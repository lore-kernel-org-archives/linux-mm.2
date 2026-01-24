Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3540AD715E7
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 12:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61A0C6B05BB; Sat, 24 Jan 2026 07:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C7B86B05BC; Sat, 24 Jan 2026 07:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F246B05BD; Sat, 24 Jan 2026 07:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32DCF6B05BB
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 07:44:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3DBDB7E32
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 12:44:12 +0000 (UTC)
X-FDA: 84366825144.01.536108A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6517240002
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 12:44:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lSnOGEfp;
	spf=pass (imf11.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769258649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NcGXjd83hOOCZsqxK9QXixDZlhl28Lpd+Tl1GiLDL80=;
	b=PHf2DVY5uyeA7wAU0qVQ+GigscCR19JqVrW6QT+hKUSFlkqyyPYfpZYDPJz+7c4/lFAn8Q
	XPJH4M4seeyPfIdRlnWyjyj5xVDtR8AgRVBbXlucmwQlbU39BOYMvylZB+pOnfq3geInqs
	/9Tx2710Y/ZL03k43a65nqqCWxKhWUg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lSnOGEfp;
	spf=pass (imf11.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769258649; a=rsa-sha256;
	cv=fail;
	b=Nokm+AitKq3D/nVaqBFe9mhMD1UJg8M3Sb2veGRdfTcOSJVQnuejpDqGkb1YwykKV2quwO
	qO8Tna4pR7/52U9j08rdfNASMk8OmqovDC4IPI7c6J0tovYfaRCuQKuLGoIVaKh0JClNUI
	GQIGeCZBmEdU2PMzGhm67+5ikB52xPA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769258648; x=1800794648;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PD9rsY/0eTmjhZBoLeUQH1OHJZRM13wpr7oeYSgAzDo=;
  b=lSnOGEfpPkNiPK321zd4ShmtpdDCCT0B5rQqXutTVhlGAB/lmW+V5SPA
   qC9wSDSltty3rV1+a82C4xF0Yc5B+uMOobq86vapQrr67qIyQ8i6LVSIb
   ooO1c/gBZKM4P6/SO6kKMsB/6c4x707oI93mDBMMFfyAHrPhIY2vpu9rC
   4Co7qhM4Y95+WQIweRdIUk+hQ9X0T3fpy6+9AUz3//KSXWI9e1LlGg+fo
   nCoFRjo9mHa3HS6yYh9WCGOegaMgl5kQgOVj4cxcRME1qlievVYRLQJVJ
   y1FT81JmZla/KhA1xJz80y62dMNLtXiJSrAUkvZybgDDkyI6K8JGIp3L3
   Q==;
X-CSE-ConnectionGUID: B/a9NO0UReOawqyKCoGo+A==
X-CSE-MsgGUID: gkuXEELmTfy0pwSfDAg3/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="58058559"
X-IronPort-AV: E=Sophos;i="6.21,250,1763452800"; 
   d="scan'208";a="58058559"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 04:44:07 -0800
X-CSE-ConnectionGUID: NyHr2BCTSniZ1gOx8xRRng==
X-CSE-MsgGUID: +bhihAbwRRicAJuvRTTXmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,250,1763452800"; 
   d="scan'208";a="206863144"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 04:44:06 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 24 Jan 2026 04:44:06 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sat, 24 Jan 2026 04:44:06 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.40)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 24 Jan 2026 04:44:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OLGpzKRHwlSxuuHaIsYi7YjR2PqNoP6uCmS++kKIYT1+/JDHauQVQ8LqWpdjmX6jY+QgOW18x4Ys3DkydiITdhJ3wujzD0XdlCzpD+QjqQeY0ypVN1AfsMrAulRKvdLHPX4qkBs+v887vnQwmt+XStQqY9bnIkVkQmeomIYGU99zl5JWJsHdNYTyh1nF8NjWy4nqA9cA7HzNy9q9iSZ+R/n+Xy0sG2jG+0/UaaQw6BYQxONLTGOMxkaA5ObGyECni954WMZywwQ7XTuFyGEBNChsbIuJ7KtUwEVzxzSd8MZIlwmqiR+8U3KT2GKu4vUGM+OJA2wmwh/rac13QGq7/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NcGXjd83hOOCZsqxK9QXixDZlhl28Lpd+Tl1GiLDL80=;
 b=ngY268p7Ozxb72PuhC9zqkPH3rvL42nOkWJIVwmeYw4tfhWnu97gCmfekQVy0JjPUI/+NoPh1ywwCn5krHc45CZqklQRYW0cbw+uDyY5fe1SLvjfM5l0T4bsLEt+0Jw/xXDBtjHehgoVnvaxkZ/8uvLnGMbQnpgtm7lECv0x3pHJcsW5SHEvp60iSqMirvpIUUl8+6XSKZv6k3qhsKDtCDFvZx0Sxy21axKx/ZI/Z9uJdH52ylqo/FMtGBJUtbbBxgcnCyQfMXaJ1XTOhiPPUBDNiHorSovThWNMcDPkoLYL5KZMuqIHVVRmrN4brVQWMDvs29q9eDYOylM8iQ/Uog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by DS0PR11MB7829.namprd11.prod.outlook.com (2603:10b6:8:f1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Sat, 24 Jan
 2026 12:44:01 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9542.008; Sat, 24 Jan 2026
 12:44:00 +0000
Message-ID: <0f679956-fd29-4165-a136-18f68e517fb5@intel.com>
Date: Sat, 24 Jan 2026 20:43:51 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/3] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-4-tianyou.li@intel.com> <aXINUc0ZJSJusel2@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aXINUc0ZJSJusel2@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0017.apcprd01.prod.exchangelabs.com
 (2603:1096:820::29) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|DS0PR11MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e11e347-6d57-4e8f-edde-08de5b463f72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eWpOMWJZcXVTUXRMSkZoMnZRMEhST1N1VWUzNEZHRXZEbm9tVmFJQ1hvakxV?=
 =?utf-8?B?cDgwelpNSDRnVzA1NWtNeXcrMlZXZHVkem9ST1BmZmlxWEVpelFCeFBudkx0?=
 =?utf-8?B?NEVCZDQvM3RIOGNUQjRpenNmb1lFOUx0V0ZZVTJpdCtWNnVENnFjdlU5SWFG?=
 =?utf-8?B?aFdzMTZKdDdka01IUm1nMFNwUHBOcDc4M3pGRk1NZERITmllUi8ySE0yQUxp?=
 =?utf-8?B?OVgyUkN1anRxeXZvSXdnWWw0UVcySzdjalBkbmNkUXFwY08yYXp3ekRDM1VM?=
 =?utf-8?B?a0U2NWttY1ZWNURvcTZEMXg5a05SZ0Qyd1RaTHA5aUQ2MEdxcm02WlppRklR?=
 =?utf-8?B?T2paTVVZazFTZlNPaWgySlA4a3h0WGFWZDRUajlMMmRrWi96Rnc3dFNTdDAx?=
 =?utf-8?B?K2VveWpKLzVXaU1Hc3hBeEZhS0xreG1kenpGWjdXVUVZRFp4U3o5M3d1RzRW?=
 =?utf-8?B?S2N5ZmJBMFJneWd0cmN4SHcrWnRHZ1E3TzUraWsyQ2JQd3lJdmF4L2FTejZR?=
 =?utf-8?B?dm1LQ1JHdXBGektOM2dpQWpKVTA0anNNaEpjWXNXR1U0REdVS3o3enVjcmtJ?=
 =?utf-8?B?Mi9ZNGJsamNTS0lPeGU1NWttZEE0cC9PVmNMTENMTDd6SzBzdFhaRjdGMUpr?=
 =?utf-8?B?Sy80V0t5bHJaWGl3Uk05aFRMZmU1dGQrbHZ6TS85YzRQb3NJd0FQMmxIZzJD?=
 =?utf-8?B?NDRZejhGUVhhMVlzQnZuNkpkeEc1elBVQmUvWGxwOWdWNnZvb2gyYlFlTWRv?=
 =?utf-8?B?WlpWNVZzWnR0U21JY3dPcE5zTkxNNVM2RUZkcTdqYXF4SU9tQm80QnJtbTMx?=
 =?utf-8?B?ZWdmV3Y1N2RiZGlLNXFqdzQrZXRXM3lnTEJBYjRKK2VZOHU2QmwwZTcyNk1X?=
 =?utf-8?B?REdtK291V3RCUEJwdDFVckw0YlVrbUoxRW5RMVJqOVNHRnBISDFVeE95YUFD?=
 =?utf-8?B?dU1DbHRXWUp3ZjZLbzBVZTIwUXRlZjI5ZENhOGI0dWMwTWYrcVVFbFpaZWFL?=
 =?utf-8?B?SFUxeWFDUENrTDFFM0h2N0hBM2cyR2NjZmtpM3grUmtBaVkyaTBvcVFNREdk?=
 =?utf-8?B?UUlEOFBZbk5zNFlUTDV0SWl5WHhCTlJ6SThnM3k4cXZYa3BJWmo4YnNBWGtE?=
 =?utf-8?B?V1ZkYmhxdGg2QnJSUGtsWlZnS3FkbWl2Q0I1VHVEQ2hSS3ArVE1Gdk5mV2p0?=
 =?utf-8?B?MVcyR01xcWhWdzhwdWV5U2pyNVpXMGJDdlNFYUYzMXQ1VFZRWG9DNVhEaHl3?=
 =?utf-8?B?L3ZSM2x1elRvRVc4SjNjN1ZLL1dsUnhUWkZvbytJVG5weTUrRkxaaWszMGFZ?=
 =?utf-8?B?dktmOXpYeURMWmhoeFIvM2FEUnQ4VlYycll6clpmOTV4aGM1MUJjbVlseThp?=
 =?utf-8?B?M1gvaTVpQXRxcFRzbHB1WnRvUnFYMFhGVEt5WG5iRExsUU12R2hIYlZacWFh?=
 =?utf-8?B?Zlh6ZTgwQi82Ky9PMmFrKythRENqTFEzZ2dTckxwZEQyN0tUci9sR3E0K0Va?=
 =?utf-8?B?OWpJVDNRYmMvU2hJdktYdGtyN0V4OTc5dGduUit1a1dwNkdEdlJyMVhBcllr?=
 =?utf-8?B?M0VMMk1pUWVXbXF2a2FWeFp1dGFFeGg4TXAzQVFDN0ppRGVtSmRZWE5jdWVR?=
 =?utf-8?B?YXl0YmRHME03T3hGU0VHajQ0cG9PQnZTdmpwS3A5UUltUXZiUXdMWHJjWFAr?=
 =?utf-8?B?S3BZSGU3cU5DNlhGVy9meE5KOXdTdEtVb2JJemJrWHJIZ0dkejVvbXp2VkRZ?=
 =?utf-8?B?cEM0cGFZNEdQbnE1aFZIQXFSNmJSVVhCZzJGcGcrbDlEb1pVUmZtL1BzOHM5?=
 =?utf-8?B?VmxmOC9PZmg1UjVRL1VSVHREeFRyYUVnZlkrb2V2NEtYZ0dIRzBCM2FXbjZ5?=
 =?utf-8?B?UE1XbUhCQ01wOE93MUE3ZFR5SE5yUFZNU2x5OVduRmNYZ1VGUDdvd3RjcUY0?=
 =?utf-8?B?bFRwMDVVck1vMVlWQm5ZcU1VSVM5M0thK2JoaElVQktFYjZITWt3VWRUbG5a?=
 =?utf-8?B?dHpzYmR0dnRuTjRvekhMY1BQQS9SQ1BFNFJtOS9pUlkwOTlWZ2FMTDFOSXZE?=
 =?utf-8?B?OXZnWXZlTzJlSTAzU0JqVWVqc0t3ajh0YS9sQlV6L1V0ME91TG8zditsSWZj?=
 =?utf-8?Q?hozs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGxCVXMzektWRFJPcytvV01sNmpDNnZGYWM4UWlucm5sWnNaOTRIMElCa3Jk?=
 =?utf-8?B?N2NHSWR3d2ZwQmk2Q29oWDFKQjBEczlWR0ZxSDNFMjR6bmtNZTZHUDFrQi9K?=
 =?utf-8?B?ejNldTM3ZnNpZjNzbXlzZngrUG1zaERRT2JKTkk2cXU4THZscExubTlQVGts?=
 =?utf-8?B?OTlFcjl0L09HbU81Qi9VNkxncmRXemxJQXc5NWZGRTc4Q0V1OXpXdjN2cDRz?=
 =?utf-8?B?LzdqYVRpVUx1TjF0Q280UlNWSy9ISTZjbUo5alFuLzlOVERxZmpsVCtJV1Vz?=
 =?utf-8?B?K044OUFPNU5HZHlIY2FEbHFtWkN3VjlxNkZsMlhmcnFLWnZnVllrTyt2azRR?=
 =?utf-8?B?WC9KMEhIakdUd2ZIMkFWSEZrZTJ2QS81SEhsMkh1WFRBb0ppUU9sM3cxQy9M?=
 =?utf-8?B?UW5HbVFSRDJmNFdRRG1MZ0NQK0J3SzE1eVhNZ1hucVJFUG5KdTU0dUNVT2Fx?=
 =?utf-8?B?RW9LUnF2dUpnaGN2Rjl6eTBTQTl3aDh5bHhmK0o0U3NvSWcwT2tPUmR4NkZD?=
 =?utf-8?B?a1BxSmtBYXhsMUR1MVJVNG9vMmxNQVZnV1lNaGpuYSt5ZkgwZWVkcVNxUStO?=
 =?utf-8?B?c1dmanM2TlgwNlpHU3I2VStpU2trTGxyVGdFV2hXVXg3NjY3VElNZUlzL3FR?=
 =?utf-8?B?YmFLZmF6djVSajZyZU1xdmtSdVJVUkVrU3laZUFQRE5xaXg1UWZPYURFVVNz?=
 =?utf-8?B?VFZKMDhmb0ZXazNPcHdvNHplbEw3TDZYOG9HS0RxY1FJdko2M0ZpY1RETStx?=
 =?utf-8?B?L3FkaUx3dzQ4YkNNT0YvMXdKOEVyY2k2ZUdSSnVzVlYwejVkRGxiNFRHN0t3?=
 =?utf-8?B?L2xDUjNBYVVLN3pTbW53VlVWNWQvdWtYU0I2NHA0MDZMWHlCOVZDNGNtWWxt?=
 =?utf-8?B?bFZ3eHlqdU9WdExXcHg4U3dmY2Vob1VERDltZ1NDNnVvMXBNUzhPZVlyR3NL?=
 =?utf-8?B?VXVNdnFQZTU5Y2haNWoyTnNDN2E1TzFvaXFaQytCaDd3TWc5NHN1Zk95TXhD?=
 =?utf-8?B?ellVck4xNkpUT1gyRXcxQXhiR1lRWFAyemJqbHRuTTFUcmlMdjBqaDRXVlBG?=
 =?utf-8?B?a0VnaTg1QXVNTzFQUzFlc2VTbk1BbW91RnlZbmViRnhGNGZOanZOcExxYjIy?=
 =?utf-8?B?Q3pKNjA0bHJJSWVsT2diKzBQa01wWDlvODFRMTdITEs1QXQ2dFRCa0s5Q3Bt?=
 =?utf-8?B?SktlTDF5TE1wUnpEdXhIbU1JdUllZklKdTVNSlcxRWM0Nk0xWVczWTlBT3l4?=
 =?utf-8?B?a3dSQkhNMnVyK2ZQbmcxZXJra29pOGgzM2hpM3piVDBQcFJjVW8xeEtFbWYx?=
 =?utf-8?B?N3lPQWpqZ3FiL1RYQkYzNFJEaEI0V2hxYTRmRm1wM2RZU0lPMGxTcUlaUW1Q?=
 =?utf-8?B?UXpFNnh0LzVmKzNETjhIYXpFNkd1dDQydmZRUStVZnR1SStBcDNSMDV0ZElD?=
 =?utf-8?B?ZytlZnJNQnN0bGVleDNzQ2toWXlnaGpqeWp4VEJnTURMUkRycGhmcHJabUht?=
 =?utf-8?B?VXdZN1R3dEVPS2pCVC91QTNxbGE3TkxoaVlxN0dYbk12ZDI5NVFtblorazFn?=
 =?utf-8?B?ZFRvcVJTVU8zTFVRZWpMSmlDM3owZmFDMGNkdHkwTU9HMnk1ajlZZzRBcEhq?=
 =?utf-8?B?eDhvRkIwRnNKcENqYlF1TkMxYTh5K2pFVFJZdVNXOUtEZi9Ncml2cU43dUF1?=
 =?utf-8?B?Z3EwSTVxQk0zUzZmU0xNQzE2N2I3Y0JwVUFQS1ZWWlByNldiWkNhR1paeEFK?=
 =?utf-8?B?NTZialdiT1FrTGw1NE81dnVjYWE0eU45T1B2R0J4clc5ZEJiYmhPSUNoOGVW?=
 =?utf-8?B?ZmNveDBzZWRrbDF2SkRUbndGQjRVMUFPa0NSbVA2dkRNZUxQYlY0WWRNUjRM?=
 =?utf-8?B?SzcvNjN1UFJMcnJHYnhBZUQwcHZsYno3S3ZyTmR0RE9DSFYyMWkyQnJRbTZk?=
 =?utf-8?B?STJKdmZ0R0tRblNIbmVzcXN0MllLOEFjRUJ6aUVaZmhFWVRRWmJDcENZd0Q5?=
 =?utf-8?B?aUxRTVpESlJGdjdHWW9qbTM3YTIrMEdXOUVQSW5uaUVMMlg5WTV4RDRuVk1U?=
 =?utf-8?B?SmtmcVFjK25rTXFPeURLN1RzMy93MjlmL2pJQVZVUVN3Y3NUQlM1WmlDdmdv?=
 =?utf-8?B?aW56OTQ1QTNoaFdxejBjWHpMZjdLUkN4VVVBbEtLUTE0aTVCazUxT3VraXZH?=
 =?utf-8?B?d2RVazltWkVVMUQreE9teE1VRm5adTh3bzJmcWNacjdIRFJ4eDhNZEtsNXhS?=
 =?utf-8?B?QVBtTTFXTlhwZ1FrcnNGRThjR0pETHRQTFhUV3VEdkNDUVhGeU5JNnF2T21z?=
 =?utf-8?B?U2JWajVDVmFIQ2xXZVkva0hTY3FaaDBUbG1ldDl6T1ZQRkkwM014QT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e11e347-6d57-4e8f-edde-08de5b463f72
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 12:44:00.6286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R0+QrJ8nTflqZlG3TlSazhQ6+gWCyfrrdJKuswPKwFrZEJmW7wTcZSqQbfFJN21n5xf1+AKDwqKiU+XdIrCLgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7829
X-OriginatorOrg: intel.com
X-Stat-Signature: jtp9bqg83an9f9yji8kaex7yczy7u1qp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6517240002
X-HE-Tag: 1769258648-60795
X-HE-Meta: U2FsdGVkX1/PnkD/5I78CLuJ+3Pi+2Xlcof9BQnGzJou40VH7WYOZKFzR6C0HvLSTJ/9EXEjMevEJt5mfkMGRSeS+8NXDTcoPSeID2/Rwb0jMORT3blkZLstcKHGOqYKQu7hcPGnnRWA/sL7Ig370IGCYdfrBLdVZ+OHe5WRoJPslUq7f1OMRJ5JwqpqZ0nuJSJWTgMlRO6aAzQTkUA9yrs+Id+7HJlwrmKzUCd+2pwWyt8eGNxsWJK64pnlk8U6J02MLd2vKNaiR2achZM/yYlIfGUoYquYY/BJnNXXT3Mf2rLzx3pvqT+8L6x3hrd6h2gPmEbxsg+womcsnjwoUUjIrP9P0Jzezgihh6bKy6UVpz8VXm6X2aD4fcRP9uziwklNS25MAlaY6gpYtrCJRxQ4QIg/oy6CVgjX9MrkP9QAQp9/TIsIU3OviUDg5o+pMZbItYfjFj0raBpxjNeUK0U8Ul+St4HiV3Tjli0qMgi7SnYRKi9UdCMrg7nsCGGyRkEW+3c2jTuQWIiHAHtxNqosuseQ9Xqatr1aTpxMeNYd4SWRS1uVC8zF7vvXlA/XLBsKQet08AgbkVaN/hkw0NFC/PBhWgUbcAuZ4adruogY+R0NlnuTxEi9QfxJw+1YwCgRKNYFQgrcLBr5kTEVr6srGkIcd9ssUKLTpU+EZC1j2X70vHDTglH2vxK368+uevGaGE0/ZNPqqww+I/5W40u5+ie0Extw83cPnFGN1/YVoXOeeb+R18KV6uq+b+1oA+wsazDneHmYWoS0fqrl2z3Jkj4Tbxid5/KHXCar13JjahdUqkb7Z0CU0yQyeclHeTJGyx6RV/V0DssOLHB3wDjx9h/cFuQIIYuMGscAcNdQ6QOi0CMCa1PLE5JCqWqNybS8o8kLatmEGLNzTmH1/c3CRZomzQ4SM90b7/F21p8sBvVnspOZRY2vRCvSgrLNW0fUq+lIsG/prXJ0JS2
 Z4t8yAaz
 YX9scZuIxxFIXLjJ3V5IOJlLQWmpHwCQAIqWfr6juDqDDIusBJ6q4WPT0GV6u+DU5o2kCaxom/4BLvpb3gmuDVyhpAjBQ/j34OXbTJVIOa2fB0vPS7hWKOTu9fqIznI7t2dwOqHaB5iE0CZOHPuQU57SgS4PUhPk9oEtH31iQFAj6Z6816FAWIhSFdBDoj2eqKN/fLHdzEnj27fTTtoiHrCpYs/S7oOVa9q7rIlQUtlhrQhSp5cLH4kYPdsEaQx10OAqJw4137nX8k38vKnLoVtYzwjB3b4Cc4I52CfTExkadpePhUziAeNy/+hwKaTR0iVSDi579XkyvEtYiQdJIj4zzr8Py4wMMRvUisA7zg6JgV+lB/y/08Vw5n7ZeGBJHaQnHG1S8iTJnSh1f1Fywd0grnyYzUI0Ht+KUvdfEde0WMVT43rjMOtJNHxOzOCFJpkKuKw+7cAwG4fvVvqki8l76G+pah9Zt/n4u0IBXFndPRjp7UdBO4QgtprOF7EMXccFmCFFvHeZH0WJdn8SjOHolUCmU5Oyjwdb/F0nof8c9YnaguZKNEFyDYy+UVLf6iYYaGFCE3fZfWdm0rOml27CxI9d7Rj3wOdsI5xDYoy4SE4uonEnPa7jFCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/22/2026 7:43 PM, Mike Rapoport wrote:
> Hi,
>
> On Tue, Jan 20, 2026 at 10:33:46PM +0800, Tianyou Li wrote:
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
>> ---
> ...
>
>> +int online_memory_block_pages(unsigned long start_pfn, unsigned long nr_pages,
>> +			unsigned long nr_vmemmap_pages, struct zone *zone,
>> +			struct memory_group *group)
>>   {
>> +	const bool contiguous = zone->contiguous;
>> +	enum zone_contig_state new_contiguous_state;
>>   	int ret;
>>   
>> +	/*
>> +	 * Calculate the new zone contig state before move_pfn_range_to_zone()
>> +	 * sets the zone temporarily to non-contiguous.
>> +	 */
>> +	new_contiguous_state = zone_contig_state_after_growing(zone, start_pfn,
>> +							       nr_pages);
>> +
>>   	if (nr_vmemmap_pages) {
>>   		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
>>   		if (ret)
>> -			return ret;
>> +			goto restore_zone_contig;
> But zone_contig_state_after_growing() does not change zone->contiguous. Why
> do we need to save and restore it?

Move_pfn_range_to_zone() will clear the zone contiguous state and it was 
invoked by online_pages(). If error occurs after 
move_pfn_range_to_zone() called like in online_pages(), I think we'd 
better to restore the original value if previous zone contiguous state 
is true.


>
>>   	}
>>   
>>   	ret = online_pages(start_pfn + nr_vmemmap_pages,
>> @@ -1271,7 +1320,7 @@ int online_memory_block_pages(unsigned long start_pfn,
>>   	if (ret) {
>>   		if (nr_vmemmap_pages)
>>   			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
>> -		return ret;
>> +		goto restore_zone_contig;
>>   	}
>>   
>>   	/*
>> @@ -1282,6 +1331,15 @@ int online_memory_block_pages(unsigned long start_pfn,
>>   		adjust_present_page_count(pfn_to_page(start_pfn), group,
>>   					  nr_vmemmap_pages);
>>   
>> +	/*
>> +	 * Now that the ranges are indicated as online, check whether the whole
>> +	 * zone is contiguous.
>> +	 */
>> +	set_zone_contiguous(zone, new_contiguous_state);
>> +	return 0;
>> +
>> +restore_zone_contig:
>> +	zone->contiguous = contiguous;
>>   	return ret;
>>   }

