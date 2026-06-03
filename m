Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D7CCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05E4E6B008C; Wed,  3 Jun 2026 09:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03AE76B0092; Wed,  3 Jun 2026 09:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66D46B0095; Wed,  3 Jun 2026 09:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D16D46B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:11:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9167712030E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:11:46 +0000 (UTC)
X-FDA: 84838638612.03.774EA29
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4D49F4000B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:11:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Tcs1zdia;
	spf=pass (imf27.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780492303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vQ1RFNL4FX/Qxd3n815JEfqWSNNShCF/eCnZxYmdal8=;
	b=MEcP7xR2xKNkxpCajsZ5c9TCUGcNCHKeDja8uDqQRYQtQeSLLDeBQoKJDh4kEmzohAZk79
	+VSqKJZQjIBIq0lelHcUAVzSf0jX9PMzuMNox7Anz63ju/W+1heoFlX7uHXor882frL4VS
	vFJBW4gDKmR/NCw4KgIJr/IjpUfPl8k=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780492303;
	b=Q5Ga7CQef6g3VaeUmkvT7l1kJX6vxZLAkPRL95O1WorhAZEe4Re2gRv87wTOwf4k1qHYm+
	CB3b0U6IvZXT1TzfMATNRxm07b8RD3s4YW8g0/imXjFSH4I8T9Q+vgDMJBAQqXQuuVbJ0R
	49FZPfs48CxH1wdX5ymSYWZIcXl6qOg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Tcs1zdia;
	spf=pass (imf27.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780492303; x=1812028303;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=yC3fHjwk3C0mMORaWR0Hydbks6yDP+oxfb4ix1M5QfU=;
  b=Tcs1zdiakvWehBmg8ko4rZhwBU61OWbTkr8mzkQFy2AyCrGHXq5Nqnkw
   4lwvkA21tfGZunmHde+fws1Iht0fA62+uoMwxjXK+D8QpkTW++pcuDEhN
   uzMq609PGM3CmVzfOmNBE2H3LOjJKbDffN4ZzyMpSr43qXpDfJbl+QBCx
   8kYOaka/G/O/z01S4D9/REYD44nJV7BjobpCd+v4GdkTjJQbQsswFpqls
   ZytNH/wj01j8MwwGsuXoTQRxSXXm2UW5Ar4wM36oWao/BV6bWsn5/GIrD
   cCsWFTum7EHKJoaLJsIV0hPSNQWtzdaPQBPLjn+7XYPz6gnj5gbvBNjfd
   A==;
X-CSE-ConnectionGUID: AcasW2OXSDmhBTGy6XVhMw==
X-CSE-MsgGUID: HwlDjlvfShiX1b4ZpPjEZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="81360241"
X-IronPort-AV: E=Sophos;i="6.24,185,1774335600"; 
   d="scan'208,217";a="81360241"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 06:11:41 -0700
X-CSE-ConnectionGUID: e1aT7+gST0iDTrerxqErrg==
X-CSE-MsgGUID: /kfSXiKsRvilo0vpfg/8rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,185,1774335600"; 
   d="scan'208,217";a="267891582"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 06:11:36 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 3 Jun 2026 06:11:36 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 3 Jun 2026 06:11:36 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.31) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 3 Jun 2026 06:11:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UPOmO79hEusbsTh+5GwsaOdkqQt88KNjpFER2Lqb8evr5BdWwZT7c2cUqTo6UWLUtZDeyj+zv5EJsyh6srFN9i70RfIjR+DuCT52VtTcV+fri0JilQ5yAFWNEHHx+8MbyXiP7LC6mKDKjr8K27e39i/3G8rKUf1S2Y5q/dig0+jcvviSpU/SC4XXcMW5r9TagdiPZZGuDwrK0jObhlLdoWk/QvznyWUuXFawK4Wcj7foE3Bvvd3qDa0ly99+/LASiupPEAGuGl/jDw9PPWVnkomiEQQWuzaskY3Y/1LCZjY5mp2QtwJ5sukSwcYoubiHFOhub3OaFNB80dM+W/BlcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQ1RFNL4FX/Qxd3n815JEfqWSNNShCF/eCnZxYmdal8=;
 b=VEfxr69Je5ZtgpW3BENNXSbT7eIn5oINH3iR+4qSm2qDSbgIK07rP+kJ39dK4fHTe2FwDpbZk3AdH8IqSGEN1EkA0F4Z9dwoK2FwtyjQfbxm0llqOodNAvyPdaDg5rW4insYnnDwvoU3sLrSoPGP7FzG/UTUAtGov5MhTfyKZXob52OOuXu7DSO5cw74/6Kzey/aAnfDKdO0jZTgC9+DthMnAJ/DVWWvsUAO6Ya2rZQy74IAszOZSZ+XcC42E6r+C8ivN6GPpNP90WErK/fQqeeLBwALVVEWO5fM0gOqQI+JKBIGQZwtdarwEpU5fXq9FCXMD4SmTC/cSsA2Ck51Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17)
 by IA0PR11MB7752.namprd11.prod.outlook.com (2603:10b6:208:442::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Wed, 3 Jun 2026
 13:11:33 +0000
Received: from CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::5670:5b2e:6ecb:dcaf]) by CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::5670:5b2e:6ecb:dcaf%5]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 13:11:33 +0000
From: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
To: "david@kernel.org" <david@kernel.org>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "mchehab+huawei@kernel.org"
	<mchehab+huawei@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"xieyuanbin1@huawei.com" <xieyuanbin1@huawei.com>
