Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FFDFCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808048E000D; Tue,  2 Sep 2025 04:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7446A8E0011; Tue,  2 Sep 2025 04:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4098E000D; Tue,  2 Sep 2025 04:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 37ACA8E000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:14:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 368E2140B57
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:50 +0000 (UTC)
X-FDA: 83843584020.02.CDDC76A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id BB1FE40005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GdqRCAOm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Jg4cts+3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//izA+gzb2Q8yY2Ihnjzzn82o4Ewk+CM1ZPZBh+u0ks=;
	b=GBxZfNaVyqtV1bXlVMAE4uEFx6kxztoQbCtuPcxiCL+6QWYV/hKqTfVUQ6NvjRJH9CGTgC
	SyHro5R3x+x3MSZbCjQcOrmXwR9glL5rFmm/NZM3GQfrKvBOZDp4Y9Lu/4ai2DB2x/0AxU
	BECdRPt/H6b4ykzmy16wYuo+l2NZxp8=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GdqRCAOm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Jg4cts+3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756800527; a=rsa-sha256;
	cv=pass;
	b=D1EfzOxO9VzosgVhBkClUn3RA9HJXH+MjAtHe5pKnkzKxwNlX2XvOMf7yuxuoIEVywZFNw
	G2C/nhXduc9bG/Ht2T82kfxcDPQBh1LtH9ZJ9v5DcILaMMRAIRfdXhdNWUsEylfCVhR9qa
	VBdatSoeWTOurSY8ITrEllcBcyekDKk=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5826gcbi019854;
	Tue, 2 Sep 2025 08:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=//izA+gzb2Q8yY2Ihnjzzn82o4Ewk+CM1ZPZBh+u0ks=; b=
	GdqRCAOm+jIuGmd+va4ciu8fPnQUT3S3WtOgakSaHOJKYbJIZFm4tetn7zBw3f91
	4tUipOMqtBLWPZszmlESK1yayQnXsut9VGYKS4EBuMuU7XTBbarh8p2qWa6jifFS
	v/DVxPCUuN4XmrOOUq7L9AnWmGRU3T//uiI5bQMtLUWNd3Llxai4iCXmNHwicFh/
	4wNmWkLftBM64LRVfc+G6CfXrns+AiGRXTWSxU6wh5cN82HI7VPOAivV9RScrm59
	SzA5k9Q3fv1OvnWaUIMoBA8IPuviR1VFzapPFtdEbLm4vM6T9ua/1BLKlsIXKTnF
	bGhlExd0DzPuDnu0HbmWyQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48v8p4jxfm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5827Z7UR004220;
	Tue, 2 Sep 2025 08:08:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr8t46r-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LtGzsa4aYBma2rFgZQnLaWp+YXcHjnM1lX+IbXdSrYbqwCywcSOgDNsP5+VswVsms589ykXdZlwBv2R82pFET9Z287p/pluMkYuwSwEQ71gqIelppdfQCnTDPnbabFF3F5D4/8JWvswiQyLKdj3jyBVnECXcHQMnHHTkM4yBEJNj2Q10fw0tJRTSOyU/+tnAambDblTSZo+UKty1xWs9i86f3Izk6LoIEUyKg2zwaLxebB/GMKRtaA4la9Fi16h0xDmNlBZMV2Zvjt7LuQVY85z1mxP4y/b01h+uex0kBC8LX1UqfXMOLjY6r2HzNRt2iqfzUgVNeUpokGlHpxDb8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//izA+gzb2Q8yY2Ihnjzzn82o4Ewk+CM1ZPZBh+u0ks=;
 b=c/X4t+l8If7u9DF+V+YuDJpW9PQCIrxr5ty4TzoTF32jaNDzZsaHiar21bNuxuoZ2WEyTXiEvpgBCRpXMPiuwHMbY3WE7ilKs2GflXoRhjqFguGHLdqYm0/S5p5tLLATy/+CIz7dtQtCJ6aOkvrOzFcU+E9w8Tg/C4JitnahGchB+RGu5CV2JQT31PMKycDIEDmCcYj7ufI3Y+Obu+wUNFFprz4RoE2+FppKX9yf0OeZSjqt/c7bMsmUaAKY02GDJ3TKOjR8Kl9E99PTfrRPgkkqAQOfW1WW+NwozkZSPYL6EMVgOtY97zAPlArhlfXOqtfbdz98tX8msnoHpOkrrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//izA+gzb2Q8yY2Ihnjzzn82o4Ewk+CM1ZPZBh+u0ks=;
 b=Jg4cts+3M66J7l5JMEcTQosWxKUNBw6WCZrgiVEHGXHkFiocmwSfwQ697XOLRiLJOoqY2rneD+Qqquaa8ywkA3xCsmhAbDFTeP3sOZmIppF7qFim05burYFRxg/QF/YaS7P89WcDHPcoSN9VbADm5Soj8xrPLXvHJ+X+VgWfLAI=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BLAPR10MB5139.namprd10.prod.outlook.com (2603:10b6:208:307::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Tue, 2 Sep
 2025 08:08:19 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Tue, 2 Sep 2025
 08:08:19 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 01/15] perf bench mem: Remove repetition around time measurement
