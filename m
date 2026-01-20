Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD04BD2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 11:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2266B03C2; Tue, 20 Jan 2026 06:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39A226B03C4; Tue, 20 Jan 2026 06:01:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2727B6B03C5; Tue, 20 Jan 2026 06:01:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 160FD6B03C2
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:01:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B4B6A1604AD
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:01:07 +0000 (UTC)
X-FDA: 84352050174.02.22C32AF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2A85F1C0014
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:01:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZZOfXcM8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QJp0WfAI;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768906864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/N6biiTu1+6D4GtCHbIYWL1qEFR3ikF6cUWJHEr4VMg=;
	b=x8jozFwndwMtEPwYdJF9/xZGwP+QBFekjY2o3U69BtOj6pLvgGa1oDkKmaETfbet1tcuS/
	lIq+SNFZgGccY6S/U+1MrmlMJiNnZIYAuC3pexILTthHyqf3aE2pCoZ7yGUv70MEXOWxs+
	RBvKXWSSC2OPAnBrZWg/z0LKNxbP8Po=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZZOfXcM8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QJp0WfAI;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768906864; a=rsa-sha256;
	cv=pass;
	b=YwP1eh5YEwtlJuOrHqnQzuOUVmir1COk6WuQEgoFezqtja58nT7igSFh0lJETV8l9VlsdH
	s5bSCxyhHdBfoYHIoMp3zSZKeUwcBiVvqfrFBLox5BDOlx2wutW9IGz7JyJV+H6WW/GSuy
	cYB21K7fF454B3GVyokxa1eogFJJW3g=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60K7vBuf3032109;
	Tue, 20 Jan 2026 11:01:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/N6biiTu1+6D4GtCHb
	IYWL1qEFR3ikF6cUWJHEr4VMg=; b=ZZOfXcM8P3YJ+T79T30BGXbd4QNP99u7ju
	EhV+yY336aJkf6tPcMnlrc0IIW75tzV9dg+fhpiCbjUfOljClPHM821w4M4ohYo5
	e6g+FqCoc25+gIQtAQO7xTApKHWzbfhppPrvs/o5Tn9wSpLnDOjEkCL4KNQZI07A
	Cy8lbXNQzx/AhPKa3RpSwcOx5ILsH7Acmk+BZU+vXh6SSAghbLt73Ajkvdv5CvZ0
	uv2Fc9ZcnhgjRSyVAONi50ASDarjAE7n0ICBtgA40yeRM2vmdWnW4oZmeQSOtcUZ
	mO0Y7S+utYqIWps6WLMtRFa9VhoaI534zV2xrIXdQlSOcGn21A6w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypuawa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 11:01:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60K9CZro017177;
	Tue, 20 Jan 2026 11:00:59 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012032.outbound.protection.outlook.com [52.101.48.32])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v9fp48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 11:00:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j588CVFGR2um1T021AB3+pFN5dXHtR2sNdN/sBg1Q9fbEc3xj7g7OHdGwuNxXJlm6PpFTWDiQq5/7HoqjrUIw+cFi9OxKoiU0lDHEdfK/hZTVadZqT64RXfHXi7B9zfy8lls/bkzKI9tkE6gEH3623EM6vERov3QJKnEio5PvGa3TFg0aqEcLj+MBfdX4VypdqN1K1Kw2aJC1XaP5y3j4ISWknjnmTQBE6HZ+nw0owoBHt+yXCqAU0Y2oS5FDsItf2E4sRNaABcHfLnieKOQNfcRVvh2kfy/V8TxPxbUi1XxqCxVJlKwfOM/e0GvT4Y0sKMqXcGl5ky9ThhF/9GSqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/N6biiTu1+6D4GtCHbIYWL1qEFR3ikF6cUWJHEr4VMg=;
 b=hqMqISRKLyoLWYVI+q2Dguyi73bescTFSemAugcu2KP/jqUlDTExZVJPCYcA4lptGq7ckkR0/11DaMg0dM3v9B1OWozPxzLHs+w/TRogkqGyHmRk46dVWvfOaqSvTpXwB4KSDzFCSHF1QcvESbe2j5N9AjI76EJgCCDkIYv8X8qKMsaSRRgxm2XvX3hG9n4XgdCQT9ZCDenCJGQ21KxDD7d2vlWO64n0Glf+QBCXeS0Cgi7lgdJEELVX4GDcwdIOz50tyFGP7E3EiBHLYuZPhdIHpR0Suli8J69SYPNAZxbrFOXWFnvxdKdZzKfCP+FpYRuWEngINNMRjZUB06JRFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/N6biiTu1+6D4GtCHbIYWL1qEFR3ikF6cUWJHEr4VMg=;
 b=QJp0WfAIa9x3ESTnjeKDojUkmj5qN7lvacYSl/XQE+9RLvxMOLuTAC1ZOFutoVQZydIs+VDH+pnlyyWoIafT9rAaZ+9WyArpRlS4ceu/DRzlnkmfjhZsmSAu7lL8o2HdV2r/FjylhXyEh8Fvz9ZzeerCIB90iqBCN9Z3MUg96XE=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CO1PR10MB4580.namprd10.prod.outlook.com (2603:10b6:303:98::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Tue, 20 Jan
 2026 11:00:52 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Tue, 20 Jan 2026
 11:00:51 +0000
Date: Tue, 20 Jan 2026 11:00:52 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 417/421] fs/xfs/xfs_file.c:1977:36: error:
 incompatible type for argument 1 of 'daxdev_mapping_supported'
