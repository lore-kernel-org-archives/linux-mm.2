Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D68CED24D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FFF16B0062; Tue, 18 Nov 2025 04:28:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B03F6B009D; Tue, 18 Nov 2025 04:28:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A586B009E; Tue, 18 Nov 2025 04:28:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15A376B0062
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:28:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9936A8918F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:28:25 +0000 (UTC)
X-FDA: 84123202170.10.F3A5A4D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9C6FD1C0011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:28:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Xf6vJH0A;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf18.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763458102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6p+H5eT1yG8lqtZTAUgD2fXgmgLJRVjlHNCckq0qNkw=;
	b=FdjK046BNkRmbLQvEH/GsVwb3pOGbWQns95xYsDxpey0RdXQ3iPjWI8ZG9UWRMFUkDRJMz
	fzZSeG3FUsRj1QiS5wCMz2XkV92+8b+5dTvQeEpX4/fXmzuFyYLStT+EVm2qss/npdoam7
	mYChgLNLKgW5Btrm+LWFh1LyYPC8AFw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763458102; a=rsa-sha256;
	cv=fail;
	b=mSynUxevncErmllDquS/u5biNZcXrt7ahqoNRsPlecjca0Sn/gE5yPssnb+7YRZJkQNRSg
	V8d3pI22mPagQEcfgEmYbihtQ+W27C5MwfNpRPaJ+184qoFW1+ulcfa/Fi0lQUSgeYxcgG
	RbpYKjzBEQTG3gkMSgPtDtShmWJNnbc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Xf6vJH0A;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf18.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763458102; x=1794994102;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:mime-version;
  bh=lYpx4Z+tmY84uan+r6eb91/L7pQZNF16610/W+wkGSc=;
  b=Xf6vJH0ABI6S8iU6WWmoM9s/vK97BMrpZp0FiUqHQfefxkVDh8mPON0Y
   uQMZLstcSlx0WnZox76je+xNqIe/nmh8R7a4wCFPFhJAJz/636wht+fFC
   nFEspv6htC7Z+91+gqZTM81Vu8cmrqaECj/fW7TS+ObyyOrSQFZeOCqKR
   1//sIuJQRSy3Nb9vftI3HPniAXbmBlcNdLQbHCx6FZJWPLqskvXetNK0F
   nWFulGjqwcvC0kGE5BUyq9yOaw/Gl963Qrx/hfSXxatLsUtkaqiaAaW1S
   cgRbjit5qt2kaTEcERovjuojo5JbJ7HxnQt2IPwr7lCGmDSaQgvk3g6bJ
   Q==;
X-CSE-ConnectionGUID: 3dEmdATsSMOR+Ey9ERq6dw==
X-CSE-MsgGUID: br9QwjkEQC22RQkl28F3+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65412861"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208,217";a="65412861"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 01:28:21 -0800
X-CSE-ConnectionGUID: 1Nvn3PQqTLu1llUTmO12NQ==
X-CSE-MsgGUID: fNDB1bepSaa5VmGBo2FZ0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208,217";a="191478809"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 01:28:19 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 01:28:19 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 01:28:19 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.38) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 01:28:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QV2yZMa+fKgVGpXxgxZUKo6xTpAN1deBPP8/DwVH+fJVD37x8m8fxUx6Px2WDtOHJXKmO3poamWMCRi8EFMq8v7kKwPV+HKtltVnBAqfePIk2O8yAP4zKfZBGbG56GImbx4jcmSoBWq98Lr/hugdlua2TEdlzJ1g3tfReINVkOGvfajKo2SlAGYlAs7hWHnIPLnpM25ZNEcD8cKUip2Xj3gPkNBpo0XBxUBJ4uu9OYzRmnYLKZyB467un25Zj5+QyR3tcu92s8W1JG2ytM23V4pINt0DqKu/MV6meCZSn37Mwl/8WlUbCatz2zn4+eodDdc/eXIoBtHzqSfXRoPmqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFlmlrmhSMn6/mivozdIku746wNAA3bJ6mGSXvrz03U=;
 b=K03stwU/vBDcukomVhmPcGj+RdrSE5GlH6q2N+SbMKPWY8aVXuQUIv1xkxbKSUbTzvX9wzE4+EDqbnZ2I+mPDSzWws6HRHso4uaYLmwkGTnUGgA/I2b1L9JLjianS7uZTmyhNsA4cvLJe6O7IMG8tRBnWaVJ8W/aptRR+w2puUrbg+90rGpin0j0G84ffsJ4l6iXvewL+TjWxzXX3/+hvy9Zz6WhpYoEQ4rCOKT0Cc1wAll0yqKSRz0mqc7KpYD//dgDxzdPqmLPGvrZPaEFbz7qZo5wDHzSdaEJZJ2TZI/ggO3uw+Ic9izpWQV0VCNQfqj7HU2JfClCgs67TT0SnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by IA0PR11MB7863.namprd11.prod.outlook.com (2603:10b6:208:40c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Tue, 18 Nov
 2025 09:28:17 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9320.019; Tue, 18 Nov 2025
 09:28:17 +0000
