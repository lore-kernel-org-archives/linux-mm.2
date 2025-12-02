Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DFF5D12661
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 18:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F206B0006; Tue,  2 Dec 2025 13:04:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526BE6B0027; Tue,  2 Dec 2025 13:04:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE416B0029; Tue,  2 Dec 2025 13:04:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2748B6B0006
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 13:04:05 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A33B51A02DD
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 18:04:02 +0000 (UTC)
X-FDA: 84175304724.24.D8DC687
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8C8B980005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 18:03:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="c//lsN60";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764698639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOFddPNgq0eK5i+ZXwJKukphBBCTUEexlwKkAmZXUu4=;
	b=mk9CfIUg6HP63EX6/v3sgSB2AQY7NKnbo5cuLFj21kIroPCYOM3b1VZNpnSlgpj4UNGzGY
	4dsQqYIIxye/537Uu+SJMk8GJWXDRymfc0LfXVvghuVrZgNryTTC2rbH25G4PnMzafdOVH
	Msjf+xtJzRyP7jCjcnkTMQtJ3o/VrSk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764698639; a=rsa-sha256;
	cv=fail;
	b=hKC/AZu0qHpQVoH2twZ49E1XtwCuS/4C1aJsdQ5SazavGIUuulhPO8PrR204k+W7gk9kiU
	riecIczeahoHX0UhvVECCBbiiagZTi0MJjDz5XzfBGCoVeLLncU6oOu4TeFF3tHu0UQctn
	juXT88QZyvJa0UmHXhuGragklAyZy84=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="c//lsN60";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764698639; x=1796234639;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UAqZc2hfo7sBF51knd+4+OTEYXbRxxIAv5ZR+uGZ2fk=;
  b=c//lsN605FouSTKqgNgXYFFjs6arHf9jnPcm62Z2nJT3Z7D64VYClHMC
   u3GdACb49sps77+eJVu4oJMGaI5Ty888dqOW8LoggK0CBVQWRPCerVMyl
   /f+PHC8z/ukQRFgonIOWWT1kLBFfTYHID5vs73AdnAjXjqicZr9RxoEs2
   Xoejy/WumkWnFX/UZmDAhlM4dbDwgldMGYy1RE8leUPh1rc7+vSeYs5IY
   Z+I/WTc2NMdjteMmPO2Xg+g7Hrt1mWfi0gfK4gztbY0XOmw88qWqx7NTl
   r2M4evW71JuHvwHYLuckVIGI1Sk5mHacZharHabYewK8s/OQx8I9b1V+b
   A==;
