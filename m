Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06C96C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1395D6B0093; Mon, 14 Sep 2026 10:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB156B00A6; Mon, 14 Sep 2026 10:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECDAF6B00AE; Mon, 14 Sep 2026 10:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1F56B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:28:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16ABCA014B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:28:02 +0000 (UTC)
X-FDA: 85212597204.22.3CF9730
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010015.outbound.protection.outlook.com [52.101.69.15])
	by imf12.hostedemail.com (Postfix) with ESMTP id 13B3840004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:27:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CajgCHwv;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CajgCHwv;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf12.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.69.15 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789396078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q96gATrUbUR0fNAZfspTOLhOnG/Q6l4kaViCzTAeDH8=;
	b=zYVz5CiJd8PBNYb8fYvmFbXVWXmb5BtiWf9KhdKn/No/+5ztrYW28p2w6zUivBrybD3qBO
	/wX98DKLm++fcrncuSzVgdSsF8gKQmcSQyf7o2OzLb/PCvFH6b1wHstrHJZdni/d633IdQ
	Gfqu07/fMO1oK0H4PK8sPgDSNtlct1Q=
ARC-Authentication-Results: i=3;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CajgCHwv;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CajgCHwv;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf12.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.69.15 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789396078;
	b=i6gb5kURkJWeaVZ9HPjzmM7pbHWfh3KThOdamwH/Vceot4ln0lT71Wc9Y9IeMLRNdBZYkS
	8tUlBWo8vDfP+BQAptsKp0hBWcfbjGsnsEQEFHXYHFfkclhgXcuave0lj8VLNiFG/K/2mc
	2vqQMvmQmw90sNup/HK5xMbaTrQLF6Y=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PpbQiML79cwS/Mf8O0Rk7owZujki0rksDdePFXtq4e+FYZinNaEeXm6od7B+dEzKJ1we13B6yUkMwsGljRRcWinrNc4odgqYSZ9XqRyyD1isuD7ujsH+VXT2nEUqusY58alcIGrUI764QzoNI0eutCqrZr/YdvpRs98nQrKctN/BqOfJ78qawmWRRW/iRVe4mA+5M/+YNzQP7T+HmEn+if2KssmSTAS9vd/NrpzbOjQ9PIjP5arjXcnHxQJs3DyAbAqZxNtXc907eIbfUA4wfJg1A2Zo0vphzTIjABKstu7d9+xFfkXc7mRd10iFuCmbK5WlKF7+9fncIDGHZmRhOQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q96gATrUbUR0fNAZfspTOLhOnG/Q6l4kaViCzTAeDH8=;
 b=uBDtjZ/wOrhG0QLOgMJ+/KFV5ujL50Ign1ZVAkgO4ilwc6I3uX9qe8/jVatiKy3iGxxrU5rVKJCFoz1qhxzEfxy7QKsRDdvaNgRjaCSuE+hJszTjdPCMGn74rqW43VX++kY+C3OWp345uphPatPC9dm7LZZKAfVy/kZGg4xHyHCNcxedXc/PoUUXtp84IYYdwip1RnhqXB/uzXFsCYph2GEoTiE7uI4Q84qj7bAxI0ZsaRkaEdog4biRU7Ce+qwJKjMSXI/nw73oXTXCUEavntYB01RbjbEhc3aK9aqzIcNh9ZLCjItn38jo+/PXN8zT/KTfPffXBrRvMo1gWV9x+w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q96gATrUbUR0fNAZfspTOLhOnG/Q6l4kaViCzTAeDH8=;
 b=CajgCHwvjm1945f923+pGJXwFutOcYDhNNei1u6AtcmC3HlH/OPYz0/p0wetpIxNo2Kv82DRErqMX+YlkuHfDAHEQdcDDj90KmbCj6NmvBZv191hjCxklfzxEPo/Z1AZM0rKU9s276VBAdDunF3pjpZ+YGw+NaCgucq+cj/Q4eI=
