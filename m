Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 684BDCEBF92
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A991F6B0092; Tue, 18 Nov 2025 04:07:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4AAF6B0093; Tue, 18 Nov 2025 04:07:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EAA96B0095; Tue, 18 Nov 2025 04:07:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4D96B0092
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:07:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 210EB16046A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:07:26 +0000 (UTC)
X-FDA: 84123149292.04.2DDCBF1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf28.hostedemail.com (Postfix) with ESMTP id 42E65C0012
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:07:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Pr11rpBU;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763456843; a=rsa-sha256;
	cv=fail;
	b=OkLQJV8oNq425voHI5mu5Y0Rpcx72nN/Xi5sMgeebkttGYMuIwK56JeaZDh+lYBO2h2fNZ
	4XjZf0rpNYCVfTE9cXykIGh7RHTh+17QIbiY4fEH5OSVl7dDTbSrGAm+isgaUudNuFKjo3
	QMNkQvzchcREm+VQJUgNvKbtOO8oSTY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Pr11rpBU;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763456843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nn1VNgTpS48f5ySHlT0gMj8DLJAkIwyRucFM4sMKqOs=;
	b=bb+LS/nlxvSYjscQC8VswMIk8pBzHKhea7DbI7XiHHRz7+bGYXZOs5DWjYltVRqHKuH/oj
	E3C5mLuSDDhSDMdKu6u9Pgk+D3SkPKTvbOMOTpgk20ko+5WcUqAlVVpftziDA6PGvcChzz
	A3YJurbJNeG8IgW3o2zn3QLPXenIUTg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763456842; x=1794992842;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MCl29NgM9gNW5VvZvJmVYhZdm5N2dokxav0u67hzHVY=;
  b=Pr11rpBUWA4FMUiUp3QJNBVjPwdu8eL6xgWauEEfYjh5qTErd9dfxnxY
   iPp30IB5TNyHBXRQ72UtyLdIIvAU6OFVOfQZ2VpUmBGC1e/C0r8HiFFrW
   pw/RyJ4ZAqf0vhFCwoGwTHt9EhObq/7dHSRNuGdSuQFD+IJz8r2nVhbgc
   gmLCV8fKEOk+l1gdfZzXs6N0PKasVoPYAAtWNMQ+X6ak3Qxa//s8AJtV+
   gnOfpwb8xN+LOQEsNuYCoyJfrDGkvTAIfVGXK6e1u5/0cTSViIvMYWf3R
   Gt6sxsa+6pT7fpDx/kC1gdStrQTUEZsI5XE+1CqsA2TzB0NlzMgO17QW/
   A==;
