Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C622ECA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 13:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E3E6B000C; Sat, 30 Aug 2025 09:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735A86B000D; Sat, 30 Aug 2025 09:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624396B0010; Sat, 30 Aug 2025 09:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE1A6B000C
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 09:00:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01C0D1163EE
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 13:00:33 +0000 (UTC)
X-FDA: 83833432788.16.9846989
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D827A0015
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 13:00:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jl5U12ly;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of philip.li@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=philip.li@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756558830; a=rsa-sha256;
	cv=fail;
	b=5rg1KZutBXgUY1aLGq8H/on8HnlDYTJLhJI9nyO/0hGTWIJI1qEjnUsPkJ2ET2gKug9fG0
	SA1y/z9vNLdPWVQ9JvsTXAO8eT0wIkJYFsS8rgtltl36pAt2z3Ipn3xMHPuKXj2Mv0Cyvf
	hUC6iDsCgfaa3xccckkFXVVsLeLkNZc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jl5U12ly;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of philip.li@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=philip.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756558830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+ZpNvtM4M5LEepTy6V00tYER6nvPVd8I5nTOpKARIA=;
	b=ipHzU9HJrc4XuHlYXL1yUoasWg++dsXk/jmp8hnTotxf9vIrUIxWdG+eDN36kU0ED+np4+
	hcE8dLlKWEx2ZbQmOrSwBorDfk7tyIPKuZGhFyHqnQOgMDMkia3uQieANoc8Q3w3KtRy+E
	CzZfxf5pW3fq3ezhgmQsITn7OwVvjiM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756558829; x=1788094829;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aSiMlIndEl1aDrWY7bs4sOB/enULzJ62cKOLwFav69M=;
  b=jl5U12lyTcvnQ8IvyKHSkt1NhF0lZgQlUdNKh4trNG3gAQ3wDPlk+ywg
   PoEHanaARUP6C3wGX4+UKWT0aTn1GlpCKV48eIsqfBTEOuPkN1pNPxufG
   krKQXikgIt443Hd57ai+QclJRgk5IXN9Q9qlgmF2LqUMaza4elN8AGwoc
   0+2+gYziPRNVGOjvf/HCjaORYbOt39wA7Re7ol8BkRC3ma8mPTqeGGmEN
   9fgIsoz1WU+JGgez6DXGodmuphghm6Dod7kAf6C0BRqkakuvDvWLqLGA1
   Tjmr9MPWnvxS2T4ta2EmqjY2dKIGBRqEuYamKg01oJXGF/QpQ2/dizSoM
   g==;
