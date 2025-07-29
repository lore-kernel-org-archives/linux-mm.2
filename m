Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4EA9C83F17
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 00:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1426B008A; Mon, 28 Jul 2025 20:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371AB6B008C; Mon, 28 Jul 2025 20:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBBE16B0092; Mon, 28 Jul 2025 20:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCAD16B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:23:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DC991A0430
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 00:23:15 +0000 (UTC)
X-FDA: 83715402750.17.B9E0DD7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3767F1C0005
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 00:23:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DPRKItQM;
	spf=pass (imf21.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753748591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7HwLc0FIow95YQDrv5J5k7zmfan1eqEPTeIf+yxXL0=;
	b=XUuhI65JLvc/NvYsge6ka5/4dZ3d3nb/6xzszTZS7UZs596AxCF2ah9TyzFce3rGCoBR8S
	VYZrdIyf8Y7Z5naCAhFR6A1ewmieA5um1XsYDiQD0u12uNRh338HHXlh83IConCTfZqLtC
	XB7bVZBP/Q32zchEvBS6NB1KaPytpzo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753748591; a=rsa-sha256;
	cv=fail;
	b=JqU4CxyxDGMp5sUeOKHG3KJYvUHjhUQCwsWFfkDJKtmyRT1DP/SQT1CjuokktRsMC+/iRy
	NG9ipPbTew01hHIA1j8tL6A/XPSHlkHemn0eDFQUoQWI44SaD9jdPLVCKuWrWLz3sm5SmF
	Uqim53OAvjNvfSV1f8H6v16mXO1Ss1Q=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DPRKItQM;
	spf=pass (imf21.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753748591; x=1785284591;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+o62Nz1ADaVHoUJGUirk5nbivaJqr9cAj7Y+5DazKo4=;
  b=DPRKItQMwrGuOdtiQww75sLj9UchAiFRHLYsDa4DJ3GRfEsS1EPjyxjU
   J4AjCTfBY/nS6pM23nhabHtdYLFTgrzDvZke9hrWNBPHODtzBgJAQbAxu
   JkiL2J9RFtXve5vAQdsfOtxVSbZHTGKqQuohlf3vfitnzsEt1ZzBIg1jG
   LIcLqW3ZQjZ1kJuHbf+Zk7JdX+UBiYDyH0Gwmn8o06mvTBfkyvoKFifAe
   esxSSlEIffbzaZIK5F4/8ZREkvoNktLS3+oFj1Ot8G67cw8k8WbFbLjlJ
   XOw6+XdM0yU/6/G8eg7LOjeC7RF8H+Qy9ZFpLqfzl2v7mMBkNBqwfoZoL
   Q==;
X-CSE-ConnectionGUID: nEdQzNbVRlqDj4/hAXmLCw==
X-CSE-MsgGUID: +SZHQH9hT2OKiBjH0/O9Dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11505"; a="59656321"
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="xz'341?scan'341,208,341";a="59656321"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 17:23:05 -0700
X-CSE-ConnectionGUID: 4InJNxG7TW6Ix1UhyHc/4A==
X-CSE-MsgGUID: R12IYTJgRyO1+5tWVgrKZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="xz'341?scan'341,208,341";a="162121093"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 17:23:04 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 17:23:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 28 Jul 2025 17:23:03 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.70)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 17:23:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R97Btpm2H8rRAHwWy0bY3h+h/gXIAZzfwb60WpkefqpN9tFb8M/beLZPu4xcH28sLpgWKyLwnAntxoQr9VIkqMtfEFwgOU1r07VegD0L5/rcup8RnKBBJ4XQbM3AfvnSz07wbkPq2548z2RBlXniPH/xQK2w5rKu7MiXJ1r2jO74vyKL8AV53ynUOnDcBIMhdP11D6lpVaTQwdlPFFMVLZXKPoCWQ/jJe0hK6psJ2IUQwaJHCMq+FosZjvAOyvuahpKBkK+MAS4bXDAyalEDQoH8Q5cbb1sc4OEcQPxOWSr8oLQeaTnT6oNzrYkIeTv3KaFY15ykUbEgEwuSVySwbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOC2tHR/8lfNi5aVjaXU07u3t8hLolCTde4XNrFH3YE=;
 b=qRmiRIfKUKiNew4F0JTx2VNeFxGd8pFkWcmGnw92e1fRcyOryg3aCwhv8JeZqy9Y7VVcUKhC0hq4YUXVVWlyKk5Ca5egGcq88jlDsDojYvu1kxOfwiDp+bPmAti6czJr7WQVGYKvKbnZr1tdvrpVJWFXcj5yB7N226O1ghm7o1fMwgV3kro8C5z9Q0ZFRZOTYq5s1xSRW5HtH3QspyQR0KBQckA1QqdsMKHc1TXDG16UEkB04SkPHsQfwMSb1DZkV+vn8k88/32US7Dn6NDF39+s+fTYsb1/L7fxgrimlVp3ct13xgdJcuemmnE/WdCSmN2FOM2n2pkU5zuev8ZVFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SJ0PR11MB6621.namprd11.prod.outlook.com (2603:10b6:a03:477::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 29 Jul
 2025 00:22:54 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 00:22:54 +0000
Date: Tue, 29 Jul 2025 08:22:42 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, <oe-lkp@lists.linux.dev>,
	<lkp@intel.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, "Sebastian
 Andrzej Siewior" <bigeasy@linutronix.de>, <linux-mm@kvack.org>,
	<ltp@lists.linux.it>, <oliver.sang@intel.com>
Subject: Re: [tip:locking/futex] [futex]  56180dd20c:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c
Message-ID: <aIgUUhKWesDpM0BJ@xsang-OptiPlex-9020>
References: <202507231021.dcf24373-lkp@intel.com>
 <87a54usty4.ffs@tglx>
 <aINKAQt3qcj2s38N@xsang-OptiPlex-9020>
 <87seikp94v.ffs@tglx>
Content-Type: multipart/mixed; boundary="y6lvXpVbwxqtoTpt"
Content-Disposition: inline
In-Reply-To: <87seikp94v.ffs@tglx>
X-ClientProxiedBy: SI2PR01CA0007.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::11) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SJ0PR11MB6621:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d9ced79-a0fe-45b9-2123-08ddce360d8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|4053099003;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?acEtiZjbHKyf5BOSHxLQV4YVphXryaTvVoU0bxEM8JmCIKJZNL7qQNp58tE+?=
 =?us-ascii?Q?r0eatj+ICvF6x1YF2HWnnY3ZS8gbXHYtG2/H6gQcx8LKTTqWgvbHF5Y3iSu6?=
 =?us-ascii?Q?rqC6XsQpUAY4Wnw8b0loX2h3pSAFTMCDfGmqRgPz9LFArMbmK/KH1Oljf+ia?=
 =?us-ascii?Q?EOmCjCVRyd1NfAefC0/JtL4SDpcQM0tGFMHiUZyiodQKT23AP0n9+9d4FT0w?=
 =?us-ascii?Q?NDdOYrttUeLfby+gXvhih/tsZRoYUme+Ld7i/y2bCghm4Ip/PC9iUJuhE7Ul?=
 =?us-ascii?Q?EogcxYIwnp1+ssev+9pdNNhnpdMvlSt21JOZ6ikZ8Der5jdnDyDIqx1FdgD+?=
 =?us-ascii?Q?k3UnpykD3BgBLWSJ2iJyfKOfywGpwHtx0zoIWFHgAqXhsvVjYXjw2Ctom91I?=
 =?us-ascii?Q?ez2VMHMmZ9DVJ+k3cPZukdP03+3lLkCcu8qJokjsJdvWIQdVo6oexz6v8EGH?=
 =?us-ascii?Q?KFcbrn9GUEBP5sMNFJVK5JXoonyEf6TCN0/pc159jgHWOzw/lIM8wP4n7UEq?=
 =?us-ascii?Q?S776FNF1BYUBf3rSozlDU274/tYPbR9jU5pSo4YrAr/fnBqBcc2rzyYWQmMW?=
 =?us-ascii?Q?orYbNPkq9PsOVaLelIzfUwyvm+UXIrjDsEwOyWX0jah6IZeHD0L0cMALB0rl?=
 =?us-ascii?Q?nJkpE3Vl4QPru4XeQ74/OYCtWZ43BpwpYludeeKKfiBMEPTtiolYfuBue0uR?=
 =?us-ascii?Q?yKCR2qs+l5R3aC/aQudkiAPyccpeakXmn9PksMWQmRhylcQUG6X88Y+DE03q?=
 =?us-ascii?Q?W1BLRhTGqft6HwhAHqxTbH6DLIxl75aekYrEPoNwFZw5aNX4oGB6ybiLnjCB?=
 =?us-ascii?Q?HdFNtADv6OralgSUkR0KK0RQVJE2NeNyzVGRJDMw0orBB0m+wFsSVZoRz8df?=
 =?us-ascii?Q?yN5uYR5dPWz+Dwyf5Mc3AweYozPy/r1WFlnhljtJWS3sTWgC+ayA4DYSZ5z7?=
 =?us-ascii?Q?rFFC33VjZOT8jiXV/zwapHcdzR/C5UID6xfP+1/hjmxlamZBTLe4N6Ue12Kj?=
 =?us-ascii?Q?Uo0RonUcFeJQWOQfo3upKtW86heGUD5YYDOdFdx9QtKciYV3EDErOMqAlX4a?=
 =?us-ascii?Q?l+OXzD9s58cMSWiyj4sZtIKHe25QeZQO8uuxuXRlj2iARa0ZrjGlWtVb8p0C?=
 =?us-ascii?Q?P6ZDG4szcosSPD+7Lsk4rUySyqwm/oUGhYRtaz/+wONQbC8zEvmtHRAaWfXY?=
 =?us-ascii?Q?V8kO0ZQ0SURJcl2IEVnhl7NQc6PZMB2GSfqrDVZmqzP/wARqOIM20y2HUvye?=
 =?us-ascii?Q?fiP7zyYUwHDIolaZKX9NL4hi+0VHjnyqvh33gg/DjFsovEM7Vhn1ZQGQmrPq?=
 =?us-ascii?Q?eNeaujhlahSG56wGGLRSrfmXxf141OMx8Kn63ek0xvMtnxCQtWDw8zy3102A?=
 =?us-ascii?Q?/rU1rKKtvkGcraYHo2noAobpOlFsX1mdDLPcF+weBvb6zY2HqFoIy64j/omA?=
 =?us-ascii?Q?nALOLBtkP7s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wftZucXf7BL3VogW5EedrurVTiQFq+EyyqwZI81Svz8z+oMsWQWFjTEhNA0J?=
 =?us-ascii?Q?O0GoHksDB2+Vw6mcvK1hdMiGQWCe0CTdhsyjcvlSAtLOTGhMRNpHkQBGbT7t?=
 =?us-ascii?Q?nBwoRbuK0rMZqR56Nh3/5qBTaVqSE2bu35lAbob6oxRpuffgar4FOGCK6sSi?=
 =?us-ascii?Q?89M0UzQSN5ehaUJwCvNZrYWeFzEAlo59155xh4sXHnD/yLDF/dE7MLRDzROn?=
 =?us-ascii?Q?qFpO1ZMXKpGJCXcy1OSigXg+na1QrMRtItcFsnswxmCrwj8NEyxvTexk8XsD?=
 =?us-ascii?Q?tjYhBczrf3xufXzyZ8i81JLlbWfE3AQpVdF4I/1nIPLuqATygwNLO/9K4pvx?=
 =?us-ascii?Q?f/CMOEVEv14h55sP3+L8wHTOkh5+rTH9JVNOZvmweIa1ZIu0IOpB6dygp0o8?=
 =?us-ascii?Q?K8BfXB/s72Fj9RP7ZiPecjWD8KGl88BX+FEdEzuduh6UOp7o639QIR67X7mN?=
 =?us-ascii?Q?R0TRC3o1tled7Am0sXccFcT5D6E70WU2gIsGSeBcXuggpCrb6gHiH4Gz1Ct1?=
 =?us-ascii?Q?ol5wgWfLZuT4MYFKQIgfbNzjhQdm/UjLX0w0e8ZQB87WQzrK+aWqvQShT6jh?=
 =?us-ascii?Q?toJEXDpJkG9vGen811/B42ecg3rYAZbhYgm4DTFwXC0wd174BtiuHFZv01lg?=
 =?us-ascii?Q?IUvWeoplU9cQt+spQ1JaMKKGszliNBpmn/OzoWrVeCKEXcuAN8jC37pm7pe4?=
 =?us-ascii?Q?3WvCePqYK7QG60quRUBrcIiiPH/vIKGJ7RI1BeKXNH1pYmwIQIT+9cIGMNOH?=
 =?us-ascii?Q?NaWIeqvQ37cJY3oN9D9Xx3aSE2H+9gXwazdaaS6RdTKSTqbldvRgVXIUKS/l?=
 =?us-ascii?Q?8uwZmu91dBwbUpOx1eUGrNmgj1Vbavp3Xk6OwlFztB+resMpRN1l0HzRHmht?=
 =?us-ascii?Q?UMcYBC93FY0X+itLVsko62y2ychRx3YPOAz2LjCFPUtuw+SoCtsvj3CFea4l?=
 =?us-ascii?Q?68Ax2uD8tAQUvA5XCznaLyF9ke77r4Bo1u6753TPXg9/xppBzNxdBa09R/+P?=
 =?us-ascii?Q?BFyj/aiKZl1uUk/UndVRz6DNhE/5tS4GtASaJMPc6w6iEU9bQiGJYSp9pNU+?=
 =?us-ascii?Q?k8C3RLOiuAfKBfgdpqlWxiCxeakiDiF+MDCFCczT/cUYwvT7pSQHGISaTaDz?=
 =?us-ascii?Q?orheYBb/6t+VfGVJ70RxwP3uQ7a/Mf40Jp14bYXLcAr/UKq1AGO9EQ/eFTav?=
 =?us-ascii?Q?ua8tNBFlXi67ZHsfdrzPltbRKITPMM3EM9WA33pMBKtCnYVmu8NjUnMQPXtD?=
 =?us-ascii?Q?UIFeel/oXH3TN6SxLoqFIQ8tBOXf7G5rARe11QdFBypp+et+CkdvVzAdqyRh?=
 =?us-ascii?Q?exF6fOpvjgL/dbO3+sMmm9toWK0w82RXuS9xWMSKAMgBXEjUL5Z4m+oRpTcx?=
 =?us-ascii?Q?5UmfkR+igg8A+l1tYEW5Noe9UdYr2A/xnq8c3NxlOvkceeu+LUvJf7ZrK1hV?=
 =?us-ascii?Q?WEfNRqyk8zlMjLHMAQov+lYesm+oExzn7B4Yxs7qZubfaKQ8Xt0SDQZPvQl/?=
 =?us-ascii?Q?b7lz3aWw2Aq3msXPxV5GoZf5FMKNgF4XPo59Sla3B2tMfGZnNO673ZCd255F?=
 =?us-ascii?Q?FHRQDdXMTHboD3Yotyn8RKPlfDZsydx5AzmjKQFfaKxghfU9L/SCg9CNq3Na?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d9ced79-a0fe-45b9-2123-08ddce360d8d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 00:22:54.0866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MT6nwjw5YPKMRhO9kqI4vMSnBYhz7kpwhwYt7h9Z4qnfGERA0WcLM3P/lBd0RiPgCJSg+X2+sUSylhWTmRZpmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6621
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 3767F1C0005
X-Stat-Signature: tppms3sp43pwwzo1juihkzwbf93cznfw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753748589-352961
X-HE-Meta: U2FsdGVkX19gewt62iGBfD1ONdx08V+hOFwzJxkCXPcY7+HwMuYOelx+x8AB/nWExfo8M5H0iNZom11mGL6+RhwVowAj+xzyWx8oJZ7cnj9pnD7i/PoQh5ZRdZt+boLkc7uQ5/c2c0ngVmvm4YiN+t9pxvf/Qn4/2y7zPjmAfft7yhpAttdSV+/WsXiE0WfHpWSULMhKuWEUx05ppgyu1orgf4Cd1+HPbW/jERCEfnlynZpvytI+0JCzyyHPPQpj4ooyCtgw3W2/7rWR6gXv3mVwS0P+VVyIHTI+0VJWV/+YR1bx0VfcyQsrHuWhuk7NcI3oolGcalg4yIyZDuMFCobgf9mWzcoypwsDZahyHlsf+iVj/pHlEz5VGygjf7c8Ojvu2KYXyJTr00siBPnh7WTyQAoHQ2Ak2ASlCdrrJG3EPPWhpTm/YrFGbi3Qk7WgaFnmEe2JXVqzdbQhX/jF3jpqQrsyShiZxmLebQHvdGh1mXPS87ERKbjXxP/L2m5erNMIpCv/wCctUwZJA8F1jYjIT+N764+5le7fTXApq3amR2HrVNhBSWpBpoUmIcGNhkRVP3d5wnWGKsH+FU1yQBOQMEic34K/k5hkj9wIX68xnIt+DZlv9jEz9UDRxN3y7KJMBw6xXhQTFH/d1yk+N3xHnhxdXGDzAoPLYsFXHVyVSfkj2OKhZzLAP3KeG7M1SgYJAG1J/y+vxD2Ukw7y6lIqEuGu2cXtvoRv6LT9u+J9dTaiFxAXn3pmnIpmlupEScmZjqv8wMUUzGcZgz4ze1f0/LiksIO2Yu5J7ptBjwkgimIsnP4QCA/uot1P+6R9vCRMmA4TcM+uEe43rmqs1tIJB9/rw5/Q4OdNx4Nf8SRmJv1Q3jLbjDt4Zych0Avod2Ws5nenOJfLwdW4bMN6wcYXZyubV4uvb8dme1+Xcm17j/3+h114RyjudhL2njbuI9Dff4hxaFzctbjhLAg
 gJa3zEVI
 IsB1PJc4v7R8Ie8klkcjBgHn4fKyC/zYJic8B1cI2ru8kUeejptgsKOUbuT1iOTsBnyyE/6lwEyN5aUfSCpVJUVpzUIxQXqKQM5b09elTEZ2fXWmrhHOLMKaYyhMs20UzLURTxeIlSS4HuEgqMpiw09qNp3j5tMaHrjJ7oBwM3NfC1TaXMfmk4l6y1cciURTpRUPM+7twiAc1fNq1o1dl29Q2bdvpOz2y7on1hHtdhWbjx+5qZz3cAgDRO4c7XP3/BOwQfvVb+01wwJs/4XbwcLhAxe/q7hnHwV2uFhjJPqNds+aex7gN9eYFKlwUCQYen46PErzVqFO4WDIor8z1pmW3HbwuqNnUrYSYdnGoRBII0v7G39EnOMrpDwe/uXNB2kr557X2koLhK5gxMBlzhxcAqZAverM6QzeM9OOaVFe+G14LlrlqQEN7T16wGBmnkH+CS1kF12NJn7jhWC8hdCn0dAue1fYyzL4JqBZKKqykLjDXgXNP1Dy8wCOFMDKuuLJW7mBYaemP+gJl7I7eYC8MCu+TAfZGb7hI/DURHPj6TZx4nQ1QtJD9ho+R9yFk4RX2FmMdhHRp6vqTmWbsETZ0INpZEIwfhQtfhrY+u/sHbm4RB6sz3nhGKgmDWk5AH9E36I3ihntbc9pQTMzbQRcKJFs8F8bgHSLlY/Ckg+7JYO8MywnYicmUqiORFoSrwllzHAv3iQ4ySkCXK/j6hNNgEaBMn9DmXQ/Luvh9ltsjlIB38xXo3Amg3JVGifudgjtvO3APl2We0C9tTwMV72ECuqxunghG87JrdQWq1ckk99HyacJjL/sQhtHfftfUgTzCGFMbY2oU0LXPSNrq9ttsQXIsahPLWsrU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--y6lvXpVbwxqtoTpt
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

hi, Thomas Gleixner,

On Fri, Jul 25, 2025 at 05:45:04PM +0200, Thomas Gleixner wrote:
> Oliver!
> 
> On Fri, Jul 25 2025 at 17:10, Oliver Sang wrote:
> > On Wed, Jul 23, 2025 at 07:22:43PM +0200, Thomas Gleixner wrote:
> >> > [  286.673775][   C97] BUG: sleeping function called from invalid context at kernel/nsproxy.c:233   <---- (1)
> >> > [  286.673784][   C97] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6748, name: oom03
> >> > [  286.673787][   C97] preempt_count: 7ffffffe, expected: 0
> >> 
> >> Ooops. That's a corrupted preempt counter, which has underflown twice.
> >> 
> >> Can you please enable CONFIG_DEBUG_PREEMPT, so we can see where this
> >> happens?
> >
> > after enable CONFIG_DEBUG_PREEMPT, the config is as attached
> > config-6.16.0-rc5-00002-g56180dd20c19
> 
> Thank you for trying, but I just realized that it tells us only when it
> underflows, but we don't see where the actual extra decrement happens
> before that.
> 
> Can you please enable CONFIG_PREEMPT_TRACER and add
> 
> 'trace_event=preemptirq:preempt_disable,preemptirq:preempt_enable ftrace_dump_on_oops'
> 
> to the kernel command line. The latter will dump the recorded
> preempt_enable/disable events and we can pinpoint the function which is
> responsible for that.

the config with CONFIG_PREEMPT_TRACER enabled is attached as
config-6.16.0-rc5-00002-g56180dd20c19

by this config, we still see random
WARNING:at_kernel/sched/core.c:#preempt_count_sub

=========================================================================================
compiler/kconfig/rootfs/tbox_group/test/testcase:
  gcc-12/x86_64-rhel-9.4-ltp_+CONFIG_PREEMPT_TRACER/debian-12-x86_64-20240206.cgz/lkp-skl-fpga01/mm-oom/ltp

a255b78d14324f8a 56180dd20c19e5b0fa34822997a
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :20          60%          12:20    dmesg.RIP:preempt_count_sub
           :20          60%          12:20    dmesg.WARNING:at_kernel/sched/core.c:#preempt_count_sub

but bot seems not be able to capture other new dmesg stats.
I attached one dmesg as example dmesg-CONFIG_PREEMPT_TRACER.xz

since there are other 11 instances, if there should be some pattern for the dump
you mentioned, could you tell me? I will search in other instances if nothing
in the dmesg I attached. thanks


Decompressing Linux... No EFI environment detected.
Parsing ELF... No relocation needed... done.
Booting the kernel (entry_offset: 0x0000000003103444).
[    0.000000][    T0] Linux version 6.16.0-rc5-00002-g56180dd20c19 (kbuild@788d51ef74a4) (gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40) #1 SMP PREEMPT_DYNAMIC Mon Jul 28 14:54:17 CST 2025
[    0.000000][    T0] Command line: ip=::::lkp-skl-fpga01::dhcp root=/dev/ram0 RESULT_ROOT=/result/ltp/mm-oom/lkp-skl-fpga01/debian-12-x86_64-20240206.cgz/x86_64-rhel-9.4-ltp_+CONFIG_PREEMPT_TRACER/gcc-12/56180dd20c19e5b0fa34822997a9ac66b517e7b3/16 BOOT_IMAGE=/pkg/linux/x86_64-rhel-9.4-ltp_+CONFIG_PREEMPT_TRACER/gcc-12/56180dd20c19e5b0fa34822997a9ac66b517e7b3/vmlinuz-6.16.0-rc5-00002-g56180dd20c19 branch=tip/locking/futex job=/lkp/jobs/scheduled/lkp-skl-fpga01/ltp-mm-oom-debian-12-x86_64-20240206.cgz-56180dd20c19-20250728-4057047-16v2vnz-7.yaml user=lkp ARCH=x86_64 kconfig=x86_64-rhel-9.4-ltp_+CONFIG_PREEMPT_TRACER commit=56180dd20c19e5b0fa34822997a9ac66b517e7b3 trace_event=preemptirq:preempt_disable,preemptirq:preempt_enable ftrace_dump_on_oops ....


....


[  409.832569][ T7668] ------------[ cut here ]------------
[  409.855676][ T7668] DEBUG_LOCKS_WARN_ON(val > preempt_count())
[  409.855687][ T7668] WARNING: CPU: 54 PID: 7668 at kernel/sched/core.c:5903 preempt_count_sub+0xdf/0x1b0
[  409.871916][ T7668] Modules linked in: intel_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common skx_edac skx_edac_common nfit libnvdimm btrfs blake2b_generic xor zstd_compress raid6_pq x86_pkg_temp_thermal intel_powerclamp sd_mod sg coretemp kvm_intel irdma kvm ice irqbypass snd_pcm ghash_clmulni_intel gnss snd_timer ast rapl ib_uverbs snd ahci acpi_power_meter drm_client_lib intel_cstate ipmi_ssif libahci nvme mei_me soundcore drm_shmem_helper i2c_i801 intel_uncore ioatdma ib_core nvme_core pcspkr libata mei drm_kms_helper i2c_smbus lpc_ich intel_pch_thermal wmi dca ipmi_si acpi_ipmi ipmi_devintf ipmi_msghandler acpi_pad joydev binfmt_misc drm fuse loop dm_mod ip_tables
[  409.936794][ T7668] CPU: 54 UID: 0 PID: 7668 Comm: oom05 Not tainted 6.16.0-rc5-00002-g56180dd20c19 #1 PREEMPT(voluntary) 
[  409.948414][ T7668] RIP: 0010:preempt_count_sub+0xdf/0x1b0
[  409.954478][ T7668] Code: 11 38 d0 7c 08 84 d2 0f 85 c4 00 00 00 8b 15 08 b6 e2 04 85 d2 75 b6 48 c7 c6 60 1e 2d 84 48 c7 c7 a0 1e 2d 84 e8 a1 f1 f2 ff <0f> 0b eb 9f 4c 8b 65 08 4c 89 e7 e8 11 4f 0e 00 85 c0 74 0a 31 ff
[  409.975094][ T7668] RSP: 0018:ffffc9003733f938 EFLAGS: 00010286
[  409.981634][ T7668] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[  409.990088][ T7668] RDX: 0000000000000002 RSI: 0000000000000004 RDI: 0000000000000001
[  409.998542][ T7668] RBP: ffffc9003733f948 R08: 0000000000000001 R09: ffffed12f53c5839
[  410.006983][ T7668] R10: ffff8897a9e2c1cb R11: 0000000000000001 R12: ffff888187f5a1c0
[  410.015428][ T7668] R13: ffffc9003733fbd0 R14: 00000000003d0f00 R15: 0000000000001df4
[  410.023855][ T7668] FS:  00007f33a7dbd740(0000) GS:ffff889822a6e000(0000) knlGS:0000000000000000
[  410.033269][ T7668] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  410.040336][ T7668] CR2: 00007f279d5ffd58 CR3: 000000016ccaa001 CR4: 00000000007726f0
[  410.048798][ T7668] PKRU: 55555554
[  410.052841][ T7668] Call Trace:
[  410.056636][ T7668]  <TASK>
[  410.060076][ T7668]  _raw_spin_unlock+0x19/0x70
[  410.065274][ T7668]  copy_process+0x4244/0x4ab0
[  410.070464][ T7668]  ? 0xffffffff81000000
[  410.075139][ T7668]  ? __pfx_copy_process+0x10/0x10
[  410.080681][ T7668]  ? _inline_copy_from_user+0x4f/0xb0
[  410.086572][ T7668]  ? copy_clone_args_from_user+0xff/0x670
[  410.092816][ T7668]  ? preempt_count_sub+0x109/0x1b0
[  410.098458][ T7668]  kernel_clone+0xb6/0x7b0
[  410.103406][ T7668]  ? __pfx_kernel_clone+0x10/0x10
[  410.108959][ T7668]  ? _copy_to_user+0x5c/0x70
[  410.114081][ T7668]  ? __x64_sys_rt_sigprocmask+0x183/0x230
[  410.120346][ T7668]  __do_sys_clone3+0x150/0x1b0
[  410.125648][ T7668]  ? __pfx___do_sys_clone3+0x10/0x10
[  410.131479][ T7668]  ? trace_event_buffer_commit+0x191/0x470
[  410.137824][ T7668]  ? trace_event_buffer_reserve+0x200/0x330
[  410.144248][ T7668]  ? trace_event_buffer_commit+0x191/0x470
[  410.150566][ T7668]  ? trace_event_raw_event_preemptirq_template+0x12c/0x1b0
[  410.158279][ T7668]  ? __pfx_trace_event_raw_event_preemptirq_template+0x10/0x10
[  410.166337][ T7668]  ? trace_event_raw_event_preemptirq_template+0x12c/0x1b0
[  410.174029][ T7668]  do_syscall_64+0x7f/0x2f0
[  410.179022][ T7668]  ? count_memcg_events+0x2a7/0x470
[  410.184693][ T7668]  ? count_memcg_events+0x2a7/0x470
[  410.190351][ T7668]  ? trace_preempt_on+0x8c/0xb0
[  410.195655][ T7668]  ? count_memcg_events+0x2a7/0x470
[  410.201305][ T7668]  ? preempt_count_sub+0x109/0x1b0
[  410.206857][ T7668]  ? count_memcg_events+0x2a7/0x470
[  410.212493][ T7668]  ? handle_mm_fault+0x3ff/0x6f0
[  410.217843][ T7668]  ? do_user_addr_fault+0x91f/0xef0
[  410.223455][ T7668]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  410.229747][ T7668] RIP: 0033:0x7f33a7ec9889
[  410.234550][ T7668] Code: 31 ed e9 44 ff ff ff e8 25 e9 00 00 0f 1f 44 00 00 b8 ea ff ff ff 48 85 ff 74 2c 48 85 d2 74 27 49 89 c8 b8 b3 01 00 00 0f 05 <48> 85 c0 7c 18 74 01 c3 31 ed 48 83 e4 f0 4c 89 c7 ff d2 48 89 c7
[  410.255034][ T7668] RSP: 002b:00007ffc670703f8 EFLAGS: 00000206 ORIG_RAX: 00000000000001b3
[  410.263824][ T7668] RAX: ffffffffffffffda RBX: 00007f33a7e48ef0 RCX: 00007f33a7ec9889
[  410.272185][ T7668] RDX: 00007f33a7e48ef0 RSI: 0000000000000058 RDI: 00007ffc67070440
[  410.280503][ T7668] RBP: 00007f279d5ff6c0 R08: 00007f279d5ff6c0 R09: 00007ffc67070537
[  410.288823][ T7668] R10: 0000000000000008 R11: 0000000000000206 R12: ffffffffffffff78
[  410.297149][ T7668] R13: 0000000000000000 R14: 00007ffc67070440 R15: 00007f279cdff000
[  410.305468][ T7668]  </TASK>
[  410.308836][ T7668] ---[ end trace 0000000000000000 ]---
[  410.337739][ T1354] oom.h:181: TPASS: victim signalled: (9) SIGKILL
[  410.337753][ T1354] 




