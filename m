Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB0CCC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 22:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDFEA6B008A; Mon, 20 Jul 2026 18:08:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91166B0092; Mon, 20 Jul 2026 18:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5E5C6B0093; Mon, 20 Jul 2026 18:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB246B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:08:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E91E6160321
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:08:36 +0000 (UTC)
X-FDA: 85010545032.04.5478B56
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf21.hostedemail.com (Postfix) with ESMTP id D240E1C0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:08:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="QH/4R3fj";
	spf=pass (imf21.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784585313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxMVfG+Ulm7Vwx+qk2+RjeUkNaQZNGikIFGgtCuB3D4=;
	b=8Usep5+o6C3nbmbtOW77Wo6Qd9rjxTKV+rdhQVnThLWkiLC6+oL6MLod9WMs2yiof/xGUZ
	RANSqZfGeOk1vs2c1yKBUCBd0b2eS1T3tFJxBIzaifN7WsB+2Yzdpt2Pi90UERybAS7CLK
	9lesJmGvul/QpBgqYcTpIwDpqouXqho=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784585313;
	b=um9jRPxQjTsvGFY8Rg+laNzzy5YbTIRsJGAjnuZ1+P+3+7nuWmXMrL2dSgW3SEtBilOQ6H
	SEhedAcalmbSMYRvTeGtp76wnrJ83WYrfvfjK5f6qrnepFj6TKf7vlpzt3lsXDdssdtUDb
	yMNJp27UMbclK1YiFASFwYmdIL+1poI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="QH/4R3fj";
	spf=pass (imf21.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784585314; x=1816121314;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eblDg82zSHBL5bIgpn3AjYBIlE6PnNBUcgX1cokc918=;
  b=QH/4R3fjohuiGdngWFqoQ7bV0z8j1opjvKgLJl3mNOXlKYvRZ3BonSGq
   HCTMTWFEtbf5XFlnmcrAB8WGzV9z7tn4kmQQIHIVWt3txuXzuEgMYSAcC
   /9V7g8kRw3fyYMnhO5D1COaCXkDJejjnJToOYO1PrSst2/mEZur22LdaH
   dgdx59DKZ3YqedPc4FLjJQW90/oakKnGUNd1x1Ctv18Z13PinmDOlrMOR
   eQtNqJLcU7j8JFBlycADKVa6hWWkxH755ukWPyPEUCb5iLP8fqmoXphK5
   JRVOjs+J4w1XZOcwsgl7wRmzsJdjKi3jngSYD50rBBhnjAiivYcOiWPEK
   w==;
X-CSE-ConnectionGUID: hlRiA/B+T067wBwpye/nGA==
X-CSE-MsgGUID: GSB3oqCtTWaZ2vBq+/VaMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11852"; a="84940522"
X-IronPort-AV: E=Sophos;i="6.25,175,1779174000"; 
   d="scan'208";a="84940522"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 15:08:32 -0700
X-CSE-ConnectionGUID: MH63P73vS++8iJQKZUhy8Q==
X-CSE-MsgGUID: arThAml7SgaRxhcAbvjxIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,175,1779174000"; 
   d="scan'208";a="282059963"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 15:08:31 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 20 Jul 2026 15:08:30 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 20 Jul 2026 15:08:30 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.40)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 20 Jul 2026 15:08:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ccan+t3IEdGh7gXUevt8vus8A4ylzTsg8naRYsVHGziNQ1gYpz1wPqSxA2hjBN33fifnNeMna9Cn/XI6kzR73nT5QZDGnCeF9wNJkfZql+6UwYDrZfQX/Np4akaxrmSXaSxrxuA4m5vovbomYDBaWvUbizGv0785KIjb/EMeTqrxtYtGt8E9I9geEuxVqlE/JatQ82eFPTLJuqmreRTOJDSNQdKq6gC+M2/2bbq+xvov/HArKSq8AE2OiEFfsyyFcL5vKSgHBc58urm9bSeNO5qZTV3uFiaBgcq5snsx5czBePNBvAcKNyvKjR9qPnM2wf3xGBAk8al8nlHZul/eiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DxMVfG+Ulm7Vwx+qk2+RjeUkNaQZNGikIFGgtCuB3D4=;
 b=ov6mbkLbmKBK3hB/7ATYZQvqq+JdZoXBAg9VwOSNX4L1GlnfaEKZURR5YrZAWLB56nScmW3gi8FtmOSblR33M4W2T5FkFKZMyH6Kc9hB4jVKXpDjIfVc5Mm3tP00OQlZabrAXsaP77hadgOkMdGXEl0x+HccSK3EZuvPvPaI0/axthKGbyib1yKhbrWkvTRfcvLpNYJYeRdIFZflQTHkT4fyFxYycesryv8ML9hgym3DJdQMap1sAAs6tL4WldQNPo2h2/OX1GSHP8XwIayJjYm3DSxjFUjfR83Ev7onNS+Do08WMRCWGpmbtAvsr5ZZrRVlOHcEnG4MbsL8483kQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DS4PPF25B1C4D24.namprd11.prod.outlook.com (2603:10b6:f:fc02::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 20 Jul
 2026 22:08:25 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 22:08:25 +0000
Date: Mon, 20 Jul 2026 15:08:22 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Matthew Wilcox <willy@infradead.org>
CC: Christoph Hellwig <hch@lst.de>, Mark Brown <broonie@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Linux Next Mailing List
	<linux-next@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, <linux-mm@kvack.org>, Christian Koenig
	<christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
	<dri-devel@lists.freedesktop.org>
Subject: Re: linux-next: manual merge of the mm-unstable tree with the
 drm-misc-fixes tree
Message-ID: <al6cVnNv2TuhuiV3@gsse-cloud1.jf.intel.com>
References: <al4jGBGNG_QACaNL@sirena.org.uk>
 <20260720144141.GA16699@lst.de>
 <al40qCMTxhEP3Kx8@casper.infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <al40qCMTxhEP3Kx8@casper.infradead.org>
X-ClientProxiedBy: MW4PR04CA0243.namprd04.prod.outlook.com
 (2603:10b6:303:88::8) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DS4PPF25B1C4D24:EE_
X-MS-Office365-Filtering-Correlation-Id: 81724a44-d6ca-4c00-0135-08dee6ab6b77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|11063799006|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: XXOHexTfywLk47SZsSksQbA0ffSuejN4PSkM9/NN3YsNDJEoaZR+y1IBJZDSJghhuPczHD3UCi1ZmnhA+xmcrXERDW+1RvtDgmmtnDg40F5M4x0tQXQVmJZLDbRJ1iBJQqx0zPWJB/5zz2mc7707KznUU5+Oi/O/WQH6ETURgljtVzfpdVQ2A+kM3z+d28v+9Vt/cvx3YpWhQt/Quy7Zm/DxBG4xMDmlowxtkSLR6K7d0ui3Ahc04EJIRn2Dgiq1LKZJFGL08V4Cm0dcLtyJDMCfm4M4np7RNkONrSDzBXhmNgBtbMH/vS87GplQ1c/TqYoDED1F0emo+ataEs4s4TGDjlFx5BdLzCuPmYvY558QfWxGhQKoLLOpRcdW3legixtq4kGqAIce1s49V09q2IE9A88TuBXC8yZbyIJoHaDWwVvd/pu2HZit7/q/67D2iHyaG6JnCQ9Zks+XCQwnzPZwrajdwVJWMwFuk2uErhg2giQWUIOGxpZCB3xQ0i/AjlbBffmst9MHnJ+ek7+IGGZwD21SJzzairhvor8slMrSFf/a2EyynT2MdMSChqJAjI84vkpA8HeUlCHQSJ2/8CkPen3GmSnIbKTOI90ASs3CatvVWFfigKcFk9cH7gthL8VMbkE5Xup4+Ufk7Wupe04x7o709y872CpD3u8EKcw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pyjO9Vvmjf5L+YwSLt2B/9wZmyc6CiPGQGODF9cGA1giPFpCR2RE+a3ejyrg?=
 =?us-ascii?Q?Nw8R3v1mm2z0LtW8FABFtZ6S/qPP+r8w6j/Odw/p3amgTHjb4xRHMVLHTR/R?=
 =?us-ascii?Q?yDc5HN6c8lneZVMNUWezd6VUhXU8yhzBvcUmMQ/bQ9+mlMTxClEO+QqXqQQk?=
 =?us-ascii?Q?QyOGC5+oIkpLQuhMrck+6X9+ol07Av8meyrN0zx1/AcBpixBVM9xr+Pb1xj1?=
 =?us-ascii?Q?3Ws5pWGRnVvJVMcPCNyCkGfDOI3fhlEyUMMVGjcFiQjG35e7oo5DizdvlWa2?=
 =?us-ascii?Q?6TVRWBYZGyPzPeU9T4zaU3rjHXGzwGW30riwD296sBseJIvcet4VngUyh8lG?=
 =?us-ascii?Q?JfVOifCwNN5XUdiqqhl1EBL9LMzbY/UyvYPDScs13Xvd13NZ3Q/RQIca6WV5?=
 =?us-ascii?Q?4h9zlugX9Ymn59klL7QAOEzWPjgEVruMiR27Nc7a+FJ0QMAZ8eFGC5N6UMrs?=
 =?us-ascii?Q?iOczizaCAUO9DasRvjlGWML4KXsHuSQKh33Ysp3uypQCX4hv1dwrxFaCIIjN?=
 =?us-ascii?Q?KhqITf9YJANr5POpUz34LAUVqzRpD5K1OHzXYjPkBjG+8vBl0wmoqWTwY4nQ?=
 =?us-ascii?Q?9FMnsZrYflVbZqFBvpElcaecFI3BXVvSGzYIRTHTNlOWRDm2kOi8um7C/xvG?=
 =?us-ascii?Q?2ZWHxwCGtqE+swF/ahGmCfWdEmecLwQUdJ/URW+ADxFd2cCFJO/uulZX+ZIG?=
 =?us-ascii?Q?jjLO2/CUjobxLPuPn3j2GZTdu/64xt6GcezGfNK356PMvsY/cFp0bYbBAKeV?=
 =?us-ascii?Q?2Y5omCFj1Lr+jpnFi2XB7bwZAh7QCsXorfqWMfGrhyhkLBM4XPtb33corlss?=
 =?us-ascii?Q?fhNhC57t8Gpo3gKfd/6pbufWOc2qur9ZALdB+JE5RY0Ss5U8sC0rMxPQP2LY?=
 =?us-ascii?Q?opSOZK0GzLrR/cz9l3Hi8n2EgZv2BiwQkMjA6LPmPxEDc5fdJa3+4p0xHcsw?=
 =?us-ascii?Q?voRBWKVqcl3OjOFby6S5E1B7sALSOY/fwlig7bOumLBtiMkRb2SmxnmomI7q?=
 =?us-ascii?Q?wiNg5UjfADZdEc+AY5eTYtxnIknjVsB3A+kPCq/Bo+g53loAYbIRzNlw1W7M?=
 =?us-ascii?Q?64fNzD3P34oq86NF526uymrPzfoZyAFl0n/YevV2//1QhiO/qqhnyUMtDQov?=
 =?us-ascii?Q?TDZ9B6mH8clsxhbS7sCPdPsswetOGMFzbjWcaeuNWGXlzPwyNDK6r/P0Uyy8?=
 =?us-ascii?Q?6rIGc1dBCIvmp/mWnTKwwa944ihEBuQ7ppBEgp5g4V/5/VfseziECGLKbPTE?=
 =?us-ascii?Q?2Xvt2bCN+1KtKt9Rped2gS0fk4AATC07Y2tJla9ZRYf+pjOPPvxoalTDDRKy?=
 =?us-ascii?Q?4HCi5N7OXgwamqBhEEIq4s8H4NhAGZdYUJff46ef1H3wi5vQP1Buv5RDL6rJ?=
 =?us-ascii?Q?c9FyumOXZzYFN/y4pRJJT9K7lJgsf9FX3himrb626qvqr67HgU4J+WxPqxod?=
 =?us-ascii?Q?4oVERWZ3Aum29S2tN3XJg6yOmL80JYwO6RBUyp0AvbWbciDw+6h8PVKtSdG4?=
 =?us-ascii?Q?UqQ4V/sloViiD/soVIJOSGeeCkWidleSck1nvCPfCGUwNbZuD0580nksFHKg?=
 =?us-ascii?Q?jHTRd/lPbsxd+3hsFPGElTJ8DkebYPaw0WbRNbwiGQ5WTZgcpy/TzTiaOkTA?=
 =?us-ascii?Q?uvgG1W/n0pcPf5glNoSnmiQ9p2l6Q2DapcSZNrhqvIA6Kzz5LmVfH/fZFSIa?=
 =?us-ascii?Q?cTeIAYzQDVK8dNaB0Fm38hdDklp9+/Nz0mDUNGrtz8eopxUuvnFVFG8eEi/s?=
 =?us-ascii?Q?hxBVR3H3Ng=3D=3D?=
X-Exchange-RoutingPolicyChecked: rP4jDAxBJXuzioZriNbNi9xZuo22HxxHoHwp9ZLIW847/l4XutGzW02KlcahErp2gQ3NRvfcKNfjfeme8wmB3a8qSOGdcAGxq1OiPPYPK4FXyBF4/26XukP3F5X0U1e55EBP39p/rXl+Ylp7E3OEfZYi59T2m4kbjZmd84Vh5AyvHPFxPxSFyVDwKIPQzunzkcUBAQ06vJmJrZAIhTqaJvgCLxMn3VyqpqAuIegpX3CXXddzFfx6G3eYe9DSTOoabxIPb6bRROgRGEvSOMHtu5eELvr2cf8waVmjIMarzaHTTtaazHGVlpFV2WGjAKr1BLVmhhyuwew5zzFFeg1RnA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 81724a44-d6ca-4c00-0135-08dee6ab6b77
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 22:08:25.1019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++faZiPtlelUAtw1nSJPuixwuv0M8jsHju9FsKBtKsLZlH0uj1bs0zE3p+WXh3EHvUmQMJ61BODEfKqAfq09pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF25B1C4D24
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D240E1C0003
X-Stat-Signature: ihabczqpquoppanbrnx6hszshthqe4im
X-HE-Tag: 1784585312-696835
X-HE-Meta: U2FsdGVkX19cTM8KvDt/AlXGuaaprSETu8ly0+HvhYxzlvItVzfJY8FpbpygrmAOh7gDQFtKfukJ+7Z/WpkBrQG6YlRGVeka4x3kmiQ3HA/8ZCNBuXNLTYtvLIkbb42bYVfJrEeYPC4tos48XtRnQdeLyVV6Z7ITWRDWUL24hG8MhrDLlcQk0oKKnsYxRxltqeU4xQq4WM2t9O9Qa+TA8KLGdKATvnLkJk3Sp9xtQNg/rDyUx3gK5RIeg9MNmqy5TQuaQcxRbt+gvk07DF+FGMez8V0Vs+9azAiXhIA+b0bn72IAMd7sOogxtHrgXlquc922buBxkMCXDtRbosGQAG4CzbW5Ajw3gwDr5ubwnGBZeWMzWbdEXJkhpCz4kdzxar7k2l94dufnLZlM9UAk4K5MzqKqsG512jIf7lnNbmWGwYWaZvQ/8Y/4bC7rH2Fy/4QTV49L5BxGsfpUvN3ZGZT9zsmiiKvOx71UdP2jdNEmWVi/16UP7L96OfY9Ap/+lAxs3ulm62iXI4jpxsDw+3Ty3WCcPWM3T4cbR70XQftxMRduBSRoAcqefDt7Wc21weL5/pyEbJwBCIVxytpuUUV79232eDt+buGZe5JihvzdZXkH2j/u19kvnmAjUZuvL4CNOGe8YL0ZO4pTV1hLK1VEDLIuO+LsRr7RTLDAfOkWySL0XIZK9NbMFr68UpuluT/pS9ff9qAZI7ctBPBXdtJqF6sXyqU7qLtBeWlXEhNJrrvooxR1fQIZu8grM332dqiSJZ4oXLUelGfL0h4HMyH41lmsS0JmDE3axsounRsPYIY3DuH+Z6NViqqVd2a/e7YLCTZ+DdhUetRI+O9qh0x3dhbzZlE+paLvFKgkN+iOGWKywRuKzhX0PAUyTc8hOE8gjxMTFJ8M39IJHeAOOjyxsU/jvK24PQMXSpddGfNKCjmtqdbmJH+Be2Vcgj4F0Jw66oCHQ1OtFl1hvqq
 Ol1Kw+6r
 1UDlj/WTrrDIbGUfZSKnqjdFhX/Iw+UI6H3YQR18Bza0N+mLBX+O9eodiWx6wBoY3yPDWWlfEigEKE8qzpbT8s7QbC1Osa63wXufc31sfKFUiwRY64Xb2bYqCDG4LMrZ16SbVVf52JAOO4xiaAICwEF55o9GM4vwiJz5TxDh3gGa7JkxYjiZ2vGVwRzr+l/uC/ZMu4G26oTZLfNGwuVqwH/QXOIkwufwmOxdul6DXiuTKK4cDnTOlvQwi++AFwkGgWkZEJ5m+/pALTM36ciquVk4RNRwoQdeFlhLaJgNiBrWTYbKmybJk39+e3Dou0TLuCRs2pntCzxfjWCj70msP1x6ZKa0oL1s4xHoto/6Hv4mIL20bhTXe1xtkOmAuBI1HAm9gtv5f5ZUpk+MQjrUw9ZMd+A2Ynj5Q9r7WOQpPEM7Av7MdX6cfSNr0UvZT9XjSfdCdauUOye7k4s3bMXlAhAJPQQ6lFBIwA/FGUXcwJboTZCE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 03:46:00PM +0100, Matthew Wilcox wrote:
> On Mon, Jul 20, 2026 at 04:41:41PM +0200, Christoph Hellwig wrote:
> > >   /**
> > >  - * ttm_backup_backup_page() - Backup a page
> > >  + * ttm_backup_backup_folio() - Backup a folio
> > >    * @backup: The struct backup pointer to use.
> > >  - * @page: The page to back up.
> > >  - * @writeback: Whether to perform immediate writeback of the page.
> > >  + * @folio: The folio to back up.
> > >  + * @order: The allocation order of @folio.  Since TTM allocates higher-order
> > >  + *         pages without __GFP_COMP, folio_nr_pages(@folio) would always
> > >  + *         return 1; the caller must pass the true order explicitly.
> 
> Wait, what?  This is just broken.  TTM should change to allocate using
> GFP_COMP.  Why can't graphics people ask questions before writing stupid
> patches?
> 

To be honest, I have no idea why TTM doesn't set GFP_COMP. This
predates my work in graphics by nearly a decade.

I found the following comment in TTM, which was added in this patch:
`git format-patch -1 bf9eee249ac20`

As far as I can tell, setting GFP_COMP would make things a lot easier in
a number of places.

Christian, who maintains TTM, is out for a couple of weeks, but this is
something we should probably take a closer look at.

Sorry for sending a stupid patch.

Matt

