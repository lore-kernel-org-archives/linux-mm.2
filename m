Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36741D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 23:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506416B002A; Mon,  1 Dec 2025 18:40:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6FD6B0030; Mon,  1 Dec 2025 18:40:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DDD6B0031; Mon,  1 Dec 2025 18:40:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2260E6B002A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:40:34 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E6F6B945E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 23:40:31 +0000 (UTC)
X-FDA: 84172523862.01.4F8BD20
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf30.hostedemail.com (Postfix) with ESMTP id E9E8C80005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 23:40:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fRdw3uMg;
	spf=pass (imf30.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764632428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6b99W16hH4qdEWc7MK4QvJSrfsz+hJY02WsbYWnatDM=;
	b=Y7Ye/rpDKj3429ESqlXuHTRG/W5PM/UmMMANQKIhm5egbqpCBgiHFY3c5+mbIS1MIumAu4
	2Blj0gGcdxBeKbD7mJAgRREHUQRwUufNR9hKhRHqnghdY9R7wyc3e7OR6KPEFxuz+4NeIX
	oV3lbKIQ/puGuYHXDrKbZ5S40hBApRU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fRdw3uMg;
	spf=pass (imf30.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764632428; a=rsa-sha256;
	cv=fail;
	b=hxGajOJjqIpxjiAhZxSZKE04cuCmqyhqixMDnxpqNIS5wDOW2Q+3hym9WyWpnnKlw0VqJt
	SafeRMZa6Z7cPlQpN9gHs0tesmgsYRIVT+QjqN9e/UH2pzepDtMrHZR1VEq5/W/mJzxqea
	BNiqp209e6PWqnM9GwUSDz6KJY/9Vf4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764632427; x=1796168427;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bTDuqndxenCwVEQ2vjhh3XFgcJMag7bu/XSUP4bJZiU=;
  b=fRdw3uMgWyfp3/pn4zRlc37JY/dy8k+XjtQPPhnvroZqWwgKIti3xxc5
   CJJean0FLEIHEkPJuoEZwAgT5j5ZPtXH8Yl0juzWnqeRtmzFm9dDTyHnt
   rDG4XM3UHg1LMpuqdcKeweqS/2GohKuTo9+GQ0OIknDHPzJLPdWYSYbN/
   zWhsjUx+5XCR04ayPTsujkBGxlTWPWdil3DoZC0f/WOG+NL0Srk6upPeR
   TeMViOsL7pLeYc/wwl6d7XFdxjLdE7k1c2zN5ED4/lugQiN/puf6n2Hsf
   Gxi6QDiHhWCIytho6qBzfsTTkyL6foRgIHFY4q8IK4Kxpp3f6z/tKDLOJ
   w==;
X-CSE-ConnectionGUID: /gCao+aeSLeMNs/gIXRNzg==
X-CSE-MsgGUID: 2zso7iR6QyaWCfeS5FWaOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66622913"
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="66622913"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 15:40:25 -0800
X-CSE-ConnectionGUID: djYXu0pJSGWjxDl9qmBG1Q==
X-CSE-MsgGUID: OUWmcGJtSIKDTjNHjfCqLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="194314225"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 15:40:26 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 15:40:24 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 1 Dec 2025 15:40:24 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.26) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 15:40:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bEECRxeOpfLi7a1HdiUHoeKR8fjuQ2kZZeANGGEyupJVDkv1g8PhOW7nUz8ZO1XWjKAc+gLyetb0lUYQ6VmCvdnPZo6j/q56iOXI4kdI5mfustwHgwB61488LtvA6SYeDxcjoDBJm+Qjn2wnBDVYp6Zq1IbyVAl6YxnQCFIIwNqHGcdRTvv3pPJei2henHRn5VG5XG2vU669/TH29AxB+FjM2wtLhWIMgnMzubOtAKPNZZ8n+tEzYQv+WIYT8sMwEHrskueG1aiJmR49QYW6E0Zjo/OQnMZ3W27QWltA209BPhP1lC6MwPXlTYayVpNpVxjwnxuC5DIs3BtVWrgtxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6b99W16hH4qdEWc7MK4QvJSrfsz+hJY02WsbYWnatDM=;
 b=GmswiukW3e5xP1rFap5sdmiwOHEMg5cmARB3jsCwyBfShjp3Z4VJa+x6AVqT9QNo3HUmoZTMfII/mjhMUZWn5iglE/eRnm8GtTtiv+NZ7ldj4Ge/8poSPq+9+zOxGMgZ0KzB0w1nYl0e5X67xLWM/9IGjn9Nu5WbdbJQRw8JNQFSNXZH3GgE/dyhR0fe9tLPce+5JGpuN7Dc9gRxRDInLHEANKR/dUm4ihDI2mZMrJiSFj/qPPho4kicSbZtRKekz6hlmjx9KhYCeKD6RwHvLWcE8o+YtrWaHrPq6HCXaEaXIda6MsVLSJ8YDkSw151fLX0pKwMXHoGmrRzEAB1Ibg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by SN7PR11MB6800.namprd11.prod.outlook.com (2603:10b6:806:260::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 23:40:20 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 23:40:20 +0000
Message-ID: <0d9da08d-4293-4dbd-bf59-999488d73763@intel.com>
Date: Tue, 2 Dec 2025 07:40:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when changes pfn range
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251201132216.1636924-1-tianyou.li@intel.com>
 <7633c77b-44eb-41f0-9c3a-1e5034b594e3@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <7633c77b-44eb-41f0-9c3a-1e5034b594e3@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KU2P306CA0044.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3c::16) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|SN7PR11MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: 83d78290-8106-4939-813e-08de3132fd18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TlZUSmZXV0l3MllkUEtEUU0wSlR6a3hDUTZhbTMvaXFaSG1uc2wvbGhwbkxW?=
 =?utf-8?B?UVF3NjhqQWhOb2FCVlZiQzlNa20vRFNjenk5ZE5aemdyQ2dCTDJjOWovaEtr?=
 =?utf-8?B?eE5iWTFhaytLMmIyVnA1WTJ0UE1yQld3RE1BSXM2Mnh2MTZkYTlnaDhRSU1x?=
 =?utf-8?B?emxUQkRaMVkwbCtrZUJyN2JxeE9rQmFuSENVNGtmbng1T29RSnpkTlJaUE9C?=
 =?utf-8?B?bjA3VWxEMUF4UGZoWnVZNWlpSEJrdTdlc3NlV2xXZzhZMUFFL3l0aFlOT25D?=
 =?utf-8?B?MVVGZnZ5T284ZnhFQmtmdUhURWFyNVZ5SHBYbHppVTZOSUFSVGxvaGlCMWhw?=
 =?utf-8?B?V2FhdlMrTUpKbUNzYUJSMlBXSjkrK1VsSmRQOFluejZyalFaMHNxbDVWUTNE?=
 =?utf-8?B?dEVFMG5KRmtOcE9BQkpMZU5VczFNbmlzQ0JWUzlSZUdrUTA4ZHJWMGQxaDNW?=
 =?utf-8?B?TlpmSDBZSmJpMldHYzFwdkhLbHUwdzMxeTJtL2hja1hoTEQrQWZ5WEl6Qmht?=
 =?utf-8?B?QmFFZDhTekRlV0hzTFhXc29DditrdTFDRjI0bjdWaDRRSUtQYmlFcEVNN29j?=
 =?utf-8?B?eVhvWEc3QUJmMkRBb09VUGJGY2lLOGJPUThkNXFCajZpWVFzMFNwSzA5VWVR?=
 =?utf-8?B?NzFpanFqYityUHREU1YxNENvSDJZSWlDTzNKQU1EL3ZpemZ1UjZHbDloaGtX?=
 =?utf-8?B?K1pzS1JFSkhVT0xxWVF1eFBKUU96NVZuMEpCY3pFc1Z3dElnNEt1bk13Rjk3?=
 =?utf-8?B?K3hPUnhpb0xmTmVhd1J6WnN5ZWFlOFV0bXgwZFNMNzRxRVdYSDN2RWJuMmFp?=
 =?utf-8?B?UW9UWjlQSXZEZWVHWkVVdlRpRHJnYkpua0x4VXNxbXl4NG9LNzhMQVJhdTZi?=
 =?utf-8?B?dlhCNlZmRWZJVGh2blNlOGsraXNQb08yYTdRcDNjbUtZbG5VTGRVV3YxQ090?=
 =?utf-8?B?YTZvTzVwNWFNOGZMVmxqWVhCd0NEYno2aUU3TXhnZUJJZkJrS2RZZDhGcm9Q?=
 =?utf-8?B?TEdjT0tFNFE2VGIzSTZXZUNBekdrbnRpSU93Y3preDNSdmNvc2pKSEZTQnBM?=
 =?utf-8?B?QS9ORU1sY3hUU3RPZWxCeDFxeW9iM01qcGo1bzNKWHh3OTBqOFJnaU5YeGsy?=
 =?utf-8?B?c2g4bHlIWG1OZm81aW9TOWZGMlVRVVgxdlpoVVI2Y3h0dWNrYWxFdFNYZjhq?=
 =?utf-8?B?QW8rYW1aTElFUzFrNzlvU0JSRkJQVSs5VStucllISUZYRlZ1c0puUUt2R0dO?=
 =?utf-8?B?dUNhT3VGZ28zODZaRERpZHdYZnd3eXA5Y2lGa3ZWd2ZXMGFGMUhTd3Q1UzFL?=
 =?utf-8?B?UStHcmQxYUdMblZxUlJLTU1tT3BOUWw0TEpBdEdEdmVvWlg4dzdRcmdIZ3NX?=
 =?utf-8?B?V29PL29qdkRTZVMrSzZTeVl5U3Yrcm4xeVhVejk3dmFNRXpqcElMZ056SHJW?=
 =?utf-8?B?RW1SYlVDbDJ0cnVoVWpSWFRldUV5MmhnSVRVTXFzOUdBWS9mZ3NvKy94Zmtj?=
 =?utf-8?B?c3hpTVBEK1BGQU1hb2NGMzVzTW1GQm1WQU5oOGhIVitVRDhIem1qZ1V2SWJM?=
 =?utf-8?B?SjBOaDNiTi9jMEVpK0VyY1hvTkRRVGVzZmhia1hUcVgvQjF2SVVwNHZsYVUz?=
 =?utf-8?B?OFpORDh4QXdYcDUzOFdUNHBhbElZaEZKRmRpcjMyZFhxdE9YeituaDdjRWJX?=
 =?utf-8?B?eElsZ1dCejUrOE5ZU1ByYkQ1bGVBS2RLK2RNNXViUWN4ZUZmcWJOaTl2YmEy?=
 =?utf-8?B?VGQ5eVdSdzFxem5Bc2VuRW9xeWViYkVXTXI4T1NIaXE0Sk1ES1Z0RmhqcXJQ?=
 =?utf-8?B?VHhkN2VOSWZtRnVPUGNhdVVUKzBvUmIzMFdPNmlZQ0NyUWJ2bEw3MHF0VUcz?=
 =?utf-8?B?Qmw1bDY5bTBobm11SzVscEtYWjNrbEtlcm1DaG00NEtIMHBGN3lpdkE0QkFD?=
 =?utf-8?Q?U1RNtATSRAkS8rzNIipry6ZnnQdTK6KI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzBRL0pQV0VZRWRsVEdlTS9vMFRZMm0xeUZLa0lUM1I1ZEZRMEN6M3grTVVT?=
 =?utf-8?B?Tko5Z2RBSFBicDhuVHI4cWdySnBWYWxnYjJPSTdsMktXVmdUcVNWSEJ0THg4?=
 =?utf-8?B?ZHJyVm01WDJwQTdZZE50MDhDd0hDL2pucWdMOU5tQWdlaWlZTFUwbnJrRTVP?=
 =?utf-8?B?Nm9kTkR2U2FYZnkvQ0JiUFZSU3ZjZURiMktaMi9Ob2Q2ZzdaVjAxcGUrRkVo?=
 =?utf-8?B?cHVFaWk2YnFjOGdEcTFkMmU2WGM0S1ltUVZmNVdVcWJJc1NvaTQvbGc0T0dC?=
 =?utf-8?B?S1lCZkFnbHo4WldwVWNaZnhDRFUwcVB6ZGcyL2FZM05peXhIVmQvK2M1V3JC?=
 =?utf-8?B?UFY4Z0tFSVRqS0Y3RkIyVy8rb1lqNWJORitLSStFWERyQ05QU3RuZThjcGhM?=
 =?utf-8?B?QTNMYmVuencweDhhUW5ncTE1QUJDcjFoZUlIbU1sOTdEa1BNRldoT1BST2tH?=
 =?utf-8?B?ZzRSR1RENW9UMzNjYk81YW4vVHNobXpyVzIyaHJEdDhrOVN2SGVrTHo2bGUr?=
 =?utf-8?B?RllpSEdZcms3SGxLR3VBNllTSHdkeUt5SDR5UFl5MzNQaXFES0JSeWJDem4w?=
 =?utf-8?B?QWZBcUFuSmpOVkhFSHd6eEVqVytqWk4ydG0rYm4yMlRkb0FuWlQ2UG1tZGcx?=
 =?utf-8?B?ZTl0MElkdThGUTlSaVoweTVPQ1V2R0JOd1kwY1IvTkFIVXpEWjI5TDJSUmx0?=
 =?utf-8?B?eUZHbkRSVk1OOCtJYTZOSTVEa21mWGpac3lRdHhrS0tiSXBEU096cFNuWi9Z?=
 =?utf-8?B?MFdPeUNFQlB1b01KSEt2bThNZjRFcTRjYi9xOFdiT3ljNW94U1E2TEhpRFpx?=
 =?utf-8?B?RXhIMFVrcVZnOWZEL0dFUTVxUExna0thSTFFbzU1cmEwNVFReCtaZEROZ044?=
 =?utf-8?B?QkdMa1UvM2RGeDAwd3pHdFJWc0lZeUVybTByeGVJZXR0V2p5OXUycmJMeWhI?=
 =?utf-8?B?MzB5Uk43dkltck5BeU12WEc5V2lWaGF5OUxoUHFYTDdVRjd2MVFaYTJNUnAy?=
 =?utf-8?B?ZlVvVlh4endLdWY4SWY0Q3pPMzNra3I3Z2lGSVFCYmpUaHNzR1ppdHZnaUpZ?=
 =?utf-8?B?RmdZVE5ia0tWdTRuY1NOSGFGc0VrUkxEWkRhZFIwcGkwTE5GUmsySDNVWUk2?=
 =?utf-8?B?eTg3MCtCc2ZLY3JxMm5XdVcrNjZjcVo2aHZMa3dnWm9JRWF1RjRqZ1IrK1Y0?=
 =?utf-8?B?MUJ2L1MzWTFlQUN4RmdaWGRtME94NlFYZk9vNzBTcDYwWnoyT1FVbFlwVm84?=
 =?utf-8?B?ZUdxTWFSUHpVem9aSVlCSGw5YmFjd2NVL0t1bityTVVpa09uTENFbjh4aFN3?=
 =?utf-8?B?c3dmcUJUaGtmYnFyV0JyVjlZMlh0Uk41V3ptSVp5cFA5cVN5SnBDMHpJWVA3?=
 =?utf-8?B?bm5lWFc5aXBSNTRBNTNTbEhhbDIrLzZGNmNCeFZ4TXJkS3huUHp2Y0I3U0xs?=
 =?utf-8?B?VHNXNnZHR3lqdExYcUFkS2JzNTY3TmY4R0REQzVUd21LNGRrbzBUSXcyeTlv?=
 =?utf-8?B?Uml2bkZmRXNSeTh5YjhMbmt0MFYrVVh1bW9sbGpKWnVRTUV4TjNoWHNways0?=
 =?utf-8?B?VTlTMmxtUVhDRUZJWVMrajBtZ1RqdTBFZ2tXTEVRak0ybnRFaHVLMXFSUGhM?=
 =?utf-8?B?S2VlZlFzNHJPK0VhVjZZSUM0TXV0dmFHQWo0R1l1aktoVTJOUHREb1dIejBU?=
 =?utf-8?B?VHNXL2V6SUFBaWQ3Y0EyQzN0S3dmdzlncThYRi8zNXpsSzBCRDdoMEFvcm5n?=
 =?utf-8?B?bWo3ZUZzczVnT1BwL1ZMWkZTRHhpcWozaXd4ZTRXTytNdkhsVFFldFU4UGo5?=
 =?utf-8?B?clE3OGJvUWx2YmsxVlZGbEc5V0xQNklvSWpUUFlWMWV2OXY4Z1YrdmVjY1Y2?=
 =?utf-8?B?WkVqQmUybDlaRDBnUGZBWmt6bklsWUk2QktTeHo0cVFRT0VXcnA1M2lValkz?=
 =?utf-8?B?QisxOWdwZWpTc0IrUEtsQ3dDMlJOOVBCeGM5ZFJUYWM2eDUvNkE1WHl5RElu?=
 =?utf-8?B?MjRVdjVKTTY5TlREM0V4ajN5T1ZzWlpMM3N6NERzY25GbGRtZkxGTUVtZ1Fj?=
 =?utf-8?B?UnM2MmFnNmFUb2tUbmc5bmFYNjF3RzZzWFhFY3B6QW5KSUM3RUY1WkZRMGw4?=
 =?utf-8?Q?HaDaI/bBg07cQfFX9Gye9opGj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83d78290-8106-4939-813e-08de3132fd18
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 23:40:20.1258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d/6toqIv7y9ncj1P7P5s/rTmDCJrxLVcIPKPpCvqEEDcDcKA/XLvOUI06We0H3sd701hV9aQ3gAitlKsUOr9qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6800
X-OriginatorOrg: intel.com
X-Stat-Signature: fzwojzihec7i4zqhy615mxsai8igcsic
X-Rspam-User: 
X-Rspamd-Queue-Id: E9E8C80005
X-Rspamd-Server: rspam09
X-HE-Tag: 1764632426-860435
X-HE-Meta: U2FsdGVkX18jEKdAByy+QdpkpjynSbmKYW1xnxHkK70MI4TYgfe089rXAI2nBmbW6LMKbf4qlw/r1RW9IBYVbAZD6j6PhNYhrNYSTuh5vtH29fR6SIRuDMz1FqGOcaBc87/F2NUKoBEpHOu/cZVCA2ilLjr8ruM4iTBrpmXOYSz7qWhbrhEKQ1bFSnPym/aPeoiRmUvUeaH6HsADr1H5sP80XR1CdL9D182hPto16pDDqP5NBX8hBz6IEZ9PpmOkV46I8zQc4klTEGYuOh0QSlOaWoKNKKJxAs6OxvaYgtGdVVt/Eip+DnBUYz759dochKWs7BR9qd47Ay3ZwthoBA75H4cQmaCDmhsTH87UyX/mLSYpMQyruY1RmeAW4ij7tG7+7Z86wKGOpNQLBjIAlGnW3xwfE4cd3qsxy3/00aLLLERey9i29rQJKJ2AKI4lVQzWQ2gmpRxt3yt2KZ2AY+iOXM5nnQHjxdLh6eoiLP45FYHCJAwNMuFLE79f6I7oxAwJIDwR4YkoUUyANVmmB+xdB1hwr6e4nmWB7o2fhnzSjF5/7Qm6idl0i45QIZjQwcjFitwXqP3OJkoJDjvAfm7hCaKDG6CTQkyk3vhlhp0nWxspMHDaCBRWX0CAcNN4b7AYHhZaD5gqXOIAS+6v2hP8hirurAsFxHePsrGrGOKvimuTRqSnfLnzZJw3S41TQgBGiG/Xww0JupI4gh/NlfuQ/KodtxR3T/JLEx71VAU+0PYMdUP/Y3SKbY5+6XIaXTObJUhXmAtcYrPsHTLN3uOVnktNiVzxETZfy1TztBk4SAra2knDVhyUljX+SyW9mmD1l9qiewtakZ3GYk7p+SwJjQvT11OxXW3m8yl5w7B5B0uL25f8Pqb9WbzB7DhEswzAEy+5YgevQr9fbMDbUH8TwJ15dviV+8wSx7DG8GCXMIh/o15RYIrSCe7fyxLPaVWJZBURBR3BLYKpok/
 ABzJTORG
 IOlIW2XC227P5x4O+E5TNA1YdP5mALy++eXrmmzG9PgCJAWIHdLkjb3dcfo63be8pVtz3qGbyRLaH6/wWJinWEhFPQIVFFRqi5U7Gnr2juPrZZALmeWOfL61fdPH+CxOAwFsFXtS63Hh/6gpOEpN1fA1Um6mIJvl6CWflVpPcSgZamVJLvcbHfrz679zBG7kKLGqSGuqe8yVyTe5ve5GvFU2/HFHj2Guh09Xj/3MMAUrGqixiAFJSmLbdeyJv62Ph12fV8h/0iTSBD0Gvdj/m1xodA29VyAvpPDpjj0qPlHCPhItvP590FMydyNdhSk5Nnd3hY5HUIdjAnU4i68muQO9VTTf2No3V2ZJRS3tsKVcbZI60Lv+vzzQCIGIRRc81gfXsRWTb+CMZvHbK2Y6mXKA3KNexycUYWWyYPDQk1fGQ+cv3AENBcfDtEUFpGh+QRY/QYrf2lFVrtguCFW1ETfQL7pvg7ffo4SgRWX96ifhDi1LsPRUiI5Qj+XAH+tG/VWXuxSIodtBK13aiMTTa+hIlXIIgaOgnjwI4ywT64aYw7f+yhXObXAHfJT9mjy/bQYFJJCA4Xb4MROHlx2XuTmbpq8Xx/bi7jZRYPHhgNvcFjGhPwNY7i5xmXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks David for the detailed review comments. I will change the code 
accordingly after one or two days, in case any other review changes 
needed to accommodate. Very appreciated.


On 12/2/2025 2:54 AM, David Hildenbrand (Red Hat) wrote:
> On 12/1/25 14:22, Tianyou Li wrote:
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
>> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>>      object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>      qom-set vmem1 requested-size 256G/512G (Plug Memory)
>>      qom-set vmem1 requested-size 0G (Unplug Memory)
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
>> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>> ---
>>   mm/internal.h       |  8 ++++-
>>   mm/memory_hotplug.c | 79 ++++++++++++++++++++++++++++++++++++++++++---
>>   mm/mm_init.c        | 36 +++++++++++++--------
>>   3 files changed, 103 insertions(+), 20 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 1561fc2ff5b8..a94928520a55 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -730,7 +730,13 @@ static inline struct page 
>> *pageblock_pfn_to_page(unsigned long start_pfn,
>>       return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>>   }
>>   -void set_zone_contiguous(struct zone *zone);
>> +enum zone_contiguous_state {
>> +    CONTIGUOUS_DEFINITELY_NOT = 0,
>> +    CONTIGUOUS_DEFINITELY = 1,
>> +    CONTIGUOUS_UNDETERMINED = 2,
>
> No need for the values.
>

Got it.


>> +};
>
> I don't like that the defines don't match the enum name (zone_c... vs. 
> CONT... ).
>
> Essentially you want a "yes / no / maybe" tristate. I don't think we 
> have an existing type for that, unfortunately.
>
> enum zone_contig_state {
>     ZONE_CONTIG_YES,
>     ZONE_CONTIG_NO,
>     ZONE_CONTIG_MAYBE,
> };
>
> Maybe someone reading along has a better idea.
>

I agree it's better. Will wait for a day or two to make the change.


>> +
>> +void set_zone_contiguous(struct zone *zone, enum 
>> zone_contiguous_state state);
>>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>                  unsigned long nr_pages);
>>   diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 0be83039c3b5..b74e558ce822 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -544,6 +544,32 @@ static void update_pgdat_span(struct pglist_data 
>> *pgdat)
>>       pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
>>   }
>>   +static enum zone_contiguous_state __meminit 
>> clear_zone_contiguous_for_shrinking(
>> +        struct zone *zone, unsigned long start_pfn, unsigned long 
>> nr_pages)
>> +{
>> +    const unsigned long end_pfn = start_pfn + nr_pages;
>> +    enum zone_contiguous_state result = CONTIGUOUS_UNDETERMINED;
>> +
>> +    /*
>> +     * If the removed pfn range inside the original zone span, the 
>> contiguous
>> +     * property is surely false.
>> +     */
>> +    if (start_pfn > zone->zone_start_pfn && end_pfn < 
>> zone_end_pfn(zone))
>> +        result = CONTIGUOUS_DEFINITELY_NOT;
>> +
>> +    /*
>> +     * If the removed pfn range is at the beginning or end of the
>> +     * original zone span, the contiguous property is preserved when
>> +     * the original zone is contiguous.
>> +     */
>> +    else if (start_pfn == zone->zone_start_pfn || end_pfn == 
>> zone_end_pfn(zone))
>> +        result = zone->contiguous ?
>> +            CONTIGUOUS_DEFINITELY : CONTIGUOUS_UNDETERMINED;
>> +
>
> See my comment below on how to make this readable.
>
>> +    clear_zone_contiguous(zone);
>> +    return result;
>> +}
>> +
>>   void remove_pfn_range_from_zone(struct zone *zone,
>>                         unsigned long start_pfn,
>>                         unsigned long nr_pages)
>> @@ -551,6 +577,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>       const unsigned long end_pfn = start_pfn + nr_pages;
>>       struct pglist_data *pgdat = zone->zone_pgdat;
>>       unsigned long pfn, cur_nr_pages;
>> +    enum zone_contiguous_state contiguous_state = 
>> CONTIGUOUS_UNDETERMINED;
>>         /* Poison struct pages because they are now uninitialized 
>> again. */
>>       for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
>> @@ -571,12 +598,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>       if (zone_is_zone_device(zone))
>>           return;
>>   -    clear_zone_contiguous(zone);
>> +    contiguous_state = clear_zone_contiguous_for_shrinking(
>> +                zone, start_pfn, nr_pages);
>
> Reading this again, I wonder whether it would be nicer to have 
> something like:
>
> new_contig_state = zone_contig_state_after_shrinking();
> clear_zone_contiguous(zone);
>
> or sth like that. Similar for the growing case.
>

