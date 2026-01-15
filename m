Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 294F7D4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CEBB6B00D0; Thu, 15 Jan 2026 14:37:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501816B00D3; Thu, 15 Jan 2026 14:37:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BDDD6B00D4; Thu, 15 Jan 2026 14:37:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09A7F6B00D0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C12291603A8
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:34 +0000 (UTC)
X-FDA: 84335207628.01.8EA22BD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6C40F12000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LtXLaHGf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uHeWMfYV;
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ahrIF3iuRxe15ApaD/d06uzPS/De8CuIODyoNbl9QY=;
	b=wlz0k6OC4cpul75Ab8pPj93/D7j2K2V1DMiJClJayxE9ruhYvscNKrd2Ag8K6rWOmao63g
	wPzxtdsEgMzCIKIU/6hZX2yYpu4TaS1osLXveDXdJMJHVyzRcAZK2DIg3eMsAqVLBo9FNH
	lcYTzMvrzd5lNGrkk2DtWbIQWfyajT0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LtXLaHGf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uHeWMfYV;
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505851; a=rsa-sha256;
	cv=pass;
	b=AvMiyROURabAf7JlE3yv4ayoPLFXW1MX4xYP6yRORKWXSApRWhn9/4Wkhz81Z5oYuPj6tF
	q9zrrpznYY6KnPa9T2in/5hUTLrVYh/mPuPCoOn6cNZAdb2sV9Bfinv6ZimEE1FNpyjBnX
	UeklSYEK9/LydHSAKnSutAbfnGUfcgE=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FDqZao2812228;
	Thu, 15 Jan 2026 19:37:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3ahrIF3iuRxe15ApaD/d06uzPS/De8CuIODyoNbl9QY=; b=
	LtXLaHGfJ3E2lMMZEcmeCPCjaEKui1Us9xtK31t3GCb95h2+PO1VaNPl29EeUtUy
	fniYgSotVu0bI35vFI95ZF9qeue0l2rwQGmV6xJ4s9sbJUwcrDgCr/7aK6xQZG/7
	umGiPG2lHdeU/IJD/T6kvaMJf5t/4BmQfSv0lkPbgC7GxEEZS8H5F5DX7uttHgXQ
	0+g+Ei9na4rSGvoylta2FpS+Emf6VNjopL0S+sShkOKbhcWAFM+bKXZBiamDF10B
	gpugRatZdB0TSF2tmg6sxNqZdtqE50JoSuVdT9F6/ff5uFgv4BmZK2/zo3y9YaH5
	b6m1h3nJ55vgTDKymQTe0w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nrnqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FHx4Pc004278;
	Thu, 15 Jan 2026 19:37:23 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010023.outbound.protection.outlook.com [52.101.46.23])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ngu9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rJV8H3iJwH4mC+M8FukjiriRoUIIL3R6tTf9jfIjTl9bWtoccxSJ1Kb/c5uHomi2660+GAqAFH9CD7yN60JppuP0WDKeyfcBRZrqwdou9NVQqsj5HYOM1+6Yjdv3zq7Lx90f8zbWoI23WcjRfcL7xLRQbACn25QJ9L3jMSkjR4xRK7CPTjx7pBOB/NwlpO65gqjedi6pVj6OYzO9xBsY5XojGYggk/o+Dx+xUZu7eZHBvSab8/mYfAFJ4zv4uaVx3H7V+RiazYt++X3GGmE5e86Gqv4iJqdHdAawyL0D5rGQ5h4jBMBvuazaD5trBP50PC4Eo1AH2BQ8JPTqVMYXBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ahrIF3iuRxe15ApaD/d06uzPS/De8CuIODyoNbl9QY=;
 b=c15fKFFMtg+k601M8WFDwE76feVnSvF8/KapcsKmy9h7nuBcNMeS3YesgigfehZu4Ty9Sdjhv3Jfl5WGzMgScorXPEoK/nqAJyUhFsLza5u1DZBAlDKFzDDXKlD0zEUwo+Z3W9H6NRnvu2ZpNWXvNvumcm9sByiulVp85WYC35SeBRd21wNOniqbZTDFy1ZYmKLa4ohkIb+NyRqBpchXmtZlNS7FypVly/npecb1oyZrXOvhWPaNnQm9pTg6TeyIHVFKM1vZ7dE44uyRuPytt9b+7jZnM/NATdM5eEgk8epN+3mgCg3QUrJJT6CPEm+VOgz0sxIohnHF1pveSmFyDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ahrIF3iuRxe15ApaD/d06uzPS/De8CuIODyoNbl9QY=;
 b=uHeWMfYV4lDwD4X686amnwb8Aklzh3YFcOJEyI7K0OeRq7s19W4dDjUv4w7pzNFn+DSe5pGQx1hyDq3juuZNHbx4lYu7+dBf2XBwegKH9y/T/hX3fe2C3qsS54/3bXRMMfg1QMDWPoWk3onBEkEgk4ruLj4v9guRffAu244BEGo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:20 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:20 +0000
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
Subject: [PATCH 10/28] maple_tree: Introduce maple_copy node and use it in mas_spanning_rebalance()
Date: Thu, 15 Jan 2026 14:36:29 -0500
Message-ID: <20260115193647.1695937-11-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0231.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c0403eb-a1ce-4bce-ff51-08de546d7f55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QRtFfgTvuoSOS2CXiMA9vPwIDFLbLzlG7N7MlGykxarndWZuTxjajOwPRGZl?=
 =?us-ascii?Q?sOHQvXqKGahbUDjSpJdJNxSVqAzUYR3u5JtaK4l/80t+xlfjI6he0XDoB0VV?=
 =?us-ascii?Q?ezBdWouEj53RCeFUxoXab1Q7j/R5QZBB+nJjjWXc5FYpuMhE+V00xJV+Wm32?=
 =?us-ascii?Q?XTWFvCJT+UQLVKT1EmFRLVZUTdoCMagkkiXtNy+KvMVB5NHrHsdZ+GH5/9/j?=
 =?us-ascii?Q?+zJu8Ff3rARfZsOJWWdmQO64rhZUFPuwMbkG3ENU26zGKaUcxhr2+2waZuTT?=
 =?us-ascii?Q?yKV2Y6uwfEILMvyHJNU7BvHuQ1xhzQ5NtQMjyrZoHP9R0ePl94jpnS6ZkIqr?=
 =?us-ascii?Q?jkPqqIaIaqfzZqnox9Kqkcf6xayLn/Me3Da8yeF9IFsDV7pUUQ6hAHuyaeLO?=
 =?us-ascii?Q?qoA2PGNO6PBnfTf2ouhYpKXUZ8bp28FIY4vH9t+y0n3H8tyrPW05u7Eciag9?=
 =?us-ascii?Q?1/9Fzugw23IbM13d8T1Qb7xTmt5UZtdc1pg5nYF6ZurpulyJ8W/98CvTKAZ+?=
 =?us-ascii?Q?JDupe7vPj8Ybxjqx4FJ8Z9WBHBwE9S338LK0AhHF2AAdH3GZ1jilUXPKawiW?=
 =?us-ascii?Q?sCk+sWYCMkB+isz3szpmrGfKiuBy3xbItParry6jyfkWHSZ49gbudodFB8p7?=
 =?us-ascii?Q?sYaRRwvBmkuZ7vgeS/i1FCi+udu2xNg5KIm/uKpZ8MzwDXjb4zCrauBdL/zf?=
 =?us-ascii?Q?Z3bpZ9XszFFToVBDLkiU1O2CfN8hdGJucp5wbBSVzqs5Vqk9s2mdmFC0WgXR?=
 =?us-ascii?Q?6LlIK3aVTVbbPJUnMVPLImlwanBLTHs71pnFrUxSnH2/NTjU7B7CyGHhLOE0?=
 =?us-ascii?Q?WCy8N+HLHHDPhJMAv6CoByBRdDJ6YPtnl0vbaYuDSLqyCzC8zNR1s+wKS3Fi?=
 =?us-ascii?Q?NYo6fzB1U4UM7j0wP4jQYVLnxyqLRJiOsOQT11lsUNEfg6ObW5XmDIxG+Iuq?=
 =?us-ascii?Q?sNPHSm5cYchPQN37jiK81mfdcT+6h7oEAvArAPtYYAmQ3fKye+NJtgRTuTzd?=
 =?us-ascii?Q?QGzRBZF0TgMwCFMhjAagMo/D1wZjFhMOkxU5c9do3pqlBFKR/lPaKxBRLxJA?=
 =?us-ascii?Q?WMwExSG4Vei0xvdwQn1PPCXriGoEY73aZrXHOiTonSCwpF8uxBoD90xhpY6+?=
 =?us-ascii?Q?l/J3LgErBEVJcf0bnbvJ84uaVXzR05uEpR2JBis67ddgntdBtDmAAupXsgt9?=
 =?us-ascii?Q?JV/toWAn1CKrL+MwrY2v5omeZQVpFOGj3991lCXIjZ0+GE9BaN1waYubhg+a?=
 =?us-ascii?Q?/5LUIhv9h99jFEnYwlux50ak35x2u+VbRJK5KgWbpWDUD87nyNRC40NkYsS5?=
 =?us-ascii?Q?TUkmYT7EWF/utnrjEk49r6NrQiMShmDFv6HtJbw3V2jqeQKQVpFFX4XqR+CP?=
 =?us-ascii?Q?a+fWI9ct6Sc4APx+6sGogYUsL329ZWzCV2+tZ7C/HMc7RZMiL1gLdd+c44l+?=
 =?us-ascii?Q?g7Ri+WImD7sGAKVex5VBhk1ziRBNXW4j7mPaIFGG+UIEAQDUswY5iH0mjx7T?=
 =?us-ascii?Q?j7BLN8HtAaywbhGAuWQpHbcv0F5rzWIOHKIwE0G/QqpkGHwVltb79t5BK23m?=
 =?us-ascii?Q?aWreSLdIr1HMxtSxnos=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ws9FnejlvJIA5JbkNT73KuTD4Y8NWloDXx3Qid7TFgai1EppMi89z1HX4Cty?=
 =?us-ascii?Q?qOvdFIkXDY+NOAmiYJN1NYSECtqmkhQW/DyDT3L4lkSNmksteOxL4tvZ5yQd?=
 =?us-ascii?Q?btpY0YOUF0Uk0iODqXMSv223UalgDCYBIbNXVLBEgiMsGigN2jEH/lQg//pn?=
 =?us-ascii?Q?4p95u5nWh9qglwUlnYIjwWvt4cQo6hq3VPNB8yky78rrf6sYPo9l0v7LDqjr?=
 =?us-ascii?Q?qwBaysO1nZiq1fze5U35qM++4y8HBuyM61Rv/0AJFq00KO8P1K8i/X45Zpst?=
 =?us-ascii?Q?qDnoCOPj3EFS7rzTVDDiqnsiCZu9/ct1Hxi0SbQITDHXLAVGynwoSepknLGf?=
 =?us-ascii?Q?peSefRFLbbOTw+k/EnOvaQZGpXyn+6zqVRVV6wuOx01pxdKibcQ9Hdqq6QMG?=
 =?us-ascii?Q?SoSCEo6uZuQxnZjGubGowmrGIyjs6iQd5g2XCDEgFWjWjCwFexi1uuN6zqCj?=
 =?us-ascii?Q?rW/3cgt+zRZvoJs1g0BGCVLopMNHPw5LNNtgy8VResFsQKvwogV6XZ52oZ3W?=
 =?us-ascii?Q?brGIwLWZUrhGaKSJjEaVjhVanrQx+fm10xiSBJFmCjtAHM9xVi3vY0+7Fgws?=
 =?us-ascii?Q?4Q8EV1Zjdgw1m/C/zNBphn0eeZTQU1g22NoncR1TaqndA0rw6QxU++qE8BFS?=
 =?us-ascii?Q?y7jD4wVFtY0uKGtG3ISEJXUDmEYZy2ciZmb9BPa06B75XcTAtqIOImUTVdLW?=
 =?us-ascii?Q?kTCJtmymVJ50eEuUI/ywhJfci+QPPwzVCZxVKQewibxayB1qqsmaNNAbMXhA?=
 =?us-ascii?Q?N5l2Xdo7+mwYY2k+12bnkB54okLX5d4L1Rb1EdMMsFLACRLqgO2qffZtzTjT?=
 =?us-ascii?Q?ccMPytQThgU2lGhDNNW9kuPw/+fIs8Cxp0ZTLaLJJXpQ13Ja3TjvpxnY4p0H?=
 =?us-ascii?Q?lpbx50rHRU1rPFKj7VflVbBDwUP1P7/Hq+Fl5uERdNmvjRhkNOpOzaOAxuMi?=
 =?us-ascii?Q?xw8XSFstoForzApxPZKY986h8lc6iF20x2quPbOMw1MMzjv5aHZTtzvaRq7D?=
 =?us-ascii?Q?LGipWjy8XI98b9qeWkgkV9DJ8DGJmY8LswCpSyzc5JJNP0r2WUjULMToVfga?=
 =?us-ascii?Q?zLknVzyw92lhn2ZJscsOQ2bmn/pVRxOPCig2EFuZ6Je8JQz7J8JR+N4tNclh?=
 =?us-ascii?Q?jlfBIKlSMMTVUZ7SKiNwNfml7hv5KqRa4ajAAflzMMwf5MNVqUv199Dh13i2?=
 =?us-ascii?Q?rZQjKo1XkuVm8EMrZiubtLarhsYG9ZpagQPpdEPZ6ysBh8P3Fha5T0bKuBMF?=
 =?us-ascii?Q?IICZG2qvPthy5wVdTMzhu8LxilO9faGO8VO8qHTZJuGwCAojC/HbiY8XVYdQ?=
 =?us-ascii?Q?o5SnHXEm6BNPLdOHXo9vApJXFygivo/7Gd3SkoMjYclnHgB4m2nmzaOJnxAe?=
 =?us-ascii?Q?KiO8+0qhr9ZCYiZCjX2FjX4F6nbuiDL064q0f5R2WYf/IwEuRZbjHDy2tHsh?=
 =?us-ascii?Q?7gskFGtE2uPQlM+fKmXivKR5uqyl4SL9B667o2vWqeabOlBePJIOC7kXhj9w?=
 =?us-ascii?Q?aaStaFvMF4aHWade1W7outwHrPovQwZSgC92uxqJCWOdljOC19TMeYHFUMyw?=
 =?us-ascii?Q?uMtoMZhfhd6zBbFSWpQOhFl7/ASkGXS7nVGVih/XES5vK3MvvRydur5AZub9?=
 =?us-ascii?Q?ecXoxicbH5tVN9vTWSO7oB2QlFmP9j1aE6g6prIZU/GIqDJwb91mDH+dyXQ5?=
 =?us-ascii?Q?OXeyP0HBxEQ4MyS4IoPHeeytbk80u9mSPjc2cZMr74W6WXo700OigRDh9aVR?=
 =?us-ascii?Q?el4NGO7Jpw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	buGoWBzl7u0N4TL6vKdFiBOOdiiUYlsAfJrokLSjecybKMtz/Kb+vrbbYNQ9bYGVnqcnhtxhWRuuRarttJYtwUHivVzoG1Av+wmWcYQ30ltyDEdg4Vaye5O6euVN7lsB4SAorqmCk7AFbE1WwjeF4gej/g2rG6gXgcZaCUjA3emB1S/KdMV1tjDOCfOJ+4E0hLnQmQJmB+zpXQa3jEHeGUE3tsJh14JBHcQsmW/a/DlTsQugHoDl7jSn9e5VyqonLxjOJNlaV9UI3xz90NsaYkbZLA52ywdOwuwvqZVMguIKc4UkADbxAv+p123JNdgq6VHHp3k5Er1IwPUNJPX+CjKmfB5jUm6aqvMvAnBhN/Pu/d6oqn1RbpmTkwa5nwigcnRiRX4hVpyZBm5Y5igj9hSuUUafeUEHEYpzoCdmuNs524GjLU+EBaswdQ1VTBrsq2jHAilTaC5upa3B9EsyYfSDMLBdMqviHw8nTuBRr4wpUTHIgtF4DpKwbdzQuDAtBlkWmOZgMWbwvw3+BlDeEFY8HMrdd+ARiN6gE8OQgt/HwxEMpd1nlcntZm1kZDbb21LYKt4CtOpXc79+6220v/IxB1eXCVC/p8NfSKX/SLM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0403eb-a1ce-4bce-ff51-08de546d7f55
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:20.0269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K+VX9pJNfciwK4HCuDEzFzPCDgSczEJ8OMzsOgqIViTy3veTclcyXMUKuNRHxyAg1fCzNWxxHyxVaj9n4Pzw4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Proofpoint-GUID: XSbBkUdelEHEZC7g5mk0RH8qcjwOqIdx
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=696941f4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Fk0WoDt32--Uo3WLaF4A:9 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfXzEBAEoNyUCe9
 sI/DMUIoD9JacryndCfLyLoXhO5E8UoCNUP1pLVE7w3YpIrEpKP7QwBJtCWUiFQLC3LLzqoLk6o
 dcyes/7yfZRLfE9Wj17NLk4wJs5RqnqkxVJ5xgLp3axxgHv/rfIH4ai0GadUSFJcCpaNV3sdS2Y
 eea46KXmX5RU+cakt9Y+5n16LNhEBBR2NFeNyIIqbFiGz9gbcnvqzRlh1sdw7LkMe+VG+E2B/Rn
 NLmt8QT24zCSMmmUSaEWULhBCAxV+RO7pKXO6VOu1t95Tt9yR1IogD2MNt6zo+Hg5iV5MjNNfH7
 N2jSoTKoLPFg9V3fB/FHesV6QwpLAmz61VfMya5co35BSmTG0Sfun8jSZ2rQ2d+jPvi7WoR1RrR
 DYjjZJgVPOxhO95xiax0N5O2s4awBpS7Li5Ocxxr69lulSyiCIaQLQq8VU9tNhQ3+brupI3GOxH
 oxnune/fTns835KtJNxab/Si8mXdXMkeMnRjRQ0I=
