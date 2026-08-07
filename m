Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C36BEC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 16:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC4046B008C; Fri,  7 Aug 2026 12:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E316B0092; Fri,  7 Aug 2026 12:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C75A6B0093; Fri,  7 Aug 2026 12:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2546B008C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:26:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8929A0453
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:26:57 +0000 (UTC)
X-FDA: 85075002474.24.72FF5C2
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013050.outbound.protection.outlook.com [52.101.83.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9A35E12000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:26:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=LbE4HoBx;
	dkim=pass header.d=arm.com header.s=selector1 header.b=LbE4HoBx;
	spf=pass (imf29.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.83.50 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786120014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MS1lmnXLC+3vPC4LjFRguif+C4PkJMlmWukiMTyIh2c=;
	b=YiIV/c9pVlpw+he/B9faLQv3hVTOBtrggA0cSAdXJ/rjthRiC35iqKnFPa7XzXR9jrRsvD
	pUbAb3yQMf8sw46uOSpf9Q4ELj/VwItcWPS+UoaiOKth2XGjdFIP+UrvXMzFPG8ZJTh4bR
	ki6Z/TyiYXEdTLG9A6muEiDQx1y/yJw=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786120014;
	b=KeE98VrvsLhVKrv/wrYjiRsX8R6PTV7Bx3fCIhVX1l1ZEaNKE8B5B3zzg1mAfy/c+WtJ16
	V7xd9irw+QvziVdXwwtTloU0CCEEDN0slIteZZKhq8yUh3qhy3/2xlaK0pgVdJg1UoVMXZ
	ADRbvqCulGwJo/4NoTdwYr9e6YILjIg=
ARC-Authentication-Results: i=3;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=LbE4HoBx;
	dkim=pass header.d=arm.com header.s=selector1 header.b=LbE4HoBx;
	spf=pass (imf29.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.83.50 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=S1XfxwbdoezrGNtcj8UyE3GCZXPXBdAlOWQPBP28V+8tyrszTTGsxfqldiEGqWUtuUE3vGD6hP9N8iWgN/hWSoqJbKvP7dCnk5mClR/jGw+Xd8ULlXemEMgYLQG5a8+SX+zAiRD/IiLlYYyj9WdOPaiYjjvyJLvzn4300I63UoltiCDj8Jg0P5yNqhROTB5cT1IJ66IKetoBSUH9ZlAkDZ0jb1JhqadNZhlcWhQg0uXCf1ZZJUT/3VejedLWxaDFhoB7eXKVxueFE8+BcEVbJjRFeKflCsN6qbZXJGnduh1MfFIEI7/GxeHQ+Rq3Rlf9McLwZh3G/s7I32c5KxrR3g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MS1lmnXLC+3vPC4LjFRguif+C4PkJMlmWukiMTyIh2c=;
 b=QoPWnMGbeaEPY70JHB5FQkhZMhNEsKVxusaXcu3ZHcrzDdOsIH9+aABL25xarJ2p0BlpVUxRf6Rgne1yLcv5zGx6QYZC0BurUyoI26KRLxEWfz7BT1WkTKdGln9XQj+21bbKcTWU5FdswTkyPLbGGfARa3gbWsvHVimPUlPOEt/SW7LYQCODLdiyL+SIffv0U//X6j+iV2CRM+LdaMa6FV/uONol3kF+A/EQq4DM41RU4LgJE6M4FV88hSW9/TUJWGaUuxL5/L7o/ivebYQhF9bO3h+hR2CNByMmIjCJr6HDtFMzZtLfkA/9O71rEd8cKcmANziXxWRrfApO7Lw8Fw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MS1lmnXLC+3vPC4LjFRguif+C4PkJMlmWukiMTyIh2c=;
 b=LbE4HoBxjfRtlY7c6ZHDXc95qdWRroP7GkPtXzaFqe+eQxYuiOQOAwMBr7zadR4TuTA5v2UTuXmiECUnpZtueKfuejTnnfUkBfLrYjyJgXAvWpK0ohfjKh71EC1IompC0jkrflMssKe0/wRqt9RdzegAqcf5Dc1XBW/fb9/q1tA=
Received: from AS4P192CA0049.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:658::22)
 by PAXPR08MB7442.eurprd08.prod.outlook.com (2603:10a6:102:2b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.16; Fri, 7 Aug
 2026 16:26:44 +0000
Received: from AMS0EPF00000199.eurprd05.prod.outlook.com
 (2603:10a6:20b:658:cafe::5) by AS4P192CA0049.outlook.office365.com
 (2603:10a6:20b:658::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 16:26:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000199.mail.protection.outlook.com (10.167.16.245) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 16:26:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FBDF7vggKyg/P39qymfNUnPXNLSQX3uZtATlVOwaLtC8TwntOHJPr284gwOOE6pZfD9pmyFHAa1UmVfQW8bWlKsBhgNU/ouiGX+26VsQpjWXWZ03OJBCOzmApMN/ySTKE8mQDBvgdWMFtoxsru3C01DYlr7vL3iyKVBB5c54bw0QQucf/VJGVkwhwn0z/NmQitzGga1XjI0FH3FYglUvWzdpCvBaLvOiejWwJW7tBPnR8nOSG9qg1A/4DhkmlwKTNOGQjqPvIBUIIUSuFkWtbpulF3P6v2SWp5fzB49KalXQ7i7JhAcvUoHoajLSseZYDQIz+xv6ilzZFCFfYm3ztg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MS1lmnXLC+3vPC4LjFRguif+C4PkJMlmWukiMTyIh2c=;
 b=RvoYgMTkY2CEpoffjFhgvcG6DOqoHwEYbJ3Ie40Y2aRdAowA7ORsQl6ZnFxPWEiRodcf+LQDB5UOCktktQ+uxJAXXkH3XltD1V1wzgI2rtyhQsrVcO8xIqGBAnRZ+pnWcT0zs6U3BkS0mNhhnOV96LiBzjqE7VbRskZWsDvkN+P1KzSRZcbvzKEh42wx0U5sjamKWFkxFTgC6XqVLLTJ//iITABk8mNNNio7hfW87kMwg27jLdrB+/9eJLsIyVTVEgYOvUXJ1zW80G/r81Ak3LDbRkKk/TMVrZf9o1etFK7qrsmJCJNLp2hUG362ZxNhsBXDxRQjMohSfbormJVZnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MS1lmnXLC+3vPC4LjFRguif+C4PkJMlmWukiMTyIh2c=;
 b=LbE4HoBxjfRtlY7c6ZHDXc95qdWRroP7GkPtXzaFqe+eQxYuiOQOAwMBr7zadR4TuTA5v2UTuXmiECUnpZtueKfuejTnnfUkBfLrYjyJgXAvWpK0ohfjKh71EC1IompC0jkrflMssKe0/wRqt9RdzegAqcf5Dc1XBW/fb9/q1tA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by VI0PR08MB10655.eurprd08.prod.outlook.com (2603:10a6:800:209::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 16:26:07 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 16:26:07 +0000
Message-ID: <5c329236-7761-4e42-a549-b822e43b4358@arm.com>
Date: Fri, 7 Aug 2026 17:26:04 +0100
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
Subject: Re: [PATCH 6/9] mm: convert PTE table entry to pte
To: Alexander Gordeev <agordeev@linux.ibm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-7-usama.anjum@arm.com>
 <fab9fc78-1e1d-4d5b-a9ca-92f3ebd04108-agordeev@linux.ibm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <fab9fc78-1e1d-4d5b-a9ca-92f3ebd04108-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0420.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::11) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|VI0PR08MB10655:EE_|AMS0EPF00000199:EE_|PAXPR08MB7442:EE_
X-MS-Office365-Filtering-Correlation-Id: 18b46daa-e409-4390-8a75-08def4a0abaf
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|18002099003|22082099003|4143699003|11063799006|56012099006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 1mEC+1GW7muqv9YRUa+5/AFrrrerVojSEnd0ecaTJkfa3ovLhwzSUtq/5/iXk3EltNs1VIgCRf8Zh7GTAr6czHLzj1LlHiHnMTDT5Dcb24wAlC09Mw+6D5YHPspvL2sx1EVI20obl2sTrjQoXjDCgA7aBVp0HoJDluRDuV7/B58aAjYrXiLYtdilyVB/c4ILJZct9XSAPErba2JDglH3GKJD4ype/UD4mcHzequXHk1JMOE06O16tguwAUEIG0u+MJ8ggTWNqgYTzNOd6MVIq6sd2hHoWdX2Y2qjuTpQTX+YA2OBeZDzPK349/Ui6sl0RztQtbMC3yY/MuAf8RC0UbnnCeYg8DCCD41dNdhUatK+JRo5T3IK1KmdaqJIqc1SsTX08C88FG2Lg8b1iyt7B2jUsYSIVllojrtRN+9N6ntm73XxGeP7W/EKk2HijMVLt/zJ00cBPF+s6ehrAwUuLcXR3bFWdCxqikr9Hu5qgLqNLiBeQyU9LZ3Rn0uE/AjKJr7KxBolhiCVsfoUtLoROh7bFHlrC6EFaGGtVgi1y6ZHnr30Pd2XXuuZe89Ym83TMhdg1ihZmFB2EXbHj6gKjLziMPVkfqXTj4k6Xt+iMxg68NNxRNU+gVap/tVp0ZnjQsNUaocWwqx1SokpwWWnu8VdsKL2mjWzZqYQVxBsrn0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 dn/YewereVVzC5A5tIWzHJtVSWhBYpgpDSi5ALQzfsiowfVbPFqVXI1S32+w2Gf3hBalkT4ScA+EB4sUwudcOtIJhjhR9aueBLUTgRnHXPmr0dbhEUDZJ+v2rrucvP3u7iERclCslQl2A5NyoZhvKU3h4jrT3J9OorOozCFUP/qcN/HdbFVtvnLxCOyew+JGCZ6WkqiuZJrWgmbPl2r9U72xSp7bx/EmXd8DnNf3SnfIcujY2BMitEtNTLz7u55xSDP2vPsc11Dyxs/oe8ZFQ05c4AHjsCyEnqkcV8VIhBM96NYmH5IBO7uCDB0P5KyPkh6gWTBXXIEFZ97AzZVXsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10655
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000199.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0a4a3d81-f480-4118-d51a-08def4a09582
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|7416014|82310400026|23010399003|376014|35042699022|1800799024|36860700016|13003099007|10067099003|11063799006|56012099006|4143699003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3ee23sDBvCMpGWS4TDHQCLYyUuSwv+AYpmfNHpcECbYwo+er0pcuW0YBJ/JGlzMVJsYwX+sABSXsOIooXGv1Z0M+CPTlgjlg8l/Ty/wmwVr9lgrVojIjexEIkm6+ajX+jCaGQkEO1zUJo0wXkMoWdebOCQaVpddKqpa301BXJrr6TFCTFHFnP4U3N8xqK/Yw3VDWz/HR+Tmja6qer8yUgdSzdJJOcu3WoyKS89aiOVle25K9alBtrNPHYoQoWKJ06NlFBf751x6aeo652mwomwBFkHSiU2zKXMeAFWuaxSYXq1glMto7hAF/gOGGTL2KsodAfMs/ljrXF2CelpRYmy7dwl871eDCtbhP7HZoQm95AyQDVHiuS6igbUrWVHInoFmIcSSYQ/pKGROsSzIS9uHKiT7mjVo4I+Jt8RhdN6Qu7v9+iowjNrvL73d5s7jF/NcJvL+dVY88XcquKU700NMF0mYZsemFR7s3WLsgCe9H7NzHlwj0UTfVbvv+b/p3fSGye2GK0W+Cf5h6XQwGCOInM1gxaeD2SAmf6gEEMx0eI5VC946Ussig+Y5WXGfBzdXeBSVELZFMUB3Mrj0zZ87rzh8sgxNwXrn0iQFJEUDkZkzpkge9bwfairbgtuVQtzayx75zCTl1VV7FA1Sk9FfxIDz8ceClCSD8heLSBoia02CVnceaJ5LQ/HpxSzWGxbG6EIome9u0k4ClWpNNmw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(7416014)(82310400026)(23010399003)(376014)(35042699022)(1800799024)(36860700016)(13003099007)(10067099003)(11063799006)(56012099006)(4143699003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	d+88svJ5Haq6WSE5QYn4CZJyPMiUwhrt6t1V2RHk3Ee1c9prJyx4tb+QtGTj3UbgmutI/PnhCtEHsr35ZeMYJIjsJ1kttUusNFj9C44KxueqFhTUJy1pVRJjR7gJbqZb0XMMkZZBV8qaszUzoOYuG3Fmn74WxXMTHpIniau7xxMzQqqH+IEnWJ+LM/afEF7mm1UuFtpi61Es1j6qU/6DdzZefnT+s7uMDbLXE75755Yr3IgrwazWn4HlBUcwVZSyzmwFVXX+7IB10zw772A9Uc0UPJ5QKASwy6/zQ3PJ05eo7i0EfLOboN8P005OBeG3KiQdN6k/85+GF3+NgIOzozCldvxfEbHC+2lhiRP1hysiIPiJVK+xNnkfisRuPDTC/zUrbgJfQU3UTvywsjWWCl89sfVDR1zg4iJA8cEZxL45be/o2DGrtvgTNcV8TyCA
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 16:26:44.4840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18b46daa-e409-4390-8a75-08def4a0abaf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000199.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7442
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A35E12000C
X-Rspam-User: 
X-Stat-Signature: ay8qxenu4pepu3ax7pycgmanfwxgcq8q
X-HE-Tag: 1786120013-540264
X-HE-Meta: U2FsdGVkX19Ih/Te4N2X1w9EyDfwuJksU+H1gVQqXXzBaiB7L0s+ZkePPH52FZh7TFlFZQjjGvpA0AFFI3zxTPhH7s+vE/1zhWpQ6OK18oGKDKMEoyvh5ixxvDKbLvvcWYpdduLrYybGkPoaJ3dnUEHjpjX78p0qMXOYJcINEiheMZo4tC5g6dbLYvWlBI5GvODN2Y4kuxgiRA9v0wnpaLo1QvA1ymwGLCcjm0f4WUUeF71kKGnEIpkh3k6DGqaBV6Zr/i6+mYIF3fFqE1snEjtn0+SrmMT/9+/Mjg+pS2awzsZqfDw3P8z1VwTGanbLxmo/ksYdh5qfJpaa839Uu5vHwA3S0hDFTKkVYZv/6wGtbhTzmyctKf58xgWpCsIPZRt2wC5B6oxIIvxvqfgvfibCGklZeYeTLgr7DKmcx7BbmGHPYmxU60o31aXuN/EsGqJeY50gVCB7SfXfmm2MX6yCh4rWDnQBqt18LnECD1tLhcAsYBArrrp3NLxq0dzdnZawU0p5lBAXioRbsridrfxGMlIA5CGqj84enMjErg0/hM7RqYTHdN1QLijcL/tOb/X9NB4161Uu+2hunGmt3XtjF95cGkmXkng7F7lIEK+OBxghZM56xMTGZtnBmfNu2rTO39xT6sYf0I3XW5NJfyMw8caE/XzMsqIoSEB7PYoU3gflY9dQJ7NKd5vflmanwt/LdmYt8OhUErZ9TtbMA3VJuPWE1mMpQznGlch68812rvziBL4GxfViclSecVvfSutceYhQbmin5IebDMAKbwOvVw/FB4P8Uf5Xj34eb5Aab3OpdB8ZwXtHMgIMhFw6Gp3vNKoWfqYfpigJH9c9EVRC4Xhnr1GDXa55+VMJ7o7oY2O305Xa/Tr115/Dw30UXu5mf8G1er3UT1Y5kKUD6YSGm17B4PFyDjWdKpYUjmRYb1gHVN3RafYhJTtLbpW5zG3ANagbpUFUfTzLh5L
 UEq2YFGO
 Hb73tpROk3QMokGt9gWwT9NJVjwVafe0y/kQu0t890jEEuGS9J9atgvX1oh8JCUEwmmW/fs6KbeD+myxedSehStzroCwSbz67QfiNWwAQ7uxnh066p6IA/X+X1d1epBqXv5Rf0Iy2eDnj8WDzy00PQ8NMayxaJSEAfsFM6fdv1SLc0Yg917PpSYCAfQfuw39wteqz8YHGsolWLGfjFKGWB+dw0jdN6n4WoXGMynxNTs48PE5nAHDhDsBYr6CzD5L2SoNHpvUt6YRJKXEhoT7jfsH6hvHa+5l3++ipEYv5Zo70nilJhTEG1npp5ChT/SLZ+Mr/m4jYasjydZdVzHB+z6CbdJNXw4U+kQbFzfdTzUEuKBp/FccIecPcBtNS6Qe+fCM8bqEhsPfb0+VgIi6JAF54QeBGOD3ko7HdyOJ1w+mjXnCbqbbahaWGsiNydSIdI3kWqpsJm3+3UlteQzYlTaXaWu9pjfZRlDSWMAgpEAoN1C7cf+leS1WSxYehJI0bEXvEXOswdLH7qo1F07qctZS6x2bEc6tsvDAvB9zFBB8v86dM3wz8U0eMIxRg/p1JTGThGGLlUwFWs9x+N/AFqqgjYotB1JneLIBQ0VJkXXHj97qQ1tk21v0FCVV4sCd8eef6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/08/2026 7:58 am, Alexander Gordeev wrote:
> On Thu, Aug 06, 2026 at 09:38:44AM +0100, Muhammad Usama Anjum wrote:
>> The non-MMU stub receives hw_pte_t but returns a logical pte_t
>> value. Convert the stored entry through __pte_from_hw() before
>> returning.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  include/linux/hugetlb.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index bc0b9c65aa1d0..9e8b391aa4bc9 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -1283,7 +1283,7 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>>  #ifdef CONFIG_MMU
>>  	return ptep_get(ptep);
>>  #else
>> -	return *ptep;
>> +	return __pte_from_hw(*ptep);
> 
> But this is a direct dereferencing, which breaks the whole point, isn't it?
Yes, this is particular line is for non MMU. In this case, CONIFG_ARCH_HAS_HW_PTE
would never be defined. Hence hw_pte_t is just pte_t and direct dereference is
allowed. I'd thought a lot about it; is better to leave direct dereference here
or use some helper. Then used __pte_from_hw() was already being used in generic
ptep_get().

There are only two users of __pte_from_hw() at this time. 

> 
> What about introducing something like pte_t ptep_get_sw(hw_pte_t *ptep)
> to be used in exactly situations like this? With that the semantics of
> hw_pte_t pointers becomes straightforward and closes the still ongoing
> "storage vs lifetime" discussion:
> 
> hw_pte_t*     points to HW-formatted page table entries
> 
> ptep_get()    is used to obtain HW-linked/attached entries, and may wire
>               extra code like [1] or [2]
> 
> ptep_get_sw() is used to obtain HW-unlinked/unattached entries and in
>               most cases is just a direct dereference
ptep_get_sw() or ptep_get_deref() is better name here?

I thought __pte_from_hw() is ugly enough that if someone tries to use it
wrongly, it'll be noticed pretty easily. I'm fine with any other name.

> 
> The caller should always know whether the entry is attached or not, so
> confusions like [3] are avoided.
> 
> 1. https://lore.kernel.org/linux-mm/20260526-kpkeys-v8-21-eaaacdacc67c@arm.com/
> 2. https://lore.kernel.org/linux-s390/650903a4-0dd9-4e6b-9d4b-3c32c5657236-agordeev@linux.ibm.com/
> 3. https://lore.kernel.org/linux-s390/b44e071d-7c9d-4e7e-a84d-4af3499a5a05@arm.com/
> 
>>  #endif
>>  }
>>  
>> -- 
>> 2.47.3
>>

-- 
Thanks,
Usama


