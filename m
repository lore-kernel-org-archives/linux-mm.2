Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A965CCF6BF3
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE416B0095; Wed,  7 Jan 2026 02:20:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1276B0096; Wed,  7 Jan 2026 02:20:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B5D6B0098; Wed,  7 Jan 2026 02:20:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B85AB6B0095
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:20:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A5CBC0856
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:20:54 +0000 (UTC)
X-FDA: 84304320828.20.60150C7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id EABC21A000B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:20:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DU0Uw3kJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="fIx/RM50";
	spf=pass (imf19.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767770451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqe5MOrniyrPpur4jyjBxMt7L5rFpfL9tZVcfYXPjVo=;
	b=1i9LzjUg1spufnhS6RZDB4ALLqPI3HFnfxNMBbSkF042pUnAlxSXZSVa4WcHrurbcZ/POj
	yBXzpt9nfNLUQEVydrb+0IKyRKQFBi0Xnz1Y3o2FwPlE7xXDeGEj1T4YmcB9xiN+M3TMSj
	AyFPRaV1Vaa668Z8V1nhqdtu2WG5IgA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DU0Uw3kJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="fIx/RM50";
	spf=pass (imf19.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767770451; a=rsa-sha256;
	cv=pass;
	b=XU8lg+OsLb1NArS4hS4F1A22oZOX2kQkTffwVW4XhsymwZ+calTdEU8Z+hWF02WQiP49rU
	NJZcz6Q23AO0Pen1CYg1y0K4WvEljkTgPNqcYokXsBfgKNIdnHKg5w4ls1nP6PbpxHKqLX
	ZKWhdZ5o/6cSs89bFYJLe5MMAJqY3wE=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6075ab3F1026291;
	Wed, 7 Jan 2026 07:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eqe5MOrniyrPpur4jyjBxMt7L5rFpfL9tZVcfYXPjVo=; b=
	DU0Uw3kJGZShjWDZCaVaGwEf8F/jSvYeayBUFkSm7tYOYrQkZ6ZVye7UVzck6Lzx
	LC5+sVUe7cthITLCsLgeLsYqNxMjrxtHmS3m17FPC/lw+MYz3KBPEU71ytg5b9cu
	P2iJk6coKjvWitIY1uSiRKTybnraKnnk2P0M6VYLSHrIEAeioYXdI0/6hTdL/m6X
	KKx/NBkUgERIIHRX8eU0Qmy24SAD9mIdZ2/8GlvXP0KtXj8drFQc6KcJNTJWGLmy
	z81OTjwTE74WkFMdnFNrLvR0C1Hus3sa72RfBCckck80tf+5iQZ9ocVgKG1irdMj
	8jVVgx244yDsngpZObRGAA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhhg7r2nj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 607517PA027437;
	Wed, 7 Jan 2026 07:20:20 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj999kc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jK3arttxhtZ+q9YAZtYK964UFb3ACSaabmbufD9Dpvoi3kOyCzrKZeJm3sTwIm02Ry1rMa90So2EnA+hJA7JM7o01QxdTG7hCE4zirKxheOYg/l5aqTkvoMOPhZ7+qJ9Sl3zqTAWEs5MiU8RQdn5NiAcAVJv09/fsQjtaLq7YOq+oFtJsvXJgwWzJZEKPEMGmlt9bygTKnp9ocY794o3vkKVkbqOvYyzO6VkxXmek5dcklS5cCT3rO3JM3O9C/YIRsES+aIZLcy6Jyyzfhdm4OJnTmiNFtxW0sy2ibd7KN3I2Ib3bkmtL7K45tvxeUEdZCUhCZTs109BbVXdb7geqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqe5MOrniyrPpur4jyjBxMt7L5rFpfL9tZVcfYXPjVo=;
 b=UrWfTWNjLruo7YV0+E2G/55DMNEtBNg+SFeiksDdUgydac7PMEXmG7OkUU4ANLJbZDKwK0QAWsY4RF7LXQLuLkeh3qM/1OMrXomC4XeDGKL3c6YYgOI1fiJAkuRmPv6++Xy7vPzFR1W2MIF35NhDynqdRfPwPoiXOaq9gCZivmKeOhklSdQDGqY8SeGG92p9jUKBa/I3FM5yyoxdbxDOhrGZliiVT4VsvHI0pvMAHfR/P4NKkToKMEudeckpy31Bc5G7cjFvkjdjvRFup39A37bjEH6702YXervY7Ky19aqIChQpXUQC39PkKHtAOU7bAgtAG2POAfa1V4vTgJmhRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqe5MOrniyrPpur4jyjBxMt7L5rFpfL9tZVcfYXPjVo=;
 b=fIx/RM50kNeFvWrDlku88ZRlPBUmblKEJusucPQO/TgkO1frVfxZeZMtLTlgU/rS+Nl4MQZwCNTBc2JM9lnRfK4HgAJccYbdHrK95Ab/jah1UNoGPeAl/S7sROQ46ZaF5XtQX1n8lAewkv4quOsR0Z+W6uBBEJTJzweEqqBq6nY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by LV8PR10MB7750.namprd10.prod.outlook.com (2603:10b6:408:1ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 07:20:13 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 07:20:13 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com, David Hildenbrand <david@redhat.com>
Subject: [PATCH v11 1/8] treewide: provide a generic clear_user_page() variant
Date: Tue,  6 Jan 2026 23:20:02 -0800
Message-Id: <20260107072009.1615991-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0157.namprd03.prod.outlook.com
 (2603:10b6:303:8d::12) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|LV8PR10MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: d7a2a4bd-d34e-4562-2d99-08de4dbd32e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+9fcItcyI944Qy+7PBeYO37kwoXWUiiHc6hmfmMkQ2jgrkG0IytLcZb5RMli?=
 =?us-ascii?Q?Ns6M8Hm5eUsYofSzMVaEA5NTOgAdxs3D7Igz8p0/98y1wMOpKfYME8Os1O1v?=
 =?us-ascii?Q?8Y47h4UvIq6WrPvSp5DwE4wMfQsUoRE8CoGsP8z+Y3+RPjtaWge+Sl0bszlz?=
 =?us-ascii?Q?u+GElYlQv/z3lMOTnOHW6khjpsxqNaIHx56P/yv51OnxoVWLnWjYXsCeR0uC?=
 =?us-ascii?Q?y2ze/vr0D4uA8IMjoV7OL9x7+rb93YVBcfmp7VGqVD8IvKN+45zVSOewVi8q?=
 =?us-ascii?Q?KPzpgYTJ9yIlS8nC+SIoxj+e0x15bm9Q6cqt5/bt0p38fhmDfNnVAsh/V7fq?=
 =?us-ascii?Q?m5WW4nIVYZkOKCu+dovmbv/XtxhbccW9AL+2YJYTgkSN93l4WuH5US8aBjBz?=
 =?us-ascii?Q?XSdnoakjtx4HK4cYd5BV/RUQ2v+tQ2dPSP0zD4WNOXcQjBEGs1lVVDLCVZkJ?=
 =?us-ascii?Q?MI7YTEcTkgKQMj1OqpKcXxluQ7f30MSIrboK3omRuEY9kRn598+Owsv36wad?=
 =?us-ascii?Q?Vj0n2x9VilPHysvzmT4HF6WgDW96Rl+cdkiAFPZL2zc/zlfoGxr0IB7ZYgqj?=
 =?us-ascii?Q?BIoPR4A9XRyz/oiYSBL+YiGr3g6GHHtA8Dncja0QaIJLL3VQQxEPe+cNl45F?=
 =?us-ascii?Q?s5vRl/UWAV13vO02oyRLy8Feps5LYfm/ErpIJY2upGiRxnVFG9EJ8ghKExS5?=
 =?us-ascii?Q?hYSRtl/VS/LoCBkEAHp7rfHrg9V0xL7ouypCsCkXz8C65WZBF7Az4gRPMKEi?=
 =?us-ascii?Q?0oQzA3x6cTdbkQv/1nk7nfNxKDOfTLFzHA9rGq6cvRHB2Y7PyTRSz9X593Jv?=
 =?us-ascii?Q?u6xAUR8HbL9e3R7QdEFcI3ooOtICE4pri0l/bxovrwHBtPLWv00Ged9vQRrp?=
 =?us-ascii?Q?/0sLJTUFHU5pZwRPpUIrBZ7FqXOHzMfH6JWdIeC/5PSF6QrMmSlfpU4etWFs?=
 =?us-ascii?Q?wx6UUGHqerxB2Nbv/iqFYjttgdjuKTk9ryQi0ME7M5oxLsDHs22iGUS6+SFQ?=
 =?us-ascii?Q?qGkuynC83BuzSQqmwR5XBvCS1W8A48GV4vECW4hHdp52dmmyVSNKKW5DBUAb?=
 =?us-ascii?Q?aOJGays5294j15sDN6DZpvT6Tk6XPTxKw//zPMmetF3poKW7qISy1p1671uu?=
 =?us-ascii?Q?Br1DblOCKhhZDo9x1OfZL/MCFLnbzU1n9qi+DiiO0S3BxQKZbH/UPpXSToS5?=
 =?us-ascii?Q?IIioT0YRBJrQHOSUyGqS7vXGb30obWl54zymXoGDkQCwvxrQOYvlCkbk2qS4?=
 =?us-ascii?Q?fZITeI7TO+J08zF56d+qDMkBqSLTFzdJAtspNOBvh/Th8OjH/ipKLBLAdJOt?=
 =?us-ascii?Q?QHQmZeLDAyJZipb1qbhpLAnLCx1KlvC6TokdP1/5f/PnkOgMcsxTLdXFoHmd?=
 =?us-ascii?Q?7YyVpJm6Vf480mt1nBD4+Y6kckXd3jPcQ2wiXsGNYfx5pJgLNjNSwPrH5Rt/?=
 =?us-ascii?Q?6Yu2HioR5tW0NwY/ZP5mwJMNKCLt/YUb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cVgNofyfGTVE8Uz33FHwLjOIB7Hetwn6UETp1M/lcrQ9TpmM9srBUB/xlG4R?=
 =?us-ascii?Q?62zgGNSrjPSDVRQ+oxPl+mk7ruSZr0q/Xt1ovTm6LXib0yKOhoXjNWcTYnpo?=
 =?us-ascii?Q?TMXFpO2pAxSab6IjBjxGl2SoDx9JZeLrgJp2bKrQq2zuVNVwEnWjM0H1dV2W?=
 =?us-ascii?Q?+g364UOvcQ4Pj6wc73n/fnwu1PksUr8i+mmSQEOXNt5H3phPwVCapH9eMX8W?=
 =?us-ascii?Q?273N6sSVCkWaYDxaqTvLj2TQ7m3eoS4YLn678dxfwoyyHc8KzXZpQVzMeymI?=
 =?us-ascii?Q?rqYgnnvQ76tvX25EH66Na2oiKB2Ql5ot2I1FICr4ZTk3pSmhd7/V0QwIqKAo?=
 =?us-ascii?Q?5YhWC83uUDWmGNB+tBdN4xeTb/2TLELXYhR3OWj6vunv+T5Cet/HuHvJ0uEG?=
 =?us-ascii?Q?EIO3SX81kA9ctcTzyFzoYOuwDG9o3UdJGuJoexrB3QZbOe3ZTmVBMIVQ2znY?=
 =?us-ascii?Q?IkMKdQ0qHuPUqpFTB6Bz9jCy2DPAeyBm1rBE/aoo81Mo/6HiKoZFoaFVVHsY?=
 =?us-ascii?Q?NADFUVg4XykdpMxNCnucjXG9YQNj3cNKIY5THbWSGynqCP515aEgB+1U5l+1?=
 =?us-ascii?Q?i0cnjQbO/FMCa6URuvoR1SGn7iic7RKZL0VuagJK0XQGZgQdv1bK5Kf/123E?=
 =?us-ascii?Q?x8r06v+A0X+hRVJwfNLi25hWy02JN7A7qGFZfUGWgKJmjLqXBZmmFY3lqADk?=
 =?us-ascii?Q?yUZW66BncEZd3fL1nwFVlEMBjUZTymGXrbLh2QGYNXQAMZ+kVzzxK7j/nip8?=
 =?us-ascii?Q?RVifNfcZbVO+KakWDrQmfC5IaCVo83JxfBadafQvKhDgW/ss3e3RKA1o+fB/?=
 =?us-ascii?Q?G0HfbnMec0y0gt6LZAYPd92ma2HXJcfyKe/SoT/1BIrG+fg2EQ52AopIA8z+?=
 =?us-ascii?Q?2Tr3SnrXZDEHu8bubr8wky7b5I4vNrx3w3i4t57t+DroP6xqyvYtPzYfj4GO?=
 =?us-ascii?Q?fEqc+Ul+Oy46YRstmU8vxokk1raGjJ+u8Fm5gd+uTzgzOBcHQrFCh3dcmcmi?=
 =?us-ascii?Q?y9ePTF06nv7jabZuM7nIeWyLPCrzl0II9qZX3v1V47bo1Oz4dgzZFVUt3wed?=
 =?us-ascii?Q?/8jDYUAt0LJavGEh8NSuZ2HzYyVSu26UJhBawVwo8FDYwMsaXOHdXqtkCxXU?=
 =?us-ascii?Q?9opLoU6vSBtVYLcuOYkncdcHgTqd09LgU+ZwgmSDzLln9P9qsPT2flfH7yGy?=
 =?us-ascii?Q?AaVV7vQI6pXZGG+QumQhYZAKKbTDMYT57M9PC868oI2EmJQuleAzRvLafJIi?=
 =?us-ascii?Q?hzpV9VYw7s2F0YLgT1d0H6lHX/KANOnEdNxFSAB87yqWEPsouCuhhpfTbym3?=
 =?us-ascii?Q?iZaNJR6rW/KOtB44n2njksMv+gJAtpRWFQPT/+yIgMyvluHgLnbvAiXg7zNf?=
 =?us-ascii?Q?dN69nV/2WiklXAyf1UX5filmVvz2kk7+kbti/mZj32gaktmlcz3sJfbmg84k?=
 =?us-ascii?Q?4NC9ntuRiKqyarIVrqYFeNpUaiBM946QfiJBneU3SXagZw1FWM3jdLaZlXsM?=
 =?us-ascii?Q?N37vNHp14viM4Uv/GNeetYPciJcdou1uk1ru8J5K65ybh7e5MxbgHkhPbrtR?=
 =?us-ascii?Q?EzJHsO+i3fc0PfsOfo7pbViJuX5xt6/GC4U7A5EyQsTGYi7Vz9294Awe17Ck?=
 =?us-ascii?Q?4fHsr9cvrzUl3l/O90MEO41ZQPSChy37CS4Piy/R3dQZmIqOZIw+37fkPWRw?=
 =?us-ascii?Q?hYfiHu/0vVEQzNAWk/xDgu0CK01W9KOleTeJDhpLUcT4ccXc9Xsx3a+oANsl?=
 =?us-ascii?Q?TFdjju4sdnjF4FhafoiVLibX91S8iMU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rTJE2hO4sUmVI/C8wzULDPYONoW1BCNNFPvfMDM9Wkk6vfDvaE+qxrYyO+5pG5m1yBpeupNe3XfoRc6kcBB+6w38/9C5gHgphclWNkoVStH2FpVQcIGZaHOg30dSRCEKeBoYveOZRrjDctKb4E05s+7g+jwmqJ+J2CYMOrhgV4I7j7j8sMjfzb2qHu0g+GGlxiHO6m+k6uDTFDw97P+oPFeG3VqcQ2mvSWp9fHwz0dLNPYtCGApWPHHay0AdaBTTplDL9jrj/U/+pZZ4nj1fGFOVC6yTlewCn0dIieI4y6g0LOCFBE6UFwdDkdiSuVvIrBye1Qbwoy4Zk4VE3FowCa4IO/mH702VYHuj8kOxWERWN6wPKM4XNc8SMPB8m9+BcZyw8jsLssU1R1D2KQWQmhbmVnwvBKYbsVcjL6fJ1m9ZOBK6qyVrENn9G1qgdpXE8Ld8xtuu8TZ5igwA+GueXRd3+HjxVbFGB3V4Z/bY0fkkXeyWKAFiTQtMS3pPThucH858RX8X5K6JnqcDYGs/7nSQcW3+BOewFVXNdDIVu/ORxxNn7zZoHmHD9pFRWao6NKNYmFdaBWJ2/Uwi76oZsBZNtJBSHpf7mKbbAKIOaSc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a2a4bd-d34e-4562-2d99-08de4dbd32e8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 07:20:13.2788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OOLwB230KczpHz/olHiB4UFDZIbe/PYapNMJr09Npr0iO1PpcT7HXwqkmQbdHPV4zL2GmMQBDoIw75v8H9OmrctOUJaf/TRPYsySgTfL694=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070058
X-Proofpoint-GUID: wxFtSgSWLtgnY5i2m5JPAkt3xggezUCE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA1OCBTYWx0ZWRfX1xlvm+CTL0f3
 AAwL3HpnDZi2jVyvF3QEO6iH6kAwvYwhZMUQoyDCfiEYoS98UpSNkwiGlTXF8xJ8yR+s3tOZRkS
 fGjf2u3wDbvAiEcBflHBDq8AsKlRhnUye6/TmQlLlcDoxWbj7sD3ujbu0fW0b710/zxTciydiBW
 RVGoNnBwh9hRa351zUQfUHx9khx7kl3kHR+TytwblSXmrei+DdgiAAO8eHBqvdPWA7dnc51iiT1
 4CbMk0u1Ss4229s+Obk/N0PEBKmfGcNYUgKlWTJiyR3bob/ivzqPyN8I/qz8XaXk3Yvls+NdvJQ
 nUAezigbANrtF66fqqI3liAtnlGWsgeihyjee+YZUdqGUT9e7mREQRCFbWVqSGvNSU/n7BIea+c
 fIITH0lcydvHOQTGQrBKhDxiM8Ihk2OuK3JINpVK1TzjXuL5ue9gwxAU9LEnn+kP4nWQ0MzwK+7
 wXLEc3p8y6wj5p7H+9g==
X-Proofpoint-ORIG-GUID: wxFtSgSWLtgnY5i2m5JPAkt3xggezUCE
X-Authority-Analysis: v=2.4 cv=HOzO14tv c=1 sm=1 tr=0 ts=695e0934 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=XISvpzbayW8Gg-unTeYA:9
X-Rspamd-Server: rspam02
X-Stat-Signature: ktw86anrm53erryky8j8jeyroyw7euob
X-Rspam-User: 
X-Rspamd-Queue-Id: EABC21A000B
X-HE-Tag: 1767770450-997174
X-HE-Meta: U2FsdGVkX1/e/duTpjdUMDMnqzf09VqAUonMQJvuDS+bC+sg0O2erg4zSMbQCycN+iR7VhpDemOFflm/qcaaHxUvqfpk3GH95c1uo+D3s+oWncK6wMIk40c04fnrnp2/K/gv9ETG+3uydAN+K+A1xWPM2s+6E5NX9AModpGKpKW5SjdvXxQuk3cC6QqDmhW1Qjr/uVcxEDN9Np7TQqvQKNxFhnQNoF+y0KdOawQ70nNWUk/GBWFhPu9djmgQFT9pbV/0JmPqzZpAkLSeY17r3f31Ni4zSfl193O50krT6TSwgWPbM3cMg0zmut8V+4Czl0W+aUbEAkRLctdp82+QEmA7CzQBmvU0glRdY2NWQGyG6E16ZWYHfOdi8qN5Vmlzp59jLCHOD+XuZlfHZEyXpH9Df+NIFLJoRlmiSyxxZhfbBuf5zLLbfR6KCH0XS5IF4lOPvrKK4R0S1FbKn4TJ5enJ7VDwyVqUCdesPZTiifCzhlvGJNVqt11WxM3ETsXo0eCv835y2LHzSTts3Fll1Lvgi/ugjXVtOJ5b8lGiEVkBRLtI9f3TVxGN9R7V3vnMCz+3RHRG2A7WWUQnK+/IImgOHbYPO6FEjx1f6fYFy9KCERyn7qNhG4qTJ2q9oSptB2kMlye02gObW7gIAKX++d8Mv8r8HBsacZnv87kZSgi/LrSVbtS3uTFJcA5KvjX33ReRL+6Yk7LMBC/M0CRHT3uwxgtJFz/+PAjK5HAvmgTf0u58/c+Iizu+McIH4lyf9dCYcJxf72vI8hyMdo04YE2csj8qnx+Kd5RVGtlz5FXrbsTDRTh/1D0eFUE9gvswoAFilBSr9H4tqoBQjWR0TFEPr47dry/HrbCzerJvOgJr12uadQ7gat6Wi3M3tDlDcDyYEj6D665AcFAf54exRaN/8rAGaTgG2ilQP0PqtPWMtHDOTfYMXdErQAynfFPjGEdh3jrtxCFvGJZTwc7
 m35Nfpo0
 5DUU7ENvWjKXQHobDYGlvpONMS6kyLsWpVANK3QMw9+j+EJPTm2beX/QEgnzdLO9mNm6bKjUe0j4wTSK4Jv9kfxuqh7LLswBjssotgBbqd+5wY6wt8txf6NMS5Z4hMBQb4MPa6y6SJgeHmmbkZTV+o3XI6OI3MbxNnYQ2IDu3fTcrYf3vkANDGUMpeb47XYnkkGWqOHVQqPbEcb9FKfvJyIFdLUf4oQHZ8wa/35b517EeNPzw3jNNyS55WhuRQgArfmjYbAoY1J2U4dW7nAFaVg6TqjPUmoyQV+0NOrFEOG+rFcuvUupsdygiX2AnNYOWGdBQ0BErEqK8KSBENJFrGAN4754UviwSUWhu0wLA6sO9ixA2M6fJhyOfsrLEpxs+N8sWOSoxJIdNdYCowcE+rxjmosKs0CRs9BYpj8Sl6rnI8cCOdXmb7YUntGE15JEvHDJpIFMiBgDUM0Vdtty/uoI8jsjWLCxD8GDCG6jBtRzT1D5HhMG55Naz92SSKHCP8GaaeBW8iaUNsghT3sqeWVsjCqGyJPKJKDOKXD7KHmOviUcvmekOSJFld/dV0OR4AdV5ceLTBqT2tfvNinjR4xADpjVnK3arAkav6LBEg/3EJP4hXD4uRNEYmrcJ1JZp8+BEJvgIxN7E16j0eQRc4yQCtIJUaSBmq4B1EnZzfDHTgUo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

Let's drop all variants that effectively map to clear_page() and
provide it in a generic variant instead.

We'll use the macro clear_user_page to indicate whether an architecture
provides it's own variant.

Also, clear_user_page() is only called from the generic variant of
clear_user_highpage(), so define it only if the architecture does
not provide a clear_user_highpage(). And, for simplicity define it
in linux/highmem.h.

Note that for parisc, clear_page() and clear_user_page() map to
clear_page_asm(), so we can just get rid of the custom clear_user_page()
implementation. There is a clear_user_page_asm() function on parisc,
that seems to be unused. Not sure what's up with that.

Signed-off-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Ankur Arora <ankur.a.arora@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/alpha/include/asm/page.h      |  1 -
 arch/arc/include/asm/page.h        |  2 ++
 arch/arm/include/asm/page-nommu.h  |  1 -
 arch/arm64/include/asm/page.h      |  1 -
 arch/csky/abiv1/inc/abi/page.h     |  1 +
 arch/csky/abiv2/inc/abi/page.h     |  7 -------
 arch/hexagon/include/asm/page.h    |  1 -
 arch/loongarch/include/asm/page.h  |  1 -
 arch/m68k/include/asm/page_no.h    |  1 -
 arch/microblaze/include/asm/page.h |  1 -
 arch/mips/include/asm/page.h       |  1 +
 arch/nios2/include/asm/page.h      |  1 +
 arch/openrisc/include/asm/page.h   |  1 -
 arch/parisc/include/asm/page.h     |  1 -
 arch/powerpc/include/asm/page.h    |  1 +
 arch/riscv/include/asm/page.h      |  1 -
 arch/s390/include/asm/page.h       |  1 -
 arch/sparc/include/asm/page_64.h   |  1 +
 arch/um/include/asm/page.h         |  1 -
 arch/x86/include/asm/page.h        |  6 ------
 arch/xtensa/include/asm/page.h     |  1 -
 include/linux/highmem.h            | 24 ++++++++++++++++++++++--
 22 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.h
index d2c6667d73e9..59d01f9b77f6 100644
--- a/arch/alpha/include/asm/page.h
+++ b/arch/alpha/include/asm/page.h
@@ -11,7 +11,6 @@
 #define STRICT_MM_TYPECHECKS
 
 extern void clear_page(void *page);
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
 	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
diff --git a/arch/arc/include/asm/page.h b/arch/arc/include/asm/page.h
index 9720fe6b2c24..38214e126c6d 100644
--- a/arch/arc/include/asm/page.h
+++ b/arch/arc/include/asm/page.h
@@ -32,6 +32,8 @@ struct page;
 
 void copy_user_highpage(struct page *to, struct page *from,
 			unsigned long u_vaddr, struct vm_area_struct *vma);
+
+#define clear_user_page clear_user_page
 void clear_user_page(void *to, unsigned long u_vaddr, struct page *page);
 
 typedef struct {
diff --git a/arch/arm/include/asm/page-nommu.h b/arch/arm/include/asm/page-nommu.h
index 7c2c72323d17..e74415c959be 100644
--- a/arch/arm/include/asm/page-nommu.h
+++ b/arch/arm/include/asm/page-nommu.h
@@ -11,7 +11,6 @@
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 /*
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 00f117ff4f7a..b39cc1127e1f 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -36,7 +36,6 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 bool tag_clear_highpages(struct page *to, int numpages);
 #define __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 typedef struct page *pgtable_t;
diff --git a/arch/csky/abiv1/inc/abi/page.h b/arch/csky/abiv1/inc/abi/page.h
index 2d2159933b76..58307254e7e5 100644
--- a/arch/csky/abiv1/inc/abi/page.h
+++ b/arch/csky/abiv1/inc/abi/page.h
@@ -10,6 +10,7 @@ static inline unsigned long pages_do_alias(unsigned long addr1,
 	return (addr1 ^ addr2) & (SHMLBA-1);
 }
 
+#define clear_user_page clear_user_page
 static inline void clear_user_page(void *addr, unsigned long vaddr,
 				   struct page *page)
 {
diff --git a/arch/csky/abiv2/inc/abi/page.h b/arch/csky/abiv2/inc/abi/page.h
index cf005f13cd15..a5a255013308 100644
--- a/arch/csky/abiv2/inc/abi/page.h
+++ b/arch/csky/abiv2/inc/abi/page.h
@@ -1,11 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-
-static inline void clear_user_page(void *addr, unsigned long vaddr,
-				   struct page *page)
-{
-	clear_page(addr);
-}
-
 static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 				  struct page *page)
 {
diff --git a/arch/hexagon/include/asm/page.h b/arch/hexagon/include/asm/page.h
index 137ba7c5de48..f0aed3ed812b 100644
--- a/arch/hexagon/include/asm/page.h
+++ b/arch/hexagon/include/asm/page.h
@@ -113,7 +113,6 @@ static inline void clear_page(void *page)
 /*
  * Under assumption that kernel always "sees" user map...
  */
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 static inline unsigned long virt_to_pfn(const void *kaddr)
diff --git a/arch/loongarch/include/asm/page.h b/arch/loongarch/include/asm/page.h
index 256d1ff7a1e3..327bf0bc92bf 100644
--- a/arch/loongarch/include/asm/page.h
+++ b/arch/loongarch/include/asm/page.h
@@ -30,7 +30,6 @@
 extern void clear_page(void *page);
 extern void copy_page(void *to, void *from);
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 extern unsigned long shm_align_mask;
diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index 39db2026a4b4..d2532bc407ef 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -10,7 +10,6 @@ extern unsigned long memory_end;
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
diff --git a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
index 90ac9f34b4b4..e1e396367ba7 100644
--- a/arch/microblaze/include/asm/page.h
+++ b/arch/microblaze/include/asm/page.h
@@ -45,7 +45,6 @@ typedef unsigned long pte_basic_t;
 # define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
 # define clear_page(pgaddr)			memset((pgaddr), 0, PAGE_SIZE)
 
-# define clear_user_page(pgaddr, vaddr, page)	memset((pgaddr), 0, PAGE_SIZE)
 # define copy_user_page(vto, vfrom, vaddr, topg) \
 			memcpy((vto), (vfrom), PAGE_SIZE)
 
diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index bc3e3484c1bf..5ec428fcc887 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -90,6 +90,7 @@ static inline void clear_user_page(void *addr, unsigned long vaddr,
 	if (pages_do_alias((unsigned long) addr, vaddr & PAGE_MASK))
 		flush_data_cache_page((unsigned long)addr);
 }
+#define clear_user_page clear_user_page
 
 struct vm_area_struct;
 extern void copy_user_highpage(struct page *to, struct page *from,
diff --git a/arch/nios2/include/asm/page.h b/arch/nios2/include/asm/page.h
index 00a51623d38a..722956ac0bf8 100644
--- a/arch/nios2/include/asm/page.h
+++ b/arch/nios2/include/asm/page.h
@@ -45,6 +45,7 @@
 
 struct page;
 
+#define clear_user_page clear_user_page
 extern void clear_user_page(void *addr, unsigned long vaddr, struct page *page);
 extern void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
 				struct page *to);
diff --git a/arch/openrisc/include/asm/page.h b/arch/openrisc/include/asm/page.h
index 85797f94d1d7..d2cdbf3579bb 100644
--- a/arch/openrisc/include/asm/page.h
+++ b/arch/openrisc/include/asm/page.h
@@ -30,7 +30,6 @@
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to, from)	memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)        clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)     copy_page(to, from)
 
 /*
diff --git a/arch/parisc/include/asm/page.h b/arch/parisc/include/asm/page.h
index 8f4e51071ea1..3630b36d07da 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -21,7 +21,6 @@ struct vm_area_struct;
 
 void clear_page_asm(void *page);
 void copy_page_asm(void *to, void *from);
-#define clear_user_page(vto, vaddr, page) clear_page_asm(vto)
 void copy_user_highpage(struct page *to, struct page *from, unsigned long vaddr,
 		struct vm_area_struct *vma);
 #define __HAVE_ARCH_COPY_USER_HIGHPAGE
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index b28fbb1d57eb..f2bb1f98eebe 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -271,6 +271,7 @@ static inline const void *pfn_to_kaddr(unsigned long pfn)
 
 struct page;
 extern void clear_user_page(void *page, unsigned long vaddr, struct page *pg);
+#define clear_user_page clear_user_page
 extern void copy_user_page(void *to, void *from, unsigned long vaddr,
 		struct page *p);
 extern int devmem_is_allowed(unsigned long pfn);
diff --git a/arch/riscv/include/asm/page.h b/arch/riscv/include/asm/page.h
index ffe213ad65a4..061b60b954ec 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -50,7 +50,6 @@ void clear_page(void *page);
 #endif
 #define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(pgaddr, vaddr, page)	clear_page(pgaddr)
 #define copy_user_page(vto, vfrom, vaddr, topg) \
 			memcpy((vto), (vfrom), PAGE_SIZE)
 
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index c1d63b613bf9..9c8c5283258e 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -65,7 +65,6 @@ static inline void copy_page(void *to, void *from)
 		: : "memory", "cc");
 }
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
diff --git a/arch/sparc/include/asm/page_64.h b/arch/sparc/include/asm/page_64.h
index d764d8a8586b..fd4dc85fb38b 100644
--- a/arch/sparc/include/asm/page_64.h
+++ b/arch/sparc/include/asm/page_64.h
@@ -43,6 +43,7 @@ void _clear_page(void *page);
 #define clear_page(X)	_clear_page((void *)(X))
 struct page;
 void clear_user_page(void *addr, unsigned long vaddr, struct page *page);
+#define clear_user_page clear_user_page
 #define copy_page(X,Y)	memcpy((void *)(X), (void *)(Y), PAGE_SIZE)
 void copy_user_page(void *to, void *from, unsigned long vaddr, struct page *topage);
 #define __HAVE_ARCH_COPY_USER_HIGHPAGE
diff --git a/arch/um/include/asm/page.h b/arch/um/include/asm/page.h
index 2d363460d896..e348ff489b89 100644
--- a/arch/um/include/asm/page.h
+++ b/arch/um/include/asm/page.h
@@ -26,7 +26,6 @@ struct page;
 #define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((void *)(to), (void *)(from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 typedef struct { unsigned long pte; } pte_t;
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 9265f2fca99a..416dc88e35c1 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -22,12 +22,6 @@ struct page;
 extern struct range pfn_mapped[];
 extern int nr_pfn_mapped;
 
-static inline void clear_user_page(void *page, unsigned long vaddr,
-				   struct page *pg)
-{
-	clear_page(page);
-}
-
 static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 				  struct page *topage)
 {
diff --git a/arch/xtensa/include/asm/page.h b/arch/xtensa/include/asm/page.h
index 20655174b111..059493256765 100644
--- a/arch/xtensa/include/asm/page.h
+++ b/arch/xtensa/include/asm/page.h
@@ -126,7 +126,6 @@ void clear_user_highpage(struct page *page, unsigned long vaddr);
 void copy_user_highpage(struct page *to, struct page *from,
 			unsigned long vaddr, struct vm_area_struct *vma);
 #else
-# define clear_user_page(page, vaddr, pg)	clear_page(page)
 # define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 #endif
 
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index abc20f9810fd..393bd51e5a1f 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -197,15 +197,35 @@ static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
 }
 #endif
 
-/* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 #ifndef clear_user_highpage
+#ifndef clear_user_page
+/**
+ * clear_user_page() - clear a page to be mapped to user space
+ * @addr: the address of the page
+ * @vaddr: the address of the user mapping
+ * @page: the page
+ *
+ * We condition the definition of clear_user_page() on the architecture
+ * not having a custom clear_user_highpage(). That's because if there
+ * is some special flushing needed for clear_user_highpage() then it
+ * is likely that clear_user_page() also needs some magic. And, since
+ * our only caller is the generic clear_user_highpage(), not defining
+ * is not much of a loss.
+ */
+static inline void clear_user_page(void *addr, unsigned long vaddr, struct page *page)
+{
+	clear_page(addr);
+}
+#endif
+
+/* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
 	void *addr = kmap_local_page(page);
 	clear_user_page(addr, vaddr, page);
 	kunmap_local(addr);
 }
-#endif
+#endif /* clear_user_highpage */
 
 #ifndef vma_alloc_zeroed_movable_folio
 /**
-- 
2.31.1


