Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7591FC4452D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 13:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCFFC6B0089; Wed, 21 Jan 2026 08:17:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4456B008A; Wed, 21 Jan 2026 08:17:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B51AB6B008C; Wed, 21 Jan 2026 08:17:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A223B6B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:17:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5849413A037
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:17:07 +0000 (UTC)
X-FDA: 84356021694.28.202ECCA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id DEFE84000C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:17:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fe1Yil35;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ihDhLKbj;
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769001424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NqQox3H6SikYN3j+qIEUPyQRVHOTfV3wm37dl3p9LTY=;
	b=LyWgN30ymeFQQ2BzSzMnoVdivu7+FAp22BTxr1f3jmTiO5dvGbM1MOwam2OVwbkOhRfJNK
	j1a5glyN1H5fdbWQ0TPJpmn94vIBe9dqv1R/6tTh/w7s6Qmg2WFAbUyCqRSyS6V1fg2PYD
	XK/KW+nCYelRV943252yVyhihU5TMNc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fe1Yil35;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ihDhLKbj;
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769001424; a=rsa-sha256;
	cv=pass;
	b=G58voMcLJQMpTwtkDwALXoOJDmYNnHPqEFmVJOo/Wliu8BeX0BNjx8saroB1iv577PnP0N
	btZdCZJyi8hFRNY0HTV3YAA6pbTMtLtRPffbyFLHtK9/sO5X5rHs7QCrNNy5ojjMCVvfDt
	uli5UKVYvsS7YJi1AKd8Six3cJLTKKM=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60L4WFkF3265007;
	Wed, 21 Jan 2026 13:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=NqQox3H6SikYN3j+
	qIEUPyQRVHOTfV3wm37dl3p9LTY=; b=fe1Yil35XZvihKos25IFMyzrVIWTos/z
	X7DAfrOXoZ3F5aI7CGF5+4mvt+/B1Z2hKZkVIDDN58yDmIpBu6Om7y1yNgQaokX2
	a8JAGS1ATtqFqY39e5y2ukd0WlDXzdAgi9y1xh4SKJp4oh5VueCsoHcQPmcv283T
	FSKXIzLrDmrKckQLEdE+X3DVP/IlCyHncLDGT+XztGgAmNR+g6FZf/eTzcTtf8l0
	Dl8fkDf2xHsMVWEt0WIJEIXlO6UzY2xRphx6nXSI92H1fWol5xGwYU0Lmf2E6CoZ
	cle2DSypf5/ZeSaaqUB0b1YgVx8fnuZu7/M5+MrsMLdGb/HSr5oiig==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8duma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 13:16:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LCrahj008437;
	Wed, 21 Jan 2026 13:16:50 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011059.outbound.protection.outlook.com [52.101.62.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vb8dwq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 13:16:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KmrGKd21aeas2AWfvD4ApE8b9QZ2lT7iLFbWgxBp6OnVLs9OiWq7lwFCGV6yaFB1uRMsOwKDKaIKclM81NeWBNJlACKQ9X6oo5uLjgQKta/wse1/7byPXJBGD/qZHRdPgCO8/UkoQYNRttQYltfhmVJusMN7nZtD1WJpypiHPNhuXRBqZDNBmzqbkIekgyqtA3BqtMxZGVuFtNSqS9AKQvjKnquidNm5pIZv+NJQzP8GXWS7ztbWgK8UpEFoYGCtVrMiSQ4KKfdeF2UkOQHzwOmzKBP4rySl4J6WfB3+P5PTdpb/hXw8hpY3/bs023yoIkjzK12Hs2MzqLF6INgsog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NqQox3H6SikYN3j+qIEUPyQRVHOTfV3wm37dl3p9LTY=;
 b=UvH0kpLONlUoQUgZuFWIwJBcQgrOsxfKUJWGzpc3fcx/AE8oLs1PGCNyPKBrBj5Qy8bWtFencK+TpmMGx+iU2JvVOJWQj6PU+kjaL3bT3jOm02c6pXBniucwFQ7qjtuTzsvDB/ZsPGMyFjtDfJz72NVFLeTgy0x8M6NZJ7NG8l6yxnu+OjUkeGVsdTjMCpqMzEP5JBLWsGdr0lJNbPtNmQ2y7wC3++3F41UPSx2NEJZV6/+7rRFfMJhVlelYDj9H4dU8qC/bOFVcEwerZbs6gOtovOSiKBAm8rOwe/npd9zBlZr11bjSDInteRJnV0uofwXwgtL6WrRuDzRA5tU0hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NqQox3H6SikYN3j+qIEUPyQRVHOTfV3wm37dl3p9LTY=;
 b=ihDhLKbj+M1pU1j/CTTZxfnnnK1gJSM9mQcN/oGNgKFj8euSU426nfAmWqYr7Cydv9zVFlnOuJ8XDzJVgVVA7jFgtmfmZw4xymvj5UJYh7ayJoXON0YJAJGVCDVbT3QwuFdDslxkzX2o1rl//73YEj+xoCTBTaWkmMNV7ww6+z8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA3PR10MB7071.namprd10.prod.outlook.com (2603:10b6:806:319::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 13:16:46 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 13:16:46 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: cl@gentwo.org, linux-mm@kvack.org, rientjes@google.com, surenb@google.com,
        harry.yoo@oracle.com, hao.li@linux.dev, bigeasy@linutronix.de,
        clrkwllms@kernel.org, rostedt@goodmis.org, paulmck@kernel.org,
        urezki@gmail.com
Subject: [PATCH] mm/slab: fix false lockdep warning in __kfree_rcu_sheaf()
Date: Wed, 21 Jan 2026 22:16:39 +0900
Message-ID: <20260121131639.165960-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0026.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:114::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA3PR10MB7071:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dc6d95f-f758-4127-4cb5-08de58ef53d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TBNWRVpyvmkPxCHmDx41gFAY73Q2M3F7QQqW7wHPpIt+V2H2HqdaTsbTxszp?=
 =?us-ascii?Q?nw+jNQSuz4iTTHl+kuOJqy4gwQxvwZAVQucpygZTtW+RCa91uiu3rDWdH3+g?=
 =?us-ascii?Q?l+BuFGwp/zRe6/hcCayWQu9FYn8ER+2looeKQ+PdP26z6bWjqEkpTm8+C+sX?=
 =?us-ascii?Q?ICZ9jxAll96M4GVxlLytDG/mSfsQQXYXgpkZ49XblVl8fZe0eAG/e/+FehOO?=
 =?us-ascii?Q?3LU/ZXbPjSZy+6i19jWE7sDg7nMDiKBs+mJTcmzpsmtGHHS17iRO8ocWi5ir?=
 =?us-ascii?Q?lOfXJNHCE94Ms7tkmqLrsc4jYLPOoaXGGt/lq+poiUSD6a3X7BIY8Lh78+fk?=
 =?us-ascii?Q?PQgZv44IrJwWPgKHT4CgGdvJizzWjAG+CSBmTNLSHPSTwlhAceuE+WUP5C79?=
 =?us-ascii?Q?egu4mHn3YPEULeP4ylP1r1+Xb8cnjY0m87pAYaQYGXsgpz1RfuShSMYlm0D8?=
 =?us-ascii?Q?p4ETv3G4K8Zwtjz8k/TEhKtlRrXRV7Iy+hy5grzGUOuM6kFqLM3R3C0j27uh?=
 =?us-ascii?Q?+3qIIiRpDMQ6FP7XV5JUTXb3ZIXrCS3id0oXghDjTUVCp1bF+f83xHu/EUEm?=
 =?us-ascii?Q?3JVA3X8EGvuQ9C9BETRep5eE9Z8UnUV24XDb2mrr09KLp8FS09ZdQPS7Z7tM?=
 =?us-ascii?Q?XWODTg3sOS5PrM4xt0NEAf5h5uFZqrixiOD3Jl3oiT5qnUUvNxjjaJFBvfrY?=
 =?us-ascii?Q?/PWwa7zvJ6NdxpStdU6DaNdCrZIhBwzf3F3NtlxmcAvsfYDAn/+NtVmd6V7w?=
 =?us-ascii?Q?v9oHMr+wRsk5Hrh8SaEDjgm5RIhBDPGsED4e0KdCj1dUoqAni9yQPYbX5UK9?=
 =?us-ascii?Q?qYTkQ/AwRnqxjt4xOGynlTOqxOue1tUNKDnhIW6WY4zBlnqV/EUjffLntk0t?=
 =?us-ascii?Q?+sCd9nJa95kQyDnP7Rc4QBj1dfc5N8v84eWoFonxWfItFsFdj4cP6qWZfl+a?=
 =?us-ascii?Q?hQVd09Dc12PG099lXzeuhDnXRlHQho/LXLP+mPwyaTC1L2PBPHFtqBgAJIvl?=
 =?us-ascii?Q?e7IUcFk8AI8SvIRgXol/qi18Nfi+elWpPUGe67bt+8mCTNtEMAMASS7XhCZt?=
 =?us-ascii?Q?KJ7A2fLcaw7Xw/c1yvZJxdo7uf04kpPlD7lSwWRBrKAI1sl1usbc9Sd0hVBM?=
 =?us-ascii?Q?/jCu63B+vakzg193/mF7regmdk5pQ7n+AW1Du2yXK3W2rQQt/lPc/RUR2snM?=
 =?us-ascii?Q?TUKTnKvsq3Ld6axQFeqcuknVcvoI7Jq1rpml3i9gayNQUXvlgKLN6i2K+LWF?=
 =?us-ascii?Q?AusB9l4Yjjl/lMeSjYt2gFqQ84G9igKAM7lieQVe3M6vCQe6wxRx/sU6w0N9?=
 =?us-ascii?Q?vRkPQ0YKZO6qdYElNhLT02HQNcI0YW5IKeyhqpeJ8JdpmFYgpUw3jWo75tlY?=
 =?us-ascii?Q?OTHg9ub7ErFydJNJuu+/eCfXxj8ycXIzWGk/tW25Yjsa7FOZmfPNRun94YXx?=
 =?us-ascii?Q?VwPbpi1m76+0F6EsY+CltkzWjsE6Ev2bVSQbvQFehaTSLexQ302KRw6qK1a2?=
 =?us-ascii?Q?GkMeBSWvi0STlPgspfR8k4/eXbTAJ0heffDg/kY4d8vWIrdVorLJqw8lQQHy?=
 =?us-ascii?Q?DTT0UryGmAiBx+mx/2g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8OKn9rYF5W7LZ/vigx8mbpdTpbT5S/Y2HT76fhZsjjomPhdrmnQXvDzTqZYa?=
 =?us-ascii?Q?QNo5iL1X5K1kgxPJqybqG18DBijktudkplLS8umHQTrWJxDqIOO53zfhptkY?=
 =?us-ascii?Q?hn2aQOON3UEtrcDyk3QOJvdHIsMm/9QNMZ4O0BMHAxW+yWLQ/KQFAcoKImeu?=
 =?us-ascii?Q?6idn0a0mX09zAivbKAcIYL7Zc4HzdYv0sM1KRXS9nn8ZGtbGi1oPBD1ui/CS?=
 =?us-ascii?Q?IV85SI5Ts5Y5FVoQGJV0aEc6V2tH2ubqEO9xsEo0K+n7VDVxpqdfXfPBsfH8?=
 =?us-ascii?Q?WXVCKwuRSrDxohRHhAv+2gBIbbqIuQw13QdUuwy77LmDN4Rg24JdO+7DtUS5?=
 =?us-ascii?Q?zYD8V/Mz1ZQGh8eTaPqpZ8cIPp2CqlvxH6ZTrBmvxTCiGeGB97VaytOXJA7R?=
 =?us-ascii?Q?UEYdWCmUxZiAHLtUiX+AZWc63mXkA0V9z1bquxMWePXu6T7uyuVOO6yj2ltw?=
 =?us-ascii?Q?aNBoLFlbXuEYUOD64LbTJ/HlgFFUNJrnjU7PHS4OrwiP/1AOP/sZJv6LXDkE?=
 =?us-ascii?Q?h/ca2yT1k2t7P8/FcOYg1nkp4PpqqpAT1+Y1sfIBMSg3sjyLSbOpw2i20K9X?=
 =?us-ascii?Q?eX31sbEOCSPsL/Ly3NmKF7SiAToZL1/WpbviSlrvGVIIvQzxnXFCa1rC5oXM?=
 =?us-ascii?Q?Oq2l13bCDwAITqnc2jwcDjdOlcCJkPavjr0tlWBfJLopMQs8CAgbO2N9EOZ4?=
 =?us-ascii?Q?KfhfrXx9nrbpPRzjU7rkE/4bohnV7efEB/Cl2vBicIi/XJruZWZuTQxXG1kk?=
 =?us-ascii?Q?oqSiyI1ujOCvZ8SBI+8tkjasn28B7mhlnvNSD2SDsE6/ewbn0zbTuB7HtEZm?=
 =?us-ascii?Q?c4tVncfbvVHWTpLj1aS67MmksNBer381oZ+evyd7/NBvy4RWp9UH0H5zWOOe?=
 =?us-ascii?Q?zCJ8gk8QmPwkFKk1QzVzJlhzfhZdFii8hM7HnYUCSy7iJIWMZwSTEbUzo3MF?=
 =?us-ascii?Q?9lQCKDJKIT+0nZiMkUX1Ro4fvi8DBu5pKTJRY4/JB60ZPTPliXk1qOsg+Xz0?=
 =?us-ascii?Q?OQer8YMdSHbZdLxYDwJ4sDhHzbfRcCJR6aGqeGFwNfPhXAYpgpEQBrzb78Aq?=
 =?us-ascii?Q?XlI2aBvkiHUpL56nDpQe8zD48Y+KaZOYVKnPNEsp9fd3LnjxZ5FXwYQRCoGg?=
 =?us-ascii?Q?+xPKTTtQeSLXvBZ1YKeIaRXVeuVJYNsLeOtVsPcgXl/qbiKrM9N8IsKW2U1/?=
 =?us-ascii?Q?PDGGfTFWdmXe/uxtUVNN/rcudSSk6yhHUpi4bKAUM8a4ReLFTnCa/nit6rd/?=
 =?us-ascii?Q?OYErvtOff8/OIFcDhQkba4fTuWBYZkDbt8iZ/Cl172HmcuFY+1JwLlUULf2J?=
 =?us-ascii?Q?lB76Z5AD8T8zyTPoa0BjypwcAKgcd0giXo+E0qCKfKBYTVgLPeb0cU7RDm8r?=
 =?us-ascii?Q?AgknVG8HRszXi4PDsLEKWzDg8/gTDiKRASdv/heHysZiQbobWo6xOksHNqR5?=
 =?us-ascii?Q?lWz7VG2leBIg1VHBIgr9vd/vrQtv2hY80mk7EIeogf8b7vWRyxPGAXPYsqIs?=
 =?us-ascii?Q?wnkJG3oTUTtvwJ1bmzUcoWjKK8qv4UGYl5yHcbXQJGtIJshcWHIKF2APp0hT?=
 =?us-ascii?Q?n7bmlusigiNH84DTtdppE1ayenugXj0Vnl6MJw5Kniq2zrOHwF1jMsq2EkVC?=
 =?us-ascii?Q?6Tb9mkMZI8X5nohbeO02QALpuAT1SA4/vjjggxuCp7GGICq8FlccpjZV4ZQl?=
 =?us-ascii?Q?pGZ78rYBaRQY8YnQd5U0NfNiq1/lBB/W4w0mMGtD4cpVyGXQgEqWzAy0VPpE?=
 =?us-ascii?Q?kdv2L6l/qQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7LlNgTYz+7o8gyofWdVyOAAdzU9WkpeWkuQ2cBq+sX1psCugQ59nFyUA4eNN7MfnRho4BSqDqSV/I7jJzIzsXC15iPHqpHcnPgkCHPBJMkvqyl1Pu3+veTPPWwsMjDEHOv4TG2HfzWYi78UuyLQL8ikHp6IJeJ2FMP76qeivK839shMMJ3GKTLi80b+Mw+kE33ucijobdDOaloyaIMD2J+PxMjQXho7Uv3nJmvU1JCUS6R6dEjbW6nzQjgQmjLI+0qXbEOlSv1j3H6QcHIUL02oDYPDEse6mSghhS5y5WJlFhj0rrplLR9ZmCj/Zs5+m70liwGIDidkTkv3QOxwRsOyqOXMP8MiGQY3f54e9afIIeUlPmy/UZZ5PfihOnquwQ64OFZpj/bLMgg71/iE1CWJpdr8SWEeGFCSDeojHI67ZTl2HeCchiXTeOC55rNIhdI2vEppabgjgETxOkYGnqeREnTnwwIzpMP0+HVdBk3BVmj6RVHX//l9pXsOAof8BcoquClvo4mkYHaVEjz0vBP0dVPBA3aoPC+wQ1rgvTfZUUCmIluTjF6BpMvC0zsBnWGiHa5n19PUnsGv+NpiWcSQHTS8ZwpujcZhWfb7OtJs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dc6d95f-f758-4127-4cb5-08de58ef53d1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 13:16:46.2974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wzIFHZgbD3idV55KOKZ+q5dnrQwuInkUgZWz3VoCRw/iu2PHH6hmncZKByI9PgeJ3RdDzVLh966D5qm9rd2a9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7071
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_01,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210111
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=6970d1c2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=ID6ng7r3AAAA:8
 a=yPCof4ZbAAAA:8 a=BXUKr_bdKuABdC24rNsA:9 a=AkheI1RvQwOzcTXhi5f4:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDExMSBTYWx0ZWRfX27E/e/PZ4IRa
 8xpgu1EhSwO5JWcTczw3jldOpgDnx2kIkAsDFpRTARs+A81bro1bLHpIc0sPV5HSpL2i6MFskon
 8GeM6fsMznvaxCDuVEKXlt8YirWMVzu78ztlx0ZyiHPKorDbC6sLaGUIMf/ghRE7fSf52CkA5+Z
 Cjady6kHmLdjixHUcr1FCfEEm8FDBwNn5evg4vdd9uR3mjK83ancXz7gVRaE5gQkh8moaW86ZG6
 8LGyb9dLeu+Fx1EJWkxz7wzHA/TlkCHYil7KB2Z4AzYKSwbyt5B2ZmbcJ+egyb3lHRZxlVECFlg
 L/pOFCBpbM+oz1vleSfXvDI417ADNQv7NVii7pHp0dcmotCMNvfS8XgxL5QJIvcY20NCjP8bn3q
 WUQTsoZ1B4Kg/Tt2W4Zmt28ghkzsVltCZu8BD17kE3Qy7CSUaF2gp8DEcCjNv5zaiXuKB6LxT9S
 PMQyDdZGBvzc0aYuyRg==
X-Proofpoint-ORIG-GUID: XHyRNTIokjNgqXYn0O6nCiA1BMF9BYha
X-Proofpoint-GUID: XHyRNTIokjNgqXYn0O6nCiA1BMF9BYha
X-Rspam-User: 
X-Stat-Signature: iqututppdfaka9mnmqw7oyzqo1whtmph
X-Rspamd-Queue-Id: DEFE84000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1769001423-504228
X-HE-Meta: U2FsdGVkX1+gIgFK0fP0fboxfiEYPZb8cP4upH80gZboRE30YeZy+Hl+NaWdnc1U2caZGl+1fMzTArZGBEwkkLEeou0qTEJyMAyPZp/AYIhLaDWjT+bmf5mLhrgYkUU86wFalXkAWG25e8PNksSvZ3zQQxgV6WpNWVO5o29J6RGGYhNJfCAS0+YIZEh3Zn9nWQzhrfG0zsCn5z6VOZi81Dz+C/fTguqSfcqPc5WfdDQGh4M6AV2Bz6nYRNhJfOokk7fljxr7RvGY3+oPIwzW7BjzOXtWgGYAf4caUUZg2abNO8CzZZ6//QEBz6TSA+S+4Mh/pPZ/ShTRZPgaEh3CeU2iV2YEfr/lDSxImoZnNGMHGeJyL2V0qiP+QVQXcGe54mK7Eu/dKOjr64f8BoN9pgxkBQubbX+0HTtLmuPGpLAao8/C63NAx8ozdG0PPs0z340u+Ufm8nlugPTAw2zM/2O3oMGfJ4r2wmkW08chVQ//jeD5Iiv7hfby8Na+SKPghKyCf633ILcXD9jBzV19sxZ8ECCHgxQavSsFvvPJjfEkBg8GICN488QC5UGwbHkxQFumGggwwvIzb+cnFzIJ9NRigNGNgyUSzyhkYtWFQNkSZiUcWSNO5COnwP34iQfoCsHGPdF4EE0OYl8rc5eOkCrH4iaDfLsEoeYH3lkJo5MAZw+HkRyixk3sid/KGhd/R4sLv40+d/dlNKOffFFCE0GUPhdhrn2q7kIa27FfIuP8IEYHTbiKM/EhxFWXhGMfoQeVltdd4bybRJwnuV8522/wVGAC9ypMmUnoxVO6bzIhMgOM2rYdWzqsftg/213Wy3BkVlnvFgGOPHUOIOPzLN/+BsIk4abYcS8nH1VIFCJvfmifsdSTQsdiE0lj0ya5NA4hfLYSukurCBFwIbWIO0vzihdgm/71gkfnb83UcK7kyWCTPpflc8ksiDIkPtrNe6iNN3KZyVqtoJOCDOy
 8soipLGk
 CaeVdK9+NWTD5KAV3RqtEQskpOQeI8m6pXqtju3zZ9RkWb49U5R+Gjlj/10X4KiKmTk/Mbd06ofAwvptpK1U7lWe4Ju/tn6UEj6Neb9zyMKwQl3qejW5F05UCQFyVwYmGh6b6qSFUA4xHJMJJBfDOow1yeeYwtJv9TMbMbNyb0RvaZJos6zSc751k64bD0fLpKV7p1S6zjtjnE/JaYhhP5Bf6VkWgEqA7gftAqUZs3mdBUz57WOzvtwa/KnJoEatc9cZPHD+HLBSxkMhJPM2q5nDVZozBo8kxCqOzNc+pJnIugKF2KwuRPWblcSvyrRKxewKpf13gA8od7lhSeaLKVFoAAqkc968xAzty2jipYh6fe5wORRprm4mwHPHVVUd/4fmhEx1A0mZqNxchRK6RqGYh7Xn4t77Zk1+tiImVPkE6NDTPU750+PFi0gCdLkp93l/pW/sy6DxW26qbpB84QweqoUs0AaDoENsa1x8yLu5SsCpaiBBv23lswsuUvg5QQXj8X8iMOSFqCjzUYod4ZBzGxuNYt0D56RQ0kVxl0NB10/Lkt3EenpmeK5QRTpMwZ7rqvd3AVHfQGMFClJd2WscnRhIXxYWrSnsecmwnPv1Ud1CA++UxnhSgO1qdMANlYPtSEYc9kPEFn/w5YeF2ntDSkb+CrJ57x91TY3x0UfHJ0kAz9yWr3SwRQOqgLBPflZFiTHnQb8Y367JuLyJBsmo6i8EWg5bBRS2p+jb6aqQwwFo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kvfree_call_rcu() can be called while holding a raw_spinlock_t.
Since __kfree_rcu_sheaf() may acquire a spinlock_t (which becomes a
sleeping lock on PREEMPT_RT) and violate lock nesting rules,
kvfree_call_rcu() bypasses the sheaves layer entirely on PREEMPT_RT.

However, lockdep still complains about acquiring spinlock_t while holding
raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a spinning lock.
This causes a false lockdep warning [1]:

 =============================
 [ BUG: Invalid wait context ]
 6.19.0-rc6-next-20260120 #21508 Not tainted
 -----------------------------
 migration/1/23 is trying to lock:
 ffff8afd01054e98 (&barn->lock){..-.}-{3:3}, at: barn_get_empty_sheaf+0x1d/0xb0
 other info that might help us debug this:
 context-{5:5}
 3 locks held by migration/1/23:
  #0: ffff8afd01fd89a8 (&p->pi_lock){-.-.}-{2:2}, at: __balance_push_cpu_stop+0x3f/0x200
  #1: ffffffff9f15c5c8 (rcu_read_lock){....}-{1:3}, at: cpuset_cpus_allowed_fallback+0x27/0x250
  #2: ffff8afd1f470be0 ((local_lock_t *)&pcs->lock){+.+.}-{3:3}, at: __kfree_rcu_sheaf+0x52/0x3d0
 stack backtrace:
 CPU: 1 UID: 0 PID: 23 Comm: migration/1 Not tainted 6.19.0-rc6-next-20260120 #21508 PREEMPTLAZY
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
 Stopper: __balance_push_cpu_stop+0x0/0x200 <- balance_push+0x118/0x170
 Call Trace:
  <TASK>
  __dump_stack+0x22/0x30
  dump_stack_lvl+0x60/0x80
  dump_stack+0x19/0x24
  __lock_acquire+0xd3a/0x28e0
  ? __lock_acquire+0x5a9/0x28e0
  ? __lock_acquire+0x5a9/0x28e0
  ? barn_get_empty_sheaf+0x1d/0xb0
  lock_acquire+0xc3/0x270
  ? barn_get_empty_sheaf+0x1d/0xb0
  ? __kfree_rcu_sheaf+0x52/0x3d0
  _raw_spin_lock_irqsave+0x47/0x70
  ? barn_get_empty_sheaf+0x1d/0xb0
  barn_get_empty_sheaf+0x1d/0xb0
  ? __kfree_rcu_sheaf+0x52/0x3d0
  __kfree_rcu_sheaf+0x19f/0x3d0
  kvfree_call_rcu+0xaf/0x390
  set_cpus_allowed_force+0xc8/0xf0
  [...]
  </TASK>

This wasn't triggered until sheaves were enabled for all slab caches,
since kfree_rcu() wasn't being called with a raw spinlock held for
caches with sheaves (vma, maple node).

As suggested by Vlastimil Babka, fix this by using a lockdep map with
LD_WAIT_CONFIG wait type to tell lockdep that acquiring spinlock_t is valid
in this case, as those spinlocks won't be used on PREEMPT_RT.

Note that kfree_rcu_sheaf_map should be acquired using _try() variant,
otherwise the acquisition of the lockdep map itself will trigger an invalid
wait context warning.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Closes: https://lore.kernel.org/linux-mm/c858b9af-2510-448b-9ab3-058f7b80dd42@paulmck-laptop [1]
Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---

Locally reproduced the issue and confirmed that the patch resolves it.
No Cc: stable as no one would hit this on -stable.

 mm/slub.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 736ebc12fe70..e63daf45736b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5479,11 +5479,26 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	free_empty_sheaf(s, sheaf);
 }
 
