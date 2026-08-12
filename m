Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 490D6C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 19:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63846B030E; Wed, 12 Aug 2026 15:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B906B030F; Wed, 12 Aug 2026 15:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B039B6B0310; Wed, 12 Aug 2026 15:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 752FD6B030E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:56:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 620B6A03FB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:56:26 +0000 (UTC)
X-FDA: 85093674372.30.FB393C9
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010039.outbound.protection.outlook.com [52.101.193.39])
	by imf18.hostedemail.com (Postfix) with ESMTP id 82EB21C000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:56:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XA2ypsWu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786564583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRExcEF/V36wntGX7mUUKZ++dBNiBtagfioIH54vRzk=;
	b=wx31uDQK98eetB6xPS60otUSA9c/rik16E8dkKJ0KPtl815/MwF9re50HCr7HeFk6O6vkT
	2g5k7yVZWh4tJXRTH5nMhmxyKUwrpPEmnHqKwgfu6QXOpiALYjZZ2XYWJrhGYEYrbpk0iq
	LFqoZoPT+EuGrVaT9QaD7+zbVV5fblc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XA2ypsWu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786564583;
	b=61BXoBBxzgNHOKur+VKsz2e2VRp1ljgohRCIakJ3BnmJZ2s2qiG4QLJptYWUfjj36FTnAz
	OP2wdmXXOD+fX1MHB1cS1I9s9JNFEQyPO8HLClVoBJHIHfum5v4Hp1x9/fpsVehZ1H9bT+
	F6hgbUnRjQ9hwOsUCW5FI280j4ncsN8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x9hNvGj+u1MmgH2BjtSvM87OzhInCHCEt7NFYq88hE3afXKFailB0di8yGM86EUnTq8nHIf5uPjDPCyqgCHF4yUY//rXgL6VA2IlhQ1+7LxDYSFoieH9xPAQer6rCHZc/445olqeiwxgoWrfmGVlrkpLOxE9bk390FLfAi2FlZzJAtrf3VXso+w1+oO69GH953kvap+vRRwUc79QxEIJxB0jHGZOYR/2si3eT9jawbe9wP4a5wmuTzUG1AgUR7R2byTwVZhgMTkz8uqUMu3PguoMYzmaPxMP8elAYOwNxsm98PtjAVm5XmfD+85468K+vkku+odph3SeTRHSVi3FvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRExcEF/V36wntGX7mUUKZ++dBNiBtagfioIH54vRzk=;
 b=FpyRG7qkmFumyC7aVHzhSubZKJTlW//dhJoZuMR6uEZAKNjdqly0y7Sl5jfu++Y7VtJsj2ws9bmusRlTxnVGeQRHfgEoF1gX+UeQfsUePhRp/QvaJZqIy/Vc+aaqb82nHWVMDaHUyfZYPEa0iNYdnHtNoEUqcxpoZVZMMS+lIyYuoTidpPcZOTgqK+3SMf56jRb1RJ1Ks/O5xUOSCk5JQjB+7E0c5WSIIFUtjSHWsgP5jlAfXD1cI3L2Ax5R4W22G0I6jFZAleC/ROu5CRrShH8zxYYQZIRNPUrwwZkko8Gk5SFA3GmiiuUdZEZPZlRownoeRpUBUET1RTYIArL7+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRExcEF/V36wntGX7mUUKZ++dBNiBtagfioIH54vRzk=;
 b=XA2ypsWuHpaVqoqj6A9I3nudRidW2sXHIjVCpuDDxW8PkifyqeMewYBcHDju/vY6+4RnaTuKeNHHzVVl0Eu4RxVF8MIkVS9Sw7jdRQHe0eBM1G91EJdxYS3ORi7eRG19d0FzRLPrhFxRF7pgcdt6+1Y2I7zNF3xqjb1aCQ9ISTAmkJQgMeN3o4Q4sHj1MNnElMBcolmeatJ+j6Ps4NpX+T8L3ggGrdKX93u5vG4rNthfFbM2Qj5ho3QpmuJRVxh7p8r17q8MFfohZcmbyFUoisqBVCqVh/LrFjJJafCH28twQXNXNYWD7rKZSNY8zdrlhRv4Q0DCzLNBN2VxlgPM9Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB8135.namprd12.prod.outlook.com (2603:10b6:a03:4f3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Wed, 12 Aug
 2026 19:56:19 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.014; Wed, 12 Aug 2026
 19:56:19 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 12 Aug 2026 15:56:16 -0400
Message-Id: <DKN8AC118Y48.1O9OVYDAZ4L7F@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Zi Yan"
 <ziy@nvidia.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Mathieu Desnoyers"
 <mathieu.desnoyers@efficios.com>, "Matthew Brost"
 <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Byungchul Park" <byungchul@sk.com>,
 <linux-fsdevel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
To: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 10/14] mm/page-flags: introduce
 folio_test_fs_private()
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-10-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-10-142c97ba3562@nvidia.com>
X-ClientProxiedBy: YQBP288CA0032.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: 71f3a492-f278-46cf-ff45-08def8abc693
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|4143699003|11063799006|56012099006|10067099003|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	ZcKug2dx+XI4DDUHikn/6M0SWmSpD7ZAXMdnqe/xo/mlSy3wM3tMzGeoJY9sGyJvY197mHKdIUnJuTdLroNoPl2zw+r+69NcGn6yD9kmXQDLxKc4suzb3KuCNGgKgAJVFd+Hg2GUBUhtP1t+X91rLiyu4sHrUdjsdD5vovhWYTXo6xYgxqYcCChHngXvQYFgSLgkBQ+2rKSHVvOCqE9Cw53QPvhQr9bbABpiETnAhmixPsMhQeUCfrBKP6NO0X8G+oNRwPCyVWBInKCA87w3anw3/HKtIm+ylAlYNmWb7Z3eVgG4lEimQXIQAnryDoQZ6rjCNf9adogc7eHbnsGAWG+TYlxcikxm5D2aYO0kPzuqeA59Nbr7t+gj9hRx6dio9pFt8JPsnG5jsWZrN1aNZNQDWuJ4crxDwO01iY25YO16QfuOtvbpPoKAg8zlfSZxPTjyrg2k2/qNODPukXQSu5ycfliyRUuHDJuDJ/9UpRNuNzY8fX8xir6qnorpzM9bty/xLH0Et5EXgZJLgMik5h0LohG+Q/+WrBqEhylnUbXVr25AzhDVxcLDLfgzSpNRqBVTtx1lip5feqXUzzTAOCxSFdmsnRp0HtKFPt4ABTvmWfiiSLQc2lXczt6TotUcli9qHpC80WcyoMUV+iap+QjjebCbsWifU1tR/Dlmo176HE2YsI4o3P5ZAMhCI1tG2e0L69TfI8HSK2eUXYue8w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(4143699003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGZGMVNNTkQ5Y2phYTkvWDZ1OWJSS0RyOTY1MFRwajZsUmdDZDdHcFp6RkMy?=
 =?utf-8?B?azIzYUlydzN0U1lxZGpmS2p2ME42K2dsSHVqZDZvTkI2VW5Ic2VESFcxQVVv?=
 =?utf-8?B?VDJlQlZMM0JtamxTbzJPa0IyQ0lFS2JERWFudjd0ZlozN05vRE83b3J0eGtJ?=
 =?utf-8?B?cUNiRytCVHZWcXlqWlE3T2huTTFodjVKWDQrWGFvN3I4dUh3NFk5aEZSdVp3?=
 =?utf-8?B?NDc2c01HUnl0dmxpMVZSUGZBOStMb3Q4VU80SEExUW5DM3pqM01MSHB5c3oy?=
 =?utf-8?B?bmhvZlpGWlp4dXdiT2ZvdUpiNDZDL3hXUkNBMi9CdXk2VmZ6K2I1WjBJcUoz?=
 =?utf-8?B?aU9UTGNXVEEzOFNNYnQrVHM3djZ5dWx1UnVreE5YbGJhTk9KMWpTWU1VaHBM?=
 =?utf-8?B?WmIwWVJhbXZDbWRHOWszZXB4TVNFMzM5cjkxeUFTWDd2OGZSRFp1WHNQbnpa?=
 =?utf-8?B?eXlzMGkrcGE2T0VNL2JUa1l4N0Uza1U0N2hmaVZjU3ZBb3FCN29oSzliZ2x6?=
 =?utf-8?B?eGhjaTdaVGhkL3luTEhBUjZ0Z1ROUjhyMXkwMTY3TG5XT0liUzd5a0pWWWx5?=
 =?utf-8?B?QkFIRHFodXJzTDZlQUtTNGg2Y1ZCcWFaK3owQ1MyV0IzR29Gb0RXOFh2d3M0?=
 =?utf-8?B?dk1Xc2lWNDQxQ05hcm5wTGJ4RXJuaXlPMEV1R0lYWnJTUUhNVHovYktQVlZE?=
 =?utf-8?B?MHYxQ2MwSFlOS29uWmhLdU1zS3hZNTlBY3h6VDNhc3lBNGtMV3JtdjRhbmNz?=
 =?utf-8?B?V0ZZcUY5aDN3SlhZK3BhZkg5cVhWSkZmUndmWC9TSkZSNnN4UE1aelc2T0l0?=
 =?utf-8?B?ZEYyL2VBYmFRM0hZcS96cEJsTTBxU1F4S0hsTHA5MTdzQ0tnU0Z1cjh6QVAw?=
 =?utf-8?B?Tkl1SlV3SDd2WlFDVXkxdjF4VE11Nm1xL0t1MWNtYVpvMXpiRGx3TTh4Tmc0?=
 =?utf-8?B?VFJxakQxNEM2TitMbWVsSWw4YXdWMCtma3hCdEd0aDhVakRlWlZmMk9MRUZP?=
 =?utf-8?B?Nlo0eWJWMDJ4cGVZTUVFUnZZam9EdkdzbVlXdFFMNS9NZFEwbGFHY2h3WHI4?=
 =?utf-8?B?L3hwWmF6NHpYWkZlMmR0eVBKeGhuZlpaWHNIaTZ4UzJsNnR1UDNHcnIyT1pG?=
 =?utf-8?B?alo0ZHQzMzlRWDFuMjkyaFBkdjAycXVGQVdURERjSnVnZE5GL25VSE1sQU1p?=
 =?utf-8?B?Mmwrby94RmF0UTBxTTl0aXp0K0VadTVtTGQ3T1pGK2VRcjR5ZWpyVi9UYzA2?=
 =?utf-8?B?Q0J5bHdNcVkydUEvSkJrc1g2b216TFRUVktyVCtPMDBoVFNOZllyTEFaWkYw?=
 =?utf-8?B?VGxrNXZ5SmppRkFBMEttNElOTHU2VGtUK3M4R1BQR3c4bWxsNml2V2d5amUr?=
 =?utf-8?B?NHg1R0Y3clNBbCtWaWNTRi9hVmFnd0x3Q1JOL1psbTB1aXY1dHZTWUE1UU5F?=
 =?utf-8?B?TFN5ZlFIeVFpSTEwbVg0eEp6Q1dWM3QzOWE4MXZodjZoc1RvSjJJYkNKMEZp?=
 =?utf-8?B?QXdHZHFVNnVzbmZZYTlXKzhERFV0M1NmUjJxeXlSSFZDM3R4THZZUTdzUDFB?=
 =?utf-8?B?STFzd0FPOHdoZFQ2TTR4U2sza2lnTVpkZ3ZvZUhsdzNNa3RlTlV5eDNUUXA1?=
 =?utf-8?B?bmFmU1grSG1UY2s2T1p1UEhLSWdYU1huMTNVZzRSM0R6NWp0RUw1eVpkVG1P?=
 =?utf-8?B?d2VVemFzOTI0VjNvNkxUZzFZdlJPZVNBVWhnZW1SV0M0VlFJQVdWSVh3cWtD?=
 =?utf-8?B?VzdWN0w2NW15NnFvdXREUmV4VUh2bG5lcjBlOHdaZVd2Sk5abFFtOURrM0o2?=
 =?utf-8?B?S1NIYW5OdmQyR2JXMjFJdlhFUWQ2dHpPVmFBUUJsYWw4eWt5NXlBalZWZ0xD?=
 =?utf-8?B?aCsvL2wxRjFMZVlzVlNmSDNxOExKa0VoWjUxNVVyRkxlYmM4T3o4OXJCRWQ3?=
 =?utf-8?B?OTd2UDB6QXRSaHdEZmtKdHZLcW15NkZpTkt6M0h1OXdXRHNURS9QdXRoQ0tu?=
 =?utf-8?B?eUVBNmtRbnNPUFBzTngyc0tZeTlRbEtvOGlXaGtNZ0dxbnRzZ1pPT0o1bk1C?=
 =?utf-8?B?RE4wTDVpTHBsS3orRWU4dTJZNGRGK0lTa1FzT3NlcjZBZTJEdTlpSVhTMTJq?=
 =?utf-8?B?NjNOV1Z2K0dLMGZxSHNDc0NJRlVaMGI3NzRsSlFNUXk0anA2UWdJRmR6eEpG?=
 =?utf-8?B?SWxjRmFVZnJqQThCVkJPa3paaGJadkpwSytnUkdmekZVTnEyUEozWHJJL2pR?=
 =?utf-8?B?L2s3bEYwNkVFbFRKTmFCUDk4RUN1N3EzQmR4VWgwTTVRRHROZkU1dVQrK01r?=
 =?utf-8?Q?+mu3f26QnN4AtvUtCY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f3a492-f278-46cf-ff45-08def8abc693
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 19:56:18.9278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ScBJ+TV0pHN1su9uGEAJwd4p+srzXN6utm90XZotWn/TWgV5ChwTEbGLTgppW86h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8135
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 82EB21C000A
X-Stat-Signature: 7p6jfaz86r8xcme4hspsxz18ep7jsy7b
X-Rspam-User: 
X-HE-Tag: 1786564583-132045
X-HE-Meta: U2FsdGVkX1/ONud6J8FwMGYT+ep/IeLPCn9vW2+dWMjam6G2KIGA7ep57lSTJ6r5eCswCav9A4Fwo8dHEA8e0XNBNLPRvDVGnnol1VYPpYKod8KxhZ9RdaVbQ13hW9nQNiUqD5b750FhhM4qwFHeFg1cjUSmoFoeyE0e1LOPIVrhwEoWvV0NjhPHwg5qDxcAGrm/Bpo3VnpVgOTDXnEBvcU86yRoSLD5pTeqcbrv2NSiMAwGmTCTuIf7pKR1pH1158jMFTDrsZcsDFVNJRWg0V5KRx8/PpC++puzBVjys553gVQF/o5g1etvcHoiwIrhrZ/VnwJBf1KQKOnaU7WuRM3npuPY8H7jDOXabXQX4oyYV376H37PPM+p72ZgSXtk8PFHuOXw2fbDO6+PaWUIb9xcAg1QOb8El/VMd5CgDm2isl0lusuhB2gZhjMStPJ5d+aLN5aIzp1HU+8BD/Pw4wqFP11zTnk9ZMU8KBEH0oSsm4bQne59APIJzY08C8ZtDP4kihDRf0GjMjhWrnxtm6fVqpOSmX50T6IZ/eAr5+xcTFSbebAWesvVaNB8Qgmpyum0C05V71wjwMreTJHqlPYH9/oWQEebYn+fxY13r4YBwO87JZN5+UsVTs1W/L/jgIJMbBD3Bxb5cm/SGARp3cxc++f4HCtBwyy+WUadSPBgHOvwNPyRkZuwY8F+Tz82Gqwuviv7MzPAJWlTxeUaceNPiRyBphEm6bB5JwBScSV39watAxCbOCrJHXgFwqH5kBXbIiUNo0hR2KpDjC0+msY6IZRfQEtix0Sc6tIltj1LM7uYGD0s7MmWkMfM6TcZbkNdseKUb0qFLqFimj8fKFBdHPIjqvlc3QmlIFXiQH0ZBGjNEh5JMJF0bZo9jrXpVU0li03VuAGb8VpdgdlcHmQvJbEARp2vu45NBv5XwUHouJPnaTJvaqQhI+kt4wFDA2b+BDw9U/7aHsEY9kb
 N7/aUea8
 2oP+sxJ8ZRpU1AnZwRyZ2umJrxmesUawCWrxbmLJOsB+WhOZGQkruwb7I64nFO2WWVbAU6bflwW9SP68h1j91vcxXrlIMF8gmiyFCFRpCDe3X3OscNL/B8X7ZVgJPw/EaPEv9eOL+DFPK6G/y6l75jOIbZ2BY6/TOKA7gq7+QsHBcrWG5y4iTIc02MLkJFv/PcGisgsrUMXLa7RQJWokdwr4ci0ie8MwNlTJeIUMzVlzOG+qbiQeTxvbYZlWteFqbC/y/XSo1+bO93+gYIbmtufqy8pq3F0vM1xV9mS96zX6NOKn0R2s0QMPrZpRFjkRSGrEGqmfaqr21BfMEpEU/P6csfh04qaXf2jaBUeUA0m89ex+lTwONXrdUnnyG0HxnSk4yyAtdGk7gpQgTQIAakLlS+M99cfjcaeF3luOXWh2+cLtXuloLF2rDSaMgEAAuBcL0DJyrDCfx+Gght0gffjBU7TnQVkYHuRsqQEOKd4aaeuP8goemi4LFPCLtMnxqyFP738Zh8sHFyOcXxc2u4+TCBA49UO4zT1UWQHfroN9tpr8tk7nPNDnN0l4DlzKbVRDrAOVwn2wmUgMpNJip+/foGfROm8skK4GlvMPsgs+ptvL3v7r4gHJQKdfF04N4cOuPWS/5XHBFg2ggBZPOzpIKanFcT/o3YXQ6kDsNvS5qgTuv39l1pYXWIS8FOseBlmnRRrT18jOtaXATGCT6mU2r1nvgLXD/g20f273qXfJDBwTuqrO/fpDVET/uZGzRexKMMLJZH6zmkp9tCZA0iJg6IrQnGEeSzbbdr4/pKR2cmDlHeritXlTo1WEVDjxWzWJuoY1cLfO2R6JLXFxAtjfVn6f+yIVawyXGcu+lMJq+yohurlbUyc6kjzyhoVXB4Oc51s6xaXEx+qvgvNZGNZn73edvocVTbbWac+g8mDVG9eMVlPnKk5Ys3ynfBZewD8M2VyMDb6gGDO9gr7PQK7ofpxGv
 HvZag6Fa
 x5ZhIL79UHvjlzsgIyArerNuBbzv9KsJrBuQYZaf1JB7fubV8DgVzMDBgGMo0ak4WRpYQCLC96EVsNdIzgigTmaEK5ujt6ej1Vq4xNXoArWDI05j7ZcB5EOb9BVlFAMZJoiVO76lCa9zpNFH0A0LUXzX18Yj9/fdJuXbenxRlhGVdUiLGNGl0M66HOhO9xqw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 31, 2026 at 10:13 PM EDT, Zi Yan wrote:
> folio_test_fs_private() wraps folio->private !=3D NULL check and excludes
> swapcache and hugetlb folios, since swapcache uses swp_entry_t overlappin=
g
> with folio->private and hugetlb sets its own flags in folio->private.
> Replace open code with the helper, since core MM does this check
> frequently.
>
> No functional change intended.
>
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Masami Hiramatsu <mhiramat@kernel.org>
> To: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Nico Pache <nico.pache@linux.dev>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-trace-kernel@vger.kernel.org
> ---
>  fs/proc/page.c                 |  3 +--
>  include/linux/mm.h             |  3 +--
>  include/linux/page-flags.h     | 21 ++++++++++++++++++---
>  include/trace/events/pagemap.h |  4 +---
>  mm/huge_memory.c               |  4 +---
>  mm/migrate.c                   |  3 +--
>  6 files changed, 23 insertions(+), 15 deletions(-)
>

Sashiko pointed out that I missed a couple of open coded checks. I will
replace them with folio_test_fs_private() in v2.


--=20
Best Regards,
Yan, Zi


