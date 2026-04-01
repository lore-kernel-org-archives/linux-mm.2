Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B22E41076365
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 05:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28A236B0089; Wed,  1 Apr 2026 01:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 261956B008A; Wed,  1 Apr 2026 01:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151506B0092; Wed,  1 Apr 2026 01:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 014E76B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:19:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0EAB16064B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:19:58 +0000 (UTC)
X-FDA: 84608835276.05.340377F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id 850AA100002
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:19:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PTsRkBi4;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf05.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775020795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KV02XT5yrjVo2YBR2XmiU7QzHjJ0p8DowmYyKgbdPcQ=;
	b=c04qvFCYaGHscSrQaaeu6QCAtUvUTQegB/T0KSY34y7qbFQQhDNTs0wyCZcQ5Dsr9OBqsi
	TPGb54AW9gjR92S/Qbma6dOnjQxyGScwHWqQwQdwn77bntfxH+h3ntFNMDcfU55CO67UJc
	fFDBeyGa9X3Zh6prtlOrWYY26zXn/bQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775020795; a=rsa-sha256;
	cv=fail;
	b=w9SMcw6zyApnC2+QZVUbciUMgYOjiCCqLQYbpckhT05zc/YHtrY6ZyJBCeSKI92C0UNNn6
	UR4qQEXonXXKSpSYL6x+hvxwszL0JNRMTZf9y/GWqDEqLUQ+WrVcBF2LBiGN06R1HcDD2T
	6317wHZ39Lm/Bn6KMDHTMP++jrjKFyc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PTsRkBi4;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf05.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775020795; x=1806556795;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=4EuBglrsK1+RTn8r4z1MVMeIuguyGB9r9tfaOL3F/RQ=;
  b=PTsRkBi4TMhu+RudybsL5ZrsVrp8g2856WvkeolTtI0TK3HPdJtLuA8j
   j1pfOYAHMWA+Vch3yyALdhGvq8Stg0VZJSQ13UmvoajjgrqAUZWNZBdzn
   JfN9tc+9bifkwVdLV2j/R3a+sJ6XJL1NT5ymn00/4RPqacH9lClt/e+Y6
   m2iDov0cSYem7I6fQFbv4ye17ngaKYj67+S2dShxXWdZ/RGcqNAa51vrn
   EJjZsiHTBXQcxXn4t9vJMQlKwoUh7dRwzsspezvwUwDpj1XnuxxW//ogj
   k2vpCuo9Dle4X7RREXkUs5gBnhFA2bVyWGjfXw2XT+noQDTmlvIZOl+xy
   A==;
X-CSE-ConnectionGUID: Y8eKSfRSQb6LZLEuoFhpYQ==
X-CSE-MsgGUID: zOsGBxNCSCaSSR18rh8LUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="76061555"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="76061555"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 22:19:53 -0700
X-CSE-ConnectionGUID: /hL54sdsSBup8SpPGShPlQ==
X-CSE-MsgGUID: oE5BTgRiSe+Ms0+kRaS+kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="219916534"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 22:19:52 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 22:19:51 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 31 Mar 2026 22:19:51 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.70) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 22:19:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UiyAWFsDTV0VCqICbXV2hNWVb5sT5tgCD+wmJIfqUSPeO92nKBnqjIpr1bFn+yVPQcOCpuHc+1K2spNRlC0fN6cTYNdxIxLbx0EA2S/a3n4/ytrCeZmQvXZI20qwepk3chOpUPOej3arMgTQKJNpGM4iZ+8vuOWEumttGALqJqV3dDbYViCxpliJntUCR/GzyUvrMuZ+4r928UJ1vLcjnphN6g2KkV9Ot1o+YBIN+XMqGgxQa5IDyXnjqhWtr271EvQncF45ZDYal6z9as/mYsCIlJadbSP/M69yU8zFAo1obClyfld7XEiLpfkw6z+Hl3pj+JmUrpPB26c5ETMfHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KV02XT5yrjVo2YBR2XmiU7QzHjJ0p8DowmYyKgbdPcQ=;
 b=hju1vtkX/XKr+vrUlndkSvrS8xBQuryI/abyZ67Wwyl7DXWlhE40TrQA54mSYmGPglT35rpMZyjQ6/ODGeADQBsWJewbc7/5cq1octGQAXYfjKQlFG8mcmLUy7FspBP6R+BjWYMs+TEoBAsCXxIZzCWJyE/UTmMea2GU6njv+aYB3k/OJ6gvvbfLyZSLfLWaA67OCX90zaUP8ObH+obL8rMRrdClpl1YMIn8bz60f7PbdmOFtg5Ue6Ebk6XDA8epApzQcLWkbBTFjukytGn0OupcOi0t6ujzXzloD+3UXB71hltEYmW4scAbY3kvCYeY3lekQfwXXFJUNW7/87A89w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5)
 by MN2PR11MB4759.namprd11.prod.outlook.com (2603:10b6:208:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Wed, 1 Apr
 2026 05:19:48 +0000
Received: from BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::53c9:f6c2:ffa5:3cb5]) by BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::53c9:f6c2:ffa5:3cb5%7]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 05:19:48 +0000
Date: Tue, 31 Mar 2026 22:19:44 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Alistair Popple <apopple@nvidia.com>
CC: <linux-mm@kvack.org>, <zenghui.yu@linux.dev>, <Liam.Howlett@oracle.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <jgg@ziepe.ca>,
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
	<mhocko@suse.com>, <rppt@kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <dri-devel@lists.freedesktop.org>, <balbirs@nvidia.com>