> 
> Thanks,
> 
>         tglx
> 
> 
> 

--y6lvXpVbwxqtoTpt
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-6.16.0-rc5-00002-g56180dd20c19"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 6.16.0-rc5 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=120200
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=24000
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=24000
CONFIG_LLD_VERSION=0
CONFIG_RUSTC_VERSION=0
CONFIG_RUSTC_LLVM_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_GCC_ASM_GOTO_OUTPUT_BROKEN=y
CONFIG_TOOLS_SUPPORT_RELR=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_LD_CAN_USE_KEEP_IN_OVERLAY=y
CONFIG_PAHOLE_VERSION=130
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_UAPI_HEADER_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT="5.14.0-427.20.1.el9_4.x86_64"
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_WATCH_QUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST_IDLE=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_IDLE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING_USER=y
# CONFIG_CONTEXT_TRACKING_USER_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=125
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
# CONFIG_BPF_PRELOAD is not set
# CONFIG_BPF_LSM is not set
# end of BPF subsystem

CONFIG_PREEMPT_BUILD=y
CONFIG_ARCH_HAS_PREEMPT_LAZY=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_LAZY is not set
# CONFIG_PREEMPT_RT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_DYNAMIC=y
CONFIG_SCHED_CORE=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_PSI=y
CONFIG_PSI_DEFAULT_DISABLED=y
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_NEED_TASKS_RCU=y
CONFIG_TASKS_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_DEFAULT_ALL is not set
# CONFIG_RCU_LAZY is not set
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_IKHEADERS=m
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_INDEX=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
CONFIG_GCC10_NO_ARRAY_BOUNDS=y
CONFIG_CC_NO_ARRAY_BOUNDS=y
CONFIG_GCC_NO_STRINGOP_OVERFLOW=y
CONFIG_CC_NO_STRINGOP_OVERFLOW=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_SLAB_OBJ_EXT=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
# CONFIG_CGROUP_FAVOR_DYNMODS is not set
CONFIG_MEMCG=y
# CONFIG_MEMCG_V1 is not set
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_GROUP_SCHED_WEIGHT=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_SCHED_MM_CID=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
# CONFIG_CGROUP_DMEM is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
# CONFIG_CPUSETS_V1 is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
CONFIG_CGROUP_MISC=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
CONFIG_BOOT_CONFIG=y
# CONFIG_BOOT_CONFIG_FORCE is not set
# CONFIG_BOOT_CONFIG_EMBED is not set
CONFIG_INITRAMFS_PRESERVE_MTIME=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_LD_ORPHAN_WARN_LEVEL="warn"
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_SMALL is not set
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_FUTEX_PRIVATE_HASH=y
CONFIG_FUTEX_MPOL=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_CACHESTAT_SYSCALL=y
# CONFIG_PC104 is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_SELFTEST is not set
CONFIG_KALLSYMS_ALL=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_GUEST_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y

#
# Kexec and crash features
#
CONFIG_CRASH_RESERVE=y
CONFIG_VMCORE_INFO=y
CONFIG_KEXEC_CORE=y
CONFIG_HAVE_IMA_KEXEC=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_KEXEC_SIG=y
# CONFIG_KEXEC_SIG_FORCE is not set
CONFIG_KEXEC_BZIMAGE_VERIFY_SIG=y
CONFIG_KEXEC_JUMP=y
# CONFIG_KEXEC_HANDOVER is not set
CONFIG_CRASH_DUMP=y
# CONFIG_CRASH_DM_CRYPT is not set
CONFIG_CRASH_HOTPLUG=y
CONFIG_CRASH_MAX_MEMORY_RANGES=8192
# end of Kexec and crash features
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_CSUM=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_AUDIT_ARCH=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_POSTED_MSI=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_CPU_RESCTRL=y
# CONFIG_X86_FRED is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_INTEL_MID is not set
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_XEN=y
# CONFIG_XEN_PV is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_PVHVM_GUEST=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
CONFIG_PVH=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
CONFIG_INTEL_TDX_GUEST=y
CONFIG_CC_HAS_MARCH_NATIVE=y
# CONFIG_X86_NATIVE_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_HAVE_PAE=y
CONFIG_X86_CX8=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_BROADCAST_TLB_FLUSH=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_BOOT_VESA_SUPPORT=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_CLUSTER=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_ACPI_MADT_WAKEUP=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
CONFIG_PERF_EVENTS_AMD_POWER=m
CONFIG_PERF_EVENTS_AMD_UNCORE=y
CONFIG_PERF_EVENTS_AMD_BRS=y
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_LATE_LOADING=y
# CONFIG_MICROCODE_LATE_FORCE_MINREV is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_X86_CPA_STATISTICS=y
CONFIG_X86_MEM_ENCRYPT=y
CONFIG_AMD_MEM_ENCRYPT=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
CONFIG_X86_CET=y
CONFIG_X86_KERNEL_IBT=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_ARCH_PKEY_BITS=4
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_X86_SGX=y
# CONFIG_X86_USER_SHADOW_STACK is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_HANDOVER_PROTOCOL=y
CONFIG_EFI_MIXED=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_ARCH_SUPPORTS_KEXEC=y
CONFIG_ARCH_SUPPORTS_KEXEC_FILE=y
CONFIG_ARCH_SELECTS_KEXEC_FILE=y
CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY=y
CONFIG_ARCH_SUPPORTS_KEXEC_SIG=y
CONFIG_ARCH_SUPPORTS_KEXEC_SIG_FORCE=y
CONFIG_ARCH_SUPPORTS_KEXEC_BZIMAGE_VERIFY_SIG=y
CONFIG_ARCH_SUPPORTS_KEXEC_JUMP=y
CONFIG_ARCH_SUPPORTS_KEXEC_HANDOVER=y
CONFIG_ARCH_SUPPORTS_CRASH_DUMP=y
CONFIG_ARCH_DEFAULT_CRASH_DUMP=y
CONFIG_ARCH_SUPPORTS_CRASH_HOTPLUG=y
CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_XONLY=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
# CONFIG_STRICT_SIGALTSTACK_SIZE is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
CONFIG_X86_BUS_LOCK_DETECT=y
# end of Processor type and features

CONFIG_CC_HAS_NAMED_AS=y
CONFIG_CC_HAS_SLS=y
CONFIG_CC_HAS_RETURN_THUNK=y
CONFIG_CC_HAS_ENTRY_PADDING=y
CONFIG_FUNCTION_PADDING_CFI=11
CONFIG_FUNCTION_PADDING_BYTES=16
CONFIG_CALL_PADDING=y
CONFIG_HAVE_CALL_THUNKS=y
CONFIG_CALL_THUNKS=y
CONFIG_PREFIX_SYMBOLS=y
CONFIG_CPU_MITIGATIONS=y
CONFIG_MITIGATION_PAGE_TABLE_ISOLATION=y
CONFIG_MITIGATION_RETPOLINE=y
CONFIG_MITIGATION_RETHUNK=y
CONFIG_MITIGATION_UNRET_ENTRY=y
CONFIG_MITIGATION_CALL_DEPTH_TRACKING=y
# CONFIG_CALL_THUNKS_DEBUG is not set
CONFIG_MITIGATION_IBPB_ENTRY=y
CONFIG_MITIGATION_IBRS_ENTRY=y
CONFIG_MITIGATION_SRSO=y
# CONFIG_MITIGATION_SLS is not set
CONFIG_MITIGATION_GDS=y
CONFIG_MITIGATION_RFDS=y
CONFIG_MITIGATION_SPECTRE_BHI=y
CONFIG_MITIGATION_MDS=y
CONFIG_MITIGATION_TAA=y
CONFIG_MITIGATION_MMIO_STALE_DATA=y
CONFIG_MITIGATION_L1TF=y
CONFIG_MITIGATION_RETBLEED=y
CONFIG_MITIGATION_SPECTRE_V1=y
CONFIG_MITIGATION_SPECTRE_V2=y
CONFIG_MITIGATION_SRBDS=y
CONFIG_MITIGATION_SSB=y
CONFIG_MITIGATION_ITS=y
CONFIG_ARCH_HAS_ADD_PAGES=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_HIBERNATION_COMP_LZO=y
CONFIG_HIBERNATION_DEF_COMP="lzo"
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_USERSPACE_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
CONFIG_PM_GENERIC_DOMAINS=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_PM_GENERIC_DOMAINS_SLEEP=y
CONFIG_ENERGY_MODEL=y
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
CONFIG_ACPI_TABLE_LIB=y
CONFIG_ACPI_THERMAL_LIB=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_PLATFORM_PROFILE=m
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NHLT=y
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_HMAT=y
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_EINJ_CXL=y
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_ACPI_DPTF=y
CONFIG_DPTF_POWER=m
CONFIG_DPTF_PCH_FIVR=m
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_ACPI_PFRUT=m
CONFIG_ACPI_PCC=y
CONFIG_ACPI_FFH=y
CONFIG_ACPI_MRRM=y
CONFIG_PMIC_OPREGION=y
CONFIG_ACPI_VIOT=y
CONFIG_ACPI_PRMT=y
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_AMD_PSTATE=y
CONFIG_X86_AMD_PSTATE_DEFAULT_MODE=3
CONFIG_X86_AMD_PSTATE_UT=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPUFREQ_ARCH_CUR_FREQ=y
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
CONFIG_CPU_IDLE_GOV_HALTPOLL=y
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_AMD_NODE=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_EMULATION_DEFAULT_DISABLED is not set
# CONFIG_X86_X32_ABI is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
# end of Binary Emulations

CONFIG_KVM_COMMON=y
CONFIG_HAVE_KVM_PFNCACHE=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_DIRTY_RING=y
CONFIG_HAVE_KVM_DIRTY_RING_TSO=y
CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_READONLY_MEM=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=m
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_HAVE_KVM_PM_NOTIFIER=y
CONFIG_KVM_GENERIC_HARDWARE_ENABLING=y
CONFIG_KVM_GENERIC_MMU_NOTIFIER=y
CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG=y
CONFIG_KVM_MMU_LOCKLESS_AGING=y
CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES=y
CONFIG_KVM_PRIVATE_MEM=y
CONFIG_KVM_GENERIC_PRIVATE_MEM=y
CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE=y
CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM_X86=m
CONFIG_KVM=m
# CONFIG_KVM_SW_PROTECTED_VM is not set
CONFIG_KVM_INTEL=m
# CONFIG_KVM_INTEL_PROVE_VE is not set
CONFIG_X86_SGX_KVM=y
CONFIG_KVM_AMD=m
CONFIG_KVM_AMD_SEV=y
CONFIG_KVM_SMM=y
CONFIG_KVM_HYPERV=y
# CONFIG_KVM_XEN is not set
# CONFIG_KVM_PROVE_MMU is not set
CONFIG_KVM_MAX_NR_VCPUS=4096
CONFIG_X86_REQUIRED_FEATURE_ALWAYS=y
CONFIG_X86_REQUIRED_FEATURE_NOPL=y
CONFIG_X86_REQUIRED_FEATURE_CX8=y
CONFIG_X86_REQUIRED_FEATURE_CMOV=y
CONFIG_X86_REQUIRED_FEATURE_CPUID=y
CONFIG_X86_REQUIRED_FEATURE_FPU=y
CONFIG_X86_REQUIRED_FEATURE_PAE=y
CONFIG_X86_REQUIRED_FEATURE_PSE=y
CONFIG_X86_REQUIRED_FEATURE_PGE=y
CONFIG_X86_REQUIRED_FEATURE_MSR=y
CONFIG_X86_REQUIRED_FEATURE_FXSR=y
CONFIG_X86_REQUIRED_FEATURE_XMM=y
CONFIG_X86_REQUIRED_FEATURE_XMM2=y
CONFIG_X86_REQUIRED_FEATURE_LM=y
CONFIG_X86_DISABLED_FEATURE_VME=y
CONFIG_X86_DISABLED_FEATURE_K6_MTRR=y
CONFIG_X86_DISABLED_FEATURE_CYRIX_ARR=y
CONFIG_X86_DISABLED_FEATURE_CENTAUR_MCR=y
CONFIG_X86_DISABLED_FEATURE_LAM=y
CONFIG_X86_DISABLED_FEATURE_XENPV=y
CONFIG_X86_DISABLED_FEATURE_USER_SHSTK=y
CONFIG_X86_DISABLED_FEATURE_FRED=y
CONFIG_AS_AVX512=y
CONFIG_AS_GFNI=y
CONFIG_AS_VAES=y
CONFIG_AS_VPCLMULQDQ=y
CONFIG_AS_WRUSS=y
CONFIG_ARCH_CONFIGURES_CPU_MITIGATIONS=y
CONFIG_ARCH_HAS_DMA_OPS=y

#
# General architecture-dependent options
#
CONFIG_HOTPLUG_SMT=y
CONFIG_HOTPLUG_CORE_SYNC=y
CONFIG_HOTPLUG_CORE_SYNC_DEAD=y
CONFIG_HOTPLUG_CORE_SYNC_FULL=y
CONFIG_HOTPLUG_SPLIT_STARTUP=y
CONFIG_HOTPLUG_PARALLEL=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_KRETPROBE_ON_RETHOOK=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_ARCH_HAS_CPU_FINALIZE_INIT=y
CONFIG_ARCH_HAS_CPU_PASID=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_RUST=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_MMU_GATHER_MERGE_VMAS=y
CONFIG_ARCH_WANT_IRQS_OFF_ACTIVATE_MM=y
CONFIG_MMU_LAZY_TLB_REFCOUNT=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_ARCH_HAVE_EXTRA_ELF_NOTES=y
CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_ARCH_SUPPORTS_AUTOFDO_CLANG=y
CONFIG_ARCH_SUPPORTS_PROPELLER_CLANG=y
CONFIG_ARCH_SUPPORTS_CFI_CLANG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING_USER=y
CONFIG_HAVE_CONTEXT_TRACKING_USER_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_HUGE_VMALLOC=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_PMD_MKWRITE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_ARCH_HAS_EXECMEM_ROX=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_PAGE_SIZE_4KB=y
CONFIG_PAGE_SIZE_4KB=y
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_PAGE_SHIFT=12
CONFIG_HAVE_OBJTOOL=y
CONFIG_HAVE_JUMP_LABEL_HACK=y
CONFIG_HAVE_NOINSTR_HACK=y
CONFIG_HAVE_NOINSTR_VALIDATION=y
CONFIG_HAVE_UACCESS_VALIDATION=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_ARCH_SUPPORTS_RT=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_ARCH_HAS_CPU_RESCTRL=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_ARCH_HAS_CC_PLATFORM=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SUPPORTS_PAGE_TABLE_CHECK=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
CONFIG_DYNAMIC_SIGFRAME=y
CONFIG_HAVE_ARCH_NODE_DEV_GROUP=y
CONFIG_ARCH_HAS_HW_PTE_YOUNG=y
CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG=y
CONFIG_ARCH_HAS_KERNEL_FPU_SUPPORT=y
CONFIG_ARCH_VMLINUX_NEEDS_RELOCS=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
CONFIG_FUNCTION_ALIGNMENT_4B=y
CONFIG_FUNCTION_ALIGNMENT_16B=y
CONFIG_FUNCTION_ALIGNMENT=16
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
# CONFIG_MODULE_DEBUG is not set
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
CONFIG_MODULE_SIG_SHA512=y
# CONFIG_MODULE_SIG_SHA3_256 is not set
# CONFIG_MODULE_SIG_SHA3_384 is not set
# CONFIG_MODULE_SIG_SHA3_512 is not set
CONFIG_MODULE_SIG_HASH="sha512"
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/usr/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLOCK_LEGACY_AUTOLOAD=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_CGROUP_PUNT_BIO=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_ICQ=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_WRITE_MOUNTED=y
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
CONFIG_BLK_CGROUP_IOLATENCY=y
CONFIG_BLK_CGROUP_FC_APPID=y
# CONFIG_BLK_CGROUP_IOCOST is not set
# CONFIG_BLK_CGROUP_IOPRIO is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLK_PM=y
CONFIG_BLOCK_HOLDER_DEPRECATED=y
CONFIG_BLK_MQ_STACKING=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_ZPOOL=y
CONFIG_SWAP=y
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_DEFAULT_ON is not set
# CONFIG_ZSWAP_SHRINKER_DEFAULT_ON is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC=y
CONFIG_ZSWAP_ZPOOL_DEFAULT="zsmalloc"
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y
CONFIG_ZSMALLOC_CHAIN_SIZE=8

#
# Slab allocator options
#
CONFIG_SLUB=y
CONFIG_KVFREE_RCU_BATCHED=y
# CONFIG_SLUB_TINY is not set
# CONFIG_SLAB_MERGE_DEFAULT is not set
CONFIG_SLAB_FREELIST_RANDOM=y
CONFIG_SLAB_FREELIST_HARDENED=y
CONFIG_SLAB_BUCKETS=y
# CONFIG_SLUB_STATS is not set
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_RANDOM_KMALLOC_CACHES is not set
# end of Slab allocator options

CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_SPARSEMEM_VMEMMAP_PREINIT=y
CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP=y
CONFIG_ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP=y
CONFIG_ARCH_WANT_HUGETLB_VMEMMAP_PREINIT=y
CONFIG_HAVE_GUP_FAST=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE=y
# CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_AUTO is not set
# CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_KERNEL is not set
# CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y
CONFIG_SPLIT_PTE_PTLOCKS=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_SPLIT_PMD_PTLOCKS=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_COMPACT_UNEVICTABLE_DEFAULT=1
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_DEVICE_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PCP_BATCH_SCALE_MAX=5
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_MM_ID=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_TRANSPARENT_HUGEPAGE_NEVER is not set
CONFIG_THP_SWAP=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
# CONFIG_NO_PAGE_MAPCOUNT is not set
CONFIG_PAGE_MAPCOUNT=y
CONFIG_PGTABLE_HAS_HUGE_LEAVES=y
CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP=y
CONFIG_ARCH_SUPPORTS_PMD_PFNMAP=y
CONFIG_ARCH_SUPPORTS_PUD_PFNMAP=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_SYSFS=y
CONFIG_CMA_AREAS=7
CONFIG_PAGE_BLOCK_ORDER=10
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ARCH_HAS_ZONE_DMA_SET=y
CONFIG_ZONE_DMA=y
CONFIG_ZONE_DMA32=y
CONFIG_ZONE_DEVICE=y
CONFIG_HMM_MIRROR=y
CONFIG_GET_FREE_REGION=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
CONFIG_ARCH_USES_PG_ARCH_2=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_TEST is not set
# CONFIG_DMAPOOL_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_MAPPING_DIRTY_HELPERS=y
CONFIG_MEMFD_CREATE=y
CONFIG_SECRETMEM=y
# CONFIG_ANON_VMA_NAME is not set
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
CONFIG_USERFAULTFD=y
# CONFIG_PTE_MARKER_UFFD_WP is not set
CONFIG_LRU_GEN=y
CONFIG_LRU_GEN_ENABLED=y
# CONFIG_LRU_GEN_STATS is not set
CONFIG_LRU_GEN_WALKS_MMU=y
CONFIG_ARCH_SUPPORTS_PER_VMA_LOCK=y
CONFIG_PER_VMA_LOCK=y
CONFIG_LOCK_MM_AND_FIND_VMA=y
CONFIG_IOMMU_MM_DATA=y
CONFIG_EXECMEM=y
CONFIG_NUMA_MEMBLKS=y
CONFIG_NUMA_EMU=y
CONFIG_ARCH_SUPPORTS_PT_RECLAIM=y
CONFIG_PT_RECLAIM=y

#
# Data Access Monitoring
#
CONFIG_DAMON=y
CONFIG_DAMON_VADDR=y
CONFIG_DAMON_PADDR=y
CONFIG_DAMON_SYSFS=y
CONFIG_DAMON_RECLAIM=y
# CONFIG_DAMON_LRU_SORT is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_NET_XGRESS=y
CONFIG_NET_REDIRECT=y
CONFIG_SKB_DECRYPTED=y
CONFIG_SKB_EXTENSIONS=y
CONFIG_NET_DEVMEM=y
CONFIG_NET_SHAPER=y
CONFIG_NET_CRC32C=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_AF_UNIX_OOB=y
CONFIG_UNIX_DIAG=y
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_USER_COMPAT is not set
CONFIG_XFRM_INTERFACE=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_XFRM_IPTFS is not set
CONFIG_XFRM_ESPINTCP=y
# CONFIG_SMC is not set
CONFIG_XDP_SOCKETS=y
CONFIG_XDP_SOCKETS_DIAG=m
CONFIG_NET_HANDSHAKE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
CONFIG_NET_FOU=m
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
CONFIG_INET_ESPINTCP=y
CONFIG_INET_IPCOMP=m
CONFIG_INET_TABLE_PERTURB_ORDER=16
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_INET_RAW_DIAG=y
CONFIG_INET_DIAG_DESTROY=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
CONFIG_TCP_CONG_NV=m
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_SIGPOOL=y
# CONFIG_TCP_AO is not set
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
CONFIG_INET6_ESPINTCP=y
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_FOU=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
CONFIG_IPV6_SEG6_HMAC=y
CONFIG_IPV6_SEG6_BPF=y
# CONFIG_IPV6_RPL_LWTUNNEL is not set
# CONFIG_IPV6_IOAM6_LWTUNNEL is not set
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=y
CONFIG_MPTCP_IPV6=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_EGRESS=y
CONFIG_NETFILTER_SKIP_EGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
CONFIG_NETFILTER_BPF_LINK=y
CONFIG_NETFILTER_NETLINK_HOOK=m
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_SYSLOG=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CONNTRACK_OVS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NF_NAT_OVS=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
CONFIG_NFT_FLOW_OFFLOAD=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
CONFIG_NFT_TUNNEL=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
CONFIG_NFT_XFRM=m
CONFIG_NFT_SOCKET=m
CONFIG_NFT_OSF=m
CONFIG_NFT_TPROXY=m
CONFIG_NFT_SYNPROXY=m
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
CONFIG_NFT_REJECT_NETDEV=m
CONFIG_NF_FLOW_TABLE_INET=m
CONFIG_NF_FLOW_TABLE=m
CONFIG_NF_FLOW_TABLE_PROCFS=y
CONFIG_NETFILTER_XTABLES=y
# CONFIG_NETFILTER_XTABLES_COMPAT is not set

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_MH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m
# CONFIG_IP_VS_TWOS is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_IP_NF_IPTABLES_LEGACY=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_NFT_COMPAT_ARP=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_IP6_NF_IPTABLES_LEGACY=m
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
CONFIG_NFT_BRIDGE_META=m
CONFIG_NFT_BRIDGE_REJECT=m
CONFIG_NF_CONNTRACK_BRIDGE=m
CONFIG_BRIDGE_NF_EBTABLES_LEGACY=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_MEDIA_IB=y
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=m
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_CBS=m
CONFIG_NET_SCH_ETF=m
CONFIG_NET_SCH_MQPRIO_LIB=m
CONFIG_NET_SCH_TAPRIO=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_CAKE=m
CONFIG_NET_SCH_FQ=m
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=m
# CONFIG_NET_SCH_PLUG is not set
CONFIG_NET_SCH_ETS=m
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_ACT_MPLS=m
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
# CONFIG_NET_ACT_CONNMARK is not set
CONFIG_NET_ACT_CTINFO=m
# CONFIG_NET_ACT_SKBMOD is not set
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
CONFIG_NET_ACT_CT=m
# CONFIG_NET_ACT_GATE is not set
CONFIG_NET_TC_SKB_EXT=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_OPENVSWITCH_GENEVE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=y
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
CONFIG_HSR=m
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
CONFIG_QRTR=m
# CONFIG_QRTR_TUN is not set
CONFIG_QRTR_MHI=m
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_MAX_SKB_FRAGS=17
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
CONFIG_CAN_J1939=m
CONFIG_CAN_ISOTP=m
CONFIG_BT=m
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m
CONFIG_BT_LE=y
CONFIG_BT_LE_L2CAP_ECRED=y
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_MSFTEXT is not set
# CONFIG_BT_AOSPEXT is not set
CONFIG_BT_DEBUGFS=y
# CONFIG_BT_SELFTEST is not set

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=m
CONFIG_BT_BCM=m
CONFIG_BT_RTL=m
CONFIG_BT_MTK=m
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTUSB_AUTOSUSPEND=y
CONFIG_BT_HCIBTUSB_POLL_SYNC=y
CONFIG_BT_HCIBTUSB_BCM=y
CONFIG_BT_HCIBTUSB_MTK=y
CONFIG_BT_HCIBTUSB_RTL=y
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
CONFIG_BT_HCIBCM203X=m
# CONFIG_BT_HCIBCM4377 is not set
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_BT_ATH3K=m
# CONFIG_BT_MTKSDIO is not set
# CONFIG_BT_VIRTIO is not set
# CONFIG_BT_INTEL_PCIE is not set
# end of Bluetooth device drivers

CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_IPV6=y
# CONFIG_AF_RXRPC_INJECT_LOSS is not set
# CONFIG_AF_RXRPC_INJECT_RX_DELAY is not set
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
# CONFIG_RXGK is not set
CONFIG_RXPERF=m
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
# CONFIG_MCTP is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
CONFIG_PAGE_POOL_STATS=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y

#
# Device Drivers
#
CONFIG_HAVE_PCI=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEAER_CXL=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
CONFIG_PCIE_PTM=y
CONFIG_PCIE_EDR=y
CONFIG_PCI_MSI=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
CONFIG_PCI_ATS=y
CONFIG_PCI_DOE=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_NPEM is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCIE_TPH is not set
CONFIG_PCI_P2PDMA=y
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=m
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_OCTEONEP is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y
CONFIG_PCI_HYPERV_INTERFACE=m

#
# Cadence-based PCIe controllers
#
# end of Cadence-based PCIe controllers

#
# DesignWare-based PCIe controllers
#
# CONFIG_PCI_MESON is not set
# CONFIG_PCIE_DW_PLAT_HOST is not set
# end of DesignWare-based PCIe controllers

#
# Mobiveil-based PCIe controllers
#
# end of Mobiveil-based PCIe controllers

#
# PLDA-based PCIe controllers
#
# end of PLDA-based PCIe controllers
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_PCI_PWRCTRL_SLOT is not set
CONFIG_CXL_BUS=m
CONFIG_CXL_PCI=m
# CONFIG_CXL_MEM_RAW_COMMANDS is not set
CONFIG_CXL_ACPI=m
CONFIG_CXL_PMEM=m
CONFIG_CXL_MEM=m
# CONFIG_CXL_FEATURES is not set
CONFIG_CXL_PORT=m
CONFIG_CXL_SUSPEND=y
CONFIG_CXL_REGION=y
# CONFIG_CXL_REGION_INVALIDATION_TEST is not set
CONFIG_CXL_MCE=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_DEVTMPFS_SAFE=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_DEBUG=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
CONFIG_FW_LOADER_COMPRESS=y
CONFIG_FW_LOADER_COMPRESS_XZ=y
CONFIG_FW_LOADER_COMPRESS_ZSTD=y
CONFIG_FW_CACHE=y
CONFIG_FW_UPLOAD=y
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
CONFIG_HMEM_REPORTING=y
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_DEVICES=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_REGMAP_IRQ=y
CONFIG_REGMAP_SOUNDWIRE=m
CONFIG_REGMAP_SOUNDWIRE_MBQ=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# CONFIG_FW_DEVLINK_SYNC_STATE_TIMEOUT is not set
# end of Generic Driver Options

#
# Bus devices
#
CONFIG_MHI_BUS=m
# CONFIG_MHI_BUS_DEBUG is not set
CONFIG_MHI_BUS_PCI_GENERIC=m
# CONFIG_MHI_BUS_EP is not set
# end of Bus devices

#
# Cache Drivers
#
# end of Cache Drivers

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
CONFIG_SYSFB=y
# CONFIG_SYSFB_SIMPLEFB is not set
CONFIG_FW_CS_DSP=m
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_SOFT_RESERVE=y
CONFIG_EFI_DXE_MEM_ATTRIBUTES=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
CONFIG_EFI_RCI2_TABLE=y
# CONFIG_EFI_DISABLE_PCI_DMA is not set
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y
# CONFIG_EFI_DISABLE_RUNTIME is not set
CONFIG_EFI_COCO_SECRET=y
CONFIG_UNACCEPTED_MEMORY=y
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y

#
# Qualcomm firmware drivers
#
# end of Qualcomm firmware drivers

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

# CONFIG_FWCTL is not set
CONFIG_GNSS=m
# CONFIG_GNSS_USB is not set
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set

#
# Partition parsers
#
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set

#
# Note that in some cases UBI block is preferred. See MTD_UBI_BLOCK.
#
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PLATRAM is not set
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_MCHP23K256 is not set
# CONFIG_MTD_MCHP48L640 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# end of Self-contained MTD device drivers

#
# NAND
#
# CONFIG_MTD_ONENAND is not set
# CONFIG_MTD_RAW_NAND is not set
# CONFIG_MTD_SPI_NAND is not set

#
# ECC engine support
#
# CONFIG_MTD_NAND_ECC_SW_HAMMING is not set
# CONFIG_MTD_NAND_ECC_SW_BCH is not set
# CONFIG_MTD_NAND_ECC_MXIC is not set
# end of ECC engine support
# end of NAND

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# end of LPDDR & LPDDR2 PCM memory drivers

# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_MTD_UBI_NVMEM is not set
# CONFIG_MTD_HYPERBUS is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=m
# CONFIG_ZRAM_BACKEND_LZ4 is not set
# CONFIG_ZRAM_BACKEND_LZ4HC is not set
# CONFIG_ZRAM_BACKEND_ZSTD is not set
# CONFIG_ZRAM_BACKEND_DEFLATE is not set
# CONFIG_ZRAM_BACKEND_842 is not set
CONFIG_ZRAM_BACKEND_FORCE_LZO=y
CONFIG_ZRAM_BACKEND_LZO=y
CONFIG_ZRAM_DEF_COMP_LZORLE=y
# CONFIG_ZRAM_DEF_COMP_LZO is not set
CONFIG_ZRAM_DEF_COMP="lzo-rle"
CONFIG_ZRAM_WRITEBACK=y
# CONFIG_ZRAM_TRACK_ENTRY_ACTIME is not set
# CONFIG_ZRAM_MEMORY_TRACKING is not set
# CONFIG_ZRAM_MULTI_COMP is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_UBLK is not set
# CONFIG_BLK_DEV_ZONED_LOOP is not set

#
# NVME Support
#
CONFIG_NVME_AUTH=m
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
CONFIG_NVME_VERBOSE_ERRORS=y
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
CONFIG_NVME_RDMA=m
CONFIG_NVME_FC=m
CONFIG_NVME_TCP=m
# CONFIG_NVME_TCP_TLS is not set
# CONFIG_NVME_HOST_AUTH is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_DEBUGFS is not set
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
CONFIG_NVME_TARGET_RDMA=m
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
CONFIG_NVME_TARGET_TCP=m
# CONFIG_NVME_TARGET_TCP_TLS is not set
CONFIG_NVME_TARGET_AUTH=y
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_RPMB is not set
# CONFIG_TI_FPC202 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
# CONFIG_NTSYNC is not set
# CONFIG_NSM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_INTEL_MEI_GSC=m
# CONFIG_INTEL_MEI_VSC_HW is not set
# CONFIG_INTEL_MEI_HDCP is not set
# CONFIG_INTEL_MEI_PXP is not set
CONFIG_INTEL_MEI_GSC_PROXY=m
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
CONFIG_MISC_RTSX_USB=m
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
CONFIG_PVPANIC_MMIO=m
# CONFIG_PVPANIC_PCI is not set
# CONFIG_GP_PCI1XXXX is not set
# CONFIG_KEBA_CP500 is not set
# CONFIG_AMD_SBRMI_I2C is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_BLK_DEV_BSG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
# CONFIG_SCSI_CXGB3_ISCSI is not set
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=m
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPI3MR=m
CONFIG_SCSI_SMARTPQI=m
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
CONFIG_VMWARE_PVSCSI=m
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=m
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_QEDI=m
CONFIG_QEDF=m
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
# CONFIG_SCSI_EFCT is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
CONFIG_SCSI_CHELSIO_FCOE=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_AHCI_DWC is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_PARPORT is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_BITMAP_FILE=y
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_CLUSTER is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_MULTIPATH_HST=m
CONFIG_DM_MULTIPATH_IOA=m
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG=y
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING is not set
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING is not set
CONFIG_DM_VERITY_FEC=y
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
# CONFIG_DM_ZONED is not set
CONFIG_DM_AUDIT=y
# CONFIG_DM_VDO is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
CONFIG_ISCSI_TARGET_CXGB4=m
# CONFIG_REMOTE_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
CONFIG_WIREGUARD=m
# CONFIG_WIREGUARD_DEBUG is not set
# CONFIG_OVPN is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_IPVLAN_L3S=y
CONFIG_IPVLAN=m
CONFIG_IPVTAP=m
CONFIG_VXLAN=m
CONFIG_GENEVE=m
CONFIG_BAREUDP=m
# CONFIG_GTP is not set
# CONFIG_PFCP is not set
# CONFIG_AMT is not set
CONFIG_MACSEC=m
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
# CONFIG_NETCONSOLE_EXTENDED_LOG is not set
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_NTB_NETDEV=m
CONFIG_TUN=m
CONFIG_TAP=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
CONFIG_NLMON=m
# CONFIG_NETKIT is not set
CONFIG_NET_VRF=m
CONFIG_VSOCKMON=m
CONFIG_MHI_NET=m
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=m
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_AGERE is not set
# CONFIG_NET_VENDOR_ALACRITECH is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
CONFIG_ENA_ETHERNET=m
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_AMD_XGBE=m
# CONFIG_AMD_XGBE_DCB is not set
CONFIG_AMD_XGBE_HAVE_ECC=y
# CONFIG_PDS_CORE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
CONFIG_AQTION=m
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ASIX=y
# CONFIG_SPI_AX88796C is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=m
# CONFIG_CX_ECAT is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BCMGENET=m
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=m
CONFIG_TIGON3_HWMON=y
CONFIG_BNX2X=m
CONFIG_BNX2X_SRIOV=y
# CONFIG_SYSTEMPORT is not set
CONFIG_BNXT=m
CONFIG_BNXT_SRIOV=y
CONFIG_BNXT_FLOWER_OFFLOAD=y
CONFIG_BNXT_DCB=y
# CONFIG_BNXT_HWMON is not set
# CONFIG_NET_VENDOR_CADENCE is not set
# CONFIG_NET_VENDOR_CAVIUM is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
CONFIG_CHELSIO_T4=m
# CONFIG_CHELSIO_T4_DCB is not set
CONFIG_CHELSIO_T4VF=m
CONFIG_CHELSIO_LIB=m
CONFIG_CHELSIO_INLINE_CRYPTO=y
CONFIG_CHELSIO_IPSEC_INLINE=m
CONFIG_CHELSIO_TLS_DEVICE=m
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
# CONFIG_NET_VENDOR_CORTINA is not set
CONFIG_NET_VENDOR_DAVICOM=y
# CONFIG_DM9051 is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=m
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_BE2NET_HWMON=y
# CONFIG_BE2NET_BE2 is not set
# CONFIG_BE2NET_BE3 is not set
CONFIG_BE2NET_LANCER=y
CONFIG_BE2NET_SKYHAWK=y
CONFIG_NET_VENDOR_ENGLEDER=y
# CONFIG_TSNEP is not set
# CONFIG_NET_VENDOR_EZCHIP is not set
CONFIG_NET_VENDOR_FUNGIBLE=y
# CONFIG_FUN_ETH is not set
CONFIG_NET_VENDOR_GOOGLE=y
CONFIG_GVE=m
CONFIG_NET_VENDOR_HISILICON=y
# CONFIG_HIBMCGE is not set
CONFIG_NET_VENDOR_HUAWEI=y
CONFIG_HINIC=m
# CONFIG_HINIC3 is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_LIBETH=y
CONFIG_LIBIE=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=m
CONFIG_IXGBE=m
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCA=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBE_IPSEC=y
CONFIG_IXGBEVF=m
CONFIG_IXGBEVF_IPSEC=y
CONFIG_I40E=y
CONFIG_I40E_DCB=y
CONFIG_IAVF=m
CONFIG_I40EVF=m
CONFIG_ICE=m
CONFIG_ICE_HWMON=y
CONFIG_ICE_SWITCHDEV=y
CONFIG_ICE_HWTS=y
CONFIG_FM10K=m
CONFIG_IGC=y
CONFIG_IDPF=m
# CONFIG_IDPF_SINGLEQ is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_ADI=y
# CONFIG_ADIN1110 is not set
CONFIG_NET_VENDOR_LITEX=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_OCTEON_EP=m
# CONFIG_OCTEON_EP_VF is not set
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
# CONFIG_MLX4_CORE_GEN2 is not set
CONFIG_MLX5_CORE=m
CONFIG_MLX5_FPGA=y
CONFIG_MLX5_CORE_EN=y
CONFIG_MLX5_EN_ARFS=y
CONFIG_MLX5_EN_RXNFC=y
CONFIG_MLX5_MPFS=y
CONFIG_MLX5_ESWITCH=y
CONFIG_MLX5_BRIDGE=y
CONFIG_MLX5_CLS_ACT=y
CONFIG_MLX5_TC_CT=y
CONFIG_MLX5_TC_SAMPLE=y
CONFIG_MLX5_CORE_EN_DCB=y
CONFIG_MLX5_CORE_IPOIB=y
# CONFIG_MLX5_MACSEC is not set
CONFIG_MLX5_EN_IPSEC=y
CONFIG_MLX5_EN_TLS=y
CONFIG_MLX5_SW_STEERING=y
CONFIG_MLX5_HW_STEERING=y
CONFIG_MLX5_SF=y
CONFIG_MLX5_SF_MANAGER=y
# CONFIG_MLX5_DPLL is not set
CONFIG_MLXSW_CORE=m
CONFIG_MLXSW_CORE_HWMON=y
CONFIG_MLXSW_CORE_THERMAL=y
CONFIG_MLXSW_PCI=m
CONFIG_MLXSW_I2C=m
CONFIG_MLXSW_SPECTRUM=m
CONFIG_MLXSW_SPECTRUM_DCB=y
CONFIG_MLXSW_MINIMAL=m
CONFIG_MLXFW=m
CONFIG_NET_VENDOR_META=y
# CONFIG_FBNIC is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MICROSEMI is not set
CONFIG_NET_VENDOR_MICROSOFT=y
CONFIG_MICROSOFT_MANA=m
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NI is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NETERION is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NFP=m
CONFIG_NFP_APP_FLOWER=y
CONFIG_NFP_APP_ABM_NIC=y
CONFIG_NFP_NET_IPSEC=y
# CONFIG_NFP_DEBUG is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
# CONFIG_NET_VENDOR_PACKET_ENGINES is not set
CONFIG_NET_VENDOR_PENSANDO=y
CONFIG_IONIC=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
# CONFIG_QLCNIC is not set
CONFIG_NETXEN_NIC=m
CONFIG_QED=m
CONFIG_QED_LL2=y
CONFIG_QED_SRIOV=y
CONFIG_QEDE=m
CONFIG_QED_RDMA=y
CONFIG_QED_ISCSI=y
CONFIG_QED_FCOE=y
CONFIG_QED_OOO=y
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_VENDOR_QUALCOMM is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
# CONFIG_RTASE is not set
# CONFIG_NET_VENDOR_RENESAS is not set
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_ROCKER=m
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_SFC_MCDI_LOGGING=y
# CONFIG_SFC_FALCON is not set
CONFIG_SFC_SIENA=m
CONFIG_SFC_SIENA_MTD=y
CONFIG_SFC_SIENA_MCDI_MON=y
CONFIG_SFC_SIENA_SRIOV=y
CONFIG_SFC_SIENA_MCDI_LOGGING=y
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_SOCIONEXT is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=m
# CONFIG_STMMAC_SELFTESTS is not set
# CONFIG_STMMAC_PLATFORM is not set
CONFIG_DWMAC_INTEL=m
# CONFIG_STMMAC_PCI is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_SYNOPSYS is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
CONFIG_NET_VENDOR_VERTEXCOM=y
# CONFIG_MSE102X is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WANGXUN=y
# CONFIG_NGBE is not set
# CONFIG_TXGBE is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_NET_VENDOR_XILINX is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PHYLINK=y
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
CONFIG_LED_TRIGGER_PHY=y
CONFIG_FIXED_PHY=y
# CONFIG_SFP is not set

