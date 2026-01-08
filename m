Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A1C4CF6C15
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 08:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326F46B0092; Thu,  8 Jan 2026 03:13:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE2D6B0093; Thu,  8 Jan 2026 03:13:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188C66B0095; Thu,  8 Jan 2026 03:13:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F24E16B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:13:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A7C613A258
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:13:35 +0000 (UTC)
X-FDA: 84308082390.19.0AF6208
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf01.hostedemail.com (Postfix) with ESMTP id 50EAF40002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:13:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y6qQY+By;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf01.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767860012; a=rsa-sha256;
	cv=fail;
	b=6cOuWDYQH8Mk+fzRanFUXR4Ffyg6CNLV+AG++p3W1eyTbdvk5r1eBR7Y+SrYfwAvvcFbIE
	a9jFyQHFZEBk3aLEAIAjfcwy024rnxuL3xYzlPwQsAYYeJHQ4ih/j/f8KrjkCoTp5xN1PQ
	p2wJ8+k+zXd9JJkQ98CA0wU30wKW1xA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y6qQY+By;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf01.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767860012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0n/lKqSBFMGsoBrKf1hjNy+pJDERq76t41TIUFj4SXY=;
	b=5kCy+yg8cud5wM6Oo7uts/RR6FH47qmdyhrh6xvPAoVzKnzEKdBhNOUMlxQf54AFIw3SFs
	ZvmcoFBZvmAHOhH/4sVLxfSD+Y7ZAuj/Ph6cQ8kbWRM9sfgSRywkuFt8UVbL+7IqPIL+dA
	gXYFTnabONLVN3yeJ2Z+gNX1eMF/AVU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767860011; x=1799396011;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:mime-version;
  bh=vPoUEJb9XYWy8gYkCoXSGpvtPWwVjH930ZfN7jNWl2c=;
  b=Y6qQY+ByI9OaLuKFFp7XXRnkzlpEqebeAwSjQr+7M/BY485Bfw9AMxEi
   wZkYoZTA4pmv2meIgHveLl8JToU/mfEoy6Uw/Nfelq9d76HKhRra8DraV
   yqjk9/jnr24HIkt7sGBZBlhKkMRb//iD/2RUF8uioUk1guqvhlH3b5cG4
   0h6f1CXdCJFwstk+Y1If19ySJr5AisLueFB0vudzQTqNwrizvYvSgx4lH
   grmeNuilCvcjgPgDlxz2qRkAZ0T6TjE6kTdoFIz147XWt09KMd3w2d4tI
   wCkMjtTrKbXRIpyIOonh2ZF3+GcNMRcFBHDRyN7felaHACaUJDTEWNHl8
   A==;
X-CSE-ConnectionGUID: JABDbX4xS4i+RvHCG0wo7Q==
X-CSE-MsgGUID: EfzeieqmRkCi645M2etDdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="72869720"
X-IronPort-AV: E=Sophos;i="6.21,210,1763452800"; 
   d="scan'208,217";a="72869720"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 00:13:29 -0800
