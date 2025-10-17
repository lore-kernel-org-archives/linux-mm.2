Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B11CCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 10:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B648E007A; Fri, 17 Oct 2025 06:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BBF8E0016; Fri, 17 Oct 2025 06:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC3E8E007A; Fri, 17 Oct 2025 06:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23F3E8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:08:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D662D59FE1
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:08:13 +0000 (UTC)
X-FDA: 84007180866.30.F07DB96
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6885D140013
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:08:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mt7eUnG4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zrac9P3W;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760695690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2Z+tBF82DkzDd2SywBxqW5/jqLjWxUm9gBCK56qn7k=;
	b=xmySoIBT3piInh8u3+m6sVDojZyyUgztId+KA4hYNh1mQ+b/ur6P453mg2/3GLUtyGzxvl
	XttvLie+hIjZLBG2EdU3dibB9KcFLj7RT+o3xSE/ADzKBng9ZUkx39JmgdZKh350SowwHm
	8kDkJPhWTEitl2kB5zThfvXAa2lJfjc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760695690; a=rsa-sha256;
	cv=pass;
	b=fJdx1z9AW1YANDJ7T1MwJCXCkoCPLjCzhtf5I5sROti8/v1fp61YTRg3k76NmvwrsBHHCe
	1mGTqoNvvj4+/jKVe4nbu2kVPXCBQIu2sJo/MNsA8upqxAGVnD/F6tLRfwkKMrYKrPwbKU
	1zKO8c1MuOtjPpg5ZA2ZQoqA3i30B88=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mt7eUnG4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zrac9P3W;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H7uNRD021006;
	Fri, 17 Oct 2025 10:08:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Q2Z+tBF82DkzDd2Syw
	BxqW5/jqLjWxUm9gBCK56qn7k=; b=mt7eUnG4pRoFkuCzXqjCqOotaja/TNrJe2
	VgR9hw8R44ZsqNYGlh6xw20JmM107FCdojUOlGKTztmukLTWCrHxdtKVrAxWFAUy
	VGWx1IJWJ4Ko2NAOGJI0I2tihpGp7FSE7rhG+44MwGnrJX7cXTeVKw8NI3KTxf/o
	TVD3Z9lBOls2px7sljP5BcI9crTLjFkkCskH6b2oAuFMG/6yJ3r4lU5itBaNNa5A
	GiQBNQhdR1+cGDvT01zhGzfJwsYCimU0TL8t5Ho+aYVwACRdjUbp6Q9+zf73yp0S
	XeF+BXD/bwEnkQkR/QDFPTq6OnEE+G+1iFLvYmnsKYyqb3+QeO5g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ra1qhr0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 10:08:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59H9Hgnf013722;
	Fri, 17 Oct 2025 10:07:59 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010029.outbound.protection.outlook.com [52.101.85.29])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpcmmej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 10:07:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UgpJAYqWtdPsIs0vcGndvT04Of9HhFvnKU+xTLeHrVNbHY+ubpbhFSvoqqcubnmuCFnpb6p74meUJO5eH6bj5DHO03JBbmFyu9k+6vBSnOQdC6k9i5bo6sn7fWFwUHG3KzcEeVMYOFOWegk2EM8NOJhIhf4ALIXrKbG1mHs+Uag+sbQZ3wgKI6evOXYmxb2jVte16QDyJ7xowCm0pWS1yqkXSpb3vIIY7BP3rUdYM0Ykh/CjSBcOA4xM2HBSsk1LPwCZxSrp6DSOm7lfDls5m/kPpEb4FAi6XYZygHSNAzHLAaLAL+tmTb26Q5zRtuYM0xZ2D19nWbYkfebkXGVyCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2Z+tBF82DkzDd2SywBxqW5/jqLjWxUm9gBCK56qn7k=;
 b=Vrx+HAza/+wfQa6DS3wUXIBPrfTmOdBVwOXs2Aa1MDZ1zN++hWXRp9K2U1d5hrE5+IUKbk1+RnDKNAfDusYjt5CvNmEAA4ZOJbISB6Chs7UewN06BWoTbrmS6Tlpq5wne86iDIYoYRnvhpZy0QhcRKZYDf00HllJ3hEkUEEizYS0SLBVZgU7LMe73Synr0TIGz4weqMPZ2oMd81cFSkuvy0x6oISr4xW7YnIM9c4Q/1I1yYJMybZ9yAQHLPovnM5Fq8hBjimolqyvNiyKCjFISPFf7HVfPP56x78687iQHy3KkImbG0cBTrTEe2njNrgffcEDUN6a4muCg8chNqk/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2Z+tBF82DkzDd2SywBxqW5/jqLjWxUm9gBCK56qn7k=;
 b=zrac9P3WoeU5khieCvswc8QcEYS1E2is0Ufc7RvD6Ek3Z12yOXwbYb8F4QO32/XUyd6mTxdDtiYIYbcsjNgl6RSc3bwSdvw+6ujZhtuGDq2FKaEJhtKiAcji+9aUE+87IBF0TqJTuVLcHSvq1O4OTItEl8PjrFNwDVf5Qfs7Vm4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB5966.namprd10.prod.outlook.com (2603:10b6:8:b2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Fri, 17 Oct
 2025 10:07:56 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 10:07:56 +0000
Date: Fri, 17 Oct 2025 11:07:53 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v3 3/3] mm: huge_memory: use folio_needs_prot_numa() for
 pmd folio