CC: "Lai, Yi1" <yi1.lai@intel.com>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>
Subject: mm/memory-failure tracepoint change breaks userspace rasdaemon
Thread-Topic: mm/memory-failure tracepoint change breaks userspace rasdaemon
Thread-Index: AdzzWUeryVIHgoWJQJyC7gAz88QdgA==
Date: Wed, 3 Jun 2026 13:11:33 +0000
Message-ID: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR11MB7134:EE_|IA0PR11MB7752:EE_
x-ms-office365-filtering-correlation-id: 4d91fb77-3d1c-4ea6-ea87-08dec171a23e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|8096899003|38070700021|11063799006|56012099006|18002099003;
x-microsoft-antispam-message-info: txYcNwUfB2eWpTX7Uq5t/Ko+W6lqiftXlHRdO0HhNAW0nCTnJQGziDozEG36+I8avU/ocmqTqLFuc6DYD1/V8xydV0YwLsVrv3zgtZQOmC0yc20dnNk/d0tyq0Ji1ccICDP0y1GmFWWHqJylVRocclSnag0tkLQmkwcTGOHnSRJGEIM/XqopYb64KxsLJUl1K5SiRCdNM6BLBvP0Iig1f1h6gODcpbPlNLwU98jy0aYQKtpNzqD0VV8o2vQijk4+I7fBMxsw95a6IuqwFnjK/pIwZoleYo2b2QrIOR145lLAjvHCPEJCl19eOzg+s1f9R8qCymuZLV/gogp0IC1hboeVH0cZph2w2ceOtTyl2G8QxG/RjczUkypFFrV8Y483m3tk7+MBlQhUB22aAGgp7OebriXEEwwrIn8TYLu7xq8mN2Yh4T/FuqoXwT1sd1vkCL0qaAT0E3AfmgzXdtAVFudxSScOnwqKI5ReRLm/sV+6KOwthFYQfPEmb1cwErBwSDdly2sFsHDlj1D0qy62lvQc1mQZHjmMuW5/RZ6X0furDmD2wEaB3ITgMioAvFRnZQ5LPNPfor3wFp1ZwG92z357Zqkz4554Jgp4y0Ywy6pZzLSYnl4VPIQJI+bnzqCS0HvELSvwxs1vmbaDo6o6xdPTydPyosPKFO2bZt05gzGHBqt6P8ys1dNbCCp0boc136Ae/YeL5k3IYi7EalsFm71HALo0A0hm4BFOo/7Fhm+811L+KBv8gltyh0lUoe7O
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7134.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(8096899003)(38070700021)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ltHMoZkPutKqPcuaSWv/oT1yGWBwIdO7RYAB7/8oWBlPtlfhzLEJFMqs20Sd?=
 =?us-ascii?Q?jWyFuOLenXsZv3DF4U7dsG9yrizq+9FUMBgBPZp2FLB2KRjisGao3eU74xUM?=
 =?us-ascii?Q?WS5jpuC5wEB5NReoIF2b/swXVsz2r7tWuyFTUMrMnUEb9nFLBj7Tp2lJ3hrN?=
 =?us-ascii?Q?xp9iGSEc2kQrWPwgrRtLjz7n2q/MkY5ImI9VFD4zpKsXmQXhN6mUt16M0lPG?=
 =?us-ascii?Q?576KRPW4BQZfaB6srSxTBYM91CwnoDVluA3t6xnCD7plRENEQU8yxYCO3155?=
 =?us-ascii?Q?s+09ChTp4S4AJsGiDnM2+PkhttaHGU7yNpCbH5rvEs1x5viRRdfXSkzo06Tl?=
 =?us-ascii?Q?J1vI0+WRjNNyEfWEdXnRW2+d4Y0Mg/4W6FON7HPGqpW6yVgX2ZtxtmvYBf8A?=
 =?us-ascii?Q?qqUwMgCO+Ptj2hG0DWS/2Ff56TDpXee+hw/Fmsi0tJ8sEHJo3EKXYyMFXYRt?=
 =?us-ascii?Q?J9cMcknnYnmAzE6/FZnLGUpOjwAM8OoY5n0SbOvcId7+xPaA/BQfUJBI4T+o?=
 =?us-ascii?Q?iG4ijwsFBcLLknDte43x39kbz9YzBVe2eAE2VOmbPQo0alLMWMzXnbmMSBQs?=
 =?us-ascii?Q?GfxgU8OFXydA5pXz0wVtD2vGKLkuLciWvW/VJvDWDh5HXKeYwcuNnueGIDK3?=
 =?us-ascii?Q?xGBnjAM9G0fq/VJNkyQo499YI6QV9mzsISujMYSUxRZPDcp9voY32+JvB0px?=
 =?us-ascii?Q?1P/et5qKDO0m9mOYNDklNuHBHYWVwS40Jkq6YnmWews9UsIvUFSZ6vlUDWWD?=
 =?us-ascii?Q?MdVU0scK6Ycor0z0OCzDGHgqJuV/3uUB+XIPvp93Zj9TuzNp5jijubSUhK8l?=
 =?us-ascii?Q?UFLAyIngC+2+7vAkE1UTrnJq4T62bG7OGQxC39NLVTK+xfXPrhgI75rAr242?=
 =?us-ascii?Q?5HIGzYDeeVADi8eNuviidFdmFrjgVaX3IML9h8fSiD5xHBWIYHpRHjftbxbr?=
 =?us-ascii?Q?y3/Cmxr0ItXic7/DNBsHiuFBfeagYAGUUTkH9f91nyMfXI+cDaWVJbe2M7Sz?=
 =?us-ascii?Q?mh04tsbWvlgct0jA8GEnIaS3jxOEXrcXRG43NCrzogn22uz9V59YTVA5atRB?=
 =?us-ascii?Q?xviqDi0RxrKySZgjzwHRVBxOc7x5wp5uaGfsLL7xxYlvJHJsOvwG/f64RI2g?=
 =?us-ascii?Q?jTH9E5jwEj2/nSY3vzBB26lI34TdMRpPurMDg2g+dxlivZvficGqOyoZaMrQ?=
 =?us-ascii?Q?H5WXCBPTYlcF/EAea3bzwd079zmujTSPC4/eiMnKOHDb+92VRSJtiPpvP6JD?=
 =?us-ascii?Q?khiKWzifB6Wcff7O/i6iX1VrL3MFssHx9mbbmb7uO78Oo65q0nrWUazNJ8OV?=
 =?us-ascii?Q?DvOh/idM5g9tdyyUcSpcdHdDsJtF7TVXPkYgGegAmCT504fjpvVI46xx30FR?=
 =?us-ascii?Q?WhRH5IBVc9K+AhQZSA5Ba/HKsAJqdk/Q8A5oGXCyVx+oPTpGjt7AC5nX2ec0?=
 =?us-ascii?Q?3XIYdZkum/wytTGUTz9+jUhOdWHbzdGeZYSCQO2opO5JuOdpmYIc6nzWk0P7?=
 =?us-ascii?Q?39Q/nYoD8uunqQ/SR0oidVKe2eiS9d7J8Bmde4NIRCGPb4OynGUo5llgk/N8?=
 =?us-ascii?Q?Z/KJok8HIHo2LXJAyJhAgFcCk8pPkVczJ98x72bldFJgw//HaBMlnPJU4+eq?=
 =?us-ascii?Q?X/3nsk9Djc6jvCZsX6GMIxLSMnYAyekv2hVXXOyHcX7Fofv8l7qtUSgy0LCG?=
 =?us-ascii?Q?h/upPlhVL9yA+ljZOJ0d6l/kMeXIQ4uZiVc450AjbPIGL7bZBlCfaXT7VBUM?=
 =?us-ascii?Q?s25DWmEuLg=3D=3D?=
