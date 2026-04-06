Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E565E9D826
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 01:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406546B0088; Sun,  5 Apr 2026 21:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD6F6B0089; Sun,  5 Apr 2026 21:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CCDC6B008A; Sun,  5 Apr 2026 21:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4B76B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 21:59:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA2871B6F90
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 01:59:51 +0000 (UTC)
X-FDA: 84626474982.02.B58680D
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010029.outbound.protection.outlook.com [52.101.56.29])
	by imf01.hostedemail.com (Postfix) with ESMTP id BAD264000F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 01:59:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=B4x2mxhg;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775440789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5MaxEYRhbgCw1BMg9CsjnIUtc+tJ2/yJ1leQZxwYMw=;
	b=qF4EAOsHlVF8sb34RMVjCEJV3Yw00PPnXAQNeGf0nl8VVzL6CAdc0ll9YTOtA92u76WqFl
	MI7NLD4nFOdPPn/oRLhiYJIEhheyrG8oXuFKT0cbLDh5CPNsojkpUxZJoA6D2ECuREg2kj
	lSAfHn6vrxWfrCWJq4qvxIdFlXPGJ1s=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=B4x2mxhg;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775440789; a=rsa-sha256;
	cv=pass;
	b=YQp1grGzjinFlrBcvZ7nZjWKJTRTXVKwcVziaZVhKdRqrXyE3Eq1S6XgsXBgwxoE0afbz4
	1CYITyXCOCAC65i1HkiYgbG7ARwKkxhA5N29g2SFZhTwdY9c32rUajAzyPys6bqpVDzf+l
	yGdQQTDgmuS0SXMZgMMekVKrBkupNjw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YYf5XQ1fSw5bYc2V6emx3Oxub8R8A2CU737cIMoz0uVp1XFz3DTT2ftkbLRhRE0kz9NWB7CvNqFuZ9UAKWkvYlLPMFsrDqSv1IwIxpZjWdMHoXRUaTIOVR4bhHgDD16M4ek2Q0SlNcI0Gjrqoy9g+hc6wsruhY/pAzUJccT6TqfUOmBmY8iekqk/0PUY2X/L/TblwTgOLsnhcz6UrXV/wMKUKRFFjJ6+XLvKiTgHlgwH0M1pANLD7MPxz3EHYNcygome5oA2FWunGf8aEg4irnsrw2G67VTW7LSRjuDiHbYWEy6yUYOx+pt/t8/OBlAQO53+Z87nbxTPXmEkXZ2DGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5MaxEYRhbgCw1BMg9CsjnIUtc+tJ2/yJ1leQZxwYMw=;
 b=cLnAFQy06Vf1huDuYjYvpi04+kOP3T3CEGHkBmdLupvYEMIzkLRsg81WD6awAiUu28u/Fuz7XbW+Z0M05MsUayTqE0EOdi2OA5i+adh09HY2KPTOioxO92F1kgFYZHna+XiRtydvjV0dX3zFT7o4pE8lEDaKDpDFBl290cgFDIaoNKZSz/hEK5tD5aEbdn05jY8g/6oIFlWWivpm/1mA+6v6DYLV1nK9TrCUxOmROUBs5nKWqhyUYymoxFCd1DYfZgHb1s4LGcSekXDAPV7JITb0I4XZ/AwdoXGmafpctULE7NNNJH2dwoBmfCpoTKaRYr/dfbC7kkHXjqfI+ChmHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5MaxEYRhbgCw1BMg9CsjnIUtc+tJ2/yJ1leQZxwYMw=;
 b=B4x2mxhgDhbGpR9PzyRpV2ZOVV/8mPnv45WozZAWQLSSCiFTQrMOgLfoSCHw7sX1VfXgEuBQes00VZpm2C2rl90XeHjW2NLiHkQyztSjImA4aur5eoARqtlvMK4nN6iRwwWYaU/MkDr/tx9I3Rv6GqKUAKY7YZ2wQjD6j6ciq58aZAQ9+uxpxb+CHNU4apfV3Z/Et6ypXmVNr2eQf7To8J9pdrrdoHtfYtoUod9qn1mGa0tEQ8uKemlgeUvC9tPrIPInuU2p0/dWO52YbN38OD2TvNNG4kDfQmXMBH+8iiCIISqcUsbg9sJWIrWj3xnUkZ17LlBv0nFtcQSdrrYxFg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB5829.namprd12.prod.outlook.com (2603:10b6:510:1d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17; Mon, 6 Apr 2026 01:59:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Mon, 6 Apr 2026
 01:59:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 00/10] Remove READ_ONLY_THP_FOR_FS Kconfig