X-CSE-ConnectionGUID: 6OOVJo7GTJSoUIZB6h4djA==
X-CSE-MsgGUID: XjBXFsu8QbqKQWJ99Hxdiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,210,1763452800"; 
   d="scan'208,217";a="233842383"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 00:13:29 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 00:13:28 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 00:13:28 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.59) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 00:13:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LygWMIEXcLe+ruwlou7upQMnbQSIDRZklBXBxTU1zc0DnvLZzTdp8cq5EqT/OxkHVvIbQkGdpwxYU9dTrolkUrZ/nWCNmQ89AVEwYhSGG0dHuchGxyNh2D3MlGj7Xz2w8bR7+H+kyLnv9TjZtx0H3FV+8KcPFAzm8ebMghPyL05a2CJo0g75TM+K3qOUJ24eEDHas+B+yxZvMNYqRtn4FkRFR1BWzoAM7nNxkVQ1OFhngvqUvYWl5/T4KbqzkFiuYwIrvUD+PIPwmuuHBbM6EPUzAH0ZZTLSX47otMud3N4spAldx6NHWSgSgGfwf/JFCp5kE5bviExBm6gfBXNzPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rNAqDXTtLNDYTmDQzpw2h1BfRRTxkUMY2Kt+xWpr00Q=;
 b=DGE/JC1qcBw4sjNkKdlg8P2fFTyVafT9hWl7JJ/YHYfxojx7kVSgzM1jDddeYBZxfEi+VDOgdHOZMRc1Q2vU9ihb0OgycOZ1DY3Ul6GRUVn5uPP0C1wdcf2tQnP9BQ3bMWbZ1Va1DzGu8XZjC4jzUBPQjj+DcH3q0VtfjwWgQmrKOs6F4SpdRPFPOgmt84Idf2AZhTXwwljSTjEMQynnnJKs4JU8t+ZuCxNJrM4BW1A1Oy2WDj9zCbu2eAQaT77m6oQJLSFOhd1OosRezd6tXwvJR0LbqgZwC/3JoiJCiJLcpF5cZCiu93YFhK+wICVqYGrFtvUK95ruJF+iCqfGxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by LV8PR11MB8722.namprd11.prod.outlook.com (2603:10b6:408:207::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 8 Jan
 2026 08:13:26 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 08:13:26 +0000
Content-Type: multipart/alternative;
	boundary="------------E9AhRLhvif39JLwM2S2lwelj"
Message-ID: <31abe489-a7e5-443c-affc-72e8454872d7@intel.com>
Date: Thu, 8 Jan 2026 16:13:17 +0800
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
X-ClientProxiedBy: KL1PR01CA0085.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::25) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|LV8PR11MB8722:EE_
X-MS-Office365-Filtering-Correlation-Id: 17db20ec-8770-4ee1-5f1a-08de4e8dcc47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|8096899003;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YUo3cEJYYkY0MStrL21GQ2orbXBPSmZiVytpV29JN2U1UnFBSTZtY1V4NW5B?=
 =?utf-8?B?SXdTa3VYcjZIQjJMWTBDb05SQkh0VFE0UnFmWFhFK242dXlBeE1tL0VoSUtV?=
 =?utf-8?B?bUQ2Tk9FT3IzeDMrUjZlM1VtZkpES3MrN0pPKzUrNW40VlV3bm02UEF5RW5p?=
 =?utf-8?B?SVdyWS9DZGJvMEs1QkNZRkE0UWo2NHMrd0xQbnBqOHVMQzBaR2pYMDEzTVNH?=
 =?utf-8?B?eEtCUFFMc0pjVGtIeEdZM3V4TXcvU1hXUk4rRXZzTkhoM2JYcWloc0ptRyt4?=
 =?utf-8?B?RkpkbFJZYmxiNExBNGllU1RCVE9YUy9tRXBjSDc2Tk44NzhsUWxlZXRKQUR5?=
 =?utf-8?B?SXY0NW1NRHdjNm03NCtQZFpoVEFQbUtpWjlhZ1AvK2p6WEgwRDJpb0FTRncx?=
 =?utf-8?B?LzY1RkJYRUR4MnJBOXQ1VGRDQmZYZGhhTjZlVUtzaUhjNnVqY3hPUjZTSWNZ?=
 =?utf-8?B?QXdnMmV3SFpBQ1Q5NWRuSGtQYmtJRDQyZGRWT0VOWTcxUmczL01nekJ4bnY1?=
 =?utf-8?B?a0Y3ZWpwYVRyMlRzSWp4czlvUWhFR1BrNnQ2OS9mdFROak5oRlVHQWw1NXUw?=
 =?utf-8?B?cHZSOFlJSkJBYWRXUE9KeTlFNDFzMUduaFZ1aFFYZ2dON3RSTTJyTnBVMzY3?=
 =?utf-8?B?OG5RTEUyY0FGRTFFUkNNL0ZIOHk4cjIzZUxDdm16ZVRFWXJvdklYd3czS3lZ?=
 =?utf-8?B?R3lzTnRSamRHTkt3amk1dkNMdEgwSHNVM1orUTRwa1NVdDBkanlVTjV5OEpH?=
 =?utf-8?B?WkF4UTJnQVFxL0hjYkFaZDlrSiszOU5ZOFJ3QXVWRlo5dnVPeUpYSHM4S3ov?=
 =?utf-8?B?LzM5NDBHcE9mSHMyVm95bHdvQnpRS0IydDdZTjFiNkxabHU3Q0ovWHBVb1Nx?=
 =?utf-8?B?Ui9LMk51emFEOWFLSlRLSDcvVHhzOUZsaTNaQmFVR1lWem9NSDZ2SFdkQXdr?=
 =?utf-8?B?cUUyQ24xNURvcE91M2tPdDFoTzdDL25aaGFzcHZPRVJML05DcFRremprbWJK?=
 =?utf-8?B?R01OeHVxaUljS2cxYUFUL3NrZGs2alBtNlkzVEE1ek9vZVo2VElseFdsdk5K?=
 =?utf-8?B?ZnorVXBtWTVFaFBlaGhVa28rUFgzczVnQkQ3RmRNOEtmem9TZVNpTHI1RVpG?=
 =?utf-8?B?U2ZRK04rZFdiTFdUamVMbVlQalBDdG1hOGJvSm9IcHRkK3hZRE40TlRBYkVK?=
 =?utf-8?B?WFltZkwvemhhTFV3b2s0SkwxRnBQbVpodnB4UTdhSjhQbnRHc255aCthL0E0?=
 =?utf-8?B?T2Y1K1UzOTYza1NBU0xITFNTWUpMZnZHZFF4TEUxR1NrZ3FoVzVmcEJQNXhp?=
 =?utf-8?B?TDFSUkF2dm8rVEJGNmlZR01QVlFtUmNpc2Qra1Z6Si9JTjl6SlhNMFRmd2xK?=
 =?utf-8?B?aHVrN0k2VTYzeE5VMk54cUR4Skx2RWJOZlpHRkpCY1Q1c3VWVnVxQ1JyRVNa?=
 =?utf-8?B?NjM0alM4QndMbkNvaElEWG04bXk4WjUrcUlPQUcyazFHblRFOCtUUkJDcGtX?=
 =?utf-8?B?ak1KMitDTzJ3eG5MQ0NQQ2NCRlhZcjkyS1N4aE5JZ2dQOFYzWi9qdm9adTli?=
 =?utf-8?B?UitjT0N0c3cvQkIyUmcweFRwdTVlWHhDZ2NzWmo1ZjFGanRqTEpDVGZZTG92?=
 =?utf-8?B?OVpVZWJRaGovc1NocEZKbTRjazJCKzhTQkFSYk5xaXlKbUNsamEzendkR1Qr?=
 =?utf-8?B?QUxNN0hCVURnZW1YV2RjWGgwQmxwUkYweDEyejdWRGNzMFBHbXhOWklVSWYw?=
 =?utf-8?B?UWFrRFdzSVhiK3B1QVJGMUVzemJLb0xyZlRYOFcwRUZqdE44a0RrL2phbVUv?=
 =?utf-8?B?MkdrbnkyTUcyRmRoV3ZxVWxuMlpPeCtPVFU2YTVjaUhBbDVwM0VCYzh1OCt3?=
 =?utf-8?B?ekdlY2Rycis4Ynd6T1d4ZkdURWhMckpPWmhOeHUxVW5ZSVBjZVNIQjJ2TklX?=
 =?utf-8?Q?crzRFac46KZhOMzdiHPHaVggWefCmZAR?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(8096899003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVZUeFFnaGN4Q0RCcWh6dENxdkVPQm91aFQ5TzZ3Ky9DZlJxdGRSdGRjTHla?=
 =?utf-8?B?YmliOUlCUlRicXA4dkxZeEF3aWhBdjVxenV4elBCV3Q0VUpGK1llanJTTXJ2?=
 =?utf-8?B?R1ZaL3g4TGNvd1dDbVV2Nnl5SENvS1lERk8wVU4xMzNwUElLcDkxZDcxV3V0?=
 =?utf-8?B?YU5iOWYvQlFvTzc1U1NHRWFsMVN6RE5CZTMxSmgwcHVSMkhISk9MSDEzc09t?=
 =?utf-8?B?aWphQjczcDZCMG8yRnBTMWZoTi8wMDEyTWN5SGxxNGVBMGM5RU4weElROFBm?=
 =?utf-8?B?blpRMVk2VmFUTm1YRGFERjBabXRETEZNcHB4RWdPNWgzTHhzRFI4UW9FUFJB?=
 =?utf-8?B?bHJwVzdFcXg1Nms2c0Y4YUdvOHVaVjZoR21EVDFFTC9sZlZpdkNqSDl5YmU2?=
 =?utf-8?B?Z0MxWEQyT1Y3Um5FSUs4Vm83amdvZTlXNHFIOHpPTUF0am9acXd2MDZhdFdj?=
 =?utf-8?B?WStjc1VUSmFJclpTcXhTU2xrTU93eE9Hc0VFN3BDVXRTSkx5TDF2Q3prU3Ex?=
 =?utf-8?B?RCtJODE4bGZ1eC8vTXcySHcyVGdoTUIreDdoMmJiZGpqeThGNFQwS21ubzBy?=
 =?utf-8?B?WjhubldMVVpjeWpBeUZJSUNJNFpzT3JQUUw5YktCOTZuRHRpWUYzeVAwaU1i?=
 =?utf-8?B?akM4R1I3UGtqaDQxK1lpNzM2TlJZODF2YjNlNmFETkU5U2dHbHN4Z3h5NWdv?=
 =?utf-8?B?U1E1WThYMDZYV3Ftcm9zYitUbXJ3RlJoajNEbkVJY3Q4Yjk2S3FmVGJyeXVC?=
 =?utf-8?B?SGwwUTIrcVJ6TzIySkM2SHBEai9KMk1uYkJ5R3loOUFJT2dzbE9yS21OWTFa?=
 =?utf-8?B?a3BjVlI2TVVRcXZBRDdlS25TU1cvNFZiY1VMSmJjaGtNVXcrMFJNRkIwMXhK?=
 =?utf-8?B?Um1DQmFpOTNVNTdheC9WaTMxeGVUNVg0YXJDSm1jRFZVT2pQMFJpWTJtM3Q5?=
 =?utf-8?B?N05kejF5bGt4V2pFSEovaDZlbU9saUdGR3lKYmhTZTRqU2s0SmMxNWpqeUR5?=
 =?utf-8?B?TVdNdkNOMDFvZmdScTU4TmJHUTlGaytld3c3dDE3WGduNVhzWFc5Y0ozN0Vx?=
 =?utf-8?B?MEtmb2p0VjV6ZkdzT1RXMDNFaXRIcC9pdm1mY25HMjlzTUxWVVQ5L3IxeU1D?=
 =?utf-8?B?ZzMxSHFvdHc3SlVJM1VhRkxXSzRDbWJUTHNZTDVaeS9yRTEzVW1vcUFZT1Ro?=
 =?utf-8?B?MytHUldKbmpFeGJrdG9lejFTVENMMnd2TU04WkdxbVdNRjN5aHJwL0FNL0Nz?=
 =?utf-8?B?c1NkMWlUbzF3NXAvQnJFTmxLSVpuM050Wjh1dW84a1BrRE0zL1cxNDU0a1Vk?=
 =?utf-8?B?dVMxdkU3MUx3YWN1aFRLMzFNZjdZcWwyMFBzSkNYeG5rMk5NOHpqbE9mMkV1?=
 =?utf-8?B?bmFjWExtOEY0Q3FjYUMzUUVoWHEyYlVwc3RzVS9CODNTV0dtNjNYS0hoTGE2?=
 =?utf-8?B?YWNIc25PT3BHLy8xUDBVUXJ2eFNaY09KKzNoUmJlS0Nqcktzd1IzSHVTN2xz?=
 =?utf-8?B?M0psR0Eyb2RzUUhHbWN5Ky9VZjRkMk1oWmpwK2JmL3lBSDJNR1hRQlpmU05H?=
 =?utf-8?B?K0t0RTFHL2c3OHlObGI1cHpQLy83NWNYd05nVnp6dFA2RFNMUVZDU3JNcG9l?=
 =?utf-8?B?UGFKdy90YVF2QXcwTUI3dWVPMTduUmxXMWIwSXRCWWNFMUpPNGZwZEFxQitD?=
 =?utf-8?B?U3FDM3NQNk8zaWVQbksrbFpuQTVIbUtyOS9SVlN1ZFZoc3VhckkwZ0hzdTM0?=
 =?utf-8?B?Y2dhREgrRktSSG9PUVdlUllzd2tIcDNFSWFrTmVWZDEzSjdZMHMwcjI4N2Np?=
 =?utf-8?B?UzlVcVVzSWM5djFVbkMya2dpR0k4OWtsTEtpNzY3SW5QVk5iK3V4Vk4yMDBH?=
 =?utf-8?B?azVRWDc1d3UyNGdCTTk4NXhDZHpCOHkzdTRpcWtCL25QS2Y4NnNCcCtZMjdI?=
 =?utf-8?B?UGVydjhna3BjcEhZRmFoWEczZnVEZUZqOU90NXhzaENQMVVtbFFuYSsxcGZC?=
 =?utf-8?B?TmUzRUFodkxYQ2lMVE1xN3hWa0REM3RDNFAzWklTWStxU2wvVSsvZWxqRUxF?=
 =?utf-8?B?K3dHUGVaZW83aUtveWVCMU13Qy9oWXJ4N1RnMk5SSkdGNE1DSi96ZllZMEE2?=
 =?utf-8?B?UzBicHFUVzZUeEtTbHUxUVF1UThiOGwvc2hsenZKRDNCWWJZWFFFOHp6MHlU?=
 =?utf-8?B?akV1WExUTEZXSjVEQUFmY3F2VzlRdVBmMi9ZUVFUaXF5dm1nS3ZySkRHOXNT?=
 =?utf-8?B?ZFlPWDFsWGd5ZHhBS3pKYmJqUWNaNW9INVRCL1lhS0ltUEdJcnhqZHZLQVdU?=
 =?utf-8?B?aWRWR01idWl2cDJGcTh3aHpSODNVYUV4QWlzQ1BrSUdtM2x2MlZYQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17db20ec-8770-4ee1-5f1a-08de4e8dcc47
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 08:13:26.0800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9T+bO9to/NaCaDrjvX3f6hvNRxcqqEDgA4N2APPeCGloAKzlnCtt8q/t0zuslHFhw9Z7PRLqcxpotqM7rNDtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8722
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 50EAF40002
X-Rspamd-Server: rspam03
X-Stat-Signature: 5hsy9u63uexjojowq9gzin9h1j9j154p
X-Rspam-User: 
X-HE-Tag: 1767860011-486846
X-HE-Meta: U2FsdGVkX1/pZu1HHArZzIkfn8toOE8UJT5ib5fWhhMWPSWikVS+HwQC1CPRiII11VvhWoahGcttxA224zeDZG0bYEloKaCKs4t23pyiIu0bGODqHUHhDg7x6alcrZg84Fx7D4pMZXlFrGL0bryf1erbAeKb8Q74PY/Qs6sgOuIZUzNwamNCW+2VjI0xZSqZZrPE5tkcBj7Tjsy0/OzaOpLN8XMQARTTYT0FovXqvygsBVvYQZOLm/uqGQUvZ0GHjXTfRenB9NyUFaI9g1usg5hOPM/GdKzQQF3mqTw0X7S6UEWfxvvIoYPTNyfx1aQJUgS16hUwyM8k8DNrMuI5c/gMyFPwIE2a2gfSnH5FhvQihXchM/c/P/ZHrHtRpLWLxQFQLion6JO3mg2y/Tm7qa5gB1JpYe1ZURQLeG9c9qX5qgP37j7ljGHvwTMvbshXH9YC8M03M2cBs5g9DhkexmdP9Zt5B1SGWGzJBPLkc8YNW4lyZow7vhZCwOjExqlYBfWr4XqT5R6KOC2egxQtU8Utp57dC3EQsPq8+VxL3e/IPoO6WwSabzIxCHHn4hRMDBKCIkFwV0v7MTBIrx0AGQDignJbxs6Zr2Ajbc+5Xy5mtgSXFYGAlfcxalT9vBwsb/eDyGbE1kqKut5SlNmrfDayuuShnqxTOLV4yLfAjW33BhadL9JQaFeyn3Wd97kIrxSEyUgDUwL2xweCO9kO8IBDCL3OZU0nQGlfQdaUVLUyePw9dYDfOBOcLG8bBBW7MKwU4Ai4ERZDJlbJlEBScEAIzj5063LkmVmBytboJUCr7flAdq+5G+bLxmvlt9yDvKlGiiZnAvdiHGA4ASb5VdzCsk1eg/Mibns/9sHjkq0yb8l0SvYAzVkrHOza8b0Cz1XDmSrCE7WAycnVR53G3B3GXtqy7mvr/hI0nPldA+h5HFNmgmfh1HQzi4Og6NXDBsFpDzQaoHTGUe331Qy
 iFDk618F
 aekHi8jpueecSxkyolUowmpbK963N6tyyeXD16oOA3gmw5jHfFW23nOQkke503okPmc+ILbmYFLuiFJVA0u02dtlbp0oIpkLb8z7epJ+nSrZ6FADPA3TXaiNYioY5nP26e9GN7bJcGGDwBEFhEahLebzaeTH1UbJaTnlS4kHEKmF8K9MJlUVHscdidLE4ooMLBN1eCHTZQOB/PhLAORkBdk6faXX4+QH/uwPOw8u/PXh0IJUgy162jcf5W2/M6fPL9XVhloIIwjS+4/L2Rqvw7395UTN1Z5zreRKUVbv65JCVj+h9yoAe4RnJBnBVxpcftvSeIxJHyi9aq6gOqHWwY89QhmlX5u3CpgoQrn6SSiXITleCBcm4qXezdJQnCjb3nt9to5jBsmrcppj036kTObEBgDsySdpSnW0tX0fhjXWUMyDj3l+pwcUykwYbkazzIBCf5Ct7SqFes09Ldbog3Av5iCMRcXX4Yte1uN5rBMl8da4YVnsG9SxazRn/p/5pWn1qBhlPAPmZ7dP7eXuKIdu7WA9oZm+uW/Rj0tNsg7BxV3Knk62RSoGCr2+1/5UFmknayoFybXsOPpQsu4G3Om5RW6OhjqUR54VVwCItS+OVDUUwHDxMKwPinEpzH0jva7l5Vihqd4m0ixQSRY6SfXXouG6fP0+YkAXBrXyVGte37zoZfIMIXDv9SasgG8lGdQmmBlWXPQlxkwg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------E9AhRLhvif39JLwM2S2lwelj
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


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

           * It's a corner case where all the memory section will be 
online,

           * thus the zone contiguous state needs to be populated.

           */

         if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
                 set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);
}