X-CSE-ConnectionGUID: AkddUUO4Q2WbH9shi1DffQ==
X-CSE-MsgGUID: EwlVlvhFSL6W8kq8wd5cyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="58533945"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="58533945"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2025 06:00:28 -0700
X-CSE-ConnectionGUID: 85rgqwL9QSSlT1nFehNWLQ==
X-CSE-MsgGUID: ILJqGBM5Rs6NlmD6PfehUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="170491302"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2025 06:00:28 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sat, 30 Aug 2025 06:00:27 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sat, 30 Aug 2025 06:00:27 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.82)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sat, 30 Aug 2025 06:00:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E/RHiWk1XDoQdBGg4InxDWf9/YFjbPUAeH6n6Ew710MDri8aSvniNKeIrwKmcrGROz8EBvSFnCwivlHAXubzUtAD+uneqjYVQFoTQt47FqKJB1d0gPAkUH0DGv9KySkbnNOnjNrLwyWgIi4VH1tcKFE0W7+fOqwCVvasG+yLIEZPgAV8pcgk0pk+A7yU2V++7F4RHgFUxqdqmo0kPdCJhE8EmBgRp9GUTOPkwUGyjJ7/7bv7elrn8NGRIjU+iZxPLLFBmx5bxsTZpbhJRbRhNR70M5m+Me9sa4h3h9Vkmi+JVZw+3G5Q8b0CchawvjN7b45OXWoGIZB6+y8g2TIH5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+ZpNvtM4M5LEepTy6V00tYER6nvPVd8I5nTOpKARIA=;
 b=Si0wPCYI+YwX4MMB930U49b8BgoHDvI6r0ZJKtdO3xssGyi4jFaZHZHWLbGpnBqBhqm/s+G/zYOqELdf8KLCpw+3Dal97VhXUkmIxlOZTWyCj7bXNeMqMtFrfM4muAgVH6qUEgClfEwJ+462OPzn7BIqaWPyU0dteBkXPn7TeJER3JCLpRuRt2rldrpwqEZTCLNibTcDVube7k1mTu9HHxSCLxz5xRyLeroIdyd7vIq08q4qlRFG26ZS/AF7FuySHi3xrgbWRRcpxh0IofAVhndv/sZTDqGlpueVNNQ4yPMtSjK1jmO2ph4JbwA3iGAPLYosFoI2ioAcoLUO3e4h5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5680.namprd11.prod.outlook.com (2603:10b6:a03:305::9)
 by MN2PR11MB4647.namprd11.prod.outlook.com (2603:10b6:208:262::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Sat, 30 Aug
 2025 13:00:24 +0000
Received: from SJ0PR11MB5680.namprd11.prod.outlook.com
 ([fe80::7c8f:9ea5:5982:1a5b]) by SJ0PR11MB5680.namprd11.prod.outlook.com
 ([fe80::7c8f:9ea5:5982:1a5b%6]) with mapi id 15.20.9073.021; Sat, 30 Aug 2025
 13:00:24 +0000
Date: Sat, 30 Aug 2025 20:59:50 +0800
From: Philip Li <philip.li@intel.com>
To: Matthew Wilcox <willy@infradead.org>
CC: kernel test robot <lkp@intel.com>, <llvm@lists.linux.dev>,
	<oe-kbuild-all@lists.linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 166/188] arch/arm/mm/flush.c:307:41: error:
 incompatible pointer types passing 'memdesc_flags_t *' to parameter of type
 'volatile unsigned long *'
Message-ID: <aLL1xhAgCtFy4HWQ@rli9-mobl>
References: <202508181807.zhZF5TQ0-lkp@intel.com>
 <aKMZbtsa4msTYAuo@casper.infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aKMZbtsa4msTYAuo@casper.infradead.org>
