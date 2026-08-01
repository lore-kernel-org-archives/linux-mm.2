Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42978C55171
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 02:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734D36B008A; Fri, 31 Jul 2026 22:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4EA6B0092; Fri, 31 Jul 2026 22:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D38E6B0093; Fri, 31 Jul 2026 22:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3466B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 22:17:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A05F801E7
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:17:08 +0000 (UTC)
X-FDA: 85051088136.12.C60495F
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010028.outbound.protection.outlook.com [52.101.201.28])
	by imf04.hostedemail.com (Postfix) with ESMTP id AC5B640003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:17:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eqIZkPbv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785550625;
	b=UH7vYnjQPc+MEhNH13EpFzPJoeO+c/tQBKVPoghBLmZ3Ni7TIlofTKprSJZZiK2xEViKaf
	QyEykt6EiWWKGSvf6tzNe1CprHK8aWUl5Bz+QhoEBDV7s1AHZNuFCaetYNHQCXpQuHL3TS
	PZMBBB5qh5ODqaBuYWr/8p61HIwuk5Y=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eqIZkPbv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785550625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voi7sKIo11kENHtkZqMxE+k2eKCumvna/s1k1axqSoU=;
	b=0S0Cry/ffXnsPOpYG49fXl5NEL6rhOyaf8tUDRjlphBmyiIG0Txn4TYi+zh/mVqP136Nwq
	S2azLmizbxa1VSAwP/wzoWXlMRm6s9hzyde0811LlEOgRKgAOpP01VfNy/ZZ4QCVmOR2YJ
	EmzzmNoMl19t/W2zC1fLYpULFADh0ts=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AoN9ZFOghwNIELN8EgoLrgE+k/0C/9TFR+eTPBCVctciuZxGrSEjTm/DhSsa9h5Q53zDBVEkS8WVHlpY04tX034+JyeVJskLQO8c+GdTvOGlcZjNImAmY2sXh/Ym+vrVM7XqSpEPw6FG5EiWR4M5iEKG/6HuTjey+9Bn5qt6zi+8SauR5V7u4XZP4nIk/bKFXjNUt32fVtBSBnV4zpHLZvyD8vRN6xuQ7kZuW6qBC6jWxWDJmJf/uFGuVDRg8pnYR9nB/M5qtPiukfG4ePM0+Oszj5o3Errnpo4XNGSsPrEq1oPiTMA0uLIdpseFKK6zNx3Pr2JzxcNEEpmCp5ww6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=voi7sKIo11kENHtkZqMxE+k2eKCumvna/s1k1axqSoU=;
 b=qgsofVZ3XNP5RGnuGIIQiDs1RUb4O55ncaVDdNFvbmxQnMtffYYiVd4DitNGsB8om2bR0FehNS/GhD/sxoroHDTo9U92crwhSphKvSIaH86nmFK/pqd5NN4y8gPR0E951qxZL4nbv0gmVU+VxpkydTD9qjHJrcaS078DHDS3mW4ZgwmVxfbJBIkvTSFceJCdez6YhXE/3e7nRRA4Z/FCw+cm9UFJQHYik7mTVw3UFuIZUzFlstTu0rVrYZCw2y8jybbZzIw635wlu32IahdN/qN9Z17FEeFVVFmAVwHiRXr0uPzFLCQ6mz6fXLyH4qAB9bMCKDwQlvpUoSOAyfzi1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voi7sKIo11kENHtkZqMxE+k2eKCumvna/s1k1axqSoU=;
 b=eqIZkPbvFTedDNgEDzZz0drhjKhKsXCJ1+E7hxVDL4kFJadHbN+9DhpaI3CDGL3/Oi36GN/VDj+qK4Ihl+EgIKP9y2RdmU/YkPve2VY+fOQVxr4hl09s7xmcAfwQZMAC1TjM+l+BEzry+B5yHt+u3YRmJKOzXlAtK0RtvP9m+yOUk6b4rszz2gGIK9lGtxpCfvpOpYh4eaBZe1Cjd7VKbSiz8hJo3gKE7iZgeKjEfCM8GGt2bZvBS9cQoJ6xESTcNTByKFTcvjvxXM85Q3VMGGhjvC+N99w8Yzua21uJcgWF2OSgJm1L5wWsu5ef8Zy971nH/Kx7YuiazzyxtbSS5Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Sat, 1 Aug
 2026 02:16:56 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.015; Sat, 1 Aug 2026
 02:16:56 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 31 Jul 2026 22:13:25 -0400
