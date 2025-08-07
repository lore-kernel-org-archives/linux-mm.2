Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C75C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 08:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30DA8E0006; Thu,  7 Aug 2025 04:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1148E0005; Thu,  7 Aug 2025 04:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A0B8E0006; Thu,  7 Aug 2025 04:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7CA8E0005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 04:17:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9A7A81D73
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:17:48 +0000 (UTC)
X-FDA: 83749257816.24.A84E56A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf04.hostedemail.com (Postfix) with ESMTP id B9EEA40003
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:17:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c8uNat5q;
	spf=pass (imf04.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754554665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=b6KKZZP5IqhhHX4xD2VW0cNDYQ2/39+fjEgwUQ51djs=;
	b=PFIENwhyFbxBnegvBNdTgCXE7B0yDYW6VKlzfiHtRT0QLJl8JpdaYNGXp1uwD1iId0Xfy1
	0b0O8hID6ZyABI/F38UOxcGSBfRJ8E3/3STGSoYCvG4i8XD3vqrNKda4meqDMSrTrBn/ko
	6tl6dgiaUcgeXlXzYSNmto1Rd2dTFAk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754554665; a=rsa-sha256;
	cv=fail;
	b=yWNHrO6ZXqfoU15ZgSYQT+aPovs7Dcg90BVTWTs6/Kti6fA0HV+WKTpxOnbFn5VuqsGzwK
	n6yUqVccmMrkw4/N40dlBF/aSguKGZ15fdGqnegua0nGoL+hdDwIZhjyi0NF0l4NYCLoHV
	CqHnHs8LehrrErFtmqvMjw9RbPZ2sm0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c8uNat5q;
	spf=pass (imf04.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754554665; x=1786090665;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=0tilqx6Vb2kyyfUgBQIFnViiQWNMr8OSDdybL6UBjR4=;
  b=c8uNat5q3AWCQJsJb4MYpBAR8uubZR57Ciz7ok95AFJvVl1lputpf8sG
   y0BP/L6DBNQjGGMqZxmt6E3vGvREsZMqk0w04n0pp4NL3liOttsHsFoyO
   zKXh+dN785bMwSqsc9K3kcwQTk6KH95flrMxt02P2btcSeyhZ2KPNks6Q
   B9VPX6cLp9dRYQ+wxs7rDafKlb5gqqPiTtMi2Chbn93tSz4Rl1P654i/S
   uW/FfX9NhEuONhdY0ohv0qYr+U4uuTaZ/tce64FbuxM+81jumvc6JRQXZ
   zGRVMWWXe6wghdCkINTrFBh9frgGE5JuyYaawAazAinIdYqOt1D5ergjN
   A==;
X-CSE-ConnectionGUID: /rnBxanMRjSdBJVJdb2uCw==
X-CSE-MsgGUID: HEY8FpGNTHeK78IdqwgpVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56780121"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="56780121"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 01:17:31 -0700
X-CSE-ConnectionGUID: ZVRMLf3TQtSm4+4EVFu62g==
X-CSE-MsgGUID: 2W/3iR97R621yZczC43FQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="165004297"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 01:17:27 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 7 Aug 2025 01:17:26 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 7 Aug 2025 01:17:26 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.74)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 7 Aug 2025 01:17:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w9m4TRjPyvHb5Dm91O3tCB/A9YAbU1WgPWa+12i4mt0oe66GbhAdsvTY5zGtQ8sRwg67+6OKxWWXO61+PUdjukufC2ArMhbsFs80nWkFOwmFir6Cf8QV7mNhMkTJHFfE6MdjApu8H3ozA3ArBTgA8RRaB0l3b0IJ7Q/DFRoTC0WS5bQti8M4y0XrdOo5SpuNUd7SgAZ2i3GfF7ZLcg16JTEfoUeAEn60qWhZJZX+/sEeqLBsxZ6NSXTl3EgFiQUfB5Cpyuwl2h72PONjPxLPK1ppH2x54s4OpqBH/XlhDp04VCbOxrP0Gr+hPnM6vHOU/cmmzzc8wQJO0xO3LR4XLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHRDIo9Vlq6uQZURHEEwQuS4GW87cjtCjkseegx/Ctk=;
 b=EG45pxBerqffevOYwIlDwYOJaq6vJngvK7hD1Tbif61oVUz+r531qvQQtbBW39r/JKoiZ06WrUeHiCAAALAv/XIRXrptckYylCfKkJr4HNeCfoh98nHzcN44A9mdXS2by1bdWZPat8DWipMpEPXuJFmnf5ufzSr9s8bbmKTgpM/BqZTpDBiunQzyMU+Bm5Hj+YG7XMIXI3gHqK7iicM0RysIrWBlYWxkma7nN8R/I2ce5HIX0Vs120pX/o+gGR0Xgicys04CWKK90oaef0uIdo6cG1arF8URhO5c5+lvGqJAeVHt3pz8SuX1tNA2n/21JIm0MJ3CanN5zpgjGDtt5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH8PR11MB7991.namprd11.prod.outlook.com (2603:10b6:510:25a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Thu, 7 Aug
 2025 08:17:24 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 08:17:23 +0000
Date: Thu, 7 Aug 2025 16:17:09 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Dev Jain <dev.jain@arm.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro Falcato
	<pfalcato@suse.de>, Anshuman Khandual <anshuman.khandual@arm.com>, Bang Li
	<libang.li@antgroup.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "bibo
 mao" <maobibo@loongson.cn>, David Hildenbrand <david@redhat.com>, Hugh
 Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>, Jann Horn
	<jannh@google.com>, Lance Yang <ioworker0@gmail.com>, Liam Howlett
	<liam.howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, Peter Xu
	<peterx@redhat.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>, Yang Shi
	<yang@os.amperecomputing.com>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [mm]  f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
Message-ID: <202508071609.4e743d7c-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::13) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH8PR11MB7991:EE_
X-MS-Office365-Filtering-Correlation-Id: 0778cd1f-6fad-4402-c011-08ddd58ad63c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?RDTtJ/izE0jgMORRSxboq5U/76gmz2YXSfIoRFZQA/xj3MMHylbbNvPwsV?=
 =?iso-8859-1?Q?Cly/OuatrbxdCWECJO4nk34QQo8Ztlg43GkdkZFjS5JkcemXWlVDgL6S7a?=
 =?iso-8859-1?Q?nnWVfsX+KA3eg35m1Zr3t3PPAgmDhZbhP0lmfdIXzgR9sIK3TDi536A6sS?=
 =?iso-8859-1?Q?dLYeVE4J6zmIkg5WKaDk+HUQqlYDO51X2y5DBSbwCtVMyNHwr7Af5TPhIG?=
 =?iso-8859-1?Q?SCoxl6UXqkmAA7zJCHeV+EF2LaAFX82FkLEGnnmQMqH2ndbkZIMKCWbuSF?=
 =?iso-8859-1?Q?fc3/tOj100vbU894e6SWZHxasdcsUBrUdO2qW/tyC7cbGaDJTKm1pNZcHK?=
 =?iso-8859-1?Q?ji1Ukgh3aH4dbSeKziSWWdroSi4mxIMVcWAIthmzEyejPF3+wZ8BudyffP?=
 =?iso-8859-1?Q?F2U+9j7YvKq4TSIkYZtW6ZJxMFCZWWi/GKaEUBu6pNRr3zhW7CqTzdLPYK?=
 =?iso-8859-1?Q?b1jWb1KJk4kMuHyTM/a6qZY7wnNKUifxplW9hOn3oYFyZYhww6RGfpWXGu?=
 =?iso-8859-1?Q?ccyR5QFZFFXkC+L/ZQZ3mHJnihlQtW3+/dSc7CyKAXrmAjttpOxObvrn0S?=
 =?iso-8859-1?Q?BH33Kq/q1TpfaUNhPhCp34k8BOD8VX9d/x21nvf25+sAurrjeuEBkSCrVl?=
 =?iso-8859-1?Q?Fqw6Hi5j/vD45vi87UfJsnCgsZH09/tjrUfx6AwgtAvzkv4kDQkbu+eIof?=
 =?iso-8859-1?Q?qDx2RfEN9n1U9WrGAUiER6yzpa1evKwAMfuI3xt4TABNEv+4T5p0hCgA0p?=
 =?iso-8859-1?Q?XswL99UuUM+XJfCCABbzGyV8A8Gw1y3ilC9BPNaYserNrbHmFZiyoww+kr?=
 =?iso-8859-1?Q?u0WULiXICUXeFD4yVb9/HlGui0nzBQFqUsDBwQN2QuKmUXCEAQYFLhMlKC?=
 =?iso-8859-1?Q?8j4GZ8KW+VZIwKjQlURhqoQnWN1AK1xyzzYUu4djitY3geO+NBY2IgcNbT?=
 =?iso-8859-1?Q?wl7LcM/EbD4XkhJvtUbAytbvH/Mn6w0wrY9HfoJPjO6dn78mJuDECEWvri?=
 =?iso-8859-1?Q?Kto9IMpuQPCnoH6Od48/wDNcinqWP/vCbVb20/JrN/tisV9m6ue+QFVt8P?=
 =?iso-8859-1?Q?BT3M4pKZeRxiUCg/GsJ8Hj4RgZdip3wSuda/8AhNdhdjwhratgcJhSiOEY?=
 =?iso-8859-1?Q?HhEfC9fUZoVnUjYyBUtaI0nlIzZkat4Raxa4iQ97VQQqQs2hN6xmBp09Nh?=
 =?iso-8859-1?Q?QjuAdMhh4xNiE55+Ga10NAOBqZyj90INJJCbz0XPM5Y/Fle6NqoyRUAmiS?=
 =?iso-8859-1?Q?dLFq+064j5vIhsPKD5fZhNpi2EOvBJTwJ7UY27RnZWHn4LW3kLlDv7KBAP?=
 =?iso-8859-1?Q?k7fX3+iZlAk86c0x/mQNS4OzbRokW8dP40VtdvX3BR/2x+os4HUz17pyu8?=
 =?iso-8859-1?Q?EWKzeXRWj3SYtU4ruJXnRrBMsJOZwGzowWBkkAltVUttQrPDvj7m+Gy5Lu?=
 =?iso-8859-1?Q?vDI3kDw9PXoFCFad?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?2FX1yS4zpKZ3/7+I2iUo17fwy/9VQCGZ9YZpUj0VxA5yShXFudQCJ268dt?=
 =?iso-8859-1?Q?JLqor2QU+4yplrhaZAL2Kowl9URRPiQIyH8MLg0Sq9+mXR40/9ApG/ILoe?=
 =?iso-8859-1?Q?ch2mj+XNTlHvawVIMxcwRuO2FLFO/v4hURl1WvPg/Xo1P7BQIxjodXEfDp?=
 =?iso-8859-1?Q?6NJBnji+jDq09qe886wnCLt3ypRgxuLAtKDIVr8JagRM8WUY5PRvQkShlD?=
 =?iso-8859-1?Q?mK+IpLGYzs1Kz32Ib5mG2URESnxphgYAIE1GwhyPJtQAU4dfmKDPQImj8n?=
 =?iso-8859-1?Q?RQfqatHFVuya03Hj7OMt1SPB87leDLr7eWk9CkB6Z4/ya3njl9CdszZeJ0?=
 =?iso-8859-1?Q?CXaD7Wpyna2vAXcjgj8gPshSOBTkRYyEEkwzMm8gFT5kutIRhy0ZkvMU+2?=
 =?iso-8859-1?Q?bbk55pnuhNpXPIbi+4Bzvgu402eG0UQ2NtjvDU8ISrfA/CuYvTW4QGXwvD?=
 =?iso-8859-1?Q?Jkf52CM7MYA4XwwFYUb4CsguFrYDo8ksogpzNVTK4OauXlIIpLcd/rOZ5q?=
 =?iso-8859-1?Q?W3J1GL0TBHa6R+NMODxmMBiKj5tyaX8I7KCC9ishKk+ulZF6j5qxOsgGPI?=
 =?iso-8859-1?Q?aYcwzsFoCTX/Tfrq6ECtLi3uKpVynK2StoMq6xnl3RXcVhSyTtKfoBCqq5?=
 =?iso-8859-1?Q?SIu3oO0qvyr/z6reqBIU7JvjcA89snCgvaJWsqdJu1w0HbxRESPkRkOZI7?=
 =?iso-8859-1?Q?6pr5fGDkG8PX7FtDlz+W/EUOy6k+5swSfGZMoZp9oDRydob7YGkA6lIMC4?=
 =?iso-8859-1?Q?/ZiuU8yFr/Bdh1He8RVZCTaWpuqKMM3pl5529li7CAUJ9N0GkNPoRYkHzJ?=
 =?iso-8859-1?Q?9IDdUJiMla6JoSdkdVHBf3RRYhN3uyOYAusMFqzBz4bd+guVKV989k6o9c?=
 =?iso-8859-1?Q?pJuW4YbTOXDQ8qzh9GKiZKPet3C51JGwoJRYpozGPAs3Hkf4Sox3hEHTH2?=
 =?iso-8859-1?Q?LmUrnJAkB66k+rVX2fdRUhDTQvt6pVPgbjRS10XQYRLU9gsl+EACPIz96K?=
 =?iso-8859-1?Q?Y91+pIRt2K5qO09Rwb6Tjr1YXUmQCIrYqzkLKkpBNc7gddxg+RY8pZDZZ0?=
 =?iso-8859-1?Q?7tNDFqb3kNFqRwBidMJhzKXWaOh2Z+8Uf8gjE8S81OLNZOgSrpqA/3ffFh?=
 =?iso-8859-1?Q?2sFUOaRin2taWMyn40rLInz72r4IUDOgB9YDSOM/EG9RGibU2oV/yFRenU?=
 =?iso-8859-1?Q?qFpXxIo12YSDyKo7jmvNhu72LNT5aYz2vD3HIcxPKbZtQx491GB7uwixlM?=
 =?iso-8859-1?Q?dPwFSsDrGrliTfeb/RzWL1ZL8Rz3s4bKjPzKWoKviTWgX3BWxu4X4kTQhO?=
 =?iso-8859-1?Q?E7kxIVBx/8D73Xkx83PhQNXSJK340eANyJvdPwgxzUpkuEHzY0v7nJjfKD?=
 =?iso-8859-1?Q?hRU5qf5Zthm2CDFHv1wIY/f4GpFlrn7m2XlMb7stNNRoc5Av1/Flpu5H85?=
 =?iso-8859-1?Q?JOFxB4mYUDwaH8xkKblTNOrdZ5gtW1V5qScXzaSS5uajqdL/QXuVP99XnT?=
 =?iso-8859-1?Q?yE9IFMF7S/YQ5/cHq+ou2j2+jraxH3useuhlc18MiGfCHNGNDiJQPTDYK8?=
 =?iso-8859-1?Q?Hu0CUQpoqb3YyMyI6XHKG5Jec0WnWYOJstf9pEuspD3kING7fPg9GI/LCL?=
 =?iso-8859-1?Q?DFsAfvo3tUc0lJ3/uKqXsu43RuVFYLlgscVy9oIFQZIfTgDkTQhcXx5Q?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0778cd1f-6fad-4402-c011-08ddd58ad63c
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 08:17:23.6225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Px8BYZSjMma/5rHkUH5B8tLacGTAv9+iNl7FNz2+Vcc5BhLKc65JcMLedBgAmUw8cFVIoG+zgcxGcY6sY94L5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7991
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: B9EEA40003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 7cqp5c9aptk785hio8txhzosr8k8w6ab
X-HE-Tag: 1754554659-660778
X-HE-Meta: U2FsdGVkX1/Wv1m51FEyeJfRfRdl5xdMdMe1gPlcUESuOj2X3aIOIu5kI6sSmVzMSRLY+109FuWXbGxzePxgETFZEdj8pnuwvezp9lT7ky6cr/QFONRg15tXGUELUhEPQM/wBgLmNOBCJPbsXOTfmLMQjNMxdGbDrxwiz7+g6F9ZbUxDdvE/kFKBK+WY9hcoOw7eh6Wq1pIXf5aKtDbdJWadx+J3w8pLe19zRbn1FYKbVjFo3SC5GLA2qU3HYdASptbtJ3otDRLiDswAD5OmvTLR/gQ32f3xSAfrkOmp6KQDnWSQR4vXfrbRAkYb5dtvm7lC4TbBkQkKBxAMy3/TwfYDxP2WlNS7zSYRheKVoWyb+zJjGVg/zPqK7vce/BoohkHpHUmtA4G4KuYYyFbZqxSg6pXeWq2xOjAhMYuz7NuyIg0cJ6CTlFoIw8ReKqThzOnHOMhUhkJdWFXJBNaJlK0qfogMCjEX9iJhubwwBjxnlGlk/L3sKSZE6eCW1r9lyYw6GVT/FKX0YHdUH9OBOP7M+SMRtn0pm/G6FWo+YW1A/DEfvCem0EN/uPIOM6ZEA4dKLs5unbp5qfWTxeKzCZu2VbSBWoopvM9a89UVXfNiOId5d94BG/a/BqXmiqPJ9xlIik89N+q59J1avujtbSbgGSWuZWlzW8chMnKC2ZoLTPShpkXdk//9dzAlYLFbLQoxCMV5CHr8os9JQ71jeMGtZqW75oFZtDNYQTYdpidlL/p5A2B6LdrnFTpWRk4G55lRjrVt21WNiDoXFvLktPtx8AHtkipScIN3v5Er01UdDau5B8wL63ze2BrePPUeKbsxBFP7nrPOJFf14JPXJu/jt38RwObYkjm2rckGKMfNSALtEw2CboNbN9ufKmtPII0N0+YJJ6PNOE/2vsnebPzl5GH/hRMa8H77gsujdyHdQ3aDCxGIw7yaDOuHwEaQwSq4Vnpw4Fs4+7LXs0Z
 cwueCEPl
 /z7Trtj45j3NW1tyg4/ktSWxJ1m/YZSQmWgE66VjSoh1AhQM1zfWMFgdYzYbeicrogyJu/cXPBCl3/tcm/QlfEbQbV5UmtBOO5JN4Z+n545+pXi/3RS4npuIiCida6gRKtQlpOwJ4hqcwL3HlWG7Cx8WLAVzNeZDGuv77BY6g0uXFP8jtpWnm442kcdVQGW4ba4EJJ5xKpRcKMiJZS1UCgHNDbl9NnRybPrvhdtP9PT5i5/xzg4ChUln6+/l7qr1TW50Ey9/nNRD3CqZu3C/01Mgd089rAx0WCWnSWZGsWoKoA0m4NLKy+U8J67NnxNSy63VmlpHLu5M4Td8Az010bxLsToOsZSwjSMWW3mzVjFQF8/ksQuCvHn9hIZwp6V86vDFMuTRwNNXLN66oOXar/r4JmaolI3E+k6wB62KKGlmYaP2Ai4D+8mWQ290McZ70YGFVpYWvkuP7zblZ9rq1XO9i6ZPHvK59zdGfvvYY4t+7v4xmjzm/t4J/r16ONw1G2g6Vz7H4EZjmFmnBXmketJNi4INo1mhW0wWuCMI0lXCqBJk3Z3j/x1pWrBU++umAay5WRoC+iAaHUrjlC/UfGrwPtRtBfKZdYZtr5UkQLOXx4uQiDT6ydNBTNUeq8ozoamxeR0PJOPvJF9oc7osU6nFd7ZebsSuNdW7p7e/XeYRfaxfLdQg5YW4lclfVK7sms00YdWFXuKL3wtg+AIpzSK04NSXHKY4bTH2CqJ5gUYQQcJlREiwbImj9h2w4ZScGbIqFSbal8uJMdrU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 37.3% regression of stress-ng.bigheap.realloc_calls_per_sec on:


commit: f822a9a81a31311d67f260aea96005540b18ab07 ("mm: optimize mremap() by PTE batching")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on      linus/master 186f3edfdd41f2ae87fc40a9ccba52a3bf930994]
[still regression on linux-next/master b9ddaa95fd283bce7041550ddbbe7e764c477110]

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  CPU @ 2.4GHz (Sapphire Rapids) with 384G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: bigheap
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202508071609.4e743d7c-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250807/202508071609.4e743d7c-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-12/performance/x86_64-rhel-9.4/100%/debian-12-x86_64-20240206.cgz/igk-spr-2sp1/bigheap/stress-ng/60s