X-CSE-ConnectionGUID: nzwbr28lTMudNsvltXTl2Q==
X-CSE-MsgGUID: KpubkOSiSWu+yX+T6BgE1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66751617"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="66751617"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 10:03:56 -0800
X-CSE-ConnectionGUID: uH/asKCPT2eVt+d5I9rXkw==
X-CSE-MsgGUID: 1HDuDNv1SPWZza4dFXuq6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="198625649"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 10:03:55 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 10:03:54 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 10:03:54 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.48) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 10:03:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OGNPL67GOofW/iGmP9585nPgNesWXi9k5CnNsf+1wkclTM8ueek68dA7RfdlaUdklVR1NOxPsXJ5DYU8HFInV/xS62UOeoFfXIxs00rQzGXMfMeY8XvnTrm7j0YAiZlTQATg8zuVfpTeCziBVA769VM+TqCoThsl5/eg7plDnqGYk/grc4bm2ltC1ni1pIKRka+OV/RIe4IFAz82gcBRTReBt1Q6bTC0ZY8yuqOtpFajigCr5eBO2zFcHyTVWrNjbJ2BMPWStdKO8rEg/MtxBmaqmMYfIj8dTPdTCYHFMk/B/tQjyPPrwxbiczgqAX3LbZeGLhU79Yu6z+ZTTQBKHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOFddPNgq0eK5i+ZXwJKukphBBCTUEexlwKkAmZXUu4=;
 b=tH31pJeaWwmT/8NAMQDYDFE5RrI5DJ/9QVxiIc2QPgLRw9PDzArii2fiBz0Xo9Y/kQFY6fd0L67H1pCfLttEfzR9zrY+uyxkV6e+W3H1vHm8mbhMcaOMHCJGhHksjCthSwCaxZaaB02Kr09936iagWT1w32jm7YD6MK6oHqjTYXcdvvpMRVLZ3iG1QV/au3G9ccNSZQTiGVPyLpttw8dVsq/5V7dJ5s0V1sdqKQ56TcjB0thgMG1Psdsrdrl/PjQr1LRnTc039HZo1376pVJYM8w8qw/H9TJJtdHt6gWtPBABIbFRnoXj5zbZKJfbKgtKXbHAUok2TdrIwXpL+2NLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ5PPF7DCFBC32A.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::839) by SN7PR11MB8066.namprd11.prod.outlook.com
 (2603:10b6:806:2df::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 18:03:47 +0000
Received: from SJ5PPF7DCFBC32A.namprd11.prod.outlook.com
 ([fe80::e17c:d0f4:db8b:d7e6]) by SJ5PPF7DCFBC32A.namprd11.prod.outlook.com
 ([fe80::e17c:d0f4:db8b:d7e6%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 18:03:47 +0000
Message-ID: <94c02fb2-3407-4efc-a80f-305140e64b94@intel.com>
Date: Tue, 2 Dec 2025 19:03:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] drivers/core: simplify variadic args handling
To: Petr Mladek <pmladek@suse.com>
CC: Steven Rostedt <rostedt@goodmis.org>, John Ogness
	<john.ogness@linutronix.de>, Sergey Senozhatsky <senozhatsky@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Brendan
 Jackman" <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
	<ziy@nvidia.com>, Christoph Lameter <cl@gentwo.org>, David Rientjes
	<rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo
	<harry.yoo@oracle.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes
	<linux@rasmusvillemoes.dk>
References: <20251201-va_format_call-v2-0-2906f3093b60@intel.com>
 <20251201-va_format_call-v2-3-2906f3093b60@intel.com>
 <aS8K5DnumUA6XUs9@pathway.suse.cz>
Content-Language: en-GB
From: "Hajda, Andrzej" <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <aS8K5DnumUA6XUs9@pathway.suse.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR03CA0015.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::27) To SJ5PPF7DCFBC32A.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::839)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF7DCFBC32A:EE_|SN7PR11MB8066:EE_
X-MS-Office365-Filtering-Correlation-Id: 77792886-91e0-410e-fd7c-08de31cd23fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QjJxbkxxenRMak9Ddi82TTY1YTlQRUFBRmRsWUFUK1NxS3JiaGNtS00xU2lq?=
 =?utf-8?B?QkpQR0cxM016UzFuL1lSZzFxNUJEQVZBaVdXZ1BmMHE5Q0ROa1pWVVBPOHlT?=
 =?utf-8?B?NWdhYzlUVXRiV3p6ZWwvRDF5NG9ZWGZIT2F5VWtzbmE0NDQxRTlwa2dzYkZE?=
 =?utf-8?B?S1pXcmFLSkxaaU4yTzZENUlIQUVFaVZ4RHF4R3QycnQyYkNSbTczMFVBbEhq?=
 =?utf-8?B?UDdERmhOL01FbXdKalk2UkNsNHlCNnFrTlBnWWtiek1NQ202Tm9MeW00Q2Ru?=
 =?utf-8?B?SXpMOTVEY2RxdFNLSi9RcXp3OXBaMnhIaVBQQWpuTC9nSGtuZzFXeWdlbXhm?=
 =?utf-8?B?R0RmZzBTd2YxbS9qNzJZaC83d2VsM0o5NVU0dWcxdC8vb3JhQThJMDdLS04x?=
 =?utf-8?B?MTlQQXJxV0M5ZGNrQ1hZdVdPeFNMeW5LMXIwQzRtOFMzMXdGNVJuTVE2NEpo?=
 =?utf-8?B?STJaVUpMeEt0eXY1TzE3dUM3MWlWY0kxalc5Ym4xdGlPSktKZUlaQllPay9i?=
 =?utf-8?B?VXFMWmZhMml3QThFSzhaL0UxNWoxeTl5V01mQ00vcWdaT3M4T2JISG1LRlhI?=
 =?utf-8?B?UC90eTZjWlBTTU9YSEpuSnhVK0lXOCtjU2J5V2pLc3Z6cldSVlZyUEo5RDVl?=
 =?utf-8?B?U1B2ZU54NG5kdVdicENCWkJaSFQzL3hEVnJMSEJjTzF4WFNqWkFzTGFOY1c4?=
 =?utf-8?B?dEgxZWRlcExvajlUeUpjcjlKQ3NqYnRUT0FmbXlIWFJMM296OHN4NDhqU1Vo?=
 =?utf-8?B?cVp2azVQZUpQR0VzVVpkTC9QTGV4TUFsMXQ4Y0toc2F1ekdSR1BDODA3YkxT?=
 =?utf-8?B?anBVSTZjTmt5SjlKdE9OVlpuTDMrQkJmeGI0aUtvWjh3TkwxRXVpMXFUYk9u?=
 =?utf-8?B?aDhpMk90OHJNdHdubzY1T3VMTHhkVnpvTTdrN1dEZzFzbjhjenZzeC9QRFVP?=
 =?utf-8?B?UmlORUVydDNDUHlHK3JZS2d4THYrZ1ZmZ0x4c0dOTVRkSGNjdXJsSnZyNFJw?=
 =?utf-8?B?UkhaZzNrNnhyTDNLOXl0N3pSNVNrendCYU56V0hlWldaT2hsODRjODNtSGFC?=
 =?utf-8?B?Kzk3SVhXRG9XdzhuYXJWT2I5TUxIU3ZDL2xVVzAxZHZhTEJUZDdMSlhZVTZl?=
 =?utf-8?B?dG0wTGp0aHRqQ0hFZHI0YUlURWxCRXV3SVhwdWJ5WkVKaHRUYldqSm5XUUo4?=
 =?utf-8?B?S3ZhYlQrQ2FHUTQ0KzRaNlZxc1RJSWhuOHgwaE5QdllZMkFhbktVV1h6eEhz?=
 =?utf-8?B?cFVZLzl2Qkt2eW9kSkFWOGtPSVJZbVpsaFRackMrdlE2cmc1MjN4TUJJZkE1?=
 =?utf-8?B?UmpYTHpIWXRFMmpIYzJTMWxtNGtvYng0Rm1IM3JRWDhaczBpcm9sZ0FHeHR5?=
 =?utf-8?B?cVNqTEJ6aXBOYndCRWxvQVZiekRuNG5ybWtvTjhHRkNLdXpmRGVkZVpQdUZI?=
 =?utf-8?B?Q3dlWXQzS01PTkFRR1ZLc0RIQlRtNDF5UjQ2enRoWno0bENsMW5uamtaVUNq?=
 =?utf-8?B?OUV2Zi9UT0Z2N3JGRFlZRjdTMTRQclNxck1PMlFLWUY0RVQrdTdnS3MvZ3FN?=
 =?utf-8?B?dFdZdW1hRDdsTTM1TTZHY2RKTnFDWXlWMVBrMXAvc054UEdVa0U3RGxCQS9B?=
 =?utf-8?B?VlF0VDlHOExkU3E5TS9mZUI1L0JXNEsrc2h0VkxnMjYyL1M2dXB2Qk96dmhP?=
 =?utf-8?B?UjN3WVRVQ0VxQnF0WkV4dmZzM0xKblRKejIvOGJHVVY4MzZob1VMS3BGb25o?=
 =?utf-8?B?M2dRbmFwNTFENHd3M2FIOUVwSTdXcTFhZ1B4S0hVRHVJdkJURVFPUTVUVmxD?=
 =?utf-8?B?ZEk0bHZ3UXczWWMrRzhvVDQzWEdldUdRUVJVcVV6eUUvNDJxZzByajVqcitM?=
 =?utf-8?B?Ymp0aTFRSEt4RS9oRmMxcC9WM1F6OExNcjBOQlVpOWJYRXdKZkJDbkZtdVk0?=
 =?utf-8?B?U244WEJsWUFoYUgyNGVtZTlTQWViVlBGR3Fxb291dEZ0bm44M3REdEdZSmV5?=
 =?utf-8?B?eG1iYkNETEl3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF7DCFBC32A.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEVob3pCZW9pVDFNb0NpL1NuZjZDS0xCUHUwVDFYb1M5MHhkWm9rdmhONUpt?=
 =?utf-8?B?a3RweEVZc1VGeEorMW0yb0xzWUhGdnp1ZHpRNzBKdjE0NC9wMHhLdnlYRFNl?=
 =?utf-8?B?c20wK3ViM21rdnNZa0ZaV0xaYnJNbGI5NkthZ2hYTm5KTEk3dUw5aGVFZmZQ?=
 =?utf-8?B?VUR3bDkxWVpOZGlRbEJ1UjU3V0FHdGFQYzA3YmFWY0hBSnVKTlBYYkQwU2ha?=
 =?utf-8?B?NXE4bEFBU014UFEwb2NKYm5QL1FPZU5xM1FDTDBkQnZXeDROMzVrM3dXdlFy?=
 =?utf-8?B?UVoxSldmOW5VbngwYzlqQXR5cEFJQTMzRzZVWUFzdHJqdVMrcHIxWEsrY3Zz?=
 =?utf-8?B?b3RWblZHN2lRdzAxMDFmRWVWNTQ1TWVlV21jc2lhRVVKSGluQWF3ZnhvRng3?=
 =?utf-8?B?ZXBLRVhQWU1qMjVRZkZCaGdaTlBwK1hIM1Y1ZGd3aVMxS0ZxTDZYZDFSdGdG?=
 =?utf-8?B?M0VEWW5BelRmaXI4aTRnK20wSlZhakp3ajRydCtzbDdEL09CZ3ViS241RHdp?=
 =?utf-8?B?emlUd043WFFXUSsxL3R1MWh1NU43VWZ1NGJuSkpqdnNoakp3bmRBdTFUVzVx?=
 =?utf-8?B?S1RISzZUbU00Rks4TUZDelhLazdxS3RzMTdsanE3Y1l5QXVMQWFEK2VkalpJ?=
 =?utf-8?B?eVQrVEh2akxCaGhTY3pqbVNsZEpSdGRFZ3VZV1BFa2orSURQY0Rva0lGZkl3?=
 =?utf-8?B?LzdrSEFOTTBzbVArSHB3SmkvVGFnZHY5b3RpYXgvZDZyVVpqY01UYURRcVhK?=
 =?utf-8?B?RnpJN1p5c1ROK0NxcTd3dEE4enJjN0pGcVM3OTc1UGh1TXI0dFhRcFN5K3Rk?=
 =?utf-8?B?aFNYamE2OGUrS0JvOHZsYW9Qamx4N3Q2YStIVFVlb1VvZHVUUkhKQjViZ3Bj?=
 =?utf-8?B?UDdKeVJvd3VmaWNBbkUvRENtT0t5KzRqTGFjeE5BU3VNVGFZUW1zQ3dqc1Nj?=
 =?utf-8?B?OHJUNWl3a2hxc3ZYUmJacVRzQStsYzI5cEQ3MlJmaXdNRVhYOWFKdGZlYXJv?=
 =?utf-8?B?Uy9qZjBWUVhWdGYwdVZ5T3ljTEV5ZTYyQXlDTG1XYlpWTFBDVFNKaExhRk5y?=
 =?utf-8?B?aGJwcXlaTG1KZnBTdUd3TXlVdklYL240WjQ5YjUvRnZQRmFCNTRzTS96UTRj?=
 =?utf-8?B?d2RCNzZ4aGlDa0t5NGE2ZHpuNWRldFVRR1RBQm5PZmJpVzVpaU56SWVjLzlG?=
 =?utf-8?B?bVJwWFpvZThqaHd0NmZUNVZTaG15VHJRMFNPbi9BYnd2VkJLZTVMeFBKczRL?=
 =?utf-8?B?bFN1Q055d1NBSFFoUjhNaWVraXVVaVpnckdSVk9TTVZqZXNUcEowVy8vbDZl?=
 =?utf-8?B?aExSRnFteTRnNXhkZTdGQ2VjYitKSXFyV2lzQ1pMQUtWQ2lsdDFlRmJxRmxa?=
 =?utf-8?B?S1hLUm9rZ0dZV0xKeHFYZ1VXK2M1cVl3VGtuSWp4QWZJSDFIRk9CbUdaWTRE?=
 =?utf-8?B?TGdRYTFWNnJVYkpwVmJlUFVEbTFxVVdiUUt4dmsvZ1ZoUTZkWEJoQ0JDMTdT?=
 =?utf-8?B?QlZOc0VtNWdlTjczV2YvYzlhQWhiSW55eStBL2FzRWh1RHdLY2lGOW1lOXBJ?=
 =?utf-8?B?Z3hrMXJaYXVVcExzeDhXNnlYZUc2R2FSWm5oK3JEVUtxOVFvd1I5RDIvcUVo?=
 =?utf-8?B?Z25xQkZRNDE4VW9kUjQwcC94SFNXREVyTy90RkZTL3FTQWFMWVpMV2xmdk9P?=
 =?utf-8?B?MjlWbGZVZTRmRXdLV2xka2JrY1RJWU4wcTA0a0EvMXRFWTBZelRjRE43UnR1?=
 =?utf-8?B?a3U4ZldEOHFkblhNb2svSEFWeDM2TEpjMWJiTnRQcmxVUStJbjhEOGRzeFBo?=
 =?utf-8?B?cGJOVjhvTkEzcjBJSHI2Zm8xUHJTUmZsU2NQbXp2R0JiVC81YnJTakNxVmNp?=
 =?utf-8?B?UXhvcjNPMVRQeUdqVUVnd0RiRUxGNmhIb2EyWVZLMVRzWkM0OG9ENmJhMkdP?=
 =?utf-8?B?emhTT3JNcFdBODdGaU1rOEROS2xtOVQxMHd4WW50VFlBUXpTVG5FWWtPS3lX?=
 =?utf-8?B?NmNKa1RFMS8xb1lXMjMwWXRHcm5qQjRaTkE2VkhjV0NBd3ROWDN5eTgvR0NY?=
 =?utf-8?B?bVNzRitHVW0xa3ZuejZxZjdrSUlRckxuMGoxUEkwbEdUUWNncHdyYXRsTHo2?=
 =?utf-8?Q?vOjYlm3O2WO1bdYZbzW8rAuDT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77792886-91e0-410e-fd7c-08de31cd23fd
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF7DCFBC32A.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 18:03:47.8057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PEveY9EsDXruYjJQ7AJ91CmnRCzpIcAGhLC8mm0u7rw+52sk6nhwoVdfE84bS5Tq/22B0dS+VX9/0qoTA5hyLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8066
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C8B980005
X-Stat-Signature: kffy19ob1c3aeto6mp9m4t8ooozk3bcz
X-Rspam-User: 
X-HE-Tag: 1764698638-737980
X-HE-Meta: U2FsdGVkX1/nPnv+/KA+DSLgJqyX5Hu+iBTDXCpvEmbci3rmMFBC/88l3Mo8FWmce1hwT7XKLy+ld8qowGts+bSTmUqGFQ7P7ycS3oZJRNqsCHmWEKY/RUpR+lvwycicYMzysyklXC9Dfh6tkEa3re4m8DFY6BM9w4Oh4lQNyF2x/7O/plgCcvs8XKLuV7kzUGG6A47Ni4ObYyopxGLcPfUZdBjJbiHiGwi9bAo1r7HeGgdlweMGvMoyZ5pyx/hXSXmL2DU33tap1a7WrAZeE1v/n9ZhMQrCXWhOxYCb6at6q27QynFLhvXeKuFuSfLNdWTEzJw5xvCMPonUCEntgwAzpiu8fPzIADgFcK4Zb/Rbx0WXjcWcZ6D0GxtUDGagpKtuNRBwCAmpS9lAVVe9tQqGwhiTlCj3A1Hl57gZ/7m6EfdK4xhn/mXYNgadeNMRrFmxJoadcjSiY9fLPBhsDO/mdyUy/1rlzch7bRpNR1ElWb2m5CvKumm5qASnDEiw+24sOByIVQmKDQEUaLaOb3u1MpIjYwRwQ0CPP1W3jl+xlyT0AAA/amKsOj9R3z/iQ+Xae9TR1vS1/5yVVgnhLcpssKKKGp+27pIZOX+4F3HVddUQWZPvAMTCXN9t41Es9/G/DKIfITZGtUsLjj9wCOX/tuen+2wbJP0mefmKiWfkgbCP2Vdj+bEy3US6vbk2cRTzfjHiRZmmRpY1QgWvrv0NrhsFZ7xWp1R0h03faBftCHnADO1L5vGX7+m6sPn/dMxXuhmF8Z45Q0dZiHW6yX9mBNv+nGXKu5Hmlf0a/G7Fw74MVvRmEgsXquNWXU/S7HR+FUqQFuQvD0BgfcznkoKLa+dwFTWMv1AP8zbi4HhWvNcW/c1wDz1b5xbgztb2uSvEZWEtR/5rXJFuqx54WNd5mMAMRH3k1yYE2JlOtqD41NNOZ+07l/n2Tg5Hc3Ke9mLt+tbzMI/VUSXR2Ly
 wrOkDL84
 viMhuLSXZF/QvdwZFrpSy3rJ7dAiIOmVBnnUiV+/Q9YZW57dE1rACWbHV04kgrD7tSrajoEYzqESMXr8sr55TEUvilCBL7zFFJFwg1ScP3GRD1ZD6FRmEIeiKVicXTJLaAn9eZrQcIc7JbRcl6JInV3/9LzFl9blv9V41PpCJR5sFOcvWIzDEFE5MbWbOu0kr9pdoYi5fhmqnKcR2sUWR8pfdg+k83JgdBgBj/xj31t9n+ngRSbAI0NByoqRMZqxynP9IaftaHw+GAfEOrTSO1NiSFhHThMAW3BTaSuEzw8/fnWTV9h+bGwttVcVJXlLHOUCrXuvduZLD9DDVt/NMVSjcMUh83wxXZeaZSdIGDP/Dl6ckm8ij3mhZEqVNpWCcnz21OZKq3TsXYnhWOBXTMiPonARivasrRvaVjPyGj5HxOiwE7UCSMBhybZabcq+5/ogUwCSr/0vs9ZL4bM4442q80ByVkpec76qSbeJ0LLSLSxoD6J+Tkm1i3XOjK3nV5ZRGCIITmtoLl9hhq3iX2xsC0zwBJytTUfol+AITubATchPop5D5K/Mw4hKYJn5AGePp85sT1ae/26FOgmbwAtitsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


