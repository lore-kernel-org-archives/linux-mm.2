Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3855DCAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 08:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 920588E000E; Tue,  9 Sep 2025 04:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA778E0001; Tue,  9 Sep 2025 04:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723518E000E; Tue,  9 Sep 2025 04:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5915B8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:27:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0589516043D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:27:10 +0000 (UTC)
X-FDA: 83869031820.29.49A4627
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3AAA6140006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:27:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aBNs5mkO;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf09.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757406426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1lA4IsbuFEwAOQgXyUdsqeYkkHwC49OQUM//Okl6zw=;
	b=5UOLYwvhpHuqOTpSNIjXU86Heb86Kvux9IAcSkL+Lz3U11mnDNlkgvQaFJXP8S2G8bC+BA
	g/3XdxM+ENxq8KkEVpYt0Ba2AuenBCnnbz4ehOK2LpYLtGsuFgkYOeU9rORlT3X5Dfnxjy
	5fWMl+qHm9mVl/VGY4iHbLaT+lLngMk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757406426; a=rsa-sha256;
	cv=fail;
	b=nkdWX/Z8T94XetLmZBqIGAH+eM1tRHyVvwXDXGxG02AcWgV51GdV4HuQlXpPuaTG2KcSow
	XK9/w5AiLxe0ostlljEcgmztBLuvCmFEN6aqMtR/GmXNSsIneoRACF7pav+Aa5kXxr2ZGm
	KVLFDsVf5/B+ARBLkaG+JySHAPS3nuM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aBNs5mkO;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf09.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757406426; x=1788942426;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=vBTct7T2ETjwayEYHpsVNHiS0ykgsh/NsO3mwBBPF18=;
  b=aBNs5mkOufd7agw7WWsVTwt+CAXpyCgbfK/AClmZ2sjDMb4Rl7ZzwNp0
   3wlqFGsQ/dqR7hnkrckphH3rZRwe7mRwZbWLhjS5VbIAqlUlgovYW0Ryd
   kYZeg1cgQsRLewTQoOt+79lgdGCOAGPhctgbrho+ry8RN3OxPeVpeI/8u
   c5vXvKxbKpgKHLDiT7jADODF1ydJWMxQdSE2Sul98W9T7kjuiDWT0B51R
   HcMkEvZmYQ3nFatDCY8YeDzMDW8seFYbqkG3FFePWYJwSmtW87vwSAEPZ
   mORkaGTQZ3eHVR1YCs0EOLD0hwsf0Ep/iE/n97E6q1g2Ny3XQno7XVQKG
   Q==;
X-CSE-ConnectionGUID: sxJmjE86QnyOyEdzdoZ6tQ==
X-CSE-MsgGUID: tIBHvbbZQ/OmwcAAJJcJJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="69938049"
X-IronPort-AV: E=Sophos;i="6.18,250,1751266800"; 
   d="scan'208";a="69938049"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 01:27:04 -0700
