Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF29BCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38D1C6B002A; Mon, 24 Nov 2025 10:50:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364AE6B002D; Mon, 24 Nov 2025 10:50:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2538C6B007B; Mon, 24 Nov 2025 10:50:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5FE6B002A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:50:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B402557F30
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:50:40 +0000 (UTC)
X-FDA: 84145938240.07.423E2B7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf06.hostedemail.com (Postfix) with ESMTP id BCCFB180012
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:50:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gZFi0x8N;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of ira.weiny@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=ira.weiny@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763999437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUuIlJWc8Nw8K6hGUrBtt3+fqZYkAUv+thgde8dHMl8=;
	b=8Y4RtcHekDnBHakxCTKHA+3t2W//l3jim8Z6gWxsgvW+qZRLT4ISdX51yHJEIw1YBRc8QB
	KMhKGBSAq1/m5A1QXWlVtV0KavquEKBh/kHJe71l+Bll9jOYtuM1jc2gI2tnsI0yThXgat
	v2Gnx8JvKTEYYfpLIthRfInAuZfLkq8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763999437; a=rsa-sha256;
	cv=fail;
	b=tndi1sZT9BfRVkD2H4L+G4nTflN0EpZbBoT7Gbdwu/ARo5lWDc0GTUYoKjqmSXXniF3jP7
	+KTPsCasZLxFL8wGcfM0k/dmBKmKEhD+oQNCdXNt7HcH7bPRC7eyFUrQhPDPB3ciwlaJGl
	4Bhkv6aMjO1PLozSLEXijv9cNsd9EqM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gZFi0x8N;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of ira.weiny@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=ira.weiny@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763999437; x=1795535437;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ON/ms1ZyKHhvZWoXV1OQkcC392X7qYvTgK2BLdPAOOk=;
  b=gZFi0x8NDUGSpmkvibjzH9VZSE1z/OBZSP5lYtmomnb8xn4JuUe6vq4r
   sw5pLvbLNCXM6f+dvJRJmg8KCCLXyKNFQ4Xy1f9PZj2ABizpPx8ddHX7/
   Pzg4+mZYS7f0+7IdRlr0euRBUjQbtMgQ4q+Oq10a5ehDFa2pAuh1DLM38
   fhe4BOQpCgrQBeuH7YrT3FBEURkVmw770Nh5rGIWTNQuvMuQkOvSKhppJ
   w6VztkzptZlPti2qDy0ikQl0Kg3zbK+q3ohWRvsEk01zcJQWb3ujzEUoL
   eE1SYIGXbstW3mf6gS6WRYN/FL+GD8pVxfXqDvjB1qbA/NVIfgAWIV7FE
   w==;
X-CSE-ConnectionGUID: jWqphmSNSm675VWlhCAX/A==
X-CSE-MsgGUID: WkE3anaRTcWT8bWxUIiCsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="65939513"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="65939513"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 07:50:35 -0800
X-CSE-ConnectionGUID: rzukQzjmRH+lj6bsZoQ+dw==
X-CSE-MsgGUID: Hu5amvSjRzWG6qWXtSoofQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="215705606"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 07:50:35 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 07:50:34 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 24 Nov 2025 07:50:34 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.6) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 24 Nov 2025 07:50:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BJD+iVbsmtlkF6lKuhA+P18Pt30NMR6+ijowoizBzpUu9q+tAqM732VCYSO9S5FbLmtxZG+BHAjnqA1WkTwDkKeeRIZVK8Kxk9Z+hY5YKkI3jlPzsgch+57RTiTlMZDljqWtX1fa6ENXL9iCuNzGOU6A9WW9ehBcoFZVzQQ/StRivFuHRVD/Dr0kDAfyjoqbCIf9/kbj/IrVfNneirhJ62qUG5JHzNx07+M6rFMH5peFZuheHbtqx3H+1bYNtcqxCnlJaQ3Qlu5jY68n0i4iRf0WguclWKzoOSCFvaIVKhKr0bCybutJlqfLuyIdQh2GFUvsBzdEF7Zw+ApUUXS5jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUuIlJWc8Nw8K6hGUrBtt3+fqZYkAUv+thgde8dHMl8=;
 b=HnHCbHGw5HDFszwNHFgq1DNrZYdXYBjgQOMK6UMz5LbDBJfECHSqC36S1nHTNZElcd55+CSS64g4K2dXIjAycrUTlk/UwvhzH+CFJr0JD/J5MYbhgklDlHXMEYMz9DpCqczk35NZDhGXqsp2QOm/YZx/yCzqX8QLr0hkiQQ8uvpHvXre8gW+iXsCmF3mLid4Fcqkz0QyN52zzIE/3kANbun5t0MRikpZcpQVj19ynycr+e9epnIk1RVG8yETawLYexs1EIzEi57kUqQVUbM3G+7981m3lQ2OTFFbxTf5Xc7lV8u95Arb3Hr2ZsB2AatGwKuhfjJ/XeIazmh2pzVvjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by IA3PR11MB9423.namprd11.prod.outlook.com
 (2603:10b6:208:582::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 15:50:31 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 15:50:31 +0000
Date: Mon, 24 Nov 2025 09:53:03 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>, Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <69247f5fd9642_5cb63100e0@iweiny-mobl.notmuch>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
 <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SJ0PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::20) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|IA3PR11MB9423:EE_
