Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D203C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7646B0115; Thu, 22 Jan 2026 03:35:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B5A6B0117; Thu, 22 Jan 2026 03:35:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743DD6B0118; Thu, 22 Jan 2026 03:35:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62AEA6B0115
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:35:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F9241401D0
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:35:18 +0000 (UTC)
X-FDA: 84358940316.26.9890D94
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 95BD31C0002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:35:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U794ZqcJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=g0sfYPrb;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769070914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+l12CrUT6YUbUBDe3daCr+Tva7a9ZuJVVB35fxVpVEw=;
	b=t410nSzrZ2RSFP6JqZ+yV8DkGWn0kqbpGIEY5dzR6twepf1ASez3YBqfwk46N9LaK6aLVZ
	HN0JHeDUC64LqxzkU5JUYkHQOkWRN2A8ne3qp1/9024CZbDR/A2kcbG95Ol4NuODBKyOxz
	8xs1gb4RwvjO4nmZzYxbenEg97PaqXE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U794ZqcJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=g0sfYPrb;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769070914; a=rsa-sha256;
	cv=pass;
	b=4l3ACPSYGEcwhhuUzdtEs6xqKEg7+zzMNLAvi355ZVx+Ehm6TIujzSEBo+M2nzOOD157Xt
	cIlT4TxiGG9gdQBmqB59Ckn1i+MOShjQOop8msjKCZB4cAelkdP+/aFZFoK/YZwNNBBz/w
	nDpDq7jDbH9GXecnAOl6o3Lj8WeD3I8=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LMVwk83031860;
	Thu, 22 Jan 2026 08:35:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+l12CrUT6YUbUBDe3d
	aCr+Tva7a9ZuJVVB35fxVpVEw=; b=U794ZqcJ/NkIGyhH1b1//lCG91Q1JKf9PY
	PPQrnawBOU2hS03izIjK8BZ3gJ3VJ+m7w3JwpKxDkiyRONdaXKojXawhBNDN5jw2
	+8aAIaHDa13tJc8CjN2ygGkAJrUG4j8rgN1vuEtaRQRLurZuPAO279mSQyVEcGk1
	KvS5yomJB0iJe5CGVQ6NC9M3PfPpE5cDWugsuZPFTe7VANFK21k3CKMRWhgF/BgA
	2RPfcxHcoSm0YEqs/8d6/o6CfUUgNTw8rrcbn/P494ETaA/8JNH3D5ibHEy8iP9z
	bkzgfm1B7AKC2Ws3uBWmaKfeNiT+2CkjxZ1sCj5f+C0hH6/B81Cg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypy87j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 08:35:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60M7VlXl032145;
	Thu, 22 Jan 2026 08:35:05 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010003.outbound.protection.outlook.com [52.101.46.3])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgasqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 08:35:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LGUx+bHLtRwqELuF3hYdlBMlmrCPiJb0RTZQ4flDBuE3EnTk6P4qySgr8YOVHFnkzTrDalfTaK2t//u+e3MZ0bFoV9ZrJcsJIaAOldX5nuvEp/TS8he/EA/rDMbgl4R6XhuQ2w6E8NFoUk0Af1m4Q5fV2Lw/IDL38z2c53Hs+wXKDPFv04s2VWAcQ7CS+ihKniWZeGRoY5pE3+//29TCrowcgsaTjYs/L4+EVG5w70P0UrwtbB4qLBTcPluYOGKG7Qk3+5D7dfy+NF6bDkYljdvuZ6NQaFVwHooAvjeEHbAY/l12r/obXSAApZ5wReCNuWpzVQJeJ6bcIkleUgCsOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+l12CrUT6YUbUBDe3daCr+Tva7a9ZuJVVB35fxVpVEw=;
 b=CtbMddEG39t+ZjB8Nw0T9GTe2Wv/xWWjHn/fFAFIgETPQjN1uS9K7ut57ZUF/cHQ/tJLSSn0b3enCaAeHDPgXOyPYs1vSd+CMye9wHeSLXQIRsBRfE/bigTwaqONMNq0ZpUaysA46TGTB4OqTGkDyWiyuZJu1DPBG8eWjvOWREx0+u45U89IsOrpDWAVbyIuRmYzpogYHl/E6mP060pLA4UGXd/JLq87W+eQ+t1Gh72b5t8TqDdAGxV78PwnZq3rIyolrVpGwQshev/xUdqi6WdBNZBgG3XDhBtKaDcIeuLjfAYI8KhfRFsQvohpMgJr6PpMILF7V+VA/jIzRWVmXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+l12CrUT6YUbUBDe3daCr+Tva7a9ZuJVVB35fxVpVEw=;
 b=g0sfYPrbRk+WFwi9yCicRNbjcJ4PTJoQcYuka83LcsCXoTp+mKX5r6TFKVsrYxdSfSR+dIqqwgQycw1bX0Z2IeA5R0t4rihbAuPbi6s/vRYa7mj+qyR0qW7LmAatZ7IRmFQeSO91sfX9Dv6TN9KECmj2tjYrHE2TrT35JHZUGXk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 08:35:02 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.010; Thu, 22 Jan 2026
 08:35:01 +0000