Message-ID: <b900b7e2-a297-4a2e-bfcc-aa3313db5f6f@lucifer.local>
References: <202601201209.cGuf98oB-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601201209.cGuf98oB-lkp@intel.com>
X-ClientProxiedBy: LO6P123CA0045.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CO1PR10MB4580:EE_
X-MS-Office365-Filtering-Correlation-Id: 723a91ca-61ed-42d2-ddca-08de58132cc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0x9Mkoo+jAbGd8wUUhzAuBCTo2iKfdWvhobOtyWyTYNLA6eDkoWqfyUkrFpz?=
 =?us-ascii?Q?lJIEnQl2aZTlhKQRvTjj3fjkdoCUO3h7u3jseIIay6Dig6XH/BjMzYVoX/PV?=
 =?us-ascii?Q?lWm1jQcK/nwOLxQxDPR9cyPGZf0IcqhG7x7AO65801i4A00Nki5YH63B5F1p?=
 =?us-ascii?Q?EfO2q8UFCNvV7s+ITnL0XRguD07oZwfX/CI/izDv1ehXBi2OGAw21GR7ztCG?=
 =?us-ascii?Q?3DlbDMnwR2bSpiqZqbJw8lwPEMMboKEMULCYcFqwVhUrZCm/7hthYOwSB1uN?=
 =?us-ascii?Q?vCecbwqMmU9txWrBwB/n/damsp417RKKnzUoSvyVcaxyATSBlMBlJs5N8yLX?=
 =?us-ascii?Q?XlI4bwERM4GM9gEYquClwc4o3plEwDaFqqkEfSGmibougSOyQvMHTreeKn0q?=
 =?us-ascii?Q?IWCU9hnjF9yXgE/g4/KzjhVyr6RnNcCkWkOzSZewNm2Vqczeu9jSZOo9FM/4?=
 =?us-ascii?Q?0Jw5a1MwDYaJfSbSZw3i0CEVQfudqbyvLZIin13ncTSUKrjZfzEYWyGKwZ2b?=
 =?us-ascii?Q?7+gih8uACVmxABBQQ1huNkogwwVJ/R2NbZ4qQEQ24rnjuS4xNEK8xs3cGo6a?=
 =?us-ascii?Q?rZ/MCPzB+xg+a7mfQ/uUgSF5jE+hrmh41Ob8skvpOQIi5At4wVJWF3VDbV8L?=
 =?us-ascii?Q?KEOKpzFKBcBZiZLh1dZUYI+S7ihevCiegcg1a5ccJSbyPEkeyXIo7Ib5AFwb?=
 =?us-ascii?Q?EevfpEiLnklgVdE6ADooPVZiSrCDgiIqPR09ER7qSAX1xyIS4IV8SVB89Qdh?=
 =?us-ascii?Q?7qAQ8Ma+XUjSC2VCVTkcC8FNsR/KSeIzJ+lBXIGpycPfD4YWMRdEBh0QbBWz?=
 =?us-ascii?Q?H0EPT8YQSBFLZMPZeca+4DfYhgevXbDbQ3MCZZPm+woqvB3fKe3QH0zjdwM6?=
 =?us-ascii?Q?d4PFhggM7aLUTO4r90+Qx7WlcMl8eGn7zMLqtVPbmJWKkrGJLbTTU/tarnGK?=
 =?us-ascii?Q?q4x4xMnfFm0it1pEPNJbqIbhx3P2E/FRHrUhCWyHpz3MxY535rWWKGv1D/xt?=
 =?us-ascii?Q?Ys1OZiGfIVDZn+ZW/LGTaT/zeMI5PBvCotTTTwA1BhXFkirVGp8qNyaLG/xf?=
 =?us-ascii?Q?8Sqxt0OU1fcYschk1rjfyaWKmDmfEiJgA2SvSl7tRrj4NamgGuOuW2appRtk?=
 =?us-ascii?Q?lLVa2FsnORcWtUUkg8LThWG6Wuz6//W774hMMPFlzArCEK+CECFQSU7E6fSt?=
 =?us-ascii?Q?1dYSRMaF+h9NVMgyzFfXRL5bY08f0n9k1kgc7Vd60PucsEWm9XtpcZIe43JJ?=
 =?us-ascii?Q?CLwDiS4A2IuM33AUFby1Wx8JMmOAqS5FLBxGag83Xf/O0ENxpLKFCFORCo8J?=
 =?us-ascii?Q?hbuAUOMRRzeoiU1oOZyUgMAoqkbMC1vyEFQ17yTAB5nFlCSlrPr1DS2BU0/d?=
 =?us-ascii?Q?wjpc9INvow/64xf8lWL5uvOOmwFfd2ZrBy3NW4eXFGMEMiK7jG7Acko1N0oc?=
 =?us-ascii?Q?umYViy5WhEDTZeZ0p+D+OXukN06OAWXRvud9STGvUWmrH2tWbtHUS6udmWpe?=
 =?us-ascii?Q?3a9ogeRkmrlAKBEQy1LwUklf7rKvJgy8tY0XPAUnHrB4qIGWy5qqv+RBS1De?=
 =?us-ascii?Q?SW+puAaBoyLrCXFJzgQQlMQAmpzl+e+SJYh4wRRM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m6oxyWakN0kCm9gfnimTkzE8jK1IVphg/2fnX7ss7Y2AkF23Hbwr+5Tz6tvl?=
 =?us-ascii?Q?uLwehDO6W++fE1r5V4/oLf41Up8F0ep0kcroGMQkJwbKuySNMlyai2u3C4VH?=
 =?us-ascii?Q?8tTf6deKWAsjczgq6ke/aRhD67SsxMmWHrW1t8fmDGfDpcIpYHTr2sALj1/0?=
 =?us-ascii?Q?V8cg797sy7IBwCmqTr/6B1H7ExjVdz9Fwg+KYzuSPKxSI9Wou21mvaFALI4n?=
 =?us-ascii?Q?Mo5VWles52dGtNbeUDLdCAAI8Ef5EZ2GRh+6tNDET4PrymseB/Nr5TiBy/7N?=
 =?us-ascii?Q?vRKXcygugaF4ZOfRpYf2nCrAGB+ZoV1iyzPPP/6UtvuUVF3/GTs7JrKQFC1I?=
 =?us-ascii?Q?t92dfeccucXcENjCC3t2W8Em555A9XS3tDC2893gjIkzsSxCxJensOrNnhi8?=
 =?us-ascii?Q?ElzSJsNTvxlLEmPWfQdsI65zX39TGiVhJhy/G996VBpzlZGg/OJmNJl2SAUf?=
 =?us-ascii?Q?3RrxsQUDyPDmPbQDOTmw1JJ/ZyxzCzoLfg8AAjc/dWaKq5qtEKZ4mnG0dn8e?=
 =?us-ascii?Q?TdyRHyMFtTVIKv7ojyrq6lQxaSqn5Q6bCKSxD85HEsQWYafRz0x/nSr0aaNR?=
 =?us-ascii?Q?xzCLFdOKEwhKRzuyJYKlM5kzV8141qXjduykwXNbDkJcE1sKVQ0ONSZfKuG0?=
 =?us-ascii?Q?TDM7copy0jt2MU+yZ+QniQiBjOKUNAyBdUgwTa3ovvmS6M/4PXKRFS+SSLvb?=
 =?us-ascii?Q?dokefTCewm+j8cAkhMgOQ+aU0wVCIEHeQI/Xw+1khoo34bbw/bv1vefc7fVt?=
 =?us-ascii?Q?NTVN/bPo6JOWh19NId19PoHXu4GCw7mEBXF0wKeAzA6ECr2OEhdymg1wNS5I?=
 =?us-ascii?Q?4Mclipip63RyXHD5FvGf41UWgEOnA3UCd2CQPlbcstNbPjFo8Y2SPRaHq0Mj?=
 =?us-ascii?Q?+QQ1NWtiIIUo3OAwbpqTXzL5/UEQ+n4Pb2D0dwi99EGMoy45AlJvzEjIibbd?=
 =?us-ascii?Q?BbrmitB3rmxHTq/5n2YwYDFTdiPLGrqSzQoWpJWYXi/WdLjp7HuuRbGHzg+a?=
 =?us-ascii?Q?it54CvbrDy1gfF77X8NgiaexZI4qh9EwkluzlCUlLLkV/Li4j5ugV8uhTLb1?=
 =?us-ascii?Q?oeAmWRP6zap1fiCGRyBG9+xJqerEvOazaWIFznS2UYRouf2EZlg4QvQtJjjT?=
 =?us-ascii?Q?nX243EYxUT39rBaIUNpAfFuSs67bZit64YsQijPvV4IxNazoToDQoebTPRG2?=
 =?us-ascii?Q?oJxC1MdirsA0dkpinUsU+ILS3FqzqJE86lFM9k8GHYoun9AxzDGqh8zq7/6R?=
 =?us-ascii?Q?jKZ8C1xcdsYGtgBVzObjnkJMVdPBuDpTUJROfczWPSax+oSfp/i04UqsXGpN?=
 =?us-ascii?Q?wOPSMrD9rJV3Z3TUdanNWSePzeB23Xq1xgUo1DRdkZG1sKcsCjNnuVeLMEDH?=
 =?us-ascii?Q?G/phHyB5ACQuGERpgApy9/C2Lk/yZOctnxJHUeJARhzPXck+cu4vKfSPrFwl?=
 =?us-ascii?Q?ENdGgTZiEYyR3971tuvVjQPwOgOnqZvpTnVEfMD/B2/kEJAtELoBcgV3HuKz?=
 =?us-ascii?Q?ambmyRUYftGVyes9M6IavHW5NE/78zsinx9HBFnK/B4F7bxnsmm2SQKY1XZd?=
 =?us-ascii?Q?RiApim5aWhkHb0gay9TDUwlo+JTU5ZUbkUCE8kCkl24sSgSkpZMnA2+G2LCX?=
 =?us-ascii?Q?4xg17BCWIvOkFYX9rL3ya/66IqlQXJbgX6vpJ2rbk30TwF7cDCqLXlhPnNjX?=
 =?us-ascii?Q?hFlxN1n8Rh25GkjmxiAJomHdDamCRQH/a9l3Zvwy2A/bZ2Go2gZIeoidS6iD?=
 =?us-ascii?Q?uvRDzZG+GZ+jN2Gzr3ThJ3AIFsWfvHQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kn5ZkwtI2Et1U68SmHtFbWKxnV4MTMr3ydW8qLZUN5c7CSCGhIJYwi07rxWFG3AUNUXWeslmEryAzosY0Zfq4yStffUiQE/uaQnwAXQ9pbiNLZ8XWxZmUUXAwWVkaMU+DP/Joyz4gPydNWwic2LmYgD+44kFAqW/r32y1+VzO4FryJpjYfyjQJ7xUwoP0ZfwqeioEApG5/91R3tKQvnmRIYLco1C/8gG7FnM/+LBH10R0tGReaB3D+dv3B1Wvzg7ZfgsY6pHxz+mR0hkcsYUMwgrhyPFmdWBAyy9b/DOk2W2/iq7Q9go3F3K8E8uMZ60nLmqkRLjA/0bpbJsc/4ifr51L8GX6/bGEBeqLuKVJzwKiN42q1OWwcmRjqYOStznnXaXjscQcQR2962/g80oOKoi9ciDzpPkhPIpU+qIoTyUNTyEAX5geCBIY/btaexnpO1tT5M1TRhH0qQ+NmiU7YK0K3CfbA0ucoSp/7WdwWzZM9m/mJP634kv3sVv02odyJslA4Fkfin8jbko4haUF21z3STZSy/iqIHcKlVd1lrZjM5IToQ8AuUVVe4xzsAIj8JVewhrwjpvwlgNq1VSjsNw9C+3NL+Bdbyc0djNDZ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 723a91ca-61ed-42d2-ddca-08de58132cc4
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 11:00:51.2606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2AxIplm3kVRHfbo5cFuT6FDBC93cmDi3KJhZJR2HjwUwYjZYFGwWmyFxAkSogNA/pdOMIsjDpNE9d6RvMjXoEjGAQfXLscRjQyefkiy60c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDA5MSBTYWx0ZWRfX5ISQJXk0Gk60
 sUvvoU+zDB32nBz8wl59uTodwcY6/Z10sIvrjbgW7rt9+oO4nVYjM0cl2cFHECRJMOpIWAQZlSk
 m/ZAf/SYgb1Hz3XH1I2Oqo77JwEQyLkViX+DMUnI8CynS1aUqmvf06JeA78wGlgbqYPikYEb//k
 ok2FyeoLYGyfn1CEa+PVZRJ8VmGJBWzAxoL35jVcDUuiZiCXXsl0suVDml618nkG+VZNFgG/kKZ
 mB4b/3+0irewC7rzdQ7MHD/kzm5Kfg5w8G4DMCopcpTD5S/6t5DRad3RBzK0xwKgV8qSJBmVe7u
 nVSlPuKRxONasGUPAqLP7YhB5et1AvoTRnNr/HfQvSguWS/GPaBX4DdqZyEBKtUM/QwR8gvFaew
 XmZzpPiI3m2gPsY8EdfQaSaFoF/oZ+/FBxPFquguOHu+X5JAZqpNxDxs/t56iPm3/btqUOTO8p7
 FdUDy2LNdZo65BkSNYw==
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=696f606c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=NEAV23lmAAAA:8
 a=CDD9DHtbrccDSp1lZM4A:9 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-ORIG-GUID: JmNZFXulOASALnzc-qgtTtzdEYZZOGRx