X-CSE-ConnectionGUID: f3LD9p76QFq8/WwP2byPVg==
X-CSE-MsgGUID: Xfa3DuedRLe9YmK6RyKmcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="69090269"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="69090269"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 01:07:21 -0800
X-CSE-ConnectionGUID: Lm2zdMYgQo6Q8JyQwB3K0A==
X-CSE-MsgGUID: KqABl8t/S6+MgDCpYStN9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="190926330"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 01:07:21 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 01:07:20 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 01:07:20 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.53) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 01:07:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ha6N4D7A7iQlzrujlxu2hbrq/s2Fgwa1WR7fH8ttWeUDvcwIKbFzmZKbAI0NL4WvOKFbdCeajYT5dqtBnQV4V1xuo0xTEHOiB5D1nFRC6LaLPIU0puNAVZVbwipgqhVBMYWomCk6dCNirSpNb2qi0TtfQUM5P6IlqgEfTBMcFPeRu7dOIBP+W0m4oaByraIqaQ2NovM/cPVWimsBKHJbKoyZ7Hs//ZV+VSSdIDlOa+p0YmVU9njT5GVwUNs2ZP3SF/Hk1OhMTjaA24x6UvbHr5d2H0zGdWLT3aDjB55pcldg00M0AhM+gos4K6VqlBGj7a1gVmS6iYQ6TTOuhLvW1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nn1VNgTpS48f5ySHlT0gMj8DLJAkIwyRucFM4sMKqOs=;
 b=JMjetV5+FrZPSt6e7qcMN9TfMu5hdbs6O7qewXAq9Yxq0c+mNz/V4he6E9Xm9HeLQ0bWikTrngn/T/q+1JJgNs2Z/6rOWcoO7p3ZGTj8lzVg2/H/0O5DFllhRE/ILmZ5ZVhLEYuZU8mMPsAwwl4sOatTW1Z3amYvJWRmkVs2Mi8tl9vG55MzM/s9oPivXmFMP6yI8PMgiP8jpvrbPnSk/mNXGlBkhyvgrEJXGjS8jDCiEZsGwMSuePkKE2n/9HLcqzCU+xv2JP8SMYKntr+aJSiuA4f51HclQSZfdbG0+0Jd7WzR2URuUsf+gGPQNgfpvVM3slr46VHtOUbrEjXa0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by MW5PR11MB5881.namprd11.prod.outlook.com (2603:10b6:303:19d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 09:07:17 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9320.019; Tue, 18 Nov 2025
 09:07:17 +0000
Message-ID: <79801dc3-234f-4de1-bd26-56d3cd7b731c@intel.com>
Date: Tue, 18 Nov 2025 17:07:09 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251117033052.371890-1-tianyou.li@intel.com>
 <da7fea0d-8749-4905-b399-4b6c6551b173@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <da7fea0d-8749-4905-b399-4b6c6551b173@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0057.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::21) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|MW5PR11MB5881:EE_
