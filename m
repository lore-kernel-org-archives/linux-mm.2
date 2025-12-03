Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 791DAD15DAD
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 18:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4016B0026; Wed,  3 Dec 2025 13:07:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84816B0028; Wed,  3 Dec 2025 13:07:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25B96B0029; Wed,  3 Dec 2025 13:07:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7EB6B0026
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 13:07:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4470CC04A6
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:07:58 +0000 (UTC)
X-FDA: 84178943436.04.0F430FB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id E19768000B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:07:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GCNw2Fb9;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf02.hostedemail.com: domain of andrzej.hajda@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764785274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vL2qVYDP4+d6Rg2x/ki5lu0weajro7+v4gtvCjYNjd8=;
	b=MXI43zBIwtojQlLYlXvCg3vqosxnukVXO2RDbP2Y6yMka2IY0xJQ/EjjCjq1JLuBMSng6U
	Ra9inJpqxDVfdUSBlt1Aj3W8DTxSTNdBIe6fab5mqqHUDG3olyxy/yIzw9jNwyzO5SvxE7
	iGeOpuKtdiTEtgcP2ch7afbnxnMQzjE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764785274; a=rsa-sha256;
	cv=fail;
	b=EMUgRGDATU/JKSv1GSjEVVg1xJ9DJlNXGlosEH0okXN17L4CiYNVOcAZ/iWBPxUh6C6QT4
	0DRM2MMcf5e4YZ0nNmTmGZw91xzW+qpb2rxu6XTmTobX6/oVK60zSH08naqGaj47Yltuck
	IIiS+sNH3/lhYn+fI4l3mWIGWu6Ynbk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GCNw2Fb9;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf02.hostedemail.com: domain of andrzej.hajda@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764785275; x=1796321275;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l6bcAJnfXp2pyo064xnuWpahka3YuBxOsZ85mlWf7uE=;
  b=GCNw2Fb9IDgOTx61C7ku3lxoSiRx2X/z3jy+WVEnlztO79m25RxJyb5J
   VqCvpfDrkhA0iiy1wnOdbYXEdrUG0lvf21SO2XtFUsEP38t5l+ykoWS92
   AZ4sYvAb/LNufqH+cYuVTeGXWHuRZ3q+mWMutS5soSE5EUzGJ8wmpSUS2
   XLPBhTSleV0jR5AlYGVqxX/JAXHlnP5H9bwoK+TRvHkvGhatM1ij9kSih
   PoqAnyJu5P4Kzo6I5fJB9FtxZV0gsA6B9R41fEN9m9wjAj9YIuDZ1NWnW
   eTHSpqMXR0fAKLveQB1PTt10kAEjuDgn2dyfjv28e1j/DPw51BUgfotg8
   Q==;
