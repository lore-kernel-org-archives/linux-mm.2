Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17916CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 15:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1845B6B0095; Fri,  2 Oct 2026 11:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 134C56B0096; Fri,  2 Oct 2026 11:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18B56B0098; Fri,  2 Oct 2026 11:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C081C6B0095
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:00:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B0001207C1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:00:20 +0000 (UTC)
X-FDA: 85277997000.20.043A299
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013027.outbound.protection.outlook.com [52.101.72.27])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5B200180005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:00:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Mo2nDH6e;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Mo2nDH6e;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf06.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.72.27 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790953216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ti/5xvbZ1AAv74C2/nfdQE1m+h+p3/QI+PEVwvH6dc4=;
	b=k/iH1B9wPLITE8VDIKAsOJ6HUHyvKoFbAreko/fNf/SmKAPC2MYp1BgZzhAE4kA9c4bkox
	YNvOvBbA5/QAMz5R4TEGR4i0mhvkLrMUyMkGwKtH0m6w311BqELaqij3Ibh1X7VZssOniY
	e0Q0vTaa/Liu2chqN890ILVCAqOqndA=
ARC-Authentication-Results: i=3;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Mo2nDH6e;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Mo2nDH6e;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf06.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.72.27 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790953216;
	b=TK7MlkbX2sdbBRfThUEvRK+q/TQN/m5x080DiCKriL7Av4+0b7NADk2+TlyAMKkbn9/zi3
	nDG5wRrUYpKnDXEbQUdxkPl9U/9r3xtJVLU+BDQpdxsJmIZH3Sl2Hlzb9QIDw7qfWnXr5o
	it8kAR0jiTTc4+Aiv7JW54mebjeKVPk=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=uAQfV3EUJW62CcM0EELXc3JHfIPV2TVgJ5yHWJTdeA4Q4X6MP/f5xbw2g+jHORKQe94uYwgaeN7FuwqkYsLBfzI0lLzODSmRjs13GkZLAPbcffhDra13NKdD2o9kRr8Hpy37vGXf0i7Yjtd1sirIHnnO0KUkBbtTQSUdLje3PhXE3wuBCyxb6XXKpoNM7VPzD0z51N+rPSXSLnFop0h2pLUalALVfCHaaPWi7y6mZ+A79PLLvuLdhg2+bjF/Sgh8nXji/DnCGHN/1tY+Ho8Uf06Sjta+lBb+F6a6wrO8J5dS/rY3Q0jRJi5m8O0m/mD5qjs7SWBXTJ9/I+iLXrWNGQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ti/5xvbZ1AAv74C2/nfdQE1m+h+p3/QI+PEVwvH6dc4=;
 b=Rh7EIoy39F3hpUwlXpL9Lj2nD74UB7MygNQ1r8sQsMqV3zRK0PKBRQ0n4Vik08I94PG6O84vZ56XKOWa6eVPyu4lj62hC47uieSefGZ2m02BL0Ee1j+z8d8znVU8pNgIpfxIwlB7X4VVnHISWNDyh+mcPqqNkJw5fT4HKc/i34eWu64FLHXZFZHNV1n4ogynNJHEjhvPt1gl9D63wt+GoerJGKRHQRgs2a0B4cv48Saej4SljRtl2GJHSv8uLYiRgi4AhNpx5Zq8dazC2wTYawv9rmTc3COr4UzIM+HOsXqlglO5QVQtQi45d6yJj4oHcUvjysD4isQZ25D6rD6PcA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=intel.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ti/5xvbZ1AAv74C2/nfdQE1m+h+p3/QI+PEVwvH6dc4=;
 b=Mo2nDH6eiiPGh7acExyLyD+Jj4WqZLPMkj5+IQJPLowJkHahm3omPF9SasuBLbFHb28M0ZAl0V6NkAsy1KXrrgZQeaXFhpkRCokyjEoOH3JIRVWGzZED5fJ2hndCjXKqF+P40X3gZ6SHd074yuEpTLDkLLIrwKQGrc3ghWf3N9Y=