Subject: [PATCH RFC 02/14] perf/ring_buffer: stop using PG_private as AUX
 page high-order marker
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-remove-pg_private-v1-2-142c97ba3562@nvidia.com>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 linux-perf-users@vger.kernel.org
X-Mailer: b4 0.14.3
X-ClientProxiedBy: IA4P220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: c5b43322-1e82-45e2-1366-08deef72f5f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|11063799006|56012099006|10067099003|18002099003|22082099003|3023799007|921020;
X-Microsoft-Antispam-Message-Info:
	u5AcEjQXoqybhCUBd4RiVhmX6OnmHQIG0l661tbSmlK/gQB/JA/iZoPQKpDbkWWYFDj4GFY7TL0xbPja2Cq29Yayp2hpO8sBPk95b8C0f6gJBcwKohJriVEePjNyZ/3hQRUASMbdiEqMCm17xxVeKgLT1VqBeSubk4nn8v+eIQKW9+k9yzb+BJtvZ8lq6RqzDtX5WyTf5EP34EllNR41cnpuGzkAU/X3h1xPjDX5EPjNauwYh24IvZ3FqIHU8kf7WiuYsC+VPpkfG5KGseYoNxOmFpQY4jnX/HKArH1SPQf5tUgZQ9eSHKWNBaaNbqvvC2kwuEArWCv6XfiK8Uv50DFnnuSPPa3r4szP8VM0fVM51TuaQ7ndj5FWXumOLCIeosH4EivbBS3HzqFhZw7zogewafiKgy0F/AigGdYi6bodsU7fTBMP1aPmvCjNVOPMV3Fh7EfGtz1VGqoU2LsH6AtvL40Mt+eP2QLCKvfVP6UcObrzhqwNEUDj19juWVW1fNSHfMu/P03BCbwtzWmajUX5Ad58bE7cyn2jtG6BPzr7EXtDJKHblNWLo7Sdtg7XTeFtOuyUeHsTBdBCYzuFsWP37awbH6eLTyfjzrvo70WTX45Bl4Bm0xyKGfdKSVgSCD7WO7f+rkpI/+Yv4v1KtrwKPB2dxvsJOT9F2rzlbgzIDA9m9n6WjLXji9ZdOJmw5AqmneEEih0+KQthRPzlEw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(3023799007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTI2ckp1V3ZCU3ZhV09EWkxaL25lZVYxdFZ2Vk5rOUlZVzdVSGIrdWU0TlYr?=
 =?utf-8?B?S3RZM2dLWGEwYTZ4Z1lIeUFiWmhVNFk3dGI0bnNCOGkydnFSbzZ1M0tnQ05X?=
 =?utf-8?B?VmcxQytnUlhLWU05TjN4Q0VyWHA2L1Q1dmRHZVhBQXU0QWovVE9GNExscXhm?=
 =?utf-8?B?S3RURWNhMUFHZnlGNGtNSStzTHJHSXAya1BpdzhYRURFOFpBcDJhc1F2ZzNF?=
 =?utf-8?B?TmFhVFVWRGNBNk9ZTzBvUU1hL3h6L0pKSHBIWE5SR0F4Sjl4Wld4ZStVTmRG?=
 =?utf-8?B?MGtIWXhac2xySzZNL21wRzJwa2Uzbk5DUEMxbGdnaFJEZmNkaUl5Vy9BYXpI?=
 =?utf-8?B?UmRCTGNxR0ZlZGlmcDRUV3FPcWpyTEJINmRONEZWMndROFNNU3JWdEljbGlM?=
 =?utf-8?B?RXpmSlRDR2l6cHRJUjVwbk5JZHNWTk05bG9zMGZFa2RxM2l3ZVp6ZVVYVE93?=
 =?utf-8?B?WU0rK0NVRHhKZUJTbDl4SWs0S0JEdmc2cy9RREtWcWN2dUlPMzVPb3JxQW9j?=
 =?utf-8?B?aGtWNmVmYSs0dUsvdUJobE9nK09PM0JDVWV6Z2lFRkhJY3FYejF4ZEk4UFI3?=
 =?utf-8?B?NmxJTjRybGxOaCs0Q1hJQjBQbEFxOG5FQ2tvdGttanR6TU9ZZ3NTeHF4cVp2?=
 =?utf-8?B?T1ZMQU9IWWpYWDQzbWhpaWkxazl3Q1BUQUJxSTVxLy9rY1FES0UwS1NXd0lN?=
 =?utf-8?B?TjYyaDI5V0tSM1ZRbm5pRWk3WWZZWGZkcnZYK1JYQ2dqUjMzNGxsNlVYdE54?=
 =?utf-8?B?RnhuckR5WWlHYkk5ODdaS055UDJnV1lrYis2Q2h4T3o0aXRGWkl1M3QyQ296?=
 =?utf-8?B?Z0RhYmdtNTNxSXlFNXh2bVllNlNOMVNsemRUL1JPZDk4dEJ2Z09LSENob01o?=
 =?utf-8?B?bjhUQjU5d2FITkZPcDRwTWt6L1RzUW13K1g0OU9oVW16aDYvR21XRmZ5RUpl?=
 =?utf-8?B?Wjd5YjdLZ0lNdW9EY2tOSWt1ZUNTU3M3L1NZMmFhYi8vZTlJZnlIQ2lGRHB5?=
 =?utf-8?B?MTJka1RhVVZ2UXhNckhoSHRYaW5ud1JIa1lNOXAwckpqSkNnUHhFS2FhTGho?=
 =?utf-8?B?dmZPdGVpdFlVb1JqSFhpV2wzTlBEV2dnK1RqditoSW5DY1JReEUrVGhVZHk1?=
 =?utf-8?B?R3lnbU0wM1E3Z2dkdTFSbU4wTUFnclJIdDNqVzlKN1pxc3ExTktPWU9RbVhQ?=
 =?utf-8?B?bFkraERWR0gweWRqb3BKVVlqWm5MVVM4ckluZFRXMHQ4d0dvSWhvNVhBQVdP?=
 =?utf-8?B?V21pZzdNeUNrMklPSnpQcnllT1RBbHp4b2xkTml6dVJ6dWwrYVdFVFkrSzNs?=
 =?utf-8?B?dWhUTm50dndOUXlzakpZRUlTMDZ2czRoWlYycGEyaFZvVVV4d1kwMU5qd1do?=
 =?utf-8?B?akN5RXZrZjg3VnZmVlV0YVBiUkJrMTg2R3d3bXJzS0tySmJWTDUwRzhXdm1w?=
 =?utf-8?B?NmkvTmt4QlpBcTJjM0hnUkNJMUlzb3lyLzVma2dpcG4yYjhaQ0gydFBrbHdv?=
 =?utf-8?B?YzRDdDhjcUxyS0dqSU1UMmVWQW1kNmluVElRRUJPUmtGNnVUWUhRL0FsTE1m?=
 =?utf-8?B?ZVJKK3Y1ZnNvSHBDNUU1MlpkcHVCK29jdGpTcE1ZS0QyTG1ROHE2aTM0N1ZO?=
 =?utf-8?B?eGpWcXRjcjg4bmEwNWJ5NXdTbnJ6Z01DdUwvTXdQa2xrZHJreFFLajFuRkVy?=
 =?utf-8?B?RUF3QXUyMEVGOWxsano4SGp0aHg3WGlsc1NlaXFCVUtYR0ZIa1drVHJSRWp6?=
 =?utf-8?B?NlpOZEprK3VNVm9PR2hGUnBPRVAwRGhkczFLK2dQWFJYbTRXNnFrZWtuTEZx?=
 =?utf-8?B?TnZjak9rL0JITmNwcFZnWXdBejZUZThJcFlveHF2VXI5NmhJdFFWYmpsNFhL?=
 =?utf-8?B?MGUvSi83UkVaTUJLQ0hJZmRONUJqcTNNK1VPbzEwOTlnYVZIZ1BuTGFSRHlB?=
 =?utf-8?B?bFcyQlZyOTNRb3pqdENkSWJUN3I1ZXlZVXkrUTAzUFVpUjd6ZHV3clhPcVVY?=
 =?utf-8?B?UlJmTUNxa3h5R1RhaDZWOW4xYnRtSm9CRlV3YUFkZ2FLTjc5NVdNVUp0RXU4?=
 =?utf-8?B?Y1lzN0MxQTU5MFRKNUhwVTBkcUtuajFlTGFZWVlFZWNiSE9yTzVwdlFLUEk2?=
 =?utf-8?B?VDhud1UxY3pZRlBVMktTeDlxbjRlUnpvYVIyL0lGQ25KZnlCN3BCZklTWmRJ?=
 =?utf-8?B?UzludUp2aW03R2JRMGVTblZlanMzamd3RnQrMitYZHhqZVZWUW96S0packhi?=
 =?utf-8?B?cnNJekFveWx0UTlTejR4bk9Gd3FVejN6WG41M2FvODBrZytrRVZVZk56Y3Ny?=
 =?utf-8?Q?haraJ71h/gC12+U7Ku?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b43322-1e82-45e2-1366-08deef72f5f1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 02:16:56.5329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MhEc+UP1lNmROnNWpeRSfRNRrYg/PtjsV2tXV2R8mqUs7/koN1o5wgAhM5pXSa41
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AC5B640003
X-Stat-Signature: 7um6bhi6t4axkarwwmiznuhnecskocko
X-Rspam-User: 
X-HE-Tag: 1785550625-795293
X-HE-Meta: U2FsdGVkX1/4xAg9pmT3Q5PVb8FoVGnyAUhh8WgCI6nqseCJemOXhhrMWOwgesvrJ4VTOhwyCOSunk4hzMhqWyRmxLflTmu6TTm71LYl9bXZrV6vQ/pt71K1JQUSq72aTeVDGr69yW31skx9FJbJS2nG2C/303H88lWj1M+EIGyeb6bFOOTLiQQRvAhJKKyKs1IfBiAdefoZSYvDpKA11nPdE/qpZ0WLm5ieLsYF7250zfgb9E27VuJhyqpVpvcXgvDt32hVR4KqI2BPSzjRHJPydwreEGUGyr7oKQF5OS3q33IunNVpLtup/+aQZBzrzRIGNNNxjAZk2RYPxYkF3SI/oBNj58rwZIXAgn3P8xBHirIEHAgFuattX7hKzBkvWXHnYvZyqfiwOl3njzcRoE3xCbkysYOP+OrseN3MyVATxgPrkVmteFPBSF7g3gC649l+uiTdjn/evnDut3iGj1Ri3umQ1kBk/81tp5FMHeWAjX18rOqfKEVY2xnUncJ30coqOL7NwBg/6IkJcWmtdSMEYD+wd09F8pSJVEeE/VHfVRjoqU1rpJ9awRMzasoPy3raxA2AxphGr9Wd5iJC6X3znwbyMt/bJYrylUOgI7OhXnyO9uVPs7KxT8oojeejh3JipkPaqyHMog7N97hqYZwb/a3GR3HMCROQE6fPQzgwZmrUv08okY8i5EQICSOjGfI/iccS356XhstIOYbIivm/Gk4rSIdbwMsZE/+PBJRpPrYq5kqiqEL/FeIOmUUl8CWFRw3hi+7hxTehWVcO4K3C353nUIzCxX0Bb2Ye/dFvBo5EXjdTqn3uYw7t7U7wa6d1rFs0siZll42QybPpe3+4Pr8ghH3jKrPBJl/cbaPxF2LGZA1NSF8awHK4s6WmgZ9rmEmCqQm8PrYSP5PSZJctaQTEJBxlt0iBlUWmK5jmILGbDSASW5UV5hFQlG4HS+v8oJZnxs21CJGSnRV
 XeJc7fS8
 J6c8hnMWz8NkiPGZECa/OUc7WbsVc4p2LZiMYVCT1XQEBFJdTAjyiWqq0Lh7TXK8yaPfBVQKiciQVLfnOQic3/E1410hKAy3HWePYbR2Wy3GyRaZkP1vdOa/M7SavuVZxw/nuvCnccYo/S9TzzB031m5mDI6toM54bHMi5gED6SJwwFhiuCVtQCSmlUQjTRTzt9ueh4UHVW7fCjWtOglHSEoo9uNEWdxWFg8B3XRxZoTtqkhkRsblJUg4zdeHs5lrjz2xOxrjLCmyJyK6wf3ff3zgAjSYYTlzCgGTxhRUlZvfYBL7GnKoBxsnfueDD7qEY0Z35h3OF6l81x+yMYuKnYuCJ8xlvVDJYBxwcxrGkMDMn1Ps2vBGCqRD3PMd58NwFAI79FWcIvoLlbLhuC2oCmWyogUQjKr37uqgizYk2fFpCTZQwmo3qe8sHmV/eXNA1DudzTLKWhS/GSkITUr32JbgjPZc9csiLAIetSThZDIaxDMqnfYqMhluEXfl818C6Idt6CqW69MUmboDNOZxCAd6eVgyEH584GIKtJ+XLsvoroCIjrmihXF1BZGnDIxUvu7xcvCih945+yDM6YBNmBDzORvJhfBm/v+1uOpmLiMZ7lqrD/dU1mwutdgvntu+Vp5i1ovY+mvbjQ+Cy9eqFICOywEfUzHsygm0k6tSc4HYntS/f3jqNlKaa1y9cSO0wUp+6ClSG64qzxXWPr1begVFQmPAmijLhjE9dF/wmgaqYAJWRUB/4nKxY0Df3O3DJiy/ppksbnc1QWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A high-order AUX page sets PG_private on its first page and stores the
order in first_page->private. Stop using PG_private and check
first_page->private for AUX page order only ring buffer and its users.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: x86@kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/events/intel/bts.c | 3 ---
 arch/x86/events/intel/pt.c  | 6 ++----
 kernel/events/ring_buffer.c | 7 +++----
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index cbac54cb3a9ec..5849392cf26d5 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -66,9 +66,6 @@ static struct pmu bts_pmu;
 
 static int buf_nr_pages(struct page *page)
 {
-	if (!PagePrivate(page))
-		return 1;
-
 	return 1 << page_private(page);
 }
 
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index b5726b50e77db..29d8b4a3560cd 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -774,8 +774,7 @@ static int topa_insert_pages(struct pt_buffer *buf, int cpu, gfp_t gfp)
 	struct page *p;
 
 	p = virt_to_page(buf->data_pages[buf->nr_pages]);
-	if (PagePrivate(p))
-		order = page_private(p);
+	order = page_private(p);
 
 	if (topa_table_full(topa)) {
 		topa = topa_alloc(cpu, gfp);
@@ -1289,8 +1288,7 @@ static int pt_buffer_try_single(struct pt_buffer *buf, int nr_pages)
 	if (!intel_pt_validate_hw_cap(PT_CAP_single_range_output))
 		goto out;
 
-	if (PagePrivate(p))
-		order = page_private(p);
+	order = page_private(p);
 
 	if (1 << order != nr_pages)
 		goto out;
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 9fe92161715e0..061b5cb222266 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -630,11 +630,10 @@ static struct page *rb_alloc_aux_page(int node, int order)
 		/*
 		 * Communicate the allocation size to the driver:
 		 * if we managed to secure a high-order allocation,
-		 * set its first page's private to this order;
-		 * !PagePrivate(page) means it's just a normal page.
+		 * set its first page's private to this order, otherwise page's
+		 * private remains zero.
 		 */
 		split_page(page, order);
-		SetPagePrivate(page);
 		set_page_private(page, order);
 	}
 
@@ -645,7 +644,7 @@ static void rb_free_aux_page(struct perf_buffer *rb, int idx)
 {
 	struct page *page = virt_to_page(rb->aux_pages[idx]);
 
-	ClearPagePrivate(page);
+	set_page_private(page, 0);
 	__free_page(page);
 }
 

-- 
2.53.0


