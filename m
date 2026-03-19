Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E0841075289
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 10:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AC846B045C; Thu, 19 Mar 2026 06:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864E46B045F; Thu, 19 Mar 2026 06:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC756B045C; Thu, 19 Mar 2026 06:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5097E6B045C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:08:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F31FA58F70
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:08:58 +0000 (UTC)
X-FDA: 84562389156.02.19F84DC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf19.hostedemail.com (Postfix) with ESMTP id F31781A0014
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:08:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=V4xRk145;
	spf=pass (imf19.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773914935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAfwytN6zfojsfdMb+cmKPOYV3MqwH/fCf8oYhlfx5U=;
	b=1r4eoqucvobdquRw40txT/u7nUTuocH1paGQPJ+LL18uZcITIUTC0MVlzpm2qZGNEM/lJl
	pqJCzH/wmH23QhUcmMPYNbilW+Cnktf7g6YBvBAlc3xr07cZ/kPxxWdgaUn+F9/YzTtR4M
	qzD8TfzFydxIROFYjM5OftYk7EwkPUc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=V4xRk145;
	spf=pass (imf19.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773914935; a=rsa-sha256;
	cv=fail;
	b=jzxngt5vbFiFGJkPAz6IljOlEdwy6Q5lqx8w/deGF2L7inhchHIRqz5BNUCB7Wh0pETif5
	aL8i3x6xn1WIFDxtOZDtKao7z9021M+cUu9DAyMOY8Sqp20137LvwJ3X1cOI43aFdNJVfl
	cq4WY01SUrB5gfDVX0PwQHnGX5XLKT8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773914934; x=1805450934;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uoGmtK6qXdqoqzuBobZGJJW7Ed/FzUrKS2tC8/MKfOQ=;
  b=V4xRk145HDDE52A5Yu9edibDHEDdyeQw2x6OrLR8wFtaCFqkePP6G0Ev
   2iqtzrB8rKUAP5XFuP+hADndw6Z7/sJ9DtlY1qCtpB6E+iP2Gsq5ADvJ3
   CVZKnoRgN+Gbl/KHgoYGuIV3jyZK/6UwTbsSwfgj3ixYTQUDM9QGp1EWz
   Hxn/ewqVGuq08PpcZHGbQUxTaUW8uysMWwQp+6oEUQ5uGMPoLV3bB4Ok5
   ccpoeQMhdx+dIUeIzrox3pqxykRDW/cOWwT5rVtMJTsEI+sspWmj3Blx1
   WBaSEh4B4KpE2SNm65mRz6/ApFirotiOJb+e4MAbpepTIsmd/AQ1KfWHl
   Q==;
X-CSE-ConnectionGUID: IOWEglSURY6PdQ0a2KKUlA==
X-CSE-MsgGUID: aVPIAisOSvCPx5tITJqlkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="75058066"
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="75058066"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 03:08:53 -0700
X-CSE-ConnectionGUID: 5TtGVze5RyeYJ3AdTvwJYw==
X-CSE-MsgGUID: cqmykxD+Rk+2PwJ0UMQ6OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="224930837"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 03:08:53 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 03:08:53 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 19 Mar 2026 03:08:53 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.16) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 03:08:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=adihm7CLx5bTl7wTu6QhqTMfA3TeU1olRnSNCX9HHu3t3bfCzOvwhom8moYvUQjH/zPwnjqgZLqB69IXp5PMCmUe1uX7e4sKHE+8zFP5Lx8pi172C3BSFyKQUtTsZVHOpY+ZC/wu+atahn786np4lwoiOB2Mgd9M4Sr9HOmRtMc4uYLaxqWx2pHMsem15DEb+MO2+lBef2w0YdaIymsT3tIP8iYYCM4PE9LQ8NEQG+QFuwTAm/nm1O9hsm9AI8RIjpm1qhJb8u7TZ/ymzbqfoPksFdEJ1ESX/xTUQ2D22F/4oEUM5TamTj1LQzznCaY0HoWZYXUYHDpDQFXilHLM7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAfwytN6zfojsfdMb+cmKPOYV3MqwH/fCf8oYhlfx5U=;
 b=fZOeyvFtsCiCvOS1G6SkuMBl5bcsRMybbl1aTpddxBPwlrZKe20l17Tpr/tHIsBX68nZtphvqSjt8DjDQTIe7dNOHt6DD0WEh0G9jFbj/B7E9DzK5XXLq17Qbbru4MGsM20O/mZ5gLxseUHgTURd62IaJS7h6pPYvmDbtNynGhIHcZiOW+ZH26CKSP5i2ZIXgItoVJPPr5uTsW6NwkcV2QTiOQk65/vaQXACa/v7Iy3FeOJuwBLJA6nuhazLQQFnE1oMz2qCCQ8JPncLLursj2Qt/519ikXETsLLO+xkw2e1kw6xbLOilfhMCG/jqeQx2ObeyUT7783G+y8SauJFGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA4PR11MB9009.namprd11.prod.outlook.com (2603:10b6:208:56f::21)
 by SN7PR11MB7090.namprd11.prod.outlook.com (2603:10b6:806:299::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Thu, 19 Mar
 2026 10:08:47 +0000
Received: from IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541]) by IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541%7]) with mapi id 15.20.9745.007; Thu, 19 Mar 2026
 10:08:46 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, "Chen
 Zhang" <zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHct4abryaKSRoUW0qNNchDaIVkzLW1oBJg