X-Proofpoint-ORIG-GUID: XSbBkUdelEHEZC7g5mk0RH8qcjwOqIdx
X-Rspamd-Queue-Id: 6C40F12000C
X-Stat-Signature: ouotirjmoisitzfe469qbazw88nntkmk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768505851-504062
X-HE-Meta: U2FsdGVkX1/R+JMEDpUb9GWo866k/MR5YOJrWTaolpQdzb+A2S+dZEpoQNSwVD8T85h6gb7sLgGFwFc1mnQaTldYWmIjS3l/8yd+luAvo3GK+NTKayeOoYeImW3/rquSKEgnl+vfvslFmfDqaT8LSIL/qJOubR8FZ/7FjVR9tJwVqTqj6woornSKNqwNc68BrlQlptvwsZLBcfDi51C5ey8iZCFB4ORtsbQHtfTyn7/h9ne0FSLCavHu9PuTf1BKjVqvUWim8ucVpGXU+jwBwlo3pZF4M2OIOAFN2wQ724K8LqV7XJvZuk4j9AfHrtphv8ttc0L5VnmtZk+ie0CB2qNrRE9DSU5yzyL3X4mQlfPUCesq1PCbHr+jldvGiovuTxfPvVYQF4ltsfBm1XrTN/BZL4+bS8mF3Aen7qu542swaMVN7/EyHkMSng59KyXzQwnQ3XvobK8z5FcWhCtsBdMtK9GdIMrGclb3IwIn+6IeWFKvbt6KrjTkYeDXrsceZbBcgv+EDyyp9ypsib+WXgQ8FNiSzKVrp0042MKt2+EzkLDsP8WDfU6hq3Ey3E7wZ7et/eGJeZBRxkPvGYktvbNObEU+YDpUI4E1kVCwg+P00xKfVwLMPGFLCGjWUrUWpG00H3Zeohx2kkiOOdxJmUFLIuyROp7WsLH0goxi+qhZxMyzCD6zssQ4aqqEJ7CJHdCccOHsl/p2KGvT88CyHqTeLyUVzB4JvYqmPfCgxj8f7XfwnnzO5hV5HXDzJczLgFa4UijMfA6HStvkv64EekKPcvbaZuUcxHPBMr78ibO/C7Dac4hNkFrD/9YQO0Iwe41VJI/aUAIG53JkuUTgR5nO3d8jcLQSwCkAI1ys7vX0Btyy4cLA3jkAlblsOi2HSnrVCzvBHXYmgFycA7SohGDFHhL+M7eUYwgYDoOjUInRNF5STXmjgNjFFtXk3qygZ9v7MmOqJNxP27oZPk7
 nrDuhabB
 ecFKqFyn0IGi0DBOL8IKSLYRrylRXZgfOnh9cQIhz3GCmzNBx6ZD0BCMVDHBfPt4wiOytwfcPFtHp40CsqeHIPe51LmyEblNTOC9yXPbCqfn/dZZH/jHzWiujCiU8FRgxbMGRKNPKXtBSnZuAxNbDJjnX7XOf31KlqxDu4ykDL4tGU2TZIuV/oNgXqyG3K+fhLubixeZJEHZ/g5H25+RDotidcZXHeItyIVyXhm3Fhj1ygi2cLlsmDA2gfG+t3wpPJLEY88yn3IkbTb4jWjAKERmt7CqOuFsrr+oT9mBhDggbSsciJZ5/mkvPGd8JNXEbSPqidDpaOEDmYkxAQXJE95g87hWRPaduo1dk5ondBJjhtLFE5m6PMxsMbz46A/LhJPzVzEFuMBgPCGo8/ghZZPojQRAFFg4/45VUBcYHu2FeDsEQzDIOxMPDsuQmsk41VuVJiQ5nciTbsci0cnWKv47tiAHWWkT3av7H30quLejG7i8eAIv7oPrLqaxMNYI5NgPw3suoPqRtNied1eU1f75FNcwVu+8Xm8izP9NFai7Yq5w3mjKRdQQHkyu5LjQnGLIQbhM2fe/WMFPXdA6qNrpxz47iva1OuwJSrXzhjo/89THEvvPb4yZNkEiAYFnR39FaRqaXdtn/KeLaoE9cEYdfvCD+YoYlwnldyULkoVnfy57M6SdlIajTEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce an internal-memory only node type called maple_copy to