Date: Tue,  2 Sep 2025 01:08:02 -0700
Message-Id: <20250902080816.3715913-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0082.namprd04.prod.outlook.com
 (2603:10b6:303:6b::27) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BLAPR10MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: 549af819-aac2-4c16-dced-08dde9f7e07e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Zl0J1YZrgS6LeSWRaFykIOXAH7UVTjZY+DzI6PYTYhWin6OE9B4979UqQuFA?=
 =?us-ascii?Q?KYc8ucx3vUJX8UCYp5tUy7//8ZLKutfUku1CHDpVQDTFM68zcuXdJoQx7/8F?=
 =?us-ascii?Q?6jd0Cb3jIWvktLTDGX6YAtXaua/SvFAk4oJOlQyT77noMLB8MCSX4yZB2T+m?=
 =?us-ascii?Q?IJ7Id4IK7HD0KDkbVX3T0X2JRkY1czUIcs/TIbyDUrYr/qIn/14SyHdD/8Zk?=
 =?us-ascii?Q?xKdpPBSiX6xfL2MjfjsolTFSj0Z2S98b4KdDhwxiETOR9Q41lYPGwRMhaNL6?=
 =?us-ascii?Q?4rd8zOTwgsjuVVfhp1evwG8rpAHRuqLDW1tSicLOG7f1jhrDs1zff3yFyver?=
 =?us-ascii?Q?1NHPefLdkHFx7XcWiV6ImY9iKo1WiMZBcqIJdbiiLACygigrSRi/hBXJIG9E?=
 =?us-ascii?Q?BzltlNDDeCXbyTaFDH8+iofqE77rKYqujl20wUkUPkcFHmd4k3yhCeMgOpgl?=
 =?us-ascii?Q?pLVqjW/B0cTVeGXrvn9hLWEi4h2v6CBEfvcOe2bwVvpdCwS8fZylQf4TEHFW?=
 =?us-ascii?Q?f7g7Mz7FNuTWiyZOzM53/pZgpk+AXWXFsq9kMjp258YltuW8Lxt02s3ItfRR?=
 =?us-ascii?Q?MAFldwgqGaXtaDQIPlgtUiFuiluT+6u4Nq/C+8z6KWsJeIuYlwibMhdMVss8?=
 =?us-ascii?Q?Qv7Z2mHMbkyh4yWhvyQv3l9yeWzol31ELd1QdCvJaZWoqNhyF6rI8Lj3axND?=
 =?us-ascii?Q?m2qfsPwTCOntxHWNFLOkPl6OC5kEKZFSvZXot555f+7mLzEjbs+qzGSKlUx1?=
 =?us-ascii?Q?l9UkXHQxGR0zwdlCAkIDTwCr7aEF1sPVhDuNfl971JHtbUujJnNwG4f8w1ud?=
 =?us-ascii?Q?vJKemOw3NNrdpppaSR3Hayp5Touf/gN5yQ/U7/aOiT7xjsWN6AZrV2gdoS2e?=
 =?us-ascii?Q?0s6+3oWF0PcFoteH9u7r811UN5Zs6BFDY15nLAVLavYgL+QlIfi+ILhbb8o+?=
 =?us-ascii?Q?PkglQfpiL6R+/isuN8stoiFAm9UlviTSJpIHF7WB9EZB7/lWgXCbonyPeCpS?=
 =?us-ascii?Q?kTZRmZom10KiRef4hWkAoFnWYo1SViwPsV9KnZo89sIN0FUWDMd/JhSiDMMB?=
 =?us-ascii?Q?kqWKlfQkror1pQACZtDHiZbKv9ENTIUli//Ruxds/d85AsL7BC9s1d2btfpo?=
 =?us-ascii?Q?OotLZ7krSyx6gSrpta6gwP0WHDUr2u6WGzMtsvLWJpdHu0GZR4SAl/Q0eBkH?=
 =?us-ascii?Q?n3gd3aZLsDz1HRT30yHEEXP/+1v/C5rwDDQsNjfIm6CXwn45ewK0qEg9uf1U?=
 =?us-ascii?Q?toP/gSfeo7LwjWxKfV3kkr03pRrWadR5NjGyKdQtxhfbNoIh8p97XGLqTmOC?=
 =?us-ascii?Q?aXj5OVc+emvGaE4l28Sy1oyTpjSY6ezcDTBfNHfr1LWgX4AlLtP/FHCGDy+U?=
 =?us-ascii?Q?CkM0llo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7xwYg8ZUG9KSurSa3nQ9l7YinsmxEfOLvGB9M8u6VFkHo0gzX31ySzL4e97m?=
 =?us-ascii?Q?ljuzCRXY3BX7JxX7eb3CM3XjWwiAqyXF2Hed+wBndqtqxjcK00kAahnmzUbf?=
 =?us-ascii?Q?0q+WLkkKndsb8IhckvhQegv/Y2EEA4uIITZ3jxfX20PlEJg0d2mVMkQZl+TM?=
 =?us-ascii?Q?WTnAdPvc9NwKRQMJ50pdSvNUtJ/50WDjPRATynpL+fO5+63f5THqX1AX84Ab?=
 =?us-ascii?Q?JzKJbB5fMK6EfXQL4a31n4MpY0hRRqHY5QWmq4P+mlWIAgY3zxdjw+/Lu4wx?=
 =?us-ascii?Q?wZj9TcNcGE9slGFG/09VXaMJe/SGzqkxrp6V2Uz9/HtWcPiY0Uc0Lc0CXWr8?=
 =?us-ascii?Q?zU+Q8MtJNvnL2xUG5wlqTP1dbn1HDYTp13Rsq5ADyTdb9NEbeGhcBJeWjfq7?=
 =?us-ascii?Q?h0Ikh67X4f4DA2w830Gd9TwOvAAF6Zc8EinszIywA0yGEyB1sSge4Xb2KLpC?=
 =?us-ascii?Q?Qewxk+C+5XBiDl2J78mF3ioHZNu2EHAXg/UpKoix0fkrca6vlzVJ30qk60AD?=
 =?us-ascii?Q?11L2HzGEyrVhxR56Ms3vaFVQmhQdZfvnY+XF4KG4wDOaXCArXbbUt/TGCQxx?=
 =?us-ascii?Q?t/G6NnPaB63JNdroFRoiLfg1rnQJmA/NGKpWI9zXnplNx9B9lFDDxou9e+Sb?=
 =?us-ascii?Q?8hvQ1LIMlp1Zby+7qrUSpCJQn0M9fEf1qa2qagHrl0fhBlYqrRp1mndBSBGj?=
 =?us-ascii?Q?BXrqm5UcMKwUBC/6mEmvPHhoWX4Rg4j4iiPXc3uhLium/8QHB5BPf+ymLpVm?=
 =?us-ascii?Q?8OxeyituB8stNLdPGMv3EkRkkQARZzYJCxdjFwLrR6qmpnYbXwSu5+wvvBVj?=
 =?us-ascii?Q?F5kUkK9z639qrKicwlXWT+XSGv20CktiNwYdFrtdHzLnJkA4iUomrvd8qJTm?=
 =?us-ascii?Q?MlL6dtNIlb2m8OUzi6f50QLFFPqnk7T3JwFo5u29eg44PisEyaIqqj1lp7NR?=
 =?us-ascii?Q?8EKxifHeNiTdppAMO+AcNKwp5lR7UPGYOOTdl26mg+bJwdcogrgMPo8vdN+T?=
 =?us-ascii?Q?p0FkZmiP5WwOiuMZOzCUdGumGZ6Y6tBjDrAAyM7OUbmBUbh92ubhiXqWXfHy?=
 =?us-ascii?Q?W4JsjKuobXhqYvGJ/N2z59xhDfp3jy9JmykVgGYZ/ZF0Ulm9csaH9iAiR77K?=
 =?us-ascii?Q?u1apM8GCFy7BMXBSBY9f+DQEBtpHbhLFvEXKev/Z739ph4d6gn/qjOEJnpYM?=
 =?us-ascii?Q?lWB7NoUxRZgdk0D4ONkpN48sE3b0XDihFV+V75yWSF4UbDQQekaNomQLhVJh?=
 =?us-ascii?Q?lg+rvN81anrO6YFg8VM4WtKZ7qCITZPdfTRZH5qYt1bMKYB4NqsR2wRfBGYl?=
 =?us-ascii?Q?aQJlmyRUpeEzgiqaz8dWX06iSIWtUHlTg+HM65O447sV0XG9y+PAXmYfEqKb?=
 =?us-ascii?Q?mKsz0jU7HziP26PB18oe3EytvIDecrfuNZ5g2SdjwfxqGuf/2L2xK9ty9aMN?=
 =?us-ascii?Q?O25tHrFPgjhQ9Y9nwkUwzJaL7u52X+ZUdJ7e4BI51WLvXzskojHo/7PBnlq1?=
 =?us-ascii?Q?vpw34aKuPFtuGSqnnLibIChoLT6VkkcyQyI7i05IXS4DrZLqv1yLHIDckJkY?=
 =?us-ascii?Q?hAk3o8jK7eIQQV3k+IpZoBXqS0p9vlZRJ1e6RuejVCskYdJK5CYLMwWdw+ZY?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1ekaEtg2WGUG134NVQyGjAvncm+uNSSaQxOSEkTL3AMqMX2rBvh9FHB3i8CwqGMc6Iel3JOx2JIe3Qg0xLN1HCugoZ1Z3WFA9dzOkttaV95OVVBWOVQmS3N9GZGmiwAMlgccRT5BRDJlzQEz5Y7lkahWYBpA7hykP8/nZStL7lpVzv+VFaQpMpjF8U5ZP/ZPer1ODYs1Zd5HSLxs3rJUSGhRc+ogd6VIE2M5WJWGXkuNOxYrvKVQmPeiRiPAz3gGVT+YtsAD0iX7Q+JY61bk5xobBvitVuIWVt2WnzhUsH5Kn4vmGwEOnHnE9YGjD7Mgi6OZo5Gr5i/99kg1wt6jN142+6q53rCiQXkOR59PHBT7kGrTL0TnhJgIK0O9Q4jnMJUupq2RxAZLkmvOdCKHIo6PR+/ZW2vDrcgYJFSj+qduGqtFwAFPof0kGu/pz7tWQird7WCtxRd/SNucu976KNz8A6ku7RCLoZy9V80z96lAdeKC7XD5hrvBuP1aL3IfzUR+czfZIFOR9Yvn9fQeW9AaoiefUKYxb+F4801zj3wo/uNkSQt63ZN1Lrj6NI6mmoJlcyHxTxxaibNqIpBnm2iBBUBQHH4uLLNdkQ2NLDE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549af819-aac2-4c16-dced-08dde9f7e07e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:08:19.2100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7lkg/8NsG1Lm6l9Sr0EkAm0eD6togA4hBQK2na18WL1Mf82oiADiy5vNEPpHYhWtl4mvqrpKFVP6xO2/oj6DgbqWg967HUjqs2m97dpwKRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509020081