X-Proofpoint-GUID: JmNZFXulOASALnzc-qgtTtzdEYZZOGRx
X-Rspamd-Queue-Id: 2A85F1C0014
X-Stat-Signature: 7w4xewbm8hj6tzdb16zmnh7iwfw95e51
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768906863-871047
X-HE-Meta: U2FsdGVkX1//Q2WvcHintBcPdbbGzH755CThWlnIqCMhAUj4jLqZLWi7jHD28hZlfoGYcfUUbyywvFVPDrcBx66uTjjTCEW6wtLFQS4CZDqcokCZrQHIdY7AAMCyalnNrbyNji/nf23tBqodKJchHH+r/QL9DqmpJm3qn7mPnACB3jjID2aK4KDWlTMnV97uB2uWKLD1ahkFwD01Tr1cy88AGbR7ohGayMGSRffXSP6VEfe/gLmMPO4ALFwxrijmeTABKJER0KyN7nJGhFXOtw0We6wXTiB2AzdB24M4Mmf24klLnZtmYf9Pwy3Lk2oqoTxi9+Zm5uMmtsha0z7olcDLzYlqrbT7mvvajXTJFbWZ+rVCQV5sIP4KOUche14SJ77f7b6+jBAEwGE7WXiUASmNLq9jfFa8nl1GV6G6SZ0GMqeSG35X0W/mja0YcaAgOWQ/+GCv5ATVsgcKc8w76iR+m29PaKu/42mA8+bOyqSizItR5P8a4l6qxZp6jpFWK9nTvxMCHLP9Sv8RmGrWnT8Qth+85zNtZujU99HzgIIM1KkniJH65BWiLS5MxocryQY5Atz94ycRdWWwMC8ggFTFm44nVrrOrR/IOn5qI/go4GfijVDizVhk8tjBo13gMb+JyUkENrMXuNTmzRsH4hAwKztGKmRrUMjb/FaDgdR1m8qjij2HNYg+QqROswlblGezPB2O7SvdPtp7IiYSgCGq/uOX5/sdTSupvHhkXzCOKeWYm3Mve+buiu8+ayZCF6ZrYZdRdHx5WwrQ65saI9iO9LAbooQQQiG6KW2Yt59Q6qru67yrZ6UawmC2OK2HbYCzv6ctcJ0pSSDG11grmB2opbI+0uLnb2HXsmkhDcuXwJZ5zA/KPczyb5+ggN4lfDtlVtJ7VZSsL5AnrsNtOUeAGGi6PdGa77YYtKjhNSIlgTnKJ3gWgzo9B+DHl5zwBvBVvtxZUMCC8vfvTGd
 J74ezv8r
 3XlNcVMv+tl4WhyxnFnBUi2JQQTVoGOfkkxDe0aG+XDVE+d874y0x22K4umDwW0F5IUj+N5uFhRzJK9/Hg1lJesKMBk1HeXAipc8yCy1Kp5xsvyYEd2HiXW2UoyaMucNaf/qhjKNlZULEpeL2Rzu7j1JMPQSLtr+ujiCv1a4Mwy78OmJX5gU62HXpQkkQRZGS6OFU2rQ96vMKgZYZ7i11R/z//fMIWNOv7LtaqhaaXxmVhF87kMHK8C+5enpRim1mpVGdevP0H0KygtD2R76rveV06ktwNK0SpmyQQyQRWVrSAyfsk06GOPGPsLVOmtVk1vNS8xf46nkqfxbaiYiOALPKgimviRZXqdtCV0fmPevnZVthCFBuKxOgiJhePouUYf+OTPPiEQ25PxvhUJ1OP5mY6Yo3VFYPpXL0jEpkimpLFd67cWXVE89cx1OO3j1SgVb7n8FfrdYdZ2O0EVCzOB21P+jwHtLqll0Fkge3F2o3gR5hMTVcJ8BVPi3bleT44i8bRPeMj2H2msdJrK5gu4muFF5guNNp3hz559XVZb2hbHFpN/7Cq8SBUhPkRMj4wbSyxmtIcMAc/UEqRxxx7gfyYxaagWnHrKENMlvMafHgShFkvTgFxjzTpAvYChQ5etfAwOi1+aj1xjaI41JHJVC9v/Sk6RX27Bpy10XyNf9nBKSeNI1a3eRd0QkAibwJrlEBWUFDBs2sKAZ6epiEXqbZwuy9rugnDIbDmgfi0Lum16Fwps3X0lfsgUbXGpy6cMx+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 12:30:13PM +0800, kernel test robot wrote:
> Hi Lorenzo,
>
> FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   e4348a62bb1acacafcdeb149c9363291fae08c0c
> commit: e3900da1b37f861133669d26ae02415f18fa71b9 [417/421] mm: update all remaining mmap_prepare users to use vma_flags_t
> config: parisc-randconfig-001-20260120 (https://download.01.org/0day-ci/archive/20260120/202601201209.cGuf98oB-lkp@intel.com/config)
> compiler: hppa-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601201209.cGuf98oB-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601201209.cGuf98oB-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    fs/xfs/xfs_file.c: In function 'xfs_file_mmap_prepare':
> >> fs/xfs/xfs_file.c:1977:36: error: incompatible type for argument 1 of 'daxdev_mapping_supported'
>      if (!daxdev_mapping_supported(desc->vma_flags, file_inode(file),
>                                    ~~~~^~~~~~~~~~~
>    In file included from fs/xfs/xfs_buf.h:14,
>                     from fs/xfs/xfs_linux.h:81,
>                     from fs/xfs/xfs.h:26,
>                     from fs/xfs/xfs_file.c:6:
>    include/linux/dax.h:114:56: note: expected 'vm_flags_t' {aka 'long unsigned int'} but argument is of type 'vma_flags_t' {aka 'struct <anonymous>'}
>     static inline bool daxdev_mapping_supported(vm_flags_t vm_flags,
>                                                 ~~~~~~~~~~~^~~~~~~~
>
>
> vim +/daxdev_mapping_supported +1977 fs/xfs/xfs_file.c
>
>   1964
>   1965	STATIC int
>   1966	xfs_file_mmap_prepare(
>   1967		struct vm_area_desc	*desc)
>   1968	{
>   1969		struct file		*file = desc->file;
>   1970		struct inode		*inode = file_inode(file);
>   1971		struct xfs_buftarg	*target = xfs_inode_buftarg(XFS_I(inode));
>   1972
>   1973		/*
>   1974		 * We don't support synchronous mappings for non-DAX files and
>   1975		 * for DAX files if underneath dax_device is not synchronous.
>   1976		 */
> > 1977		if (!daxdev_mapping_supported(desc->vma_flags, file_inode(file),
>   1978					      target->bt_daxdev))

Same deal as other report, will fix.

>   1979			return -EOPNOTSUPP;
>   1980
>   1981		file_accessed(file);
>   1982		desc->vm_ops = &xfs_file_vm_ops;
>   1983		if (IS_DAX(inode))
>   1984			vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
>   1985		return 0;
>   1986	}
>   1987
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

