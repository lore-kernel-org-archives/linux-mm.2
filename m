Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE763C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 10:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47BAF6B008A; Mon, 10 Aug 2026 06:10:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453006B008C; Mon, 10 Aug 2026 06:10:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F44A6B0095; Mon, 10 Aug 2026 06:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3E766B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:10:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A9D212071B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:10:19 +0000 (UTC)
X-FDA: 85084939758.08.9E9BDB8
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013022.outbound.protection.outlook.com [52.101.72.22])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7E2E51C0007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:10:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="X/TDbJ7e";
	dkim=pass header.d=arm.com header.s=selector1 header.b="X/TDbJ7e";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.72.22 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786356615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGHMm995GRpz8U1PURPcj9ORNaGW0JAp4jH7dTCsP5Q=;
	b=3hQl9hqHNwHkALGjDdDphqxSdcakvSV+BcvKUBrCm2aEFgipf8QS3y8dBiykFYKl8UjEtJ
	uPpZQmW1YGdETeUgg1By/PifwTfcQWZY2osJhAWzQzJoO2o34BgRfcLmLVmZlXKT1BpgIb
	U6B5CyokX8rg1p68Pr2cBHA5e8m47mY=
ARC-Authentication-Results: i=3;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="X/TDbJ7e";
	dkim=pass header.d=arm.com header.s=selector1 header.b="X/TDbJ7e";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.72.22 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786356615;
	b=YQgjghXPkSPhojQufjZ2tNzJncwRd6ni+Cat84Ba+7GzGQsF1Yak57zHmFvX/YvEvsNrgd
	iBfXggfHPnhaANAaVqnNepgH7ID+njRSDAm9WD8MQpuMvUYy9541vbt/PbNIWDgzzos3Hw
	GG8lBY1Lpck0Ir7ujUu3sOgrMgzTTrY=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=S2VIJpv8VwAb5nGpLGZco2CwJBxJrdyYG0R62U+CUHku9g3BmuTtMlMlIalp3nI4J7nE7zlNG9ZnMtfOtlZTFLneApMOEKjlMD7Ql6qnWhXJ5IFseiPtR3Th4DDKJaIdYvVWj+X5pw9qFiTe80e8kNtxtL1olXtIBI3mcZ2ZElrHCmVnqKWUHhryztxnYN0XtDj5KDUStZ/CpJ6yD0+vXzgXcAwh1p1jNY18syNeP+u+6Rf/JgIh83qOelSMLB2jjsipz2iZkbwTgJWDRyaE6sg6dhDLCsQdETz/8GqmSbYDfiWc4ukfs2V7R+KGM1DLVLPyWp1yBhymet1S8Hy/JQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sGHMm995GRpz8U1PURPcj9ORNaGW0JAp4jH7dTCsP5Q=;
 b=v1zz21/zgnctBGF04WoXuyaVM+n5aAJ7fY9Xa8kNx9OlnPNxnTdtI9JDT7zRBWR/jESJ5pyShmr0RkuG8+nyLXgWakdbtpE2OZVWzZ+eUDTQyRgEFqA3aCf6liib8Hhtfj3vm2AaqDgdCwqXGXm6YlZZ4tAndD3O+JqoGjcLEYi6cXk3oeCc+meBuwwtRzHf6MriVf+TGaj+b1lUnvcmgr69NfqY2+Aar+yk2YHMoJzcW8QcAQnz9B6smEzBJWx9MuUyohXKTF3uwtUk9MHvCgWX99gHiROvfAMFeXf6r9ur7ozd0DQq4BAbt/wBySamT6N9dGd2+/2GoSoA3Hewxg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGHMm995GRpz8U1PURPcj9ORNaGW0JAp4jH7dTCsP5Q=;
 b=X/TDbJ7ebcrgT+EhFqFMXkZrLW/4YZDc8WqKTw7e75/PXAK8hVBv6C+G4sRbqAlFtYUqJEtd2tPQmUS9T18h/wXtC2aoCPud+bRck2pQq9CYkNqoCovk3ytIAzcRbI1Snb/v7MuNLuEi4ToSBvjeB4IQeWdFklu/yB6MC0uCDmQ=
