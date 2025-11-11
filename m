Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3616CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 16:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2A08E000B; Tue, 11 Nov 2025 11:20:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3500E8E0002; Tue, 11 Nov 2025 11:20:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F0F48E000B; Tue, 11 Nov 2025 11:20:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5088E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:20:40 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5B8FBA73D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:20:39 +0000 (UTC)
X-FDA: 84098839398.12.F580D97
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012043.outbound.protection.outlook.com [52.101.48.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id C35FD8000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:20:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kHn6edvv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762878037; a=rsa-sha256;
	cv=pass;
	b=IiHrXV85iyHPKYdvkpDJMYD3k4H9iLp5/aNlpMcelr3DBY/xPGTYT1g/lXgv7svYVru5aT
	1GOPLdmH/SPoGurdDihpMJI1fZzMlj49QjL5uiYnJLie7Rz7CvW5uqcz2cDx5HjGljRJtf
	2Dmvr76lTu9Rl8fm6tu2ku/TSlqueCM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kHn6edvv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762878037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIRYiCcoF10jB3DeSfNBtNvtAMEsy5fgqZCLZAbNohg=;
	b=c+tp0DuEqTd2dtX/UzbimUx1Ntg6Z/kGB46u9b8umzdf1n6RXYL6sdri7KILXt8cuVXtLm
	C5vBb6NwAfCv415XCk+WJ7WglHxpVdzS2iq8QVxlFot2eO3mJcr031e6seELU1ROHl2Z6k
	SlfKKZJUZEDAqR8wacLpc/eMebhZee4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=heAqivH0CDuId9ukMTZKX/zOer/CbCBDLp1EbD93MI6i80xi8daFD02PkEgG9J6ss4qqVvlygvp8/9xD45y2ESno7KuYMFs2ZVzrOn/ZiKF7B6EdO6aMAVevAKrlg7nfbXIkHieYFB7cdJ6KSwMHmvpec8oZRdtoeDKxOlu4YRxqMfmcPALKKVmG0uEtAFpPuSEaAeUVPMnvOJ9wOXB8x+YnFmVkavvQXTLRb+/IoFNlTMDTp7PqxBRI9MDD5Vtd2p1UOJHwqSEX22D7DKAm+nlwMAPcJCRqB7KLqKD1m3WAYpsFp1SbS7am/lcfNlsdyz14JiNLidNnkoTSiYzJRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iIRYiCcoF10jB3DeSfNBtNvtAMEsy5fgqZCLZAbNohg=;
 b=nvyfC4g85+MxAVCqmXPfO7XYZSL0vKdaQydVcM8sm0Xnn+rbzMm+4D5AKXelTfYivjAXUlQsjkFdaZFfApXvXoB8n95KSF/H4nm8tTrwpBjVQevw4lTIrLhChBs7MeHYIXd8YdVPwTSF2uip68fJQhCive/o/YzTJjSPxaVkdVPKZxJP3s6Wi10mFZ42mL0Kq0NU8bcM5kneL3GeBfvRltvV1lGmHISqEddXaQ+UnpeM+kE65p3WTPKqWoR5irmunfcYkCW+gjHijVIVtvvF6KhVD5OzQ2lrzkcX/jjsSdv8VfuXvspaGXNvDx7gHmdB557Q7F152ZD6dtICFCvmFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iIRYiCcoF10jB3DeSfNBtNvtAMEsy5fgqZCLZAbNohg=;
 b=kHn6edvvcIlB5NjLlyTFeRDfGCFbes13FttT+tMIFSaMugZchYZHcmXhxPIOZQZXYoSSEfumlqUUE18dmzJDnrZMJYNxzyiV1JHX9qdtSAopZWpwA7Q9gSCAXTNlR31PpBRr1QxOQIxG16JYuk8el2ObhgNeeqiWEwOfvsnbpg8fdJxVp8cjJArdxU6i9q+wqbNsj64rpsgHvvcw0KYpB81hG3pFgWOf++ZLX98TTzpj6OegfYFHsMzb0D9R+9adXdu2OL9FagxvqK7iHzsgagf4tH7vchWuQ7Q0VpImBJ8540eXb7HrINsJJcvWVOF1wB5vi0pygIp3k+b3Zo8J3g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6010.namprd12.prod.outlook.com (2603:10b6:8:6a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.16; Tue, 11 Nov 2025 16:20:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 16:20:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
 Arnd Bergmann <arnd@arndb.de>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 02/16] mm: introduce leaf entry type and use to
 simplify leaf entry logic
Date: Tue, 11 Nov 2025 11:20:20 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <B9351A0E-482E-4363-9B67-9392131CFA6B@nvidia.com>
In-Reply-To: <66b35154-860e-4586-ac30-160e688e1bc4@lucifer.local>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <c879383aac77d96a03e4d38f7daba893cd35fc76.1762812360.git.lorenzo.stoakes@oracle.com>
 <CBBF1711-5881-4B5A-ADE6-1D86C0E94296@nvidia.com>
 <66b35154-860e-4586-ac30-160e688e1bc4@lucifer.local>
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF0001640C.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6010:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ef0f9ba-aba1-4234-6b66-08de213e396a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1O7lpymfOUryEJzwzuJmHqIE+TIQq+ZSOhJVjYrh/gkbYnVlYHniK1mqq6HM?=
 =?us-ascii?Q?bj9Wg+SH8fgiPteSDr2FTXjCFcaTtY71FzwbdlpxvX4hLA5amwm8iUjmsKry?=
 =?us-ascii?Q?qIR7Zr+PA6qEfxsWp+kKB/tubqNGU8cv6D5YSlo51SP7S911niidBwJgpbXg?=
 =?us-ascii?Q?QpQvxPjlz63HLLZdTZVLxMyntzSrSwafCxoECC7Cs1c4Cc3yUDp/eQROpj7j?=
 =?us-ascii?Q?L/3cp9qYfRlA06o/QNyKIHsf32VnHeqK1w4wIYcwTUEFpeg8Kln8tO2GVkOi?=
 =?us-ascii?Q?AI3vXEeZxvheizvyHhREVYoa+N6xfn8K2ZBJFYt3qRHcwIZnWueeVD2Z1SLy?=
 =?us-ascii?Q?ZpzTDDIq96BTKCVvD+YhCB+bOJdAer2Ze3eWM8mDkAvN1oJUoam1rGHndfHe?=
 =?us-ascii?Q?io/efr4qw43vb5bLu1YwmNwg1V2qc+PFWi6c/Ahxuwb8mjFWHwOXtan4nq6a?=
 =?us-ascii?Q?6LS1vUa/raY9aOx25/rVzV5KWncbZhvOEkw2Y8JWSbdfZj0QX+yI6d8d/zNk?=
 =?us-ascii?Q?ytAeEU4BiYeiAOamGQH788W+7tNS95CLVqYkYHU7UH6heZVvJ9gV0oRm7HiC?=
 =?us-ascii?Q?tLaE6/gReO4EnFBuMDwX7xGP520HzTmT2uy93gYXmmza0u88ktiT6swRuAu+?=
 =?us-ascii?Q?H5tTKudjP42/L2fQu4U3N22BaCuy6tT4hByPATcxqzjJ5wJRn45O42SgAFkI?=
 =?us-ascii?Q?VHvU4zEYFz9ezMBA5U+7ge78JvNTBJfIoSLxz8B8lqZSdf32+Jmjh1VwNXMt?=
 =?us-ascii?Q?JFfc1oRWSJWRXYjSCNa0ud5dAJhcONSOeg/8NFsizKlywJ3XtFFTta5Ox+Rx?=
 =?us-ascii?Q?Iw7NIloDl5Xuvxpzq7NpRMw3RqR+I3ygyO4tNksTcdtbtTn388vk242GBKZQ?=
 =?us-ascii?Q?4/GZGgVlC+GksULZH+TQr6M1jk5Cz8QW9Bt+5RFq31tdiCRkJmp8ULGPJcV4?=
 =?us-ascii?Q?1P9QrT5J0k6OfMgTnWraFFeEW7k5C8CtKDwV49yuontG5CKFkmBObPX/1UFy?=
 =?us-ascii?Q?qX2YP7Mub5I19n67R8bEpTuQUxObC3fK90emqRNbauHU0r9+/dHRcZ3C54tr?=
 =?us-ascii?Q?zvZzu1Mp9ETcpb1yJb8c8mUwFyT6ACHNcZU9ndTUgBfDpm5y983euk776u3w?=
 =?us-ascii?Q?s80TAKRQqw1jIn8JJnSkKXzwAeCSgsAJ2wW/EmhuT69mmUSm3xD65uRaO6b9?=
 =?us-ascii?Q?wNiVGhH3/eztWJiD6mIfArigz0OPjT21HwJ0FjQ1zJisSfTFTXoXFQW6R3Be?=
 =?us-ascii?Q?18Ug9E9BgW+ctXgo5aPv2/TGjrBhI7Fnt8J5OpUZ3Kipoj2F0r5QQ8mYmEhO?=
 =?us-ascii?Q?0kpDAG0R2XIDxl8/QnB3VafFhksTBiQW3ZJTetFHwta3FFfU+hZIkGXiR/v3?=
 =?us-ascii?Q?Z0ay2PAFfYS+KxYFAilmZmy5LByX/W2uBknkAkgBdo0p8kKtQkVOXcq801Q9?=
 =?us-ascii?Q?qdGJPepP5dsG6swwpjK/M7IhkOlUScbq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oW07Jlh9PaWSi8cd7ecFV8siSZ+4FtHYpyjdLUT7BR50a8OEl4JPRH18P3kT?=
 =?us-ascii?Q?XjKE9Fslh7PJqRpwQ9mmrXREQCKnbJlJoajL2bzptLdr2t+CG7pMQz7ACcXB?=
 =?us-ascii?Q?fonFzgDiqj7uwTCBiH/zhN6NyoimQ3HQb8rFQ8iq3RkRZQq0DS2gSMxKXMB3?=
 =?us-ascii?Q?RggBJLzb/mA7okLZLnE4koGC83LgeOVgCjTDJNnNN8TeHmDQMRavv6zoHEle?=
 =?us-ascii?Q?nJKhe9hs5ZKb7+AqwjOW6eAMxZqYFg6xpHNnW/YkJXv+L0KNivTWsRpqfb4e?=
 =?us-ascii?Q?y3p9JQMbfNFeCVSD/G4Wq8/NpFZI8oUdMKy4AAHcPCcSIm3VPtJw1myl1bYY?=
 =?us-ascii?Q?X/qJG0t+d0IOWWfgc5dfcmgNny268Ch+GGVRwKE0LVsV1uSgwAeoqUGe19jN?=
 =?us-ascii?Q?keFabag9eEuxL4LEyROTwY6SZshGdwP8/hxgkJ0JRLiJClzQEPPM4TuqgEq+?=
 =?us-ascii?Q?gKd/Rez+gJ1+iKvVp1rpczR32NKFiGWiQP4I1aMWSNo6F2cPqLZrJ2aDHww1?=
 =?us-ascii?Q?cZjWZpMMIm7SWNfKVNBTaXG9yePhal/dEpuCcm5KwzwtX9FnIf1Fmyvmh9nh?=
 =?us-ascii?Q?MvJRwiGcBlK7+6G08zeA9wKqXLlIs7zR5U6fXTuG1a5cBgJFCldY6miCJ8CP?=
 =?us-ascii?Q?Wc/mvBmkk3RmxOzdHmwTMbgdZQ977jmVtFYtLbywouZ8Od7FSKP8jb6KwHM5?=
 =?us-ascii?Q?R1w4uvB/kKfftkA4dWobhNUqrRlEZ8yXeNWuqkEDHf+LiGEba5PyO2mO4Pfx?=
 =?us-ascii?Q?zVFPFuZDbyd/fARj1TTMO7p6gxBxDLAbm/Bxtr5kai7YzybmYXAUvVkXWy1b?=
 =?us-ascii?Q?Fa2Npm4RbYjojhPelTNSC6y8upYShAOaW92YtqCSOIBV3E0k/9mIuXzdtxt1?=
 =?us-ascii?Q?xErqTdVXzagXASqX29YA1cWMQCzHKee1Y5z2LP7gx/xsGH6U46hj4CegRD1r?=
 =?us-ascii?Q?VTrgRax3pxm44yCGZOeLSflOvQiOFKVb8mCkht0tEZkkANWgh2NNrQAPJHot?=
 =?us-ascii?Q?MizUWLcD05T8p0n1Ja4mvy/N3DFoJPT3CHsFoeQH5dTcnZ6zWJw2SdO8UYvv?=
 =?us-ascii?Q?W+tioAZhDDeEnzzr+yQ2bYQgvYikwegsmAp6hJmaoqf3pOOxoTeCBPuRIuig?=
 =?us-ascii?Q?9qVTC1I4bQfBCLDgdpjvTOe+30aCizv3LbvrSRILddFGOX2HAa6/KlSwbJSU?=
 =?us-ascii?Q?za3eIXphmY0iuFf6usCFZOiLXmOO4hFukLlmrl6blfYDWD1JY3p56ZA11e0k?=
 =?us-ascii?Q?k0DLdI2j4tlzwEcHq+KAE1gbIcZ/rgb/pYclNZytAtQ5hPF0CsOQiEO89Wj7?=
 =?us-ascii?Q?fn4Ge76kXsHfKrkSExoBkrR+T3bkP86auS915wEF02EKvYXMUT4LmKFa35kr?=
 =?us-ascii?Q?/7G/ZNuhuveZwXmdDzJW5XlNsKr9UFo5y13Xzj3qK8o52xh//aQD2i1h+4Fj?=
 =?us-ascii?Q?A7QqeEbi3DMZ7aJh2g/j3ORyrumEKCwz8BB9DoEo/iJ47L0j6bgnlIhCR1ds?=
 =?us-ascii?Q?GQaJ6sb6/EK5DDmHbGvEwHZvu5zILU7IA8Q6/hBl6r6h9A4ymsKYQH1Hnz17?=
 =?us-ascii?Q?fjmIiItTjqMxmycKkPcV/gCdrs/km9HidOl7EQS4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef0f9ba-aba1-4234-6b66-08de213e396a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 16:20:26.9743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 84lOTbEq2OJhSHMy6hO1q1BmS6EvvohdB0X3EIC8m+DFNvhMQJMg+zbX0pCYsuJz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6010
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C35FD8000F
X-Stat-Signature: 9z81c9jze7zzwb8s5r1zey7b5yxq8ruk
X-HE-Tag: 1762878036-263079
X-HE-Meta: U2FsdGVkX1+M7xN1tDtbi1wMKdFERaEMaCZlw2D1F5MEOez/h2DGtgP6tfiYG9JtbUKDQ2SR3WV9p3b6fCD+pSxlQJ3YNgtynIn2EoM3PTyhBcTMn2p/YE3KjRqsb/PxrWTicIza0s4gwoAM516qANuFUS3ozXiMlQ3p8vlWwt5ON4Vq3Ed+oqvyWegUL1o/yisD7WYVZdxJxNRoumDSvssrv5xOhsGh2ym7MaR1wfUmTB0dL//SQ1EQdP/xXSEfVUCPXHG3LeZ+Bne4hXVMGsePFGU05OxGj+woeCPGL8ER9EY06xjwE8/NaplBLyS/tqyRDfBPBNFW6NZF7ixtVsE2Ba9QWt10Imyw3V6dffAWzaieKvApCLSWIVUjCVh7xjsPta8wQhXMvGNGR9G1i/grAyaorJSzlIdMOc5xJ03otsevIUbrUenNa5g0upAh+B9bjMG8kMR9p6Uf1tLqv92exI5QYUeJ7g2+gbG25n4V5OhGVPaSiBMSD5E8K/+UsenYa2xSWzsHL3z//UevsciGniejTRPLOllbUaPS5iuxSkBhPqoRUcTdInkywxpb+1tKrOxfpubLNbqHQpYrKxGnqJqHdTg3B64a1c26HJ6D5ymqp/EZw2nALje88kiFHt5hwXqvIIwwYk9Bo2AgldXp8nJ+qpxmcfV5q/uOqpvdn70mQmHKUkS9TXfirKz/lFKnL97+2W4ncYF+vklezURf4NwtxdlVdaxEWRXb1pDN4yGW48BpTuQOocACWbstk8ODsDf9qWYtBoCFcRjeFHVrzeSwfeHCdx2eDQFga6FJFtncYzQvl26TP0+5MxTUTlFkUZE6nEQvISFvDpf4UzilGVUKVHyv8uahR3lApETfJepOxV0iUbFGD4gGfTItE1YjXcU/VDMP3AlSVmIvU1yrTj4HRxCoHKeKdb6tns5Yf9VLQpGRpQKmHqkB9+MwJQraSyN+wTtfdvlruPl
 Q44lwY51
 Stzivw58uy+jr7r48WYKvp+VUCWiB/MtSVB48wyez+iv0QODDkWxiMB3COyFKrIjxxdIMHjmJd/N0SCoYt2tOEHOQtaCkZyok+JeX58MVVkCwIlrgP5yyzlCXTybDgBiaRpMgNFF1Na64qyhSuyktAuY02RL0AQSgSDJ7+RCKC30m1/Vtirm2cU1GlBmvRXI8qlCFUcM5ajI2aoNSnQCxRl3fPhkH2g0hhPe7+0EMXpLVExjOxiRgqK4QDNiQUBQCdDrJ2M68txyGMhrg/kPYN3P0kU880cQcwF6SBUHWK39v5FwR5+vXeAXUIFsavv0z+qk81WbkNFCgnBsClT6xh+KVCuiZqnGOUbonmjzMQKag6YJwdO3Z4/iwdUjZecrIv+rOZF4dIDEIOUU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Nov 2025, at 2:16, Lorenzo Stoakes wrote:

> On Mon, Nov 10, 2025 at 10:25:40PM -0500, Zi Yan wrote:
>> On 10 Nov 2025, at 17:21, Lorenzo Stoakes wrote:
>>
>>> The kernel maintains leaf page table entries which contain either:
>>>
>>> - Nothing ('none' entries)
>>> - Present entries (that is stuff the hardware can navigate without fault)
>>
>> This is not true for:
>>
>> 1. pXX_protnone(), where _PAGE_PROTNONE flag also means pXX_present() is
>> true, but hardware would still trigger a fault.
>
> Sigh. I'm very well aware of this, I've commented on this issue at length
> in discussions on-list and off.
>
> But for good or pad we decided to hack in protnone this way. As far as the
> kernel is concerned they _are_ present.
>
> Yes, technically, they're not, and will result in a fault, and will result in
> the whole NUMA balancing hint mechanism firing off.
>
> But I feel like it only adds noise and confusion to get into all that here,
> frankly.
>
>> 2. pmd_present() where _PAGE_PSE also means a present PMD (see the comment
>> in pmd_present()).
>
> Right, and here we go again with another 'wise decision'. That's just intensely
> gross, and one I wasn't aware of.
>
> But again, I'm not really interested in asterixing all of these.
>
> 'As far as the kernel is concerned' these are present. We have to lie in the bed
> we made AFAIC.
>
>>
>> This commit log needs to be updated.
>
> No it doesn't. As per the above, we have literally decided to treat these as if
> they were present in cases where, in fact, they're not.
>
> Note that to be thorough here I'd have to go through every single architecture
> and check every single caveat that exists in pXX_present() and pXX_none().
>
> Because I guarantee you there will be some oddities there.
>
> Is that a good use of my or anybody else's time?
>
> I think we have to draw the pedantry line somewhere.
>
>>
>>> - Everything else that will cause a fault which the kernel handles
>>
>> This is not true because of the reasons above.
>
> I covered this off in the above. I'm not really that interested in adding
> additional noise here, sorry.
>
> As a compromise - if I have to respin - I can add a very brief comment like
>
> 	* Note that there are exceptions such as protnone which for
> 	everything but the kernel fault handler ought to be treated as
> 	present but are in fact not. For avoidance of doubt, soft leaf
> 	entries treat pXX_none() and pXX_present() as the authoritative
> 	determinants of whether a page table entry is empty/present,
> 	regardless of hacked-in implementation details.
>
> Note how _already_ saying stuff like this adds confusion and 'wtf'. THis is
> what I'm trying to avoid.
>
> But if I have to respin, can add that.
>
>
>>
>> How should we categorize these non-present to HW but present to SW entries,
>> like protnone and under splitting PMDs? Strictly speaking, they are
>> softleaf entries, but that would require more changes to the kernel code
>> and pXX_present() means HW present.
>
> No they're not strictly speaking softleaf entries at all. These page table
> entries use every single bit except present/PSE. The softleaf abstraction
> does not retain all of these bits, and then it becomes impossible to
> determine which is 'present' in a software sense or not.
>
> We categorise pXX_present() leaf page table entries as... being present,
> even if past kernel developers decided to hack in cases which are present
> as far as the HW faulting mechanism is concerned, piling yet more confusion
> on everything.
>
> We made our bed on this and have to lie in it. There are numerous places
> where in page table code to all intents and purposes it looks like we're
> literally testing for hw-present entries whereas in fact we are not.
>
> So I don't think it is beneficial to do anything more on this other than
> perhaps updating _this_ commit message on respin.
>
>>
>> To not make this series more complicated, I think updating commit log
>> and comments to use pXX_present() instead of HW present might be
>> the easiest way out. We can revisit pXX_present() vs HW present later.
>
> No, there's nothing to revisit AFAIC.
>
> I'm not going to go through and update every single mention of faulting to
> account for that.
>
> I think it's an unreasonable level of pedantry.

Got it. As long as you are aware of this, I am fine with what you have now.


Best Regards,
Yan, Zi

