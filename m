Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 766BBE6BF3A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4053F6B00B4; Fri, 30 Jan 2026 16:01:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D926B00B6; Fri, 30 Jan 2026 16:01:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2289E6B00B7; Fri, 30 Jan 2026 16:01:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08FD56B00B4
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:13 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B839CD4D26
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:12 +0000 (UTC)
X-FDA: 84389850384.18.6795AB6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 61CABC0013
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fQAkYIkh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XnJNN+c3;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z46YKdo2lBzG2/pT0aZ7gRzGN1eS4pfYd2iyISwVPU8=;
	b=2MfWVz55VkVFpf5y953BkHevhSDOD7TG4ey2pd/B82IT8wofXnQ0cAggnVb5DqkcW4CrFc
	ZwefbSEKcoiuhFKUDrMtYV/GKAROQQsRg/js3qSq1H199g2qPo0jbmYfI7jopN54EfrVuq
	i18aUCe+ZDppMNs5EUzDQJ4TkK566wI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fQAkYIkh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XnJNN+c3;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806869; a=rsa-sha256;
	cv=pass;
	b=VTgtnDpE9fPzMR3iX7jVDLHvr0gbGsifQqo/OqAdFQ4eNbEq+nMaPLt65+NhTU47CwLm8r
	n9J4XLWXyEbOFJQ1s9PK+3rrPYILeOyQNXxP1OoeAIxEkrGZ7tSDJu6MyTk8NI09mKyEBN
	GJ7r2lM/pwZKhnrcQAwP39ZV+pz4vvk=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDR473538556;
	Fri, 30 Jan 2026 21:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Z46YKdo2lBzG2/pT0aZ7gRzGN1eS4pfYd2iyISwVPU8=; b=
	fQAkYIkh14KC+ixcyuTcOTxlWwozxr83fcbfk1bLpNbOWddk1RXMgeTyQlpG8JNv
	hfyO0aWYJ/ROTk6VLZVC17Ffb1DKT5tXjXtRi47Jah3XDoThrTMa5j7H4vzmHqUQ
	yPyPeS4bBvKv5aesmmC2e0gjKmoxDyphvhYw3KQe6d5sN/qODpI9Pkma/R8fOPWX
	ZNUcBUo5UEsyZu2LJ9ALMgVmZOk8DmMSZfyHBnM9qdb+zz2LpwGukNCus12PpGd0
	glcGIaeiT4UYmEWV9V75R4jzLeNLryQ9X0LAETeKWNQ6RYA7jF/0sVHNKKaonj1A
	isURhrIJ355kvjiEFR55dQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10b2rcry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJKVu7036073;
	Fri, 30 Jan 2026 21:00:46 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010052.outbound.protection.outlook.com [40.93.198.52])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhtexx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aI1wEoUFbgZKqSc6Oo31r536OyU+RxTXKWkBqfwUiLNWUj3jEjYSh2z0eVsNsfWPaiuUAanUt9HlsYAHZXTAxMIfJniuzoCNCVUKuUm0Usvn43iSHyIjHB3Fq6w6nM2YYhN0Kv8gFLjqtjJeHP7/rwhRUsCqxWMnQXC342w+kZ59Ii85t5+fpFJ2vsGHJs3q0g5vlzLcqwQ/MIo9sVEtuR6D+SBuWFvJt/7l9LaKZ7zRVeROqagWJ05ukyXg9iq6t+WgUQMXtWaiUsIwFa1N6x8hbRWvJsNYaFN4E/Lpa4ofkI1YRlLSvXmDXYl2lFmMlPXUDXg3a45W2+t/hSIB3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z46YKdo2lBzG2/pT0aZ7gRzGN1eS4pfYd2iyISwVPU8=;
 b=Ae+jaQdcOAbT3TYMBtO7h7osDygLbi4rkf7Vyl3NqvXWrpk547iidCZu7k0DzyrGzAu7vfcCUjiZRo3kWd7GBswlPF4d2CYvzH2uvuv+Qjt/NhXiWi5cF8aDOkXPFyKfjTRfIIPEBTm0uPdHL76kNMLHBKyhXKvkr3iUKI5rMM4OYWxG92ttlXcSnWi1xGoRxSvo3dR5eO5tKwHRSJnpkKRiG8beVOXAu+SnFaGKwjYgTQGZLqsDEpRkOgFc5dT+sIRizTJvR0MsQy/sxsKuY/XIdM/fTxv7dI+qaxZnJsyv2E5wrY6pw3+Gr7sjDkTs05NKgu3SR0xy+PFCVJNiPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z46YKdo2lBzG2/pT0aZ7gRzGN1eS4pfYd2iyISwVPU8=;
 b=XnJNN+c3B3xzBpmBi6OoUgltfTY3bCVGsGypgVLvp3VRio4IHybb9mMViou88VUau8gCdoBMTh6DlTV3W0Rep5Ez7zpMXa5YnHPFls/AhanUxZ8iK19KAcWPRfNQYRkJc9BLNeo+2l0Vj1hU0YRNitzUGHt5TFdxolyI+mbWsD4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:41 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:41 +0000
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
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 20/30] maple_tree: Separate wr_split_store and wr_rebalance store type code path
Date: Fri, 30 Jan 2026 15:59:25 -0500
Message-ID: <20260130205935.2559335-21-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0280.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: f17bf571-2b6b-4bf8-46af-08de6042a0aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q4AGsO4qYHjMGQ8IrpisGaw51weAlErIPv3wWCxzHdr00LBmWafIRn0FsGXC?=
 =?us-ascii?Q?RhQYw8CDhsRn41vA+CIQPY/2/89bAGqdeVbpucWyTlcGqBk93Y0Tu7fa0dw3?=
 =?us-ascii?Q?slcD8ldCwYiKKNUK/CuhB2YYgtnVVOW0qcmZIKcI3VAYQfLOTCWr9thmHsz3?=
 =?us-ascii?Q?gBksu83Wha2Wwsw/sbybaNqRFiq8LGTFag8CTxHRYfQN8PGV4vaB+3ZS7jgP?=
 =?us-ascii?Q?jysCYK52bL8UP++vc2kZ5+PMT0oPpeU941zODlLFuHbZ4hQhrq8fAz2fsqmg?=
 =?us-ascii?Q?ScXWaMoE60Q4CtdadmwUmMgNpzWPXCXPe5mpBtSlQGj4NI1XxiSkPCOTaYBV?=
 =?us-ascii?Q?Kql2UDNTt7yW4Jb2Hlf75AM3DxYC47mGdUg+ShuKtqitwgJPBFhRnRagYrmi?=
 =?us-ascii?Q?tfkE+1LcscwG7C3U1PEqp1IoVaIw2a3XHZKELjwOp/pDLiuW4CVPpHKXp0gr?=
 =?us-ascii?Q?exa3tzgKy7vDPIiZszkaDLHUHHdD2VcnHqgRTjZSy4PfVTTHWkrQ2KisSi0F?=
 =?us-ascii?Q?0Ooc/ggiDNH0VVhttotKsNHx/+AgV0/77JRYASkbeSDNSY1RqTEnO7jxGSQL?=
 =?us-ascii?Q?sN57xGDR/p4h8/9cykcoPJvrQp8sLOF/tMiYMKZTFonkz89OA+fWTjte65Uw?=
 =?us-ascii?Q?NQ1IsP74zG4lDpWZR4JrayMiIl29/XMAx7gKk+80FhZt80xyIUA/IvfJx+B1?=
 =?us-ascii?Q?EZu95sXXsHXi7qN9vZtEp8VJf8IRvlNojcJo4SSTOdOf6tYsYlQMdTBQdwQ7?=
 =?us-ascii?Q?G3etJTqQdOBj8U2TGzk5dvkwicuKtfhF6lblzgwDDZDFSdf/p/Az6QY1ngXN?=
 =?us-ascii?Q?uayHwzbGNMtcQ3P44VqZ8zw6jsXwi7xLdm9xG4l0IqNcD40o3ByR6Sms7sg5?=
 =?us-ascii?Q?g7CbwZ/vvAkS8NlVvYRcU5OF5EPe3lF1fHBKaRGUyYAmDzV4L4iGHuB933st?=
 =?us-ascii?Q?NkS16T1fVEIEwbOfo+6PGKXSQsOgZtxvOiGG7giYz2kHpyZo5H3b7q0hFQrA?=
 =?us-ascii?Q?AdhljOmHp2O5yjrXIsr1IFEJbYd/pP28lVWAE4h2uxqRKf0vtjA/YFVTpwsK?=
 =?us-ascii?Q?rwyTk4Xz9/zwp+d+Rfh2iDfYps3G8FmCfBa++KdIyeqxTbyQTelxdbvAjw9B?=
 =?us-ascii?Q?CLwDFn9uetNA/bny+9WGbZe9CI3Fsum193n+A13YFkMMCRVajUG8qeothT02?=
 =?us-ascii?Q?j/h8pF86+hW/mfm/qcMmp+IqjAAZ53/wLrXPl2v9N2E+62oPL4DbUpkcoWqc?=
 =?us-ascii?Q?P2Xits/sOC+b5WkobbN1EWg5+XjTxj87R6qS8ExECJyZE9fC+yb51QukdV7Q?=
 =?us-ascii?Q?3dxnmz+RrO6g2DmDa2n4UYnOsVoWz5tBsEDdD3w/6pYJzLsjfVreUi7Aev3M?=
 =?us-ascii?Q?NzD0kwHicXX2IwSxIQEALs/I03H5+I9KsEAyeF/m24t02GNAR8gB3ctXZq26?=
 =?us-ascii?Q?4PeTztkYItPu50UahuhEZjq1LXtv6mNCZC/h6ItZ2jCb+lpfnNgXscRBYoye?=
 =?us-ascii?Q?8KU+BDfrsrc4v56dNy0l7pMGiwRt+wvHWM6KqWnHgZbV4ZXj/YF4QkaoFkYd?=
 =?us-ascii?Q?H9q4yzNCuAkcwwnjQag=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8Ng/E8vvMWNYfYbVI9TCsc8PFSHkzzqoCJjsI5vgDq8/5ASk1gQXA3TpXdDz?=
 =?us-ascii?Q?LjdvniiFXloLVGn9LIEJxizRGohVRwR80lsLs64BmTEu4UuFfeqbfUsqZuY/?=
 =?us-ascii?Q?/LzZt6Rg4YgxTrnHKCx+awpyIMxXjlu/FtmZi6mkSNGsU2kCkGstniKG2wCM?=
 =?us-ascii?Q?uUT0qEpt0bVM3FJ1wQ4p/3JTfrbgLUqgvcjcio2kD6pu9Q+3HGeNTpJoyl7E?=
 =?us-ascii?Q?E48elc+qoLC4q5lbaM+LbIDZcsQcJIcsal7KRcTyTuNcTWUm/19NU36Ce3M8?=
 =?us-ascii?Q?kcFeyk857uGu2g3boJyTDcZ9Nrlp/wbO9JGvkiDexsQeYP1RYAclcUkK+gxX?=
 =?us-ascii?Q?VK79ocCx3ulD/S0cMVJ0FPZ88AmKWDqSu5XuHDIdGtia+L6sTqrzncDdtOMY?=
 =?us-ascii?Q?A+A7m8yC3spjbYcMmZWyah8qSIHb3y1dB+5L27MrhdW2kFSBykXCY3kTotVp?=
 =?us-ascii?Q?ZzDr7p3EScsd2HlfPDRxpUvvSsWVtGuWieFozgmf+zppqsQ/B+r3GXSlzIxa?=
 =?us-ascii?Q?4YsccT0loJpajMFT3LNu04v6dK89fa59ZYLuDpwsWnw9VgeJZVG4ZbVmGDj2?=
 =?us-ascii?Q?8l6UGEKEJlnXNScZE585p0cxfv242OFHXXT2FW+kkRTIqST8BeKVwyZBOFow?=
 =?us-ascii?Q?qrS7cH/pgJCmuOHNXXjXkmpXlb6witZBAAuiVy5bSwiiIct/7pMLVx69uQwi?=
 =?us-ascii?Q?ao88WaLTH/W2edpVIVuFA0lialUyCYZNI8ftPprlnuWCBn/W+1XIdTt+jZgT?=
 =?us-ascii?Q?pzxtmUtCXB59olXTB9fZPN6UdQ5v6TjnqGRWeJsvFOcNb6XTQmIlMjVOHeou?=
 =?us-ascii?Q?DxoAdx4UZLEYLRxmhpR1K+wS6GsIJpYSmqliTPHFsqlylV8yEJJkQJO/tVnF?=
 =?us-ascii?Q?v2kXWM05O9tNx7VOZwAcnsakHtmXnJaiI9FocR6xC6Cs+ke2QMeCKAlaUt0V?=
 =?us-ascii?Q?dD62Cdv8hOv9hf/dOzODY+p9qJWXbSoA6QgMIsg+FEcbM8NkcQbWhXTcIBJd?=
 =?us-ascii?Q?samp6NxxBkxvlbZY+rIju4/+1ErE6DjhE17xgqXel4q21qPRsgwc/P7A/srX?=
 =?us-ascii?Q?4J0S5kTS0UXrCz1qjkQz6ulC2I/jZyYtBRCOInofuqVLXWFtY4y28TSMliXr?=
 =?us-ascii?Q?ph8FOPQrEHC47/EMf/lrrP1CZ/xjWJrQmlgvTFzbarG44rd6W807J0Dkx62f?=
 =?us-ascii?Q?BzuT59N/9lWIst+YBWI/4KsXr4IetSTLlc4C5hCdzxqJULtGGWa56LJF9G9U?=
 =?us-ascii?Q?yeZ7RFStQ4qvUWLLM25FkKClXv5+QL87aliCy3v78+Y8v2p1SWGokMuF1WSJ?=
 =?us-ascii?Q?voAnr4b7Tvcutb248DPAIeKKaO4G9uYnWxp4bnuYY+CiYLZuyYKgKopKJpLO?=
 =?us-ascii?Q?LEK8uJ6WhqyfJ7aslv38C7u1z91rMQFJGhc0q+hwiaqUfA9UpD51sA+p8j5q?=
 =?us-ascii?Q?lpr+RTlfqfMx+otqIa2Jhy7HXML/XDnyIxh+NJJiGNkI+rtos/2ZVzorXjrz?=
 =?us-ascii?Q?L/ZDGs0gdDqKf5GekIUNqzjaf73aV2xQ4wWxUcHdyekPs73T2MrIuDJVTMni?=
 =?us-ascii?Q?zlbpCFJWEC/o+KkRggAd6OXMkkPJds/dbAsoKNavC6yJTAWL3X2bgNNhvcm0?=
 =?us-ascii?Q?OCSIVonPnh56p4EWMImF2105CKJyUjZNPI5kIaE4PENls2BMfIrf/7f97XK3?=
 =?us-ascii?Q?hdtWkwOuwPQtMf44k+budgoDZ8LOaO390k7gky4lApd74aewaAHy6iN5EKnu?=
 =?us-ascii?Q?MRoXEJZ/SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fuN5Tg3vc2YNTPpFAeCnQB4uWV3cEYUr6mA69/82e+ekmQd/sTQmOnutINUZTRC6PgYV5LmQwroTSRJ/+IxcG1NdL2WR524tFbYPWtGEbqjUpkzXN/J67L0DmwFW0CTBXRXB8Rku4ZTzfrQjfsn0dvVMQXYh3AU9KBPn9BXD/XcatoM+C5aJEHl5pOGuQvdoErIGKygNzExcTpW1DVNrTHPpeT4C9YH+0+JD1JZSk+2z3OQdO19buPsldGHeBZ82tYUamT3FmBJpfiacVmPZJudcy8EsPHfW8Cee7TWnps0STbA0dhPLzZ5MMx5FHy3116FODPLQk0KGWXLbcElSRm4LW8YGSqQMkNWJLWOYVbA42eyGU8F2XgYwo8EwaiZLavr3rsyiKktg99gHSSQVpsNzLT0NQkk++iVL1ObUHCcAWwbCuM4gcMK5bbKAURqw1NyzlZP/8nO5ydvURpJVtUt3acw8Xx/z1lGWK7pxe7nfYYcx1tIZM9qV4PsyiGZ7vMZjekwGlv0VJvunVT/UjVLg1d4LLWnB09gs7IBMGX0xnuZIna9Dvfq2UIJLm3o7SmXrp3yILMEc5D0G4mCLRBhINCwlCbNYLp+FJz56x20=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f17bf571-2b6b-4bf8-46af-08de6042a0aa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:41.3749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c03scqu3VaQQtZpzbkwXBt7aN4Du512cZ7YR6Zk484lHl2UOEBR67+a0AvQh4OqlDqjhh4pP4vAKuhO/Z4k62g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-GUID: 3m33lqd9TBd1PR70kHYnVB5z2J7foQy5
