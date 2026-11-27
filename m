Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8327606A68C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 23:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qCqhBm0z
Received: by kanga.kvack.org (Postfix)
	id 6F8046B05C2; Fri, 27 Nov 2026 18:02:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE826B05C3; Fri, 27 Nov 2026 18:02:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD386B05C4; Fri, 27 Nov 2026 18:02:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB9DF6B05C2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:02:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 017171A053F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:02:05 +0000 (UTC)
X-FDA: 85482423852.13.CC2523F
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 332638001A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:02:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=qCqhBm0z;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795820523;
	b=eV6eURoxBSDPR7xwbFJ889wpuZgQ4z0XoQV+LvuGAjYib/iGrWUMgGKDnHi0cfZDy9X6/K
	e46G3lmujHPTIfSJ4lRVinf0TxEkB81GUpHo1aRAhFKr0K3vuW00eQnlHEzHdjghyNe7T0
	3duht/FJs6xcjlQW/VWus3DHuYxANvk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795820523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upELllW165M8rDQHr11hFVEi+ObboYVo9EgOybAORCw=;
	b=Q3WlCucx8XuvbmwkhOp2DIuAl4J7uAmlb3ZONBX2K0dYdCNFj+HHX/+TwC6B141k8b0I/A
	sICiHUdCSec7BhkAYyWBQw8DwZ093yyZstGC8anpIei1sAUItxYCV1nB0Hj9TjEfG9AdFJ
	bM1jRMbndGnIqvGTYJG652fs7FDQluI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=qCqhBm0z;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N3xiv9G8ufYI9FATtkLlD+EKnuIH4sKflfhRA0daFPD/u24/fcZSNTpua30rxiu2Mg6O6lMk1rp3se6PVF1YM7qqt3LUrPAh8ZtF+7W4s6rR4h361LUHzOm7B6BndiXVxVzxbbbfSFHRjKWueydwrb1ycq0Wxis3M4yXuNTswqqY2LL85HBOz9Z+IhYW+3S4Sxh8FcvUJxMqddNUSxOrZ6KvToY4HPij2iPEgEjoA8c84TWcRl8nQOMa5WPuyB8Ut0ufl7MVgNCHIryIJmkd/3KsxSouO2/KdZukIz/XJOpd7lqG1iWzJf2uIMpdgp5SIUsL0WXp6v7nX5nL9JJQ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upELllW165M8rDQHr11hFVEi+ObboYVo9EgOybAORCw=;
 b=hACD2clB5ulu/6Ztof8eUAI8AwzfP+1bry8TlMq0YOwNxXKYHelGSLbpSirYbDGfvsUHX6O0bU8pwuqykZ0ckMlE867VnFuXg+3XrJ7ZFFtkzrh0+MWrzjJNv3etnm3q5gRh98a3uT4Netv7VKDJYNs8XS0wPQt1pgyS6PRo0SFOAm4/u8WkBVVaF/H/lNjaAAaoP20t3MFGVy+2qDyp5u7jNynhIIlZ97lfme/BuBbCGDvCnwy7qS8nWak5Kn4KEp+4xi17YJZTwPPYvUYTmhvoXr91UTTZ3rxVbnoVxYPjsTwHR7CBkWoHnSfTkC7QJ9UNhE5qkm1JZXk2PHNJ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upELllW165M8rDQHr11hFVEi+ObboYVo9EgOybAORCw=;
 b=qCqhBm0z0xtJ8GlPA19sNFx8A7XixlT2l6bfiFsLVHSY6QRaWUiLnvp9ulTryIkzR8Rlo5zoIoTDcdTO5ycpdLnE2X22S3jvCs3gnk39coG4ZIJvj1HCuEJqt2+lFLKNSOv9LQilYuA1UhC0qE+VN8X5bOCmDu32srFYbdiLkfRZZcIVlQMjcgW6HdCg1jXMdno3VJSKTs/PPEZ8dQVFP/wt9Uk/Bp/BiPKvHMB17eUO4zgeKpowSWQrtlYeC9NH52w9cbQEyg67hcGjqOmQW8A0y7dM0ivPyF7uVF/X08RtjXyGuQ73ptfrbbEBOoeYAT3vSUxZQa6pZI/zdYJIWA==
