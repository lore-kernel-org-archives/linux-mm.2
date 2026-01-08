Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17C66D0D17B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 08:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584806B0092; Thu,  8 Jan 2026 03:24:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531FD6B0093; Thu,  8 Jan 2026 03:24:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9056B0095; Thu,  8 Jan 2026 03:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 259686B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:24:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D8DF59157
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:24:17 +0000 (UTC)
X-FDA: 84308109354.13.5732D52
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf05.hostedemail.com (Postfix) with ESMTP id B2BDC100003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:24:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PLEBq8CL;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf05.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767860654; a=rsa-sha256;
	cv=fail;
	b=NnDC9Xr3NbFsc9wwIh5+322s8p5qPo02AipG9KUz/jav4rsA+4nlku93YriFvJOMfT23Xw
	HUXViP9iZzPmBe8fzrqLze3DPcfZbhtn2oYDfinUT7nqE40nib33SbydL+WaJQ5cV2/8Vq
	lCuVVfMML6sgFD7s/snoFexUPq/ekwY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PLEBq8CL;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf05.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767860654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZBR2T0CatbCXPUBRawJGcUCRRGLjURMjqZA5y5Cg+o=;
	b=iLyQEUCwLW3m0rhaGuUH5RIfJmbSxWDjZQIjqA1aJOcwb5EC4wIS2Z8I8KQl2+BxxOm4PM
	ssAuCV9VHdIRsNDETgKOYPGyHfhQ3AId5kStZNBpqzu9yJnm/erhvWNGyhdLTurz85RtwN
	x47KAsTvTqA7H99pGGclDtLm2XRXT5M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767860654; x=1799396654;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jUlse/YNzoW/PiBqmz85P/cFAvlpoG2WsBobHut0S7Y=;
  b=PLEBq8CLUgYQVJmel/nN4X8yBblaHTGzy84yX9LEP0FKAyC3wuV+eCIx
   XHWFhuAYNnbweoRX9RWh+OzbQVqO3KSl/wQOwvQJaEcAJzOPRRtqdxomX
   2kbMdaJZnXCCTYVXjgXv52Ln472v1Lzz55o6aiKdEH4YMdLrWdvDHxXuZ
   iOcaf/3tWU7TZenFlFFKFrypBcaPxrwtzUExPmteJRKgpfZGhVIQrfPKY
   sEX9wAxztPjlBTPc5mS1qzasNmaS86eIOOxIci/tK0Bu1og9m8bpXjp8m
   NgU3BKAgB8pDqPITW7RMnWUyX74Ht+ShaYceIKVe/L8Ck/1z9/dP+wdde
   g==;
X-CSE-ConnectionGUID: O7ROMEk4TfSY4rcfi4UbDA==
X-CSE-MsgGUID: j5q6XYOCQayuQAQIQXtSdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91894820"
X-IronPort-AV: E=Sophos;i="6.21,210,1763452800"; 
   d="scan'208";a="91894820"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 00:24:12 -0800
X-CSE-ConnectionGUID: X8ILFCy/TZ6RsKNHc8fedA==
X-CSE-MsgGUID: 3+DiBdNSRFCJ4qxAP3jKKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,210,1763452800"; 
   d="scan'208";a="207281592"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 00:24:12 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 00:24:11 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 00:24:11 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.17) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 00:24:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MIkCDmijckSSxeTGnDlWi60Pa8T7XSJ/9AkEuZD7hgsSnC6xDlIjh+0eXYO1lSb+xXDIRYzL/nn8H6CPK5wEUxtXbILqZHC3oJWKzaEp5Algrpjvo0huJYLAW/kdQep9dy9XnwA2FNgZ1iU5O3lyv2wxrgdtlhsw3+zdZpjcznHZSuPcDwP5nYfeBa/W32owew34eGEWwMk+v7IIuMwcw8Qm+VYfZyDOuyi09ut+HMzayKiiZONmtPuxAk4pHSYp5/+CIlM1cklE00h4jgQ7rd31xCR5f1S/CHFbhsTNyOXaG+epEarYqru5rooaA04/kGrqHJVWok7JExHN8qpd/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RZBR2T0CatbCXPUBRawJGcUCRRGLjURMjqZA5y5Cg+o=;
 b=km2L4t3G8qMu30G4zYT0SNMgXqNINqkk+5rmFZhfs7OEUhTlyF398ri7BpDH/FjvlEHkADSfEFa7Hmjj8cHNhUH7W5dHTjX19jYpyzynaRZSR5POas3TxgxeTAIns4Nd+NiIO0/DtbHNaZ2eDX/F7I4Vq/48oH06fhp5awvsCk+lwQRKoPq1MHGgvRMxt4gBwzIERqBlL4DRrnBFUbdzgH4BftRj2EZE1qLtP87JXRrz5ALNAbXFZVExYMUHAps5y/A9EnqLeVQ50eT7KchwOiWyjScc6g2OIS7PaJGG2mZ046sSh7vjNNQZ9uhl9kL0ljqo7pI/8CmSx8C55orf2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by IA1PR11MB7678.namprd11.prod.outlook.com (2603:10b6:208:3f4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 08:24:04 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 08:24:03 +0000
Message-ID: <e9d52093-d11e-4e0d-9bb9-88e0ffb78a19@intel.com>
Date: Thu, 8 Jan 2026 16:23:53 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251222145807.11351-1-tianyou.li@intel.com>
 <20251222145807.11351-3-tianyou.li@intel.com>
 <2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KUZPR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:d10:31::16) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|IA1PR11MB7678:EE_
