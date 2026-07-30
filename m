Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B533AC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3C96B0096; Thu, 30 Jul 2026 03:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7BC26B0098; Thu, 30 Jul 2026 03:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A6B6B0099; Thu, 30 Jul 2026 03:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 784E06B0096
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:57:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70EE312074E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:57:23 +0000 (UTC)
X-FDA: 85044687966.03.F31D6DC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1ED39100008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:57:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Y/3VJjzP";
	spf=pass (imf14.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785398239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnhU6FKdrSK82lKn14RftT+vYbDKZTpqy2O+KxJ8XVk=;
	b=ZO0X4jm9nuzsxSce5lIbwlSq6u9bMjFW5WYe6YIxERtnmm00oKwJaHtKJvAY1dTtgeHCms
	YXMDpP3RtFhXKHm+MCLqIN+7yqdTEyJW6womJuG7mYbiLbQe4/oZLpVXKALBMjwE2+O5bH
	CCu56Rf8TR8hTKSbO8vCeAKWq+ckX28=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785398239;
	b=BRY2F/7iYACevWoICZrbsKEUjVHZSgw59kDIVn0ULLGVtS6PqeArcMvfUdjDCLdogW86Ns
	mKFCe14h70fnNBrnehAE/4H/z3XnjkAkYCwVXrctmiVc9QQigSaN666BNH/17//u86ZNH0
	lpNi3dhtE30wRqYRBEIRv5EPGrsOG/k=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Y/3VJjzP";
	spf=pass (imf14.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785398240; x=1816934240;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6QyfhjKq4pzGd2XoQfvgPHTTgll3HZZ/wi0JIrMTPUo=;
  b=Y/3VJjzPAOmmRp1HvUFcGzVNOJ5iM7x/EwDGkiDY+P3DjeLAlwh5SKyt
   GclcnKLFOBwrApsLJE4WQI1CE7wyiK7010GUud/P/JP/kjeKudL3juUnR
   R6u60j7W/7ZT1SzjFug4E9NaQizUKSkILBz96cT85sRPTVN0vUnRi1bv9
   0KetFwbsxUVh9h0enSijdw2HyMdnEs99+UHNGZKiB76KzcxaDpYqJOYIM
   jCP3vr2FOrTi9DNwScJqGnMvSjPx+LjarBJX7FT/MIOssjWfPk7VbPWBf
   eDTD7GoSbTFXZ64spVFQ87E6pQYYNQ3TzXyRgn2YV3eXQKB6sdHPqY2dU
   g==;
X-CSE-ConnectionGUID: iWu4MXV1Rru/IZfED875Ug==
X-CSE-MsgGUID: xYnnPEwAQdefYPZ9oHjOdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="85866427"
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="85866427"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 00:57:18 -0700
X-CSE-ConnectionGUID: DjZb9wFhQUia8XWHeGDr+w==
X-CSE-MsgGUID: KKNWMEUjQBCFEMeH1JuQAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="258457066"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 00:57:18 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 00:57:17 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 30 Jul 2026 00:57:17 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.54) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 00:57:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w5ZZiqFxUm5MJsC23AUlIwovHL+h10vmAZ/Gt5tTwqLZvIOtvN1pkrCmPpIFusJwoTPaGsVotJurZN4fCWvvhS14huin9+wMMJ3f/yBit+izjzAnl7/bX3p3LVuzjWNJAjh+ZRX5mcn1svdsUBBpykjiiMzIs7IXG8/uuDRY2V+sfi83MZuDZhZM53ePwWNHOh/+XZxHue7PLhe30AIQXg16ZYeX3ucxE5cggoxvCBpVpsDLangC4OHCynmwIaay/1QNFAVyit7TnjF0+Wk41hT+5MH2sEOI6yhUCPO+F5UEVFWBVrA3risYLWaOx0hYdZgJHJshZxH0Mz6PurEhmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EnhU6FKdrSK82lKn14RftT+vYbDKZTpqy2O+KxJ8XVk=;
 b=MSabb00SDsGY1KwmRrpQFB7RyoZJpe6UqYvV7dfZxqC1itPc3mEaLABISp+yBc4D1dKoQzan/KG5PiO0MkltSw1WahST3P4WF4cNEFvvWfWvb5QH84kByqRSmPUnIEbYGf7kHrk4lZsWbn6xqkbndd09Jz5Yeuckk2PkmKuP6fR5Plz18+KfPKWCe/+qrWz6IqvyG6O1Ipj3Yn3NO3Xd5BFq1HbUoW1el54v7BEImDM0Ifg4NZtON9ULnezt2FXjDv6gqAuj53yB+/nV9FDLwc05nb2/BrBe1jGDU3hBCexiDK/bj1Sg+yZSoBZNIBMLwqb/iP2Rc75O2ConyrK9wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by PH0PR11MB4888.namprd11.prod.outlook.com (2603:10b6:510:32::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.14; Thu, 30 Jul
 2026 07:57:15 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%3]) with mapi id 15.21.0270.009; Thu, 30 Jul 2026
 07:57:14 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Wei Yang <richard.weiyang@gmail.com>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li,
 Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng,
 Jason" <jason.zeng@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
 subsection boundary checks