Date: Thu, 22 Jan 2026 17:34:54 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 14/21] slab: simplify kmalloc_nolock()
Message-ID: <aXHhLtuQMZbquJ2p@hyeyoo>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-14-5595cb000772@suse.cz>
 <aXGC_JRmz3ICjMHW@hyeyoo>
 <3aa8d400-fa6a-48bd-b9f2-3bd6f37e523d@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aa8d400-fa6a-48bd-b9f2-3bd6f37e523d@suse.cz>
X-ClientProxiedBy: SEWP216CA0047.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bd::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB4767:EE_
X-MS-Office365-Filtering-Correlation-Id: c7483e44-4698-4ffa-7f5b-08de59912271
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5zn/EyCv+U48qtt6Xy/2YNzpLYdoDJ2rRVUN6HIP2h8wbku7N/X5jZCD31Se?=
 =?us-ascii?Q?AGDTI9YUInOwPUs2gzZsdXILaBaDlpMK9wakQJ64rgCDZMHu32VdNhYX/O4f?=
 =?us-ascii?Q?krMEbemxhiJSps2L/dIzMiFS+cVKoqwDgLP08soispfbahETA3/Ec4CJ7C/I?=
 =?us-ascii?Q?pocPYQ8Btcg2tdM4X6WePHemXmfFhK7U3CKP/mxgcHYejsJefePyV7gfGbQC?=
 =?us-ascii?Q?u16ogcrvMkMXVDN5v4AxO8DVvjRwavNnOcJiEftIn2yutLRx9vZEYe0RkNeF?=
 =?us-ascii?Q?ZNvdFrzW1A3eSSaTRicl7I1y9RFeemXaYrpJwNpckTdszlB9Q4ZGiEWaiv88?=
 =?us-ascii?Q?I4P+8fXcrzD21YnA2Silve98Hr4HiErlawtDUvJc6WSXiiVRw6r59Mr2ds+r?=
 =?us-ascii?Q?VrytlBY7uoAE5jSz7DzrrABnDCri3XjhrlTPTZfYzzdy5OSojbrDwWLt9APp?=
 =?us-ascii?Q?jc6hIRWw1QvYmq6wZc0nxJqe3ZRccXKBp5uLlC124OmdYVW7TEd9V+U83eB5?=
 =?us-ascii?Q?e6TwODrW/hmlOpjy4EQY7OFW8PqPaGc6BxVnujLLljesrrL7IJ2ko7DUfNe8?=
 =?us-ascii?Q?cCJi3BE8v6sPSnXSBRGVsXVFFAyZdSSSMahwIsauuO81UORPDSw0RC9SlfQy?=
 =?us-ascii?Q?+P8DlLzyWKKAVdWF3kHuo+5udrlc9tb6tSRLTnZT0YIT1kfAxSZwLqPy4Ois?=
 =?us-ascii?Q?xNQgAJAVOssMwssH9Ur9NBnGyxTiVpABof4/L3GC1H2Qos3gvt9PyU+mS9HS?=
 =?us-ascii?Q?IUVp6e9WaCVgHRPfg2tts+vENMmhC/+lafGvvjnl/zNahtW5Gv6TCxowyI5b?=
 =?us-ascii?Q?mL0+1vmhsgR+eY9fCCcsG2s4MjtP5ZZuPskeBduDwRobOqfW1lL5vvk/6XQs?=
 =?us-ascii?Q?mYmomHtfNAT4UYEnEGXLdWQjLmH3AiM3si9sdQG0t5qEwwSNCpqYuGO8FrSM?=
 =?us-ascii?Q?PpiTaYjmOsycJ66mtA9jQ1yR8J2KTYdoZLjtlsPYShLI/XWOJj+P69QzTzTN?=
 =?us-ascii?Q?MAypVrebgh2r+SoYo3gp5OWGIxmSp6gXvMeqHng0oLsGyX6YH4Bkfag33Tr1?=
 =?us-ascii?Q?/jtzt/EkXaZ+VwKrHkcy9yVTnct92r943HKcdD4KHCCOKRc4MKFx8BtNaRFl?=
 =?us-ascii?Q?dhSXIq4T6qiSA+UbOGuTqSbZtZdhzAhXTIRpXDu5Ay+PM7yfqBrZ3KoK0245?=
 =?us-ascii?Q?BQBb8zKktgdDz2D9E4y3JkBgFD9Zd3dlPYdhtdxA6xqiZ+rrpBmZ9kwBOQ+b?=
 =?us-ascii?Q?VXn7JtjIsxYTRtRT/EdeWZpuGGv6UFYneDbMKAr+mz0qWB5+sRYTnDyIyERA?=
 =?us-ascii?Q?K813fFjdY6z0IXz4p4D5F4ukJ/a7u7vnip7YuJbti/e+yyVsMbGDcnjTLO+Y?=
 =?us-ascii?Q?5pgIFqRteKZsoTqn4qRvW9QvfLmz6TV6Fz+G3NgcrmHl1VxKSW66/kOGBcib?=
 =?us-ascii?Q?scYStzL0thTW6Y7d26QpnfLAzA+VOUmY2bPBDixAwxYjB61pwBM8wfGrktlw?=
 =?us-ascii?Q?X2cg3O4JpuIwAcw3ySdFOYQLFuOjXBGIHITgq+2fKu+IrvIpNMJx2Igwx5ct?=
 =?us-ascii?Q?MYc3YtAxcOYyxe9WBhQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9zemOPkpNhXIP57X6FouoTymaOz23FXg9H9lkCtS4/NcpIHu7wpLehVIJEI6?=
 =?us-ascii?Q?XnovCS64Zjw5bAWHPQ/9S42dqca3fGU7MTgeEaTJuovI60oyeZjxNYEeGy60?=
 =?us-ascii?Q?KaNT1byiTOIhHloOg8KEZe3aFadLpKbGn6rJ7l0/6BQXPmI7cQJXqpdaHK7s?=
 =?us-ascii?Q?jKm7UpF+ZO5mO6a81BMugeKJsqC3WwrX3wNTzhQ4PhTciSDfJVpQPJKV8AbB?=
 =?us-ascii?Q?wjcsBwCzagyA6fpvQ6lt/ldKck2JnCndyAiWm+0c7m7kUi82y7c99iVJd0Lh?=
 =?us-ascii?Q?17PnqQV8cafFT7nAaXVRTtvCvAbnM4J6S1Aqh01MC6oaDeLMBUDYoG/KxNNj?=
 =?us-ascii?Q?Al/dRw/meZ67a44W/dh6hM0pCGGesmljngKcYWQE9R8IWrAg13YXpf8pD5ZN?=
 =?us-ascii?Q?lR2OXK4ZwUIgqViw6F8Y8/Mn+5ZB7aY1cEjF4ZeXx752cz5l0wWtzCwwJcyG?=
 =?us-ascii?Q?Kv2X0D4Dl/4lQm3Aw4G5MCM/UNQ2aJp2fIhEZYo7tUqv42Nhu0Kqv5eMvsth?=
 =?us-ascii?Q?BoHkWNOlJjooQj4r4gxOFoTd329LL690giJN/SMzNkScb0yRD1ueTVoEuUTQ?=
 =?us-ascii?Q?OxuL0i+NiW+dAlSjbuIZUP12fyeM68Mavxtq4JIoZuEE7XMEOjJUTahHNmcz?=
 =?us-ascii?Q?x5swxt/59CDBPPiyjBHCylBoUk0C3rnetK7D7N2UzE6ZQ21ZDg3ax7plUY2k?=
 =?us-ascii?Q?NSg0e9kxpgmVwI2lfwaf207ztFPz4aM6cJxf4cKV5XXHgXYSQqLxOrARlmyt?=
 =?us-ascii?Q?+C2ZVE0Gi87fTmtWdhdjM1tO0+IZrwjjADL1JD8m4/vICXh2aKQqwOGnr91G?=
 =?us-ascii?Q?HYzBPQBw98ixS02xswFTgFieXoo3cmPueT4ZTTuHHnnv3BSBlMWcanchEc1Y?=
 =?us-ascii?Q?TUew6cAyDbkiR3AneIdpir+USf58YnpkWt8hkevZ75VKS0KH4s8QxUkrERpf?=
 =?us-ascii?Q?h8lZcW+xY33Js7mF38RryDM9S8o/IvCnR1aZJKIAjz3bfgpC0RGFq6qDDbN8?=
 =?us-ascii?Q?S4Z5z/oigpjV57mzYMTxtR+FEbaXjaQ+/2BjnzKXxYpKiIv1GP4qO9U8x90s?=
 =?us-ascii?Q?Bz7H9UJhCh2nPpa6DOG+U7RasAikwKRcrIjmU6VIIHt/6M0G4CpvH51BiusA?=
 =?us-ascii?Q?b+1RQM6vMGipqsUFton6W83y446/0dsHzx/tI+VdI8csUOUV7ZivBtVV6VIc?=
 =?us-ascii?Q?9zdCndVku2clCpH0673Tk5HfbY90eKsd0jWSSq7AnEA8UXlL75LXI6kseIWG?=
 =?us-ascii?Q?thtiOoQ4Ant5gQmojQ48YOariqUoaiVrLFTBlEuhSAmLlkyszkMCbRRjRSjC?=
 =?us-ascii?Q?A6vCnUWSli5OZ89PWUOTCivJ3Q+yaOgiNx24ttp/DiZTAnCGgL4I91CRN0UD?=
 =?us-ascii?Q?sAjQ4w9hbtirrj9VQfzY9yddMsCJJlXT+xEP521SubbwouerM+hw/5YhmYOl?=
 =?us-ascii?Q?5lhSKnSg1soYRKzpqhk4HjjZF5VeEAvnnPYijSQfsd6Q2XJZyUafnjw0MI6J?=
 =?us-ascii?Q?w3WMrAOLC/nJW/H5k10I/Zjr6RbFhx/tWIr0Wvourqht9alltTVMIZJlJwNR?=
 =?us-ascii?Q?v76BC9W6sVLqEd7IkSUh+YMC8OceuH/Q/0PPsENRjZCpIYSXN4Z/U8KPvIAB?=
 =?us-ascii?Q?H0pkK50WTaD+Mpn2MdsZCFlGF6UkokPpi542KtAkBjnI73ot5FDnSIQqSpUx?=
 =?us-ascii?Q?F0H+v+tYTqKi8+742gvi2t/Nw8qyFAQSNMG4kfZfZUJ7QqZgk84fHk6WaZzL?=
 =?us-ascii?Q?GsyKj49M9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ksr1wpBXViAxsREOVyb0A72tutnsP85NY2ZjjeixpV04qgVvj+7NFyDu19ykcv6xE6Oden6pldC5dNg6W4AIisIZ4WxjvaruH4s05OI9Du7NJqAYRbE2iuZuHsQgEuEJ6FJ4QB4oc0zQn4e0bztseEmUNhQk7X1IAf794l3WIU19dYqZ1sO+0WskATHC7h7DSuwuDVfcvhU3GBy2CaPCJngAO00hK/X3jg17iWUJyOrpsqbNAoll4LmGwNHBL/+0MmW2/Dapq1IqOG2lIfpx0usGvmB8QgK9rLYaH/uG/dtRnUghek0gjqd/l02ZlJ/Mp/w1lvlN9OKi7kGEMWtYgCYJerg+21dfCHVOHUATNEOf17WDqqKt6FFAYmoJkM1ntqG/4YPA0N9VTKOKC2rzdsn7xEknhxfNCdNq+cgaaRDBbqPJnBEKIKzBSvdao5QcahUgodVS78/P+9AUjUwUDUqfRbR37EXm8LTTNyzlTYc4ybMLQKSK1PADEd6fABuzvCY6Es2EJw3DyzNHXhirQAqVODx4lLH7EWcEdGNR+qPjVNqWaQEQAyJwGVu5CakkBiKG87Az36o+L20Jx75EvuPc8LMC4nmOrIxw4WVkOW8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7483e44-4698-4ffa-7f5b-08de59912271
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 08:35:01.7469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HUG4hQcW6dGUKFnGkKNFXo17Nj6nLbcvk3bHY8YGFJCb5KFYreiIILmGhpZwBQ+TUaIT9qYsAeEWpN/5izOiUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_04,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=771 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220057
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA1NiBTYWx0ZWRfX3XgJ9+tKZyEc
 yAB24itrVRgL0t6XSr9924gvWOcevftPd46tknrvTiB90H3TbHceWjcE6I0ZEufS9Bahpi5uQHZ
 pCp89I71/Y/SDwOFTLPIrcF1PDfNSqwnAevcs8p8xRBRiXGT22vCXbF5jcbSSTZJrzyvVVjx+fG
 zhNHpRrDhFz+w1Y2ntHFt5O85mQso9Bh4VF1Ez8Xh6RmFFgQVlzaLckcBlfXssfECKhbLCpUPKq
 VTc6yDxR+XoMRqEeaFbY9L03c2/7TSEN2liiD/+cSm7pPiYsN0KfntCgbb18qmhWjg5NSBdaRcQ
 DWKxvm328UyN7EL/eV49Si/QSinxeuSe+77R7Cn6pxOWqE8quSeiBgZNRUcg3+SdPCZUiVqlGHs
 6kmcRkI2Ii6STBa7oKhM0A9fGhBFONiramu9F08J08PrZ1QAljw3xlFbw0IEsL/kMFrWZAvYzXj
 lFmYUDlk8/x3e2AS9HmTy7yW+jHb6iW5Uv0WsDoA=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=6971e13a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=e7c8kmyVcqSGSyQomPQA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13644
