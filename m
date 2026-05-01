Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ADC6CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 20:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33A616B0005; Fri,  1 May 2026 16:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA616B008A; Fri,  1 May 2026 16:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B1B6B008C; Fri,  1 May 2026 16:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07E496B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:00:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89B35C1200
	for <linux-mm@kvack.org>; Fri,  1 May 2026 20:00:24 +0000 (UTC)
X-FDA: 84719917968.13.38E4D49
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf11.hostedemail.com (Postfix) with ESMTP id DF5854000E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 20:00:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=di34M7z1;
	spf=pass (imf11.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777665620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A26od0xBKDep3Z4Z0vxMMdyQ072HAIu2mfwXQbm8k4I=;
	b=1YmHXbB7P9/vLaHB1GRTFzh4nMjJI6rKzTg8a/2v+cp4CYFfsALjqwK8fKa/ZdXdUMJsON
	Hijzt9nAhWFXAV74xZMp7qkUuEUmOBGt8y/seRt1pP666mTYCw6hsHy2pDnB3fGaWWQ+7O
	XiXGSXCW+tf3KtyC4t+237B94Lbm9do=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=di34M7z1;
	spf=pass (imf11.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777665620; a=rsa-sha256;
	cv=fail;
	b=OMw0D8MucmyG8vvRWElo2IJpzr/MvhYz+O/tB9yQ2HNIbrIHxu3h1nXjII+yiK9h6eyg8x
	GjSMlogDdUMRIfMpIyIQPLgnrMjVlCs0LsCYQYErT8ZwDDFhlgA2EaaJMNFj5LjkKKuca/
	teIZXllTAeJTpIX883DAlp7cCyoRdVM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777665620; x=1809201620;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KdZPv4324VpY8zuFED7TSFu3dZfkYF24oOkFMsmRBRM=;
  b=di34M7z1S2wuKWRbRH71N20+HcVpQp1vmDpfRjwNLybvuAuZVeHHDcmc
   BEeONBerYZPh7SOYQ3w8pzZ+e8H+iqJsHWrLuULdmro63cz2JVFjm/Ax3
   p/sLXlApT6BTHVn+8mU7XwlujoGopVqzOlX21rLnVDlkal20nKfxBnDJn
   Y6fipNJ2IYm6YynQxSESB03DXO4wTR58wKRsz/QeqDhAJcrdse0827Fe4
   sfXq50NqPKfvDZvnBaUK7xIr2+jRskPqL9fpNvy7OXd8ig6B5RcSE0Skn
   R8iEsioPM/CXi5h/PzjSWvlsWc8AHi/mYtWmoV1tre27fuTdAbJbmtVOP
   w==;
X-CSE-ConnectionGUID: sh0dPizLTsmyR1eS3RMDbw==
X-CSE-MsgGUID: XYlN5naWRbqH3BxfTA/Wlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11773"; a="78618556"
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="78618556"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 13:00:18 -0700
X-CSE-ConnectionGUID: OHC9O6Y/RjGMQ07dCI3i5w==
X-CSE-MsgGUID: 9DAdB6ACSOew+zdbDZTwCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="232303355"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 13:00:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 1 May 2026 13:00:16 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 1 May 2026 13:00:16 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.56) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 1 May 2026 13:00:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O4AkZKvoo676sGvicpe2rymB/1d1WxBAXoYDMuKhqaWlref4ARyQEK6YAn9wNl4m+7YGRVz8es17l6RRiUWAibhtey8yGPJYHL0FccVOx1jDXrTkvoimrIJCXIXm2Q98iSO1bJBy/AJP750RuLdsLZFOk3qyIhCOKw7MRYIkdt2XPmmXNQm2QfVTiS+B45P4nJd3PA+vBrGbomf+fJYxFhp5415g8aRITRg+/eP/A5nafsIbWTPRE/8R1XNMhuU0TYYtlx7ojCrzZ6VHjNWyheTfPbErDw3phGtLqaM0SClKwzW66ww9Q4MKPKdkQp49zlhYn3e+slgx8J8KTb2EJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A26od0xBKDep3Z4Z0vxMMdyQ072HAIu2mfwXQbm8k4I=;
 b=gXJWHeQ3XSjIhFclOKNF31k1UV+m8hSmsducyL93nUhU/8l3ZNdERQMb5IhEHu/USsOHdPma1SMQL0ZSkXSaRMhnlA6vUUqFwjenR2KR/itTPn3qGoBcjLyeeNj3n2lvsP8FBeVhjIiLy94d7LzkG746mwmlYUjeUk73ojsfBSS6PfduI+kMFQY3kj3cfovPLIkgQlDyHzgb97eqbqxFnGyhjSg+Bt4rTcPC+dDwMiGzhTemUoWjDWgY7QRU0TnTCXntMNn/q9YGLUkx9T/lb8sFluUfJ8zi9vl2i8Er/dEcbW7UfGyqCmZeWWY6R50/Ak53TFq5f6MG87AUDVyZdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DM4PR11MB6527.namprd11.prod.outlook.com (2603:10b6:8:8e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Fri, 1 May
 2026 20:00:12 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 20:00:12 +0000
Date: Fri, 1 May 2026 13:00:10 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Kenneth Crudup <kenny@panix.com>, <airlied@gmail.com>
CC: <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: PATCH v4 0/6] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops
 under fragmentation
Message-ID: <afUGSmS+jNPP8O5v@gsse-cloud1.jf.intel.com>
References: <20260430191809.2142544-1-matthew.brost@intel.com>
 <20260430191809.2142544-3-matthew.brost@intel.com>
 <f25f27a1-bf09-44bd-9b37-49f159d82d6a@panix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f25f27a1-bf09-44bd-9b37-49f159d82d6a@panix.com>
X-ClientProxiedBy: SJ0PR03CA0361.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::6) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DM4PR11MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 2faf5448-21d1-4c80-7218-08dea7bc416a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: FhIBdoh8XYSmqm6guLbQEKpHMEtqzZPdTIZrKU+qZyfXrY1qUprwHiOEAvYYXoJRhe5X9GN872CWWW38PdXx6LSHNpSUEndN5zJdBUi18WX2rM+TQ1Vdz3M6CL/CSL4aHGRSTZzovrfNybV+RMTgGKYh5VlpGlTcngrob3cFyM+lYeoM7s6n+4h0fGU10d/5vBB2U7YdFzp0QcyFMGX9H2JNJStBtdaPhuzirrCpmKvn6T8/mX9Y4ixn5sqJ+ghlIuLWOCF4EpmgkgOH7zgCq8DObgml5PmyCZ3ZG7h7UBOGZRdDEledLw3Wp6ceH5yuTUriXHJRbebTRjhV9siMmKv8dbJUQQFJqWQJKHuOKh/NCOuGJ2LHXUtM08kcSIRIXF8h4BL9R5mHW+4KOvjq3mB3/T0PjoQnwUlmqlFFzLSsmLaQgAWLBr5sBl5mqwrIZ+3PmfBpiHv4ckw1EWbdBg/hSP1DtbaOwu5THNsFtGRG1qxk2fmv00DaqB2HpIW4IlLQOzHLb4GGDcs5uISvHmzRRRJjD06J+4FKOTk65JELMgYKYRCy4VaVfSBhWlGoyC/D1S4F7O8W6CrscjTy7ZuYdGz5lsEw+tvO2Y/Rp6B0licbLidLU65i9rRyY7hZIV/3eEvPTzGsaaCfED32YIGAFD9Gkzd86hJY+QDPOZcNMcGhZC/oKHqyqbtNHjaa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h5TlonLxMuZhUSFhcddjZIgcJxMXojX7kKKDpTLlghPsCKMwzEyeO0Yo0me8?=
 =?us-ascii?Q?W1zzwmn28B7ZvTHDMB6XAfh2te6/U3RfcdwsnxDM+W+TdcdY29/O4gArNy3B?=
 =?us-ascii?Q?YVF3gh1mBj/41zOXFETrsA8hJASpE3bUzSR3gwn3BBuSygECxVklYbz8jXO7?=
 =?us-ascii?Q?YGvL4Ht2JXnnGDy7SEsgByrXzh/PGo5qIlPPfdnepZF1QrlsC/y/yl4DZzhQ?=
 =?us-ascii?Q?EUT1fLLm2jcJLicPz4za6gpf0hS5qNBqCc3vne9ZeTr9rphWoiA2+mP3dfq+?=
 =?us-ascii?Q?mbSZwrTOlXW17YIbVeHgA7ioF0rlQP9WA38ScZE/utcE4uo/+JyUq4nUcZp4?=
 =?us-ascii?Q?TSr6PeINerCD7mvbV9ZA7ij0lUtR0FXW2pxF/Ir76AsPACZiIxFZnHCNtct7?=
 =?us-ascii?Q?so2VyFBL85NqdpO6+lLNcjY7GCLxAKnpzCu7R6f39xX7j+LOfCYHSZlIFrkz?=
 =?us-ascii?Q?LFx/3+BINp/JWZCHY4+g3vFp67MtvvweNJMoOzmSRs9YwAvjMFgCOqGeikhS?=
 =?us-ascii?Q?PRK9V3XI/J0l0CQ178hocjP9hnJ6fOc97nVQoexg67Ps9GrblL1beV9Y9/lS?=
 =?us-ascii?Q?9Y4Pt+HZ4rtjVWSk/pP30B9lVoYCDbJehEVMy3F//Jkb0LQHMtM342IqbYRl?=
 =?us-ascii?Q?GfhfXaefxsFy6Xy2dHDqquJ2iIqQyMLyoxGUOjC5AN1zppO8b3BVyR7ZExWc?=
 =?us-ascii?Q?fw7XFHboJBCffIKE02VxnXKZR+BToYjSrHPA6TvDqRYj31eNAqWJ0VKvn7gF?=
 =?us-ascii?Q?wGcOW5ScPzK1WNQuFht5n6b6NAC55MuINoJ8AZ6gWFNGmQotl+iy6PK/E7c5?=
 =?us-ascii?Q?+7iHVuDmPsSyvebc5P5wQq1hdgRR202TAoHEF5arhguIiAw9++01ZoXEnpiL?=
 =?us-ascii?Q?cxrrKn/vBvg5jvifvUNP5fexBK7E/MPY7HJCV7bPg2z9Ok4ciGSZ0hZImGxn?=
 =?us-ascii?Q?2K1YzijQmpfAFEcHHMLwRTpy2MyHQG+KHuf984m5ucZ4okYN5eS/pfyAKDRC?=
 =?us-ascii?Q?Wra6/5OrRS+WHC+AJ4mWw/rOPnj+d/VQTr0bBMG1f5sf8YEf5aEHtbLCGicT?=
 =?us-ascii?Q?u4vuNd05p5G66IEPbQHVNmBuVsZfYGFJ8UqTQhgEAkKOCfPIAx1vmrU4cmkz?=
 =?us-ascii?Q?QuQ4E3cC+wQsQAUL6lHtTepHW8dYiqcIZl3/uBmEDlcdCE1e7dtbDQwyAk/6?=
 =?us-ascii?Q?DJFN68z6RluLLZzyQP6grYM6gf+/A6Qw+Hsac2Htp+kgT3sJHMxWMul9FZzJ?=
 =?us-ascii?Q?gUbKwU5OAcn4Kb9a2Cnlq7+KX1eoC9MmOBwHDWxQUf0j+WQ6owCCwBCCOXsO?=
 =?us-ascii?Q?GJ0xOY/9oHZtWOOGet4FnBgVp0nzDFOUEjEM1E8zgQp/+XcSjlBEElzSgjvf?=
 =?us-ascii?Q?7aawNtdMDx86ilbCGeAuFDy2t3EGAfGTNsKXJ3ikWN82UJza4SSiWk4i4h4G?=
 =?us-ascii?Q?Vw/8QpoTdNoJdKVn/DOl/lwctkJr/o5PcMRyIBPMslBEkCyRBDhbyT/ILKgA?=
 =?us-ascii?Q?SPY0ZXOejW/oPuzkehwWytZlY06EeBSS3DJzgdyX0R1dRliI9duecdtNEkOd?=
 =?us-ascii?Q?z83+I0dHEiECj/J2bXZw9subctE86dY60bTtJGPCOT5vUEQpUkvAZ1W21lTW?=
 =?us-ascii?Q?wOtXrgTqlbORo4Mjd8vVbPet+CYWPzH3xcAj7kewTO+0uQ6wrG1PZT3rMcee?=
 =?us-ascii?Q?3+gbLBQb0KhatvdIz0SWgkwyOPEdWht7D2sp8VFyaKv15/1XxF4XzmtB8/iR?=
 =?us-ascii?Q?EayjI4fxPTHWq2dHz3TGUUrP4d0blu8=3D?=
