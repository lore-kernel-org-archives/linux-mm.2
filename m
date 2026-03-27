Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B63810F2847
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955846B008C; Fri, 27 Mar 2026 11:44:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CBB6B0096; Fri, 27 Mar 2026 11:44:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81BAC6B0098; Fri, 27 Mar 2026 11:44:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC726B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:44:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FA318D516
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:44:18 +0000 (UTC)
X-FDA: 84592264638.10.88D57C0
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011067.outbound.protection.outlook.com [52.101.62.67])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3F9701A0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:44:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KFDNtgrL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774626254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5But+8CRQbV99IChjATiS0l/KR5l14qhFlXfLXHrI0=;
	b=sGSYCVWbv45nvX8iajxdJspLFW0l6CqT/gmG7VaFj2xU6HsbmdHZFTUndwEFI7FTjOHHa/
	iKcoB/KEJDxQ9WcD++GYx1WzB++bhEafnmt1FkYVHJtlJoypkWyQpNGhRjcPu0diDC3odq
	w1bgFvOCaygPsp3PXJnD6FzTnJDsuIQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774626254; a=rsa-sha256;
	cv=pass;
	b=2JjMr4SL5HgtDtBrNKrCeuTehqtEAru6Ix9+iKia4ge+MTmEsgwHtqVl/rT6r/spYavleY
	GiWOAkYfp3kzumvSeyfFdN+E07iKQOYtPEG76O6BV+fCFOK6QOuUUDTDvb/YCResdMI7nE
	lOCliQhrk2RdyRKHXaqfjOPi725DFk8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KFDNtgrL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Smqg8FegJsVHXPUoUqpZnjETCFn5k/G/YO+Lp865CQY53YoPn0q53UKyRhdf3xnIAb7G78JKvLOzbbRZapteosLgpL5wqkCb/ptXsWlfGu+xi4C2cBC+x/nSS0YE3Y012iLooiIqnui1QtDneOZ6mEJPsFlAgfsRsZ9XQSi6UwB2W5UnR2Usxp2uPyZn5k/mK+hKeuKGWS4EZaMpX04cztphdTwFVpjtGtJz//GMrCmLScpJORq8FBsLEEf4YUzhY+DzmxmWXGQItgtskcDfKWkWBtiqEq4hTWzy+UDLIyafb2uLnrMJ81CZZVnbe8BqxPcl8bRclGDZNtc152EUPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5But+8CRQbV99IChjATiS0l/KR5l14qhFlXfLXHrI0=;
 b=pQcBqW4kEb6U4QwKyDyxOtM2MCy8/7r5Lpzu5wX6cehuJ8pdr8GBeqWmjp862w88aYNZLyYUyGY7zmaVQgE/r48FN7iI2Lns7/4lHoEZcn0JXS8CEh5kxlwFUR/oPuZ5ihTINfzk46uabluRxl+797tGKUaIrX0lOFwyEzcHHpmuUEYDgieVBvG2Ew/Lt8gONr2Z4B2cDCz1/Woe9/pivLfWXQhIJgYNf12x5r1E1i6bTpxX9vcjAufLkCZPpETTOcbYRdj87hn8c7poyKwDiaIO13vx/WesdzSwT3yWe4HZbe7xTfvsHdzMJMBMAzKBjM74T2IukGKgoOg0AIGj6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5But+8CRQbV99IChjATiS0l/KR5l14qhFlXfLXHrI0=;
 b=KFDNtgrLKBURUCq0Cn373BeZoqk5ZvF8CKKY04VjwqbEAMugsQAPG84pkID8vTExl7Xt+SOILeYQi9ovM2vZh+I5HuNr0Z21whFgG2lLBDnqRLNzZ5SpMuT2zwvCZn34BN70KqsIzxvuue84f3BJBNMSkjpVwFLbRB8ThEaafsB5zZFSwxCJmRDj4uyhprydzj/STSbdY5z/9+NyQto9zOd3lF48RHsHeqHRfeeTlfzu7QG07/FGfQJcEYxHN0p3YWLsrOW/alRB8NkrA701QN3RBmCzJj0n9zl4SQ2fFgQYHHV2LtwqMy5DxNHJMtSEJJhUlDcCVuwPUrXSzcY1Xg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8884.namprd12.prod.outlook.com (2603:10b6:a03:547::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Fri, 27 Mar
 2026 15:44:06 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 15:44:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from
 file_thp_enabled()
Date: Fri, 27 Mar 2026 11:43:57 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <59A91369-9BCB-4545-AEF8-083B52998CC3@nvidia.com>
In-Reply-To: <14af57ba-09bc-40ff-812a-b41dfb78a03c@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
 <075A4C69-B386-4557-BDAA-4038EB36370D@nvidia.com>
 <14af57ba-09bc-40ff-812a-b41dfb78a03c@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN0PR02CA0003.namprd02.prod.outlook.com
 (2603:10b6:208:530::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8884:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bc0cdaf-07f1-4730-bf22-08de8c17adf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Bt/7snhjiM2oUO1N/VDD4b9YY7DxlRP9SWMdqTI+G+Gb197znvPIE3RboExJxPrZ5wzhQaYAgqvLvWooQKowX1PpoXaqGkHbLxw4MfGWe6/xZZC7XC7GfEEy+zrCdiGBX/4Zu9Yj7maphutxten6b1eed7Z95FvwYaXci5vM2R83f8Gt/y4J+QjPrHFqakHIzYhbabFJAJfsQJdFGUSWHMY4Z5fIkjfMiTi0eTl5zYYRdwRvggY5TPD5pSLu4nVH3lagRrL3h0AkK0jvV8nAZu3ZTLpvIqjsTEtSCYqoxmEeb7b6o/Ik1q19zpW93mWEfgy8/j044ro9qqm2U0RE+YZVdLcqDbVHMyKNGcvRVdLnrP2KiDm5vuVFFPzZ2efrfeKT5jurSf4ObW8LGp0Q86xoBtiIeiqG+mnDsrpeU33HJmPsqpsRi1dX6fF0m3d3wBqVacRquab2X9vHhdsURg+nweqf8XhyowBE/mRE2KTjPAA0hGkXEzhTgKRo4IK1LQB0IipR49J1IfMwP2+iEJX2Mdxds4on0Dtj4dmXlyajQAuarso60fGs8317gTEKJGfxWBIPPcnZXKD8dVoVKHA/9v/Pn+RQ4b1OZiH9UvTfw7sojTCL/RA9KfnR69IZHuTLgX3SB/Hzqw3sZCTgOT3Xs97iMyWs612mPyaIovqfPbL7AQ9jWKxHLQCfo1wkIRviz+mZydoNY/9dtYRJ5TQBIHOVfO8yQM630wy22Vc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THFDZFZrbHpWck42bWVqVFZVK3BWQ1VsdUdMd0NSSFpzYUE1WDNsWFlMUzBu?=
 =?utf-8?B?TkRkbjdVZmZNRkhTYUdFMktxbnZweUJTOWljT2FFZHBhemc4d2V1SlUxWDBL?=
 =?utf-8?B?S1luRUFqWHhRV0hnOFArU2pDbXc2QXYyMEU4c3Y5eG5VWk1ycUFyZWpNampT?=
 =?utf-8?B?VmlUak5WZHpzR2UyOEtGK2Jka3Q5NnJ4UFJScXYxbXgwdGdFeEc1K2VIbUZs?=
 =?utf-8?B?SkxycFQwazFuaFJaVDZaZGtvd09uSjN4WEhqMG9lUGhtSWdBd0NQSGNZbHUz?=
 =?utf-8?B?emlqU2VPTTB6WEtURGtYR0ZwSWhOL1pDNnkwNzR4NHcrcVRhdlRVYVF4Qmgx?=
 =?utf-8?B?WUx5L0FrM2FWUW83SVZKS3lwU1U0M3dsQStDZmhOcU12RmUzM21YUFFtazdj?=
 =?utf-8?B?eFZBSHpIaEd3ai9vaFVlZ1FXaytVbGdYYkw0Ry9naks3NXR4VFBWZFhqZXZn?=
 =?utf-8?B?cHFJVmRtNCtOUXRvOE1Tb0c1R2szYkJjMXZDd3R3MTEvSXFsVE03dW40djQw?=
 =?utf-8?B?VEp0NGFMSVBKcWhNUlJNSFJuYW1tZDRjTUtBdkNjVXc2a21Qa1NoekJjSWVt?=
 =?utf-8?B?Y0lYRy9DSEdmUytqSW1DWlZGY2ZMeThMNVJzcC9sYlk5OUhPUGZITm9PWmdr?=
 =?utf-8?B?bEM2UlM5N2lBeXMwNVV2T0puQnlOcXhnWWZvemg4YjBIUUxMb1htSTVEeFht?=
 =?utf-8?B?THFYOVNMZUtuaTA0QzNQaWtQOXdoaENZbWJlZU1UdUkzU2dGTlI3TmkyYUFI?=
 =?utf-8?B?VXE2aFpXRkFDUDlLbFZpcTU3LzdyN3pOSUFyVEZVelFYNUl6S0FIa0RIb0wy?=
 =?utf-8?B?OTRCckJXWm1EbndTM00xTDJPRHhHTHlJVjFKUHo0MHh3M2xrNFA3bXRac096?=
 =?utf-8?B?a0xpVkg0aFdieUVlV2k0UWVMenlsdFgwUWdBamFzbTBkLzBJWHRHTVgwLzM5?=
 =?utf-8?B?NTNEWEdVRDBZWEJtNkdXck1XcW1RSndLaTJQMUtBeXd1SldQeUplekRXekNZ?=
 =?utf-8?B?WnQ5Yzc5WG11dGhWMmF6enc0WGZkN0xyTmUvdTVQbkxDTjdRWVZISGZwVXRG?=
 =?utf-8?B?MGx0ZHROMkFGOVhEUW1mT2Jvd3FZanFpOFg5UFBoajY2WmdOU2hiZ3V4Q0R2?=
 =?utf-8?B?MmFFMkdSOFdwd2RIdGZRY200TmFuUkxOU3UrZzNlbjlTQmlaaWJka0lKTERh?=
 =?utf-8?B?ajIyZC84SUdDTlEvUlBIWnd0NGRWN1FXV2tXVnBxWXJDQnROSmZac3EyYTIx?=
 =?utf-8?B?MzI3cStLVUtPMDZMM2ozYSthaW1leUo1bWM3NzdQY1JLb2U3SWoydmJheW51?=
 =?utf-8?B?M1hWeHhSVlFKS3hqMUo4QmJ0bGc3b3A1MXp0NlR0bnA0bTU0NndmYlJ0d0hB?=
 =?utf-8?B?NjhlVTNoMmZyRDcrTUlNbllVZlJkNFN4MUNSN3p1a0hTSzAreThzc1FQb3JP?=
 =?utf-8?B?bjBTQ0I3YmZTUC9tRVM5THcyOUlGSGs2R3pZazV6VEFMeWxMZWJ4UkNWc0Ny?=
 =?utf-8?B?UHNhU2RMWk5Ma0RYeTVMOXJiTDBBTXR5UjNQS01xNEF1Y1NNL1l1TUdTSUgr?=
 =?utf-8?B?aC9wc0FlWGJ1S3JtNDZGV2QyWkIwWWtDZHNGbVpHZWVoazYrNE9DcGNJeDBW?=
 =?utf-8?B?dzg1YmQ2TFpqZzlCcjdYQ2FsVWptRDNaSXM1N01NaXFCcEd4eVV3VU1Kb3hD?=
 =?utf-8?B?RDR2MWRacUU0MEtoWnEwYkc2cEFKdTd0ZUduRXd6Q0o4VzZoM2R2SXJzY1pE?=
 =?utf-8?B?Ukt2RHpzVzZYTnF3RVpXWnFkZ1ErTWlVR0lyR05WSzhCUkdPU2lsZjNWYTZU?=
 =?utf-8?B?ZEpLOGg5anZrdnh4ZFZwSnJHL2NvKy9vL3B4UjJRd3lCeWY3VWQveG9LaUF6?=
 =?utf-8?B?SUsxV0grT3BKNDgwWXNRTHZBUjUyUWc0TEZyNjFJNWdqWEVIcjgxVEZadkVK?=
 =?utf-8?B?WnBFQ20yS01NU0diTEVnNjZpZWZhUlB1cDdGeURVb0ZhZE9uYi9sMzAxVVp5?=
 =?utf-8?B?U2IrNjYwN3Z1KzdlR3B4cndMZkR3QUF5K1dSV1paK05oVjg5UGhVYzJ6aHdp?=
 =?utf-8?B?b2NmdHQ2dlhRYWpxQ2tmenJjdDRHQUtObEI3WEZNNGZQUG9KZU1zQnlIU2V1?=
 =?utf-8?B?VnZhOHNTUWZzRGN5RjZYQytmMHp6NDFPaXBtWDBLQUs4b1lXUGV2OWRveXQv?=
 =?utf-8?B?S3lRdjkxRlFyS21kaU90Q1VKNnphV0VLT01GamxEZnMxM1BJV3A2YVBCbVVk?=
 =?utf-8?B?Zllkd1pPQ2F2OWZwVGJHYm92RW9qMlgyM0ZTOGxFbjM1QmZKNmk2Z29LUHBl?=
 =?utf-8?B?M2xZS3o3dCtoZFJmV24rNGJKbVVuRCtTdXV3czQ1ei91bHJXVjB6QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bc0cdaf-07f1-4730-bf22-08de8c17adf7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:44:06.5606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGseDRyAe0lVBk/FUeTCCwVGJ74bnTYJ4QkPAEs6SLDWSm3/srJBLd9xumVKQnUn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8884
X-Rspamd-Queue-Id: 3F9701A0002
X-Stat-Signature: ojuetjzrqa41qxyto97ptf3oq6wcbmtn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774626253-153753
X-HE-Meta: U2FsdGVkX1/NC9wg8+SRNKBwFc0JLIi54F2sukDqPUHVu20Y0R1nA1yc4EIcuz+KBjpft9BEKYH+oCUxBL1VFnx3imZlZBmhJyFFlEMwklYkv+KML7LMcVD9bHal82762YxhCWiVVYmbXcvXcPnSjqi9RKUNROggZ4ZdISDw3mlWLSkFRrEU6vEfZ5z3n3OT/qeI2/FBALKRSAxbEFcRZJ1JgwDvHa0x7UjakALz4h2nctX6sWabrwW+QiEE0+vPBMofwlqjVa4rgoo+VOapcj6hcJYkIsoGYDqU2oKdLEJCSEqfmQqE87OT5iGvQf1P/PP/+hPljhxaWT6a4C9FccIOx5az/Fyg6f6P5u2XKQ8U+jf/7UYPJjYwN10+2Sa8CXeRHFMsZJpDmJhub0eE6vqwHNn+CiwOS7cJk5YI698IzS5cRPan9Pi7MWbL//0BIodyGo66k6gVieXGfmhwoSwQSe8msosCp9cLkI4qj10Xtkk4SQCl6sHHHJzFnNYkxIz/j5OG+izu7SN1kTGjvLCBHHmn0mP8T5PnVB5Z5ZSue6IfmrsePARXa+O7Fei/DTzScyWt+SXUjJ6QXF3op7m/B9cJdBo6vxcZUQCfxrGtCBBC5zSbujM/1eiXcbV6e+BSnTdEX/py+YVPBkZtqvk6maZYMxH4FW5LIdfzwpXN4P5YAc6j/DuL4beT4ionzhysiRkc2UO9rXFQuU6gfNpcNLBrfwT10wvHn9rgrmbWeKjsxu8Z5x+/mFvjTLCXxvHS5RRPLHWmdQfKi4dhhcjS2iV0Xf+NQfZOMd44uUsaBv4IKH3cf1HPgRV2v0klh7TbCQMMdl8I23Dstse7vwwvyNj477AVHPtGcN/40w0HDjrApxB8b9zB+IKPQJeYA/G/ajqeQLMxTJtqtbFvFRlshnfmT+8qZMh9SftsXHXufhN7We0+AZaMTWD3VnNn8oIm2RygzTQzhTGnAZj
 IreL89CN
 DzTYo6od3zrpwEO7+DSf6WEtLyMuaTuxcXaSZakhAF2vqjXdyvNOhcB6CjtU1R+KvNr/oUNT3YrPwJFrDFx/L7mEcb1+qsnz21S1l0m9hbTTOH6zEQErKd0N80yhzzfiF6Wr6T/B/O5oE+dMbWMSUT6+7ZfIUP9wGi39MnjD1l8SeGiBx3RBVD3Fh3f7ynnwfXCGDezIDPLLYF7wYl6Uhgk6T3afSodIQpx0zIbFKgXC4Wr3hwqIQlIdWiMB3oKaZtvpYsSKvUcTAzC8ptq1A6W9HjWOVOOKKU6HgaQtZykyZz80nlaW7WwGdROFRw6U5CxpfLqzll0Q6payzLvReEpdJ5jg8D+Z+pWQ0DLHFbzLHatgreObv8q4zJhcaBfvMjCgb84VO9gh6M1KtEMs35jdPROsTCHhzHmfQ9cDU9c3vj7woC1CYaDMLoe+kxbzHOk9LvTP4oSbLWe2n0vMqaone0DG9oZ7WFP3Rnk+CegQFg2BpWU/WUBQvSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Mar 2026, at 11:29, Lorenzo Stoakes (Oracle) wrote:

> On Fri, Mar 27, 2026 at 11:12:46AM -0400, Zi Yan wrote:
>> On 27 Mar 2026, at 8:42, Lorenzo Stoakes (Oracle) wrote:
>>
>>> On Thu, Mar 26, 2026 at 09:42:50PM -0400, Zi Yan wrote:
>>>> Replace it with a check on the max folio order of the file's address space
>>>> mapping, making sure PMD_ORDER is supported.
>>>>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>>  mm/huge_memory.c | 6 +++---
>>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index c7873dbdc470..1da1467328a3 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -89,9 +89,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>>>  {
>>>>  	struct inode *inode;
>>>>
>>>> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
>>>> -		return false;
>>>> -
>>>>  	if (!vma->vm_file)
>>>>  		return false;
>>>>
>>>> @@ -100,6 +97,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>>>  	if (IS_ANON_FILE(inode))
>>>>  		return false;
>>>>
>>>> +	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
>>>> +		return false;
>>>> +
>>>
>>> At this point I think this should be a separate function quite honestly and
>>> share it with 2/10's use, and then you can put the comment in here re: anon
>>> shmem etc.
>>>
>>> Though that won't apply here of course as shmem_allowable_huge_orders() would
>>> have been invoked :)
>>>
>>> But no harm in refactoring it anyway, and the repetitive < PMD_ORDER stuff is
>>> unfortunate.
>>>
>>> Buuut having said that is this right actually?
>>>
>>> Because we have:
>>>
>>> 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
>>> 			return orders;
>>>
>>> Above it, and now you're enabling huge folio file systems to do non-page fault
>>> THP and that's err... isn't that quite a big change?
>>
>> That is what READ_ONLY_THP_FOR_FS does, creating THPs after page faults, right?
>> This patchset changes the condition from all FSes to FSes with large folio
>> support.
>
> No, READ_ONLY_THP_FOR_FS operates differently.
>
> It explicitly _only_ is allowed for MADV_COLLAPSE and only if the file is
> mounted read-only.
>
> So due to:
>
> 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> 			return orders;
>
> 		if (((!in_pf || smaps)) && file_thp_enabled(vma))
> 			return orders;
>
>                       |    PF     | MADV_COLLAPSE | khugepaged |
> 		      |-----------|---------------|------------|
> large folio fs        |     ✓     |       x       |      x     |
> READ_ONLY_THP_FOR_FS  |     x     |       ✓       |      ✓     |
>
> After this change:
>
>                       |    PF     | MADV_COLLAPSE | khugepaged |
> 		      |-----------|---------------|------------|
> large folio fs        |     ✓     |       ✓       |      ?     |
>
> (I hope we're not enabling khugepaged for large folio fs - which shouldn't
> be necessary anyway as we try to give them folios on page fault and they
> use thp-friendly get_unused_area etc. :)
>
> We shouldn't be doing this.
>
> It should remain:
>
>                       |    PF     | MADV_COLLAPSE | khugepaged |
> 		      |-----------|---------------|------------|
> large folio fs        |     ✓     |       x       |      x     |
>
> If we're going to remove it, we should first _just remove it_, not
> simultaneously increase the scope of what all the MADV_COLLAPSE code is
> doing without any confidence in any of it working properly.
>
> And it makes the whole series misleading - you're actually _enabling_ a
> feature not (only) _removing_ one.

That is what my RFC patch does, but David and willy told me to do this. :)
IIUC, with READ_ONLY_THP_FOR_FS, FSes with large folio support will
get THP via MADV_COLLAPSE or khugepaged. So removing the code like I
did in RFC would cause regressions.

I guess I need to rename the series to avoid confusion. How about?

Remove read-only THP support for FSes without large folio support.

[1] https://lore.kernel.org/all/7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org/

>
> So let's focus as David suggested on one thing at a time, incrementally.
>
> And let's please try and sort some of this confusing mess out in the code
> if at all possible...
>
>>
>> Will add a helper, mapping_support_pmd_folio(), for
>> mapping_max_folio_order(inode->i_mapping) < PMD_ORDER.
>>
>>>
>>> So yeah probably no to this patch as is :) we should just drop
>>> file_thp_enabled()?
>>
>>
>>
>>>
>>>>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>>>>  }
>>>>
>>>> --
>>>> 2.43.0
>>>>
>>
>>
>> Best Regards,
>> Yan, Zi
>
> Cheers, Lorenzo


Best Regards,
Yan, Zi

