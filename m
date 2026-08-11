Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B06CC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743046B0096; Tue, 11 Aug 2026 10:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EFD86B0098; Tue, 11 Aug 2026 10:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569E56B0099; Tue, 11 Aug 2026 10:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1FCC96B0096
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:09:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9694012049B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:09:58 +0000 (UTC)
X-FDA: 85089172476.15.DB3B329
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013035.outbound.protection.outlook.com [40.107.159.35])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4D0BE1C0012
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:09:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Of2zMK4A;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Of2zMK4A;
	spf=pass (imf21.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.35 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786457394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=spajHA6ointRyLw86RivlHQVOLc0loAJEJ1TlU4g/dk=;
	b=L8vNA/Vc6ijdPdfnNDMBWJNRyOvLAhiifgqz2cK//h23GaMFpyUwBQegKaLW+0YT3M71yg
	zvVuGEEa4y3a+L6SdWTtT5WVTEdn1W4wJtorsaB6gW0hPUTgr8xJIgnSjneV7d+wbze2XZ
	pz7mpD3r6E/Xo3UHPURw3U3Hf2aruN0=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786457394;
	b=xrDgZ4X/ClSL4hVE+zNO7nEks44hVJr4sbdYd7yaGsdA/+63mcr2/pK7+RTcHEwfYMbBhz
	Q4pARcf5Ymnw6Y7eo4K3BPVU0wpL0fYDJdzwErfYJZ17WovzWOsDCtuF2H8P0JeuDptm5+
	0LaSrR/mUCu9Mwv1fUNavz+A3Bf0Tk4=
ARC-Authentication-Results: i=3;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Of2zMK4A;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Of2zMK4A;
	spf=pass (imf21.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.35 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xcDPG0hVFOk0AUBj4C159DlzoaguQZmjigOLV2wlFCc1pdTt01jMQKGY/63LO/jOC85zG8fc5G4S/C6LkqRvQq8cGDjsCAp4G0jAx5M6heW70DQpUJHjiGaHTKnlqex+aOAtpgfSFkhVomSobgG26G6LQsP/rlLSbbT9biSftIQAxcHrOrhpc/0mz0VQw2WcUOSxlc7+nk02Fmg58AXbzUzfJrDdq58Wms8TkhdGIF914fbh+45YDgmPICpe3rEcmG8FNY3lmrlAVnxH+OvFs7B5Hh9XDmAxy7tKUofargAwaRLAuSv6YqFDrLtEJYGZ8P+hC53w/NpVCRzM9KBrRA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=spajHA6ointRyLw86RivlHQVOLc0loAJEJ1TlU4g/dk=;
 b=g44y70zFwMxf1rENbj2VFHwbaRyRQgZzGayNR9x0/8MrFLFhqCzljt7pZsMD14Mjeoa2oQINEuzzHsUleIeFCipLAFcZZipBxMdPXY8RPqw+AEb9AiUeIQRyTI3n0Z0036JBosn0LDw/M4rlkL4dFiRVhD7ioWXRsIwQYR5qraJe5t4h49ArxxFG1BIvRemUHWrQBPcUDcd7mf8bDwzF1TTDxCo6+MssXldmesRH7X/ERmExRfyQywBYtlefGWdousS3j0NG7cUg2zL/ozv12GzgfvtaDWsfIlMMLX7AsX1VHSM6P6EnHRFJZiFzUrSylcGJcmY98ej2nd68mQrJMA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spajHA6ointRyLw86RivlHQVOLc0loAJEJ1TlU4g/dk=;
 b=Of2zMK4AYCmnRWDmgZxXsjcqJPO31mxBQjUoXGVjTGfhVwp3SdIVVi7agOghu8iMGsMktBYOl3wqspqIPSdjK9UxF2eBDJ6bk6sX1c3OJggt0NuQA/Et5PtcevurQjrhzd+EKtrJjoGYBF7cOXsfD+VKGP1nFjdL2BwS8rzk/ik=
Received: from AS9PR05CA0242.eurprd05.prod.outlook.com (2603:10a6:20b:493::26)
 by AS2PR08MB9713.eurprd08.prod.outlook.com (2603:10a6:20b:607::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 14:09:45 +0000
Received: from AMS1EPF00000094.eurprd05.prod.outlook.com
 (2603:10a6:20b:493:cafe::41) by AS9PR05CA0242.outlook.office365.com
 (2603:10a6:20b:493::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.26 via Frontend Transport; Tue,
 11 Aug 2026 14:09:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000094.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Tue, 11 Aug 2026 14:09:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HAp0D8fED4BIknp3JzrYjuhx/SQCyUUgLhlHQqssIAq2N6Zbn1so7sXZlziVHIj7d6R6PvF8Ffjtzn5GtAwxsJVYpCiC48lY1FRKuvfiZSsIjOzx5m0rzsNPepoiaPYMUz1G50y3QAq/T9sRgB7BwN9w9N/5R6Z/dvPN6jj2BvCi5es97DYocaURGfL86kcHhZ1Slwc/nSlmXR/BKN/XnrkkkH8IwV9gNY0TdJ1pp7/fHWC6RH/vdaAWVJV5U07z0j2Ijxbtr1LpePU5MZb1DHhnujJir1mlbvttFdbM6COV0mAusxSw6xvcW/kyWYKjFzABD7KH14UKtT0642548w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=spajHA6ointRyLw86RivlHQVOLc0loAJEJ1TlU4g/dk=;
 b=iaBjCOaVhCrKf98DWl2iS/e0DsC7e2a2L3DMyqusEaofhJIZiVQsRraj6DPlUHWjukjnzf+AoDBXBd5Ox9PjTzzPv3+rGqnof+EKhq///cIsuJpOOu7gm5tcXvQs8wLkXbmtqZ/yG17mPwjxEksDitQGwZ3BuZrdYfyLesQWzPqWPhK7kueTmeaMsz7EK+6sUZMOSPcFkkNDWrBv25fa0YsWNMPqFyhGOArj1uD+rr+3ELIXOhc57Dz1C3xjDevg7ocWAmwbS63Ihia7vPkPc9ak4loMKc52jcciVQPoAiesWVhjMqiBGkrR2ZU76WKZ5dv12pZ7rzg4OvzuMYZSAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spajHA6ointRyLw86RivlHQVOLc0loAJEJ1TlU4g/dk=;
 b=Of2zMK4AYCmnRWDmgZxXsjcqJPO31mxBQjUoXGVjTGfhVwp3SdIVVi7agOghu8iMGsMktBYOl3wqspqIPSdjK9UxF2eBDJ6bk6sX1c3OJggt0NuQA/Et5PtcevurQjrhzd+EKtrJjoGYBF7cOXsfD+VKGP1nFjdL2BwS8rzk/ik=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by DB9PR08MB9730.eurprd08.prod.outlook.com (2603:10a6:10:462::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 14:09:11 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 14:09:11 +0000
Message-ID: <b21c4cc9-84a3-429e-8156-0b9967b2f133@arm.com>
Date: Tue, 11 Aug 2026 15:09:07 +0100
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
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 3/9] mm: name pointers to copied PTE values ptentp
To: Anshuman Khandual <anshuman.khandual@arm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-4-usama.anjum@arm.com>
 <e7osakog3yvdewhdlrk3bsp27pwt2nnhroeb7zihlfxyjotarb@rwxkcb25crh3>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <e7osakog3yvdewhdlrk3bsp27pwt2nnhroeb7zihlfxyjotarb@rwxkcb25crh3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0197.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::22) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|DB9PR08MB9730:EE_|AMS1EPF00000094:EE_|AS2PR08MB9713:EE_
X-MS-Office365-Filtering-Correlation-Id: fff88c87-ef4e-46f1-d491-08def7b231fd
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|6133799003|10067099003|4143699003|56012099006|5023799004|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 X8qvVO1tGgOGc68Tj8e6uYIlEm61fj7Yc+rR2Ay/UJ31hxb3PHm/Vx9ayVx7BXhFCE26lvSj1FVRwdkt9qTwDUf03EfjHj5zTGh3lNmthZUPU0QqKoBPqNCZMmlIdwvntC0ETgEazcLBhiggaaU1oTVhVrF4zZNB+8zbzV+Jd4wX3kEhklK/JQF5PBzEsMQlnX/RA2nh2JKyOqzVqPIP0JRjHOvrNtwouMyn4EApYlEz54M5OIY1sJGVL2DhxYD3bw4zw1/+YIsp0Em0CEamCCEu6TYlPIaaPzdzbep4Q20xFGwIz/vtY0BuDXxxwaquypHlTctA+f8g9C3qAfi604tm9S5lbClK6rgQWc2C7gtm+k/RpQITOlu/8ySU8jRAuLryQLIaU07iwsnyadRcNDbGozKdXF53Sl5vfnr69T1lGLspteufAc2KPwXQegTPnGNpBa3XqVK3I0rj6mCz2fhoS5cgar40oNGDel28oFjLSHmTqLzlgfCXDa/SdbvfGw6kYd7pbX0X6Er0Yoa1pmDs1KkhBG+od3Lm2kLHvxMgPWvVu6+OGVUF/muODby0JcN0Z5kv6Rm9XFuwS+rujtHHfFG+S8WUrGIQGqc1z/gh7bAy38Lj79K19jGGQknUUaoEdzVxQEjI8Btl4hXMy1IFAn4QlZDRT18lnMFWkRU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(6133799003)(10067099003)(4143699003)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 PoID+C9pr8SsNiZRZqrmEF20E8+VyYQrbmNS/atK0zw4H6xYhN8JDWaNyZcuAbKvDXx3md+N466b0729ETpNiHwGFoQQWHtr1wStuHk00WaD7R8uPTqjp9Pek556gM35mQe8FX1aL7Sp2zO09cPHEXYxt6UjkF20b/IyX2c8fU9p9FtV22m3Uikksqe9i+Rbf7inmIUq5CxSfVO/lt6nTQ/RZeCwOhVPzS6fqYMTUAmCwPYjztBlT9Knlw8LjChFicyl5+dVAtGMoyOikQxEQPeOpO5qwUVElOLqNbWdabbXkDPmBevoai7DCbgoVW7V/xraDV24EN08DFdilYcMzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9730
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000094.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	685e73f2-e898-46f2-3da0-08def7b21dbb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|82310400026|14060799003|36860700016|35042699022|22082099003|18002099003|3023799007|56012099006|10067099003|4143699003|11063799006|6133799003|5023799004;
X-Microsoft-Antispam-Message-Info:
	QrDAuJ2AlDAgvei/zvkJkvfQWUZGGIE48wAeeS/YiIuKQGmvUJdnpoOGxcyZyGvL5v9YQDS11/dPPsMg2cg1TdIBKj/ZPGWerzgyXqYtwORlNDmgfnW1ufsTE6Dd8rVH5Y60KHRVB7gdGtwPo0QRPYxa+19gn2F9ZYAc7vEaMH7O/lMCMTdnVAeZpH3cffXgRvh0z4psptR+jLz5AOW2p95Mp7oEkWASyLHtxgupDKTGEedMTMvp//INjXGo2cWcA/e6GrBUxPqcX5kfCHlTW7LZJVVh7KoMepIb3kvntg0sZB7NL70Gfcia3025jrIEKnF4KqGPNa7L4Wq1HuGXv0mXVwxgNaXb4NK6wEqF20/zC2xOQ03ZEDkzIaO5E8EtDOmMHI3BTAJp19EjbxOnpsbjpZwiRMVYN8hTGfn+phsV7aF1B5A1fxxKzIWNT7TcyDZDNbDBy1fbQToFO5F+i4z/RQolLUS3Wn0ibbXuZ+MygZXiKYKpg6hE3qAiTq+5zd0g/bBOWtNab9jVgdTUMONzw2ZxDG0EgMOHwF0DiCsTueED+SeHwVgZU+GzrMz87g33N5tKbau+TbAQn2QXPF9MxQ6cHwA8s4U9bUxPnpTjQgHdHKTvFvU5aY7Ow1Ob1uTCPhu5ZMh43XcVPfVFoDWZh3bLL6721rPAVQi4Q0ZLIBz69rhhyWPreQ7jy1l9vvLbXjiKTroIq0PcnHoNqA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(82310400026)(14060799003)(36860700016)(35042699022)(22082099003)(18002099003)(3023799007)(56012099006)(10067099003)(4143699003)(11063799006)(6133799003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vJDzeRb927ULnuNkJdCXMZlhivSk2C+D0uSOnJ7V3ytepBxLXm9FF/vHnPjZGBO8nF2u/+cRH8iKRjoTl1m5jFnoKyjflZUcWX7Uxbggm+eXM9hAPxwV4hQPwdlt4m0bJeyYkEMZjtJ+HCNEdOf49hoHllcfXObByHwyeCPEQEmfATo3YQAMseQqQ7nJkmgo6XalANWP4f+Hdn6/bPhbPvRs6gKRx7T3WlexdzGR2IR9A1t+EG24dcOLQcX1a9QiijX+f/ItEgCVcLa2WlN9xjjcH98InlLSbUc2rfQziuUojQeyl1c6FmjcOBGg5upE1sHsKJ1LCXjFA4h57R19kbwEWTeGr3YiuKif/ZnDswdLKZ+f+keUwx3sdcTyYKRVhOGkpjBK2wm3HgH+r5/JTrWf3YKzp7BzmT/1RjYxYw8ipU3vIF94I+n/8KtOtGbE
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 14:09:44.7531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fff88c87-ef4e-46f1-d491-08def7b231fd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000094.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9713
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D0BE1C0012
X-Rspam-User: 
X-Stat-Signature: hcpqpe4jn59kr6qkq7xipy35yjz8pzpx
X-HE-Tag: 1786457394-719512
X-HE-Meta: U2FsdGVkX190skznKitC0Gnn8qMnfngApYH0Z24fc1gfj14QQLgEIPY7Jws1xS904uFP1WSdNAkdAddxkq2Ci9pwHJ7kxyYAeQooiu1rw1MxutSM1/lvlLoLua8zmzb2hTsZJAnf5IOaLL4BQJTsjlcNMoTDHBXl/3IX4m5gAEd4Z7kOGyJEdUGjU5XN8/LX43esp/cG8BQO+2l7c+Zhor8qF9CTe07KJnfY5Pm3nOYylHtNfgc8rCCVoftD3UrRuvQt0yjf5WnbGBIvc1CPWo/CyqMxuAIWCUkfBlRj3kdD3OLY1wr5bYlYuxw9Pf/4YBbViGfiEsKSxmVyOp6SucPVvdbIBH3wtF4CoJ66uDAIeRmmhFrW4hrrb+iOPThQ+wUuWU7hSpPtzTe/4JmRv4fVLPRpoVF84VXaOIlJ2MUNbkmSwAKeP3RhuF1705acbD249SY7BKIUe9PC7KvalXmgDCk30J9P71gd85YXqdtR92bqPb+iE+0qEJVDpBJg7Ar5oyGryOG1TI9FNULWnxVOS0AjtB0E3lohvLbkoQHvMHprEtV7cIF8BN+Em4VE3avE1jze5fmQGfNE+z6WXzQ+MDLEfm2yqKTHbKHHvXe0vBqWRHx8ksx2879w/d7WaT76zgXd5214xOjNMX3f5HgUXG+MoTlTFoZYY1RDiDG+bnK1h0x6wKw2lJ0BGiMhwe8ywvV1UlFgicXSY4A1W1hOaZ/vg4coyckte3krJfUjTXUtfc0pyYz314B4Ih5ieV/UHLIAFfE4rOrNF01iAdDHx8P2RHg4soHfnl4kqtK6wCTc5iHF6AHAZEGJXRbbmeQ8z/JBrf3ixAUolzRnzMBKIEVhhRKHb7OUc5I7cnyTgA/BlymQxd9W6s92KzI+PH7zQ5cDg8udB3Js8sgchkI8qiKfdxrh6Aq0ek5j0H+8tQib8r6i25KyGeqOkyIJYAY4OYI2XZDpGHBSx+B
 mwOLfj0f
 6Zvjt5+A3W7ZaVmhM33em73kaRhUCXVdxRaRqxAg6a4Leu4g9ryOR4y8vEH9DZE7wv6UPj1yqEW+NZSSZDnHpqmN+mdnVNEpJlxcnD7/rvdiBIrqoK6PpubD3Eqe96jvXL+ZmUXQlGDZB9pYjRxykXayzAAUQq3shFEbWV4TKXMckkrTbs5MHTfh+SbYWAGdB73x1vrG3fJ6SwPhnckq1WeG5dfW1Ebx4+DjzSbMIm0pk8LIFWArseK6xqB/dW/in5YgwzDiDTy2Wyw0pEE3/exMrk3RAcKsya9+HgOFHx7vXY9l5uodUXF9PFYoKj5otJSQMcF1ikJsLtxWaKiCIIwUs8y1e1Nydg2wCjYaE9jPeqH26PQPx8uRQaEZTTMwQqa6o2EWHhbPmTFycpIM8GRBwt9x4euw51rmIsju5403RLWuRMeWUHK+M91fqeGBsM7deyDhtAuHjwyQYvGN3rWaLNCjL9aNLav1oxuWWdFqLVpT5Imy1w24W8tNo6k2bu24Rirb9hh1EPviyo4sutE7TP93T7+w0fzMPl5OuX5fUMSCY1F3Z7+TD8lAJJiYXs8ieM/I9M3d4EsbB4kY38MDlsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/08/2026 11:58 am, Anshuman Khandual wrote:
> Subject line is very confusing. Perhaps something like the following.
> 
> mm: Rename pointers to copied PTE values as ptentp
> 
> But even 'copied PTE values' is not very clear as well.

Something like:

mm: rename pointers to logical PTE values as ptentp

or

mm: rename pointers to software PTE values as ptentp

> 
> On Thu, Aug 06, 2026 at 09:38:41AM +0100, Muhammad Usama Anjum wrote:
>> The hw_pte_t conversion must retain pte_t * for pointers to standalone PTE
> 
> We need to explain what is `standalone PTE values` first.
> 
>> values. Name the value parameters ptentp in the install_pte callback,
>> write_protect_page(), and guard_install_set_pte() so the later mechanical
>> conversion can distinguish them from pointers to PTE table storage.
>>
>> Some functions already use the ptentp name, including:
>> - madvise_folio_pte_batch()
>> - folio_pte_batch_flags()
>> No need to convert them.
>>
>> This is a naming-only change.
> 
> Small nit - s/naming-only/rename

I'll fix it.

> 
> The commit message needs rewrite clearly explaining the following details
> 
> - What are standalone PTE values
Logical/software PTE is correct and better name here.

> - How these are different from HW pgtable pointers
> - Change is just a rename for pointers into such 'standalone PTE'
> - These renamed 'ptentp' here would be used for skip or replaced during
>   upcoming mechanical change via a script
> - No functional changes intended
I'll update message in more elaborate way.

> 
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since RFC v1:
>> - Update the description for the architecture opt-in conversion.
>> ---
>>  include/linux/pagewalk.h | 2 +-
>>  mm/ksm.c                 | 4 ++--
>>  mm/madvise.c             | 4 ++--
>>  3 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
>> index b41d7265c01bc..c34d826c5e4a2 100644
>> --- a/include/linux/pagewalk.h
>> +++ b/include/linux/pagewalk.h
>> @@ -89,7 +89,7 @@ struct mm_walk_ops {
>>  		       struct mm_walk *walk);
>>  	void (*post_vma)(struct mm_walk *walk);
>>  	int (*install_pte)(unsigned long addr, unsigned long next,
>> -			   pte_t *ptep, struct mm_walk *walk);
>> +			   pte_t *ptentp, struct mm_walk *walk);
>>  	enum page_walk_lock walk_lock;
>>  };
>>  
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index ad05d7791307e..11d50518d02e9 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -1292,7 +1292,7 @@ static u32 calc_checksum(struct page *page)
>>  }
>>  
>>  static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
>> -			      pte_t *orig_pte)
>> +			      pte_t *ptentp)
>>  {
>>  	struct mm_struct *mm = vma->vm_mm;
>>  	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, 0, 0);
>> @@ -1371,7 +1371,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
>>  
>>  		set_pte_at(mm, pvmw.address, pvmw.pte, entry);
>>  	}
>> -	*orig_pte = entry;
>> +	*ptentp = entry;
>>  	err = 0;
>>  
>>  out_unlock:
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index 07a21ca31bad4..c324cc991f841 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -1101,12 +1101,12 @@ static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
>>  }
>>  
>>  static int guard_install_set_pte(unsigned long addr, unsigned long next,
>> -				 pte_t *ptep, struct mm_walk *walk)
>> +				 pte_t *ptentp, struct mm_walk *walk)
>>  {
>>  	unsigned long *nr_pages = (unsigned long *)walk->private;
>>  
>>  	/* Simply install a PTE marker, this causes segfault on access. */
>> -	*ptep = make_pte_marker(PTE_MARKER_GUARD);
>> +	*ptentp = make_pte_marker(PTE_MARKER_GUARD);
>>  	(*nr_pages)++;
>>  
>>  	return 0;
>> -- 
>> 2.47.3
>>
> 
> How did we ensure that the above changes are comprehensive and nothing
> else got left in here ?

The order of patches and even the code was found out after adding hw_pte_t
structure. Then everything was converted, until some pte_t pointers were left
which didn't require conversion.

If something is left, we'll get build errors when we build a converted architecture.
So the branch mentioned in the cover letter when built, would produce build errors.
(Those patches would be sent separately, after finalization of this series).

Whenever I'm rebasing (on mm-new), I'm rerunning Coccinelle script to see if new code
has arrived which requires conversion or renaming.

-- 
Thanks,
Usama


