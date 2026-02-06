Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01297EE20A6
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 14:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8206B0093; Fri,  6 Feb 2026 09:08:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2554D6B0096; Fri,  6 Feb 2026 09:08:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 103DA6B0098; Fri,  6 Feb 2026 09:08:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F12356B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:08:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 479BDC0C17
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:08:46 +0000 (UTC)
X-FDA: 84414212652.04.556CB55
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 77B511C000B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:08:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lvUg9AHO;
	spf=pass (imf20.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770386922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BIpHY8AjEpVHhNjxM6b+2BKc5uQ1AQADoVE8Xgu92o=;
	b=Yuq3g8R9chmGJbRahB1h+WEYr/ftnFgqpErfbSo0+gPb7ZVICTovqUZqW+Stq6/ShBwRNC
	NJCGs/WrQxMuB7v3eUN2i3K16xvBBPkOV5wFAK3IaxyOSxSxyP68wkIP9TccgSdzBUJQt2
	TD4Naf9LksjVRtc3we7CbYFiNziqufk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lvUg9AHO;
	spf=pass (imf20.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770386922; a=rsa-sha256;
	cv=fail;
	b=ozAHkCfJ7oahELS0rOwJVfq43tXbqSmNlV1vySITVIRtkebR5zEylTnXS5FNhx5+5Lgq35
	P9ceoWd/wOTupaHTKdHMWKdo+5gpNqOg7rHX7d5vKBaBREII74HCBFAEvbHClprl4GusDK
	SMEbOlVPug1FcgPNXeaLsNztR6TKIYo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770386923; x=1801922923;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PfO9dDuX9GBHHpLOYKaj7spppbyL+A4YUnEjDrms8TM=;
  b=lvUg9AHOOZx/E1KcftpoXlmMpaRYz79PsOSQrQ/Van9znry7Ne4M28AD
   RbptsKPJde5ZDGrcon6Xa4EMVqeJNfhO+gAYLBSEk7X4bWO4oQ9EOgbvh
   HB8wBwxVbeQWukM9maY6sSk8M+uRNi3f42wUUJIp7QIp24grL1mfcPOWh
   fVXyYiiImNXbbsj1xLR+refn9W9s55a6y5Ay0YR4H97REIOCKN+BiCGHg
   LM5wfzNh24R0QhyWA4fH0O+DPDPyA97A5UPBeZICV0KOfMCH5YmmM+Run
   ggEfVo5oaHL6Lg5n2zFwByq2AM5gCXHRdRt82Hz0iTuf9huyCrhcf6omg
   w==;
X-CSE-ConnectionGUID: pATcjV9STVeAQVCTrmwYkg==
X-CSE-MsgGUID: tV36c9MiSMShFj4eDUZgfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="82226849"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="82226849"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 06:08:41 -0800
X-CSE-ConnectionGUID: isVvWHnkSTqH2WSn8VzqOA==
X-CSE-MsgGUID: R6k/DsbxRb66R6kFG7sRgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="210167758"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 06:08:41 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 06:08:40 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 06:08:40 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.64) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 06:08:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eB6pHeAwcR46ilhHxQlksIDDOaPi+HM1eYEKBP82KGIDLoi4SkCnSYZ0Qf9mU7JYSuM1Fojfx4WPbvR7AUPIEXMI1FcZikAa0GIG1VnHSGj0f3MzdvYn8ajaEpBF+KVvlvo0tE+b2cIIFFJU6/GsskJubYTmmDyTQR0azNCKnwDxNNRQuG9ivqMPxdHMBmU8h/TrnB9zZsTjvyNk7BZCXzdbmRqjawyiKKPjMo6rAbi/Y9jrTCvZyEASFYof1CU4ZYhZqMjQMYDenvZsNNPQkNkDdLPWmzxpb3qUITuCjN7Qs2L5ozy2B9UzVVb8UMvoz1mjremUPkrhRMCpsASXPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BIpHY8AjEpVHhNjxM6b+2BKc5uQ1AQADoVE8Xgu92o=;
 b=nWnY88hLlGDCrNlviHGd2RbWTjvp79MltoIRIx95aXIX7zDxrRKzyacn57XCf4BJHp+qQK6kcniCapX+oketUAbCw8GjoyZrhcVUbdLpGEnu3v/hp5gRSCvVXO3HezGivHiH6XHtamKJVxwVLc8yxK3Mt8nR4aQMh5GEd3ro2jjrOwtuxbodz2iINE43TO6U8YCKVDm+B6E4KjRTM3IqhfQaXdyuesiEdK+7VRuxc55cp9kOZyzQsFeNZaPoZ5lKRmCMOs6cn/QCkfHXu+UIFAHNqQsBlkV9QHFvYvKy/gP33Ji4jzGCrpn9GLleCL4sHweWCuxfjx+e6fXqBfE2/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by PH3PPF8517B3F27.namprd11.prod.outlook.com (2603:10b6:518:1::d35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Fri, 6 Feb
 2026 14:08:37 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 14:08:36 +0000
Message-ID: <12f4c0eb-fcd0-4157-b668-d0e8340d8219@intel.com>
Date: Fri, 6 Feb 2026 22:08:26 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug: Fix zone->contiguous always false when
 hotplug
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20260130160938.2671462-1-tianyou.li@intel.com>
 <00d07c59-e573-40b6-a096-266ef14545b9@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <00d07c59-e573-40b6-a096-266ef14545b9@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0041.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::29) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|PH3PPF8517B3F27:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d48bfeb-fb64-4ee6-640d-08de65893841
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TUVVbnU5OXc1NVBVdklaVm10bjRNY0YweGRxQkdETG1MMTk1d3cvUnZOVURv?=
 =?utf-8?B?ZVp5UVJ4dlFYU3dhdGVFeTcwYzk5emhhaVErVG03UzVuL1FYbFRjV2JHK3A5?=
 =?utf-8?B?K3huN05UU1VlTCsva2NPNUFscVhNUlczN2oxRzNuUUZibk5vVEFTZDMxUVp5?=
 =?utf-8?B?Ym05S2N2VzJucGw0bDU0eGRvRlVCaUhERDhHdHYyRzhFT2ppOWNHM041eTd1?=
 =?utf-8?B?WmFRVytQdFVzeDJDbFJ0cmh1REhuU2I3czVneENhclJJTzZ0c1grSlp5Q1g4?=
 =?utf-8?B?bkQxZXJyOFo3U3NDUkVGbzJjblRGL0pjODV3MDU1WU1wWWhEbGFCeHhJbk82?=
 =?utf-8?B?aU9hK0pONGdYd0tlZURzd3hLSFlWdHB3aVdJQ0hoeTF3eGg3bzB1MFJ3bnJ2?=
 =?utf-8?B?QkRJWkhvSlc5Qkp3MGlpWWNlVXhPL0xONmxhWFYyWVVqQytzc0NjbG1RcEVN?=
 =?utf-8?B?NzdpYzVnVmNyMys5SUN5T2VNY0J0b3FHaW16QkplUUZ5anNTd3MrRHBscm5W?=
 =?utf-8?B?YWFGSWtaZGtvb1hTTGw3L0RsbkI5eDIwbXNreEErV0dhQm9scnIrRDQvaTRh?=
 =?utf-8?B?cEYrV3Q3R2tBUERGbkdtQmxqY2pFRXNzdGcxWUFrdkxGWDVZZy82QWI3blhi?=
 =?utf-8?B?V3lUZDV0blViZWRuKzd2R1JweHZ4MnlJU2dybkQzZHB1YUhCT0J2MDNXQito?=
 =?utf-8?B?VEV6K2NoRG0wbm9uZ3VCZlVaQ3JjNkJCUUV5NDczV2xZTXN1Q3gzNW1Pd1RF?=
 =?utf-8?B?NHFuSEplTlMzcW5Tc09uemIrSHJaUUdnaFl3NDJSV2JVSTd3K3U1TmJsMUc2?=
 =?utf-8?B?U1ZReUQ2RkVmM3dGZm9MWWdOSktza3lVZUxMME1EektSWDVnZ0hVbXlUblNz?=
 =?utf-8?B?VDh4VVF5dnRpalE1UGpYZFNDVnVMN043U3hhVnZsNWhDOU9hM3BKWm5LT2c5?=
 =?utf-8?B?RGtoZ0RoRzIrMFYwa25iRWl5U2lWYUxCYUlLVHJDWGZyblZtanRhbktnYmFS?=
 =?utf-8?B?SytjY2FCcjNMcEUxalMybVdQaW9FM3k2SXJoOUtsakxSb2Z6Ym05Nk1kVmV6?=
 =?utf-8?B?OUlFN0dPTS9NNFNadGdLQ1ppcWVxVlZHbFA2OFgrSGRIYUdjVXo2QVhnZHJY?=
 =?utf-8?B?ZlVyNGxMdHhPYTZWU1BTT1VKNDVyRHg3bnUrcXdDaGRJKy9tbWFncmZQbndO?=
 =?utf-8?B?YnZDVEhYbDhBSGpzWGFCZlp2Y2dleXVIeU9wc1QyckV3ZlBQWFZpeUVsVVFS?=
 =?utf-8?B?OVNyS1JGWTVoTzUyb284dnpFbldtUmVJelNNOEJ2N21peG5vcWxDbUJDQXhs?=
 =?utf-8?B?cHpWYlBhSFZjV2RFdGtRK1F4R0NWL0d2QVRlQ1g2bXNPZHNZVks3VDcrZFhJ?=
 =?utf-8?B?dDltQng5eHQ5QmJpNEI1Q29iazZuZlZqV3drcWh4VWVxL2RVL245U1BRc1l5?=
 =?utf-8?B?QnVSSUpKVFRESWE3T1JWbW9raFNCdE01eG83dHhVaTlMelZDVFA1VVpaeHU4?=
 =?utf-8?B?alpHa0V2YmdCMnhndWxBajkyZTdYT0VKN044dFNLVnFsdjFsam9nTW94OS9j?=
 =?utf-8?B?UWVrcExhbFRxajdvUGtVdjVvbHJWMEN6TDhHYkFDb1dFWVJRTEZiMTdZRkRG?=
 =?utf-8?B?VzNDZEwwT00zRHBZdjVhMkphczhicDJuNDdUYnlwbENtUHd4ZzJaaTVQeHpB?=
 =?utf-8?B?enBCVjRENHNKdWh3TmdHcmN1OUxQUVZNK0E4dHFKN3FFUXlXc3JyZWt1dTho?=
 =?utf-8?B?VGNyMnhOVndLcWp0T29Sem9PUzROVGRaZ09yQWl3UmRiL3pobEJ3dzdmbnRI?=
 =?utf-8?B?Sk4zWXc5SEt6NXhIZWpVYkw0aDFiWTV5TjZ0THI5VGgwNXpSNWUxOW1WVUU1?=
 =?utf-8?B?YmxPZnVKYjRxa1B0RGtuM3gyQUpoaGZXaytRSDVlY1Y0NXc2YlhMdkFicGIz?=
 =?utf-8?B?MUNkdjRmWmY5eFR5UWdCd0lDRVRIamRiNzVmS09PMHYxcmtZeDhaT3BFTS95?=
 =?utf-8?B?M2RmanZDQllJNm9EbjBLU1BQQm9lMlNKVk56andCelE3Q3VzRzI5amRXQ1py?=
 =?utf-8?B?cXpreGFDZktpY0xvaFQ4K1FndFBXczdzRnN1UGpMT01SUXV4cTZvSTlHd1dO?=
 =?utf-8?Q?bT5o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ck84ZktCdzJTZ1lRTkpNSTB2QU12NkplejVmbEZyQ1ZjL1c1RStWVExUREhx?=
 =?utf-8?B?N1BjekNjSU93N21IQTFGbVdUeUx0bUgzZ0UzenVNbExieXJhUCs4aUVwVXhI?=
 =?utf-8?B?Q1RrejZIdTAzMSthOHZYK29weCswd2RDekg4M2d1VGxkc1IxT1piaWdJUnNV?=
 =?utf-8?B?em04WVdqMEdlZTRZOVR4U2VITXc0RGw0SkdZUFdSMURUeVNhOUcrZGZsV29M?=
 =?utf-8?B?aGQrSzQ3RGpTeldvY0RxQmU4RmF0bUZHRG5xNzE5aGl3NXArYnVBazJBWTBn?=
 =?utf-8?B?WnlKZ1FSeG0za1VXenVpM21vd2N3R1RQM0hBeENVeWllZ21LSkhjeURyOGVU?=
 =?utf-8?B?UjNCMWszSkgvY0diLzlPNFpFZUNEdGExb2Q3UWVEaUxQY01hOXowSGVJWTVZ?=
 =?utf-8?B?Y1JzTGx3VmZRM1ZmWll1OHE2blNEdlBkRVlnYVU1SjdYTG9vYnVNSDVMSTdF?=
 =?utf-8?B?YlF5Vk1UVFl5UDY5clVvamJkRSsxeHEyRjZKa2N2bDhuS0tGRFJ5MlhmWEdy?=
 =?utf-8?B?ZVVkU0dXUms5WkNNa2w2c0ExYkV6UmFGeDdvWFBkVGR2bnFTdCtuNHoyaTJG?=
 =?utf-8?B?dS9RRCttNi9CMXlKdXYvRVg4MHRqbFhPTVJyZjhDTzNBVXlKZ05PVTI5bDlU?=
 =?utf-8?B?Mk5JbWlETUYvWTV0TGZBaEdFa0htWEd1ajVnMXpobGdaOGdkaGV1WWJpVTE0?=
 =?utf-8?B?d3lhR3BNbUYvNk5yZjRNNHJIc3NxRWhOL0l6SGdrUTJJMTJXaDhvb1BONkl0?=
 =?utf-8?B?UDZRSUQ3bDBOUGFtOWNYMmIyY2hJa3Uza0srOVJ2S1NGc1lVMHMxVUt0dVVm?=
 =?utf-8?B?Qld3U2NtZEpnS0VtV3F4alNwNHNmb2tCZXl1Z0NheHJ0bGRtZVRzZG8yVWtk?=
 =?utf-8?B?alJSVzB0eDhJcmRYUWl4Q1VYcUtwZXhtQ25QNDlzcHd6bmVWdGxXVmVydTMr?=
 =?utf-8?B?bEVEUUxkajBwSGp4ZDNTY21PQTBueWtoRmNHVkpDWm95ZlpzK3U5UmZsTS81?=
 =?utf-8?B?KzI5cVRFdUFnR1YzVnppaXJMMWpEdTRHWkhNWWU2a05OSFplblhhWE5mb0s4?=
 =?utf-8?B?NjI5Q25hano0WkRocG00Umo0VVZpQThZQjRpYVBXczRPWmpxT3Y1bkNSRmNw?=
 =?utf-8?B?UGZVQzFVbEdPOTAwK3JSbFpUTnNiNC9QVEMvVXN4RVF5TmZZUm5YdEZyaHo3?=
 =?utf-8?B?T2xwL3djZ3Y2eXl3Ty95QWYvZFRFSjNtNDZXd3pteFJJWUlpNEMvTFJDS2FQ?=
 =?utf-8?B?K3V2WS9WVmRhOHdsUHZraGJ3d3dXdzVjTllLbXpuVmJxMjJMTTVPekJYQjJC?=
 =?utf-8?B?OXR0R1puYzNjNGY0T2lDWjdzMW94YVJxYjZFQ0JZa3M1UWpCM2t0NWF5c1p0?=
 =?utf-8?B?VTQzYTBoT1A2Ry9UT0tDODFhWlFiSHRQb0FMRmhZVXpSc05SalczdHh4OC81?=
 =?utf-8?B?cTkrVkJLN2E4c3pmVXBQL2orTnAzeHUzcUEzZlBvMy9ycGVCMjRycG9jVzdJ?=
 =?utf-8?B?RHZONnNjRXdLdDNBR0VmMFkycTZ2Ly9Sa1krTzQxYUR3cjdDUjdDSmZKSXJO?=
 =?utf-8?B?WnAwRTJHRTVwNjBwWTZjVlNIaXk5SWdCZzN2aERZNUNPaW5vT1hmT2ExWWVX?=
 =?utf-8?B?MXh6Y0lVY0xGRTBBZmdydTZoL1N6QXdva0JXZWxKZW1hTm5pQjBUSkNuVFRL?=
 =?utf-8?B?Wm9IbC9ncnFZRldmOFhiSy81WkFGUnVLQ2NCK2UraXBlbmJZRW9mSXlaWGk4?=
 =?utf-8?B?N0VoM0szNVQrMDZYR3hPKy9RSVBvNWY1S0J1UkxhMFdlRTlQVVp0THY2L2VB?=
 =?utf-8?B?c1dHanBNbkRKaXYxbnpwemk4MHdmWnNjTXNCQ2FtLytkaVlLQVB1bXhGMlZE?=
 =?utf-8?B?K2xTVUZrbE1JbHFIOTFjWmtWRkJObytGOHk3U3MzRDNucWNyOGJlNExEZ245?=
 =?utf-8?B?OWxCaGtVNWVhSTVQV0NkbXBqVnJtWDdhbC9VeEZUVEt3SWYwQVBNZjNKYllH?=
 =?utf-8?B?N05PMi9DSERoT2N2ZXpzV3dDNW1tcitGck9YWlV5cEtpMHlrSnR5RTZwNGli?=
 =?utf-8?B?M1hEY1JqSisycHJxdmc3WlFLNG1DTkRJQ1FMTEMvK3ZCd2lmVW94bk43blAx?=
 =?utf-8?B?QUIrME9yc0VUZVdPeGp5MUpUbDN3MkhpMFRZZXliQ1U0eDRtTUdJckxFcStT?=
 =?utf-8?B?bXlOTFNmcExYeHEycENYejl0V2ZRbVl4K0FIb2lrendCMGxJdU9wbzUvK1p0?=
 =?utf-8?B?dU5RbDkwWHUzY3NaSjBTWFdrNk1EYm9kQnhpL0N4NHVGY0N0YlY2OVJpWjg2?=
 =?utf-8?B?bTF6eXozQXh3SWtzMzByVGtPRllMNGJwNUF1ZjI4RFYzQzlETXRmUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d48bfeb-fb64-4ee6-640d-08de65893841
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 14:08:36.7418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kl08zJBA+U6fs6t3jXHzhuy2uHRr9iBxGLHRlHYk8V/VI29rbzgDODx4mgY4XKym2/8+hQZv5vgpHxapvvWQxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF8517B3F27
X-OriginatorOrg: intel.com
X-Stat-Signature: efq8eyjh9e5imt9ms3mwdkz4q14km8mu
X-Rspamd-Queue-Id: 77B511C000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770386922-89251
X-HE-Meta: U2FsdGVkX1+aavZnZv5tqdTeg7YjRqwkVT2TOGRuAfxLIlWqwYFky2craoMVavcIkpJnub7Q/1T08SffPApQD45K+o31DMt1DmTNntvADjE/99PEo77hQHjBC3tq1a/k0gbXgYxehW4ATR7y5xHv92EnKU07hDT/SbMxQsiyNXRW6/W+a4QcPHg2ezixnE0UQPLwutOkDJR7gzbdepLUirpuNexnufsCc0i8/PvliskpplJX0DH/Vhc7EphgxdbzVdW/Q/8zDx3Ijo57niZBzew2T9lGpZyP6gp1a03G6+t/JdC+iRqk4dc689hdIJUSERJARAkrLBYFa9odFoDxDvMAwyXTp5MQ70x5WNC13YEIAVHBUt/mXIRhsBDQk/u4UNMnIa2UGVazLc5nAnNQKBEaHTDg/Pth7FmSSm8BdlnWOuCwQHZDvfV3hpyFYjaN1CIwlKopIC1BXfCroD4YPGCu5kho1yhPgBn/j2v9tZPZ33yhGqbsNh8J4oVtSXYUauGxmqO4+XYHm3JbxAEY9oCzqn+8eeiNKoYfllKDMn+17g7RJAySEGRNA1do8wIbQwdDQKDtZRWVT1qDhUNvPflkMUOGjcUOwZY3IfBiR7kMBkmZbFKVQsbv3UCBNuH0Xz+The9R/1yz7wTl+vudt8739Cry6jgsifSDp0xfz8+unOv7AFXg9MHcq7kPbmZ4QUQXex/R29pHIyf3Pac2UdoV0fiP56ApZM+ySFYfhwk5PnIXiMprv60hgNBnsxoUXPJe4ZTO3fQzrux3F4dIoF/VanWg4kbusyN+yuNH3DfJ6UZn6jr0Jz16g9SyTxIeymSIi39DDocR2hGtvrYsU2bYQdKLb1PLT6B2aVX8A/BExoMhW4A6AacE8hIJlQk4M1ep+n8ltbB+d47tJ6ktFAGNIMzt9kFGZCOFEEXBQTRWVbQy0AmdRUJqUfdM393p7C1ZJC/47KSJGYqKORH
 SSe9yaNX
 YwxOI/ftj5eQojVud+EqOnkpAXkSG4QWzd4Bic/pEB5rZTLSRAdk9SLQQG69g2BDe6u4zRKHAkKuZnb19opebJWBPFHKsREbTP3VqRrsgpRa6TS6rPQ8vbijNiAS1r2GNF64Z6L40V7IBxHliOceWB58XPx+UrVT+BoSP1pW+JN7v0/Gyv9qNNc7IHYozbJlrH2A0op8uKaqRDrUvz/PsehXm2mkM7Q4h6WCr35MvjsZea4Bp5EGQAuO8STGsGFiHW3LC+eMT/iWsLx/+q8bOXO+6B6wzx6hVtTNHQBDajRuW9W8VEcBUsyZIIv0jjU50eq2gVXe0GViJui1mWbH+eUtELbZEWR1d99M3pUD6EoljlzecPsf+I2VesfKHZewsY5kEaGxZdT695SSYYwsG0L+AoPphKPBsyNwM9sLP92XqQRPq5fAkBZz8TF0dRqhL/qLcmVPc47BnQL9bRzzqsQoXuGLae8/4SCURLqT8vjLLcczRA5306mVi+Y9UuPSz56+lustbpJ+ZR6EEqg2Of5mY7H2TV40GTZabZT2U7iDsBVzFs8e+j8Nh2XjbNMddxK961J7uZwdEqzPyk1cLycqJchM6pqVJ51NdNXqKL5n0Z+YHt8uBFcStRObXO3A0hvhkTAAtcMPyS64OB2e83VJvPbJ0V4XqJzXMunrTQUlLc+yGVwVgH5GVdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2/6/2026 9:03 PM, David Hildenbrand (Arm) wrote
> On 1/30/26 17:09, Tianyou Li wrote:
>> From: Yuan Liu <yuan1.liu@intel.com>
>
> Nit: subject should start with "mm/memory_hotplug:"
>

Got it. My bad, will pay attention next time. Thanks David.


>>
>> set_zone_contiguous() uses __pageblock_pfn_to_page() to detect
>> pageblocks that either do not exist (hole) or that do not belong
>> to the same zone.
>>
>> __pageblock_pfn_to_page(), however, relies on pfn_to_online_page(),
>> effectively always returning NULL for memory ranges that were not
>> onlined yet. So when called on a range-to-be-onlined, it indicates
>> a memory hole to set_zone_contiguous().
>>
>> Consequently, the set_zone_contiguous() call in 
>> move_pfn_range_to_zone(),
>> which happens early during memory onlining, will never detect a
>> zone as being contiguous. Bad: the fast path relies on the zone
>> contiguous state may skipped.
>>
>> To fix the issue, move the set_zone_contiguous() call to a later
>> stage in memory onlining, where pfn_to_online_page() will succeed:
>> after we mark the memory sections to be online.
>>
>> Fixes: 2d070eab2e82 ("mm: consider zone which is not fully populated 
>> to have holes")
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>
> How was Yuan Liu involved? If he is a co-author there is a
>
>     Co-developed-by: Yuan Liu <yuan1.liu@intel.com>
>
> missing.
>

Yes, Yuan Liu co-author the patch. Thanks and I will pay attention next 
time. Appreciated.


>
> Likely there is no resend required if you tell Andrew what to do, so 
> he can just fixup when applying.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>

+ Andrew Morton for awareness.

Hi Andrew,

Please kindly let me know if resend required or you are willing to 
kindly fixup the titile and Co-developed-by tag for me. Appreciated in 
advance for any additional burden that costs.

Regards,

Tianyou





