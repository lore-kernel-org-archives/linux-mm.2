Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 109D7606AC0A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=U5QnF+x+
Received: by kanga.kvack.org (Postfix)
	id 76B9B6B05B0; Wed,  4 Nov 2026 15:39:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F2EB6B05B1; Wed,  4 Nov 2026 15:39:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596166B05B2; Wed,  4 Nov 2026 15:39:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4276B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:39:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 917CB4085F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:39:34 +0000 (UTC)
X-FDA: 85398602268.04.6F67CCC
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013036.outbound.protection.outlook.com [40.107.201.36])
	by imf23.hostedemail.com (Postfix) with ESMTP id B9D6E140005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:39:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U5QnF+x+;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793824771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DR1g0Q8bCtJw0djR3dMfoLeXmAkZYDMtyQM9I6YDmHE=;
	b=uCUrJP0h9Cxji0d+pV4q0FxncObWDjYr3NEFGB+BclZcDz9xre1GqflakAoV13IwsWNIQk
	qjFCLLeUatrKBmmMfdbe5pmsqXcgoEEeA+ZGyC1xJmYNEgDtHwZPLODUldoUOdRvBDFF2M
	fsh+IMrQnwcfnIyHNt7VX+NQEHlHn0U=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U5QnF+x+;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793824771;
	b=msQotQ8WftQaQJUr34WBJV1faM5VDRI9oMKKJxzd2cLzx1EroXQ0k/OUcJTuqenrEa6gIK
	Xi41O8qm6+dIaFzdkqPj/1g19k7x6msmvjDU69TgDgJzLcyfip1AB+V6JmlWcfEhljjm0O
	h/cGSSNqXYSccsRyObhhFoDKCPjZszo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lwxEXj6BMVLyMH99aul9fFdUy+Kj/FCDcC+pm5lfrWmHiwH/KbPa27hSy8Zue3UOpXk7GCiQ8LEF+OwLjO6WZHKu7zWxNVvxT2GRg47GXPcb+XjyoNeEfAmMqr02kojBoPAwVK8cClQi+wtImk+DfqzrxJ6ZGE8eYDG0YuWY+VzF3QRtfSfwhpf/QPhqT80e+U00CKw0VLaK+LokPQ1cRCdotP28tnZ3SxnQLEU8sbS6yVmdUyPkQ8BeOJ1PwfgG1KmZeFfA0FpUGRz1C1j/R6NXhVmTUKCg1M02nKYB64xT1yYXIHjM7dbivKzpEQr4mciOZCn7LOvga/LYs+tMHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DR1g0Q8bCtJw0djR3dMfoLeXmAkZYDMtyQM9I6YDmHE=;
 b=tZhBzcMv+6M10NNwYzAa5PMCojvjffU+jxQV7VERTlyD9w8ka9X+rCvFNFLQFdkrO15mC2Jo97dn+wrWEMirh8AH5/yBL+tHfZAQlQl/5dv3LhTVjZOs1DezqD2x/7gZxYocK3uIV1ZAzs9Eu0oXxltjjAyZ0SnCe9zHrboqF3sNoAUlE1F+RYjdfWNnJ8S2oIkOcRR1EBV2NfPekPmtMIrsaANLpfKWxg2tuNxW2zTydejK/ZusX5Nxi2mnaNyX0h0I+Rxj9ne5zLTnI7PDvJBLsLRDLNSNxSXHpv0/wZZ192TC0b1EPU9l8QWRPB8dRECXNIstOFp4y5O9pzizrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DR1g0Q8bCtJw0djR3dMfoLeXmAkZYDMtyQM9I6YDmHE=;
 b=U5QnF+x+1rX3X3C6GCfvqTyqOB89IdREo3ZKOc6JN40HsN7K0ngf+ihdqEYFLT9yOjJtVk6RPvBW+hSg6vjzSV5AhWYeMJQms/+9sAeeK435KG2am9MS5jMDrqTqIQACr/JXrUzXM4i2H58mqb71MfUnGG23y6KDfrJ7DJYA3tS9goRHnN5grNrqhoZ4GAt3Ljc+/RWb6PAv58G6/QTa24byovdPwVHAV/MKcTSXFA5MeLiTlZIhHVPQnIX0pXLgyCfYf1ieuJ4cCI2PBNBd+vf+8y46h1IgL9OnTc+Q/BMLPxZ9XLpm4Ugt1kmkz5B2nRQlI+PT5I0VV9P8j3OS3w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA0PR12MB4414.namprd12.prod.outlook.com (2603:10b6:806:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 20:39:18 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 20:39:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: split out memory-failure declarations from internal.h
Date: Wed, 04 Nov 2026 15:39:15 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <13A0BF13-BB68-48AF-87C2-6650F8426F5C@nvidia.com>
In-Reply-To: <20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org>
References: <20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:208:23d::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA0PR12MB4414:EE_
X-MS-Office365-Filtering-Correlation-Id: 561dd2f3-8db9-4423-5439-08df3ab3b1ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|7416014|1800799024|10067099003|22082099003|18002099003|56012099006|11063799006|261102123227099003|261028144727099003|261026140227099003|261022105027099003|261021121427099003|261021123027099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	HjY1AaufJrgDUO/CJpq5rw+wLYHnrd3RNM3qVWPuBjKY29JHXK9tvz2+RKjntwck87JztbogTRKz5J+rtz3UyIxOyf+BbCBVTWcswAW5jqE8ovE9mj38GW3Jir/z0w62rKRB7RfBDxw3GmlOUhXKlbu/oXxmZi5aJJJhS+5sSZ6T2XaACH1b0UBTV0bHC1Zz1AAWEhnghcdNINybQiQkOdb8XlTtG9F2RqcCSTFmgZSt1+9dzb1bfVJAA4diArcLP1JelkJJtv1x9QNTZHKDKtB99R7WD/YtqZNqPww+tQeB8kCODbCJ46OBNsRPcHrZ2Tf8Xq61sDzTRdkoH7VPDtS297O2awCwT7C3I+cFYI+85XlkcDWe09ECiT5ZQfFi7ZA+F1rXJfQSk/gYFs+N7NEBuXmq7v4yvqt+bUbuEKa6l5TKbVo1nyNzvcrK/60B2rVdhrSqgDgPbWNbCcMbWLKo11vBgZ4Cyv3lqCYUUDIz5mUZW5OyLKDLcHMBusP1S8U2tQW3VrTpQEU+DO7DvnHeo/J/LCPZqpcNKfSh+sa+lrBiAgaAgdMyC3Jo9G0+GU6anRAygNyG1Bi2/o5leZvUMhDkFBdA2RxBOHX4yIB7QxdkVlx8kWCB2vjGXdXh0jWCOZ/0rxEd4PTSPa2F/iiZgRQGKAFOdfIErUq2B+o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(7416014)(1800799024)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006)(261102123227099003)(261028144727099003)(261026140227099003)(261022105027099003)(261021121427099003)(261021123027099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cLf6zZBAtBh0ULfz0Vxbyq7vzLVRYAd3bn2CCiLNauB8Bc9jeNGefi60hDZ3?=
 =?us-ascii?Q?92j+51QjfQbX+G5+6NICItO1F5uW95sSJ4R33bYl59fVnSiWS14UG+hYup3K?=
 =?us-ascii?Q?gC2DPfGHvmEwVaCNA3Q/nVwgtNcwUPNonM8i7nu5VHbtihBZt1fCal7jdyh6?=
 =?us-ascii?Q?giJnFpnwOxGdo0mlPs6ePH4yO3IdTCABpZVsLvwlfuF3j/LTwjMOBA3+iv12?=
 =?us-ascii?Q?8SCSJYAf86xpeC5D+hx48deFNv/eHDcc9eYr/Zh1wnZd7/59Sb+Y5BrJ/uvK?=
 =?us-ascii?Q?BvRIfZhOdgQdbVLohBmX/4P2tk1v31yktIhytduOtjt3Y+LkQnoDvsI4MfWw?=
 =?us-ascii?Q?eeiln+fH31ccFRDhypofknWPDyxHrcUhP+4/04tTnLkapSy4Mz0Jfwowi35o?=
 =?us-ascii?Q?1/1gxptH5wS+eptLtFQndmc9J638mbVpkIyvwiBTwhVHvqKfqY0pZDt46IE5?=
 =?us-ascii?Q?T8yxyUdBsT0ZB3eZyUpkM1s9qyDnvjuDNcSHh6Ua9DvNHNHo4hymnI5tGyd2?=
 =?us-ascii?Q?gCM2TQJn5SjpWaGUW6+B+GthRthZIbTtYs0Lwe4aiTbdEmtM45JnClS4zsSg?=
 =?us-ascii?Q?/CxeHIuve0C9LFr0iikmDKmbKu9/UFtUQWRo9P3OYi4leFwWN9Mhrxicia4s?=
 =?us-ascii?Q?g00Q1Zg2Obyhv4bJyHaRp9To0VK8yRIFF28PuaCTKwRfS9BI7kH+a/EdI4P2?=
 =?us-ascii?Q?A0VyN+RI4915VIhRYbcqwPFEuPQAiQfCBvzzPV9Z1HKsZNOre5ClG+Xb2jtc?=
 =?us-ascii?Q?lyPWwSKPP7b9QgNEzuk6b9OZJi6kJshPWEn/Nb2S0yw6dnNvSdv5LQkwedF5?=
 =?us-ascii?Q?9MpVw7tmVMaQZv8LLAzgA20axXRnNcHYne03p2W9ddOjTrMX7H+5KrPjHyQZ?=
 =?us-ascii?Q?FnGms7kfWdlRGm8TtR0ixz+gRH33Oy2Cb9Zw5mk2cFjftheYf5AgZwHiuDib?=
 =?us-ascii?Q?D7f7sH/EC0k69+Zlg7M7ipFHaGMoho/yJ93vSX1oZ64wVXml60vH5/VXwbAM?=
 =?us-ascii?Q?qBUSQtxGu2uT1u0n4fJrWAwOsJONYrU+Zm9cfJX0MPYVg2TXHsUdgOVt5ar5?=
 =?us-ascii?Q?5JXyLZy+bAm9iVMDakJEmYj+x9LGLk4+Vt8ZhoxYUrgMToUTJDSSjjwNMScJ?=
 =?us-ascii?Q?seTbM2zFJ95P81CrJ6xP3AS/m8wAiRWfv3oAGkxTeiA1Y+M2YmUD8tvJk3fp?=
 =?us-ascii?Q?JRgmemnNqvw4q1i6duZr06Xr97VubfWaz4Ia15oaWQBqYDzzV+2CMMg0qPhX?=
 =?us-ascii?Q?AkfqpitakCkPGeIgDjEL8rKISe5PqBE8VhXYnrJhsI2ZfjK+ztJG184+EGRQ?=
 =?us-ascii?Q?ksoHn2lOlDV6BTWEeLFdqB1tBPStKD/jEeGxcgkjJos5GBTfOXEGK1XFESPD?=
 =?us-ascii?Q?Ftef+kapyhpFWD8z6xLi+18huVx1ry42dn9xAbhGPB39ubIQFR8f8ttKDG3Z?=
 =?us-ascii?Q?q3bzdUUD6XU36ZnTBXLLh3G8M5K3TYiTFXhYJaakWLBdsL/cvK1HvdMLFcm2?=
 =?us-ascii?Q?2G4ZO7dopaewKuH+V0Bj24WS+M9TVCz8ULD/M2EgA4QTQm862wVQJbNg/KMY?=
 =?us-ascii?Q?vgE0OcG+XMWRf2hmuKLrb66RqoXhsJeJZhHjWRmjMoCC+YfUAzdGzi37r6YB?=
 =?us-ascii?Q?IlbfyFtOlZSAKYwUH7pfagufhV+MTGinnzSvI1VjPgtJKXBSB746zmE1VFDx?=
 =?us-ascii?Q?AXkJYk+iTlkh3QHohhLNcjOv4huPlHl6KHfNZ3/JxiRmRUwu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 561dd2f3-8db9-4423-5439-08df3ab3b1ee
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 20:39:17.0099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 29cGIbZdM0P8usie9fV7L8HhlRk2qrFXrODm0IYDO0Y9YItzvNgtVOVu5QvbVz0c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4414
X-Stat-Signature: m6j1cpgsj3jjcaifgnqc5uiue6hk7yer
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B9D6E140005
X-HE-Tag: 1793824771-600406
X-HE-Meta: U2FsdGVkX19sxg5fACP6MvD9EHARhtcaPf24jnHCCQX4jHMPW/2Jt72eM1mf9AR9oeC8J9ENZPM2WVfuWB1stVo/zMz0AKgxVN+f7nY+7DCgFXrLkbu1TAastEvVOcmnPDb94W825mrIMi1mVS8wIZQ6HrVctkxCXyCttUeLrZwe7iGMwzjBPfhyW3SunnJR/vZ4xMggR3aMn7xYEDyyJi+MVgNCFg/TMaV4DxxuA/Wtb6p+mSa3Mbe7lWOACycjKUSg5/yclNxfp5exgYjW8cEbdeN/lBiiTMpktYHSFGfsLd6J+SBTXValu/rl6SS6N0UXeBUv0kkteQTNMlB2qWDaSyLtYfNd3ynvHbXIfmV3PILFRRUcD0DzHgFFgPO7yah3keKPyh32p9sccjiWGBVuElyD9A+IvbUTq7R01PTamIgoZhk+tHWG4mUm4QeB9vQT2XpSY3mpwtwk9KK7qOgKe9IqnROlqftn2qz9A9MAvKU/S+5MPahtrYb+XJ2dYSElW6GQLB/nsmiyDPmhgNjbOaoSzCPBSl6xlAEuA3HZf66lF236z2QshfPro5HFDC3uXfn7AgtxFjR9QAdJEz4d9ugk3fzBhY4tcQ6f6L8ApyEcBnxXO6use3dOYA24oJY/MkK+QFH4CVdZcpSWizkqBogIjqqFI/j46kgHxTp6xC2W2ZRGTe6EJJeqH0o+iTEc0RV0xWr2Zu6pXtPWchHp1MF/T4203I2QN3/2lG2EN4Pjnls9IZ5j4iF5Dz6X6SqFsZHcOEcKKxHBvnynEZD/I1X4jrOsMK7+ha4AHZWoGPGGpBZQnldQ47gLEvQSUJ9jKepE9nRRAKiQNYlTE5WfGIAofuz5+ltPwd4NIWv1GRa7DkcK4m5PYr8ZtXovyTA7k2oimA6LRzYVUjtW8x/sFeakXATvxHSJFHauBVlI4LZE1l8H/ApvIavX7/J1zpWCNbGG/ikblNyvW93
 4eG351Z+
 ywcSRW3r2bkSI7cPZUOQnQ/9gdHwkX00m95sFmZ8GANBif7VtJTHPFo1bcdLeBkBZkRScvlHDaldIf49ZD4+19f4NfsKcfs4Srqn2bWP62X/wWbYpoPTAsaibiYSywkaY/Y61F9BqL6deiMmMSxzFUgR0+9hXMWJSiAsAvhPpyThwr7QSB3rgA7sU8B4RyCuKpgAY0HXxMeQP9jLofb57QTvWKi359TO6AMBbhaLGFM8/sgn9TZDXZMOR/B7HvnICwC97o6QFoaR7qcAjZdigmwZAzkEet36eYV/0sl3wwBpSzJqrNk9Lls33U/y+PRgrsDbE4iWf9MY64BN6h7389GskdNbp4VhfO8pkafhb6BhUvvNRra8JIqnkaLixH5jfdUr+fiBO0e/srJqWWrdyRf3Q53nDzq9bMToVDxnppufl1Bd5fPq3wQHMwIzbIb268LH52aSDegKSXiLKUisDjcUMxlrjGHrvAV4K601RoyfAK4ZSHtU5t8msaskqFLlYjp4U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 4 Nov 2026, at 11:45, Breno Leitao wrote:

> mm/internal.h carries the memory failure declarations, but only seven
> of the 81 .c files that include it use them.
>
> Move memory failure declarations to a new mm/memory-failure.h and
> include that from those seven files that need them.
>
> Move the block as is, including take_page_off_buddy(),
> put_page_back_buddy() and page_mapped_in_vma(): they live in
> page_alloc.c and page_vma_mapped.c, but are built only for
> CONFIG_MEMORY_FAILURE and called only from memory-failure.c.
>
> Keep the declarations private to mm/.
>
> No functional change.
>
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Link: https://lore.kernel.org/all/aumt-4kfGGtoXuh-@kernel.org/
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  MAINTAINERS          |  1 +
>  mm/hwpoison-inject.c |  1 +
>  mm/internal.h        | 29 -----------------------------
>  mm/ksm.c             |  1 +
>  mm/memory-failure.c  |  1 +
>  mm/memory-failure.h  | 36 ++++++++++++++++++++++++++++++++++++
>  mm/memory_hotplug.c  |  1 +
>  mm/page_alloc.c      |  1 +
>  mm/page_vma_mapped.c |  1 +
>  mm/vmscan.c          |  1 +
>  10 files changed, 44 insertions(+), 29 deletions(-)
>
Makes sense. Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

