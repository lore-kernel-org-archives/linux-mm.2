Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2761CE7B0E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 13:32:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75808E000E; Fri, 14 Nov 2025 08:32:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD9C8E0002; Fri, 14 Nov 2025 08:32:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4FFD8E000E; Fri, 14 Nov 2025 08:32:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA59A8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:32:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6708CB8A5D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:32:16 +0000 (UTC)
X-FDA: 84109301472.27.C87F36C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 11F3720010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:32:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VNXQHLOq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JNJkjPDu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763127133; a=rsa-sha256;
	cv=pass;
	b=Iigal7sAvXJ+hq8ZzgbHTu06zsEXXvBqgS+Q3n8cDvKPwMcWg9f0SsS6mTARvonsPNTANp
	tYQS5pxQ3Q/JertnTPyON5GgAScKnOu/pru3XEQNu3VnWYzH+XLo7FM27Zc0+eSP3WABD6
	aO1o1CQ6c/ZV/gvNeIrPt4SUSjTYVF4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VNXQHLOq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JNJkjPDu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763127133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6O7L7FvAdhX/Jp6IvUCuECP7nVu9VdHmj0QgR5C0RHY=;
	b=UlbS9BNfKwfjR/ldOI5mk6K3LysS1N609UtHSfeYItj1LLbw0ywLd0uaD/9Qq43rx4lkNS
	QqTvV4k5N9TziXYOOwKkYLNvhS+dAeX8UihZE/1sCcw7+Gk9QOA5M4oVQiSjvI76YDlb9n
	oUVTHLLEloiB/36DbPTYad3dERnxe4c=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AECuQxV008163;
	Fri, 14 Nov 2025 13:26:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6O7L7FvAdhX/Jp6IvUCuECP7nVu9VdHmj0QgR5C0RHY=; b=
	VNXQHLOqww4gbfTfJwSBkMJ+H1JzFj2XtROJUUc/1SqsA46tQbzHbz662i+ywQXi
	zzfzYvglVU6ejEYuF78SOn0T6kdyVaKtQuqT9jwbPTx5O0vJsmLDtsbqDW/jJrXg
	VU6HEV8v6oeZ78dNTBwWZ/nHOu6wJ0zAKoGsjnPc7KYSFC+/r8ahqOucmbjdYazS
	9OiD0A627vEW7EGVm8PKaxup1O27BcAnsIRjsQd76Fgt4E7+/YfdO7KATwIK740V
	pDGPnN1/stttYBJ8BhXEjjaoUi752QhneYeuC8oHEwObRXWoF2Xvdz7ArqkqAa3R
	0KdGayMnLx2ZsH6L+sGwtA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4adrdjh4tc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 13:26:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AECPACj038491;
	Fri, 14 Nov 2025 13:26:41 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013014.outbound.protection.outlook.com [40.93.196.14])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vadgv4s-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 13:26:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r0dSA4CMu/rpuZ+bX8kNAq0pXKLvtSRZ8vkhMJBUUm6yi3ier6HuaqcSRZz7eo2z8IOK8uhroGeoU/lbUCwMsaOk/ZM023UfVnLDPvLj8aQwYsNZ+00Us7tJArnBqfUwjOliq3D4S4n6aZuA0RD+aVs6GXx/4+c6vfGbM7KZd5C4BBWJuc1qxAS5eUPkzwap5UIgDtcMyK0W82qQK9VP+CmeU2LdTv6t0L8jNrI2p2lunKvEMTAbp6rPYiMaX0Mc2PlyU0mEEMzzMG59Zbawx6Gn5rsApzsFmFPJwa19ZctN/SX8+iFbiFWgNb/R6nBM4a4JwvWIVYlolZ2zcJcvRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6O7L7FvAdhX/Jp6IvUCuECP7nVu9VdHmj0QgR5C0RHY=;
 b=EzcoessBTPMg8yekNdl5gWm0MYY9oaHd4ZIeooz0X6cCCu7eg058jB5nUt+TzkYSy+8RIb/opUraQIUcq17bu3KWTnaNgAyBsuf1H+ccV82fxNlJh6AKFgU6tlZi8xMrcrVBm4FVEJsu0J0UeJMowT0tddyxc5fSjCnrUYsTst/MirUaqcDbsSJsuL8g8E5py65Idl/q0Qqp9BRE5cHKzAM3TM5i9WPMG4qbbHtu88aLVQ7Av/9WKKVLGO6/3iR80276dXzgrya0/ywPzNbcl9ziN0BPo6r/x8cxqoSQ1uU18yVs3HDuzPtZiZX4LTcWAJ1e4kQsk3ilExW8YNnewA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6O7L7FvAdhX/Jp6IvUCuECP7nVu9VdHmj0QgR5C0RHY=;
 b=JNJkjPDuIq1E1JHmQ+JfKF2PwZ6CNLgEp9KLLCeoUY19BFenZ+1NvuAKtXG188bVUskBqTjKJOn5wa2m+EgNiEru6JWeumzOx/ej+2oFD0LyJmpCoIANK6H4xHY9+cyERDcRYEZCM6kqjfOn6w7U9t4qVAom2yEwB2YpMunSw1k=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 13:26:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 13:26:36 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
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
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>,
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
        Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
        Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org
