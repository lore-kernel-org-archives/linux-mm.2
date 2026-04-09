Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B738E98FA5
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 03:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95D726B0005; Wed,  8 Apr 2026 23:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E5F6B0088; Wed,  8 Apr 2026 23:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D53C6B008A; Wed,  8 Apr 2026 23:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 695E46B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:20:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2896EE0C20
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:20:35 +0000 (UTC)
X-FDA: 84637564830.04.9F3EBA1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9D096140002
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:20:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Owwup3fD;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775704831; a=rsa-sha256;
	cv=fail;
	b=egQhE5nGOHtyovGmCjbSoSNEDTP1rFaHhskC2/eRU2dkNDucNkzBVRhpNOrQpCv9HpoaiA
	Ij91lco+gL+RBXnM1hx2TuSlTqVNtb8Oub4D4vzUyirIKAvPSrFZDlKNaMuj5oyL3DJ6l6
	Zzs8VyeyAIOZyEcL0I6Km1D/rifzE2s=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Owwup3fD;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775704831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H8638BwiEFYX3GGnoaLtJJyoNr7pj4IDUPGZ188ZSFM=;
	b=yyJiQWsbEn85UxxkpyxxGUKenxudSzf9lJkmcSWXhvIDD9h6Xi2VIrOzaYzBHNBW9TQew+
	OrHROGo+XvXbCUOSnd53PcIY1twW8x8/2Ld8YDJg67d/e5MqR6FJyP0m7SBT+J+cLQyuPn
	J5d0ioHd7Z/Dw31OR0m+zSh0PEYepkk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775704831; x=1807240831;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HBqC52PYr9wFx3L00/rRRKXSnuV3PlMC2xa8/g6sHXo=;
  b=Owwup3fDvSX4IbMSce4PPzuDqxoGroZv8FxlQDokIRIv1FoqYxZgVKEN
   mcv1tmnd6YnA4N6HRd+qYmlobKFvQNUNazHcG8rX+GuTPONi5ZV1cZ+IQ
   uHgk6AOOkkGOF3sYhLzk3oJlvLyKGQluMyoDISsHuSa5sNTg0VokzsEAK
   lxAKCseebQCnIyeGsPc/LZi7hC+DH8L/Et0Aam/rpNQCuONxYS+GCRy98
   Ac6fv4qq8RE8H/79L7DzG+3fgGjah6qiesPG1tn5/mUG9OOPDa8ZWwGkV
   vm3M0Lh3MuaO48uLXsu3WcwqQkkaPeVk0wUago7cLWYRKmeXGVYB7NZrs
   Q==;
X-CSE-ConnectionGUID: qT94N45wTuu++s+IVN0CZA==
X-CSE-MsgGUID: JSaArVj6Q121HD7kSaaMYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11753"; a="79291953"
X-IronPort-AV: E=Sophos;i="6.23,168,1770624000"; 
   d="scan'208";a="79291953"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 20:20:29 -0700
