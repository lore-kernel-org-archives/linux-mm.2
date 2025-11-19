Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABB00CF256C
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 03:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1ACF6B00A3; Tue, 18 Nov 2025 22:13:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA176B00A4; Tue, 18 Nov 2025 22:13:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44106B00A5; Tue, 18 Nov 2025 22:13:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BCCA76B00A3
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 22:13:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C601758355
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:13:47 +0000 (UTC)
X-FDA: 84125886894.14.61510DD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2EA361C0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:13:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lfXhOFzB;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763522024; a=rsa-sha256;
	cv=fail;
	b=iXZBH0a2ukagVGWbFQWvRA+j5ayImpiuwiHK8klA9eeLnQDsN+OxivuiIzlmD2c9mMUmFH
	f60uMaLeRWOOGnhTrelIZfJO2mAlcxwQ0r/cjyljACTBa54axIwLeLQCqybm3lA9lIYKei
	q5cFOhWtcgqUkAL/8NWnFTVZ/RFIVYo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lfXhOFzB;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763522024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5a9Gs+zqKu3w8tb0N66pDOZjKviNNLxJK1jsiSGqjjU=;
	b=MYLE/LuJPPDhqg1Nc0Z+aCf1mmppykiaJiB3UkJM5N3RzibVgnp8PXa4ml5eaU6q8PrvL9
	ny3MfpD5n35f6lzkCznDRpm6TSGqcvoqGdaNyJTpPWWjyDm1eZzbEIPe5BjjdKemW4uI6w
	AhOTXWd9/0lRTdGMvcCHFD8gDyTUiTY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763522024; x=1795058024;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9DY7RVLieKl3E4FMZ+7Wm4JCFInG/00AyzPcvb2qb44=;
  b=lfXhOFzBNyusGrlVHaBAtViWdoPNBRSxBEqNp96Ic5EcTNeZzOtoN1/w
   /0i2Hn1CyrrpwAG1FQJ9jycKKcEmJSKMKxT7OF6nLsf3zA6XJ+yscxUpS
   Y4k24diW4O8xh8RzJh53Pcp8LcF5SxYesFvhgCGuDwJbeX+I15CMQpvvF
   o66K4rx82+1E0xWmNW3MgJrs3HKPFZUjYWWFvupQjJK/E0Ra7+HrOS7NP
   y86NwH55JbWaoWmyp3rfi01eVeU+Rf48J8NfreFzWIbe+qGLhA+5NsAEz
   o03vDOLxL8L82FgKX6DVgX3YPrU9E9clqC4/K7A1ED/VHVdoMZTERirGf
   A==;