Subject: [PATCH v2 3/4] tools/testing/vma: eliminate dependency on vma->__vm_flags
Date: Fri, 14 Nov 2025 13:26:10 +0000
Message-ID: <fb709773edcaf13d7a2c4cede046e454b4e88b1e.1763126447.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1763126447.git.lorenzo.stoakes@oracle.com>
References: <cover.1763126447.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0655.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f6d11c9-8545-414c-b9c4-08de23816f6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BbmWxNsWmvS7qQT+Kas/wBgCIc6mAKO801l+fIN9mVKx6RvE0bYFMW0ZVw3D?=
 =?us-ascii?Q?EA1qd5le5OgBRSMPRmTNLl4Xt4rl70bcw+9zGJpQQmHmeTs6kCfdxyxeFy/6?=
 =?us-ascii?Q?T21i4ev1Up7fxYCCyn05P8aTEkMfIUlGgnDmIZPqvxcopKM59Wgh29TJn5ro?=
 =?us-ascii?Q?1VBF25UH6GdUavRclK3+ZeXUnNW9qkaVBDZQL7cH58U9BO4Ir3rEnCDMJib5?=
 =?us-ascii?Q?VfXRrQ42oYiZ7bI1sPKdrTG0S6JRUqazo7JmNuLL7CXO7Fg3X4y2mwDhtHOn?=
 =?us-ascii?Q?okcormjPtZCkPE2iNC9IJUnB1kR18cJXLydU1tvRemF2oN64XGrWGd45SGcw?=
 =?us-ascii?Q?Sf20FNk0o3o8H0Kh8ozwxo0MNv52WLrqv7iitFm/rUfoufgmsovYJxGfp04e?=
 =?us-ascii?Q?YfpIYuwgY5nsVBEiZ186SEcjiuD9HOi8Dhkl9TniBdF7IgRi01rmEARYwSQp?=
 =?us-ascii?Q?4vbATh8FzlgtCCcoUhhVAE9lbeA2ExecqH/rA9Jr/yd2VUpNNw3W4LZJLCHD?=
 =?us-ascii?Q?0huCR2ebxHW2n8iKJVo4/QYFWGgs/gyEdauOMmHg7BmPCUolfpPNfJrzvx9L?=
 =?us-ascii?Q?+z7hbgSLac5yJAjSCn55T/+UK4wU6U01+QYS0eaawwKqcmdqrRypkD4/YtDs?=
 =?us-ascii?Q?2f3PK/qQQfkwQSfescrTGw5L50l8qY+gl1bQRl1hJ6gDZUVrGV7jaZUMATk0?=
 =?us-ascii?Q?Qzz0nXflRfGY+UymSGqnYdLcVejb1dzs9Dfa6sfDQkUTAP/QxAlKDoXo5OW5?=
 =?us-ascii?Q?veufNc8znZwLOLviPyiSKEMWkjT9kmK/EfD6htnkcKHL2BvfwOpcK6bwL0Qq?=
 =?us-ascii?Q?Q7O2e3M2mG/zXpm8K8z0ZIHU+lD2eD2wb7ZzeoJI+6azGsXvMZ3I/cfyfZ0D?=
 =?us-ascii?Q?fU/dwCYGBIi8b9ehAHmpUHOBIpvIOWok6C5g9qGgCHI1lWOYaf0Zt9S6DmHS?=
 =?us-ascii?Q?HYbuaCh5TLhNXE0ErbRdtVcXlF1rtH+RayaXElZSLVCnNqWLAIN5R8spAcMU?=
 =?us-ascii?Q?cD0LWU7XHmM/JXzQfVOEfMYf2XmSoPz+Cz+1rv5VbHiuEn54dB3dBD8fFT1c?=
 =?us-ascii?Q?1Cwe6pBqgWkw17uNNMRo477Kn96mGSLL9NSJSi0TAM1z2Uq71tUjn/VCFDY3?=
 =?us-ascii?Q?2AKk9hNvBs9KCubq9Y5Ds02CI+gWMafASAJcBFQBYzD3zjaM4XUkR5vwreXn?=
 =?us-ascii?Q?DEOw3lfx6bxDL+hbx9XCgBYl0w3os+bGG17abN2e42v3ghfoH5D3psAprCGu?=
 =?us-ascii?Q?rl4oJSn7sGWrIO2KF/ss5XeVW3cQv2wERZMhceackAmjHoJkhWyvEFgBa1UL?=
 =?us-ascii?Q?wYfykvqdaoBGQnhtOL0y1U+QNt2VIUQfTawNEhKcFoaTZJvFQDLoy8tStD3C?=
 =?us-ascii?Q?+QUvuTOz5OjvjH9bitfV1T3eYG+yUkudFAKev/Sg4FsgquCGEoUlYwRenYwb?=
 =?us-ascii?Q?sXFtS/EoMMwbAfmX77/tGvltkv4Q6zzD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HCs+witMiWcKVQ5a+l2F/83yTJfZTdlMNdGswSKh6DK/pLtxpMxkyqVCxWuo?=
 =?us-ascii?Q?QlJwRG4m5VOnVlQMZgpjlMx5BqmB7ojCNJ1Q1/b/Hfqx6gVGbj+EX8/4pVsn?=
 =?us-ascii?Q?/NqGMZBrdmsWCVmN851HF3jLG/AuGEJoXXYI4ZZXxSNbHNQKKFY95rAn8WqA?=
 =?us-ascii?Q?g6ohChElw6ia5++GN3EUgim2qJUVgYQmizaDTMnWrcFUBxEwOKWDhwOr73nT?=
 =?us-ascii?Q?ibGsh9WIWY3k0zOaFOEx/7ay0EIdZF7Ut9sCnqEPPRIk4ekxtTqnoLtFFNvE?=
 =?us-ascii?Q?O9AOFere2Yx7yGSOfaQ5aKA3DLFktf5MQA66ioAcKQijmLgV5FcAdngXJfoe?=
 =?us-ascii?Q?rKUM4Rh6E5eHBAymcywXfz4KFY5tEY4QBWhY4XGJUM8DEuh3yLMucgTygfVu?=
 =?us-ascii?Q?1kVQ6DIvuVlEUH+aViKkQnh5aFUv/6VzbjxAY23Wmta4kp7R8k1ug379G3a4?=
 =?us-ascii?Q?Dx2gGsKx8mgqMkianwvK5/lEsh/1cVJYGMfOB9zHk90+3IhI5UBSSnG+fFlM?=
 =?us-ascii?Q?HLkgkmgWrUIe8nNQu2+gEItP9nFnrUXUBqi+zRR++s/Y+rJ7cpUGzngbtbFV?=
 =?us-ascii?Q?5SvN7teYjRUhDUq3KnAV0AziCkNrHX8gQR6SUPBOxumuPj2w/7I0yxHjABIE?=
 =?us-ascii?Q?dXZqDPBH089iF2KiXvUC/NsF1RNsCe85GyrYmcgN0sxETeqyS/KKI5WGjIW/?=
 =?us-ascii?Q?oKbgl/OcQCPSbkQeUdiLbE3faRqrlQiS/VANXyVCPlIPddn6yQjVeQMnlf89?=
 =?us-ascii?Q?NJlrPCbKa+DZyPezaZUYi0hM05z9jj6rtY34P67Dh+bw1MvBMTldnw7pVkdI?=
 =?us-ascii?Q?XAj66WoNXpC/ovtzSa3jB7X4eKLYB0QtBBT+0+2BoF2/AI7jS9JK9Bp9w9N3?=
 =?us-ascii?Q?hpx0mT8KhE1+hPx/A7kH9js+erQSh287+GMlnrq8/uxmWkeGauNfszWXJuuW?=
 =?us-ascii?Q?f6OG28S3/6bIXLZja+f3znMrW7PTSufpPMyTtoVg5q+zHzCuyjIlyO1tjhej?=
 =?us-ascii?Q?P/IiKzmpKhhu4uPzWt1S/kGA9r/V4xZve8vCA8OkBmhkOqgj3L1iV6e6Jrc6?=
 =?us-ascii?Q?CMpYv5GJKG6YWsSxirsPuIMlW8N6gfuXcHUrT8foR1oNMc92fA+sivvkqBmh?=
 =?us-ascii?Q?paAY0+FwF9AHowe466wvNvDYkTZw+AXdETppcFc4WxsKIAbnS5isAkMQF4CF?=
 =?us-ascii?Q?Z3S6ljt9qR2TUxfxBe7kpmeFgTKxtxSE0QM/WD2N1SfwS2R4G+W9O2PEhfMG?=
 =?us-ascii?Q?QKcEhaDpjrnT+aFTbLrjTPq+WkKT2iFGBntEZRJbiV8HEmapm0TAlMpx4X0H?=
 =?us-ascii?Q?zw2b5P3HCasmFn8uRbisKdfrMSWsuR4TmESux3QfQK8M4WpcnCHklKdM/3ju?=
 =?us-ascii?Q?ViguhfVPLyOe1ZHT6VipNntljeOc0/KhAf+4uh/3IFHlfAtPEKIFrYT70PQU?=
 =?us-ascii?Q?GJH1q8NB5Wa2ovbehazaHtm1hXY/6o6lRLeHMuoDVA8VeMEtBXnHwfD+Ozta?=
 =?us-ascii?Q?gDulOHna6A4TU7pt6icmu7mjEf/Z0uTtwy+rLvq1LjCfHA4MD7wCH3zhz1Mf?=
 =?us-ascii?Q?nDnc06VraopE9KdEGj4bnhpeKAwUEdyngcr26afGPKilodEV8o86wJZEgAeX?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZQx3+1gIozPDWkmvEuux1/jUdvDLYWr13fYjCt+iLiDv3Y40lOqLiGdDgbUvSxI9G+7Ahs0cS99vpy8HEexlQ8azNvVjeAKPkrytGspLWyu2FDifNPRR1mY7o94sa+xqhNvP1qja6S8F5Yx/bnYh8PvqDqh2TVBQAtF0/8/FfhgR67BG3ft20UpZBIrnEJxU5w/IxKpxPevmMcTMAid+BvP7TctKR/a+c/ZMvv5K0y8IofjapNNUwaau7Q9L91R0xepx+J00G//A54NB/IUdyjSM55IG9lYFvF87+5MzZbiC1BJlgL+ryZPv32kWDiCAShYURB+jQi3KZy5SWBM207NDYXN5EgnwVEvLlUrHjUhlF2oU3Ve2EEMLBSXCmFC9bW5cURGk4xs4gENqj7roy7xAg+uGByjMWkM1iOEGb7ouHMjdZNfTaruQkv2XBW2vUpsQ/qnZYvFOeH9P93Yzg2X5pG9uHsUa56XuveX1RiKbfbUgdoyDDpbEYmeK1WS41Tt7q1xFy5UaXRoVbBkcwQef62xnuONC565c5M2pvvxtb2IO2oqSvNjZGDxM477mguUTI69HOmJEYZ60jbEe5lK+QWxL+YTH7h9Pb8Aq1aQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f6d11c9-8545-414c-b9c4-08de23816f6c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 13:26:36.1114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4mGVpvQUB/hA61KOdsSIjXusS7XGF7NSTRFcSvceImk+Y4ce5jdWvh11oFB/CcMPpQCvVGYrMSTia9osCluGA7WE3WUmUQ29Seevr1Ai4ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511140107
