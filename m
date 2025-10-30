Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68513CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 08:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98308E0136; Thu, 30 Oct 2025 04:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F238E0112; Thu, 30 Oct 2025 04:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B36CB8E0136; Thu, 30 Oct 2025 04:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9458A8E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:34:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F7DE49DFE
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:34:06 +0000 (UTC)
X-FDA: 84054118092.14.BC37DF0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id C3F7520007
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:34:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bXVMBkDm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cvQlmqj0;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761813243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6mGMeWxCKzMyTyZkIQ8IRl2aYIN2SyIba6dBMlskJJc=;
	b=BC9b17OxdheGTBkhb5M294MPR8NXra0KAqLIaZyW05CcAJBXSIzmsxWcCGV/Obq/wI5LqG
	kYjOjk3YJXQXi5xhaMTSQJdBD3X2kMm7uIXBsgoS4glrtcbxPbNd5CkbHjo09ysjUwt4oh
	WaMYR4xiqJZluwpo4ZQzCt7/FHVtEnQ=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bXVMBkDm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cvQlmqj0;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761813243; a=rsa-sha256;
	cv=pass;
	b=RdFfy/6rlU1cO2/77jAzIqYQvxfA82PBm2OPBghMdRlf/98kEkh4cZkZ1VrOcbGxyk0/jo
	W5TJbTVUBDgZaIlXYJNEWovzrNCvtJ60x9g0lsgCX2SlruIqM8iq5XeGorCDlTYJrwoqih
	LilBlqzFUyBGKp4T2K6T0tZcdk3JNz0=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U8TxiJ003133;
	Thu, 30 Oct 2025 08:33:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6mGMeWxCKzMyTyZkIQ
	8IRl2aYIN2SyIba6dBMlskJJc=; b=bXVMBkDmPU4BZqvxvPUhCSrndZG06qPAKj
	Y0wBYFiyPZ3QgD1ijWC4hp9Kyy4iI65TSb7UYUPvxctFo8zFAi9eZo4do90lY7Gm
	9OVvAvgeLwV7OmHHLgjaMHX+mgRFTiXwKsvty95TNRlz9FofboW213+MGGGDIYwt
	xQTbKedndUwbe2k0bZdtJDcU5LDCPqeCpRo4E4qLXSB0IeyWjHwAiyOk0SawhFdF
	KOSLPf4Mv+zxMto//8iMy0Vk+bYrwYTC2W0DrKG+5MgeCv7G87MZQ+2By9uKIaES
	p5ydjELjUN8DJ3MUrN0kAzpCB54ooVkJKekTxT+ILmNdXVHgLUMQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a44j6g081-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 08:33:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U6n6vp023002;
	Thu, 30 Oct 2025 08:33:33 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012011.outbound.protection.outlook.com [40.93.195.11])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33y0ax3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 08:33:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h1dOsk1Fm1FnkAaCwPt5JbMhcAuASSQ8rE50ntFXpViI4mz3AU9uWHNSuXu/NvTDBRhnjSEMOU3tx1McZj79GbBwaUmUzz7bTCVs2G+gGZgpFD152Y1U7kXQ5YZD8t+DIdyAeCcasVqXbpjCzFh5bwmZ41eW5KYRPK11NCbGBDK7P3ITk+q9t7d1SsaB16gpFgxB9pFEiRU/LasvNgxBrIweffKEddIFpuHRjFOkFV9bSzNJtGJ27wicCddu5wQ2iioqE1tyFV+BoZbSe5ZrlALnnpQsWb9u3RNId87NdYDbZWqDWELVXQzxO7vp/38/BswjxxlEULtBK7tZ2NuMEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6mGMeWxCKzMyTyZkIQ8IRl2aYIN2SyIba6dBMlskJJc=;
 b=AzuvHM3GsJW3HsldZceZdie7vfZ9IaOerANyBEMlgRURiFMbxoDeAqJ0AOy8w+uEi33BbCz3Wiya655BXpsMTIIg5ckrQaRZ5E7+Knq09NRDzNomPaPoOssVnOmaUILpjzWyl0EbeFrE9jXXauIsKjdEx0mFCKvbBBNryccDOkRG3+KOHjgCVcz6WbxYsOqRG+xBEYNg+GN99wRuopMQMpNVjL2ZnrKsbTlptRnPiZcmAJH0HpGy7MiDWR4dEwv5Fhxrmp+oN5RO2L63d9LBjex6hMIUUZwCX4wIB9pBSYUBes3s7CjjfMSQtpUgiX0Di8kTQ7PuFo9vedzP4NLuAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mGMeWxCKzMyTyZkIQ8IRl2aYIN2SyIba6dBMlskJJc=;
 b=cvQlmqj0uE3CyhbycrIfGD9C6k4aub/25Dmrl0meNIEzq1pm8ChcKK+bCeullHUGp9Qlhw9mg+71tTdN0BkqVJZT7NAXp1aVaf7+wES4/PMucj4jwj/5Bb0201EWDPb1s0VlKoRXNBh9T0eE6O6EQ+x9HrrE+8MuaD00I8sHXxE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB7104.namprd10.prod.outlook.com (2603:10b6:806:343::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 30 Oct
 2025 08:33:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Thu, 30 Oct 2025
 08:33:12 +0000
Date: Thu, 30 Oct 2025 08:33:10 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Pedro Falcato <pfalcato@suse.de>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH 0/4] initial work on making VMA flags a bitmap
Message-ID: <4e6d3f7b-551f-4cbf-8c00-2b9bb1f54d68@lucifer.local>
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
 <CAA1CXcCiS37Kw78pam3=htBX5FvtbFOWvYNA0nPWLyE93HPtwA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA1CXcCiS37Kw78pam3=htBX5FvtbFOWvYNA0nPWLyE93HPtwA@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0506.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB7104:EE_
