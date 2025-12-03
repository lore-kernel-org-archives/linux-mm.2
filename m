Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2ABD116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF82B6B0095; Wed,  3 Dec 2025 04:36:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0306B0096; Wed,  3 Dec 2025 04:36:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97D56B0098; Wed,  3 Dec 2025 04:36:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C48076B0095
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:36:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5081489342
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:36:07 +0000 (UTC)
X-FDA: 84177653574.23.BC3E27F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 54C82C000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:36:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YvsLqJnA;
	spf=pass (imf10.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764754564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8azZL1YPHPW94QWVdSMtraKURSwvY0MYtrG/38gt6s=;
	b=qhk9L1+2EdGLrsgz7rU3YDuPhtHhW2XteMo/pu0xhX6bYf0aAyX+p/gaxWg0GGvGUFJsyc
	ip9bRhJowAQ0ayWXf+mygiYEUprosZm0O00alu+zgdUHYzVs7YkrSIOn0xNOz+xjMYl9vh
	yUw6ZV1WkSby9SXBWrRcoY9J18dSTbg=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YvsLqJnA;
	spf=pass (imf10.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764754564; a=rsa-sha256;
	cv=fail;
	b=SX8pek/l+0OwXsIRUEWvhCm+jOKg2AaBgCw8tf7KwLmAuBsxBWw/jLBK2sMqpzfgC7ITvH
	0z7dDtiq+4hIYMMEY9P1tDjtbM28iLMyRzNa9aaxHoYq7/FdyTVKYct+p4cvRsd/tbA1cA
	MMvM7cMHQulJczVvT9m3iEFJU6KqVug=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764754564; x=1796290564;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n95hxRutEnjjEM6udoj3e11DkiA8MHgsUWFDxD3B20A=;
  b=YvsLqJnAiTQDfjM7jpjiaIPLcLzZfhTpWjyrB9FWqtLyFje2vBZ2Cs9y
   67hLyzZczi3CJJh0UOQgwB+s2u2uRsooCtUu8DBZH19rM+JUjGxPUBAHh
   OPZPJeGs2P+SdG1SOL0W/ufxmQSNdOeRx44rXUutc9jh3rBzUmmNFvYh7
   QFczL8Odqs4iubTYajjkJYUX8BIMDsCFJ1/ChjnyPvrz2/6SR05//dXEo
   wR02Vu/mpKa/wxLjU68+vGW5vvr9zMLaILpkw5VEbay9itbFmWEM69B3T
   caaTTgHjUmcNu4CUeHwUR7gOK56TjmT6d10tGzn6MSUCyH1NxQt18Hayk
   g==;
X-CSE-ConnectionGUID: FUDXtNbSQUyd/xEAqWLLtw==
X-CSE-MsgGUID: Bkv9pm/3QMKQDIX0H84Oog==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66906810"
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="66906810"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 01:36:02 -0800
X-CSE-ConnectionGUID: 0gwqISHHSAy0SeZQ63n1dQ==
X-CSE-MsgGUID: scjnW6PzSLSR2Z/pTe/SFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="225306506"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 01:36:03 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 01:36:01 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 3 Dec 2025 01:36:01 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.42) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 01:36:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OGNWL5WWyxDQQE52xAH0cvUCiuuvlf6oF6NPqWB7eodR8utvfbV/0AoffWnjypuwibnlbt2FGLt8wYMhXkarkA0DdsT1NukjXII8CstIkDd88WyNaNMiKqUCdD9enTie+W27MN1XrHJFHpXzvuee5k3Pd5I0BAL+aCSEVW8/nzcxIYT2V5W1zV8ufjBkbOXOj+f68wKXAwkmnNplvG6YhCbwCEKBeCb8kQUHU0lE/SzMCVNVHF1yv4IFdzFutpnjIms/265TENvpKFChcyXw0/5z9P2dNTShRof/5njN4y5XL2Jj5tkleZwE+3CEc4qKxPbYkUoGdN/iexI1Vko1Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b8azZL1YPHPW94QWVdSMtraKURSwvY0MYtrG/38gt6s=;
 b=yxy/yNly6o4GdwXHJiNcTVv3gz8E2nnmVoMLM+0ZobR5UAFsnQ4mHNXo53Yuwy9O77Wb7C34amEcdIKY87ozino8yQlc9XFhXFcMQolsb/HaeTY0P+jNT+ryr91ybiM9ruqd6MHsnFVQ0UvQbqYUtKUjyI6uzco28GanJqz3bD4Kte7OQytFXQAMeJ7vGL25AMZiq6CGnmdhECouhSdzNv2ea7+hBpRkYpkIAqVvis1lReuUPY6tvDplIO2rOBUZN6T4Kf4VSOK4VL96ubtFQqxH1td+110vkl+9AjU5N5QlJMI9LUgnITr97wozIOU4gKHs8NjeYTjMOlE7BWN9Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by LV8PR11MB8486.namprd11.prod.outlook.com (2603:10b6:408:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 09:35:54 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 09:35:54 +0000
Message-ID: <9102cb70-e573-42d8-82c3-39d2af009e63@intel.com>
Date: Wed, 3 Dec 2025 17:35:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when changes pfn range
To: Mike Rapoport <rppt@kernel.org>, "David Hildenbrand (Red Hat)"
	<david@kernel.org>
CC: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	<linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251201132216.1636924-1-tianyou.li@intel.com>
 <7633c77b-44eb-41f0-9c3a-1e5034b594e3@kernel.org>
 <aS7F_ORMLBcAqQTz@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aS7F_ORMLBcAqQTz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TPYP295CA0032.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::13) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|LV8PR11MB8486:EE_
X-MS-Office365-Filtering-Correlation-Id: e7f7c139-611d-4569-a6a7-08de324f5ada
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WDVUS3BrbkFQWVhHcmtSbVNwbHJza09uM0pnRSsrcjNXQWR4dGVIa1pHL0xO?=
 =?utf-8?B?STRuMUk1ak4wdElQekxwWTVzNmdONE0rVHdkLzE1c3NPMFBiYVdmY0tNbDQ2?=
 =?utf-8?B?M01YVjFtN0xIQmtXbGZ4RzUvRzdVZ2JhSWZORDR6aTZwY2RicVI5K1h2MUx3?=
 =?utf-8?B?RTB5Yzd6cmhCNDlvUmJqOXpHYmM5bk5xQXdGQXFjMVJ6bmNBWS8yUWhFd1NJ?=
 =?utf-8?B?UXk4cXgxVjBHZ09tZ2M4NndPY0Y5S3AwR0hpa0FSNVQ0eWJCQ0Zra1U3NXNs?=
 =?utf-8?B?S2U1MXZZL3Uzc3dOaUgrTS9tU0hZV0VnT1V6UlZ1VTlTQkhBV2p1ZnNBMlBD?=
 =?utf-8?B?SjB2MzM3RTBVdldQSy8wVmJGTmhLanJyb1BFekdoMTEyWjBRelE0bzF0TWQx?=
 =?utf-8?B?Um1ldkFoN1lrUFFJejUxV2xxSTg1cVlnK2dtdy9wS3NKcVBwcHhsYnp6cGM3?=
 =?utf-8?B?TEJnZnNZY25iR0duekdvQkVOcU9EWXk2YzdaSEtiS1FzVjc2em1xUnJXRkNu?=
 =?utf-8?B?QlJKVlZ1clBZTmpUMEc2Z2dkUGs2WStFQnE2aG91d0tPVzgwOFdYT3pXZjBB?=
 =?utf-8?B?eG1EdFA2eHBzekxyWjN2ZkVWOTkxeVMrZDlYTnNwdU55WEVmRko3KzJWY2xv?=
 =?utf-8?B?cGJBUlpXRDJuRU9OVHZ2dm5MME5kNjZuQ0xrRnJkUFg2RWsvQmRJOVFMRk9T?=
 =?utf-8?B?R0YrdG8ydWUzcUY2NGRDbzZnSnVMOWh1RXk0TU5nWWY4ajFhbitoWFJJSEU4?=
 =?utf-8?B?N0NSUWc0SDJOZmtaNmZtZkl1bDlJRmFhR1NZUmtYVkpRZk9qT3d2LzQxdW1t?=
 =?utf-8?B?ZDA4eGdBaFVaMmFwUi8zeTc5TUtRSVhoelp0WUZQQU5Ibk11STc1aGJDQ29o?=
 =?utf-8?B?QTJMcWJDMStvd0xjeTBEczZaellVbjQwSkZlVktzY1N4TjNNWUVtUEVXY0t2?=
 =?utf-8?B?eXJ4RWtMM0tLUHMxeHBnVkZKYnNkNWhkSHc0emNnY1RFd3lRRzQrYk50bC96?=
 =?utf-8?B?UFFoV3F0RE9uK1pUTkxPWTEraHk5dDBEUkpLYVowVDN6Zm5VRGNlcGJOVjMx?=
 =?utf-8?B?ZWJKS0J4cENxV3VYR09zZExMYzFQaVE1Mk9CSU13U1Nuak9tL1NYMHAwT3cy?=
 =?utf-8?B?bHZ4Y29jTkloWGpXWTVSU2tEVkRidVNwSG9idUx5M0VlNVczdDU1NVBRd2oy?=
 =?utf-8?B?bExiSkROVVI0dURjQklkNDM1aTBEazY5UXAzaEYyVXdEeUpucXE1YVI2Zjhu?=
 =?utf-8?B?SDMxMWdMU09yMFoxNFdVVEVpaEFXSFM5M0k2WDZDU3dEdVdhcSs1Z0tOUDlT?=
 =?utf-8?B?dUU2MG1CSUN3dFFjM3E2QzlZTXM0MXlGdHc4WXE4UEc4dnlhWjBnY1I3RzND?=
 =?utf-8?B?VERVd1ZYRm9VN1M3MldsMlZodnM1OW9sNjdOckNRQzZEN1RiWXdDT29lRHNp?=
 =?utf-8?B?cHdRaitBd090QXkwTUlEVE41ZkwxaFo4S0dlYjFML0V2Qzk5VGMrZXFFaGtL?=
 =?utf-8?B?NUJFZ05WVmltRi81VXJrT0dBR3VwZ0hGVFBiaUd0UTk5MW16NEtHUVBqN016?=
 =?utf-8?B?VlBYTFR3YnFkRTFZM2dBeWlpT0RUWWh5TkEyL3pVa2VrSVYxOU5ublNnbk1V?=
 =?utf-8?B?TG1adEFzMVZ4Z1NQNi9TZFBnYVhzdWNKdzZsdUlIZUFPL3hoQTd6RnJjMTBM?=
 =?utf-8?B?R21iVmdRS2M1VFBxcDZGUnN2MklOK2llL2NMTWhEWDlFbG5vdGhNRlhySnhX?=
 =?utf-8?B?a2Z2UldZdkowKythMUl4Nk55d25KR084alVMSXBqenhIY0IzdkJSN3FYQ2Y5?=
 =?utf-8?B?VVFlYWZCSllpcmYxL3k3WFExRUFqbVJEQnM2QWFZR09BeUdPMzZxaTNRUHY1?=
 =?utf-8?B?SVhWUVdianZsSUhoSEk2L2pZeVZ2cytHbkhYSkFybVBWUC8rc0hoUUVsUkYx?=
 =?utf-8?Q?XVcPSzjh+/kCOygm7qzqwEYCGqUvSrby?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlpWZjJ3MlQ1L2dKWmN3ZmkzTnZiR0xlcnZvc1EveGtVWW5oTEZ3NklRbWFt?=
 =?utf-8?B?TG9BSXhvUHZrN3A5RFc5T3dVdlo0TTcxYjVZVWxtNmpUUjZGWXZrdE5ieXdG?=
 =?utf-8?B?SVRBWmFCUGM3NUJlYlM1clZZNjJ2RFk2VnpVV1pKRUs3ODNZV04rNFF6T3h3?=
 =?utf-8?B?VnJJUjhEK1pWV0V4U2tqOTZHRFMyRHpyMVdIc2F1VGpGV2llTC8vVHhBWWlk?=
 =?utf-8?B?TjZsemlTNWRNK0k1SGFxN1lEZmpXbmkxRjhycU5SdjJLbFpvR0JLWkl2UFRM?=
 =?utf-8?B?cUZqeTNkSGhUcTJjNzVrU0xURVRaWGM0UHR2dzkvOGFXNWxYMkZ3Y085cXFZ?=
 =?utf-8?B?dFlPa0s5V1k2QUsweWk3VjNNWEkvMkRCdFc5cGpNTjZRZHRQTmNrS1VUNG9J?=
 =?utf-8?B?QXNkZmxNRWc5dm10bVYzdkpvUHhoNE5EbkVraE9LTml5dGxTcUhqTENDb3p0?=
 =?utf-8?B?QzFqcDJDMVZBOGZQT1JqUFZDaHkyVGxnOTgrVlFKb3ZhU0M1TzQ5ZFQ4b3dm?=
 =?utf-8?B?RVVTS2QrWkZDUXdyT3lEQTJabEdnSVE0RlZGT05icGppcm1hWHdVeXFvdmt5?=
 =?utf-8?B?ZmxkVlR3VnErSUtwL3E0bk83LzEvTkthS0RZTTBlRUh1b0poYUh4cmZRQ3Q3?=
 =?utf-8?B?QWsyOEt2eXNDaFNKaHN2UXJLQnFHVnBQSG0vdDhNQlF2dHlVN0JkVkZGazNv?=
 =?utf-8?B?OTZ5WUE3WmRBTHB0NDFwdjFZa3B1TTRFekpDZVA5M2hNNXNFMjdDT0k2N2JE?=
 =?utf-8?B?RzZWYnJzNzBBb2d6L24zc3RWTnRkSHY5b3IrVHFSWFhkNU04SlRDbUlvNmVk?=
 =?utf-8?B?MDRSKy81Mk12bVMwVVNoWmN0akxtNkxkb1ZQUFQ1QmozSlROMjM4Y1RDcDdI?=
 =?utf-8?B?Z0hiaVFNUGxhaVBUZlNNWmdhdVJReFJGU1B2QldWakpjWkdWV1NjUDRxY2pQ?=
 =?utf-8?B?TTRkNC9KU08vdjdJcnhPbzNoUUF6d2NGMkEvR2hCUDVTejdBcTQyb1VJVkJF?=
 =?utf-8?B?YmFLUGxzcDQ2VHE4c0hDaVNicGVJQ1o0alh3bVd5QnR1bHJDR3hwQkRpVTlH?=
 =?utf-8?B?U0FjekFSYm1zRWo4TXFNQXBzeU5pU3NMdU5NUno2amVTcHI5dkRKeWVuRE8z?=
 =?utf-8?B?WUZtUEV4T3hjWVZqWGpzUzFZaVQrRFUxUER3V1YrQzRYenpxUngrcnpKNE5H?=
 =?utf-8?B?WCtkZVhWWjhOMUdPZlY1MDRyVFNoZTduMUlzNzc0ZEZyZlV0MDNsS0w0czJq?=
 =?utf-8?B?RGNPWGFTOVd1V1luZCtDYmYxUytoV2owWmI3NVBtTW54TWdhaGo5MFdlWWdV?=
 =?utf-8?B?TTd0bzF3TTNLR3VnWEx4TmphNWVyNmhTajVrRjBkR096UXlid2xjTHBrcHVU?=
 =?utf-8?B?Qkh6TTNNYzNGSTJrdHc5QVJQSk94S2xTWUk0aXNpSUdPUXVQMG1lLzBCTmRH?=
 =?utf-8?B?UHFJbFEvZU5aR09QbG9lYjN5TktRa1NFWVgyK2V3VS9yZHR4NUU4RFRlcjdQ?=
 =?utf-8?B?RW4zTDBjMk9TU2JHMHo0MzJHckhHRHMxb2QwQ1ovWm1QWGFITnZ2ZlV2RUZL?=
 =?utf-8?B?Z1FpUjhpL00vOENxMU1GN0NiL2s4NjVTbXl5eVNwNWRLaTBkMFhSdDYrNVc3?=
 =?utf-8?B?VmRBcUxhaGNiMk1LaHhvRytQTnJhOE1yQVoyTVY4bnZyUUFqTWJwdUtXd0xj?=
 =?utf-8?B?eG41N0djQ096d1dNc2ZmcTEwOW5ZQkNBdzEvL3gyU1FlNGcydytiRFZ6QlZm?=
 =?utf-8?B?aEdNZDJ2dWFReU5GWlQzc21lOUtkUlVpTUJhMXVsbTM1clFLT1BFMlVWb2Vr?=
 =?utf-8?B?VTY5TzNkcEFGenBuL1J4NU5hQUZrdHJlME9JTUNwK0wvcGFsczg2OEt1akp5?=
 =?utf-8?B?dDhoL2hrNXpkNzZpMUF0T1RLb250RzVITXhxQTVKUkord2Z4SVo2QSs1REhz?=
 =?utf-8?B?YUJKMzRxakk5WG9qclRTeGIyTWhneUJ5SzZUT2RUTlEzdit0dFN6YS9jdE5a?=
 =?utf-8?B?czkyVGY0VnZCbFE5VG1IeWJwekNJaG56MDU0cnphbEZZTWxkcTFPNG0wUnF0?=
 =?utf-8?B?Ny9kVkxlSW0vNm5kZzgwN2pLVXBZRjFySWxPbWNYcnF4MDhQMllYUVpSK3dx?=
 =?utf-8?Q?GgR/LamWuYwY43AuUJPiZEpT4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f7c139-611d-4569-a6a7-08de324f5ada
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 09:35:54.4180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7/fdEK39BwEgQIx19mfMYbJ1IxVPh6n3ZZCjcFlJsOrftZmSKG6MRXYNkcdQYy1AskYsfBluOicuFOiTC0AgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8486
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 54C82C000A
X-Rspamd-Server: rspam02
X-Stat-Signature: 8i9pn47s67b6agsitdzkgsap8qcetdny
X-Rspam-User: 
X-HE-Tag: 1764754563-697363
X-HE-Meta: U2FsdGVkX1+W8piX1f6feZvaPl7tPt7UNfdFGT4FumbHiLvkLGqnmGUlJJwPdlldVzNV+kiwaV3FLqpHLJAhxM8yE7ksDwrQ0Ts+qlsdelWzaqW9y78iz1xciEvVAQblT2Z1pWqe4F5u540LknjLuWesBOA1BVWFbS/JZDBDbRcSBmt822PxdrSchSXGnFA/xtNVENUN8Whpo7ZCo3G/30sKeiAtbfgCypOE7Htt0L1baefZ47EgbjKM9y/oDtESctZdtwaerOrq3Jq8rgwqx9v4DHA1aQT6n8m3RrMc5sBA5A02oGfNpHDxgA2q3iSzRKuPltrJbdFJFv3YxHw8U2xTa0aT6B7CCXBC7ddlQjEgCkxl6RyYC1Xu7xkhfD0GhtBfZZ+PIZP7ST62Uti22DfJZDCtOBokEvSqdhUWmZHcTBdJhJub2CNBeRVMlf/dNIxHkxphGIaSoXVoAN/SC4wPfvEwUOpmunK8QU/DrxHrpvzw+PPcbr/Bl7LWzWBFJG6lSXzJ7sCFIH1bGavkpbvOPQfVL/aikSOfeFqjSmbcWIsL3x2KVWmFoDIiPsTOFXLId1hi0wyY40Jj4trCV/ZySCEXe5hNILNkzpIUDBJe4Dp6xy8liLGC7T8R9idvjzq1qY1sRmQo90f0rP/Bcolm87hE1Tx1k4qJSKBa1jJq7XTyc7Wjcb0LW6lqnKM0yeUzTFAzMJTsV6NcvxDIO9lfwswig+bDyDA9xW/kbcw4amH2yNilOruNcyRKkKoNXd2Yn6J9GTon/IFisLPIqNMSSfFLu3vhORwjIIonuCTvgcu5W3MNNCn0IEFjHltFtvFKaqCyTkte41t1QlYslhVoACo4OOQeBWrYxFqcz3rp9Xll8nLCT7/sGhqMM2wvk6NnbKjoVP4WKjRdqFzk0BqC4+rEdYiKfzgCQ02X/LY7eZjKkfzhNHu2zMQdCjFSx9GAjVWbAmGU6zZ8LJA
 0bcEQOSo
 b4XrYs8dYzU9PI3ILoINpm1z1YP3ZUJEU6ug9qWqvfELi5cEuucDd/Nmc0qOghEsV3HKE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/2/2025 6:57 PM, Mike Rapoport wrote:
> On Mon, Dec 01, 2025 at 07:54:34PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/1/25 14:22, Tianyou Li wrote:
> ...
>
>>>    void remove_pfn_range_from_zone(struct zone *zone,
>>>    				      unsigned long start_pfn,
>>>    				      unsigned long nr_pages)
>>> @@ -551,6 +577,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>>    	const unsigned long end_pfn = start_pfn + nr_pages;
>>>    	struct pglist_data *pgdat = zone->zone_pgdat;
>>>    	unsigned long pfn, cur_nr_pages;
>>> +	enum zone_contiguous_state contiguous_state = CONTIGUOUS_UNDETERMINED;
>>>    	/* Poison struct pages because they are now uninitialized again. */
>>>    	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
>>> @@ -571,12 +598,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>>    	if (zone_is_zone_device(zone))
>>>    		return;
>>> -	clear_zone_contiguous(zone);
>>> +	contiguous_state = clear_zone_contiguous_for_shrinking(
>>> +				zone, start_pfn, nr_pages);
>> Reading this again, I wonder whether it would be nicer to have something
>> like:
>>
>> new_contig_state = zone_contig_state_after_shrinking();
>> clear_zone_contiguous(zone);
> +1
>
>>> +static enum zone_contiguous_state __meminit clear_zone_contiguous_for_growing(
>>> +		struct zone *zone, unsigned long start_pfn, unsigned long nr_pages)
>>> +{
>>> +	const unsigned long end_pfn = start_pfn + nr_pages;
>>> +	enum zone_contiguous_state result = CONTIGUOUS_UNDETERMINED;
>>> +
>>> +	/*
>>> +	 * Given the moved pfn range's contiguous property is always true,
>>> +	 * under the conditional of empty zone, the contiguous property should
>>> +	 * be true.
>>> +	 */
>> I don't think that comment is required.
>>
>>> +	if (zone_is_empty(zone))
>>> +		result = CONTIGUOUS_DEFINITELY;
>>> +
>>> +	/*
>>> +	 * If the moved pfn range does not intersect with the original zone span,
>>> +	 * the contiguous property is surely false.
>>> +	 */
>>> +	else if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone))
>>> +		result = CONTIGUOUS_DEFINITELY_NOT;
>>> +
>>> +	/*
>>> +	 * If the moved pfn range is adjacent to the original zone span, given
>>> +	 * the moved pfn range's contiguous property is always true, the zone's
>>> +	 * contiguous property inherited from the original value.
>>> +	 */
>>> +	else if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
>>> +		result = zone->contiguous ?
>>> +			CONTIGUOUS_DEFINITELY : CONTIGUOUS_DEFINITELY_NOT;
>>> +
>>> +	/*
>>> +	 * If the original zone's hole larger than the moved pages in the range,
>>> +	 * the contiguous property is surely false.
>>> +	 */
>>> +	else if (nr_pages < (zone->spanned_pages - zone->present_pages))
>>> +		result = CONTIGUOUS_DEFINITELY_NOT;
>>> +
>> This is a bit unreadable :)
>>
>> if (zone_is_empty(zone)) {
>> 	result = CONTIGUOUS_DEFINITELY;
>> } else if (...) {
>> 	/* ... */
>> 	...
>> } else if (...) {
>> 	...
>> }
> If we update zone state outside this function it can be even simpler:
>
> 	if (zone_is_empty(zone))
> 		return CONTIGUOUS_DEFINITELY;
>
> 	if (nr_pages < (zone->spanned_pages - zone->present_pages))
> 		return CONTIGUOUS_DEFINITELY_NOT;
>
> etc.
>   