X-Exchange-RoutingPolicyChecked: AOjPfBVegg8tLSjS1N8HmkUP613sLxPDHqgBmZ24agueTgAdLY1o0HhdrEb40NaJCx2SUonLzZXOtmL45jMTbyws39tttQGeH1YEE7lY0vbEFjA/VqTjsWEjRjO9kD22DqaV/TOYisg3Q56y0fh4RdrhF+DfiyWmAPViF9wWbJsuQwWOZPEBLpnTo+qLLS6vmGS20i18Oc2CA8z+6Jb/SY6aeM4E3Vo4n5E5PruxwrYs7wCNCzMDfAo6jzrfP4O7siaAjXM0i+A5gLFrLTiGaQjk7OKoJhiPz/xPgXK2lHq6EaiZuoqBBiLIW52pNvs2u9b2yCmjnPQFTB2pdr2WEw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2faf5448-21d1-4c80-7218-08dea7bc416a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 20:00:12.7741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8H1UAELmVPpjXJZoZO2sW4p2nM+lxo5srX58UHDgvFNTdmKa50fXCywh72Joajbt/AlBEWrm8bR6GMp9j5l5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6527
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF5854000E
X-Stat-Signature: 15ustzsp4cqjykwwudi8u9w7s19gcc79
X-HE-Tag: 1777665618-161189
X-HE-Meta: U2FsdGVkX1+sjb+P/pS9Ci5rVEqK3ecf9/2L8nH6pr9Dgurzsb/zxxB2dnxSILgZh9QDwZU62nDKUD5hMDCVzHp+BOOJ1px0kQ9m0FZkNiptC0zDo3a17BnW4/ivg1tSWPDfj4XE6yCrvZwXAjz9vknlt2WdXGSFumrL1/p6Erum3Sc02vAVr0aCvKkOIGBdRTOIx49/4dNY38OmPKbx/X9jiij1HSmoIkNTtchihhmAbzqbNoMssAvKKhNDgtaZt5RkXO9WbTT5SH4KjyeRBZmltv/PN+ypWrhLGEeEGwCww+nF/dc+ssFlEi6Hm17Bun6pwMxlaT9NkcZnBlxetWciXPLu+WhwYnCqu/5klbpBlBbhmcNAkuqEfAoK3FYE9tf+NuMm0YTEfXsYK/L9XO5gnWRc4DJAKe87oi2X8otfCuBF7B3zoN7XXQYxo1m5SihFdjQE6C9mPPs80dDa1lypKG0tBuPXD07qUw4KAQ7HrimBvy8M30i51K7OsfuVE2VDfXyczghbwhxpvAg+zsTWEUzifCQ4xSntYFf2dBBumGSXymD/KjwhQcJNwpi+PY7/e1BCiwvKdwiYbU7CUxMQ1xWu/EkKXye91ShYP6Mn8IFidj+Z8sGw9C/8auNypGdjOfO2Ipqsk/H0+oPHBaL9hOhxZk1ztwR+1uWpNS5HVJLnruL+rh92C2cuqazS08foqJa3qttTQ9KgZSIXFpNxm8stxMwK+O7TwGQtiURaNCcQXVelGhYdZjbWv2xoPrf2xruAlW7eevJaSl0Zi6YYg34ElPv3IKjyPkWSawfcSnpKQflrGxjrJX7U9KxcUxZkHMNiuCNbtBaIP+hZ8XcQFNJYtfX3+1kuySJAlg8Og0v0rOLL9PjUYzwdzpQw1Bt3RN2r73rNNcB7D9rDeRa2/OtU/tke7BmYwbIvZhXjMXkLTFnVVBRoVtLJGwoSniea58Qbz8riU7cnT86
 dy0WJwTA
 E7l6kKTwm2nlCnOWdRE1Ec/9qtFEdb0iCFWkZiNs9G94iiGZn2HM2UKb/0dGl1G8XgNHMYolwSlc7WZQUuQZA3dgNQqkoG1HTeoqI1dqjGXWlgwkefdRHUlXK2YJH6+6J40Q/xXq1g1vcXctJ5KEH69M5PbtKpBwew0VD51+DROBcImCQU8LZdRnzWauWAS/AzhK0N7xQKOmmS2NMVD1P+9lny0ZeSwRMEKk+IogSm5jqlxG7AEnkiqmkYoSTys5tTTh4Dl3McX6DBKRxr61pnrTqO/XQbsGHE/fLN61S9qbDhvWdzMVvxEBRDIZgfJ/1qdUiGYsnXhul55w7sSfsLJyA1IuLNairtHlwXDF48nM/+Xa1ihOnab8QJyJc8+Lyf8z/5Bu+PpgtFr+OyN8qv7HCWz9/LH04GERrEZH2gftBPEVnfg8LZDZbGaA8G+gATXy4fjd/I9j7ae+nCDaYPn599Vq9eCsv/DJa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 12:08:48PM -0700, Kenneth Crudup wrote:
> 
> On 4/30/26 12:18, Matthew Brost wrote:
> 
> > Introduce zone_maybe_fragmented_in_shrinker() as a lightweight helper to
> > allow subsystems to make coarse decisions about reclaim behavior in the
> > presence of likely fragmentation
> 
> I'm running Linus' master on my LunarLake (258v) laptop, and sometimes after

+Dave

So is this 7.1-rc1? It looks like new feature to 7.1 added by Dave [1] and
something look off here. Thanks for pointing this out.

I'm grabbing a machine now to see if I can recreate this...

Matt

[1] git format-patch -1 2232ba9c7931d

> compiling a kernel (of all things) I'd see kswapd0 thrash despite having
> quite a bit of free memory.
> 
> I finally traced it to the xe driver after seeing the "GPUActive" field in
> /proc/meminfo suddenly start rising, eventually growing larger than real
> memory by several times (see below).
> 
> This patchset fixes the issue, and I'm sure there'll be a fix going into
> Linus' master soon, but what I'M wondering is how could building a kernel
> (which is just in a KDE Konsole running on Wayland) make the GPActive grow
> from ~1.6G to > 30G (and continue to rise, RN I'm seeing 91839848 kBs and
> still growing).
> 
> -Kenny
> 
> ----
> SwapTotal:      33554428 kB
> MemTotal:       32345672 kB
> GPUActive:        652640 kB
> GPUReclaim:       403988 kB
> 
> SwapTotal:      33554428 kB
> MemTotal:       32345672 kB
> GPUActive:        651180 kB
> GPUReclaim:       406812 kB
> 
> SwapTotal:      33554428 kB
> MemTotal:       32345672 kB
> GPUActive:        659004 kB
> GPUReclaim:       399396 kB
> 
> SwapTotal:      33554428 kB
> MemTotal:       32345672 kB
> GPUActive:        666996 kB
> GPUReclaim:       392764 kB
> 
> <some hours later>
> GPUActive:      91832468 kB
> SwapTotal:      33554428 kB
> MemTotal:       32345672 kB
> GPUReclaim:       488000 kB
> 
> GPUActive:      91832332 kB
> SwapTotal:      33554428 kB
> MemTotal:       32345672 kB
> GPUReclaim:       487988 kB
> 
> GPUActive:      91869376 kB
> SwapTotal:      33554428 kB
> MemTotal:       32345672 kB
> GPUReclaim:       486504 kB
> ----
> 
> -- 
> Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County
> CA
> 