X-MS-Office365-Filtering-Correlation-Id: 647eac9a-2dbf-4d13-08a0-08de178ef66d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SUlNgfg+iwvo7kKhteYg0y2CdKXgZUTzrEqMKDb18rm1xwmjGS3WQwGbVLxs?=
 =?us-ascii?Q?G2TP/tzxuPxClHQq+RH9YzSw9pieM7cYknXDYcTJGoQjO4RX4WxPp+spNfAu?=
 =?us-ascii?Q?zPybER9y+QAKgu5C211lZVo5gr1lpGxZsdnjCYaEkKLRvljyAJt7Ce+vZd0r?=
 =?us-ascii?Q?s+BZV7wDI0ItrPuIKqzTWAkM0ovHAtSc/VqrbQT0ndLnTT1OxaT/Ku4ep5ln?=
 =?us-ascii?Q?ikLbfa/kEBnG2vrC0/gSCVeq66n2QJpKnFUq2XCkc1Mox5WVuDmqfuTcSE4Z?=
 =?us-ascii?Q?mYg2nAWi57X715cU3ndlpcbCAB0zkvTxorBQQganEwBarpooft085BPXgwYu?=
 =?us-ascii?Q?To3AsS6PC9W0Ha0k+fiXE8+jVzLcVcDJ+RIDcgI5JLWkscO+lZ3LGPvQJxyF?=
 =?us-ascii?Q?y7+7hNIfZ1fN/gr6DXSnv8EMbPs602srbehJwH4fiwylHJdmJCusq4cF0kEC?=
 =?us-ascii?Q?WzD+bcw0tdbv1gla2PP3NBDrMCCv+xq3rCes5jDvjhRLn90O1hdL5v/id1uM?=
 =?us-ascii?Q?gFDFaP6Ax5qGfObZEIUfr0k86LHOO8458iStm0oihjzuK99B8/xf+fZfVe6O?=
 =?us-ascii?Q?+CdMuTXpruXM0oiJ4bSybKrsMWaAzlSQJDTGlMKkT5vIEnmLgcbpprbUSvhB?=
 =?us-ascii?Q?lBo0sM4+CGfi9oSzjluXVTYVYfDCPfNqIZM99J4a26CaUvXhQ+MdgE814ERu?=
 =?us-ascii?Q?JycEwjSZMoqm12u84GB1UUDsWQbl1kykJxzgd48TsYGg0AuDJSfglDieA8fi?=
 =?us-ascii?Q?Cb24XxMDF2SpMbQXJPZJAxtXPdMtcopJt5l/w7CrcPEotjI7j1lYH+KoNqkG?=
 =?us-ascii?Q?9UXLPS5gdh1AvGCkcopSh6my+q4752p1ER3ODHZYXz8uO7Hfq3NyARUP3LHr?=
 =?us-ascii?Q?9jHZKgpL3K2DbvOdNnrKkACaDYhlwhfiynezp9yNYPa09RhqET40p+ZzLXpS?=
 =?us-ascii?Q?kS1KCo7pWxVNyuEJmhKhP5t6WKuAdwTVKbq4Jv2LAc8M0JuYEgJKbxjkXSF5?=
 =?us-ascii?Q?AASeev+J7yp7HoSOFv6D9ZfQS2u6VbTYlUTkxD4cU2nSU3lq5mhiNIdiOqNv?=
 =?us-ascii?Q?O0iCEHG/ChG7DhxlcBwSAvRi9fQVw5z+daMMakGl5r71pq7WwkUxXXV7c0RY?=
 =?us-ascii?Q?GdIuYds08CzfYaMMeRa5L0LYrp8Gc2HWEIFHI1x80wyVvEA0wbGc97br5NT4?=
 =?us-ascii?Q?6Z6S2FCQdwmesDJahVIp49daIQIwZMqCpSHTrj0h0YQOX1RTw+Dz1Nnb5L/x?=
 =?us-ascii?Q?7EBYc7E9NgGpGwvH/WB/CMR/C58tSp1gLMiCWAuDlxPWP7DmE5FrfVPBDdkE?=
 =?us-ascii?Q?NlwS5DXuRfTW800WRiktw0+IIDpE6kZKpj2lSP8MPqYcqnficUcpz7P+gfhz?=
 =?us-ascii?Q?8lYPSPwJWBnoyMlvP52+Ci9ZJfqDuxOvYBM7mIkWJg7krb+Uy0bh3ZLr1oqv?=
 =?us-ascii?Q?hRrLuQQHNhs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TaC/xrXD+8OJEPfbwBm0IHFYz4EkAZ3sG741vh8wTm+19lx/uCAqlxpfRAJ5?=
 =?us-ascii?Q?8UJ45njUjN1FFBI0c9GeMsB5Meu5+WRapqRL33RUocpxftivnfotZ6sN7m+b?=
 =?us-ascii?Q?dBriL7S7hnRo/wRZkpZi79hTyttaPb3trzZ2weU+ztQeDn5wIseOxBlPPC4A?=
 =?us-ascii?Q?PTds9bdmm3dyGyynPJOeuVmtsAVGlRx80ZxtMm3fuqjcfyKreSs2Tn3d5lmn?=
 =?us-ascii?Q?dURVjkMvJJCPZ0+6zxL6GbOwjoyGsPFTApeOSZpFrPZstpJSPQ0ZbEMKxjWc?=
 =?us-ascii?Q?4w81iqO1UpVz7SQftRZgviZCg0gf28mlRRIoQKdyWKgxJdHWb1RJ46jtclxF?=
 =?us-ascii?Q?DRuROMa6wUr4PP2VN7fAxz3M2qsdFKBZhswaM4+VDBKyUJNqJX5hozkOPEzD?=
 =?us-ascii?Q?/JIzvJtBn9PYTP9hnL63yrUzLUDp6mTYGwRoruwwLwTYbRupR282HLLJU517?=
 =?us-ascii?Q?QsdlyVIEVN5OIGDFhX8AcEq+kTOLqHhm6uLV8SSWMilO61kSvJwxYJ5ghLc4?=
 =?us-ascii?Q?eXTNgpjeYzgbl61N7uqLjIzvILOhl5/11ytRhEP0jyFcdnTwxHDDiPTwBYpX?=
 =?us-ascii?Q?qwMbL+NH8KlXA+klkoihhPeNAvk7YgbXdn+oWkuIJgMyLLiv8wnO/+cx6o42?=
 =?us-ascii?Q?v4IVijwNrXLPQ9Btpyyp8mE3U3OE2ud56v7TLd8ytK1EIzkPiBjnxUsY+tth?=
 =?us-ascii?Q?uGXnFn8kTBJdlAr4gSPNkOKwWeABuNcEUY36XqLWPuL5v1H7C347sN7LxOrR?=
 =?us-ascii?Q?dsNdNX37QjKnDKrNJ1MRDuzhO9QE4blbcmU7u4BiCsaugT6dM0G9HEgclhKH?=
 =?us-ascii?Q?JZVeU5RJBuf55QrX4hbResGFKDuha3Lahxu70RDnmDlsvS8Ke6M1GlA7dt/P?=
 =?us-ascii?Q?+8R586Z8omwmUEVx3k+m0UMNEBKLQRL+x8WBHXmjLHBn2ctGs8F69sXhhRUj?=
 =?us-ascii?Q?hyAX1bjY8FzyEaM+Tt8fv7sA0pi4DfhEg+lP/WGJqBXOWgrdlTDTwgKV/IV7?=
 =?us-ascii?Q?M0ShPzpD1Q4MNwQrXQl7aR3Nv0PzfUkxhRr4WFBJ0RZej5BhtwgVQuwI3obK?=
 =?us-ascii?Q?6Adamhm8+yQ+DKAihBq8nRuxlZ3w5YEdf6nTlEjrMLduF11KCOXfh6/itF4d?=
 =?us-ascii?Q?d351qrUIdop91bib3xgBWo1TMZA7OYLrKDTayQSczrRrej7Fr9IXKLwJ0Inz?=
 =?us-ascii?Q?+gDCVebnG3+5IGMmvIRmrIXmKc9o+iJHvlXN4JTY9etzRck3Bj0jbYd+vOci?=
 =?us-ascii?Q?OGfBJ6ZRPGNRlbfZqzD1m47in5BFg1a6qOyvuqcmMuWeAQCyaB4tq3facWBc?=
 =?us-ascii?Q?LLq/IxY7kUwp8QGt0ih4EhTdmMo2OCe9FYvHwSqiCUB6K4Bp6s/L5TVOidj4?=
 =?us-ascii?Q?T0Xs1gXF5Kg4MTgHmyF/DkkQg/Xx9Xp5jG6FVlXSvIhPSP5XBka7rBqTIWGp?=
 =?us-ascii?Q?iSOSDp/FlIsJocbex1mNTtKz77L/6+A34d7dEdIxdpbOXtoR/BqrmacgSVWs?=
 =?us-ascii?Q?gZmIQ52hTu71mM4qwK/4A/Y33SjIb64l788xnSAzfx+XFLajCJJnDmhEcFz9?=
 =?us-ascii?Q?t3zg21HzPVzhG7rmjj5CWtHEmMSDSorswsxNGhxVl3H/+qY1PutJdmYofdMW?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oaPgvXkOrxViLR6bTqHI7KYyA+crmTIu9KahH/3kcYwykpKJ1EKGcIirNzEw1d0iar66cBgnPF4UB4otARtObKQlZl6xAUr4JFR5wN21e3uWlgTIqtkhkyFR9KgcrEYgj8uzNjUJ0assYHEcOyfXRjdUqthGiW6lSFyp8WzLTfqfYW20dzl2ZNpZZZ+IQNbrWnp6CxwRB1ZDVa3BNe+DP/cJsOTuhTNvR6EWsUqQQQuhCBFNKDBQypoq4ckfbjNap1WYWTzJ03w4GwFjJhsN8CIpn273xXeMLPXq9TUUCcnV5SqhMkMt/GIjRZSq2PrJN1sp753Gi7BQqXWwtJmA7o4LndXq4edCKH2g2caOwEAvxMgvfMLOn5I0pKPOqS1bXRpawX2ynLTmFTRby9GFCCu2nRHfd+9oLydWyof5+6PfHoYUnNsfSREdhimrWu9MNN2owkfGr3JT+K7uLA0NqrUxWMgVHIznXZ7QfTtquOs7YTFrwtvP5SjrlZf3PHZvLCSxMbE9RoritAQRnHQu0q0wdgdvQfhDj0MAxLA5G8mbO6zbhIIqZvVXcaU49UN8jzomr6wiCy79vNWBaHYNfWY6Bmti7Ky0qQ0SHrypZyg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 647eac9a-2dbf-4d13-08a0-08de178ef66d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 08:33:12.1193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjrQkyygF+8eYdbvzqQnMydYSojXEDHBK6MhkvXiTneTZprxl4o33Clz/miJO1E1k18tHQzV18emHxjQAXHc3mOuuf4CevhqJ028Au96eTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7104
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=715 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300069
X-Authority-Analysis: v=2.4 cv=JJI2csKb c=1 sm=1 tr=0 ts=690322dd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=vTr9H3xdAAAA:8 a=NEAV23lmAAAA:8 a=8-9y-Zw0JUOsBIgKVpQA:9 a=CjuIK1q_8ugA:10
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: jJiYEABZVGVUxr5IBzuwEcl3XJ7YSe5A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDA2OCBTYWx0ZWRfX8rN9e+YX824z
 oWaKQcvTEjxEXw1DAyg/dTthx0HKXST/POTHOS4TJ9tlooUK1YUmFYrBm1F9nnkwVLsiRM/RXyK
 EVvhhwOxvVVH3mi7NZDj7aB3SmHFwN9JKPRRfh0ltJE/g1dquvjd58TfS/+WjSER0Rd9Lkn4KCQ
 awbAEn055kRAdVCYAcNW+JSVnpzkfrMZu3BjBFJSe1hOtkAkV37Scue57neTqU2XaDtffNB0hlc
 VCrgPQpCKuoFqT01+j69mPUPqINVMhPlapoCFsS1wDwVBZbq/en2Ks4l92In33GSrWQ33hJ1pRJ
 ssoBI0PLMTj4HUzI7nOi4WV55bXVggH+iJ16Tg1CQ6rOwl065GrcpE1lUY1ySi3u49278W/hgfj
 +6lQ08+v39/XU8cEW+yPbW9KNfUq9Q==
