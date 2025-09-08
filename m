Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D879ACAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B5A8E001B; Mon,  8 Sep 2025 08:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 404658E000E; Mon,  8 Sep 2025 08:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC6A8E001B; Mon,  8 Sep 2025 08:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1972E8E000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:55:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA3E21A015B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:55:45 +0000 (UTC)
X-FDA: 83866079850.21.6E70B52
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf18.hostedemail.com (Postfix) with ESMTP id C18281C000B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:55:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cHY7HLsN;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf18.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757336142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSadJWzQiyJa+gnD3zl687C0ALZ38LSEVNOXUFJNWDA=;
	b=B2bEbc8VExf7f1+a2yVz/fchEZhUGe6J+rTtJIBKX17jXzO5LTcKP0g7gcqSFScHXbCk3U
	BAdF8Mwjbm9zVLfjohxKuyg35YvFp+ommAbuaFAadoQWjLoZHIsuzDswhAtKayfzLuZK3B
	EMo7GBBVmtrUCEE1hYBCG5O5yTKVE+I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757336142; a=rsa-sha256;
	cv=fail;
	b=Jns8+GoUjK6IGuiYX3ylet7ZeQ1KxlOa6zVgln3dI4fiZSu456HvcgQCmDkgi06cxgFPd9
	fF46YX3Y2w2IgpRGW3W/2uGX5+XA1fGgYW86dc6agfn3Xa7rHPKait/cBmopOmyVCTcJTc
	mgGVZigSNG4EjBShFhwVljtYaXfo59M=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cHY7HLsN;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf18.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757336142; x=1788872142;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=PwBcB3gg/pikuYrfbTY+sTvbQ5ZYxbD93i8ywhNgIAA=;
  b=cHY7HLsN25GBBMpjz7EgrcSRPgGB9yMUyTJOGKsjJ+Humx/QPJnMiHF0
   NLU0p+2L+vRsVhg6X/314RqwskS/ir2kYPUVWtpI8EuHHG2GCrHVE2NWd
   6+UTsKYdrLgKUJlCIUtlT8/0DJVuZHvnus5XKOmAIM3/okcVo37NyOV27
   X8wFXc4EJ0W6XZA8S1os0OEth4FygIp2FHgX1F44o6YPlQaYtIRi/19bt
   98QAR4g/8SKjQRXmAdlrDfqbi2lmz39R9BDY7aANddjCtwCiqibz6UrIs
   suRS+31qFtof0p4NtvVy4/sPFlQLIlFSBgPZNfMmtD8A9M2CDZFQqqY2l
   g==;
X-CSE-ConnectionGUID: yVUW/zdISO+8HG3/aKhSuA==
X-CSE-MsgGUID: enJqbq/DRdmXnfUYMWVVmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="47165044"
X-IronPort-AV: E=Sophos;i="6.18,248,1751266800"; 
   d="scan'208";a="47165044"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 05:55:40 -0700
