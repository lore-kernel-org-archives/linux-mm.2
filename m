Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50747606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 23:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Hj0dEVtF
Received: by kanga.kvack.org (Postfix)
	id 4FB3E6B05C3; Fri, 27 Nov 2026 18:02:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D28F6B05C4; Fri, 27 Nov 2026 18:02:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 373706B05C5; Fri, 27 Nov 2026 18:02:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0780E6B05C3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:02:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28E1F1C3D0D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:02:03 +0000 (UTC)
X-FDA: 85482423726.17.692F1DC
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 672D780010
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:02:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=Hj0dEVtF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795820520;
	b=N+2F50VL+2LiRZGBiqh1K7qBNTQgSFxK2y48OujXQF5k39PtWT8LM5gr2igGMMKPlnAtYs
	n7hwPEmrRpeGQ/JDYZupb96pTbLFocUhf1A5N/r/OFztTkihOJILRmWam62w62Or9alTZd
	ADBQKuGbbTJVsuSe+7HhLD9cBNClGz4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795820520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LdIclwL+xLdb9Xm2DjTbHZfjZsM7rhR8+SV2mixmrU=;
	b=ZL2fA5XOtqRrF3e0oO/R+b4JdAJew1ycs2UxPD8wl+MRlUR1ruvDWxt+StF/QQSJVD8g/E
	5vGQF78x6OMVIUF7G5XyGGYMF1yrjqKUw990EwgvaZNSkjXl0V6HCp4oAUYFRIqL5RTwwB
	b/C16r/ABL4UMot2P5qZtNle1Q1Cvj8=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=Hj0dEVtF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TiIcy8txKfWUujE96eQ6dqqmy4aE1hDxo6H3qWPo31YF5+NZ8vE4uY2pVbnVWVQbrJPxtyuD+hNXVGxxtwGKAa+35CmLdk0T8AJXmjgg2VM/ZfqoH7PMqzDH/qJJj4b8QX2p7buusdlx6YNWZEg8gliZHsKwo7gsDgR22P8FAXOKjwnG8pEEdkp5OFkBxAJB5sJzfY4iGJDQlyRNUoPva10diX9mOYUxHktbVK+C026LHOqsjEI9VXRA0KdBhLWBD4uNvOJsgdMJFI3+qGH7tBgX8CgE8KItbpHdy7c+q8NzkatmYogL57q5ArIi3x3aFRKrHuM2gC+kCw6x0Fcqsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LdIclwL+xLdb9Xm2DjTbHZfjZsM7rhR8+SV2mixmrU=;
 b=O6j8pWY1bkFDzdHCJowZvELMxpSaSFJdNiyxWN0yDRHBba6IvvQTUlIkYxfYSgnPtbZ7fuL+9lhRYM54G2HGSl1oKqhKw6FhNyNo9JyYYiRv+GiLRqHylxFvT2WuUpVQqIhW5uChzsIUnRktAU4gKHhif/9TbfkPx4YRlEge3S6n1hGYGpc2ECDL7Gbg66MTOZhbqQTDkzvBqG6aoIq8W26Nho81LESd6joEKlEcKz0v2SOAA1+Mw1qMI1muwsVU1a9zUnxYzV3Q0efmXfKgKczAeW7KynH0My4ZyyuoQ7cpZCA0owpENnfJ7Nb4/DYGOWj4lzwEngNhK6N1iaTZlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LdIclwL+xLdb9Xm2DjTbHZfjZsM7rhR8+SV2mixmrU=;
 b=Hj0dEVtFNzD4492YR5xQsssfdb6mw/ou+ypmsIne1PijjZCCts1foti3qNtRBNSBdqvcq1eNSr7q+caJWlno8ijZ6E7xjWrPw4w8KccwNIJBmxgBiyPGYmGFKpdZrqm42hCWOUsGmYCdyXHLUysMm9zpDrslVTWLxzBtlAzkqF0btfnF6R8iyAjVWZxswf5aLZgINTsqpCfS9p5pDZbdARxS/wXS2RAkpRGjdTjfwBmLVu1A5xjOntO/GkipxWe/jeDPmYAFY+vvwGzri74zyq1FwsCkZ8vOmjHNs7JNewIz7IYZ+QpQRNmqAcXSTitppFrUxFpWM9ST0EmAuz5f7Q==
Received: from SN6PR12MB2814.namprd12.prod.outlook.com (2603:10b6:805:72::33)
 by IA0PR12MB7505.namprd12.prod.outlook.com (2603:10b6:208:443::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Fri, 27 Nov
 2026 23:01:49 +0000
Received: from SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59]) by SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59%6]) with mapi id 15.21.0662.004; Fri, 27 Nov 2026
 23:01:49 +0000
