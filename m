Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ED5AD78786
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 14:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9546B0088; Fri, 19 Dec 2025 09:33:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 797486B0089; Fri, 19 Dec 2025 09:33:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6243B6B008A; Fri, 19 Dec 2025 09:33:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 504226B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:33:35 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B11613007
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:33:35 +0000 (UTC)
X-FDA: 84236463990.02.BAB5E9F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf27.hostedemail.com (Postfix) with ESMTP id DB46A4000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:33:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hhn73EVK;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766154811; a=rsa-sha256;
	cv=fail;
	b=fK4VeCsSpOnDt60zbX4m98d7yv6p99zCx1hWnyRz6Zv6dHxP1Waq1ieven1CJmiZpXFPVz
	5+FPfLi6R3RRyhexc8SVUt95fCM5MRrsjsqUNSBNkzzGZeu1kTsSxnQGRldZiZ9uProhhW
	pTLVlDFl9uyx64VBXBlkGbjDRdC3USM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hhn73EVK;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766154811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9x/yHYmF3dV2usx5u0PS/eNX7mygD4mEIWs2atFTls=;
	b=NnWMbPo2fXRtO3rdEnWRO5gqX7AT1oRlBQ+hQ83+6qFzS0irfRSlt5edGDbwN5SQK8aIlf
	QpmfX39OySvnhUAw/GD0ZBjNCq2miJH+0MkaGo50yH75aThyAZPjuMy/SGrGFjlSbWIfOn
	hsXx1C2DmnRzQ0V7+mnwnBJjyCM/ioE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766154811; x=1797690811;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oTErsHRanj2QgdQTIWb6l+aDRGEC9J7T9FHPzlVoYRc=;
  b=hhn73EVKD4KRIG6TwcDcwMqR43SMPJ/OJ5OzwJ/Mc9CKewoj+VboQzNV
   nQ9frEJ2tsSaJPDelYRwxGf1EiJazG3OS1UKP/UqLNRliZfn7/aEeoQBE
   hjE7PDZLl4YyyWRNymSmsBjvsMPeECJ6XTyuMLLgtJ/UIcTOHtHyfkj87
   yvfPHkqz9B58O6yQ0bolKmcr0hM1pPEdWFLYEJ/P35pZEWSQ+dVPq8I5h
   17s/5QdDUhRuGRv+3kk7lHOstjvnMecMH0eeJ9a61698mSs8rjA+9dUdH
   6w9Tsly1EBztvuIPR+i7qoO+l/iWVd+knRXC9yNTvNJawfWmiQ5QoJeot
   Q==;
X-CSE-ConnectionGUID: V5+etSNyRRqFvdN5O7yAGQ==
X-CSE-MsgGUID: +5vTbGSfRGilz4rMnUYQHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="71744721"
X-IronPort-AV: E=Sophos;i="6.21,161,1763452800"; 
   d="scan'208";a="71744721"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 06:33:30 -0800
X-CSE-ConnectionGUID: qNqHsq8aQ460UWiB4WyaFw==
X-CSE-MsgGUID: KS7lQQ2SRdiwDqYadahzvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,161,1763452800"; 
   d="scan'208";a="198935985"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 06:33:28 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 06:33:27 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 19 Dec 2025 06:33:27 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.8) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 06:33:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z5UZUWgII/9nXu40VikWTSXNOGyw8g/U45j8q2lsHiO/kIHXPunsY79VBgKLis54zZalH7BUD4Dxp/fJpdHKRgtta2sNWm/JcHbLlwo27GUWetOdkgdRmrKn1kDBpWM5ighBFZTHbMZmyiyBs1p0bnFZF3wiDVGbUjAhbtdI72RtnTdsDfU9wnT6q4ba7XtR/XqBVn1cFAKz31eyMOM1fkRP9hIi30SDU1D6dgsNNOEHCltnalZWoWT2HUDytoMHeDy9o2wSb8BkXAtn9QsKg0je3Q1xcug9YZD4AYKLo3CYpmxffRQv+bEVxunGx+NFrnP+kHEbON5zv/1p9GqQHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9x/yHYmF3dV2usx5u0PS/eNX7mygD4mEIWs2atFTls=;
 b=PsPns6fpO4wMGdbcGzUaS3eCgnZb0igUbfgxjxLzi5YFgMPSSCVjgKX7I3GIr5MxksdmYmcG273xS0oFnT6RK/QDEL5Ko1Ad4dBiGRgBhjgGyG1kAtNt0Px8YDdlJnlcwmtOWLybe7VVmypVW/AyC3KF4zTd5J0fq64KMd0IhOFJkb/27XflEW5aLadTrDKpLpiBeI+gzcl+Rmvz8iirLYXiyn89FSRpZWTHbtxo8lgT/7eyICD34s4gpcT8tr5InUACHBJ9Tm3PGJC8Nrj99x29vMLMtoMW2IOtTczXPeX2aKlJ5rLsD/KJDY8HRx8Lt/touRB4rcQVzqc0WsjV1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by MN2PR11MB4648.namprd11.prod.outlook.com (2603:10b6:208:26f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 14:33:24 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 14:33:24 +0000
Message-ID: <ee63f7c4-0adc-46ec-8e14-277609af6243@intel.com>
Date: Fri, 19 Dec 2025 22:33:15 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] mm/memory hotplug: fix zone->contiguous always
 false when hotplug
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, <linux-mm@kvack.org>, Yong Hu
	<yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu
	<yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo
	<qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>, Pan Deng
	<pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	<linux-kernel@vger.kernel.org>
