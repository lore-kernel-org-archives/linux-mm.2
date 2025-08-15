Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC9ECA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 15:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57AAA6B0088; Fri, 15 Aug 2025 11:11:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52ACD90024B; Fri, 15 Aug 2025 11:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F36F6B008A; Fri, 15 Aug 2025 11:11:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F14B90024B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:11:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1522B6D9F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:11:43 +0000 (UTC)
X-FDA: 83779331286.17.DB8A9F4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 474EC40011
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:11:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hSqIShR2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iFMu5T6S;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755270700; a=rsa-sha256;
	cv=pass;
	b=t+8/2sJhGxiawWIsGlDX1chtij3QdIfHcyhC6mmsz4xjNhC5qTU2COunT8dRjXLIJgaQuU
	47/S9Rb2GpA0HzHvnbchw1g9MX7oVreiXLp+umWB0o7FcDpoqsZSOcLXfnD+s4M6rykES5
	UjpOZS/gTCpKdIIDh02kLuBMbNwm0oA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hSqIShR2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iFMu5T6S;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755270700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AI4IMsVJLxv/WR+3t1JS+Pyy+5lPm/gQY6gkpHHfeV0=;
	b=iecq6h2yYHyayc03eRfyPug3FsNsD3PGbf7vSH/cnGU0G8gSHMnLaHSP4+KGJRiIOJCNa7
	KS/zkbuE3nWMsCBCqD9Y0KftXujujuaCa12e/4YM4LPMsKeE1XzMJ3plbgYyWm057A8qWh
	DRmqpJh9S0hp4JDdQqlBNQNgvJOpyBI=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57FDN5Vd028990;
	Fri, 15 Aug 2025 15:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AI4IMsVJLxv/WR+3t1
	JS+Pyy+5lPm/gQY6gkpHHfeV0=; b=hSqIShR2TEdxaJDIddNQ/IRccCs8PDdW2d
	jhbDo4nGnFh3Nj04bgnCAf7H+OLyt/k19BDgfespOxaF4s45BxL98632RTBP5kzs
	xFH3ghTpmWqxhCxnOrw9FNqL3eMIqVnhp3mrwrseY/i04XTor9D9vFGLynF37LiX
	+G+B5F2sQ8spZWrd8CZNNTbkCEMv7R8tS7T4nkcp0GYxlPV1FGhVAwUJwBdeSogx
	80Geci/kgJJXKTIt/MOdY30/yh/eHEi7e6TzJHrLWDYiB6TQlLNAcAM8IEO3Zfwo
	jhMnEul/a/P4cVnhOOrjYPN15R4XNvleraHgAWFk19tiBUOavkbA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxvx40pc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 15:11:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57FDqFa0030021;
	Fri, 15 Aug 2025 15:11:36 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2044.outbound.protection.outlook.com [40.107.102.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvse324y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 15:11:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BA8XSkt6ETlbGhG1o/hVzMgZlVOIuyQvs8qOgheD9zQ0p6CXtND0U1ynyO1E6/KTTyQkuhHvSqb3GSn80MBpuvyMNHREkj7mTlPMNsDQY89+Qv/exuHEyjU6nFHgP+Gr2729c9za6ohg2xGcNzuj+MvXk49WyT5LL8J+Y5nDybx8Y76fPmtwYEICyUW16CMvEcr8HjCDDfzOAT9bsUIkSGCHsWib8UBnv9D5Zv8qefH2VS/iQ7VVjcaF7O7Qwdz7ojXI8D2hTrmrTqScta+Ehbi5mODMHVa+IPIjAT/4tFKCmCARn9rptQL9F7osJRfa23mbX8A9AOUOoSdsQ384Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AI4IMsVJLxv/WR+3t1JS+Pyy+5lPm/gQY6gkpHHfeV0=;
 b=WWGDp2uTKxNSqknwWaJch479IEWFBlBwC8AWtY+rbvFhj4BLWL5oeB688XxL9bqYRF0cIpIEsWJyO6eFbsqppJJdn3p5BC1/tDa2NErEB7lvG/MUCnKfCih/D0YDfGvg2eL1QRk63P6cOWzYxt3W7EOavN0pSPy033GGQcb5+RW85VuJNwyflL5id8R49PX3Ozds+0xG7zp+8ttOM+kxZpGTTS97QC5NtTJTgjm38rd/H5Fz6/AtcUzB6L4HAqTkyWqx2SyO56SWefxuM+a8MS3caQBcZ3r8DNCwiCs6r9WsOTxFSgpI4hpU42KrnoynbTUvHcAXhB2L7iT7BJGrmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AI4IMsVJLxv/WR+3t1JS+Pyy+5lPm/gQY6gkpHHfeV0=;
 b=iFMu5T6SQCu+hupSUg2aF4XtnuXUNlcLOQvQZMfqwuMiIhQ7/b4NWOYNtGEO/YI4XbkQnShaE3crx0DU9HJQXCYRPFX4e0UYqtvxvyt/gGrTDOndxrH2qPJjeNQu+urg/BK1yuhii431U4+rYLg/2Cr7ZWznp7NnrATdHaIWSe0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB5731.namprd10.prod.outlook.com (2603:10b6:510:149::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Fri, 15 Aug
 2025 15:11:34 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 15:11:33 +0000
Date: Fri, 15 Aug 2025 11:11:30 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v2 1/3] testing/radix-tree/maple: Hack around kfree_rcu
 not existing
Message-ID: <rocriz7qo5is6m2dcimj3qiczgv3eoneqwrqvrcpsrtgqnnmmy@eswbhyo2a6w4>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20250812162124.59417-1-pfalcato@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812162124.59417-1-pfalcato@suse.de>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBPR0101CA0006.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB5731:EE_
X-MS-Office365-Filtering-Correlation-Id: 74f772cf-2889-41bf-ef32-08dddc0e058f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Iz/hjmxFsV06KWcSe0IPKRx0T4i5qNwr0BcSH6gFUIbmpKtqL5jFvDN/70hA?=
 =?us-ascii?Q?XeSbqYA+Q/D8rzutLhJjj2BIj84dKG9ZYY9sJ6ydIjxXC6LmuORa2S+/jVAv?=
 =?us-ascii?Q?M7v2crEeB95TTk1gTClovvCo1W/pXddghC0MbFlXZhvGPgVabS4lVXU8ZbxW?=
 =?us-ascii?Q?wG4DEkZfphd/drJo4idyXsMHE77DMNDs/Qm4iW6v5eabyaPqkZc5zEVwoPDV?=
 =?us-ascii?Q?1VAguCRoLyix3EcNcxnEkiaQBLFHUGtTXvOp4KjekdYNPJ73QS7uQSwiDdT/?=
 =?us-ascii?Q?0g+Foh7A7xeU4Sc2Wl/0RufughlCjQ1UdJmC6jVA3UMaUsjBFCd1cm2xQi8g?=
 =?us-ascii?Q?ang+DxDbaoJnFRmZ76whcbDG3Su90gJAdWUQ5p2Mt6srFY/vln02TRACEGQ/?=
 =?us-ascii?Q?7t0wDXjgPuFax84BIb8blFgulpDfZWeS1grIV0Cdrpl76DfZrGyKwrXAdAmt?=
 =?us-ascii?Q?fdGWLJ7dXFVc0PMrPCvDc/rDX9yLfjlFtoR39kRsDf7Lny6GMeCsdYwZSG50?=
 =?us-ascii?Q?omkkGW1DHHVmn852dC3cTfOgIGQ/oJGup/6dAcoWaKl9Jp2ZDDLpwyXMDQDr?=
 =?us-ascii?Q?uSUJLmd5Eervg2fwizepqJIJ17CxrPYKQboKCwMIfMiu2iKJC3Y+ZXpol5IZ?=
 =?us-ascii?Q?H2rUwSscwj630Rjt9BtXEXlS9o1kFmCz5j4rpNU9uZ1WrRaxlxfcgZ6leEfF?=
 =?us-ascii?Q?BrraumActDOYjvxERZz6c1ql6c+5GFYu8g73oJN/wMjfkBt7fS0GxlUiP3Ok?=
 =?us-ascii?Q?KanBMo1wZBnonaUWw3ZjPwcEuvLSIJPoMfyCdboEfZSabQK67CRqPur0iELM?=
 =?us-ascii?Q?ofDcueZ83wGnSutsd++wh1brDiKY3olGA4c9F3aLTBJFOQ1XWf8rGvqAdUeA?=
 =?us-ascii?Q?lIpuAzXmo8f1m0f+b9mSRu8S/L/4JoZsFfHw03to51s3jDVtI8mSCk32DNa5?=
 =?us-ascii?Q?lbj72zFs896cA7+/1ORc74LR3gfvi2gE9FqzmCHkybd9CLNoIq/wFaKad6/h?=
 =?us-ascii?Q?l+qmyGxQyrxrdZEOzavyOYbi7QdRvyi0TrDo4ahfcW4yxxfVX//dcBZvWEB4?=
 =?us-ascii?Q?i31Bl6Ch0gBV7+ARrFGsjoIh9Hp44yl7D7GZpXMRJ78eCBqOYUwbEHzH40yM?=
 =?us-ascii?Q?E+017+8vjM74xuAstFFaw4o+f8ztgxp7JK3lhIN9s8GR7RnsTOwxtm/3BtYl?=
 =?us-ascii?Q?p50/TEZDeDkzbIl9RuKU6LextxnbaYEkifFBnyxBNXLyKYYDBZRKzo0s56e/?=
 =?us-ascii?Q?bfoeD5zjiCBCHeXm59pStu+Q4TmdTaow1B3cyYnx5gmatBKxbi9xEZPivtM1?=
 =?us-ascii?Q?2ObY0UhIOc6E1R2vOcR1tBSMSBCXBO0JdWpIt0go8OBPZZ7JH4w5SHP2hzu3?=
 =?us-ascii?Q?mP+uibduW7SPW6InwAk6OSPLAJtY5HvWTsKyP+giz/du3Ehc74Sb4heBlnqp?=
 =?us-ascii?Q?tAbaxjgACxM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M36A0jYQrLfuNqQsvAXWHghcOdTAfE4wD8syOOr0Dyxi03e6lvgSVsayxCGK?=
 =?us-ascii?Q?WiRCSdeMZWekEjHiJMgIfcxtDX+JaEWEAoEExFbd/5o+mJS484DCS6fhrBI1?=
 =?us-ascii?Q?1qo9Yj7LRNiiMcgfMGEusCzCQ5iajnuYP51KbBbzI2Ch1VVR1Xed3OquuvSJ?=
 =?us-ascii?Q?o+82lnOfT/FL+VKdQetWrEe7E+ToAmTQbUjzc+5vuiCtOq+P0sqNRoXqR5G9?=
 =?us-ascii?Q?BiIC/GcFIRBGydZ27Ny+1U2JTNwtaT3tGGlwMOikkYMuPDhAjjsB7+LpvP+1?=
 =?us-ascii?Q?fQ9LwOfwqzSpJbD2S7LCksUze5emjRJmoo9o3K13yY+HtZzfwQk5XX4261bl?=
 =?us-ascii?Q?Oaw2SIXNifKel9XkPfiiakjtpcbkr2CfjZI6h29+zl1+zCDjKIevRskXrtx7?=
 =?us-ascii?Q?Bgh9mlo+DXYr13nt5m0VqnzX1gS7O5/AbeZcx2aybUdjZiZz5MbvHc0ftkrI?=
 =?us-ascii?Q?cmsbcY5vSZYAxBngJyxAOBDQf4aBqmSsV8nvWhpm9sSaVGv8AqTNmK99hbwG?=
 =?us-ascii?Q?HqhjhRia3VMltiO5wvQPJSriM353HTb3opYAu5PzphexfvvIqyIHUSCtz1RW?=
 =?us-ascii?Q?a+4X3ksGTpaKNlDlH3LQ7jlzeVfkfMLWbUPldZrqQtMwuqBVjGSsKhVmnwn/?=
 =?us-ascii?Q?XjeE2rAOn9YALvC10nbg3AO2XSboaExjXSJ8TNslDkviH3K1PoMSW5eKcS1r?=
 =?us-ascii?Q?tlC7EIqNjVYxbv6Mp7BDL9w6LSYOTqiEnL+lRpVBCElRrzblinlrr71Lp4oU?=
 =?us-ascii?Q?ENFGO7iFsP8MYjT5+1VB3aZZNAF+GpGpB0tj8HXx1MRMWMXbAktS1HtN4i83?=
 =?us-ascii?Q?Se2aA/nM15iRO1WMv/nccSlLdEDw/2wrjTdPiNr1Je99se95hfgfk2BH/CC6?=
 =?us-ascii?Q?0krkNiIqlOQ2++clo8NxCq1P2zpSGFZBNPZSWNIzZVpBAOJSe5mnjXAxI/Yx?=
 =?us-ascii?Q?46bDuRVclgGZrNIFc1aAgohiqkBpSjouqO1UMJp7zME5ckkhEd/bMfuGkoD6?=
 =?us-ascii?Q?30RHD7RRY6cgnPD7cUYcxylgdELqKlApKzM/n50jSrmcys81kQ64fX6lw8wm?=
 =?us-ascii?Q?lD/znNSeGmBZJck7Xeo4gBWfGNTq73QLR9MTCAxvwdd5IzgAD24AOwZK8MKB?=
 =?us-ascii?Q?2kfWFiYjJ5nZv5s8QXW00bu9MNvK3X0aPOuiECfhcNQgLj1uxtSg6l0zVHA4?=
 =?us-ascii?Q?nm3TujidyVM/ZDjyBZoAReLRb8wq3FBi7SkFP7/5v0lyPw6b9+AdfhpzK4/f?=
 =?us-ascii?Q?/TOA/vQn27khrQXhqU6D+1p3VFJFQnTkbye9mC5vC85uOluKbcf+kGaAyS7+?=
 =?us-ascii?Q?WMx72jMo/lCnH6WrAiSB9PdC6aygN5n1J5b+vknVHiA+9Ty14U4vWRnYrZw8?=
 =?us-ascii?Q?1JF3FHXJk9LeLPNOVSKP97LdqHXFECDeqlGlpvCbicUgymSvUXZTseMP0ECe?=
 =?us-ascii?Q?4oXPHkji08NgPaYudgrXQVNalEtGok22qZbquuZyGrQse7a52F5unk5H7lt1?=
 =?us-ascii?Q?QKbNJZYj+DaiZvBniw8FuiEHX5TtCJIYraZZFwJM5F+XA9r2Vltk6g61U68j?=
 =?us-ascii?Q?mktUVaXJw1ccaFWC1h4Awo3o6/2EHpq49zVWjl0v?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FL7VArh/THdMVYL7PQVSo9BnGRoJg18jRmsF4u/z/s8KTspRpiItKVhIAgWJgA9w+FCBUiq4s7+a4P5meD7pwh94sOkI/mNRuyPO8YAwdrZVP7ei+zBFOPuew83qGycRtg/eDCLJydvvfUBoA4/E3Icmw9OHUL8YVSBUVD6a3SnsNigbWrIicNqrOtOqX1z3dlpOysr9LSkJLd0k1sTy6AuZuBbIgKivyStrdBPrn70TESPUIMrrgSNUnbAPm8d8Az6Ox0tMm+c5Qnnx3zbpfIf6LhaOeBTNeXZtIWImMpOMd3q0aMawfHg3fcsW5kiyt05upffolLPDzkKtxxUzFWBk2MZY0pdMhAIW2e+6q7lOzBVjN4uYyf9G+Rt9VuFfSzh/Jzujhs8oKdUI+SNZUY9mm9ZJjy6PkDC/dBBkLn3qpgtt/IIRxzkHtgbi19DgRXnyTAdn5fepHVGfF0S23WQ9A38GbLKG1FbntJgnU7gr4bAmARmBrdSL3i7OyFIXETgf/Nx+jf4q872a0O8m4/w8mSzECNfMoWhk8a8VT91mL3Ryl/q+D6zpZBNt5FPIWlu8m9epFyoYKtBdhlZ/1G1msVWvLPYnL0nZHL12UsQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f772cf-2889-41bf-ef32-08dddc0e058f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 15:11:33.8904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ROOI0ChH1nUMeBPjhpqeT9ZwfWiBA4k5NPGO1pgBcwTiUWnvgegqh6mTbCNg0BK6z/NBHIx7pTKNwy0GX48TXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5731
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508150124
X-Proofpoint-GUID: nS_8Soe_jdgcefH8HkgUUh3q-TwEOCo_
X-Proofpoint-ORIG-GUID: nS_8Soe_jdgcefH8HkgUUh3q-TwEOCo_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDEyNSBTYWx0ZWRfX9XYZ6a60AjUB
 NrKW8mb5IXPryMmsCWcFbDU2FxFOpMENZN0ygXMNRoGhTTIOjGdePihAHbFtz3ey9+9zRKlzmHJ
 hhObyg+VFnOGpGa4YpMK4leQN8OAOBAYCeIjVwvpS0BUPGU2UpfLDjtA3rMezqkP6M35nsm/oj/
 3w1xeep/FJtTXi57J+aA3gjtpcJqM6iWtAg15enbxZLCtx8+a4Z1mrIPwmDDv+QRUGNbFKgJ9oV
 mEquXklgwyZN7Nu531cvJSDVDM87+NW2mdIwLM0hiLy52/ASnhjCcrmetQxH3LLapluNxdrnzm7
 b6DtDGxjy9lXFSLplC8j3H03Tn0EXgXOcv42hZzzZY1xArodGKbbaySbr183Iq+B/UcycwyEdRh
 vqpog0OwsGQ15vbVRx3MmNHFfFemwJuPzPfwf40yEPKzXndVlSQMyAorwVG1ZsBE8c2jFctr
X-Authority-Analysis: v=2.4 cv=dpnbC0g4 c=1 sm=1 tr=0 ts=689f4e29 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=wcJrYnJmcS420O6A8-sA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: 474EC40011
X-Stat-Signature: afhhgh7cj3ihfhc36d6hr1x7ke1hftym
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755270700-808689
X-HE-Meta: U2FsdGVkX1/R/okrVgysHdAeICtXmlicd8Gi+64LMJaa2raAgzu+Tf0ZhC5DhcDy+JN4tDH3RX+BftbYQQn/fcSx7Q5JfD3gxpiGi4KH+fQ9a0LUU3SfJtKaZk9DrxlLmA/In7Y3/O2b7172RsZdGzIx6GEiTWDLumBvT12kn4PS/q/SoEpPQ5mVTrbU7F4Zc9pI6dxExlF5Wkvk0JtTkrIX3Q6In5JsXJEKOplGL6vWjbtOMJ2N1LJNhhJbM3ByOh5ElQYFMsIZFNYSqvDttZTRYvUCdmnc1zsJ54zMKsQfyPSaY8bS5cbW2xms2SvU8V+OJTR1yikncU3duSSoviYyBfteDQHY+ZrT2JDLvQqEcz1jagwYV0dKcLX39xa9Q3FUK8XMaN+n9pewifQIH3x1vdhj/xa9VIHc8IDSxCm5cb5Oo1lPxs2FOz8YDhpvD/7l3KM6JyYFNI0s1Q/wFrRmaWVrlVHxUVVkrU2ozFryFpkNVO2sgZDbA8krOwFVM+bo/i/9aD7U3kobxRezEA21IrVdu+2CHXtHsCnJAfjhqTyfmQNUujAn9NYMoGqxa24U8MZc+GcmnlfjN6MDuSjTOjEqxyCpq1l7F92WquuLDHa+WRowzKyleDe+ZFqLUFwgsk87eCzDOLb7iAxN3mslw09DdcRFgE1ZK3Z8XPNDLms/bX82NEkhCj2BKMWY9vVMK23SWbOT+4Uvn44NVG2eZLh6SEHLsUVmRB8AaS+gnsMDve14Csxm4BdLP2jKYVm71YkMekPg4QAlFsvRwqb+Xly/vyTn9D1arThlRenQ9kM3EfdO7v1/htozmVw64xh6zIJwEf4kfAbx7rutlElaVVUxuXMaKAPbTAXwckVdKj/8WbFEdJskhtQIkw1ZKL/UasBFfpyMlLpn2ztitQ7JRMRU7ux7XCzyaonb8KO0iCftGj98K2oL6fcRJs8ZuI9fLsYWvo+GCwaxIS9
 az2QUEwG
 PP8PdGi7WUeAlsSLcaScqF14uoLnXocjyN0QDVLEKZK2I9WmuXhL482RN9xEn0MpTPlC5TTLf/e/71zxXfVvkOWhioXhsQrrodLv0hS7q6LPunCjfog/qHbAvZtqPQ5dDeP/Q7Drn+sCkTefliUOXKZ3w6NGlx3gPTHfTbWHZq3NvUZbUoycHNMfypNIR7Upy03m5rmD/FAOawQpcxNS0s3vPX0MdJFsXVlD2Dh3xx6bL+hF6Z/URJs6oic4+m+K+EZS6gZs2v8mUqkqVa4Bivzs6J6wLMzvYNgFLhV+snI8W6FxUsuVTlfd9s8QSyRLiMq+fWnmX/tVqmsfXDh9VI8FAeq7y1E1WWdxEqgDlh2D8cHQdfMXwM9t7QKLtdgvTaNXyLakDvYf6dr80IqqLaL2NCW7fE+2M5U7z5oTZeyDNUz5zL++wtVtDLoXr+Fd6NCWdf/rqLPKvI86BpBxYRek4XwebFfXVIW7R3SNGKtCsvjuX1X3B5jmZWIVsf+ndOuVeui7wdwg/lrj2jM3Laks7uJFCnYCUgok5/EaCOH6NhCWqoSg6zCyXuyNMeNbsAtd0SSI9Kjkm+x/3wz5eTJnB+icgtRxEx/W7hrRryeU/v2OBhd/jqmuBPv+2r3WLi9kHAth0k78zQk7PNmxu8/fFibySb3ZYZzL1rPwq4GJA1Fv4NxH0VkdvY8NdcfGQl3tMF9DEPOB0vAFGCMZEDQBLC5sUbu69eo92wLrzzBHzIpulxSaDeIMlDq9geUvoRq9uyiPRKYwr4rBWNRhDMCw6ppuvhKQmRXS7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Pedro Falcato <pfalcato@suse.de> [250812 12:21]:
> liburcu doesn't have kfree_rcu (or anything similar). Despite that, we
> can hack around it in a trivial fashion, by adding a wrapper.
> 
> This wrapper only works for maple_nodes, and not anything else (due to
> us not being able to know rcu_head offsets in any way), and thus we take
> advantage of the type checking to avoid future silent breakage.
> 
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>


Andrew,

Please drop this patch set.  We will have it go through Vlastimil's tree
to avoid conflicts with other work and to maintain the userspace testing
in mm-new while that happens.

Thanks,
Liam

> ---
> v2:
>  - Move kfree_rcu hack to maple-shared.h, to fix userland VMA tests, per
>    Lorenzo
> 
>  tools/testing/shared/maple-shared.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/tools/testing/shared/maple-shared.h b/tools/testing/shared/maple-shared.h
> index dc4d30f3860b..572cd2580123 100644
> --- a/tools/testing/shared/maple-shared.h
> +++ b/tools/testing/shared/maple-shared.h
> @@ -9,5 +9,20 @@
>  #include <stdlib.h>
>  #include <time.h>
>  #include "linux/init.h"
> +#include <linux/maple_tree.h>
> +
> +static inline void free_node(struct rcu_head *head)
> +{
> +	struct maple_node *node = container_of(head, struct maple_node, rcu);
> +
> +	free(node);
> +}
> +
> +static inline void kfree_rcu_node(struct maple_node *node)
> +{
> +	call_rcu(&node->rcu, free_node);
> +}
> +
> +#define kfree_rcu(ptr, memb) kfree_rcu_node(ptr)
>  
>  #endif /* __MAPLE_SHARED_H__ */
> -- 
> 2.50.1
> 

