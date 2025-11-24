Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6E35CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 07:09:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1C76B0008; Mon, 24 Nov 2025 02:09:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082676B000C; Mon, 24 Nov 2025 02:09:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E656D6B0028; Mon, 24 Nov 2025 02:09:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE5146B0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 02:09:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1412B74F1
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:09:53 +0000 (UTC)
X-FDA: 84144625866.24.8D28A0D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A925180002
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:09:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rBHSE6tP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="eU/i9Rfq";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763968190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5S1FL4fb0KEqU4w9lVLTdsSX4sqaAxoSYORkuoGjMs=;
	b=GC8VMjoacsMwY9hAGcOZyDD3embF3VNfX7dKB+20ZkwCxFcZ4b6BVDPreCGzwGtq/a9PI1
	p8fRr0Pb+g2j+QUSF1TzZ7dIXKxc4o+0bKdJyi+5AKMzPzWN/ZVezYcxtSb1fOaK8Ax3Up
	HViSH55lTPUJmjWr9KotWKqbUZX8dqY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763968190; a=rsa-sha256;
	cv=pass;
	b=vkFYRvE1qAieGW4tVaw+756FemAHkjiODvnSSjGIuekFpicQCoY9wbrV82BBEWWW+YFySF
	bQsiMZf+FypKQFRwJuHT1KEKfuqV9vBiomQ7+14k2tRNB51g/KCNkTXlx8Df1lO1UMaeBt
	w8lZh69EDwoKrPqy3S7Tobut2hQgXRk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rBHSE6tP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="eU/i9Rfq";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ANNEpDo3927535;
	Mon, 24 Nov 2025 07:09:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=N5S1FL4fb0KEqU4w9l
	VLTdsSX4sqaAxoSYORkuoGjMs=; b=rBHSE6tPzfNjTmYMyuwHjXVj3W7Ayxge25
	0G1vhBEofpd5CRivjR9I8kOjaxsK3gYgPifQ8eZ7eQsKEqVJG6fDMZsjVoggwqGu
	P5ApAx5R7gvibPy6UCYsuB5xjyLCDqjqFc64rS8f7B7r2QDK/sA5Db1/01FWW4kq
	NporH6FrLBLP97Z2XGaEKbJ6UOVb2Hhk3MDxEnJT/eAawflBJwTa/uewpoBNmTqW
	vWxcDJfVSjHjhH410mspSruwbf6NuKTxGxsHLzJlrZALeI9hnzcIFe2ZqXUTHNqt
	yXOKBTuxeoFgqtrgV4Ir3U2tAS5cxr8i4Y4QfNC/ecqCM7XZ2IEA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fk9fp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 07:09:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO50R96029761;
	Mon, 24 Nov 2025 07:09:40 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010036.outbound.protection.outlook.com [52.101.85.36])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mb9dw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 07:09:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N0RK6hVK0UFf75DTox5yWC7yLOuy8zDo9ga5YHe05SNhUurd/wWJetjHs+zslvP3wqFMKazhpxGfiUb0aszcux7GnfxV57vEJ2C/0tdZLgM3vzwd+ZBrwqukvFCdYBugf/UkX6HlHb8pvfT1+7uolVvD/YNaGjErCmNCZZjby30CIjIoOzI8oLfz0eE4YyJLdCLtdB4kMCr5+A02AFVgKazY/aRgQe64+FKKcs+u6vDDotNNbHUoAlAjz9z1BN3ceJfFxaI6Cgb+ZNQyoX+Xtz4HRjpvbQJBNfqRgqEngs5Z//Y9ZhIY5xa2B7//e15pzYXTHPMXqXkfLj8kPLjPsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N5S1FL4fb0KEqU4w9lVLTdsSX4sqaAxoSYORkuoGjMs=;
 b=sbLNoEd8GA75MKBqzlzVxN+N+y+c9n+IeUsLYRm9ei5khMX/2r7t+uV8oGZjdMo4B2d7q0h0qco/jvY7HsGLpDvIQFOytsv2Q2TDeY0UKvLw36Gui2BEeDWjeaxq8eGCFMPGJZ2rSrtjPwDIRS0XNYPD0IETXquh3lvUXVm8CCi++Em98mh8bIg8Jt3fy1Lqf9+NsBadDmw9hLQQpUj+r+VKYe7/gJ55OnOtddNKiKJFe0LpDYhr/LCkog5603ngbdv+zXjZKDGNUksSdFXy6P+l7rJirVwYfVnoy1r+N5SoEAT1KYTtcnw3E5xWC5LytSraIbkiy4ubVHydCNfCHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N5S1FL4fb0KEqU4w9lVLTdsSX4sqaAxoSYORkuoGjMs=;
 b=eU/i9Rfq/5/n2eBU/SDTzvzY8ICxHaR+v4XqTIH1K1RruL6x1n4ZfIzXOfMkjxN+PbbFZi957kIgFPoNoLseJ6Seeb2MYI+pboKfnc3Pfs1dRKZEcvXPpMR9mFUZFpt0dyA/l64vsXZDJFwzYbs7/ckFSIXjSzYV9gIwJkqFPAg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4786.namprd10.prod.outlook.com (2603:10b6:303:6d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 07:09:37 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 07:09:37 +0000
Date: Mon, 24 Nov 2025 16:09:32 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v4 16/16] slab: Remove references to folios from
 virt_to_slab()
