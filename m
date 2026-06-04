Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B4C1CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 15:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BCFD6B008A; Thu,  4 Jun 2026 11:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96D5A6B008C; Thu,  4 Jun 2026 11:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8351E6B0092; Thu,  4 Jun 2026 11:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 726416B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:48:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A8131C0628
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:48:46 +0000 (UTC)
X-FDA: 84842663052.30.758FEF3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf22.hostedemail.com (Postfix) with ESMTP id A2727C0018
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:48:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Oo8sLue2;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780588122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CCeCN3GyaLpPvD0FC2oZLfB/VDTaXnrXPSH8uYL+sc=;
	b=nMO0ikIGYOT6GvihW72pNzNm/utTLKvXQa4bs395cZ1nmoqw9nGO4+K6rqNfk+6P9UzdaV
	z1w6DxM2u3NTUswDdlFCiFBM24S04JLq6Y0fTidQ+lDJFixcOeUzXpGLuQh+1/lIA1O9fq
	0ckYxCNhcSqNNrT/R4kwr+rcurHtmeU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Oo8sLue2;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780588122;
	b=ju+3Yw28JINquHas5RusM3pEnUpdy0ujx2XWyDB6mH8ZLh2iTGL5KKvzj9UTM4WWHXHwwH
	aqQIVAjB1+Cn6jqM7OYPhwZzuujR9ZRpfVuWtHME7ihvkzKzMOXhxASXWxJzIVtG07ayn6
	7auMyv6miBwI9TnoQcITA84tX7yPkf8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780588122; x=1812124122;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/CCeCN3GyaLpPvD0FC2oZLfB/VDTaXnrXPSH8uYL+sc=;
  b=Oo8sLue2cAv0xpGHoxi60nB7j6jJu2Bdm50rLMQ92hnnBotfFAVhcY3g
   oTpgeadP3M7xzFWvm3TYaCwvNw6RDdJI/XIsPGCbSpfxRGy5ZGh25t6tS
   BqecuDmkMrDmnKcAMF0C95SNXwMUKI96nWYbkxGj5kzJmSoQu/KHdGd6o
   z45M2Jt1K47OeJws0K/zdyGlxTrjiyrMXOcRBOPcn2zcZ9MTE09tpwXIE
   XjpP0fPEcktrtrx+EjYtOldFcviKjyFRtNtWdptlyngg3PLTvVXIkxpnZ
   K/HgLte2N2DB1Xf60pGsa8puf2nfua/3VoMBNyItVlqjEMy/Aw0OplhRa
   g==;
X-CSE-ConnectionGUID: 1BZyDORpSeSmN3i8wejd1Q==
X-CSE-MsgGUID: 2uI2m/b1RHyafQ+zqCMM7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="81540292"
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="81540292"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 08:48:11 -0700
X-CSE-ConnectionGUID: d4Y3gbwIT4CZEgEFffs3PQ==
X-CSE-MsgGUID: 3FQ3jQ4lT6KzQPKj670bIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="244436714"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 08:48:11 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 08:48:10 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 4 Jun 2026 08:48:10 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.66) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 08:48:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kpvfzb1A36M0KnnnhTw8b7Z3JyJ6BZZpbRMnE2Q5O87rSSC838vbB828l0MbdxgXbW0On9gJ7ZMV/CYD6caxSEEKhCiwpLt0gba9BT7yi9+uTXcSKE15XA1uGqMdMdpCH3ARQBOgNKQ8wVdP0RHBad4D1Mb7voP4RJi8GlG28/b2gvhToMfNaS4xNGoygx66D3uyI+WTFigvna/lEyKXFR9DrTuBTSIcOPnjU36ZFboxDS0iNGuhyxwi+LnxDH1rbkE/icva3vSCPz31Or0nxYZwBfVrsk/ljVdTsB89B87C0wQMofQdpPogeerhi+hQ/DPKqM6WNcqdmtU6Iq1WoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/CCeCN3GyaLpPvD0FC2oZLfB/VDTaXnrXPSH8uYL+sc=;
 b=jL8cpRKs5o3N9iqy427ftvYzAMlIGWjb65JiUd45tsIcINvV/IQkyMkBxmzfuTFJfPHVqhDb3x6rrY1w1kJCD8p7IIRIcuJ2NUJhO/b6az50IX+U+PrdVbFvrj8kTH6QYACDpwIK29MNmTu9EBmKphrjoIVbmbbDSmujUVQMDwnMZDvglCHyu1QFcRqFQZp2zH/Y+94EQco9jtLIVDHaMJ4Hxtl/LBxyt3n+vaHdI2nwyvMp98b4re7XkTD8d2YIEQLTKGTucUgZRfdFWJ4lVrkZ+N050/bBlaoBVVI8jIeFIlM5waiVxuWL93EzK0lqArKAps36ILDV3OhYQwIKcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17)
 by MW6PR11MB8338.namprd11.prod.outlook.com (2603:10b6:303:247::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Thu, 4 Jun 2026
 15:48:06 +0000
Received: from CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::5670:5b2e:6ecb:dcaf]) by CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::5670:5b2e:6ecb:dcaf%5]) with mapi id 15.21.0092.006; Thu, 4 Jun 2026
 15:48:06 +0000
