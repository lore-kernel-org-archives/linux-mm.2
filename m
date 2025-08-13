Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F77EC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 11:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9735900060; Wed, 13 Aug 2025 07:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B484D900044; Wed, 13 Aug 2025 07:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8BF900060; Wed, 13 Aug 2025 07:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85AA4900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:44:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAF12586A4
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:44:47 +0000 (UTC)
X-FDA: 83771552214.22.E10972B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4351C1C0003
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:44:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kE8NSE1N;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755085484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xB3KxtpYe8BokF4ZpDC2R4ESU2KpUXZXf7my4S5Gyi0=;
	b=zBHp7MMalJyWDr0XQhORdPxECHKmPhlaaMw5NuzNGbN2dg3r5dE8wVJZiwgocPNPLNATtJ
	MzATgQ1NdcYFSATLnH+TUWVuaXFJLqqT8/qblgeBNr/EwF2FtO9r4IhyE24VTRXjJd4t2Z
	8YN8aMtIZOVolZX94s52KNL3r2noCks=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755085484; a=rsa-sha256;
	cv=fail;
	b=cPloAES0EkVaILESpBk2+miYIvv3uP6V7Yn52lNvlXjOeWLrUI/4kedDfy8vPaqgQq3k3U
	M8Cx5QtojjY20mhr+iGR6GOqjKuSuc8TW2zTZvalQMELqGdggsLzJKGFk4uXV3naMKZgRK
	kW+enW7JLTI7YYg9KEETThRqw5Izg2w=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kE8NSE1N;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755085483; x=1786621483;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=mx1sj/6s4tVWUubNKOB9VYCygnoXWYdaWIXxM0em7rs=;
  b=kE8NSE1NpO0yk3OjsvKf42h2PDubStT0DZ1db66wC2m+RFv6Votp9GER
   GImygAYXBkDSo2glVBsu7QGpEVJCJGXzd49evTkw9UiIqnSe7FNaU1kxi
   TLN2/S9eavQ1bNIRchF+B/6/IyCn+HMlKB8v6hJ0Aj/5j35m9lv/vCtQP
   +xyxAiLeg2iKzec4ZEc6Wot2NR5ErAC2NEJlzdgShlmUgYrwF0Yj+cd1e
   CU0OSm5n8acxlB3MwVUTA63dyiWMmaD7IQtnInZPkAJVCf05D/F2iLNTO
   C7oF7HRf3y3ZjaidtjYYH9AdaFMpsdcC3BD5sYGPDWQPUN4urAEtQQcDp
   w==;
X-CSE-ConnectionGUID: Z3aTrUY/QDaqwQlgx334GQ==
X-CSE-MsgGUID: cesFrSnER8GRmGLmqxjHBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="56586303"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="56586303"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 04:44:41 -0700
X-CSE-ConnectionGUID: K5agJHgMQFaaMHizXl83yA==
X-CSE-MsgGUID: EEi7JZIhT2Wq/rMKioh+QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="167240485"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 04:44:41 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 04:44:41 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 04:44:41 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.52)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 04:44:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FxBNXcLCPlMqHG/OXutxRYko0MZTNNJuQFUPvpnYYIdJHkgIEQn64cE5Y6iMYETu6xULcXxpIbB785anV7eFRMa7oUwfGL/UCvUrMMMH5tqGfBotr1Y5yDMVP4yZZWPdc2MmV3/i6fCdWux0DKx2tv2T49Gg8vdJuKJUEt0IGlHQ91sUBioyb5Pk6SU73maooNZhgksT36/29YnTRtAK6LYBhwyFmALe08PDZ/Hf8gLkC4s5gk377PHRyCbmmnv4qeICdhBLcr7s6jn5qOh+/n/pC7qIgGryE6rVYNI0KbbS/+kFMT7S/WDELE+iA71dYdKCd046tCK50pcVNjsUVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCY2xioaOZZ0eIx3IJXs43PtynuXv28d/Le9lAtm9AI=;
 b=PPz4bJeX5wF6B0k7M9reChMmnUPRcjQePQz325D1C4tPDlXthqUxqdKUd4FjWA7hzYdyGuFNXzMyderk7iWkyi303HkRtBCQjn6rqBRXxkzztqvHzyZbybuhAf3NcXQM8j0ZP6b8jHZ+nAOLXIkZufJPErwP6Tsw/e6haBKCcumU4iklAL3NBC7Rc6sQ1/62RR0sUW/HuXI0DCLXqjx8aiKWBIYqlkNEDF5u9a47nNwg3MFNV0tX+vbdBhDXz9YE5vGw+VwJ6/pC2dGKnbuokxkvXgBPYEgX3qgbBeFthcefWM6t84uk5LTLJj3r1mMttgHTrspwW1R4o8u2OaXz3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3934.namprd11.prod.outlook.com (2603:10b6:208:152::20)
 by SA2PR11MB5050.namprd11.prod.outlook.com (2603:10b6:806:fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Wed, 13 Aug
 2025 11:44:38 +0000
Received: from MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2]) by MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2%6]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 11:44:38 +0000
Date: Wed, 13 Aug 2025 13:44:21 +0200
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
Message-ID: <4oiaqaiqvxgswebgm63mtyv3pxuhsx2jo5lade56flgz7laoem@au6ltbbzmvoy>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
 <mt3agowg6ghwhvcjqfgqgua3m3al566ewmvwvqkkenxfkbslhq@eun5r3quvcqq>
 <rzlimi2nh4balb2zdf7cb75adoh2fb33vfpsirdtrteauhcdjm@jtzfh4zjuwgl>
 <ebl5meuoksen5yzpzbc5lcafcgzy3esfq7c47puz4tefeskkos@f5wzzg4fjrfz>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ebl5meuoksen5yzpzbc5lcafcgzy3esfq7c47puz4tefeskkos@f5wzzg4fjrfz>