In both shrinking and growing case, separate the clear_zone_contiguous 
from the logic of zone state check, right?


>>       shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>>       update_pgdat_span(pgdat);
>>   -    set_zone_contiguous(zone);
>> +    set_zone_contiguous(zone, contiguous_state);
>>   }
>>     /**
>> @@ -736,6 +764,47 @@ static inline void 
>> section_taint_zone_device(unsigned long pfn)
>>   }
>>   #endif
>>   +static enum zone_contiguous_state __meminit 
>> clear_zone_contiguous_for_growing(
>> +        struct zone *zone, unsigned long start_pfn, unsigned long 
>> nr_pages)
>> +{
>> +    const unsigned long end_pfn = start_pfn + nr_pages;
>> +    enum zone_contiguous_state result = CONTIGUOUS_UNDETERMINED;
>> +
>> +    /*
>> +     * Given the moved pfn range's contiguous property is always true,
>> +     * under the conditional of empty zone, the contiguous property 
>> should
>> +     * be true.
>> +     */
>
> I don't think that comment is required.
>

Got it.


>> +    if (zone_is_empty(zone))
>> +        result = CONTIGUOUS_DEFINITELY;
>> +
>> +    /*
>> +     * If the moved pfn range does not intersect with the original 
>> zone span,
>> +     * the contiguous property is surely false.
>> +     */
>> +    else if (end_pfn < zone->zone_start_pfn || start_pfn > 
>> zone_end_pfn(zone))
>> +        result = CONTIGUOUS_DEFINITELY_NOT;
>> +
>> +    /*
>> +     * If the moved pfn range is adjacent to the original zone span, 
>> given
>> +     * the moved pfn range's contiguous property is always true, the 
>> zone's
>> +     * contiguous property inherited from the original value.
>> +     */
>> +    else if (end_pfn == zone->zone_start_pfn || start_pfn == 
>> zone_end_pfn(zone))
>> +        result = zone->contiguous ?
>> +            CONTIGUOUS_DEFINITELY : CONTIGUOUS_DEFINITELY_NOT;
>> +
>> +    /*
>> +     * If the original zone's hole larger than the moved pages in 
>> the range,
>> +     * the contiguous property is surely false.
>> +     */
>> +    else if (nr_pages < (zone->spanned_pages - zone->present_pages))
>> +        result = CONTIGUOUS_DEFINITELY_NOT;
>> +
>
> This is a bit unreadable :)
>
> if (zone_is_empty(zone)) {
>     result = CONTIGUOUS_DEFINITELY;
> } else if (...) {
>     /* ... */
>     ...
> } else if (...) {
>     ...
> }
>

