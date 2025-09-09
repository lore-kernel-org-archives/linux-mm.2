Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D50F3CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 00:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1168E000E; Mon,  8 Sep 2025 20:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278948E0002; Mon,  8 Sep 2025 20:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DC18E000E; Mon,  8 Sep 2025 20:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 038FD8E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:59:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99D6FC0364
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:59:39 +0000 (UTC)
X-FDA: 83867904078.08.B913838
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2084.outbound.protection.outlook.com [40.107.95.84])
	by imf06.hostedemail.com (Postfix) with ESMTP id F17FF180007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:59:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ASVUBexl;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.95.84 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757379577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eUjGcPl8eDy7DtF15L+5aNei6pzDbHKP3JcnOuIaH0Q=;
	b=T0QSeXop3RsRwqtf70mAb8CvzDOz1KBf9d7uVX9JfXPSbxdEnQc0UUJQdf02Pn+5sCQV+i
	TTb7jIvHz2cmVdhdD9x7WQuJ+WEXU58k+hxLptCl9IUZbax0sx/SQN6KvcFKiPGpO9aAav
	NgTvrvlvR0nxLNlGtyaB4ooET6lXiVE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ASVUBexl;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.95.84 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757379577; a=rsa-sha256;
	cv=pass;
	b=dXd0SzeEwOO41asCo91LjGFF561fCQQHxwuI4XLUqyBJDSg93DCCoIwl9ws9Sh9OTvXEnh
	NlmrHxW8u+J9+H8fEy3gndJ+aOCvnafmVwADo8EHx1UxUja0uT6KayThJKdxjvsyPkIn25
	6ehliQHeUAFmsezoaWnnj4ltFx18QeE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XmmGQuAO3Y4Rq8zYimCyqZMBn0U8BPo2sBrbznlt+bWORkyiEF8CV+nLjYIkTgRcD7fxzkrpRsE3sGk3iW1SVQ+Fv2ZkJUgppuFcpYre8ElzWS7tE1JO5oJkE6zO065A2ML8fu7cKMc8MTBslcTmtDaHrp9P/GC6Cds/c9E+MjtAQX8hBV/WVC76eDbYjF3z8SZrwzV4p9sUWqurMwqXkl0+g+fxkKxuaZTTpG1/7a/0NmuJExCsgQl0CAOnwgNfJCIvM7rRqhPhUarthyqpwqPT2WwRG30TTfa5cvjVhVtRavhw6C4LxgHjGxQcJp4RYxfU/nNHpGpfLc+LZ99YKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUjGcPl8eDy7DtF15L+5aNei6pzDbHKP3JcnOuIaH0Q=;
 b=MPebiKOZmb+JXInHeLqOUKYcKOgybIEr+OC3hNtuS2/gLGr2u0VtbAgk0o0yiP8Ol1KijBysGf6spS7NfFVQZhnwZ2ZxsV/INAR4pd+/pwLWe8O1NrLOIi7UIoA2wrq8/VFUPrSE2LpdoWI/DtYIuYONURaPvuo7As3J8uaSbYSL0d+W3z6uTMtpvtx+qXtKxXOViKC1sm1b3SWiBWuuUFJdm4F4iUHIuzOaqY9b3JcZchkWNxb56bzME8lzzHt0Rr0MTRn0HcN1Y9pjyLGyhO5X6/6QQzjZXzqM7E0XKW1V7Bd+SBAROOQsgkucEuGweEdIRQ4mb9ysnt1lfatAZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUjGcPl8eDy7DtF15L+5aNei6pzDbHKP3JcnOuIaH0Q=;
 b=ASVUBexlqTQYvHRxgGhI5jFVFmER7U3xpIEUoLr1UOZ/DFw7R87iBBORcgI4qWfxychkAEtKQT+VnlYsTRc3wW37Bkn+B9l3c6xD+DOKlmE11BtUHh1rk22w2RLAhoWyW3heZOV+CAhVC5Ith2RK9pI6jfgERTC3r8GOQv3P/iUiVOOSsdsOwBsutjLn0SM9qMhr7TD4oRSsv04qAwmSbcxgA77UC5ZNfMrF7JI9e/dAcP60m2zVn24gw4rZJKYkgqLKFnUlUlDAM+CEz5KoLSkRliEzq2+glA3qUj87tiB9fUyqfDVG1DtcG/LOC0IoiHBJ9xbE4AjhI9ox6w5/dg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9611.namprd12.prod.outlook.com (2603:10b6:8:277::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Tue, 9 Sep 2025 00:59:34 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 00:59:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
 jane.chu@oracle.com, Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 2/9] mm: hugetlb: convert to
 account_new_hugetlb_folio()
