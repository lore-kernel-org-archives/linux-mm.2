Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C897D232D7
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 09:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C6976B0088; Mon, 12 Jan 2026 04:43:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2176B0089; Mon, 12 Jan 2026 04:43:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE93F6B008A; Mon, 12 Jan 2026 04:43:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDD8E6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:43:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58070C28AA
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:43:39 +0000 (UTC)
X-FDA: 84322824558.06.1C6B1EE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf17.hostedemail.com (Postfix) with ESMTP id C87A64000F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:43:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kLMfbArO;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768211016;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHBR9WN6fQHx6U5N+qp89DQege8kbFhk9HpOxIRMeXY=;
	b=21Mj+izBFRsy6LSLfGB6LgOrVxQ5YYmlA9Bjgs98/2w9aEeu7qmTDt0z0o7YnuU6ienxj8
	mAN6LJK9bkHyY2Cbag4ui6pcojI0QayEhu+dKUInniJAvhoKqhNmYkOU8IVNS+sUqrWbKe
	AZdp1dBQUinvk0osf+s+LjyUh+q5Gxc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768211016; a=rsa-sha256;
	cv=fail;
	b=NDtq4Q3p/C4kZIY57B+75hmbO83jdiuglGDYGe9S69UehmcQAoVeLF5Fw9uitejUNBaFv7
	YNijlBsCrOAhhSGXq/fJXl7CCJu4w8CAZRlG4Lx/PEtnbpShOI+Eq8X5pZQCGrKHiJFDwY
	7//vkc3cNJMQktk0sXWcTiS/KSP5ffo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kLMfbArO;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768211016; x=1799747016;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=jHBR9WN6fQHx6U5N+qp89DQege8kbFhk9HpOxIRMeXY=;
  b=kLMfbArOLKpdiYGKLfUZ6QatUZFJ2WXy26APvpbaQiKojfdvevrxPTd+
   ehh29RbyF4nWrjLkbUn6gKxqC8ib0Az3qZuDE7eXCS3B03UDPiWGj2GE8
   MTeJSJ5CN8r3zpNFgqsN6loxRbLUOIBOE1rEfCXlu3wPijY4t9pSZI+6E
   IeEgorv7IdvbdjuZg5XQfbk6SwxghriqS2tDlRw9PT+XdjxrRaLRrutDD
   y2wJVD7YPGLRPZ/kQfO/WzPtl6vk3r9jR7b4rNmihiglVFGEGe6Ka2S6b
   1q4KAqDUz6NNr4JLswoUufViS30YMNxr3KyQPlHdY2tDPFO4Kg9xgs4KM
   Q==;