X-CSE-ConnectionGUID: Vs25pIPgS9OHaAuKXHCfng==
X-CSE-MsgGUID: Mth4a+QdQYiRuDu1deENZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,250,1751266800"; 
   d="scan'208";a="204012052"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 01:27:04 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 01:27:03 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 01:27:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.61)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 01:27:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qf+ewLehCW5AtpxRusGVJALlBNVVUBsKzwmVnUtN5LX1ibfvqZTQlvqbceY95G5KeiqBia4b6+FrRXj4FLC9V6OG8jyEOX1oYhSPl/aeVKQ556LkmofWZhuYR0U6QJvpPl/wbwa+dvYkUKaJwlbldtaU5/C3MI0ROk1CymAU3w01We2qCvDglG1GmH0v2cLg/F5PpjDhp/WwilAL/TS23DY5lMtIaaxs/oWMWYyptqnf9SqJQjmZKhqcQAZqBw9VDkTQhu/CgDvz5aMUyRkDW8dGzfRgj5OehP/GiM6CbYHEVR58LIiByV4fgAzjZHhKZV4MI4owZWkwsPFS2Pcsxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1lA4IsbuFEwAOQgXyUdsqeYkkHwC49OQUM//Okl6zw=;
 b=FmyqIIPMcMXUSH2lyEmOdRtNJ7cgRrlcIG3BXuNpzOfa3nagfTB8HFX2UnHgQrjXRVzPBlxaKwTHXdnjfQnWYKdoazz2/ebVgTAkJALAVbBJPhOQPHQVwFMH4d14UvZtnjQvv+hISRPyQTNXKa5VIF1m7uawJ9Ujgd3cIY4VclAI9LBQ8P5iYp+YINPcefXvRyB//4neYx7EGQuJ1e7qiW60oD0a6+zrC9szjMJQe/fQQrT5BpUtynaizMiHlL+ri+5Hyrrm/LS7S3ApEsHWDkcxbGzFvhBqr0byOTLTgJrXxewfV7MyMVK46dHNtIp7yS9zrQg2he5hbaU8AsqZXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3934.namprd11.prod.outlook.com (2603:10b6:208:152::20)
 by SJ5PPF263E38237.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::81a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 08:26:54 +0000
Received: from MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2]) by MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2%3]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 08:26:54 +0000
Date: Tue, 9 Sep 2025 10:26:39 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
CC: <sohil.mehta@intel.com>, <baohua@kernel.org>, <david@redhat.com>,
	<kbingham@kernel.org>, <weixugc@google.com>, <Liam.Howlett@oracle.com>,
	<alexandre.chartre@oracle.com>, <kas@kernel.org>, <mark.rutland@arm.com>,
	<trintaeoitogc@gmail.com>, <axelrasmussen@google.com>, <yuanchu@google.com>,
	<joey.gouly@arm.com>, <samitolvanen@google.com>, <joel.granados@kernel.org>,
	<graf@amazon.com>, <vincenzo.frascino@arm.com>, <kees@kernel.org>,
	<ardb@kernel.org>, <thiago.bauermann@linaro.org>, <glider@google.com>,
	<thuth@redhat.com>, <kuan-ying.lee@canonical.com>,
	<pasha.tatashin@soleen.com>, <nick.desaulniers+lkml@gmail.com>,
	<vbabka@suse.cz>, <kaleshsingh@google.com>, <justinstitt@google.com>,
	<catalin.marinas@arm.com>, <alexander.shishkin@linux.intel.com>,
	<samuel.holland@sifive.com>, <dave.hansen@linux.intel.com>, <corbet@lwn.net>,
	<xin@zytor.com>, <dvyukov@google.com>, <tglx@linutronix.de>,
	<scott@os.amperecomputing.com>, <jason.andryuk@amd.com>, <morbo@google.com>,
	<nathan@kernel.org>, <lorenzo.stoakes@oracle.com>, <mingo@redhat.com>,
	<brgerst@gmail.com>, <kristina.martsenko@arm.com>, <bigeasy@linutronix.de>,
	<luto@kernel.org>, <jgross@suse.com>, <jpoimboe@kernel.org>,
	<urezki@gmail.com>, <mhocko@suse.com>, <ada.coupriediaz@arm.com>,
	<hpa@zytor.com>, <leitao@debian.org>, <peterz@infradead.org>,
	<wangkefeng.wang@huawei.com>, <surenb@google.com>, <ziy@nvidia.com>,
	<smostafa@google.com>, <ryabinin.a.a@gmail.com>, <ubizjak@gmail.com>,
	<jbohac@suse.cz>, <broonie@kernel.org>, <akpm@linux-foundation.org>,
	<guoweikang.kernel@gmail.com>, <rppt@kernel.org>, <pcc@google.com>,
	<jan.kiszka@siemens.com>, <nicolas.schier@linux.dev>, <will@kernel.org>,
	<jhubbard@nvidia.com>, <bp@alien8.de>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-mm@kvack.org>, <llvm@lists.linux.dev>,
	<linux-kbuild@vger.kernel.org>, <kasan-dev@googlegroups.com>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 18/19] mm: Unpoison vms[area] addresses with a common
 tag