X-CSE-ConnectionGUID: wYL3bECzRAGWlPIpSknbiQ==
X-CSE-MsgGUID: WtvhL9BNSdaNENkEvAGE7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="65436937"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="65436937"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 19:13:42 -0800
X-CSE-ConnectionGUID: J/gyOuORSr+6wa272Qp9pg==
X-CSE-MsgGUID: 3My5YOdPRh+p6yaOGR2Dsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="191372889"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 19:13:41 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 19:13:40 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 19:13:40 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.32) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 19:13:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yJylm1VZ05S5MMtwDNavlZKebhveHvBZExVyt/d3fyPiJ9MTSjxbkdUO5Ao4L2Txwg7jdYiIOR9eHyET3NKOcAElhyl+FcaPWU0Fdge9H0J/Zi5+CBZVdAeKGkq6ejCsR1+r3Ky2PRP89ISwDGq9Jwgvg+O+98znpOLOp0VXQ92I3fRjq9KHpuvskDvjTS3Xk9yMczBbhLv6MHld9Lut/sj+G4/CTQTjUreQtZ0dYvJxjX7iJVhWwb8gpqaOvriLV1YWgW+1HyuT7OelurnTT0gtKk9m8sloBQm3QdiHYI4R5wIfQx3qZ19GzjsIjX50k71NsMy23bs13fyRW+82Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5a9Gs+zqKu3w8tb0N66pDOZjKviNNLxJK1jsiSGqjjU=;
 b=L5mgHvXjtRXgTXAAsbhEov9uXOl7vfZIBZTN7lUEyvJgFGZJiiT9WZIHeSyZlByi6mbNKIlFvMssEawO919i1rumsYJH1hlHbWXbQ4BPh4DPZo1dr8T7PMDY1QRKL4bzUwVPATq6TAVRq8mKneoUAgeMYSKmOAKxpOnyIThotzYFuC7Ogu4C7vKdlArxHymzOucr6SetPD182GKRchvNqbKpEgGxy0b9hcom/Qmr3wujm01fSCSdTnZ5P0eFR+mW1GgiOaovfjWigfmQt9NlaQNNP/J6cshaoVk4GQnO5z5PMtQj2m+6+Aeci8WpP7UtpgJDvR9g1AUimZ54cGiElQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB8281.namprd11.prod.outlook.com (2603:10b6:806:26b::20)
 by IA1PR11MB6219.namprd11.prod.outlook.com (2603:10b6:208:3e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Wed, 19 Nov
 2025 03:13:37 +0000
Received: from SN7PR11MB8281.namprd11.prod.outlook.com
 ([fe80::e4c6:587d:ede3:2f85]) by SN7PR11MB8281.namprd11.prod.outlook.com
 ([fe80::e4c6:587d:ede3:2f85%7]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 03:13:37 +0000
Message-ID: <38d90dac-982a-4adb-a4aa-3b8caa6d81c8@intel.com>
Date: Wed, 19 Nov 2025 11:13:27 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <aRwAjSQBby614Itx@kernel.org>
 <20251119040718.2735199-1-tianyou.li@intel.com>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <20251119040718.2735199-1-tianyou.li@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::11) To SN7PR11MB8281.namprd11.prod.outlook.com
 (2603:10b6:806:26b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB8281:EE_|IA1PR11MB6219:EE_
X-MS-Office365-Filtering-Correlation-Id: ce05f265-283d-4c50-1dea-08de2719a156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UC80dm1xM1JrSFk5R0hRUXhmQW5EU0lzVDRoMERpQlhNYkJEd091U0Nmam9I?=
 =?utf-8?B?SURCTjM4NUpRZktMa1h5TVNla1RoaUhVYVBTYmZkWVVPWmpld2RlaGRmQ3ZS?=
 =?utf-8?B?T2s2TTlkaWZGT2pMVDBMcDk4VHpqK1RxNlRlR1NudUhhZmFhQ3V4WHdLTFlP?=
 =?utf-8?B?MVdUZGovNWNNK3J5S1RIRkN4c1E4N0trZXkxZTBvNkJHVjN2VHdEZXJmQk9h?=
 =?utf-8?B?L1VoMzZpOXZaL2hZYXg4dmRTVDZxSFluMEh4NWZtTWZucnJ4djU3bmtqemN1?=
 =?utf-8?B?cFVxZWRjNnEzSjczN2VtT2UzNUVFQXpMNGhRaW1RV2s1R0JLbUV6WWxDSjYv?=
 =?utf-8?B?bzQ5aFJSS1grT0VUQnArSXE0S1E5dkdvSkZtK05DS1FxWERodVZzaWlCUlF2?=
 =?utf-8?B?OFFQMXF3MnBzSHRWVjMwKzAzOW1IbVFQSEVTaUM2bGc4eG05emlXdit5RGM5?=
 =?utf-8?B?SkZGZC9ORnhjUSt2SDlLTkVWWG9KdjQ3NURINFYwcnlYdDVlcENUTkRqck1E?=
 =?utf-8?B?eWRLZkxxMzdoZzc1ei90NkhNSFJxdVF0VW00WEU2WnZpNlJGeWJYclliOEh1?=
 =?utf-8?B?eVRCSG9PUWt6cXkydUE5VE5wRTZMYzJXT1gxYXpHT0tUd0J1S3NHUGV1ZWdx?=
 =?utf-8?B?YjhSbDdIQVJ4c0RhTUlwc0c4ZWZmcnM3Mm9rekRXS3NTSDZyVS9nK1RBOVFU?=
 =?utf-8?B?SEJITndsaThtbzNEZmFSWmh1aWJYUjdQNkExekZud1BXZDhFZ1Z5YVZCelVp?=
 =?utf-8?B?Vm1kYjZVRXExd0VQc2huWEZyalpid01JYmp4enM0V3ZUN3RwVDBiK01qNUJo?=
 =?utf-8?B?aUphYWh2c3Q3UmdmOEVRcTAxVmRJdE1PRzQwZXI4OE41RmhRZlEwMXZndFln?=
 =?utf-8?B?R2FpZWZ4R1dOdXVPTXpOM3c0RUl4aGUvS2tBZXdJRXZ5ai84N0t2eDdFN0xT?=
 =?utf-8?B?SnF6S0x5QkYzSHdsZFRVN1dQMndycVFickNZU0JHOHM3cFdudXZOQnNYdmdL?=
 =?utf-8?B?TVVTQ1RYbW5kT1ZidDFRSzdaZjdlZDhnTUtDaG9kOHdEVUh5UnlCWWtOVnlO?=
 =?utf-8?B?S3B3WVRUaGd2NUoyNnM4Z0hGand3NG1pQnhCbm1tZlhTZ2Y5cDZuWHJLTGlI?=
 =?utf-8?B?UVVISDNDRDM0ZWtMK0c2SVBuanNiS3VlKzBPRE1YcmRXVG9nT2lSc1IvUU5L?=
 =?utf-8?B?TUV3SHBlODl5aThVenVBcnBWb1NlNWh5WFgwbkVwVkdKbHZWOE9KNGpjNlBX?=
 =?utf-8?B?QU5wdjkvcEJNRnNRS1VZQkRjNWJNNzVkcUV3WWlSVTZMWVdKRElJNjFvenVV?=
 =?utf-8?B?akQ2WHBFQmFaN1AyK0pmSCt6d251NUQ3UnR4ZHFRWEl3VENkRUFyMGpwcldI?=
 =?utf-8?B?bGxUU1RGOXpRQ1ppaEEzVzQxQnIrOEZpRFIrVHk0anU5dElDd1RiMnM4Z1c0?=
 =?utf-8?B?b0xwWEJJSEJnRnYxUnhIbGxwRUV2dDRyVHNuSXJIUzZ1WEtpcSswMzNhQVEz?=
 =?utf-8?B?a1d3eDVNc0Vac2UzMFNYbktyQU1MRWJ2TGlMaUlvNVluZEkyR2VkNkpValYx?=
 =?utf-8?B?dm5qYTc5QmJtK09XSGlJeW1sVzU3MTRuNCtIWGZaTldBSXd1bWkzR3hkYmND?=
 =?utf-8?B?anBsRWhEMnk5Q2VzVjFKTXppYmpmN2dHYVlGUkwyTlk0UHpvTUNneWVsY2lz?=
 =?utf-8?B?eVRVS1Z3am9neU81b2xlTWJqUW5rOVIzRlhaOHYxVnFJcW0zb09KK242U21m?=
 =?utf-8?B?Uys2NWRrajZBSFZpbFBUd2VSdHNRVnhqdDcwcEtXdmxCU3hoUThpVXJSNjg4?=
 =?utf-8?B?Q25LbWxkQ3JSV0VoUVhjelBIbSt6Yks3TFluWXA1M3lZK3RUUTFvZ3ZRYVZu?=
 =?utf-8?B?QVg1a1d4VGJRaUNqYTBiMW1VMTVVTXdtcWg2d1NLWTk5dkNna2VFdkJUMloy?=
 =?utf-8?Q?hXE3nXTlHX83seruRFSHy84MnMO3zWEV?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB8281.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnJlSWtNNzFNMGYxL0RURGJmSHZJTzZrVnlSdjJEb0VPY1F5cWpoM2QzQk9n?=
 =?utf-8?B?cGxjVVgzT2s5YngrWWlNWVl0NG9aVkpnc0tHOEU1ZTlzUnBjbHNQb3VJaUhP?=
 =?utf-8?B?VVlMd0F6YWY4Y3FuSUpFUzVxN01EMGF4cGRnVVFnalkyc3M1ZXNBMk1QYnNL?=
 =?utf-8?B?RWtoc2NDWXZoSHRMWWtxWGF4RkR4ZFdVcm9OcGx4NUkrZGZkcUpqbWs3a1Ix?=
 =?utf-8?B?VGZVRlpEUzJYMU9kMGlyS3c5RFgvWGVZSTVxZ0E5cjBVNGVadituQjduQjNE?=
 =?utf-8?B?MWxwVjZmS1FBTE1EZC83ZlJOWE9oUFRZUk9oVzQwZmdHc0krOTVEbDlvcktw?=
 =?utf-8?B?RWFOYzFsK24wSTg2ZURwekNISVo5SVN5dmtuNGFvRlhFczRFTnpOSldzdFRC?=
 =?utf-8?B?T3o2SjRDRE54OXZ5U29LaEFNNVg5R3F6NFZodnNPd2NiZXlVR3QxamxubGx2?=
 =?utf-8?B?MUZCc3FEc3NqVXYySGgyUHgvYXloTlFEMU5FUzZjcjdNZXZCWHIrSnY5SEJx?=
 =?utf-8?B?a2RpQ29yS3ZDbjdnQkZQa1BrTnRidlIvV0s0Wm1WUWl5cWJ6TnpaTWJBTlZP?=
 =?utf-8?B?akRHejRDcDhUNEZCajYvTzZyanZEWTdPVElaN25yTVN3RTI5MUo0dEhvVnNt?=
 =?utf-8?B?bnJObjFabzZwaDFCL2lqTE1uNmpTNG1STlBNZ0hNZnZycnphYS9kV3hHTXgv?=
 =?utf-8?B?cUEwUHh4Y2ZVeTU4NDBKRW1MT3RmeExJaElIcy9DSktYdHB3MVN5cmw5dXFT?=
 =?utf-8?B?ME9VZHA4emErRWJoS1hxZXlXTkZ4ZDljc09SVG5MR2c1OW4zQlFwOFpFYjhm?=
 =?utf-8?B?bWV1M0x4bWw2TFh6Ujd6T3cxa3lwZ2xtRDRrV1dmWTlNZlJYNFpkM2NZL21z?=
 =?utf-8?B?c3d1VHNMV0RQb0dTRnVuMUNpN0s3cnlUamFJRVdRR1N1SmN2T3FJS0Fobnhj?=
 =?utf-8?B?aDBwbUVDTG1zNlpkZ3IyNUZSU29yaWFlMkJmOUFvcUF0WWVqOEd6SkNraUx4?=
 =?utf-8?B?MVB6amxpWWZJUXo1ZDNhekhrcjhDNmQ4V0xQV2RkVzZ6V2xaRWMvQ1M1ZGJs?=
 =?utf-8?B?cVRWeVEyRzgxVG5pQzk1L3BZUFlpaHNMVjFGc3hQZFAzaEJwMGx4b2VSZnFT?=
 =?utf-8?B?b3RTNWVDTnlNUUZBWGNXQ0p2Q1dMTkk4a2dydkdNenRpbXRyZ1J1UERoNGpP?=
 =?utf-8?B?YjJQanNhL3lodzBlMVF0OWNGTjQxV3J0Z2RYZmJQYi9SbStnVWFsa0J4dnJz?=
 =?utf-8?B?RzB5WWFRLyt6YUxpTlJlbm5IdzgzSWpjOUMvMTZBcTY4M3Y3NU1yM1lCYjVP?=
 =?utf-8?B?K2o4akFmdTJHMEIxdERpMVhnbkdJWmRQNURoRFBRZkd3elkxU1VGREJham4y?=
 =?utf-8?B?UkNXYmVDM05zZkZSTG1XQmFNMG5ENDg1ZDBHeFF0bmE1anI5cGJvMGNVMXQr?=
 =?utf-8?B?Q0VOV3Y2NnJrVWNCQTZVRS9yVDBYL2lwNG1taTlmSTBFU0pmWGZycTVXWTZS?=
 =?utf-8?B?Zmo5R2ZWSG1rR1N5YUlWZ21MWjJ6MFVBTkM1Q3FQZ3RJWE1zcmpSSHFJV1Vj?=
 =?utf-8?B?elNFNkM1S2dJcDZiU3hCMmEyZzFxSTZFOTVtUmFma1pBOFlRdG1KRmJOaWYr?=
 =?utf-8?B?cGdQa3ZDa29UcnVRSU9DcmFNQTk1aTYzWGY3NW5SZ2IxUEhxQXg3a2ppK1BJ?=
 =?utf-8?B?cnQwYm50SU1xQmt4N0lZMllFYnQyUmJSbUVVZ2dhVGJVQmJ2UmdtelNzZUM0?=
 =?utf-8?B?T0dpR25taTVEdDJ6U1cybWhMSXUvallKeE5KbUQyNytMTGhIOGRXWjhuY0FG?=
 =?utf-8?B?SSt3YkdiaDlXdENyUFQwV2lwdWJIdXlzN3FpWUdDK0FtbHJqL1Y1RDY1Q3Zv?=
 =?utf-8?B?N0txbUVaYWI4ZVU0U3NMVjIxeGxxQjl2NTkvbVhzZTF5R1E5ekpVdXBybnZR?=
 =?utf-8?B?YkZ3djR5cnVpank4WGVzZmx0VzkvcWxEQlJ2bE5wMHNzdGNwTVJqWnh3OGpV?=
 =?utf-8?B?UWh1YzJhK0pEd3hUbTRqUmZjMkJLRTVOSE1jaWJwWEliR0dDV1I2bE9Ya2Fm?=
 =?utf-8?B?bWwvRUlqdjJJM0hWaFdRbFFUanRWeDdSRXBaUDVNSFgvUFQrU0VtdVJ3MjVm?=
 =?utf-8?Q?V/ne9GyZsJZ7hwEmTghR1EvNp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce05f265-283d-4c50-1dea-08de2719a156
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB8281.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 03:13:37.3679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bMkFR9LStKMZBjKH6/g7RtksUadpiNZAfbMaW5bky0jJswAAxlClkvOJ4pz2FjHzcNFQ3LjuvlR115ljaBVqZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6219
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 2EA361C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: 5hpm3ayfk1he49a9qnaddjzqpu8chg85
X-Rspam-User: 
X-HE-Tag: 1763522023-506961
X-HE-Meta: U2FsdGVkX18FuuUNhoYQXCkszMub1ifmdp5WiRLypTxZctx9iIdVBjPlcxEMC9Ww5ClEc41NfRSmktRpHAt16Jb0mZLhHfp0dM+TaD7YAa7m9/cICvjf4g/8gikSMZ06dDaLCWhvlxJy9TKEn4U/J3LI4zM+qFVHUGxXm3xRPhoqxhNdsdoK0t9o1xH94RWkQ7KfFdOm1K8CG+EvYNp503gUaGvMfnsSj9qC/oTs3ALZWMnhxGGNGlpjdmQa+0TGaO5yMcLs2Tt1zYhuw5BDAmWEMtIqzb52MZMyaHsqhnQ5K+9T5acUFYZn+uUsL1rofrYp8xx1x4U7CIvabFDVGRkZiTZCzD8F6Umh7BzOgQu0hPp85WWtCxOc+DRhXYU6sn6AIjpK07rTKzEeW95UjT50CtGXqpjROhurJhSkZMcX1oIQV0ymDOluHQ7kZO5OqRnEswPooXDy95fR+YjBY/wlpLCrK4dYb7mx6VC6x+AZmnbesAtUUZLu14LUllKFHxmu/c89ZhARIlec5qX3ap1/YbtSp1cdWrdHUh99Cn5sZmc5NCFPM1WWHaQdZqBVWmjI//U0lElQ8MDQEuf+4DpwuxMr7vpti500JeXOx+ZU78xxiPL3bPPGsvxZLgjXnuI9kqadkY/lMxXmBGOAiQu/d1tsazKOlGgYIm3+dOikct1cUeu6O/JVbPLwTbhfa/B4Pk2yhzI9XU0BB61d7ySRwQNYl2fnbenDNW7oD5W1vnx45Zh8P5tcKwvq1bFE0s4AwVmNDFbtzeXtwHfFDX478ELVZqa6Eb7BmFX+PkmMKb80/Si+30DVIAOrRqGGjak2+GUYnoMWwC563P6r5kfhxN0fZOB9eDBqaem0l/i40YiAcWj5qhCA0OMkVOnVHT/b5t8DLDlrNLIK6swQ4glh7IVOw0kKXo2MdGh5mVBA5nbSLBtJ3ffo6GhxN3hL+j8dhSX2MpXFMH8wxGT
 gp3fWrCo
 tmoQNM+FG8RLOPO9J2S/5tXpaKlpB/HiGe2Ilnf3vn6Q87Vj4at4nzGDxh4OpZEsv5TpNuGONcSUrhgL+Bn+g0vd0ItnzPGBUO86m9nkDix6nfJjiw/twumaWnG18xaryQ8Je4diQsWnfx86hRiMQY1KVA7Cpsyeuz/778f1Whp+tehdFuoWMqoh6GixKSuL6ZyvSVoqjHa8n+rRqNEpiou0qPB3Isz0cKVWy9yKaPe7emBYDAUhAYIkuxml3i0/Hj+J/AWkgWiLWPowRAT65rhkAze034rKpEIl3OMPyU3NyAn46q4HRAqYITIa01afYQEVG+pUz0WANim86Ck7fdcREpj4uL1hbznfZ4NRtCNg0NoEcDC+BgmRo70OhR0gdaieo0FmleYyF0x6QFLzIVUXIV0xumDvujWF4sdg8HXT3NBagtp4GpimLIEv3USEJOX2ndQNdNGYM4L81rYMUUBS0oZRdJhdFW5TkYLXpXXV87e7IAUcRCKujii2dbDtAmZ6/Wr6AZNtpGqb0bmGJnANIzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

Patch v2 with the changes suggested from David and Mike, which 
simplified the code and also performance get further improved on 
Icelake. Appreciated for your review. Thanks.

Regards,

Tianyou


On 11/19/2025 12:07 PM, Tianyou Li wrote:
> When invoke move_pfn_range_to_zone, it will update the zone->contiguous by
> checking the new zone's pfn range from the beginning to the end, regardless
> the previous state of the old zone. When the zone's pfn range is large, the
> cost of traversing the pfn range to update the zone->contiguous could be
> significant.
>
> Add fast paths to quickly detect cases where zone is definitely not
> contiguous without scanning the new zone. The cases are: when the new range
> did not overlap with previous range, the contiguous should be false; if the
> new range adjacent with the previous range, just need to check the new
> range; if the new added pages could not fill the hole of previous zone, the
> contiguous should be false.
>
> The following test cases of memory hotplug for a VM [1], tested in the
> environment [2], show that this optimization can significantly reduce the
> memory hotplug time [3].
>
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Memory Hotplug | 256G |      10s      |      2s      |       80%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      33s      |      6s      |       81%      |
> +----------------+------+---------------+--------------+----------------+
>
> [1] Qemu commands to hotplug 512G memory for a VM:
>      object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>      qom-set vmem1 requested-size 512G
>
> [2] Hardware     : Intel Icelake server
>      Guest Kernel : v6.18-rc2
>      Qemu         : v9.0.0
>
>      Launch VM    :
>      qemu-system-x86_64 -accel kvm -cpu host \
>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>      -drive file=./seed.img,format=raw,if=virtio \
>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>      -m 2G,slots=10,maxmem=2052472M \
>      -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>      -nographic -machine q35 \
>      -nic user,hostfwd=tcp::3000-:22
>
>      Guest kernel auto-onlines newly added memory blocks:
>      echo online > /sys/devices/system/memory/auto_online_blocks
>
> [3] The time from typing the QEMU commands in [1] to when the output of
>      'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>      memory is recognized.
>
> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
> Tested-by: Yuan Liu <yuan1.liu@intel.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
> Reviewed-by: Pan Deng <pan.deng@intel.com>
> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> ---
>   mm/memory_hotplug.c | 57 ++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 54 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 0be83039c3b5..8f126f20ca47 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -723,6 +723,57 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
>   
>   }
>   
> +static bool __meminit check_zone_contiguous_fast(struct zone *zone,
> +			unsigned long start_pfn, unsigned long nr_pages)
> +{
> +	const unsigned long end_pfn = start_pfn + nr_pages;
> +	unsigned long nr_filled_pages;
> +
> +	/*
> +	 * Given the moved pfn range's contiguous property is always true,
> +	 * under the conditional of empty zone, the contiguous property should
> +	 * be true.
> +	 */
> +	if (zone_is_empty(zone)) {
> +		zone->contiguous = true;
> +		return true;
> +	}
> +
> +	/*
> +	 * If the moved pfn range does not intersect with the original zone span,
> +	 * the contiguous property is surely false.
> +	 */
> +	if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone)) {
> +		zone->contiguous = false;
> +		return true;
> +	}
> +
> +	/*
> +	 * If the moved pfn range is adjacent to the original zone span, given
> +	 * the moved pfn range's contiguous property is always true, the zone's
> +	 * contiguous property inherited from the original value.
> +	 */
> +	if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
> +		return true;
> +
> +	/*
> +	 * If the original zone's hole larger than the new filled pages, the
> +	 * contiguous property is surely false.
> +	 */
> +	nr_filled_pages = end_pfn - zone->zone_start_pfn;
> +	if (start_pfn > zone->zone_start_pfn)
> +		nr_filled_pages -= start_pfn - zone->zone_start_pfn;
> +	if (end_pfn > zone_end_pfn(zone))
> +		nr_filled_pages -= end_pfn - zone_end_pfn(zone);
> +	if (nr_filled_pages < (zone->spanned_pages - zone->present_pages)) {
> +		zone->contiguous = false;
> +		return true;
> +	}
> +
> +	clear_zone_contiguous(zone);
> +	return false;
> +}
> +
>   #ifdef CONFIG_ZONE_DEVICE
>   static void section_taint_zone_device(unsigned long pfn)
>   {
> @@ -752,8 +803,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>   {
>   	struct pglist_data *pgdat = zone->zone_pgdat;
>   	int nid = pgdat->node_id;
> -
> -	clear_zone_contiguous(zone);
> +	const bool fast_path = check_zone_contiguous_fast(zone, start_pfn, nr_pages);
>   
>   	if (zone_is_empty(zone))
>   		init_currently_empty_zone(zone, start_pfn, nr_pages);
> @@ -783,7 +833,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>   			 MEMINIT_HOTPLUG, altmap, migratetype,
>   			 isolate_pageblock);
>   
> -	set_zone_contiguous(zone);
> +	if (!fast_path)
> +		set_zone_contiguous(zone);
>   }
>   
>   struct auto_movable_stats {

