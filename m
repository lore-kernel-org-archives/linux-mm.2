Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBE2C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 10:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6A3900058; Wed, 13 Aug 2025 06:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49E55900044; Wed, 13 Aug 2025 06:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365EB900058; Wed, 13 Aug 2025 06:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22EF7900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:41:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9837C117022
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:41:01 +0000 (UTC)
X-FDA: 83771391522.19.0B7D36F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8E6C8100007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:40:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P0ox1OsV;
	spf=pass (imf05.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755081658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/V4ysxzRX1oH14Uo2lbLLkafYycPJMyOAwCeRcAo+M=;
	b=du1XQfmJkmwwFC2qwhWEa1B4iHOX73PCSqmYj+/9HaM+Zvijy3We8jzjuXzIMtBTuf31WV
	/lVWWUMfb0j7wcoKzK7GjmG1/K6t+8m0+qwVmfYd/wrsZ8p4QB0jN13ZUPxZBEsGgqFMZH
	z5N8TanNyRgzp0YZ9f77voLhZLexuE0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P0ox1OsV;
	spf=pass (imf05.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755081658; a=rsa-sha256;
	cv=fail;
	b=xws3ZRHeqCdm6RnEzh17nzsiAZY7A4+plUAzTBbmX/t9j/sBa5G+FGXxX/T9ASoXFAyHpz
	tYGFHaHzpwHrThdjL3wQkyYFaXMFHrKIrJpdu0cp2kDDcXWyE+IyBcL/0Yfi8UjfGY1eel
	etrgXQfXbvoCKvjCiEzmszIEU6n8FgY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755081658; x=1786617658;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=1CpaxJLJaMpje4WQmHqG+CHMByk+bOepWXqIIjHqmsY=;
  b=P0ox1OsVmoQ/n/1cAJv6oEF31eT++fUV9ypVXME6zdVf5lghZu6XTc5s
   yCUp07zY+/cTAGKLjQ/GPyj+QJ1LpJ7xpHypjKx7EjcG+/funn5rIDoIr
   ljztOMNC1GcxIFKpJy+OUuZV72PRSyQcbdUgZxvC7SFs19MAooknj+on4
   mAbGNuQxWZbwSCzf2F+uofAnLJdC9NK6/BQRfqJCUjznb1ske5D3bbJ57
   szn2il1p2b0wetEHrQcQa1+ASE7iZ050yx4YMfrNSaPawXMhWSnZs2S/8
   P0UP5cDTIaDGNgsrBBYkSqlEWGis1Sun7xC8q6W3SKEpGj7sEKN/W/xKc
   w==;
X-CSE-ConnectionGUID: drLKQsAtRt2p0nxo+SWBJQ==
X-CSE-MsgGUID: yTI/xI8ySc+FoVtCgStSTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="74817734"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="74817734"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 03:40:56 -0700
X-CSE-ConnectionGUID: 8rQVP2eOSUq42A5Q2xoAQA==
X-CSE-MsgGUID: IyB5qBL0S928kK0Y0bWeCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="171764862"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 03:40:54 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 03:40:49 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 03:40:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.84) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 03:40:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWsVBLwWbN5fEKHUmd3idmXtSXEvykLmsHfV5PkQX9QFtYD8O54yn5mvEuCesHvsjc5/m8eq/KE8MIQQSEN2/5YR+kqo2ruY51dontnzoDN/p9vZ2AwKJCvaSfZSayuORLiSlmjvHyK2J4HHzyhkDNE0RLob4LflSgPxpMDStOGDb1XROaNel2laQJx7y0GNzVXGH9QHZYfsY3I3wz/RmknAvDpdQv5lb4FVUurSpK72K21SxSuFbN2Ic8XDMTBk1wR1wUPbOQBHGLID64yYOWjc/8OOn8czXRON+L5Tzw5EvlZQZ2ZBj63aM1azyUrP1yr1hJjDqdT53tRxPdrO8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rKKY8rznZ41XMPA9SgN9+U2171s46U3wvgnEgor5fI=;
 b=XbQci2+feRX7yt7ZYd0zpiRUBgIPvXYDpPmKc973vwGGgWNBxXLZtKztuOi1ReLZmQBEOTJgjXx3oJsVJzhWaBDXuNHGCQGCWAZv2g/bo8ry1x71uBte1wP1N/vuBZocgQFGrLKnIekt6U0WYfWt/MvqqzJaeBC7yevGTzs4xZBuWZwlrIJ+m1c27zu91tl7P+3vYpDoK73T1igxw8c6f0L9LldBX20eBhu6+E0BCqdnfQe5YSSsPnhDJXjvhbijnlQatE3Chr6aBfoXzmlEeU8xq0JWtSYVLA2voZR11U756DeG7fp1fIFeuNhpYLQQiNfl1Ujc0OuWY2rorARWQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3934.namprd11.prod.outlook.com (2603:10b6:208:152::20)
 by SJ5PPF1EED2E381.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::817) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Wed, 13 Aug
 2025 10:40:45 +0000
