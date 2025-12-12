Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E659D4336B
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 05:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D85F6B0005; Fri, 12 Dec 2025 00:27:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AFAD6B0006; Fri, 12 Dec 2025 00:27:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E806B0007; Fri, 12 Dec 2025 00:27:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51DD56B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:27:59 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0C148992B
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:27:58 +0000 (UTC)
X-FDA: 84209687436.16.DE01BB9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8F00140005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:27:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HJDoDoAv;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf11.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765517275; a=rsa-sha256;
	cv=fail;
	b=CeMW5lajZ/gOKdqPfN/d5sh2eh1vQN8MwLCTi3ZHj3yXCm+dQ/CIatJoDsIfVShMttlNxR
	uHT9LneTku0G1Hf1B6gHF5YoP++zRHmQFOkWXztyhp3G4Kzvsrli073xVl8iPdn79pUSec
	+m9XSNsZUUEDUvRlFt/IwsMqM9H7/io=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HJDoDoAv;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf11.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765517275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hm+r/DnLJakxPacAqQScagRz2NkiVebcEelDUmfDaLQ=;
	b=4gMKcjOOUrMz9O/ijBZJZBsAm9jeABc4VwVe1H59Bh/hYdiVoiz0GEh10pA2zOD8nhhC9l
	s/zom/v8Ohllr3jGceVD4GUQLxFzPs21jMtNQ2voSUUYJn56ORnTIJC+EPZCfd4VNJGf5p
	9ThIVbeTLR8FJTSc/gdjQwyOu1RRxkg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765517275; x=1797053275;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ca4cAp65YC4JDglaXVd3uq5EagqA4/2GBBwca9w4yDc=;
  b=HJDoDoAvGRBDU5T9+GXXRDDbkiex7XK4OH3N5kgmWeMXW0ys6H9Dbrol
   QCto75/0dA/1dBTQS2KcTYnO5lgC3K4/pHk1atreASbDr2yIjF/A6xre0
   3UTwixS2IsynDImTrZtkP5y4tnxHchqMGp6M1atLb0Inv/QtH7amDgXxl
   I0i3+Xbm9b/WK+jLj5P6aTZz8/Fwh5OZuyotTLDJKJTlvrX0701pfOrYe
   AuFCg+oJCKahUc5zK0aOdhU3IGoMN3E3gV9j+lzex7Pvg09ZlQD+TXahR
   CbXJ4UeL9m3cLev/F+uMGG1V6trbd1hoejieIFykGDz6IjnkXnNxsokgA
   g==;