Content-Type: multipart/alternative;
	boundary="------------B930fNdiUyTspraKwVGqayhr"
Message-ID: <faed85f7-c17a-478f-948c-e4c0a016de85@intel.com>
Date: Tue, 18 Nov 2025 17:28:10 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
	<linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251117033052.371890-1-tianyou.li@intel.com>
 <aRwAjSQBby614Itx@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aRwAjSQBby614Itx@kernel.org>
X-ClientProxiedBy: TPYP295CA0020.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::10) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|IA0PR11MB7863:EE_
X-MS-Office365-Filtering-Correlation-Id: 33f387d7-df06-4693-3507-08de2684ce35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|8096899003;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YnY2TFF6ZlV3TEFWdVNOWjJSbmZXZlFabUxnZ1A0amNDSzJsZTlOSWcxSEJh?=
 =?utf-8?B?K0x2bFRjSFd2Y2ZmMW1Ld1d4aHhGYmdSd2dwRm92NURQczdsSTVMOEJCTW1G?=
 =?utf-8?B?aW1xNzlWdmZkcGp3bHc2dnhBSkw1U05qQzR2dEk5bkhWT3FNSGNHVWl1VThR?=
 =?utf-8?B?cFRBR0pYbXpvR08vaDdYbUFxOEJ0SjBXSzArYTRDY05LVEY4OVV0L2Y4Mits?=
 =?utf-8?B?UUh1OCtrQW5hdlB4OVNIdVZiek0zUTJSb1h1SUFZKzRxbjhYY01yMkRkYkg5?=
 =?utf-8?B?Mjg2dkZXcnpBeE9CODZMY1c4TkRpUUxHZ1Y0Wm1SSlNva0Q5bmZmV3Arc2FU?=
 =?utf-8?B?ajJyOWNzMkxaM01CTTFoT0daM29YblZ5OVVraXF3ekthanI2SU5heWtTMVBa?=
 =?utf-8?B?VVdBT09XRXRDdkR4N0hsTXNJR2NvdHJmOXV2aGNpZEE0S3R5WFZ4QVdXaEN1?=
 =?utf-8?B?Q3duT1R5WVNtV2w1M0RXRnI1WXFJd2Z0eVovOGROUEkwRG5PdFB6MlVyUXRY?=
 =?utf-8?B?RUVXK2ZzZHdORUFLUDY1Yi8xbTZhbzJRRU1uSWpWcjJFRjdvM2tVTlJkOS9G?=
 =?utf-8?B?ZVFtdjBnU1BZbGNvczIxUVpWS296UldJczVLRG9tMnZsdmJzWW5ySXJIZ3lq?=
 =?utf-8?B?VE5yOVBTNGd3N3ZQYlBGRWlWdWFTUnNDM1NxOGJ5NHJCSExoaG9wdHhyeVdQ?=
 =?utf-8?B?bXM3aVNjY0JxRCtpY3ZBNE55NkdGVjNTUENDMFJvQXFCNU5GYmtrT2dJbWtD?=
 =?utf-8?B?bldzeWxHSFdtd09lbC9ScTAvNG1kNE50TGhtOTQvcGxaT0tOVHY0Ym1ha1Ny?=
 =?utf-8?B?emlpREtlOGZsZWZML2RPS05GbFUvK3RyWWYrdWI2Y0F0TlhZVzdJc0FQckpW?=
 =?utf-8?B?RG5kMWhQdGptZVp2L3k0ZTJPS3dGRHRzUHpEKzE1d2haU2RHTE9HY0dhVzFY?=
 =?utf-8?B?TUtpc2k2eVVkTGRBV09Gc1RUQnJJQ1N1R0FORS9tL1dScGV2ck1aTmtGVlFV?=
 =?utf-8?B?WFM1TEZPT0lEaUljQW4vU2VIaVdwWm9Od0plU2ZTVnhvWnRjQVZHK1hUM0tF?=
 =?utf-8?B?SzVXaUhzTFh1MXBzalF1a1FjUklTejJGYjdBV25vL25mTVRzQ3RqUnBNMm1s?=
 =?utf-8?B?VlZwZXF6WlJ1UlR5WHFmMTh3UkhvMEZhZE9RaUVhdnF1bmx3akNHaUQ3Q25K?=
 =?utf-8?B?SWY4RHQ0TEtaejN5d2xBeTJtL3N1WVVuSUlFUllvMjVsYnMwMXhxRStFTU93?=
 =?utf-8?B?VHBQVndlOEx3ZVV0T09wdFJqTDlIT0sxV05yVmh0QUZBNnhqdVBLL0NqRTd2?=
 =?utf-8?B?dHI2YzFoVjdZNGpWSFp2TFpGZDV3djEydEdNZ0loVTlIZExEeDRGalRNUDhT?=
 =?utf-8?B?QVRvMENNSk9NdmdZSEowZy8wZTBFVjZ4ZkJLYUxmNkxITWVQWk00eXhIbURB?=
 =?utf-8?B?MWErOWRBNmFkK3RhY0NiMi9hQUdtZThyZDNSRU42TjNnc3E0dGVzSzJKd2lv?=
 =?utf-8?B?OThxdHEwZFZPRUwxckJTdlZ3OFRFQjFnM1QrSVBlWkRyZlNlQnZ4cE9SeHA1?=
 =?utf-8?B?bEEyNWZUOGo3VXZ4M1g4ZHBYQUw4NjdWNEt0VDhiek5HUGxmb3FsS01ZVnBW?=
 =?utf-8?B?WUhvRWZwV1lPeEVGbmFWSDhpSG1CWFIrTStiSGQrRTB5WVhlMWJZRmN4ZVRD?=
 =?utf-8?B?MkxndmdDWlRsZGpqaWhoNXd6R3o4MmszK2RBelVTa3RVZGpYU0FOUStiNXhw?=
 =?utf-8?B?bXJlNUd2aHFSU1VobzExT2s3akVsVUFhTnZ5SDcvMWg5QkpZVXAza3d4VWR2?=
 =?utf-8?B?U0psdURSL2hmT09jMUFOZ0UvYXFPTnRXV2VGbytPNmlhVWtqTWZDeEdMbzNV?=
 =?utf-8?B?emNLTUxSU1N6RkI0UWQrZGJGUUxQT2YzSDd4c3BmRjBPSFZ5M3hLSS9TWEVL?=
 =?utf-8?Q?mo0/2Ad7/1KGPXNPk7froDPbkroTeljT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(8096899003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3hYT0FyL0JGNEh4NWEvVUF1VUdWOGJJVkFSSEJLOFQrOEFXbTFuaXJJQm9T?=
 =?utf-8?B?K2tHMFRid0VUOGEwL3RWc3FpNDFxUHBSdTUrK01nUXBla0lmU2tWNlRKUnNC?=
 =?utf-8?B?NTVTc21MWHhzT1Y5Q1hFUWZzN1V5QXVteTBBemtDZWVlUE1GamkvQ1lQaCtN?=
 =?utf-8?B?dFVUa0NGNlozczVkaVRPOTFKZG9vUkI5b2JML25kK2d2R3pZRElGanpiazZY?=
 =?utf-8?B?TXUydXdzaDVkWWRJNWNSSE9qcTE1b2szSldoU0lPWU1QejZ1OFRlT2QycEpi?=
 =?utf-8?B?UGNWRmRrTS9vMG9KbXg5TGIzOHRtMTBrWXYwYTgzcDNkSk80c0EwSXpQYXZU?=
 =?utf-8?B?OE1lNmZDVUM1dkwwVG9pVFU0SDlqRzRiZ0tMWkI5akZQM3ZEdG9FbW85eUVh?=
 =?utf-8?B?NlR6YXJuZWF3MGNrR3Z6RjBQNWt6ZUd2azFrdEpQZi9laFBVa043RXNqbFcr?=
 =?utf-8?B?RFR0eHFoZ2dJTjhiRGZ5M3VLVHI5TEdWZzYxMDQraVZFMDZhWng4NFBNdkEx?=
 =?utf-8?B?R1BFZUVDaXAwNFFjaFRqYlVVMlZ5eFRtaktSamx2OVhHWWVDRnVaNzdQQmg0?=
 =?utf-8?B?aUdmeXc5S3NFMmI2YjZLL0ovc0R4cENzN2E4WU9raEIzd3BvRElPOGxhc2RW?=
 =?utf-8?B?OHdQU3FaUFE3ZU1PUVBqa2xxMzdwME00SEFXMEx1RVZFNnlOOWM5d0RFaXdN?=
 =?utf-8?B?VG1kV0VtbFloT3Jsc1JrbVdOVUQxRFd0cnFnUTM4WTg3TFJQOG4zQnNDNEZZ?=
 =?utf-8?B?aVdYOVNTSFRsL3hNTUxEeGp5bUlsdnpNbjdxY25LaVNMcFNsUDVsZFgxWkQw?=
 =?utf-8?B?UkpDVytKUFdkdUdQVnlUM0pnekRCanlZSGUwVlJSRzVNS2VBMld6M0toRlhu?=
 =?utf-8?B?eitUL0RUazlaMzYxaGFkWCtWTU5meWhrWFNhQS9FVkFOYWhUV0lWbHp3V3dt?=
 =?utf-8?B?ci9KbXZNbzJoOTJjR09hZVpBQUY0dXExWEVtV1ZtclNBMmFHTXNYaVQwcW85?=
 =?utf-8?B?S0w2OEFVcy8yMUZ6amF0S1VlOWxzaDFQS1dwZi8vWmh2Y2dZaGcwY1FsSlBU?=
 =?utf-8?B?b3JYWllLS3FOYlJubElvN0c5eEZaQ1ZqY2NodEF0ekRoLzBKNWZ6bGUvK2R1?=
 =?utf-8?B?bDMrWDhLQTg4czUxRGJOcGtONWJ3VlVCM0d3bjI1a0VmbG9zS0tYUGVlNUE3?=
 =?utf-8?B?RkFLaXZtZGZNRGNqQmM3bnRHM0FCdjV1NGR4TTRvUU8rWFhyUHhDVUtFYmV0?=
 =?utf-8?B?U21ScEFVUkh6N0xwbFROSUpLUWpRY2ZWME9aemlRd2ZvZW13M0xzNkpudjB4?=
 =?utf-8?B?Ky9RTk9IQjJoVDloc25ud2J0R2wzQ0o1M2tNditzOFZEcFpGM3JFbUg3ZEVi?=
 =?utf-8?B?YTlVNDlZWnFYcWJJZ2ZOK3BoczAzNEdQemdWMk9KeTUzeGV6clBLTTJlYlM4?=
 =?utf-8?B?eHpGZ3UyQXp6MXpoOGpkMHF1Rk9pN0FLbGdRSm1udmVxUHNrYkhXakRyVmFw?=
 =?utf-8?B?MWM3bjd2ZXVoN2lFZHlRK2NoaWtTcDFPZ2pNUUJzR3BzUFpGZVJJZTVJMmJm?=
 =?utf-8?B?ajcvN3pDMUUzdUx6dEhPUkY0UmxHSkh3WmsreWpOb3F3WVVhS01ybTFTMHE5?=
 =?utf-8?B?MjFvUHlZVGtkdEdIbzE2N1FURmJ5Z3RhVU5keEJmczFIY2p5dkRZZHZZY3pL?=
 =?utf-8?B?RlNkamJNTDh5NjNhVjVvZkxjS25uTzhSay81QWZONjBqaFlKbjhxNThaMWR4?=
 =?utf-8?B?QTY4aWZBWUo0bVd3SExRTE1SMFZmYzRQS09jSG54WTZ1WXVxejAwYXkweE0z?=
 =?utf-8?B?OWJWMTloSWNGSEtrN1dQNGtxRFpZMWZBeXN4Ynh4dk50QnRBYmRHZ1d5VzhN?=
 =?utf-8?B?enE5NmhBNjh1Qm81S0phYmFrek0veG5tZFpwcjNHeHlkaitsZDVLNUFyVDZB?=
 =?utf-8?B?VkFoZUtpMytIVEQyYWhJOXByOUg3aisxRUN4bVk2cnFnYmMvaStlU1dGTlMy?=
 =?utf-8?B?REp1NnhuK0JycWkzK3NyUENyK1NtUExjcG5xM01RYUREYm8zSXRscC9naWZl?=
 =?utf-8?B?WXlMRU1tcUNRYWRqbVM3WjR5bTNiRWFodTl4RUJKK0JYMjhLRng3S29SVjVL?=
 =?utf-8?Q?vDyk2OmbiljHyApGngX+8yi8W?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f387d7-df06-4693-3507-08de2684ce35
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 09:28:17.3305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6W/sWpAtXCyrPXVbTPnzM7D8kru6spKuXKK9KMkRB9D0sm75kSLnzsc7b2spOxiqyneGpGa83ucu3+JXGUPOqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7863
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9C6FD1C0011
X-Stat-Signature: 34yf85jdcczx1oojyeu9oejqzqed61es
X-Rspam-User: 
X-HE-Tag: 1763458101-795256
X-HE-Meta: U2FsdGVkX19GrE5rdXS64E5/mib/FVuNw9cxP2ZjslHQTQF0NEsR31SlBY4hqFo26Y1tQ5YXOWORCcVgf/PFiP41Y9FDl4h5aznXzxEzGig1hs4nmqYwgkfEQ9EZygNY8QqsjHH5DaqjgDSHuZzPhxwBdL5aaSjaEq+GuW6G5xVq0Ihu8Uk9JtJvjQR7VXwVFCHgfJxTvZP2QlOQRHICF5Qn51J6UCzrlGGUuTiPwkF18ylNy67848ibeLWxg67pByY3wr0/en2A9ncUxGhKNXDfsRJ8urzc9xGH2kzX4A0UMxjYohewoPb5SuFtZphdAikB0YbAzZYA/lkAf66EQ+cxKVh0gXTVCuMbGuU/SnzJlW9aFg/t+h7yNnowbk/gk8O0Hgb5PtBhKahd1LhAviTc/RJBIn8xl6ybcEMTb5oyUqu5YR8KwUIil0MW/aw8lQXvrq694ybYpoTCDcIk4jJxfAdtOQlMsAMy6u17y+YuEEm8l5lhZJtAvXTJHPFGm1eJJyuI08uU4bn7ImAiq7v+Pr5ZpQKVr8/F2jOv+mOH6vqf3ZGOoR9l3Xf1lyoU4EDrp4CSwzK8Ssw1FQLwmpqNOlXEXZN0hL/JjE9gnNZhtLNe5r+uhxB+HJkZNANw5v8Nu/cJkSbEMQITeQiCtFzy7ItyH95DrMn/sWZ2n+jIzskw5td1F4HdnjMWNV+naECppH10BCgKNMWQrhceQ5d6/7jjmz+Enev+VGXtgaMSJjn6Um17slg9ioVbs2GERfkjtg6wFkdk1zyR4krEfeCrw3fse6jGTrXmGf4oqXzKuO9bq36DA/Ox+zFeoDliBgWPSDHrAtT0mLP5eHBXAkoqtHnIwlOtQY5yUaJ8n65GJafZE6ZWescQI6g0zvLoAcqKPG7eIiQ1uiVZn0zFDxr4s3ihzENfyjGLcb54vxWJBboK8UyEqvpV94zlQ6pSYssTT9q2tOXni5ZGYK6
 pPHo719m
 0TPZsTBy/qWdMnobD6A0uzI7CClQCMxyVMw4ivlAAgVgwlBg/ag8C+101ck0nS9W8kJWJbvF29pGL1nnBDOXwyYUPwoI4xz6NvFAbSadvxDYacQ/vtqvKsO+i6bprwM4a+9sfgzdvCnzHd6dpj3yD9noHw7jeChTl6bRilGi7/Dx/obSQfyAjGwmO0Nz9JA6pN4hOzTrt7+YUy1x30FBJlLsT/EUBB8kqoMltzERf7+VPjWyvr3bYDoOrnu/K+Ds/jZ/PioQEn6GtQtP3INZ5tfNLAvFm/mkip9Syc7wpHDK+LxKv3BJyBbxtf657qPNnpdY5sJVuCOEm+DIaDnAoey7ftgIxd5hezGWF+TQvaOmMKlEZEIbG9m14flCte7JqFu82tu0dSQOTjTvvTpIliCJ/Im2zGUz2sRrHig0CavbTsUB3ihT+yXdqjSYviYnWl9L9j5p/UgALJNBAJe4bcK6nemnaVvndN2t7G16blwdY4hHG4YtZTKyEbue4aT/gFJdR7aLnzNK5Mv96wH7rZ3R0sTPXwLYGIzQemby+MlvKjc/UA/xq/AB8GBsrZNGOQf2+JpHhLwk6LxlJ4Zrs4ybqLP8a7+1/lW908nFLcZbaBoeHH2PpQkydRKk67JAQYB4hrOEZjqYasi7DA9NkyG/czBcnFuLKlpxm1gM38b1EbOU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------B930fNdiUyTspraKwVGqayhr
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for your comments Mike. Appreciated.

On 11/18/2025 1:13 PM, Mike Rapoport wrote:
> On Mon, Nov 17, 2025 at 11:30:52AM +0800, Tianyou Li wrote:
>> When invoke move_pfn_range_to_zone, it will update the zone->contiguous by
>> checking the new zone's pfn range from the beginning to the end, regardless
>> the previous state of the old zone. When the zone's pfn range is large, the
>> cost of traversing the pfn range to update the zone->contiguous could be
>> significant.
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
>> | Memory Hotplug | 256G |      10s      |      3s      |       70%      |
>> |                +------+---------------+--------------+----------------+
>> |                | 512G |      33s      |      8s      |       76%      |
>> +----------------+------+---------------+--------------+----------------+
>>
>> [1] Qemu commands to hotplug 512G memory for a VM:
>>      object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>      qom-set vmem1 requested-size 512G
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
>> Reported-by: Nanhai Zou<nanhai.zou@intel.com>
>> Reported-by: Chen Zhang<zhangchen.kidd@jd.com>
>> Tested-by: Yuan Liu<yuan1.liu@intel.com>
>> Reviewed-by: Tim Chen<tim.c.chen@linux.intel.com>
>> Reviewed-by: Qiuxu Zhuo<qiuxu.zhuo@intel.com>
>> Reviewed-by: Yu C Chen<yu.c.chen@intel.com>
>> Reviewed-by: Pan Deng<pan.deng@intel.com>
>> Reviewed-by: Nanhai Zou<nanhai.zou@intel.com>
>> Signed-off-by: Tianyou Li<tianyou.li@intel.com>
>> ---
>>   mm/internal.h       |  3 +++
>>   mm/memory_hotplug.c | 48 ++++++++++++++++++++++++++++++++++++++++++++-
>>   mm/mm_init.c        | 31 ++++++++++++++++++++++-------
>>   3 files changed, 74 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 1561fc2ff5b8..734caae6873c 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -734,6 +734,9 @@ void set_zone_contiguous(struct zone *zone);
>>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>   			   unsigned long nr_pages);
>>   
>> +bool check_zone_contiguous(struct zone *zone, unsigned long start_pfn,
>> +			   unsigned long nr_pages);
>> +
>>   static inline void clear_zone_contiguous(struct zone *zone)
>>   {
>>   	zone->contiguous = false;
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 0be83039c3b5..96c003271b8e 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -723,6 +723,47 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
>>   
>>   }
>>   
>> +static void __meminit update_zone_contiguous(struct zone *zone,
>> +			bool old_contiguous, unsigned long old_start_pfn,
>> +			unsigned long old_nr_pages, unsigned long old_absent_pages,
>> +			unsigned long new_start_pfn, unsigned long new_nr_pages)
>> +{
>> +	unsigned long old_end_pfn = old_start_pfn + old_nr_pages;
>> +	unsigned long new_end_pfn = new_start_pfn + new_nr_pages;
>> +	unsigned long new_filled_pages = 0;
>> +
>> +	/*
>> +	 * If the moved pfn range does not intersect with the old zone span,
>> +	 * the contiguous property is surely false.
>> +	 */
>> +	if (new_end_pfn < old_start_pfn || new_start_pfn > old_end_pfn)
>> +		return;
>> +
>> +	/*
>> +	 * If the moved pfn range is adjacent to the old zone span,
>> +	 * check the range to the left or to the right
>> +	 */
>> +	if (new_end_pfn == old_start_pfn || new_start_pfn == old_end_pfn) {
>> +		zone->contiguous = old_contiguous &&
>> +			check_zone_contiguous(zone, new_start_pfn, new_nr_pages);
>> +		return;
> The check for adjacency of the new range to the zone can be moved to the
> beginning of move_pfn_range_to_zone() and it will already optimize the
> common case when we hotplug memory to a contiguous zone.


Do you mean we can separate the update_zone_contiguous logic into two 
parts, one for fast path at the beginning of the move_pfn_range_to_zone, 
and the other for slow path after the memmep_init_range?


>> +	}
>> +
>> +	/*
>> +	 * If old zone's hole larger than the new filled pages, the contiguous
>> +	 * property is surely false.
>> +	 */
>> +	new_filled_pages = new_end_pfn - old_start_pfn;
>> +	if (new_start_pfn > old_start_pfn)
>> +		new_filled_pages -= new_start_pfn - old_start_pfn;
>> +	if (new_end_pfn > old_end_pfn)
>> +		new_filled_pages -= new_end_pfn - old_end_pfn;
>> +	if (new_filled_pages < old_absent_pages)
>> +		return;
> Let's just check that we don't add enough pages to cover the hole
>
> 	if (nr_new_pages < old_absent_pages)
> 		return;
>
> and if we do go to the slow path and walk the pageblocks.


I'd like to avoid of the slow path as much as possible. The check 'if 
(nr_new_pages < old_absent_pages)' is more strict if overlap happens. I 
am OK to simplify it if there is no overlap cases or to reduce the 
maintaining efforts.


Thanks & Regards,

Tianyou


>> +
>> +	set_zone_contiguous(zone);
>> +}
>> +
--------------B930fNdiUyTspraKwVGqayhr
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html><html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body>
    <p>Thanks for your comments Mike. Appreciated.</p>
    <div class="moz-cite-prefix">On 11/18/2025 1:13 PM, Mike Rapoport
      wrote:<br>
    </div>
    <blockquote type="cite" cite="mid:aRwAjSQBby614Itx@kernel.org">
      <pre wrap="" class="moz-quote-pre">On Mon, Nov 17, 2025 at 11:30:52AM +0800, Tianyou Li wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">When invoke move_pfn_range_to_zone, it will update the zone-&gt;contiguous by