Message-ID: <edef569f-7956-4a66-ac1c-59743724731c@lucifer.local>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-4-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015123516.2703660-4-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: LO4P123CA0426.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB5966:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c081f28-83f2-42a4-6865-08de0d650adf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LdNAtqKgno+/TlajeMhavMXvZNnSoNRc4PfEACWuFqzxoRxiuixNaU8AIs23?=
 =?us-ascii?Q?V3ZVM9IqN2JX+12WO+Wta2Tz8qrBrMw/U4zm7/8fWb4o0mTMOVwRKAxxLN3d?=
 =?us-ascii?Q?a/JQ9EH9X/pg/4H70Sz2dqLKzfU+MZqSA7m3qvGWN9dKoJXKp8kRE26NDMzB?=
 =?us-ascii?Q?yp9GUpktW3aXKdhvJWPxzT9CevdrofpDNKKT9eM37mhxlJCE06Ev+9tkX2CE?=
 =?us-ascii?Q?Vxvgk6YP8mW7E1/zxKVingO7I14/kHHOVXLwS1Y/KI8OZfzGxo7dR2VoHDPu?=
 =?us-ascii?Q?KaJrb3lvgmDbqH2cPqoKDi28VvbfFYNcHV0fJgybEVjh9ZDmVV3xh8jK4i2v?=
 =?us-ascii?Q?lH4Klvx1o7bNVYIGMiWvxgz8kyTnIR3rLIpwnTuWNerd/dLQRx5Jy//pHUuL?=
 =?us-ascii?Q?X1QeICo5F4IfOD/NkgJclmj6XQkPuespBTxfKd4U+93SiNL0gLPJnJNV3o2l?=
 =?us-ascii?Q?vzZU0ABX9M6b7vK0PUHFeUfBagnUyzwxeIsb39vBdesgsWvMN3JEmRGr45HK?=
 =?us-ascii?Q?8HilIF3BpUTi2sPNrTQYl+aqxmaUtWvCtexxGBzunC+WS8hO9MQ2vCF/ltHk?=
 =?us-ascii?Q?hUxNOtGT6A/OKYHH5kRph78So3Xf0SBLRI2ZkMhEDJWp2FrM3nXt2MBQQzGR?=
 =?us-ascii?Q?t5UReSIWiTNbG0ziLE8K8YHMNV98mEp8KUard64V18jKS+IEFd1gkEHOVm8I?=
 =?us-ascii?Q?4OlxFp6ctM/+BwfcUCgP2+KqAUa1EXBurOE5+VAb0PCDekTD6SDvesUt5Cx/?=
 =?us-ascii?Q?gw6TEhEdkyTHhIY9USd5G+0L6V8Uxynxfc+soZJf7mnhev4orcZSU6Wlkm6Q?=
 =?us-ascii?Q?t7T8eodBg27khllcGGzE6A78Cfi/p0bkaOMoHWX3t2f9h3uMbKAabt9MQ+2L?=
 =?us-ascii?Q?t6gQCwyDlq24em9ifjf/f0xuIhpXG/mAnih0hrltxKgIjeC3lgRVygz4cg5y?=
 =?us-ascii?Q?CUQQbxr16AJZ8OI6Q0iMA+yac8FiJuVEqHDo61Zo3lvTQnKF0QMXBxyneYpD?=
 =?us-ascii?Q?0wviTKfJCeN5YyO59uPeDkT+V8yoY6Me2PIfwBnmiMmKfG8n2T1VvJO+zOdP?=
 =?us-ascii?Q?7xGvuyYFayW38O4C78j1ix/AJ8o8b728WfNLh6RFNuGzCbaHhbUy6c9yLo92?=
 =?us-ascii?Q?iNbLmA4JGZh05ejbNgu1nkh70NyCgwH6LFrDftMK1YQ9s2ZkBgqxdD3Bx1SA?=
 =?us-ascii?Q?W7nvxJItDNu8yozgyi/gn4PsUIsONE+0yGEk5Kvfb3rSXdMEp2Cvkv1k88xK?=
 =?us-ascii?Q?iB9M8LAP80ONNIsh/E4XTpzOyRuh7wanOWtrqA7hCYlCzNqjBB1apSQfVakA?=
 =?us-ascii?Q?finl15kcjyfhUdb6FdbHTk30go6f6AU1tNjvK/PSVnGibPLnrfMAXbnEoiUl?=
 =?us-ascii?Q?DJH4SumxdEWkcZJVkgnrJst6QC69vDowMANU9QSt7NNXe4KCoE+zxm1k7JpG?=
 =?us-ascii?Q?M8xnl53fAi25sQoo1jfvmu+bEja7VMG8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vrDmUjMz+YTOusH2T1P/cx8CsLZr5au3s5pZDC6G8oU9FPanJgzVxbrKg5GY?=
 =?us-ascii?Q?ERfPHyDWLf1hWp+XqqS3ZQbyYN8XS2OpJ98voG5kz9k/91mtmSqKMd98FHpt?=
 =?us-ascii?Q?GNr1nF4H5M/4nziul74SzCyrhGw2+cAGEAr9EC0re4ohZZ5lMmyPd3e/ow67?=
 =?us-ascii?Q?G4NQq/WYXEthUvr/SzEii5YWOa5YG63dpLhBYVdqX24H01DVxw7seizBBGbK?=
 =?us-ascii?Q?PFCgQ+LKiEwLGcY8bWccKJSt4wCKiaF6pJEB3kYS4OOfE9wzRh7V4wR/fs0E?=
 =?us-ascii?Q?3ODamnA4ZXGTJXKBVP+Gt3gRgvppYRn6lqEeFScRePGqawT/pe/NqNK0fPGg?=
 =?us-ascii?Q?PSqW4Etzi/C5CVZcTG4Ug4CGtDOqCCXplwcu8HnFhjw7SSuqkiRAJopjR8AJ?=
 =?us-ascii?Q?0tMhmVzmvGd0+WI4703uj/vAsOGaA/HVNaGkPJexdPpQ87zsPJMvVL27LyYM?=
 =?us-ascii?Q?EkVF28+Xlw8axuehXegbG/JlNIyH/kGS0eRYir9YDTCgy0cApqqAX3Mu584u?=
 =?us-ascii?Q?7f5HJGhTRjd1DyyTF5DnOTX4NlBbbKKf8mPopSJFzWmDuwBND5/4APngoAG2?=
 =?us-ascii?Q?pxVlq63T1Ey90OZh9vXAZ6Z6sZILQelLt9CxHBgiB/z8vABBF4ZBxBg6nAAv?=
 =?us-ascii?Q?Gar0i1MmBG3LpVQ3nXvhNTH5OMV1xumHa+5Gfpw4kKS0BiAevzr4J8ZQvy24?=
 =?us-ascii?Q?nN6p+2/n1gCsjViYEBl5vKcbapqUwxdq+Siwgmt2oJ3mdFJFdHPAwyengCfJ?=
 =?us-ascii?Q?XlcZqZo1STqgFoZ66nmY+Jk5PDQqM9IB4vQTj3DrC1i2PKz8djDfZNvOp6+f?=
 =?us-ascii?Q?478il39VgDLfedcnty/jrud8sJzXMLHOu3bVltz8wejJg2u9iMTLVgu4sfYp?=
 =?us-ascii?Q?NvbF0+uJBmnk0Z/H5tiT4Y7qTUZK6NxfzV7AsU+xMWNzfUzKsxWTW/RlSRx2?=
 =?us-ascii?Q?bQaOvNM09S4qucQy5NIdJkPq8ijwvTljU5Rli0a5AgTj7L9ve9zzlcBGFMGX?=
 =?us-ascii?Q?FvLUQiPNaogm4IgYUQOrEDQvKEfUQc5DyFcl41MkXs4q9T3esXb1yYOrugUe?=
 =?us-ascii?Q?8uoe4Sj7IjWkSHyfuWz9lowG1zcIQcW7T3v5xTfzf+YsJfPBoLG9AjTZ97ql?=
 =?us-ascii?Q?mo2V3iArJG/v6DyAiXT/PeupWFsr/DAcEUezbTWVf6+pF0Y7l/s3w5lvJRF6?=
 =?us-ascii?Q?3x/6xgdMAaj23cNv1iKczlfL/WjMAhY0nO9Frcrt9y0a5vkskVScIcncSVZr?=
 =?us-ascii?Q?0UG/yWsh/hEPisSkSeaCjGIOlDgMyYWUdwsTK/1u0kuI7rAg+JZq+/VR78GA?=
 =?us-ascii?Q?4I0EdWexb8CfrN87LOefWLajKPFAQCZBu2H34W54dY9tHo5zzjzeRvuebbc1?=
 =?us-ascii?Q?Ir++aA0r6UsiwptWy2PZ2Xa+bafNYOsImnj1gXYTV6MC1RpPW7p0Vd3yiePP?=
 =?us-ascii?Q?cHVqzZUS3v0qBt+Z2WKbsLYo2/HowTeIMycVOx6GXIgdBG1AxK5Yqbf5B+I3?=
 =?us-ascii?Q?PjF0pQuZtd9UqT1lZGaXyTuMLPuWgJy44WxjjuiWz31wP2pYuryGCL9hMewL?=
 =?us-ascii?Q?Jz3AFdrfh6CajeK9RhpxKSBo2jTRchVszgrdmVszriKU2iuxqX9saXjiJCxH?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VIL/K+GJVePtq/wNcTVA7CAPRxYZxguvpMty2gCseaMSR/xXlLoa+ws4RYFiIDzu9rpLJxepFkSO4UTdJA+aDeUO488Y9cIEVsw/wwDCo7I0gnKTSZnNhJnQYl/eFyhd5wyg1EYusfXUaiGr+cHhf9AjIDk7KN9l07tY+daqqtuASyUBLie//Jpo+mfkXCYqUuxe8XH+ngGfLAC6T1iSp01d5Hs0BFEN9eIDixtZNH1JeS5Da0jLpovzF+KooVjkPUqplyeFPlsuLRQNxJ62BVW1Ytr6uiHlZKb6x+BWnt2CbBg0UR4ASSsBXEMwqjuDaKE+fMfuOW14keDFqIF0M3F9KdEuZTYWJRe7TKsRQRASFLtyA8hteWuj0aFVTkvVQjoi8iQ/JgIKv7Ti8QlaBhfSUNW6LzAueba/+8/o68yEInVXfBF/sHGCa8fopdx76zI+sseCOC42QCemF7C0wVK5FYq3dz7cBIisN3KPuwxg1kTGEKNtBV9hfbRNaXsQCjx6QVlkg/ganuXPCsHa6sJQOerXMi+8rARcbncou0RULPO7pXmzrZUtMkP5/f1njtKuontjRH449+QVbo+3vn7qvuGMM06Xe0TFyyIyPYs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c081f28-83f2-42a4-6865-08de0d650adf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 10:07:55.9547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qo0OsOXeGxRDxhoiNVQea2IES03qaHRHdWuiNWs/TPWmkUgSp4Q5j+u2xIgMXuJxcJ78PulyVfX82n5qW5v0tJUtWR4xrqCQfZbgGeRuhGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5966
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=978 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170074
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA1MSBTYWx0ZWRfX77Xb7xDe3CL7
 5iObTOpnT4ABYLlI11AzDdqOsvMpxPshWOxiPngTJ9Dqwq8QuZDPVPqWdH22IL68nwoXSh7Pfn8
 hmTKoH4qtPwDB8zpSq0SG99wtcQ1EO6EimkHr/cvysaemLqJKim8wjM0nsMSahPTRy1UH2HiA/W
 xN1d6CdaEezeC7nsrgWXw4YXrL5U2oVJ1ZcKdD/VCOuBQON9YQ03UNGstK+QHaBpThOWUxKiWUH
 Tk2n5BbUryct/7Twg6fuCNE318fBIX/RbhFI43ElLcEuqeSxjPAdD9Q3MTOX85rDL4ty9ubSCtp
 g5ZvrU4RaAk2Lbwi2oAL1diZ84sUZ4NZbi9VjszYllEqIM0T/tDQ/X3yCEpQpYGAh18DisxQzIa
 +55el7g7V+GRobZyMDtQHV2y8x156XkB0WKNE0kthmg3gNwPgBk=