X-Proofpoint-ORIG-GUID: LxuNHFzvhuRRsRqomRZKGRi3QMrHAOGI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDIyMiBTYWx0ZWRfX7BEIIIzIUomu
 rjiznNH0RysdudptSxroceS4Ym/HKXGIQ3dq5jtNgalEvBQIEJhCe2ap2t0+ClOjOc6u1c1PMzn
 bdmCHG46LgVlog+6LsSnnVufMnjGgdYovS7OuIKtcDJ92WLkysgdG2i5rETX5pifppboDfeoODH
 C+JDVgp+FpDhrfrRItMTze2bVnW6eVEBJqIs/wv8BvjTzANRQDO2buFAkg3MD/Uy9HU3fNPNhYi
 A5ZhxfPmKeWBQs1SkjjD81tONnO25LL0+9Db7ZgIpcm9LKo46pHiD+zrypR3VlD0TdcPqHJKLtw
 syAtiNNuHEJQIk7V3bSIxSkh95GzgwaOblKTLPGsLvATBGEsfRxbpcCd/gGscFVncedfU8aHZNw
 v0BNHra8
X-Authority-Analysis: v=2.4 cv=doHbC0g4 c=1 sm=1 tr=0 ts=68b6a5f7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=QzB8L1Xlpqjwh72o9DYA:9
X-Proofpoint-GUID: LxuNHFzvhuRRsRqomRZKGRi3QMrHAOGI
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB1FE40005
X-Stat-Signature: yje85u3b85qwx9pnfh4oabbexbuqks3h
X-Rspam-User: 
X-HE-Tag: 1756800526-19847
X-HE-Meta: U2FsdGVkX18be8n0rG9KTc9vcqQBBzTz0A37Gwlo/a9mkvc3GQKJhpIGYKEKRWe5m5rbWvZXdHH/7z1vFDaqOxcKdrq0Tp+I0mh0CMWnY7ZahDVZozEryGqYwrtKlQEPtibprAuKectcf5Sa36asTHUDDiZxuhS25peB15Pzmw3roj7fVlqVrPn6D1LRztidnyXsIOVacJ476hWqD2Tq+BcBYtNOwrSF0hcQu5TLEI911YXjULfMXGJ+8QIom3g46WLQWYoBY/bFJyCU9P48f1YpZzX8ZZdw3pAHnI46OTi5d2cH9Au3Bh8HG3VaNgLZ7weLVs+xq0lE1GClkn58FtvHlFft+w/UpnNGgKm9U/4XGgf/vw6c7PsFD754qV157UFYMOSFA//1lYZRzCU+/C/4dcQt419ehM7RUiqWVf60hTQUDvZEHtqsfPWYl5qiAxWZbvauFEC1hLqzcUHnGeQFacUQg8WYfwF/B3ArtA+rvq/xib0CX0hX5ku4Ee7Ns+hg74SkTMli1iYEMqJB9ZlqzdZ91jqLkR9pO9hRE3g/hUQuwvziGQgY2XUgANXQMYpSXOn6GKiveHnMgQdHLlVStYfWU/oUEAMw31+M6GHtQCj5VjAegKebmnPbA0ry/0XiByii7OJK1T4zy02UyyuKhks6dDH/OOL+9vW7fFQcqcgcECM+Tybf/pszx7HXXEpTnxY0TO6idk0OV28QZeK0vUO0zATJGJU6lerczh0PRa+5FDoVANBlf3Idesj608yGYAW4PIM2IWnMx/l1dqca+2piOFR0JUApDIgBwHAc2vnhTUtk+hJPJx9RJBCepgZ/3O1SwFdKGq3zILWRr3tHLYpbc8HM4pffrlAqMlf8TdY+GilYUub3G/Nhkb/7v4wQoMkqr9WQO7rgTZeyoOqlKuFtF//ryM7ry8I/dDURDdSQxciusYQ3tzo2SPtFRc0obVDqOfi9rE6irAY
 14UvKMfD
 pMqKSQ3HkNX3+Myc9NbL//56sDwhZ0A9BgiwDdj5n7UU4vKwhLwGTImRqlpBerblP5wiJJjDiIQKiMIS1Z8H6wQJUmwABzbkzmJp9A3jKXTlCne6mK/UgN1XT48vddFtKmGyaBl7ltpmU4uf6nM5d7nzqF9F2jNW+KZS2/dK0EOGVGfLL8ZwilSfR5RHp3E/EcMiRLfMRvZQc28i9PHIDkjgl6eqDnlt/jcJJurLP4amr3dByaueqW7aOm7Ej1Smxmo3N+vReCcZQgrpZ+e3ob52lCcREAnTgDnvnRwudZKND5r5sN225MwYc9Mt8DP3SZ67vyf2qjHWe3/aX3kTRurRtugqeVG4BgZKsJE/yTAR4ML9fNi3DG6PoERpXZ97B4aNeOFHW+lAGl8ScInSDIsJti+y8zOEEBEwvloTWG0LKDik4CEsM/+prjWVGs50nzolOFHRNDhco/2x5/PsPPGOnz/QNBMTTf7YsXH5UwcOptOOyxMTgLJEfpX/tUDWtQN32Gb0oq5tRcjzWaGsxhzV1OE1rcH33H9PNLoomxRntvwgPqlIxiyUpPRKD/rZOhwz/ckoNUfBcEeRSOIlW+wiy7IpnNASgiB9yv+7UOEmtx+diEedd5UbzOIh54d8EUwdJ+7HzWDGqymlGaB6I8AznNzYYOVYH4N7n+4gUFf4boEoBQGpxU/0pU0nWt2+SicIld8VStRujS2yNoEFl8j/zQ5ZgCTcgO0kPgR6zsVcy/irHItdTm56fgMYR+c56XjKx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have two copies of each mem benchmark: one using cycles to
