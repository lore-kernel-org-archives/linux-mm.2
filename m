Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD06E1093176
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5193A6B008A; Wed, 25 Mar 2026 10:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1156B008C; Wed, 25 Mar 2026 10:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4065E6B0095; Wed, 25 Mar 2026 10:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5CC6B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:21:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5CF3140484
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:21:16 +0000 (UTC)
X-FDA: 84584797752.26.C98238C
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010048.outbound.protection.outlook.com [52.101.61.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1D9D31C0011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:21:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S1W2rvcY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p57C4f9vzdAwUetqSd7yX/mGzxk2H5OStTxYkyMhrms=;
	b=D7A5YHzPn9Yd+NQ15m7yxB7/45CKrfOgPDtEg8t1MQpX3bHTBsUqkECcIRKO6SCi3eMsjb
	ufT7nySVE9xIFQ3REnbijmwbpo7avhUxd12agIEwR14aCpJUO/LvIZ+Kyry61pkKmBNaa0
	ZVv4lRBV8fGpTiB+zrTDfjGNAMOwmKQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774448474; a=rsa-sha256;
	cv=pass;
	b=PYabxAJPvUkGj+K3vvwSHqp4RHBvg+GB9pvNVvQvwKCwlxYOgHkrDjiuFU4ngS6ZanafEO
	c3nUSUEbzrsmfHCH338mEpdeLcxiV4kHDl69f5H15ETAhqAN8gyfJinLgP8zPY8XWuJSt6
	yetNH2lOfgOcGYAJan7o5Kj3rposfzg=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S1W2rvcY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wvgOvKs2JtRIYd+jfUdjt/YhwJuKwit4agw3AUSmuJDOELetvzAxMxlLgBkyyMwjHKkmQRWJyFBOxT3UgPxuyiE3Ynp3wT6qFXY7hfV/W2oKdDUfz3QelomXBodeZHI/GdZHvDljFZMIAWpgTupVqh5L7jS9jyYYWIsAsiRUoQKfFgFk7BPGkJ8Cf94kfsdnPzN39rTGprNIIZXgNzxsHFpZsdnMLpMF0MigxkU+9ScVvKEKOfay3iPN3yG5OJ3o0qFYCZG7839db12LU6lXfA0Yh/337ZONVipPWEGC6drTBvct5u2jKwLyarOdoKRuWlN4KGv5sLuS1aF7diNDCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p57C4f9vzdAwUetqSd7yX/mGzxk2H5OStTxYkyMhrms=;
 b=jLqHZVRNLg7RVGRumP+u2neHfuB3JC7KEcW1CTaMNSlwrpbuem8VHf/rUPwcZOjfA1/TU+jfuARLF2gfgWb0ICMptIcKHEWOmgPSLF86RYbwGw03pFbbuRtFaejs7AzFoIrKE0krTR1oWpareTC9f05RxhHZKxsQqSZVfOW084jH+wPdo+DKWCGd8fAK5J/Wjm/yNMaCYbwwnLHW/aWsPftw7q6Qe00em1LP2XP6NRGPqtGCdm9HZhwZaK/xo51499zL1MpywbqJjXN9E2bFgbnCT/mstgeFRWJlcjWqFSZEGBk/43TdAd3OaEtz3H+hzwi8kGiMNymq9g+drK3/EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p57C4f9vzdAwUetqSd7yX/mGzxk2H5OStTxYkyMhrms=;
 b=S1W2rvcYdqEGyBK2Zkx5aY8NUpNalEEB6hAfC6CvlRL5yXxTN4XdRntYbv6iiIpsgrj/hcxtvYZ6n0lQjq8M+rp9OWUjSYYAdoj1Y6tVlNGUCKjzrZ3Bh7r5FySELBsY775tPvdPn8RSnSer7fOWyBtPq44JJKl78b5J4iU54OOfBzPCPshdLTWqX70F4oGIZ/C3HzFVTaYU/NVdOc0gadWjrLYXcDPRSmmu9yO81V9hllsG7s87WlEl8rSRxkmSwMI43XCkmHx8Ncf6lo+sgRXATpLZBYjH6fNY6sNeVKUIDICcMm2A6EJsseTcJPy+q+qYu2/y/rI3dpbIc2abHw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7284.namprd12.prod.outlook.com (2603:10b6:510:20b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 14:21:09 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Wed, 25 Mar 2026
 14:21:09 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Garg, Shivank" <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
Date: Wed, 25 Mar 2026 10:21:06 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <857B5E73-94AC-41B9-A3BE-953E59A5DB40@nvidia.com>
In-Reply-To: <f844a2ce-105e-4002-a106-b936ddd98a99@amd.com>
References: <20260324114720.864478-2-shivankg@amd.com>
 <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
 <41cd005e-3702-4c67-8d32-0c09274194e9@amd.com>
 <cb383f3f-b74c-41a8-a77d-d00e93b7fe94@kernel.org>
 <f844a2ce-105e-4002-a106-b936ddd98a99@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0114.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7284:EE_
X-MS-Office365-Filtering-Correlation-Id: ab7a85d6-d7a8-46d8-48a3-08de8a79c233
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	7gSk2qDcE6M5TSxSn+P2FsS2BYFPf315Z4i3xUwMhUgiQQ55BbHYHOHx+0E/S2hNzn/XlYubu+16sygh7Os/wMMeS/7bMGXcGIk8hgUEEfz3WL4KjZHlW5NwjfxdIDdLY0qIGg3/LU0ApjLEr6KjIHoXIw7tZXLfpgh9ss5PeFZb+a6HxhvVbyyMsqM0G+TeLKsrV+jIAdjk71kHuzLod2+sGGX/Wzaj6HzhUwrbFJ/wvuhgRP67NmJanoTQRavsnUtuoKzjU8Wt8tB0E+VA8IseeE05WJ64SPC/h4jIeAnvM+J7Gplv6Jta/TDcd3d42k/elnC9+jFSVYxL81bkDFf98qL3wbJXN0nCh6/MCmg1eez3h1cDJbZAqDT62QNulOdGYo6n9I0FSeG49UMRdqW5PPQ1EuOOLTn905z1yogi0z4dy/7ARfgrqXJa652hiKsH9/7C2W6CRZNFwZyOpx0bYFeaW1G4e7TxRQKQrYqjbm2mUHEdxYGFgxhVj3XUjUqlULtyQwStIuQJ4hk2cKAX+R+E8miMax8dc5UzNd7cRAsQtcavTdXCtgpBRAMIbvEYEb91bp8XcvPeeV+v76hKgn8XJ+BFrq+E6aJ1yGXLrMSNHh8LBYlNumEoGpb2IBHe/FFfoQb8yxdSSM6BBph7LkbgCuXgmAWfpXl/FaiWaXyQjqJe+XCjMP6rMfTM+ydCz2c1M9i2jYMZ2VLbLzbMvoLwkkndh24KY+M5imA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BuHj9O3R3GTuJK0n34l3hhPFeZz1UPaS/Fm548tnZEbhk0z9thvaCLC4qYof?=
 =?us-ascii?Q?aUo/j+95wuY8o+piPMD+Rjib83MrPJvG8ZdCHbLRIel9mqPoxmZ6H4iBpVkJ?=
 =?us-ascii?Q?fJjMTkk6ivJruqIneGwzVvrQyxJJ4riIYhihFYZhD0AC/NQ3Hps3CohfXsj1?=
 =?us-ascii?Q?/w4ZjWRAJtYF8vlNEdVFgfRyrYbK40ZxAo7O4pJ7mVnV7xdLMo+hokvpYkqZ?=
 =?us-ascii?Q?1WMrAkUJZsoNsjqVMWsgoZC0GNMYxGHFelhTdvxyn3aIe65UWM3RTklzOzRJ?=
 =?us-ascii?Q?bsNUWGILTz8+ojUPPyzCfMxUab7z6I4EbZUTgXqv9Gxd4V5UGZcvwdgSkXJ6?=
 =?us-ascii?Q?l47MZLt5tiXrCxEOrMMFV7XWbDAqGCLZ8bT/qilK3XTCCWogca2XGJE8MrCa?=
 =?us-ascii?Q?YLlCG7SjVYYFlrOD/bECdh6nTO3lPJeFcqMKlfKB6NvScZuy3Ot2JD6OUZvg?=
 =?us-ascii?Q?gLmaz0qAOCJRzIL7FSVsK+71DIbvpb+iHkoTPp5wkNX6aMvoctIi8FCxjBYf?=
 =?us-ascii?Q?560hEAxOtgMByZpNzhw30wsMS/wXES1DJSqlVeBzjcafEPdHVs1EsyowrCWN?=
 =?us-ascii?Q?BHLJtfaK/0+xIPLD2TecngaY7UMmdHu7VYzh68tl9ehSlpMaA+yfjbh8Ycrp?=
 =?us-ascii?Q?x/b8nUk5J9Ihsz0fhnGhhxBusHjH4AMRNiOiAzCM2X7J+ypaDCA5rBbft2DC?=
 =?us-ascii?Q?MJAA8i3v2sroTRJIudCWjx3Dk72oQGLhy+3pU8DrO/t6OSS0SXbu2wkIzEG8?=
 =?us-ascii?Q?iQveO9nhso/2ZbcsiU5LalhZa/e/LzzOfW22Ejx+z5ntc3lYJ24mG+RdPSMg?=
 =?us-ascii?Q?XZttf/tzi+xMhM7uUaCnvcqVsafVg/7sDBPkcL9Y/FFhb/Pw58NPNvkwhvAv?=
 =?us-ascii?Q?wavFJL5G27E+48fhFM0xtp53Oay9n5d04DzZHCo4kHsLewR+2H0f8639Aio7?=
 =?us-ascii?Q?cTRiTNctRWw7bG9S3IQkJNHt0C/TUqweqoyMJ/V5IPEzzNDXeo0sG3DumiYO?=
 =?us-ascii?Q?o2/T84OVMsarjbDxpwiOApAlluYTMgdY/ykpHiaMyArpWJttxu3Ejo8fFrwD?=
 =?us-ascii?Q?4L0F/dI35QO1Akfnnd8ac3W65Y+m1V/KFWanW4DLb5ERMqMaHbTzHkqaSGtM?=
 =?us-ascii?Q?rx/I2FpGmVNnS7iSKysCow0XSxIMk3XPDQ8Mjr9G8xGrWFHl23GEyh5Mm5j8?=
 =?us-ascii?Q?By4BGi2GTEATIrbyGLos3WgRxVwqqqrnSwamzLK/hsAFtFID9WVzQVEb8RfK?=
 =?us-ascii?Q?Lb3/IzwhqiiYnHrJ0t15j1Y+xr6rA/3ap8vwE7N66XYZe4jkB4By9s8Jm4M0?=
 =?us-ascii?Q?4Gt67qbWP1VtxWqCWeSf1Kgmm2ziDV0hUBbdzy2RkSJkkhviuY6xuFFQtmtY?=
 =?us-ascii?Q?pRZTt/qxztBCkNXbodcD0b7sUhKMMpK9EEZRIKSPzf933M0v95kCaLwjIXC5?=
 =?us-ascii?Q?LrBimybc61fNlqcR86oNI5K5IfqV39k4BdebUDmzN12DbAfRWRsdJndDawBL?=
 =?us-ascii?Q?5uIJBri54PFq1LNe2UAveCvPyjKlrj6j1tUaji9VOeeQElqNNQ8yTwB5Elso?=
 =?us-ascii?Q?HN9wle0hx6NviOxDTh275G/Nd+jHkHbkxtEjg4Ojj5HJfEOhp3dflD7uXTqb?=
 =?us-ascii?Q?joq/b62Q5bZL+wxRpExpGw5nUKHkCsLKnmkYavKBYPqGbj5fK/5u+sEW3LmE?=
 =?us-ascii?Q?pegzd5yeUTi3RNwNjAh2yHNhcjOK4N3bXBgTyPjcKOyZ65MYN9aHTwb3Ogv9?=
 =?us-ascii?Q?kJILbrYf0A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab7a85d6-d7a8-46d8-48a3-08de8a79c233
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 14:21:08.9788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EpFYAZM331IvAY+8b9RQjDRDjNXGXMOdGJYc1kINS9aqDtY1jwTcpJkBc9XZmEx9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7284
X-Rspamd-Queue-Id: 1D9D31C0011
X-Stat-Signature: 1tfg9fsqmnhax74rxwds5c8xc3n5jj4s
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774448473-800760
X-HE-Meta: U2FsdGVkX19uKBG25hTawxayp0dSyIvVKx6AvQNW2WHQnsQtmcEtR1Og3fxBSJoLj6Dai9POH0dGH4zjXkP3g1N63cF2trmMbNuMDT5F1SBUOEfD7tk/hEntp6Ec/aVCTBGGF/0j1syrAmaSrhgCfFrfNeI8u/d3dzQ9khqIdFmIyL2FZ9lS96/tGFpSfIX7lgCXPsSpAc53acXuu5gkUGIN9XzragLLJxIxRhntYRPyvHeVETdGTURm5nvu7E7FNetGAdLG9mqBCBODI8STZZqUVBt+aC1uL1IQmeUGNISg4i8oTfzFlG7uGYnp6X5IHTMQyS/DH4IF7tdOIdzekbbOsv2AUaP/GNib6lyNREFVJTbOA3IpFwBLZ8u1JQae/5GL2r0OL4w/NpxAtBovcSKonwAPc5FZhqsLMAlefuLInrZDNOvADxfp0l9027gdxRfn90BM3usAF4u7aLv4h1TBIySW7chcJlkB2LWncsNM0SmhKIcWh4U24MubRHn0frsY2uAI/pLAxHqIGo3nFaI4MJNakv/6X2FCY05IUnLLdkMnHnegahogXrHKGRJSCk6SRvrocy7wT5S+iyqKCu1HmyhEEofM1meJ8QourfCKy37AZeYW6ioLKQ/57jW0p1itPzeitpzEudsT8aTi9ESszljuu+zmzO8SsTfrs0CIh+xwcKWjTKSda/PmUJ4l3sPXWvh4/WEn0eXq4eJ93Bd94gQG05p3kuzNnIDex8lvOoAuhyTtnj8kyP3gS70h1byictgS5LSku3jTr7pATQkCHVzbfQk7AA7yzgpo0bAcPbg0Lu/B+b3r0u2q9W24AhEHPE5vVZtYSn4fVcw0qiMd+4+lCrSE5LEea+llZ5w7SoAO2lqmpV9Z2Iyz6+WaZWg8n0VUilsSFGItD3gE8F0sAR46oeOmr4A0qMjgmq5epw4NomURd/3q9gFCKg9YcO7oGGMVNVXzd0NTRBL
 ZHJQuIba
 ONAYFqg30RpX9NhNAIsLcqSQSLx47BiC5LDKqHiLddVgF+6fno13FIlGa1W8HrNhfVizJHKa8xLVDz0BCf8iKAQ2Nz0XQq4/CXKro+enUjcTj3+Xf1IjgCuZ8byQ8yd1+ppJqjrIywkxjH9qH1x5IfFgFOE87/BEvbqs9AH7zjqTtB37EVzmZ6zQfBmKpEo6u/KeJ15Hzc4Qo3sCKuvzNMMcdbi9p4pXTutor0PGhBhHN3XivPdAfg4OyR/6hDi21/6ey9L0euEbwVzdF7oX4fdHJx2+rzrbzNUGTj+iVUIsgX067nz8G1GUfI266m041Oz0ML7gjRMLH51JQxlZcLKqT++j0czZmpHnR2w955qWKatqGIGw9vURLLGygVhKwa+3XJYW4U0OBg3bddq5anBGsbpQLpXY10XSau/HLrmVQ5lHwsv2550nnLksoOJnqoZtG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Mar 2026, at 7:04, Garg, Shivank wrote:

> On 3/25/2026 2:55 PM, David Hildenbrand (Arm) wrote:
>> On 3/25/26 10:21, Garg, Shivank wrote:
>>>
>>>>>
>>>>>  static void __migrate_folio_record(struct folio *dst,
>>>>> -				   int old_page_state,
>>>>> +				   int old_folio_state,
>>>>>  				   struct anon_vma *anon_vma)
>>>>>  {
>>>>> -	dst->private = (void *)anon_vma + old_page_state;
>>>>> +	dst->private = (void *)anon_vma + old_folio_state;
>>>>>  }
>>>>>
>>>>>  static void __migrate_folio_extract(struct folio *dst,
>>>>> -				   int *old_page_state,
>>>>> +				   int *old_folio_state,
>>>>>  				   struct anon_vma **anon_vmap)
>>>>>  {
>>>>>  	unsigned long private = (unsigned long)dst->private;
>>>>>
>>>>> -	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
>>>>> -	*old_page_state = private & PAGE_OLD_STATES;
>>>>> +	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
>>>>> +	*old_folio_state = private & FOLIO_OLD_STATES;
>>>>>  	dst->private = NULL;
>>>>>  }
>>>>
>>>> Just an observation on folio->private, it is void*, but page->private
>>>> is unsigned long. It confused me a bit. There are folio_get_private()
>>>> and folio_change_private(), I wonder if we want to use them here
>>>> instead of direct ->private accesses. Feel free to ignore this,
>>>> since it is irrelevant to this patch.
>>>
>>> Would something like this as a follow-up patch work?
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 6d4a85f903d8..55d1af6c9759 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -1143,17 +1143,17 @@ enum {
>>>  static void __migrate_folio_record(struct folio *dst,
>>>  		int old_folio_state, struct anon_vma *anon_vma)
>>>  {
>>> -	dst->private = (void *)anon_vma + old_folio_state;
>>> +	folio_change_private(dst, (void *)anon_vma + old_folio_state);
>>>  }
>>>
>>>  static void __migrate_folio_extract(struct folio *dst,
>>>  		int *old_folio_state, struct anon_vma **anon_vmap)
>>>  {
>>> -	unsigned long private = (unsigned long)dst->private;
>>> +	unsigned long private = (unsigned long)folio_get_private(dst);
>>>
>>>  	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
>>>  	*old_folio_state = private & FOLIO_OLD_STATES;
>>> -	dst->private = NULL;
>>> +	folio_change_private(dst, NULL);
>>>  }
>>
>>
>> Isn't folio_change_private() part of the
>> folio_attach_private()/folio_detach_private() interface that has
>> completely different semantics?
>>
>> "The page must previously have had data attached and the data must be
>> detached before the folio will be freed."
>>
>> (btw, that comment should refer to pages)
>>
>> So I would not use folio_change_private(). An accidental
>> folio_attach_private() / folio_detach_private() would be rather undesired.

Hi David,

In terms of folio_change_private(), I did not think it is related to
folio_{attach,detach}_private(), since the latter change folio refcount during
the operation. If folio_change_private() is related to attach/detach,
I imagine it would check folio refcount before touches ->private. But
that is my interpretation.

BTW, do you know why we have set_page_private() but no folio_set_private()?
I would suggest folio_set_private() if it exists.

>>
>
> Makes sense. I'll drop this.
>
> I think using folio_get_private() is fine.

Hi Shivank,

Thanks. Sorry for the confusion.

--
Best Regards,
Yan, Zi