X-CSE-ConnectionGUID: xeye/Wv5R8KMdL8pzkdICw==
X-CSE-MsgGUID: bpr90f4LTleGzAkMexu+Cg==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="66687957"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="66687957"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 21:27:52 -0800
X-CSE-ConnectionGUID: ib6gGjYDSfOOOhpqrop69A==
X-CSE-MsgGUID: OVjqGNG2Th+IObuLvVIAng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="196898401"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 21:27:52 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 21:27:51 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 21:27:51 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.14) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 21:27:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cSlFdbBgb3aALxwnNu+XwcCM/x7U7z2jl2rvL7UkpWKYJ2m7ISNPTWjDv842PBC68ErgCdVyvJY08sZoX73AS/EVdLALXDZDwYKmctTurEmBdNTJSO+C847utJwDi+5peOLfoacyzK1S3chAcVl65rVK3sJrVWIDfwwwp1rqw5QiQdQih+u3cj4FSBdZ3J/H71pd9QSKlx0Mn4Q3yxTAyix/y7MHecUOK47dMlN7AOxb/IEBtTaFrc/I37BbV6nFElfPXA1Px+caelGLZQb/S0VkPTOVaXhNA3zS+Kvi1IXMs7fZnz9Q8jUcupuq4VIlL8lu6nzLgYoVGYtwV8C32w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hm+r/DnLJakxPacAqQScagRz2NkiVebcEelDUmfDaLQ=;
 b=h82IaDh1xzGsCOM4Bo2mI0hJDvRDSvEt7xwrsAQK3xhIBw3ssViBXk4ohvDdS9tqvvx+sergyVVej1OmdTbI4es0FhN7HXsu3vUK9LZtpKd2gqayiCRFYw5mKiGwuO3hz85I6DlC4ouDVEGrt3fIRav4QxAt+A+p8Nm3bMyM8BVJvAXV2vwkzd/3KRVGDajbtlTmenYmt7hRdlhhOrvHpM5HaEZPs1OrjSw70wfQW62RZ/ZgBnxtRVEq9JKxgKDXEPaAwFImsKiKDy84NO80GmCw1Y8orANJHCtnrbbvu0XGGkgK5iK18iHuqf/JwqWDLSSXUc6OIeGAaQwCrDG53w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB8281.namprd11.prod.outlook.com (2603:10b6:806:26b::20)
 by IA1PR11MB7811.namprd11.prod.outlook.com (2603:10b6:208:3f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 05:27:43 +0000
Received: from SN7PR11MB8281.namprd11.prod.outlook.com
 ([fe80::e4c6:587d:ede3:2f85]) by SN7PR11MB8281.namprd11.prod.outlook.com
 ([fe80::e4c6:587d:ede3:2f85%7]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 05:27:42 +0000
Message-ID: <4a81dd12-1bba-4a89-821b-7a12edc02e04@intel.com>
Date: Fri, 12 Dec 2025 13:27:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: Oscar Salvador <osalvador@suse.de>
CC: David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
	"Wei Yang" <richard.weiyang@gmail.com>, <linux-mm@kvack.org>, Yong Hu
	<yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu
	<yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo
	<qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>, Pan Deng
	<pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	<linux-kernel@vger.kernel.org>
References: <20251208152544.1150732-1-tianyou.li@intel.com>
 <20251208152544.1150732-2-tianyou.li@intel.com>
 <aTpRoUt0WvEULeKE@localhost.localdomain>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aTpRoUt0WvEULeKE@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TPYP295CA0042.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::20) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB8281:EE_|IA1PR11MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: ffd4ac1f-3f9a-4779-be64-08de393f2af7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L3VhODFCNGdlSmxVWWJMN3I3SVJHdWpnWVM1eklaUmRvYlhNUGZuZ1ZZdldt?=
 =?utf-8?B?dWJpYnM3WlkrTHBFMUtpZVU3SVVsSVBRNVdiTm5zbVo2ZzIzbFJka21ZTWhB?=
 =?utf-8?B?b2ljWVJjRTZYSlVEeU5WUnpZSS82RkthTEJvT1RvYVBFT1JlK2s4S29CVXpk?=
 =?utf-8?B?ZlBUYUFsaXovUDdWYnh3c1hCOHc4T3pCbXFSWVBESGVLc1E5M2NGS2ZaUU5j?=
 =?utf-8?B?eWU1ajJqTmJsNy91OUFnWElhMFgxZ3NMTC9mS1htVmVseDFXanVTcUp0TCtk?=
 =?utf-8?B?K293djllUEhzNXFaS3lVSnkyTlNxMHFvZDNWdmJjdEhTQjloTG5YQmJvK0tw?=
 =?utf-8?B?bjFEQVEvcDFXaTFBZkQzWWxvQjNSelU5cWEyeWtOVmtFWm1WUTN4SE56MzRH?=
 =?utf-8?B?MHoyVVpaekZvL3BaZ0tSOEZWWm9ET1ZxMkNoa3pDUkJiMzFhZDZOY1F5SlFO?=
 =?utf-8?B?dmE0bWpPN2phQ3hWdmRrYzBHWEN4SndqUDJuTll4a0FlaDZCSkNwZFRFOHFF?=
 =?utf-8?B?ckU1Y2FWcHJUUWRFRkhFbkdGNk1sdHRsekgvbVdEcU1nSnZMT0ZWL3EyREFQ?=
 =?utf-8?B?NHJHVEF0Q3ZteHByQzdJK3dYVU10MnNNRU54bUwzUGlBMXkzZlVvQStPZW5o?=
 =?utf-8?B?TXZDK1BkcEF5Y2hGc1RLeWdJYUwwNGV0U0kyUWg0Nkg0Y2VqNSswQURrbEo1?=
 =?utf-8?B?N0ZMN3hrUDh2cVpnQ3RScjlSM0NUSDZ6T1JGM3lsVm1SbGhnbmFHVjlyaEJP?=
 =?utf-8?B?U0JXck1tOTkvaTNUK0RkRGJ0Y2tsVVRucm42RG4rWGR0Vmtja2JaWHJDQUZN?=
 =?utf-8?B?S2dueVFjNGNOU2NNQ29RdVN4bmJ3N2JLZGI3TXRCMHhrcGNZdytYd0hvNnhs?=
 =?utf-8?B?RnVYd083N0NiRDJHVDArTUpEMzVUWWR4cHFCYXhjanlOZ0xOdk9zM0Y1cnhM?=
 =?utf-8?B?ZkJJaFdkdUh3TDdycHZURlk0dVkxd0lTR0pZVUlsdjI1V1RDQklDSHBmOGRC?=
 =?utf-8?B?bU9rYTE4ZVE3czdTOS9VTVo4R2YrUnQrbkt3L1NrK2ZTZHFpcTJYQkY3aXps?=
 =?utf-8?B?U0pxa2M1b1M5Uyt6eUxGNTZoNXhGZkVaWittRUdIeUF1WTRUSHNjM3ppS3kr?=
 =?utf-8?B?NmRaQVFsbGtmVWNYQ0dsNTlFS1lBaENhYUNiSi8veXVJQXhmR2tBUEJ3NG1C?=
 =?utf-8?B?NFNyT3o4TFVpVG4zZ2ZGZ1pBYlVxOWIzNkJSdXljQnVlSmlGRDVMR0xYVFV2?=
 =?utf-8?B?NHhqbHV4amhRaGRpWmJiNEJUWlQxWEt6NUVXOU8xTlhCQ3N1QVJlQm1qdUZo?=
 =?utf-8?B?SHI5eDJRdEl3bFl5SDc5RGRNV1gzM2MwWHA1Z2FhOWtlenpYMWE0TDVLMHVp?=
 =?utf-8?B?Y25lZ1pEcjhkNnhIcENWTllBRzVONGNGcXZUd0NEaVFqUDlGL3NFaGIwL1Vu?=
 =?utf-8?B?azY0dmsxcVZCWW1OSlUya3prRTBlYTNaUDVuKyt1U2pqc0hPZHBKMnFJSnQ2?=
 =?utf-8?B?SHlHQ2F2Z3lEb21PbDJJVEQyZW5CYkQxb1VLYXRSRS8ycEN0WTBCbkU5YkNu?=
 =?utf-8?B?MUtNWjE2b2pVaHdDS0F6WVVBMzVDckFGY004SFNDaThyS0t2V05xWVlNRmdD?=
 =?utf-8?B?RFJYa2FFUml4MjZQcHpxdXh1LzV2RUdhZ2ovTFlUMGs5NlAyTTUxc1R5L0lh?=
 =?utf-8?B?R1c5dEpWSDlsNW9oSHBwNUY0VitEcWZOdTBwT1h4Z0FJYTFtMk9DbHM5UEgw?=
 =?utf-8?B?MFFaME1aaTdRdGtUUnk2aU5lTkdvWnU5VTU1SHNnaEdLdzRTYStCTGhkR0dW?=
 =?utf-8?B?MXgwN1Zka2JzRVZqT2N3WGtOUjVmWkJLYjJNTGxadUJLWWhNOTJ0UWkrQm9z?=
 =?utf-8?B?a2tnUmFpZkpIT3dNV2lGOWpVVitYUWZGczZxZmNmNEZySWlaeFNsRFlHam1x?=
 =?utf-8?Q?/VFcZw+6qIPNu+lEPyo8O0kvK10kk810?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB8281.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm5pRUV1RVFpNzZNcGF6NElQSGJEczh4SzFoYW5sdGpzcFh1VEV1TzNyeFdV?=
 =?utf-8?B?aDArQk9uUDVWTHdoUUJpNSsyVnk1QUZzNFVoOHljVjlFUEtmU08xUkVxN1Nt?=
 =?utf-8?B?WllPNmdsYlV2MlZIK2pBaTZKcXpRS1JheXRkeGV6aHZHMGpUTWFabVNzVnp6?=
 =?utf-8?B?azd4MTRJWkQwTU9JbG5hR25HcE1rY1BOdkpIM3ozRFRnVUhRK2lTeXh1alpV?=
 =?utf-8?B?S0NCMURWdDAxbmNmblBpcysyWHhCSTF5QVlPa1JYMTZiR01SS2YrK2dMZ0tJ?=
 =?utf-8?B?d1V4eE14bHorbWNRSisrLzhVOW5qTFBtcDNnVE1seDhPODYwQkFqMXQvNEdu?=
 =?utf-8?B?OWJLcWFNQU5LaGNoaS9udzJGdkMxbDQ4Umw3dnJ4WEpkOGppUzVQMkg2a1Uv?=
 =?utf-8?B?b3dvYWM2MUFMYkJtUDlORkhjeTFrSDIzQUU5YWxBMWdmSU5VQ2xic0V2elBl?=
 =?utf-8?B?d0lRa2xRRDRWS01mdlBKYk8xL2FDU09VNmtiZjhRcEJMUW85S04xdG9JK1lQ?=
 =?utf-8?B?WjJPM1BadVI3a0xNMUZuYU45SGJZYUhTTUt3Ym9wdFJJTXM2SkFzNkRiejRt?=
 =?utf-8?B?OXJucC8rNHR4VXVpNlJvcEw2UTQzNUtvVW5zdUR6ZXdmK00vYlgwZ0J4QXRP?=
 =?utf-8?B?RDJNSW83VUFma21TMEo5NkJiMEsvaHhrektIYWQzQmtQbVAydVg5bFRxQUV4?=
 =?utf-8?B?dVhZMTBsZmhhZmY0NEQ0Qm5GTTc4OHJVcHZ1dWkzeE9QRldrL1g1eDdSU05R?=
 =?utf-8?B?TnAzNGhjTUZBSlU4M0pTRHRFQ0IvbnIrNVpsanROdXA4Q2lkSGp2SDdGUWNu?=
 =?utf-8?B?bWhRUVN3d2RNYUtRYWYxVVE1VU5KRVNHOW4xelQxU0tZRU1GWWVZUHpvcUpR?=
 =?utf-8?B?Q3BOeHF2QTJMa3BrblNCOG1McndjK3BPNmc5ckE2clY5NzdJOC94dklYa0x4?=
 =?utf-8?B?dDBteU8wQWZLU1pSU3hhUUhWWCtJSmpVMkhIUk9uSWVoNWtZckpPOEFNSUdp?=
 =?utf-8?B?WEQ3cHNFTlpWS0h4ZTJFMzg5SkZSMXAwMEUvQlBCRW45MUpmUndCeTFQY2Zm?=
 =?utf-8?B?anF0SlVCYTRwNFA3WUdQYncrOXZ2WDYzZmFyRnRkMTlBYWZXNUx4Y3hxY1Rw?=
 =?utf-8?B?Q3R6Z3VnK3lUVXNLSmJrZG91NFI5RXBXbWhRci9PdlVyc25zTUNHeVlxWEdl?=
 =?utf-8?B?eHFvbmVqK2pJRkRjek93TGw1dVBWcEVRQmxrb2hiOVpoQW5jQmcvamNCdWpj?=
 =?utf-8?B?eDJ6cFNueWFMblNPWjY0NGVmakVUOEhvc3pnZFczZE5BczFpLzRzR2tpSnZt?=
 =?utf-8?B?ejhYKzMrNjY3V3hrWlkzMnpWQ2NUKzY1TTl2d1lmZjZoeWZBNzVQWXc5S0tD?=
 =?utf-8?B?amdQT2xFdzM4ZWlQazZPYm1IS1RmSHlabjJrbVg4cFUwdUlIUFoveGFYQW9q?=
 =?utf-8?B?bFVXaTRaOC91TWJjZDhTdENyZFNuRUZDUW9HYmVVcmhlbUFmKytQU25lRXpu?=
 =?utf-8?B?TjdaQ3pPc0JHa2ZVK2QrL09BYTVsWGJ6RE54cFdTZUhDNCtQUGZHcFRYQk9x?=
 =?utf-8?B?T3pYc21MWFZYWlpxb2MrRkNjYzBvREdqZnJwQ2VTUk81NTF0eXRNSnRsaE15?=
 =?utf-8?B?QWhjRlRSV28yTFVUVmFYQS9HNys1VTc3RW0rSVJUa2lDKzhJK3poT3NUaFFX?=
 =?utf-8?B?OUFqUlhKbnplalZhMnlEU2I4YlE4d09OUGEzSWo4MW9WM01KMy8vdDFTYVpr?=
 =?utf-8?B?U2hLN1FJR29keWNtSzQ1QVpIYzQ5MktJNkI2ZmRXNVZrRkEvaElWSU9HZ3Vx?=
 =?utf-8?B?amlQbW9CS1FQbmNSVmE5WnNDVHBnSnA2Qk9BT096UzkvMHNqYURCeVg0U1ZC?=
 =?utf-8?B?OUlDbTg2VVo3Z0dIeHhDSU9HL2lzS0FlVTZZa0RyNFhCMGFMMjcyeXRBNjJW?=
 =?utf-8?B?SE1IUU51dDNTODQ0Tm5CSlg3VkhTZ2c0SzNWVDhiT0ZMdWc5Y2hOVFd4cWhI?=
 =?utf-8?B?V3JjVGhVUXJPMmVUR3JvbnhpakV4UTdqRnFsR2RUaUdXcmZQc25KOXNuUVRX?=
 =?utf-8?B?a0lxQUUrWVNUaWs2R0JDQVpkNk1EU0t4c0I5TjZGWEl1SXY4NFIvdFYvVTh3?=
 =?utf-8?Q?c3VZIKxYIrH9ePUgbn89wUSip?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ffd4ac1f-3f9a-4779-be64-08de393f2af7
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 05:27:42.6524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1+dgU1cXTfxV4hEhIIIBzFF7wHKcqzlnj8KU28zWyyZTMZ3fSpIYY+c6Ju6MqIjTW8qH72FCs0R6/n+K2niJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7811
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 8F00140005
X-Stat-Signature: qqbsf1dq4dn71jyudzkexwzpkdar1asg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765517274-49332
X-HE-Meta: U2FsdGVkX18pEhYaW9/9YeWQEcqsd11tBQ2HER02p5Fc4IZadSRY4vVQrD23czexgqrFpLrPgVsye5akv32RusRSqnNa9PebzwvxnpPZ/CrZUCrHD3589nGteG7QESNn+0CjRIDvdr2+aC6fBvck88fFSoU+iuEa2XRKT+e8ptcLgUuLWp5nEiNF9SI2yZfwXzmFyl7dl7iTJFIM8CUe4u0eEeGvqjzhKSz1EC/1S7+b3vlsVRVLjbNH/qbJoVXmIeKonp0VQivXijsOaZzbzLSXmvPVRJxQe81Rm2mrNmcttCJd8Q6W23vvajDzkaiGNw1ZVD+FQTYjSNFFseLuRmwZylLICSRvtxEraInDRU8AsfC44JdlMyxjencPiLLAbvIiou4Ga6lv26iJWjxH3RIaaEXum6bJe2/0eXU9VXdv5QiYdoblUVnt5HIiUUy37BUIXN8xlBKn4sZCJPvZmkraxYEjWolsfhoW41IRYd4PE2JGqRv6GrumT+DKmfFAWhgSoDcpPUxiGVLDjQvbWjDREdRxoz+b8N2NnyeHOH+CeyxbKyLttmP7Zfu0VPmvRQLPKhOCmKRmUNelyHNFnWCjkwbcH/x3b5ieLu0CqfXM4DWm5S98U2bB11mKbHnNEt+wxwncpcTJfNFP2/x7R9zqRPz9jW22zC3712oaeFNvwydZwhwnZIhNHAHYjUw/IvqpRp10XzGbIT20VCw3pzWDaaO8kTTEDZBHSfO+JTzWnelwdAIR6NqcnKS8SVu4rC537/BisstDMaXzvbEJKWEftQ7rvLBDnUlSPEEalwwlx6g9829spaM+U2J+ntAmDmaVatbsxlYCg7sCmi2Q5CHH4dTn8OxMWxtMEhUGzQFiVLdb1lzpBs4Koh5mBcMu4Z4/mbfRMBZg6fc6akSIfAOKafqku955VZCTjwd/BAfwPDOLJeF5zRjJpW/0E5VUnqNY9usvdd1sJAMKH1p
 VjoH3iYj
 k7ew8q9XXRVWceimhdk2/CX2+wgE2DhxuCbzam4AQO7hpTCotWMxA0zXkOF4NArQT1W+kowF7j23mPrysjDaFRoct3+Hski2n6KlxN6gYFyhTqERQAjHPqP7XZjuwln8LrLFlFhKSf+kUegZhfAHg5EsHYrAMEpN4bKy4BBo9RI5UcG2BnbX9t52cWFGa8NtfyooxaHWM1SWXRg2F5T2pvy2dZ2Tzc+A4B/t71c+ZcWz3VitZroX9swRIhP10rKxLJAJqfsGeO2RjfEDD6dMmx2csM1H2LRGOjQaIg00kqxgJhF05i/96FbtCMDUPH1XxMGlBk8tnTmGjmBMPSD+6g7G1DrmMWxhU+mHoPJiEMasNxkoQizUwvbM6G/H5O1gZ8X878YZmwoOSWoX4mfuaaUNoZwqef9gmKbOQzYVmHlTiM3KXLvyF7HcnKry5oau6ZCZ1PGChSehUWRRsDhl1UJUo5YeFYhwNUX/MfQKwtQYozg/cYhRz6V96dmQV+aOSYLbrcM6JR/fj4VCUgR8C8TwMpj68WpopioftPS5e7IIPS+8UUCuwLXDf867swwM5c/mFIx4mW+orWd9ikYJ5nVJOdO1kVxnQdu7G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/11/2025 1:07 PM, Oscar Salvador wrote:
> On Mon, Dec 08, 2025 at 11:25:43PM +0800, Tianyou Li wrote:
>> When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it will
>> update the zone->contiguous by checking the new zone's pfn range from the
>> beginning to the end, regardless the previous state of the old zone. When
>> the zone's pfn range is large, the cost of traversing the pfn range to
>> update the zone->contiguous could be significant.
>>
>> Add fast paths to quickly detect cases where zone is definitely not
>> contiguous without scanning the new zone. The cases are: when the new range
>> did not overlap with previous range, the contiguous should be false; if the
>> new range adjacent with the previous range, just need to check the new
>> range; if the new added pages could not fill the hole of previous zone, the
>> contiguous should be false.
>>
>> The following test cases of memory hotplug for a VM [1], tested in the
>> environment [2], show that this optimization can significantly reduce the
>> memory hotplug time [3].
>>
>> +----------------+------+---------------+--------------+----------------+
>> |                | Size | Time (before) | Time (after) | Time Reduction |
>> |                +------+---------------+--------------+----------------+
>> | Plug Memory    | 256G |      10s      |      2s      |       80%      |
>> |                +------+---------------+--------------+----------------+
>> |                | 512G |      33s      |      6s      |       81%      |
>> +----------------+------+---------------+--------------+----------------+
>>
>> +----------------+------+---------------+--------------+----------------+
>> |                | Size | Time (before) | Time (after) | Time Reduction |
>> |                +------+---------------+--------------+----------------+
>> | Unplug Memory  | 256G |      10s      |      2s      |       80%      |
>> |                +------+---------------+--------------+----------------+
>> |                | 512G |      34s      |      6s      |       82%      |
>> +----------------+------+---------------+--------------+----------------+
>>
>> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>>      object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>      qom-set vmem1 requested-size 256G/512G (Plug Memory)
>>      qom-set vmem1 requested-size 0G (Unplug Memory)
>>
>> [2] Hardware     : Intel Icelake server
>>      Guest Kernel : v6.18-rc2
>>      Qemu         : v9.0.0
>>
>>      Launch VM    :
>>      qemu-system-x86_64 -accel kvm -cpu host \
>>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>>      -drive file=./seed.img,format=raw,if=virtio \
>>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>>      -m 2G,slots=10,maxmem=2052472M \
>>      -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>>      -nographic -machine q35 \
>>      -nic user,hostfwd=tcp::3000-:22
>>
>>      Guest kernel auto-onlines newly added memory blocks:
>>      echo online > /sys/devices/system/memory/auto_online_blocks
>>
>> [3] The time from typing the QEMU commands in [1] to when the output of
>>      'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>>      memory is recognized.
>>
>> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>> Tested-by: Yuan Liu <yuan1.liu@intel.com>
>> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
>> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
>> Reviewed-by: Pan Deng <pan.deng@intel.com>
>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> Overall this looks good to me, thanks Tianyou Li for working on this.
> Just some minor comments below:


Very appreciated Oscar for your time to review the patch! Yuan and I 
will work on the patch v6 to address all your comments/suggestions.

We will test the patch v6 across the weekend. If any other comments 
during those days, we will need more days probably. Thanks.


>> ---
>>   mm/internal.h       |  8 +++++-
>>   mm/memory_hotplug.c | 64 ++++++++++++++++++++++++++++++++++++++++++---
>>   mm/mm_init.c        | 13 +++++++--
>>   3 files changed, 79 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 1561fc2ff5b8..1b5bba6526d4 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -730,7 +730,13 @@ static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>>   	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>>   }
>>   
>> -void set_zone_contiguous(struct zone *zone);
>> +enum zone_contig_state {
>> +	ZONE_CONTIG_YES,
>> +	ZONE_CONTIG_NO,
>> +	ZONE_CONTIG_MAYBE,
>> +};
>> +
>> +void set_zone_contiguous(struct zone *zone, enum zone_contig_state state);
>>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>   			   unsigned long nr_pages);
>>   
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 0be83039c3b5..d711f6e2c87f 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -544,6 +544,28 @@ static void update_pgdat_span(struct pglist_data *pgdat)
>>   	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
>>   }
>>   
>> +static enum zone_contig_state __meminit zone_contig_state_after_shrinking(
>> +		struct zone *zone, unsigned long start_pfn, unsigned long nr_pages)
> Why do we need the __meminit? These functions are only used from memory-hotplug
> code so we should not need it?


