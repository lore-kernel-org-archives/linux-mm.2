Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55BCBC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31416B015D; Thu, 24 Jul 2025 01:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE21F6B015E; Thu, 24 Jul 2025 01:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B828D6B015F; Thu, 24 Jul 2025 01:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD246B015D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:01:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA733111A9F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:01:24 +0000 (UTC)
X-FDA: 83697959688.30.1E3B56A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 923D014000F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:01:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ESDzM8g7;
	spf=pass (imf23.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753333281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRxmwQAWXZdwJMDke+S336eEtebbGfb5pAEJHo3omU8=;
	b=KA7IyadHh9VJXNcbfKzq5/pC1IWiBXanra0jQKu7g+HMD5P/iXgwHdsRi18IQRI8Don2h5
	3RjePU9VUM3C/VMoWqqEXNFY+7s2QcXbnF+sO+zI1DJ/H+gzF+Cn19P6dghKf1HgEUwjjr
	9MpGAEknltrWcVL2WAS6K/Uuh2ydvnk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753333281; a=rsa-sha256;
	cv=fail;
	b=U1FvKiZyfe/6vYyJsxmLkpK0LE6LcftwinHu+ykMmUibRsol3X/bZJlNATgh8vufoIkogd
	bc1F+KNAzj2qfOlivB8vjZygGJnhOtFm4l7ZMZaE3B6sRFbT2MFmnNlg+Y4ydcOpxE4zNZ
	y7bNcArThj9jynJzWyoOg2z0CZXu65Y=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ESDzM8g7;
	spf=pass (imf23.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753333281; x=1784869281;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=srwlUG46rEDB4ouEGQD2rIYLBJw6wvefPZsxDrqfiZs=;
  b=ESDzM8g74CkzmaX1UF/sxYXDDkt8Vf8jKidek7raePqzBwl69inFp59a
   1TzTOLkha8gGkWp7TCMa2dhuiWNOO81yrF9Y0OE4nBYbNB0AIob91mDot
   +CECjyH6oxT4LSAMVrlimOfmeWLMFyQWCCFQEE3mQ695RcpF6igDQwLNK
   l+jVEfxCXmVjIG5F2xd2HpmB+iTnFqvErdZkX/3Otw/atoFjSjL/YoaQ5
   L2/UN0psTOITP6m3GTOfbH7AIxyFCeXGIV0upA/Ov5wh/w9PVgM4EgfxQ
   CfSB7Sl868n/TI4vMUWULnM8AW33EsbUg3jnCWG5jsI2UpmEXzGetxWND
   w==;
X-CSE-ConnectionGUID: grxV33scQIiLnMYgQ8ZIkw==
X-CSE-MsgGUID: 8xggGN5BR9Wb9gPacD7I6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="67059524"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="67059524"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 22:01:19 -0700
X-CSE-ConnectionGUID: RNhdmmNGSzqFaMamlvXUmg==
X-CSE-MsgGUID: 6X/pNraxQ7awL2YCfNxG+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="190913932"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 22:01:16 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 22:01:15 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 22:01:15 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.81) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 22:01:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mRctKOVD8pgCttkxdnA/eDMI54rnKvTXmzgEKnLeKRsnsw0g7UMPpbNckoHZCerRq7bKXjjH2lh4z6alaEe1qt11//yXZZf+7GGX9cdqAhOilOtcrCWjjAVHuWPT3dVxq2TrrVOkh+RcFix5W6qkMppDhok0JWiE83vEzq8ePYvSQBfShMtTUmm/8uGNUPsFho83UI7ZN10wUpmVRiLvc8fTupWiYB6pO6mA2leD9y1PxwHjUXyOmkcrwWFsjDd7WvR/6k2UZanf+5nEtiDqNSd6ABKSGGLpvOx/ynoa7Clc0y/yInkKHSdCMjT27Ac6wo93IxhM8FhcnLDNUlGDlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YRxmwQAWXZdwJMDke+S336eEtebbGfb5pAEJHo3omU8=;
 b=uF0yZ+K9DDWDMuu+r4Yv2PWQ6Nou4c//ZHDr/T0PmhFleYGONsnwSoLb0xfRDsZf/spWNYjBdRnLmp6egevgKvr4Yom0ISttGArZmlJNSFqEfYVRUFNNvZRP2NnX9Nko/OOLRd+BH9eYVORqw9ayWjAragc8JSnSxPpg3ti5mT1MKFwwqWBLrgU6Ifqu+RRU2en8fQYnh9rzBdWdxMpLTJ/n7GxGrIfFtt3+ABPnP9ZvmzEicTIQGswcKLEKORqcbX2bkurSOFwL/DaHcZ+qcBait86u+4F8tJ3Am5yG5j0GuZaAo7fqdYsH3YLiVpWKyiYNAkvGivrsJw1w+PlLXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DS0PR11MB6470.namprd11.prod.outlook.com (2603:10b6:8:c2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.30; Thu, 24 Jul 2025 05:01:11 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 05:01:11 +0000
Date: Wed, 23 Jul 2025 22:02:58 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Balbir Singh <balbirs@nvidia.com>, <jgg@nvidia.com>, <leonro@nvidia.com>
CC: Francois Dugast <francois.dugast@intel.com>, <airlied@gmail.com>,
	<akpm@linux-foundation.org>, <apopple@nvidia.com>, <baohua@kernel.org>,
	<baolin.wang@linux.alibaba.com>, <dakr@kernel.org>, <david@redhat.com>,
	<donettom@linux.ibm.com>, <jane.chu@oracle.com>, <jglisse@redhat.com>,
	<kherbst@redhat.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lyude@redhat.com>, <peterx@redhat.com>, <ryan.roberts@arm.com>,
	<shuah@kernel.org>, <simona@ffwll.ch>, <wangkefeng.wang@huawei.com>,
	<willy@infradead.org>, <ziy@nvidia.com>
Subject: Re: [PATCH] mm/hmm: Do not fault in device private pages owned by
 the caller
Message-ID: <aIG+gqY2YRqBeKlh@lstrano-desk.jf.intel.com>
References: <9ae3e014-c7d0-4d58-af0e-925bcd9e4cfd@nvidia.com>
 <20250722193445.1588348-1-francois.dugast@intel.com>
 <023ab16d-f3af-487e-a7ce-929bf7b2fe3e@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <023ab16d-f3af-487e-a7ce-929bf7b2fe3e@nvidia.com>
X-ClientProxiedBy: MW4PR04CA0214.namprd04.prod.outlook.com
 (2603:10b6:303:87::9) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DS0PR11MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: ab320e82-9007-4363-c13e-08ddca6f1b7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V1NRRjFCTUJDK2tzWFRrWVMrVFo0ZkE5OWlLN0taNkNVcVZzbTlqUFVCM29C?=
 =?utf-8?B?ZFk2K1QrT1dncVNEK2hKSmY4WWpuT2ZPeGcwZGVISC9LeHB6SU1IR1NpT2g3?=
 =?utf-8?B?SlF5Szh0TExqQkhSSXJkTDRPYmNZMi9NVzZOMmVNaEdiYlRnZVgvampEOEEy?=
 =?utf-8?B?YnZldjJXMEVlZktqcENjZVlURm9mTlNZeDlDUFFkUWhSZVNsS0lIN1VZaWk5?=
 =?utf-8?B?eW91SkkzSWxIUkZNV1kwZVR1UHlEVTBLQjkwY0wydkVPOC84aStVOGtZeTlP?=
 =?utf-8?B?N1J2blpEYUIwZWtiYmltMzgwcFlsR2E4QnFPZzBRQlp4eVJwUFlwTW5yMkpM?=
 =?utf-8?B?RXpFdUVib0lWUnErMGpPdkhaQ2k3M01kYk9HZmNKTGJLQVhuMGtYc3RhMHBu?=
 =?utf-8?B?bmNnMG9Hek9FM200THd5TDlnbExqcVVhakt1YWNza3hONXVrMHVIaUJpVTVz?=
 =?utf-8?B?TDZNR0dneEpEMEpld09scFp3elQvdUhHb1BGYWdZMlQ1N2laUUJ2WG85SmEx?=
 =?utf-8?B?TlEyd25mbXdNenBxUzBlT3J3YUZwVmcxRlU5OG9xeGVzR1k4T3JVU2xEVGV2?=
 =?utf-8?B?RVgxRjNuNWJxWUFsVW5WTlJqY2h5akc5TTRNSE41M0VER2t2aEpWMFpENk5B?=
 =?utf-8?B?NVhsT2hNME9Idi9QY1YrOVpaVWxWVmVsSFdBMXBpVXR4Zjd1a1lKMlUyMjlP?=
 =?utf-8?B?RmFBMTlBRXpOK3FYYUFUSU1SQnVMeCs0ZEsrWll1M2xyZEZjZUpBZUtMNHdQ?=
 =?utf-8?B?S2JsSU4wNFVxZ2NmMXZaUVorM1hhWlpyaDg0YVFJcnNVVHpyek4yUDJDdng3?=
 =?utf-8?B?cmdDTHFrWXNhbDdDVzkrbDFEZENzVGV4VTlIdUlWZzBnZDFFamMrdnpKcWt1?=
 =?utf-8?B?VFlqMUo0bEYrU2xpaUl2b0QvcDB0bWlWMDg0R2RPQkIzZWxJVndVclFJVG10?=
 =?utf-8?B?S0ZkZjJyV3ArUEdwVlhrVEREa0JRVDJTSlZqT3VRNlA5VlhpZVJ1TnhPRkZm?=
 =?utf-8?B?Q3FWVUhybUdtdFhHRmZYOFgzRklvZWJIV1pwVjZuYWhtTTJ0WDM2enAzQzBu?=
 =?utf-8?B?Ukg5d0tUalplVWJyamhhYnNCOGlvZzBOMjY3eGNKbzZ3enRaQ3pNVDYySUNw?=
 =?utf-8?B?eXE4MmV3M1VxdWVyMXRQYmtzdFZKelFCM3dISHNma05FelNiYVNiU2VlN2kv?=
 =?utf-8?B?OVBWY1Erek9rZksrazdldHJ5TExZem5oRUJUTi9YNUFJUTZrK1FBdll1SlQx?=
 =?utf-8?B?cTdRK2QvUGEveXhUOUdQUG83dVpPNEUwcEg3YVJaNXpDYThyYjJKQ1EwKzYv?=
 =?utf-8?B?L0JKdnJLNGorTzcwQ3orVG5vNHQ0N0JrekdHY013Qmg1TnZ6QU1aeFpHdDEy?=
 =?utf-8?B?RlRvM0RsZlpOWTBZOFRmL1Z1Nmkzb3huWC9EcDc5S2NIYTV1a0swSm9kVkl2?=
 =?utf-8?B?UUZhVE85cE5GZElzV3NaKytWM0ZlS2VNQnU1K3hkRkRndHd5ZVQ2ZkQxcVlk?=
 =?utf-8?B?NUljU2c2cDg5Ynd4a3E4bnVUeHNJdFhvREtPMlZCdXgzemkyY25zbElWZjFN?=
 =?utf-8?B?OWRKUjNBRDkvc2VJS3VZRHQ4dkNTQUY2RkppYVRsZnk1bGtuTHhkLzk5Rmtz?=
 =?utf-8?B?SE94TzJZSXk0eDFUWDVFUDh0c0hkdkF0YmhmMTlJZkNNcXFIT1F2My9leVBX?=
 =?utf-8?B?WEhOOG1sb0VTeitxYVN3SXVVMnpNN3dwUFZxdVpGcEJvU1Fxa3diWlJzaWdo?=
 =?utf-8?B?N1RobVRMd21UV1FvM09mbGFJRzYvNTJ0dzlKS3MwenZHVzg4aU54SXhOOGtl?=
 =?utf-8?B?WURkSm9DK205MTRGL0VxaU51ZCt6UlNCNFk1emVXVkZnOWRSeHAzZ2hUY0Q3?=
 =?utf-8?B?RCtuMUMrVkgxWXNqUU50U05ucG1JaU0zWEdwbFVCRVRBekE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0JDMG42eGhYMy9ydGF6aStEMmNuNEhjWDB4ZTV3TzFqOG9DSE16R3Nydllz?=
 =?utf-8?B?bkEzV3Z3V291dkdUbzd1dno1b2J4Q2NGRlN2SzdhS0Z3dm5XdEJaQVo1NlA3?=
 =?utf-8?B?aXgrOVptZnNpRzFWdmtRQ2lnNUlHQzR0WlRVKzNHcHlKSThUTGgzbFNFc1NX?=
 =?utf-8?B?Zmp3K21LTTl6TTdDUW1QZTRNQm1JNUYvdGgwYldxTmZZa1BFWTZQczVUVnNE?=
 =?utf-8?B?ZHFpbHhzdjE3Yk16RkpKbFoxY1c3c2pYNUtsQnpvMU9nL0lkQy80TG5pUkQ2?=
 =?utf-8?B?bzFNUjVMemRZeExrR05nU1VPckJFZS9VZWlSTkR1aEVYcFRvTDJhaFpIbmQv?=
 =?utf-8?B?a1NtYWFHZGVOOVY2eGQ2R25TcTVYNEp6WmRLMGpleEhTNnkzcTNoMElhQ2Ro?=
 =?utf-8?B?WlduS1VncWJlbFRJM0N3UHBhelhETUpVVWJQTlRmUzIrWUhNMVJKS0FJamFw?=
 =?utf-8?B?dHRWVHRlTkU5RnVQa21sMW5DQ0taRXpub0xaREhpVkJydDNlaUpzSVNHT2JH?=
 =?utf-8?B?QXRPbWJaRGI2TkJLc3EyVEJWUU1ZZmVkUmY3VHZ1RXF1ZzAxQmkwcDJmVmF2?=
 =?utf-8?B?Q0V3Q055SjluQ05qODFFNi9WVlBtQ1c0Y2VIM2dTcHVWd0ZOd0NzNEdUSEpv?=
 =?utf-8?B?R1lGalhjZzdySXdjMncrWFhHVlh3NkxldGpEalNDb0MrTEV4Q09IT0JsY3Rx?=
 =?utf-8?B?R05BdVlMdmpqMTNDaWZldWMwU1QwUitLS2tZeTNqbFFnbzNaaGU1aEovYTlm?=
 =?utf-8?B?WllnRzRMN1lXMzhkWmx6S0dXcE0weU1KeWhRb1Vmc0tVNDVCYTNBWW82TUgv?=
 =?utf-8?B?MGZHSFJsNTdsQStJYlZWQlFnUFhFVGtUZ1RSWUFraGthSUp2eWowZFhRRlZv?=
 =?utf-8?B?UTFjaW9vNk1iZTl2VVRLcFFwaUgvdUdsbmdlR3o4RHg3aGU5SWovWkRXRGNj?=
 =?utf-8?B?UDY3cjMyRDRJR28yai9UY0dmblFiOFVrZXdNbGdSQ1F2YXNnY3MwbTFRS0VX?=
 =?utf-8?B?TmFEbnoxNmxCaEt0T0RrUFVJdnJIS2I4MWJGNFlZMVJaOUJVc1FVclhha2NW?=
 =?utf-8?B?QXgzazRkSTA4djJadTZCUjc5QStwTG9hWFBwbW9vMVhDTFo0YWY0dkFROU81?=
 =?utf-8?B?eWF0MmlHcUlyWTBDajhBVFNqR0dGVytCZUJlWWFnRjJRbklrRjc2QlpTL1hq?=
 =?utf-8?B?M3dtem1nZjlUdHgxUFBKSXYzVHpnWDR3QTE3UzBFeExpN3I0cmU2a25rZVRT?=
 =?utf-8?B?K3hRMStUVGMzN3FSZ1NOb3kxanNYOUl3MDJkdkRVT3ptU2pUMFpTaVp2WlhM?=
 =?utf-8?B?T1dmTWh4MFNDUE9lQlpvbEtENlJzY1I0S1gzWHlVcStSRUNJTmJqNldTSHdL?=
 =?utf-8?B?OUhVMEQzejV5NzgzbGFOUVZUUy8yTHJOSDBxM1ZPN1hDNnROZTlRdjFkVk0r?=
 =?utf-8?B?bXhra1pheEhaZDdkNEV6ZkxsdTJ1bmJIaEhVaFVJYjhsc0ttZ0Y5ZGN3MXBr?=
 =?utf-8?B?aExmdFpyb3JZUVpOU1JhSWlUYWxEZXV4RDkvTVFwUjliWm9aWTZYcVUrN1ZS?=
 =?utf-8?B?bVRLd1NSWlRSRGZlb21NWllJN0hQNGhlb3Q1UlE1c0JZaDFkcFIrdEVENWhW?=
 =?utf-8?B?MHJuWkEyV2QwR2JyWTJEL3o4VXJ4eDI3aENpNVhBSk9VVEtkV21HZ1RyVkp0?=
 =?utf-8?B?Rm5jT2tyb0YweER4NTQzaXRnbGo0VVhva21lQmZ0aC83MmxGRklOV1BEOExN?=
 =?utf-8?B?V01USkxFcFlDOE5ZSDE5Z3pCTEpIUDJ1Vk10L216eXh6MEFhblZIQ1R1VXhv?=
 =?utf-8?B?OFhkTDgya01ydjR6aU93SFhxU1o1M3pGVFZyVVlhQk9Zc2N4bFZwMlI3VHhh?=
 =?utf-8?B?ZThpMlFSeFNOaGVLM05wNVF0KzVQeWFkZmhEUml5RjRpNENhN0ZPTVU1K2xH?=
 =?utf-8?B?Ny9yeEdGRS9WMXhMMDFVd0lXZlFmTjdlZ21BMFVuQ1lsQ2szaWVNUG42dTlN?=
 =?utf-8?B?cTJIRjgxMWJmZzlob2hWSU1HbE5keEVma2kzK0piU2pHaisxOGpxSnRYUmpt?=
 =?utf-8?B?T0U1ZzQ1TmVoNnZCK2J1QzV6Rm9YVmpiT1JjL21sY3c3Z2U4bmpmNEpNbTVq?=
 =?utf-8?B?T3hEU0l6ZDFCVFVCbjlOeVU5MmlmNzhFTjEwaHBURWI1WXBBNTNsaUJvVHNs?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab320e82-9007-4363-c13e-08ddca6f1b7c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 05:01:11.0383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J/6rzojHFyzhGBQ4HLqEFBjA8F+HlHR8Qmc13X2b/zLUC2J4VmzIebFtfEA8PCay0xdVY1dDPBO1+W2yyFVMyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6470
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 923D014000F
X-Stat-Signature: 49oafn43x44hyyu79uqhpyozxoqkpsj1
X-Rspam-User: 
X-HE-Tag: 1753333280-431333
X-HE-Meta: U2FsdGVkX19B2x3XdJNrbToSDpb0MWDD8A4jI435Jt1U2OMj9Uqkw3Cpw0gi8fWTjIZITsGAlTHnOs4k/UWeGZASljINK73MpmfL2nzjRCTE/mjPK0vQgNsKiUhGWCf5q04QH7STU6d1O22glNf8c210/fkPyigDvaevpMDpdp5h0aolqjBRFEMBkKQuei5gCRODGdph/PRvvxMmWF3e6KX2UwOIG3VwdC10/5FNrwVqt9t5PGKodJ8usTeHwRUaV2LVsEC2gLtPditT1k8DkyfEI6z382yDQAwjArq81kgmDanf+PqsVwTcFbERJ3cJoC0fVtoeCUfKfXqVazkmGpFyHt5fpL6+XkaWF4XE3r6VMAXgU2auy28vbLR2t9oPpKEGzxg6Ul3xlMVnL+wERYcrID4zmHAPqh+wVA2JQ6bFqq3vcrnPyiNNIuyjLbFZtZhxfGpY5jB+obZHXcIBNMk0YgVBHXGK9rEZ1weDfKnl4kD0m9lxhs6lJ5E7h+FXVxVVMlEW9Vo8ToRr8UY7+hXOW90DtOhfdFjcWzrtrQ1Cl4KGQH2QsEyBwLvsZrOv0PpBPUfX/FvJyUpHXgsrE6kDeR7U6qQ0FJI2EnhdZh26DPL6n4ftiq00ziRfCPkVs6xVP2EEXoxsM4lAOblmBg3cWD3iTKtDa7aIQBlgApial9gBajXftY7JDz/dKV6iAXSHuoHvxvZEG1E2SpNsz3n2bIdR0hXhJ6OlhIaRAHkY115XITiXWso7mnDT28ONw6YDkr6b6hJBxo6Fo518khT+Cc5VJq9/ymU4ce980vDYLj8pE6tA+GcVW1+8OrpK+rOhMMEQwLkS6Jb7VH/Mioqp6W0mqAuxmX+j16yf7QUnoJMmwYp1iKxSzPfIPCKNT8sCS57LuxIKnRSULPPCGtYJZeCCfGoIDh39pHZpEzgket0pcUQGkyEmzA2C89+fat/xJWzehx+iw2B/n2o
 5Gk7g4eZ
 3dOhJbg8fhUaSFqZqH4Ccgd8/81AmZY6TKB4iZ7vyesf4MlZJ/Z33AP4eghEYvVjJYt8RV+P6eytpaA7Mzxl9XwOjHnstUQ7nAX+OSXm8t3JU1BtR+jF+Q3RenspyB3KYYHmPrLDjkok0W9qxOXOxHGyMmAzz5L/n43gKShlPtyPt1R9uRsrhq1/rlZuQXNpQ3h5Tbk+TuYjmydAEWKRvykin9QrKTegtMkavSlCGrtEnzqFuVoSqTKo5tr3UnwXnyVSZjy0woHcV6k0WonLbV+zdD0NBH1Zhcen4FqFaxFzMNalgHku0DmtitnUNBP8Ykllixm3C4KcT0Mnqxk1AogbuqAef1doWNpJypO/vK4Wg2+H60qZvepT3hfi4Yrhu5WlLbAOjGflPegi3An71GfD/a1VUBt/mjAQSLo5/TBr0wsRZFLbDkOgJjuu2kmQ1w8nrKfAL6oxgqp/JPDa+2Ice/rBPKV/C/hpn43gl2SIugkbLSRThNhZ4qchYW+wRBUTrELGr8jnPTNkq+6HtHGcxkRPVTp1gcJ/A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 10:25:11AM +1000, Balbir Singh wrote:
> On 7/23/25 05:34, Francois Dugast wrote:
> > When the PMD swap entry is device private and owned by the caller,
> > skip the range faulting and instead just set the correct HMM PFNs.
> > This is similar to the logic for PTEs in hmm_vma_handle_pte().
> > 
> > For now, each hmm_pfns[i] entry is populated as it is currently done
> > in hmm_vma_handle_pmd() but this might not be necessary. A follow-up
> > optimization could be to make use of the order and skip populating
> > subsequent PFNs.
> 
> I think we should test and remove these now
> 

+Jason, Leon – perhaps either of you can provide insight into why
hmm_vma_handle_pmd fully populates the HMM PFNs when a higher-order page
is found.

If we can be assured that changing this won’t break other parts of the
kernel, I agree it should be removed. A snippet of documentation should
also be added indicating that when higher-order PFNs are found,
subsequent PFNs within the range will remain unpopulated. I can verify
that GPU SVM works just fine without these PFNs being populated.

Matt

> > 
> > Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> > ---
> >  mm/hmm.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> > 
> > diff --git a/mm/hmm.c b/mm/hmm.c
> > index f2415b4b2cdd..63ec1b18a656 100644
> > --- a/mm/hmm.c
> > +++ b/mm/hmm.c
> > @@ -355,6 +355,31 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
> >  	}
> >  
> >  	if (!pmd_present(pmd)) {
> > +		swp_entry_t entry = pmd_to_swp_entry(pmd);
> > +
> > +		/*
> > +		 * Don't fault in device private pages owned by the caller,
> > +		 * just report the PFNs.
> > +		 */
> > +		if (is_device_private_entry(entry) &&
> > +		    pfn_swap_entry_folio(entry)->pgmap->owner ==
> > +		    range->dev_private_owner) {
> > +			unsigned long cpu_flags = HMM_PFN_VALID |
> > +				hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
> > +			unsigned long pfn = swp_offset_pfn(entry);
> > +			unsigned long i;
> > +
> > +			if (is_writable_device_private_entry(entry))
> > +				cpu_flags |= HMM_PFN_WRITE;
> > +
> > +			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
> > +				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> > +				hmm_pfns[i] |= pfn | cpu_flags;
> > +			}
> > +
> 
> As discussed, can we remove these.
> 
> > +			return 0;
> > +		}
> 
> All of this be under CONFIG_ARCH_ENABLE_THP_MIGRATION
> 
> > +
> >  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
> >  			return -EFAULT;
> >  		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> 
> 
> 
> Balbir Singh

