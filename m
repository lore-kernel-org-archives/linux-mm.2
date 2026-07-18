Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E41CDC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 02:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B8F6B00B1; Fri, 17 Jul 2026 22:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2CA66B00B2; Fri, 17 Jul 2026 22:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A67C6B00B3; Fri, 17 Jul 2026 22:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 528106B00B1
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:54:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF851C02B7
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:54:40 +0000 (UTC)
X-FDA: 85000379520.25.888B745
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011024.outbound.protection.outlook.com [52.101.57.24])
	by imf08.hostedemail.com (Postfix) with ESMTP id DA9E8160004
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:54:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jwQwqVSn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784343278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gfg9Y2+1xjXi8rFICR7TSKEFbAGVEnvaR8I5Gv9ln6w=;
	b=xYEcRO0ZmcCHbgPq6f4al9b7iXkw7sdkpgaXlxhgJoghVCi+IoHOcbnxIDsAaZhDK3tAU5
	gCt61o93aVc0fnrKsGicSSh/uYrvfkghvcbYKSbBxmN0iGCq3K4HDkW1c1gTaC1ciwNm87
	tVYpsDpeon52li9ugyjCn0qgxWslLW0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jwQwqVSn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784343278;
	b=bYkys8hN2fq52XOcyhh8QQWYNM32YEZo9Mhf1YCgA1p64Qcqq4JENwXUwUWJxEK9rEiq11
	xAnVuAsHSAxWgzolnZ3JtG4x1fj9jW7RQZPo8XDjw+o9doz9Wrwk7USxtl/YQ19M3dIrma
	xZz6c8lsRRt0nXh717p3N/8jmvR7vVQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G5DXs269JorjC98V4UeSzm+PsURutrGQ6dazv8uh/xdFxtDbFEzkbi7SvoEUq6Vd9KGrS9CEtoS4b/h6r1v3S0u63A+eP5++aNFazYEs2ExAHaJjXyG5ufCtUxg13PG9EPxtU4DnUs8LElsbJzlVi38rFB3BWzP7xT2fn3qfagTXyIJ3KM6NNVGw/KuofrpnqNOa3ySJCNFKXjVhoHi7+yvXHJ9P4o0JhCBCJyeueL7Y8IHg33JvIk/3sPJjCIsklZdoEeDIQ+vUtpLcphebruc+2rKd0VHxVMpPEvxOL3WD60mbL6GbR3PQK++WQbKlXk70jFtKlaoqIt0LtKPVDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfg9Y2+1xjXi8rFICR7TSKEFbAGVEnvaR8I5Gv9ln6w=;
 b=H0DdHrMaJWVU//HqybUElEPEj3B76wmPYZcx0SeRzza6yAUE8MsMic3sUClX30MIgvN8h+KNqEvGNCg7sT4HBX0olORmSANZwmcHj05mdv6dAEn+tdjHi0UvT/REcdGETFR9TY2hFHDzvE/YZQOUM1AwD9Tdk9dvohYzgkpXW5NiqBEitgtEOplvp+Z8Pdhl7pk4navoQnQ8SZFy1ZYk22Z+vaK+zW/9GNrK29C5yRxJo2/m6PO2OvtLgr7dYiMaPxrOOGn3yj1t/0oaBokbjSxZut7k86j+ZCk1B7XW+WieaBtdu5UkvTWarKcsTOJEcUO0jEXSd6hdlS7jYZPbGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfg9Y2+1xjXi8rFICR7TSKEFbAGVEnvaR8I5Gv9ln6w=;
 b=jwQwqVSnOmC9JLVVAFBq4GF5pFQvwdLfcIrbehbL5ITnlmCzZIvnvprns8695WkovkR8/+CtOtzm78h4T6LI1h7H26GfZnqqjUhDa0sdrB9s9hOLuPsZA1z1F8PUF/n7UEosVmyqlprW1ijx64XpuDBiOeIkBZed6gnPKQXe9m7hVp7NdPdG8rhUD5EhuvxNy/t76Xmh2JsA48bQtjGfVQ/hpyKHV8VMahnaQWP9qOC6ptXCBb6Yp5iVfRpy6zyo69+l37vhJZlHnErJ2iw6cCVErkVanWpbX6vMQy0yy77sv+ttykNxTAD3oMcs1rHAuA0rWr74wrydXMJXUpaS+A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB6885.namprd12.prod.outlook.com (2603:10b6:806:263::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Sat, 18 Jul
 2026 02:54:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:54:27 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:54:24 -0400
Message-Id: <DK1CWBDK5J60.3VPRP45IS7L7E@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 08/33] mm/rmap: rename vma_interval_tree_*() to
 mapping_rmap_tree_*()
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
 <damon@lists.linux.dev>, <iommu@lists.linux.dev>,
 <kasan-dev@googlegroups.com>, <linux-sgx@vger.kernel.org>,
 <etnaviv@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
 <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
 <linux-tegra@vger.kernel.org>, <kvm@vger.kernel.org>, "Russell King"
 <linux+etnaviv@armlinux.org.uk>
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Rik van Riel"
 <riel@surriel.com>, "Harry Yoo" <harry@kernel.org>, "Jann Horn"
 <jannh@google.com>, "Lance Yang" <lance.yang@linux.dev>, "Pedro Falcato"
 <pfalcato@suse.de>, "Russell King" <linux@armlinux.org.uk>, "Dinh Nguyen"
 <dinguyen@kernel.org>, "Simon Schuster"
 <schuster.simon@siemens-energy.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Helge Deller" <deller@gmx.de>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Dan Williams"
 <djbw@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Oleg Nesterov" <oleg@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>, "Namhyung Kim"
 <namhyung@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, "Jiri Olsa"
 <jolsa@kernel.org>, "Ian Rogers" <irogers@google.com>, "Adrian Hunter"
 <adrian.hunter@intel.com>, "James Clark" <james.clark@linaro.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Nico Pache" <npache@redhat.com>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Miaohe Lin" <linmiaohe@huawei.com>,
 "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Xu Xin"
 <xu.xin16@zte.com.cn>, "Chengming Zhou" <chengming.zhou@linux.dev>, "SJ
 Park" <sj@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul
 Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hugh Dickins" <hughd@google.com>, "Peter Xu" <peterx@redhat.com>, "Kees
 Cook" <kees@kernel.org>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
 "Robin Murphy" <robin.murphy@arm.com>, "Andrey Konovalov"
 <andreyknvl@gmail.com>, "Alexander Potapenko" <glider@google.com>, "Dmitry
 Vyukov" <dvyukov@google.com>, "Steven Rostedt" <rostedt@goodmis.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Jarkko Sakkinen"
 <jarkko@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Borislav Petkov" <bp@alien8.de>,
 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Ian Abbott"
 <abbotti@mev.co.uk>, "H Hartley Sweeten" <hsweeten@visionengravers.com>,
 "Lucas Stach" <l.stach@pengutronix.de>, "Christian Gmeiner"
 <christian.gmeiner@gmail.com>, "David Airlie" <airlied@gmail.com>, "Simona
 Vetter" <simona@ffwll.ch>, "Patrik Jakobsson"
 <patrik.r.jakobsson@gmail.com>, "Maarten Lankhorst"
 <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>, "Rob Clark"
 <robin.clark@oss.qualcomm.com>, "Dmitry Baryshkov" <lumag@kernel.org>,
 "Abhinav Kumar" <abhinav.kumar@linux.dev>, "Jessica Zhang"
 <jesszhan0024@gmail.com>, "Sean Paul" <sean@poorly.run>, "Marijn Suijten"
 <marijn.suijten@somainline.org>, "Tomi Valkeinen"
 <tomi.valkeinen@ideasonboard.com>, "Thierry Reding"
 <thierry.reding@kernel.org>, "Mikko Perttunen" <mperttunen@nvidia.com>,
 "Jonathan Hunter" <jonathanh@nvidia.com>, "Christian Koenig"
 <christian.koenig@amd.com>, "Huang Rui" <ray.huang@amd.com>, "Matthew Auld"
 <matthew.auld@intel.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Yishai Hadas"
 <yishaih@nvidia.com>, "Shameer Kolothum" <skolothumtho@nvidia.com>, "Kevin
 Tian" <kevin.tian@intel.com>, "Ankit Agrawal" <ankita@nvidia.com>, "Alex
 Williamson" <alex@shazbot.org>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>
