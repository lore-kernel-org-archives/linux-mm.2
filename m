Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D95B6C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 15:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09596B009F; Fri, 10 Jul 2026 11:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1016B00A1; Fri, 10 Jul 2026 11:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1C16B00A3; Fri, 10 Jul 2026 11:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE0F6B009F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:35:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD4441404C4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:35:30 +0000 (UTC)
X-FDA: 84973266420.07.27EB7E0
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011071.outbound.protection.outlook.com [40.107.208.71])
	by imf09.hostedemail.com (Postfix) with ESMTP id EC3A3140005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:35:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oE85Gh3e;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783697728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNpBlr+6fMrjx5pTxrJ9XBBXSB+o8Gi45nvsGhlr7kU=;
	b=1IdQnJGo66UKQIEF7X6hZKUZDPa/Gn1mtCCAqF8a5p31PYndxRTYzRo/S6V7r82Df2UL9C
	kEUHMm/H7+7SKrsnwLEyNnnWhzP29/6ZhNYHiuiB1zfgsp5IS7pRCi9ykx/mMuxeKPVpdZ
	Q6EF/toEt09AWH6Gscck/6CtbhbNSDI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oE85Gh3e;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783697728;
	b=tNu2LIL8xgxY8QCYC9aGK9xIMBH86eiFjD7alef6Y8IDb6AZzXPvLcKW0FsBHhe8AC/UwB
	bLxb9duLRvlv9H1XJV/MwFDRrMuu+smAa4zYjxwiaIhEoiyGPP1TbZGwiu6xdKgOG2w/bZ
	b2ugOKlAa8xHfmgcsmeinl8PhIwB+N0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d1m3n2KaviwVfS+uT2fVqPVYJzdC1mL/pm3qnMGU1RclVwoywB7Va1Eg/t1j594jzdqd5ca8XYQaY5I7REy2zfUdfCyoaSWYPCSop8/vt6fVbWE/IWDXxLj4t7a3H8SWQ/B/1PLdBK7NJFUZV+TiqpBt25CptGkPQ8jQjoSXirsPoqbA7UyvQjGSc9TILuqK5R/KwE65kiNd8fNAjD2YtEjwr2gAmk59t3NpvI4Pz8gEIrJ3HKV2zKchmwHnY/m5xc7CdVJGTYU7n7sjbagh7+KXSByejxskzeg7WJ3rXIXWK9xEInpx5ClfnV1xGWz4zHE1YV04FbIF1SKb0RZMgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNpBlr+6fMrjx5pTxrJ9XBBXSB+o8Gi45nvsGhlr7kU=;
 b=vd6i8+ElxV6pnqiAXLFQEVmhKcMveE7R5BCsawcbPzjvJFszj82l5Db+K2umAonIP7P3qrhhxHqwk7qRQyMvFo42LKd5SGWu0s7QcwV3fMveM5lx/4r6pQ2beBWdiEpPehiEZ0Dg3jqdfmMRBOCiwtvFVZ8wOHNw4XsJHGEMsaOV3Xz0idiDJvHZNDHgEqfnwk7QR+KHh6bK3OyfkTIAtMMh5z31HCf3T3D1Kx7WSR+Qu2bhiJOjOoLIRgi/N414F8zgLhABBlyfTn9k1HWghLJrXEgDKGPBiROv1X/j6iP69psD0P1MV4e16rk6xypFLHv+6d7uXj/34neTcipB/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNpBlr+6fMrjx5pTxrJ9XBBXSB+o8Gi45nvsGhlr7kU=;
 b=oE85Gh3e1VKiGOCWGiWam4VZVm/ImqD/7d8xfRXbpr0q2QhCkfYW4vyfZxTJx1x5d7OFPA8oxzbLyutDuCNF4RhuwpkEUX9l2S6XmiSyQcN7arAsoqe1heQm/FcfFtSlHR1eB7h9FcljEk8/AOONRFU6mGMpT3HQUCs974dm6e62C5MDQSgvx104kB2J0WTgSleq1idZnwDXuysYKSdkOJxW4RBC9l3iDiqmCwXYILVZN5PnnyNd4WN2JtwAhfH0mvT1Aj8MP0J/KHOEn71HTq4PYNj1sbxIpeXxbGkfIX2qZX31I7j7OmNzJicCLD/qYf+W+YaCQzOmPEyjiMyZyA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW5PR12MB5652.namprd12.prod.outlook.com (2603:10b6:303:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Fri, 10 Jul
 2026 15:35:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.016; Fri, 10 Jul 2026
 15:35:22 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Jul 2026 11:35:21 -0400
Message-Id: <DJV02L9N37X3.1THK8MN9Z2RUR@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Sashiko"
 <sashiko-bot@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>,
 "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Balbir Singh" <balbirs@nvidia.com>, "Kefeng Wang"
 <wangkefeng.wang@huawei.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
X-Mailer: aerc 0.21.0
References: <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com> <b806c878-e1e6-4af9-8816-678955288d82@kernel.org> <DJT9JHBIGW8V.17SI5NN5GCJVQ@nvidia.com> <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com> <DJUUUX0BK942.1ZP1I5GNIGEY1@nvidia.com> <89d20411-4915-43e8-9808-3a7fbd98d2ab@kernel.org>
In-Reply-To: <89d20411-4915-43e8-9808-3a7fbd98d2ab@kernel.org>
X-ClientProxiedBy: MN0PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:208:52c::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW5PR12MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dc955d3-356d-4b67-9be3-08dede98db24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|4143699003|11063799006|56012099006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	YMcEBFM107qMavi48ne7ZovcYYzWEVuTpuKhnFqXBAZYNG69yQN5q0Kq2dIzARVEnO4I1a9VQ+NDw8qcBAiOXzGA22jQaQmsBNF0QoaObjFI2XaDEwJQhUFsvICS2pJ3a6+5pZP+GPhcN+ace2qYCAKoL9Ud8h9UzQOEUJP9or6IfHkaYi1vciMCAyinNVrHYRWs3FKqgLUB/5FKYTo4mqq1IIpdY6rZGwdXa+i51QQfLqKVT8ukBy8QJtMWwDa2xI2li+b2xDLC/NVWig0Ty6wmKhiA4irWLZUNEoEQGDTC4PjB4JV7T1Jo3t4aU3hyGOtpzcrnvauVDEpw50cWVADcOTEhrrjdLP4wvuyTFWYp6JErAsMpxLUE84jDCrAitZL2uwzxSPZGTP59yC3jUovRg4Ug8UjZST5QF13NZbZmuYT092vcLNcIl7avXg8042+grkYPoDvMGniMXWqSUkVyzakgt+XdiBeBBUhFy5e7ULx2BZL6z0UG+W3sya1vgk9wL8QCtMZO+GcbAwDbpFvbOcx7JcMY4ZUYCqMTch1c6cJbkFT/InnujFpyBLMhDmIeCJ+Nxx/h/zWYOB74HwFJO5o9Tdaflxa9wKqAWgy3EoRdxlah+bLJbj+tdkq38CVvfRan4HDCbnaE8x9HNrr3/uOAlaF2RYTTCQb3FRk/KuMwjcmwgTC114Ky4ptpXUhSt00S057u2LbGNto4MQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEFla3FxMTlTeUZvdXFHUlp4MWxjUnhtc3NjMTc4RlBXNmVLTFhpa1VRdzZI?=
 =?utf-8?B?TVZUVDVhRmtqT2g0dVFxNllKVU1CWVNzM0pQRHZjN1dMeUd4eTB3Z3YxOXQz?=
 =?utf-8?B?Q2tWQkc5cjZUNktQNlRBV1RUUUwzSUlnTmErM28yc05SZ0pLdnIwb2d4NURq?=
 =?utf-8?B?eVFZNzlyOURibVRodWFRcjBvdWpKQlVhWHJMWUR6Zk1LZHVwTWRPVHlZQ3RB?=
 =?utf-8?B?YkxXMUg0ZjJ1clNxS2VWNGtFOWJlU1BVdU9uNlkxWmUxWE9ad2t4WExGSldY?=
 =?utf-8?B?bWxOa3R2UERUQ3JoSllmaEZwb1JMYlVTc0J3aW5Hd00zNWRMeUxHa2pScjha?=
 =?utf-8?B?c01yRThvRW8zeFc5TXluSm1Pa2hBVjFjNVNNTlBGR2VtU2tDQXZ6dHBXOVFi?=
 =?utf-8?B?MUJvbnpNOFA0UjV6aTJxNmRZcmxvcHVRWU9SbGNUbW5ZRlR2S2NwSnF5dmlB?=
 =?utf-8?B?dXl1bi9rZVBxaGpZYXRxUWd0eXd5Ty8wazBzR3Nvb0hNZFJPVktEbVNKS0o2?=
 =?utf-8?B?RmwwSkI5cEhGV3F1WS9zK2Y1L2VpcTEwZE5hRFJJaWtHQU9CRzJyNVAraVBD?=
 =?utf-8?B?cnIvbXd3UFRydVBKTjc1andtOGtxWFpMcGhra1BWT09XTC9ubXFpUGpLUHha?=
 =?utf-8?B?dzlldEtWL3lxY1U4OWdTcXkxZkdkM01lZTZnVmpUbUR3amU1SlFNR2ZMV3gv?=
 =?utf-8?B?MGdCSjBOVnkzQjNNZFNFNGtHVjNKenNuQnFOejFFdW1RbllTOEpYRlMxR3B6?=
 =?utf-8?B?OHRNR2IzbXQ5dTVZVzloMml1S2JTR3FEWTFlMjBuejVmM2dWam45QUpZZnAy?=
 =?utf-8?B?eGFYenBldGVYVEdnVU56T1l2MC96dHNueG5KdWpyY04xcXdUNlNmSjNmRVhH?=
 =?utf-8?B?N2pqSWxjSzNLMEtnb3ZCTmRGaGEzVURXM1I3OUFsbFpQcGhhNWVIeUZlUElv?=
 =?utf-8?B?ZHFSRUd0NGtCRjdKVkwwQWN4blpzcTNzemFRSC9SRmhPdmhvNmZUSmliWC9o?=
 =?utf-8?B?Vjg2VUdaODE0ek91OFNhTXN0OFhEVFh0cGNpeENHVlVTOFZGbWRhelk4U0dn?=
 =?utf-8?B?QzRIVUFCeEFydUw2UlpxbTdUU0FNOXJMaW5CWjNtSm8rQ2NWNkQ2dllzd1BH?=
 =?utf-8?B?L1doYWEvZUZEWWlyU1EwdDY3S1l0T0JoK0xvVStXdE1PS1N1RnNLeGxLamt2?=
 =?utf-8?B?Rmp5MCtRMWtOTFVmajdLZ1diMkE2akFodllQV2NWdWtmSVRESFJjeTBwZmZp?=
 =?utf-8?B?aXZvbTg4WkZtWnNsNWpKL25FMVJadmVnSjFtc0VDWEpodlcvL0RBQWtjT1BM?=
 =?utf-8?B?Vjh3bUIyVG81Vk9NSnNaSWtjTWppS3EwWEx4ZWxZK2U3ME8yZTNUZi85eGVG?=
 =?utf-8?B?dlJ2YkpTS284c3Q5WTdWZ2RSU0VsOU5Vb1VWSWJXTkxod2ZBVkZYZUxRYUtl?=
 =?utf-8?B?OTNmUGs4K1VRb1IwQlYxTFJpMGpxVk1PaENLcE5mWjFKbThmdGRFdE1iVU1S?=
 =?utf-8?B?eXIzR2xaZlBXb2NIbUFWZ3pGdEVrM2pLOHB0ZmQxeFdxZUlucGF1WjZSMGFJ?=
 =?utf-8?B?a0ZicjF4VWUzZUJkaEhROEx2S24zRXNMK3hndHZKRHQ0eTUyZGJrWThVRWI3?=
 =?utf-8?B?RGE0cHUwRHJOMldvb2VPQm5RRHRsWlNIeUZPd2g5aVp5M2hsU3JHMW9pRXEw?=
 =?utf-8?B?NEFFMFhxa0M0NU8wS21OVVA4VEpleXZKSzlQZzgyeHRQWERsU2xKL1d0R3FQ?=
 =?utf-8?B?WnNhZ295ZTg1elduMEp1UVo1RHFIc3M3MTdMNUs0MU8rd2VOYXNySWpLN1Jl?=
 =?utf-8?B?SEF1Y2ZuUE5TNTR0V2htOFdBRzc5dTUwSXpxbEZtenlJZXJYZXllV2JSNUJ4?=
 =?utf-8?B?bVFsRExDMU5uWEtoNHoxM3E3bitUUE1WOENYQkVJT1grSWN6Vm9HOGpTdi9w?=
 =?utf-8?B?TFZ5WkNHOHMyNmFWRTlocVNaTGZwZS9BM21iK3JhL1cvSHg5Vnkwa1JnM2VF?=
 =?utf-8?B?OHlQdTcvYTIrb2twYmxZb1BQa0V4dUZkeFhHWFBZVUlkSDJUalJDOUNSWkhp?=
 =?utf-8?B?dXVtdUFjeUFaa3FrQlZ3cExUbC9CTTgyaVNtYnhvaU9IcWZhc2JWcHBQclJC?=
 =?utf-8?B?eUJJYXRySEZWcGdVNUgzMmVwUU9iWVN1bVdlTHEveHRxYllvYVo5d0NXVnRl?=
 =?utf-8?B?WDZSelpIT1J5WExCNWNtcFcrcWU0YjJMcEsxNU00WHNxYlRKNmlNNGFGWUFF?=
 =?utf-8?B?SWR5UkdUemx6VG1VSFdGbmFOUmNsV1ZiYUlSOGhXZGpNUVhBVmdkWE9PbnBZ?=
 =?utf-8?Q?Lsswf3F3IXZZW/oKi5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc955d3-356d-4b67-9be3-08dede98db24
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 15:35:22.7570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bD7CESPT+aFl+0zEjuiIwEcDZCGH4Hax2FpkXBrpe/kfDVkhNJiSYbuxi0ompqRK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5652
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC3A3140005
X-Stat-Signature: e6jnntf1bb5ebky8gyzkzz969nendtcf
X-HE-Tag: 1783697727-663479
X-HE-Meta: U2FsdGVkX19TwfwkvAGH7v8Yn5dZFqzbK0NF7EpQZ4H7ySrXHWJWKk414hopH6sNc18LmlwasbUvB319jTE+bk7ksMv8yt4hB9q8Oyr0aW1qhC5Zq0DDu9Ss3+2zHDHpW7Ns6ZPNGuRNSxppUvM51FNUF56GURjdy3EBpGhEABBWTDKINW2rdkbz+i4USdM9kto9K9bQpf+rxP3qjCIocnztDy17dGO5Hps/7cj5xxC5j+H8upkFnSFSlhShWeMEOi7FylJAWnrCKICmmK1SKeMEmEiH55xtDYBnHjLjl9NwlC/wmtY2gP5PHCukxedLjdA4W7WWRT8PXr6zR9+OD9aQNkcE9fxE+j+qxIcJ7dg4zvszm+3gs+azO0R1/HlcuozTtGB8eASrnzTY73CwJ4RAKD/2EIEFhz46AoU5wXFEcNqVMw5IoYVGIg1IyMh3RXa1vsZnyx6/cJURm87u+iQZ4gtwotaN3TaTsuy/5HbODl28l3iov88S+/lcRVA5IpNMPjaSgMjGcXl29XZmt8dCdba32z5E0qADLsw9aBizaEPQKy3GN4rRSi0aES5QsOe4k8CarhvjI0F8AuzZX6faXwRorQ2ILfbz/9qD2II1Mi+TSyH4eVz+yTzTLLgwESrJLXGZ0Sr2IWQLgvHqSaRgS8CrlOBEgb1PhqEcgfdbGlqBo3qaMpsj5vnR6Byxmn0bcrDoPuJ/uG5rPtUfcxpWCsHbPY+EGYgJ2iimlwVK908QhyRD9j1CnjqXhuA6FU2PfE7WXa+X3E4RrPMlpXaTzh/ngklo419/vavjF24SPFs9VzGcUvKnmrmcVX/GVhc8+xaqLWebp6QevXf86sxZ8Ion761iZuQwFiDgnBESrjJAUHtcAmxkuiwMkvCUDyc1RG/oZqJ9xVPI8A0CjTT4cxQmn028TboVtkoY16Ok0piCLoTBGYl49+/wG/TK18asmPUcJeHI4rpwA5x
 SmLmHxmp
 7gKYWlKbvZnwDXVDSOWiXMW4wlCn2ji3YlABnsOBmjUTfiFG/zfdH2GpeqShcqnU8mYZBRNAZ4zOhMbt1N1qHitri2NGt2yHf2fanbsHqnUsmOCni8kmHOhDHu7i1QYCDM85dBh5EhYPPd+L01JJ/hXdvrkYcaN1Y0lkOcFhotBzJunU1So/BeIBLPuNKWx5FXhF2CUlembP9PP2IFmk97WdhhqdfN6GCPlPyXgAU9SrtRD23CTgO00pFy6AZLbJ4Bzg834p2rsrwTDc6wp131Xn4UBQivWLbjEiXpWmjYVqyqp/ikzf5ulXdDghDEZsNgPyYWWSgLy8C5v40jZTpV7ivuPceVJA0ZZeBlXrm8vxqxRPyQfaOq4KRqrcoWfXFjGG4AqCC+9h+v396Mk2k+GWnREvOSZ5kXQ/bRMlF7ckUqMWBWY0tr/JDhAGHby84ff8sdjgbeh9/0MOfcCvkZOviG7wrUGxlyG++YjKKgEV7JGw9v3Hl7iCsLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 10, 2026 at 7:56 AM EDT, David Hildenbrand (Arm) wrote:
> On 7/10/26 13:30, Zi Yan wrote:
>> On Wed Jul 8, 2026 at 10:43 AM EDT, Zi Yan wrote:
>>> On Wed Jul 8, 2026 at 10:35 AM EDT, Zi Yan wrote:
>>>>
>>>> I guess I have the same feelings.
>>>>
>>>> You mean we reset migrate->cpages and migrate->npages and restart from
>>>> the beginning? But it is not only that, since the code below also
>>>> changes PTEs into migration entries. We will need to revert them as
>>>> well.
>>>>
>>>> Hmm, migrate_vma_collect() documents itself as "update the src array a=
nd
>>>> "takes a reference on the page" without mentioning changing PTEs. I
>>>> wonder why changing PTEs is necessary, since later migrate_vma_unmap()
>>>> also changes page table entries to migration entries, although
>>>> migrate_vma_unmap() changes all entries to a folio, whereas
>>>> migrate_vma_collect() only changes PTEs from the specified VMA.
>>>
>>> OK, it is an optimization[1] when migrate_vma*() was introduced. If
>>> there is only one mapping, migrate_vma_collect() will set migration
>>> entry immediately without waiting until migrate_vma_unmap(). Fun.
>>>
>>> [1] Commit 8c3328f1f36a5 ("mm/migrate: migrate_vma() unmap page from vm=
a while collecting pages")
>>=20
>> Hi David,
>>=20
>
> Hi,
>
>> Do you think this patch is good to get in? I would like to get ack from
>> you.
>
> I dislike that we fail collecting even though there is something (differe=
nt)
> mapped now.

Not all the time. After a folio split and PTE lock is dropped, there are
different cases:

1. no page table change, the collection grabs the PTE lock and continues;

2. some PTE(s) is changed, the same as 1 and the collection continues;

3. the PMD pointing to the PTE page table is changed to either a leaf
   PMD or an invalid PMD, the collection cannot grab the PTE lock to
   work on the remaming PTEs, since they are gone. For the collected
   PFNs (they are mapped more than once) and folios with elevated
   refcount (they are mapped once and unmapped here as an optimization),
   they will be processed later in migrate_vma_unmap(). Since
   migrate_vma_collect() is best effort, there is no need to revert and
   try to recollect from the beginning (to get that possible large
   folio or skip).

BTW, recollection will be more feasible if migrate_vma_collect() does
not do unmap singly-mapped optimization, since in the case, no PTE is
changed, we just need to reset migrate->->cpages and migrate->npages and
restart from the beginning.

>
> In case we stumble over a PMD, there sure are no migration entries on the=
 PTE
> level anymore?

Right. The PTE page table should be gone and the original PMD, pointing
to the PTE page table, becomes a leaf PMD or an invalid PMD, since
someone changed it when the PTE lock is dropped.

--=20
Best Regards,
Yan, Zi


