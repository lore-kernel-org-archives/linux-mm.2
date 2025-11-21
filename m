Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E228CFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04EC06B008C; Fri, 21 Nov 2025 14:09:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026AA6B0096; Fri, 21 Nov 2025 14:09:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56E86B009D; Fri, 21 Nov 2025 14:09:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB44F6B008C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:09:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70E4F140700
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:09:49 +0000 (UTC)
X-FDA: 84135553698.19.E01335F
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010019.outbound.protection.outlook.com [40.93.198.19])
	by imf08.hostedemail.com (Postfix) with ESMTP id 67834160015
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:09:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VjrItfMa;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763752186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Pp22jGzf7h7TLSkbFg2ChE0n3pSBiJhMpfOMLq6Uqw=;
	b=vTsZOS60C1B7bHGKSd2jICCmm6tM9tr07BYQEDdfmMl6C3KW1Ut9SaQaiR7srvicX1xyUG
	4x/Lb/JYeHuuvvcOFHJfW2IfNpN46YmcHFVvON/LsLFHc3E9NKQaFUhFQJlO0Frln0RHpv
	AaLYH9cTE2py+RX8HIoWbc1Go65f9bs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763752186; a=rsa-sha256;
	cv=pass;
	b=MkyhG2fU6939Mi+7g8P47cZ+mgf1pVCTMR74fkEo5VlR/ImKJaYMuD6BMn9e7Geg3IdfYh
	aHdcLq3KcJToE7p0+6WPgtpXC25sQWoO0qhDXYKf9+3GRmzNVEegDgBnSPx6fhLC0w881q
	3slRKC3Pu5tApZymGldSpHzSWUoAdzI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VjrItfMa;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X1EguQS8i1Aehywkz3IZEKbFVPNwLLEKJKu/cJnz9rEVusdSj3/qTOCAK84XPjLkVbh7CdGN8G3C+l9dlXr1AxfWUJSD9pDDS2OeJTuKoAo+trK3njJUNfoteb3L7LuNYCUoufGRlZjIUjZnMiYq6TXpZm7+RA8QL1KTAW5gYNi9xPEhh67dM5aJjhtp96Uj8wjNFx7fzoTtf4ReNof6hnY+B80iqTdbX3Jq4hh3gOF9VvyLMQMXt9m7ifSqYnjH0saj3LDFBFianXXTL2AQEPOjmzou26IVdcNvL60JYawQHEM0FJ2R8/eN0j0pzgbJ/rIUzhm3Dd1HxuxmoOkYGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Pp22jGzf7h7TLSkbFg2ChE0n3pSBiJhMpfOMLq6Uqw=;
 b=uUKdLpFfM9n4q53KWKc9d+cU0GSCyf5L91nzDle4O8/utVCxv/EqzOOCXPuVXraqTO/BNPAG7y21eYem1iYs451QP4ZU1GllnFCy+avq+qOmwC4MdVCCxctmxN/f3sjZxKKq2vkQe5DOqHwlQB8PmW3BR6VbK19a4kPoz2ophlYlPOifVSwes7CDuQqyxL3cGkOfA1SUXz6jmKMH2hkBuhuEtJr81/4HSMmr3Y7QUhv0RgFL8V5q3No3xkZDB/AOnu33JATvrz/gWgg7cXAPAqAntZpixN+vrbbf+O5fPBrtjhcBvt471hAly2qVxtC8tJs+vTa9jNtwiRcQYHjYIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Pp22jGzf7h7TLSkbFg2ChE0n3pSBiJhMpfOMLq6Uqw=;
 b=VjrItfMa6mloKNPjeWFQjjKR+aAlkg7ee8kilLDHRhK/AnKFbsgjdRR/RKbRuSznLmX1XU23ky5C8A5DTokEUciD/XHiI1sjsoFgJY4JP3wsF7OU/XvN5JxrvkbuDy4gM3ouPvmValin9c109DzHxBSXu7BgqO8LRrsCw5x675zcTG2B2fuCwdj1vgUVhvtsMtL0QRqN/2O42rGqlE6O5AOCkzO/YQ859UZu62Sco2pf+NQfyxQWQPoNbjGF5Zthu3xN59pqfDfo+ee9HXYDSIPCbTW96/rTyddVhkQCUH/PFRoYq33LTS2rM2f1hiqsgk8FuJAvFgCXrtAJeFudYw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6768.namprd12.prod.outlook.com (2603:10b6:806:268::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.11; Fri, 21 Nov 2025 19:09:42 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 19:09:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Date: Fri, 21 Nov 2025 14:09:39 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <031D24A1-5E0E-4A34-8333-4DBA31987784@nvidia.com>
In-Reply-To: <20251121103945.13934959041672e76dd34ecb@linux-foundation.org>
References: <20251106034155.21398-3-richard.weiyang@gmail.com>
 <20251117012239.lqm33uu4vl4y5zqc@master>
 <337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
 <20251118033339.7rukw7vvjvlbj5jb@master>
 <51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
 <20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
 <2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
 <20251118140658.9078de6aab719b2308996387@linux-foundation.org>
 <20251119005248.ddlbhokgjdmlkhkr@master>
 <20251120131621.486cbccc8a713ddbd30dcfe6@linux-foundation.org>
 <20251121090048.3n25tjhusu45xpoo@master>
 <E7C2F025-4CA1-4739-8661-343D60D82F7C@nvidia.com>
 <20251121085034.d8092d312da961b23c33a22c@linux-foundation.org>
 <31B02667-2F69-442B-AD91-6C0A7823BA05@nvidia.com>
 <20251121103945.13934959041672e76dd34ecb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:208:530::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: 651bf4ab-b059-48aa-c4e8-08de293186a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OEVSWnVZSjZYMWpMQkJxTTYzaGlLbmFRUklZYWZXNDIxT0Z4RXRHNmx5T00v?=
 =?utf-8?B?TWI2WWMzUk5CRHhWeEQ0K21yanozMzBMQ042Mm5oL2x5YkJleXFDT0Q5THFw?=
 =?utf-8?B?K25tNERWQTArajJReGRQNU40ejVwN1FTN3VEVmhhdGdNTEZMQVdFM2ZhNUg1?=
 =?utf-8?B?SjJQdTFCZElwNzFXT1VIUE8yZVl3NERrdFVLeGw5emU1NmI1eENPaFRwOGFV?=
 =?utf-8?B?N3Raa0s2Y1gySVBLZElxYVNYeEhoVzhQRGN3ajJwUW5IaVlXRUVydUhFSUN1?=
 =?utf-8?B?ZnlnUEZDT21SM0RreUtERFpSQ3RQV1pWTzB3eWJhUVYyQzVKdENFS0x6YmlB?=
 =?utf-8?B?UlFKZ2I3WGw5UWRUaElxRHU4RWtwcHlrUUJndDFoQXhkNWN4dE4wNXdpLzJG?=
 =?utf-8?B?dUwwbEt3ZnJ3Ui9ld2c3WXZxdElvQ2RhbDhUcGFrVVJERUptcWF1SklNdGE5?=
 =?utf-8?B?TU5QYWgyak8rWnlRN3pDMTFMVFB0eUpoYnlYRU5RUmR0aXd6QjJWbjc4UkpM?=
 =?utf-8?B?MzdPYnVxcmpsRlpFa1BnUUIwNDF3R2VveXVSUXVxaElkMVBpZTVWOThRbFBR?=
 =?utf-8?B?SXFabW5IV1RiLzV1alFzQlpLU2dLaExpTWt6bkZUNXU1a1lIK1QwTVIxTEF2?=
 =?utf-8?B?UXZBTklIWEZ0Wkpna2tXTWpKcmM1MUlmZFI3d3B1ZmUyeUF1NFJWa0JEYTFq?=
 =?utf-8?B?NDRjdUhBak5oOWVZemwyZDZhV0pWNmxDZWd0bnE2ZGlhZGl3ZXIrOUtzM1V2?=
 =?utf-8?B?UEhMa2FZa2lMR1ZkZ09RN094ZW13NVpnOTQyS3NxNmZ0Syt5NENSWHdBUWp1?=
 =?utf-8?B?QzA2aFAvZjBFVnhPVlNDcWhGcjdSMUJQeC9OdnliWC9oMGt1NDdERUtxNUpT?=
 =?utf-8?B?Z3NRc2ZRZU00Y1dFakkxVnh4alp2aXJzQUtiUytYNUtBVUkvUGZIM2swMnZY?=
 =?utf-8?B?OW5mZFB5L0pHaTZ0Y1l1d2pPSkJJWThYaGttTzJLY3FIZWFhT1UxUS8yN0hs?=
 =?utf-8?B?cHR2OFFFU01KSlFNVUhOWWR0VkNxYUVwM2lJSHBuNGFFeEE5dDRGOGZaSGkv?=
 =?utf-8?B?UkVWOGdOYWZVUXB0OG4vUDhnT0dhWEFPRGRxZjY3eTZhcjk2bDVGamFmRzMr?=
 =?utf-8?B?Wm5BZjRsaFNSZzdNK0hoSGhLN285aHNReURVKzl0aEVrcnQwenMxK0NGbjdN?=
 =?utf-8?B?SzV2NHFwMi9mRmVWWUFiQWtlc1BmajlMd09pNE9PWHV5OEpjUjRIcmtmTUlq?=
 =?utf-8?B?MTl0YlcrNjJRRUMrMHdzWVgvbXVkaWxRRVIxTXd1NzljOUIxV0hjcmNvNVVo?=
 =?utf-8?B?VDZyNHpWeGl1WHRScHpKVjBmTGJjUXRib3VseXUxZCt2WVp1Y3JUc0dBTnRV?=
 =?utf-8?B?cWZvQklYb1M1eDZIZUNkNUR6a3RaVDREYzBZL0tBc0toM29zQkZ3RXFDYUw5?=
 =?utf-8?B?THgzcTFDYTF2c0NRVW9lTFZwb1NqSUtzQWpFaUlOWFRpcmVLQytHL1B2eUlm?=
 =?utf-8?B?aUtzNzJqb0xTUW0zdFV6UDgxU29vNTZPNlpObzVPb3BYenV2dDBtNzJRM1d0?=
 =?utf-8?B?a1BKRVZUZERaQzhoTGdyb2ZmL3UyMDBlcjNyLzNFQzk5QjE1VCtCOENsem1X?=
 =?utf-8?B?cUVMREw2UndDU3JvTXBkYXNPMjFaZnpMS1hFM05lYkZnbnNTNEpwZE5qcG01?=
 =?utf-8?B?TXZRNzM1bkVvSlJQZHlqY1NyazFtUFdkN2hjL1laWDZTRW5KUDlQZm9NWVBK?=
 =?utf-8?B?NUYvYXJmQ1JxQ2lpQy9KZTlqU1ZaVHhiWWpmTXVMeFg2eE83dndHMHp1NXJY?=
 =?utf-8?B?UDl6bjlld0NDMGduU0ZrZkdpL2txSENoL1o2UWJXdkhWcVpLaVFOTzhsbGJh?=
 =?utf-8?B?alVVV3hTZFBSZTY3VnM5TUgrYTQ5ak5FdnZHeUIyMEpROW1NV3lBUUV0Zlpk?=
 =?utf-8?B?TmpLdCttMUJxbWE3VFhGYk51TzNncFl1OTdpVXBVcGM4cXpHNVFKNGJYeks2?=
 =?utf-8?B?ZlZCTDdYOVNBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnZ0bUg4aDFza0pjN1JpaE83ejlJYjE2S21VMktkMDdaek1FejdJSHI0UnpL?=
 =?utf-8?B?MXVBTWh6Tzd3QTJVbTMwVEE3aklxK0FpZVdhbmpvL2VveDN4K3hkdDloZzZ6?=
 =?utf-8?B?Q2E3U3dId0dNNVpFSncrK3hPWlVHalJzUERuRStNeTdHYXdMLy94QlpIM1Qx?=
 =?utf-8?B?UGUwaEVDbG42bkd0cmF5SWNRb09ZMllhQTd6N1VxbzBnanVqMTFuZW1ySzJm?=
 =?utf-8?B?UHZHWG14aVBJWmxiR3pUUUprNnlRTGFHdmdVbnJHNEVnQUNZTG9WaTd2U2hn?=
 =?utf-8?B?U2t2WmZlRnpyeXhQeDU2TUkzaWowY0ZpcjZ6RldGUEV5eTRKK0UwUHJpK29W?=
 =?utf-8?B?dnNXZ0IzOTFXbDY1SFlld0I0R3dGSGcxLzZzaVU0M242alVxTkNaZlpmNWlQ?=
 =?utf-8?B?R2lYWjllKzhpRnhxK1FEY1EzdGNZUEZQbkdPZVNmeVVvN1VZSmE3bURuTGRW?=
 =?utf-8?B?eTl5TXNzeHI5REJ5ZUZXWjVaWEJQMkE5VjR6ZlR2QmZMSG1LaFZIekFTZnJH?=
 =?utf-8?B?cEhsSXVTYlJJQ0IwYW1OZjRBRW5vSU1Lcm1iZW1ZbjNNVldnYkFwbTByVE55?=
 =?utf-8?B?Q1RBRnd1NzNtNEtoQ0VCUXExL3ZiQXZSWVRla3hqOG1Remg3UHBUOEVFRjdP?=
 =?utf-8?B?bnptQktYUHFlVjh5OFFpU0oxWDdPaTB3OUNFNkVEbXAyVSt1eTZGbS8zVi9z?=
 =?utf-8?B?ODNKWU80RmsySmEwbGh4SllaNnNaRHMyZEpNYjBBdlI4REg3K3ZMOVYzT3Va?=
 =?utf-8?B?MjJhNWJKdlhSNDAwY2ZSWFZRMXd2QlN4VENTS3Q1UVF5SlI4bVhqclVvZ1po?=
 =?utf-8?B?SXY0bzZMTWtTODNaV05qWVhpM2hUQXlXS0hkZWt2QmdLZWhkajNKK1k1U3BW?=
 =?utf-8?B?b2hMVHNFakUyckM1bWlnajZVYUY5b2MvOVVrT3NUbkYrZHlCTFFyNDZpWFYr?=
 =?utf-8?B?dDRudVEzVVEzc2hDU21uYXAwc0xlNjBnTStHRkh3ZFJ6WG5hbWNnTzhIb1Bk?=
 =?utf-8?B?WEFtblBpank5RFRHVVg3UDJ2T1l3cFEydVpyQ0FUSEJSQUt2WFdsQ0w5amVm?=
 =?utf-8?B?eno0cElhN0NWZ0tKclBYY1dEQ09rY0N4OEJPTTRnb0NXTDZkOFI0YVRZZ05N?=
 =?utf-8?B?djRqVG5MUTNzTVhqN0Jnd1JGMTFUcVFCVUpsNlBuWDQxODR1STYwYXRFY3pp?=
 =?utf-8?B?b21CQlJNSm94WEs5VEVQOFpSTGo3bStWNHFHZFdrYWlJLzROZVowTHNXeHl4?=
 =?utf-8?B?Z1dDSW1uTmUwZ3RlYzFOdHFUdEdjRVd3TkZzU1R3cEpVUkxQU3phTGN4RXdK?=
 =?utf-8?B?TTF6c3gxQUdIaEtvQzN3TXByK3IyaGFibmFkWDNybnhHMzZ1eDZ0TDBHWWsz?=
 =?utf-8?B?Tm5SbDcwU1hJVWxvS3RLbEdhUWNUNEdwSkdpdUJJRFlnMXpPS0hzYWorWGJh?=
 =?utf-8?B?YkNwOUcvaThnaXZVOHVPRytIOHpxUXhLL2h1K3FnTCtEU2RZWmZjd2J3TWVF?=
 =?utf-8?B?RUFsVnIzN0lhVTl4WUx5NU05OExOTUFyVmJmanVGZnJjZ2lnTHNEc0Y5YnFU?=
 =?utf-8?B?MzF6WFY1MnozSUJQRHpOR0p3b3VjTGRiUE9meWtSNGJHaDVOa29lbE11UFY1?=
 =?utf-8?B?cldTODdLSXU1V0pXY1JEaExUTWhkMStnNHFkRWNQL1dLaDN2ZFc3Zm5qRlcv?=
 =?utf-8?B?b0VpMlFPc1VYUzdCcXhzVllvV3prVk9BS1RRdkNmSU5udjhNV3ovN1RrTkdr?=
 =?utf-8?B?ZDhGWTRrRHc4d0lTZzJ5TXhNQ3VTME5INkpWWGp4eXFRK0xMUHJVKzRGVzAv?=
 =?utf-8?B?Unc2aklNeU00RHRoS3ZkeWRYdk5iWUREWjlWREYzSmFMZk1rRXpOeUpVdXRK?=
 =?utf-8?B?YXQrQUdFRWhIcGRkc3dQRC83KzV1THQ5clJkMUFvb1lZV3NmSXVrTmNsRzk0?=
 =?utf-8?B?MGxTdXcyQ2lyZWZtOFEzK0xpUG5FTnV4UkF4bmgxNTA2Qk5kMDBpc3F1K28w?=
 =?utf-8?B?b1RkbjRHNHFzanp0WS8rd0c0ei8xb0gyTEpPV01BMkpVNEpIZzFUTG51MkNL?=
 =?utf-8?B?SXdYcGdLOFZCdWFpVU92ZU9QT2ZZM1RCZlY5Nm9PS2ZJSmhPMWZ5cFkvQWFE?=
 =?utf-8?Q?AiwqoCxCULW2aM8OkPU/fZ7Lq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 651bf4ab-b059-48aa-c4e8-08de293186a1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 19:09:42.3294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBewoEZEPTtIhvCJao0pDpr/Dyq0FmsytH5TCD/1x0FkpA29NDf/ADyc0qta3dHg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6768
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 67834160015
X-Stat-Signature: z4juq5u1pw3n648kechigeycpddb1z3a
X-Rspam-User: 
X-HE-Tag: 1763752186-877673
X-HE-Meta: U2FsdGVkX18N0un34+yc7vIUK4nnyABP2E3gjh2U5rM3plYa30fKgCHFFchx537Vju/eCblUOtn6ioN1qMX7VvNdQdYfgMiZmIQvC01++jGocCdMWH3R11CcPGEnfQ9VMZkDn79224RgOzYqpNJrEreaRIruoMcfGs+XpzyGSJymISf0wpeBnqzXJgOJQEeyScDIbpuGM4By+T+Xi6eydov3owHINXGUJ3TzuaixPabIlUjeGC2L2mTbhKvHrtYcaFq45QX4S7DsV0YXDeQYYfly0qbfUSKItHUOnNd92WoWCSIgeK9p1YKt2Io8zomuL7JUsBByk31S6CEhdO4Hg2Mb0tcCaIx083I/v/PqX+75JgVT9JV9FIS0GEdi/bgh+duTo5+iFhoDiMqNZy0yP6Dl8sKWAOROQJEkyA9T5qG2OEdLDW696LrFQGSmJUrtt8oQuF/iT9vNrPKqd46HS4Pp6Lib4U4tecXFZUtlA1q+69c+ecefcz/q9Bvjb0ALyskegSkVGnyzpVn8QSnGe+M1pFyWfG7+tuWozu2IlGItSstlYbeAxq89+6aCGgeMadNcpsz6wkqutEXs3lB2rV1qFUskrxgUur1C8lsvuNzwVAOIpL77XrdYKi2jf1b1fS6H7Uq4HHzrjvrGjST9O2s3X9KEs2ecjJmA93QQb9W1aOp1mRAqT5ByxedUsezzzyriY+4uwI9hbI/fDLvxkKiGIU9h/Qmy58T2nAdkol5ToTpud0WV109PFSjz8yTmk+kFuICc1iMhgmr2P+EeNhiyDVvxolQeEubaljFvD9J6PCOIYR1QeAo9ZASV6ZjdNzsWmKP9Vl4DueqYmlUBARKzZnRT/9x4z5oMRLLPudYRa1WEjWy4XBezQJ3iv5yZbX12fx/+aCTQTKY7Ax5mQ/WnXYX11pC7WtAYdOK6F3cIhGmhqqoaRX6XpzcZ83BRyghAnjWVw3bchKUBxhu
 lpyQKoxi
 hfDAD5t2vouICz3bXVuNEq4MgLqFO+OqZXxmbqRyPJHT/fnZTBANT4yXdCcJCgMwVDzmasYdmx3ssppc3bp0gOrZ4M9dQusOGh2t2dYIj5MaJKV+E51S60InBzKONZQXWUWwJ4KTorqpCuGAPLzkJRPG530l8H/1EQx9xP1Bxy8YMjPlFnb4q5fiQipSFYV+DsmsbHZMYDK6k6QJPTydK+iRCKOZUyYRphGsdaiamrxOIYHbRBn+4WZoV654dQP3OY8S2uu8/mgl9WWL9rw7tLZCvGMpku9VO0Gh+YyTfrw9+PASJK3cDP89fiIG2guzhU/I7icL1QfmJo1LOAn7mmdFYmyGFSBxDQspeR5JEWBtoMUrhQ4byDfpQWTFzEDY8BjEJA1xVdUpPLHNKZeANNvIvIhCWptG1EixePv4siR5BByodjz5yQNLeMVyuNWW3ibyoh+KjQ8PLCAfPWEIWYH0dxoAwBjxqmaiTgN+D39xeTunwqRb5jig8mL4ByNLk/0HMoo1a8XonvANoU8s5ep7ccx98zKLrEre7dh6cc/xcYVNC6x+IkJr8mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Nov 2025, at 13:39, Andrew Morton wrote:

> On Fri, 21 Nov 2025 12:00:51 -0500 Zi Yan <ziy@nvidia.com> wrote:
>
>> On 21 Nov 2025, at 11:50, Andrew Morton wrote:
>>
>>> On Fri, 21 Nov 2025 09:59:42 -0500 Zi Yan <ziy@nvidia.com> wrote:
>>>
>>>>>
>>>>> 2. A further cleanup attempt:
>>>>>
>>>>> https://lkml.kernel.org/r/136E8B1C-3352-412C-8038-627F5CC8A112@nvidia=
.com
>>>>>
>>>>> This one is the related mail.
>>>>>
>>>>> I proposed one version in
>>>>>
>>>>> http://lkml.kernel.org/r/20251114075703.10434-1-richard.weiyang@gmail=
.com
>>>>>
>>>>> But it is not proper, will do follow up work later.
>>>>
>>>> Please refrain from sending more patches related to __folio_split() an=
d its
>>>> related functions until the above hotfix is merged.
>>>
>>> You're referring to
>>> https://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.=
com?
>>
>> Yes.
>>
>>>
>>>> I also have an ongoing
>>>> cleanup patchset[1] and want to get it in before any other changes.
>>>
>>> I remain unclear on the status of this patchset.  Is it considered good
>>> to upstream or is additional work required?
>>
>> I am still having a discussion with David Hildenbrand about it and hopef=
ully
>> get it sorted out soon. The reason is that the above hotfix is good for
>> backport but future user of folio_split_supported() can still dereferenc=
e
>> a NULL folio->mapping unless they check folio->mapping !=3D NULL beforeh=
and.
>> I would like to avoid that by refactoring folio_split_support().
>>
>> Wei=E2=80=99s further cleanup patch can come after my refactoring by jus=
t moving
>> a code hunk above.
>>
>
> This is coming down to the wire.  I'm considering dropping
>
> mm-huge_memory-introduce-enum-split_type-for-clarity.patch
> mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
> mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_suppor=
ted.patch
>
> and
>
> mm-huge_memoryc-introduce-folio_split_unmapped.patch
> mm-huge_memoryc-introduce-folio_split_unmapped-v2.patch
> mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix.patch
> mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
>
> and we can revisit after the upcoming merge window.  Thoughts?

These patches are fine as is. The patch I asked Wei to hold on sending
is =E2=80=9C[PATCH] mm/huge_memory: consolidate order-related checks into
folio_split_supported()=E2=80=9D[1]. The current mm-new, mm-unstable trees
look good to me. Sorry if it was not clear.


[1] https://lore.kernel.org/linux-mm/20251114075703.10434-1-richard.weiyang=
@gmail.com/

Best Regards,
Yan, Zi

