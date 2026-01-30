Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B275E6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BBEC6B00AD; Fri, 30 Jan 2026 16:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873CC6B00AE; Fri, 30 Jan 2026 16:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717DE6B00AF; Fri, 30 Jan 2026 16:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD1A6B00AD
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19A2FC282B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:07 +0000 (UTC)
X-FDA: 84389850174.18.985B1BF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id AB12D1C000E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Gi/FUx1S";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wdE+wXfC;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5/XfMrIVNr4jGac/hck8dhyaWvy8wm0lBic5iHql7U=;
	b=tpESNqXxfj5a7gUS9aDCi4cVgkpX+yO9XRikX245IIpH6uNYvN7PNfW3EzDL1ZjS3XgoOS
	+7TGsUA7Y4Q86ubYWb++f3eRs0IFF7cyFyP7PMFNZCNvp75m7qD1pGxIEyf+VyYEu/rRnU
	uHR0KPAmpLw4PGR6cKzhbn+ac9O9ZLo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Gi/FUx1S";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wdE+wXfC;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806863; a=rsa-sha256;
	cv=pass;
	b=1gVwpMUnJpwfsv6goxcgUQMp2KfO1RQuZs0Y0TdrOqtMnbUOJ9D5jb8XZdMEI02xuACLYH
	JNSBcfEZ1uJV1r9ljF3WCIbPj4gz07WfS+aXSBiksiBeIpoG9L0qM1Ac6SBrZVM3GXwsrC
	3mxHC8kfO6xE9FHjM6qim+n1h37qjBc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDR0C3910794;
	Fri, 30 Jan 2026 21:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=U5/XfMrIVNr4jGac/hck8dhyaWvy8wm0lBic5iHql7U=; b=
	Gi/FUx1Sw6VtbFhEI16YJBRdV67DCA+XfdgMItr1JfiRJirOJcSXF7Zp68hI9glo
	OzDQQvouaVUnjPC96ZbZWgKnma3uaqgS7lEtW9rU4+1+wYvJHTMue391W+fe20T/
	4+OIYvjv3Vz+noCQbxt7aiuOei4kjOF7y9Nc4Lq5XVtwWnSvC8Jk1WLrkDIQNTfL
	ctSRvFqlpvESnLSmSjDYVUKIQGr5krDcJQrw89StcMlm1cW8Ep3DLdpIexIAsC0P
	NvIDYYsUBazFPyJyvdLgRu8zk6j3LXh2Qleg+O7jGz0Uv0gtrdrZaPdzB3BtAfYM
	9C3KMO7kC7ZYEPAUzzNInQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bxx09pm6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJV7Bs001764;
	Fri, 30 Jan 2026 21:00:55 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013009.outbound.protection.outlook.com [40.107.201.9])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhjqvgx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nr/G7GABigowlSVnBXASvmMjHe3VSMPynV3jMw+m8nRDRK6G/5Ohcc0XNMv9OagezwjCBvK56/27T21O4qCDjK0RMf9ApoMca0B3oz/GL4b0NhMwysbEfx69diZI97lPj1rRh8U58YKv3duqwh4VhnUlrLNPylChImWHv8kIPtS3K61rer1ve40xqCZQtpsUHgELNY1zjJ6kxF0aBiA42idd5/QK7BAR5wqooNaZ8AxSilBDlD1K84ydd7ifJip5/QK24x0+5lCWIbhqppLYAPBbKcsfbyAGgCgYOUx7i/4XreB/5N9tTmlh4WQTZm3TylOgQJX/tVeFHTNAjH3Nyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5/XfMrIVNr4jGac/hck8dhyaWvy8wm0lBic5iHql7U=;
 b=clt1VQgGLqxp6ixDe5lIO/wjGOOjjNr2i+FKRPC1B4kk0jBz+XDLd4Ql7cXSeWpKmquUR55EANtB+nRd65uEA7EhYLV8nwKOMjlYC13uXg3q/OssSed71fndZEf36ASOi3+ORowVajr+swK+MWKZXZJSIEAIvN6LoDnHV/nqQ8LizYBtPJWnx2jWh9u+RxAYpfWqVjvMSfvZX1oT8p7bjvYCq1UtUp7mliHKBtVCXg9F8dCz4cH70zU2QGoJZ3HEH8ErZU9GNYe9iuesLI9EkkHXDgAuEOA35BVs6V9fT8w8NbUDyTPRMGEbIPVWf0Py3+rltzxsQGDPCznZd50xhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5/XfMrIVNr4jGac/hck8dhyaWvy8wm0lBic5iHql7U=;
 b=wdE+wXfCVjclOTK9YyKVBd7RFoK8jJlEp7EeYaZQQKsT/yl2mFehp6cwVZsqQ9R6Ba1xtmu0wo62SXNwOj4ESEth1YMHy/33o1IVLRsJbTSkaIalPYe7lfkHHRc5Nfr+1ue5inhwa1PawwyMivojjVyKq0UXQV0YcThWPUcMP8U=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:50 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:50 +0000
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
Subject: [PATCH v3 24/30] maple_tree: Add copy_tree_location() helper
Date: Fri, 30 Jan 2026 15:59:29 -0500
Message-ID: <20260130205935.2559335-25-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0426.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 593511d8-401e-4702-acd8-08de6042a61c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R9cHlsEsZGuG+KVDT7ypzZnifUnadr5l4/2oeUxqGkG2eCQNIQ67VdHSzdud?=
 =?us-ascii?Q?hZs/FSOHCLBk0GRJEB+IQn1c1P8m5HGHunmSB/1bjGIlnCtoYkBauIPVkocH?=
 =?us-ascii?Q?0JJPb5Uq/nqRTbSSj+4DvsBCPAYyF1OVLoGG6+A5GtwtKENs6KrnuPXHAltW?=
 =?us-ascii?Q?I87sUEkIb8TByDNp4WMWmfgd4ikKL6Z7olYfwrSgD3Ooe6o+voWxrvQnideH?=
 =?us-ascii?Q?Ai7YBVTTj/1UjAa/zV/YsfGcnYXvavJpbjtqkkhGr/Js33n54AU7zH/1QRNj?=
 =?us-ascii?Q?1Y+F8r0DmEDqbw9qhSJsrXR7ruJ+OB0NOWl2+kUtJHbGEKXc499SdKvMMJAO?=
 =?us-ascii?Q?fzcyXPK1dlZLVtF/rlSCuvQtIycFTojCUDIhvVpbS9aD6z002qPoll9id5A5?=
 =?us-ascii?Q?/j5/zao9kFJwgq0BFbE1j9/kN9gYgM4JOIjfXLS/2r9WyTYXcjwFHZ9eYfsb?=
 =?us-ascii?Q?ZRFIjFZUeO1ifhdLyiVhZWSqz8QDTk7FsnMKnuxwuqEeYtioYRy64qREfLO6?=
 =?us-ascii?Q?X7/GlCV5xs1MYPZVw1p46HVcJjiMbYDhrZAfMcoHtS9OeeqNq6F6O9HVgY2o?=
 =?us-ascii?Q?ru1HZSW5fYuaX5gXxMwDqwxfoLUPVVzuQNXUKHfdPxkcue/uY7hYuRGTG/kJ?=
 =?us-ascii?Q?zJnfTWLasrsJM8Oc3KSGymqJKLuWwMFoo+ApoEW+AK4+yPEq+6FZpgk3Rnqw?=
 =?us-ascii?Q?dnVazy0zgCITFOJG1JNipDISjgaMOpwj/QO6C6BcnsRFz00jcd6Op9NJJAbX?=
 =?us-ascii?Q?+6ucfoudUaliK6Jcfz7xDVBoSQO/xQgwewlZcz6AiOQtS12ag+0RwJEtwEaW?=
 =?us-ascii?Q?yUEvjwJ96smyKuOtec4xyDglrb6Dfiox7qKkU3xicphy4JAzUDniApj6ZQTI?=
 =?us-ascii?Q?PXZtIie/e8Y7l2NBZGx4okZKtgoocWYrttVZxcdcR5XaRAMCZ97LARB1f9pL?=
 =?us-ascii?Q?s5Wzb7zpCa/9ngQRPPs8utg/E8Ahq5ucKfXFih9LujKPt3DDJN78phZU2/62?=
 =?us-ascii?Q?ikpmEe94dRjQ6Irp70smz9w4qZoqDWzDcmuoYzFuSLdo1c1CoyCT2TzV/XYs?=
 =?us-ascii?Q?Fpi+iLYs2FsAgHB6NL2H/wHHIUjp1CL9d2932Xt7T2npZLqLf6M4VQwm2ZTb?=
 =?us-ascii?Q?n8CmOMVmHXnSkqXIZNgHbpxJFOoDU3YAPR1mAZIUrif3y0WJRmaR9blWGODK?=
 =?us-ascii?Q?w64m53ly29lNlEmr6gs+CLvfpNWNI4L+coMx/ZRrAymKoXf3jGCsR48X1Kgm?=
 =?us-ascii?Q?BmBtr+mHsk8mgfa4Ma9LRcjoFpE0NDPKi+iHKLo9jsXNRV7WCwVsPkQpJnhl?=
 =?us-ascii?Q?AZPNT4a2QoGyTRc0Gd9OVi10Yid77uhCe54lQgty+8yPaJUB9N2n5uEsKPnd?=
 =?us-ascii?Q?ZbvqxpiFng5hrogzDH+qliXR0OwD2B0wGTwAkPkaCtjrtSV33W41zThJaKCN?=
 =?us-ascii?Q?oJH+orCCNm5VD80CkmuxpvmY/5Gncn9+UTJRuQT4XNKuWcifHXNWkIHgkPvf?=
 =?us-ascii?Q?Hpd5AODCwpnjAUU7cO5qRY/qpbo5Oza5mNCX/iwF+Sy+qCkWbJ+S60Vwj4Ec?=
 =?us-ascii?Q?sk2De81mKJk38zlIJMM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XZZl+Q59JAST5wfBRLVTiXsoU8niJZiPYdTjAjJihJdkiwZ9yRVM4nOLHt1W?=
 =?us-ascii?Q?zNrjGEQjhmThLwCv9FnBGkqrCQWX0TcLaOu68yDevuYAWkfPXjA/eAN0GzMb?=
 =?us-ascii?Q?IuCJ5Am4Tk+rlew2IqV+5tR3C64UKJJOeeAxvrH8kTyRUmOGyJBaXcUfNb9g?=
 =?us-ascii?Q?uuMpJTZYs2LKwm+/VL/54uEjClspuPp5YSwX365jTQ4nDFlfeFmn3Wf00ZkF?=
 =?us-ascii?Q?v+ang9zbWYzonFqm40VwgbM52WmtazuRUZaMRBV6opVWTTSs7kGEqp+Fckjc?=
 =?us-ascii?Q?QyXXC+OQIIJfqyM3Dk/BzlQixkkOFccEhmHpUcMxhI6hIPCzce1cJVjTFieZ?=
 =?us-ascii?Q?ED022LdQFiCLMftnZHGbrF6eYDeugfrLbWdkNaHaqkGRM/lqvZUIYvHpYKOY?=
 =?us-ascii?Q?wS6b9STOH0aN3/r4PVItTD0ThwOAnKAGQ3hz0cSLmyuOn6gSnqU98VaCMY9f?=
 =?us-ascii?Q?xBO/F6KctThVsf7L/5KNPMPu4nnQbg3qlrKFTotOQnhkp2D8+2W4MAbWu8gC?=
 =?us-ascii?Q?V1fAYJjaEMxxDSfDtzks+UZ8EpR05be47iG9D+Mh+jeGIx7utJ61a6a5YlRu?=
 =?us-ascii?Q?FSOIiuo3FaeO5CtO+BpnGWmI8iDxHMmN4DtYRiznLotCjAYQ9aO6uMx8opn9?=
 =?us-ascii?Q?XFGJCsDYS0uwRbnDaD9oBV69B9dOW4JYkF5p/XbihUsgc5ezNhhjWv133yD5?=
 =?us-ascii?Q?V52sU1xn2GAPvn5AdrcehOkOhx5EGIXXlHng9AFsRdep7ClSLscVdwTxO27E?=
 =?us-ascii?Q?stPOeJX3Z+c6l+22DLhNwEMbSr54RIfv/qkDSWof4TFZ/y5q2OZcPr+dwqhb?=
 =?us-ascii?Q?50XbQKxpVqrAJi9pEgD9gjS3Gxd7XP9sYbX0JDmbbRXkr/TfxZTARCnSuFXr?=
 =?us-ascii?Q?qf7wjcMMwOj5RkV8mfY5vQe2QKgQHKTHSRQz4uPy/i/NBfnAQtrizH9vs0Xj?=
 =?us-ascii?Q?iDr6XZQc9OTAIJooC9KLQXGh/X2sPXphrJKQGsNiFtdKQXtOd60Q+Ml1puJR?=
 =?us-ascii?Q?ypVtwAwC/kDjWnudKLLf72kItS9CKQvJv6rkDQLpa4/uRqjHWx5PNm9zUzSb?=
 =?us-ascii?Q?SC4JCJalTCP0zvPiPRHQknTGrv4tUgejC7+MWTxKq9safGuOsScMLGuHH3Vr?=
 =?us-ascii?Q?GCtgSbpkpHZ8AS+yYZXlqsgBezfX4UtW+HgwPPctCs13LMuMqjJW69eqQNE6?=
 =?us-ascii?Q?OLyGwLX6PMgh9M+up2/qJmaE6c3cT6iLlZfamt9/iYp3Qe18keN/BzhdVJ3w?=
 =?us-ascii?Q?iGCNZ42Yb+Y6sgmbtp/xY9/PDWv3vop+8WV5YuQ8VqDKb8u9o/MmINyjr3bS?=
 =?us-ascii?Q?O3nTwzSb8U6vHNyhjZvBZ4eI0j3qr2nKijgYtA4MFgaJh0Y3enxzbmahyAcm?=
 =?us-ascii?Q?X9MVQmWqqS+KUSRcO5fB/laYBnVaKZTVbLD8Gp4Igq1kxJNQIZz7TMdh6Kc6?=
 =?us-ascii?Q?4meoQZ9UINrsNu5TnY8eEQiceKIZSb0OYe6Bf7WfxFQ9x2LpGQ+F1T+OGALB?=
 =?us-ascii?Q?V4u/PiNmrp7QTmlFarTOveoYf/6oAqp21U8CfvY/ZmlGmSZy5d8yGNsKBw+L?=
 =?us-ascii?Q?10crRpOrKyLj45uXfCrd2G6iD9/asodK7Jlh1Vpg0+A7UtBYzNN3n5MjPNIc?=
 =?us-ascii?Q?MawgcxRKGyBCppk+k6z95cXoX/fdoa/JrHBVtV3oyJY4dNZxXtC/XGEDzP+c?=
 =?us-ascii?Q?0OkziN0jObsWGumuw5BF+bt7FnU40HEanPvYLZYoZPp0S+IhrGVH6P7VdeA4?=
 =?us-ascii?Q?XizRpo3ZBQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mdqgqCthwYc32mwBhGXDswEN0v64WLyGvCVxCORCIPN054UNCynf/PGYlrf0x2nx4iz050N6zQ4fLsyZOv/35BMAyB/GLbjmjy8FPDk1vLC08PmofobNPpb7Gv8ExzdkTfGTQf6erTVt8STWXQEJvprWxuQLkK9MD5dWKGuXNhXlYDULGkXn1hnlaDTqCIvHGADG3OxcG83KvnQtOAEsBjkzaXmu9QqXqllDTePrh8bas+VFC26btDT7sJJrEP+ZC9SzIqKPcwYIIEOWmu+IFGhwm9exTW8c+jLX5N9Xp0vCl1Unqis0ucak5/I4TB3XyTe2TfjIEy6rsRxyEGj9lk67tWUw7Onq4trTuf3haQTYy3hMtdvBfMzsnYbnlnUcco6/J+ZdLkVPuHX2ppmmquQj3kcRc3pPqn59MScn92BEfzD33MqGf9AIuGgN0nkcfXEDitjrY2LMqyxEEs928Z+XvKSsLDNMVI0uNXTlrwCMGtTKSs4NkwKshf6/RNdd5Sf9IaaDZsyipoLnjnLmD1TanxsYLbXfrNrrB2METkiyVUvhdxkfhyrIoy7qU7I7Agb7MJKG59ZWjJwELS5w53C+/KU3Pa7lMdEdAl2Iw7Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 593511d8-401e-4702-acd8-08de6042a61c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:50.5032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5MfSvw/XUqJsxSEpV4gPd/N9G0/u0h+oXywmrENRTSZk3IMUBCXIp3NLT0OPR80x2fv5vgbOw/Jtp637RDbsdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-ORIG-GUID: 43-0F42WVelMUeiERcnMpTdtOT3q0M_f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfXzb/HBkpPLdJJ
 p2i30FqGsTh11Kk05nCsLQrL4pbad82v0Q+CG7E2hfwLIZCwDWo+TBN48I06eyJYBn8izrhExpY
 VXyCDF5XYPfv8GqQyRWskGMRfCkkKT7FNVsG5JXNma8+VnqwPfl+puuqm/cPXolzBbG3YT8u2fP
 Ne9y1MkeWeMonTGHNse9k8fiRfr+mzqxpcoxwYhrpn1yXlRlinEzM3GeIwwdB+EFzC4rDZhnkmD
 bIE6QVXlPkVIADyrjoUW1FgLnJ51SHC+jYm8phaQiqE8YExnY6sw0b4qbnMY5aT6BlG/tj4zfcO
 uvJmb2lHm2tDm8ZS+oZgcYmZJa5YC4w+pymuDFtB/kaL0rh0+XxaGbZa2A09s2DgLbBs9SR1vt7
 6SDMe1AGvsT79C5slrjGbwFP0+umjjPk1LshbAkp75DcGOAcfNKpVsA/HZpj1AOadLGKfy8BDAK
 weRH93qzjDdv9io+HlU1Q+MqtHORsncxLB34TZhY=
