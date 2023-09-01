// Defines the page and action for importing and integrating to the GL

// Usage:
// 0. Row numbers must be in the file. Recommend incrementing by 100.
// 1. Create all of the needed batches in BC. If they exist, batches must be empty.
// 2. Navigate to the GL Import Staging Page.
// 3. Import.
// 4. Integrate to the GL.
// 5. Validate.
// 6. Post.

// BIG BUG
//(fixed???) The date gets decremented, that's really bad
// Need to add dimension set id

// Smaller bug
// The records will get pushed to the GL table if the batch doesn't exist. Creating the batch
// makes it magically appear. Be sure to follow step 1 above.

// Current capabilities
// Truncate External Document No to 35 characters
// Truncate Description to 100 characters
// Map to MEM Entity Id

// Possible enhancements:
// Add validation for GL accounts
// Add validation for dimension values existing, based on the General Ledger Setup
// Verify transactions balance by doc # by date
// Verify there are not $0 amounts (or maybe just skip them)
// Create an action to generate the batches and check for them to be empty
// Provide record count progress in the UI

page 99100 "GL Import Staging"
{
    AutoSplitKey = true;
    Caption = 'GL Import Staging';
    DelayedInsert = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "GL Import Staging";
    SourceTableView = sorting("Journal Batch Name", "Line No.");
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Dimension 1"; Rec."Dimension 1")
                {
                    ApplicationArea = All;
                }
                field("Dimension 2"; Rec."Dimension 2")
                {
                    ApplicationArea = All;
                }
                field("Dimension 3"; Rec."Dimension 3")
                {
                    ApplicationArea = All;
                }
                field("Dimension 4"; Rec."Dimension 4")
                {
                    ApplicationArea = All;
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Import")
            {
                Caption = '&Import';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Import data from excel.';

                trigger OnAction()
                var
                begin
                    // if BatchName = '' then
                    //     Error(BatchISBlankMsg);
                    ReadExcelSheet();
                    ImportExcelData();
                end;
            }

            action("&Integrate")
            {
                Caption = '&Integrate';
                Image = ImportDatabase;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Integrate data to GL table.';

                trigger OnAction()
                begin
                    IntegrateToGL();
                end;
            }

        }
    }

    var
        // BatchName: Code[10];
        FileName: Text[100];
        SheetName: Text[100];

        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        BatchISBlankMsg: Label 'Batch name is blank';
        ExcelImportSucess: Label 'Excel is successfully imported.';

    local procedure IntegrateToGL()
    var
        GenJrnlLine: Record "Gen. Journal Line";
        GLImportStaging: Record "GL Import Staging";
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimensionManagement: Codeunit DimensionManagement;
        NewDimSetId: integer;
        RowNo: Integer;
        MaxRowNo: Integer;
    begin
        RowNo := 0;
        MaxRowNo := 0;

        GLImportStaging.Reset();
        if GLImportStaging.FindLast() then begin
            MaxRowNo := GLImportStaging."Line No.";
        end;

        // for RowNo := 1 to MaxRowNo do
        if GLImportStaging.Find('-') then begin
            GenJrnlLine.LockTable();

            // RowNo := GLImportStaging."Line No.";

            repeat
                GenJrnlLine.Init();

                GenJrnlLine."Posting Date" := GLImportStaging."Posting Date";
                GenJrnlLine."Document No." := GLImportStaging."Document No.";
                GenJrnlLine."External Document No." := GLImportStaging."Document No.";
                GenJrnlLine."Account Type" := GLImportStaging."Account Type";
                GenJrnlLine."Account No." := GLImportStaging."Account No.";
                GenJrnlLine.Description := GLImportStaging.Description;
                GenJrnlLine.Amount := GLImportStaging.Amount;
                GenJrnlLine.BssiEntityID := GLImportStaging."Dimension 1";
                GenJrnlLine."Journal Template Name" := GLImportStaging."Journal Template Name";
                GenJrnlLine."Journal Batch Name" := GLImportStaging."Journal Batch Name";
                GenJrnlLine."Line No." := GLImportStaging."Line No.";

                // TempDimensionSetEntry.Init();
                // TempDimensionSetEntry.Validate("Dimension Code", 'ENTITY');
                // TempDimensionSetEntry.Validate("Dimension Value Code", GLImportStaging."Dimension 1");
                // TempDimensionSetEntry.Insert(true);

                // if (GLImportStaging."Dimension 2" <> '') then begin
                //     TempDimensionSetEntry.Validate("Dimension Code", 'BUSINESS');
                //     TempDimensionSetEntry.Validate("Dimension Value Code", GLImportStaging."Dimension 2");
                //     TempDimensionSetEntry.Insert(true);
                // end;

                // if (GLImportStaging."Dimension 3" <> '') then begin
                //     TempDimensionSetEntry.Validate("Dimension Code", 'REINSURACE');
                //     TempDimensionSetEntry.Validate("Dimension Value Code", GLImportStaging."Dimension 3");
                //     TempDimensionSetEntry.Insert(true);
                // end;

                // if (GLImportStaging."Dimension 4" <> '') then begin
                //     TempDimensionSetEntry.Validate("Dimension Code", 'MISC');
                //     TempDimensionSetEntry.Validate("Dimension Value Code", GLImportStaging."Dimension 4");
                //     TempDimensionSetEntry.Insert(true);
                // end;

                // NewDimSetId := DimensionManagement.GetDimensionSetID(TempDimensionSetEntry);
                // if NewDimSetId <> 0 then begin
                //     GenJrnlLine."Dimension Set ID" := NewDimSetId;
                // end;

                if (GenJrnlLine.Insert()) then begin
                    GLImportStaging.Delete()
                end;

            until (GLImportStaging.Next = 0)
        end;
        Commit();
    end;

    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.SetReadDateTimeInUtcDate(true);
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        GLImportStaging: Record "GL Import Staging";
        PostingDate: DateTime;
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        //LineNo := 0;
        GLImportStaging.Reset();
        if GLImportStaging.FindLast() then
            LineNo := GLImportStaging."Line No.";
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            GLImportStaging.Init();
            Evaluate(PostingDate, GetValueAtCell(RowNo, 1));
            GLImportStaging."Posting Date" := DT2Date(PostingDate);
            //Column 2 is Document Type; at this time we don't care about it
            Evaluate(GLImportStaging."Document No.", GetValueAtCell(RowNo, 3));
            Evaluate(GLImportStaging."External Document No.", Format(GetValueAtCell(RowNo, 4), -35));
            Evaluate(GLImportStaging."Account Type", GetValueAtCell(RowNo, 5));
            Evaluate(GLImportStaging."Account No.", GetValueAtCell(RowNo, 6));
            Evaluate(GLImportStaging.Description, Format(GetValueAtCell(RowNo, 7), -100));
            Evaluate(GLImportStaging.Amount, GetValueAtCell(RowNo, 8));
            //Column 9 is the MEM Entity; ignoring this for now
            Evaluate(GLImportStaging."Dimension 1", GetValueAtCell(RowNo, 10));
            Evaluate(GLImportStaging."Dimension 2", GetValueAtCell(RowNo, 11));
            Evaluate(GLImportStaging."Dimension 3", GetValueAtCell(RowNo, 12));
            Evaluate(GLImportStaging."Dimension 4", GetValueAtCell(RowNo, 13));
            Evaluate(GLImportStaging."Journal Template Name", GetValueAtCell(RowNo, 14));
            Evaluate(GLImportStaging."Journal Batch Name", GetValueAtCell(RowNo, 15));
            Evaluate(GLImportStaging."Line No.", GetValueAtCell(RowNo, 16));
            GLImportStaging.Insert();

        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}