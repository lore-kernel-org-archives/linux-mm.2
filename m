Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57336C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24856B00C7; Wed, 21 Jan 2026 11:57:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFE376B00C8; Wed, 21 Jan 2026 11:57:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3DD56B00C9; Wed, 21 Jan 2026 11:57:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BF4F6B00C7
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B42B140815
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:34 +0000 (UTC)
X-FDA: 84356577228.04.FA151A8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id D9FBEA0012
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rHdojEX0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JjHb9Ic3;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEIeGa8s8FT4BesebaeHml1I0z9WBgn4siTvKsY8tgo=;
	b=aec2UAb5ZVvPX88QGV0V1mXXdLFPebIWHsqmkhEjMBnASH54d3SGCiY1TKMkeZBbd3gOCs
	H0EILn1ZFDi8jeJ2vrosRZtlQ2xYWOSJgiKPtQwT03XyUaeWu2ddFUqxA6yHhdkocrKpf6
	IN//lBGFAP2yHk5eAY6nqSc0J8HFf+o=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rHdojEX0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JjHb9Ic3;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014651; a=rsa-sha256;
	cv=pass;
	b=d5e0m+ECwASf3T1aWwkP+WQtRklz4ayoTgTq4kRI/aPmn7JQUAptQviiH9WdRiDHYj5RTu
	PqxPuOh1eXTba/fqzRzh9ybe0vnRMs5mLHGn09pJ2rYm6uinuP0NDPRvnWp0C84Bc4bGh0
	BJIb01UGXaAR6dITQOoFAetdR7l4rxk=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LEOGfg3430893;
	Wed, 21 Jan 2026 16:57:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QEIeGa8s8FT4BesebaeHml1I0z9WBgn4siTvKsY8tgo=; b=
	rHdojEX01gjNiQa5H6UlKya2byJwABXn0uF8C9HCMgNK7oymmxCviH6lyB+PCJN/
	cYe7Al9Dm+83BEmTKR88xb2oPLGTV4/XWSUGiQYIj7t4/ZeudUYKjdOOT+4YUXqn
	VFJw5WmNxlCXklEySD9NcdAzd965Vd+8qJO8HvpdJgKlZk00MaBeVmaEQ8D1QTHR
	gRyDUZqyHLse8LrWkFrWcT303OsrWb4pOhSohng9TXzBQ0++RhboDgiicE8lIcU/
	ZfayXrtSTEveWdWj/6dCmVZTnFYC8C1KMSk/0x9z3L2AmDSXocbRZ/xOcSuq7Z0E
	3DYooPIxa42zzoaSHh0Ojw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5p619-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGgNor008362;
	Wed, 21 Jan 2026 16:57:21 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010036.outbound.protection.outlook.com [40.93.198.36])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbht75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QG9QAmnHTE1K3foteGR3cyewr+HVNagRAGnCEUCxNyFFWIQfCDjUbK3R8TCRDBpcxaHKhjcCjjyYnIZ7V9KFIpKcSMXlyYd/eI+JQkuUGbHqPKfyylSOqhrF51pCqbDFSzT8xgcE+OD3nzrrBuGa4xhAy5wdlw36FMCVFxbKVz8uoAhVsFWdC2/fL68BP26uEtsWEVQNHi0y9W2iGI8OdXSImjAA97/F+hYvx8z2NGWgMOQUER7Bk7lnPLouI/L/k3Ur+1YNBN73QqnErLK+L3vFsdl0sNqJzp5jzEyFA7NDD/M9Gd5OdltuX2IjSAww/0a928Y/HLj7pWpHHfiRqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEIeGa8s8FT4BesebaeHml1I0z9WBgn4siTvKsY8tgo=;
 b=jP2RB9FVkw93ZgbvQ18uV86yVel+Vs8K3fuibgpI1DFLzbbGNjG6v57DvCPkwu1EqtBgoLpfaV9T7A5iVnRn9zwZn02npHqPGoncomy6qhgzOverV6MH3yDJEynyksfIu+vlEBaNv8xLssQH9gWztZ1iT3gJMEOtd3gb/Ionvsp1bv0gPRUnA/b+vUp6HSjR53kngj0zii2OfSFOOy3xI6MHZg8xAs6XCxuLOE0i0WJTXSbAH53EhN6/t0Yi95G9f5Fdi6/h11DD79oXvTtx2jjIEuirOv73GaAcDpnixgGvH67Un5y34e318En9Q5wnvik+/dJ0IOMIU0wtwE3Y5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEIeGa8s8FT4BesebaeHml1I0z9WBgn4siTvKsY8tgo=;
 b=JjHb9Ic33MilTwm1hrewgknHRsX2PFY9JfnWCdVZTocNARqY+KJJRPebId0PPIFPhLbmsVAfsGD6fkvc0O9qDjff0dU7s0euii6SEOfMM4otS2u1oLpZ7G0u4ANfUfeuk4duYShiY/bqcdKh1ZEUtfxURYHpAD1OkMk57Q03xmI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:18 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:18 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 16/29] maple_tree: Add gap support, slot and pivot sizes for maple copy
