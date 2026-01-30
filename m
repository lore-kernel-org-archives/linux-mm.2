Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D23FDE6BF2F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 16:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D716B008C; Fri, 30 Jan 2026 11:43:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE3F6B0092; Fri, 30 Jan 2026 11:43:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09BE46B0093; Fri, 30 Jan 2026 11:43:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E389B6B008C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:43:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B114160717
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:43:17 +0000 (UTC)
X-FDA: 84389200434.08.AF89DF7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2A316C000E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:43:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mSCrGwSW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="UhsIYmB/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769791394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVZME3TjV+nQFSgbU7EfcfxMGDepHzqQAIXQzNWI+ks=;
	b=FtS0uXeaSVDDmb59PrcfQiA+5LvCW4HjGDpn41Iygaa9T296l4nntrx9U52oAD8Xyy5Khk
	9V3Vz987NYxM5tHzVQoaQ/nd/W0gZZMFCMxGIKhtCwS0KNDkbNvH06/75FGtSDg6pyQqrg
	Rn17n7MbI1+m50e0KV1vNNdebXQbHbs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769791394; a=rsa-sha256;
	cv=pass;
	b=jl9awJLYXNqiUx+Uh6oy6o+1atg/g+HcTdlOWSQntTdPOpRwHNV27yHf4sk2/W/XeLZ5r1
	DhmolECIvT3Q62VHuYIR3B5kMWSF5ZEKDazjz8+p79pvB75g0bYxl0/if+FK47gsRjUiDi
	Xrl43Us0x7tgm9/PXUqdYmfMW0lJp9Q=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mSCrGwSW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="UhsIYmB/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UChBll3324497;
	Fri, 30 Jan 2026 16:42:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IVZME3TjV+nQFSgbU7
	EfcfxMGDepHzqQAIXQzNWI+ks=; b=mSCrGwSW/NygC13tZoSSfcJzUfUuLs5/kO
	j08GKHZhbhJjd3oOxXKKTUtV252+5hFl4wdlQZ6a3O7HgQ603vDQukNvvDVBPtdN
	+7TuWggEq4rZfQHQfJZ1nyEXXcEnPsAJdduMojnOO4sK2HmP/mF3TwwWJYNsmwGc
	IWNQUdaZF39L5kQ5nH5ERxdyVUnZu/KODglVR5MhUpR4urq4KQTvVC+n63GJ2LIn
	WX36GF9devhmjNFILrmoMpacI/Hya0Zd7JTm2TzukMOfkFzGxfVGRNIz7s5uawvS
	jpbc5kfhsfqLNpZEpgtS2Q7Z1oVDh1C4Lz/z4Pb2QU9nacuSWi2g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by2vgnkd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 16:42:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UFPqh7001839;
	Fri, 30 Jan 2026 16:42:56 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012050.outbound.protection.outlook.com [52.101.48.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhjf37x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 16:42:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tj7HklmndwniqbvIhGzxIgvNGNQQvv8rYIpesaY4tXHkVRafjrANxSEQPgSvDJ9oE0PkiPpqBLm+UEpCMSYBTQ7piCQcGHW/NfOwb3+GLCdDkW1Pcjr6XDBtCKqnGJBCJiq0CyDPlrHMA5NbrtnY+Lc6MtfBlRtSBKvBcV9Yy4fLDhv9+2rTpUgAPwnJF2def5vNtnKIy4pYJQdaps6yIpFFTmSOw2qkOi7cJQpHfCYCreF1Q+feRZMUOCfKuJm9ew0fbV2oaIIp2Tdp+dFRrJ2ExJatM3jMcGcQj2490tXYx/gIzH6FjWRWXA5t9LAaegspo+P7W7Zr/JHGojdiEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IVZME3TjV+nQFSgbU7EfcfxMGDepHzqQAIXQzNWI+ks=;
 b=B4midc195mWQd+GEJeS2yjckWcs3R7DdS5V9YGu/vQ5P0mfgpIa30Q2T2YrLujpqBltoad4Q6G3TtOGVCmk8Vhzb41+Z4tj2k9YrpE0HQDvTHMphqyicpE+mmbxHo+Gf1vF8Z0P2YBjHLvyX/ZEJ+Q1J+fe+CJnyR80s/MR2ndnohBjJ0kQg+sYrwMmJgiP7VFMvk7EDjrIjLuslAuKFLetSb9rHMUuBFIZE+9XsTo3ETyyKAPzbRL+FPomrQVe6ssZ4tHh1fKNg+KXz1zJcpnq73xO77FhH+bIeQ1T87lbZyoR5P+1h5bwaILGJDS+XpODc3xcZWH/uGSS1c906kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVZME3TjV+nQFSgbU7EfcfxMGDepHzqQAIXQzNWI+ks=;
 b=UhsIYmB/EMFdUlTxqQQflTCygry7lJFJdIODrs32VUIIXaM54EcMwOK8jZGuV3+pH4ozNUfkrpnxAkeKQfjqJCy2TJGtfkoftJBQEQCF2tUmkdNxQMWoSkWtABdH4L2IxaOxj7aRARX5qbU5fUh/eXIQEFPcIY80TbiUThXlWrY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BN0PR10MB5094.namprd10.prod.outlook.com (2603:10b6:408:129::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 16:42:53 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 16:42:52 +0000
Date: Fri, 30 Jan 2026 11:42:49 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2 22/29] maple_tree: Use maple copy node for
 mas_wr_rebalance() operation
Message-ID: <vb2xas75xigzauqkfey7amtb6ux5oz4vnfxx7u7oks3nzbggy7@eaheqgwtwa34>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Alice Ryhl <aliceryhl@google.com>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Kujau <lists@nerdbynature.de>, Aishwarya.TCV@arm.com
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
 <20260121164526.2093265-23-Liam.Howlett@oracle.com>
 <bd1c3356-11a1-4d0b-bf58-47eb21bfd24d@sirena.org.uk>
 <20260127151548.b57825c664d36fbff70ffa7c@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127151548.b57825c664d36fbff70ffa7c@linux-foundation.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT2PR01CA0021.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BN0PR10MB5094:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e7cedbb-da55-43af-f518-08de601e9cb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6ZwhoQHVCyrotEkDwCXN2pJ5jQ9LDRyyLd9SUdOK1JF2lJQR4676trMhUWqw?=
 =?us-ascii?Q?GXkdlq3NONnKXA2nDfVJlCwZstfdonZg/Xy2ObVPiS/LDmq1pNZpVIshZjGB?=
 =?us-ascii?Q?i+6U4+xSCuRNMBLLz76E7mBKKMq/qfue7j/bBd0RJmN67xBtc5RDYtE4esBc?=
 =?us-ascii?Q?DAXBOmmSkcKwjCAQlAK9Rv6wNS0p1IoFfkDPuvBrU2/TU5FNKVRz5wjaxCm4?=
 =?us-ascii?Q?ip8txvpbAIsqDy5UJACKH7mfMQqCZRv8A/FSZ2lQksHKH+8w7dXhzmPsM4kr?=
 =?us-ascii?Q?xuyJsYwZA4ruH3yp9C61p14PBwjzuG7jWGkin0oob3m1qGisXi725qz7Z33z?=
 =?us-ascii?Q?hVxXpDD7YIP0v5cfZCFnFjN/3GELdBNqLvfs53M5fN1qRJh+mg5DDPYFZPMN?=
 =?us-ascii?Q?cK5eKHOhUM98t1O41EUuvs6ig4yREALfmFxVolthynaOHgqH97jmmvycMV9Y?=
 =?us-ascii?Q?DCG1HkeKKu6oqqvU3Qn3Blms0zu9rjLM+s3x6h7/X2+nuCarQgQLfHAgwlyS?=
 =?us-ascii?Q?XriTlRFR6nk5LmJhQLUMYBXsFVu9cXD1KwO5zg303SwwN3r1G2O0ayPpcj0j?=
 =?us-ascii?Q?BeH1MUK639249h3x0ZK+ZDClcrQORNbQl7zqSPsp5Ev1KEh+NlfVKUXKQBfm?=
 =?us-ascii?Q?ssTLWWmwT51nrgIDLU7CcbSwW9xOGLOoTfbHixDwuHsqTG2I6cNPNDjQ8LQQ?=
 =?us-ascii?Q?mXKwhbgF/QKsysv1wPOGzGuYWLHm//vMnFase8+z83fxTaPFfrZe9efN+Z5z?=
 =?us-ascii?Q?FbisnJNbp8iv/+/Yz4rWQh9BayV7oXyw3I3xhcTk7FEa/QxfI+2Ukijut230?=
 =?us-ascii?Q?N2X984qqRh+XaF1U78BWoUxfRaZ6KxgD3Eck3WG548+FyfMp9a44wdYeKslW?=
 =?us-ascii?Q?Yo6fLlFSNh+V0Vv+byrvnKrw0LQYOVuRGbD5iDrPYblNtE23QuarpH2U4rNU?=
 =?us-ascii?Q?70cenSv5ffFt/UvbEDh2Ez1Y8H3o+Qvv0dMmPHsOwhIPSySd0pn52/dnz53V?=
 =?us-ascii?Q?qzJcBV4ETXk4bnQbzLqTzCIZhVeb4M1SkzU8iyf6NiIN0eiTSl7g6S/vqpZf?=
 =?us-ascii?Q?83TzW6k0cgxoKSq6Ak9fJk3Aw9vzZoMTEiYnIq5tgKASeUuSh5cRLaQK+RB6?=
 =?us-ascii?Q?2OaFoUiYCiAE0L1Ta6bzR5nazGvJ/CsFan/xKZ1UCl2JZRCEXwt+nqPRb3ms?=
 =?us-ascii?Q?e4QtA+3Quvj8103k/tEH6NKazzRHYm2CWUCtGlqiuVjvqjYr4cfX46X2YLd+?=
 =?us-ascii?Q?Uzdm/LX2Cceags+MZiNMIR/09HutwQvks5GNJlfAIXfOxGdhvd1/rTzz+rfy?=
 =?us-ascii?Q?vchVs8Mb+R7zVKzYNwQoXBWI11iFycCfLhNinHxoNHbUhC/ODAVR80rEw5ZV?=
 =?us-ascii?Q?XJrBiXfAKHQf6s+5iY7uRODLvLO48kECGDp+4NPl3Chk3uftFglls6OTKhLP?=
 =?us-ascii?Q?XCtWtqFC4nr/Gbm8Sw+9pJrSKKxGjbVM2BmWzDd6PmtjZ+g1i/9aiHZ58Zv9?=
 =?us-ascii?Q?vA7lnUEP6wSB8ZlwpztbdbccSlBlBl771hGym28XOWMEb5T+J6rTmGOaICi0?=
 =?us-ascii?Q?K97PWVbIZG86pX22P2Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aLsi7aDL7CknZXvj6Hf6Bf4Sx/Gag/pfPP0wKLMFBtStpInIqyxksyTEYHya?=
 =?us-ascii?Q?wCPOOzmiht1/SgsuGElDjv2j8HcuQz8g0vX1MAyPS99qtlMyHuh62cH03DQY?=
 =?us-ascii?Q?4UEOTzg+4Z0i5Bh4VfTg/Q2qJqwSVKyqCKvafFOTl6KX1dkDf7SVXZjj0h2d?=
 =?us-ascii?Q?uUTcuEF4KxHy+yhBtJvQO4/ivlyf8MHzg9ie0GMCPLV+2wa5U8Pni3Ad9wQQ?=
 =?us-ascii?Q?8EU0hTNF9F6O/ADMs9/MqBuC0szvjSISfe1DIsB7zfGrBcTDyqqygNcFOHUy?=
 =?us-ascii?Q?40S7OzlXA0BZOZoEbUC8scLIIJyRDR1fVdztOpdA/YvzxMCkOTE2l+tB+Imu?=
 =?us-ascii?Q?egU0pIlZUv+EN8g9SRlkDWXfcu356Dstj6OLc0Y/X1ZaAv42bHsf+l2KHwVU?=
 =?us-ascii?Q?/NJONmyKNxzrxJidU1Hv0eVCqZsNgbrN8PTfJiIVlCREx0dKhT/3TglAY/NN?=
 =?us-ascii?Q?4QzLS+lIdOmAyR8PtL0cw6trL4hWBu9tMXwZ/9pabiAN06qKHrMFjpFPRoJz?=
 =?us-ascii?Q?3XWYQma0JgMZbG3DqB4ZCsvqVn6c2onoMWOAV36owrFRapPEcAwNeoONUzsK?=
 =?us-ascii?Q?Qh4KsQaa+Gq/rIwnioUaZNIKHs1vxt6gxstvqdpj39+tEvmj/OIOrzrYNyGL?=
 =?us-ascii?Q?HuRDCxtPlAPCiSs1U6aED9Kd+ZqjL0kI+Ao66+hhSm8D2YjBQ9pHg1pJPoYH?=
 =?us-ascii?Q?RHBTqm5C/k6lRvi7kfs10cynWgPOQ2IEf/8udwWBL3+1wEp4ZCwYU0MK0GJY?=
 =?us-ascii?Q?SJuaKqrDcvlyhEE8xU9n1EV72dcrjlF3NCHc8FcfEGtYbqaLBlrqoKser1Ub?=
 =?us-ascii?Q?c+VJAAAPa904pMTIejIzFB46we8FIauW4eL33bm4pjuMcwhtu8/cmVTvjmoM?=
 =?us-ascii?Q?Q2XxNBz8qOeSsn2b+20PJIpsTCObU116A/SljB9L/061ZzDH/QAgVCNA/OsE?=
 =?us-ascii?Q?Y/yG60NYRgDj0oVMF6YACdPC97l73qZUXml1DJiric+3CplBaEHh6tE6YR4Q?=
 =?us-ascii?Q?h+po3YXs2NJfRs06BvztSmMljRRS+Dt8E/nNYQAustDqiURZzSUBMP5LR7wR?=
 =?us-ascii?Q?T7eyB4WTwOySqtf9z1tkq554Sge5Xpwmx1CP1N8mcu3EytopgioW6X3HCsJ+?=
 =?us-ascii?Q?key30bdX5zz5CXF4lJ6ajbPZCUEbtKXYL8sjAdqf5mnatPVcEmNyDE23EKO2?=
 =?us-ascii?Q?NcFJzHCGeiMi1bcmDKevgLGaYXfGrp2E9wOKZBg/P/sYZ2jOMOpc0tnboEpl?=
 =?us-ascii?Q?Gn3tAjLfsbg+xIrgharnJtCNT3C/+zxwzwRWbzHDWAgtj06MEpiIQoRYuNtz?=
 =?us-ascii?Q?Kh6+bXpYQAj/jQd6ec1vpgdXNlWhnvkJ5ESLAY8uEG/VH5bwIDvzf23TLcYZ?=
 =?us-ascii?Q?4jAXW1je6rs4d/5ZUherPkpBwhjEiJFGEHyoqCew5ydd4JSUs0uxLnRM0GSU?=
 =?us-ascii?Q?wgrmi7plB17P6YKuYdjd2aQaJkQJvvRTcy2dQOmH6Oq/4vADteLZEpLJ4Q76?=
 =?us-ascii?Q?E9VFFKTb8lPvsyLdyknzVICMTdTIJi42yDWFUrcodOYtKxY6Q3o9MW5AAZjf?=
 =?us-ascii?Q?uG+zDmbctGcJsSO+IpeZEVSPGD2ZdDmp2EHE8r+PM8bMJ/Uvfjo/rwisN+i7?=
 =?us-ascii?Q?vekV8+S5NszNlFWWHtwiwy619D8OtrqJ8jmTHso6gtw+7eM6dGPdDzyRuhrT?=
 =?us-ascii?Q?eMDV4hx8Q6nMC1DckBZRylbuOdzhILT7Qb/EkBQhR7QBIxKjfZUPiIbNUtyH?=
 =?us-ascii?Q?Mv+pg/zVdQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vtq7AvUYUQNqpIbF+s0HOLRaJI+3jtp/2mrUkYzckwxfJa7H7wCxdYWyk7qQKJIfg8Y1K2O7BrXN+zLLXJKXx+G8TmOmXnBslg2MDBpFQLWORrw+H/HUXxCXAOgu+T4TmcG2FZWujbMD9O+t8QmeYV21hGvZ7cyd+rGBnF5ge22RTqKyReP/dkZgfC0bWqNXkWgMqvPB9rWT/b2ItEDb7BUrDb8oO6yNOyXZy5k3Il+jzvDcmQNO9/6j2uaa9o8rW2h5RmtGmLz38odKY1hDgw0iJ9m6JTvEqusBhDxmvBmjI8Pp8UMBKZxX18gX0Ihn2sSJ9UHKWJIl7eBsR4JDy0GqP0QPy3sV2JtLk8z/JJDO6R/3zMRDSFVzP8D6VA7s2OHtV1J/SjzNMGftyi4RCeXSZyFTbwcKC0j/btZy/Dp463BZSPqAr31ew/J82tC5q/KZ/vzkz9BUsIVezBuGFE6MY4odvJ+aB+72ytQb7+Nrj8f7D8ogSOmrYSfjKGKcqnXcExcNuXbEfJch5Wm1pWVrhm2Yzsy94gpmZbQBEMQ8u6i7pX6zYccMkjLnPsth9DJGi13nwK0plJCIZpUP5j0mxx1QZm3lcqLk8xcvUKg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e7cedbb-da55-43af-f518-08de601e9cb0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 16:42:52.8968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tSFgyYvlyKs1IaKtzl15fGRifByjFlCpS+snI/CKpx3gnpExSShP1ghkgq204UW7mQm+6x6R6LDMvKigm0vFkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5094
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_02,2026-01-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300136
X-Proofpoint-GUID: F9f1EffQeCeHy-4aNiDkHX40o-B_ZFP9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDEzNyBTYWx0ZWRfX28uyO82Q0EzG
 ztItF9PipaIWrR3hd5rdV64PsiOmuONyYt9kcrgPFv9jjrDor+srOjYO+qyxB9kDBdw6MXL59bJ
 fH2LXpU+0r9oVE7fkIe+C4/ZabCCHwVkLaXg0Ol9WwasRLPS731RAedG7SuwXzEqD7VlyFrtg7R
 YYedjXzl6WFnDiszaN9xDV+4w5syXLNi2C+o64BrWqT9U3PNhAZopGNck3KT31OrlyAIScjyNog
 UGk8XWtY3ZkYsdpQevk5jECvQ6ipFp/xw+p/5HgNX7rVkrTCqH1+KVLXcwchbB4T3OiopeaLCol
 lGxL17SC/J2y5c74Q7EUdURqjesn4G8oi1flUbEQ96gO6D9EBe+h69Y/Wni2Lx/3lRP2Ekodc01
 vzTkK81BvNG00HmKPBAz5XBmhILd3DbfnPGwhlbwDRMEKWoPn5fL+l/GmPsEWJbt6pRa1SVhfsa
 U+c+4Xg6VGLPq2ZzehUFWYvNehG6uptP4CvucwD4=
X-Proofpoint-ORIG-GUID: F9f1EffQeCeHy-4aNiDkHX40o-B_ZFP9
X-Authority-Analysis: v=2.4 cv=a7s9NESF c=1 sm=1 tr=0 ts=697cdf91 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=Ec51SCiPbZtzNtErd-QA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:13644
X-Rspamd-Queue-Id: 2A316C000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5nd7pqqgtze3jdbb191tw4cryh1ejiuu
X-HE-Tag: 1769791394-553551
X-HE-Meta: U2FsdGVkX19pygad8XZq0DZ6xjUgxDnB2+4u+cnOC4P2Wp35YOavLSMYb7LkYQG1R8XKw9Qt8EgVYtVNmC7tAlVZ6AN3VcKwodC9Tr6evgNSUM/6lsG0oC2NzIlMnHe2LNGsKq3ixMK4XfD5Kt2oKn3Ug54dFOxWMEKGd4LhhKrzyJ/lOLMtAYWR2DDHZWrvbKGxOuhywSles610ISnbUQC2WLrWpXxqAE0aztcuja/LljDoGuamE6rblVWrc14qBNNkrF8npCgrWCLRqL9gZK8L3NvPISpY5qiTktYKQT3nFSb68fz0+kt3u98nZxbxIBMHSswLeIaAlVn9Bs2oanURC1kjmHTXtw1zz0vK7eX2TKcTtV4UtR02wkAukpMVvBopYtZ2ejPs/1xN7O71K4RPSAs0FAW4gOeWVcvBY6hcfVmYIKJXWL04CsSsQclfJFBID6F/UtlPFksvQOuwljQFi9y6MALDn033y0qCAiZgTuIkkKOfdtEAp80FDEfr1DdPjaQDgWOkS0Z4GppY/4MZtuaKMBAGS3V+lcz4ousoz0nbsXGEIFtYvQqyiEscpoReca7G1HiAfkhwF2A7bTWX7TUDoph9Xue0K5+hO/t284ZJgmWFDa5IL7UG21GzIA3BU6tz9EBJKgUVxwUQGZmFsM76rLkhyXXTZuzOxZsx1Wkjrjr9YJrmQY+GqYgogZgRyd1nNKr7+yMYvh4tLf0Arwg2SMRzGIxM8/iSkBP0Jg6dE9p/FqDBDqX9Bwg7TMJ9iaJgj/YC5WhCFuDm3US4GFyKYGLN/xUSwbIjdpwTlaWRSM16z5T4+JcCf6Ra+b89OCIQEXaZP1jJb9hQlpA1YgMdBuipZE3Xe3AH1R2LfIcmaRiDqNiVfFUR1ypeq+kisfUDlWckmnYi+uMhzWbXvemSSCINU4cx5pURhHgnZlDE3xsH963iQ7oUBpV9cT+t5bRAbd6D6iws5TL
 ItJ/eIZ1
 MAW6r4GXF5UDdyPOPd4GZYsuyveU6zPfV/XOsE5KBVIJaBYBNz8DApD3jLuLTSI8hz4JA3MATCz+WuBq1mZVrHhDFuY3gVY9xDNtwztSk0qRrZjAFiqID52CtcyfiGwGfTalyl/EXUyJbLvwZays1szzPcH7fvKKeFzn9RMNrbJgWKV/aRa5qRod5zfpGGJPD6hqPg5K/V+xTPcoxqmZjWAcdCuFDSoa5KiTzY2nIvgoIcDnVKxJD27Ii01gU6kwoTrLWTOrmXuwrTZpNoi+3BvRHiKGgPiuEnfKDeJeZ2U8HwcxmMbt1tiAXV+XT40AqZaxFqt2Ud8waJahNsZztxQewF+JoZhW9K9gf+g9RFQw2AciokhJJ7yPT27Fc3KUKMs7EBl08tdn2f0pFUNKJqteAT91JF59mgr+VkDAPPKHCs/5poN30wGZTQiYzj+lVkEWsF/mnd//MzO7in0pCTUT81ldSxXBCyat2T4/Uf3i1BHBPGLORk3Nij1MgbRPKSc4a+ya+kgeIXBIgfHtpVr0G16Tecdjm+/XV09uY3c0PP/nASrlhjKfGUApMmgUbe9dvLxfL1uXWTxGn3NJ9ykuPe1XhlvTsmxNDXdrb4r3lyh/lU6su2zv+xHQeFOpcFPfosIoJ+AbLqMhN68Pu1y1i7pT66o1TqhEsywddmPpGZmww+xbuy/hJDUd2eFIQZgmX7Cfw+L63Jyej/+vklgHE7i9yH1zXRZ+jN3Ho70rrzSqsXsr7J0Ww4+9FC7dY8lXa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andrew Morton <akpm@linux-foundation.org> [260127 18:16]:
> On Tue, 27 Jan 2026 23:05:48 +0000 Mark Brown <broonie@kernel.org> wrote:
> 
> > On Wed, Jan 21, 2026 at 11:45:19AM -0500, Liam R. Howlett wrote:
> > > Stop using the maple big node for rebalance operations by changing to
> > > more align with spanning store.  The rebalance operation needs its own
> > > data calculation in rebalance_data().
> > > 
> > > In the event of too much data, the rebalance tries to push the data
> > > using push_data_sib().  If there is insufficient data, the rebalance
> > > operation will rebalance against a sibling (found with rebalance_sib()).
> > 
> > I'm seeing a test failure in the LTP linkat02 test on arm64 which we're
> > also seeing on a range of platforms in the Arm lab.  A NULL pointer
> > deference is generated handling the syscall in the updated code (log for
> > the actual next-20260126 commit):
> 
> Cool, thanks.
> 
> Liam, I'll move this series back into mm-new to avoid disrupting
> linux-next testing.
> 
> 

I know you like fixup patches on larger sets, but I've done three things
to the patch set now:

1. A small fix for this issue
2. Added a new test in its own patch for this issue
3. Cleaned up the old compiler pointer warning in a more readable way

Would you like me to send the delta or a new patch set?

Thanks,
Liam


