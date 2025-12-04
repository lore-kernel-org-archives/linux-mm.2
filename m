Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F9A3D1D884
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 08:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3766B000A; Thu,  4 Dec 2025 03:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B939C6B000E; Thu,  4 Dec 2025 03:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34606B0010; Thu,  4 Dec 2025 03:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8ACBA6B000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 03:00:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A46A51F4F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:00:20 +0000 (UTC)
X-FDA: 84181041000.16.0DFF2FC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf04.hostedemail.com (Postfix) with ESMTP id 275F440015
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:00:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WXQ4HnJr;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764835217; a=rsa-sha256;
	cv=fail;
	b=Sa1pvwdVBx9pWgrhoX3tIVX/bLnud7yaCcgl8LtwNKn5ERJik+FQWj8DH9HAoVso+93uEL
	W1FFE63WtTdCYPcXuwEOT0TdXEsIE1SM956hCb+NC9FjF448hwZ2X6HJZeOG3DMxO5q4DY
	AFJdaVqihrqzNG+hrdtc2fsx1/gfXbI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WXQ4HnJr;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764835217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jqLrRGbOfV18os9SxdF3qjSQKMDsRKtx+vn5wTsDC2o=;
	b=WUrmvJpWfHMKb9W0wmOHxyNVBRuK8ywBSYR/plJG1qASjiKRHB7GajufHVJtyS03ejhkaZ
	vG8oU9WeoR9vWWODqkUndMNwQwksYFWcioAGjjRM8d+CKWc8C9ylIHVAnNw8Ug93PwYWe9
	FxR+CUCFzQgssDk458p08yWYlcDebPU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764835217; x=1796371217;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=NdPpcJSUkHs+ZdeBgzfEHhVdF9Wl794GRsWhaqACRnA=;
  b=WXQ4HnJrMB0YtuvVsye+isWNHYxUBv+zhR1T2RK4OWB+07Y7OkMHmLBI
   qWUIoFlvMprdcwmUEz5s3io0n0JSSL/Vtst7IGyBVUGXz6tT1fwdQ9cIw
   EYWH353dl9ECRavMhzvxuS3CvZQcN6Oy9NOg+uc4XJaD6T9HrC9vZYpIZ
   RMjPqhUACqeLz4gSW6cjsNp248C+1HoMFrMpUu65/aIr1q5LmQsk+EaI7
   SdSSjey7hypGkbrLEqqovs6YklSJQR9ZntWOPLOAGQAZIvcg98UMR+2Lb
   XvkuUlgVhX0PVGzLyx6YSRrW7CkdWGG39qqjKBwXDWgD7ffz9XqCngLJC
   w==;
X-CSE-ConnectionGUID: 027hCWnWRoGT/JCDxKnAnw==
X-CSE-MsgGUID: XipbE0DwTui7Kniy+NYA3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66731708"
X-IronPort-AV: E=Sophos;i="6.20,248,1758610800"; 
   d="scan'208";a="66731708"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 00:00:15 -0800
X-CSE-ConnectionGUID: VbFf49SIR+uoe/UjDOgfAw==
X-CSE-MsgGUID: lT0epKJBQmO4qfq10KMroA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,248,1758610800"; 
   d="scan'208";a="193980638"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 00:00:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Dec 2025 00:00:13 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 4 Dec 2025 00:00:13 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.18)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Dec 2025 00:00:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RjhCa1Fxm8QycblS/Tx9/u0IE54Qw6l4XwgWb/SlOpD0Dmq4MkZTzyR/fJrOxLza1k0q93WhjvT6B76BCEq76v5xFy4yWXt7bQm1WdZTtt2rWSHHtfRxIE6HNrDKrVnwBXCLf2uN32gMXDBAfm+X2J84C8227MX9j2AGn1z1v27aBV/7TpdqcJIUSzxdXV9gXnPjRgGTgG0XN1t2KULVL6jU2MbgP8gUYsCVf1Mgfhmcgj1uxovJAM9oPvU/4yUrWVQAwneQxsIuJuIukNnHCd5SMMYM1SDHH2fj8GT80BVhZL3Q/7FOKWP+ayRvvKsBTRP3aTIpFMKJwxmrFB2dKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LiUXXU0+Aq3cJMLiVlA7mMJENO8bqV+DJVeVyaCvGhk=;
 b=qk+zeUpzOAfCPkY0coevA8a7B+oTbdwZAOo/Xdy3z0vHjOY2oxNqNlcAV7q8VS2xyF8O6JZHof+PvrEQCXsytI5WaopohpoPungsGkK/+SBRt+nlUUP06qaM9fD3fwTYebLiuLqFFwqpbFEg5JnJVRfGaOnaY0i6v3SeaiXcrA3vyyeQi5TD0rXM+JTxyMQQJR9J+qq7Jl8hHvrOfphGxzvRKmrKmoDh5xg0k/vvxpxwvXnbalvJ0StvDrYfgr7YwYesLVx4RBk2NtVU2lkQS9C1wbwQ8P/1HXGeehXFdcVr5ieKwzBQs6d0zMxR9E1v//9Z8e4s81WV+HJWd61F+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by BL4PR11MB8846.namprd11.prod.outlook.com (2603:10b6:208:5aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Thu, 4 Dec
 2025 08:00:11 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9388.003; Thu, 4 Dec 2025
 08:00:10 +0000
Date: Thu, 4 Dec 2025 16:00:01 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, <linux-mm@kvack.org>,
	<aubrey.li@linux.intel.com>, <yu.c.chen@intel.com>, <oliver.sang@intel.com>
Subject: [linus:master] [sched/mmcid]  77d7dc8bef:
 stress-ng.enosys.ops_per_sec 2.7% improvement
