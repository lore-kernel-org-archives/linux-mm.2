Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 154A6CA5FC4
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 17:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90DAF6B008C; Wed, 30 Sep 2026 13:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8710A6B0092; Wed, 30 Sep 2026 13:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2706B0093; Wed, 30 Sep 2026 13:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CC5C6B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:47:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00ADD12019E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:46:59 +0000 (UTC)
X-FDA: 85271159400.15.2BE792B
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011009.outbound.protection.outlook.com [40.107.130.9])
	by imf25.hostedemail.com (Postfix) with ESMTP id F0C17A0004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:46:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=e5YpwPeH;
	dkim=pass header.d=arm.com header.s=selector1 header.b=e5YpwPeH;
	spf=pass (imf25.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.9 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790790416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aEn4ubSlfZC8d5zvTQtfBiiaBLSDPSceR3sArTbNzQ=;
	b=bEuhbJBpp4ZuDs1mIfeWcod4i4X420+SJs70w9/5ra4K4f0sHL0ofUhqkHbDNqwkD7fvaX
	0CQ1XD9heVrOJbUkYzKQqljuW1fBAl+6d8Cmu29OfasoS8SHtkrOdixuenrbslvz5u4pdu
	mogmJAdxZq0GP2ELMeZD/U0gC10x0U4=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790790416;
	b=3TW01wQ/l9sE6bIgcVyCrmY4pSYxzbWzGM2GvUoCt6Vq903Odngelp5Ay6/Yyfa6addupF
	cgwzH0DuEdo8M/3vjw/c2qqXlEGIHVPWF7MZsazy5gv62qb9Ocr6N62ShSjczDrzCSeTgM
	iIGOxgE5MwaS7ST+YXoYKfMtS+mhPqA=
ARC-Authentication-Results: i=3;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=e5YpwPeH;
	dkim=pass header.d=arm.com header.s=selector1 header.b=e5YpwPeH;
	spf=pass (imf25.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.9 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JwiS2CIGnOkUV+AZMoeIIiArw3Q+f+CWoy77vL+I6EUZy9uApE3RLTRNfPjt8Vw+6Gfeo45mBBHTdkI3HyLRa8kUdCZIokvaCCc7/RhY5G6Wl7ZpY7VZgLR6yo9E0rM7v3RjCQi6Oyqg6FdRTPal2MrVqAgl2U32tsLC0UinugBKo8GROCRr3Ou14xjlH4184F3rPxkCpCduiOHjHThHUUPUjpuOcdLcUNmbeq6+dHyfg6wTzbgy8+20r4FmhwIpeNLTMejkF16CZCcHJDw4+ncB19PvNIs4P+2QjW41HvnVZtWACPxnkqRvyFpMSmEmlNxo1SBiHnwvPWogSaPaMA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9aEn4ubSlfZC8d5zvTQtfBiiaBLSDPSceR3sArTbNzQ=;
 b=HfbfXNDEQN4ttV2I5UHEqYbL201TEUR6a50q5exuAo52Ht83TOj+Za8wv9kzDcMCIERs/NQr6EwI99BoTETuglQ520LwSHXkS5t8oNsNP1XqPIkvyd/WNCW4j8UTey9Z85bSSlysSkek+0aUIx5MnPpEzzk1Ntj/41EHXmovkHmmsejeipEmhedZw4lQTI5mn3X8cV97kUSf/vVApGGT+UCgC0b7C57/JLHDT6va4L9oS3Pkf/oxc5GVleF/fYlJgnLOdBsv6JX2XnwD9Pv65JEkMFQ2URS1jCSDY2H/Mp00FVAysO7QFdi8hPeC0Q6jxz01GptsfuMAhw2TZDJ0zg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9aEn4ubSlfZC8d5zvTQtfBiiaBLSDPSceR3sArTbNzQ=;
 b=e5YpwPeHK7pAtQ/qb0k69OTcEWf/KbpXCCJPLXQkuM8RXGXpBhD/XPcWItkbKTshWp5HIMPueTjwLWHAXHn4t9PsGA361buN5J/XU1M89pp9C/PNyWjkcNsKAMkkyZGxuuGzBHmaWDRIw9Bj2+WXSKzelCztognoPierPFf1d6w=
Received: from DU2PR04CA0358.eurprd04.prod.outlook.com (2603:10a6:10:2b4::31)
 by PAWPR08MB9053.eurprd08.prod.outlook.com (2603:10a6:102:341::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Wed, 30 Sep
 2026 17:46:46 +0000
Received: from DB1PEPF000509EE.eurprd03.prod.outlook.com
 (2603:10a6:10:2b4:cafe::66) by DU2PR04CA0358.outlook.office365.com
 (2603:10a6:10:2b4::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 17:46:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EE.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14
 via Frontend Transport; Wed, 30 Sep 2026 17:46:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kfkl2k50yIYjdGeMbUiIF0rrLLmt5/RkXdUnQVABHxYJT7Eh5OTIl9ZObXkohhFG/096DXxPKea0hK+UdBVNlB+rbDP7uCbeg8t2jb/PojZQarJ1Pq7hFRj0NDZ/5dm1E/3ESQk9QjWSDqa9mIaODPbhxpXkrbMBZ0+WsboP9vwclEhC1h2qhT4yqozVlGZgxkbrd54IDCGcrwprbr42T7K9hqSI3+VoDRa6hY9eBZf2laSJhfFIzeUiEs48q9IcvMZL21RmgNbsMoEa3eXqYx0EqNIMxVO/US3fFjvorKO4EOKTZ1R3TnjECWby5jX2YlQw3vwCGKR0YzXImFfEBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9aEn4ubSlfZC8d5zvTQtfBiiaBLSDPSceR3sArTbNzQ=;
 b=ZsggRuyxLjcd8+2f4JXPpiWJb7z/RdwMlc/1OsaKp3QfGH+7efVgUS7TRQ08hawPnxT9HZf0Io06NQwMx7j+vsSWq5URWBJVw9sLsLR2GraphdNuJscW6zflIaCHH/VRlwWOAb1g57Q3XS51Vg4QO4Ae8jm2ddAN89NCXmxeHIIrXnrbqSmZpUAe8CqLiabrAa9ZMZduVNzTwW8sqCtOIDiRW3qj1eNCtci7hVWc9hoDkgcKRT8lpEKnTS4wtgDGyRHQpTnF3mH5aMVZT0kPlClhF0tYKmwGQyNzhYcm+Bgezg9a0RlXWmcc2WOVk9GbmrodsgUUfb4Bt15Ani7PBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9aEn4ubSlfZC8d5zvTQtfBiiaBLSDPSceR3sArTbNzQ=;
 b=e5YpwPeHK7pAtQ/qb0k69OTcEWf/KbpXCCJPLXQkuM8RXGXpBhD/XPcWItkbKTshWp5HIMPueTjwLWHAXHn4t9PsGA361buN5J/XU1M89pp9C/PNyWjkcNsKAMkkyZGxuuGzBHmaWDRIw9Bj2+WXSKzelCztognoPierPFf1d6w=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by GVXPR08MB11787.eurprd08.prod.outlook.com (2603:10a6:150:316::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Wed, 30 Sep
 2026 17:46:10 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0472.012; Wed, 30 Sep 2026
 17:46:09 +0000
Message-ID: <872cb298-8187-41b9-9553-b0db8ce0557d@arm.com>
Date: Wed, 30 Sep 2026 18:46:04 +0100
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
Subject: Re: [PATCH v3 4/9] mm: convert PTE table entries in ptep_get()
To: Anshuman Khandual <anshuman.khandual@arm.com>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-4-5670b8cb9059@arm.com>
 <dhokijjou3rh3poqnqqpyoyac7wrqeprl4vlhzqokvh4lgjyya@g5hwn7sve3uw>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <dhokijjou3rh3poqnqqpyoyac7wrqeprl4vlhzqokvh4lgjyya@g5hwn7sve3uw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0519.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:3db::14) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|GVXPR08MB11787:EE_|DB1PEPF000509EE:EE_|PAWPR08MB9053:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a19c08c-6695-4268-362e-08df1f1acc0c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|4143699003|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 l9hI3Oabjw6gk2JG4lKodRzavQcorcEJkMoiVGYQoSx+pVgXjpBAlCH28YVA/H2bcu8jFMcs8yxnXb7xuyR2ZeeuN3A+u+X5jWuxffvkJQbZsvGB8tb2uBFZcMGLiivoy9dPd61bi2sHr35UxZvCyrTIrPQ76+Sh2sG/3DyjHP+QMizypilAoFcP8nV/cWA80tumvBfHgDXt8s0K5GgeCvYY30O1n0DPnxNUBEBPK+clJf86c/ecxBanrf0WDwK5w1+ohTRBoty/hYdwebuCRhj3cWPqashM4L0j6hDkKLqyQwS4J0YSQA/fplSLcEQGX1nPD6kXh+XgqZ6u1kmMaCT0thxOi//qNQRgYxJwV7Tww3rnybN+1/5+/OZFh3zTQRTc37nGRDbROuSbe44gV3OlKhLbhjydQHt9rXpzeKHFAxCsX4ymZEQn5KfvB9SPdu1nsJM5tQjBQIyHn+Ax5Lmxko0RWGD8vb4+F3SUxwt4u0CysC7ovuOkCU81v7Rv7a3BNzVKZn6M3zRo4+hWZaMuHrUz1Fk81k6aU40s+kApEGWtVaan+h7nng4xRstkSkwPCfXrCT6XRLfHKHjpddNUzRQL84YDM4N29vH/K1BYa1Hyqiiw1Z6rGf4ABzjRiNlIyrEPDqwbJOjoy3McCnuETTq+P+jtnn0aqiqe/oE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 eoqglAgi1nBFmowgDYlmh5NsECyYCBBi4iKTD9HbyKVulUPH7OOZZLsafvPdLMO0oGoyPr7qaWHY2xesx2OQgVrH8JjZWtRk+t2XFLls+miJxEpk/QNUHsdCTIVRZIEYchd2GxPo17AQbM8nOhpZGYr16kOEfKUAasNgX6hcSVq8VsP38DSl9e0Y2dXy4RuwwYxY7Q7tBFLpU23WrT+9OyoCvb2Zu+xtx9O6NODp48Vj6lwcxGV6VqlXLdLC+Am5PnyTIMZsyGsZpqGmVHqTEhQOsvasmM9HQmSiTCySlMCmtES5hRd3FveryCz/uei0/g82wRy4F+uBe1UTxz5Qiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11787
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	99ea4608-baf6-473c-408a-08df1f1ab5ff
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|23010399003|376014|14060799003|1800799024|35042699022|82310400026|22082099003|18002099003|10067099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	M9psLUbm67Gle7zWN7Mv5g2T1S2+5/Aj31RAA8Wb249+xK8m37LW7a2HOJ873nKuNl964dlF050bXvIC4ICTsVyMS/cNmuacIDoNpTlY2Pc01MxboOlLbQNwDqM2bzpx/GIO14R3b+f/qoudBKlg7S8LL34FwdbnH7vx4/TFtMpzpS5MU9VrxVq0bdywmLxLlfpyK3wwTj3vNkeM6Rs0q1OccW0SkH07VeQsyoveU3aOaPN9DtjzWDvHk/6YNrTdBiexQ4QuJFeocM5Pgmn5nWXxnSHlTyfF00ZSVnoJuHwTQojt6BRn14Fq0Slzyq/Zq1aRtICORrSM8phBVvcQzs27x9iK/LfZRKxDRm4toeWD4OWmhRUFjo0FqHIdRN2B+I6Y8J6skPmKk0PTzsld8WGw3QyF8XOcwEfiLt+TLIvZnGIyA3B3WF/MC/Ai+yTHRsGIFgD4z7UgNa0Rd1ZhMP7YdvXMzMu6tYUSe4+W3zSMnaH3qfr7lxQbI/5BI0owLcH9NmR3obF4WFErn38CmqELIG35z0ghMJyHZxMtyRkJnAAgp735rbWVW15ULzVhVgXLGmdnX4QySA85XyyiEGA6W7UVKkDrSYtCn4agfMknhzXc4tnv+XvkhMI5xbWvz9Cw3cu2vUr3M942ognYwysfWeHh6Sdl7j0XyS2+DhkLhYDdqihJ7QPvwLR4P2mOUjenqG+dG2GU41pKJ6a5nQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(23010399003)(376014)(14060799003)(1800799024)(35042699022)(82310400026)(22082099003)(18002099003)(10067099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ltLhjch6TQqHa86+LyWu/PDTVk90j5rUxriYipjlz9Qj6BIveih3d1jHl+ZgpT9pJfc9gTZNA7DnzrIw10lDIV55MVEQKu+vsWplj0iH96OAxoduQRF1CJvYPZ3JJsPaFzBYFEfg41fqE1bN0lj4C2hgdvuo3/k91DeBcoSq5hsr1wCaoMFn8f+JFh/aekN8xAOCp/X51CUz6CilUwgKqk3sA5n4vCSCYVY92zYGFQu0Zhlig+u4G0vJaEcmGqN978RpoBOhDhr8jhhBF8WPV5S6NOjQrgYjsTlULvc+ROAan+ifWfmRHIdxLydYJfrDdXd/JR4AfbyG4Qem5huAWDeLqwi3DCLSMe49TH/GlTB58ZlZd3bVK4J29mciIasOpDai/flrQzW9A2ObsGSsAyT6JYBb3eMp+BBDzXjOdaXbp1B8KTUAbJIoDan2fOBF
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 17:46:46.2135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a19c08c-6695-4268-362e-08df1f1acc0c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9053
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F0C17A0004
X-Stat-Signature: iy1c97wqjc9am5tpjtkgs191i36tf7qr
X-Rspam-User: 
X-HE-Tag: 1790790415-970835
X-HE-Meta: U2FsdGVkX1+otxDp203QTeRTWDQduOpYOOHdTz5z8t1BsOoVx7AjVlj2CCIZf3oXhNMRUZ3qgT9h+fvkIpyopwht/r+qXchEB7Ga9mpohf1wlmB1PmIiqqPoPCzWoi5+Cs8nNJgcygpf5DGwe+AmegYE01NkzZNxU6rojzy4UEpGXJxkbyrmZUU+QTC8fPBgTHD8gseKrpSc9FD/opKxfwO/HmQV7VhQ2qWzi2+ZTjU74D1+TkT95Pt4gnN6V6fTnl9CXlUc112648nGxHIUUffL0qpNRT2MlSACBexPp84/b1K3lVF4powBkgHirNSPAA7h8SLs1E9FalzCjWtpTw9XZ5suzfq3kWbn6g4xfLbpDY1azAX0XFRggK18hid7iZT3Z8qfKtK1IuZZLdtcaR2g3wqXJXZ2Vb5wCk3vA/qEVYGapDrTcaQvq1YUgHOH8yDDKVSnLLrkaVngckmMJz+EHB5pqWpk4eZfN4iWcpgmsDcyCunX5H1dp59aPXa8LVJrQASUAkiPbB8TKM9amYKXJ+5/upbqYwSu62i8Y+URadH8GnTS4AbvyT1DX/d5CtK0xABKKNdYbODjEr8Zhp0vvsFDmOstei2sNPIj1hFa4oIHTnkCf+Z77acwtRj/a7uyo1NDCINvDhuFQQpwzog/PyudbXzgxlLKLK3d6sy5enIm/7cDgLrJSzTKZjmTmBhuDf6YWaqKw6TXV49KDnOJUdKSWQ9wztKEY2PES3zr5izmqTP0M4vGxxAJcUvr32/b09kDJv2fUOWlH7puYXkB31IBo+PBUMLo2dkKiaN0A1St1ku8zqiXdZ6MPeZoE3Gkt+ebfhbDUi5DEFVQSv+HamuT8eVvPZrh058dY46sLTvv5hlfG48e7Sd5zHds0lmJh6e0XjS0C3H6AQo0ygzgqki0O5fhE0RNlIDHcj3S32fAA3l9We8YBFoBFzBbX49g5Gk+aW0Sfh6xQUV
 SWR+tOet
 DVL6lJ+khad8GRxVNyYE8xIbA/EXQtabwwWpnaV7bXO0GartmnXTtWneYin9Obn9pVBIxjk0+9LltvhwemzxHA1QhwKOFsxOYD31cM7TKKGmTavAqa21nHSqRQCNCZw0m0P5oGdhw36SwgqanSUR/m8Kac9tGZyAwm2EOJYqpckkQ6IPirAWtVvcIWiKQvQkNjEjTIgCjsA5K6ohp5zH0U70wdB885GNcS4v/lhZAC1ZHqYZP/JY3L111zp4KjnSeV9t8u/jrZeuwLvr5wH07HCk8HEHQgOcLHujCgwBknufCLXKteFFN0tD+UYaHktnDRyLW8chWRRMtUumglh3gMm3Cxo3SXHigxwykV5nsdUT0SpE0J+IHqI2mAUaxaVSwM4DLXtGMqnW90YFKpgLQcvpZVV2DraRx8HY+NnuzC++DRug2QiAcHjRtjaPB14oyMkKrzAdwNu1VQLf+sP7/l45VTMkez/ulNpWdhLfKaxtXZIiZBjklV7vX5ykW8D3fjodSSyiejuwpnHOnuvQrr3DimTODi0NbNsohopL8EHADYdaVjppYQEMNp1LaAFhJyJ8t/hcDALVo7ENOFVgywfxHWYvajnNvE9q6CAjdO/y4tCpyqB0hjlW11jZ6N/f/THkvtHly40e0Qs+SE8ZDsCPQQnDCLf8yuA4zzDzQI0U+Vk6nq6iJs8SaheWU46HjNcIjbFXv82bvcfTpNVIYT0Ew5XZWBVub5UNrYyURMD83Y9eVzbzeihE2ob+0xrHlZ1Ddr5Cn7eK3qlvMEdM33iQC79N0FuU/4HS0Ur5btJlofUyc9Mejk4ihoDw/Dm2/40QwLE6CvOHzR0a0rtO+6tnYs+KNxpp2/04jinGWIXJH1ZrCU4PSSGGWWMbtKJOaFUV3y61jLzFet4F6XO6eO/dlE3mBbg81jF1eImBHlaDcDtBsJxd1QZeZk4Lr7Ct7PLkgewjUFJMVfRujKxlGsbqmPy1f
 bN2djs7d
 SKWMXgHYB8JMoHRBYKJX7pUnw4WI/2zlvvJO5hLyNxF6YauPb0xrEQ7MN2hiTTiW/vBfrQBQfQZ4fU0t2WSmSEqDXpoxUPQ6YGbVPaZMRbv+RPkHXgMBvOqmAk34qh64M5/zkTDQndnbjjY3FgG+39T/xB8XalgE9Q64OCptOThxl+93s+Bmx/PXpMYXcWy2jABagy60PJu/jqG6Aqr9hyTy8KWgxXAGvSTeyrAYMUyWYWxN1gf4dvhlriAtAvVsYdnjMNPLKPhqw8NjWb4mFBw2GeGjR2Pl1E0HecfHhZwIyjl/Sfbi3qzJ1mbxyVEhQdDtAAIP8DeMVTc+Wu7qrToqDw2fZpJ0cHuFP+L0nANnwl/R+XzzpDKKc12+UNNuBXtSzb7A6DZwG5AvEQD3qfTyR4r1irg73jPP9NNu344sljyV2fmdD8KOK5CsplwDC/cPyxZBE4aUMvE/u6oFQr0V65/qgyOCP/6KP1mRtAxsOr9PwKUQZYLSOYdAfzSQFSASxIUA9XJ6XkfH7LEWZM5z4US853Sxuy52RBQCq6qjrRz/sG4zdzqz23z6BVHCvIb5KMQug2U0qwuRvDiWYpOXZrNkUzZiwDr/tfzNFKpidyZQTxFc3rzHlKInb1LcWm1TerR/56O2XUBCZdx7qqNb2aYGymPIIB2IJAvjjb+nBkP7NjMATv++bCSUuYGh7C5T8qsjKhtctpQWYXU09RlKFJcD+xuydqFwR2UCbp0x1HVKj9zSRfxLGZTTHN+E7c+/0wvS/t5rvYpVrO3Eu+xyokta5tPRjh+KYe9bO68T+xqKlvuttvmo4lZpUbeyjLqH7P5y6BPVEU6Dvc6A1GcU2GWUtnuZcBYut2GYQoo3FtM9a/LIUEc0a/i8sKAe05ltZqPMRUf1IdryFX5wguBky2MGa5SXoSWM3/0cG7IxTSFC2vU0AW2kV8y5KcM8fgXcD7C4B9zZfv7ZztC43DEOdDo4w
 1AhwLpgd
 VH6IQ+b5FkDSUz1mRJcGbtWV+L+15VgLEgQE4YPxOIkGUUQZNdXuy67Zcqc/MnQaxWbAuiUsiznmVPm5vgK6dq0JXVWL5NtBTUT2YfjrCsrEpaGwWc31U9Ozq6Be1ZFJnZplsOFPdOB29gVGZk349krwErmPN4kCTsHDV1si48F45gMGwFt299ES40anJpqvPCLgxcBT0Hm/UxMRZTWGhYqgP0OB5pPYra9LM3p+slyOfIzzSgqmpTp3pefIvM+y1wStiITW+SgJbXFibX/ILoSOdakLI38QN3caMlpZLOp1LwGon+iqx4v60C38RrI12xyDGQbbT8QvvqUgY9OtstQq0/Cxj8YKKY88DGFDTOJ0ipEsWjI1NNDuWLF+cG+Zpsme3AlslaLGz9W/hLZnD6jD8HItw3O5dDdx+yuRvEOhTUWwu6cu8dnCXRRgb4wjhu4EZNhAv83/6c2PAPlc3hHitEs+lJkEJIF+eCXX4z8csWNSEO4iEhZq0x8HqDVQNcKXLugoyV71x/zfYMdDrEfS+nZdMCONyu8yuDf1Dl84Q3ZzU7TAQo21CcrtY6V7+zTDicHKnmkYzNlpD1SlNb5Nro+VSn4ImuVyZeqeiPdcAc9LjvHngoA4l15Zy0Zwm8TfphvwSPLivR/07Ht1WWjxAnGhlP6saeV6XLM+boSLrDHUxgErlHKqXsFM45VeN2NSecooGtygykeQ6iDuc87o+sR+oKUAnaqgRdN1yN7b8V3Vn1auYR13iA9UZG3bEII0/mrq/MFccAncje1TrSXDgzI6Kql2Ts7HwBWeFsXFu9WWHRYUaWck1HtGQaWFYxoLw6FYfWER5l7uU8dSWYFOsfqNvXgTZd6VKgnL1rhchwFCHvDM/fcIMUBz2ada+ijawKqSuYJl/onvHd3Xm+sNXQdTbMkJG7qprNxIt1HtwUA5knuMjEnrqibEhLbEGWQXmXanGpTnGczdgKOFqlwIbj6gN
 7KrP0Vjc
 BJnFWjMDHretD6kKFgNeG8M7s/3H2xwZ1ch9f/xS3luV7dcfwG3Wn3a+49xVDmFsYD+CWbNbualjbSxjO8E+E1LBz5mqEo4lmHTulgb52mAbuxHGoi0ixJgXdzpw2iv+LmiqsB3YCwSAHFeJ1HYwN9BSWBf7xZ+jUy0PL+Q55MmHYaW26LAhXpZchYzGk2HHkYSiz5zwzV2flI+FdvAy0HDDRs9xXlO8EWtkHtPBM6ip0ah1CM0h4KN1oGsg3tFDzv/SJogYusA8TpX2Ju73APZxSkrUsbWrL0MH5/TWc4QGHz5PT0LVZAVWBFpTkfWUNiaLIXoezYaZ7Gy8RpjUH3b7Y6GtzjZ6eAt9X/lboQ+G8UQeoAJFfXyn9u6uN/bzt4WV1K/m8mYp5RqAbcHFG/g6czsLsI0t6+XUy7G5adPffPhINgjch9vb56iO57I0RzZWjbe/DAZAsRh4rFiikTzwnPJ7W5H4poDLXrh2HWKU8L9+0PlB7saziuC30iMh6STBf87Dg+wfWQMu8D/WBkZKaU6JdHebWfwUNvSODMlFhXgYILbwfOpEMlLgH5DaJNysbX0Gkfras0C7yZJK2ySyr8bPPypXA/3fzInZWKbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/09/2026 6:10 am, Anshuman Khandual wrote:
> On Tue, Sep 22, 2026 at 06:12:32PM +0100, Muhammad Usama Anjum wrote:
>> ptep_get() now accepts a pointer to hw_pte_t storage but must continue to
>> return a software PTE value. Add __pte_from_hw for both generic hw_pte_t
>> definitions. Read the hw_pte_t table element atomically before converting
>> it to pte_t.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v1:
>> - Use software PTE value terminology.
>>
>> Changes since RFC v1:
>> - Define __pte_from_hw for the opted-in generic wrapper.
>> - Apply READ_ONCE() to hw_pte_t before converting it to pte_t.
>> ---
>>  include/linux/pgtable.h       | 2 +-
>>  include/linux/pgtable_types.h | 2 ++
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 19098e302b75a..41337da0d65aa 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -493,7 +493,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
>>  #ifndef ptep_get
>>  static inline pte_t ptep_get(hw_pte_t *ptep)
>>  {
>> -	return READ_ONCE(*ptep);
>> +	return __pte_from_hw(READ_ONCE(*ptep));
>>  }
> 
> Just curious - when would other pgtable levels (PMD, PUD, P4D and PGD) be converted
> in this format as well ?

I've patches for conversion of all levels offline. But it would have been
so much difficult and complex (to review and rebase) if I would have posted
all of them. That's why this split was done. I'll be sending other conversion
after acceptance of these current series. PMD conversions has some patches
which require discussion. Other remaining levels are going to be straight
forward. Maybe I'll send those together.

-- 
Thanks,
Usama

