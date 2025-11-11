Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA15CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 15:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D7878E0008; Tue, 11 Nov 2025 10:38:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AEF88E0002; Tue, 11 Nov 2025 10:38:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8768C8E0008; Tue, 11 Nov 2025 10:38:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74D378E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:38:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1244812D845
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:38:06 +0000 (UTC)
X-FDA: 84098732172.24.B001AB5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 88C03C000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:38:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VmreoiGm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FzGJfpS0;
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762875482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NzIjTS+Nk2hx86NnNIPXl0ZwwofW+a1eh2mM+6BrrA=;
	b=prB5MkydrgOm57f1zCIXUyYlku7NiRKf4EStCIt29l2U1DNukSWhJ7zmgqiwTZTgBpLb79
	7y/VdF4tvL3QNP4QPhHekCtqluLigNhHlvgNvV5p9irKQ1osbKmKvKYDTZU5WlLaVPwPo9
	ywiyKdpUwX+zERaNII4bgIW0FYdl1vM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VmreoiGm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FzGJfpS0;
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762875482; a=rsa-sha256;
	cv=pass;
	b=n+qNrd8vPZ6qOASTaAfFPh2IBHl4XN2UgeyvSVvCgdANIomAuds50210U+TGvOHHFUQnZM
	DU2ybdSwBAzDWoYbK3oC0Ai0VAfOO+XHaeJO+1Tl5wDpir+454bUvzxAgSXLtF/iNCvpC/
	gxKy9+IfuItvK82r5EkTvFQrpS2IXpU=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABFYoXE004470;
	Tue, 11 Nov 2025 15:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4NzIjTS+Nk2hx86NnN
	IPXl0ZwwofW+a1eh2mM+6BrrA=; b=VmreoiGmfwI09IXOWfH8GGkfrubrszTqn2
	ulcqf0Z33fU62Y8b5N7oPRK8nNLiw/3zt/4q3oSvjo8D/KD5ZdloyByJVtSMGtur
	iHAqaX3IYvMcdbEkX/KCR63Yx1qGtF1ucwsIE+cun0mWRdqfI67uffdbvKaGe/OU
	yLzNxsc7qDWBS+qmMvQ/UYVqNpA9//S/IyEAyvrscn8JyUYqe7bah4H2D2CKlMTa
	GVKOCQ1vbDR3GpDcyssR4jx002U4nU6J7SIE+ATup4SbJlOy0JMLGK1/vZIftPMH
	99HDWoWmJzbbw6mxrV3INTi07nQoxFpgDvfQTiBdl6CzzVuldFFA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ac7w4g055-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 15:37:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABFMFth000967;
	Tue, 11 Nov 2025 15:37:56 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010000.outbound.protection.outlook.com [52.101.56.0])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vadp830-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 15:37:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WGg2Tj2L5V4DYu1aas/0xEOcFHuT/6pnJuwmaugcayThaxsbSeGDJG8h6Mh1bind6pv3vrjG8EPOlycpkZ0MoEElGTlQASlQQcseTqSWLLmhxbDyi5Uf4XAWBhJhKJfGwerXAEoQIbppo7T7hOTqSUSOxWLczQ6JQNPD8h6KFOuspZ9d0Nhh4h28Q93Yrem7sw8WZo+Pgkg1MsDAjIdtjkCNGPlxbpm9dBLw9mBCty6Sd3SwYtmoMzMEvvE/9ipI4w7QKPO35zWgIIK45esOvLTppBdgmjntM5fxYdH2n2Wm2QOZ9tAQbyMA7Jp5gKUE4Ukg96HZmuRlgN5LeUg01A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4NzIjTS+Nk2hx86NnNIPXl0ZwwofW+a1eh2mM+6BrrA=;
 b=E2aIgEnko8s2SEv7ezStAfDtxTjgmSdn/Acn8OhivQgG0wUJv1iMiY5okHFzlJuc28yMuFpShFsbXtdY+pj1USflXVw85psYRLlZjS1KKCAzdZfJ8sDPZQIuU95wycVx7Spv6FNJ+F0Ld1Ce0/CsBN2Q6FBDOmIbZSLdshnH/nHN5oHHjsEFFzG+NAGaO1q7+Qz6pfBiTGR35PYYHC263qmln2jgHeR1cR8Kpo7q0NRsCbO0xGoBIbi2N00td/cy6aYqG3oGFBVISp90ciVSDYchyy0yTcgFr9RSE1awQPOjKEErh2YXnp5HZ/Ef2PrnGTxMuK7Xn5Dtu0SgOs66dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4NzIjTS+Nk2hx86NnNIPXl0ZwwofW+a1eh2mM+6BrrA=;
 b=FzGJfpS0iKuyFr4nT6Rf2VA1ZVAcdllwO4FJc4M1MhCzSD+iZvVmLr506gpKBqEAyYnV+UMy2jk/me/3B7BaW/rQKhOxricdJt4zoDrxoWVZUHDJgEV8QUjyOAFcP21JKIiYa5oEhC2ZlO/7XgI2Qsat69dcnL4c8n1rPFm5SWw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH3PPFCCF14A5A1.namprd10.prod.outlook.com (2603:10b6:518:1::7c7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Tue, 11 Nov
 2025 15:37:52 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 15:37:52 +0000
Date: Tue, 11 Nov 2025 10:37:48 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tytus Rogalewski <tytanick@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH V1] mm/slub: fix memory leak in free_to_pcs_bulk()
Message-ID: <eesmaqfwnhq4xcoduevr5aodsf622ugn5aheywvpbhpg5fzhcv@5zbfhikqmrtl>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Tytus Rogalewski <tytanick@gmail.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <20251111125331.12246-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111125331.12246-1-harry.yoo@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0464.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH3PPFCCF14A5A1:EE_
X-MS-Office365-Filtering-Correlation-Id: 28aa8612-bcf1-44ad-51e3-08de213846aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ClsrmSfY8hAxcLPcA989vFu/L6mm2iQNZxRwjkCqv9l4PWbPCJQF9IIDUz4s?=
 =?us-ascii?Q?FEhUdirLGBhvM3R7Hg48AQAc8Vt82F4sOVkFr1HjXdOLNLqTi2Xw+JW7jrdI?=
 =?us-ascii?Q?6UgvwvpsBwltTjhtcZcxH7LKnby2SbYHAU2BR/jCTIbjEpUAcZUf0IzLQrb5?=
 =?us-ascii?Q?CIjK6ndiyKpLc+VUxNg+Qj7zlGxB7dIP6PaoFEGoqTI00NactNhi9KRk9yoQ?=
 =?us-ascii?Q?cofA1ChyHQohnjpe5BVZZLOhA7GqpkOxvzuKIjW3HnNQ8hXMyekksGytUe18?=
 =?us-ascii?Q?/K1Hkx7Go7mrG/uiOR6aNEJDDRsbld2sW8IZl/DoqVtj8gi40caaPHxNkThz?=
 =?us-ascii?Q?pE+HZ0ZwSfiRbn3cXNXGkFguQeGgSmydgPKlXeKA9OwV62LV4Hn9qAZjR8Qb?=
 =?us-ascii?Q?T3F7RqEp6hbAHsnEcDeO/Ml3dAA2sTtLIMltLIP+Hjyze3yQDewnYzsSSW5J?=
 =?us-ascii?Q?5GOt3TqJ+d6K5esEPGWqYdRBcR11QSqh+088bJ7E2HKSmHFIx5mvKAgJIuQM?=
 =?us-ascii?Q?i4+uckSZgwaU/xZniA92/vs8uJr0f5krCeNr+kBbRbJXuPjzywgjt9l4G/U7?=
 =?us-ascii?Q?7uJwEjXCTHy9Pd8K5zd9aU8d+ef291uMq0patBKMZagJYrGjue+Ip0OMtFpP?=
 =?us-ascii?Q?fJKnvWrHxjIHa/Bk3Ulf+aYj0pz1eyiYupO0dTh1702L1xGrxn1rm7hIJyco?=
 =?us-ascii?Q?oEHekI0xsszFDz5wDTybuj2JkoIJYlnNidGoh12zhdq9HihbS3s/QGpvYtCE?=
 =?us-ascii?Q?+fDeugMpTnZ6FA5ToKN7+Jo8l0Tx+tS8t3rqmcOHR/NA2kLDQQVnT6nj/Rci?=
 =?us-ascii?Q?vv0wFzZSmXrz+kNE1pgmp3LU3igkkbezXVQENrYuQxrEfjnhRR2tGNfwHK/t?=
 =?us-ascii?Q?KjoVZ2wsK6Cs3Per4d1JA/3gK8tr6BAEg8z6+gDcMOd7wswMymrS58BuYtbV?=
 =?us-ascii?Q?yvi7VtA7jxKrvHNYVInd8AcTh30vS2ptvQqOSc0E3B/2figRrstioOJuGTUn?=
 =?us-ascii?Q?PJhfbXjkLYc6+YuTPdljbgHjvfwgJL302/AXR1MD6lspnPWF9RrJKol0LTTc?=
 =?us-ascii?Q?QpOHfc2FVBw4Okc+eekEkEPv0sr8D+qu5s2Kd7V28a+UWLGH8qdehic6gueC?=
 =?us-ascii?Q?va5aPX6zAhWpKvPLh14tVtQDBIYigutlr9k61EEaoRbsGxrBL/yvSJ1cnTgb?=
 =?us-ascii?Q?6nl5SgjHOfRhfJytnt9dMki4jv+Qz8jMirzkDKUYf7Bm8pQao5TXyGzUFZZ0?=
 =?us-ascii?Q?2pBjl+O07ZYDSDED8axUwKOEFsd38y04/ffy8r+VJirNurPumUIdvLvQSJkn?=
 =?us-ascii?Q?LqtvaXQeZXwumT5f2absPQb7/W48fgEVJv7TwNt9m78S9hq9ajtkakm+bEdT?=
 =?us-ascii?Q?DQQlYH4EGHgYropQVyGSAVcUKMREseKXN6yRMy1vXTx4FycSfMfC4J8dgBev?=
 =?us-ascii?Q?VFV2KgjzIW4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kWakXrnmE4FlpbG6oHfzpKSNysOClJJz5q7Z9xcHBuJjBGA2XrJLarQUYmn9?=
 =?us-ascii?Q?Lath19SZX1U8QsbuzwhY+PCrf1uaf1R+wxh578QzEXXtZynTTAy8+HIJ2x+V?=
 =?us-ascii?Q?FKYqn0YphL4SSLxe39OqcH3ar59cxoHUO0D6gWhV0sfdtP2Uq0xVtfyL7r0V?=
 =?us-ascii?Q?5819ROQqAjLYt4/BBATAQuyzq7nTWOP7qCThaxwOLarPWFIFl2/9RBWUWGBS?=
 =?us-ascii?Q?YbROnnBRDMvY0MBVht6WMgsPODCBEw7IV3yzVl3lFP9sD7XycQT6rDzmaybb?=
 =?us-ascii?Q?PKkIiA1vyymGzs33zlCnoA9w5CngZ5KIMUAMJRBaQOc2RnCqCGM5W8QRX3k/?=
 =?us-ascii?Q?QhSt8jylajRmLzaswa999lagtKvzHCNoEFuFdq/uvaCOXm1yZkpdegEWmlnH?=
 =?us-ascii?Q?epV5jc45cBg4vkkgMkKKda+3vxZL4CVSUeg7hykMsm5qMYbwXJKoDHktN9me?=
 =?us-ascii?Q?AFxHzqBMGRLlEVRHdA04ePE2st4V37MGIGuH96Q/AR5DetuikUeuvm9H2h+E?=
 =?us-ascii?Q?LHBp29bgrhX40Td1URYVJjycLpKLm4ot/qqbKjPsSflacrQKwzJ8FxcpQeuR?=
 =?us-ascii?Q?CLlOUwo9gd5tu2ggvhEvWsuOnpt8YWFHzc4Qk7nDnePmZxa4ZXmRth1efge+?=
 =?us-ascii?Q?sj0zquUB9lP1ldPFGP2askkfxvYQ7DpeJ/64ikI3DRLbhbDuE9RUFceHlP40?=
 =?us-ascii?Q?IV9x7vgh3j5ZglP8t3r2GyyV0dANr7i9K25SARPzDIjmzw0Ni+RzLLq+fvKn?=
 =?us-ascii?Q?evXlSoKiH+XQSSWLhYCqoMEHGgQB5xG4pP51v3ynhf5TDIKz5RmLTdBhqq8a?=
 =?us-ascii?Q?d3beah3Nr5Fx0UvvQ1jaZtNpg76LxOOeSuBK2fSEmkiZllUxoqQNIRNg6AW+?=
 =?us-ascii?Q?GrXZLPhsTpuqlDbNDidDSQgbNzc+pjoYw+3xdnNOmHQvvHEVuTJoZ9lvd5a6?=
 =?us-ascii?Q?gxO2BxOn7gD2Iby9UFk5jjopuNhbYn37b32wAoNaGOlV0TqwiQ2BCpKzipK/?=
 =?us-ascii?Q?QlEWz+y3/xSdEJLJl3J9DLeOPwyqXr88Zk78ip0j3kkVT0zEYXaWfVV413yy?=
 =?us-ascii?Q?fgILeSJt/8Ks2ABLB5mVB2dcuLyU3jrpxtL5IhfF2ROwuGUj75gJnR7VlKcc?=
 =?us-ascii?Q?/aP1kx35K2pwAzeMPgOwuGbjYekVO85uxAW0952o2tb5pNIsIdaCl7qPX+pt?=
 =?us-ascii?Q?CIYxlieOojj2VXGH4oNOYLB1SunJ+2gZW3n2c9As400nSHg8lnwh4urpS8s6?=
 =?us-ascii?Q?e4eeikfpTWW8dEa1qNnXV4IEIMPOw3WjQaqtcjKmqp1T3yZf6VdFtJAbNrqx?=
 =?us-ascii?Q?E8CvZNOZc/EmdBWBFSUibhGMr52tid0LmsmHeWZX+nLUUnA4cuHXhwVnIMbO?=
 =?us-ascii?Q?wRnuZG2HLE0+1bQiFuHkgQwAEEgItsW+QYYrH9bgb1oLu/jxsyBRrZdq5Nn5?=
 =?us-ascii?Q?oHw/sWClyGbOe4ECaAPjU8jopcQUMNC535Ll2hSycZjYDSGWLNPikZCKc0fN?=
 =?us-ascii?Q?vQbptSLCS+Yb3oCo5TRpCqdb7MtTZyT+SWaGaP2b+o9M3+oRLz/XYrTxMp2B?=
 =?us-ascii?Q?lDm1bjDATyf+lXFAzMY42zY3hxYfxkPpE7B/R7S4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7V6LDN/B2RGjdEjpG1i4dZZYcsZg7S19Jx77tCogrRX/DFgbx1JBZB+UTRA5G1tqKdSadgoTJHRL9tQZzNmOUw8yFSgJjq+FtJvU04fVJ2tE4FprDNlw9kJwCkAg9EEcFq2lw+LOmYJUBzfdTYNxhTLSKpqwZapHboUqV4MnfdN0pafW3mf3+FdF5p5zXScfXvjwmmrSZ/AqTL3PhvYD/nGQZz0F5l6hkK+ECemJ3F7eOX6wOAy/fLbLkN0KmmNTbtiGjX5k00lDV7/ak0T6Ik2+niwrVOfndIvcZX4pd4iE36D1ccLBZjfhCwnvQ9Cnbiac2yEYdxlkK+XpnzIiB5ocCxk3edD5r8BajVABdFfaSoAfBqtdl4sNQX74f25tvyI8vD7UZQSTBkxYy8HW3V+cHMMYp7uYvr38YfJNkhcGZZFxocjaOezXTg+AVcQa9cT7qydXu6SsomDhCcOiOC2GeMCcBj9m2dZMr8XJH1o2MdDhcgNj7HnXpP6iuO86KnuEs+y2o+ZMJyEwmc8H24NGj51CtnId7kaLAgl9Tnq43o1ZA+xz3utWN3iJ5Av6F3FQKCrwYUR+cqvTiDYdAbJUl12HJmtBm28uzvlaVM4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28aa8612-bcf1-44ad-51e3-08de213846aa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 15:37:52.2336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GZRFnDr+zQlj5Y+4HY7XImcuqBh4kVmlXFv2vf0cBbCztd43XmZL2tbpcZOiAtbtqfbl8Ww44zdMAwcmodxbGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFCCF14A5A1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_02,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511110126