X-MS-Office365-Filtering-Correlation-Id: e9c853eb-1290-4c44-460d-08de2681df57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dkVvRC9haWk0WVFjbVpQYVM4RzFWaGthR1ZFLys3andsOURYcmNCTFFsRGRi?=
 =?utf-8?B?QzdYeDBrcnNSQTljSnZCZmZnN0RFaE9EanBPTERCVTdHL0pHU2M1R3Nibllp?=
 =?utf-8?B?amRiMGtFMzh5L01VQm5zUktNa0tZQzRlWWEzZHNjbjdENURQRmxGSmVaWHFw?=
 =?utf-8?B?V0FRcVVScG1PQ2lzc3kzSWd3UE51SjRzRDdOZmdxN2s2a0Q4dFpIZk9xWkE2?=
 =?utf-8?B?L0NmMzhVaHJZWTFNKzBLelVpaXFMR3BWd1FaeXlSaVFjcDJkSmNldVRLdkJ5?=
 =?utf-8?B?VnFISE1NZlhtUDJsbG1lbjZkMkVyUjR2YS9DN253QmhOM3lsUnE5OFJXTkgw?=
 =?utf-8?B?QW9xbmVHOUtXaEtxek5ZcEtSb0xaSjlNcGh0UGxTclAxQkcrMTU2MEFsMWRP?=
 =?utf-8?B?S1JOUTM0WVVWY3lNVHhhMlBrUFRWRnlKY2hOdXMvd292djBSWmRwWlZzRjEy?=
 =?utf-8?B?SVhVYk5tUDE1bjRWRHN2bDk4UE1oTTNhVGx1UTI2bnBsMlN2L3RZMk1xc2wv?=
 =?utf-8?B?MHdXR3N4aUw1RlNVTXMyQ0N0NmFVSVBSVnVnWG8xYTh1STJCWTFRKzZ2WGpt?=
 =?utf-8?B?ZFBtVEhBV1pLa0V2QmFVRUtVWWhJYXg2cXBPbU4xOXdoQS9MUUtQOXI3cVht?=
 =?utf-8?B?Z2JlMk1SVHF2UXFHNUR0bXhmaUpTcFJZNXJtU09sR2wvdWdlZmhuQjhjbnRt?=
 =?utf-8?B?NGZUelBJbDExZFhlUkJ1N0RteDRMelN5NmdDUzUrYVFkZkYvK0l6TC9Lc0Zj?=
 =?utf-8?B?WFl4bkliU203eFJZdEhhVUtTU0l5cU56ZGgzWkEzWHliMC9MNlljVHV3c0Zn?=
 =?utf-8?B?UEd5VlRIVlFBeVkyQTBSQlVSTTV3K2FkWFd4RWhQVkVOQU9OQ3dQL1pTSDZK?=
 =?utf-8?B?Y3Vib1pPWlJ3WG0zSFhPV2FpR04vb0NJYWhPd01tZGJEWk5Oek11eEs2ZWVm?=
 =?utf-8?B?ZWtpQ0JGR3lua1c1OHViaXRqOWd3T01naFlyYS9iVE1nVDdkdVFBbEpRVzdt?=
 =?utf-8?B?a3RIWXI3UE1YOHgySUE2NXRaTGFUa0s4V1h0TSs2K3EvUVZ1RVdjYkZ3SEVW?=
 =?utf-8?B?N2lwbEdOMWhiWTdFL21FSW1uMjY4THpWVGVWK3RmeVhyUFU3WEUvSkYzcm1u?=
 =?utf-8?B?Tyt2SmJXQTkrYUY1Z3I1T3VRT2dvR2FLZEh3eHlnQkozSjhnSmdqMzZsUVFZ?=
 =?utf-8?B?THE5ZTU0WXZUNGdoRGhKUXZSdktoOCtscUU1NUxLNG9qUStycUdWaERBL1hL?=
 =?utf-8?B?WnlHTmFmc0tQUkw3WXhaTFNxSjRlRmZ2MnJIdnFDUGtCNjByQTdwRmN4OU9h?=
 =?utf-8?B?S1pGMnlkK0NjTUI1bkdhVThNakgyTVpGbFkzNnRGSVdSNWd2SEkyeURGL2xL?=
 =?utf-8?B?ekVCVzMydFNqU1NFQU10SWVjcFIzdFJNSVpOV3FLNjQzSzE4ZHZTcTV1Ti9D?=
 =?utf-8?B?N1BhZUMxNVBSWTdTOEJ1RDNiNVVnWHBQNnVHb29aSWxJd0pKMkZieG1iRXFM?=
 =?utf-8?B?dlUrSlhjZkpFUEZhblZnb3Y4bmZmM0YvcldIeE1pQTc4bUNOT0VwQ21ibjNC?=
 =?utf-8?B?OHJhT3RlQU9NMFFTTnhoS2R2SWhNdE5scDdUeXd2YWlVeGdRUDJQNWhaSEZ1?=
 =?utf-8?B?QXdlM0FsNDV1RVNnY0h4cmhsaXNkdFlhdktWNzlTZGYvVVZyTldJayswWjI4?=
 =?utf-8?B?ejRZaGNyU3RPcDlUV2IzeUZOSmJ4TzMxd0xkWjZ6ZmE5U2l1dlBlRjdCVVZs?=
 =?utf-8?B?ZnEyclJxbUs5Tk9ZTVdWNGN2SGh2VUtSWlI1b2w2dS81Y2N1ZjBxSUZzckVW?=
 =?utf-8?B?VExnU1B2NGNmTnF5K2pJZFRScW5lSlhHV0F3K2czSnhjYWhqSERrTU5QMGth?=
 =?utf-8?B?M3ZVWExmcFhpLzY2MHBZSG9STmhUcTU4TUo4eDhld05yUy9jTzE2cnVsazNV?=
 =?utf-8?Q?UdYfF63Nhmb7yYvoIP4L8oyERxOPDQ1l?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enI2RlhRNGxSd0hrTUxDTFJRWjBZeUNrMXFidnJobHloME9kb0VwVXRTTkpW?=
 =?utf-8?B?UUhSd1JEeXVqMVBHbkttTFlEMExzTk8zK2NlZ1V5c1kxQno1YzdRRlN6WWgw?=
 =?utf-8?B?L0gxSnR5SnhBL29YTlg5c0pDajBDZ1dxMHc5MXk1TTZjcFlmdVFJNjh5STFV?=
 =?utf-8?B?ZWFEa1AvM043MmZDaTBGeXJWRjZGbnBSNXF2anpnMGN4TVBnMk9RU3NyM3VI?=
 =?utf-8?B?aTljNGx3MkEyRmE4UUNBT2trZkROeWEvT0ZnVmtoZmlVVldONXJGOVBMWFFw?=
 =?utf-8?B?a0VMa284SzFMV0xyYUpiWithNGd2dm1uTWFYQUhHMUdIZWRobFAyNkI2OVEw?=
 =?utf-8?B?OGt0dHBwN2NaOVBhNDBXMWJxeGNmVTJKTWo0eVlnanMzZDVyWG1FelhzdGJk?=
 =?utf-8?B?OWVWMHllYUNxamdicWVLU2ZoMS8yVTNJT2ZRM3RaK2NuOVNSTStUMk5GVm11?=
 =?utf-8?B?Q3lvZmFYOW5GRE9lYnh4clVOckNROGRVK1I4Wm5sUUtjVTltYW1PblJjQ2hT?=
 =?utf-8?B?SVVQT0g1aGdQMERhRXVMV3pvM3R6OU5BY1lFbjBaUzRxYjM0UXNrdy8xNjRX?=
 =?utf-8?B?R3JhMmVIMVNyT0NaTDZVUVRiVm9oTENsczhsQTc0emV5dWdIdTRyZTFpLzZ4?=
 =?utf-8?B?UDNRbkpZODhlWXI0ZEtNMU9ZUm9LQ05IbjNWUmRmUVNmNXc5YWF5dExIbkJU?=
 =?utf-8?B?ZGhvbEVjak81NE5tdXFoaW0xOEJkdVEwVEd2ZmpOSVFaaC9mU2lmUXk1K2lu?=
 =?utf-8?B?OEwyQWluVW5neDI4bDM0Mlk2WHN5OG1qWkdXL280ZkVPcEVMSGVoSXJXNTMx?=
 =?utf-8?B?Ky9QNUpqcnlHUlU3S3Q1dlliN1hpQlZFMVd5U05ZanBwbEp0eFFrYlcrdnJq?=
 =?utf-8?B?YWxTbGZna01ueHdxYkpzMTVyZHRpamgzSTdEUHMxU1hwVnpvaGxMRTh5UTdL?=
 =?utf-8?B?UGhLSjl4OWRsRE8wRU1aYnJrWlcycmFKcnI4V1M4MEl6WkIvYXFOVzM4ZG13?=
 =?utf-8?B?MjVteVdRZktuNTlNRlExd3d3RlJvWkgzbEZxU1dZcnpUZGVpUGVudGJOb2Za?=
 =?utf-8?B?UTZMdThqSTFjWDU4RHZlOU0wK3JYMXBXUVFqbmJZSG1TVzRYVWFnZXRVTzMx?=
 =?utf-8?B?T0l6eHhyQllDaVRSMzZ3RWhqN2tnT1NHUjlzaDVTQ0gwOFdKRW9pbFBITTBQ?=
 =?utf-8?B?UFcvdkx1aHV5Qzl3dTlVRUZhdXF3ZVo4dlQ2OGdZQ2lQZ0pqZzYyaUNiNThB?=
 =?utf-8?B?WXB5ZlM1WnN3ckJZYzNJbG1Wa2gva3VnM1VDSzZ6Wmx6RlE1SXA0bVZad0Z5?=
 =?utf-8?B?cm1EbWl2YVh0K09Xb2lCcjkyYnZwYnoyOUt6clpyVkVHOHF4eTZWYjA0NXht?=
 =?utf-8?B?QVlQT2svTC95WjRqTU5wMDlsSkNmUmI4VFhVQUJYOW9wYjkzTVZEY1E0bjV2?=
 =?utf-8?B?V0d0THBRVGlOc2RpNlJXMC9DMXNySk9TVVVzcmF0NlYxb210UTJPNHpuTlV0?=
 =?utf-8?B?Y0lmeHR3Z1JBb3Bld255R1Zlb1dTQTZuWTVnK1Y1VGlobldKZ3c3NWpqbjYz?=
 =?utf-8?B?QjNHZnZBUHFUaTR0S0UvY2VnZno3N2doNk1FTkhUREhDMkgxZDFQRjdrTGE1?=
 =?utf-8?B?czVVZ2w4YjB6UDE4emhTUXhkV1lwcXVxUTM1TXh2Rlhia1hUMmxLVzZrZ1JK?=
 =?utf-8?B?eE8xKzVTYXFSNlRwRFFPUEVIbXFFRUxRQUVpbzRkQ0s4NlYrdDltNTllM0xT?=
 =?utf-8?B?SmszY3BoYzdvYUlaRFdjVXFkWlkvK21lbHN5ME90eU9NSk9veTNCUDFGM1I1?=
 =?utf-8?B?NEJ5OGV2UG1rcDNRNG8yWjIyODZGTnNieHNpQ1ZaV3R3WVh1eVZDbEhWQTND?=
 =?utf-8?B?T3VKMXp2eTUrYzNSa3hyRlZHTW1uZktFVTQ5V2N5SUJ6bVVQOFdGR21QWGUz?=
 =?utf-8?B?VFNHU3h5OW1XdzB6Y0J4REJwc09FekpiUE9DbDQvNkM3ckZxUXFaR0RxRUxp?=
 =?utf-8?B?RkFmb2MvaFJ0WEZvUUFPRUFlRlNvYkJaczdPZVV6UXBjMnV4Nk1WZFJqa1hQ?=
 =?utf-8?B?S2NqNXNDNXN4VFZycUpEem5jbXVzcDhNTHlReTZyVzUrRzM4OGFsSXlBZk1z?=
 =?utf-8?Q?VnCi6NulcZ/vtOKWz6lE3egV7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9c853eb-1290-4c44-460d-08de2681df57
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 09:07:17.6631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uV9OmsQT0tdChGI+wUVzHkB84BQNwNe1M30rTpIQvbnwHgyQK7hQPG2jn7ciOSfOEcr9jCkis8Fgr9aw3gBGAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5881
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 42E65C0012
X-Stat-Signature: 8rjry8gtnz3zfyq9ci8pzsuxnfzaznr9
X-Rspam-User: 
X-HE-Tag: 1763456842-761814
X-HE-Meta: U2FsdGVkX1/FwccscfYe5NvKE5E54mOw8Uev6Mzthq/gpUW5ySD/AxJoH26RqaeWoain6cVFErtsiKEpAp2/cPq86QMbI9MN6kHOx2EPLFRRH52Tq/DBCQ9Vtvg+iPCzeV54egmihdRVAzngn8aYy7Aul3kJDcV42GFxBkVm2NDo+bg8nVQzG7lWbYLyS7wQl11WU2cMP9zytfHYvvy7uCR/TYpzED7y/ckDZyyJI+6fSzrc2EzuJK0O2gds1Mup3WfBhht72heqgqT+c3R6WdpYtoVfSEHpAi/qQqsNxVZ3qd3PPQo86SeQyvqFdK6S/Kzm2T0ZzqCa2g+ROxZJe6JeYYh2+e4blhHI2nXvqBGb2Kwz80MTjdyWQjaT/bZZmwWbwce46s3nNJm580CrtBy14VvtrO2zSAni+fuIH21LCNN5sHA2wiZ+ELws67CNRKElZV4sQGrzXsOkDTOG6BVeLOkWns+QeHTzDMiMQ5IhVHtwG/aeCRC05rUb2PZYTHAzYIpXtB7Wl7I98Nl7VERtxDAtKgnfe56als39IyK65kLbmd1WszN9MyPII9hUoFshgI8Y6kIsBuCKnfjRb66zhEhuhGyBu3ro4NkTtLNDMXm3iWgFmMzmKlltjwr8oCzu5s11ZLpPtonHR0hNHKwXCkiN9zYSgOpBOvzx18lJihn/08npeTf4lhUr/yaX1QLNA4hrftlhjN32KGlpfZLRxn6PnBGDfTg5yWInoMrmLjMXRxK2kgZGl+5JyO4RS7ymQXO0N+XWLHqUpQDxefjmFM0knAIfmEfayHm/buWWIywco0atWa3814l592gHwE0ndsqgqJCnR+JZAJ6nlO92cTL6Bl8sOlyYaVW/qqSOiwfCcoDDVKEDNC713hgvsWy8MWE92UEFpZHND05Fmodsrz1QSaTWwoIokp7MhG5QHIX8yAU/Z8fEh3bCrULnJvt9JuNQpu1A2xEHH1F
 rtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Very appreciated for your timely review and insightful comments, David.


