Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA03EFB7F9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 07:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A766B0088; Tue, 24 Feb 2026 02:15:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9481E6B0089; Tue, 24 Feb 2026 02:15:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2746B008A; Tue, 24 Feb 2026 02:15:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 668FA6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:15:21 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1706A59084
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:15:21 +0000 (UTC)
X-FDA: 84478489242.30.0BED699
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf03.hostedemail.com (Postfix) with ESMTP id EBD2E20013
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:15:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WUHcKgkI;
	spf=pass (imf03.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771917317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHQYUPbizOZty3jCuV/Vg+1w3Svtue5nrNwQvTaRtN4=;
	b=7lpPqxVWbN6Fr5CzBBmRmgkIYilugFmlzck+JnhTd8rUPH2BY+GESYk6Ms4t6Vbe+rLBxI
	hgHfvoYZLrk01lf3PXqNUzoWxryQQo1JAUOKuHivBU8D7m1s4IqVR07w0dzHrqAeqtgASH
	xPL/i1WJ8EH9bDrAaGw4V8mxWuv7Yik=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WUHcKgkI;
	spf=pass (imf03.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771917317; a=rsa-sha256;
	cv=fail;
	b=XaHx/WfbnJHnsZ31FS08dP5qin41JFFs5CLC7S2gnnuq0oncQw+u0PhCmh+YcEMBXyzc/A
	8gdD8uor8wv+qQMiiIbgCYCCOYdmD/B85A4pGOMLYEaClI/aBgyCc1VZPd3TYtPUeJNDI7
	DeNxVuwziVfOK0ueH/lzO2mlmT9QIJE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771917316; x=1803453316;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BOoATmsiBoXmylnBCpGJ5TB4N+PlCBH+nNpvQLgCDfE=;
  b=WUHcKgkIgQWYowwFN0445Vkmaj49lgyRy9GeKCZ/uqsdu3rVn6eqoDyS
   YImhWKIYwCTtY6xnrAtZiaUIuurMNEXABXgNdVanyCrJkxW7eDs41bQOA
   OdqWj89Igmob6PH34RpWNZtv/vVn8FoomcBtfgteZ7uBIx4uRyVuzgTK3
   tGSNOSW3Pxo0giQCgnKSCLCmsyba1VCmzULNH4g5dBMY/0mvOWcjgEzPb
   K2ALy2OuM2gCoxDvG9WTUOSA0rVbF2vHzY5B0H0vkr49WAT+RPgCXJppk
   GFqM3St04oCMh8SHAfK8HJmOUsIB+6tpty2h6df9qHp8jpGfynvFVSJnK
   g==;
X-CSE-ConnectionGUID: zfZ3RME5SQCgZYyvw3/ehA==
X-CSE-MsgGUID: kPd0vFtuQWmY9ibwHHGYLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="72629016"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="72629016"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 23:15:14 -0800
X-CSE-ConnectionGUID: 9ykEDPAAQkutd7QOqoCa+w==
X-CSE-MsgGUID: iuMQuyIqSl2ON9xrSBpr1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="243823258"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 23:15:14 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 23:15:13 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 23:15:13 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.29) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 23:15:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DwwQ8/XEnouQSKuLpDQPmVrVaeARhEkumuR7tHaHrA/GCpdeajmvb0BYXxJIXuvUvY3/zGvV3bEX9l4xj6ESKLWxUnA20LsICIWQzOazFDk4hWg9JN6U7kHFY1MZiIW4Ha6wbOryzhdksbtgNZxAVPGTEHnZ4aAs/NXB3K6WSlSvL4AjEPFIM9XdoU2jMSm1F5PPP3ramaYRycMRIfYnQPoK0sMpYPi+a4J9N9Eonp5pJB56UGi9lqw84NhVpSLd2XnI7jq7xEJkcgmOf/38KlYELejxzUpFTLgyPw0lWaIHGDY+iHgpm10vlxyJhlvGr3HHdKWuccVMH9HQfM1N4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHQYUPbizOZty3jCuV/Vg+1w3Svtue5nrNwQvTaRtN4=;
 b=bamrVN+XeG+1RYgDLkzHJq25BSmz8UEEs3X8DYRJffqi3dATc6tWrjgymlG5R2Moo2b+sru9MG4gWJwUBia0o9z2raK9P/CD2n0fXo+D+N5f3Oiko1HQ4iiuuf7we6i8mzY34NdbBb7q+n6aexunbgLlSNVi3WiEHMPvPVpG3Yys42UeojFrC/mffmv/IwU56zafI13Dv7/c9FsEhmP1sNuzOTJt3Z2w8qrVUWr/pNYe0H4b/cVtofwdo3TdxkPNOLoCXFstkE/2KlslcXxkjQlWtbtwoa236Xyt4/4/GMe2m0V5psxVvC2EXZVkABu8KmoE3Q53NPA1dXT7YgqfoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by SA1PR11MB6663.namprd11.prod.outlook.com (2603:10b6:806:257::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 07:15:11 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 07:15:10 +0000
Message-ID: <de501b65-6d02-4eeb-b50e-bfe5ab9b8d00@intel.com>
Date: Tue, 24 Feb 2026 15:15:02 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: "David Hildenbrand (Arm)" <david@kernel.org>, Mike Rapoport
	<rppt@kernel.org>
CC: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>, Yong Hu
	<yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu
	<yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo
	<qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>, Pan Deng
	<pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	<linux-kernel@vger.kernel.org>
References: <20260130163756.2674225-1-tianyou.li@intel.com>
 <20260130163756.2674225-3-tianyou.li@intel.com>
 <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
 <aYjmcZ4hg9bNbmiY@kernel.org>
 <6ea2dbce-c919-49d6-b2cb-255a565a94e0@kernel.org>
 <2cb55d76-4da7-4ebe-b23b-0abbc4d963f3@kernel.org>
 <aYsaBkMecDG595Xg@kernel.org>
 <b3777d0e-0b25-45bc-b387-e67fe5a0d328@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <b3777d0e-0b25-45bc-b387-e67fe5a0d328@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TP0P295CA0005.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:2::8)
 To MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|SA1PR11MB6663:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c4197ec-b39f-48cf-3b6a-08de7374724e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z2QyMmJvakx0SUROUmUvSDAwOHBaUUxndkpJb3JVVHV1V05zTGsva1BxbElr?=
 =?utf-8?B?OVloTGVRbk02Z21GK2FNY3Z5Uk15NnI1VDF5OUp3N3piQ3M2QzBUdjhyemFq?=
 =?utf-8?B?eGxCZ2t6d1dOUVNYc0ZESDRFUU5tanBaMFlJQWprTmlURS9oaTdUTjdBTU1y?=
 =?utf-8?B?WWZyNjBHUHMxU1pOM3AzZXl1OWxaNk5jZDhzdUQ3TjhTbjV6b0djSGFLSTZ0?=
 =?utf-8?B?WEwzZmgrcE0yb0tjKy9xdjJ0SmQzNi8vWGs2aURTU2tPWFNaS2FHcFRvK0tm?=
 =?utf-8?B?elFnT3JRRHhHTkViMDBnenFYSnRvQXN0U2FyU1diK3pFMFBMZFlZSW1OS0hY?=
 =?utf-8?B?YlpOcG9YOWlkVjVpSGp5R0RobUQzTWluVWV5ZnZTM1hkT1VSWTJsaWxtR3BJ?=
 =?utf-8?B?aDkvUVV2RVFmRVh3blQ4QW51NXV1ZjZ6Ujg1L2E0dzhsRHMvckQxRElhQVhG?=
 =?utf-8?B?Z0pYYllpbXBKNGhZN3lQSkZ4b1R1bXhIZ2pDVTd4TzJzV28yanMwM29TNG42?=
 =?utf-8?B?RDhMa2dYWE9qZGlxSXNEQUdTalNZN0VDdW53bXBWbUwyV3ZzSVB4bC8zREt6?=
 =?utf-8?B?NXRsdGw4WHI1ZFlWRVhPK1BKcWhjRVdXbjBNRWU2QXA0dXUyZzRpTlhiNWpE?=
 =?utf-8?B?UUFGZ2VYYWtHUVkwVWhySW5OWWxyY1VwRVk0dnNXeVRNTldqalEwUS9xQ1hR?=
 =?utf-8?B?aFhhM0JmQnVvTm96ZWRhMVpGUUJJYlJOMTMxV2hMREJoRkJVSWpoLzRxY2Q0?=
 =?utf-8?B?VkQvNnEzZjNXcnVzZHZmL1pCZ2dLSlU3VE9rQmZyS3JSbGQwSTBOODBvRDVv?=
 =?utf-8?B?RkRqVXhIT3FKMUduV2VVaVhFdmw4S3BqTGQxUXVkTHFWRjhLRktOVjA0ejcr?=
 =?utf-8?B?SWlaT1Y5OUdReE0rLzZGM2JZSW1GTTN3T2pSSTJkN0xCdkRnQTZlV0MxS2Qz?=
 =?utf-8?B?S0prM2IxOStMRWNva3M4WCt5d09SVzdkd2pJU0JQaC8zdTdjVnFSRkQ3T3Zw?=
 =?utf-8?B?OXI4MDFQMDVYbEJlMTZ5THRkS210R2cyT2c1OHV6ZmNDTmE5Ym1rWktiZkdh?=
 =?utf-8?B?dVlsc1VudkpSMXk1NXduMVlEWEQ2Lytla3A5bFBmYTVIUlFyNVA3TVhkSDBi?=
 =?utf-8?B?MkkyTkdGL3EvVVdJNSs5bUkydFRBMUlqTlUrVXZieFIvK05CTC96QW41NTdW?=
 =?utf-8?B?dSs1QllBKzU1VnVkQSsyMXZlNEpkdFpLbm9nNjFONWFDclFBNHhjS0xQVjhP?=
 =?utf-8?B?M0VYYVRKWTBXQ25uM2RNdm5ib2swQVh0SGJ4ZTRtdjhZZUd3SGxQaUdFSkFD?=
 =?utf-8?B?QjRtNldlVGFBWHROYnNRZit5SnBSaWszK3NsREw3NnhZSzFFS3pQUFpocEF1?=
 =?utf-8?B?SGtZZ1NFWmdFWmZkODEvWUI0SVZSazNrenIyL1dzcG9MN25nTjIva3lKaVhm?=
 =?utf-8?B?aGxlaVhZY3JKYU1EZ2lQMkZmK3lKaTRNUm1jY1hLenpBQ1J3dWZ6OW5WcjZu?=
 =?utf-8?B?QnAxUVZxVzRGYnpZazRza1FKdFZsZ2lRK2ZaMlRkUlZod1JYVXd6NW80eHJC?=
 =?utf-8?B?bUpWQ2crV2FsczVNUk5JSE5Bb3I5SXMvV3M5UVI2c0tnT3AxL2RrZnB3WWV5?=
 =?utf-8?B?bmlXL2I0VW41dEJKY0ZjcWRxdXFIbmU4SDRuUEZXdVZhOUl0WXFySE16Njll?=
 =?utf-8?B?eldHNlh2NUkxcE0ybTJlTEZrcnJ1RXczeUhXdWhpdk1HUlQ0YjBtbUJkNitD?=
 =?utf-8?B?SHFNUWIvT0czOXpCcVdTYi9ackt1eG52VHE2Rkt6bUQrVXFiQjdFTEdJQUJC?=
 =?utf-8?B?MHNPdm81a09NeVc3ejFsd0wwR0dvNjZXTDNWTjAxc2NvbFBBeERMQ3c3N0oy?=
 =?utf-8?B?TTJwR2dpN0JiczRIK1VqVXROcmhaWVVMSFV1L3Nkd25wYzRZYUcxTzRmYXZX?=
 =?utf-8?B?R3pJekEwKzRjT0FpRGM3WU5KYVQ4UkNmUGErMEJzV0Z6R1BDdGIrdzFQYTk1?=
 =?utf-8?B?czA2Tllsb1lZcUdqbnlFMGVXRmJ1QnY3RG55Z2M3bXNJVnJhWlFjY3BlenI4?=
 =?utf-8?B?MU9vZDd6VFhWbW9Nbk40UEF6bHRWQVlCQ20ydnJtS25oYU80UTRIQ0dQU3Y0?=
 =?utf-8?Q?Fk88=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THZ5TjBnRmxyMWlDaGFjaEtoMmlMbEk2NDBoYXd5UkJyL0xFWE5ZNEVOOXM2?=
 =?utf-8?B?ZHh1anJ3ZHFsNEZSam5xM3BhRk5RTWZGeWJmdkE0akpuNktWZGFsd1NjVXE3?=
 =?utf-8?B?d29HeE44UDh0OUVNZ2JnaVl5UUZNUnozazU3RkpYUGoyb0MxbGw1UDk5eUZK?=
 =?utf-8?B?OCt0TTZaaGY1YnBTcExpTEdKUUZMR1c2VkFEamhPTFF6MXV5SzFFS0krWkoz?=
 =?utf-8?B?bkdlOTVmZVU2VXdVNEd5Z25wS2RBdDRTOEJ1Zkpybmc0TlI2R04zL1ErbFZO?=
 =?utf-8?B?d2dWWGNZQTU1T1FmN0k1NFhqbWp2MXBNeWo4N25FeXVmK0dyaENGUWxpUk8w?=
 =?utf-8?B?V0VHaitYKytJRTZuRk1XcGNBa1JOTHNkN1NISElObzRPMUI5QnNjTTlVclho?=
 =?utf-8?B?bUtGVjhIc0V3OGFwNldqa0ZaZlJiWlBYRXpoMlVxVUN0ZWU5cXk3bXI0NzRZ?=
 =?utf-8?B?ci8xM3FkckQvcmNzdEp5TThlT041QkMxdWQyeitzSnQ0dmF2Y3BWSkRNMWFO?=
 =?utf-8?B?MVdRQWl0YTVQYitoeUhlOGRKOWNUVEs3VU9JNXJVVnhSWWxEbjRJSU1vRmUr?=
 =?utf-8?B?Mm5qZU1VZVVwRzRPNVZZS3FJYndkRFBxZVoyblFYWXFOT1doUUJhVFFuLzZ3?=
 =?utf-8?B?VnpaUU1hQjF5ZmF6em1sMmhGZzF5aXNHZldwWXFJMktUcXRFNTJVbWs5cVpC?=
 =?utf-8?B?bjFrUk9WUWQ1N0V3Vkg5ZDc4ZVRxSGJONDJFRVlnUkhpSyt3dHcyRm9SaGE4?=
 =?utf-8?B?ZyttakZFS0czdGR2YlpZaHdMRDdkazl3YXE0VTB1VHJIQ0JHWWxZTWxnbXpv?=
 =?utf-8?B?VFlybWRTZHMrTGFKV1Fzb09JTDNhWUZGdGFSTXMydkhvZGhxZEFzR2ZCTVJF?=
 =?utf-8?B?S2xPaUJMdjIxUEt1OWZ3QXFTYStNbzN6dEVwSUN0cDdXcjd0dHMvOHFqTVVo?=
 =?utf-8?B?eVVsQnlCNjRyRmNtUFFHWEpEa1RMcFowVm90cTcrS09iYm4wajhxM1RFUUpx?=
 =?utf-8?B?OFV4TUY3US8yRUJLb0dEaVVNNTRObHZlbk9JNXM5MmhBQnpIOTl6Um1FNUlG?=
 =?utf-8?B?d3VDNkVraDNTRmtlcXMvNldIRVpoNGI4VkhwRXlUYWhNNU5rMXYzTFNJUjFV?=
 =?utf-8?B?N3VHVlo3RzdkU0EwZUpBZ1ZiY0phenE0V1o5RmQzZVpuQ1RYUXh3MkIwbTJV?=
 =?utf-8?B?b2prZ2dJUkFsMkF4aDJkVXZKaHFzazFCOFFLbEk4NUNvclRsSWdqQkh0aEtN?=
 =?utf-8?B?UXI5OG5Md1RGM0VUQ2UvZzFOOExzbytOWmZyR0F1MU9OdkJlbnNUVlVtZVNO?=
 =?utf-8?B?TGlOcXFvQzhQOXVGOUNocEhyTC8zcXZoY21rd0hmOE9SVE8xVm9yOFRIM1Ba?=
 =?utf-8?B?bExIOEhsYzFhMlo0c2NwN013elFkYnRmY1F1TW1zb3JQQXVqd3ZlWUZndHpi?=
 =?utf-8?B?V2hPS0xYNVhKMHlsZW0xdGExZXNsSnZPZ1hCSE5KK2NTOTBrbHVQaVh4VWJO?=
 =?utf-8?B?SHVta3dLdGxlcHBKN0YxRlYraUkxam5wcDd1TVM3SjVVMC9WVWZiS2pVRkJv?=
 =?utf-8?B?MHJISFdkMitWenIxaEFYOU5DWmRiRGRYdHR0d0VtSE1QdlFqYldabHNLYnVV?=
 =?utf-8?B?UVJ6Mmc4RmE5clFpd1RMRjBoU1QxV3FFTCtNUmE4bm50b0taKzJOeFU2bmlq?=
 =?utf-8?B?TUEvM1c5TDdFT3o1UVczWGg4WUVMbXVuVk83SXJHUzB3YTFYTDB4R0s4M2RP?=
 =?utf-8?B?ZzNtbE1QcjRpNlJ2Zk5xbFliSkF1TndXQmdBUmZ0Q0R5SlZlUE5TVEdGelFO?=
 =?utf-8?B?QzRJWWxIZUIvTUROSTZyT1lFRzQ5VERhUFRBNmJOWVkzc0t3RUtleFdrMTNB?=
 =?utf-8?B?WkltWFJ0VEZXcEE3VDNqOGFmL2dnSjlLTTdyN28wZVg0dFVaV1BiREg2SjVB?=
 =?utf-8?B?dXp5emRtcENFZyt2QlVWRXdkTldZNVkwdkl2OUQ0MHFVSmNLUGszZkVhZ0pD?=
 =?utf-8?B?S0RGdThGOHMrMGFsalNNN29Ya2Ftd0Q2SHNEWWpxS3JLano1R1BNejZxbzdo?=
 =?utf-8?B?Nk9RMmhGL09SQ3UyUlVCWnlpNy9LTi9Td0Nsb0QycDVmNWhzaFZ5SmpERExO?=
 =?utf-8?B?ay9Fb05TU1JCczEzekdBWGdvL3BJZEhqZDVpWmNYRDJVSGdnVkcwVFEvNko5?=
 =?utf-8?B?MVQ3THB3QkxtSEtIVXFjTjl1WDk3MUVOUll0dWVMc0R2NDZqN0JGRU15cUV0?=
 =?utf-8?B?RGhtaWFLR3JNR01aT1VTaVZReGtOaTVmSXYwVnpnOTNSQnBKbGtFdVJVVnVM?=
 =?utf-8?B?WUwwd3RIeG10Qjk4R24rOGNVdG5GdFZnTXhWNmJ0UDJIeUt0aXJKQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4197ec-b39f-48cf-3b6a-08de7374724e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 07:15:10.8335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MniG2nyAcmQydFqaZX/Tvw87NjwJyPKackV2e2wpl2VlJ3iVe5vjtCn40Z9k22OZl8nMmQ0cx+knqEIWsJM50g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6663
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EBD2E20013
X-Stat-Signature: h6a15z4rc6dz9k93h1hjbd9mecbk8age
X-Rspam-User: 
X-HE-Tag: 1771917315-13022
X-HE-Meta: U2FsdGVkX1+Ub4dQiooswlO48EuNAJWrkxi/Gg+AEBkaVbij5DpKKaDpcJr8MHBSJ73QF8AQ6iYnGc7699K8t/fPhvBcNKmpDVDZs4aTIb6zGr2tRg7b55NjJhGWaE8QFTodi4YwXUO9CmwID2Pncs6y7IOLymHCAttjIg1iYxM06wZfF32Dm30QbkbuVzw6FZe53K6Bq2eQEZK1Ux/prpOsJoX8hMw7HYErnSsXnePh6UIhWZxE12IgnwIPTcQoR6k3WS6Ctyi3rQaNbcKuhOLEicQPgxsinIKOPxepJZgAOpIor+QWMOBd03clduJU5esZ5BFTQThLK2YOr8Ka5YwI+n/amJ9fwDuEeHYBFEGHh9Hey1rOzznsQfZdMzKnGyrdymvRnUN+FUZltTiRcQSog3QXh9gMg3jTeX7MS21ailDaBhWamXwRRhiDx9X752xeiunvWnpb7MJpemhV1fUu/pGRDPPLi1bU9G+jHIUZn0QmcQG2l9jxoHhW4cr4G8PaAL5rTi7VJD0lWeDv9cq70ah6Lp9AAY4mc7A71VJkDxSoLkrps6WV0zBP7YGUqYEwoz+O+8+JNITGiiitpE3kR5Lmw32Th25cBHZiKNg+mIQPeVIyBkOkK3WpTfGqs0LAX5+u9Ex0RRnXOYMsutl5lRZddgSdm56s4Q+JZlPJuL6U36ePFudEzffKopoIbOXb83FdslpJ2mS+4cvBgKxeVUzNzag8Un8iNkU9PTSli9XuTJRdLPlbj3KASb71LKGv0nSAdHsaZB1RRj+KRLybQcXOWwKzO4Fu6Q891wwO9lz0JwP694uIqyB5Vf5N6/vu1jzZV4zM2K6NWddocxQbnv8V6U9Q2q1rjqydn9VeHJypQb4F4FFRwQS44A4aa28nEiSsv1ujn3tM02nqJSIBibjpLxQpGsve7ezB/3Ry/8H40G7uOBNckams6l+zIDCeMWWSABInhvnMT5n
 XaFhzV6w
 GiuJhLAtLgr3MKjn7Zv1nXJrfMsLFUzlRkuhmT3hMx2KhueWsk2/2XrhIJGESqnXOfSSCbzrNeS8M+ny5PmPxMUAgZnstYjBRvXLa1PmCqGRgjaMPmRzX7p0QILSfb9dylFXkZyQjq4plv7QquBKb1SfYISdplnNK6CufCNgUGQA5fpIccfQiZWV0sthKZ5WP0uKlnM1wm1eLxVmK55lMFc/mSuqOyMSxwSdHiBu9ds1EH/KtVRCPB7JAQlnDAz0S6x2QEW1p66aelH8zhAGQVuD8RX1yfHcVrPKJuHf/GFqHJsFCBrzAMZiuuNlQe9f7M24zxC5J6jI37F0RRAwhR0EZdwUw3L6osw33MS7+B0cDSToZ5OEKWsNkk4XA9Kg12BjnK3ZRLjhiARa9PyJRHPeh+i6dpSdXPWxTUXS7kP2O1p8hg1IyO/IgdzIlosOsoD74u6iKQFWAqHD9hTgyLRxjTZ2NPuYM961XiQYhVd078UJr1Fb4HpsDYL4biGt9KXleq+KB1IxIGvxDXhBj/7Tmy1CSqj6TSfmgbCGlNQ4IuaCQoFC3O86s84t3yvhp9qf0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2/11/2026 8:19 PM, David Hildenbrand (Arm) wrote:
>>>        *
>>> +     * online_pages is pages within the zone that have an online 
>>> memmap.
>>> +     * online_pages include present pages and memory holes that have a
>>> +     * memmap. When spanned_pages == online_pages, pfn_to_page() 
>>> can be
>>> +     * performed without further checks on any pfn within the zone 
>>> span.
>>
>> Maybe pages_with_memmap? It would stand off from managed, spanned and
>> present, but it's clearer than online IMHO.
>
> offline pages also have a memmap, but that should not be touched as it 
> might contain garbage. So it's a bit more tricky :)
>
>>
>>> +     *
>>>        * So present_pages may be used by memory hotplug or memory power
>>>        * management logic to figure out unmanaged pages by checking
>>>        * (present_pages - managed_pages). And managed_pages should 
>>> be used
>>> @@ -967,6 +972,7 @@ struct zone {
>>>       atomic_long_t        managed_pages;
>>>       unsigned long        spanned_pages;
>>>       unsigned long        present_pages;
>>> +    unsigned long        online_pages;
>>>   #if defined(CONFIG_MEMORY_HOTPLUG)
>>>       unsigned long        present_early_pages;
>>>   #endif
>>> @@ -1051,8 +1057,6 @@ struct zone {
>>>       bool            compact_blockskip_flush;
>>>   #endif
>>> -    bool            contiguous;
>>> -
>>>       CACHELINE_PADDING(_pad3_);
>>>       /* Zone statistics */
>>>       atomic_long_t        vm_stat[NR_VM_ZONE_STAT_ITEMS];
>>> @@ -1124,6 +1128,23 @@ static inline bool zone_spans_pfn(const 
>>> struct zone *zone, unsigned long pfn)
>>>       return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
>>>   }
>>> +/**
>>> + * zone_is_contiguous - test whether a zone is contiguous
>>> + * @zone: the zone to test.
>>> + *
>>> + * In a contiguous zone, it is valid to call pfn_to_page() on any 
>>> pfn in the
>>> + * spanned zone without requiting pfn_valid() or 
>>> pfn_to_online_page() checks.
>>> + *
>>> + * Returns: true if contiguous, otherwise false.
>>> + */
>>> +static inline bool zone_is_contiguous(const struct zone *zone)
>>> +{
>>> +    return READ_ONCE(zone->spanned_pages) == 
>>> READ_ONCE(zone->online_pages);
>>> +}
>>> +
>>>   static inline bool zone_is_initialized(const struct zone *zone)
>>>   {
>>>       return zone->initialized;
>>> diff --git a/mm/internal.h b/mm/internal.h
>>> index f35dbcf99a86..6062f9b8ee62 100644
>>> --- a/mm/internal.h
>>> +++ b/mm/internal.h
>>> @@ -716,21 +716,15 @@ extern struct page 
>>> *__pageblock_pfn_to_page(unsigned long start_pfn,
>>>   static inline struct page *pageblock_pfn_to_page(unsigned long 
>>> start_pfn,
>>>                   unsigned long end_pfn, struct zone *zone)
>>>   {
>>> -    if (zone->contiguous)
>>> +    if (zone_is_contiguous(zone))
>>>           return pfn_to_page(start_pfn);
>>>       return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>>>   }
>>> -void set_zone_contiguous(struct zone *zone);
>>>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>>                  unsigned long nr_pages);
>>> -static inline void clear_zone_contiguous(struct zone *zone)
>>> -{
>>> -    zone->contiguous = false;
>>> -}
>>> -
>>>   extern int __isolate_free_page(struct page *page, unsigned int 
>>> order);
>>>   extern void __putback_isolated_page(struct page *page, unsigned 
>>> int order,
>>>                       int mt);
>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>> index a63ec679d861..76496c1039a9 100644
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -492,11 +492,11 @@ static void shrink_zone_span(struct zone 
>>> *zone, unsigned long start_pfn,
>>>           pfn = find_smallest_section_pfn(nid, zone, end_pfn,
>>>                           zone_end_pfn(zone));
>>>           if (pfn) {
>>> -            zone->spanned_pages = zone_end_pfn(zone) - pfn;
>>> +            WRITE_ONCE(zone->spanned_pages, zone_end_pfn(zone) - pfn);
>>>               zone->zone_start_pfn = pfn;
>>>           } else {
>>>               zone->zone_start_pfn = 0;
>>> -            zone->spanned_pages = 0;
>>> +            WRITE_ONCE(zone->spanned_pages, 0);
>>>           }
>>>       } else if (zone_end_pfn(zone) == end_pfn) {
>>>           /*
>>> @@ -508,10 +508,10 @@ static void shrink_zone_span(struct zone 
>>> *zone, unsigned long start_pfn,
>>>           pfn = find_biggest_section_pfn(nid, zone, 
>>> zone->zone_start_pfn,
>>>                              start_pfn);
>>>           if (pfn)
>>> -            zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
>>> +            WRITE_ONCE(zone->spanned_pages, pfn - 
>>> zone->zone_start_pfn + 1);
>>>           else {
>>>               zone->zone_start_pfn = 0;
>>> -            zone->spanned_pages = 0;
>>> +            WRITE_ONCE(zone->spanned_pages, 0);
>>>           }
>>>       }
>>>   }
>>> @@ -565,18 +565,13 @@ void remove_pfn_range_from_zone(struct zone 
>>> *zone,
>>>       /*
>>>        * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
>>> -     * we will not try to shrink the zones - which is okay as
>>> -     * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
>>> +     * we will not try to shrink the zones.
>>>        */
>>>       if (zone_is_zone_device(zone))
>>>           return;
>>> -    clear_zone_contiguous(zone);
>>> -
>>>       shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>>>       update_pgdat_span(pgdat);
>>> -
>>> -    set_zone_contiguous(zone);
>>>   }
>>>   /**
>>> @@ -753,8 +748,6 @@ void move_pfn_range_to_zone(struct zone *zone, 
>>> unsigned long start_pfn,
>>>       struct pglist_data *pgdat = zone->zone_pgdat;
>>>       int nid = pgdat->node_id;
>>> -    clear_zone_contiguous(zone);
>>> -
>>>       if (zone_is_empty(zone))
>>>           init_currently_empty_zone(zone, start_pfn, nr_pages);
>>>       resize_zone_range(zone, start_pfn, nr_pages);
>>> @@ -782,8 +775,6 @@ void move_pfn_range_to_zone(struct zone *zone, 
>>> unsigned long start_pfn,
>>>       memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>>>                MEMINIT_HOTPLUG, altmap, migratetype,
>>>                isolate_pageblock);
>>> -
>>> -    set_zone_contiguous(zone);
>>>   }
>>>   struct auto_movable_stats {
>>> @@ -1079,6 +1070,7 @@ void adjust_present_page_count(struct page 
>>> *page, struct memory_group *group,
>>>       if (early_section(__pfn_to_section(page_to_pfn(page))))
>>>           zone->present_early_pages += nr_pages;
>>>       zone->present_pages += nr_pages;
>>> +    WRITE_ONCE(zone->online_pages,  zone->online_pages + nr_pages);
>>>       zone->zone_pgdat->node_present_pages += nr_pages;
>>>       if (group && movable)
>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>> index 2a809cd8e7fa..e33caa6fb6fc 100644
>>> --- a/mm/mm_init.c
>>> +++ b/mm/mm_init.c
>>> @@ -2263,9 +2263,10 @@ void __init init_cma_pageblock(struct page 
>>> *page)
>>>   }
>>>   #endif
>>> -void set_zone_contiguous(struct zone *zone)
>>> +static void calc_online_pages(struct zone *zone)
>>>   {
>>>       unsigned long block_start_pfn = zone->zone_start_pfn;
>>> +    unsigned long online_pages = 0;
>>>       unsigned long block_end_pfn;
>>>       block_end_pfn = pageblock_end_pfn(block_start_pfn);
>>> @@ -2277,12 +2278,11 @@ void set_zone_contiguous(struct zone *zone)
>>>           if (!__pageblock_pfn_to_page(block_start_pfn,
>>>                            block_end_pfn, zone))
>>> -            return;
>>> +            continue;
>>>           cond_resched();
>>> +        online_pages += block_end_pfn - block_start_pfn;
>>
>> I think we can completely get rid of this with something like this 
>> untested
>> patch to calculate zone->online_pages for coldplug:
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index e33caa6fb6fc..ff2f75e7b49f 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -845,9 +845,9 @@ overlap_memmap_init(unsigned long zone, unsigned 
>> long *pfn)
>>    *   zone/node above the hole except for the trailing pages in the 
>> last
>>    *   section that will be appended to the zone/node below.
>>    */
>> -static void __init init_unavailable_range(unsigned long spfn,
>> -                      unsigned long epfn,
>> -                      int zone, int node)
>> +static u64 __init init_unavailable_range(unsigned long spfn,
>> +                     unsigned long epfn,
>> +                     int zone, int node)
>>   {
>>       unsigned long pfn;
>>       u64 pgcnt = 0;
>> @@ -861,6 +861,8 @@ static void __init 
>> init_unavailable_range(unsigned long spfn,
>>       if (pgcnt)
>>           pr_info("On node %d, zone %s: %lld pages in unavailable 
>> ranges\n",
>>               node, zone_names[zone], pgcnt);
>> +
>> +    return pgcnt;
>>   }
>>     /*
>> @@ -959,9 +961,10 @@ static void __init memmap_init_zone_range(struct 
>> zone *zone,
>>       memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
>>                 zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>>                 false);
>> +    zone->online_pages += (end_pfn - start_pfn);
>>         if (*hole_pfn < start_pfn)
>> -        init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
>> +        zone->online_pages += init_unavailable_range(*hole_pfn, 
>> start_pfn, zone_id, nid);
>>         *hole_pfn = end_pfn;
>>   }
>>
>
> Looking at set_zone_contiguous(), __pageblock_pfn_to_page() takes care 
> of a weird case where the end of a zone falls into the middle of a 
> pageblock.
>
> I am not even sure if that is possible, but we could handle that 
> easily in pageblock_pfn_to_page() by checking the requested range 
> against the zone spanned range.
>
> Then the semantics "zone->online_pages" would be less weird and more 
> closely resemble "pages with online memmap".
>
> init_unavailable_range() might indeed do the trick!
>
> @Tianyou, can you explore that direction? I know, your PTO is coming up.
>

Hi David,

Sorry for the late response, just come back from CNY holiday. I am 
willing to explore the new direction. Will sync with Yuan in a day or 
two to confirm the overall implementation and testing plan. Thanks in 
advance for your time to review the new patch set once ready.

Regards,

Tianyou