X-MS-Office365-Filtering-Correlation-Id: 92f07f3e-2ee4-4c34-152d-08de4e8f485c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S1JSV1ZSOFFnTktLWEFXWk4zbGVTL0M5NDRvMnQ5STQzNUhLdGxCUWYzalgx?=
 =?utf-8?B?ZnVvK2dJZWhSQ0d2OEVKYWgxUmRTU21TS0psay9iL2pVTC95ZllXemwyWkNs?=
 =?utf-8?B?VUxaV1J2cDVadEJXWHdrOXpPdDBUd3d6TXB3SUY1RXhzNXlrc0RBRnA2K2RT?=
 =?utf-8?B?RnhpbGY0d3dMb2hzNU9VQXNIWEFUZ2ZWVEhTM2FpdnVwaFVZVHBJQWR4TkhY?=
 =?utf-8?B?blJ1T1NyalM2TnNFeVlRRFlvVi9DWS9YamZIbVV6MlFCeCttbU1iRFVaN3E1?=
 =?utf-8?B?WGlLR2s4L1htLzQxQ0dBcUd2UWlpV1FvZ1h1RSs3ZVR1N1pnbDBreHVQUlY0?=
 =?utf-8?B?aTQyYURRSHBoU0VFWVBxdjVDNmlRNlZnRmkxYWxjWkw3Mzk5SjZaN1MyRm41?=
 =?utf-8?B?SlM4bWZ3LzZqeTJ3VUpZK3owaXpkdjVxRnFydy95a3VtVEhTY1dPRHBKak9m?=
 =?utf-8?B?QjgzaFlRUkpiM0w4ZjQxZUhpRHlCdVRqazBRVTZTMFZhdEpjUG5GK0RPTmkz?=
 =?utf-8?B?TGYvL1BNOVhQRkg2eWlPcitRUGlBelNoWVc0REMwb295RjVBa1NqcmlGU0Jr?=
 =?utf-8?B?bWhSVS9vL1JNSkJQTnQ2a0RLOFdBYTQyQlVDWmxBazhkMk1JZisxU1BSZ2dO?=
 =?utf-8?B?WGNENyt3aTlPV1FKQ3YxMlFIZHp0c01ocnA2K2pCdkYzcU02NnpQVktPcHZo?=
 =?utf-8?B?S3lGWllvc0VTSE16VFNIRDdiVFZoaVpVK0ZLTGs0ZWVqeTNEZHFrQW5vU29Z?=
 =?utf-8?B?cGFtbzRXVHdLZDczOTh1djhyUlhSdGVWOGRISFd4K0FpVnRocDZQOTdWVVVp?=
 =?utf-8?B?dG5YS3NVUDMxNFpTTjhWOTF5Zyt6ZnJXQjlKUFphYW8yUHBqVWZKUVFzbGJY?=
 =?utf-8?B?bGtPTFdhT1ZRWjNJZVZCOVBaYjJsa2hqblp3NG9jNVR6RDdKdU1uQ2NRSTBS?=
 =?utf-8?B?Nk9qekZFanJZa3lEcnF4ODh3QnBWME9qQ2w5MG43dkpnZGdEa3BXbTFUTWZT?=
 =?utf-8?B?T0RacFUrOHV4aks5ZnM0dkxYa2VWbE5oN05hU2UxSTE1TWh5WmRCcmFQZzdx?=
 =?utf-8?B?alZVQTB5RFBxQ09RdzhPK2pSaGM3OHZTM3RyMkx1WjhHTU5yZnhabjQ1elNR?=
 =?utf-8?B?b0VqZFA5bC9Pby9saDY1Ylg3V2VTOGRobkwrYnZWMStXbWozc1k0SzZnMURF?=
 =?utf-8?B?RkZTVzYwbTZYc2JaZmNuTlRXM2JwVm5SbXJYZ2ZsaGFzeGc3SDV1Q1Erbkg1?=
 =?utf-8?B?TzU2a0ZJWTUwbG5EVE9hT0dQVDU1ODJHdzh0OXJyakxvWEZkNjQ2WGloYUN1?=
 =?utf-8?B?ZzBZSXN6U0xlK1g5QnVHYVN5OVUrbzk1Smp2WHF4eVhIQUxBRjYrQ2E4ZDVN?=
 =?utf-8?B?SSttMlo3U1YrWHNuVXBsOGVRY2wzOWZ4dkxTamUxNFNvVU8rdGhweHFlMDhw?=
 =?utf-8?B?RTVQNkVGTlZCMUhZUG8yRWM2YXl6ZjkyTWlCb0pucFVnMFp3YkdYVVBZR0lL?=
 =?utf-8?B?bS8zMWs3RDU4TEo3SE8zbjdWTnlQT0R6QnlJZmZ0d1ZUbWg1a0RwS3hnRnFU?=
 =?utf-8?B?VFU2S3RubXQvbmxXV0crQnI4eFlxd0R4WFZzWmZuY0t0ZmU5cFpIQVVVdmpP?=
 =?utf-8?B?N0gyUEJsMWJSYnZyQS81K1JIdUlCUVh4NDFOT0F3eU5sREgySHZ4c0d3UndF?=
 =?utf-8?B?OFZXT0ZUeEJuTVd0aWgvcUc5K2Z0VENGM0tEVGlUZFhTcmlRaTNSdGwxYWZT?=
 =?utf-8?B?T2xoVTRXK2VkMkdJZmhmSDdMT0IxTVROcHRyWGxVVVZtNXMvcndRN3JoQlVs?=
 =?utf-8?B?bG1jbkFGUkVUSlQxWE55Y2tqQ3hYSHREdWphb21mM1pDK0cwam9HODUvT08z?=
 =?utf-8?B?RWJRbmFjMzFtcThkUVptN2wzR2YyaTI0UUVwZExFMEhzL1VXaXNsQXJHL2dV?=
 =?utf-8?Q?6wbDdL2Z2wX4hplE0koS6q3CGF5haQw/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFlYcE5GSWpuR1dZYU91Q1BaTXJKYWhlc3o5ZThlS05KQVdEaks4UnUyN25K?=
 =?utf-8?B?MnNPVGFhelVLVzEvZTJRMjJ2RjV3dDlxS2RaUlhCM3JkeDdxRUNZblFkZjhr?=
 =?utf-8?B?SDBkeEFkejJwK3lCWFM0SElrZnl3RkJ3SWd2cXdXYTgvYjBFYzJSblQyVVRz?=
 =?utf-8?B?QS9JcHEyWFVocjNydzhva1pwVUFKOFhWcUhUd2xMZk9Gck4xNEY4aEpOOE0z?=
 =?utf-8?B?Mk83bkJGVWFCZUhEU08wZjh1dHppY1hhMDJJOUc3VW1IWmhOY252V1pTZDNk?=
 =?utf-8?B?ZHN0QjdySFFhZHk4VW9RenBzV0RrandBMHpkWEFNVENuUjAzdGFHMzgyZDJL?=
 =?utf-8?B?Q1pwWGZYc1JYMWt5emdYMHdrZ0Vralh2MC9BeWQwV0t3Q0pzSWxtK01TWWhF?=
 =?utf-8?B?dzVGcTI0bENkM0d1V3lMWmp6T0FkZStoYXI3K2p0TTkxZkdzVEdDZTF5ejNY?=
 =?utf-8?B?WG8xTWVIbzBaT2VKSmtPRzRLOVFnb0x2NUU5c2RkVjd4cnBHR3NsNGsrUEZ1?=
 =?utf-8?B?WGJWVkxxQWpFVnQ3RFRlLzhpQ1krM292aS9wczk3QW5pRmZraTcreFpYWFpQ?=
 =?utf-8?B?RU5mbjY1V0d3WXNaS1R5amdLZG1OYkZwWllYbVU2OGsxbnY4NTJvdzlNdVMy?=
 =?utf-8?B?ZjJ0TXk4UTNZV3RSaFEwZFBxbDcyczA0Mmd3MGozRG0vN0hkRVlGUEl4KzNX?=
 =?utf-8?B?NzBVMHlMem1SdUFOV1Ivb1doaGl2elgzUHZyT3J3L1RVZnl4WG5yL0RzaEpa?=
 =?utf-8?B?UnZydW1TcGt3NjlFOGowaG94djYzVmFYR0diV2FwVkdzcFBOWFA1dGxad2pY?=
 =?utf-8?B?bTJKa1RjMmR5UU1UeTNDTUZBdHhsMHBpT1kwM0JtclpYRUk1NEt0QUdSV0du?=
 =?utf-8?B?WWZNNDU0RVhnWUo1YmxZQ3hKQVYyaFpyUmIrNHA2UFBIYmgvN0xGdEZhekZD?=
 =?utf-8?B?anFKNzdrTjJoM2ZSUit4TzdVTW55aS9lN1dnZHkrVGVQcGlTdU5DSDdCb1ZN?=
 =?utf-8?B?U09NQWJwUllrZk9TeTI0ckRKV3NxMHlobkhrcVpCS1d4T2xQc3d6OFoyTmlO?=
 =?utf-8?B?SzF3V1dBZWZFa1B5V0VaOFljRHBReStSUG41b0RiREpqRDN6V2VyOWpNcXZS?=
 =?utf-8?B?bkhwNEdiVWxrSEh4d1BvM0hDT0cyUU9aOEI2UDBuVjFoajN3dDgrbTFNb2x5?=
 =?utf-8?B?RnpIcEpPbnZCRXJ2aE9iV0o1Mk5TS0x3cHNlc0RheGV4d29XSXRtM25acmNE?=
 =?utf-8?B?N2hsN3dMbUpBV2hGK1pNb0lYdlVrUHFYOXBlQVF6VkJQS3UyNFFieXQvd0pv?=
 =?utf-8?B?akJJaTFQUi92WmFDLzlFc0dNZXhXYld5U0FlUGFHZ2dQM092S2pUU2tXN2tP?=
 =?utf-8?B?b1NPS1BLeHlzbnhKdU9na0pvcHFRbjRBS1lwWkI0TkVHLzZueTVHV3FVaUIv?=
 =?utf-8?B?WHNFcTNwUlFmL1pFQ2tyTnQwRExDSXord2lXd09YcnFIZk9RbHkrZWFNT1VM?=
 =?utf-8?B?UCt4UVMya0k5ZS9ReUE5M0hHTW9jUTluNmZzOGFYdE51ODNiYzNCM3QrLzBO?=
 =?utf-8?B?Sm95RUZSUk5DMXpTdEhXR3U4cjdLMWJFZ3VZZ0FwMVgrRTVRWHl0WGhYQmRx?=
 =?utf-8?B?U3cwTlNKOEdZNkVURmFxRDdoK2JjT1NWRmdwdklEeEQrVXpZYkpmMmY5RXdW?=
 =?utf-8?B?bzhFbGRjRnFNOG1ud3lFYVFEd2FqUFJCemFqcUhQN3JIb2htamlPUkNTN05m?=
 =?utf-8?B?ZFovd2JoVmk3SVc4amtMOGJDZHJlTkQxSVlQd29tc0FVNURkQ2hibWp2bWlH?=
 =?utf-8?B?akNKVm5iZUhnYUIvNXc2dzFWVjMvcDBXOFdVUVM0WjFHVGYrS2RTaXRWMjZ3?=
 =?utf-8?B?VVFNdmNtRWY5YnZXSGtucGFLVlZCU2R2NEZUWjJvaE9xWmdYNysrZHVpVjZE?=
 =?utf-8?B?ZFQzWHpNejFsalJLRGFmZXV3ZDVVWmMwUGhVN1NPQUlGNEczK2U2L0tYMlhz?=
 =?utf-8?B?RUtxNDFIYlg3RzJrZ2x3OUpHUjhmQXVJN2x2NDRaZW1KTmdocUNXU0xGWFRV?=
 =?utf-8?B?MFUzWHkzbW10UFo4SzE4S1F1RDFaUUV4ajcvditoaGtQUUVxSkdNVGdwaU5R?=
 =?utf-8?B?bmJXQXFZV0cyY2NlemlCSGdhRXJFL1F5ajlHekpDNDViQU1VeGlxS2MwcTBZ?=
 =?utf-8?B?U0lUTUd0VXByYWpWUXppQUFNZjhONHo5c2N0RDV1YUd2Q0RGWlhVWFlTeTBV?=
 =?utf-8?B?bFdGTzY2cGpTVU9TWjltdXN2THA1Z3lLT3YxZWoxcnV2NFIvTElSU1UzSklS?=
 =?utf-8?B?RGpoWUl6YmgwNGFaRVEydHVWdEF0QWp4RUFrcjlKbEN4aUJadEJGUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f07f3e-2ee4-4c34-152d-08de4e8f485c
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 08:24:03.7524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZVlQ7DzPoaoD1ZjStf9KdTCuBgkv2UJQjbuAOFNkfbI4vLvStv3ZqmYJuGuoyqbUt7KkOTkOPbvBxt8XjANY9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7678
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: B2BDC100003
X-Rspam-User: 
X-Stat-Signature: gojco4qzinumrwz8s93p459bz8h1fig6
X-Rspamd-Server: rspam07
X-HE-Tag: 1767860653-21785
X-HE-Meta: U2FsdGVkX1+4eTr4AXcMa5C5V1eMDQP8E49WC/amjJoxArlAZ4sOkBFTsYmGW5rcM8+jX59IHvQ6WwZPfJgYtP5rKYUu40UfiHegs8Hb8+7ie5nfFMPup6uo8Cpay13QqYF/MXYbanRvrOI2FMaDuRrOj2vuk1CB9WcJVDgwVDQHtCGca4mZIrzRAgXiBKaBNrX6Gvuq0mzABLdbuRMnJhBrzIcurgXRH7dJb1ZlWcEIfpevbS5ja+2gczYNYtYMMyBBFvRuB1thZLda7KYAPXUkt3dBFucQmbJgip3NG2gL5wBtwv4YKPRaF4fHuKFXWtMza8wEYRIp0xH2c8UtmE/ecNeiLX/JDLm1MZrQkCR4lGlNCM+CnfM3X45D/98Ht3CPb/nQJqtzsiONL5EGItWwKSVwYz93jnjUROqQOnqoNBDxDmZthi7scmEK1hEdOtFq/5Y1N8n8XE+FxQFbO0yyjbwe6An71skxHtg9qIwWuw2MtIqNPcLfY4qzteVDYMKeUJS4rtB+AL/NrBiJ0hyiGVwRYqi657qttx66ZotcRI7EunvG0YRc+ogeBlzz3adxvnxDWGT4AL3yFhM+QTT/l5X5xaTyv3Z9Mch0GN4Z5NuIflD5DCA93MmR62l+A6D2YGZ1n/eMEr/rH/oCKICwIohoLhkNHLFi6vCdyvcGceMBPEL24/0TDWH7P407oIhe83kGnL3ikZxEjfIBjQYtRkzMS68pnS5vt6JidMrjkRT/O0yIIyD/sEg4iqoJ48itMIJWBrYSzTUGSNKr6rwyVhCzDm8ZL0aARDpva0Abd71sM3tPF5viSZybvLWaNXb7t+i+6uOvPIOuEZ2K2xLBNKcSWXuLB08OCLqFW4++/tnNwTUS4tC4LYJojAo1pZPBF+Jeg0td+JqmLyC5UdFd8I2toh/n6DuYI3gxp/xrBYBknGYqTThjC0iz42ZBZ8UKdPbgM+CmfeX0gTH
 bxjz9Y/y
 GoFshTPrEqIexLBz6dOkjpHPBpjXwURYGIyPXi0vXv4ol9P77pswR8sifXlLx2SVMoFgp3SFd+kvtyqXtYHOsTayL2deuAhhIWAcZoeTwbUA0VwAOba3bc2BwrkLkFLmTgXePBzIstg0Fp0k5DFnaYgynT3TdA/DNweCPL0G7foLPooO6T4O4Y/142GQqhLLNYP7eWDLG73JkkFGkQNydehbZUKLUKt8QKYtbzjPVS6cyCCtSVQQeyGlLRdDvaZENIcIfSoiRMB0VopAK1n9pt63I7jgEbIQnVset7ECrUwX5bf2Y/0RSOVbfgzgARLlfSHnNyXRWQVmu0MbL71eFY9JAOKbRIdz378jZ2tFS5iHG0/TxEMC7Kep+DSgHMmgjPh+6KuSNGxMu5oagUNB1h4i+X3Axzh3nRBXhwGog9Eh0xMiU8VKY2UGmUDXl0tEoV7Mur2bmz6wW3F9pOrMOqS39IvcAS8y4rHdvxLt0Pni+YL0NSTEje3zuoWs2dL90284R3aLAOS3mWJXKLq8xKP4AwwJFaMK1h0WbVNlDUZ6vlve0AY6YEu9KVKAj27Onk0Dv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resent to fix the format.

