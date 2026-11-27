Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A61060A2628
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 23:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UyHRIWlE
Received: by kanga.kvack.org (Postfix)
	id 1C7066B05B7; Fri, 27 Nov 2026 18:01:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19DDB6B05B8; Fri, 27 Nov 2026 18:01:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C2E6B05B9; Fri, 27 Nov 2026 18:01:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C23336B05B7
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:01:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34AC4120536
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:01:49 +0000 (UTC)
X-FDA: 85482423138.19.D6389FF
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2D3AA8000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:01:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=UyHRIWlE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795820506;
	b=ztDPNvF6Hsp/Vnhg7M7Y9HyPjKz22ByH9jEWxW18eAlOR4tvc+G+TQTynl60RNma4o2mwh
	uKPLoX8xMxNzABgm2IcXyV7yonUXZxJI2m2pH+ryzd8CKoCUoWupyCwhT/TO5sCBNSU9re
	Cb38KADLklGnUWBZv32o4j7Op2JhcWc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795820506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3ZmOT2SF888jSN9A/SfPYy4HLPm4zCpMpOCYIlLGs4=;
	b=HsEe0JVwgfhE6dsZRs6bE7f2gR/lckRCi+ery/HI+oaunrVn1d23yxYDW0hWgCwtISpA5Q
	OgO1fgD+ngvYymgTBuFIex4Sf++Z6z2z3zVchpChVKf3UWmIjNGOXk2Xhm8TMpcB5ckMiu
	KNX3JUxpb8lYNrHbYf1nBLcG/Vy3nHg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=UyHRIWlE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oLpBuJfOmIppYW9QFTkt5YRWAW0V9Ixb1I6l6VoQ1uXkBemPVC2qb4JziLT1eqfL4b2TLk7+10GPwhKm6uq0F9e7hHhrgQIU0KJSS4FkgwVnJfmgpsp/hYTN54hSn5xML8uifnn85HicMIcU1Gt9IH5BKWClXwR5VxhcaD3T2ef8iv4CyPCbMfNEWRpXrQQd3eg5bVbVsaAQ1AyGeBirxuMzWUyD+NC5IApOiyTSGhg/WmT2SVe3Q5/Bi/CcQTfBUNQYQqMOWZlRQ8J+1V0Yde0l91K79M7nRcySxQwkKuyURPzAOqARv8OGcSRdUV+y8k75qwRgRTiHv5kf3/dTCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3ZmOT2SF888jSN9A/SfPYy4HLPm4zCpMpOCYIlLGs4=;
 b=J0lAOH8O6CRdprZnddmfZL4hEc8tdWA0Dr9v+pFXyDYRE0rxms5mpnFD+MU3rdp6rO1mBjLsrMTCAXn9AzWe5YxO/mFpLuCFmdgQUInBB4QcPEA+dqt5GGhBz2nvZsPUsa0kHBemda0xRdWAeGBc4KVqMdccrWQzEnUihJM9e/YrgLMvuFTVfmdacp4zq+qXVLa3OFrkj6yUMiewd7qpvuQ4cmi8THHGPEngl6eLvP6bO8ufDf8GcxLU42AdcTg3fM5q8ay/rHPCsvBjhA2dahc6LthjSK7tOwmjW3OavI9aJyu50yAR9rphX8ZvIIXCPEw4DKkv3/5VhV2AlGeAsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3ZmOT2SF888jSN9A/SfPYy4HLPm4zCpMpOCYIlLGs4=;
 b=UyHRIWlEWkAL1QG7QmJdMaptWt+AAbbEGZctLJdeevMY8NcNbMSf50UtfQuddRkEit5N8hFnnaXeS4g6/EN1NmtO1urgDpK5bvFX/ISxA1Unrr/Ln3WNL5yOdAMbVHWE2oXaMEz3Y8k+A1aEKU6nNa3ea70qr9QE1aUBUePQ4oHLJSfPw1c/kgHpQ+loknN2OwN5/sJKaJPh9L0pLW6m/+yHAviFZUNKoZuOzkCmFImPxoR5pAfbfVncg4DTH+hBLp632KtlpujNuDMrBbOyBxIfuQ8/1ZOx/Qdy89NNNxmd4RBMtMFkqRdNRqxdAaowj2XMaENIxq3tFs22pxQEGg==