Got it. Will remove the __meminit in patch v6.


>> +{
>> +	const unsigned long end_pfn = start_pfn + nr_pages;
>> +
>> +	/*
>> +	 * If the removed pfn range inside the original zone span, the contiguous
>> +	 * property is surely false.
>> +	 */
>> +	if (start_pfn > zone->zone_start_pfn && end_pfn < zone_end_pfn(zone))
>> +		return ZONE_CONTIG_NO;
>> +
>> +	/* If the removed pfn range is at the beginning or end of the
>> +	 * original zone span, the contiguous property is preserved when
>> +	 * the original zone is contiguous.
>> +	 */
>> +	if (start_pfn == zone->zone_start_pfn || end_pfn == zone_end_pfn(zone))
>> +		return zone->contiguous ? ZONE_CONTIG_YES : ZONE_CONTIG_MAYBE;
>> +
>> +	return ZONE_CONTIG_MAYBE;
>> +}
>> +
>>   void remove_pfn_range_from_zone(struct zone *zone,
>>   				      unsigned long start_pfn,
>>   				      unsigned long nr_pages)
>> @@ -551,6 +573,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>   	const unsigned long end_pfn = start_pfn + nr_pages;
>>   	struct pglist_data *pgdat = zone->zone_pgdat;
>>   	unsigned long pfn, cur_nr_pages;
>> +	enum zone_contig_state contiguous_state = ZONE_CONTIG_MAYBE;
> I think that new_contiguous_state is clearer, but I do not have a strong
> opinion here.


