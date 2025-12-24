Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EFD6E74903
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 05:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C9C6B008C; Wed, 24 Dec 2025 00:35:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09A86B0092; Wed, 24 Dec 2025 00:35:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8446B0093; Wed, 24 Dec 2025 00:35:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7F666B008C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:35:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45ECC8B6BD
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:35:33 +0000 (UTC)
X-FDA: 84253252146.20.A05F142
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id D3F774000D
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:35:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DciDQfbo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=L4Kf55TQ;
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766554530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3YbNg3hGmzlvHXyZpG0XO+wUjMJUYwfu367gLaJBfQ=;
	b=nsbnff2LPHU19ZrlkqRZAlb9K28hXs7a2lGkEx/6XO63N0Wgzvn6y255iAfcYf9xb0B8cP
	avZVkFC3uw66hprXkI99pHwCLptXujUxdrcTN+naiSqp65Y8DLbmpgsQ05qFxWPsKJL6ko
	YWy5FjsEqYPy84dm45JUzAleXPQ9giQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DciDQfbo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=L4Kf55TQ;
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766554530; a=rsa-sha256;
	cv=pass;
	b=k03pruyjXOFWHR4tVuCRNUZ6ChmUwXpYGKzJcpFO1JG+82LEcyGFI5fHQBNFJPUZ2jKXhJ
	x+v988H+hqEEDCCgECuwzo70CSIYwVXofUflG0ocnKeDbh+J1Wa+SUiE8t4hMmB/3lsVcr
	dx12H0fRrWScxg5sx1yZTpq7ZoPMb+0=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BO2n3SH1604028;
	Wed, 24 Dec 2025 05:35:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=c3YbNg3hGmzlvHXyZp
	G0XO+wUjMJUYwfu367gLaJBfQ=; b=DciDQfboq8UH2iYhGJg0G9gC41UcDAvgJ0
	CbS8ea9ZsNI9FpeWKrNdmq4vbryqLbM6G2KIb/ztBiDtjmNvgprfCo9sfKYACNkX
	8deqpxmiAGRwG5TiHM1+HQH9amUoiZ5I9wxKlS0oBAyG03/THlwRee2vpLaw5czw
	yc3oJSqIAskBP9TfCidteU4qdPPM/DZDq5XpQDOGsn8lEGayhdn1s6oBKUhCHg04
	RA+A4n9YTA9NnhgPvppdC1y/kPOCos4wIev9xmkb5yuPLTv808LdPQfXHUp6mv5x
	6pxfxWLaoVMaSpZIcB7S4h2VunJpmzbyMZbPhEkrtmy+Qgiv2w4A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b87p88305-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Dec 2025 05:35:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BO209Ef000653;
	Wed, 24 Dec 2025 05:35:22 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012012.outbound.protection.outlook.com [40.107.200.12])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j8kcugu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Dec 2025 05:35:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u8dqIUtM2DrmwTYlLMEvwlpp8mbuhzvJLOHh7ZwXRChT3fRehfb7a2CxXhbIg1+B66KZRJXevOvJyTt0PeIf2I99WgIMG28xTkKOP5PErDbooS4jUD4DdsjFTQq9RFdubRE2VLU0aCMVI0qcHDJUiynQxJZ+pAE/Z/L6aMcjk1Evk47PCsBbe32qmRjksjinTjaEPOBtTfV3N0FH8isqK+dPCxv/1ydRfCSFchDvUTfV9pj3Nvsyxv6ijTSVlxihJ3c7tFctqXXmIovGKkpI/BYnF/x+rz7VaXGDcLYXwcaBDDgV9X7rMTpOpsd8jtqxxw7D38sMm1QuPQsLyr2waQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3YbNg3hGmzlvHXyZpG0XO+wUjMJUYwfu367gLaJBfQ=;
 b=KLUx1Ty0zzCn53eJlzmUAZ5iD/5Io/fhuBggdG4gyGmuAbboSWPkLaDe8lndu9shOiGDu3RXshd23E7azrQdOCqHC1XOTGscGLa6cEPNAM0/KfBQLMOAjHwSun3v2+dpP+LmZMLzYWrFSfKcNtIsTTmrhWsONVQl3T2X0y4IEfiFtnFncm60mMFQRlwvQIuJPr5kRvv5gSpcZu06OgbY+swwG64rlTiDKHMoTG6eassvazdifu2GGir+7avy0+nGN08t707qnopoc/iXFJxXD1LzZEW6AogJFcq9DY+rmbbVZKx6Ciq+9IcuKJjB03D5urx0XXyHN7ZxvQx32Ztx7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3YbNg3hGmzlvHXyZpG0XO+wUjMJUYwfu367gLaJBfQ=;
 b=L4Kf55TQUM0bYkPca27DZD9O/Dx02M7rB+G/lwmdPFt31sSPIvVznp+aODW6Q9ecdtvvZQ48IS5FEIabW5X42OwIrTPpbtzKM62ztDUpn0PaKeA96Rb1F/glM0nOeqGrELGKGnRYMho3hgS/SkPalJVTUAho8wYzHPkZd3nYXRQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Wed, 24 Dec
 2025 05:35:20 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9434.009; Wed, 24 Dec 2025
 05:35:20 +0000
