Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD6FD116F5
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 12:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9AB6B0006; Mon,  1 Dec 2025 07:28:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F7F6B0032; Mon,  1 Dec 2025 07:28:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D106B0088; Mon,  1 Dec 2025 07:28:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F09026B0006
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:28:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8EB77160174
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:28:30 +0000 (UTC)
X-FDA: 84170830380.08.A987EE1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0A1D740003
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:28:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gSHF+6mB;
	spf=pass (imf07.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764592107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0cXki6nR5FOa20KjN7dQtFygN0w9vGdVVPBHZmVUMk=;
	b=xN27jE4NAuWaPj7T/URxnUiDlkwjf3K0ucXCKc4nBubAOWr4aG9djb8O/VaVApORghWtva
	Uh6v18xgGB0jEoH5pR/CodWHOTZoJw2dDeFSqU8c30Qil43Ww4kaBcDgG9f+6TMsVKg9T9
	rJRhIEIy6/rGuKOo2S5xTs/mrj++OdY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gSHF+6mB;
	spf=pass (imf07.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764592107; a=rsa-sha256;
	cv=fail;
	b=YvOpnxpklxQ9z7+GXRAcOX9u4NZpeWevePo9Xt+qfbeGuqScKFif5AxnGhs7o5Nsbi/NsP
	JQpAamvhMA075ElfmZVEG+ZLh6WUsMkaI1U7n+z5QLyLlBqvIUi/dnp2BNE40xzR2wC5W+
	nbLCPmPHKGhX8MXJ5F1c7NcFdM/Q+K0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764592107; x=1796128107;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wh0cnvYffYK9+SgdPauztCtqLLzlcYcrQk6W8sdHcxc=;
  b=gSHF+6mB7YRlPvcDID+yfVKm8YM7ROrVzDK4dKYHkUBtHIUDGrIoXiFy
   3fEQuOalN2m5rVuKNre87tYy0o6f/U2tXa8rnB0CYJk7gvKUvDBycTMOm
   JuE+IbjMLD/n12Y3OhnzqdadHrQeKgDmPoDjPxsiAnUoa1dacD9xz0VeN
   zyiNsPIIxEJoQvevcrghfQb7SRoqPZldweMdy0M7T3/8Cwae2f4Ioe2+v
   AKRsqJk7IsPhnhnkHerlxKr+ywAND/Hp6SYFngecZCpbzwXsyipOzIzOi
   4IVBnctwpBoWWm66NjuN7gmEKtMQ9qtplXDQUfMLo4+FlPqZSMhWKeFs2
   g==;
X-CSE-ConnectionGUID: /74N6kTXSqe6YHWLsRGkTQ==
X-CSE-MsgGUID: G7bAaSBVSuSkshDMpmGh0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11629"; a="66564155"
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="66564155"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 04:28:25 -0800
X-CSE-ConnectionGUID: W1Rc2mepQo2UKvDnJ7wGRQ==
X-CSE-MsgGUID: rGGFHKidQSyNhyzd9Oydnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="193891259"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 04:28:25 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 04:28:24 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 1 Dec 2025 04:28:24 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.53) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 04:28:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=plYb9ojSAD2NIEfxSxln/h4myQqTPs9QWpH3cNl8lQg7tQS+c1zw5oRVeVfbMrfs6W6pOwYZr2LcyowTZyUdu/raTYp7Rdl/VLE3FwMGYAN270FZZPQcgaWC7IeakC10znjMf3X/DHdd6oK9OTpo/8Kh/gHYI3rb4TSd0UxzCOLAlb8hB1BglPHh+N+lRhynlgWD6eH1Lh0l8bIlGy9kHnlLW+IX6VBhEXQsxglBpIbc6liziSKsX0wfRx4AEKQS8Ekd2V7/do/Gvb1sC+aVuIIEft6JZyzDCImtyTX0QPQ7Arp2uEUJoBf8+P8Xb7zjM07UEekrL8gS7iBRQnGSSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0cXki6nR5FOa20KjN7dQtFygN0w9vGdVVPBHZmVUMk=;
 b=UD7l+AxbxOnJ3l0ispdncdPy1GEElIWVJSKalQQIL4gskT4TWxGGwoxcsBxK5MkFWvXe5RtaJrn4+dgNhTMvJtkBWoBlQdppUAeSFC1qwQFBK+GegScNTTpHbDjOADmm4Z+yQZb3N0kJpNnlrvKbxbF4p13+1Sr0vuqskAz+YS3p/IAQfrkfPZHwBsNkCgY41zENqbVIOedlPs1wEJl25m+JrYpg6J/PkbxmRV2he1gzIvTvO0WraI1eZ5wo4x0IdqQmj24Uwe451SwyT4TsuQtkQpxw9Y+VEVBa5bZ9f2T65LehXmL9Lkqf2cqAOq1JQ1ELo63f32HZfA17UxoERg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by SA0PR11MB4528.namprd11.prod.outlook.com (2603:10b6:806:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 12:28:23 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 12:28:23 +0000
Message-ID: <e54741dc-2fcf-404a-bb28-4cee6db3bd4c@intel.com>
Date: Mon, 1 Dec 2025 20:28:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251119114252.oykrczprf3ecd7ak@master>
 <20251119140657.3845818-1-tianyou.li@intel.com>
 <872562fa-5dd7-4cc9-82ab-5b7c09ee8fe3@kernel.org>
 <9b6e39ae-c317-4433-8171-0927bce3acad@intel.com>
 <123e0d99-ef29-4906-828a-9dfd29dafd29@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <123e0d99-ef29-4906-828a-9dfd29dafd29@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KUZPR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:d10:34::19) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|SA0PR11MB4528:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d66fc2a-e228-4c89-d27a-08de30d51e35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y2JIZG8vRDN5NHRRZ1NIUGVjYlI4SEIvS04xN1hzbXpPdTNXNmFSTkkzWWI3?=
 =?utf-8?B?Rm5NMnBDVi9ub3Q5ZnFrR0YyUUlobk1HSDFzMXR1ZTZTTDBSWmEwMUJ6dnph?=
 =?utf-8?B?bGs2b01DOGFpNkUxdGpMSC96VjVEVjd4U1VjTkd6WkNNc2ZsNmVvMUM3b1Fr?=
 =?utf-8?B?WCtnY1ppZWdsMWVVdTAyTUF2cW5QUldhY1NUdkltYU9jc21iMEdXbEl0cjhP?=
 =?utf-8?B?TDVNaXNpVEpQUVRLSCsrVHA5K0ZIM3lidXF6emZrY1lIVHdHRDhsQmh5ZkJU?=
 =?utf-8?B?emY4dVJFMEVtUEJaRnMwd2psMEI3YUtjajI4SjNtZVMyakV1Z2Zlak5vT0Jm?=
 =?utf-8?B?aFFZeHdqNCtZWFdRWnFSVTJ3WmttekNxam9MOFBRUmtPRm4zSmgrMkZDcTBG?=
 =?utf-8?B?OXd3UTdFNVNTVE1KMytzQXpXa1U0RGJoN0lyMDVpaUhWNkJDS1lReUpPWmo0?=
 =?utf-8?B?Q0pFNWZqNURqWjQ0N0ltVjh3K01hOThZNTdGUU1ZK1dweGdpTmdPSHU0VlJh?=
 =?utf-8?B?T1RlOEFueFAxNlVZMERUWWJLS05iTFh0Y09hU1NiQm5EL3Brc2NaWnEyWFJv?=
 =?utf-8?B?ZWVveVo2ekpSd25UWVlsNVkvaHdUL3V2cVVBWG9xUXNKRmJiUTlqeEQ0R2hi?=
 =?utf-8?B?NEdhb3RXa0wzK09MdzYzcVpXRnp5anhRNFhHYVdUV3FXZ2dpUjFnd2d1N1Ra?=
 =?utf-8?B?dDlPWW55dGJBNklLTUhhZjBjdEhlR1lmTGF4dkRlTTJ2MmpkY3pXSWFZTVVM?=
 =?utf-8?B?WWpYWlc5YzZLVmFiV2lYQXA5Tlc0MG8wTkxLMG5La0VocWVDOVJRRjV4NE50?=
 =?utf-8?B?V1pPZENKTWFDTG41YXZ3SHBraXFKaFVVYXRpL2IwdkJwNkM5Y0xvNldqamdi?=
 =?utf-8?B?SkdhZjczVWkvRzh6c0E2WG9OVVZNNitGQzFsQ29PZU5wOERQdG95QjhtY0Zz?=
 =?utf-8?B?aTVJTFEzTGhjU2c0NHROMmx3Wm9CNklGNXByVmI5NVZUTTQweEZWajBUUE9j?=
 =?utf-8?B?WFZQdGt0MVFWclFJa1pXOFpBZTU5QXNSTnlDeDRNWk12blRneXZSZTMrSUc1?=
 =?utf-8?B?aEpGRjFGNytvSkoxenJOZnAwd2dmNWVsL1FFSitCZnRjbDdydE1VazM3eC9y?=
 =?utf-8?B?dUdjcnZrOVNUK0psQXdTa0hSQ1VuRHVFWEdjZVJNdEFmMmdycUxuSmJnNks3?=
 =?utf-8?B?ZHRZMWM5b09FcmpQVFJtYVlXTG4rb3ZMQVRTR1pXRXlidTIrSWMyU3BzMkF5?=
 =?utf-8?B?WW1iNTRwZlpMTjY3b2hGOWVCVXdsSmxWZ25uaWdIeDJkclZ6Q3IrNk43L2VU?=
 =?utf-8?B?b0szT2wrQm5vTCtOb05MZFl0dlhPdnYyRkh3djRTcGZrZjZQOU92Q1RBUUlQ?=
 =?utf-8?B?SjFPS3ZybzY5bkQ5eTBzQmVlZHBhRWRTSlVkdU15R3JiN0dCTW0yb2l5Q2FC?=
 =?utf-8?B?MDk4N080cHRkVkhDMER6N3pIMmJsK3JGSHlOY08vNUg5c1ZlZzJETEk1RWJ1?=
 =?utf-8?B?d09NWHRQenhIN2VRRGQ0MDg4aEpNdXRzRVhWdVBsVkFDczNxbnZPTTgxQ2t1?=
 =?utf-8?B?ejNvSWt2MnhwTEc1REhSYnRUS09RSndTelFVeFdGVmkwNnh0STNRUUxoY0Mz?=
 =?utf-8?B?YUMvS25naVgrcVhMYXFOQlJPbGZGelRCeUFUalgrQTlZbU41RHFjaWhtUTRx?=
 =?utf-8?B?RXhIdEJPem1Lc3ZXeWVYSGw5aTVUQ2lZbVBqT2VHOXF1UTVSVkZ4cXlzd2Vl?=
 =?utf-8?B?Q1Fsdm1sekVtclhkTDQwTFRRZHkvcXlxZlhQY2FaRUlXUXgzTDQ4QmpLdHhB?=
 =?utf-8?B?U0NxQnNOQWZEWm9scDZWZTh3MWtySGJxTEhiVTF5eHdrVllDSWZ6Ull1blVj?=
 =?utf-8?B?eUlraytra0FDRjlwU1pWSnFpVEFDaGVLai81cXB6d3UzZm03TVJMUVFXSDN2?=
 =?utf-8?Q?+Aaj92+m1pfKmtCYuiQ2oBv3fqz/j339?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXQ2MXB4YUk1WmtOQWxDRjJVYzJ2ejhFSEFkWkZjMldMRWl4RFNkajFMLzky?=
 =?utf-8?B?NlpHd2FSM3BrTkx2RWNNL1VHTjEvWklVRzhNS3liTzJpclJCZWVFTEkzMzA4?=
 =?utf-8?B?d1IzYTl0SldMRWYvaFBMQXZVQzJmRVdGaERZRjY1VWV6aTE1NjNLdjJRUS9v?=
 =?utf-8?B?aUg2ZlMrelFRVDdmU3dnYWxISGhkSlIzSmVsWDdVUFVKcGhUSHUrMTRvZlFV?=
 =?utf-8?B?L1hXVUduVlAzaVNJWmhBSzNlSllpd1B2eEp2UDFYVENMWkJHRWtXNzdpVmNN?=
 =?utf-8?B?R2VwMzkwdGRId2pxdVZIekIzR0ZONjhXcldKUXhIRnNXNXBGd0F4QkxPYzUr?=
 =?utf-8?B?ZTRoSFZkZ1lmWjkxN09teTh4T0NiYTJEN045MG1VSXpRTFp0bitQcVhCL01w?=
 =?utf-8?B?U0g4TTNlbHAwWGVRZXYyZGlqK0E3QnV1ZGtmQXVyWUpQUG1INHVOejJZQTMz?=
 =?utf-8?B?TWt3NWJ5d25HQVp6dFB1RGROMk1LajZZNVhtdGpVcFk5SXA1aTI2OFllb1NW?=
 =?utf-8?B?aTh3S2l5VlBqc1N0aDNkekhJK0liYVl2MjdjaTJBNWZZdStJUnFEYkRxSkJy?=
 =?utf-8?B?VUtEaGVOZkZLeDlzOW4rSEl1ckVYOWpha2o0Wmx6aGkxSlNXWnFmTHpJZzdM?=
 =?utf-8?B?cUFYaTcwVUJ2ZHRwOE9IMnpQeWs5Zy84alRTeTJtMWRCZkxSSHJmemdaRVM2?=
 =?utf-8?B?UXZCangwNU00bGprSTlQWU1ZUWRoRmZYaWZRS3RpVzNPZm1FUTlnR1hubTlw?=
 =?utf-8?B?aWg1Y0VlZGdIOXc5bGk1dU1qWTFUdTQzQ0piTVFkTFI0eWplT254QjZ0MlIw?=
 =?utf-8?B?bGd4QW5yYUVyUmtpM0I3a25oamxDaU4zTDNtSXpHa0R6ekt6d203cVBWM2p3?=
 =?utf-8?B?TjNnKzl2RXhvNlNnLyt0MWs5RkdKYjBqaFduVVgzZEVsaHlvRU42QTd3NG8w?=
 =?utf-8?B?VmptMHA2OTc4bm13WWdMcXhNaGtFcGJIY0lLNnMrZGpYc0ZlVUZmUm9Qc3Yz?=
 =?utf-8?B?Zm90NzYzMVYyVmRNMmF0WkxZTTdsUVZEMnRzMWtEbmx4eGlLUVNReDZhZzRy?=
 =?utf-8?B?c1VVSXdjdjRkWTNSVmZrbjRCMHdrWnZ3aVEzNGJYeWkrUDFaY0NMN1hRVXRm?=
 =?utf-8?B?VFV3c2E5YTNvb1VDclo2RHZOSHp3cGNXZjFVbGs5cThTTy91SnZERXlRb2M5?=
 =?utf-8?B?QUJ0MmVDMUY4aXBWR1JhWHhUdFpuT29SMHhEMVpydm12WUkyQ3hRbFgwY2lx?=
 =?utf-8?B?Y3pBRVdJMjE0MlA1aWZHYUZzbGJXajRjVjgvbDJmSityMGsxY09jS0NIRHFM?=
 =?utf-8?B?a0QvRTFhS093VDh5NjNzL0cyWTJWRFlkWGI4dll5NHJNdUgxUGxocEs1UWtp?=
 =?utf-8?B?TEZBOWZKNHkxK1dybnl2SUkzclBzU2ZTaE9vRjNkWXdndU9EdjY0Z2xnY0lD?=
 =?utf-8?B?bTdWUU1RK1AreFNwY0NnSmFvVUY5Q2xqV012YzU2NTZjNnNreW9vNVJBR2Ny?=
 =?utf-8?B?cFRxbmF3V2RBRWU2ckVxU2M5eVdNTGNiMU5uNG5lb1J2ZXIreFZzcVJ0WkFX?=
 =?utf-8?B?SHZMWUJHbGZDcmdkN3NxVmNXU3paaHpkSk5lRzFzaUFCdkpNWTY2d2swaWJW?=
 =?utf-8?B?U0RGcjUzZnF2Qzc2MloyalFzZHZJTXFtbGE4eEtDd3BzdEo0WU4rUzZRbHB4?=
 =?utf-8?B?YWNJU1dvZE8vRlVKcE9YSXdGYWh3SEJkcTRtU2QvbmcvUUVVNzg0YjZFUlVO?=
 =?utf-8?B?TEtaY1NRV0FHNGNrRHRDNTBGY0pkQmR6aXRHSHdyL3l0djhCZjBJWmo5OVRi?=
 =?utf-8?B?c25MVjMwbUQ3bUFUamNtRVVSZ2k2anJMMWh6OTFyTlB5V1oycmZEVjN2OUM1?=
 =?utf-8?B?ZktKbUt1NEtLRTNBQzNzQXFhVlluK1JtbGo4MEZRUXRwTG1ISUtxLy9zZFR5?=
 =?utf-8?B?dnorSHExSHdoamE4MnJFQjNKb0ZEODNmNW43aWJESFgyQ0REekRtUkxDLzRp?=
 =?utf-8?B?MlVOVnVjSmk0bzQvT3FFWkg3cXFzWG5SSE4rZFM3NFFEWjBVN1FKWkoreits?=
 =?utf-8?B?VXNOdHRIMkhhV0ZHbmFHNE5VZTFNTEFmcjdNMGE5VEp4dkh4cUZmaFhoUFZs?=
 =?utf-8?Q?4nj0VGyqmQ9TIh33pEfSc/FW4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d66fc2a-e228-4c89-d27a-08de30d51e35
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 12:28:22.9741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lfh9E5tfCvxAgj0r6dCvGcgjUEYnFpdZRV/xhBTNSwCBu7gtuCxOD+5YkZGXU41NaXyd3zpzsLFJ9HjloNXjSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4528
X-OriginatorOrg: intel.com
X-Stat-Signature: yb1oj7w511p7ie4b3anrnzirxi36gwjs
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A1D740003
X-Rspamd-Server: rspam09
X-HE-Tag: 1764592106-187283
X-HE-Meta: U2FsdGVkX19ZRMwWtKw+IbTFm1Uf5zLv44ayMHrc4BTKGnS/tHHWYJw3xwnSM1RV6bUtuljnexqjzX/mvIcffl81k3QZYuJM4tyxJCB0vHXSHLGISNQfffa7DGi3IsLk049tRXOHUnAERwHYPygXk01YoBUaLz24Ekzl+jiggmigat/lWoH3gyPYO6wrOVdZD0hKUrCEL4Hfg+1G7YC4Qtv/PFLE0xYhDhEytWzBzmkfM6DsSGoLEiGswXk5aErVkRlpJZ6oPq7ypuK+mk3ewB+O3cWaEctaxzv+ZA6A89ANdbAwrcX8Xl8aTXLxPt/ivbQRYrPoh9sKOUwCaeZSVqrYjttRrMEhou4qyZQBrMG/md+rhY0Rg7WU3nPVLmsMGCsgF+HJNgLL0taRJ3s878zdrTs3kz8vzPQ5HSSrS3bVCXE3HPfAxsQU4LzO8NkAv9BxXMVzx3YsSz8r0uBAdc05/nNLB1TdG3AIuBqkFs3jILAv6X8ahyzxQn36xS7KltYlx9M16QXwakxbWBi05aPMrIXiIcq0EDVq4je70Ovb3wcpnOE/h4fydhnDY6i1OhtRKExfrg5sU7iwybXIgrW9a5FFqlIlQpNbwU4GHUwtcVZhPQqRRxYQlMLOa43Iv7HND/qg0mIb0G6AJ8T1DKYrhsaUFtZ58gQD+V+KixK97ooLwT5cnKIJ465EnrgDBRruz2pRfFfy2xl/4Ym1YnRh9UBXmSHZl/lrgHWBWuxP/Bv/Bm19A9v/QgOSQ3CKrlbXihN5r1/kp0TIs4Yx65P8Ednv7t6c40AX525l6FcdWoZGEFesmtltxl/12ezwIJJstfh2XIAZ5ea87qaXrWIyEjRpRikz0EYuFcw3xEQxHIh1hUmA6sngWM0eAwgKmFD9H9za5DhkMK6hBmgwcviCqYP0nOskMS2ll/ATHzTt7Ciqv4Er737YA9ILcYeWQ7j96iT7y1f3wNcFFzk
 bDW4szJl
 ETE3C5jglZThOtn+7F8Ri8FAblPPknmxRyQZtasYKkHsadZs0lVQzNecgq7FyndurmMdOlKPQZnAodCPvF+yXVWMWc9GXGihRmuSOUerp3ENdZpSMhapVFwrpCYalSg6ra0dgBtwGMtAwfuvXIuy9eBms/azO47Rimur43MXgK2e+ea3DJyexytR1wiEhYZDK7PJfWiipueAbRvYnFjJ6KTpWjCqKqRb9Zz4BBIGZ/dZstdTAXDIxWQSeOzl3aUKkjRg4NSSA2gJmioi4eKoerAAGSYhv9zdhynBTySMFrFKVisO6n7G++1qOpNsLtODZnx41zYRck3uU9pvG26BZXJHf8Ev2Bz73PT/RPnTTZqhLtzA5VvAIaVbSc3pLSjEG28lNpeRtGMuXwv5WMFKIoU7Jb6pzs2tGe0MnNayLO7GVmQupv0vuL1jYI63dIdi+r1rzNZqJYSIbFgx6BTejHrCpbobvzoYD+PQs10s574MosZjZAVUez5ls4a5HWd69/Tyj8yn//0XIEAV03MZ9UkDIZAcQU7vTfZyshWXtflKHSxLIT4UfNTjqXebC90pIrM1/ptxITAdGJfM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks David for your time to review.

On 11/29/2025 12:04 AM, David Hildenbrand (Red Hat) wrote:
>>
>> Instead of a bool value, could the clear_zone_contiguous_for_growing
>> and clear_zone_contiguous_for_shrinking return a enum value to indicate
>> one of the three states: 1. DEFINITELY_CONTIGUOUS;
>> 2. DEFINITELY_NOT_CONTIGUOUS; 3. UNDETERMINED_CONTIGUOUS? The
>> set_zone_contiguous took the state and skip the contiguous check if
>> DEFINITELY_CONTIGUOUS or DEFINITELY_NOT_CONTIGUOUS.
>
> I had the exact same thought while writing my rely, so it's worth 
> investigating.
>
> If that helps to come up with even better+descriptive 
> variable/function names, even better :)
>

I've created a patch v4 for review in a new thread as previously 
suggested, Yuan Liu added the test result for memory plug and unplug. 
Welcome for any comments or suggestions. Appreciated.


Regards,

Tianyou