From: Yury Norov <ynorov@nvidia.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <kasong@tencent.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Peter Zijlstra <peterz@infradead.org>,
	Mel Gorman <mgorman@suse.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-mips@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 08/11] mtip32xx: switch next_online_node() to runtime nodemask length
Date: Fri, 27 Nov 2026 18:01:25 -0500
Message-ID: <20261127230128.111933-9-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127230128.111933-1-ynorov@nvidia.com>
References: <20261127230128.111933-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0295.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::30) To SN6PR12MB2814.namprd12.prod.outlook.com
 (2603:10b6:805:72::33)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2814:EE_|IA0PR12MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: 45cfd8ba-4f86-4232-98a1-08df4cda6ac6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|7416014|921020|10067099003|56012099006|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261021123027099003|261102123227099003|261009223027099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	WBaaKObIIjnHpbix3rre1aZEKkRpm82vs791DiYpjhKny2zIAUt6VPtYXYNr2qgHaEBxIMXhuflCoUCsa0iK+6aReyK9ko93Rf5dKi8rxhEAov2KfHyfTNy2zKqM60GAlIekKYup+2Y+YGUBQeEsLc9xI5uZKXVAcAIltonkTnaM5tVjJ1M3VRN/7Acdwhbl7+cY0JO6SWShOsqS0YwxaA6fCqOqNGYnkJt7/t6vtXEXoLeO9EjT+YZBStaB/rGjLaTR0wV6DyZarXeSv3m/hXluQfJyTcuLlcpbOtRJFlxp7XR1Kdq2QQBZQa7tcanlGfSJtu6d76QFci880bKwuoMFDWpwtgcHjfIT5uRNWnSIXAgTpgs6I7v/ePP7TCBkv5//kV7rQt4XC8+iydp8QX96n7f1PSlqqlDeG77ShvDVFkTlmUJW1QM0JbMn06N6a5Gygt/NDXYDOEMf/KeC1M6eC/o4w2HsRrXMJM/Vyree2CsMSlrfHu1hced8vQ1/dxElQ9SkZglG4U9VbHHzr0Ot+V6WeN3S2e7Nh5LEUQOg8NIrxX+Egwi2aVXwTbPGtn3jbByL+yxJcBmpvCtba0gJTi4vcIIZon5BpOwJTJMdWG7G4dngInfqz8Wugl2CcAvOwcdEXP9gaPP0jRGRaeOW+bTZ1vIkPoKZ6dMHSWFUg37g4X/Edw5Vl3qJYfHpztAnDNdAOkM15J4Y8+hPgw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2814.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(10067099003)(56012099006)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261021123027099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GBPrSzxPykbd1Hr3ekzw+SwZhkuQ+1l9kM4EbhIp21SNwY6LJOfw+PCjxWim?=
 =?us-ascii?Q?Iqy4V4YijeieOaNnljbvp+Cw1l4uSK4hRNa4KmhSUdjP07nUuWPwI1hRRul2?=
 =?us-ascii?Q?3B+oF3xwfNmpYvRngi7pEKAdanfSv6PRpikqNLcaBoFWfRocM5736YYeqjB5?=
 =?us-ascii?Q?NKo1ZY6gLIezj4JLA9zwrRie5aCJua8mRGaU58F4DROKXavKuvHh0Uah7081?=
 =?us-ascii?Q?4uO6zyWRMmSWpkHcRvy7zxafETkKyWWfMkNLOCNnniUXBJ/auwFqI7M0eCBi?=
 =?us-ascii?Q?iZFlKZaEwcnOQ31hupYj8vdB6ZuKF7fihODeqLjrvS0U32m6wbvy4ma1af2T?=
 =?us-ascii?Q?YUWCzP9r0EDh6Pj1cuQZlrisfbwzVksfAIVqz7CmpAvgaSFfRxq6nJToJEUG?=
 =?us-ascii?Q?rH44BYxJTiFnR/a3PpO2VfvG2HgBPJdA8wxqxOtPpx7UE4PngFeCcdXcjMAM?=
 =?us-ascii?Q?C5eKXPhb4rClHmQGGhmcYYn369eV/sM8/VVfBEH+NmedrzKQWpDqrFdfDv/F?=
 =?us-ascii?Q?MM1JKT3brFb7ujDCkF8pQ2X3drl5mfXG9PFb9V3haJxa9G82438D1avHq3/0?=
 =?us-ascii?Q?PKN16NnzS5k1JRn/zXiuUyhvyAet614T3xfI0Ik3h5iyY5xXAjMwkfrRh87b?=
 =?us-ascii?Q?OHoamGvfoGtstoeuQoQPCy1badVkO36/AC9pjpzFPv4ms4kkZaovQBFu0xla?=
 =?us-ascii?Q?FB/xdfhgL96rNQ1tbcJuDB6/QPz/wHJglAwawptYEbfItVAG4rBfSUKl+9I5?=
 =?us-ascii?Q?Djam88KLtQcdUaICMRIvDJkCTPM09M8qkPs09J8K6NTADw0kXtP7YywPh7ge?=
 =?us-ascii?Q?M30bCgZb6gv1NTrF+GoVE7rPw1QAmzvqxlLCbgE2hKpNLXp2mv7sif5bmwsB?=
 =?us-ascii?Q?QTsgzxhoNdq1iEIJSghFgA+qg0hTvY17/V8TlOyE/p4letBpvxfqwpwYiw/g?=
 =?us-ascii?Q?nSN3bx0O7Su0dauQEwLW8BFY4n9MqiZjZ+vDvqKMJSNIArtbDQf9pNToPYkW?=
 =?us-ascii?Q?Voo2+cVZi8UJIk2nynXj20p8AEFXBYym9RG+XJCvXTzs+3cB9doqRumSIvCo?=
 =?us-ascii?Q?SwA+RvR4gvzZjHv3bXanoesyvsa19cqxQ69Bt+V3KJdZiAj37M1kNyIEk45y?=
 =?us-ascii?Q?1VsB/4IR8QptSHdkaNd2saDc6x26iVjGkCpvcIoZsQNrKDCy2rkDCSMk/rTP?=
 =?us-ascii?Q?jl97lJ8fu/xvItJF+C/7GaO2Y0wrpWO7BAh0FmHvY8a64+qHGBSUTXmPaGLb?=
 =?us-ascii?Q?+lfQ3SILEELswk/qALjaiLlfJ2g2gc4OW3KdKEByXYVjNvbP3NottmB6xZ5z?=
 =?us-ascii?Q?DoW2FQcZYFZjOT6Fyh0emQDJEoxV+SOZXJ+KuVHnpV6dmxdqAYrKj5pw4VJN?=
 =?us-ascii?Q?1MZZWdW+PPgdVPZHA6ZdbKrgH8D4QR1nansyYIVXqwLfWbYUYXi9iyYelUP8?=
 =?us-ascii?Q?7zmSyg7QGebfK4BbDvrsDmvUkAOG+td/B5+1h1QriOoKuT8c02bIbK8cx+CJ?=
 =?us-ascii?Q?RTz9xo/yVWfV8t3WlCbM4QVOF/Ev+7mC1JLw8Pf6rNA1RF7i+uwEb8b0vCCm?=
 =?us-ascii?Q?lVAkip8MiD0dfZZEpfBZYLcht6eMA40yzhq+TDaLUP9z9zqRHyFEYBkrPTSQ?=
 =?us-ascii?Q?VzbAN0iJ78nYfkgXCHz1l4tMTZP00dCs0irk/suWRmGuu1LhBn6DNdcrEhvR?=
 =?us-ascii?Q?hg1pclbbWcBRrgx70SE/rAa4C/sP0LCkZJ2CIhcit1hx0S/F9aBo/96rs4U0?=
 =?us-ascii?Q?fYKAKjLonktxQoB0HFqD9j4PI+1Faqgp5AHuMuel1p77hJz+XVWR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45cfd8ba-4f86-4232-98a1-08df4cda6ac6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2814.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 23:01:49.0375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y85Iaz7QgIWM/FAw51ooaRgvncSiGtTBQE24pbKR1GpiGKpgJEpPDdFm2Gi+S33vFPHmYbhNVvxYKTEDyJZ3cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7505
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 672D780010
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4mr1imcubptxt3hyrcqi6nz78fdpyyt6
X-HE-Tag: 1795820520-989838
X-HE-Meta: U2FsdGVkX199n5OiAye/KLNyUpZtf0leX5kecSFBOAyurjPATU7uOJGhO3kP3zIKTIk6ZU3Km2VM+i0urPeUZZyR/+yiI3koXxahAMa9l2McrJ87jYildrv+Ze3qj7J1QpbpBlKU4kUPMjXC36MUKjkIFgTQojCMLuqx1xH3pvO7gNMEDZdMP0NaL1j2Pp/T/b5PIdNM8e2nYxmGxoFwgiE8d1hto6oUaX/J1b6ooZvr1jDiuGb/4/djZ3I+osvC/oDOwHVNxWZv76AgwXmSMn96AePsLVE7XWr85e7ES8WzvMa41EyAH7zcUGt/u4Y5QmPU9VJYsCOwapG3QjexzYLwRUJ2BvStwywbKFwuCjxOOIbk5YChfjw6rOMuCvd9K3ebAe4qAgrdObcpqQq1zIMdL/dFt4tWNlbRtLelMyK2TrDMjGojDtXrtWsxMkGnLHQtksrQbRam9CX73aF1niW+fQXpg/rHWJwHMrJW+Lm7IPmKyzjOtkG22ksutxWaQSRhye4ZPj/8Lq0Rwv4ozW/8DWK5t4T7u1H0mo/rJS2AQk9NGQn31IyIXrwPmeljTZ7neB8cJMFF5TVSQUejptZJDwEt7pAkAmHzO6YCWS5l6QYTd+2psF4+Um8iSOzQMZTg/DBiB2c28215UVEuvFR3MG1kAwlHhzBmCzj6NBeCTjG2P4meLDjq5Z+7obxNIfNGqpZqwkf5hZ0+RzBdNikKjKgedGaYyUEgmkBDNzjZD8E7pX8zHWOhWZfGC1Mw8ZYW9ft9tfLt1qXlL9FAMVf2YIwveTtaMpzh0z7qULZ8iM/0voFjg7eT85cdql2tk9VIRnN48QLY8VBTkQCbJnkntGMyxjRVEO/9dLvasb765k56+U8rJGrWCDZLoLxY9Iiu/9vbfXQAqCzSBS1Q71zkENfVC5V0emyI+CQJetxMG78d5/qXBD1fuQITcHNvWu+1b+d68r8+gn49bf+
 0Mr0r2DG
 72qqciHdUL46fvzCVzERtmo49qZkFSeFFJcp+fnh3MGofGregFngbgtuu4Ca2+Byl8Ugqk/JGoruQfTfllDhXaDzj/buIoSi5895PeVFhdycxBx2uyXjiuWYIQI5rrU0hqftTOgpvYnaMiKWTOwLerIM8oCd1PpYZIciK6vN93SxSoayUNt+r66Pjevwvuy3TXt1CaFI1Z+woGyBjU/BkM06Az3NAHxAm1bFQ3AaJVXYOz+hC+afE11C3IqFJ+BF88wF/plI7FvvtOvOGl0gLerk2hzdpY+ihniS8zaN6CIzlW+Cwf/Y1NeP/zvwO94KnDSyPwZTomOsbyrI6VU/pZt6aWMrXWuHgW75Go+qsVrekWOR8NnclbXTWpuxuN4PbSIR9PSBDitfbXclLaU/LFnUu01lUwysY2IvKBPif6+5/4HNkh5At+jJjn0IIvuUyVmzezzXPZ9kuBhP3P9kblAF4/F+urXKcqnJk/yf74n3LzAoyyAtUGUdc4iSx/K108/YwqKVpoWyb7GbNdepL3osy/+2nyAekEMTyQopFu+tTw48UebX6CNE+4CDEkzWMZntDxqV4uom6NoF5ukC03H94SQaRZt50rAF9vkhHcD9pvZXsxZHFUsikJrXFqRH/U/0UCCrOahA/fJ56s1vtGMbENO6JK9UpQnl+PqRLWNFYCDHNRJLdrHDq+GtiVbe/yPwdCatWRuFlskAAq7Z2BrSq8zt2zCXdtdzy8dPlgdABZUDBPZQryZrX31BHZxR3PkIPf0Pbb5fGea4teV0FGL6V00n8wybVUpMOBMWAgwOlLagqHAR1ph/h0YjwDCBRLqu7nK4RK+r8Zji2Maw1RPZDF4mCuno7Kso7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation for switching nodemask API to runtime nr_node_ids,
update the boundary checking condition.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 drivers/block/mtip32xx/mtip32xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 113bdb868c46..8b8b4211e41a 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3630,7 +3630,7 @@ static inline int mtip_get_next_rr_node(void)
 	}
 
 	next_node = next_online_node(next_node);
-	if (next_node == MAX_NUMNODES)
+	if (next_node >= nr_node_ids)
 		next_node = first_online_node;
 	return next_node;
 }
-- 
2.53.0


