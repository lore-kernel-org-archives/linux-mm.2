Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6372C8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 18:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7D88E0060; Mon, 25 Aug 2025 14:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86A18E0038; Mon, 25 Aug 2025 14:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28428E0060; Mon, 25 Aug 2025 14:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 87F1F8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:12:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21A9D842B6
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:12:37 +0000 (UTC)
X-FDA: 83816075154.07.42593A2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf20.hostedemail.com (Postfix) with ESMTP id E8F231C0007
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:12:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FEsS2BAF;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756145553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mz4I9EJ/5OrrYdnRzLgbMsjuGlrAARIfXbsbsSnpMgM=;
	b=js2thu3+dHHu6fl30fdkh4e3DGylMWB6y+UuCSutDKIMnzcEsW6njsbSm/5k/618DdJi8S
	WwDvTkaUp7q4ilXN06hIEoLddPy7j3Lr4yWhtTqr5f4nvG8jubbISvPheHiqoWFB0B53D0
	V9Ca0NP0zwxHOm5zZivrXX6yPjV7buM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FEsS2BAF;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756145553; a=rsa-sha256;
	cv=pass;
	b=JuStx1YVH3cQ2NS2Vj0FZHKQTuqJtfIfsxSoES/QPqX1dZXEUnj3UTZv5ZgjFdljL25ZWe
	jzi/ZtpBWKXyLBlgIx2E0ti/ZezCJcqaCbYeDaz60gTZutPH2HoAwaEN4dmThSXWRF9Wd9
	ETKce6Z6D4dGjEyygmAmciS0vkinIuo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756145553; x=1787681553;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4Zyj6S4yJTSrDRu2FP8ykglFXirBg/ppB1oTY8mpLeE=;
  b=FEsS2BAFltGpdfm03XGXnlI0MB2LIu6KWj6ALJpwpNYBu1o8SxNDCJ5C
   +NDc/txmu+n5z9bQDYKEPbVs4a/1p1vIBqq+GhJfFuZz3ZFrEPzZf+ZEq
   E/zrZoHX2oClY6/sfHyOjfbvHS5oafV1Xa3Wpqvv7JivupqUuVpaM5dUz
   SbCgtS3iAUOhWWkoUtYDFa7i29FZdTeHro1OYeQIcpHBL5zemCh3IeoQB
   TkE6ptaAaxYJITKTaY9TI3/Xuk9RwUze27LjwTmdyhfpwwWyClboPFKRF
   t01JCSpvnPgc3GNaBIloyVKOAcwjgEo6z/Y0Oey+U/d0oPZf3oQdS6QCQ
   Q==;
X-CSE-ConnectionGUID: Qd2oEiGtRsSi9S6XrtAUxg==
X-CSE-MsgGUID: 53ieQ0sAQby1yc/M+efDMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="58467560"
X-IronPort-AV: E=Sophos;i="6.18,213,1751266800"; 
   d="scan'208";a="58467560"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 11:12:31 -0700