X-Authority-Analysis: v=2.4 cv=BLK+bVQG c=1 sm=1 tr=0 ts=697d1bff b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=_NXkmabX6IJC5lhnbH0A:9 cc=ntf awl=host:12104
X-Proofpoint-ORIG-GUID: 3m33lqd9TBd1PR70kHYnVB5z2J7foQy5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX0uv2vhxSngfx
 kx124r7hCJLihwaO8rfP6iZXWj3GzIouceZ86n0Zl8NxM0ugSg2aI0JQC9JbXWdi9HhdVtnHjX/
 5qZdGGDUGuSJfrDVgziZCn95reO/yWCET5F3z4aLckohbNkOeJyhCDvTOOalOa8J36Bbz6Hypn8
 yvGBU+0TLnApXE3XnowDUxUx6mwLpTGs501q/1oxg719ck7nqCKLpYIJYZaBwXHtMQptMZRCvNE
 4unApP/FVAUBIpZmCFbyzLCMrFyR9cjq0N6ctpkefQemf0QF2GuKoObqcHUSMzgjg9/Rl5et5Ge
 Obvq9fUxatxWmn6j+vdzzIdignY2lHSfW12YRPHqGq78IV37zawcR12Qeb4ELOklRe1Ikm6n7q+
 FZQsKMJIFdwhdCjQfaiMz/joIOvelSmJRqBabtdx7QzP+ACU0fTXEdIXimFvUDp/WeOs6uHECiI
 c/LbbKSl2JgrKXIe22Epzi9IfIqi3hhXsyNB70/c=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 61CABC0013
