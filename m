Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D9FCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 13:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17216B0010; Fri, 28 Nov 2025 08:33:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEEDF6B0026; Fri, 28 Nov 2025 08:33:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6B36B0029; Fri, 28 Nov 2025 08:33:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9318A6B0010
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:33:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55C2158927
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:33:20 +0000 (UTC)
X-FDA: 84160107360.11.5AA6631
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf06.hostedemail.com (Postfix) with ESMTP id 24002180019
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:33:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gS3ZpFWA;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764336796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKQQ4bpPOdW/whkRJG3Q/RpPsLiAtg5suJSKaZAT1KU=;
	b=jjdrFn0tcuuggUlGFZC1E0TB/vEDhL8zB1N39ZUX+tGfRIlwG/xGymqZ9YLjSH7z2r7N5I
	qN8zz3Xkm8cdngf79LiocRAVTU4iIP7mXdAKLqpEk7G4noIlBJ6cQHvfZzgN+6YZwZoAmI
	RKiMCykEhN0FSOwmO6aQpkVhcStLOAg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764336797; a=rsa-sha256;
	cv=fail;
	b=JCeGEyh+LRm0Q6u8hbfpfo2XGWt5yw0oY6LINdJSLZBI7cCCC7nu6TDNaJJFYDaaj/8ucF
	kGeU20UDBzZgL6+ri8PzMS3codG5/qe+fRvnow5Zsvo/BvfgAiCH8r/AZdjX9k0PZt4QyB
	I7v4S8yZ9c40GmTF+01d7jxvGIRRFGI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gS3ZpFWA;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764336796; x=1795872796;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yKQQ4bpPOdW/whkRJG3Q/RpPsLiAtg5suJSKaZAT1KU=;
  b=gS3ZpFWAEP6nr2sqMT0oNPPncgy5XJioAl3cUSkth4bAEjU5THDkQ+eV
   2/H6ynvbEij7h90eQyZRBh06Gx6d8enHv41a+skSUwpwWxD/fiWwBq/qZ
   afzp8SKHOdDL4p9o4cJ6hkvveNjefARgIJEL+T6lqhwlD/Bvj28NTpu5f
   IPX46ksydmISvB94tZWTrs2dQJ02bSxbvwbRpbBybVTbgWn82Z0xejCuL
   8owQXeClnhjRpufrGSjpP8dYgcED+YWQju+8NRTFBJLrjuGx4JbzF+a05
   RwO4XDafUEIh/0SR/sEwDJDSFPAgEwvsFx7qygQ//+nCxgXGulSU4U/DT
   Q==;
X-CSE-ConnectionGUID: VTZEiU03SJeqAmAPavzZeQ==
X-CSE-MsgGUID: /N42w49ERzq7Ypc6OJGNVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11626"; a="66258989"
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="66258989"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2025 05:33:14 -0800
X-CSE-ConnectionGUID: 0S9ZxZFNQoWkYXhSt8oI0g==
X-CSE-MsgGUID: iozku4CeQo2ItCUGY895Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="192722385"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2025 05:33:14 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 28 Nov 2025 05:33:13 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 28 Nov 2025 05:33:13 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.20) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 28 Nov 2025 05:33:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l8PlAkwMVfsI4N9HhPadoj6kOlDezBGBPLrdidmNxa7gHIbKRnZZe9LfPKrN/ih01p5Fm7McIeAiMk33nhiA70H85Cqzt5daOD5glXsIc3uQdl6FI4Q9EAS0ny8xOr1D7FVMLyd5PWiEk/h1F/Np45N6ckeub5a+Ck2OeUOVmtz2OHPCncnKiurU+uuPLw3fGrnyIYDUHbIm6pYFZUX/RFSBv0nlaDir4XlW8HojWnG82AYD0PZLgkSWxCsSN/IEbF6+Qn4paIE6etuUiULFDLeMRo+5ninqO18RcfeJ4yatLmN+AgYQjOe3tBoe57XayBkJjRI21Ugznwt/tTe4Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yKQQ4bpPOdW/whkRJG3Q/RpPsLiAtg5suJSKaZAT1KU=;
 b=izpJzcblHMKhppZzGbg4mLUhPzHdlStvBL5NPixXfqeChVSyuBnmjfjXSGaLFMfZ1Y9txmDMkyVrwRWFgKv1+CPvEE8tSQCLm6yp1aQ65gmolETy6CKx+6LmT5qspOZhYSruYfHZSEOAacJJcGdFmVHp1K79aUP0fHrPogD4tw+2h9HaDPxA8uweBx0ffcWd5ekQs0r/NByogxS+VrzGpgh+XVr0sAGAa4atRWmpi8oVcvx2Dd7Wk+i9hj6pBZd7rEwtqCe85QN/zWptGlhCU2fSdFaHMI62lRQQ8ajSACjdZNmxlAAOXsPqtyjt1+MhsBLSP6tp59au5u19lfdQKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by IA4PR11MB9232.namprd11.prod.outlook.com (2603:10b6:208:56e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Fri, 28 Nov
 2025 13:33:10 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9366.012; Fri, 28 Nov 2025
 13:33:10 +0000
Message-ID: <b9fd0a75-c8d6-48c6-bd36-70ab0d70b5b9@intel.com>
Date: Fri, 28 Nov 2025 21:33:01 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <aRwAjSQBby614Itx@kernel.org>
 <20251119040718.2735199-1-tianyou.li@intel.com>
 <38d90dac-982a-4adb-a4aa-3b8caa6d81c8@intel.com>
 <d70f4bd6-0e52-490b-8237-a2d87f24c3c8@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <d70f4bd6-0e52-490b-8237-a2d87f24c3c8@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KU2P306CA0046.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3c::12) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|IA4PR11MB9232:EE_