Received: from AS4P191CA0001.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d5::14)
 by AS4PR08MB7831.eurprd08.prod.outlook.com (2603:10a6:20b:51b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 10:10:02 +0000
Received: from DB5PEPF00014B90.eurprd02.prod.outlook.com
 (2603:10a6:20b:5d5:cafe::71) by AS4P191CA0001.outlook.office365.com
 (2603:10a6:20b:5d5::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 10:10:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B90.mail.protection.outlook.com (10.167.8.228) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Mon, 10 Aug 2026 10:10:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lu7ea3NWDFQpIQidj/jgqt5/KcmZz0+/1a76oNtofgRKQtEybTY1fyBCnkJjwDsyW7/qX3L6SuD9Uh5OOHCJZv4AsAKYRa7pqgYV5bpV89zK0ET5xvFNA69JUYBVaBtP0v7tg2VZAyWAiuyhnRXyRJmyI6iJTXkdrK8qzmLAX72W8xQB1C86P44R4flTtnd2wfkhUaNejYRyNyzz7kDmWdH4jUVPDlAovM32wCDcB9FIoKAtzVEOFXG21H0s8vbW8kpr9DkQcw+l1uc4z2ouPB+PKPpQgUkqAgSo7BymZKjTQDr1YQgtlWllUFntTrZaE/f0vUEuw7WNLHE7NfbLKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sGHMm995GRpz8U1PURPcj9ORNaGW0JAp4jH7dTCsP5Q=;
 b=INpxTaXgNxtQiT573C05qSNgM1vbGnG8XOl2r9kZCWWdSH5g6G1tsg4YtDB2RnlUfjNClceUU3wo9Klb9vEyafV39ILI5xqT1mB40WqPtm3NOuPUzwS5rBds59divY4qpTl7kf1EzwOf8HLDVNq5OTM7M6etkjs2xop/w+dMmKowx8ZP6A7DWAFSqY0QuOdrj5QS8eOgAYJv13UTwNieAv7yjfEIN10iM0PeUyIVFvRpY3+skcHmBU15LSyj0evBb/FYsMgrn8p9G/rw5d2z6CVDr0Xv7YlNJpp1GNZQl4fgnkZvyFgrCH78oR/UhFhwGdFC2APICbt2IEP03StPWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGHMm995GRpz8U1PURPcj9ORNaGW0JAp4jH7dTCsP5Q=;
 b=X/TDbJ7ebcrgT+EhFqFMXkZrLW/4YZDc8WqKTw7e75/PXAK8hVBv6C+G4sRbqAlFtYUqJEtd2tPQmUS9T18h/wXtC2aoCPud+bRck2pQq9CYkNqoCovk3ytIAzcRbI1Snb/v7MuNLuEi4ToSBvjeB4IQeWdFklu/yB6MC0uCDmQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by GV2PR08MB11418.eurprd08.prod.outlook.com (2603:10a6:150:2c9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 10:09:26 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%2]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 10:09:25 +0000
Message-ID: <52b5066c-64f6-40bb-9bce-365a18f24265@arm.com>
Date: Mon, 10 Aug 2026 11:09:24 +0100
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
 <eef14e97-20cd-4b08-ae22-7636af049b09@arm.com>
 <4a42c498-58ca-46f4-819f-da14cfba154f-agordeev@linux.ibm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <4a42c498-58ca-46f4-819f-da14cfba154f-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0541.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::12) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|GV2PR08MB11418:EE_|DB5PEPF00014B90:EE_|AS4PR08MB7831:EE_
X-MS-Office365-Filtering-Correlation-Id: 96d6ff17-0376-40a1-bf75-08def6c78b22
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|6133799003|4143699003|11063799006|56012099006|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 mSQv7AaybVdP8lh1lVFlcXP3kGG1cksbK7NhWTSFCBI3T0vZN0VuY2xwLDoDTGWs3W5PpK1u3qICDytNzKUqK9SDvSv7mOhBGz8mCm/T4p9TZ37PTi68WrHC7SBnCBiKxzCJ1ggOVHo04CZfBzLVji6+kBvSiujrzeh5gmb35+T9IoDVoY8YoaoS6y3IVsR/GNlvmGtl5h83qJwaCQGveRteXDi/EkCuqvbd5zatwi9ASQA/qgf3VrS4W7mHxiqhY/nlY5S2wjkycoMVtJy07vAqhKdVMsdnlL25x/Iwz4DXtgLyS6aJ6fYrNzxhQ3+eeZbR9SXZ64cp+5Kn89v3W3otEbkLRadT3SUQngLaRqNN8wIsqyOU8D4Yz99lvY6ZDxbtPq7pRcf3CTk8/Al5XLIF1V5sHok4sc9I5uDs30xNOq+ymqN4IBv9JdPHOaSs/1do4M34tKTFM41rHL/hmWIhHTdx8kq07vwMPgvnN5p7o+qmmoZSROUn3GPPhVdKXZ/LpJhu+sxmyl/Sx++vGNwaHa6REVMYmcFmZNeFvyZ/Y3jMrZuslEQMs0LbQZ2M5AtlfuTDIL4Je4PJTXc6RkGhF6yffaGrIBjR+RmxDHg5eXT2WqHRIQ6DcoTZIfTUIKxMWJPNuZkweSPQ7vN4An9Dr/hNzavgZ0covaVZmjI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(6133799003)(4143699003)(11063799006)(56012099006)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 opP+uzSVHSCRZK1SnjoVnNSw+fDPOATCeo/EkQ/9TKyIWl0BioAAzSjZhW8oRWRhh0VP/Q1IhuRQUxZSxCsMBYVxG/vcaCq1wzUNu0nQPwwWo+QE2KhmS9+j4egy16LiRS4nTmRLKN+XuBdurSLoP+kaCOoDnMKd3pxwSOThge4lF9ONak39/a4lKk8vojL/Ah1HFZ0d8Go5NuqSGNowzXBjnKGdIXTD/jk32PsEmyqcNbc2TwzdKXhRdNZujBGi+KEGdynA/VP0mrbFbmrciAva+eyNqKFeXEVWYbI8GKT7kDRSysVn0Mgym+JU9ctCXZkrSk7GbR3mC+NkBpOOug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11418
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B90.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b22ca400-de72-440a-7983-08def6c77506
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|82310400026|14060799003|36860700016|35042699022|22082099003|18002099003|56012099006|10067099003|3023799007|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	cRrjktM/0DgtNP+E1PYP/0TkmX3sW8qhpY9DcxvRfNeCDy8AXNMKLuDb4jtrpgipjzOzFQliODcOOY4RT92OTAXEaRCQ7E8drxYE9301ePLgTjvbj5KSRwz5uxaT8ET0eGm6NCQdUL4MwmspJAR/K/koXYxEQR8PpkShv+2mLpdO/hvV2vVx5phfc7TjVBx1COc/IpRWuf2G9XfZZks0y1EN2Q34OgU0Am9DiPRHRbT6k1rn9/q6qNa5cEuxA1CBtpe3HM/na9j3mE3HhYOgZLW96Ez7DsV+rlaQV0o5bVbUzSqItNRYQhG7ggz04xHaeOzU7WiE1ZHXzQDL9LHzaOccmv9e29M6u4Lu404ORpzuva9lnkueRswUV+7NHztVd2TdweKlYHqyHaQV32baOQHtWWgOCzxPP/i8y2k1EdqfeVivtE+SUotRzWqX4b+wFKf8TE1x6gs3kJEt1vD0O6iQaetLgtFPOD9lcztBFADSza/1D1T64EPGO/iULK9iV+gQ+WcfsG9Xet7UAWNF4verB7aZ71XjTFFAH10J705ZwKAORUbP9qntrVwLy7R5q2qJXHXiMYH28W9O8rJf8X981Y/FdjlFG7a8rlCqezM9+Vx8/f1ahn1fMI1qpujZx87DZcCRqB+fAUZ9biioHBrXp6PqYCzMzAlkIXMokzwZFfsfSA0aonNvmQ21odrDzgb8d/ug7NM2gwuGhDfScw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(82310400026)(14060799003)(36860700016)(35042699022)(22082099003)(18002099003)(56012099006)(10067099003)(3023799007)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RZu5a05QZ2FkwUV+f3u/xNJ5M977oWBQ8C7GFk7ktc47z+21uudAEAHRHlGSo5AXhoiep89PdJZItSNMVMKzhUWkAzOcbK1aDFW/Mi7N4e8tpvPJlry/aLrtdxgCK6kaQFJRAsOgE/+7N3cXDyiQfUZw+1Gee/0CnYC2dvf05U3qAEsjAQfdrCTHKQKH5tBZy+2KPL7OM2eCxrNi9Gz0AbGh/+NomfeCMStvdy//InA+bHcfFAOJZTvNIE6SEqd15SnoxmQPwOC0MKvmF+jgtvEYJ1/QNCoj4vbau8Q6BterG7888HbRyE6pSP2pgILQsPNbTd+Am8BVwld3VFN6zngsr09c3yxKP3xFmqxE/jdbWplTagyu0d+50/ntJpmFUgC5AEPtB0UZ7gK6HWiys18iUs6JwL3+Gige/sROB32Eq1eo0jD5flZ0SUXOiW8/
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 10:10:02.5666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d6ff17-0376-40a1-bf75-08def6c78b22
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B90.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7831
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7E2E51C0007
X-Stat-Signature: truzppjrf5stxm8o1yhobygkkeqoszyt
X-Rspam-User: 
X-HE-Tag: 1786356613-15837
X-HE-Meta: U2FsdGVkX1+XyzMUodUZQcnCUwqauVBvJST/LufYYERHV6dyC4bONs8bMGZXicmL6Y1lrRHjS4RTYxJojAtCP1n7W0kMeEE431nw+3/2d1wmlTpUuXqz3Pj1dYLOkw/adzU/oek5kkYgPELNnp/2gRKfNvTsbZWhUUlzTRL26YVq3lk5KlGNgoL+GvrxpK5W5azgZwN4/eKFE4Ph13b2Mrrpe5JoqowFKW+De99e/XcFvgQar8NpJI2GRugrBs5fiVsa7wHLOILkz8bhQOd3L7v1ajnYh1YHvbYdS3m4Sc8tqL91zhC5kZFKFrJZNQSHdIbXspsIIWzutNXniaaMzJ4iNCVn47d7HvVxSspl83311+ctgtuXbuuxN2jkga24VxgEpMky5UfPzDIuPyOQMBSh1/EBtZWu0BsXfkRa+gSftAB1ossqYnT/tBuVcZK0RJ3GxeqXej4wBeVzKxV46cYaDAuP6DNUUVRvVExJA6tHdY20ppvoqLGjlqgvCaVYrq6Z3V27d9e6vTWQzbZgn1vO/hzERU1meumFUZIy6BpaplPLpOLucdCIxRvTmbvkBXx5VceVYzrjAsHzD4oRTnwscLl/oV58UW4fMIRjdalQ0Z7TQ8hc7hkPsDdZyMdgZ+5x/JQvMbop+u00fAfpLjE6cpWWSe1WVrsyos6W/9vlkl0Y2lEG61QXq9jlcC5SHMvHuBGV2ea2/A8CGukmYjgh2FMB54MMykEstIRlSZDzdAk62DT7p60EzeMShwuU/MRGa95GzYwrp48gT33NgBRzZ/NWhG1KGCsFRvlN18blREWTd5yKqZqxHoeXhp5qV5wpYZyFHTe/hctaPzILd+Ot+Wrwyx1PGVIrUXKK8svbYWV6HBVdXyJmDvn87uYOOQuUnWVoo3/qly1EUCkK8uzgLYqBwDFAGyeuBB6W+aEV0yQU/wRVBt5lb1PKV067zxf6/vJSQb6lxBsLcn+
 5jln06Nc
 WXN4bGOYTlWadAW0g7C4zJoVAGFqdXjRWwAiKd0RRZsKFjAZo/r5gjrBM23UfYYagfhPxWiCcRWIKd6x60n7WNDvo1etGw2k4s0PSZQputq9l4r5rllEs2jFy/ZA7cq6NBbm+xYYOAlmrFgO3McgOaLEAAFuSeYvwDNe00n02S0J5WJgTfKYTW/LrBU4BoQ6BfbfSSMG3oOP8mqzBCoLRFOsy25q2GZDxqjTGyxZluT/13IQp/xM+CF1gZHlGYs+COEtuV4iCVYyPutB3XW8OHp0157daJCNMxo9zYJvOz6lDbVKKtxsTJAPJT3/hKhx8FZ8LAmFnah9BcKA306xViBAnmtp7Nnjt2J/pHFsyo4aPOzIt9jBv+wG/I9xkTm9iADLGltLwVZBFuKHsYe1Qj3pMJ1kATvONov0xc3oApu1bV1gZkrDnjf1bhH6Hq59RnD52h9BCST0ohVgHn0Qstl7y00/KkCabIphcQmNPb/EaB2z67pZRvcRAUJF15FBi4qFyE0A+64ytaKqKS7GuAXSk5H4TEDqHZxBQfBgz5b7H7bU7p0ua0r/8Yx1kAj1oizph3HOR1PukG1LD3lFdyavGWuRtF/sMlZGhg/jdLZOGoHOKbT6rWvwFUzSr4IG3+IVF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/08/2026 6:45 pm, Alexander Gordeev wrote:
> On Fri, Aug 07, 2026 at 04:24:00PM +0100, Muhammad Usama Anjum wrote:
>> On 07/08/2026 8:09 am, Alexander Gordeev wrote:
>>> On Thu, Aug 06, 2026 at 09:38:39AM +0100, Muhammad Usama Anjum wrote:
>>>> pte_t is used both for logical PTE values and for entries stored in a PTE
>>>> table, so pte_t * does not distinguish a pointer to a copied value from a
>>>> pointer to table storage.
>>>>
>>>> Introduce hw_pte_t as the generic name for a PTE table element. Define it
>>>> as a macro alias of pte_t by default. When an architecture selects
>>>> ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
>>>> This preserves the representation while allowing converted architectures
>>>> to enforce the distinction at compile time.
>>>>
>>>> Keep the C type definitions behind an __ASSEMBLY__ check because
>>>> architecture assembly sources can include this header indirectly. Include
>>>> asm/page.h so consumers such as linux/vmalloc.h retain the page definitions
>>>> they previously obtained from that header.
>>>>
>>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>>> ---
>>>> Changes since RFC v1:
>>>> - Add the ARCH_HAS_HW_PTE_T opt-in and generic wrapper definition.
>>>> - Exclude the C type definitions from assembly sources.
>>>> - Update the description for the new opt-in model.
>>>> ---
>>>>  MAINTAINERS                   |  1 +
>>>>  include/linux/pgtable_types.h | 17 +++++++++++++++++
>>>>  mm/Kconfig                    |  3 +++
>>>>  3 files changed, 21 insertions(+)
>>>>  create mode 100644 include/linux/pgtable_types.h
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index e9c8567308a75..7169bea968cf5 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -16982,6 +16982,7 @@ F:	include/linux/mmu_notifier.h
>>>>  F:	include/linux/pagewalk.h
>>>>  F:	include/linux/pgalloc.h
>>>>  F:	include/linux/pgtable.h
>>>> +F:	include/linux/pgtable_types.h
>>>>  F:	include/linux/ptdump.h
>>>>  F:	include/linux/vmpressure.h
>>>>  F:	include/linux/vmstat.h
>>>> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
>>>> new file mode 100644
>>>> index 0000000000000..70c3edd00a01b
>>>> --- /dev/null
>>>> +++ b/include/linux/pgtable_types.h
>>>> @@ -0,0 +1,17 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +#ifndef _LINUX_PGTABLE_TYPES_H
>>>> +#define _LINUX_PGTABLE_TYPES_H
>>>> +
>>>> +#include <asm/page.h>
>>>> +
>>>> +#ifndef __ASSEMBLY__
>>>> +
>>>> +#ifdef CONFIG_ARCH_HAS_HW_PTE_T
>>>> +typedef struct { pte_t __pte; } hw_pte_t;
>>>
>>> On s390 it fails to compile once we do typedef hw_pte_t *pgtable_t
>>> in asm/page.h. m68k, powerpc and sparc may also have such problem.
>>>
>>> The below declaration helps to resolve it using forward declaration
>>> and without meddling with headers, though I do not like it much:
>>>
>>> typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
>> Thank you for testing it out on s390.
>>
>> As __hw_pte_t isn't being used yet in this series, would s390 enablement
>> patches add __hw_pte_t to this definition?
> 
> I hope there is a better solution. As I noted m68k, powerpc and sparc
> may also be affected, so I would suggest to look into those as well.
> I would prefer s390 to use the generic one rather than circumvent a
> compile error in a custom way.
I've just checked all of these architectures by doing dirty conversion and
reached to same conclusion that __hw_pte_t must be defined like:
 
typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;

I'lll add __hw_pte_t to this series. (Initially on last email I'd thought
that the first user would add __hw_pte_t. But it seems sensible to add it
now)

-- 
Thanks,
Usama


