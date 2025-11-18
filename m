Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D38DCED24E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 10:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64D9B6B0089; Tue, 18 Nov 2025 05:31:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE946B00AA; Tue, 18 Nov 2025 05:31:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F3E6B00AB; Tue, 18 Nov 2025 05:31:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3126F6B0089
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:31:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C024913B121
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:31:55 +0000 (UTC)
X-FDA: 84123362190.25.DD36F14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf09.hostedemail.com (Postfix) with ESMTP id A94C2140008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:31:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SrwGjtuR;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf09.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763461912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6OQvJcSqF99e40H1YFbShWFdmCLeGVrz4DiJtCMdCYw=;
	b=yzc4eMvCGWKxOc3VuW+1d7tmHQnvCiKtdzmfINtDMmn4vC31PcWBVIdYlwJtEvGqiObPxt
	hXUDLPRbyLcJ8RvgoQbap9LSJFoDGLSbRXEVXeYsajGtSvoeOeN849JxpnHTmVznjjcxWI
	dGvpJhsip1j1rAb1PCoqszjh68mjOw0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763461912; a=rsa-sha256;
	cv=fail;
	b=Wfuf6tOpi/7ygZoKQKrcEWv0ktSmA64ZKkgojAzilCsEI82wMG+fHwN+j01ZaNBqBhfIZj
	AMaGhdsvSHiHTkz7glI2md28gJFjlAg8IniiD7+om+iHdbQwwFR9Z4zgMSFA54AvLqGpDO
	6qIdu8SuaS3tJttitENFxYj70Tzd/wM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SrwGjtuR;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf09.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763461912; x=1794997912;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RJ1gPKxa3GZAwJHzsy69pTdPRDrBHJti6KLgvKPJPro=;
  b=SrwGjtuRkF04JreBtdZyfb4XseWfT0oHqMUu5YSW89QUeLYW75aFFPqB
   pRqaKw6Kc54+xFWzLyidjG6A312HG6ebr/Y328TH+TdOl8EADQ8p6UfnW
   VIAblgFSR7Z+/XLIMJRc9H6ns4kHTON3Zkx/SqOWWoxH9lMsT/GA/TZxc
   XUbUqX7Iy7ZMG4V4cJf5vAYx/h4gDVlAmR5kcMSTA+NTE1OfMA7Bzp397
   EO2QAOccC3OYwYdNOoNI4ngXFa9vaG4KfhXJfuaPdRmXUo5POvzrkX8J/
   DyDrwGo+5DzHbsCfUB0hzcuLB+J1eaGPP7Zp0VBO8B3uyaY703vvLff4g
   w==;