Message-ID: <zl446ufpv5cxbu7dlgsl5vmd7ttinitd6q3q6vfozeggvjrfz5@r5mxfobkbihn>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <3339d11e69c9127108fe8ef80a069b7b3bb07175.1756151769.git.maciej.wieczor-retman@intel.com>
 <CA+fCnZedGwtMThKjFLcXqJuc6+RD_EskQGvqKhV9Ew4dKdM_Og@mail.gmail.com>
 <2xfriqqibrl7pwvcn6f2zwfjromyuvlxas744vpqrn2jthbzu6@nrhlxafjpfnr>
 <CA+fCnZeem3pBPfhQyPiSAUfp5K0YdHFuRs0FZykF03YXVS-f1g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZeem3pBPfhQyPiSAUfp5K0YdHFuRs0FZykF03YXVS-f1g@mail.gmail.com>
X-ClientProxiedBy: DU2PR04CA0088.eurprd04.prod.outlook.com
 (2603:10a6:10:232::33) To MN2PR11MB3934.namprd11.prod.outlook.com
 (2603:10b6:208:152::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3934:EE_|SJ5PPF263E38237:EE_
X-MS-Office365-Filtering-Correlation-Id: e57c2a7e-c5d4-4f13-4344-08ddef7aa204
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dWNaNGU5MjZYeWZGai9velc4TTk1TWFnUE9TNUNDL0NHQWtOSlF0elFIeHpE?=
 =?utf-8?B?djg4a3BlUmtFN2sxTnYvZ2xjVTVZbWlqVjFZZ0dPeDMvRVZPM1FZSTdHWVNr?=
 =?utf-8?B?bzcxSm0rRjZLeE1VN1F0ZDQ3bmk3Q3RJcGo0RzVGRTRJV1QvYUEzcnQzU2ha?=
 =?utf-8?B?cHNnNWJRamxlQzMvRkJZQWI0QjYvUkU4d2NsR0c2cm9rU1BwRjh2b1Btc25J?=
 =?utf-8?B?Y1ZoUmlGcVg0bCtPRk5IcW1aWWdBamgwYkM1K0xYbzJSMnBFSGFNeEtQck4y?=
 =?utf-8?B?K3lMUU13elNodGNHaXVUNm5zUlErUEpTbXZUanFJMWtMVEJ1c0dsRGtWSFZ5?=
 =?utf-8?B?U3FsRnROK1FiUmtNSS9MczZld1k5cUhxcWNkbWNFSktDaTd0WVdaNlBpL2U1?=
 =?utf-8?B?eUM4NWN6Y1ZRQmJkckNkdFZwODJnVnBjenJmbzJlSkhLRHgzbms5RmFsOG9Z?=
 =?utf-8?B?SnhFdDdoQ0JPMW41RnIwNWhmZlY5dVFOd2tDUnl4YlJQaFltUlEwb3FCbTVZ?=
 =?utf-8?B?bjQ0RlVDK1FieUE4YnI1NzB4ZzQrSzF2RFNWTmJES0doZ3JNNVF6bVl0Ykxz?=
 =?utf-8?B?UGJIY3hmL1YwM1pPcmc5RC83K3hEVTVRVW93eUZlUm9hSzdvZHVIUFZnMUFD?=
 =?utf-8?B?WDdVdmZUZkQ2c1B4NmVZNklXQXdSOEpLbmZmcVYwd3RubWRwUmUyUkxxcko3?=
 =?utf-8?B?UXpWM2FTNFlQRXlHWEZzU1hwdkkzaWlDdHZZKzQ2bUw3YlhweThZNnFIakV6?=
 =?utf-8?B?ZEdRd295b2IzN0k5aVo3Q3lXc1VpNmRWSWdxWk1Qcm1WTWFhZ3FVWWRRbEEx?=
 =?utf-8?B?YkhVNHBaOEdZbVJ2S2U1N1dxbmg4bWIvUmJGdDdhQnRkd1NibkhFU2lpQ0tT?=
 =?utf-8?B?UmRPdnhzeG1UNGVKZGlRQUpway82MVU3OGxkeDdhQS8rQ3V5enkvT2drNXh6?=
 =?utf-8?B?RlFRY3RuMzA5T3AxWldqN0ZvU1J3dkl1djBFM2pSQXltSDdwcE44NktaWmRY?=
 =?utf-8?B?VFJXTHZJbzkvV01CZVFyT2lsMkU4K0xvSE42bWtJcXE3RTFCZ0pBUUNJUzUz?=
 =?utf-8?B?NmFiZDJTa0crdE4ybFYwZk9xYnllQjZrL1h3N1lWSVNRNVhiWkZFTzc5Njgr?=
 =?utf-8?B?dzA5L3h0UzhlTU1INGJWcFVWNzFLdVphM1NGTFRVY1lkaFo2dk81dEFCQXE2?=
 =?utf-8?B?Z1hEanhmTVlDSk9UK3VaYnBGdUNGdEl2UzFHdjlCTXhhU2lTWG5mLzdKUnIv?=
 =?utf-8?B?SHNsOFM5YllkNVFROWR1bGRxdHV3S2NIemFVNUk0UU9BSmg4ZGtadGRRSVha?=
 =?utf-8?B?aStIeVNNd1BnSlVLV0xWM3Z3NWw2YmlyMHhZc1JpTDlzd2pTc0x6ZGtCeTBW?=
 =?utf-8?B?L0tTMC9wS2JaNVgzYWQ4QVppWE5pam5ENHltWFRpSGRTQU1ta295SjJuN0pL?=
 =?utf-8?B?YlBLVWZoRmFJZjlPUGxXelRKRk95bHpycXR2K29Kdk1QbjlDT2VuYlN0SjFz?=
 =?utf-8?B?TTdVa0V3cGxLV2tKWVRMTmdjUEpjajNMOWk4Z2NzOFRia1k1ZVIyMWtTMWRq?=
 =?utf-8?B?N0l3aFFWaTNoRmhBZ0ErZ3Q2RW1ZRUFlaHI1UmpvaENPcENoTGYvdWU4ZEtj?=
 =?utf-8?B?MnlYN3h5NlJ6R2RXcG9HQ1FZNFloQ0N5NnQzaXdTWlRTb1FoOUxZK3B1UTBp?=
 =?utf-8?B?Y2VRZ0NLaE56R0swVyt4KzFvQ1hmNjR6NzdGV1VNdTNDczZQN1I0L0dqQ3FD?=
 =?utf-8?B?eHlHaUpibEJHR2pPS0JNa3l6YnZTTGFYcUlUOVliSkE0WEtYSDFVcHNZQURD?=
 =?utf-8?B?a3IvWkFJWjBYL0premw4SzZzQ2RFQnFsVmdub3RLK2pBVlMrem5UQ3c3VW01?=
 =?utf-8?B?Ri9CREJVZ2FnVHRkY3FsdytUTWQ3MDg3WlNuSFZhZTBySWd3Z2pvcjVFbGo2?=
 =?utf-8?Q?5LplsvnkncE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3934.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0RzOUQ1WG8xM1QyKysvQWxQZUgvQ1BQaU0wd3oraXdLa0QwSjg5dEFHS1p0?=
 =?utf-8?B?NmNCM09Ia2ZZK284NFdRcFlIRHV1dUF1dldoYXk1UVZhT3R3VVNIZ2hXZ0RK?=
 =?utf-8?B?VlliZ0YxRnZNWE5PZ3M0ckozU0RsbDdWL1BISXBDb2xnRUJHUkcyVytXUENt?=
 =?utf-8?B?TS90Vm1SakNFSkFad2ZWNnFnanB2bVJhcmtQMmdSTUlOOVJDMGM5aWhEbkoy?=
 =?utf-8?B?TDlwUnVEcHBPK0czaXBKZ09hdExRZU9RcDFQaytrNUlxSWpWcnI5d0hid1lH?=
 =?utf-8?B?WlFwY3NoNGdLUmR2cDJpcEg1S2FzendWbFhoQjdjalFpbm85aUhOWnFLSlRa?=
 =?utf-8?B?eEFTQzVRWWhSMVdUVlF0dmxVT1M5UmNwZmd2THhLTldlN0kzSzVCQWtwUWpk?=
 =?utf-8?B?L25JaUdla0F4Z3R6dkhjcHlDTGtsYkhZV0I0M3ZHMDhmYm1menh0cFlsMkNR?=
 =?utf-8?B?RmRxRVVJSHBpVHhMMDdsd0VGOHU0ckNXeGNocno1TldTcW5MNmVTOTVKTm1M?=
 =?utf-8?B?ZStvZ2FuQXZwREE3R2pPb1dDTE9uaE56WHhabVUxNTZ5cGRxNGFlUHhWNHV0?=
 =?utf-8?B?THFFMllxUk5teDlHc2N6YmdNbkh4VmRiMklmSS95dlFySklLZzM3SUdWcm14?=
 =?utf-8?B?eWFOYTgrZCtHNXhtWWxnY3JYbDEvdXpLdnRsU2s0cHU3SklXaWdHNHk5RHlZ?=
 =?utf-8?B?OTJZSEppdG1qaEVKdGNlelJLZDVLa1E4cWZWQWYxWTlpUklyR2EwM3VpMGFB?=
 =?utf-8?B?RUQzQzJSTDJTNG1yWjVGdDhLdnZmRGVhWmp1YVdLNWdzMG5qa2UzTmJSald4?=
 =?utf-8?B?bDJCeDNZV1duUnZ2SmFpbmlYN21pSDFzb0FteHJodjErOUtWNjZiWVBxM2Qy?=
 =?utf-8?B?RWo1bHZlQ3NzVDhqZkVEcWRobzVmQnJwNG5JTVd4dHgyUUlValNmeWZIZlNz?=
 =?utf-8?B?UzBvVlE0SzBlQnhvTVNSam1sZ2JJbWJPeTFpT1gvRVpHRTAzNTdJa1p1OXAr?=
 =?utf-8?B?NkdIS05Da01ZSmFqSUxHc0VFZW1UTllSblB0QktxV0JiZUMzaXZOL0FiYXZT?=
 =?utf-8?B?OUpQcVZTdytTaStaNDRDeFd2OEYrNUtGNWRVQWhwMWVYOTZxcDV5TFVVWWY2?=
 =?utf-8?B?RG85TWVRdUZYWndMOTRoTUw3YVd6d1Q1OXdkcWxwTDI4VHNqdUdFa1dieGd6?=
 =?utf-8?B?WGdKdEtSNS9JQzgvOHQvbTE3L0NDRjdnU084YjBIZDJ5WVVKR0RZUWNNdjFG?=
 =?utf-8?B?YlZZcUhSdGU0Vi9SVlVHTFF5YXBaN1ZydzlOaU1DcTlWeitVNzNSWUF5dzJx?=
 =?utf-8?B?aGFEQUdobEdrOWRqUHo4TVloeG5lU20xbHkxb0ZySGJwMkJuNDdkMk5tUmZ2?=
 =?utf-8?B?QjA3U0s4R2xXQ0F1Q1BnVmJLdm85aFJubC9NUS81MXR0eUNKNmJYOXFUeHhy?=
 =?utf-8?B?TUNpWk9OdDZCNUNsUmJyNksyRklQU21LNmgvVDcvQ2RyRUJCcFZCTmhlelpj?=
 =?utf-8?B?NzNLSjBEL3loM1pWN2dLNnlSUEU2TVpycTd6K3RyMGZXWUhaeHYzOGFrUVJY?=
 =?utf-8?B?eDRlb2VGTEUvdEpXZ0ludWYwMnU1Y3BXQ2FYTnpHZHordUZTcWtxYjJJMWlt?=
 =?utf-8?B?M0JXUUs1U0F1ZTdoUW5YV1dIOTJYRTZnMUxSZC93d1hEK05HazF5eWtIZURC?=
 =?utf-8?B?bWRUdEVXa3Y2YXlYV3FpQmkzajRvYVQrNkFWblAzMTYyWUFkWjIrVkJ1SHVL?=
 =?utf-8?B?L1pxY0Y4UUc5WjdGRVFpNkRGemtwVFJLUm9odkJJVlNjK3h2cEwxYUdTYlIz?=
 =?utf-8?B?cmh6TnZ5c0RqYmJQS1dpOWk3c2J5cG51T09UU3NRbTVDUE1QTUMxUkduSHRN?=
 =?utf-8?B?c0pkNEF3dnR1YWM3SEZFZzJoMUkxMlo5OWtWZXczSUU1Wk1IU0RjVGUyVXI3?=
 =?utf-8?B?SndnR2FnVHE5YWVHak1EQ0dhVGloU0VQSEUzVXZPcTJjUkFFM0J4RUxUb2FD?=
 =?utf-8?B?VWlmMS9SeUJyaDZpdUFHRkF5V05FdlgvNHN6alV0ZVV4TDN2amdlN2xRUlU0?=
 =?utf-8?B?YXIxV09CMWNaMXlxZGE0bmM5M2t0VkZIbVZpMGpBMnFLc0prWlFTNUJ4aWg2?=
 =?utf-8?B?V0lUL2QwdmxnR0wrQ2JyVFdoaXJzVVBxWGpDTkZxWXRDbVdjR2NGZnh2aTJL?=
 =?utf-8?Q?BJAJw6kcU+GmKs3MFa6ckBY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e57c2a7e-c5d4-4f13-4344-08ddef7aa204
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3934.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 08:26:54.1153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mm2JzCngy5sjR8kVl3cOqV/j4JjiU+vRCpH/v8Vb7H8gxTibyw8fNcywFKxe+dHRz7JwMglvZ3uUTn/Zt4jSwCD65TFHWrV7fDZJAeIjqGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF263E38237
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3AAA6140006
X-Stat-Signature: fqgy4fmucn6hasiyygi1yxzdtz649w7z
X-Rspam-User: 
X-HE-Tag: 1757406426-884784
X-HE-Meta: U2FsdGVkX18jI+xu5CiwhbmxGmHW9X9PQPNj5mD8PipHC7OvdpNQgIbBG+fWDzX/E8FVUy0VZg8qrt8SDLKQt0gk1uqXGg1fziQdXKpC4uDz2zJOqxNpzCZR2ZtIcwzkLeBSqeT9Il19sFiuBTJpJ466EBv16/kMOYXLZyESRhd3uELSQ3AcEDe+ahL1gKXbyG99Xjqx5pwfpTcrV7C5t0S0zK/181ZipvhmKhdy5MB7rvFI3e/ujPycfsKEAR0er5h4RzSb8bX7CGcmV0lPshoqWLk+v0kvg5mP6G2Nr8QptrUncNHYML0JZFlScmIby9iiD4hxWG1nNdXxmxx4Z4vkAkpyOLewXQNHT+ncdushocr9vKZTRlnUPcMTk9K92e1JB6PIZlDGUimALCbhCoNJAET8OzB6YVRbbBEtjq0MtKtT5q1FgbltJBpY4FCmt1d8VQyiF/LIlcPdQWdLVnbfN9O8NFYGjdYNBTGPRoT/PE9Zy/7J/W+dn0ZmD/soO3+SBdPLYZhEqkLyUxuWea2c6RjlrroSlp0fvrAA+LnGtaAqCVJwdzsf4hohaChSoSmj7Lw4oBDcYS4CSvDpCQTSeYjLSqRGGgpdrKc6b/tb7gklk+X+VuulEsgjjJdKuoRr6pi2iIL7y1vHN3wctpTNX7uOy3yZ6Asa21sp4QsMmn/wBmz+lmE5DH3mcSnKDrehO46kT5QSa0FHX+2optoHNLlTbsi4yjyJ1x3W0W2ptj1vdVCZEJFIjwYzggKd4rZFPMT2tdZy8d2YGpE2+0H/logWOYMwcUtFvdRFt0tBcu/6X4mvwKWho+BqiJ/b12gidZi/CIAteq2RLtj/kqtp5BKGxTVggXzYCoXcVeohqBmPrbPpb3xnJ7HzlLy1o1wgTsT8pnuC0X/TBC1filxzW57Jn2o+mYxevpng0yT6ByLA1ZvfeVJ7bt9xG9zUdHprXASZngpMPL9dmIS
 j3F+u7TX
 bk0YuWb19V5Wc7DcrRPjI9dsbXfyL4xbQAgMqIo97Wc/fuxAYRm7bDAKDLy+ysSjeasBgm313S+ZbdvTkIlpja2LG76L08YFGfyagx35QbZ9BBa/E/fpsFdYs/KrJhi/Wf4Quj7KsbMqrP2HoWGJODHf86JV/QgXBLwMIzcuAuFrfgIEJCMC8da+cu9k9hegKb5Y5+pw6fQYMLki3x0/rEnqyM1vh1LD5QkP7SRulCN4yKt0rU9jRhcmkiOgf1Hst15SvCFo/QWYeimgcfXFWEAENbNHMkmeSgqTAnuFxJ113b+6J15xVG3X+FfwxhNxy60kYLamnZ2tXelGh33I41iO8UAoL50DDAX8OQZraDm9Z52njgiyZLnt2D52IV+Re2Pv4YOm0ZPIuwZ5hjV80OKbyeDCJ/GgEfaLCJgqO+nTTzpl2++e5EI9kYlbNBOcT8krVCRMgS5mDxH8we5AscCjcgUl2s3ZkDtB3KJ7gmLXuZVtQljlADvfvvES8JSlpKdo+FsF5It2zd1JlX/Y+pIso1Psw3leUm90QhfpD+DBxHyNFGiyaTHEgjR0VC11en6rVNHSwUCu60DnCBGl8sUF1JF6FWAdngVwfKCt4GeoXE7Z+11UyBg4Rti+0VJ1UL+vruOp1pFW6xMcaqAmySIhSq/cQATqfV/QvqRx2+Jnx0S1F9uaxG0XB0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-08 at 22:19:15 +0200, Andrey Konovalov wrote:
>On Mon, Sep 8, 2025 at 3:12 PM Maciej Wieczor-Retman
><maciej.wieczor-retman@intel.com> wrote:
>>
>> >Do we need this fix for the HW_TAGS mode too?
>>
>> Oh, I suppose it could also affect the hardware mode since this is related to
>> tagged pointers and NUMA nodes. I'll try to also make it work for HW_TAGS.
>
>Ack. I suspect you won't need to provide two separate implementations
>for this then.
>
>Also, could you split out this fix into a separate patch with the
>Fixes and CC stable tags (or put the fix first in the series)?

Sure, I'll move it to the beginning of the series.

-- 
Kind regards
Maciej Wieczór-Retman

