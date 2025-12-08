Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F47D3B7F3
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 15:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CA586B0006; Mon,  8 Dec 2025 10:06:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353CD6B0007; Mon,  8 Dec 2025 10:06:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE1E6B0008; Mon,  8 Dec 2025 10:06:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3D2F6B0006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:06:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 679B6C0204
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 15:06:17 +0000 (UTC)
X-FDA: 84196629594.24.6380BAF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf26.hostedemail.com (Postfix) with ESMTP id C486A140025
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 15:06:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bCqbu7o5;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765206373; a=rsa-sha256;
	cv=fail;
	b=MXstGhc49NmYVCjVAo6bfn4v29aIN+ZsZnxZY1tq5wGaXtZD1L3xQMbUTODhb/tU3h1Hq4
	z0bSH6Q5OsdGvrRaa8mqnQQB0I4L+2RR8LQD4vsjFOZCjnbAbmvmzjl43+1ItpkoNonvBH
	TneoWqlNj03vFv1WXhKlvIseyFoWHog=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bCqbu7o5;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765206373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+WKk27lVoI0vgdJdYFsB78yk7twH/Cdk7hafXI2+ls=;
	b=LT+qzrw7BccPkJxByb0HjENi0PXfO/6Uv3wyPk7ntTA9jZdWKGWiS7GQDkRFWwwdzNkpGh
	DBPGHEsf4v6keGZ5LKilw6TsCUoEgDYowRe9IoG2O7lxUMXsbYg7ZUrrmwykXo6rLmoVlR
	nb5Im/i4oG0PDaDPvbPpsJjVXckZ788=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765206373; x=1796742373;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LMPJBct4Y1Couda6WW/m6ws8LEIuc7xoK8k7wPwsvZs=;
  b=bCqbu7o50XDlUEHO9npkJtI4BhJGummrkCrF8g9sKjy0IwFTGxThdh3f
   sfLtWyMPeMg4hcFg+Ade326wG/o7yjgRda8R5a2ccUgWvpDbZrNdA/y23
   Q4UQZkVMjy/hXdreoI5RuHPZEeZif+Y4cTJAoBwKiS8QKM85wDQWyBeB3
   JZUsNLCXEZ7rc3AaYr96Hz2rF2/i1h+AGfUrLpfVMO5vNLvCGxqoHXEsv
   Y+MaKPsDdcg0hzS7Mbm8d/j+NEkqzb7G5+w8sJLJ8Umhmy4BEScaU6J89
   UFPsB92Qp+ljraUKcFOJ8M7ylAJFBxR3COCjqRJPNZyY6cZ40f6AHuET0
   A==;
X-CSE-ConnectionGUID: wt6ErqOyRCmkpEgfd0/4eA==
X-CSE-MsgGUID: LeYapdjWTw6FryETc19i9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="70766621"
X-IronPort-AV: E=Sophos;i="6.20,259,1758610800"; 
   d="scan'208";a="70766621"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 07:06:01 -0800