Received: from MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2]) by MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2%6]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 10:40:45 +0000
Date: Wed, 13 Aug 2025 12:39:35 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Kiryl Shutsemau <kas@kernel.org>
CC: <nathan@kernel.org>, <arnd@arndb.de>, <broonie@kernel.org>,
	<Liam.Howlett@oracle.com>, <urezki@gmail.com>, <will@kernel.org>,
	<kaleshsingh@google.com>, <rppt@kernel.org>, <leitao@debian.org>,
	<coxu@redhat.com>, <surenb@google.com>, <akpm@linux-foundation.org>,
	<luto@kernel.org>, <jpoimboe@kernel.org>, <changyuanl@google.com>,
	<hpa@zytor.com>, <dvyukov@google.com>, <corbet@lwn.net>,
	<vincenzo.frascino@arm.com>, <smostafa@google.com>,
	<nick.desaulniers+lkml@gmail.com>, <morbo@google.com>,
	<andreyknvl@gmail.com>, <alexander.shishkin@linux.intel.com>,
	<thiago.bauermann@linaro.org>, <catalin.marinas@arm.com>,
	<ryabinin.a.a@gmail.com>, <jan.kiszka@siemens.com>, <jbohac@suse.cz>,
	<dan.j.williams@intel.com>, <joel.granados@kernel.org>, <baohua@kernel.org>,
	<kevin.brodsky@arm.com>, <nicolas.schier@linux.dev>, <pcc@google.com>,
	<andriy.shevchenko@linux.intel.com>, <wei.liu@kernel.org>, <bp@alien8.de>,
	<ada.coupriediaz@arm.com>, <xin@zytor.com>, <pankaj.gupta@amd.com>,
	<vbabka@suse.cz>, <glider@google.com>, <jgross@suse.com>, <kees@kernel.org>,
	<jhubbard@nvidia.com>, <joey.gouly@arm.com>, <ardb@kernel.org>,
	<thuth@redhat.com>, <pasha.tatashin@soleen.com>,
	<kristina.martsenko@arm.com>, <bigeasy@linutronix.de>,
	<lorenzo.stoakes@oracle.com>, <jason.andryuk@amd.com>, <david@redhat.com>,
	<graf@amazon.com>, <wangkefeng.wang@huawei.com>, <ziy@nvidia.com>,
	<mark.rutland@arm.com>, <dave.hansen@linux.intel.com>,
	<samuel.holland@sifive.com>, <kbingham@kernel.org>,
	<trintaeoitogc@gmail.com>, <scott@os.amperecomputing.com>,
	<justinstitt@google.com>, <kuan-ying.lee@canonical.com>, <maz@kernel.org>,
	<tglx@linutronix.de>, <samitolvanen@google.com>, <mhocko@suse.com>,
	<nunodasneves@linux.microsoft.com>, <brgerst@gmail.com>,
	<willy@infradead.org>, <ubizjak@gmail.com>, <peterz@infradead.org>,
	<mingo@redhat.com>, <sohil.mehta@intel.com>, <linux-mm@kvack.org>,
	<linux-kbuild@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<x86@kernel.org>, <llvm@lists.linux.dev>, <kasan-dev@googlegroups.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/18] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <rzlimi2nh4balb2zdf7cb75adoh2fb33vfpsirdtrteauhcdjm@jtzfh4zjuwgl>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
 <mt3agowg6ghwhvcjqfgqgua3m3al566ewmvwvqkkenxfkbslhq@eun5r3quvcqq>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <mt3agowg6ghwhvcjqfgqgua3m3al566ewmvwvqkkenxfkbslhq@eun5r3quvcqq>
