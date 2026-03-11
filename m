Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0CA4106121C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7586B0089; Wed, 11 Mar 2026 07:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06EDD6B008A; Wed, 11 Mar 2026 07:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30F56B008C; Wed, 11 Mar 2026 07:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BECAF6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:14:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64BA21B5825
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:14:11 +0000 (UTC)
X-FDA: 84533523102.09.6998794
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 41B16C000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:14:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LTejqJbm;
	spf=pass (imf10.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773227647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0aIdG6vd3S2Ls8fB+WYNU+VnOaflfSLvN9tem2QwjnA=;
	b=cXzFHH4/cKsGmtQoRWzaS4E5KpJMzSl+FkPDSp4BqhRqpwf6BZJxrrjMD7cnpOnTEXsfn/
	fmiVc8deu8O8Qao30Zu6X6xszHIwBiAyQ53laWHidtn1C2k3m4B03IIsa0ufvEY/E80kwo
	sBDSyPrvgyRBcU2khYe/h1ZBrtMidms=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LTejqJbm;
	spf=pass (imf10.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773227647; a=rsa-sha256;
	cv=fail;
	b=j2C3a4ECGGXTwlK+K12meiFK/sj7BfvbNxd24YppQb0AItMlFt2VUTigX030D8Tjo4EvqN
	j34BaFYVl4v52odvQny2Mm8pdb+T9oRisb9/V78H4ook1NwRGjOtdcWh41c0NFgThg1GUC
	z2h6TPdP1peeD0VgKaK6ABsNi1j1+dQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773227645; x=1804763645;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=83MOWzVG4EKchkC8/2kbpWAWSKay65qe1edotV+EIO4=;
  b=LTejqJbm5EGD9NgX/zMbSAVQvZCilqr8C6K7TDWQZbYmuA1WmrRBYK/o
   hQ9ihqgSiQUkkPwi5cy5OVJIqV2F/yTeQDCBIFSU0NzPDUFl1rPhD32AK
   bCx/5jQ94gtmGqjwqql0HpT4BQQRVfhUjkv1IgXgfIbtC0ucGf+d+fBTs
   A6AhsUYq/BIbdSuI/yxI1SEpbDMSVeB80Ps8UNsvl5q5Mht44mkphMGIY
   YvIiia433SH8sdXCIKXq8FYU4gy97DDpQHCcIys4A/f4LAxBGubIIddAz
   HuGItpip/MIRYdbpu4YzvtlTOtNM9p53/tXcfOYMTayRhszn2EOxzP/Xf
   Q==;
X-CSE-ConnectionGUID: zkuzW22YT7uiTdnam4klMg==
X-CSE-MsgGUID: 2/LaDtUUQxiA2WEinDBloA==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="61865803"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="61865803"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 04:14:02 -0700
X-CSE-ConnectionGUID: Y5n5SJYUQjywdRQYV9BtwA==
X-CSE-MsgGUID: aNdjkJPXSYeNiAOYLyJSww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="220483623"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 04:14:00 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 04:13:59 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 04:13:59 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.63) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 04:13:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GItxcmcIh+K05iVwiY2kI8AVdH8Njmp5w0XvEll9cIdk7IpaH9WRTDzKt55R9VCne3pFRqXsY02N2ik/lj8XdXdS6/192MCBEmcEEfOCisZjFrGlFTWmTFMuykZ1vzIIDEl+LN2Z8xM+Wwy3KUtAJ8Ow3T0z1cML+FqCX541tG+wGEV2O38udsc1Kh9qQjb0Hjb6NQ2XHkep3RfESax3Yrh3rdNBVjNOS7W6B3QCfQhw0rc1btscNz132qmoWb2xRGeJQGfkIeexHQQMGpCQfD+yRjhxYONBoSFiBtbzLuRf3Sx4my3F8u62cUD77tDBeW51Igo/VGJ11b09i487eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pqSy/Pt6o6fVtDGiSPTmBzh/e0vZ3raNc+CXWagXKdo=;
 b=Qz0pUE+BdQq13A9XFr2WAE8LHQ5FGFBxJbxWFIhGDpImMChGYO3xJV6QBbhgL2KIxWnHf/9e3SD31eCl5m1EFFUSt06QWKAXYZScGjiuIEKhaS69oKD5v+03+sWtZPIRS8PTPY3w1OzHIVO89Sxw3fljtA5OjisrqtZo9xJ4ObLwAnjXtNakhZtzm8p2YXNysdcPnjpOO3jrQHYxgFcWwRMX1GDvMnnAon07yzHYbD/i1uMyD77il+f44iQiWRmgWQ8ZeAnAxU6OqBTSVrcfMILd6VZ6HuhoAy2v64S7FyIUzlkcuz8+LY3xHagjgEfnRsMAzpAGd2GfjZ1g5zutlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3282.namprd11.prod.outlook.com (2603:10b6:208:6a::32)
 by CH3PR11MB7276.namprd11.prod.outlook.com (2603:10b6:610:14b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Wed, 11 Mar
 2026 11:13:54 +0000
Received: from BL0PR11MB3282.namprd11.prod.outlook.com
 ([fe80::5050:537c:f8b:6a19]) by BL0PR11MB3282.namprd11.prod.outlook.com
 ([fe80::5050:537c:f8b:6a19%5]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 11:13:54 +0000
Date: Wed, 11 Mar 2026 12:13:18 +0100
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, <urezki@gmail.com>,
	<ryan.roberts@arm.com>, <kevin.brodsky@arm.com>, <samuel.holland@sifive.com>,
	<dave.hansen@linux.intel.com>, <jeremy.linton@arm.com>, <weixugc@google.com>,
	<ljs@kernel.org>, <ryabinin.a.a@gmail.com>, <rppt@kernel.org>,
	<bp@alien8.de>, <luto@kernel.org>, <jan.kiszka@siemens.com>,
	<mingo@redhat.com>, <david@kernel.org>, <mhocko@suse.com>,
	<akpm@linux-foundation.org>, <andreas@gaisler.com>, <kas@kernel.org>,
	<Liam.Howlett@oracle.com>, <morbo@google.com>, <thuth@redhat.com>,
	<catalin.marinas@arm.com>, <ankur.a.arora@oracle.com>, <kbingham@kernel.org>,
	<nick.desaulniers+lkml@gmail.com>, <andreyknvl@gmail.com>,
	<dvyukov@google.com>, <corbet@lwn.net>, <leitao@debian.org>, <hpa@zytor.com>,
	<tglx@kernel.org>, <yuanchu@google.com>, <ardb@kernel.org>,
	<vincenzo.frascino@arm.com>, <tabba@google.com>, <joey.gouly@arm.com>,
	<nsc@kernel.org>, <will@kernel.org>, <yeoreum.yun@arm.com>,
	<nathan@kernel.org>, <skhan@linuxfoundation.org>, <axelrasmussen@google.com>,
	<osandov@fb.com>, <surenb@google.com>, <justinstitt@google.com>,
	<kees@kernel.org>, <vbabka@kernel.org>, <hsj0512@snu.ac.kr>,
	<trintaeoitogc@gmail.com>, <jackmanb@google.com>, <maz@kernel.org>,
	<glider@google.com>, <linux-doc@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kasan-dev@googlegroups.com>,
	<workflows@vger.kernel.org>, <llvm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kbuild@vger.kernel.org>,
	<linux-mm@kvack.org>
Subject: Re: [PATCH v11 00/15] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <abFNoRrt3WbTXdvH@wieczorr-mobl1.localdomain>
References: <cover.1773164688.git.m.wieczorretman@pm.me>
 <20260310190022.GI606826@noisy.programming.kicks-ass.net>
 <abBu-M5esEYWScDf@wieczorr-mobl1.localdomain>
 <Vf0qDlj-PdjaOVSRop_2G9jg2PohqvXhhgm1DfJrDBaZ5QY5BGc_YVr_tLFXkNTgXGfC7VdSFrcI1Ci2zvDhXA==@protonmail.internalid>
 <20260311110553.GM606826@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260311110553.GM606826@noisy.programming.kicks-ass.net>
X-ClientProxiedBy: DUZPR01CA0345.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b8::28) To BL0PR11MB3282.namprd11.prod.outlook.com
 (2603:10b6:208:6a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB3282:EE_|CH3PR11MB7276:EE_
X-MS-Office365-Filtering-Correlation-Id: de943b0c-ebfe-4aca-50a1-08de7f5f483e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: cwqWsXP6ZBfYc4PKKFuUXkpaQieS96yiqEnaFy/Ib+ItS9LfV3kEA0OGsBLRTM7nxn0tsy0kFe4xc9n8ukFnToAa74GNuiQf5noQ+jkM+gTCW0oobUbsvFNqQ7a/nyqQKDXg1/zLh+RkBtwF4K/lhDcSpgvjzcK00kaVV4IFMZRPALYYFFG4X4AcEqHyUHehwM2gIxgMmFpfzgeqv7FMAgSX6RqdA+8MBObBnvpHH2uuENw8SM5hotXDddAajX6m8wLK4oZFDseZjc1kYjx/l5YxAoqFiiA4R1jZSjXD8KQUWkkov/1uvQU59CVTqFiy+8WRijGaM9A8pZEiA4DMw2emkK7ZjDcfBooseig5z10S2OdzVQ0DpcA6yVdsDIkjKrpTiRP66HuZ+heOjiSQ4ygwZ7KkAHeue/S48jneQ8iuOZREfGgsL2atXocrQqtzvnJ3W6SMI6vv3Rop9Ocn9qwpMtGZTpjh+NGB1fcY5Ou+Ge6hRr5yrtm0vgBYxKN1RN6TrNWh59SPwWqqZbB1bJrTvCUjD64mCVEDnqr1VQGyOVkR2scxZ+NaGXL4TT6lWvHvQni3V8QnezB3J+JLg72rKliZ+MZZX9KkbFGKHgaESbaBpUvPl3lioMs8WKeTWWa0lntaYKgluXQLFlJLq8UJ9r4hs6AnrC1kKc7J3R/0BsnHR2aDbVxNcVDQYWBD2ii7Kh7xiukLswnIg1p0//8gIQ9SrOBBdks4bMyN+8U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3282.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?PR6kbVFfUz+kXoV0azX1cXxo0WAZhjSQaWs4/6Tnwh/Avq7BMQC97RDus3?=
 =?iso-8859-1?Q?ru5amGmAg8hOJD9MFksRgeIad6HRipfuvfvOgk8t0DMPFcNXbaGr5n0xrs?=
 =?iso-8859-1?Q?3ejUi8qWrsCLWxk60/9RvbndY49mXmuaFgLFlV5oPxd5tq8p14GIIhweGh?=
 =?iso-8859-1?Q?xDFZGIeiNtfchxl49G4QzvIp0rr/t9QAsw7LCziFxibk3y14fUgFL8lQQg?=
 =?iso-8859-1?Q?IkJTLkZ1yykdNQ/k7Ca7rhHzhif1BlBVMKQYOkwImZCsvBF/H0ASS/FV7/?=
 =?iso-8859-1?Q?mJE/sQNv/s/CmeguvmG85OL/Aa64eFhrwVGD3kq5mhlRj4OjPFh1LlopDp?=
 =?iso-8859-1?Q?RrZP/3hjVn3Q2qDQ9rPjg9uQoj0iDtgjjlt4cRinNF/nzLZKgN74K/TqgT?=
 =?iso-8859-1?Q?y0Orh3xRRl+CxAOrd7/cXTEGRdeUNAdwCGzvcHVtKv550NsGjR2MuaK81o?=
 =?iso-8859-1?Q?4dSohIdMUI94hdh7W3wPVgfMc+EaCWSNkopkmELzlnikNrLsQq07VEKtqW?=
 =?iso-8859-1?Q?rrZh0IG7GzDJL2xSj9bH5e0O33BcRBDr1EmOJ2peBdjjHJhi4jxKIAG4ov?=
 =?iso-8859-1?Q?hlh/zqLTxJTTsYoNz/t6KoTBTN5V+q8smANOGXf4rFC/Tyz7MXdjTaucuT?=
 =?iso-8859-1?Q?AAGiX5xyjeD/nDKHvLLSBJjpZPGrPdANRVVqCXsOXRGgjg0RSKkS5XBzGk?=
 =?iso-8859-1?Q?07me5qoHccvLG7qaQVGYj2pC9MEFtYw2winEGGektzPPJwh2oAQPewKeHz?=
 =?iso-8859-1?Q?YGc3QkvsN0ipg/xvZEFmdPi/e+6rl151FPmqViSCZp63dDxnsL8nKAVr+d?=
 =?iso-8859-1?Q?sYQWI23UJlHxQ9kv8/JZIILSKrHS2zmuo7xTm1ToycPSYjqy2ZPPlOHG7Z?=
 =?iso-8859-1?Q?TXU4aWlcaC8+2U3qzLOE2+EztuzsYHNEQdmj+TF4AOHgpqexaUWFhEx09c?=
 =?iso-8859-1?Q?xpvDGDSESSzF0duLTd+N+oZBWuCjcGgz0IIFGpBpQtaih1AktyV7cCeFc0?=
 =?iso-8859-1?Q?jaofQnpVSnZYsnjCF2NyV/XXzf4mIMjJlVj9WKr/C6mM1Uf8vi1Jdk/LUJ?=
 =?iso-8859-1?Q?SdKoiTPgjnnrF67TE8f43r7k1vyR7Gu8FF28M9ae02WMGTIF/uyk+Boap+?=
 =?iso-8859-1?Q?6y2xMmbGy8rMo5tqdOqYvrIXvYnoCSkcqOZN//ZweTtQNKRUI1uAXimovr?=
 =?iso-8859-1?Q?CsGNYDwzlhLP1B8PQvMwsVZxEhRVi/rUioSNdWwsMKQ6Eah0uTjY1hU2CN?=
 =?iso-8859-1?Q?zPOxWTQ6B66IathzkCGaNlDfs7wB681VMgmlTieotc78wV94x7pd+Glic7?=
 =?iso-8859-1?Q?2ZEKHpEmcOs88tHnekWLjbeRF+NMbx0jiBZJrxObxaFFgXcwWZjnhoNA4Z?=
 =?iso-8859-1?Q?3Zdd7L8eMgfBnp3IK4RhL5QkwbTx6u/rVov4a8X9Ahq6cFxpO+1bze2POK?=
 =?iso-8859-1?Q?AYewLWbq+t7xGWJvMpimJtGTdo9x7JF9vz48mCGJ8MIoxM6MW7wnkRPiMF?=
 =?iso-8859-1?Q?h7BJVWkMuNU6BYA4vNLTMMGYaexgwSqfsJreG9RmYNVnzxZ9YHel8qJLat?=
 =?iso-8859-1?Q?6HqR0UVGIi3vlI9qt89NIIhMNyVz/0+4unmP81SC4/HD9axLelY7/Y7wzm?=
 =?iso-8859-1?Q?iErktbmsEP5FUs7s+kyezdrEY0h86LVGqvooZYIBUmH3Y41g8OcJlR1V04?=
 =?iso-8859-1?Q?yGpaxgaNuwHOGJRUV7aZo8iBQw2nf17b7MB0OTzvFGg1HROR8teiXSXFHe?=
 =?iso-8859-1?Q?CyDmIy0kCPiYNE0chZ60OUk09XV0BMjvRF4tzZrTLyyFbOjwvhXRdUNBWr?=
 =?iso-8859-1?Q?PvBmRkD+qqcnN4DtdjREDcIH+R40wVYUFEFLYuiRcFoGPJcMxkuo?=
X-Exchange-RoutingPolicyChecked: FjXoJv+JK3eHBBpWHznumS8GTekE1oVCNzofEFfDmap+0DeydtLC4DIgAFcsGs++aYKLEpcmQq4iCVythSsyXZa3n53bJzaChYeZou84hVjb7juKTnvPOJKFLbiSp7zsV3H/Hdhd4IA8yD0VPaXPUZ2lO2uXW/865vJUNY/KuY44Zrzt/lMKjdKFnUxjJyCBHZeT1c8Lh2kZ0D0uwbmjW7kGG/DwVtcm4qlAmgfetYZCyOGcHR72tQABSGSERUdH56uzW1tfei8O/fu+bHnBcLHxml+QLafccpGSzwtYoUI4epCCTH6IoUzkOKuB/EOaOW/41j8sOBieyTqQynhNZA==
X-MS-Exchange-CrossTenant-Network-Message-Id: de943b0c-ebfe-4aca-50a1-08de7f5f483e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3282.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 11:13:54.5773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6v6ZV7f/BeTeL1rpoTsTKyZny/JFTcrFWRpjP+9ATkNvV4pZH6FCh7lcDPTRJBdMRswhFKMc8T50TxLT83xx7dxQVzniFjgK27696UD5emc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7276
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 41B16C000F
X-Stat-Signature: 4ikca581c3i55dw8pakbqmj76apwndyx
X-Rspam-User: 
X-HE-Tag: 1773227645-684751
X-HE-Meta: U2FsdGVkX1/Clq1MgkLWBA5t1ec9iFALV03wiPw+CKrkIkdmTAZXaQuadkjdvfGyCf9bqR/FZunW1xPXxwP4D2Gh1sifPwFkutl8610hn4fZxg9BNp+Mx4vz3PpdzbQtY4lUdBglrCisaoTB3SXWE3QhChtE9XHmAJ83edzkBUpXklSMZU6owyp8oQzW4hvJJKnSTES8DUUwSgwR5YbWUPLNCkM39jua4Y34jVK6UoFLGNLtDa9lmDV1t6PmdWTNZHkmCuJr+QeI5Qhabs2VKxDEMQdiPOQMVbU9vEx+EdiXdfeOMj/388pi+/4paEFd1ng1GCmcPHay+mtfNtx6Xv61dW38d3RSsbN9a+iuXa2XPf7GwdEbcddnrqRA/XySrB83qCkw6lSeBGc7DjNVk8eEz6Sa5B/kxVSAyWU8SM2NIqfNChip2H5OpaqIJHxpKx1VhCMTZ8FCs5PyxUTRxkZgwwfICJvDja0MhViH4nv0IdHT4MQzSgXPOW1hN8iqmKvGM5Z4tclzDL2SqKMdIqwp5ZUUkksWAbrPrlhTihB2t58UNRY/AHneJn+ij2SnzH8QHeKdHHlYHMJs/EJztjx4JsvY5o0OcJp7BxBRNDq1ZingXLsRbwkZDGdRrrFhCn0EWOzLp2yLiOnuW0o/Z2cInYXpWUl4niIePd+nQ8iLQztG/LIYPbAI/hD7dG/WgIQWu5e7Jlfq2pb9XAD3225lQCavZy/SzOCOk4IRweYZnmXc+nHDFJMaHxwu40XYyAz92/qhI/PaMG4geqDSYQo9fdN3ZcMZ5idOvgWXgDImGIDsi/gqII8Qo9b3hot+zjhpTHlJqhU53fGHAbvvOQoh9BcTtn+9vcRvvobJUlMGYIbrvtfRbfOtYu8TvzAtscEv9Q/GY2pBzBx0DKDPEA+Ue8HMzqgBrXofzy7cAmwoGPWR5etlOh8la3STBrgKB7fCIx+GxazBtqHctRE
 ICuJfsMj
 +Y4njo88X//GAqYwKMfKbIuYS7fwBIJ68jXTN8WM5xX0QipStFCfKVYMv87DEoJq58KRmUfw841Ski3GOxUXdcGyhwj9ETHA2bRq/oxhP4JHcHd52gjm41rHA6sPoxcE8mrEcgaeOJYWlg/PldHQcXsE8+14ufnscPiYoohJF4643Xk8IUqBTWilpiJuKLAsK7DQagBpiBJliS2ljGpflOTvdaZWfAbr/vun08GeWx7hOQI81WUVB51eCa/1FsrEgky0109SIXFzZeUYCGrOTggap3FSzpfXWuGzZnPIBfwuDwx2zCv5ukU2He8UQBhejAuiVLSIMmxaa+GieL4VXnIeyIWSiA/aWVFfUVdZoZHVJOu0QmOaec02wEnlj/EeYqaMb567um11ZulY4HIqqbhsCifZy2xFsSpXgXPAUx3rEMzqzC4/C/02E7cmzLvJ/uVGzKdew1Kc2Um9+lbO2GHvJjq73I3H1vS3n4J+ptvx2ezv45jSmONCTHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-11 at 12:05:53 +0100, Peter Zijlstra wrote:
>On Tue, Mar 10, 2026 at 07:30:36PM +0000, Maciej Wieczor-Retman wrote:
>> On 2026-03-10 at 20:00:22 +0100, Peter Zijlstra wrote:
>> >On Tue, Mar 10, 2026 at 05:51:19PM +0000, Maciej Wieczor-Retman wrote:
>> >
>> >> ======= Compilation
>> >> Clang was used to compile the series (make LLVM=1) since gcc doesn't
>> >> seem to have support for KASAN tag-based compiler instrumentation on
>> >> x86. Patchset does seem to compile with gcc without an issue but doesn't
>> >> boot afterwards.
>> >
>> >Can you put all that under a specific CONFIG and make that depend on
>> >CC_IS_CLANG?
>>
>> I made HAVE_ARCH_KASAN_SW_TAGS depend on CC_IS_CLANG, and that controls all the
>> software tags stuff, like ARCH_DISABLE_KASAN_INLINE through KASAN_SW_TAGS.
>> And ARCH_NEEDS_DEFER_KASAN is for if KASAN is compiled but LAM is not available,
>> so that it gets disabled in runtime.
>>
>> But sure, I suppose I can add a separate CONFIG with CC_IS_CLANG to these three
>> so the clang connection is more transparent.
>
>Right, because building but not booting is BAD :-) While compiler
>specific features are a dime a dozen.

I'll make the change and I agree of course, what I meant is that with this patch
I'm pretty sure you already can't hit the condition of 'building but not
booting'. All the 'not booting' options are already hidden behind CC_IS_CLANG
(so really only HAVE_ARCH_KASAN_SW_TAGS which controls all the other ones).

-- 
Kind regards
Maciej Wieczór-Retman