X-CSE-ConnectionGUID: dPXzbSxvTkuvIkge2u4mpQ==
X-CSE-MsgGUID: wtoO8V0IScOKOQftc1cOxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,259,1758610800"; 
   d="scan'208";a="233324917"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 07:06:01 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 07:06:00 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 07:06:00 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.70) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 07:06:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=STrD+fBNiZVjZEWfQmUMNSJn6rHkVe5LW8tR7aN+hK2EfbMBxjXlNwItTsv5/7SEH3KsN8aS5ooZL4kkofBKXAEmS3bx+WNzT8e+wsk6Euo7Z+A5XmCkcM9tZPLULf92chZOed+yTNFiS1+1L3ku9wyNdyIWSbmMS10Q+P29GIekvsWLDDJvztpYuECHlYcPSaI064Vh0Uaxu3Am/Cw9eejzcQkg9lFG80NnXJaaoJh57vAXkTftRbCi8EiCWzbmLWV4tOgFGCFcHCXXBY7kjFQ9h7mw8FIHGq2Du4OWiwspRA/zo0Vs0hV+xnvANtJSBW4B+P/hEfBWGdVNS1sjcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+WKk27lVoI0vgdJdYFsB78yk7twH/Cdk7hafXI2+ls=;
 b=d37uM1jOcBgHbrxNMsgaPSCTqVoYYLzQbpBs1TC9m4+jY+TzER3dWpZOvg2LpRvqlrVxzT6OCz4lcQNuU+R2hrH9XlvxvNfGU5cQAbcdgFJaqd7YS8VMCLDWSu2ft+KF20RLqUgXsLLHjSyf54KQycpBaklPHEehW3NkcxUyaKVKGBRhOYUSjQ8zdsH8nk5aVXnSjCUOPU6fP6mIGlBylSU9aC4EIvGEZQjrZaff6hR7Fvrr4VxIlJKAEfAx7gmYEtpIPsk2ZSS68mMb76sVLPz3MBghYqm+ggLrMqH1BsUtKefa8OD1RnOh4JO6MG4qJIWV53uHqUkcHJ2UjDInHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by CH3PR11MB7273.namprd11.prod.outlook.com (2603:10b6:610:141::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 15:05:56 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 15:05:56 +0000
Message-ID: <49bda900-e79f-4d43-8ea8-46e7d9f78c2d@intel.com>
Date: Mon, 8 Dec 2025 23:05:49 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when changes pfn range
From: "Li, Tianyou" <tianyou.li@intel.com>
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
 <0d9da08d-4293-4dbd-bf59-999488d73763@intel.com>
 <2901df56-bf0c-4d08-b043-eca294b981f9@kernel.org>
 <7761ab95-4cf4-4a6f-a979-ce862ad97f85@intel.com>
Content-Language: en-US
In-Reply-To: <7761ab95-4cf4-4a6f-a979-ce862ad97f85@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TP0P295CA0047.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::13) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|CH3PR11MB7273:EE_
X-MS-Office365-Filtering-Correlation-Id: 73aa1461-a8f3-4264-931d-08de366b49eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L2I1MkxFcDlvMjVhbTBEbnd0akxJbVppZE9yaENFUGJWeklHa1F2MUFnQ2Ux?=
 =?utf-8?B?Tk9VL2ZSUXBqY21kY3g5VWV4cE5aREZ5TDhxZ0FyOVN3MDIvZGpCYWxKOEN2?=
 =?utf-8?B?czh6dWc3OVlRMkNFdC9sWkY2RXVROHJ6VWJrZjR6T2RmSkh6b3cyb2FzaWhS?=
 =?utf-8?B?MjQwYW9ZT2Erek0weUpHMW1GeHJrK0tjN3hYMDF2dDA1RVdkUFVRdzNWOVNP?=
 =?utf-8?B?RXJNc0JLYkptNTljaGNBOWI4RDgrUEYybU9zN1BSdHM3ZUtJN1RvUTRhVnZj?=
 =?utf-8?B?azAzRC9yM2JhSWNVdWs4dWZzdjFMalFJOXdhZmJXckZXdjF2bHhtSFJNT2pV?=
 =?utf-8?B?VkxQdXhWbi9xNG53QlZhZUMyY0VOWE5Gb0ZDbk1zZ1pBcHNFVjFpYUZlVDhv?=
 =?utf-8?B?L1JqYUlzZFFKZnlCZ1pYTTJmTzVPV1JoNDh1U2lwMzBDaEV5dVNDUkszNUpL?=
 =?utf-8?B?NVplcHlRdXI3T3FEemVuT0VkV24zQ1NneGdzQkFDYUJqbVRlV0VPQmlnTFVD?=
 =?utf-8?B?MndGTGNweVd2SHFOS3Vnd1dBWUt5YS9EY2dya054Y0Z1bVptM2ZiRXdKNlhr?=
 =?utf-8?B?QnZaNXo5UzBkeUdUTTdxZ2IxKy9MV3VyQ2RpWkxCZDRoL240ZjZZZ3kxbmlY?=
 =?utf-8?B?bHNFOFM2MGVHbjhjbmQ1UFZpRjlhcXI1MTdIU0pxWXdkOTNhY2FGSTJwOURH?=
 =?utf-8?B?dWx2amt5M3laZVNJVlQ5VWc0MzNCTW5Qc2lYamwxSEJ3NWVLTTFHaURTRUJ3?=
 =?utf-8?B?ZThZS2ZYQnBQcU96aHpOeDNZRjg2QU5HNkE3MlJmMGphTTh2M3pUalFicndj?=
 =?utf-8?B?dGdDTnNpaFZVbkdNcXh1SE0wNHBGdFJKalBRbTVsRmx3WGJyUTFWbG5MNHNt?=
 =?utf-8?B?OWtLYnY5bGVFZmhKMm5PSlRWa0VsTTYrY0tRT3IwYmVzeHhmS2pKbEJGTEhG?=
 =?utf-8?B?dVNIYW9GU0t5Z2p5TkN0SXBuTDd0R1VGcmEwRFY0S3dmcHQzUm9kUFlvNlc0?=
 =?utf-8?B?TnBHckZ0UnpBODJoQmNpMFlUM0p3ak93cE5jYVdzUThnbXdaakgzc05DcVkr?=
 =?utf-8?B?bEJ6SE9ON1NvL254Q1pDVmtIbis0RjRBQWFpbmNEN3NlU1JFZW1ZVFFveHBB?=
 =?utf-8?B?d3psbFg3c2M2Ni9BMks2LzhXb2RKVFhDMGNRbitOTk1YYzlOcTQyTkNjaHFR?=
 =?utf-8?B?Mzh3aWdPUmNpSzZtYlcrRTYrOTNMTWNGTW5SMDY2SERvQU1xOVNSbWZLUjRI?=
 =?utf-8?B?L1VLaU1UNGlNZ2E3aCtHc2JacWpFZXI2T0UwTEdGc0RIYXZ6RVVxd0VMWnNK?=
 =?utf-8?B?YmRzNGFmRG9KaE9ydFoycUM5WXdLRXFGOWpySlR2SWhmdFI5TC8rLzZOUVZ6?=
 =?utf-8?B?THg4WWdXNGl0OCsrSnNUMzdXSHV3QmFNM1BpeDV2dk1SN25qbmh5UTF6RFpX?=
 =?utf-8?B?eDN5R2dCZnVaYW13WDh1USs1WnNhclVIRmFWZkxBM0ZEMmRaOEE1bFNRZUta?=
 =?utf-8?B?eHAyZi96ZkFPdnZhRktHK0lJVGcxaUd4UW55d0RJWVhnWGtoM0FRRFVHNDVD?=
 =?utf-8?B?dVlTRlE3VGc4T1JRZkMvcW1vVU1vMnRMaGZpUnp3MFBjQXVyVzYzVWdMSkhQ?=
 =?utf-8?B?dEdtMDErQmZ1Ylc4MWdRL0lCR2ZtbkZvdkcxMVJrdXNOR1Z3YzNUZEp1Mmpk?=
 =?utf-8?B?b2Zuc0F3MFpNUzJTR214NHljY1J3L2Z0STBzNGlrSU1MZ1VzYW5IeGtCRzZi?=
 =?utf-8?B?YkRJbXdDVWk3THJuNU5DMVhLZFlOUndMa2psYVZibEwyYklpWXcvb2J1aThS?=
 =?utf-8?B?dmJ2Y2Yza01DWnZQREY4LzZxQnJjYmpaTEtwMWpuWnMzR2UxYnBVakFmaFZG?=
 =?utf-8?B?VWdlR2hnekFKbFY3QjJ3TThzSHJWOVdROEdCdnBKZFQ2SzNJRXZ2K1dVd0lz?=
 =?utf-8?Q?56NDfsM7OEHKcYDL7XdvnblzJy7VrDwv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SG1tNU5UbHpTT3V2WnRMZWxvV1dZNlBqOXF4Uy9aMFZYRmNxY2RHYTVLZFhx?=
 =?utf-8?B?ZUp4ZWcrVDRNenJ0dUhvck01TFFWaDJMbmkyVkh4ZTJPSU45dGQwNVMrTjJQ?=
 =?utf-8?B?Mk5HbXNZVVUyQ01sZWhtTFRmcG01UG1iTzBZbjBlUWIzcFFxSURONHBQb3dI?=
 =?utf-8?B?cU5TSUdJa1dBVVUxQjlEaVlDYjdRN0d0SzgxWHNHaEJ3UlcwWDNlOGlWYU5Q?=
 =?utf-8?B?eVhWVFRyMU8vMXRZazdmaHVCS3dWRFlRYnpydWdrVnRmWTJpdkNnOXRtR1cw?=
 =?utf-8?B?MlVmYjdaMlk5azBMMytzd2ZGdTZSMFpaY3FQRmJGTnBTMCtSQlFWVmZBRWNU?=
 =?utf-8?B?WGowekl5L21jbEpKWGFxTFJ4L1IxdFBBNk9tQlVKSW84RHBnY2tHL0VkZDly?=
 =?utf-8?B?SzVHYW9iemJzaUE4Z0xVaWtFQmFzRXBUeFRUd1ZPUlRaRUl2bnpVUmxnVlcv?=
 =?utf-8?B?QTM0WThHa2UwTGNzV1dhUGxvdFdsclRuaUw1cDJ2RHgyR21mVHVNZVc2WnE2?=
 =?utf-8?B?MUh2R1RKMU1ZeW5uN2dxbFlvUkdPRjlUTThoRXNJQnN2Z3ZWcHpiS0JOektL?=
 =?utf-8?B?aVRVaFVOOFlMUmxKRjh4NUVhVkNkZmFxNzNLMkVxOElSQnVYcVcwa3h4Sjhv?=
 =?utf-8?B?U2FqNklUQXpSU3VDUWdWLzNUVHBUelZXdUZka05waVp4cFpad1NPTXllemV2?=
 =?utf-8?B?V3BoenZ6cUNDWFlsS1VKWmRGcTdVTThUVjM3a21MOHRsQnRaT0F5Uy9NREdl?=
 =?utf-8?B?SGVaYitlQ25neW92WnZqYUswMmp0UktkMmdOa21LZ3hHd1F2MGRENFJVVXJH?=
 =?utf-8?B?NkFvalNjenFEK2RBdFFjRHh3N2pJUDF2T21UV01mWlRPSXI4Tm83YW84bHBC?=
 =?utf-8?B?SUorNG92Q29pWGMrNnAxbjVFcGt6MEptRG5IQnZzTkk1bk9OalNLRzl1RzdP?=
 =?utf-8?B?MUlwSlhoK2JRcGlpdXF6N05NaDFPNTByMXFyU1ZGMHNMbGtZZFBnUm9QU3p3?=
 =?utf-8?B?bnVEc0tMMk9DK1NUck9YMWpxKzJvVExKK3ZuMjRIdjloZERuUFRlNGdRZldw?=
 =?utf-8?B?b3kvenJvSXZxTFE5WXd5b05wZ2FoaEg2VEg4bVpVTHk1a01RVXVQSm9EN2tQ?=
 =?utf-8?B?a0NVUGM3UmlPejFXVEd0ZUNSMjFJUmp0MWJzWmlpT254cDhWc1A2NTVUcnl1?=
 =?utf-8?B?M1RGQlZURFB2L3pCV21adWpQRkhDWjdVVC9vSi9vTmJxa2Q4VXR3Nkp0bTNn?=
 =?utf-8?B?c0I4aW83eExLUzJSM25wQjJkam40OTk1SnU5TVZzak1tQkxMWlpHamt0VC9h?=
 =?utf-8?B?d00vaUdPQUl0NGdaeFA3UEkrZjBmQVhKMjMzVnZsSHQveXFZSDdyRDBEODhk?=
 =?utf-8?B?RFVWbnUyZGNkczBkQ1pHTVloNW51cGk4L3hGc1lFbnJKeXNzcjJ6R0RaVzlJ?=
 =?utf-8?B?WE1BaXcvaTFDeUFQeE1ULzM1VGphZkd3b3ZkWk03MWJnRXp3Y3p0Z1gwbHdX?=
 =?utf-8?B?bHUrK0RLRmIzSUFiU0g5b3l0czkyR25Ed2lYamJZMmYrbWVrM1h6SHZPV3dJ?=
 =?utf-8?B?ODJ0dFZ3V3IwT0t5SU1oZ1JKZElEUFR2L1ZuZmpOYTJtOVRqMUlhb2hvMTBV?=
 =?utf-8?B?czhFMHZvS29VQmlVZ1hQRUpjZFYyVGI1anpoYnVSUi9IaHV5bHliZWs2U0di?=
 =?utf-8?B?b0RHeStwa3d1cHREQWRrNkY1WDZVREVpQ05SQWtKQ2FTK2xuZHJGZko0aEli?=
 =?utf-8?B?SEdDSjJHbGtYc210S2lGZUNJd01xMVRnQVpsMEsxNFJoZWhvSFBwdm5iREVu?=
 =?utf-8?B?dS9oUjJSZ0VtVGg4ajN2bWlzc3lNSzdZK281eks3R1JaZ0RlRzJ0QmVhUzRG?=
 =?utf-8?B?aGV6OWVRbmVhaXU0dXlYRjBzYUF0bk1rYUc0WlFIVXZnV0p5MGc2TUJzTUFF?=
 =?utf-8?B?K1J1ZDlsWDUwbkJpczE5Z3BuWm02VXZBRVBNeUJXT05waVg5Q1ljeDA5dStr?=
 =?utf-8?B?NW84c290bTZxZG5jd0htZTY3THZMbVJQKzRteWxqV2hud2lSbnJGNVZ2UWt0?=
 =?utf-8?B?S3FPNm9sTkJWazErbzNTQTZNMjRXK2NpZkFPWHFZditrQkI4Y0MwSjl0Tkhr?=
 =?utf-8?Q?/TmzIy4ljPCOys/jWedeKq9Sg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73aa1461-a8f3-4264-931d-08de366b49eb
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 15:05:56.5485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqoPqX12hnVWKCOPWQVrTr7hkYF4riXodr/BdP3n4e3Ppz2fjhI2IaNPiD+uYLO6Uf7ZNoDZAm+ojqOrkTlmYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7273
X-OriginatorOrg: intel.com
X-Stat-Signature: a8g96zy9gpxet8hjy95it8t8opwbzbbp
X-Rspam-User: 
X-Rspamd-Queue-Id: C486A140025
X-Rspamd-Server: rspam01
X-HE-Tag: 1765206372-173286
X-HE-Meta: U2FsdGVkX1/9yyhldatAjQXXXO4iXR6rgYy8N48GJY3YPwCyGZYuKF7GPY7K5bqxNMrXRPtEOY6cz4SfymUaPmfHSPX66FiwFKxwX6Q685ncX4lJvpyGkVXARvKVM2dWmQJMoxDSCtD5OV4N+JAnIFm3QDrDsaRymrSoUDqA7T2RkPGZhIZq9QQn0AVDWFxjRM4enGd9O0Z2VDjh5YanDbiJb/3hWQThSzlNFQTcX91R8klQOCWaW0s8uKQ4C522YyZV8G7HkAssYVx+HdTq9s2VZRXjNgwk53CLiIEXtNB0gevbuEoYnDa4AY39nqIgqO+m/7e+FoVARh78DapYb81Dz75nwou2bnsAS9o5B5HihqClTyMleL2Altr76dVGi7NhBzJDlikD7QvkK/vt3xcqWSx3LEG6wL2WomTmnZEBGi0hGeCaMDnvL89yDGOIDJaOJLZ0l3mhmLNgrd9xxSjKwdlh63g87/4X/mwPOOpjbDbyrNxM14Uvyo55VOXSiF6HtBxODymBStlsum5lSNea9NmMkQGVsd1Uja9ffj0SDPfCQNMl6VtJqIFMXAFcjbOBsLeMrOwRSLJuJPCbl6BXU2RID28hPXp6fHD0uFaBawbHHhxVQJqNVnrnTah7P5LYRjskgFY5X1HvP0oIEDSK/x9diOhtXN7ifY62g/TtXE05vNsaV6IKuGk5JMi7eplG0kTediF0JT5yOPkiHq7fhhPATdGwm4A2n87ijV6D5VC8SPoe+GDDBuC841F7Wc6oFtJ80vEiI7N/tuhcKWlmcML2ubms4/i+MS61pelUwj3JfEdx+CWcgZXSzU0s9HabhGLwtQDWowHom/2NS+sof3y0CQcFjhDWjsIcJTEvfYUEDd5Fx+5etDTKbRyUtbpWzTjIfaQ2sISKyXFwv9m93doDw7IBJSQqDz4Ls+n326y8rm6LaMYo8MYoBMEP7tHRBNSpQyhPG67TKnh
 ux9nmhyX
 dRP2fbuQplZaJbHGkD8zF1RTWf4T6tX8zJnLz71LZjWlVLLIEPiUV27a4jKUmdO40ycL6SsIVRDSEH6u4tUO5c8xlxbyjc1NYNWPqjg3g/TWp6cG7vbId7ZmwmSleOXXiKRFNHOL55eIiRzMYbmOAh3M5ADYDED5nnyQrcFxhcUy2RyCF5TuP8erJNrxGahAMKGTJoRiK6vWP2J6UiJYO1LO8weww4f61Bz3LGpItuiiMBl19d8NZmhJo21Wzb2DxNXam7ixg2MF3WWwsrIZU4A5n7ppParliBHtnco2K4uaTIXAHpAARimT8nyaqORhCyvXlD5qzzMhumwyzQQgBLfiyve5jYIfzm2cLcDhp6dDvqH9B3z9DIt4WYB/3lpW8NiVRaDLhN01zawUGagZCLQqgxxB+4AosQ2pl4chDqfhTcv+lGJwDI7+NoIs+fFNEU8bRd8YyNobaUNcMGru32M6lRihRcUWlWs+n6AXDUyUKesAIXLBI9qleX6w3jfTtdMHKUnZmDemxFYsLL020NL16FQhHl1YYSkVY961+L9CWKhYUpd6A61GdKiNBPCyIMkOW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for the delayed. We were working on a suspected issue and now the 
