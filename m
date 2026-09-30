Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC52DCA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 15:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44E06B0093; Wed, 30 Sep 2026 11:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1CD16B0095; Wed, 30 Sep 2026 11:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C106B0096; Wed, 30 Sep 2026 11:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1F96B0093
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:10:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03AD5160809
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:10:34 +0000 (UTC)
X-FDA: 85270765230.05.D5AF499
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010019.outbound.protection.outlook.com [52.101.193.19])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0EABF4000F
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:10:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rF3LMWFF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790781032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIpEnQqeJD67Yt0sOkVklXGfQh7eSPXOnniolBK2wog=;
	b=x9W/QXpmPE1RDpzzTFdZn3mugX2PeUOJE2N0Ls2i6oG58uPxwQgrX+wvPfzH8IxTtwuVkI
	62HjKqvlbpklHEsmxFPeNNManOSaHFec9aJeFfFt+7gE8o90Az6WFwpnyCkW7nzXU0A3GE
	aNvQX2KvMd8f5jD31Lyw5W65u+uAdXc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rF3LMWFF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790781032;
	b=0K8z8KCXgYq0aVIAaKzp6nmHL/GcfTh47juIZm9rc5Y6/cXyL/hp4SrCGfDXpfBDQ1eNaB
	XS09GLcx/PPHoRuNQm1BOjoF+TvrT9yG0ciInm9c/BIWkXzIP4aUspYUfYd51ByBqOg3XZ
	HClcAVIxysKH5M5wnekB2ZK41r0Ct0o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gLIB8JH3yvTItiBD/G0K5CkvyrflWKpHFG6rdtRwiB7jdRdxuC9Jjn2vWRmukR6oPQI77UTIVmkR24dGEQe6dWIz7dnB7vOWdcK1VXR+BAhW87dGCdqipML+dP1U346IjGixSAT4/iS5GaUUH7li31A6elTd6f7tMNaiuQDeVBRBrgQxJsA2jXHdUG8itUmkfKqwcdUMCQDGz6kp+053U0CTTqjzvex81DansGkf5Ik2SzT1/0XKRKo0qz0wGOMWwflC6eX+1aOjTX8quQsHkQteZlUcgU5+QJUcQjG4qPLAcAj8/E3sDb3aWgASUzS3GVES6IG8mYxhcvX1/GMbbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIpEnQqeJD67Yt0sOkVklXGfQh7eSPXOnniolBK2wog=;
 b=NFwD6GF4ywwUoSGJwVjKRZi1+kvyvyOtXhHl1hgzeiqM5E8HjqoEmR01mvfBptxB+pH4RYRCI/ChAtQJnFSQ+G+U0CWQ/h7wlIy3ZPnw4dE7roApuvxWCs6jRF6zUVOT/vFXtyok04vl/Sdsb5MWZgtFTl7TRAW+yJe4WSJZjmSaY0FgbiXxWNwyQU0afTN9OMH+MdcTDzob8Hri09XcEo4W7IuyK969C/BwGZbub3HaPCyH6u3D6+1+dpfRRYNy+F9HK3+/sIhOpQO+NNkipixw8vYoyIk/nBQegHGGGwV8vS4WEi/tUyIUlOP3M2zxP5lAxkTCERk9+k4PnjFWnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIpEnQqeJD67Yt0sOkVklXGfQh7eSPXOnniolBK2wog=;
 b=rF3LMWFFYLaGqtyqSPTkSZSyYgkR0WVIfiMn158Aj6PlPZM+QRLQxMYvKm3URQQ1b+22S1ciDg1Cf09JRw9IjLk/uTqrWyupyCYvUgqQLCimhvHAhV5Lxo84zsbz3ZtWKgOuj7z19/rbXgcruHsPXQnKDk1hqx/n/R12UDqYI9kMxKhng5WfPqJgyffSHRS1kVUuF1r9BO9tQ/z+fYhiAHqH2Fx+kWF69w9bqy3zK7Fuwxhaxf1QBl8Lyraf/Di/q/qFFoAxK87XZcdVbvxcFO2p5fvE1hQgEGV1JgtXji6trH46I7ZqJukclwCDg++9WHrQH8GnRIT8VOWfhkL2qg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB6824.namprd12.prod.outlook.com (2603:10b6:806:25f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Wed, 30 Sep
 2026 15:10:21 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.015; Wed, 30 Sep 2026
 15:10:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>, Li Zhe <lizhe.67@bytedance.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, rppt@kernel.org, mhocko@suse.com,
 corbet@lwn.net, skhan@linuxfoundation.org, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
Date: Wed, 30 Sep 2026 11:10:13 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <A005B05D-A85C-4153-A65D-0BDF9D8500DF@nvidia.com>
In-Reply-To: <ar0fURbLDPrphYMY@gourry-fedora-PF4VCD3F>
References: <20260930121154.687586-1-joshua.hahnjy@gmail.com>
 <2e3f12b7-0dac-428c-b70b-07e1f63de028@bytedance.com>
 <ar0fURbLDPrphYMY@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0870.namprd03.prod.outlook.com
 (2603:10b6:408:13d::35) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB6824:EE_
X-MS-Office365-Filtering-Correlation-Id: 82bb16d7-1086-41b3-54bf-08df1f04ee54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|18002099003|22082099003|11063799006|4143699003|3023799007|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	HKHZAYxG6ZbyjpFSLEAIU/ynIXNb+x3YvFHwJgGgy3oddFitj/PYqYDEq5STEARUrWtSp15i45tMEBF3UVS6bKIan5By3MEm280XQwiFieZP5vpKrl6Y+UxnYhTzTN8dWus8UzquREPdOJQNILcsZI4yuZKNrvtPM5BS3esGekjSFAxc7yV22yxa/LiW3GYDAA6hwf4egl2/19h8oJjfkC/FtFXpZp0hcp5d9qMxTXkk1ZweLlXIsqDMLZfKLwaKcT3dv97UZlneNU1tUXtShgrf2pX7UHgOnEiD5+HftzIdck6uTIPlEDGajv+V1eIzlVHFa5pphLzczr2Z8JWqRfTykiystLAkLUiQ5wo8HuP05TKVA2+aMQcsoGiBAPDdm/xJD0i7kQKZPF/O2hY+UJIH7rN3GN+c7626CP5CdRNwOs8fFR4gjCKenYprDFAdSPYppTGW7SP7Kuwn2ZZDhbQABpyR6zWiHWLxlL0C6oj+wcIAsjGBllxXz1fUpNF4zw6lFDNkiaCEnGkxx5NztWopI88bmqRBRa36H08JlgpI6sn/HEBQHhRfmSz0DP0ymrCMKU/1NpEkx8Ou8Cvwf7q/3gHi+M7XBh1BYxo06fhrmqJxb9EHLdlyqCS5pogY2IjHt3FJetazbhs2qkXvYXhMLqf/yETBGeRDuLpPjA8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(11063799006)(4143699003)(3023799007)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0xhcnJxQjhZamdEb1BBaU5aTjdwNmI1MmViOTMvcDZZbUhZOHRPSDhsV1hQ?=
 =?utf-8?B?cUEyb3RMMFJYS25mOXVwcFZWbTlaU3B3Nk5XL1UzWGx4bHY1T3o3TmxaN2Vh?=
 =?utf-8?B?ZEhNRG5LakFxT2RGMy8rbDYySFpGYmUwVnJGK1F4TjVhWjZteWcybHJCT0ZP?=
 =?utf-8?B?OXZFZTU2UE14REF4SWhJVy90WDZmMFpXM3Nub1k1UG13S2ZBYmEzcm9mcGFE?=
 =?utf-8?B?Q2pwVDZGOHlPVW0zaC9mMCtnZENnOVczT2ROR0dseWtMdHZ3N2hRQlVjRUpY?=
 =?utf-8?B?YkNzZ2hTaFR1TmJ4ZEZhc2NUWDhBempYMmtHSU1sd3RCayt1YjR6Zm9iNEZx?=
 =?utf-8?B?dVorYThLSzR2VW41Vm1PVDY0R05GVDM5bFRmSkxUQStEMmpmWVhqR2V2M0ZC?=
 =?utf-8?B?VUdCWDNaZHpjRzhZSEpNbUlsU2dsVTV1aUx3eDZLNVdab0lGV2R4Q2tCNnlK?=
 =?utf-8?B?b2FycnBtQm9QVVkwQzdaR3ppelJKckdCVnk1MGdoakFCcXpza08ybHk3bU56?=
 =?utf-8?B?ZUFhSE8xcWI3VVEySmRIUC9YdVU4VDRvUXoxTTZqb2xRdVRwaUpWdWs4djY3?=
 =?utf-8?B?aXBUTjgxK05SejdaNWExTHJUS0U3MzNuMTVIWkl6bnh3dktZS2UybXNieUlQ?=
 =?utf-8?B?Mm5ENmQzdmR4clpPenJka2dDbGU1RjVOOXlaKyt3ZEIwc1hZRWIvWEt3a2Ew?=
 =?utf-8?B?LzRaTitNR0Nwc2JaZlpCc1BnNnVjL2pSRTA4VlBJUkVtUVNyUDFsaTRIMVRX?=
 =?utf-8?B?OWlJaUZOczJvWTdlVThWNGFWL2JLVUlIMmdta21RZXJobHJjWk0ycDlhRDVN?=
 =?utf-8?B?MmI5UnpldlRhZnRzSnNEaSswMzNMWkthZjFIR0xPazA2cEtycHdnRHNRZktq?=
 =?utf-8?B?ejV6QXJtUGRxaVJ6dWZZdjNHVnZ5eVBLd3hValZJYXVkZjg2WUMyMGIzdkl1?=
 =?utf-8?B?U0ZNNmRJZ1ZYcjJLSWlaVkM3L0lOc3RvYnNaQnZTL2JrajhhOVRuUDZQenhI?=
 =?utf-8?B?ZlgrOEJWUmxIZG9tRUZCbHp5cFVwcmkrSXlDK2xnMGt2M2lUbXc5QmFrbzNq?=
 =?utf-8?B?MFN4MkxKQW95UFA3T1dxcmN0aFd6amt4VTdHSjF4RDQ4eEkxSGNxNW9la0lL?=
 =?utf-8?B?ZVcxR3hDMUlySXNId0RGVkVrTjd4SnNFNk1TV2h5ditmM0JHV3ZTMkxCa1FL?=
 =?utf-8?B?dFloMWZhL2dWS0paSHBVZi9hcVhTc003Y0lyUGQrd1IzZWZpcXJDOE1EalFn?=
 =?utf-8?B?b3JydUkrUitlYnI2SnB4ajdaZklub0QrV1kzRkE4M2Zza1JNVm5JRExwaVND?=
 =?utf-8?B?UE4vNmtFL2gyTkZ0MWpoelNKUnhtZzlGbXVwRnJhdTh4WnptODgxcE11QTJF?=
 =?utf-8?B?dkFqTmJ3S054aDBZMTE0Qkd2b0dMZXEwYzRiZ3pIcFNkQ0habWV5Vmt1MjhM?=
 =?utf-8?B?djRLQmFBQmVqdFlhcklnbkJqVk1PcnY2eWs2a0NTYUI1M1NxZjdCQWZxSGF5?=
 =?utf-8?B?dG1kdXdFOEN2bldieno5RkRZdnVtL25JUmkrQkZuT2xsQmptZ0c4dTN5RmdT?=
 =?utf-8?B?ckdCN1FQc09nb2lvTVN2SXkrYXNHd0w3R01FUDRjL0YraXQxTUNPbzVLQkpR?=
 =?utf-8?B?bjRSdjk4RHZzRjNiR0QwSkJuL2pvM3p4ZWdjY1pxRzBkUXdVZ0MvMndQaHo3?=
 =?utf-8?B?c3RIQytPdHloOEp6WXJaQVI4bTZUREZVR3NXSkhMZGJaZ1YxOW5FU0FsckpW?=
 =?utf-8?B?QVFNYnRuMGxuUWVuL3BiNXV6dmw3QStta2k5anBwMFdTVE1Td1lrcXZzN0pq?=
 =?utf-8?B?dkYvbGhuazVJVmQ4SlJUazFaV3F4SlNpclNQajBkKzB1bFVndXVsYzcybGJj?=
 =?utf-8?B?SGdsNVQrUVNNcFMxdG5WeEt4ZGxJcFFpWHhzeWF6azRIdUFwbFRrQWh1WDR1?=
 =?utf-8?B?RjNta1R0WkE0REVZRUtvTjhIL3BVak5JVndxbXZ5TGdLWHRMMHNZc2pQRVlW?=
 =?utf-8?B?dWVjdXZQOG1jcWxrRWtWK0VJeDdpRmZXbXpncWZkU2tJdTRvOGVZT3lHM3V4?=
 =?utf-8?B?THd3QUFFQW1jWm5kWmdoK1dTeDFiaGRlZ1ZZWkwvTkhEL1Jmc3pDbzdDOHVV?=
 =?utf-8?B?SDFPVTUyWmVNUTc2WTN6UkZaOXpOWGVmUVJSOXRPNXlqMVN5VGNvRUF1a0Mz?=
 =?utf-8?B?QVZQWmNKVzQ5RlhuanFlV3ZTZ2ppUStKNm52L1dNall3eno3ZjVxRnU2OWl1?=
 =?utf-8?B?U3JVNGh0M0MwV01mcHBFZHNqYnRYWmhGZkx6NHVQYVV2cHd4ZUhNcWFxTFo1?=
 =?utf-8?Q?RpnfkmSsUxwuTAYROD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82bb16d7-1086-41b3-54bf-08df1f04ee54
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 15:10:15.0193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0gzCwtjpwZGTxKGjIjmnIfR18/MFmOlrOprL7uQvWipOwecyze9odJfZHDZ3bkLm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6824
X-Stat-Signature: m5yaq7rt7tacej99yrjzjk4qy9hfgd45
X-Rspamd-Queue-Id: 0EABF4000F
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790781031-392349
X-HE-Meta: U2FsdGVkX18JemtjedJ/E73u0REK1m9udLMQ/6ob1lAcWX4me5l2D4Sh54wrBLH606e1xO/kRcEEjUPlU9+SCDRSKaRUdTZjaAdjERi2kIJLnSGhiQYkpcTMT1dHk807ZV8R0rQL2i4lNzMd61tlu5r/WPQa2jxk2gSaYkiskZBB1Ey0Zxc0+bae1myeswkwUO5CXQZh5m7fX/SnMZ+mBtlH28N9WA3sfAVL2Z3XrZgaLMlhknmrjqmhcR+m18nvzTaZ6XduOuCzyBBR3b8D0IdwyN+Jt7SzdmOm3y2euMf963uqkRzzsrpMdR1ljarwI5VQ3X3kro4Eguuc78AsKfTMVyFSRHOUAYotGQL2ZEbrwAKOqLNItEFeTohZ5yhwb6YdympuSppyRTYk990Ru8iUuGGGAyy2rKvnWjTrhEMZ5yAKQLzgxuNWzKcRfiBiPeh6VZHj+eRABvwteIPzw4n12yAnBy/IaftGndm957xrKs1Z2pkQGiZ38ogcUsa469OwV5s08f3bQKSb3cXUlx68wT2yc8OHv/cAk0RhRdqncVnFcX66B9ZiC3caO+LaaDFkejaS7CAWBRQ1YYURnnzcqCZ2f2fE9oLdeuJcC5+23uv1AsO6LScaoreCDx1vF4qFApXN3OPX7WZBN8U+qeUSA/BcP5rv5bMW82N2fvlk2vYV2lIfmdYCviyyspIrA5YsERngGyKJlyBGsptXO9SOMwezlv85q06uJkV+4lE9DV+6SeVu428fp6nKtVm5NgPjrCc1DGGHdeaUwbaMTI0cR6qDYdpOK+egGeI2+au/OTgAPjJIyFSZ8vMxubGoagXf9qyH3RQjCfLtvdfz3NMuvJD3aFf+rs0xOMEd1yfIY5nuEWx7QbCx/G6WFlD8qoeMulcbPixo+EywDJZ4vGlkknED5rANDmJzW7Yf1zL9BBzIvbaquL3ujOlVLk6ntjGL/6ZQYsnFOMTz1eL
 Iv+2+CRj
 whNi2aB9+ML0iy+SBdnAH4GCgKsa8l8ypogA0U8GbpeZb2hev5NyeG3tH2VY34gdbZ6y3/6+t5DQsDhBmwYLF3du4ek8D6tBGYExLaCHCxBD75vUZz3U6j3ZzwUtGZ1IR83Ey9tWcLKoFdytfvtXPG77d6JRXrVUP85NrH/9JsIsaUx7wl5mvdZZwH+KnMHbwXhim1VDUUOF4xbSBp/F2kr2+GMNXOpgqFQH1TxcsH3sVP5XVk7uqCip8DO1b8XosrZtLHKWNZHeGc8T72h/OJMFezGqpdxRYdhKQdPQp05s8n40EoXvgNf3afgussdtN8ucOejrbJsJs6goA0HNpaWDqPjUwpGPMW9cYosIQ8jr0Yzq+WaIlNQrurL4oqhiAgSZv3xlFeVhL8J5TvEmE74AW5HrPOOHb1Qnmf0dOudu9vig/XOlnsF4mWBCiF79m4IyUMiOKAZnjiLF13el1S7og2/uigjRVyBv9xL2Lqbema6N3UIKCpbdeQxLrcoviPlqcT/Vpk52/i4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Sep 2026, at 10:50, Gregory Price wrote:

> On Wed, Sep 30, 2026 at 10:02:23PM +0800, Li Zhe wrote:
>> The use case is closer to the second one, but the main motivation is not
>> only startup-time performance.  The more important point is that each
>> workload has its own DDR/CXL budget assigned by the workload manager.
>>
>
> mempolicy is the wrong interface to do budget policy, you'd be better
> off looking at Joshua's memcg tiered node solutions for that.
>
>> MPOL_WEIGHTED_INTERLEAVE is useful because it lets new allocations
>> follow that per-workload budget from the beginning, instead of placing
>> everything on one tier first and correcting the placement later. This is
>> important for workload orchestration because the workload starts from a
>> placement close to its assigned DDR/CXL ratio.
>>
>
> This however is reasonable to me - you'd prefer to spread out the cost
> of initial faulting placement explicitly, rather than simply take
> fallbacks when the top-tier budget becomes pressured.
>
> i.e. w/o interleave:
>
> [node 0       ]
> ^^^^^^^^^^^^^^ alloc until full
>                 vvvvvvvvv fallback
>                 [node 1          ]
>
> in this scenario you end up with considerable hot memory
> on the remote node consolidated in time-space (everything
> allocated after node0 becomes full skews heavily toward
> node1)
>
> Tiering then likely takes many faults to rebalance after
> you've already reached node0 limits.
>
> w/ interleave
>
> [node 0                                      ]
>  ^^^vv^^^vv^^^vv^^^vv^^^vv^^^vv....
> [node 1                                      ]
>
> In this scenario you do an initial fill distributed by weight
> and then let tiering figure it out without consolidating all
> of the pressure to the point where node0 has no space left.
>
> That said - this seems like mostly an initial-fill problem, after
> you initially fill your memory, a new allocation largely implies
> the memory is hot - and you probably prefer that to be local.

If this is a initial-fill problem, can userspace set weighted interleave
initially? The program or harness can observe memory usage of the program
or related NUMA nodes and switch the policy to numa balancing via
set_mempolicy() or mbind() without MPOL_MF_MOVE after certain threshold
is met?



Best Regards,
Yan, Zi

