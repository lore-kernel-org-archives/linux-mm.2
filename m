Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4EE606A6AB
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 23:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DyZzqH/G
Received: by kanga.kvack.org (Postfix)
	id 76C366B05BF; Fri, 27 Nov 2026 18:01:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744816B05C0; Fri, 27 Nov 2026 18:01:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD246B05C1; Fri, 27 Nov 2026 18:01:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8F16B05BF
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:01:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A11221C3D20
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:01:57 +0000 (UTC)
X-FDA: 85482423474.21.3505B48
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id D806D8001A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:01:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b="DyZzqH/G";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795820515;
	b=8C9LmeNZ4fc0pBysCcxZJAILQu02U63LsDThX2CY3++h8RVM5ZEtdSUQTm9xxqbURRbY7m
	cTKQYixZIe7IODyv99oetFpt4x5GjV0HsKq/ifBHhd1B/b0xkqCA96r7RkJMDzMmTJR6ns
	VS+Hg2ydx+qyqAoKnkwWnI1Sa6iUdtE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795820515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8eNTTOdcnzdZwGgtLXJftPOXQJFd+tnndAIPM6LXzc=;
	b=aFsTgPwjwDAvcIc5YdM+uzM4XML6ceNduEQ+jKcFDOgoc6sVgD9MHk133l22HsY7xwoO5A
	ONYYwlCiA3bBV1U5l1W5jKp4wNK3e0bfC674/Cn1/SQkWQhLstFQlTl9e0TFWQJCurc1Op
	KRT+cSxzbrM0rIt6szJHd8y6Cz4yPaw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b="DyZzqH/G";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lutBotMhMcKeHiW5brul45dSVzS0KKVrW6F74pPSqScqIPuml/Ewz68zxoDXnFfriBtlRip5OgnKwQHEhE1kJZSb5g3Fu/pFinmdD5MGeQmqiGULs/g3VTmZBSq3AsQGXL7ydhJnglmd5L95nHtMwiLehxEvQ5l6r/OgVIBG5p5E5G+Ozbwe3Q5GtQV5j6xmUAa50o6hN1h4EUa4K8OUwTFPt5ocr5PGR+KlehTkClRwAhWuh9vW1RZeJ7SXDWTwlWGGpG+9vqWVkBiZdRUqNlSZMIBJ36gU0z4a32SrEApSIaaiuyIMe7UfydrcN2/2u+cg8U6RQB++tJpLHstRuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8eNTTOdcnzdZwGgtLXJftPOXQJFd+tnndAIPM6LXzc=;
 b=WAdgawGumJxRsDoT/AkKzKMFG8HTUEggC1dGUrpqO4sCVs3ANJz8AXUGoA7LyhqEmEJNoYY9d+6O7xXk4W1j5YIVFWjbJZLS4C0mrPYE1bCYkutt4sb9wsfaUddFI+I4sI9bRDv/fw8Nfed3XNAdHpnOqnY6ihfpnAxOhC4J+n2+fTol3HClirMeGfgKcNh9Yq7zpdIGLm0iEFwkgPKvSuIBi2ISiHQYddJ+gmAegfWKVQzdjwIv4sWTQEXPhzcQ4yKoJHEXtP6Zv4qt2S2GDDS6mWJNyNTZiu0KLXbObJtTOBcrjg8Rx7TqXO8g13nw29KCXpga/VfWh3MWfTiuKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8eNTTOdcnzdZwGgtLXJftPOXQJFd+tnndAIPM6LXzc=;
 b=DyZzqH/GsrP0ZsOQG87PChhfLsWzrHNyTUCvlYlOJcd4fGYfHYg6PqCrsPbLE1hdmFQXeLN69z7NsNEmZag6UzpNvIWd2Bv1H2nDZ6CeKMmJK18EEdUmMAbCI1rBF7VLFSUPdmwVwlGp69R+amIVtDoc/zjaz2pQ+wYVAxvPJOkFpXiCpAtvaxgh9nKgyrYYd6x69Hqf2jI0iO+Y12Gvt+JX84jmxn5/QPxldCHRa3pC5zVgc4jXMT7EPvpCQJeg8phwKkX47oe6nNcsga0JkmlFcE7nH6PLLwq2eEzGhSuiikQm43GafWELEZSz5pb8oZvb0QSEbanKf2a/942zqA==