Date: Thu, 19 Mar 2026 10:08:46 +0000
Message-ID: <IA4PR11MB90098E3689ED637C9B8F10D1A34FA@IA4PR11MB9009.namprd11.prod.outlook.com>
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
In-Reply-To: <20260319095622.1130380-1-yuan1.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA4PR11MB9009:EE_|SN7PR11MB7090:EE_
x-ms-office365-filtering-correlation-id: 45a0fbff-03cc-4675-ea3c-08de859f8247
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|22082099003|56012099003|18002099003;
x-microsoft-antispam-message-info: JIyZWX8sM6S8uWhrBORj5ZW+qv+SYwMb5n+nz1YxFwuAUQE1C4V/CuSHoQo4vnKAHJWrdho7qiBOlQiS+Z9Kld/rfNaLuTpftMbXM/WKINLMdb03uIrDcqF75a08+DubyfKYopUqT11MA8uIZQSToVTyFDgabpueIpNKjLPm576LNKJcPiHpwSrW+tNAghMUYlSpxMFubYRHNZXbAcs/livTI4NgXpmsrJ0qi0UbwmLPlk3MOU+OV7WWlPV1i1o0I7rjlhvQ2VxvLnrMKvDeeZlLVxNxiyr5njJHvTLxFyDp5Cjrbt9UX0jY6JGitT16QO02Tf7PuCzoX9fJ+7Xruk8Gk4tUSqPjGSMZqR/gP7KDt9FGXHNwekrPYc+J0fB6UdWj0kPANcLtH9vM8bmPCIxc6ADi1M81SzezNy5is+QX2eb+umxEAw5L7CC6yBxjtp8IvJlnsD+qhZ8kHc+SmbvK//KDPpQz0SKdeGNfSghCnxePJG7y5bnHs12DCwf8mQ/TXVM2SEfiYDfl+O60UrpQlacVY6ERRwVEjOG7bz40vdUM+ogSvkSs3Sa9QYSgYFrgc7SLwpqnsLAfyuf96aExpupM/7D5WOBTKCPHV0cCSIs2qAZLAntZRvOk6FcJoPPis+GAvw/rrzxjVCKnTzTRfVMw9o6ahn156u7gm4icOZFZDV0kwfJ/2Qg3pyJ2RmvLeHrtKfIAYTalg+MlVCqEfzU3B5qM3SrLaXg4c5TL+Z0tdQwNJvY8O7WjTRubeyrb8AH/ch2g85iRxavFQ7D5R0XkFdAQMYaxz90sIAo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9009.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?stJN0d/xQdHtcb4GLCsIyKU1LjFWP7XcYt2+zV6nJ8PNDHnL8nFP8gYz5cpR?=
 =?us-ascii?Q?cDfUTkCtu/Hvy/Wl5pAh6zCBxo8VQQ9yrReiXprx75FcmcKt1ASBHO+IH8XF?=
 =?us-ascii?Q?SKQQE9oMOYQrTvsvwnae+M5y0SYcDJclGoo6SUFWaLw7IcRSygCdmTmC2Osu?=
 =?us-ascii?Q?d6e0Y17aQAgOLWZOWbjNDT8zA6ur5W/3Iq2Yy+4DFADpLI8q3GKiICJ5B3Cn?=
 =?us-ascii?Q?v1lze7tFk1SaaYUIEfdmL1nratHi+EdSCHo6RycE2lbqdHpVb9M7yYveZub3?=
 =?us-ascii?Q?adJ+ggJ7EhttNP3kvAykt69Mua4Z7mTNcxzfKH0YcVoxwMPARvLzt6WgAZLv?=
 =?us-ascii?Q?8jW4/zrLum9XK/XexLE1nvNkFdVnBjE9rdgxc3shw2IqzeBeNAA0F0F2hOOO?=
 =?us-ascii?Q?PP8jtlZGhT0+hgDbSz0uheNLJ6TXjY8GSrh7IhYn5MtumNfyWmf9cA1LU6xv?=
 =?us-ascii?Q?8sjhFo58oj+9KHPigz8oxEazdvTgMC2sZsIhbRb85sTd7Pagf9J/AGojWF+4?=
 =?us-ascii?Q?3qxtKghYFgrIjpZBvdGzp7LM8feFE/hRfFG9fY1Hh+p/auwGsd1XrLDVRYEX?=
 =?us-ascii?Q?6YAv+w0IR+2TjGKf9RYOPaR1T2LhV7zVVTbO/CTrLlG6glX2DWteree9YypH?=
 =?us-ascii?Q?g5vcLLGat8gDe2MPYSMfYbg6tNE7jex/YLWiuf5QFrGke2I+he89nGfMlnci?=
 =?us-ascii?Q?wS7t9ZgbuRMiXKpZYBaH8gXiKO3pHinNvxGSA/IRvOrnGmgKKLJ3x1ksXyln?=
 =?us-ascii?Q?ppAgiIpAL4rj4uYKOUeysRQZM/9/G2yrpfGu+9cVPJZ4mPe7lhQAhQm4RlGo?=
 =?us-ascii?Q?hAyV3DxS+dJMqsGXNxmLSINi6E8oOs5op333lcFUnR4PxIoA2MW8g8LsGy3m?=
 =?us-ascii?Q?9P+hthl+rf6kkGiyOU0VYe1ZsByTbEITJy9b5olLWsaGe5lPW13LdELi6VrY?=
 =?us-ascii?Q?7iPthfe+6ATBkx4RkZiiw9Hih6HC7l8G/z6RitjOWvJcO9j32L/AimRgUbrF?=
 =?us-ascii?Q?RaPMomhkvAUp1KQ6D2+XsD891aKib2Zz7OquryEu64ot/IeglZMqsFMuLldW?=
 =?us-ascii?Q?gk0Hua4k4ir/w5g/1yz6X8eshVz1VbtjzyHEuQOnQ8qXZ/M0NojqbnoXLq5w?=
 =?us-ascii?Q?rCzQHoUc2/XT4AdTpMMKD6nRJDrnQAqeCbCuzxInyN+Xd3ea/L51ODqPgLGd?=
 =?us-ascii?Q?ikKoBM+72J26GMxq8MzbExzkBIKyIZoyI3O/BGWdnYMUmsX7+/1liQzRTjzI?=
 =?us-ascii?Q?ANkIdLJznl97mXWaewMi4mJqbTGWu+K5h/JGMb0OiLZ8vC2bN9tCK1GfFwMh?=
 =?us-ascii?Q?R0zVHGxCPUAXUL/IkyQ55G2vEWpuLOZlVCs3Pk36WdOw9nXpzsbA1D5Q8qm9?=
 =?us-ascii?Q?wkJuR5w5EdgdNGCfeDbNe02lD9JvZrsfbEOoK42hWIovilAUR0nJm1MQwUzq?=
 =?us-ascii?Q?RIDrWv2wotUJLs2s+r0CuutkWVHFYy8k4lzSGrVD1nxAIJjtclvZKzjJ0Tce?=
 =?us-ascii?Q?r2QnvlXbj6AXQoV9p9/Qy9cugPXszg6trOEEhc0bScP5/PtZvqr7FSax3S7F?=
 =?us-ascii?Q?5yTuh/VTbsPRsSRb6GWx4wj3PDxtjvpuEAEgg96yfdDefizSOrI0OUiZJKR2?=
 =?us-ascii?Q?qaBHUkmRbjBWwluPG4QsZ0pdFS9O4Q0Q1G526ecAz5xQmn1B4ua1lOPey2BI?=
 =?us-ascii?Q?+N+i1O9z6ymtsmDp1L3tfAwmBL0sjPzdMRYQVTUXe1GjYywN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: czQopFfua6lesK+FdEr7MjNEjrpt/U+YldCRUYoWZwqk/AQcFxEheZ9tabRg4gdKXu7P5wrOMvRS6Ks8FTrx8G7aQ1XcAfNWHMYhrnBwzGGMKJAyD2NOMLbgqGA87RLD5upqc53YLxCp4lSb+bTQT7Yjq0fnnpF8rxZ0bxLiS81Fq6yPEyT/LySGW0crxs+A2QtVQDdibm5WWeGNrVgsyZ21ElCJX+i73Putr2T+H2lL+53BSM/+2h+4A/6relTUPdBEa4DD56DuImG9z6UkOWkVu8xqABytBaxRBcmavDDXCy6BpWyK3RHI9FYKLdvccBVtriDSj12fjRxM9yheWA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9009.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45a0fbff-03cc-4675-ea3c-08de859f8247
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2026 10:08:46.5086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wt0RDAOofZdtw/OVIM1PUe/WNlmebeBzzt6pxCA0XeX9h9kiSAcLwSb1ZSHBE6ARkIDSJJ4r3IOWhBgcaXRBLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7090
X-OriginatorOrg: intel.com
X-Stat-Signature: 7skqdfwz5f9a7ckius9qz5xcnk8hn9j6
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: F31781A0014
X-HE-Tag: 1773914934-117542
X-HE-Meta: U2FsdGVkX18rSbDr7zCnWmD0r4qnRV6waQsqP9UkSSINq5WBeclS3DCZjbLMiFzakswIc/VeQy/BXBo3CWnRYdKse2j3o9FW58myXZ39MsdEecZaeQ7ck2bNk5Dv0LgwYquQa5C46EK12Hwwu1zaGtn+PimS6TWfGDJtWOySyCveT3W7yeZemTr6jeS42PLRM8+MLpFDNtvakAcnQrAxuBR+PUTFbtcOM6gFyjUICsl88CAbpiC6BEb8AoDS0M7mnNN2BmooaAB2RTalDOg+5FA/vPYsf6zpZ55k2j+hMC4ISfwGS+G/EmSjaiXcSwEMnkOW4zwuiN91rOrNS0+6LoLebUB1uPU8Qsfqvl71/FU89hQUdHDUHdgUxrT8KG4olowtaYv4eo27OZnIvnhT7wlTO2JeHfYMi9+UkrCGSImIQHm2xTI4znSIO1nXggwkbG/z4VJ0mSdYgi0L8xzAmqRciSQZ8T7hVl/E2Adr6WSH+/Y3aJbUT+TXqaZkFmLz9RDL+/egWqR2vGzVR/IbWC06uy6tBSaLkfZ0EeOvtimar/0Zrxhif7ps+sjq91KovND7FDgM0AThYCDWBZJSxRtM0+AwuFYKPtp+G24v2mgYLeJBp3GxLxseOPXz5Ir/Zko13dOYxU9vFMXyWCn82Dw95vh1deg8QeO0JgPCMCahwCVLuvwJF23t+zf2KMjyh3CMyHQERUKW2jm8hnascy2t/cibWvb9LPir+p8eC4e/8SOStfil2Y9ncXDY1C9MuW2Imbp+dsM8uMQwwZUrfK+inUC38UUwJfN8xzQKRrJqv5GlHTN/1ZlsQWp3FZWlQye6HHUfWGwOvSA2E8WQqAzvYZA9Mer6B9xRhj0yzFp8CdqbxrFHvamoxF4Z8DSiA3lef9UMgHE2i/nBUGKkfMwjSz7zMvPRalOwxtsPobalyKtRnv70Rkrn+Dd8tXbza3RJQt5XGmL6ijDsA/F
 nYlDPF6w
 4YeuY0pVr4yf5vvgPK6h0WQIJIkAg1eME+R0AkKA5q8M3UQoveyqvfikcL28olvPBLEsOwDaNfh3+i9WuKXDxj/KO38r7zVWuC1oeXhHMegFlBLePhGUcn6Oppu/kw+ba2ZRrySVVWlGZovujJ0/6ImV8De+V0+0Ezm8FuJiSyhr4bBKRPmFJ87uNOL+OxhIA+tiKk26/gqxyNZhr8ACuaq83eAVohGf74EzPWWbCYJrh4nHELEvzEUr0dVkxfZO2C9HKl5V66gQKWusDF6XS1JMsLa0qNaiCnu4a3GYHYBM5ksjgnGYtEN9/mD/kTIXarCOK2/Z5LaoPBMtLzvtHWyUXzYZo0tQatqkqcedTsXfkcONGMxvlxeGHNWfNSoXPgo748eFmbriz/QeKrte9oQEH6Ysr4wJxh9c/IFygKqev9khYi28rTEEt0BEBCKW4uFRup+cTFcehqL1uSqp7gMWWCeTfNillDyCXEwD1REI1z+eXkg9m4Ij27TsKb17JCIzm3aWUY99aSC13zssuGVMbvQSIyMM3Wk4BTDgW4k6ZshKt8ybXSMPZtMYu7w29C66Gg5LOOtOt/zb7NZAkroyqo0wy//1SRIHBnAJGSbqhx3N8BK8KYuY8MdBYfjEUAuglkkm8wh7NiCwRGzSbHuEfU5353JI5eLpNzKHOwwLCD3bLZg51+V/AaEAPbL++fap32mafcBjQ22IgIdi03A1gz3qBTDL9wef8pAH2rMWRviCCSITFnfvNlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David & Mike

