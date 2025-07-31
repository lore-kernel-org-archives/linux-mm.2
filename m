Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2DC0C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 13:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361536B0092; Thu, 31 Jul 2025 09:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3387A6B0098; Thu, 31 Jul 2025 09:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2001B6B009A; Thu, 31 Jul 2025 09:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2326B0092
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:19:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A94571406D1
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:19:27 +0000 (UTC)
X-FDA: 83724616374.02.BC6A74E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1E48D4000D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:19:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GyRezrCL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CwR15ER0;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753967964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1nBxsFsN6FCBs/B9nOuehH5wuNqDHWqFE8vPYWmY7Mk=;
	b=S+61WH5VYE13PaqoxAjVuPQbXHw6s3fKHipwcsqTom3EoR23e1RwWW7ZTYQ4kwyrcWpHWW
	z7rTNQ+fiK2otug4F74D61xfeetP5npJxRmXUxoPXXTa+PGw/siv8SUUNRiftybn8kcPas
	uTMAXMysuRHplRfDxGFxSWcDsOWAHJ8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753967964; a=rsa-sha256;
	cv=pass;
	b=me+nlf6EBeZN4ODCxj+Mf+16Y16FY5qH8BRRyTLYIC3Yv/iTM0ZExL2y/HJNztxYAtTEX9
	uQsiywME8N7WfBxYjkdjjksnvDNYFJdMw0fK2gcyXbERRBo7GSxH4j98LJrB4klQtnGhLy
	bLMUUuUVhTU6nCimTWWMqnFiae7x/gc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GyRezrCL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CwR15ER0;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56VAskbc021994;
	Thu, 31 Jul 2025 13:19:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1nBxsFsN6FCBs/B9nO
	uehH5wuNqDHWqFE8vPYWmY7Mk=; b=GyRezrCL2o52xzzn6TJDU4kcdvT57w/zDn
	XSe9GxZSWPgG7UNAQ7yD8goUStt8ZxSYqQasciaH2CBiyo9cZf+NUm7/IhtlC8RY
	Ajn3w0VyYON/d8PIGmmKd+fpathWhoclR2YXRSAlcyM5/frVUhr97yW3GC2AkhC2
	wX8aGqBSEEdruPBtJ+o4hL52FLs5Qynj42EfPNCGBgfW7SVKsWuXLv49v2+GXvaC
	q7r1gkrNNOB8m2PFnhwvJJwjHRinTr/1DrfmydzkP0RAkB17ak7YEECJrHRM5JM2
	2Nq1ZE59xzEkk5eDPhPSbDZ/yrT2i4KjGLsIj8gCAjQSh25BxHyA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4ec7nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 13:19:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56VBf86q016740;
	Thu, 31 Jul 2025 13:19:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjtber-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 13:19:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DckqCcmYUnM5DGeQMnSKIsd+VNdNzOiQV3qS8GDJRqkQy6QuuORc9pk3o+pNf+vQ6oiM/K+VtP7iRJ62+NBf7QjuMgYBpZ8yOknnW3ePXUUvYwBPSA0oW+T7vNcuQQ8sjN4UDi6bBgkSl1Nd6xzcQGg7Q/4el07rg9p/Z3UgXBsSueaBXQEOIjXuH2VxQAmRVi2XvJ0PgndoWobLSQT4+9vdNutr76/AOfBEI+eDzHrws6fIngFwMWAo9X7SvRXcrCHxOGVOzBTWyDD3i1sgK4kJbzUTUXJuu/gG8KW5uai6JoBfK49HzgT3hDmrIBfdHA9YPi7vRM79ND5s9QtU9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1nBxsFsN6FCBs/B9nOuehH5wuNqDHWqFE8vPYWmY7Mk=;
 b=YLygBaa7y4otkg7BQ1LS4VRxqnmI9qbq+7mcPQgS9VVtHSs8HfU2OlQKLKr1qgeAy4cwibSWBYDguerFZP1m5wVcetq1L4L2Y5OBPlKlrZbTL9t9Hxs6sJEfIkTjfcARj3NH+DFTiJmTSvdwgZXrohc4Cv9pSybDaD8+HU4MoVOWX1AI35wqHa1vCuewtdqDFNf/WvDJlb9OSWsbpUyWuB4dkqrBUcTl9455P2nXm7prp60aEuquOfKE5fnneEMA3R41eV4xpMquYMJe2Pz5e+6Qomq3H2e6k0W0ZZQUceR6yyREOhoV/0Z34Io0XJjBYy59TuCBtWzBagCEu/RXYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1nBxsFsN6FCBs/B9nOuehH5wuNqDHWqFE8vPYWmY7Mk=;
 b=CwR15ER0F5IhNscnbPnMqlken+0xedwoXdWDz4XPioLNq90N1a8m1vqZab7OLWWfSgoGkAcj6hfJ18y0TNc/pUn/p2WH9wnVrvaQH1icy9FquPNpbQ62qqy0Hj5XVDrN+0zC9oYRgvssDPbfX6bCkS9GbVRkZN4D8udiF6RuZxI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH8PR10MB6646.namprd10.prod.outlook.com (2603:10b6:510:222::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Thu, 31 Jul
 2025 13:19:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.013; Thu, 31 Jul 2025
 13:19:04 +0000
Date: Thu, 31 Jul 2025 14:18:59 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, baohua@kernel.org, shakeel.butt@linux.dev,
        riel@surriel.com, ziy@nvidia.com, laoar.shao@gmail.com,
        dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
        jannh@google.com, Arnd Bergmann <arnd@arndb.de>, sj@kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-team@meta.com, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 1/5] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