X-Authority-Analysis: v=2.4 cv=L9oQguT8 c=1 sm=1 tr=0 ts=69172e12 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=P_b51HnBFZLct5vy70cA:9 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-GUID: cGqaBHmVzbfE1Nlxa7456Jbf8W8UHjGr
X-Proofpoint-ORIG-GUID: cGqaBHmVzbfE1Nlxa7456Jbf8W8UHjGr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEzMDE3OSBTYWx0ZWRfX+Oy3ctjsin/K
 GNxEGP2DEWqLEl/AkE1LSZt42RuRjNZTPyvLaiX8rzI5dw9OeUmjNvGtr5QbmvhbUMGlUK0PrmT
 IYzDU1GOQqLJuEsT/+DnFJlIoIjNmBYIs9xf9J+x+/LFcOGmVCrv1bsTx3iURrwKKlRzXT8WsO8
 bNba65AyDvBkXo7ggHTwEKf161HhLazHV7NNhUWC6BMsCuUIt4kBpwfDoFTmfvU4rL/ZKv9NnrQ
 w5I9SVCw6YW7up/xNjuKglIq0d3iBMLGK5vwfinmdUR03BSxrxnTj55M04aevXhRnYCQlrELY0F
 RhT0dlZvdovuOc3EAkftL49XzwkKoGu1lViL2o2ya6w/iyAn3oLDu1IHdhsMnbqJpaHgJUvsp+m
 OeQtDCpN8MdUdhrCJrhy8cTg1fhsmw==