X-CSE-ConnectionGUID: JEKD/jTlQomy/JlVOqowrg==
X-CSE-MsgGUID: QSWkE1fzTOaf61uQ7Umhug==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="78255802"
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="78255802"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 10:07:37 -0800
X-CSE-ConnectionGUID: X6jWKrG6R9SyBXIkLIVXNQ==
X-CSE-MsgGUID: Ko8ILIznRSupHTrcjhTnyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="195001966"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 10:07:34 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 10:07:33 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 3 Dec 2025 10:07:33 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.44) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 10:07:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tpIBaAMaHblM8j1ltsuRL3IZ+33sRw8ysYRwug1hO0ChiUgHItBJmgSvmg76A31WW5VXi4pXr9VB7a44rlOK7lLDRtmn/jJpq83JSMs7ISqJ2xC8c2gROlRKlQuZXxDpLoBQfzum1jTU996j7E5w+xcf/1rBa4M4w2/DyW8AjwnQcH6JyWS465hYT3JDabephBJMsDd4VZdX2tvSG5rlE3rkFgiNdSObLSnzaFcXF5vWNxeipW+GieSg7kIso9qCQBM5ep6LCq9kkt7Pa4rCX+6teH2+avGw0UuSzmIy7LwmyhFYLOGS+aDCbyh/sUBWPgkObVCYl6eCbYSZ58KUBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vL2qVYDP4+d6Rg2x/ki5lu0weajro7+v4gtvCjYNjd8=;
 b=kNklCZInW3eoXJ9CM6OEKcBmaSHIUbQ/YqR8yNmixJ7o4pmYCqbpqC4eVkegHFPs4Pj05dhNO+fKRTMdGtJqx5f+WA35ClAMpl9rJThDDYw54VSHq0KGSqB5kNL5wOY0YnCirhgBFzORMSpdBNsyXglQuJ5EMGgA4O4NcXgMmnmKKPV/KBBxXL4Jy9SkbFNIrxqwbuGEf96Lze+mwH7BRf162zoSos83IpEqOOTxiO4pP9D0VWOGlnY0b84stqcQpByB7U5IqNGiFEW3z3VRoLChD1twtftGmy3s9qR1I2QDTpFZgom09X1KwmM8W5YmhBfRZr6ojZx6MAGekgkC0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ5PPF7DCFBC32A.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::839) by SN7PR11MB6945.namprd11.prod.outlook.com
 (2603:10b6:806:2a8::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 18:07:26 +0000
Received: from SJ5PPF7DCFBC32A.namprd11.prod.outlook.com
 ([fe80::e17c:d0f4:db8b:d7e6]) by SJ5PPF7DCFBC32A.namprd11.prod.outlook.com
 ([fe80::e17c:d0f4:db8b:d7e6%3]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 18:07:26 +0000
Message-ID: <1e4ec35b-41d7-48df-9ae8-4fef77f7b291@intel.com>
Date: Wed, 3 Dec 2025 19:07:17 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] drivers/core: simplify variadic args handling
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
	"John Ogness" <john.ogness@linutronix.de>, Sergey Senozhatsky
	<senozhatsky@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>, Christoph Lameter <cl@gentwo.org>, David Rientjes
	<rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo
	<harry.yoo@oracle.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <20251201-va_format_call-v2-0-2906f3093b60@intel.com>
 <20251201-va_format_call-v2-3-2906f3093b60@intel.com>
 <aS8K5DnumUA6XUs9@pathway.suse.cz>
 <94c02fb2-3407-4efc-a80f-305140e64b94@intel.com>
 <aTBNj5HEfejyW5TK@smile.fi.intel.com>
Content-Language: en-GB
From: "Hajda, Andrzej" <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <aTBNj5HEfejyW5TK@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR10CA0094.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::23) To SJ5PPF7DCFBC32A.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::839)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF7DCFBC32A:EE_|SN7PR11MB6945:EE_
X-MS-Office365-Filtering-Correlation-Id: 82c1ec8a-361a-4bac-f07d-08de3296d0c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cndpbU9BMWhieGtscWhlQXN0MnplSld2akJrUzIwRElsSDhKeUZ5anRHbjFy?=
 =?utf-8?B?T0lsUGpad25YRS9IaEZFVDJMV28vMC9UZUE4Z2ppc3U5cWVmcG85L20vR0Jx?=
 =?utf-8?B?a3g1R3o1U2d4T0xKTVlYRVhmS2FWOUZvY0FQSlpDYnpnc1hydG81VllCeFVW?=
 =?utf-8?B?cEw0Ti84eTcxNzRqa3JCellGbFRZT2RqNjY3MDU1M21reSs4Wk4rZ2pFb3Rt?=
 =?utf-8?B?Z1Z6RnZlQjZ6cC9xUmx2Z1hoOUpCVVI5elJqcjhaUGpLK3UrVm5UUUJUTUtk?=
 =?utf-8?B?V1hEUFh5SWg2VEpYM01zc0I5ZWFwbWFHbkxOQ3Z3L2s0MUJzRGlOdWVHUjRD?=
 =?utf-8?B?cWE4SjdhTXdZSC9OelBzN3JDbUVJUjRKWXF6bEJ2V1Zvd0FJNG15TEczalNl?=
 =?utf-8?B?YkwrUktCQWpZK3lkR3psVnRWZnFwZjMyYWY3WjhNV1JKaEZ5aVpsRy84Z1Mv?=
 =?utf-8?B?SThDT08zd09mK1RKM0tzaFNvNHNndGZobFN5eEFFeDdxUzJJR2tuTm56YzZi?=
 =?utf-8?B?S0RYMWRWc3dkK3oxM1l0eXNIRjVrL3ZXdVAzV2hkWHhHblJLRWVPSk81czN4?=
 =?utf-8?B?YjAvaVJFVTlURGpBM1ZJVWVzbzNSZUJ0L3VRbm5CZ0dyakhsUkFia01wbkhB?=
 =?utf-8?B?ZmVNemdKa09xemlYRSszbitIM0hvMkw1UDFQTnQ5eWJyZGZwbTl0ZTBVZGRW?=
 =?utf-8?B?TnJHQTE4SXBSZEhjZDhlRy9sZ3oyNzNlK1VmWkkxbC9HUjAzVzhWbzlneDdT?=
 =?utf-8?B?UDhWcmEzaUJjbldBTlpCNUNacUJyVDlVVW1UNlAxOStvL2V6QVpZRk5SdGw4?=
 =?utf-8?B?TFp6SlJ1RzJTbXQzR1c2akZIbDVFN0RRS3pHbnVKVUsySlF0TU9xUFJoT2Jk?=
 =?utf-8?B?VGVVUDZZSThvSGt5YXYyOTNQZUlTMVd2WlF2YktZUkJtdFdocFQ3UlFGRlNK?=
 =?utf-8?B?S1hiREVJT2NtU3VRQ25nV3d3UU02dlJ0alRuTTBGTVplOSs2V2g3SitNaHZm?=
 =?utf-8?B?NHlnRTVCaGNISFZLb0dnMWNvc00rdTZNb0Z3MjY4SHpwRUd6S0xPYVJWODhn?=
 =?utf-8?B?K0JwRThCTW4zNk5XZ1RvdXgyMWxVVERURU5rTkJxcWZTQ3Bwb29NTWpzdXFY?=
 =?utf-8?B?NXozRUd6OTBvaXlNWXlkdDdPZTJMditnNmZPa0J1c1pDck5WRjM0aDNha1Bz?=
 =?utf-8?B?aDBpNTZEeWFoUVZkSzBUcy9wZ0c3S2p5Z1hoVzVqS0huUE9naFJuNm54SnhH?=
 =?utf-8?B?TWZseGJLT2dZK0hUbEptc01mUlkxWllCUTBUNFJhZ0tNVEh5OThON0JNZk44?=
 =?utf-8?B?NmxJbzM1b2MrYVhiU0xMaHdhdWtQdE56M3hrVGlQZjVpSG9xYzRUSjBibWdU?=
 =?utf-8?B?bUxUNEh2U0hxN3luR2FxYTExcDdya0poMms1NHdRUkh2YmR0WWc2RGVjSTcx?=
 =?utf-8?B?YXBYQ3JkNWM5T1VSUmNYSkpVck5sR0REbFdVck5pbTFKRkNXeHZmWWIyVHRr?=
 =?utf-8?B?OElacHlBZXhxRTlVeC9LM1daYTNsREh0b0x0U2o2L0p6bjRHMUdZM0JpR1BF?=
 =?utf-8?B?MzZzN2o2cCtmZXZob3M2UDNGUDR5MWxmM0h2Wi90VFZucnh4OFE2c0RJLzZS?=
 =?utf-8?B?Z2ZUUDdNNFh5Z2ZxVTM2ckxMS0tkYjJXeHp5VnlVRlVKaitkUXJDUnVKZkhw?=
 =?utf-8?B?WG5kTjBTL0ZPRWhpQ2RaaTV4a0E5aHByYnNxL1VYN093d2FyUzB3OEtZMkI1?=
 =?utf-8?B?SWNNOE9zRUEwcVkrTDRhUmhOQk50NmkxTmF1eXVPcUJZSEJqN3RJOXZZTTI1?=
 =?utf-8?B?eXJaNnNUKy9rVFpHdEJBaGFaTC9vR2hjQ2lCaGFCU2o4akZvWWMxZnA5QmlX?=
 =?utf-8?B?MjZ2VVZjWWJnZGR0WlU3MHBmNzlhUk91emVVSzYzbVkxN0tFVGk3Zlk1ZmVI?=
 =?utf-8?B?QXJ1T3YvRWY2NzBsTmZBZG5RYXRJK2IzdHpvNEsyNzNxemFvVlR1UDlYTmFE?=
 =?utf-8?B?ME5QQkdEQTVRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF7DCFBC32A.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1VhTE5HZWZzaGlnSysvZTRGUk9wNCtveU53aWJHNUZwQk1seTFKVnp4SmR0?=
 =?utf-8?B?bU9nRVdNdGZBQUdZKzdseXFFc1g0N2tjaDlJQmlZZE56eHplRlg1Z0gvS1Fq?=
 =?utf-8?B?NXlIMnpSQWdtc0NNNTlXM3hqNzh1aldEUjlvVUV6eUNZM2RYaHl6TzJSTTlG?=
 =?utf-8?B?QUlWV0RkNklwa3pDb3YvSFYrcTllYlZUdG4xZW5tc2ZseFRNTzBaVnc3Y1Bv?=
 =?utf-8?B?SG1JaFRXa0lPdHBpcE9GQmMxd1ZuY0RxRXVwd0xMZXhQQXRMMmdiZDJ3RGM5?=
 =?utf-8?B?K1RsWFN3Uy9GR21iN0YwUFd5Z3JMU0VVQWE2cTdLTDZVR1ZlMzdtNW81cTV1?=
 =?utf-8?B?blo4Tml6dmh0TjF3TEFsV3FISGFieW41RURYNFlqSDlwYk9rWmFZelk5V29i?=
 =?utf-8?B?Qnoxa3NhcWdMYW15S2hXSDN5ZmtQR1hXY3h0ZDlUZGdLUExhUTFqMmZSdG5M?=
 =?utf-8?B?Ty9DMmprSU9pTFpOS2FmdG5vZFlnZ2NwZ3ZMRFF6YzF6TmVJbDlJZGdqTjhF?=
 =?utf-8?B?VFZ3VFhDREFLTEJXWU9zZDA0Y2ZUMkRxTWhGSU1QYks4Q3NjdElHejVOSUFE?=
 =?utf-8?B?eDQzc3R3RjhHb2NrV251Q0NBWEVQb2w0YVo5MGx5RXJwVmdDK3BPaWRPdDBV?=
 =?utf-8?B?QXpxSmErNGJCYlE1SVBRbUg2cW1wV2UxM21IaFNwOVZuOXJOV1NPNTdueE9w?=
 =?utf-8?B?cGsyQWtZdHhONnRhWTNkUDh5SWc2Y2pOa1ZaOTF1WmdDK1c1RkRTY1lDbyti?=
 =?utf-8?B?SVprdlMwVElEQkhFU2dqUWRUWE5DWkpJeGt5cVg2RVlRcW9WeHJES05uRUZM?=
 =?utf-8?B?OWE0MjhzQXZZQnFtVjZ1eUIxZkZ5UDZmdmdaS3pXVXlYcW1sZTVqdlBDUi9O?=
 =?utf-8?B?SHd2aUZUOVhET0w4OHFTR1lRT0xaS280UVZIVXNVMUdSdmpxMlVqeDJSSVhZ?=
 =?utf-8?B?OUZCOEhneTdUbGh0NzZFQlF4a01oTEZXOHhhYmxxN0RTc1B4VStuQzgyRk1i?=
 =?utf-8?B?TEppTXZVOVNPK1l2UHh0dC9pbUsyUkFQWDJWdmJPZG1pR2w0UVVMejFMd01x?=
 =?utf-8?B?c3VhY3ZXVHlzOFdnYnYrOFNpNVZ2aW9rV2cwSTZiVVViYXpyd2RVK2JJV0s5?=
 =?utf-8?B?VVZtcUwyRHFHL3pPb2g5NitCWXBrTkwzekdPaElMd0hnZHkrSnlKRFRjWDIy?=
 =?utf-8?B?Vi9yRlFPankvcWZiSm1ZbXB2dytYS0NUczJmaTU1QzZGUTA1ZnMycTlnVE82?=
 =?utf-8?B?YmlDZmVlZTk4eVptZ1pET2daOThGQlQzekZIZTd6RjZabDJndXBFd3pXMXU0?=
 =?utf-8?B?cTlZSWdqZS82UUFLaHNqYVFnbHdtUjlPRzlxOUw5Um93enJMcFMrc2ZLSzk1?=
 =?utf-8?B?ZHJNdHhZUzdQWHEvR2V0bWI2R3RIcENuZSszZHVkVy9pY050ODhCOHNaY2dG?=
 =?utf-8?B?ekRGSUlCQ2lEaUJ2K1prcElma1ZJZjB2NTJZNXl3MG1hdm5nN3NXVE8vT2dT?=
 =?utf-8?B?UUxUYncwaHdLVmdFcXNobWloZXl5MElqSlU1em9DMXlGTDFoMnpWYkFQc3Nk?=
 =?utf-8?B?eXFySml4Qk11VXBIZVFXUUc2VHp3dVJVYlpXT0l6Rlg0Q1lZdm5pZ29ubW03?=
 =?utf-8?B?ODRWbG90Q2RVZk1wU2hPb2VOd2hYb09wUlZQa0ZvanZBWWQwUnhkUzFLeks1?=
 =?utf-8?B?V1R0N21GY1JPenBlVjkyc0IyUzR3N0YxWXdDS2RKendVakZwd1dMQ2Racytj?=
 =?utf-8?B?eHdHdFB4ZDN4WGhIV3dMYU0zRlJ5L3ZWa0QyUVRZcC9TMzVtM2xpM1FMSFRl?=
 =?utf-8?B?dkFUNXV5WjNaMmpydlE0cHBzcGZBdTUyQUpJWHhuZUpjREo1eVVMOHdyQkQx?=
 =?utf-8?B?cXVwS2ZORmVVQXBtOTlsWmhkV1NBTXJqMnhBWnN4VHA1b1FZUStoMXExaHZ4?=
 =?utf-8?B?UEVubDQrem1rRW5rOGh3aURjZ0g2b0NDVVVncGhYRmFzbXNzYXQ1Q1NHNlA0?=
 =?utf-8?B?RGxyUnRrc3J2MGl6bE9NZ28zZlBaa05Db3pQRFlJVmZ4NDBpQ0M0dlFtS3Vq?=
 =?utf-8?B?QXd4OEJTTXFnaUxxU00rRkZSYVcyUmxVYis4MzlUSGtSeTAvR1ZFdlRnMFB1?=
 =?utf-8?Q?ZDe3rXkOWLCFvT+qVn4t/CouQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c1ec8a-361a-4bac-f07d-08de3296d0c0
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF7DCFBC32A.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 18:07:26.5086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PV6I4bTGb2vPMOweIZweR3AgCKSUjxjrceAfzpyNehD3Cxa96S1n5GBc9xl70R4LGj9W3O+tfUrGgHNbgG0Jcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6945
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E19768000B
X-Stat-Signature: keoiqojojmr5csy9c1yxpxr8zonus6bs
X-HE-Tag: 1764785273-774339
X-HE-Meta: U2FsdGVkX19hVthl3w6CZcBXMT23zW0NeSvL7q1vJmqsLm/4151V6Zl3q5BKxY+r0aH6R7E03YUf6iBZ53ivXOzj9fOK7utYa984PLeOQcG11yA6kBRUD02aTIxLvqAk32oLBkTJg69vejAZUfyejrPrnD9fGkCEKMnYjWNdJIjI/b6C8AzsAWA2WLShhOgmtI0upbN7tE+m/ns2MqrNLIkXKotq/btcunI9QGoNLPth3vEhC3syKDISFULnBOMOObAuxiNdcPYlarQUnAF/cE1rEonuDNYTruulqJgntNVnNJa7qKGTGdYgfGOEwYgbQpTHbdNUYo+eqlDTWqmY/+HZIny3VNqe1rFehQBAvIWNUVWd+LkV/Y2qmqU1WR5VOGsKEjFDwqDCAfH2HcxpKn2CFG2wZaXAn7M5XeW9esRfJB/akZzE3hU1DF83ywmcrWWk50HlURhaILsLJWKJbyWlMGyoLpI+/26Nq2fwFiBczEw1ZOqpa2qD5HI7J1EpwVAIIS2YAc5Ow/EsqisKkQ9nH219SnH7LY8CtqaACQaAU82+LGeZHcYIBX0aRvmai5weuMQhhBxWl69MzLnC1DSgu7dKcH+G+ZordHGFVNkdTP0bFYEeiFxG1+1SZI9Wks+ZPJyQsaYzdMTy828yWGj4FVh5QaZzJrac2rkRAMmdp/1FC5ohwaoIxZa2+CQPLrXmMElASjHEgeiIzrTYTUwLVZvAqMRweQv/DOPBq0qDvkd4XJwRxe2d0Qih5/NfF8z8s3Tv/I08+Qm+hjQiqh3lcg7A+pz2AZL5cLNGIZvfrWPPHWfLYyrbO/S8uT1q69/NREQSj2pldvmKOhX6LT63ZYYiNLxnIslChp68zhnR+GkMv52qKj066/qhoQcJtokHkSXYQL4NDGjoaZqGRwo0n8+IwtFIU6UBTunmUeZXrx158UpgRu4VvEQN9o79TbuQIu4Ms5z1i2zZPnn
 tSXwkGSY
 7JBXBjkZeU2/eijzIZ8cev3YhhYxb9M7fuRVaDjmf5VBOFUAACFcadxfFL2jd+PXiUQ2BR4tq4VyD3Ud7Jw66kwPi6vnEIc/vxzIbnkVprp6AdqFhh1pjI3dTD8whqMBWpX/bVps9J9zDbSYr2cEbJBJo59AtA3U7A2tYJoTMcqHu4+WkoGfuyQpagA24f+yt1FYXMMzBv3TfX/f1CnNNfro7L3yoN8if3DUWgGex/09Mji225PHtdtV9IOggvP8jW9dzeu9LcvrPZWdiDL8XLcO+E1qOfNIEcS1yrf5Zv+K7IDMtFSziY7OZigaD6cMC+AP7a6SOvSbletjt7jvO2ATb3pEUUwbgaoWq7dSLvlQ+6TW2LAzrjtVN92NYv/MpneP9P2lEUes4uzMj1S3usstybxx+PdJNyhmNMUl/NU2Q8ck1kkz5HuskRkAlK8U+MzX5iecB6hKxTmo2aJmIS3OGlcP+uW23W7Ril1WFRmgjYNLaq7DwD816BDYUPPCbsii0uCmLJcZc+tYTLsq0JdqS9+zAAq4DD4JFTsiKjq4GaO6e51Zl0xNz0TEvdnVHEzhc3hATuXZUqTjVevA6QZwVEUyvEhmsiGzdt3AN7LCFUy2sLrkFGgPEEgcuxDI+kf7vBY4XVOFGLZt4d1XFymZbNONmYovE2Q1kpdjrjHzp0gng6xnjXgf4/aG8gpQiSl7Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