Message-ID: <f1b0ee33-fa64-4802-a575-c843ec459b7b@lucifer.local>
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
 <20250731122825.2102184-2-usamaarif642@gmail.com>
 <dda2e42f-7c20-4530-93f9-d3a73bb1368b@lucifer.local>
 <c9896875-fb86-4b6c-8091-27c8152ba6d0@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9896875-fb86-4b6c-8091-27c8152ba6d0@gmail.com>
X-ClientProxiedBy: AM9P192CA0028.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::33) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH8PR10MB6646:EE_
X-MS-Office365-Filtering-Correlation-Id: ac53375c-0695-4258-a826-08ddd034d25b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GCaEhiGHE6N6T0BfuFKWzwV32mUbwNiFkgQuU0ENA6BoDK1YqXsfztAzcAX+?=
 =?us-ascii?Q?PadD9gRCX8EYmpYP6j/GWLCj2MEmwca+LJU80Z8n7cwIy+ZEqKQqm1qVPeYh?=
 =?us-ascii?Q?wFDV/QyB8/BvJE0ndQcu0mRcv03E2ZUq8zRT3BuZgIojeN2D7UZcCWi56d1x?=
 =?us-ascii?Q?GYueT5d/21DfCC5VuhFS+QWZcuooBg3sx9Qhkj5nITvBGWIHqwZ559dpgRRh?=
 =?us-ascii?Q?FqMSnpqz5XnMxWyF/anYffUMZimAni/0dUN+hmDEgtdr3o81A3lhAiBmfH7U?=
 =?us-ascii?Q?cON9npigmVQEvFMFXOpJ9heHsQ0XMGiiBWA630dUqya9sWimxVdDHQNKN9Pn?=
 =?us-ascii?Q?oe9bWnm9atET3Yij6Kx2Ecte6aDvw5lXlQV8ncqGjOcojfRjOuqVvcZ1owxT?=
 =?us-ascii?Q?ee4ghgefZElElnv83vlb+33KMTyQ4EMXUNJIrbJoCMeDIQSGEXfqN0HxoNzi?=
 =?us-ascii?Q?dXg2in5lpMndVwdXdqDgZ/2easuOGRTZ4Jq4E21TuSqPSbV7N6nmosBrExai?=
 =?us-ascii?Q?RpBfZJG344bQM6p7/izRLJMZ6hK+mbUhe3n8yk1ewSjlKt30rJC7NLBkFIhN?=
 =?us-ascii?Q?FOFj2cdD/IFKBOUXODTRhEp95YYvtlX0JPCsWKgBtYWa8wfkAc7fAKZAYAJu?=
 =?us-ascii?Q?noTFh/nWQYHOo1uXrnkELIEQtkFeD+iXySSs+3fFGRIjEJJiimLOitc/JpTY?=
 =?us-ascii?Q?HMc1eJUj8uwdCgvMl3RS+b1Jxsxxft8VhrnwROVTAv45plVSCNh1o0pPOA5I?=
 =?us-ascii?Q?3R1MBnzrXMd3Cb60kvPMWAriQ6sMOn4h1siOaqNAvAoozNT0fwa4/D7Gxwi2?=
 =?us-ascii?Q?kS2nljf2H60Bxzh7cz70A8CZGIB3OymH5KndLWKm/BikewL/p5SD32djrhU5?=
 =?us-ascii?Q?VXurTRdma4sw7LkfFkzzIvBHqWp8ui6CtZ7XeRVUKk0/IJlN5Z+lBANuGX2s?=
 =?us-ascii?Q?D5RhM7tLcjzSAzQ+k285dLne3g6VS0XSs06dSvItEGIIwEVEoIUV9XaEcD7O?=
 =?us-ascii?Q?GLfB03YRse1HtbUXLBKZMy7AUKUY3X7Vo6KygiHEE0H/pHtBRZauRWRZlfMT?=
 =?us-ascii?Q?3IdQjSwAS4R6hAmQeFuBhrRM0yZr8KHVzrV95efRr60QOb1WAk3WMZVtrr88?=
 =?us-ascii?Q?13gg/ikrf53yMc5AEqCV1oIuHl91etstA7OVK9WUcU51BjvIBg9FBEPwSWr+?=
 =?us-ascii?Q?9t7e73UQQksv5t/vk4eFSTiLP94vxHNNDlaA0Tu5n6KWM2wJHnOpV5m32qSK?=
 =?us-ascii?Q?0S2AhwvbuukwOFU1jEhpe/rDwBNySf3gAoTdpRTe8oykY+FcHP/QPTS8BfsW?=
 =?us-ascii?Q?LKDzxomHRvxeN5VBp8RZlgfJba8Q1vtlZBA5BNi6submP5JACE8LwI2c0Na1?=
 =?us-ascii?Q?voudlnQuhYBikmvwMvG5jNyQvyis5g5/Roy7ngpWAr6N9QNXG51eXjGWagkm?=
 =?us-ascii?Q?UvdIGrI3qyQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vRdnoxmypXG2HOyiAXm8e/W7wopwkCG9W28asfN+nnxG5oJZVnV5Iw3Y98k2?=
 =?us-ascii?Q?+dvV8QALQ96YhLHXfgrX7+uBGD36qobQqe9i9sytnL5skBYo0r6jnkmO2mcO?=
 =?us-ascii?Q?lyIDhgFefTp48nvv339AX4Vep7HiEa9WaBQlSyHbEyapnWQorOY10oi0CtNr?=
 =?us-ascii?Q?4HQALXaTKhlQmsTdrbTQ4hnDr9sA0gsgGq1UyNNZ3IEigeDieN6g8qN1z0f0?=
 =?us-ascii?Q?8DvBszOg5kJuploENJx5PjehTSwLOvw6YQnvV0GT1oMhpV0Du72Tebh4r+fI?=
 =?us-ascii?Q?6F0IS/26I5OScsQQm4H3d1BLSiOo2oNIDROcB4sDO2KxBA0oA/G1zm3Fr+x3?=
 =?us-ascii?Q?66ZB5df8fU0mZxYv15lb2Q5UXbVaVQfFnR44QgBtpQh96Cvw/L/mYnD1TEej?=
 =?us-ascii?Q?MWVHUoXZ9K0gP0bgfyLVEBg9CUqBWw0Uk2fIHHu1nH/4v82ahvR89FTSJ8Uj?=
 =?us-ascii?Q?lDHIq+T7uC4cAVgRpVtL4uxgBi5+JS6EO4wjFOLm67+wkUP1FQK6T/Ss11Jx?=
 =?us-ascii?Q?8/kf8l4yIi5KY7mCvO0/gmRpOFco5Bhl7hNx9/HodbfVmK39pB7+jFU9GMI1?=
 =?us-ascii?Q?AQ862wqm2JP5rHFQqzWKeqw4kPigtMscw2rLDAdQ78MQXg4BOp6wA1imEFPm?=
 =?us-ascii?Q?JlYHShZg5WHxtJ797uW5y4yOe2GBcSRHkHb8Q7NMZC3KEum6gV4mALnfJZxO?=
 =?us-ascii?Q?Kj9cFhfYnlOXUNvhwTQ5UoJi5d41gjgwKCl9Kw3ER1Zne+kSQjQ3zbr4i4Kl?=
 =?us-ascii?Q?qPDCQUZFrp9adLkzCuU0Xt62QQA/HRWZuPB+ny12GcrE7tnEoo/QsdXoa+26?=
 =?us-ascii?Q?wr7nL3U9Y56DYseyCK2svuKPdgL+G9dwd8n1AYoIY73EJ04mJqvigWpkFb/M?=
 =?us-ascii?Q?KPO1W4loWUAZGfBrIeaIKV3tp8cZvxS2nss2fnxMIoZSl9fxmg9WyztU9U+J?=
 =?us-ascii?Q?V4j1aNEd2K/L4shT/zNaxtj6U0EGug+QGdAU9hvgJXuPmUNh+PpJmAFM4Ryn?=
 =?us-ascii?Q?IXbyQKDFOm4e5TcoC9ITE6FTf8sUwDv8ibAd4tSIqUopv0SxRZfkmxYaLLGt?=
 =?us-ascii?Q?CKxafTKWR1Gmc3xSBMPVRCivvVsb7KZNkGKilOsHEzrQN5eHxMxNb3LunvXT?=
 =?us-ascii?Q?oW4kwRRet8NvmNjrdoT41WPHcvLWSICJNQhn/RS3BT1xNpEwD3JpTljZrJyP?=
 =?us-ascii?Q?IambstJSeAhLzBt2o0rvTPoJ7WnfB18AMsJkPWMcDXMbRsIstVT/rkWF/+74?=
 =?us-ascii?Q?B30IhTHNNaTMs/6ol3v5SVgKcuIhUTgf2Cjnmz11MdjsohzjjF/DS/s9TOiZ?=
 =?us-ascii?Q?dIfp6Wx0RRy5zARcoZfz1D+p5QZVCsxNW3jRzb50I72VCTmU37P+Y3xc95ki?=
 =?us-ascii?Q?i4RctNlL4l67dS7JAZxSFrS6JFWw1R6WLe3wbk2FNxX5BLq50jqQqDtwds+k?=
 =?us-ascii?Q?RRPRdDLh7tcalLwP0UgHMWG2JM64JMGrbA4EaluffNbBGlgFjqhPYqsWf4xc?=
 =?us-ascii?Q?/HoT+vsaX+4YWkd2dX4c4GVr6Na7DhPPETMLkF4zfaruWylrOIJrHqw/sfqY?=
 =?us-ascii?Q?k5U5JaKFizY20g657X/UHB05Te4/aPgAz9TwF0KnaMNEajf8aLdDI6Z6Drvn?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jXBUb9I0GomsJ5lGL7xBEZ77CgyW+GuVHpHVDt9tA1P8VP6aGiao+/KWqq+fJ1angIeTtyAkUjicSnGj+wqlqqAHepG0mnM7PZeKWmAHE9U0dByyK/096Mh/LT5fJuAE02eV9k0DgJeYSkxAYobjJKacL2CNGBx6WGJDzx1IRhRd3xNlh+WAq0lOewlCNt8BNwQLmB0xfZ+ebtSCoSvGhuhCWRGGkGEPwXvdErU3wqjcbFN372ilegkwekD/6uUNI/THV5xCl5GphNWVkoiR2GrpjkWwVMEP2egpbEjL4Bfeca6/EHdGS3oQDfOuio4Ha7dQ1/JHqsfoLkc0rILvUxSXA1qkF87wZ8ZMdf6hr3i86Kw1WrZ9n5RSaXsJjFqJhAQvCSVkRyuDC4rvagxJD0Nuw/f8X9Dg16E+jaR56T5Y64U8m/jkFRP6bNuuWyMEd+q+ZNwTxgmREFsoBQBQjpGqcgfpeNzBiDC8mIE/EWK3Bl9wvpw+edBsZKBMD0C0hVGB0wfFW01S+QTmmatwFtoLLDnLIAcU0rccoXMExplzEt9a2+/3x4mZHSFdjBpoVI3dbc/2uC0did2t/Zgn4BOfYI9pM+3o7E+77Bjs53Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac53375c-0695-4258-a826-08ddd034d25b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 13:19:04.3423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p5lgFJIp0PSaOrVZV3IYEpLD1RNk8fH9mG0zNaiFglrPjyT0AcDcKCE68c5oPyPK7l62lmTN3w7ClZuzXVrz5KOHJUpq3ZSV9fc4ttaK4GE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_02,2025-07-31_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=841 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310092