X-ClientProxiedBy: SG2PR04CA0172.apcprd04.prod.outlook.com (2603:1096:4::34)
 To PH0PR11MB5674.namprd11.prod.outlook.com (2603:10b6:510:ec::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5680:EE_|MN2PR11MB4647:EE_
X-MS-Office365-Filtering-Correlation-Id: 29143d91-ca9b-403e-0cc6-08dde7c52373
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OirTv+qbKUP6umUmYSd0HZwvwg8T1sJ7OhHWDlluhbR2TwUGwEiehwqGL7//?=
 =?us-ascii?Q?qyw/NvuiUfpp/ON438a/qTP6v8aywztCJdTBLpD75dnvJn8nPY/7loBesu8Y?=
 =?us-ascii?Q?pkMeDn1/94W3DftzgD7pkI5NrHDeLcn89Qe1ih/uKUvtTuLxZWHz89qLUV10?=
 =?us-ascii?Q?Ua6vlFtVSK/vk1TnbzG70QRz90UA/Fg26+uW8honRmsF6CcUzolbZ2Lz/1k1?=
 =?us-ascii?Q?1yo+oaOG+ILsy67YRLDphqw9Nr7Im128HKqRGWtWajwG3qZ/FWJNZSOQzQXN?=
 =?us-ascii?Q?EQjyvZwaA7GnUvjYkA7HV1vqwS5CVjJ+Av+RnumSx2kQdsrGRc5fQZiV0m0O?=
 =?us-ascii?Q?98cYkL0KkEBF1+HqR3lnw0MhY6tIhUFOrsfB3DPxA6G6KFlpBxqCBLHuNtFO?=
 =?us-ascii?Q?Is5dPaeNk+4L5AL7z8EhvStc11/peWCrvNnAKWh4nllkjoXeyPmVWE0Qq+p+?=
 =?us-ascii?Q?TbXIJZkNKz5Bs0VurbEs2crFI5zz4DKvQRseOPvZjuNpXv0l1Mkf089EF90F?=
 =?us-ascii?Q?qtYGOnGwm3HG/urX1/6m0Xj3YFrxIcWSQBD1q6t9peYJ1CLPyvORDanYvw83?=
 =?us-ascii?Q?sj1r9vC68kXE//Lfr/W/AmVdO7YyoE1B80ZsX8PAkgDNNBd3VuZved7Q4Ksr?=
 =?us-ascii?Q?cQH+ImXtsiHk/bN+JrXRYnlbxfsH0db1y/Mv6sgOkb7ANZ3Fz1PK9WVaQH+P?=
 =?us-ascii?Q?FF2uWZx4BQsISLaJcm9u21eozHuCdp8YARdZIDlCgYnAG6sxARrSkRvqUFja?=
 =?us-ascii?Q?GZ05VezM8MaoQvpwqsYuoEAoWsK7CPm5MmLPxdc4MC4u6XcqzO9pb2E+Gq0g?=
 =?us-ascii?Q?aV6rFB/zU41Svthf4yIz+hUb73tt8aKPXT9iMoQOkRTjbwI9fwtQlPQ3OkrF?=
 =?us-ascii?Q?/YwhCeqPTrAu7qrCMdSiBejlx8kYyaqcz1uV8U+oIBozEgiiitEQ5Uk5vdZA?=
 =?us-ascii?Q?RCDthhZ8bfyoBVDpFin1deObd/pcRRYmiDacM0kGxzErdUOLINeBFd1yYqyd?=
 =?us-ascii?Q?qtvu9PcvUJKoLCKz03+lkBlXHYAmZOrcc4558QDfxfn8iEKOV4nbjVZa/MFY?=
 =?us-ascii?Q?Ilke5kVPj9PYJs1ACYoJTvksOZ/ev7z8KL08FY7xsYYc5RxWbjoDTYnn+vVi?=
 =?us-ascii?Q?GqYNnWzMRQDlqi5GTsgkExPq322O69TOEpcy4GQ5Z3KfIoYDItNN/X4OI7mj?=
 =?us-ascii?Q?fxUJGS6yyrf3zhHsczsCo0U7YSkDcsmoqkWBNzyfRGmfjWCyrLLzptC1MsdA?=
 =?us-ascii?Q?l4XbG4CRhhfn881oOsZpdqPBKKAaS9sroZYlTsc4L7kxYy0GdwW23V4POdHy?=
 =?us-ascii?Q?RX19O6d/K5gtqctMTeqKCsERbfxY14gNoX5ZQEMirZLOSIY0bUfn260FRk3n?=
 =?us-ascii?Q?nzwmb9U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5680.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G9r2ZDGB6+UjhM1QEzq5HzkPeVoZwShxzWTfQvGTn4S7OJJ+L56aadkbauzP?=
 =?us-ascii?Q?jFot+j2ddru/yYQAeluvC+4iVT1FW8aMKOSpyBrzG69Qp6VfSzzYZn16rVX/?=
 =?us-ascii?Q?RQm6d6zt1S8sMrYbLuIsAO+E6GeL1toEpydYkbBgMLKP4qx4n8GTzViE+RJl?=
 =?us-ascii?Q?MiQCt6iI3Ii3i0rRWZO51DW2xnopoXvVojgJVIhMo5yoyXbZzOcdKiezPYdP?=
 =?us-ascii?Q?/Q7/4MOJGHZ68tdB4goEs6wqg8VUsPW6VE1wjfl9pWdYppwDO44Zyqbi+XY6?=
 =?us-ascii?Q?purJLJ/pZH+dlndo30L72apCydIULPwL+R9hP5q+flcJkeZQOBm2204Wg+Zx?=
 =?us-ascii?Q?Z0mhCnC9F1GG8QqGwlmph4JrZappbjy8FuoWhR4ZTG8Xu2PVsv33250sYZ2a?=
 =?us-ascii?Q?kyC9L8VZ7lEnB++NcnaPeBOHW/ksyNJagU9j4p6M1EPiRy675K3kdwXhRvcq?=
 =?us-ascii?Q?wwfd0fRkWo2tHSnBDCqe3UDEsYQ7Gi9+DYGO3RDEzKZozcekbBBJJMy+0usz?=
 =?us-ascii?Q?MEnNt/44HVKJHLH95iASrJEuFpOZiTsvjK8GpWJf+F51w0utNwwYLP4MI/Jm?=
 =?us-ascii?Q?BIT/5U2ZCbup1zCdY/ZjCh/W7i766lwHU9zVylL3m84WLY+Y9fxk5U4clNz6?=
 =?us-ascii?Q?GZTmNxdvE/WD8muu79ka5/mR+hErhDZzwqhlp3nL2lhdHRFJA+4e3TCO+uWq?=
 =?us-ascii?Q?JnZoU9oUXWTOUAQCSwB5wzSw0FvyfA1zXE3GUzP/FfkW9rLIGspKkNUWiFJj?=
 =?us-ascii?Q?EIZZV5yC9ql5aFfnGnd9y3tdpMqOLPsxECQ+3sbzxzKHglQVQGefmXMoKoA6?=
 =?us-ascii?Q?BvT2cRX2JgDIbhyarD7qcUG44VFwLANW/zqVBwaGvQLuL2kOlPNIdMRhUAsC?=
 =?us-ascii?Q?8k1R2UBu7hJ70+yL58h0uRrE+LABxG1GjK8MgSoxczekJmLZbssIRQw6Btvn?=
 =?us-ascii?Q?hpAU2DeViUtlnJeKGw8J6bV3hfRKZAUkYd7aRWa1A0XamF16ZHF39uKIX11F?=
 =?us-ascii?Q?qMjOOb/9FqWyPJtepJMCHlMQrfRDf481Gxcm++vBiIZmKiUcVP+n4Pql8nLL?=
 =?us-ascii?Q?237QPx0Vvn+cL0uaFysWh8bIXaaE/eyyv2vZx57gz/wPt8xGi/dO0gWVq9ki?=
 =?us-ascii?Q?G22tUwIan14hXumhIWBu0kISHfw5+l2RUPzOM6Ug2MM7xNGf50d4iBjdDwJm?=
 =?us-ascii?Q?JI1qfR2AKNhHApnS8M0gFUXsc5upzMCEw3Oj2eaYf68AkaiGieONtQcwnR8E?=
 =?us-ascii?Q?sCC0qAZDzG9+XIWz6G5gZ5f9DPS6d0GRshp0aCpYdRYgAgWqVv6hRw2sFPBu?=
 =?us-ascii?Q?uoGGA1YJc3hyneo9zdbBq75it/cV2TSZBnh3j7iF+uIbLlfcOXJIGUp3pRnb?=
 =?us-ascii?Q?1vDVesdHs4t/QB1RZKMZyX77T58JQZrvPQeWDC5z2vg506gwmjxXtTRS5jr5?=
 =?us-ascii?Q?DEi+zQDYIIFor+qI6sOShhl4aYxkndhnkCdzyb5hJXOCHCS6Qta9RAgdl7hC?=
 =?us-ascii?Q?MO8UOiaG6HnjNH8b343WTGwt1+ri3YzLsmVBEs9SMSIsHhhOlj2eOt+tf0fQ?=
 =?us-ascii?Q?y7bQ6+BsqEyrSeXgUXpSTMxXV5qhiVx5BMtVqr3y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29143d91-ca9b-403e-0cc6-08dde7c52373
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5674.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2025 13:00:24.2762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8v+qIunRJbG2UWdWas5PgM6J4PlozJJ9f0aIepRlXhHZuqbTR6OXi9xCUX3NZTTEbCCcwk+mETVrwg6v5G6G3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4647
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D827A0015
X-Stat-Signature: tqe9mw6few8f8bkxbeercwxsr1mxmky9
X-HE-Tag: 1756558829-541900
X-HE-Meta: U2FsdGVkX19xt7PJilknEDZnSa1+TdLbQN5XDEYzfROcJWLrncUpjVrD41PZnjRVHeAdyGJ7SYojLU37RdnUjxOoQaWDujDiSe58TPPOkJd5ZuyLlJbNGvuPRLWH/uVvHQKZxNEPikElLUKaY6HaAQUKFCQ83ZVPlQGxOWH5l7ep8kpirVOuG91lEyo2AQBqnQ6BnzofkIJsdW+FBeq32+HcRXHjxyQb+UA4DBFxv7NC/7hOPJOiLuvN2C6X1s7GH9r8brHY1sCnKrsq9T7EU8HARnAYmU+KY97XfuH2/cQAhsAbihac+WzCw+fL9B7VHpIidr6ioRiSVQ+Kp8OxJOW3wC7/BklfN9CVboVZnAzIKB1dZ5b1Kq5P/ld3cmU5XDvkeXb+1NE1FqjGGGNapT5NxbtrU4Oq8UaXwbofy8RNTFaEM4oviewPhxoEeGdthVpsz9RGfkPXMNMN3PKxzvYillGzC7pf8aIILupzKdPGEWjXXqq+daOSqj3QOSZAzWjAmbOvllTEIVeMew2F+8VqipwcHJF0isW81L0MRm0fAT1/nhJJW83AfY/nWk9jr6SRzKJdU1nrQ0e6s41BILsJyrt2YHdz1w7Jk2zz64397O/7K83TZR38Vji0xKVQXMdjSv56Q9hQRaW0vQxl+WKQI8eSgnUFlCnQVva40DHiatL3xfZdKPj9AZ8bRT6mvmfQwuHrQop/dFpkEtSknd3amWluKJCVNY2Uh52iW7bDX1ytXEYRpECvKERo2H3PgJ+3L2XQJUKh+fRRKwL2ZtBY8ksvAIFRafi/DRJgE8+mVBZneZaEu1QgbJD/0MQekw6ZMhZs2XePnck/v/pVGvIXgqz7qpaZaqlKc2FJgtQTsneWAMvLM4gnjiujF9J/2D+E9MUeiuUKnizeB8LG/Ta23qNbyzpMDOEhT60PVRKXM6WPJU1kB2lsWKwyT7jpTADf5yHqJjm52cHULLI
 kuFmVHUo
 7/CPQth/00PfglVB6OHLbmuz2/yAmcjf8AhPAF5lBpnbgMH7EEBFa5v9mG9/2UQhSbgZ3jDheILRVFp3t7pTnelo91c3D514kMb7Q9f+GyCyWkVDh+Z2RmrTxNsJT+WMWT+jc5VzVW8ej5uTem2TfpSEisy5W39Btk51yizLHxNQKJCV8i0DzoxoCBFtOAftoh7WrETEjHAow1UC7Cvj7CvJ9d4R3NxkuVoypqbscE5ixP8eAEWRC0rKPDQkorrdcSge2BbkUQdOPmxArW/YDIGu/XHxxFMkzyK7JAoJr1hMuN7joCt+m18yOuKLY8nXDWfOSubzAu8ZkPQEmfCFeAlp3WYYF4eG6VXJDt1qhqcAp0Nz2X8sJZQwj5kVxwfDt7gccUhcc08b8/1ePlsQEMBRNT9sIbleXF26mE0UGGjSQ7/uosXXew9nUCzeOP+sdj6LuatCTfdzKxMb6hVj8iouzUOOJvOq/EKaM6UuB2tJWOXBZzlHEibPNCAKx84VMy7RdjUa32dlh/XHExCvW9QqKwumiXmYsSNSoetPwb/qRi1vu4k4mPytdP4urdsL1VBsonWTFPRWCUM8H/ptWMtWDbEw1eb82pjrPFW1NK2FaKxHa4eSijcnKibMXmBFUoZUHveHxQr6HlDcBZx1dqtD4mma+Zr/8abCecTDLJ7L5Uweo8L1+XBDg113HGQAoShwd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 01:15:42PM +0100, Matthew Wilcox wrote:
> On Mon, Aug 18, 2025 at 06:17:13PM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   dd1510cefdfec9dc3fa2bae40e0f16f1bf825567
> > commit: a2004477b3282318589bf43a786d952856adcaee [166/188] mm: introduce memdesc_flags_t
> 
> I've had this commit sitting in
> https://git.infradead.org/?p=users/willy/pagecache.git;a=shortlog;h=refs/heads/folio-page-split
> for over two weeks now.  Are you no longer testing pagecache.git?

Sorry for the late response. There's issue in the bot that causes failure
to fetch from git.infradead.org for quite long time, which is not noticed.

It is fixed now, and we will be more careful to monitor the status of each
possible issue. Sorry about this.

> 
> (the fix is trivial, I'll send it)
> 

