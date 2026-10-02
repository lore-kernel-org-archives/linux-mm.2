Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D42CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885CD6B0093; Fri,  2 Oct 2026 10:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8364B6B0095; Fri,  2 Oct 2026 10:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D82B6B0096; Fri,  2 Oct 2026 10:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3192A6B0093
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:58:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26E93A077D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:58:53 +0000 (UTC)
X-FDA: 85277993346.07.D0B8A1C
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013062.outbound.protection.outlook.com [52.101.72.62])
	by imf19.hostedemail.com (Postfix) with ESMTP id EA5241A0003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:58:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=UJcWlmHQ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=UJcWlmHQ;
	spf=pass (imf19.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.72.62 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790953129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3Ah6swvMtWzeWq4SM6XIIUNRxfAhr9a8O2D5gmTT3s=;
	b=cyD4+YUqG4Lrg8EhBKu4l6f0cP4IbhZSESxrCyjd0a1X6Ymd0EOpcupX14yEInQ3bdxntd
	J13W2rV5Ok6DtCW0eSMfgcWmQDLWmEAza/Xhkd874ThvKAdrQDQXCc1Ai3GodcDy9IZiPl
	F/89/a3uaxihrQ4ex5lYJIGpfpVl0Ws=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790953129;
	b=n/xsjermtuXOwSU5FiDB3LOehztLACvry8uZzSFaHtNSIvJnIFs6hzk6X/frqmZc+7fg6I
	TG4cuKCEAJeLcsYb2XB7Ex3rcw0gQdK3uP7xSz/gnfXqj3hmLDSf4aietHwuziooDWeGC7
	iA8vth4SLnfm+jJilFeZz819XvYKp0Q=
ARC-Authentication-Results: i=3;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=UJcWlmHQ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=UJcWlmHQ;
	spf=pass (imf19.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.72.62 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YPvQ0a+7By6XQcEb8hlq+PrcGIxgwJB2znE1fMq4EOM3BkGN5jHzQfynTR1ygeg1QAa0gAzG8zxWPigEcBuVr9awwmmU7k2tB/ZAWF5HP6FSgJB2uachJBJu9G8YhnqakvUlQ4rr+Y2BdOH5kZDeiKWgSZl9i5ZOi8QerpW14Bi1Ps2O0WS3mI6dg0xt85fd2f+E9/M4tYwA+xF9cs4lasA6EBNC7y5ztYMrOkJ/6nrlD8hIMRh6zw2TrUMYqn0lIw6AObAJr5GssHNM1hMhlMbNX8YGzfomzk/XojuaX/VrQbl4DEeBHbxalwbth9zFwXkgozhtptj7fuVYVnbdWg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3Ah6swvMtWzeWq4SM6XIIUNRxfAhr9a8O2D5gmTT3s=;
 b=SJkj2wwVG1eZxAbGxGaoOnULq5H0zUO5cZEi6UUAnHwRxQUm9tSidjatutWzcT01MCoFKDv0LZeD70JgVEz06FNAQfMBAcuytqowro9+pE90fjHAUeE/nxDfb1Lu4ssqyST0A9WHGAstNe09+lMTTchaqwhOpGa62nIZ/blfMCfO38/cYPWOFDG90em1q9haR0FGn6MWDKFSLAncgrw5E6Jx540B5nWFZK6kq9HZIeD3l2vmgzziMNy8rZRvcqHR0mYy5A7g+F6eNeeG7rJt/h/ZV/cFs4888JgbvGJkSBKlHERT5cx4Mpkpz0X7kJbyG7DWus0/LWo5TnQTump44g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=intel.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3Ah6swvMtWzeWq4SM6XIIUNRxfAhr9a8O2D5gmTT3s=;
 b=UJcWlmHQHD1z6UzAsf0AsXyWIx/n+YuOAR8uwm4lC4UsM/1VWXYStnqfg9poduspEls8OzGsiySlaYVY4oB/MorRmaNyIUCPBYKvmdCg1HJJnA6z9kcFuEy2+Bcb0H0JeQMlbUZK8KivhGoCbOw4ao+1HjGBB/BvBK2I1xV7EEU=
Received: from ZR1PEPF000077BA.CHEP278.PROD.OUTLOOK.COM (2603:10a6:918::474)
 by VI0PR08MB11501.eurprd08.prod.outlook.com (2603:10a6:800:2ff::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 14:58:42 +0000
Received: from ZR1PEPF0000E6B0.eurprd05.prod.outlook.com (2603:10a6:918::157)
 by ZR1PEPF000077BA.outlook.office365.com (2603:10a6:918::474) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15
 via Frontend Transport; Fri, 2 Oct 2026 14:58:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 ZR1PEPF0000E6B0.mail.protection.outlook.com (10.167.241.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14
 via Frontend Transport; Fri, 2 Oct 2026 14:58:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qf1ioclt6CZLsZI5sbHKKNFSAw7r3xz4tB6DNEdFGmiWnjOu4Kz4KF+DzZeXzE5HJpiiXiCP6cwF4g3zJGcExLuEFgfePTraNXmMR1pzCXtJmUHpOwPmrQAm+xjKTQxdlPsr63yZOIVYgPrIp+NsWOYn2YTFQ60InG0yTZG6A4lUgPwjg5O+O+b1XpX0MMu9w5zvTTsIgMbeRlWzrAKUkNoa5M+hRFB4VhS6U+h0hDS+AC+S/qFszAb/1OMd47g2tdM2zzR4k5nl6dIKwEj6gXb3kjV/dn6j7D/JTjLbsFRCXECWq7fhORVbvwWdee0fUlbZqXGM1uCj2/n6q30rfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3Ah6swvMtWzeWq4SM6XIIUNRxfAhr9a8O2D5gmTT3s=;
 b=mm5FZi7KiBf/IpnKgskI5Q8S4CYFgRFxXU6qHkW1QRE2f/adMulUNbzu58a7+D0WjlxHVTy5AD1wqskKJmJgT/PUuAJ73Vxc7VP4YQW2xYVzY3IjG3/LZ8NJhFSnF6Hc9YSR4Nvx08SL0aYa2GonfzXPlB4w9sXdtZm1ZDk0okUiaB9SkjKtbnBb2pr4x6XANDziWk1KJCTBDZd5JJB/LR+EgHza5b9XtxD8NX/QLrd9j1x++hHIQqeU+WEKUV4hvepEFdD+ujiQ3dROlfvA28nevX2u3BfGBOU+yvijUYCPmfgzoh8WUR5RVCNDE62BrmJvcSz2tzapYtJkAa/uKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3Ah6swvMtWzeWq4SM6XIIUNRxfAhr9a8O2D5gmTT3s=;
 b=UJcWlmHQHD1z6UzAsf0AsXyWIx/n+YuOAR8uwm4lC4UsM/1VWXYStnqfg9poduspEls8OzGsiySlaYVY4oB/MorRmaNyIUCPBYKvmdCg1HJJnA6z9kcFuEy2+Bcb0H0JeQMlbUZK8KivhGoCbOw4ao+1HjGBB/BvBK2I1xV7EEU=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by GV1PR08MB10856.eurprd08.prod.outlook.com (2603:10a6:150:161::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 14:57:59 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 14:57:59 +0000
Message-ID: <72ef1c9b-9712-4e08-8f92-3984de7df54d@arm.com>
Date: Fri, 2 Oct 2026 15:57:54 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev,
 kasan-dev@googlegroups.com, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org,
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
Subject: Re: [PATCH v3 5/9] mm: convert PTE table entry to pte
To: "David Hildenbrand (Arm)" <david@kernel.org>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-5-5670b8cb9059@arm.com>
 <e94dd0fc-3381-4545-9ede-513fcb2b8243@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <e94dd0fc-3381-4545-9ede-513fcb2b8243@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0501.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::8) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|GV1PR08MB10856:EE_|ZR1PEPF0000E6B0:EE_|VI0PR08MB11501:EE_
X-MS-Office365-Filtering-Correlation-Id: 9de1d168-82ca-46bb-9fd9-08df2095a5fc
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|11063799006|4143699003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 0dhx1+S2wgcHNIZ4qGb6jCMd5Ad4vFWeOzSxNAuAiD0L95N8XDyuGx6rLwOXJL7u2B3bOGcN89zRKgMuyPe0q6si0B+kude0c+MDcBEnHlA/q073+A9lvG65InILmDoD1YcAqKXz95iVytxna3n1/AVgcSL///yDu/oDy/LD2A3/oeuYF3RLd+KcomCEIDOJ+U20NsbWQ38nb8/1FF5nSorWji1cdy76fj6UJHxl2HtLS5GuGbCZmCeiZ0IBTVXvP7t7613u8/cbaiSstnBCLA7cdi6E3oHaiueEllKmVyhwyqhgKCNR3JnZife+YMG/wgvj4CRGbbFWaSAfx8FF/LUa4BdGC+nlj/TwhYk7sL2ppHk+0kWDxZrB00TJIAqU8RXwj+XQD6LGoCVHyumk4NPvVsAvFFClaErEmd3KpYu9cCHUyiXEb0JCgcnUjE+yFrle3no3zw5uust6hdCiJR5vXYo+VRlN8gPOaFEuycTP9F43C7N129xCbhOnRZ9ffOnIqw0K8+azdr5GDhQ3nN0Gg8xgBlhGYfqgHWJvyox2eRpy8pO+Scq4qgPzsgWxQ0AciYsd47Q6mrpVrNwrScBMOCu1p275K37EQEsJUxo6XQST2AWF2YkEhteHB+GDgIPdIp1vEjJX9pvUNyirTQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(11063799006)(4143699003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 0/bqb1pcygz+orArl2yLvdFr2+CAcusy52mCrAntYx/z75bRz4YGBpeFBJL8hevynK/I35PHi6CiCOo37zbLgE/f/8sDnEada73834TrXRDGWJwPLh16iquDV58pf/xECOVta/qXB5sKLJ12//Iw7Ii4nna+UmtTsAOfm1kJOZWY6FlnPXNZG/LZcW+/ZQTChENDFBhvMyX8Tzm34fTJ2nYi78qbDfS1u+wzyt9EZmdN812OEhJwP3Ijvn9TXiIfZqheZvrMMxs3TlqyiMwWNlknrXvgZmCVyphpy5Ez84SDkEixbQuHGbg+RbATsUJx86/OPFCl60YmuyZuk/8KOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10856
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 ZR1PEPF0000E6B0.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8e313be2-c88d-40c6-d962-08df20958cb9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|35042699022|14060799003|23010399003|376014|7416014|82310400026|22082099003|18002099003|10067099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	yVl1M4jNnGHFJkmLJcS9RYzE5SBcH0bc1tsVO99GTgm8SJGcX8jJbp8lyZpPj4rEhRtfy6ad9WLGH69HDj8Lt0AN3WdNz3tRyg3zxfxoOgm40auR8NIO59cgoqGGcTxKh6W7LYTaiZjB1s6x4bgcLhrAB6QZgtsjxg5nAbLl9P2vR1WSttretgKO93YBKrGg9lawSPhVo1pP+myujRSVOOZh0tvOMApvXGAQ/8a2T4IigB8tcwc6sBasqbEPjWlUnlCwUgOkhS7Ny15UnN+HEwMZM8eVYzax2hR5lP6kmQQIBrhhPCCYEJ/qZGQwJiEoLkXG117P3qN1oW1sgIxcUcimy8YMt+RC3KoIF88e+ZLICYjpuMYIO0EN+YnIbdmqbBnC8tlCT9B6xaLdR6atBHLcJKpsiSZC1meuLBU8nVlIekETyAC/+EiE+h+Tgg7B+4oQNWvntbg2hwRfBVoObyHJIPuFo7BBnUM2vomlo93t4DXeAmUSvGbCvga79rkPQW9m7k2i3F0Ixr5x/a/wYhqOoVHhO9TBySB37UnsONp78Xj7wnKgreJpi+FwTfiUGiu0LvMBlAvHOspXaR+GA31b/7rWpvskGToG/nhWtOmMRVCjWVEe+W3ToIHnR4tYBjjYK/3GJzVCrn5hUQbBzeqGl/reYDt46TffoR7ORnNoT7ynPzfebkZb4VWAm3Ex
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(35042699022)(14060799003)(23010399003)(376014)(7416014)(82310400026)(22082099003)(18002099003)(10067099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4choth8Ewo2VDdr/aMZR1RmHIkPrJdtW4soA+TmIYNPe8QMhJpaETjcZXbUMT0o8uT5VLeA5A2vX0i+eQlCLeX1fZGy5YdpjYxTbKTtxFy2DCSSqe/RiCaf3KPaYYUAcAQ5Z9gl9eRoQ4E1vk+ISGUN6Umyz6GAIkpczPF74L20HzEZTTlD98i6BWKx6rIV/vVTEARoDaCHhd2YfsC2qzAIz3FXQuPpX7Jf9itiWKg2inLb8kDOE11ucrZTWlRjtTHuNoijofc7hrXlyoZvzLc6WNxcfOyqCy+ybRPgijzkA6zbYu6NPKMv4Rl8wq7Q++UaTyMzCDHJiQGbjlsDSijSLvFyPfkCbmaB50CDo0tzCvqEXXzY6IOoGPtB46WuE/PIv/R/5y/dy4joMav8HxmbF6ZidtAZGxlm/dOZO22mdYHrjBKssfpmOnBh2uU/M
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 14:58:41.5564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de1d168-82ca-46bb-9fd9-08df2095a5fc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	ZR1PEPF0000E6B0.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11501
X-Rspam-User: 
X-Stat-Signature: yjqchkrc98umgk5utiq4o3p8ab836fro
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EA5241A0003
X-HE-Tag: 1790953128-692730
X-HE-Meta: U2FsdGVkX19J7RB4SrbDF7dGVUcSN9WeGYtC3DefrbOVLwZ0HQsbdqYr0dayeP7YS6WH6u1H/fMIanLh/ESYfmkBP58rQT1b57wC6CNYp84gUehrIzwPWfgsbTBjByMqDCPuHg/ggGShnjVEwNHUpLF1AWv7xBcXVOp4oLCHQ1xMUzNnFKMYBfoFKpnUJhOsXPPD1JSpcs0xndomjHEXtXwPMlYF2pQ5167QXnGlnWsYv3tf3pEg2VJsYewMVulH1csi91OGPM/qKbPGLzrmwf+ybIwhRRYFcg//MgHpMPYaMjfIZGvMXF3+WxdgVwsJMR5CeMn7z7/Y8xdmYSiwtc5HxqvWxElMCUh5zzqcNqckmpDNu1wN6MrX83BwYM9ZWGCWZzLDnvM0zNbjqpITXuj65iPSGSpceLuPVy/yHjAu3FNc78u5guKFWdGE/E8Fa522C5AfWJ6yezuE3ryz3TeGD8q7YBxNPdev4DMIH8GBVOkbyZQJH/71hczZeElrG6D7r9K30pP/zSBA5qQqne4vZUGiFtYugWVqCksHGgeqkSJakzxdSn1e9ZE9XdH5aq3JKf+Hyv6YqGu5hPujdEgwSjLbE6tSjS8M4jbRQqdqE7umKx+KNavmnNxnJSvp13gWF9voI0sgzpjb8ij+vrXJ4p/uZT1U0CGXjuOiiLCLvq6YXB9u+kix8MTuu7VtvTnw9MxM+DOxQ9n+l8f+cJ3OHA2uXD1/yKyQcfmSotfF31MjovQNxxdYreTi49iRsSYcKbdl6soouUK3B7Dq74OyWXd23Zfyh/WdSxHSkKWVro6YT1kT8jdsXW6XFR+OpJTlYIQZajTpBSdrxo52PIJdTXZLZA7U3FEZ/Yq7JqQTQttOfb5xGaOIgFET0yNPLqBOD/YYLR5t4k4XVF9oMyMW+LjWsCZPZKVPhth5RR8Ws7d07GkLe+bXdR+FNZs8zv6pDLO90J15y5jrTJ9
 IQKl4uc6
 cQfDuEgWsLPNIC0LTD79TvlaJmuDyQyMihO2B4Wlw9p1sTPBrnxf63imxvOGCWR534u1b/+kdtvECvakYeDxIm88FapDtK/0v+noeiLWjgF8NyB7PWZwEEOfof3zQ+MzXyVoQL/FY5mjDOA/KPhRVI8SBkPYWjkcMqqDABREo9wGhcLLtGg7v4pLBADJuq9qZ0BlKcn8jx6COGMBSYmMQmKq3C9o7AoPRIaitAWXukwvrtdK30jfXsFs6pnMrrYaYPxrFnFN8PncZGEBIgCUVQy5myuxBpPAL1zYi6xO6/Y5c3gYdgGDEyvuuSzMYn5Q7bzyVUipfNg0Stm+IFY5LKcf7USndkIf9GG16XTLF4D/GbQplGhVGY3EZq2fBcjH8KUUa1CkWwFCyznrLa+isXtG/R80T7Tuk+M5FG18TFmbVWJuhOy0B5wOnEqY5+MlmPyV/MS3P0QY72GhCMfXa23xM4Y8/2DGgAtc0r1jRwvMupavdZnkZFs3/z1gD4B8gN0JbxwSysmF0RjaVIemgpUwql2d6buP8NwBrIWfs4dEgrdqnNXiB9cPHkbGNisY2ifmZynTSLJJpdrgKFvLufWamnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/10/2026 12:17 pm, David Hildenbrand (Arm) wrote:
> On 9/22/26 19:12, Muhammad Usama Anjum wrote:
>> The non-MMU stub receives hw_pte_t but returns a software PTE value. It
>> has no attached PTE that requires ptep_get(), so convert only the stored
>> entry through __pte_from_hw().
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v1:
>> - Explain why the NOMMU stub does not use ptep_get().
>> - Use software PTE value terminology.
>> ---
>>  include/linux/hugetlb.h | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 0d2101facaa50..637fc863d3687 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -1278,7 +1278,8 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>>  #ifdef CONFIG_MMU
>>  	return ptep_get(ptep);
>>  #else
>> -	return *ptep;
>> +	/* No attached PTE that requires ptep_get(). */
>> +	return __pte_from_hw(*ptep);
>>  #endif
>>  }
>>  
>>
> 
> Okay, that looks quite odd. No NOMMU code should ever be calling this helper. I
> can understand that some NOMMU code might, for some odd reason, end up including
> hguetlb.h where we have !CONFIG_HUGETLB_PAGE.
> 
> But let's see who actually calls huge_ptep_clear_flush():
> 
> arch/arm64/mm/hugetlbpage.c: only with CONFIG_HUGETLB_PAGE
> mm/hugetlb.c: only with CONFIG_HUGETLB_PAGE
> mm/rmap.c: only after checking folio_test_hugetlb().
> 
> I suspect we can simply do:
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 80a5a03e9cee..8642c863c1b7 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1268,15 +1268,8 @@ static inline void hugetlb_count_sub(long l, struct
> mm_struct *mm)
>  pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
>  unsigned long huge_pte_dirty(pte_t pte);
> 
> -static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
> -                                         unsigned long addr, pte_t *ptep)
> -{
> -#ifdef CONFIG_MMU
> -       return ptep_get(ptep);
> -#else
> -       return *ptep;
> -#endif
> -}
> +pte_t huge_ptep_clear_flush(struct vm_area_struct *vma, unsigned long addr,
> +               pte_t *ptep);
> 
>  static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
>                                    pte_t *ptep, pte_t pte, unsigned long sz)

Thank you for digging into the code to sort this out. I'll confirm
and update this patch in the next version.

-- 
Thanks,
Usama