+/*
+ * kvfree_call_rcu() can be called while holding a raw_spinlock_t. Since
+ * __kfree_rcu_sheaf() may acquire a spinlock_t (sleeping lock on PREEMPT_RT),
+ * this would violate lock nesting rules. Therefore, kvfree_call_rcu() avoids
+ * this problem by bypassing the sheaves layer entirely on PREEMPT_RT.
+ *
+ * However, lockdep still complains that it is invalid to acquire spinlock_t
+ * while holding raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a
+ * spinning lock. Tell lockdep that acquiring spinlock_t is valid here
+ * by temporarily raising the wait-type to LD_WAIT_CONFIG.
+ */
+static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
+
 bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *rcu_sheaf;
 
+	lock_map_acquire_try(&kfree_rcu_sheaf_map);
+
 	if (!local_trylock(&s->cpu_sheaves->lock))
 		goto fail;
 
@@ -5566,10 +5581,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	local_unlock(&s->cpu_sheaves->lock);
 
 	stat(s, FREE_RCU_SHEAF);
+	lock_map_release(&kfree_rcu_sheaf_map);
 	return true;
 
 fail:
 	stat(s, FREE_RCU_SHEAF_FAIL);
+	lock_map_release(&kfree_rcu_sheaf_map);
 	return false;
 }
 
-- 
2.43.0


