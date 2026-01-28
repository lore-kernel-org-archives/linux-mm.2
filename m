Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BD35D2FEDA
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20FC66B00AB; Wed, 28 Jan 2026 08:57:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8406B00AE; Wed, 28 Jan 2026 08:57:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02D156B00B0; Wed, 28 Jan 2026 08:57:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD0B46B00AB
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:57:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB30AD423E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:57:00 +0000 (UTC)
X-FDA: 84381523800.15.0390609
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 235DE4000B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:56:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=V9ieM21k;
	spf=pass (imf17.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HN9pKwJx8jY81PVhQLiEjzqgrR6sPZM1Oz9guNsZWjQ=;
	b=SEAw2x8yQA11YQoZ21G7+cwr8KzXCQSDtq66IXz+A3yHLZdq7xo+A0SXVOjAzXFDdFI4jS
	YTObdvWerwQOFAuyFehrQNxGGLakxkmg2Js6h1uc0KPZCfMOMuQ+dLHot9Vtkp+HIiRECk
	trwLNc9tXkWeW2Byl2xpOJWBcUwXKEg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=V9ieM21k;
	spf=pass (imf17.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769608617; a=rsa-sha256;
	cv=fail;
	b=OvZh8zV4bH2Jl4PrEFMssOPMJ4/BwgNYIgi/06+2ULQVl1sFNlRMwF+M3J8LVLyEDK6L4V
	LtFBUDxsewNE+tbnPZQg43cpZvcjQ8c2qnulIgO5WO9e0LMM1py/9wQ5UlO6gSrVPDCufF
	5KIeV/Hl31UE+HiCj0B2El0PpAJPY60=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769608617; x=1801144617;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yTITLMiulpkDzCNH80abs1SPkh82pMmHR+Hax0MN0iE=;
  b=V9ieM21kRloAPWxxyVbxXlWTobzMGoBjxsu3aq4lWov/j/RwNOvWTk3s
   bAoVtCgBhmJsbNu3bPBiruQHMl+5YoaBQFiq+yfJky4XmRaba+4h8TLjV
   wY6K8IzrLh2VG/mDapFH4Ee2DmpXN+4objD0dmzggnFrLa8nBXZslzZzN
   pdH6PkhZxG8veSofMlyxbo2+RN7S5EReIqtznfR9NQNLdd7xqyYTvnGsX
   foaXOjPHWG/v7XVrJUx2hacODVJj6stkAL7/gVkK9HE1biVK4WW7lAK8M
   tSpHNMI1GHh10gyUT2PNGUVs17Si2Vmu/W7VbNLWp2g7KEMi6FjrlCiIZ
   g==;
X-CSE-ConnectionGUID: nfgrskyGRXmL5mMVlzk63Q==
X-CSE-MsgGUID: 7Ja0O8hOSKCsdrjnYaTiBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="81543188"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="81543188"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 05:56:56 -0800
X-CSE-ConnectionGUID: XkLxW+dtQQaEuaAuZCNdRg==
X-CSE-MsgGUID: FfSkhDJwRGqZU8pIPriBaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208646651"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 05:56:55 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 05:56:54 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 05:56:54 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.43) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 05:56:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pkm+u3whQsY6vA9Pz/DbB4HQgOlwlJMFm64jvNz0IAArjZ+a9WLBbOT7OjOJkcs+8/+G+eI6IRqFYmpQBhxmm/Aq6AiiAudeiPFlJjG795MrUREuUhDo1Brvro2Tk4tHjGk8csr7I2ALhA4jL7Dew9vQPgpagoP1bz6biwRCahHQ8fyHZyjhWFrivdp4tQjDUaXTTWPBloZAVGtp5XX/GUiHaeLdEH6NjrdgLOKdm0UGeooBzrFtFs7jBh4olWyKjexjtyT1DSjpsTTle/L2Fwk0U9bxojIh/hpfyRAsWC3K0W/2EsyJJQURZyKKRnkQ/nGA3oPPhRdnQdChnDV5eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HN9pKwJx8jY81PVhQLiEjzqgrR6sPZM1Oz9guNsZWjQ=;
 b=lBy8Yp/N3iC6BHqzjLryVKtfP25AZT6FWU0hpGv+pdA/X3hJsHEaeBm7aGn5X8m/4tB7pk/AS0ILaZHZ3KI3mMdGvSdzs79U7hOGsVQblgL7muLbilI3gsjM3bKROG1URc4qRPHdx7fTFspXTIir20MWsZpODkMpvoxwf7QXMAdoqy05PJKuBOX0yg6hhNROgi156dkMGnXRFNZH3CikpnBO5HrmFWLPdCTcsUE+I/1oyyVGqu99xBXV+Oy4wVh6v8azosxdkJUQYXNHk6UTpyX/CQvsPtV5nwjxBGdqhHZGb6rAzSA2EaRgCVRIL7cw1tXg1eB62ai7sQfW5VOQJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by PH8PR11MB6880.namprd11.prod.outlook.com (2603:10b6:510:228::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 13:56:51 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9542.010; Wed, 28 Jan 2026
 13:56:51 +0000
Message-ID: <becccb16-c7bf-417d-a065-bb3a98eac88f@intel.com>
Date: Wed, 28 Jan 2026 21:56:42 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/3] mm/memory hotplug/unplug: Add
 online_memory_block_pages() and offline_memory_block_pages()
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-3-tianyou.li@intel.com> <aXIK55fQeKfB-jM0@kernel.org>
 <705d63f7-2451-46bc-b1f0-bef718b82283@intel.com>
 <aXhiJFvEKFk1Flpb@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aXhiJFvEKFk1Flpb@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::7)
 To MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|PH8PR11MB6880:EE_
X-MS-Office365-Filtering-Correlation-Id: 08f48bb9-b896-464c-4552-08de5e751660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eE5IVEt4am9Ja3FhWFpGOVg1SHluZmh5YXVmWDRMeDlaQXNRRWN6SzhlQ0do?=
 =?utf-8?B?c1FoUnpSVjRPYTloUGNUa2VDekFBTGIxcVVmTy9Uc1o1bUZ2SGlwN1lJdC8y?=
 =?utf-8?B?UWY5WURaYXFtblJoNUdDTVR6Wk5hOWR3dnBxdkpnV1ZaRTA1K1dnZUJJYnpR?=
 =?utf-8?B?UXA3eTJBNGNNMlZIVTFlNHpzK1o2cU9ieGZjaXRjUlRUamRnQTNGZ1RyYllq?=
 =?utf-8?B?NGc1dGJ2cFY0YkNNaE45OWZWTW9ERFpOSDlKdk5FOHU2VzZwVUFGYUlOQUZn?=
 =?utf-8?B?N3hIUGRWa3M0WXA3RzZYWFpqR1IxcWI4blNMUy9Ia1FNdStVOVJxcWtkWnha?=
 =?utf-8?B?MlNaNGdrR3ZaUWtScWtqU0taZ0VrODBzbkRKaUlUdkNNdFQyYS9lQm9kWFZ0?=
 =?utf-8?B?aEM4amw5M2pSTlVYNit1RktsWGcxTzgrUDN2SFhYRURWbDFNZmVTRkhxZ1Bt?=
 =?utf-8?B?RDI3UHU1S0QxT2ZpV08vL1VuWTRJRTBRd3RKY1BNazgwbmF5bWlETHRhQjBj?=
 =?utf-8?B?RUg2UlBCaWEycnVpTUdBMHlpTS9FbUI3VkR3OW5keWVSMmlNNlB6UFFMVjM4?=
 =?utf-8?B?aEFlR0FrVXhYR1VrVjVRaGNra3l6MmRKNkVTQUUwcEZ6QWlPdlRaSFozancv?=
 =?utf-8?B?YVJFMkt1TldqeW5Ja2RZQmo4UWJsK0FwMW1MVFg3Y3ZibUlkcVBxVjB1RXdP?=
 =?utf-8?B?U3pkQmV3T2UrelRLeTRuWjlySThUeSswaDBIbzF4cERWNFlGOThZZFh2NVpv?=
 =?utf-8?B?ZTQvQjJoR09kdmdzT2N3Q0szZnpwTlBOU1JBcUhZVTRHYkhaS1FLUVRxYW9v?=
 =?utf-8?B?YlZkWkhON2p6N2xqUVBBUGRqUUVVaUNMOEVGdEEza0JCNDZXaDBzdkI4L0NI?=
 =?utf-8?B?Z2hYb2JuZmx2TGJBM1pSV01rMjZ5TWVoTlZJb1JXUmRoeGpmU2RiSlhtb0E1?=
 =?utf-8?B?bUc2MmgvdWI0YUlBOTVGcWsrenU0di9DWDlSRmJDOUFJcUhqa2UrODRpMUNo?=
 =?utf-8?B?OFpLeUsybUlETDJ6KzNoMFBjZnZPeDBzTDBEazdrcVc1NHhTcVJYcWlVS2lo?=
 =?utf-8?B?REptWW12Umw1VzlpaDBJaitHeFRoWUtHb0c1bG1oWkZ6YkVPQ0pMY2FNWElB?=
 =?utf-8?B?cW5QMjhuQ0JvSWpQNXNnWkxOKzFzUnFGcXdvMXVXYUNxejBmbFVpQVRMZXlt?=
 =?utf-8?B?Yy9CSTJTclBjdmdkVk1YV1hlaHBRWnVibWZadE9sdjhxZlQ4dUEveGtoTXZi?=
 =?utf-8?B?ZXdtR0MvWE5lczBXZjhMb0pZRDJMT0xtRysvcWo0Q1puNjV6eUdpUFZtNVhl?=
 =?utf-8?B?cDUzaXprZDZIODZPR1lzM1V3SDRXR0NVcTJ0cGIySVNsdlJFTXNmdm96UU0v?=
 =?utf-8?B?MFdCd3JBT29RakNTMVpDeHpObmtraENxb2ttaXVOcVJaMllEeEx1d011MDB4?=
 =?utf-8?B?UVMydmZCVXpDZUNBSWRaUUJIUU1PbE5NSUQveThxSXRmVVl5a3lYMGpCb281?=
 =?utf-8?B?dUNIVjVNWnRwTWlVR290WWcwVExBcDdWaW5DcXJOTHFSM1hOSFEvOGNHajVh?=
 =?utf-8?B?RzFva1BaenExY2xjd3QxbE5sb2RZZmFxRkZIWGdkdVA2L0hBNG5NdTR4WXpK?=
 =?utf-8?B?elc3Q0tHUWF5OHloK3o2ajRZVG9ZOGlQR21hdS9ObkptbHNMUllXVnI4RUQ5?=
 =?utf-8?B?bDdhaTF4UTVoUU93TVN2VEd3TmRFSTJVSnhDME1JQVRXWWNVVFhYZGttQTN0?=
 =?utf-8?B?MWRTWGp2a0FxWFVYdk5yTTdDckNrNXNIL29PbWhTY3B3eCtCd09qbVN2WTJS?=
 =?utf-8?B?YkpCQ3B4aEJuK0RaU2JhdFNla3ppUy85OSttUzUzUFNPMFV3UUE5aHdlTDVR?=
 =?utf-8?B?aE5Za1JQbC9sVk1JVjI0Qnp0V1A1cVpzZnlheGZFUUdHVzlKdWp3clVtOXBL?=
 =?utf-8?B?dkNVRzFNUkpjR29TelVhRFVOMzhCaDdreGdGVSt2d29HdEFBM1VzTHJzUHdR?=
 =?utf-8?B?UnJ4RDZBQ0NIcmlYRUVDNkI3aCt2NHVnZ1VTWFllMXFVbXB4ekRyOFo1MlF3?=
 =?utf-8?B?eWZkVWxsTWpWejIwV3daTGoxa1ZCWC9IQlEzNjEwTWEzR2EyQ2ptdmdoWFU4?=
 =?utf-8?Q?jBEo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHM4ckNLV1BiRloyVTA5d3hlaUgxdmZaL3RhbWxObDV5TzVucWxVNTYyYStK?=
 =?utf-8?B?NzhJUS9ZNm5TU0JwUmliVVdWYmN4ZXRsUFlrYWlIRkRSOXFMa3NLaWp3OUJV?=
 =?utf-8?B?eTVGSEVJd1BvbGppU1RFbFhvemU0SFF0Wk5BcjFRNVVYRy9WMjlKMzJ5YXNQ?=
 =?utf-8?B?bDl6WGRZdEtFVmpMUXo2Z3ZrRDAyOTdpYW54M0dqQ05raDVOcDU4VHYzTmJH?=
 =?utf-8?B?ZFpCU0JCVTJIN2xxa1FhUWVQdmRhcnV0c013KzFGdlBJVmprWUNSRTBQSUoy?=
 =?utf-8?B?RW1JWjlQMmRSQmdBYTZFcG1xQkpnR0pXU0ErcGNneVlTb1ZvR24yQVV3c091?=
 =?utf-8?B?UzduV2JNRzVPR0J1b3NjNE1sT1hjcGM4N0FYVGZhWStiU3liUC9kQVM4dGwx?=
 =?utf-8?B?TCs0Q0ttQytsSWhoVVc5WVRGYVFQd1BHVjR1dlJzSWNoUVBFTmhVT2pNaTI4?=
 =?utf-8?B?T1RoaDREa0N6bHlxL2NtU3J2RWZkVWpVbmNNbDJiaU5vWmxQQ3J6Um9FR0Vu?=
 =?utf-8?B?STN6RTJPRGVuU3dJQlAxWi9VS3VwQStCRDQreUhWY3FES2E3MElMcjRmTUFq?=
 =?utf-8?B?Qm9vZ2h4M3QxSzNWdm9vaTFYQ094ZDU2dk9NVEV3WDlIRlNtVjBkM0l6UEhZ?=
 =?utf-8?B?NTVHWFZGcDlkSTlGTHdtUTJOVFJ1dFBORlpxRnBtaVFEeDBZRzZMZjl6SzZo?=
 =?utf-8?B?VHN5SlRsNkM2dFRZdGpQanMwRXNqRVpTQlYxRjBVamd3QW5pMnVRODVBYlNC?=
 =?utf-8?B?Nkl2UDZrMVNpeDNuNisrc0hHa3pQcDUyVUVPTjAxZ2oyelcybnIvZlcwOVZw?=
 =?utf-8?B?T2R2T1oxaWhZVHhpVDNocDdCVGRuamFvT2pSNWRaRGJrZ3RMZ0FsN01Lc3NH?=
 =?utf-8?B?OG9BNXdDUHZRUmlYUXplUzBkVkFUcHV2SnM0WWh3cm9uRG1YSU4zQWRxVm5k?=
 =?utf-8?B?bUpNamlYQ0c5T0w2UUliWGEwMmJuc1JFWnh2Mzh0bzZyYWRVMkdwMFpFQnZV?=
 =?utf-8?B?elM0S2toOHpxbzNtMzRBeSs5aXFkaHFwbzM2S1YxUS9VeVJkeEhyUHlrTFBV?=
 =?utf-8?B?b1VxTzJoYlEwZURkSk5VMUxqZ0c0ZTk1NkJ6ZHp1NTViV0Y2OVQ0QmRJYXZP?=
 =?utf-8?B?UktoZVV4dnpzZHlJeGhyQWJuUXJ3Y3dGTWU1RWlLZ1RwTXpNZTZWUmJwNndo?=
 =?utf-8?B?Q1YyRDQ3aWljR2htYWZVN2M3UVIvQThQMVdUSmtOMWhGRjF2RjE2NVlMUFB4?=
 =?utf-8?B?L0FLUXlPU2VyMENQT2lNMGtVVGZzUm54ODZuTEVGZkU0SnhINmpHZ3JEVkRy?=
 =?utf-8?B?ZXpXOHBUQ255SGNBRHRlWi9TK25ad3k5b2UvMFJvS1lWTERLMmlZdG1RNFZw?=
 =?utf-8?B?RVVxVVptQ0IybE5PY3k3cG5rT0d6YTNaVGVGQXF3S3gyMktnZUxZVkNKak1X?=
 =?utf-8?B?MjdSU28xbThZVXd1a1ZkNTRMRXF6SzU0NWVveXNOQ3JCNUNNSGFESzJBRVZn?=
 =?utf-8?B?NmJXNWs0MFRVaUE0Ukdab3hzK1kwUXRaTHo0b0VsekI1dmVVTjd4R1k2RmNB?=
 =?utf-8?B?c0hEbkNHQlg2MUovQmY4RmJBOEZlY0orMW1OQm5ZVHM4UWx1clZSdWNDQThG?=
 =?utf-8?B?MkhLYXAyL1hjT0JzalczSnpkL2FTVXRSNXBYL2VNRGlWQ1hHZHdEMXdQQmVv?=
 =?utf-8?B?eUNkcUZnNndyR0ZCVnl2M0VnWWhnV0toN2RQVXU5ZlYrZFRWYXVoejJpQmg5?=
 =?utf-8?B?TlBDN24zWU9ZVmNvUW84OU1oRmgySU4zdDRTYlBGYmIvejJMK2tEd1lZVU1p?=
 =?utf-8?B?M0hvNndJM3FvL2x6UmRGUnJrQVJ5SUdlaDFPU2dxSnk1UVdKL0tPd1FyOUFi?=
 =?utf-8?B?R0lEdnZQa2Vxb1lweDg3bmNjOWNyeXhiUkxLUWVjMEwzeTV3Nzd4S3NYK0FM?=
 =?utf-8?B?T2pLWGxmcVFuN2lPV0JkNktKa3FxRXJ2NWpqOHRmMFRmWDI0eVBwODNwbTJm?=
 =?utf-8?B?bGRtVDA1c3B4ZEY4emwyY1pxd1MwUUk4R3FnUlR0SFJUOVBCNEM2WWEvUFNx?=
 =?utf-8?B?RjRTVS9Nd3hBd2JWR1BlWUQwVVhPRFBkendhamJKU2dyaG9nT0ZnZmRBVE1Z?=
 =?utf-8?B?M1RucnY5Q2Z6Z2hLeERlczQ2UHpjR0xndkRFUC9HN2l1Z2VubmFsOS9OUllP?=
 =?utf-8?B?bGNpckxSWENYK2Z1UGk3Nm9TT1ZuTm9zOGRCNS92bjNiYUR3SUhrRWgxS3NC?=
 =?utf-8?B?bU5NVlN0bWREQ0JCOWNQQy9vOFYxSExHbWtQSTZTOENxWFh6Rmh4T3VzKzk1?=
 =?utf-8?B?TjdadDRJYXZ1Y1hqTFY2YW0vMG5xNHZEZFR4TnNJZzlCWVFkcXZyZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f48bb9-b896-464c-4552-08de5e751660
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 13:56:51.5553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hkvsynmRc6rzQ2lYqKYoEEyopi2yamd6V90k4IxkDk6Y68N6vYWbfkCYa4AXDOU1155CDePqtypAmlUoLD6fwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6880
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Stat-Signature: dcek6r8dsq5ei5idiymggtho7mdbqj5a
X-Rspam-User: 
X-Rspamd-Queue-Id: 235DE4000B
X-HE-Tag: 1769608616-943596
X-HE-Meta: U2FsdGVkX1+IMs8+MgAVmB9/uJNUhPEyjMfiFvytkfagn7CS9lElGKWTENuynvdwjAXmVwxfuoS6wBLEmnJYU17I5/70s6r3aBmRW50oFHUzzbpUwBv0fmJsjppnzu4wPYSWFivMXzkxXAwQJkBJIsgCDCkd7avobkRRj9a+Mh/iApcI7FnhYWB7tFk0Wc0EMcKS2eaePFoN+G9k45bwbPo2/ODHb2v2YTm/oZwZtsIPxYLSLlw5paH9KjQNiSsyg8ZOJ+DmpEhmlkG4OxZvp0h5WjoJgZSxhXNnQ2UV/263vdkO7GNOetHkZcNZT3xD8E4C7iIU55dZ211cyPa9t0l22hRX2Rrh6cyHKq9h+5QvDmtDEzvsurga0zqWCAQzlCMkBydtaCS/W1Z2XeDqWXjhZ7j65XW9+AdiikZCWuW6+iRb/43YgtUClDtVrfh+af1IFE2lXQEZzcaEPcEyu2poZbdjM3/KOYXm3UMp5YYlslL74Cn5DG7kLKL2N9Q6hCHNv2ikGlWtfKaniAdc8ygBZ8lrrenpw5k5HUyf9cIzR+KvG24dOmJvNXoJ8XRpIktIz7RDCeUZJ37KNe9pC2uDig85rXiA1X0mnRzkhl1BnnuJsWKoCLR7x07KM/9hhOfFLBUcancSXlQBV/NluWuFsoNTV6hgUw66GP/zDG7z1BT2WTr7tHB3gikfLEHlYb4fRxib4w40SMOwGoT/bg1MoH0EFPIpauTQYp8WPPA7CZ9chWMhVGyu1wrYqkpeJn0ki5N5AcwY3Qv6VYZSyHYXJwHsBv33S00OmziF2JLIekex7e+QqJaQN4z/akn14LLoDZRvoYaJnze2W+x5p1bGkfhF2GnvlMdWvu+tw0ymZqRox+azDZKcoQOPdm3DKKG3GFahfI5nvspUQ2EliPVEkA/EoRiasZecmCgtWnjJDXhFWQkUFw4CWyUMHMlhUfWJ3okwPXK30KxueoZ
 XAZUDEat
 38W6iJUhGB4WlM36QtwIHdKQ6XeK/83t3O07eXDPONdZbYADav1Skp6l0r/Jkx0BRr4eVdMcrCzaQ/f2uqy8ClrwExpjGkCXIT6d9sWRnudRCsq2QdHjJ+8WDE6C/nIjA8CtrUMUiWT5Nj2EKOrMS3sF0Sw4kW+2lLuJE+76ncjEX7BLBME56HBYWYfqwsn2VSfn2xHk24WzSHvfsebqvMXuEBcbCqBz+yDpJ1WPFTMtVqux1PwavfuPEmhiuEelJTeP/stBjOMR/94nPUI/tnwlyR/Z98s2997O6l89FtpwO9QsDOKd1G61wQl8ifC54JMh49bqLe8LrvYzu/7hMiD4v9ElpiI0vUMDjbVbOVLBwgLGCM2W9barirmoTI/4MPzTg263bibL+9/hVr5/q2kATmAlii4Qfiz6rv/Mrgn3Fsw9T4g2dzc9SjivPntiFdJgdXgosAHBA3pRytx8LJP0Vcpav+zDFxSdos6B8A+fI5ieO4mFh08Ium6xhudJIc641ZCH52bpOUURY3dFj/Pa4+hpt59GIoown8Codt3OGBOyxszZ8FMI6YtJSAo5k3DPf3dyZ03WkeILn9jfeXWrskPJnU8w9ueo9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/27/2026 2:58 PM, Mike Rapoport wrote:
> On Sat, Jan 24, 2026 at 08:30:57PM +0800, Li, Tianyou wrote:
>> On 1/22/2026 7:32 PM, Mike Rapoport wrote:
>>>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>>>> index 751f248ca4a8..ea4d6fbf34fd 100644
>>>> --- a/drivers/base/memory.c
>>>> +++ b/drivers/base/memory.c
>>>> @@ -246,31 +246,12 @@ static int memory_block_online(struct memory_block *mem)
>>>>    		nr_vmemmap_pages = mem->altmap->free;
>>>>    	mem_hotplug_begin();
>>>> -	if (nr_vmemmap_pages) {
>>>> -		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
>>>> -		if (ret)
>>>> -			goto out;
>>>> -	}
>>>> -
>>>> -	ret = online_pages(start_pfn + nr_vmemmap_pages,
>>>> -			   nr_pages - nr_vmemmap_pages, zone, mem->group);
>>>> -	if (ret) {
>>>> -		if (nr_vmemmap_pages)
>>>> -			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
>>>> -		goto out;
>>>> -	}
>>>> -
>>>> -	/*
>>>> -	 * Account once onlining succeeded. If the zone was unpopulated, it is
>>>> -	 * now already properly populated.
>>>> -	 */
>>>> -	if (nr_vmemmap_pages)
>>>> -		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
>>>> -					  nr_vmemmap_pages);
>>>> -
>>>> -	mem->zone = zone;
>>>> -out:
>>>> +	ret = online_memory_block_pages(start_pfn, nr_pages, nr_vmemmap_pages,
>>>> +					zone, mem->group);
>>>> +	if (!ret)
>>>> +		mem->zone = zone;
>>> I think we can move most of memory_block_online() to the new function and
>>> pass struct memory_block to it.
>>> I'd suggest
>>> 	
>>> 	int mhp_block_online(struct memory_block *block)
>>>
>>> and
>>>
>>> 	int mhp_block_offline(struct memory_block *block)
>>>
>>> Other than that LGTM.
>>
>> It's doable, if not other comments I can change the code. Would it look like
>> moving the functions to mm/memory_hotplug.c, change the name to
>> mhp_block_online() and mhp_block_offline(), and change the references where
>> the original function invoked in drivers/base/memory.c?
> Yeah, that's what I thought about.
>
> Even more broadly, I think the functionality in drivers/base/memory.c
> belongs to mm/ much more than to drivers/ but that's surely out of scope
> for these patches.
>   


Thanks Mike for the confirmation.


>> My prior thoughts on this was just break the code as small pieces as
>> necessary to handle the pages online part together with zone contiguous
>> state update.
> IMHO moving the entire function is cleaner, let's hear what David and Oscar
> think.


Sure. Actually the patch has been ready with the mhp_block_online() and 
mhp_block_offline() moved to memory_hotplug.c, the 
online_memory_block_pages() and offline_memory_block_pages() remains but 
as static function.


Once get feedback from David and Oscar, I can change them accordingly.


