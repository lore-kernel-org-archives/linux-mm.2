Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E69CACA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF3E6B0023; Mon,  8 Sep 2025 07:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422068E0012; Mon,  8 Sep 2025 07:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29BDD6B0027; Mon,  8 Sep 2025 07:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9366B0023
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:12:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1B58140AC0
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:12:02 +0000 (UTC)
X-FDA: 83865818484.07.495A394
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 14DB9180006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:11:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mljG+8VA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QlJyRUnY;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757329919; a=rsa-sha256;
	cv=pass;
	b=4JOqn3KnT3nNeSDyNgBZAckVyYHL8s+lVXfpAZduua1YKWKaofNTEF8nDeDmpToURFgrzO
	KPP2YUERashEA1DKUQedFGX8+UZ7uSD0FT5TfvmXU1syOtGjD2Ik/xH9soHCIiJq/6KwUy
	GljiFxbL2T2kAgmvCBHj1iuXgHFmGhw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mljG+8VA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QlJyRUnY;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757329919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jFeM+IklPleV0gR6/nJieTKITDf0dbD9LUtd2DY72B4=;
	b=wvICaeFX07LE/QqmFyhb5DEeyCP9EMstcG+Vb0IFyDa4UXX+Euk/mxOlsjjEwAPtRhymW/
	gQbE2B26RqBkKGwWiM0yXUMkDCrNcCOcUeis3O2v27SzZRzLrfYPAO618ovtMVxQnzDZN9
	IvyWBwOQ+M+qtjUiP5MvyFkGeTwDp/s=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588B4tN9011866;
	Mon, 8 Sep 2025 11:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jFeM+IklPleV0gR6/nJieTKITDf0dbD9LUtd2DY72B4=; b=
	mljG+8VA0Ug0vViUJusk5h4k9s8NwFO9S/NZ+4DKJ1KgfGfgUrjjISipsXcKuryP
	laVC4Zuaxih9HalPszNQJLI546EsHTxMe8AIWNm4SwDPOgz5YNRCO0O468XQh2By
	mr+QuJMLBRc1MGCE+f6VpQYRsBwyb2RqRqD6z0UDKXMVMMTOIFY2wJ4qM0xGpZgv
	+14OFW7EntFgk6FUee/ATwjbxhvYf1aMRDBKrIvRBufbjsI8dQc5D2oI6PO5hXNH
	h/c5pC5y0Hm4Kau/xrtH6VAdrtqSs+y+iIclgGRthYQCzdp1DgFSrXn/j6Pg1cGJ
	Nl1I8ceyjIzpSzJzVi5OCA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491wxvg07s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 11:11:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588B6G9D026049;
	Mon, 8 Sep 2025 11:11:40 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2051.outbound.protection.outlook.com [40.107.102.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd81nkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 11:11:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RFPNoUAytJA5B0UpPrDVa1wpeWVL506QF8M+iQQQpxLYL/Iiex6NlTFw/cV3Q6EZpMX9TSn4/BteN5raGi+I38FpuG/2YuTwptnMYUW2VQRdqXcBAaV00d5KM4xbhekpcdOzxSHPBs0pCQd/NQpSA3FhsCPH3Z8G8GsXml8ZOdufsP3Le/T8zbdkJWpfjFFRxWymAi/vUtlJSviNjtXpLrMgNkA3h2u5GIVxEsnr8F+PguNveY0pq5lxIcViLU8y5C3FTlFrOdbErO0LZs6bXZ1T7RCJNCppm0QrqyfDahsQBWrhfvDUrFNvw/a9OrEOJwb9ZLPPvoAhqtlEDqiWKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFeM+IklPleV0gR6/nJieTKITDf0dbD9LUtd2DY72B4=;
 b=tYksr4y3Oe9byJJyCpOGKBvY7z71zvKxg4AR4a+X8jC2dp3erseEI1qWEQvzr7YWUs1oVCuflJbr35W9/L9fyzeyAnH0Fok4MoigIocGghvfds/zKPRK+2L7bPSkpmxD+jCUdH8W+Z9WFeW8M79QpcYa5+7OkcE26HOqYPcU3Ut5AKwhOdgbBWeBVRiKAGimolbiu7U5yOOKEqvNe+XnJOGRsmHvb314l1SRbup11WBq7taE2MTtm3aemQ1B8xrRogSXe4jMgZCFNGbiBxzk7iNXrfBMY71rSjZmlFs42YYolIJIdy8HeEvUyyja21+zwj5npVrs7imtxcNtZE9lDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFeM+IklPleV0gR6/nJieTKITDf0dbD9LUtd2DY72B4=;
 b=QlJyRUnYDXeXYxX8ukI1sEZFxCT8Z8oZO7NEaBokfkNT6x2iEF/JPV0TdcEVQSZLuxunAh6h3Gc/NPYLLJ0GVyYK5SoNXL6EmpJRGHPHQQiYFrZM0U4msIRTp3trL9ASMVsU25HdfI9I2vuQZQX86H+GYXG92RTZ3AtEl/M1r2A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6588.namprd10.prod.outlook.com (2603:10b6:930:57::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 11:11:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 11:11:36 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
        Guo Ren <guoren@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-csky@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org,
        ntfs3@lists.linux.dev, kexec@lists.infradead.org,
        kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 09/16] mm: introduce io_remap_pfn_range_prepare, complete
Date: Mon,  8 Sep 2025 12:10:40 +0100
Message-ID: <68b2571de694e883b8ffd6cdc0448849ae67b683.1757329751.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVZP280CA0055.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:271::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 097ccb31-adda-4479-90f3-08ddeec87a1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?URu94y6dwJpUkpHAiK1ZCCnSPW48zOKrETiE+/IP4+p07IgigUmquLdvrXVw?=
 =?us-ascii?Q?u2tV02kA9Iwo/VNMyh095x7eaPb55PsRxQ+hYvnQovIzyE5Q6ZwDoGdNKLpu?=
 =?us-ascii?Q?e4BDey9gQLXdMIH8Q0t4YyHwbV7SuDn/XOk0btJF/DG00Yv1+3+gywYilfbP?=
 =?us-ascii?Q?Bgxqs0mhrQEpD+D8HwVauUBCLGjkbhMWgPHxVDKnCj/m6G4TAzlrMk0lSzuL?=
 =?us-ascii?Q?zuR3vBrS5l5Cv5UMPVTSKDAqfQsYKJ/UH4ARmo09YIbDrLFpWYGkmc5vit9g?=
 =?us-ascii?Q?PSKJWyHrQ5HoMCIgJh0u4cOwBAzRhsBNsQl+iqodtArP/RkjjsZU8QArbdqd?=
 =?us-ascii?Q?msgVJIw8YZSIG4ZvuK/t2iFIK0+B7+rKeJBe/TBw+/RqqLDMkZj6tJ5mbVyQ?=
 =?us-ascii?Q?UYIwJe2KjhcKwpKmHxAw3powkc7JitDMOawY65QoWvYVAjUaM+kUiRykyvS+?=
 =?us-ascii?Q?GNcBCHYDJF7duwHwZH7F3zRDcC4bHi57vyNS9YkyuN8blPu5F0XElBSMFrvL?=
 =?us-ascii?Q?WonDW8VIoUl1hoCIk6DSxtOOHqKybAncGzpGiDFOCJZt5be+QA7zwplg/8GI?=
 =?us-ascii?Q?QAQ191wZz5jit9jaf3O1dpUVFEZ9my7TtLGk0SA7VNsLnjYMshEK0fF6ZMav?=
 =?us-ascii?Q?q86cc1GyJSIaWYR6j5UdxNP2DtPhoWnvY/+ROPld947KV1By2ZOSBxuV8sFS?=
 =?us-ascii?Q?LyMR981vHTci//+2e11rCj7zMEggfUdHhLjs7r1mPc9mgVakXkZHHMJjMAv3?=
 =?us-ascii?Q?ocvRHJAYd9G5p02ct8cjVwnWyXuZw1n6VRj9WC3ZMVsJjMWlI6brSWgSyQoF?=
 =?us-ascii?Q?NZCRKVu2TvW19i3WxhlxRkgiVnwxJj91kcxZH4NEGv2NMBRmZ5s2YaQ2+RP6?=
 =?us-ascii?Q?0v4Y7FjFah635ghRFFdtfIfiTEBpGbCRsl0Oultz1kpoMvc9xKjfmhatEi+h?=
 =?us-ascii?Q?ALala/q58uBcxq5kIBibVhgLGAoUju6m9FDg46Rf4a4+RvbuZb/+Xbhyj078?=
 =?us-ascii?Q?893STAd9EtOLJLGTWjJ17NRz1tcB0KFbscKz7+Fphd8p6jPZ5Y3qU9ritQH1?=
 =?us-ascii?Q?h1tD/khjn+TYM+nv1aHccUWE3e5jipdhvIgbQ6ffHoh2yRHnpQnlOnxlS+H5?=
 =?us-ascii?Q?kaKM0KeeDtx3X3070R18eT746zgSS/Ol6+hV91MvSZBex+wPaOBqNkbWeuGu?=
 =?us-ascii?Q?CFrLHMwxAMUsihFPAWlpPjpAAHHYgFV4AmJP02PW7A/V6OhhlTTC+uRJ+yz/?=
 =?us-ascii?Q?NtwDgLvbdmhPRAYJqugwCtjKfIB+u5GlJXt88D88a1Yv/5CPJ/aWH+/301mN?=
 =?us-ascii?Q?KszYFS+AQPiXlAwzDiEezmk5WherlpqVVD51sX7AGJgubevyuGkuA8/5GMEu?=
 =?us-ascii?Q?H7aaNH+H6rfAk/UAVXaKvvk/xA39l349H/UngVOkZskiRhzzoIIhc0mO6mDz?=
 =?us-ascii?Q?gi3Om8Gu2pU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SWGRzDC+FFLFwQEpOhMnHeXYj3bRGqvtxAL7zyQxTrC+oYeY1b0ElNWnaroL?=
 =?us-ascii?Q?mBHl4FnJs2bZ0/bkfjf7P06nKq1DuEspRyp09TSVJJ1M5kWOdaGPO9BoP6cE?=
 =?us-ascii?Q?UngC5uD1ueBRzKtNo2ydVliF6cc8Vc2DYsJ/Px86E6xeJE7nCzXG2/z7IYsb?=
 =?us-ascii?Q?tFYnwju+fsr2XgLPBM9LbYnpijY83wWe2XI4sJSTzIvBDQmZo90MOIrfPvMI?=
 =?us-ascii?Q?GPqshr/EISrKJtkLBhtZjTCCFV1tXmBPQAKpoqVdYfi2C92lSJWcZDlNvYgp?=
 =?us-ascii?Q?WsJAVIwlRYb1OOASbLJXJkp18LqNHZZoi9V/eOTDM1an6eS6xcXCl+y99oJ2?=
 =?us-ascii?Q?8vOfUrb89BixgQfx7AkEmKv7VPrEthgF3Ef7dk24Ii3AbhuSzmxq105oqZPD?=
 =?us-ascii?Q?FayISTA8P/QFnPeF5TECOl2jOOX9ms5gXz8cRF+aAD2sCa2NGpum5+mRfW4y?=
 =?us-ascii?Q?tx/hZjD05mUFpcVYVA6tSCoVZ5rKh9rfIqCrSuwR/iQ2yHaDxPvsK2/uOIxL?=
 =?us-ascii?Q?SaxS4bP8sWsqIR0GVf6MMq1++A99ab7dJBSNSl50w5NXseCTRBOFWMg1JqpE?=
 =?us-ascii?Q?e8QCble2YkCcrft2ONNvn92CR/IBa9Akf3y6UTUlepeZvniuxFXTKq3giRiK?=
 =?us-ascii?Q?sMKJHKZcLvJu9alDYSeqfEhsSGr1w2pmPpJubP6qT9O1rMLDL+IiMR8w5YZN?=
 =?us-ascii?Q?kSsdYdveoo1lnkHkSaxtKgykyP+6yzpIT0oRUr/P0k51FS4ujoFTURZad3Pb?=
 =?us-ascii?Q?6Cg9Q0YX9INtaZIZDgeJL9vt+GWAnALecrpouvsmy/cPqGmW6PSfRr83DjTz?=
 =?us-ascii?Q?KrIHIHpuCcDu9WxojmKGFDltS61Xy33RDowkDnp7xq+l/kbzM7wNcHWi/uJI?=
 =?us-ascii?Q?XgyAM70Q4/B/waXoSmyMwZcnqW8StosssunJ2crYzEoBdOazKsBbXr3xwi5n?=
 =?us-ascii?Q?mvJbanJwAAr4oJeoLMO/1s7vXqUUIHPKEH5x0cg94w7unYSaMFOlc6qW2pQW?=
 =?us-ascii?Q?df2JFzi7YDPS0AOc51pk0IuhFbzVKWhOar90bIIDFZrLymt7CJ4Ds7+KMFIo?=
 =?us-ascii?Q?ABRr5tGoGf7f+8nIa+nD/ptmU+4WeoY6i98oeM35Zx9L5mceo4biKWDUW6KW?=
 =?us-ascii?Q?6T9Oo8Pic6aKPBjBa1JXdq9IsUULEZManqWCZjUYMJH04JDbCfkIpb1bzJqJ?=
 =?us-ascii?Q?te22d6vIH3Um27x7PChmxIcDqBogkzU1Ylod2RAV4ST/FV6eVOKenT9ni425?=
 =?us-ascii?Q?VHBGQ1uwwkTZoJnsiAaMF0I9akxCPzxS8CPTGLJ9c4V5TZHzmrcbqpnR0ntp?=
 =?us-ascii?Q?Y5wd2iVWZVqvniTXZZBI/sxUtwUgK26CW2XfNBaabwPCEuAKm/28z+54SnWR?=
 =?us-ascii?Q?7cU1ecojyTtKjPZSs/qWgMU7oq+dBDtKXtxP4MWqTXXfcaJgB6W7y7ZtOyn1?=
 =?us-ascii?Q?rBenrXJZ09H+8StFZS9HpyNn6e788UPcCrZucewKY63NLT7Lb/uj56U4jNKC?=
 =?us-ascii?Q?68q8pvZUmDtjaVi9kbAm6FLTgyIAwGkB+dSSSdcgEraSd1BASEpNVGO2LYf6?=
 =?us-ascii?Q?6FvHtbHPNLJy9RoNiSwxRz0tg0wWd88KsRqkOwHXwB8ayiKRS4s3DTnVapQR?=
 =?us-ascii?Q?Qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x9JUtJoUqEDI2FJ/cTKKOiMuU1ChK29OlvIoWihoEnUP8/GyPV1TF0IDdrnHU641L+was9O59FJ2CrSVlo97+RVHP6bQdEfdvsw7g8qqFrdkho+oKjMohBSOiuSuCtgv/A9I797OjJdXd027D6H2cOGkn91zctO4u8OUlitij4kwX2cdNPOEjQk1eCgwUqaO93c8VwckeR3fJvR3GxdHmTzsuQ/+dF+xTpW8pXaSXVja/XjeV4AWOURvG8gR+TI4ybruxFGZODMfF9EaDynzbnobfOXgzu2w48Z+/1EmKteoM0wFW8Sf83jgJH1I/R08TKfdmED3FNE24fqW13oeG82YGMLh3ah5VgUFdQpCewkEUNeYNVuEpxdxvbTdtnn+c70faiQ6RdaEr20JI/ko62/fxOboiaj67r5MWyzlXXENBbMppRhCDIg0NEmbqeWRfZ2S/hmbHIkwOUHhssVFNaMV/4uW6kbev4tpaGv2ITVl62lyZ3Xdu5/3VBskbwfkX/0k+3g3IwI+eU/9gZrL/Zb+XhDkb0ZVya9fZWY4AjuViFdHlVPKHzQMwMZAPOCwHskn1bBPyKD6iCt2YbS9mmdjunAOc+JsfKAUdU2un5U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 097ccb31-adda-4479-90f3-08ddeec87a1b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 11:11:36.7753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZvmJ+NDJoteXYzZMfNTZNTQlcYP9tIbldcwnEsjoUlR3DPsT5E/gfBY/1E8E8F4g8W7KWrIui7ZcttEkiOgYc4+fNR0iDluEOvOibEIqqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6588
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_04,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080113
X-Proofpoint-ORIG-GUID: nKFGd1X3n5saloJ_nqdHoji6ovMgfWna
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDExMiBTYWx0ZWRfX4p5uW7hd/ViC
 7n7ZE7j+T5GJCVyUqYzEZ6Ip74jKnEsnGqe3eeFaE2xv2r2M4FBi0QnPgjetAmpJeGC70eJN3pF
 DebpZD5Dhkn1VurkTM7nl/DEYJSz8FoNSS68xSeBVVPYN2IjFGkUr4AWlWAJiUQvPli/eBXfJRx
 UPhcGfugqd2T5ECfl0cikkkAGTDZAwnuqav1m/ENm3/syYtUi7Aax2o9BbAuZHmdUPU1M9tNlli
 Mdj+5X/4OllWX7Tr2iBamOpJBj5GyRzprmhLBdcy4SIGwTZBl8WFhItTwylQWwsZldjydFTrcOu
 UGK5NQRiGQ6HVxiJWE/+QDiVqMrRjzgTYT5yZ0w4h8OvV4apJdvzkz4FT44F5Szeqh3qx9EbuDl
 18L4oS3xaHlCTNhRQIkRqP0SHlbcQw==
X-Authority-Analysis: v=2.4 cv=MIFgmNZl c=1 sm=1 tr=0 ts=68beb9ed b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=8VW42N-dlZBHzYBeMqgA:9 cc=ntf
 awl=host:13602
X-Proofpoint-GUID: nKFGd1X3n5saloJ_nqdHoji6ovMgfWna
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 14DB9180006
X-Stat-Signature: jmmqx15iuo8z39wx3i3fuu884yct6aty
X-Rspam-User: 
X-HE-Tag: 1757329918-439193
X-HE-Meta: U2FsdGVkX18T78UijmmPJX8L+nr6rUCv4I/v7ll5zyppVPG8ZzJ54qWfUE91+s2bADXXNy8h9yb+uUFNNDHdX0BFFfwIYZ+1VURE6whGLOoAjYjJsVQ+imEMnDaNuiS2tY9SLWQxL3PKanfp0Gd3XWTpuALS23YAhymq7g/EXE8KjRvQrF32Cl8meMCCKWMOe2XqH1bp+IX+pZoAR2nVX7LQ2++A5oUw7oIrSnc/ZjsDxI8JvW3fg+2lfuElRJQM0SV2eTOK2Lso7pvaMuZNT1UvbCIjo/fozJsioTWWE/Fyq0pLYPmD3i/sr6zLvDnckgQM++JJf41IxX1mBGpQbKw2Tj4ZMizc4YPxIQwEWn7LddslPsZMRCFObOIlGcsDTRmyUAxEe3kvoH6IBNJwuPYFQIpuh2QD54W4FczAyezb+qfCcYfLmLM61Gy2nr36KZ6G47gGtDO3d7arut4oe0sEmMZ/sO0oxmaJnYJWzDnR1TaEKeiUl7KKKpq1giqFNUW75MElGuq15TgZbnSxzP2P6sQwDUAJA4m8IhoZ00f/T+V4us2pIPcd6qgsrokAvHEoO+n8RiznRmI+4PntUcvMKy/I4KUvWzMKDv89uaQck0QsGdY41TXaDeuMRnXdqcLbTJkFWhKYdqmDSli2KEC1d689mv2//PAjbj4kYp/vhFeZLY/glsE3a2ZygsYvh0GZkV0wC2otpB54Z2S9Tl7l4hwS58n0AT4LKVD5970hKis1rtlxU/bc9cTYo3M9ha7R8bzH5ZkX1N20s0HEPbaDm/8FFeLpciMt5fmnSGc+6m4qr3xgAuRhifU9ieK3OXn4LNQ/SCDzGxdjHIdNtKAoNnXpw1egS6xmWBdaLDFchBU5SyJQoXuoF7tNpeTv2NoAiWY2nRP18uvTVbSX350qWIX/ZlwGMSPvvGKv2OWvZ3jhllABqlpgbrWpaDtjPqmwXvU7yhQCjdTU06x
 MBP4BjWJ
 lNjI8gRggsW/TboUe6NPNMCj5zlQHKtwFVKJCmlNV964etKQdJrAF42xJ6QvIPKW1hijlvPI29zQA2KTY8c6dXP8VG8J7Qxe4qHp9aLHEy8qCp3r7hTY7Sx4KWYjn1bNCdYNlTyrsNKVzpq4S26P6a2HpmY+ao7De2/UyIKUWMAPhsjJuMyKlNjt9jrJmL+qPEz550YTuf3bN5/sbqeNC5abna9fqbTE2WG8/NcqqelI2+ivsDlaH5gbRVq8TvHYhVW0CVn2lbKG034PFLHd9qTSqk5oKf4wdMATvYf4+YUrtQw0/1Qul1cY2gSq8UIdfZx8aEGqQxOe0Ur/RATFxEsBXbjp5+aatf1Le1Dtg34H1tpXfRD3MinocRKGuPq4SKbgZvC9Z9f4S25tL/WnUW6/8sjjqezWb7dtTPNMw/D2kDM8b2yGEIkrUCBjkBbyLPhHw86Wde45FE8h82heA7kABjzBl49l5zoS1RVaUQU5qulXEa3IOgwAZEy2CNVhvYA2OUuQjVve02fI87xaHmYHLgccdDEPzpoeCjT1usL6P0zfE8hKwaK6XWJauNhKd70161J9FkDp2Nn4HFEnpA9gTKp5Tr+lWbUrnKriA9FJUMdYHBjRqCrzlYf84EryPMczIbVOZPFxurEaZ566mH1uAVqgQrtdKUMWZLxejbbNBOLU8RBtloFcbYehDhwmbrDxQUM32tXkXXbXiRfSWrX0yjGeHvC5wm8XSLvuIVxPN1oUhKyt3UXWNzitYq3ACnWtKUeyImTsfc96AZ1Qvo2ueJdsoBCZFI33LliLlqMEQhXTV6XNerAlWW2qvVo5+U9aW7CaOzTyoJw/Ttd40otoosP/3E11XMFM4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We introduce the io_remap*() equivalents of remap_pfn_range_prepare() and
remap_pfn_range_complete() to allow for I/O remapping utilising
f_op->mmap_prepare and f_op->mmap_complete hooks.

We have to make some architecture-specific changes for those architectures
which define customised handlers.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 arch/csky/include/asm/pgtable.h     |  5 +++++
 arch/mips/alchemy/common/setup.c    | 28 +++++++++++++++++++++++++---
 arch/mips/include/asm/pgtable.h     | 10 ++++++++++
 arch/sparc/include/asm/pgtable_32.h | 29 +++++++++++++++++++++++++----
 arch/sparc/include/asm/pgtable_64.h | 29 +++++++++++++++++++++++++----
 include/linux/mm.h                  | 18 ++++++++++++++++++
 6 files changed, 108 insertions(+), 11 deletions(-)

diff --git a/arch/csky/include/asm/pgtable.h b/arch/csky/include/asm/pgtable.h
index 5a394be09c35..c83505839a06 100644
--- a/arch/csky/include/asm/pgtable.h
+++ b/arch/csky/include/asm/pgtable.h
@@ -266,4 +266,9 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot) \
 	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
