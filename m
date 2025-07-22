Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467F1C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 05:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1436B00A3; Tue, 22 Jul 2025 01:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C890C6B00A4; Tue, 22 Jul 2025 01:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B510E6B00A5; Tue, 22 Jul 2025 01:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A2E686B00A3
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:24:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E5F61A0276
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:24:49 +0000 (UTC)
X-FDA: 83690761098.02.33E3D9D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 13DBB120007
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:24:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=REyE54Kr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mVLhgs+t;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753161886; a=rsa-sha256;
	cv=pass;
	b=SemJSCsquEIw0wuVPI0c5BOZvcii4Z4FgDW4N0Y0GnjijGwRtrazUicDzXe7MXmlnxhEPo
	WZ93+YGqMQzqLyp5Nzd290qMvEjeGApldp8m+jLy051SJBrr+NHicwoy+yrGqLX7rQL+bC
	JVD3dW/gjJqHE7mZnUSdzuDFriI+wOE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=REyE54Kr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mVLhgs+t;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753161886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSll+XMQ/GGC6cjBFnOm4HcuTM7fDHStEiAL050gr9s=;
	b=lvcJH4HA+oH/L4rjhGr2jpKszV3ZyPbpkQm8gQqK9PULmUo5yU1WZyi9T7rU8fYwNz363c
	5d+RM7zeDKxZ5cuy943KimL84ygRI9rebvmyk9VUOufAVUBnEo/fZkRYAmzYsJ3o8GVm20
	uLxap+NvlnMUUfPeOpYPIwqtsEOtqkk=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1CaCV020462;
	Tue, 22 Jul 2025 05:24:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fSll+XMQ/GGC6cjBFnOm4HcuTM7fDHStEiAL050gr9s=; b=
	REyE54Kr6E5WJUwXSqkcVojDOdEyA9G2sk0KtoRShRRBRPfM4/DMolxQBBv4QW3b
	+eqY6PzSh0jtjh3G3w6qcngi7+vA3EdmULLjoyuDZCUZQbzb8mfrKKOoracZ2R+H
	ISJWYddeoywgmkTbHqTJBSRyVVnGl0Usm269fEbGwqT0D3+/mb+LEO/xm8m4Fdsr
	DCzMunlJ5dH5+pTDCzz0RQ4yO+dVc2mJkvPapy2EZ8KWFXzRy/yGvz8r8emslw3+
	WPfOwv0gS1JE400vyqqtxRKeGfi2lh8zZ8UjF+6xFrWOp/AeeaddyEuZfkj9V3p/
	4K4ada/fB7x6VlV9WZPYUA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 480576m8tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 05:24:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M49hPs005752;
	Tue, 22 Jul 2025 05:24:40 GMT