X-MS-Office365-Filtering-Correlation-Id: fb81c80f-64ee-4723-c1c4-08de2e82ac12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?clZ2MUlrYXhmVmF6NUQ3bGlsOVhJL3hEd1lZQkZ2NVJLOHJQVVMwMWRmc0Q0?=
 =?utf-8?B?S2JTazhzK0ozckpFM1p5V3Q0SFk2THRCT2s5SmFaMS9IcE8wejZIZGIvbFJO?=
 =?utf-8?B?ZjJvOWFSRmpEOHRKZEdzc3RKSTFZTXllSExrR0FlWTFLaVdMNkVhSHFSSVhT?=
 =?utf-8?B?bUQ5T2NqVFQreUZZSWpIbSs0NVJHV3RBNlpNR0JPcFBzSHQ2MTlIMmp0N1RM?=
 =?utf-8?B?dXpZUlE0a1RJVHc3ZVlUdnFFdWppb0xyWUNCdWt4WVZEUFBUblBwTTZmVHBr?=
 =?utf-8?B?TFVQSmVnNE9LRDRmSWxFb2EzWnZ3SjY1Ky81ZDNJTGhoalRJWFVhbXdxZDV1?=
 =?utf-8?B?Nzl2OFVMTzdsYTdLZE1CVmNjdXdxaUsxOGd2TUFuQ3VCS0pRUENuQ1I3dHg5?=
 =?utf-8?B?dFVZZUxpcmVhMmVwYlV3cFloNUpSOHRRVE9zSmtXaHQyYis2RWgwUDBuNGkz?=
 =?utf-8?B?NS8zR1RWWXp2QjRjelZEZHJmeFc3Z2xsaUd3WUVXaTVzenJaWXFMR3VmNzJE?=
 =?utf-8?B?amFDMU9CeXExMFN6bG1kQko2V09GdnFGZFJZaDF2b1VQbkdQVXNrTm9CcUE0?=
 =?utf-8?B?eUhBMUM5SFpvcVl3WGdMR294YnAwNUUzQ3RQMDFTNFpabHFuU25Ecm95R2hX?=
 =?utf-8?B?Y2dYelN0WEtzVmNTeko1V0FLWjVGOHJtMTVGTDVOd0lJbGpCN0UrNG1mWkR5?=
 =?utf-8?B?SHpnaWQrSkpQTjFTZ2h6RTV3R29GbXM5TnAvTHpmOWdRTzVPaEFoWkdJUXZ5?=
 =?utf-8?B?QitCOVJxSjhMVEZEZ0IwVlp2VVovSzNNRW5hbE5WZ0VpbUxtcE9YVWlkL1hU?=
 =?utf-8?B?dW9LajZsZUJXdndJNFZRUjBiVDRjNTNmczVYV2sxTDUxWVNDQnRRdWV5UFFi?=
 =?utf-8?B?ekNaaWZ5NjNVK2dObkdnL05qaHVJVXp0RGNRa1ZOV2x6MlBxU1ljbFpyTUUy?=
 =?utf-8?B?VVRyUmY3TFVZa0lHbXRFTmU0eHdNQWhTbkFhVjFIK0xVNUdReEY1Z05hdGtJ?=
 =?utf-8?B?WGsvc0VxZ2U5Q2FTb2lpSGZVTjgxUGdwSUNuVVpmdDJFcEkzdGd5SGZ0ejRw?=
 =?utf-8?B?Z25pWitzQkFsQ2ZMU1FuamhVWWFDR2JWTjNsdGxGMlFaY1AwU3N6L3VPcWVQ?=
 =?utf-8?B?OUszM2ZtalZ0dkYxNDIySUtSMkZSOHIrK080bGJGcS9aaWtkSnIvTkg3OEFY?=
 =?utf-8?B?S3NieHB0bHRLS0tLeExhcThtUU11dG1vTDZzcFJ2RDR2Y1A5VTVXZFRJOUVa?=
 =?utf-8?B?RVRJdDNGbEozNnhUa3RTQzJMeFFJcWpxcWtLaHdPdFRCUElZNUtqNGN3Mmlv?=
 =?utf-8?B?bmdEamJyWHhTK1NXTHRjNlNiK1pKOUplci9WSXZLZGViakJWSm5pRVQyemUw?=
 =?utf-8?B?YzV0cVpaSHdOV2hIQkVTL2VHNTJSM1MyTVVIUUVMOXFaY1ZIeU8wR3d5eE1y?=
 =?utf-8?B?TXZHcHBDNTdrc0I0ZXBmN28zeGN3Uys1UDNrcmlBd0hKbFBVSld5NjJuSldJ?=
 =?utf-8?B?bS9qR2lvTm42ZFBxcXN0cFFRdmlKTEN1QU9TTG50ZU92R1I1Smdodk1CdDZr?=
 =?utf-8?B?Q0NQNkRjSHhSRk4rV25xM3ZiVVRkNU42QWtBcndCcGYxUVNabEFHUk9GampO?=
 =?utf-8?B?Y2xoeTJJdkNrdmdvQVFqakNqakYxSXkvRGpRd0tkRUlwaGpZL1lSbFZlY3R3?=
 =?utf-8?B?NWxFdW93U1R2a2hGQ0x2OVpmaU5VeFJXTmF6TnNXK3hrY2E1OGZFNDFjT3BN?=
 =?utf-8?B?QnFSMEhxVnY0VHl0b3FXcndSL2ZxdGdzSnJFRGNtN0JVR0lZZWZ0aWdyNGlV?=
 =?utf-8?B?WjRPaFJCUVM1aGs3R25iOGNtd0N6T2JqRnBFaHVBVnF0NkFqZnNzWWZKbFhn?=
 =?utf-8?B?NFRHREZEditEUHVNaTV1K2pyZ2ZRT2I0TEYzcFJjUU5uWlBDbUxnK1BEQXlz?=
 =?utf-8?Q?DlE8sq0G1IBhXECN3Negjnetlmgcbqsm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGV0bUR5Uy91N0N4aTN4UzByUDZoSlduR3lhVmpnZmUvTlExSkZuWFliRk13?=
 =?utf-8?B?eDk1VHhYZVI5TnBxQ0IrLzRocGtYS3cxa0pPNFJ5MzdocVp1OC9GVGFmcENT?=
 =?utf-8?B?dkZadCtOM1U3a3JjVG5DcDNIVWt6K0tkWTZ6QnI5eTdFVHRHQ0VpWm9TaHhP?=
 =?utf-8?B?d1NiLzlsTWh4VHRIazVxVzYyQ2hmWEo5MCtTOU03ZjZORzZza3I0L0RwR2Nn?=
 =?utf-8?B?V05Zc1k1NHVZNEZQTlhlR0I2N2FBWXovYk9VbWo0Z01BV1doMERydmJxR3Rx?=
 =?utf-8?B?TVlsTGRxLzdNWnZBQVdDdkZBdmR6UmlGaW4xaHRXWGZ2WktYTnR0U3ppZW9T?=
 =?utf-8?B?VWY4cUpJbndwVXpSQTdJMmFya2JZRXFQTEoxTUQwT0JCOTFzYU5YcU40a0k5?=
 =?utf-8?B?eDcyNTlxbWNpYUQyL3V4VUR1NUc1VGpQS3lOQmFDUTIrSy9DZUxEQlFCazdW?=
 =?utf-8?B?RVE4cWxYN1hIZytnTWJQODdmRjZ6QjAvWnBObmozUXdPbXd6ais3N2p1SDFu?=
 =?utf-8?B?VDNVNHlJU0N0U0tkamJhRlVZZFY1RkpXcThuRnZrOTNXTk5lZkV0dnk1M05O?=
 =?utf-8?B?MGRFbzhJODFmQVVUa1F1bjlFalR0RE5NYXgzU21vbGpyUEhvZ1hqREoydWxH?=
 =?utf-8?B?b0hvUW1YZTV5ODdIM0xZaDFrcUJsQjl3N1VUSlUxV3ZRUlZWaVNWd2EremJ2?=
 =?utf-8?B?MU04RVQwRloya0JENm9BNGhGOFIvdDk4NGxqZGJ2OFBCdll3dExHVVd6RVpp?=
 =?utf-8?B?WHI2ZDVIcU1BSXZpMTU2ME5xc2Q0bG40enNnK3RGTjQxN0NKQmpvMEY1QnIz?=
 =?utf-8?B?T2wzRGxHN2QzMmNuNWhTZk05MDUxMThOQjlGMHd1U1ZQZUtrckdpTytQSWhs?=
 =?utf-8?B?M3lqSHZseVh2UW9ibndDMTZuUnkyYWVOaG16eWFtRnBRMlNITVd3bkhCamRW?=
 =?utf-8?B?d0xUT29SajF0aHhEQzBudzZHK3VBQ2FIZ0ZEYTJOdDk1c1FlUDNqUUtWT1FE?=
 =?utf-8?B?cHM2aTVpdldVZWFzQ0dFZUtwM0IyYVA1dzh5bEZzczR1eCtjckdlOU5aZmNK?=
 =?utf-8?B?bUNVbW5lWWlSUnA5UWMzNEltWWx1U01kK0I5Z283bXNGZW4ybG1nVHFwbWtI?=
 =?utf-8?B?cnZ3djFXeFZBa0xuMUorVUgzbG51QjdUL3UvLyt4MmJ1My9EcVJOaWlnSXZQ?=
 =?utf-8?B?RzE2Z2V1ZlJodTNmay9ITk12MUFFWGNScTJOVjQxSmR5MzZ2Z0c2ZFBuSWQx?=
 =?utf-8?B?YWZtbnBkcVRMcDBkeDFmSzZ1Nm5ENG8vMmJvbXgvRlZlRFB4RkF4Z2ZPc3JL?=
 =?utf-8?B?QjJCeHNkay9jeGw1S2lUeWs1dHpnZjVUd0tvMFA3cklUSjlOOUFKejdQV1NC?=
 =?utf-8?B?TjFUUnJlU1grNURLbkYyUmxOb202RHRxb09zTWp4TjJSaUNpN3pBT1ByZ2py?=
 =?utf-8?B?Wk1wKzFjazEyMVlUN2gzTW5WcmFPZkxmN0l6TFYycFR6N2hGcE9jemJoREZn?=
 =?utf-8?B?bnVtaXdvZFAxQ2lsdk9zb3VnTnlPa29nRWhSV0lXVmdKcTFWU2x6alNiN1hM?=
 =?utf-8?B?TGN5SEhraHZweGFDNzUyY0NCQ3liMWhvbWI2NEkwa1l0S1ZFc1kyeGlldXFj?=
 =?utf-8?B?YnlQSWZCYTE3TmtCNFp4Mi9RSm5oRHQ5U1RFS1hjZG5DTG95SWhOY1ZXMG5B?=
 =?utf-8?B?bVpPbWpEWU5GallqTTUrVDVIRmtsQWh1ZmtUd0Z3eTV1ei9iMWRNbG5tN3Qw?=
 =?utf-8?B?UzJ2QVhGQ2NBc21wQlFGWlYxZnpRbWNPYUh0d2hvTFpSL0Y1M05wZVpQRjdv?=
 =?utf-8?B?MWgxeDhXVUs5UkU1amYvMDdiTnNnVGFuZzJpK2Foa1piQnN0N1FJZmgxWVhP?=
 =?utf-8?B?dGJ0ektnODh4cnJJRC9pQ3NwN3ZJUVo4U3l5MW9MU2RUcGhGREJrVm5mcW5X?=
 =?utf-8?B?b0JWT2d0WmZLdThGaHROTW1ZM1M2TzZrZjNRTGJEbXo4a3J3UGl1SmpHUWox?=
 =?utf-8?B?dzZKNFo4Y2F3N09PQzk2V3BXd29JWFFNbXg2eW85SWJBREtSSG5SQnFTQXMr?=
 =?utf-8?B?MG5uQldBNnd5cnhXNldNeWtCN3ZpcmM2WGVVMXFkSk5pWmkrY0NDcnZPTzFv?=
 =?utf-8?Q?2VNTMnZXv8kvzRS2jHNDDIdAm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb81c80f-64ee-4723-c1c4-08de2e82ac12
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 13:33:10.3416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w/us2K9jeMjsMScUMXPp7UJRMnLuEJ1PQVV2S/PVBdpChyLQMmq3Kk6dA1hSGdHh97N9AhBgqGgXXoA72rRqgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9232
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 24002180019
X-Stat-Signature: 5o4y6ti1gc1aihjnuhrogwfa8ghcwizk
X-HE-Tag: 1764336795-515395
X-HE-Meta: U2FsdGVkX18gUapAejSGSgHAiyMncjs6GlSWfq68U3rSPj+LE2Oc4DQNcwVHeD2ZSpVIYbK/LjG3snlKbyqKhUu4dvTyXynu5OxyGvul6zcrLaaa4HeR4IE4Vrb9tpdEheYEQTxzQH9outQRF2v9fv3xCPFVkdPVjOC71FxpgktiZ5Qpr1q/sj3vJ4TzYhBq5ANFHXgWSEoE+ItjQW/qzd2kHRyCiJ2iwG1eVSGsrIiPd7ZijdC4dJ80U+DgYEVWMyYGIxPgodV4nQUWHeC9s+wBYHJXENjxU/yj2g4GOdsrzwX1G7hlwtyZRwWGGP1yDMGBM6UKBhN0WE1jqMfFs/lsAPk6tPpfu31GyvTJd1pnqtCYiDKwAxWzoEwoN6Q3AOfzkIkR9n3F2fKgVS0ziVSHX/hrCwxuEoUgcggcHDEGG3sZ6nXt/mt8oqU4OgYfWx18PG9O/P/rixE3Va+ppytcNRFDzieDPCCscdrq52nfik4e1P67Nay5sSbLGwZB2YM7yPSIvYbaoquBIWm8Q9LBXQZhp9snZ8j6/qiGd7gI4GaT1tQ90Fbvp1PfkpJ/E13ztUjhLNyqISerjZIeWX6betNC+q7uorqsLPhRDKDMcJv6BrhN4/UWuhELRpxTxpe+EiIsVOTxA+q3aji63pLfeUpt1wiZ1nSEONrAQTdXh8PKrhIgQym/j3jmweLvyhMCFw8UL0I5oX8Mre8qfFg7CoCSHslChKBbf4k0Xl7iWjtq4wQ16eNSb5HgULll52ie+wlJ4CDzcYKHeZWH21scATwk8PcCOheIA0HaR5ptNuGfjtYB1egSF8mvtiGBECd7zROzHjGSoA2pP5gzFb1quTterQJ5rcGw7YSzlgi5CAwsNyj96Y4vejZUmiOEgWA0OqOXXfNPOw03sojgCZbRtxhDOMtTlSOVmMaW5OR3QvVe2iImC63lerz9HskdmPM+IGBd433p21IGZar
 IQ04ix2k
 HA7c7kpS4oVm3ALvDN+AQ3qo/WQ4kCHSsyD6dhxJ0N8HbMk1j89aSZhlhzXKgnUgWePp49PrA2RsQK+FxD2Hf0nO1U3t5VqKAE/kRg5+sO/OdYRKPE97h8uDcg5cTuyfoCHYDd5k8bLZLIyLViMgzshXIFw5m6YvJFlU93P4IMTvbGlsQlUlGBlgpaqzDn3LZO0G4uvQE9y35A9fmebJBENJv/GQrQ7JoX/69gZsOyvKbJm6cpbBBRlF8WhtJzVa4L52A+BtZK5CaysD22qajtXqGKjH3CYb9qN0tavxdwHW+aCCeQm1px8mGl1vV1E2DVvhxSkQKc774Q3+fhn/lQJDFPZ2ULgtmbIutPdAy00ScT90+4xNn+psa9lEplSor9LlC2V44bkWMAd0sdEM7Np0S5infevJw317DOIsD5s19ZOG/kxUbbu1rTpV3Paz+wvEOekCsCzMTN6vRSfrtIWE0Rb7Edhr6EqbAfpaSkCERAX4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks David. Appreciated.

Regards,

Tianyou

On 11/28/2025 7:49 PM, David Hildenbrand (Red Hat) wrote:
> On 11/19/25 04:13, Li, Tianyou wrote:
>> Hi All,
>>
>> Patch v2 with the changes suggested from David and Mike, which
>> simplified the code and also performance get further improved on
>> Icelake. Appreciated for your review. Thanks.
>
> Now about to review v3 :)
>