#
# MII PHY device drivers
#
# CONFIG_AS21XXX_PHY is not set
# CONFIG_AIR_EN8811H_PHY is not set
CONFIG_AMD_PHY=m
# CONFIG_ADIN_PHY is not set
# CONFIG_ADIN1100_PHY is not set
CONFIG_AQUANTIA_PHY=m
CONFIG_AX88796B_PHY=y
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM54140_PHY is not set
CONFIG_BCM7XXX_PHY=m
# CONFIG_BCM84881_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_BCM_NET_PHYLIB=m
CONFIG_BCM_NET_PHYPTP=m
CONFIG_CICADA_PHY=m
CONFIG_CORTINA_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_LXT_PHY=m
CONFIG_INTEL_XWAY_PHY=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MARVELL_PHY=m
CONFIG_MARVELL_10G_PHY=m
CONFIG_MARVELL_88Q2XXX_PHY=m
# CONFIG_MARVELL_88X2222_PHY is not set
CONFIG_MAXLINEAR_GPHY=m
# CONFIG_MAXLINEAR_86110_PHY is not set
# CONFIG_MEDIATEK_GE_PHY is not set
CONFIG_MICREL_PHY=m
# CONFIG_MICROCHIP_T1S_PHY is not set
CONFIG_MICROCHIP_PHY=m
CONFIG_MICROCHIP_T1_PHY=m
CONFIG_MICROCHIP_PHY_RDS_PTP=m
CONFIG_MICROSEMI_PHY=m
# CONFIG_MOTORCOMM_PHY is not set
CONFIG_NATIONAL_PHY=m
# CONFIG_NXP_CBTX_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_NCN26000_PHY is not set
# CONFIG_QCA83XX_PHY is not set
# CONFIG_QCA808X_PHY is not set
CONFIG_QSEMI_PHY=m
CONFIG_REALTEK_PHY=y
# CONFIG_REALTEK_PHY_HWMON is not set
CONFIG_RENESAS_PHY=m
CONFIG_ROCKCHIP_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_STE10XP=m
CONFIG_TERANETICS_PHY=m
CONFIG_DP83822_PHY=m
CONFIG_DP83TC811_PHY=m
CONFIG_DP83848_PHY=m
CONFIG_DP83867_PHY=m
# CONFIG_DP83869_PHY is not set
# CONFIG_DP83TD510_PHY is not set
# CONFIG_DP83TG720_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_XILINX_GMII2RGMII=m
CONFIG_MICREL_KS8995MA=m
CONFIG_CAN_DEV=m
CONFIG_CAN_VCAN=m
CONFIG_CAN_VXCAN=m
CONFIG_CAN_NETLINK=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_RX_OFFLOAD=y
# CONFIG_CAN_CAN327 is not set
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_SLCAN=m
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set
# CONFIG_CAN_CTUCANFD_PCI is not set
# CONFIG_CAN_ESD_402_PCI is not set
# CONFIG_CAN_IFI_CANFD is not set
CONFIG_CAN_M_CAN=m
CONFIG_CAN_M_CAN_PCI=m
# CONFIG_CAN_M_CAN_PLATFORM is not set
# CONFIG_CAN_M_CAN_TCAN4X5X is not set
CONFIG_CAN_PEAK_PCIEFD=m
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_SOFTING is not set

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
CONFIG_CAN_MCP251X=m
CONFIG_CAN_MCP251XFD=m
# CONFIG_CAN_MCP251XFD_SANITY is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
CONFIG_CAN_8DEV_USB=m
CONFIG_CAN_EMS_USB=m
# CONFIG_CAN_ESD_USB is not set
# CONFIG_CAN_ETAS_ES58X is not set
# CONFIG_CAN_F81604 is not set
# CONFIG_CAN_GS_USB is not set
CONFIG_CAN_KVASER_USB=m
# CONFIG_CAN_MCBA_USB is not set
CONFIG_CAN_PEAK_USB=m
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_MDIO_BUS=y
CONFIG_FWNODE_MDIO=y
CONFIG_ACPI_MDIO=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_BCM_UNIMAC=m
CONFIG_MDIO_CAVIUM=m
# CONFIG_MDIO_GPIO is not set
# CONFIG_MDIO_MVUSB is not set
CONFIG_MDIO_THUNDER=m

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
CONFIG_PCS_XPCS=m
# end of PCS device drivers

# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
# CONFIG_PPPOE_HASH_BITS_1 is not set
# CONFIG_PPPOE_HASH_BITS_2 is not set
CONFIG_PPPOE_HASH_BITS_4=y
# CONFIG_PPPOE_HASH_BITS_8 is not set
CONFIG_PPPOE_HASH_BITS=4
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_RTL8152=m
CONFIG_USB_LAN78XX=m
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_HUAWEI_CDC_NCM=m
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET_ENABLE=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
CONFIG_USB_VL600=m
CONFIG_USB_NET_CH9200=m
# CONFIG_USB_NET_AQC111 is not set
CONFIG_USB_RTL8153_ECM=m
CONFIG_WLAN=y
# CONFIG_WLAN_VENDOR_ADMTEK is not set
CONFIG_ATH_COMMON=m
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K=m
CONFIG_ATH9K_PCI=y
CONFIG_ATH9K_AHB=y
# CONFIG_ATH9K_DYNACK is not set
CONFIG_ATH9K_WOW=y
CONFIG_ATH9K_RFKILL=y
# CONFIG_ATH9K_CHANNEL_CONTEXT is not set
CONFIG_ATH9K_PCOEM=y
# CONFIG_ATH9K_PCI_NO_EEPROM is not set
CONFIG_ATH9K_HTC=m
# CONFIG_ATH9K_HTC_DEBUGFS is not set
# CONFIG_ATH9K_HWRNG is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
CONFIG_ATH10K=m
CONFIG_ATH10K_CE=y
CONFIG_ATH10K_PCI=m
# CONFIG_ATH10K_SDIO is not set
# CONFIG_ATH10K_USB is not set
# CONFIG_ATH10K_DEBUG is not set
CONFIG_ATH10K_DEBUGFS=y
CONFIG_ATH10K_LEDS=y
# CONFIG_ATH10K_SPECTRAL is not set
# CONFIG_ATH10K_TRACING is not set
# CONFIG_WCN36XX is not set
CONFIG_ATH11K=m
CONFIG_ATH11K_PCI=m
# CONFIG_ATH11K_DEBUG is not set
# CONFIG_ATH11K_TRACING is not set
# CONFIG_ATH12K is not set
# CONFIG_WLAN_VENDOR_ATMEL is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMSMAC=m
CONFIG_BRCMSMAC_LEDS=y
CONFIG_BRCMFMAC=m
CONFIG_BRCMFMAC_PROTO_BCDC=y
CONFIG_BRCMFMAC_PROTO_MSGBUF=y
CONFIG_BRCMFMAC_SDIO=y
CONFIG_BRCMFMAC_USB=y
CONFIG_BRCMFMAC_PCIE=y
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m
# CONFIG_IWLMLD is not set
CONFIG_IWLWIFI_OPMODE_MODULAR=y

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
# end of Debugging Options

# CONFIG_WLAN_VENDOR_INTERSIL is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
CONFIG_MWIFIEX_PCIE=m
CONFIG_MWIFIEX_USB=m
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
CONFIG_MT7601U=m
CONFIG_MT76_CORE=m
CONFIG_MT76_LEDS=y
CONFIG_MT76_USB=m
CONFIG_MT76x02_LIB=m
CONFIG_MT76x02_USB=m
CONFIG_MT76_CONNAC_LIB=m
CONFIG_MT792x_LIB=m
CONFIG_MT76x0_COMMON=m
CONFIG_MT76x0U=m
CONFIG_MT76x0E=m
CONFIG_MT76x2_COMMON=m
CONFIG_MT76x2E=m
CONFIG_MT76x2U=m
# CONFIG_MT7603E is not set
# CONFIG_MT7615E is not set
# CONFIG_MT7663U is not set
# CONFIG_MT7663S is not set
# CONFIG_MT7915E is not set
CONFIG_MT7921_COMMON=m
CONFIG_MT7921E=m
# CONFIG_MT7921S is not set
# CONFIG_MT7921U is not set
# CONFIG_MT7996E is not set
CONFIG_MT7925_COMMON=m
CONFIG_MT7925E=m
# CONFIG_MT7925U is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_PURELIFI=y
# CONFIG_PLFXLC is not set
CONFIG_WLAN_VENDOR_RALINK=y
CONFIG_RT2X00=m
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
CONFIG_RT2800PCI=m
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
CONFIG_RT2800PCI_RT53XX=y
CONFIG_RT2800PCI_RT3290=y
# CONFIG_RT2500USB is not set
# CONFIG_RT73USB is not set
CONFIG_RT2800USB=m
CONFIG_RT2800USB_RT33XX=y
CONFIG_RT2800USB_RT35XX=y
CONFIG_RT2800USB_RT3573=y
CONFIG_RT2800USB_RT53XX=y
CONFIG_RT2800USB_RT55XX=y
CONFIG_RT2800USB_UNKNOWN=y
CONFIG_RT2800_LIB=m
CONFIG_RT2800_LIB_MMIO=m
CONFIG_RT2X00_LIB_MMIO=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
CONFIG_RTL8192CE=m
CONFIG_RTL8192SE=m
CONFIG_RTL8192DE=m
CONFIG_RTL8723AE=m
CONFIG_RTL8723BE=m
CONFIG_RTL8188EE=m
CONFIG_RTL8192EE=m
CONFIG_RTL8821AE=m
CONFIG_RTL8192CU=m
# CONFIG_RTL8192DU is not set
CONFIG_RTLWIFI=m
CONFIG_RTLWIFI_PCI=m
CONFIG_RTLWIFI_USB=m
# CONFIG_RTLWIFI_DEBUG is not set
CONFIG_RTL8192C_COMMON=m
CONFIG_RTL8192D_COMMON=m
CONFIG_RTL8723_COMMON=m
CONFIG_RTLBTCOEXIST=m
CONFIG_RTL8XXXU=m
# CONFIG_RTL8XXXU_UNTESTED is not set
CONFIG_RTW88=m
CONFIG_RTW88_CORE=m
CONFIG_RTW88_PCI=m
CONFIG_RTW88_8822B=m
CONFIG_RTW88_8822C=m
CONFIG_RTW88_8723X=m
CONFIG_RTW88_8723D=m
CONFIG_RTW88_8821C=m
CONFIG_RTW88_8822BE=m
# CONFIG_RTW88_8822BS is not set
# CONFIG_RTW88_8822BU is not set
CONFIG_RTW88_8822CE=m
# CONFIG_RTW88_8822CS is not set
# CONFIG_RTW88_8822CU is not set
CONFIG_RTW88_8723DE=m
# CONFIG_RTW88_8723DS is not set
# CONFIG_RTW88_8723CS is not set
# CONFIG_RTW88_8723DU is not set
CONFIG_RTW88_8821CE=m
# CONFIG_RTW88_8821CS is not set
# CONFIG_RTW88_8821CU is not set
# CONFIG_RTW88_8821AU is not set
# CONFIG_RTW88_8812AU is not set
# CONFIG_RTW88_8814AE is not set
# CONFIG_RTW88_8814AU is not set
# CONFIG_RTW88_DEBUG is not set
# CONFIG_RTW88_DEBUGFS is not set
CONFIG_RTW88_LEDS=y
CONFIG_RTW89=m
CONFIG_RTW89_CORE=m
CONFIG_RTW89_PCI=m
CONFIG_RTW89_8852A=m
CONFIG_RTW89_8852B_COMMON=m
CONFIG_RTW89_8852B=m
CONFIG_RTW89_8852C=m
# CONFIG_RTW89_8851BE is not set
CONFIG_RTW89_8852AE=m
CONFIG_RTW89_8852BE=m
# CONFIG_RTW89_8852BTE is not set
CONFIG_RTW89_8852CE=m
# CONFIG_RTW89_8922AE is not set
# CONFIG_RTW89_DEBUGMSG is not set
# CONFIG_WLAN_VENDOR_RSI is not set
CONFIG_WLAN_VENDOR_SILABS=y
# CONFIG_WFX is not set
# CONFIG_WLAN_VENDOR_ST is not set
# CONFIG_WLAN_VENDOR_TI is not set
# CONFIG_WLAN_VENDOR_ZYDAS is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_VIRT_WIFI is not set
CONFIG_WAN=y
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_FRAMER is not set
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKELB=m
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set

#
# Wireless WAN
#
CONFIG_WWAN=y
CONFIG_WWAN_DEBUGFS=y
CONFIG_WWAN_HWSIM=m
CONFIG_MHI_WWAN_CTRL=m
CONFIG_MHI_WWAN_MBIM=m
CONFIG_IOSM=m
CONFIG_MTK_T7XX=m
# end of Wireless WAN

CONFIG_XEN_NETDEV_FRONTEND=m
CONFIG_VMXNET3=m
CONFIG_FUJITSU_ES=m
CONFIG_USB4_NET=m
CONFIG_HYPERV_NET=m
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CYPRESS_SF is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
# CONFIG_TABLET_USB_PEGASUS is not set
CONFIG_TABLET_SERIAL_WACOM4=m
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ADC is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_BU21029 is not set
# CONFIG_TOUCHSCREEN_CHIPONE_ICN8505 is not set
# CONFIG_TOUCHSCREEN_CY8CTMA140 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP5 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
# CONFIG_TOUCHSCREEN_EXC3000 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
# CONFIG_TOUCHSCREEN_GOODIX_BERLIN_I2C is not set
# CONFIG_TOUCHSCREEN_GOODIX_BERLIN_SPI is not set
# CONFIG_TOUCHSCREEN_HIDEEP is not set
# CONFIG_TOUCHSCREEN_HYCON_HY46XX is not set
# CONFIG_TOUCHSCREEN_HYNITRON_CSTXXX is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_ILITEK is not set
# CONFIG_TOUCHSCREEN_S6SY761 is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
# CONFIG_TOUCHSCREEN_MSG2638 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_NOVATEK_NVT_TS is not set
# CONFIG_TOUCHSCREEN_IMAGIS is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2004 is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
# CONFIG_TOUCHSCREEN_SIS_I2C is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMFTS is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_SURFACE3_SPI is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZET6223 is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_TOUCHSCREEN_COLIBRI_VF50 is not set
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
# CONFIG_TOUCHSCREEN_IQS5XX is not set
# CONFIG_TOUCHSCREEN_IQS7211 is not set
# CONFIG_TOUCHSCREEN_ZINITIX is not set
# CONFIG_TOUCHSCREEN_HIMAX_HX83112B is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_DECODER is not set
# CONFIG_INPUT_GPIO_VIBRA is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_PWM_VIBRA is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
# CONFIG_INPUT_DA7280_HAPTICS is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_IQS269A is not set
# CONFIG_INPUT_IQS626A is not set
# CONFIG_INPUT_IQS7222 is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
CONFIG_RMI4_F3A=y
# CONFIG_RMI4_F54 is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LEGACY_TIOCSTI=y
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCILIB=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_PCI1XXXX is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=m
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y
# CONFIG_SERIAL_8250_NI is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TPM2_HMAC=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_SPI=y
# CONFIG_TCG_TIS_SPI_CR50 is not set
# CONFIG_TCG_TIS_I2C is not set
# CONFIG_TCG_TIS_I2C_CR50 is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=m
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
CONFIG_TCG_VTPM_PROXY=m
# CONFIG_TCG_SVSM is not set
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# CONFIG_XILLYUSB is not set
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_AMD_MP2 is not set
# CONFIG_I2C_AMD_ASF is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m
# CONFIG_I2C_ZHAOXIN is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_AMDPSP is not set
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
# CONFIG_I2C_CP2615 is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_PCI1XXXX is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# CONFIG_I2C_VIRTIO is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_CH341 is not set
CONFIG_SPI_CS42L43=m
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_MICROCHIP_CORE is not set
# CONFIG_SPI_MICROCHIP_CORE_QSPI is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PCI1XXXX is not set
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m
# CONFIG_PPS_GENERATOR is not set

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_PTP_1588_CLOCK_OPTIONAL=y
CONFIG_DP83640_PHY=m
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
CONFIG_PTP_1588_CLOCK_VMCLOCK=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_FC3W is not set
# CONFIG_PTP_1588_CLOCK_MOCK is not set
CONFIG_PTP_1588_CLOCK_VMW=m
# CONFIG_PTP_1588_CLOCK_OCP is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=y
# CONFIG_PINCTRL_CY8C95X0 is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_CS42L43=m

#
# Intel pinctrl drivers
#
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
CONFIG_PINCTRL_INTEL=y
# CONFIG_PINCTRL_INTEL_PLATFORM is not set
CONFIG_PINCTRL_ALDERLAKE=m
CONFIG_PINCTRL_BROXTON=m
CONFIG_PINCTRL_CANNONLAKE=m
CONFIG_PINCTRL_CEDARFORK=m
CONFIG_PINCTRL_DENVERTON=m
CONFIG_PINCTRL_ELKHARTLAKE=m
CONFIG_PINCTRL_EMMITSBURG=m
CONFIG_PINCTRL_GEMINILAKE=m
CONFIG_PINCTRL_ICELAKE=m
CONFIG_PINCTRL_JASPERLAKE=m
CONFIG_PINCTRL_LAKEFIELD=m
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_METEORLAKE=m
# CONFIG_PINCTRL_METEORPOINT is not set
CONFIG_PINCTRL_SUNRISEPOINT=m
CONFIG_PINCTRL_TIGERLAKE=m
# end of Intel pinctrl drivers

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_SWNODE_UNDEFINED=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_ALTERA is not set
CONFIG_GPIO_AMDPT=m
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_GRANITERAPIDS is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_POLARFIRE_SOC is not set
# CONFIG_GPIO_XILINX is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_FXL6408 is not set
# CONFIG_GPIO_DS4520 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# CONFIG_GPIO_ELKHARTLAKE is not set
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_74X164 is not set
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# CONFIG_GPIO_MPSSE is not set
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
# CONFIG_GPIO_LATCH is not set
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_GPIO_VIRTIO is not set
# CONFIG_GPIO_SIM is not set
# end of Virtual GPIO drivers

#
# GPIO Debugging utilities
#
# CONFIG_GPIO_SLOPPY_LOGIC_ANALYZER is not set
# CONFIG_GPIO_VIRTUSER is not set
# end of GPIO Debugging utilities

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
# CONFIG_POWER_RESET_TORADEX_EC is not set
# CONFIG_POWER_SEQUENCING is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_IP5XXX_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CHAGALL is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SAMSUNG_SDI is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_BATTERY_MAX1720X is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_MAX77976 is not set
# CONFIG_CHARGER_MAX8971 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_FUEL_GAUGE_STC3117 is not set
# CONFIG_CHARGER_BD99954 is not set
# CONFIG_BATTERY_UG3105 is not set
# CONFIG_FUEL_GAUGE_MM8013 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AQUACOMPUTER_D5NEXT is not set
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_ASUS_ROG_RYUJIN is not set
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CHIPCAP2 is not set
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
# CONFIG_I8K is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
# CONFIG_SENSORS_GIGABYTE_WATERFORCE is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HS3001 is not set
# CONFIG_SENSORS_HTU31 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_ISL28022 is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWERZ is not set
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LENOVO_EC is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC2991 is not set
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LTC4282 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX31760 is not set
# CONFIG_MAX31827 is not set
# CONFIG_SENSORS_MAX6620 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
# CONFIG_SENSORS_MC34VR500 is not set
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_MLXREG_FAN=m
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_TPS23861 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775_CORE=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT6775_I2C is not set
# CONFIG_SENSORS_NCT7363 is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
# CONFIG_SENSORS_NZXT_KRAKEN3 is not set
# CONFIG_SENSORS_NZXT_SMART2 is not set
# CONFIG_SENSORS_OCC_P8_I2C is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ACBEL_FSG032 is not set
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_ADP1050 is not set
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_CRPS is not set
# CONFIG_SENSORS_DELTA_AHE50DC_FAN is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_DPS920AB is not set
# CONFIG_SENSORS_INA233 is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR36021 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LT3074 is not set
# CONFIG_SENSORS_LT7182S is not set
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_LTC4286 is not set
# CONFIG_SENSORS_MAX15301 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2856 is not set
# CONFIG_SENSORS_MP2888 is not set
# CONFIG_SENSORS_MP2891 is not set
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_MP2993 is not set
# CONFIG_SENSORS_MP5023 is not set
# CONFIG_SENSORS_MP5920 is not set
# CONFIG_SENSORS_MP5990 is not set
# CONFIG_SENSORS_MP9941 is not set
# CONFIG_SENSORS_MPQ7932 is not set
# CONFIG_SENSORS_MPQ8785 is not set
# CONFIG_SENSORS_PIM4328 is not set
# CONFIG_SENSORS_PLI1209BC is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TDA38640 is not set
# CONFIG_SENSORS_TPS25990 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
# CONFIG_SENSORS_TPS546D24 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDP710 is not set
# CONFIG_SENSORS_XDPE152 is not set
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_PT5161L is not set
# CONFIG_SENSORS_PWM_FAN is not set
# CONFIG_SENSORS_SBTSI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC2305 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA238 is not set
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_SPD5118 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP464 is not set
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
# CONFIG_SENSORS_ASUS_WMI is not set
# CONFIG_SENSORS_ASUS_EC is not set
# CONFIG_SENSORS_HP_WMI is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_NETLINK=y
# CONFIG_THERMAL_STATISTICS is not set
# CONFIG_THERMAL_DEBUGFS is not set
# CONFIG_THERMAL_CORE_TESTING is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_PCIE_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_INTEL_TCC=y
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=m
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
CONFIG_INTEL_HFI_THERMAL=y
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y
# CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT is not set

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_LENOVO_SE10_WDT is not set
# CONFIG_LENOVO_SE30_WDT is not set
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
CONFIG_MLX_WDT=m
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ADVANTECH_EC_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_EBC_C384_WDT is not set
# CONFIG_EXAR_WDT is not set
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=m
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
# CONFIG_INTEL_OC_WATCHDOG is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
# CONFIG_XEN_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_MFD_SMPRO is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_CGBC is not set
CONFIG_MFD_CS42L43=m
# CONFIG_MFD_CS42L43_I2C is not set
CONFIG_MFD_CS42L43_SDW=m
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
CONFIG_MFD_INTEL_LPSS=m
CONFIG_MFD_INTEL_LPSS_ACPI=m
CONFIG_MFD_INTEL_LPSS_PCI=m
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77541 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77705 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6370 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_MFD_OCELOT is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_SY7636A is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RT5120 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS6594_I2C is not set
# CONFIG_MFD_TPS6594_SPI is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_ATC260X_I2C is not set
# CONFIG_MFD_CS40L50_I2C is not set
# CONFIG_MFD_CS40L50_SPI is not set
# CONFIG_MFD_INTEL_M10_BMC_SPI is not set
# CONFIG_MFD_UPBOARD_FPGA is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
# CONFIG_RC_CORE is not set
CONFIG_CEC_CORE=m
CONFIG_CEC_NOTIFIER=y

#
# CEC support
#
CONFIG_MEDIA_CEC_SUPPORT=y
# CONFIG_CEC_CH7322 is not set
# CONFIG_CEC_NXP_TDA9950 is not set
# CONFIG_CEC_GPIO is not set
# CONFIG_CEC_SECO is not set
# CONFIG_USB_EXTRON_DA_HD_4K_PLUS_CEC is not set
CONFIG_USB_PULSE8_CEC=m
CONFIG_USB_RAINSHADOW_CEC=m
# end of CEC support

CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_SUPPORT_FILTER=y
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media device types
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_PLATFORM_SUPPORT is not set
# CONFIG_MEDIA_TEST_SUPPORT is not set
# end of Media device types

CONFIG_VIDEO_DEV=m
CONFIG_MEDIA_CONTROLLER=y

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_FWNODE=m
CONFIG_V4L2_ASYNC=m
# end of Video4Linux options

#
# Media controller options
#
# end of Media controller options

#
# Media drivers
#

#
# Drivers filtered as selected at 'Filter media drivers'
#

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_GSPCA=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
# CONFIG_USB_GSPCA_KINECT is not set
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
# CONFIG_USB_GSPCA_TOUPTEK is not set
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_GL860=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_USB_S2255=m
# CONFIG_VIDEO_USBTV is not set
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_VIDEO_EM28XX is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
# CONFIG_VIDEO_MGB4 is not set
# CONFIG_VIDEO_SOLO6X10 is not set
# CONFIG_VIDEO_TW5864 is not set
# CONFIG_VIDEO_TW68 is not set
# CONFIG_VIDEO_TW686X is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_IPU3_CIO2 is not set
# CONFIG_VIDEO_INTEL_IPU6 is not set
# CONFIG_INTEL_VSC is not set
# CONFIG_IPU_BRIDGE is not set
CONFIG_UVC_COMMON=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# end of Media drivers