X-CSE-ConnectionGUID: iN/IHU0RSdOtCUYmLZItfw==
X-CSE-MsgGUID: LqUrf+6EQymyUw/OEy1JQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80848505"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80848505"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 01:43:34 -0800
X-CSE-ConnectionGUID: jKdfUHLJQVyHyr6cfm/G7Q==
X-CSE-MsgGUID: svuoe9vBQAWULEQL5F6qpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="204328946"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 01:43:34 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 01:43:34 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 01:43:34 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.39) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 01:43:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kxv4tXoWBL04/awWDiCZhbafZsM5fuuR2OiHyzX23+UayAqUDNrENapcMyQRhJep3k3KNhYybkThMa8p6UnYfvtf/ss/tEkSHSDoatjF8kHQdxhtsJwlAgRTBqlyPIYGbvXiu8NTHcr0Egn9+1HCPjqNXXJGAsUNucyDDRZdCWqI3/AIsczlkXujwGMkXMgAeK4Z4iWJ4yiWxWDsb26XlI3ZPFuPJ32HiajAyjagqwSYKsftSrsqri08qqIJ6B7SY7KxAiCid8hdobgcWou+UP7hnm4GE4r+USQHZAUkr6h8nYCNb7Qg16isk+C625azbgbh1tGJmAoa2BUtXSlrcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHBR9WN6fQHx6U5N+qp89DQege8kbFhk9HpOxIRMeXY=;
 b=v/pz3HX7WRSfBnU3EapUesT956Rh6LwCvAMcH7mSi31x8KBrYGu33KugnzG1mhaVFzB9wyMdMaCCeb7nwkQCUbUJ7yKPiEy3dTA7EuOin7uvlGq3eeinI78QOlHxSdrUtIhaGqJXjFokbY5n43fdXUX13zx+sQLzUbRG70fS2RSha0Trd4lexu88tekUBx/fTwIGC8jUElmOwVr6GCUzgtwszudBZMev6so0FqzdPH4A4AB9wK7oMjb642mjzkbg1AqwUjg1BZv+LB5igVoSqnmRKR0oLntJYeACzDSMDmbOM0mLJamThzRVls67WzwdhH5fPkrqHt/qLp2jgH53FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA4PR11MB8914.namprd11.prod.outlook.com (2603:10b6:208:56b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 09:43:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 09:43:26 +0000
Date: Mon, 12 Jan 2026 17:41:16 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <pankaj.gupta@amd.com>, Kai Huang
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 6/6] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <aWTBvFnrT6Y2eF4S@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
 <20260108214622.1084057-7-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260108214622.1084057-7-michael.roth@amd.com>