+/* default io_remap_pfn_range_prepare can be used. */
+
+#define io_remap_pfn_range_complete(vma, addr, pfn, size, prot) \
+	remap_pfn_range_complete(vma, addr, pfn, size, prot)
+
 #endif /* __ASM_CSKY_PGTABLE_H */
diff --git a/arch/mips/alchemy/common/setup.c b/arch/mips/alchemy/common/setup.c
index a7a6d31a7a41..a4ab02776994 100644
--- a/arch/mips/alchemy/common/setup.c
+++ b/arch/mips/alchemy/common/setup.c
@@ -94,12 +94,34 @@ phys_addr_t fixup_bigphys_addr(phys_addr_t phys_addr, phys_addr_t size)
 	return phys_addr;
 }
 
-int io_remap_pfn_range(struct vm_area_struct *vma, unsigned long vaddr,
-		unsigned long pfn, unsigned long size, pgprot_t prot)
+static unsigned long calc_pfn(unsigned long pfn, unsigned long size)
 {
 	phys_addr_t phys_addr = fixup_bigphys_addr(pfn << PAGE_SHIFT, size);
 
-	return remap_pfn_range(vma, vaddr, phys_addr >> PAGE_SHIFT, size, prot);
+	return phys_addr >> PAGE_SHIFT;
+}
+
+int io_remap_pfn_range(struct vm_area_struct *vma, unsigned long vaddr,
+		unsigned long pfn, unsigned long size, pgprot_t prot)
+{
+	return remap_pfn_range(vma, vaddr, calc_pfn(pfn, size), size, prot);
 }
 EXPORT_SYMBOL(io_remap_pfn_range);