W dniu 03.12.2025 o 15:47, Andy Shevchenko pisze:
> On Tue, Dec 02, 2025 at 07:03:37PM +0100, Hajda, Andrzej wrote:
>> W dniu 02.12.2025 o 16:51, Petr Mladek pisze:
>>> I am adding Andy and Rasmus into Cc who are active vsprintf-related
>>> code reviewers...
>>>
>>> You might see the entire patchset at
>>> https://lore.kernel.org/all/20251201-va_format_call-v2-0-2906f3093b60@intel.com/
> TBH, I don't like the result. There are two problems with readability:
>
> 1) macro well hides the actual low-level call, hard to parse from its
> parameters;

I hope 'va_format_call' is a strong suggestion that sth is to be called.

>
> 2) sometimes it has va_format_call(fmt, ..., fmt, ...) which is confusing.

Many functions sometimes takes the same argument twice.

1st argument is to indicate beginning of the '...' in caller function 
args list, quite natural.

2nd argument is function name, and the rest are it's arguments, quite 
natural.

Since C23 standard, we could omit the 1st argument [1], but this is 
potential future.

[1]: https://en.cppreference.com/w/c/variadic/va_start


>
> Implementation is also doubtful (to me) as GCC extension. Can't it rather
> return an error code and use something like do { } while (0) inside? OTOH,
> may be this is not feasible in a clean way...

