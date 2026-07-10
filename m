Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 324A0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 02:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524B56B008C; Thu,  9 Jul 2026 22:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DAFA6B0092; Thu,  9 Jul 2026 22:54:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0816B0093; Thu,  9 Jul 2026 22:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07D846B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:54:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76FA81A0327
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:54:10 +0000 (UTC)
X-FDA: 84971347860.23.93C14B6
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012014.outbound.protection.outlook.com [52.101.53.14])
	by imf01.hostedemail.com (Postfix) with ESMTP id AB5BF4000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:54:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jv0E5fUl;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783652047;
	b=EU5MBWSZInWAoltipPt/kAq0pRYDwQpeYAEmh70XKW9t3C3ufNe2GgkiGZkyHVgGVHlVQo
	2hZyELAqChBolXGfuYrXo3J/x2Jdux1jQ6gASU7s5YjU0L30Kj8dKRRhBBdMIJOnAEw1AW
	mBaGGEKxTvLoMi5qzGlLkMdFb+EB8Cg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jv0E5fUl;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783652047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcG3ukdZSJtiSjV2W+cokkgh7mgS6tXiJaWwnjHb9Ts=;
	b=Rh9CL2fG4Yvq0hjLkKeRkUpUMK+pUFDUNfazktEiJkL3kXCMZvLedunTPtvgEuQrtIDLue
	7W0gbg/VoZzpHboAJlHE3JSjaljKUP/7aHJX6Efqh76BP8ZrQz2GqVXlfOrh5Cm2iHbRlb
	54h/fsqeh7eHs8VWqjhy59+TKPAQBj4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bPsioe18u8EMXwW165WYjSY2hT9umxRKcEeTqTSWfW/tpqb/09yqBbGjq2YLxZMgKyfUqnknCjRR7vLGSSyqxOBDDiCJafwpqTm2K9RRJ5NIW+P0yHag+dmOMdjDdc3Ybn9zOLVcADrRtTVBipq9VdRH0PsFKS1apyKSWuEXCzcTaKHIZxRCCkoGxoQrhZZiel1ofHbXtmtG+cU2hKAzCtbppmYAoKGCpMtoubzqzAtCSBdwgrV/BXLkSElTx27iPtzNcqHC+z1FPobeeARmbaar8A1/wv2XMMAmmiH9u+vxUlIn6eCmVUXhH84krc1Bg5llsUDUD9f28YpqPFAFQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hcG3ukdZSJtiSjV2W+cokkgh7mgS6tXiJaWwnjHb9Ts=;
 b=RNFv3wSscwOJSJk0E2w/+q1Xm3+LwHO7sLn9wZIKkYn8YK00BPo72DmLyBtOP13eokMHOzMJhR72gEkJaeyYdHr2/riU1q48wtxXCSxuZSvA6/hjUkCFAPYCenNi46R/hDp2ExJLpdBb3FT0qaukesjdQyrc7CVGwqUeB9aBalXC6AmI0yserCHYDQtoyr/OxRv6b/hd6XvCgvRp+wEXc+umIiXzcxbB/iRCLYLLt5wiRM1sjmWvR7phg2weUswtAihuixgLyOPiX440tufcCkVzc9dvQPvxVxSD6Hc1yNaKtgxol7NqKGMO1fXnl5omL786/SJpaXyWawienWpHGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcG3ukdZSJtiSjV2W+cokkgh7mgS6tXiJaWwnjHb9Ts=;
 b=jv0E5fUl8MBGJxLaZTGXVZ5RpQA/a1sQlEVykw0q45Dfr4+JacZtFNjT3XSIo/X9P5+L7L06s2E+u/JWEmvPqW9tKvpqDZq7njKSJG8n3ogTlHADWNLt3Q1gYU2hn9sEW1Puf7tdLnUz/AN8fPBv1AaGxJ85NpeY8UrdA/AzRVVpqtOmyuBJ05EFYKNhjVhUYRb0xdwOCdE1pQ61+4OXkvuTZVzdF9KTp9y7Sd92XAsx/Mp8NeHG7bFsD6zh3D4wbVZT/xgWosTkgdEjJqMwbgnWLhPz4YjZZGlAqV+NTFYvWCGoub2qXmb2Q9goeyDiwWvZr2msItMPQ8yrkN+x+Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV8PR12MB9641.namprd12.prod.outlook.com (2603:10b6:408:295::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 10 Jul
 2026 02:54:03 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.014; Fri, 10 Jul 2026
 02:54:03 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 09 Jul 2026 22:54:02 -0400
Message-Id: <DJUJVOIVLYL2.OMQEX12FKKH@nvidia.com>
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Sashiko"
 <sashiko-bot@kernel.org>, "Zi Yan" <ziy@nvidia.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul
 Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Balbir Singh" <balbirs@nvidia.com>, "Kefeng Wang"
 <wangkefeng.wang@huawei.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com>
In-Reply-To: <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com>
X-ClientProxiedBy: BLAPR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:208:36e::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV8PR12MB9641:EE_
X-MS-Office365-Filtering-Correlation-Id: a92690d7-198f-48c9-bcd6-08dede2e8055
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|921020|18002099003|56012099006|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	h2f1KXHaTHMmbVgK20adOpsiUNotuH8jzcdkV+C3hmxBiHYTX6Mzk1Z7uIKjgl9y+u4aZ6dCXYwPZ4WLnw5FWENbxZMM68ssDat6INnqiqZz6bnCLsDpc0+BPw6zrh5kkWifSbkdFeeOH0okQO3rzPV5XN8WPXqk5+mje5mCUzXCSFncpn9csBAFoBGqLiosCWFB+2hIPuBNZPWjo0cUSwDMRXeagluIV7yrAeChTfDVN7so+/aw1Dw1Ecjmi5Rve5jrjFtyTPbdNZWNz4uSiTCxzXGOK8MNd2PJpVhxttgduKnjC2qBLLzeBewNtVGltlQ9msTejJgA7qIt6YIuaiwUYvyhY/ZJP43q/jfZ70Q/Mm/NqZIl+tIdNBql6jhsynFs+Ni+vDvOWkVriG+mKYSJpJouCO7hAqQHkba3TQSl4unsxmaZiDSvEMegVfhkT5v6+fQo0IGhTcc5YAG4JDN32zW8aiKt9YaIz/eTUPGCd64kRVrl7vgNPAvTdsfaXZW5XQ1b+FfBOhyt9HVTsm5us5ZMMhElix75RhFnBWrgDexQIMxZVhkL1oV9NI/GNqJ9WqytQkKvOvexf7mSDzatvf1ZGZUxJa0AUeaavy7X5gg08Srbro18BiisFbcua5BUvaMgK3Z3uhDh8u14Sxu/nzaa7aIAgMSSZMcvLStTAQ5cjIy95YrX41LmgUs0u8/srUM4qwcGrS8Q91nSnQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(921020)(18002099003)(56012099006)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGR3N1dYYXhPODg1Q08vNUYwZU5rcXpaaGpjNU81enZrOUdXenBQaVAwR3JU?=
 =?utf-8?B?THNKNXVDU0FWYnM5T2x3VmxpZ05sZG1SdkRSd0dkbjN4Y3RIbVFqclorTnR3?=
 =?utf-8?B?QXlZUzlLWEw0WlkyeFpIcVlpNVZJVVhGb09DQTAwTjF5MEh2Q0tHN0wrdGxh?=
 =?utf-8?B?OVdhWUtOd3pFbFY1YUtsRWpVYkVUUDFrNFV2SjVXS2p0M2Mwb3VNeXlIckth?=
 =?utf-8?B?SlZhUHFKaWxoRzhxSURjR0FQQm56RWYwTENhYjgxMFhDT0huYkRCcEhRQ2Y1?=
 =?utf-8?B?dm5Vank2RnNod0NEeXN0NEZiVnRLU1lrMnJ3ZFRGZ3VZQXQvT2pvTGMyYkh0?=
 =?utf-8?B?NmE3aStrSnh0M09TbDJIbU93d09zbDl1QmFjVkVjTE5abUtWV1dpMFhaVVdv?=
 =?utf-8?B?d2tJb1JGcUErZ2MzOFJwN2d5bHVYRGVGcldTam5lY0ZpdFlsVE85MGJUeit4?=
 =?utf-8?B?NDF4ZGNFeFhnT1pnZFl0bHdVbllOTzJuRlcrRmp0QnczTlpaY3hoTXMvOXBa?=
 =?utf-8?B?MlV6d2orbldkdG5sNm5xY1A2RVd6a2QxVVliTW56bVliVkFUd1BzK0VPSW9L?=
 =?utf-8?B?TDRZNVRwOWg0Q0RnRmdtdE1qeHJ6QnhmRHI5QzNSU09VUzk0MzVycUtTZyti?=
 =?utf-8?B?elFScXo0ODJzM0JYMmNuT2RWSWdHekQwbDNlb3hFVUoyaFlRWkxldUtPUWdq?=
 =?utf-8?B?YmRPMjErQzlZWGdXZ3llYkdMbWJ2QW80L213TjVZUnlJK2ZvMnpWcDg3L1FM?=
 =?utf-8?B?QTFaZ2xFdXljMmRveGtJMll2enJ3WjBDaVd0WGRCS3dscjNPeStPUEZENlZP?=
 =?utf-8?B?TjZwSlBRdUEwN1A2TUg0Y3lpaHh3ZWJHbDZpaVc1MGF6dEFjalA5VVcvUGRD?=
 =?utf-8?B?NlpXa2I1cUVtTUovandubjZEc0YrVzhpNGJnNStvMXZOV1BVV3VCem1vcVBI?=
 =?utf-8?B?ZmZRRVNGTEREc0hMUStnbkpTRk01WnJ6a1FsclFUTWw1YUFQeUxuK0lZYlZI?=
 =?utf-8?B?N3Z0T0ZnaXptdVZoS1hkNC9GejVMV3p3M21MM01MWG1FTGNKb1VSMGV6WVVy?=
 =?utf-8?B?WVBRQ09hb2poaEtYcGJ6SGh0aHpOdkFtWkdEQi96RUM1WC93OGVNbWpseDBr?=
 =?utf-8?B?Q0tYeEw1VGJVMW81MnJUeEIxdXFqM1JyUnMxMDhFMGF3bHMvb0pzT2s1WVRP?=
 =?utf-8?B?MC9TcWVFN0xiVHdLUFc2KzRaUnFaRVpVWlJUN2dvZDFuT3pScEo2eEh3WlZ4?=
 =?utf-8?B?bG90MUt0dWUrbU1JSm9iOHFmWTUrNTZuYUZJdmFRbjdleVE1RFF3dDJqdEI1?=
 =?utf-8?B?MVlESVZBYVB6SnVOc1d3aVhJZGJXV1Q3NWtESTJuWWtIRDVoeXE3RDhhbHp2?=
 =?utf-8?B?SHpoRi9HZnI2UE5LQTdER2RKdmVRVjBFbVZjZHVZQlNhKytncWJsSVA3Y1F0?=
 =?utf-8?B?Mk1wOXhHSm1NVDJ2UER0SVdJOS9yYVN2cmlLZEZWWXZpNVViOENzNGJQblJv?=
 =?utf-8?B?YzhwblhPU3BMNy9HWW8zQ05yU2pPZlRmR2VxMVV6Z0l4REMzUjMyUTYrNDU1?=
 =?utf-8?B?TmhBNERvVXVnUnNrUkczMDAraEcxS0NjdVFOKzFKQ293amJ3MFBRc1k2T1Jw?=
 =?utf-8?B?MTl0bEd5ZmF3VVYveUZTdGkrdXpQSXRoR1JjL2VSMFplclU3Mi91UXhja2kz?=
 =?utf-8?B?enJSL1MrNHhnRUJsc3phMFpXU29hK2IzeVpuMVFyMlJQdTZrZEQxVjhzWUhh?=
 =?utf-8?B?ajM3Q0h2S0VJZVVSelVHUVNxTzlSUEdSODVQK2NVcVZzaUU5a3EvMGZTVmxw?=
 =?utf-8?B?WmtVTGNmRHNiRzNOdFNDM3huYkhIcGxmc1VZOUtENnorV0UrbzNQcXhHdm1X?=
 =?utf-8?B?VklQSUkxbkw3d1RmKzI5dXJJSGE1ZUpkbXBjMUtzWHZqQjBDckV6NmlldmlP?=
 =?utf-8?B?SzVLQWxINDkzemdPUERXV0FoOGI0aUtuUWp1TDl4elQxOVJNb3dNQnlrTWNy?=
 =?utf-8?B?bnpacU1rUjZad2s2czVPMHE3MWYwUmVRNHNleUczZ2M4L25tWlowUktVT2lZ?=
 =?utf-8?B?K2pWYjF6WTBCNXVCQjlPUk5HN3N2bG54aVhabWl6dDhKaitxb1ZnTzUyYXpa?=
 =?utf-8?B?VlRNa0JmbHVnZk0rNWJWR1FsYk1KMVRqdlBwWTAvS2U0dHlqNEtpR1lWdG5S?=
 =?utf-8?B?dGVvOUlpemthT2pXZ0pUUE1aanJETEhMKy9MZVY1UjBoQlA5MGIrWExMdFo4?=
 =?utf-8?B?MTFxVzQvUHFqYTJFUDdqRmRUTU1vUERGTzRBbnNMK09ES1E0aUV0bW5pbXAx?=
 =?utf-8?Q?6zMYlYA9MEMG9u5uVW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a92690d7-198f-48c9-bcd6-08dede2e8055
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 02:54:03.8071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQVRA8N0g7M6xSUAZg/neeDR+9ts2e8QwoF0M+DsA1Ll+Ir4MWQ81lScKrqFuNNW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9641
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AB5BF4000B
X-Stat-Signature: cm1fxhr5d8q35ggnw4roc8ajr8hnf5uz
X-HE-Tag: 1783652047-547848
X-HE-Meta: U2FsdGVkX1/hPKRZYiC59ETgOMQ71yj/o6icggRDOrLJ2mufrICwLqBRCCihGvxy3/15fXrZUwEjoJen3HfeVG/mr45R6OrBtaKdv2GIi7EQ3poHcZnDnjaJoRbyC/Rvf0Gk39/m1unm1jO33/iYwgSfHj1s7QQO3B4f2xKbajYMmOu0VF/nM8SuTIM7kL/dgQGjNVHz7vLnIHNEiJLKJdiw7xZj+jX+bpKQYrW7YnkwmHB8qHLPvcZU2Yb4oxj0qs7IkkeDQQDX23MxjUrfpIdqDY/596WAyWRZk1jWjXzOs6L+B1I0lnk63Ohom0FQvvctE/mS2OKZx1r8VN6vmJZEHQbTBf6ocwoDZYyS5sBXymw+lcc8DcfDoKRpDO69BEgN54Hn9KGQNdZJTHET+phdIdSF8SPWt8U+bd6eqHfPnWRUtbL+ozei/KoKeDuVs7RDdWnsNQ75NlN5CLxqkgdjSOdu2tt0vDz9ev5eV3uLshDMJDF3QD5aFeHAY2Vtp1nnKCdmUiZ91otOjQjX2ikXeIgfggoFBSItuTwvq2JllfBfbQUhX8FH4tIl+Uc09hc9UQaCwIESz7KKfXe8EqR9VBXzGMIBw9Hdht0CGvSfK5cb+mkVfUXRWOADhcg5Jb9GkLp6KPlSCLya81Uw7EPdKrGiieIIUFFK0Ah4qLslZx/sVsz4PqyzqBxOmF+nmYz/akU7oZlJ8XAT9VcT07rM9ftjJ3C7a/b/HtBqF5Se+59AHDaedNxFowky6yCxFkDwGvl76kAWofmgd2VzVG7SZ6fnfhCOP1b8cpmodexfHefE7jkxnAfpT+5Wk6TwciIqWgK5XYdzvtL+/xwgV2OsxnBKplE9hBX5Prvnk9PzRf0WHUgZQpekty0sKdB9SYJBdv/p9mkpC3iSV7HZfgudrPkAewrFoF/BL0CZrHtwQLLEfvXmwf20t9bx4mbTxeIgwveTPsalvbDmaDP
 zf2z8gCg
 Sj/2fEZvtK/j0FBnen2k03ESPn3XJB02SIeSuk44vGQnDppEPk5px5IZYyg7PttGYcEOevT8WnWckKToJyNZfSV5xV+v9NFVuP89EERrQthhTUOsX+mhuXINnKKrP5Kz3B6aJqCGiGqkVi58IigN81JqnheycJw8faRbD8NJ5NmqH+gTy+fxMXpiT7SQqZtutII9B5FXSex/jZ8k9m8OqwHwBuOQXeJgDqpGeV1VvxyXfsoJ8qpPnOkP1noYMxOrVq4Mt7xYR/P9W0FhaAWsIb+HwtdTfx0FN+FVMAhUz7yP4FiDMV/GRY6OURe7gHW8G7eJNvjdZPqo+QWD1ebNHKkdrGjd/AVD8V+mPM5RAW0hZRrIn6vMlN7XzwRMtEqQNZYKZ4jTzcG+KlrTUkfE4NQsB7mqlhe18/OsuJqE7LRjEV1kTs9iLCBS707VQt4FxLHe6CM0uimDMzAfXRRNq1+Gzpt7DQxc82o3cwKgvimc4EyQL6bmswHWDCE4iZXu8rvzp4tZ6dlEwzQHMPJ1RQX/Co5ZBektZgKp+hBHbOP2gFQogqgcM8QANDwgx9WKiYR2k1rEUrzhu7B2N8BXI8q9pNRS5UMUpMb6HtIY28dT5ppj/lJ6OqWfUnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 7, 2026 at 9:50 PM EDT, Zi Yan wrote:
> migrate_vma_collect_pmd() can drop pte lock to split a large folio and
> restart. But the code does not handle restart properly when pmd becomes
> huge or cleared. It can overflow migrate->dst and migrate->src arrays
> during the hole or skip collection. Fix it by:
> 1. avoiding migrate_vma_collect_huge_pmd() if some collection is done,
> 2. skipping the rest of the range if pmd no longer points to a pte page
>    table.
>
> Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zone=
 device pages")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkefen=
g.wang@huawei.com
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> The issue is spot by Sashiko during a patch[1] review as a pre-existing o=
ne.
> This patch has the minimal change. An alternative is to reset
> migrate->cpages and migrate->npages and restart the whole range from the
> beginning, but that also requires a restoration of no-longer-present PTEs=
.
>
> Link: https://lore.kernel.org/all/20260706111958.3649651-1-wangkefeng.wan=
g@huawei.com/ [1]
> ---
>  mm/migrate_device.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>

Sashiko has a new concern:

https://sashiko.dev/#/patchset/20260707-fix-array-overflow-in-migrate_vma_c=
ollect_pmd-v1-1-ce3ff4627653@nvidia.com

Q: migrate_vma_collect_pmd() drops the page table lock without flushing
the TLB leave stale entries active? When an order-0 page is collected and
its present PTE becomes a migration entry without flushing TLBs, later
CPUs with the stale TLB can still write to the page, potentially leading
to data corruption.

Answer: No, migrate_vma_collect_pmd() adds a reference to the collected
pages, so these pages are not going away. In addition, unmapped is
incremented after a page collection and warrants a TLB flush before the
code exits migrate_vma_collect_pmd():

1. pte_offset_map_lock() fails, this patch adds a flush.
2. split fails, a flush is already in the code.
3. the whole range is processed, a flush is at the end of the function.


--=20
Best Regards,
Yan, Zi


