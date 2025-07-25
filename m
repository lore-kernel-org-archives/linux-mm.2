Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16468C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 22:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B716B007B; Fri, 25 Jul 2025 18:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC966B0089; Fri, 25 Jul 2025 18:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76EBB6B008A; Fri, 25 Jul 2025 18:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 628F56B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:49:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB2E213428E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:49:46 +0000 (UTC)
X-FDA: 83704280772.14.35AE640
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1D829140002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:49:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=S81sPDX+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KcoCdefG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753483783; a=rsa-sha256;
	cv=pass;
	b=uNPuX1wa2ixy7WyOFjkttrIzKpvincyMZZabdydFN/d75Qy6xD8X3sIL9Uq0JbHMUi14yx
	GKgfhE1chOqRnDZ2FC9vUQVGxewK48gEcAPjRxbZj7NT9qCubkWpGG8YG/wM8veupzaztY
	PfL/f32X8ahx3n+yaZq7uRgehqXDSc4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=S81sPDX+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KcoCdefG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753483783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6m8JJrhxH1WZ8SkKBpWcO71wGFpnpbxjZFOBsg9fdaY=;
	b=y9PEBAmtBUyPh0BL+VScAIjL1kK10C4m2d2CffequCfo6JBFSDYZSswkAk6lsrWOd0GU9S
	0aJeGVfYVSpfEBJop4ug2dp3WJinkLvEpwcxjz9sy8MAqxoTq6nmI1dpQnIUMecWvI7aoW
	D9y9tGSQ27beBrj2f+22DQPVBYALF08=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PKg4hC002656;
	Fri, 25 Jul 2025 22:49:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6m8JJrhxH1WZ8SkKBp
	WcO71wGFpnpbxjZFOBsg9fdaY=; b=S81sPDX+CjkVYrVR6SDrN6xkFJ7917hX6E
	DNK744OQXCH8LsMkML/eUWerTvPRbcYWP5VlAYK9o70HPbbXTHvLXJ9eo1AvcncD
	60URtbditS6IS0aMilTxwf5bm++4i802ivnteRh9wOTjN8GF09pXyGeNz6Fn82tt
	cwab6h048c0gdRkOqXCnPsBycf683OunGpVSV40kDZF1dxCqkVmN+5q7EVhg3W7M
	8Jcs5rMcBcROfgIU2wAc/3wzjJ9CdWdL+fY9epn5fslc7VHTWUQTacHapFXouH+l
	LTyBZQRf2nH3FUWbvDNrEsf8J5j3ff4yz5VQgoJDO5vDzb0fXaSQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1h218a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 22:49:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PM0KlT031445;
	Fri, 25 Jul 2025 22:49:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tkyedu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 22:49:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pYUFBYzWv/hfJwpR0APhzYCV43b5AF+4TeDNFdVJWZhOdN02s0ajEtYBAIIg4qPsu+MDeFd9si3sDPGih/fK+2gH9v6HdMW/qcTopbM2dY4JumVwFtHifrctu9N67NmVOC9rF7W73Yc1uwR6mkssFuY6kJYMY6C2Ld2ECIhmXyUbigTIFX64YiuLuslqq2pqwcyjUlQh/umajteE7EC3slWeRN2udutc14vnYWq0qgGy4J7zeWzZBaja56Ze+94qW0ZP7PumegHZHDjxhHoEFpTQDZZUMmheHkyjI8xFo5VbF5177Ensv0nCqppK4Ln3Gsq83abPx4cmbomRH8Mz6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6m8JJrhxH1WZ8SkKBpWcO71wGFpnpbxjZFOBsg9fdaY=;
 b=KW2xtqFtfD1Nq2CnC+9roeQQHyC1zecTBn6KyKluCOB1k3Y4Di6XKIhalKxiC6pLi6BW0UdY+wXZhMgS29VGOEXRY0efN4pkWB5mDX7lIFrSjunsCQ20HKMnFcca1vesYdum52qIFwptXgBeuQ+jM5X2JrcqvkLtZGjR7aPiRQBfWzeUkL4yOgoxDJJ9umFsziYG4g83qEpOtsXsQB2nuh+fOzqm8nR3/5BZREM31sb3mepEoFNi9RlwfMuqRu134UjjH+5zgrLThS2ykGOF2VzXhSeJVHL49QZlSdFtKFaW03rkgAAlcrdQCDyTT6g8TCfRKdAEZ9sesqYWcLAJPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6m8JJrhxH1WZ8SkKBpWcO71wGFpnpbxjZFOBsg9fdaY=;
 b=KcoCdefG8NVCmIncWRtN5THTa1NBg0SgBqLsdKXt9dhwRVD9kaE0qvOY43LvgxhTUAUDTCLfsKK0f4nlHjMWn5kNb9bW95/G/qXE+/D2jBNvyBOgbXvsGBv4odAD1XD6v78gqh5K+aNrIrPK1230T5lVGoxLNt3AifKNyBSWNWU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB5145.namprd10.prod.outlook.com (2603:10b6:610:db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.24; Fri, 25 Jul
 2025 22:49:32 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 22:49:32 +0000
Date: Sat, 26 Jul 2025 07:49:21 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Li Qiong <liqiong@nfschina.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: slub: avoid deref of free pointer in sanity
 checks if object is invalid
Message-ID: <aIQJ8QQQbA2a-x2n@hyeyoo>
References: <20250725064919.1785537-1-liqiong@nfschina.com>
 <996a7622-219f-4e05-96ce-96bbc70068b0@suse.cz>
 <aIO6m2C8K4SrJ6mp@casper.infradead.org>
 <aIPZXSnkDF5r-PR5@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIPZXSnkDF5r-PR5@casper.infradead.org>
X-ClientProxiedBy: SEWP216CA0025.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b6::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB5145:EE_
X-MS-Office365-Filtering-Correlation-Id: 900d1dd8-2373-4060-43d8-08ddcbcd8544
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dArPCTbx4c/5BRcN0moykkEAFqpb+TweeLOrHHYOQJpECuaKVNDz81ZUt9t8?=
 =?us-ascii?Q?mEk0U8T1M3THZxRgLTdntWnMuTCcOy4owO/mlJtRWrx1X3ek+CRf9OshwYWO?=
 =?us-ascii?Q?JOPD0qDRJpRvVCVuKnOGcb21AXICh/+3mQYGPXERDUzFDvyum+H2Op+Ugk1Z?=
 =?us-ascii?Q?FuMlOmpEMiIkqYevAwklTgXH31C5kEsh2gST/qR3fp/uywMi7GAOzq58Xnp1?=
 =?us-ascii?Q?QNRj311Gm8F9QTO2Qm7ex+OUY6cpCAOLRmTwx0nG52HUiMLDhhkwW8tTenM+?=
 =?us-ascii?Q?Duwf19Se1OqOpG4VyJIDrDtosc3MqUJdkXctOJLC/CpusuwQmiTRFGe0SJU1?=
 =?us-ascii?Q?FBTDI8N5qIm39qPOVGoTudRWb33zBdASHMfpffbD1GBDevksZzp3HbNHXKYl?=
 =?us-ascii?Q?+GJ9rcU/ZcKyliLiMMyIaL4ni8ZyTlBLsQ53o8CDzDzcoyGzhfDt25JdicRa?=
 =?us-ascii?Q?ucRtxYfTBwSS1YwfIqt19zzaNTzt8YGbfuDOXlR6+dFQsCFlR4hF8wrM8INP?=
 =?us-ascii?Q?ySufoRDA4fw3MZ07lh7R0CxdohJ0gGSovlnUsnMqp8bdOI045CQOA/SN1b3h?=
 =?us-ascii?Q?mW+kEtJOz9j1+r24AiRccUX2O6aFEKJY1NcvCa4SpONZ30EyvaDlQWK+zubq?=
 =?us-ascii?Q?J1uzBbASfBGBrHCTBeCaLxezQgcUBNvKXcdfT6V5/UpqEJoRtap4Uqd+48s/?=
 =?us-ascii?Q?NiEzWtZ/UUh7ta2kF9KJ9q/agP7ieSFAXc7SKF9c5uKoIB3L3dZpdb20G5lE?=
 =?us-ascii?Q?Ff/TomAAPhZZX3/jAAaomFov8T6M5O2Rf2koDmKX/Ds++rh86K1tjLjl8Iet?=
 =?us-ascii?Q?hatspZ/vOSEzmTC8qwwPCRfyEDdnc62RX6U9a6JLVeBwBqq2lokiQUPY6V6P?=
 =?us-ascii?Q?PeyhxqF04MxGvKiJMQvwUlKztEceevdJRHy/ho7B2BY4Pg8X/MKYHHtFpVAB?=
 =?us-ascii?Q?H8nlj0NphHvnkkCxtwghmR4ka0s27JfPy87uWUH8QrJVR/8o1CZNn4XnBs16?=
 =?us-ascii?Q?L6O74dbPspcSuhnCsJD/R7BWoM/fDZMjeWU6d3zTMfkRQcLSRi43ZMLiiNlI?=
 =?us-ascii?Q?XjceqIO/uN1zNKi+lX+HW2lnWF3ODm34pPhWFDEluR6pFaO5qbhEkWSyqRI5?=
 =?us-ascii?Q?tgEjglLcq/uGpAJH85cOTYjEwe+J5T2xhiZ6dPsuANTLk6BNeuYtCi3Ye1wt?=
 =?us-ascii?Q?9KczriBDjeW7jViuGfYiu3Ldbn84qadxxm88fSZ6RtEJNY464jfZIPJrD194?=
 =?us-ascii?Q?akuYDq7MlGPvHZeGqZRS/M/lyXhw/dDR2YGQXIQHKWVnYxVLYYVR/KaYNJ11?=
 =?us-ascii?Q?bWGKrp7jEshe7IJZ64dDCECgFqYyZaKVmbK1PlGys4dzafi5/oUn9dXdxf+6?=
 =?us-ascii?Q?FmljOgk645sQ17WaqqI/nzESCnaJ6OnvJK+U12A0v8Kvd1PCsNzbtlJxHAwm?=
 =?us-ascii?Q?pTdh8y4BLmI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eFJwwWXgb7t5nW5zun4gL8nRKQiLNjLxwkrtP2aE4Jp3MxFG13FfpzB1rbDZ?=
 =?us-ascii?Q?LFS+1L7DVVacTUQWKtkVTWN5PXoaOioBERzOTFCAbtbOD0oTc0pjiK+jrhG5?=
 =?us-ascii?Q?sz+82w1GC6m4yXe/uOZmwRtt9XscwV6F3dccAKwQgRityICeCn2YskWjBy4w?=
 =?us-ascii?Q?QofC4e+tMD0Rb6q3055tO1Mm1N/Ufegweysk2tiMSYeMA0Hivxd2+GMfwN0j?=
 =?us-ascii?Q?0HSkudfawB9A1+5lmxR/epyM5RVoKcuPdF3MXEMxjZSrbH/uiXz2/5KsCP/U?=
 =?us-ascii?Q?3isyuK+dUVl9ypdnNlH15VQbXWK6A54NpfpItTkOZrOzqSZnW4pI67tTbQvB?=
 =?us-ascii?Q?dfPV4wyO8es8fxslz8/e2NV8LYy+sfL+H9bsrqePDXmO1iFV8PnubvGvTcM5?=
 =?us-ascii?Q?fyPkAlCue2iloToAl29iT2NORP3V0sUZdnmnvOehUpmYllzpgHLHcbG9RZpz?=
 =?us-ascii?Q?BPCzYJspfy/U8vp0ggfw/VhBlUL7CV1xJiG8LTg/BcXxH9qF5bjAU2FpJlpH?=
 =?us-ascii?Q?E3xKGdvo3uakQw4FQi1R5Jpmrt+p1huBETA3r2YmV50jaSCFbwwVj1dbFLL3?=
 =?us-ascii?Q?xKTZMdgGP84ZHZjlsOtsu5n/mJv7JO9B7fYdMapa/20HrbHydpf+CY7JWAKQ?=
 =?us-ascii?Q?DTOzXaN7dvcC4eXQ6LpRGtXmBROgzkI8u+mafj6/+6pqTq9KE8+P/3rIyT7D?=
 =?us-ascii?Q?DFQ+YXB+cGwJFtrZSOeW/UHgwWIVnE8RoxKwH834IzNAL7aU0eAniiMzDSq8?=
 =?us-ascii?Q?mUO2hzaUxMwlg5CphOkbtZsN91BoQ7wjolx5Vc1drAVLuhr5lh4NbaRA4TnO?=
 =?us-ascii?Q?aSkgaJc6etVCaPBCIZZaEzIHuBfi+FdAL7118u+awAhN986H5ToqNC8aPjtt?=
 =?us-ascii?Q?1DksQIkPum/8+aF0vCVhHOyxzmuvSvF8eDlUdnZdXDocImNlweHIp0fPaOnO?=
 =?us-ascii?Q?0RNI6DoF+mtqhr9zdY1UTXoho7C1eICO60HYn+6lWwF++EwYJBgl6IiqcgXh?=
 =?us-ascii?Q?eEwaci7+G1TtxT87DGE2ht+hQQRLsa8XhxkYX9/e/kH22k9aF9qoo0ZlWxcX?=
 =?us-ascii?Q?BPmznvTBss5EHOmXIC2sIho7HPxKH33wrrVdNj0QLQADJRWOSaFapqRfnaqY?=
 =?us-ascii?Q?OU8Rs+KjbIlm7TQxkGwGokUHylfFpQQSpnjCMR9JfbMWO1ocCuCtoJNDez8v?=
 =?us-ascii?Q?o0DRBa8Ye912YMoR4x6xTMjxa25AvnFN9qQNd/sgE4C9nWN6mpmXmM0PgstQ?=
 =?us-ascii?Q?bziNLD0qmpNVXa04vx9kVSULm70DEKUom/J4ot5QLHZtHpLbmQjo6g0spf3T?=
 =?us-ascii?Q?72+azY1Hm2lcgPkW3UbTXp3WMjijkD4dT3x4oPc7UCv4y3Kv+OsvL9srd0QA?=
 =?us-ascii?Q?yklRvpM7e82VXN5qFYgCKzYJVYEMpAC1fAf49unMZm4upMlVg59UyRcDih9z?=
 =?us-ascii?Q?hDi07RHXxYbOTKZye6BRhHaB/piHqn1cfbCIVl3pyrL0ivfT8XxNFF9RssXl?=
 =?us-ascii?Q?+DlMzLR/L80K2XZYHFiG1236S/+l5Pj9Ww+RbpgfS/fX8sv+5iQU7p6w24pB?=
 =?us-ascii?Q?HaeFggOMVPeu9+uqhixPd4r+PCs9+M11PToBR+yc?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kFmB6kdl+zkX9peoNkcFh1ZARxWkWGWwKGUq7y7E0x8XmF9Hp+SSVQA9Y1jsSb9YFj/MImfGhuIesdl55PYMNB94jYjn75wnNfih/wIJ1SJUUeKbLCIHOavOQITkXglddgDIaucxWYF5RBMVeRgvnE/eZHz+yl7EuUeDvh95LwaVmGPfTg55myKgUFGjqt0NXqjhKcAonabtjhdgO1RdAoIweUR5LQ+HcOxE7EExe1CAy9jPM1L9MBqTkGNZsa9gLA2vCuPSLcbzJdjNKNel9cikd53wkGeomgZgfSdpVBYaqPrTctRhCIXhVYC7KZZyWRDRoI+Z8QT9Vt4idPMZTOvEp0hacFWD8XgVwyqFNUnEXHnvCxpfruqhzRGMhBt9EY/ICnwe3BMrPTB+1dw5ucGIlvTtsbuONmLiPYAx37vRTGe32GzSenKywFxqaBs2+S/28TJhXBVd/TaV/44k32dcG5BMpdmmVWS+G+BpFC97P2fkn+83Zod7YMKz+m+0r34k1ehGw4gpepmk7qwkbXk7elOCzSJ1scETj/CjBaZZ+xg5H5qV6nFGr3H5isn//yrSO2BnJnEJkB5upJ2ZeDOnmr7VzNXI2C7+DeWNvd0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 900d1dd8-2373-4060-43d8-08ddcbcd8544
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 22:49:32.2578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WZOtpYuHXyZlN8aLxYJaJDXJIzxdj+quegz+NL1R1zUUo8tcsu9nzPVNPss0Pc7b2SdsVmV0GAGe2jBVeaygPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5145
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=896 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250198
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDE5NyBTYWx0ZWRfXzmRPldr29MqH
 klh3oIVpEgFM8yZG2A1kO1CcntAPH4X+4/sM51K3G1wSRxju+irKVuhNEcb2dmA2MbRMC7nSbe8
 BCwmYWT5NooH4h/hGEDj7P43ba1kP8fZ+HFk7D4IZY2QFbwRw7Htc8O91M9rnLa3QZf7zM4zfLA
 ekaBhd2Fi5LtzN0YnnKbczEoA5fa3VWGdVBAJP63LIVQPk6ZlrjEIMdlJSXp++sLJrfIzSqJw0n
 vSuzKZ7ZDBc+Rx+HxV7FBu4KJPucXXW8RqLjuxqq7P+QI3OB0c2UUNy16wRgW3EXypSiCAIN0bU
 idjbjdZRxaLjpdnuxFlxWtBvqHYDQf0/hvGo0FniNn9bRV2BNR2XaKSPGtmw+J0BKPmbv74K+A1
 RJ+K54LxMmUoym2FU/akdJcggbv6vXGUlRdQ23aOUwNKTzAP9NWfRchbNJpLqPLH3EbHsPCK
X-Proofpoint-GUID: _dibrsCYZ9Gx44NFHlXbr9FHzMhDw-7y
X-Authority-Analysis: v=2.4 cv=RIGzH5i+ c=1 sm=1 tr=0 ts=68840a01 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=JXmsinbq3K5hJ-isv20A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: _dibrsCYZ9Gx44NFHlXbr9FHzMhDw-7y
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1D829140002
X-Stat-Signature: qgt38too3pxz4pg3nn3s4akr6hrd4fkr
X-HE-Tag: 1753483782-450364
X-HE-Meta: U2FsdGVkX1/Y99mv8LUoMTNgrrzejvqE3ILvIh/IFCP83BT0IUGhdLKcrIXpTvB5bnWlK83ckCge5OZUJJtH4ziv0+JIzjnwPhh6HFCXyWW0Vu6bgB7MUk3Wlge493LoFwLtMdTyqxGmmcZZ2+KE1nxS8MdBtHxJM3FOpSAsPas0sKJHubalc2OaaC1r3U9U5A5FEPxwtKi4XxiSjoZrKXZnxMKTT2mq89ZY66joEGvXmyauf/LLvvP7irlz9Inyu4V0gDDQ44NQXpLTbNmbcroT2myVhWQYXk9OHOpwlJ7JukahElMHWGdN3jdB6nNhSwQhe6yKyjlIxTW6cXuynEVz78hvPLhi5ptvCRGQKp6fH+MsKBqODycq2ZOinUgBs/kgg5Cps1iJCU2sZGYDIAJKljFGYMzH7npRY22fTskQrj8KLnAD509b7jxd2QE+Iv3X4x5vdcsD+vYq9hvL2OZJ/EIQsgHc9IzWpbIcAbvslIDzuutuDTR2SL5GajGG6lr34q4upwBrDnOTR+3hEdpEzkY6f4DUk6FnqlG50iaNbc21x5aSniOH37VdUENDgRwe7HWQyNgrcqZPBd8XuiH+IXCaUzgO8x8wzgxVrHxYXflxi4znpn5NP993s7stHEWDhto1ALCSLCyM1P5gRX8NiNbZcnEtj4O+ee/rqzKdPrlDQVvwv3/Pe7Tj+bTqm8bgpt5uoFnBiNKxWeohjJI9f6xp0+FkRHJq6oJE92dWetFbq5hZIOXaIcLtMkFR/qRvY0bKfFoZzqIJjgM1uFYehYbP9UQKjw7kdFuSaOkPF0yGdXHcP84H4alMgiSP2TX8hDcSsqIk+Cvcb0akx0q/tBo50e1jz/1+IPnQmUny06LSklRMEaMaH1xj55GzqLP/LT+6G7Q9DQzWzZsXvnD6tc7dpUfLggLPKHprIto2X9pTHtObCJDZbZ/ntEvb5VawLMhgg7PKpKcMzi4
 Mn9zKKRj
 f2WijczaZr1XAZMrM49TtnD+Y5wnosvUl9AqWUjhcfBFduIxtgowjPwCc4bCBcsYQ5nQFOyG63GqGxltoJXCOQnd5NjF9W+2JgG5uIg+N3t8wmezeakhmwYkb10xT1U/NmuVXXnO0y97AlGRxRae3ScQ8eRex3QGjfYaChUCWm3qVtuT+E5gtd34jmdTj+za8C4qd6ch7run4qzhIqdomL33kZNX9dZw5fMIh4857teOPzJOT4gLsl5DS5HCFnw5CMRl9DYgcCgcxkfp1hzTZLT2oLw72DRVyGXNpGjvSeVcoQ33jJnqTuLiGPimhZ2xlK8FwpQRIIcW8dS6yf4ovRh1aH6+JnAH0wZqQPgGyKFBPQr7TS6yZdgaorRBr3z96wqA9cPT9sL+B6+VznCP5SIT/DLkiBaVrA8OtoZNZG2wB1dh3bmbAkG2zN9rXXkHLBRea0/Qtd3wrKjD9LjUitP4hP/qCEAmVdiQinxwxwVOEPWDu239gN4vsFN950h9ZuyH4emHQ+IVSBXVv7p/lNnETHuPkXeIMechkz5TgPt/ynoy3rX7E1cr4Pro1819nycb2G1aHDlH3Az2kepZdskUghi4XFB9D+t8ZWht9rT9vIwFICToMNFsO98NeZxQxo9ryo7o5tMJ8gDF9nBHeSWvH/zU1tl0zrNGp9Y/2TgRjnzW5OdFjkftMDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 08:22:05PM +0100, Matthew Wilcox wrote:
> On Fri, Jul 25, 2025 at 06:10:51PM +0100, Matthew Wilcox wrote:
> > On Fri, Jul 25, 2025 at 06:47:01PM +0200, Vlastimil Babka wrote:
> > > On 7/25/25 08:49, Li Qiong wrote:
> > > > For debugging, object_err() prints free pointer of the object.
> > > > However, if check_valid_pointer() returns false for a object,
> > > > dereferncing `object + s->offset` can lead to a crash. Therefore,
> > > > print the object's address in such cases.
> > 
> > I don't know where this patch came from (was it cc'd to linux-mm? i
> > don't see it)

Oops, I missed this email when I was replying to the previous email.

> I've spent some more time thinking about this and I now believe that
> there are several calls to object_err() that can be passed a bad
> pointer:
> 
> freelist_corrupted()
> check_object()
> on_freelist()
> alloc_consistency_checks()
> free_consistency_checks()
> 
> so I think this line of attack is inappropriate. Instead, I think we
> need to make object_err() resilient against wild pointers.  Specifically,
> avoid doing risky things in print_trailer() if object is not within slab.

Making object_err() more resilient sounds good to me.

-- 
Cheers,
Harry / Hyeonggon

