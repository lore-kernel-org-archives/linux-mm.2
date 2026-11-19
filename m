Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFE8360A380C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 20:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Rp8C4Zyr;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=dwBhR4I+
Received: by kanga.kvack.org (Postfix)
	id E33566B0693; Thu, 19 Nov 2026 15:33:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3F76B06B6; Thu, 19 Nov 2026 15:33:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC9A6B06DB; Thu, 19 Nov 2026 15:33:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BDEA6B0693
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:33:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18F7940BD7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:33:49 +0000 (UTC)
X-FDA: 85453019778.09.F000945
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9A84540016
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:33:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rp8C4Zyr;
	dkim=pass header.d=intel.com header.s=selector1 header.b=dwBhR4I+;
	spf=pass (imf27.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795120425;
	b=pe6yjRZuhLxxsfA7RK0841zOibnTWwJSE2R1LUqgQCGc1g6hLaS/3SG0lsfnEH7470mf8K
	/LTRunh2H+G0akcqmai8TOBPA131O+xAH8jpqxk9Co7rqqozAky+OUyqYNT39ZzGsDJCV1
	cig18GHVk3aiM6y5Xlv1f/dAlRamxRo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rp8C4Zyr;
	dkim=pass header.d=intel.com header.s=selector1 header.b=dwBhR4I+;
	spf=pass (imf27.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795120425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpjYA/yYh0ILIadAUF1utBdvC4N1Qzz8nT7vUgQc7zg=;
	b=NVOYUWAM3QWlYopdHKuF/bSYTTe5giNUmSUfEnyy4FJLQM68ORir0pYmoZ+WfXZMv/tEeN
	tN0+8JowiPogy+rYZYR7NxEG09IxwLk5b+mxiZnF/O/FJFFNEmza28d8BEYLDc21xpdCIQ
	fBpv/0PFg5/Tmly5yQD07ZYorgqnMpg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795120423; x=1826656423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OpjYA/yYh0ILIadAUF1utBdvC4N1Qzz8nT7vUgQc7zg=;
  b=Rp8C4ZyrK/K4rE0Vt+A4CF2lGMSr4UOndoqwiLjb7yQqQABSB6UYgPuw
   h69oiUfgoNeGkeahUuHWIeMgFsP+/NcOknYG1ASh7Ku6GE6kGSe1Yc9no
   4miZ+fSR5VxFiosVrKcQY/FngGrRl2/QV11UPFpX+GIUg8gbcJMhxTIUL
   qgVen60ezSub2830rgOcRenRtaIHUDBPvSy25q6mZFHGhu78zYsay0yyS
   AdBysZA0+BpnqF8Ol8458NGg1PKgXkC9Lh6H/i8d+lLICqHc+mjxNib2L
   mr09GTgYW5TDp7VftDTHeZgxQNOQm5+dNOY3xv5oRwtYg7GX0CfOodBoJ
   g==;
X-CSE-ConnectionGUID: fT8iFlenScOsqKdRq/bqKw==
X-CSE-MsgGUID: PubNkL5wQPKfTmaHP4avZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3904530"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3904530"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 12:33:40 -0800
X-CSE-ConnectionGUID: FW0f3ZuuRLO+tZ8itjG6fQ==
X-CSE-MsgGUID: Krhi3wYuQKyQ8Ty/BY9vkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10750648"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 12:33:38 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 12:33:36 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 19 Nov 2026 12:33:36 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.26) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 12:33:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jdefh5PrTYqcHxqg1Ee/tSs/nktYtEfDgg2DxebDJeNMRYJkNxeVCZHDe/Sx8Wsb9hZmiy/FKtaYq/cn5ROqL0p5KT+Zu/9tW8lTRd7a1m05x2mdvQMcyFgoJI5Py/nhB5aiZQtqRBYHsekWKrlGfp9jNdIVtZ7pOZvOafjEWOUvD2x7BvJgmaA6KkJN/skLLRiQn1hee3AxS7hxpndc8mxy3wmhPIxGypGJMz8Xl+8p/tBs/JoWf33ct9mxjPFwuBuAswuAzRSIAap1Nh6fqgJ1OFZwUXPlgZMRXJ8JuiDMxT9JPcOJPTz4y4wJJqAy8iIw+gLyVAtu2psOz21pqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OpjYA/yYh0ILIadAUF1utBdvC4N1Qzz8nT7vUgQc7zg=;
 b=EzflliLjIT3hvhnO2A3eUQmZktbkoFQTg7FHeqK0zHHxap2hFoEvzb5CIRokGqjZKlLo5r8jIhgZPj41M7PO+/uxPUIlgFjKqqm4cGSrT2aQsnagIh+Ajj3ve/E6oZcmSQjWHzSlyRYFuN1C7U8D2+t7BBY3OBy7n8lS+LvbLHVZMFjBUABJUnulN9rw33IVjzgLMZNkwsOgUu4cqI0sjzcu7oO5P/BFvlKN0mbjcQH/EXGjlv2/RHtq+mkyp7GSmoiRfNi8/ah2bIUJGgKsL1eivwWwByemOsjM/27h/peyyAw4cuazyT73DLlU2qFrsHichAIjZX1/rOnJ7RstHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpjYA/yYh0ILIadAUF1utBdvC4N1Qzz8nT7vUgQc7zg=;
 b=dwBhR4I+dcIas4pYI4Z87zvWKOcGRU+U7f0xvsiMpfzQRlXCtIjLHtAHB+JVLzWM4mNN6V5VQUhBJCRXX0gAhJkt0E9iyaXDnRqvMcCzR+KLU/veriPlGPM/JQ1MQSAwPl7jp4bGZnFpOLY6DORQeuI6mc/yGhhBjMAapZ291vM=
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 (2603:10b6:208:549::23) by IA4PR11MB9323.namprd11.prod.outlook.com
 (2603:10b6:208:565::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Thu, 19 Nov
 2026 20:33:34 +0000
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57]) by IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57%5]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 20:33:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jgg@nvidia.com" <jgg@nvidia.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>
CC: "ljs@kernel.org" <ljs@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "david@kernel.org" <david@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "kernel-team@meta.com"
	<kernel-team@meta.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "kas@kernel.org" <kas@kernel.org>,
	"leon@kernel.org" <leon@kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "gourry@gourry.net" <gourry@gourry.net>
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
Thread-Topic: [PATCH] mm/hmm: reject shadow-stack mappings
Thread-Index: AQHdeGU/H1l7ImqEJ0KOHtCVGoraMQ==
Date: Thu, 19 Nov 2026 20:33:33 +0000
Message-ID: <e5a7d15d0f5b5f91fb412b302386b5b7a88db568.camel@intel.com>
References: <20261113195536.2660763-1-gourry@gourry.net>
	 <20261113200303.GA395967@nvidia.com>
	 <179460249376.482102.14669935557901467762.b4-reply@b4>
	 <20261114002027.GE3706007@nvidia.com>
	 <20261113181025.6e8b9475b29c13d29f59e02e@linux-foundation.org>
	 <20261115000005.GG3706007@nvidia.com>
	 <20261114170127.3d29199864eb352d9045eaba@linux-foundation.org>