On 1/7/2026 4:18 AM, David Hildenbrand (Red Hat) wrote:
> On 12/22/25 15:58, Tianyou Li wrote:
>> When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it 
>> will
>> update the zone->contiguous by checking the new zone's pfn range from 
>> the
>> beginning to the end, regardless the previous state of the old zone. 
>> When
>> the zone's pfn range is large, the cost of traversing the pfn range to
>> update the zone->contiguous could be significant.
>>
>> Add fast paths to quickly detect cases where zone is definitely not
>> contiguous without scanning the new zone. The cases are: when the new 
>> range
>> did not overlap with previous range, the contiguous should be false; 
>> if the
>> new range adjacent with the previous range, just need to check the new
>> range; if the new added pages could not fill the hole of previous 
>> zone, the
>> contiguous should be false.
>>
>> The following test cases of memory hotplug for a VM [1], tested in the
>> environment [2], show that this optimization can significantly reduce 
>> the
>> memory hotplug time [3].
>>
>> +----------------+------+---------------+--------------+----------------+ 
>>
>> |                | Size | Time (before) | Time (after) | Time 
>> Reduction |
>> | +------+---------------+--------------+----------------+
>> | Plug Memory    | 256G |      10s      |      2s      | 80%      |
>> | +------+---------------+--------------+----------------+
>> |                | 512G |      33s      |      6s      | 81%      |
>> +----------------+------+---------------+--------------+----------------+ 
>>
>>
>> +----------------+------+---------------+--------------+----------------+ 
>>
>> |                | Size | Time (before) | Time (after) | Time 
>> Reduction |
>> | +------+---------------+--------------+----------------+
>> | Unplug Memory  | 256G |      10s      |      2s      | 80%      |
>> | +------+---------------+--------------+----------------+
>> |                | 512G |      34s      |      6s      | 82%      |
>> +----------------+------+---------------+--------------+----------------+ 
>>
>>
>
> Again, very nice results.
>
> [...]
>