X-Proofpoint-GUID: jJiYEABZVGVUxr5IBzuwEcl3XJ7YSe5A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C3F7520007
X-Stat-Signature: 5d56iw96oijc11qiepins7ozqpdofeau
X-Rspam-User: 
X-HE-Tag: 1761813242-460773
X-HE-Meta: U2FsdGVkX1/w/l1KWtRVE23+sNsCNX8kxr1vHogmYfF1I5gaj/4QyVn2rNk1Yusy3bXLlUtFehzrP6mp61CGUFKEdi83jOT8zW/Dc079IOsrkppZWYOLxbji7EkKCGnC1/d+GVooXzEDNk4birAnm9EbKzLr23AU3zJ0dYaIxJHjSZs9DQfafy3yf+VjZKC3J20LPQuHLWFQ9X8xcJQiu2zeuuL2UOD31JFhNc/o1s3s5JVt4MZYaBZyrG9doOy8fuIQ79cNMhitaXZvAO1rUOfNLGYAXFoNz/8pAf2cCbe7oiUeXRk10nDmBFeNPbL+t0jt0/c1mN3PraiZd0dEYjJ2Fbf9Xbz/URKrV6Ms/bhf/hoMiLliVaN8j9cV8vbJOlNUJKSu80vh/MV9B7z32i9FyxR8XUKwKQnFheHaKUjx0x1kJ49HOFI946cdV6dd66vYEPloqTvbajgTZtSqoqg6On9fUvZG/Rcjcsbwnrb0/q6WdWPDrrMIWpW5gxzW4RU1fhQ3ExUYfRwwKGQJWpYd+zo/379qHnugjNnVUntimQRF9OtRWS0u/j0PMKoAEJVwrJS0gHxF9Y66MvGu1/aMslP3l6oXcSJUErAOYVegVjISXX1HKcYDpMUoj3qSWh6NNXqyKeM1cYsOgYSMfrzBi4AILl56QDYC3dBgNk7qhxIfVCj9mIj+5K9a13d6P0vKndGp0WS3YAYcudwKiwE83GOdOV33dMS5ClxEPFsKyj05vHgoQnc7N4F0WfeU24RuMmrjXkCxEWz8VQEk1xfRbTuklAb3fs6n1zQWxWtB1mQt0MvzQkomfDqC692iG+VZm53EvDaVm3uC9chB7upD5qDTno0DKmvrFSdRXnApljCwTOPhSpZyBkQ+n5enpyWNx9dMx7T08qu0hvbNRt9tdV+0zjOXUwfA+dnhwy+mcDIj2F+ks7LLMVioLfX08C6STlgZY4tcvArhFK7
 zC/qMuxF
 pYhBzG6bWVtHBUaYL6/gHyP+/vWhgFSdJSn5DuGKeRRyn3j/L0ge0iagU0Tq9V/st6kHbLx+sn8gq2LI2+TacHOpxIUnqrv0xAoWAjrpf5PZvn+4LOL5P7dHjxOGh+XwD1LAZ/a92xQyoi591MvDihZtYdXvFL7+Hh70AqaKgkyP8jy8AZ+SW9FAQo2AXELTaD2VlObg+Eg2oDQhPRTTdA0UUCyJrO+KIEEr3Bfu35pOXG7W1AIQxvB3aIGzGU4PYQBdWIUPGQ/ctC3Vi7Al3EsMBNbm43AX6U+bveWwUe4DMTbnrZqEsR1iTW0v8+zDOrQY3lzcahZvD7B2H8dydRVQxSu/h4WXqD21aMQoWU8zpkV2Kndw4pSddXHElhulTBQNh0PK0wRKejP9SErPep9xLQpatuyd/C8HbzeTLxd5jJ9wnHlVJ7zEHmWka6XbXOuRP27FxhynIlGZNl7bSBNMyZUENSp3x3GQdx7tzgfmPYS7fnOFY9jg2xsCvzN7tiChPwjgd1E/mowsUZZjDd0FNdf3am3V1x/kvDHLjcf9lEUoJXJZwusWAnckk3pUkJH1W7oxhCFZ/IaAXCUAPzszirOS3JtBDYUMIk2Gik5Q1NZ/lAmh6/j36EN/YD2fNlbPeEYVHNIS8mEHIS2kkSImR20oadYOhHiYjMvrns+xnM+/YCzPs8sTiPwLtR28wpQ1BnGsiym3RBeI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Alice - could you help look at this? It seems I have broken the rust