From: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
To: Xie Yuanbin <xieyuanbin1@huawei.com>, "david@kernel.org"
	<david@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>, "Luck, Tony"
	<tony.luck@intel.com>, "torvalds@linux-foundation.org"
	<torvalds@linux-foundation.org>, "Lai, Yi1" <yi1.lai@intel.com>
Subject: RE: mm/memory-failure tracepoint change breaks userspace rasdaemon
Thread-Topic: mm/memory-failure tracepoint change breaks userspace rasdaemon
Thread-Index: AdzzWUeryVIHgoWJQJyC7gAz88QdgAABeDAAAAVQ7YAAABfXgAAAOygAAAEtTgAABKiwAAANuYuAAApXpIAADqbrgAAEVXRQ
Date: Thu, 4 Jun 2026 15:48:05 +0000
Message-ID: <CY8PR11MB7134B7F76B242515C05C0FF189102@CY8PR11MB7134.namprd11.prod.outlook.com>
References: <4de75e51-025c-4926-871a-4b9da479cefa@kernel.org>
 <20260604134209.111533-1-xieyuanbin1@huawei.com>
In-Reply-To: <20260604134209.111533-1-xieyuanbin1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR11MB7134:EE_|MW6PR11MB8338:EE_
x-ms-office365-filtering-correlation-id: f9873d02-e28a-4254-cc09-08dec250ab3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700021|56012099006|4143699003|11063799006|22082099003|18002099003;
x-microsoft-antispam-message-info: uanOjH9vcxVNZlBu1O0yzhHpuEHBQdVPjC3vChkuJjc0OgrT8Snq9E5YI8geuxhE0PRZqKKBGjfEHMwCeENSVHsppqTjkbCPFSlO+QmwVspAUZPH7QzPqq56URgMJDs6yn4rmIJZKUgbsKAdS//bEdejkqj1GlKuDF8iK8eZlsaSQvKhkiyqjyb3FqWFuXs3GWpWUjhzzNUsV2wUqXLRd0tYly9NZDaP7APoMCXNA8985U+0xEhY0UZyP1c/LFkcJpWk0eDfxo3qSqeF1EcudDOLEkX2SicZP6T12DFPw8vfpCKAeaZFgDEMDH5dryibKwYaIgRXN7c1+C5IssaVa9AJqfsSm2sIc4Z358IODONJcsnpNr1SiyVvO/Cb+xjkN44QJtwQptWT3l1EDybJGyxPSEO6hWUpKp/aZxc0QYpCJzN7CCrXC0z3SUcjo8ivVBbmWQJjUdLSDNHCGOv8gXiOLtJT9MeG9NYueDcHNaPCJfCMI2VcofLQyJRgQFZTT1Yad5rSEtbNTI+/0xyVQ718eu+QUKj8g6o487D7YRH/vrPyhsVbYnptF4aUu7Z9fBC3x3p8r1zwAGnpelCBfgI4ojkPhxTdNilwtYlKw4vas5fp7uniuC2pV54y8KSycnVNvb/2UDdvXTKxtejDiHhNvCNgL+Ip5FbSyuWjxDDv4k+jZ/K1MA+ebofNw8DvIwDHQkTH1Npx/TB1Mi8Kl+mQGHbAICd5WWjmL2UOn4vpjZ8MSLM/Aeh3j+r5kdhy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7134.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700021)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CxMlmh/M4gN2G4+G/PWx/WeXulJ6HIX8AVkaxMKw2RyLvAgS4wJuLTlMSb+9?=
 =?us-ascii?Q?/o4Z28yFGflfyygHTIBLIKshDSMxJWIp8Vphh7szaSP2whpr2xeT9VgFofN3?=
 =?us-ascii?Q?JGH+Ms0xaN4DlTRsLmvTrp4styJOO6Ht+S5fCYyN+Z6o9Rw4e1dXfPv6xb0k?=
 =?us-ascii?Q?g1ekvgfn0ND30eW1m8ItqGG5j3vLacWJQTFXdF/WD6wMSHIUXg4CHFq99ybR?=
 =?us-ascii?Q?3qNmQEkEI6GNAgJrTSqQCEFnxjxQNT9upDy2VRCEaSmB5uVGgm4uIr1JAHIU?=
 =?us-ascii?Q?b8Fv/6geFyBiwDyUJRFDaokaBZd6q5LUYm15Y6ja/A1TVNbC5ttXXSfXXvLS?=
 =?us-ascii?Q?yPRzrvDjJZD7xBV+FEXCbT/3q3rmoba0vRnKWXKGEOcyzoPW49IlUYBgGkkR?=
 =?us-ascii?Q?k2+iPyxaAi7PlIC/23648ivuEnC4T4MdSrX7RAw0Lq5lvcKbPRQzhXzGv7jk?=
 =?us-ascii?Q?zZ64t5nTWqY3RBCa8wOOV20ZrswmNxOPHs/gurEtEqQQxrES/HZD/LCriiFN?=
 =?us-ascii?Q?iP7AmPpxubcQfg7+X8f0jIw6DRz+zvyPEvN2cu/FYNRPuQC6voKdqSMFiNAM?=
 =?us-ascii?Q?0Qz7Sk+4qR0bR15NiUJk7Cigx3WGjxvP0cv0uv3lBNR1uF+liYlej6I3kuBP?=
 =?us-ascii?Q?y9xLW3bRjGbH8RQayMc+5JuqsmquWz7XuUTYJHZ7HP34e94TJa0AF0DZyEpH?=
 =?us-ascii?Q?IB0xYPjxAp+dp4Tz47Nn0L006j+gRusMT9L7ziJpSGpZ9ujNjHbZvTKdkACR?=
 =?us-ascii?Q?kjWAla1O8sp1xv9F3SAQ1vD38lGqkjdL8GMVXXFzYlPsXLU4G/3+Puk3818R?=
 =?us-ascii?Q?ZTZmIQdk8pnK2bn3CWnMMO6a8e1xoz2Tmx76hhaAQTAK8DDEZWI8Abv+VcDP?=
 =?us-ascii?Q?EI78UW41c3b/vaAQqHmwip76X7mu5nrIQgw2wOWB3bsD30ogTrFshMdNxx+e?=
 =?us-ascii?Q?aOpzh45bEzPIj28L+7kzjUFTguFadzrTw7Gqd8h3j8CgckxWjnx5ptL/delu?=
 =?us-ascii?Q?yNh67vVieATDeVShfBSblwyOqIHW5svpTaDMHvmKp58ulbQ0N5n2NBffkqaR?=
 =?us-ascii?Q?+ea+Xb1ODg7Cd/bCruSCBAT+GsMDwQX19sNThmzOS1tDkDG0WiVbTUmz04SZ?=
 =?us-ascii?Q?b0olD0yEBowS713LM/3IHyTuO60slOZ5FJfLP5BPTeuGq8Iy5ixIRGAiGjPd?=
 =?us-ascii?Q?if+HbHn8fjueF8BTJkCUZTqmK23Hd+jT9leXCnx4q27/NGBbjMHrMB6N0DhU?=
 =?us-ascii?Q?qsDo/HwnbLz7cqBuTFc/RZI39OPOMgFJAc0wg/u+FpR9cDyZLMi4gEXARKW4?=
 =?us-ascii?Q?P8lpGNjpO3oWvG9wieRVx1SBPAtzYyQLFmDiHUcRC3gx0nDCgECRYj1mFVON?=
 =?us-ascii?Q?LbCR2kmu+w1Ejmzdo+HritYlgs5S0ZJwItLHPLjTJuDQuUZsopQ2TZfl3GdA?=
 =?us-ascii?Q?rXbfotin6Q4SxVpFRB02s1trnf1J1PMtpZzPcgdLRNCsnWXdkZ2I6ZUDj7Zv?=
 =?us-ascii?Q?f1MvmLLj41YxAAQ3fuShf9Ma04q4jScT6p1y7Lu01liHLRwx8/eP8FfyP5dK?=
 =?us-ascii?Q?yGFtP1GxDxEJkgK4Rat0jMaW3CKCF4Nekxo/Sc4OB+SEhIOZfjc9VewYsFWr?=
 =?us-ascii?Q?oY7yemGvlnt3D8jKY6OfhLVVpiIqk1eZ3asEkx+0yysUC670r6fQJ94qrxhY?=
 =?us-ascii?Q?PgYVp6UBUSkiEgpihdYrqn+xEaLgCueBh8crS1MUk7IHTRbK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: rMTE7J3BuOnAu3acitnlnnYSoUY4xFcbeO+vQF7YnvGgIACp4LEE+U9WvkuiUOS6Zcv9p8vN1bOtfzjOYWtOE1VOKqhcVJMGRBBSpHXylAzYbfF1jRIZswafBflDH/FoxMljwQxZ5VIxPaZAvVV/us2Ob19+UPWZEKf5Lnmr1stoi/4WaWx6eMQy9/Q70klPwOGZGf6EH/3UvElmM7QxEzY/k5JK0gKFO9Y9ZX4jFIxcoYu98hh2E5pR0SYWWtg04ucLGp+PhXPzVeqAnCy3Dc66asvhUsOeVU84mGC8ad5M62POfmu/XBkXVy5GrAAwAhnQy+ZiLTs3LCl5haJYnA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7134.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9873d02-e28a-4254-cc09-08dec250ab3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2026 15:48:05.9371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sRe7SSpzcbyWx1IlhGvh+XCTbPQoih+nhmPRwUtJ5XwHbcC8ZL9gKPtVo1IofrZRjXWrx3dHm2NG9RILpHbW/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8338
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 4mxjae5z57esykm197nk99i18prqi84b
X-Rspamd-Queue-Id: A2727C0018
X-HE-Tag: 1780588121-903250
X-HE-Meta: U2FsdGVkX19rX8c69j2vkNLlLhsrGlxjDbXPuBzeSgNWKBVwB14S8S+X7wc/oAEUstAbB7e6cDjjy0Xea32k1CguMhw0taHVmnKM94OfI2AsNyAgKZNi+XaJtobdxBd5SVolQEL/JA1Kdy74MoRxHLVIDQfNhvalJUFaTs14ZaOPsZ8wyVentUQMGMJRNG4Tm5kCPkuV8wlwfK/5gEsPqZV+HAS5lJUYhXnP1pg8LEPqtA5WW1SfNq+pHyD/mqoJx1WnD3uLJTp8mGBF4mQTV3jHqigmXUHIH9ZFomIQmV6ojfSAYLMHdprZ/UTFW151GkUtBk9hAhKLDeecYVHR6e5svSXpMewovEPDHQgHv3lDTFMQzDRmRsCzWwRcDqKHdREUXPBws98AhPL/q0FtIjv4qNtkW0v4MWQQ7S3lM4vf7ki9TY7Shlf7ewVMQLETW/MsoN7SqmY2fjKDKWz5fNPYDzLOACcz3OloYZHJ12obXJ2RxrrftVVYI/d7HrCawnTZcRCtqwJF+oDDMKwFSmjf+vNGCoHOQfdW2zP9Oe41rgsvojVhn9Z9Vm105aVl/sQJgL3YotKw3r6CNUOyFUs5Ho2TtCSnfT2JVP/j+9Ov8lvKYlQFEbV9lwmeXeadEK6vs3UYRNa9KG0pfSR8VWEfZ1osWgJcBtDBXhIAQdivp+NGoryAc8W6d3yKiPcJVNFju8bFsWOIu5wpwMHThx9ZQDfysIgLLFIIrrf9un9Rz7vspFGRSAB/RGa2Gv4Ev+HSjAafXGukiAVZDFdAXfpfH9+vQn3ZsRiSLFEIcsJBXSp9EvmoNmeDTGikEf0NY7BF2/OGtKj2kA2QMQqE//3LeLZ2wTusOaorSImpNF4/jrMkscsXxeMCaD+f7n4Fx0FQPR0TVvPxMVXjcz27ybgpOLCTVi9RXzZHKbG3Gu8AYCCnbdqM5etAaNpMVK8S66tj/x+SPLsWwSDbdhP
 1AsQEylE
 WstFRn9EfWwQcMY3aCmXs5y+SV9dQiZ7M8HGM9dF5q1/Jm7N2FQQCBvIFce+gjMpycOi5UTaO7BuSxQXqmyAsSSBUviVl1gDYJhviG58MI4DL57LGp/FwZo2g3evYRCVWvP6+nfRk0lCiSAo+mLWP/kOk3RAH7mUaRTXFnjnW5bupwEcJQr3Vg6Xn/jmiZyY4uKceIKXYyWEfQyIMv5/lWW1HKzkuwpDTaGTVA12lvN+4VHvvScwBo0+//ti8toiuue1MFMR/QZbxifSh5CsXjYFTL6C6aVuFDJ67oikSIoBqXx0QTdaH2ytMx4zty0Lg9GB09ED0LHGWBmTzPbK2P+7Hkr7lVEnr54Lh6N0wCtIIGZpXNJx5JTAW9SucKkxvpQo+R3INO5sqAuxXeHVdK/3bvJVGu/extg+Kl8xSvBgYH8U/raO+TXIBEK59iIMHWeLSG6pAVRnNkwoTZxt8uI66MMm+ElfFD0ViWAgzXm/2MI0FXV2/M1dHppftDUguca4TlS1bB1tXz/rADFi6c6K809iBwFv+WzdOnTnhds6iXrEhgelGNwAH1R/7g6doICi2M/t9wDFzMLSK5s3aue+uqIMiANmht8H8JHo5OMknlnBcs5I/6svVlzrRxQeIzTSpiyYrPF/WJGtmKjOuysd5IPrFQW+6mWXBzXNNO00xzE1KHgWp72+fB4MO3bpc6pcTd4WKAUgEDH1Af7Ernm/FIZeyvRualL7x80helho0I4Vud6KTtzNhUNoPJVmp5C8XtQPIV2pJQym6J6/KUJQmAZ4O8iIylIdkrCzUY7gFemjx/aS9KscuV3bh7jTDISwQDg7QbJVWei7OHKT2FIvevg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Xie Yuanbin <xieyuanbin1@huawei.com>
> Sent: Thursday, June 4, 2026 9:42 PM
> To: david@kernel.org; Zhuo, Qiuxu <qiuxu.zhuo@intel.com>; bp@alien8.de;
> akpm@linux-foundation.org; rostedt@goodmis.org; linmiaohe@huawei.com
> Cc: linux-edac@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; linux-trace-kernel@vger.kernel.org;
> mchehab+huawei@kernel.org; Luck, Tony <tony.luck@intel.com>;
> torvalds@linux-foundation.org; xieyuanbin1@huawei.com; Lai, Yi1
> <yi1.lai@intel.com>
> Subject: Re: mm/memory-failure tracepoint change breaks userspace
> rasdaemon
>=20
> On Thu, 4 Jun 2026 08:42:37 +0200, David Hildenbrand (Arm) wrote:
> > Yeah, if only I had known that we would break user space by changing
> > trace events ... now we know :)
> >
> > Do you have capacity to send a fix?
>=20
> Sure, with pleasure.

Thanks Yuanbin,

When your patch is ready, we can help test it again if needed.

-Qiuxu