X-Proofpoint-GUID: 0AljrIhSKszUzMUcsMCm4MN_EqyPOB9n
X-Proofpoint-ORIG-GUID: 0AljrIhSKszUzMUcsMCm4MN_EqyPOB9n
X-Authority-Analysis: v=2.4 cv=GL0F0+NK c=1 sm=1 tr=0 ts=68f21580 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8 a=eeX5hHCYYCW0QIC2H_gA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13624
X-Rspamd-Server: rspam05
X-Stat-Signature: ku4wbcn45xw668up6podtzxhiz7yuor1
X-Rspam-User: 
X-Rspamd-Queue-Id: 6885D140013
X-HE-Tag: 1760695690-559308
X-HE-Meta: U2FsdGVkX184b21In24T3Pojg86RoUiMfhSvvnpuNvdC2mEf8qUm72n2LV3dug8cjkDc2vqg2nlfrXkRYdLPXfWRj5oKPYeFEQYQN14aFaZnpreuavdump9q8KMomcekUnjd9zi7iiqRwFnJv6GG6ZUmEl9oNA2OaXyLxq7I4VLQhUs0qHXM6zCRWxqz4paOlKDeM9wpio50sfYToRkM+XwZd5CxnTg1+/h0dWa9Ffw/6MJa55b3nvExChygIAjxvZiuMMdAQKQMYeaNYYkhhXxZ0MGDv0f/64COxPbm8LL7JNKTQaxkrqLzZHGwveZVngs4F4SihZ5jUCQtD3geJ2qvZbFfX9r3RXH7Zw/Dk/0fXgoL4jikzIR0H+R2AUZDCzXnnCjWhZxkeMAZX5pqqE5w6LtTDQZRjGvLsHNwOydYwYmlt485c0RZ+0yUx2i6yiSQp+S8AY3NukYtYINq8aH8vOW6OH/AqHExAECuQXTZnvT4AbRnTFP+qb8m99SVooh2Z94o+iG0eQcTHSyTlZK9rCtJb7bTkCIR4B0mh8s4btj8D8F3/f4qEZBM3iB47gA5N0Vf0iPIorTfjVa09rrzckR7ZIat1WIQJ1jV7It3j2H0GN6HHdDF27Cah5SrEpE1LKDK4D8rHRZjI51qCTXb8/p+SKoFya/VzoiwLoAJjhye8mgZjruzzjn3hQmYefwkbz055FxSSEpp8CyYDAvaa2TJFdJEaDAiOor9xjqvmaCZUqH6iJnO23bp5W7OrbaySTyiQFFguzBTKBU/il0f3boxxSAQyzAlB4xOvXKli+TDdzwdHbohAmBHVd2q7gedEDDIQWgjS0WapIltU9NKw8np9m5Zhd4PDluz6BKEejgEJnCu/txNPFZuaglt62B7p0g1LkqnxkIf9hEWHk1xdJJQgzIvDFB10hezh5H0+59nbjdarKckg+zhZ6gUpAfX11YrezRFflspK1V
 NkxAGaz3
 thh1h0M4cAYn0JAMnkid5qg/UBncnwgDHLiRxvPr52pRgYEUjfvurXRGJHTtz89ukfcbqHq3o95LtdDd8oOxWPL0GEbZ5Q4x2CAs56Gg44dGvrIb0BX2vsL93hGQHwggB64/XGhQP8Pcerj6qCUSaoylZ2QeyjOcCS9K0KRlTNph/sWBr2YxWdFONOzAElRVICNKkp09CEJQHp1wkcTvGgTEL1lVcsTlwa2w1aD9bbx3mP6e20UqD18eAA1MgPWpoH8T5nWiODffNo4aouYUpB/L7OEUgdv5tmsQxebilYxPt/dgUSlpHLArsADEahF/LEqxTilluhC3yEDSEWuLjLCFldu9OptQIOuSDgJZiqILQpOqFupZd8dfW3q+TT3+ypu1ugf2+DEw8jG0nSIaHwgi6Ql7RpyNEjUqCd+gHTm4lVZdRs7QYxCpwPuy25QbkEXBpsgsFszvtGpA3IrqCPJ40jATbXr3PusE7eBcUe7s21p2I3mGqkKKTm3bzBJokn5GWTPlsh41FES7onPmu3iovlG17/SOcLL6G67npDSO91K3bR5Opvo7pQsTomtSjf7twslMgZVtQW6/A1MCjV8tGlqojGef4C5+IEDcHzusoLYJxNS6791DAsHG1f3MDrZ4dl6sO4cqFppLKw3r+QKWQG6AWa8CzO22xCfVRNLlowFRbMOtY0s5ECM0XXX5NLssJxQgma6Ycg5teIAb1CwpArw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 08:35:16PM +0800, Kefeng Wang wrote:
> Rename prot_numa_skip() to folio_needs_prot_numa(), and remove
> ret by directly return value instead of goto style.
>
> The folio checks for prot numa should be suitable for pmd folio
> too, which helps to avoid unnecessary pmd change and folio
> migration attempts.
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Yeah you're doing too much at once here.

You seem to be combining refactoring with changing actual functionality which is
just not helpful, could you split this into two patches please?

Otherwise on bisect if you break the PMD stuff we'll end up reverting the
refactoring too.

Plus it makes review harder.

Thanks!

> ---
>  mm/huge_memory.c | 21 +++++++--------------
>  mm/internal.h    |  2 ++
>  mm/mprotect.c    | 45 +++++++++++++++++++++++----------------------
>  3 files changed, 32 insertions(+), 36 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1d1b74950332..c7364dcb96c1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2395,8 +2395,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  #endif
>
>  	if (prot_numa) {
> -		struct folio *folio;
> -		bool toptier;
> +		int target_node = NUMA_NO_NODE;
>  		/*
>  		 * Avoid trapping faults against the zero page. The read-only
>  		 * data is likely to be read-cached on the local CPU and
> @@ -2408,19 +2407,13 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		if (pmd_protnone(*pmd))
>  			goto unlock;
>
> -		folio = pmd_folio(*pmd);
> -		toptier = node_is_toptier(folio_nid(folio));
> -		/*
> -		 * Skip scanning top tier node if normal numa
> -		 * balancing is disabled
> -		 */
> -		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
> -		    toptier)
> -			goto unlock;
> +		/* Get target node for single threaded private VMAs */
> +		if (!(vma->vm_flags & VM_SHARED) &&
> +		    atomic_read(&vma->vm_mm->mm_users) == 1)
> +			target_node = numa_node_id();
>
> -		if (folio_use_access_time(folio))
> -			folio_xchg_access_time(folio,
> -					       jiffies_to_msecs(jiffies));
> +		if (!folio_needs_prot_numa(pmd_folio(*pmd), vma, target_node))
> +			goto unlock;
>  	}
>  	/*
>  	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..5f63d5c049b1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1378,6 +1378,8 @@ void vunmap_range_noflush(unsigned long start, unsigned long end);
>
>  void __vunmap_range_noflush(unsigned long start, unsigned long end);
>
> +bool folio_needs_prot_numa(struct folio *folio, struct vm_area_struct *vma,
> +		int target_node);
>  int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
>  		      unsigned long addr, int *flags, bool writable,
>  		      int *last_cpupid);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index ed44aadb7aaa..0ae8f4a277b2 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,26 +118,30 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>  	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>  }
>
> -static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
> -		struct folio *folio)
> +/**
> + * folio_needs_prot_numa() - Whether the folio needs prot numa
> + * @folio: The folio.
> + * @vma: The VMA mapping.
> + * @target_node: The numa node being accessed.
> + *
> + * Return: Returns true if folio needs prot numa and the access time of
> + *	   folio is adjusted. Returns false otherwise.
> + */
> +bool folio_needs_prot_numa(struct folio *folio, struct vm_area_struct *vma,
> +		int target_node)
>  {
> -	bool ret = true;
> -	bool toptier;
>  	int nid;
>
> -	if (!folio)
> -		goto skip;
> -
> -	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
> -		goto skip;
> +	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
> +		return false;
>
>  	/* Also skip shared copy-on-write folios */
>  	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
> -		goto skip;
> +		return false;
>
>  	/* Folios are pinned and can't be migrated */
>  	if (folio_maybe_dma_pinned(folio))
> -		goto skip;
> +		return false;
>
>  	/*
>  	 * While migration can move some dirty pages,
> @@ -145,7 +149,7 @@ static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
>  	 * context.
>  	 */
>  	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
> -		goto skip;
> +		return false;
>
>  	/*
>  	 * Don't mess with PTEs if page is already on the node
> @@ -153,23 +157,20 @@ static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
>  	 */
>  	nid = folio_nid(folio);
>  	if (target_node == nid)
> -		goto skip;
> -
> -	toptier = node_is_toptier(nid);
> +		return false;
>
>  	/*
>  	 * Skip scanning top tier node if normal numa
>  	 * balancing is disabled
>  	 */
> -	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
> -		goto skip;
> +	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
> +	    node_is_toptier(nid))
> +		return false;
>
> -	ret = false;
>  	if (folio_use_access_time(folio))
>  		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
>
> -skip:
> -	return ret;
> +	return true;
>  }
>
>  /* Set nr_ptes number of ptes, starting from idx */
> @@ -314,8 +315,8 @@ static long change_pte_range(struct mmu_gather *tlb,
>  			 * Avoid trapping faults against the zero or KSM
>  			 * pages. See similar comment in change_huge_pmd.
>  			 */
> -			if (prot_numa && prot_numa_skip(vma, target_node,
> -							folio)) {
> +			if (prot_numa && !folio_needs_prot_numa(folio, vma,
> +								target_node)) {
>  				/* determine batch to skip */
>  				nr_ptes = mprotect_folio_pte_batch(folio,
>  					  pte, oldpte, max_nr_ptes, /* flags = */ 0);
> --
> 2.27.0
>
>

