Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 370C4606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 12:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=hbO3qy0R;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=hbO3qy0R
Received: by kanga.kvack.org (Postfix)
	id 582516B05B5; Fri, 30 Oct 2026 08:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553556B05B6; Fri, 30 Oct 2026 08:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B6B6B05B7; Fri, 30 Oct 2026 08:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1919D6B05B5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:13:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98B6A14065C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:13:22 +0000 (UTC)
X-FDA: 85379182644.15.8DF8BD6
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011049.outbound.protection.outlook.com [52.101.65.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 423632000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:13:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=hbO3qy0R;
	dkim=pass header.d=arm.com header.s=selector1 header.b=hbO3qy0R;
	spf=pass (imf03.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.65.49 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793362398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3PFuhGxCT6CHmA6Kq5jQ8IT0fQb5siA0MmF3bJ7oBw=;
	b=bY3qXjv8v0IyWMogQZ5V1vwe5y9bLsKF3r8Qs/hSTU26qoSp/MGSG7/Ozjehyy8xsokyiW
	It5lVpWkPKMFjUEk8k61vXvZBUqtLzNIkLltJg6YGUVpUePXOVB9TKrEiMR7TqR2fdAfG2
	HcVD530XqxKipmI0BY84C3aHkOgJy+U=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793362398;
	b=gU0MBfRd3O/ah8VQ5SsCRGysVpBmA+vvaz0u7EbAUS6N6/0NsCDjJz1U9C8pHvwkIPnbS4
	4eLcDY3JqGF69ZmJ1Lr0mNiWiaaqkRMUhiiWDSk+L6pGkKaHrsti4N02AO/k+kaQoc2N4/
	uCyHzZ+4JDaT6t/xM2PZcOieLpdKRLI=
ARC-Authentication-Results: i=3;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=hbO3qy0R;
	dkim=pass header.d=arm.com header.s=selector1 header.b=hbO3qy0R;
	spf=pass (imf03.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.65.49 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BRF06MC6P+QfGdK6tx+X5EDqYozFjBdtX+P/HO26377ODk85tu8WRfC8rMNBPqiEVmm/Lnt8mJ3FPvb13eOwio+B/9cX1o3ibjV5Rg3vZ/5VLTBiB3fpbQaA1XMKK+3NctLOTVXDcR6zMx2hL2dLQl6eQ0fssij2Vm7FDOwk7jEpzUr3Qm3VLHpg8fzw1fj//yOhzPkljXbYShfEErpdbLrjRnsQ09Jw4cy5XdH9HgeBPKVN/z8XFkf/4W/Q0HVDX/JMcpciwhmlthJlzgyWHr31W2yjKFNaUdBpPi863GK9IAK2J+1F7S/WP5HfZ/1MqtpStG2tkt1yKHfI426D2A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K3PFuhGxCT6CHmA6Kq5jQ8IT0fQb5siA0MmF3bJ7oBw=;
 b=es/8SNOv/rMXFXMtIlzc1vZUHku3UiCSVkZFbSnfInOtNnE1TlgPhN2Ho4eGz11k9fV/LAfNUjMyegqCswXBpgkWaiR6rWL5hIvRSoX4owBUBYzw79zl4tczTQYrj4xBWFPh4sFinycM6PdCSHW3ej1t78pB5Y/zTgkk4jb2AC1d8Ce/8yLQctEfA4K5sSUf78lHzfhU6fz4n8m9cpOVfaXCeMq0iP2td5umX3gXJxNlsEYXSSfSWoGsiX3UrZ6VN8qIn71PIh/xnGtIYttPEZPUUChLpojhT5KpCxGQrln8nCtJ/SGlmbHNOMfjUaBX1GKic69GB+yJQbQTXLfcfg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3PFuhGxCT6CHmA6Kq5jQ8IT0fQb5siA0MmF3bJ7oBw=;
 b=hbO3qy0R8fV1QRafR1/F3QG6d+BxD2xc7Uu1dt4bDrnsFuTMZY2Spsep182/MPGHwzHb2MOh2uBWwWKfKpxLveWkY/2uoncbf5hGK377rzQZCL1zGGv4FELCpzOsbqubZJoyH8HGuqbhf9/Tg3HranIPOWxU6K7ubvcEczFOHrE=
Received: from DUZPR01CA0063.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::13) by AM0PR08MB041735.eurprd08.prod.outlook.com
 (2603:10a6:20b:807::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Fri, 30 Oct
 2026 12:13:13 +0000
Received: from DB1PEPF000509EB.eurprd03.prod.outlook.com
 (2603:10a6:10:3c2:cafe::d) by DUZPR01CA0063.outlook.office365.com
 (2603:10a6:10:3c2::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.10 via Frontend Transport; Fri,
 30 Oct 2026 12:13:13 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EB.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.4
 via Frontend Transport; Fri, 30 Oct 2026 12:13:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=crxuL1IFU9C1byQxFUdn/5Kadhg84jdtFF4IMoghoOz7F4uWnIMIwnPaiQwCyTPx3434X2A3K/TzbblghUO2+O4eIQKvVoUQdFL0FG5AzDlq2JGfLPRQHzBs4vF85t0NmnBwfS36rqYhV8ZB6+vfEUgNOojlzoBnr2QrHeGCT2HvyXX2QNPPRlQ99sbJR+udWwyORP+04JreMWT7cIkF0B+zrIO6RH7dQInmIjcaS6g67V3AT/TdcWPyTRZCqUMCNr2ZY2iyVcx0kd5hFbHwqd0jRfR/XEy62ip6zxwiIm+WsIgikm7tLbOjiHRCWQgTCW0YS4sRxJJiOa+lNwX5fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K3PFuhGxCT6CHmA6Kq5jQ8IT0fQb5siA0MmF3bJ7oBw=;
 b=RTX3PLrAtLY3Nd7F+XurMv7Lw7/bmpxPpu6O843cJj1n/UwU83eTxRjcPtNFpuJtZ02cF8ColD2X8/5kx7ijUI77Q2PTc8KpQR3clJq9aasB0ZNCG4/zCBujkszWHgwXVCQwz58e6C3dtA49ZEjhZC5xpN7RCTMFpTZl1aJZ1jTzlRzRPrFhz4M6rdNNFfTwUaW6pXhVxBVkhJMowd+KoodAVj4EMdf0NSlN2RW4upcOy8ciCM+7Snz7ksnGs077AIbbAPDWkUH67KniJYXntHs3DFmJrtdPD9xWi52eVXss6Qw8RL16HV41tcjevcpgtdrKytrJdESZ8bXFqkFSDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3PFuhGxCT6CHmA6Kq5jQ8IT0fQb5siA0MmF3bJ7oBw=;
 b=hbO3qy0R8fV1QRafR1/F3QG6d+BxD2xc7Uu1dt4bDrnsFuTMZY2Spsep182/MPGHwzHb2MOh2uBWwWKfKpxLveWkY/2uoncbf5hGK377rzQZCL1zGGv4FELCpzOsbqubZJoyH8HGuqbhf9/Tg3HranIPOWxU6K7ubvcEczFOHrE=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV2PR08MB9229.eurprd08.prod.outlook.com (2603:10a6:150:d5::21)
 by DB9PR08MB11402.eurprd08.prod.outlook.com (2603:10a6:10:60e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 12:12:38 +0000
Received: from GV2PR08MB9229.eurprd08.prod.outlook.com
 ([fe80::4dea:4c1:9d33:db7f]) by GV2PR08MB9229.eurprd08.prod.outlook.com
 ([fe80::4dea:4c1:9d33:db7f%7]) with mapi id 15.21.0546.019; Fri, 30 Oct 2026
 12:12:38 +0000
Message-ID: <bc8c1fc5-4620-4515-8520-22ebcd0d592a@arm.com>
Date: Fri, 30 Oct 2026 12:12:33 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Mani Tofigh <mt4022@columbia.edu>, Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 00/47] mm: various (urgent?) fixes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
 <2f23dafc-43a5-47c9-a819-e696cda6fd44@arm.com>
 <baeda061-e0d0-4be1-9aa5-8886182ca83f@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <baeda061-e0d0-4be1-9aa5-8886182ca83f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0164.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:347::14) To GV2PR08MB9229.eurprd08.prod.outlook.com
 (2603:10a6:150:d5::21)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV2PR08MB9229:EE_|DB9PR08MB11402:EE_|DB1PEPF000509EB:EE_|AM0PR08MB041735:EE_
X-MS-Office365-Filtering-Correlation-Id: 2189c47f-5449-4fc3-7b1d-08df367f2bb8
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|18002099003|22082099003|921020|11063799006|56012099006|4143699003|261022105027099003|261021121427099003|10067099003|261009223027099003|261026140227099003|261028144727099003;
X-Microsoft-Antispam-Message-Info-Original:
 CF+hepbNSjDrsAaPsKrz4H3R5uQeSUq7VmP6Es99i7iC+yLGjqas/fBhXXLTZEhnpgawRgoCsItLo20vVUd+Jxvkv4gfB3jx63ov5hlqrNMvq2SqY4wzWQcJTpmyhjPY6opND8/OrKrJUQtYGA2F/pPeJvFMsRUsgrlDQqDB08QUDCAZO3uS3poFfK5OuEwKHBP85EH+Djz+aYefi42wB/i0k2ezStmlbJWxRZ2I1FQD15LOGdI0gUOSXz16x188CZjE9VowkcDxwgg4rS81+fAGMk2t/bfuL7lXfV9kXzzOgDrINKx/S8VYRWHF9l/OycgltOmb2MBV/I30d5zV2nLxDcBq3CbRr2Drfdm8kRGR9xlL5f9c6QN5UbotQzT+DX7OgZuo3FNAgzjmvpC9bxyJo23QHI5Y8kFG2Nc+TPnXJOQQyiSJPXZBO3LwQlco6Fkt5n/HjJtJfvYpjlVOBMdzojoECVs4cVHinsSwfgBFC1opyGPVwb1iwTkq1eW7ArSzJ+WHoSdhB/DqNtipzAUGoYJPhfTPdZL1kvJ/vUmjNYOTE5vF92mb1PNsPyNGKUmgeCJZns50D+fpdmPlMX1GOR/AA0oFdOwkbJXHoBaIw7Dh7tF6VRcspnsVon58qRyEabkIhdr+l5873AoGxn9mFd/5uZ9r250H05kdkuo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR08MB9229.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(18002099003)(22082099003)(921020)(11063799006)(56012099006)(4143699003)(261022105027099003)(261021121427099003)(10067099003)(261009223027099003)(261026140227099003)(261028144727099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 TZWCv0FRVVkt3RnO/JGuaOyiz94B6TrZ8QNMj69pyVI/jrKE1tKJDi4PxqU8DbhN4LP/6osdaesl18qKaPmERuSRuUisoU4pDEzXa8qdhk2OrBXzirroAbq94vlY0nJHdfwV8BzIUF6PwkjJRDY3G9zv33hkb1oOhijEsl3kzVBZPw9N3zK2XiqV/a+kKgcOPer5BgXX8ewyV6D+K/ofyBZZ2Cn/RAp+8wH+rBB7Olqw/DzLDho00+d9M8aUrQ8GVemt3CtRa9OtkGYj33tEbIPBHL3tTuPLzoYijAB35uvwv0u2zHMvKZ8oPmfd8LP5s4bk8wTUg8p2FctRh62Onw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11402
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EB.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	10f7071f-a02a-40de-a04c-08df367f16ac
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|35042699022|14060799003|1800799024|82310400026|36860700016|921020|4143699003|11063799006|56012099006|261009223027099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003|10067099003|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	YBEcdRAVtXlyb1mSS2RptunCJkBAM8eG+O+7H2GHy93LuTGW3JJShcZ0SM12qcmMHf9UJe3wybhGz02HaEqqkfVl2FYv7C2D8ocCzdmnBcjED/n3gP/H14a0KVaivmVlZwapT4w2VpjLjo8ueOxO/B4AfqktrsTCNkD81mojHvq3IXr0+5J1Ga/FJfDpNr9mM8hByXyTLG9s/9gCLgD88ArNu9MIQ3L49FRIRhkDWxR+SLZaywbHkjHyAVSRHwtwOiK3C2Ak/arTUZRoRGMgKmdanjEZJQR+GV+NNh2s2H9MRfP3HnF1f7MsLfdZ2ZXSw8BpNAIanoHY/LztRymboa2fhmkSwbnbW3CBoDX0IbFfciBi1cj8uvrt7OYyWFOBUhly56W3oupk1znugbkwvQtNvNQEIj4L5G1Eb3Vwlvd0unDWi8VH1yLOraRHQ+UWgnqLFt0jd2U4wTP6UlJksXrOZYiu0r+KVKWq9uLMmlA6G6vqBiJN0EVEAvmO5YYn1j010RTeYJIiJ52K55N019RUS9ybsvZsI42SF6Rgdu3l38XuwQbYKu0ejSZdr4/dQWLkfDi2YPHCd4CCQiigkvcRVQBhZti2dB+r9RsginwlguENfQNQyNi7o7zCExhQSgUJiJp6hohiA4UbFHWH8uTKM8n/7Sd42+ZnLEpGsBGFvwVn0ONG6kWQ3VoQHMjBNYKIae/Qy+IwZPVTHY+Gjg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(35042699022)(14060799003)(1800799024)(82310400026)(36860700016)(921020)(4143699003)(11063799006)(56012099006)(261009223027099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003)(10067099003)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sZWVwxD1ZdQGeqUQDjccv0HxpGW+jQpVrmeOhbyne0Gi4qGY9wPqjTRHMOpUXHKNPJK86CsstqvF7fl4dFALChSlR2PqRxemnuJMB3j//fWIyk4AcnF3UksvC10UAk6RyigOKLVcquNS0eqIsj4zBT0V+UAbgqGbgD6PO1owZ9LMAJM8Vw3Z8IA6TvAEF7V5rv0A+m9fc5nR9mX5LD1iWyvi/IAhUdbI1jxbWnHtysNJyxE8Hy1kXNEAMp+Cqg6dFFDod12MEFEA3D4YDNoSygELJLaivmkHTfss46AAUF1pKqN60zaJsPZ6sqmksMWdUiP87nm2OHzhMfUilFGlTGyncHp3bDVFW75UR+U9XDRdMg64aCUcKEzCCL76GzM/wIihtfKNdcygwiKXdUIXqtbFOaLcQBz3cfJAvA+vvtmSKWmvywruxXGlasYO4fBv
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 12:13:13.1408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2189c47f-5449-4fc3-7b1d-08df367f2bb8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EB.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB041735
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 423632000C
X-Stat-Signature: ixaiab7eaeqtp3y44p3scf1j41akt9a5
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793362398-418430
X-HE-Meta: U2FsdGVkX1/dIchkZKUJ8v3JLH92vvqeWtUcnVPxxaTknzu6/c2E1SycLtXNtt1Brpg8zTnTbbpP2FobEHi9mGkkzbNRMwlRFpqlLxd0dY5ntvjgPXZ2pCjqo+n6wFmByEE4dX1N2J3lwjFhTTVwEptrHMVMkMMErbXx8N5kTaWAArUI/QevY6pWva8/MkboYULXkd6rhKJrAxxONYGR7nXLkwsBFnQdvM5nS/vVzOI5iKgLnlzpgFr+3LrFLqIyz7IF6sDJ1tgfTOWcEY6SaPy/WuFB+IFwpYVxc3YSOSitT7eucwVk+6OONc3ioVoEN7vO8g2OTB12spHotuttjA4G8qfVNZgaErnoojnH5Sa4kv/uHDUFfOzSBpSQk1E9HPK9FTQwDfLtzyXrGuSDuO1NuLVTldxuepX3s104JvRw2wWiLWjrGeD+XfXHw9j21UnQ2Fql5EE5jJd340cFT9Hzq/Ae3CN7TC2n4BRbc07d0CC0yBRkp33UkndSHz32KGXZ/HkFYmjTy54Z2Ffs3d7XUGOcYJAAXK8CMmyewOB3x7hyr0EAZP8jYU90AHOrja3q4hHdbinjW5W6iClMmG6i3M0f7Y/bHWGdi1uYFN2l3bnpixERutPLjZofmX4JKiGs8hxsqZTu/f1bvyyf5l0FD9JNyUjdp38dlH68uSluoPOyq5KuXwDzXKGAzr/7X6z3rePqvhpNbZBXvJKFBKOh47ACpEIGDf9KuqGuHM0+UrG30bspmWzb1YLd6iJZK955phoebVZrTemDLouskjtvYcOa3j+8lIQO5MjXpST2TWSAaOjOctOxx3t4TJO6y29mmNBnGfYkw6ynaupAIoeHeVoIGvv/zQ7wP+SLrCVf8sMrS4MkQrJazMvpYrykyRROG43XRNXotRLW/a8AFHkxYHCNSd60d/YP26Zgal1enomDKnrG1hAH2llXjxE2guhrzsi+k0nQfruGUF5
 eDANZdP1
 FaXb781lIjv1cO3f5VxV8xoz7VnayqxrXb6h0prY3zLw6h4NbFS2j/xgRLvEGGkr8c/9QgOqgyfAdLtI4ESro9lMLGvGTfFfOY0OGyBnPuDVJy99VfQ5M5QvWn9yHsgPFUiyV1tYaucKHwi1XFN77Y7q2Mrt2bFpQQjYaZ3oT294DQDcMYyEDjZKU6y12Pjl4MkijmcxVk4ADwVta1TATypS7w5YA2c1TU4ySsVV6icyTz/iAvcQTVIjFgPkj7X9q3YNNGlaKJ4APpH6blWGhlp3ORQKPrWRRusLbA6LwF4fN5XDOz+NNcts7vKAMyOsq/n1wUy+MoLf2WZs+SgrsWfNvYUnz7knQ9l9mYfV3cG6sxli3lg+tWE9ud647o8BzcN8iLITRD1UzYumDBZaICHY+CQG/GDBerUveYHoi2Pmcupz79kotFj0/Otf3XQME/o+wPUxXD/qLTBnWV5UGdW93SNUXLw4JaaYDSWGuV3asFBNaj8oB57gSJbleeKQHVqfNuYiq66x3GCbdvj4ScGF/KJ9EPIvOBMPTf6Hjy8WlMadWInvqZa10cbRL6lveLDHR4pWrUxJWDQgds3ByRAOx1nlZMGlYX8yQoyACwaLtTWqJV+fnruURS3e4VEy8udHnGp83kKWGTQ3szEWOeU54HjZhsxqyhli5Z53oiTkJxh6cTwxTwWHoC/SCawup8Wy/w4kfJMbrAHiKbiP9r9U7l7cmtT9QTa50QUdmYIiW9nM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 30/10/2026 11:35 am, David Hildenbrand (Arm) wrote:
> On 10/30/26 12:19, Muhammad Usama Anjum wrote:
>> On 29/10/2026 8:32 pm, David Hildenbrand (Arm) wrote:
>>> See v1 on details. TL;DR various fixes :)
>>>
>>> Thanks to everyone for the review! Hoping I can get some more? :)
>>>
>>> I am planning on picking these myself, moving them to linux-next fairly
>>> soon through mm/core.git.
>>>
>>> ---
>>> Changes in v2:
>>> - "mm/memfd: check for real shmem inodes before accessing shmem state"
>>>  - Call it inode_is_shmem
>>> - "mm/truncate: look again if a folio left the mapping"
>>>  - Different fix for truncate_inode_pages_range
>>>  - Adjust description
>>> - "mm/huge_memory: fix zapping migration entries for device-private THPs"
>>>  - Move handling in zap_deposited_table
>>> - "mm/mmu_gather: fix flushing ranges with 4 GiB or larger"
>>>  - Adjust description"
>>> - "mm/huge_memory: split huge PUDs when adjusting VMA boundaries"
>>>  - Drop split_pud check
>>> - Link to v1: https://patch.msgid.link/20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org
>> I ran Fastpath, a Linux kernel performance benchmarking framework, on
>> this series against mm-stable on aws-m7g.metal. (I) and (R) indicate
>> statistically significant improvements and regressions, respectively.
>> The results show 10 improvements and 1 regression. Other, unmarked
>> percentage changes can be ignored as statistically insignificant. Hence:
>>
>> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> 
> 
> Thanks for the results. IIUC it's schbench that shows a possible regression.
> 
> I would expect that no changes here really affect performance at all (neither
> positively nor negatively).
> 
> "mm/huge_memory: fix list corruption when deferred_split_scan() races with
> deferred_split_folio()" fixes locking, but I wouldn't assume that this matters
> at all for this benchmark.
> 
> "fork: take mmap_lock before copying mm_struct" changes locking, but I also fail
> to see how that would affect the benchmark.
> 
> Maybe some code layout changes just affect some benchmark on some machines?
> Because already seeing 10 improvements makes me wonder how that could possibly be.
> 
> So I'll move forward with these fixes for now and see if we get more reports and
> could identify actual problematic commits.

Yes, these improvements/regression might be because of code movement and how it
has affected the run time performance. Most importantly, these results show that
there isn't any drastic affect on performance. These fixes are good to go.

-- 
Thanks,
Usama