Message-ID: <202512041521.6bdcad6-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TPYP295CA0045.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:7::6)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|BL4PR11MB8846:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b217008-54c7-456b-5178-08de330b259e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?q3aBlmnOmg0FZkcGR0CxTsQ6nIJe5n74uUbpsNQqNPhuovBA4w+iGtZS9x?=
 =?iso-8859-1?Q?TWvoVbi4/j+gIEvo+BBMDValrVkwtvERMy/LbtYCqf4xbgz7+GSeb7Virn?=
 =?iso-8859-1?Q?F9k/ma1MsC6iUCZhMGgV/5SVAI2/e/qpRnbMUsf/yFHGCqliF2wno3H2y1?=
 =?iso-8859-1?Q?Fwe1MMlQNOH0fQZkM9suYo3HpbPJNEAw8uGrLEv+E1JhnSvRtGmBL9dMU7?=
 =?iso-8859-1?Q?9RgYFyubhJAZS3gGeWsrUU/XR7grTG3fWWkLblxANhdiMQdFFq4eIQuztL?=
 =?iso-8859-1?Q?bXxcoCjyKXLcMloPp9gCJyjqn72gVYcbdmrcOm7pRvFvTecTCMBgEI8X/o?=
 =?iso-8859-1?Q?bB5hyr12XRTs5TVM1P7KQ2N5cfDF7jGL0hTm0ngoLz4z2yIeLET9e88C27?=
 =?iso-8859-1?Q?RRWx4GQ92sODqGXktLEqhvW+/b0moEmFqQw67ld9NIMMrYrpvqO1I9gbRK?=
 =?iso-8859-1?Q?RJg5gaD6kcw96sA+4/rJhdAQW7TK2oG+idl5KyK3D2tg/D8vgMnDS+ku+o?=
 =?iso-8859-1?Q?XKyUjCt/AB9bUk3HitZe+kx9saU8Vz2+sBWeYKplMYhDA6qXAG/nXIVTR+?=
 =?iso-8859-1?Q?m7JGSiqOSYAI4SvuAZrzTvxKJ6Ohd0/O4Vw5RZkzAhhMTpG5kaSnFQCqY2?=
 =?iso-8859-1?Q?YF7l7tpN0LCuhnC3KMvvaLjgKmIMv3wU1/3LJQvIxQlf3z/FJ+s2ryhnd4?=
 =?iso-8859-1?Q?FnpR3DZ1ynBigFP9/hk4JrsNFhrxhT7QkpVdFdaDueK4AANVwMOHtPRqUE?=
 =?iso-8859-1?Q?LL0TJRRDRr3ssXH2gOkHGYZ/Saz6Nm2ExUBrQQoN5EDlHGF3rxgN9LxxEZ?=
 =?iso-8859-1?Q?bo79OdXtCt/ht32c1M+LeONQU5qwnPD/m1qrfW88q5Ngu4OjLUi5PQGp6D?=
 =?iso-8859-1?Q?sT2M35DyqiTEQVmTglrEtm9F7OOgCAs5a/ZbMSdek9sXnopNLn+SPIedNQ?=
 =?iso-8859-1?Q?7jU9tNAZUMsSBKFs5F9QL9s6tdgLr8B+OuuoN1ujqKzsYLO5WhKZsu+wNO?=
 =?iso-8859-1?Q?Wd626gcKbRoWi0dpeH4KPXYAbEtoQTHb4k5wsqswiwSIAnrWnLuMuxQBu3?=
 =?iso-8859-1?Q?R8l6MOkCKgbpucAh+G2rfspYtjB1e0wInIO6rNy1r0GoX+QbjBqfjNFmZn?=
 =?iso-8859-1?Q?eIrHdaSqPxMs8AtTmgjpfGnFxjmt2HJ3vGn/xSpXduybk0hNVPwZvpNlLZ?=
 =?iso-8859-1?Q?UADWYvPWNHaOiYkayfSu/08w9QNlA07NjxngDP5RCHe4/i51tZD/Ez+yQf?=
 =?iso-8859-1?Q?sG4cNShvUH8E4akBLGLyBMpwkKrYrgfJAy1Q6QhROEwxY70shISb6HIOfY?=
 =?iso-8859-1?Q?3LgNWXIgcD5dEigFnNYZwFmACucML4y0Azc5mcQxtfPzc7li10+Krj3eIH?=
 =?iso-8859-1?Q?9auEyQT9bas8bL3jaVnHodrEdW0U44AzAXFKu0J934lDSpr7GQUba5b28m?=
 =?iso-8859-1?Q?+9shxGn2djbBv0r8/3ugqYRPoeSS96XS7QXzdAx31f3yylkt5Eao8JaYZX?=
 =?iso-8859-1?Q?VROPiAGJXPVjzkdS4W7PW90bfowznSZeR9qWhceV0KPw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?b/+HuehyJQCD5ZXyDHjQDjI7aH7eWfd6QTWeIrrbLx80BdCpRoyuF7xKGp?=
 =?iso-8859-1?Q?t4RMmHK8j/LCxXfUjxbBNZjbO6UAwObd+E/Btcs73YE6amXdjn2DsGSKbn?=
 =?iso-8859-1?Q?n+ndZI6KGY68KJ5PTEyrY1QkXQeEDFnmMPqNyWvMd9b0iU2EK7UhpL0xUz?=
 =?iso-8859-1?Q?Hdh34BXYm2ea8o+my0CZbjmLKjZ2Nih2zGX1B0hYNwFC5TNpQA1nCS1pd9?=
 =?iso-8859-1?Q?9iw9Zaz0VhqG+6p9RPT0mfR0YWp4fZZW5Qh9YQLE/VuLZiwGHhzUbnBWae?=
 =?iso-8859-1?Q?2iOHu/lG359nTLUNNs24/dff17K/eOud3m9gm8vaIzBPb2Agwrj7jBNVgC?=
 =?iso-8859-1?Q?ZTbivKkFK2w187yUY2vGZOKlNPL4C4jgv2k6fSPNjSYf/0dJmcwQg2VSi3?=
 =?iso-8859-1?Q?frE8MtHBmCr3oCwhoY7Gy35vWGnDnTrg2tCIiuEctDXwoq3bii7OOef3Sj?=
 =?iso-8859-1?Q?VGW+388mphQmQXr57fA3ZsfKgSPo5cPiebrfW4EdvbJvdofocfJsROejQN?=
 =?iso-8859-1?Q?++3ZKUVHVyb7FKhbuFlsE2rA+BuVWhPXzHc1iygZWSL66ywIP+Rq26DfXp?=
 =?iso-8859-1?Q?mAZuTg77FxoupIkS9TGtC/oBlsUE05tV6AZrRRIceGdOp/46aW6Gmb2mA0?=
 =?iso-8859-1?Q?4XcDcSatHa7Riw6Jb3fTzsakrg3mxrm8mTYBXhZRTOP1TgnsO/AWu2jXnt?=
 =?iso-8859-1?Q?gcZ1CVDdDi0OJWLaWgiP9fsQeATERfb3LJ+BEd/mh+HFmdon9wWjK3lPSv?=
 =?iso-8859-1?Q?Ni0A7ARocOmWx8OiFdaEYnJgL+NqJVtuA9MvTnX9qFeY+tfxBTadqzzSLA?=
 =?iso-8859-1?Q?Rm6QP0i2Or3wTZixTEnaP6Ay5xv+BvU/hVNtBADlYq0uvhM56FfgCblzxp?=
 =?iso-8859-1?Q?rf59RdS5EBmfC0mb0CWnNaQbkBKoIEPhIwiwmDN3wrkmm/4pLIyVvDcFNP?=
 =?iso-8859-1?Q?Gq5k24rI1/7fLQhaXDSwMQcT/1KUQbfK1fP6Y1QkclNSBc4B82K/Dyt/tf?=
 =?iso-8859-1?Q?T1lshp8E+bPE8A73smxEerlhrEm9M6lwy78M9jsMHd4rm4zS3rVxio7jAP?=
 =?iso-8859-1?Q?as20pZYox1dpSQFA5FGS00cAoZC3bREQ181Brjvoy1QXlM32rQrt0Q8TnI?=
 =?iso-8859-1?Q?3gYw23MgkICLJlUjzq97iox4u17upD6odFvZshNc8ZtD4k+HA7KYTzEP1s?=
 =?iso-8859-1?Q?HDq7PfSBei+PkoZ8tTwlVDTl4hRR+KaKqSfIYAucfRuCm0Tu6VSlWYcvBC?=
 =?iso-8859-1?Q?uaqOC4vVJx0RKTLN+D5Jy3F3tmXv3ZnFr1IywYZ+4Kp4xFMSdjUGdbhYAZ?=
 =?iso-8859-1?Q?yo66qs0XSTPNaLHyxNoDMp6cD+g1KkFDIFhCk5P+jVxi1cfCVLRD+6QSvf?=
 =?iso-8859-1?Q?IhbgsoJwv2AWIi0BSyI992Np5d6LaGsfEWYimNrD4ntq1DLf9ACWuBxpLZ?=
 =?iso-8859-1?Q?4YZJUtZV6qO5vinyajC2n7qPixcj7GnThAwFO9hdbRpoutyFS0ITlDV1IN?=
 =?iso-8859-1?Q?CxdxQG0WI5eXt/TyNu5SflM3IeMlVOrDIAPxcFGP4EoJgJCyVIA9BhcLIX?=
 =?iso-8859-1?Q?Q+30jh8ofa4nzDVuHJrVXbJ2p9pP7sYgntOwgLJa1tg6UAH7PkEcyDiPcm?=
 =?iso-8859-1?Q?NRSIQJWzZdKXdZ/ZH6g4nT+oTt7Zu0ad5uR6r07DgXpQhq3uRp0YwUCg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b217008-54c7-456b-5178-08de330b259e
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 08:00:10.4748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R7jnx1xZHhQ4Ft0h0QkJ2sP/Lc+QJAxQJ8fc+QNZTgZL8mJdIK/M2jjNloEli4/CN1ur0XTzUMyhPoZcLUzzJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8846
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 275F440015
X-Stat-Signature: iw3h39j6s8pjqkpwhsc78cpo7qntuuw8
X-Rspam-User: 
X-HE-Tag: 1764835215-961270
X-HE-Meta: U2FsdGVkX18CMLqtbFfmSQz9z1rGkOWBDNmBVA/umxk0/+/sXeFodE42D7t1oqDxoIheU9l3v7CRbD4XDHuPsOe50IbiL23b1nUyYyhH6WikTfSw+oSP6/WrID4mSMut49N6trCee4qGs8KEF6wwDtlsSiOmjKX4+lwQ5ql+aDoMQfprGtQpmDhV0nXRGF038Uxa3dOUxv3GyTuJ/Qds68SPuA6MeWRCwcpm7GSYaQIV2c9xaNtagM7F6TXr8zHn4fYYzLQi94jqGM/WEzQF5IaFIwcvh0y4uk93Kh/7kDXIzBnQk0zI6W46UDWtKZ7C4fT3KPmv+BDZJlzMKnrme7e+j40HakDNcljA3rPexH34TetZoiVx3nKlTSSh1Dm/5sDWUqUYBlVQTtGgUTg6cS+C6s21vSO89sEG6x1M+GyX6MbGNCsydVB7ARkKOwm2KhpUNpxj/n4pALmdqSISpNaTYGI8SrRelrZDGlmubqAegljw+d76L0CoeCGI9YeeP3hX1El+jL8ryaKC4F+5p9uI27ky10hdTicGavMIIgM0tFZRyoCpf9ZnbnPE5MMp98O2ieAeRneYFFwrV0VNPrHcRKiLeKjYPijmRYxuuHoTqgEYvqhhplBo4C5ukhxCjiBX+IKMB34ECJpBrrnssQJ71a26EXXcmZxiV2n4pdHUTtYwUiCDt74qSzkuPanL9iCartAitSs7+DmGCeJ3WQuW0ouzs/y7H3ktzTp+GENh1g1hwlPTCdJgqixO/vlHHdcOSopiEP7gn+Lsc/d81oBaPXj06HJbQ+jC2fysTePvG8WmrQzSKLaV3klUWoVPgPHEVMArQronBpJ+7zYOY45qx9JQ1BJ+qi1F7E3S8fhrZ3Eswi7EUZLiT8gSWl9VeuPbeAW0516FEX2zoifN0nXVQc/Ic5EmpMBNVQWO9aovbp2fl9Jb5SZCWbC5vFMNnfM3TMyI4O3AS5ZBGeO
 K+JkBoMh
 E7qCrYGrmwn/d+QvxoHvLWMsg6Nsk7dV+420FWmkOdRcgngdNxYN24/AhellHtLEcRHH4hVoCnCOApVzLUFIIabsiQdBGZ4vF03DPGXQPIlSVyMDfZQ0Wqv4KX9jdCqpzWSLNCx9ocduShSlLS9hEJ4+oDrjCDtDnL5Sy6uOus9/QlJuCXNTPPpT2KyMNaeEpzFW/3rIRR/f2J0kUtcQ2Ir+/kKudA9vKr8Rmkgz6t2rNNpGQUjhkj/HARRybEZeXh2HbcsuiWTT7iXbW2V2U7cM52j0addvmZTeqTSJqy4zFxSZEGc0PJ0coAnILhe5fgFDuc8VziRzXOEWGRzyoG6c6300bNmLQP6dmf+4rHZ+xj7GMJZJ/6ms2eUGYmvHyKmDW1nwanR6Wrx+K4SmOt27QLKNgr7spbAe0Et7/yEowiz0EdErn84fm0bv+yuCnMs96Pw29nle5Mn36q2s6Toyjo+l2EeTo5a5cJFf3p4ka/57TfNDLamemwVw140QnzpAJ6s8DGKNruvMk/XU98l/ivKDAOb+5X6j0lUuCu9/7q5uF+D60z367/V8fKr98XIHMrDRMQsdqouvgB+xLVcZDBUWfmYBfxLGk1WgDlTae7g0cjY5Jxx/qLpEy7pgG1+KCaY+5H8kvAXWQwkGTuM7AxBuzykYZfKtLHe+LAQ81IYY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 2.7% improvement of stress-ng.enosys.ops_per_sec on:


commit: 77d7dc8bef482e987036bc204136bbda552d95cd ("sched/mmcid: Revert the complex CID management")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6768P  CPU @ 2.4GHz (Granite Rapids) with 64G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: enosys
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251204/202512041521.6bdcad6-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp4/enosys/stress-ng/60s

commit: 
  80adaccf0e ("rseq: Delete duplicate if statement in rseq_virt_userspace_exit()")
  77d7dc8bef ("sched/mmcid: Revert the complex CID management")

80adaccf0e1c8c8f 77d7dc8bef482e987036bc20413 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      1.72            -0.3        1.45        mpstat.cpu.all.irq%
    359128 ±  6%     +11.4%     400016 ±  3%  numa-meminfo.node0.Slab
      2599 ±  3%     -15.3%       2200 ±  9%  perf-c2c.DRAM.remote
     16.86            +0.3       17.15        turbostat.C1%
      1.29 ±  2%      -0.0        1.24        turbostat.C1E%
 7.172e+08            +2.7%  7.368e+08        stress-ng.enosys.ops
  11968579            +2.7%   12297343        stress-ng.enosys.ops_per_sec
     93501            +2.7%      96070        stress-ng.enosys.syscalls_per_second
  47588033            +7.3%   51081361        stress-ng.time.involuntary_context_switches
 1.412e+09            +2.6%  1.449e+09        stress-ng.time.voluntary_context_switches
      0.14           -15.4%       0.12        perf-stat.i.MPKI
 7.113e+10            +1.5%  7.217e+10        perf-stat.i.branch-instructions
      0.78            -0.0        0.76        perf-stat.i.branch-miss-rate%
      1.02            -0.1        0.90        perf-stat.i.cache-miss-rate%
  49452856           -14.1%   42492832        perf-stat.i.cache-misses
 5.659e+09            -1.7%  5.563e+09        perf-stat.i.cache-references
  39101456            +2.5%   40060126        perf-stat.i.context-switches
      2.43            -1.8%       2.39        perf-stat.i.cpi
     20302           +27.2%      25834 ±  2%  perf-stat.i.cycles-between-cache-misses
 3.522e+11            +1.5%  3.576e+11        perf-stat.i.instructions
      0.44            +1.7%       0.45        perf-stat.i.ipc
    194.63            +2.1%     198.62        perf-stat.i.metric.K/sec
      0.14           -15.2%       0.12        perf-stat.overall.MPKI
      0.72            -0.0        0.71        perf-stat.overall.branch-miss-rate%
      0.87            -0.1        0.76        perf-stat.overall.cache-miss-rate%
      2.27            -1.9%       2.23        perf-stat.overall.cpi
     16200           +15.8%      18762        perf-stat.overall.cycles-between-cache-misses
      0.44            +1.9%       0.45        perf-stat.overall.ipc
 6.981e+10            +1.6%  7.092e+10        perf-stat.ps.branch-instructions
  48451570           -13.8%   41741420        perf-stat.ps.cache-misses
 5.566e+09            -1.7%  5.471e+09        perf-stat.ps.cache-references
  38495150            +2.4%   39418126        perf-stat.ps.context-switches
 3.458e+11            +1.6%  3.515e+11        perf-stat.ps.instructions
 2.098e+13            +1.9%  2.138e+13        perf-stat.total.instructions
      5.70            -0.8        4.90        perf-profile.calltrace.cycles-pp.ttwu_do_activate.sched_ttwu_pending.__flush_smp_call_function_queue.flush_smp_call_function_queue.do_idle
      7.05            -0.8        6.28        perf-profile.calltrace.cycles-pp.sched_ttwu_pending.__flush_smp_call_function_queue.flush_smp_call_function_queue.do_idle.cpu_startup_entry
     27.35            -0.7       26.61        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     27.41            -0.7       26.67        perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
     27.52            -0.7       26.78        perf-profile.calltrace.cycles-pp.common_startup_64
      8.75            -0.7        8.01        perf-profile.calltrace.cycles-pp.flush_smp_call_function_queue.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     27.38            -0.7       26.65        perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
      7.98            -0.7        7.24        perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.flush_smp_call_function_queue.do_idle.cpu_startup_entry.start_secondary
      1.17            -0.2        0.98        perf-profile.calltrace.cycles-pp.__switch_to
     11.65            -0.1       11.54        perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     10.94            -0.1       10.83        perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
     10.83            -0.1       10.74        perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
      0.70            -0.1        0.61        perf-profile.calltrace.cycles-pp.nohz_run_idle_balance.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      1.57            -0.1        1.51        perf-profile.calltrace.cycles-pp.restore_fpregs_from_fpstate.switch_fpu_return.arch_exit_to_user_mode_prepare.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.86            -0.0        0.84        perf-profile.calltrace.cycles-pp.finish_task_switch.__schedule.schedule.anon_pipe_read.vfs_read
      0.54            -0.0        0.52        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__getpid
      0.78            +0.0        0.79        perf-profile.calltrace.cycles-pp.raw_spin_rq_lock_nested.__schedule.schedule.anon_pipe_read.vfs_read
      0.72            +0.0        0.74        perf-profile.calltrace.cycles-pp.switch_mm_irqs_off.__schedule.schedule_idle.do_idle.cpu_startup_entry
      0.71            +0.0        0.73        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.raw_spin_rq_lock_nested.__task_rq_lock.try_to_wake_up
      1.36            +0.0        1.38        perf-profile.calltrace.cycles-pp.pick_next_task_fair.__pick_next_task.__schedule.schedule_idle.do_idle
      0.95            +0.0        0.97        perf-profile.calltrace.cycles-pp.wake_affine.select_task_rq_fair.select_task_rq.try_to_wake_up.autoremove_wake_function
      0.75            +0.0        0.78        perf-profile.calltrace.cycles-pp.raw_spin_rq_lock_nested.__schedule.schedule_idle.do_idle.cpu_startup_entry
      1.41            +0.0        1.43        perf-profile.calltrace.cycles-pp.__pick_next_task.__schedule.schedule_idle.do_idle.cpu_startup_entry
      0.75            +0.0        0.77        perf-profile.calltrace.cycles-pp._raw_spin_lock.raw_spin_rq_lock_nested.__schedule.schedule_idle.do_idle
      0.92            +0.0        0.94        perf-profile.calltrace.cycles-pp.raw_spin_rq_lock_nested.__task_rq_lock.try_to_wake_up.autoremove_wake_function.__wake_up_common
      0.75            +0.0        0.78        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
      0.53            +0.0        0.56        perf-profile.calltrace.cycles-pp.prepare_to_wait_event.anon_pipe_read.vfs_read.ksys_read.do_syscall_64
      1.11            +0.0        1.14        perf-profile.calltrace.cycles-pp.pick_task_fair.pick_next_task_fair.__pick_next_task.__schedule.schedule
      0.91            +0.0        0.94        perf-profile.calltrace.cycles-pp._raw_spin_lock.raw_spin_rq_lock_nested.__task_rq_lock.try_to_wake_up.autoremove_wake_function
      1.00            +0.0        1.03        perf-profile.calltrace.cycles-pp.__task_rq_lock.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
      1.23            +0.0        1.26        perf-profile.calltrace.cycles-pp.mutex_unlock.anon_pipe_write.vfs_write.ksys_write.do_syscall_64
      1.39            +0.0        1.43        perf-profile.calltrace.cycles-pp.do_perf_trace_sched_wakeup_template.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
      0.80            +0.0        0.83        perf-profile.calltrace.cycles-pp.llist_reverse_order.__flush_smp_call_function_queue.flush_smp_call_function_queue.do_idle.cpu_startup_entry
      0.98            +0.0        1.02        perf-profile.calltrace.cycles-pp.perf_tp_event.do_perf_trace_sched_wakeup_template.try_to_wake_up.autoremove_wake_function.__wake_up_common
      1.49            +0.0        1.53        perf-profile.calltrace.cycles-pp.pthread_sigmask
      1.26            +0.0        1.30        perf-profile.calltrace.cycles-pp.update_load_avg.dequeue_entity.dequeue_entities.dequeue_task_fair.try_to_block_task
      0.70            +0.0        0.74        perf-profile.calltrace.cycles-pp.wakeup_preempt.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
      0.51            +0.0        0.56        perf-profile.calltrace.cycles-pp.check_preempt_wakeup_fair.wakeup_preempt.try_to_wake_up.autoremove_wake_function.__wake_up_common
      3.54            +0.1        3.60        perf-profile.calltrace.cycles-pp.__pick_next_task.__schedule.schedule.anon_pipe_read.vfs_read
      2.39            +0.1        2.45        perf-profile.calltrace.cycles-pp.pick_next_task_fair.__pick_next_task.__schedule.schedule.anon_pipe_read
      1.40            +0.1        1.48        perf-profile.calltrace.cycles-pp.__smp_call_single_queue.ttwu_queue_wakelist.try_to_wake_up.autoremove_wake_function.__wake_up_common
      1.84            +0.1        1.92        perf-profile.calltrace.cycles-pp.ttwu_queue_wakelist.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
      4.10            +0.1        4.20        perf-profile.calltrace.cycles-pp.dequeue_entity.dequeue_entities.dequeue_task_fair.try_to_block_task.__schedule
      4.92            +0.1        5.02        perf-profile.calltrace.cycles-pp.dequeue_entities.dequeue_task_fair.try_to_block_task.__schedule.schedule
      5.08            +0.1        5.19        perf-profile.calltrace.cycles-pp.try_to_block_task.__schedule.schedule.anon_pipe_read.vfs_read
      5.02            +0.1        5.13        perf-profile.calltrace.cycles-pp.dequeue_task_fair.try_to_block_task.__schedule.schedule.anon_pipe_read
      1.53            +0.1        1.65        perf-profile.calltrace.cycles-pp.update_load_avg.enqueue_entity.enqueue_task_fair.enqueue_task.ttwu_do_activate
      7.44            +0.1        7.58        perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      3.36            +0.2        3.53        perf-profile.calltrace.cycles-pp.enqueue_entity.enqueue_task_fair.enqueue_task.ttwu_do_activate.sched_ttwu_pending
      5.06            +0.2        5.28        perf-profile.calltrace.cycles-pp.__schedule.schedule_idle.do_idle.cpu_startup_entry.start_secondary
      5.16            +0.2        5.38        perf-profile.calltrace.cycles-pp.schedule_idle.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      4.24            +0.2        4.46        perf-profile.calltrace.cycles-pp.enqueue_task_fair.enqueue_task.ttwu_do_activate.sched_ttwu_pending.__flush_smp_call_function_queue
      0.25 ±100%      +0.3        0.52        perf-profile.calltrace.cycles-pp.syscall
      4.47            +0.3        4.75        perf-profile.calltrace.cycles-pp.enqueue_task.ttwu_do_activate.sched_ttwu_pending.__flush_smp_call_function_queue.flush_smp_call_function_queue
     24.62            +0.3       24.91        perf-profile.calltrace.cycles-pp.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key.anon_pipe_write
     24.68            +0.3       24.97        perf-profile.calltrace.cycles-pp.autoremove_wake_function.__wake_up_common.__wake_up_sync_key.anon_pipe_write.vfs_write
     14.61            +0.3       14.93        perf-profile.calltrace.cycles-pp.__schedule.schedule.anon_pipe_read.vfs_read.ksys_read
     15.07            +0.3       15.40        perf-profile.calltrace.cycles-pp.schedule.anon_pipe_read.vfs_read.ksys_read.do_syscall_64
     25.98            +0.3       26.31        perf-profile.calltrace.cycles-pp.__wake_up_common.__wake_up_sync_key.anon_pipe_write.vfs_write.ksys_write
     26.13            +0.3       26.47        perf-profile.calltrace.cycles-pp.__wake_up_sync_key.anon_pipe_write.vfs_write.ksys_write.do_syscall_64
     21.40            +0.4       21.84        perf-profile.calltrace.cycles-pp.anon_pipe_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     29.54            +0.4       29.98        perf-profile.calltrace.cycles-pp.anon_pipe_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     29.93            +0.5       30.38        perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     30.32            +0.5       30.78        perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     22.36            +0.5       22.82        perf-profile.calltrace.cycles-pp.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     22.50            +0.5       22.96        perf-profile.calltrace.cycles-pp.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.6        0.55        perf-profile.calltrace.cycles-pp.enqueue_task.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
     57.94            +0.9       58.84        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
     58.04            +0.9       58.95        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
      6.91            -1.1        5.81        perf-profile.children.cycles-pp.ttwu_do_activate
      7.97            -1.0        6.93        perf-profile.children.cycles-pp.sched_ttwu_pending
      9.17            -1.0        8.15        perf-profile.children.cycles-pp.__flush_smp_call_function_queue
     27.49            -0.7       26.74        perf-profile.children.cycles-pp.do_idle
      8.83            -0.7        8.09        perf-profile.children.cycles-pp.flush_smp_call_function_queue
     27.41            -0.7       26.67        perf-profile.children.cycles-pp.start_secondary
     27.52            -0.7       26.78        perf-profile.children.cycles-pp.common_startup_64
     27.52            -0.7       26.78        perf-profile.children.cycles-pp.cpu_startup_entry
      1.28            -0.3        0.96        perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      1.12            -0.3        0.81        perf-profile.children.cycles-pp.sysvec_call_function_single
      1.04            -0.3        0.75        perf-profile.children.cycles-pp.__sysvec_call_function_single
      1.29            -0.2        1.10        perf-profile.children.cycles-pp.__switch_to
      0.59            -0.2        0.42 ±  3%  perf-profile.children.cycles-pp.__switch_to_asm
     11.72            -0.1       11.61        perf-profile.children.cycles-pp.cpuidle_idle_call
     10.96            -0.1       10.85        perf-profile.children.cycles-pp.cpuidle_enter_state
     10.98            -0.1       10.88        perf-profile.children.cycles-pp.cpuidle_enter
      0.71            -0.1        0.62        perf-profile.children.cycles-pp.nohz_run_idle_balance
      1.57            -0.1        1.52        perf-profile.children.cycles-pp.restore_fpregs_from_fpstate
      1.28            -0.0        1.23        perf-profile.children.cycles-pp.finish_task_switch
      0.62            -0.0        0.60        perf-profile.children.cycles-pp.__update_load_avg_se
      0.33            -0.0        0.31        perf-profile.children.cycles-pp.place_entity
      0.27            -0.0        0.25        perf-profile.children.cycles-pp.__task_pid_nr_ns
      0.28            -0.0        0.26        perf-profile.children.cycles-pp.__x64_sys_getpid
      0.59            -0.0        0.57        perf-profile.children.cycles-pp.propagate_entity_load_avg
      0.34            +0.0        0.35        perf-profile.children.cycles-pp.menu_select
      0.38            +0.0        0.39        perf-profile.children.cycles-pp.sched_clock
      0.24            +0.0        0.25        perf-profile.children.cycles-pp.__wrgsbase_inactive
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.dl_server_update
      0.98            +0.0        1.00        perf-profile.children.cycles-pp.hrtimer_start_range_ns
      0.20            +0.0        0.21        perf-profile.children.cycles-pp.asm_sysvec_reschedule_ipi
      0.66            +0.0        0.68        perf-profile.children.cycles-pp.syscall
      0.38            +0.0        0.40        perf-profile.children.cycles-pp.put_prev_entity
      1.44            +0.0        1.46        perf-profile.children.cycles-pp.set_next_entity
      0.81            +0.0        0.83        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.33            +0.0        0.35        perf-profile.children.cycles-pp.__pick_eevdf
      0.41            +0.0        0.43        perf-profile.children.cycles-pp.avg_vruntime
      0.96            +0.0        0.98        perf-profile.children.cycles-pp.wake_affine
      0.55            +0.0        0.57        perf-profile.children.cycles-pp.prepare_to_wait_event
      1.73            +0.0        1.76        perf-profile.children.cycles-pp.update_rq_clock
      0.90            +0.0        0.93        perf-profile.children.cycles-pp.llist_reverse_order
      0.45            +0.0        0.47        perf-profile.children.cycles-pp.update_entity_lag
      0.34 ±  2%      +0.0        0.36        perf-profile.children.cycles-pp.update_min_vruntime
      0.36            +0.0        0.39        perf-profile.children.cycles-pp.requeue_delayed_entity
      1.41            +0.0        1.44        perf-profile.children.cycles-pp.switch_mm_irqs_off
      1.00            +0.0        1.03        perf-profile.children.cycles-pp.__task_rq_lock
      0.35            +0.0        0.38 ± 11%  perf-profile.children.cycles-pp.copy_page_from_iter
      0.84            +0.0        0.87        perf-profile.children.cycles-pp.wakeup_preempt
      0.76            +0.0        0.80        perf-profile.children.cycles-pp.prepare_task_switch
      1.33            +0.0        1.36        perf-profile.children.cycles-pp.pick_task_fair
      1.64            +0.0        1.68        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      1.40            +0.0        1.44        perf-profile.children.cycles-pp.do_perf_trace_sched_wakeup_template
      0.98            +0.0        1.03        perf-profile.children.cycles-pp.perf_tp_event
      1.91            +0.0        1.95        perf-profile.children.cycles-pp.update_se
      3.06            +0.0        3.11        perf-profile.children.cycles-pp.raw_spin_rq_lock_nested
      0.53            +0.0        0.58        perf-profile.children.cycles-pp.check_preempt_wakeup_fair
      0.63            +0.0        0.68        perf-profile.children.cycles-pp.__update_load_avg_cfs_rq
      0.21            +0.0        0.26        perf-profile.children.cycles-pp.attach_entity_load_avg
      1.80            +0.1        1.86        perf-profile.children.cycles-pp.pthread_sigmask
      1.72            +0.1        1.78        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.35            +0.1        0.41 ±  3%  perf-profile.children.cycles-pp.cpuacct_charge
      1.41            +0.1        1.48        perf-profile.children.cycles-pp.__smp_call_single_queue
      1.84            +0.1        1.92        perf-profile.children.cycles-pp.ttwu_queue_wakelist
      4.03            +0.1        4.12        perf-profile.children.cycles-pp.pick_next_task_fair
      5.22            +0.1        5.32        perf-profile.children.cycles-pp.__pick_next_task
      4.41            +0.1        4.51        perf-profile.children.cycles-pp.dequeue_entity
      2.98            +0.1        3.09        perf-profile.children.cycles-pp.update_curr
      5.09            +0.1        5.20        perf-profile.children.cycles-pp.try_to_block_task
      3.94            +0.1        4.05        perf-profile.children.cycles-pp.enqueue_entity
      5.03            +0.1        5.14        perf-profile.children.cycles-pp.dequeue_task_fair
      5.49            +0.1        5.61        perf-profile.children.cycles-pp.dequeue_entities
      7.47            +0.1        7.62        perf-profile.children.cycles-pp.intel_idle
      5.11            +0.2        5.26        perf-profile.children.cycles-pp.enqueue_task_fair
      4.37            +0.2        4.54        perf-profile.children.cycles-pp.update_load_avg
      5.21            +0.2        5.43        perf-profile.children.cycles-pp.schedule_idle
      5.86            +0.3        6.13        perf-profile.children.cycles-pp.enqueue_task
     24.68            +0.3       24.98        perf-profile.children.cycles-pp.autoremove_wake_function
     24.64            +0.3       24.94        perf-profile.children.cycles-pp.try_to_wake_up
     25.98            +0.3       26.32        perf-profile.children.cycles-pp.__wake_up_common
     26.14            +0.3       26.48        perf-profile.children.cycles-pp.__wake_up_sync_key
     15.53            +0.4       15.89        perf-profile.children.cycles-pp.schedule
     30.13            +0.4       30.53        perf-profile.children.cycles-pp.vfs_write
     30.55            +0.4       30.96        perf-profile.children.cycles-pp.ksys_write
     21.46            +0.4       21.90        perf-profile.children.cycles-pp.anon_pipe_read
     29.64            +0.4       30.08        perf-profile.children.cycles-pp.anon_pipe_write
     22.38            +0.5       22.83        perf-profile.children.cycles-pp.vfs_read
     22.51            +0.5       22.98        perf-profile.children.cycles-pp.ksys_read
     20.24            +0.6       20.82        perf-profile.children.cycles-pp.__schedule
      0.07            +0.6        0.68        perf-profile.children.cycles-pp.mm_cid_get
     62.50            +1.0       63.46        perf-profile.children.cycles-pp.do_syscall_64
     62.74            +1.0       63.70        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      3.47            -0.3        3.17        perf-profile.self.cycles-pp.__schedule
      1.26            -0.2        1.06        perf-profile.self.cycles-pp.__switch_to
      0.58            -0.2        0.42 ±  3%  perf-profile.self.cycles-pp.__switch_to_asm
      0.63            -0.1        0.56        perf-profile.self.cycles-pp.nohz_run_idle_balance
      1.57            -0.1        1.52        perf-profile.self.cycles-pp.restore_fpregs_from_fpstate
      0.81            -0.0        0.77        perf-profile.self.cycles-pp.finish_task_switch
      0.58            -0.0        0.56        perf-profile.self.cycles-pp.__update_load_avg_se
      0.19 ±  2%      -0.0        0.17 ±  2%  perf-profile.self.cycles-pp.place_entity
      0.26            -0.0        0.24        perf-profile.self.cycles-pp.__task_pid_nr_ns
      0.57            -0.0        0.55        perf-profile.self.cycles-pp.propagate_entity_load_avg
      0.07            -0.0        0.06        perf-profile.self.cycles-pp.try_to_block_task
      0.26            +0.0        0.27        perf-profile.self.cycles-pp.menu_select
      0.46            +0.0        0.47        perf-profile.self.cycles-pp.task_h_load
      0.35            +0.0        0.36        perf-profile.self.cycles-pp.os_xsave
      0.78            +0.0        0.80        perf-profile.self.cycles-pp.vfs_read
      0.35            +0.0        0.36        perf-profile.self.cycles-pp.setitimer
      0.39            +0.0        0.41        perf-profile.self.cycles-pp.avg_vruntime
      0.28            +0.0        0.30        perf-profile.self.cycles-pp.__pick_eevdf
      0.79            +0.0        0.81        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.90            +0.0        0.92        perf-profile.self.cycles-pp.llist_reverse_order
      0.76            +0.0        0.78        perf-profile.self.cycles-pp.try_to_wake_up
      0.44            +0.0        0.47        perf-profile.self.cycles-pp.prepare_to_wait_event
      0.53            +0.0        0.56        perf-profile.self.cycles-pp.flush_smp_call_function_queue
      0.32 ±  2%      +0.0        0.35        perf-profile.self.cycles-pp.update_min_vruntime
      0.58            +0.0        0.61        perf-profile.self.cycles-pp.prepare_task_switch
      1.34            +0.0        1.37        perf-profile.self.cycles-pp.switch_mm_irqs_off
      0.66            +0.0        0.68        perf-profile.self.cycles-pp.update_curr
      0.43            +0.0        0.46        perf-profile.self.cycles-pp.pick_next_task_fair
      0.79            +0.0        0.83        perf-profile.self.cycles-pp.perf_tp_event
      1.61            +0.0        1.65        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      1.30            +0.0        1.34        perf-profile.self.cycles-pp.__wake_up_common
      1.25            +0.0        1.29        perf-profile.self.cycles-pp.anon_pipe_write
      2.00            +0.0        2.05        perf-profile.self.cycles-pp._raw_spin_lock
      0.92            +0.0        0.96        perf-profile.self.cycles-pp.do_syscall_64
      0.55            +0.0        0.59        perf-profile.self.cycles-pp.switch_fpu_return
      0.21            +0.0        0.26        perf-profile.self.cycles-pp.attach_entity_load_avg
      0.68            +0.1        0.73        perf-profile.self.cycles-pp.enqueue_task_fair
      0.61            +0.1        0.66        perf-profile.self.cycles-pp.__update_load_avg_cfs_rq
      0.34            +0.1        0.40 ±  2%  perf-profile.self.cycles-pp.cpuacct_charge
      0.76            +0.1        0.83        perf-profile.self.cycles-pp.__smp_call_single_queue
      0.38            +0.1        0.47        perf-profile.self.cycles-pp.enqueue_task
      2.21            +0.1        2.33        perf-profile.self.cycles-pp.update_load_avg
      7.47            +0.1        7.61        perf-profile.self.cycles-pp.intel_idle
      0.06 ±  7%      +0.6        0.67        perf-profile.self.cycles-pp.mm_cid_get




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