checking the new zone's pfn range from the beginning to the end, regardless
the previous state of the old zone. When the zone's pfn range is large, the
cost of traversing the pfn range to update the zone-&gt;contiguous could be
significant.

Add fast paths to quickly detect cases where zone is definitely not
contiguous without scanning the new zone. The cases are: when the new range
did not overlap with previous range, the contiguous should be false; if the
new range adjacent with the previous range, just need to check the new
range; if the new added pages could not fill the hole of previous zone, the
contiguous should be false.

The following test cases of memory hotplug for a VM [1], tested in the
environment [2], show that this optimization can significantly reduce the
memory hotplug time [3].

+----------------+------+---------------+--------------+----------------+
|                | Size | Time (before) | Time (after) | Time Reduction |
|                +------+---------------+--------------+----------------+
| Memory Hotplug | 256G |      10s      |      3s      |       70%      |
|                +------+---------------+--------------+----------------+
|                | 512G |      33s      |      8s      |       76%      |
+----------------+------+---------------+--------------+----------------+

[1] Qemu commands to hotplug 512G memory for a VM:
    object_add memory-backend-ram,id=hotmem0,size=512G,share=on
    device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
    qom-set vmem1 requested-size 512G

[2] Hardware     : Intel Icelake server
    Guest Kernel : v6.18-rc2
    Qemu         : v9.0.0

    Launch VM    :
    qemu-system-x86_64 -accel kvm -cpu host \
    -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
    -drive file=./seed.img,format=raw,if=virtio \
    -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
    -m 2G,slots=10,maxmem=2052472M \
    -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
    -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
    -nographic -machine q35 \
    -nic user,hostfwd=tcp::3000-:22

    Guest kernel auto-onlines newly added memory blocks:
    echo online &gt; /sys/devices/system/memory/auto_online_blocks

