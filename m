Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE163C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 12:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDA776B008C; Thu, 20 Aug 2026 08:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8ACE6B0092; Thu, 20 Aug 2026 08:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79756B0095; Thu, 20 Aug 2026 08:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FCC46B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:53:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04E491C00FE
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:53:12 +0000 (UTC)
X-FDA: 85121638266.01.A987973
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf29.hostedemail.com (Postfix) with ESMTP id 98000120006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:53:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rsz+Fp+y;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787230389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZb2Dk2T5OA2roq4IjlZJt9AeGmCxyIshzK3CjXjiNc=;
	b=H+M/vPshyaJEkOymm+tZzR7xU5A+7Dgsi7cjH7aEDORPwCDQNGwW6Z6KHIr2ORNoX8rRQ8
	Vf1b2cEmmKl+fnwYriInw4rG9YIK//q5iRumXtRZUHaIvCD32IrLe1H7JbRyGmrh3bak/Y
	8PYu7vZDCUIAT7iVHa6nVZyrWwtEAFo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rsz+Fp+y;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787230389;
	b=jfSJLuT1N0oQ5CsOcmWg4T55sZzPmrPEaQYP+RtGPKhqu3XNX+IhvbEFTps8A02P0n0jEd
	79OTIOo5atD1U38hy3n2MXfeKw6jDma0vE4CMzxzthsybcSpsy2yAokOBvhT6c4vNBqauT
	mIm5jylxPEXUzfIexjg/J0BDW6sFDcQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787230389; x=1818766389;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LBODIwEdpMMbV2QtiPJpWGfKlliJ/GAfA2hHHHqronU=;
  b=Rsz+Fp+y3g4mb6WpKAfTyfwiYd3Z8iFRltaKR9v8YW/n+yeRDoJH9KhQ
   xr9zP2S8HbmRFVxLChZk/ECgOBdCBBZ5qDgQm58uQ3j335FpJZTgVBnjh
   pVBH1a5OrTDWriuyGhLqsVQa0s/s6GnS0Wyaq6F9NTmLY+BprmzchLesv
   KV6hmOMlr7enRXLp9RJUx08vavp4Z0jeCSBbPxEJpzDK9rCGuS8kgpTIU
   0IBE6+jFjPYyNz9dnNEqf3QfsGfAV7+dN2vD+iqvUVdVDf+j47m5yxrWS
   /1DafZb4zlLtIOjXQS9ozVXyUnaMCgJQ4r3nbQUpECz6mFRxBC+liR9d+
   g==;
X-CSE-ConnectionGUID: wgTDMG1BRQO1ywKVx1d6rQ==
X-CSE-MsgGUID: ZYw08C61Q/K78ZY60p7dug==
X-IronPort-AV: E=McAfee;i="6800,10657,11880"; a="113303303"
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="113303303"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 05:53:03 -0700
X-CSE-ConnectionGUID: FMtUUVIgRb6AZdExOEQo7w==
X-CSE-MsgGUID: l7ZSEns8Q0GKQ2Tl6vS86Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="269493733"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 05:53:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 05:53:01 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 20 Aug 2026 05:53:01 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.10) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 05:52:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iYtbmuSeTSKgLfZiyKeFJr+Ayg5eAFK841m5kHZRFDtjxNR5Wzv6FrgPf0JbFIODcYqNK7o+1QfWNSJU998LV1HtJdDj54qy35EvjxS6gLQP5ae/I3s7Szh4dLDwUrn046Rk5+BDWLw9/oVY0NM9gdNRCc7Pn6ZlcdC5DFPz35zpLic6Fky+/TFKZR7G/qwaC0RDaENavgKk0WZZqTXSu90nWFJUo9zlUW9rcz3ACiBZMNjf4kp9/d7hFGcD1VCDzLsT+l675u4Up2N+/Oil2HWo9aRzVHoSw6V9vnIZIdDV1AJ0d5SvHY4jd6xo4q7bI8cHmizeDgohkngkgMUIrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uZb2Dk2T5OA2roq4IjlZJt9AeGmCxyIshzK3CjXjiNc=;
 b=BGAYW/rQYxREid0sj4gAv841erH3x7C10JSu3/TTIIJqf1GWgM8O7lIjJfkXQ8IVucBkkTZhE1yK+k9+RE2If474hL89HRfdCBu6TLO6X9+uf4N1gFW0Yo4Ez0pZp1ts9yFOGZxnVpSfmlQWaxQf/hGdG5+g7rQ+4PwVB2iMGuqeL11N+dCQei9IIvXhcO2FKiijWInoPArvmfZQ6IgrO3YAKUSWbosALyJYtHfz5p4btnRHLGOR0mN2nfg6dRbxVS28ZTXXf9dVjSkn6Vw04VorGpO89OtoB6pqntO/Bh+eWlC9ANzRtCUze8kzHzWj0HJEbGa28qaXWkXX4Whi/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by DSVPR11MB9741.namprd11.prod.outlook.com (2603:10b6:8:351::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Thu, 20 Aug
 2026 12:52:11 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 12:52:11 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng, Jason"
	<jason.zeng@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan"
	<pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 1/2] mm/memory_hotplug: make shrink_zone_span() more
 robust
