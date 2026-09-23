Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB4F1C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25406B0093; Wed, 23 Sep 2026 09:45:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC906B0095; Wed, 23 Sep 2026 09:45:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5196B0096; Wed, 23 Sep 2026 09:45:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7456F6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:45:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0542916080E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:45:41 +0000 (UTC)
X-FDA: 85245149682.16.D4F9BDC
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013062.outbound.protection.outlook.com [52.101.72.62])
	by imf30.hostedemail.com (Postfix) with ESMTP id A13868000B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:45:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NImLnI7m;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NImLnI7m;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf30.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.72.62 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790171137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DNv2PlrEALCBnLQsldXodP/zMuSTmALFTUFz//S+1bg=;
	b=tdw0HBWzhcGlmmsUg0I2gBelyZgyvTXJXfiXQObTZT2+qD+Ih3jNduLsUbotooMQ7CKvAm
	OfL0L0AmGYzIIpRloMeaK1RLRDMXbgb7IKI4D0YXN9ax9LW+HyS5GOeN+MTyom1JViefid
	tc7xZBr+Sq164Nx12GRa8LA27bNo8ic=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NImLnI7m;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NImLnI7m;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf30.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.72.62 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790171137;
	b=lgOwF3T3t23L+hC6PJ65jFxOcQtAOMVAiu9Vjy0SPiPfQ6y331/3iNipIymQDRQZk3zYre
	1CYjAr27HWaz1RxWO2Q90ktrDkfIw9U91WOtHSIvCgJMoSTiRzK0eAieNDtAnbTokf7Ohs
	b81kin61QHILeuKGuMwzuAdTwqAeBgI=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kzgdyTvKhhlePou3DYFmQlpI5GOSzMn/Xu8SPWCfg9vBVRFGQxid03K7ciG8NmY8+tUz+MYLtzcfk5D18Id9hqehjMiEPKwRi4yLASAy966ElR1Zy2BQTOv+P4ZfMLm7a4UNEEtyLxYIrvnY9JnInoJT3zNAQF/0ZX0/FENlReHD7C8IHtljH4UnDa/2wMFm4DtvRNOu1Huanv7AjveJ7HD6wiyyCSbgNXj8vMwIvhCbdg9WZax2rBTaYZ2W9P0HG3ng8IkuPfEWDOhgMf5PvD7LJLigPrtdTViHZ72d2ePWYWvN/I7DQ1EUaMes1fCFrQNJqJohqP70YjAhJrNXnQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNv2PlrEALCBnLQsldXodP/zMuSTmALFTUFz//S+1bg=;
 b=xk35mhgC24gyWrvj5H9IV/yYQucGtvPOamJCQUxofy/lghRCucN0uyKWjgXhxzCvxeAiUfAwgZrxla+lXyF6mhN+QPNOvV9R6IMBTvqw0cq7bTdEtUYQv67/843h+eTNrvFASsfK2viClttBuM4exPxf80ou0h7U0s50rbYn1gUKO9HcNY01KvJilmQbsKXEMyVr+T1x279vfYHXlX9aMpGCGTNr6dTFuvbaPwpqFTZuFKXYs6WBy+bRxZAAJfIyZCJt/Cw6QIAucFlvJ1lqorhM6x7DMbi80kgyGT9ZA9qYEwhk8DRm/p+0e0bX28b4K056BkMg3Kj9IGiL7UGmpw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNv2PlrEALCBnLQsldXodP/zMuSTmALFTUFz//S+1bg=;
 b=NImLnI7mPzOCS5h75myRD6dJrhYj/Y8pb61WWlfOk08FUtxHCscx3oDJn5egO5woT658xGiB2tOEbTMVbcbi6ph3mDDYiA2qjvSuNRYRzRqdfIE9qlC+/cqGsnimcLLVDcNeCm5QDg8C8Ok0X4+2H9Cqc6asgus/twsBLTaTJfY=