Date: Mon, 08 Sep 2025 20:59:31 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <6AC39123-7AA8-4B06-8D6F-A2EC084B371F@nvidia.com>
In-Reply-To: <20250902124820.3081488-3-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BN1PR14CA0019.namprd14.prod.outlook.com
 (2603:10b6:408:e3::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9611:EE_
X-MS-Office365-Filtering-Correlation-Id: f3f2ffc1-e94d-4d1d-6264-08ddef3c2426
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/NJXFsHrKNHKxBS5ag+vs8Uv4/lXzj9xIqIWp6nl67YCS0vXurmMdUkAHgW3?=
 =?us-ascii?Q?Yp3qkd311l1MdJmrCxQXHQhNTJSkXAtNYDfgNNmljzNFDqVz58vjtAMnZy8G?=
 =?us-ascii?Q?dDXe0vQ4phcycpdn8SlzNypkgrJ6jl46+zdA7A0fuMTBVsbpVfCoVVTziLVh?=
 =?us-ascii?Q?pF7w0Vq0lSmbLdf1y0FvzfdhVMQKNvi166bPJF2f2fwAlIp/jRh+P12ibTBZ?=
 =?us-ascii?Q?sDvnMiV2pBJ7CbqIw9FV/KzMxKfz1luTD1/BQi2CpgqMLxf9Ape3TIAVk2NI?=
 =?us-ascii?Q?UYSToLtkydMW6o1mtReD8NbypBXZck+sjfgy+O1zsGSakz6GS477vs+88WkC?=
 =?us-ascii?Q?d2Om0J3X4n9FZ+ZcoT/hMUOFr3Xw0lmoVkXVZdsgKLDtuBJNtdHWGAcBkCu+?=
 =?us-ascii?Q?KwUj4bAu1PQQhEdPCX2coE5t/mNQQkYYvTv63NQ+3WRWnRSj4iQGt2pDedQZ?=
 =?us-ascii?Q?K6b+aDZ7qwMoLIpakx/Y26w4dnZzIcCmG8f5WpGRH7z13/ABEdF1BnbLTHOq?=
 =?us-ascii?Q?o/UFhUsI7LPaY48gbjiw5nqwmLLt4tOzTqd2Hz0amVA/cxw24KtnR4oatM31?=
 =?us-ascii?Q?A7XcfpPEZNM3lnkSK6H++zHAfAMXuA+Yc6fX7bmr94P8r+IDL53iaGrYhN5D?=
 =?us-ascii?Q?E2ZBIJtgAB2FX50NO29XaClMWIPW1xPuJcukFVxmTUrtbMhAhJIK40QBx/P+?=
 =?us-ascii?Q?R7HaS+1RwRSi6XCaTFu/le9p7lljGi+BRtpfNMq1QXgAxUybohedtNqizRr7?=
 =?us-ascii?Q?hdJ7yaQkMOgaf69io+xmyAyF1YKpFC47Tyxv0nF2hyWn3CKSorf9QUTgu2jt?=
 =?us-ascii?Q?VP5lfHEwLPA0Uh5REAfHTiAn+4DRCV81EviiJ2+3lmDq4rSHaFZUjB8pAOyJ?=
 =?us-ascii?Q?nRhn6I0FOnQeprpJngnOwlCgI/hx+ezmpBfApTuca3Aa5NckLsOmN98Ujm73?=
 =?us-ascii?Q?6J+ugQxjdA9GkOFx3UUNwFBxFbzrVWWzsg4m3/bfEGSdbCE35juCLhCL+5na?=
 =?us-ascii?Q?dTpZcVxdfpLvjeoi9ssph84/tBlDYgMHekR2WHbDxO5I7lNG5PF3zauXKiCX?=
 =?us-ascii?Q?2nDivugIsfkc9FQe/2rHIjYRY2guhjK4noTEw4eP7at5/eapJBbvDq6W74zQ?=
 =?us-ascii?Q?kDk0dNUVFL2n+2D4nVxKO/z6vA/YEqa51DbvqkIDI2XKwxqzbOzVQpIf2Z9r?=
 =?us-ascii?Q?3ppTqxdelRxqG8VsV6lymzzhqpprUY18gHv96ezzw1XvuBBmlNKIiz+o5e/v?=
 =?us-ascii?Q?azMAryWMwI9FZ4wMJ8zvIizD1cFnyEoTTT9mzZGbxKU5RiM1a+NMediC5V6Y?=
 =?us-ascii?Q?unVOKliCWeD92lC3Mzt0gPYnIJ2a2+63QVkCuCEzx4grLildAu+ubWa9qznD?=
 =?us-ascii?Q?CvxTsI3GT/T/Bm3g22QpYzdC5tCq1XK/yhpoGJAG6cE1PNCuHsTk2iEGUSh3?=
 =?us-ascii?Q?Bn0XtWj5wzA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eQyqCMwTKr1V4sKDkrBSCirfxokvOPqNLu3KF5sowdvFA9H36bgnLObbN0NF?=
 =?us-ascii?Q?nZ6XbDlr7fQNhMU0zPeCaEIHLroC0qtUI65GESOntvtW6n7MkAR7MRGiG1ZO?=
 =?us-ascii?Q?tPbpMw7n/3zQHiy5Vx8F2cC5ZZt5/SZ5JOTC+ifHSAJL2wITCE/8ypU/6aQs?=
 =?us-ascii?Q?Rd/Y/C8YZsYPH6vrvsxkUWC0GQSiFx8SlKV6R4HaMN7b8WwY2Z7r3zrTYlCu?=
 =?us-ascii?Q?u3waAT/Hlquo+SpoBXQG5c7oGWnwPNBklHk/Q0w7y/vb/+9N2nWUjDHwK5/x?=
 =?us-ascii?Q?5ucFNDydJKfn6J5fI87bUAgWndslBnDRTNmxu9HNNH1gQkERZSfWFCgf2j7s?=
 =?us-ascii?Q?lUg8Ho/ERRcmv+w1NkMqZvcFwnYXCW3HtMFynx+2T+MAVOvWraph8Jl0bJCX?=
 =?us-ascii?Q?nNtAXA4QrnYCkPOTBut2Qaj/RgkXDNIYptapNWdurHImMKfyjQ0W6CC8KvhL?=
 =?us-ascii?Q?CicJOl0c2RClqL35XCOmPsPoNNsFB1DIap80YouxsZn23od00udw5d1WYD+g?=
 =?us-ascii?Q?V/lay3t5uSshBWC3r5I3HpIl15sM7FucFW/9nrUD5x6UpHpdKE0rYjpZ4dgV?=
 =?us-ascii?Q?MhBcEdHxBHpHubur8J5keY9QcsovqTB01/aTQ+E9kG8BW8YCIuzJggvLPVJx?=
 =?us-ascii?Q?HZtQVJW9D60XZ4DjOyxwLIGrCaqEYKcJwA3Y3GakaO//A/R+/IF4hM+24irk?=
 =?us-ascii?Q?F+ar73JBuLyXrPo7WF1Tzna8Mg60be8uAOyG76k/YZbWZPDx/fzph3cr17ul?=
 =?us-ascii?Q?bcBP8HT6/7QR4pYOI76RFtk22hfxZLyMemRTwO4eFTSHIKFkDkBFpCrYT+8t?=
 =?us-ascii?Q?AxjXMminOQM4DH9yOPSSJlUphxwa9FbP2vxOJdyJseKT0kU/gaRapp0ITgN5?=
 =?us-ascii?Q?ZvermpMY5Z0n8vL4ggmikJKjSJUWMk0u3LD6O7AwVUEOuifByawKPjIDL0j8?=
 =?us-ascii?Q?bjIoF+qdfJfyon+NQO7G9PqYg8s2D55/27mWbEOM0A3T7PoiEmQwjDXs+zzF?=
 =?us-ascii?Q?b5epwtttJJ3fF3eyBXDRXMliSuhDRBUFj2aUZdYVTmpSM2d9P51JhPgqK6W7?=
 =?us-ascii?Q?2nLDgNTCwsV0Fv0wFNwEIa1bX5sTaVICn94yHkWmnpNHVWyVyZIGdOCjgsRG?=
 =?us-ascii?Q?PImjxRQik046TTfxLdFQ6ROkWT3jwMnTmfXRNPtH1h/VzUtIlB4/3654mhrz?=
 =?us-ascii?Q?gAW5SDlFvShofZdzSVBUmQUb8QVa9+sKELf4dJe1kN8DZ4RSFM4sMDPrksrV?=
 =?us-ascii?Q?M15iCuVm2VO8hy/f4WTh3yJMG8jEK/pw1s9Fh/Rqq+h0GNc4y+jiN7lxcJ5q?=
 =?us-ascii?Q?Os+Mlm+ZuOf7RyU7S7+KAi57eljSa8lzRDEVQw9IJff7QB+UFysbn+gJMCu+?=
 =?us-ascii?Q?vebnoZxBfXltNUjH9zztW8BUwIYYVYweNfE6tWeAATAvEnFm0L1McpCt3KMY?=
 =?us-ascii?Q?EMrsr2B0+AoMMsoOiibbeYg9WDIT/WTn458/W+LnwWiZQATvTGCzJMd+b4/l?=
 =?us-ascii?Q?2QHTZXX5GnyLvpEq9E4VzfGGgBm9DpohYuXVR95FM7ZAzAqQtxnZ8cVUgF3v?=
 =?us-ascii?Q?/RyNeRemctMitU6xLG2fCGf0FVC55f3BcxizLf6G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f2ffc1-e94d-4d1d-6264-08ddef3c2426
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 00:59:34.1446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R//ElCWvu71C5wcT/Y8Xz8IuGHBC0zkI1A+Yp3Zy0LJafkhn8C7bVcEcyodAtghI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9611
X-Rspamd-Queue-Id: F17FF180007
X-Rspamd-Server: rspam05
X-Stat-Signature: yisnncqm63rf55xfxyfjki43b7chps61
X-Rspam-User: 
X-HE-Tag: 1757379576-368854
X-HE-Meta: U2FsdGVkX1+Jge4DA1RgQkjSQ2xyPuo2vT4JTGbpTP121iigPVJh3VuDDN2Q26yR4/4vaCbbm2q18Gux5DRvYFfuTQvk5tAA1R8EyjC7vM8cXbl+OFVOxpt8RnEVs/u28ltpVt0VOHIQjD7HMISMscR867mPYUoO/VX/ga4VYB+yQCNZzsIuDOv8L06EHX/Vzp1H+NlMvIA9rrOehrPZno+f/7uS7tZ1tRW73J18WeLSqmhGtBhoT3B+Tb1bhlfEPPr2aCdxAwxu3diTTvxBmRyV0vIwlSCXr2xUW3L7+KdoPKEb0WP20dwDNcM848Zxivh5LksnX0iEFzScMbbGiEtwLhhQPBzyzuzkmHucYv1Zo+YQyUwMlcKYNcvquN/rVRHRPYLIcKIjXPf8ie4se13PKFUE8NIJYoQ+fv31kXs1SQ53QG17WdJ1aNfyoAIlIrnsWa0H5wfVHOz9dnUr7ZGArgdrNbahKgaOMwfkw2Hw5+g8nO33mDVbRhhFLrizHP7/euWpCwWwVvTbFNTqySJ3Tl0fiWYPUgWJEIRatXRDYIYOAdw766KR7xYk6NdzuD+Tj5ZrW9gwxb+SkGdNg+AexiedWfoCr9f8LE+CffRPvjs0zhzl2NNRvhazKigXQFOA6tg5tK822ZEXc/aqrFkXTv7WubTVp7OY1gTc0RJH8v7+gjpqTlyIRyS4h8znKIWNE0UTsu1ZuoV8WCar0p2zhnoemTlVavIWVJbD+PEXjs4AoFMS8Wai0aJOLdAfF/8p/4Q5zou14BZ1e9d1EFffWDpMEhcXpOpjlsbfpEQlz/GuzA1N5SVVuI5wamLtnw/p86fBuuYNAbP2XdBA2+WPnCtk7DaPkR3zce24J8B/PfpFy/AbIH4kzHftbLW1z0Hcha/SB6C/mXwRyx1k1vOsfAxcnOQEIU+ceAbNEHP5Evs4hMt7XgtrBj9O/2KtCoX6naVVwmllo02WJjo
 wptPKOQ8
 wW+iRpNTBwRIJF9VQpz4swzc691d2Lu00/CJr0xYPbfHrB5SX2gaGAFVjFbpQeEsBap+1t1RnZ4nox1yxxKKytXXHQxnw6AdHHzx351eziHIFqk4vfv4E5iP2pdZPdflec7KtC7rJxJ1wAnRHRmh9BvhLLmzQs6YaWUNdCzCedVlG4wYjX23gtiGq3P4XMMOYfxdRsGOGAROvzRIrwgOAx29yiwR5cvOasS9DFsLOU29foXqLhNnaqHszTSYcneYGGi/5COUfYDSO2rqonPVDSCKpZlctfRvk5oCixgiqpNvzECnYWJbAYn89oWXnz7JOxCtT+z06XIyW+tAq8Fvals9zy2+c1yHSwHAlCRClqnvsh2n1YqwHz6DC6EFocb8VeDoLCqBiRD3A1jQ9HIJT3VIuaJapEN3nhODDTvKG00pYLcxRg0NF2gGCnugIhIfhh/i32fE7VoM3B7nhz00xdE5Q9tlR5tCrrUxJvjfT2t3JOu2A42iuYeNFrnanHjO24O+D5a+B181HACiwX3OHZzoVBVb+uGfyUto4Yku0cUoceQ0ucnK0k0fxtaZrkJuZtPS6qOLRAOeZ+0Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Sep 2025, at 8:48, Kefeng Wang wrote:

> In order to avoid the wrong nid passed into the account, it's better
> to move folio_nid() into account_new_hugetlb_folio().
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/hugetlb.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

