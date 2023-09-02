// Defines a staging table for GL entries

table 99100 "GL Import Staging"
{
    Caption = 'GL Import Staging';

    fields
    {
        field(1; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(3; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(4; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(5; "Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
        }
        field(6; "Description"; Text[100])
        {
            Caption = 'Entry Description';
            DataClassification = CustomerContent;
        }
        field(7; "Amount"; Decimal)
        {
            DecimalPlaces = 2;
            Caption = 'Entry Amount';
            DataClassification = CustomerContent;
        }
        field(8; "Dimension 1"; Code[20])
        {
            Caption = 'Dimension 1';
            DataClassification = CustomerContent;
        }
        field(9; "Dimension 2"; Code[20])
        {
            Caption = 'Dimension 2';
            DataClassification = CustomerContent;
        }
        field(10; "Dimension 3"; Code[20])
        {
            Caption = 'Dimension 3';
            DataClassification = CustomerContent;
        }
        field(11; "Dimension 4"; Code[20])
        {
            Caption = 'Dimension 4';
            DataClassification = CustomerContent;
        }
        field(12; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            DataClassification = CustomerContent;
        }
        field(13; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
        }
        field(14; "Line No."; Integer)
        {
            Caption = 'Journal Line No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Journal Batch Name", "Line No.")
        {
        }
    }
}