X-Stat-Signature: pc1r38o9abu45ku4qsjya7q38d9zpe87
X-Rspam-User: 
X-HE-Tag: 1769806869-887751
X-HE-Meta: U2FsdGVkX1/5FERx172w6DZtZvqqnl7yJu+cux/iF0d3AZwmTmesr8A2RnCc0hY0Dj18Dk6YdewTz6V5L7HVv4gqeMfQg2FgyFbXJG0+WOGSWFZ3stacNKn6lsUHUAuasCBz3fTqS45BrgGHfQiT8QQrUYGvukq9WgXRVp1cW4BORQ/NtkF6K/hzkj1+v0GAdCy4+uO1XoJ8IGwuKhie9fjBanhHBpIbGaCx5z9zcQjCUUNhVmvH4VF+4OjQUXlyNqO3sdPDdD0Kxj7/7/1BsQABrpGhzKB794obMjzbWzx+ctLMJncCjrJ1UjaSJXRPQEOxcFFjK/YO/9I6pAoZt8WJQh9Cf9or/qcrGZ7RdCoOdPIZoy+haQjjMjw9In3K25Xot0eEUJ0JMLOVkT1/KZ85kr5ZBD4tnoeDQ7cOMkeBR6DfFq2+bHDMw4lzt23d3ASeBzKDH3+xFmtcO+FsKKSOHZzxYpU0hQzPyqctL2nWoQKYBWTcGUzePpOOJ8zHrXPUnePqO7rKKgImBqGgJgYPRs9v0dv6lROeiPR4p8SKe8PW5Udo/e6XGn6Yb8v9bAkd72RyO/dHdZeXhIMpGYgocfg81hR4Ucuwl0PDKiXnq1Fgl1mBb4hPy5VMUmuWB7o685Od1O0NP6F98oW6/dfMABBkp+CtG/Kafuxr8MyhFPHKW4pv+WQaZ8wGS/8i1mii1uGhkgWlzOI6XnBNHbFg4fbnUF240UUXBK6TN9CiMKCHhyTe4tha0aeh0kEIV+vJsAq53Rv4T7R/0TgCG3CcsN046h9rkHy1F68yW1wwrfIxbRxa5S+RPKFcRYy2EOwAbmYa8/RhHyZ4SHQHZw1Z0Dig4yQ9GP5zmu69yKDqCwV0+ST6QihOER1sm8fVhp64pJsL/2AEah0hK439u7R58X+KvNHEOk7KZBaEpLZKadDRIL/7Le39KbN70ahjRwHHLbvjAbNzGKQhf1y
 hlPdJNaw
 YVSR//eDZAgC0sSstd0f5Wn9yD4nG3k8pWO7lk47vsaC17U7sgX3AoXt31CWfCHaHbE/j8DPkjAuTx/4nRtFoTTKyTd8MChmJGL6MfJgjWj7l71cppj+pbM94kXQ9LuaamLci
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The split and rebalance store types both go through the same function
that uses the big node.  Separate the code paths so that each can be
updated independently.