Thanks David.


>>   +static enum zone_contig_state 
>> zone_contig_state_after_shrinking(struct zone *zone,
>> +                unsigned long start_pfn, unsigned long nr_pages)
>> +{
>> +    const unsigned long end_pfn = start_pfn + nr_pages;
>> +
>> +    /*
>> +     * If the removed pfn range inside the original zone span, the 
>> contiguous
>> +     * property is surely false.
>
> /*
>  * If we cut a hole into the zone span, then the zone is
>  * certainly not contiguous.
>  */


Will change accordingly.  Thanks.


>
>> +     */
>> +    if (start_pfn > zone->zone_start_pfn && end_pfn < 
>> zone_end_pfn(zone))
>> +        return ZONE_CONTIG_NO;
>> +
>> +    /* If the removed pfn range is at the beginning or end of the
>> +     * original zone span, the contiguous property is preserved when
>> +     * the original zone is contiguous.
>
> /* Removing from the start/end of the zone will not change anything. */
>

Will change accordingly.  Thanks.


>> +     */
>> +    if (start_pfn == zone->zone_start_pfn || end_pfn == 
>> zone_end_pfn(zone))
>> +        return zone->contiguous ? ZONE_CONTIG_YES : ZONE_CONTIG_MAYBE;
>> +
>> +    return ZONE_CONTIG_MAYBE;
>> +}
>> +
>>   void remove_pfn_range_from_zone(struct zone *zone,
>>                         unsigned long start_pfn,
>>                         unsigned long nr_pages)
>> @@ -551,6 +573,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>       const unsigned long end_pfn = start_pfn + nr_pages;
>>       struct pglist_data *pgdat = zone->zone_pgdat;
>>       unsigned long pfn, cur_nr_pages;
>> +    enum zone_contig_state new_contiguous_state = ZONE_CONTIG_MAYBE;
>
> No need to initialize, given that you overwrite the value below.
>