Date: Wed, 24 Dec 2025 14:35:09 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: syzbot <syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
        jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, riel@surriel.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Message-ID: <aUt7jbCP_KQtjSbH@hyeyoo>
References: <694a2745.050a0220.19928e.0017.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <694a2745.050a0220.19928e.0017.GAE@google.com>
X-ClientProxiedBy: SEWP216CA0021.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b6::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4577:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b69ea17-ddb7-4e47-983e-08de42ae3a00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lnJl1w0rl1btRinIQw74ILW/Wg2Q8lcxJMZtm37rK/eH3kmC5U9KtC0uM/6U?=
 =?us-ascii?Q?kEJk1f/KW1zW7DiQcqGSTsUmfflqzItmmN44NrYw0C8nSLw8coic+KhQTedb?=
 =?us-ascii?Q?U/IYM+lNaZU4iJc2SsBt4OYm/0kpWssLmrQ5Vjkn73Bk6gC7jgLnM/5Z5ZOx?=
 =?us-ascii?Q?IW0HLajeNG9ER1pYul/0ZW85GYSfYMFGzW2VCZ2JdZXG0Wi44tIHuDZ/OEHi?=
 =?us-ascii?Q?XLKtB79onKgciXO0eXV/u6UejYITsqyz4BM5Scz0vzhmhAuEl3Vk7g8Byiud?=
 =?us-ascii?Q?NFFUqI+UVa2kJmdDBcIWIMea3+MzJ0wLImF3HAy5R0P36Hzb4SfuGA6EDrYO?=
 =?us-ascii?Q?AzL06yQEdMpzPLgCfzVeUB9x9bE3cA6nybgwBg7aG03NwTyEo+frV04JgMOQ?=
 =?us-ascii?Q?xdPa1RKTq2jXVwIyp/qSxl0+bygFlQcAWIYCHpKwU3ecX0gQIxhRxs7WDLXd?=
 =?us-ascii?Q?9/IDbTuBsBBHQOaYrJ5ganJU2nw18fR2b/PrFQQevi5fzPL06H2I47C+Tj/x?=
 =?us-ascii?Q?y6vCTS9B42sqU9epyGD7IY1zoRCqfZYO/0/3J1Ftt1jZUGbti4+scCbAfwDy?=
 =?us-ascii?Q?zBcBAn53hQmHW/0gizdkfqIytD3keLpq9vBk7YjNngYr0VjKVtthzAaAj8jX?=
 =?us-ascii?Q?iFOX7IhDqMuri4dzGYVu09wK9WQwFcBp4zB/jk555OQDaofhCmxXXbksLk1y?=
 =?us-ascii?Q?2BBAWGsVbJ1J4tFYizKcmZ+p4BwDFQ0605QzNx1hNyB+u3Fh6hd7rVWS0fxJ?=
 =?us-ascii?Q?zE+bCPo3ZUzW3nrtLSMvJF7KyB9zM77uQnqYs0pjyE9UsnquhPlDErUXEclY?=
 =?us-ascii?Q?Gr6Nxwtd5ceajYuOoujyE4X9wKLPgvyJLCEysB9e9DTjc4E+rcewC0PmUDVV?=
 =?us-ascii?Q?IxELQsTO5hA7nlsXTX7rzVSg4x+74JLuXewd8X8d0fOPeBlP9mmbw/w5elcZ?=
 =?us-ascii?Q?vbeCQh1jMEybx9/fuSulZqVSYdIApFJFK5+hKm3WZV5kESlCs3Ue6HD3LirU?=
 =?us-ascii?Q?9g+YJaTNQmanPpDBc6X0DaHtc1X8fEIxdyZtIOgisb0d6YfFRkibkIay7Huv?=
 =?us-ascii?Q?3WSaEeWQeTNPB3JVjexDIGYDWIyuXkGp42IBCclHgBNvIAfNr2po4nauabIW?=
 =?us-ascii?Q?/hx7pqUXhHwsEZPKlRoNpi+xjIx4M5YlKLAThaehXlXAuW6PeheBO7+02het?=
 =?us-ascii?Q?a1X+MKFzkGonSgDXdg4pKW/eTUhm3fNr5hjhG9do8+HWe70pQEgobYkNHkpU?=
 =?us-ascii?Q?nqTIbaj3XTstQYAZAUdscRtuqoSnZkv+12BaxW18kHiOlq9DVWwdp7TwbJx8?=
 =?us-ascii?Q?DHAcibL5b5YS40Hv/xOLdxDifyLQRVpgzSX/dGUjs8JrQlOSBKn4y2T1Q6OM?=
 =?us-ascii?Q?yeqzNykudJJx/E5vf9rJ7rZNxu44RfW0YnKVYv0dFyAdQS6S1g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RfHO/c2OLlzOfcUlbE+Na8EqUOPcR+npC3YoAXH7eAq6G9WqEsqgrJNxd7n6?=
 =?us-ascii?Q?jPOoSy+6pBL61HYBEqfZhGum0Oog8VieQVRmM2YyiY1kCh2gYHh05ibGNiKe?=
 =?us-ascii?Q?Qsw++mflsGfkYTOapKjD702VCbk+3B+bEJtPS45YqAO+pV2oX5LIVbqcyHNT?=
 =?us-ascii?Q?VR+BSSdZ73X1kuXLfL2D3dkrSUB4JCJntgUZTyIUgsxBOtySDtq2VAla3D+f?=
 =?us-ascii?Q?pptyloyMNI010ahNE6wtEEg33P/zSCs8Pv5kykEyKCElgB/18sV2w8+zNpbd?=
 =?us-ascii?Q?SeJD4i2dvGbMQ/91F0sWdnzDiiYfbYyxw6mRVwv62oYVxFZot3uVWb6VJbcL?=
 =?us-ascii?Q?5CFw+sWeu8mMDaNmLjeEhRRbmjX2YqUEGpVq4wSJv16hfwYqPyjmbvSrxkWU?=
 =?us-ascii?Q?U6Jy0+eLSofJzby+TqIXlq/eTCRCJfcURmcPhefelIXq7OaqOlZmSaOAJZ2j?=
 =?us-ascii?Q?8OStVmv+Rr3k7GjY7zIzLxdcBfVwyIr/MZR//j80JJO5CFPNhjtJQjGmgfYS?=
 =?us-ascii?Q?q1TJYDKzF1i9E0N3LhsVWv+fg2WB9jIvShrzmYMbJ/yio16haza9uRvaCDyz?=
 =?us-ascii?Q?A9xiC/y0CEF3E/Z66LkXXf+V1WRiwDIxpkceDFKWHyqZSWwr4JYfEH8x2yJL?=
 =?us-ascii?Q?/nr1OTyAekVLcZKBcwx3UgyKeBp6N6dFOfxHuViFidJL3AMrSzS2M+OzgJUQ?=
 =?us-ascii?Q?ehAHGDpC/ZD1jHu1R3LMLci4xOA4p9FVI97QBG9OhcTjimh1dkOmak5zoI4t?=
 =?us-ascii?Q?v7NSwKOb7BJ//Z03/UwsbyhFpJliSq/PGM2yXX/qhYCLxnsxUpRmPzSr89Of?=
 =?us-ascii?Q?ckUuzTQTFZ/hFa3TOfZ0OUJ3vvCQTK2EzFMF5Si1AFI097A/bsc1SizxK992?=
 =?us-ascii?Q?zYpAWNtfOTseVBn6e4Aow27GAYQvix5ZLt5CY7ZRwAAhOYj6cKiY0H91XWLN?=
 =?us-ascii?Q?HBpV7Q7pRLKEt9RedzVAWdVk5ZG82aCV3iAl1CGjGpZiu3E7nn5O5VAqGKJU?=
 =?us-ascii?Q?Q8RHzezcy0QGZqTOX+VzQegv7LUH7W+afe5eJJGsJE2xq/b/evh1ZH4L0SGM?=
 =?us-ascii?Q?0NTbZxF+yuY6KSnALWMCK3sgtbtaGGpNYoSjvRhBFWwaDj5Okjxt6NmNxmJL?=
 =?us-ascii?Q?nLa0KfWs7WrMN6LbCfg7CVRi7h4VnIsQ/2Q0Qd4GQe8DTPH9+Oy1jSx5ayhL?=
 =?us-ascii?Q?e4HBcDmf5XWHplhS7OmZ5eJUSlX78ZA7RuhK1ardQEcsBoF7lKN+bw5qz2HU?=
 =?us-ascii?Q?umosyLpasdtcs1nj6/DTZkepu5IUNj/UYm74ycfQRF+RcNiGqWRVZ4HcOGz6?=
 =?us-ascii?Q?4h0KNyRi19fEoq/htJ4EnMl58D7DUFZl1YbnhMnB+RwNrWvZuDQENZ1e8lFy?=
 =?us-ascii?Q?THBKfFjaleE5EBqIW8Aa10FEwJ6+zahbv/GRTAEL2X63enfq8RTma4JLY4Oc?=
 =?us-ascii?Q?Fv64UHuX5eAHcgH1zTH1OuyHiHI0x40RT0gVnyKPM5QhuqHnUuY3ZFcOkE8p?=
 =?us-ascii?Q?yHO9dnfcWdwpwSwmcIrVIfs+Bj4lVpuQYpfs29nEnzpr1JG5e2f294r4RfvM?=
 =?us-ascii?Q?Dk7yBuuqS49TDzCGLdyGy1754CSOcOpIV1SYh9a5mLzO3lfpziRum0ezk/Qq?=
 =?us-ascii?Q?QWTYTch7cNolEd6Ih4pAndDvuAoQdyVWk8kfwxtPOMXzm4tFy52FW1/y29xz?=
 =?us-ascii?Q?1/6NZ4GYIjOxz1cdFC2ltRYzwBv7vd3q1FVylKefBeEcp5SKjM9RdsJDTDBn?=
 =?us-ascii?Q?B+aUJEoKOg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ytunSPtQlEcMsrEbhGHNJrF8NMJFkIBM5yumoysmf8Sp7XX9owJd+zSys8hGOohjRqk3jjlzrG9VWydbFzfngcs81Y7uwQROspXBDVD/prsSAj3aACf8s9Bo9E8oFK+183Qi8q8kQUe3Dku+MJjozRdMV6UCo3cpz+TJxYnhDQRkcLcdlyPcJwxQQcEpZv9RMWAdhqFn2h58N0fQdW8hgAWPaTpAnrSgd1JKgE+VkwTfnGr7RyUuRzWYSGl9ycI4cqGwhRJ2zCj7ey4eAT8zf4wYwG5/y+4uEWp0yOKSPbyBasvM1YUrKZlSaqhHGDKK7wS6Rg08jzhg8Dhdm7ICLJp4iKQ+rZNiOjOnLyRq8IrlJZldVqFNIxZ00FxXMT0i0btXO3Glfx9Ec+nEdkU48hRDVX59nWIjLi5ZWMRFmMEQd3WVXbSAEH8cBRF1V1GWV1Alpoo1SP7G3rK6hoQ/JEb4Uo9Ql0AFUGfj7yPNJJPL6MdUgV58YrlUvT6n1OIWzaxANFfo7ALaBVNtua9jYK+R4NBU9yCJ+G0JcvvJQfpYtGgDsyf3xeSo8X6YhDLCA2cnGCUvvEji7DB5C7GQkB7MfkwMJ/rp+FmIOyd2m2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b69ea17-ddb7-4e47-983e-08de42ae3a00
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 05:35:19.9477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1FMf9/HuSHmZpnvLfHdkID/w51Ruwc9PnKEYwkhVehWYWFYeCkpARrp5aG5Mw4Hlko3DFPR7BINo3e2SqohVPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-24_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512240045
X-Authority-Analysis: v=2.4 cv=e4ELiKp/ c=1 sm=1 tr=0 ts=694b7b9c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8 a=hSkVLCK3AAAA:8 a=B9itKbTiQJ2Mn_Bo0fUA:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22
 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: xvlny50ObC5Bp9Q5BS7h_ZmIdVHwXKU8