Received: from SN6PR12MB2814.namprd12.prod.outlook.com (2603:10b6:805:72::33)
 by IA0PR12MB7505.namprd12.prod.outlook.com (2603:10b6:208:443::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Fri, 27 Nov
 2026 23:01:44 +0000
Received: from SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59]) by SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59%6]) with mapi id 15.21.0662.004; Fri, 27 Nov 2026
 23:01:44 +0000
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
Subject: [PATCH 06/11] MIPS: IP27: switch nmi_dump to runtime nodemask length
Date: Fri, 27 Nov 2026 18:01:23 -0500
Message-ID: <20261127230128.111933-7-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127230128.111933-1-ynorov@nvidia.com>
References: <20261127230128.111933-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0015.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::20) To SN6PR12MB2814.namprd12.prod.outlook.com
 (2603:10b6:805:72::33)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2814:EE_|IA0PR12MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: c788ed79-4760-408b-af9d-08df4cda6841
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|7416014|921020|10067099003|56012099006|261026140227099003|261028144727099003|261021121427099003|261022075727099003|261022105027099003|261021123027099003|261102123227099003|261009223027099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	1Gnjz+HNWtGkAbfUx4NrNuRgUQ7aHe8PplzPCGnGzZfmmbt4lGqIS0JQ0TWegteMsi9NWX7duE54HHko3C749EA1hC+U+3DW19UJDpTK2nnMMbdFxo4fBjco1IZt8tLGMjl9O2QiwclFZFN/MhHFCuIG8DiAosyULdVrVcr/aRZey6wilSuDRQ6PhNUKITP4MYkmDD/tGgWPbLzJNJlJ7tHYo0zAzd97Y6asynO6sYRMFLgv6mML5TZzwQcup0zK80uZuxzVkS1RL8dqBfgkMQ+8s3LRMTBw7rCg6sn62BJMMQckx6g7kOS7WpnKG0AxmjPfhdquheXlAOZpR1tUknNDYutsCFHEUbDLIzIBoaaR2/QYSJYf7N9XE4zDl/zAqmbazP8K1+IYKDGL/Y+Bc64StJJ4WVzNldgIXBU2ky/yGPHMIKb9hrXCGRBY3ttOr+cnQwP4sutD7Uwh0ZbT4BOUyTmThIc5sOFdZKyw54xLxruLNedvgRulMJYg2D/eF+puW0Vk80FpQSOHPMEo9lIPCDYd8fI+bwTgTdBlYG+Red3tWhEfD42hlB7Mt5TsFF0MNW8fBXy5hKuOMkMRdqkIDhoBYDw4QucJHiY5kNrk0r1M39322RLj4R3frFgo8IXELo6zsoQru2f4vAilywwwopvDca0mSLnEXePA5zuYQhDpgsOy7yJ10ECKpC8EtkRVna0fLNWCqnh5SXwTdQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2814.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(10067099003)(56012099006)(261026140227099003)(261028144727099003)(261021121427099003)(261022075727099003)(261022105027099003)(261021123027099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KsAISbZwOLzIzsDqett07tgoFeku0j73c2C02SSnywfQAu1EBYCxeLgzz06o?=
 =?us-ascii?Q?zoC+gyeoAr3VFY6ocwsK2bpqkjAivTF1opyqs1+3wyXel87MCcgdi4aMkwrU?=
 =?us-ascii?Q?Tniz/hFHm90isyiGfef04F606WyAcyIfgDzon+lH3iT93jnbr90sHX2cIcM1?=
 =?us-ascii?Q?xwj57z76IcCZT556HQDUDo8rgj45WGi9HdNSE5RdDeTDXCk9ijtuLtq73RxY?=
 =?us-ascii?Q?c+D+kaVqfk5pbLqPo3twm6grAdGkdtplbOyoq6Jbt4au+JviG3M8Oa3lIYu4?=
 =?us-ascii?Q?CWwlBLwiUFYzYrVo8AS+XmNsl23/j4hX/5HLiroN4Hp/F7XWsG35nyejUkyL?=
 =?us-ascii?Q?mge/e4l9+9f+ss1IrB02MIxxQjTZuqtRzmsWH/d2kBSQlwqHR134f/mVWqrx?=
 =?us-ascii?Q?AQqH8fOoiDgH8EavRQsKjDa81N1dcccyJEkQ7sXuOZr9lAsz2AShnpZWmoCf?=
 =?us-ascii?Q?zGkMSxPQCBFlaAt3vjfBiJxmLBj+1mRAXvmJ/Cy1VaNKBMXMZYahCybTUyQP?=
 =?us-ascii?Q?0muusgFr+aC+AkR8TCti2xBmZ+se65oYqcJYjw9iuOALet1tRMOnRjMdMnPN?=
 =?us-ascii?Q?77H/PEM1a7kU4awd5YoXiM+Cjn6MgXlbSNlb7oxOtQT8K8N2wBOc4KiJzPXn?=
 =?us-ascii?Q?ZUttHL60fJK8XclHaihrSFxOeaCkFrZ6EeFrGyvRUBpiLbPSCWRwvwbomuCA?=
 =?us-ascii?Q?iWmP+WFEJJOkEbUQrjtu8qz303GHh3CyQSA+hrXb/tddPBzR2l064EK91w/5?=
 =?us-ascii?Q?61jIubexQHeSSYSUMNnujNzNWLR7MgB71S4bocApN795eP0VN21/5d0LJICm?=
 =?us-ascii?Q?Dy+zCz3heohRE4EmJ78nZNe18QecsnofYcut4zH//H4fB5y0yuPprTyvx7Wm?=
 =?us-ascii?Q?uPYqJCoqWQ2Qu+yrI/P9KW2/XdRqcianiueAzyzn2oXNsvn3x6psqyrYDwUs?=
 =?us-ascii?Q?EOMv6xx+DyfXV9cSF1RYEtTDjKcXi8j3vggrl+zTFa/oDmcqbc8v/M0OITYb?=
 =?us-ascii?Q?a/rdGgNU1pvhyUDrcg0kE+ji+czAtsK2Txy0WI5vmTeYS9YYtWImWiU3vXJk?=
 =?us-ascii?Q?fXNhAfb8Ek8Mn0An/Bs6cHZMxQaPXiOk3Dj+6Ob7Htuw6ZTOrxi8lCTK6HJJ?=
 =?us-ascii?Q?ABdEAVXR/E4dogr/1+0XoN5kiVNmhyDdZ2TV+bfP/5YLtYH4hCSfr1QaVyNd?=
 =?us-ascii?Q?F5rDqdqbCz1QFC0RliAKY4uwAb2wssP2jJd8DuD4BtvLRg745mNh53QBnD9W?=
 =?us-ascii?Q?WlEK/DEoQOR/5qCbPxQnecGyFBCA+Yjsv6v1SNP4rDmmK9LhHdIEKYWFEcsH?=
 =?us-ascii?Q?PjNLbHunUPm94Dqc6JVr5ax4He/FcSI5TynlgNyUJQgudGxKftlbCrFmSxtD?=
 =?us-ascii?Q?b2tyqDVuujT49qrfX7NMgQTQ5DNOhwqPBoM/NBoMUOTj6udFOBDT5aNuxZL6?=
 =?us-ascii?Q?VomIiYKZRiNXGtaH6IvgWNg1HqDCPxpZbhUXwbyQMscmPt2CtKaiKB+hqM+U?=
 =?us-ascii?Q?/e7X6pyUgB6eJreA9HLOS7cckpnptkTC4Ajtvx7tIt/cGjAsxC5fbPifPpLI?=
 =?us-ascii?Q?3fhM22rRGISkrGof1RQtMFeNnlIWgbHCxHww0hJ57PSE5dF8MVLxcP/Xl+Oj?=
 =?us-ascii?Q?o1ofhwlJ+WE4YuOCnSPrLy0hkr+N9TzlibOtI+iG755d9tQvZ3EY2FfBhyxt?=
 =?us-ascii?Q?1bAA3ToGefo/yMjO1wlknI9J0TSufMaofxKJPmhGR1zf1zW2JXSe3OCbggH3?=
 =?us-ascii?Q?8GpQ0xDm4610dS6SaBuODEktX6denzOxerfby33IhYmr9V2R6LCt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c788ed79-4760-408b-af9d-08df4cda6841
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2814.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 23:01:44.8616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJwSFnNfZkYg7UTjCA1n/g/1rltuuUxZlLIUnjCNArDoWyCqpMSG+4t58OPipY9vzcQ0AxuEN+NpmTOvPSh3jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7505
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D806D8001A
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4ptymkk8kb4d5kn3e9dw7mreeeqb8r3o
X-HE-Tag: 1795820514-659810
X-HE-Meta: U2FsdGVkX1/Fyd1H0YjIjo28grCCgcQDIzziM4e1RN38mLNoLWR6B/XImeEvXxhCw00OlHU6SWKe0ocesqGD2RjH7mD8GeM3R0JluBc/TtbxCwqRp/6Nz8qzalQgwEFbLwfTSUZGLOmeMHcQWhWue/3wOIoSf0/ht/WdbF6YJECx95HdVDRW/sd6SkVyyDPwp2O7T+3z5sd/QKgPWMqFJ/fYlbCqUBzghDAvj+C931V8dRtJwha6JXWQPCCgV2fhE/E+Z0PnQ+jawxU7NxhFlzwtstcTE63Sr0NitO9pT9tZrDrBPq9k6dsPh4ORUkUEP3Jj7ll9A6ODH1CnTQdNxPycY6vp3c410Nx3DfVFScixMN/g9QHRy9+/97L2iohkxySERRl6aCeAhE7zPXKF2Jb2XsZ/Pgdwx/0g6/ZqjNg6f0griiRkCp8RS7mOi5XPU694+G0mDtCTcPh2j3NUE0O8Dt3F/kD930BxnuTUlJmadp482efdatIycXdZdvE/XOKA+R4I6jlMFUr9pRqsb6CeRPPhXcWd7ST+2tPsqZcggpNx8XIMWb7ZllfiAq0gfSqlQgJP86dzQdpXfwXTxPLTdOUXMHvb1ehL2cJdpuTffK+zQBJODUl6Yvo7TFaj5LpN3Z51uxERb4e6LZFBFNEKerGQKsccc1niVV+/qiL5T0GePXttid0cqs53lM7euMEbd3CtubkivHRlCj4HT6qgKQTqdt5kK4sj2x1KomZWbAzFF9+amelhYWUTfeGqUnbJN5S13VBPTb/OM5eTdiBD2BykOvLvQD+VaXgxOcMgb3cFrIkcDSY61QYdWmA0EU5EnZiiLxdvx6CWhEgB2WFJgGzLr6NhTcTdt+xcy3qzzZVj1JMsBQwt+Ursw2+qQ2k4JdG3vsIskVLh2oREYyJ64YiJC48+SskFq3R0qRR7gQQuq/y8s0dpcY2YXcpFV6crBR6xBL8DHzKzT4j
 TaFFcU6Y
 1qvRJzCzilw0yQgolWavJ9jidkiHSBYAm6Hz4cXO+9Yt1gJ3ZRtKtf7uQi13KYP/9PXzd1/FX+SOJsHsYAKk1Bl5YlSwWDbe/Vh9xhoKW4chCOpuxAxm5aYTRXqaOjgksA7RqKR63WmoqUBIw4vnENhPByIE5nWl1SxA0lLukMzVyWzMWrEwnxuxULs/9IK5i0kLQDR1TwsBDFwoyyIIQHXfXaMa9LaPWUlLgJqFazIqa6FKVDdoQsNF9cem3GG8jp0EBczHihgWXZ9JItNB5jfiqepwTsXkcRLObRphSZF0qbgeKbT1rVXsDKOvGxHLGeaGw2kgM4HaSSVm357p1qybFuEMv9wEpRSWGQEjFaHYVzGN67sZGL5hYmnQz2BjOvMqAxuHEZqSLHsRB84B13zeZ/jZ3x3FQvdt9sjqEqOkHMZVuLlWFn9pRRR32pGi9LnYHiMtE1NcApJO9raowgHRB9SLT4nnKJrIRutBjJH3IbEmXZhbXjSAVPjwaFvRPapwBEm4EZCO8OEz9TySax+2etOMDEFZ4KcGf82vrsN6xfM6lIjBM08IbUBDiEakSAFLFOr5ZyFR9xuW5cT+fHVvtnb80raYyDBTKdzmyMJLToujHR5Z32CXWcRHRpwVdRXTK7JiucrtV0eXPYrsqc2Q6n0qJK2oyZpvvM2b+cgRZPwj0RCIhBN3hQUPsC9yzAlGxqRgcVwNp0vzvL1WICx36DUmBIzFxVY6ES+7NNAPwKhV+aIhBDSCVQFomOXs+VHqteSEoTd4XKoaQfrOyGHR2yURNvX4WgTSxvBpHyJWXjRC59IqXhb+7SshGQa1MHiWMPhp5zFsotqQ2tMbaPv9jGx9L+eLASsbC
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
 arch/mips/sgi-ip27/ip27-nmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/sgi-ip27/ip27-nmi.c b/arch/mips/sgi-ip27/ip27-nmi.c
index c502982621e6..38b9a89bcca2 100644
--- a/arch/mips/sgi-ip27/ip27-nmi.c
+++ b/arch/mips/sgi-ip27/ip27-nmi.c
@@ -207,7 +207,7 @@ static void nmi_dump(void)
 		for_each_online_node(node)
 			if (NODEPDA(node)->dump_count == 0)
 				break;
-		if (node == MAX_NUMNODES)
+		if (node >= nr_node_ids)
 			break;
 		if (i == 1000) {
 			for_each_online_node(node)
-- 
2.53.0