X-Proofpoint-ORIG-GUID: D_nnCAO7i4wRKCtf4v7d0l0mGWljaWtH
X-Proofpoint-GUID: D_nnCAO7i4wRKCtf4v7d0l0mGWljaWtH
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 95BD31C0002
X-Stat-Signature: k3yepqfhrafo8yf3whehf8jdc49gmzrq
X-Rspam-User: 
X-HE-Tag: 1769070914-695359
X-HE-Meta: U2FsdGVkX18/Y1LnOEQZ9EP7hSGNw8sDyc9KqKAAZZzsITdRuAUQVeyR1WprNw+71p5oLqzLe8Y/QqLUTf84Pu3QWrHmMfFIyE3v8qL5XTiaxxOxTNfG3Vfjj2yzkF6k/+ZHVHzhUohXwPh7WA5QEQAvs0yPXHlolInZPFedbHtrAH+CNmtMJTbaR45YPRxXFXMu8miLqJdOxwpPID7q6pNBnnK/zyVpoiJzbe4on8bYbepnFYxPDgh8hNr6XwZ0bfPuQv3EOxKMCIuTJCTXXzBwjSz/8Ub/6oOInEFYqCyqPetI1//7z+4ClhldzkmJW2LM1FTgIRrQWMA/nZURRRpsYPNGNdqMiE7ehXYQ4iIz8n8kP16QynQyF9kwnHxVittZ2lFDOCf7mbCNMDwF7t8VXlYJ/DtF21siJLDSu2tsLdgeUdFiBXJK7nmJkhAg6BMaUFPcvS3klkDzZgXVkiAOxNZ4spphn+2QmeM2u6Sz+qux5iwFL6XMqhmeWAWylG+d676Dhr7cn3vkfgVa8HPqa40uettac2otkjwzH56flczK+VJ2e2vQkUvRQbXs1V7yEyGd4tlYU36x5U+ZN6ASkw+uuieCohjRTENsT74tUgSR2p8S3P+zlEK7HTjY56VfIaVpoQSpMKhkmXTBHtoDbH5PSndz9sGGIxxlb14KJpT0Rt0vPqH2iexmC6pXH1HS2N2KDMtiuQLI0/BCFwzRl6oU85a9HZy56TFf38xxjLt7AGZ1ttQOzQfjV3VXK8FWoinz4EL2p/ZH6QQzt8QTB5vtEYUeJQkQw2kqe9LURsCtCTV8qKDBvo5Zt9a5PhoYUJeFCPFbDmETkNYFPjzu0H5tZQ/i23peWJkxvQZl+95puphx9a7+MmaOk+STXEIeJ3l8K3Oh2zJBxt2ejwqe5oB2ZHnUzTSdRoEHZ16d180CAYaV+xqR1Xmz/4K5oEAadi5W4K1731tCGom
 y0s0r7Oz
 Irx258lTnYF/WIA62OFnv1i/L9HFiwqCBolhRT+ymFOHqBbAJySrAe4bvduhwIylYpjtH97O+Wkd8+aA9XoRkHCBQWtnZjB5dRt0oJ7YByA0xsgcxAZxSt46icm45vy1pEyXD86hAwmq/X+Rj4+p0XZ4Wcx0VgxZm7Tc94twSJODVx8382fGJDJY3NnA9prOZC5k4zILW2LJ6S9O6f9hcOJJL2PGjyAZEe46/Zdvzh/YIbEhj0712WMseVWZZdQRTHIWarRnTDPPt+zmdzU3n0K6jynhIdFM5naAkug3NzFl2U5cghin6pHyJvakvvb9alBa1Zy1xocqrRotNyw5j0wvWI+DEAZqhyru/xYfo68T4AcTzbYdwiR/bpj4Y2XbtazO0ukhyeRMM9USTliLyVQg7rotHPaW/bgBuhd2QlbLppzKgS5TyyuFZFuF8Pifn+RUg7ZNoDTHuPgpi4TavO415wJRuqVK11gOt7ke+mRB+EP8Ecajppm56AuDolgcxu2MEYHsB2mAAZ+kw5sF1opH0O10kiA0ao2eDOBZbedmibU46JkVazEqyn34QqmJ4TPYgRDo2leRsdwcn9AdI6mZAcmNUzn4c2xvDIpx1TKPFfpRNu1cr/H78AzdPGE04bdanCBcplEcL38Wvsy3A55ngoPRJtNu02Sip9qcSmqG0rNuTQckRHa187yCXNz0l6s2LZBXPqBI8B5M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 09:16:04AM +0100, Vlastimil Babka wrote:
> On 1/22/26 02:53, Harry Yoo wrote:
> > On Fri, Jan 16, 2026 at 03:40:34PM +0100, Vlastimil Babka wrote:
> >>  	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
> >>  		/*
> >>  		 * kmalloc_nolock() is not supported on architectures that
> >> -		 * don't implement cmpxchg16b, but debug caches don't use
> >> -		 * per-cpu slab and per-cpu partial slabs. They rely on
> >> -		 * kmem_cache_node->list_lock, so kmalloc_nolock() can
> >> -		 * attempt to allocate from debug caches by
> >> +		 * don't implement cmpxchg16b and thus need slab_lock()
> >> +		 * which could be preempted by a nmi.
> > 
> > nit: I think now this limitation can be removed because the only slab
> > lock used in the allocation path is get_partial_node() ->
> > __slab_update_freelist(), but it is always used under n->list_lock.
> > 
> > Being preempted by a NMI while holding the slab lock is fine because
> > NMI context should fail to acquire n->list_lock and bail out.
> 
> Hmm but somebody might be freeing with __slab_free() without taking the
> n->list_lock (slab is on partial list and expected to remain there after the
> free), then there's a NMI and the allocation can take n->list_lock fine?

Oops, you're right. Never mind.
Concurrency is tricky :)

-- 
Cheers,
Harry / Hyeonggon