Solution2.1:
online_pages(…, nr_vmemmap_pages)

{

         ...
         If (nr_vmemmap_pages > 0)
                 set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);
         …
}

Solution2.2

oneline_pages(...)

{

         ...

         struct memory_block *mem = pfn_to_memory_block(start_pfn);

         if (mem->altmap && mem->altmap->free)

                 set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);

}


Looking forward to hearing your advice. Thanks.


>>       move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, 
>> MIGRATE_UNMOVABLE,
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
--------------E9AhRLhvif39JLwM2S2lwelj
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html><html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 1/7/2026 4:18 AM, David Hildenbrand
      (Red Hat) wrote:<br>
    </div>
    <blockquote type="cite" cite="mid:2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org">On
      12/22/25 15:58, Tianyou Li wrote:
      <br>
      <blockquote type="cite">When invoke move_pfn_range_to_zone or
        remove_pfn_range_from_zone, it will
        <br>
        update the zone-&gt;contiguous by checking the new zone's pfn
        range from the
        <br>
        beginning to the end, regardless the previous state of the old
        zone. When
        <br>
        the zone's pfn range is large, the cost of traversing the pfn
        range to
        <br>
        update the zone-&gt;contiguous could be significant.
        <br>
        <br>
        Add fast paths to quickly detect cases where zone is definitely
        not
        <br>
        contiguous without scanning the new zone. The cases are: when
        the new range
        <br>
        did not overlap with previous range, the contiguous should be
        false; if the
        <br>
        new range adjacent with the previous range, just need to check
        the new
        <br>
        range; if the new added pages could not fill the hole of
        previous zone, the
        <br>
        contiguous should be false.
        <br>
        <br>
        The following test cases of memory hotplug for a VM [1], tested
        in the
        <br>
        environment [2], show that this optimization can significantly
        reduce the
        <br>
        memory hotplug time [3].
        <br>
        <br>