+
+void io_remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn,
+			       unsigned long size)
+{
+	remap_pfn_range_prepare(desc, calc_pfn(pfn, size));
+}
+EXPORT_SYMBOL(io_remap_pfn_range_prepare);
+
+int io_remap_pfn_range_complete(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long size,
+		pgprot_t prot)
+{
+	return remap_pfn_range_complete(vma, addr, calc_pfn(pfn, size),
+			size, prot);
+}
+EXPORT_SYMBOL(io_remap_pfn_range_complete);
+
 #endif /* CONFIG_MIPS_FIXUP_BIGPHYS_ADDR */
diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index ae73ecf4c41a..6a8964f55a31 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -607,6 +607,16 @@ phys_addr_t fixup_bigphys_addr(phys_addr_t addr, phys_addr_t size);
 int io_remap_pfn_range(struct vm_area_struct *vma, unsigned long vaddr,
 		unsigned long pfn, unsigned long size, pgprot_t prot);
 #define io_remap_pfn_range io_remap_pfn_range
+
+void io_remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn,
+		unsigned long size);
+#define io_remap_pfn_range_prepare io_remap_pfn_range_prepare
+
+int io_remap_pfn_range_complete(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long size,
+		pgprot_t prot);
+#define io_remap_pfn_range_complete io_remap_pfn_range_complete
+
 #else
 #define fixup_bigphys_addr(addr, size)	(addr)
 #endif /* CONFIG_MIPS_FIXUP_BIGPHYS_ADDR */
