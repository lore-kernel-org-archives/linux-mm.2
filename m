Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E3FF54AA8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E8166B008A; Tue, 24 Mar 2026 09:01:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298E56B008C; Tue, 24 Mar 2026 09:01:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A466B0092; Tue, 24 Mar 2026 09:01:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F33B56B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:01:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 765181BA26E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:01:42 +0000 (UTC)
X-FDA: 84580968444.02.5075B1A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4D36718002B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:01:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b8Y3dT5q;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of yi.l.liu@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yi.l.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774357298; a=rsa-sha256;
	cv=fail;
	b=YRVKpnJWDebzJXhdO9bOHoFWunMADaCDqJHSFVBDbgZM6Lb/rrxENIq32UX6zBhxFwCbSv
	/lTzn5rNQxRbXfV9tltb0N2D07zsL05lfa9vKcAKAOMde7Hcg3S/dsweBxPPVakNFanTg7
	QbNynwehWjh4mVrVfvnKStrYRBCPYGg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774357298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhqR5ePLqS+MWfEc/MKVDek1P4l3gttgLXGr48lPW2M=;
	b=ujC3FD/CiulzAHMamEbjBUcmVL+h13N/q+JD3Cas2QyMJ3+VXN6ii04AjUZcI2Ziex3VIH
	t5p2/YqDio4bC449dQazuRYAC6kfPVCJgiVZMELN8sylC2YH7/nBdPZOi6rDSaHjWfoX2Z
	HsD49Uu1sHJNKRYGnroHnqxZybHiFHA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b8Y3dT5q;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of yi.l.liu@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yi.l.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774357298; x=1805893298;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fXIKOmeKv6N/bxNCc82YDScZ2GOPAD80Mk+DqB0HhFo=;
  b=b8Y3dT5qv9744rmDt1Tj4KwdDCXnM+CLmbqgp+DO8fMbV7lkFVFe5emn
   8febCdCz1KJXW94LHToV8U1/MBz/P4LbupF1e5AFzmW+DqhPKkqhFHvwi
   rDcYv0uHL0wECJvh8Urt209X0VSrGl433td8TimQ+VQCxWZCnPE5/B8l5
   F9lEdEEKFgRMtSkuMyLT2sXY+/kR5DNOiOfloasydSTKkwW4YRq1vf3JQ
   zQOjnLajm8xo2YxkqUv6cfyW5wfUK4ZlwP1/lzdxuI3s+VpOICH8QcJEE
   RhOJgchy5kZDBSlD2pxnzZ1KDLXfJlcXcJdwIrWnyDj6+uGroDktqvQaf
   g==;