Received: from SN6PR12MB2814.namprd12.prod.outlook.com (2603:10b6:805:72::33)
 by IA0PR12MB7505.namprd12.prod.outlook.com (2603:10b6:208:443::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Fri, 27 Nov
 2026 23:01:50 +0000
Received: from SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59]) by SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59%6]) with mapi id 15.21.0662.004; Fri, 27 Nov 2026
 23:01:50 +0000
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
Subject: [PATCH 09/11] nodemask: add nodes_copy_and_extend()
Date: Fri, 27 Nov 2026 18:01:26 -0500
Message-ID: <20261127230128.111933-10-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127230128.111933-1-ynorov@nvidia.com>
References: <20261127230128.111933-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0880.namprd03.prod.outlook.com
 (2603:10b6:408:13c::15) To SN6PR12MB2814.namprd12.prod.outlook.com
 (2603:10b6:805:72::33)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2814:EE_|IA0PR12MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b431000-0210-40e7-29ee-08df4cda6bf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|7416014|921020|10067099003|56012099006|261026140227099003|261026121527099003|261028144727099003|261021121427099003|261022105027099003|261102123227099003|261009223027099003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	K6MPCuUSBzZZwiIWVijzIdTOAtOLWzYY1dV3nIILtHpADLvxArvgANJIhva/Eh2cYEsr2WcuE5iT1ebkpwQ3Ow5RpPbiajNerf6GGsGVY2GOhpcd6z+a3PC7qp5tj867JdJNFTkhDrV3NB31qI2RFIabyDBJ9ZG2yjXcYJsuYFe0TqaeTNU67r4Dr8MY5yaSxVmofO4F1G/JVzvju+ubTAQmLnIriQT2OfRBjkh3Tjv2mpd8YNEFZ77jpJepBWf+kbiir4Am3fQgMlOx32ks04ujQPWqmIGtqE8K2tspovNP5iz8VbzCcy2vXbUh+nu0C/fBpOPjn/qeuu8bDY2tYEyvMnifCUtWjZeqrE1iBAxk/lXDIBopbg/zwOrnoD+Hcav78z44eXI+E3vBkiXdSybMcYEVO6tvHDXUMwec5ne+83KYKvw00AoqEugYqSP0ev+KUTz5Yiy80dmrbiqMZEfEngScULYQuhDsx/tzczcL4GkDN50/0a/zbOxm/PwsPYUiQfppXXAzCjt1rQhPq5CNEjRdRPAah4HDdrTiSQ+UqR7mFOgTgfds3VqZAwalbQlLYjncwbUVoUQ+nZU3xgxkW0TxFCAiSWWTGM/pn3U90ZrKFgIklS2cFXuxxF5o2tYtBbw644fapwZz2QJ3alBei5+z/xQDSEO1j+abKw+HSS4BU+ANlTokHnE9k37B7ymx9n4Uhh2JjZORPeltrg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2814.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(10067099003)(56012099006)(261026140227099003)(261026121527099003)(261028144727099003)(261021121427099003)(261022105027099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r0yCM423bmoS22oSW8SwZ4EQfMj2o2nt4sOhkpuNnO7fT4ZRtwME52mYLohK?=
 =?us-ascii?Q?bZ47zr4ewN1KCXilAljaZsG0SpNJeFWBKkplXx8mYZkkh2YT8u0Gk5m4DT0o?=
 =?us-ascii?Q?LmNiVfL9lKcyElmO7d7bxU539r2PKIvPsZ5KfeU7tBgsUe8y/OjENKvY7zfI?=
 =?us-ascii?Q?M+EgQIlt/slcsCHWfb+BoLci2DOUEKHWhx/xLnDAIIOIpe695w9XF8JjUlVs?=
 =?us-ascii?Q?pbt804MPI1pikNF/9+qYY03QOgLFJJ46XfeytubpIFIDbBYHzq5rdB536pQ9?=
 =?us-ascii?Q?wZESeqzRzFM06fZqF5XC3OQBGddkyjCy5txNo3rMZ0QH7w+XWY0KoE1C38Hv?=
 =?us-ascii?Q?Ruv1GChyEWH+GS1a5wXptY4xVaVVg29Q4y2NY/t2SBSVQsXnGpsGVoYhTCjp?=
 =?us-ascii?Q?z29Gdf3paB9u9FfN+5pezdy87P7Rns5zd9FC2Uq07LCz1wHWaegmyj+TWwtA?=
 =?us-ascii?Q?A9lLUxjePxABakbmctQjhkZ2+N50aVz2+qFeFmyexPSH+qtLNWfupJKaO+4S?=
 =?us-ascii?Q?ymacnPJRu0Vbw1r5k1agoHOvFp/Y99YL5k3rKtG55/u0srFarbQ1SduU6EMA?=
 =?us-ascii?Q?s0Xdh9Nu2bdjoO16wqKoI21DzlqeSKEOVp+pTgj1mXQPueqNrK708Y2kZm+c?=
 =?us-ascii?Q?+OXaxGYcfeCwcZ55bHWM+wv8DuQNWv5Jn5bwXrRi2iSCazcGEEfYXK7MDogk?=
 =?us-ascii?Q?8v+58pmTDkUUuQZ/mm/GOItqsDlPBdv0RhKcLA3bQS9g2lCKEQNj1Ht2cI/m?=
 =?us-ascii?Q?3p1IzAJjgqzMeupsio2XjeZYczGRVC1zi0myuHTnAnP1OxnMjxAaKMZ+UQoA?=
 =?us-ascii?Q?2NCnRR7rnj5iNviH5REDjVWX6NGcHqUEWeKsnRyjW+ioQZHapkb1nrtg0M5D?=
 =?us-ascii?Q?Fh2xnpRCJYZOxfDuUQQCsxpae4a8pgffMUOB7K0FsKnrvdp+IjKLcm2cBPIn?=
 =?us-ascii?Q?GCR6OeRQWHYqCkVW9Nm1Uh3JgRuqSdPHXJYNqO+T/MDdKqdZNEOwQqu6Za28?=
 =?us-ascii?Q?8lXIzQTDru+CFWW8zrUrqsAvi/dBEzLfDe84uJvuY3zxLGMATTaHPP+MQyQG?=
 =?us-ascii?Q?da4BZlEgH49nTPsEoe2XjkpSa6Rn7ly82Dh9dWAAsf7MglfSKU/749SF6x9r?=
 =?us-ascii?Q?6pcw59VW4s+Dgu/2FgWacGnQIlROUI6sKuFKNw1GXQSBF1AvAOtyFcCqh+T/?=
 =?us-ascii?Q?RjHlcwnS99uxpmlDdvy3x+KYh8CnnpsCcOzKJ06TkIdlvtO5652x6yfsg4JM?=
 =?us-ascii?Q?uexVQLSHsmx8FX+TpHYTokutWQN/EsieRVYBVICXaTdDZKZmu4M6V/gGRKm6?=
 =?us-ascii?Q?woquld8sOiNN6EZ6g5VIVavDMzD05/9MAiTJUqayqcYvTCoc/1gPnuwMWo7l?=
 =?us-ascii?Q?9GKl5vj4s4Ezor60BnwJkC4nHL/UaORtTI8gPgogKdL6sFzmvO4X9pUeGws2?=
 =?us-ascii?Q?YTk6vzW7gy604SnMVHHnwCGKuhnS+x8lAE7FJYwv+aNBpxTbg94+e/4yljOT?=
 =?us-ascii?Q?jU+1bnc0vApp5jp16z745bqSo67TXVc1bm/oxio1uDxhDegbFsvNP8lwKaKY?=
 =?us-ascii?Q?amXqYgRG15PCV/8o/7EVGhMAVT1P8QBOA4gta85FT+ScimMB+1LUt5WdLuCv?=
 =?us-ascii?Q?CxMAp/s4cxViBFxME53KrvzdbSkR3Z1KdMqmarakxnJqAady4eGn27N3O/2I?=
 =?us-ascii?Q?eyW9VLSTeNGO/XPsscXwV4qfbFPYimVd6NTlIg4k3VF9aypvfZhjoUM/0ZGp?=
 =?us-ascii?Q?8KUANuKP24bNpnc5aUexPOTCmayNwpCM/4ZVVhgtf8x6e5PDC/tX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b431000-0210-40e7-29ee-08df4cda6bf6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2814.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 23:01:50.8911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xutmC9PsND9k6Av5JEkrdEj7746kkmhl2+gCYJhFSjUEkj92Sz9UkA+TLwNwVNpWvkiLuCGiq5mO5iUXF+gABw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7505
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 332638001A
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mudyt3oxhrmmo8yenryjy8brpqugzkmi
X-HE-Tag: 1795820523-285211
X-HE-Meta: U2FsdGVkX1890cuxbK2Z+nZ2dtgswnLMm+4FLUcU9ipGb8qde3SUkJFaRKf1p94QfdyQqij+B7et3wv3VtY0r0BhGXkwpj3FpsnSn6KNvy7+15rBtsV8l2v9CXffPGKmScj309exUq+UCp44DEONL2i9FqAEQIQGRgD/VaLI7uhyz3Sc8KB2hG67e2RkygehgHgQ3OFeTgjRxcL4eA6R1OwudU/y+Chuk+Cv+SJQiXW0gcP6+LbTm1Jtfygzlj9lW5fJ7FtLL/m8KjrKGUrNL42uaaUiGCbwCTiLtxfct2cWbXnADtPGtYs1R8e01Vd/3igYkmH+V3h42Rh1clkHDzlkW+pbTbkYvVsFcxKTBG6mOZ8Bf/PN2V/vSk1zQY/xjPxmCLXTE949ilKo2Ai0xjPlK5YBi+kZwV5dw6vdYnaELbZe9QHZiLiNr6payues+OF30x74tL0mtHKNgnkKKXR8VgtmGiNrNIjHceBxqvDl1pKvd29g1iUOvBhxqnPxElsTsxYfLg8IaAZwo82fRVTsYRaH74X3OhVCJ+OO9jZuq1iKCxgzNZf5S67WlnVaOPzWOsB04u6dLK70rc/TEFXevUXwRRLm/ag+NibEDCWbfw2HoTTH1kW54+ZLO3sIWcTHgxFbmSXrO1tJiZls5OsVSkfUgvFSidENiYHBViTsHa5yePyZgyScJBvB/E/YSUIocalfJijB1KmtbT1qbMZMnQhp8dtu9uCVIrW3XZc9HxnMwgpH2CYp147l0KkOkdLccPtmOKgf835emrs3Uey9ns9BQ6v7L5mopdItoaeGv+t9KLOFyEdebhXYuBeG0ebK3KtQkiwYejMH8FNzkVB3ZOwVUO3SHGCt9Olc9d+9MmB1lY98U58jnZZk7lk2lBagpPBMcZnKq5o2km9eIQz1aY9sQt7BXZtNGEZhX2UlDyxRHe5c8CZ3Ha2DMkVvntLW+3lEfwyNZNnkOTt
 ztT6fJly
 ETG6V7oqa3oGmitYjMcGl6gNukKKurwUTSbfCmEwyTv0IVXzWSQ5LBMGgdDnhTiSe/TjpH0zMfLlVkxTnCQRf5M4pWuEZZ0pgPAjZfDDBhCDHrwenfQntTpZ3qYerqt1Jrt59IoAUgyfh1G5PBNA8WHpz/lKrOjkElGt6XxIa+gLrFB364PF1tKY3QCQWcuqTJjplGkgNFu3LVfO3uXk5GY/h/0xB2HGMCqbB5NjPnucgKvMCzQFfeBm5nYWplWkC8JT/kat4vWdv8vt8UVI+nuNevxOhZIMqvgEv7xoBOIoAgrYXDcFm97UrgrePVOPADecWRQEo58NuPB191c+2jGVPcI1WSMqQu8s4Y32SUlNtIMCUstOpdx6kNQLGaNoRGJxVqiK4c4WIgEYWm/0ISRzSwLYGe9b5Hbzi3g/tZ2VmVL/i8SKeX9TFYLzVSzX67HNTTvfuMgHXU6SsTs3xrXKEM/hDZpnYN7pV7NZFUZIlDyYG0zfjJYjOvT/+s55nLcawzv5vaFHBBGBcyNPC7yQ1aHRYQqdyBe/t0f/oiXQbVEo/L+8SxlCi41t25atwhDxfEmwd6sPOdcHveGUpdcbWdVwAPlMs5TGamRlovOCXUWvoyf0pQNnwDxB4Ni8vvtqR80Z0OLrRRwzvXoX2iNlj70r5Uq0yTjpoot4VUADJoO8PszwVgl2yQgL2+3LYLt2xY9cJ12csvXHCM0I5S+3Nli8giSMEDLWQ09lERNMGrb22/Y+LjVvWEF8Rxb4EyToKQbj2tC/Ekfmx/I+bdjwHtltjwPAmBW563/SuwYGZ4gAfyjqGBKmWYINqRnOrreG1hwTcyxq0al0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add nodes_copy_and_extend() to copy the nr_node_ids range and clear all
remaining bits in the destination's MAX_NUMNODES-sized storage.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/nodemask.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index a17aa5c2e562..4ef6ca642054 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -30,6 +30,7 @@
  * void nodes_or(dst, src1, src2)	dst = src1 | src2  [union]
  * void nodes_xor(dst, src1, src2)	dst = src1 ^ src2
  * bool nodes_andnot(dst, src1, src2)	dst = src1 & ~src2
+ * void nodes_copy_and_extend(dst, src)	Copy runtime nodes, clear remaining bits
  * void nodes_complement(dst, src)	dst = ~src
  *
  * bool nodes_equal(mask1, mask2)	Does mask1 == mask2?
@@ -218,6 +219,16 @@ static __always_inline void __nodes_copy(nodemask_t *dstp,
 	bitmap_copy(dstp->bits, srcp->bits, nbits);
 }
 
+/* Copy runtime nodes and clear the rest of the destination's storage. */
+#define nodes_copy_and_extend(dst, src) \
+		__nodes_copy_and_extend(&(dst), &(src), nr_node_ids, MAX_NUMNODES)
+static __always_inline void __nodes_copy_and_extend(nodemask_t *dstp,
+					const nodemask_t *srcp,
+					unsigned int nbits, unsigned int size)
+{
+	bitmap_copy_and_extend(dstp->bits, srcp->bits, nbits, size);
+}
+
 #define nodes_complement(dst, src) \
 			__nodes_complement(&(dst), &(src), MAX_NUMNODES)
 static __always_inline void __nodes_complement(nodemask_t *dstp,
-- 
2.53.0