References: <20251215130437.3914342-1-tianyou.li@intel.com>
 <20251215130437.3914342-3-tianyou.li@intel.com> <aUUc9BNgUNguFS9K@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aUUc9BNgUNguFS9K@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:4:186::15) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|MN2PR11MB4648:EE_
X-MS-Office365-Filtering-Correlation-Id: e855ff3e-895c-4933-82ad-08de3f0b90f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L3ZMc3VCdTFPVHpUa0V1dkFaWXpZTlphMVlZc3YrT2UzZGpIbG9aMXZ3eFlP?=
 =?utf-8?B?SmNZMjBCZGx6VEMxdURBWFpGRjR3cUJJT3pKNUhLSm14SEgvUXZNaERkV2Yx?=
 =?utf-8?B?b3h3OUJ2ZVMrOWpMT2Z4dTJZWDUvMlExSnFMZng4WE9xVzNvT0daOHIwRm5u?=
 =?utf-8?B?M1UvRlViSXd1Zlp6QTdqRDlOQ2E4VVplL3ppNzlPeHRac1FqeVBHUmdDL2sw?=
 =?utf-8?B?cExEL09RUTNPUEpYcnUxdHRBKzNkbXY1OVBJeTNoQ05JSCsyNGxHY0I0c0NQ?=
 =?utf-8?B?VW5HQm9NN0FwcjY1WFhldEwvakxDYTFvdGpwbGlGMytLVGh6dkZ0UTdaMy91?=
 =?utf-8?B?NWZDS0IwRm4yd09PUkgwbU9YRHhBTHcrMUF6VmpZdEpQM1lHRmxPWTM0OW5R?=
 =?utf-8?B?MldnY2dtaTNVc2R6cGJWUDhHYmUxWWJqNmFEb0w1R3kxNEswb294MXpkQ1Vq?=
 =?utf-8?B?Y3pDVnRqdmRJM201WXJaeU5tRXFwZWt1K1AzVHBWcW5tMCt3VjZtZ2oybXlm?=
 =?utf-8?B?N1k2djZCV01mT29TZ0VIYkNCa1IzT1o1eVN6V25FL0FnWm1qeGlhV3ZKK2JC?=
 =?utf-8?B?b2hVYzJISWtUeGFxVUQ2cDh0UnJXSmJaNEFQR3puWmJYOE5HNktSM2dzaVpn?=
 =?utf-8?B?Y0VxL2FwOU5telNiZnpvL2FuZUsrYkFpOWJLZDc5UnFPTmpOMzE0UkQwWFlz?=
 =?utf-8?B?ejVaTDYxYnBwVzEzdHVmZzJNYm15dGFzemdmRVEwUGZ0WmNwM2ZiWjZTKzlP?=
 =?utf-8?B?TUtGa3FtQXl6WTRacytiUVZGN0xnZW4rZWxESTNqYzFwaThFY1lFNU5RM2xj?=
 =?utf-8?B?emhMdVNEUjI0Ym5xRk1xSnZtSk4rSGJ1dEVOM3pKT2MrTE5JQytKajU5WCtl?=
 =?utf-8?B?bWhDZm5zUHVSbS9ubHdiUk5VUm1rTG1iS1ZyT1VLZmczNkNZZ2xyTlUrUHc2?=
 =?utf-8?B?UWh4d2tIWUpaR0lYNG4wMHhORXo0UDQyUlRsNGFpUmlMajNJdFJmdk1jb0h3?=
 =?utf-8?B?NmxyaGJ1eU0vMG9STlRtei82UjFkYlFLTkJ4Y0lNN21RU0VTaTNOZkJ4bDc3?=
 =?utf-8?B?ZHFBT2lWZkJmWjl5NXpJNHpaZXdPaHdrV1dxUmtsaFlpTEE4UXdHL0FvZ09L?=
 =?utf-8?B?ZGJuNWNrbVo1SmREQlZWd0VGTGNZcnN3MlI2K0l0bTg0bHRnYnJVb2FHc1NL?=
 =?utf-8?B?WE5JRDltemZjM0ZLZGJWeU9wYmhMNU82REV6SXpIYzk5NW42d1d0RzZPZUM5?=
 =?utf-8?B?Q0JqS20xaFluSEFPNTh1cW5xVWl0dkQraXNHV05neklJdGZObjRZbVlQVWFL?=
 =?utf-8?B?VGVDeUF1WS8wYlNVOXRLMXN2KzA1RkdleldSVkNWbjB0ckptYkpoNHV6YkpB?=
 =?utf-8?B?SGdwS1h3RFN1bFlCNHo4blozTlhxdHdnTzlMUVU2NTlRZVdmaGNVTEV4SVhh?=
 =?utf-8?B?b3ljeXBkaDM0dEowdWQyL0kvcUNPcDlIUTB3YVlFMXlacXMxQ2x5djdGbk5m?=
 =?utf-8?B?MmNJbCtNY2cwcDZyK0w1Y1B4czlpcVNvNzcrSWk4aHg5NXdQUUVyQ3RYQnpV?=
 =?utf-8?B?WEZveitlVVNldG1ReVFDUHVNVzk2dVZkZWlDaTVFMGUrOWZnTmNJcW81VFVr?=
 =?utf-8?B?Q1R6b1lMaGF1UWFHSVVldzNKK1N6MWNsd0Y3RzY1cmJiOGNuTWUwa3BwNzBp?=
 =?utf-8?B?am9VWlRqTjJUaGRoVThXaTgybGZJTnpQMDN1TEFxVXBFSnlRdmVvMkdJOHBF?=
 =?utf-8?B?NHFVQUkrT3VlSEoxOEhxRXc2WUltbUtNdFdBakFzWGRFb0RpZXlKMktCNWhP?=
 =?utf-8?B?SDFMeWtrMk5GSUJ1R0xHQnhScXJhTnUxQTMzOHVYbW42Tk14bTRuQWFPYWkw?=
 =?utf-8?B?dEdFUGNvUTVKM1gyeUx0cnVLK1NZSmZZOHlqdm5JRkJNd0xKR2x4bllVZUE4?=
 =?utf-8?Q?ttV/Yb1wNaaw1wlqQVkil5hUgLViH6tL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1pyWVNCVURCTk5DdUt4ektoVVJ2dU5RWEFzbjRZeEZuajZiKzJ5a1A3MnVZ?=
 =?utf-8?B?ZzVCWHQxdXJ1UGdGK3JzOWV5SzFONU5HbkUvK2ptOTZkcHBjNkd0QmR5RUlC?=
 =?utf-8?B?ZW9xWk1INC9VcFZ3UnhveDFCV0NZc0RiVER3dkFic1l2RERBTGxkL3lSL29Z?=
 =?utf-8?B?eEsrelZ4Q21tREx3eTdWQU4zb3dzQVRUaFFGTmRkSXloZEFNS3ZaSDQ0K0sx?=
 =?utf-8?B?Sk9NRnlLUXpQZ1N0M1RvRWxMY1hoOFQzTUdUQlh4MDF3Uk9zZ2p4dm1CLytz?=
 =?utf-8?B?STZjU2RkODlCdERIU3BQK212b1lwcVdDWlNzN2hMaTdnZ0xTeEdPS3lKWjAr?=
 =?utf-8?B?VnVMQUU3TVFIblk0dEF5Q3owL2g2cHZHeVZHMFdjTjJXWGkzbGNzeWtSeVhI?=
 =?utf-8?B?OG9hSlZIcGxUdVhESHhkdE9EckZqMnd3NDkvaFNyak9UQmdTRTc5MFNISHlH?=
 =?utf-8?B?bXFrU2hZcDkwRmhZZFNJd095T2FLRXpGbFdrK3V6K1NMMDRDMjNmbDBSRGhH?=
 =?utf-8?B?WDJ3cHozWXE0aDJuZmFIL252ck5KMFlKZHJkNDkyL3FiY3hoRWpvVHkyNTlQ?=
 =?utf-8?B?OEN5WWdmMmMveDFsMjZoUnRycmR1d1pSR050bGdvL3psUzZhSjY0UXQ0Mk9I?=
 =?utf-8?B?TjNWOHd4ZlVPTW1tc1VWMGtOaDh2WDBQZW11RXRQVldrdHNQWXBvQUwrMjdR?=
 =?utf-8?B?a2lDVi9Uc2dWRlBLa0w0aXRobjkzUHB2ZFpzYjAyam1ZYlZGR2NzbzZxb1BL?=
 =?utf-8?B?MzBJeVFnVzU1UXBQWDlKVzRldXBWcTlpTTdwMXNVTjh6N0tzSStEcTNpbUdq?=
 =?utf-8?B?YTQwdE96QzRwTkkvN25nNkVEWjl6Y1RmbGhEQWR5Yi9NS3JJMEVQRnBZTmpX?=
 =?utf-8?B?eGtqN0JSWDZzT3U2eDIzMWgyQVlpNmx0b3dXYzZhbEQxSXltUHFQK3JTSW14?=
 =?utf-8?B?ZnBJdzVPYmhyRStJdVovdC9JalU0WEphbjdsYjRaekpOVDcyaUxiclY0aDRu?=
 =?utf-8?B?bzh3RW1vbHBKcDlNY0ZUSXpLYlB5Nm1ROGFLaGxCNTYxd2NobzR6RXc4Vjdp?=
 =?utf-8?B?aXV1MkVQQzRNV1lFdURiaEVzZlFFY2JnTmdEdkovUTl1cnB5TlNqZFNkVjRn?=
 =?utf-8?B?TmM1cWNLaFRDZEtEcW5QQUpEUmh6RFNvN2ZxTEprZ0Y3NitadGc3MktXeEEr?=
 =?utf-8?B?QWR1WGNKOUVaVzQ2ai93TFFOUmxKOHd6bTFuQmNweU5jZjJLYzV2MU5XUnVW?=
 =?utf-8?B?TVNHcGFDWFlnQzFBMjZqbUZsSjZLUy9qNS9lZkwwOEpZeE1kTkVCR0pGaXRs?=
 =?utf-8?B?akFQZTdZWUZ5RUpoTEhPT3JZZlUvSWt3ZTRTeFBRQnIyZVQxZlRVVWtBaW9t?=
 =?utf-8?B?Zzk0WWdSblpNQktxeitVV1VlZUNxcFZrL29mTEFSckVhZUpmbndUZVVYRFpR?=
 =?utf-8?B?ZUZyVlladWpBRU5vRUw4U2ZXQ0xoV3BwUWZTVEVqTWhmNHY4S2NzdnduektL?=
 =?utf-8?B?T2paSWZ2c2FWbnFtZUlWLzFld3JEaFJzdjB5aU9ySS9Za0pwKzFUQ04yNGl2?=
 =?utf-8?B?ZTN3WjJtem5jRVdGK3JkS2pRc1VUZzliVU9LaG5qVE1KcWtKcjdYTUllMUhx?=
 =?utf-8?B?M1hYODVrZ25JdktJK091djJTSzhIRC8yd3g1QUpZTzlNL1lwVWw0RGJKY1lJ?=
 =?utf-8?B?Nmp0SGJYNmsvYlJTZjNVT3ZjTjVpdkRGcmlRVHY1Z3JjbUhlbWJWMlFmbytQ?=
 =?utf-8?B?eWVwS1FsNFRZSTBSaWpSQ0ZUc0VrVk5BQ0VZNWRwdENBbmp4WGJ1Q1grT21D?=
 =?utf-8?B?ZTdkZ0JwRG10RElXTU82WEowWGJvQ1NzSzVlUWo0VWtKZHQvaWFhWXRaMWw3?=
 =?utf-8?B?bkRQbDdvL25VZFJLbERGU0JqbXd1M2NzQTNIUG5rcVYxOWdRN1pmaVM4WUNj?=
 =?utf-8?B?SGJvblBsUlI4eDJmSlFOSTFkZHM5SnBJYzFmc3NmR3dPUlg2WG8zSGlSUFVB?=
 =?utf-8?B?QVMwL1krcm1YMGZ3Z0hFNlZMUTdjZkc1aXQ0NkZzM3JCVUNMVVM4d21xRDM1?=
 =?utf-8?B?akVvYUdtdndqQmxJNWduYzNZangwWnlqc0N5UTg1amdPbkdPbXQrUWxYbG04?=
 =?utf-8?B?MCtTK3NYSmcwY2hzNHRTenFJeGdLOU5OTkp2ZjdvRm5tMmRVRGN4akh5OCtH?=
 =?utf-8?B?eHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e855ff3e-895c-4933-82ad-08de3f0b90f7
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 14:33:24.5662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyYGRuiezL7SPctrJVzD8krCeyBZ8qOlBwa6mQDgx/2DEnVojNSmVIByctQ8p+BlLsHviAeWynfeyWp0IE7JZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4648
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: DB46A4000C
X-Stat-Signature: kgdeinwu6w51ngnczocr34yx31k693rq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766154810-355702
X-HE-Meta: U2FsdGVkX1/UD01A7k6XIoiBg1FEiYEDi/oWUE9kD0C8Ol1WQ4UIUenfW4bXZa6JdrZ7cDOSd4p6ruU5vxuK9EKd5wDt+rKtbuauJhWKq5IQXbHp3VrzH06giWXoUYPagTPst7KdV//yF2cJvOjWG3gX2xSeVwo/BFCWz0mvAef51/htJp3En2bOdVOkCyzGF0RWW515iinFv8oN31ZH5SCjoVK99c6VBLrdE8JTs+UcOUSlWU8jT+KmEmo7mFqCbwlG/iTWof1fUfwXCsre3W8AbpVK+dlh9feFFRj3WFpp9uzLU7gKSGCdyDCsOuDGLWaawDdg4tIETW075OKSaJNjYMUPgnIiYE65R2iB2oTey/0O2HfXiiRZsvUeBZex2wjg8ZVZYrOrPpEfQIDohEppyFBZQUSubOAH1Nl5rHcTQV2tM/J4L0zdkv/ZSFdmtN3As3jrT965pPP+4be2AFM13vkqwQWEBZ3m2xs2eFq7nsbNXjHdMjpNkC8yStcougNyHWVTDXo0j0U3+6Na7boAmUTq8iGi2q3ZouwxUTHl17h1ookCHgByJkS5wbL+RKfPEPwTkAiNFxv4OYEEQy34dHzKKkC5SwXSpSefjRvPlaBMj5hKnH0UJ7B0+5Kr22xkhTRuqicrXC++4czboFyslmqUkOJkUynd8oJ0QV59gfzbl9e0L8iRiH5+O0ymMuPuUBhYzTAwxZ1yMqkHA0mRehkLDmM01YLfSJnKs139JFvNj07V0Ol9gMB5n4KX6b/GBuRPi2wKcPsey0Niw52vX/fK5Q3eZrkXuzfymicyEL2RjYw4WWqSyZ9sphvpH4pcF75rOupnnk/uiEqUj8XkV1VymX9dVftEavjeZ5MvEpxWODQXXkOD7VvX2cX2ZRDgsVuXSo0VzlhDJ/4jyKFfagHVq3J/CwPuSp2cr9SgKQZlkIBXaDjC85W+dUazlx0LoqHc32xOZrVXdQU
 hpdWsDNT
 N5MfV/F2PgZs6zQjVqzBIQzQv9Divdo/X4OGRrHs422+xh4ugqL8x8eg8f/FjQMiKPgQtl04UmFeHOFZhcpBUz/E5vwV2p3CgnSf3ESoGnkDwmbogolCy3iGv5Uv1LiWBQJOpllTr0CfY7sTqeq1vJW825ApcJncC0aMY2XvwkoqWuYLGrLi7FSJF3pHlfjR07j771XieLWb8T/5OZLOJo3E88PsONxLZivMte4P5T2zRMMKt+OLCeB5Fydk0ga1bdP64neiuTO2wyXLS48L59KuYrFP2C114mj4b9hg5pfDIaqCJ3wrAbhSUb/r5W5fSpjmKEP6qx+CIzLdydUCXTf3wUiI8TYoPGgrWvNS7xWkX3RAAbLhFRdS1m6hJ+QWyWHPioaBF7AkxBPkCGz5JMX5OXrie3rwR34vxo9zlmfRJXnKP6EmOwBSryhennjExZvHJOcCVdIbG5/l1PnwqVZatkby834/wJscC1jOgl2i6pCX0eIHz+WlWlGAWK0fF9mxSVUkf/QDm0LD4LxsCzkY6Trr7JKcYZf/0LLOlLY6va4pI4SDwtGVfqeerLPBozUyDjpyCDcVMJ1nXvV6KJj2AsuB1jt5bcegPD52XApkRxZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/19/2025 5:37 PM, Mike Rapoport wrote:
> Hi,
>
> On Mon, Dec 15, 2025 at 09:04:37PM +0800, Tianyou Li wrote:
>> From: Yuan Liu <yuan1.liu@intel.com>
>>
>> Function set_zone_contiguous used __pageblock_pfn_to_page to
>> check the whole pageblock is in the same zone. One assumption is
>> the memory section must online, otherwise the __pageblock_pfn_to_page
>> will return NULL, then the set_zone_contiguous will be false.
>> When move_pfn_range_to_zone invoked set_zone_contiguous, since the
>> memory section did not online, the return value will always be false.
>>
>> To fix this issue, we removed the set_zone_contiguous from the
>> move_pfn_range_to_zone, and place it after memory section onlined.
>>
>> Function remove_pfn_range_from_zone did not have this issue because
>> memory section remains online at the time set_zone_contiguous invoked.
> Since the fix is relevant even without the optimization patch, can we
> please reorder the patches so that the fix will be the first in the series?
> Than it can be applied to stable trees as well.


Thanks for the comments. That's totally make sense. I will work on the 
patch v7, will rebase with 6.19-rc1. I will be out of office next week, 
probably slow response but will keep working on the patch with Yuan Liu. 
Thanks.


Regards,

Tianyou


>   
>> Reviewed-by: Tianyou Li <tianyou.li@intel.com>
>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> ---
>>   mm/memory_hotplug.c | 18 ++++++++++++++----
>>   1 file changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 12839032ad42..0220021f6a68 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -810,8 +810,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   {
>>   	struct pglist_data *pgdat = zone->zone_pgdat;
>>   	int nid = pgdat->node_id;
>> -	const enum zone_contig_state new_contiguous_state =
>> -		zone_contig_state_after_growing(zone, start_pfn, nr_pages);
>> +
>>   	clear_zone_contiguous(zone);
>>   
>>   	if (zone_is_empty(zone))
>> @@ -841,8 +840,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>   	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>>   			 MEMINIT_HOTPLUG, altmap, migratetype,
>>   			 isolate_pageblock);
>> -
>> -	set_zone_contiguous(zone, new_contiguous_state);
>>   }
>>   
>>   struct auto_movable_stats {
>> @@ -1151,6 +1148,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
>>   {
>>   	unsigned long end_pfn = pfn + nr_pages;
>>   	int ret, i;
>> +	enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
>>   
>>   	ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
>>   	if (ret)
>> @@ -1165,6 +1163,14 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
>>   	if (mhp_off_inaccessible)
>>   		page_init_poison(pfn_to_page(pfn), sizeof(struct page) * nr_pages);
>>   
>> +	/*
>> +	 * If the allocated memmap pages are not in a full section, keep the
>> +	 * contiguous state as ZONE_CONTIG_NO.
>> +	 */
>> +	if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
>> +		new_contiguous_state = zone_contig_state_after_growing(zone,
>> +								pfn, nr_pages);
>> +
>>   	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_UNMOVABLE,
>>   			       false);
>>   
>> @@ -1183,6 +1189,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
>>   	if (nr_pages >= PAGES_PER_SECTION)
>>   	        online_mem_sections(pfn, ALIGN_DOWN(end_pfn, PAGES_PER_SECTION));
>>   
>> +	set_zone_contiguous(zone, new_contiguous_state);
>>   	return ret;
>>   }
>>   
>> @@ -1221,6 +1228,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>>   	};
>>   	const int nid = zone_to_nid(zone);
>>   	int need_zonelists_rebuild = 0;
>> +	enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
>>   	unsigned long flags;
>>   	int ret;
>>   
>> @@ -1235,6 +1243,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>>   			 !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
>>   		return -EINVAL;
>>   
>> +	new_contiguous_state = zone_contig_state_after_growing(zone, pfn, nr_pages);
>>   
>>   	/* associate pfn range with the zone */
>>   	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
>> @@ -1273,6 +1282,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>>   	}
>>   
>>   	online_pages_range(pfn, nr_pages);
>> +	set_zone_contiguous(zone, new_contiguous_state);
>>   	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
>>   
>>   	if (node_arg.nid >= 0)
>> -- 
>> 2.47.1
>>

