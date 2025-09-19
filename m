Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73496CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 11:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC085940008; Fri, 19 Sep 2025 07:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98698E0053; Fri, 19 Sep 2025 07:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95FFE940008; Fri, 19 Sep 2025 07:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6988E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:05:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BC9513AEDE
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:05:28 +0000 (UTC)
X-FDA: 83905718736.29.23E97A9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf27.hostedemail.com (Postfix) with ESMTP id D64CA4000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:05:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z0wAORZY;
	spf=pass (imf27.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758279924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzSewiYlCB77GjMCC+SV78qBcCY1Vr8TbJXigtTUuC8=;
	b=fKQeLnD77aKlFmW4w3Hvn4GzhdZjqey7XGwHiWO6jsgCqmjrbGnbuuYJtUAnN8/kV3TsUz
	JWs8U+GT8WAVbpfxfDd9qtCJc+Qzqw8gX9bLTJVL/LvAw5e0Uqb5Y5aBXQI8iZfbpXI8zi
	c7lQ2ElpfrEGL76CnjZX4NBMhkfOCPI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z0wAORZY;
	spf=pass (imf27.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758279924; a=rsa-sha256;
	cv=fail;
	b=UJJe88JM50sfgFyW/kYNJ7louaVSPh7GgoqLIEyUTUIkSSX608LST365l40/qsn475doSo
	Eg+XAmxE1Hm/QmOwSgg1SOzVTfdkuDIu9OasWC43fVwvEKY4kFzAbHpmj9GNSqkwt5Dgva
	HJYeeFGPlCfq8qNp9v1C+zn8V0wR40Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758279924; x=1789815924;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=tmQT/DM45x9LqEn4Z+be7cJMcqqfGovpUfcvA2EwAmc=;
  b=Z0wAORZYXD2DEeq5qt23ya835Ua/jj/7KUDOVnVz+G65yLX7v1bYXHen
   pRAdY710n/UEY3DKf9Bq+UEHTiE4Asu1n4iITql32CiBLSEr6h1aa3ZYN
   TXBv1hGu9mjZqMlT1tArqXlhgmn3dja7bWFrENt2jPreVBuk1/jh1PDNI
   VHjn7DVIFxTniJ7Ad/mZ3u+u/fN9mbg13XAOICQWZ+QH7nOJ1yaQ5cGpv
   UREf5SgianxcCUy2bNxd9K3lJh6amkS0Z8wNfBaN8ZqIxlyTm4dSP/lX3
   GFMRsVtvEqnchEta2khEOEJrc5epuGHsuU88IL/S76V3B2RnlhIHsOZFw
   Q==;
X-CSE-ConnectionGUID: UErMUx1ISKqvWZGERc60Zw==
X-CSE-MsgGUID: HWrc1/stRQ6iZ+yV2C7R8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="59666351"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="59666351"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 04:05:22 -0700
X-CSE-ConnectionGUID: ngTq3oQgS1aejjTPOYa9GQ==
X-CSE-MsgGUID: y4TDpkz2QJqKi8PESSkveg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="175736781"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 04:05:22 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 04:05:21 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 19 Sep 2025 04:05:21 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.56) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 04:05:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=foQWp8I5QPp3oy5bZ5HHNgXg91TIDoReGeXTirWDvZ8t2o1WCZKAij3Od/Sas8uFr4xcN8fvrDlURWWAkDXMU6tjt6OOhDoItPnbakFZZVPuu7YW/fBcigK71q7oVzbAl1NRLtK67yT5crZqdU2uMuagiKw/M+JGtX+hj0C72iQ6BXe69I9sxfU7VEUEPbjRuVaEKjvgMpFkz6Ts+VDll6TyhxKfD1lGSOOfaK/6i1VGBRc1IsJC1oGMh7Ffj7RSE3RYnFjeYmr5QskF/Q8gFdGqlVZT3V6KlIcPIWyamMgZaHKW9mwZTPIntcTLck+7rUn4cYPZkgiocwDSy0Mr4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzSewiYlCB77GjMCC+SV78qBcCY1Vr8TbJXigtTUuC8=;
 b=cvJqi3GFXPJu+VquEa7qX4Icof79SEQeUBOwvS9Xryb98uMr9pbeuUQX/Reqz9YvA3MnpPRcUMNeV5YjlFOvwTZXF2++L+vQ/PSgcR/tl4IVAJ+C53fjtM0cZGVhUMeHlkDGaHHxFV/0kDJ4uxIxVo3hRLZcd90eNGd4ZD6MISDkqNNK66V6Mev85rQOEIGNENStWi1CKgHvOhjnKlqqAKHkRrJ6MSR2Sz6XzBOAURaGxyaaU6zYtDWKhZe2kwfUqOsRoznDZrAWM1Q75Z8Bgmgw8KYdLf/mFI9DRI/uzlEahBDW4nO54MgjBAjdgER/VY8kKWeilRxRPRTev8RWQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3934.namprd11.prod.outlook.com (2603:10b6:208:152::20)
 by CY5PR11MB6162.namprd11.prod.outlook.com (2603:10b6:930:29::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Fri, 19 Sep
 2025 11:05:19 +0000
Received: from MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2]) by MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2%3]) with mapi id 15.20.9137.016; Fri, 19 Sep 2025
 11:05:19 +0000