Thread-Topic: [PATCH v7 1/2] mm/memory_hotplug: make shrink_zone_span() more
 robust
Thread-Index: AQHdLu8L5URt92GsE0GgZ5S/ygZg37am5u3A
Date: Thu, 20 Aug 2026 12:52:10 +0000
Message-ID: <MW4PR11MB693634E1E7A50A2CD7BD691DA3A42@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
 <20260818085702.3395529-2-yuan1.liu@intel.com>
In-Reply-To: <20260818085702.3395529-2-yuan1.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|DSVPR11MB9741:EE_
x-ms-office365-filtering-correlation-id: 2340fa8e-76bb-4c69-6842-08defeb9d9dd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|18002099003|22082099003|38070700021|4143699003|11063799006|56012099006;
x-microsoft-antispam-message-info: tlcc7JWBFLvUTA7XUOfkdQD6NV9fGK4VO5YBidWEILH2i0N3MT9REXn26Ots/wnNBrA6tJ5rq1csZxws3ABhoVqKG2/JTDxBPgAmlzovDrFLUBO4gd7aIiNndpRfmnqjTpFSvrvrh1i32TZ40puxnQd9B6/Y12BsUTBrNiRx6q+axTUH5dXscay51j5XVCDT/lhGwcEi/hURfLCeZkKHfXi1vLY1l6GMelhlcOIgay5dq/PusI/X/owwXbEmf/o7CfyOJ/FXETujcyOroMjN0/EBLMLEIG0RONIzDiFHhsRGGskt1vgq8lkx1aS3zb/uzBMFYoURAs15b8pB0NXIOyxlIgr5KhCqQKR0U8616Wp6+rrqvY6KsgK+qsljUeMwhlGmlxyDx72w29ufOrYBnufFT92JAe/WHyVpz5DdASTo72Cig18lj4bEyFZ1ZSVGisO4ynHL6VJYvp+L/1HVyoeyIToce2zU21hdUPadLS+I1znxSHr1pOVJefPIgq3WsW/MIrFcWDsKZo9xWNVCSSPNxjtKlHkiWG1LSnn06iMVoD2cT/vAt4BwJ8oLeF0dthApuasSQBUIfeRf/NozcZkdzn91xQe91Qw+5+D8jUyr4tqxn1MYLx0k9YJweWU1jpMjt6vdnzdCUJRUR1LjF1EKN1Q5NqtE2o1jz+XfSTQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(18002099003)(22082099003)(38070700021)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uag2AxxZ4k/ZFHdqYaAJgAERLre0E0Oo2oRzueGcZMV6vkwdYln8KikQjmE8?=
 =?us-ascii?Q?6l8t6PxKKDx4qQvnl8BkPc3p1mtvZ0cYj9uq1rKSDWHwCPXRJEj1JsVvgGvM?=
 =?us-ascii?Q?khNLmVjoH5V9joMJZdbGAqrkad+jZIhFFuP+zWgyhfrMuY96SQWUiG22r+1S?=
 =?us-ascii?Q?4/N8BkI726W+sYnyle+H+jw6dscUreO3PDnjD/KOXvCAGLRbrddZOEBjtv2a?=
 =?us-ascii?Q?L3WXDPNIkH+4ym4hDcqvbZkIhdnQXy7u2c/5k0CSIqBMq4gYbszKakPP2El7?=
 =?us-ascii?Q?s8E5Criq8iOSanAoorO5GLzraE0ggbVpv4xGfLURGoMs2fQcQEBe2lGTKjyr?=
 =?us-ascii?Q?nglEBXeKebB/eiqGbYdpLKa0s3ZIJaBFZsj6r3D3ZQDed+bOCUthHFTNzfB6?=
 =?us-ascii?Q?iMXcsNFLFpCn3Eeu77vZ6QVhidHWc0hAHudfV3den4FNETetccFf/hPfpg/p?=
 =?us-ascii?Q?5t8MCFeCfhHBiA1yXSk7BoCwxZx1rHjaz8CknA70qiQR35inB+c3q98u/p8O?=
 =?us-ascii?Q?mn1jrhGWUhIwI2u/E0kLzDMmkGXLiGfZfq+OadLkj7ySrQLNXyYrsLnMyUIA?=
 =?us-ascii?Q?jJGMiOr90N9MgSn6e+zM5NEpjq4E65HsR2XNWD8bp1kLta4sDQEknFTHGHt8?=
 =?us-ascii?Q?+N3uuLw2HQp2C2D7GrbUkFXXItzZ05ABpbTji4FRrc3MhcOq/EY+NH8rq7Tk?=
 =?us-ascii?Q?d6IM/GlXwD8+IifIT2E0c5AcqnN17XSC9yMvso0hzkrD634Js7JHMD9kWEFK?=
 =?us-ascii?Q?OUPm8nQ/EuhuJkxwCETXShjgBI92tcOoSXyx54KUDPxRIro3nrVD0rTWriMk?=
 =?us-ascii?Q?b2myKFHzbdN6DxT6O/pQCr22s84Z9fVKxMhR9foj9v168ZRensVPT65mdI3l?=
 =?us-ascii?Q?t6dmZzFN2sRm0W05ETGHjdy+MJTDo9GnTjIu/8RghWkFughySkSdUqOWjrtH?=
 =?us-ascii?Q?0XUYKobYUKEhzet3KzxVCHPN8kdT8usciDexROl7pV2PgWVS0D+gfluXRM5q?=
 =?us-ascii?Q?MlJZZUkBgCZAPtqwhkc55DWDtIL6ulhcFSEPSvcv6Ss0e07sjfXKMAm4s1os?=
 =?us-ascii?Q?eCblKLOcc7aFLJdoiLPptoWTjTlswb9losmx1dv9aGOWoI0HLIaFGwC11AeE?=
 =?us-ascii?Q?sWQnnsjSRz3c06Q0voNBCN+bcL5HKaR40unXDfFCYG/aP9ql0sRP/MJQ3gT+?=
 =?us-ascii?Q?94FLojFXvuTCu4XuD8nnjglM62rrMt5MGqTiPNyasOcWeoiYKWFNM1tLpez8?=
 =?us-ascii?Q?xWDHgeiplKVnEhCLHoFs+JMZQx8n2NyFJiaZxkGLM2Y+omweejBgR1gJI/ta?=
 =?us-ascii?Q?SoU1MTFN4v47kcBaDejdG4EqZtOoyACdytAGDpB215EtsBpWe5C2LKFTQzgM?=
 =?us-ascii?Q?Cc4yAzr6j4zMV7v/zve19UBP0FG81KkcmlwIAos6hTBUS4zVZfcQB/4/XE2d?=
 =?us-ascii?Q?Wc2J9QZj9SdBu4/8GsqImCjTFEhCOSZrcYATqkP3PJ+y1hqHA1eJbld8fKzF?=
 =?us-ascii?Q?Q1nMXQyTjYeudaq5/nd84EOOWLKqv46kn0v4IN8vcyretGKAmbcZqU9mjRSn?=
 =?us-ascii?Q?S7g+oCYv+LtRdOQKu5XlnaMeQZr3XOIbGc0Fjxm3MpDdR10iDkGarppk/Lgm?=
 =?us-ascii?Q?9oxkf3GrTG7uSVUK1P06d5TQ0fCIiqqiS2uYeRiwXYSz7cVnTpux8MRSjmNF?=
 =?us-ascii?Q?6JqD24Ic+Z/fcD5uKMuhknw+cEJGk/pewod1h6qgofks1bve?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: EG3h9kD50lTsrKaC/o3GnvIYhLoqqU7zFke1vOSt3gbqEcCJF2TNTiOahy5ByDfF6bxuRved91xXkDyJaJbAzSnRdYHWkw/R+DENe4R1Ql/a86+itQEWPAA8N0VEwfcNynYpW4S1mmUDeMg4yGgoRsKqNrADiUZQmlOv66wFHh1fOEHw+gNVTyFv3yIL0M3zQ8VFk/RQEhGz8AqLqt4Ufhfnnjjr0zhDX+OopfY942M0JRERWAHI1BwNwyNr5YdzU3YyT0lvh4bfFakz7rDmnC2pnAFopZim2rI1lnYq5iBiikMl6qtM0IsErYZMjGKFoozEz8MbTibC7LM5DSqogA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2340fa8e-76bb-4c69-6842-08defeb9d9dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2026 12:52:11.0153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aLe3TCQ+cT5LNyJZJX+t+Pp4ajIQAAn+6XUxA7fUBgRS3s1F5DBKK2VY5VQ2x/Bqi9Z0HfbTShBw1wCMNpuCrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9741