X-Proofpoint-GUID: xvlny50ObC5Bp9Q5BS7h_ZmIdVHwXKU8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI0MDA0NSBTYWx0ZWRfX9dwwxWrmRSij
 QxMGqL3KAgpcU2covINGPGf0Ni+tfGgtiid+al/jlj0tNBvcpVkGR77InWRj8AywlZVR66lnJWU
 gpgd6xodosdVU7H6uO2LTs8LM4+8Kg950zLfvDCjKX+unYY8nbt4bSTjQtJy3W4QFgoq6Az7eLu
 93nOe1xtzmnY/cRcxZpho2hbvZ8XBlLfgveZYsCuXgXS2IRZ8mXD1wrvBO+M5DVPOhWOLRjb9xM
 8Ij5XDiyRC2blLK2gNWM9oom+vUfiTBbu0ES3V0XgbcoLWfT+69NEB00maaIu70tU83anxsmHUm
 3TvVqkSa7d89YMpjsQE5qUOkiSk2fo6RW9Icm21u/IdWOY0OeY/peeuhvBrPDuNFiuxj6sMWM7Q
 5TpQuMP5WcaozH3V5mcjJzMBRE99mc0jU4G8kWCPiJvysbTyBwTMWK7PfXkK7vnoyTMCWro+hC+
 1N13nGCdniKe9zD6Ro9evbaViWbTYDle8pcasOJ0=