On 11/17/2025 7:57 PM, David Hildenbrand (Red Hat) wrote:
> On 17.11.25 04:30, Tianyou Li wrote:
>
> Sorry for the late review!
>
>> When invoke move_pfn_range_to_zone, it will update the 
>> zone->contiguous by
>> checking the new zone's pfn range from the beginning to the end, 
>> regardless
>> the previous state of the old zone. When the zone's pfn range is 
>> large, the
>> cost of traversing the pfn range to update the zone->contiguous could be
>> significant.
>
> Right, unfortunately we have to iterate pageblocks.
>
> We know that hotplugged sections always belong to the same zone, so we 
> could optimize for them as well. Only early section have to walk 
> pageblocks.
>
>     if (early_section(__pfn_to_section(pfn)))
>
> We could also walk memory blocks I guess (for_each_memory_block). If 
> mem->zone != NULL, we know the whole block spans a single zone.
>
>
> Memory blocks are as small as 128 MiB on x86-64, with pageblocks being 
> 2 MiB we would walk 64 pageblocks.
>
> (I think we can also walk MAX_PAGE_ORDER chunks instead of pageblock 
> chunks)
>

This actually point to another optimization opportunity that reduce the 
memory access even further to get better performance beyond this patch. 
This patch is to avoid the contiguous check as much as possible if we 
can deduce the result of contiguous with given conditions. I must 
confess I did not know that we can walk through memory blocks in some 
situations. Allow me to think through the idea and create another patch 
to optimize the slow path. At same time, would you mind to review the 
patch v2 for the fast paths situation separately?