W dniu 02.12.2025 o 16:51, Petr Mladek pisze:
> I am adding Andy and Rasmus into Cc who are active vsprintf-related
> code reviewers...
>
> You might see the entire patchset at
> https://lore.kernel.org/all/20251201-va_format_call-v2-0-2906f3093b60@intel.com/
>
> On Mon 2025-12-01 10:31:24, Andrzej Hajda wrote:
>> Changing argument type from va_list to struct va_format * allows
>> to simplify variadic argument handling with va_format_call helper.
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 513e5ef8a6da..4d76b67a87e3 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -4965,30 +4965,12 @@ define_dev_printk_level(_dev_info, KERN_INFO);
>>   #endif
>>   
>>   static void __dev_probe_failed(const struct device *dev, int err, bool fatal,
>> -			       const char *fmt, va_list vargsp)
>> +			       const char *fmt, struct va_format *vaf)
>>   {
>> -	struct va_format vaf;
>> -	va_list vargs;
>> -
>> -	/*
>> -	 * On x86_64 and possibly on other architectures, va_list is actually a
>> -	 * size-1 array containing a structure.  As a result, function parameter
>> -	 * vargsp decays from T[1] to T*, and &vargsp has type T** rather than
>> -	 * T(*)[1], which is expected by its assignment to vaf.va below.
>> -	 *
>> -	 * One standard way to solve this mess is by creating a copy in a local
>> -	 * variable of type va_list and then using a pointer to that local copy
>> -	 * instead, which is the approach employed here.
>> -	 */
>> -	va_copy(vargs, vargsp);
>> -
>> -	vaf.fmt = fmt;
>> -	vaf.va = &vargs;
> I am always a bit lost when using this API.
> Why is it safe to remove the va_copy() here, please?

Not very familiar with this workaround, just my thoughts about it.

It is just va_list is compiler's private implementation, which can be 
anything.

And if it happens to be T[1], it's type decays to T* if it is type of 
argument of the function.

So vargsp is in fact of type T*, and &vargs is of type T** and it does 
not point to va_list anymore.

So in short passing va_list to a function, which takes a pointer to the 
arg is problematic.

va_format_call DOES NOT pass va_list to a function, so it seems to be safe.


> The va_format_call() uses va_start()/va_end() which is replacing
> these calls in dev_err_probe() and dev_warn_probe().
>
> It is possible that the original code was actually wrong because
> it uses the same copy (&vaf) everywhere, see below.
>
>>   	switch (err) {
>>   	case -EPROBE_DEFER:
>> -		device_set_deferred_probe_reason(dev, &vaf);
> This function processes the arguments via:
>
>    + device_set_deferred_probe_reason()
>      + kasprintf()
>        + va_start()/va_end()


This va_start/va_end is for var_args of kasprintf, not for &vaf, I hope 
parsing %pV uses va_copy.


Regards

Andrzej


>
>> -		dev_dbg(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
> This function uses the already processed copy of the arguments.
> IMHO, it might print a garbage because of this. IMHO, it should use
> the original va_list() or might need its own copy.
>
> Note that this call does not modify the va_list because it uses "%pV"
> and vsprintf() creates its own copy in this case, see va_format()
> in lib/vsprintf.c.
>
>> +		device_set_deferred_probe_reason(dev, vaf);
>> +		dev_dbg(dev, "error %pe: %pV", ERR_PTR(err), vaf);
>>   		break;
>>   
>>   	case -ENOMEM:
>> @@ -4998,13 +4980,11 @@ static void __dev_probe_failed(const struct device *dev, int err, bool fatal,
>>   	default:
>>   		/* Log fatal final failures as errors, otherwise produce warnings */
>>   		if (fatal)
>> -			dev_err(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
>> +			dev_err(dev, "error %pe: %pV", ERR_PTR(err), vaf);
>>   		else
>> -			dev_warn(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
>> +			dev_warn(dev, "error %pe: %pV", ERR_PTR(err), vaf);
> This should be fine because of using "%pV".
>
>>   		break;
>>   	}
>> -
>> -	va_end(vargs);
>>   }
>>   
>>   /**
>> @@ -5042,15 +5022,7 @@ static void __dev_probe_failed(const struct device *dev, int err, bool fatal,
>>    */
>>   int dev_err_probe(const struct device *dev, int err, const char *fmt, ...)
>>   {
>> -	va_list vargs;
>> -
>> -	va_start(vargs, fmt);
>> -
>> -	/* Use dev_err() for logging when err doesn't equal -EPROBE_DEFER */
>> -	__dev_probe_failed(dev, err, true, fmt, vargs);
>> -
>> -	va_end(vargs);
>> -
>> +	va_format_call(fmt, __dev_probe_failed, dev, err, true, fmt, va_format_arg);
>>   	return err;
>>   }
>>   EXPORT_SYMBOL_GPL(dev_err_probe);
>> @@ -5090,15 +5062,7 @@ EXPORT_SYMBOL_GPL(dev_err_probe);
>>    */
>>   int dev_warn_probe(const struct device *dev, int err, const char *fmt, ...)
>>   {
>> -	va_list vargs;
>> -
>> -	va_start(vargs, fmt);
>> -
>> -	/* Use dev_warn() for logging when err doesn't equal -EPROBE_DEFER */
>> -	__dev_probe_failed(dev, err, false, fmt, vargs);
>> -
>> -	va_end(vargs);
>> -
>> +	va_format_call(fmt, __dev_probe_failed, dev, err, false, fmt, va_format_arg);
>>   	return err;
>>   }
>>   EXPORT_SYMBOL_GPL(dev_warn_probe);
> Best Regards,
> Petr

