Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8667ECA5FC4
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 17:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3605D6B0088; Wed, 30 Sep 2026 13:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310806B008A; Wed, 30 Sep 2026 13:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1006B008C; Wed, 30 Sep 2026 13:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E45456B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:41:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 732EE120198
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:41:20 +0000 (UTC)
X-FDA: 85271145120.01.B42C0DA
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011044.outbound.protection.outlook.com [52.101.70.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6D27380009
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:41:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=oDOAon48;
	dkim=pass header.d=arm.com header.s=selector1 header.b=oDOAon48;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.44 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790790076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Dj3mza0d7acfswRMgXyXAp0FLYQUvs4v9I7WURo1EM=;
	b=p32bATNs+sNVBqSTT7xqiBkUWSvoDdq2TiK94XsTJon5ZYFCt2CNv2BmRX8gMMS9tNGxRj
	in2Q0ycpMPs0rY3XuZ0VqelXt7nN+yjKNYyNO4AfX0N71WSWjrmRzu3qI5qgxVj8/YYdKt
	O9A2ZCRaq/UplMxE45DONmuj6dNL3PA=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=oDOAon48;
	dkim=pass header.d=arm.com header.s=selector1 header.b=oDOAon48;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.44 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790790076;
	b=qfgmvwOQlS0qq8YknPvaclghj1UHke3LfLu60/7P2HFEqY76Ap0wnWv4dvU5Dfu7bGW5lx
	kNRAGG5AaWy53/UdgyiqanRMO1+qjD/5Q8hR5RzAQUoVWzdgZb42AcYE39jKtVwlgj8tDb
	ygHrfBM/jepZUjAY656HuuCizZR5VW4=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rnmT8kao+W+92vbrU+1X5YqYwSCJzV9dgvDMeKGltPUdCc1kSpS2h9VyOlJAmEFDk4zZOYgww7dk/oAvjjC+lr2TuM3Q3ZGbytMliClaT1mhu2m49Pzl2SvKZCLGfuINNZaFj0Gso9da3LKabAV8ht7DBcl5qoMQfk+Lu5yetWiq64hTfH1k1UUQVOa+zjfgovW8unB7me7tLvbHYVz8/phB5xoaocpaqYJDc+E1JI99XNl9aT2tlmyJTMz3GSTpNjTz+dm068OX1V1zSFb1HLq6kQOucFGAipSET9MehkMYZycMrIFWY4HusmPr5B9OYBiw6UJEdVmLkUdXXGM/2Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Dj3mza0d7acfswRMgXyXAp0FLYQUvs4v9I7WURo1EM=;
 b=wZiqYr0SPoLlLzTjnKBNL1ao93XBR+kDf0TbPItLGPBZpPta+vJE6OCxsbb2TSfHgBXc4Z1K+5qs+tVD+xHySY7EwRqQO9e/tNVi0pfozQaXaVZqPhOJ08adNn/j3OXrHsP3MRz0K4QN4mNdIM20RsEO9t+MUbX5dIHNeMJqugSVTonGmQkmZIcgTGLvkDRjBzCEfOxWe6HGI323vtIE2v6yTqIpwD9nl65cPNimpPzHs0KEZmIJF2CTxruHBqWHdZkZq64+J8TSQfG1owQzKxs3CfM/f7lK5E2z2WquCAseXpjGyQj1BkpxrlCTs7lk874q5CD4rTsu/As6oGfawA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Dj3mza0d7acfswRMgXyXAp0FLYQUvs4v9I7WURo1EM=;
 b=oDOAon48OeBS6pTAWmIZUiQfOFqJqq0xC/o9Tw0s5gOjXQnDoL+hPmSOeIkUgQpL+YkpspeF+nomKaA5eICb+l8wbbqFVNLMc+h2jYeZCLL8eWRyN5teXiYFyGCxF3PiWxHeWL27e/t/Lx4Wc8Ar2gbhQeb+jWPPxZ9fx1sWosc=
Received: from VI1P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::24)
 by DU5PR08MB10677.eurprd08.prod.outlook.com (2603:10a6:10:529::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Wed, 30 Sep
 2026 17:41:08 +0000
Received: from MI3PEPF00008485.eurprd02.prod.outlook.com
 (2603:10a6:802:2a:cafe::7d) by VI1P189CA0011.outlook.office365.com
 (2603:10a6:802:2a::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Wed,
 30 Sep 2026 17:41:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008485.mail.protection.outlook.com (10.167.240.132) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14
 via Frontend Transport; Wed, 30 Sep 2026 17:41:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MUZQb3FAg7yfr2Gmy65jr58i8W7Vn13ARnWdNaUoxX4nsvwmwZAYBAvK52SM7RPBMA2jLKTeQjot5JDkgVcSPC0SS8AwTnJk98aLdlWmxhB5rSXOtR9ObN/iQuVdnX9h+nqy3v5PNsCyJlHIxrBuL8X0wN46uF7tSgaiHR6juqe3StVFe6EsN4NDOC1bxNmKJXhedpIAypEaraZX1M3DGRFk242WiBT7OFtCCP7JdLl0ExLB8cgNGhE/KrUI/Tt0BztagRXiX1POKo2JsuG+t/qydQMUn72csR4mKdNUwNAWwKN7iFmH3KJGd9CWc3hTXN0c/p7FDr7kHl8F0WvnqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Dj3mza0d7acfswRMgXyXAp0FLYQUvs4v9I7WURo1EM=;
 b=VLFluQFA4wUPvgWQqHMQT8kDLgBsVRnxlZBM2UP9tj/aZn2yC8vHyHQ6aCyngsOl2jw1YVXg2vvUYrtRFUOjt2qSKRMJRLXwcLedBPPi/rSTLR6a58omQe6iS0Wy2Qy7j+InZjL+X7H7Nsw8dFepQKnkClXmiELQhiy59cz3a6X+33l1HbEA3fUL/r6kGULXPlrpsGNC4yAIchLd9ZWe9jIqgL+PG4kxLz0UfXY+FTQZGUyBohS33RTOyu6lSBqOGBis73hp3IXIcD6+/uVStswqXKLNKazfxIMVc6Wv1dgJGlfQ/NNyoOrvBOlL+Qg2X0od6iYBNk9IrjA4zDEiHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Dj3mza0d7acfswRMgXyXAp0FLYQUvs4v9I7WURo1EM=;
 b=oDOAon48OeBS6pTAWmIZUiQfOFqJqq0xC/o9Tw0s5gOjXQnDoL+hPmSOeIkUgQpL+YkpspeF+nomKaA5eICb+l8wbbqFVNLMc+h2jYeZCLL8eWRyN5teXiYFyGCxF3PiWxHeWL27e/t/Lx4Wc8Ar2gbhQeb+jWPPxZ9fx1sWosc=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AS8PR08MB9840.eurprd08.prod.outlook.com (2603:10a6:20b:613::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.7; Wed, 30 Sep
 2026 17:40:33 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0472.012; Wed, 30 Sep 2026
 17:40:33 +0000
Message-ID: <63db3469-82d0-4997-9bcf-31bb3aa59deb@arm.com>
Date: Wed, 30 Sep 2026 18:40:28 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
 James Clark <james.clark@linaro.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev,
 kasan-dev@googlegroups.com, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 3/9] mm: use hw_pte_t for generic PTE table storage
To: Anshuman Khandual <anshuman.khandual@arm.com>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-3-5670b8cb9059@arm.com>
 <xzlxdkrjilskjcagnl33eed7ijxrgfhoalmmmq5ks3wgjmkkhi@zchtxpr2amff>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <xzlxdkrjilskjcagnl33eed7ijxrgfhoalmmmq5ks3wgjmkkhi@zchtxpr2amff>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0267.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::7) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AS8PR08MB9840:EE_|MI3PEPF00008485:EE_|DU5PR08MB10677:EE_
X-MS-Office365-Filtering-Correlation-Id: f654edf1-1795-4e27-6e0f-08df1f1a0268
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|6133799003|22082099003|18002099003|10067099003|56012099006|11063799006|3023799007|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 oGI7muJrlZpwF/CpDHEzSDJCtzoqS/F3W423126M4B7XVwwmWQMfuelL6Drv404qx12ulnjM4McoRoH2NEquKYER7GCiXUBW2yAtyKLG5ZfBjfUL99P38usNcVC0HjNO/EWQlAlszKFgqK3QjtoK4jRiTZR7h6q3UCvMmEmJj+Zc9flQRzesGOjw4Bjzlc3JwakYyyuP81YRfDZjr7WXaL/YBEk7WP5Zx6XX8bST7EL+YkcQsAL+jYauBpPQJMJTxHW0+4D6r28jU7hFISb4k5fLhdxsCJMhvjoqyCScUWK2XexS1WeyCKHxbXAiR9Y4lzTTl3bM0wOUObWbYPGoseq1+bd9V+gDvz44n9Z4sZWuclTXfJ797kFqNJ/dPY0hlLRBBtPFczXpxW4Jrwo6fhrvbUxlTKhMYweDNyxCG4hMOWqh3Pr0y8Cb31TKDgfZ4nTLwfT0q+OdTJKI+g3t2OHVEynSCqM+0eNK6RhXhg9pN4QLKVzZrNL/3bJPKMPULVkmlZhCDxhH3d2glFtWSxtnJJjOqVwGHoiEvWxeYzo9pWCj1RGSYhinwWMWpXcHfT1Ts1H82zA8m24Olqxekvt6pCSivv9BdoOTXhQuY5Z51sxkdkvXU/UY5OHdGsaD/0ljbuXWDhq2J61EwuOBFAIVLiLOUXMAB0as2Shst3Q=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006)(3023799007)(4143699003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 ZRh/vaUJ8vPLDwbrpqZLGWjxaIwOvyvt14r+gVvGKmgPPwK2TDTTLFe3d41eOrldXN2Fh6Rlgp30is4w/0Ee+/Iz707w8ulVg8jMkeJmQ9QgGwFHZ5aPzws0sX9jQQk+GVEI8LwKndr1/707rxzO8hbJd1HDaxV8NCyM+pYvcnxP1HNJHpEykUsZ0nxE9BGYRfQ1OVtCbOkU9xW6FoIiOOaiHUJhQJUJf98vL796fhWLRMJ5tWyDNUEy39UrG+G97sssgwv7emKfpTstqUBx5b83Q5zktpXhxsiXlgmkTb7hcUBoY38o6Myeb2CjQybUiRxo5I3mlgrYuef+nXXc+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9840
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008485.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5a3f536c-6b22-4217-dabc-08df1f19ed82
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|23010399003|14060799003|35042699022|36860700016|6133799003|22082099003|18002099003|3023799007|56012099006|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	lKEksvLE37fjc2mwiNSXeiH0ULDoLEwpGCyPCthjhujizaV0pVRBxx78QRZ1fDXyKhJ3hY09i2N+AXkOtyC7aoof15gnXkUqwBXrDxDS/qn45IYL5Y5dFNmhnQD6GBKvj3n/bNRgneKt66YF7BZ48BfttEHtgm8PzSta57upzE04JYeWzPqXitdBqKaGDQ3qRkvq2/oHFq3SfONA7s8G05F9SDsA596dv6X1UK9iEH/Tlrh0YIO7+nvJu47da4GjBXFzkHwdqG05wYNyPTMJZHIAyMxCyXUtPiAIgP7A/TU4YG/zaavEXXd2XLX8H6il4ABjnPNJNSIjsqiWv0h1XTGMmT2TPU+3piIhyBgwnRhS7JwtT/8R/wYew/0OqSmOEogGVWlgGO+Km2Apgo3EGt0PQaonNACOL/0OaLaRGYyH3Kovf29vAW6Ylyod1VI3x8pjOQWM+4aIAAbmTm9Zu4w6O4kEKvAXbwF3Cg01zCGDtXy9+vU27Da2W2rEHkbG7NO3z/DwJZO0q8h5FwY0ZNgKvdt0PhDAWpNU4+uSalGZCzhNYbII/7qRhGdLWgM516z4jfQhafhNJKNGPrFEr2t15IWwpQMC8AxM6HQavlpzjxhtfiGB/jQze0YLTwRu+V0X1cf85Yr6Os9y6not/T4iH/8oKIQRfSspcLC0IturY2rxEY+4W++8FzKLPUMkRYaHzDHnYr+3VY+t7SIu6Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(23010399003)(14060799003)(35042699022)(36860700016)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	shaQxYrWuv0/HunaC8qXu8DHPkm5VaxjmfyI4Nk4p8VJB+fstynyA1uZ+UA19aEaaljuD9vLf0nUSaDJgSjOMRNOhtcd52Yd6OVG7kIP4ZUyFGyDc0O8fh+m53bbPz2aAJwLuWrJmseTOcYd34e1kD8nlzHqPfb1xqiXCQKcEEpTPrwBQ5StMGs1YaZ4xFCcBsNs8Tlvqk3ch+pVUCQqWh81hROJF70SSeybACbI7TnGdR2QD0Qn4mUvPOaVYgYTiREvbv47Wp7mbkz6aw2ReTn94zGFNrxRpyvf327epAN5j82rEPKp25y901lLPiel0MHNUzqu8VBIHdkm2KE/CccuYNt5avoouA+7tiNSMWwY9GI5G9AK5zJJXne97UcTBqV8XoiIlB02gF4JGujHgDpEczv0mxrBIv+e8VXBlC7CXhMwxZmNXUQHMGRMCSKg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 17:41:07.8344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f654edf1-1795-4e27-6e0f-08df1f1a0268
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008485.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10677
X-Stat-Signature: f58py5mdychnxbiqk3x9edtmemysnhri
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D27380009
X-HE-Tag: 1790790076-890473
X-HE-Meta: U2FsdGVkX19UsXOHwfvlkmdThvEHO1KUHXnjMZnhJfFKb/l4RF/OQbttGm6vvk6kT8D8e+yFMbmEv7j4aiMcwIWQTRhk1Fxyq1pMQ9vfuiHceuTlnaoHP+wl/v/jDWyiM0VUjEJRga6lqBbpPGkLVrkivXoX/3w8U2yYDMRgI6EDG+tkzp0N99ttcMvn9JLQ48XDXCPqZt0+VsxwBBlndTqWTc1BnOkszn3xd1ynkYtxAgq+iirWm/KMgG/8XWVcaQAJmWVxeoPT84nvWPrqyJZs2brFkVpQj1dsXg3xsa1sgxlzj7o6h9acKXTljb+nrUnbrDNOWaBS4Ke5SzioFfYuWJovc8wVphhdkMwwX82zjVLznBNND51qlTGs7pDtCj4afB75t3xLHb7b1x1xNl5LnLCJKhEA1s1lt28CK/porykMwma2tmYQwCVOSb/53so5U852qW8WC4p9edt2bEhzBUxr235QciVb0HSqiuFwofs7rlExoWdpIO/N7vgV9Zh2WcucfMyo80x48tytyTzKYZKEa9Zx7s/MEQ2USiCgU0mrTA70Tjid72UtQZYN+DCA3klJwIxER05R5zxWtjsq8j+vBazTvEiwlvsC7mW71Ciw5yhGIbtFc5ziR8ryJeuc+Z+mCNxjbT6EXjnftobByzaymH0O/og13wVdlWCROkC6M4qaWF+5M22+MvS2qQ90c8sLRI00dIUc/qE1DUNkmMy73TvxWDk7ZjoQ6eHOUsdVxQGicKVlfS5kDyaNZpcDmVJKFihNr9snE/NjSGMZBDn+CpjodC5fRWZqMOoa4C0M6j9RZbsYImJhwRKgaF5sv0EK2FeKNKQNC8/k88A8KcZH1hGnXpfLc2DbI72QwtT7MlhUEtyNmfxmx8+YaagU2tH4AKPBBUsI9QQIqypkbIgulH2TuEARtFRfHuzt8VBz3ekwn2uVpG7WEKWqf4vpU/Nzs/HIvrODaGf
 U38kH6wU
 K6PzSxbO+0Dfscn5cJCXNWm6oML1r/jFiUbi1oqXyoqyS44GQP6f6SaLnOGVysEmZpYoDCSjZrb+Js4G9nUD59pHk5HiGRHKp5VKV/CEtlt1m7QXRZJOHLQmHbEBDlfsnBYp6d181YheWIYFs4FCIZikq/CKvAj8U/ld85o4nUN19jZUykFFpQDOGFyZybVn4GAg/Oj3OLB/RBq86sJawsRb6iT9ZBrLYipIrZMt8fOMvGfHe2wEHdf26zj/vb3nxBXXsDIc045S54N43xBfuP+1HEZXI7Wxz3dDAux7tdrP+yGutJAwnTewEcFR5i+/dDZazMThWfii26/awe97sj/4s/vdG5o1y15gCf/pct3ixWm1pAlJqskaK1uTCeakuLpydPmH1yWKDGTE9FfEkMnhKzf2TrKo1c995/dNhagFTNc6GYCZZ2u0nERnUQ27mqjT29dIAoHpqmIH3Kpa0F/3e2rNyAlRCQX4nEcAHImUIAJO2kN+kBs76VOEaVTfPbIfh8P1Gk6CZVAASUJXpD8cqKHqBGSiaFpemMEGU+ABK3sQGpjAshZC3mKIwGsjQqed8sZ+UjBJ3SAmq3pPYA3m0SMRVyYF5Z+B5r/kCYa+oIHRejI007jJbYkMO78J93jJvo1zP80cXjpA48urQQF2x3r5rgv+KswqH8KsWBwP3kBuIhkM/ojSUeyo0dRbBivMyLHpMSCLQUo3FuJ337qa9HunXKOa9a3NtLWcn1s3nGDnny1hmnQNFsadwOqTXPX/kTHgX35LhBH8WD0IcDaTbugSX9aPSZczFs/GzSYFNSflDBzTPRqCTyMjuoEbrT+dDM9lSZwLVL3qOjt/YyF+ev1uSrsCS4K04Y7WF0K2jYGQMisylWXCJ+d6wYHD0XS90oExDHXj/dL0YoXqpUhLaFVHvytNn9yjtNiPRibj3L8xiyDEinEVjN6FgvcpzqqDobl501lNhaqcMRIaQdCoCXJkA
 u0/NmWZ6
 EYbBCVqj3fH4yLIrFXs4ZmQjptzaanuVhD+4deTEivhxAo+WdlxBwMBCg5pN/XnPtHzXfT7zdWkQkAQmO1UQZDJgoo8KxRLsLyDuDBBtYF9J0Jo6Qd4YIeUkShLq2Afqnkyhz5lVB9RechqrF9CGUmxeB/08XKhUDpaJM3cUkAqa6VFo5HivhTP83CGd0wONv1FcULSDyOF1Znp6HZkIrWK7CCOSfTGayH1fxomgTNi97EitZ+NrRyBLQTH3E5QhAXfWFI5GpLtrz0EBzBQX/die60rOsWfKxzeGQE/FsYDQfYzJJRIqRpyRS4Jz3+/8vejl8wbwH9rK1t02l3l117/xqcp7RG6GBF0uV/SwH8sE2daRMoXKbCIy5YZ6nNUkUK0/XCYDZHTBQeNjqYOfQyRLDiO9HJaAz5gGdYBsuLApemHN2cr8LLWrMtgCnGdkTxkA56IEqa9q6Glh0bhXr+j0HUwelZeZgtvTxdbygblwqHESI8k6rZ9fhgJdoVoRRR9x7GVcsP37lFjZT8L83rK89EmWS49vHVx8hh7rCUITcCW2u1lLOvmBh/yjFAu+I8yTNCJAYIrymrTfmFFdCuyZaBuAWGsRqLTQn1p3mUSuJL10sviNZlG7OQUgRLBNg08iMuhJJN1gWI87s/RWU/LajD9K4XUeKGmhtxioyHHdUfUHjR6Cb6tGUWzP/+F59lIGa4bjme0WFB3vlPRyEUnQgrUIpjXoJksmfvE/EeONaG+vyIsKC8fUXcECPPN/+IV5YyQBaGBteBY96+KV5cRhEBY4ZouyYwXrRI3ayngNy0tUrS2e4HPTzW7quLbx6lh7lGn3M1a8dWcZD91+wR4bZhaXQrEb2G3KmFMKhV8ilSz58OBJY9VMWTc/QroPCYFE4YCxGT5CV5AT3pe31b4awGGM3AqR+3dIV/ErmlaqiLKeQxhTa0EuQ7nGAyUrUgR0X6ObPliuJ+aEt9w4Z0mROr9+D
 Bn7ybRwq
 WsRsY/R9u3HShqwTg2gCfDGbVoXszTEbSNlOH1jeSkuaxnOLH/+ykeghU5jrVAJ1guoVj2+VaBM4dTPUzRKkyah9iKIF2v0l9afc4s7bw+r7Ar+bFuTss/lAJnvEsWFHDKAxHPQJw7LV2Rei9xiB38NVKox8dJevZDcwIB3SVm0aFOaSWyw4v84Hl3BtrCbV8UePvloS5XCrbaKVD124CleE5ifiHxq/lzYzU7h6hHPK+3ilQE6F5MXAH8FoBfqAYTzxwPc+6r/9EVPeN2+oDVUz2fzjRQXsXAygiBUbabi6Mrs/qLMAqujIE1fmWcVPRIavoaodBGlW+TJyt1ocIGSXmynQFkunqzpuhlOmu95lnw01x6t+pYAB86wrQPpxJr3bWyM0AdliGqK21EawRp+a8Wj0bWcOJIFqM6x5Ip0KafqkL6NI13PBxZMCbwXOiJRw0Yx9jTIZqy4g+68fD+q7fPnjkG62HtBDLlyPc1v9q1r1XfVoXhBI9NcKb7zbYlK18Euw72PgDWQgR3VQJJtjPFQI1i64Uh7DR0GKyHNe94aOB99UNwKMx7BW56dLZ9Il9B5z334WvRC0CYnguYUadccqsSoPL0BVwPMW306cze+LWrhnyj6pAuvAQYV9xXGDfRdh3c6Wuk32qXCmmxqEGwYAxvYfUfeElvBmyjJm0EX+Oe0gGlas1CARJoOI5D1767ia7JnsmAdpKD4QbkxZgbzOe1GXkD0OD1Fs8qL8MrmsbkC377EKkdePk+c9vAwbbylBx3MJ6sgB/3zv5Bg48iHOn1J0hbKF/K9lGo5aemcRJ+JARnN3kzHY9n7oVXR3qe9WdjzGUa4AsA4XrTNiblyZgUNY/6YnDh3BhgUHJvIWF4YfG7O1+Ax2CXB43rDo5EVZx78o6wxl5VRckgQXXLr8rdEKyKUeGZI/iPuMnoEfRM+TFemSE6i7egM4JLTnIeh5Wa0ua65UAGwjVW+5OP6NG
 rtZnfAos
 5NilwKZ6Ac5UI/pCPKMDLaPVZ4qaANe/CBuD5x/MH8QRl0d8e/PQ9AuBPKe1l7GsQYRgYA3ALNlaPSfjp9l85jFWBMg9ecOiPtOQu1JKAKEv68TnUpivrUryDHbXCyJJ3VOVRuxFgcrmSJdyC6VzJjZIZxafmiSf0I7BfmdJnMKnd57YQ7Q7Me7NQ6GJ3+DAOUzVsqkCH0oZWQkRfelUuYTFOvSoQfkC/agwqTXKw1IYFAa+ZTdNJLqmboAiujQcCsxKDaaoAfX2I/7wuR8UcbxmDbE3S0kLfa1jFZpQQ+vJy5puonfnapH0O3wC0GLen/uQHWjWSLmuwpJoGQmtmnm03YmgUSm6pvN8fx3VVw7jlT0RAuE1nOV/jvo6rTstr1jrQA2D5zkKoXZCEUrjQRvSfsZBD58jvF3t9MBQIPt0mPjKGgPDHoORAwQmDR7cftzXIO4oBE8I34+xRDxLfVuFOsQQmFclNRON/5JAMyfNPNcQrpNIOW6Eef8GUf4AuTxI+R2vU8djEi1+2DdsNSWr7GAVd8d9LkXr8XymdTYiKqN8cW3mv8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/09/2026 5:35 am, Anshuman Khandual wrote:
> On Tue, Sep 22, 2026 at 06:12:31PM +0100, Muhammad Usama Anjum wrote:
>> Generic page-table interfaces use pte_t * for both pointers to PTE table
>> storage and pointers to software PTE values. Convert the generic
>> declarations and their MM, fs, and kernel users together so parameters,
>> return types, callbacks, and local pointers that designate table storage
>> use hw_pte_t *.
>>
>> Include linux/pgtable_types.h from headers that expose the converted
>> interfaces. It continues to provide pgprot_t to vmalloc.h through
>> asm/page.h.
>>
>> Keep software PTE values as pte_t and retain pte_t * for value interfaces.
>>
>> No architecture selects ARCH_HAS_HW_PTE_T at this point, so hw_pte_t
>> remains an alias of pte_t and this changes the interface vocabulary without
>> changing representation or behavior.
>>
>> Most of this mechanical conversion was generated with the Coccinelle script
>> included in the cover letter. The script deliberately ignores pte_t *
> 
> Just wondering - should this Coccinelle script that converted all these
> instances be saved inside ./scripts/coccinelle/ for future referene.

Thanks for the suggestion. This script was written for this one-time conversion
and requires manual review to distinguish HW PTE table pointers from SW PTE
pointers. After the conversion, it would not be useful.
(Maybe other arch can use it to do their conversion. But they can always
copy script from the series)

-- 
Thanks,
Usama

