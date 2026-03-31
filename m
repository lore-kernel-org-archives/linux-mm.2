Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDEE2FF60EC
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7EC6B008C; Tue, 31 Mar 2026 04:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AFBF6B0095; Tue, 31 Mar 2026 04:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F706B0096; Tue, 31 Mar 2026 04:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08B066B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:28:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 742D4140BF6
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:28:33 +0000 (UTC)
X-FDA: 84605681706.24.766810A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf03.hostedemail.com (Postfix) with ESMTP id 31CEC2000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:28:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AttmEWPU;
	spf=pass (imf03.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774945710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=jgR98h6a+iSMQ8yoMDzUNCO7/kgnIEhs9ybF3vZX12I=;
	b=mSuwz/XKWdlPcu+5MRYJEh1OsaYGZKdtBP/8sUXWibJRSM1e7feGHMDk9x8jE/gR2P9pYj
	ov9bQD6EQk5lVgBpwzlqUjmFH/1vgAccQ9o0yfpOmk638AJN9u/ktBl/6wGHIvyR5gtc8M
	v1wisWyMRcKxfhs1CDzVp9HZ/eZs8h4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AttmEWPU;
	spf=pass (imf03.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774945710; a=rsa-sha256;
	cv=fail;
	b=hXv3urbqhtdS9iKRe9GrjHM7YDhQCnGcZo3KyyLO9taNsfiuTFV80YO/xDtQZ05zd4laMc
	uQJYQ5rbm5YRpTLoH/+XcQPhJ+0yTD/EsQb6jU4MvH1keIC5OhIlrjr5OP0O3GASvF0Xlq
	su3WgW+imcFCcjgKiD4qsl8NSJPggDI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774945709; x=1806481709;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=v8DeuP4fywcCb/oYi/SNwuWqcUWP3ZowizHiQSrMvkg=;
  b=AttmEWPURHHZk0o8fitLdQ41BBHie+K0c1kmdFH1HzQoUkyjGEgGNmR9
   bYm8kxPVzmTEwYE0IZWkS0XI12AGmqfI0TizmBmdyxh/SwHUFv17SvFtA
   Srk/eAl43BEbPoejtT+m96xD3iJQ1Ycfom21LTICoLxrNxI4DHByybCSH
   rSbhLSxXmDQXzJz5vHD9uUHiICHe1PiyKl0y1lxpQn56eLrFQ+wMw1Xua
   epWhZKVv8ohqOF5q+F2lOAF9vlgiJOsohbxVxu53/jd5TCZd2d8e+o9Qt
   PPLoXA5rQucKpEX0QoAg3EgqNwbRQOpfnUj0Ck51RSGwR1haWv89lHF6A
   A==;
X-CSE-ConnectionGUID: G8/DxYBtQBKAU6yyLZeSEA==
X-CSE-MsgGUID: P49xH+8GQfqLnJ/p1cQsbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="75666668"
X-IronPort-AV: E=Sophos;i="6.23,151,1770624000"; 
   d="scan'208";a="75666668"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 01:28:28 -0700
X-CSE-ConnectionGUID: 6IZcEgRMTseeqeitxXIkSA==
X-CSE-MsgGUID: E3EbzlQKSrOIGDYur1TdMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,151,1770624000"; 
   d="scan'208";a="231114140"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 01:28:27 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 01:28:27 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 31 Mar 2026 01:28:27 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.21) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 01:28:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aOrCy1xxBdKXY78ILagz3+0kMPDLtdT84vk2rZBi39aaDReIwg8q0FqrN/otOPuknCf+NoL5iFWIX5cq8x6rYGaWM81rsGL1t6lidQ4Ez3lBDAEiFCRPjpqx4NTeTKMR7aJz3/HPXL95j0ks3eZp5xSedzEaTC9uWLXSkZl8TuMyoaGdp8z0vwDkq1T34CbEHcMLNfoRLEeyOTMGsqLP6LvercDuU2BumJDbfojo+d4TgGjMYYWVu53oBBkCwe4DY+xFD2u9XnBGE5oSxYxzZwd457QG88klwpb0JHWHz4HY7xDyqqutIWtAb7V6mkMwXfhtVdtYlddGC34aUVTRHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgR98h6a+iSMQ8yoMDzUNCO7/kgnIEhs9ybF3vZX12I=;
 b=OwbD/Xz2sVWLuhbZe1A/vEZ4Vl9nc7+TSstdI005c1086o/QkbOOdZdY+tjfnx0LsDFDWZUJmumg/G83p+FDvqQ6REAcvwtMPHWBcE/iZCL4XTwDyFTx0niBn4FzLZay1iFkMMtSe6pw4f6bfGjXfK/lllb0Q/Z0EEfkuSwoVcqKVgApsmLofSBQ41OqcIR75KiBHCEJijYbTYT9UD0Hc6Vb6YteF5jsi8srGk3ttW+8rKr7VNDhz/O2K4AkP/fXtQoscycPtc3DSg6aGZ0tNSNbDhkmKH/BRXgtv6LbOaSDiW3TInAv3xuu9ryrRC/6DRwLUUKgL1jLNV4S6hNatw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by SJ0PR11MB6816.namprd11.prod.outlook.com (2603:10b6:a03:485::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 08:28:22 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9769.006; Tue, 31 Mar 2026
 08:28:22 +0000
Date: Tue, 31 Mar 2026 16:28:14 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Xin Zhao <jackzxcui1989@163.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <peterz@infradead.org>, <akpm@linux-foundation.org>,
	<bigeasy@linutronix.de>, <linux-mm@kvack.org>, <kuba@kernel.org>,
	<jackzxcui1989@163.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH] mm/fault, arch: faulthandler_disabled() also check
 irqs_disabled()
Message-ID: <202603311618.27b2972e-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260323100100.1031582-1-jackzxcui1989@163.com>
X-ClientProxiedBy: TPYP295CA0053.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::10) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|SJ0PR11MB6816:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f4ce1a5-c36c-443f-001b-08de8eff788f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: ttWKYQea+ZyJw6Ot1RlFuaaXJyuqZyIuG8TXchBz9CzxMWft229idam0K1O3O19n3SVxpz57sdLADwH+AVLlOflkrpRSs8XgBwbGt5z/ura7Cf6by30Q84EAqfgQa1KdwFrKuaZWysrTv3ovG5QAnMFKJeBurDza6T2u/nEHMfFh8nZmKQg+PxIoTOnvZoe/KsYLs/mSl69L/2VoBcwBcE93dEy8U5+FXMXEzIJbxRQ0ckqzE7O6vR2ROubOqX3GLWN0C4TwOW/Rv7RZ+EFe7FlFjaBdcksTVSZDvFeUYBWJtDJtJOgsmg/RoRf4WDXtSnkdb1IMPLxuophAVC88099exQEIVx0/fVV9cgOrEfv51iBUOLRRuPY2GUN8ZTwBmNN3HRmKmVQEsCofYcrR7UhhMcK87ViBSaEA3xybF9jh7gs4s9d8qRWmeb2OZgf9sI2P96KXsmgsxrSRfJyGZKKrG3xQXN02c6GZIMYX3OetO4JRhJPaCRo7X5CeNOEzhbib4tqpMHJgxWHbbi+k3oB8uvq2VOg2ZAncr98jfeQFnDVblKtFB7jFfQLuZIW8HJpQUJrURwPB8ZWMCYDyR3y9bp8BRps2j8lT0J3zEV1fqc4gg3ARaf+ars8gIbwW9WJk3c4zE2LVho75t6e+A9XgANdXQGdLhC2bYSUWh74ZcbyPyjK8EZXJTCmvccakGTmWrqsOtCVqkVS+oGn/QA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SpPqyKNRHBgArHU7XhU/ILZUPXFdqZJpbvQaHU4Kt56NVlyn5S4JG1w3MbSU?=
 =?us-ascii?Q?xNnoPoOipSINeQ+L3MBN8BnRlVR447G4eveCj0H4j8K4YATiMMkl7uuY/Ucx?=
 =?us-ascii?Q?thaNmY4PkktnmJbmRr8mw2NR6vb0+ufXUCzx/nYcVMimWZ3BvWfeylzpe0vq?=
 =?us-ascii?Q?69LogNodeBDQ0PiP+n7KRrc/g6vQNX+b8LVocR1TwhxVKFwKNFptOnxQlHtp?=
 =?us-ascii?Q?gvX3uhpAgYp4Vhr0HdECjImDv0uJCscx64LD5gtRtsY/bA2aqdnGee2Vv9N0?=
 =?us-ascii?Q?h3VNVZlX0YHZtH7h5Z19iFK8LBjFAooA+QFxnb9cogETWh0dTUNYWiilNOZv?=
 =?us-ascii?Q?d4Y6NtTiVT0+ruJXmxmqIE4sGhsGXZTRXM/koX7uAclYI3YBJb05bA8X7Ao+?=
 =?us-ascii?Q?aRU3Q3bZvbiv9vOAuGa72LE5lmbVPPgV2O+akuHYnidfvmiZTFDKNvUwdkIL?=
 =?us-ascii?Q?ZCM/1LJ30ougQSIwIwdSFsNbqIz7WNkpstF2bRXRSc9kgtNk5Utg6lGeHy8q?=
 =?us-ascii?Q?i0UP7rtlWXXWdXZOYMVmiLr1wt6n30ji/hDsPQYGoL8ELwW2HuQMV3czoNkt?=
 =?us-ascii?Q?NDBsZNcbiNmpC7N3tm6ePetDvrfArysNTM4R5Snm5NTgTGQCZuM9Ubz2m+kP?=
 =?us-ascii?Q?CQOr7S40OjU7+kRyQXjemNoqkaAHOEFYx44xEOBvudTymPGrvrIzoMtGQpLi?=
 =?us-ascii?Q?MKwmMUMMI70Dr6SiW+Np9hC0HXD84B5+djjTNIqt6dotVYUQaDgD1Hn3D+Jh?=
 =?us-ascii?Q?WfYV30fQeoVsBVcjTWZ3FNMGpmKSXvlUN7PoNyOWwoTD/p114nDADam4tKz/?=
 =?us-ascii?Q?zmkcJkQv4aDM5ETZhtCsy2SRXLuliJ2pYXgNMpGjlqy4WzElawnLJ6YYIIsM?=
 =?us-ascii?Q?0jH00ctaYl9n0tcADUrVgnfawVroc4eUbaLYrx6ZtXYGv6WBylKCnQ7xi70v?=
 =?us-ascii?Q?vcWm5lPQ+IqubQClAFMWkcxt9PErC0YyvMqTh5rlH+k+5YUzaYFmyPq8i4yW?=
 =?us-ascii?Q?N0mf8Zsa5mtPeGf15m+C8U+9lAo1PnsYKuMpLxbpVT1ur8P2PuKc+oBWBCjb?=
 =?us-ascii?Q?1qBvBpNz4T5ByjDzM3HsPxBnFGCgja06lq7CP1g8Ulb0JKLpZIYHQYsKkCD3?=
 =?us-ascii?Q?oUqk0DjSTR+IEDIA6PdxUm8QlrXdSgQrN6e4xM+anks35tzdsd6piuaO/+UI?=
 =?us-ascii?Q?rdADeVNN5s0gyKghNzHx0ylrip+qpGGUOI4p01NF6PkUf9c2qyLWCAsk09pd?=
 =?us-ascii?Q?UvX0087l0Dtl8mD4hpUnkzO/J7FfpaxR4IclhT/wrIUk0Vjx3S5m091KuQHA?=
 =?us-ascii?Q?XD6Lo690mPJV9K4y0avHOlmw66LNQzV6Ys23OcNgXIrIr1njFYv2B7Wd8tNs?=
 =?us-ascii?Q?6ZxieYL9laguAehUcezUJAA3kbK1Ry6OyoykjA/A1hR1crVmeGSM5bosm4YM?=
 =?us-ascii?Q?zqYGHaAiqAAbwiT7JZ8XoRdQSfptkVzGYOi/YnUjOS+rU8eTBrMHHSKdBXvJ?=
 =?us-ascii?Q?o8NGM3Mid+tGbmAASMhfM3egy6iM19G1Xu91//zzaGyaa+cv0pfFCvB5/jPG?=
 =?us-ascii?Q?cP/+B2HyeaTN440Br+7FhAvNSJTdlgFeXf6gAVcS3HPqMyfyK+98GcjyLjln?=
 =?us-ascii?Q?lLXotK4ZZ1Qe9LMjxA6HJQG7UKMGtXZ/VIN51rCt/OjreZub8RWJBRuQoIKo?=
 =?us-ascii?Q?YhGOl6L8H2jRx2TUmLZcf2e9ATRvx7MUWsMWeOJpaafQ9wBeGDex6eG5RWM5?=
 =?us-ascii?Q?3+CPrpi8fA=3D=3D?=