Will change accordingly.  Thanks.


>>         /* Poison struct pages because they are now uninitialized 
>> again. */
>>       for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
>> @@ -571,12 +594,14 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>       if (zone_is_zone_device(zone))
>>           return;
>>   +    new_contiguous_state = zone_contig_state_after_shrinking(zone, 
>> start_pfn,
>> +                                 nr_pages);
>>       clear_zone_contiguous(zone);
>>         shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>>       update_pgdat_span(pgdat);
>>   -    set_zone_contiguous(zone);
>> +    set_zone_contiguous(zone, new_contiguous_state);
>>   }
>>     /**
>> @@ -736,6 +761,39 @@ static inline void 
>> section_taint_zone_device(unsigned long pfn)
>>   }
>>   #endif
>>   +static enum zone_contig_state 
>> zone_contig_state_after_growing(struct zone *zone,
>> +                unsigned long start_pfn, unsigned long nr_pages)
>> +{
>> +    const unsigned long end_pfn = start_pfn + nr_pages;
>> +
>> +    if (zone_is_empty(zone))
>> +        return ZONE_CONTIG_YES;
>> +
>> +    /*
>> +     * If the moved pfn range does not intersect with the original 
>> zone spa
>
> s/spa/span/
>

My mistake:(

Will change accordingly.  Thanks.


>> +     * the contiguous property is surely false.
>
> "the zone is surely not contiguous."
>

Will change accordingly.  Thanks.


>> +     */
>> +    if (end_pfn < zone->zone_start_pfn || start_pfn > 
>> zone_end_pfn(zone))
>> +        return ZONE_CONTIG_NO;
>> +
>> +    /*
>> +     * If the moved pfn range is adjacent to the original zone span, 
>> given
>> +     * the moved pfn range's contiguous property is always true, the 
>> zone's
>> +     * contiguous property inherited from the original value.
>> +     */
>
> /* Adding to the start/end of the zone will not change anything. */
>