+----------------+------+---------------+--------------+----------------+
        <br>
        |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Size | Time (before) | Time (after) | Time
        Reduction |
        <br>
        |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        +------+---------------+--------------+----------------+
        <br>
        | Plug Memory&nbsp;&nbsp;&nbsp; | 256G |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        80%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
        <br>
        |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        +------+---------------+--------------+----------------+
        <br>
        |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 512G |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 33s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        81%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
        <br>
+----------------+------+---------------+--------------+----------------+
        <br>
        <br>
+----------------+------+---------------+--------------+----------------+
        <br>
        |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Size | Time (before) | Time (after) | Time
        Reduction |
        <br>
        |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        +------+---------------+--------------+----------------+
        <br>
        | Unplug Memory&nbsp; | 256G |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        80%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
        <br>
        |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        +------+---------------+--------------+----------------+
        <br>
        |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 512G |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 34s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        82%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
        <br>
+----------------+------+---------------+--------------+----------------+
        <br>
        <br>
      </blockquote>
      <br>
      Again, very nice results.
      <br>
      <br>
      [...]&nbsp;<br>
      <br>
    </blockquote>
    <p><br>
    </p>
    <p>Thanks David.</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org">
      <blockquote type="cite">&nbsp; +static enum zone_contig_state
        zone_contig_state_after_shrinking(struct zone *zone,
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long start_pfn, unsigned long
        nr_pages)
        <br>
        +{
        <br>
        +&nbsp;&nbsp;&nbsp; const unsigned long end_pfn = start_pfn + nr_pages;
        <br>
        +
        <br>
        +&nbsp;&nbsp;&nbsp; /*
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; * If the removed pfn range inside the original zone span,
        the contiguous
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; * property is surely false.
        <br>
      </blockquote>
      <br>
      /*
      <br>
      &nbsp;* If we cut a hole into the zone span, then the zone is
      <br>
      &nbsp;* certainly not contiguous.
      <br>
      &nbsp;*/&nbsp;<br>
    </blockquote>
    <p><br>
    </p>
    <p>Will change accordingly.&nbsp; Thanks.</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org"><br>
      <blockquote type="cite">+&nbsp;&nbsp;&nbsp;&nbsp; */
        <br>
        +&nbsp;&nbsp;&nbsp; if (start_pfn &gt; zone-&gt;zone_start_pfn &amp;&amp;
        end_pfn &lt; zone_end_pfn(zone))
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return ZONE_CONTIG_NO;
        <br>
        +
        <br>
        +&nbsp;&nbsp;&nbsp; /* If the removed pfn range is at the beginning or end of
        the
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; * original zone span, the contiguous property is preserved
        when
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; * the original zone is contiguous.
        <br>
      </blockquote>
      <br>
      /* Removing from the start/end of the zone will not change
      anything. */&nbsp;<br>
      <br>
    </blockquote>
    <p><br>
    </p>
    <p>Will change accordingly.&nbsp; Thanks.</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org">
      <blockquote type="cite">+&nbsp;&nbsp;&nbsp;&nbsp; */
        <br>
        +&nbsp;&nbsp;&nbsp; if (start_pfn == zone-&gt;zone_start_pfn || end_pfn ==
        zone_end_pfn(zone))
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return zone-&gt;contiguous ? ZONE_CONTIG_YES :
        ZONE_CONTIG_MAYBE;
        <br>
        +
        <br>
        +&nbsp;&nbsp;&nbsp; return ZONE_CONTIG_MAYBE;
        <br>
        +}
        <br>
        +
        <br>
        &nbsp; void remove_pfn_range_from_zone(struct zone *zone,
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long start_pfn,
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long nr_pages)
        <br>
        @@ -551,6 +573,7 @@ void remove_pfn_range_from_zone(struct zone
        *zone,
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; const unsigned long end_pfn = start_pfn + nr_pages;
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pglist_data *pgdat = zone-&gt;zone_pgdat;
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long pfn, cur_nr_pages;
        <br>
        +&nbsp;&nbsp;&nbsp; enum zone_contig_state new_contiguous_state =
        ZONE_CONTIG_MAYBE;
        <br>
      </blockquote>
      <br>
      No need to initialize, given that you overwrite the value below.&nbsp;<br>
      <br>
    </blockquote>
    <p><br>
    </p>
    <p>Will change accordingly.&nbsp; Thanks.</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org">
      <blockquote type="cite">&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Poison struct pages because
        they are now uninitialized again. */
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (pfn = start_pfn; pfn &lt; end_pfn; pfn +=
        cur_nr_pages) {
        <br>
        @@ -571,12 +594,14 @@ void remove_pfn_range_from_zone(struct
        zone *zone,
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (zone_is_zone_device(zone))
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;
        <br>
        &nbsp; +&nbsp;&nbsp;&nbsp; new_contiguous_state =
        zone_contig_state_after_shrinking(zone, start_pfn,
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; nr_pages);
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; clear_zone_contiguous(zone);
        <br>
        &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; update_pgdat_span(pgdat);
        <br>
        &nbsp; -&nbsp;&nbsp;&nbsp; set_zone_contiguous(zone);
        <br>
        +&nbsp;&nbsp;&nbsp; set_zone_contiguous(zone, new_contiguous_state);
        <br>
        &nbsp; }
        <br>
        &nbsp; &nbsp; /**
        <br>
        @@ -736,6 +761,39 @@ static inline void
        section_taint_zone_device(unsigned long pfn)
        <br>
        &nbsp; }
        <br>
        &nbsp; #endif
        <br>
        &nbsp; +static enum zone_contig_state
        zone_contig_state_after_growing(struct zone *zone,
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long start_pfn, unsigned long
        nr_pages)
        <br>
        +{
        <br>
        +&nbsp;&nbsp;&nbsp; const unsigned long end_pfn = start_pfn + nr_pages;
        <br>
        +
        <br>
        +&nbsp;&nbsp;&nbsp; if (zone_is_empty(zone))
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return ZONE_CONTIG_YES;
        <br>
        +
        <br>
        +&nbsp;&nbsp;&nbsp; /*
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; * If the moved pfn range does not intersect with the
        original zone spa
        <br>
      </blockquote>
      <br>
      s/spa/span/&nbsp;<br>
      <br>
    </blockquote>
    <p><br>
    </p>
    <p>My mistake:(&nbsp;</p>
    <p>Will change accordingly.&nbsp; Thanks.</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org">
      <blockquote type="cite">+&nbsp;&nbsp;&nbsp;&nbsp; * the contiguous property is surely
        false.
        <br>
      </blockquote>
      <br>
      &quot;the zone is surely not contiguous.&quot;&nbsp;<br>
      <br>
    </blockquote>
    <p><br>
    </p>
    <p>Will change accordingly.&nbsp; Thanks.</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org">
      <blockquote type="cite">+&nbsp;&nbsp;&nbsp;&nbsp; */
        <br>
        +&nbsp;&nbsp;&nbsp; if (end_pfn &lt; zone-&gt;zone_start_pfn || start_pfn &gt;
        zone_end_pfn(zone))
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return ZONE_CONTIG_NO;
        <br>
        +
        <br>
        +&nbsp;&nbsp;&nbsp; /*
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; * If the moved pfn range is adjacent to the original zone
        span, given
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; * the moved pfn range's contiguous property is always
        true, the zone's
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; * contiguous property inherited from the original value.
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; */
        <br>
      </blockquote>
      <br>
      /* Adding to the start/end of the zone will not change anything.
      */&nbsp;<br>
      <br>
    </blockquote>
    <p><br>
    </p>
    <p>Will change accordingly.&nbsp; Thanks.</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org">
      <blockquote type="cite">+&nbsp;&nbsp;&nbsp; if (end_pfn ==
        zone-&gt;zone_start_pfn || start_pfn == zone_end_pfn(zone))
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return zone-&gt;contiguous ? ZONE_CONTIG_YES :
        ZONE_CONTIG_NO;
        <br>
        +
        <br>
        +&nbsp;&nbsp;&nbsp; /*
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; * If the original zone's hole larger than the moved pages
        in the range
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; * the contiguous property is surely false.
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; */
        <br>
      </blockquote>
      <br>
      /* If we cannot fill the hole, the zone stays not contiguous. */&nbsp;<br>
      <br>
    </blockquote>
    <p><br>
    </p>
    <p>Will change accordingly.&nbsp; Thanks.</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org">
      <blockquote type="cite">+&nbsp;&nbsp;&nbsp; if (nr_pages &lt;
        (zone-&gt;spanned_pages - zone-&gt;present_pages))
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return ZONE_CONTIG_NO;
        <br>
        +
        <br>
        +&nbsp;&nbsp;&nbsp; return ZONE_CONTIG_MAYBE;
        <br>
        +}
        <br>
        +
        <br>
        &nbsp; /*
        <br>
        &nbsp;&nbsp; * Associate the pfn range with the given zone, initializing
        the memmaps
        <br>
        &nbsp;&nbsp; * and resizing the pgdat/zone data to span the added pages.
        After this
        <br>
        @@ -1090,11 +1148,20 @@ int mhp_init_memmap_on_memory(unsigned
        long pfn, unsigned long nr_pages,
        <br>
        &nbsp; {
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long end_pfn = pfn + nr_pages;
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int ret, i;
        <br>
        +&nbsp;&nbsp;&nbsp; enum zone_contig_state new_contiguous_state =
        ZONE_CONTIG_NO;
        <br>
        &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)),
        PFN_PHYS(nr_pages));
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (ret)
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return ret;
        <br>
        &nbsp; +&nbsp;&nbsp;&nbsp; /*
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; * If the allocated memmap pages are not in a full section,
        keep the
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; * contiguous state as ZONE_CONTIG_NO.
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp; */
        <br>
        +&nbsp;&nbsp;&nbsp; if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; new_contiguous_state =
        zone_contig_state_after_growing(zone,
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pfn, nr_pages);
        <br>
        +
        <br>
      </blockquote>
      <br>
      This is nasty. I would wish we could just leave that code path
      alone.
      <br>
      <br>
      In particular: I am 99% sure that we never ever run into this case
      in practice.
      <br>
      <br>
      E.g., on x86, we can have up to 2 GiB memory blocks. But the
      memmap of that is 64/4096*2GiB == 32 MB ... and a memory section
      is 128 MiB.
      <br>
      <br>
      <br>
      As commented on patch #1, we should drop the set_zone_contiguous()
      in this function either way and let online_pages() deal with it.
      <br>
      <br>
      We just have to make sure that we don't create some
      inconsistencies by doing that.
      <br>
      <br>
      Can you double-check?&nbsp;<br>
      <br>
    </blockquote>
    <p><br>
    </p>
    <p><span data-teams="true">
        <p><span style="font-size: inherit;">Agreed, it is very corner
            case that only when the end_pfn aligned with the
            PAGES_PER_SECTION, all the memory sections will be onlined,
            then the pfn_to_online_page will get non-NULL value thus the
            zone contiguous has the chance to be true, otherwise the
            zone contiguous will always be false. In practice it will
            rarely get touched.</span></p>
        <p><span style="font-size: inherit;">While this optimization
            relies on the previous contiguous state of the zone, in the
            corner case the zone contiguous could be true, but without
            set_zone_contiguous(), the zone's contiguous will remain as
            false, then the fast path in the online_pages() could be
            incorrect.</span>&nbsp;</p>
        <p><span style="font-size: inherit;">I agree in patch #1 we can
            remove the set_zone_contiguous because at that time the
            online_pages did not depend on the previous contiguous
            state. Now, after this optimization, this part of code seems
            necessary to be kept here.&nbsp;</span></p>
        <p><span style="font-size: inherit;">One solution is to simplify
            it by change the code to set_zone_contiguous(zone,
            ZONE_CONTIG_MAYBE) once IS_ALIGNED(end_pfn,
            PAGES_PER_SECTION), but this part of code is still in the
            mhp_init_memmap_on_memory(); If we want online_pages() to
            deal with this corner case, then we might need to either
            pass the information to&nbsp;online_pages() through additional
            parameter, or we need to have some code in the
            online_pages() to get memory block information from pfn then
            check the altmap, which seems not a good approach for the
            common code path to deal with a very corner case in every
            call of online_pages().</span></p>
      </span><br>
    </p>
    <p>Solution1:<br>
      mhp_init_memmap_on_memory(...)&nbsp;</p>
    <p>{&nbsp;<br>
      &nbsp; &nbsp; &nbsp; &nbsp; …</p>
    <p>&nbsp; &nbsp; &nbsp; &nbsp; /*&nbsp;</p>
    <p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; * It's a corner case where all the memory section will
      be online,&nbsp;</p>
    <p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; * thus the zone contiguous state needs to be populated.</p>
    <p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; */</p>
    <p>&nbsp; &nbsp; &nbsp; &nbsp; if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))<br>
      &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);<br>
      }<br>
      &nbsp;<br>
      Solution2.1:<br>
      online_pages(…, nr_vmemmap_pages)&nbsp;</p>
    <p>{</p>
    <p>&nbsp; &nbsp; &nbsp; &nbsp; ...<br>
      &nbsp; &nbsp; &nbsp; &nbsp; If (nr_vmemmap_pages &gt; 0)<br>
      &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);<br>
      &nbsp; &nbsp; &nbsp; &nbsp; …<br>
      }</p>
    <p>Solution2.2</p>
    <p>oneline_pages(...)&nbsp;</p>
    <p>{</p>
    <p>&nbsp; &nbsp; &nbsp; &nbsp; ...</p>
    <p>&nbsp; &nbsp; &nbsp; &nbsp; struct memory_block *mem =
      pfn_to_memory_block(start_pfn);</p>
    <p>&nbsp; &nbsp; &nbsp; &nbsp; if (mem-&gt;altmap &amp;&amp; mem-&gt;altmap-&gt;free)</p>
    <p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);</p>
    <p>}</p>
    <p><br>
    </p>
    <p>Looking forward to hearing your advice. Thanks.</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org">
      <blockquote type="cite">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; move_pfn_range_to_zone(zone, pfn,
        nr_pages, NULL, MIGRATE_UNMOVABLE,
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; false);
        <br>
        &nbsp; @@ -1113,7 +1180,7 @@ int mhp_init_memmap_on_memory(unsigned
        long pfn, unsigned long nr_pages,
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (nr_pages &gt;= PAGES_PER_SECTION)
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; online_mem_sections(pfn, ALIGN_DOWN(end_pfn,
        PAGES_PER_SECTION));
        <br>
        &nbsp; -&nbsp;&nbsp;&nbsp; set_zone_contiguous(zone);
        <br>
        +&nbsp;&nbsp;&nbsp; set_zone_contiguous(zone, new_contiguous_state);
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return ret;
        <br>
        &nbsp; }
        <br>
        &nbsp; @@ -1153,6 +1220,7 @@ int online_pages(unsigned long pfn,
        unsigned long nr_pages,
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; const int nid = zone_to_nid(zone);
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int need_zonelists_rebuild = 0;
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long flags;
        <br>
        +&nbsp;&nbsp;&nbsp; enum zone_contig_state new_contiguous_state =
        ZONE_CONTIG_NO;
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int ret;
        <br>
        &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*
        <br>
        @@ -1166,6 +1234,7 @@ int online_pages(unsigned long pfn,
        unsigned long nr_pages,
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return -EINVAL;
        <br>
        &nbsp; +&nbsp;&nbsp;&nbsp; new_contiguous_state =
        zone_contig_state_after_growing(zone, pfn, nr_pages);
        <br>
        &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* associate pfn range with the zone */
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; move_pfn_range_to_zone(zone, pfn, nr_pages, NULL,
        MIGRATE_MOVABLE,
        <br>
        @@ -1204,7 +1273,7 @@ int online_pages(unsigned long pfn,
        unsigned long nr_pages,
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }
        <br>
        &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; online_pages_range(pfn, nr_pages);
        <br>
        -&nbsp;&nbsp;&nbsp; set_zone_contiguous(zone);
        <br>
        +&nbsp;&nbsp;&nbsp; set_zone_contiguous(zone, new_contiguous_state);
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; adjust_present_page_count(pfn_to_page(pfn), group,
        nr_pages);
        <br>
        &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (node_arg.nid &gt;= 0)
        <br>
        diff --git a/mm/mm_init.c b/mm/mm_init.c
        <br>
        index fc2a6f1e518f..0c41f1004847 100644
        <br>
        --- a/mm/mm_init.c
        <br>
        +++ b/mm/mm_init.c
        <br>
        @@ -2263,11 +2263,19 @@ void __init init_cma_pageblock(struct
        page *page)
        <br>
        &nbsp; }
        <br>
        &nbsp; #endif
        <br>
        &nbsp; -void set_zone_contiguous(struct zone *zone)
        <br>
        +void set_zone_contiguous(struct zone *zone, enum
        zone_contig_state state)
        <br>
        &nbsp; {
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long block_start_pfn = zone-&gt;zone_start_pfn;
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long block_end_pfn;
        <br>
        &nbsp; +&nbsp;&nbsp;&nbsp; if (state == ZONE_CONTIG_YES) {
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; zone-&gt;contiguous = true;
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;
        <br>
        +&nbsp;&nbsp;&nbsp; }
        <br>
        +
        <br>
      </blockquote>
      <br>
      Maybe add a comment like
      <br>
      <br>
      /* We expect an earlier call to clear_zone_contig(). */&nbsp;<br>
      <br>
      <br>
    </blockquote>
    <blockquote type="cite" cite="mid:2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org">And
      maybe move that comment all the way up in the function and add
      <br>
      <br>
      VM_WARN_ON_ONCE(zone-&gt;contiguous);&nbsp;<br>
    </blockquote>
    <p><br>
    </p>
    <p>Will change accordingly.&nbsp; Thanks.</p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org"><br>
      <blockquote type="cite">+&nbsp;&nbsp;&nbsp; if (state == ZONE_CONTIG_NO)
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;
        <br>
        +
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; block_end_pfn = pageblock_end_pfn(block_start_pfn);
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (; block_start_pfn &lt; zone_end_pfn(zone);
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; block_start_pfn = block_end_pfn,
        <br>
        @@ -2348,7 +2356,7 @@ void __init page_alloc_init_late(void)
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; shuffle_free_memory(NODE_DATA(nid));
        <br>
        &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for_each_populated_zone(zone)
        <br>
        -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; set_zone_contiguous(zone);
        <br>
        +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);
        <br>
        &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Initialize page ext after all struct pages are
        initialized. */
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (deferred_struct_pages)
        <br>
      </blockquote>
      <br>
      <br>
    </blockquote>
  </body>
</html>

--------------E9AhRLhvif39JLwM2S2lwelj--