bindings here :)

Thanks!

On Wed, Oct 29, 2025 at 09:07:07PM -0600, Nico Pache wrote:
> Hey Lorenzo,
>
> I put your patchset into the Fedora Koji system to run some CI on it for you.
>
> It failed to build due to what looks like some Rust bindings.
>
> Heres the build: https://koji.fedoraproject.org/koji/taskinfo?taskID=138547842
>
> And x86 build logs:
> https://kojipkgs.fedoraproject.org//work/tasks/7966/138547966/build.log
>
> The error is pretty large but here's a snippet if you want an idea
>
> error[E0425]: cannot find value `VM_READ` in crate `bindings`
>    --> rust/kernel/mm/virt.rs:399:44
>     |
> 399 |     pub const READ: vm_flags_t = bindings::VM_READ as vm_flags_t;
>     |                                            ^^^^^^^ not found in `bindings`
> error[E0425]: cannot find value `VM_WRITE` in crate `bindings`
>    --> rust/kernel/mm/virt.rs:402:45
>     |
> 402 |     pub const WRITE: vm_flags_t = bindings::VM_WRITE as vm_flags_t;
>     |                                             ^^^^^^^^ not found
> in `bindings`
> error[E0425]: cannot find value `VM_EXEC` in crate `bindings`
>      --> rust/kernel/mm/virt.rs:405:44
>       |
>   405 |     pub const EXEC: vm_flags_t = bindings::VM_EXEC as vm_flags_t;
>       |                                            ^^^^^^^ help: a
> constant with a similar name exists: `ET_EXEC`
>       |
>      ::: /builddir/build/BUILD/kernel-6.18.0-build/kernel-6.18-rc3-16-ge53642b87a4f/linux-6.18.0-0.rc3.e53642b87a4f.31.bitvma.fc44.x86_64/rust/bindings/bindings_generated.rs:13881:1
>       |
> 13881 | pub const ET_EXEC: u32 = 2;
>       | ---------------------- similarly named constant `ET_EXEC` defined here
> error[E0425]: cannot find value `VM_SHARED` in crate `bindings`
>    --> rust/kernel/mm/virt.rs:408:46
>     |
> 408 |     pub const SHARED: vm_flags_t = bindings::VM_SHARED as vm_flags_t;
>     |                                              ^^^^^^^^^ not found
> in `bindings`
>
> In the next version Ill do the same and continue with the CI testing for you!

Thanks much appreciated :)

It seems I broke the rust bindings (clearly), have pinged Alice to have a
look!

May try and repro my side to see if there's something trivial that I could
take a look at.

I ran this through mm self tests, allmodconfig + a bunch of other checks
but ofc enabling rust was not one, I should probably update my scripts [0]
to do that too :)

Cheers, Lorenzo

[0]:https://github.com/lorenzo-stoakes/review-scripts