Date: Sun, 05 Apr 2026 21:59:41 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <737AA503-E522-4F01-B78E-AB6C6B2E89B0@nvidia.com>
In-Reply-To: <CAA1CXcCmue7iX3O9RLo7wR5EqASvJGCLraw1+iQMZ98BiMJwrA@mail.gmail.com>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <CAA1CXcCmue7iX3O9RLo7wR5EqASvJGCLraw1+iQMZ98BiMJwrA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR01CA0033.prod.exchangelabs.com (2603:10b6:208:10c::46)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: 11c57a64-c544-446e-4d40-08de93802c31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	u1qMJjQ/fg3rR/FAfYJpJVMRP/DNuZ0JMrvornz+OTsjY2R7sriSsHyyKzdaNCwU48iHOPNmYRXbLnuiYZDXa0JI+EZJe3Y0mtsTIRj617PxEdh3+2yglq/2GrFYvmlaVl0B1vslGtLYnn162hwtogge0gPMuhnex0W0AyqKT/AZ/5/c7bd/rwyb7Q8N3cJHedztaaC4AO36Pik818XjijSMBPXCbNLviTrD0YZSTDqG9Am7LGTZjD1hRYY0FeRDo11V/JDpZ1Pq8RRYa0bOH+d7bVGLNIZ6n/bRPrDPfjoQSP/tzjs1wb9rpDbBbDh8xd1fdANYK9k1C/1Yk0RgNx7TQcfyvB0oPFZl5IlMwmPsXFOydaliGIkDAhV+wZqa5bbyW4jP5DHyb8Nx7tjvAb8XraFThgzu7U+r8tWdtidAV2BeiRns0jHSryXxWRVU4WpSEYRgPNw6C+ePkYrTLGzIgbdrxef2GnO9eipYl3n5LhpCb+502TaaN6n7QR/V0Nb+zHgGRsJHM7uI8sfkSFcKDP3BHL4bv5+54nYkPXTPjaVsDbTE5vdC88FxfLBjGxDiwJ46Hy8HUA7b4Fp5uCJdz/031ujM76HP/xYcTdpGml9Lm83/6Fi0CFmhn5W6Gvw6oSoK+nEw0aTMv3h9p6BNANfV2Hav5/85cRGfF3XGyBJjNHl2Q7gXPhPPynwU/1mb54AGm1WdoQtquIMve0H1Nw5uOHHHrFxbE82pllo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnFFNDdaekFhU3VUdFczT0NwL3pZMVlNbkVORVR5aGVwSEhYSjZTS25uQ3FO?=
 =?utf-8?B?SjUybElEM0ZNQitaS1o4d250Wk5hVkwvSThxcEk1Qmd5d0lnK0UxUXhoZFVy?=
 =?utf-8?B?bTczOEcrNXRwaDU0dk9CUElRc1JXYlJ0SG9XakUyRFlmVnlHbW94dDlGRGJq?=
 =?utf-8?B?Q2dqZ2ZYTVdLVE9RYTBWek1qL3V1MmE5Sm5PejBvV0hoSnMySkc3U3g4QlND?=
 =?utf-8?B?Z1BEQ2xXT1lqb2NBZG52OGY5aTJjM1RxNXN4c2U1VmJvajVuU2JhTUFTckJz?=
 =?utf-8?B?MC9qSTgwbi9YcUdGcVB4NllNZzNjNkpuUG5tdnpLcmZiS1p3Nk5IWGI0dHhO?=
 =?utf-8?B?UERRQ202YXJIUkxxTm5FWGY1N1ZTUGJ4NWpPeDVRUHhVanV3MVpmZkxLS0E1?=
 =?utf-8?B?UkY3b0FKYUo2VFhxdm5aczI4c0NpRmRJK3pJZVMwYUtUMHZFbTNzb3cyc0gr?=
 =?utf-8?B?YUYyc2ZWVDJVaDdyYWxMTENSdXBhVDNmNjR0bmwwNVRlMzZuYUtqMDZCOFh0?=
 =?utf-8?B?dVZqQTMvbCtsb21pcWxwQXVqTVloVkZ6c0kxQW9KZlMwYXk4Lyt2OWRBU001?=
 =?utf-8?B?WmxEdTl6Z2pFU0RyWDhwQXNxcU53Z2ErZ2h1VWJ2VGcxb3BpUFlHV2VnWDRN?=
 =?utf-8?B?TkFBSzJBK0k2ZUdlNnpGVEEvMmJGK3E4aW02ZFdOMGJUV05rUzZKSUdBM05o?=
 =?utf-8?B?SVZrSkY5ZTZlUUx0N0Y0NnllSEphd0VPRUV4bkV6S0tzZ0E0eThmcnVsUllG?=
 =?utf-8?B?czdSSnE4Sm93L0lkaWg0QklUYndVb0JRMVRuVVVCMzlJbFBmd3FqcDhHS3R0?=
 =?utf-8?B?RllDdmVMaUZSNFlQeHJTUVJQL3lSTDNELzQ4aU9IMktHM1JNTkpmQ2FzSTRq?=
 =?utf-8?B?V2FPYk12SlVsQWpwWGM2MWIrVGxJblc4ME53UHU4ZzRBQ1draHFOb3MvNjNv?=
 =?utf-8?B?Z0FqRGVBdUphdTg0a1VQcEtQa3RVVHA1eFNmNzhBSzJHTFZuYXMxTytKWTh3?=
 =?utf-8?B?Wnlvem54ZitNME13dzl3eWF6T0JRenkrSHhNcHZDZ2tmSHpjdnYvVkl2ZVVG?=
 =?utf-8?B?aHBNY1dmMXprc1o5LzhPRjJQWWpzTitEcmZvL3FOYjFiMmNMWisrZjdCVkNj?=
 =?utf-8?B?OHhZM0pJV2dqRnVxa2dSem9NODllcjhXeEJVblJ2ejhTTDNvRXhBZXVqOW5C?=
 =?utf-8?B?MVQvc3daY2toSldhVGoxdVYvK09BS1MwYVE2UkR1NzhnWnhSaWk5WlNkOXBQ?=
 =?utf-8?B?ODdTeFdQV1gxNUZFclB2RGFqZUUzbHpOZXpSZ1RMSjhDTDVpamtTckF4TXQ3?=
 =?utf-8?B?UTBVelBURmZKajM3K3BESk9CK3YyYmR2dXJlaWpCa0gwMWp0K3hmNlh3clRp?=
 =?utf-8?B?NkN5VmNzR0lseFd3UnBMeDQ0eE1EZFBuNU4wdGhub2k5OUFWQ084cmE1OTBI?=
 =?utf-8?B?WkhaUlc4SnZpYnN3MU53VzRXU0dKbEl1SVFxaHBoZzRobVR3K0NxcW9VTGtj?=
 =?utf-8?B?QUEyOWNYeW1FVmxPYlJhbHllVXRhb2ZvOFdkam1pU1pqcmJsd2hSN0QvZWdu?=
 =?utf-8?B?VHloRUxjRXlra28wOFA3SkNrbGZQaEIwYWgrbTJHU0VURWVjd2RSQmRxaXgw?=
 =?utf-8?B?djBlUk93Tk1WRmRqRU56aUNYcnhCNWFQOGExYVNBWUFUaTNCSkRORW1PVWVV?=
 =?utf-8?B?QUcwbUltZWlGMzhua01zMnR6NTcyaXlEbUVUTVE2M0hnUHJybzQ3YjZjRkd2?=
 =?utf-8?B?SG1ZMSs1WjB4dmtOQlFRbU5IdGo0Y3RRSDZTVUhON0tVWHdWNm9aaUc1cGpl?=
 =?utf-8?B?cVcvTFZRNjBGdTJqMnBLcEtydVdINHVoZ25ZMHlpZ25vZ2dMNnNKMythcVBr?=
 =?utf-8?B?amVMWGxvRmJWc3RZMzFNTW9EMWcxUWxnTFI1VGE4U2d6YUo0M1VyZkJNTUJX?=
 =?utf-8?B?bHhOVE9SUTlmUVMwTkpPNzNlcFlGdmwwNGRPek1PUm4vckx0S2N5Z2JCdy9m?=
 =?utf-8?B?L0ZZUU16blZ4MnpUZ3l2d1BoV2VUODhqRGFRK0szeUdKS1pMd1J3bUQrVFkz?=
 =?utf-8?B?WlBzdkVQRlZnSzh2M0dzVWRhNHlrRnZxMnJKSnZ4VEdnL290bDNxV0JRMlFq?=
 =?utf-8?B?K0FUZEVsclQyWkMvM09RdGl6MkcvMGxORzVldU5wK2JqR1FFTFJXUEpwQ3Fl?=
 =?utf-8?B?UGZZSUlub1ovYXlGUWk2V0I1V1lQRHEreS9nVlRkR0ZGTXNZOGgrczV5blgw?=
 =?utf-8?B?UjR3VjJCZDI4MEpyVnZQOHI3R2pzQjlPU2hmaG1tbzFldmkwUVhqQ3BqT3U4?=
 =?utf-8?Q?rOMUlJ3g+aTlZXIKPF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c57a64-c544-446e-4d40-08de93802c31
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2026 01:59:44.0924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35XK4NhgYDFQBUsFfimlHayHYqdXGKQGTk+QW72U7Kd4CFa0QVPxyECA4Hm0KGHz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5829
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BAD264000F
X-Stat-Signature: h5mtmr1hzshurykccct6cfufra5nio1s
X-Rspam-User: 
X-HE-Tag: 1775440788-542695
X-HE-Meta: U2FsdGVkX19V89lJVNt8dKmNz3DY9f7XbZVXS+TbfO2rSc8Kdo50gmqrH5UJIDg7LV4WnHLO8LCHkKgRdWDp9bDtGRviro71Ieni5bgTIGrE4FBPbB55sM/uqmkyqbTSX7we+M5hRVFrkAis/yNPJz8jTDLq7sYwLVVunTlAl/YwhA9uFDxfMh3CQH4aHcOYb8DW8hVZwKCgeGnxroZMruE4hVzzGj9gKnnfKOh2m3VygfOoNIFuosPemDBsMECHqL524wCM5iVYxpfq/HbAXpDX4xEaUQUakZKygSGL2q5VcY4mKQAPgcz9GDVOHIvIvJSFH/43QwOd/llJEpLbczaLdOFVyQCG/wIztuxZ/IrA/q4ln4jn3Az0dK5ZCZFn68ubUXa+3enu0u7bwZkdwej8AhQWY+lHx4fNIUd8zhhoQPFsHjAh+CcyI+1IJjx6yVkgAsW3zMR6ssAZitJHlBaj+TzAAvXJxbFxtd0dM4i6MbOFul0xAkUuLBzvWcFYhvpC4DGTsXJlVZj5wUA2iwRXg4TvmIefkvEdARow9NeYZnqs/BTzkhQZBI+Ty6BYuHJEgXS2Df7iYSFYENJ6al4rLLK0Zh5e0fRhuwubuI8qzzBtMHX+lL6K3QkLlOUEIecaR7VcGtKi2tWDlOmJzOVxD6olyZXzg/pyo96hwGWubk5SgFw8qnxPL9/DzEMhJ4oGsv1B0yV8tMBqfqrrBGfoS3c0ghcuQW3OCnxdnPdHnDJiNyIbfb53Jn6e+Yi+QBfVOAedtC7Zq1/Y4vM809y/u8H22HvB9s2VyaC1r2cvD2VyxgYHnCdz2hH0bGRrrXZ4AS+dSYw2nXSR3Ttt3HJBnnjkSJZ+9kjp+zDnMcvTOaFsaj76WPxIxIbWnjIvMfXeSa/s8dq9ush4y8r55O9ycHu2qG+q9e8YbI8oFAP8uy/xWF5etKRjg3OS4MvC09d3T0jHWGZloAVDvGn
 q0XOK7LJ
 w0kyZUZLcZNcO1eVtDDR/dRQan6RE1sw9ZC87Zp0cdwt64gss80ZkX+hZ76hfo6afKYUE1p0qzdwEclhwTNxRIsPq8Gnnl6DsLwKBLDD9Sgaujatz5PwDN61R79kaGfCzLoiLXYNG2UOZMBTuvnKjFWXTE7Qc6vu9DSxGTy2uVI1NMWat9yVCmn7EZphudA4yuipnwx28qifqyGn8WY7MaNqdwleNpv4t58ZI+qTI4FvJUUzEip8hUzw9qR5FBybdU/8h9MVGJdj0N9JEyTGe+PjjP/ukqCDEHS6rSvZyWvuEOXU/6DPhfz1Ai0QyaB4kfZckgxadA3bDGrbA2NANXgPewdyPYSiaeXTYoxFRMkaczsJvEG6ehOssItWEdOTwhsxKTKoEh9DQ/GwVIOAl4XKK0Uswh9VkZzsNbDMKJ9hTPIUUHUWt5zkjVaEVVu4rYLdJ35hE+xbTbdRs5G/TIZG5r7ue/POSwKm8oJ6Y3JHsAV3N4OaXnpAhwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Apr 2026, at 13:38, Nico Pache wrote:

