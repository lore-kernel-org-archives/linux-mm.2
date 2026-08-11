Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E68AC5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2716B0093; Tue, 11 Aug 2026 07:28:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273596B00A5; Tue, 11 Aug 2026 07:28:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B156B00A6; Tue, 11 Aug 2026 07:28:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E23E16B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:28:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74AAE1603E0
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:28:16 +0000 (UTC)
X-FDA: 85088764992.21.2DB49F8
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010031.outbound.protection.outlook.com [52.101.69.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8478420004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:28:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZUpGE89U;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZUpGE89U;
	spf=pass (imf31.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.69.31 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786447692;
	b=ZcABFmfBAr44Y0YNW+Bh6h7OhHL81MiBB3FJ9eeDX6bfjKQdeYROZMlAr6UxknDgr+N5yO
	8E75VLueRCvXJUpbHO2+GW9CEqibX4ZfrQIErizbhR+theURyy7pFIa1jt/O0VAKpXHbcN
	xuJ4WBHUEh02avetRWngxgUz0f8zEkA=
ARC-Authentication-Results: i=3;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZUpGE89U;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZUpGE89U;
	spf=pass (imf31.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.69.31 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786447692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJvqjQtYhPn+5rlwiCulIyzL4lgkY2x9AtSglnQ/lYY=;
	b=3tSkfSGd7usEV9VVu5eNV3OwLU4G5JXVwfePHgwrzVtGQectAA2QCLTWZcB51B0Rt3icns
	xUS1blnI85hiqBxq/H0ufh4WW8tu+pL2Q7BERzP+5mGG+x5r8EeoUhxchMkb43ljHkS0rm
	BhbCcv/WM2acSkyBq8EqZUa57wgbXcc=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qoS21m4gqpl2A6mSYODK138AgZwscC6N6PBwKh0DY+U4/TY/d+9O22I+jnT6RZQ1qRmAbHotdmjz24h5HLuMHt2xruX853hADfuN6vM3ogka7+wik6xxKKcTFwHu7PtzYakC6Myv0tXrUbbdk1QdAOhE/6C3RCxk18Z5okURGuqvdXeUhwSCteSgY/PFWRSf/ibAUzhFYrFJFUzMdZYOsC5p7ihZV6k89/8jsGVt5koH2dtKgIS6T9ydUNiqRKgiv/tuhR+Wwz6RUfw8Tgf4hhzLqCY+dDo+bvZwodjNnzpyNCFt70WuLC6WYUXgkPGwTinVi6xnlV43aTLXM4CJzw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJvqjQtYhPn+5rlwiCulIyzL4lgkY2x9AtSglnQ/lYY=;
 b=QVqwLDL6dU8ENykUrSBX3azgWcaNBU6rqxz+4rZeM+oyBC8GK/x3lCMDcem5YrIRmulghNj6VZuwOTenlfLgwKxoRyvMvv4DcMLhMsYZysLvJ+bXVj/umUVRJ+GXV6RG9+cyZPlmF7smr3sIzUdtipk3EJEAjvh/cCSxy4yW9t6nm4GaD3LzSwVuTpWgTr6IqF2QCAn2ay0QSAMvb6hWnHsdsYwC49R0ozqycBMAzPrkyb8zntGg9EL26TKTJ0RoaOp3AOtfQ7ZObsG5F01dT/jSmt/ufiJ25S0XpCnqXiFUiPX8vCaGjUlPl9KLA7lmU4xdE8T137K9YLQWtx7kyw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJvqjQtYhPn+5rlwiCulIyzL4lgkY2x9AtSglnQ/lYY=;
 b=ZUpGE89U93omH662/JXtCNc15E3velUKg/MY+8EtCB58awMrAJ55DvQpiyUbXmRWgGbeUbeaF1kB4Mf/vJIUzh9u5D1IYs0UbuSUkN9eR4mUz6yAUzJl+btZ4QsOeyW8mPHysbYosEhYL1r7OxUUxylALgW+wLqgDL+K2823ehs=
Received: from AM0PR10CA0002.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::12)
 by DBAPR08MB5591.eurprd08.prod.outlook.com (2603:10a6:10:1ae::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 11:28:02 +0000
Received: from AMS0EPF00000197.eurprd05.prod.outlook.com
 (2603:10a6:208:17c:cafe::1e) by AM0PR10CA0002.outlook.office365.com
 (2603:10a6:208:17c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Tue,
 11 Aug 2026 11:28:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000197.mail.protection.outlook.com (10.167.16.219) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Tue, 11 Aug 2026 11:28:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TtAUGRcJ6AWlPqIQMLOFqdpWYxlTC4E2nUnOT3chDTEIsmQcnbc7C4Y2sSB+uTDKwOvo2ZRT6Em8+BPrJnX7eXUTotZQn8/QVz2bJayIE79ffJW5RQRmoE9taCWO1CRXKXSMtue7nY/k7SBTekqwHh499iyRUbYpsQOFjkQrA0ckSpbIO9s0kAJ7nZE0iUrOiqvUKvT1dA3BtLcz5cjBQsNYUdJq+D9dJ9nsXo7du0pJvj30fC46fGjK2Fb0oDCav9SQ6O8F+n4Ny5fHFBYw4zeGzzIlme6w72w8fxAFJJS2I8DsZiwUGAxrBHih8QF8wD9eb0Gf3vg1RbgJMx1eYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJvqjQtYhPn+5rlwiCulIyzL4lgkY2x9AtSglnQ/lYY=;
 b=BUubzy05M5a0o/rrnDSXc2KdVNLdPVbJYF1vXwuI3/COJyE/qtHU44Dl3N54SOa/fu/35NVq+uVAGrPBVNXLVeUge3lOZz6SgrGkjDkjsf0CCohtaUm397MMHWHoKlzfgWUPT0NDVZ/OILkn8pomnIoZgwZ7XLrU1HMBt+mc3XClJEnNlKc2NFjlgVA2oaBTo1lN3Mup6A5NInGri1ekKwe78rvvGzamNFBrREnJ2nEKadoQ5NFB3sW9jYunsvp1SIMclM93siICuij+o1E10npQlj8GB80SeLV7W2OsvQivrs79f+K5bjWjAMnQrVdUTAr1zajM6lpYD7FbYq4NXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJvqjQtYhPn+5rlwiCulIyzL4lgkY2x9AtSglnQ/lYY=;
 b=ZUpGE89U93omH662/JXtCNc15E3velUKg/MY+8EtCB58awMrAJ55DvQpiyUbXmRWgGbeUbeaF1kB4Mf/vJIUzh9u5D1IYs0UbuSUkN9eR4mUz6yAUzJl+btZ4QsOeyW8mPHysbYosEhYL1r7OxUUxylALgW+wLqgDL+K2823ehs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AS8PR08MB7790.eurprd08.prod.outlook.com (2603:10a6:20b:527::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 11:27:27 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 11:27:27 +0000
Message-ID: <00e4f324-18b1-4120-bdd0-2715cb8c8481@arm.com>
Date: Tue, 11 Aug 2026 12:27:24 +0100
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
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 2/9] mm: make hw_pte_t visible to generic PTE interfaces
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 David Hildenbrand <david@kernel.org>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-3-usama.anjum@arm.com>
 <7xbai2nyu6nuyr6otqv556dnphpgwaqsmvwkqwoqwbh5nvj3ns@ddy5ezgvb7w3>
 <85286df7-363a-4671-bce8-8157ae5c8f02@arm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <85286df7-363a-4671-bce8-8157ae5c8f02@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0528.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::10) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AS8PR08MB7790:EE_|AMS0EPF00000197:EE_|DBAPR08MB5591:EE_
X-MS-Office365-Filtering-Correlation-Id: 844557b4-3d08-49e0-57de-08def79b9ace
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|11063799006|56012099006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 MTpsf3IvsMf7LVKWeyhvKaEhr96cF7yvH7aAkJB0bN7Dz2cNvpHXLH1fyHZGxfSN239QNIaI0+Jcok45W8o6dR4xsKN68cgbWwRp1dzQPww8VsZXlkd40hV+KhrcssadBi6n0BtjeK57do7GEQf9oFzJbDCKBGKEr/aV+5jAIFyIZeHeh5kMOB9Qrjk9lo8ssRQA+eChm6iIsXGtD+CSOW4NioxM8SGHVL3AteUAnM8e4g774whpKM+LAnfDDjcLSX4MFF9hSkCzLPofT/OqYQzv+EwMtqda4QQ3+eunavGYKJYsOeegTMveEFkeBGvj6JTMm/hOKqolApr0MUGBdr41GqT/ssdVZNPKYsYEt9xqPyShcC5PyLIgKCnX0v/tTebELHCxdk51b5+2EAOWhVI77v4UDPfelMHZNmq21/aREZCxR9W6n0o5k4YLX5a3uijZLV6UVlfpJNgZ3QuTO2Bc6BphO3IM+ARnj71zys1h3r+Kd1pb9EbS1Jq989xaLY051Ts6i4KRA6aMFZo9LueNV/CeTUhnbiREzQtnXolfLW9GvmLGkm7fnud0MoPESxMefIj4l0ubl/7OWFxpNp2b3IZPQBAFKTvfGCVWSb5hVvqbhexADPkBEFLs81yOY+RJW4pds8/DrhzuSgfKHQo42UznNPz83AM+zvWSmgA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(11063799006)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 hdQ7nn26YN7Vq0hE6oTx+kKoU45kJvqrMn0abldXFwKud0iJoW85VnYLUJpGpJvIJxgBFh5raADG36uRwV2AaPoefUNSSsVWUW5Y0zg8xQjIC+gS+uPl8TNSAFyKERlMdMsUi0xE67L6J47pXwlISmSbpRVwkLFrYG++90jViVROoUAQ0CjGmPthS/NBEXTu9BnqGOFLyjUMftDMlwsgCQzUj+8ciRZetLxOt7/pjNpvjEIqP4rEUksxKtNuI3nmtRimaXmtBqx+3z5zVXMWLYpAPEr4PTzqyXYAU22s9MqBWyN4hojABhxaeNE2vm0Mc7y2GYdrTtg6FpMnYERIRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7790
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	18d48398-875e-496f-3753-08def79b8605
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|14060799003|35042699022|36860700016|23010399003|22082099003|18002099003|11063799006|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	2EUmajtFjD2DNOQiqDYJhx/duHHhmL0owb4dTyfZ9bsnUL0uoX2XHDDcNEc8ffXH0yXFMc54S3eDdd3FK7Rgvf4oSdqjiuUijkmLVLhvYqiCS6p8fA/HIzvhi6DErNoUOFkJy4QHGrQyelLZh56K5hTOBUnG1R5SLFbyT4aPXHyPwsw8wUBIP9Y9rXgptG6nI/+P7u4RJRImjY27HbdHVXIJgwWS6rL/yVVXlDfZuS4eh/6+ZD5HHB9ucDqX4VFdjRdQxF8HJxek3eSNARe4FG/qKSh70eBDyPnSouR7KyaGJMR/2iMOrQaTK7DsGNaNX9Rm2OyL+30OXWY/2qczX+GyRC5rN9DAiEQhB3Nwo4lOeinyDhdoGapUIK+wGhd2NmJ7dikDhU/t+9ZF/O0XmDzmqlpA16nEikeqk4T9qWAuMIphpCWAnKhVQ0lg0uDbNpFs7KJXbDVsHyPCmrHptMgrtBPYXWY7zodgjZzIcSCYwgXWfLiBRhg6tbathu7RR3dFRTSo4E0WFqB9nQYl46Pyb4ttMR/EQ3BkRR83ob34C+egtvZWEdiZtbTCwt5jBuwjLoWW2cFDMx6CMCdAgWQz9boCtXX+LZNxDTVtT2tu7m0Y3zuKxbu+sK5MaVwhDmgDFOgKIqWUBggriZgqwdFaqZsSSnIl4BQlXlIEigG9yMV6bK1RxorlpjUUuOJJMGm8LrT2Y7fiutRFecm12w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(14060799003)(35042699022)(36860700016)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WyhUxGQhEoSVrTLtM6KTQBdls8wJsW8gVWLkbWdx6cT7Xk/GYLPsBmlh93x9ztJFgtKrG41K/BR325MTqhuTQWTOaCrXraK0rMkVwnxR47oSdh9fsdqsKI+B3VpHMqo4o/Hv/BDlEsUXshXASkbsuTmzu1uD1bz0cGpBPcmOfP+Iid0iyfWDi72D4I7Ue+JJkSYEQYbepcZRsEhuGUIVVkfPWqPOga74+qtzICPnzDmuWc7QVcFVVVv0fZsfk7ZGiKMz8epspjJVn9Q/22nE55LUCy6f3tDgfOUCAEc3sw7T0cSYCJK554b7Cfd0iG/qiST8q0ESTYex1eiK8/ENww5D0y1dJNo92UpI+ykfXr+eBR4Azp5L80JDcstN4cax67P2PQm3jW1TJPF8UYWxA82cG2ywWMYG/z97+a9N57pgyA+k9Yizy3VGl1dJjFYh
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 11:28:02.1748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 844557b4-3d08-49e0-57de-08def79b9ace
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5591
X-Rspamd-Queue-Id: 8478420004
X-Stat-Signature: ukdbpstnoy4psejm8p9rjch4wy6q6tmn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786447692-974549
X-HE-Meta: U2FsdGVkX18wn++ydybDCxYhgUnQ1ey6lSzKUW050S4TGOeNZm/k/JNW3PFAD4UsdWnDaJ2rXbxcW93Q/N9zY5J7hozbtnW3ychNAO4+5UrrF3kBmbB14hJrckioD1rV/e6ulAsNq8rV/mi6ffuSvF0AHDf8bXQYCSNoqnTKVHGStnqNS1JRr2vrVGt3lEluJAbHp3quRjlCZFXXoZ7YlRgKZqf6j2XAzUO5mUB9Phxpjb+8DtpSoxNsxoMYCjdf85/KNwc01k4lvUEqcsMVGvU5jC/qBaMZTc3KbLJR7h6Vzr38LnfMy2cx7AXRqSwJIt8wqpqHcQG8GJj+fJbtxo9/hsA6Ef9xNTKnL0d1BzHik7VGh6vBCeGbrpBN54Lukgv3KP+9Rv4Qlkmb5Ug8iTMm3A94tj+Rmvf1pxEtFyUW7OASDN/RI9Jndr5W7KlkmYmuCOvd0rmUncQsT7kLY2utTwWNA+P56/d9PoLdqHn4zljbo38HuMn1h5Pg0HEo8phbfHTFtEkgn6kFYxpuNbl/4tRpFP08GSPwV5EOt9iVn1PzZ/h1msuQz1rLXCnkPJ6xi9mKkjN5AFqPOukphvYsVpcYSFPPO/wlrLjl1eOTdDXT48ZjAnVzp4ocL74aODhrImbmWvj8mJY8S/QZK7dAVCIkM1l9WqLfxcs9P2Ge5P+X6G67MkvfmcsrsJOzSn3vp+bBzpQwr7/0J6KM/qsPKMKlIh+UtdyCiWzEoMoAgwLlZaiDYRT5+Z5KM1OF/JOY16C62HgFINGdkl26S1Xxnwm+yT9Cc27LqWJVXGTfKz93c/ZEKL/tnRsEq3SdhM6oWxntacMh04b+E8wjKyKC7GOmXhHMbSdVlxkIQTJ4rYYznkcpoYvTUnvGGclhg4+UuIrK31mZ5IWJ7+HYq4HcbNcTS/0Hv5z4Gt4znQxnAMNqMMgz8OeHlyUmvrTceuCDhOHGWjU7Si4KOG6
 1Ijmsizx
 tzYVIus3OGakNuv6QWxsdHn1klZK0MDBnp0KtZ7FR2uBzM+QtErP9+kqH0WBl4WL9qWY6jLvmuPL6xE2ui4IITqn4tdeIB2i1bIDbQ+ad3uRCVw4DLq9FhIDS0iiEuWywkWZzZmRtbz5aTLzky2WQNCpByVhwI+wQDMWP8LuqG+DxglwS42CbrDinNCDb1fMIRuYro/JPLDq4uJQp5rJfEwY0uqyPLXJ9iuTVBQWQ0p0Zr2QGnhDFNahXbtwdszJHmDiltRX1U4zlUClASmzzjjWkJzPrAghbWGoxsCUmxIn6MKniQslcWtHd97baWzSTEagbnv8GqIfp+5mKL/VaybhRUjic5mzmw/X+CDtGIPlRt4NFVcPxsMepyX8hJnVQMmpyPKuXK1+F1Sle/OGqdM3YIsNWss3Ylxc/bFELE8lZh7ZKBX7tKmL0DqOjmWRIQ5EBh67COgXD+Ji2vjRWaKXNLkkZah/O7/X60awYd0ljH2pGHSIRTKOQMebAYa1l16Py40ImccmB3TIZwu3YsxfWM5FobwhB21mXLeUdg2HrPotgEPLQdtUwH9kB8uYZA9Ob
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/08/2026 12:25 pm, Muhammad Usama Anjum wrote:
> On 11/08/2026 11:15 am, Anshuman Khandual wrote:
>> On Thu, Aug 06, 2026 at 09:38:40AM +0100, Muhammad Usama Anjum wrote:
>>> Later conversions use hw_pte_t in page-table checking, generic page-table
>>> helpers, and vmalloc interfaces. Include linux/pgtable_types.h from the
>>> headers that declare those interfaces before changing their types.
>>>
>>> For vmalloc.h, replace the direct asm/page.h include with
>>> linux/pgtable_types.h. The latter includes asm/page.h, so pgprot_t remains
>>> available. It also provides either the default alias or the opted-in
>>> hw_pte_t wrapper.
>>
>> Stand-alone header file updates are not ideal. Why cannot these changes be
>> folded in, where hw_pte_t gets used first time ever in the above mentioned
>> places.
> That's correct. This patch should be merged with the 3/9 patch. But that patch
> is already too much big as it was generated with the help of Coccinelle. So I
> kept it separate.
> 
> Do you still think we should merge it as its a special case?

Sorry, I wanted to mention merging this patch and 4/9 patch (instead of 3/9 patch) in
my previous email.

 
Thanks,
Usama