[3] The time from typing the QEMU commands in [1] to when the output of
    'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
    memory is recognized.

Reported-by: Nanhai Zou <a class="moz-txt-link-rfc2396E" href="mailto:nanhai.zou@intel.com">&lt;nanhai.zou@intel.com&gt;</a>
Reported-by: Chen Zhang <a class="moz-txt-link-rfc2396E" href="mailto:zhangchen.kidd@jd.com">&lt;zhangchen.kidd@jd.com&gt;</a>
Tested-by: Yuan Liu <a class="moz-txt-link-rfc2396E" href="mailto:yuan1.liu@intel.com">&lt;yuan1.liu@intel.com&gt;</a>
Reviewed-by: Tim Chen <a class="moz-txt-link-rfc2396E" href="mailto:tim.c.chen@linux.intel.com">&lt;tim.c.chen@linux.intel.com&gt;</a>
Reviewed-by: Qiuxu Zhuo <a class="moz-txt-link-rfc2396E" href="mailto:qiuxu.zhuo@intel.com">&lt;qiuxu.zhuo@intel.com&gt;</a>
Reviewed-by: Yu C Chen <a class="moz-txt-link-rfc2396E" href="mailto:yu.c.chen@intel.com">&lt;yu.c.chen@intel.com&gt;</a>
Reviewed-by: Pan Deng <a class="moz-txt-link-rfc2396E" href="mailto:pan.deng@intel.com">&lt;pan.deng@intel.com&gt;</a>
Reviewed-by: Nanhai Zou <a class="moz-txt-link-rfc2396E" href="mailto:nanhai.zou@intel.com">&lt;nanhai.zou@intel.com&gt;</a>
Signed-off-by: Tianyou Li <a class="moz-txt-link-rfc2396E" href="mailto:tianyou.li@intel.com">&lt;tianyou.li@intel.com&gt;</a>
---
 mm/internal.h       |  3 +++
 mm/memory_hotplug.c | 48 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/mm_init.c        | 31 ++++++++++++++++++++++-------
 3 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..734caae6873c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -734,6 +734,9 @@ void set_zone_contiguous(struct zone *zone);
 bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
 			   unsigned long nr_pages);
 