X-Mailer: aerc 0.21.0
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-8-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-8-2a5aa403d977@kernel.org>
X-ClientProxiedBy: BL1P222CA0006.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB6885:EE_
X-MS-Office365-Filtering-Correlation-Id: be49dae8-ffc0-4301-4626-08dee477e194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|11063799006|4143699003|18002099003|22082099003|56012099006|6133799003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	DooPcwc1JSQj4oKqoxDo1pCT53j0Hp62PSlv5DY8tSnHHAH8X3i8auNQMO+NmwFNR2XVl97YYMAZc/IfsljNAGvKMworUN7itOJzrsYFW3zKtBMpXsZMOUA2zSYGcYmsMjaA0m4Qq3fJpA7UNjIX5yXAuG9kbxxXNtfmGSn01tLRipdOpmiWhoIGTyxTBxOFkCNW9M0XRpOPVewZafV6OYmbDI62NRHGmTHBsvCn8S0eebAFqjVKH4isrz8ACRFvLe1MxciPOe5+WiApxfTcf7gH9MHvnaQL0yiO1MEz2ZDMGqoWqfkhYeUJgnG5Csd1NIQkQzz4fqLtZhaRqFF9rAg9/uIym9ENQkbTzFo5P7ctMtzvBv294ncI3N54wAYKaANnmZb/FUmJUlLl3BgRloXmqNsB7GT8qOQbOJZ3IpsFonR9719xOQe/HJqEc9HP6MHuyVVN5szq6WJsiNZIVHQCVyBqCFLnAQrfNJ86jQbIg5Sx172fmCX9OvfJckVHQN/R0C62jkPYVrEvNUdSbE7RCscwrmlS7vglVVV/AvZ4SGUmqFSChMcMaSvnDQs5mhnzJddvWtg1VgoW5eUfHG9sUAC4hCDmLzER+FK7SZip1NiR0WnE5RDFSqh8Pc6QWiDe8di2DRoq5t2QhOz9ojUNB4fxXLfO2w3zdi5PTYHQFUL+8IDNRwINGWUXiA7+HnqN4vD9L2At8ksMeWbFyQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(11063799006)(4143699003)(18002099003)(22082099003)(56012099006)(6133799003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REdMRVdHT3RnZXo0ZFBZamNQUGJ1QzNlUExHQ1REc1RCKzU5akQvTUtUVE1a?=
 =?utf-8?B?U2lQWlB4dWdLOUpNbzJ2T3IxNW5tVXl3dEpBdkhKWEpxMzZmd0JEbWg0Nmdh?=
 =?utf-8?B?Y2RDdktORGgrMzVLVW02R3ZXdTc3bFdqWGNhcDdLZnMySk1ZV3VNQ1Q0ZDho?=
 =?utf-8?B?aERnSWd4eTRTUzBnLy9saTRZRWRsSE50dUFGTSs2L3Z5YXJmQ0hOUEtlcm9m?=
 =?utf-8?B?ODllTUtuVUlRNGJ5OTQ2VkpnVXJUSWY2UkM2TGF0L1F6dS95TnJ3L2pjdEwx?=
 =?utf-8?B?WjM0cnJlQzM5Wnk1b2xBTTRuQXdQZ0tsanp6SVNMQXFuL2t3RDRURmRwTUtC?=
 =?utf-8?B?SE1ucEdmS2tEQjVVMTRLaGtvR3pkQW1sRlhQdzlLbVdRV3luWVhDaUtSV2Rs?=
 =?utf-8?B?NlVSY2NUcnM2TGdtQ2Y2Y1lWa3dnWStQQUhabjZubHFpS2d5SWgyc3JWays1?=
 =?utf-8?B?Ykg3aEJreXhGdFZoamVubDd2Wm1ra1RXZzNHVkx1OEVPT0Z5NFhQa0lxRmZV?=
 =?utf-8?B?WXFua0E4MWJPbmxyQkpMa3BDUXN6N2FjNDQ3TWR2QTdXU1Z0aFBwaEJXaUlw?=
 =?utf-8?B?MmNVb05yZ3p3WHd4VE1IME1Mem5xeDdnazF2cWZZQVBCd1M3SzlQYk1ha0FT?=
 =?utf-8?B?N1IvZlUyTVh0REg5cDJKMVd3dGdVQTM5T3I3dWNZeHozVDFOR1FzbjJmUlR4?=
 =?utf-8?B?bCtqd0oxUDdTdzdlcU5kTWNjaXZHMWNLaHN3dUUxajlITGpmV2xUVTJDdnpi?=
 =?utf-8?B?VzVQcU5GSVV6Z0JxcGR0bW9VTWdjRWZkV1NHb0htSlM2eU1Cdll5aVVRaXhz?=
 =?utf-8?B?SHl1UDZMOU03SjJaZHdQZG1nY3hPM3hyRGZuOU9iSGVpZmhpN3hDVjR6ZjJj?=
 =?utf-8?B?aTQ3dVVGQngvK0hoaWNCelcyeHBmRUR0d3gydmZrb25VNmVzbzh1MG03ZnFC?=
 =?utf-8?B?MEhiUmRQT3BVclZwVk1WNVlUK0Yxc2cxWjFMaldqYVozU09JQkt2M2dTbzhz?=
 =?utf-8?B?RWZGUFVyOUM5b0J1MmRBZFpubVJSaFl5a3ZwRFR6Q1NTQlNNWXpFSnRxL01Z?=
 =?utf-8?B?UEZ6cjY1cytVWUlyN3o5VHc4UTQ5djBUNE1XT1dOVllNNHY4UjVuQkhYM1hZ?=
 =?utf-8?B?TVA5MHQ1UVowMmhKT1I1TUlXYVNkWEhTUEx0ZHg1cmYrZnFtR01YOUZCeDFP?=
 =?utf-8?B?MGMrNUQ3V1crTWxreis2ZURZYlJYOTlhbDhtQWh0WEVVOCtwd053SUlrVjlT?=
 =?utf-8?B?YkZzTlQwM1dQZGZnd0tWZUdUUjJSSm5ST1lLcjlIelV2QVlFcml4MVVwTGhT?=
 =?utf-8?B?NWErYVNOaXhSeENDd2tEb0hkVHRBM1pHZHJTa0NkOUNJM0laRmVXdVkrUlpu?=
 =?utf-8?B?cC9ka1B4UDVWdU96ZnNPZDVtbXlWMzUrazVPZ2o2c1phbVlvR1pDMHd0bWEr?=
 =?utf-8?B?ODJZSXozdmdRSkhENng4Sk1hek5Md3JhRE1EcTBBZXZ1bDN1Q2ZOMjlYTHNa?=
 =?utf-8?B?UURTZHdlS2N0cjVzSSs1Q3F6RExoWkpOc3lDWlNxT05WdzVDRTVoOE5MbTJi?=
 =?utf-8?B?bUR0VjkzY1g3VzdIaEY5c3phcGorNmVoWkJQOFNrSHVrVGdQUm02eURiOFJl?=
 =?utf-8?B?QmZ2N1F4K3h1UUxnRUJtSlV0UUVoRzF6ZDkzTjB3azExK2RPMUZTWXJXSGIz?=
 =?utf-8?B?RTdJZDg1Qm1sVFVKcTQwZkNLcDlNVTFlSHdoVEdBYjh3dlFra0dtdlVJaHJH?=
 =?utf-8?B?MSs0SVRGaGpYd3c3Tm82VHdBazhhbGdicVdETTh4bUVZZzdFZTByVXFtMHMr?=
 =?utf-8?B?ZDBrRjYvZUJ0UitMRjFvZjRkenVUUFNCMVVqOHdVcUlSMWZIRGc4MTNsV2tI?=
 =?utf-8?B?VTljQTJyQXBnakZoU0IwUndabUw2ckJxelJkNVRkeWx2WnhET3kyUXZkT2p2?=
 =?utf-8?B?V2JvR3J5TFVGQndWMXg5RnJ6WVJyZ3ZZZWR4ZjNaWWx5MnRCSGlQOWFIbGRy?=
 =?utf-8?B?dXhOYjNnK1JubXhydVRVSnNBSVNRREhVSVpHQVo3ZFplY0lPMUtqM2pZMnh3?=
 =?utf-8?B?MTZIS29EWlo2MktGWGZzYzFrRkZ6dGZ3b0J3c0JtQ042S00wQUdocDRUZjNS?=
 =?utf-8?B?dDlWTDdSS1ByV1hQczhPRllsTGpQVlROTEgyeER3QlFkQmxBYXFhcmNoa1ZU?=
 =?utf-8?B?eTFLbkJ4OThJM1hRT3Y3ZGZ5QUlXMnlHNDhTZW9Rd2JLQ1RYczFCenk4M1Qx?=
 =?utf-8?B?allYd3hFUzNUZHdraVNSZ3ZSbjl5RlBNQU5ISDcwVkU2YjRWcnR2eUZONWh4?=
 =?utf-8?Q?sobt12M8aSy51rITgs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be49dae8-ffc0-4301-4626-08dee477e194
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:54:27.1253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8dfY9OijGOs2OCgyvD1+K65HhqWtUSbLkNgHcE7QZnukbgQakI725JCZ5I93Fkn8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6885
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DA9E8160004
X-Stat-Signature: bdt4af1m1hr5yw56tpzw1qbsni4rctfm
X-Rspam-User: 
X-HE-Tag: 1784343277-685533
X-HE-Meta: U2FsdGVkX1+XF2ZZNjqrHSFhX9BAZgVAY59e2oeDlbScgrs2v+c5257BllrT4d9LQ7CNtJuWf11AXailZBuyVxMu3DsueU6cphECtvy1SckNzMt8hNODmeGgnPyJRtsypp60Ck1J4L6adYyZKRrOXV3B++lN0iQHVh1I11p1Uje8XolIIbygy6ovPtdhpjV23m2wI1CkRvx+oVpz7/jtlchIZyU+805QCNQ8oMd7JHYWks3u/+WOqbd90KqVYizlB+OihDrOVb68IpiCmrQfrbEo/N+SHWGivN3/9PDpnsMIXxGCfNzUVKXh1mIzDAJyi3cyiO7kVgIF5Q2gExXtic+FuPUkX2WimgmrP5G4aTV3DGkK11HwPS/+dCeisYZczZR5cJ44c6QAEVtsgXouW94ryIU8o6l5kCxVT/OJ9TYMuhjij2b6Uj2vQZ0E/4BLko0WqOtk0jnNMb6UJ4G6lqF4F78VVdSBgTvUw4atsU95Wf1pbWxhZq9ZMcGG7vUYd26RjH6Eot9eyV0HGmCOzHWJjnxgjVfQcnpOTkhm2DGKU1msFK69TA7JuokOomMJIxwuMY7c4Xc5VvOAfMQjPa9X5WMr0suIISk1u/BjO66ERDrCdnz6OWVscUhiaF1tHRHqHPDIGD2N0WGYgJxVZYlIIuvo+6u7K6YLUdCH0GCijxWHGhhobwwsV5v1XKGc71+FdxNULaMjJ/wMRWBQqgtSutyS+L41nLD2Z4+IRDu1hDpqMq1HrmRe3YALTLioqRcNNYgxziR+AdzRZQFQoL9PecMtLlV9m1vi/4XYLqMIO42PwC3LviU0Rqy3IqTPE6xHf/w7c4lOD8soECVEnsztOqSnl8oEAyrDuWbGKPfyYrlXvHX6he7xk8BpUEdbDtbL5Axbhbodbje+m0bfGzSyXFT7fYhz4SLNwC1wQs1iisxEiEsBntBbWvX8c4GKWqU0BGWsUPvFM826L9P
 rAIexAkz
 AwwbrbElFwU0bItkWyx01axZGhQdLLvebOyMakDxB7cfb9nwVxdWPfDhwgkgoS6PyiijjY0WckYlnV5Cl3iu4+F12QeiR8CYh4TRdVCu17IzHgSoH8iddDMqIrkS9478OYi4BvNcYqcfiMCl+u6EJ/F9kLG1nI0EV74k9eP4COVr6UcHOzu0378GyQ4Tr5/rmIRTXIsFqCwkmJcQ3CL73YPVQSJrNy5s8DqJ28qQPwR7yUMlfaGxPR91jRfD/7e99Cb18q0Sk4mH7/gQBsQjqR1pr1v0CsNYf73VPZHnJSlqhPANFB4VHDC0ImNkSRDfNsMaiVpJ2DLeWczNQLRxX1UqTUSFaOiCtKmnp0/nBlWfoIkvwbAMKD3UgjsUUOQdx3QICBvoETLFk1lZelXDPWCZ1wO4hpPTSDF5z1zwjK7HhXdBkTvmTQjWqlc144oxpANQ11VguKfEQhmo1Ni7TExF9sBhGA0qHnMAXpYQd6XQ/qJZuc3k/3tXCSgY8Ih2ZPhWf3Tp7wSUzhTxwRcE/GSUkmBidP/qigUHM3Rp/fyChqyjh+oDE2CXKT7xGNlSZL4DW+raerAKMeyhGmMh2kLb5GDQAUVUOPFGR5ztB3ozKQfpEHOvKPQooXkW3QlkeFsCsNtWdUJxoAPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> The family of vma_interval_tree_() functions manipulate the
> address_space (which, of course, is generally referred to as 'mapping')
> reverse mapping, but are named the 'VMA' interval tree.
>
> VMAs may be mapped by an anon_vma, an address_space, or both. Therefore
> calling the mapping interval tree a 'VMA' interval tree is rather
> confusing.
>
> This is also inconsistent with the anon_vma_interval_tree_*() functions
> which explicitly reference the rmap object to which they pertain.
>
> Rename the vma_interval_tree_*() functions to mapping_rmap_tree_*() to
> correct this.
>
> We will rename the anon rmap functions similarly in a subsequent patch.
>
> No functional change intended.
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  arch/arm/mm/fault-armv.c          |  2 +-
>  arch/arm/mm/flush.c               |  2 +-
>  arch/nios2/mm/cacheflush.c        |  2 +-
>  arch/parisc/kernel/cache.c        |  2 +-
>  fs/dax.c                          |  2 +-
>  fs/hugetlbfs/inode.c              |  4 ++--
>  include/linux/mm.h                | 16 ++++++++--------
>  kernel/events/uprobes.c           |  2 +-
>  mm/hugetlb.c                      |  4 ++--
>  mm/interval_tree.c                | 22 +++++++++++-----------
>  mm/khugepaged.c                   |  4 ++--
>  mm/memory-failure.c               |  6 +++---
>  mm/memory.c                       |  2 +-
>  mm/mmap.c                         |  2 +-
>  mm/nommu.c                        |  8 ++++----
>  mm/pagewalk.c                     |  2 +-
>  mm/rmap.c                         |  2 +-
>  mm/vma.c                          | 12 ++++++------
>  tools/testing/vma/include/stubs.h |  4 ++--
>  19 files changed, 50 insertions(+), 50 deletions(-)
>

Just curious, why not file_rmap_tree_*()?

One nice part of this renaming is that the length of each function does
not chagne. That makes the patch easy to review.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