X-ClientProxiedBy: DUZP191CA0051.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:4fa::28) To MN2PR11MB3934.namprd11.prod.outlook.com
 (2603:10b6:208:152::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3934:EE_|SA2PR11MB5050:EE_
X-MS-Office365-Filtering-Correlation-Id: 6735fae1-f688-4b91-0dfb-08ddda5ec831
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?CGHIQ5piAHsXhj5B9Oezf4sPUol1XanMtIMBtz+Fsni6BPnXwiMGyNp6YA?=
 =?iso-8859-1?Q?+FbtZlDP99AjnJFdJ0d2sDcVuC5RDgDXPh+Q+vKuNE8d40N6DTEbjZwkEO?=
 =?iso-8859-1?Q?zbNxnkIM/sVRlfUBICUoeKHum+XLhfo9RXrWEg75ude4hL5BAKJ5BH0Emu?=
 =?iso-8859-1?Q?EsvQNYB8Ifgfq6IZsNmkBy238lPGUE/I4brhaaG98Vz4koEnoD0QeRLn7U?=
 =?iso-8859-1?Q?pxA3QarWhD87LzhMfE6iPjeKSdjxwhBzVgzOU3S36Xl/RaVXaP0+dWUP11?=
 =?iso-8859-1?Q?/hHWWvquhCKcEYDOlx2PQ3PK688WEfmwyz5l6syWWBIouZcwJtP6enPquu?=
 =?iso-8859-1?Q?XIni5Y4lcFs1pJNt+vsrLq7J9wE1T569OpAmHBPg4Lhz7tLNAvR4qaRboj?=
 =?iso-8859-1?Q?xEXfZ1vI4tx0DaLJB+GixevKfI+cip93QgIb7UF4UvTins2/dTmiKMHElw?=
 =?iso-8859-1?Q?iTYvQ7GHOKPuw1N8g+9PaxNp50G4ukiNHFHlyMHJtaFuxhYkocf9GOhwpY?=
 =?iso-8859-1?Q?6l5OBruPBzv2AkAp3sEXh2OjqmLRMKulTUVpbxREhZHVnbLNDokGfn2jwy?=
 =?iso-8859-1?Q?ZQVonzjJRq5oC+G8K1+bl1i2YF+ofBGwcAI5E/K9spikNUTyyTUPobaEbn?=
 =?iso-8859-1?Q?ecaizAhBSMgqKLzzXgFdX1ayoKODjZE36z/E0CmkfbdzzTVz7JzpnXVNh5?=
 =?iso-8859-1?Q?ipRHIyt2nXWlDN2DZITrWDfG6G+Ud55qx0+KZeKkTHDQoML/GiFoIPWEPa?=
 =?iso-8859-1?Q?ZwphxWgjujAo39VQoPA/vXDgC0YfeYNcENmMdD7oZS65UoyH6wf7yuxj1g?=
 =?iso-8859-1?Q?8gwDUnoNHhjKSVtUpnum4Gex1wTiE9yQDWUXVm+mrC7aD+ibaGfkjA0bxK?=
 =?iso-8859-1?Q?68a7F/sDm6TSxxPhVh6MQYPW1t229eZ8UOZT1ibM4lJCJCSB+GdFtQ0+iV?=
 =?iso-8859-1?Q?LfFSpiWEDX2bbdIqseLTWsyrdDRDR0vXFO5Ss6wEwuhEVTd60/o5PuYb8u?=
 =?iso-8859-1?Q?aDxnn9lJSvBtZZlwNRus7uGfDOXQPmcd+sVLelCkIGyzUZY3/Vp3v3cxbS?=
 =?iso-8859-1?Q?Rt8PA4j/5Vy+dShHgREtuOtSHawpZdkqdPqtsF8ZcI5aEMnlf4E4885JDL?=
 =?iso-8859-1?Q?kmRoXCfg9TJ3shg3oh9gvkb6L69JQzBAl9iWFZOgAIGbDOEMXtLvjyWzmo?=
 =?iso-8859-1?Q?lUbMFxymDxKIStKvN60Itcb+qePW9XRKLVM8IUFFpMC4MgRjt9V/ILaYfP?=
 =?iso-8859-1?Q?B5hvWljrhOPddXprym1Ze63wXVkZS5ws8GBXxgf28drvvb5yUNziNINF6t?=
 =?iso-8859-1?Q?GZpdt927G++TKfsIWe1YWmEjYYP+zs14o9cO5ECW5rUKiW1ruVt1OljBJf?=
 =?iso-8859-1?Q?bHf/SgksV/ejGcsQH9KNDoh6k98IPJnr3A9JQ2bJUdasQCe563Dspj1de1?=
 =?iso-8859-1?Q?ERVYPkFCoWAVs1tzsTzCdGvt8+CQfNAjhVoft5BmraeLgNG7aGA6mp3yMh?=
 =?iso-8859-1?Q?8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3934.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ncrgWSQ6zz+5YTRKqnQedbzmne2xBiXqRL/Ji/IzxSSKjUBxUUexJyKhQV?=
 =?iso-8859-1?Q?cxV3iMJtCx8GO9sYM8P/D/kC2+9+YeZuJhYtH0ldNF4vIR2c6FUqjLBIT7?=
 =?iso-8859-1?Q?Bsf4PFPbMCHAYWBf6YxzC0F80K0qtDCoKe2gOXGbpAdxM07kXylDZ/PsV+?=
 =?iso-8859-1?Q?ErVCanlHiJMuoKQebN+RWmzVzcnFf18ipQopeFUVbil/sUxS1y7oipJmJo?=
 =?iso-8859-1?Q?2BUbnVkMKDz/srkp7m1dcJkkkkMSVfnbEm3wZzdFg816/F+mumDqslVL0C?=
 =?iso-8859-1?Q?s//H0qai4C+KL7PXZkJifKx5K1j55cnjVBD4lKjGDOkyYlaob6OJfgImtb?=
 =?iso-8859-1?Q?yF9xDrkHVMZKQW06jsznKRA22ho1SQ1T3Sya3bCZ3o6tRDhRTjkI5NaFO0?=
 =?iso-8859-1?Q?6D0DK52qp+AQ2AfEolVgdnXJ/63A4wpkLeCSNKkX0qYLe73whup98e5wN4?=
 =?iso-8859-1?Q?00YC8TqtPemOcdnsG3WgduEzJ4a8RACqrS5uKEaprE2sdpDCMAw/2eZKPC?=
 =?iso-8859-1?Q?410EhsGKwjO2V3pgAhzN/0KooNb0Iu1GjSV5y6JH9XoJkGtZHvONHlbCcI?=
 =?iso-8859-1?Q?rnfpAV808x134sGmZLzCda9rUPT16qVUl5S/z4C9WhvYmXMUjn1j0omdR1?=
 =?iso-8859-1?Q?W+kRNKLFMBkV3DfwmFP5+Ogg2Onj4g49Jssi0bEg8whReH1r2kGFW5sOBA?=
 =?iso-8859-1?Q?UlB4vc2hK/XTAP+IOsHgLELu5dbxZB4hfublMSafJiLniRFfWn0Sa97Eiv?=
 =?iso-8859-1?Q?ywxKJcNXkEjE1tE78UOB8XLV2PelyHyeeX5/jJaWJ6etajG/CB18VVKO56?=
 =?iso-8859-1?Q?6QrZ/F3aymSydts4pgZdER4wq9jYdsdT0l9ea8+6Pz+rnDkgHp1avmgeYZ?=
 =?iso-8859-1?Q?j06N0RifbInmqGzq0lK2XNx+JvH7XLWhAAc1bpVjJ1cEb+0mXhEJkXhyWf?=
 =?iso-8859-1?Q?QAX9qLksuU56d3hV/+mDin+gH0F/Gq+K/vhICwSPRNhKHXnksuwMI8gBBS?=
 =?iso-8859-1?Q?Oy3kopNvF1dHe1b1KM0Gj4gZQbKt4J8yAAaix0Ayzmk+W6CQzcBfeJXy9E?=
 =?iso-8859-1?Q?XgYlhkY6twKL5smOrVaOI+LU8CEiwXOgWcsMtJc2uOg6SnU/xjcZ3+FzNM?=
 =?iso-8859-1?Q?MSg3lJQ/Pa0cNWhaqHpRpRwfHn2ZDMeUOewHZh7A0b+dUVDnTZZiBiSmO5?=
 =?iso-8859-1?Q?NjXeODJRVOcw1pRnz6FE34/mxB7ZsxbVYJGn/r+sKpwhJyYpJNnAWzDt2l?=
 =?iso-8859-1?Q?rljKIEXKKK654po2Ivo1TLlh9VNykDf9zHOawrxw1i6d9pPYl16pZHwGp2?=
 =?iso-8859-1?Q?kJIqKrjQ5wEEh4SyLIQYnXgLDNUwrlN0Wz3Sepfl/qi71da//1CvVQ37qm?=
 =?iso-8859-1?Q?FWUFfP5L11Oiscu1rkGydlmeqskqbCZfCVXrzjzhZI2zXO3sOCk04NnpPp?=
 =?iso-8859-1?Q?bd2uBnnYHhHl2ixABlJeI4j1NJuX5ORiqlO94OTGNyW59VNJBBl9faCDCo?=
 =?iso-8859-1?Q?QMcWxSo82MPW3s/94GHMS7hNMaaTmhn8hijW6nJfHJmXGmiM8+7eWrSBui?=
 =?iso-8859-1?Q?/wgMc1NQSRupkcettwKEN1HRhlOu/uolcJDuJsDx+xNiH18W4t5fbCN/KN?=
 =?iso-8859-1?Q?wOorHYxTXbowrhHBan+pOp+4BiacL3OgEKqyxBmEE548nlAV2zBe48ft1z?=
 =?iso-8859-1?Q?sUY/fIomFdwvfGZvbgE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6735fae1-f688-4b91-0dfb-08ddda5ec831
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3934.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 11:44:37.9108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VAsf9xjzU49MdbVT9LKN8H4y/IW+vTEbdL36OUtjD4EHk2BltPCgCmsFOxJ7zGFCfvceo3NhE7pozZcZutAs7tLgXlzGhs8nGLvwbZAE7Zs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5050
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4351C1C0003
X-Stat-Signature: 5fjznfhggeth7g184d9kj8zd5nrn1p5n
X-Rspam-User: 
X-HE-Tag: 1755085483-643371
X-HE-Meta: U2FsdGVkX19sFt2cM0aNlXbMxWCCnRaiWl4y4k3agFypzHN5KJCIHkHx0XKsHl1DaCEXmo4Qx6K8vUisW9uER3JpPRcADYc/0YY8U4daRH54emqfSeU0zKPRgB5G7CoiTZBc9G/Oa8ME046wsPN3zLlKHW7rjJRrPul4AqxvVgedQn3jvTAUzdY6CK2SmyRn+n+qjPXOOdpCFwqQc+NhxhcXFMcqZfwGp4bdRT2eaosZ1dPYcZVavaikAcAhydnH/cVyertVluNxrASQi6b7EUv2154xBTowW57hMsVTWeyY+cvOgWgSucawEJG7CN8WGkaXYEEwPZco2RM49of2DwL2U1Si35ne0YaOZW8UOC+J/7lDLG81v1JWP31ZuqAW0in2aLggu1vynWhG104YYS/Fe2DoyU2km0ti3Q903JVl8RWH0z1pcaXOmw7OUNOLm8fd8m/BPob+FPO/rzELZ4SFaMHe1SIeFMQTWqwtEwT/q+C3IAVsOPOnvAXRya1xzb9MP1NHJXpmiEvYS+gZEuvhxuGhQYQ1yb48LTFYXG0ZY4NktrR0hMcodDnChZwx4InD81T+2Z5/Y8dQIFrN+/fV080JP1HIqIhxwdAewAoPzcCdWCWFwRAP3I4lMMj5znJjYwyC/1TChVcactCWoZ2S9qeKbM3bh6eD9RmaaY6e7Us5h7wUhE8zgk/CSx4dsg7/ZqmO5sbbnAydbR34qU3dmiYN3Oqc7CCZXA5SVqRbqWKzhyzvObd1ZFEah3mJ3gHMIoGqeLQ5CVqGWZLOAQBQ/utWPDlGYnphPDgYEvZCbBB1UJ6yoSKHg9+FicT6KOCe2/RNTdgQcN6sy4934lVT4REGbI8BYOPQ5Cv6RzmppQcfsJSO+r0sF5KY96NTwfdFGWJu2GPBiHk3WTAKd6tuhJ3MTQ7EBI4neM16vtH7eVN1Jn4dnD9WsbLQMTIf/5Gfdg6MrZsYckpwW6G
 ZMpLCYh3
 LnoUVxwe37nif1qy+nIuVPoSx4pr6Wk3IleBD9o5MyHfWHgvyKmX1q6Ua2MTVh5KJJdc6ZyUMiSuvPtp7vja6TuN9JXQt5vgiA0+g8VN5492KqPLAsJRLLEBCdvVjXoWRwwuNAm84Y9PCnXjDI8muyx7JjQ5mmx+5/n/VpJJuQ5mZt/OYEs68zcgWuyE0VW19i+HVmq4nHEd3XXZ8ROpHGKAnd13Syne5VTw3/C/caSBX4JqqK6jJ3cIa5HsDUS2nZt6hb5CyM/yACx3C/PwHPKbCJqHS+9uGVaHzJn4a8/ilYN8bC4Sb4e6CQg3IqBtywHhXm1FIEiEdGEwZrps/PE5qCnhKAp6Thy4Tr+fxKehNSzNoMrs7+dptocN0jjjG1OuFrwomiQBtZR161lNBQ8gF3uc3AtApls07Lmvga6fXGMFSBYhyX8gr6+JFhWLAqzercUmKBoWdCAOjQyTw2zF+xh+zEXTr8iexWZbJH6YvCp6IGaoYBHkR7vIJhft5JUMr3pT+bAAE/fPhBgfozW0aZ3IRQ7OJqdIAXqFpedwE63TXGNSbmnIZhLfC8PuVgZA2wuXILekyWiXMFz2qk8NwioH5KWR/kPZsusDGOEbyKkq9KOLSvZaQpc22r5cdSnJtu242Ms3pjEDOnbAe2uat/saSfOihIVNh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-13 at 12:05:47 +0100, Kiryl Shutsemau wrote:
>On Wed, Aug 13, 2025 at 12:39:35PM +0200, Maciej Wieczor-Retman wrote:
>> On 2025-08-13 at 09:16:29 +0100, Kiryl Shutsemau wrote:
>> >On Tue, Aug 12, 2025 at 03:23:36PM +0200, Maciej Wieczor-Retman wrote:
>> >> Compilation time comparison (10 cores):
>> >> * 7:27 for clean kernel
>> >> * 8:21/7:44 for generic KASAN (inline/outline)
>> >> * 8:20/7:41 for tag-based KASAN (inline/outline)
>> >
>> >It is not clear if it is compilation time of a kernel with different
>> >config options or compilation time of the same kernel running on machine
>> >with different kernels (KASAN-off/KASAN-generic/KASAN-tagged).
>> 
>> It's the first one, I'll reword this accordingly.
>> 
>> When you said a while ago this would be a good thing to measure, did you mean
>> the first or the second thing? I thought you meant the first one but now I have
>> doubts.
>
>I meant the second. We want to know how slow is it to run a workload
>under kernel with KASAN enabled.

Okay, thanks for confirming, I'll run these compilations on the system with the
tested kernels and attach results to v5 of the series.

>
>-- 
>  Kiryl Shutsemau / Kirill A. Shutemov

-- 
Kind regards
Maciej Wieczór-Retman