#
# Media ancillary drivers
#
CONFIG_VIDEO_CAMERA_SENSOR=y
# CONFIG_VIDEO_ALVIUM_CSI2 is not set
# CONFIG_VIDEO_AR0521 is not set
# CONFIG_VIDEO_GC0308 is not set
# CONFIG_VIDEO_GC05A2 is not set
# CONFIG_VIDEO_GC08A3 is not set
# CONFIG_VIDEO_GC2145 is not set
# CONFIG_VIDEO_HI556 is not set
# CONFIG_VIDEO_HI846 is not set
# CONFIG_VIDEO_HI847 is not set
# CONFIG_VIDEO_IMX208 is not set
# CONFIG_VIDEO_IMX214 is not set
# CONFIG_VIDEO_IMX219 is not set
# CONFIG_VIDEO_IMX258 is not set
# CONFIG_VIDEO_IMX274 is not set
# CONFIG_VIDEO_IMX283 is not set
# CONFIG_VIDEO_IMX290 is not set
# CONFIG_VIDEO_IMX296 is not set
# CONFIG_VIDEO_IMX319 is not set
# CONFIG_VIDEO_IMX355 is not set
# CONFIG_VIDEO_MT9M001 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9M114 is not set
# CONFIG_VIDEO_MT9P031 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V032 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_OG01A1B is not set
# CONFIG_VIDEO_OV01A10 is not set
# CONFIG_VIDEO_OV02A10 is not set
# CONFIG_VIDEO_OV02E10 is not set
# CONFIG_VIDEO_OV02C10 is not set
# CONFIG_VIDEO_OV08D10 is not set
# CONFIG_VIDEO_OV08X40 is not set
# CONFIG_VIDEO_OV13858 is not set
# CONFIG_VIDEO_OV13B10 is not set
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV2740 is not set
# CONFIG_VIDEO_OV4689 is not set
# CONFIG_VIDEO_OV5647 is not set
# CONFIG_VIDEO_OV5648 is not set
# CONFIG_VIDEO_OV5670 is not set
# CONFIG_VIDEO_OV5675 is not set
# CONFIG_VIDEO_OV5693 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV64A40 is not set
# CONFIG_VIDEO_OV6650 is not set
# CONFIG_VIDEO_OV7251 is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV8856 is not set
# CONFIG_VIDEO_OV8858 is not set
# CONFIG_VIDEO_OV8865 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_OV9650 is not set
# CONFIG_VIDEO_OV9734 is not set
# CONFIG_VIDEO_RDACM20 is not set
# CONFIG_VIDEO_RDACM21 is not set
# CONFIG_VIDEO_RJ54N1 is not set
# CONFIG_VIDEO_S5C73M3 is not set
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_S5K6A3 is not set
# CONFIG_VIDEO_VD55G1 is not set
# CONFIG_VIDEO_VD56G3 is not set
# CONFIG_VIDEO_CCS is not set
# CONFIG_VIDEO_ET8EK8 is not set

#
# Camera ISPs
#
# CONFIG_VIDEO_THP7312 is not set
# end of Camera ISPs

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set
# CONFIG_VIDEO_AK7375 is not set
# CONFIG_VIDEO_DW9714 is not set
# CONFIG_VIDEO_DW9719 is not set
# CONFIG_VIDEO_DW9768 is not set
# CONFIG_VIDEO_DW9807_VCM is not set
# end of Lens drivers

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set
# end of Flash devices

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_CS3308 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set
# CONFIG_VIDEO_TDA1997X is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_WM8775 is not set
# end of Audio decoders, processors and mixers

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set
# end of RDS decoders

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_ADV7604 is not set
# CONFIG_VIDEO_ADV7842 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_LT6911UXE is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_TC358743 is not set
# CONFIG_VIDEO_TC358746 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9900 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set
# end of Video decoders

#
# Video encoders
#
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_ADV7511 is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_THS8200 is not set
# end of Video encoders

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set
# end of Video improvement chips

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set
# end of Audio/Video compression chips

#
# SDR tuner chips
#
# end of SDR tuner chips

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_I2C is not set
# CONFIG_VIDEO_M52790 is not set
# CONFIG_VIDEO_ST_MIPID02 is not set
# CONFIG_VIDEO_THS7303 is not set
# end of Miscellaneous helper chips

#
# Video serializers and deserializers
#
# end of Video serializers and deserializers

#
# Media SPI Adapters
#
# CONFIG_VIDEO_GS1662 is not set
# end of Media SPI Adapters
# end of Media ancillary drivers

#
# Graphics support
#
CONFIG_APERTURE_HELPERS=y
CONFIG_SCREEN_INFO=y
CONFIG_VIDEO=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m

#
# DRM debugging options
#
# CONFIG_DRM_WERROR is not set
# CONFIG_DRM_DEBUG_MM is not set
# end of DRM debugging options

CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_PANIC is not set
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
# CONFIG_DRM_DEBUG_MODESET_LOCK is not set
CONFIG_DRM_CLIENT=y
CONFIG_DRM_CLIENT_LIB=m
CONFIG_DRM_CLIENT_SELECTION=m
CONFIG_DRM_CLIENT_SETUP=y

#
# Supported DRM clients
#
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
# CONFIG_DRM_CLIENT_LOG is not set
CONFIG_DRM_CLIENT_DEFAULT_FBDEV=y
CONFIG_DRM_CLIENT_DEFAULT="fbdev"
# end of Supported DRM clients

CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_DISPLAY_HELPER=m
# CONFIG_DRM_DISPLAY_DP_AUX_CEC is not set
# CONFIG_DRM_DISPLAY_DP_AUX_CHARDEV is not set
CONFIG_DRM_DISPLAY_DP_HELPER=y
CONFIG_DRM_DISPLAY_DP_TUNNEL=y
CONFIG_DRM_DISPLAY_DSC_HELPER=y
CONFIG_DRM_DISPLAY_HDCP_HELPER=y
CONFIG_DRM_DISPLAY_HDMI_HELPER=y
CONFIG_DRM_TTM=m
CONFIG_DRM_EXEC=m
CONFIG_DRM_GPUVM=m
CONFIG_DRM_BUDDY=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=m
CONFIG_DRM_SUBALLOC_HELPER=m
CONFIG_DRM_SCHED=m

#
# Drivers for system framebuffers
#
# CONFIG_DRM_EFIDRM is not set
# CONFIG_DRM_SIMPLEDRM is not set
# CONFIG_DRM_VESADRM is not set
# end of Drivers for system framebuffers

#
# ARM devices
#
# end of ARM devices

CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_USERPTR=y
CONFIG_DRM_AMDGPU=m
# CONFIG_DRM_AMDGPU_SI is not set
# CONFIG_DRM_AMDGPU_CIK is not set
CONFIG_DRM_AMDGPU_USERPTR=y
# CONFIG_DRM_AMD_ISP is not set
# CONFIG_DRM_AMDGPU_WERROR is not set

#
# ACP (Audio CoProcessor) Configuration
#
CONFIG_DRM_AMD_ACP=y
# end of ACP (Audio CoProcessor) Configuration

#
# Display Engine Configuration
#
CONFIG_DRM_AMD_DC=y
CONFIG_DRM_AMD_DC_FP=y
# CONFIG_DRM_AMD_SECURE_DISPLAY is not set
# end of Display Engine Configuration

CONFIG_HSA_AMD=y
CONFIG_HSA_AMD_SVM=y
# CONFIG_HSA_AMD_P2P is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_NOUVEAU_DEBUG_MMU is not set
# CONFIG_NOUVEAU_DEBUG_PUSH is not set
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_NOUVEAU_GSP_DEFAULT is not set
CONFIG_DRM_NOUVEAU_CH7006=m
CONFIG_DRM_NOUVEAU_SIL164=m
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
# CONFIG_DRM_I915_GVT_KVMGT is not set
CONFIG_DRM_I915_DP_TUNNEL=y

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_REPLAY_GPU_HANGS_API is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# CONFIG_DRM_I915_DEBUG_WAKEREF is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_PREEMPT_TIMEOUT_COMPUTE=7500
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

# CONFIG_DRM_XE is not set
# CONFIG_DRM_VGEM is not set
CONFIG_DRM_VKMS=m
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_MKSSTATS is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_QXL=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_VIRTIO_GPU_KMS=y
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_AUO_A030JTN01 is not set
# CONFIG_DRM_PANEL_ILITEK_ILI9341 is not set
# CONFIG_DRM_PANEL_ORISETECH_OTA5601A is not set
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# CONFIG_DRM_PANEL_WIDECHIPS_WS2401 is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
# CONFIG_DRM_HISI_HIBMC is not set
# CONFIG_DRM_APPLETBDRM is not set
CONFIG_DRM_BOCHS=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_GM12U320=m
# CONFIG_DRM_PANEL_MIPI_DBI is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9163 is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_SHARP_MEMORY is not set
# CONFIG_DRM_XEN_FRONTEND is not set
# CONFIG_DRM_VBOXVIDEO is not set
CONFIG_DRM_GUD=m
# CONFIG_DRM_ST7571_I2C is not set
# CONFIG_DRM_ST7586 is not set
# CONFIG_DRM_ST7735R is not set
# CONFIG_DRM_SSD130X is not set
CONFIG_DRM_HYPERV=m
CONFIG_DRM_PANEL_BACKLIGHT_QUIRKS=m
CONFIG_DRM_PRIVACY_SCREEN=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_HYPERV is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
CONFIG_FB_CORE=y
CONFIG_FB_NOTIFY=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DEVICE=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYSMEM_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_IOMEM_FOPS=y
CONFIG_FB_IOMEM_HELPERS=y
CONFIG_FB_SYSMEM_HELPERS=y
CONFIG_FB_SYSMEM_HELPERS_DEFERRED=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_KTD2801 is not set
# CONFIG_BACKLIGHT_KTZ8866 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3509 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_MP3309C is not set
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION is not set
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

# CONFIG_DRM_ACCEL is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_PCM_ELD=y
CONFIG_SND_HWDEP=m
CONFIG_SND_SEQ_DEVICE=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_UMP=m
CONFIG_SND_UMP_LEGACY_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_PROC_FS=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_CTL_FAST_LOOKUP=y
# CONFIG_SND_DEBUG is not set
# CONFIG_SND_CTL_INPUT_VALIDATION is not set
# CONFIG_SND_UTIMER is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_CTL_LED=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_SEQ_MIDI_EVENT=m
CONFIG_SND_SEQ_MIDI=m
CONFIG_SND_SEQ_MIDI_EMUL=m
CONFIG_SND_SEQ_VIRMIDI=m
CONFIG_SND_SEQ_UMP=y
CONFIG_SND_SEQ_UMP_CLIENT=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
# CONFIG_SND_PCMTEST is not set
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=m
CONFIG_SND_HDA_GENERIC_LEDS=y
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDA_ACPI is not set
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CIRRUS_SCODEC=m
CONFIG_SND_HDA_SCODEC_CS35L41=m
CONFIG_SND_HDA_SCODEC_COMPONENT=m
CONFIG_SND_HDA_SCODEC_CS35L41_I2C=m
CONFIG_SND_HDA_SCODEC_CS35L41_SPI=m
CONFIG_SND_HDA_SCODEC_CS35L56=m
CONFIG_SND_HDA_SCODEC_CS35L56_I2C=m
CONFIG_SND_HDA_SCODEC_CS35L56_SPI=m
CONFIG_SND_HDA_SCODEC_TAS2781=m
CONFIG_SND_HDA_SCODEC_TAS2781_I2C=m
# CONFIG_SND_HDA_SCODEC_TAS2781_SPI is not set
CONFIG_SND_HDA_CODEC_REALTEK=m
CONFIG_SND_HDA_CODEC_ANALOG=m
CONFIG_SND_HDA_CODEC_SIGMATEL=m
CONFIG_SND_HDA_CODEC_VIA=m
CONFIG_SND_HDA_CODEC_HDMI=m
CONFIG_SND_HDA_CODEC_CIRRUS=m
CONFIG_SND_HDA_CODEC_CS8409=m
CONFIG_SND_HDA_CODEC_CONEXANT=m
# CONFIG_SND_HDA_CODEC_SENARYTECH is not set
CONFIG_SND_HDA_CODEC_CA0110=m
CONFIG_SND_HDA_CODEC_CA0132=m
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m
CONFIG_SND_HDA_CODEC_SI3054=m
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=1
CONFIG_SND_HDA_INTEL_HDMI_SILENT_STREAM=y
# CONFIG_SND_HDA_CTL_DEV_ID is not set
# end of HD-Audio

CONFIG_SND_HDA_CORE=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_COMPONENT=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_EXT_CORE=m
CONFIG_SND_HDA_PREALLOC_SIZE=0
CONFIG_SND_INTEL_NHLT=y
CONFIG_SND_INTEL_DSP_CONFIG=m
CONFIG_SND_INTEL_SOUNDWIRE_ACPI=m
# CONFIG_SND_INTEL_BYT_PREFER_SOF is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_AUDIO_MIDI_V2=y
CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER=y
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
CONFIG_SND_USB_HIFACE=m
CONFIG_SND_BCD2000=m
CONFIG_SND_USB_LINE6=m
CONFIG_SND_USB_POD=m
CONFIG_SND_USB_PODHD=m
CONFIG_SND_USB_TONEPORT=m
CONFIG_SND_USB_VARIAX=m
CONFIG_SND_SOC=m
CONFIG_SND_SOC_COMPRESS=y
CONFIG_SND_SOC_TOPOLOGY=y
CONFIG_SND_SOC_ACPI=m
# CONFIG_SND_SOC_USB is not set
# CONFIG_SND_SOC_ADI is not set
# CONFIG_SND_SOC_AMD_ACP is not set
# CONFIG_SND_SOC_AMD_ACP3x is not set
CONFIG_SND_SOC_AMD_RENOIR=m
CONFIG_SND_SOC_AMD_RENOIR_MACH=m
CONFIG_SND_SOC_AMD_ACP5x=m
CONFIG_SND_SOC_AMD_VANGOGH_MACH=m
CONFIG_SND_SOC_AMD_ACP6x=m
CONFIG_SND_SOC_AMD_YC_MACH=m
CONFIG_SND_AMD_ACP_CONFIG=m
# CONFIG_SND_SOC_AMD_ACP_COMMON is not set
CONFIG_SND_SOC_ACPI_AMD_MATCH=m
CONFIG_SND_AMD_SOUNDWIRE_ACPI=m
# CONFIG_SND_SOC_AMD_RPL_ACP6x is not set
CONFIG_SND_SOC_AMD_ACP63_TOPLEVEL=m
CONFIG_SND_SOC_AMD_SOUNDWIRE_LINK_BASELINE=m
CONFIG_SND_SOC_AMD_SOUNDWIRE=m
CONFIG_SND_SOC_AMD_PS=m
CONFIG_SND_SOC_AMD_PS_MACH=m
# CONFIG_SND_ATMEL_SOC is not set
# CONFIG_SND_BCM63XX_I2S_WHISTLER is not set
# CONFIG_SND_DESIGNWARE_I2S is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_ASRC is not set
# CONFIG_SND_SOC_FSL_SAI is not set
# CONFIG_SND_SOC_FSL_AUDMIX is not set
# CONFIG_SND_SOC_FSL_SSI is not set
# CONFIG_SND_SOC_FSL_SPDIF is not set
# CONFIG_SND_SOC_FSL_ESAI is not set
# CONFIG_SND_SOC_FSL_MICFIL is not set
# CONFIG_SND_SOC_FSL_XCVR is not set
# CONFIG_SND_SOC_IMX_AUDMUX is not set
# end of SoC Audio for Freescale CPUs

# CONFIG_SND_SOC_CHV3_I2S is not set
# CONFIG_SND_I2S_HI6210_I2S is not set

#
# SoC Audio for Loongson CPUs
#
# end of SoC Audio for Loongson CPUs

# CONFIG_SND_SOC_IMG is not set
CONFIG_SND_SOC_INTEL_SST_TOPLEVEL=y
CONFIG_SND_SOC_INTEL_CATPT=m
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM=m
# CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_PCI is not set
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_ACPI=m
CONFIG_SND_SOC_ACPI_INTEL_MATCH=m
CONFIG_SND_SOC_ACPI_INTEL_SDCA_QUIRKS=m
CONFIG_SND_SOC_INTEL_AVS=m

#
# Intel AVS Machine drivers
#

#
# Available DSP configurations
#
# CONFIG_SND_SOC_INTEL_AVS_CARDNAME_OBSOLETE is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_DA7219 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_DMIC is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_ES8336 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_HDAUDIO is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_I2S_TEST is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_MAX98927 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_MAX98357A is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_MAX98373 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_NAU8825 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_PCM3168A is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_PROBE is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT274 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT286 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT298 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT5514 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT5663 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT5682 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_SSM4567 is not set
# end of Intel AVS Machine drivers

CONFIG_SND_SOC_INTEL_MACH=y
CONFIG_SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES=y
CONFIG_SND_SOC_INTEL_HDA_DSP_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_MAXIM_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_REALTEK_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_CIRRUS_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_NUVOTON_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_BOARD_HELPERS=m
CONFIG_SND_SOC_INTEL_HASWELL_MACH=m
CONFIG_SND_SOC_INTEL_BDW_RT5650_MACH=m
CONFIG_SND_SOC_INTEL_BDW_RT5677_MACH=m
CONFIG_SND_SOC_INTEL_BROADWELL_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5640_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5651_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5672_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5645_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_MAX98090_TI_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_NAU8824_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_CX2072X_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_DA7213_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_ES8316_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_NOCODEC_MACH=m
CONFIG_SND_SOC_INTEL_SOF_WM8804_MACH=m
CONFIG_SND_SOC_INTEL_GLK_DA7219_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_GLK_RT5682_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_SKL_HDA_DSP_GENERIC_MACH=m
CONFIG_SND_SOC_INTEL_SOF_RT5682_MACH=m
CONFIG_SND_SOC_INTEL_SOF_CS42L42_MACH=m
CONFIG_SND_SOC_INTEL_SOF_PCM512x_MACH=m
CONFIG_SND_SOC_INTEL_SOF_ES8336_MACH=m
CONFIG_SND_SOC_INTEL_SOF_NAU8825_MACH=m
CONFIG_SND_SOC_INTEL_CML_LP_DA7219_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_SOF_CML_RT1011_RT5682_MACH=m
CONFIG_SND_SOC_INTEL_SOF_DA7219_MACH=m
CONFIG_SND_SOC_INTEL_SOF_SSP_AMP_MACH=m
CONFIG_SND_SOC_INTEL_EHL_RT5660_MACH=m
CONFIG_SND_SOC_INTEL_SOUNDWIRE_SOF_MACH=m
# CONFIG_SND_SOC_MTK_BTCVSD is not set
CONFIG_SND_SOC_SDCA=m
CONFIG_SND_SOC_SDCA_OPTIONAL=m
CONFIG_SND_SOC_SOF_TOPLEVEL=y
CONFIG_SND_SOC_SOF_PCI_DEV=m
CONFIG_SND_SOC_SOF_PCI=m
CONFIG_SND_SOC_SOF_ACPI=m
CONFIG_SND_SOC_SOF_ACPI_DEV=m
CONFIG_SND_SOC_SOF_DEBUG_PROBES=m
CONFIG_SND_SOC_SOF_CLIENT=m
# CONFIG_SND_SOC_SOF_DEVELOPER_SUPPORT is not set
CONFIG_SND_SOC_SOF=m
CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE=y
CONFIG_SND_SOC_SOF_IPC3=y
CONFIG_SND_SOC_SOF_IPC4=y
CONFIG_SND_SOC_SOF_AMD_TOPLEVEL=m
CONFIG_SND_SOC_SOF_AMD_COMMON=m
CONFIG_SND_SOC_SOF_AMD_RENOIR=m
CONFIG_SND_SOC_SOF_AMD_VANGOGH=m
CONFIG_SND_SOC_SOF_AMD_REMBRANDT=m
CONFIG_SND_SOC_SOF_ACP_PROBES=m
# CONFIG_SND_SOC_SOF_AMD_ACP63 is not set
# CONFIG_SND_SOC_SOF_AMD_ACP70 is not set
CONFIG_SND_SOC_SOF_INTEL_TOPLEVEL=y
CONFIG_SND_SOC_SOF_INTEL_HIFI_EP_IPC=m
CONFIG_SND_SOC_SOF_INTEL_ATOM_HIFI_EP=m
CONFIG_SND_SOC_SOF_INTEL_COMMON=m
CONFIG_SND_SOC_SOF_BAYTRAIL=m
CONFIG_SND_SOC_SOF_BROADWELL=m
CONFIG_SND_SOC_SOF_MERRIFIELD=m
# CONFIG_SND_SOC_SOF_SKYLAKE is not set
# CONFIG_SND_SOC_SOF_KABYLAKE is not set
CONFIG_SND_SOC_SOF_INTEL_APL=m
CONFIG_SND_SOC_SOF_APOLLOLAKE=m
CONFIG_SND_SOC_SOF_GEMINILAKE=m
CONFIG_SND_SOC_SOF_INTEL_CNL=m
CONFIG_SND_SOC_SOF_CANNONLAKE=m
CONFIG_SND_SOC_SOF_COFFEELAKE=m
CONFIG_SND_SOC_SOF_COMETLAKE=m
CONFIG_SND_SOC_SOF_INTEL_ICL=m
CONFIG_SND_SOC_SOF_ICELAKE=m
CONFIG_SND_SOC_SOF_JASPERLAKE=m
CONFIG_SND_SOC_SOF_INTEL_TGL=m
CONFIG_SND_SOC_SOF_TIGERLAKE=m
CONFIG_SND_SOC_SOF_ELKHARTLAKE=m
CONFIG_SND_SOC_SOF_ALDERLAKE=m
CONFIG_SND_SOC_SOF_INTEL_MTL=m
CONFIG_SND_SOC_SOF_METEORLAKE=m
CONFIG_SND_SOC_SOF_INTEL_LNL=m
CONFIG_SND_SOC_SOF_LUNARLAKE=m
CONFIG_SND_SOC_SOF_INTEL_PTL=m
CONFIG_SND_SOC_SOF_PANTHERLAKE=m
CONFIG_SND_SOC_SOF_HDA_COMMON=m
CONFIG_SND_SOC_SOF_HDA_GENERIC=m
CONFIG_SND_SOC_SOF_HDA_MLINK=m
CONFIG_SND_SOC_SOF_HDA_LINK=y
CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC=y
CONFIG_SND_SOF_SOF_HDA_SDW_BPT=m
CONFIG_SND_SOC_SOF_HDA_LINK_BASELINE=m
CONFIG_SND_SOC_SOF_HDA=m
CONFIG_SND_SOC_SOF_HDA_PROBES=m
CONFIG_SND_SOC_SOF_INTEL_SOUNDWIRE_LINK_BASELINE=m
CONFIG_SND_SOC_SOF_INTEL_SOUNDWIRE=m
CONFIG_SND_SOC_SOF_XTENSA=m

#
# STMicroelectronics STM32 SOC audio support
#
# end of STMicroelectronics STM32 SOC audio support