Received: from SN6PR12MB2814.namprd12.prod.outlook.com (2603:10b6:805:72::33)
 by IA0PR12MB7505.namprd12.prod.outlook.com (2603:10b6:208:443::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Fri, 27 Nov
 2026 23:01:38 +0000
Received: from SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59]) by SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59%6]) with mapi id 15.21.0662.004; Fri, 27 Nov 2026
 23:01:38 +0000
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
Subject: [PATCH 03/11] mm/mempolicy: reject migrate_pages source IDs beyond nr_node_ids
Date: Fri, 27 Nov 2026 18:01:20 -0500
Message-ID: <20261127230128.111933-4-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127230128.111933-1-ynorov@nvidia.com>
References: <20261127230128.111933-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:208:52d::32) To SN6PR12MB2814.namprd12.prod.outlook.com
 (2603:10b6:805:72::33)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2814:EE_|IA0PR12MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: 801fdf0a-2120-418d-a335-08df4cda64b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|7416014|921020|10067099003|56012099006|261026140227099003|261026121527099003|261028144727099003|261021121427099003|261022075727099003|261022105027099003|261102123227099003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	WDyzIXrGMT+/FPN3btkfy0BxQ7rJl+lVQET8HftofNbiajrkFeg9zFwd52bOUARoP5KX9Idn8NhFMggWxEQNIflXzheZyqpmAtsTyqWsa20MQs1tf6CqnGAwPaXp5XymAHCIgD+cp3d3o6naCwmm3wxW5Wh7egMsfKNhBlTGNRgqIUlAXj93WeEo+M2Sob8hJ7LO8XjQZNpdMgUk/9H17VGffqKkmKnQnna7WkhzjKcCqfILfqN7wbbzGfeFIuXsP2hC939R/yXDavHw1VVjDdW46er7hnnsAXzaokMglXy2Zvb+x+C2rHLV2CSONV2QaTsWMvILU58G/dRrvb9qx+ol6s5cWyra8sGvl/Q+PJh5HjkxS5BgbVLFTQpcZOwgCEx+SmGXQUN7MzoAzQYUcmIR0f2kZ7D1BrRjdXrKVWllOEKXGYIghkHkt1XNkKgfbMdeZ3zLZI+jLFkdKd/pDAM3Mvq1KxrXCc5B4fQUbY/tCRadZK+jHfgs+PNvhUVCWau9YYOuM9qi3z3gy9qA7O4CXPkvbpiccOJoEFM7qjnRtRDINaCYjIFs2JRjP/+MAposNKDYi2ba7bzmKOVEqZNp1shQhY4gO8oVZj8yiQWrF2QJafIMrJLBqPh0Fs9liv4RCYRpxX7d/V0zf1QX4jFxokqRX5mk046jSbkG5pwmT3Am0jMhCCKFQ/DCF3chpbSh+Fq3bljp3j5CGy4oDg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2814.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(10067099003)(56012099006)(261026140227099003)(261026121527099003)(261028144727099003)(261021121427099003)(261022075727099003)(261022105027099003)(261102123227099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SniKESgucCEqwRBknwSliLaLVjtA52wtVp+jKKQ2pWwNh0FXqimTgBgCXOta?=
 =?us-ascii?Q?zUG28i2JUqBChioWpSqWbUF1ge455UBtpsqvN/wJ5r5iSYIWOQ4KLVQYjp88?=
 =?us-ascii?Q?NcxQbS3p54xJ7allQftzqRucSxJGhM/jCfZrf+Qv/qkpAX9zkiXsJ1BfFO8d?=
 =?us-ascii?Q?aS3Hts9QT9QFU1Ke4NVyqaEdkl9l2j6I3+uiy7CFtFmwW0I/oxWlWmYwqXfu?=
 =?us-ascii?Q?H1YEbfYXwoFbeZZxe4TgBknIGdHu0JqK8XYiWaKVy364w8ugwc/YUkrd4oue?=
 =?us-ascii?Q?58dHrmfxOIhFxfDs9Rfkb2pIYOSRaTyLvNkOfBeNAa5ybCzMsYw2XSiyc2qv?=
 =?us-ascii?Q?0BsiKuLt5xmmO9pjZ8PyFUCfbXST06i8r3K1EBuNkUnxctez4r27WS8i3E45?=
 =?us-ascii?Q?hH0NDnm2pQP3s3HOfEm04TsZiF8ILcvjoMDnzl+byPoGT/TPaEO1XCuh5stV?=
 =?us-ascii?Q?g7vzQUwm4H7cIYY5OcCAXpwdQ4cXOA6Nhggn38oqRh88TuBQE+zWJ/oWRinc?=
 =?us-ascii?Q?+d8IPar4vidDTTYqAULoe1nPS22acxa6InEkwDDqA31iQzq8PvGRclTObY2k?=
 =?us-ascii?Q?3ghDZx8GubpMfBXcyXNGAZ51n1Z5u+jdwtnltDsFwB75+eqtUK1tMwro/tXU?=
 =?us-ascii?Q?WEjCK5smRObZM25L9I5SOi2R0o4rYYjIVzNKlI7aSFIxWmSRdmyAN9iSh6mJ?=
 =?us-ascii?Q?7kSouLQmq4Zhis6Kl3TmuX5cG5HDlK3MMtAYUCTzI5kjNCPbyeysmRtxttH0?=
 =?us-ascii?Q?on4MbaJBBejVpILepFBRfNg4PX/62ahNyZUsRwKn2og4dLKEYXanIH9Bx/vi?=
 =?us-ascii?Q?9h9ja/9je7resBzQb4KBhYdEk2HE7wTpZDNHBWb/xytuDtJBJdeEc1HH08mw?=
 =?us-ascii?Q?otfuqGJ9OcpHvXCcWlzDGWWrT0limgT2V5TQw0krNZNYnTd128dbftTuo9Tk?=
 =?us-ascii?Q?V61hsXVndKoVUw/Z4Ttz3l2drFAy4ndgfVg88+lrXFaMFu02ySc+o5xnoebp?=
 =?us-ascii?Q?Fi+U2hdi6MLgbGamJPGfNRYVMIwo9IAmj+IIGm51iQeIoQooVGNMHElPUBjX?=
 =?us-ascii?Q?M6+bYDejFUlgs/nsw8y53LdXU+BPsPFtBuQO6j6OtGwpgb8FLFqEqCy2g0gv?=
 =?us-ascii?Q?hr2L0sDfKeivW82j1blcxi3X8GaH2KnuIWrxjrVzW7VPmEFS2edhdzjiuVa3?=
 =?us-ascii?Q?m4JRJcvmqcgfgdio7rxtLiFTKG2T0r52xmDX7EZfyTzGficEmq//FGCAsGzL?=
 =?us-ascii?Q?pkLZhyU+583uYQ2mvsOnJa5zjdPKJN7YuQibKy8lhgcv0Im0kSvSwHsAuJ92?=
 =?us-ascii?Q?e17Cf7Gd2By7wtCuP5K/iKAnvjXvQEj621Bn10HRBsWwgk3bfMgRcqhzb3lr?=
 =?us-ascii?Q?Zcv+JK4fGV89fqmv48MrbM1GUmhWgTqN9ERPZ+9P6gVxBkptczUYBXko8SDH?=
 =?us-ascii?Q?fCGvSec+kGiiqOtuowT8XT6iZdWrEY7DRPOMMiIsptmoDbwdKggqZBT3A8Di?=
 =?us-ascii?Q?6UMj43Rr25gt8fgbpRtuqzpY5Pb/UE0bI8DhbyPA1gksktzuwhiQxfAHuO4h?=
 =?us-ascii?Q?sNxiCJ1vQoITaMzbGC4jXnY6kiKOKkwEfJBMPryw9jErMvriK2KzEBgImI4l?=
 =?us-ascii?Q?dKM5MZHp3hYN2VZcwURCOWKXJDTg33tAUlmhvUW9iXA3XwMKusHasTDHpMZq?=
 =?us-ascii?Q?iOixXA4LNXbdaGMbrpDomssOSvXu8n2USpiEQh/VGAAzbTv5a++mS3cIgm7Y?=
 =?us-ascii?Q?wEXMnmDzx0M482PhUHA+7YfOKwuphHducbc2zD5HlibftzMNIPZr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 801fdf0a-2120-418d-a335-08df4cda64b3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2814.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 23:01:38.7941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxlKkEH+7QUEIY5I13Q+yeq8HFIdmCDzWwUOoUGW7pY6axP59o5zcEFBoeYUShajaL/GwqESM6XFGbiK4hFMlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7505
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D3AA8000C
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ygqgq1mwuenzcpah1cu8568gtwin6wc4
X-HE-Tag: 1795820506-960049
X-HE-Meta: U2FsdGVkX1/xe3JxfAMjiUahzOcqBtrllyIWE1cTPpVbdgDkvt2QMiB2SxeKAIVw+S8+kzR9eDA1v1E44iPg36jbcLXhcfAnEtIc5/3VuAYMaQk8x0t5zBqsLOLhY1LVheYSNgDZzMO6emOpApOEh+l6N0fnyAUZzOlRoX7KTk4eVQTQNVT6aCOBPMzMEWQ4169J68o2VXpVxw8jVklDRznHiocyoj6bWp70KghBXNzMDVt+WZUcvZEx7Ei2AmAO0WT/TQZb1/vi2QNA1x50RBwl0y7nKpxh2xkDvUupUZXzvGh9dYyrHQCrJQf1PIBIhBBsVr9/uItmUwOUNn/bPoLBD1tVPthKL/2hDTB3Ic5EjiWV7UE4uxu3uKm3+COK8k/NPp9WQLVjFlV6jl5BsPlnUHpFVOEKLdCEblArMRGM5kpP2Y5mQeH/Ghy/Vvta9en/xapnPHwIGIEH1Qop4sQ8uoS/IXNOzB3GmvqF6egF2w9gRwMXjRu1S69cyXBRtEByuYuVrAguDRxRQt53Mf/EDDUWyoIkdVvxhUPOSLWR5KO/LZSHpY0qNug8FyjVosU5zoj2CYXoI2mXxiBqUs3qSunTiwOPd3zCWkjx8FU8npphKLqql8aT+eXszf2dXACMV/Rl1vQ1s4EBmEl9f+xpInJBUZ7NTV4fhRqNIb1yqgX4hrkS0SEspRVJdG2PVLpgV1QGd6/sv3RURbsI9hugJvHlc4MnfXJvsiPyrau4qL88wOtmG0sMjC6XclSWPNGtCWmTwGIDYN3dPZ6PvbD9O5PS9ZUgNJniTp3Ehu01emaNhm7Nd4Jo3SjnQDhOldgdVoEimjZWQpdKRqPPS/fFvG4X/BKP4XJzr4yktPoAeT/0TqTuc7YQH5kWdGt59fgoNdkVvjpXEY/hagy2b097OZVVSByJYpJL5vfLAVVNjjFMvo92eKhP9Shv+0pjU0TreNMkXTvfDRORCwp
 dZ0s1xNS
 obn3acf+bS44pYAgkKX/5wngfdWm9bKMMQ2O2RV96p4AloSifxbc7i0xpk3EgUZDrRmvLGvS86HY3CAr710vf8XnSQEo3L6Fq3NhjLShyMvQeKdDmx242ehsZUqIwAyy3yaMxDna8J8BUy2Co9QCLoJ5VCtxBCh+WCHCnZXcyGRIuwZIo63lGgr27odl2/RSSuT+KFr+ShZKb5vuY/lpax+6xnF4juhXu23xWFt5m0XEAFdc3bf3FdN03wzFSPNalWfsaoM5yzb5IaBsZ5zYy0atYjRMeRfvnl8E1IjzRKnrTZ8oUWoRxHURH3Wz32zdd/tLt7jBaYyfHAhNyMiWuAxRgx1bUtJ07uchszZEO5r5tYihVFRjomkn8p+lyKFI5aiXG2WhJPk+Efph3MWKkVY5g67MqY789pOKDUCauCS2pf8EGfZ+UymcXmUDVfXmMboY6S41YbZjmewYcJwcrU5S48frrv4L8MIpaX4LGurKY88S/auem5QW2BoHkajAA1Z920WL/dN/LNnpY9hA1E+KcNYrUfQKoHc7Dm7op4yXsaotKFcY5yehoAp7mtWzZ5I5jhkgXuRBBUfCRm2KMqDW8I9iIkEX+EPXhUicRWWEcsWsRtNlen2YkgdeFkzIpVmQ3MnZXjw5WTqI3XPdZvm/msV496dguWYLtX6eLYfz7Tm7TBZTbKW/TXFDbytMKn6wnkJTzADaIGK6jPYX8x/p41Lqiz2Kz8J/cRYoOeAU3dDq/yrYfcitF7CpRFafrFpaBD4oXT1priLCOt+uJu2mALdWBfE6tEBansE+zcC7+6/rXxbnijwFT11UhtmDBzuhoTlwmjJ4RbAs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The runtime nodemask conversion limits source iteration and weight
calculations in do_migrate_pages() to the runtime node range. Reject
userspace source masks containing node IDs at or above nr_node_ids
instead of silently ignoring those bits during migration selection.

Check the full MAX_NUMNODES-wide mask after copying old_nodes and return
-EINVAL if any source bit lies outside the runtime range. Keep the
existing destination permission checks and the do_migrate_pages() API.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 mm/mempolicy.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index ffe4e45cc97d..67e258c62527 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1905,6 +1905,12 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	if (err)
 		goto out;
 
+	/* Source node IDs must fit within the runtime nodemask. */
+	if (__next_node(nr_node_ids - 1, old, MAX_NUMNODES) < MAX_NUMNODES) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	err = get_nodes(new, new_nodes, maxnode);
 	if (err)
 		goto out;
-- 
2.53.0