Received: from AS4P190CA0028.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d0::17)
 by DB3PR08MB9897.eurprd08.prod.outlook.com (2603:10a6:10:436::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.13; Fri, 2 Oct
 2026 15:00:06 +0000
Received: from AMS1EPF0000009C.eurprd02.prod.outlook.com
 (2603:10a6:20b:5d0:cafe::9d) by AS4P190CA0028.outlook.office365.com
 (2603:10a6:20b:5d0::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.19 via Frontend Transport; Fri, 2
 Oct 2026 15:00:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000009C.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14
 via Frontend Transport; Fri, 2 Oct 2026 15:00:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l3VEqmKvuZAU0+agmoZzr+8hppPqTJFFjvc4xTWXU7zI0brox9y2VNY0kZVvIu0zzCRwzXjfbOjAKCiBJMsA6BBszQ6ffq1eXuqvdGPo2eMZAXS/WHss44krBPSAGZSY77dO2KIOU8LnF0mTtNiBafcZp2GFVFB80DipFgiLK2R9CBLv94wyyz9Rb3tDTqQFFngoc+JsQV6z/aL5viDSQmIeMif8Ta6JnjNqel+cUuXWxLwcFyjGWoV6sxib1D41Ff3v/P27rUiS2vbzCTkzedgDkhjW6cuMcERqBodwlJm3fFa9e1++PL5XX/b18SxdSKWHD32aOwUuqxu4MeQKDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ti/5xvbZ1AAv74C2/nfdQE1m+h+p3/QI+PEVwvH6dc4=;
 b=ct2u76lGXznHnGAjkKWIvF/QheO8nIZ68MLyiN+rmPU6QfrHfFOfmG5tISyqlCdZKb7bEFIvXMYnOTje6TSEL0GIIAuLIHDZXQax3NVHDvI9ueJDGw3pMFZ83K87pZ7QLqfS6pt7c248vcvHR73N4mQyGe4TSd7w/SXqJ9WHsXmJeF0JcmJcubJG+aOCZ0BmCL9JEpPcCp9YBuzcGCs9s5MGRoOJSBGNNbwXJsdUFbWfBaVVvhPiDVZsFFWzhfsSiLJpRwafrTjgGQ1LvrSnVMuiyEIrXGftQt7U533VnnfVKXIvlqaXGVnHroKkRh+reVZ4xHULl9F3NqgzmSPsrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ti/5xvbZ1AAv74C2/nfdQE1m+h+p3/QI+PEVwvH6dc4=;
 b=Mo2nDH6eiiPGh7acExyLyD+Jj4WqZLPMkj5+IQJPLowJkHahm3omPF9SasuBLbFHb28M0ZAl0V6NkAsy1KXrrgZQeaXFhpkRCokyjEoOH3JIRVWGzZED5fJ2hndCjXKqF+P40X3gZ6SHd074yuEpTLDkLLIrwKQGrc3ghWf3N9Y=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by MI9PR08MB641028.eurprd08.prod.outlook.com (2603:10a6:290:b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.12; Fri, 2 Oct
 2026 14:59:28 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 14:59:27 +0000
Message-ID: <a142e0ae-3336-47db-90f3-5d22708f9a18@arm.com>
Date: Fri, 2 Oct 2026 15:59:23 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev,
 kasan-dev@googlegroups.com, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
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
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Subject: Re: [PATCH v3 6/9] mm: add hw_pte_val for HW PTE storage
To: David Hildenbrand <david@kernel.org>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-6-5670b8cb9059@arm.com>
 <2dcd9dbc-99ca-4f5e-8e25-f42977763c84@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <2dcd9dbc-99ca-4f5e-8e25-f42977763c84@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0506.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::13) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|MI9PR08MB641028:EE_|AMS1EPF0000009C:EE_|DB3PR08MB9897:EE_
X-MS-Office365-Filtering-Correlation-Id: a034d3be-d90e-477f-407f-08df2095d84f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|10067099003|56012099006|11063799006|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 awZGmDrP+n8iLBKvmVXHTttSmqRxMeSGungA92N+sXf6yE3oI65JXMYjoyoqZU4z92EjLnPwdA3swFEzepXI34dKn43yBmeVvLqIUe/aBv08SgXGzrmAxS717gejGWy8U4rPYkvOIDdyiBxd2MBpfzCJlWMuJUzzr/Wp+j3suycL5rjxd/v30SmewNFgPgNQgQfr10cfje9l+9HvcpHE8UaxFi2m98g/Oi1yFh1Uv7p83MBhZzn3LxcBIRczyIMvxVclUNwFTHfOSqMknRfYtrchbmqunIu6Mb0NweYLrvUPqE6ht4UxNYMe9LubbLj0Z2CDA/bRAHha1WPyDPpEeMgLlZ7ttBS8IhHCFiIstMQ66XUeWBLvVis9enTtmnqK/jdaFIplCGIsd76kNk+meVo8W38oNZdpqw8ADA77Z0k5L3wSocvuaE/Jv02VD4+Yu/fdyYpMGa9TY4CDAu33JydBOUkVs9q39XNddxpJgbW4r+th+qCEhwCOzFeVMy3aAVkJ64e9rj5Db+h19TKi6I1q66jeb6gu8PyGYzRJRxwM8+Ze7MsHhx3jpuXiau+zNi20djXGuN/50xIlRPUpcpXdIeivXUrEcm3rd/dUuKz3a6g4TuBdUDqyIM6I6Rnz3ylxUov8Yd87TbRsm/QMEJl0iwp4KFdC2hGLxcMxCi4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(10067099003)(56012099006)(11063799006)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 O/ShE+MLm7IKbo9g36eL3X0mvPd8jlMxid/HVeiYr6CQ/77qfCa3N/b4vIwk1i1PLKqJlVUWlqDgRxqtKEPjtwupepE/KVG1qbX766JDmNnClOViKhwOGw2odERsg9V2MjPMqfmYMVgxuz4t93xa4jorFwnbmORgOPy4FhhUFe0nYkv1xqlrkn9VHF3vW5h65bao/GxIP1gmv+LW0ignAeRy6AzaqIhaREPatPNVFTOpKJfRCCBw+9xErF4dn+NC6XkhhsqIS5cKm3zOB/HmOtHh5S8/5xktPWw6L8Ata4pti5pA2V19xSSvyXK97GtzwJMmr8bgS0R/wczjrkICXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MI9PR08MB641028
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000009C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8e3e908f-f49f-42a7-a5e9-08df2095c16e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|35042699022|1800799024|36860700016|82310400026|14060799003|56012099006|11063799006|4143699003|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	e3PVHNV6Atu4PUVDGTRp8g81vqrcCMJA/whGHwuBhmxf3Bo5KxOpwZ7/t/Dtp55WWTPpJn0EfGRVWhw0dbOxPDtIqsiLjPBUO5SoavPEuHHIj62gBfPg8JelhvQRTTynrhyLfEsO0GQiHAnXOd+chyflqWvmjo7MMw5ZR7npBKEUG23i5lScAFhbAIcJkyu2eFUM6dV2ue8YLiy74oQTnEilKcsLb/7rAfWbEzqWvkVJdJNPoZflu8rEZ++XcI0T0S7stdOKDxNbY9P79NLrB2A+iFbvT3uGhoAXRg5JwgHfe/iTKRIxMzNm8y33mdMwe+MYZbt5WCwfcazjfy427YYThdoFFaME59/Bu6xv6TCthRyipjx9H92z5fIdp7uZc9ffkSGADyyN3St6p0hxoBrGXok/z9hnbPb4/2/MTm0AAr3hpyBtOVreV2zS0X7hmzMapU8GBksu9QFZQN3tdA8f7kHHUu3K1+74WrDSAyrpWEsOzFlEhQ8evkzD6XV0pt6+/rEZCuDr+H8/AkX36t4A+plgvjWc9ev6dDptVq9YGC399Mu1kBXJUCrYR5WqZ31/R7uLa9MInAdfZeK8vRGom+3XMiBfQFGmUcXbA91wDTFed36qS0G4Qg0DBia9gx4+7pW7jQpYL32DjPf6pvOpEHtpYpjyv703KcgQsY6WDSm6N/zAgWD7hdBG1TfU202RzLBYlbX29fmnz5nyjw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(35042699022)(1800799024)(36860700016)(82310400026)(14060799003)(56012099006)(11063799006)(4143699003)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nHkjJVNJiDScHS7JCHIRkUZQWOdQ/QJve4xVDinlyoCcIfKtj5o7oAzp92if3AokVhSRa7cY4lXMqEqipvOmJjJwamYgB64kjr4PjseTzYLppgjBVAu35cRVnzCnsVxS4cTzFCng0dStiAaXZrgH0US0jysiQsOCI2idInD1S1/FcT9U2PufYfGi65Bx19hJzZlaw1nZR23T7S2Q3p0bWKV+Yk4/nUIm7Lra0OB/unZOJ8LSVR3SrjXptH+l7zPjbQ7PV9EtFm1Z9kmpSfBoMq4GOgDP+fusWnFi7NnXOxyQAaaS4GLeHj1sdf53NqxUJIEM+BlmGRiaF5WscIVNY1Re6LyzVWVRSYRjL3zvRaxmXAMfEIhLVORgvyISUrYOP/pzMfMQUEMGoIy0PcaxoIphhassmN5iLZEoGI4YY8g0m21Vkz8O/znrRuBmA0iw
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 15:00:06.0457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a034d3be-d90e-477f-407f-08df2095d84f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000009C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9897
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5B200180005
X-Stat-Signature: tazucdigkdpoy4iyrbkm9z4wfeun6u93
X-HE-Tag: 1790953216-725488
X-HE-Meta: U2FsdGVkX197TgYfjdoFE0oLEzt7kzzGLA7BD0/SPr+fb7loEaPsYxFJaxTU2xDl154FYl6QUOkz+bNwnLt6t3aeH5lkb3VejjpFB9sO4imx4I4CBtI+I+ssU92r/Z131MoScvd0P2p6MSHyQZAIj7JRaTE7VWJEI6QyjFK5mNwf06+yOCi7AnP9/YaNMy97KLMeLcZtiPPDOqQHw8JmfKmw+qTi00EdyIw7/BUnkaVs59aOh970qhKEUvJXqD4n/iWPsB3e4PCVkx7rMrIMLhkwJbnPqDHPUiHit1FbgwSakSnOYy6v9zN0oSH99JizqvEgrPb2qxOGPpgcu2KPxr9iZNc/qnVOrXBKUTQpobymr+/LdxhEpqPtfZEfBdtD1yVBPBufPVem6MSQHQaxIHKZ7S8Er7iAdnA9HnfZ7aIbLvk2Zbim/PVMDz/RcIYQny9ulXWDxJEDBur1b1aOoJRMlbBSUhSG4JlVhIVzTELV+O5HMprwt2syaMLnSn30d8aUb/kvwoPBbmcD1NwLjMxVk5Z1sLR1vUnFyeaFmMHRj9heesltkJ69y4J5EuJI+jomMTptlDpi1OYmaCQHRBGPNRO+hS5cJRcsj4V5LjqCBmzGDsqA5ROEQoLo29JQJ8YctZYPT5FNdaS6/Hdmd7NQY/h5t8S4w0kxULvzL6cqv8S8um3jkMqF5TA4j6COJL8JhjBAY4UvRiXLdEYx+rRWt9UUULnzl503BMiIH7rgRCp4HQJx9WYRf2p9dXadn69u1lchQvstjxcec4ZuqIenRBjMSvGdqWaLIzQWydbzvXW+Hb6OZpvQC4od70zv6013yUkyMQc12JAbMM3ATJ37bxutSf68ElfNGAPb5bOSU2EypzxW/Ko6w7ENPw6pjzdj2Zu5ZflDc1e9BamsIBUM1M1PoyaiL0MQRWuzTuVICwwhctOyfi+Q+lESKT/ftH9G6A+gavje/41yi12
 LY6feVEw
 KWf93G4pHoOz4Cpya+pxmzttTfp7p51m7wJZPTY/sF76fohB/O4yBLzv4xabdtxEeiu230W1lf1iniX9Iap/gyc5tSvfbe2vH5PB4ItszgNiYhbs5eeRXzAJ5RvNQlFhOOwKGd8gtDqvBDV//5qLP2XtTCd45m7x92lg0tQKA1lV5mSbtgxV0P50Q3HpteDxG4l989hgsJALc/i07QVn4HCKpDFnI6sclE2sSgttJRWLe7qaYLXk5VmAruVBimNO1gHDiXtmbLaiATW4i9YOPZX82+4SqD3iHWwV3feqwXXDllfUcV2VLX/GdzL0Mk7lmfcPbh6ANSvzN+3/2ymbrAlvSBBgT9mgPr6Z6FjMjYZcDlGuftZsrcfTJyePT7BsxuVzqKRmppKl9SYocZzug2WLYD1pSRQ5sUk91w1SeHRai8awfQCYXUoxFgU7XjiN2ayjfko28xmf/lgbi5oPsqhCl/pSKWj4LJ0PJozo/wVX7Lss7+tWpZIP6FJ4BaDJWM182y53/Mz1QnChd1ERlT7Z0Xlhl4+YiX0EZnlWvhiio3BlnWe5aRj8+7x7CgSKFMFg9hbCsQDTUcjd96vE/vPC/bQaF28xN2DdIzXVfFlOqRSBsj8vVOP3T4folnDrnyo1Wq1x1W5Aq+KqQp1ahDody/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/10/2026 12:19 pm, David Hildenbrand (Arm) wrote:
> On 9/22/26 19:12, Muhammad Usama Anjum wrote:
>> Atomic PTE updates need an lvalue for the bits stored in an HW PTE.
>> pte_val() only accepts a SW PTE value, so it cannot operate directly on
>> a distinct hw_pte_t.
>>
>> Add hw_pte_val() to expose the underlying pte_val() lvalue. Access the
>> wrapper's __pte member when hw_pte_t is distinct, and use pte_val()
>> directly when it remains an alias of pte_t.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes in v3:
>> - Moved from the arm64 series to generic series as it makes more sense
>>   to add this in generic with all other changes. Usually we only add
>>   code where its get used. But this whole series wouldn't get used
>>   until an arch started using HW PTEs.
>> ---
>>  include/linux/pgtable_types.h | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
>> index d6c5a7548550b..ee4eace5c3e1c 100644
>> --- a/include/linux/pgtable_types.h
>> +++ b/include/linux/pgtable_types.h
>> @@ -9,9 +9,13 @@
>>  #ifdef CONFIG_ARCH_HAS_HW_PTE_T
>>  typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
>>  #define __pte_from_hw(pte)	((pte).__pte)
>> +
>> +#define hw_pte_val(x)  pte_val((x).__pte)
>>  #else
>>  #define hw_pte_t pte_t
>>  #define __pte_from_hw(pte)	(pte)
>> +
>> +#define hw_pte_val(x)  pte_val(x)
>>  #endif
> 
> I was just about to say: this series doesn't add any users. You should add that
> detail to the patch description: "prepare for usage in arch code" or sth like that.
> 
> With that
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

I'll add to the description. Thanks for reviewing.

-- 
Thanks,
Usama