X-OriginatorOrg: intel.com
X-Stat-Signature: 4q6d7phtcud59c3jk9kwb8fffmsdik7r
X-Rspamd-Queue-Id: 98000120006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787230388-352352
X-HE-Meta: U2FsdGVkX19FUv/MGPX/XRYP/NWfG5mniRPe+P5xxSjbOrq7ktbalyNZ5tN1DIioG4vq8m/vkwsjG/lDJHX3u6o2TLTpyx82yk03GWjCdASGTCci5qlM0dK9+OPkBAgCJerWh33z8t1v5/7FY2yc0HbG+umrG09oSoOWplfd1dqWemyXWwy9kYLIRyZbd6Po2+eCm3DyjDpD7kiUN8peW/+bh9XUAH/h2K6U14smeK8Ajvn+S4AYq6Z0hXBgus64h8Z+L2TQQp/DTSVjA7GDVb8FxenVcUkKaynrvndIZzxH3ixBf4+KxiVLWIofXhRcz09iLewf4fsHNmtxFzDolg+ohOma45lGIsWebpa+BtdPkUhcJkV58kQBlAcZ8f8AAqQjziTv7zVn3TRW4Fi+2gvAib8vp1NVyHBOaBR+fT4AG8J4DypCG75Na1QK7+gS0uYw6objJW1ygeKqYQkwyvAOMR58+6MH52qdAvie0fxuQIoaMpXuist/qm146AJdUaSPUJ/ZogCgnQ9shRc/KipMOGymo8gGJB2sav6jvRtsM804QAIaTd2a/1CUDmE731UEhoHtSkA4ILG0wGgUkvsfeI8Dq4sgby5Z+YZvU63+ITAg43IXZ+Q0KFp1KgPSkmZvbzPr4pwxt0CtJlmN88U7S1okMWtIn965xPZB81Tp6+8126PQId06q/lFJZe1euahFO41p//u6GuCNvnjPUrMBpUKcONcT/6RgrwRYQXrzu500YoxXEEusanKRLXWvXEg/lqfoIGXMas8+hIU+eETGCtBlRO+9LIcoWL45y6Q+MF/ftrs4cvZGCHWnusmjPetIhyG9npgTL3LWuImAub94cxfFb7Fktnap5StsoYH4UPfveVkrZMGzNXZwNSxHk7WDIFaHLgVF3qaI4fhVV5GdOj2+KXhBYg9HJF6NEg6nqEXf5zppOqJNLvRDqooq1jtWUc17FCDUPTFM3S
 mGCnhMDT
 c2G7ds9UvEYUCUvY+pnTX6YLzBAJIRcRrQ1mUWMU/Cmp9sOBmtgsOO+XZf0urtjxSrQg/Sr284pPjRkcI+W9vmN4UNHd+suprIvhyNWE6ZyxuF2PA7WcNdYaX5yLE9LoMALCyZeyWi/GwjYy3TNoL5hqGLcRzbobq1vm8k6XZBHhNanz5GAnGK3ZVeTxhUlHy4h5Xzxl3bOnjnE2wQzGMIsImEGl/Rclb7xbRYNvtDi9QWTezGlvFpO1Hg+l7jV1cYiMuKpEcSVGu3xVJb7pwi56E9gdeU4+0kJHoXu9PyzLdSLZOMlNSzpYSIXj76jxyap7YU2c+t4o7YghrvhFZKO0f63Ybveo/crvD0eaU43uqbKtvCOtA2lNS0dj/T5n1GzYbvk0LSjmNtBVAeqo40HrhRYY6aaF/iIaCpmjzY8x7TjghmMULwnSmB9CNDN7LaZRjUxbR5LaWwmuZJ6nmW2MpH8LMxL7mmQQQiFfzB3hs8OJmuqrecCE3pRJ7XXxClfKGreD07IwwgcthOYr0DFAk12AfN6m+6f5q5lJuiRRL0dTzI61CYjAQP2fpuYiw+SAXw2WuR6sKcv+40q//I00jmGp1kEEgKuIrH0Jb6D6bJ7pnaHvcu+loiUBJiMvRWD1tzfUknLtqhberHV77IX7T4cYhKsVOrwM68qcd5QDvInTzH7OAdfaKyYrRJzlnKoSxlzPfc1694LgS5G8rwqhw+QkoF0bdtVvzd5TJw5Z+2wTgSRvk6juN2XR6cYyMPeECIizPoliwFWeD3xJsNcrgGb+hrJljry/660Dj7eYe6bdC2SBI2Khg3kD8GpuCnyYx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Liu, Yuan1 <yuan1.liu@intel.com>