X-Rspamd-Queue-Id: 11F3720010
X-Rspamd-Server: rspam07
X-Stat-Signature: 4nq9u1zrnbb533fby63ratsm9f8uiisz
X-Rspam-User: 
X-HE-Tag: 1763127132-750140
X-HE-Meta: U2FsdGVkX1/x6llNU0xk6GFmeppikN2L9BOtrVYzZRR8EhUjDrUDe6vPsCFgkHfDFSILLyhROU+W7c/TvhiB36+gEEKEsJIZVoc0wvKcUX+3ooBd6KGLFw6GQ8C8pTzRduWzhWCUb/uVyVQ4wlGr8Az1ETlcFM5z4NpWPyP1UuIgUQp2dwwE/UoPU8w7CaP5aParpNcDUuHvUACyi1/57uD7GYR+ydukneZtm9HRf6fQr5wQgMtBjSUR3zc3ZPXLFwXgz+NEnwM4UgsDY06tb6ArsEse4aKG6fZuUSDMNATotwCWYiNBCsOOfA1Gd8DZhncqkgdZI4YD5j42rkXy0XDobtVDCzHij4x2wGxRvhbTTPCT6MHNKEqnLs1/PVFSa0RfflI80IRJU+XXwV/yMoIiAEZGYxFeMGUS3Xwmvrn1Py8/wfVhNe8Uz3l47ji7/WXVX9GevysOXZik5XyVqwwnG+oGdDXrR/6OvPyi2a9ACW48REepbKzWs/niwu0IEAOYRqrWJOT9na/xMk1eTbecwo0+yfVUJG2npG2+paVu7b2BExVSge8uWnSP3RWMc+8/rGIANqFNb28iyVusvlkYJLq4jbGS9fvH4IYFu4cS3FCEhmv7gi1/YP66svXvfqx1Gr977Zq9LqZ2qmhiMRN7mzq+BLzmb/Hb19WSzpx4m7Fpb2Atck6bsx5hFHomnprK21prjFDbSxgVLCTlMMWof0XrB9q4YljjJi5y2XqFsGQkavAwd4NHjGObFDi6GleLxMMY/5HvE6IUFt313/nz8G95NsNidjPqcGiSE0KQacYhrwDcuzDmx+IxHx2lWTKfAwQPW3CTpT+isBR/+ne+5h1t6eZ+u0WXIj6NfHUgWBcxHx1wT4GW8WaOwDB38hVE60v0HMuzv8xqeEGWDkQz3yJ24DvSGdLzEXLqjTF80l1kBbkp3FcYdnQrMYRmRyX0BmQh1aTBwSbq+L7
 Exti1QDF
 yU4yBXKJSbu+Mly9QJPGi9q3QEiRVcWB5MYY6gqMMAix0uWSY84Sl6+Al2ezec5+JeFO5GUdCF3td9ENkqF34NqTkR3KwKpq5PePKiF1VpM4XSS1TiVskUbEhDZ+W0Gn3AtyrVArCRYmh4J7dpFOGdUY6ieUs02QFZ3thDTsW1I/zS4R5aFHVqt3QiK31ja/kV6KrOdMs5bXmSPxFeTxulcodFTS21Suvw3pDIHFtfD5iPsioFP36hKMGDQivgDg59ks8qxARcEDh0uVw2U57MvMdjeRx/sGacJxScaqrWdodgYbxDO76MyULzdT6dp8dAx2hwosrSeb8t70kKG7VBPpCDvm0HPJfgJFl4i/+ak4wqMZ/saJkXHZYHqN8XoGlLHQKarrGV+fq+uPQAnmDxxpZu1hbYfi1TvC1SiM5+w2hd8i83/IECUoEOEKXYGOYVrrchjDJV7kNVrt0oPjccnOE12/wBVjZBQgzNB67BcDduMxKJ/+xnsvEjYQeHBxEub0HxFoyTHChjGmDy5v3a56PUqPOwZ9ohsuV8Aq4EonrKmL1vUDR+QR1kFYfa2n6umPxZtiQwUfGwZEdetsfYCD1rglI9pfYJn5f37IlNhvFBIxBM4RgluDqrSLhljzFAaog0gPWR3V3aPyanjK4RfDrGGWDTkEd7bNTL1FvMZoc1EbRvAxszr1luc2GiGxfhST7i+4bOZ0pj1Pe+YUZ/iyl+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The userland VMA test code relied on an internal implementation detail -