diff --git a/arch/sparc/include/asm/pgtable_32.h b/arch/sparc/include/asm/pgtable_32.h
index 7c199c003ffe..cfd764afc107 100644
--- a/arch/sparc/include/asm/pgtable_32.h
+++ b/arch/sparc/include/asm/pgtable_32.h
@@ -398,9 +398,7 @@ __get_iospace (unsigned long addr)
 int remap_pfn_range(struct vm_area_struct *, unsigned long, unsigned long,
 		    unsigned long, pgprot_t);
 
-static inline int io_remap_pfn_range(struct vm_area_struct *vma,
-				     unsigned long from, unsigned long pfn,
-				     unsigned long size, pgprot_t prot)
+static inline unsigned long calc_io_remap_pfn(unsigned long pfn)
 {
 	unsigned long long offset, space, phys_base;
 
@@ -408,10 +406,33 @@ static inline int io_remap_pfn_range(struct vm_area_struct *vma,
 	space = GET_IOSPACE(pfn);
 	phys_base = offset | (space << 32ULL);
 
-	return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT, size, prot);
+	return phys_base >> PAGE_SHIFT;
+}
+
+static inline int io_remap_pfn_range(struct vm_area_struct *vma,
+				     unsigned long from, unsigned long pfn,
+				     unsigned long size, pgprot_t prot)
+{
+	return remap_pfn_range(vma, from, calc_io_remap_pfn(pfn), size, prot);
 }
 #define io_remap_pfn_range io_remap_pfn_range
 
