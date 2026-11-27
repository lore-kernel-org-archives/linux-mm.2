Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DCD6606A336
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 23:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LfxMFhnF
Received: by kanga.kvack.org (Postfix)
	id C4DA06B05C0; Fri, 27 Nov 2026 18:02:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C258D6B05C1; Fri, 27 Nov 2026 18:02:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B149B6B05C2; Fri, 27 Nov 2026 18:02:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 424506B05C0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:02:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 772FF1A051D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:02:00 +0000 (UTC)
X-FDA: 85482423600.27.73531BC
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9FB2780007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:01:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=LfxMFhnF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795820517;
	b=td304tECO2ziC1i3C9FCR3+zgyEbhif8bXpmIF7mov2n/mONKxQSclKxQgj5Uj2zf4zVGR
	nDU8a/so5y8I+LAyLM0sVPrJtDmAriwMEuDivBetxDrioq0jzu/f5/kuN6PPxCZncWWia9
	e5De98irJLxupBkH+dQZP0YbRKqFfsc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795820517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9jjHGoZpN8SfMXzLgY+jF4xm0VYSsUKUAYryZpul+o=;
	b=H12+jB5oBKk5OJ9eUEDBUgIiCKrcHgVjXh5qhV1ugc8y4wiHrquP0L1RVh5BiNnwc88689
	PKe1+r/026OVzI7FgfvloOmkv2/GgmEbEohIC56v6xONRvugUtZJzMnHv75uiVQ9mcbcbp
	QXeS7CL5kn9R9qXbNg/Is9i9+xBXRvM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=LfxMFhnF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gq1ZXOIWkTfuFeVTqt2eyRnHzhASARC8PvJDODFSV2bW9gjEo+zToR8HTdw3Xw7Azg1SaDISFuJsUoGGcBcYstYXz4I2jr1EPQ7hVoZTBrhpTbnDrivYhj1Ic2ISqNxKjzab4eWZYvxp5jwyHu+IUR6C517CCMXIIUIadXsqB3Hox6v4SLtu610NVj0hlS4YUtqpZs3rdJdcBq9XlGaul1EngUa8VacVBiR6BBVRBiWBtDmIXN1KgsWEcXY0oKHPUeYvxzGaR+ylWxeGJDMZogMr/I8Bmz1Fpw1a995ypEEdcsIP1ys3dPQ7APxarIYJ4xIrKR++KycSbqG6rGg/Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9jjHGoZpN8SfMXzLgY+jF4xm0VYSsUKUAYryZpul+o=;
 b=T9pVCUsT8MCQ7xr8H1jQxi9XsiSXA5dfOhK3ZUXVLFQw9QuXpz4/qsmYu1dk+0ynn0QHxkCXRfiisSy/p+3xbmaD9rECN8zlCYGp62J3bZC3YpPayD8lgKLLvMMZz4NPdm5u0B7xxH5Axlo38ZE6MUK5B6AqL3XybMxBwO/10FDRGGboUb8o8PJ3w81RWCz6XdlWIBG97hW6RgnEpDwIlppX6b1wiU1xIM32SZ8Qvw+NY+P/hX3JYlj4AhC2RvtDNkoqrbB2pfY/Qfjhw6y1rglXdkj/Ak8167fQ42kMQngK1UUACEDOY0JUUFCX6+NTvyE0NSXm2kmJHW8WE/bFYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9jjHGoZpN8SfMXzLgY+jF4xm0VYSsUKUAYryZpul+o=;
 b=LfxMFhnFCpacABBqPT9K87vr0xnTeqy2EPnXfgG98mWK63F0QQkgvpXs6thbLHA16yr4ujQ0KU+wjhjFU2L/eDpQ9JjEiG+Ye8lVx2KUEPIXcEuJ/jvHV4Vm1db41pLrmzdGNZd6T6BPRIgcVvF+gUGauLFkXmCst0REl3FgG2v22trsozKOGBrdV5SwXfCJEnl1Yb4ipvBtbkJguexACz/wExdieRndlhRmuuLryYpUeMeoDXWqOgU6EEQa47XTYCcxQHnwOGmFSYXRIXAHqQ+ojzk1avN2ta6UlIHIjLFNJ8TdCNjdPz3MiSn42SOWJjouZmaQRJYnwOxWCmfdZg==