???, expression statement "({ ...})" is present even in macro samples in 
kernel coding-style [2].

[2] https://www.kernel.org/doc/html/latest/process/coding-style.html

>
> And what is the motivation? Just make less LoCs?

Also, but first:

- encapsulate common repeatable pattern into one macro, with clear 
purpose - forward variable args to va_format aware function.

- simplify handling variable arguments: it is easier to write single 
line instead of ten, usually interleaved by other declarations and code.

Is it so hard to see it? Have you seen other patches - quite good examples.

>   I would really like to see at least vmlinux sizes,

What for? This not about binary size optimisation.

> the reports that GCC _and_ clang are both happy with
> the compilation as of `make W=1` of this on both 32- and 64-bit cases.


I do not expect any problems here, but will check :)


>
> Does it solve any issue? Does it bring any consistency or standardisation here?

No. Yes.


Regards

Andrzej


>
>>> On Mon 2025-12-01 10:31:24, Andrzej Hajda wrote:
> ...
>
>>>> -	/*
>>>> -	 * On x86_64 and possibly on other architectures, va_list is actually a
>>>> -	 * size-1 array containing a structure.  As a result, function parameter
>>>> -	 * vargsp decays from T[1] to T*, and &vargsp has type T** rather than
>>>> -	 * T(*)[1], which is expected by its assignment to vaf.va below.
>>>> -	 *
>>>> -	 * One standard way to solve this mess is by creating a copy in a local
>>>> -	 * variable of type va_list and then using a pointer to that local copy
>>>> -	 * instead, which is the approach employed here.
>>>> -	 */
>>>> -	va_copy(vargs, vargsp);
>>>> -
>>>> -	vaf.fmt = fmt;
>>>> -	vaf.va = &vargs;
>>> I am always a bit lost when using this API.
>>> Why is it safe to remove the va_copy() here, please?
>> Not very familiar with this workaround, just my thoughts about it.
>>
>> It is just va_list is compiler's private implementation, which can be
>> anything.
>>
>> And if it happens to be T[1], it's type decays to T* if it is type of
>> argument of the function.
>>
>> So vargsp is in fact of type T*, and &vargs is of type T** and it does not
>> point to va_list anymore.
>>
>> So in short passing va_list to a function, which takes a pointer to the arg
>> is problematic.
>>
>> va_format_call DOES NOT pass va_list to a function, so it seems to be safe.
> I'm sorry, I can't be helpful here, as I am not well familiar
> with va_*() stuff. The idea is interesting, nevertheless, but
> see above.
>
>>> The va_format_call() uses va_start()/va_end() which is replacing
>>> these calls in dev_err_probe() and dev_warn_probe().
>>>
>>> It is possible that the original code was actually wrong because
>>> it uses the same copy (&vaf) everywhere, see below.
>>>
>>>>    	switch (err) {
>>>>    	case -EPROBE_DEFER:
>>>> -		device_set_deferred_probe_reason(dev, &vaf);
>>> This function processes the arguments via:
>>>
>>>     + device_set_deferred_probe_reason()
>>>       + kasprintf()
>>>         + va_start()/va_end()
>> This va_start/va_end is for var_args of kasprintf, not for &vaf, I hope
>> parsing %pV uses va_copy.
> Yes, it does call va_copy().
>

