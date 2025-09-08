Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA866CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1583C6B00A6; Mon,  8 Sep 2025 10:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1305F8E0009; Mon,  8 Sep 2025 10:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A3A6B00A8; Mon,  8 Sep 2025 10:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE62E6B00A6
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:11:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8318BB6A78
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:11:32 +0000 (UTC)
X-FDA: 83866270824.15.9C59E9B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id E138F40003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:11:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DhgVh0gf;
	spf=pass (imf12.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757340689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6z266Ho0fJjxJcuxNplMCMhZ1+YyVayULXocY0SO5/A=;
	b=u5Edt6DiWvj+KnHTXn3HfLndr7opqkDOmlYjnYewPbChd40WKjmeMh3aZcCPAywFrWg40u
	WV9drcb5eJr+OX2Hn7TbSgtoymiZGc8f+LBNuWz659d9kcBu3Whm4a/h96ewAfAghLLveH
	5GA596FG922PPSYpeA7Qy4rl9AU3a+0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DhgVh0gf;
	spf=pass (imf12.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757340689; a=rsa-sha256;
	cv=fail;
	b=IuFh+Qz59hyEYWutzbvXdjvL6Zv2dVSQcyzEREtZu7AzikIwOlA+W53mfGipesObDE78YK
	R/AshxeGDMQqbpOA0T4BRNH4cWY3+YZppa53nJy2iRgWI2b6aMk463C56dNXaTfWIthFCy
	00RtoJvr0STDAoqucdTmNru6zcsMsYo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757340688; x=1788876688;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ZtIQlh/sbIj3lNh4M6GH9Mr163csTVPqNHj9YjNx9Mc=;
  b=DhgVh0gfYzjB7g8YXSMbbu4ZI0sCAunxAFmva+yHW37IA2835g0DQ59y
   v1ddk8GTKC6kPLFjwaXQ7S+ZjrYFfqmBLLbPXzs3ycqKE+IbfhvUEaRfu
   4Kn/Orfu0jFBUX/TSu4CYMws3Mj6VaMC3O1u/Kg8bWH7ZhUIs7jQm+i3/
   LhV7UhMY9feA+173mPeRUCNPUBOeCLdN6A10WiFXCBx5ACyYwqBLFmpoF
   m7CasgG1Hg6uQfamLmaJ5wIhzHuoPLNntH1nmFhoixxQXtllwtZWrT6B7
   +h/IFlqHA7MCRjuRudB+vnped+bXqWG123XgVhsVk2IzgbsSp8NQ5cx+c
   w==;
X-CSE-ConnectionGUID: Q7VvJU3AQk2m6ZpzkhtIWA==
X-CSE-MsgGUID: Qbx/oKtzRh2vCDCPVkzg9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70218777"
X-IronPort-AV: E=Sophos;i="6.18,248,1751266800"; 
   d="scan'208";a="70218777"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 07:11:26 -0700
X-CSE-ConnectionGUID: uuPNgqKRRzOV2SK/VMazbw==
X-CSE-MsgGUID: TV8J3wd4SnaRALo01oc17A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,248,1751266800"; 
   d="scan'208";a="178019883"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 07:11:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 8 Sep 2025 07:11:24 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 8 Sep 2025 07:11:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.51) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 8 Sep 2025 07:11:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wD8tv9fKu1Ce3mjc6LOAqPxRtFHzJUSXcGnVhKspF8NtdcXcpfunnlPtuJzj6qPMWQl5Pfe/xulYLeg5/s+Fny0nySvwIG6iCQWg3wNjixo9LWwfqa7zX8gvPmkGnkowzM+XVwkmxWgqB1MdlbtW0niMt5Lfko3uV8bcoRIoNGGOICTwgRgqjHNrJ9iNjteHgfn16UlwKBByAb8vI3lBF0aT5OOI2bNXvWXUT3kKiPvVGQMnrMXBRqzHAGF1O7fVW3LuRz3ITtXnpT0GQGLCniaEkQZO0u25aw95BkHha1OjtF94hNRenZwjNhOIxo/R4Eyrp451Wi/nF7h9sG+y+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6z266Ho0fJjxJcuxNplMCMhZ1+YyVayULXocY0SO5/A=;
 b=M8Ma666Jlujp3ig1fSU+UqKf2tXV1TBqhvUcgzjH+Rf3ryud51WWWaUUlo99dquOPFS+YEeWpqIF3r9TLiLM6b1zWVPydY5Z+1xSgxrChaNdnmEDEmwFg9n2MhsZ0SA1ed8faYWA2G+oBrA1oy5W1zns1e2BWqgeXt7AfkQ3/oF5P2R60Asdu8d+Jhp2354iH65/n/2Es5NjcOgJtrA30+s3PUJMnRPZOmbfy8+eXy7wJNx2cvqsaGT8s4VCE8dn8LCGMoYJumWWGDT2i6leHUZ/7bOOfbrOIFRZXsD1jWLSwhXHlNEa/+GZIZWIZ8urwDvko+E4j9EEsV/lkMZweQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3934.namprd11.prod.outlook.com (2603:10b6:208:152::20)
 by CY8PR11MB7135.namprd11.prod.outlook.com (2603:10b6:930:61::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 14:11:16 +0000
Received: from MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2]) by MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2%3]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 14:11:15 +0000
Date: Mon, 8 Sep 2025 16:11:00 +0200
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
Subject: Re: [PATCH v5 19/19] x86: Make software tag-based kasan available
Message-ID: <f2z4nvob7qwhjsfsxu57weicoqiuu4weyi5axtd2vcb6n2gkhe@cvkypdtyrrg7>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <3db48135aec987c99e8e6601249d4a4c023703c4.1756151769.git.maciej.wieczor-retman@intel.com>
 <CA+fCnZd2824w610t86xQk+ykfv3EyAOvhb_OuXjru5e+jE4HTw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZd2824w610t86xQk+ykfv3EyAOvhb_OuXjru5e+jE4HTw@mail.gmail.com>
