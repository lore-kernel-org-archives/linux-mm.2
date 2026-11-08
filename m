Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62CB606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 14:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=XveeSVDq
Received: by kanga.kvack.org (Postfix)
	id E86BA6B05B4; Sun,  8 Nov 2026 09:44:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E8E6B05B5; Sun,  8 Nov 2026 09:44:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE76B6B05B6; Sun,  8 Nov 2026 09:44:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A0AA36B05B4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:44:41 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B8A4C0475
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:44:41 +0000 (UTC)
X-FDA: 85412223162.02.C28F477
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011069.outbound.protection.outlook.com [52.101.62.69])
	by imf19.hostedemail.com (Postfix) with ESMTP id 462DE1A0007
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:44:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XveeSVDq;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794149078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unvgm3UYytYBZsDNf1OIEbly06j5oRwz+H8GZx6bLKE=;
	b=dtHUuFPPORJ1UkCPr2v95eNBxvq0HH9q3JuPxSvqFLyP3IoroNQAHgNG6IkXHBwkwLNyjX
	HOeXwDNdyyZeg+qm3d+Avxb2OP5QRaRwEsBTDc2Zr0d+TqG7QsMl9TB+XHTd+WRmRR9QDg
	p7Dsrg7wgx880m4NCPRDeqRBttKdtQc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XveeSVDq;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794149078;
	b=a1LA5MAHbO1ikiD7wWMQMaYFLyP7mDQ/HgwA5RDNoSnpisx8w6thEwl/G5IkD4Xz92ERKQ
	uioPo9bMlp//LgKGQI/Xzs8jFNcHLLbXR2dNjHFPYgSQ6GB53r1sz2AngDJVccuNXtI1ti
	BtO+GV0811xfc0oxAgirhaN+9BoAhz4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x9rQ12lY2aMG2eXzkMpHtNi/XY7YVdmLf1qDFmyKe0ygIjUysfcSMUfUn+PfnzY9Q1L/QYcFo6lwN94G8/Bh38c+QLfAjUT+aXUctaWKWbg46uPym1yyvXKuve7yA7REefDQ8iN/zW/QvmjgWI4l8KqLY2w28INRMpTIQ2Z7x0kH3mRr3BzyA5i9XzLQ5YLLRfnJ7y0VxVESdrPlRmS1uVIAlgk3pYeqqaRT8N7BYVPbOV/5tv5DCaiMXeEF2nmLX/Je0hXclCpu/Qq5ghfDSRCCRc4e2Fbl6Dlp7uShwWQl/FAI1QNJq9blWIZ0kLvvrkeWFNQIedw52YQdA2QwWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unvgm3UYytYBZsDNf1OIEbly06j5oRwz+H8GZx6bLKE=;
 b=JIfi0dusjlcs1ZPpoUhTQxDq7xvjDE7jyDSVEEtKla6ZBw7xh8G4dwiXhgbv2nsiyfNjvoy5UkFjppdrGICEcJg8i56n9TlcXEHUS5bgdfoEUnkh5kJ6xpxkabQ0cXJY5ZLgFOa8WTUxuwtu7GU2ZrXTKRAdO8mItId0Minlc/kzBzfPp9bd3Npe96OQu0mHw2QkPlMNLkv6O5zDSm+36ZxtysY9DFhDGazG7GX+5TXOUfWeOwDAiY4VdWtkrsSy5mjcafvYJsUjYjhOjKVSVGDXvXqF0LbBPE8KtCOaV2Js/ljgqN7jSb2AS0PvkKHMdEyUyRHGUJpTfdboB8B3Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unvgm3UYytYBZsDNf1OIEbly06j5oRwz+H8GZx6bLKE=;
 b=XveeSVDqFqkf7zV31vsNqYgJjGSjvuwsxwmpN+t0ZhFxiJCtUln1bEJW+ZPU1BLLEb345yzQsxrd27fn/9sAVXwIrDKmM3pFGGgcsHTx7+qvYCoDN8vf/D29Tix8ejCYgJcm/URnLGd3it3Lr/Igi+peTVAzxpdVSGxpzBT15E8Ahh3PjYfFLpp1FAx6/NgM/N+8+X4tm5wSeAdefPZ/AYma2NhP5i4thxx2EsS86jeW6JzMDqtS/5hhZk8CDoQm9z6X4TpyiGlPMFk6HnmJZ5mTOl3WDXFN/V/z0oWQTPAq/BM0jwUV4zGJrbbDPJkb2nAO6c2O6HueFaxDNUfEyw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW3PR12MB4441.namprd12.prod.outlook.com (2603:10b6:303:59::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Sun, 8 Nov
 2026 14:42:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.007; Sun, 8 Nov 2026
 14:42:27 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 08 Nov 2026 09:42:25 -0500
Message-Id: <DMPWPZ7OHL1N.30XGRVQNCKVFZ@nvidia.com>
Subject: Re: [PATCH v2] mm/migrate: don't batch the TLB flush when there is
 nothing to batch
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>,
 "Gregory Price" <gourry@gourry.net>, "Alistair Popple"
 <apopple@nvidia.com>, "Xin Hao" <xhao@linux.alibaba.com>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>, "Zhiteng Qiu"
 <qiuzhiteng@hygon.cn>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261106041628.1177963-1-qiuzhiteng@hygon.cn>
 <20261107143456.1590658-1-qiuzhiteng@hygon.cn>
 <878q33wknc.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <878q33wknc.fsf@DESKTOP-5N7EMDA>
X-ClientProxiedBy: YQBPR0101CA0330.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW3PR12MB4441:EE_
X-MS-Office365-Filtering-Correlation-Id: 982ae9a8-a9e0-40eb-4a2d-08df3da6826f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|5023799004|11063799006|4143699003|56012099006|261021121427099003|261022105027099003|261009223027099003|261026140227099003|261028144727099003|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Wta/EJsKZqpnGClzIOgKWMKO9sqNKAdeVJ9KO/KvrJMYQ1abqVVJ2Jp+ygkFfyPfRHeXko9uZZ/ULP9SSiY1MZggm1iUFqXF7vCGfO8gwUTVKpQS+fsuLEWvbdVaP8LW7L67XXaM5XU9P7AIq/jqNtfXTKdOiIB/+Ce3FMAWvIBwf+3l3cZ/z9H/XpI5QMJ/93ttPyASuCgH/llx50mQtu1K2jKJujv6giC+xnsr4Quoh+CxD6nNdBrybTLZWKAIJsvPCWqd/o19YABbCabqVw5fUP81hm3PZ7ugAUIKabsJ9KikILnGnPp0XjoriBlf7p1UgdFmVSwUkedcJCT0QShUSIW3P1zlsib4dq6xETbpnevCkjONMlxwbVvrPBPnUQ2ksOQC0OtJXN1TSovVpDRxCFOcv8xf3EyPNw8Sl9SJWnoz19E3BkDv6l+9dNZ+GU2dVOAu8QQiWeqXOeb9O5V4HRwc3FTCmuCdJOMyHe8jz/VqSOK5aoeItPqFVIXldAwwrm6nx5oI4eopJcHdtT42dgNrGvVBdoyNMMnSG7c71valfG+/DDrowFjIO9HNxTSnEj4mLARc5J7EZpNZOtMPBONB9uy6CjYm1RAqHfa8xe8ZLVU0eMAfKxeEKM4g+s2W1Zb9WuiUn1Q8odcZ1ZSgXlhKhxlvirEADh/BR5Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(5023799004)(11063799006)(4143699003)(56012099006)(261021121427099003)(261022105027099003)(261009223027099003)(261026140227099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YnVzcVpyVVh2SXlnV2ViSUVCSnNEL2ZxUlNaYXJqNmZ3V2pIbkxOTjhLNGgv?=
 =?utf-8?B?Q2l3b0pnN1JvV2dJZlpiOVdvZVBGaHkzcGZYZTFtY3kxR2oyOXFqdUFha1RH?=
 =?utf-8?B?bU8xcWR6NzVXTE5wU1duUElSSnQzai96WlpBd05KZDVMNHNGY21yMEdYU0hI?=
 =?utf-8?B?WHpHL2I1MmtkNHhaejFISmZFblVYOWRtMHVpdlVKZFUyd2dhZXdOeFM2MmVG?=
 =?utf-8?B?OE1VVXkrdlBCaThVRDFLSkxDZHgzYWk4SURMb21qY1ErMDV6TlpSM25sRUVy?=
 =?utf-8?B?ZmNJY0NiSU9SaWlZTGNTWHFXUElKaVJyY0d6T24yK2M1ZXoya0hoY3BFMVR6?=
 =?utf-8?B?VmsvR1FYdkx1bjNQOFRvUEwzOWF2bm5PcEkxaVFuSzBtZjhYbENoMzFSK2x4?=
 =?utf-8?B?RVJwR2l6YVBBUVdyZ25NckNEYmFvUW9BRDVyYTd5OVhrWjFjVUdpTERMM0hQ?=
 =?utf-8?B?eTJadHZTZi8vbzJNRTJyLzY1K2szcVd2YWltTi9pNnhaa09DZXlJM1JqNGhl?=
 =?utf-8?B?eTU1QW5XcGlMWFdKNHNteGYyZmxkZmt6dTJhcEhrYmJsTzRwQnhTM3JPRHMy?=
 =?utf-8?B?MEhBb1VOV3VMck96THZGemp5WStPRDJ1dnl4K2VMaTBmR3RZa3M4aUJ6UHdX?=
 =?utf-8?B?emZrRFRldHVBSmd4QktEYXlWYy9acEJnNEp2bGU4bTdYeVY4VVlIMm42elNX?=
 =?utf-8?B?TWk2ZUhtbzVxRmozNU5FdlplTnhZNlZQWkg0SVF1djB4bWtiQmJmVzBUcVNu?=
 =?utf-8?B?RmhLT3hKYURpN1RiQ2luR0FFVnd5RllhYlh0Zk5sdU4vNjd2Ni93eGRRUGNx?=
 =?utf-8?B?RWVFRlFhVERNSW9qRnVidDgrRVFucks3MStWVHpVNVdXdFJJME84Vk0xOUQ5?=
 =?utf-8?B?bVFhRVFlWXBVV21PR0IzQXdFTm95MC9QR3V5N2FSR2ZVMTdCam9YenRBWHM0?=
 =?utf-8?B?ZERLdHpORVVISkx1QXhkQmc1bmQyZkRqdEZzRXRsMXkwUTAxRzNaQ0tHN2tL?=
 =?utf-8?B?N0JXcWJZMSs1bTlVZFoybTlGdFZoT2dDb082dk5EcXl2enNONXMza2VUcGJU?=
 =?utf-8?B?Rm5FUzRoWitacVU5Vm5wMUhRQWRMSXp5OTBXVHIrT0trWWFyYVoxaGk4N2hH?=
 =?utf-8?B?dTE3L09acy80dE12YTF5Wk42bTY5djlGMy91YStjTmtrN0JySEd1QWRDMVRs?=
 =?utf-8?B?S1BGR0s4dVo4Y3N1WGdVaDdCL3pSYUZVdXR3TjlmTHc4NGlhUlhlK0g1WFNz?=
 =?utf-8?B?STRtQnZzb2lURHlxK3E0Z1JabUVvVTJLeEtZaTU5NGVEd1FWMGgrOE9jRUw4?=
 =?utf-8?B?TzhPME9zQ1dkWWk2NlEzbFJtWmkwZURwemhjc1RwZ1k5TVlybDRmSmc0YUpP?=
 =?utf-8?B?TmF5L24yS0k3Y0Z4bEorR0pmaC9TaTRHRnFielU4d0VvbXM3aFRqRDR4UjZP?=
 =?utf-8?B?QlZsMDlvZ2k2LzdJT011VXZwd29LS2xPMjFhK0svOEpPOXdySzFVZ0Y4NEFJ?=
 =?utf-8?B?Z3BYK3FpajZIK2dwMDduWHN2SVVEUG1DcTU3dytwQzI1MC9xWFNBdDRSN1Fp?=
 =?utf-8?B?eDV1K2tQdCtIUFRNTEt3RDNENmgrSVRGSTdGbHR6MFFPUG9jMnh6Zm43eGpm?=
 =?utf-8?B?NnBWSFo0S05WMXBIMm9OSVVFSXNVVWZLRjM3VERUOEhYOGNNdm11UGc2TXVN?=
 =?utf-8?B?d2NoM2x0RGprT0Z2M2xGYlBUM25TTUlQZVdGNHRCWFhlUzQvZ1QwNVpuYmkz?=
 =?utf-8?B?Z2NwejRad25MeHV3SjBqZ2ladW1YOFlzT0NnWG5RVTlKU3dOVTBYYWtzck93?=
 =?utf-8?B?UUVLc0p6TDQ0b3FEUW05a21XZXNmNW1YUkoza0IvUHBKVDFndC9qZk5LaDJ4?=
 =?utf-8?B?dXhrREVmU2dtUHQ1N0JwNittei85WVFYWk8wK051ZnZ1ckdxbjRFRXVWakt2?=
 =?utf-8?B?SzFISVlQN2EvaUhzVEVFdGE3UHUzMUtoUHJRN2FMeHhzZHM1NFNabUlZZHlN?=
 =?utf-8?B?WFJRUkVTeEVOM2tvTHJnZ2ZQc1BZdnNudW5SNk04WVl0WENSMUhDbnJOSFZx?=
 =?utf-8?B?K2pXWDZDRG4rdzFxYms2UWN2ZERuY2UwaUdkb0FyNGorcENPRkMwdi9zczhT?=
 =?utf-8?B?WU9FcmJ3cVQ5cGNwcTd4RlhsMWp1enBva3pIeVFlYlJxTmU3WlFxV1l5dmpl?=
 =?utf-8?B?cHpHQjJ0UkxnNndZZnQ5ZHd3Mmk4WGNuZVRDNzMwaXRNQ0xjTlgwTUpKdzdr?=
 =?utf-8?B?d3hyYm85NnpoZ2dtTGxhTTkxa2hzdjMrd1JmSDZ0SGpvVEZYSUl1dERXMzVi?=
 =?utf-8?Q?3lQBJjxhNuBeoYK4BG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 982ae9a8-a9e0-40eb-4a2d-08df3da6826f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 14:42:27.3836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ayt0JA3I15ExrMidzzMjSY9KWDmC4Y8neHAj4zBjWTwDkfCI4XKYuwqSD5+uOwtO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4441
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 462DE1A0007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zr6o5cbnqs1s961ihb3feo7dw5akpwdf
X-HE-Tag: 1794149078-875941
X-HE-Meta: U2FsdGVkX1/urb+A3cNNehrzUgi/skVJD0cclAEwy/pzaPKV4PgthjNCZsiG6/nzc4J0fxIn0JrAkV+UcRN8qYvbH2mny9Cg23nPYQjyylFOZbJKQXP+uLu1mF2V0xNYh60a+UYULm7uRfTx5oXkljXbjrqs8+JBPdrmmEmCS3kZe/Ih8lcDF5ro9RXWfx5OvWNK0cLO34vqJdI0aFXC0iSHlCblRBXsAK11YR+kdFFLT2o/c6izcinMmWmV00my6NZVxjU8fT3CP5/X+LX1A4uXrODqukgRjoWN2XYWi1JTulpUu13vtezWdtvCHsHsBIpsfb5UwSmN+LH7NtvVZmWioGedR7DYnak39i7BMszKT92y9qXQcBOm0KVl7JBx5JfZnxDGgE3uyDNNI9afe1LF6lHVB/yXJj9ngPZ5ZVFxEZNACHKISWlnGDorzVjlNs41RtHNrJxtWwFMzD2Jwmm/zgrgvvwEgEvVhcfijEmGX96ptY31CdUhWwyr1xnw9hths24gjZxTDgjgbnG9qUjsunbAdCUpd8sPlY7XOTgERfXjjimcrWudajlAR9kN8CHAsXHb7757kcmwbD6ZlpKYVgofHxbl066MvH0y4+ICa7VHl89NteN/uIUwvnLpIXpI7hDjflso6SL1dPIONB52HiQA4cjebt4HUrYHjzLmg/YA4kh4EwTGN6ZRqESlkdaDrgcg8vner0lp2R9TMD7dqOT5UqODYJ5sPl0cVyYhrNDxdKvyIjINXG5G9je5tGbvsIwpAmjZvJTEyU2rfF/9lt3BoH6NLbuZxsxpx5wSqYbz9o2TzrYyPvQeUwhsHvDAEO05GA8Kch0N5h7WAmgucXrScH13jvlnfa+yXKpzotAT+Dx1+7ifSTKz0a6QZm1TkflLP/771g6KwRKTdJayKEuubwRLl1lRBms8BAusnQ2xaUsX9lCh9b2yQsCO9I+lYo57bW5QHC3Bu4v
 P3PKJB3+
 vexeVBOEqJSboQE30ZxLYHv/dbkJtICGp0tbuhjxGcWQPsUeBROg9kHY4OhhSWW8miuAZhscNpor0rdt5ECHKwh41GyLKPQx3ZG+Qy/F1i7HTTeYdxVwQjM8H82AXLqz7EZ22h1qtKOqrT6Rkn/U7/Ht1H2vXsrcR9+2X3YshL7C1Y4hQXFAEdVqQeRLhj9a1hO/Pre24cgqar7994wz02wyeTvu9BPzXx8gwQX6bYn6v6pahDrILHvMqCRsb3dzIqA3SiW66MnuofXsTdwjLhEeCA4J+5/3Mcgbr4IRccIeZnAHruyMpDWIzH2nLFJOVPL3iCC7Xc4VWh1222GSynXTZAY+hV46ewc+2ti8lx1flN2kPq1/fwv3SlMX7eyoL16Oxv64tl6MTSKtuv2DPYw4fMFR01T9zDpivzU+30FYHPKya3a9b0ASNw6W0MqHkSnJ/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun Nov 8, 2026 at 7:52 AM EST, Huang, Ying wrote:
> Zhiteng Qiu <qiuzhiteng@hygon.cn> writes:
>
<snip>
>
> IMHO, the description above is a bit too long.  Could you try to make it
> more concise?

I agree. It looks like AI generated.

>
>> Signed-off-by: Zhiteng Qiu <qiuzhiteng@hygon.cn>
>> ---

<snip>

>> @@ -1344,7 +1344,19 @@ static int migrate_folio_unmap(new_folio_t get_ne=
w_folio,
>>  		/* Establish migration ptes */
>>  		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
>>  			       !folio_test_ksm(src) && !anon_vma, src);
>> -		try_to_migrate(src, mode =3D=3D MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
>> +		enum ttu_flags ttu =3D mode =3D=3D MIGRATE_ASYNC ? TTU_BATCH_FLUSH : =
0;
>> +
>> +		/*
>> +		 * Batching only pays off when the rmap walk can meet more than
>> +		 * one PTE.  A lone order-0 folio with a single mapping has
>> +		 * exactly one: batching it gains nothing, and it leaves
>> +		 * mm->tlb_flush_batched pending, so later page table changes
>> +		 * in this mm (e.g. NUMA scanning) flush the whole mm.

This comment can be simplified.

>> +		 */
>> +		if (single_folio && !folio_test_large(src) &&
>> +		    !folio_maybe_mapped_shared(src))
>> +			ttu &=3D ~TTU_BATCH_FLUSH;
>
> Is it possible to use a simplified version as below?
>
>         enum ttu_flags ttu =3D 0;
>
>         if (mode =3D=3D MIGRATE_ASYNC &&
>             (!single_folio || folio_mapcount(src) > 1))

LGTM, but I would keep folio_maybe_mapped_shared() to clarify the
intent. Would (!single_folio || folio_maybe_mapped_shared(src)) work?

>                 ttu =3D TTU_BATCH_FLUSH;
>

--=20
Best Regards,
Yan, Zi