Will change accordingly.  Thanks.


>> +    if (end_pfn == zone->zone_start_pfn || start_pfn == 
>> zone_end_pfn(zone))
>> +        return zone->contiguous ? ZONE_CONTIG_YES : ZONE_CONTIG_NO;
>> +
>> +    /*
>> +     * If the original zone's hole larger than the moved pages in 
>> the range
>> +     * the contiguous property is surely false.
>> +     */
>
> /* If we cannot fill the hole, the zone stays not contiguous. */
>

Will change accordingly.  Thanks.


>> +    if (nr_pages < (zone->spanned_pages - zone->present_pages))
>> +        return ZONE_CONTIG_NO;
>> +
>> +    return ZONE_CONTIG_MAYBE;
>> +}
>> +
>>   /*
>>    * Associate the pfn range with the given zone, initializing the 
>> memmaps
>>    * and resizing the pgdat/zone data to span the added pages. After 
>> this
>> @@ -1090,11 +1148,20 @@ int mhp_init_memmap_on_memory(unsigned long 
>> pfn, unsigned long nr_pages,
>>   {
>>       unsigned long end_pfn = pfn + nr_pages;
>>       int ret, i;
>> +    enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
>>         ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)), 
>> PFN_PHYS(nr_pages));
>>       if (ret)
>>           return ret;
>>   +    /*
>> +     * If the allocated memmap pages are not in a full section, keep 
>> the
>> +     * contiguous state as ZONE_CONTIG_NO.
>> +     */
>> +    if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
>> +        new_contiguous_state = zone_contig_state_after_growing(zone,
>> +                                pfn, nr_pages);
>> +
>
> This is nasty. I would wish we could just leave that code path alone.
>
> In particular: I am 99% sure that we never ever run into this case in 
> practice.
>
> E.g., on x86, we can have up to 2 GiB memory blocks. But the memmap of 
> that is 64/4096*2GiB == 32 MB ... and a memory section is 128 MiB.
>
>
> As commented on patch #1, we should drop the set_zone_contiguous() in 
> this function either way and let online_pages() deal with it.
>
> We just have to make sure that we don't create some inconsistencies by 
> doing that.
>
> Can you double-check?
>