X-Exchange-RoutingPolicyChecked: YIyI8BP8Sn9FNe8EVWuGgNmHh+3K0o3a07r+QA/ydEqVnIpPEmul6LxaGKAW4xY/o0lamwvXWYZL8iMWsgJeLITmh/j4gCCqmGy/AnlesfXDsCMa5OSBSGjKTjyARxokqXXrGNkvV/Gc4rN338SHJ/IbXpnB8ZCAu9f/8U2Cxtx02Cgg1tptmgwimDQJ5lOrFK5N5bpfgweVDOIWkJotwT/9OLjEsZHDOqRK2SCsP3x4OONH0nlBK/coNk9ywEBi9rOfzVyxChoZuLnVXtTsdAfTqdpDJCQTkO6l8/mulzawucXS8jx/7Nlq4YbxlyfcjYmLYqNGF9ecS0OP3r9/Cg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f4ce1a5-c36c-443f-001b-08de8eff788f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 08:28:22.5879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ou/7kCSd/wynPbX1oFj7PiIQDZow/RI6AKPmC68aggo/yb9Jg7PJzXLyAyGFqCD2+6/5RbDXFnOLh0lO8kDwQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6816
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 31CEC2000A
X-Stat-Signature: nrb9wctsqyskj3yidb58bzk7dsqperaq
X-Rspam-User: 
X-HE-Tag: 1774945708-416121
X-HE-Meta: U2FsdGVkX1/PNw1XrXughbMr5GPtDsjRPEkCtVwJqwYaUOh5qRWjRepCasFFvVRb/wkL5JV740lPVzaAG6Tsk6hgGVPrQ5MXeyyiLTv+D7V2k9ly4EFXUzqaQCC/kvHpPXaAbg4jSjzUCw6oPnkAG4WLk3xd55oNMTg49etwHINcXmfc1wd4dl+RMnxNIZt5SSy77+ZtwRd5D2tyNvsJ5EMDtSwHm500Z1LPq/sfw4n4eUlLKeucMO2d8n5lZBUjIfiPPe04vilmOcUldPjhtM3kQ9xiSgMwqyrleniIk6Qw+6FaM65lpZNlhIpwKRlnQ5P/KUS5shBwZSekXniTX0bvVwyd6a5RNqMYvG9O4yTw2PfGfTf+XjI5sLpIBvGZV34VF3Sjqg4+EVxHGTcJEITfcmwyADGbPZwbSRwiqbR/eQzpZ6rJXXfOVk4ekBSOTPbl0kwHwbkBeSbbBYwtGGRkhKihEd0ZDXGeZRShFfTRGg/0ZggMLBftDrKhgbYfozvhHM9dEtFV1bVK/fD7s4//z0k9sbjnK4wWNjJlmm+/E43XYl1VeDJxkHx9VknicGhOUe4bplvTernRO6hc/jyXwrlhOrzEhX94Hoyjg6S3KlPO0inidA5yj9OCRZ4YDOAS9e/zHKxh2hXLq0bnJTxlDzih9VwQPZFtTw6pRev5EuXS1/HVIU6X0wYbP6ay8mFNXQxkeKq0nukx25QndUp4itSZYJsjS4M4PIXgC7TsuEY3xhAI0p2dHet19a2HOoBgUBeB6xqbwJ6rAk/FQlvpagwVyEL+RImuGgvsWQkoVG0odjmE7WT8/lIwg6+2q5WbMH8nEBpb+BomUTLTDrp8NicpkCBo+1tscqp/foUJx1uzN1EAb1WeasLpDtiLRF3if+SGmlc7YAJvCNmMTpBO8RNrXfk56VBbynbLziuUBeOqjGtPM5fVdZMxSWvVnvJjvqf7h+vAkvFqeem
 2gkx6a7I
 rB8qLToFBzO6FG51+euki1K7fzB1F+c/dNCy6usfwq54O1DQGDwmDUYVG1Yft/MSLxaoGdgxGPqcO1mvdyzoOB2mAQ+vtoAZwKs6WoEEpRiQv40YQsItQ2F3m+qA77TJmzBEtz9k2ywL4R+TybceSk75E3yRJgyija1Gj3k77QpDqzs278xmV97Pnf08J0x3PsksignvnhhamNXxpCFKUa4crkX3HdXn5KKauiC292LpIQAHFuKxl4i+tu8A/HwMJ4pAAzYtIbtdPm1FeErzpg6KM0tIa+BHUEKnC9DTgsGK4ZIuO/3+e4e0sYeriw4zflpeANVoqqlNP7HWamU/pH++hic4cJjA2LDcwRP+QPKB19WSGSrlX/dV2ku1oOpSvrm+Wp1DiX9cxllgk/OUSnmMCZRw/7DAKUyg6bBY9LuSnBYcS60IT0CtwHQSOHuwZbGhlWbcfCtPE8pZVDSLhw+DIhvH6AT9QjlJ0VFtkSiJ5qqz86ZRXwr1L2W71Sc306ImqNhPBcCxKniWEqszKdBwQxcjtJEukPz5ZqmoZuG+XvKEz6fhnYFlBNOvfpSSmQndxeAEw85F6XmLAqJQ+ukiIK3V6rJMNe6HO7i5/puiFLq2LA82FivEGeCjdVNu04ZOF9DElmP2K4/Kb9KNxJ/19eUTb+J364cNOs2xk9xzvn/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "Kernel_panic-not_syncing:No_working_init_found" on:

commit: 6046ff3895e712d6aa63b4e4923082413d549baa ("[PATCH] mm/fault, arch: faulthandler_disabled() also check irqs_disabled()")
url: https://github.com/intel-lab-lkp/linux/commits/Xin-Zhao/mm-fault-arch-faulthandler_disabled-also-check-irqs_disabled/20260325-222637
base: https://git.kernel.org/cgit/linux/kernel/git/akpm/mm.git mm-everything
patch link: https://lore.kernel.org/all/20260323100100.1031582-1-jackzxcui1989@163.com/
patch subject: [PATCH] mm/fault, arch: faulthandler_disabled() also check irqs_disabled()

in testcase: boot

config: i386-randconfig-141-20260328
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202603311618.27b2972e-lkp@intel.com




[  975.526458][    T1]     nmi_watchdog=panic
[  975.540461][    T1]     load_ramdisk=2
[  975.553947][    T1]     prompt_ramdisk=0
[  975.567589][    T1]     vga=normal
[  975.589657][    T1] Starting init: /bin/sh exists but couldn't execute it (error -14)
[  975.616704][    T1] Kernel panic - not syncing: No working init found.  Try passing init= option to kernel. See Linux Documentation/admin-guide/init.rst for guidance.
[  975.664175][    T1] CPU: 0 UID: 0 PID: 1 Comm: sh Not tainted 7.0.0-rc5-00672-g6046ff3895e7 #1 PREEMPTLAZY  faae55da7b9858fe5c5fa04eb7f80af1bb165d67
[  975.706828][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  975.739692][    T1] Call Trace:
[  975.750564][    T1]  ? __dump_stack (kbuild/src/consumer/lib/dump_stack.c:95)
[  975.765613][    T1]  ? dump_stack_lvl (kbuild/src/consumer/lib/dump_stack.c:122)
[  975.780501][    T1]  ? vpanic (kbuild/src/consumer/lib/dump_stack.c:129 kbuild/src/consumer/kernel/panic.c:650)
[  975.794103][    T1]  ? rest_init (kbuild/src/consumer/init/main.c:1574)
[  975.808830][    T1]  ? rest_init (kbuild/src/consumer/init/main.c:1574)

The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260331/202603311618.27b2972e-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


