Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63435CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 22:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B736B008A; Wed, 27 May 2026 18:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8030C6B008C; Wed, 27 May 2026 18:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2286B0092; Wed, 27 May 2026 18:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C41A6B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:51:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C40E1A0753
	for <linux-mm@kvack.org>; Wed, 27 May 2026 22:51:39 +0000 (UTC)
X-FDA: 84814698318.22.D35C7A1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8A1E94000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 22:51:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="YVe/2dYi";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of alison.schofield@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=alison.schofield@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779922295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDQhGLTBG5XqBFY7W/8jo6+pnNQYZiQRmOH7ZZZttlA=;
	b=T0B5M0PpzFhIKsgUaWVPYC8xE5DxUDsyPeaCtju0YEONc2xRiTb1pkNT7ypC6fc0enMnHI
	/2+kll55L0fW0qIc4SkLWPyyEBVSODANrB/rgHo0UOQKC02gkLi2FWS2qkKGf/q7Zcxh4U
	SIXy6UTm5E7D4+j1OEDWSwClqg6RjHc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779922295; a=rsa-sha256;
	cv=fail;
	b=k9YoKlWfkcYrjKuPn1tkg5hL3aMVVy1dHtdo3RluAlLgTlINAzS8nOPKGkaAvQ/mJVQHUk
	GTRelLN9Yb/vCF+8RIKY4yIyH7hgp4/5Aos26Pe2sYk+hCPD+L2c9RPZo0Ey5HAQCGJBMO
	BYZDlejEken8c/B7utQnvnx81JWJdK4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="YVe/2dYi";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of alison.schofield@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=alison.schofield@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779922294; x=1811458294;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=C8xw0wyoXr1E2+4Ifcj8xC8Sxn9ZKO4xo00N7Y/uIi4=;
  b=YVe/2dYi54v3Niqlte3Qkm9/5oCulwiqo+L378z9IZia1LJ/5SNCgbsg
   46GxsNYERHwi5oIHH4B5f5U/sZTEMhMX7hbCmCd8+f/7rjOQVjXGFqMTd
   mwWf+3r71EMNRSmGMVkzXTcNuL8GHJp17W6k+U23FJCvbEntC9WC3xZr5
   amQBiWyvlZG3SDmpwQJU3g18Vd6Dyka/zizzaU8Wz9Ro+dpS8aaw3OD06
   0+TXPjatAKTso4N+R6IXFD9/5BVMk/W2DOxRIPSNuizbwtWfODLrzSlDF
   aGLYEHYJ9PqqKoJoUZHjU0gCIbVS68g3ugolvM4zH4UGAuVXyphFpA2+g
   A==;
X-CSE-ConnectionGUID: nmqJp7ajQj+b3Q1xOsOPRw==
X-CSE-MsgGUID: xG7T5DviTr+NKMrZ6fBs3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="84625262"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="84625262"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 15:51:31 -0700
X-CSE-ConnectionGUID: Qp01/zDWQMOLYn4ab4xM6w==
X-CSE-MsgGUID: vUmqUlOeSmi6WOyNGoxZ4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="239798668"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 15:51:30 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 27 May 2026 15:51:30 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 27 May 2026 15:51:30 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.4) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 27 May 2026 15:51:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f+pB21cQVOdlxYIcPauKbhv/zz8fn3oo3FKuyw2d+/ubZCgQEtIysvHU/8Dx4JryLiMFTUrBLQTYhT1Kmta25rM3os4QAtgzjzsoCUshaFPMqdHYD1mscDILXjqB4B3IHrHh1GM10pQaYQNOfP8YpEzcb6rm27Xm8YoQwvsvBeUBceEs5BHyjDXsJLR1/PINR2FcIRUk98V0OXoLi55EMNuHzlq8ZGSwrfvVSvpktd7+ZqUv/exxEjRaJwcA9LDwq5wVtFVstPhggiIZMrZlOJm2I3Z6XUa0fK56r2R80ZDjEB9E8eY9zrN2inCCCvYruD/sKbxwce1yaCR+qFRBnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mDQhGLTBG5XqBFY7W/8jo6+pnNQYZiQRmOH7ZZZttlA=;
 b=ZxcriNK2Ju6+2OcxHX0seChUmjMy0JIzLs/TU2yyR5y1C7VUtm6ct0zbaktakqWnwqVMuscY8DCPh491xIZJK1/YUjbP8bkFQCO5v24BnQ3var7mAQxwpMmzYHVfli92hBGPg2qFn9NoiLI7MVYbu67QOkHU+kKpConuYwplEUVRAJAa0pajB569KT1kKE+Noy50IXXX4k46DPp5ITjeUqOIyAP6/OXlyb8VHSt7Oi3OpcVjuTCX//OrKSnLtW6m+MCBIiz1gaBfJtnv7NFRhCo2IPeFtAIl7mEtws0S2h+46iod1urFlkKvjj1k7WihwIGPLsmKKa2vPYBwZqI21g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA0PR11MB7330.namprd11.prod.outlook.com (2603:10b6:208:436::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Wed, 27 May
 2026 22:51:24 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0071.010; Wed, 27 May 2026
 22:51:24 +0000
