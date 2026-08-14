Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF779C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 10:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D80F6B0675; Fri, 14 Aug 2026 06:07:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990A86B0677; Fri, 14 Aug 2026 06:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831D16B0678; Fri, 14 Aug 2026 06:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7986B0675
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:07:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E388A1A0407
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:07:11 +0000 (UTC)
X-FDA: 85099447062.02.A245EB7
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013016.outbound.protection.outlook.com [40.107.162.16])
	by imf14.hostedemail.com (Postfix) with ESMTP id 54662100008
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:07:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Xa73x8VO;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Xa73x8VO;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf14.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.16 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786702028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3KhvsxEoEP9z6JNj1aBx70Nx6X3XBZOUekklW3rbtQ=;
	b=hHDxkAuT9NHXOd4cGRXWIxml4VLGLcLZihMjyXTgBuiE/LOwoL35D6TR91+lbhxT1jJmqE
	kCSZ4qcfAo6Op3bSaUh9I6GkiifwWZH3Zr1C9wAkMnwyp5Xd/EnU0WsZs0SSFIMaCIOysI
	j1ZTDq2U5Yo3bZAG5lQ2SCfFAZVRfMk=
ARC-Authentication-Results: i=3;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Xa73x8VO;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Xa73x8VO;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf14.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.16 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786702028;
	b=1WDyWEfgynyZ6U8sbto9RJd1BksDXDZ23NDxE2r/1a4RnMq19VNcEeIgG4Wg+e2MSX3fFM
	E3//oSPUyFcXOCnbq+CPdgitLJ6K5GXEtIhCLKXDMfnQlLvpkbI/jxIPpQuCfK5eMKLOA4
	iJgWax82K7HmqMv1CXcb/88s95Mgc8M=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xDBuWPymd45tbtSJsM5zIQ7ovzGXD+AGiS6ED8icHhxGxVT76M6DstGxkVHkqZFrKZ985/4ylndA6OkpO7KApT4x8A9VoWXIUF7ol+hnVj8p9InHzAwMyVHfnKoHZOy0STBUIWB2yo7sa+gulPrTLvj9KR5/g+JJ0LaFg4m2WMV0GZnLHXfdLtAkTv04NadcewuXeVcvS9PxpcizH7DD2JNdWOxdpz8AUK4jC8UjZjjx2jVcWfCBmRMksbO7bq08/ZKY22a5fuJ7oHkIKekVik6zDgN9xwDX6CwML+4n1YKATCfnob9SNIv4bmxK1dOzh93tLos5zLU3l1hYIdSSUw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3KhvsxEoEP9z6JNj1aBx70Nx6X3XBZOUekklW3rbtQ=;
 b=PyqtN1JNJudVv4ZYrE1LAlvnCEJ9YizG8w2qpKARDgPno8P2z0qNluL59nw8K5h/EdPXXJbXfFM/fB8OTlRfbZl7GjRfyLD6A6TdNZOQSwunFyleIE1EpEkPcnVlUPybP0ZBxym/muZ7y1YnawaISEyunpHgL/KMMxwVE/c/1d/3m7cvTVqn1k2gjKXmUxoBejgFo/9KsetJjU27CUNrxDZ07lPKBtsGPSO/GGCkeNfCp4CT3XjBatR91gj25FKk9Bi9EADX8XUESx98U1/UZTUbc6MxXnJOSU0IbmcgLWItKlGVQFta2tayKA7kP9UXLCivv/rRKRUIo2Rt01oiPQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3KhvsxEoEP9z6JNj1aBx70Nx6X3XBZOUekklW3rbtQ=;
 b=Xa73x8VOqP9SORkdx0HmJjWkb3uz57kANXUAB9hdYEYAtYJmLeE2YabwJREVIDuEv1ACZhPpSmNzQNZDThV0g18zfFCpkViSg2f9AxMSAyzqyY06lO8Q2enl3N0PSPGUuhiDSwh7mZg8yBwj6DT6IUdeWHq5TOnreBTaN+Uj0Dg=