Thread-Topic: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
 subsection boundary checks
Thread-Index: AQHdGn+x2uiqqGOqx0aLQy9y2I3YaLZ9i4gAgAOZewCABD5eAIAAWRuw
Date: Thu, 30 Jul 2026 07:57:13 +0000
Message-ID: <MW4PR11MB693678FB9ACF5B0014F32803A3C92@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-3-yuan1.liu@intel.com>
 <20260725024952.65lfm2s676obpoue@master>
 <MW4PR11MB6936598686BD5FA7B2FE9181A3CC2@MW4PR11MB6936.namprd11.prod.outlook.com>
 <20260730023614.fasdjzfl5wz4tsfr@master>
In-Reply-To: <20260730023614.fasdjzfl5wz4tsfr@master>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|PH0PR11MB4888:EE_
x-ms-office365-filtering-correlation-id: 196044ba-67cd-4635-26af-08deee102af7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|38070700021|6133799003|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info: bJkSDynbrq6/Z1d/Xy7gUZFvSjdEoztylsNiguq5STUEdEW1zp3PHDveLbghvs1W/Xfq5QRAZAp03c6jJxero/l+KndEpUrCtrG36MDkvYUDQggFIFO986unPwC7gNPs5Zut0ifl3h7k5gl9X7kdS2czNDLz83Cai2un+74RP3lvEg0xyPJPTZv+SRvTFBFoWEr8Ov6dB+OSki0uI5HBJmU2rJWX2uvumhsCIbO+UeiN2YaShDzVZVGRDODngEirQNX/uic0IS0fV/kweyN8x7RlVQm0CbMpMXUy9YiYua1sFY8r49V/jM4QFIj5o+ejmqVzyUPrUfKaThExod5eqyP6Eg825lyKQpav3ke6Z6oWUapXIiNzzGParFIcnT1iTiHqtCrA6i5kbNfe5YtRiWeISqgUN9c70b9nwqDvscyhAGLRgdtCFgTHsq0pdEiKIdgAV8DmLH9Qc9PKv070RXpHMC0vJEtvjHKoXFFkBpFYb+4W6glQcpbEHIOLYBanjsmhz8NcNjHEzxEuGAHJCsvKsOBiLJ1Pe6gd6GMJcWx3IZIEusSncW/GTIZwGZgMI9yVlvMOMgCnx7tllIiVH4LJyh534Ql29ncoViyOh/z1cL24mWq0JqgL8hmpGqlQAbwWfX5Vj1JNTucIY3EpO5cWPiGryw0wgdT2Al68Wn6EMK1qf1eX6E77yXN3hyvwMyvNWkgjJag/aRExKgO/W8fyYHjqX+GgKtp+hW2znKY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(38070700021)(6133799003)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?idqBOxAZ1QJTsZs9FabxSoMghVVQwZZ30eImdePoAKSNn8V0FlybwjXnnLM7?=
 =?us-ascii?Q?EIVeqn4bZKVsoEC3KBKB0QSLq0YDAG+Qp1u0J/ZK15PiP0rshRwklEeZk++r?=
 =?us-ascii?Q?QiSLF6ugYK0nzZDw79NDqtro+8C85NJ5f+3ApNPRfMv28etd7kOR2AttQZj9?=
 =?us-ascii?Q?GJgJKe3QMheVuE6leXCkZTG57mATTNwFzyq2ZtYd9oRQiDoDLan58PI4PsYL?=
 =?us-ascii?Q?0daQCOjqfUrVRWMXT4Ty71jkpGPp+KEG0ew73jTQfCPqkRUoP1MC5QtVTOWt?=
 =?us-ascii?Q?6MZ6U1fs+F3UUlfCkgBDbsob8gAQUb4qbLuF29S4CVEwrh8JGGNZMg7PWkp/?=
 =?us-ascii?Q?FQgAC7W51B0PrH/IgUUidou8jKvzWM+NkPnrFs7IiVdd2Zg2mAeoCVsalCDs?=
 =?us-ascii?Q?IYj7t0uU47X/4dq/PgdqCVBOh7eB/NTrhlf0VrJTir4XSiB4jeENHV/daUkh?=
 =?us-ascii?Q?BfqF//7p3Pg2VzBKiAuDR8xxWnk0X1umANFLBMtUNRwfqdLOwZLBeBva8t4f?=
 =?us-ascii?Q?4mD2F26CL1KdXqbfIz5I2GLI/kbyAS5k23qRT26veixFsIcIzWkex+A6psAd?=
 =?us-ascii?Q?dgtbVzfGsEdmDcQoGPVAtLgi0Baty3CJBGOllrHS0hFDAYIGmBsGATyM4rA7?=
 =?us-ascii?Q?WoUCVjUya87NZXyFzVOzBzuhwz5exw1IZFbzfq7dzknucrU6a4J+1s5zJKtN?=
 =?us-ascii?Q?dQJ9t9BJuWmNxK3j2+9oxQf0VEfnzWmv4ghHGIUQXXM2SL03r8z0COKk02qv?=
 =?us-ascii?Q?tAzh4DnHCGhBFGaGkI02P0HT6wzXknMNH4alKzrVbDJ3soXhGhxV/eLed9T1?=
 =?us-ascii?Q?FXgdOlaunfHsSDyiiDbQhzmjzOTx1eBX4LImQEKGz1QE/uCWsxzYvoVnnVqR?=
 =?us-ascii?Q?VrrWaHaAH3BjIFC8CuhUT7CqGKsLefrp47TFfySmLzKCvTUesiQfjABV0Oj2?=
 =?us-ascii?Q?WsCxVZwRrHulNI94mZANLx58GKXrqA3aUw7mGSh0exhz2GUPDIhY/j2MoloZ?=
 =?us-ascii?Q?g6NyQTLY3njL7TcC53jSOgoFfkqNFRbvfTB1/0vTnjj1Wxg7RxIKTfgFCoVc?=
 =?us-ascii?Q?66FdrZeo5XbySYuD2KMa4aW1ddrE5uKqBHXw2fuGNVK00Eq+5CIzpRYzafMC?=
 =?us-ascii?Q?jt+0TPRrakvhMnIbIciiqi0jaL12LFw5lxsYxa6913ZAdxfTH0N3O57VJN/i?=
 =?us-ascii?Q?QrZ/dWU1xRmx/3b7Ik3YvuKkmGwIXW7kVIZ8VaEXmtsPlWWSlLz/IdZpgnkz?=
 =?us-ascii?Q?jtwE2tKbcmqt3CjJDrbly5A5FcB+jxJMO9hQcL4kKbROUlRKwzX9gpIorx28?=
 =?us-ascii?Q?ouybsJftOOgBYu+owYus0kIHMTPy0PDV07+sx3HJitFqRt74G6YLnnfBDV7U?=
 =?us-ascii?Q?9Qqf8LsIVu2+YRGcRvnopuJNKKcU2JahiE0fqpLL0QQg+ZSvInq+nosc5KSe?=
 =?us-ascii?Q?aS0oZyfMGLQUYj5lZ0a8bavtT+mRQ3sipQCNpRiXR7+3HE6lvnXbh/NwNfB+?=
 =?us-ascii?Q?p2pK3y1FHaBP27k2PVGggPZ95adKjBsIqI0J1DhSL3Of5esfdTblNzE64Yxr?=
 =?us-ascii?Q?12TYIBEF9Icvb6F01/hrgFTfqdZCNG7hip32744RyKK+yN1oMO8f2/Lbg6Y8?=
 =?us-ascii?Q?WnzgwPUIkIqNcyjYjgC/Rsd0nEd1ZjG0RXNT3hAIkKIFOOOS1i+cQmjuICov?=
 =?us-ascii?Q?/xD7BWabzLt6OkgOhwdzjtMPlmCz+Hv6xCwp1svI3mxCkhDK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: JCGeVjDEevZTdUvZctsWO9bHdsS0EAYGFs2c80FBcpPAQFLCYXxih/AZqEGNv3at2ADkTMlVRwyW3ozUGxHj3Iq2cLzqjHMXo5OS10Q94jDIje/0eYO9R+q8NunoCLO+kqAXpqTrCh0yo4REIVPDONg3YkZFNHiXIH0ackDkFM2wryzscl6LwPoya3gkacmuory1bENoqC7SCuYDRq+AGfjU6bIKMch102N7QGgqrNy2RU48xaK8u3322Eu1hJqSq3YKR9Sx81VGd2WXFigCA76X3wFM1Kywxu7UEtGcrqMTI+kHz/NwgtUMbh/bmqjZT9VYWryrw1T+5hq23PxaTw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 196044ba-67cd-4635-26af-08deee102af7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2026 07:57:13.9621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l93d0b3VpZYrsBRRhb2eIJaq5vq8bD+GVJcSc8lEDqj8bXXBvNSjvdsztj2Ts4s5xW7perYhOQbfpHWTjfvxuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4888
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 1ED39100008
X-Stat-Signature: cwpb9f5f57ue3kztufjbd4r19b7xbcb7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785398238-186479
X-HE-Meta: U2FsdGVkX1+n996n844MJa/ADcj0iaehC1nff87qz1Nbv8nlQCRdt/kBspTLweBGjdSyszPdsXcXyBlCfbQHWX18HzrvWbYzPbe35WOS12uLAetTk5MxLcQfyGSrPVAeICieh0hsGnOx56rjDEEoQyiwpFOI6S+KzWtvjoyN/G8KLhn9I8n5sXs3/cls/QNLhCC+es9yTZC/z7a4j0QqvRkqTWmZ0vdy2A4bxfHIgVpfl3km+3KlxDr5Jarayt4QfuNSJVz+8eYqWr9mw11srOQSLN831ZTCaspZB2ckO5jddV7uKqKbAl0uRZsjiZrtBuDBR6Df7lrnJ85nj/8k81y/sqyfR7Wlcqou3MnWtIbAOJoLB3ZPhhT2uUGmqlueSSB52Hoas+8l42+Lrs+RxJNmrunfzHdlF99wo2EM80tekQkrFNMRhHGsMdbdSWCiM7EaSadA08ziu1jtgsStZbFyrZ85JUq3I8aZe862Q9KxzHFd88+IXRm67zU3Z6OZHApofGao/X9Da1U3i6+6Z8mGYlzGQ1JUrR0gcpic88HDByIry98Xmu2xgVv9eHTerycJTqwtyIZ6y37EJkn36WI1w97gcNCXHUZ49OrfNbvquf25se5w3FU+ewzilnJD10qR1AF+vxCMMzKM/kFr8ZZIVF+MgmZrLSEWyosWH9t8y1CU3Wxwl9xBOPur6bCzvqPHe5as+JI59kH/cMFUcMMhzHLK1IUVP72Xjp01GFR/zlVC1uCV8Ie3KosdcSLgDGFns3hz+WGLdidMz83KiemvOmPl8hQxtyWx2xxmKPQjBfr97qkrV9K5gk8klkQUsDhtVV4DobLfDGYl7X8YweNX1z6fc43ZyGjhrPLMvomgsfglOZ7EElBuvTZ7pioTRKorIGx/8XCP08Xk0HuC9ISvnvXGdYb5+zRznziE0tZk8LtkA3EvGM3Z9RhB/r+r0dxFjTi4TRr6afG6eXp
 JFuJkWDn
 e81RBHiLBOJZUDAtc5IQ9reLdUfvoqvbwwqc1M/1N8I/XUOP6X3kXl9/4NUTEYdgARF4IjlzB89hPXnoMOUqFXR1m0w0UoBCY9tdSLis5WeqDuH5Y/+uwdLfININeBIKnk5ncqoT6SDx5llFmB2jIbZ2rMaysv+H68kvUigFpzFUPY9JiDNM1wuFSHDsSj3pKQpr4KXJnfIcQcLhtNVLDYU2X8ZEUmvx0YNWnJ36PHeP/r/XDLELVtiuzPUASeqLAqWK8y8azrbpwNlm1tLem0wyO1DxPRmaodBnnp+nU4erABr0rmHj01lCToigD6p6XujXOyd0NoGXrE6CwPg3ZXa/NqZFEDW/is4YibxCZOFX4Hs2LWlP1x8RVXqW8I/EYw0OTl85dDqbhSHWGSEQ87QF7I1caItdNyGrUH2WDOtnwawMnfln+FrR98gRU8CgxSGMxljjDZoJOu5Orygn8VQ9FX6BheWgQjY4y3mLkuLKURnU1jCcymjYLM/Vjf33IUoflAEmIPQ3QudMlfHyZh9wFzdzpulOkc8oAvtAP7/nDD4Ggd3LMzvlAlcmEGvZRo5A8VZaZNyhwazdY7fCUiHbu9MmYkQSQx8mhyIurA50UyeiRaS74WinU6RiRUOdT77KhGGs5YeHKtCzJS+7h+NC22ZV6ND9Oe3XhgaelTxhM6eDbMUHvI7+4T9aiEuQhTlXNmsORSZhiJJXOvv81LC3QUIs2NcwC9S1tQEXwil+PJ0XmQvloz9++Va3ZM4hIJwCW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Wei Yang <richard.weiyang@gmail.com>