Date: Wed, 27 May 2026 15:51:14 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
CC: Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
	<luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Mike
 Rapoport (Microsoft)" <rppt@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Lu
 Baolu" <baolu.lu@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <stable@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v2] x86/mm: fix freeing of PMD-sized vmemmap pages
Message-ID: <ahd1YmG_m64SNp0q@aschofie-mobl2.lan>
References: <20260429-vmemmap-v2-1-8dfcacffd877@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260429-vmemmap-v2-1-8dfcacffd877@kernel.org>
X-ClientProxiedBy: SJ0PR05CA0169.namprd05.prod.outlook.com
 (2603:10b6:a03:339::24) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA0PR11MB7330:EE_
X-MS-Office365-Filtering-Correlation-Id: 35e38b74-a9a5-40b2-e1b4-08debc427a8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info: phqHouqD+nyJoiEsjkYXKljuS/hUqUeoZ4Vt09+6Oc25dksVLc97Dfvp0nRyjcwkeg8WZzwxgEphKsfpgqHtLFGupNPg3Z7y9My+XvZidniL2CYKw61Nmz2qQWF5qCg9Fvz72OmwkF5rdsrbAWDo8rfc+WCXW4HdD8pHj5RzUsHAyOakoxWRQKdVITQuTjBE0L8EU0P5oauBGiw4X/YwZ9FrWiwdpi8QgrHI/K6gWpEWr2M/oJSqgWserG6xu6cGnM8all/z2TUA8HgvqCUmVv9nqfjjKRc/hEPo/1wZ+BO7po7OGAUAK/zv3Wb72pLQzZrXjYNJppnMlEVIbzhXpB6wWXzgbwXi8g8U6QZBOb/dAmgCeQ6dr25GRxhvFP1TpdwfgvUkc3royO08I8mCdz0moP6jYqI04NgqGDUfRTIfujWYQV8o0I+66G/PeLHIwLZ3XKHPtnGdgMVfCp/QZFCoDaCJQPbPzyM56HGz38NCUhwXOPUQeDchCmkS1v5IgqUW/AwkAynLLgAa/cl1TV82W0QaQ4/3l+5wSXxlxWfGkid6R8JjPsjwdpmaPtP/AFRV7NJK+KZVY/IzupYBC8L+9elOfCmUEW3POF7gj7nFhqHSOa4HYARsy9KPyDb5QKwl1BgSCe1fXf9DO5GkiTp0LA8WWUXV8u25IfhSj3Luvi35/YVUfyGSY/CglrX9RJQbkP+d2rbdC9EzYMyzBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U5oG3O90jsxUWoMt9EacfxVYA3FKnD80rewXvwxP9J9q5xHQPOHbKLnV/zXY?=
 =?us-ascii?Q?Vk3omBbg5ZtligXLHZreM2qNDIDf3DVbwCUZc4SGYpYBsJ23/SyR1enBDtBu?=
 =?us-ascii?Q?4NWklSJKREQM+IgoqmfhwNGLrT2UUetDU+IOqiAA1BK0TeBX4/jL/UfDJ96m?=
 =?us-ascii?Q?P9MpAUwbXWrQXLbEAWitgJOzMW2v6qdR8eYLOrU4b9G98lmjkvgAniQFoxDi?=
 =?us-ascii?Q?UCLsYrrD+WMykpekkHfdbYo9pa31UblYKsxR4h1/XBNdjrZa88vknrrbar/4?=
 =?us-ascii?Q?4dWGsnsZhZ/ncp1nEk3Sbs4AtlkskNSyrNVQFXs18OQyz+R7JVW2CXHiLk3B?=
 =?us-ascii?Q?jNyCHvEC6DHsDAtaGonan5bOofsCnyHqSr5oF6TSeidvAZEbuLJ3B1my1mBO?=
 =?us-ascii?Q?CWiPaKP4FZfzMop5sTtxeGYKp817s2sjP2k9ovHNaRnhVml8U3DHh3tgBfyI?=
 =?us-ascii?Q?9cSIazQ/B8THf7acuIwDhzANFR9RP44qyZqZLskTpWf7uvNGC8D8xVUz5FJd?=
 =?us-ascii?Q?JDAroy7XGPjXm3DX+Ytzmsg6WzJO/jCLU0OkHFL6YccEumc8EsriBM8vXOjf?=
 =?us-ascii?Q?ZSdfzwdwGlr3JYEmyGALnILdh2bnzl6egRv/ESzezw6mobUWYfEAXJQb4MXn?=
 =?us-ascii?Q?MRIZIEEV4JS5qJmizFXH8TLTmtFbpaEeDdF5d8EbmMWUH/vH/kCFxOMprVqR?=
 =?us-ascii?Q?lKGdwzaL8DwdulUvCW3BhG4K/jbceGvHK92Spl4mNYmo/JS7lh5TufEM5wU7?=
 =?us-ascii?Q?02N4wzbLDWmJzsCwoYvO4q+Rx5gNvZyruHILovWrWqfZN7yF/q5quem4ZfwG?=
 =?us-ascii?Q?WCHlh575/ziWWJ9GeMwLLFNMKGI3ssOF/pRQV0UQAwOgcB8c1yzGLaYEOiUu?=
 =?us-ascii?Q?jf0wWyfLxZu2oMBfpndY8dx20avus4XNEl/OitZOs8Hs9nB+bJeR5VVVtZQV?=
 =?us-ascii?Q?NVogkjiSIjdMIoR6pBxr9O3aIjGXybppa6Eb8fD8jf9z2OHqNtxevAPhSlip?=
 =?us-ascii?Q?xNyCjhkcjDEFcLEQl23qEm1Tp6oyHai2SNJFhNUOLenuPn/RRibRnX66/zIo?=
 =?us-ascii?Q?+RTYJIv9HaFaB85/aRtpxKxJoCE8Qw0zA2RGittvz1VlRNV8a+PC10dPdFcH?=
 =?us-ascii?Q?M4atEX52IwqKxgzc2X0/eCpYPYuAy/5/HGO3xRqGWWeeQZpir5ODsSGXvopK?=
 =?us-ascii?Q?GIhyoIoCw5MvujmGBKkkUJgoFG5eiTl8oeMH87lZmKDkkW4kaz4hkWHKGZU7?=
 =?us-ascii?Q?a6tMLSPDHfm8wShP1fCHRT6Fm1+Lu9CQiPnWN4LjgqAg/JdKFRoCQwOLJ7jv?=
 =?us-ascii?Q?Gr9Vpgq4re/0pyZORGOSxlj/OR2Oz7JioKQm7m3yiNvRJ+3WNp1Avq7FQav4?=
 =?us-ascii?Q?hlQd5zDT0y3Oln1c049dkaItwvSeSnIlP32zEa0m6Gv8ext7yTBw8xWe11vM?=
 =?us-ascii?Q?hDD0Kir1WtQF0Pdhg3DjGF10MW0lrYgG3xg/lDO2gR7PdMpHN8dugJmbgv9C?=
 =?us-ascii?Q?eYJJqNofcqwhBc5J+yu9mt6dpBVD/k0sxFHt8bRJGh+EUXgpftsdhkeMUKSm?=
 =?us-ascii?Q?6Sl7mcJXg/ebIr2LGNmPPPXfQ5+/P/UIg+PxXpHeQSXRLmxR9whDqXBN501E?=
 =?us-ascii?Q?s0N5bJbew/s02wIfFTfxv8ET6tm4zYyiWpyTXW8OUlKCOi0qrQapo6FlrjDB?=
 =?us-ascii?Q?zC1G2jpKwl/xltV9fLVbMSlAufcNdBr1KSWj3XAcV9a+Ixn7pXml51XnJjDn?=
 =?us-ascii?Q?shr3KKo+usY3ZlEsYcOap6axvclgqls=3D?=