X-CSE-ConnectionGUID: q+MkNz5bS/K74w+AB0lj3Q==
X-CSE-MsgGUID: dfR5RqsAQzeTVE0bHzlXbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="74554118"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="74554118"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 06:01:34 -0700
X-CSE-ConnectionGUID: aTQFjj02SZebdFozMbwCwA==
X-CSE-MsgGUID: IgMJlkEGTFKK2EXc5qxo9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="223412780"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 06:01:32 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 06:01:31 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 24 Mar 2026 06:01:31 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.4) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 06:01:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RlhKUFKf3B5nXJD5lqX+JB+0hv8dUjC3Y8Bk2VEhQWZCe2wvtMdc5vnj9wZS+wPoTtI9Ee8Er3zeqx8Xtwoy5PNxweD/OdlhzxG4IooTlmlJIc7OJaxbSIx01Oi9hSCauP///1t1m54SYqdsh5dLsjbtz9zP5LLG3jyODKZdhu9/mGHs3ynCCtIwWmOitZuBUIUOJ+fZy31gVEOmiVAJYxSYIrVGTy43oh8FKiGr+RMdkbUSMFyPYWOU7eZh413/n07gXrUZKGMOU8ZZvLbHx9qRXfwX90abz17T3035o39r/J4PAsPutfur1JfMcpMVQW/5jg0BgkfaGXnsQzL3Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhqR5ePLqS+MWfEc/MKVDek1P4l3gttgLXGr48lPW2M=;
 b=JW51pQ8ebcY99F1VxTZnupTCnd5mSf92ZKvoE5vj9mtgBfBMQBiwsj6zo6r1WN8MqDHz7mQJKlLuVRijLwOcTQqtMUIzyOdt8CRPd5lNIqIOzHkSCqbjKIzfJZteUhSMTECnsNnr0BuG7jfnHwKAH8SDFUcnToQyyQJuq3FiX6askV6Cd7v5E6aWNXdAWNbAHBHK0Rc61i/0ReTz0FieaGpeT3k6g39+++3Oyeqc6GljIroLAo1dNxxB4HVGt347OPPDYrqlzUEoybaJhvYzhJc8VklgV8Gcfwfb4XIhHB3DFZ+CEbBrniGnsZxDGklipLj7p4orKTfRjrp7kpn1Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV8PR11MB8509.namprd11.prod.outlook.com (2603:10b6:408:1e6::15)
 by DS4PPF0084F97E3.namprd11.prod.outlook.com (2603:10b6:f:fc02::4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.12; Tue, 24 Mar
 2026 13:01:23 +0000
Received: from LV8PR11MB8509.namprd11.prod.outlook.com
 ([fe80::f5bd:4dde:4f2f:20b7]) by LV8PR11MB8509.namprd11.prod.outlook.com
 ([fe80::f5bd:4dde:4f2f:20b7%5]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 13:01:23 +0000
Message-ID: <df5dac48-8a54-49e2-acb8-9370b7078033@intel.com>
Date: Tue, 24 Mar 2026 21:08:16 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/24] vfio/pci: Preserve vfio-pci device files across
 Live Update
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>
CC: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf
	<graf@amazon.com>, Alex Mastro <amastro@fb.com>, Andrew Morton
	<akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann
	<arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, "Borislav Petkov (AMD)"
	<bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, David Rientjes <rientjes@google.com>, Feng Tang
	<feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Jonathan
 Corbet" <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kees Cook
	<kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	<kexec@lists.infradead.org>, <kvm@vger.kernel.org>, Leon Romanovsky
	<leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-pci@vger.kernel.org>, Li RongQing <lirongqing@baidu.com>, Lukas Wunner
	<lukas@wunner.de>, Marco Elver <elver@google.com>,
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, Mike Rapoport
	<rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Pawan
 Gupta" <pawan.kumar.gupta@linux.intel.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>,
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20260323235817.1960573-1-dmatlack@google.com>
 <20260323235817.1960573-8-dmatlack@google.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20260323235817.1960573-8-dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0109.apcprd02.prod.outlook.com
 (2603:1096:4:92::25) To LV8PR11MB8509.namprd11.prod.outlook.com
 (2603:10b6:408:1e6::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR11MB8509:EE_|DS4PPF0084F97E3:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eacb3ee-59b0-4b30-afd3-08de89a57355
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|42112799006|366016|7053199007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: Aju1Vt78ZA9HSjETxafkLeW+nh5wGznDISbV1h8MIfn7frtXN1Zi8zLrHuAxCQtI8WUhRZttItiMjLXT8nRPYqW0uzH7RCJaeuJHx73YZMWlxwb0oNjLBN8LY/7Zhtl2yWzM30iy/qmqsx4D590Y1KhrVegcPc4+sRIqnuMoXCZgsELO0Zta8HyGkbUP4iBpwPLu6ucmjR4glhoBtPxVTiJwU1vzIXaSCw0Ick4DpxZ3tP+fixOSz/9LkfMWnquys3b58kU2uu1GgB5y5QcPiXhWtlYuSu5gVvtNZtUaL+QeI76UMKP3v5XjC7V6rQNOTmpe4RhKP1+xl25+KPGo96xf+VUVxXjJ4rVyiMRnHMyFeTSQsIsM/LRmy5nsFeyT6iEobVZAMBIvicQmg3dfUgPJWwDmXgnWQZXxMatE7IO4xwiT3SI+Ubd/kS6k5syRjTt0pZ81lMEnCoqaEQ2LlAZIE+VenQMiUY/70Ue0iWgylTyg5gMFb/cFeLDjG3kFciUbcVD+PDpxwfY3An90U9NoWO0R0OJEVrdJH51Rl4Hqsllwg8k/joH+ZA+WMEm+NvdyJXETfN5Z7plFGAxbxMqqcas30FrzV1glH+9e4H3RVK4lC0S/RshW0nfUzO3qL/y6vGwxQ2HEsq9vhdQqnH8EkjmYeDdTmYTD0jQGgj6pRo6NpAlv2iXZPM9EJlUojA2EREah+Bw++znTmg2kp+EJ9zAtzjYWpyOBM1VD2LA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR11MB8509.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(42112799006)(366016)(7053199007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TU5mY3p3V05Xd0ZzRlhENlNuaFdMZ08rUTBrQzNBWjBXWnppM05vSXdLYi9G?=
 =?utf-8?B?WUdhR2JhUEFVeU1WZmVpckpBd0V3T1g0cm9VWjJ0U0V3NWlvL2V3Y3lUelFJ?=
 =?utf-8?B?ajYrallYN3FrV2pDQnhZaDc3K3BLd0ZZVkhIZjF0WGdEcEZMZy9icCtjbVYy?=
 =?utf-8?B?OVdWUWhSajBzbG1XUUtPMnRhSjUrSE1RTXFqV3hVc2swMFQrZGxacWJjNTN4?=
 =?utf-8?B?WXlKaVJ0aFZqUFFxMkNaV1ZrcjB0KzN4NlNiRkkyUDBVbFFoRkV3ajZQekdI?=
 =?utf-8?B?VHVONUh1ZGYzZFZrcGl0MVlWeWIzcExneTUxaWt5WkdTcXF4bGV4M3VxelEw?=
 =?utf-8?B?VUR3RG5sMlpRRXJFZ3JRNlY5bXNnZVBrdTJpSHh5b0cySmJpUjZNQ2tsZkxV?=
 =?utf-8?B?aGR2a09zVUdHYzYwNi9NbktCSWJMTDNxMTZIanQyTWMxY09RdkJkNjIzQWJa?=
 =?utf-8?B?eU9mWEZIYldvWmFiQlBuWlozS3c1TG8rSmtzT0VsUHhnZHZTZnpnV0xBMk9I?=
 =?utf-8?B?cnlsN3Qzd1E3ajlSMG9LcVNZVFk1SzBoS243NFBOTlg1eEZ3WG1HYmd3WnA1?=
 =?utf-8?B?SDdvYnVzTlhwbFBsNXRLR01EYXRlNzJ5MjVLMzd0ZmU5T1l5bXFPclRrRnpx?=
 =?utf-8?B?WVNDNEFWMHRSK3dieXdYS1huZ3lrczcrWmViN3BVQjhhVjB3VmJiVERudDVP?=
 =?utf-8?B?MUdqYkZYd0xEQjloTUtyRmlKY3ZyYm9YbXd5TW5MSkI0MStRSU9GejZIbHVN?=
 =?utf-8?B?QzBxbDM3dW1BK0NGV1BZRHYzOTRDWk9rSXk4VzJJT3FLR3NLYmxEMWVUbXFr?=
 =?utf-8?B?U1NDYVpDMmxONjM2cElqd3lKQzJ4N1kvRHgvWEJsNkdaMGFqbzJTNCs0Q2Nz?=
 =?utf-8?B?TVhELzVyWlJmRmNpMXlwaDBmdkNjeFVGYWhuSUtlVlJHL1lsRGU1bDY2ZThR?=
 =?utf-8?B?bHZsNDhiQXBEcWQyc3o2ZWVXa082OGM0cWdMODU2WDBQWHkreXpxR3p5UXMz?=
 =?utf-8?B?Qllra3FVM2xhTEc0L0hldWF2aEFoM1V5K2JOQStUcG9aczNvemtTVEFObmFP?=
 =?utf-8?B?bW5uMXpmMzBHSjlzM0xDcys1djZhcXBkYXdheWdwNU93ems5dnczSkNkcDll?=
 =?utf-8?B?V1lZLzFheVBtZ0JtYjRxNlRxR0hoU2F4NnNYcWdPeUlVbTBENW15Kzk5N0lw?=
 =?utf-8?B?dzg2amJaeVk1R0pCZGJub3BwUjVoZzN2MzAzOExoSVVrU3pFTWw2TTRIRWhx?=
 =?utf-8?B?NzJLZzcxUnMwZ1RxM3lKSWtXc3R3VmNiMWVNeWNwWTJpYlpMcjc0Vy8yN0pY?=
 =?utf-8?B?TjYxQjl2TEt1dEJDZmJyN0xoWWRGLzhMT0l1UDh1em44QW8wa2NpbzVrTEhE?=
 =?utf-8?B?bjZlUWRKQ0Z5emp5cUEvbUQvcmpLdm1QTElpVEcvM3ViTDJzVXV3Q2l5U0sy?=
 =?utf-8?B?MWdlQ05MQ2F4emxqdTQ2djJkeFU3OEwzQ2ROTHZ1c1BSa0lsK1VwNW80aitq?=
 =?utf-8?B?VnpjazNMVENuRHlkWFFLTVpQVnBuOUZtV21jSURjcU1zMi9xSE9NWnJiakhM?=
 =?utf-8?B?aHRONkVlck0rR0ZuNFNBWGdyYnhWWU42RExJS2JLUTVQckR4eC9SczZRRzAv?=
 =?utf-8?B?YzEyUWYvZ1NzUHlzcVdmeGtDVDRzRDh6c3BvVmRFV0RYZXRlRGQwcmFZK1VW?=
 =?utf-8?B?Q25SUEF5LzI3N0R6YWRwaElqRzVrNkpwdjhzcnRsV1RvM1ZENWc5MXdyL0dI?=
 =?utf-8?B?dVk5bHhxc0dVYUxUOXZFVzJINlc3NzlLT1pjSkMvY1psbS9vZGs1NlVmMm1H?=
 =?utf-8?B?ZHVja1c5UTVHUnFZNjJGa1dSNS9RcVNreEJNTHRVM0JTeEdmUTNReW9adEFl?=
 =?utf-8?B?N3VSU1o0S3M5d0djZ2JrYVE0RUVzNkVTTFZCWjRzbEMzS2hVNzY1UWRSS2VF?=
 =?utf-8?B?QVd6aFFIbUtveWx5eUJ0aW9seTVYYTBTOVB0NkF0bDNaaE9ZRnIwNXpaVzZE?=
 =?utf-8?B?SjlqQkRyRTNmblFPTDdlU1FTZzhjZXBldHJsRVhualNidm11Q2JLanRXUXA0?=
 =?utf-8?B?VFdPa3VxdUF1dTc4SWVSdmtxYnF2YmlPelRuRlNMNWQvV1pCcGt5M29oZ2di?=
 =?utf-8?B?TXIvaktWV0NxN25DeGJOVm52TDNSRUpWS3ExL1pSSE84bURwYUsrOXdkNWNJ?=
 =?utf-8?B?dWtvQWRjdmUxVnZkU1dQcGoycklsajlITlZUSDQrQTh1T1FrOFBjOVFlbFM4?=
 =?utf-8?B?NGhZczFkYXBnbm5lSjE2V0FoOHFSQ1U5R3ZJd1dhUG1kOFpxQUs2bmdBUnlL?=
 =?utf-8?B?amZsK3BjcVMrWGhCd3pTRVhRZVJCYWdJai9MV0QybWd2WUJBOXNXZz09?=
X-Exchange-RoutingPolicyChecked: hV+eP8xggYS8aAcsncTN8Miqz5Pinhmc126GE2yJeCaetzj8XR9WT7dbqGuWzipcaH2h7bPQxEPBp4HON64G9FKxEeCF2gxM8/9MKw1/yMAA+u1NxjIQNvJPLSgw60TqQvPsq1jj6VATlJobQmz1yHI3zsNQjAg4VdtYudBZzwAjc7G+PvvedL1jyv9wTAq7OsB/nxns8frZQPmHdgZNP9yTvXJIOlHKxeDznekYglKnHN9UIzMOvOeJDufk79SlE7Zvp4ySTpZHLBMSDD/AaEo+4Xh/moVOJ3rL7L7haBINVHFKF/dW2dmjkYKe30E5LsNfPQ0XOTTFDK1AYWqjGg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eacb3ee-59b0-4b30-afd3-08de89a57355
X-MS-Exchange-CrossTenant-AuthSource: LV8PR11MB8509.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 13:01:23.4407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EfmMWq7CefUjffSUZ87MObx8tNHn4NhG9928ARBsFZEh+t6WqoQf36xMFpZcLcR4usWFWRI+f/6RBWl00FnMvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF0084F97E3
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4D36718002B
X-Stat-Signature: 7wxzer1znxx4kmzrurdkteedu7bns3zu
X-HE-Tag: 1774357298-113007
X-HE-Meta: U2FsdGVkX1+Q/Xa8HARN8DVT0/1JQYilaLukQ79JC+crv8zaMASQ+X4JDjDw3Jj1vt09Nerd//QZGVGpL0XiQovw9sx/ACdOvPzIkx1R3yh6mCNQN/VTxvuJJqwa+vdUXBgFB/d/MFu0RgzBHSXFbOfnTbXuE3+gBoKSQowXJqEL4tv6EHHtkEGjTd0YK5UblDC113A5eMzMecmyKEaD1BG/xdrOmgzXgeQLA/ZcZo+S0xvWRbGdzlUHm6sJJvoIv/NeP+ICbd5rydBZeUChd8CU+HQGbci1sCkrVOOtjraIUGt2l2WCbxm8QBTl0if8nHTETv1CnHew0qF7V1C3hv8902f4DsVotC3Ik15KNODQOCaYDQrQg1NtWa3xnEJEvlSKIE+eE7VYESOMXNfN7EihabdaI2PeoL61bbz2G2zIs1zRbR8Vhk5fypp1b0Cq6n6u0ae72FWXRV54wdzrPUpn8FCEorY1n9pfTEn2ixd1OGv7khSsaT0FbpDyDlb0XI6OhuC9F8rFK99zEct0090YX6dLYmX4VjQ2E2VUyFUuyxP4ScD8Z7TQ8bSnOe5Dm89vltRn3ybFhNb0taKHXkJrKdLP7T2C4rK3ahh49Uy73aEO8rxmf+bzOQoXQ8FHjUmQqs7Zw8Jx0jVuLbVMSoObZ5YaROSHez9aWonmkWXX+Zk6DO/5HprGgg50PRgr7u9wXvBbF0a910GvH8oozIdR4KepispPVFTVzWRgkZD7yawZJLRU1nNVtPR8ECfp70hNrOw9sW/IKLuSfvIE7gKTXWz6RYCAZETcm5vN0N+/G7IfXMaCL/JxsgnyoxJhczH9WAsGr5Xs+R7iXsLxnippWresFpvcyajXonlRhrbnW2cgBSB5t3rSNCAqfWg+1el4vgn2YazPadgHTaWvo0kr6nXYp4ewkuFqy7ZEn5GzdO9lzaoWicnPW0xU4VbpvlyKomWX0uScFvMT28L
 vb7ZSrKc
 zAVSih1ytkiEBLqAFLtP6SeVmeV0dSTypbaj4Xd4ZFFNbERjUJlpfnNbOfr6zdzYw2Veka4AX+99XR1ZDa9pNebPsaUXlR95BLvF6R56m8ZKCxF7oxJ+DjEL21uXFkQZ8FbOqMsUc++UhhcjZ2DFcce8IZDacrNovFx8L9Sz0D5J/ZTDLj/i1L/FpB3UAgD0oU4qZKuyjsFm8a/fCE+1iZzLB9tfj+YXtVAJFpqkPykS9j3rqWgx3ior3ObF/R9fNNPANg2PdmVCUluTIHjwxhj1Vism1p0YAoZMPW5Vhk5kyT2OO+xq7+KUnPV5FzsXQGpIxeJ9BTLZ736yHsmjcFO3+Fp7IGDyWPD04tdtWGWhsQP2sNgLnDQO5laY0uizsegwblF79hRn6KZ96uMavVR39lSAUkO2WYxxvJJPdAa9/G4ZyhkeoLE3NrNzjBWh46NmO4EAUfqZUlpByaVlirK6QNGhvOClav4EXkuVGJJB9hPfOF5uEOXsMt8BhOPhFA+xk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 07:57, David Matlack wrote:
> From: Vipin Sharma <vipinsh@google.com>
> 
> Implement the live update file handler callbacks to preserve a vfio-pci
> device across a Live Update. Subsequent commits will enable userspace to
> then retrieve this file after the Live Update.
> 
> Live Update support is scoped only to cdev files (i.e. not
> VFIO_GROUP_GET_DEVICE_FD files).
> 
> State about each device is serialized into a new ABI struct
> vfio_pci_core_device_ser. The contents of this struct are preserved
> across the Live Update to the next kernel using a combination of
> Kexec-Handover (KHO) to preserve the page(s) holding the struct and the
> Live Update Orchestrator (LUO) to preserve the physical address of the
> struct.
> 
> For now the only contents of struct vfio_pci_core_device_ser the
> device's PCI segment number and BDF, so that the device can be uniquely
> identified after the Live Update.
> 
> Require that userspace disables interrupts on the device prior to
> freeze() so that the device does not send any interrupts until new
> interrupt handlers have been set up by the next kernel.
> 
> Reset the device and restore its state in the freeze() callback. This
> ensures the device can be received by the next kernel in a consistent
> state. Eventually this will be dropped and the device can be preserved
> across in a running state, but that requires further work in VFIO and
> the core PCI layer.
> 
> Note that LUO holds a reference to this file when it is preserved. So
> VFIO is guaranteed that vfio_df_device_last_close() will not be called
> on this device no matter what userspace does.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Co-developed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   drivers/vfio/pci/vfio_pci.c            |   2 +-
>   drivers/vfio/pci/vfio_pci_core.c       |  57 +++++----
>   drivers/vfio/pci/vfio_pci_liveupdate.c | 156 ++++++++++++++++++++++++-
>   drivers/vfio/pci/vfio_pci_priv.h       |   4 +
>   drivers/vfio/vfio_main.c               |   3 +-
>   include/linux/kho/abi/vfio_pci.h       |  15 +++
>   include/linux/vfio.h                   |   2 +
>   7 files changed, 213 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 41dcbe4ace67..351480d13f6e 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -125,7 +125,7 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
>   	return 0;
>   }
>   
> -static const struct vfio_device_ops vfio_pci_ops = {
> +const struct vfio_device_ops vfio_pci_ops = {
>   	.name		= "vfio-pci",
>   	.init		= vfio_pci_core_init_dev,
>   	.release	= vfio_pci_core_release_dev,
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index d43745fe4c84..81f941323641 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -585,9 +585,42 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>   }
>   EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
>   
> +void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct pci_dev *bridge = pci_upstream_bridge(pdev);
> +
> +	lockdep_assert_held(&vdev->vdev.dev_set->lock);
> +
> +	if (!vdev->reset_works)
> +		return;
> +
> +	/*
> +	 * Try to get the locks ourselves to prevent a deadlock. The
> +	 * success of this is dependent on being able to lock the device,
> +	 * which is not always possible.
> +	 *
> +	 * We cannot use the "try" reset interface here, since that will
> +	 * overwrite the previously restored configuration information.
> +	 */
> +	if (bridge && !pci_dev_trylock(bridge))
> +		return;
> +
> +	if (!pci_dev_trylock(pdev))
> +		goto out;
> +
> +	if (!__pci_reset_function_locked(pdev))
> +		vdev->needs_reset = false;
> +
> +	pci_dev_unlock(pdev);
> +out:
> +	if (bridge)
> +		pci_dev_unlock(bridge);
> +}
> +EXPORT_SYMBOL_GPL(vfio_pci_core_try_reset);
> +
>   void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>   {
> -	struct pci_dev *bridge;
>   	struct pci_dev *pdev = vdev->pdev;
>   	struct vfio_pci_dummy_resource *dummy_res, *tmp;
>   	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
> @@ -687,27 +720,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>   	 */
>   	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
>   
> -	/*
> -	 * Try to get the locks ourselves to prevent a deadlock. The
> -	 * success of this is dependent on being able to lock the device,
> -	 * which is not always possible.
> -	 * We can not use the "try" reset interface here, which will
> -	 * overwrite the previously restored configuration information.
> -	 */
> -	if (vdev->reset_works) {
> -		bridge = pci_upstream_bridge(pdev);
> -		if (bridge && !pci_dev_trylock(bridge))
> -			goto out_restore_state;
> -		if (pci_dev_trylock(pdev)) {
> -			if (!__pci_reset_function_locked(pdev))
> -				vdev->needs_reset = false;
> -			pci_dev_unlock(pdev);
> -		}
> -		if (bridge)
> -			pci_dev_unlock(bridge);
> -	}
> -
> -out_restore_state:
> +	vfio_pci_core_try_reset(vdev);
>   	pci_restore_state(pdev);
>   out:
>   	pci_disable_device(pdev);
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index 5ea5af46b159..c4ebc7c486e5 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -6,27 +6,178 @@
>    * David Matlack <dmatlack@google.com>
>    */
>   
> +/**
> + * DOC: VFIO PCI Preservation via LUO
> + *
> + * VFIO PCI devices can be preserved over a kexec using the Live Update
> + * Orchestrator (LUO) file preservation. This allows userspace (such as a VMM)
> + * to transfer an in-use device to the next kernel.
> + *
> + * .. note::
> + *    The support for preserving VFIO PCI devices is currently *partial* and
> + *    should be considered *experimental*. It should only be used by developers
> + *    working on expanding the support for the time being.
> + *
> + *    To avoid accidental usage while the support is still experimental, this
> + *    support is hidden behind a default-disable config option
> + *    ``CONFIG_VFIO_PCI_LIVEUPDATE``. Once the kernel support has stabilized and
> + *    become complete, this option will be enabled by default when
> + *    ``CONFIG_VFIO_PCI`` and ``CONFIG_LIVEUPDATE`` are enabled.
> + *
> + * Usage Example
> + * =============
> + *
> + * VFIO PCI devices can be preserved across a kexec by preserving the file
> + * associated with the device in a LUO session::
> + *
> + *   device_fd = open("/dev/vfio/devices/X");

/dev/vfio/devices/vfioX

> + *   ...
> + *   ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, { ..., device_fd, ...});
> + *
> + * .. note::
> + *    LUO will hold an extra reference to the device file for as long as it is
> + *    preserved, so there is no way for the file to be destroyed or the device
> + *    to be unbound from the vfio-pci driver while it is preserved.
> + *
> + * Retrieving the file after kexec is not yet supported.
> + *
> + * Restrictions
> + * ============
> + *
> + * The kernel imposes the following restrictions when preserving VFIO devices:
> + *
> + *  * The device must be bound to the ``vfio-pci`` driver.
> + *
> + *  * ``CONFIG_VFIO_PCI_ZDEV_KVM`` must not be enabled. This may be relaxed in
> + *    the future.
> + *
> + *  * The device not be an Intel display device. This may be relaxed in the
> + *    future.
> + *
> + *  * The device file must have been acquired from the VFIO character device,
> + *    not ``VFIO_GROUP_GET_DEVICE_FD``.

how about "The device file descriptor must be obtained by opening the 
VFIO device
character device (``/dev/vfio/devices/vfioX``), not via 
``VFIO_GROUP_GET_DEVICE_FD``."?

just be aligned with the below words in vfio.rst.

"Traditionally user acquires a device fd via VFIO_GROUP_GET_DEVICE_FD
user can now acquire a device fd by directly opening a character device 
/dev/vfio/devices/vfioX"

> + *
> + *  * The device must have interrupt disable prior to kexec. Failure to disable
> + *    interrupts on the device will cause the ``reboot(LINUX_REBOOT_CMD_KEXEC)``
> + *    syscall (to initiate the kexec) to fail.
> + *
> + * Preservation Behavior
> + * =====================
> + *
> + * The eventual goal of this support is to avoid disrupting the workload, state,
> + * or configuration of each preserved device during a Live Update. This would
> + * include allowing the device to perform DMA to preserved memory buffers and
> + * perform P2P DMA to other preserved devices. However, there are many pieces
> + * that still need to land in the kernel.
> + *
> + * For now, VFIO only preserves the following state for for devices:
> + *
> + *  * The PCI Segment, Bus, Device, and Function numbers of the device. The
> + *    kernel guarantees the these will not change across a kexec when a device
> + *    is preserved.
> + *
> + * Since the kernel is not yet prepared to preserve all parts of the device and
> + * its dependencies (such as DMA mappings), VFIO currently resets and restores
> + * preserved devices back into an idle state during kexec, before handing off
> + * control to the next kernel. This will be relaxed in future versions of the
> + * kernel once it is safe to allow the device to keep running across kexec.
> + */
> +
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   
> +#include <linux/kexec_handover.h>
>   #include <linux/kho/abi/vfio_pci.h>
>   #include <linux/liveupdate.h>
>   #include <linux/errno.h>
> +#include <linux/vfio.h>

maybe follow alphabet order. errno.h would be moved to the top first.

Regards,Yi Liu