X-Proofpoint-ORIG-GUID: Vs2D5Woop29wf3ByAo8th1Htw1wB-gsN
X-Proofpoint-GUID: Vs2D5Woop29wf3ByAo8th1Htw1wB-gsN
X-Authority-Analysis: v=2.4 cv=QZtmvtbv c=1 sm=1 tr=0 ts=688b6d4c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=07d9gI8wAAAA:8
 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8 a=SRrdq9N9AAAA:8
 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=iox4zFpeAAAA:8 a=JfrnYn6hAAAA:8 a=gmp_2V53UkDn_K6tnJEA:9 a=CjuIK1q_8ugA:10
 a=e2CUPOnPG4QKp8I52DXD:22 a=HkZW87K1Qel5hWWM3VKY:22 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=WzC6qhA0u3u7Ye7llzcV:22 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDA5MiBTYWx0ZWRfXxGd4oAVQjWua
 7AKLOG0edP+2wfjasDXU12+AbhpOwRgPF8ZIf0j5Kt9ydI4GY6CKlKSUxuCuRW85cQYgMReIzCZ
 NmAUGHWRLPcFiZhccCNpbWdX8OvgFF/gbgaWt3jn6wFlKjGElIzcztj38r0Tu2DnhQjCSqZWq/S
 Cpk8AIJP4UfMg87n592ho/G19upJwqgWslJ9x/04ndu/TmtQzISucNa7a6hnNieh/AY94Eq3DEf
 XNH2ojE8ZZgXn9K92avjS+WTcDkstY70/jIW6uZr7knzHDBeS/snNJ/0iYcbe0OesWgl2WfbNHu
 6/sjXza2t7lxoJuEQPH8tKeKPcsYg4ZnYjtNxPr+bd9EgdS4ba41W6jWMUrHU0bxRikiOPAAI/E
 XX6fhn/42atJe1JfXIianTNw9Qh7a6iYAI72luHMmtZUS6HBBv9VleFq4HlEBp3welj9Qoaj