I merged this patch into v6.19-rc8 for validation and observed that unplugg=
ing 256 GB takes 3 seconds, while unplugging 512 GB takes 7 seconds. I beli=
eve this performance regression in memory unplug is not caused by this patc=
h.

Best Regards,
Liu, Yuan1

> -----Original Message-----
> From: Liu, Yuan1 <yuan1.liu@intel.com>
> Sent: Thursday, March 19, 2026 5:56 PM
> To: David Hildenbrand <david@kernel.org>; Oscar Salvador
> <osalvador@suse.de>; Mike Rapoport <rppt@kernel.org>; Wei Yang
> <richard.weiyang@gmail.com>
> Cc: linux-mm@kvack.org; Hu, Yong <yong.hu@intel.com>; Zou, Nanhai
> <nanhai.zou@intel.com>; Liu, Yuan1 <yuan1.liu@intel.com>; Tim Chen
> <tim.c.chen@linux.intel.com>; Zhuo, Qiuxu <qiuxu.zhuo@intel.com>; Chen, Y=
u
> C <yu.c.chen@intel.com>; Deng, Pan <pan.deng@intel.com>; Li, Tianyou
> <tianyou.li@intel.com>; Chen Zhang <zhangchen.kidd@jd.com>; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
> when changing pfn range
>=20
> When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it will
> update the zone->contiguous by checking the new zone's pfn range from the
> beginning to the end, regardless the previous state of the old zone. When
> the zone's pfn range is large, the cost of traversing the pfn range to
> update the zone->contiguous could be significant.
>=20
> Add a new zone's pages_with_memmap member, it is pages within the zone
> that
> have an online memmap. It includes present pages and memory holes that
> have
> a memmap. When spanned_pages =3D=3D pages_with_online_memmap, pfn_to_page=
()
> can
> be performed without further checks on any pfn within the zone span.
>=20
> The following test cases of memory hotplug for a VM [1], tested in the
> environment [2], show that this optimization can significantly reduce the
> memory hotplug time [3].
>=20
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Plug Memory    | 256G |      10s      |      3s      |       70%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      36s      |      7s      |       81%      |
> +----------------+------+---------------+--------------+----------------+
>=20
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Unplug Memory  | 256G |      11s      |      4s      |       64%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      36s      |      9s      |       75%      |
> +----------------+------+---------------+--------------+----------------+
>=20
> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>     object_add memory-backend-ram,id=3Dhotmem0,size=3D256G/512G,share=3Do=
n
>     device_add virtio-mem-pci,id=3Dvmem1,memdev=3Dhotmem0,bus=3Dport1
>     qom-set vmem1 requested-size 256G/512G (Plug Memory)
>     qom-set vmem1 requested-size 0G (Unplug Memory)
>=20
> [2] Hardware     : Intel Icelake server
>     Guest Kernel : v7.0-rc4
>     Qemu         : v9.0.0
>=20
>     Launch VM    :
>     qemu-system-x86_64 -accel kvm -cpu host \
>     -drive file=3D./Centos10_cloud.qcow2,format=3Dqcow2,if=3Dvirtio \
>     -drive file=3D./seed.img,format=3Draw,if=3Dvirtio \
>     -smp 3,cores=3D3,threads=3D1,sockets=3D1,maxcpus=3D3 \
>     -m 2G,slots=3D10,maxmem=3D2052472M \
>     -device pcie-root-port,id=3Dport1,bus=3Dpcie.0,slot=3D1,multifunction=
=3Don \
>     -device pcie-root-port,id=3Dport2,bus=3Dpcie.0,slot=3D2 \
>     -nographic -machine q35 \
>     -nic user,hostfwd=3Dtcp::3000-:22
>=20
>     Guest kernel auto-onlines newly added memory blocks:
>     echo online > /sys/devices/system/memory/auto_online_blocks
>=20
> [3] The time from typing the QEMU commands in [1] to when the output of
>     'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>     memory is recognized.
>=20
> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
> Tested-by: Yuan Liu <yuan1.liu@intel.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
> Reviewed-by: Pan Deng <pan.deng@intel.com>
> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
> Co-developed-by: Tianyou Li <tianyou.li@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> ---
>  Documentation/mm/physical_memory.rst |  6 +++++
>  include/linux/mmzone.h               | 22 ++++++++++++++-
>  mm/internal.h                        | 10 +++----
>  mm/memory_hotplug.c                  | 21 +++++----------
>  mm/mm_init.c                         | 40 +++++++++-------------------
>  5 files changed, 50 insertions(+), 49 deletions(-)
>=20
> diff --git a/Documentation/mm/physical_memory.rst
> b/Documentation/mm/physical_memory.rst
> index b76183545e5b..d324da29ac11 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -483,6 +483,12 @@ General
>    ``present_pages`` should use ``get_online_mems()`` to get a stable
> value. It
>    is initialized by ``calculate_node_totalpages()``.
>=20
> +``pages_with_online_memmap``
> +  The pages_with_online_memmap is pages within the zone that have an
> online
> +  memmap. It includes present pages and memory holes that have a memmap.
> When
> +  spanned_pages =3D=3D pages_with_online_memmap, pfn_to_page() can be
> performed
> +  without further checks on any pfn within the zone span.
> +
>  ``present_early_pages``
>    The present pages existing within the zone located on memory available
> since
>    early boot, excluding hotplugged memory. Defined only when
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 3e51190a55e4..c7a136ce55c7 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -943,6 +943,11 @@ struct zone {
>  	 * cma pages is present pages that are assigned for CMA use
>  	 * (MIGRATE_CMA).
>  	 *
> +	 * pages_with_online_memmap is pages within the zone that have an
> online
> +	 * memmap. It includes present pages and memory holes that have a
> memmap.
> +	 * When spanned_pages =3D=3D pages_with_online_memmap, pfn_to_page() ca=
n
> be
> +	 * performed without further checks on any pfn within the zone span.
> +	 *
>  	 * So present_pages may be used by memory hotplug or memory power
>  	 * management logic to figure out unmanaged pages by checking
>  	 * (present_pages - managed_pages). And managed_pages should be used
> @@ -967,6 +972,7 @@ struct zone {
>  	atomic_long_t		managed_pages;
>  	unsigned long		spanned_pages;
>  	unsigned long		present_pages;
> +	unsigned long		pages_with_online_memmap;
>  #if defined(CONFIG_MEMORY_HOTPLUG)
>  	unsigned long		present_early_pages;
>  #endif
> @@ -1051,7 +1057,6 @@ struct zone {
>  	bool			compact_blockskip_flush;
>  #endif
>=20
> -	bool			contiguous;
>=20
>  	CACHELINE_PADDING(_pad3_);
>  	/* Zone statistics */
> @@ -1124,6 +1129,21 @@ static inline bool zone_spans_pfn(const struct zon=
e
> *zone, unsigned long pfn)
>  	return zone->zone_start_pfn <=3D pfn && pfn < zone_end_pfn(zone);
>  }
>=20
> +/**
> + * zone_is_contiguous - test whether a zone is contiguous
> + * @zone: the zone to test.
> + *
> + * In a contiguous zone, it is valid to call pfn_to_page() on any pfn in
> the
> + * spanned zone without requiring pfn_valid() or pfn_to_online_page()
> checks.
> + *
> + * Returns: true if contiguous, otherwise false.
> + */
> +static inline bool zone_is_contiguous(const struct zone *zone)
> +{
> +	return READ_ONCE(zone->spanned_pages) =3D=3D
> +		READ_ONCE(zone->pages_with_online_memmap);
> +}
> +
>  static inline bool zone_is_initialized(const struct zone *zone)
>  {
>  	return zone->initialized;
> diff --git a/mm/internal.h b/mm/internal.h
> index cb0af847d7d9..7c4c8ab68bde 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -793,21 +793,17 @@ extern struct page *__pageblock_pfn_to_page(unsigne=
d
> long start_pfn,
>  static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn=
,
>  				unsigned long end_pfn, struct zone *zone)
>  {
> -	if (zone->contiguous)
> +	if (zone_is_contiguous(zone) && zone_spans_pfn(zone, start_pfn)) {
> +		VM_BUG_ON(end_pfn > zone_end_pfn(zone));
>  		return pfn_to_page(start_pfn);
> +	}
>=20
>  	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>  }
>=20
> -void set_zone_contiguous(struct zone *zone);
>  bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>  			   unsigned long nr_pages);
>=20
> -static inline void clear_zone_contiguous(struct zone *zone)
> -{
> -	zone->contiguous =3D false;
> -}
> -
>  extern int __isolate_free_page(struct page *page, unsigned int order);
>  extern void __putback_isolated_page(struct page *page, unsigned int
> order,
>  				    int mt);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index bc805029da51..2ba7a394a64b 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -492,11 +492,11 @@ static void shrink_zone_span(struct zone *zone,
> unsigned long start_pfn,
>  		pfn =3D find_smallest_section_pfn(nid, zone, end_pfn,
>  						zone_end_pfn(zone));
>  		if (pfn) {
> -			zone->spanned_pages =3D zone_end_pfn(zone) - pfn;
> +			WRITE_ONCE(zone->spanned_pages, zone_end_pfn(zone) -
> pfn);
>  			zone->zone_start_pfn =3D pfn;
>  		} else {
>  			zone->zone_start_pfn =3D 0;
> -			zone->spanned_pages =3D 0;
> +			WRITE_ONCE(zone->spanned_pages, 0);
>  		}
>  	} else if (zone_end_pfn(zone) =3D=3D end_pfn) {
>  		/*
> @@ -508,10 +508,10 @@ static void shrink_zone_span(struct zone *zone,
> unsigned long start_pfn,
>  		pfn =3D find_biggest_section_pfn(nid, zone, zone-
> >zone_start_pfn,
>  					       start_pfn);
>  		if (pfn)
> -			zone->spanned_pages =3D pfn - zone->zone_start_pfn + 1;
> +			WRITE_ONCE(zone->spanned_pages, pfn - zone-
> >zone_start_pfn + 1);
>  		else {
>  			zone->zone_start_pfn =3D 0;
> -			zone->spanned_pages =3D 0;
> +			WRITE_ONCE(zone->spanned_pages, 0);
>  		}
>  	}
>  }
> @@ -565,18 +565,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
>=20
>  	/*
>  	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
> -	 * we will not try to shrink the zones - which is okay as
> -	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
> +	 * we will not try to shrink the zones.
>  	 */
>  	if (zone_is_zone_device(zone))
>  		return;
>=20
> -	clear_zone_contiguous(zone);
> -
>  	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>  	update_pgdat_span(pgdat);
> -
> -	set_zone_contiguous(zone);
>  }
>=20
>  /**
> @@ -753,8 +748,6 @@ void move_pfn_range_to_zone(struct zone *zone,
> unsigned long start_pfn,
>  	struct pglist_data *pgdat =3D zone->zone_pgdat;
>  	int nid =3D pgdat->node_id;
>=20
> -	clear_zone_contiguous(zone);
> -
>  	if (zone_is_empty(zone))
>  		init_currently_empty_zone(zone, start_pfn, nr_pages);
>  	resize_zone_range(zone, start_pfn, nr_pages);
> @@ -782,8 +775,6 @@ void move_pfn_range_to_zone(struct zone *zone,
> unsigned long start_pfn,
>  	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>  			 MEMINIT_HOTPLUG, altmap, migratetype,
>  			 isolate_pageblock);
> -
> -	set_zone_contiguous(zone);
>  }
>=20
>  struct auto_movable_stats {
> @@ -1079,6 +1070,8 @@ void adjust_present_page_count(struct page *page,
> struct memory_group *group,
>  	if (early_section(__pfn_to_section(page_to_pfn(page))))
>  		zone->present_early_pages +=3D nr_pages;
>  	zone->present_pages +=3D nr_pages;
> +	WRITE_ONCE(zone->pages_with_online_memmap,
> +		READ_ONCE(zone->pages_with_online_memmap) + nr_pages);
>  	zone->zone_pgdat->node_present_pages +=3D nr_pages;
>=20
>  	if (group && movable)
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index df34797691bd..96690e550024 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -946,6 +946,7 @@ static void __init memmap_init_zone_range(struct zone
> *zone,
>  	unsigned long zone_start_pfn =3D zone->zone_start_pfn;
>  	unsigned long zone_end_pfn =3D zone_start_pfn + zone->spanned_pages;
>  	int nid =3D zone_to_nid(zone), zone_id =3D zone_idx(zone);
> +	unsigned long zone_hole_start, zone_hole_end;
>=20
>  	start_pfn =3D clamp(start_pfn, zone_start_pfn, zone_end_pfn);
>  	end_pfn =3D clamp(end_pfn, zone_start_pfn, zone_end_pfn);
> @@ -957,8 +958,19 @@ static void __init memmap_init_zone_range(struct zon=
e
> *zone,
>  			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>  			  false);
>=20
> -	if (*hole_pfn < start_pfn)
> +	WRITE_ONCE(zone->pages_with_online_memmap,
> +		   READ_ONCE(zone->pages_with_online_memmap) +
> +		   (end_pfn - start_pfn));
> +
> +	if (*hole_pfn < start_pfn) {
>  		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> +		zone_hole_start =3D clamp(*hole_pfn, zone_start_pfn,
> zone_end_pfn);
> +		zone_hole_end =3D clamp(start_pfn, zone_start_pfn,
> zone_end_pfn);
> +		if (zone_hole_start < zone_hole_end)
> +			WRITE_ONCE(zone->pages_with_online_memmap,
> +				   READ_ONCE(zone->pages_with_online_memmap) +
> +				   (zone_hole_end - zone_hole_start));
> +	}
>=20
>  	*hole_pfn =3D end_pfn;
>  }
> @@ -2261,28 +2273,6 @@ void __init init_cma_pageblock(struct page *page)
>  }
>  #endif
>=20
> -void set_zone_contiguous(struct zone *zone)
> -{
> -	unsigned long block_start_pfn =3D zone->zone_start_pfn;
> -	unsigned long block_end_pfn;
> -
> -	block_end_pfn =3D pageblock_end_pfn(block_start_pfn);
> -	for (; block_start_pfn < zone_end_pfn(zone);
> -			block_start_pfn =3D block_end_pfn,
> -			 block_end_pfn +=3D pageblock_nr_pages) {
> -
> -		block_end_pfn =3D min(block_end_pfn, zone_end_pfn(zone));
> -
> -		if (!__pageblock_pfn_to_page(block_start_pfn,
> -					     block_end_pfn, zone))
> -			return;
> -		cond_resched();
> -	}
> -
> -	/* We confirm that there is no hole */
> -	zone->contiguous =3D true;
> -}
> -
>  /*
>   * Check if a PFN range intersects multiple zones on one or more
>   * NUMA nodes. Specify the @nid argument if it is known that this
> @@ -2311,7 +2301,6 @@ bool pfn_range_intersects_zones(int nid, unsigned
> long start_pfn,
>  static void __init mem_init_print_info(void);
>  void __init page_alloc_init_late(void)
>  {
> -	struct zone *zone;
>  	int nid;
>=20
>  #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
> @@ -2345,9 +2334,6 @@ void __init page_alloc_init_late(void)
>  	for_each_node_state(nid, N_MEMORY)
>  		shuffle_free_memory(NODE_DATA(nid));
>=20
> -	for_each_populated_zone(zone)
> -		set_zone_contiguous(zone);
> -
>  	/* Initialize page ext after all struct pages are initialized. */
>  	if (deferred_struct_pages)
>  		page_ext_init();
> --
> 2.47.3