Yes, I am thinking of that during coding. I was keeping that way for a 
'better looking'. I agree that will not be a good case for maintaining 
the code. Thanks.


>> +    clear_zone_contiguous(zone);
>> +    return result;
>> +}
>> +
>>   /*
>>    * Associate the pfn range with the given zone, initializing the 
>> memmaps
>>    * and resizing the pgdat/zone data to span the added pages. After 
>> this
>> @@ -752,8 +821,8 @@ void move_pfn_range_to_zone(struct zone *zone, 
>> unsigned long start_pfn,
>>   {
>>       struct pglist_data *pgdat = zone->zone_pgdat;
>>       int nid = pgdat->node_id;
>> -
>> -    clear_zone_contiguous(zone);
>> +    const enum zone_contiguous_state contiguous_state =
>> +        clear_zone_contiguous_for_growing(zone, start_pfn, nr_pages);
>>         if (zone_is_empty(zone))
>>           init_currently_empty_zone(zone, start_pfn, nr_pages);
>> @@ -783,7 +852,7 @@ void move_pfn_range_to_zone(struct zone *zone, 
>> unsigned long start_pfn,
>>                MEMINIT_HOTPLUG, altmap, migratetype,
>>                isolate_pageblock);
>>   -    set_zone_contiguous(zone);
>> +    set_zone_contiguous(zone, contiguous_state);
>>   }
>>     struct auto_movable_stats {
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 7712d887b696..06db3fcf7f95 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -2263,26 +2263,34 @@ void __init init_cma_pageblock(struct page 
>> *page)
>>   }
>>   #endif
>>   -void set_zone_contiguous(struct zone *zone)
>> +void set_zone_contiguous(struct zone *zone, enum 
>> zone_contiguous_state state)
>>   {
>>       unsigned long block_start_pfn = zone->zone_start_pfn;
>>       unsigned long block_end_pfn;
>>   -    block_end_pfn = pageblock_end_pfn(block_start_pfn);
>> -    for (; block_start_pfn < zone_end_pfn(zone);
>> -            block_start_pfn = block_end_pfn,
>> -             block_end_pfn += pageblock_nr_pages) {
>> +    if (state == CONTIGUOUS_DEFINITELY) {
>> +        zone->contiguous = true;
>> +        return;
>> +    } else if (state == CONTIGUOUS_DEFINITELY_NOT) {
>> +        // zone contiguous has already cleared as false, just return.
>> +        return;
>> +    } else if (state == CONTIGUOUS_UNDETERMINED) {
>> +        block_end_pfn = pageblock_end_pfn(block_start_pfn);
>> +        for (; block_start_pfn < zone_end_pfn(zone);
>> +                block_start_pfn = block_end_pfn,
>> +                block_end_pfn += pageblock_nr_pages) {
>>   -        block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
>> +            block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
>>   -        if (!__pageblock_pfn_to_page(block_start_pfn,
>> -                         block_end_pfn, zone))
>> -            return;
>> -        cond_resched();
>> -    }
>> +            if (!__pageblock_pfn_to_page(block_start_pfn,
>> +                        block_end_pfn, zone))
>> +                return;
>> +            cond_resched();
>> +        }
>>   -    /* We confirm that there is no hole */
>> -    zone->contiguous = true;
>> +        /* We confirm that there is no hole */
>> +        zone->contiguous = true;
>> +    }
>>   }
>
>
> switch (state) {
> case CONTIGUOUS_DEFINITELY:
>     zone->contiguous = true;
>     return;
> case CONTIGUOUS_DEFINITELY_NOT:
>     return;
> default:
>     break;
> }
>
> ... unchanged logic.
>

Will do. Thanks.


>>   /*
>> @@ -2348,7 +2356,7 @@ void __init page_alloc_init_late(void)
>>           shuffle_free_memory(NODE_DATA(nid));
>>         for_each_populated_zone(zone)
>> -        set_zone_contiguous(zone);
>> +        set_zone_contiguous(zone, CONTIGUOUS_UNDETERMINED);
>>         /* Initialize page ext after all struct pages are 
>> initialized. */
>>       if (deferred_struct_pages)
>
>

Regards,

Tianyou