Received: from SN6PR12MB2814.namprd12.prod.outlook.com (2603:10b6:805:72::33)
 by IA0PR12MB7505.namprd12.prod.outlook.com (2603:10b6:208:443::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Fri, 27 Nov
 2026 23:01:46 +0000
Received: from SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59]) by SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59%6]) with mapi id 15.21.0662.004; Fri, 27 Nov 2026
 23:01:46 +0000
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
Subject: [PATCH 07/11] ACPI: NUMA: switch acpi_map_pxm_to_node to runtime nodemask length
Date: Fri, 27 Nov 2026 18:01:24 -0500
Message-ID: <20261127230128.111933-8-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127230128.111933-1-ynorov@nvidia.com>
References: <20261127230128.111933-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::8) To SN6PR12MB2814.namprd12.prod.outlook.com
 (2603:10b6:805:72::33)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2814:EE_|IA0PR12MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: 95fbe7dc-215b-424d-385d-08df4cda6986
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|7416014|921020|10067099003|56012099006|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261021123027099003|261102123227099003|261009223027099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	Tl6cmFyUKeKD37WsmitVnPpCzkpQj7TmkYqVYlPXOduMv3JdNERDVzCEspS3qCP86/BI0xXhdGwLs/XrksnxJytgKmZUCZ+7xVE5nbKJoLLbSxecV11LnWOj79NYNfLn1Oql9WDEiXjNul1/EhiDYUXEmjEMcUW/hoHU6XK8iGYhSdYGyj7FzpGt4XN9qGsNOn1Nt+1NQVxZvC/OEyb1rdiz6wW+R+jYhKS9O4TC5T28P1t1VppE8Z0X08TIOVGrYDuN8U2G4F1kBZQavTgfTGN+b5PzEChxEz9xrb2061J55MXIh3rhlaaeOVOHyU7aQR9zlHrVhHImDKtVFlMI6FelHohTlDWcFsmurXyGndbT5RCFreRjcEsGCy2UGmJEJoedJ2zEdrbFTIyg38bwe2N5bQrPbfZqvKtQLCFMla8gyMpk7ZIyaNdWjWxONgnE/6s6n8t/UUGaESIb2mQnL9jhHsXfZV76i11rv+qkQSiH9M76SxJohhuWC1JzZ0OLyhVcnguBBZA3UiO8m+gEzM+sMrTYymAF06jtwVJgki2TIecKPkgrU0fFAfUrWe758aC/j5TYpMKMT05av5nwJW8mrBC6hhnKVUxEVgEzOtn+kYoebO9/4ZRhNSqNITyfni5au5okGWBOrstL7Q7TwEEWN6FMagcmfRpZqKAOXkT3IfisCqMikR28sU/IGIxsDyloE3hNaz/mFWX4Nzgwpw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2814.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(10067099003)(56012099006)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261021123027099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JowL88Y1vX/6vTxsfvaFBVUQZRYqK5HNE/kyTQj1sNHx1zmUgrvJy/c6O9Dt?=
 =?us-ascii?Q?tS9pZEL3qDIUPS8zu98zvgDG3ILu7SqyCSGv667UZII75VLqg7nKDmu/W0hV?=
 =?us-ascii?Q?g9Z6g2XEMVW6f2HZD/g2BYmWRJhKrXC8in2kZAVLlJ5ZT+eGi4TDkiZmNv6Q?=
 =?us-ascii?Q?8p53Eh9Tyf5FdX4cravQ3C5zYuZkq0m7oBt3cJrDocr9pgg1m4YorQam9QTy?=
 =?us-ascii?Q?MlmCwUwXSuLBWmgAn84iiZPsHX1+flAJG7hmZvaPKtukktKLUnNaB/nvHI4U?=
 =?us-ascii?Q?b6patnA78cxGEyroPh9lw/8dl/HK+fEnI0SswWCP2jBnWJfQxhG//jR7bxr8?=
 =?us-ascii?Q?Va7W3a7uAhGuZzP5uwrWBfYipuTd6btil9yaqFDtOE4dDjqBiDefqZ4f9AeT?=
 =?us-ascii?Q?yThiirmxlbK6BhKFtAvSh0v3vkphrYj8gxxdCV+iLB3Agrcc/SKDFuSUudO/?=
 =?us-ascii?Q?hVxAYNidcw096tkpR8/5ufEaCchaWi7YIYVeAkt81r2R6Y+DEBWk5qbwR+UN?=
 =?us-ascii?Q?Q/F+sCU8tfFvkKCJ7WjrYyLtP/YE2cXGyPYGg7Vp4fmyyeQiH+KBE34WFbNk?=
 =?us-ascii?Q?CsxMbgyf57gUwBURci/haKq6Gk/JewkwBa9Pa0VDL84frEBHDRJ03ICivP/8?=
 =?us-ascii?Q?bCBYLYTXCkXm9d52bbvM5nuvMDfRelARGAfkwnpnFTCW7nM3MthBZx1Gi/FO?=
 =?us-ascii?Q?jyI8R6GSpVPzIp775WqGZDmIdS8swHy4ymDLGcdaXes374uOjzohyefefp3D?=
 =?us-ascii?Q?WRQ6NgsDAegpJKQAqRpVehiouaXTj4rB4wc0c+sPmJyyN+hJrZ4NqxPex104?=
 =?us-ascii?Q?fn26esyovjuZLoIQk0fz82svPQr9mQNgEcdd47i/Xufy0yKrg8Jx1A+rW+Uh?=
 =?us-ascii?Q?PSMaSab0S7SGBQpn/zR9sDKnUQSuUye8vfEhUj97m+2MEqHpTSLLjpsqN1hx?=
 =?us-ascii?Q?7s3P+zcsNtDziuKCqelAaNzSW7L/IOBfFiy5O1rThhiaNjks6If2NrjRx/NX?=
 =?us-ascii?Q?9eP7w0Uq2gv6oB58QXHAFUW2ivQUXtcXgCud9pxQRrJWcAtpA3HzhmgtBmqt?=
 =?us-ascii?Q?nsu7OTueHp4rY0RrysKzqYEMgv53mVBtoGhIu9LeGI3mOb5ZOG8T+nAT0tWN?=
 =?us-ascii?Q?+S7fFcnztV3x8EH0tlmwry74UkpL/22o9nS1eEtixRQ/wK1bCk+2F58hLDJD?=
 =?us-ascii?Q?40SnAcvDUtp//bQqDEwOa3QqNuzyx5R7MlxDbOGWr2EbAQtESKRKvZQmeRxA?=
 =?us-ascii?Q?imCkxlvIpx/82FJB0grYyPy7H1ScOuM3RbBv8PVKX9b/yss/s7CMwfHxr5cH?=
 =?us-ascii?Q?3K0730zfYxSsiF/pRb1qEN951BXOTmGsL4YgHCDPqktKXH/F0tV+CGnJJd/M?=
 =?us-ascii?Q?NDDN+mew7/+J9ur7YCWcIhJLdFnyVsODdcZXINumVLa56RELmTWJMEiTo1eD?=
 =?us-ascii?Q?Ph9rGqbsrjAWwx4NLs+eJtPQUbPstaLyXCzcYIo5QsVZ+uY8aAl5fGBPmJyK?=
 =?us-ascii?Q?uFrVU0Wa2WfhBUNf/j2thhoPNXlTQUpfiXcxXw6hligGbUHsG/w4025B8vn/?=
 =?us-ascii?Q?Xt5Kel7Ph1LUAYB4mlROCD0Pzkrb/lyMwmbmwLHEt/+fDlDaKLSo5u/IXKZM?=
 =?us-ascii?Q?IJvMyKlRmiRA7PHDo6iBD5jNPLtp1WspyxwxYZyPNe3Ia+P7jip41ExIQCDq?=
 =?us-ascii?Q?UuyAwUZDmzGmg0Qayp301zMA/2g5quZMg5Dc1yruBcSNrU9JMHaEWBM1LewR?=
 =?us-ascii?Q?MYVcqCzc4/LgqhPHAq/nXvNu9N5K+OfPR8K7Rw/M6pWJkZwKksNB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95fbe7dc-215b-424d-385d-08df4cda6986
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2814.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 23:01:46.9019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 60v9vWEvm1SsL5kGWq+9arwEc3fAwzFWix5ouMMPMHqhY8GVrHDfD7JtWCMajD6uZqUEdn8Gsa5dMK2WDd26dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7505
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9FB2780007
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8gpwynqgmggt6gbmqgnt1gbg6kjfg6bw
X-HE-Tag: 1795820517-191450
X-HE-Meta: U2FsdGVkX1+DJjMCOlon4havDPAzRUTutBTTmlEOBbbBPS3y+G8n+gNFQ/RLu3VPQUjQLHRloc0q9w6Ey1hso4QFZorXYDnw436AYNDj3nQ9YKChvBq1ZSkXICHNXvNzPkexyqqj1k+mELI+XxQ9Cx2zrUPSURqwJm+OnfG0nPfa3mUZggpzAH29sH5kT+DcPogkCPXTvQatyd39ceffu71bKXYFk/tBa8wF0dF71AAh+BajILmkznEbdz4MAIP34ZGSe1GPODSqaZqSiQ0EBwecFs2zGVHyes01ICg5QyuDCjWgwXM2yHfZfJksCaV+IIbHSanS28BGQ9bDFC/CdjeD0Bb9aSoXt9R6OZFhtOy6cZM+7N6fRNlgoLYe0Sj/jalvX9d8OjCFwPJS4IzUYtVG9RUJzEbwxVsEeirO8Fe38WQwXuMWqMNci4LzYP0RgxwXjEarZYjgTMOWW3g+sIThHLw0oXleRbI3W5Wz/mJqDYcDgFasqs3rtEwzDsVCUXEbaV4ZaonLHXhO5ywz0YJkNHCf+Du/Z0k77/89A7d9ZTK+NcxHLmhQCdjT9d1mE+TAgKXUU1R4ff8DJZVZ/c61itq2T7UJPXKjrazEher0NObBj4ak5RFZ0Bw4Kiop4l202+jLcwAkBrhlld7YkrGFAL4XWaaqSlXvlRpaesuSiAtU04HIMKUhp+0Yote1P7ZPjPogt2bOKAXPgJQ4rsIV+L786xQWmcXeCPyf1Rne+ft+juPxOsSRc3za/tH7wJuxT0nAUiVdjZcf4LVji+CR9YiSxj7V6KcT9ED7zIAohbTV/+vdbXlqku+0ZBx+upJl4DKDudb2QujPv1V8gAxzvFjpnP5kVI/j8ftIFN81G54mq27uYxdiRDhUP2VnVfQC7j4lauV6KO0IhleZRW2pNi4JMGERGe9Yo6LpTs3XGBse7fAl9k/qxc8twK54WklvwB0jiwOOGhjon3O
 zqya0bEC
 q7ReZD8LM9Ob52vF6MKyYqeN5QfQKM7hY/G2cCFxdYLtauGsJfSUzeFiRDTD8sozJFr3F4YkOkts2Cy+JUuONKCB5pyLYxrr2DDSiXhkNID3F0mP0v6qj2gEf4Z023gShciYB+vaYkVuC7PhLxhArDuDBfn0gw/PR/O5MH6kHyiNdQRIMfEYNtAALpYvguD0Rk9ABvOvM52+kD6SswzMtimB1IJoHQF5IFBKzCOoZ6pXpmTR5f0VAvcHYuPTuFQgmgfTQ2UpwL//M7+CGgmZotCmfZx7v2jfTQ5iJbglMKepHB0ZmY8qE2nWb/9TWr+avPw2oZYDRmFo4zMnzmJ6IrePMiAG/MpR21SfpnVbsGJzRHJK0i5lWNPMSbSoqq9NHACQ0UjmjT3FSHEc6xo5KotgbLOpgCFPY+2Hc8GmxdE6sm789ZJbiFRvDg6LQC5FOUXfh9biEY9vJLBSlZ/0yBkKeYHsp+yd515rVWKM2z7Q7szBhjfPLqLw26po9eGJltpIW5fHj2zsJRW2m6t+WNzU0/22nJgWMa4qPFSiD3Ja6LpYXlxqVqkdCkwr1NUyKHWS6mNt6Dzq+gbSHBh2kS1iZBXSB8xgD75nBspBfrmVe9P0csKaZsg2bDxaPx8uzMW8yW87huzhmd8TWHWe4tFv4bxthxDrYrAoYL5qEqNO9ETH356axaV/Q7HKyzC/3ehGb0v6nYIG878ZhLKWOWdPr94vLitmCoUu5e2TUPzfa5UNEiMjO/A2RNjfQ4EcK6kqhatiGgRhrYrPdGCHZhcYx1twZS0ZNsJiagP+PO0UwzsMiEOLIAgssjwEizM99WdwG7yY6OFr2Xp3izvf/oM9HvBZrxuAqvrdV
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
 drivers/acpi/numa/srat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index f5616830f5a9..d7acb2e973a3 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -74,7 +74,7 @@ int acpi_map_pxm_to_node(int pxm)
 
 	if (node == NUMA_NO_NODE) {
 		node = first_unset_node(nodes_found_map);
-		if (node >= MAX_NUMNODES)
+		if (node >= nr_node_ids)
 			return NUMA_NO_NODE;
 		__acpi_map_pxm_to_node(pxm, node);
 		node_set(node, nodes_found_map);
-- 
2.53.0