X-Authority-Analysis: v=2.4 cv=Qe5rf8bv c=1 sm=1 tr=0 ts=697d1c07 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=QZEmuyFpAcF_U6Uib-IA:9 cc=ntf awl=host:13644
X-Proofpoint-GUID: 43-0F42WVelMUeiERcnMpTdtOT3q0M_f
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AB12D1C000E
X-Stat-Signature: gx4tc7octostxyr6aiygzoa4oobas6wy
X-Rspam-User: 
X-HE-Tag: 1769806863-95887
X-HE-Meta: U2FsdGVkX18e2NK8JZyPCX0eqUB20+PMTEwIOzf9Snrn5ecMS7wHl3hGa8T/QVC8D1o+OSMaQex4k6HkaJK9UVwO9Yr9YhqnhFsbxwoG9aLz/j8G0LxxgP7hnYIs3fWlOKtmJZQ72yg5zhREGhyV2ssKKnB6DgkLAhcSLw1I4mty+X+vYSBSgmXlvXTb1b6cj/g80dy2mzteFZhFwVr5ywoHlXWa6zQwkIhyfrOGVvXykDq4aHYob50B87aiT1SH0FfGigZTSbu8a4Z2AfJHKXbdcTPswFowVLrPia43nSzMBDsT+XpoOgSS7vkMqzUpOyaCmrMNVd/7BSvFins5SRrxyLDpSAfq1V4lrnRJSCsa6cAjr5FJ+eilCawtlbcKcWhw0g8ZA7OPM1iXu/tFNOg6TvDbjATog1ZOP+Ijngz1NwFFAnkg8pakDjUxkOwV4bvoGdLWx8lKuRVHJdC1PuHLUSoADVax9wpUeJq8HckUZGaITwopEb/L2dhTRSS2M22Pp4ttsMQmF+Qsl4nmRuaX6/Ht9BoVRsof2r6U0KFsN/V8UD2wgxgguKAOHks3h9rGPZ5BCq6XTXsxKeXqYBm6mop1O0eiapXXZkOE+UrbRoWtqf0D0z3kPR+wEgglsPWyL257O6KjZuBX36HxfowRxGWX2thWtdUS3Fp2EcFNkC9rZLoe1dFLZMKFmXwFIlXy/8xhIba0xTZav75BJhJfOcj1uKGvic4MhAOkulZ/vLCSLcKI3GzyUFwIi8sxriJhPv+0xjgSdypxh1NBPbFCGGARJK9g2GsLPsjjIgHpAZe2Dyn7bZgeSYtxy38IjFwjwKsmqdwzrhGjb3UVjJ+XWNTxLpMVAY3deNAtph4vGEJ3J/FThDF+n+9odrJ8C6tbWuPxSmSdkRjZw4cIJfM7k3m5fx+wmLGyTTMomZUWJ7or+nDKaDHKY35/AVTW+NJC5U0pL+n49+ZvwMf
 v2C5NzK5
 VmklA24FX7G6UU/lMCsHwRduPY70R/ZUNpxMEoZBFTyYjXSKCsTD9gcGj6vzJ3MnByVUzFdW2hjip4OBulgtZzm/jj+iD6AjdjQ9e/NjGqm0PQANOiAYvsg6vWBSRfhFDA5remFLv2lKaTKa/UwcmBer8ymIHj9QBdv4BOkYkdaFLaT08BsXTVRDXGVOuVnYPKwvsSvwS42T+vtrRwAZKd39C/SygLTAWVAmIP9T02Zq86QeuBP9xNUZzsLOuXxp3qhYcOBHZJTqfWqwGcv3zyzeAuN82eT1SQHLHEjrERS03K+VA2PvNiLpoi1nK1I2Vv43vAk11OBGCg9mVzdy1g3PvCaDNIQ8Ym5JUZ8jvCFSEDEfYrEw+58nxQm+4hKYVE7aDHTpaJfVaoWXTVWrtR3qrjuMJTOOmiKaZ9b4Ht7xNvsPZj0GS31bA+AOgl0b884KXp04Hq3rdbxTm2E0cPpt+jkOLYPvWyQxrqWVnoZOe/Q+KX54VwZM0/984vvOMkzBTUhNOVQ30BWiHZFAyjKZRUqsBGo9oXri0q34w58LnwPAPsFgVkTwEXNSx91fW7jwnWvH6flcB3gw9wCj6z4/75xYl25SUeLj6C3WkUJJ+7U/BU5O3MGkxCdr2TEZe61LH/Fql75BgJis0LreGK6zAKUNevknRTdV/SP3OOliEY/I9wTmjlDDmHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the copying of the tree location from one maple state to another
into its own function.  This is used more later.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 0d5d68913de44..1e79dfbb024a0 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3531,6 +3531,17 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 	return true;
 }
 
+static inline
+void copy_tree_location(const struct ma_state *src, struct ma_state *dst)
+{
+	dst->node = src->node;
+	dst->offset = src->offset;
+	dst->min = src->min;
+	dst->max = src->max;
+	dst->end = src->end;
+	dst->depth = src->depth;
+}
+
 /*
  * rebalance_ascend() - Ascend the tree and set up for the next loop - if
  * necessary
@@ -3570,12 +3581,7 @@ static inline bool rebalance_ascend(struct maple_copy *cp,
 	}
 
 	cp->height++;
-	mas->node = parent->node;
-	mas->offset = parent->offset;
-	mas->min = parent->min;
-	mas->max = parent->max;
-	mas->end = parent->end;
-	mas->depth = parent->depth;
+	copy_tree_location(parent, mas);
 	wr_mas_setup(wr_mas, mas);
 	return true;
 }
-- 
2.47.3