X-Proofpoint-GUID: et8i-EtYYpVwwmJzeI5qRhllzqDT6vbu
X-Authority-Analysis: v=2.4 cv=I4Rohdgg c=1 sm=1 tr=0 ts=69135855 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8
 a=xiuc-KPsT2FZWwXFHekA:9 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf
 awl=host:13634
X-Proofpoint-ORIG-GUID: et8i-EtYYpVwwmJzeI5qRhllzqDT6vbu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDEyNSBTYWx0ZWRfXxveWCN0+imMo
 MyXy52+FDLMJvb9+J6PPdaggOQmhfF1Z+ec2+klfxJJDiLoqTGipVLosXpoYof+Jm9OjneHrOyR
 64SSmD3JRkl4e06ZhYzyqy+pkevojnjzJfsPuM+AlpjPy/mJhdg8lqeh3hnqeqQuolEjBPUtvni
 NJafXHU/CU8vhdnV8AzFUYAVEWgG4nH8YuayPoZbNuxnsMV0VdQ5kxafoCGeOlizOlbdQBYbBNX
 iH95NG4qT5C5Gj17n1tiCghzUKg3rxjiFtIBX50hIazPamfVACL1RxyQhGDHHZlnBGMxPmnNhLc
 6SaYjYdSkqkAXj4iywF4yoOM7rRohGHugs/uXeo4TU1LPcwgm8n82ZCkCO1ARCz51ssoaI1NWIc
 6UiSJINUyrPIO6lkUyp9S6AW7GPx/b0/+M13mDMDXI/GK7d+cOo=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 88C03C000B