Subject: Re: [PATCH 2/3] selftests/mm: hmm-tests: don't hardcode THP size to
 2MB
Message-ID: <acyq8B7/Uwowj+kl@gsse-cloud1.jf.intel.com>
References: <20260331063445.3551404-1-apopple@nvidia.com>
 <20260331063445.3551404-3-apopple@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260331063445.3551404-3-apopple@nvidia.com>
X-ClientProxiedBy: MW4PR04CA0222.namprd04.prod.outlook.com
 (2603:10b6:303:87::17) To BL3PR11MB6508.namprd11.prod.outlook.com
 (2603:10b6:208:38f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR11MB6508:EE_|MN2PR11MB4759:EE_
X-MS-Office365-Filtering-Correlation-Id: b63a8535-f320-42e9-b758-08de8fae4b27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info: OJesxqDEmnITQ87XmtHS4x/TiX6ezeOjHwxHkowpudBKmZSSd7gis3kDb4uWa9doWo9DQlwvRRNM7vQlxTFXGjr0qxp4ycqc2VjypyjmZog6R98T7n/HNpthyjGqP6ShJpgbPiUxcf8o4GS3jr0rsbed0YQfFYwHPBYkDf0q2axEA4vI39KVuQuBkvJRTiUnaqm3cZ+/lTg5bE47x+bKMUp9pd1Lu00zVlfSPY2Sz+0keHRSXk1CPx/mAUUiLz45mo/fGyc+MioT7xHbm5duaymAYJ26IvtXSsNkosEpCKdUDWAn/nlUYmP/JanuCSfh8mdnN+W/3IzZ5DDByI/0KBnnMJaNWpDGQJDJCJRayGmu3WyktAUwPmFgBtlH+xD9dwsY5tBOm4rb+TTfwpGjv3vgKi05WJZwANdlxPyeYzrpy/pF90Atwn4mMwayJJaZC61UkYdnDZ4g1cAMwyqzcslZFmj14bBkpr1gcE8x9+AKY3w35ESDfm73jaOvJeMU9+CminS0p6wv/MxXQZY6j57vYVXnvybGzUoA0lTpEQ4MBlHS2XWx7a5q52Q88an7nz/i3Wj7btsQMFqByfHCxyPl44vCENenUOznAKXdCY8CTgUkIRpuPyjEPx95qTRp/fHAA594u0YW0W4eWNjNw6L/DiADVbizIVdO9Xr5Xdugd8dqvSjaYn/TTPsNgA1E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR11MB6508.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEhRc1pNZVN6bDVBT0dRVm9jem51Y3pxQ0NSVFh3ZnY3dFFQNkZMczgwSk1F?=
 =?utf-8?B?TW4wVWlQb3JWZUVYY3RHTjdHZUtlQXAvMWx4MTlyY25WYzlGOWtqUzVnQ3Nu?=
 =?utf-8?B?QVJDZUYyZjZsYk12S0ZBQ3REeEVFM3grY1lTWDVMOHlKNnN6bTVyTHNnSXFy?=
 =?utf-8?B?d0FMdlZnYTQwTFZBdWpBYkZ0VkQ3b2l3dVFQQ09STW9MWWRkYkYzeGRlZERm?=
 =?utf-8?B?OGFkRGdsa0szcWh3QnpuZ1RKUGRDNDNyT2ZsL2JSdFQ0bjdnaWlrbzFVK2h2?=
 =?utf-8?B?OTRScXdvTFl0WnFqTjg5emFnU0xxZmJKZDVVMVlPcEpQdExIaktQNHlVRmJE?=
 =?utf-8?B?UzVVKzFtNUR6RldLM3ZhZ09Zejd3TlZEcXFLeWxCT081b1lHdXM5UkkzMnZn?=
 =?utf-8?B?aWtZOHdPNjBDTlcyN09RTFJrVXhnNkV3MjJDeEZ4OFo0MW80WXNOaGQvQmZD?=
 =?utf-8?B?a3VIUDAyVWtVMVNabWwzSGc3bVdVaGhYZnJkQWFHZ2V1VFVYRjF1akQwYXdZ?=
 =?utf-8?B?UnIrSzEwTWRsNHFSM0tVVC9IN01NMHp0dXhsRjZaemoyaFVza1k3Y2ZJaEVi?=
 =?utf-8?B?Zk1kVTFJRlJYZFdJK0h2T0hZMklvR213akpnSWlmYmhobU5qUHk1NHF2SDhE?=
 =?utf-8?B?T0VqSVR0aVMvKzBOREE0ajB5Z3hmNzN6MG5nOHJjYTNSNSs2dVVtbWdoUXJi?=
 =?utf-8?B?OWFhbXpsa1A5dCt4U3BwQUlSa0krNTdwc0dwcEp0WFBhTnUzaFYya0Mzd2U3?=
 =?utf-8?B?Ync5bDZuR1JzaVVTa1hVSlpOYkFJM2EvWkNlMmpDN04vOFd3YXJLYVIzeGNo?=
 =?utf-8?B?S0cydUEvMGo5TCtFQmxnanRyZEJHcmVOTFlhU2ZpTXNQcnIwazRuZ3dIc0Nk?=
 =?utf-8?B?V2JTU3pxK2VqNkQ2YW1EOHNvakVacVFQV2FPSTRPbUVXSGovZ2ZTYW5OTmM2?=
 =?utf-8?B?dEg0S21pVXdQM0JFZTJtcWpYSDNjY3ZKd0FlRzdVQWtsUEVsMkRibTRUV0pS?=
 =?utf-8?B?Q1RCd1lkVGk0ZG0zQWNVYmdJaE1NMks5aWt1OUhoRmtNb3RhcmI0cExjSTNS?=
 =?utf-8?B?RWErY3lNb1NvNFYwakNGTEhGTVZaK0V3QkxMUksxVHhFVmROK05WRVlUL3Jt?=
 =?utf-8?B?cW1wa2R6aDRHdzJiUzRxbk1pUEtiR0Qwdis3NWxqZFYwcEYzbC9rMmpFM09K?=
 =?utf-8?B?ZDRXcDR5c1hkdUFlOEVrajd3TGxoRDdyZWoyK3lIN3drZURqbnBsR0M5Rk9D?=
 =?utf-8?B?MXFnVDRxRnJ1bXltbHNxUVRXM3BXclpXR2VFNFJrZ3dzL1RxL1ptcSs3NGQ3?=
 =?utf-8?B?cjA5V3VKdVp1cEx2SEUxZmN4ZDY0TzNLZ0ovQkZlSGtEQUtlSjR6ZUxXTDBG?=
 =?utf-8?B?aW5NUi9Bb1dDUGFtTko3RVExZjhFVlFxNENJeGVLd1F2TEZIWlFlb2tIR2Iy?=
 =?utf-8?B?dXFIeWNHT0Job1BzWFlISXVFbS85bzRZK3UxU2tBQ0dLUC9SMnpUazF2cFNF?=
 =?utf-8?B?VDZ1T0xoOGFGN1lhYnFkMGRtU1ZFZjJLaE5BZWFCUmhOMWNzRjhZM2tzcVRl?=
 =?utf-8?B?MStIVEVxYnhQZkNuZVROdkJQZUtVa1RrZkR3TDJVLzg0UlJ2QlZoYXFMeUsx?=
 =?utf-8?B?Sk8zYjZ5STRxaVBMaVAzcXpXR0UyUEVvelRUSmgrT3VqNi9Sc29aR1llQzJZ?=
 =?utf-8?B?aENvS2x0cmZjSHZQbEV3R0NXMktIY2I5UW5Pdzg5UGtrUGNXZ2VPOSswZ3Fx?=
 =?utf-8?B?VU9xV2xDM3hyak9BWHdPbTdNbXJDNmNRbTJpcFFZQldyS0NmdzJhQzZRcEhm?=
 =?utf-8?B?c0pCZlE0MjV2d2JiQzdYWjVqa0R2QytvK2c0MkZXbGR5MW4yM0kzTmhpcmps?=
 =?utf-8?B?WFNLSWdOUnZIcnR3UFEyUllxZ1h5dTNDajBCMW5SM1BrcGJXOGVqRi9lSGVE?=
 =?utf-8?B?bFF2NU9yMk9BYU1ib1Rqc0N0RUx5bFF0Y01OdU1Jc3Nsdm9EaytXZXl2L0V0?=
 =?utf-8?B?L3RuRFpZL3BCZDJLbm0yK2RUemhqOEV5V0JGcVk2VjJoSUpINjFFVWhpb1Mz?=
 =?utf-8?B?clRGSldFcFJ3MGp0OXJpVk9STFF0UGJzdXVrb09LdEUyRWg0ekRCSisweHpE?=
 =?utf-8?B?RGpBVmZJZG5SeWNBWEJaOWlTR0lvY1hnRlZXeHEzNGsvYi80MkxZUW9hQ3ZD?=
 =?utf-8?B?M2xVZ2NJTUpEUlFpbS9lUHlPSFFTL1FtUE1nNmdwaU40dW1KWit2Mzlidzdm?=
 =?utf-8?B?Tlc2cDFsdTNZcDFOK2pTMHdYOUFhNStScEQ0ZXA4eU5NUzhrekRwUVVkekpZ?=
 =?utf-8?B?TTBMdDBUajlSclFkUFBDN0hzRGVaVUg0Z2hIUU5kRGg5d0Nhekxydz09?=
X-Exchange-RoutingPolicyChecked: ifjhXbUVHEjW+8ZwapfEECxLZGNmmV9Pnkpjh63S7NJH80pYml/DLPOstFiUoM1dSMhffPb2wEm1EmwqLeVmPaP/JttKlAenVoCnXN8SME0hfZPDS7+QGHzdc86SGDYzNAxHTXAE2fWLOBi5LZO7LX3UsZV8NNwjcZy590wjM6dYX1+vIY6WgTgPBuOaLwhptHg1bavxhVnNcnae7htIqvGre2olwVkRFjFza+jKXlFT3mIOVtTaMYWa8JnXZ3CgrNLv2wPuQeC0PROZia+FjJbfep29H0P7w55FIslm4BCRibVABdOQK3Bmx1dXkWUdLUBT7J90WOB4RnTqdQWP9g==
X-MS-Exchange-CrossTenant-Network-Message-Id: b63a8535-f320-42e9-b758-08de8fae4b27
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6508.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 05:19:48.2245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YDC1FcK3CdOZf/MtE82aK+L22S9+fQ+Utw27wCQQsXfzbe34Yd/OZ0MOJVIamzSOeIy2N78uUah8yWOqNl+S2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4759
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Stat-Signature: w7aubzpg4its1sq1a53o9pxdqmd7dwz1
X-Rspamd-Queue-Id: 850AA100002
X-Rspam-User: 
X-HE-Tag: 1775020794-421642
X-HE-Meta: U2FsdGVkX19r3OisNeNNshLBKaWyRibtLuonHuXdSGcIjhh+O344utRf3u/IQX4TFv5A83qI5qopLJhoV3TbTMivnKvzJBLLa9CmjrfiHlZ+fFVr6qYnscTB5ITShnVGQpGXB7ZGlSrDnEsjARkZmVlCV8Hlexo+0cNaYwKOUTJshpdalRcNeVrRogDXLvZy1NMdzlGPY20biZ6yEOpEQUGKS3c+qcrqofG4aIdPgq0arDvVfcQKY5vrRo9CHDnCh/iYQccKnaZvPzZ5KFH3qO8IKyo6YnIJ8nsCcdDokaDSepnHWvOw8GI5YmnqKN/pso4leEhblt1NL1zqdaOfvX/V1aKIMHV1EgGjTgQWEtsCFfPTqll4o8MOnq5bJDz/64aAA2D6H4BOSoeSuOkPTZQXPXHM6KmhYE5gbudUROH69GqJmtPS7omdc/qrVx822AHPVLrb8oG2G+cQtYxvftU0XMkx8HUldqicKk2yH8xfdPpFrfkcunobqJZ7PJEwvNniDh9ISQMqfqfH/GeTzvG24SbMI5606JkgMYhCb2KQpd9MZC2mGTuBfI5TZUq/VliFd0soAyXrRcMXj5lLAMjeTgFITXLCXrrZIxaIAJ5LLQgiRZYFkyo6LyHcOoVn9hTkvFfVwD8Z1QMoF63JZt/vkUaRMLfVRGOzR4kEOZ0PELUJ5g8zs4RMMxjgvN4kj7zlgVGxTaiuvubNs7FERHj6tL5LU75TzIcQeLV4Jc+jW9aXFcuLzjsD4rr+fvAT2Bl+x9c3W3TYJsHZmb8oDLOZH6En9jtBZbOCrIFJ7VcxTHMOE4yOxtTHXLpLskNC06JQM9EXBK0qpNJ3KoYEV+g1wf7/h8NIG5dCGHRPxYjLiTBej4g0uG/6zRDsY5by7Cde8yaDuvGgFXiwI17sAjdp2ZzQdwUkJ4PCENh4DLa2jXuwkn2gK1yIVcat1AraV805zeeOe+4FfsCq6UL
 2dbSCG8U
 uqStdCjj98Pm9uHRpIBpoh8g9n/zBKVdDPs5ZJAhZC8A3CVFvdCRdsaIaRQeMrt2jqVNJwxtmDrfqsOKm6BL+ZoPDqedQ97DUEjx9MIuy4gQCviSD7YHOPogYwVcFYdTIBuz54CS5P4dey9GnRLEKHeVQMGprSKA+1nm9NtKw5CwwNm78kMcK41Ikba2fv8Lb0byjbq+36y/S/CDYHJPPNPE0DYYW6jhXN+ThrQTWi/h/FT0uIWUpl5/Tgm+BqIKUKKWaYLxSaClD1tXE0YUEPs6C5sldMx8Ps7e3yjNA1BBbeq8SgAezR/paOl0h5lmrTi9dDfSwc3QszX0DQIAvBGG70DulQrBA4jZxnHqZS7xy1QBLJkn28k+8O/xh2Ke6KPCCfJx4uzgLJ7qmMvXun16o8ZUNgmIQdcZ7ggGtCxoyYQ1Q/1hNGECFa+4tmFDRgNKrmrGEWlJFsi00CMZUvDqcFhokwrQh7gUrGs9yRQFq5GLx6Yo0HQu2IZmhrZ1ao1/NE2JVouYoHKX7IyHt2k8+eNc6BBItYnppEB5zvDWzWFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 05:34:44PM +1100, Alistair Popple wrote:
> Several HMM tests hardcode TWOMEG as the THP size. This is wrong on
> architectures where the PMD size is not 2MB such as arm64 with 64K base

+1

But one question…

Can’t the THP size be derived via HPAGE_PMD_ORDER?

If not, then some DRM common code I’ve written will break on arm64.

Matt

> pages where THP is 512MB. Fix this by using read_pmd_pagesize() from
> vm_util instead.
> 
> While here also replace the custom file_read_ulong() helper used to
> parse the default hugetlbfs page size from /proc/meminfo with the
> existing default_huge_page_size() from vm_util.
> 
> [1] https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
> 
> Fixes: fee9f6d1b8df ("mm/hmm/test: add selftests for HMM")
> Fixes: 519071529d2a ("selftests/mm/hmm-tests: new tests for zone device THP migration")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  tools/testing/selftests/mm/hmm-tests.c | 83 +++++---------------------
>  1 file changed, 16 insertions(+), 67 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index e8328c89d855..788689497e92 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -34,6 +34,7 @@
>   */
>  #include <lib/test_hmm_uapi.h>
>  #include <mm/gup_test.h>
> +#include <mm/vm_util.h>
>  
>  struct hmm_buffer {
>  	void		*ptr;
> @@ -548,7 +549,7 @@ TEST_F(hmm, anon_write_child)
>  
>  	for (migrate = 0; migrate < 2; ++migrate) {
>  		for (use_thp = 0; use_thp < 2; ++use_thp) {
> -			npages = ALIGN(use_thp ? TWOMEG : HMM_BUFFER_SIZE,
> +			npages = ALIGN(use_thp ? read_pmd_pagesize() : HMM_BUFFER_SIZE,
>  				       self->page_size) >> self->page_shift;
>  			ASSERT_NE(npages, 0);
>  			size = npages << self->page_shift;
> @@ -728,7 +729,7 @@ TEST_F(hmm, anon_write_huge)
>  	int *ptr;
>  	int ret;
>  
> -	size = 2 * TWOMEG;
> +	size = 2 * read_pmd_pagesize();
>  
>  	buffer = malloc(sizeof(*buffer));
>  	ASSERT_NE(buffer, NULL);
> @@ -744,7 +745,7 @@ TEST_F(hmm, anon_write_huge)
>  			   buffer->fd, 0);
>  	ASSERT_NE(buffer->ptr, MAP_FAILED);
>  
> -	size = TWOMEG;
> +	size /= 2;
>  	npages = size >> self->page_shift;
>  	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
>  	ret = madvise(map, size, MADV_HUGEPAGE);
> @@ -770,54 +771,6 @@ TEST_F(hmm, anon_write_huge)
>  	hmm_buffer_free(buffer);
>  }
>  
> -/*
> - * Read numeric data from raw and tagged kernel status files.  Used to read
> - * /proc and /sys data (without a tag) and from /proc/meminfo (with a tag).
> - */
> -static long file_read_ulong(char *file, const char *tag)
> -{
> -	int fd;
> -	char buf[2048];
> -	int len;
> -	char *p, *q;
> -	long val;
> -
> -	fd = open(file, O_RDONLY);
> -	if (fd < 0) {
> -		/* Error opening the file */
> -		return -1;
> -	}
> -
> -	len = read(fd, buf, sizeof(buf));
> -	close(fd);
> -	if (len < 0) {
> -		/* Error in reading the file */
> -		return -1;
> -	}
> -	if (len == sizeof(buf)) {
> -		/* Error file is too large */
> -		return -1;
> -	}
> -	buf[len] = '\0';
> -
> -	/* Search for a tag if provided */
> -	if (tag) {
> -		p = strstr(buf, tag);
> -		if (!p)
> -			return -1; /* looks like the line we want isn't there */
> -		p += strlen(tag);
> -	} else
> -		p = buf;
> -
> -	val = strtol(p, &q, 0);
> -	if (*q != ' ') {
> -		/* Error parsing the file */
> -		return -1;
> -	}
> -
> -	return val;
> -}
> -
>  /*
>   * Write huge TLBFS page.
>   */
> @@ -826,15 +779,13 @@ TEST_F(hmm, anon_write_hugetlbfs)
>  	struct hmm_buffer *buffer;
>  	unsigned long npages;
>  	unsigned long size;
> -	unsigned long default_hsize;
> +	unsigned long default_hsize = default_huge_page_size();
>  	unsigned long i;
>  	int *ptr;
>  	int ret;
>  
> -	default_hsize = file_read_ulong("/proc/meminfo", "Hugepagesize:");
> -	if (default_hsize < 0 || default_hsize*1024 < default_hsize)
> +	if (!default_hsize)
>  		SKIP(return, "Huge page size could not be determined");
> -	default_hsize = default_hsize*1024; /* KB to B */
>  
>  	size = ALIGN(TWOMEG, default_hsize);
>  	npages = size >> self->page_shift;
> @@ -1606,7 +1557,7 @@ TEST_F(hmm, compound)
>  	struct hmm_buffer *buffer;
>  	unsigned long npages;
>  	unsigned long size;
> -	unsigned long default_hsize;
> +	unsigned long default_hsize = default_huge_page_size();
>  	int *ptr;
>  	unsigned char *m;
>  	int ret;
> @@ -1614,10 +1565,8 @@ TEST_F(hmm, compound)
>  
>  	/* Skip test if we can't allocate a hugetlbfs page. */
>  
> -	default_hsize = file_read_ulong("/proc/meminfo", "Hugepagesize:");
> -	if (default_hsize < 0 || default_hsize*1024 < default_hsize)
> +	if (!default_hsize)
>  		SKIP(return, "Huge page size could not be determined");
> -	default_hsize = default_hsize*1024; /* KB to B */
>  
>  	size = ALIGN(TWOMEG, default_hsize);
>  	npages = size >> self->page_shift;
> @@ -2106,7 +2055,7 @@ TEST_F(hmm, migrate_anon_huge_empty)
>  	int *ptr;
>  	int ret;
>  
> -	size = TWOMEG;
> +	size = read_pmd_pagesize();
>  
>  	buffer = malloc(sizeof(*buffer));
>  	ASSERT_NE(buffer, NULL);
> @@ -2158,7 +2107,7 @@ TEST_F(hmm, migrate_anon_huge_zero)
>  	int ret;
>  	int val;
>  
> -	size = TWOMEG;
> +	size = read_pmd_pagesize();
>  
>  	buffer = malloc(sizeof(*buffer));
>  	ASSERT_NE(buffer, NULL);
> @@ -2221,7 +2170,7 @@ TEST_F(hmm, migrate_anon_huge_free)
>  	int *ptr;
>  	int ret;
>  
> -	size = TWOMEG;
> +	size = read_pmd_pagesize();
>  
>  	buffer = malloc(sizeof(*buffer));
>  	ASSERT_NE(buffer, NULL);
> @@ -2280,7 +2229,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	int *ptr;
>  	int ret;
>  
> -	size = TWOMEG;
> +	size = read_pmd_pagesize();
>  
>  	buffer = malloc(sizeof(*buffer));
>  	ASSERT_NE(buffer, NULL);
> @@ -2332,7 +2281,7 @@ TEST_F(hmm, migrate_partial_unmap_fault)
>  {
>  	struct hmm_buffer *buffer;
>  	unsigned long npages;
> -	unsigned long size = TWOMEG;
> +	unsigned long size = read_pmd_pagesize();
>  	unsigned long i;
>  	void *old_ptr;
>  	void *map;
> @@ -2398,7 +2347,7 @@ TEST_F(hmm, migrate_remap_fault)
>  {
>  	struct hmm_buffer *buffer;
>  	unsigned long npages;
> -	unsigned long size = TWOMEG;
> +	unsigned long size = read_pmd_pagesize();
>  	unsigned long i;
>  	void *old_ptr, *new_ptr = NULL;
>  	void *map;
> @@ -2498,7 +2447,7 @@ TEST_F(hmm, migrate_anon_huge_err)
>  	int *ptr;
>  	int ret;
>  
> -	size = TWOMEG;
> +	size = read_pmd_pagesize();
>  
>  	buffer = malloc(sizeof(*buffer));
>  	ASSERT_NE(buffer, NULL);
> @@ -2593,7 +2542,7 @@ TEST_F(hmm, migrate_anon_huge_zero_err)
>  	int *ptr;
>  	int ret;
>  
> -	size = TWOMEG;
> +	size = read_pmd_pagesize();
>  
>  	buffer = malloc(sizeof(*buffer));
>  	ASSERT_NE(buffer, NULL);
> -- 
> 2.53.0
> 