Received: from DU7P250CA0018.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::31)
 by DU0PR08MB9420.eurprd08.prod.outlook.com (2603:10a6:10:423::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Fri, 14 Aug
 2026 10:06:56 +0000
Received: from DB1PEPF00050A00.eurprd03.prod.outlook.com
 (2603:10a6:10:54f:cafe::5d) by DU7P250CA0018.outlook.office365.com
 (2603:10a6:10:54f::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.15 via Frontend Transport; Fri,
 14 Aug 2026 10:06:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00050A00.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3
 via Frontend Transport; Fri, 14 Aug 2026 10:06:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PHmEnvHlnGBw4IwdJs7esLlclPRGZD2862Rk8b9wsf+poJ2rYvaUBfHOPunvQWGY5sYkl8wYrAn/QYbHHAtQyGPCTEJkGD2TJ4WhFQsPsx33YtXlw1LwXYRwVz3fOWwJiquTf1z6MxUiF5BgTZHG98PEkygMOeAHsS1rt199eD6O+gDgJTLzIHiZPgDkLFGccCmeryNn/dgQ7ZvlIPEKY9Hak1474QAC75YTnYzI50qA4wALw96kqICvycaCYHRE7Z/nP5nk8K3GeAC9f+/2oCuJaTM0OlcH7BBFyvc9cJ9DlaqACd/QE3coMzFmhKVnDfFiUHlD5oT+MsOS2gJLgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3KhvsxEoEP9z6JNj1aBx70Nx6X3XBZOUekklW3rbtQ=;
 b=HTDEjnorGVlYrFORYmJdgvFchCM37g7vDTzt/byP84USaAURmmENe49RTl34SlC1zzHl6D2b+A7QmIrit+m8GN3JvghoHHjvQor0ke8o0TdXvyBSlm9HFG2tZkamq4qtJb1+n5TSDY0Pl0Ufjg7M/usWMZGI68M2+vhuGQD+KDPyWTY4vuDbimg4VR9OHJH8h5o7vpz2F5ilzIcp3fP0qqbBtmqN81mvB9WWkMPMg0McxLex/XZ4Xx9Lw3JTJ9aehR62XBuqz0omqE/zj00Fvtc5jtGUquybb5+N2V/NwDpoZwFWI3zGsjUH34t+FLowH8NNpN8wIoaj+G0ZCKR0fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3KhvsxEoEP9z6JNj1aBx70Nx6X3XBZOUekklW3rbtQ=;
 b=Xa73x8VOqP9SORkdx0HmJjWkb3uz57kANXUAB9hdYEYAtYJmLeE2YabwJREVIDuEv1ACZhPpSmNzQNZDThV0g18zfFCpkViSg2f9AxMSAyzqyY06lO8Q2enl3N0PSPGUuhiDSwh7mZg8yBwj6DT6IUdeWHq5TOnreBTaN+Uj0Dg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by AS2PR08MB10111.eurprd08.prod.outlook.com (2603:10a6:20b:62d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Fri, 14 Aug
 2026 10:06:22 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%2]) with mapi id 15.21.0315.014; Fri, 14 Aug 2026
 10:06:22 +0000
Message-ID: <99eac5ca-d5c6-4777-b16c-5a20fae95f5d@arm.com>
Date: Fri, 14 Aug 2026 11:06:20 +0100
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
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-7-usama.anjum@arm.com>
 <fab9fc78-1e1d-4d5b-a9ca-92f3ebd04108-agordeev@linux.ibm.com>
 <5c329236-7761-4e42-a549-b822e43b4358@arm.com>
 <2599c5b3-e8ac-4865-993b-d41e6f060d52-agordeev@linux.ibm.com>
 <f0b0dacb-fb83-4402-b0ea-30072727dfd7@arm.com>
 <e9de4158-b829-471b-980c-1999959bbc48@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <e9de4158-b829-471b-980c-1999959bbc48@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0374.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::19) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|AS2PR08MB10111:EE_|DB1PEPF00050A00:EE_|DU0PR08MB9420:EE_