# CONFIG_SND_SOC_XILINX_I2S is not set
# CONFIG_SND_SOC_XILINX_AUDIO_FORMATTER is not set
# CONFIG_SND_SOC_XILINX_SPDIF is not set
# CONFIG_SND_SOC_XTFPGA_I2S is not set
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
CONFIG_SND_SOC_WM_ADSP=m
# CONFIG_SND_SOC_AC97_CODEC is not set
# CONFIG_SND_SOC_ADAU1372_I2C is not set
# CONFIG_SND_SOC_ADAU1372_SPI is not set
# CONFIG_SND_SOC_ADAU1373 is not set
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_ADAU1761_I2C is not set
# CONFIG_SND_SOC_ADAU1761_SPI is not set
# CONFIG_SND_SOC_ADAU7002 is not set
# CONFIG_SND_SOC_ADAU7118_HW is not set
# CONFIG_SND_SOC_ADAU7118_I2C is not set
# CONFIG_SND_SOC_AK4104 is not set
# CONFIG_SND_SOC_AK4118 is not set
# CONFIG_SND_SOC_AK4375 is not set
# CONFIG_SND_SOC_AK4458 is not set
# CONFIG_SND_SOC_AK4554 is not set
# CONFIG_SND_SOC_AK4613 is not set
# CONFIG_SND_SOC_AK4619 is not set
# CONFIG_SND_SOC_AK4642 is not set
# CONFIG_SND_SOC_AK5386 is not set
# CONFIG_SND_SOC_AK5558 is not set
# CONFIG_SND_SOC_ALC5623 is not set
# CONFIG_SND_SOC_AUDIO_IIO_AUX is not set
# CONFIG_SND_SOC_AW8738 is not set
# CONFIG_SND_SOC_AW88395 is not set
# CONFIG_SND_SOC_AW88166 is not set
# CONFIG_SND_SOC_AW88261 is not set
# CONFIG_SND_SOC_AW88081 is not set
# CONFIG_SND_SOC_AW87390 is not set
# CONFIG_SND_SOC_AW88399 is not set
# CONFIG_SND_SOC_BD28623 is not set
# CONFIG_SND_SOC_BT_SCO is not set
# CONFIG_SND_SOC_CHV3_CODEC is not set
CONFIG_SND_SOC_CS_AMP_LIB=m
# CONFIG_SND_SOC_CS35L32 is not set
# CONFIG_SND_SOC_CS35L33 is not set
# CONFIG_SND_SOC_CS35L34 is not set
# CONFIG_SND_SOC_CS35L35 is not set
# CONFIG_SND_SOC_CS35L36 is not set
CONFIG_SND_SOC_CS35L41_LIB=m
CONFIG_SND_SOC_CS35L41=m
CONFIG_SND_SOC_CS35L41_SPI=m
CONFIG_SND_SOC_CS35L41_I2C=m
# CONFIG_SND_SOC_CS35L45_SPI is not set
# CONFIG_SND_SOC_CS35L45_I2C is not set
CONFIG_SND_SOC_CS35L56=m
CONFIG_SND_SOC_CS35L56_SHARED=m
# CONFIG_SND_SOC_CS35L56_I2C is not set
CONFIG_SND_SOC_CS35L56_SPI=m
CONFIG_SND_SOC_CS35L56_SDW=m
CONFIG_SND_SOC_CS42L42_CORE=m
CONFIG_SND_SOC_CS42L42=m
CONFIG_SND_SOC_CS42L42_SDW=m
CONFIG_SND_SOC_CS42L43=m
CONFIG_SND_SOC_CS42L43_SDW=m
# CONFIG_SND_SOC_CS42L51_I2C is not set
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS42L83 is not set
# CONFIG_SND_SOC_CS42L84 is not set
# CONFIG_SND_SOC_CS4234 is not set
# CONFIG_SND_SOC_CS4265 is not set
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271_I2C is not set
# CONFIG_SND_SOC_CS4271_SPI is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
# CONFIG_SND_SOC_CS43130 is not set
# CONFIG_SND_SOC_CS4341 is not set
# CONFIG_SND_SOC_CS4349 is not set
# CONFIG_SND_SOC_CS48L32 is not set
# CONFIG_SND_SOC_CS53L30 is not set
# CONFIG_SND_SOC_CS530X_I2C is not set
CONFIG_SND_SOC_CX2072X=m
CONFIG_SND_SOC_DA7213=m
CONFIG_SND_SOC_DA7219=m
CONFIG_SND_SOC_DMIC=m
# CONFIG_SND_SOC_ES7134 is not set
# CONFIG_SND_SOC_ES7241 is not set
CONFIG_SND_SOC_ES83XX_DSM_COMMON=m
# CONFIG_SND_SOC_ES8311 is not set
CONFIG_SND_SOC_ES8316=m
# CONFIG_SND_SOC_ES8323 is not set
CONFIG_SND_SOC_ES8326=m
# CONFIG_SND_SOC_ES8328_I2C is not set
# CONFIG_SND_SOC_ES8328_SPI is not set
# CONFIG_SND_SOC_ES8375 is not set
# CONFIG_SND_SOC_ES8389 is not set
# CONFIG_SND_SOC_GTM601 is not set
CONFIG_SND_SOC_HDAC_HDA=m
CONFIG_SND_SOC_HDA=m
# CONFIG_SND_SOC_ICS43432 is not set
# CONFIG_SND_SOC_IDT821034 is not set
# CONFIG_SND_SOC_MAX98088 is not set
CONFIG_SND_SOC_MAX98090=m
CONFIG_SND_SOC_MAX98357A=m
# CONFIG_SND_SOC_MAX98504 is not set
# CONFIG_SND_SOC_MAX9867 is not set
CONFIG_SND_SOC_MAX98927=m
# CONFIG_SND_SOC_MAX98520 is not set
CONFIG_SND_SOC_MAX98363=m
CONFIG_SND_SOC_MAX98373=m
CONFIG_SND_SOC_MAX98373_I2C=m
CONFIG_SND_SOC_MAX98373_SDW=m
CONFIG_SND_SOC_MAX98388=m
CONFIG_SND_SOC_MAX98390=m
# CONFIG_SND_SOC_MAX98396 is not set
# CONFIG_SND_SOC_MAX9860 is not set
# CONFIG_SND_SOC_MSM8916_WCD_DIGITAL is not set
# CONFIG_SND_SOC_PCM1681 is not set
# CONFIG_SND_SOC_PCM1789_I2C is not set
# CONFIG_SND_SOC_PCM179X_I2C is not set
# CONFIG_SND_SOC_PCM179X_SPI is not set
# CONFIG_SND_SOC_PCM186X_I2C is not set
# CONFIG_SND_SOC_PCM186X_SPI is not set
# CONFIG_SND_SOC_PCM3060_I2C is not set
# CONFIG_SND_SOC_PCM3060_SPI is not set
# CONFIG_SND_SOC_PCM3168A_I2C is not set
# CONFIG_SND_SOC_PCM3168A_SPI is not set
# CONFIG_SND_SOC_PCM5102A is not set
CONFIG_SND_SOC_PCM512x=m
CONFIG_SND_SOC_PCM512x_I2C=m
# CONFIG_SND_SOC_PCM512x_SPI is not set
# CONFIG_SND_SOC_PCM6240 is not set
# CONFIG_SND_SOC_PEB2466 is not set
CONFIG_SND_SOC_RL6231=m
CONFIG_SND_SOC_RT_SDW_COMMON=m
CONFIG_SND_SOC_RL6347A=m
CONFIG_SND_SOC_RT286=m
CONFIG_SND_SOC_RT1011=m
CONFIG_SND_SOC_RT1015=m
CONFIG_SND_SOC_RT1015P=m
# CONFIG_SND_SOC_RT1017_SDCA_SDW is not set
CONFIG_SND_SOC_RT1308=m
CONFIG_SND_SOC_RT1308_SDW=m
CONFIG_SND_SOC_RT1316_SDW=m
CONFIG_SND_SOC_RT1318_SDW=m
CONFIG_SND_SOC_RT1320_SDW=m
# CONFIG_SND_SOC_RT5616 is not set
# CONFIG_SND_SOC_RT5631 is not set
CONFIG_SND_SOC_RT5640=m
CONFIG_SND_SOC_RT5645=m
CONFIG_SND_SOC_RT5651=m
# CONFIG_SND_SOC_RT5659 is not set
CONFIG_SND_SOC_RT5660=m
CONFIG_SND_SOC_RT5670=m
CONFIG_SND_SOC_RT5677=m
CONFIG_SND_SOC_RT5677_SPI=m
CONFIG_SND_SOC_RT5682=m
CONFIG_SND_SOC_RT5682_I2C=m
CONFIG_SND_SOC_RT5682_SDW=m
CONFIG_SND_SOC_RT5682S=m
CONFIG_SND_SOC_RT700=m
CONFIG_SND_SOC_RT700_SDW=m
CONFIG_SND_SOC_RT711=m
CONFIG_SND_SOC_RT711_SDW=m
CONFIG_SND_SOC_RT711_SDCA_SDW=m
CONFIG_SND_SOC_RT712_SDCA_SDW=m
CONFIG_SND_SOC_RT712_SDCA_DMIC_SDW=m
CONFIG_SND_SOC_RT721_SDCA_SDW=m
CONFIG_SND_SOC_RT722_SDCA_SDW=m
CONFIG_SND_SOC_RT715=m
CONFIG_SND_SOC_RT715_SDW=m
CONFIG_SND_SOC_RT715_SDCA_SDW=m
# CONFIG_SND_SOC_RT9120 is not set
# CONFIG_SND_SOC_RT9123 is not set
# CONFIG_SND_SOC_RT9123P is not set
# CONFIG_SND_SOC_RTQ9128 is not set
# CONFIG_SND_SOC_SDW_MOCKUP is not set
# CONFIG_SND_SOC_SGTL5000 is not set
# CONFIG_SND_SOC_SIMPLE_AMPLIFIER is not set
# CONFIG_SND_SOC_SIMPLE_MUX is not set
# CONFIG_SND_SOC_SMA1303 is not set
# CONFIG_SND_SOC_SMA1307 is not set
# CONFIG_SND_SOC_SPDIF is not set
# CONFIG_SND_SOC_SRC4XXX_I2C is not set
# CONFIG_SND_SOC_SSM2305 is not set
# CONFIG_SND_SOC_SSM2518 is not set
# CONFIG_SND_SOC_SSM2602_SPI is not set
# CONFIG_SND_SOC_SSM2602_I2C is not set
CONFIG_SND_SOC_SSM4567=m
# CONFIG_SND_SOC_STA32X is not set
# CONFIG_SND_SOC_STA350 is not set
# CONFIG_SND_SOC_STI_SAS is not set
# CONFIG_SND_SOC_TAS2552 is not set
# CONFIG_SND_SOC_TAS2562 is not set
# CONFIG_SND_SOC_TAS2764 is not set
# CONFIG_SND_SOC_TAS2770 is not set
# CONFIG_SND_SOC_TAS2780 is not set
CONFIG_SND_SOC_TAS2781_COMLIB=m
CONFIG_SND_SOC_TAS2781_COMLIB_I2C=m
CONFIG_SND_SOC_TAS2781_FMWLIB=m
# CONFIG_SND_SOC_TAS2781_I2C is not set
# CONFIG_SND_SOC_TAS5086 is not set
# CONFIG_SND_SOC_TAS571X is not set
# CONFIG_SND_SOC_TAS5720 is not set
# CONFIG_SND_SOC_TAS5805M is not set
# CONFIG_SND_SOC_TAS6424 is not set
# CONFIG_SND_SOC_TDA7419 is not set
# CONFIG_SND_SOC_TFA9879 is not set
# CONFIG_SND_SOC_TFA989X is not set
# CONFIG_SND_SOC_TLV320ADC3XXX is not set
# CONFIG_SND_SOC_TLV320AIC23_I2C is not set
# CONFIG_SND_SOC_TLV320AIC23_SPI is not set
# CONFIG_SND_SOC_TLV320AIC31XX is not set
# CONFIG_SND_SOC_TLV320AIC32X4_I2C is not set
# CONFIG_SND_SOC_TLV320AIC32X4_SPI is not set
# CONFIG_SND_SOC_TLV320AIC3X_I2C is not set
# CONFIG_SND_SOC_TLV320AIC3X_SPI is not set
# CONFIG_SND_SOC_TLV320ADCX140 is not set
CONFIG_SND_SOC_TS3A227E=m
# CONFIG_SND_SOC_TSCS42XX is not set
# CONFIG_SND_SOC_TSCS454 is not set
# CONFIG_SND_SOC_UDA1334 is not set
# CONFIG_SND_SOC_UDA1342 is not set
# CONFIG_SND_SOC_WCD937X_SDW is not set
# CONFIG_SND_SOC_WCD938X_SDW is not set
# CONFIG_SND_SOC_WCD939X_SDW is not set
# CONFIG_SND_SOC_WM8510 is not set
# CONFIG_SND_SOC_WM8523 is not set
# CONFIG_SND_SOC_WM8524 is not set
# CONFIG_SND_SOC_WM8580 is not set
# CONFIG_SND_SOC_WM8711 is not set
# CONFIG_SND_SOC_WM8728 is not set
# CONFIG_SND_SOC_WM8731_I2C is not set
# CONFIG_SND_SOC_WM8731_SPI is not set
# CONFIG_SND_SOC_WM8737 is not set
# CONFIG_SND_SOC_WM8741 is not set
# CONFIG_SND_SOC_WM8750 is not set
# CONFIG_SND_SOC_WM8753 is not set
# CONFIG_SND_SOC_WM8770 is not set
# CONFIG_SND_SOC_WM8776 is not set
# CONFIG_SND_SOC_WM8782 is not set
CONFIG_SND_SOC_WM8804=m
CONFIG_SND_SOC_WM8804_I2C=m
# CONFIG_SND_SOC_WM8804_SPI is not set
# CONFIG_SND_SOC_WM8903 is not set
# CONFIG_SND_SOC_WM8904 is not set
# CONFIG_SND_SOC_WM8940 is not set
# CONFIG_SND_SOC_WM8960 is not set
# CONFIG_SND_SOC_WM8961 is not set
# CONFIG_SND_SOC_WM8962 is not set
# CONFIG_SND_SOC_WM8974 is not set
# CONFIG_SND_SOC_WM8978 is not set
# CONFIG_SND_SOC_WM8985 is not set
# CONFIG_SND_SOC_WSA881X is not set
# CONFIG_SND_SOC_WSA883X is not set
# CONFIG_SND_SOC_WSA884X is not set
# CONFIG_SND_SOC_ZL38060 is not set
# CONFIG_SND_SOC_MAX9759 is not set
# CONFIG_SND_SOC_MT6351 is not set
# CONFIG_SND_SOC_MT6357 is not set
# CONFIG_SND_SOC_MT6358 is not set
# CONFIG_SND_SOC_MT6660 is not set
CONFIG_SND_SOC_NAU8315=m
# CONFIG_SND_SOC_NAU8540 is not set
# CONFIG_SND_SOC_NAU8810 is not set
CONFIG_SND_SOC_NAU8821=m
# CONFIG_SND_SOC_NAU8822 is not set
CONFIG_SND_SOC_NAU8824=m
CONFIG_SND_SOC_NAU8825=m
# CONFIG_SND_SOC_NTP8918 is not set
# CONFIG_SND_SOC_NTP8835 is not set
# CONFIG_SND_SOC_TPA6130A2 is not set
# CONFIG_SND_SOC_LPASS_WSA_MACRO is not set
# CONFIG_SND_SOC_LPASS_VA_MACRO is not set
# CONFIG_SND_SOC_LPASS_RX_MACRO is not set
# CONFIG_SND_SOC_LPASS_TX_MACRO is not set
# end of CODEC drivers

CONFIG_SND_SOC_SDW_UTILS=m
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SND_X86=y
CONFIG_HDMI_LPE_AUDIO=m
CONFIG_SND_SYNTH_EMUX=m
CONFIG_SND_XEN_FRONTEND=m
CONFIG_SND_VIRTIO=m
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
CONFIG_HID_APPLEIR=m
# CONFIG_HID_APPLETB_BL is not set
# CONFIG_HID_APPLETB_KBD is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_BETOP_FF=m
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CORSAIR=m
CONFIG_HID_COUGAR=m
# CONFIG_HID_MACALLY is not set
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELAN=m
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
CONFIG_HID_EVISION=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_GOODIX_SPI is not set
# CONFIG_HID_GOOGLE_STADIA_FF is not set
# CONFIG_HID_VIVALDI is not set
CONFIG_HID_GT683R=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_KYSONA is not set
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
# CONFIG_HID_VRC2 is not set
CONFIG_HID_XIAOMI=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
CONFIG_HID_LETSKETCH=m
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_MEGAWORLD_FF is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NINTENDO is not set
CONFIG_HID_NTI=m
CONFIG_HID_NTRIG=y
# CONFIG_HID_NVIDIA_SHIELD is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PENMOUNT=m
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PLANTRONICS=m
# CONFIG_HID_PXRC is not set
# CONFIG_HID_RAZER is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SEMITEK=m
CONFIG_HID_SIGMAMICRO=m
CONFIG_HID_SONY=m
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
# CONFIG_HID_TOPRE is not set
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_UNIVERSAL_PIDFF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_WINWING is not set
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2200 is not set
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# HID-BPF support
#
CONFIG_HID_BPF=y
# end of HID-BPF support

CONFIG_I2C_HID=y
CONFIG_I2C_HID_ACPI=m
# CONFIG_I2C_HID_OF is not set
CONFIG_I2C_HID_CORE=m

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
CONFIG_AMD_SFH_HID=m
# end of AMD SFH HID Support

#
# Intel THC HID Support
#
# CONFIG_INTEL_THC_HID is not set
# end of Intel THC HID Support

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y
# end of USB HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_PCI_AMD=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
# CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=m
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_DEFAULT_AUTHORIZATION_MODE=1
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_DBGCAP=y
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
CONFIG_USB_XHCI_PLATFORM=m
# CONFIG_USB_XHCI_SIDEBAND is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set
# CONFIG_USB_XEN_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
# CONFIG_USBIP_CORE is not set

#
# USB dual-mode controller drivers
#
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_F8153X=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MXUPORT=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_UPD78F0730=m
# CONFIG_USB_SERIAL_XR is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_LJCA is not set
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
CONFIG_TYPEC_TCPM=m
CONFIG_TYPEC_TCPCI=m
# CONFIG_TYPEC_RT1711H is not set
# CONFIG_TYPEC_TCPCI_MAXIM is not set
CONFIG_TYPEC_FUSB302=m
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_UCSI_STM32G0 is not set
CONFIG_TYPEC_TPS6598X=m
# CONFIG_TYPEC_ANX7411 is not set
CONFIG_TYPEC_RT1719=m
# CONFIG_TYPEC_HD3SS3220 is not set
# CONFIG_TYPEC_STUSB160X is not set
CONFIG_TYPEC_WUSB3801=m

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
CONFIG_TYPEC_MUX_FSA4480=m
# CONFIG_TYPEC_MUX_GPIO_SBU is not set
CONFIG_TYPEC_MUX_PI3USB30532=m
# CONFIG_TYPEC_MUX_IT5205 is not set
# CONFIG_TYPEC_MUX_NB7VPQ904M is not set
# CONFIG_TYPEC_MUX_PS883X is not set
# CONFIG_TYPEC_MUX_PTN36502 is not set
# CONFIG_TYPEC_MUX_TUSB1046 is not set
# CONFIG_TYPEC_MUX_WCD939X_USBSS is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
CONFIG_TYPEC_DP_ALTMODE=m
# CONFIG_TYPEC_NVIDIA_ALTMODE is not set
# CONFIG_TYPEC_TBT_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

CONFIG_USB_ROLE_SWITCH=y
CONFIG_USB_ROLES_INTEL_XHCI=m
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_UHS2=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_REALTEK_PCI=m
CONFIG_MMC_REALTEK_USB=m
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_USB=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
# CONFIG_LEDS_AW200XX is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA995X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2606MVV is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_IS31FL319X is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
CONFIG_LEDS_MLXREG=m
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_SPI_BYTE is not set

#
# Flash and Torch LED drivers
#

#
# RGB LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_DISK=y
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
# CONFIG_LEDS_TRIGGER_TTY is not set
# CONFIG_LEDS_TRIGGER_INPUT_EVENTS is not set

#
# Simatic LED drivers
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
CONFIG_INFINIBAND_VIRT_DMA=y
CONFIG_INFINIBAND_BNXT_RE=m
CONFIG_INFINIBAND_CXGB4=m
CONFIG_INFINIBAND_EFA=m
# CONFIG_INFINIBAND_ERDMA is not set
CONFIG_INFINIBAND_HFI1=m
# CONFIG_HFI1_DEBUG_SDMA_ORDER is not set
# CONFIG_SDMA_VERBOSITY is not set
CONFIG_INFINIBAND_IRDMA=m
CONFIG_MANA_INFINIBAND=m
CONFIG_MLX4_INFINIBAND=m
CONFIG_MLX5_INFINIBAND=m
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_QEDR=m
# CONFIG_INFINIBAND_QIB is not set
CONFIG_INFINIBAND_USNIC=m
CONFIG_INFINIBAND_VMWARE_PVRDMA=m
CONFIG_INFINIBAND_RDMAVT=m
CONFIG_RDMA_RXE=m
CONFIG_RDMA_SIW=m
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
CONFIG_INFINIBAND_ISER=m
CONFIG_INFINIBAND_ISERT=m
# CONFIG_INFINIBAND_RTRS_CLIENT is not set
# CONFIG_INFINIBAND_RTRS_SERVER is not set
CONFIG_INFINIBAND_OPA_VNIC=m
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_GHES=y
# CONFIG_EDAC_SCRUB is not set
# CONFIG_EDAC_ECS is not set
# CONFIG_EDAC_MEM_REPAIR is not set
CONFIG_EDAC_AMD64=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
CONFIG_EDAC_I10NM=m
CONFIG_EDAC_PND2=m
CONFIG_EDAC_IGEN6=m
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
# CONFIG_RTC_DRV_MAX31335 is not set
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
# CONFIG_RTC_DRV_RX8111 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
CONFIG_RTC_DRV_RV8803=m
# CONFIG_RTC_DRV_SD2405AL is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set
# CONFIG_RTC_DRV_RX6110 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_RP5C01=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_RTC_DRV_GOLDFISH is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
CONFIG_INTEL_IDXD_BUS=m
CONFIG_INTEL_IDXD=m
# CONFIG_INTEL_IDXD_COMPAT is not set
CONFIG_INTEL_IDXD_SVM=y
CONFIG_INTEL_IDXD_PERFMON=y
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_XILINX_DMA is not set
# CONFIG_XILINX_XDMA is not set
# CONFIG_AMD_AE4DMA is not set
CONFIG_AMD_PTDMA=m
# CONFIG_AMD_QDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
# CONFIG_INTEL_LDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
CONFIG_UDMABUF=y
CONFIG_DMABUF_MOVE_NOTIFY=y
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
CONFIG_DMABUF_HEAPS=y
# CONFIG_DMABUF_SYSFS_STATS is not set
CONFIG_DMABUF_HEAPS_SYSTEM=y
# CONFIG_DMABUF_HEAPS_CMA is not set
# end of DMABUF options

CONFIG_DCA=m
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_HV_GENERIC=m
CONFIG_VFIO=m
CONFIG_VFIO_DEVICE_CDEV=y
CONFIG_VFIO_GROUP=y
CONFIG_VFIO_CONTAINER=y
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_VIRQFD=y
# CONFIG_VFIO_DEBUGFS is not set

#
# VFIO support for PCI devices
#
CONFIG_VFIO_PCI_CORE=m
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_MLX5_VFIO_PCI=m
# CONFIG_VIRTIO_VFIO_PCI is not set
# CONFIG_QAT_VFIO_PCI is not set
# end of VFIO support for PCI devices