X-Rspamd-Queue-Id: 1E48D4000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ksejimp99mn5gj6imyizydwmwe6x3grd
X-HE-Tag: 1753967963-337246
X-HE-Meta: U2FsdGVkX1/BOdJbxnuD021SQsEKziGHCeq3zxYjr1wMCa5hXAJ9aME9UwVWM4IXyLDXR7LRYaY24PbU4/Os5NFRZxvmmJ2U/FQIJRbSraLAUrVCVixxhL5N+AxxcC3VXbNCZYeqakrLXozUikuhzgw9yZ51eG6NfTieUu/uePgvE77CbzPqYV1Uj+7wufo5+HcdK6bzqmkSkiUwsiF0ivrRuBYdJts4gG+xk/4zQaPiEseXTIvgaVZPOoxy5fuXfopff8uR2QaasvH4niRn90U0O3MEh4X+Wdtop4wJ6pAv2VBPVZIJ+stXU6pelbO13iMqPnbRmW+hsaASNX3S4fdPgSfo8Ig55uLff1hK5PoE9XXkiNkhL5zsoQt7+MldoMbniKe90ohmSjp283IfL/pljZuJjyZOgdZVxH/zZmtbR3EwGQmCqFZsJWif1AQlkI+pmX1dcVSNggvE4eQCHdAC6pm8J6ib0EmlhehtqIvel3YVlosYz/krVErYL+F+gS0Q+kDfo/79FCCDCGOiLqcl3PvuR2Sejx7RhhOvVu1kTHM7XijnlnWVP8w8VnVyS19UPruo/5AtVz03vmq9uhYgOvPKjiocKWKpFntNsnpxC7ogNbLGg/OKuj4g0hBVU5u041lWwUkPni5CuutS8Bv5SnzMwdpp1p7DmW7rs5LBWsXlu7vamyql1BVblexwUc1Y0JHoCnJaSaMOLmsheNEcY08DH+cmzdf0mbgJZ/ab/o0jVVFoCO7XVQu4AS05IMqik1wUkv2KyxNaau3u51Lunup5r3cUN+UMZ1QOCWGzeNqByEelLtAhqUCdw2TKIi/ZYVc+c6cWGpY+it6t5AUFW8iZoyFpVA0pwFPHHd7Y0isfl2t0mTIWTnUtJjZivUemlBk0DtRgJoNC/Xt8lBjUf2vxt3YG5ri2BcISxIs1QVf05+paRB23WSnnFmTSWeJsCNWmlbLdv4A5mpb
 YOyM5tB5
 0k1qbpk0eH5sSNVeBzH2KvFOnW1ZMYDXmTE41iWU0MKxRDvOVmAtT1DZ1/VbdpnwN8NrKMBTDvkK89et8ih15ryFXzZhFjDvrfAinCJ9hQ3ssA3ZS8g9HEvfucUd28OQMVB42xntG/LeGPLe2x0iIkyJ1+gIF2M8xv2ZWmN0El1hhybxImyOmzk/Jon4D6ESHggG313a4gAxtCRrOY879/2ZptjHL3RXDPLrTXu47IKoMhMXaSDVQ05jaZLHgdXh+XvBppcJceV2PL+6tSPHUGd4Q7Ok/CVlBqqCVIG1Cb1sxHDLaD5vfDs7kLu1MRsf8waSPqT/BPSxvr3+7TzE9je5gPc6ntvGMY507nFzXu15mF7MLE7psXb07sY3E1ZPY+a3hS7j2nHNuSHoyRTyK5TZY4uRxi57aCoVk0dIhAWu7TbnjSSUWrCgMSafTLhukuNdHAX72P59zCg+EZLM0jSq18WDdCSwgcfnnMHPeeElIob8J/Jcantf+FdsKEiBVeW0r+RfeUCE2r4L40DpyiEbcbhjgJFvo+RS+NR4+gh4CwePUYRjocqyxdLVr9SLNXO++PQhLcZ3+s5NkOyckR1mrkWFm0QovwU9hB0FW+46/0TXKjg9QtpzfofvDPzrwL85rsRYrN1rQn1RlzQjCyhSxGzHl8sZuG7bYr0HPcQeKIwYAcyvcIxvRHsfHTBKNXB6yJ+Ap8ne1/wzMy9vET5Rt/9yMK7HAm14LiHXpXvyVwY1e+hvGDkluHAjxSRZK3M9GRKfZeNYNSuQSH/v/OOJdngg5NMgz+OsLJEJxwpJPFWlAx8aKC1YtRWXcP64jP+KwKuucWsgB+XJ6HZJtCD1w+9dP4Hy291LLEBI3xGKOa3mKvF1DYHpZvaVpCMq/6gax7e3HRhTy9AoNl0rk6VQs9K3NyfYFjLnBRqWdaoKX+c4V7fJNtcnmNieMFfTnElxDnfsk/ln93YVreqZO4yHvPhcl
 RYxo6/KT
 072PbyINsGUy6VthZVczw+ocy4r8RSLQK2l99WT1s88Y6Y0t2AcG2Mo6RGLvUijKPpXSwkHGqdV4cEvlPy9P/aeno+9jOqml2wJ6ccpBIfxVj/UVZEg2eU1/mp8jz/wb7PqVxQFfk79kpw+x/OGmU/YriFW7I21Mai77dlQkGPllBudJKcL5buH1QzctNyATbdRk8ihruOH/iApG9Gi4frOb9Uq4SaOVkk+tgIDBDyGrg61Uc5RN8DEdTZl5R0NpdEtHFuZseJ2LhZRfNokIsemxGBdFHrtecSpGm+E+Iz6nEKsvN4irDuBsy9GzPG1v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 02:12:44PM +0100, Usama Arif wrote:
>
>
> On 31/07/2025 13:40, Lorenzo Stoakes wrote:
> > On Thu, Jul 31, 2025 at 01:27:18PM +0100, Usama Arif wrote:
> > [snip]
> >> Acked-by: Usama Arif <usamaarif642@gmail.com>
> >> Tested-by: Usama Arif <usamaarif642@gmail.com>
> >> Cc: Jonathan Corbet <corbet@lwn.net>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >> Cc: Zi Yan <ziy@nvidia.com>
> >> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> >> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> >> Cc: Nico Pache <npache@redhat.com>
> >> Cc: Ryan Roberts <ryan.roberts@arm.com>
> >> Cc: Dev Jain <dev.jain@arm.com>
> >> Cc: Barry Song <baohua@kernel.org>
> >> Cc: Vlastimil Babka <vbabka@suse.cz>
> >> Cc: Mike Rapoport <rppt@kernel.org>
> >> Cc: Suren Baghdasaryan <surenb@google.com>
> >> Cc: Michal Hocko <mhocko@suse.com>
> >> Cc: Usama Arif <usamaarif642@gmail.com>
> >> Cc: SeongJae Park <sj@kernel.org>
> >> Cc: Jann Horn <jannh@google.com>
> >> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> >> Cc: Yafang Shao <laoar.shao@gmail.com>
> >> Cc: Matthew Wilcox <willy@infradead.org>
> >
> > You don't need to include these Cc's, Andrew will add them for you.
> >
> >> Signed-off-by: David Hildenbrand <david@redhat.com>
> >> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > Shouldn't this also be signed off by you? 2/5 and 3/5 has S-o-b for both
> > David and yourself?
> >
> > This is inconsistent at the very least.
> >
>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>
> The Ccs were added by David, and I didn't want to remove them.