commit: 
  94dab12d86 ("mm: call pointers to ptes as ptep")
  f822a9a81a ("mm: optimize mremap() by PTE batching")

94dab12d86cf77ff f822a9a81a31311d67f260aea96 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     13777 ± 37%     +45.0%      19979 ± 27%  numa-vmstat.node1.nr_slab_reclaimable
    367205            +2.3%     375703        vmstat.system.in
     55106 ± 37%     +45.1%      79971 ± 27%  numa-meminfo.node1.KReclaimable
     55106 ± 37%     +45.1%      79971 ± 27%  numa-meminfo.node1.SReclaimable
    559381           -37.3%     350757        stress-ng.bigheap.realloc_calls_per_sec
     11468            +1.2%      11603        stress-ng.time.system_time
    296.25            +4.5%     309.70        stress-ng.time.user_time
      0.81 ±187%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      9.36 ±165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      0.81 ±187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      9.36 ±165%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      5.50 ± 17%    +390.9%      27.00 ± 56%  perf-c2c.DRAM.local
    388.50 ± 10%    +114.7%     834.17 ± 33%  perf-c2c.DRAM.remote
      1214 ± 13%    +107.3%       2517 ± 31%  perf-c2c.HITM.local
    135.00 ± 19%    +130.9%     311.67 ± 32%  perf-c2c.HITM.remote
      1349 ± 13%    +109.6%       2829 ± 31%  perf-c2c.HITM.total




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