Date: Wed, 21 Jan 2026 11:45:13 -0500
Message-ID: <20260121164526.2093265-17-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0291.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 23158a4a-a3bc-4c7e-9fc6-08de590e22a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A68hMNQ7Dapu24RmpRCZHF1kzzgysVHwyL0bByp1PW02bUEpLbza5yVx+AzW?=
 =?us-ascii?Q?TV7qeVzsCU752zlwxyiNcU66vXVIAhSfktTAgWs+9xlNt4ruSBvhSt2A5Tyu?=
 =?us-ascii?Q?8HwrkWlgKjinV8SqBskw93MUzr8ptGly13uErignzyMCQpnIEfBn/FxJQ0v2?=
 =?us-ascii?Q?waQZCZuuMG2HnJTDsyr+qTFiLt9Y1kfU4bOB2CJuTzGpc0mw9tur1k813xKK?=
 =?us-ascii?Q?PnXoIwls/FNJeTv4PJYED0YjEXUEoxryUAMv7c5hg2vr6e+22Q4H0o3WiNJs?=
 =?us-ascii?Q?/z2Bu/phxQ0fOe1nr02HZ0qhtoV4MPDE17vHfUUpswwXpjVZnJTyeiCdo9tp?=
 =?us-ascii?Q?ci6OuQE3v3aGaH/dhPssxghQVtUEOCcUGRo1CZ/J4hcDcaijpI2SoY3gT4iC?=
 =?us-ascii?Q?oLZQwojTiBTQWoIGkeIY8jxxYVVk2vUhzUtfkwEGbLsYG3Hgt99Gvna1SeMs?=
 =?us-ascii?Q?06pAVzbk8poj+x+gMCertLqfButEpUTBhnX3lqBDUYFk1VDrmaPVjdxaj218?=
 =?us-ascii?Q?W6xRJuf3Ehx6qnxIufNGT2Qfb0wfXf+Nk5vcRoRX/DmmGznuDA9MOsVpJ592?=
 =?us-ascii?Q?xW+wweplpAx7QIrOXj0qLWnB4BjEBA66mMGMUbteYoLVvT9kPO/S+u7PJvJz?=
 =?us-ascii?Q?LiR7rtEhJZ/xdEBIhN9TPkvY6+Q5DSxKoX8Lk2giL+f/reHBrBDeEeVMnGoS?=
 =?us-ascii?Q?g+QRFdSPVSg5Ix/JB2yHV5eujVqDXQEUCQFYpuzdEK6FWKpCsF2frrl4M6kC?=
 =?us-ascii?Q?oraDvfvwAg2xGndeXgrfXsnBd5Lb80IJikja6gpvdF1A8p9aGCFTnp5FtbiZ?=
 =?us-ascii?Q?wg1k9YBVB1CBL5HD4xgRsvxSN/iKFdLPsV5vGH1k1Nc8kCobYt0mx2Q/y+U1?=
 =?us-ascii?Q?iUqTcjVYeO6+ARY6gabKJ3MDh83MtDpXuL0bR5gf/SD7oI/phMLzM5YfW5+m?=
 =?us-ascii?Q?s0Dru3O2uA8Iz+G2ygLHYk3CsnF5l6e6mIakdbI/rTzGzu+afG7ewcbTD5AM?=
 =?us-ascii?Q?FKyMAmNjekVNy8ek14kH1NKPWKxSIzAGj2WE0PL/rE14JFSyuwt8ZKIxSOqS?=
 =?us-ascii?Q?61NLH73mswx7FJbAecu6DFrc9aMNx/kKGxw4A/uQL+lT1nL2Toc01kvkefXq?=
 =?us-ascii?Q?LfQ4glQ82bUmD+aIcTvjdUe8ULVfvIWLwvt7mcAji9AFd+qi/qwnUKy5NLlB?=
 =?us-ascii?Q?fzVhI9CqAwQ44yuDpRNKcpynE1ColdixJOfpYbmClQRsik4HfaXSyvlq0DuL?=
 =?us-ascii?Q?A8BqW6PisxYHOJhdYLR+54NSQArxE7N5a0Y+tDGkppIpxmczgqhtUdrCm3FN?=
 =?us-ascii?Q?4i6yW3yerybOcK9A7poMw9GQhpB1F9ZLyRJJzQzMnk4yr0n3rOCnV4zaPE5r?=
 =?us-ascii?Q?XFZdSXQ1lOwpc7cwBqt+bEDeCnqzIodLGtv8bTXi8LXrBBT/0cDah7rNoO9C?=
 =?us-ascii?Q?YG5w5OzU2CvtaWFjV9TVQsJwC1lH+1/OeBG68A2kKyQDHPVCm5WDdOd04aLC?=
 =?us-ascii?Q?BbdYZU5+jTtlrCLYXUjPawTfbjVmZVnJKY7M6Bjk/wHDQ0PlQ6l6O2RX281q?=
 =?us-ascii?Q?ZRXeu9GZDgUJAS6qGEU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?51gxOjv23r/db2H6sT1o4CAtWUcUfOZcBhNpNnV9OR/ZchTrUAZbMilhlHQ1?=
 =?us-ascii?Q?f59WdFbYzXyvNEe8fr0ycCJ7fTmZeVLcxYa6yJvCeqEbw/jTmVq5G/UFGofr?=
 =?us-ascii?Q?kdAHG30IMNktdlVtCO492To5eX7lHEm17eTU/HXWoxSCs2KmUryWZ4JJbZ7V?=
 =?us-ascii?Q?nOvXUjIh73DBkg/XnPti3d0bdDi4kDg1I3G9JS0wdoPwwRHjgpiU2cfAVrE/?=
 =?us-ascii?Q?k2J8SBwL1Rza2nCyz4NWnEwRrEdFnQoqf43OVFn1gBDzElt8iU6yu76lEG6u?=
 =?us-ascii?Q?nIXbO49Alx4kNE3tkpdGyWxRiMmlsP6/xeyOR2KqsTq1mAWHiuXzrvRgJj0E?=
 =?us-ascii?Q?SF6oWSYJCvxXNK/lEMkaFgqWG2WKXAzccUKv0a3XtA3+4Xj4puxkHg0Ba/b+?=
 =?us-ascii?Q?myI59FkTlo3AdHzRJIH2oeXxiiWl5wfCz5JT196wRpiI6EcFawO5kBaDXtGO?=
 =?us-ascii?Q?A5bmhHO2dpqOmzLPFNdDP/4aWiJs0U5ShC93i5opyeO2BiW3W4K4S5D8SKS2?=
 =?us-ascii?Q?UJ/AQUKULgg+0ss211kTY2ErYfBYx0l9LDkr+wqSCvMoYXo1sVotL3GSJxsI?=
 =?us-ascii?Q?eyagKnMYpqBJR5kIndVnTWCLXTX8sWRviRAPUtXpvifXe+34WHqyOfLcCbfu?=
 =?us-ascii?Q?l/ntahX572upiHbr4SS3LacCRSx+jr10VXvhLXAi9CfbFgu63Bxs/3IUbm7L?=
 =?us-ascii?Q?Z+e2ZPub1ftaPcDPvpq4eC/NiZkSJ6mpmHJRRDKTxBoaCZ5a0DagkwXI/DBp?=
 =?us-ascii?Q?izEnU91Q2es8izzO9cvtS4rXU6JmqdV3FU32oluvBpQcVuLO8t189lDlW9ur?=
 =?us-ascii?Q?YULHVtDVq/W5tt92URkL6kmdCKtS0OPbt8/Qecis0deZX+KpwNPyx/K2Kcmi?=
 =?us-ascii?Q?S3a4wPNkkLWbes2pL8pMn15zrGWZHqU532GaGcIKbLRklQbgmp8hcsOhuQE7?=
 =?us-ascii?Q?kaBZAY2NoDXnfhKjLzJJB7SqNzYwtpjnuyWkS5r01RkZB6Y7YRHW7ectz1Rq?=
 =?us-ascii?Q?UAp46ap2jM9dWOUyAQZptS32/Mx3IroPm4Nu4SXKqf+cB9owFqv0KyUoVEis?=
 =?us-ascii?Q?v/OX+MXTdKl9r0UE21YwsJRY3JllH9g2zlCNpk6kB2mLOmac47nUFr4+5UKl?=
 =?us-ascii?Q?YJv0YNEa1/tFPIPSUdEr59pbwH5lQMdgNU5ZjOLI5wNwB3v4D4G1F+Ab4qgg?=
 =?us-ascii?Q?YsDjBJ6CTnXdbj/5W4LFZWL2uF05kcEZa+py7UTv9M+NR6SeX2Pp1QU5domd?=
 =?us-ascii?Q?Iub7aeBLgvQ1tvATbn4Av6Ny4q/nb1lw65GmRamnq1D7Yt4WKGGFHwSXMf1G?=
 =?us-ascii?Q?dQjOTe71/HBkVpKgHg7vokcRn/CROCDqFgpisNf0S66Z9XabhOhV1WxHbPyA?=
 =?us-ascii?Q?dy3wUpJkbPK4I1iS4dOz+Ym79fcBuGVaxFtx7JMR98kOql9fyBbUsxpYYoMB?=
 =?us-ascii?Q?MiX0ug8TcNTulYTGUAnq/oKFka1us0xwsV+PBd5hwJub12Z1IBZZc90dfkL2?=
 =?us-ascii?Q?vADVWQo3Ynw6uGtxNeI42j8j8ha/Bq1STpvzDYLqgtWYoK73dqhYObCtRMgY?=
 =?us-ascii?Q?8Iak8S/1W3y+KLKQOr5nFgOhdS2CqZ5mLLDFXwTdhp31CfFKFW+Z5KBefjxo?=
 =?us-ascii?Q?47ClzfgnlQqCT17Z9Y1hnjjWaBqOqlHCu/Pg1xRDt7MuCKEhWqcZLiWphA4x?=
 =?us-ascii?Q?c99JLOSqAu71N8kWDSQS1GvHIv7MCRwUO7DHukslawLUMS/YTFelyCt3FMYY?=
 =?us-ascii?Q?JbW8qE9p0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	187HC6w4FL6aHacF7mleDwjsChYd8H9UlbS6UchvYsdbjWAQ0FFDRtPwAzS2xw880ujD7cFaPGYwGTPhAYR84TjQcQsUFhyALwMe1dYiJOIJ1Aqh7mc2wmBfNIQISHKae8nCZm0VBv+VdrZYKkcdmqpq+oLmTXcMh5lMae+0UEOJMSrQ1fa/4a2r+6OlrDidi8m6VZIxo3ZhKsfOP2SbIUDYCEiyzOe0j1wXD7TS/B23fvLVGFQ+TsQ7rwCFhPMPJP1Z6y9x9XqtulgtClTat6NTVWlfNhFtPVPRY8fbRHkMQnx5x17zGFvb0NMvCrq4hBulSbmqyfe9WN6hZsldgJfnLuscOw6/Vv4HKizNmbRlfbtlG25C0e1EEF2iZ/ajO1nSDiZ4hj7Z/yEhh9hrZYORsMfh3vvv+9smPM1dBLqOlLAh3SS7Wjgy+dCt/44RygaRFgo4eHOLBYn3wxT681B1FK0hEHvSgP98tUOij7q/xOvANSWUhHWUxjCD+PURI96rQ4eV5Ag8ZgcebxZGClIjM1EIhkBifvK80dsGV81pmEhH5C7xlfehJlOSSXUYHmO85VRq/iitkAUdPqT81QQNZtuXaUq3cgdryGiMdDY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23158a4a-a3bc-4c7e-9fc6-08de590e22a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:17.9972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dzbnYkoVrhAIHXP3krMPRo19lBxp/vEeiVSKT2zY6q5uPyWOm61APozFEViqg11QSpXsIddW9raXpbK4kHedZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX0ZgMtQIm6Sf1
 hgjnbFzNv/Z5rzw0fZvSENGf6ijtmdjIvsHvF+bgdPen4schORZ5qZV60h2qpHCVkvyVBeMlgdL
 9jbBVfpBqWIrzC7M++R1DVIOrnHQYmhSQJTo2xdgnykSL8OTWePr7GiKv3UkARc0PxBRQutBKCc
 vdSCTHChSvPOw+bcuYzV9KJL0J/ikZkGPVFDIHZyf7H6g5ohNdCxi5Q9qWabBTZVolcsCIB3mFs
 pQceWKqa4SLcz3516K28A73ZBoa56FxyNVlKoNE7R+YnjlwAKA7lWLwjb+ayhqyx/Xy/+jH+Al9
 VkRowGFR3jyhP/j0RXifCihYS68swU3JKs4bGktRtIPXInic9XCh9TQE9I60MnNLOALn2okm2Zw
 2sPGopDS42Vtsp84LuiwVDDkblsMG3yaBIq/zCWzXS1H2C54aQ0oXCzrMClcGNA9pOaFbcJhBiw
 C1sQqkojmJDAKW7hmSg==