CONFIG_IRQ_BYPASS_MANAGER=m
CONFIG_VIRT_DRIVERS=y
CONFIG_VMGENID=y
# CONFIG_VBOXGUEST is not set
CONFIG_NITRO_ENCLAVES=m
CONFIG_EFI_SECRET=m
CONFIG_SEV_GUEST=m
CONFIG_TDX_GUEST_DRIVER=m
CONFIG_TSM_GUEST=y
CONFIG_TSM_REPORTS=m
CONFIG_TSM_MEASUREMENTS=y
CONFIG_VIRTIO_ANCHOR=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_PCI_LIB_LEGACY=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_ADMIN_LEGACY=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_VDPA=m
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MEM=m
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VIRTIO_DEBUG is not set
# CONFIG_VIRTIO_RTC is not set
CONFIG_VDPA=m
# CONFIG_VDPA_USER is not set
CONFIG_IFCVF=m
CONFIG_MLX5_VDPA=y
CONFIG_MLX5_VDPA_NET=m
# CONFIG_MLX5_VDPA_STEERING_DEBUG is not set
CONFIG_VP_VDPA=m
# CONFIG_ALIBABA_ENI_VDPA is not set
# CONFIG_SNET_VDPA is not set
# CONFIG_OCTEONEP_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST_RING=m
CONFIG_VHOST_TASK=y
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
CONFIG_VHOST_VDPA=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
# CONFIG_HYPERV_VTL_MODE is not set
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# CONFIG_MSHV_ROOT is not set
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_FRONT_PGDIR_SHBUF=m
# CONFIG_XEN_UNPOPULATED_ALLOC is not set
# CONFIG_XEN_VIRTIO is not set
# end of Xen driver support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
# CONFIG_STAGING is not set
# CONFIG_GOLDFISH is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLX_PLATFORM=m
# CONFIG_MLXREG_DPU is not set
CONFIG_MLXREG_HOTPLUG=m
CONFIG_MLXREG_IO=m
CONFIG_MLXREG_LC=m
CONFIG_NVSW_SN2201=m
# CONFIG_SURFACE_PLATFORMS is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
CONFIG_UV_SYSFS=m
CONFIG_MXM_WMI=m
CONFIG_NVIDIA_WMI_EC_BACKLIGHT=m
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
# CONFIG_YOGABOOK is not set
# CONFIG_ACERHDF is not set
CONFIG_ACER_WIRELESS=m
CONFIG_ACER_WMI=m

#
# AMD HSMP Driver
#
# CONFIG_AMD_HSMP_ACPI is not set
# CONFIG_AMD_HSMP_PLAT is not set
# end of AMD HSMP Driver

CONFIG_AMD_PMC=m
CONFIG_AMD_MP2_STB=y
# CONFIG_AMD_3D_VCACHE is not set
# CONFIG_AMD_WBRF is not set
# CONFIG_AMD_ISP_PLATFORM is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
# CONFIG_ASUS_TF103C_DOCK is not set
# CONFIG_MERAKI_MX100 is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
CONFIG_X86_PLATFORM_DRIVERS_DELL=y
# CONFIG_ALIENWARE_WMI is not set
CONFIG_DCDBAS=m
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_RBU=m
CONFIG_DELL_RBTN=m
CONFIG_DELL_PC=m
CONFIG_DELL_SMBIOS=m
CONFIG_DELL_SMBIOS_WMI=y
# CONFIG_DELL_SMBIOS_SMM is not set
CONFIG_DELL_SMO8800=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_PRIVACY=y
CONFIG_DELL_WMI_AIO=m
CONFIG_DELL_WMI_DESCRIPTOR=m
CONFIG_DELL_WMI_DDV=m
CONFIG_DELL_WMI_LED=m
CONFIG_DELL_WMI_SYSMAN=m
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
# CONFIG_X86_PLATFORM_DRIVERS_HP is not set
CONFIG_WIRELESS_HOTKEY=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
# CONFIG_LENOVO_WMI_HOTKEY_UTILITIES is not set
# CONFIG_LENOVO_YMC is not set
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_THINKPAD_LMI=m
# CONFIG_INTEL_ATOMISP2_PM is not set
CONFIG_INTEL_IFS=m
# CONFIG_INTEL_SAR_INT1092 is not set
CONFIG_INTEL_PMC_CORE=m
CONFIG_INTEL_PMC_SSRAM_TELEMETRY=m
CONFIG_INTEL_PMT_CLASS=m
CONFIG_INTEL_PMT_TELEMETRY=m
CONFIG_INTEL_PMT_CRASHLOG=m

#
# Intel Speed Select Technology interface support
#
CONFIG_INTEL_SPEED_SELECT_TPMI=m
CONFIG_INTEL_SPEED_SELECT_INTERFACE=m
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_WMI=y
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m

#
# Intel Uncore Frequency Control
#
CONFIG_INTEL_UNCORE_FREQ_CONTROL_TPMI=m
CONFIG_INTEL_UNCORE_FREQ_CONTROL=m
# end of Intel Uncore Frequency Control

CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_OAKTRAIL=m
CONFIG_INTEL_ISHTP_ECLITE=m
# CONFIG_INTEL_PUNIT_IPC is not set
CONFIG_INTEL_RST=m
CONFIG_INTEL_SDSI=m
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_INTEL_TPMI_POWER_DOMAINS=m
CONFIG_INTEL_TPMI=m
# CONFIG_INTEL_PLR_TPMI is not set
CONFIG_INTEL_TURBO_MAX_3=y
CONFIG_INTEL_VSEC=m
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_MEEGOPAD_ANX7428 is not set
# CONFIG_MSI_EC is not set
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_MSI_WMI_PLATFORM is not set
# CONFIG_PCENGINES_APU2 is not set
# CONFIG_PORTWELL_EC is not set
# CONFIG_BARCO_P50_GPIO is not set
# CONFIG_SAMSUNG_GALAXYBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_SERIAL_MULTI_INSTANTIATE=m
# CONFIG_INSPUR_PLATFORM_PROFILE is not set
# CONFIG_LENOVO_WMI_CAMERA is not set
# CONFIG_DASHARO_ACPI is not set
CONFIG_FW_ATTR_CLASS=m
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
# CONFIG_SIEMENS_SIMATIC_IPC is not set
# CONFIG_WINMATE_FM07_KEYS is not set
# CONFIG_SEL3350_PLATFORM is not set
# CONFIG_OXP_EC is not set
# CONFIG_TUXEDO_NB04_WMI_AB is not set
CONFIG_P2SB=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_LMK04832 is not set
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_XILINX_VCU is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOMMU_API=y
CONFIG_IOMMUFD_DRIVER=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
CONFIG_IOMMU_IO_PGTABLE=y
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_DMA_STRICT is not set
CONFIG_IOMMU_DEFAULT_DMA_LAZY=y
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_IOMMU_SVA=y
CONFIG_IOMMU_IOPF=y
CONFIG_AMD_IOMMU=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_SVM=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_PERF_EVENTS=y
CONFIG_IOMMUFD_DRIVER_CORE=y
CONFIG_IOMMUFD=m
CONFIG_IRQ_REMAP=y
CONFIG_HYPERV_IOMMU=y
CONFIG_VIRTIO_IOMMU=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

CONFIG_SOUNDWIRE=m

#
# SoundWire Devices
#
CONFIG_SOUNDWIRE_AMD=m
CONFIG_SOUNDWIRE_CADENCE=m
CONFIG_SOUNDWIRE_INTEL=m
# CONFIG_SOUNDWIRE_QCOM is not set
CONFIG_SOUNDWIRE_GENERIC_ALLOCATION=m

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# fujitsu SoC drivers
#
# end of fujitsu SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

# CONFIG_WPCM450_SOC is not set

#
# Qualcomm SoC drivers
#
CONFIG_QCOM_QMI_HELPERS=m
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

#
# PM Domains
#

#
# Amlogic PM Domains
#
# end of Amlogic PM Domains

#
# Broadcom PM Domains
#
# end of Broadcom PM Domains

#
# i.MX PM Domains
#
# end of i.MX PM Domains

#
# Qualcomm PM Domains
#
# end of Qualcomm PM Domains
# end of PM Domains

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
# CONFIG_IIO_BUFFER_DMA is not set
# CONFIG_IIO_BUFFER_DMAENGINE is not set
# CONFIG_IIO_BUFFER_HW_CONSUMER is not set
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
# CONFIG_IIO_CONFIGFS is not set
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
# CONFIG_IIO_SW_DEVICE is not set
# CONFIG_IIO_SW_TRIGGER is not set
# CONFIG_IIO_TRIGGERED_EVENT is not set

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADXL313_I2C is not set
# CONFIG_ADXL313_SPI is not set
# CONFIG_ADXL345_I2C is not set
# CONFIG_ADXL345_SPI is not set
# CONFIG_ADXL355_I2C is not set
# CONFIG_ADXL355_SPI is not set
# CONFIG_ADXL367_SPI is not set
# CONFIG_ADXL367_I2C is not set
# CONFIG_ADXL372_SPI is not set
# CONFIG_ADXL372_I2C is not set
# CONFIG_ADXL380_SPI is not set
# CONFIG_ADXL380_I2C is not set
# CONFIG_BMA180 is not set
# CONFIG_BMA220 is not set
# CONFIG_BMA400 is not set
# CONFIG_BMC150_ACCEL is not set
# CONFIG_BMI088_ACCEL is not set
# CONFIG_DA280 is not set
# CONFIG_DA311 is not set
# CONFIG_DMARD06 is not set
# CONFIG_DMARD09 is not set
# CONFIG_DMARD10 is not set
# CONFIG_FXLS8962AF_I2C is not set
# CONFIG_FXLS8962AF_SPI is not set
CONFIG_HID_SENSOR_ACCEL_3D=m
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
# CONFIG_IIO_KX022A_SPI is not set
# CONFIG_IIO_KX022A_I2C is not set
# CONFIG_KXSD9 is not set
# CONFIG_KXCJK1013 is not set
# CONFIG_MC3230 is not set
# CONFIG_MMA7455_I2C is not set
# CONFIG_MMA7455_SPI is not set
# CONFIG_MMA7660 is not set
# CONFIG_MMA8452 is not set
# CONFIG_MMA9551 is not set
# CONFIG_MMA9553 is not set
# CONFIG_MSA311 is not set
# CONFIG_MXC4005 is not set
# CONFIG_MXC6255 is not set
# CONFIG_SCA3000 is not set
# CONFIG_SCA3300 is not set
# CONFIG_STK8312 is not set
# CONFIG_STK8BA50 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD4000 is not set
# CONFIG_AD4030 is not set
# CONFIG_AD4130 is not set
# CONFIG_AD4695 is not set
# CONFIG_AD4851 is not set
# CONFIG_AD7091R5 is not set
# CONFIG_AD7091R8 is not set
# CONFIG_AD7124 is not set
# CONFIG_AD7173 is not set
# CONFIG_AD7191 is not set
# CONFIG_AD7192 is not set
# CONFIG_AD7266 is not set
# CONFIG_AD7280 is not set
# CONFIG_AD7291 is not set
# CONFIG_AD7292 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7380 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
# CONFIG_AD7625 is not set
# CONFIG_AD7766 is not set
# CONFIG_AD7768_1 is not set
# CONFIG_AD7779 is not set
# CONFIG_AD7780 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
# CONFIG_AD7944 is not set
# CONFIG_AD7949 is not set
# CONFIG_AD799X is not set
# CONFIG_AD9467 is not set
# CONFIG_ENVELOPE_DETECTOR is not set
# CONFIG_GEHC_PMC_ADC is not set
# CONFIG_HI8435 is not set
# CONFIG_HX711 is not set
# CONFIG_INA2XX_ADC is not set
# CONFIG_LTC2309 is not set
# CONFIG_LTC2471 is not set
# CONFIG_LTC2485 is not set
# CONFIG_LTC2496 is not set
# CONFIG_LTC2497 is not set
# CONFIG_MAX1027 is not set
# CONFIG_MAX11100 is not set
# CONFIG_MAX1118 is not set
# CONFIG_MAX11205 is not set
# CONFIG_MAX11410 is not set
# CONFIG_MAX1241 is not set
# CONFIG_MAX1363 is not set
# CONFIG_MAX34408 is not set
# CONFIG_MAX9611 is not set
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
# CONFIG_MCP3564 is not set
# CONFIG_MCP3911 is not set
# CONFIG_NAU7802 is not set
# CONFIG_NCT7201 is not set
# CONFIG_PAC1921 is not set
# CONFIG_PAC1934 is not set
# CONFIG_ROHM_BD79124 is not set
# CONFIG_RICHTEK_RTQ6056 is not set
# CONFIG_SD_ADC_MODULATOR is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_ADC0832 is not set
# CONFIG_TI_ADC084S021 is not set
# CONFIG_TI_ADC108S102 is not set
# CONFIG_TI_ADC12138 is not set
# CONFIG_TI_ADC128S052 is not set
# CONFIG_TI_ADC161S626 is not set
# CONFIG_TI_ADS1015 is not set
# CONFIG_TI_ADS1100 is not set
# CONFIG_TI_ADS1119 is not set
# CONFIG_TI_ADS124S08 is not set
# CONFIG_TI_ADS1298 is not set
# CONFIG_TI_ADS131E08 is not set
# CONFIG_TI_ADS7138 is not set
# CONFIG_TI_ADS7924 is not set
# CONFIG_TI_ADS7950 is not set
# CONFIG_TI_ADS8344 is not set
# CONFIG_TI_ADS8688 is not set
# CONFIG_TI_LMP92064 is not set
# CONFIG_TI_TLC4541 is not set
# CONFIG_TI_TSC2046 is not set
# CONFIG_VF610_ADC is not set
# CONFIG_XILINX_XADC is not set
# end of Analog to digital converters

#
# Analog to digital and digital to analog converters
#
# CONFIG_AD74115 is not set
# CONFIG_AD74413R is not set
# end of Analog to digital and digital to analog converters

#
# Analog Front Ends
#
# CONFIG_IIO_RESCALE is not set
# end of Analog Front Ends

#
# Amplifiers
#
# CONFIG_AD8366 is not set
# CONFIG_ADA4250 is not set
# CONFIG_HMC425 is not set
# end of Amplifiers

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7746 is not set
# end of Capacitance to digital converters

#
# Chemical Sensors
#
# CONFIG_AOSONG_AGS02MA is not set
# CONFIG_ATLAS_PH_SENSOR is not set
# CONFIG_ATLAS_EZO_SENSOR is not set
# CONFIG_BME680 is not set
# CONFIG_CCS811 is not set
# CONFIG_ENS160 is not set
# CONFIG_IAQCORE is not set
# CONFIG_SCD30_CORE is not set
# CONFIG_SCD4X is not set
# CONFIG_SEN0322 is not set
# CONFIG_SENSIRION_SGP30 is not set
# CONFIG_SENSIRION_SGP40 is not set
# CONFIG_SPS30_I2C is not set
# CONFIG_SENSEAIR_SUNRISE_CO2 is not set
# CONFIG_VZ89X is not set
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
# end of Hid Sensor IIO Common

#
# IIO SCMI Sensors
#
# end of IIO SCMI Sensors

#
# SSP Sensor Common
#
# CONFIG_IIO_SSP_SENSORHUB is not set
# end of SSP Sensor Common

#
# Digital to analog converters
#
# CONFIG_AD3530R is not set
# CONFIG_AD3552R_HS is not set
# CONFIG_AD3552R is not set
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
# CONFIG_AD5592R is not set
# CONFIG_AD5593R is not set
# CONFIG_AD5504 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_AD9739A is not set
# CONFIG_LTC2688 is not set
# CONFIG_AD5686_SPI is not set
# CONFIG_AD5696_I2C is not set
# CONFIG_AD5755 is not set
# CONFIG_AD5758 is not set
# CONFIG_AD5761 is not set
# CONFIG_AD5764 is not set
# CONFIG_AD5766 is not set
# CONFIG_AD5770R is not set
# CONFIG_AD5791 is not set
# CONFIG_AD7293 is not set
# CONFIG_AD7303 is not set
# CONFIG_AD8460 is not set
# CONFIG_AD8801 is not set
# CONFIG_BD79703 is not set
# CONFIG_DPOT_DAC is not set
# CONFIG_DS4424 is not set
# CONFIG_LTC1660 is not set
# CONFIG_LTC2632 is not set
# CONFIG_LTC2664 is not set
# CONFIG_M62332 is not set
# CONFIG_MAX517 is not set
# CONFIG_MAX5522 is not set
# CONFIG_MAX5821 is not set
# CONFIG_MCP4725 is not set
# CONFIG_MCP4728 is not set
# CONFIG_MCP4821 is not set
# CONFIG_MCP4922 is not set
# CONFIG_TI_DAC082S085 is not set
# CONFIG_TI_DAC5571 is not set
# CONFIG_TI_DAC7311 is not set
# CONFIG_TI_DAC7612 is not set
# CONFIG_VF610_DAC is not set
# end of Digital to analog converters

#
# IIO dummy driver
#
# end of IIO dummy driver

#
# Filters
#
# CONFIG_ADMV8818 is not set
# end of Filters

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set
# CONFIG_ADF4371 is not set
# CONFIG_ADF4377 is not set
# CONFIG_ADMFM2000 is not set
# CONFIG_ADMV1013 is not set
# CONFIG_ADMV1014 is not set
# CONFIG_ADMV4420 is not set
# CONFIG_ADRF6780 is not set
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS290 is not set
# CONFIG_ADXRS450 is not set
# CONFIG_BMG160 is not set
# CONFIG_FXAS21002C is not set
CONFIG_HID_SENSOR_GYRO_3D=m
# CONFIG_MPU3050_I2C is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
# CONFIG_AFE4403 is not set
# CONFIG_AFE4404 is not set
# CONFIG_MAX30100 is not set
# CONFIG_MAX30102 is not set
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
# CONFIG_DHT11 is not set
# CONFIG_ENS210 is not set
# CONFIG_HDC100X is not set
# CONFIG_HDC2010 is not set
# CONFIG_HDC3020 is not set
CONFIG_HID_SENSOR_HUMIDITY=m
# CONFIG_HTS221 is not set
# CONFIG_HTU21 is not set
# CONFIG_SI7005 is not set
# CONFIG_SI7020 is not set
# end of Humidity sensors

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
# CONFIG_ADIS16460 is not set
# CONFIG_ADIS16475 is not set
# CONFIG_ADIS16480 is not set
# CONFIG_ADIS16550 is not set
# CONFIG_BMI160_I2C is not set
# CONFIG_BMI160_SPI is not set
# CONFIG_BMI270_I2C is not set
# CONFIG_BMI270_SPI is not set
# CONFIG_BMI323_I2C is not set
# CONFIG_BMI323_SPI is not set
# CONFIG_BOSCH_BNO055_I2C is not set
# CONFIG_FXOS8700_I2C is not set
# CONFIG_FXOS8700_SPI is not set
# CONFIG_KMX61 is not set
# CONFIG_INV_ICM42600_I2C is not set
# CONFIG_INV_ICM42600_SPI is not set
# CONFIG_INV_MPU6050_I2C is not set
# CONFIG_INV_MPU6050_SPI is not set
# CONFIG_SMI240 is not set
# CONFIG_IIO_ST_LSM6DSX is not set
# CONFIG_IIO_ST_LSM9DS0 is not set
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
# CONFIG_ADJD_S311 is not set
# CONFIG_ADUX1020 is not set
# CONFIG_AL3000A is not set
# CONFIG_AL3010 is not set
# CONFIG_AL3320A is not set
# CONFIG_APDS9160 is not set
# CONFIG_APDS9300 is not set
# CONFIG_APDS9306 is not set
# CONFIG_APDS9960 is not set
# CONFIG_AS73211 is not set
# CONFIG_BH1745 is not set
# CONFIG_BH1750 is not set
# CONFIG_BH1780 is not set
# CONFIG_CM32181 is not set
# CONFIG_CM3232 is not set
# CONFIG_CM3323 is not set
# CONFIG_CM3605 is not set
# CONFIG_CM36651 is not set
# CONFIG_GP2AP002 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_ISL29125 is not set
# CONFIG_ISL76682 is not set
CONFIG_HID_SENSOR_ALS=m
CONFIG_HID_SENSOR_PROX=m
# CONFIG_JSA1212 is not set
# CONFIG_ROHM_BU27034 is not set
# CONFIG_RPR0521 is not set
# CONFIG_LTR390 is not set
# CONFIG_LTR501 is not set
# CONFIG_LTRF216A is not set
# CONFIG_LV0104CS is not set
# CONFIG_MAX44000 is not set
# CONFIG_MAX44009 is not set
# CONFIG_NOA1305 is not set
# CONFIG_OPT3001 is not set
# CONFIG_OPT4001 is not set
# CONFIG_OPT4060 is not set
# CONFIG_PA12203001 is not set
# CONFIG_SI1133 is not set
# CONFIG_SI1145 is not set
# CONFIG_STK3310 is not set
# CONFIG_ST_UVIS25 is not set
# CONFIG_TCS3414 is not set
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2591 is not set
# CONFIG_TSL2772 is not set
# CONFIG_TSL4531 is not set
# CONFIG_US5182D is not set
# CONFIG_VCNL4000 is not set
# CONFIG_VCNL4035 is not set
# CONFIG_VEML3235 is not set
# CONFIG_VEML6030 is not set
# CONFIG_VEML6040 is not set
# CONFIG_VEML6070 is not set
# CONFIG_VEML6075 is not set
# CONFIG_VL6180 is not set
# CONFIG_ZOPT2201 is not set
# end of Light sensors

#
# Magnetometer sensors
#
# CONFIG_AK8974 is not set
# CONFIG_AK8975 is not set
# CONFIG_AK09911 is not set
# CONFIG_ALS31300 is not set
# CONFIG_BMC150_MAGN_I2C is not set
# CONFIG_BMC150_MAGN_SPI is not set
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
# CONFIG_MMC35240 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set
# CONFIG_SENSORS_HMC5843_I2C is not set
# CONFIG_SENSORS_HMC5843_SPI is not set
# CONFIG_SENSORS_RM3100_I2C is not set
# CONFIG_SENSORS_RM3100_SPI is not set
# CONFIG_SI7210 is not set
# CONFIG_TI_TMAG5273 is not set
# CONFIG_YAMAHA_YAS530 is not set
# end of Magnetometer sensors

#
# Multiplexers
#
# CONFIG_IIO_MUX is not set
# end of Multiplexers

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m
CONFIG_HID_SENSOR_DEVICE_ROTATION=m
# end of Inclinometer sensors

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set
# end of Triggers - standalone

#
# Linear and angular position sensors
#
# CONFIG_HID_SENSOR_CUSTOM_INTEL_HINGE is not set
# end of Linear and angular position sensors

#
# Digital potentiometers
#
# CONFIG_AD5110 is not set
# CONFIG_AD5272 is not set
# CONFIG_DS1803 is not set
# CONFIG_MAX5432 is not set
# CONFIG_MAX5481 is not set
# CONFIG_MAX5487 is not set
# CONFIG_MCP4018 is not set
# CONFIG_MCP4131 is not set
# CONFIG_MCP4531 is not set
# CONFIG_MCP41010 is not set
# CONFIG_TPL0102 is not set
# CONFIG_X9250 is not set
# end of Digital potentiometers

#
# Digital potentiostats
#
# CONFIG_LMP91000 is not set
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
# CONFIG_ROHM_BM1390 is not set
# CONFIG_BMP280 is not set
# CONFIG_DLHL60D is not set
# CONFIG_DPS310 is not set
CONFIG_HID_SENSOR_PRESS=m
# CONFIG_HP03 is not set
# CONFIG_HSC030PA is not set
# CONFIG_ICP10100 is not set
# CONFIG_MPL115_I2C is not set
# CONFIG_MPL115_SPI is not set
# CONFIG_MPL3115 is not set
# CONFIG_MPRLS0025PA is not set
# CONFIG_MS5611 is not set
# CONFIG_MS5637 is not set
# CONFIG_SDP500 is not set
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_T5403 is not set
# CONFIG_HP206C is not set
# CONFIG_ZPA2326 is not set
# end of Pressure sensors

#
# Lightning sensors
#
# CONFIG_AS3935 is not set
# end of Lightning sensors

#
# Proximity and distance sensors
#
# CONFIG_HX9023S is not set
# CONFIG_IRSD200 is not set
# CONFIG_ISL29501 is not set
# CONFIG_LIDAR_LITE_V2 is not set
# CONFIG_MB1232 is not set
# CONFIG_PING is not set
# CONFIG_RFD77402 is not set
# CONFIG_SRF04 is not set
# CONFIG_SX9310 is not set
# CONFIG_SX9324 is not set
# CONFIG_SX9360 is not set
# CONFIG_SX9500 is not set
# CONFIG_SRF08 is not set
# CONFIG_VCNL3020 is not set
# CONFIG_VL53L0X_I2C is not set
# CONFIG_AW96103 is not set
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set
# CONFIG_AD2S1200 is not set
# CONFIG_AD2S1210 is not set
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_LTC2983 is not set
# CONFIG_MAXIM_THERMOCOUPLE is not set
CONFIG_HID_SENSOR_TEMP=m
# CONFIG_MLX90614 is not set
# CONFIG_MLX90632 is not set
# CONFIG_MLX90635 is not set
# CONFIG_TMP006 is not set
# CONFIG_TMP007 is not set
# CONFIG_TMP117 is not set
# CONFIG_TSYS01 is not set
# CONFIG_TSYS02D is not set
# CONFIG_MAX30208 is not set
# CONFIG_MAX31856 is not set
# CONFIG_MAX31865 is not set
# CONFIG_MCP9600 is not set
# end of Temperature sensors