X-ClientProxiedBy: DB8PR09CA0025.eurprd09.prod.outlook.com
 (2603:10a6:10:a0::38) To MN2PR11MB3934.namprd11.prod.outlook.com
 (2603:10b6:208:152::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3934:EE_|SJ5PPF1EED2E381:EE_
X-MS-Office365-Filtering-Correlation-Id: 74f7127c-56fb-415b-aa13-08ddda55dbdc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?zh2OKw1mNTYyc7MpM7Gp3Ntsu+ttLa+1Kurrk2+Tntx294FdCv0sB3mUsX?=
 =?iso-8859-1?Q?k6EZutKfpNPlFOtPcJyifPdwTQeFpzzcQXL0BHiRZdBxEV4+0WXK5qNBAu?=
 =?iso-8859-1?Q?SG+1F6uYKGPpmeI66vjq/0xjuFv4FIF8YlbnNhehGZI6trCMeqwcR/sQX4?=
 =?iso-8859-1?Q?31E20VrXo7SLTxuUJ3owLM2Mjgo1tVgMHl7nCwgphJ40tnMzveBvPZ9LOL?=
 =?iso-8859-1?Q?ROAbeKuAT079MxOPUsa2rTJ7tl30mcrbIZoTtBlOZrXJToa/ENbgwSUeFz?=
 =?iso-8859-1?Q?KqzRdwIrhXOlc0dHcEa7xMmwjpTR/3cBXjRbDRSpnsE5pIb4hYwfbUWx9V?=
 =?iso-8859-1?Q?f4Y+U2AVe1XMVG2kHJ32oip+0Eintr3kLXsgJUOvxD9IvUZhbNbhSxkJG+?=
 =?iso-8859-1?Q?5PDI3QPslFQDUsscdsiiITO30+T3htRWJ/zYzfESZx9ckBC+Hnt0Plu44Z?=
 =?iso-8859-1?Q?y2z67aRVwU+KT6/qH2vhEGkiFlQl4TqXiGbnFxHDxOwgLF3ANXpymz05yS?=
 =?iso-8859-1?Q?1cGqo2NAtacyFkTVeZlyURlMHgEc86gCdC/Ooz+JvfDGVf1Hzguj0quGVe?=
 =?iso-8859-1?Q?dXjft/NyZ+NDu0fqxhqbbshdUCSpXL2tV7TneMjuxS9NQm/31/LxY5tb8I?=
 =?iso-8859-1?Q?rRxAGpyQcPFqXH3uz+p9TGheL5GXCG7Tz8t4t5nxtZ9zz6Y6hMYe47eFrR?=
 =?iso-8859-1?Q?ef7+dCMptuWx81oCI5UchOFPhLlE6ThkfMmkB5DbD8brdiZ1Fv2dxHft/o?=
 =?iso-8859-1?Q?zwLlXT7+gP593OhnktHntVFH5pzgzf90mom8p3JDtnsv6G5rc9P8ydTk6H?=
 =?iso-8859-1?Q?QQMUyFqD/fmC4k3tICN/KfT8ujhsVHL6VFPsoN3TW2DBx6nQVSI22aW8sp?=
 =?iso-8859-1?Q?YhGiDOembMYJlEQFRJzTWU6ORLRaYzB/1t/1iSoVH8f2rMSUp6FiDcah7J?=
 =?iso-8859-1?Q?MnV5dVowmgJr04pHueXajQnyn+hvhiiDmKT2+zkSXFMtQsQZ8kZ+JXppuo?=
 =?iso-8859-1?Q?mSXqkXgoZEdfFhXoiB/s16yLN46lyDpZudG5f/jwC6eDUZKbYFVvZL3au2?=
 =?iso-8859-1?Q?DDCVx3tM/mvXcyDn8qwMrp8FKmUWBKk5lpJ4wYXph/iwC77/Wc/9ty39Zz?=
 =?iso-8859-1?Q?Rnh9sUggPiKykTdfyml2RpoUmLwbL1tb5X4iEZPJj4vRIhCt7+7D45izoD?=
 =?iso-8859-1?Q?KqXh8OA+0N/FEUP5EKiSHa4kUko8F8aUCVqwWEwsnO5LQz25t5M4vZzpEY?=
 =?iso-8859-1?Q?/icEE+pK4NdyLMsHwZjMo9P6qT72nfeB09Ok6c1bhJBGwhEWle2FgvksSD?=
 =?iso-8859-1?Q?Z6QND9/8B9h0yRMigqNAUbw2XdNmC2u5zyb46IgpEOKIAFiEPEG0aZO7dl?=
 =?iso-8859-1?Q?PPQAU/GByudllVLHl1SWtjAB5+kdtQ/PrSx334apG28q8GGtfdr5Tj5klX?=
 =?iso-8859-1?Q?C2GQByXCob6cxfM7V6WZXOyE1yeb3vpJWQj2axFGbJ2Mqp3eH1wk+pgJJs?=
 =?iso-8859-1?Q?c=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3934.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?omvumtEPIXVSB7pAd+6zqooALYnvYne1GFMQSFPdxc/d7Zdbibttr9LXzV?=
 =?iso-8859-1?Q?vPYNFayQWTeJF4foLzFioaXwHiuGAEmLTnwa+lRp6KgMbH8aoUmCxZ7QtW?=
 =?iso-8859-1?Q?AarwtANXq4Vjc2dVCvYQVX/A5fe3fP1wxQQ+1/8kND6SlHjT9tapCg8syX?=
 =?iso-8859-1?Q?g+9l/Xq/GgZ3Q7i/XlyueOY+/U16WgqpFdAuBArkkaMmfrE1/Pvuw3gbTi?=
 =?iso-8859-1?Q?6IYuyKVEyWRvDSaskxIozgeEJpsT4BQPtHjiZzstDctUpyJfX99WWfHc5W?=
 =?iso-8859-1?Q?606PhEU5+2ZFLgqWPq37tAoKsHKR/wzC7sD4YAF1Ntkx3tboyqKpzUPUm0?=
 =?iso-8859-1?Q?D8MwmsECsLaEQoT9Ivb1K6dimsuXu8qWZrCcwuK87oprrUR0Y+/q2XJJ1Q?=
 =?iso-8859-1?Q?UhfqZJs0XVnQJ+rkD7QSFyQ3802gNN5gCXguldfQ5Gt9tPxSeb1Bm3GiyY?=
 =?iso-8859-1?Q?iZ7GAYeweELvkUjqiqreJuoz/GsfZ7xKAe7oYkEeNjVBca620r6T06yCO0?=
 =?iso-8859-1?Q?tvhpfTnjM9xNDHIqYUO4JAdJTcsQidka7RO8eiR2mxlZbFsiJ7+puyETE/?=
 =?iso-8859-1?Q?BnrnGDOfEi6HWxYdrXSRBvsu3oGyu1+HhnvN2crN1asIZbcTBqaV3OBVtY?=
 =?iso-8859-1?Q?4A1Vva6E090imZz8WAj/INCftXloSLdaa2OT+PYy/rHOvdWNLgYy5GODYG?=
 =?iso-8859-1?Q?juZroSN+g0fmm/OUv3BEZ+Nk+yckNmwhuVGIKpnNrKFAE+1E7XoMvotV7/?=
 =?iso-8859-1?Q?wJIHGWkQ2c1LOovjPdm8QKl+C+6mgDLAkP47xX4UPsD4Y/0ZxKvie5O3Kp?=
 =?iso-8859-1?Q?oVkjllqYs2Mhm2v+QD87V1QyGBCX3WiEbWQ98y3QhDEbMqEEtoLgs9U4Ec?=
 =?iso-8859-1?Q?V8cndjvC9IAjRVo8XtS9Ns+DLEdA8yzwilg9uqPGtU4S5Gl13chqAJ6SUU?=
 =?iso-8859-1?Q?zJ4sdltdu1TCmg/jQ+RGDl5200LCIIBpw3rP4SJgM5tq72+mLGRDVkvTJJ?=
 =?iso-8859-1?Q?0OYC04UWzR12XaCXNp9n5ZPaXWWjiNTUwZdpHeRZFMsLK3euY/JOsE6bVT?=
 =?iso-8859-1?Q?iPulZqXLXI9GWepN2B/d6GFfEV6SEl38qFHpr2VlMujUd7lPcSsxDGNBR0?=
 =?iso-8859-1?Q?aDZAOIu3JxjJw64/oWUh3Bi0ZOK0MR4UR4ofVeh9E15MUsxVbr9e0xXhfn?=
 =?iso-8859-1?Q?aYmEujNYGusfyw4fHC6aCnV+sOareCwoAe990t+VcPuXImM7y3Bbbj16eL?=
 =?iso-8859-1?Q?Q+IknWieQsM7SallgGF4bEXBbVIXYKDDuUZwOZFOZzRpSjeL4EXHyV+BDf?=
 =?iso-8859-1?Q?QEOHJo6oOI3pn9IFWHZzJdMhovacE2Oahfc1lW9cH8BuZCzDeM6achSBcy?=
 =?iso-8859-1?Q?xQkhBS3MCHGQNJG69SjL7wvu46hBIgW+7JuAzv6D6BctglvYXVighIru0n?=
 =?iso-8859-1?Q?NKww3tcXZ7s5mLWvEoTHhjVHipTCv0QG8gPCrDvNJxA0kum/y4Eb/+qUqf?=
 =?iso-8859-1?Q?OMzvipj37aCdd9LZ0RgBcrc2rAA9qHOnjePCvz/GymYG1etvHc2zyHRwZg?=
 =?iso-8859-1?Q?XZU2btE9c20kE3snhwj00r8M6v/K1ApIHc9Z9m3OO9Bo9kBEmsoKvVXBYa?=
 =?iso-8859-1?Q?d8ScPLgP6XtPNoM2W8lfm2SmfrITgyofx7MULYVv6DcX/d61B32GXiVrtg?=
 =?iso-8859-1?Q?k7gGVF7yReA1JeFYaSY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f7127c-56fb-415b-aa13-08ddda55dbdc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3934.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 10:40:45.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 92nhxj/q7p2coUNxRgPTLosXiLtwNOFn1Z9oRuJtqFwKB2xMMLwEuPs65YzpzE3mTtiq9CJSBNUZlE0qs/kgIxPeATfVJ6IotW0bERjOfUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1EED2E381
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 8E6C8100007
X-Rspam-User: 
X-Stat-Signature: tzjhr8pgf6s3nhd5o9p73bpqmffe9bg3
X-Rspamd-Server: rspam09
X-HE-Tag: 1755081657-701870
X-HE-Meta: U2FsdGVkX1/u+EbKtwHRW87bBleoV/XMd5ieiJBzASdX+8FJi9ai6guTC6UfctJaKwbiq48wi4jSRS8IfOwaUgroScaDtOkjda4Lh2jLWqvgkKptqC/nsulHRJIMF8frs6+1LUGb5BkN4qhpakOVb/4gV6z4fKgdYxom1E54Axd3hkAhzFbe7d4WlEZ5qXVTRrmcZZngglovDJ3YDwK7f8KcuHawTb9aryskI1bIwZfjWPkGg8/1WX3sbGqkA0iWMP70XCmdJdl0djWSt7LPVb6Qj/K86ZidxmeE3dwtLFPcJ6d4cqsYxO7pbxzWndfa1m0niM7WhKHnGiKb5QqLfxbqOJUsGxmUGOotx3y5xeSuhf5jLSQdx9mScP3K2dBDg+InbMpFdPGqytU17iDDg1lIj6hMBnEC/TzQp0bmSz/o7ElYWp8y1UZm4bHcqzeYnsSKhNtp2A2EN0xAZfA2mO5st4gdDDtA7CzhefrzVNDLSaQjdhVfO5FpFq6rXZ8hi65DFXcxFAJ/IArRKvlkBgY+qM63U2kPTWC67DA7nYsAFZNMzY5q0e3RRkSGGKp8cWBNVyMyyxsbnhbanat5viu8v/Lik4z+PtuZy++adrZc+JZab2eKJpU7/h15/NbCtz3SLhUV92gBKT/l34mWE0Sb4XfdGUwba9ozHclzUbEkY4GOTBwz5zb9xa7N5OqL6QALi++G1wDjlCOMUte9fVnAwqVu6h0SZwbS53k43RiLXVr0cHrEkAn8eNxnOe718W3AhvM5d/qcJzG19KKLHkf+m/PfkeLV/Luq3YUSp7BIgAIry/83/oIANzozr8kjySuu+qjnWIl/lBXrxHZo6F+swr1PnwrNFDWT5TzUiCRgXCRQp2uJwh8FDuET5TwpLkq1We9l8DQ5/wMhQBS32eCBVFgA2G89XDiOVyDZB6ITj3Sxgntcfo3Gs2jLktS7+UDom8PZMvNKRMv0Sdt
 O8Cpbblg
 3LS3KkhJdwRi3vzytnVtn7xu5x/9I52EE+qsWw3zETM9yYZH91wASQvcaRg0bYwR/rvAQgY3ExeXlwDw205ZAQgTzwHzm6ceH4SFibaIBc753dvTl8bihb7wliW9l8x8cjri3M2k8kg9Od0DP/1870FFM645/Z7o4DU9IHH01JTyyhN+BxPyRIeSz7ajRs9iYqQ04JwEgUF9xj7S9zFKeL6Y2tobebwpFTjhf4iRq0ausvWjAVdmGeGmMycikcj7ba3YzoxmvmYp0I8edyQFvGeaJnlCuu87ppX9T3xZrJZyE7OElzPdNsSpRcFhXDboJEkfZ/YhM4QgTYtwuxT6bptdBto5Ksd/Ph7LBvUWt6S49qRDY5cIl4VpPZX3EMUFwILk1kfZUycn99DluaFSlfUWXIjNNJOy+DdjCIN4WvSgPEn0z3f01dgLJdQMm3TFcWFq/ssPh3q4eV4CSSDbd6FlCJB4x54Idx14MFj1io+/kXNtLgUJVBnd+t9ulsOVO4WtioMlfYAbFXQg6kNv5wlXY5565gx64zBsrNcS6to8G6FbK+W5COunq3INeDeZvI/H18NHz+PteJ6lbB6/orebsQO6KDNyuxhIqfjx2mJAjMrc55//l+kgYH9+Tu22klYhBvUSzU3rvY4kuBDNCC5W12a7ygc1wUqIK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-13 at 09:16:29 +0100, Kiryl Shutsemau wrote:
>On Tue, Aug 12, 2025 at 03:23:36PM +0200, Maciej Wieczor-Retman wrote:
>> Compilation time comparison (10 cores):
>> * 7:27 for clean kernel
>> * 8:21/7:44 for generic KASAN (inline/outline)
>> * 8:20/7:41 for tag-based KASAN (inline/outline)
>
>It is not clear if it is compilation time of a kernel with different
>config options or compilation time of the same kernel running on machine
>with different kernels (KASAN-off/KASAN-generic/KASAN-tagged).

It's the first one, I'll reword this accordingly.

When you said a while ago this would be a good thing to measure, did you mean
the first or the second thing? I thought you meant the first one but now I have
doubts.

>
>-- 
>  Kiryl Shutsemau / Kirill A. Shutemov

-- 
Kind regards
Maciej Wieczór-Retman