X-Rspamd-Server: rspam02
X-Stat-Signature: tpfizzhsw9pkkjyu59pgouqiuert488c
X-Rspam-User: 
X-Rspamd-Queue-Id: D3F774000D
X-HE-Tag: 1766554529-487709
X-HE-Meta: U2FsdGVkX18HC3Xk3T8TuRZPezgQ0U9rK0cngxeBe3Z/txePB3IcU9YLiQjllLlUD3H96Yjrk269/FnOtk/UwtfbYyTAEFUN0v5/Hd4MFsMCp/3aoTimdESHSDa86d2ublRLa23pinQDQ0RNOoCOA8ecyUhKvlUGFrcLl52mMLD5LUE0IFJ6whWsnF874df2bRwgwWPgowZWmXilTEbVPK8+WNMJ7JTTtubb5gAgpTGg6CvPF/z552PsmQJg8DkT2UsPXsETuXVCnlJnmMrFhqQR9aRxyQSH+NcCFEeUREDX145HER6rV0TJXAUzgXLr8MZg7cnN+84fA4HYb6pm8jqx93O1Al2Qc0wfOML8AH9HjYD0E5mpDpim1pL/Nm7jdJGOUT58uHeBxIKprXWp9gUvrIRYHs3HbaN9Us30IO7+yo7NBOy1IeGbY4ECvwLDQ2aHt1V1RyAvrBSfzvgp65PXPZ6n6osWQUm4w0iG2Tt5q+EA4grBJ2pEhQlxW0QlpR2VO7uM3ZP5Aj8B3TlQb/3un4vpCneHRUH4ESMGQXDdbC5bdWqO9So5FfbkHzsY5GS7jwYNzBm1zJLS0mMOH7msSAStKmpMAm2IrYGJoWhCFopPtmRoJqWVp/C3VBtGWPBLi8v1930xP1dYxN6xUCJAZv7oUwBXt51HHjpsChuIBnAuIIZxoXFTNHPfQAjaSej6GfJFTfAyc5s7Qxvvu2ZbcMVklm1N+I7+6ByQHNUVVwraZb22FlVWWiG29l8Y5m+65IdJFhUTuyYU2E2+3WalSyRCyzOJYPf7q0czNCa1jrIRSMhZ/IvPlSxFZgCG8Pr3yu8BT+FCQ97vSVWD0ozAQ6xq1/v5pOr+mSdlXF7qMOMxGvR5U7FU61OAyb7Lfi8WnKPgsbU9iUo9JsMd8j506raPaSl5ff3UfE32TbmXyF3y2EDVQZ7z4EXYPMIVflZ/53QMhzuo7bK74cu
 Y3jUYSnb
 L9U2ramZ49fDbJl4TSxYITkhM0m6WkHJI0BjP0xXNkO8XTeZyVOeUx9lttlB8dCHwDLCjOltapbNaMUg2UelKFC8HL8sKw3v6rQQ2CW9JFB5XLm0dVWGC05RIMh4VSJuYS2xvftti5b8CA7zzqURdxqAnbAW3wWiRgwcfO73uJP4Qlk6nzPwq93vzcr2Lu+lc+D//upfIzpbQ90sVTpXZHLmafAIOvAeiWPBGOwUazfGnqk3zyuFIi46SBl+67Jte1Op6cdAr613WGbQK62xy9hZ0VJyKw0ixh6BtPx1S5zFChl46hPL1W2bE9smi2kX0IU2IfgT32J9wGR1/VEIx7sFt/w3g+HZs67lHhzwWQNFDn8QBFKDh85H+sPzPYRO2A55BM6yB8OOqHTqD06FzcH4YEeHb9uz1VlsL5boA/bbS/NkrskqU9ukQsAp56rSoRipe09/353r1eynt2TOJ8MLocGWikpS9pnv/u7Y6CEXnEC9SrnG1F3TpB/16/ic6NwXHOW2z013iQSp+d6zQydKZk8eQHbFBZ0dT+6RMroUfAIl0MM/1fqQMfPr3VrQFt7GDaIrO409lTNcCuKC8iXyLWZCG6kgjcLodi5wKv7u467FSlunK9Bdd/KVDWfJRE+fwfjQC6xX73l9UNO8lXZKLM4hOxCxYGrWOXwDrFSliyO0d60DtfHumXwI8QYVPAaX00VvL9oh32OJhons0lfiuxyY018vhSGF0eGBAe+0efH7kx/z3JsUpSgfDuK55oP5qLbSk+FjQZj7wcY81t6C4K2uCH83QkYRLthQr9lq9IxrFegqmIwHRbBmwP2vMLRhBq0zny1pu5GOJaVZeVSYGJ2JflHvyHuNi80kJhLkl2+5Mc/0XMVEin3vJjKwQYd2IStgS42rWT/VJqvfBVkVpIcLbcLKq2kEYXkLlqpVdxJKf0/hYZxHrwVit9v7cemiCr8s3d0xZZAwxZcafrLOuwh/B
 NC8raSuT
 9aUPoEzrYHS6Ij1FgcSK/skCJTs7/ddWeBC5SIW29+RdzugDFs0O8FLjIggVMs5HkXRHhN5fS7Fd5fqT5HOcIvEA+Jvi+JPgddtdyyCcoJUkHrsqvxV2H0OemT+zrxd9GxHYBd8Ykaug8XszzV1CpooKSdCirxcSVC0XzqM3jHVTlWtI6cb+UUsfD0gu6N1+ilG0WUYGpTGCREXLNd+tfh9z2973w5w5b5WG+qiEulw6F8RFmLLuqQwY4FJE4NgKXVkpivAxFB0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 09:23:17PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9094662f6707 Merge tag 'ata-6.19-rc2' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1411f77c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765