> Sent: Thursday, July 30, 2026 10:36 AM
> To: Liu, Yuan1 <yuan1.liu@intel.com>
> Cc: Wei Yang <richard.weiyang@gmail.com>; David Hildenbrand
> <david@kernel.org>; Oscar Salvador <osalvador@suse.de>; Mike Rapoport
> <rppt@kernel.org>; linux-mm@kvack.org; Zou, Nanhai <nanhai.zou@intel.com>=
;
> Deng, Pan <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen
> Zhang <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
> subsection boundary checks
>=20
> On Mon, Jul 27, 2026 at 09:49:39AM +0000, Liu, Yuan1 wrote:
> >> -----Original Message-----
> >> From: Wei Yang <richard.weiyang@gmail.com>
> >> Sent: Saturday, July 25, 2026 10:50 AM
> >> To: Liu, Yuan1 <yuan1.liu@intel.com>
> >> Cc: David Hildenbrand <david@kernel.org>; Oscar Salvador
> >> <osalvador@suse.de>; Mike Rapoport <rppt@kernel.org>; Wei Yang
> >> <richard.weiyang@gmail.com>; linux-mm@kvack.org; Zou, Nanhai
> >> <nanhai.zou@intel.com>; Deng, Pan <pan.deng@intel.com>; Li, Tianyou
> >> <tianyou.li@intel.com>; Chen Zhang <zhangchen.kidd@jd.com>; Zeng, Jaso=
n
> >> <jason.zeng@intel.com>; linux-kernel@vger.kernel.org
> >> Subject: Re: [PATCH v6 2/2] mm/memory_hotplug: improve
> shrink_zone_span()
> >> subsection boundary checks
> >>
> >> On Thu, Jul 23, 2026 at 04:49:46AM -0400, Yuan Liu wrote:
> >> >When shrinking a zone span after removing a PFN range,
> >> >find_smallest_section_pfn() and find_biggest_section_pfn()
> >> >only checked one edge PFN in each subsection for nid/zone matching.
> >> >
> >> >If a memory or hole boundary falls in the middle of a subsection,
> >> >that edge PFN may belong to a different nid/zone, causing the helpers
> >> >to miss a valid PFN within that subsection.
> >> >
> >> >Fix this by checking both subsection edge PFNs for nid/zone matching.
> >> >Keep a single pfn_to_online_page() check per subsection, since online
> >> >state is the same for all PFNs in a subsection.
> >> >
> >> >Reviewed-by: Jason Zeng <jason.zeng@intel.com>
> >> >Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> >> >---
> >> > mm/memory_hotplug.c | 42 +++++++++++++++++++++++++++---------------
> >> > 1 file changed, 27 insertions(+), 15 deletions(-)
> >> >
> >> >diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> >> >index 4c699fd9c479..3a281d595207 100644
> >> >--- a/mm/memory_hotplug.c
> >> >+++ b/mm/memory_hotplug.c
> >> >@@ -427,17 +427,24 @@ static unsigned long
> find_smallest_section_pfn(int
> >> nid, struct zone *zone,
> >> > 				     unsigned long start_pfn,
> >> > 				     unsigned long end_pfn)
> >> > {
> >> >-	for (; start_pfn < end_pfn; start_pfn +=3D PAGES_PER_SUBSECTION) {
> >> >-		if (unlikely(!pfn_to_online_page(start_pfn)))
> >> >-			continue;
> >> >+	unsigned long next_pfn;
> >> >
> >> >-		if (unlikely(pfn_to_nid(start_pfn) !=3D nid))
> >> >-			continue;
> >> >+	for (; start_pfn < end_pfn; start_pfn =3D next_pfn) {
> >> >+		unsigned long tail_pfn;
> >> >
> >> >-		if (zone !=3D page_zone(pfn_to_page(start_pfn)))
> >> >+		next_pfn =3D start_pfn + PAGES_PER_SUBSECTION;
> >> >+		tail_pfn =3D next_pfn - 1;
> >> >+
> >> >+		if (unlikely(!pfn_to_online_page(start_pfn)))
> >> > 			continue;
> >> >
> >> >-		return start_pfn;
> >> >+		if (likely(pfn_to_nid(start_pfn) =3D=3D nid) &&
> >> >+		    zone =3D=3D page_zone(pfn_to_page(start_pfn)))
> >> >+			return start_pfn;
> >> >+
> >> >+		if (likely(pfn_to_nid(tail_pfn) =3D=3D nid) &&
> >> >+		    zone =3D=3D page_zone(pfn_to_page(tail_pfn)))
> >> >+			return start_pfn;
> >>
> >> Here we are checking range [start_pfn, tail_pfn]. When we come here, i=
t
> >> means
> >> start_pfn's nid or zone doesn't match our expectation. But if tail_pfn
> >> does,
> >> why it still return start_pfn?
> >
> >Hi Wei
> >
> >If start_pfn falls into a hole while tail_pfn still belongs to a valid
> >memblock in this zone, skipping the subsection would cause
> >shrink_zone_span() to shrink the zone span too aggressively, excluding
> >valid PFNs from the zone.
> >
> >Since init_unavailable_range() initializes hole pages with the correct
> >zone/nid, the start_pfn check always succeeds here, making the tail_pfn
> >check redundant today.
> >
> >That said, I wonder if it is still worth keeping this check so that
> >shrink_zone_span() does not depend on how hole pages are initialized.
> >
>=20
> Looks reasonable.
>=20
> I search the discussion history, and found David suggest this fix in [1]
> with
> following statement.
>=20
>   Well, unless we have an odd case where the hole+memory starts in the
>   middle of a "PAGES_PER_SUBSECTION". That would already be problematic i=
f
>   memory starts/ends in the middle of a PAGES_PER_SUBSECTION chunk. I
>   don't such a case exists.
>=20
>   We could improve shrink_zone_span() to let
>   find_smallest_section_pfn/find_biggest_section_pfn test the pfn_to_nid(=
)
>   and page_zone() not on;y on the smallest/highest pfn, but also on the
>   highest/smallest PFN in a PAGES_PER_SUBSECTION chunk.
>=20
> I am trying to understand the exact case David described, but not fully
> get
> it. Would you mind describing more, so we would make sure not missing the
> point.
>=20
> [1]: https://lore.kernel.org/all/e86fee84-08d8-4563-8596-
> e40d8e196799@kernel.org/T/#u

I am not sure whether this scenario can occur on real systems, but
from reading the current code it seems there may be a corner case.

For example, consider a zone whose tail ends with a single-PFN hole.
init_unavailable_range() initializes this hole page and assigns its
nid/zone to the adjacent next zone, since the PFN itself belongs outside=20
the current zone.

When memory is hot-added after this hole, the hotplug granularity
(PAGES_PER_SUBSECTION) extends the zone span to include the entire
subsection containing the hole.

Later, when the hot-added memory is removed,
find_biggest_section_pfn() examines the hole page first. Because its
nid/zone belongs to the adjacent next zone, the boundary subsection may=20
be considered removable even though it still contains boot memory pages.

This appears to be asymmetric between the zone head and the zone tail.

At the zone head (find_smallest_section_pfn()), the boundary subsection
has a hole + memory layout. The hole pages belong to the current zone,
so the subsection is retained.

At the zone tail (find_biggest_section_pfn()), the boundary subsection
has a memory + hole layout. The trailing hole pages belong to the
adjacent next zone, so the subsection may be discarded.

> --
> Wei Yang
> Help you, Help me