Will do in the patch v6.


>>   	/* Poison struct pages because they are now uninitialized again. */
>>   	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
>> @@ -571,12 +594,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>   	if (zone_is_zone_device(zone))
>>   		return;
>>   
>> +	contiguous_state = zone_contig_state_after_shrinking(zone, start_pfn, nr_pages);
>>   	clear_zone_contiguous(zone);
>>   
>>   	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>>   	update_pgdat_span(pgdat);
>>   
>> -	set_zone_contiguous(zone);
>> +	set_zone_contiguous(zone, contiguous_state);
>>   }
>>   
> ...
>> @@ -752,7 +809,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   {
>>   	struct pglist_data *pgdat = zone->zone_pgdat;
>>   	int nid = pgdat->node_id;
>> -
>> +	const enum zone_contig_state contiguous_state =
>> +		zone_contig_state_after_growing(zone, start_pfn, nr_pages);
> Same comment from remove_pfn_range_from_zone.


Will do in the patch v6.


>>   	clear_zone_contiguous(zone);
>>   
>>   	if (zone_is_empty(zone))
>> @@ -783,7 +841,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   			 MEMINIT_HOTPLUG, altmap, migratetype,
>>   			 isolate_pageblock);
>>   
>> -	set_zone_contiguous(zone);
>> +	set_zone_contiguous(zone, contiguous_state);
>>   }
>>   
>>   struct auto_movable_stats {
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 7712d887b696..e296bd9fac9e 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -2263,11 +2263,19 @@ void __init init_cma_pageblock(struct page *page)
>>   }
>>   #endif
>>   
>> -void set_zone_contiguous(struct zone *zone)
>> +void set_zone_contiguous(struct zone *zone, enum zone_contig_state state)
>>   {
>>   	unsigned long block_start_pfn = zone->zone_start_pfn;
>>   	unsigned long block_end_pfn;
>>   
>> +	if (state == ZONE_CONTIG_YES) {
>> +		zone->contiguous = true;
>> +		return;
>> +	}
>> +
>> +	if (state == ZONE_CONTIG_NO)
>> +		return;
>> +
>>   	block_end_pfn = pageblock_end_pfn(block_start_pfn);
>>   	for (; block_start_pfn < zone_end_pfn(zone);
>>   			block_start_pfn = block_end_pfn,
>> @@ -2283,6 +2291,7 @@ void set_zone_contiguous(struct zone *zone)
>>   
>>   	/* We confirm that there is no hole */
>>   	zone->contiguous = true;
>> +
> Not needed?


My mistake, thanks. Will do in the patch v6.


Regards,

Tianyou


>>   }
>   
>