> dashboard link: https://syzkaller.appspot.com/bug?extid=b165fc2e11771c66d8ba
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11998b1a580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=128cdb1a580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-9094662f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/5bec9d32a91c/vmlinux-9094662f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/3df82e1a3cec/bzImage-9094662f.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
> 
>  handle_mm_fault+0x3fe/0xad0 mm/memory.c:6580
>  do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
>  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>  exc_page_fault+0x64/0xc0 arch/x86/mm/fault.c:1532
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> ------------[ cut here ]------------
> WARNING: ./include/linux/rmap.h:462 at __folio_rmap_sanity_checks include/linux/rmap.h:462 [inline], CPU#1: syz.0.18/6090
> WARNING: ./include/linux/rmap.h:462 at __folio_remove_rmap mm/rmap.c:1663 [inline], CPU#1: syz.0.18/6090
> WARNING: ./include/linux/rmap.h:462 at folio_remove_rmap_ptes+0xc27/0xfb0 mm/rmap.c:1779, CPU#1: syz.0.18/6090
> Modules linked in:
> CPU: 1 UID: 0 PID: 6090 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:__folio_rmap_sanity_checks include/linux/rmap.h:462 [inline]
> RIP: 0010:__folio_remove_rmap mm/rmap.c:1663 [inline]
> RIP: 0010:folio_remove_rmap_ptes+0xc27/0xfb0 mm/rmap.c:1779
> Code: 00 e9 49 f4 ff ff e8 a8 35 aa ff e8 c3 55 17 ff e9 98 fc ff ff e8 99 35 aa ff 48 c7 c6 80 b7 9c 8b 4c 89 e7 e8 8a 12 f5 ff 90 <0f> 0b 90 e9 5a f6 ff ff e8 7c 35 aa ff 48 8b 54 24 10 48 b8 00 00
> RSP: 0018:ffffc90003f5f260 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffea0001417f80 RCX: ffffc90003f5f144
> RDX: ffff88803368c980 RSI: ffffffff8214b106 RDI: ffff88803368ce04
> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: ffff88803368d4b0 R12: ffffea0001417f80
> R13: ffff888030c90500 R14: 0000000000000000 R15: ffff888012660660
> FS:  00007f98fd3fe6c0(0000) GS:ffff8880d69f5000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f98fd3ddd58 CR3: 000000003661c000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  zap_present_folio_ptes mm/memory.c:1650 [inline]
>  zap_present_ptes mm/memory.c:1708 [inline]
>  do_zap_pte_range mm/memory.c:1810 [inline]
>  zap_pte_range mm/memory.c:1854 [inline]
>  zap_pmd_range mm/memory.c:1946 [inline]
>  zap_pud_range mm/memory.c:1975 [inline]
>  zap_p4d_range mm/memory.c:1996 [inline]
>  unmap_page_range+0x1b7d/0x43c0 mm/memory.c:2017
>  unmap_single_vma+0x153/0x240 mm/memory.c:2059
>  unmap_vmas+0x218/0x470 mm/memory.c:2101