X-Proofpoint-GUID: dh6uQEANPikrkfWeWNdm0sx47T22Ko2K
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=69710572 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=WDoy55lLVV0zyn05J78A:9
X-Proofpoint-ORIG-GUID: dh6uQEANPikrkfWeWNdm0sx47T22Ko2K
X-Rspamd-Server: rspam12
X-Stat-Signature: zo8b69tjuirhrd69jzaxy9rrkzcqosfo
X-Rspamd-Queue-Id: D9FBEA0012
X-Rspam-User: 
X-HE-Tag: 1769014650-989441
X-HE-Meta: U2FsdGVkX1+qhWPvMyDaEmfLMt9PcdTtEw85bA5CuiLziQ5tw2DeSSRW5qgVUqvBP8ra77AwOA49uYPp9EiN7kMC9AH3M9lbBB+Tqr6xrbIoW7NL9ahU3M0KX5cbDoB/wDIOj0B4Htg/pJ6AiEkfA8TPSzXqvAK5fOoxP7P33NDbsOR8/husvQXGqp3BmaxEITgRll2h8FWyMrgTq0+c198DipiIESM7igqI/NPyr9iilpD6TbDxNqXJnpo6g5IDOxzzjEZgr941sP0LnoAZ4QASG1rXN2timxGRLrFWj3LM/J4sFfub0756Gf9rr8g8JfewdPfAse6bCbW3okhZvUV5pPO/sDzw20ui9eTjEQjrOBlec3+70EBf0xNDizItxhAJUqDv5p1vfVJdjX9yQjDhLBqTvGLhbvqekTmmDO9cIkEaC7QsZ9s+7S4kbcg0PqJrSVpefJILtP0NZGJB9lsJJh0HSKRBuddlWCYnokqOvldjtdDosHZK+oXUoCYkpEN8kJlmRGf1+F3z5YMtCij/u9aK+ecNEJDlz6W7HvDuM4jM7p3x/rSnLBaVBKPb3xE//S+7fT+xRovkwwYvCPFe4OV+iyo3PKfHau8dSX5D0XxIuujm3d22iJtgG5MRTqBvwjErcopgkA4uvrtmzRGCxyZB8byii1RxZZSnp6JcvEM+aS6f0P5aQ4BjK9IETZT/vH6KcuZK5xCUkyNGzTbDxHv/IaLxK5CyEbGYukwHEvy9lV7C098a7XYcieMYKh9gG2xzEuULobgsuj8SQjM7hCdSFRDv+3ZwVnwjnpJlllh69Y4/Y/Ejt3fdxu7Up7PKYrzzBQDkBYxDUAmXrrpEvVQ+SnKuvuaHwzeOFyU+AbsBOCIw/3/C0AGNn5KGiEnebr5eWqecXVMEmEvOvI9h+bAlvBZXl4oFKtVfoIl9lOW+k0lHX3/+W3jhZSDh54HNi1tXWasIg77vTbu
 aB/P25Tb
 FnfONfOCRBOu79VQMQIJju8duBDkqjlzSwgHK4LxLuylGRfx17+UNMBjrHOAf2CxSx83rf+E0EzxC2GvPBpgFYpW+SCeh9TpUKngUUOKY6MY1dgjKN00Cpn3/HpNFCG2F3oLcqkFG0K14ZyJKY+Xe7FDX0dBcBQIrDbPyN4kdMAc2SCUaACFHKYHgL7ck51DuBlOL/CYAKHZYgsMu5jBt8gwspc6L5Nf2uTtH+raozYxTsAGLYZRl2uLdRpsd6J+S22HE7Nm/yq7fXa9E+VFjWoejE9duFpbqViFTJXa91JZEMFNVQbHPTfUGpGLYjkjrlVkyVMhJdemrd0TVdLCplnE6Ab9TSnbrDbWWKKEW7Vn3a2RV2U0iVOTEWi5oIBj70hBAyNDSkx/8mwf7dIDLT0EenKAGDuAJ/p9w0Iok3PUEA0lmfKVf/l2pj2MeLJqj4SWF8n/EYwzGezQ2A5onOFDoqReExCxpSZ1HC+Rn9OMaUsxoQZsz+z1VCpEYsjZvJb1OZpGiNijoEj7wt4+lPNPCJQ2i92SHa4Lba/AJz9E6ZP9ZYTm7d0TxADkeIS8npwLLqjD8Ir9+dEiTW+r/70if8RJ3K3/xDnYB7keLM+RD1bk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add plumbing work for using maple copy as a normal node for a source of
