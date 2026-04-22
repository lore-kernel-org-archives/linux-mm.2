Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C71F94CDB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 07:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 386266B0088; Wed, 22 Apr 2026 03:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CE76B008A; Wed, 22 Apr 2026 03:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24BD46B008C; Wed, 22 Apr 2026 03:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12B286B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:08:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D57BE6AC1
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:08:19 +0000 (UTC)
X-FDA: 84685313118.19.2A7932C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf19.hostedemail.com (Postfix) with ESMTP id E40D51A000C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:08:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="QTf9fWK/";
	spf=pass (imf19.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776841695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puUwOosBNuHm8jQbC7cVMIvPOybWPDJSlYBpYKSA25s=;
	b=HMNrAM9yv+Ngbu7lUlPkkQ7o3vNbViCWsuhiji1u2ztzbOa5zR8SVVZPnZ3V3l9QSiBfKv
	7obcYLVOw9zncczLZLob0tpfXqDovlSbc7x9vdbvlb//qkjvLSDpIwJGcFDCMuLhHRRH/c
	1ULCrpV+MWU2XHLOws92FZo0psbwpTY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="QTf9fWK/";
	spf=pass (imf19.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776841695; a=rsa-sha256;
	cv=fail;
	b=vvRe6LPjjZ/DJN4O0pPrGJQ2+WyERU7hcHkM8GPiUd3Zv9+3TQWhCHtWCNU1lez1q7ZaFQ
	UNZaJWJspf3FiZ4A3ngdMiWXCT9+p+tO8fUwHNfEcL/+o/4UBb1KDgChgFQyvYhI9D+UyS
	6YCejNkrVi7JtOugnXiXCsUpAVGVwas=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776841695; x=1808377695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HNLEmAgZITCPoRsfTPZFPpUkkwMCgfCYzJyBxN2qLoY=;
  b=QTf9fWK/fVwd+JU5V/WoAuZvbZUsieSN0+3rtEv/4GO6dFuzZ53jay85
   3cLgMh+PTgRcvYc57yJER47PMLPrezrdYAQ+mHHU/YgKBeVta9ocIEt+P
   UOrZnFTnSJPkMfi0eJ2+M8OMnB9hOhi/AbAnFpK65CeZqTOA2Bcrfx+ha
   PBP83u18V1UDpkJCBZUQM/BHW6Mj9jFA/PqJChfJDbgLCnynZFzDoqHhd
   uV65lPJYxqFS4+DEb04EHbwNyZU/lR+t0jWa5jjy8NCHQOQ7Fwxd+XZn6
   nrDDelG0u5NuNhNOc40MV8PKaRPNiWmt2mU/3gtoP+7/cGS02oBONBrbJ
   Q==;
X-CSE-ConnectionGUID: DquH6h4GRNixLHmeX9n7bg==
X-CSE-MsgGUID: yArgTQTBSl2Ek9EnjvCFLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11763"; a="95201826"
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="95201826"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 00:08:13 -0700
X-CSE-ConnectionGUID: gp0lnHRaSqSs13RVS1H/Jg==
X-CSE-MsgGUID: UZJh1jh0T4Wqjs2MDhkRvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="270372990"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 00:08:13 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 00:08:12 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 22 Apr 2026 00:08:12 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.63) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 00:08:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m7ea3Vp9ZQ8wj03r8LFE2sSnMYx+YURSO78x8Wj6l0IGz3ZxlS/GW37m3A5TP/EpHyRPH3nNva/vhtWgUkJyxkys4yVEkYQFG5+Ef5mMhf1zYN3clna4LE3orEkAWR7OB3jXUleqdymlSN0duwYaeI4yW37U6zutMmzaNOAIIhat5x49NUtmou3l/jLvScOMs7RQwpUfDfl9aXIxOKqTLenFyNiczSS9MHoxIXrdsaOyz8AJsO50tUFydVJPhTcIz+JwO+h7d6YPYrLmrPnrI7nXRq+d+FGrCX0A78B145vB4NcClEbqkncQn6juwL3b3JfDSeKyLiRXOLAlxW1gFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=puUwOosBNuHm8jQbC7cVMIvPOybWPDJSlYBpYKSA25s=;
 b=jUnuqJW8ag17zik7XMXMtMeKH2PHXnIyVnjXKNyDPt+97tIH5FkLt3XuZ7tTLjQ/Ugd0drHyBqcdcTjlTFcwr1+q30xCEIRNPVHSPkmMjxLeF/LLGmxNviA3A0ksr4/jzrKeCCYbyhH27k+s6pIyuxVhCY9TOV65m3jwrxprW96yPk9BpbTHGdnPMymfdeR8/jQmnco3inRkqQfhOTPO7SRJ6dU64YlWZCatcXYLxT7z84SK6ybQ49l6fjE+txGb+446DKk3H/aaRefL018tBlS95gwQfNraWDZ//Dy411OmTFCjMDY1ttQM6jJWfhSlNc7cYq0fUOynOdq2nNKF4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by CO1PR11MB5011.namprd11.prod.outlook.com (2603:10b6:303:6d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.18; Wed, 22 Apr
 2026 07:08:01 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 07:08:01 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Wei Yang <richard.weiyang@gmail.com>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Hu, Yong" <yong.hu@intel.com>, "Zou, Nanhai" <nanhai.zou@intel.com>, "Tim
 Chen" <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li,
 Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Thread-Topic: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Thread-Index: AQHc0Y4h66ZJRC45aEeUdFXXLFyV9bXqRsUAgABiDOA=
Date: Wed, 22 Apr 2026 07:08:01 +0000
Message-ID: <MW4PR11MB69364A3A1AB994425E53DBE5A32D2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
 <20260421125508.2317429-2-yuan1.liu@intel.com>
 <20260422011126.thu67icgj5qfbecj@master>
In-Reply-To: <20260422011126.thu67icgj5qfbecj@master>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|CO1PR11MB5011:EE_
x-ms-office365-filtering-correlation-id: 01e3e362-30bc-486a-8f38-08dea03de3f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info: 32x0XY6XrimeZkflM4UC98t8kKiRzIu2NI0dv91EQvzxHOY1zVjbu56mZHT9sILc5t46ZKipD1k4n6HgYtNI4V2gWVolGHvWsV4IDPk9/3jIESHcAyPp6EIeMn4jUX6fSNh0vy4IzeVbQfQ5IUTZmfS5d4W5WQ2iaWg8o34XAjjuCZ3hL4coHerC4zBTf7qWJNyd6a2g5croCDyvJ/e9/3BhRjIg4R6kfDCyMfIHuKpzp2F8QJ/1Yl2PGXwMOkGdclYNISwm+K9HZNqexVByLuXk1JlkNnDLH5/bDjuliH+n5kukdO/hQHwtfmUFD+BQ1T+1BUtNlMtdWlX5IaZxttAMmBHgEcF6UDVMDieLaaZ2wveK8g8GVNt0qEmC3O3nnRG0eqP2voLv0saHS3Crtkna2w0yXqPSAHnn2/P/JP1eu/tSw4N/lZ+FRXCxvnyVF/8c5WprY+xdp/rFtvvrW6R3Ax2AdbgJarwQuNhPVxJkWYmfEwcFUm4Cc6d4n3vcopmPSgIW2KNuPLKiSsFszynSdWFfP/51Kgnj5obZU//9jknmrCIPWkIZL8vBoT8FhFPqGHOOwlHxtTe1bc1lKnWuVQ/XUVJZCQNfjvq9Ab598XPxrXJv57/j2cY/YTehPylVh6gVQYfXsk0cS1xUQLxGtcIRbUmQLsi02oKLmdK0d24OdZptyQu8oQdWU8CeeEYcfkZnUZiBNeWwDGPRITx98LnMHYc1qppqijnpvKX+C7mmoVhH9aZ6iYQjroR2COyVnH2c1bVQn6vHfqQ0Tlny1G9E38zcPbfppWQ+FXs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7Y0aO6URZUDLYROv9BF0QkGj3FjOyWWAjjPfa+0vIIFv+JEmYL0dkh1n9+ha?=
 =?us-ascii?Q?7h61/3Qyf4VW91sI7umDR9yCKKmID2NNyWutxBiIUeET9Qm3SkmyAZQPGTfa?=
 =?us-ascii?Q?Q8GBAkKnIPcRWHCh09AfGFKSw7Z5gAfB9kPjawKX4IOMK9WQZ0TMe+miNULr?=
 =?us-ascii?Q?vmTcK+t7R72PJ4baWXxa06S4S7diFjEJ23xrV0fytz+TGBYDGUIHT95w2laf?=
 =?us-ascii?Q?ODxeaXdgvOmlHVYMpv/exDLzI5fiHS7o8a11Fvfj8V1VJMqIyqKKW0olbpiw?=
 =?us-ascii?Q?FoqxzWT2FIYqBdE7ER2wLJ7ObhYVaGb99gbzf0gh9jN79M0luSLwsPNeOAro?=
 =?us-ascii?Q?Qnl+AsET8PWa0emLDmMKAtS8SszzfNLyQTwE20bZhhceFJhu0dRMhHoDW8VW?=
 =?us-ascii?Q?ImOMf2pdS2gNhrYR09bUy1cF5ccj2oBV4vCNBzIfC3oyqAoqqGBm/iO3e9Dn?=
 =?us-ascii?Q?OafS41ztYJEbEAGfC3cVni4Rb1jGnXS2RangrNGbs5o7E6sXvu5YgNrP0Ar4?=
 =?us-ascii?Q?zGJajSdGSU07xkx7lLbevgub/8gP4bn22oqgGDlxkJ0GYlJAkH8AXLqI1l11?=
 =?us-ascii?Q?/Fcp7pNAO+Y8fJrQcFKq4/JjAUdiPBBYRavjXDOFXfaAeKJe8AqvGLlD3U7B?=
 =?us-ascii?Q?Qmhc9Rk6lafTOjkDUQNjyC7T/u3sq5MA4EbixyQy9kSsj7U5m1bwscduk9/o?=
 =?us-ascii?Q?7bk8EKGGMdQMDvBjQLUXlYnCGhzNTH/0eir++5loIBPWEYGK/ARps/+7ib0L?=
 =?us-ascii?Q?vhAkZq6XHW9IQWd0xBvN871u25DOOxTkRUSefT8BYjX4NKlGYSk7Q0+al0W3?=
 =?us-ascii?Q?+DvhCD6YYcTRcr69y7r7+on8+qw3vDP/HHSXjyJXvsX9mamdoefQUnxByS19?=
 =?us-ascii?Q?uOaWBxLDytBCgdvIAh9rrMz8pxkm8sAVFl2Wbck37LGYDIqyJjDwJWVqCxpB?=
 =?us-ascii?Q?BRv+tdR0nYFCv2vpncqPpqRoSKvnUCyf+9KLDV6QIimfJq5M9mn3Q0jc8nAr?=
 =?us-ascii?Q?oQOchcUypCzVsM+15pHv6oya5Bu7B+ZRaKm0pgH7b4M+Rcc6q70/j3sMzig1?=
 =?us-ascii?Q?DVjYfvp0w6K3THKlV0quncFVVusOgepNx+vb+wjLRC/S5qFWvBip7jShKFAo?=
 =?us-ascii?Q?xVwWFJYy4upC1eGCqbJHXT5XGP0Uqz3Y4ZFVPhHBvuRYbw1eCyFulnB4z/7Q?=
 =?us-ascii?Q?RduFirUE/wr4wJbghnZJTjEY7ifvM1MwwDQevNog6pEUQxjD/YsQE4cPdR9m?=
 =?us-ascii?Q?oJH0Z1sx3V1vdkaSG8L1oVA09uQhqVut4NjBXCqMP6cO7OmDt90rQFAPzWX5?=
 =?us-ascii?Q?4aenEToSvgFbLgno3+8d5j28R5OQGGYDH1p+fpBu3ru7Trt8NYJW2VJ4A22l?=
 =?us-ascii?Q?glocYSOTHaQi879Hzh1554Q/ZY7ci5y71mJmoEUPxIjX6YeztDBB8IAVoGms?=
 =?us-ascii?Q?6YBONAkkgds4g1C8wijTD/2R2Q5LoXANdRiH3Xb+lXx+93JpUf7SKf0Ru7r1?=
 =?us-ascii?Q?D4ufA2A2jc9t33Gb/N0BJPzPeD6BvUIuNM6XWk3RGvABhBTQCFuM2x6DxXCd?=
 =?us-ascii?Q?yEw7uMXV2GwsuPb++D6jTlrSawcgtouq+G0QntR8p/860Zdb2OwGVG1IYCyz?=
 =?us-ascii?Q?s4a849hXPdGHQfbSxiMJ0vx7+ctVQ7xC3QvUhBfAiN6h0Z9tpJpoO22PYkdY?=
 =?us-ascii?Q?pbwFb+uBXV/dFMu4EsYe8RYocvwdOHkqYGVvmmTtOgJ+KRdo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: qpeN6oxzo/07khk4Jx1WcP+fLeGygj9WY96goKtEMMbXyxtYM2nh27NQG8AQe2gEN551t09FI2/3nUouC8znp6y0b895SyZMMducCr26uVQ6xh1EsSEoU3VjsKzThsUv00JikUhuewpuBUkZuP2uGxkg3En/S3d7YoQ0Zapcgd4vHFHSHWpw+bJnHin1HqSF2JppdQrdn6aDxPUx4gWukuOtBIK82wr1CjbNu4GMsphkEdNLPCmQLgFeRGmPRgayFUBb+5HN3I18rAhTOafmGptgMLvfepn3N+x0IsNDOt7JKR0czGwhn0YHil6o+sN1L7il+JyD1KXmCPvfBEghXQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01e3e362-30bc-486a-8f38-08dea03de3f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2026 07:08:01.0713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gfoi2gMpg6SPvOkQrGFDXzxotB50OE2+yHOI/sLw7oHElE15M3PKEuOVs7AhLjn1XDPBHTeg24zkajIcMqEApg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5011
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E40D51A000C
X-Stat-Signature: hcot8mb7odzbsti4zbooi37yf4errybz
X-Rspam-User: 
X-HE-Tag: 1776841694-889476
X-HE-Meta: U2FsdGVkX19N+d7039ctOlj9NDoDMO0dx6tqUIvRyktRiXnKf08nIsgV6nig7bnpM0Ky8Ez4LiQuI8w75NIWz0JWsN/DpzyeJzWhlhV/u8wEXz3yPMuZVjmryWvA0GGpIxQe3jrOpQuPu4N/cWm9y24tvxTQNDGquJM/F6pVUVSGqqHZrRg7sUakGoFPMy23XSmST4W0Cquemf2Fxbc3SNpYv2Rj62Mai1OsZtkurAEB44uecVHms/wMdT2FtjaQbh+UlUTnnBzPtf3D6zIBGUQ2fRgbX/AxYmgnYoVik2ZDHuWdFO/AkHc6oAqJCKf7lhp/JeoGn86+uBFE+CJKlVKTZVkltNdT2XGspKJRuwyWhZMAG+Plz9GjEiuMyVoP+wacpnooB2dRZjkDvnUbS76khiZIh+CrLD2TaF8UclQwMQtpvCmCuhkUmCTM6Pf972EfHSbiTZjit1+xi0a2oQFCKwrUpjhj9/nhvIFnTSK7JPUN9hmVh6Q6L9ZuK+Zarm9YZUQNZuc6+8t/52fegO/HZrD9d18pPfY/b28EIqLBR/JCLhmX3nwyeK2XERTLn9qam4lWq0mS2aKpQmmvfgHQfL35pLF3z546cH1aEkWQGbH0V7WsoQFSuhVIDGJY8bOktRM3RRwDx1OhmXIZ/P3k0EH4JBnjlIVmStTOQGLPm8t5kaEmYbw184YJwTY03gYZgiTsM0csyisdseJTVZscSEgZGUg6i4HBqPEo6Kt5AgDTCsxkskPUOtaGshNUR8P8TkrsO+3WTszFJYr1c6bSW+FXBSdGd6xHPdcffw2iBo9UmuhGtRnXcJ3OEgVKcRgVikJcOtMRLJ0/Qm06payUKWmji7tw7VykZJtOlEvLYDTHWV8xxGcXDczaNzarg5HyWq3J0vE9Xm3MMra6zsq5EH3NXx1GQswjqliM5gvHIGXg+s1+jOay40a6gGAl1pKg2jWHSJF7zDkeU7V
 jAMrGYvj
 XfGfof3352JgeYihT/vjMdLgk9lQS6ad306GLYah0daxf1jpEpnGLzejQt5wiNF1yuUpn1CKZ0wWAnW6IaLeUTE+1EyvE9ehxyy0PdeLSgVTnfhQwJGxki6Z2Mw4KCHDBq9t9Y0HHqBEmL8DQU8dMO1FAk9Mu7wmXi8PVg1ENygndbJ8xxFFkjzPWNd/Bb+ABHPtqzNgd+r9XBSf8T/bciRkGxxy225zMfN0inj3fNCNQz3Z0ZYTd6s1NgJdCBzbQPspXsZPFo2vYd0rXH/aQdeIB+8BsLtgHR3RLzq60sf7CBZ4R9k/oMuJWv2nEUHJd3wN3GH43ZPLqTnFyGllwgxbMrlXc/eaV2jm/RYWh7lk8njSeUG8YM2sLA+0JC7HQtLpSW8KExHYOIQRF8alvIZ8kbHbtINwp21DqZ/WMEOsLNJNMcMGR6LWgbc5kcy+R7ggpSzoizhbig4DIgaV5W5oonOreKWWxbJdfAdr6wdKchouENmA2yJ/cekQXoyQW2gsMOpyasUmgxsIkhzbf8nUtM84YpDsuSMrZ1lkuR9ilP4+NVxFsrbaH14sDcDiSNIO225uNTJO2DfmI0/tlKreaCsbBXS2DjAtD+sbSylD7VmpD0j7T9T61iDRXZW7CpezJs3kgzHyYo9cOHjq32VXWmQ2C4Id8rS4P9h7cqXB4MGIqHqeAmAoWpLe1Jh0YEzt/JwpEGAUcCbPOFGTLszn9bBEwrz4+dxxoRQUzsvVoTLbq8j5pNQmr+iXjY2tkxrYS5LeKYoX4Yy+mRP1y+iP9rGQrcsK1VIWB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Wei Yang <richard.weiyang@gmail.com>
> Sent: Wednesday, April 22, 2026 9:11 AM
> To: Liu, Yuan1 <yuan1.liu@intel.com>
> Cc: David Hildenbrand <david@kernel.org>; Oscar Salvador
> <osalvador@suse.de>; Mike Rapoport <rppt@kernel.org>; Wei Yang
> <richard.weiyang@gmail.com>; linux-mm@kvack.org; Hu, Yong
> <yong.hu@intel.com>; Zou, Nanhai <nanhai.zou@intel.com>; Tim Chen
> <tim.c.chen@linux.intel.com>; Zhuo, Qiuxu <qiuxu.zhuo@intel.com>; Chen, Y=
u
> C <yu.c.chen@intel.com>; Deng, Pan <pan.deng@intel.com>; Li, Tianyou
> <tianyou.li@intel.com>; Chen Zhang <zhangchen.kidd@jd.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v4 1/2] mm: move overlap memory map init check to
> memmap_init()
>=20
> On Tue, Apr 21, 2026 at 08:55:07AM -0400, Yuan Liu wrote:
> >Move the overlap memmap init check from memmap_init_range() into
> >memmap_init().
> >
> >When mirrored kernelcore is enabled, avoid memory map initialization
> >for overlap regions. There are two cases that may overlap: a mirror
> >memory region assigned to movable zone, or a non-mirror memory region
> >assigned to a non-movable zone but falling within the movable zone
> >range.
> >
> >Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> >---
> > mm/mm_init.c | 37 +++++++++++++------------------------
> > 1 file changed, 13 insertions(+), 24 deletions(-)
> >
> >diff --git a/mm/mm_init.c b/mm/mm_init.c
> >index df34797691bd..2b5233060504 100644
> >--- a/mm/mm_init.c
> >+++ b/mm/mm_init.c
> >@@ -797,28 +797,6 @@ void __meminit reserve_bootmem_region(phys_addr_t
> start,
> > 	}
> > }
> >
> >-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped
> init */
> >-static bool __meminit
> >-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
> >-{
> >-	static struct memblock_region *r;
> >-
> >-	if (mirrored_kernelcore && zone =3D=3D ZONE_MOVABLE) {
> >-		if (!r || *pfn >=3D memblock_region_memory_end_pfn(r)) {
> >-			for_each_mem_region(r) {
> >-				if (*pfn < memblock_region_memory_end_pfn(r))
> >-					break;
> >-			}
> >-		}
> >-		if (*pfn >=3D memblock_region_memory_base_pfn(r) &&
> >-		    memblock_is_mirror(r)) {
> >-			*pfn =3D memblock_region_memory_end_pfn(r);
> >-			return true;
> >-		}
> >-	}
> >-	return false;
> >-}
> >-
> > /*
> >  * Only struct pages that correspond to ranges defined by
> memblock.memory
> >  * are zeroed and initialized by going through __init_single_page()
> during
> >@@ -905,8 +883,6 @@ void __meminit memmap_init_range(unsigned long size,
> int nid, unsigned long zone
> > 		 * function.  They do not exist on hotplugged memory.
> > 		 */
> > 		if (context =3D=3D MEMINIT_EARLY) {
> >-			if (overlap_memmap_init(zone, &pfn))
> >-				continue;
> > 			if (defer_init(nid, pfn, zone_end_pfn)) {
> > 				deferred_struct_pages =3D true;
> > 				break;
> >@@ -971,6 +947,7 @@ static void __init memmap_init(void)
> >
> > 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
> {
> > 		struct pglist_data *node =3D NODE_DATA(nid);
> >+		struct memblock_region *r =3D &memblock.memory.regions[i];
> >
> > 		for (j =3D 0; j < MAX_NR_ZONES; j++) {
> > 			struct zone *zone =3D node->node_zones + j;
> >@@ -978,6 +955,18 @@ static void __init memmap_init(void)
> > 			if (!populated_zone(zone))
> > 				continue;
> >
> >+			if (mirrored_kernelcore) {
> >+				const bool is_mirror =3D memblock_is_mirror(r);
> >+				const bool is_movable_zone =3D (j =3D=3D ZONE_MOVABLE);
> >+
> >+				if (is_mirror && is_movable_zone)
> >+					continue;
> >+
> >+				if (!is_mirror && !is_movable_zone &&
> >+				    start_pfn >=3D zone_movable_pfn[nid])
> >+					continue;
>=20
> IIUC, when mirrored_kernelcore is set but !memblock_has_mirror() or
> is_kdump_kernel(), zone_movable_pfn[nid] is kept to be 0.
>=20
> This means it will skip all memory regions.

You're right. I verified the case you mentioned that mirrored_kernelcore
is enabled but there are no mirrored memory blocks, it indeed has a problem=
.=20

Thank you very much for pointing that out.

> >+			}
> >+
> > 			memmap_init_zone_range(zone, start_pfn, end_pfn,
> > 					       &hole_pfn);
> > 			zone_id =3D j;
> >--
> >2.47.3
>=20
> --
> Wei Yang
> Help you, Help me

