Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D00F3D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1956B0088; Thu, 18 Dec 2025 20:31:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C2D6B0089; Thu, 18 Dec 2025 20:31:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D99A6B008A; Thu, 18 Dec 2025 20:31:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB1E06B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:31:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB4E91320A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:31:44 +0000 (UTC)
X-FDA: 84234493728.09.0F825CD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf14.hostedemail.com (Postfix) with ESMTP id 80EED100008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:31:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cmY+bKas;
	spf=pass (imf14.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766107901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VP6tgqA6LaVUDQqypRsewliNKGfu5DcBHaXXZMijYCk=;
	b=X+8xElZyufkdIQO435X/BCysfKhTiYA5BYkytr8cBk7wSS4GdD2GTQpqN3doXqSQcQ4J5u
	ckbsN/jptUtpwZMrARPn1w+Aw9QXFCTmorTay95LeSjeP+ctWm9+2B59DNDdyvcJN0S0Yv
	JgoGIXwyj0oANmK4ZemHuZrq7aBVjuo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cmY+bKas;
	spf=pass (imf14.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766107901; a=rsa-sha256;
	cv=fail;
	b=IL2lYT6s83HpoM5MdcSEnGM8xkaVxWL0onrZQiabmXdphnNlUoHBbrmEk6ClIloWN8H//Z
	F9MCf4KKCPvOTnXEKIQ1bZ94VNFVmndfiy6IdKB7cg0839PlFRjOwjJCf+vnB2dgDcz9wq
	TxjOrRI1HCYyenD46vNafUAwdfK/Q9w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766107901; x=1797643901;
  h=message-id:date:subject:from:to:references:cc:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6/uZs8wjM0e7vvTYsI4a2uWfSopmWo5igvtxKuwaqWw=;
  b=cmY+bKasSDqBI8AVdUrMnojRZLOW4DFCjwrBhbxhHavPJ8Kq+5SMWY3d
   YaJdTH/XheivcxcbAW4+lB8veMnSG62B8NkWCzWnf+zWcju2iqhIjJVK0
   rt4/DSKnitrIYGwc5TISZLwaBgCA09cqX6Jx8D0Nx9/t53n2OMojKf4qy
   Pw9/xLpn1HIq8PIGaRa3Qd/0zBj9zzaZ3QnT/oWw8+vWDIBWt6n+1v8/X
   gFZoW0B3vNB5VRhe6Gn+8eVf80W+ZJHr5F839xxcnVQLw5DiBAePjFdGF
   N51oQL142Gu7HjCzbVWQDJrzeMc1Xxg8KRueR8orgzh24jdbHMWmaUvKo
   g==;
X-CSE-ConnectionGUID: uGVtKdKwRHmEXXCIev2DDg==
X-CSE-MsgGUID: TfYTrPJdSt69spvL/GBvkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="67948168"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="67948168"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 17:31:39 -0800
X-CSE-ConnectionGUID: Qnnt0JM6T2y+7spCn5VNTA==
X-CSE-MsgGUID: tOA+QOx1T02opzU7QlZJ8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="202910838"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 17:31:39 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 17:31:38 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 18 Dec 2025 17:31:38 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.20) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 17:31:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SDWjOi5+s6cOfZKuI1H9jUQrwz9gQInhWO7IpKhizrOFrBQvm6sbpXgYvRwAqG/gIGHuibpLi8TsiNgcf9JshrLHCTulkrZfTIadKecObWpVIFyeZdryyRRCf0kueHSazjIqJZPjFw79PySQ4i7OlSLCGeaH3AAOmQBBC0/xncOXGFu9cgTs3eupNA4kKTqBnG+vk17jL0BE8f8WGc2Vvc6xPNdF77oM3vYJyjHdoJNf2SXZsq6CNSzSMDlKhDL/5HLsenT+iFvpsuAF24mg3cvc87q5WSqkqh5z/ijlmQg79KI1feSOKEFTAAAcCOnvMRpi8FO9rX1fpxjqwuHcyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VP6tgqA6LaVUDQqypRsewliNKGfu5DcBHaXXZMijYCk=;
 b=IWe6glPwOmpowWEK+BmnGY4wO3ECOgQy3b5dJroSk5T1++vcRLQoiYN21CEwmHr4lpa/4B5VjqXTbhtLu9aaxy14ZD3Wlyx6Koc8N820nDMEUfUeStEpXwjjlXZ721eUhDEmauCVRHw1whiHKB3tHxVjC0sT2ysUSkwVPgui/v7Ltq8BVbrqHzGi9u7RWfVm8yfq8L2BaunRiMI/HbVul0ScUgUmyaXMpl5GSymsSz8nzAEeCLjiOFTTzdycmQ6vX5dYgxLvDyItrlGDIatuYikJmqB/u3fqPNsT87r91eFIL+nbK/EB2nq1W2vMeMBC5j+Z4R8NzzVThCH1heds3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by PH0PR11MB5029.namprd11.prod.outlook.com (2603:10b6:510:30::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 01:31:31 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 01:31:31 +0000
Message-ID: <127930dd-3dd8-4b18-9bdd-9b8dea9496ae@intel.com>
Date: Fri, 19 Dec 2025 09:31:22 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
From: "Li, Tianyou" <tianyou.li@intel.com>
To: Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>, Mike Rapoport <rppt@kernel.org>
References: <20251208152544.1150732-1-tianyou.li@intel.com>
 <20251208152544.1150732-2-tianyou.li@intel.com>
 <aTpRoUt0WvEULeKE@localhost.localdomain>
 <4a81dd12-1bba-4a89-821b-7a12edc02e04@intel.com>
Content-Language: en-US
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4a81dd12-1bba-4a89-821b-7a12edc02e04@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG3P274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::30)
 To MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|PH0PR11MB5029:EE_
X-MS-Office365-Filtering-Correlation-Id: e6c8155a-90a3-42e7-12ce-08de3e9e5662
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M0hWOFJraDUvb0liYnp3MDB1bUFYQUNYcjR0SnJOTnB1TXFDSEgxYnZOdHBw?=
 =?utf-8?B?bDRibllEVGI3SmlpbDFwUDhpd2t5WVcyU2RGWjMra0lvK0NFRkVpQlk4dlNh?=
 =?utf-8?B?OU9vcmhlVDk3ZkJhcGhWMWtqaUl6NnUyNkhVZFFWb05vUVdhRGhqaFNTRG5P?=
 =?utf-8?B?QmYyYkVRS0w3eVdPN3lJWEVBL0ozaDQ5K0kyUjhtRnkxUGtNaVZDT25qRGdC?=
 =?utf-8?B?dVV3U256ZnJTMFd1VFBVcEl4WlZiQkxyWWVZbVV1TFlUeWx6RXdqVHRuRnAr?=
 =?utf-8?B?YTVreFY4Y00rc2g5a3hoMlNFZlBjRllHYmtzME5mL2RyQ0Y5M1J0UitIeVZ3?=
 =?utf-8?B?bktKbXhpYi9aNDRCT1lXekY0SXdDRDZTK1Z3MGt1Vng5cVdOeVM4eFhqWGVP?=
 =?utf-8?B?b2F0QjMzcHpILy9ISVlkN3V1V2RnbTV2Q3IvUnQ2d0hRUmlpQ29kU0pzcHgw?=
 =?utf-8?B?TjA4Mk1aNUwyR2R2Z0h2NFEybkdrNWgrQU8wQi9wSllXODA0WFVCa3A5UEt2?=
 =?utf-8?B?WmF0MFk3ekRmK0tSdkRsajl4Rk84SGtnNkRZWm1nUzV0aWpCWm4rN0c5RU8r?=
 =?utf-8?B?c3ZKRVRWREc4cmxHTWxtK3RWWkhQR3hoL2F1ZTVtUFBiMVp4UGw0cUl4UVV4?=
 =?utf-8?B?N1BkbkxoR2l2d2VZRFkva292YXNUNmg1bFlydVFtTHZLSitLMHZkZ25lRDJ2?=
 =?utf-8?B?blpPK3RqaXhmMUdJOWZDdzRCcllFWE1xZTkxaDB4Z0lrNlZUcUloSGgvdGxR?=
 =?utf-8?B?VncxYVZTc3lkUG1UbnBSckNEVUdIako2R0JtZEFDTWtOUzlkMWcxQVV1aWth?=
 =?utf-8?B?czZySExYRUxPNGVJOFRRbWJDdlRGMEJmUXhDcVBjczNDcEdrZ1FweXlBekov?=
 =?utf-8?B?aWVlN3N1KytZMmpXTTR5RE95VXpIR3d5Mi96L0RMVjF3UjkvSWY1MUs3MFNL?=
 =?utf-8?B?Rm1SVTJnR1lPVEF6Wm1ZMVp5dG40WlgxYjlSaVVuZ05yQzFHU3dhUTEvWUox?=
 =?utf-8?B?bzJ6Rk5kWm4yekpNY05Jd3o1UlQwTnIvWVJtK1FTNkRCbENIT2lkSzdxNjhN?=
 =?utf-8?B?ejlqRGlWMzU2SUl5bFN3VXp0RGI0Y3VrOGN5YmhXaUplTVBjSXU5UnIxbkZV?=
 =?utf-8?B?a1YxdmNtY29Cd3ZrSG9ZUjRVZGs1ZkdnaUtmTzlTTW13elJ6Ky93R2l4NE12?=
 =?utf-8?B?VER4d1YzUDJ2dUMrTDlnTkVMUXN6S3Q4a0lYMXc0eGNTMnYvajNySWUyWW5K?=
 =?utf-8?B?d0hVOUhTc1k3R28rNWJGSDFrOHlkTzB3QWJBeWg4VVhENVNOQjQ1TUZiWVRa?=
 =?utf-8?B?eVJiOG02YzFlc2lkWXNma25PRitTYk5yM291aDNzNTVjTGhJUXptK255VDYz?=
 =?utf-8?B?elJVdmZnejBxZlpWM2s2N0hRcnRhazRoYXJPY1diakxpOXFxdkMzU0wweFhW?=
 =?utf-8?B?RXBHeXVhbkRJK3ZxRGlYV2JWTnJsL0lPUkloakl1OHpzTWg5YlhYRkczN2s0?=
 =?utf-8?B?aFFyWWRuL1AyeWFMWUVXZFM0ZkNtdHl6bWRCTVZrT1l2bjh5UDR6SW96dG1h?=
 =?utf-8?B?VWNYdGo1TWJOaFpQbnRXSFRpMWtmV0YxSnV0U1YwMTQ1WE91dDQvZndqc0xv?=
 =?utf-8?B?aUNrQ2VJanRXTUlFTUdTYjZ2WnB3SGxvZk10Mll1YkJqdUdvaGpRSEV2ZTZX?=
 =?utf-8?B?M3NyeUFxOVF5VVZyamZpL0xwV25Nc2UwaVB3M1VsRS9RSUNOVXZlZ0dMV3pK?=
 =?utf-8?B?TGdLd2ZGaWxaWGJpTzNzWThlbGpKM0Zub0svK0hQbVVadHpLT3h4TUJ1YkpT?=
 =?utf-8?B?Unl5aENENnZFYUtHMWw5dUk3WTZRZmtEZ0RzMGJ1SjNWVkZhTkR0cjA0anRO?=
 =?utf-8?B?V09XcitOblppOGN3N3Z4SnBwSldTNHpPdlBXcXZFVzdCdjBoVk95TnBObWFN?=
 =?utf-8?Q?7Ia25XgPAnFAMLWeAwUpcxm/v4DcP5dh?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkQxOU9kaEs2N3hjMWN0RE9MYkF0cXI1N2hEY1FXa2xNY3BPeWdta29RenFC?=
 =?utf-8?B?QlRGazc5cjVtL3JrSXF6dFNnckJDaDBpcEc4cURqUGR1SStSUjlBWVJKVUl0?=
 =?utf-8?B?VEc4NWJNeWJCOUVidHJ2WVRwcmF0R1hRNUFSNFowMmdiUzhMOGRzTHJVVndP?=
 =?utf-8?B?dXRLL3Z5SnJLSGZOMXFuUkc5UmsweExaL2dpaVNnVXJyRjZBUURlcmVpK2NZ?=
 =?utf-8?B?Mng3dDdlakx4NTlMMkpWRzBYQmJBWlpzbU1oSmRjWGNFWFJrdUwzSUZpY0VT?=
 =?utf-8?B?TlJXTytzVVJWa0dZNERhdmo0eVZ1MDFCVkVzQTFsNXhiVjV6VGdjbm92NmRn?=
 =?utf-8?B?b1g3M0VtWHRuaEZzVVBoZUhKTURQZkxtblVVQjJvQWlsNi9nL3hCQmwyTldi?=
 =?utf-8?B?WEdRL3RXcVRDT3ZrcTNIalQxcG53eFRKdWd4SWNSS2pIQVdPckd5TTI2TmEx?=
 =?utf-8?B?ZXhhRElrNGJXdCtQaUN2cGpPbTJYR3BnQTZ3THN3MEluN0h1TmhwYnNpVHZL?=
 =?utf-8?B?WlZVTlJKWGhHd2VJaDVtZk9XaXI0Z0tHeUxIRjFiY1hzMEM5QkVucE5LdE9z?=
 =?utf-8?B?MmFnb0I0ZEFTWDQ2WjVOd0FqTU9pVmpDYkhCZ3JsU2JRekRyWmFUY09ObTlC?=
 =?utf-8?B?TmhpVjFoM3crUG9IZzRtZ3dQSmc3eXMwbVNuNTlMbFIvUE1tdkNaZTVrRW95?=
 =?utf-8?B?Y0N3RmV3RXhyTkVYV0tLeXU4bUpVR2hYVWtKUTlQZ0hZZ0FVMmNvckppLzRI?=
 =?utf-8?B?UkNZNnhWSzJkdXVrOFdJWE8yeWh3TG5aVUNsbFdKaFFUQWRsdFNxVmlHRy90?=
 =?utf-8?B?WHNsWWk5eU1iTmE1aG5QT0U5SE9tamNuajBZL0dWM3hFRnRJZGNMZzNPdFlz?=
 =?utf-8?B?ZFZJTlVZaitGOWN3eWFyNmVFU3p6Q09oN0tnUzRSNFRwYllieHE4MmpMMDJ6?=
 =?utf-8?B?NXVrZ0lvNnMyS3V5TWxVQ3Y0MytxZXV5YVZkRlFqZUdlMmpudW9xU2tja2Fw?=
 =?utf-8?B?T0l6Z1YxVytYZXBKNGtEVnFmQUI1VDdvTW5LQ2ZOU0NqSHp0VXNwN2dMT25o?=
 =?utf-8?B?YUtQQnNGNGc2ZmV5OU53eXAyME1uWllGeGlvK3REM3g3ZXJydnluS3FZTHE4?=
 =?utf-8?B?czFoUThmV2VuNnp4VEdBRDY1eXNFeVprMjdmMkY2TW9PaC9sRjBoVHFEVmgv?=
 =?utf-8?B?a3VSRTJic1RIYjRhWXcydFdRUUk2UUhRWnlMMU12UXRNb1pxWTlWMmorQmJV?=
 =?utf-8?B?b0llVHVxUmJOTExkdEdkUDhKMThBTU1GMGlSdlJUYUUzQ0dUWGhTTXFsRWFr?=
 =?utf-8?B?MERCWnhaK281dTB1ZWE0UXd6NFFEMkIvcWM1TnFoKzJIaDBGMk9tcXl2aUE4?=
 =?utf-8?B?K3FHWEdlUkkweUFQdDZZZWIxNjdXUFJsTlZrN0d5aHhzZStYNXdGWDNwV0ZU?=
 =?utf-8?B?VWtyVzZuT3FqTXhGUjEvOTdwTEw2N2hocDJpWHd1dTdZRFJubS9zQ21ldTZz?=
 =?utf-8?B?RTZLckk4WkdiTldlU1phNHZKNXpBbEVjQzRPVDFsMm05RDBFYWFqNXVtNHgy?=
 =?utf-8?B?Z3pTaksySlhndmhVNmpBOUhWY1lwelVYOEhtUDhVcmZYL1h0aXBPZmxnS1BZ?=
 =?utf-8?B?R29qSGhvbWtqUDZzSXM4V1lISUxiYWJ1OWo2NkV1SmlvVkJKWDZOdG1jc0NE?=
 =?utf-8?B?YWl4eFU3bk9peW51NGhWdDZwR1NBZW04Z1ovSlZIRkZnQUxFSXZYRzJNL0dU?=
 =?utf-8?B?bFRiNU1vOWpNNU5wTkxqaDl2TXJFZUgxK0FDV284Ykt3a0hXSnZCUEJSZkZI?=
 =?utf-8?B?bTJQZkwyYnI1N3FXdmNHWU5DU0xNSmxGN0NWV3EzL24wZk9ra0U4MENVRll4?=
 =?utf-8?B?RFZYUEJzNFo1TndaaThBWE83ZW1MTXZLMFg2NjJUWVY2VzFJV1c1NCtuT29D?=
 =?utf-8?B?UE50QjRpNW5odjR5VzBUaEZDQnZvdHN4QktsanYycFBEeDBlZ3RRWmVhZzUv?=
 =?utf-8?B?UEZkR3lzc0gwRU5HRXN0OSsxT0g0ZTkxVEJTNVMzQnRzMjdSWmt4bDRWNzRs?=
 =?utf-8?B?SFA1MDhpS1JuSTBWM3p4Zi8wbW44emxyaExUanV1MjMrK09JUEJsaDZqN3dE?=
 =?utf-8?Q?G7xusRdAZfIZ8agFz7/AESfjR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c8155a-90a3-42e7-12ce-08de3e9e5662
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 01:31:31.2093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qMeVY6pRxTsK+L3VfE668RlpgKC+vTx8gkdcObOVGCxEMl6aB0Gm5ErcT4A95kr9kkqlc2Kz3oidgljbQ2I8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5029
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam02
X-Stat-Signature: 3xrixcf7z79c9gyb1ezncu49kessh7py
X-Rspam-User: 
X-Rspamd-Queue-Id: 80EED100008
X-HE-Tag: 1766107900-514623
X-HE-Meta: U2FsdGVkX18DZB7Q+Fs5pVj2c0ysT34n+8Ez6VbUql76R/YwnWG/vQElRR/ih6KQHOydcqZj2Bd7zQwcblAOXzrMAhROkrM7Xgbh103PLxoh+d9UZv9bv1oTPa4ekuob3M4YWjqoT55E+pBiEqv5IqQLh2czmNb+Fng+xpE2l9N1vK7sTTiy8t6QGaTg0mtkXs/0UErolLu/wYU17BsgUyvU1aJ0Zb51CIY+AT20AX3ooislrvUZ+zs2NM/4LADY+vZd5qxl2rc+jcmysHOoS9BvyxDlf7nGyOCNZzkGBx/F/hFADv/RXgPW+mSE0joQ0UBBfD04oJIWjECKpeAld3knnvMbnbWTFywY/OZn+jFBFa9MjHSYiy5nVMGP39Z26U11tZKLgie88qtCSnsFp9eIem2pc/QAGytH2khXe2IWVF+H30zZIRTyh+zIZBfbxNvcW2FgMr7V3TIJsGiEAzt5eKXCdYwh+alGHaTpYe8SwPyiW+f7PQZnyA65rXVFDNVHbuVlVeTXzHHrSPB1ZL/A3PDR/rzFDRNoBVK5JafkhC/DATbD2XtEPlt3Cqlfy+pVgGU4kK5+kE5zGAVriDAKq5i2q2SS+fKJuh8ymXlopXGVQUYSOT1GmevL2UekVHeudEFtaM2VvQgFKMhUA/w76W2jdRe52HnGU/hxqS7rJnuolYMXhXwHRT46SvhkqlgdLWQ/z3VvT9ONaYOfOmH6w62rTukeu0qrDICN4nLXjDA+HEt2BPqCGgWVkXsHmX/lu/oWlZlx6N/u0r4mUpzjag9TKqlDlf3bm7GSz1pFtKR0sxfUie2n/1gkfUPOYeYbbnQPN9+x+A9hb+pKndNljuDJsqygjZvLKjAmlt0lPFzig68OJsiwNUQ29O0CESMWYPDlqX6oxrB2E1lcwMw+vYwMJTqDQEWE4HvRkJ8lZ+DDMFc0yqYQ4x4qE6qetWj9CKYVjeU/dmVecKI
 S7xXDVs2
 VcsSYCAZlN1et71JiYZHGvGcG1CIN2wjFIqBpTEgkWZftJEJBFl33KwIRSPTnJRqos9u3YeUY8cHPXrvP7joTSbM7ZzkuGK9z3/s3WnDjoGP+u6OgSNGgeqjo0kRq/m0EkfJ8J3uuadeSkTsDY61n6GHka8mRs9/+EXfjF/N6Snd2mjx/BKzY0w6RULtHu9sTjM5GYu5rfTO8vQsFozPb33+TVAfbL9GKVMNzU9VjULY/7ReYGEoTnr5/oCRwD3Fhk6LK8ezqBEcVZW6tZ+VNx6v6HkVucqyuBZ3Q8XPx2crYi3IUtVtJz7UGHmmc1OR9G//IBvr+Q9ZVx5AJGIqldpbEhM9iQ/EbiAd93KIqmjsMBwgtCPXYD81prabnmXKNpA5DZm906fpwrS0oXdUNwvv6CznX5F+PrWzoVp/DNj2EeY07uCKrgBCUaPRq5f0F8Mjqoj3Xo19v6swiggIrcfxWkmfU9AnfUG2TGTvwoH5jvg6nPA8iytA7DLuBGzGle65CgL0rqzfwSgCXRuHIIayc3qW6J4Pprmwfamcj+zEgB/mAT/Po6gjb1BL7JSPXlwzGnmq0b+sQ9/YypcRO9NRJlAquKJgu5z1Jqnup3WXrP6d2/skvhTxbCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you all for your time and efforts. We have submitted the patch v6, 
tested through the last weekend. Any comments or suggestions are 
welcomed. Appreciated.


Regards,

Tianyou


On 12/12/2025 1:27 PM, Li, Tianyou wrote:
>
> On 12/11/2025 1:07 PM, Oscar Salvador wrote:
>> On Mon, Dec 08, 2025 at 11:25:43PM +0800, Tianyou Li wrote:
>>> When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it 
>>> will
>>> update the zone->contiguous by checking the new zone's pfn range 
>>> from the
>>> beginning to the end, regardless the previous state of the old zone. 
>>> When
>>> the zone's pfn range is large, the cost of traversing the pfn range to
>>> update the zone->contiguous could be significant.
>>>
>>> Add fast paths to quickly detect cases where zone is definitely not
>>> contiguous without scanning the new zone. The cases are: when the 
>>> new range
>>> did not overlap with previous range, the contiguous should be false; 
>>> if the
>>> new range adjacent with the previous range, just need to check the new
>>> range; if the new added pages could not fill the hole of previous 
>>> zone, the
>>> contiguous should be false.
>>>
>>> The following test cases of memory hotplug for a VM [1], tested in the
>>> environment [2], show that this optimization can significantly 
>>> reduce the
>>> memory hotplug time [3].
>>>
>>> +----------------+------+---------------+--------------+----------------+ 
>>>
>>> |                | Size | Time (before) | Time (after) | Time 
>>> Reduction |
>>> | +------+---------------+--------------+----------------+
>>> | Plug Memory    | 256G |      10s      |      2s      | 80%      |
>>> | +------+---------------+--------------+----------------+
>>> |                | 512G |      33s      |      6s      | 81%      |
>>> +----------------+------+---------------+--------------+----------------+ 
>>>
>>>
>>> +----------------+------+---------------+--------------+----------------+ 
>>>
>>> |                | Size | Time (before) | Time (after) | Time 
>>> Reduction |
>>> | +------+---------------+--------------+----------------+
>>> | Unplug Memory  | 256G |      10s      |      2s      | 80%      |
>>> | +------+---------------+--------------+----------------+
>>> |                | 512G |      34s      |      6s      | 82%      |
>>> +----------------+------+---------------+--------------+----------------+ 
>>>
>>>
>>> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>>>      object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>>>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>>      qom-set vmem1 requested-size 256G/512G (Plug Memory)
>>>      qom-set vmem1 requested-size 0G (Unplug Memory)
>>>
>>> [2] Hardware     : Intel Icelake server
>>>      Guest Kernel : v6.18-rc2
>>>      Qemu         : v9.0.0
>>>
>>>      Launch VM    :
>>>      qemu-system-x86_64 -accel kvm -cpu host \
>>>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>>>      -drive file=./seed.img,format=raw,if=virtio \
>>>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>>>      -m 2G,slots=10,maxmem=2052472M \
>>>      -device 
>>> pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>>>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>>>      -nographic -machine q35 \
>>>      -nic user,hostfwd=tcp::3000-:22
>>>
>>>      Guest kernel auto-onlines newly added memory blocks:
>>>      echo online > /sys/devices/system/memory/auto_online_blocks
>>>
>>> [3] The time from typing the QEMU commands in [1] to when the output of
>>>      'grep MemTotal /proc/meminfo' on Guest reflects that all 
>>> hotplugged
>>>      memory is recognized.
>>>
>>> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>>> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>>> Tested-by: Yuan Liu <yuan1.liu@intel.com>
>>> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
>>> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>>> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
>>> Reviewed-by: Pan Deng <pan.deng@intel.com>
>>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>>> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
>>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>> Overall this looks good to me, thanks Tianyou Li for working on this.
>> Just some minor comments below:
>
>
> Very appreciated Oscar for your time to review the patch! Yuan and I 
> will work on the patch v6 to address all your comments/suggestions.
>
> We will test the patch v6 across the weekend. If any other comments 
> during those days, we will need more days probably. Thanks.
>
>
>>> ---
>>>   mm/internal.h       |  8 +++++-
>>>   mm/memory_hotplug.c | 64 
>>> ++++++++++++++++++++++++++++++++++++++++++---
>>>   mm/mm_init.c        | 13 +++++++--
>>>   3 files changed, 79 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/mm/internal.h b/mm/internal.h
>>> index 1561fc2ff5b8..1b5bba6526d4 100644
>>> --- a/mm/internal.h
>>> +++ b/mm/internal.h
>>> @@ -730,7 +730,13 @@ static inline struct page 
>>> *pageblock_pfn_to_page(unsigned long start_pfn,
>>>       return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>>>   }
>>>   -void set_zone_contiguous(struct zone *zone);
>>> +enum zone_contig_state {
>>> +    ZONE_CONTIG_YES,
>>> +    ZONE_CONTIG_NO,
>>> +    ZONE_CONTIG_MAYBE,
>>> +};
>>> +
>>> +void set_zone_contiguous(struct zone *zone, enum zone_contig_state 
>>> state);
>>>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>>                  unsigned long nr_pages);
>>>   diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>> index 0be83039c3b5..d711f6e2c87f 100644
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -544,6 +544,28 @@ static void update_pgdat_span(struct 
>>> pglist_data *pgdat)
>>>       pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
>>>   }
>>>   +static enum zone_contig_state __meminit 
>>> zone_contig_state_after_shrinking(
>>> +        struct zone *zone, unsigned long start_pfn, unsigned long 
>>> nr_pages)
>> Why do we need the __meminit? These functions are only used from 
>> memory-hotplug
>> code so we should not need it?
>
>
> Got it. Will remove the __meminit in patch v6.
>
>
>>> +{
>>> +    const unsigned long end_pfn = start_pfn + nr_pages;
>>> +
>>> +    /*
>>> +     * If the removed pfn range inside the original zone span, the 
>>> contiguous
>>> +     * property is surely false.
>>> +     */
>>> +    if (start_pfn > zone->zone_start_pfn && end_pfn < 
>>> zone_end_pfn(zone))
>>> +        return ZONE_CONTIG_NO;
>>> +
>>> +    /* If the removed pfn range is at the beginning or end of the
>>> +     * original zone span, the contiguous property is preserved when
>>> +     * the original zone is contiguous.
>>> +     */
>>> +    if (start_pfn == zone->zone_start_pfn || end_pfn == 
>>> zone_end_pfn(zone))
>>> +        return zone->contiguous ? ZONE_CONTIG_YES : ZONE_CONTIG_MAYBE;
>>> +
>>> +    return ZONE_CONTIG_MAYBE;
>>> +}
>>> +
>>>   void remove_pfn_range_from_zone(struct zone *zone,
>>>                         unsigned long start_pfn,
>>>                         unsigned long nr_pages)
>>> @@ -551,6 +573,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>>       const unsigned long end_pfn = start_pfn + nr_pages;
>>>       struct pglist_data *pgdat = zone->zone_pgdat;
>>>       unsigned long pfn, cur_nr_pages;
>>> +    enum zone_contig_state contiguous_state = ZONE_CONTIG_MAYBE;
>> I think that new_contiguous_state is clearer, but I do not have a strong
>> opinion here.
>
>
> Will do in the patch v6.
>
>
>>>       /* Poison struct pages because they are now uninitialized 
>>> again. */
>>>       for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
>>> @@ -571,12 +594,13 @@ void remove_pfn_range_from_zone(struct zone 
>>> *zone,
>>>       if (zone_is_zone_device(zone))
>>>           return;
>>>   +    contiguous_state = zone_contig_state_after_shrinking(zone, 
>>> start_pfn, nr_pages);
>>>       clear_zone_contiguous(zone);
>>>         shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>>>       update_pgdat_span(pgdat);
>>>   -    set_zone_contiguous(zone);
>>> +    set_zone_contiguous(zone, contiguous_state);
>>>   }
>> ...
>>> @@ -752,7 +809,8 @@ void move_pfn_range_to_zone(struct zone *zone, 
>>> unsigned long start_pfn,
>>>   {
>>>       struct pglist_data *pgdat = zone->zone_pgdat;
>>>       int nid = pgdat->node_id;
>>> -
>>> +    const enum zone_contig_state contiguous_state =
>>> +        zone_contig_state_after_growing(zone, start_pfn, nr_pages);
>> Same comment from remove_pfn_range_from_zone.
>
>
> Will do in the patch v6.
>
>
>>>       clear_zone_contiguous(zone);
>>>         if (zone_is_empty(zone))
>>> @@ -783,7 +841,7 @@ void move_pfn_range_to_zone(struct zone *zone, 
>>> unsigned long start_pfn,
>>>                MEMINIT_HOTPLUG, altmap, migratetype,
>>>                isolate_pageblock);
>>>   -    set_zone_contiguous(zone);
>>> +    set_zone_contiguous(zone, contiguous_state);
>>>   }
>>>     struct auto_movable_stats {
>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>> index 7712d887b696..e296bd9fac9e 100644
>>> --- a/mm/mm_init.c
>>> +++ b/mm/mm_init.c
>>> @@ -2263,11 +2263,19 @@ void __init init_cma_pageblock(struct page 
>>> *page)
>>>   }
>>>   #endif
>>>   -void set_zone_contiguous(struct zone *zone)
>>> +void set_zone_contiguous(struct zone *zone, enum zone_contig_state 
>>> state)
>>>   {
>>>       unsigned long block_start_pfn = zone->zone_start_pfn;
>>>       unsigned long block_end_pfn;
>>>   +    if (state == ZONE_CONTIG_YES) {
>>> +        zone->contiguous = true;
>>> +        return;
>>> +    }
>>> +
>>> +    if (state == ZONE_CONTIG_NO)
>>> +        return;
>>> +
>>>       block_end_pfn = pageblock_end_pfn(block_start_pfn);
>>>       for (; block_start_pfn < zone_end_pfn(zone);
>>>               block_start_pfn = block_end_pfn,
>>> @@ -2283,6 +2291,7 @@ void set_zone_contiguous(struct zone *zone)
>>>         /* We confirm that there is no hole */
>>>       zone->contiguous = true;
>>> +
>> Not needed?
>
>
> My mistake, thanks. Will do in the patch v6.
>
>
> Regards,
>
> Tianyou
>
>
>>>   }
>>
>
>