No functional change intended

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 4a64b4f37aeb3..5280fa6d2d6ec 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3719,24 +3719,6 @@ static void mas_split(struct ma_state *mas, struct maple_big_node *b_node)
 	mtree_range_walk(mas);
 }
 
-/*
- * mas_commit_b_node() - Commit the big node into the tree.
- * @wr_mas: The maple write state
- * @b_node: The maple big node
- */
-static noinline_for_kasan void mas_commit_b_node(struct ma_wr_state *wr_mas,
-			    struct maple_big_node *b_node)
-{
-	enum store_type type = wr_mas->mas->store_type;
-
-	WARN_ON_ONCE(type != wr_rebalance && type != wr_split_store);
-
-	if (type == wr_rebalance)
-		return mas_rebalance(wr_mas->mas, b_node);
-
-	return mas_split(wr_mas->mas, b_node);
-}
-
 /*
  * mas_root_expand() - Expand a root to a node
  * @mas: The maple state
@@ -4373,19 +4355,34 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas,
 }
 
 /*
- * mas_wr_bnode() - Slow path for a modification.
+ * mas_wr_split() - Expand one node into two
  * @wr_mas: The write maple state
- *
- * This is where split, rebalance end up.
  */
-static void mas_wr_bnode(struct ma_wr_state *wr_mas)
+static noinline_for_kasan void mas_wr_split(struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
 
 	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	mas_commit_b_node(wr_mas, &b_node);
+	WARN_ON_ONCE(wr_mas->mas->store_type != wr_split_store);
+	return mas_split(wr_mas->mas, &b_node);
+}
+
+/*
+ * mas_wr_rebalance() - Insufficient data in one node needs to either get data
+ * from a sibling or absorb a sibling all together.
+ * @wr_mas: The write maple state
+ */
+static noinline_for_kasan void mas_wr_rebalance(struct ma_wr_state *wr_mas)
+{
+	struct maple_big_node b_node;
+
+	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
+	memset(&b_node, 0, sizeof(struct maple_big_node));
+	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
+	WARN_ON_ONCE(wr_mas->mas->store_type != wr_rebalance);
+	return mas_rebalance(wr_mas->mas, &b_node);
 }
 
 /*
@@ -4416,8 +4413,10 @@ static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 		mas_wr_spanning_store(wr_mas);
 		break;
 	case wr_split_store:
+		mas_wr_split(wr_mas);
+		break;
 	case wr_rebalance:
-		mas_wr_bnode(wr_mas);
+		mas_wr_rebalance(wr_mas);
 		break;
 	case wr_new_root:
 		mas_new_root(mas, wr_mas->entry);
-- 
2.47.3