X-CSE-ConnectionGUID: Q4fvfY8KQQOlzYKHb3Ay5A==
X-CSE-MsgGUID: 94jO0QjUQ2SrWuNqd+XWtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,248,1751266800"; 
   d="scan'208";a="178008264"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 05:55:40 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 8 Sep 2025 05:55:38 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 8 Sep 2025 05:55:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.59)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 8 Sep 2025 05:55:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EZkc0PJKt0xywMb3sxp6ViYJ5b7DKLBTO2+XZIhPxNmZkoOxm35i8BUSUOxsisARhomi013oT94uUiQgyjldLGOGBf5iWWzzQkaliYhgQqihtaW9yoaszI61vlMVZaUvdI9I42sqLD6ZHy3N4fOlFiEFOfeiMdLpPaLHWwQlj8IAIb8G5hK9eDr7ydIa45yTxUX3xeLA5nG9yDvZkb/KlaFuKzFdF5jVfLO1/njhmTX9q9+rhzEjOIet5fhRDz0X2CkizxwJocztE0EtdV/3gZWLTH8F+xKFcdm2biM4fxxHYgR2L5yrwH2f5aKZyZK+zDYCIOFmPBGo0wAWV87W+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xSadJWzQiyJa+gnD3zl687C0ALZ38LSEVNOXUFJNWDA=;
 b=rLhENxjv52IXR0ZUmQH6lMC22w2D8eLROOqiTfbsOstgcP6Tvx825CdfjBcq1qQIF82LCdJYA/RUblmNLGhDZL8DEzpP9nyuMemRSf+uHdQOBhiEFymh/wRABmP+BueE4bhX5BFBniPoohTMWFQYQAr1nRK/2cRzpMIVqw3CR6IRvt+ZvdNtQyg8EE9Gx4ULhEGVpFG69YHV8B9xWCweRXsc3OsJ3FcPgPuOsKbMktKvTQg/fBVSVLI6oTg4Ryk50Hp4PU2qRhGlpVvtJ0kJB9g/XuNome7KcK/7QSy5gXislXKTZzpd9M5IEsmSTz2CjCuyabUrCpfQV7Igw8Q8qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3934.namprd11.prod.outlook.com (2603:10b6:208:152::20)
 by CH3PR11MB7868.namprd11.prod.outlook.com (2603:10b6:610:12e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 12:55:29 +0000
Received: from MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2]) by MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2%3]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 12:55:28 +0000
Date: Mon, 8 Sep 2025 14:54:32 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
CC: <sohil.mehta@intel.com>, <baohua@kernel.org>, <david@redhat.com>,
	<kbingham@kernel.org>, <weixugc@google.com>, <Liam.Howlett@oracle.com>,
	<alexandre.chartre@oracle.com>, <kas@kernel.org>, <mark.rutland@arm.com>,
	<trintaeoitogc@gmail.com>, <axelrasmussen@google.com>, <yuanchu@google.com>,
	<joey.gouly@arm.com>, <samitolvanen@google.com>, <joel.granados@kernel.org>,
	<graf@amazon.com>, <vincenzo.frascino@arm.com>, <kees@kernel.org>,
	<ardb@kernel.org>, <thiago.bauermann@linaro.org>, <glider@google.com>,
	<thuth@redhat.com>, <kuan-ying.lee@canonical.com>,
	<pasha.tatashin@soleen.com>, <nick.desaulniers+lkml@gmail.com>,
	<vbabka@suse.cz>, <kaleshsingh@google.com>, <justinstitt@google.com>,
	<catalin.marinas@arm.com>, <alexander.shishkin@linux.intel.com>,
	<samuel.holland@sifive.com>, <dave.hansen@linux.intel.com>, <corbet@lwn.net>,
	<xin@zytor.com>, <dvyukov@google.com>, <tglx@linutronix.de>,
	<scott@os.amperecomputing.com>, <jason.andryuk@amd.com>, <morbo@google.com>,
	<nathan@kernel.org>, <lorenzo.stoakes@oracle.com>, <mingo@redhat.com>,
	<brgerst@gmail.com>, <kristina.martsenko@arm.com>, <bigeasy@linutronix.de>,
	<luto@kernel.org>, <jgross@suse.com>, <jpoimboe@kernel.org>,
	<urezki@gmail.com>, <mhocko@suse.com>, <ada.coupriediaz@arm.com>,
	<hpa@zytor.com>, <leitao@debian.org>, <peterz@infradead.org>,
	<wangkefeng.wang@huawei.com>, <surenb@google.com>, <ziy@nvidia.com>,
	<smostafa@google.com>, <ryabinin.a.a@gmail.com>, <ubizjak@gmail.com>,
	<jbohac@suse.cz>, <broonie@kernel.org>, <akpm@linux-foundation.org>,
	<guoweikang.kernel@gmail.com>, <rppt@kernel.org>, <pcc@google.com>,
	<jan.kiszka@siemens.com>, <nicolas.schier@linux.dev>, <will@kernel.org>,
	<jhubbard@nvidia.com>, <bp@alien8.de>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-mm@kvack.org>, <llvm@lists.linux.dev>,
	<linux-kbuild@vger.kernel.org>, <kasan-dev@googlegroups.com>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 13/19] kasan: x86: Handle int3 for inline KASAN reports