patch v5 is out. Thanks for your review in advance.


Regards,

Tianyou


On 12/2/2025 6:41 PM, Li, Tianyou wrote:
>
> On 12/2/2025 6:24 PM, David Hildenbrand (Red Hat) wrote:
>>>>> +};
>>>>
>>>> I don't like that the defines don't match the enum name (zone_c... vs.
>>>> CONT... ).
>>>>
>>>> Essentially you want a "yes / no / maybe" tristate. I don't think we
>>>> have an existing type for that, unfortunately.
>>>>
>>>> enum zone_contig_state {
>>>>      ZONE_CONTIG_YES,
>>>>      ZONE_CONTIG_NO,
>>>>      ZONE_CONTIG_MAYBE,
>>>> };
>>>>
>>>> Maybe someone reading along has a better idea.
>>>>
>>>
>>> I agree it's better. Will wait for a day or two to make the change.
>>>
>>
>> Yes, good idea. No needs to rush at this point because the merge 
>> window just opened up.
>>
>
> Got it. Allow me to take one more day then complete the patch v5 with 
> sufficient testing.
>
>
>>>
>>>>> +
>>>>> +void set_zone_contiguous(struct zone *zone, enum
>>>>> zone_contiguous_state state);
>>>>>    bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>>>>                   unsigned long nr_pages);
>>>>>    diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>>>> index 0be83039c3b5..b74e558ce822 100644
>>>>> --- a/mm/memory_hotplug.c
>>>>> +++ b/mm/memory_hotplug.c
>>>>> @@ -544,6 +544,32 @@ static void update_pgdat_span(struct pglist_data
>>>>> *pgdat)
>>>>>        pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
>>>>>    }
>>>>>    +static enum zone_contiguous_state __meminit
>>>>> clear_zone_contiguous_for_shrinking(
>>>>> +        struct zone *zone, unsigned long start_pfn, unsigned long
>>>>> nr_pages)
>>>>> +{
>>>>> +    const unsigned long end_pfn = start_pfn + nr_pages;
>>>>> +    enum zone_contiguous_state result = CONTIGUOUS_UNDETERMINED;
>>>>> +
>>>>> +    /*
>>>>> +     * If the removed pfn range inside the original zone span, the
>>>>> contiguous
>>>>> +     * property is surely false.
>>>>> +     */
>>>>> +    if (start_pfn > zone->zone_start_pfn && end_pfn <
>>>>> zone_end_pfn(zone))
>>>>> +        result = CONTIGUOUS_DEFINITELY_NOT;
>>>>> +
>>>>> +    /*
>>>>> +     * If the removed pfn range is at the beginning or end of the
>>>>> +     * original zone span, the contiguous property is preserved when
>>>>> +     * the original zone is contiguous.
>>>>> +     */
>>>>> +    else if (start_pfn == zone->zone_start_pfn || end_pfn ==
>>>>> zone_end_pfn(zone))
>>>>> +        result = zone->contiguous ?
>>>>> +            CONTIGUOUS_DEFINITELY : CONTIGUOUS_UNDETERMINED;
>>>>> +
>>>>
>>>> See my comment below on how to make this readable.
>>>>
>>>>> +    clear_zone_contiguous(zone);
>>>>> +    return result;
>>>>> +}
>>>>> +
>>>>>    void remove_pfn_range_from_zone(struct zone *zone,
>>>>>                          unsigned long start_pfn,
>>>>>                          unsigned long nr_pages)
>>>>> @@ -551,6 +577,7 @@ void remove_pfn_range_from_zone(struct zone 
>>>>> *zone,
>>>>>        const unsigned long end_pfn = start_pfn + nr_pages;
>>>>>        struct pglist_data *pgdat = zone->zone_pgdat;
>>>>>        unsigned long pfn, cur_nr_pages;
>>>>> +    enum zone_contiguous_state contiguous_state =
>>>>> CONTIGUOUS_UNDETERMINED;
>>>>>          /* Poison struct pages because they are now uninitialized
>>>>> again. */
>>>>>        for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
>>>>> @@ -571,12 +598,13 @@ void remove_pfn_range_from_zone(struct zone 
>>>>> *zone,
>>>>>        if (zone_is_zone_device(zone))
>>>>>            return;
>>>>>    -    clear_zone_contiguous(zone);
>>>>> +    contiguous_state = clear_zone_contiguous_for_shrinking(
>>>>> +                zone, start_pfn, nr_pages);
>>>>
>>>> Reading this again, I wonder whether it would be nicer to have
>>>> something like:
>>>>
>>>> new_contig_state = zone_contig_state_after_shrinking();
>>>> clear_zone_contiguous(zone);
>>>>
>>>> or sth like that. Similar for the growing case.
>>>>
>>>
>>> In both shrinking and growing case, separate the clear_zone_contiguous
>>> from the logic of zone state check, right?
>>
>> Yes, I think that makes it look a bit nicer.
>>
>
> Thanks for the confirmation David. Noted and will do. Thanks.
>
>
>
>

