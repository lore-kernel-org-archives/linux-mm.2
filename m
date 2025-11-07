Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C21F0CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 02:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1EF8E000C; Thu,  6 Nov 2025 21:00:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7DA8E0002; Thu,  6 Nov 2025 21:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C4D8E000C; Thu,  6 Nov 2025 21:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ECECF8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:00:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E6E7884D9
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:00:07 +0000 (UTC)
X-FDA: 84082155654.06.B8DEFB7
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010052.outbound.protection.outlook.com [52.101.201.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id AEBEB180006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:00:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZocmPT6T;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762480804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPwUkU7pcYTWVxD9v1WHMxXTifpzZNgIJedB+SeDOfA=;
	b=R2L1gmczicEW3qHWlc5tCsaXt4g8whXgCgyAUOI/dy2VCGLvnan/djl7+VCkSYeP4haEWp
	6VATvCky4Esmw1tzRHhj7Zbr1+/RcWj7LKdb9seG8Y7PCO/XWqN9etC5+vw2Q75sM7ygnx
	BrfhBYmgoOmyYYVHKV4vo4VRaEnO9+g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762480804; a=rsa-sha256;
	cv=pass;
	b=0/NusXcuDG4OhtjHMlzYJv5qGdapyVOVhZHKPTF2Py/akNfpt0Sor9DLPsLapFEs7+Jub7
	k04ZOh/GahvIIU3PM7oDkNQIOcV2p3uiK+m6uDnb7GuUkLccYF/d6DFgAoSIE4NJs39Pno
	tQYPf5UOMJY1bKLEVhu+QINCYq+Fwqk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZocmPT6T;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y8BeX9+ikzHAJ8+WpLpApvEQfd/6D+w2ERbxMVH2pAmLV7/ItDSHhJVNf/pZreB15jdWOF/FeMFDYwGHr0Tk/i21T9ugDHjaP3Oolhi2sdQXDWZMbuBOhQGKP8hy7LOBd6O9JxZj7VgV6YyZQjNT+zG5KN6jtnuQXGvDO5rfw8JsmfhKkbxgWcMgRducdtVwslc2dqYp7Q5pfYG40KHT16CTfEL2ypnY/yOY6RT2lXLYa7Z+ipojtqdm183S1AX4EZODsbWWPcs9aTcFxlPBdBW/8Tkc9sM7Aa3EFhY0OCfntAUfuZwWFvFvTTw9MByz01+LE+qR07DwfaQO5fe5qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPwUkU7pcYTWVxD9v1WHMxXTifpzZNgIJedB+SeDOfA=;
 b=ZaSOunhxsOy3RIuacpaMniBxd1J45Xi3K+OYJ3u4PwXb3dfWS2Qr0mPqaKWhZOXKtldOub/lKXNE8eCmzsvUa3X22Np5wORuYYGAsEilca4QKHKdl1i3XCLU48WJGJcJDpIHQFRpFaRqe90ULgAde0C5jjSUo1miu35LLKkj7AB1PJRERBEN0w7CAlxpG/johfr7L5LkfN/0AIvyqCDJdQ+SETCRZo0yhF8VSrOaI29XPcIFqfrDOzPXY68gFXVwQPwV2lFOavqQFFNaGpvaFNDkYy9f6NGr7saEoOeCQc89zwxYFuluieEJRmxovm2OY2j31CGmk/J9qR/z/fSmWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPwUkU7pcYTWVxD9v1WHMxXTifpzZNgIJedB+SeDOfA=;
 b=ZocmPT6Td6kFcmXMe+RLwTpAe0h3siViCkLEY5Oa2bQb/8e4JQKEa1CI3Tb4xIZAFUAR0pU6jXY3YLP6ZRc0d9F4/F/wwlMXEW2BffkiVSV0g1gVWmDmOm0dWH3Y4O/TmQGRoX0t2WVHlAqh5LyaWpkKfA54BxWNb+fmIgEXYVpWKJtdgh5udtIjTyDGZVwIApwPZsg/9Ie9yfQTrzoxsJznLDIr6IGzWamxKQxbQb/YMBxFlLTCsAfGNhAXwT7g5oSwZR1GihGim8kWVht3qO+Pt+CFcCH/8taUljL2olqjh+3D3Ne5AIfIn3yKdOtDxqdWp0Fi9F1rcGGH1b1/qw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB8697.namprd12.prod.outlook.com (2603:10b6:806:385::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 01:59:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 01:59:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] mm/huge_memory: Modularize and simplify folio
 splitting paths
Date: Thu, 06 Nov 2025 20:59:44 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <4E3F155A-CA9A-4BAB-AC72-523478A0F513@nvidia.com>
In-Reply-To: <20251107010201.vasfacufmvza6xzm@master>
References: <20251101002927.2610-1-richard.weiyang@gmail.com>
 <20251107010201.vasfacufmvza6xzm@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:208:256::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB8697:EE_
X-MS-Office365-Filtering-Correlation-Id: b2cc66a1-365d-4aa2-7adb-08de1da153dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?czkwaDRtSlZIajVhcjRqeW1xT3dJc0dXVUl5VG5KZG1yY0ZCdGJGMWdQTFFh?=
 =?utf-8?B?cWlqdUhET1ZVZ3I3VXBjbmQ2eFJGUXBVMUdQSXdGSk1OQ1YyTTUvSEJZVW5S?=
 =?utf-8?B?Z1k0OERDZUxQZUVGY0Vxemp4SHBHb005SURxYzh5UlNFZHJJNWs4UGpNeXd0?=
 =?utf-8?B?c1IxanFPaUovU2o5cFo4aWlJbEltWHVzdnlOVStWbDFLSWhwWnd4RXZKQ3JD?=
 =?utf-8?B?NTJKRElZeWxsUG9RVTVLNmhJV25xeXBZeDQwRXZGZ1gya0pUOHlHc2cwQmpM?=
 =?utf-8?B?czkxQnJ3bmVFb1B1S1A4blNyYzB4OEhWdmdOd2F0bmhzc2c1clJMK0k3ZjMw?=
 =?utf-8?B?bG15U3JZU3hacy9ocUsvdkFqOCtCTHEvTC9PdUJBM1hSMjRrK3YrbzEzQzgz?=
 =?utf-8?B?djdSYTNJVjVZVU96d1RLUjFrZW5Cb2xEK1BYZVU5TXhVL0FLVlFzQ29EUUpz?=
 =?utf-8?B?d3FXdVlUcEk5bzI4c0dCSWVTRDBSeVRrNFpaWVVQK29oNkxScjd3ZTJJQXhy?=
 =?utf-8?B?aXg4U213ZXRoNXZsNlhUMzJUeTJ5VDFzQzFzNkVFTnppNzFTRWhBT1ZsMzhG?=
 =?utf-8?B?OGlHRDNMMFNjNS9xNVg4QmtKSDFlcUx3S0wwTWxMVUFQV1JjVmJxS2Q4eEpI?=
 =?utf-8?B?ZUtickZvWjcwWEtuZDA0VkVhS3lURjdBenJoQTF3Q2FiS2Z0UitXK0Myc1hD?=
 =?utf-8?B?S0lJL3cyUkpkenRFeDdDRnkyRHdUOTNWeDM3Z2pTU3grVmdmTzV4dXBUNjkx?=
 =?utf-8?B?emVKQ3AwREJIaHY2ODBqenU0QzJML0ZMbFQxMnRUSmNZUDJKTjFGR1Bzdnh6?=
 =?utf-8?B?b2g4Ukp6NWlZVWJ3cnlXZkt2cUNpSnZQNFNsRHd3MzEyQU01VjU3aGRUY3Rh?=
 =?utf-8?B?aXY0WDZ4YjJhQVM2bXV5Q0N6SG5aYzNXYTYvRnZJUGpFU3UzV2VtcURFUmxz?=
 =?utf-8?B?dnY5ZHlyYXNJQnNPdlhHSnJ3SERpSFVZbkZBZy81VDZmM292OEVnMFl2aHo4?=
 =?utf-8?B?eTlxZHl3TFI2cGxsSDhoNzhKL0ZIUmNGd2d2QmhHY2tvemYvZkhyT29OVW4y?=
 =?utf-8?B?dG9jY01QV1lwY0I4Nk02RWpkRnlheE5MZTJQczJkMVNlZ1M3ZmlLYVJIYkYv?=
 =?utf-8?B?TE1XZ00wMDRXNUdHWTd6eEY5eFQzL0FzV0ltb0p2eHFHV21OL0hFSTFaY214?=
 =?utf-8?B?eVU0aTBYM0R2TlFFbm82UGZJTllFUWgwUldtY0VaZHhqd0Z1MXJ5LzlxTmhB?=
 =?utf-8?B?RGE3SjJMY2pVZjEwbk5KaW1CRU4rTjYwR1RGbnd0Ui9walAwbmx5WWVKUDhB?=
 =?utf-8?B?UG8xaU84NGFQQjhOODB1eWRSOVZWRkhqMzJWL3NxWEZLR2tWY044VUpjYnR4?=
 =?utf-8?B?TmNLQ2p3L1ZOTzlUdFFyMitmQkVYQVg4dXdvRzQ0V0RKUjdtMjIvbllaOHNo?=
 =?utf-8?B?eUJnb0tHbEwwQjBYelRvNytpU1VQVlduTnBEbFRlaW1EMS9WSHR4MXNwME4y?=
 =?utf-8?B?NjhSNjVXSVozUGxxRVFZdEJVL2oxWnVXalZsUU0vdERENnlYWGZkbW9vdTJ6?=
 =?utf-8?B?dXU0d3FMdzVRRjI1NjZwQ0liYjN1emd1dWxGYjJhQ05xZzFQNXhZeDcyZTY2?=
 =?utf-8?B?ZHp0b21mWkpiYXFtNkJPTXRnMHN0UHpDSS9QWE5IYUVJMi94SWtsaE0vRWJC?=
 =?utf-8?B?MGxObVBPajM5YWJuYTdjc0pVbmZUbW50bU0zbTdEbUFXQnlWT25JaVVTTnNL?=
 =?utf-8?B?TmN2enlCbmNyWGovZVZhSmU5bjdDbXk1TmcyUlpBUy9xQWh5NE53WnAxTjZ4?=
 =?utf-8?B?V3BiYzIyd21mVXczVm9EcGxtbHhuQXJuQi95L3VxWDFUR2JGNCttS3RRYzJs?=
 =?utf-8?B?SXNKdDJGUk5pZjhyVW1JZW14T1pTaC9OL0w0bmovendQTHlCNlh2UWtIMmxT?=
 =?utf-8?B?MTRqTWMzbFVkQWxqOGVsTmRTTWVIbmVrZStaNWFnRng5N0wrWGJqU3pEOFE2?=
 =?utf-8?B?TXdFWUxHK1h3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MldFWkI1eEI5Nld2eStyT3Y3dFp2RU1OT25TUXBRRkxLYit3S051a2hWNmU4?=
 =?utf-8?B?Qm9STFhjbE83UGw3aVZET3BBY2ZwOS9GaTdhZnRSd2ZEVGd4c3cwd2RYZEhH?=
 =?utf-8?B?Y3p6M0JJTFQ4TDBVSnJGbUF5UXJPT0JrRjJTUHkwYnlta0JybEFuZnFsVzJn?=
 =?utf-8?B?SjhidzFGbjk2c1g3cWFTYmkvYkNXbEtjWm5OZVNiK3ZWODhSOUJOc2pDMVRM?=
 =?utf-8?B?Qk1vUDNMcXZ5UE5nL3d4NnBwMkRpMXBEaTVJa3pLcy84WW9IS0FpS0VDT05z?=
 =?utf-8?B?VVBkNWZ6M0hTMjRhRDFhWlN6RWczUTFrYXNBQUdoUkRGc2txUW9YRmVvS2Rq?=
 =?utf-8?B?S21nbjg4eUl0blN2MzZadEg1QVY4anRJYjBqdWhDSGVQVm40MGNESk00VDh6?=
 =?utf-8?B?RllEUUVMS2d5YndpaExXUkx6MFhQeGNDUUlrTUpaR0Z4OHNHL3hlMEVDZlhO?=
 =?utf-8?B?am96c0p4Mkl1N2IrWGlNNDJQc3RhVTRkbFVra0JVYkVSMmRvZjBhYzA4Nnpw?=
 =?utf-8?B?U2dURENobFRZTHZ2VVo4L0RXZkdCUGtVWnRIMlgyeTdYUW03SWVKRS9hRFo3?=
 =?utf-8?B?LzdLZnVmdkRrOXFiWnZaaWtNdXBDRnlaNTI3S1BzRFNXY2Jub3Axc3VueEpK?=
 =?utf-8?B?a3MzazlQM09RQ2d3ZUhyWVpsM0tnaXhKdjdGbGlPaS9lU01iejJsaHE2R0I5?=
 =?utf-8?B?SXhHenJpbjVIa01uVGlDMFhiK1B4bldVS2lZM1ZSUkg1SU9hSE5IWDBIeDRP?=
 =?utf-8?B?azBUQW0rNE1ZcHJTSlJDNzBJZEYzZDVBb213NU0zcEJYMXhSWmdrbVl2VTk4?=
 =?utf-8?B?b1I1cWxZSmgzVGIyeGV2RXBUZWxmNUZibG9xUnlzWmtCUVNTOXBGODJwdDlI?=
 =?utf-8?B?M0dIRlVPS2lKcmxDS2VSbVBzUXlZNk5RaitnT1dZbzVubWdnYTYxQTREMitv?=
 =?utf-8?B?dnN1L3RqS25MN1RycUs5Vm0vTmtCSkRIMnpnZXlvc2QraFlCN29pbUZIU1ow?=
 =?utf-8?B?L3BYTHQ4WFJCeUt6UGVtcWtHZUhtSDg3OGh6RHJOYmdJNXdZZWM0YkVoRnFH?=
 =?utf-8?B?cGI3OXBaV3g1TnBKQUxScGZneUlEcnhXa05mOFlzU0xnbyswT0RqaER0cGg0?=
 =?utf-8?B?VmUwK0ZkSWJ1V0JXNHZTQW55Q3V5a2t1eE0rK3ViKy9hZUJGQld2ZVpyaTBM?=
 =?utf-8?B?Z00zRmJUZnliYTlSSFBEQklTMGFZbW5qNlRWRW13QndKTjQ2ZytqZlVSbDhX?=
 =?utf-8?B?NVRYOVFFSzA4YmJyYVExQkNObTdoN3g1eWVxcndzcGdzZzRvTkxza1hQQkNz?=
 =?utf-8?B?NE4xcXhhYzFORmU3dHFwbjgvSEVxcnRrSHNYV1MrL0JoeVRvWW1pd0o5ZWp6?=
 =?utf-8?B?VTZnY1QrSTJlcmJwamZsa3lOU21Cb05UVTV6Wk45K0dDTUV0d0JCU3A1YUVv?=
 =?utf-8?B?Mit3K1FtVTJJdlRiWW9WSU9SUlIrd0FSaWVYU1F1bzhqbm5GV0drbTk1V3E4?=
 =?utf-8?B?d3p3ZHd0RlJpNUhaQm5UYjM4Vi84ZGpKN0RIMlRVQVR6U1lGODZ5YmkzRHli?=
 =?utf-8?B?L0dkK2NUSUd6bm9EVUlUeHBsMkF3UUZtL2p3N01QbGFsUGJwVXdBQjA1M2tP?=
 =?utf-8?B?NmsyZzc0TzkwQ1ZEVjVYM1RVTmk0UmxlQytGSk5ITDVob0tVOXVDbE9hWldt?=
 =?utf-8?B?Tnhuc1EvVjFVWnFiL0hLSHRSc1RhMTVQSG1FYmQ5b3RQWUNjYmk2MVpTRCt1?=
 =?utf-8?B?SGt2cHRzRC9JWCtTTjhUTXhLd29zdU1lVnNxU1hldFJ3Z0FKVkY4R1VEeFRr?=
 =?utf-8?B?WnFMVFhwLzVwTi9zUTdhM3FWSEFDdjV0TmJ2bG80MHRRdEQ4M0dRdUk4N2dQ?=
 =?utf-8?B?clFQVVA1UnNXZExQOW9yR3JJb3Y2OFJRRXM0TkgrYml2VTBoV2g1OHYyYWt2?=
 =?utf-8?B?VEtPWXBYdWh2b25yNE1Ib0wwTEwyMWVqamFmTXluOEtra05oY09hZHhuTXJz?=
 =?utf-8?B?dGlZK3BSNFhmTWZnbHRPbFVDNHpFb0xreEFCTzFFWHl0M1NMZDR1VUV6Mmxr?=
 =?utf-8?B?TUJoZ3lUWitnbmFRS2tEWHVKYXB3VHdvSGlIcDZwR1AyQ1RhbGx1YVVYaitx?=
 =?utf-8?Q?wLZJR0G48oOeN2fCf/7MjTz93?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2cc66a1-365d-4aa2-7adb-08de1da153dd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 01:59:46.9138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IFbOU7JY9Vy9sPmDKxM5f4fcWOKExVLdvHnIg4Pu3sHaV2pWYTPWZi76vXBzh2BU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8697
X-Stat-Signature: nrrbyyqzxkmqqsysqtmodqcdoxtfs3g4
X-Rspam-User: 
X-Rspamd-Queue-Id: AEBEB180006
X-Rspamd-Server: rspam01
X-HE-Tag: 1762480804-714182
X-HE-Meta: U2FsdGVkX1/E9ecNgCAzZM7I4/XPCMnOSdVCdwpzEQdBzc6BQhrpMaQYKredGd3/d6iT7P4siT5A+x/J5mh6tcAgTdGl3klCtsdUWOOYNBBsFfXiPIV98VoqV5opYbK/FoPk9msRHghMX2jLH44ioU2jmmEJxZyehf3oHkM5eGP5rSRSjPahhZMPR1ZwTDZbqT/7pTgdqK9B5VIP03GZ7kTVSZz9iOPhlq8bKv9RHBZTqJZjCCL7HMfsarmov8aHoeVFUECiqqm9M1LLFwY5ZHWuly6vadZhyx1etgH7yhpgc9PvyVkPIY2Orv82OD1MN0O37SkltlNwC7UHi1MsRZ/hxC/+DFUElm4Uvv3aUaTCe0CIu911B1zR9ANJmURU1uFclK8jxYM7d6tjP33+coqnPdvwO/r5IetKW96XM304/ftnNgybAstepo+8XT2VeEvHdRU+5z640hkmildW1j5cosINdFA7DxRSTAtE8mu04CerGLcbO7kH4OCQPKAK7LjAUYJfULUKcxUjClMiUU+G5shzxIxiElojQFFLdL8/zfdopcc2kmgyMJCQNpv18yocsjW6BNJUbNGjmO0GUe2rXaWh0syn32GBaR1nNTaxZuc66i3M5ugceCv8s898iGpBmKxWfDd2uJUE10CBnde8wq4ZhzytGihXBZ3vyDphrxGcd0sN2JlvPES6vS1Vl9cSvfb4u9deobeyzg2kZhbQiyrjy/2IRtZ3P/XQiTZCAIIjSjURwPRhyZ040fUcpFdvptnok4ttpwm8M3cGMkJOlxZRd8AUUO8Nx7fU7jI7Q2HzQdO+KzD6h6KqiE7T7xWo6yUG5uenDOR/AtKnXUvzkSVIBHujSFOl5OOFNbyYeE6rUw/7XcXVPoXm5idFg5U21FZ0VcHM27AtMJMcgm8kZgtccWgdsfOcxkBPzgJUT7arOdIlNCyCzPZhNLlo7GIiGhIHDtxSB8zjdmV
 iyJlhm5o
 G6ClENAlW23JVG4hp+vd3FFeVKhqzsFXQ+vdPdcNCGyztOleX8DZeoLGVpsGceZ5hqwVPBdJxoOOQE3X6D3vfvshg3/+/Uka9qmcdNukGrfjlVV7x9i1StmLtR7yX+leBAGvwXwQvFBcyzD1y/dx+bKJnTLl1am1Ae1WGBGAIx/wtFds6NCloVA7m1jb6fx0l9NXqzdbhOHDiReuXzFWMpTnVX1wYdfIm6o0fSdqB4UUAqxTCF9D7XcO4ZDMnbqXc9SOWV5DiVuWj4UaYDvV+UGdkkRrsrxouGFZXbBOTSOM8OgTyxHTdCszl9UkULspGnTcGBYSfb1A6EJZmk5V1eRD16+16YJRKWJg/Klxfk8pY9mOGSj59r4eWz0aKCiSmrwKuR09BeuIIEZVB3DV0SkarC+RkyQba+dHzmWHbdMQR7JW7XrRavsOzu9r8nL7bwIM/Y5sTKmI79v8JXWqt3og6sApJDirjYDWSlXJ4P5Gf0rOoS5Ne9pbazcCGdY8bIexJbhVP5GpLn/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Nov 2025, at 20:02, Wei Yang wrote:

> On Sat, Nov 01, 2025 at 12:29:25AM +0000, Wei Yang wrote:
>> This two-patch series focuses on refactoring the core logic of folio
>> splitting to improve code structure, clarity, and maintainability.
>>
>> The first patch introduces a new consolidated helper function that group=
s
>> all the required tasks involved in a folio split. The second patch then
>> leverages this new helper to clearly separate the different execution
>> paths for uniform and non-uniform splitting, which simplifies
>> __split_unmapped_folio().
>>
>> This series sets a better foundation for future optimizations and
>> maintenance in the huge memory handling code.
>>
>> Also selftests/split_huge_page_test pass.
>
> Hi, Lorenzo , Zi
>
> This patch set is based on your suggestion from [1].
>
> Not sure you still like it?
>
> [1]: http://lkml.kernel.org/r/f1830e4e-1630-4242-be0d-1cf65f20b54b@lucife=
r.local
>

Can you address David=E2=80=99s concern and update the patches?
I will take a look then.

Thanks.

>>
>> Wei Yang (2):
>>  mm/huge_memory: introduce __split_folio_and_update_stats() to
>>    consolidate split task
>>  mm/huge_memory: separate uniform/non uniform split logic in
>>    __split_unmapped_folio()
>>
>> mm/huge_memory.c | 59 +++++++++++++++++++++++++++---------------------
>> 1 file changed, 33 insertions(+), 26 deletions(-)
>>
>> --=20
>> 2.34.1
>
> --=20
> Wei Yang
> Help you, Help me


Best Regards,
Yan, Zi