In-Reply-To: <20261114170127.3d29199864eb352d9045eaba@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB634048:EE_|IA4PR11MB9323:EE_
x-ms-office365-filtering-correlation-id: dc09b3a4-aace-41f5-9b29-08df467c61b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|22082099003|18002099003|3023799007|4143699003|56012099006|11063799006|261022075727099003|261021121427099003|261102123227099003|261026121527099003|38070700021|10067099003;
x-microsoft-antispam-message-info: PAcBZLF3dWmFGXmx+21/7+Hi3l5axb8uyu2gBRzsERP0vqAOtYxehpDxEqiW57aNY0tAMiDRBJE9X8UC0QxwkkGqPu2qDIic2Tflj3nOJajs+KBm6ZBGptZ5OUA1LAPoMwz12bQDsBRLXZS46kLjnX6VdgFOP1WEVGT+JoHmjbVRVEg39pL7OYAiMptk8z9PjbcAv80JhZsUkh95fEcdHpKsv+Kb9rsAtA8aRDdd9YiSJ0jqirFhseEm0ZOA2tA10f3s8T+maeEju55w7y3yCUoWANmGYLrxYC9fzxWMuoYI36K7Oazk/FYQVqvuEXEwg4KN7L5D0FCxbLnVVY/jGKHBrbDUHe8Pex6x5dn7GnRxLzaZ4GwdJHndtScuTsG+GZ3xE3hpKWbfmJ8Iky1O0a47XmWZWGUpmpO/YZkGT+LAfAaUKoDNb9XodrvvrexvS1Dln3+/b9m5hHQwi4ZlxK/68MKOCnFrX4r13Y2tvblvjGhTusW7EhcZzcW8LoWUDYs6wRgi4exKsvF5yjApubWNZjqbHp1+0lEItymBJM0GLAwDeqRr6jhc7ev37iAy5JjVwxPooaN5imZKoR+LZpHzZjkAWlK1LyTtL3iJXTShVdE3GlDL3PG2tTGp9grm7JP97OT6an9eTyStrllZMkDROVJDEAyZuMPuVHVKTOgAkLsEXyvY3uOf7j81w9NrTOkq76ts6YTlDGM4Ol9FfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB634048.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(22082099003)(18002099003)(3023799007)(4143699003)(56012099006)(11063799006)(261022075727099003)(261021121427099003)(261102123227099003)(261026121527099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R21QeUxQWUttYVJLazlCT0p0NnZhTXhyWStTSEhkT2ZuRi9JTVlybi96NVd2?=
 =?utf-8?B?TUp2ZE9PRFlXMnRXUHp4aGErYUFaWTJWcTBGWUNiaGRKQmdzTUNrR2xadVNV?=
 =?utf-8?B?Y0V2UGZLVHdNWVRTeFNQUnpWTDkvWlFIU0NXQllYL0pCZmFnVWpKa2hocWpH?=
 =?utf-8?B?MnZkai9NM0JObTBZdGRiZGtXTFR1cnZkaWZLQ0FoQlFhRUljZFZFMS9Cakox?=
 =?utf-8?B?ekl2TmlwNzNqcTBlTEtXTUU2VVNuSHVpMkJqUUlaV00vNUVKMVZpWnpQdjJC?=
 =?utf-8?B?U1dmcitzQXhOYVlyRzVycHZjYkVwa1dCSkk4cUM1WkZmMkw0T3hKK0F4N3Vt?=
 =?utf-8?B?L3dPK1l0SlVHSEgxSkpkN1NHaHBzdmhRNVhHV25DbmNNOWpuVlVtTmpYMWZ1?=
 =?utf-8?B?bTFuaG5oOU0zTnJNTzBvRFBFd1NPcGJvdUs2S2Ywd3JleStKbkpQaDlvdE5x?=
 =?utf-8?B?R2VmT0h6WlJYZm9UZWUyNEUzdHBaOCtIVGt6Z0ptcTRyS3ZiV1BJczI1YzZz?=
 =?utf-8?B?MndSa3V4VkpaRjdlNTAzaTNOdGRXck1rRHhRZ1UzNWwxRkhHTFpNcjgyUXZW?=
 =?utf-8?B?V0xSZElqMmhKNzkrV2lLR1lRa0lnNDNLZkRYakRxcGsvemRLZlBZME14dklC?=
 =?utf-8?B?azNxOXJLcFVyMG96TnhXejNKMlV3dTRsS0RPbHBHejVreEFmOWo0OUFtWG4v?=
 =?utf-8?B?TnlDa24wYXFRUmtGU3JHelA5cG9JMWZaOURzZHQ2SUxnRUhYZkdhVFhGUFJi?=
 =?utf-8?B?b2xRM0ZZa1FDQ0NJRGZJT25TM3J4ZFJTRnVKU284a3ZNWTRYelcwMGlHQTI3?=
 =?utf-8?B?Snp3VXJ5K1lMMlJ3U3dHRmlrTkhCTzg1b3dJSURqQmhqUTFORDhRNUtmVVlH?=
 =?utf-8?B?MnI2YUpjL3FhbnZwWVB1Z2ZrRzlIeEF0OFRzekphUVMvc3I3cUhWbi9SZGtV?=
 =?utf-8?B?Z3JoZUQ1d1p3VFhVNTNyR2ZTRzZXUmNsQnJHeHA0STVqYm1PRkRZblRnVWtu?=
 =?utf-8?B?KzZ5ZngxNXpiVVAwODhJcExYRlEvSTBzVUc5NUhmZk1CbXdobTBMR2lBYW1p?=
 =?utf-8?B?QlJaYS9WQjRsZy8yRDFZK1pNSXIrUGJFSzJKcWM0SjAyWTUrMmw0RGlkS1FW?=
 =?utf-8?B?N0VoaUswY1VteFVYSXozQWJ4S2tBalpMZXdtdTJyWEtBRlo3Y1BUS1JUeVhL?=
 =?utf-8?B?cHZFb2xTb3UrZzFkby8xK0lKUFFBZVBlbk8xdWdqKzByUGN2RExlRk10L3pj?=
 =?utf-8?B?RTU2RjZhaC84dWtKWGZJYUNhUXZwWEs0NWtsMkFMRkxmZTAwSTNKWWlSS2lm?=
 =?utf-8?B?UlhmcTU1bjEzN0tqa1hyL0ttRTRJK2tjRXFhWnpSeCtNZExFMGZFMXV3WldB?=
 =?utf-8?B?eTVocGJ3WENXaEh6NGlNQ0V5c1NLdmdrL3lZMi8ySTJRL0xCYVR5Qlg3d0pJ?=
 =?utf-8?B?eWVMVGw3Y1kyNUQ2dGh2ek16MUc1S0x6eHN6eTl0S3phazRPTlpUMmpsUGVV?=
 =?utf-8?B?a2VjRVl3b3EzbzdyMnBWK05jdVpXcXBwU0F6bkQwUmJmTnJONFhML0FaNVBE?=
 =?utf-8?B?aE1VNklCUEIyelMrN2tNRkFDQlYzUXJrS0JnQStPQ2hZcTJxdUl3YThNWjVX?=
 =?utf-8?B?aWdFMEpicjI0WmRoTjM2NFI4WktwUEMvSG8wRjE0dmNmaSs0dm1JZjhpWXcx?=
 =?utf-8?B?VlB6T3UvbkgyQktuc05UMkZWOEdOL3R2b3g2bUJwbWdnNm8yb1NZc2wwRXdr?=
 =?utf-8?B?NEU2Q3dqYVo0UTZKVDNwMGxqQlFDT3F6dWdLc2c5bDlMR2Z3bVFsNUs1ckQx?=
 =?utf-8?B?YW50aFZ3Y1c3ODdST2UwamxGOTBIOWVBclhZcyttenFNM1h1TDBCT28xd3hn?=
 =?utf-8?B?UTF6RVZHNU1sRk5zZmluQlAyVXBieDhrN3U2WGRhbG9rUVRjc2g4UGNCK3Rj?=
 =?utf-8?B?V3pYeUZQLzFJQk1lK0d6UjA3KzJwNDBRTVhyRkthU3oxRkNGMFpEL1JpRUZh?=
 =?utf-8?B?THJyYTBhdUg1SGNtKzEvVmkvRnRiNW05WDhGWGwxSGpaL3ppdmMxZkJNZ1FQ?=
 =?utf-8?B?ODlHb1JsT1dzdytmUGhwZXFNSTA5N2x2RHY3MXV0U2Fidzd0R1RIZTNtUFFs?=
 =?utf-8?B?WDduamNGeVNVS0N0VmFkSnY3RGxiNEUxU0xiY0lRcnliVXhEVXB5NUU1OWJh?=
 =?utf-8?B?c3ZNWVlSTGU2MmNDcU5HK1V1MGxybXp1MlJid0pUTmZ6TUNGOFRucUgvaGxh?=
 =?utf-8?B?Sk50bFRXMWd0dXo3NUlIdVFLaHQvSGlOUGl2Q1psY3lDbFBVNVRyclB4YThE?=
 =?utf-8?B?OFh3SnNIU3hEWmQwM21BSFhWcGladDBzY2lib29nVHRFN3ExOVVJL1JPK2Zw?=
 =?utf-8?Q?nxrR7ntyerVFWqsA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48A6D63A036BCF4B8865F6AFECF1827C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: TF5fT0elU8nKgev2mCEkPJM2VgEfLW7mpwuubbRTDOZOEeyCKBsYnDO8ItGrfQoUklZKT5Wkozwxu2e9wpimYaubTK1CMQyWY6R9vJOiGdicn0teYuV6OqSHmivhDSUR68vRoagLlafzBnyy0Do/sC3ryrwV5+0VpprFMWSiYaIS4PHft0dHi9QuE2W098aoEdH9/U5WCG4IzyviBhJqc0MeyYpaMyw+5L4iFSllh9AzYv3cnkr4t/tLNIBhgrTVT0Rc1VLxzm0AOS6I0gZH4tVxMzK1Q/LCWZ0Tjtg2dSbNy20ygTfsVV24fWEK7EUJZmWIBbUK1Dcti0jV5D4nTQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB634048.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc09b3a4-aace-41f5-9b29-08df467c61b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2026 20:33:33.8612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: idFIQZ0D8vX6ppRQS+tLy3YUjRB7VT7Ruh4cTN1m2aaX6SCkJuYwnTUbX7yOTtBB2R6AXaBL90iLxJb+TdNquDbTDH+MZONdkdAfSkNJO5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9323
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9A84540016
X-Stat-Signature: qp45xeqfagkb4nqoz7ktkt3wc5oky14e
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795120422-233925
X-HE-Meta: U2FsdGVkX18xx/BcEXQ1hsxio+izbq8RyEiIZ0D+kOpEVfZPnFBlhLhDwHPNkwMbMO5lZJ6RYjtGiyiBCkQkG/NasEAgwBfdIvW7tKv75t+6lcibRlqRc+YX6yFVo+Pv0VcbZQWxd2ODFFLTa0luP+WektOW0a1KflsF6uFMtQn8BKTWMZz8nh1J/PeIvN84+WJFpS04pH2P/0xz27raZB/ZQBaifRMyClUB/Dfx3AjaXxZQSNX78ZucGExpZaXhzomnf2of7qACHsM/EPDSTDbZJeTwIFbyLasCJi6ucWSJQ+AggkaSw38F5DJeoQY4OeKIOFvZW75KUmmtg/M2lEk0e+hMA6vNqCDZYH5tMQSoyd+TOrSF0kNwRXlqdWXeMYSoR7MShvfP7VX9H529M+cjt5I11Upcq2NI5rb25dYyekfTZHsRrGtPU3o13ke553dIGwhDOXQvtrs/NRKoEJiUNH3ACctvqwxlfmufJXm2BuDIFe917lrBJHmq52bBjFFDvfddrnD51W2iLtxNoup8VT+1Lg5zRSbsaymLtbS3WGXtZkrIKOq4ZImRkg1PMGIIwLBh2CSWr4zT6XqVWVhx91OxwxcdXdILoVjm0eGuHfkEMNeMSKSz5RtIvYHTas+JurSim10WUGdcoK+0HClCLb/H22BSLR4CmkgkgGYQtMj6T7sxVvQb/XBkqyq479+hrX6n0L4oybkagnC5XVfGOyF30y1tONbyDnXHUBzLTgAHqqMtKbbtMjeCvaCg0085cH3oz4fvNRu2mqDK9zM4WDzs3XZQ4jHaNNPdTuV3iwKDjPXltvgH2Siiezeq2D1LyxqdxYN+XmkUJXXVe4bxXqU9zmOgvO16QLnQ1ADjyyGkHKa10296pcFbCYAwSltDWfX5k02C4vtxo+YH++kP2wmvqXNKGn2cdRN4fZ6UAj8ytGvvw5ACfVd2xN2qhnxNir6AHC3A6kCoJaO
 KLy13SF/
 j8niREJFpPanB/wR98nzrdMVs3I4iv6HT9IpMTCGKS857EC9sJL7AL3IZfn08f27nE8Z2uYjjIX+vGf80e+KEQLsAb7rCYFk4VHNw1sxpMQjYTbnYlLghuYz5cYxU29noT0cqn8b/pIpWcwYKZEZo7d8odoaG3Cwj49OjonrpX1FrK4SaI3yFLa2N0XEiCWplY50FUNIk6KR2mvVFwRMOe5gx3ULBnHJLLDRkjZqakflMS5/LviEVoaWIZSURvm/FPHoooGUI0UWC3InoxC//8/A6y/94+LfdrW4Qvz69z+JDx0OEhXXv12fzvnPB1hq9p5SN89Kro1mjp6Pq6+f0n2JhX+W/bWuz7tzeYGreB+4cE/TvoBy8GRGKdVfB7sLzuAqX20uyYMXnv+BYkCpJ43/ldqX+ufO6+qemC4QhwvMmSZS5z+Ck2GHpmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gU2F0LCAyMDI2LTExLTE0IGF0IDE3OjAxIC0wODAwLCBBbmRyZXcgTW9ydG9uIHdyb3RlOg0K
PiBUaGFua3MuwqAgVGhpcz8NCj4gDQo+IE9uIHg4NiwgYSBzaGFkb3ctc3RhY2sgUFRFIGhhcyBp
dHMgb3JkaW5hcnkgd3JpdGUgYml0IGNsZWFyLsKgIFRoZSBDUFUNCj4gcmVqZWN0cyBvcmRpbmFy
eSBzdG9yZXMsIGJ1dCBwdGVfd3JpdGUoKSByZXBvcnRzIGl0IHdyaXRhYmxlIGJlY2F1c2UNCj4g
c2hhZG93LXN0YWNrIGluc3RydWN0aW9ucyBjYW4gd3JpdGUgaXQuwqAgSE1NIGNvbnNlcXVlbnRs
eSBzZXRzDQo+IEhNTV9QRk5fV1JJVEUuwqAgTm91dmVhdSB1c2VzIHRoYXQgZmxhZyBmb3IgR1BV
IHdyaXRlIHBlcm1pc3Npb24sIGFuZA0KPiBSRE1BIG9uLWRlbWFuZCBwYWdpbmcgY2FuIHVzZSBp
dCB0byBncmFudCBkZXZpY2Ugd3JpdGUgcGVybWlzc2lvbiB0byBhDQo+IHJlZ2lzdGVyZWQgbWVt
b3J5IHJlZ2lvbi7CoCBBIGRldmljZSwgb3IgYW4gUkRNQSBwZWVyIHdpdGggd3JpdGUgYWNjZXNz
DQo+IHRvIHRoYXQgcmVnaW9uLCBjYW4gdGhlbiBvdmVyd3JpdGUgdGhlIHByb2Nlc3MncyBzaGFk
b3cgc3RhY2ssDQo+IHBvdGVudGlhbGx5IGNvcnJ1cHRpbmcgcmV0dXJuIGFkZHJlc3NlcyBvciBi
eXBhc3NpbmcgdGhhdCBwcm90ZWN0aW9uLg0KPiANCj4gUmVqZWN0IHNoYWRvdy1zdGFjayBWTUFz
IGluIGhtbV92bWFfd2Fsa190ZXN0KCksIGluY2x1ZGluZyByZWFkIGFjY2Vzcy4NCj4gQSByZXF1
ZXN0ZWQgZmF1bHQgcmV0dXJucyAtRUZBVUxUOyBhIHNuYXBzaG90IHJlY29yZHMgSE1NX1BGTl9F
UlJPUi4NCg0KQlRXLCB0aGlzIGlzIG5vdCBqdXN0IGFuIHg4NiB0aGluZy4gQXJtIGFuZCByaXNj
diBoYXZlIHRoZSBzYW1lIHB0ZV93cml0ZSgpDQpzaGFkb3cgc3RhY2sgYmVoYXZpb3IgZm9yIHRo
ZSBzYW1lIHJlYXNvbnMuIERlc3BpdGUgbm90IGhhdmluZyB0aGUNCldyaXRlPTAsRGlydHk9MSB0
aGluZywgd2hpY2ggKmlzKiB3ZWlyZC4gQnV0IHRoZXkgc3RpbGwgdHJ5IHRvIHByZXZlbnQgdGhl
DQprZXJuZWwgZnJvbSB3cml0aW5nIGl0IHZpYSBsb2dpYyBpbiBndXAsIGV0Yy4NCg==

