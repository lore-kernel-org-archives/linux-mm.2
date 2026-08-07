Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8601C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DFEA6B007B; Fri,  7 Aug 2026 11:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969716B0088; Fri,  7 Aug 2026 11:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3056B008A; Fri,  7 Aug 2026 11:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8A26B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:24:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9E9C4044A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:24:55 +0000 (UTC)
X-FDA: 85074846150.17.82053E2
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011027.outbound.protection.outlook.com [40.107.130.27])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8D29E40004
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:24:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=enPJXwJa;
	dkim=pass header.d=arm.com header.s=selector1 header.b=enPJXwJa;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf07.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.27 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786116292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=214jEOHDvbqO65kJp7R9WvTe7aHGn+ywbFPey8CpPng=;
	b=Iny+fKK+FaRhH9YMsKnDA5vOZn9K6dUAl/n5ylC4AvsI/RMGcGs4bBJLsc8qOh2Ah+BfKw
	rqNV2yEqeNRZRxq/0IVQVfPU+viIMlrtwpO9lfbm0e09gtrxniszEY7Yhhoeo9bg7QPdnl
	c/5qeHu00OjUQH+aIvQgvFOScpWHmmM=
ARC-Authentication-Results: i=3;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=enPJXwJa;
	dkim=pass header.d=arm.com header.s=selector1 header.b=enPJXwJa;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf07.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.27 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786116292;
	b=Sp2E5AiATDI4xYPzAtG6K9cLEfNDtoqeXgRxaVlCE2ruAMf4NV0zeHRroQPFLMz0NLwjJs
	ja5VJMXqdHn6H3XSZVteXUPaEpjRaoYrOXE8b0vd978kOt05iECgymbimxU/w2fuSjC+ke
	qiq4RFd3FXnzEwqohi3AgT75zEIkiVc=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YgYEf8/SAqc2pFNvqaD4dDMa/gsJUU+5MZOxScmIqgUj/Tx7t4IlrtLsb91lNcg69MR7dVZoeSppBCkkBgQGOqwkJ6OWWJ+MTzZdA5kBb1VsrAvpI2lcKR4S8ceD0HjUcj+ESfu4Zd+1mIbJMlJ0ibLEGcuwKGy8JlCK2FsT3toHWjiGadnfZeBoOXcXciv/bmssMN5WrVhJFvGs2j8vQzPbqaxRjQSaxJiLt+8aMVo0WuXLmER0/KfgBnTJb7H6E9NhxpSG9VS6y01FqG904amkoWg43Gzd4regFez2fl/jNZpv5RUfsY46/OvfjqvHaibmSbVVst2yCnM5oUxUZg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=214jEOHDvbqO65kJp7R9WvTe7aHGn+ywbFPey8CpPng=;
 b=y+TPSW3BkJ1wUWEQ2sdPKNn62KbZXzdE/RRRrao+EOsUTJgTZtUkfUNwGiKVCpF39Swbmbd5wxX4F7TgHkMR/eHuxNXfS60q5y3z2KCSD9V/rFsOQDDkPkOxMtAaMC1vEvORGD77NqqZuZ2t6zVYfxHh0tSrPjjxPy9iwHrAy4mekd47nKe08vlEsLMc2/53MckeG+WHt9Rd9/5SqaDvyL1zYObh9cIOBQysoAOscfpwXLhOEJffH1pZiNbV5UxBhASGtAXqrZpIylWQ3A2qq07ZT5YNmb3jKWs8dOpSPNEgnZPRyVJAFWTYhgQlasMIEbdxCVJtRCfD4iGbYwH77Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=214jEOHDvbqO65kJp7R9WvTe7aHGn+ywbFPey8CpPng=;
 b=enPJXwJauFv1oQ+Zsu+QSANwW3vkwSHO6idG1f9lavXYCMDiQj7zALU9r7ZrSNwB83ddazzAia7berLLBPNVREmY+i8jUOiFiAzFgVdPhUoiSCQgYnEuLgSz9qoiTNaXORSa7/hhnbz2uAkAxi6hltZwGxaaMH2YsrtnaxNGBH4=