copy operations.  This is needed later.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/maple_tree.h | 1 +
 lib/maple_tree.c           | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index e99e16ac1c6da..db6a02788902a 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -165,6 +165,7 @@ struct maple_copy {
 	} src[4];
 	/* Simulated node */
 	void __rcu *slot[3];
+	unsigned long gap[3];
 	unsigned long min;
 	union {
 		unsigned long pivot[3];
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 499cae720251f..9c701ee7412ca 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -101,6 +101,7 @@ static const unsigned long mt_max[] = {
 	[maple_leaf_64]		= ULONG_MAX,
 	[maple_range_64]	= ULONG_MAX,
 	[maple_arange_64]	= ULONG_MAX,
+	[maple_copy]		= ULONG_MAX,
 };
 #define mt_node_max(x) mt_max[mte_node_type(x)]
 #endif
@@ -110,6 +111,7 @@ static const unsigned char mt_slots[] = {
 	[maple_leaf_64]		= MAPLE_RANGE64_SLOTS,
 	[maple_range_64]	= MAPLE_RANGE64_SLOTS,
 	[maple_arange_64]	= MAPLE_ARANGE64_SLOTS,
+	[maple_copy]		= 3,
 };
 #define mt_slot_count(x) mt_slots[mte_node_type(x)]
 
@@ -118,6 +120,7 @@ static const unsigned char mt_pivots[] = {
 	[maple_leaf_64]		= MAPLE_RANGE64_SLOTS - 1,
 	[maple_range_64]	= MAPLE_RANGE64_SLOTS - 1,
 	[maple_arange_64]	= MAPLE_ARANGE64_SLOTS - 1,
+	[maple_copy]		= 3,
 };
 #define mt_pivot_count(x) mt_pivots[mte_node_type(x)]
 
@@ -126,6 +129,7 @@ static const unsigned char mt_min_slots[] = {
 	[maple_leaf_64]		= (MAPLE_RANGE64_SLOTS / 2) - 2,
 	[maple_range_64]	= (MAPLE_RANGE64_SLOTS / 2) - 2,
 	[maple_arange_64]	= (MAPLE_ARANGE64_SLOTS / 2) - 1,
+	[maple_copy]		= 1, /* Should never be used */
 };
 #define mt_min_slot_count(x) mt_min_slots[mte_node_type(x)]
 
@@ -627,6 +631,7 @@ static inline unsigned long *ma_gaps(struct maple_node *node,
 	case maple_arange_64:
 		return node->ma64.gap;
 	case maple_copy:
+		return node->cp.gap;
 	case maple_range_64:
 	case maple_leaf_64:
 	case maple_dense:
-- 
2.47.3