X-Stat-Signature: fczqstg8xyjnrpuf4rg1dif8yqdxdjwi
X-Rspam-User: 
X-HE-Tag: 1762875482-15936
X-HE-Meta: U2FsdGVkX18XZvTblkvpXDMKFjYlBEMamhdz1ndVA5S/WXp2ONtVO0zwczGzAwNAYo8afAwPIShhz+dWNfurpu8zy+sciDng8E8s/i3THd6dm3gkEOU58TbQpJQa9XW75AcB0L67NpyZNo484t3P1Mue6hCffWakwyhME+CXzYaCiT3Am5wBLCk30W6du8Zw4eJMF3q/7h+lDgXT+TXMYHmx8AHKs926PEaeW0bWQUHjnsNMmtjt+VgQzuwEdkWQJs3BBvB88RmBAIba6EE6sEHd8W3D1m+RfYKaoMzz8KJ9P0p0J1PRxSDUMRhi+FJKucl5YsFjQ5ea8SWY8Em07CGTss5tChvO3FzojFX9xPGSg92FA0At9bYma/OzR5T9dxiGDUSM6ElP7EsyC2RXoqdeCf2jQWQapmnJucVolrLQy8/qxeT6COpsoi6j1Z1PLU8wmd3dmQgbqHR9JQMze5PhVW/MUlebtDMkatpYRsHPx/WNyaph+bX5p9/ptov8Q7NG1wubm5EYkBN6Jo5MrFvpulpJ0nUYuEN3vQIv7Qo6Sw1IVsmqqazavuT8swZFHxrWSqh2exsNT9+kEJ/NO59UHRGx3217dUhi2jBQZo0vF3AvYQ/ocTjfBsF02E4Az7SUgzk1XXIB6AaqYIR6HmZNjiXYCVaPbSrd7p9HAPty2psOEFSE6UF1hOGS2TaElUDi0++vc+IDoxA5C+g1byB34TDueT5+fb/mPgp7DeerCfTGNhyQZgekpFO1+YSpydYA4nG4+xZ9yyUIG+Hw00bDmXioj0Mlo8ok6I9QrUVu1iAvCzUBqXZs5T2s626LmlpXId31WDdJb1EFy5FJ2aHFhMaB5Els4TyhR7zCgMGklgHs/qBKMJuXSvW9jVi96H6FV9VuC7ElPLFuvlt9UDXRT5bWiHr2T3T7D6OZG9k8cLRbJ5IlsOltAiurqivkqYk66e2w8TSszwDDprQ
 vLZK4Siz
 JVNI38ajN6cFH16KxHY1intm3pHSZdvnexT+UToONzsdAdaAlsJY1KjrdIzM1jVSp0i8e4FqFcXi0qoqt9G0vrpyYBFTn+j31oNHZD9e387Kw7lOWdlfQC4GVvjBSHhQa4v6zqq+6MLyZVzQkz0JYVZ49h/mJQUblOZBUHb3/RD6LA3dmwdA/s4g8Hd8d0uxB6/ua2IDo5TRhOc24EOF4ot166g7IrA2WR+aeET3gIN2eXlYDIo147QCmu0cQr3vp9rDfyJ8VHF80hItFqXMvFxogCylhale3o2szHcjvfMGd0CdSnBbyuEBjxpPLREqURooyjM2b24lWp3t4GauPjkEaMZ48fzOZiY6ZfiYE0KZ5HaxHjbRa9CWw9p2jIMFnE97GfNg5bvMj2dnxw0yYXtXDejLDRtF98LPUFU5oE9wobhwVsHxjUBEUw0T4l+Heb7oMLNwc7fYg1IT3aa1oxiAkVO5vYpQPtsLfuaFP/Y8TX1vlZ7KjvlTCJQ5FrttnCG8TE2avF1DEPs9IytC27t9iYfAPanD1Qh/a6TJql6v4UsmnR/nXcLcSDuXoL6sNNetGKxb5XPlz5u9f7yR7bFN1dZX2vo+ppeojqWVvLlvsdVtWq0WRlItaac2jyk7lFKWy6hnAbw4gOtwJpVS2Nx6B8xkb/X4yS8Fp5skgMWuj50gyLLYIrd2xvBtglnMYk2tO4vLbAziFX2+fVQWtodF1z8bjyX4H0rvZYKx0yr/+rMRUL4VN8IEQjmZ7E84HG0eSXDy1ChcWCGILnDc3l+6Rb5AN+iLCSUPSwmvvW5O/eGU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Harry Yoo <harry.yoo@oracle.com> [251111 07:55]:
