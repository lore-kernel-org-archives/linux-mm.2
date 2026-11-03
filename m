Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08D5606A338
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Z3s3HzrU
Received: by kanga.kvack.org (Postfix)
	id C0E6B6B05B8; Mon,  2 Nov 2026 22:45:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6756B05B9; Mon,  2 Nov 2026 22:45:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB496B05BA; Mon,  2 Nov 2026 22:45:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 792EC6B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:45:22 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E14431A0246
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:45:21 +0000 (UTC)
X-FDA: 85392417642.02.B9FDA1D
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012060.outbound.protection.outlook.com [40.107.209.60])
	by imf16.hostedemail.com (Postfix) with ESMTP id 06288180009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:45:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Z3s3HzrU;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793677519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vyGB45prwHE+IqhIs2DAboNFGgxXM965eELk7LfDYFo=;
	b=chfTqwsr8nBh5j6XEFfkwW/Y+tjD0ZOzLLtxH5lvCO5T+uMU7Ln7i2KezZIw/GHoNyagTP
	rkm8c7Q78ckqjbXlcBIHsoCSMptQbOy2/BehYrrodaE1lCnhy6G/OJsgFP6NzvrmOoSG+h
	ivTg6912ZN65fjWVBIx0BIwSu9fHk0s=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793677519;
	b=FkSy4Ed+P/yfZ6Oqz15rp/X9VQKXd54Lh6CpOYU9W41wzJf8cs0fnIv0YfkdY0znKeJbk4
	wvnOUI/bK2zOfAvY40Yko8hEKpK6EFa/IaTX/3WR0geeKnTwCLoUt3Ee/6VYF+1ARl4YUx
	Wq9i4PZ+94khbLKzSYb1S5BdE4JUuW8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Z3s3HzrU;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CUZ11TZTCulOswkfYEEomB/Rn1ElNYhQJKAB8F4fc+YFb/8rXEi5ITCzTZlk5z/iCwytRWg2EOegtQSlmBz7Eagcpr1usInpDmcjyNtSChlbL5Uw5HmX3yTvucM6maO8Jgn7jP6vzI/9PZAdgoCrXY1ZyJCs7d4CE1R6vH5imnDQNqjTOi1e1pU0cPTVtpLXgoSPw/r2736zXlhd95uj8CWLHr88t+qHUiSa3JN4t5cY8OLFuPEtnO1kTSOffmKvPux49ipLUlEVsVcuhot3O/BySbm/8Yy25nEi+BmJMpZs0QiiQXKr8ERRQGp1+InYUCsUUhURBzPeMCVeyyu8nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vyGB45prwHE+IqhIs2DAboNFGgxXM965eELk7LfDYFo=;
 b=HKx8FG4IvAaoUcMGHxqIRJ3Jgj3bs5K47fT80ndr9oqcbmnCEL5iCgzMwyCGgeWPnMIOXepBTAW8znuP+sjEPTvYrQK/xsFJ+PliwiMZKWL/VXYbHaDCQ1NcMxx+bDwnxZKLRM43Vfl78xeIxCSrHUsrfH8gTguA02/SOcx+/Jjm5hcRXd/VTVVvtR0yXoNRgI1lQvt7AmBbCJvCYL6QU9K+4DgscgnhPrn3+7DlgKIAI6AZLbNoAqNiMW4Be/y0EFHBfPVElmQPPEUqQ8ppGzp6C/Z7L9KDMXc6xqNF35p9cDg0QGPBITHd5IzsE5k3D+l5OzWTUX2Dn0RwU3G/Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vyGB45prwHE+IqhIs2DAboNFGgxXM965eELk7LfDYFo=;
 b=Z3s3HzrUH0mINae4fFhyYIDcZ9Kaw6EreAvkmzgKWedLx7cmS3PACuf0K/yRPSj+QdezXstylDERcZlsMvCbAnEcUP3cbvHCAoZ3pEzVt+ueExnctOH3Ayfxj/LA8PH/cikr45ZACYU5kQjwsCuCjL4sdBM1IKS9mSK3qlCCMlLQCxT6kVRazb3mlFR+uVM3IGmMSV5bn20waOMzHVYhUYhPTF4ev8Du3ZapT9MDh+3dllAhVyQ0KMH2lXIFKYnbxLHHWySSdVNfEXYJT4qCAOLgayJKt0o9lVgeyCmZbh/13fc6hwH2JgC5SciMBW9iX1nXlLf0fm87lNtX2884kQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB5890.namprd12.prod.outlook.com (2603:10b6:8:66::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Tue, 3 Nov
 2026 03:45:13 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 03:45:13 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 22:45:10 -0500
Message-Id: <DML9M0YCK0WK.1TEXBKALZLTRB@nvidia.com>
Subject: Re: [PATCH 5/8] mm: remove find_get_page_flags()
Cc: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Tal Zussman" <tz2294@columbia.edu>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Jason Gunthorpe" <jgg@ziepe.ca>,
 "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Hugh
 Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-5-e7280bdb31f6@columbia.edu>
In-Reply-To: <20261102-page-wrappers-v1-5-e7280bdb31f6@columbia.edu>
X-ClientProxiedBy: YQBPR0101CA0116.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: f866791a-ed1a-4241-4fc4-08df395cddc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|18002099003|22082099003|921020|10067099003|4143699003|11063799006|261022075727099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	D/O+hz0E0JlCldWhEV+qVe0AW5El1Wc/WMKIfDOSL7REwz2tZ/9JXhVA7ofFKtJRgDkKtpVxjOWqQLfx+EAOfN/o08b3h7VrJ3yO6hlGhYWjNFpkOHraxjPfdQ/X7WHX4/hGvpd5q78SezEm7EUGm1nuESlorhLeYDXuNoEnv/BpvlxA2CgswccpW4Yoqw0LNJb+Ak8Wi5SvyusTZqCDZT4OoEUTudb0v0sNbd+IsszaAnQDD7PLeq4Gbw8/XxbiniKPvA6PfmrHz5p/mxQrE4hMjg47znMzEAQkOh2eElACPIz/RcMGQgNeK0rQHEawl5tlhPjmEPn1hyTLot00UXKkdKE6742BgnikQXhf4l1BHBpxaI9ZiQO7Gk95DELPiEURXaCfXjUgeNVRdm9QVNepe5jr0f0QKPbBYaVuQOnq5ee0hFY//IjOxZQusL3BbJ9bvMxzRXX7HBQpOaPYktaNld+sGrgmjcbN0yOrjSqEJQrJxW5cp5V7Ld214LfyqUDNdihfoGaB2g4GJuk4OL6L2Tme4J0r54kDQivc4ynPe5ixq+S49aHLzFsiIT83aWw9SpstcpCfilJpbNm5eC5P+Yz+306a5EAKLzYXalN5CNRTwI0/Ujpd8YEdVIvHIMl28SUpvczz5g1Bh3upZxN0PtaTSoVexGcEl69QZPlJfHfRG95vsetQNWguASLHe1pnp3ZsUccaoDk2uQbAyg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(921020)(10067099003)(4143699003)(11063799006)(261022075727099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVZzbTMzUjZSeVppdGVEc282TWVjeUwrZ251TEw2cU9PbS9WYnlLT0RrRHBa?=
 =?utf-8?B?MTNpc01DYkJqOGdya1l4b1dpaGtMVFlSZ2ErRW42aE9JRG0zUFcvQ0dlekFx?=
 =?utf-8?B?OURiZWNvUDV6K29LMmlnOW1rWmRNeXRXaE5uQ0tPTlRCVDk5ZlFGTHdTY3JG?=
 =?utf-8?B?Qk0waEl4TmV5NCt5bTkxeGdsTUpQekRLVUpLNGR5R2FpSlU5WTA5bnhRdUZQ?=
 =?utf-8?B?c1VRRkhUaGFOTFk3TmE3akxHQXpvM1E4d2N0YUd0cldRWFBJSktWU2s4S2ZL?=
 =?utf-8?B?TWN1TkJ6dHMrNnh6aUpSUk5GUTdCc2J4Qy8wYVBOQ0wya2diTmVGSkF1ZCsw?=
 =?utf-8?B?Y3Y5eEhsa2hQWWZkQ0hvK2cydXdzNzJNaGNUWFRXZFRPL3R1VmZSS3d2ejd6?=
 =?utf-8?B?MGt3aTUyTkRjTTJNN2M1a09xT1p1Vkg3MFdRSTBwNy9GRVJXRFFqWGJiWnNq?=
 =?utf-8?B?NENhWlVwNllaQzg2RVJSOCtzRDU2OHEvT2lXclR3VmFOUkplQmhvWExYbm5W?=
 =?utf-8?B?ZkNsSDRyOXA4SEpPRWg4MTEyOWtJWXRhbWtrZGZmaGxqUWVKMXhnZWVwOFVa?=
 =?utf-8?B?WGViZFJac05FYlpGNFRFSkVNTUppcFJ6RXhYQjc1SVFROG50Vit2RzYzOU5V?=
 =?utf-8?B?SG9ZLzVQQXRxekN4TnpRWlI5WFhJRGRRVE9DOWRDSkFPdm43UEpkSGRncGVw?=
 =?utf-8?B?WjhXV3UrZkNLNHltbnVpekVGNEpwNUJUeU1EeGFKK29JTmk1TngzTUp0R0N2?=
 =?utf-8?B?Q3FjS1RDcTM3dXRjYmM1ZGpqVEd1VjVBakVhZTg2bitMK2IrNDNnRElmU3Ry?=
 =?utf-8?B?eVppYWNyUmo2ZjJyV0IycjhwRjQxcWFWYmR2eXhJT0NGZGJWOXJmWWVLd1Zm?=
 =?utf-8?B?c3ZNVjcvTWtoUlNwb0RGWWFLWUhQV0o3V1lIblEzMWd0cHRNMlN0enN2cnRp?=
 =?utf-8?B?Rkt6SXBkU2pkaXZ1alZiV2N2SFU0YmZwNjNxckVIM1RqcGRuSkY3dnBLRHhR?=
 =?utf-8?B?ZnlTWlZjdHA1VjhGQ3hhY1ZRSU4rVTgxZ1lkV0xHbnk0clNNM2hmeVJ4cGZh?=
 =?utf-8?B?ZklqQ1VPVGZNQ2ZEaU4ydUJpWi9VcnlWNmxQRGdYUWpKL1BwSGw3Vng5U3Yz?=
 =?utf-8?B?d3hOSHM4V3JmTFdvNWVlNnZvTDljeERoVlhGVElVb0pSVkFvSDk4NEx4dFcv?=
 =?utf-8?B?OGZJZXZEZzJhL1JvUitmbTZtS21hMFdCeWduUFkvVzRLNWtHYkx6RzE5d2gv?=
 =?utf-8?B?QU8xNUZQaXp0b0ZlVCt0aHRhTFQ1b1puYlJCN1kwemltTkJ3dEhaWDVibFRp?=
 =?utf-8?B?TGlWaSt0ZFNtYkVlOHdlSTZ5elRtaW5rM2I5RndZVnB1Z0dPT09GWWdLckFx?=
 =?utf-8?B?VHRGS2Vjc1B2dnRuZGtvU25UVnJvV1Z5a2xWTHhhV0Y1NGViaG1TZm5YQWNO?=
 =?utf-8?B?eTZjUjRwb3lCUXRlWk1uN1cxRmtaRXViVlRIUGhkQ25UVVRXWmNHYitWc1d3?=
 =?utf-8?B?Ny9ickRVYTl2WnU0UCtIRHdnQlgzKzdPSVJTMk5vQkNEMzY3cHAzT0M1OFFB?=
 =?utf-8?B?ZjgvQUR5TWdwZVY3RWIwd3RzOEU3T0kyVXppTkVrRWJZK3VBWVNXZVJYQ2Iw?=
 =?utf-8?B?a1gzZGNoSHA5NkhnKzdEWklpOENmd2FBTGgyZlFRVjdNbzk1emRPanV6OEg0?=
 =?utf-8?B?VStHZ3o1K3JieFdJd1QxdDFqZ1dhZWpTb0EyUkNsVXdhTy9YeDVDa0M2QVY1?=
 =?utf-8?B?cDRDdDE1dkNwSG9reWFrYXVqSkJXZDFVSGcxK0g0QjJnZ1VzOUc0Vkk2SEhj?=
 =?utf-8?B?V1ptdXdjd1dqZzdzNlhlZk1Bb25iOTNMUzEwbkNyRzFGS0R1dVZBSDBBRHBh?=
 =?utf-8?B?YjEyVFhuQ3ZlU3ZnbVhHQ1dGNWhodm5xNEFEKzkvYzZ5dWdDOWJhdWJGTEpS?=
 =?utf-8?B?MW04b2JSYytzUWI4eVU1dkd6ZU53bnNkNXNtSlJyMm9RTjJneDNrd2JPYkQ2?=
 =?utf-8?B?bVo2aktIay9FTVlIUGdENlNqQzUrWW9XejMyL2dFNzlTdlRzWjZRaDBWRk82?=
 =?utf-8?B?SWZ4YmhXS1ZsYmtFM2VvTC9KQmhrMkpGemJSeWVRdTJKS09UVTBQT3liL2k2?=
 =?utf-8?B?VHhRQ1lVdWpVZE16QVZGbXhSL1AwUmhRdThkTHJHRDlEajlENFlhTG1XOG1s?=
 =?utf-8?B?KzA5a2R0UGt3alBrMXdUMlRqZUFaVkNYeW1nV0RUMWJldEdhY3dWV3hmN0lR?=
 =?utf-8?B?SHJhWVBPODYrcGQrTDNZZUN6YjZUREg3TDRCRlJxT291MkY1OVBQMkc5c1dp?=
 =?utf-8?Q?NgxJ1zW1FLd6cBFFIr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f866791a-ed1a-4241-4fc4-08df395cddc9
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 03:45:13.3617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/qIB+MSZbSHgdejHC2XoD4f+s9wh84U1UCOuPkYeNXknMRB9Qx1DjlcGjcq0SNn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5890
X-Rspamd-Server: rspam06
X-Stat-Signature: yobnh5bpzy8ufjmf5am4meegbrgnj5c5
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 06288180009
X-Rspam-User: 
X-HE-Tag: 1793677518-686273
X-HE-Meta: U2FsdGVkX1+G4atjdFslu8g9nSDbvmG37CZZpxyMaWYdxZXZnJyeFytxuoPSmtXOW0zDfRO8Yn4RSGzVXJEpiekTRCszt/wYQy6wwe5J86sczn6m1bM2wxLmLS74HICktbaxeM9al6PSTik6xMIoQdULC/s4KGpDy/It91yVUB0NSIf0pc+Ma5f3nvVImPpC47A0N4IbqPLKnjZg0M0ELOQB8MxwZQmbjLLqoBzJlJ26daxX+HireBi1GvS3bWZOdID08ldm7A0QYgyDAKhmSAEeuJMlBV7t5uoG3o3xBYfdut6RgWtYj/iJdOvrvx794NR/FCCSFGCWEM0fMvHAMwbwt7LEk5ukM2+KitEVv6sXaLbZi4oVVcZ7jCEYfflVd2sL2RNrrasRSYgBVptwPtL05vFuMR16IlxIZmvmXchFUjMM+WNKJYHVtcK8F7QZH9lvoEnlqX/PTfecS6ydkQJCBoDbTiiQSw/5C9qC6Rp3aqqslmrHjbpnvFnN6PxBJYsD+aE7g2C7bQrEekb0Qu6q/c+03iyPPhmKnPPY4g6gT37nVBL6+95COp/zIIzc/s37vv0vPVy8QmEPzkpvliZ1COgSwfwCi7x5hZjG0bk68zcOXGc66KTXvu1Uo/MUI7t7m7aoih0p4FRnYVk/N9P8eLsXMAxHT+rhVX00QKDPRs2+1MnqRv8UET1khFaeHzcAzWsLwCIBCOtM4Qtcw2QekJwLxTFR2EQscoRuDW/3yefxqZOF7NNOs1xc9Gw8UOorqyyiwnOW0Cfwe06y14O5Eru5bPczICWqb5J4wjRiYPz2fZennrUk9xaQCuiZ6Fdtl8QBi6vv4QNP0+jteQFMOVnsMmZqaBOydGW8WiyzK7JjQCDrvwc4tDUp66kHQ/YceJ/WKjBvTXrXJc7cqxD1e2GoIL5CEV7EWy9QjgfkN/PqH8nCQyt73ed75ZVlgDumbZQyM8PRn9GR+JT
 y5ovvIOF
 VHjPrzSjTPkCIoCIK37a8z/N9C5DfzPUHamadHxI+zkaVMcXyLyLRd/aR4hKczhy01O21q0hxEDBHft8aAEv4TGMQd/BtMvHEvChAFgklUs1o/z8StTtb+CGMvrjzZgKSeN/P6mYf05uhibyDekC2ImiiQoHrCLUzi911pQrqzkKzCPaE3LKYlWdFSx+XxREUU1IRSiyDo7EJFMv9Z8i+jIRT2JyYCubiQmVG/b+64cUPruP4YV5qP/KTEjPsyc25fya73HP8FvnHSuKo8F3MrJeNnnxZ7j2s5a/x/kNlYbkhLDznyyfQnmhAc6hrYMXUVbB41Fe+UNXzB3uycKNP8dSTNTaeaBSUOUMaPVcHM6TRmXnR9ZhPlzsPxyO6B1ZWQTAoV6n+eQEEHvOmJWbFrlZxfCo8j/5u4W69McIFPWbkN57xYj/Nbv+S6Rp+HkyFQBrsUs2XXEOKq3P4tWoWBFwTzSh/CpAl5cQCwbeqcyp7r/bPexmN7pK6uktJwGl8w2WhcETuMMuZtI+zBA3V4rCbfSziu25AmcjMyGjQKI86X4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 2, 2026 at 5:54 PM EST, Tal Zussman wrote:
> There are no callers left. Remove it.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