So this is unmapping VMAs, and it observed an anon_vma with refcount == 0.
anon_vma's refcount isn't supposed to be zero as long as there's
any anonymous memory mapped to a VMA (that's associated with the anon_vma).

From the page dump below, we know that it's been allocated to a file VMA
that has anon_vma (due to CoW, I think).

> [   64.399049][ T6090] page: refcount:2 mapcount:1 mapping:0000000000000000 index:0x0 pfn:0x505fe
> [   64.402037][ T6090] memcg:ffff888100078d40
> [   64.403522][ T6090] anon flags: 0xfff0800002090c(referenced|uptodate|active|owner_2|swapbacked|node=0|zone=1|lastcpupid=0x7ff)
> [   64.407140][ T6090] raw: 00fff0800002090c 0000000000000000 dead000000000122 ffff888012660661
> [   64.409851][ T6090] raw: 0000000000000000 0000000000000000 0000000200000000 ffff888100078d40
> [   64.412578][ T6090] page dumped because: VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0)
> [   64.415320][ T6090] page_owner tracks the page as allocated
> [   64.417353][ T6090] page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 6091, tgid 6089 (syz.0.18), ts 64395709171, free_ts 64007663612
> [   64.422891][ T6090]  post_alloc_hook+0x1af/0x220
> [   64.424399][ T6090]  get_page_from_freelist+0xd0b/0x31a0
> [   64.426135][ T6090]  __alloc_frozen_pages_noprof+0x25f/0x2430
> [   64.427958][ T6090]  alloc_pages_mpol+0x1fb/0x550
> [   64.429506][ T6090]  folio_alloc_mpol_noprof+0x36/0x2f0
> [   64.431157][ T6090]  vma_alloc_folio_noprof+0xed/0x1e0
> [   64.433173][ T6090]  do_fault+0x219/0x1ad0
> [   64.434586][ T6090]  __handle_mm_fault+0x1919/0x2bb0
> [   64.436396][ T6090]  handle_mm_fault+0x3fe/0xad0
> [   64.437985][ T6090]  __get_user_pages+0x54e/0x3590
> [   64.439679][ T6090]  get_user_pages_remote+0x243/0xab0