X-MS-Office365-Filtering-Correlation-Id: 63e47786-f4fc-4bc2-1a14-08def9ebc5eb
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|3023799007|6133799003|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 FdM+vYM//Rs5TUwEEHIcmgNLmFMgPcbIWudfucKOtLwbQHuQH4LsRsLWhZbhUHVwlsUZ2MW/QlqZEBRFZOotGFq9ElB1fBk0T2wDM9eJxSONOc0eBnNbJCrYXcdL413Ax+OyfkfEoxy+7p6xfO/Gp0ULezU0rryPMHDxdW+WSS5rUULaD/qtxpsaexe4gAKKlRwpoKiMYC0kk6mOSF6nV//6DKRqnn8jaUxss4Jb7rpTjNrDntvBromiOXkyH+u738mcKX2mQvUwgMLXPwSoUcHl2FYCYlRXOtzbXYvxFs4S2yuivsokOQ+SAGvWRCMRzXK/QnoVKcb0xUY8+gZ88apENk0piPBxngMRBECCAR61rRcrJLUNQtlEB8HBbq/YpCmGNjePl8g7rSF97nWWZn5uqDznbnx9lhon+2zPAyx5mE7R4B8g1+I/ayLySqAwyOQtrDcO7Utgw3QJ5V1LabHy5H4Zq+RZu+yoYeVUyWvQxqZvBXrOzp8rjCTsZcVr6KY7JAdQq4tl5Ps/qB9tRiPALRaFbOG7P370QXOXENe/wCCzLSQ1wcD8BOuVSU5Yk2Obd7lxvCHq2207TdfFyw6gpkOv+e49mmqVZhxXI356CRSby/7mB6IuGiTs4sLL6Lcof90Lpfy9gfrzTaZ12kmtz9OQ0y9Jt1KAXQnZMIU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(3023799007)(6133799003)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 hg0VAWoj1GcWWsk+NJy5Vc8BjrpZSBqh8S30aINiN6NxTNaP4iTTkJ91o6iF1/+Zwjb+/AU1X6UV8XTM3bUxU3Q8BCdzlOCy7kOyF2/QY5swJ6ur7BBbFXmGFS6NpT/ac5AA3biozKgSIVWQ+BMglFcO2/q00U6bDY7FjrezA7vmmaMQsVLMPQbt67FGkKdB2XVwe9vKRY6AHj6SJA5C8LJnCN/kIC4nQUKWP63TP6aMafYf/b5odoc4YiM9oEHhWuIHKuJJWkzrwup6r5XiD7ifQ667mLFzrHqBBcKWLla6YAbKP70dp40wmHUcEMJMSgsfMU8tyCfetML6h6+siw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10111
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00050A00.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	330ecdb8-6c41-4eca-4e97-08def9ebb11e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|35042699022|14060799003|1800799024|23010399003|82310400026|6133799003|4143699003|10067099003|11063799006|22082099003|18002099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info:
	VjS2yHJRJ6FIIV5VKfG/RwNRqdqbt3Pw64Il+TSsQGYNJXdp7YbLVWSVHkDcN2Te0SodvhigFS0HUT6l/N+WF/VM69XgCun7ZWE5XvidEFCSmujGCh99x+s19goBj1LtThgEcHLltVEzVBAbA8a2qghQ5UbPjLZ44PJ1xqUu23wBz0wqTb8Axr4boImcWSCfUcvUav0HEwqkvKauBpWHGPIiwyxfB0y7TegHzWNbyVim5M7bkh68zoD/iXLJtn4r43vg2f7dSOHK4cfcCiLrA801zYhzAeRz7Rc4tfr5QNHdS43R6dQUZdKtzCyh2E3K09xHkaulD+pYhLi+JNGpNSQW31hV2HdAo7IrrejyTAkZXxrzkkv96tBOjZg1YD5xUj8cZ0UfG5oFSJUSCEMe/8MvRZBQT0tZztt40vP1eHgQJm1iufXi7qdatBrOu9RbHszUSbXrdutpLIdIE5l9zHhM3KQ9WMFXrktOuVW21AXgnz0oD4iEsVeh1SMGUl8U2pEIv01AsGyf2/ZS43Tez5ahziTbYoN5cLgwTyw66AIPPr6cG37TeG6HgK0IaRZlYnzqGHHMmR0fOdJWRCDPKzcuZqOe5zfLLL+OgRNQOl4GbgukmSyfZx/XWVRQclsPXRxxAVRh7CKFo8KKdCziEvaFeR+12MumIMvkJKrLf925bD5emz55ZgRWNJ7FDxyKDyVmMBJDeM4ilL+UWM7iAw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(35042699022)(14060799003)(1800799024)(23010399003)(82310400026)(6133799003)(4143699003)(10067099003)(11063799006)(22082099003)(18002099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pvMM/dJiD/B/1LdIJH1K8JbPFKXwEhVh9l8eVP26ZwENbQXm6ngpU4Rk/Ns4b3guGJ9Ivy86+rD/m4sStrCfxLyVcStcdW1pEMK2s5aLAyp3fn9xco2MbDSJqcAvvsvb1QZ4iiH048VUfUHvrclD1oVmg/CzcrAFnajPe8PToT6sJ61rWJdiYyi/vZNajaHBOfZAQeKx7dCJBHhLdm91fQ5+8DlZgBqyfxw4iAbVxkX0hpAylYE4/LSVaLMwPi0RRDg5i0liPY/VVuqNnL+DkB0KUp0zc+y/qtSu1z/okjH9xHPS2hFuB5+86KHOYYoemfOSDysVkP3fDshHDZ8RhJ/fvIsydMSzU0isAHIY5ZgtVINWQ73F6SrL1tpO8wqizQZ+ns4pFVtccu9gwAFH5rTwScC/HayBRHU0PAjukOwNT3Xhow54yht9ACpYav6T
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 10:06:56.5509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63e47786-f4fc-4bc2-1a14-08def9ebc5eb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00050A00.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9420
X-Stat-Signature: bxrxhhozjm71y784m4bund9abgsnugrs
X-Rspamd-Queue-Id: 54662100008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786702025-137812
X-HE-Meta: U2FsdGVkX1/R7r5qBS/SRNNUT6MeLP61fkLzE2TyBe+PdBdOQhtdzdgROQFM4DW6iG6eQigyA8SPCPcZJpTO67jf5O0w6vpvx+ERD7bzh1akaVa2XKd19I4lMOIkb/jZyDGN0xNgBU48DObSpuV+IWqdAgiYM7bTu6dpJ5EqR7+qbfHdmhkMD2TiqaCEK7ra8j4+BqYEVJgvQ1RS5wSPThd8JIIIPL6fvSEIMkm1y+8WHCh2CMxjzS4Q7EIVfHU0v8WO+X9szut+waVYbcOqIxmdv3mHUr+nBuv5gWNUjPqjblYyf5FvVH0DGMyo1E3/N6Jx/Ao0aNqWSvmT4IlGyDK2lkdtSa46uJesPNgI/BgVuxdz3KOMaag/dhyaKrUCZNZ3tPKq1YncDgTGx/d5HjpbOK1osbeAKwL6aV59HG4mkM+LWMQgaYGnZMXYpCxsl0n3gxF3l1vGjGZYLB4ick+GmcFJyES338sdkKyOHibHExhqbStEqXhqM86SXGcastC5HscbNOOfHHn9RXL199+DM6GiCGFQ6uDKjIuU+aBLHKkNkTXBj+97l7JzUMR0421J1dupbzPFagRZfN9aIPary8PPDhrm+HRbs9rg2FKmBtCXVsToU34PbB/7nD5NB4R3Kwqt26P4kDZmuqV1X7tvbyezfrNvObNn3Gq5tw0tvlWRmcDcn5e9ItDymDZWNQ4oqcpoYbcM0Fdy5g2u04zOH+4GD16vulj23d+Z+dJsbhUq2Rr47UygjX1tLaBgHtKon7dKQLDPYTjEczju++uwk7oSmBhYZ9KTNgMrDGLPSEdxoJ1nN5YkFZBPxqfPjclVzdjF4y1NAI+Cw8p0Dd+W8X3qvSQOVFgKgJui4/OD+61w/j3Kt7etd4JnV4TlO+yQxPRnYeM4+QpRsuVkzp/8V+BhPGD+rpxNY4tf6QPtVC0pxWePNmJDxDuLC2z36ZvBFKn7PekRy1tbHDm
 gYAmRHRi
 8FN6d5a/ZQHl5IYvHNb//y2SzVVK6fO0Fdaj6m/CrfjBl5JdNaccknXTdRXviCoWRbxmIpaHV+zqYXwTjpjkwhxuP7V1uXXlZzn11D9Ibx+SQNYaqYMkgi6GRyCcH0oXf5sYuF5hdTsnZa+gFNs3o3ag/P6i0Fd2wS1OqrklwGcYDXLCK/wKSrT/TN7jwgnJJ3B9/WFW2lHAUr0iRCMyd09B3YK+a44e3iEV7Kzi8LSF+9MDaVzHxY5I9cj4mRV3N1VFNXaKXFi9eC50aDQoXkubrH/4PNmLAQrcpGBiKk4A353/ODFD8wLjg6zafxdrjm8/bDRmbV4k/vSpZSzKKk9vEFphiq3+vXrOQKrUsVMtJ5EmXOmbxZm1cVV0ocLt7xV1BkDr8Zd1uj+v5x/hVxpZKsEL3JmR+pfHCQ0DKlw/ZgXwwfYtdLHnZnRn9F9/fuHHlifMBwO00JxHN3Gq6OPxoJZ7766Dd/LzhFviuC3S9zQMeqmcpWl/t0aj69AAJ+IiJ3VZJtYgiNt8dmm0y8kYSFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/08/2026 1:11 pm, David Hildenbrand (Arm) wrote:
> On 8/10/26 13:06, Muhammad Usama Anjum wrote:
>> On 10/08/2026 7:44 am, Alexander Gordeev wrote:
>>> On Fri, Aug 07, 2026 at 05:26:04PM +0100, Muhammad Usama Anjum wrote:
>>>> Yes, this is particular line is for non MMU. In this case, CONIFG_ARCH_HAS_HW_PTE
>>>> would never be defined. Hence hw_pte_t is just pte_t and direct dereference is
>>>> allowed. I'd thought a lot about it; is better to leave direct dereference here
>>>> or use some helper. Then used __pte_from_hw() was already being used in generic
>>>> ptep_get().
>>>
>>> But in case CONIFG_ARCH_HAS_HW_PTE=n __pte_from_hw() is still gets called.
>>> That looks inconsistent to me. Why not just call ptep_deref() (see below)?
>>
>> Agreed. Calling __pte_from_hw() directly exposes the representation
>> conversion at the call site. I will introduce ptep_deref() and use it
>> here.
>>
>>>
>>>> There are only two users of __pte_from_hw() at this time. 
>>>>
>>>> ptep_get_sw() or ptep_get_deref() is better name here?
>>>
>>> ptep_deref() would be it.
>>>
>>> Do you agree to the suggested API requirements?
>>
>> Yes. hw_pte_t * identifies storage containing hardware-formatted PTEs,
>> regardless of whether it is attached. ptep_get() is used for attached
>> entries and may provide additional architecture-specific handling.
>> ptep_deref() is used for unattached entries and performs only the raw
>> storage-to-value conversion.
>>
>> For review, this patch would become:
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index bc0b9c65aa1d0..ce900d2652d91 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -1283,7 +1283,7 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>>  #ifdef CONFIG_MMU
>>  	return ptep_get(ptep);
>>  #else
>> -	return *ptep;
>> +	return ptep_deref(ptep);
>>  #endif
>>  }
>>  
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 1768421755a9c..08613593f3320 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -490,6 +490,13 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
>>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>  #endif
>>  
>> +#ifndef ptep_deref
>> +static inline pte_t ptep_deref(hw_pte_t *ptep)
>> +{
>> +	return __pte_from_hw(*ptep);
>> +}
>> +#endif
>> +
>>  #ifndef ptep_get
>>  static inline pte_t ptep_get(hw_pte_t *ptep)
>>  {
>>
> 
> I mean, how many such users do we expect? 1? :)
> 
> Why have a helper for that then, that seems to encourage it's use, when really
> people should be using ptep_get() ?

There is only 1 direct dereference case and even that is for non-MMU case.
That's really good point. I'll keep using __pte_from_hw() and put a comment
in huge_ptep_clear_flush() that use of this must be avoided at all cost. An
API can be introduced in case more users arrive.

-- 
Thanks,
Usama