facilitate internal copy operations.  Use it in mas_spanning_rebalance()
for just the leaf nodes.  Initially, the maple_copy node is used to
configure the source nodes and copy the data into the big_node.

The maple_copy contains a list of source entries with start and end
offsets.  One of the maple_copy entries can be itself with an offset of
0 to 2, representing the data where the store partially overwrites
entries, or fully overwrites the entry.  The side effect is that the
source nodes no longer have to worry about partially copying the
existing offset if it is not fully overwritten.

This is in preparation of removal of the maple big_node, but for the
time being the data is copied to the big node to limit the change size.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/maple_tree.h |  26 ++++++++
 lib/maple_tree.c           | 133 ++++++++++++++++++++++++++++++++++---
 2 files changed, 150 insertions(+), 9 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 7b8aad47121e7..9bc7fa89bc2ee 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -139,6 +139,7 @@ enum maple_type {
 	maple_leaf_64,
 	maple_range_64,
 	maple_arange_64,
+	maple_copy,
 };
 
 enum store_type {
@@ -154,6 +155,30 @@ enum store_type {
 	wr_slot_store,
 };
 
+struct maple_copy {
+	struct {
+		struct maple_node *node;
+		unsigned long max;
+		unsigned char start;
+		unsigned char end;
+		enum maple_type mt;
+	} src[4];
+	/* Simulated node */
+	void __rcu *slot[3];
+	unsigned long min;
+	union {
+		unsigned long pivot[3];
+		struct {
+			void *_pad[2];
+			unsigned long max;
+		};
+	};
+	unsigned char end;
+
+	/*Avoid passing these around */
+	unsigned char s_count;
+};
+
 /**
  * DOC: Maple tree flags
  *
@@ -299,6 +324,7 @@ struct maple_node {
 		};
 		struct maple_range_64 mr64;
 		struct maple_arange_64 ma64;
+		struct maple_copy cp;
 	};
 };
 
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 8cefaebf414d3..8927e8e1b8012 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -605,6 +605,8 @@ static inline unsigned long *ma_pivots(struct maple_node *node,
 	case maple_range_64:
 	case maple_leaf_64:
 		return node->mr64.pivot;
+	case maple_copy:
+		return node->cp.pivot;
 	case maple_dense:
 		return NULL;
 	}
@@ -624,6 +626,7 @@ static inline unsigned long *ma_gaps(struct maple_node *node,
 	switch (type) {
 	case maple_arange_64:
 		return node->ma64.gap;
+	case maple_copy:
 	case maple_range_64:
 	case maple_leaf_64:
 	case maple_dense:
@@ -690,6 +693,7 @@ static inline void mte_set_pivot(struct maple_enode *mn, unsigned char piv,
 	case maple_arange_64:
 		node->ma64.pivot[piv] = val;
 		break;
+	case maple_copy:
 	case maple_dense:
 		break;
 	}
@@ -711,6 +715,8 @@ static inline void __rcu **ma_slots(struct maple_node *mn, enum maple_type mt)
 	case maple_range_64:
 	case maple_leaf_64:
 		return mn->mr64.slot;
+	case maple_copy:
+		return mn->cp.slot;
 	case maple_dense:
 		return mn->slot;
 	}
@@ -2595,6 +2601,103 @@ static inline void *mtree_range_walk(struct ma_state *mas)
 	return NULL;
 }
 
+/*
+ * cp_leaf_init() - Initialize a maple_copy node for the leaf level of a
+ * spanning store
+ * @cp: The maple copy node
+ * @mas: The maple state
+ * @l_wr_mas: The left write state of the spanning store
+ * @r_wr_mas: The right write state of the spanning store
+ */
+static inline void cp_leaf_init(struct maple_copy *cp,
+		struct ma_state *mas, struct ma_wr_state *l_wr_mas,
+		struct ma_wr_state *r_wr_mas)
+{
+	unsigned char end = 0;
+
+	/* Create entries to insert including split entries to left and right */
+	if (l_wr_mas->r_min < mas->index) {
+		end++;
+		cp->slot[0] = l_wr_mas->content;
+		cp->pivot[0] = mas->index - 1;
+	}
+	cp->slot[end] = l_wr_mas->entry;
+	cp->pivot[end] = mas->last;
+
+	if (r_wr_mas->end_piv > mas->last) {
+		end++;
+		cp->slot[end] = r_wr_mas->slots[r_wr_mas->offset_end];
+		cp->pivot[end] = r_wr_mas->end_piv;
+	}
+
+	cp->min = l_wr_mas->r_min;
+	cp->max = cp->pivot[end];
+	cp->end = end;
+}
+
+static inline void append_wr_mas_cp(struct maple_copy *cp,
+	struct ma_wr_state *wr_mas, unsigned char start, unsigned char end)
+{
+	unsigned char count;
+
+	count = cp->s_count;
+	cp->src[count].node = wr_mas->node;
+	cp->src[count].mt = wr_mas->type;
+	if (wr_mas->mas->end <= end)
+		cp->src[count].max = wr_mas->mas->max;
+	else
+		cp->src[count].max = wr_mas->pivots[end];
+
+	cp->src[count].start = start;
+	cp->src[count].end = end;
+	cp->s_count++;
+}
+
+static inline void init_cp_src(struct maple_copy *cp)
+{
+	cp->src[cp->s_count].node = ma_mnode_ptr(cp);
+	cp->src[cp->s_count].mt = maple_copy;
+	cp->src[cp->s_count].max = cp->max;
+	cp->src[cp->s_count].start = 0;
+	cp->src[cp->s_count].end = cp->end;
+	cp->s_count++;
+}
+
+static inline
+void cp_data_write(struct maple_copy *cp, struct maple_big_node *b_node)
+{
+	struct maple_node *src;
+	unsigned char s;
+	unsigned char src_end, s_offset;
+	unsigned long *b_pivots, *cp_pivots;
+	void __rcu **b_slots, **cp_slots;
+	enum maple_type s_mt;
+
+	b_node->b_end = 0;
+
+	s = 0;
+	b_pivots = b_node->pivot;
+	b_slots = (void __rcu *)b_node->slot;
+	do {
+		unsigned char size;
+
+		src = cp->src[s].node;
+		s_mt = cp->src[s].mt;
+		s_offset = cp->src[s].start;
+		src_end = cp->src[s].end;
+		size = src_end - s_offset + 1;
+		cp_pivots = ma_pivots(src, s_mt) + s_offset;
+		cp_slots = ma_slots(src, s_mt) + s_offset;
+		memcpy(b_slots, cp_slots, size * sizeof(void __rcu *));
+		if (size > 1)
+			memcpy(b_pivots, cp_pivots, (size - 1) * sizeof(unsigned long));
+		b_pivots[size - 1] = cp->src[s].max;
+		b_pivots += size;
+		b_slots += size;
+		b_node->b_end += size;
+	} while (++s < cp->s_count);
+}
+
 static void mas_spanning_rebalance_loop(struct ma_state *mas,
 		struct maple_subtree_state *mast, unsigned char count)
 {
@@ -2750,10 +2853,11 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct ma_wr_state *wr_mas, struct ma_wr_state *r_wr_mas)
+		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
 {
 	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
+	struct maple_copy cp;
 	unsigned char height;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
@@ -2765,15 +2869,26 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 	mast.orig_l = &mast_l_mas;
 	mast.orig_r = r_wr_mas->mas;
 	memset(&b_node, 0, sizeof(struct maple_big_node));
-	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(wr_mas, &b_node, mast.orig_l->end);
-	/* Copy r_mas into b_node if there is anything to copy. */
-	if (mast.orig_r->max > mast.orig_r->last)
-		mas_mab_cp(mast.orig_r, mast.orig_r->offset,
-			   mast.orig_r->end, &b_node, b_node.b_end + 1);
-	else
-		b_node.b_end++;
+	cp.s_count = 0;
+	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
+	/* Copy left 0 - offset */
+	if (l_wr_mas->mas->offset) {
+		unsigned char off = l_wr_mas->mas->offset - 1;
+
+		append_wr_mas_cp(&cp, l_wr_mas, 0, off);
+		cp.src[cp.s_count - 1].max = cp.min - 1;
+	}
+
+	init_cp_src(&cp);
+
+	/* Copy right from offset_end + 1 to end */
+	if (r_wr_mas->mas->end != r_wr_mas->offset_end)
+		append_wr_mas_cp(&cp, r_wr_mas, r_wr_mas->offset_end + 1,
+			       r_wr_mas->mas->end);
+
 
+	b_node.type = l_wr_mas->type;
+	cp_data_write(&cp, &b_node);
 	/* Stop spanning searches by searching for just index. */
 	mast.orig_l->last = mas->index;
 
-- 
2.47.3