Date: Fri, 19 Sep 2025 13:05:02 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
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
	<smostafa@google.com>, <ubizjak@gmail.com>, <jbohac@suse.cz>,
	<broonie@kernel.org>, <akpm@linux-foundation.org>,
	<guoweikang.kernel@gmail.com>, <rppt@kernel.org>, <pcc@google.com>,
	<jan.kiszka@siemens.com>, <nicolas.schier@linux.dev>, <will@kernel.org>,
	<andreyknvl@gmail.com>, <jhubbard@nvidia.com>, <bp@alien8.de>,
	<x86@kernel.org>, <linux-doc@vger.kernel.org>, <linux-mm@kvack.org>,
	<llvm@lists.linux.dev>, <linux-kbuild@vger.kernel.org>,
	<kasan-dev@googlegroups.com>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 04/19] x86: Add arch specific kasan functions
Message-ID: <tiuv6fwtmktlibyvsvixlla6zpjikrw5zfnlv4jzq343haro46@boagnya3rx47>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <7cb9edae06aeaf8c69013a89f1fd13a9e1531d54.1756151769.git.maciej.wieczor-retman@intel.com>
 <60b9d835-b164-4775-b9b4-64a523c98879@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60b9d835-b164-4775-b9b4-64a523c98879@gmail.com>