> The commit 989b09b73978 ("slab: skip percpu sheaves for remote object
> freeing") introduced the remote_objects array in free_to_pcs_bulk() to
> skip sheaves when objects from a remote node are freed.
> 
> However, the array is flushed only when:
>   1) the array becomes full (++remote_nr >= PCS_BATCH_MAX), or
>   2) slab_free_hook() returns false and size becomes zero.
> 
> When neither of the conditions is met, objects in the array are leaked.
> This resulted in a memory leak [1], where 82 GiB of memory was allocated
> for the maple_node cache.
> 
> Flush the array after successfully freeing objects to sheaves
> in the do_free: path.
> 
> In the meantime, move the snippet if (!size) goto flush_remote; outside
> the while loop for readability. Let's say all objects in the array are
> from a remote node: then we acquire s->cpu_sheaves->lock and try to free
> an object even when size is zero. This doesn't appear to be harmful,
> but isn't really readable.
> 
> Reported-by: Tytus Rogalewski <tytanick@gmail.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220765 [1]
> Closes: https://lore.kernel.org/linux-mm/20251107094809.12e9d705b7bf4815783eb184@linux-foundation.org
> Closes: https://lore.kernel.org/all/aRGDTwbt2EIz2CYn@hyeyoo
> Fixes: 989b09b73978 ("slab: skip percpu sheaves for remote object freeing")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>


Thanks Harry.

Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/slub.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f1a5373eee7b..a787687a0d59 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6332,8 +6332,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  
>  		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
>  			p[i] = p[--size];
> -			if (!size)
> -				goto flush_remote;
>  			continue;
>  		}
>  
> @@ -6348,6 +6346,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		i++;
>  	}
>  
> +	if (!size)
> +		goto flush_remote;
> +
>  next_batch:
>  	if (!local_trylock(&s->cpu_sheaves->lock))
>  		goto fallback;
> @@ -6402,6 +6403,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		goto next_batch;
>  	}
>  
> +	if (remote_nr)
> +		goto flush_remote;
> +
>  	return;
>  
>  no_empty:
> -- 
> 2.43.0
> 