Agreed, it is very corner case that only when the end_pfn aligned with 
the PAGES_PER_SECTION, all the memory sections will be onlined, then the 
pfn_to_online_page will get non-NULL value thus the zone contiguous has 
the chance to be true, otherwise the zone contiguous will always be 
false. In practice it will rarely get touched.

While this optimization relies on the previous contiguous state of the 
zone, in the corner case the zone contiguous could be true, but without 
set_zone_contiguous(), the zone's contiguous will remain as false, then 
the fast path in the online_pages() could be incorrect.

I agree in patch #1 we can remove the set_zone_contiguous because at 
that time the online_pages did not depend on the previous contiguous 
state. Now, after this optimization, this part of code seems necessary 
to be kept here.

One solution is to simplify it by change the code to 
set_zone_contiguous(zone, ZONE_CONTIG_MAYBE) once IS_ALIGNED(end_pfn, 
PAGES_PER_SECTION), but this part of code is still in the 
mhp_init_memmap_on_memory(); If we want online_pages() to deal with this 
corner case, then we might need to either pass the information 
to online_pages() through additional parameter, or we need to have some 
code in the online_pages() to get memory block information from pfn then 
check the altmap, which seems not a good approach for the common code 
path to deal with a very corner case in every call of online_pages().


Solution1:
mhp_init_memmap_on_memory(...)