>
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
>> | Memory Hotplug | 256G |      10s      |      3s      | 70%      |
>> | +------+---------------+--------------+----------------+
>> |                | 512G |      33s      |      8s      | 76%      |
>> +----------------+------+---------------+--------------+----------------+ 
>>
>
> Did not expect that to be the most expensive part, nice!
>

Thanks.


>>
>> [1] Qemu commands to hotplug 512G memory for a VM:
>>      object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>      qom-set vmem1 requested-size 512G
>>
>> [2] Hardware     : Intel Icelake server
>>      Guest Kernel : v6.18-rc2
>>      Qemu         : v9.0.0
>>
>>      Launch VM    :
>>      qemu-system-x86_64 -accel kvm -cpu host \
>>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>>      -drive file=./seed.img,format=raw,if=virtio \
>>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>>      -m 2G,slots=10,maxmem=2052472M \
>>      -device 
>> pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>>      -nographic -machine q35 \
>>      -nic user,hostfwd=tcp::3000-:22
>>
>>      Guest kernel auto-onlines newly added memory blocks:
>>      echo online > /sys/devices/system/memory/auto_online_blocks
>>
>> [3] The time from typing the QEMU commands in [1] to when the output of
>>      'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>>      memory is recognized.
>>
>> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>> Tested-by: Yuan Liu <yuan1.liu@intel.com>
>> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
>> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
>> Reviewed-by: Pan Deng <pan.deng@intel.com>
>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>> ---
>>   mm/internal.h       |  3 +++
>>   mm/memory_hotplug.c | 48 ++++++++++++++++++++++++++++++++++++++++++++-
>>   mm/mm_init.c        | 31 ++++++++++++++++++++++-------
>>   3 files changed, 74 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 1561fc2ff5b8..734caae6873c 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -734,6 +734,9 @@ void set_zone_contiguous(struct zone *zone);
>>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>                  unsigned long nr_pages);
>>   +bool check_zone_contiguous(struct zone *zone, unsigned long 
>> start_pfn,
>> +               unsigned long nr_pages);
>> +
>>   static inline void clear_zone_contiguous(struct zone *zone)
>>   {
>>       zone->contiguous = false;
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 0be83039c3b5..96c003271b8e 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -723,6 +723,47 @@ static void __meminit resize_pgdat_range(struct 
>> pglist_data *pgdat, unsigned lon
>>     }
>>   +static void __meminit update_zone_contiguous(struct zone *zone,
>> +            bool old_contiguous, unsigned long old_start_pfn,
>> +            unsigned long old_nr_pages, unsigned long old_absent_pages,
>> +            unsigned long new_start_pfn, unsigned long new_nr_pages)
>
> Is "old" the old zone range and "new", the new part we are adding?
>
> In that case, old vs. new is misleading, could be interpreted as "old 
> spanned zone range" and "new spanned zone range".
>
>

Agreed, the naming struggles. Could I rename the 'old' to 'origin' that 
indicates the original spanned zone range and removes the 'new_' to 
indicate the added/moved pfn range? Will that be more descriptive to fit 
in this situation?


> Why are we passing in old_absent_pages and not simply calculate it 
> based on zone->present pages in here?


Will do in patch v2. Previously I am a bit conservative to use 
zone->present_pages directly in the update_zone_contiguous function 
because implicitly it creates a dependency that zone->present_pages did 
not get updated in any of the functions before it. Allow me to send the 
patch v2 for your review.


>
>> +{
>> +    unsigned long old_end_pfn = old_start_pfn + old_nr_pages;
>> +    unsigned long new_end_pfn = new_start_pfn + new_nr_pages;
>
> Can both be const.
>

Thanks, will do in patch v2.


>> +    unsigned long new_filled_pages = 0;
>> +
>> +    /*
>> +     * If the moved pfn range does not intersect with the old zone 
>> span,
>> +     * the contiguous property is surely false.
>> +     */
>> +    if (new_end_pfn < old_start_pfn || new_start_pfn > old_end_pfn)
>> +        return;
>> +
>> +    /*
>> +     * If the moved pfn range is adjacent to the old zone span,
>> +     * check the range to the left or to the right
>> +     */
>> +    if (new_end_pfn == old_start_pfn || new_start_pfn == old_end_pfn) {
>> +        zone->contiguous = old_contiguous &&
>> +            check_zone_contiguous(zone, new_start_pfn, new_nr_pages);
>
> It's sufficient to check that a single pageblock at the old start/end 
> (depending where we're adding) has the same zone already.
>
> Why are we checking the new range we are adding? That doesn't make 
> sense unless I am missing something. We know that that one is contiguous.
>

You are right. The memmap_init_range makes the new ranges contiguous 
with the same zone as the original zone span, because it passed with the 
nid and zone_idx from the original zone. In that case, should we just 
inherited the original contiguous property, probably even need not to 
check additional pageblocks?

A quick test with your idea shows significant improvements, for 256G 
configuration, the time reduced from 3s to 2s, and for 512G 
configuration, the time reduced from 8s to 6s. The new result as below:

+----------------+------+---------------+--------------+----------------+
|                | Size | Time (before) | Time (after) | Time Reduction |
| +------+---------------+--------------+----------------+
| Memory Hotplug | 256G |      10s      |      2s      |  80%      |
| +------+---------------+--------------+----------------+
|                | 512G |      33s      |      6s      |  81%      |
+----------------+------+---------------+--------------+----------------+


>> +        return;
>> +    }
>> +
>> +    /*
>> +     * If old zone's hole larger than the new filled pages, the 
>> contiguous
>> +     * property is surely false.
>> +     */
>> +    new_filled_pages = new_end_pfn - old_start_pfn;
>> +    if (new_start_pfn > old_start_pfn)
>> +        new_filled_pages -= new_start_pfn - old_start_pfn;
>> +    if (new_end_pfn > old_end_pfn)
>> +        new_filled_pages -= new_end_pfn - old_end_pfn;
>> +    if (new_filled_pages < old_absent_pages)
>> +        return;
>
> I don't quite like the dependence on present pages here. But I guess 
> there is no other simple way to just detect that there is a large hole 
> in there that cannot possibly get closed.
>

Yes, I did not find a better solution to cover this situation simply, 
and I'd like to cover most of cases include inside/overlap/span of the 
original zone.


>> +
>> +    set_zone_contiguous(zone);
>> +}
>> +
>>   #ifdef CONFIG_ZONE_DEVICE
>>   static void section_taint_zone_device(unsigned long pfn)
>>   {
>> @@ -752,6 +793,10 @@ void move_pfn_range_to_zone(struct zone *zone, 
>> unsigned long start_pfn,
>>   {
>>       struct pglist_data *pgdat = zone->zone_pgdat;
>>       int nid = pgdat->node_id;
>> +    bool old_contiguous = zone->contiguous;
>> +    unsigned long old_start_pfn = zone->zone_start_pfn;
>> +    unsigned long old_nr_pages = zone->spanned_pages;
>> +    unsigned long old_absent_pages = zone->spanned_pages - 
>> zone->present_pages;
>>         clear_zone_contiguous(zone);
>>   @@ -783,7 +828,8 @@ void move_pfn_range_to_zone(struct zone *zone, 
>> unsigned long start_pfn,
>>                MEMINIT_HOTPLUG, altmap, migratetype,
>>                isolate_pageblock);
>>   -    set_zone_contiguous(zone);
>> +    update_zone_contiguous(zone, old_contiguous, old_start_pfn, 
>> old_nr_pages,
>> +                old_absent_pages, start_pfn, nr_pages);
>>   }
>>     struct auto_movable_stats {
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 7712d887b696..04fdd949fe49 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -2263,26 +2263,43 @@ void __init init_cma_pageblock(struct page 
>> *page)
>>   }
>>   #endif
>>   -void set_zone_contiguous(struct zone *zone)
>> +/*
>> + * Check if all pageblocks in the given PFN range belong to the 
>> given zone.
>> + * The given range is expected to be within the zone's pfn range, 
>> otherwise
>> + * false is returned.
>> + */
>> +bool check_zone_contiguous(struct zone *zone, unsigned long start_pfn,
>> +                unsigned long nr_pages)
>>   {
>> -    unsigned long block_start_pfn = zone->zone_start_pfn;
>> +    unsigned long end_pfn = start_pfn + nr_pages;
>> +    unsigned long block_start_pfn = start_pfn;
>
> Can be const.
>
Yes, will do in patch v2.


Thanks & Regards,

Tianyou



