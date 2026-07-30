Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 816BCC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1C56B0096; Thu, 30 Jul 2026 06:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45ADD6B0098; Thu, 30 Jul 2026 06:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4796B009B; Thu, 30 Jul 2026 06:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB1476B0096
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:12:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69D9E12087D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:12:58 +0000 (UTC)
X-FDA: 85045029636.26.ACF7732
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010060.outbound.protection.outlook.com [52.101.84.60])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7434820005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:12:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=GeswaosQ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=GeswaosQ;
	spf=pass (imf13.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.84.60 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785406374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GW6TaX/wrJVlgXDX7ALl3n8GGbzcs9T87q/ugCOz5wc=;
	b=8U3N7X7f9OkhWMTjtOU20S1n6OFNXDOiKsfKCIB0wkzOIUKmg/DBwWzYZNgJUa4uncoyDO
	4Qcam9L0bBHxD9kAVIy/jzI6jlZGb3Ce44lq4aULfryTE2NY+YFJnytMCnJ1zC8iCq9ROy
	duFGvXnekRJ7L5oFtbK6BqotenbuAGA=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785406374;
	b=FQTvk3cL0cimuEytHYzls46Zod+DL3ywF3yGIAA20cv6RlQdQ1fxomywcG53EWUO53wCHE
	AE3yW3M7YPEsV1wvYgk/0/kaX5Rn5qZKlcIrrsPEy/CJyZORSSq2GKTLMYS2kA5DffQOgN
	5U2iXLTc8j5c45rdYBzoAZkaGxpb6s0=
ARC-Authentication-Results: i=3;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=GeswaosQ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=GeswaosQ;
	spf=pass (imf13.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.84.60 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nIa4vb5Fn7KrhHYLt6PtEsXQ3R4PFFdUgUMI9qnr8Cgx7gzpzrkRgRqQ7MvjzcXp2grF9FQal/iiyhG0fg/F2xLMfqipyTRP52HAUcIeWdtY0WwpAOjW65HYHvAPeFTrpVmSBygxyO9njZABkMO5UJvOYRhHSd8cbFtznjew3ElpIBjzQBzmZXXEzPlneQsRHt9kdmCqe19JZu7XeRM0vwvxGnqZfIXvkxYtDbiqNvoqiKVyNyAA7st+XJxuk9k17MV0zjCjkDzQtyYRBK8yoyc4QZQln149ovTr+RslCQOkknQqro0xzjHlSNxjkw0fH8Ee5vF81wWL42U5mBLjZQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GW6TaX/wrJVlgXDX7ALl3n8GGbzcs9T87q/ugCOz5wc=;
 b=Z9m/YspZ0DNAD1xXnUYri9RNQVUk03vBZKSm0QNUkcEPxzOjJMJErnh/iLtybOyXP07g53QLybFjRYd1umw/HXAY4SRnvaTDsT318Vey6riiDQKG/OysKGWzRao1t2pDwmmQk0MYkQET6uD9PG5e4f7jIwQ8+nhbu52huYxQ3siRrl6pqcmPdG2/GIk8taEJqVXm9NwkYKtiJQdbN6JajWltjM7TbaH+mHxzWJzRM8vvmHNLalcHjTkjuLUa8nSGo9h2dkshq7qUwXyNwTVoqL21UPH6xtMmJCZEot+JeSKM+nsPrYlF6dRN9cvAdUHsDfILgYfchG0WJTX8Cwe2DQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GW6TaX/wrJVlgXDX7ALl3n8GGbzcs9T87q/ugCOz5wc=;
 b=GeswaosQZW0XJG+pOZUpxw2UMeTwpKI4FYP0ko0dIeM4WIxbIYvQH+bglzNEKMbrO0yKKXGBEVn4shqk8etpdsccMENK3ifDFZKHSpzWk9UeWkqZ2kAYwD0nx0jKN9zSjC5NMBpnJ8GUAHuFuIQ5lyqQw1k8sKSM3+5rrH0IUXU=
Received: from AM7PR04CA0011.eurprd04.prod.outlook.com (2603:10a6:20b:110::21)
 by AS1PR08MB7428.eurprd08.prod.outlook.com (2603:10a6:20b:4df::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 10:12:46 +0000
Received: from AM3PEPF0000A78F.eurprd04.prod.outlook.com
 (2603:10a6:20b:110:cafe::59) by AM7PR04CA0011.outlook.office365.com
 (2603:10a6:20b:110::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.14 via Frontend Transport; Thu,
 30 Jul 2026 10:12:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78F.mail.protection.outlook.com (10.167.16.118) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Thu, 30 Jul 2026 10:12:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GS5RCkRYCqQustTpOkpKOo9ShwzYOgu1KcBOh+0+gdQ7GcK/fSzronqjHxjGwjL/xvn5KSgEHpDtZlrxdSITgMoRYf/U4cqHK/HRjYRmnYdwc978uuNSE9KVMT/2DFI7B+M7Eb5Xtad79e9MKVKFCy84NC3CM4NI09/YmnsFXmtiIZziSrLIxTq0atHZr6RzlqhBPqh4utIW9rqC41r1GrALdYvLOhXcc7mp1TW4cusck+GFxbB5uXPnHDaVFbNlSj2JTrGDRc58lvrldvGizlOxiJitFAMLpntI9QtT7Nk8yLX2Uc7nyN73V/J5yTF3Z4utYgdOsz1aALsHjMjwkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GW6TaX/wrJVlgXDX7ALl3n8GGbzcs9T87q/ugCOz5wc=;
 b=fz0K7HaKJIztN06ofWYIYBBvaZPV2CIHdhinaGSzda+cmKkXpgu64xYGyHWtvlCTd52xf14/WqguAKFoRG1d62XFW/dwlv0pcVUrzltiip4XkGDf2e5DA1fY+3zJEMQPuBvElKivoSOZeOkPT0CvRhkxV2j7N8vWT1Blx2OKemO1QP0gvD/+UftV9BcQMAOojiuvz69bkP/WO6edjJjH3WT+IfYil4KgozKdjieQjZyhPhjMVtlv+zBrfPjHDARBUlvUWVr0aQqSH4SiXTe/YFBPplDAQus0/ugPjfcUW1ucqlqDsvnRADc8rVLRH+jB0gPFNh6XugWpW6ahgqc+rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GW6TaX/wrJVlgXDX7ALl3n8GGbzcs9T87q/ugCOz5wc=;
 b=GeswaosQZW0XJG+pOZUpxw2UMeTwpKI4FYP0ko0dIeM4WIxbIYvQH+bglzNEKMbrO0yKKXGBEVn4shqk8etpdsccMENK3ifDFZKHSpzWk9UeWkqZ2kAYwD0nx0jKN9zSjC5NMBpnJ8GUAHuFuIQ5lyqQw1k8sKSM3+5rrH0IUXU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AS2PR08MB9414.eurprd08.prod.outlook.com (2603:10a6:20b:596::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Thu, 30 Jul
 2026 10:11:40 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0270.009; Thu, 30 Jul 2026
 10:11:39 +0000
Message-ID: <fec9e0c7-07c3-442c-819b-f9f5316cb6a2@arm.com>
Date: Thu, 30 Jul 2026 11:11:35 +0100
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
Subject: Re: [PATCH RFC 05/11] mm: convert PTE table entries in ptep_get()
To: Alexander Gordeev <agordeev@linux.ibm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-6-usama.anjum@arm.com>
 <34eed5fd-c569-49d8-bc4d-a3d4b1207fbd-agordeev@linux.ibm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <34eed5fd-c569-49d8-bc4d-a3d4b1207fbd-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0569.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::9) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AS2PR08MB9414:EE_|AM3PEPF0000A78F:EE_|AS1PR08MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d5ff5d-dd86-417c-608d-08deee231a54
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|11063799006|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 uInQKg8jf9Nb/UF1IivgM/22qCbP0TvqUsgYHdS7porxb5tSHO00dGTijkLOLlk9/j/VpGHmaTlpjAfcrdcNJhbjqGV6wvlv5xuBeOctx6yLoczl/TcDAs6ZQWgiJmENQ5XpevQTCbABC9qqSnMz6KpF2B0ZF3+9XbvadJQABkNVXvu32u1hF8+GBilDAt1ouT4D70y2A1FAy8c47O2lWbyuKu6F6ucTXC0WPZRGqZiQVcIsQcJ4AdcBVwwbreMbB79e8aisN21FlJPPBRejbbhoNfXZC6PkQaIOIvnwZt1gxjvH/iEO0ZZXY11XFY5tIDVPZ96+GpdbXyyCaRgQmjgQ8ywikJooE1i+pSQpITDrpUacjhUS5i8KEKh4+a5rM0BEBsLXLak1sGT8DhPs0kcl3yTxz7olLqyYkcnokgMFTvMYgEadP8H7JJLwzgq1UihvbZjEoIM69JP/HuEYrkpbeuOt6KGiO8go9IwBEOkKVdqLyk29UzTVAmj1dfBwX5Q09MsC1f2FaAoELQck4NMFewUgY6JJH5rwvR/YCvFLzm0JdA4yAkxKKTrW1MgvvtWjkuR10RvprlzfFPfDw8XvJCoR3I8SESUj2xwrne6RTaADibTXz85KPIe2itNRB3kKzgGuQEu281GNHpSVcA==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 mxXycThQPOwCEKiJ4fpi4gay7U452fMtMC308xNh6nW7ar/t+Hqd8lgGY/Q3Eq9XUsaCDsOUntdt15OQ+wP7f8KKOQRloVvYD7VZhZJEaUp3qxctrhUfVFPMkrc61K5jDn8BuNFCj3O4UFhYfZDMIYHXvNVFLVNIMGorVnt+RzJl4dpvtM3jzfnFYWW2sPHTy17I/JghjtEphRZs89opntIZ01w+03ahpl8ja/ezVcis/D6Dn2Zf0i0OAxv7ayl8ma0C0FT8d1EM0q5Zp0gqazNKFCPxh9fD+0NnqIUPE3sspQELgdi5pMydyv8fg6g4LZTnXyBFbv2JTyHAJRKUmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9414
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c7c79767-1c36-444a-b20b-08deee22f16a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|82310400026|14060799003|1800799024|35042699022|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gkHq787ZbJ/QtqxPA+IipHmbLjsbOnnWq6MGWGCGZ7sm5cOSlYVEI5wVbmvMVy7OHzsGm4rJhSa13Vsf/NvcCCja/BlX0urx080G00ZSIc/I2r3LsNX+VYiHVVloL5Nv65if6GPwm2zy29bNa65hRTcZxUJTEc5Stb5WxJL5yKAPT8G17Sx+XidhAJHNlqSoVa9kVc4vqZmlxoQTj8MK5U6/GN641/T9ZF4Qll2MdVk8VJ+IrwcKcM0YErc/NwobJAEl2D55KuEZGygcz6vOLUoAugONrvpI8P3RPwRrGbkBsFDCbC5zgWzjYKvl1VCD5zn5zwQf1cs/Q1ZexfXec2WxJQ97NTg7JqeKxR53jEbOcRqgQ64DIrjl/XX11HjD6Fz6QVIghmzymRuHUv/TNXda1zpNe5ks8LvHhDTEt3vefVFoIpBW5HWoPoKjg5J5bEnnLhz9Y5IqYRARmSB5iyPYehTCjV36dnQko0MFK1c7XnpIinFCJreBsEN4Nj3vqfkgTL7Oth1Suhb76yujU9j1KhVx4Uaf6IDK/OgFOI32QUsV3w+A+8OcDpCRhzaVU+Qp+07/qEWzOYZ41vRpECzc+rLO/4Kn0VctfcgF4GBVDYH6oQCaChTc2s21ZORhlBR8/Lv2Hy5nYupZWPW8shUyDQ7vwiiG3ewxr6ubLMwpkxUIltpKB9RA8fVloQdM
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(82310400026)(14060799003)(1800799024)(35042699022)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TFhnqf9FpnK1waYPtQxasD129j4WLA2oK9JkweYCzquofnO1PchnTDRT6J7/vOZLuC/hWe4f/dDDIbSsCr51YXr0NM2ZqWv8VQJTJdHw/fKBQXf3Dr4QVjGrYEQ+URqkcuXxxed/LvbVfOk01J3idQcFOGafhrWzFk0ZRrglgLprnbn1mqpCvK7uMP5GqehtByQzHSZEqYgDqijMQz1eehY/daeYEuRJMhzurb51AqLosglDVvlZk4/WqWk3eInYky5SktACCw11Te12WpxorpZHDCRrOyu5aX7tHsHTH5wWU4Vq/6FwGPD2nJcoABwp8fdsOW6saOALfE8i7gFLFTXjRxBCnryiCUKfIP1J97q0+KSu3HwC7LVNDc4AgM7EWZaeLpSO6gAoWDKX+Oa8NWTPTaHBwtzJOW5Kb07kl1ENC5Y7mAmc+zzybOz6Ks++
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 10:12:46.5568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d5ff5d-dd86-417c-608d-08deee231a54
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7428
X-Stat-Signature: usho6unib7noc51u4yamde8xyji1s3m1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7434820005
X-HE-Tag: 1785406374-272563
X-HE-Meta: U2FsdGVkX1/xAatwUjdJe9LaMpnW3f59FuYP632fE05FKjJPQuQCkFW/Vt35Gx79QHAZzyZgwJLlQsTLSaSAeBzpetXTyIEePPFAsmzluNcXFSbVndA5ojie2eTw5wKncq5VimT31rnC4P3g+YnlReoQAfL/4NKO/Ml6qdpHOk6UxvQg5r0/F/LAVCpaAwfnxiSRaSHWp052g7MfNfyjEcHEC5bqObno4PlKF2KUsv/c0E3jv4kcC1AClUzGPia1AI4NW5i6SSDTW2DmjCeJgUQEKHC8hvnyqGkcTW0JVXF752vQt8vFRczren6JxxfDeZRcKP0jM+C25WnwrmVP1zQtVE4wuU1T5dN/w9qNtV8LEuFJhiMe2yMl8KSSectTtOYDqO7ohkQ4AJSU8E77xBYDAnzFL9zwHehoc5r+ZvDKAPMkdQVqVA/0ACG8sbKaQTVYY75ZPeUy5xSJAknPY+D0dVfJzUJ7aleyQfrWbkGvP+ROwuVrbShhKOADZ/Mhayyg/WmuhWcwSYCuknOBRTqGnpUr1tgh/7dhFQNbdZYOgllduN8bxokObcwQZehLCowzH5SBxR5X1V5ZYyR7XVuDhyhK+HPSf9GgJeU3PQglU4mqrsRiRhFwifNZssuju6iSvwJia1EIw4BnDv38AUlrsGGsIUiMVO/886pBjNcP7FZDAPSxCYqhN80x2FsSEvGB92IcTlEci5zquY9QGUemCat9/EfBunOFnvIliXd/dT5lhQmVcWdJpLbpkQOiJ2C0l3q4MYk1NzjfmSOqAOsMSIkzHHVfhKEq98Vkhlbnm8uOLl9dPyFDiB6P3uGrfwX8Pld6XLJu6J46SNE1pFfbmINwG+TjTVry2s0Z9D2vf1j+JV+grR7FuMbMlcIAtxpVDSPd3SVdff99ir2zDIIVrfntFLlaaQGaCuUjolXCErrl4fvi6Ln5NCSu5AyMD2RZaJMUKIxeyiwww7N
 bdx3GB6J
 psQM6gn1gj4+GmpNdMVL7MpdTAdQ71cgwVq6UwBSiwPAA6vS9I+7uOLKdX1QelK7fde+U5StwJ4zZCg7zZyAifYw4RAuf1h9GUgoy4mnwf+A8JITOEJ0mNXcqjM6drojhA0NyAdBn/wWgzzFX4Bs1NaKV0W1/Y31Uct3jghojD6woUV4s7rmw3pvVF3JSEfv6y9TzEiYldP2nrXh5jFNh35pGjj85IGjz7XB09sGlvQYVqMaqgIxGZKoOeyJDaucjkg2R1gjVyMWgbVEI6NOktKRh+ckoswo40sLvIMtk2SUCI9NILkhkPq5KO2TBo6aMci7hvXkVoYqmzpzaZxNhR8C3p1f8xFWgz2dtm0f2FHsx3jb47JAJSJ7dbghWlXqRmYUiZyRkT5clOfTfYjTTXsUPsrXbsMzJiqFXyvh0UQyasng3iPqu7bVuV+Pr2AQ/5TcgrY41fPuMFUBMnJ4LJ7jCmc9iegVXWCsDa06ryJB/0C6ko8QHL8xVatCP/zqniUz76Oy+vmu83dWGQJJJ3Z0L4Js5r3vMVH4Ur6guRu8c6u4U/hhFsqUDpxn8L6Kxduy9IzdgJLbAkChaSRJXEUemOH/Ekq/0a86ln0xHGEfEuwlI3tP830PO5/dibKMcbLLZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/07/2026 11:08 am, Alexander Gordeev wrote:
> On Mon, Jul 27, 2026 at 05:46:56PM +0100, Muhammad Usama Anjum wrote:
>> ptep_get() now accepts a pointer to hw_pte_t storage but must continue to
>> return a logical pte_t value. Add __pte_from_hw() as the conversion hook
>> and apply it in the generic ptep_get() implementation.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  include/linux/pgtable.h       | 2 +-
>>  include/linux/pgtable_types.h | 1 +
>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index dad80d264aac2..3003ac9cd81fe 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -493,7 +493,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
>>  #ifndef ptep_get
>>  static inline pte_t ptep_get(hw_pte_t *ptep)
>>  {
>> -	return READ_ONCE(*ptep);
>> +	return READ_ONCE(__pte_from_hw(*ptep));
> 
> Should it be something like?
> 
> 	return __pte_from_hw(READ_ONCE(*ptep));
I'd thought about it. My thinking is that we should get the pte_t first before
before calling READ_ONCE(). Please correct me what makes more sense?

> 
>>  }
>>  #endif
>>  
>> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
>> index ed5dba42a4f8c..61afe27307ec2 100644
>> --- a/include/linux/pgtable_types.h
>> +++ b/include/linux/pgtable_types.h
>> @@ -6,6 +6,7 @@
>>  
>>  #ifndef __HAVE_ARCH_HW_PTE_T
>>  #define hw_pte_t pte_t
>> +#define __pte_from_hw(pte)	(pte)
>>  #endif
>>  
>>  #endif /* _LINUX_PGTABLE_TYPES_H */
>> -- 
>> 2.47.3
>>

-- 
Thanks,
Usama