> Sent: Tuesday, August 18, 2026 4:57 PM
> To: David Hildenbrand <david@kernel.org>; Oscar Salvador
> <osalvador@suse.de>; Mike Rapoport <rppt@kernel.org>; Wei Yang
> <richard.weiyang@gmail.com>
> Cc: linux-mm@kvack.org; Zou, Nanhai <nanhai.zou@intel.com>; Chen Zhang
> <zhangchen.kidd@jd.com>; Liu, Yuan1 <yuan1.liu@intel.com>; Zeng, Jason
> <jason.zeng@intel.com>; Chen, Yu C <yu.c.chen@intel.com>; Deng, Pan
> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; linux-
> kernel@vger.kernel.org
> Subject: [PATCH v7 1/2] mm/memory_hotplug: make shrink_zone_span() more
> robust
>=20
> From: "David Hildenbrand (Arm)" <david@kernel.org>
>=20
> Let's make shrink_zone_span() more robust by checking in
> find_smallest_section_pfn() / find_biggest_section_pfn() that the
> start and end PFNs of the subsection are within the zone.
>=20
> While at it, clean up the function by factoring the core check out
> into subsection_overlaps_zone().
>=20
> There likely is no need to check the nid first. We require
> SPARSEMEM_VMEMMAP_ENABLE, where pfn_to_page() is cheap, and
> pfn_to_nid() on CONFIG_NUMA would call pfn_to_page() either way.
> So let's just drop that for now.
>=20
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Tested-by: Yuan Liu <yuan1.liu@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> ---
>  mm/memory_hotplug.c | 59 ++++++++++++++++++---------------------------
>  1 file changed, 24 insertions(+), 35 deletions(-)
>=20
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 7ac19fab2263..cd82e79f0782 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
[...]