Thanks Mike. It's doable, consider clear_zone_contiguous moved out.

>>> +	clear_zone_contiguous(zone);
>>> +	return result;
>>> +}
>>> +
>>>    /*
>>>     * Associate the pfn range with the given zone, initializing the memmaps
>>>     * and resizing the pgdat/zone data to span the added pages. After this
>>> @@ -752,8 +821,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>>    {
>>>    	struct pglist_data *pgdat = zone->zone_pgdat;
>>>    	int nid = pgdat->node_id;
>>> -
>>> -	clear_zone_contiguous(zone);
>>> +	const enum zone_contiguous_state contiguous_state =
>>> +		clear_zone_contiguous_for_growing(zone, start_pfn, nr_pages);
>>>    	if (zone_is_empty(zone))
>>>    		init_currently_empty_zone(zone, start_pfn, nr_pages);
>>> @@ -783,7 +852,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>>>    			 MEMINIT_HOTPLUG, altmap, migratetype,
>>>    			 isolate_pageblock);
>>> -	set_zone_contiguous(zone);
>>> +	set_zone_contiguous(zone, contiguous_state);
>>>    }
>>>    struct auto_movable_stats {
>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>> index 7712d887b696..06db3fcf7f95 100644
>>> --- a/mm/mm_init.c
>>> +++ b/mm/mm_init.c
>>> @@ -2263,26 +2263,34 @@ void __init init_cma_pageblock(struct page *page)
>>>    }
>>>    #endif
>>> -void set_zone_contiguous(struct zone *zone)
>>> +void set_zone_contiguous(struct zone *zone, enum zone_contiguous_state state)
>>>    {
>>>    	unsigned long block_start_pfn = zone->zone_start_pfn;
>>>    	unsigned long block_end_pfn;
>>> -	block_end_pfn = pageblock_end_pfn(block_start_pfn);
>>> -	for (; block_start_pfn < zone_end_pfn(zone);
>>> -			block_start_pfn = block_end_pfn,
>>> -			 block_end_pfn += pageblock_nr_pages) {
>>> +	if (state == CONTIGUOUS_DEFINITELY) {
>>> +		zone->contiguous = true;
>>> +		return;
>>> +	} else if (state == CONTIGUOUS_DEFINITELY_NOT) {
>>> +		// zone contiguous has already cleared as false, just return.
> Please no C++ style comments.


Got it. Thanks.


>>> +		return;
>>> +	} else if (state == CONTIGUOUS_UNDETERMINED) {
>>> +		block_end_pfn = pageblock_end_pfn(block_start_pfn);
>>> +		for (; block_start_pfn < zone_end_pfn(zone);
>>> +				block_start_pfn = block_end_pfn,
>>> +				block_end_pfn += pageblock_nr_pages) {
>>> -		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
>>> +			block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
>>> -		if (!__pageblock_pfn_to_page(block_start_pfn,
>>> -					     block_end_pfn, zone))
>>> -			return;
>>> -		cond_resched();
>>> -	}
>>> +			if (!__pageblock_pfn_to_page(block_start_pfn,
>>> +						block_end_pfn, zone))
>>> +				return;
>>> +			cond_resched();
>>> +		}
>>> -	/* We confirm that there is no hole */
>>> -	zone->contiguous = true;
>>> +		/* We confirm that there is no hole */
>>> +		zone->contiguous = true;
>>> +	}
>>>    }
>>
>> switch (state) {
>> case CONTIGUOUS_DEFINITELY:
>> 	zone->contiguous = true;
>> 	return;
>> case CONTIGUOUS_DEFINITELY_NOT:
>> 	return;
>> default:
>> 	break;
>> }
>> ... unchanged logic.
> I was going to suggest rather to drop 'else'
>
> 	if (state == CONTIGUOUS_DEFINITELY) {
> 		zone->contiguous = true;
> 		return;
> 	}
>
> 	if (state == CONTIGUOUS_DEFINITELY_NOT)
> 		return;
>
> 	... unchanged logic.
>
> but I don't feel strongly about it.
>   


Got it. Thanks.