X-CSE-ConnectionGUID: j8gBvs+xRmOeom7yETJ/DQ==
X-CSE-MsgGUID: cVyNZp+QTFu3LaqMbzzl5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65521581"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="65521581"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 02:31:50 -0800
X-CSE-ConnectionGUID: meZwHvkMTiuYyFHxeI+ZDQ==
X-CSE-MsgGUID: dW7SHBTsQCyiEXNlDaJFEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="190519369"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 02:31:50 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 02:31:49 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 02:31:49 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.29) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 02:31:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nv3UogrSyOl61y242C4CAM+kYrTy30qjGf2+Tg7DKjWz8h6kaNGv9rOgmpsPC750OvgaNzjXZMAhk4T9BZdux0q6VPTnI//zhuRi8P5cq5sajRgrYFXw0n+S8hXyQCV8XMRzwMl8KZvuNxdZ0hg7oP4BVKix/YWkhg0a80hvMe1fATOa6ZCjb6Tse7Le2QzgkNzerHXRpIfkAWPsvmybSd4Ioc02UZwT7DuMtILCkaBn08R5sgY1XRwAKQFY/2/oqkyZfBFk+VFmZ0r2GHdIXUBBEL87PAIR6z6AmoVehwU9YJC2oNn6S4RMjk+XdQd0hZPB/DaCJTReJcEZLuQaKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6OQvJcSqF99e40H1YFbShWFdmCLeGVrz4DiJtCMdCYw=;
 b=Gog4G7sR2HtgPORKlDOCTrH0+tGHL57wWzi65EiM1lKNqA61N5oIqBtVix7INgwJLS/1IPQxy/2ELz0/DeDiiDMJm92/jtjv7djAO4eDue+gRnNwtXe0VjAsS5hFjpMG2UOa8ad46Qjvzi3vD+kDqra8mZeEXzFTiK4D6+EemmYc4Qz7hmhftFyw33xUWLBOMRY2cPgstkxC3KJpWiQS0UxsYaeIfEPIVS7JTiJQMOfPSFbkI2T2P3DG4Ug38vDB6JenguYS124OmplR3bZbPJKayEDbjznLg2O1/jKUjaABqCLOypREnptiw35qf4ASaP5uSkQOEJ9/tbC4tYpU3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by SA3PR11MB8074.namprd11.prod.outlook.com (2603:10b6:806:302::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 18 Nov
 2025 10:31:42 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9320.019; Tue, 18 Nov 2025
 10:31:42 +0000
Message-ID: <8473ed80-8a1b-45f6-9950-29e6d960f2b3@intel.com>
Date: Tue, 18 Nov 2025 18:31:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
From: "Li, Tianyou" <tianyou.li@intel.com>
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
	<linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251117033052.371890-1-tianyou.li@intel.com>
 <aRwAjSQBby614Itx@kernel.org>
 <d78e10f2-9483-4d05-9a73-eebd8d8af827@intel.com>
Content-Language: en-US
In-Reply-To: <d78e10f2-9483-4d05-9a73-eebd8d8af827@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TPYP295CA0001.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:9::18) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|SA3PR11MB8074:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a98b217-ede6-4b86-0e5c-08de268daa28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UUo5SkJYZXBKdUl5Z0liWS92RjhJckdHaURldlVSOWpDMlUvd0l6QXQ5YWtH?=
 =?utf-8?B?Q2FncWFMeld2VnhEU01UWVpTVGxWVExLdXNzYTVHbzU2ODBtdlBWVzJMSExm?=
 =?utf-8?B?TnhwVC9VL29EOXVwSW9WamtWN0JpTlpFKzkrVHc0dTVZUXBCWlJLY1Arb1Fz?=
 =?utf-8?B?L0RlVGdBVG5TUVMzRkZTc3ZzYU9TSC94ZTNRbEJOelNWMlFla1lQV0FhQ3NO?=
 =?utf-8?B?MUN0OFVCYlpUQ3NzSS9zMFErN1hZOWlrS1hUL0lYU0lSeW4xZVZKUFhnaW1R?=
 =?utf-8?B?aUdSNDRwSFM5cFpPNDJmcm9yMDZEL01NQ1FzQWErKzQ3encyMysxaDF6bjNM?=
 =?utf-8?B?QTd2ZFM3T0k2d3NFSXpVcEdFSVp1ZFd1RmFCWTVEUnZtbTh0S2orU2tzMDQw?=
 =?utf-8?B?L1QxRlg3MjB3NE8vc21XaXlqR0JuY0pFS1pUQUFpSDEwdGVDaE53bWdFcTh4?=
 =?utf-8?B?ZzdQZkZxdU5DM09adlc1WnBUbGU2Vkx0VDRwUzNMdUl5bTI2MWUyK0xRbGd1?=
 =?utf-8?B?emRRMGhSZi9GSERzQStVVHJaUGRRL2xxWDFTbDdNWnNXZ0dVa01kK2FWdG00?=
 =?utf-8?B?ZlJsaXluWXBPRUx6bm1ZNWE3bVR4YVZpTlVTSHhodVVXWlhnZ09tdkk4UVFj?=
 =?utf-8?B?RytZTTJ1NFV3RVVzbGZSd2ZNUE5PTTFRQ1UxT0E1MHg0UmZ3SEMrbno3WlQw?=
 =?utf-8?B?ejBvbm9tdW9yeFlNZVExcjRPK0ZWT3lSeiszcllyN1grTUJtMEoxNHRvQ21C?=
 =?utf-8?B?TlJlZGdWWjgzTWFhYldBQUNvaXM3VlV1YmhuVDJUWHNLR3ErVWh0MHdKK0sv?=
 =?utf-8?B?NWxNdyswY2R6bVJ5cUlycjd2NHFMMnRoalJ1eEVEK25jOHBZcG9JSTFVbHpF?=
 =?utf-8?B?bVpTemh1YXBrcjVVQ3lZbWFRRFNNMUxTKzNiUXZMRVJEeVkvZW5JcnFQNkRX?=
 =?utf-8?B?bWVrM3lBbGg0eEtuQW1UWmpqaTErT2Y2MEpVQ2cwVWtrUS96MzUrdGhNUW9n?=
 =?utf-8?B?bVFKdU90NkU4Z0Nhb2ZaRXBmR3JHYkdlTTRCR01TYWlVTXlFdVdLeThwTWZq?=
 =?utf-8?B?TXpPN2ZENUNiYTdITUgyN3BwZmttdkE2T1dYMnlXMnpjb0ZHTy81c0IzNzlG?=
 =?utf-8?B?eEFiUzVxTjB6VUdjYTIxTndWdjhkaS9QcHZNQndCcXBJN1pUWklpRFpRZjJz?=
 =?utf-8?B?Ukp2b2dMTnlWYklGb1VHRTNjNFpUQk9QdGQwbkFQa2hrMEtXUkF2c1V6RTNG?=
 =?utf-8?B?NHlBd21Qa2RMb3U3NUdMWjRTLy84dXFZejh0YmlKVGNnaW1zdXZWSXhoMjQ5?=
 =?utf-8?B?Wm96V242KzBLMENTSlF1RmZidlpjc3Q3Um8vUzVNQWVvRWhqZEdKSExtNVF1?=
 =?utf-8?B?U3JiVjg2S3Fxb2x4VUZvdlU4UTB0bmo1V21XTHJybDQrcFRyanByNGNjcnlH?=
 =?utf-8?B?eUV4WkJobGRNNHJRcmlRZlZ2QTZsL0JiVGhkUExPRG9ZZ3hkQ2VHNTNaNVpn?=
 =?utf-8?B?R0hldlhLR0JPdzd2SFkzaE9LUDJPWEVmMENPUjA2NEE0dWg5aFNTSUpZUFkx?=
 =?utf-8?B?M1Z2am8zdURxWXJOcC9sNmw5WWU2K1h2d1lXM1gvemhrTm5OZmwrUzIrUSs2?=
 =?utf-8?B?aGI3aHBBaFBDTGg4ejhYZ1NheE4yVGlTaHE5TXc3ck53dmlnbHJhL0F5RGFS?=
 =?utf-8?B?YkQzcFRhbk52K09TcWlFN0swV0JpRnhDbWhOVUhxbGk4VHNIZ1JybTFkdVd1?=
 =?utf-8?B?Rlp3Z2pTVTM1ME5EK3RZNmsrWExyejd6a1VMOGJZMDZIVkhEa2c1QURlU3hl?=
 =?utf-8?B?QTkraUh6S2gwY044Ui9yc3RVUFNQQjR5aHlNamEwRDhjRVRwT09DOC9GNHNk?=
 =?utf-8?B?aDI1eUJnL0VXT0RpbmRpVGJ6U0ZtWFIzV01ETFMxWERDZ201OHp0S2d1RzN4?=
 =?utf-8?Q?4rdenObx5VH887Hpppbl6Z8B2AZu61zs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjNMeWhNUTNxc0JmQ2N2ci9uQ1pkVTFvcERDUTFlNlBtYjR3em93Vno4eWFx?=
 =?utf-8?B?VkxoUjczYVNIa1ErZ1hVRTdUV1crOEUzcUZOVi91UWVqL1VKQVp5TkhFd1l4?=
 =?utf-8?B?YmJZVXpqZVlhRm9CZ0RYZnliNXAwYXZxS2I3dCt5dUtOallGWldFVm9YR052?=
 =?utf-8?B?eUlEenk4RUJQdEV2TWVhTkRiQXVUUXdCQmovR1NZR0NYbERXRFJqQS83M2NQ?=
 =?utf-8?B?SVdWYnNMU3hqZU5VQklnL2pDcWRldUwzd1VmemEzV1J4dkZsMUdWRmkyYzhu?=
 =?utf-8?B?SXlVOGIrMXpkRFlJc3dXcGJPMGVIZENRYlA4SFJWM2FZNk9nUFNDU25Ua3Fh?=
 =?utf-8?B?a3piZWVZTXhkamxvaXltbUVHakF6QUcxRGdqY2pUVk81Znp5cy94UVU4c2l4?=
 =?utf-8?B?VU51Zy91Y0hHYzMwZ09uQnVvUUV1NWhjZ0l5bU5JS0NzQU01bnlJbU00K3Bp?=
 =?utf-8?B?T1RnbUdzbW5xaC8yTHJaYXc4ekdzSkNFbnFiKzB6dVBLaGRuQVVTZVJJdlFY?=
 =?utf-8?B?WVBaOEQwVXl1Q25qOGljZWJ1MjdmSGo4VFMzTThaUHJnai9iYks1Y2hjd3Jn?=
 =?utf-8?B?WDdJZ0g1WDVaMi9MOEFhWWFyRU41VzM2RWJibHl1M3cvVndGQ3BvM3lNNkJ2?=
 =?utf-8?B?cG9xZTRISDF2WU1iN3VzRlBCQUYrWXJmTiswMGdIaUVoV3pwc21TSzFDcFM5?=
 =?utf-8?B?d2tCcUtOS2JDcFcxRzNrdmlaUVpwNGJPY3R2aTRyejZBMTQ2dFlmMXJnYlE3?=
 =?utf-8?B?bTRpNkYvVysvaWJXVnVpNkQvYTBaL21URmlnUU5DTHFoL3BtY0xLcm84cU1h?=
 =?utf-8?B?dDNRdHJwb2V1SmY3dk11bzhid1lTMGRFQWlmK2VlK2tJNm9EbUVFN3IvV0pN?=
 =?utf-8?B?clRJNVVoaEs5Nkg3djA4aGFCWnpwN3pTeWZrUVhpUjg0ODgvb3lCWC9UYVAz?=
 =?utf-8?B?U2xKR3JzVGdJK090RVJ6WHRXbEduL2R4Q1hST2dLaDBrcGozM0VhMGVCMDBN?=
 =?utf-8?B?TlNoZXdQSkRTOS9OdWVYa2dsMFZveVlJZXE5RlJFWTd2aXM4YkdIcGJIdHRr?=
 =?utf-8?B?c0ZDenFFUlVldk1nN2FJM3lHNkRSNWhUNm9zZ0RDaWl1dit3MGg5T0p4cFdW?=
 =?utf-8?B?TktsOHVTaFQzWjRSS1d6Q3hoQ29TVS8xdXlhZmVWb0FuYVM5R05DdGZPY1ZC?=
 =?utf-8?B?T05KaDJXYXh0SUdWVzV3aWdhb2JTMDkyaXRSVHVTWFZRQStPVWlDb2krL3FY?=
 =?utf-8?B?Tm5xTDlTRjYvQzBPcVNDSDZUa3dGdjkvVXpMeGZvbEZDaVFKU0VycDhCa3l5?=
 =?utf-8?B?SUpOcG95bDVSdVdyVnhYRVlKaDU3T25EY2p5Zi9UVGZIWSs3V3Z4WkpzdHR0?=
 =?utf-8?B?eUhxY1V5ZjM4MTdWQlRtUzVjKzZpU0piV3NqZWM1aWFjMVVvejhPVVBjOTEr?=
 =?utf-8?B?bGYxMkR0VGdEalV5Ky9iQjVyNDRvaVcxRzFJbkhJUjNVZTZoa2FaOGE5ckI1?=
 =?utf-8?B?K3VXaW81LzBqQ2d5ZjJVVnpEV3JsT3BzSHlKQ25nTkhlK1dKc2llNDhUZGpJ?=
 =?utf-8?B?OGVUb1VqVmJKbHJXWDJ0cHdJY25OVEE4SmVjSHlEM1c2TzVTMlhjMjZ1akUy?=
 =?utf-8?B?ZlFKZmdoV0dzUzhZNVBPYXcrdUpCeG42R1ppWWtGSEZldEx2WmhqdlprenBI?=
 =?utf-8?B?MlVUR0xWZjVKMWxsOU56ckpnaEs2MWxDekVQTitxVGpkaG4yRGpyVmVVekIz?=
 =?utf-8?B?RE5WUEhHOVhabDVsQnJrUGJMaGlTQVNUM28yRG95VjJiUkVCK2xNMGVsaVVz?=
 =?utf-8?B?MEY0Vy82ajVhdkRuK1hUNWc0eWlHZ3libjZzWnpHaHVrOGlSbVFPM1lTWktD?=
 =?utf-8?B?Um9jdC9FM3FMNXU3V1dBNmdBTDZNWjA2cE9FdEsxcFN3VmszdnlHWWJud1Y2?=
 =?utf-8?B?dFZ1VUF1d3Brem1NcGY5MkRiMmlVdGFjK0tnQXkzNkJKUXgzVENIT1RseUo5?=
 =?utf-8?B?NXFJL2V5M040a1JUbmJlTHJiMDRYaFdBZm5wQ1NVNEtKRlRRSnFPblpKcGJW?=
 =?utf-8?B?VG1CRlZrZjllZnpzbythR2xlNWFDV2YvaDZob0ZjamRCZU0vamI4M2NPbVE3?=
 =?utf-8?Q?8Cv2fULhplNo/r6AW9JMiwM89?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a98b217-ede6-4b86-0e5c-08de268daa28
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 10:31:42.3000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJ55EHJSH3hIVGleFS4bcyeLol3pCfOzwmkzTaI//P+je+pD5JRaxAgAloB7EmmzsofxNSKuG8ntMjKxAD/V1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8074
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A94C2140008
X-Stat-Signature: 3yshwrwgr5am4y711dg8gahaj8rbsnp7
X-Rspam-User: 
X-HE-Tag: 1763461911-235892
X-HE-Meta: U2FsdGVkX186z7gHBgK1fLAZBEfxJLKdgb4dq+WUxACd62Km1WNP72C0CkAj9XfQGpGjmQiKybmHQithnE3eOh/IN1cuQ7+8//5Bevc3/q9Kwld5qr+c24H+hbTE4w/koMCCgVV8lUeGXSsVBi3fmnen4JK38GASRkNuD5fyq73IehAEkirDla04acWMNAFx+LEwcLbQxsCLFSdTmbuDBogygy7/uHOzrIqH7uEuQEgSF8GV6oeQjOn0ANv/lEjGFFZ6rO1IoaiBU+Q1DW4INKbD3Hi6Qd8eGU9SUlHAE+vppHnXgVHl+MeS1p9+wniHUl9FN2TIf9hRsIIRzkKgrOIvytrbOL33NtLX9KhxSoZHG35da0a3rdeO7XZVTuWPIj/pfuGKL09jJYHnc+fVGMsu+s5NP+brjmEN4O0WLKxMj2me+jyWBYjfDEJu3sd1iSGu+XSeXblcfSHrBFlPv3Mx+8sTkpbLVPYBFKB73KaXXExO3spxtPFnKvdA5s7T7qsuavrrMiPjY3/Ot3NpmtV3p+AMSdjq/tfynK+uEn6SQRFXY6yF88KEhU7YE+PYiueAjWSj1gX/n4kcBZI9QY8qYMxFbfQy2kyiPp6cq/UZY/MoNyUiHF0Yd33Nkd1haChmvq28MBKeMZypHJ0TcEvqSmAQU0GLkux5tt6dMBbETupbqxPi61c6+9C1+ICuOD8/LQ9zWyQbfoGtzJdMcd2pE08+9EZ6f3H7IpYpBRjFa7rRhNaKYfX0epysaweTl/63snGVoZqTjFNJxXqYVSQKs2Alkax01MGF8k3Jazj6D1opR1aEf8wWTnw9EV7kl8xCC6cc9CIAzSvVQgKnv/MHeY1nhnYaIgLEOET84zolI19RBsQJH0je+QFurRDCFfWPKNHMHLzgB+m12YQygdThTAUf/Fn2SQBR7pwtenW+DBageV6rDh2XghMKw2iYcTE5JMUAHZ7/VINSzaO
 6xJ9k/jz
 5lUBlOcXTUUADnEQcwRdWwtuvhCBcfY2Aiy+BucjD/M18dFkLQdY1JSyzhmBKqYZ3SpLXeyIuuueyDqU7TEPLmrmNrWTryXRc5hRYJNq8iGdb9jFDijmCBeJocEmr6Ay47feDAc1qdqLhKaEGVw4E5Yx+NIXcq3krzmJwMIcffH7gL/xoPuYUM977chKHhrMLLiIVF5Vl6v0SXIMMHLD8ufRbP1lCD/YgABbfdAKQ5Vo5A89Y4k29RBiVhZsHwQ6bbHCYTPIe6KyVX0I/ctCc3rXlBlTOCG8lSBSuM0TKimKKg7I4KMdO+r3U5MKioOM81UwTJKh+HynkbqGOu8VsY331Mg6Oj78/3fXheA3QRFgEMSnroNU0OzlhqBjMwGjlRVcH+zvx38L0oRFgjtAHEQIthJp4hdGVQvEvE3piUYn/J5kEnYSn5C1D2wScCltX0ZDt9cYITwKAh58SNMJKGWH4G/vEfU1mQGtdf7ffknRBWqr4nFvS0vzw8axH3xkfMO6ib2nVRGqZIukGaH0l7pKVH9v3jHboYfM5A/lTkcsqU2IywSUvKMzV2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/18/2025 5:35 PM, Li, Tianyou wrote:
> Thanks for your comments Mike. Appreciated.
>
>
> On 11/18/2025 1:13 PM, Mike Rapoport wrote:
>> On Mon, Nov 17, 2025 at 11:30:52AM +0800, Tianyou Li wrote:
>>> When invoke move_pfn_range_to_zone, it will update the 
>>> zone->contiguous by
>>> checking the new zone's pfn range from the beginning to the end, 
>>> regardless
>>> the previous state of the old zone. When the zone's pfn range is 
>>> large, the
>>> cost of traversing the pfn range to update the zone->contiguous 
>>> could be
>>> significant.
>>>
>>> Add fast paths to quickly detect cases where zone is definitely not
>>> contiguous without scanning the new zone. The cases are: when the 
>>> new range
>>> did not overlap with previous range, the contiguous should be false; 
>>> if the
>>> new range adjacent with the previous range, just need to check the new
>>> range; if the new added pages could not fill the hole of previous 
>>> zone, the
>>> contiguous should be false.
>>>
>>> The following test cases of memory hotplug for a VM [1], tested in the
>>> environment [2], show that this optimization can significantly 
>>> reduce the
>>> memory hotplug time [3].
>>>
>>> +----------------+------+---------------+--------------+----------------+ 
>>>
>>> |                | Size | Time (before) | Time (after) | Time 
>>> Reduction |
>>> | +------+---------------+--------------+----------------+
>>> | Memory Hotplug | 256G |      10s      |      3s      | 70%      |
>>> | +------+---------------+--------------+----------------+
>>> |                | 512G |      33s      |      8s      | 76%      |
>>> +----------------+------+---------------+--------------+----------------+ 
>>>
>>>
>>> [1] Qemu commands to hotplug 512G memory for a VM:
>>>      object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>>>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>>      qom-set vmem1 requested-size 512G
>>>
>>> [2] Hardware     : Intel Icelake server
>>>      Guest Kernel : v6.18-rc2
>>>      Qemu         : v9.0.0
>>>
>>>      Launch VM    :
>>>      qemu-system-x86_64 -accel kvm -cpu host \
>>>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>>>      -drive file=./seed.img,format=raw,if=virtio \
>>>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>>>      -m 2G,slots=10,maxmem=2052472M \
>>>      -device 
>>> pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>>>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>>>      -nographic -machine q35 \
>>>      -nic user,hostfwd=tcp::3000-:22
>>>
>>>      Guest kernel auto-onlines newly added memory blocks:
>>>      echo online > /sys/devices/system/memory/auto_online_blocks
>>>
>>> [3] The time from typing the QEMU commands in [1] to when the output of
>>>      'grep MemTotal /proc/meminfo' on Guest reflects that all 
>>> hotplugged
>>>      memory is recognized.
>>>
>>> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>>> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>>> Tested-by: Yuan Liu <yuan1.liu@intel.com>
>>> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
>>> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>>> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
>>> Reviewed-by: Pan Deng <pan.deng@intel.com>
>>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>>> ---
>>>   mm/internal.h       |  3 +++
>>>   mm/memory_hotplug.c | 48 
>>> ++++++++++++++++++++++++++++++++++++++++++++-
>>>   mm/mm_init.c        | 31 ++++++++++++++++++++++-------
>>>   3 files changed, 74 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/mm/internal.h b/mm/internal.h
>>> index 1561fc2ff5b8..734caae6873c 100644
>>> --- a/mm/internal.h
>>> +++ b/mm/internal.h
>>> @@ -734,6 +734,9 @@ void set_zone_contiguous(struct zone *zone);
>>>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>>                  unsigned long nr_pages);
>>>   +bool check_zone_contiguous(struct zone *zone, unsigned long 
>>> start_pfn,
>>> +               unsigned long nr_pages);
>>> +
>>>   static inline void clear_zone_contiguous(struct zone *zone)
>>>   {
>>>       zone->contiguous = false;
>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>> index 0be83039c3b5..96c003271b8e 100644
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -723,6 +723,47 @@ static void __meminit resize_pgdat_range(struct 
>>> pglist_data *pgdat, unsigned lon
>>>     }
>>>   +static void __meminit update_zone_contiguous(struct zone *zone,
>>> +            bool old_contiguous, unsigned long old_start_pfn,
>>> +            unsigned long old_nr_pages, unsigned long 
>>> old_absent_pages,
>>> +            unsigned long new_start_pfn, unsigned long new_nr_pages)
>>> +{
>>> +    unsigned long old_end_pfn = old_start_pfn + old_nr_pages;
>>> +    unsigned long new_end_pfn = new_start_pfn + new_nr_pages;
>>> +    unsigned long new_filled_pages = 0;
>>> +
>>> +    /*
>>> +     * If the moved pfn range does not intersect with the old zone 
>>> span,
>>> +     * the contiguous property is surely false.
>>> +     */
>>> +    if (new_end_pfn < old_start_pfn || new_start_pfn > old_end_pfn)
>>> +        return;
>>> +
>>> +    /*
>>> +     * If the moved pfn range is adjacent to the old zone span,
>>> +     * check the range to the left or to the right
>>> +     */
>>> +    if (new_end_pfn == old_start_pfn || new_start_pfn == 
>>> old_end_pfn) {
>>> +        zone->contiguous = old_contiguous &&
>>> +            check_zone_contiguous(zone, new_start_pfn, new_nr_pages);
>>> +        return;
>> The check for adjacency of the new range to the zone can be moved to the
>> beginning of move_pfn_range_to_zone() and it will already optimize the
>> common case when we hotplug memory to a contiguous zone.
>
>
> Do you mean we can separate the update_zone_contiguous logic into two 
> parts, one for fast path at the beginning of the 
> move_pfn_range_to_zone, and the other for slow path after the 
> memmep_init_range?
>

Re-think your idea, it's doable consider the check_zone_contiguous is 
not necessary. We can have a function check_zone_contiguous_fast, which 
need to pass the zone, start_pfn and nr_pages, return a boolean value to 
indicate the fast path or not. The code changes minimized. Will send the 
patch v2 soon.


>
>>> +    }
>>> +
>>> +    /*
>>> +     * If old zone's hole larger than the new filled pages, the 
>>> contiguous
>>> +     * property is surely false.
>>> +     */
>>> +    new_filled_pages = new_end_pfn - old_start_pfn;
>>> +    if (new_start_pfn > old_start_pfn)
>>> +        new_filled_pages -= new_start_pfn - old_start_pfn;
>>> +    if (new_end_pfn > old_end_pfn)
>>> +        new_filled_pages -= new_end_pfn - old_end_pfn;
>>> +    if (new_filled_pages < old_absent_pages)
>>> +        return;
>> Let's just check that we don't add enough pages to cover the hole
>>
>>     if (nr_new_pages < old_absent_pages)
>>         return;
>>
>> and if we do go to the slow path and walk the pageblocks.
>
>
> I'd like to avoid of the slow path as much as possible. The check 'if 
> (nr_new_pages < old_absent_pages)' is more strict if overlap happens. 
> I am OK to simplify it if there is no overlap cases or to reduce the 
> maintaining efforts.
>
>
> Thanks & Regards,
>
> Tianyou
>
>
>>> +
>>> +    set_zone_contiguous(zone);
>>> +}
>>> +