the existence of vma->__vm_flags to directly access VMA flags. There is no
need to do so when we have the vm_flags_*() helper functions available.

This is both ugly, but also a subsequent commit will eliminate this field
altogether so this will shortly become broken.

This patch has us utilise the helper functions instead.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 tools/testing/vma/vma.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/vma/vma.c b/tools/testing/vma/vma.c
index ee9d3547c421..fc77fa3f66f0 100644
--- a/tools/testing/vma/vma.c
+++ b/tools/testing/vma/vma.c
@@ -69,18 +69,18 @@ static struct vm_area_struct *alloc_vma(struct mm_struct *mm,
 					pgoff_t pgoff,
 					vm_flags_t vm_flags)
 {
-	struct vm_area_struct *ret = vm_area_alloc(mm);
+	struct vm_area_struct *vma = vm_area_alloc(mm);
 
-	if (ret == NULL)
+	if (vma == NULL)
 		return NULL;
 
-	ret->vm_start = start;
-	ret->vm_end = end;
-	ret->vm_pgoff = pgoff;
-	ret->__vm_flags = vm_flags;
-	vma_assert_detached(ret);
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+	vm_flags_reset(vma, vm_flags);
+	vma_assert_detached(vma);
 
-	return ret;
+	return vma;
 }
 
 /* Helper function to allocate a VMA and link it to the tree. */
@@ -713,7 +713,7 @@ static bool test_vma_merge_special_flags(void)
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {
 		vm_flags_t special_flag = special_flags[i];
 
-		vma_left->__vm_flags = vm_flags | special_flag;
+		vm_flags_reset(vma_left, vm_flags | special_flag);
 		vmg.vm_flags = vm_flags | special_flag;
 		vma = merge_new(&vmg);
 		ASSERT_EQ(vma, NULL);
@@ -735,7 +735,7 @@ static bool test_vma_merge_special_flags(void)
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {
 		vm_flags_t special_flag = special_flags[i];
 
-		vma_left->__vm_flags = vm_flags | special_flag;
+		vm_flags_reset(vma_left, vm_flags | special_flag);
 		vmg.vm_flags = vm_flags | special_flag;
 		vma = merge_existing(&vmg);
 		ASSERT_EQ(vma, NULL);
-- 
2.51.0