Content-Type: multipart/alternative;
	boundary="_000_CY8PR11MB7134346A3E4BB28ECA28D6E989132CY8PR11MB7134namp_"
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: mryeOn0ilTQSD0n6m+0n/mo0AvcGh8TSUTFf7vgdnN8qQP5L9athzrfQ36nZV82INR+E1hh0ihE1dXd8t9ex69aY/+hPeTqfBAaYHKjgAGDAJzK2ZQ7veu1fpAAQR/jQOqIfZXY1jQ0UTJp3aNv6rXjEe5iTKGQTQrBTlN5pTgTsI9lJwLbrcccdbQnxWVl7dQhQ5TvDio0wyW3ed+p5s9faJxV6QHv1t0L11yGMZKtoAfbYt3NpFozdI4Qc6YYuFG+2Fzv9IJVK95ekoZXkvTPnwHgGbL0R5ZgKfj//bpXRxx8jKt/CD3qI3uD6hbvwHpzO/A+DpoBP52IGqciuZA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7134.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d91fb77-3d1c-4ea6-ea87-08dec171a23e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2026 13:11:33.0426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SvqlUIRj5g+gsYR6186LEj5oB4Rod2IWMwA1B7i0a/UIgdqf2Rf3L9yZ/U4tcQcRNPemUe8uEsNt0Wn0my/g5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7752
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D49F4000B
X-Stat-Signature: i8pry5npbg9cnhfzfrmgwkzxrkzwu1mu
X-HE-Tag: 1780492302-949993
X-HE-Meta: U2FsdGVkX1/6KpJAdnYKwcdlsXcTdcwLI5n+z6j3KvSPX3d6O7GFuNpxWjy+QTEqpQIcQS962HxZrYvPaCS6FujL2BMbVtRRv0d5rEnQUoN+wI/+nFFh8/xlFbU5mrDmGEo13SM5QpcenP5cOVO/qpCkUobqkLB7LDEq8hPw8aLuUsJKgabyWQiqM4MM8CBO3CtruSxFU0zJtWvaRuT7CQ1m/ohU8qUjpoWRbwid28MXB3SEDJhpz7S96X/VZgDjCdOsofDAJpXIjF/QIAB4yoIwTbWWNmXY9Q/40kyS/Gw/wt31BqnbKVMNxXBhwazK7O67et4IrDNn1bsDW3yF1N8o2BzFRugpyEV6SB1IloD5P5Qxkn7aXfZzhT+Z/qJUY9WMvFVe+XtFthD0QHMaIzwcyi45yqsAGL8l0hVstFHWjdcMxSsa58tE++uX+Z8vmtvWBHk8M6MD6+hjzMHmQxSLbEGUr4vreHXRUDwCdiQd8IzBaR0oeM7XmbApgv00Qmk1/4iiJWfqEc27XvYRbSilS7Uyxp5laLEEMwADPyarw2eXobbS9qfwMVCUA7pHM2BQDQPZ6S5jI6+A8oQxN/etieTQJzGTqeXaAzSrDi5MyDsmWPifYQL9jl/0QHipPxtFvWMX5CFJSTCTQhIqCyX6UHyqYeNU2lOD1QUH700zeRgLcdtio3aBFtdrLEnmXyCcZuMAhf5YkxFlviNl6BkbMc7hg/1r4+hbCi5jZM71UupEFLFCGI3XGPekgRDhgHrgvGif9Hp6H8qE0OhrDWQNjyAjDuRJQel4g08hm7OML9rAGDPoS1fE1NCQ6TY0is99UQSKgUPE3srnSC3YDT1jyEh9L/9KScKoIaqQIFpUR+jh5mOK/HKzvIAjS+MtTYHrbfy+1ZrLOXkz8VqE/3x/lFwoDvJDucKT3G9orYLeC+6uxJ60qzbp+sCyPTblnorzTVuHgnq9UWA1ZjR
 9U6S7ZFw
 U4MyIZGCqUy1H4pleDLP/OVD/1oZ+ZrczVxjzlXvrECQ6u4OQXMdp2rGMTMiv2dOlekWopGJHWlr8QGWzAzxuZoJdEN9mrjEUPhcOexVQ8OJoFNheFNLHNTpIPJWPxAw0Ddswkeu3XTj8ueKfltbMi4kDqd7OdnSwOCL2RRaLkH6K408zMS3k+r3aYedn+GV/rNBMrukLXN3rLXmGK0EIrPUcpjGsoXCE4LQdcy8wbpEwFOIFkUKPjHTeJu51m8voHi73ozFu/yAtfrUQ1/XRoMmvn7chBkTgwxtrKWwGlg+DBCdSOKRFwv/Hpxnxlv0Yg5/7VHe3oJPLFIZgm8Is4adfiP7ku/Xj25W+ZYyGUtkAbce3PNwyIbGr3cmw+gbW2Cb9qQCcgbv8En6SWmdEmkwiFoMbHSmamaw5AMELmPHdLXTgcF2fCZCH6ffSjjfUVOYAJ27/tQw6wXh6WV7TL4j+5iQdoB2wwAbYoX4RPRrambUqG2dKrNScq36Mgv5Fq+Bfus4woXDkX/57Xwg7PRgDGppJwMIrTa1+VJ5X+xUEVgFYxBJMeZmamg5ulFyAJaxoJP/1hC3FSrcp2M72BLJTW+jcmbM2m5DKxrd4IONWq7Pa/cJ/UU5faVvFlsbjkzUiVHbHryqAZEm68Kct0RU+Ffw7xQgv8Kx3vnfNkNQrLav4qsWkzlfD/wktVGlTwNOEFqHzvPvBKRqGLqnTNMAMHIubOOgTmILl7tW5Cwchvc79RjWNC/nHjKEeF2T96Dh9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_CY8PR11MB7134346A3E4BB28ECA28D6E989132CY8PR11MB7134namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