woohoo, this is faulted via GUP from another process...

> [   64.441359][ T6090]  uprobe_write+0x22b/0x24f0
> [   64.442887][ T6090]  uprobe_write_opcode+0x99/0x1a0
> [   64.444496][ T6090]  set_swbp+0x112/0x200
> [   64.445793][ T6090]  install_breakpoint+0x14b/0xa20
> [   64.447382][ T6090]  uprobe_mmap+0x512/0x10e0
> [   64.448874][ T6090] page last free pid 6082 tgid 6082 stack trace:
> [   64.450887][ T6090]  free_unref_folios+0xa22/0x1610
> [   64.452536][ T6090]  folios_put_refs+0x4be/0x750
> [   64.454064][ T6090]  folio_batch_move_lru+0x278/0x3a0
> [   64.455714][ T6090]  __folio_batch_add_and_move+0x318/0xc30
> [   64.457810][ T6090]  folio_add_lru_vma+0xb0/0x100
> [   64.459416][ T6090]  do_anonymous_page+0x12cf/0x2190
> [   64.461066][ T6090]  __handle_mm_fault+0x1ecf/0x2bb0
> [   64.462706][ T6090]  handle_mm_fault+0x3fe/0xad0
> [   64.464562][ T6090]  do_user_addr_fault+0x60c/0x1370
> [   64.466676][ T6090]  exc_page_fault+0x64/0xc0
> [   64.468067][ T6090]  asm_exc_page_fault+0x26/0x30
> [   64.469661][ T6090] ------------[ cut here ]------------