X-CSE-ConnectionGUID: 9AYEKBYLTTe1W+oQxHpWNw==
X-CSE-MsgGUID: COCLNCCCSCy4xKYR59QeIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,168,1770624000"; 
   d="scan'208";a="233612643"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 20:20:29 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 8 Apr 2026 20:20:28 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 8 Apr 2026 20:20:28 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.5) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 8 Apr 2026 20:20:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JRfqL2n5wHRyF3gYxgAHPulR6RJu5+BsCWUMIOXlTImZHOFUp/i9o+bLjsW2JAgNhJV92ClFhh+IMvlCiHhJEwLqZyGX2i0/E7K47DA6LXIV5bJxskZ2afJiVWyfQbYu5kD//VzRnhjigrxYfIG2lx/rP3Q/sN5noj8RImP36tiDhEJK7gTOkqD8mvla0vI2c9+UyOP+0o8QH6ULnPCassoWiMEBRSRQkpQ7jQJYVyFJh3fKIu0L4szM0oUeUnwgDYC1OJcethiE5ABPFxasSb98f4fz/kcfoRyxnNdOfpnLYvGEjK6PtsPM2oPyy+CigRdlTR5xhJJtt5CEZec1dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8638BwiEFYX3GGnoaLtJJyoNr7pj4IDUPGZ188ZSFM=;
 b=Sm5hQJkKstA3KvY1l5R1LS8uVxHzaxy+EqmpxH50ey3UyBZCXNhrzHGrYjWDiRU7dw3NhqUrSOm88SERoDGssGH2UHcdoEr0iKC8xh99/2zma+Oc1eA2i7PjY/GTwActaKfFrd8r6aMaT6ikAmp83p0o/yjDWOmur/PYBP35b16dnqN3RiSC/p2Y2Dx831lX+Mn+0Lx7F6l8StvxIlGpPk4XKA4v9zAyuosgBPaoIFXyWqkIzDCEJkEvtrOT1wt60uZRFlwQd01y5CwDZUd1dezdTmJDsNMwKPhghxJNYFEl01OFDyL7ypH9QVSy3wsC+4oCNxy28+Qy2X9iOtN1Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by DS0PR11MB7681.namprd11.prod.outlook.com (2603:10b6:8:f0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 9 Apr
 2026 03:20:25 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.20.9769.015; Thu, 9 Apr 2026
 03:20:25 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Sion Ji <sion.ji@samsung.com>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, "Chen
 Zhang" <zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHct4abryaKSRoUW0qNNchDaIVkzLXWJB0AgAAMFqA=
Date: Thu, 9 Apr 2026 03:20:24 +0000
Message-ID: <MW4PR11MB693641052EE649F974F8CD9EA3582@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
	<CGME20260409023553epcas2p2e40d1d79206f0169a765fadcf180b010@epcas2p2.samsung.com>
 <20260409023552.GA2807@AE>
In-Reply-To: <20260409023552.GA2807@AE>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|DS0PR11MB7681:EE_
x-ms-office365-filtering-correlation-id: 95e5c05e-e9af-4ac2-235d-08de95e6f0f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info: vnEswrinrfmtx5ilBgvhnyBLUxD0JTo53Ig+MGRpCK4x07k3Rj9OSvmJbzV1XvzqR6ZjTPVPcBtzqAsknowfh71LZwMtJK2iNOgFit6Y5JKvtpVIzt5/cZDSkIuyWW1dZtfMMBNG1i1uLKe3pOqD63lUYvGZkiSZLKtO7qbiYUhSMGwjdAzWrHQX5dJ1xXs6prCnHay6LQ1wDIA3bpwo0V+f6pdW0wb2y0Zr3zT9tREZhpP2rCeeMw0tUgfb/HHPzup0qGh4QlnTCxHrF/7zbMdVz5PGMJyukl8qbBo1NqoOK3IcWXRqEVp1baaIokT6rk+9lITi0zWrcyhkyo3NMRpUoamk8KFui3cFxxL6SjKrezBOqIokeZrd8q4NRF6MBEYRpxmXEkLWyQU5KgT4j4QSpfBBAjRTZzUqSFPhk7cylx7NiYqVhQZKgCqS1SGtNxFQZlPLzrVp2ynMgRxiaMHvk9b0M+VrALHT5SuHjHn6cUbbVHCZBvqGcGFjyKrpBcReRWaeI/L4gRWYNmOuFEWNJtJCFa5SqgqFjLXH24K76d4pGRKQQUb6vy8flq5qa7IIJrP9F1hc8lqLc5nvV5RPCTJKJ8jpvMi9ue4yljw5DOZgz9Vo2gkZb5kOqtSwNuR03rJbSOXnKjv+y5Je+b6B8DkRXADMLMRC3qnXAFg4wMyM7KaqfY5jyhHwbYCeDY2twxtLkthqQLCOHrOJ3LkVBOA9bhUQc5VCgbc3/O2VqkDoPQEqvQb9ZQR+FejozWbmqAZoVSnlO239uWDoUDoLIV0dM0CY+uZfGXhq3d4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9wUQY7LT1TqNBFyRUMZzOfASefC1g5tnZDwBRXLp2jX3WoHMw+ta1Lqj7CZ7?=
 =?us-ascii?Q?WGvQP3icko9T4yWdM0xXNDEgrYOGzYGqKIs2Pdsn8BWtMO9ixVkUBCoMfaLF?=
 =?us-ascii?Q?kZdCUi1fKty1iCoVGVvBPvNMcZTBFwc0YQMPbBSszyl7Kk5si+C6hY7ygQhn?=
 =?us-ascii?Q?p+P3it9Rjlr8w8n5rq2bnrUuzhIWq9SMzTbzy3cZbo6ZxDFhqtpHOK/cT/Fc?=
 =?us-ascii?Q?LCb/jXjgPN1dirn0wXO29vl/Llbe9BOjRPZvYYNeRwwUeIFSW+RG6BXPaenG?=
 =?us-ascii?Q?Of6tPavFrt+edO43TsS+UyzQf/yiBd777xCRVGaia8+rLVZp5YxKGEHH5VPi?=
 =?us-ascii?Q?uX0gbUp46Ei7DW3xxD9WgAy08SJbiJ+q3d8oRWtJtfGGgl8pYmELuIulaPp1?=
 =?us-ascii?Q?AZaBnlCQTLHCSlefHCkLcTsLKte0xuVe6GtAbQt/TDrYw7LmV0tK6F2va4uB?=
 =?us-ascii?Q?E+c607fDJOAQLxQQ6OocTMclyeCKsbL3vOSOmCj2qFGec1pxojc7sGCRLIr9?=
 =?us-ascii?Q?ku9I3K1YsXtw1dsmUCtuiMU5DJiMkFk0FxWRBSVmyw7B6d41WjjSpcYYvEwC?=
 =?us-ascii?Q?T/sXf8vS8aAjD37FupAEEmXtiJ3wURM0RdHKHL+Cn6wfwLXRvpNMVqQlOgdR?=
 =?us-ascii?Q?n5Fmy93U86a0ie6iwzPs934r5WVfKRDSIhY0GK2NKp5Rs42nK0VZKmRduuRt?=
 =?us-ascii?Q?2Sjm62+owGJ5qjjcXOh/i+dtfFyAEIwAXNjgkPMs1013fuU3W+3gEZBg5QeS?=
 =?us-ascii?Q?XDLs/Fix8dmpSir/fiMnNNaUTUM78uQe9+4eW+SPFrl1kTsTeDdG8UostGTZ?=
 =?us-ascii?Q?RNhr459jejMEe7QQlINu8nyXwJRqMQcmj975AAqKUHFfzCnJEVrS5tOJ/WgP?=
 =?us-ascii?Q?TJiM5zViHzQ0oBR2fNCQnLyE83aJ8PkumyUbfgMCJVVYln/RvBjkXNVm0pgN?=
 =?us-ascii?Q?/2DWay/LhXL5JewaVgsLvUkcVlyKuCMzqbJvT9abGX2GslFvvhZXUn+2DpX6?=
 =?us-ascii?Q?pzBgFwHUQEU1LIlHdcVxQ/hhbBm5eZ21FPwVpWoZNsDSvQLKsYoX6NiCari3?=
 =?us-ascii?Q?r68kEvDjefF/6PlwwqBK7p9q/35330b0CmK6uCB/t6QYXuIMRarXfnAg2pqP?=
 =?us-ascii?Q?Ypkr6aqQh3qrvc+9x/N273oxZwRBSDg1L3YO71lKjBqjYEo3HW1TxRcS4T7y?=
 =?us-ascii?Q?U1X3FBCxWsU64SS3MviRiHxuKW+v3Tz59pTtid8aqdE6E0gTZO7zKTkRwyzu?=
 =?us-ascii?Q?dUTIOpKj263pjgZ1VX4UHLzpfuRZiJqok/bN5Rnv2NeCk0G54kRjSCCauijd?=
 =?us-ascii?Q?o4sEYw+8rzqAd0B7e8ZNPltdDzjFYmhixAVfbCCZIf6/qm4PCj4zhJPJWpMd?=
 =?us-ascii?Q?808xtNqIVJhPp6WESaXxByK87+2iRFOirXUgi3QfonsD27bTLjAZCvpTIR2l?=
 =?us-ascii?Q?I7gP6tlG3bE8GseI7MBCIfc/w3K7FBSSn/jSNUq3XfMTu6s5ah5QIIBy4hBd?=
 =?us-ascii?Q?JJRvDMhRCXTyP6+5j2Rz4Ouu3PrFj3mPosJWzwvEztYVRB00lt2+MHsT8qpx?=
 =?us-ascii?Q?UFf3+eWTfi1Rjmipe09wBZZ4P1bhqRHKTUMIY1S/j9p6EQQrBGEOe7/R+oao?=
 =?us-ascii?Q?dG+VpmmG6GlfwyTYw8CI2iHrTJfYkc7CIkS6sp/rVUGue0zP/TPLQspTgWVh?=
 =?us-ascii?Q?fB8Egcx15xgHX9DzssB1ktW1rkrdoGY2nR4a/pXwEkzMSx47?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: KTdFNR4B28lZcte5xHSNxrKJ0+7fXnRdZ16mBuOoVf0G0hZUaH2q7opgttA2hhfTmBfrQfx4nL4/9a+clry0rcVX2A2MaecRSLUH1TMzHh08LSImEWG9TmhV4T77IzKKSSGniu1QDKA3H6WB1Wk1okJ1yZRbAli2H0jiEKD1Ugvf32xOMLhx/E/XrhCPXKKxpzTj0yXM/59koD2aaw28WY1UAPnsFlOS1EVRlWnnZjEp/oWyyPBWazKVuoWwjG5mOhoveB5uDgLyitumtV/O5kzrbSsE5mG+oQI161u9p4wdbLR1WQdnuJkigYBY4EbSFaq+bs3mzsmX0P9r5rp+9A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e5c05e-e9af-4ac2-235d-08de95e6f0f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2026 03:20:24.9733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sqCULTsBiPC5Vnp85y87efmWg+UYzyn+j2lPMP4/cha2qSgj+Ikzhux0iawkGriEDp1A9zS2qez7Tc7BwlIpuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7681
X-OriginatorOrg: intel.com
X-Stat-Signature: hpsj9mtiqrj6ffwcx6ogtgtbc7x3cxyd
X-Rspamd-Queue-Id: 9D096140002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775704830-462459
X-HE-Meta: U2FsdGVkX1+EBKKkrmWgkOps0V7yUTPe+aNyLP42XvVkvhnvou66vqp649EhZlRKigo2SzX3mUDTtfNkxOIbke4lLCPjcfM/VNVbV6Y992fSf1atStdcq0ODre+8MUoqo1saC8v3uLagu639fAKDqv7r8L+APIPLGz0w3o+UMnPAgLEz3bDF/uh/NT4x+HGnywZhnBE//3yTIwpRf3ziINw9vLircvVk+ffb+JTigNg652MhxDBZfdPwMWgYkfozHic6g3iRBU3TdKKAI94r+iL8JC2VWqk5cKgCYMSWwlEAhwwNCEVOWQBoKjcSFry/67lChMxU9XNSeZCvZkW0XbWW9IsjdsSUTlxEyoz3HuvDHpzza6RsKM9A3tqA+Z1sGYCrp6O9wayM1q9qm4Ojpu77C4yXKBwRgb0zSvDRQOpow1C5OnlZX5yf8QeMI1s3o3NsmRc6b5o+qNTfyE1A2IR6AZ0lWUDjwv/GPdUTDHmvJQVJRADyP/VH68hE2V4uOs5Hctkksjp/CNp5mUiBjB0BXThjNSD2UQt8poG5L0aMwIw11pS0ss1cp3KW5T8xNs16JaSJMQadbNA7VznOIhtAEXQ9qbw+tAlSRZffoZBT2tqY6hCErFPAyMr/Pdr1RYHvKZ4g+q85heEoRbhea178TYOcykbBydoMpw7TXG1Upmp+IBO4KpHgqXHZ7g/J6zqYEeL0H/suSxh+Omhxo7J0oF7ERnWSA0GEOmwCGGzQF8gLecCOOAYC7kPpbfjqbH8wkE3DU2h2xFqL6ax0aRBAP8Cfb3BpxucXrIFVPTuNqXRDKqbHUQv66zqU+NIhYRYLuRscEHvWYf2e7Q1lkE61ZygDyDR9VBG/Jc6CXpn4qnyAfD0UpFNBf5IdQNOI8arB2LdJx+7vgDMTlG7Qt4B2nbteaGiY9080GGOqA0iwzeAS8xqoNay/miNSzr5KmSBr6L2tk4wQ4yp5HvP
 pNlbi2U3
 nPP9eMMWSLdph+fZL55PcdcE4CY8oYcwe0BaylghIm89x0Yr5fVhk865gY+UDIFZohWDF+zUrBsxM8hiBoR6ceW20z6FHdztvCzdZ7IdOhbktJpLjmKX4UfwoX3ERg7M9GAitJkd/G0u42Xyn8unIyR2uBjc2c3tlUmE3vedFgzuWQgoR/jQnOZ8CNvqElYV6+XV5wt5P8LWfeZp8EO+mfGZZXD8W6J3Eax+qbrcf4GtK9iPe6NKecdtIm4/nY2BxWbXSzL0fXnLh9GnsUzbAepty83un6g6L6Avfg//9/0Hb+ilNzA9dZkYUjmjmwnDRjKK2FdsSGG8qyhIt5/obtXD//XWz8bFojp0jp1MkqJtV8vm6hqIQhdy/x2y1KRsV8tRvIVzBwVWg0U1R0VhtCIs3pG5NQ/Q+mVWpf786XA94sawtsk9QOqmEaywUf18bN1g4d+ps9F4e3EthuNLaYGjqjaTBcVRlPIRZGUWwefwG+lfh5qO6caHq5GlQ2L3SJP/0yzm020eU6XbQfCpXVxEF892CxtwB7x9ZrNbEj6Lnoo1RgwOZ1Nflv/WTaDDCvp0ntyL6hFi8KBrv8swdTBrODjbKNNrtdOGT19ImrMzAH4YwleSDjLhhyNyrUeu+jAdYRaZ4toWLX58gPDqJ3bB8SHw0AY+jcdGdp9f1IEb5owJiGQ0PLo3vGzi5Z9rCV6tsfsf3jebpVCB968OchAacSmxxA6tsUFrhgmy7mAX/Xf+ghzGqTKgg6kHkNLouIoNtXfhn6M+9Ya0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Sion Ji <sion.ji@samsung.com>
> Sent: Thursday, April 9, 2026 10:36 AM
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
> Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous
> check when changing pfn range
>=20
> On Thu, Mar 19, 2026 at 05:56:22AM -0400, Yuan Liu wrote:
> > When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it
> will
> > update the zone->contiguous by checking the new zone's pfn range from
> the
> > beginning to the end, regardless the previous state of the old zone.
> When
> > the zone's pfn range is large, the cost of traversing the pfn range to
> > update the zone->contiguous could be significant.
> >
> > Add a new zone's pages_with_memmap member, it is pages within the zone
> that
> > have an online memmap. It includes present pages and memory holes that
> have
> > a memmap. When spanned_pages =3D=3D pages_with_online_memmap, pfn_to_pa=
ge()
> can
> > be performed without further checks on any pfn within the zone span.
> >
> > The following test cases of memory hotplug for a VM [1], tested in the
> > environment [2], show that this optimization can significantly reduce
> the
> > memory hotplug time [3].
> >
> > +----------------+------+---------------+--------------+---------------=
-
> +
> > |                | Size | Time (before) | Time (after) | Time Reduction
> |
> > |                +------+---------------+--------------+---------------=
-
> +
> > | Plug Memory    | 256G |      10s      |      3s      |       70%
> |
> > |                +------+---------------+--------------+---------------=
-
> +
> > |                | 512G |      36s      |      7s      |       81%
> |
> > +----------------+------+---------------+--------------+---------------=
-
> +
> >
> > +----------------+------+---------------+--------------+---------------=
-
> +
> > |                | Size | Time (before) | Time (after) | Time Reduction
> |
> > |                +------+---------------+--------------+---------------=
-
> +
> > | Unplug Memory  | 256G |      11s      |      4s      |       64%
> |
> > |                +------+---------------+--------------+---------------=
-
> +
> > |                | 512G |      36s      |      9s      |       75%
> |
> > +----------------+------+---------------+--------------+---------------=
-
> +
> >
> > [1] Qemu commands to hotplug 256G/512G memory for a VM:
> >     object_add memory-backend-ram,id=3Dhotmem0,size=3D256G/512G,share=
=3Don
> >     device_add virtio-mem-pci,id=3Dvmem1,memdev=3Dhotmem0,bus=3Dport1
> >     qom-set vmem1 requested-size 256G/512G (Plug Memory)
> >     qom-set vmem1 requested-size 0G (Unplug Memory)
> >
> > [2] Hardware     : Intel Icelake server
> >     Guest Kernel : v7.0-rc4
> >     Qemu         : v9.0.0
> >
> >     Launch VM    :
> >     qemu-system-x86_64 -accel kvm -cpu host \
> >     -drive file=3D./Centos10_cloud.qcow2,format=3Dqcow2,if=3Dvirtio \
> >     -drive file=3D./seed.img,format=3Draw,if=3Dvirtio \
> >     -smp 3,cores=3D3,threads=3D1,sockets=3D1,maxcpus=3D3 \
> >     -m 2G,slots=3D10,maxmem=3D2052472M \
> >     -device pcie-root-port,id=3Dport1,bus=3Dpcie.0,slot=3D1,multifuncti=
on=3Don \
> >     -device pcie-root-port,id=3Dport2,bus=3Dpcie.0,slot=3D2 \
> >     -nographic -machine q35 \
> >     -nic user,hostfwd=3Dtcp::3000-:22
> >
> >     Guest kernel auto-onlines newly added memory blocks:
> >     echo online > /sys/devices/system/memory/auto_online_blocks
> >
> > [3] The time from typing the QEMU commands in [1] to when the output of
> >     'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
> >     memory is recognized.
>=20
> Since the above results were tested in a QEMU environment, we ran the
> tests in a real-world environment [1]. The kernel version is v7.0-rc4,
> which is the same as the QEMU guest kernel. We configured remote memory
> node using 2 and 4 CXL devices for the 256G and 512G tests, respectively.
>=20
> We replaced the QEMU hotplug commands with the daxctl [2]. We tested by
> changing the value of /sys/devices/system/memory/auto_online_blocks.
>=20
> The following is the result when the kernel onlines added memory blocks:
> (echo online > /sys/devices/system/memory/auto_online_blocks)
>=20
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Plug Memory    | 256G |      6.7s     |     4.4s     |      -35%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      18s      |     8.7s     |      -52%      |
> +----------------+------+---------------+--------------+----------------+
>=20
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Unplug Memory  | 256G |      2.8s     |     2.6s     |      -8%       |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      5.2s     |      5s      |      -4%       |
> +----------------+------+---------------+--------------+----------------+
>=20
> [1] Platform        : Intel GNR-AP
>     CPU             : Intel(R) Xeon(R) 6960P
>     Memory          : Samsung DDR5-4800
>     Hotplug devices : Samsung CXL 2.0 128G Devices
>     Kernel          : v7.0-rc4
>=20
>=20
> [2] daxctl commands to hotplug memory for a test:
>     time daxctl reconfigure-device --force --mode=3Dsystem-ram dax0.0
>                                                            (Plug Memory)
>     time daxctl reconfigure-device --force --mode=3Ddevdax dax0.0
>                                                          (Unplug Memory)
>=20
>=20
> The following is the result when the value is set to online_movable:
> (echo online_movable > /sys/devices/system/memory/auto_online_blocks)
>=20
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Plug Memory    | 256G |      4.5s     |     4.4s     |       -3%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |     18.6s     |     6.6s     |      -65%      |
> +----------------+------+---------------+--------------+----------------+
>=20
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Unplug Memory  | 256G |      2.2s     |     2.6s     |      +18%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      5.2s     |     4.2s     |      -20%      |
> +----------------+------+---------------+--------------+----------------+
>=20
>=20
> FYI, it is the result when kernel does not automatically online memory.
> (echo offline > /sys/devices/system/memory/auto_online_blocks)
>=20
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Plug Memory    | 256G |      3.3s     |     4.4s     |      +33%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      6.7s     |     6.6s     |       -2%      |
> +----------------+------+---------------+--------------+----------------+
>=20
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Unplug Memory  | 256G |      2.2s     |     2.6s     |      +18%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      4.4s     |     4.2s     |       -5%      |
> +----------------+------+---------------+--------------+----------------+
>=20
>=20
> We hope this result is helpful.

Thank you very much for sharing these results - they are really helpful. Fr=
om your data, it seems that for 256G the improvement is not consistent, but=
 for 512G there is a clear and consistent benefit. This is very useful for =
understanding the behavior at larger scales. Thanks again for the detailed =
testing!

> Regards,
> Sion Ji