Let's not add this noise on respins please, it makes review harder. No
other patch in the series, including ones by David, do it.

>
> >>
> >> ---
> >>
> >
> > Nothing below the --- will be included in the patch, so we can drop the
> > below, it's just noise that people can find easily if needed.
> >
> >> At first, I thought of "why not simply relax PR_SET_THP_DISABLE", but I
> >> think there might be real use cases where we want to disable any THPs --
> >> in particular also around debugging THP-related problems, and
> >> "never" not meaning ... "never" anymore ever since we add MADV_COLLAPSE.
> >> PR_SET_THP_DISABLE will also block MADV_COLLAPSE, which can be very
> >> helpful for debugging purposes. Of course, I thought of having a
> >> system-wide config option to modify PR_SET_THP_DISABLE behavior, but
> >> I just don't like the semantics.
> >
> > [snip]
> >
> >>
> >> Signed-off-by: David Hildenbrand <david@redhat.com>
> >
> > This S-o-b is weird, it's in a comment essentially. Let's drop that too
> > please.
>
>
> Everything below --- was added by David I believe to provide further explanation that
> doesn't need to be included in the commit message, and I didn't want to remove it
> or his 2nd sign-off, as its discarded anyways. Its useful info that can just be
> ignored.

Yup I get that, you've posted this several times now, anybody who needs it can
find it. Please remove on future respins to save me having to page through
noise.

The S-o-b was actively confusing, and this whole block of noise hid the
fact you got the S-o-b wrong on this patch.

Thanks

