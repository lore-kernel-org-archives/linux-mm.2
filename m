Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1BC8CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 12:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2688E0006; Mon, 20 Oct 2025 08:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA0E8E0005; Mon, 20 Oct 2025 08:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81B48E0006; Mon, 20 Oct 2025 08:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5AAA8E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:53:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C4BF138881
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:53:45 +0000 (UTC)
X-FDA: 84018484410.14.BD2E9B6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id F2AACA000C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:53:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Py3j2vxU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IbUY5SsQ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760964822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3SAoV39uqxu3MEyA5EAbP2MbUIb6W+irKIoDhXTp50=;
	b=XgDaSo1D+Sgfti0ISnKqdEBMgxj00jSlbfm0HCozokIM6ffiilhstmwmhDUDy7CCbq9F3C
	yxiYtu5OeWwKy6e2CQdjwuCE2DaBfv2urFxOGacDr9X45oQn4oiUNDz3+zaPMQGAopqE2+
	B2RcI+w234c67DJYAdvn+Ias39VSO2k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760964822; a=rsa-sha256;
	cv=pass;
	b=V9mJ8cluO6pafdEYzpk3tpiS0IrXu2tdcyZP1oTudhLKVJIp3COMSdU8SaapH2D3qmYgX8
	Ance/7ysNDx8F5Nx04aAV6Ec2f/QH30C5G9ADWMMkb8UoG8ih6Iu3129uUvXxYCjbOwFi1
	fCi5UIcyLEDgt0h+lf95GXeBIdyoJr4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Py3j2vxU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IbUY5SsQ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8Rooq000978;
	Mon, 20 Oct 2025 12:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=S3SAoV39uqxu3MEyA5
	EAbP2MbUIb6W+irKIoDhXTp50=; b=Py3j2vxUX2lLuFFqMiHNOQhxSDNKPipgOU
	uHX0Sr/oiA82E6iB6m48Xbrph+xT6k2rPq0vnInWk7P5Jie9ydOBFNQersnTF5Tj
	5NNqYhLCrHe+KP+eFM/RPmdj01eHmNpG79FctSFDbDK7jHb226KPhFWa7pDlbvMz
	sFsT92jNHrB6jyQq2zswPoYBDJM7G2oOLUAVWCJFV+USYKpf58HEYfg5rdQqV1qt
	1ohtDlTF5nRCBq79eQwrotUINUQOF5KxYW/evYLrF6JW5R9BF7ZEk8qSz+5HGtpZ
	zSUo6bs8MVCs5JPq0dPw39Z6Zd8Rqsxh06NizhuRaA0/9TuiM9pA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v30725md-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 12:53:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KA9d9l009376;
	Mon, 20 Oct 2025 12:53:29 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbwaet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 12:53:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eDEHFqx94SzmbeduT4xhrUngAm6xFGU+f/dQ4mb8s6sSyR23xjI7zn2W4NlXRLm0YrfHCVVlEGep9Yrfl2P2k5P4Bzg409w6u5QdNVSkVPpgpUecPsGfB4bG8VAXeWOadJaQmd0U3oR/fYqasbpSOCVj1gcag05c+9NhX4ITVGVUTtaflmqeEFC0GMgn/1DekCSQu/IGjOzmok8zCddm7SUAa7niDX4kjNj4c6RTYb2U6TDpg60S4WVxH+egyvLje3NHUOpjev9LYKyjvH5lG/rbjZng5uo9KkaELu5oK5UCSwgFgz+kdFqjQYpIZOjXXYyBmDOaBdqvdK1RX9Y0GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3SAoV39uqxu3MEyA5EAbP2MbUIb6W+irKIoDhXTp50=;
 b=VZpiJiS5mE/e/uEgxHVJ+deOprB39LYYHMsBwS3w6L6NdFG3WNUZJ6ZN10PR7YdlE3+HSfG6ixUrfAnp/f1WGTKJdB6uaARnxH/EAJqb/9QpXRtwML8wUCGlKnkw5ZK9lGrmXq8wA4hCoYtW25xbHWFKUvL7v6v4kLoMJggGOBSkpvK7p9TvwJIf4muOkw4sJmTHGYHvd3ulznb1uvCXvZksToUZ07/jrJO0NzesBrNKLlik3hA9JZ5aVU+EC6vMN+hM/7rCfFAcQzhnVHoLgb5/V6cKT2HRdcns3uQY2enYQKT4zwnc+rJXBOenIPZ6e6ViQDyzHjFpPf0h1npJ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3SAoV39uqxu3MEyA5EAbP2MbUIb6W+irKIoDhXTp50=;
 b=IbUY5SsQ6YJ/AvMZd703CiXViPy1TonTWHs9HqGxWcEdMxLMPL0LwDL6h/MTk6mzFHOZJrl1raQrP3R6ZXM7svopP02zpgmcHduYqTt9tVjOE+gqOLWUu2puolvI4wZTTxYc28Hva74d8/XtNp0xz4VWO7RDWvjtWWuqTo2SI20=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5863.namprd10.prod.outlook.com (2603:10b6:303:18e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 12:53:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 12:53:08 +0000
Date: Mon, 20 Oct 2025 13:53:03 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v4 2/4] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
Message-ID: <7d7855be-41e6-4e97-9a24-10ce3e9c5c7c@lucifer.local>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020061845.3347258-3-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: LO2P265CA0386.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5863:EE_
X-MS-Office365-Filtering-Correlation-Id: c40f8c5a-bd2b-4a14-014b-08de0fd79e26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kuC/cx909zdo/AeSLoIg9Ui/cnbx5qQj/REQoSwhsPKXhyREwkHkF9uIwQrA?=
 =?us-ascii?Q?yf/rcCVrBTxOu1reI345cz2x7GYyluXaDzV+rKnAJhWB1wJXsD5z51kN9mG1?=
 =?us-ascii?Q?nNZAVcGV/8IcV3nnjUiHVTBLd4qv5I7QRD4wHf1VeYhBC6QGGiLOmNj07cAP?=
 =?us-ascii?Q?CJHGI7hwV96uK7iMDE2++TJrysKLAcXGYx4Pk52j/axayExxs4hcehu+eo3o?=
 =?us-ascii?Q?8gMREM6sIeSwBv/3C1XLGQcBsKXx09NQOBJOdUCRZGuX9SNdtwVoSKJdwWMl?=
 =?us-ascii?Q?3cJvo0LRxFeSfEMIqhnj4o25Ls5jgwt5CxEktwTt57W5dMDj4bB9txI3wvT8?=
 =?us-ascii?Q?eErc/0DIsTw/lzlA1Z657GbhrBn+nZxUyGO8kdnRJwkfE2DzStywoHA+axmI?=
 =?us-ascii?Q?a16djZlmL0MjM2Z8F2BxEfe3xN1U4KDghRMOqBtRV21gshkT8pcX4uxyjlFm?=
 =?us-ascii?Q?vzzIjpcrCrOV7nrvFYz4XVnV8tydTVoAFeJbhr0dpGmE+2WhtnLScHcm2se6?=
 =?us-ascii?Q?9+egtTP9KGZGriZaRZdSth0mqvkkfIN3zoyUqvBOs9tj9KZO6Ytw2raFLvzx?=
 =?us-ascii?Q?QpK2IScB59cJzeKKKWEa7bHgZWlU8cqwUpUphxEiSL+BfOrIuosxHoeE4Xt+?=
 =?us-ascii?Q?cQNQCGHqRS7/dxbpSBUuaREdJ9N16VP6P5Sl/cDPoKNxgCmi5YEeQO/u4Tb6?=
 =?us-ascii?Q?U1yhXgNmbGnGbqk2fA+dmd0vaoDz+izeAdRxcIBhiEBbsce+QDNbB2nJMJwK?=
 =?us-ascii?Q?10as28yWOPB9/Qktgcw5bs2N0D/ax2GwVeLcgGc2x+dD3QGb0tyRBgIK5gmk?=
 =?us-ascii?Q?8OYo9IM5yI/rxSOlS1z4LvdXFva/HGtzxdJHNWns3xzhlgg2GTbfF6+PP3mE?=
 =?us-ascii?Q?o9sCPUUUvR2wJHL4JdElctIsois2WzvUPvlv4YaZTlauOHjphe+sq9d18jud?=
 =?us-ascii?Q?nAvsQIzvTZ6uPG2JHFrbjBYyL64GFxiZiazso8A4wFOcHG2mAwCCVE+/5Xgz?=
 =?us-ascii?Q?HbYEfXoHpG+TVDLPEy5N/dYSg/REiU/R5T6xvZ4oVmeiaMTyfIZ9Drp0NAZc?=
 =?us-ascii?Q?bbqQ6DrtYIoUGcrx8AlWyAzGXPIIdc9qOptFL6PXE+ykCoW2mYp8TFwU/9ia?=
 =?us-ascii?Q?R8vaq4HvnYLWYyKOPKfabsy9quxP4j385mkKhViZsaccbn+qvGRGOUncD6VB?=
 =?us-ascii?Q?kSpohkVJS2ONitv0r7bi1biTOXOgW3HBcMrYgM1jh4eWQizqvLDKuXzn73S1?=
 =?us-ascii?Q?lATsgdU2aJ0jrS4OAO88tqCIK0whnfulQM6k0/hGlM88+izWiOXyD8eu2uTm?=
 =?us-ascii?Q?PXDrJwGyiDq/iE7IIkGp4feMm8o2ZxO/i8sM3mCOWDqTZVyIULmy8bJKnFMM?=
 =?us-ascii?Q?D4MdFo2W8xc31Wmq0Sv+NKSOorPflYYS+4AyXe3SmtrPN7fsP01I/i3Nz6rn?=
 =?us-ascii?Q?8sVMsBawxoe7F/2pj8UF1rkDKcW0fW7s?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UNTqqT1rOtMbvDvoBbZb9OpEL+WkcpwTw/f47JvzmX4hFu0/xmEWKZNsbUo0?=
 =?us-ascii?Q?6jY3914p3OMhPnnZLDHZr1FOfwDk9lFWn+hs20ABMsGxk+05GZCwmx62arVK?=
 =?us-ascii?Q?S8NJp+eb5ediCU1ujpHACvryPxI7G/RbR2aif7nKUYo9/gelTCtmZ9/mnaWZ?=
 =?us-ascii?Q?m+rOk2h3vmbBb5jr3e4H12s+SVUiyrkan/gIYm6BiOY3G7zJqdchDNIsaFOJ?=
 =?us-ascii?Q?gURQsl+0ZoZZiwlrCwSRNVIgeJApmMbmR5hSjL8I/r8lBR65fsyapv/ZjKr6?=
 =?us-ascii?Q?47vozRW6X0vzR1AKa23BAUkAXFOA/7dIkoKqJ8KtyifOVhIg0hCeq313rjER?=
 =?us-ascii?Q?aro1O+FpDkjZmEmHlWpTFpLfTWj5hYl20K3HNuEXM4W/ECTHqGpqM/Lfppn9?=
 =?us-ascii?Q?FDl4JtsaqOIq50EXcQ+le+KEwaMQ/q4rqfqmVScvTuJ2yOSVvxtIgZ/2riKG?=
 =?us-ascii?Q?0ZiER2BFPh1KtauYhr8m2OmZBYo3Ae137vRg/4Jd3N9QtNxtzqIc+zT6Uoyq?=
 =?us-ascii?Q?xK+iULF2369gWFda2SFxnSCbKBNS/YLT+po4QMCKw42TbUDoGRcMahTF57lo?=
 =?us-ascii?Q?eh4lVa6+9JxFsw2vuAw3tk81AQ2ah5NRVRyNx1mKDwYpxmSXqtzJs9IwApz+?=
 =?us-ascii?Q?Nf+HycW2GzPCVLwWtlXen21owH7v3FxK7jxcZqJh4o9kIxcHsOBiIXHrHG99?=
 =?us-ascii?Q?kdUuq7jSrsL56mITVwuRVKY0ek4fVGZzlrNhbejoWPHpPOEaTduuYnCo6O7g?=
 =?us-ascii?Q?4mduWeRinF3LjursXxhNvRrSH6m2LMmQjrA2Jomt366UNpdIGsjI/nO4RLvz?=
 =?us-ascii?Q?1zcYE4OHh4hXWQKpngPp+pzXmLmWDriws6HxZxlEAUI05o4Z2mfF8y9IS4jm?=
 =?us-ascii?Q?3gPkdR5Fuk0nyu6s8Uc1bzQKZjhR+ty4WjptYZ+v9L4OLhkRUWZEZ2v1LTf8?=
 =?us-ascii?Q?qdVjEhmLam5o5dxbrvKuzpgthpbGDaQ68ZIj4ujxulqsm7If1TKV/P0vWe92?=
 =?us-ascii?Q?+iUVk3CmriOqgfmTF0ZFYCmlnvtk/EITsbL6THUzTNMqvs+DYAvvUK1HekjK?=
 =?us-ascii?Q?+D4M5ZFM3fkD37MO45XBAL/kJ9jevJqGBmpY5jSmIeLferfp2QAQ/s2VvB62?=
 =?us-ascii?Q?NbjpFZbTdVCgMpeDIs9YnmAcDTINJl9hK6aXNdHoSOnEcpUcuJIQX5KZA6wq?=
 =?us-ascii?Q?+O8rGl/KAcQR7jrGPB/KPbiE8dfQ7Bn7ozQi6dPJS9rNImHPkCxoHN8r+vil?=
 =?us-ascii?Q?ESvyBxmz08YPsQg6mTi7p8biQ2BrvTPXF5JhbR/gMT9AQvl/z94wcn96DCzX?=
 =?us-ascii?Q?3E9EhM4/VN16BGos/h6EvlQFUcpTjVMvs9+lDOElihbQmcpKNRvcq7cR3tiP?=
 =?us-ascii?Q?tkgdIQwLv/LzGBCaRvYPoWF1P422P3RaI9ZSffSSS/ZN+njXrTTTq/t4Y0Cd?=
 =?us-ascii?Q?5tD5MuRhznpGhMzOGFDRC/bzRJsWsgdHxXhN2Qy6xTUBHhqZGC0TCl4+eVNw?=
 =?us-ascii?Q?gJG6obbd1195qjLsJm5/SvLNpiSDTGc6eqNhtmlk8wI/pyOywWglBRoJzFFz?=
 =?us-ascii?Q?LDUQJZGiHrBaEN5HVvrvNSYmIAath2mu/BSJPX+yaYuLm2fYr3cjqSGaEYW5?=
 =?us-ascii?Q?fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7om0UwhFZqxGuRn5GsmkxYfg59bC1lwzK3aXgzpx+R4iJsQyuh7b1B65osD/XNpv/8jcve95zAhN7EpdFKWw9r0heT5SI3aYYmcpruEeSZQDgMtacAt5oKDeHj7wXlshuXGT29PElwzZfJklKcXu0cBycWHP6QbQ7105sOYXnH2qJ2juJLLXVAoPqlqtm8Yfhux2RtyxyTmPNj4RcquK+CHZFJTlfsnm3H+zJ1d071BiP0YdvGnu6e4S9FNgLHSrQgRJxMlIulB+4gc8Ax3Hav+jeH8ee84B5yGtki7ea+BT/n71DFWp6P57WCUZerS8NVWn/T4ItTt9M/ZPKUF5B7MgNBNQdoWaEsR35+4fDJuU6xoXf02BjE4WwJLCkKvH4uEK4vhzzH7Zge9y8eelnBqlxsYQUb/RNVDTEBKL6HZenNflvVtI7r36SdzTPXBCALIzAhHmtqmDZN/rxdjWsR3rIOv9X/TV9dDVdcAkah12nDwtkuRPY1Pa4+NKTaD0RJT2AzQhmd+oGem7P7ig9JTT8cqVriSEI7PgAhGOAqHP21kY9A3/S/md7gScpfPx9j9ZN34DA3mtlkdKmzYT8m34e7fYVhM5suD/++bxlUQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40f8c5a-bd2b-4a14-014b-08de0fd79e26
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 12:53:07.9522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q75l5VVhfaAkCeOx8tFRsJw+kFYK3m2184HSy6tYCetfDiDVV9HbC5ZXN0fqY+Ribn9CiCgVP8ltG+fDfcyXG1QJ+lapo6fICjjcc0mwr58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200106
X-Proofpoint-ORIG-GUID: fTz-krjiBNtOYwfgPQCYQqD7llvB4ZzH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX0Q6PW4kT9E1D
 seo1XnVBhYf1ItLB5I/sF2ff1eqRv9CZhQsXPh6OCcFCarff3yGRG4qvpCRTAMMeOAvlcfNsZD2
 n86mCeMXV8l83bOG0p8TastAQUduGyazu7M6mr3qyAGa7jFTOTH30RvbBLW4Y6oo4vh+RZ32f0n
 tkhsLFGvNeSAKpLsauc/rEh4uHnhO3VPIHW7f8C6SOUqfL4gzfcigYcNNlGhKa9vUdrH2JveJGK
 woskJztT5yrTsUUmh2IpgI2bJ4V3pRnsQP1ZxX7ORW8f3s51yrWdfDUA7f9pCgNnL7R6613Gl5d
 4x8ZQk95TpGlREP+G7rVmN2b6eC/LNGoQf0ztSvMGyU6J9rTMYZaoDo0CgVLu1Uqtwt8hvRr3xM
 Vw1rLCg5MCKDXndKg4Xb/bjugnYHYejNdGhSpvUkyugoRBFL4Io=