X-ClientProxiedBy: DB9PR02CA0010.eurprd02.prod.outlook.com
 (2603:10a6:10:1d9::15) To MN2PR11MB3934.namprd11.prod.outlook.com
 (2603:10b6:208:152::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3934:EE_|CY8PR11MB7135:EE_
X-MS-Office365-Filtering-Correlation-Id: 33e1615e-d818-4968-9105-08ddeee192e2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SytyZHgyQTV4eEM2elpCbWh0WDl1N1hSK29UM0RKQTBrb1lKY2s4UzQzWFJD?=
 =?utf-8?B?RFNFRzJWSFk2aHJGczFBRnFXYWEzL011UzB0TlRhTFFJdml2Z1ZQMXZQNWpC?=
 =?utf-8?B?WjNOWXVCNVZnSG5UaW5lSVp4VlFXaG5IY3JjVHlPU08xa1pZVTI3c2lMTTNV?=
 =?utf-8?B?SGJlOU1IYXlRdmRDMGpwTnZySzV0NEtQamJ4dHZZdnFTSDZVbmJZM1FobjFM?=
 =?utf-8?B?aXArS2dMK0dXNVBIQkc4T3krNktCamVML21KSnB0bDBJQWw2YUdVUWZhVDlV?=
 =?utf-8?B?akZLSkdlOU5RSDZvMDZ6VlRpYTYxWnFabkdHd2xHdU9vNkUrK2thWFNpL2Zs?=
 =?utf-8?B?NzZWc3VsbVV3b2tUK2FSYk9EaUtqZ2lLbGlIQVJCLzR6UGlSM2x6aUdreENR?=
 =?utf-8?B?Q1JIY3BTMjBIU0NxYXIwc1F0S3JwS0p1M1ZGUS9VMGhxd0FWSUhTdE16TCtD?=
 =?utf-8?B?WjhYeDFCM3VvaWx2THRYYVdHYUkwMlpiS21nSUJRNWVmQ2JmN0wxeU1WUGVl?=
 =?utf-8?B?WHh2dWFreXZSQk9zOVZaaEdodVJrTUM3WVJZR2xQc0taWkorcFI4UW13eGh4?=
 =?utf-8?B?TmpKTU1qQXhoYVdvSjJveDZwQ3pFWEx5S3hTbURiRDhOckxvMnZBckNudjgr?=
 =?utf-8?B?d1BOYklQdjJpRm1YcjFqNk1ieWJOZjNIR1N2cnl0Sk1oNEhvYjV6Q1R2S2p6?=
 =?utf-8?B?ODZtM3pEQ2VFTnZzOXZQMTRSM2FvR1VIbGQ2bzd5Z2Y2dy82UUwydTNhVFoy?=
 =?utf-8?B?Wk1Yd3FNeU9OOXBFMXdQSUVQUndvVnJFS0xQVFdJU0YyaWlXcWJ0Mk9ENHBP?=
 =?utf-8?B?SmlvUEVPcUI2WWZrbjNSODd3QlpsY2hWM0lPZzVabmZpaERRcXhGcmpIS3kr?=
 =?utf-8?B?clB6S2xVNzZ4VE9HazcvMmJzdEovdVp1WVdWaHo4V050VkxXSGxqK2xyS1FX?=
 =?utf-8?B?TjM4d1paT0ovdFVUK2Vrd1loazJVRGFidlY3Wk1rZ1BnVHR2cWhIemhuRFIr?=
 =?utf-8?B?YnJzVVRkN2t0UGVCVysrZnNKeGV0aVZUTjNmU1duRzBTRUJWU0FTc0RVOWNy?=
 =?utf-8?B?ZDBaTW9oVGU1TjNORlcxYmowL1grVlhsTFpMak5NU1FxTmlNSHZUYVVtQTVY?=
 =?utf-8?B?NXlJVXhVZTdxWk5uU1VtVzFiYlN2Um9pbGtWeWpmTTlJQkd1Mlk4UzZIY3dz?=
 =?utf-8?B?WFNEcnhqRVVqZ1F1SUtZQXpsZWRDSzQxT3IyV2JxUXNFdjluVGZ1eExTMHpN?=
 =?utf-8?B?REZoUTNIUlhZeWRicWVmQ09uY2tnR2dsWEt4dkNhSFFKQ0xJdXFLWjBCeURM?=
 =?utf-8?B?WXY3ZGNtUll1NGoySERMRTBiUXl6VTBwaVY5YjZYU2lNSGtvVWUzNkRSMm1B?=
 =?utf-8?B?WGRhdmFQYVduVTJ6cVpSY2w1QWxuZWNsTFo4K0gwOEVTZ1VmRGlJR1hsbnNV?=
 =?utf-8?B?Z0VCNFJwbEd1UHh2Rk5FSDV1aWtQazFub2plcEdLKzFJa0U0bHhySGt2MmdY?=
 =?utf-8?B?OG5KY2tuVm5FTFZFekxnaDN5eEJQaGZENm9BRi9SYVh3amhlQjUxTnpxalNl?=
 =?utf-8?B?ZDFzYXUwQVdxVzVrZnBMelJjK2hYdmdWWjBpVzNVV3FtYzRsbHVaVGk5Mzd3?=
 =?utf-8?B?Q2hha0laNjJ5WHZZaWkrdlc5b0lJM0R4Nm03UGtQTjR0dFBtTll4VmtvdGdS?=
 =?utf-8?B?STl4eXZVZzVwc2g3L3UraDJNMVBZTUZtWmxPYWJyVTVpdnZXb2NjS1A5TVF6?=
 =?utf-8?B?MTVTNi9aSEQ2d0I5QUh3MzMzREJxQ2ZzYTNXckROUnVxWWlFeEpmWUxqWHZI?=
 =?utf-8?B?ZGxOeEc0R2RvSDhuRUVaNWpGbEh0V0liMGFJV3BwOGVBUE11R1hhZEk0OThq?=
 =?utf-8?B?d0twcGdLZlFsV2wyb2VKNlVmNHlITWtHeXVnQ2p1SlBTRVFRSFNDdVFCRlFr?=
 =?utf-8?Q?E7TNRVHma8o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3934.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NG5TRmZ5S3FCM2hBcTBKRUNVR3JRK3g3RnFlRnpxRVdyV0hsZTMwbVJ2Z2pC?=
 =?utf-8?B?RkF3Z0tLSk9HbVB3dVBhVlRjQzR1ZUJIcFp0R2tUZUJCTUNzMnFVSlc0RWxx?=
 =?utf-8?B?NXBTdGdXQ2l3VVRnWEdTRUJ0dHJraDhXOFdKdnZ1bExsaklBRVFpL3hMcVU3?=
 =?utf-8?B?SE8xVmpRYnFXUW1iSHllUTBjaTY3OFo3em9zckJkYmM3WHpSQ3lWdU9sYnYz?=
 =?utf-8?B?V3ZHUmtVZDZybW9idWpPNnZ5dGFxNXNtakZTNjNwNWFQYzYxUThXU0tvUXY3?=
 =?utf-8?B?NktqSXhpQjBUdEpHTDVEQ1BvZlR6L253UkdkNk9ES0laYTVNNFpoeDEzczVy?=
 =?utf-8?B?SmlnaG1JNGtodjZ3cHV0WTV2UHlsOWFUTWc3c0Z3ZlUrbmd0WGFGSFZFb0p2?=
 =?utf-8?B?dldDNjlLNWdTeEJ1azRMOThpd29WdVQrTmZRVkM2bnB6VytKRDJFOGpEV0NI?=
 =?utf-8?B?ZHhLRTA4aHVTNG1aT3d1Ym94VlduRTR3WXBlME9IZk4yekVEbVpXZkJLUmhq?=
 =?utf-8?B?WjFTNmx2UHJuODhBU1V4bFljR0pOMnZWMG5IcmwrQ3E1NkJhL3hwaC9iQlZj?=
 =?utf-8?B?WmtyaE15UEZ4WU5HSW1zUElDZXNxMk82U0w2VkQwTHhabnU4dDZHZjFzTXRO?=
 =?utf-8?B?dXJ0c2pIWlRTbStlZXd2bkV3SG1xMTFxMVZSRjJoa0pWekJOMlc1UXhtT3Jz?=
 =?utf-8?B?KzNyeS9MQ3pWRXZ4YytvQ0ZNa3p1VDdjR1ZTTkUvTEJQdXNyUTN5ZytFcnlW?=
 =?utf-8?B?ZmhVRitSQUZvSnlpVkJIWGNMZUlzNzAxdXhJYnc3QVBOWlFLS2c0U3IzeEIr?=
 =?utf-8?B?UmdyYWVhLzdiMHJuRDdoK2llY3N5S3V2YysyWC9ZR3IrZkt1dkRuQ1BiZ2Vz?=
 =?utf-8?B?bEVHdS9ZQ2NUaTFobVBTWVpua082aFJDakhPejVBN2czeHA2OVoxZVJqR3Ir?=
 =?utf-8?B?bC9Cb1pPMWZIUXV5eVlyNDA0TmFDMCtiamRIUjNaT0w0bmQ0bEhvaGpXOG1M?=
 =?utf-8?B?WnNsemxLSW4yUllVRUVXZnBueWtuSVRnS0xYOGN0SUU3bXRYcDBkV2tsaUpu?=
 =?utf-8?B?YW81RXlGb1VHZDE2RlNqZ0V4c1lrOGwrNHB5djMyTHRnRmJQRUo5WjVVRTJa?=
 =?utf-8?B?YUdrMGl6SFJwT1Rkdks2bDlNenM5ajlrN1BCQktyQnMvYzFhNTR4ZksrbjNw?=
 =?utf-8?B?VnQ4RndUTitpNUozb21mYlZWR1NFd2FwbktDK1dJUDd1U01PNmtiUXdobzJH?=
 =?utf-8?B?WTBOQ29LTmU0OWR3ZGh5eFZiWXJxZXVpWmJpd0lGOVhJVWlWWE44bGxUNHdm?=
 =?utf-8?B?UkdUam9kNURqTEJFcjVoTDFRVDBZZENuMjBXMFArNmFsVW4wTGZCQUNjM1Jt?=
 =?utf-8?B?bkRvZmpXbVh3Tm1BOXAwbFpnd1I2SWNidDlITzBZQWt4bkFleDU5OFZiODVi?=
 =?utf-8?B?NGo0YjlwSTdNOGZRSHVtTEM0MGtmS2Y4WVdWRGtBcTRJN3liazdiMEtTcVBj?=
 =?utf-8?B?dCtGNGhYWDB0ZDhnUXJKdG9yNkV2MWpldFpSVnRIRFlrdDd2SkNmYjBheXZr?=
 =?utf-8?B?ZHJLbkF4SWM1c0tRSXhPMm9HVlAyK0kwRzFOOFFVR3k2aEwzd1NlMHRQRmhN?=
 =?utf-8?B?aTJCQ0h0ZCtmZy9yV1dPWnlZZzdyN3pjKy9RSVh0OUtaTnU4WndKS1lDaFpo?=
 =?utf-8?B?OE1wWVhXR1FjVnBtb1piR093UTRoVHNFNTdxQmt3VjNWc0owZ3JNQ0QyTi9P?=
 =?utf-8?B?UjNmc0I4N2VqenowZi9WVThLMGcrRWJUajFjUXVOTWExWnZyVlRNU2FSc2dh?=
 =?utf-8?B?TDUyS0l0czlBSVJHTGwvdmZvbWRzTmdZaXdWR2MzWGdONXA3WlJXODBxOEh3?=
 =?utf-8?B?cUhjRlNBeVQ1NEEvTDVsWHVwZHR2R1pNeE5iOGxhNmZQNmp5a1JCODlwSUpZ?=
 =?utf-8?B?T1pOK0VWSXQxa285U1N2OVVVcFloQjkyRGEvbVg3SWF6eUFpbG8xWEpjdnNU?=
 =?utf-8?B?NUVwOTVja1JCMXJKd2lWb1pjNWN5c2IxdUduVHdCMjZuZUdyTm1KZ3NtTEcr?=
 =?utf-8?B?WEJYV1hzZGpVVlJaRHYvMjlaYnEwMlY1MXFHTmYxdnNYV21NdjdLdkJKSWNK?=
 =?utf-8?B?OXBDT2phb3JSc0QrcTJXOXNyQ0F3SFFaTVFhQnRGbk5uUmpvQ3E3Tk5Gcldk?=
 =?utf-8?Q?+aLkBX/r9SaM83LKsJ7DeiY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e1615e-d818-4968-9105-08ddeee192e2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3934.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 14:11:15.8262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+mu7GnrnWK0CCNb9LnKG4WS8RUGBKWRlXCA/Cfjt/bc+J3gafJkP+TFL7xbOLM9BS7pAwXcMMMorZ4T3p3O5Xk4WuQ+0BVhAnI60zmQrJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7135
X-OriginatorOrg: intel.com
X-Stat-Signature: c8rytsq83dc9594yzi4exikgxwhhsi47
X-Rspam-User: 
X-Rspamd-Queue-Id: E138F40003
X-Rspamd-Server: rspam05
X-HE-Tag: 1757340687-549253
X-HE-Meta: U2FsdGVkX19hhUTMpPQ2dpuwmlp1AyZ93bljRMCcOwurRMDvXnIJxRwHaffoGb28xk6eqhRQ30LSRQm357eXek5brV/drSHMhSUGIEQtbFzylp/FV2AG9wAYj0x2mckp5ihkk2ttssFsMBYxARksQgwOsrz5O+Tkw3ZJxhXLjxgn4H9l8LYSELPQ0i+slvrhv5Xzf2jeb2ZYVg8zNrCmNEZmUabuBy4nNy6aODPfK2WBqcf181b370aSaeXR+Ulnu0yyrZKSFlW+8DMXII9Tc8H/g5ZloOx8kAtIBYf0sIGUzwbXm43sZ8J6DvL4T6lD+mNLX13zlo2KrrAQgBInPxfL3E8wB8lRP5uVdpqDjsggiDwRMrQY4vedaaEoJHtcsVyrO5EH0Zp1ywwkZ1LH031/dwIF8/sCdhdsbCQKEHOBv6UyNKQHjL19sRRzOkAzTabGAzXE4JgDihsaXV2MTLOIXGCuPfPSb+6cR6tUSVQoEjjGHWopcq/m3DadJvGrpDjHwkZVkWyrvDhPfMhMUblpqCPrEuDfyCg7v4mLqD3Jh/r1tfkBsKRnXlCbIEf4R4S9HwwBrHt/ZXD3kBn+FQbMLnoz69KxDwvWXCMfDPqml/LPd+FY62r2NyqYuqQRyXUmVDOrURw80b/VNuL2lOAgCv0Sxp3BR4cIInlGhQA4827W6Tjg/e2VDIaKva9ID+TXViz8ZW+sDbaFG8z/yCUVcB+PLk2dJFowZFaYlA02doR4+iICeyqgW091y6Ngf7bkgOdUD/NZ0ZprsRQsT57vZQbxk0lHDzwF9a0Ee7uYvP/WY9FJCmI9E2FavGzc4hzhA1goIvAWNsMzEFTFu8C6HS8+0dMKwujsqPvReN7OavI9v8sscBJAQW0y21w1DP7FNYWNV5x8MqOvbZAKxOqps8kSYp0qwgG547y8yq+pHuskEnCapt7xIzlixSXZzHZt48c4+tIgsHyDvxw
 pwINTEe5
 OjUwiHJqYlwABRGptvJTTSUJdr8/c4XH6KX3LU0rj00oB2yLu6MClHptwYCoYNlAjKcgmZcUhTVNvjhxANWRJthVRBQlPpkj80owWZ0v0DF4aHlKvd/v5d+nJFx9XXshV8NsrQ1xdlhIm4mUe0z1LBk7SsqClHsKMAbz8hbPR5F1SSTLOKX9cgnIoCZY8eU9LWNx8bj33StBytb8Ro4sWulJouB5toYpucZIvzMMyPhm3RLYccsRUh91ZwWAi/scKCYyhMTbWC2y3o8emEF0/5/p9oMnsqmoXGnGryAV6upqCe8h7Cvk/HS//kxASkFreRUMi2/E4rTUGlrTUvabltXDvvJyFY7uJYxHlSPrEdltfHnCqB51xc0jpym9N3uTcqKIJFgFhabQ8Oh4PIrSmO7E5BQm8vIAF14wN7cj+j98NQ3syTN0H3k81+d9PJfCAJRpBe7DzcYx9i3wzh4H6ru1VbuEuHuQRf/v6zYqwyHFnKXx+Dzr7Guqxr/lXLOrZDHJi/rHnlcJZKzHKPZLSu1XTwmk4TWmPorQjTbvVziw1iB3HHHFSp3lyyucGvcL0OCLk/A16LHYnj5Z0Qi/lWep77UY5AJo7Pp4xm09X82fzv2naLpU61DASeur/QPBeeogrch5sv86aXxj0+vI6YRMElaDck+5xHqh4sS4X2A5aZTXF2rUjqTMU6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-06 at 19:19:33 +0200, Andrey Konovalov wrote:
>On Mon, Aug 25, 2025 at 10:32 PM Maciej Wieczor-Retman
><maciej.wieczor-retman@intel.com> wrote:
>>
>> Make CONFIG_KASAN_SW_TAGS available for x86 machines if they have
>> ADDRESS_MASKING enabled (LAM) as that works similarly to Top-Byte Ignore
>> (TBI) that allows the software tag-based mode on arm64 platform.
>>
>> Set scale macro based on KASAN mode: in software tag-based mode 16 bytes
>> of memory map to one shadow byte and 8 in generic mode.
>>
>> Disable CONFIG_KASAN_INLINE and CONFIG_KASAN_STACK when
>> CONFIG_KASAN_SW_TAGS is enabled on x86 until the appropriate compiler
>> support is available.
>>
>> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>> ---
>> Changelog v4:
>> - Add x86 specific kasan_mem_to_shadow().
>> - Revert x86 to the older unsigned KASAN_SHADOW_OFFSET. Do the same to
>>   KASAN_SHADOW_START/END.
>> - Modify scripts/gdb/linux/kasan.py to keep x86 using unsigned offset.
>> - Disable inline and stack support when software tags are enabled on
>>   x86.
>>
>> Changelog v3:
>> - Remove runtime_const from previous patch and merge the rest here.
>> - Move scale shift definition back to header file.
>> - Add new kasan offset for software tag based mode.
>> - Fix patch message typo 32 -> 16, and 16 -> 8.
>> - Update lib/Kconfig.kasan with x86 now having software tag-based
>>   support.
>>
>> Changelog v2:
>> - Remove KASAN dense code.
>>
>>  Documentation/arch/x86/x86_64/mm.rst | 6 ++++--
>>  arch/x86/Kconfig                     | 4 +++-
>>  arch/x86/boot/compressed/misc.h      | 1 +
>>  arch/x86/include/asm/kasan.h         | 1 +
>>  arch/x86/kernel/setup.c              | 2 ++
>>  lib/Kconfig.kasan                    | 3 ++-
>>  scripts/gdb/linux/kasan.py           | 4 ++--
>>  7 files changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/arch/x86/x86_64/mm.rst b/Documentation/arch/x86/x86_64/mm.rst
>> index a6cf05d51bd8..ccbdbb4cda36 100644
>> --- a/Documentation/arch/x86/x86_64/mm.rst
>> +++ b/Documentation/arch/x86/x86_64/mm.rst
>> @@ -60,7 +60,8 @@ Complete virtual memory map with 4-level page tables
>>     ffffe90000000000 |  -23    TB | ffffe9ffffffffff |    1 TB | ... unused hole
>>     ffffea0000000000 |  -22    TB | ffffeaffffffffff |    1 TB | virtual memory map (vmemmap_base)
>>     ffffeb0000000000 |  -21    TB | ffffebffffffffff |    1 TB | ... unused hole
>> -   ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN shadow memory
>> +   ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN shadow memory (generic mode)
>> +   fffff40000000000 |   -8    TB | fffffbffffffffff |    8 TB | KASAN shadow memory (software tag-based mode)
>>    __________________|____________|__________________|_________|____________________________________________________________
>>                                                                |
>>                                                                | Identical layout to the 56-bit one from here on:
>> @@ -130,7 +131,8 @@ Complete virtual memory map with 5-level page tables
>>     ffd2000000000000 |  -11.5  PB | ffd3ffffffffffff |  0.5 PB | ... unused hole
>>     ffd4000000000000 |  -11    PB | ffd5ffffffffffff |  0.5 PB | virtual memory map (vmemmap_base)
>>     ffd6000000000000 |  -10.5  PB | ffdeffffffffffff | 2.25 PB | ... unused hole
>> -   ffdf000000000000 |   -8.25 PB | fffffbffffffffff |   ~8 PB | KASAN shadow memory
>> +   ffdf000000000000 |   -8.25 PB | fffffbffffffffff |   ~8 PB | KASAN shadow memory (generic mode)
>> +   ffeffc0000000000 |   -6    PB | fffffbffffffffff |    4 PB | KASAN shadow memory (software tag-based mode)
>>    __________________|____________|__________________|_________|____________________________________________________________
>>                                                                |
>>                                                                | Identical layout to the 47-bit one from here on:
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index b8df57ac0f28..f44fec1190b6 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -69,6 +69,7 @@ config X86
>>         select ARCH_CLOCKSOURCE_INIT
>>         select ARCH_CONFIGURES_CPU_MITIGATIONS
>>         select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
>> +       select ARCH_DISABLE_KASAN_INLINE        if X86_64 && KASAN_SW_TAGS
>
>Do you think it would make sense to drop the parts of the series that
>add int3 handling, since the inline instrumentation does not work yet
>anyway?

I thought we might as well put it into the kernel, so once the compiler side
gets upstreamed only the Kconfig needs to be modified.

But both options are okay, I thought itd be easy to argument changes to LLVM if
this inline mode is already prepared in the kernel.

>
>>         select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
>>         select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
>>         select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
>> @@ -199,6 +200,7 @@ config X86
>>         select HAVE_ARCH_JUMP_LABEL_RELATIVE
>>         select HAVE_ARCH_KASAN                  if X86_64
>>         select HAVE_ARCH_KASAN_VMALLOC          if X86_64
>> +       select HAVE_ARCH_KASAN_SW_TAGS          if ADDRESS_MASKING
>>         select HAVE_ARCH_KFENCE
>>         select HAVE_ARCH_KMSAN                  if X86_64
>>         select HAVE_ARCH_KGDB
>> @@ -403,7 +405,7 @@ config AUDIT_ARCH
>>
>>  config KASAN_SHADOW_OFFSET
>>         hex
>> -       depends on KASAN
>
>Line accidentally removed?

Yes, sorry, I'll put it back in.

>
>> +       default 0xeffffc0000000000 if KASAN_SW_TAGS
>>         default 0xdffffc0000000000
>>
>>  config HAVE_INTEL_TXT
>> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
>> index db1048621ea2..ded92b439ada 100644
>> --- a/arch/x86/boot/compressed/misc.h
>> +++ b/arch/x86/boot/compressed/misc.h
>> @@ -13,6 +13,7 @@
>>  #undef CONFIG_PARAVIRT_SPINLOCKS
>>  #undef CONFIG_KASAN
>>  #undef CONFIG_KASAN_GENERIC
>> +#undef CONFIG_KASAN_SW_TAGS
>>
>>  #define __NO_FORTIFY
>>
>> diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
>> index f3e34a9754d2..385f4e9daab3 100644
>> --- a/arch/x86/include/asm/kasan.h
>> +++ b/arch/x86/include/asm/kasan.h
>> @@ -7,6 +7,7 @@
>>  #include <linux/types.h>
>>  #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
>>  #ifdef CONFIG_KASAN_SW_TAGS
>> +#define KASAN_SHADOW_SCALE_SHIFT 4
>>
>>  /*
>>   * LLVM ABI for reporting tag mismatches in inline KASAN mode.
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index 1b2edd07a3e1..5b819f84f6db 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -1207,6 +1207,8 @@ void __init setup_arch(char **cmdline_p)
>>
>>         kasan_init();
>>
>> +       kasan_init_sw_tags();
>> +
>>         /*
>>          * Sync back kernel address range.
>>          *
>> diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
>> index f82889a830fa..9ddbc6aeb5d5 100644
>> --- a/lib/Kconfig.kasan
>> +++ b/lib/Kconfig.kasan
>> @@ -100,7 +100,8 @@ config KASAN_SW_TAGS
>>
>>           Requires GCC 11+ or Clang.
>>
>> -         Supported only on arm64 CPUs and relies on Top Byte Ignore.
>> +         Supported on arm64 CPUs that support Top Byte Ignore and on x86 CPUs
>> +         that support Linear Address Masking.
>>
>>           Consumes about 1/16th of available memory at kernel start and
>>           add an overhead of ~20% for dynamic allocations.
>> diff --git a/scripts/gdb/linux/kasan.py b/scripts/gdb/linux/kasan.py
>> index fca39968d308..4b86202b155f 100644
>> --- a/scripts/gdb/linux/kasan.py
>> +++ b/scripts/gdb/linux/kasan.py
>> @@ -7,7 +7,7 @@
>>  #
>>
>>  import gdb
>> -from linux import constants, mm
>> +from linux import constants, utils, mm
>>  from ctypes import c_int64 as s64
>>
>>  def help():
>> @@ -40,7 +40,7 @@ class KasanMemToShadow(gdb.Command):
>>          else:
>>              help()
>>      def kasan_mem_to_shadow(self, addr):
>> -        if constants.CONFIG_KASAN_SW_TAGS:
>> +        if constants.CONFIG_KASAN_SW_TAGS and not utils.is_target_arch('x86'):
>
>This change seems to belong to the patch that changes how the shadow
>memory address is calculated.

Okay, I can move it there.

>
>>              addr = s64(addr)
>>          return (addr >> self.p_ops.KASAN_SHADOW_SCALE_SHIFT) + self.p_ops.KASAN_SHADOW_OFFSET
>>
>> --
>> 2.50.1
>>

-- 
Kind regards
Maciej Wieczór-Retman