CONFIG_NTB=m
CONFIG_NTB_MSI=y
CONFIG_NTB_AMD=m
# CONFIG_NTB_IDT is not set
CONFIG_NTB_INTEL=m
# CONFIG_NTB_EPF is not set
# CONFIG_NTB_SWITCHTEC is not set
CONFIG_NTB_PINGPONG=m
CONFIG_NTB_TOOL=m
CONFIG_NTB_PERF=m
CONFIG_NTB_MSI_TEST=m
CONFIG_NTB_TRANSPORT=m
CONFIG_PWM=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_CLK is not set
# CONFIG_PWM_DWC is not set
# CONFIG_PWM_GPIO is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_GPIO is not set
# CONFIG_RESET_SIMPLE is not set
# CONFIG_RESET_TI_SYSCON is not set
# CONFIG_RESET_TI_TPS380X is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_USB_LGM_PHY is not set
# CONFIG_PHY_CAN_TRANSCEIVER is not set

#
# PHY drivers for Broadcom platforms
#
# CONFIG_BCM_KONA_USB2_PHY is not set
# end of PHY drivers for Broadcom platforms

# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_CPCAP_USB is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
CONFIG_INTEL_RAPL_TPMI=m
CONFIG_IDLE_INJECT=y
# CONFIG_MCB is not set

#
# Performance monitor support
#
# CONFIG_DWC_PCIE_PMU is not set
# CONFIG_CXL_PMU is not set
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
CONFIG_AMD_ATL=m
CONFIG_AMD_ATL_PRM=y
CONFIG_RAS_FMPM=m
CONFIG_USB4=y
# CONFIG_USB4_DEBUGFS_WRITE is not set
# CONFIG_USB4_DMA_TEST is not set

#
# Android
#
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
# CONFIG_NVDIMM_SECURITY_TEST is not set
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_HMEM=m
CONFIG_DEV_DAX_CXL=m
CONFIG_DEV_DAX_HMEM_DEVICES=y
CONFIG_DEV_DAX_KMEM=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_LAYOUTS is not set
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
CONFIG_STM=m
CONFIG_STM_PROTO_BASIC=m
CONFIG_STM_PROTO_SYS_T=m
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
CONFIG_TEE=m
# CONFIG_AMDTEE is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
CONFIG_COUNTER=m
CONFIG_INTEL_QEP=m
# CONFIG_INTERRUPT_CNT is not set
# CONFIG_MOST is not set
# CONFIG_PECI is not set
# CONFIG_HTE is not set
CONFIG_DPLL=y
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
CONFIG_FS_STACK=y
CONFIG_BUFFER_HEAD=y
CONFIG_LEGACY_DIRECT_IO=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_SUPPORT_ASCII_CI=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DRAIN_INTENTS=y
CONFIG_XFS_LIVE_HOOKS=y
CONFIG_XFS_MEMORY_BUFS=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_SCRUB_STATS=y
# CONFIG_XFS_ONLINE_REPAIR is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_EXPERIMENTAL is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_F2FS_IOSTAT=y
# CONFIG_F2FS_UNFAIR_RWSEM is not set
# CONFIG_BCACHEFS_FS is not set
# CONFIG_ZONEFS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FS_VERITY=y
# CONFIG_FS_VERITY_BUILTIN_SIGNATURES is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_VIRTIO_FS=m
CONFIG_FUSE_DAX=y
CONFIG_FUSE_PASSTHROUGH=y
CONFIG_FUSE_IO_URING=y
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set
# CONFIG_OVERLAY_FS_DEBUG is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=y
CONFIG_NETFS_STATS=y
# CONFIG_NETFS_DEBUG is not set
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_ERROR_INJECTION is not set
# CONFIG_CACHEFILES_ONDEMAND is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
CONFIG_EXFAT_FS=m
CONFIG_EXFAT_DEFAULT_IOCHARSET="utf8"
# CONFIG_NTFS3_FS is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_TMPFS_INODE64=y
# CONFIG_TMPFS_QUOTA is not set
CONFIG_HUGETLBFS=y
# CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON is not set
CONFIG_HUGETLB_PAGE=y
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
# CONFIG_CRAMFS_MTD is not set
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_CHOICE_DECOMP_BY_MOUNT is not set
CONFIG_SQUASHFS_COMPILE_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_COMPILE_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_COMPILE_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_COMP_CACHE_FULL is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_ZSTD=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_RESCTRL_FS=y
CONFIG_RESCTRL_FS_PSEUDO_LOCK=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_COMPRESS=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_PSTORE_BLK is not set
# CONFIG_UFS_FS is not set
CONFIG_EROFS_FS=m
# CONFIG_EROFS_FS_DEBUG is not set
CONFIG_EROFS_FS_XATTR=y
CONFIG_EROFS_FS_POSIX_ACL=y
CONFIG_EROFS_FS_SECURITY=y
CONFIG_EROFS_FS_BACKED_BY_FILE=y
# CONFIG_EROFS_FS_ZIP is not set
# CONFIG_EROFS_FS_ONDEMAND is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFS_V4_2_READ_PLUS is not set
CONFIG_NFSD=m
# CONFIG_NFSD_V2 is not set
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
CONFIG_NFSD_V4_2_INTER_SSC=y
CONFIG_NFSD_V4_SECURITY_LABEL=y
# CONFIG_NFSD_LEGACY_CLIENT_TRACKING is not set
# CONFIG_NFSD_V4_DELEG_TIMESTAMPS is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
# CONFIG_NFS_LOCALIO is not set
CONFIG_NFS_V4_2_SSC_HELPER=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_AES_SHA1=y
CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_CAMELLIA=y
CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_AES_SHA2=y
CONFIG_SUNRPC_DEBUG=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_CEPH_FS=m
CONFIG_CEPH_FSCACHE=y
CONFIG_CEPH_FS_POSIX_ACL=y
CONFIG_CEPH_FS_SECURITY_LABEL=y
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
CONFIG_CIFS_SMB_DIRECT=y
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CIFS_COMPRESSION is not set
# CONFIG_SMB_SERVER is not set
CONFIG_SMBFS=m
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
# CONFIG_AFS_DEBUG_CURSOR is not set
CONFIG_9P_FS=y
# CONFIG_9P_FSCACHE is not set
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_NLS_UCS2_UTILS=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_HAVE_TRUSTED_KEYS=y
CONFIG_TRUSTED_KEYS_TPM=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_USER_DECRYPTED_DATA is not set
CONFIG_KEY_DH_OPERATIONS=y
CONFIG_KEY_NOTIFICATIONS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_PROC_MEM_ALWAYS_FORCE=y
# CONFIG_PROC_MEM_FORCE_PTRACE is not set
# CONFIG_PROC_MEM_NO_FORCE is not set
CONFIG_SECURITY=y
CONFIG_HAS_SECURITY_AUDIT=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_INFINIBAND=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
# CONFIG_SECURITY_SELINUX_DEBUG is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
CONFIG_SECURITY_LOCKDOWN_LSM=y
CONFIG_SECURITY_LOCKDOWN_LSM_EARLY=y
CONFIG_LOCK_DOWN_KERNEL_FORCE_NONE=y
# CONFIG_LOCK_DOWN_KERNEL_FORCE_INTEGRITY is not set
# CONFIG_LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY is not set
# CONFIG_SECURITY_LANDLOCK is not set
# CONFIG_SECURITY_IPE is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
CONFIG_INTEGRITY_PLATFORM_KEYRING=y
CONFIG_INTEGRITY_MACHINE_KEYRING=y
CONFIG_INTEGRITY_CA_MACHINE_KEYRING=y
CONFIG_INTEGRITY_CA_MACHINE_KEYRING_MAX=y
CONFIG_LOAD_UEFI_KEYS=y
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
# CONFIG_IMA_KEXEC is not set
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_NG_TEMPLATE is not set
CONFIG_IMA_SIG_TEMPLATE=y
CONFIG_IMA_DEFAULT_TEMPLATE="ima-sig"
# CONFIG_IMA_DEFAULT_HASH_SHA1 is not set
CONFIG_IMA_DEFAULT_HASH_SHA256=y
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha256"
CONFIG_IMA_WRITE_POLICY=y
CONFIG_IMA_READ_POLICY=y
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_ARCH_POLICY=y
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
CONFIG_IMA_APPRAISE_MODSIG=y
CONFIG_IMA_KEYRINGS_PERMIT_SIGNED_BY_BUILTIN_OR_SECONDARY=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT=y
# CONFIG_IMA_DISABLE_HTABLE is not set
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="lockdown,yama,integrity,selinux,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_BARE=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y
CONFIG_INIT_STACK_NONE=y
# CONFIG_INIT_STACK_ALL_PATTERN is not set
# CONFIG_INIT_STACK_ALL_ZERO is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
# CONFIG_ZERO_CALL_USED_REGS is not set
# end of Memory initialization

#
# Bounds checking
#
CONFIG_FORTIFY_SOURCE=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_DEFAULT_ON=y
# end of Bounds checking

#
# Hardening of kernel data structures
#
CONFIG_LIST_HARDENED=y
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Hardening of kernel data structures

CONFIG_RANDSTRUCT_NONE=y
# CONFIG_RANDSTRUCT_FULL is not set
# CONFIG_RANDSTRUCT_PERFORMANCE is not set
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SIG=y
CONFIG_CRYPTO_SIG2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_HKDF=m
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_SELFTESTS is not set
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_KRB5ENC=m
# CONFIG_CRYPTO_BENCHMARK is not set
# end of Crypto core or helper

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_DH_RFC7919_GROUPS=y
CONFIG_CRYPTO_ECC=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_ECDSA=y
# CONFIG_CRYPTO_ECRDSA is not set
CONFIG_CRYPTO_CURVE25519=m
# end of Public-key cryptography

#
# Block ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
# CONFIG_CRYPTO_ARIA is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SM4=m
CONFIG_CRYPTO_SM4_GENERIC=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# end of Block ciphers

#
# Length-preserving ciphers and modes
#
CONFIG_CRYPTO_ADIANTUM=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_HCTR2 is not set
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_NHPOLY1305=m
# end of Length-preserving ciphers and modes

#
# AEAD (authenticated encryption with associated data) ciphers
#
# CONFIG_CRYPTO_AEGIS128 is not set
CONFIG_CRYPTO_CHACHA20POLY1305=m
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_GENIV=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m
CONFIG_CRYPTO_ESSIV=m
# end of AEAD (authenticated encryption with associated data) ciphers

#
# Hashes, digests, and MACs
#
CONFIG_CRYPTO_BLAKE2B=m
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
CONFIG_CRYPTO_SM3_GENERIC=m
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_XXHASH=m
# end of Hashes, digests, and MACs

#
# CRCs (cyclic redundancy checks)
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32=m
# end of CRCs (cyclic redundancy checks)

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
CONFIG_CRYPTO_ZSTD=m
# end of Compression

#
# Random number generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_JITTERENTROPY_MEMORY_BLOCKS=64
CONFIG_CRYPTO_JITTERENTROPY_MEMORY_BLOCKSIZE=32
CONFIG_CRYPTO_JITTERENTROPY_OSR=1
CONFIG_CRYPTO_KDF800108_CTR=y
# end of Random number generation

#
# Userspace interface
#
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
# CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE is not set
# end of Userspace interface

CONFIG_CRYPTO_HASH_INFO=y

#
# Accelerated Cryptographic Algorithms for CPU (x86)
#
CONFIG_CRYPTO_CURVE25519_X86=m
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES3_EDE_X86_64=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
# CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_ARIA_AESNI_AVX2_X86_64 is not set
# CONFIG_CRYPTO_ARIA_GFNI_AVX512_X86_64 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_NHPOLY1305_SSE2=m
CONFIG_CRYPTO_NHPOLY1305_AVX2=m
# CONFIG_CRYPTO_POLYVAL_CLMUL_NI is not set
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
# CONFIG_CRYPTO_SM3_AVX_X86_64 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m
# end of Accelerated Cryptographic Algorithms for CPU (x86)

CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
CONFIG_CRYPTO_DEV_QAT_4XXX=m
# CONFIG_CRYPTO_DEV_QAT_420XX is not set
# CONFIG_CRYPTO_DEV_QAT_6XXX is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
# CONFIG_CRYPTO_DEV_QAT_ERROR_INJECTION is not set
CONFIG_CRYPTO_DEV_IAA_CRYPTO=m
# CONFIG_CRYPTO_DEV_IAA_CRYPTO_STATS is not set
CONFIG_CRYPTO_DEV_CHELSIO=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS8_PRIVATE_KEY_PARSER=m
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y
CONFIG_FIPS_SIGNATURE_SELFTEST=y
CONFIG_FIPS_SIGNATURE_SELFTEST_RSA=y
CONFIG_FIPS_SIGNATURE_SELFTEST_ECDSA=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_MODULE_SIG_KEY_TYPE_RSA=y
# CONFIG_MODULE_SIG_KEY_TYPE_ECDSA is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
CONFIG_SECONDARY_TRUSTED_KEYRING=y
# CONFIG_SECONDARY_TRUSTED_KEYRING_SIGNED_BY_BUILTIN is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# CONFIG_SYSTEM_REVOCATION_LIST is not set
# CONFIG_SYSTEM_BLACKLIST_AUTH_UPDATE is not set
# end of Certificates for signature checking

CONFIG_CRYPTO_KRB5=m
# CONFIG_CRYPTO_KRB5_SELFTESTS is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
# CONFIG_RAID6_PQ_BENCHMARK is not set
CONFIG_PACKING=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=m
CONFIG_PRIME_NUMBERS=m
CONFIG_RATIONAL=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_UTILS=y
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_AESCFB=y
CONFIG_CRYPTO_LIB_AESGCM=y
CONFIG_CRYPTO_LIB_ARC4=m
CONFIG_CRYPTO_LIB_GF128MUL=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S=y
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=y
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519=y
CONFIG_CRYPTO_LIB_CURVE25519_GENERIC=m
CONFIG_CRYPTO_LIB_CURVE25519_INTERNAL=m
CONFIG_CRYPTO_LIB_CURVE25519=m
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=y
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m
CONFIG_CRYPTO_LIB_POLY1305=y
CONFIG_CRYPTO_LIB_CHACHA20POLY1305=y
CONFIG_CRYPTO_LIB_SHA1=y
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD=y
CONFIG_CRYPTO_LIB_SHA256_GENERIC=y
CONFIG_CRYPTO_LIB_SM3=m
CONFIG_CRYPTO_BLAKE2S_X86=y
CONFIG_CRYPTO_CHACHA20_X86_64=y
CONFIG_CRYPTO_POLY1305_X86_64=y
CONFIG_CRYPTO_SHA256_X86_64=y
# end of Crypto library routines

CONFIG_CRC_CCITT=y
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_ARCH_HAS_CRC_T10DIF=y
CONFIG_CRC_T10DIF_ARCH=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_ARCH_HAS_CRC32=y
CONFIG_CRC32_ARCH=y
CONFIG_CRC64=y
CONFIG_ARCH_HAS_CRC64=y
CONFIG_CRC64_ARCH=y
CONFIG_CRC8=m
CONFIG_CRC_OPTIMIZATIONS=y
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMMON=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_ARM64=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_RISCV=y
# CONFIG_XZ_DEC_MICROLZMA is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_INTERVAL_TREE=y
CONFIG_INTERVAL_TREE_SPAN_ITER=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS_HELPERS=y
CONFIG_NEED_SG_DMA_FLAGS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_SWIOTLB=y
# CONFIG_SWIOTLB_DYNAMIC is not set
CONFIG_DMA_NEED_SYNC=y
CONFIG_DMA_COHERENT_POOL=y
CONFIG_DMA_CMA=y
# CONFIG_DMA_NUMA_CMA is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_DIMLIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_GENERIC_VDSO_OVERFLOW_PROTECT=y
CONFIG_VDSO_GETRANDOM=y
CONFIG_GENERIC_VDSO_DATA_STORE=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACKDEPOT_ALWAYS_INIT=y
CONFIG_STACKDEPOT_MAX_FRAMES=64
CONFIG_SBITMAP=y
CONFIG_PARMAN=m
CONFIG_OBJAGG=m
# CONFIG_LWQ_TEST is not set
# end of Library routines

CONFIG_PLDMFW=y
CONFIG_ASN1_ENCODER=y
CONFIG_POLYNOMIAL=m
CONFIG_FIRMWARE_TABLE=y
CONFIG_UNION_FIND=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
# CONFIG_STACKTRACE_BUILD_ID is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_AS_HAS_NON_CONST_ULEB128=y
# CONFIG_DEBUG_INFO_NONE is not set
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_DEBUG_INFO_COMPRESSED_NONE=y
# CONFIG_DEBUG_INFO_COMPRESSED_ZLIB is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_PAHOLE_HAS_LANG_EXCLUDE=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_HEADERS_INSTALL=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B is not set
CONFIG_OBJTOOL=y
# CONFIG_OBJTOOL_WERROR is not set
# CONFIG_VMLINUX_MAP is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS_STRICT=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS_STRICT=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
# CONFIG_UBSAN_BOOL is not set
# CONFIG_UBSAN_ENUM is not set
# CONFIG_UBSAN_ALIGNMENT is not set
# CONFIG_TEST_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
CONFIG_HAVE_KCSAN_COMPILER=y
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
# CONFIG_NET_NS_REFCNT_TRACKER is not set
# CONFIG_DEBUG_NET is not set
# CONFIG_DEBUG_NET_SMALL_RTNL is not set
# end of Networking Debugging

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_RCU_DEBUG=y
CONFIG_PAGE_OWNER=y
# CONFIG_PAGE_TABLE_CHECK is not set
CONFIG_PAGE_POISONING=y
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
CONFIG_DEBUG_WX=y
CONFIG_ARCH_HAS_PTDUMP=y
CONFIG_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_PER_VMA_LOCK_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SHRINKER_DEBUG is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VFS is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_MEM_ALLOC_PROFILING is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
# CONFIG_KASAN_EXTRA_INFO is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
CONFIG_HAVE_ARCH_KMSAN=y
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_SOFTLOCKUP_DETECTOR_INTR_STORM is not set
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_HAVE_HARDLOCKUP_DETECTOR_BUDDY=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_HARDLOCKUP_DETECTOR_PREFER_BUDDY is not set
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
# CONFIG_HARDLOCKUP_DETECTOR_BUDDY is not set
# CONFIG_HARDLOCKUP_DETECTOR_ARCH is not set
CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_DETECT_HUNG_TASK_BLOCKER=y
CONFIG_WQ_WATCHDOG=y
# CONFIG_WQ_CPU_INTENSIVE_REPORT is not set
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

# CONFIG_NMI_CHECK_CPU is not set
# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_MAPLE_TREE is not set
# end of Debug kernel data structures

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_SCALE_TEST is not set
CONFIG_RCU_TORTURE_TEST=m
# CONFIG_RCU_TORTURE_TEST_CHK_RDR_STATE is not set
# CONFIG_RCU_TORTURE_TEST_LOG_CPU is not set
# CONFIG_RCU_TORTURE_TEST_LOG_GP is not set
CONFIG_RCU_REF_SCALE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
# CONFIG_RCU_CPU_STALL_CPUTIME is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_DEBUG_CGROUP_REF is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FREGS=y
CONFIG_HAVE_FTRACE_GRAPH_FUNC=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_REGS_HAVING_PT_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_NO_PATCHABLE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_OBJTOOL_NOP_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_BOOTTIME_TRACING=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_FUNCTION_GRAPH_RETVAL is not set
# CONFIG_FUNCTION_GRAPH_RETADDR is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_FPROBE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
CONFIG_TRACE_PREEMPT_TOGGLE=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
CONFIG_OSNOISE_TRACER=y
CONFIG_TIMERLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_FPROBE_EVENTS=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_BPF_KPROBE_OVERRIDE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
# CONFIG_USER_EVENTS is not set
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_VALIDATE_RCU_IS_WATCHING is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_FTRACE_SORT_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_DA_MON_EVENTS=y
CONFIG_DA_MON_EVENTS_ID=y
CONFIG_RV=y
# CONFIG_RV_MON_WIP is not set
CONFIG_RV_MON_WWNR=y
# CONFIG_RV_MON_SCHED is not set
CONFIG_RV_REACTORS=y
CONFIG_RV_REACT_PRINTK=y
CONFIG_RV_REACT_PANIC=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_KCOV=y
# CONFIG_KCOV is not set
# CONFIG_RUNTIME_TESTING_MENU is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage

#
# Rust hacking
#
# end of Rust hacking
# end of Kernel hacking

CONFIG_IO_URING_ZCRX=y

--y6lvXpVbwxqtoTpt
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg-CONFIG_PREEMPT_TRACER.xz"
Content-Transfer-Encoding: base64

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
eC/SVB36zZTVjSxlZAjvUvyayaRWmYUVpWzYdjLSglkLNhbvc2m4DKOotbeNfdd2eAKbhh3lyZq4
f2M1e2U3363/PN2inObRy4+8xmFpOaEJ7ZSQxtGdVnWpyPCdIuLzfmpDijWc/IdsLNRbCuOmb/Hq
+lK8KY9o+aUFzpgSyPsipc1382kiW8L037y4WKQXe/7eRar2Rj1u1D9vUayJILqaJ2EYepa+GZtG
F9gqy8xpdUGLES4rrYuvfvlGQNwEpo38UT2Oq6ZXdaY0ztf+bLGZSjyzzRbDWrDZ8MyrsAJCrjiQ
ApM6V8U3B+4/Awg+k/CDbBpOGis//RYZipjLV1hpsTDDplwSt7pfoC7U+TmeAtS5KAG6OSjNKme2
Zx8rcdCFkHw2bYIayVagM9iMWa8aY7X6LEAhB1GZRmPhBqbpEhh8T20azUWA0me66oev08VxnaVS
0z0hIr3aOcXOf7Q+i8S34hXP8glbUzDWl7wJS+IUrtaICKe7lhdOmWksDF2O1sFr7tjL9sw3Duqk
zBdH7cu7joSPxX9GKoeu2IUHXl56OD5K50bIvictmzp9yQgoOAaUSEMrlCNPKpKUB57h/NHZahuj
YERAmfeWHYYyqdfoZ7R7CxaF26C8azSHjpIbL5io6Zir5gtRYEQkXJ9P+P/91rL8J0AnTxom18+b
Ts6/YcCazEiel2fbUAHmUz2wNf20tFAyaU8d+mHThYpl+PFs6kFMZohIDeXRsMGo/E5QycREh6q1
P9jDji6Trn3bu7jnUc0rupLlf7gBSQJfqXm2tIhIx6xRr/bEGe3rT9DZIPxeQDOBZXfZLaWZBmtr
eyBAKfV16h5lvJabMVXijNfV2lkgxgymy3TnMIocEyU16k0bDzFfj/ktWtr1SEpdSjUi2Ejoy2L7
xRtDCD+ECo709O/8r+6/AVXl0JL+HIE95SoCSHAGvVJEbLMFAUNDL5xTGuBb5uHFibX3S3cQUjIo
vdQ2E2RFjB2clm8JY2fhecQpLs9W86GeBI7XmXdsVAKwrn8OMir5Kg3uDtmrpVIiuCiCM/bjv9X2
QKlq4c/Q02/+vB2p0StxKsqtsaFDYRkz8H3QTtJQ8ZzyQrUhdxd8D/chFXuWIDe9n+nbi7abA1op
D2Z4kMxp73isTJurJHc3cv7Cg92/oYQXlkexnSgmCXHCFNcSjaH8Hw/aRY21qHn3IkNLFiqInNY6
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

--y6lvXpVbwxqtoTpt--