X-CSE-ConnectionGUID: mDz/Vm+lQUqZj8g8VwOFhA==
X-CSE-MsgGUID: 8YjCdpxPSzOF9ax2YLx6pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,213,1751266800"; 
   d="scan'208";a="200254149"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 11:12:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 11:12:30 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 25 Aug 2025 11:12:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 11:12:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OLIj5hRyMNkENifJnwefpvyfSq/KVSKWcmuzpA85kYPjsm+RUozI/xT6fEIePF2x4W9ttEGamawFHBUiMUchbYS05wc42ce++pk7ppEhlkTzBdE0ZK83caHO0QE626pHUvJAIzWIzVYQWIujD8X/Z8yjOxpLqB7Ici42m+VgBzf9CaHju9NSOn6ujYX/i5zfEib0HJn1VNKmaoqUVPwM0h8nzvpD5xzy/1sC9XBx44YEpqwOJW0eGsviL1Nae8G1BKzTmfRXokJBP3uJiJT7w+WDbggdw//Y/epjAVNkrMG9TeG+NYupcuhfnuYo88CpTfGDARKv1xSioviFBKUcKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mz4I9EJ/5OrrYdnRzLgbMsjuGlrAARIfXbsbsSnpMgM=;
 b=eXpAppjFw7Xq7yxZTmUVPCvzy4ToxrN/2wcz0Y6mlb5lbVcLww6oK3klHwQTyzvOoqCwypnvfH+i+HQdghcnzLsJYyENGIckCSyCvP0lvf+T+7HsAYvlUOSviLPFrprkeFbRjLrottFcxGXRVo69/+/y/42ehqENm/i3soZz0f+H06sWKZ7FzSy20K5uA19zIRmK8GPTaXAg8DGorqpnIuaLIyQokSFAYCN2iRg0TDWpcvQ/NcqKa1KIu2S0iLbREBjzMLWAAIDCFbfiCjeQdO5cMahLzOsWscy929hw1HNfq9c9KKq1ytonj5oynYW2DPwJ6w4dU0Fu78QiG7Xehw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SA1PR11MB8811.namprd11.prod.outlook.com (2603:10b6:806:467::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 18:12:19 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 18:12:19 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Nhat Pham <nphamcs@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev"
	<yosry.ahmed@linux.dev>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Topic: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Index: AQHcAp3n35LtSdVMgUSnKQGImY3Y0LRZeWoAgAnL+YCAC+jI8IAD0bOAgADL1oA=
Date: Mon, 25 Aug 2025 18:12:19 +0000
Message-ID: <PH7PR11MB812163C97D4C533F0302FA20C93EA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
 <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
 <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aKv28XTvAITuq-p8@gondor.apana.org.au>
In-Reply-To: <aKv28XTvAITuq-p8@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SA1PR11MB8811:EE_
x-ms-office365-filtering-correlation-id: 02ddd78b-30cd-4493-924a-08dde402ee5b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?gmYonN21m9CGAOGU1jRz3OLPqE0XxqvezMSlzSZP5iwHDrKrTotPrbTVv8V0?=
 =?us-ascii?Q?RejdAVYmCCMn50ZS32CgAtgXvpiDOKFTFxNQcUE1qwyxyndOJKAbZcA1/GNJ?=
 =?us-ascii?Q?z4rg12G9PGCrSqb98xqdSOWr2Q0jmFWTfri3A/bmokjoMRnnFckWntAonB9H?=
 =?us-ascii?Q?I1i7I9syvpQRG3sqvTaYihcrq+pD257opGzeE+6td033vRF5d4bF+Enq0C5N?=
 =?us-ascii?Q?t4K/LFy2Y2mM7k82yah1SxRAX0zpxBlXsNaLSmNNLnMajo49/rOgT+hfK2Uu?=
 =?us-ascii?Q?NfzajZ0vqDe9KNWc6zgp8BUNewWVDEZrIIUbN6rYlFOcKDVXxQZGckvG8kgW?=
 =?us-ascii?Q?jpK7hgP1TQfvkhhGNm63A9vHJ5wTl46LP2Ze5TN27t9jrBbI4ShZjHpZcEE9?=
 =?us-ascii?Q?broIHH3Ic7XjVzvYEgvuBA2Osd80drjZskZCKYVKu+36EJLcgIoZ82mPrupT?=
 =?us-ascii?Q?zRqamnkoTEA+Xd3Eh+eJAIEQdAibISUmGGxADsQl9ior1ECAFP2Z29jkbUOr?=
 =?us-ascii?Q?ArLe2GKxEzpH3OZWwIfGgBpCiXm5QZK9rnRA1EOi6Mjax/EubphUx8RDMwTJ?=
 =?us-ascii?Q?/MElhzgRjaQGIBz1x3k0PuySGTAz6PRzmVfAMqDe0a13mmVxld80EXecRBNA?=
 =?us-ascii?Q?7fqfKyiz2eQB5hUzqlqaX90ENRuIZNG4o5uk+9+UcY6tJbQe7rGiMB/kKo/V?=
 =?us-ascii?Q?rgJ/vm/IAlNACsXPNgeFF8BDydFSyRG9Zdnm/33Nftx7ycvSNFvTNLasaTlS?=
 =?us-ascii?Q?Hc3ghZt0DEsY2BOg4gJ0litrQ/eo/qanZDC+0zSBQQmkWMyIidvdXO9DuHZa?=
 =?us-ascii?Q?HQVSr+2exth5JROM59JYZ14R+kEF/bluqsnXSpt1EfokP2bQRxg0hsLUGGE6?=
 =?us-ascii?Q?IMpgH0YMQVcyX8wvdR1g8JbihxX4vOzfkOjQivMb1rAeJtJeXKJA4EohM1lp?=
 =?us-ascii?Q?3LIO/xMS97LO/Jr+NG2WyYu3RaAM4HRyrn5Xry14Loe7aBBzLqRkiOdx2Uhb?=
 =?us-ascii?Q?nU6QyVrNvscVBp196q9hxexNhooPRek/V+vi7CFBIX7zn5ofHpmPQ6hmNajx?=
 =?us-ascii?Q?N+JY9hXBuAMJ/5wlfiQ9codXMpAd8HpXdfAs8f/YkiMDAMr0VE66zhzq1RXd?=
 =?us-ascii?Q?vJiCSaQmEz5AGjeTpJmwbJdCnA7LN4G0TbYF/tYg9OWfOrm03XBMaPTpd9fP?=
 =?us-ascii?Q?kkd3gBS/fceVxUOLfnbVjdBwd0FdIBVVFBhu4/S7/zH7+e+gUiROF+HiLLmI?=
 =?us-ascii?Q?vHAv+EWS9iDbPo9wKTnFNt6TCQq1IRpmUq0SaWFKHONMoJlvVBFE87sgWfAR?=
 =?us-ascii?Q?NtPO7iK0EgyRXYAm97roZQBpO3i6GfpZNIr2WAmHWnvr8OqzooCZOj70PbNp?=
 =?us-ascii?Q?6WL7IOU9s4soBAvOzeW7jon19FQ/k3XL1d4O18crbwhPdiZ1n4eKX2GfSwhb?=
 =?us-ascii?Q?7V6+DEEnbt0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oqCsUcF5x5RTKVJaalSj0hMQZrrNcPrUZeZbz6LfPxWbTnvgP7t+PjnHrLxi?=
 =?us-ascii?Q?UHum5GweLlL2XVS+SU8bZgLse3AB/V0K57p3drHPrNx389RKe/u8VVJbc94z?=
 =?us-ascii?Q?gLNXXDYhl6tfqllaXBMn8W6+a8JcWcBF2gPzzOUxUYPKXbXYrZVAIkjf8Wml?=
 =?us-ascii?Q?GTffXLQYpy3Znmvr2Zz7c3NjHQQ/WxOwEm0jpGrO7c4RqeeDcZJouEyVZWJr?=
 =?us-ascii?Q?XGr1xAhIh2a9K6iLBRRW6hJoquYXioBlxzXf+QNjyJQmnBgGbnk2R7lXP17s?=
 =?us-ascii?Q?C7cbCDGhQXr64BgtYOJNFfzr1aizs7paPL/RfTWXCTJEeonrtwLKjQdRtMOb?=
 =?us-ascii?Q?p1oL7XpNEh9f8Ejsx0+yVWEnuNYBwVgiMFKlgxRsiaAbVXiO9AA2Ff1bAY7V?=
 =?us-ascii?Q?52Inyr6q2p2Ij+5nHQYOmnM/p48N4Jj9lZxgDnqBraKgKj+bhrvw171+YNjY?=
 =?us-ascii?Q?UACgZyWxgihE1VkkbKx8YHvjfkqbBpgjE/uRvboyslxKW1zo5RaPeVavDOyW?=
 =?us-ascii?Q?4Kzbpy/0+jx1KDTQcTuVKh4UOxhBpoLkXg3KOd529yF0Wp7c5nnjcOcMVdtD?=
 =?us-ascii?Q?kSE3WkoozUgzxdigKbf2UUWLOebN82sqRK+bZAXx33ZC2ndMcnGWQaUB4hA/?=
 =?us-ascii?Q?NuN/m5u5RjEHz4VJihJvv8dk77TdlPLkJDKN/2y3spuBsjPuepNek5Mf7awG?=
 =?us-ascii?Q?zUHpfpC0AgifHyBDpVqeI92/j6ArYibhhPY4j5KwQ8bgXNDeB/yPIWDWg/qo?=
 =?us-ascii?Q?GUcmdm2HL3oaS2dd/eQBQGFAhPfSjBx+gW0w1vhsqNzST48ZfHYHiEWUFxkK?=
 =?us-ascii?Q?PtR89rFWRh50rNnQNcWScanGE5uvfmyY2GrhQwp6bNA8wyGtI5Lqmc0QeItX?=
 =?us-ascii?Q?Qlz+SaLpXbvqcldjPLDRMaAdpQdWJLNLs5pv3F3UZpzqVS7OQQGZsNKyrmMR?=
 =?us-ascii?Q?cum9VNXl13tdWvZz/W41ZQnxpDM1afBHK06TgdjyASG57xJDvx3E1a+xXkp7?=
 =?us-ascii?Q?GNRGgHb1ot+WF/wgXpBoOlGg+XehhCZysQ3YPIS5uhYqDZr0TabQD6hcno+r?=
 =?us-ascii?Q?oVKTkfBc3EsXbm+CB9HkOubDS0AMSRMOdMKL7/pEJJtwmn7ZXZGWGpzdJUTZ?=
 =?us-ascii?Q?lzL9J/W/KeGuc5OFAZGRqeGL0Tr0l9XudxIYbtoIuytYGvVgSTxqc+PFEsIZ?=
 =?us-ascii?Q?qy/gYl+LvHZ3oKIE22Lm0OX5Yvp4AV7l2F/LRvzM7oHdQWr6/HdWdtIXcwdM?=
 =?us-ascii?Q?0JUbu4UIKvJkNt/H4jwFPVmZbbM1WENs4lrYUyADofRdvDQEf5dEuY5nOCDW?=
 =?us-ascii?Q?MHSf5hvPUmCsqtOoRPMxaejJG5T3zPG/hmAHfuLBTDpn0a8OIwI6Vv1uwJwN?=
 =?us-ascii?Q?I0yhbt298xEP8LnnEiuqqz1ww6rtVqrVqVPIi0L7KBBi2F1ly7L8qU8cQKt4?=
 =?us-ascii?Q?H6Vxu3y4T4kXktrARNy/YRkqZ6CQtIuh4RPPjGJ6rXpAv/R9TztIE1H4hUps?=
 =?us-ascii?Q?iwE2IxiiGNtjxyXnGot5Sn4EFuFaK4irXBkDQYo9cpHoBkg/grfT6EqAttE5?=
 =?us-ascii?Q?EG9cbIHeKGRLGIbtYG2Og6KLrY8r/B4stVupkhEUOV7Lg7P2eKAzH1aA4m8Z?=
 =?us-ascii?Q?TQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ddd78b-30cd-4493-924a-08dde402ee5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2025 18:12:19.6073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oOEeH7QMHgd4SvpWEsahAAuzAdWMNFY3Mx5x+NaV5ZsIxF/WUzHJM0n0kw5qpZzVETd7RQfoHGnM2WrseYM/p/ee7vpTYdiYDL/Ptgml9MI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8811
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: E8F231C0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: shqim6ypy3dtdemj19o9g5zqqyk3g1bg
X-HE-Tag: 1756145552-232784
X-HE-Meta: U2FsdGVkX1+xX4pOuXltfcWG5C3WjkZAKpfbpsuSN6NxQV6LS17dMjHcTwuvbpun3lArcrCf7oZno2LhHo4k2iPEsPUkPsXH6zycCR/XamrLw/zH6etXJAEWTPyM5ybB28a/Uo7DyIk+9i8PCeu1HRude2CUd/kc+3qpc1lokcp4j17/t/+4vkke5I7C3FZ9GnOGeS5Sg+sAgRWlrO6C4NMMof1FTyyaJ69s+zxFiWah6MY7y6nyrn9hp2kZ/3LhTrAm+1jhhcAkxeY3Qx6tHAhZPIEBQKtk8h/HfuCO0jrNq1rCqfPT+LOImScyq1LPasFR69JxJAdxB9ljPOPm3Hvrn7VGvY7HQeRuK/9pataIQcVn56erd1e5HRYwkQfqFn6Jjl/s/GD9iX3pMwhrBWiaOcHq0hMameIUyawVsrbjy2i5E+DiqimXOXV9QAYGOV1HgRj9D/kVuohFRslvIOfJnIwI/4ywIv0/IwE3in3GYr4mZLm9suVKSJSTkI1raD3aTLxVIhItZzdtffClGD8UI1HCgas/YlcEybvV7NE7ZLAzBcbqcH5Mma+VfopdGWvmPD/Td7nemM9myApvUoY+222u6I7DSst2rkpCemBhuMUaPSTeyosHRVRkGi9yUTeSlFEj0/0LrXKduJ+YQooc8wptIeokjshzSecsz86+YgH4Ob0ZQqaQCzrHzlMKzpsKUGqPVaKuGBlpgXHYH7Dtb6Ga5qPl6wDLU1fivmxcNSn05egjHsASg9qVYpaeiDX4oMbiNCfIAYtNF/56iUQHW35VnsSPd0xLK6q26Si3xe/sToswWesqxTO11J9sDfWcwzYbkNQLYGRgsLGJT5hzfI6xYRKbqG9UIWuXHSl/mBWcQly+I/dP9jlrbsRhKp65fillk9Gp72Aze8M2RfviUqPtAzEScVks+mQL0JG+0SfO2MCJbUYKVALu9p42WoMbha9WYkpxxMZOupv
 gaSiaxbH
 OfVzpp5L8pgTNX5A38v+yf8KHuEOiEBkdEuODUVmY0PNCL0n+B72vZHTMbydvA6CdqpJJafSOsujqd4e+7f15hxQRleFJ251doKzsGvi1zhgP7v4Rw1haFlbpqXw7nFKukMmh2hC5AYv/+tBHMkDNfX/yrxdIr1kfkTCEXYnnwMDprWGBdQu4iCt4UR0K4zIXAyOngRuvfy/OLWoHc1IKW4kYesHS3XGuCT5Z3Ew8Iqk4rD1OXWwzy8X2KUR+MM058LjBY51HKVUGAouaNanSicSg3JDYCN7uk/fTFg6Qt7UtgsqMFHqjNrU1N9hraQ/zVU5bgGOspnkLs86L+xV56y3+H02m5XaHnZWtafhNXgEODWxJnVhXj5ylJC07vBgA6zeWtNgrOpqrs8fhvMbtocU7mlAtzg5jqfbKDR71emOA3bz+aQOnFwNnaKUjuZd79SQuIfzV1PILogfIEmKefjqRrxVEOytV6FHktePCSjAusKjlPtt/FRFsdiYLCM4HOdbbjqJMtxgh8IQ3QovVQ00zFu+ULI6kNpiNrEvYi3NLrAdUXMmsADvYz/FMFVpQTPixIsv93+tjTgfBN+i6zj7v8FSkvcOoHPmnCIXD6oJCj3eg6wsQhrW1UTNZlIwXHBzN26d5mJmkymdiiAUFozcvlDiDeAhzqJpEI1bVjN8SzFf4JyCh22ywu6M2r4JH7IDrjx9WTH47bkgRqIGksZdbDqHT+34uAb2PW2BT8zmJY11Ws0vScaAITo4dOZ532wfMRhYsmewX9MvQO0lu4yT6MyX/x/FJqd1TeEC9cXKlicMWsu5TjTqFw7C7VrV3KNQ6XqBZOfK31g/VxgrZjnqsEXNx2DUNzPEzM7kaEDalDt/T2q5Gf39/i/hhPRCJ/C1BS5+JBotrxZFM3JN4pJswNVn26GX/KjVby56bX2cJVcpJP0ChiL8NwBm/0sREGRyuEW4NswCjPYYMCsk9fx879hSI
 PJ+LNa4+
 g0FyVuXLEzyMs9hz9XJ+fh7rzkMlv+GcUzrf7xd73xJoV7p1qeamLRDTibO1SVtCjejVlfduVdyIC56zNfBxZOHOnWVswJL10jnNEXCnDlPhvbMR1b/qbT4I4Ppr5vc+YIu9O04dsf/G5zBPHgUtTRfbig66J486fYjeWGt+iKvp/JnuLKFETjeWyCDxKj1EtSeS8y8mwU8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Sunday, August 24, 2025 10:39 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Nhat Pham <nphamcs@gmail.com>; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; hannes@cmpxchg.org; yosry.ahmed@linux.dev;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
> iaa_crypto driver
>=20
> On Fri, Aug 22, 2025 at 07:26:34PM +0000, Sridhar, Kanchana P wrote:
> >
> > 1) The zswap per-CPU acomp_ctx has two sg_tables added, one each for
> >    inputs/outputs, with nents set to the pool->compr_batch_size (1 for
> software
> >    compressors). This per-CPU data incurs additional memory overhead pe=
r-
> CPU,
> >    however this is memory that will anyway be allocated on the stack in
> >    zswap_compress(); and less memory overhead than the latter because w=
e
> know
> >    exactly how many sg_table scatterlists to allocate for the given poo=
l
> >    (assuming we don't kmalloc in zswap_compress()). I will make sure to
> quantify
> >    the overhead in v12's commit logs.
>=20
> There is no need for any SG lists for the source.  The folio should
> be submitted as the source.
>=20
> So only the destination requires an SG list.
>=20
> > 6) "For the source, nothing needs to be done because the folio could be
> passed
> >    in as is.". As far as I know, this cannot be accomplished without
> >    modifications to the crypto API for software compressors, because
> compressed
> >    buffers need to be stored in the zswap/zram zs_pools at PAGE_SIZE
> >    granularity.
>=20
> Sure.  But all it needs is one central fallback path in the acompress
> API.  I can do this for you.

Thanks Herbert, for reviewing the approach. IIUC, we should follow
these constraints:

1) The folio should be submitted as the source.

2) For the destination, construct an SG list for them and pass that in.
    The rule should be that the SG list must contain a sufficient number
    of pages for the compression output based on the given unit size
    (PAGE_SIZE for zswap).

For PMD folios, there would be 512 compression outputs. In this case,
would we need to pass in an SG list that can contain 512 compression
outputs after calling the acompress API once?

If so, this might not be feasible for zswap since there are only "batch-siz=
e"
number of pre-allocated per-CPU output buffers, where "batch_size" is the
max number of pages that can be compressed in one call to the algorithm
(1 for software compressors). Hence, gathering all 512 compression outputs
may not be possible in a single invocation to crypto_acomp_compress().

Is the suggestion to allocate 512 per-CPU output buffers to overcome
this? This could be memory-wise very expensive. Please let me know if
I am missing something.

Thanks for offering to make the necessary changes to the acompress API.
Hoping we can sync on the approach!

Best regards,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