X-MS-Office365-Filtering-Correlation-Id: f01dcd6e-a74b-4304-f668-08de2b71327f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kxVPNJNY+r64x6bi2VIQtak2jWztOVsrR38YIGXuMgxj+YFNVjKavyFiEM3t?=
 =?us-ascii?Q?3tK1hZE3QTLXjZy2NGUQkYgLTXxH6fFN0z02gY0TfHar7bN3B8EATSXly8Xv?=
 =?us-ascii?Q?2R3A0ZopWdmlkn+NDDmwjKjAhOwhZBBRkjl/AReZO9c7OJtF3dUHQ+Z/ibxR?=
 =?us-ascii?Q?FzO65qJxOHEj78uGZIOXRhSD1zVZaA5bk8tM9brbny/taMtR9fcKTC4kE9jB?=
 =?us-ascii?Q?7Q/Asgm5orr+yAsgTaSSu2xQ4lKljspNGZCr9oNDpgCgH9HPqnimrkLtxJNb?=
 =?us-ascii?Q?tR3lId4BkJx5PzeKTRWeu7oiCrZH7tNRaEIkfCjO4mtMnYHduvT3eiS4KV5N?=
 =?us-ascii?Q?oggXZQbOzPd/MlBpYNcM3G6IkDg60c2Pt8jb0aGyDHOnNsThArZZL4fmmQ49?=
 =?us-ascii?Q?L8Em2vSjgGAjvtNZU8WHK3wxIb/b71cCZ67lqHbQa9s1fm+C4phdwXtHngbm?=
 =?us-ascii?Q?FTG7efRNn/O+N7lSYDg1+OXDoALbpizehVYfH67SEXRjMyPoV2SdjgYp+P43?=
 =?us-ascii?Q?8XBpxY/4VQGFC0JL8VVzbyWkVfLX/CrkxW0H34+oopY2z7K2Sxoh4zkzgRsw?=
 =?us-ascii?Q?EqDrPMSFqkRj3tHqXH/nvgqfkB3qLN3b+Y7TS0GwKOnV6EFV9gBeLTeFqdrE?=
 =?us-ascii?Q?qvjcKt9xAd6ecNuI7Mv1G0dtoryvUYrYj1ll+t8OCdrNIo6WyA864xUZZ0Jv?=
 =?us-ascii?Q?sJN/eolE2C8H26WBaFU8XGsQgr4UNEOPty5dzTQAWRoXY9CPAhrBfaaI8zz9?=
 =?us-ascii?Q?tb9cJuo0DfNaD5wbMC0Crqdbi5TjrUDh/ZZAFHxkpeNoMGEAuPgfGfpM+BOE?=
 =?us-ascii?Q?bosOO4Q1jUiBNFaiSUpautpIIobU/a7sSkPSjG87XiLcywb3cDOwzNajFYfA?=
 =?us-ascii?Q?qQjgZkVnZVvv9lri2L2xCXtrLopBTLb4rL7uDNshVnwXjno5jNbwRHWdVTwW?=
 =?us-ascii?Q?A9HXXUZfy6SxpPAAU9Ie7ClTOGMVfoekscf2ubpH6NbQ7yLKlNrRSWN3nOCT?=
 =?us-ascii?Q?vPAa/EEXZwvQF/BwcWygnSJDv7T4h204onuMaGUHMpDY6kWVRVyR+4k//O+7?=
 =?us-ascii?Q?mgury+MoaFT/rqul5oXP4JsLp5WK6rayKjFNV59bdtwpq50DaKQZq4qd3k0A?=
 =?us-ascii?Q?6Vlyf9dfWFnX3/NxGKsBupSX3esqf+ipWlV0EJKcz7eFachcijHbJPPTTHJj?=
 =?us-ascii?Q?g9bL58/qcOdfczxV8xsiG1CAqRVgsNojh4A37aCgDM99KjzWy1g+Ji6BsbRk?=
 =?us-ascii?Q?EO4RESLVnZsqtBGG8KqkGSvlo1PtEy8EEf5LB4UOQc5l3J6oF12GRLeLChrt?=
 =?us-ascii?Q?FapAFm5czmgQI4ksO75IIHr5KBRgbSTpAPE5SCU/CzVU0GJSP7Sxl+PHvhx+?=
 =?us-ascii?Q?q2TSdKmseG5WsAIjqXaXkrmfF1dHrcY6y8Qzknqrlnwu95I2SAjs1Tm7NtvA?=
 =?us-ascii?Q?Hu3mCDIIukH/9aZhbY0X4EJwwmXMMRwl?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xkMW/vm0vbBVhmuSwue0EZL4vFoDNA63fLAtL8UBAoUKu0oWfMiF44idq8Nt?=
 =?us-ascii?Q?wrWll1TPXEGCduuR3QMRNx2oIRZZbmdm1wuLT8tLtcBZSLnDQ4ImWYCAGxAE?=
 =?us-ascii?Q?2Ok2Hs+ry7lWTwIJAc4jh6MrGpBVU+RK4ue2OURWf7qZiuGdHDGhRemFr3BP?=
 =?us-ascii?Q?Hif0hUrzA0b6hVUlS7z/fY3MfLyvH4z7pwhoTaGBUBbXWlUfQvbHMU87Ua4n?=
 =?us-ascii?Q?KEv87UPF/CshgnFZY6rXDvEmJvDI1niq7+arftsRKak+Rc274DGblaXP7bfl?=
 =?us-ascii?Q?ADHHJ75mEjsrC6lNGQF4DTKsOm7VXelBe2XjeQn+JuxDSGC7YcmM9Ad0H8aw?=
 =?us-ascii?Q?DVxnu78uoCLmIaaCgpMoFWpnDGjheRBJrQk1SPxvhXC/volXRIWSqKHub6hx?=
 =?us-ascii?Q?M3WTntmtPXE+hGrYCd6Eaqzk9IcEKCZlrZszmW3lKElleYZODPkCG0LAyX9p?=
 =?us-ascii?Q?zu+9sfex8Qp4QkFryCCGJWogkt6sZ7oc9TTYWhuGdJdfM/rAkMsAwOSjdVJg?=
 =?us-ascii?Q?4MZyxy/6XWUBc9+cyq/4Ij9/vP0UMGZ3rPMvxZR5EHSOTDHyH/sIpH8TNgxN?=
 =?us-ascii?Q?ZvE9cesSjtd9Mt9OmmKvTKLeexntorlaXvfwYn49JBDqaahPaKg859NOSjkL?=
 =?us-ascii?Q?jys38pcGj0znXT+c3fh+c3sLVeNam79W5MAtsNag0ZfcTRd4JTYuOPnW21bg?=
 =?us-ascii?Q?TwWQQ8MtfgKDVP7qa3lZXsBQokCWkwiBN/QefDCy/hWS+XjcsPMiKnSJwAen?=
 =?us-ascii?Q?MuRJOEklVRuh9aLyD9hf1MkES/PmDl6U2470lodpSkIeHlVBZnojnqKcWENV?=
 =?us-ascii?Q?ALINiws1JWqAq8YCoeIiHw/fLgr1M8rTjL0WZzkQA+YVfHUejT1NtWGKfQHo?=
 =?us-ascii?Q?sRlwYifWQsXd9f31pzbEhMWFuk+2b9s7NyWIEDAnqJpMUVoRsN1P/MVxVUpv?=
 =?us-ascii?Q?pTZ0S4twXzs+N5efXiSl+n2YSPxa9n2qqLuWgfAHDzu1QWjqNw7/1PuWv+Ko?=
 =?us-ascii?Q?we9vjop+x2Y60qdMeqTqq3YgKGwf/znNfs+asPijkvJSJY1AlDbvmGWpFu5c?=
 =?us-ascii?Q?bf0ZY2CWXGdBYYJgUPo8LQ39fzwDdpseZY9Bo5AM43ZZmzHudeuVRTVzoMyr?=
 =?us-ascii?Q?0WSRqdztUqFhtkYId+7rjHTNm+/GvYGF0wouAoUgu/08lSAQWtRg7DRtsJ+n?=
 =?us-ascii?Q?gMLFaiFBPeFao1vu75H8RsI3Z4bxKcALkNCYya0mFAe/2qPa1Odyfy9uco+R?=
 =?us-ascii?Q?AiuUUTNZV/iAIR0MRLfozs2dDSYXTFja5KWgDj9vM9P/mfpI5fGWZmBHJfq9?=
 =?us-ascii?Q?kFmHJU5yMefadRdx5wRN8dAxO1rDXCDj8DoIMLveNea9T0mTyb0OjRRQVWdS?=
 =?us-ascii?Q?MMXKMozuGDDYBHbDwcAlKBJjZrYPRcCFCR6629M+KP8F5TmPZL30SY+dtCcZ?=
 =?us-ascii?Q?s9ut3WHg2lJ60+g6FQ8GEHJLLq3FsW7p8cX5XY2qGt3qGqnMFDXPPIZlgGJx?=
 =?us-ascii?Q?IVwHtK1t12tIoEPZGss9WlK+dCP4ZB3C8Ap800s6f1bn7LdA0jM3K7SLtVOp?=
 =?us-ascii?Q?VLS5ChFn4MHDISjaHccxfZqk6tW7sy9/wg/Yf3Ns?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f01dcd6e-a74b-4304-f668-08de2b71327f
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 15:50:31.3775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kkt3YX1mVM09oKI8QgFIDBQn3MgtN9+Z3tb//lpUCTE6SCAyVhdnExHrPj7wS+vOEMvRfJGy+eWVTK1qlI7ztw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9423
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: BCCFB180012
X-Stat-Signature: 1dptzaris5bbu6tjzajozmkkerdyyk6a
X-HE-Tag: 1763999436-284614
X-HE-Meta: U2FsdGVkX1/3SRmFoXMKNMyI7SqkurSjfv6awDkYW3iySEef255VwMF6ZPz9dAdlZuZ/JrAP7Je4BgldoiDpCsXzxc1uyX2qeBrt8d7q+6ZNCNlBs/3T6pZfL4VnrJSZbG3pE7p3feolAtpsQVHuCh4v/NrIO7IiHPAJfWtnnWGMOMm/NKSWr05NhhHlcoXg9lPsnmi3WYPCWboJl2yf3qPBXgFsITlag4rSxlMuwp5HUrgGOEY7lnL7KrjaewvdJ+YDg6ASnl35msGkSQt5Hc3PG+PEmSTlBjWA3MgupruuuVguCpTQ4jX1bdPlRJwmYffOq8HG39lU6FzLwUQ3xoRtXiYsT9jaE2z6GKTzGj9UDhHQh+g16Q9qaneLksFDJNDBiIUZltYjRnMHYIJ8M7UO0zj8vBTbslhB4UCuIqZNukhgqKjrcDRDmvAHtwY4xfjOfzD05Q9taqvUV9I7Ri45fzHcFQCQeUlklRRENrBSDO2SaKA+y8GMtTKxTzCZcwmizM0bUORTEaADYPKCuwE0LH55QbOTJvyyAt1qMm2MWbsNi1XBo94UEBfHrkVQLNy7/3JRbiAtjzOHjve73nOjeBDxpBfQ8pNm+Gqsp2wWT9vI+BAmSZx2XHm0K5MzrE8TxE8QMYBFziMSaNsCQtajdgeAH85Hu9HrBKdFJTH0UMZeL3IGQZEMoXIB6ybSSw8qUjN2ToS1Fy6pj5sLJDD6sbT7ILgGWxvyKGO/Lhmz5mBsbyESuzsARiDnj4Ut0IPVgxdKGl8MvVceg6oY7jZpaXYjFJ0I3NEOASv1C1FMgf+vNzILCgQ7Eqqb3pUecRaif8QcbvHg7VHbd8UTzuDNtALTbh1f0Qwszj21bzTKUuuIlB36ZKXct3j/dSNlknR5Aep3reMfvJle03Q53S4Szy0tZOhiAMa+P1S0tJYcdUVNKRjg9XxrpmoD96PTaRKtWKJk7zHj6DRu39w
 QxQjdUCo
 FHHSuPjFuj1t1GgB/+1EHlkvbvxTmTHQezxjEmjmUc/nv38T5cOujffJAAc8nUiO+HsfVeTmWVfawqhcS1HIIbjwCMZAYhyfPUNCrcA7GGB9VS5lcWfWmjGIutd4WKN7D1/wbEVn7v3p9RYIPjdxChBC60qN0vzo5euj1pHQMrRykzQKgKgj51pVeqc73RrCixdedYNl9AQlSo3UDh8mHczTgUPd4WZgemKCSC57MxIK4Hv5Ok/YFOxPrI8AYtWQ8mzBjSwi3tUj7xyBVlwz4fdZfNmU2ekhM7ZodlubY/aSJCyRGVXEQzUk0SoRrdPVdMmFxP3qUWARmDRBLdEXvaczehqiIOL21ht0i8ujOJkD7FG1EVE7++YIb9Z6o7KGPuo2l4i1KCh4mqw3faVFayGnzcb4tL9dmUBo5I8+XtzzfEhFIVAsJ95JAYXdCUX4X/1AP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao wrote:
> On Fri, Nov 21, 2025 at 07:01:44AM -0600, Michael Roth wrote:
> > On Thu, Nov 20, 2025 at 05:11:48PM +0800, Yan Zhao wrote:
> > > On Thu, Nov 13, 2025 at 05:07:59PM -0600, Michael Roth wrote:

[snip]

> > > > @@ -2284,14 +2285,21 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > >  			goto err;
> > > >  		}
> > > >  
> > > > -		if (src) {
> > > > -			void *vaddr = kmap_local_pfn(pfn + i);
> > > > +		if (src_pages) {
> > > > +			void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > > > +			void *dst_vaddr = kmap_local_pfn(pfn + i);
> > > >  
> > > > -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> > > > -				ret = -EFAULT;
> > > > -				goto err;
> > > > +			memcpy(dst_vaddr, src_vaddr + src_offset, PAGE_SIZE - src_offset);
> > > > +			kunmap_local(src_vaddr);
> > > > +
> > > > +			if (src_offset) {
> > > > +				src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > > +
> > > > +				memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
> > > > +				kunmap_local(src_vaddr);
> > > IIUC, src_offset is the src's offset from the first page. e.g.,
> > > src could be 0x7fea82684100, with src_offset=0x100, while npages could be 512.
> > > 
> > > Then it looks like the two memcpy() calls here only work when npages == 1 ?
> > 
> > src_offset ends up being the offset into the pair of src pages that we
> > are using to fully populate a single dest page with each iteration. So
> > if we start at src_offset, read a page worth of data, then we are now at
> > src_offset in the next src page and the loop continues that way even if
> > npages > 1.
> > 
> > If src_offset is 0 we never have to bother with straddling 2 src pages so
> > the 2nd memcpy is skipped on every iteration.
> > 
> > That's the intent at least. Is there a flaw in the code/reasoning that I
> > missed?
> Oh, I got you. SNP expects a single src_offset applies for each src page.
> 
> So if npages = 2, there're 4 memcpy() calls.
> 
> src:  |---------|---------|---------|  (VA contiguous)
>           ^         ^         ^
>           |         |         |
> dst:      |---------|---------|   (PA contiguous)
> 

I'm not following the above diagram.  Either src and dst are aligned and
src_pages points to exactly one page.  OR not aligned and src_pages points
to 2 pages.

src:  |---------|---------|  (VA contiguous)
          ^         ^
          |         |
dst:      |---------|   (PA contiguous)

Regardless I think this is all bike shedding over a feature which I really
don't think buys us much trying to allow the src to be missaligned.

> 
> I previously incorrectly thought kvm_gmem_populate() should pass in src_offset
> as 0 for the 2nd src page.
> 
> Would you consider checking if params.uaddr is PAGE_ALIGNED() in
> snp_launch_update() to simplify the design?

I think this would help a lot...  ATM I'm not even sure the algorithm
works if order is not 0.

[snip]

>  
> > > Increasing GMEM_GUP_NPAGES to (1UL << PUD_ORDER) is probabaly not a good idea.
> > > 
> > > Given both TDX/SNP map at 4KB granularity, why not just invoke post_populate()
> > > per 4KB while removing the max_order from post_populate() parameters, as done
> > > in Sean's sketch patch [1]?
> > 
> > That's an option too, but SNP can make use of 2MB pages in the
> > post-populate callback so I don't want to shut the door on that option
> > just yet if it's not too much of a pain to work in. Given the guest BIOS
> > lives primarily in 1 or 2 of these 2MB regions the benefits might be
> > worthwhile, and SNP doesn't have a post-post-populate promotion path
> > like TDX (at least, not one that would help much for guest boot times)
> I see.
> 
> So, what about below change?

I'm not following what this change has to do with moving GUP out of the
post_populate calls?

Ira

> 
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -878,11 +878,10 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>                 }
> 
>                 folio_unlock(folio);
> -               WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> -                       (npages - i) < (1 << max_order));
> 
>                 ret = -EINVAL;
> -               while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
> +               while (!IS_ALIGNED(gfn, 1 << max_order) || (npages - i) < (1 << max_order) ||
> +                      !kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
>                                                         KVM_MEMORY_ATTRIBUTE_PRIVATE,
>                                                         KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>                         if (!max_order)
> 
> 
> 

[snip]