Received: from sj2pr03cu002.outbound.protection.outlook.com (mail-westusazon11013056.outbound.protection.outlook.com [52.101.44.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8vdhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 05:24:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IgyBc8fZe9cttxXqenadWZQsM6NRR97bWs6YCTkT0mkxEmNnZlp8iCfxPhbVPVw6vSHoYfO//AAHwtJfHkoTNYlrLoNRU5eqs10WpcugbI+Ht0gjKFLHkzSgnwL5hDYHb054bU3KVNWHS+tyC7FPCMMawae+aCmJGy/KIJCMePRIamIHuwGzgWQkt9N17/Yd5p/SpoVSti6IS+vsfPJNk1ou1C9lqcxw60wWA8fReZQ2JysdmS9KGwqBEUmNh81eE3dRNDFfBcI7i2Ni5LWWLyPawayrZT0EiavED+p0bT1lFObRrTWrHDHGuIzVxrnlasajKA1ftTKoOmVx+MWYrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSll+XMQ/GGC6cjBFnOm4HcuTM7fDHStEiAL050gr9s=;
 b=gWZtT2R/2J7FykPu673g4w+DomjYlIvC6RvySl1+gWyFjHPE0llhuc5IUyqPb2LiOe/GB7jfsKs7/K9wemzW56e6BYIW30OnPf3kWTDxh3XnmLHbY3zLs9wBBaVrB0n1zaAHkRm2e7722mUzPqeGeKZX3nG22jG7UIQxi29IVSS+14KIjF4Nlb+RH1Df7f6AhWvHhKvFQk633uI4vinRRlOjbixzgrpA/Uzz9mcueRQj03MLkeRjx3ptssA8lqDuBIvP5GuafxGW4G0uVi6nX80mWxCxtmXNJtWBe+ZpdNrokx3QOy/NjNZj354Jr1reshVheHLd5n8ltdBpzsu9QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSll+XMQ/GGC6cjBFnOm4HcuTM7fDHStEiAL050gr9s=;
 b=mVLhgs+tuz5He9eRIIOo7HcrLmaQUI+PrpBc2AUT8oe4/r0lqTWaauElaag3KwElFFkK4ly6IsWtC/FaTo5nqujfrQJjGJ1PsPG5mrRw5Wh5jiPqJMB1KM1p1bSOssb+YTJr4y0mVZonLS1jvbzOeUaKpCetdg8cdNKX/aIshRk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4765.namprd10.prod.outlook.com (2603:10b6:a03:2af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 05:24:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 05:24:38 +0000
Date: Tue, 22 Jul 2025 06:24:36 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: update THP documentation to clarify sysfs "never"
 setting
Message-ID: <08e3cf90-76f5-4a69-813d-94315943d37c@lucifer.local>
References: <20250721155530.75944-1-lorenzo.stoakes@oracle.com>
 <35df32ae-dc95-48e1-bdb1-90f17bfd4d5c@linux.alibaba.com>
 <CAGsJ_4yMLi_+yxJYebTbEALujcVmeqbfHh=ArkZRxMwE+OBWgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yMLi_+yxJYebTbEALujcVmeqbfHh=ArkZRxMwE+OBWgQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0405.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4765:EE_
X-MS-Office365-Filtering-Correlation-Id: bd782686-665a-4884-c63e-08ddc8e00d73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlZud0dqb256OXZZOTZVVzVSN3lPWHFJdjNXNHdqdEVyc2VhUmZtTVU0M0Mz?=
 =?utf-8?B?RGdaelhDTTZwNWFqcUM2NWhod3REWThZQmx3bVl1d25xLzVMN3BrZ0liUm5V?=
 =?utf-8?B?bEhaVmJSME1GRjM4NFc3aDc4REFtTTZrdTNIUXZDQlQycmNOc0libmdhVVlF?=
 =?utf-8?B?d2xMaUZQemQwa1VPOWxkNkZ2T1JrTUw4RzhLSDhqVTNEVWhNT0lFb0lvYVpj?=
 =?utf-8?B?dEJNWmorcmE0Qnp2dEFZNk5SRDRKU3kxRDNxY0pvWTZvdFdpUCtyYiswTUNl?=
 =?utf-8?B?QisxTjgxcWpKa0VtK3pROXBvQzcxVFVsWmpEWHhMMmNjbWJIOThPSzZjQ2Yx?=
 =?utf-8?B?YzFFRTJmeUF6QUE5b0ZLVUpadXErak9YU1RhS3pmbksyaWhNMlg3S1UxY052?=
 =?utf-8?B?ajRDcDBSdmFtcGdyWDF3WjRMdXUwWEMxTmF5RUNTRzk3ZkJ3enFwTVM2eFA2?=
 =?utf-8?B?b1AxMS9WbWZZNkgyODZsOU9aSXAyRTl4b2RIdk5IeTZTcFpieXhJdW1Db0V6?=
 =?utf-8?B?SVNSeGM0L2k1b1dDcXBydklVQUczOEhiWGUvNWtwejIrVFoydjZ4Ulc4QzN4?=
 =?utf-8?B?MUpJUmhNdjVIMkpXRExPNk84YThKTm1XUXZMbTJhcUVYQnNDMmVodUxCTDFs?=
 =?utf-8?B?alB5N3o5ak9ZNE1JNlduenc1SkV5RWc4SlN2VTRrN01xY1prZHBCaGtQeTAv?=
 =?utf-8?B?ZFJvdFliaDIrRmZBdE4ycGxjMnhZQjVIcXo4QjdUbjZUQ2M2RHdVWXNkUVBO?=
 =?utf-8?B?MGZQR09DSWd5TUlpRlIzSzRucVJkcnY5Z0lqRWdKRW0rd09zMHRPaTY5emZa?=
 =?utf-8?B?WURlbHNlWFdGaWN0SEJHVlVFaDRMNVh3QjZEOXA0SjRsMXdwa0JPdjlwV0du?=
 =?utf-8?B?dTk2NjVwRHlvdnBWOWJpVG1vVWZlNEtyemhmN0hJa2kxMCtyYXJPY09GcGVI?=
 =?utf-8?B?TERqYVpkUDNkZmVuRjg4czBxV1BvNUYxUnpFdUVCWklQY2w5Ri9vb2VDNCtV?=
 =?utf-8?B?STdZcTBVVFJHSU1aa1ArTWg5NG8zODFBbTh3eFM1VnlLMWcyOWNxN1hSQ1lw?=
 =?utf-8?B?Nmp6cmxwWmNRYlljd0Qzam1sM0hGczZHUGVId24vWEloUmtoYXltWG9pZ2Er?=
 =?utf-8?B?T1JaNTdOcDJvTGxVYVVlNjhQdmRtS1FJOWxsM0RZdHFzOHBQemZFZFdPNVhM?=
 =?utf-8?B?VFl1R2NnTTdXdDFXNndYdFNvdUhncUJnMEs3ZG1DUWRPOUJsZ0dHMTY5M2xS?=
 =?utf-8?B?YU0zRnlDRnNEZkU4a011ZHBCRFZHRWpZaVRaQ250eHlpNWZYaTFlOG0yYnlk?=
 =?utf-8?B?aTl4NTNCQTVwM2dVT05lK3RzSzNmUUZFZk9zcHlybmlENEFZNmN5ZXYzWVRo?=
 =?utf-8?B?a0dRM1UxdHNpSHhBSDhOM2NNSG9RbFIwaXRwbGVGVHlOWlhBMjA3Y2FGZ1VM?=
 =?utf-8?B?U0IxR3YvWkdEVEhCRXR3TEZJTGVrWlVjd0Q1Yi9zL0hSSW00VkhkV3Jic2V6?=
 =?utf-8?B?SDFWU3NONG1qTThLZTBUR013ejcxajhMa09iNGpQNWpDUjB1WndJejRlaDIz?=
 =?utf-8?B?ZEdnelYyUFN3YlhOeGlaUVhTaTRRcjZRTjdGZmd2L2tNbkpSZmtLNytSZ0NH?=
 =?utf-8?B?U0UwOEExOWJTZ1Y0M1FVbXQ0Z0xxYW1NQWh4TDRGNHdVQWh6T2xnU3FuNnNF?=
 =?utf-8?B?UkhRZUo1ZVNzeUF5aVJOMENxR1hveVJGdDZTWFB5VnRReFZ5RGMrM2tOTzF6?=
 =?utf-8?B?d2k4bE5mcGZWRVVzbzQ3bTQ4UElHOXFEN2lhTDdSSnZHSEFXMjVGaXU2NUxn?=
 =?utf-8?B?MzZNQ3hSMWJSa1ZTdTV3QTY0Y290cStmd1k4OE85cjQ0TXF2WWhsSytVOElz?=
 =?utf-8?B?R3pua1UrelNlNmhiYWtlanJtMXpPWGFBOXJTYVNVOEJtOFcyc1VnQW9uSGxJ?=
 =?utf-8?Q?R/2F/f93zgQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGVQUmVEamtJZ0lIVlB1SE5mVHJRaG9iVDIxYmc5NHUwVzE3MHA4OEpYcDRB?=
 =?utf-8?B?R2t1SEZQc1JXWFFwRHhpVnQ0ZVlPN3liUC96Z25iNlpOcy9Ea0o4UDEvU20v?=
 =?utf-8?B?NmdmVExZK0t2N0xVejc3L2FoWEgyRW92WDVleXFQcElhcU5IMmtjWVc1cWo3?=
 =?utf-8?B?ak9ubW8wK085SmxRdXMvY2pHcFQzdnRKWmg1QkNTN3VUVkZoTmNpcGhLc2tS?=
 =?utf-8?B?Yk9YbW1uVFNiWVhnQVg5TDdhNFh5MmVCMzZHcUtNRnNmTTZiS3Z2ZklSRysy?=
 =?utf-8?B?Sm9HbXNIbmVpWk5RMnh2OHhseXNTRUFZc1Y0NGR0MmUzdW9HSTFBK3lheHdC?=
 =?utf-8?B?Q1J1UDdRbm1BTjNoUTBRVzdJZFA4WVF3dzZrR3Z4OGU1RFhRa0pBdG8rWWRM?=
 =?utf-8?B?ekcrb09LOU03MWd2N2RpZDBEZGtDSlJBM1YzNWdWN1NaRmt2Q2xPb3RYWVE0?=
 =?utf-8?B?azZtSEFoNTBXSGZRNllZWDZrWXh4ZFhiOFJGNlQyWHFwM3ROb0w0QXdsWGFz?=
 =?utf-8?B?Szd4ZG43UDFZVkYweWgwcVY5a2xoUXhlaVo0ZVJRbURPM2ZSNmh3cFZsUVE1?=
 =?utf-8?B?Y1F3VGtvTElwME1tNVI2VVhvL1hSaEU5MmVlT2h5SHJjU1ZhOThXUXJkeGlJ?=
 =?utf-8?B?eUtiL29KMGdkTHZRWm9INGpNeGVkc3VTa0F4RGdZc2w5YUJLaFdWbGhtQlBM?=
 =?utf-8?B?bk96RUZ5aGlEdnZSYmJOVVJCUmxGb3JLcnlZeHJsUFJjeHFsNFZLbEdsc0ts?=
 =?utf-8?B?VEo1MHVTYnN3WFg4SFdSbUM0aVVnMmloams2ck56K1ZPS3RUWC9uOHhFdWc0?=
 =?utf-8?B?WWFhZ0dlRDhCaGV4MmJtR3g4VXhYR0RxMG9EZFliL0EzUzBIMmk2RXRlWVNL?=
 =?utf-8?B?ODlXRVdTZVVXd2VaQUdJS1FKL0owb2diVkZWZ1hLdXp0bEdVNVVncVlKUGla?=
 =?utf-8?B?cnEyWGFFL2JVcXdITVN0Ullnam55a2kyUURuMmNwcjNzUExPRWppczdaazh4?=
 =?utf-8?B?cTVybjZ6SjZWWURRWWpCZHBnQllJMWJzNTVhQmp2TXk1eVRVWVZXaklRQzd0?=
 =?utf-8?B?UW9sa2o1T1pnUFR5QldWNURZMjhKekcyUHNRYWwveE5RY04rK3N3QmdGT1FJ?=
 =?utf-8?B?NTdKRkgycEVseFBGbDFyQVU5cGgyOHNXb0c0VjZqNVRIdHlONWwzOUhyeXZo?=
 =?utf-8?B?YnZ6T3Z2d2M1N3ZyMHNER1V0K1IrbnVnTmhnb2ZGcGl1cmN2enE4NGxoc3VQ?=
 =?utf-8?B?NVQ2SFVFSUZmRWRNSzE2L2N5VlFtUEZFWlA5aFEydjFEYjE0VjNac3VvNDhP?=
 =?utf-8?B?RStGODBOaFppai9ZNXU3Z2JxVHdCNW5ERk5IcUN5THZyYzFQMHA4Z1dRVWVE?=
 =?utf-8?B?b0E5RERPUU5FR0VtMS80d29UeDhKN1dONC9NNThZcU94aXNBWHhCYkJZeWxz?=
 =?utf-8?B?WXllSG1JU3ZLU1BzdmExekJ3NUhZZ0FmMHhTNmk1QWltQWFDeGZYOXdjNkZE?=
 =?utf-8?B?YXBHQVB4aFNJZGpHY1JESUhFRlVlSFRRdmNnVXBBc0Zaa2ZBWmRzNGhJWXVU?=
 =?utf-8?B?L1NLbHgwdmNCSXg2R05FSVJUNm0yU3k4cWp1NHpWcmpIa0lqMk9MQTdQazdF?=
 =?utf-8?B?ejJvTVJrV3pBdm1xZTJCUnNrdEVUWXZ4TmRCR01tc252RWFIc1ppYW9wZElS?=
 =?utf-8?B?bHAwZ09ZbWZOWHp3YUNidVZKazBkc0YzclRaTHJ2cTNWb2x4RTNqUHZDRDR6?=
 =?utf-8?B?NDdWYXlhZHdOejd4MGx0YXNlMmRCaW81ZFBIbEgzWGJzZFhvNWd1ZmU0SWoy?=
 =?utf-8?B?K0FUUlhGSTNZeEFpY3VNbnJNcCtZejBpK2VCMEttU2cvdDdESXJYcFphM2Vu?=
 =?utf-8?B?UjRNTkJQVkEwRkIvcEdOWklManJxZFR3dVRWUWdOSGJzZ3F0MFc3bXg0bjBR?=
 =?utf-8?B?ZW9CcExJL3Z6Y1VRTDc1YWYwenRhSjVpd0EycytCakFZTHhGaXVwcHljTmZZ?=
 =?utf-8?B?UlZOUWlISTVZOXdjcXR2Wk9lMEpaM0dTS2tEdVV1TDZIejljNE9VbnROMTNu?=
 =?utf-8?B?dGxHaEovL0k0MkxhUllkbWswODJnOXdzekZlMi9CZURHbTZwNkxJcjgyQTNH?=
 =?utf-8?B?dG9TRHFqYTkrb3lMMWpTNG9xTGF1eGUrOVRRWXN1K0QxYXhMUTlPZW1XaitF?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lduoKW9NHZtWCjlG48jla248F7d6SO7c0/5EzDUIx7hgHnGaQp/h6rB0ydp5cIPqp5KEKnXJ2TiDa3+XvblqT8gJoXPUdLPOZ1PBunOiDveWYZgAL0L18xDO8+//Lj6M8NhywR/mjJPbtVLo6ThO+FUpf983EmMlF2vRHeLiz3iJ3p9tgfWTcPaTDcWCf4H+Yd0isaTL/O80nZVw5m+/knSVNY8phsB6igpmplcg0OlpbqAT4uxqzBCNXo7CfWA1dvcOshDOW+Y3DQMUmWqo4TzEOzABpgtJjYctkZVDmeSmVDrof54BFP93/M++vRnojqtO3+vZTdNrJCRShSsgEn382RSJ3dqDoqceE6gewgBohb+zEcujdv3ItcKRTsBopXgXGyV4tjYH8AfUb0u1q1dnMHqu7c7gVpCDQxNy2fvbhzq3V93Wbt11O6+VTUjLXHAnxDa+N2Hz1yZiTg2bUMUI2ZHs9/6ZyXWr6+PVS58HUB3XkddE3lqL5j0OQ5HiCl3+mOxyNy4c1HNabWSCVgUQ0JHVMXFNb5zCBlvZtspxICbD4ytaXyf6hEtrs6mF4y3LhLoSIoXF1ToNJlvNX4ndobYwTXLhqjtlIyRCXZE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd782686-665a-4884-c63e-08ddc8e00d73
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 05:24:38.1688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DfMQZmjzB8KpjZQLLUQ9dJlMaxTkZB9T+HEhp/0q4w0Q9bd1HS2Ck5iiGFBhf8A2C1MhHxT7FyO8p1sI4TI5iStLIHdN+F9GVRdVpDQhks8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_01,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507220042
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDA0MSBTYWx0ZWRfX9xx20cFufxYO
 4rE90kWRGs5Pn/os/X0H6xkb6uRFe2hx9cB1ArqRYtvBIvHeR/JUGpIC5ZjVjAuINeuburJPFSr
 Krj8hqnorhFdxq3ciojeZGtpdDdWuRXQv/fAMim17EFXaanYGjYtQyl+drY7wWXrFSekljF5u9l
 vpDEJVWHgsalOSJNpUpsts5oCiIjmqLAWK5uYU4+Lm8Jh866AGXtSqWSnrsOePW1iss8JAY6Z1c
 9UN+zbPzmAALjI67N0btymnqwRu6Nk1gyJzKQ0T36OQ3sHWcZdVeKGJFNeyyRU9MYDtGKR9U7rM
 DwGwDBOUFfbgjeghg6rAd9C85B1tmXREwwHNBbSFnOTd7+8hd4zfqKihbZZH4TTXBGHC5CKpdIY
 HPzRW/ef/8Pb9Zbr4Bu7JwmxVmRc5RkJGpZrxkUfVbXLoOjuzlVi1tlGonB5Xm/EYAOTGIUl
X-Authority-Analysis: v=2.4 cv=doDbC0g4 c=1 sm=1 tr=0 ts=687f2099 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=SRrdq9N9AAAA:8 a=yPCof4ZbAAAA:8 a=gMB-goX5PFDbr3Dt_sQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: b0ojUn9KJnbbpfJ-CwVfCf6F6QqVgIwl
X-Proofpoint-ORIG-GUID: b0ojUn9KJnbbpfJ-CwVfCf6F6QqVgIwl
X-Rspamd-Queue-Id: 13DBB120007
X-Stat-Signature: 44jcprgc6613ay1mqhhghpsijf1m9r5b
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753161885-180024
X-HE-Meta: U2FsdGVkX18mr1eQltPSHV6THiRSDT7VBd83vBMBC/Q2eYZ8Ar9iK4HrJqpqq4nHPELXfDG4FhgqVpfl3WpW0n5idWs7E026zYE8tDMgODqvIxf2wanjt7hZ2xxxYeyCF0iB3npZchMkCSE9Ml2RotY1BSiWEDoGAgMdoMIkSogw8W9+RL7A1VEIGNbEvKT1YkkSrVu8NddVszcs2OLz9Z/YIHx4Lwhr6XqTf8VPVRDMpWfLli3hIVAuspWjhAtySpCw41PSUh3QOVWuySAhuaFlG7QW7ScMMgnlRE0Y+7ame01R21CG5ZZkvhx6VZMtpCNkf4LepmNzEAaKlhJpt12z8tjeeqQnfRrjGXmUK2T85R5UlYJ5nhZgkN/Qy+4SJqXIT11d7e3IfPPt6KaPVWfwxk37j1Ey9kq82fl/tWTtimI93nOwbsvrtiLSSrx5shPwIonmTNLto/Vh3fPV9o+xT7WdNKum1EBY+GuCoC/BpUU8jrCBJcY80I88tFuM8PcrUVGVw1T+O4WCkAnk/4HG5gGeXzgUHpxiBXRsbkZc3uRfhI+s7Vpq8uby/X4vNPJFarZ25EgLwrlXrRUlvYbjBdXUxG3sfYsRgZehrm9NHBge58TlaK6+J0crW8DHSXZM53dmhDqxql6NrEPgicWMnQhrzda8s880aa41TjIURx80E1l2nFCY+Ong4nRJi1tASRngThucxF19tgyxVH1hJcqH+fwL9Ada39f63PZjbga68K532dp0xftFESGMe1njJ3t22dI9GUwok1ryc5G7BT+t7X0S3Q3Sta2aola1p7FTGmJ3o6UY6v4wBh/93mOIbsUFE2JK9NJNE7Nm2f+WG9yzJ889JC8QW0zbJDdOhA9PjIxZyvmyyct+/GLbMA5wYOgChHdpr5daRD0FtrthiI6heSXjKgQIS2JjyzDrZZQ8BFEKQL3ms6uO8HllvCUPS5AV3lI+L5jlleo
 YhO/N/L6
 33VCP4crloNXav4EZEidQwzRHDAe7nRAcGq1HUVbNMk6Pp3M2UKz8PxzPJKrXDkKwWHnT2thu1PgKrs49g8RhrzLPUopr99P0xHPCivNjGvsYokCXfHPblPaduGb4U/C/1zbkocCjq3zpupERSgdhRkE8YNmP2UVolDiN2iAf8J4bRJxra9wQ91Mb57VTqH9YDMTh4g3qXM5Feoj6LWYkl5KN12veQZXFPpXeKFVmqfU+DFvfCilq/kzFNcsPAERTMSsrpMFs7KvblRv/RpOb/0wTfGzmqIDkL1u+ZV2BgQiUXxY5NEoimbRpGvEASBvt1jDYDmPKlrtXr9ItIGxQmsSBU93t/YHj8g6ROJHcjvQZyXolHIBa1XulFL5ZhTNQVMMTdnNRkwCbLYYvYVsAne1e24TaBaFY4kiD6Yz/1JIAhhHPudlgOfkLHaODiGCquSodtukIz5wnFQASDtJwyP0yVDY9TuKDlXhZsXehUsDfJyNczk6Lva7i3h/1lq/KXwssXnllRoJDt4/zoyUO08ubbGYoai8BFlvTtQpzdQw4o7GX2UT8zbwOWknjxR2ZAJ9E7zkLA06MVwzf+4G+bBi5hOzpMxAPgAuGUgkOVOagLdbODSvBEDItT5mjXQka/qhGQ06zNFvz/RuDJJk8a1uCxG3IZa/aEcFp5tWYN+Z2xEFrW3dmMEDH1gzSTMSw87WzpdJjWtyGoD5Av8innY2t1sGSgvZRBtKT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 10:23:39AM +0800, Barry Song wrote:
> On Tue, Jul 22, 2025 at 9:30 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
> >
> >
> >
> > On 2025/7/21 23:55, Lorenzo Stoakes wrote:
> > > Rather confusingly, setting all Transparent Huge Page sysfs settings to
> > > "never" does not in fact result in THP being globally disabled.
> > >
> > > Rather, it results in khugepaged being disabled, but one can still obtain
> > > THP pages using madvise(..., MADV_COLLAPSE).
> > >
> > > This is something that has remained poorly documented for some time, and it
> > > is likely the received wisdom of most users of THP that never does, in
> > > fact, mean never.
> > >
> > > It is therefore important to highlight, very clearly, that this is not the
> > > ase.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > ---
> > >   Documentation/admin-guide/mm/transhuge.rst | 11 +++++++++--
> > >   1 file changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> > > index dff8d5985f0f..182519197ef7 100644
> > > --- a/Documentation/admin-guide/mm/transhuge.rst
> > > +++ b/Documentation/admin-guide/mm/transhuge.rst
> > > @@ -107,7 +107,7 @@ sysfs
> > >   Global THP controls
> > >   -------------------
> > >
> > > -Transparent Hugepage Support for anonymous memory can be entirely disabled
> > > +Transparent Hugepage Support for anonymous memory can be disabled
> > >   (mostly for debugging purposes) or only enabled inside MADV_HUGEPAGE
> > >   regions (to avoid the risk of consuming more memory resources) or enabled
> > >   system wide. This can be achieved per-supported-THP-size with one of::
> > > @@ -119,6 +119,11 @@ system wide. This can be achieved per-supported-THP-size with one of::
> > >   where <size> is the hugepage size being addressed, the available sizes
> > >   for which vary by system.
> > >
> > > +.. note:: Setting "never" in all sysfs THP controls does **not** disable
> > > +          Transparent Huge Pages globally. This is because ``madvise(...,
> > > +          MADV_COLLAPSE)`` ignores these settings and collapses ranges to
> > > +          PMD-sized huge pages unconditionally.
> > > +
> > >   For example::
> > >
> > >       echo always >/sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled
> > > @@ -187,7 +192,9 @@ madvise
> > >       behaviour.
> > >
> > >   never
> > > -     should be self-explanatory.
> > > +     should be self-explanatory. Note that ``madvise(...,
> > > +     MADV_COLLAPSE)`` can still cause transparent huge pages to be
> > > +     obtained even if this mode is specified everywhere.
> >
> > I hope this part of the explanation is also copy-pasted into the
> > 'Hugepages in tmpfs/shmem' section. Otherwise look good to me. Thanks.
>
> Apologies if this is a silly question, but regarding this patchset:
> https://lore.kernel.org/linux-mm/cover.1750815384.git.baolin.wang@linux.alibaba.com/
>
> It looks like the intention is to disable hugepages even for
> `MADV_COLLAPSE` when the user has set the policy to 'never'. However,
> based on Lorenzo's documentation update, it seems we still want to allow
> hugepages for `MADV_COLLAPSE` even if 'never' is set?
>
> Could you clarify what the intended behavior is? It seems we've decided
> to keep the existing behavior unchanged—am I understanding that
> correctly?

For now see [0], we have decided at this time that this series should not be
applied.

I again apologise sincerely to Baolin for this being such a back and forth
and him doing so much work here prior to this decision, but overall David
and I felt that _at this time_ we didn't want to risk breaking anybody by
changing this behaviour.

And so as I promised, this patch is my updating the documentation to
reflect the current (and I entirely agree - odd) reality of 'never means
never'.

Cheers, Lorenzo

[0]:https://lore.kernel.org/linux-mm/573eb43a-8536-4206-a7c6-d0daa1fd7e70@lucifer.local/

>
> Thanks
> Barry