>  /* find the biggest valid pfn in the range [start_pfn, end_pfn). */
> -static unsigned long find_biggest_section_pfn(int nid, struct zone *zone=
,
> -				    unsigned long start_pfn,
> -				    unsigned long end_pfn)
> +static unsigned long find_biggest_section_pfn(struct zone *zone,
> +		unsigned long start_pfn, unsigned long end_pfn)
>  {
> -	unsigned long pfn;
> -
> -	/* pfn is the end pfn of a memory section. */
> -	pfn =3D end_pfn - 1;
> -	for (; pfn >=3D start_pfn; pfn -=3D PAGES_PER_SUBSECTION) {
> -		if (unlikely(!pfn_to_online_page(pfn)))
> -			continue;
> -
> -		if (unlikely(pfn_to_nid(pfn) !=3D nid))
> -			continue;
> -
> -		if (zone !=3D page_zone(pfn_to_page(pfn)))
> -			continue;
> -
> -		return pfn;
> +	for (; end_pfn >=3D start_pfn; end_pfn -=3D PAGES_PER_SUBSECTION) {
> +		if (subsection_overlaps_zone(end_pfn - 1, zone))
> +			return end_pfn - 1;
>  	}

Hi David

Sashiko[1] pointed out that the loop can evaluate an out-of-range PFN
and underflow when start_pfn is 0. I'll change the condition to
end_pfn > start_pfn to address this.

[1] https://sashiko.dev/#/patchset/20260818085702.3395529-1-yuan1.liu%40int=
el.com

Best Regards,
Liu, Yuan

> -
>  	return 0;
>  }


