Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3ECDCF8841
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 10:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6466B000C; Thu, 20 Nov 2025 05:35:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86EE6B0088; Thu, 20 Nov 2025 05:35:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26F66B0089; Thu, 20 Nov 2025 05:35:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BED826B000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:35:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81607BB74E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:35:41 +0000 (UTC)
X-FDA: 84130629282.28.1E03D77
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010056.outbound.protection.outlook.com [52.101.56.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7E5B080003
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:35:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ey2M6+Wx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.56 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763634938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C5MN1d6o9Lwd2q7wdkQLFNDX/vDIiefcF8X1TIGgbOE=;
	b=yqqMM7JgowTQG/cFJLPvNFyj74CM4NBMw889BGolFVRCbCMrAVCT+cI9QHHUWZ1UAC0Amo
	RlxH6+1K5Mgt1kl2TXbRmKzFbV8ciedgGIhQoa1lVPDbNa9NZDoxA2hdLYexuNs/A0ABY0
	UxlulEIwI4grV6QOhMSnda08kkw2auA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ey2M6+Wx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.56 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763634938; a=rsa-sha256;
	cv=pass;
	b=O7nZkcPiJ6HeQ37e61+aHnrPCmrg5FBX1bnCJD0qePnGNGAKRw+kPW9aFFoFa0u9+g6Y/h
	h1vbkTi9XCbhmGxz2Ug3qTlchimVjcXp45lwSX/qUTJAtc07H2pA6oV3QSOXG/OTOdZV8b
	WS93nMYfqTasrByOPWJbYNreEq/3bes=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w9snU9x4u8lHDEgfWM4KhrXNmUic/TRySaFMgzNxP8DhmaMTwt5XrWwBCqkX+IZlQBQ6+/MY0YrkyFrW6ATLqxE1YO8TFLwS5MJBzKGoT5VYMUfbpPlnxupUGQugY1qp14Xu426CYYfgoqxIZwohGtrzoOFayR4Td5gyZj7q/r1J2f/SaQOWNunlLY665vLY7bCA6qlEooO9jk4hCXFhZmLhz/0TW+1BBx0qhMRBAMIZOX1Avj65+iYGfJNvPoBsiOC8Di55Ywnnnug9E4nCcWyEK+qx9snO89YJazYQzk4B2sVY+wYVOg9FEd5FFNGZvenLeTIaE24yjCE9dcI4fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5MN1d6o9Lwd2q7wdkQLFNDX/vDIiefcF8X1TIGgbOE=;
 b=GTuEnzRZF168wWTRmbpCoJ0WNIhZgLf8lganwuVkYFoW6h34rkictMLo4C3r4/z0HvrCRMK0vqypcgqJi0094ypHOLtnQkAVTuJyXMg8Pcu7ULQAcdHsXVrTbt9FwRylGr4jiqvqgwdLkQgPFm6Aq6VFcLN862XMnfA378XSkKiCTkmtTGtCuCgOb56ZF//FUts7x3Z1DPIFWWtzqRCEFQ2JAq2Dd/XGSl/5P1Ti1eu/5/ZqkQ8kgmhhoJMDeE/affGuPpaGEHh3LI4AYg1Cc0d3L7WpC8v56y/9Hv7naUGE+7UcBgQy3a+XXQsXyIFi55KhN4NQvh2HpLopzrWmqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5MN1d6o9Lwd2q7wdkQLFNDX/vDIiefcF8X1TIGgbOE=;
 b=Ey2M6+Wx1MHNKLN9819SyuyJpq+x5Vnh092T+OrrV3+BmpiXn338CIbVTI7OgK01FwPA48cl/FcnpzwknevzjJye/5G4eH8BTO9NsunYSowMgobe2W0agGOkRvj1gdaBYc/V2B9ZDvqR+3jpCgMXZNHm9kWGIVn+qExOX8o0ajdwWhDbayW2bhOZlErXDLqDr5H32XAJdX9RMKtthMDiHxym2D/H1dIu4Q4V2iHuZ45DoCgJwEg/QCi0uSiM5lIVaIq+9BrLo6UoWFh/XsuM6aK7og2l1VBnr0gIqYZxEzhEDiQOlB8YnYynA8XfOZu9ZiTSCM02L8h8571bOvMszA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA1PR12MB7343.namprd12.prod.outlook.com (2603:10b6:806:2b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 10:35:35 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 10:35:35 +0000
Message-ID: <a81d10bb-cf63-4095-b8ef-1631f8ef5712@nvidia.com>
Date: Thu, 20 Nov 2025 21:35:27 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fixup: mm/huge_memory.c: introduce folio_split_unmapped
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251120030709.2933665-1-balbirs@nvidia.com>
 <4b87bd52-5582-4599-8a97-38843e27d0a7@kernel.org>
 <875a9449-fcdd-4aef-9d77-1703dd02edf0@nvidia.com>
 <3c332dea-ea60-4939-9843-ac7d3068c7c8@kernel.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <3c332dea-ea60-4939-9843-ac7d3068c7c8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:a03:60::38) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA1PR12MB7343:EE_
X-MS-Office365-Filtering-Correlation-Id: d6e79e1b-7b7a-42d6-8b9e-08de282089b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGNLWk9NVTJ0WjdjTSt5NG9Pc21EdzVla2dRY3FBUnZGYnpmT1poTlB5QTFl?=
 =?utf-8?B?ZWl0Yi9TVTdwRkppa3ppdHFSTFI4TFhKR0FuTGIvVGVnb0hjRVorQnZPWVJj?=
 =?utf-8?B?eEUyc0VnZFRSWUp4UWFIUTRGb0xWTVZFZzc4VkhKb0VoekVvRURNK2pwQU1t?=
 =?utf-8?B?VFRvS2w4cStHTUc0OGErckFPek1TT0ZsQmUzZXozS2l0dGNlNFNpSUNjNmFH?=
 =?utf-8?B?NGVpZ2llR2wyamNOS21jZ1Z5RmxSZEN5WFNrU25HOVg5dGhpYjROSkk1cHl4?=
 =?utf-8?B?aHpXS09kRzB3bWJEa2YxSU5ZSkh2NjZFenZ6eUJEZi83ZC9TS0Q2OGVTWk1Z?=
 =?utf-8?B?aGR3SnFCWnV4S3VZQnY5WjZDaDN1NlJtTEJOV3dlS3lFZ2dOU0lBQVVQSXJq?=
 =?utf-8?B?QTYxeDZlMUlhTllrMUV4VFRYMmRjbHgzOGtjT24wZFFRODZMeXJuMkkyazlu?=
 =?utf-8?B?NzhhaXM3WElQL1J3RDN1U0hmZWJIeWo5QkJPRlJjTDI3Y2tWaFBnSmVtY0k4?=
 =?utf-8?B?RGJWbUVNd0cwYWw4LzFpb05TT3RlaXVVaWZINWNLcHRibHhNWnJDcThpbjVQ?=
 =?utf-8?B?OUdpSmxBcXV5eE5uL3poL2ZEWWtJdmtKZ3JJZWUwV1diUVJ5c0ZleWR1Sk9M?=
 =?utf-8?B?QnVFaHkyRjhkMThLTFp5aFIrWi80SnNrc2VtbUhLUmx3QkVvb1lCL3UxSnox?=
 =?utf-8?B?bnFabjB1NlhrUzU4OGNFd20vYStRdk5rNkFtZ3FCMURUQlFqbDVaZG9ZeDE2?=
 =?utf-8?B?dXVuVVFKZEljUWMyWU1qWkVwN3VLL0VzVjVXWXh5aWJVazdBd1lxMDFqRG9p?=
 =?utf-8?B?UFliMjhVMlBFV051WDhTTVNBUS9DU1h1cHUzaTVtL3ZzUTljblNaVGd0UTFG?=
 =?utf-8?B?RGNBcEZyUVRvb2JLcUx1L2RKN3dWS05sWTN4ZHJFRnlhNEE0SnBRRzBGYjV4?=
 =?utf-8?B?RFdwNzMvanlvMVlpVVlrcEw2TGprOWNadGFMVG9HLzBsYWtpYXBpdUYrYlRN?=
 =?utf-8?B?R1V0aHUrbzZmeEYxQjlOZWVSd25iRk1YbWI0VDB0VkNkOGFnb01sM00wb0xo?=
 =?utf-8?B?aU1hNkw1NHlHTFR2TFlEaUIxMlFJTmt4WFQyRUtQUTRYSnhmVEQ1YUJ0SE0w?=
 =?utf-8?B?elFhMmNGM2xGZmF2VjBqSER1RzJtSFlySG9LQ2NzTWc5b1BvM29MeFl0dXho?=
 =?utf-8?B?dDNuVTN4U3hKaGVuSTVnUm4wSG84YjA4a29oelpoSTluVDZlM2Nld0RBNzVh?=
 =?utf-8?B?UU05ZE5rZUpsNHZMN3E5MTVFdk1Gc01kRGQ3Q2Fmb2JSN0tPeFBuUDZ2QlNC?=
 =?utf-8?B?SUNWWUI2RmJvRlFXOFdUaUZuYTZoc21xV0ZMTEpsV2J5YXAyRWlFYWZrNVZR?=
 =?utf-8?B?OWZhWUlTWGp1VXdEa3ROclQ4V2Q5ZHo4SWp1SDYxK1dKa09MbjRkVXIwNHNC?=
 =?utf-8?B?L0JCUEZMT2RQV3ZyUTI5dWEzdEZNSTNqWHV0M3EwMHJCd09PNk5IRnZyNFZQ?=
 =?utf-8?B?SFZXclNpMEsrd1E0cWQrN3lSUTRHcWRyd3F0d2hRQVpnL0NtdEZSeHQzdWJN?=
 =?utf-8?B?TDFvV1hFbUZoSEtmVXpMaEZCc0wwWjZRUFFrcTI0QjhPdXEva2N5VXdtSVZz?=
 =?utf-8?B?emQ1T0trRFlOTEZ0d2JEY1IwQStLY1FpR0lVSmpKZTZtUmRVRHFVTEhId2dI?=
 =?utf-8?B?NnQrSUFYS2pGdDYwck5GVWpNUU56UW5OSzdXMzk5b1crTlZGN096R3kycDlH?=
 =?utf-8?B?RloyemFFcHdPT0N6UENldEtuY01kbDlwRkhVL1FaNVg3MmlzTUxFNGVsQWpO?=
 =?utf-8?B?bmNkazlVckRENnozcXl4Tlp4RDQwaFlIc0U3bnFEeWFOVjJsZUlwS0FON2di?=
 =?utf-8?B?L3A0K1M4eS83Zm1HVlgrbW0zelRJdjcxaDVzSlUwTHBNUVpvWWlDS25mRGlL?=
 =?utf-8?Q?KczABmwq0bLxZdpeDlasvo+QmlMC/ODv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDU4bzZpbXYwdFJ2OUNOaGZQanQyNFdFWXgwZmNQY2FtZW1icUZqS1FDRFBH?=
 =?utf-8?B?YWU2TDF0bVR4ckFPYzEvMDhVQlRxd2l0R3V4WnIvM0tTK01PTDFWRkNWOUdo?=
 =?utf-8?B?MFZuMFl5bG4vVkcvc2RrS2E1U2N0d1JBQW45ek13YktydjdlSWEra2l1OGFv?=
 =?utf-8?B?RlpsRWlzNjA1NUU2S1czeHJ5YmF1ZHl1MmRENTBBNzBhOVBSVUhvVHN4TmE1?=
 =?utf-8?B?OVZxQUJLZzkrSHQySjRadHIvcXByYndGOUNxcVk1VGFxMjh1TGJtbTFaQU53?=
 =?utf-8?B?VEF6clFubUxnVlJGenBFYnFOYmYva2g1TWphcEltWlpONUZRRXJCcnVBUlVp?=
 =?utf-8?B?YnVzQmp4MWhTS2xRclZvZFZ1TkF1TUt2TlRuSFlvVW1yalR5WkUzMWhPZkNl?=
 =?utf-8?B?M3RkMEk5SkViZ2hLRzlyeFF4S00ybDdrZ1BTUmQ0Y1pyTTNqZDV5MXpQMGk4?=
 =?utf-8?B?VW5MSlZzY3RqcUcxSDZoMnRScGhEYjFJdTB1MDJPbE1vZFI3S2I2SURYdjlZ?=
 =?utf-8?B?UGR3U3Y2SjhwQTN2eHpWcWdyZUFxMEMzM0RRcHVNUkNYemRCNEtUb2luTTdv?=
 =?utf-8?B?bllYaFNBQ1lqLy9IR2ZRckZ5bjVBL2hRcWdpK2xUZ2JDa0NlYnZ0Qk80YWF2?=
 =?utf-8?B?VytrampaU3RUS3pyMUZRVE9McEV5bk9MT3NrKzVpKzZWUURXRDZTSEk2SzRX?=
 =?utf-8?B?TklwTFQzRGUvajE0WTUzNW9qMWFTL0piRFVxY2gyNndoSFlMOXdmYWhXclY0?=
 =?utf-8?B?bjZJV2NLallpK2U4NURXL0R4SlVSSDluTkRDeTNkMlQzcjNwcERuYnpuVGhM?=
 =?utf-8?B?MnhmUnRnQWZWbmR5YXg3SEFTZU0zZGs3TUQ3RUxTVTM5QzMzdEc5ZHV4aGZ5?=
 =?utf-8?B?aGl5eEZsYndDQytKZkhvUzg3YlB4ZU5NbzJuL0luTUJGK1hleVN2dHYrbGE0?=
 =?utf-8?B?OWk0WkpVNVpGVHQwVHJSRGtjWVplWjRYeVFMRDcrRFR3RUhjYUxqR0c0R3pS?=
 =?utf-8?B?RWpPK3Y4aFVzWXJ4VExNd3hpbW5LRkZEZlNsV0orU0RKY3E2QitwTnlTNTVU?=
 =?utf-8?B?YWZaQjRld211d0hnUE5ud3BPWm5lSWNucmZTRW94dGpSYTJ3U29UMHRYaEMw?=
 =?utf-8?B?TGsxN0xiZDhLd1V2WHlpTG5kNGtCTTNHZnUyQ0oxRm1hdXNSbTJsYm94eHh4?=
 =?utf-8?B?OVcwUjN1VHY4Zk85TXp5NE95aGJaNmI0d1pBQVJtTWFrdVRQYnJFdlBCR0dl?=
 =?utf-8?B?K3o4VFkzRDVLd0dxcHFGTlkwaVQ2MVVWVHlaMG5uVDIzZDkwcU5LVjE0aWlN?=
 =?utf-8?B?K0duY1hSQTZZRzNzcHF2R0hLNFUyT0h0cldqQ0ZIcnRRWnJDYkdod2pwZ3hm?=
 =?utf-8?B?VzJ0Y1FQWW1aTGdpRDVEZEF1TWJiZXowLzRNZGdPSUJnVktGa0xsdUt6SXFa?=
 =?utf-8?B?Sm1yODlDSDB6Y09oSXZpSVJwK2t0VUUxTExvWkZTU3hzSlZ3TnpldFdZRzUx?=
 =?utf-8?B?RXViVmJvcTI5aVZBZmJVMDY5cmxDcXpTc1p2eVhzYVBDeWdGelZwQUhOQUZZ?=
 =?utf-8?B?YVFpdGFNUE9jZ1dsYzR2c3RYWExtOWs5eVU0dXlpSXJmaS94aU1maU9HdkVT?=
 =?utf-8?B?YkJYalYzdFcwazgrdFNONnZZb3JCek9reEY3aEpDZjRkcXo1RUlTUE96K0s0?=
 =?utf-8?B?WWp3L1l1WjRFb2NDTStycFAxY0VWU1hNeGR0dmpiMDNINk5EN2hXT3Y2dC93?=
 =?utf-8?B?dURJTnUycWdCL21LY0FRWGpJYVVURlVEbkFFcWNHMFgvbUoxUmpUT0hqdEdx?=
 =?utf-8?B?Mkh4bzNJcHpaOWpwTzNHR0hIb2JidUxKY3U5bUQ4dHJaM1Z1SUVVdG5YOENS?=
 =?utf-8?B?RzdJa1VFWHc3SjE5NE5YTGtmUlJPN09rOWxFVy9BT3NvV1NLekxTL1V5d3FS?=
 =?utf-8?B?aENvZEhvamQ1bThSK0hseVBrUFc1Y2czQUpKUUIvaTlnQnB0WVNaTVhmMFcx?=
 =?utf-8?B?TFNEdTlsVTVRUmdYelQ1OXl6RmZwZlVYcHZuOHd2Y1AzellGRkF4bDlROWFl?=
 =?utf-8?B?bTdjcGdYc3NvTWJyTk1OUm9UcndlQTMxM3FxWFVoTTJyRSsxSGVrU1dQVU16?=
 =?utf-8?B?N2h6TFZhVVY0YXhHUlN0cGpOR2dDM1VCams0dUdJZ2REUDBVSHA1cjQvemFY?=
 =?utf-8?Q?I7zCt3Wl08+7dtNfYOWBVUFs5YjzHCwx+3MNx9I+keTR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e79e1b-7b7a-42d6-8b9e-08de282089b2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 10:35:34.9543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 40LVr5tSyMHkID7XjfEoU2Reyz2yxUba5hTuYEKsxKYT0rO5da301cvj58lhrWwo/AgYBd+ItAjtDbvlqGw/tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7343
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E5B080003
X-Stat-Signature: b61jcyjnr5dehgjxyz4aizb4mf6rq1ni
X-Rspam-User: 
X-HE-Tag: 1763634938-972132
X-HE-Meta: U2FsdGVkX1/WDOcDX+GWjJyNQdxD1LYQvXwV/F0751JhPw4Vk/RGS2htiNzNid8xxlKXXq+WTgk4L7BUzFQLYUIAotTOomK4UFZMcW/OOVhgf24nUD3Ws8ogm+oNVuXdNlnX36IlO5giHYVXHfUx5HPP9lbFQmSzxoKyGrj4c50//uKIBhNHCFCPAhn7VK71ftKlx6mtm146akfaswijss3Ali6gLbYYgxoHzVkAvl7iGE43DW3HgFLb9iN8HrtGTM8OpF4uKSFWzwUXzzJ/ttJg5dURHfQu+pw5j4ttCXLWaKtQV/9QJErzMkEuu3CKyIaca9Jis2tX7JDbfsMXKZkGDB1ui/pj8hGU/IHCuR259PL2cDTtiMXZ2g8b6ZTJ77C4QAEEhB/r8hGkLAE6P2fjlQ698zZQu8hB5wlttogpS/pwnf7qAT2c9Z6q3g+2URPAYCgxKWKwvUAS1/JTIJh+qeLW1iokMpoT5fpSDSsisLTbZ8+VrWaklXSj8gjV2SfB559nOdmrybQptLRt3yLfjCT4ADsfUSSAVgaO+vzcqKgQ/8+I7nZlD+S1/DuvuSj6o0gAZUnssSu4/9zOSpIMYy81ozmTjBU1qSIfkz+hZikElqvUPqMzeLnOb+Ggukg0DAzNTbe72iSLlonEBE+D717eTN5AAhOv1sd8FG+Con3XGrAvBURJe9z6h04U2yWYnwbZqjFWc7ko79q9LBkc2PTOMg07IfJFt/boBbegbfyNuHssITbiGDhdmE+lbfMpczUgSQhKVoM3nEc4gO88OJz2FKy/uxvJv336Vq95AtpA3CYAWCAIXWfZ0X9lbdS+BoUIZCtJclIozzlcdAP59ebR5etFwJZUcSb7Di54gVFPFtux+shhPOYwfJMYw2V1Y/dl0DYhjp10CXYMzh2y/QxJrGO3CLrIozEUZliPT5u0m7F0tq/O7YjoXJSiyaZ6jw/6oz8x20E9uiQ
 oefjBxVQ
 X1CQ5JqFCLT4nMg+LS9cNS2vKayShG2hEvWI1QlxKNiPeA60zny/bufv0b5/gU3bcwOIn1NGv8V4G9bVhTFiM3wk9DhEyb4PaEtUDJUjKw9eKbM73dviPNTEyqfGOuxNSeyeGcLLYnLZ8eQCMeJ3ozmExqmY1idryApk6rsKdafXG06aXEcTHjXjB6TlCQPLVRar7P1Bcyj/MK1Kasa/4/oqxMPjXnHEq7x9lgpGCA1/alW7LxDpB54+0KzYcr+r/KHy1zuw83UyIYU0xlj/2bN09HHcdd0OwDf23dh0lqGofE16xW9i9UrP8eqZ9O7HJrW8GhQwulGPj+zNpZ7BEvpB2toghCemQvTtOhJH09qcfxxtcftGQlguizJWZ1J2EvHKGLzKBNb9Z6Iin+Z8+tH6/VdmGCq6g91dqXVC1GV1yO9Tm2Fth4awsS8najvZRxk5HUVbIMm5Lllo6K28xhpkowH+AIwSszvgI2KdDgpnw5X2pOiO/hHtorO9HJyCeIWGh0N8TLN7kb0HdUw+gfEVknxvBWgKk9ZeIlFHGuQNKLeLuQsLrwdliejVTVyfUEHiD0uu/OEbdXUC87nf8cXo8gXK0d/94XZvwZcVEonU3pQ9Ds6mlwv6QPz/vk52uTTc/2xwtBroots0y3h9BiJdsJ3UfBw7svKzs+JB5jMQftCVsPiR0HUPZ3XCPyrHDeQHXoBmiwTPLa0Au03PszcYtjeIidxkRZiFscIGDz4WTtySBr2OlZ7f1dGJ3Ymztbm3lo9OU2E4+PeQTZlsF46iPzFZOoP1QfqyV7QIMRufRMTl+VcGBfFfsoV1IWWvDcff4M0uHjx2vmR00XE5l/pq9B1KxuKFdwRfQogkLM4z8J2x2cz+2ZAXfUhRz/kQ1STJNSdwTCsc2qvtbobN1mjvSbagQFakLFUsU/7QHk9KWeeLrlY7UsZnemHzr+nh/nPuH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 20:32, David Hildenbrand (Red Hat) wrote:
> On 11/20/25 10:25, Balbir Singh wrote:
>> On 11/20/25 20:09, David Hildenbrand (Red Hat) wrote:
>>> On 11/20/25 04:07, Balbir Singh wrote:
>>>> Code refactoring of __folio_split() via helper
>>>> __folio_freeze_and_split_unmapped() caused a regression with clang-20
>>>> with CONFIG_SHMEM=n, the compiler was not able to optimize away the
>>>> call to shmem_uncharge() due to changes in nr_shmem_dropped.
>>>> Fix this by checking for shmem_mapping() prior to calling
>>>> shmem_uncharge(), shmem_mapping() returns false when CONFIG_SHMEM=n.
>>>>
>>>> smatch also complained about parameter end being used without
>>>> initialization, which is a false positive, but keep the tool happy
>>>> by sending in initialized parameters. end is initialized to 0.
>>>>
>>>> Add detailed documentation comments for folio_split_unmapped()
>>>>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>> Cc: Gregory Price <gourry@gourry.net>
>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>> Cc: Nico Pache <npache@redhat.com>
>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>> Cc: Barry Song <baohua@kernel.org>
>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>> Cc: David Airlie <airlied@gmail.com>
>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>
>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>> ---
>>>>    mm/huge_memory.c | 32 ++++++++++++++++++++++----------
>>>>    1 file changed, 22 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 78a31a476ad3..c4267a0f74df 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -3751,6 +3751,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>>>>        int ret = 0;
>>>>        struct deferred_split *ds_queue;
>>>>    +    VM_WARN_ON_ONCE(!mapping && end != 0);
>>>
>>> You could drop the "!= 0"
>>
>> Ack
>>
>> VM_WARN_ONE(!mapping && end);
>>
>>>
>>>>        /* Prevent deferred_split_scan() touching ->_refcount */
>>>>        ds_queue = folio_split_queue_lock(folio);
>>>>        if (folio_ref_freeze(folio, 1 + extra_pins)) {
>>>> @@ -3919,7 +3920,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>        int nr_shmem_dropped = 0;
>>>>        int remap_flags = 0;
>>>>        int extra_pins, ret;
>>>> -    pgoff_t end;
>>>> +    pgoff_t end = 0;
>>>>        bool is_hzp;
>>>>          VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>>>> @@ -4049,7 +4050,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>          local_irq_enable();
>>>>    -    if (nr_shmem_dropped)
>>>> +    if (mapping && shmem_mapping(mapping) && nr_shmem_dropped)
>>>>            shmem_uncharge(mapping->host, nr_shmem_dropped);
>>>
>>> That looks questionable. We shouldn't add runtime check to handle buildtime things.
>>>
>>> Likely what you want is instead
>>>
>>> if (IS_ENABLED(CONFIG_SHMEM) && nr_shmem_dropped)
>>>      shmem_uncharge()
>>>
>>
>> shmem_mapping() returns false for CONFIG_SHMEM=n and shmem_mapping() checks that the mapping
>> is indeed for shmem ops before uncharging. Happy to change it if you like,
>> your version is more readable
> Good point, but the questionable thing is that it looks like nr_shmem_dropped
> could be set for non-shmem mappings, when it's really just a compiler thing.
> 
> What about handling it through a proper stub so we can keep this calling code simple?
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 5b368f9549d67..e38cb01031200 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -136,11 +136,15 @@ static inline bool shmem_hpage_pmd_enabled(void)
>  
>  #ifdef CONFIG_SHMEM
>  extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
> +extern void shmem_uncharge(struct inode *inode, long pages);
>  #else
>  static inline unsigned long shmem_swap_usage(struct vm_area_struct *vma)
>  {
>         return 0;
>  }
> +static inline void shmem_uncharge(struct inode *inode, long pages)
> +{
> +}
>  #endif
>  extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
>                                                 pgoff_t start, pgoff_t end);
> @@ -194,7 +198,6 @@ static inline pgoff_t shmem_fallocend(struct inode *inode, pgoff_t eof)
>  }
>  
>  extern bool shmem_charge(struct inode *inode, long pages);
> -extern void shmem_uncharge(struct inode *inode, long pages);
>  
>  #ifdef CONFIG_USERFAULTFD
>  #ifdef CONFIG_SHMEM
> 
> 

Agreed, I would like to let this patch proceed and then immediately follow up patch
along the lines of CONFIG_SHMEM as separate independent patch (independent of this
series). What do you think?

Balbir
changes. 

