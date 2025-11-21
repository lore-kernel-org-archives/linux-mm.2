Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F155ECFC500
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F476B009E; Fri, 21 Nov 2025 14:26:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556A16B009F; Fri, 21 Nov 2025 14:26:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41DE86B00A4; Fri, 21 Nov 2025 14:26:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 266326B009E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:26:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01577130448
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:26:39 +0000 (UTC)
X-FDA: 84135596160.24.503E75D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 95CAC40016
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:26:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=igb4X1S9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Sb50AymK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763753196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyUIK287Y/GxVDRszmWh4NnGh4I17+NXvxgYXAKi/Wg=;
	b=2NJPNHsGgxnqoFnjtZepoIh74HMrPKYQ7PKGjnw8wJLInbR0eSMTfc8kUCoE+i5XNYZ9Sn
	3uB8eaL/2nYz7x36hePdH9lpN/b/+07oBcID6jsp8t+3kWSRMOkyOQDkgkxxiu05enx+Ln
	/zEk2EA3JtbLaeP/yEHq/sNdAXKRlVM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763753196; a=rsa-sha256;
	cv=pass;
	b=W2EvGI3xdBkcIlWq4TidyWG5uhReEqAk/+f5c/Gkt5bjKqrzXBHQ8Odfnu1f/gMRHyLkgf
	CrLJQe88JcOAQgwPNRfw6xVgXV44/4QHSmFTmxjkxChz02wf3KjaHCJiMmynBHsdP0Lp6S
	pwqTzmMsV+HPRuwKw+X/3MY2JFEGm/Y=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=igb4X1S9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Sb50AymK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALEgwoH022813;
	Fri, 21 Nov 2025 19:26:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SyUIK287Y/GxVDRszm
	Wh4NnGh4I17+NXvxgYXAKi/Wg=; b=igb4X1S9zLJC1ZiQHcI8gS2CRA6jDREetb
	L00jARAXljaeBK8AfqEBrBFyps8NwCu3tXGzoT1Od/zXNptztjCqVc6FfaXg2yat
	liE5dfDBTKfrTCz/u9YK4fwR3l/pGRDNASr+bDxOoM13M5714vqk1yNs2pEwKadw
	Tz4F7FGVSEw5LxROIs7274xbzYyk1QhBEg5K1VQaMS7vBWgBqR9BKKFA37m4xpjD
	ls+T2ItVuYiGAvjxlJk7M/0joGU8HxNKQRU85WaCfaYEbBBfZYTMbrdN2VWEejWS
	sT6mugL630m8D2CuqTbIRH4e9L5Lxqr9vmpq36dJXICAyxKtZFsQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbmn0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 19:26:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALHeNQW039836;
	Fri, 21 Nov 2025 19:26:12 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012031.outbound.protection.outlook.com [40.93.195.31])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyrc14t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 19:26:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OK0+ItzFy3qeYzG3HxlpT3A+KfSLFjKn7yil2E58DBUXact05ZH/7UyPM4RB/Wg7Sw1cJJNqiRL55HoZfNnwkEmGoky6isr3Ewi/zWfL6lJmeb7r2poh4Oxo2Z1sfV+M5ZgmuMunkYZig9MYvG8hmpOP9ilVv2nCY93eiH3uokeXMv9/5dAWlUpeAFPVV7fTAgBCjbU+6NUow9NwYT7vbn7VT9pioxxi/plwT1F/Z8e+NyEv955lDh7M80CwIjHF9lv3n124ghd/HkSr8XJhaIPmTEeIsV7OVo7LwM3Pij6gNKObph9+gybQs7+sndQNnf+KWMhn1R7rE89gprq3Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyUIK287Y/GxVDRszmWh4NnGh4I17+NXvxgYXAKi/Wg=;
 b=pMCA6pWvf00HCVA+AifUfaEakJa9bB5gljLpzSgr3dSEHU8mso3Jmn9fsfPv3sR9Ik3aY1jIgiR3mg2apbdkJT4x+/qt5oMKwWtaPCY/p/GJqHCh6YAlxbnSiuklPqZzVjuXVo7eQs+T6kiPggT+Phqc2EW7i1C4WrYCbTGW3hDx/EwLobPOrrvII7m+mVySsl8pvCkjUN6NTw56nu1yLxzQRxXHXV5pYuTN5hWN8NRY7BeSCQ5DFoD2ESMWa9zk8NXzKt0Iuhql5aO0iglUM6Z51odHeX0TVym44KvTK+HfwX1pEF1H9q7RYylD5YRaQDy0e7nknxz6k0s6iANiYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyUIK287Y/GxVDRszmWh4NnGh4I17+NXvxgYXAKi/Wg=;
 b=Sb50AymK/BbIUYb8ioSU42Z+LeI8l29hwxA2JNcIuQzZsC3pRpnC6WksRuGK5Ekp4XB25pUclrPTTmdxgWzxCZLfX1w+4JMkJoeLlBI1wbdZS4t+fk/x6ZcQ+/CGvDHnbIhiWnx4SRpMkwcDMe2YhQ1Cei7bLWP9kuusQYl+ybQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4541.namprd10.prod.outlook.com (2603:10b6:a03:2db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Fri, 21 Nov
 2025 19:26:06 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 19:26:06 +0000
Date: Fri, 21 Nov 2025 19:26:02 +0000
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
Subject: Re: [PATCH v2 4/4] mm: introduce VMA flags bitmap type
Message-ID: <15817b81-c36c-42b1-9a8c-b394805a3a5e@lucifer.local>
References: <cover.1763126447.git.lorenzo.stoakes@oracle.com>
 <195625e7d1a8ff9156cb9bb294eb128b6a4e9294.1763126447.git.lorenzo.stoakes@oracle.com>
 <c82d75d1-5795-4401-92f8-58df6ac8dbd3@lucifer.local>
 <20251121105131.1dea1fbd744587b433390116@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121105131.1dea1fbd744587b433390116@linux-foundation.org>
X-ClientProxiedBy: LO4P123CA0007.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4541:EE_
X-MS-Office365-Filtering-Correlation-Id: af5f290e-1c32-48df-5996-08de2933d13c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lmM8JAUHSjs0bmJ5diQf901SRtPyO85FRxwsAFnCRvoBUtUOwS68lYI2+5rv?=
 =?us-ascii?Q?79L6nLNYsDP5iAoEnUdSqpbev0l6lULQ9g0683Aj1mNSt25orK058jcvTt+O?=
 =?us-ascii?Q?Y2YUbddv6F27mkQd+F1HBofgAxJwX1CyKy1OYqZIjYQQxljTdohua/0V2bkG?=
 =?us-ascii?Q?PzngruJjUW1AoFbfM/X61ibubE6ib6Wu8KeanvwLnbEmKudpnNb/X6scHxcw?=
 =?us-ascii?Q?/CLrKskh1rl6rpFn5UAXCKq4zcv8TqYbceij2lbhw5CiPhZmqpFvzQbrkRsL?=
 =?us-ascii?Q?VuySxEy6dzujEo4H+/TGBEjS58xuMA73eTC1CQhl0suLXZ4ZXKkMH/9kYezV?=
 =?us-ascii?Q?Mvd0sz4ykx2sI23m44G0jVTznZDhoh9iWlzvixVROyrOVcc7y9pww11I4MzC?=
 =?us-ascii?Q?D4ABOZopfBFFpmZ9l1f2md22smD8IjDpr+qMlfUA5t7jmgp+SLa8um0WEpQC?=
 =?us-ascii?Q?nDA0wMBuUE2moONzzOBEf9NWr6krvPXxU0fwEO3hpztzsZvUJHDE8HCPG9RF?=
 =?us-ascii?Q?bh0QNNw6M92QFJV/Sp7P3eC24xOOlurRXpDKdyGgpHOscRaE1gqA5h+JAi1A?=
 =?us-ascii?Q?xgyRjKx+pSN9l3J/9T8NMLVJob0ubkAbBpXo4C/SI4B62Ye3yDUDRQpkY0hs?=
 =?us-ascii?Q?ABvxI8LHR7OToTjoy08oYbmqChxE5cfORBmx2y90tN/3N59zgkqZ2LSwN07h?=
 =?us-ascii?Q?qTFYDbsYFgecMT+rWVkGh/Od+SIgeNKftmGiXRA7bCOs8fyajWVd8nHWb589?=
 =?us-ascii?Q?uLRA6tab9crmT6wM8zp+rlRYV1+nePr1+2bjbbICGo8vItEEz9O+INwOi3vA?=
 =?us-ascii?Q?xCoMoMlFFW/wVJ4+fNSmsAbwV6TofdMpExRVeNsc/w4M3iegiWUQhBlgg1tI?=
 =?us-ascii?Q?yAm1GVaG6b8XHh4cPikPh8efQ/rS3iVnGXp8biJWaR3yAgXj8l1Ut7Cg79Gj?=
 =?us-ascii?Q?Qp7oHrP/9eOW7yTLTObA6kDS6Utmx/q34mDUrsFcOG3j5FdFqXtcQFrH5U2D?=
 =?us-ascii?Q?7Cmg6dYqhAtDgELpbx3XGmsLyNk1t6FoK+VPRbWjyg3rd/dh+zxFKIQabpo2?=
 =?us-ascii?Q?RVqNo9/Ud+RvesTxc7Yc6BCg4wZA/YA1EQYw8qeK295To82DoFPEMyiwXxU9?=
 =?us-ascii?Q?uqLJsf7NlfaLsX7oDtgM1INWyMdvBnFlWCAMPbI1akriBpwuN6fVsf50F+Im?=
 =?us-ascii?Q?DPw26oDGAVzzpENwO/iidZvfGKfiqnniM+VSQgAAvO5xqRkjGFIOuNB5wqjf?=
 =?us-ascii?Q?Yzd7dMBGZBbnY2rOr/MTJry+EQOKCcBvsZeXajoPelkXisvQa1MeVdPzIbyu?=
 =?us-ascii?Q?dLq63nhIN8/xKb3SvyZy67IHAP1lejOD8Czi54zD2PsT89QT6BskEiGawRgL?=
 =?us-ascii?Q?gk+ADDhPfNZLM9q0uxKjAEFW/CIWQxSAeZjQQ5knrUb65qUB/xb11aAHt1/W?=
 =?us-ascii?Q?6jiM7v+H1NGhN+xLwJgFv3Wg9lBC2CeN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/kBy/V7VN7n2LSTF/mpwtq6La6H/fx5LHX01/UQuGOWYKjNjWNIolxWJ27h/?=
 =?us-ascii?Q?Tr8+cDRqK6BMxc1DPiTcZiVtHd5bW1IISYFP+7ji+9vpGUsK7S0mZJjq4ccm?=
 =?us-ascii?Q?gm5CJascZ1kC3so3p5rFCd926klUGPH9ixdQR1e4XJ9v6sjLTKw8DteP8bVn?=
 =?us-ascii?Q?p5b1r0s//89duU0itstTHNXyzQFMnqaolWNdtI8ksBcScOkZpG1TswPp+wnN?=
 =?us-ascii?Q?QoEPfDLSbDT3K+aBr0fSmTGhHN4Uw/eMN3XQ2aV+mUukEP97lvoRz5FWC4se?=
 =?us-ascii?Q?krhJ8iKxj2GHPQ8Q48NnbyMvnHe8NFzx1qeLF7h0jnCN//wo9QWOH72ItK3D?=
 =?us-ascii?Q?lWPpCqICzyAqxEDEDa+kllO1YvFMyDY6zTWiI5MJheGBOKNeq64d8/U7Fzeg?=
 =?us-ascii?Q?yO1qCHCDBYR6g6GKUkdk/ZzMj+r+jlNsmxXXx5qGPGleox7ih56eNKGwYMAU?=
 =?us-ascii?Q?/okiJXeqn5swqWDZ6zMT3LoQtM2+24/j/uP0+OfKilUWyCo0wzRMSeMrxyMc?=
 =?us-ascii?Q?B4lDZbqR9Ar5G059KHLwpqbsExenW28kPsHgE9tvmqcPLLyg3zOzPahhnEdE?=
 =?us-ascii?Q?RjrNxP7D4r7qum6MA0f3fTTnOiVY/Jxjn240eBFsYspbfAV9IsBHA6geZxB8?=
 =?us-ascii?Q?A7jdy1i+gnDzMs7EgY+so5gwuxTEklNAp88g9fgGdgd66bZcfaz8mQiLlqoR?=
 =?us-ascii?Q?nRTLIKKQyUjwumeG6A+e7nJE2+ES/0L1t4Vckq7EKIeSEgYHczKHyqxs6DQp?=
 =?us-ascii?Q?L950EiPL+EXu3oS98tbyMN8kQgL29/q9lCcS9JKGYeqVCCFv21uvk1dDm2Pk?=
 =?us-ascii?Q?XTjugLlEfkrW/yLbYQJ4OBrqMSX9zpZEnxy/6vc0kQl0kdLHgMPdnQ0Fhxvc?=
 =?us-ascii?Q?XB5uzOKNVQ03wJ5MjO67yxYEgPU7ivsiha59CwVW1ebkYh7ZsxkGKfilpUE0?=
 =?us-ascii?Q?LTA9Chs5xwOgJZj1Vupn8VU8xE196PVARSr89d7FODCVg7T/Qhwt4GeYwg+u?=
 =?us-ascii?Q?M2btFE2io4WhridTZg+rkIs3rIeIQDOMdoBpkz7fvrnRtrI3afi8J8Z1WyS2?=
 =?us-ascii?Q?dSPraJjgcvhDQaPAY/E7sT7Cw4Hl9sllpx5cownxCHUoZW5W6kgpbToYVyWa?=
 =?us-ascii?Q?lo0C8Jyk0dXn5Q9PNv7L94osIsrGzPESDJFQV5cLhf0b3tKhbxvTKdmppQaq?=
 =?us-ascii?Q?AGWM/tipNOvWnizxuXM5xXqe8FqGi3VQGzLVXHBKJ38m3ZiuUBFxsnFu4aH4?=
 =?us-ascii?Q?VnCyjk4VXtyDTg0123dx2r93GImBuGGJL4xj6eT+InoxDXtTZhOM62J5uryI?=
 =?us-ascii?Q?wYaAzbbEYtthPHr5Ldz1v5d+9WuByfj1qSY6/ojCj3HDWBSf2D/KJbdI0YbA?=
 =?us-ascii?Q?mcbVxUHqTJHrLbVP4rYNYS3g/Xoa8X7D85oNxY8B+RoDvsJPpvbp+hg+BQts?=
 =?us-ascii?Q?SJMAqNVKwC7H19oL9fzFCYpyeYlGWMQ6GGQv9hBMCdyVjJXC63C+RIGAZXLi?=
 =?us-ascii?Q?skXAddAdCzYzPiDTsFCaoQofpe2NyQjHnLQBSPrlG/lu22AKtD65bCv0sHwt?=
 =?us-ascii?Q?gpHxxo5VhHmY4nJD6NiqliTNQXkvuv6VL3BmA479KmAHW1dx1vjTpUuhAxH1?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IgPQFcXtTcCgzBwG8nd16MrAMpLDXY3Kw1yOMi5Gf/XZ0QFbAYPpwviV3+280DyJI1e+tKeZ2tjVZOnytxlNcobGqQ2O3wdxjtrhcj4bHMepjotx/VBjPN1D5Q2JzCW/n8kYOkuKwU4wpF3f3LBQb4k1rCWWqjaHsNrBsDTy6ADvYu1RJnXCJ3UkWYRt0yaUQf6fqR7hUti5To4p/+r9XU6Sdb4CBf57J8WbHUu8+RfEntfvYm6/Z8Gop8GjmZrryitJ8ZBPIBH6yCgJyV5RLTu9DJwyDgkepXQMksoP2AoiX3ZtlrUehNC5aiDshbxX2ySh8O38Vpe2P2pFHpTDrKfIygSMIte1yaVhXZ63BEuMEOiwrpnfcc2+AdlOZ8nN6QpdctXpjEngQAiT8cCI6qAdZ3A9/yTuypC0eGRJ+fDFn3MlfR01ypBISKCuEs+Yz/GUN5AYBi877Q+pTAK4FmDkskz2B9xaGTs3R2PxOHhYcoOqoO/sDEHusFSXu3YNrhWioUx8kNB2EH+/yTR7smPdPTlOGpMVJGUymVs4G9SRKTZfen3L2f1ZXvL82cAXV/J/TkNMcCXuwz3dJTr3kt8HEbe7j2w0kk2bOFTaXGA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af5f290e-1c32-48df-5996-08de2933d13c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 19:26:06.4370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCB6iBKHVkw5SEAsRTifhZ0V7kXAuYOdJQIk0h9ronkYFUie2S4x4QsusrzMKSwYUpXZ1YZ2IOh/kK7IizTcj6G1UnkMaf2uBVoDw8xNR5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4541
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_05,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511210147
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=6920bcd5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=_x31dzYN4GugQ5JSwxYA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12099
X-Proofpoint-ORIG-GUID: 8d7RJpT6QU2_4ysfeTWTTNGTEnr-YDJ0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX+0j2UN2q7K5q
 RlGkas3gvQEmmTzeDWVDkw0t0OQSoprpsgCuC3r304JQKviUBERLUUowVaHQaNAoI7MnEPP2oYk
 0QEptnhGLzrYxSZhMuso0HVXu/TQhGD7QMXu/MQ3T3ekhdYY/NFFu6ZKQGvB8zmcylXQ3VrWeAw
 Je1h+pivMrW5TZ+TWx+aKTQ17/7zk9gbzCnFdKOX1Fkbro4qIE2qQObsUy9b4p0l1CBrpG0HWpC
 ob0BbYNmiKVzCqknKhcfCZEPUGPTEWmyxAZXEkLZK4I7UKNjv/Q7HIrjdGzBPB/XYFD5vL4ZP+G
 xJVJGvwxqfbYElYAs+L5BNhgVl7wZIR+Qts8r9d1xTsBVrQISUS1ZQydFxIjHExBH50pyEsjIn5
 u5cxG24XMmVBA31qaTjfTM+oDcK/qWGxEoaN7lzBEKFCLFqty4c=
X-Proofpoint-GUID: 8d7RJpT6QU2_4ysfeTWTTNGTEnr-YDJ0
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 95CAC40016
X-Stat-Signature: 5mg7stgejbojj7d9de53yzumteepnkwx
X-HE-Tag: 1763753196-790983
X-HE-Meta: U2FsdGVkX183dgDt7rh3RC2eBdOLr3+3zHhGmbo0CL63ujmWl42Nz2NzlbD7YylpsOzh2CZmkqf5QcsQVGcWZqrsAksN3pSkjoqid/R5mEANKqQkTk2lUShE8QvYs10JXD/SLZsIKvPyp1dmYAOnQFJC0CTwHaGUpTRv7ta1IURdJ5YNLFMOAelN3Hkszdfmc7ZqF0lDifbbqt3pwZFFTCx/0dmICXYzym3fKMJvgJAoI3Ci/j/0AcZZEWiptwa3mu0AUaeAlWS5Jw9cu9vo3oriypzXIRJ7Whxm9VzvZ6xfKdWpgRlKmUWQAq9PUI8FukxDeO9sZ9Q+P6V2OCKt1GFv7qwwVyIxNBI47u42WZ1TsZ+GHg0oYK9JR/F/mflMZLnFlhu9RqJihXgfAXPZANGOLxo8NtyIhC8v+Cb0nUHgP8VRTxzUVwaPRNd3Ehv9BbkVPBfKnttY6nhm8R7lcCEemvx5EnZqra0YReTfF1H/Pyo3JBzqewr1qg1tlXrQrtuYfGXqpdJ25Slqkv/VCy0Cp3+bbjlnZttEcOO1T9z80wk3tFoCzW0cIKE0VJy6bqWMaAN7bjvDT6GN3dfeNbhNgcTMExBxAWNiWk7oP/TFUt+HsCFUXHYiqw7jwBC1Rus7bHwEKWxvKun6a+AuvHjNTmuQgA9CgRx0svME1Jf1pZSHRPYMLDOOQbwsWapB57GgWgyfh1Q4vh4DghaQrmlWP6j/1B+2YTBkb4nYkXl/SvBT8Fus/fyBD1pUj2ZA7+hUOCC56B/1AHOQ477/cPsA60NdJPLgaZbfzx/xAANI0STPLYekXzOqe9uRq7H72Xw2F+t2ZST0V8hkO4mzXxipNepFrNODYR36tn5qNorWdK2DwhIhIPJwU2VGFVjUWIrJm34G1XcL2+1UdD2LCyBHjaViqd7xEJAyPEIaSv02n8ug5ndYOL/HkDFWyfkp5OkTEbtwkW25R8M+jyP
 kpwDofws
 tgtvlaZgqBLRGt16NWeVhMPQwdkSxPN11+JgO906cFhFnT5VHF74iobHhoTAdh4chm1jkcO2ppRQrvtKFT4hnTuVmwIxW8N+0RCVfjeXkWLStysAxwXOApbp0YQRpKmuvgI3Ga9JBEIsT8OfkY3CdGvEPPNExrtONCEfgncdbNytDk4uWvmhbhTRrlFvc14ouWklO01UNjwpFsTN9Maca/Opqn+EA5EJLIqkkI6q4nRgRHtIp2YJCDivf0Yubh0Zm1F0ABDP2sllAPuqqkZzP/M9AlnTE9GWv9g+VGI3XZjcNsJu0d+FsH2zSnNPHe5PNYunQbHIceT9/twWYbGTf5atsoDm8YdDhwB/Xlr10+whLZHAFWClOIJyzoyHU6JJIT0iCzBl+wEDW66CJkyOKgN9qHmT3/rM5WKHHmqD1ZNwLKuZCDsaxZNctYYPp/G9DaXaWy06PzaDE8jckjMd6HftlenCBagzQkueFmeFnvZHHxNP4frjq3eZVieIRrGKzTVBXZrBvmVaf+UTIln5RSx57zl6jfeJDf/w48ZUXlm5s15BPJT97MktkPUJbLsK6rY1kHmwVVPKaoEXsCmwO3LtS56BwW7W2AAB+znaRZvmTq2TX/S/OdWdX5BQZbEpiDtWbf3HhOqL9tjfHVsp5i/T/RagKe5NNdaANbYHY9OOXLZCN1lBAl1WIYCt/nXmWyNugXt6uYdPtDBj1go6/c60KeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 10:51:31AM -0800, Andrew Morton wrote:
> On Fri, 21 Nov 2025 17:44:43 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > As Vlastimil noticed, something has gone fairly horribly wrong here in the
> > actual commit [0] vs. the patch here for tools/testing/vma/vma_internal.h.
> >
> > We should only have the delta shown here, let me know if I need to help with a
> > conflict resolution! :)
>
> OK, thanks, easy fix.

Perfect, thanks! :)

Cheers, Lorenzo