Received: from WA2PEPF000008A3.POLP291.PROD.OUTLOOK.COM (2603:10a6:1d8::654)
 by DBBPR08MB10531.eurprd08.prod.outlook.com (2603:10a6:10:53d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.4; Wed, 23 Sep
 2026 13:45:24 +0000
Received: from WA1PEPF00009B3A.eurprd05.prod.outlook.com (2603:10a6:1d8::118)
 by WA2PEPF000008A3.outlook.office365.com (2603:10a6:1d8::654) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12
 via Frontend Transport; Wed, 23 Sep 2026 13:45:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 WA1PEPF00009B3A.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Wed, 23 Sep 2026 13:45:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFc6tbN+DqR9bAcOpUhd5U6M7Q7RUV9BGGK3m1uDUl3G88awk3wbZkIUMEtEVoD5b+mpJyuYo4ThkzM/O18vTTB2yH05diNCUoxnCR6PzAd6zAe6sjujqVwqzbLfZSpBRmlaX7XN01mX1sFF/PCDrFtVgNxTVhkksyzKFJAoKXVc2dLQz68cI5czXADet2kHxLdB0RwAG8A4JIKNQ22vh7cJvtgaTzMm9J2BDX0LuHqFJpDmHmOlRw4vxjbTQQ8HW+FeNjRs/2kTIFFnnNEkCK8JjpAY43grjKB/1vVBkqsJP82tRXL+D3n54rr3SLW5UcaLzAtBE6p5ZI1m7B8buw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNv2PlrEALCBnLQsldXodP/zMuSTmALFTUFz//S+1bg=;
 b=jNWSZAnXa1NBr9IVjgjsys9yhz7wZLeNTqADBkYdUvhNe6TsU0eG2px/iArkOYQ21o00f5SprqHsrUhgh/eG476Y9d73VAjX9Arqk7Sn1xVij1xQIbJ9Gc/isTRqDMBmtJxYT/h52ecJqhaIJw5lUqsBdyVWKgz0zfTPa7ceo+tOcwIduGe+GNYblhw83oko/QCqSMDHxhyH78pUhd4+GtCloSsUbMkr1b030fIdCDunGTloje1Oy+t7fof+sPsDg8ytEukVESEYbEFtLBJlJuy3TZ0ZNZ6xZmtA0RvwzY4tiXzWwf7DQElW80W7heL7Qh7OVrmv7FY8lQQa5CFUjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNv2PlrEALCBnLQsldXodP/zMuSTmALFTUFz//S+1bg=;
 b=NImLnI7mPzOCS5h75myRD6dJrhYj/Y8pb61WWlfOk08FUtxHCscx3oDJn5egO5woT658xGiB2tOEbTMVbcbi6ph3mDDYiA2qjvSuNRYRzRqdfIE9qlC+/cqGsnimcLLVDcNeCm5QDg8C8Ok0X4+2H9Cqc6asgus/twsBLTaTJfY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by DBBPR08MB5993.eurprd08.prod.outlook.com (2603:10a6:10:1f4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Wed, 23 Sep
 2026 13:44:47 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0451.012; Wed, 23 Sep 2026
 13:44:45 +0000
Message-ID: <b9054539-2f3c-4fee-aad5-c6e725c6ea1c@arm.com>
Date: Wed, 23 Sep 2026 14:44:40 +0100
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
Subject: Re: [PATCH v2 1/8] mm: introduce hw_pte_t for PTE table storage
To: Alexander Gordeev <agordeev@linux.ibm.com>
References: <20260903103002.1091859-1-usama.anjum@arm.com>
 <20260903103002.1091859-2-usama.anjum@arm.com>
 <4fb9f42e-73c3-46db-ac10-351a90901b7c-agordeev@linux.ibm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <4fb9f42e-73c3-46db-ac10-351a90901b7c-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0270.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::23) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|DBBPR08MB5993:EE_|WA1PEPF00009B3A:EE_|DBBPR08MB10531:EE_
X-MS-Office365-Filtering-Correlation-Id: 93df322b-b665-4342-eb1a-08df1978eb26
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|10067099003|11063799006|6133799003|10063799003|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 4g1AO8kRUEFNWgcQXjh2wHWdD79yQHdGiF1pC7allufgdnec5hNaE7+LNiSCIW8Cf/LtPMWAWu+HPPgzv/h/86VenR7OgyMEAnQxSLhc6S1YXd3KbGcVG8FY+/uRwl2ul7KHXmCO3LuzTQ0SFj2AvY+ekUeNm5xr/L4a17cqmOqLpE0hAIi44FxnIq9dA3Nm+SVA/TEFMUynwqzMMF1o0R5llCURQxKQkTE1GpeGyi36kiNV9ODPLh1EN0sfuFhInnhFcKJqY+xYUmLPvsySIeInXeNZ1Z93zJhvtB2mq6Y8l5seuDc2vh5RF/SHYMEdPWXSnE5OZxSiaYpuFsg+dDvBTPyMsN0r+h+n2YCPn1GFt6ITTvfq46WkRfqb3MSjQnVdYP/zv/x0HEy6K4khd2PMP8H+vDJwOYKRmIG3Mi519jEvwQz40tAckyFi0mO4vK+baOniNWbTxmwhe8ESybU9GLHKpvs/R6GFtfYcJZB3Kt6GXZUOf1Qb2V5lvYAJGrzFdVA2+GGsUXSScGpCDpUR+Y30VQ+1KOjQc8IDrXUQVwlCBTIaYDWiZ95e9D8+FO8tuwdnNTTTyOYXynEdIkSbx1nbyf2tebLLP7inAORYQY8UD1Uaw/iqwaxO1xbT
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(10067099003)(11063799006)(6133799003)(10063799003)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 TXHaA0zYu16+wIC41/vqvbEGWbtUM6A/QEi4hfjhAZPwB7e/jDm13rcDMw/aO8Z2W08mfc3hKtaOOacLo68A26n5EL4dlA6LeleYhiC9nkQ6kXhDTJjvxh6CcSAyRIuUgCt1DIK2sXz505JdtvnA2ICEk4rkuGPM4P8kWlgrKMZpUO0UV9+9Uo3fIActyOJ5+5cyFkF9VXAiNALcv8XPHc2fVWH9PI099oOHbtbpKWEwWIu1KS07lEVj6r5JRJFjGKZlCzAiG9RixrQvT6D0eOwJ1RBKOXbzd2ZDFxeC0Qw/pt63RPvGVNaks9ZgZxO5NDYB/k+xBxN6WVE1V46ZaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5993
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 WA1PEPF00009B3A.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	40b0c1cc-e4c7-4cb9-e70f-08df1978d2e2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|36860700016|82310400026|35042699022|7416014|376014|23010399003|11063799006|56012099006|10067099003|6133799003|10063799003|22082099003|18002099003|4143699003|13003099007;
X-Microsoft-Antispam-Message-Info:
	xOdlt9gWQb5AmSldLIWwF39tLodl3UEFxjRIlrJ59NOw1kDi74+MXR9xlaG6aaiwXOY4cd5Jr3/wVt3bn36vacHTUeK/0KkfDzfrq2g5Yg2Iq99iBlX+SLENnYyMQSMqVsEr5bmOG7rtrTXyX6GSBc/bDOo1IUtMeKgG3vo/wz5NiZSEi8voynSqFqdUS6viavUwo+Jx+JPKABcrwcVtgmVefWaxTfeyvVpXR6O8KwclhNDzbHfqq32FrEXU0oRTy7L7iSGI0XmH1BSjsT19TjgwGIfyWko4QvIXLRZ7R7aDkpnyOK1icXyArFqJ7sd1bhVUct+dsjWy2kDp4uqvcldeRBBLL858DI2MxESGcLlE7x0xIed6CPotyGxiZLixIEAQVj3xqWHFrekI8GCaF9oIgFJHptna+7v0Ltr9p6UUGpFAa/tqPIxoqsjPoSsY74WZ92uGJZQb/psZOb9k/BWPCpKRlG8ZogiOzuXyGNPyg8rTK4JwxRX2ipiwBXMPMvMfyYc+JG1BqLhRkmKvkwhywKX+Y7UXAVJzMtiV2XcTyIBK+JU0kCtEQwjNebJv6yulaHQFyARfAftW3HoMDE5ANHaQuYWy1WSkZwCxFxTNGuCfIV+dTdbLy5dwvccbsVoESTRJOsivk1l65Y0+HbGp9ST/sv8PNzZMjjVcmVU=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(36860700016)(82310400026)(35042699022)(7416014)(376014)(23010399003)(11063799006)(56012099006)(10067099003)(6133799003)(10063799003)(22082099003)(18002099003)(4143699003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	x678kAqGeH74dlpP5SlpeeqVF/B8Jqjj7yszzQQL7Qxoeef1ZC7qYaLfodPtRt1nBDXEY1KPq1agkS4ZsvRzqw24ACv31K8NxW9wr/5QZWeG+tOpRjBinx10ZZDpZXODjAJGdgImBc2OeaCXeldNt2c0helMZ1fadIpCpL8Qj24u1s64LdFc+u3JU6c+h2SM+Ywr5biNXalC/1kXFJPUWnkX4Q0D/03BN4zFe3OZUBkyYeW43OCfJ3yir3ileqzDhBvPe1LwPl4XAEoAx2nUPBaK4IVYMJVlvdT0YSyYQU5JyZAKOx4mb47W6+TRkp4Z2nBY7tIxsfapRMxxHIlkcCh4SUi40x5LoZc74sT0G1qox30Vs2XcCQluY5Fc5+cDtApJeOw8RizKDiyv4S3QI+goVGza5E7sXuQN5CIegAOHN6TogHTWIcUMWNyFiDMg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 13:45:24.0046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93df322b-b665-4342-eb1a-08df1978eb26
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	WA1PEPF00009B3A.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10531
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A13868000B
X-Stat-Signature: y7tyic4uxnbekhtiqb8qjg68f4ueyiej
X-HE-Tag: 1790171136-727021
X-HE-Meta: U2FsdGVkX1++kf1n9P1BNtqqUTlhF53KdNY2ykQmQoSMsrm0AlRhw9TSFWd1LMc9q+HvrKKPnR1GVrAA9ZnhCN6hAOLmdHPV+z5kL0C7+r0B4fqWs/DiBsZTa1ttoPNKbbkC27QrEWstoA2ldpyIzNYGwJVcodYgtmFxUPXHgHAjAnEXUwtoCmUfSVQL4Tfh76OAxPSC+5LsqRB6gjEsOTfTANmEN9V0ykuN5W0qKn2uxkkEdLyv/+9M6+SdiLj/C6yxEtrgDgoHaZjQVq0i9Xo/UhCdqHzMaBZxFvYWKREcSE604TyAUqSqYCtUII/6twsu9etMUBpzOiDp/9OwfNmJCUt37++LB4iIK4RTQGfq4yod5d3V1LmcQ7emOC+2jrrCwbQTWzQZIQctMAqdCyeDD52gmNkNSAoUc/lUz4egzWlqbCISLq76kDo++0nl+yyZ3/O2BRlb1rVE1R1t8ljnpSIBJ9NqDI7TPfoJE6Yylj+iCdS95aRBuob5vEIFTd5u4y/D6Fyrvv28qVHbur5Q8p+awIn0K4Cj1Ei8X/aKW3LciirPVAs9xNgi3U/ObphFMkeO4KfpocerHRPlzX7on+xzpGaK4VFi22zTQah5zm31t0SgLi6nd++1flfmbe8YqZyWwym/WUHIQHDSN3arky8KkSyyFhJbhRDszqMPjTRydayknUxQ7Du21RvWE9fGw/oFDQzEZ6vNkRxAg2rDwUkMNJ0z7PyVUgdSOWoYS3cRr96NgzycKprFMB01WejMBJP6OK2GYlmBDU3+Rbb1bgKkpEgSPiJuEw/NhsJgsuGEhmkYeOBWaZeTQ1Bn0fJVf1l3KYa+uFOt9fpr83pDiHQz1mwG3+gFcWl189SR7wyS7FaIgLyeSIWwc8WQRC/CW4BlbN5/uOacl1oe9PMYUc730Boy7hM3tD1HqTIL7m2W/VFNd7wMx5EYRs9MvUfiLdJLyvb+cEXbzs/
 erxFqmH+
 KuVM82801YUkiQLu6yd9fjdQ2S44pm7f5ZUdDPnzmd2w+WYHXXSxdjkC1aeWvQPahx3Qrd+bkYtlRablpBj1UH2U9NkMGuALsDzSFpp0HDnIMKuZPcnZPi2SgRP0sLzMBQ/SwUSttzmI1DCFcc5qaUswO7Sqqy0BTys4xUhxavqAYE30vf6rLS34AQMCFtG6807WsqtN5RG3SbHD8R+Zcj4csteq0mamjDsdYjfLPllzGpwcPmC4MINZanocWeft2UvCx2JTGFuK5pd3pGdDuJeS2/y1nOefv8K3zj5C/jozSulOJw8976x3jdwRBcW+R41bf1Lag0GLMtnE3eMNfI6/FGJHttqcHKrsNFJ/ngbRllhm6gU1zB0b6n/VP320T3RsARNY00BCYg4CVLnMuvcsI66irCaHOLvkah4S+RETDNfW6Eum8xCNX0dRCRuoHdzZjkpWV98fK1TkmT23Esuzmhr4Xk5E34QOq6hvyawILvcGdu/vmhWnCGzJJ/S+5ytvy8zgh3zR+XqUk5xiLFTIksfd98Ch6GLKpY+hlChqtYI565pB/nxdyBlcPMSr4Tm2J+9n7lfLoGaU38SblJW1LzT2UNgYMxJDPnaz1pCXjmyt6JTNySTn5M8guyTTNFkQ8/rm7rQO+9id8VXwbUGRa8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/09/2026 12:52 pm, Alexander Gordeev wrote:
> On Thu, Sep 03, 2026 at 11:29:53AM +0100, Muhammad Usama Anjum wrote:
>> pte_t is used both for software PTE values and for entries stored in a PTE
>> table, so pte_t * does not distinguish a pointer to a software PTE
>> value from a pointer to table storage.
>>
>> Introduce hw_pte_t as the generic name for a PTE table element. Define it
>> as a macro alias of pte_t by default. When an architecture selects
>> ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
>> This preserves the representation while allowing converted architectures
>> to enforce the distinction at compile time.
>>
>> Name the generic wrapper structure __hw_pte_t so architectures can
>> forward-declare it when pgtable_t must be defined before the generic
>> hw_pte_t typedef is visible. This avoids header-order dependencies.
>>
>> Keep the C type definitions behind an __ASSEMBLY__ check because
>> architecture assembly sources can include this header indirectly. Include
>> asm/page.h so consumers such as linux/vmalloc.h retain the page definitions
>> they previously obtained from that header.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v1:
>> - Name the generic wrapper structure __hw_pte_t so architectures can
>>   forward-declare it, and explain why this is required.
>> - Use software PTE value terminology.
>>
>> Changes since RFC v1:
>> - Add the ARCH_HAS_HW_PTE_T opt-in and generic wrapper definition.
>> - Exclude the C type definitions from assembly sources.
>> - Update the description for the new opt-in model.
>> ---
>>  MAINTAINERS                   |  1 +
>>  include/linux/pgtable_types.h | 17 +++++++++++++++++
>>  mm/Kconfig                    |  3 +++
>>  3 files changed, 21 insertions(+)
>>  create mode 100644 include/linux/pgtable_types.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 2133aec4a2004..da60a8bdcddb5 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17140,6 +17140,7 @@ F:	include/linux/mmu_notifier.h
>>  F:	include/linux/pagewalk.h
>>  F:	include/linux/pgalloc.h
>>  F:	include/linux/pgtable.h
>> +F:	include/linux/pgtable_types.h
>>  F:	include/linux/ptdump.h
>>  F:	include/linux/vmpressure.h
>>  F:	include/linux/vmstat.h
>> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
>> new file mode 100644
>> index 0000000000000..07da05d375c2c
>> --- /dev/null
>> +++ b/include/linux/pgtable_types.h
>> @@ -0,0 +1,17 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _LINUX_PGTABLE_TYPES_H
>> +#define _LINUX_PGTABLE_TYPES_H
>> +
>> +#include <asm/page.h>
>> +
>> +#ifndef __ASSEMBLY__
>> +
>> +#ifdef CONFIG_ARCH_HAS_HW_PTE_T
>> +typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
>> +#else
>> +#define hw_pte_t pte_t
>> +#endif
> 
> I would suggest to provide __hw_pte() in this series - it is needed
> by architectures along with __pte_from_hw() right away (as opposed
> to when lands in arm64).

* __pte_from_hw() is added by 4th patch in this series.
* __hw_pte() was added in arm64 specific series. But it has been dropped
  because of [1] in v2 of arm64 series [2]. There is no user of it in my both series.
  Please feel free to add it if s390 needs it.
* hw_pte_val() was in arm64 specific series. It has since been moved to generic
series in v3 [3].

[1] https://lore.kernel.org/all/86d4aea6-4272-427e-9229-295489e068d7@arm.com
[2] arm64 v2: https://lore.kernel.org/all/20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com 
[3] genric v3: https://lore.kernel.org/all/20260922-pte0-v3-0-5670b8cb9059@arm.com 

> 
>> +#endif /* !__ASSEMBLY__ */
>> +
>> +#endif /* _LINUX_PGTABLE_TYPES_H */
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index c1ddf59c0d71a..5f462ec6fa5e5 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1312,6 +1312,9 @@ comment "GUP_TEST needs to have DEBUG_FS enabled"
>>  config GUP_GET_PXX_LOW_HIGH
>>  	bool
>>  
>> +config ARCH_HAS_HW_PTE_T
>> +	bool
>> +
>>  config DMAPOOL_TEST
>>  	tristate "Enable a module to run time tests on dma_pool"
>>  	depends on HAS_DMA
>> -- 
>> 2.47.3
>>


-- 
Thanks,
Usama