+bool check_zone_contiguous(struct zone *zone, unsigned long start_pfn,
+			   unsigned long nr_pages);
+
 static inline void clear_zone_contiguous(struct zone *zone)
 {
 	zone-&gt;contiguous = false;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0be83039c3b5..96c003271b8e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -723,6 +723,47 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
 
 }
 
+static void __meminit update_zone_contiguous(struct zone *zone,
+			bool old_contiguous, unsigned long old_start_pfn,
+			unsigned long old_nr_pages, unsigned long old_absent_pages,
+			unsigned long new_start_pfn, unsigned long new_nr_pages)
+{
+	unsigned long old_end_pfn = old_start_pfn + old_nr_pages;
+	unsigned long new_end_pfn = new_start_pfn + new_nr_pages;
+	unsigned long new_filled_pages = 0;
+
+	/*
+	 * If the moved pfn range does not intersect with the old zone span,
+	 * the contiguous property is surely false.
+	 */
+	if (new_end_pfn &lt; old_start_pfn || new_start_pfn &gt; old_end_pfn)
+		return;
+
+	/*
+	 * If the moved pfn range is adjacent to the old zone span,
+	 * check the range to the left or to the right
+	 */
+	if (new_end_pfn == old_start_pfn || new_start_pfn == old_end_pfn) {
+		zone-&gt;contiguous = old_contiguous &amp;&amp;
+			check_zone_contiguous(zone, new_start_pfn, new_nr_pages);
+		return;
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
The check for adjacency of the new range to the zone can be moved to the
beginning of move_pfn_range_to_zone() and it will already optimize the
common case when we hotplug memory to a contiguous zone.
</pre>
    </blockquote>
    <p><br>
    </p>
    <p>Do you mean we can separate the update_zone_contiguous logic into
      two parts, one for fast path at the beginning of the
      move_pfn_range_to_zone, and the other for slow path after the
      memmep_init_range?&nbsp;</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:aRwAjSQBby614Itx@kernel.org">
      <pre wrap="" class="moz-quote-pre">
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">+	}
+
+	/*
+	 * If old zone's hole larger than the new filled pages, the contiguous
+	 * property is surely false.
+	 */
+	new_filled_pages = new_end_pfn - old_start_pfn;
+	if (new_start_pfn &gt; old_start_pfn)
+		new_filled_pages -= new_start_pfn - old_start_pfn;
+	if (new_end_pfn &gt; old_end_pfn)
+		new_filled_pages -= new_end_pfn - old_end_pfn;
+	if (new_filled_pages &lt; old_absent_pages)
+		return;
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Let's just check that we don't add enough pages to cover the hole

	if (nr_new_pages &lt; old_absent_pages)
		return;

and if we do go to the slow path and walk the pageblocks.
</pre>
    </blockquote>
    <p><br>
    </p>
    <p>I'd like to avoid of the slow path as much as possible. The check
      '<span style="white-space: pre-wrap">if (nr_new_pages &lt; old_absent_pages)</span>'
      is more strict if overlap happens. I am OK to simplify it if there
      is no overlap cases or to reduce the maintaining efforts.</p>
    <p><br>
    </p>
    <p>Thanks &amp; Regards,</p>
    <p>Tianyou</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:aRwAjSQBby614Itx@kernel.org">
      <pre wrap="" class="moz-quote-pre">
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">+
+	set_zone_contiguous(zone);
+}
+</pre>
      </blockquote>
    </blockquote>
    <blockquote type="cite" cite="mid:aRwAjSQBby614Itx@kernel.org">
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------B930fNdiUyTspraKwVGqayhr--