measure time, the second for gettimeofday().

Unify.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 tools/perf/bench/mem-functions.c | 110 +++++++++++++------------------
 1 file changed, 46 insertions(+), 64 deletions(-)

diff --git a/tools/perf/bench/mem-functions.c b/tools/perf/bench/mem-functions.c
index 19d45c377ac1..8599ed96ee1f 100644
--- a/tools/perf/bench/mem-functions.c
+++ b/tools/perf/bench/mem-functions.c
@@ -51,6 +51,11 @@ static const struct option options[] = {
 	OPT_END()
 };
 
+union bench_clock {
+	u64		cycles;
+	struct timeval	tv;
+};
+
 typedef void *(*memcpy_t)(void *, const void *, size_t);
 typedef void *(*memset_t)(void *, int, size_t);
 
@@ -91,6 +96,26 @@ static u64 get_cycles(void)
 	return clk;
 }
 
+static void clock_get(union bench_clock *t)
+{
+	if (use_cycles)
+		t->cycles = get_cycles();
+	else
+		BUG_ON(gettimeofday(&t->tv, NULL));
+}
+
+static union bench_clock clock_diff(union bench_clock *s, union bench_clock *e)
+{
+	union bench_clock t;
+
+	if (use_cycles)
+		t.cycles = e->cycles - s->cycles;
+	else
+		timersub(&e->tv, &s->tv, &t.tv);
+
+	return t;
+}
+
 static double timeval2double(struct timeval *ts)
 {
 	return (double)ts->tv_sec + (double)ts->tv_usec / (double)USEC_PER_SEC;
@@ -109,8 +134,7 @@ static double timeval2double(struct timeval *ts)
 
 struct bench_mem_info {
 	const struct function *functions;
-	u64 (*do_cycles)(const struct function *r, size_t size, void *src, void *dst);
-	double (*do_gettimeofday)(const struct function *r, size_t size, void *src, void *dst);
+	union bench_clock (*do_op)(const struct function *r, size_t size, void *src, void *dst);
 	const char *const *usage;
 	bool alloc_src;
 };
@@ -119,7 +143,7 @@ static void __bench_mem_function(struct bench_mem_info *info, int r_idx, size_t
 {
 	const struct function *r = &info->functions[r_idx];
 	double result_bps = 0.0;
-	u64 result_cycles = 0;
+	union bench_clock rt = { 0 };
 	void *src = NULL, *dst = zalloc(size);
 
 	printf("# function '%s' (%s)\n", r->name, r->desc);
@@ -136,25 +160,23 @@ static void __bench_mem_function(struct bench_mem_info *info, int r_idx, size_t
 	if (bench_format == BENCH_FORMAT_DEFAULT)
 		printf("# Copying %s bytes ...\n\n", size_str);
 
-	if (use_cycles) {
-		result_cycles = info->do_cycles(r, size, src, dst);
-	} else {
-		result_bps = info->do_gettimeofday(r, size, src, dst);
-	}
+	rt = info->do_op(r, size, src, dst);
 
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
 		if (use_cycles) {
-			printf(" %14lf cycles/byte\n", (double)result_cycles/size_total);
+			printf(" %14lf cycles/byte\n", (double)rt.cycles/size_total);
 		} else {
+			result_bps = size_total/timeval2double(&rt.tv);
 			print_bps(result_bps);
 		}
 		break;
 
 	case BENCH_FORMAT_SIMPLE:
 		if (use_cycles) {
-			printf("%lf\n", (double)result_cycles/size_total);
+			printf("%lf\n", (double)rt.cycles/size_total);
 		} else {
+			result_bps = size_total/timeval2double(&rt.tv);
 			printf("%lf\n", result_bps);
 		}
 		break;
@@ -235,38 +257,21 @@ static void memcpy_prefault(memcpy_t fn, size_t size, void *src, void *dst)
 	fn(dst, src, size);
 }
 
-static u64 do_memcpy_cycles(const struct function *r, size_t size, void *src, void *dst)
+static union bench_clock do_memcpy(const struct function *r, size_t size,
+				   void *src, void *dst)
 {
-	u64 cycle_start = 0ULL, cycle_end = 0ULL;
+	union bench_clock start, end;
 	memcpy_t fn = r->fn.memcpy;
 	int i;
 
 	memcpy_prefault(fn, size, src, dst);
 
-	cycle_start = get_cycles();
+	clock_get(&start);
 	for (i = 0; i < nr_loops; ++i)
 		fn(dst, src, size);
-	cycle_end = get_cycles();
+	clock_get(&end);
 
-	return cycle_end - cycle_start;
-}
-
-static double do_memcpy_gettimeofday(const struct function *r, size_t size, void *src, void *dst)
-{
-	struct timeval tv_start, tv_end, tv_diff;
-	memcpy_t fn = r->fn.memcpy;
-	int i;
-
-	memcpy_prefault(fn, size, src, dst);
-
-	BUG_ON(gettimeofday(&tv_start, NULL));
-	for (i = 0; i < nr_loops; ++i)
-		fn(dst, src, size);
-	BUG_ON(gettimeofday(&tv_end, NULL));
-
-	timersub(&tv_end, &tv_start, &tv_diff);
-
-	return (double)(((double)size * nr_loops) / timeval2double(&tv_diff));
+	return clock_diff(&start, &end);
 }
 
 struct function memcpy_functions[] = {
@@ -292,8 +297,7 @@ int bench_mem_memcpy(int argc, const char **argv)
 {
 	struct bench_mem_info info = {
 		.functions		= memcpy_functions,
-		.do_cycles		= do_memcpy_cycles,
-		.do_gettimeofday	= do_memcpy_gettimeofday,
+		.do_op			= do_memcpy,
 		.usage			= bench_mem_memcpy_usage,
 		.alloc_src              = true,
 	};
@@ -301,9 +305,10 @@ int bench_mem_memcpy(int argc, const char **argv)
 	return bench_mem_common(argc, argv, &info);
 }
 
-static u64 do_memset_cycles(const struct function *r, size_t size, void *src __maybe_unused, void *dst)
+static union bench_clock do_memset(const struct function *r, size_t size,
+				   void *src __maybe_unused, void *dst)
 {
-	u64 cycle_start = 0ULL, cycle_end = 0ULL;
+	union bench_clock start, end;
 	memset_t fn = r->fn.memset;
 	int i;
 
@@ -313,34 +318,12 @@ static u64 do_memset_cycles(const struct function *r, size_t size, void *src __m
 	 */
 	fn(dst, -1, size);
 
-	cycle_start = get_cycles();
+	clock_get(&start);
 	for (i = 0; i < nr_loops; ++i)
 		fn(dst, i, size);
-	cycle_end = get_cycles();
+	clock_get(&end);
 
-	return cycle_end - cycle_start;
-}
-
-static double do_memset_gettimeofday(const struct function *r, size_t size, void *src __maybe_unused, void *dst)
-{
-	struct timeval tv_start, tv_end, tv_diff;
-	memset_t fn = r->fn.memset;
-	int i;
-
-	/*
-	 * We prefault the freshly allocated memory range here,
-	 * to not measure page fault overhead:
-	 */
-	fn(dst, -1, size);
-
-	BUG_ON(gettimeofday(&tv_start, NULL));
-	for (i = 0; i < nr_loops; ++i)
-		fn(dst, i, size);
-	BUG_ON(gettimeofday(&tv_end, NULL));
-
-	timersub(&tv_end, &tv_start, &tv_diff);
-
-	return (double)(((double)size * nr_loops) / timeval2double(&tv_diff));
+	return clock_diff(&start, &end);
 }
 
 static const char * const bench_mem_memset_usage[] = {
@@ -366,8 +349,7 @@ int bench_mem_memset(int argc, const char **argv)
 {
 	struct bench_mem_info info = {
 		.functions		= memset_functions,
-		.do_cycles		= do_memset_cycles,
-		.do_gettimeofday	= do_memset_gettimeofday,
+		.do_op			= do_memset,
 		.usage			= bench_mem_memset_usage,
 	};
 
-- 
2.31.1


