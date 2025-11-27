Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE863D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47A3A6B0012; Thu, 27 Nov 2025 12:41:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42B336B0098; Thu, 27 Nov 2025 12:41:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5296B0099; Thu, 27 Nov 2025 12:41:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1315F6B0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:41:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C187612AB5
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:41:48 +0000 (UTC)
X-FDA: 84157104696.05.C915DA1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 693FA1C0006
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:41:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qVMjurj6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vGEKkMK6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764265305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKNgsynLcW8P1cZ7hQX4im33DyL/C2i96Ejm5F8qI1k=;
	b=Jh8Ro0P1TIE4wtZZzRsp2EfON2ZOcsiSo/f4oXG2577Tv080b2/DZwugM7HWZza1NgPYy6
	kIayCNKovj8mzUiPYkze+r4XyDpLwRoZECoWADVh44iyH3PcKlvauNGr1FP9EuYnjpaaEw
	KSKfWQXGGxbL6IfUoWZInf1Fz7gjaIg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qVMjurj6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vGEKkMK6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764265305; a=rsa-sha256;
	cv=pass;
	b=KxTek5Vc6HK/0aB0SRngxwniR7uOw+9NS8BxuOjwuoMzgVbgBQG4alJMSHBihfk8tsVYUY
	8lwitk5XzYQdQWDktgtnK0wjESt9lJ/blVimKHp2j7Zi7azaAkvHvZm/2MBFYYDP4KWoqk
	lTRTXknGHpMify2I73AHN2Q0gOp+8Mc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AR9fv5f298971;
	Thu, 27 Nov 2025 17:41:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RKNgsynLcW8P1cZ7hQ
	X4im33DyL/C2i96Ejm5F8qI1k=; b=qVMjurj67GuCNTlGuvTSc6f+qsyPGpZlIl
	xyBU/FV7PDcWMC6I+wUv7hze5bHvhruy4uormx4xYD257J/325wh7gmzS/as0PA4
	A9IveJXvmku7xoE6sT1TnO4Tx2nvsrb6axFJZBlQNSd0Ta6qWSfQ3QJ/zlgn0DR+
	1H3VH2g0rb+7fhnIxaDjdD0aQVPilOG6Tgbs3DSE1E++ah6xUHMU66qyUiUgzVuv
	aa4sYA/02zheiv/gT5+PY9rHTwDDWGAyicTZ0dUJjUXMsAxWW1JowqMl2nCJQvKd
	PN5gSgY4wmhyzdtRDwihCc+RDtAf57ldV+uoPfO9W0NwwFQY4djA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4apm7vgns6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 17:41:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ARHHeYW032704;
	Thu, 27 Nov 2025 17:41:20 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011011.outbound.protection.outlook.com [40.93.194.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mcgyae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 17:41:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TQp6gpmYv+9UUjD0rsj16e7bBSHJlhF6U5md7B8EXJSjPkPTmmjcf4feEpo2tXX1XLW8k9pUD6dJxH+MyDXzvpBLJ5ffeykmO5VzE9+sUkCTTIifEyJKYD/ENRo07CWnHV/g7DDhN1tgwnAlt/yBdhYG7Pzf3Am88iV/NRjwNB2Wkf3O9zmykToT5SZCrJUn/hfgdT1re6Q8yUaP/tt7MFsgTEJwdgUpl8hI6GltBt4sLLFNvKDKZWa80ji8OlOa8mo7r1mq1vd1wbFPnI7pI/fVYd/VxFwdiorSTJ8BYG2upw8Crkf8Z3jbaJgqw6z5J5jEm1NWo3bBPduR7FqUEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RKNgsynLcW8P1cZ7hQX4im33DyL/C2i96Ejm5F8qI1k=;
 b=nNulPPyCDulydAxmx/1dKkS2yNRShSNYY7NGGUEoMcs/XytMmEKhYMUh2DHm5++9WV8TbVKoLl8l2y51+RBEYqfGT15hDoplnuZjGfiOgbultshZUf7RlhX4aU97H4ClK4OVNhTlR5u05XkBZwJuzrU61dRaNFUHjMf2irixQd6iEJXeRCIUz7ottVKvjqauvH0K3ZtWK/o0zGCu5Q7JzrjfVydYVbDCKQCwnYU/4ES0LSsB8IopimI2q1eFeY1Rvz7uPbz09LGyf8VckPEnEpdBzJ0gca/oPfez5B3+WHdk0rbBnXhVx1LwLw7HqYLn0VCO2PYChBWy0MhsT9Qx4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKNgsynLcW8P1cZ7hQX4im33DyL/C2i96Ejm5F8qI1k=;
 b=vGEKkMK6FwjEHKfJ1TvbEjHIqinD4AbbZID8dFJ9SIJstQLZZG+BcoX8XxNOm5C1K6AdwPmY7kBlGk8AiH6cAa+Sx3FsJW15aAPYWlitrbYNqrruTlYk08fD5bY4ukeJTtiemgUytwttxQwrW4aOgKHmkoPiVxDNjUCMGX8TljE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Thu, 27 Nov
 2025 17:41:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.012; Thu, 27 Nov 2025
 17:41:16 +0000
Date: Thu, 27 Nov 2025 17:41:12 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Pedro Falcato <pfalcato@suse.de>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 14/16] mm: remove is_hugetlb_entry_[migration,
 hwpoisoned]()