X-ClientProxiedBy: DB8P191CA0025.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:130::35) To MN2PR11MB3934.namprd11.prod.outlook.com
 (2603:10b6:208:152::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3934:EE_|CY5PR11MB6162:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e52ba41-e1f3-4ae4-60fd-08ddf76c6b5e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bGNNbjR4TDgyZXhmaTczN2tJYWpMa2tWVWpIUjBSRDRhQnZXblBtbDZPd3FX?=
 =?utf-8?B?eklwT0FnbzBxaGdMNWlpUjh6cUE0QlEwNDVSUkQ5bHZOa09mdXRzRlhXeGE5?=
 =?utf-8?B?Vi9DbFBQdFAwaC9FbVhjREcxSzNhSG5TclI2MHN2a2Y3Qm9iK1ovVk1JcDJC?=
 =?utf-8?B?ZjJUWFBKMDRxWHZIVjF3RFE4bFFDN0c2WTFhQ0FGaDBxeVZ5YTJUdkxPa0xL?=
 =?utf-8?B?RFFFMnk3cWNJNlRyWUVXcmNnS0h0NDBQU3c2L2owVWQzbElxWFY1Sm45UXVs?=
 =?utf-8?B?RUkzeFBqTHYzcE9SL2NIQXYxclVNTmU0SVRTNDJjS3lRZzdHWFRSdE5iSmlz?=
 =?utf-8?B?SmFzQUlWc3VyN3JpMXJJaUxIa2NydkN3eUYvOTM1THF3VUd1d2ZHbUU4dXFk?=
 =?utf-8?B?VWVweG1kYTFhT3BKKzFNQ09ZRWpWdjE0SnpJUW9tbllhb29RN2xMbENTbmR3?=
 =?utf-8?B?dVVhUnNJeWxOdDJ4SlkyV3A5WDdCZi9KclUxazZ2YXRCWGlHZE5CYnlDY0Y2?=
 =?utf-8?B?aFRRVllvUEhzUmRGQ1BtaDM3Q1UwbEFaYU9uWWI2enlLcmhCQU5IcXJraWFM?=
 =?utf-8?B?YzhrU2VyNmgvRHhpNkQweFFsVmh4K1lPU2s5WEJmcmI5TVRvU1ZMTVZnRzlx?=
 =?utf-8?B?U0NUUlZEMm1VcHZ4aXdxK2VzenQ3UE9EY09wdHMzSWtkRjFCeGo3QUw3YTY2?=
 =?utf-8?B?SGZnQnlOVk0vak1aZ3d2N1pQdnNjYytVbVpDUGVZZzJnbzRGVmN6Sjg1SnRO?=
 =?utf-8?B?TEdRbW9WYldFS01SdFQ3NjROMVB0ZFBwejZyODhOaTRTaVhjaHd6K01uSldW?=
 =?utf-8?B?UW1QWmwyYlVtNlZ6cFRzazZNZzJZY2JvY3F3b3lwSUhsME9vY2hKZTlndWRB?=
 =?utf-8?B?VWJxam5sQ0YrVmF4d2tZRjFrMHpkeTVIS3lGVHVWeVI0YnFlL084Lzh6UGRP?=
 =?utf-8?B?enZZdVBVSEVaY3JjR1R6d0RVRkJRNStrTm8xS0lkdGJuN2pMRGdOSVpGb0RT?=
 =?utf-8?B?eUxFTTVuRkZiUFVLR25YNFFGMW5vcTRTMWx1WVZVbVFKQzdxTzdEVk1vdU1J?=
 =?utf-8?B?LzRsdTZsYkJIUzJLM21mUnRGdkw3UzUrRHhxV1duNnQ4elRJOXBMWDU2c202?=
 =?utf-8?B?ZUphVjlmWXhkT3VnL1hMMXhNNmxhVDk0cDlpYmtPazliblNTNFdid2tYVm0r?=
 =?utf-8?B?ZHhndEJyR2lHMWJ1S0JnT1ZuM2xCeUlEK3VBK0RPMGttRkVxSEdIYUdsZUxH?=
 =?utf-8?B?Z2QxVVJCUmZDZHhGV0UzSnJNMUhtdGtvV2s2M1MrdE9KZitkSlNsbW9xSWRy?=
 =?utf-8?B?MVlKQ1htL1MyK3hWcC85S0c0eGt0NTh4M01TZjFPSFZPS1ZQaVVIOEw3UmJm?=
 =?utf-8?B?MXdsSnBnZXBYUkVvdXkrbWl3R1NBTFQrM1Ryd3dyVnpYb0N1Vlc2ZXdPcFJ3?=
 =?utf-8?B?bGNwNGFPejhHelBFZVFhZHczV3FnSHl6aCtvQlpSUVpBL1VIV1hsVkpkb01G?=
 =?utf-8?B?S3JUOWdBdzVhb2o0SGVPWDI3Y2Rvc3YrWEtycFBkQUVabDRhTkhrRVM0dEQx?=
 =?utf-8?B?K3haV1d2YlJJOE1zV2xTQzB4K1p4RnRablQ2WlJPeXZFV0JPNmRTL29OTmd2?=
 =?utf-8?B?TUxRMyt6UDVPMXZPb1pkdXVxZ3lvOEV4dHRKNWNRZlJPKzFQQVAxaE1pOS9D?=
 =?utf-8?B?Umcrd2RienJpbjdqK3ZONFFGVWVNQXF5KzB5bXlXRzVkN1pLK0lrejI3aWhE?=
 =?utf-8?B?R0lsSnhTbGxTVll3OFJ4dlYwazlzZkM4TUk3dVFYclhEaTlvMDVTV2FValND?=
 =?utf-8?B?dlpOUHJFbThpOHVJVE9KbkdnbGpPRW4zSXh5eTJpOHRSMTBVMDZUV0ZyakFr?=
 =?utf-8?B?RmFPUHRSNklPS3NiTjRBanBud09Rd3cyV0ZDdXBLM0JOQm5Va210QlFpNHRB?=
 =?utf-8?Q?q8wS/ex3uVQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3934.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1hUV0tiaGZUa1lrUXBtV3Z4bTZaSUVoVHZxNlJ4RExWOUhXMXhac21GU056?=
 =?utf-8?B?T1oxLy9pemlaSXUxYnRpSkN1aUhEbk4wcXM5b0Y3ZWJ6allBelJVUzZpZStL?=
 =?utf-8?B?dnM5ZmxPU0NUY3VCc0w1b1dCS3hmdlNxaVhZanBMMm5lV3Y1WXdNR1JFcE5r?=
 =?utf-8?B?c2dyTmR3K0I3bXRaRGFSVmo2aGhGR2VVN3RhcVlBYW5BUXhLYXJLajJQTHla?=
 =?utf-8?B?RUlSZnZaWlhWdjhYYnlIUnQ1KzhMdlY4OGtvY3BVbUNlcVBIZDI5c2JKUThk?=
 =?utf-8?B?bXhnZ2g0d0VrdU92UzRFbjFWUzZDb3gxREVsNmlkWHdacmp3U2tHQ3JnakRr?=
 =?utf-8?B?S1JQbWVZNzZMWm1DdUlJQVAydTJuNnNPbFRsVW9qaHR4aER5Rkg1WjJBSTdE?=
 =?utf-8?B?Nld6OHJQd1ZvRnBQaUNxSXJORkNkQlNLd2M5aUlTay92WmxmTDl0anM2UnA5?=
 =?utf-8?B?bFJOanMzQ3gzQmFINVpaQ01pN0I3dC9aMVNsRUpRVlg3RkVGZ3BIWllnSkNE?=
 =?utf-8?B?WFFYaythZnhzeEtDbnJsQ2RiLzRPV09mbG0xR3NWZldsMStGOXhsVWo2MHdM?=
 =?utf-8?B?dXdhZENLUmtTZ2VJTE9WMmk4QmRWOWFFUFBpSklpWE5SOTF5dGpHcWw4Lzcy?=
 =?utf-8?B?M1hSRStkN3V5S1FsRHhDOTBZamw1SktVYXhRV3ZnUlN0VytjVGUyU280SGFh?=
 =?utf-8?B?VWVxSmtsR0J1cE4xUCs5bWc5Uy8wNGJZVWUxYjFQeFlvRklCK3AyUDFCQUtZ?=
 =?utf-8?B?a1llcXdSM0NKMVpzeWlhZktqRWVOaUpBM0pCZzFZRkVWOFRjdXRGLzVCTEtQ?=
 =?utf-8?B?dFJ5ZzN3ZFRBYTR4aGtJOXpYaENSSVhaWWxGQTdkZGszdjAwak55UHVZZGpC?=
 =?utf-8?B?UFlUa3QxVkNBbHdHak52aExFeE4vd1pYUGhaSTUrQTJhd3AzOTZxM09FWE1Q?=
 =?utf-8?B?S2hTZDVTZmZKdEdmUlFQaHIvczRpRVltaW8wS1JqY3JyUXB3MXJKZDE0TXFq?=
 =?utf-8?B?V0NtZUhhQUhmakx4WkxJZXYySXJIUndRS3Zsa0VxZkFNTHFlcU1Fb0pCcmtX?=
 =?utf-8?B?eXA5SDdFNUFJVUIwemNuTE9rdEpySnY4R013ZTJuOTAya0FUdEVRYUlzVUkv?=
 =?utf-8?B?SmdzQ1Z5cFpydFg5dXhSY1BBeFlXZ1QzaElnVmdRcDlmdTJtb1FQNVc4cC9h?=
 =?utf-8?B?dVU1WjBtam1iUlhKcGhscUhvZU1IU1ZyZTg1S1BpWkdGZHIrMjNRcHpuMUxW?=
 =?utf-8?B?V25FaEZRM0pPZHZHQ2IvSU1EaUZ0bjhqQk5MczB2TC9NL0FkRzByOXBqQ0s4?=
 =?utf-8?B?SlBLV2J2WWhDcU1lYWY0SjltRld2a04zdGNiOTRGdkZKdzhvVVpoc2tBNkU4?=
 =?utf-8?B?NU43SVJ0eXB0V3daZ0hKL05VMW5BeDE0SXlITk10dVhWbTBXSm9ma1lFUGRu?=
 =?utf-8?B?cUZERnZkWEU3NUpadVJ0TkRQOUprb3dzam85RkluSU9VUDduTjV3cmJuaEs0?=
 =?utf-8?B?SHdwalhTeUMyUThMemlDMnNyKzZ6M29hN2h3SjJ3bHg0SGhzdG91NUkrdHZZ?=
 =?utf-8?B?ZlZ2U3lJaDlsNkNKUS9TSjlIUXE5YjBEMHRRYlo1a3VNcUg1NktUZ0g1VSs4?=
 =?utf-8?B?QnhLMFY4YlAweUhDL3hHZU5oVlErL3c2djAvUC9xdHNWS0JBQUJ0SWJKRmU3?=
 =?utf-8?B?UitpMVJjek9RMzJaR0tmOWRlcjB5MEp5NWRscElvUEppTFFFNzM0MW9UalBl?=
 =?utf-8?B?VkttVzEzSW4zOFdVNFN4ZGNTUUdUQ1BMNWFaazF3Q3hTQ1M0QVBYZXZvbkxF?=
 =?utf-8?B?cUg1Q1VQOWdHbUNjdFF5VXNUZFJzWHJTN0VYaTB6NjZQWlkrTHpiZTBNRmJq?=
 =?utf-8?B?YjhaUFROUVRic2VTMFRycWpXbVFPVmpGSDFpVStIZmpDTmF1REVReERPcnJ2?=
 =?utf-8?B?ZWhKRituWUQxbVFJYmhKa1ZkSkRmY3RsYjJNMEsvTDljZCtwdTEwMHNFZU9J?=
 =?utf-8?B?b0xXajdUaUlpeE04STdOdXV2aGhXZlVYSE93eVFnRFVodjhFa0lqck9reGh2?=
 =?utf-8?B?WWhUc3hOa2xsSHFvVVFjMkJOMENjdldzZEU3ZWI4Z3RDODNZdWRNUTZCc0tJ?=
 =?utf-8?B?Mk4vRDRtcEh0NDNqV2NFUlJRakxXUE9NUHRmQzBSZ2pBZVlXK0VTcXNVV3Fk?=
 =?utf-8?Q?5NteVKDy5juoeadYsPi/L0s=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e52ba41-e1f3-4ae4-60fd-08ddf76c6b5e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3934.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 11:05:19.0681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vgBrksATT1HSBTu4iWSKlQV8dupkEDk/NOHbesUjYNjzEgOXzlQX/n9MUgIIxyGzH4TPuj17VVh4bbsk0N/EOjR5CMNPqxEpe7zDQ/990zY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6162
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: D64CA4000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: e7msjxmsdwd6droopp5awnowz9tr67uy
X-HE-Tag: 1758279923-329249
X-HE-Meta: U2FsdGVkX18DUegcjguF0h/5zxmrwVtIsaEEk/Z9bnBt3WO9eeG8Cr7WqcezMcPz22YKzsvyWcgJvr3olwna9VIW9JNKoR1qzD0nphmURKRooo4KEhJMzlq2P04vl2uRLrxkKYlblWONGoyb8Zuhzenet7LpXXpg/mIiOGMCXld28+29WIxmhvbNAAEJDKnRjO+QG2NYJsHcBsSfLJ1DbxrK6a6vJOXa7DpHwQf393nCacELby1bd1Jo6dlQYOhKsIpAkiQveS2e+S4TcKiXj8tFEjNPU45CmefijryOe0SODjy12zl+DoGNloj3pQ+vVLFHNDGHLCD+aNN30qrmH4m+ffaL7ir/vRZHGYbywhPvni6Ql+ZPznJbpnmf6t4khg3GE5oebiG0mcfnAr9NrBC+WpTlOShodPEgokIgBjuNtuHja6Q2aTTHnlDzqZdIo7jO4lZK6SmIWq51/+eJruWEPqt6aleP6JCi7+yIZPlaGcnOZEM8+GPjJlaD7pPII3g1lqg7zkFUuLtk+X7FzMTcTozh/LnS8vWrH/u9ltk6nexjWmsF1SRrnqBpjc1cYbvAt8Dpn9vF61AJGmJRLVZ9GTVIiWVjxwLSpHB7tJlUEn8sPGtPO6Q7KwRIgMXDmOWfQGm3sFxpt7wKbDQIjr0pGHuTdmzqO97KKdshKII7BY+cvn0hyF2t5I5P//p6916MOlFYFkPMuBnZ/eYEpLWxCZkK/j3mOE6rdDDSb8Q5ZLNZxShs8w1O1iZqrmr+MngcO0tVWBg7UM7MzkxSYfk/7MCgmRkGVkkQASIDYQa/CYR9ugAdzxmdQVNbM2o2UjMNwtBLsqlWuaHitGB8UxCrOrNUcLya+pUM9woZQHdZE5Ar4r912nBuhRGmRlo/gj2rzVrjUGkU3ne7h1+A3pozeTTQ9AZFMAVoXchayr/tWr4s2YeOks31N5oC96vg/mICfZKT/hQJhkf1KQ/
 di0+IyBd
 XdqYnSwyPqN2+azpOObfNPFPfe8h02kArt4SSwwySdoexc794EA4rAjlWYFJGj05XeksK7lSg81dzLnIlIEUngnNAV22iLEL/4rcdr43P7PcoL0schxglnuB2LGWt+NKZToDDySJiQc8M+3zYwMd1jyvbGMqtq091T0+4VFGN4om/Ct9zZK/J6C9VcwQyXJyd/7T+44YejMWOKLq+o7MW2bci0djYwalfU66JwJL8SF0uqGzAYVKbpewQDgYEEv3m5W4tK6W6unFlRWV/OgGGFi/MkvPBwPItWbBCaIBpLgbaWTOrsL4QyGf2Ba4OtNYO9ykJp9vk2bXo+d3lvQD5HaCe0EfbwQirTJ9/3uyyA5AmxmzsnHCNcylosj9B3y/w6qHIBZiFXqJnMNnwjCV6hWOcUdJuKDHlypmKMlopnxkmxzf4a12ZLPPdkMkLno1HehkURKTDKPZo7ohC93tInh6LytZ3TJbPznZhV5qPuV/7UJj7SuoPFfAq59LXDgmTnIEEUgVUDHEj4F69RuMZrAAgqzttj146Q1LvHXrTFaw/hqnfemxWsfkR1VB6nxX6gF1dvez0D2qwz8uRqrDqR28yq16g49Dh/40UDJ+ptDSA1kokDFkr/SamVZwuadKqLFpcxQGflJwkPoZK6xBCyqicCe0dAVTY3u3E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-18 at 17:52:39 +0200, Andrey Ryabinin wrote:
>
>On 8/25/25 10:24 PM, Maciej Wieczor-Retman wrote:
>
>> +static inline void *__tag_set(const void *__addr, u8 tag)
>> +{
>> +	u64 addr = (u64)__addr;
>> +
>> +	addr &= ~__tag_shifted(KASAN_TAG_MASK);
>> +	addr |= __tag_shifted(tag);
>> +
>> +	return (void *)addr;
>> +}
>> +
>
>
>This requires some ifdef magic to avoid getting this into vdso32 image build process,
>otherwise we'll get this warning:
>
>CC      arch/x86/entry/vdso/vdso32/vclock_gettime.o
>In file included from ../arch/x86/include/asm/page.h:10,
>                 from ../arch/x86/include/asm/processor.h:20,
>                 from ../arch/x86/include/asm/timex.h:5,
>                 from ../include/linux/timex.h:67,
>                 from ../include/linux/time32.h:13,
>                 from ../include/linux/time.h:60,
>                 from ../arch/x86/entry/vdso/vdso32/../vclock_gettime.c:11,
>                 from ../arch/x86/entry/vdso/vdso32/vclock_gettime.c:4:
>../arch/x86/include/asm/kasan.h: In function ‘__tag_set’:
>../arch/x86/include/asm/kasan.h:81:20: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>   81 |         u64 addr = (u64)__addr;
>      |                    ^
>../arch/x86/include/asm/kasan.h:86:16: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>   86 |         return (void *)addr;
>      |                ^
>

Thanks for noticing that, I'll fix it :)

-- 
Kind regards
Maciej Wieczór-Retman