Received: from DU2PR04CA0029.eurprd04.prod.outlook.com (2603:10a6:10:3b::34)
 by VI0PR08MB10800.eurprd08.prod.outlook.com (2603:10a6:800:205::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 15:24:43 +0000
Received: from DU2PEPF00028D12.eurprd03.prod.outlook.com
 (2603:10a6:10:3b:cafe::3a) by DU2PR04CA0029.outlook.office365.com
 (2603:10a6:10:3b::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Fri, 7
 Aug 2026 15:24:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D12.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 15:24:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nyb2Zb/LWU68b4QGwWAhlcQocb72STHW3uhfNyJ/g64lELJLAmSW96qAz/OMx/oWcaZqLK49ey50C0zOyinM7uz2f7t/rswIfJA3on937Xr6rhZb33gq8yhF4bo6zdBOVTLTTmBkHDZqbrhB1LfT98VZ4UuY+vRsvJGn47rpYM2oVFn7z917NcM2U9kmEetzF9c++WTMl6VCBZgLdoLH5eaGhWUVZSpGlwrGUhQRbJUXUyod4ZZbXfyj0kyvcfN7N4KwVdsxEpfT0a5ugq9b0gRmqdJdpiXUKBiRnGKrU20+fpbtbBQlvm3ws17MFXcdqwsLv/8+HoZLqlMT5UlyGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=214jEOHDvbqO65kJp7R9WvTe7aHGn+ywbFPey8CpPng=;
 b=Iq5uLCPRY95NgPG05ec3/v2umI3pqGev6OJlMs7JnoSZa/9RU2leY3JSX/bYvrQkD0I7P1+cm78rMIHmjbqvjBW7B9mXVoMfVYbF+opAu4V+XE2BHctMeSKfr2XeJY44FM3zl1dqPfSUlfEMG+B6CiPQfIIlotdibkE9UBosH1EJPtygjT0yjeDg+eI5L/m71FQd9x8g57J2U6XhfKwPEIWMwIrh1riSh2LF+rAZ7E22DOaKucwUf1CTatrBeX0rJ5Q5DU7hX6WqB6NmLRg7PAqNEZZ6AHGC1dUBwtSis4KZ/YYk69flyBa7kLy0fsZiiWBcyjtBZR0lPz6uPGvmLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=214jEOHDvbqO65kJp7R9WvTe7aHGn+ywbFPey8CpPng=;
 b=enPJXwJauFv1oQ+Zsu+QSANwW3vkwSHO6idG1f9lavXYCMDiQj7zALU9r7ZrSNwB83ddazzAia7berLLBPNVREmY+i8jUOiFiAzFgVdPhUoiSCQgYnEuLgSz9qoiTNaXORSa7/hhnbz2uAkAxi6hltZwGxaaMH2YsrtnaxNGBH4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by DU0PR08MB10360.eurprd08.prod.outlook.com (2603:10a6:10:417::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 15:24:04 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 15:24:03 +0000
Message-ID: <eef14e97-20cd-4b08-ae22-7636af049b09@arm.com>
Date: Fri, 7 Aug 2026 16:24:00 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 David Hildenbrand <david@kernel.org>,
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
 ziy@nvidia.com, pfalcato@suse.de, ryan.roberts@arm.com,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 1/9] mm: introduce hw_pte_t for PTE table storage
To: Alexander Gordeev <agordeev@linux.ibm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-2-usama.anjum@arm.com>
 <3db8233c-3785-444e-b2eb-3e5fc5cb2f17-agordeev@linux.ibm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <3db8233c-3785-444e-b2eb-3e5fc5cb2f17-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0612.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::6) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|DU0PR08MB10360:EE_|DU2PEPF00028D12:EE_|VI0PR08MB10800:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b1f1875-57fb-491d-136b-08def4980165
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 2t3nqJ+jv2XLoMl6etGaV134C/dZQIRkfbXAbpMvG3W60rxh9JNS7vnG7JumwZOuXshH8/Khuk3XFmNjAOvraHt1FiMxY6SDqUc2bwJ7gjYZ8RtOPYKcClF0QM+zYRhnM2CHCrpr7hoXmeUcNK1NloD1WpyVejEgA1J4jgFzdItq9u6OyZXdImufdWj+LEBGS6IBmv+6/BB4ye4g2SKWQIknvPuEDBuj1QJcOVK16BBecyhY/ujuWGSnNHP185oWRvXeO9VonLi2CbWPODWWJ6+GNA1EHlmq0Q4ZqO2p+w3c5VO7/ibcU56cA9Zm1BPAr5gV3dSiIY5gBrrO0GhJM/Nz6RG84n0RW8uE6xU5lIhiU0aD67U5Nv3EgUz3WjaosLO/zSgKYoBUWVByOz+9Priy7ZB1ksCjLvXt3lJinMQPrFeYsVK6CNwe9nME7chQkisUZPHEKJn9+l8p6tsQWo4cFJaBq/z/0EYkPFoVR0A8yv0iaX3Wc+ux7aTJ/42G09Rj3Dead4InmbspUi+Ht3U8qdwytMOXQUE/LL9p10Moqf0AmvqZoPncIsUwaQ4XpIbvzZ39tWHKbpiuDcdyBJ5WqoGT7NG2PDYTvLuVLzk29GuoAKjCGC+s6nyChN0n+dYaspSn0T4UGPXwMasE55ULyoI/4NgyGnNil4b9eEY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 dlDyhQkPRofMsLRSwwlNt05buGPmBxT0qhTwS66CFq8RqMH9JnrYeuRl/dIwLMTa3S0/tZc6rtzklCAqGaMnZaEqdUOy9ty+kky5eI4h+1Wf1WKIT0YHlFeHr0vRqQZTfCnso0G6QzigOOedxx6gMxysMT0bK0ziCJd0J1RyfKzdTW8odKVbcKEuWC5tBK5BP8pSTpUvb9bqjJt22KWmnNAWz2ZwHUnOCAJKWRrFwk8vXvlbNdJcHpB5C7uykx7jnsyv/KXKYdJZ+mj0wHCvlqXKkXG1OQs27M0t8YC/n8p+GVaGFyr5QH2Su5t2Nu/Vrv2mfXu8Eux58avYedux6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB10360
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	78010af5-117a-4010-9bc3-08def497e9d7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|35042699022|14060799003|376014|7416014|1800799024|36860700016|4143699003|10067099003|11063799006|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	x2l+m/+TZiN5WDcR3BKopXymxFpy1n/w8zewuFb2y9Ds335w4O4Ipg3KOXg2n4Xh8Z6ZlmT7QUcRkLaff92m3Ne0kmAudKqF1i7KCM0DsFpx3DuUqfjaP7aF7OmXLIxPwJDeNR1W4aFtqQsMzj6mGeLYmKeqqcSPNPzag2ub2GOj2/bK/1pDOYTo1K/k4bk0vhAynOwzYNa1Nx7/1WC7PI3jL/TJiYXFCp8dpLng+J/aNdOXoAm/RLQNmFW4ljg84owYqlCIOCcbCANBBRVgveRdJU0JPGD82Od0h/a0+Oq0aW9pFkmA0o2dCO+bzsekY0s+7XFX1ZHLlI1HQN6ViBp6bPK1ybVXLSu1PwTi4Vv4eNXkBTJx5fk3hzwhU3PHuJhxB8mxgL9ZTTpSgQzsxo0vJKN+HlDTJEuEoUX6pfOPCHlhyvD80zyfKVHQsdUVjHubTkpPRxB7j+LSyo5f9JriQn5T2mpl7uwyUXioFUweqjQAZskVMuoQcyTxNU0O/sqBdp2Ce9+PHxvT6pLO2MVwmDJigEVSUruzu7+RQG81CMOio5AB+p4ZhsqB7FVhLbsM5WPYVMbMbGTGhrHYk4RU/s8FcW61yPwCV/Jr+M0S2432PHauUfoUr4fKduq/SZoY6dd/CSw7MzOR563j+j2GQhVfmsDKgWE1s4d62IKk5MiyhpQkdB08qiAYJIzxAsYqQudlQv3BkGSoxsFW4w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(35042699022)(14060799003)(376014)(7416014)(1800799024)(36860700016)(4143699003)(10067099003)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	g6sLusA9X41u1ejA18zr5/0Hh+oxjNblxuqvfooYrhKJWuytwsqkYM4RBDsVD6JUPG5ejrRcqnr5/e7tppZJbWyjdo7t0o+y6z68tsoif+F1MBaBmgNHyyctH3CIoA/SkECaXcG16VOwlN9BPUQ0jemKU5fquWEAgHzOiZRFYVgG6EPWjni/TQvwedDSSGb8Razw3w014ZbBUH6R3/c0wWm24LvnYzQv+O7tSwf+LD8ovZuboPDpk0K2qUMKcAzXRFN5Agl8K8bfESJXk4tJL+oyf7av+q6WK2Br07wYwX8iCuY6olsVmayuluAaae4jxdx6l7Rfd0Sxs1FZSgFIEBdpvTlmClNis1jG6i1BiVLn1AWIPxbDqedfdPJx2hH9vhU5ko2RaVILr1JHK4cc51ZlbJ7gAPev9zfv7mGajHlpjSLdLi8QeNSS211id+sa
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 15:24:42.8031
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b1f1875-57fb-491d-136b-08def4980165
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10800
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8D29E40004
X-Stat-Signature: ezrjxhs9c4tih1j894qhcsadgfuijz4e
X-Rspam-User: 
X-HE-Tag: 1786116291-669499
X-HE-Meta: U2FsdGVkX18xn6ZVMSRA9ZKK7FKBeZtOg5m/Xmuk26Q6+UdaVM4894u7mbppTbIxutBrxcs3KkxCtnuxZnMqMeVuJsJLjwEvb1IYJULM1YIFht2iXEdpCl4/d34gN9a2w4KrFiyfny//wmMfv3s/IrY7WSMOuEHcQ8556LuwJc/igfw8ea8vN0WsLduGE9CCwqzrsQnkcoQjLNhUmM4DXF1p/IUisdFAILjXXyLCBbztKzbBnkzEHncm4nStDjVDjgRnRjVRY9yb+6QKGbdhGF1BI5u63l657M1P5Iq2EhCrMCTc0DAErEIQnXOO2yF6TyTG41bWiwyzO+wBS5jwslTNqyMMiW5RoHQ7grEynyeYJLwiqoK0P4Xz0oVciXFQDFhuT63QSLf7oo4qU2n1wRI1kIuwiFmpR8292sQMSSRjPfZrx3U5gVA33kwXHYPeOPYXuQfJYEkPdkWnyjt9Nqqlfy8BfDx1n0tP+c8yQDDjKtge/fYWxiySthlxzGuBc3L23S3rK2MkGlG4auFICRIpfdQ37Txiq92EUsX00oiJ5N7s5phCNkVlxr2aerI3p9MGnwmPeLxG3seEJsiwM6l5yKRaDnDPDBMNos/M8/HOannfUOsxq+wcJ8YHZXOmOYLR+39GP1GFB4sCbbYzdLb5Bkm740pdGSRNbLxJ0jf6DxZsEES2bhHoHz4n8sUyWKPkh9Io6vEr0y7W/I2/pMV4Fvuh8fS25C23fxDKx93kmfbd0e/mfSZmAmvikMBBLRzw+uPssJA6shzGZHnywWce++h4WfOmqUU8bIBYIw4B/WcCZ+zAtDVETViYTKW/QMk6tv+l9iSl01OohRTGQFgLg1+nNdglYHUT6Wiu2zeL5ZaFmqUTAl0iQLuYNK7sOs+gLsGLqiy6FTlk/G6nxkh+qoMtYt77e9XMAY55+hd7KPH9b92iq9n/aRtZyZrEp8nUpzqlxY9tFaocbeG
 XnONajuF
 dwbOOoQt4jtyv/f+xzqXKoeBnG+D7suPty4JkGN4gnF7eagA8O11V1/cEf3ckfEHPSzJ9qAuYSchxu4Od75ALCX3hAGGMkjynSqMQXqfCjxd6pNbw896z6aD2vDcKzpa6q3plk4fjIRX1Y8pnDNHUgog7KOEmuzjZgqPx1ReEOhanTp2TZ4YsgNs8XPRYHzz8loDLdArnlKPfMbob5cqtumoFIL4xAqb6eJO28CgjSIptHdEm8Z5PTmqJLO6yZmsRHt1RAXcoMLc0nHmpquLtPE203Y6INAL584iwo+rig7fkcDU403JKfjlHV6bMaRdBdKNFRT/43ecoNnCTd8TEI8V7C71o+giP0SxuASg+gvWDy1JpP7FleSOC7Gccx+SkRbxL7MgIhCg2m4DLGcuvmeh8jwK+AIuUdsmXS3wLvJhZ1Ak3fuAZFfsocVLFs1OK35Krc+nDVs6knAOzGa+CeCd2ymKrsCqN28/izO4BaR5Bg12zgwR4a7JYdMHFhO5RRAWQOIACSROuR9YyyAvzSWPSZCmv0m6lXvigOIKIqKe+KgRVsTmQv6Si9w4PAYJouKA9mOAgmMIHrdYSPej7oIUp2/gECbQh3+vBNllDFcw9emUmD8ai8o1O2882u6dAJmTa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/08/2026 8:09 am, Alexander Gordeev wrote:
> On Thu, Aug 06, 2026 at 09:38:39AM +0100, Muhammad Usama Anjum wrote:
>> pte_t is used both for logical PTE values and for entries stored in a PTE
>> table, so pte_t * does not distinguish a pointer to a copied value from a
>> pointer to table storage.
>>
>> Introduce hw_pte_t as the generic name for a PTE table element. Define it
>> as a macro alias of pte_t by default. When an architecture selects
>> ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
>> This preserves the representation while allowing converted architectures
>> to enforce the distinction at compile time.
>>
>> Keep the C type definitions behind an __ASSEMBLY__ check because
>> architecture assembly sources can include this header indirectly. Include
>> asm/page.h so consumers such as linux/vmalloc.h retain the page definitions
>> they previously obtained from that header.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since RFC v1:
>> - Add the ARCH_HAS_HW_PTE_T opt-in and generic wrapper definition.
>> - Exclude the C type definitions from assembly sources.
>> - Update the description for the new opt-in model.
>> ---
>>  MAINTAINERS                   |  1 +
>>  include/linux/pgtable_types.h | 17 +++++++++++++++++
>>  mm/Kconfig                    |  3 +++
>>  3 files changed, 21 insertions(+)
>>  create mode 100644 include/linux/pgtable_types.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index e9c8567308a75..7169bea968cf5 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -16982,6 +16982,7 @@ F:	include/linux/mmu_notifier.h
>>  F:	include/linux/pagewalk.h
>>  F:	include/linux/pgalloc.h
>>  F:	include/linux/pgtable.h
>> +F:	include/linux/pgtable_types.h
>>  F:	include/linux/ptdump.h
>>  F:	include/linux/vmpressure.h
>>  F:	include/linux/vmstat.h
>> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
>> new file mode 100644
>> index 0000000000000..70c3edd00a01b
>> --- /dev/null
>> +++ b/include/linux/pgtable_types.h
>> @@ -0,0 +1,17 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _LINUX_PGTABLE_TYPES_H
>> +#define _LINUX_PGTABLE_TYPES_H
>> +
>> +#include <asm/page.h>
>> +
>> +#ifndef __ASSEMBLY__
>> +
>> +#ifdef CONFIG_ARCH_HAS_HW_PTE_T
>> +typedef struct { pte_t __pte; } hw_pte_t;
> 
> On s390 it fails to compile once we do typedef hw_pte_t *pgtable_t
> in asm/page.h. m68k, powerpc and sparc may also have such problem.
> 
> The below declaration helps to resolve it using forward declaration
> and without meddling with headers, though I do not like it much:
> 
> typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
Thank you for testing it out on s390.

As __hw_pte_t isn't being used yet in this series, would s390 enablement
patches add __hw_pte_t to this definition?

This could have been avoided if each architecture defined its own hw_pte_t.
But for now we are keeping the generic definition of hw_pte_t.

> 
>> +#else
>> +#define hw_pte_t pte_t
>> +#endif
>> +
>> +#endif /* !__ASSEMBLY__ */
>> +
>> +#endif /* _LINUX_PGTABLE_TYPES_H */
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 331daf7fcfab5..31ba9ebf4aafd 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1316,6 +1316,9 @@ comment "GUP_TEST needs to have DEBUG_FS enabled"
>>  config GUP_GET_PXX_LOW_HIGH
>>  	bool
>>  
>> +config ARCH_HAS_HW_PTE_T
>> +	bool
>> +
>>  config DMAPOOL_TEST
>>  	tristate "Enable a module to run time tests on dma_pool"
>>  	depends on HAS_DMA
>> -- 
>> 2.47.3
>>

-- 
Thanks,
Usama