X-Proofpoint-GUID: fTz-krjiBNtOYwfgPQCYQqD7llvB4ZzH
X-Authority-Analysis: v=2.4 cv=csaWUl4i c=1 sm=1 tr=0 ts=68f630ca b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Ikd4Dj_1AAAA:8 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8
 a=XNSc-Gmhumj0JyTYMMcA:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf
 awl=host:12092
X-Rspam-User: 
X-Rspamd-Queue-Id: F2AACA000C
X-Rspamd-Server: rspam02
X-Stat-Signature: o6wx69tewjq9w8ocuhkc8ufcurmmqbbx
X-HE-Tag: 1760964821-349126
X-HE-Meta: U2FsdGVkX18S2iD01pUAe5cF6JxWq6I7ScN0Nnj1DuNaHc0SxMW9lTn++nWnxStJCreRhyESR84ZvlOcVC8q66fGtgk03locIzsUulFTKfGeqJXQnSNi7uujHaSyvJ0kHlGRRaxwSNxvab02r/5kabldtxmnFrYuJ5QqoDDwx8W9LH0DvEQj3JBWjbNbXZjyXg4HkDQdJ/CgIAEhY8vUk6i72jF82j1kzIPSL6soZIIT6ifcwyHBOmEqocsZ20AmGS9WQoeU70GrgGziFQXj2c8J7vhF78X5xU0FqQdRnLeqZvbi44V3ulx4YS/IC+C/qJk3WNRzUmxb4Ni/q2zzyqDG//CIe3lXJ0nFuoZzedsCuM5sSBq6QFKOx3q7hc4ppjgMxZ0d4cS+idpOjszgGO/OrDRRq+BoDyzRmpzxQDIEnOUNCrN7/wMYQcQ9SXwdg37F9sBIjEpEF2uAgWeI+Tc5aHROKM4UNRWVW6CoYKXKvfqggoS10m9qmutKhgozU7JFEuZocCIWm0V6dH7EBDCPX/qRgNmZKHm/voST08sa//GQubsEJlqjZbk9B+l8Gyuo2RceKyzOwGAPHtsCJTqIo+e0gZbmgEaAkmX15ASTNQrterHhKwiClu1DYdidrUtxa+vMVu4zfNadmx5G7Cy1qCpMtZdAxnDSWoeb2LSb5z4Lko8uchJ3PfXZoJRyz0J8/GKlzAOVnPSdqdznfQlSO+cQkWrs37wbY4vTbaJ5RVhx+iI2hNq9LI+xdx7W9DHm4azcNEqTWFjxri8HLCGYEoHAvMyhVtZoadAXh4fJV94IFAzHMzgtlCqFWu436hL4QUL3zQBbbEP7zYY5Nq28uKlA6VXlZYjvls0G658tVyIg8H7gLJPQzwHlj+yAEWxC4deKwoiyKjWb12R2vuYBOQ7jqUTkmWG6CBuYwTs8KW4dYc3JbjmU2GrsjgZeC3vzgeaVzmWt4jEDZWY
 n3Rg4I6p
 hPa83WCSNirjqC6auGW1IZCjTlsKELwT7Xn5vG6R3ua/RRX/U6OMC3FjHSb61h4QAG16WeI9KEhG99BFg3zBju2qgW2KJrF9u4KR8ZL7PM7+XMmoFpeWimAa/Bv+sRDZVp+ig1g3ZgrB5XaaR8CPkhohfa2eyqjgfMExwOtgVbE5hoz4NxE3sT5AaWnyhtGnarBN5IE4cLNZjKjH8LYaH0kU/aVBF1ce+hKsH0oQqT9mw5rrL/xt80sa60/8nTL++3QR+rwtY24iVwA8oPYTFdtKmesXXT7LkVGXQbAUW7zqRZZpGKVD2FJygp2x6g3cKn3JIlLachAfh/hXXGiN328F4t3rbo5P7nf+JQT1sKe0arqtfyq13wSZ80e46O//Va7fpJDaAoZ3pPtrDNVXWUTzyRu/BOSQAN/Dlrlkddn3LA0WmaCFT6f8EUyE9lLF3Ce0PbnheN6eYnYT1uwz5gzYkfTBWBNaw7SuMw6YCGHdVTQh16+66OBaxFtV7/xxYBCY8StcGHuZrAdGCqAhoDhxfCBt1F9XujLkXHQBWt/Zm0gqb3ktPxEChqCGHhh39JbEL4EFYnFWH0aFdSk/IXTlzLJ2wIoh81q6sxMZoMlKoqE9oZvxKq/+cuOqaQtlxIqBAO8aB7AkWjfPqprc6s9uVetf7q6hr4JXd6CFFDBE4wflXkNgqymZ09jMIejOYuhuxDe0Tiui3MaGweBDgMme1nEKzJwPI/X8U4zUYJzhFAiNVRpbhNue7fZyRKFmABf5V0AWG3YMMOQSHnqiWC7HkQ9kwvw1OA8Tz0WFCtJ3xCV0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 02:18:43PM +0800, Kefeng Wang wrote:
> If the pte_protnone() is true, we could avoid unnecessary struct page
> accessing and reduce cache footprint when scanning page tables for prot
> numa, there was a similar change before, see more commit a818f5363a0e
> ("autonuma: reduce cache footprint when scanning page tables").
>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Thanks for updating the commit message, this LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/mprotect.c | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 056986d9076a..6236d120c8e6 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,18 +118,13 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>  	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>  }
>
> -static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
> -			   pte_t oldpte, pte_t *pte, int target_node,
> -			   struct folio *folio)
> +static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
> +		struct folio *folio)
>  {
>  	bool ret = true;
>  	bool toptier;
>  	int nid;
>
> -	/* Avoid TLB flush if possible */
> -	if (pte_protnone(oldpte))
> -		goto skip;
> -
>  	if (!folio)
>  		goto skip;
>
> @@ -307,23 +302,25 @@ static long change_pte_range(struct mmu_gather *tlb,
>  			struct page *page;
>  			pte_t ptent;
>
> +			/* Already in the desired state. */
> +			if (prot_numa && pte_protnone(oldpte))
> +				continue;
> +
>  			page = vm_normal_page(vma, addr, oldpte);
>  			if (page)
>  				folio = page_folio(page);
> +
>  			/*
>  			 * Avoid trapping faults against the zero or KSM
>  			 * pages. See similar comment in change_huge_pmd.
>  			 */
> -			if (prot_numa) {
> -				int ret = prot_numa_skip(vma, addr, oldpte, pte,
> -							 target_node, folio);
> -				if (ret) {
> +			if (prot_numa &&
> +			    prot_numa_skip(vma, target_node, folio)) {
>
> -					/* determine batch to skip */
> -					nr_ptes = mprotect_folio_pte_batch(folio,
> -						  pte, oldpte, max_nr_ptes, /* flags = */ 0);
> -					continue;
> -				}
> +				/* determine batch to skip */
> +				nr_ptes = mprotect_folio_pte_batch(folio,
> +					  pte, oldpte, max_nr_ptes, /* flags = */ 0);
> +				continue;
>  			}
>
>  			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
> --
> 2.27.0
>
>