Message-ID: <hw7xa2ooqeyjo5ypc5jluuyjlgyzimxtylj5sh6igyffsxtyaf@qajqp37h6v2n>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <36c0e5e9d875addc42a73168b8090144c327ec9f.1756151769.git.maciej.wieczor-retman@intel.com>
 <CA+fCnZcMV0BOJyvx2nciCK2jvht-Hx0HnFtRzcc=zu+pQSOdVw@mail.gmail.com>
 <couuy2aawztipvnlmaloadkbceewcekur5qbtzktr7ovneduvf@l47rxycy65aa>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <couuy2aawztipvnlmaloadkbceewcekur5qbtzktr7ovneduvf@l47rxycy65aa>
X-ClientProxiedBy: DU6P191CA0062.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:53e::11) To MN2PR11MB3934.namprd11.prod.outlook.com
 (2603:10b6:208:152::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3934:EE_|CH3PR11MB7868:EE_
X-MS-Office365-Filtering-Correlation-Id: a808aa26-e72c-458c-cd19-08ddeed6fc60
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TEZpdXI0U2U4UTBabmtPbkJTZEpmYkdRT3BmeUZQL3hEWXd2TmQvbGxTU2sw?=
 =?utf-8?B?SFhsQmpjMkNuSmttd3lFMU5ic2dsM2dlbXljUmF6Mzh1K3pYbFArQWxhRWdI?=
 =?utf-8?B?VUdGemRiWFp5L2xNTmUrNjV6b2thbXRqNVEyNE9aeUgyT09MNy9sUzVsZHc3?=
 =?utf-8?B?YnZNeUFnM09PSVgrbWg1Mlpwb2dhRFpmQ1RxS0RBU3VmeU5xMks1b1ZXSDBK?=
 =?utf-8?B?RlB4TlFML051OE9oOEJUU2FqbWwvQ3BPOEtsZDN4WUI5WlJoSGVvdWVYUlFS?=
 =?utf-8?B?WDIrRkJETFVPYXJuZjNtWU8wMXhuVm1CK25TSXlEN2lmanJ0eE02MUdaNkRM?=
 =?utf-8?B?WXVxZlZLV2d1S3JGbE5oMlJmY21SYVZGWStpTDlPLzJNejlwRDVTNGNMRjdZ?=
 =?utf-8?B?VnN6Zkxqczc5SEN4QWUrN2hiSXZNeUJNYitkNWdHRWlpQ1BYRWRZMnZJK0l3?=
 =?utf-8?B?SnRXOWpEeUJvSFpJMWdna3lTT1hpeXJmaG9SbnlEdHJkM2h6Q292akFMdzlR?=
 =?utf-8?B?Q2xsODQ3eENoL2ZXUHV2aFpKL1gxUm0yaDZUQzk5V05yNUZJZlV6eDJsSTJ5?=
 =?utf-8?B?bEFDRnJTZjZkaE5EcnJjbWFVVFRMY2tRdXIwNEJUNkpockdib1hSYjFlRm5G?=
 =?utf-8?B?c3FWdGI5akZXN3BuWE41cTZiRjRqRm1Tcmx4cmlla1FkUTl2RHgzTGh6SzNR?=
 =?utf-8?B?UXRwRzN6Smw4cFA0RzBjRHFpL2IzUmFWNG1YOTh1OVl0OXMwVnRZd3lpRVFi?=
 =?utf-8?B?VGJnWnYzK2N0N1J2dnpvRkd1YXZnS29MTWxVY1pPRUNqNHR5cjJHMDgzM0xx?=
 =?utf-8?B?RHpDOU1vdWU4NksyV0lEVFR0VDUzOTIrRGUwUlpQVUpFcmZjWlo5ZHZKT1lD?=
 =?utf-8?B?dVB2d01HSDBrOUZYcVRsTVRCK01PK1pqRUhRQ2Nua2k5cGhVNHNEb1o5alZs?=
 =?utf-8?B?eTIrY2tLd1VsTm92YitCZ1NwUnk1WlVRNk5YMWl5RFJVTkU3eXk2ZUZNZUtU?=
 =?utf-8?B?VDlUalZTVElkSGErbnVLWVBzbGN1eFZxTVBEMmU5dEJSYjhKWlplcmFaWUVr?=
 =?utf-8?B?M3pEQ29YWW9qRisrTURnUXRyTDd0VjNCTjNzbmw2by9FU3V4Z3pKa1hHa2tP?=
 =?utf-8?B?SitLYkdFRDQrT2F6eU83Uk50N0xlMERVOEhaMStmaCtRTGFpS0VvdlV1L1hI?=
 =?utf-8?B?RGFnZUI5RTA0STM5SlNlTmpIRUdGUTIrdzJGczFIL1U3SG5oNzVrazgxZEJ6?=
 =?utf-8?B?ZVVHVVVqTkdRVGxIcjJUQTRjS0VucksvZllEc2RqcFI5WG5IV3cxeXJuU0VM?=
 =?utf-8?B?K1dpLyt2dGh0MVFpbGJJVlJCN2xyUHZhK2V3Y0pxeWJhT0w3Z3B0RDZSaDRa?=
 =?utf-8?B?cVZBYmRHOURmWjFFMWlQSGhkQjhKdnRwd08xOTVpVWR2eTJrVWtjMDNFa3VX?=
 =?utf-8?B?SFFRbUxRWWFjT2xoVVd1OFljd1BPTTRCei9PRFFJTndnU2UwdWpkNFBDMVlG?=
 =?utf-8?B?N1A5OC8ycXlyVGpZYXhQVVYzVXBPaHBGQWNMQnhUVWlERGpydDFRZU9VODIz?=
 =?utf-8?B?cXlLYUN0VGordWVDaVRYWlY5MkVnM0E3Vjl4SVpyQ1pMaFVNWklLM0xoRmtZ?=
 =?utf-8?B?bXhtREMxdkFmelJ2cXEyVFpvSnlHZ1M4dk85clJRY1ZZczFvb1RNTGZxSGRK?=
 =?utf-8?B?T1pIbkJISlBYWkJFVlJLdHJrWEY4bnd5eURHWk9NaktNRldrTlRYWXcvbWph?=
 =?utf-8?B?WnRLNDRsNlp5elYzalkxU01yY3hoSlQ4T3M0Kzg2ZTh1OVZvaWwwSUl2Z0dl?=
 =?utf-8?B?Zkx6eXhtTW5KN3JSUVBWclZEbXlVRXlZMTQrbTFhS3FBS2NDdHkyVjRaNFdI?=
 =?utf-8?B?aHRNMm1VZHkrWU94WFpmTGVUcFpaVms3NDRwUHB1ME1Ub3d0NkZYT3NLcW1Z?=
 =?utf-8?Q?3d99JjgjAeI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3934.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWtXekFIT1dyQmZ1bGdDOW1sNTBWRUtRcXkzdXhvVy93VGVoY0ZYTHkwSUFS?=
 =?utf-8?B?N1U0RkhtZHhDTXBCUUpoUWErYlFhTjRwcXhsY25qUm1Mc2tZTS9jc05IUDhH?=
 =?utf-8?B?c3ZqN0NoR0dDZDJFeklXSmJXSUk2N3VqT1UyZmgvS2lTK05rZ1RkVmR6bm9q?=
 =?utf-8?B?cDlXMVVHZVVEY3NFK2hMdWdwWk9yY0tlUUxmN2NMcWpDL1pVdk85ZG5BT2VJ?=
 =?utf-8?B?OFVib0RnNGV1UktEL2R4Tjh6eFozWkdJbTVvdE5hUXptT3hZUkx5R0Q1T1A1?=
 =?utf-8?B?UVl3SUJpMytkLzRZaDJvNEdOQWZwOU5DZ051NVF6MzJGRWVDYitnak11TzUz?=
 =?utf-8?B?RDVFbmdOK3ZTWGN0bVJKV2VaTzNTMm9ab0svZXMybHhtZ01uZ3VkNUp6dVVK?=
 =?utf-8?B?bmdtM3JKSC91SzRrTm55KzBxbkNybk5aNHdsQndpNmtWejVxYzhOTklYdUhy?=
 =?utf-8?B?Y3Jmbm4xNVNNa3RwSUZrWDhuUG45ejQ2a1M0aGIwSXFzS3VJMUZHSnIyb2Z1?=
 =?utf-8?B?b0ttYklTckhZY0tFdlc1TnA2cXdoMk13Wnh5WlhnalpzaldrY2NVQWYwa2NX?=
 =?utf-8?B?cmdPbUU5VTV1dWVwdC9FOEcxV2E3U1BURVZCZWU5eGNUSEJkelU4Mk5qTGxR?=
 =?utf-8?B?SGUrU0RnMk5rTk8xUklXNzJFaWVZY1dZZDEwbWNIM2VEZ0JXNzZnWU1nUU5X?=
 =?utf-8?B?VnYycHZmWVl6RXhnKzQzUlFZQk45SEtwMWx6L1grUlJ5dElLYTZpNkp4S051?=
 =?utf-8?B?RzNST0krcVVtL1Q1WEtGZnI2RjZKazZQTEtXcmxYTGVSWHNnd1RPUVNiOEp0?=
 =?utf-8?B?TjZvYlVpcHVVVDRmNHNQRFFOT0F1TlJBazBOdWcyM2ZsL08zVVJodjlSS2VK?=
 =?utf-8?B?blFMNFl1NUpxNzRqcGxFb0tRS2JKRnAvR1lzTFlLS2tCVjZCb3BiL1NWVW9T?=
 =?utf-8?B?Y001TFlmeWJCbDN6ZllCazg4Z2U4YVBXU3FOV2VLbjhnTyttdXhBaWtuc3hj?=
 =?utf-8?B?ejdyeTB5UmZQaGdUQ2pPeDhKamw2NjVMdkxNT2Q4VEc3TUtiOFdhSjl4Y01L?=
 =?utf-8?B?VFMxcFBRVjRZZmJZTmQ0enlNTFhPcTdCcWhHVkpoUDJaaHFZZis4WmlxM2wv?=
 =?utf-8?B?UUlMVWEwZ1dSSWJreFJZWkptSkxzY0NWemZjcFJ3bW41V2Z6dGhBaVRMQmxk?=
 =?utf-8?B?L0dDWnUvSjFlTmNWZ3ZIZGNjdXdHUHFNZVBGUUdqRGx1MjNxZEZhSm5MT0Qw?=
 =?utf-8?B?VEF0Z005bjVQZ0duOHFOUUlXWjNobXVnUjN0V3FJTzdtanZ2VzhTOHZZM0lW?=
 =?utf-8?B?aGY3cEtpUHFIR3I3K0JuRTZBSjU1TTlFK3lyWGYwWXA4ZkxYeU9UU2lTOE16?=
 =?utf-8?B?QWwrMDlTOGIvcUwrN0Nzc3IxL3A1TSs1RmVXZzZSclhGSS9NZnR3SHc1ejNS?=
 =?utf-8?B?WVlKQ2svQTZCakJuV1JReG5CYU0wL0ZhKzFHWGtqNTk0c041S2FXK0p3am13?=
 =?utf-8?B?bXYrTk91Nm1IMG9VQUxaQllhNXJBTXVJNFZYTU5CRVNENVl2N280dU9wbTRX?=
 =?utf-8?B?c2h0OG9PWXRPaE9NeXpRR2cyK3Zsd0dzQ2RVOEMvN1FIck9vY05Jd3lkWXVm?=
 =?utf-8?B?TFY3a3ordFJJZkZjYXU5SXNsSElyNVBhQVdrOGhwUlRCNUxoVTRaQ0NOYzcr?=
 =?utf-8?B?VUFlVmMwV0JkcFd3MSs3dTBPYTJZSm81QVFpd3pSN281ZG10ZE9QTU90ZkVR?=
 =?utf-8?B?bGVDcG9sRStuVFVjMzFrc0J2VFl4R1pHKzdBUXFiZmNlWGVrNkNCeWhheGxq?=
 =?utf-8?B?akFVYkh6TlJtay9pRjRLT1RLR2t6dzhlUlYrSGxGU1VSVUVLZjRUQlJUQTdY?=
 =?utf-8?B?bnRwdjlIUktQNEhHeVowQ3plY2dRbThEOWpWczdmSkJHWHd2aUJWZU9xR0xG?=
 =?utf-8?B?UHUxWStwaFlIY1pyRFdhT0tVRkE5eGdoUHRSWUdNQ2J3RzVpQkNMUjlVcEx1?=
 =?utf-8?B?eDB5OWNDY3ZLQklzN0FJbCtzTVE2TFhKeVdMWXdXZmtMRzBTWVFTdEtQRDEw?=
 =?utf-8?B?YXhwbFVscWxnZEl3Z0ZDcGljYXA5cU9NbFl1TzNPNkIxYXJiZE95U3pWajdk?=
 =?utf-8?B?VVBnUkVuWnhKeGpSRjM5OHQ1TmxIYUlXMWFHdHl0bmNSM3dYRUhQcGRCSkpx?=
 =?utf-8?Q?bGLCRuHNxGytvHMk5Zze1k8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a808aa26-e72c-458c-cd19-08ddeed6fc60
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3934.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 12:55:28.4183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDLGVZMOXEfLUFhl49kR05dQikvQIHACbcJbTPgxPaJ5VgCSV1l8ENd6Pvou6SRNtTCOKxOjmMz1gCa4QZXRV2dvBYoXfyrk3S0DQy5Bt0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7868
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C18281C000B
X-Stat-Signature: 8p8ww396wdbfzi1unt5z417rs7epzu97
X-Rspam-User: 
X-HE-Tag: 1757336141-120940
X-HE-Meta: U2FsdGVkX199ZW29r9CZrSJZ97yUTK3n36iFvSKY6jzDynWAvZA06bwz+VUOjUd7WY5FIiXIC8uqqN/kTGznBux9fYICLjEC/jQSoSVEAdzyCQq3Ks2p7+nQ0vJ3Bw0dLcL5HdpHCb9ytHGwS9dkWlsurlwXWLLpsSA8mFflhAii6+Hylf01uBPgYuIbppMJ+ldwIFnTaFCCkzlvqW9e/1Q0+b9e9uesKYCHO+DCYThH4kXuo0p/yrlPNTzvPtVxAak6ec5cEsNrG9QWV1QlFyEkBV662GqsBtFEiflfmW+NpDJoRdZZYc1j9dw30ZouyO7RRRT8YgDYEExr3uxRtpc/gZxq2G99I8tpHboYXGkGue7W4fGN6nkd1elzCvVu/xh7GwiSRWhTwcHIesZ23kTqkcLxBBPqCI/SMj6VjUva0SSSDnEzcAIt7S5uACJIs9elC2iIMoEvDQY/vrimrjmF84cUYXj+Ui5Sne5DIlklh4hDgumxNEgCPN0NRS+XKwTNxjBZr0r30GP19eCdWfi5y4/Qysc5SuqIRQclIWMliNIG+lgrru8JCslU5EhMnV7918qZ+jd4utULZG4dBsYVEeKIYV87R/k0sEZAlHCnGvi6H/JwvTgon52EUUPy5vkskGNP1uXX9Bq4zgrL3M0SZbhfv9KYrIa0a4SvtKX7n59aimHgxapzAzPBHfbGYPSRCv3kv+vp9V4wjiH4xFVmWhLn37zoYht2GqP3nxjkXjKELzj7aCL2F04vFYfWAzwPpvxzZoYQCoEW2fkKwEGmwwxuSeD0xBgGzs1rnBIAaWkHZfoQwWpmlPFP02mksO7P60l/upeey/hzs4Byuok0eOIAJgyzhYNxco2Ync4UyCUAznS7JY65W6jW4QWI2N/dZU3UvNjXulhlPsEg17gqQ//6hpxi7AZbAdEwHJNi60t351Xb4OcHW1mZiLDsHf/m8fVQAifT1nP6ewr
 8D+jNQvQ
 j+AByPqiGe1YaWdllklOvt6a3Dzm/8/XPdlMA0gT98Un8k7m0E/M7qGOH5N6eiCRYcJLRinGY5irSo70k6gzwXlBg85ONtvtqs/Hr5YpoTpjucD67uz+80zEGu/Q/6iVMMM7pW7DZfJs0qayGA2Lh4MKHyc79X0NyNkwdjWbp2RIp4Z3v2DwFYb00i0fVtaeNBaOjXEPvByru+xM/uHjL6pLs+TjAKq3mJFlVTOMPZy1nN81ZmshcDqCcC9pQcyHJyY3FYbmCPaFt15iPOhTluBQkPpJIO46bmmHwvKU+M6yW6C12OpQXnwmk5PnUWcgoDNHf48I3foKrR/ifQKN+RLHUBr6/gGtrD3smgHwxtFBRBJGPWnqffhkwAi23Fk8OslNiizkExV/1xs9b6ED21lXMBMMD2IFE1pw2Xl2tX8NGxjQ7wy0dYCV0M1R0alhlyxbN3uhgEfMF9G8l/xiqFDE1HHGOdGpTfO6ENIed0jgiJ9FZdIL4W+bQhJxI3rz/merdxF6rlsr5g1v4wmU6dDmRcedc0s3XxgqCvWcgCJEnISmTkv15M9bJtF8MGn3Tv2Yd83870CPWy+t2u8S0bO295QdsA9FhLmiTRSuYEM8XohUHthW+NJ2xideAihU9SQ142F6acpBDBjp1wr4i8HmNW1MhQxPfYxAl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-08 at 12:38:57 +0200, Maciej Wieczor-Retman wrote:
>On 2025-09-06 at 19:19:01 +0200, Andrey Konovalov wrote:
>>On Mon, Aug 25, 2025 at 10:30 PM Maciej Wieczor-Retman
>>> diff --git a/arch/x86/mm/kasan_inline.c b/arch/x86/mm/kasan_inline.c
>>> new file mode 100644
>>> index 000000000000..9f85dfd1c38b
>>> --- /dev/null
>>> +++ b/arch/x86/mm/kasan_inline.c
>>> @@ -0,0 +1,23 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +#include <linux/kasan.h>
>>> +#include <linux/kdebug.h>
>>> +
>>> +bool kasan_inline_handler(struct pt_regs *regs)
>>> +{
>>> +       int metadata = regs->ax;
>>> +       u64 addr = regs->di;
>>> +       u64 pc = regs->ip;
>>> +       bool recover = metadata & KASAN_RAX_RECOVER;
>>> +       bool write = metadata & KASAN_RAX_WRITE;
>>> +       size_t size = KASAN_RAX_SIZE(metadata);
>>> +
>>> +       if (user_mode(regs))
>>> +               return false;
>>> +
>>> +       if (!kasan_report((void *)addr, size, write, pc))
>>> +               return false;
>>
>>Hm, this part is different than on arm64: there, we don't check the
>>return value.
>>
>>Do I understand correctly that the return value from this function
>>controls whether we skip over the int3 instruction and continue the
>>execution? If so, we should return the same value regardless of
>>whether the report is suppressed or not. And then you should not need
>>to explicitly check for KASAN_BIT_MULTI_SHOT in the latter patch.
>
>I recall there were some corner cases where this code path got called in outline
>mode, didn't have a mismatch but still died due to the die() below. But I'll
>recheck and either apply what you wrote above or get add a better explanation
>to the patch message.

Okay, so the int3_selftest_ip() is causing a problem in outline mode.

I tried disabling kasan with kasan_disable_current() but thinking of it now it
won't work because int3 handler will still be called and die() will happen.

What did you mean by "return the same value regardless of kasan_report()"? Then
it will never reach the kasan_inline_recover() which I assume is needed for
inline mode (once recover will work).

-- 
Kind regards
Maciej Wieczór-Retman

