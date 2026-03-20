Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B5A108B91E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 12:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7496B008A; Fri, 20 Mar 2026 08:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40D96B008C; Fri, 20 Mar 2026 08:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6956B0093; Fri, 20 Mar 2026 08:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0006B008A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:47:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E50A894FF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:47:06 +0000 (UTC)
X-FDA: 84566416452.15.AA3B1B4
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012042.outbound.protection.outlook.com [52.101.48.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6FF864000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:47:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GMg41mr+;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774010823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b96P6ZRqVKe9uAXEcRTOQRIBJdOnGMjZ8lxWZ11+u4c=;
	b=DZUYBosvRoq/3oXsavHAaaE0npTp9F0CCnae/LPBZrKs3TR85hY2hpCLsw7QrJCZbIrNjv
	6gL3zLHyHHxPLpAXFXh77FrrMPVoy2Tvumv9zR2Tz35ATGbVn+wRBHv3SMBcCbkQinDSma
	vwS4RAZVy26HvA1zfGfsQLCEl3Zgcz0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GMg41mr+;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774010823; a=rsa-sha256;
	cv=pass;
	b=qDuv26rwcKz4YqMXpGFzHdI/o+6a3M9MaJ78BSo7UOQnTmtodWl+MF8zBg63I2wbT25vD1
	1PyzCG2oMxfPLDP+OV/6FwNoujL0IprumzVvsMTQUt7ajvRoEuw786jjVQBQlKkkoR/76d
	eUg74cXtDcAKM1iwy9NWMlzgL+hv3IE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oh1drfdGMKxx84XZviREcLVascta+MZtYZGlx9d/sOZdcu28UNWbk/xotwjW1PFtXoIcU8GKkwtNxNz3qTHc2YoOgvSnFZ8zM19w0QE67nhnAGekfmNCV24qp0POtKErF3/21HsFxGRUd96KEFcNWOthsgrk0GESgByAoAja0RxWzSlSOm2vsbjbFmgWdxVjc594TvroQdC/lSt4p/L1l/hWdLQL0xVfK7LxyuknoKVWdF8Rh/iGkO/FnYiH8zguH07+csGAR7j3k4dkvJIMFbOZWA6pMfcppUv44eEcrM8mLUw58WiK3IspvIwEQLE2Xy5OvYkwEB/VXqew0UwHtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b96P6ZRqVKe9uAXEcRTOQRIBJdOnGMjZ8lxWZ11+u4c=;
 b=KRc3cMMECqJjPTuPFKzH5jv7voYwTLHOiEW/kt1r5/MAn6230Il02SV7EJEpTK62I9+HcoNVHz92pBQEOJR5GEaSitoY6grMr+R4kpHjvuuulTjyPSWUDC0Zl43vFYUWuufnfKoUyiKxOfRfvGWVSN5wuMAIM51JYGtM5j0W6EII2hPW5pViGlaHzo/iFMNxeWH7Ee7cDF3sqbNFEk+g8GorX+56NsGFmh29Wbiy9T6dCv2NWGrP83G/vyaLlU7W+mVx3v+HlBQOVa1z2xIk/cJ/XzSJrMprnjkwTYzNcfSHN2UQPPe5elgJkmBVWpGrf9tFqX/d/Fc3W4KRttFV4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b96P6ZRqVKe9uAXEcRTOQRIBJdOnGMjZ8lxWZ11+u4c=;
 b=GMg41mr+ShYejcSt9CtCXHJTDSxhIzkSlt0viM/c7vTuSbeWoKZv9I8x4C+Fp1EOWR94+5DT2Pc0R3Jdfs3++MmibhNwhgSZCJUEuMmbTakwyugHPwhDPUZ8DaahZw/6c+H7OmZVBz8QailBrRpkG07OsxQmummsrJJ4OYA4/QvT1P6yfwBCPYffTJzOm/TIRC3HSYMRh+2MF7XALOo/U5J1v53iseZ5z/40XBk93FuOF49nEJU7tsDmVQZ9NBpi+FOiGA0ieEv/wFiZ3TUgKIcp2/e4Nc0RoqkRxdeP6g8bEJEBzgvhLixdcD7pORbmwHMZq5xxpJnHibCfV8hhkA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB6360.namprd12.prod.outlook.com (2603:10b6:8:93::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.9; Fri, 20 Mar 2026 12:46:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Fri, 20 Mar 2026
 12:46:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Ryan.Roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, david.hildenbrand@arm.com
Subject: Re: [PATCH v2 1/3] mm/page_alloc: Optimize free_contig_range()
Date: Fri, 20 Mar 2026 08:46:50 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <FC8C47E8-58A7-4F5F-ACDF-CF24DB662D82@nvidia.com>
In-Reply-To: <8cf1b799-c02c-466d-9212-0e12a99bfd8b@kernel.org>
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-2-usama.anjum@arm.com>
 <220e97f0-dc82-4f37-b833-7160aee46cea@suse.cz>
 <703BB8CD-23D9-4012-8333-366837D7E95A@nvidia.com>
 <fde63978-d632-4196-b032-4cc20041fd90@kernel.org>
 <2AE5B748-C57B-4BC1-BF9E-6299CCBF295B@nvidia.com>
 <3883abcd-426d-4211-ae76-b5601ee728de@kernel.org>
 <54364b65-ffeb-4d91-918a-c1e4b0c92816@kernel.org>
 <8cf1b799-c02c-466d-9212-0e12a99bfd8b@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0271.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB6360:EE_
X-MS-Office365-Filtering-Correlation-Id: 090827b6-ac2f-4657-c337-08de867ec57d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yd6swCiEgDcY/jpjuKUgC9Fyu2vf9igFr8ybl6gyPATYCP13OnFJINpBXAOVXB1T2LkqbwWGPkSRjm3DeRZ3f4NVzf5MpibgERKInbiVT0sXfdkGAlFOAkABgGGsps6Ojpc5+FKml2+eOu1/QYotaqbMHTXsjvIpZZMKwVxRQ4jSfGdlDCdH6QER4I4x+aiAOhacfDxhQIdqHIxR9m4yWA2csLfbRjaiqqNT/4K9oPJFAISzeAYHlKLdhYjwGH7ombK/cc74IaBj/C6pxbirHnKwb1vH+VYgNHULaX2yryYcj+Dahckv2BV427CaoaHoRarScbTGo4DDvEoM2t72+OrozsQmBUzmfvod5+ggEsqMR39LhA6blW8ekG3nYEa63OzjPDo8LvrcMuLMM323M9S32/7JzoyP2U8mLVZBltPlDbAwf0nQszKgv3hr3pAmvb28TxolKdb2R6r4U6Ojr/HPLLjBlP7ycgTqDlEL3QsecJ1A53B3e45S9fWMStlAClXQO2x4eTeTUGnk3WeooqLzjV5n3eMy9PGUFfgZHFKATMpbTHghwYm4tdPSsAU0Z8sg0J1WgQQoLIIHz+sDExRQrPYEGdA4XZkLdy9vwCdx6JoPJNyGEiWh0mb436UI0AKCCF21XaFexyEYItw2xY2l/+bOpVpC4Ldkzu/GDlvVjS/y6LCGgR2KOw6F+jlXNEyABQuw3BkP9V4gepD230vgNBqTkGE15ujaydIgGjc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s7DGPP+dOAZ+cknVEvPTTtZyDfTTR25+YGkcnuNrxAFACG3Zz3ARWk9NQF7g?=
 =?us-ascii?Q?F7o9kJs6E89vVXUFyTCjUccUpTq+yHiy8fBiWuGGJus19iiEkmO+mGSZ5ig6?=
 =?us-ascii?Q?/qlFMw+RISngMb1lzyF/bJMUN1aipsVma+ZueYVtBNo/vIXYkcdHKNH5w7KD?=
 =?us-ascii?Q?q7kSGBqgsmk5A2jIhyBfBFZnDJoVVoxdAUBVgBunolFyZSwHj8CzjCyWHHyO?=
 =?us-ascii?Q?5nsiiyVWAxWtnUPQt3LRot9U+Fm/JwqtsDL2z509N2W+DwOqM5JyhZNdU487?=
 =?us-ascii?Q?xbkfTqGdTVA3RXjJSKBS79t79kf8x3mjRJ4FzZQLy75gt3xJ9JiBSDau3KMr?=
 =?us-ascii?Q?0ief4UfjK82+x9v6BP0w2jll7dQZx1DU2d0Wy5xqghGqVwaV4pMN27fURQWJ?=
 =?us-ascii?Q?7kRLTX/ClTktNNI6IpXSjFyHKQEMZjZ7jn4+WwNAkR//gndO44Wk1+mZWUFG?=
 =?us-ascii?Q?T+VfWv+iOH+fXjnjOROxiP0yvtI1pU70hyJp4YwfWq18UhS4xM+tUeZt+OPN?=
 =?us-ascii?Q?OoXynnFsnj0e+DIFLwDVXVnwK+SisFSPK7qvJgIAafsM63xq4xMK3RC51wfk?=
 =?us-ascii?Q?AqlHwv0OWGeVegmcrZKFPmrrt00duivUFpOI9F91Z+r6os5/PmaXQoG8LHM8?=
 =?us-ascii?Q?1GexQax27LvTGBctEM82vQ5KMtmKYTfFUr9l75IDycCeG1NL/P4KuE34dxVb?=
 =?us-ascii?Q?WLHO2lawvM6Xd8L+2MDhezqIlIlJfRuObdKX25wxOmzrg5jXDfOtD5xpbosl?=
 =?us-ascii?Q?SjDfyJCKOY94YPJ19MPXUL0KffvM88dhjtywLhn5iMELt1ngMN4Sj0VQeZKm?=
 =?us-ascii?Q?2P2ZuQ48LXwb4vZbixDkrvEu1hj+7vwf0C/5K80mUUPNjUxbHzUn4qc9Ggdq?=
 =?us-ascii?Q?eFyJIE3ElYEvS4JDUJyM3l4egtuxKllK1LmfqSX7kH+G/E7+lpAZJY6anNS1?=
 =?us-ascii?Q?hFgf+uflkLRiQX91x+BLV4HxLjOsIMj3N8XWDWjofurXq+bm32R7ESAqelVX?=
 =?us-ascii?Q?VCQVAX/oNhJYMAuJHzB+NPfibZfhhj2sKPSsicwesQooa75kMuZWBYj4AlNL?=
 =?us-ascii?Q?aPqC7/IOiAB5C3lM50Tayvp/g3Uq5HATJ4MVxEiFXdgYCBQ6l19tBwhPy+Mq?=
 =?us-ascii?Q?d88hJFqtm0x0Ox6xqEeWhDj/dXMtLku0NZofbjbIqn3+6RBYZx8V/2/oEI7/?=
 =?us-ascii?Q?YbX3udVhq1iHPbeNRWu2Q0YXZ5s9eeJIvYkBmo0KItJmqZbz5HNsqBSFnOz5?=
 =?us-ascii?Q?hS8noq2bZrwLQk4Pi5TcpnsxNpJPplNOOCp7RQpFPIM1Sod+1h54hss35dvW?=
 =?us-ascii?Q?1IiWYOvcSo9XqO946JUeJL3e2CZPe2fWlt+SC+k9ZaSw8s02hUcRdqBOxuQ/?=
 =?us-ascii?Q?X7TF85vbz/kFbvmnh45Anx7kTaCjSrTPmVcdDHAuTI5FA9vYDMosufv6qX2i?=
 =?us-ascii?Q?yVgm6cbzhF2P/91c1x6UiojEbE7P7nNajhcyAoD41SCh3rKUiiUsKG1BumMV?=
 =?us-ascii?Q?ufbH9VFn38PMO5fxcHEiSRGjarSqjqUq0JTSVbFy2Ffqf50iGYWkYFzrDs7B?=
 =?us-ascii?Q?YYrRnMmCLIQvlXBEbKZ6bEg0JapqGHLsRWHDgeWBh5ay83zwUQjl+BTZl1ik?=
 =?us-ascii?Q?CX5c9PVBzZqXmpZWul1LWKMo84R+6XGzl04hQg4ZjB+KN3iMyKxIpKtXNdge?=
 =?us-ascii?Q?r07a/XmxKM836hqAJGpBZ7wUzLYfHP68TTdSj2hvk9ZZM8ENKqfpb/s6NJfj?=
 =?us-ascii?Q?LSDEcaw2xw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 090827b6-ac2f-4657-c337-08de867ec57d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 12:46:57.1707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vGkSSiCbbbY2QmMWuE1HkotMd43DK/y4+P+w7zhZsquCCsxWuRPJjJDRUv3Joap
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6360
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6FF864000E
X-Stat-Signature: byr7ik7tcpycakj94ff5b5s1txn3o9nm
X-Rspam-User: 
X-HE-Tag: 1774010823-399933
X-HE-Meta: U2FsdGVkX18azW8qWi88C1U2g3hWRrh5xz9YTrbjnAPKQvBFOgXdx57gaYVRFIHFYUzZ18lVr0NNTywP+sjsKDx/OxtbqG2tRdbP8M7dpHifDLErDdYkcy5x7fS0SPYqRzY7Zb4KF2ToJ8QKGsUDCt60uwpsj1ZlHvAzgS+SWm8lFlA/H9gcHdh0ji9x3fPG2cpQWPtgFyq9LVW28DObhEgPCCvJ1nA17pB8qtm74z8IzLg+DdCt0mGXQH6u2Y4uwG/lOyFWtJVFRcJYsNp4DdLi0i6B+kbC1akKdQC0e6FZjdHyxADM8ippYLjTBcCywQ25enbAgaCbJANLRsRiYg/CWcFDMXs3CwZzu1q275PJRtIEuM2C3YbBHg8lpHKYbQvYDJGn11Zi1Oisblsh3wJ2+7aen/jpCY6cvKL6Yfp85jvXaFUrO0a7g3bn4qb5MNbm23xvwhYVcLE85y1zN8mWZMlhwJPkkh5XRW/RswRS4kIQzaNSPuiS5ZIqBA0igz7BnEfOuHwErtRY+wJARS6/dzm8Dmp03FkA6wyIVSkWys6VOdISuCosgMs2O7Ir4uBr/blTVbd/oxvcBe6Zb0jv6gSwrgmucHAEWg4Vx6DDhMpLklxi3jmx/VsTFO+uReZ3j3oyxL9ExQfT/TNjKXV+Ac4Cz6d+rLiWrB6EiPiSTF+fyI/lw7KYV0bgUBHszAcwKmU5RcY2PLiReF6QFU9DzvV1W/AYv/l6utuLkXzBA3q4hqY5V6UxXtQi3inJ+YhlTBozbhKPbNV0reB0v8T+IYXbIIV0fp5pmCveGZtbEBMcGWUp9vorJ1fvDIRAg/sAEBn+vdMnr7OCOXqo/+OCdjvszcVXXqysgNplQqkXWA3q5rOxkMJu21XoPM4w/e2h4eFOmRXVYzwRYm7B9Z42h/ZAS7C9wyYqnOq+OLxOfpKAwnLnFEl60DaG53Zw/kr7CPh8cSmlyC0Ed6h
 anXttw9M
 y4udG96jrIc28sXb0aFMgYUBJpV+as7PGqfbLIS1DnDWT78s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Mar 2026, at 4:20, Vlastimil Babka (SUSE) wrote:

> On 3/19/26 23:07, David Hildenbrand (Arm) wrote:
>>>> the allocation of non-compound order>0, like you suggested in 3, we basically
>>>
>>> I suggested we'd take it away in the sense of not producing order>0 where
>>> head is refcounted, tails are not, and it's not a compound page. I'd rather
>>> have an API that applies split_page() before and returns it as order-0
>>> refcounted pages, but not the intermediate order>0 non-compound anymore.
>>
>> Are you talking about external API or internal API?
>
> In this case of alloc+split, external, and that would make sense to me.
>
> In case of freeing, the current free_pages(order>0) is also external and I
> would prefer not to augment it for this free_contig_range() usecase.
>
>> Regarding external interface: I think the crucial part is that an
>> external interface (free_contig_range) should always get a range of
>> individual order-0 pages: neither compound nor non-compound order > 0.
>
> Ack.
>
>> The individual order-0 pages can either be frozen or refcounted
>> (depending on the interface).
>
> Ack.
>
>> Regarding internal interface: To me that implies that FPI_PREPARED will
>> never ever have to do any kind of "subpage" (page) free_pages_prepare()
>> checks. It must already have been performed on all order-0 pages.
>>
>> So the TODO should indeed be dropped.
>
> Agreed. But maybe I misunderstood Zi, so that's why I tried to add so much
> detail about what I mean by what.

Ack on dropping the TODO.

I was discussing about whether we can have a better interface for freeing these
contiguous pages instead of FPI_PREPARED. Since FPI_PREPARED adds another
form of free pages, where free_pages_prepare() are called on all incoming
pages already. It might be a separate topic. I will think about it more
and come back later. Sorry for the confusion.

>
>> I'm not sure I understood whether you think using the
>> __free_frozen_pages() with order > 0 is okay, or whether we need a
>> different (internal) interface.
>
> I think this is fine. But I agree with you above that this assumes
> FPI_PREPARED and will not have to deal with subpages.


Best Regards,
Yan, Zi