Message-ID: <aae888f2-e826-42ad-a35f-dbcb15fd4126@lucifer.local>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <0e92d6924d3de88cd014ce1c53e20edc08fc152e.1762812360.git.lorenzo.stoakes@oracle.com>
 <dc483db3-be4d-45f7-8b40-a28f5d8f5738@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc483db3-be4d-45f7-8b40-a28f5d8f5738@suse.cz>
X-ClientProxiedBy: LO4P123CA0183.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: eec26c05-8a31-4768-9146-08de2ddc2ad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N5PFHYB7KQmgxmqp+OIP2RAdrr+nsePayl/AmywKrDPsStK8/WaZT5XpJ2L8?=
 =?us-ascii?Q?H+22j2dDtEJ26PkbiyPnPT3GgXhXEMdORQwnIjT/Dy6mg6jJt/VhfJkcUmT5?=
 =?us-ascii?Q?DrpwRor2zy54nGD1+lTWDqaHvo1PquHrK0y9n3NddwdaeAzOSZtlI8fYa3xI?=
 =?us-ascii?Q?sH19V10rhQQ2SUP+Bg3X+hz7RwlQ0DNL01+tZA1WNwVd5HWXToJ6Fy+K8J7D?=
 =?us-ascii?Q?CO/hk6FlJL2RNtXLWb4JXgP1CZdVqsLrNGUoUHN/+701egCsDwyGpd8Yndb2?=
 =?us-ascii?Q?O9NOnVKw7Yv5mhxOCQRRVH/7SxVxgJOjZcmPiA9xWbPvavAZHll6gHMlRFxp?=
 =?us-ascii?Q?4iXM+qO+Szvytcin6nKKEUwfyRGcM5/eEUJEicrx6KK5zsuz17VGO6Ng5Phs?=
 =?us-ascii?Q?qlS/NAVi6Y7F0PiVGneEodhX2355uLwZPuWXUoHYGWBkq7Q25+0kMXNZgX4K?=
 =?us-ascii?Q?oTSy1SN3hBnMXBfs2ZsraxVqLr+wywrb2TrhVLLqJQhhyD2GHNMdyI80Zqoa?=
 =?us-ascii?Q?/f9aFpgeGVZOHssbnrUGnlLBj64l9ZVLxWQEB1dxp02j4UNzjRnZWwR6xVFT?=
 =?us-ascii?Q?dJoLmyCLoBltkHjQchniY/KHj+LGDOWwn/lGZQ2WLhTxq2V+1WBd0q2egiSN?=
 =?us-ascii?Q?5nvpZKPfN4tghcuTXcaS9FAXyn9cYGp4uHzDuk+Bq73ol01jXoOIf5YkX/Vd?=
 =?us-ascii?Q?TZw5QO606G52kLUvHruMUyo2boioRnmNZF7aAxuhmW+eN0ossMLFdBTdfiOv?=
 =?us-ascii?Q?RcRnsQhjAo153lF2caqLFRWQcSDsKUeyvvEUdEGiOXrFUY1OmsRBz7nxSTmu?=
 =?us-ascii?Q?LnENLQCpC9mNyjES/CWYqqb/oF8l3r5z+hqt9SKj60Y64tz6csB0sMio+xZK?=
 =?us-ascii?Q?K4qrQOPfeBc0X6HG0Ct3CsJNCay5RpN17CGO98Zvl2cyR0HYrtc6xh3qUFi/?=
 =?us-ascii?Q?dctpunv5APJHGpLrQylRjTkof4oY49gXa0SPf5n2SRlCwJelHG3g0jhlqNVX?=
 =?us-ascii?Q?+qYYzHg7YkIljN5vGuPEXeSmCqdjpW7lnEMExcHtqHxVLr8YS/PqfgVcji7P?=
 =?us-ascii?Q?Q775ULPGcaPadKkcjAi2wCX5ucI+ErXCd/vV2TpmWsl3qjTjte5fC6H8Eq4I?=
 =?us-ascii?Q?z8ndNeR8/EJQn5uiwVLriVPt6E/eHYE+lJdawLi3Q5HVf3l5gszaCiYG4Vko?=
 =?us-ascii?Q?/qWKDMiOntQetYXHLnSeVScoJfTi3CDndGlvjmqeuT9DaawlASkW8TUjF8kg?=
 =?us-ascii?Q?WYTwpkji3KWJdmQSmtr8PBXF0MQUk2iDAUOaH0Y43TULJkrGAOietKc8HydH?=
 =?us-ascii?Q?UiLeJldeIV1hujyi3kACNKG1KD/BLjA7sKIOGr65/Zpn9XbAow7paa4wZv7V?=
 =?us-ascii?Q?pWQACOkcwoW7i4pzAogwp1llmTvm8pvcofaXcjclwzeQITK052I1OfUNxcW5?=
 =?us-ascii?Q?pXCTrUwuiLWAhz8SCXO1ObL8If18LKpD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zvaUbJBPa6hj0oLTBWLOMMXoVFz9m+Q34WEn4iO/dFKKF8LNPQA+c5wNpbmd?=
 =?us-ascii?Q?8oOfC1AABNbXKpN/dTDuOerbKU29kNA2vllNyuIA2oWo/5ewf3RAfuWLlF4F?=
 =?us-ascii?Q?+zxdKvqDyga8TFZ3wJK3+aqGskwmODhyxwv2pXMvT8Ab43DRqi1w+Vn+goLB?=
 =?us-ascii?Q?fRJGNoYRh8esTVDMsx6ZtxnLAB3zpISp4stHBC3638uo3tII8NGHa7HyaTFs?=
 =?us-ascii?Q?zbeYmJkjkH56o1wNujiQWGCbQ/hSJxN8lXqYVOfNduN8YerONSppApcA8lTr?=
 =?us-ascii?Q?AzM3R6uHaFgyG5lCPm5I6Skn41V968hhY6+6Mf+n3y0/BZtWJWPCbLa0CMa2?=
 =?us-ascii?Q?os3e+xGCDX8Z+/VTwTgO7brF0v7DSDmMij5XorB+3/mzSwvJsQQHG94+lBwg?=
 =?us-ascii?Q?7oOkKF9d/DkKdCuyYOCI2WhLL082DTLn500nAFF1jFGpBwaCdjkF4R6nrLU1?=
 =?us-ascii?Q?7G0dAabXB8iIwuwS0FQN/CN/Cw39P84jQFPyQoxrWS3Dp9msZ34H1XVz3LAB?=
 =?us-ascii?Q?0rI6b5WLxC7vkx96/O2AOLNRfMciLm1knrOoF/n3nH8sT5m73njzArTIhGNY?=
 =?us-ascii?Q?HF3yVvzLI12eKgld35pMBMDnBZvwe4z4OyyYhQy1UA6xnRcySoofCf2f1SsK?=
 =?us-ascii?Q?suo4ac+nifDX4wWaHVICc5cVLnZg2MqS39m8tKb0yx1NVRxk0J7K/iTp5LbA?=
 =?us-ascii?Q?Cg+htedkKgnnsEy06xdSWFEp3jtRKXooIR5TUxnkVFv5dUQV09jzSPCLH1ca?=
 =?us-ascii?Q?EG7RbZdfYN+KvDgB7h4zfgyN9CYYzln1fJjnvkIVXzDkZmQKZFQBJBO+QaaY?=
 =?us-ascii?Q?SN3gGFzZ62pwlEcfFNE/24D8GQQDwZ5KmI9zmsT4JjIXu/2f8lpcrKyCXa0F?=
 =?us-ascii?Q?d9vPMEdQIRRSJUu2tYF0bMP2LfSgH7Qk+3hE2HLS/nIcetroTniGIMKdkCGI?=
 =?us-ascii?Q?JisfxywLDUkps2n+kVkuDLUxOxTyZ28eTxhhKGZZOhb8pb663Sxr3dkzi0SH?=
 =?us-ascii?Q?wN2fcIuA5xx/Ifem1BHW2ivrONr2Bt4xNr7sXvAXtCX6tWIebGPcledK7gMb?=
 =?us-ascii?Q?XcJT4Duxl2IdY64WcYsiar1EqhKNq4XIHRRteHtz67ZGdppa1mt1PlOBcmo7?=
 =?us-ascii?Q?oRq6zg3YlUCruz3hDSobIWhlX6tM1FdI6CRasJFIwpwaspjul6TvEjj1hQjR?=
 =?us-ascii?Q?qdFAyiSDElpeocnvmWLdAoqwfCSuXqyN9GByoeIz6Fe+R1Pu5n5ra0kGlWLS?=
 =?us-ascii?Q?mRxjRCZ313R16dzU31AMmYqQAAanbphn9llPBAITDncp8qf5SW8O/9C++ws0?=
 =?us-ascii?Q?UQRDFdbN8XoVJuMZd4fcyP2FoCSWqgGu1cSPSC+ZHiw4PSxHr7YcpgIZAzBW?=
 =?us-ascii?Q?p7sqejRblL1gXYnTjp09Lsyvjy9GS28GfpSbS6od8s12dApGbmn2+oBrqXLa?=
 =?us-ascii?Q?FuA6tesV76QLkByecomD6N/jARA411I/g480k2ZysU/drJaANbq+EFBhkAzi?=
 =?us-ascii?Q?CPYNAuKHshg7QJqOGcuq8usGh6gh8sH0Mxrf6ISrSNBRC+Lqh0TsNDmcx3oq?=
 =?us-ascii?Q?nuAbxyKRk+g3B/36JRsml0PXyCZl2rzd3AmP2X5lvswwOLLggQQfQJuJrlNy?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tl7InHpRvjo7S4voLW8YN0o/wqaLGapaCaqpxXzLHWGUoTO1+k8pn0etrrJpMrnNU//MHfuRcZu1QP7aUuoIImMQ0/jqSqB5x9niK4ZafAT27GEdeTUrjdvMcEJQ+ElsY1h0DEtLjaDzJyf52zyu+WIGXDAfdJUZtEV3sCcn8izH24Q23WYAfgtNkJyLuc+r6Q0WsMeOXAEDQt/YA4b9Sl3L6qZdhtLc9p0k+KO+v9YOp3o/Hw1KbJpK2n337XHEKqGfvQngJtXTxHXcQ3S20k5jq5nOXPjxABD6IpYClWzO85g5iKTpWmhKWFJaEHN7I4nuHUfmIIqm84j5zy9yAzw01H3YcUbaFu590Av5TqhxuNDVyzm2Y9bjdNdvNcC5o+VtikbwS+M0Wxk+gmURL1DPPc9FbCIRd1e5s9BEwweP5BQLltT95zYVF8pWDAcluoZkHd3gmG08N2kOeFNn8OrMdTl60NhLxRC+xFoWySVvN1HYhyHbPqhJwHqQfU3ULki7QMorCdKgqYEDn0z2KSsvwgLZEavbhE19IeS+iXjvVTpK5c5A3VYOIHazCBwvR7t5Youaq8wbWcxS0zliUp/diBp3rcUEIYDk7NHn2ww=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec26c05-8a31-4768-9146-08de2ddc2ad8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 17:41:16.8822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Y8jwt4T3YONd5KeBCN57LPolariO8s8vkKPhUTTtb4sg+JrylAAlkMJ8VFD/MoatPmKArIIRaR1ebuvcftkHaWjJNkI0tu0/4ikq8WcSvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511270132