X-ClientProxiedBy: KL1PR0401CA0004.apcprd04.prod.outlook.com
 (2603:1096:820:f::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA4PR11MB8914:EE_
X-MS-Office365-Filtering-Correlation-Id: 45bc8eff-9651-4173-202b-08de51bf08fd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WFh5OVmr6/Op1i2ZEDr1yX1ZKR4B9knCCwEiYyFI48BxK79enTdU25HPXFGq?=
 =?us-ascii?Q?53/H2trFM2008vlGnaC5lfOOHhmzNQZV/fKLbMDzHg0Ul7KfXpromaFYEBhk?=
 =?us-ascii?Q?AwK+6tFar8sJgPHigTN/LwhR6z8aN7a4Tr/R/3NA47ooiYUNg2O0L9Mtgze2?=
 =?us-ascii?Q?/AYQavPowWD+M099aV9iVfbM8saZZUBbCIoZQbRzUGjJkFEWpBRMttX2v4Rw?=
 =?us-ascii?Q?PKTb7NvSQFwM+qXMpC5eeXdwFPpuyOwoFU6bbYrubXXgdvpohEvm4A2eHkjg?=
 =?us-ascii?Q?Op8ZQqtoiy+yWkMhxMFjofAxx8s+yq14+4geezDPY17tsLDQswaeCv/g0uKe?=
 =?us-ascii?Q?2WWU1NkwKY522z5uUdmKbiKNE71l1JDZotYaV+oHxCwG3qVN3pei/Ug+Yd3Z?=
 =?us-ascii?Q?2zND6L0wFdKcrv/F/NEpI7CN+MIJZsVqq27sd4WmBi9U4j+xacJ5/+j9l2nt?=
 =?us-ascii?Q?8C7zUvJycwbntHc5E241SO1Hwnv1QHl4FoMIyOkxTog0uKmc0PTLQCBA25Vt?=
 =?us-ascii?Q?VK/upWWD36Zrw2F0nByu7pCf+y1tmvr98AeAhscI6j+89T7R2asVHh0B20VL?=
 =?us-ascii?Q?xdD8iQbIkX/TIm3tdcS9G43gm5/FGQSnpaeaajwZF475kFT19rzICKJKSMVh?=
 =?us-ascii?Q?zAwHlxeUwyOv05q6pkMdTjixQA99whzGeLWIyppDOlN6dyy87UNAaKJ/f7EZ?=
 =?us-ascii?Q?Z7DvfDOocHjVoak5tr3gQzGkwkQlDf+2GOaArOBD6ntVDKPtSGOiOc3GbDE/?=
 =?us-ascii?Q?JBaZotkQx71Ybd2HmqFZVaTz1HS105MhhqMymM2Ow33lLAqCG6BDw8qa5x2U?=
 =?us-ascii?Q?qI+WtDyDxzRxkTTA1z3oriaiebdZqBQIpNrgEPtENga1Ts1wvqo/0b6liCfE?=
 =?us-ascii?Q?89BX0a7p5yhtX2iy8JbYWnSKX9IFfTL5bBsWh6qL/sKvf6x8DVgCkhuuNNdh?=
 =?us-ascii?Q?9UHfJVY092j3CMEs5jrHaK/O8j1zwdMRloLDICqm8rtyYpvrN7+nFdP0QCZz?=
 =?us-ascii?Q?cn8KbQmkC8wdD3QzuKQ2MjC3bpZBJeO4SEl/xoqKadaKearPTgBC3rI8pvDC?=
 =?us-ascii?Q?lCwssWdndRV90Ly0BXjHHR52d1TkidroTovxfZZJlzOK/c7DSOIGH5+E1jH5?=
 =?us-ascii?Q?HKC3kevRGOWsKTNgSZ2+x682doSEZycFqsEU9S8qkLsbFCFtrgrmjK+EUA5t?=
 =?us-ascii?Q?sgkS06qGqLilbwFRj/qqeMJ5FNb/Cp8kR8I9QgxEumxe9pg+QHRXgdWMFty2?=
 =?us-ascii?Q?KJe1GMjzX6iDhSI5S3uFzbbgkWuIecJYKfAtcb4To46o5c8zZ9ZqOtmD6Neu?=
 =?us-ascii?Q?H8bLcd6vs2Y92z1pf8y6QORS/qDohO1sOYFD/OFQcw5Q+inH/A5mZkXkvJEi?=
 =?us-ascii?Q?hEeKRdqcfZohZVR3iSsBnf8m+0qF0wy422fPVxVfLtX8Zb4xoG95JR7H4sMq?=
 =?us-ascii?Q?dEvD1gfMgMssKIf1MyPRxW1NypqNMdtm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M3w/uZWGIqPmxfqkbSlZ74txsNwLnSSR7Va7AWz4gkpEIN28eJzWyeEx3Hb4?=
 =?us-ascii?Q?h+df+g81YVXbiE1UZL0mMYSYqVMxsQt+foBbQGESBvO8KzTWn6WG7iDzNDMR?=
 =?us-ascii?Q?H0kmGP8H6GI20xeZymQ7nXS6ru88oDEyDw7ljak8ysCBkqrih7W7udkOdUyX?=
 =?us-ascii?Q?a36g0yIzy+SBKSrk6PsYslBlBIF0wXF98REeKMfTx5ki9LHReDyM7efnLqca?=
 =?us-ascii?Q?0jskPRMz2Ges6YP1zbUA0MJ0+00wn+8rrolYbsubWTIDw8ibaLPy9faAI9xA?=
 =?us-ascii?Q?6aKxOgbd3dg/PuM1nO0oHxJGniSiWgV1Yi8qKqJwGz8LHIzU4gfOnihfPY5u?=
 =?us-ascii?Q?0rbxf85sVJS1VD5iUVZvK5e/KdE7LHLzznqMhwtI4otjF08Jex568F6bPHVV?=
 =?us-ascii?Q?DFmAlUMo+vTAamg0tRzuqp/3Pl1V1P9SDYfrEJP8KULoYRIcVrpndQaxTXkr?=
 =?us-ascii?Q?kdh68oEN6curA44n3tihagzLnKtUP3HvjZaBmnOyVmr213BeMZz8YIRI/WMt?=
 =?us-ascii?Q?vUDzflJgRHHkH2r9MccZzWl4ntNfWhDzgNWszPppyatMiUr1hxWhgaizcJqf?=
 =?us-ascii?Q?73U9hZfI1et/lONWWU8FB4uEq/92VOvyVpPkkhIOndnyUCQkU73Fkqz+dORv?=
 =?us-ascii?Q?gPqixe+tCulixrAfjskBJmXNCgn9Am7NKePkGyYwgpFYUGVWB0LMQ7qKuT5D?=
 =?us-ascii?Q?8V99UtR8FA87YK3+H7i62n4P2j1NKAbPsME/K6CaW6gXmm/jK8nWFJEaj88X?=
 =?us-ascii?Q?Z0WApLjKJlDWcI5kEAs3ctuvhQGHg4BDNmC/jJb+dYfQsZC47suChR0fU2ut?=
 =?us-ascii?Q?jefSK/Bk1IQPfDQC//0MLE3FYEsGNsBBL5r57K3KMUMOQufqmicHpXB77TV8?=
 =?us-ascii?Q?y5JVbYCb8ZBE2E6bfLh4w+2nDS3tgANSbOJDIavxhyw0lu865/nEyUVLxhMH?=
 =?us-ascii?Q?lvuNKraxYWVEnDwpvOTGYfXIllQc5sCJGm2yPpOpZD6h9BGTIz8BZPHLNWdg?=
 =?us-ascii?Q?pU5HVC9bYk5Y/OfQv/SOcmSSYxOnNDng0bvRC9dBXL+BgbEqMqkgt4msYCyi?=
 =?us-ascii?Q?BBvF3Eikzna18/B9L06/5PV51mQWLMeBTF/kxUGNJAIvGLzI50KE40jofIvA?=
 =?us-ascii?Q?al7SlfeLD+TiSaRHmHzvTRulHVTJLqSABzDGWRKEfp8fFgycjrEnqLDyyTHL?=
 =?us-ascii?Q?8qh9q7S1IKoth6cJuVzhiwIlB9BYCY3jh9IbyJV+OUsVA5TNEdQ8MBxLMZjt?=
 =?us-ascii?Q?TIilt0irA56bfO+OZL4TAA32n0OxtNOQLXVg8XKrXfpNINZF95l+vwlTAvN5?=
 =?us-ascii?Q?mNGjyBKxZRF2jWKE0aPdh+D4RF5+yqIzJraLSKP2E69cS2/c81T8EJ7GPCT0?=
 =?us-ascii?Q?9gBMSTJP2tlSFGBslK2u4XE61nIYUa0OqFV35+OAE9IZtrPaQI5xv2etddQq?=
 =?us-ascii?Q?m3ljsVA0wIB72n4wXil4wYiVj164J+yHopjrSPiVzergxGqmfWbRrscNYWhh?=
 =?us-ascii?Q?8h1IQU8XMfgC3og6f2PbXgn9OvrxhdadBOA8XlOylWZ/GekJxwhxVeYSPlom?=
 =?us-ascii?Q?yjx7s22Fy18wQ3w/vTp7nW+D7VokDNRXG9u1l3jrXPvx05zVlSXhCBK8enEU?=
 =?us-ascii?Q?ACiyUbgioA66VexDszFfSmP525sTxqEtkiccZWfNvzXt72M0ATMPUDMWF7O6?=
 =?us-ascii?Q?mtaphc9NWzw1DhEQsXFA3c8Ix8TZ5dKNS9BFC/BzU0I+D4pq2+/Z0snoWAx8?=
 =?us-ascii?Q?KtfhhBZVyQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45bc8eff-9651-4173-202b-08de51bf08fd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 09:43:26.5758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZufLjXLfCmdb+tZLrN1wbspNw5nN3yDDPvY1QcknOnn6d9Qw78VRNOtDWw5D9HwCm56JnLpjSmmoRHgBhTlvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8914
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C87A64000F
X-Rspam-User: 
X-Stat-Signature: 6to4mbznrzdhj1qra5eruh4nq5tkxdho
X-HE-Tag: 1768211015-622765
X-HE-Meta: U2FsdGVkX1/zKLl097wZW2xGtkc44MldpXJNEe+MXNBrVETIvzGtkr81IQN7tLd/t4zi264pKq2d8KgOWLiQYUBKtoOnnJzFBEUb5UdenkcmHR9bIcgUK9aEAbzm5LzwxsB0F8X23IrkOwubwlgzbTj7auTNUWeYgogyebqXQeuds5e9BBp20OviK1RnZ50lfRHUTq88lAly0iCBnU5sR7kApVNInV26a5rjRpEUrvfAzDEwm5ZXXMAFYi65sWllw2rcDTIWoURfmsY0uxgysptfSZYJdEfXdE0A1Hl/M4cg4WeS6T7U7YZTWGGwdl9g1EjON1bmZcsxem0YzukWOx36qGEUoHlCVR+dw5NmL9RrQD64jJUvxXepmjUS0ebdGu0ZEp8EgkGXZV2RdLQso1+I0whhF3VSb9Q/uF7VuXfqm7EQiFnEnaCiPlF88mp6ugz1RsDZ+GDU6SMcCwtK79b34iq2LwCyGGJxn+uEJb2j2v0KVT219ZUhVDtLgCl6v1Y7ohSZdp7IfFoGG1rzMSEa0doSau7BYiKxGjdJOBDYeODuoJSnjuFxKkh5QHkfAuA3J6xOGD7OZO0Zcgfc7jkAJCCE3FMcT1yMNSdz83FoD+NdvOWyvBU8z/YCTgZbCi4TwmBV0JENOHVHy1rwDF5c4NxA+Aml5KShy7PTLc+o1vfaGW7XwrGIelnzUm98IJucFB3/hCkY+MttXBt6ArpwfTIvPwbPOOOYxvs/qcKV29kk1DZwPRM9IgzNGe56DsgWWRH2ARPS5y33Utykyxk93IiegBlyJJugjOY6iECEz49j0Heq6JLNYm4V8CnV5qVyRjJrtzXAXllkv8xnw1/1SzZGMUpq1cIz9pDRozt8IQCTvb+eFUf8KAHyGn/SyzopGdrdyDQHTbeYNttlHP4yev8lKZwBlx6UYR3NoDzyHXPTr4aLUz0Yt5Nhb61tt5K2NMDA2kkoEwOsf6z
 I391qALM
 aa4EF40le3toOjPkCMZHzav40x0toC2BRZjRqLuFH1e4AF1LcJknZrC0j3PmslNCvRTqpU3vOX6/9brQdtNOfOA5U/r2rL2qmaQa1WLI41iRKgyRqxmapTaOSFOkQtUp2vrzbuTAWWzozbFPe0rD4pf0P+QW7sdEQ5K2+qABS8DXun53pB5OqU7qPUPvWuM7CQpYfVm3uHd71/OOOC9RCqx9ylz0uny6xL/lYFjgtTeH4k1Mwdde6r1PmYzEOUNpgb/ToONbcGtDoU1RWxrkJZg7Qntm6C3rUcyAJhHucrt/At1yAwyJASLBDhlyemMQ6pTMX8DvEhlgjCvtR0cxbRqi2arnX3VNcMxIqo7XdzAopswJvx6QXAwHQfg5XtJoA8JHk9PIxZ3OTOF6ZtRAOAib5NECuKEZSrx4V6W2vUp80Xs3yD5OaRUCS+g4gEcvZdWc2f+noxakY6Tu7IYaufn2whP/MhFdHEwTniijH6ETUcjRfV1+uuaIHg6qCiSQx344EZtBoIIrxSt2oq+At8WBBuk8ROvQfbiKy3pGWbCnXlLWtBwHai3WdFoZ6p1FvX3qXsnhDhbDtfRaaFaYJzyHJiFPw8OwpaFRKAmKgX4UtChry5ACExjJZ5kiS53CaAO/e5UZejrvu5Ve1elqhmLF4Np+Gw3hBrt7X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>