X-Exchange-RoutingPolicyChecked: NKGWnz+VDurA5+L64dn3RuIK2QNUrRlARIyfGHO34Al2L1hDein29y3y88b94ZeH9SczaSQtr9hbcCHINaZ3r5jh407UH3wEE3/JrutluKVRlAhEzhMPuZfP4Dw3rF1qJ7Z0EJXOY3FROk940mVwUYyOuUt9L0duTz3fkf4Dr5r+n/vVMDtWSXILHKXeDQCOUDlJtwHbgLaPuiOuGr6YC83SRUejRtVYhJlhXt4HbL3n/LcQ/e/jKCudpdiVlXfYLnM81mhQ598Yh93UNszB9QKzTHCYGn7BvOxWVGzMjGVCsS9iHyPwlOG4J6Od4Q8M77pmXGmAypoKDPU45WmlTw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e38b74-a9a5-40b2-e1b4-08debc427a8d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2026 22:51:24.5446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZS+E0MQh5HWU8jBYnhjP30PrAAy8o5NclhomGmcLIvTVEK92yK1DvrCCJLIDYywOQqsXGxZlhbWk0VbhdZhNIYmjj24Rd2poK2T5mKrbwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7330
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Stat-Signature: zzcpazyx8xea3949emtz8nf757ynfwzw
X-Rspamd-Queue-Id: 8A1E94000B
X-Rspam-User: 
X-HE-Tag: 1779922293-300524
X-HE-Meta: U2FsdGVkX19490gWY6ui5C1w5IuGU6ebniwS2q5tP9u8ioZ1f15D2nKsXxqC/aXVJP0W4CMHH4fhgJTFQkwkUfHx9g3VU1jcUhRQeIhbxRaRvND9iTmLUWLeT9x6J1xTwFjAOZ/r+pEEmSphee3UuMR4CSrHcVbALoOgTthdyn7E54GMZsAQ+hekfv8rFLBxIu52jKE6vFbvSZqS/+2pUMWH2ZBlo7PlvR7RBHa+ROXfEFKoMVG/GEjoU2doz6d2XsSS6s9u44wvrlMwvhjGz8VFIR1U4VsBROIFhzyYl1XPX1jMI1xNDTFlXzCgVmZ8t5vsk5DCfa92PiQCTrEsRp+FHxLpAjwPhHY1HZNBW0P1zOd23BfUSN4beoArzyuOGovwzWt5E5QsjuiUYGOiEu9uxHXnprdBCoJYaxBR7Uk7cBl2Nl/K2infoskMaZpIJLbgdcnk1emhkNnKmnJhJnDsQdFxLCquv4XTXr3S7H7Bh+63cEeqa62dFTzCd2o9I4R+kw82DlOjso9emnTrMVazlbfbptPY68MiAhsI7xo3imGq4LAlODX/MvFc53PGdJhfhoRZmVswxrpub2IXISUBD/94JjuYZsP4Ht+XopeLvf145UHwykA7ACcpYpgKPrn8HKSien6RJ0RWTXyrezvEoXt2FmZ5UHD/E5JsIUl3KZWUuMBW7I8m0tVq+UTXaN9RtujMagqRG0IoFSxw2Fl9dRsTiIGbS1cJbX04LxedLCqOYd/rmTY5akneKp4elsbHxbmET20OrX9Vxb7doybi28BBXHm52TeV3/Ipj0PD2zZJc+j/F6ES9EJ+3tF9ZrMl746phcnZxAy9YPYXdVApfp6pToUTJCPsFKJNyJF2zOj4g4uT1wzJoc/X4pmAAZVvK8CWCPry6Px7EUMLIs27Y3zh/lFueeqCiE4skc3/3UjutjITynLb/0F+O/reMTo1b7aZpBdUnZbSaof
 DWudRuZY
 UXh53IbnJrsERtxj3IBa3Y73sYmZGg7V79yad03p5VBDQAiV6wFNADEACPLotip3fD3Czal4m47gQjkhlbOrhLG1oLPYxNV0KgNNQapXx4rzomHqQ5+ArH4+kBYzvAR6euaWea4vDKco98rqdTN0pWyc1dtyKdVOODUFTJNbGyunkxRUIFSeXkzI+v4hHBBWWQYjrQ1A4XvbxfEiDhcO6Qj40JpBJ2R2mlr5ScUoV3OPYuZzcJNxMCi5loQ6GHbuRxq+iXwOb+80jrBTM8MBsyafSnASwinFlF07tb9umXh4Ucg3F60hEX5pDHlcr9EFV493xSBx4qdDN29G87u7Os2ZBo69UmkJzC3shZGmmFa7mwFeJHYQM2bqXJXuYJ6yB8BFhKOdzOGp77EUmR/Ykih4k7I3w0RQaOc2F3M+21Hdvp7L0G2GkjivR7twelMwrS9J1fC0TVwnsMcDkV60fZwEG6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 12:49:14PM +0200, David Hildenbrand (Arm) wrote:
> In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched
> from freeing non-boot page tables through __free_pages() to
> pagetable_free().
> 
> However, the function is also called to free vmemmap pages.
> 
> Given that vmemmap pages are not page tables, already the page_ptdesc(page)
> is wrong. But worse, pagetable_free() calls
> 
> 	__free_pages(page, compound_order(page));
> 
> As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
> except for HVO, which doesn't apply here -- we will only free the first
> page when freeing a PMD-sized vmemmap page, leaking the other ones.

Hi David,

Sneaking in here to share with nvdimm/dax folks as this affects their
nfit_test environment usage.

+ nvdimm@lists.linux.dev

NVDIMM, DAX folks,

This fixes a memory leak present since v6.19 that surfaces during DAX
and NVDIMM unit testing, as well as ad-hoc nfit_test usage. If you are
seeing the system gradually run out of memory across repeated test runs
or namespace reconfiguration cycles, this is likely the cause.

In my setup, a VM with 5.4 GiB MemAvailable and a 4 GiB nfit_test
namespace lost about 1.1 GiB of MemAvailable per DAX or NVDIMM test suite
run. The VM OOM's partway through the 4th consecutive run of either. The
number of survivable runs scales roughly with available VM memory.

Symptoms typically begin with "page allocation failure: order 0" messages
from unrelated processes. If a test run is active when memory is
sufficiently depleted, it eventually terminates w OOM.