{
     …
     /*
      * It's a corner case where all the memory section will be online,
      * thus the zone contiguous state needs to be populated.
      */
     if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
         set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);
}

Solution2.1:
online_pages(..., nr_vmemmap_pages)

{

     ...
     If (nr_vmemmap_pages > 0)
         set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);
     ...
}

Solution2.2
oneline_pages(...)

{
     ...

     struct memory_block *mem = pfn_to_memory_block(start_pfn);
     if (mem->altmap && mem->altmap->free)
         set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);
     ...
}


Looking forward to hearing your advice. Thanks.


>> move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_UNMOVABLE,
>>                      false);
>>   @@ -1113,7 +1180,7 @@ int mhp_init_memmap_on_memory(unsigned long 
>> pfn, unsigned long nr_pages,
>>       if (nr_pages >= PAGES_PER_SECTION)
>>               online_mem_sections(pfn, ALIGN_DOWN(end_pfn, 
>> PAGES_PER_SECTION));
>>   -    set_zone_contiguous(zone);
>> +    set_zone_contiguous(zone, new_contiguous_state);
>>       return ret;
>>   }
>>   @@ -1153,6 +1220,7 @@ int online_pages(unsigned long pfn, unsigned 
>> long nr_pages,
>>       const int nid = zone_to_nid(zone);
>>       int need_zonelists_rebuild = 0;
>>       unsigned long flags;
>> +    enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
>>       int ret;
>>         /*
>> @@ -1166,6 +1234,7 @@ int online_pages(unsigned long pfn, unsigned 
>> long nr_pages,
>>                !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
>>           return -EINVAL;
>>   +    new_contiguous_state = zone_contig_state_after_growing(zone, 
>> pfn, nr_pages);
>>         /* associate pfn range with the zone */
>>       move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
>> @@ -1204,7 +1273,7 @@ int online_pages(unsigned long pfn, unsigned 
>> long nr_pages,
>>       }
>>         online_pages_range(pfn, nr_pages);
>> -    set_zone_contiguous(zone);
>> +    set_zone_contiguous(zone, new_contiguous_state);
>>       adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
>>         if (node_arg.nid >= 0)
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index fc2a6f1e518f..0c41f1004847 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -2263,11 +2263,19 @@ void __init init_cma_pageblock(struct page 
>> *page)
>>   }
>>   #endif
>>   -void set_zone_contiguous(struct zone *zone)
>> +void set_zone_contiguous(struct zone *zone, enum zone_contig_state 
>> state)
>>   {
>>       unsigned long block_start_pfn = zone->zone_start_pfn;
>>       unsigned long block_end_pfn;
>>   +    if (state == ZONE_CONTIG_YES) {
>> +        zone->contiguous = true;
>> +        return;
>> +    }
>> +
>
> Maybe add a comment like
>
> /* We expect an earlier call to clear_zone_contig(). */
>
>
> And maybe move that comment all the way up in the function and add
>
> VM_WARN_ON_ONCE(zone->contiguous);


Will change accordingly.  Thanks.


>
>> +    if (state == ZONE_CONTIG_NO)
>> +        return;
>> +
>>       block_end_pfn = pageblock_end_pfn(block_start_pfn);
>>       for (; block_start_pfn < zone_end_pfn(zone);
>>               block_start_pfn = block_end_pfn,
>> @@ -2348,7 +2356,7 @@ void __init page_alloc_init_late(void)
>>           shuffle_free_memory(NODE_DATA(nid));
>>         for_each_populated_zone(zone)
>> -        set_zone_contiguous(zone);
>> +        set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);
>>         /* Initialize page ext after all struct pages are 
>> initialized. */
>>       if (deferred_struct_pages)
>
>