BUT unfortunately the report doesn't have any information regarding
_when_ the refcount has been dropped to zero.

Perhaps we want yet another DEBUG_VM feature to record when it's been
dropped to zero and report it in the sanity check, or... imagine harder
how a file VMA that has anon_vma involving CoW / GUP / migration /
reclamation could somehow drop the refcount to zero?

Sounds fun ;)

-- 
Cheers,
Harry / Hyeonggon

>  vms_clear_ptes+0x419/0x790 mm/vma.c:1231
>  vms_complete_munmap_vmas+0x1ca/0x970 mm/vma.c:1280
>  do_vmi_align_munmap+0x446/0x7e0 mm/vma.c:1539
>  do_vmi_munmap+0x204/0x3e0 mm/vma.c:1587
>  do_munmap+0xb6/0xf0 mm/mmap.c:1065
>  mremap_to+0x236/0x450 mm/mremap.c:1378
>  remap_move mm/mremap.c:1890 [inline]
>  do_mremap+0x13a8/0x2020 mm/mremap.c:1933
>  __do_sys_mremap+0x119/0x170 mm/mremap.c:1997
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f98fdd8f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f98fd3fe038 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
> RAX: ffffffffffffffda RBX: 00007f98fdfe5fa0 RCX: 00007f98fdd8f7c9
> RDX: 0000000000004000 RSI: 0000000000004000 RDI: 0000200000ffc000
> RBP: 00007f98fde13f91 R08: 0000200000002000 R09: 0000000000000000
> R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f98fdfe6038 R14: 00007f98fdfe5fa0 R15: 00007ffd69c60518
>  </TASK>

