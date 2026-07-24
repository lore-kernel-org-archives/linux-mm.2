Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3584C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 03:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA356B007B; Thu, 23 Jul 2026 23:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B126B0088; Thu, 23 Jul 2026 23:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645316B008C; Thu, 23 Jul 2026 23:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA916B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:35:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1307A0279
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:35:17 +0000 (UTC)
X-FDA: 85022254674.07.31FFAFC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf06.hostedemail.com (Postfix) with ESMTP id 01E4B180002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:35:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lrdv4NMp;
	spf=pass (imf06.hostedemail.com: domain of arvind.yadav@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784864114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/RGnuO7Kx45MKlF80VBJo+e8FjkSm5hvl7dwNPIBMA=;
	b=wfSAfoqCwVNnMqVhXaa1G6kCFIfBQ+2WCaRNy+tsueyfRitc5A4UD0AyXvnpuGyOEOjPgU
	vh9YAe7F0+vCo2gYvKaYf1LSou/ZxYBJ0qRX04nra+zKmqfzznrL3gAdSmg/lk27zX4SvW
	98skvAuwtW091wEW2oQR17XDc5wV3ug=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lrdv4NMp;
	spf=pass (imf06.hostedemail.com: domain of arvind.yadav@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784864114;
	b=5qwprXmMHb6qgdBwOdndb9/00vtp1YTvC8Xl6N/6S8nHDTghUZR/MoMorGUGWLEAHGfwEL
	2Oa2erUidsxQh1BAVsYSjfau2DAHniTmbo56F5mRCOVd09oJ2EPKIEYqqO8znAI3FEkRbH
	Gs1OJNLLBFepAfy0HwFTMhXVVa5lV34=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784864114; x=1816400114;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8tcx/jQDvqX+jUnrpnDr5zdJXWycHlDQUscw/fx/SMI=;
  b=lrdv4NMpVgNv9GjyiEn02SnlCxUU7bKfRCXpH4uoWC8c6H7SrJUdqO8I
   9V6gmAu/n0++IlA8H9eoGWhs3i/Maa4Wx8jrbOv/DadkmdMdGQEWGAfPk
   TzAz99ED0n+izPWk4b6mznFvmKUO/cGOTmitQPaIe4gljJi1QmMd75bW4
   91Hl4XIjN9jkZ5SnU3d6b0Ea66CsEoah7iaejG6ZLXmwxn0HCeyib4mhh
   QO+s/7B1uIYJr33hCiQj5XViFyMSQiMuNBl5MAfg/ATPrqjla1IgxRwJO
   UPe8OyKYrSoAMxe+ZnY7XzWu5zFBG7IQQE7jYJTrZbxgtct0TKEtSsJZQ
   g==;
X-CSE-ConnectionGUID: f8R0RhotSLqJw1ErUNpwAg==
X-CSE-MsgGUID: 9QpIkUUFRbme21sy7sqIFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="96191708"
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="96191708"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 20:35:12 -0700
X-CSE-ConnectionGUID: 7VgRq3qeSDm8+bWAYX2REA==
X-CSE-MsgGUID: DEpj0uArR96S3NnAZqFLLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="283098371"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 20:35:12 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 23 Jul 2026 20:35:12 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 23 Jul 2026 20:35:12 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.27) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 23 Jul 2026 20:35:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RzdDUk/dfKoakh0a9wbdhIwN1UWBEyQJpta8iXLQjIH/81qlKq5j5LUKMXFohBkOc+RCtpA4KbtrbVFvtIAFewXj49iQFwm+X2MJ2tfTO06NDhTyyf96SaucQ6a0LEXunou0J9zZLSbPu7uku4l2fYEgGmjWfN+U3Fcs3+QK/zBgc7jfPcldwYarQNQfO2SChFrwoQ/+RAxUdts1ZEhdYMH1GyhvQcHV/dsVpHPPKhuXGG2zNoSBQgxuN/3yYbwVFCb5RK22RBx9yksDFStYQfRrf5X24P9mOqPmJb+odSZTMMBDbrt8mi6Ohkd8TszGNaKglyXrn/IBXbuw5WhAXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/RGnuO7Kx45MKlF80VBJo+e8FjkSm5hvl7dwNPIBMA=;
 b=IhhcKq56SOk9NKeCYUw/dnDzI3MN6YJ6Knh57lLYwBGizvsHLsAPfBPzor0DUL+HULSof7QcU3l2nnYQ50nlsgmPSrWEyQFTYaQ9aV9jJFSUxDsbBfvAlgIVW+Cr6679YiqWZgae0g6GFxLwbx9r/dmMXgUy0KHmo4q8L9Q/GYz/UzdoWrFFojiD9NxASyBIT+q4C/Qwmnvkm7+0YYV3zStNtW+wS+sk0P9Br/tLHPVtXN/RTBNWSPTxLKV5SMp3trEW1GWp1n78smmr9WH1oa+3bWbqmrhDRpI2qSpj6YiMQhWyc2bDBGqJTgmQWdzyPGF2KWXY21ZiA2IuVRBHiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN0PR11MB5709.namprd11.prod.outlook.com (2603:10b6:408:148::6)
 by SA2PR11MB5050.namprd11.prod.outlook.com (2603:10b6:806:fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 03:35:10 +0000
Received: from BN0PR11MB5709.namprd11.prod.outlook.com
 ([fe80::ad31:3f30:20b8:26c]) by BN0PR11MB5709.namprd11.prod.outlook.com
 ([fe80::ad31:3f30:20b8:26c%4]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 03:35:10 +0000
Message-ID: <8275ff46-5b6a-4be2-8ba6-b7b3fae816e8@intel.com>
Date: Fri, 24 Jul 2026 09:04:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: Clear stale mapping after freeing
 swapcache
To: Zi Yan <ziy@nvidia.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>
References: <20260723100846.1880865-1-arvind.yadav@intel.com>
 <70D21F4A-3BB9-45C7-B445-9414C0DC6FC9@nvidia.com>
Content-Language: en-US
From: "Yadav, Arvind" <arvind.yadav@intel.com>
In-Reply-To: <70D21F4A-3BB9-45C7-B445-9414C0DC6FC9@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5P287CA0290.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:221::17) To BN0PR11MB5709.namprd11.prod.outlook.com
 (2603:10b6:408:148::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR11MB5709:EE_|SA2PR11MB5050:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ca7dc6d-f7ae-41d2-27d6-08dee934900e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|11063799006|4143699003|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info: FJDyng3ra0TygAskRdY9HZSVt9PHBTiDyOaQA1tfQXErkmFqWAKVOvxRMiVrJ9tY40U+riGI4PDlI/msbeJtp3ajYSayZNEy+D2E4vtchLCSA+exWD/dYmSLptk5GhVo5F1GgF+mf6xuxHKAg1LZRaIfrKapl1tU8Kw4jXUGD3sLGvXoS7s0WI9Pmpp1BN74OPBRsFuGpXQ8n5Y0x7rGZMAkIhaYRyvpUbuQ1OzTRf086NJjVZwBy0WCbTIuMHZ3qnTCaGwY6o3ZyDz2G5AvDPO0qLipXaS3w1Wn7iUOFBtWYMDqrZPFjzvaCUer/r+Y0FE8iijMSEOjvAgCYzgbPKbYc2w/9+/bkJCLqk67yosH57V7lBMLwVf27Fx/6+1Yr7OvS9oA+8juu4bWVZJGPFQG1oOrez+Fz0dp9UuKHazGo5zpnfVOYfTUT4DLRh+gKSf/EI3+r7ZEpZZ/+MDq/wy4pSK9V1Fz7ylqxUDEA5cMi9brBeZHVaDt8/rimcm/hjo8Q3ATlbNJ7ynRb7oWmPq0xz295Ppamymkr2++yMS4/z2pOUq9l6ZFXyCewbRaH6mFjBEv6AFkY0ThIurGilwXkHPqzBx/Q3IglxyWT1URGSTUXt7XeejkpZfSYnHkwRznE37Eh+3U3F7vrPiGIzeCO9kfAPKQmNUSdU0WJ24=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5709.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEc0T3N1NGg1ZHp4S21xbHhhQ1ByYWlGNVNxMkhrRXV3YnZyVk9TVFVWWHp2?=
 =?utf-8?B?TUJ3K3ZGUWc0bERlanlyQ283TDlPaVdPQ3JjOFdrTityRTRncTZ2U1l1UUQ2?=
 =?utf-8?B?ZHVNYjJaN3VTOWR0SXVQMUJuQmZiKzloeWlKMHVCZkcvYlhob2V1UU5XODlL?=
 =?utf-8?B?SWIvVitKNHFYTkwvWWc3WG0yZHRXblBjK3dIWWhudzFiZTY0SUV0aHdmb01O?=
 =?utf-8?B?VUlIbGM2MXhkcXc0cHlhSi9neFp6cmlXemkxWThXdFYxeUxGZlY4cWRkbUFR?=
 =?utf-8?B?anN0cHltRG5URHgydVBkZUJXZWY1VloxdWlnTG5SM0QydmJ1UnRMWVYrbHJP?=
 =?utf-8?B?WVBBQml4eGNYZ2k2Wkd0ZVE4Q3ZKTFZUUGFhZjVYNktDc2FlRGtibXJVSWRQ?=
 =?utf-8?B?MFg1S0RISnllR0VYRlloMytKc3o0RWw2b1JSTmJ5OGFtRXlFcmEyQ1pNZ1dV?=
 =?utf-8?B?bStmTUcxODMxVFhyN25GZXgyLytxS2J5UkJwbllNbHduUTYwVnBoY0cvQ0tY?=
 =?utf-8?B?TS9ONzFzdktxVFF2TTBYM3UyajJVOXUzY0wySEdPNUtCUFFOL2RuM3JjRWVk?=
 =?utf-8?B?V2JWUnNIRlg4dlVLQUFKamZSTzNYckRuZks1VWsyeEZXaVBXZlFSdWF0Z0Qr?=
 =?utf-8?B?VGl6VGlpNExhNk45cFNYM01haWpITW1MejlLYk8wQm10M2NLVkhWS2NLU2t1?=
 =?utf-8?B?MEhZRzlvRXIyek9Vcms4YTlZaXdSWkZ2WU4rNWNSVFN5Uk9IMVpvOWNranVS?=
 =?utf-8?B?b0hJT2dWdkltaTNpTThXc0Y0ZmZYZUNJZDRYU0lxTTdiNmlOY2xIRzZ6TnlO?=
 =?utf-8?B?YUNVVE45amd3N29kTUxFczRKdU8wZGZDZ2d1YWZNVmF4T0dOTWM5RVBHSVRh?=
 =?utf-8?B?SzZER0ZNVGM0OERZOG4vTnhQMkFMNitiR25qS3Q0RTl5TUF3Y1F4S0pmSVBV?=
 =?utf-8?B?SkdXUjVlYzJQaEdPNHN6TmY1R2dscnVhZEN1Nm1HTkhMNmRnMW5qM2FYWFVB?=
 =?utf-8?B?cnE5ZTBMbHB6b0FnWXZLWnZ1blRXWXFQOXIzK3M2c3oycXdSb2dqUjNadFdn?=
 =?utf-8?B?VStOMS9jaFRKNUZvcWc0WDluM2toWk0rRFRVWXo0M01nT3hoRTFjUDJtOGZk?=
 =?utf-8?B?a1p3bHBra2xzRVlRTDR0VG0wVG1BTy9yYUR3NWlMMGo0OGQzSjZoSnhCeUpy?=
 =?utf-8?B?YUdEMEVlelV2NVA2K2M5YzlRTXFvZ25sUEttZ0FoSndPaGJia1FiT05GNVlo?=
 =?utf-8?B?eWNINmtycm5BcGcxYklyS3RPdEwzMXFpOEhhODFxTC9WWktURXl0L2hYRUJk?=
 =?utf-8?B?cElkNXNoZWYyak1NeHFCeVRQazl0aUZhblBCck56eEdPUHpZdTYvWFZ2K1dU?=
 =?utf-8?B?dVhjcVU5TkdoR0drU0NlOThiSW1WMnpORzh1N0hnZ0FCeEM2T0VKVjVPb2Zm?=
 =?utf-8?B?aVdScjFJVWszV0pmRmllUFZGTzI5Sml2VTZMY1lkSitTRU0wU0hHMzF3elVU?=
 =?utf-8?B?R3NWWW1IKzNvL1FLRXZTZkh1RFU0YnEyUXM2ZGdQcXBDclMvUlozNWo5bGo5?=
 =?utf-8?B?SVVvRmF5L0VvSFJjaCtqL0xYOEl0d1FGcm1QakFzb3JQQ1REOGpVd0RxcHc3?=
 =?utf-8?B?aDBZL05IK1lqaG9nc2IxY1k1UjBkd2ZGak9xbWxzNU82UEJpekt1bFRNck54?=
 =?utf-8?B?L01zTUJZNyttTWUxRHRZcUh2YXFqS2VtclF6dnVQRkQ1TnNrY2t6REFZWHl6?=
 =?utf-8?B?ZlQxcXFNNlhqZ0syOC9Jdm10azl0ZW9NWHFiUGwyMW9EREFYa2RHMkk0Nm5K?=
 =?utf-8?B?RmFRcSsxZVNGODNITXB4YmNuWGxCVkZyNW5VUk92OU53NTg1eGZHMkcvbmVU?=
 =?utf-8?B?ZldBZUhLQy9GajROWHJkcldYMW5DVHp5Y01SUXJUY0JmWnpyZ1FCU1UrVmc2?=
 =?utf-8?B?eVhvR2NnZzB6RmtTY3hUYmNkU2hKd1lEa3ZERldQUXNMVHI3ai9qZFN1SGFH?=
 =?utf-8?B?eVJscnBSRmhyTkRIQ0VCZjhIQlNYTmY4eVVHVnVTRVh1clVWR3UzVFBCVVN1?=
 =?utf-8?B?WDFSTERTQ3p6ZG1PVjFMbTdhOTRmNU5RMHNCZG1lODVqN2VQaWM0c1VHVVFQ?=
 =?utf-8?B?c0VsZWltdElDUHpKdEQzTzZmZ016dkc1eHZ4czNSQm1relVyRWQ3eFRZd0lS?=
 =?utf-8?B?RGdHaEFnNXdOQitEaGR6U3JXS0tBekxwbXV2Mlgyb3NsT0Mveis0UlY0NGk5?=
 =?utf-8?B?ZUFpSTBBYjQ5K0Z4WVYvcUVrUmtGYzMwUTNkZGNhMmp2QlVUSE45V1BieEIy?=
 =?utf-8?B?bHRTT1IvR1VUR3gzeVd5KzBCL0ZySXZaVlZSR0greTBCdkJucXpLUT09?=
X-Exchange-RoutingPolicyChecked: M+Frb1vgqNnpz4qPWVVjMME1EJjTDBP8bWh2lWjxYOuH5TXYD0cLbH2ArgK3VW+QAPcBJl6Vtd7aONjSAv3dikxYO5yEgVGkOCfv5nsNy0PWcYhXXXec2C5JcNxtazMIbl7HEIobbS1r5w4ngvjI2MSK47BEzcKp/FpIxngEoTNzE4B1EU9sYnaH0P6sGlQSnKnao/o+iE8DKi3K5Oj+D8p0EWOcwjAez3yj0UW2nnyiRZShIDiIXSYz1WYprJIFSax3Z/v6P90PTn6+B4yIA9Gj2WiiKiDjKlNlBjelrw1lu8DSWRN+gXJSG64DFfGcT2AndFtp/RYCxkEM4wIFHw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca7dc6d-f7ae-41d2-27d6-08dee934900e
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5709.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 03:35:10.2049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4uNBq2ZdLu1gm/UaqC4BXzHV/unEBYJbsjxSsf4oFD8xgdHLRUzJtuHHG17e4U/UXY3aOEOh6tpl0pdDJdtnlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5050
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 01E4B180002
X-Rspam-User: 
X-Stat-Signature: jzywt6cgnyo4mhmfuk3h3665q7xqc8ar
X-Rspamd-Server: rspam04
X-HE-Tag: 1784864113-178991
X-HE-Meta: U2FsdGVkX19IGAFJO8SHK0yOHWWczGgP5trvEQ45Zz79lFpEmuWriH2AseJtn5yBPfTEwiz70RzVcKOgvFdpfJUo5Y2Ee9aCw4P4mTHNu6ZMzPenvVI4seJ4+SF/FjIWNeUG48c8k+vkIb0dF3raP7aRlK+Jm2sh+nJ9X9NpDeCkRHX9YPKhBUErcKKQHQwCyXpLuV2LJGma1HBWA8K0GlKNZCjAfdNAwZSus8J5up5QJy+clatnhz2zNBXY3uGjqqY8t6mEAPjLWLeTXxXaRKiwsAGff8WufuFcI2wy01tnF+CaM7ck66Kk0G7uZmDP2YYTBjorxmK4HV1IAde/M/3YhQLzTY3B1Q+BmpMy9e1VABIWDKA46099ykMcIh/rVcK6MCYelNsRdmDkev/DMv09lVESkTTXKF/7NwawTfFmViOhsBYxUxsHK80zqSaISOSfzgwjK5e1o3p6E9B44r3ADFtFP9xjACEbsgbeeTCFydokzJ4kbfwed+/qYUt5ow9YhxSFBmUBh4/A3UCNgVejLfFb7A5Aak6WeEzKRI11JgGaWULQjvNzJPi8YDWTXOiKGkIsibvwDOSuSe8nc+DJgaT5HFHJfgHVAyF85HPWQOwLZJDrRfDEqdEQEGyLBkoplZRCaOGAKeiY9bo88d6YSq5uh5pjCaBCP6bUnCExHCy+a+QfHKI/Du6pnM78X/b1W15uw9oGDLl4IQSXaj0WP2QD4LCUWydU3UShKBPuf5xY/vKf7OdXJjscykVGL5xlCPv9ysFr3cnsq9y8UIpkd/5sW58qWpgyT+n9sVcrFUnOanwGqDUU1q2gU7/++egxfD/KNDKawVnwluH6tALpR/edb4O4Cs2HyVIENhCBRWPU0FHqjTSExH2XG/qf3et2ASJxjzXfbC61DsZXYC+PHyHydWzi3SaRScZ2YZpzvLCoui+kA8N3pZNw40RdLKtQEyiFJSVZpcyPYcC
 pM2NtDAW
 nmstR+CR3lzVSSQ3/fWiynB83Z0aeSB1Fk373NITfjPFwFbuN9pky80FsXo8JFkt+4bzsRmz6YhmbayxdYKd/KlUDux7LA7M4Hy7Zcqvswjo/4zWRewbVHbrvwbymaKIm0qfKJozVIm1GzKCNfIB67vltXPv9bnNQ7Qb3H08InWwUGwDkEPm96XzNsTGg0AoppWCECiTQd/kmgsx7LtWZGrM49MWnpDbZrBoxt/RZT/tzagbZammhw8/YLOYVMMcM2ljSDihW27YFxoeUnavkpnhWrkE5yXkdY//BuwN9GpgdwIIBLepkdoxL2Zq/BHTXj4cOq6Y/399Qq5i/F4ofX1dLIjULJ9wLhniYKm2HKyy+VtQpKpanSgIylrYzYoq5XQenDS/PFt84Ouu8t8TFRgIBjIzUa4gbJlDZRBUlVSAd/ARFEHC19kKAtEAQe4ZqGN3R53k9Wl7+b9fhAiI2ZkLOxRtHlpzEtjZaeMbAlcLgxu5HHXxGyk1DB7qfGwRWOoBLdUGgjDfIYj47PlRjDv7M88uXdLP1BJr8IHvPpgzUdJXfP9usykoaZ49igi7QdQE1H+hqmk4gG1FMGdc7tuvY4xch5kggGhy5oLOOe1gbC6d1E25UHy+t0l6oTffNnqtXrD/OW1u9tAFZ+sxAee0yBtaUf0z5lukcSwYf8tRwgUQENJTm4b9x2hzxYWuCHW9d54kk9kRdWOSKHI239vX3ubzISBZ0JP76Md1DpuIrkwZo1racxxvZVeTBz6WAFfdSiYBcOcn6rrQvGprGryWvRmyD0Xizpe4F+BeQIyGMm05q9L9vj8bDDRu/HsH8cPsF8Geay0nwaSLVfxuxsrvSj7jczi8WmF7C+lJ/wa6y8/Rq+M02uz05KY9J+Sy9ZaYFU6h2gmIDrDLzKaYrB6l4ByfDciMTQaV2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 24-07-2026 01:09, Zi Yan wrote:
> On 23 Jul 2026, at 6:08, Arvind Yadav wrote:
>
>> __migrate_device_pages() reads the folio mapping before calling
>> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
>> from the swap cache, but the saved mapping still points to swap_space.
>>
>> Passing the stale mapping to folio_migrate_mapping() makes it take the
>> mapped-folio path after the swapcache reference has been dropped. This can
>> cause an invalid swap_space lock access followed by a folio reference
>> count BUG.
>>
>> Clear the saved mapping so the source is migrated as a mappingless
>> anonymous folio.
> Why not use folio_mapping(folio) in the call to folio_migrate_mapping()?
> Or do mapping = folio_mapping(folio) instead of a hard-coded mapping = NULL?


Agree, Re-reading the mapping is clearer and avoids assuming it is 
always NULL. I’ll update it to refresh mapping after folio_free_swap().
Thanks for the suggestion.

Regards,
Arvind

>
>> Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Rakie Kim <rakie.kim@sk.com>
>> Cc: Byungchul Park <byungchul@sk.com>
>> Cc: Gregory Price <gourry@gourry.net>
>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
>> ---
>>   mm/migrate_device.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 554754eb26ff..fa7fbacac514 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -1204,6 +1204,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>>   					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
>>   					goto next;
>>   				}
>> +
>> +				/*
>> +				 * folio_free_swap() removed the folio from the swap
>> +				 * cache. Migrate it as a mappingless anonymous folio.
>> +				 */
>> +				mapping = NULL;
>>   			}
>>   		} else if (folio_is_zone_device(newfolio)) {
>>   			/*
>> -- 
>> 2.43.0
>
> Best Regards,
> Yan, Zi