+static inline void io_remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn,
+		unsigned long size)
+{
+	remap_pfn_range_prepare(desc, calc_io_remap_pfn(pfn));
+}
+#define io_remap_pfn_range_prepare io_remap_pfn_range_prepare
+
+static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long size,
+		pgprot_t prot)
+{
+	return remap_pfn_range_complete(vma, addr, calc_io_remap_pfn(pfn),
+			size, prot);
+}
+#define io_remap_pfn_range_complete io_remap_pfn_range_complete
+
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
 ({									  \
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 669cd02469a1..b8000ce4b59f 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -1084,9 +1084,7 @@ static inline int arch_unmap_one(struct mm_struct *mm,
 	return 0;
 }
 
-static inline int io_remap_pfn_range(struct vm_area_struct *vma,
-				     unsigned long from, unsigned long pfn,
-				     unsigned long size, pgprot_t prot)
+static inline unsigned long calc_io_remap_pfn(unsigned long pfn)
 {
 	unsigned long offset = GET_PFN(pfn) << PAGE_SHIFT;
 	int space = GET_IOSPACE(pfn);
@@ -1094,10 +1092,33 @@ static inline int io_remap_pfn_range(struct vm_area_struct *vma,
 
 	phys_base = offset | (((unsigned long) space) << 32UL);
 
-	return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT, size, prot);
+	return phys_base >> PAGE_SHIFT;
+}
+
+static inline int io_remap_pfn_range(struct vm_area_struct *vma,
+				     unsigned long from, unsigned long pfn,
+				     unsigned long size, pgprot_t prot)
+{
+	return remap_pfn_range(vma, from, calc_io_remap_pfn(pfn), size, prot);
 }
 #define io_remap_pfn_range io_remap_pfn_range
 
+static inline void io_remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn,
+	unsigned long size)
+{
+	return remap_pfn_range_prepare(desc, calc_io_remap_pfn(pfn));
+}
+#define io_remap_pfn_range_prepare io_remap_pfn_range_prepare
+
+static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long size,
+		pgprot_t prot)
+{
+	return remap_pfn_range_complete(vma, addr, calc_io_remap_pfn(pfn),
+					size, prot);
+}
+#define io_remap_pfn_range_complete io_remap_pfn_range_complete
+
 static inline unsigned long __untagged_addr(unsigned long start)
 {
 	if (adi_capable()) {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0f59bf14cac3..d96840262498 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3673,6 +3673,24 @@ static inline int io_remap_pfn_range(struct vm_area_struct *vma,
 }
 #endif
 
+#ifndef io_remap_pfn_range_prepare
+static inline void io_remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn,
+	unsigned long size)
+{
+	return remap_pfn_range_prepare(desc, pfn);
+}
+#endif
+
+#ifndef io_remap_pfn_range_complete
+static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long size,
+		pgprot_t prot)
+{
+	return remap_pfn_range_complete(vma, addr, pfn, size,
+			pgprot_decrypted(prot));
+}
+#endif
+
 static inline vm_fault_t vmf_error(int err)
 {
 	if (err == -ENOMEM)
-- 
2.51.0


