Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED48DC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430398E01BE; Wed, 13 Aug 2025 02:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C02F8E01B6; Wed, 13 Aug 2025 02:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2816E8E01BE; Wed, 13 Aug 2025 02:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13F818E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:06:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B040C82713
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:06:20 +0000 (UTC)
X-FDA: 83770699320.30.9E85CB2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 54DEF14000E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:06:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IEuDShlG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cZDpcA7l;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755065177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XozO5/Td7nKs9xH2Azr/7Ci1bep1sXP/zW1t0gNgMWc=;
	b=olMDz+hUD6c6LwSeNWzNBQzxQai9j2zZkmWsHAsI/B46D0W5TB+ugnga0/VO+Gg+krsXvS
	nNUWyzCyv7SHLAO50Wnu6cPxNi2p1bvGUtC/jqcN8tawe2whkKwGWY0aZv2x0Wnm2/4kua
	IzJQQZHRY2P5zpe+h9b3q0ahO8CqmrA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755065177; a=rsa-sha256;
	cv=pass;
	b=PPXEUYic9N9AzHImgYpYFj8KYNzoUfoznCxQBMDOvNLduLxFBWe8GkaRCTMszVou2E1kSx
	Qezs65aNLWJF7/Nsh1wr7KBqrrKq0m1ux+ezSRui7OF6nxJ/5qfrfBBsyPdPBlHljWnX41
	qZ5/vrfYiVsE4NXoojtqO4P5uGbTPhE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IEuDShlG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cZDpcA7l;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57D5txEF015673;
	Wed, 13 Aug 2025 06:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XozO5/Td7nKs9xH2Az
	r/7Ci1bep1sXP/zW1t0gNgMWc=; b=IEuDShlGe0jLjVAqZpAF3aB2k02BICE9cy
	Xi/SfMYS6niXmfgDo/LWeKUPYhCL1JrAw+UMihaByXLLKdJlrUxk27xyaOlICxjr
	akBGaR0Euss1kDDh5g+hpytyV4UBe+5VeGaapeK155qwuNdUIsNt7YAGGrCJA2xb
	NY8KT8DwbaNBlYbeZKkAbng9bMO331uD4rH/csbOm+BO8LvDVj6468ru7VIFgn1B
	TnTGq98prKuEPbi89pfXaMt+NOQI1+3JPPR54kVDlbtN+qQzaH/AtIBcNuKgHfr9
	ey4tTG6fw+aOeHVlGmeLsxbFSjKO55Ty3JHcjXy4oJ+H/BAVAFGg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw44xgy2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:06:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57D5sgO2030111;
	Wed, 13 Aug 2025 06:06:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsaxhr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:06:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sH45Pq6p62S3Y2J34tM0mSXMI5nrmU5LP1uejhZl+V08Lm0jZKljZ4yt0AFqmpMg1L7WzslzgODPevVSmHABrUJzurO8/RYC7ALkrznRKaSu2D66HqEe9YRCKw8eN2VCbxS9LG4rxUTAKnFZLGz6JbCGBduFiP7iaTmoqG7fAGZWokH1yZLPeMJg/Nb0ndR1lFz5I8QJjK2jPkywfl2wqN3oa9cNnuehRj3X68ATTwK9hRVFzajyU4ozE/imdZSi/Vy5FOXlFB3NnSUJBm/HevYGSKNiiDpo1N5+LALuBaQLdBK3u8XFAhfglSU8bW5V3h2A2QveiA4A8g9rTonhDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XozO5/Td7nKs9xH2Azr/7Ci1bep1sXP/zW1t0gNgMWc=;
 b=FwF9Sfchf68+7hd4F2sqMCvN6tuoVGOAdkTTvNUCth4ndvJybU8+4pXjykBlpN/1GEpUQfdxKYPU6ElOT9mnf4c7ZaKS9BCyTa42K1zZHTuVdQQ9mN8XP/Vp4LUAdMxU7DkAbC+EwUGtxcyHQaxHS71CcmTY2+AWNpM1zKdZqTiOdGPNlFmtFpcRUVtKNhQPSGKGJZkxm56NL5Ba6TDKjNKb5X1wFiray+P6FZQffP+2sfAInDvDdfkB7TXHpV9UUFn+R2550tXY/n3zAT6cU5gxOPXZXs8SLMiYXPEneAkeH3fJGSWnZxV9PhrhWvLCwkJRW+YbePwtqY6QkpnA9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XozO5/Td7nKs9xH2Azr/7Ci1bep1sXP/zW1t0gNgMWc=;
 b=cZDpcA7lmDjp5iebl+qRbuTgMA1iPQTKbv1qdtG56MmsBYpROBLWQMJDQydN/0rZ3XQKhVWw9PidL4FpckVngSRz64PkuuirIA82OxekexkTvHXAOGfIZEYbo1Y8ky+BUFSkdn5APmBqJCwDiA/64bQxpzHAv5QuMKvd9fy4+YE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB6642.namprd10.prod.outlook.com (2603:10b6:806:2ad::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Wed, 13 Aug
 2025 06:06:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 06:06:04 +0000
Date: Wed, 13 Aug 2025 07:06:01 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, baohua@kernel.org, shakeel.butt@linux.dev,
        riel@surriel.com, ziy@nvidia.com, laoar.shao@gmail.com,
        dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
        jannh@google.com, Arnd Bergmann <arnd@arndb.de>, sj@kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-team@meta.com
Subject: Re: [PATCH v3 0/6] prctl: extend PR_SET_THP_DISABLE to only provide
 THPs when advised
Message-ID: <0f8b7e64-d08b-44d6-8a1b-2b4b8d64cbe6@lucifer.local>
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804154317.1648084-1-usamaarif642@gmail.com>
X-ClientProxiedBy: AM0PR07CA0013.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::26) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB6642:EE_
X-MS-Office365-Filtering-Correlation-Id: fbdcc177-76b7-49f3-1f9a-08ddda2f7c7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9KcOxDAoBa/Oz/bZcA1MCiUmaJZ6TLxKcj9Ja5uRKZ9LQ7ko0nwXB56sj/8a?=
 =?us-ascii?Q?3ExMdlqq+5eNqq8yDxb18OKg8i24NjU+aL+pmJs3CsmM7B0r/Zi9GqiSPlV9?=
 =?us-ascii?Q?kyHCwOeDKe+s3rzP0jaU7fN6MLOj5C2H3X51ScneqvoKj9H8QHskP+ZuoC53?=
 =?us-ascii?Q?6wcflhB0R9RV8B9a91FItFDP+53G3dj0yNwsTYMfyX7/Ay7NjailiNiZuIO8?=
 =?us-ascii?Q?iFIUaS2N33Qc7qvCutAw1a+bB2UXceXNdmaEdHEeM26L9KYGw4UMmhNJim6M?=
 =?us-ascii?Q?CsoYM1QQXlQ6D8Aa6Kbk5BGDbqzYh6/liMUdFZ5sPMhGQuTRR57UuWk9KwyL?=
 =?us-ascii?Q?8eD47Gju+9hCVsEml+um3PwJ5wyglTnbrhF3tE6Gv4/ql+R3zPj1L1VukV4M?=
 =?us-ascii?Q?syQpOQDa7S0U+IlCh7oMUYmNCeitL88QSe4CpXS4F1oLzf3lVu/xZDy1+y2I?=
 =?us-ascii?Q?JPMh0ioRGas8UH3jBe0HdnwapMvJZlSWwVIujegxRZYf9Sq86Af/Pnmnfiy/?=
 =?us-ascii?Q?jPMp3zyIf2R6JfnLo4ezXeEt7tP0IDM0c6s1jnkNUFAD4GybVfTtOhwOYicd?=
 =?us-ascii?Q?SjR3MyBQdRjRkpcvFi7s4RNiPGXhsylpNcqNTskWw3NwTVXaLCaJVmmzhqGi?=
 =?us-ascii?Q?0UxU7WWr+r7d72vRlCC0w01iCyOW1+JsK7Ur7URHr7R8KWKpqVZ+B+Tg23ai?=
 =?us-ascii?Q?phLeCw4iXMxMiyfTFLjWAYUX8i4igR/AfRilobPkVFkV+GP+h4MYXiun4YU0?=
 =?us-ascii?Q?h11KeNS0vaIMj8z1s9dZbqA/vYQIwKJ8RhMebu685jr6dBesSOP2li4sSxtG?=
 =?us-ascii?Q?mt3XTsSuqAA304x+gs1xIsr//zGRLMYj+qn3lZnNBX0YVk84QEThnPC1Jd1I?=
 =?us-ascii?Q?ulGYuenKZlU7LEp8uO/9qZZsEgR6w9cl7Q3ovfXDnPI/I81xkEo5KklWY/ty?=
 =?us-ascii?Q?AdH+HA1eqgZDkwQlonW2AbUt8PMAV0yfl8xek9kZEle69vxK3O1gSWgfjE6c?=
 =?us-ascii?Q?UD7zXFRTfOrKpxbTfn+6q68XItsqkViveHxq9Z+/cS/THEYifrJ4Iw4hFikz?=
 =?us-ascii?Q?jM4Av9LJECwb9t4JrHPMLBbisA3YvnDMp8WVFvvtK64dQcW81Q4Gi9Aw1tAM?=
 =?us-ascii?Q?tdLjEakfrVzsDLNeeMN0v/D01wV4n2SW0o4hNgMWOAffLrbLPClyt8zrDMah?=
 =?us-ascii?Q?A+im+O1vlgkQWXIuYcvlDPZUBihwWDyq1A9t6zNXfuwgMpXmq70MJKxu2nOO?=
 =?us-ascii?Q?ibGlln4WaPp2XnDFi6da750m+s0DvmEeA6UN0p4vIs9F83blXdCV0RVLP085?=
 =?us-ascii?Q?9kMhBWTRI4G/M7e9ftoAOOkmMirBu/M+EU5TJdBtMa9ogwIMKc3kLxIPPwWK?=
 =?us-ascii?Q?ZjQP5jf32B0FtiWLlUADJJK5LcVeYtOTmy7WxERjhgLSXUeHVWsG7Yquzrc/?=
 =?us-ascii?Q?VnnsWODYaPQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AeWlrl1wKWyq8qBZPqIDPsYd4EuKAR2w/SOU7KqLp0jSFnQOvH0zvtTXRCsU?=
 =?us-ascii?Q?kbZBD0g8k8WCLuCB/1JLuK0wp02bxVitls3DNkKi9/JajCEMNJ/wxPhGkhU9?=
 =?us-ascii?Q?7RWR9KPpMLFtLWDL/ip9+iyoswWNLG+2/MJIFT1Jti0RC2Azgl6xolU8Q9ny?=
 =?us-ascii?Q?U3s1XhHqtWEHkfnmGcRhKAYJw1mGoxoIfNwDRsluK1T1F1g3j90T7Adeycb6?=
 =?us-ascii?Q?UuyiIX8hZ305pFkh3f2jMikgR1UiLkVQ7h8+l+ru3yGwnsfyf9ea3kslHate?=
 =?us-ascii?Q?08O04VWmayFLPk6k3O+OYtF8FqgZj4xhvn/pMWtNlNR67oC2LhOAhvifhmx0?=
 =?us-ascii?Q?3yxtu9s+ZC3wk4uJ44sZhMNg1Uq57kS/cfvbFKt+SSYK4ktur+BHkpIsGSxL?=
 =?us-ascii?Q?pwwzPUd5luTi2dgc4liP++55stLR1vP0Ce77Y4KXkpK3fv2Ew6x9XqhYZqky?=
 =?us-ascii?Q?dwaRkU3L0uDEHFAI4tzvg4XUEx/kHJzzsuEU9/WHygmOJ5cmZlnKlCe0RRN7?=
 =?us-ascii?Q?Vl2g08lFqfHI1vc8ykrcWTEL5TmV6mfQr6CSRpFLOA8PPQvK3cn8dJ6S+qWT?=
 =?us-ascii?Q?QIFWJZWsCAYQ4DRm2nIzlvqP8do3yCpFd9Ewx9EdGuXoBofjCMtupCNxkick?=
 =?us-ascii?Q?io8J6ZdpWuFio7LR8BGKNehKzr9zXDEizOK6xGqeeWTUswdFQA1QNDZ7Nxok?=
 =?us-ascii?Q?3zMaJyotvuOJxTeuB5qa5WRgW8RLfNKpCBMTfwCThx5iGHOegrOMDuyMs2c6?=
 =?us-ascii?Q?Kq0XqUT3ncTAhOgog1QYqOMdD6U9K3B46vcYu7I6vS+UD3tZmizGsY8ZKqFz?=
 =?us-ascii?Q?2LdvXquoV9XXavsw2l4ftrXAxrzBVh+3GRhQCjtP9aOxJeS++uq7cuEhFkYs?=
 =?us-ascii?Q?vDeLEIV+QfdXxCkBRq1t76rY62VU/9qB9F47yavuXWKLRHEOvEF6fJgYWNDC?=
 =?us-ascii?Q?l+CqVUSZ/arqHc7HTd5/ZlrY0aXitewzA/fC2eIjU1brFJj9kihV3dTBglKU?=
 =?us-ascii?Q?1gjih3UFTVi6SwWCfvO1pSL/4tZzDRj5TaazYAegNAFcjlQqlCfSzodusifu?=
 =?us-ascii?Q?QLWu6BsfGeSLnGW9Mbeq0PgTtY3eZEg3EYyvYMIS16Pz920zp/PFIVKuJioa?=
 =?us-ascii?Q?bMwgoPMoGP3e6e/nbXZ5uljIfSU9kaJ2LW9gNngDHAgBp1Xy5C3nY4S/mkny?=
 =?us-ascii?Q?uTrJPfGtL33tOZ5tTQvOR3z63qc0ArkXRtSxpa0vf9bYWYUvGy5XnaqopVa4?=
 =?us-ascii?Q?L7siqsEvnuk9HEj+2IhvXOa9TJZQctsUcE2u46MjKpgeXrj7F9c6ojlFheIZ?=
 =?us-ascii?Q?9gVjKCZfKhXyP/Bxc4NzNNik5h8lBJZle+13DGTmCIANyFZ4/JpNTM3xZoh4?=
 =?us-ascii?Q?3xiMiea0G/d5N4wl36V0rsi+SO7EVizM8yFCiPnF4c4oV7301TiJ0mDphwzO?=
 =?us-ascii?Q?emVwVGtkBcEa1grWaTHu8od6/BrgCChTfTpQ8h4nhewQTQ+71u8Mm9zG+7sH?=
 =?us-ascii?Q?8K696zTALHiw+1ue/5dsKNHFyHtTAvEQ+ueg0pvsJBfYo85HSSzrdml849JF?=
 =?us-ascii?Q?Uv5LcG5BYSvsc7MfxBO030TsLV6wSiWw72huMxACUPoz60wEAS5WBQOfxsnV?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QiykNjTTR9flVzsGKMbtKHsEsCfCL3sQX5Ouk9zq+zA/0LQj+nducwPbcQDsU9lGo7WhWx7hTzBM/2wAgG0zetRbFFYBxOBn5Qu6b4NvBN/XXsSq9kfou5qmVSD7CZcM5/7g2HpF5VkVabUm8i3kfonuWw4CSyCJV1oxNw0TYjBStb7qJkzyWYeplGlZT3oze3FSmExbMs9nw8Um3p9aZdxNTknMeNx0ytPlFN75Q2yeHfllsH30/Lrtd2ZMZW04L9JSrEdCRDG6cMN3GWCqOMjfH9E2j3yDptvUUf4Ab+76Tmyyl6X8zqb9cRUjojsbFIAqWj22qKftZ5gjQa/3HNVBFKSAhGASnks7y3p6U3f+IbCJJZeVcAGHzJS8va6KSdRpUWh6XbTtOTMQxaKINURrkLN25nhrn4sae6oKFBZMJjhtAcSkizhkq6Xq2rsS58IJQBnPLN02k56acFMrDyvde+sZC+8tGB9eI7zDwVhbS/Pefc+sdg93FgFXrM2MxfxibxzISMuk/vMaV0AyT6m8jQtfEwSutBcxBtRLbbeLR1ssmIdjgxdIrDxlw6axBzAKhl8F6JtMBiSxzwzbD2F+D1h5Gp0ZgzrzFQdhJR0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbdcc177-76b7-49f3-1f9a-08ddda2f7c7c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 06:06:04.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TBjo7L+/Vxt0vhkUAVRQQFIJ9UXt/d6kAkSl3phOeWhcq/ZD+W+6TZ1F0XY4tzThx1PJpBLCpg5eBr6ZrpHtOw2/otQKW4zuMAV5bWypzAE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6642
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=814 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130057
X-Proofpoint-ORIG-GUID: 5izKkXSSe3OQd-AcIDJ5Z4c6QSP3sRKS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDA1OCBTYWx0ZWRfX2H6s0ynwLqki
 4iiPW4p2MnOkJL6Ysqz0MSceFsFXOaM+Lp4RBj9NGFHGMwQi+i80bBMbndZkxuYr86wuNBndtA4
 7FGlqOARrFGNQc3ZbDd02n60I8629/19Af1AWhm5oKEE7iU/AK+TaDKiD/ImVQcy3HridKeDikj
 QR9PYzOpAwJi1iHAzTjyUOvhMlxVICa68g4Zo3kVqkK0M3CwT5lPjpG7sTRDTUUzx3OQHU34BZO
 HigD5NFdvXjAmvaAS9VRYI7cbEsK+e8meiyNgG60sINxiaCWWxvCsujvSvZbG0gzK4N0hTTLcyO
 b1n8PWhN+DWc0Oc1s0dNOYYomBWGEdQz6l/cyaT+39hcFr4P5XkRHPPlibSYGTWqArGkScmwJLT
 hdc6yzTlDIMCLDOoNOvstsH4SED6E1IosA8gJgCeHmTLc0MLeuUaLwWiYR9Lq9kWgjOhEr7+
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=689c2b50 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=9MWn6bUuaF_eMk0hTXwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 5izKkXSSe3OQd-AcIDJ5Z4c6QSP3sRKS
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54DEF14000E
X-Stat-Signature: 33jay4jt645dg7iwyd5u1cuon4rap1xh
X-Rspam-User: 
X-HE-Tag: 1755065177-178242
X-HE-Meta: U2FsdGVkX1/LZM1frnH7T2eiW/Vf1UqUM5bqsQuWJBZgH2D/Cswtka4Ct4wEQXCdIEYbkPCUTWlBJ6m/hEB5Ul+3T889DVLivtx2mmAtn8e2VevLVkasl3KNPKFd6e9X5zIJORYgGtp1YGfAIG4fdKgkcfPsBA3wfJcAbPfwXwDWQnNvZQ0cK+/jv4FZatkkEYyndNotpd01Le83x9xedXe7CkP6O3D2XZqnSEIXyrMnck+XkctM6gcoqjY2e7khYCx0kJpVo8J+mS1eRSah8bpjvJZJ1nbTek9dUyFk3Aw0njr6wxr3QXatxgQtxj58dhJW6T46uha1h0MI08tDGqTADKWTMxP7tIQsRDuRX0nX0TipxZkB4zwpW385uemURfqpFs/b46VyGGw+FbqMvD0OewMR40UJOU3bscnhFnnc7ed8L/3F2IPA0PZWxGCimdWomkVivjSz2MACLYs91WPuSkqIr5XJ2Btsa1HSZ883o4KeUA3ZuLcuuUZcM3yQna3JjY0AVu7o8Lp8zN5aWy14jOZRh52UZgTwC+IwRKjpNyg/5fC0Hq6ihettJBgC8XoZ2gQY1L3D137rjBRooBoELtVwkWfIuiWVAzowH2iIU5TNCxBDU6/3X3bE7h5poz5E4nHQc1i9k7e8llyMcx3UYOe3iGZknupQ9PoTkE3Smsfl17GEu9DCK+TTACi5M7tCsIY+DeAHF0QgGTjIGXPySdhozSbkcKucB4UQ17ykLluTmldDI+wNcpH3FbKI1DkpCEl1tNAsn8TiuN57jhhawYaniPcnKAd7FztFnzDw8GFCnMx0TkKLX+CUFLl1UvSexKZAEyLybVGNYHLYWMUl3QXVQeY72Ee/iNoHmGfOVIueUEpWepDv+RAxFRw9KUL58VS50VRJN65iwtED0Qg8ZJDUo3SR0g42UDpeN0/i75MRXf5gvrFUSlX5S+LqPdU6uhq6CvpoMQtBRaQ
 9MQKCAP1
 CC5rO9yEV1CaMttjr+47goqCBMsUx/SQskiSCQplgIRj7v8JhEcO2/s1OWchht5T6TTM5UIGS0KX+PKrOkpGGQsFvNZZJY9xfQXEcE5dcf+YAGSwNVw2WM20gsvUDi09SWKsLJ9uDNvLae6COJ8zYKRdOoHCDvNABxORxx0taUwSPTkPKozZeBZgESWQmjWAzalXQRddtnj4izh8yEOIkyBT0q+t54wY1D7fbf2uOR4B1u+3F3UYl5dx40eQiR1pC+tJxMqzEc7VMKvIIWLrg6JFC233grQnmDukNt45iqX5wAetY9CLsnqTUmT/LbxvfQatdTitwR/a89nJcQvdNW43sihrUDqJCl/rIN8G9ezfppQ95FI3IqrhLx+iQUOBcMmtyEqS6VVqwmbk9Qq9Csiwg3cCRK20+8v5fnkudvsSjbMka4g3gDHO0Kjpi4gYZCgm4BUMz38S+k2joL5MgB8ibj+1RX3dT7Owh0pf24c2NpINU4YG3/hmGaXFIkI3MA8jvXW/1dxHSsiwXzgDWbSoTbCgWZxlKKA0juB28aJMrEteOOpHbz4pBUYZxs/PtUXQ3mmLYtmb0rUsYwcRJ2+luQZLRrMWyGt9qe5oOrTcavMho+oMmxvKgZRMG+QGwC3tDCO5BSVVF0mfG04ksU2xebXNVZSVRfIFd9ud9M0i/6vv/lJ4PAt4P0gmBwOcmYoh/5jAQo9xYEY89IDjmkC6Ls3L19PC5Mu3I5wgyAy+p/yyLKKILmIv86rORr9SUAHGBXXztF+4BvKImtj0OiC3n0tvVIHQF1P2bh4nnRAhc7hr/GIusE09gqDTi58962PlHH83pGYwSV5693UF4RXQYXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Usama - did we plan another respin here? I ask as not in mm-new.

Also heads up, my mm flags series will break this one, so if you're
respinning, please make sure to use the mm flag helpers described in [0].

It's really simple, you just do:

mm_flags_test(MMF_xxx, mm) instead of test_bit(MMF_xxx, &mm->flags)
mm_flags_set(MMF_xxx, mm) instead of set_bit(MMF_xxx, &mm->flags)
mm_flags_clear(MMF_xxx, mm) instead of clear_bit(MMF_xxx, &mm->flags)

So should be very quick to fixup.

Sorry about that, but should be super simple to sort out.

Cheers, Lorenzo

[0]: https://lore.kernel.org/linux-mm/cover.1755012943.git.lorenzo.stoakes@oracle.com/