> On Thu, Mar 26, 2026 at 7:43 PM Zi Yan <ziy@nvidia.com> wrote:
>>
>> Hi all,
>>
>> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
>> read-only THPs for FSes with large folio support (the supported orders
>> need to include PMD_ORDER) by default.
>
> Hi Zi,
>
> Thank you for tackling this :) Ill try to review the next version as
> I'm a little behind on this thread.

Sure. Thanks.

>
> Should we guard collapsing READ_ONLY_THPs with a sysctl? My fear is
> workloads that convert READ_ONLY THPs into writable pages (assuming
> this is common/possible; my understanding of FS is rather low),
> leading to storms of thp splitting. Do you think this is a real
> concern? I guess this is also true of read-only-->writable fs-THPS
> even without khugepaged, correct?

Why would a read-only THP need to be split when it becomes writable?
After this patchset, a read-only THP can only be created on a FS that
supports large folios (to be precise PMD THP). That means any write
to that read-only THP would just change it to a writable THP.

Let me know if I miss anything.

>
> Cheers,
> -- Nico
>
>>
>> The changes are:
>> 1. collapse_file() from mm/khugepaged.c, instead of checking
>>    CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
>>    of struct address_space of the file is at least PMD_ORDER.
>> 2. file_thp_enabled() also checks mapping_max_folio_order() instead.
>> 3. truncate_inode_partial_folio() calls folio_split() directly instead
>>    of the removed try_folio_split_to_order(), since large folios can
>>    only show up on a FS with large folio support.
>> 4. nr_thps is removed from struct address_space, since it is no longer
>>    needed to drop all read-only THPs from a FS without large folio
>>    support when the fd becomes writable. Its related filemap_nr_thps*()
>>    are removed too.
>> 5. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.
>> 6. Updated comments in various places.
>>
>> Changelog
>> ===
>> From RFC[1]:
>> 1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
>>    on by default for all FSes with large folio support and the supported
>>    orders includes PMD_ORDER.
>>
>> Suggestions and comments are welcome.
>>
>> Link: https://lore.kernel.org/all/20260323190644.1714379-1-ziy@nvidia.com/ [1]
>>
>> Zi Yan (10):
>>   mm: remove READ_ONLY_THP_FOR_FS Kconfig option
>>   mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
>>   mm: fs: remove filemap_nr_thps*() functions and their users
>>   fs: remove nr_thps from struct address_space
>>   mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
>>   mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
>>   mm/truncate: use folio_split() in truncate_inode_partial_folio()
>>   fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
>>   selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
>>   selftests/mm: remove READ_ONLY_THP_FOR_FS from comments in
>>     guard-regions
>>
>>  fs/btrfs/defrag.c                          |  3 --
>>  fs/inode.c                                 |  3 --
>>  fs/open.c                                  | 27 ----------------
>>  include/linux/fs.h                         |  5 ---
>>  include/linux/huge_mm.h                    | 25 ++-------------
>>  include/linux/pagemap.h                    | 29 -----------------
>>  mm/Kconfig                                 | 11 -------
>>  mm/filemap.c                               |  1 -
>>  mm/huge_memory.c                           | 29 ++---------------
>>  mm/khugepaged.c                            | 36 +++++-----------------
>>  mm/truncate.c                              |  8 ++---
>>  tools/testing/selftests/mm/guard-regions.c |  9 +++---
>>  tools/testing/selftests/mm/khugepaged.c    |  4 +--
>>  13 files changed, 23 insertions(+), 167 deletions(-)
>>
>> --
>> 2.43.0
>>


--
Best Regards,
Yan, Zi