X-Proofpoint-ORIG-GUID: xtiElJ8EMNdNF0Vec-YgXysHGtG-tJhF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDEzMiBTYWx0ZWRfX+JvIbFsUE/qW
 wINS16yorcikEKHQzEA3L3EQKtAGlaM7Mkz1XKazGjgXFPy4pcrCDm1fgaAtiGJ8sVsDFxfzSCx
 on4JrX0zR5w83oS/kzUI6NUEvkwTBWK+98hCtiT7jeb/X4LwF6YBXqqpRKrKpGNGq7tQwWhtNzt
 WQDp9LTtG4T118UsnU49QUERcST5p+S/PRs6yWHjil/8QEu4bEKBWyaQk9ZXBqLTzi/IfJrr+6D
 A5/6PL8Kfd+LbXwMzlz6u8X8zDz9dlPZzLXgaVla2ETTq4gPX3rm8Kr9UqmUugEpbLkyceSa4bm
 2pj6GTuI4y7WyrIXImKmOf4z9SG3xovThsguT+OtNnC4LpRn8cBaqpTU8ZMBaBVhOhBAfbTcAje
 qb8nNZOKgeyHEWEmg7HWzGwPhDtg0Q==
X-Authority-Analysis: v=2.4 cv=A9Rh/qWG c=1 sm=1 tr=0 ts=69288d41 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=SdnQnRXblhh1GgZf_fQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: xtiElJ8EMNdNF0Vec-YgXysHGtG-tJhF
X-Rspamd-Queue-Id: 693FA1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: k5p5tjcmiz6owzifym91rztyeim4httc
X-HE-Tag: 1764265305-332228
X-HE-Meta: U2FsdGVkX19ywp0DQKeQUNl7IR54qX2p3B+UjLDyGd40v7MFppA3l7XWDX2bYugLWCOgvW+c91ZG7QSkVQXnOwNsDazpJJpTlJ0sp/9aOOmupe3xHRLvEJYm69pyn0GuXOfXpsptx8gXtJRsYsdFHv0GpuqHlgME+eJbJo2XR/SfdBR5P9ctsv/H7ZPlENovZBo7gK2qygczUD4TVC57v1UG1Rtdfi9itLy+9QIxIKRDinJuyqHFwFplrhz4kSj9fVCFH6oGo1UN/u1mp5m7w5VBsASAmslDR3auTZwVjsai81GlnsOP1r0h9v222iF3CvDm4t1vBnw+f+T9ikefxeC2l1Qd8iSHOA7WVAzJg26jQ9/tlpGtBJ85fYl26k1LLj3rFArfbTK34YZrcmecGRzYwtMmMxBNRjs1DNk/ogrE8zBuTO2diuZiwJR+GxNUp+yxJYU31QeqhqQTppRaWX1OB6e+jGl439vOYPiFVWIp1U3gRdhQO84mz/Hy5JtHiSW0ZTS+opy0D43hWPgLcEA0iAEkoO9c7OQLOnjIZEr0z2Wp4KjLae9K66F/eZIJ1e6VAjm6F0S2Hk3xyhBmp6jurhzXEB2v9noNiW3quhF++yd+blKxTsZGMXuaJ66BZaALaJmz9Lq65MHcNkvPVdYCKVMS/VJFt3EpAiC//UFrRgqUBilTjxlvhe15Zha7ZVlxEnYgp7DASnM5nJvRhOAU+5GwG+/yIPcJoIUTlgunV/47JjdPTldNaR9h//okuHEgyu4YAqQqnqxp0bWVU8cdcLHd+NbLx57RgHhVIjBRRmqYFw6JDLdEcZO1OrRYXtL8Aouy0EGdcK/RBs1I9f1wm1zXUr2u02WhnJdpObPnqRBZZrmvTO4Zu3BLZkl/qXMK5/aERKiLKbLpGyl9te7hofVlg2bT0c8ajOyH9luBkY1Pq/0+y4gITnz0Xp74CoXFz36iRdTsuQqS+8p
 CeBHDh53
 vrj0T6+Yl3Mspy75eplhpnyM/rVREvWMp/mEGROVDOy3WwQuyFVjX4qdqnK0TihbXFOCRh5oXR7t2m3/6TGfmSKHOVRL6uIafK1DOnEDlf8/9cDyYxw6l8zKD7VB3RFaxdeDeu4oWTQ0gq64KeZDzbILhnUuyVRBJXCU4wX253D6pmpF76RE/RHL/0xAyHovFSWMFw6iB4U+v981vgTa3Iv8TD2Pa99qkRpot234QSpBQrRrRFpgeHe0kgCaLlcuFxXF4B5YExuJlg7ylZTnGc8j1UCMqDDhcfyL2tiiHVeCQEtER/weY3q2LYz0llXRfFkdE90BLCnk81roUzRVcUzD3O+Jl+gpeXJniNz5gtEilLqrwlukraYThTVOa3ROtAcMuP8+BvpVd961iM6A6pmEPpUuWKRZoP+0lIoZWQH/R9tpngT+EF0GtPsw8d7jByFc3WBOuzZ1WghTGaKTmCgPXHMKnN/3+EHjQHEHHxdTdelqyZn12NmIUWsnnWodu1tDeko/Rsjstne3rxZWcHRo0++M0rWvbUgy2UoRmKxgsWtcTkBTtvugrnhtLehgjeoyxEyGXRc/ixHYHA4eoUYO1+yzhTLAULiL9yQHIyLNsCirrhjVqyR4WC4QZnwT2kU4wF6ytcQn/or8glW/QjVRV20/US7wteTdBtAvVJqNx8ABGLtXBIzGSWkiztLlfo33RTnbvrHvIKOVbyegJiyGQggrNUeASl0wXrD8PZQlI5TfJtrkPCz+UldtqUrM2FHGr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 06:29:39PM +0100, Vlastimil Babka wrote:
> On 11/10/25 23:21, Lorenzo Stoakes wrote:
> > We do not need to have explicit helper functions for these, it adds a level
> > of confusion and indirection when we can simply use software leaf entry
> > logic here instead and spell out the special huge_pte_none() case we must
> > consider.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>
> But seems to me a fixup is needed:
>
> > ---
> >  fs/proc/task_mmu.c      | 19 +++++----
> >  include/linux/hugetlb.h |  2 -
> >  mm/hugetlb.c            | 91 +++++++++++++++++------------------------
> >  mm/mempolicy.c          | 17 +++++---
> >  mm/migrate.c            | 15 +++++--
> >  5 files changed, 69 insertions(+), 75 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 6cb9e1691e18..3cdefa7546db 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -2499,22 +2499,23 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
> >  				  unsigned long addr, pte_t *ptep,
> >  				  pte_t ptent)
> >  {
> > -	unsigned long psize;
> > +	const unsigned long psize = huge_page_size(hstate_vma(vma));
> > +	softleaf_t entry;
> >
> > -	if (is_hugetlb_entry_hwpoisoned(ptent) || pte_is_marker(ptent))
> > -		return;
> > +	if (huge_pte_none(ptent))
> > +		set_huge_pte_at(vma->vm_mm, addr, ptep,
> > +				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
>
> Shouldn't we return here? Otherwise AFAICS we'll also reach the
> huge_ptep_modify_prot_commit() below and that wasn't happening before.

Yup, will reply with fix-patch, thanks.

>
> >
> > -	psize = huge_page_size(hstate_vma(vma));
> > +	entry = softleaf_from_pte(ptent);
> > +	if (softleaf_is_hwpoison(entry) || softleaf_is_marker(entry))
> > +		return;
> >
> > -	if (is_hugetlb_entry_migration(ptent))
> > +	if (softleaf_is_migration(entry))
> >  		set_huge_pte_at(vma->vm_mm, addr, ptep,
> >  				pte_swp_mkuffd_wp(ptent), psize);
> > -	else if (!huge_pte_none(ptent))
> > +	else
> >  		huge_ptep_modify_prot_commit(vma, addr, ptep, ptent,
> >  					     huge_pte_mkuffd_wp(ptent));
> > -	else
> > -		set_huge_pte_at(vma->vm_mm, addr, ptep,
> > -				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
> >  }
> >  #endif /* CONFIG_HUGETLB_PAGE */
> >