I've tested both this posted fix and a revert of the Fixes commit and both
resolve the leak in my setup. If neither is an option, periodic reboot of
the test environment may be needed for longer test sessions.

-- Alison

> 
> Fix it by properly decoupling pagetable and vmemmap freeing.
> free_pagetable() no longer has to mess with SECTION_INFO, as only the
> vmemmap is marked like that in register_page_bootmem_memmap().
> 
> The indentation in remove_pmd_table() is messed up, let's fix that
> while touching it.
> 
> Note that we'll try to get rid of that bootmem info handling soon. For
> now, we'll handle it similar to free_pagetable(), just avoiding the
> ifdef.
> 
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Reproduced and tested with a simple VM with a virtio-mem device,
> repeatedly adding and removing memory.
> 
> Found by code inspection while working on bootmem_info removal.
> ---
> Changes in v2:
> - Don't mess with the altmap with PTEs and add a comment why.
> - Simplify "unsigned long nr_pages" handling.
> - Link to v1: https://lore.kernel.org/r/20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org
> ---
>  arch/x86/mm/init_64.c | 40 ++++++++++++++++++++++++++--------------
>  1 file changed, 26 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index df2261fa4f98..7e20b22d658b 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1014,7 +1014,7 @@ static void __meminit free_pagetable(struct page *page, int order)
>  #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
>  		enum bootmem_type type = bootmem_type(page);
>  
> -		if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
> +		if (type == MIX_SECTION_INFO) {
>  			while (nr_pages--)
>  				put_page_bootmem(page++);
>  		} else {
> @@ -1028,13 +1028,24 @@ static void __meminit free_pagetable(struct page *page, int order)
>  	}
>  }
>  
> -static void __meminit free_hugepage_table(struct page *page,
> +static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
>  		struct vmem_altmap *altmap)
>  {
> -	if (altmap)
> -		vmem_altmap_free(altmap, PMD_SIZE / PAGE_SIZE);
> -	else
> -		free_pagetable(page, get_order(PMD_SIZE));
> +	unsigned long nr_pages = 1u << order;
> +
> +	if (altmap) {
> +		vmem_altmap_free(altmap, nr_pages);
> +	} else if (PageReserved(page)) {
> +		if (IS_ENABLED(CONFIG_HAVE_BOOTMEM_INFO_NODE) &&
> +		    bootmem_type(page) == SECTION_INFO) {
> +			while (nr_pages--)
> +				put_page_bootmem(page++);
> +		} else {
> +			free_reserved_pages(page, nr_pages);
> +		}
> +	} else {
> +		__free_pages(page, order);
> +	}
>  }
>  
>  static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
> @@ -1118,7 +1129,8 @@ remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
>  			return;
>  
>  		if (!direct)
> -			free_pagetable(pte_page(*pte), 0);
> +			/* We never populate base pages from the altmap. */
> +			free_vmemmap_pages(pte_page(*pte), 0, NULL);
>  
>  		spin_lock(&init_mm.page_table_lock);
>  		pte_clear(&init_mm, addr, pte);
> @@ -1153,19 +1165,19 @@ remove_pmd_table(pmd_t *pmd_start, unsigned long addr, unsigned long end,
>  			if (IS_ALIGNED(addr, PMD_SIZE) &&
>  			    IS_ALIGNED(next, PMD_SIZE)) {
>  				if (!direct)
> -					free_hugepage_table(pmd_page(*pmd),
> -							    altmap);
> +					free_vmemmap_pages(pmd_page(*pmd),
> +							   PMD_ORDER, altmap);
>  
>  				spin_lock(&init_mm.page_table_lock);
>  				pmd_clear(pmd);
>  				spin_unlock(&init_mm.page_table_lock);
>  				pages++;
>  			} else if (vmemmap_pmd_is_unused(addr, next)) {
> -					free_hugepage_table(pmd_page(*pmd),
> -							    altmap);
> -					spin_lock(&init_mm.page_table_lock);
> -					pmd_clear(pmd);
> -					spin_unlock(&init_mm.page_table_lock);
> +				free_vmemmap_pages(pmd_page(*pmd), PMD_ORDER,
> +						   altmap);
> +				spin_lock(&init_mm.page_table_lock);
> +				pmd_clear(pmd);
> +				spin_unlock(&init_mm.page_table_lock);
>  			}
>  			continue;
>  		}
> 
> ---
> 
> base-commit: a2ddbfd1af0f54ea84bf17f0400088815d012e8d
> 
> change-id: 20260428-vmemmap-ab4b949aa727
> 
> --
> 
> Cheers,
> 
> David
> 