Received: from DU2PR04CA0158.eurprd04.prod.outlook.com (2603:10a6:10:2b0::13)
 by AS8PR08MB6232.eurprd08.prod.outlook.com (2603:10a6:20b:296::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.8; Mon, 14 Sep
 2026 14:27:49 +0000
Received: from DB1PEPF000509E5.eurprd03.prod.outlook.com
 (2603:10a6:10:2b0:cafe::a9) by DU2PR04CA0158.outlook.office365.com
 (2603:10a6:10:2b0::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Mon,
 14 Sep 2026 14:27:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E5.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.7
 via Frontend Transport; Mon, 14 Sep 2026 14:27:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F9KV7u71QswuU+0zbfVrY3DlPlQgB3pRKOG1An/XUBk9/MO4UhQuhaHFSovix/vNfs8Aad42B4lo6C18we8BMd6LOk2+Ym2Vhv+YyFxt/lbKkh2kq+cbuBYzTkcH3nWG10Xd5Pwz+dMKBZzLCnkVxDcb13hUGXkZDXbdUm6+xgjfNMrW8MTBcZZDDc3p/PFuWibbML9xwCTZwnV6IJVtbifbl43+JBeI1WlT9XP3r9hrnI9E7ox+TVGCfAgEuiVLh1ta7JfzKoIVbnn0KvjfRIibsAnWpYFrT8zLm/qkDQdAsELDosn9xGLPJuSjRWjEubAB1LL04/AQ2jFBcZuk9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q96gATrUbUR0fNAZfspTOLhOnG/Q6l4kaViCzTAeDH8=;
 b=bWe4uqgVCK7sWClD4LkTW9t9is7KjjfmDxqogwyY8SX/zoZ8jUMEm5EDCkMolM3Ma3J5ExdNjM0peUh5UEueJpdZ01Y4qoFu7Mt1xKDL+ZHySoeg4crsNhcIPpfnXAgG6Cv/gPPPds9KeJJhXNQx9FGPl5dwNKVsdMKTQH2U9y823gg4sXQjqHpgwimGsTES0TcpaTiinwpvjS/lfvDlp1i9yi3qh46ZxjS+ES/eFky020hBKRfSSYN6ZidQza5FY5pYFy/t6CisYXenpRuc7Y4kdzyj2Dv0qrK3cA2OrA+culFUR9kIOX88cr/VwipPK07N54+gydOUSvt8AGc78A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q96gATrUbUR0fNAZfspTOLhOnG/Q6l4kaViCzTAeDH8=;
 b=CajgCHwvjm1945f923+pGJXwFutOcYDhNNei1u6AtcmC3HlH/OPYz0/p0wetpIxNo2Kv82DRErqMX+YlkuHfDAHEQdcDDj90KmbCj6NmvBZv191hjCxklfzxEPo/Z1AZM0rKU9s276VBAdDunF3pjpZ+YGw+NaCgucq+cj/Q4eI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AS8PR08MB6056.eurprd08.prod.outlook.com (2603:10a6:20b:299::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.8; Mon, 14 Sep
 2026 14:27:14 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0428.004; Mon, 14 Sep 2026
 14:27:14 +0000
Message-ID: <9edaff57-de65-4335-8439-823519a502ee@arm.com>
Date: Mon, 14 Sep 2026 15:27:11 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com
Subject: Re: [PATCH v2 0/8] mm: distinguish PTE table storage from PTE values
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20260903103002.1091859-1-usama.anjum@arm.com>
 <dd6ecac2-9bd2-4184-a034-9e13afa614bb@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <dd6ecac2-9bd2-4184-a034-9e13afa614bb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P195CA0001.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::6) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AS8PR08MB6056:EE_|DB1PEPF000509E5:EE_|AS8PR08MB6232:EE_
X-MS-Office365-Filtering-Correlation-Id: 314c31fd-cf09-48b0-f0cc-08df126c5a53
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|22082099003|10063799003|18002099003|56012099006|11063799006|3023799007|4143699003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 UEMSfUJEaWEajDBturqJu6KW8OYyxCGj8nkyovMvwn6ArMMLLn0c3260UK/wwdFEds3bDLkZUL3NYQhL7jYtpl65ogJB8E+BDguKdgMC8vDX9B48giOr4GcSHNIUeIeXWWqNTZWGLtEBN37eH7v8cArvKr2Erz1nGnf3vFssgA5sc1cyluR+2wKTkTFKgxz9/ZY1ggnEAjazixd2NqALzjzp2Qd5pst9e6/ytHWlzgf6nv29Ks23/8sKt1tT66FvMtI3nR7zczlGJoWKblIc8bKzB4NJtByP/W0KJ2veaNvTL7cpY9v54fREMsTK5dT43T6kLLXLKkEKCBxFk9dLUhXT0++I8bJi+hvWJ3ykzxUtSs8SvJQ0M6iKf/1BV1FyiElrfpu+hzECNlxsMUpVxtya/TwSXiUI9UPuYGhdZIn1hGwt4J7SLouk4pREPvnW/LZ4dn+rERAJGRBF1puD9dKQuPYTvH702Ko0tjytyjmnCbuhgfVIXHJi04kSxQdhxvPLRxXTracWEGen2WFuCkn0+2dwXVlc8pVfCanSEtEaKfVdDY3o2Ao8tHnyWsct8vBZDLy2nXbmcEBFsi6BJp107FlUKmXkH7yqWFFL/wccbCitMCeUbjGOO/QI2tpwMbEjf/EsPpQzixJi/gEpS9YMAqyL163dv00gMJTq1e0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(22082099003)(10063799003)(18002099003)(56012099006)(11063799006)(3023799007)(4143699003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 Ox0ApicW/xsZTDWWGbIPRo4yID+i+qX2712xjmA8XjBvFrKMx5C+tb5VfmTFicxgxlewKc9OgzJPg6jh2ybwtadXL477GSd2jxXRjrUGFLbT8TdFcR7exGsRGvhuEihw7meD4UQ9iyDkomf7xIdqlmF8inCM2yXnjGx4ISSmGoSi250o4sJGhGQ/bbyX8xaRbqs5Hkhv52+Zm/76e98xCM+z8YxROeWjSENtO3wf8DNYRI0vuJdtAUOp2n6diwN14izvLHXhn99hfG+8bkfZaFzzLTmQrTwE3crm2CHvk8SnIrp4j+rKiHObtz1HZ3NLrysHib1aIOMyNJTeg9x73w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6056
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	372fb2b5-2aa8-446c-f3b8-08df126c45b1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|14060799003|1800799024|82310400026|23010399003|35042699022|36860700016|13003099007|10063799003|4143699003|11063799006|56012099006|6133799003|22082099003|18002099003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	4ogOTScx6ErN5/M/7+VF5xKhLzmxGm4GC8n7UWC01odvgAJAEZHWaRGn8D6N1JOJ792ypYrN6XHDHkL0NoYLWDHNU3aph+okWZGAeXzGFQ2MXNGMnIxQ3Q30vicrjlVYI1Qn0h7AJjyXh5tHKr0ZQJCzfh7C7KuBYOVUOgpUvxf7X+AJct8w300RQnf8KKdsn8ae/BAI+3xOEVhZfzgBVROPQjjeoygLwvN+XRGrl5vhGZOiTyTfvDwd9zEnlBgROSZgrxCkVnztZ+HLRqI7dSBqCpTNv1CPQTNfzY2gjXEGktRcAo7ur+K6aEsNGrhQJUD+sBa6kaoGbo2pIENHf87ihSBnxswuwngaRw7CD6m3/uq87A52UciThDOFrFVp9u2sGKZXoLeSJAConMzLpH3k/SshD8H+5+sQ/wZgsrpjaSpJ0WP95Ncey+MgBG563Y84Jm7srdpqkATjyb/dJqBasODoavijNSGhazaaDf8KMGcjUGaQ05rZDeYejDI/x61QEnxW+iAIv9QUrf0va3qpkuxb1vdMr77y+gTxQESE7v6HRzEdKJCFwrVWW2yvfzQlS66AYeRZzz9nJZ6W5YDQWuDvQ0F9uRSC7fh/hNCEdXhc8LHl1fSAc2l4Xaz7glLSKXnZLSRpiRP4Z7C4t/M7VQwpYcubJ+d6gcbfJzS2F93dfgT2ppbjSN1vBPhF+gFvEVpIJ7227UybkDHDew==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(14060799003)(1800799024)(82310400026)(23010399003)(35042699022)(36860700016)(13003099007)(10063799003)(4143699003)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZGMEqhFUi2qhN1Lau3ZeSYgSkk85im6sY2Oo3siiB3KWw+svQD6+JA/ceJFkEG7Xy0hpgo8RlV1zeb8jrPhbA0gtWWX/aJaEmdl/WoZ69cuLy/wGJtajbRaEbHEC1jk5Q7H55rFl7/jBDhtiBRZ0laSQGCGwnmokT6E3IFDr+Z4qB/tsEpINP6fVdZAsgUCibeSURBFVJaMDZwr+7BnUiiEKPh9FpG7vFuHEx2iz8mgshmT15GHzlc6evfAvdED8wO+p5oIeEQcrfWLMdBhP6+IJtikJm7xnv3tzfsl+aag9IAOFGNZe+JRz11n6wAI2Vx2Y6PkszSSCsdUiKYeBQEZYMjDg78IUKoQFBI4DcW+BAFabpFUPhRhuzxUeQW0NDBHEwdvudXrH2LRuwJcyvZqkuAJC6OMt/5FObWJt3rlmmCaDv7CR4inUC0vxr3NJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 14:27:49.0313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 314c31fd-cf09-48b0-f0cc-08df126c5a53
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6232
X-Rspam-User: 
X-Stat-Signature: ukzayzogdyerob63du3gg4heoh8efni1
X-Rspamd-Queue-Id: 13B3840004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789396077-762101
X-HE-Meta: U2FsdGVkX1+ai9OT1NPl/p7LPv0R6kvgn3Otlwbxg/SxkgZnRI5EuQhxSzPQ/te279vnogxosGEnDWlgNr6mZtcXE3culfZHviBWQTA4xvFLcSuekxa6OPAiDxeNY3RHLmKIjB6B00BoK4+IN7vTdvT4VhbN5UpUiWPgizI/w9wfA3ECv5JGbobBr7mfkGIA+HScuq7Ti0VtzSPlOoKDvphlzFhn1dfSgX8uusPqZmAmQRXHIUE1QWkyiPxypl/yISD7LF4qte7I3jz4ZMMxjBaEMX0I4c4SOZH2V6i2wYSwJJHkJYqhHZBnJZp1QwhD7if3O5jH6LN3L3S/C71bEAWvgmlbRMxcOL5OceJIY4GYiwPT0XACfPIHLruswZIn2vvLCYoLyo3Khjbyjj4+ZFjz2f5fJ/MTeCkyxfy4qIzGdhEU+86ZtrlOEN9b1jxyMECHoPRbPaEVMoBnzT1hFBf9/OPtNcvrHZbbZAvQCMO6Lv6IoiHz4ZMPZK9jW3U10zG6jsafDU+3voHMW+e9PQmIcVLGANG6voMs2VmwFVMcZR/GQGEXKgj1alBkNOidFVJ1oHRhkKtYPI6c+EwAXzcp8j7wo7o0dTmSDxwYzdi7x7+4rf9DGnIq5zmBgCIDeE1iFGtPBH6GsI4LiBlH88Gzw3+68TT1dPTOcCmytwbS/me3Au0mpmyH1Iqwf0IPO+trVwCvzsbDnbqb8XY6OhyW/JjSAu2ittViSiwoRxA6KFI7opNL4XQ26/a22B8OKBmVA7avgRf1+lLoO9d2Me01+wIWlNw4JS98nXCYUUgsWXAPoVFNqJ+J9yKd5S/53k3SFIJqFHk4Ncibm7cntt7nuQyBf+PmPI82JJvUanMMLl3W0Nmq7iC7VEw4X6SmsKg7Ar4J2tzaPCjyKoE31Ec2J+A59pAIdd9pmDgM8vSTn3U1eCUFE1GPLOLhOPWcmmaNwZgFtsgAblRrkI5
 ePFosPj4
 ybXEWt7dnMw0KApmX/nkDvJdxtrIzzK7oftfkgqTkPC9lOzDWX15jGtk6uIRcmud277/cDOzxUIivM4F2tzLRulp2cWDWsJMGzz3kUFIcLIYJ8fo1bDEexP2pklzO3nmK1POjUO1mS6viPyVbBT2RJT1vnMlJmZXrQxFE2rI+5ZNEKi8T4VH8jTXSbgGH46pgL19HGzR03F2Mn8x9Gs8qTuoQFfZrZ9hjpK2TVfzV3+VOFmZ4tHlrEeQKctRl/YSN4Tlk4+MKQPj99xRFX2dsp9zJSjcbiX3gO7K3aNFLMnwn0EnRoB5iFa5ZxFQL72vxDj8d7SMHPdjL01s1tvYXAGTrugVra4Ivri/OSlUGAGXZ5TJ9g/+ka19SqCoVIorq09PMv8MN9hyZyV/vgXI1Og06ETkRyvdCz70LWZqVKeDCEz3ri7QelgMVP3XXYsdtwOcADl+MMXNHV2l6oeV74OQ3BajucWCrluu2uNVGts/9kEn+6x8XR/fumbcr1tD1VWSn8W0Xh5H13h6HjBnJimw5icAuM0uBYTSpNolOGuCD7mxSAs0A2pj4KLUYM3P6pSDmY69Ww8fhz9H+Nm5flqAJGG8XS/5u762WLYeYvK3iFJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/09/2026 5:55 pm, David Hildenbrand (Arm) wrote:
> On 9/3/26 12:29, Muhammad Usama Anjum wrote:
>> Hi,
>>
>> pte_t currently describes both a software PTE value and an element stored
>> in a PTE table. Consequently, pte_t * can point either to a software PTE
>> value, often a stack copy, or to a PTE-table slot. The compiler cannot
>> distinguish these cases. A value pointer can therefore be passed to an
>> interface that expects table storage, while table storage can be read by
>> direct dereference instead of the architecture accessor.
>>
>> This series begins a staged conversion at the PTE level. It introduces
>> hw_pte_t as the element type for PTE-table storage and converts generic
>> MM to use hw_pte_t *. Software PTE values remain pte_t. Interfaces that
>> intentionally return a value through pte_t *, such as install_pte,
>> remain value interfaces; the relevant parameters are named ptentp to
>> make that distinction explicit.
>>
>> The generic definition aliases hw_pte_t to pte_t unless an architecture
>> selects ARCH_HAS_HW_PTE_T, which enables a distinct generic wrapper named
>> __hw_pte_t. Some architectures define pgtable_t in headers parsed before
>> the generic hw_pte_t typedef is visible. The structure tag allows those
>> headers to define pgtable_t as struct __hw_pte_t * without creating an
>> include-order dependency. This is required when converting s390, m68k,
>> powerpc and sparc.
>>
>> No architecture selects ARCH_HAS_HW_PTE_T in this series, so the
>> representation and behavior of every architecture are preserved. ptep_get()
>> keeps its existing READ_ONCE() semantics and converts the stored element
>> through __pte_from_hw(). An architecture can later select the option and
>> convert its PTE interfaces to make the distinction compiler-enforced.
>> Architecture PTE implementations and most architecture code are
>> deliberately left for those later opt-in conversions.
>>
>> Here, hw_pte_t identifies PTE-table storage rather than table lifetime:
>> complete PTE tables use hw_pte_t whether or not they are currently
>> linked into a page-table hierarchy, while software PTE values use
>> pte_t. The distinction between complete but unlinked tables and
>> hardware-reachable tables was raised during discussion and remains an
>> important point for review.
>>
>> PMD, PUD, P4D and PGD storage are deliberately out of scope. They can be
>> converted in later series after the PTE boundary is agreed, avoiding the
>> PMD-specific cases that made an all-level conversion difficult to
>> review.
>>
>> Most mechanical pointer conversions were generated with the Coccinelle
>> script included below, then audited and fixed by hand.
>>
>> This series does not add a second ptep_get_once() accessor and does not
>> remove or replace STRICT_MM_TYPECHECKS.
>>
>> The design discussion is available at [1]; while the original idea came
>> from [2].
>>
>> I've the patches here [3] for arm64 conversion which I used to find
>> usages in generic code which I missed during development. These would be
>> sent separately.
> 
> Unless there is more feedback on the overall approach, the next step for this is
> to have at least one architecture support posted.
> 
> We should only merge this if at least one architecture (better two? :) arm64 and
> s390x? ) would merge the architecture bits.
> 
> That is, we should get an ACK from the arch maintainer son the common code bits
> and the arch bits.
> 

Thank you for reviewing the series. I've posted the patches for arm64 just
now [1]. Let's wait for arm64 maintainers to ACK the patches.

[1] https://lore.kernel.org/all/20260914-pte0_arm-v1-0-bb53b663e396@arm.com 

-- 
Thanks,
Usama