Laiyi reported that the userspace rasdaemon fails to enable memory_failure_=
event on kernels >=3D v6.19.

Kernel commit 31807483d395 ("mm/memory-failure: remove the selection of RAS=
"), merged in v6.19-rc1,
moved the memory_failure_event tracepoint from the "ras" subsystem to "memo=
ry_failure".
However, rasdaemon still tries to enable:

    ras:memory_failure_event

while on v6.19+ kernels, the tracepoint is:

    memory_failure:memory_failure_event

As a result, rasdaemon fails to start:

    ...
   Can't write to set_event
   Huh! something got wrong. Aborting.
   ...

Reproducer:

    rasdaemon --enable

Could you please let me know whether the preferred solution is to revert th=
e kernel change,
or to update rasdaemon to support both tracepoint names for backward/forwar=
d compatibility?

Thanks,
- Qiuxu

--_000_CY8PR11MB7134346A3E4BB28ECA28D6E989132CY8PR11MB7134namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:DengXian;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"\@DengXian";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;
	mso-ligatures:standardcontextual;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:11.0pt;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72" style=3D"word-wrap:=
break-word">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Laiyi reported that the userspace rasdaemon fails to=
 enable memory_failure_event on kernels &gt;=3D v6.19.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Kernel commit 31807483d395 (&quot;mm/memory-failure:=
 remove the selection of RAS&quot;), merged in v6.19-rc1,
<o:p></o:p></p>
<p class=3D"MsoNormal">moved the memory_failure_event tracepoint from the &=
quot;ras&quot; subsystem to &quot;memory_failure&quot;.<o:p></o:p></p>
<p class=3D"MsoNormal">However, rasdaemon still tries to enable:<o:p></o:p>=
</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp; ras:memory_failure_event<o:p></o:=
p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">while on v6.19+ kernels, the tracepoint is:<o:p></o:=
p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp; memory_failure:memory_failure_eve=
nt<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">As a result, rasdaemon fails to start:<o:p></o:p></p=
>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp; &#8230;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp; Can't write to set_event<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp; Huh! something got wrong. Aborting.<o:p=
></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp; &#8230;<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Reproducer:<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp; rasdaemon --enable<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Could you please let me know whether the preferred s=
olution is to revert the kernel change,
<o:p></o:p></p>
<p class=3D"MsoNormal">or to update rasdaemon to support both tracepoint na=
mes for backward/forward compatibility?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks,<o:p></o:p></p>
<p class=3D"MsoNormal">- Qiuxu<o:p></o:p></p>
</div>
</body>
</html>

--_000_CY8PR11MB7134346A3E4BB28ECA28D6E989132CY8PR11MB7134namp_--