Message-ID: <aSQErJNLLev2CDPa@hyeyoo>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-17-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113000932.1589073-17-willy@infradead.org>
X-ClientProxiedBy: SEWP216CA0076.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bc::18) To DS0PR10MB7341.namprd10.prod.outlook.com
 (2603:10b6:8:f8::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4786:EE_
X-MS-Office365-Filtering-Correlation-Id: f64736be-950a-4250-72b4-08de2b286da1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+zEhbhy6dPypn21e/fIndjjZHMZDuSWwIJFPQY5HHBl5jiZYsu7IRlsAZTWl?=
 =?us-ascii?Q?JF1QxeI5/Bhgi52IPuxwhdN5zYXUjLyRhiNUv5szElq2u1ngJbqWMEfUtabJ?=
 =?us-ascii?Q?h6CwbHx/X+vFwvg7yrIsC0aI74FiYCola8SISgD7SXKxw7JkV8kepwXK6rMn?=
 =?us-ascii?Q?y6KTJg9puD6paJgLzBSaZdADTM70TVhUqm+MyCkPDZxxuwm8GN6coYUpmj1q?=
 =?us-ascii?Q?Yrkw/0U9rFa4EEUUC+3XRGsbx3ermESgwxcdd34ISsd2MHG68/Ir00Rq5awK?=
 =?us-ascii?Q?CjW16e+119Kvcv3ECJ+l/WwzLY4ogFf1FCS18qjy0VW0WkOqXn5NLLTqJtif?=
 =?us-ascii?Q?CQmyB6czohtCnaiSw1ZQgndHIae8cY0MOyJ+7AmTVVVH4Qa4zcGHBBRym1ih?=
 =?us-ascii?Q?Ts7LYnNEnfqQ0KMxdYIKJV9G5Ou/aVQXe+s1uw4lVe4jk2AwTJrQNJUS1NBz?=
 =?us-ascii?Q?kFIu5JjtiwXWS3H5bYbr9gEa+23VsBEaolxJiXCZ/oB9DNUrdlp8B0u4myRs?=
 =?us-ascii?Q?lZ8BxKgtA06WVHoF8fIVvDmqoU4fadibOUdKDOnjEksSAfpIgfYK9XBCOO/3?=
 =?us-ascii?Q?bm+j5xPBdLUTV20x2Ox6zGbBlMmYA4D5ZpuFrrQXvUxkBR45HU1NBw+XPCzP?=
 =?us-ascii?Q?OrDg+KQP50iJoQhNnQ65cbisNejiEWlrvEO9iuZRhE8FvBLwLvbJB/ePcQjb?=
 =?us-ascii?Q?EN8xD0Bj0GQNYes71BQVW+UEIC+chjJ214/QKOfGvhpQmfd8HUOmEY+EHkS5?=
 =?us-ascii?Q?PNAMLrpk+pSeEUAyXnN824DfwcmlABl/YSpu0EVZh3q05WJfKrlAm03QlYXc?=
 =?us-ascii?Q?zxS7b99DN4EVXu7HRtwwrwabjAbTGBFRriTYnTKetXmQ3nthQZYzVoTJ081l?=
 =?us-ascii?Q?TvRJCc4LApDzWXH1GY+8Hyv5DwwBqmt+V6flp8VitaodV+6nQ5RcRtXKXrcI?=
 =?us-ascii?Q?BMLCUZdroHbBpS5P6+maIsjjYA0WaI2e0RQmm6AciftUk9dws7j3ojiEh0ps?=
 =?us-ascii?Q?v4TF4wCyy1BZ3j1OHtWMi4DACOFyDzcKbrkkCnhh3x1Qz6f/SYe/tbrnP57U?=
 =?us-ascii?Q?N+Sl5R5CXLkR/Fa6m3CpLxKV6v06NNn2hIINAUmrt1HgJZxLclmXOZHyBpp2?=
 =?us-ascii?Q?d7qF9uEftoqszeTGeWUyPqZivevQJbEpyS2+aK+G1xVgv2+qvqXa+kIlvcfM?=
 =?us-ascii?Q?ZCYRSiZi5Jpga3Epw1tOuaSS7eGO5kujIyMDpHtDLKt321OkDJ2clrk9Ae9z?=
 =?us-ascii?Q?LpirtU6ZStM9MNm56cKdlaDSQzatropGfz0HpTt4W2mWLn+oQfM3WU31LFEg?=
 =?us-ascii?Q?oWr0eADsxltlgJfH7HiS2BLTxfBDuZIS/aF3St/JvOrU0YGOMBuJA6r9mIN0?=
 =?us-ascii?Q?uV9EUFxDYiPbFCQK/pH5GE/u4Ks7V9e4zQZ6Jf/N7b1K0n0rqQmIe8IfvoXs?=
 =?us-ascii?Q?FswIQpFFUnRsj6QMC65I2Wbo0V+wX1Ui?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BOz8cOOyeD3MlIBsOOc9qCG5DAmBXUEmjORhNeYEwQNquUZ34VpgzBR67LGl?=
 =?us-ascii?Q?pO8F0naUGhmcwvb3B0dAX06yNn/Ckbu7IJnS+W+cl9MPoUeOC3qmgeXuoH4n?=
 =?us-ascii?Q?NI9heUJIK/XyQ6jDde7wMS9P0gfw8264v8akH95TM+ZFJCCgcffY/pfd/noi?=
 =?us-ascii?Q?g1FDu9wGTlBtWs8QEaiW7F3uFsesMR0c1TEHmMmXNvJRnR/VUQf7rEXxfW6z?=
 =?us-ascii?Q?Xqi78bb4fJqvwA0+XEwdDUpWdpvYaMJFT11cRVI8VlF4tUULj9GFI8LCHtc7?=
 =?us-ascii?Q?JNkaIcsBJocJORB+wRvme36CsJiqmgkUsvMdDGOENRGA/Z7VPCVB9a9Vzxt6?=
 =?us-ascii?Q?UI20dKgaKDtvUTYIvmXgeQlwiujEqDCJoWhoj2rkmeyTMxR7eOIoGpScvCxM?=
 =?us-ascii?Q?8PKNZCrdQU5aWAG2WNJETFCTFYjhy4ggtAVegcSAUEn1hv80byEQyypnN42c?=
 =?us-ascii?Q?RmQSptDhc0SOuWozgQiV4rYUDHyIRd+1b6x+C6odkm4KypvZdler7DUtdw1x?=
 =?us-ascii?Q?1Nqbz5fBG1QwvbWSkxFIejPObfm4EimOtKki/JHcQk5GpfVTM06W3oyoraqW?=
 =?us-ascii?Q?NArdN1xocScde2Vt2vvYC2CVRXYzDx7zpvaPDrvLfHVPxrRBb+wx9VtRcEaw?=
 =?us-ascii?Q?fRH3+MEeNVjV3gY5Nh/GmuyLfCvTorl37aAaTACeVYTKk3gOPL48+wIVvbxA?=
 =?us-ascii?Q?J625hJ8yaYNj8vmszUSuUc7aW15ToySe2d6XV5B+GXsZUPf45k2DuHm/W7Cd?=
 =?us-ascii?Q?8QsunqgMOf5OrsFLpY610wQclCk1zt8ALMIT3+Tkg6eISpriw58nVV9bBCpO?=
 =?us-ascii?Q?1w2xu40++25UKoSpKUtn51GYhVhwbdVbXozVl34ykb9Ox0hjuCx9Big00Qdk?=
 =?us-ascii?Q?oOlbpuIb9iM4y21gNb8oEiTOSLkgTjY8kEji6vcAIvhpc1RV1KGmca9HAyxI?=
 =?us-ascii?Q?ZzFJDvyxMPIN8tYGTUdHg5yb8MGZsb4ZhTkKuPRtQ2Mju3IYscRXip47OD0F?=
 =?us-ascii?Q?gIn7Q2vo+9BnRg3Z+/G1npDF2A/xWVv7U5MKSqFqmAwU5jVKQo3fWxzDlw56?=
 =?us-ascii?Q?rQ374OuRvWOJjpNFOtj29nGeUI9WqCFBViIL/KsrmPMiboJ98ykh7TLzd8Gd?=
 =?us-ascii?Q?We5Vxdb7zUXm0/Qsz/o8gUw6pPfp584jEed3KdMe8LXCrx5BHoBNun9NMF3u?=
 =?us-ascii?Q?oJTUsS1MX76ds9BM+gibMQD1P8UKPiVE4T/Gq/ZJuYJqJzLPf8ok2st1vNnI?=
 =?us-ascii?Q?pCcxwFd6dVFeftqtcRfAJ4M4Qs7/PBbWf7nCowQrxc5t59kzu+MxEgYZL6VT?=
 =?us-ascii?Q?RSApIbxIq4Dqy8bP5BvLxDDKWU50pWg/s1AT06rkzinZBk0aDAPejl0FkpGY?=
 =?us-ascii?Q?YbzW2BqCLtZa6UeZ6dL1RGKWv5t1ADLBkkXd2kQa4VPyq233kSzgUkD7+cZZ?=
 =?us-ascii?Q?+2Ojpmz12TQfyDTiYFbfgRpPGGwPiZbLEWM8Snk9jdKEgfCa4B7DTent+2EL?=
 =?us-ascii?Q?qtbAaN/Iuuf48Th3JgkV/vWGl/ps+o/Gy9UXbNxvlmm6LjmQXmUDBBnEmaj4?=
 =?us-ascii?Q?8hhI+GnBeWk/zQtb3E1K4a8KAPJ9B79R44Sth6UW?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TuIwGFVsUgF0lospxMsHiqQH7WY1zRthG6HDsuZYe6pG9DJ7EmeOQjQOUraqh5ITg3e377cqhMJkt7++lXb7/qx4D6+jD/0qjv6Tz2yg7do0N1KnSCMFyDBy7JrjWResxUCG6O/I3s/ERC9uLThwTOkDje4cUGdSNcNK1iXUK/5HjWX1LYRd2KppvEHO2cvJb5H2+KkXocnBtxULlSuTaKchsA2smMUBA6I1ycDgDrmZBdVcdhalKarnSho6pgDI26wLkDr7U+8zaslhs2VgrMfNst5JaCuYl6FdZ4fdONQunMee3EegQDb41mgrOOogSjELaA0e7lCgg+9wdJjAb2OuKT6NgguJvVAzTmP+ubMLE34O4rfupoVARsZn4WOKT+y9JnRsbt2X9LFy6+1yhioK2p59mdNzhgwMfUUYnBg6s/sGrfSaDpNYse0amIQiQRphKCiJyo7E+zAx6Wkm53uXxOIwekZ5Nsrp2zWDgCPCnEjhRiV/dDZXqV70DLmLjAFPbxIVtJR2aorjGyIu1iSRb6qHMOg2FjRhDeTsYvuh0o3sAk/E8Toi9pOtNI7wKhnLc8iNsjEkSLiatzvr0MJu9eyZd2/vhDBCA/w9chw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f64736be-950a-4250-72b4-08de2b286da1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7341.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 07:09:37.5283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h0vvDE/Y//OPdH7ZEjGPrL482LcU4uW89H8Fz0fyCnwZjvFCcc6kP+jht6366r9GJnRmkMStzmEvjZUZbH91tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_03,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240062
X-Authority-Analysis: v=2.4 cv=f4RFxeyM c=1 sm=1 tr=0 ts=692404b5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=gocAoaSusk-08mf-ZZsA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA2MiBTYWx0ZWRfX3lyOE7bO78tC
 r4u/cGBVaSu4PD/r6lM1+Omo2s52lbAojuDSncJrZb5k+0bkgQzcqjlL0yPq7DQRQIXPi4oI7Kh
 6r/+VIM0/RWW/lA3RTh3MeMYO43fcOYeXT8SZvNhr+UxGCwYrXdfQ62G1SgK4n9xxjoW9f/Kut6
 VbAAuzRi6HYePzc0Btfc7HyyiTwS1ypSSxB+5f4e+M5HyYvxTjbAPRPxlaBk7Jrk/0HTKaaSXqa
 rlsnOC+4ZIk/khW8OfSyjWa9DJyumqAExLMLI5/Jws63hM8McbIghSRwdIa62KHIPMA3Mk8yju+
 Qz5NXEWitHLZSsWQABt+3Nf1sVU5C4NT/Z39T7pezI5Nnif/mlO/mxS126HAx3gNcd33eigoNXA
 PN/6K/IsBU0DmisjtdzWSJyxSbawb7MQdTgkS6F/cwzk8GK6U2s=
X-Proofpoint-ORIG-GUID: _MTAIDZuYWGiKyiVCDg1fmEPZDjxly_R
X-Proofpoint-GUID: _MTAIDZuYWGiKyiVCDg1fmEPZDjxly_R
X-Stat-Signature: ifj78fncwbtcsxo7esw8zimismia33u3
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A925180002
X-Rspamd-Server: rspam10
X-HE-Tag: 1763968190-678005
X-HE-Meta: U2FsdGVkX19BOc/pZttZzu9ocf4q+bNJYUPoX5K+2gyDjqeWx7NbpZWc5abKMfyWunCBUAnDMuwJZIHE06c2D232rhxqP1AiCSFI2A4dwbj0uVDLqQu9mE8iZTGsvq4dR6C//Vl5QHCg6ksu3Wl+wppXDKtOwrChJKGeYNnvra5+093RbDEcieCOQ2oAGxIxdE2DXUSs7ZXIuyr1eBUDSQk81NjCjqAiSezmE2lRtlNsIekTjIltwf5wGFw5IVCrUluctJloSdEPqFBhI0hQe36dGqyD2MVjbl9PMhgv+Dg+hAnq632WMZ7nZK/GxU4JlGRd+AjAubf0x6NoGDXJvZQ9zFnPRaWw6ZYWy/zD2YjdVoAxgI8QsiB14DRAlLSQdFitNZkngZJtUN4IxCquPCXdduQzrsvdKUrDpl3wVplSVzp2gq8hIbTBCAKbJPw/7X51yJqlcjr35WMUKND7nMjfisqx/6YFLssS7RSU+n4csfEjfI2lLRwYGYH5pIS+LGuufdbd1eAJ8fBfAU8y/9mhHOlJr9kKy6VrirywfisC0GPGb6LGbM3i5FRto/Ax54WWMJPEuj9oXCSldcl17gq8Vw1TVDKQrL3rxBX9seR3P9RXutfjQnH9W2kCCR8zV6RJ0K2gMjowiV4PsEJ6U8k2v5dWjx/aDRhnLG/HeHL1uL00Tdl+E5IEwm/x/h4tyJLhkP6fPVF21xIDSFvuGVNIjE/9CSZ7SZb+Il4CZHsjTSfEMPXD+SVssyP4wLA1+rWNN0nkpB5Uk3Dppp2yA8Xf/gVZHyoIuDadPhEnMPiikpaDLONgLxnBkzcdBz67lFYGbuYKt4URrqRNTrfFzHvPMvVJcHZoY3rN7r1cMCR5WyAuSJrZ/mQQf2V/iHbXTmhhOIk3DtVaxPEMIU65iZOCmMznxn3w0b0DZH36RaiThQjeJfseY0c1bG/uNmH53NF0lXtx5lYuwfOxUOE
 7R6pMgsk
 RUgDL31V3R7jPg8ArwEn1up5+OVAYGyyZEOkC6TnpsQgmBgJ7n0F61QMVaXyOGC8h27YiKyQtHhMYCm81JjC5lACPgUD1fdQXgVYnGPbADqG0FNPNSsknba56/uXDQuej0d4q8zbaYZDeO1YDjT8yhiJ2Iw4z2/smJ67+X+8t6ZDgHUX7Xh808Vje4qEphEAWbOkdwIPLwkzrodTAAsfJAhS4i6TuKvGusjJ/qzL2XRoNwy53JJi/d5g8D4inz3vRxxoWeglT99XVAGdm302I/oB+yJ3ECLquRXzGPAm5I1OSGmCb9zuVv3zdD02Rw3Nx/P0mvv8w6UZ4fjY8l+yeQZtq8lx8bRNoXsRF3SbJKDwm+9xAtZwNJJch+iV6iuHpK8beuEOb8Aw9JG65LSIRBbkO7fgXgKezvtYQFD4Yr8heedJ2nPb4Xzyk3IjsM7/DKaZurgGnOTZLH08wSRwWiGntaEeir27xV5qJ5NSaLtv/V+pghvLTX5TT9u8fCiR1yXwmnnyGQEDkNXU/EiLpiUU8je+CXDr6Bwq+QnA8P6F1acRnZFBbs4hmhcaXvs7DzLh7Pdzex5pAmIQUgHr9eR0kR1sxinhHgloLZ9rtvoAjnA+hMvW61lzcEoTZlpZKE7dAxuKoWCl6Z+yMSk0p8d02hJVt+kFhOe0+4zkWbC5YwPIf0rWqvPkTZ3IOxUcKLfk1mLjxpJRVbQi4GiAyiG9f1jGuy4nE0TjT8Ioc6+TWYLghjAEndA12q/B7KDgUFGL2b+sOwkxoDMe4hu6OknwnLDAiN7hlVUv8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:09:30AM +0000, Matthew Wilcox (Oracle) wrote:
> Use page_slab() instead of virt_to_folio() which will work
> perfectly when struct slab is separated from struct folio.
> 
> This was the last user of folio_slab(), so delete it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Woo-hoo, finally the last patch!

By the way, there is one remaining code snippet that references folio in
alloc_from_pcs():

  if (folio_nid(virt_to_folio(object)) != node)

which won't work after separating struct slab from struct folio :)

-- 
Cheers,
Harry / Hyeonggon

