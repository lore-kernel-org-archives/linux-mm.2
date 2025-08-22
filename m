Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15219CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD596B0025; Fri, 22 Aug 2025 15:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D49D6B0115; Fri, 22 Aug 2025 15:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C6F6B0116; Fri, 22 Aug 2025 15:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 31B016B0115
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:31:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E100A8354F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:31:21 +0000 (UTC)
X-FDA: 83805387162.09.3CAC619
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1657E20007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:31:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=h04nVnz6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755891078; a=rsa-sha256;
	cv=pass;
	b=nfosYfhrVNydICz9A3eWV0ZQVaAQmExIwBFSaEsdXiAHhO5iNCj11u3NA/4JGW4JdHdoSd
	YuYnmswnpRh/I0JGhYO/678HP1xX2wyFYHmaUYOu89BonYZAYPPGf1eseJ3J13SNhpNoNE
	s4NhQfg46d0YdZzY4KzjYtsBcE8x258=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=h04nVnz6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755891078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EogltnJsfrYws4jCg9kwgB9d8kK83skSPQ+wGLpSGfY=;
	b=LoTC52eLWMcgZTSwB3+sMNtIFt74NGolfbwJ6KqGS7fVEb/Zizh/aZF7x8XbKnkZF8pieq
	GBBTVA8jyJymJesPAx1vZ/ACj84ePKyWXrUyywh4tqQjd8MGg7ReWXaXqGSkKVNLj/Iqrw
	fnr4kG3onDxmsKAFZwHvdfuKUMkBgvM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755891078; x=1787427078;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A9clVWcAQKJnwV+R6evPQ3utHns8yhx/+Gsy1/UcAyM=;
  b=h04nVnz6zoXo3xCviOlWyZpUDCy3I6umLFRiiat2KI09LTbGRDcxK5GQ
   BiEMhVBL2lyw5t+FtJCGOBd/lD5Sc43sqGaCsftWLKDm43Y7nh+6WQ5Av
   b/GoEqc34OzJuAF03VgGBWnymzvui3Z1D1cEm2t8pMPBKXtfR33OOXgV5
   AGD6iO8jCVi9MJsQZIOHvlbMc0pMchhNejHYSLCvlNwOKgQbImwIwKOYc
   l92iYGIv+rOSYdzCww/P4Vv8EVqc1Hl7sahOZWlRymMe9Gf91RvE4y/M3
   9cQN4EO4mmOmFHVY6jO5lPUy5lWM0yxzYQfQMt9gAWtl2kWjtV1rQWLYl
   Q==;
X-CSE-ConnectionGUID: 6BAnYSMlTTCHhr/uNqPhZA==
X-CSE-MsgGUID: +1DNplXATZK5e9HbDFpyhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="57222553"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="57222553"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 12:31:16 -0700
X-CSE-ConnectionGUID: RBzr7ndrR2ycMrhbr+A2pw==
X-CSE-MsgGUID: uVT2FEDOROeWfy++Q3WmwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="168288356"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 12:31:16 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 12:31:16 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 22 Aug 2025 12:31:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.49)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 12:31:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=czDGYL/w8yF3agQo7URJyRQbTYEm/Tw6Z66GxxaGFniAIoV5mLZ3an3LTb42lE5CRFMHndaxJESwqoj7grMe9xtSxQ1ezZr3pJpwlcPnn96p+heyrdGkSLarSoDULxrdNZ+Rjo+fu4BzTkWM06+3dFEMLaA6yF7tUMSkeH/eAz8Oo9QuSfXYwKy5+x0kKqYVIkzFsnuIlfvxN9RTwUQifa94R9WSRbdEVwGeziZj/2tBtahYfek+2AsNhVOtJVfxyV8JyZjvITdvg2OFYvhS4fSu9oDr8f/XfVdg63/7AwtZ3MQU+3HnHWE1OX4e4odiW7jC07mwygvLYy2BjDWs0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EogltnJsfrYws4jCg9kwgB9d8kK83skSPQ+wGLpSGfY=;
 b=idQRM/QQUJEsh8XMnOZm/knunL2utOmXMCJfhRAeRo2LtF3zMvg/X6tuAM67c12IN8ajWr6VXZKT+uYtbbfk/O9AyoTXWHcbQRLKYriPNbrYCHwWUP0NwY8mLObv1yjhWEgXGiZR+gfkK67h7J96H7nR/b4bVyKscidB55g7kPVV1X7ODf4yaPnqUVqkw8dtjal9yRL4eXGTBFgtHDGq8wqI/4ulImYQHoI/nsoSLbhkUcecy2/zfd78tIvQvACLl1Z+B4WxAk6Y9uhT3/AloPWy2pTHGBCdFp1ziY7RA8vtokK0QQPQOxjElx/+o/OSf4PHX2GWw6oXn5Ck9KU1Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by DM6PR11MB4563.namprd11.prod.outlook.com (2603:10b6:5:28e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Fri, 22 Aug
 2025 19:31:12 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9052.017; Fri, 22 Aug 2025
 19:31:11 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
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
Subject: RE: [PATCH v11 18/24] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
Thread-Topic: [PATCH v11 18/24] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
Thread-Index: AQHcAp3rrlgug3tz+EGLnem5m/WFabRjRbuAgAvqfqA=
Date: Fri, 22 Aug 2025 19:31:11 +0000
Message-ID: <PH7PR11MB81210ABFD0BF9F73214080E8C93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-19-kanchana.p.sridhar@intel.com>
 <aJ7Fk6RpNc815Ivd@gondor.apana.org.au>
In-Reply-To: <aJ7Fk6RpNc815Ivd@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|DM6PR11MB4563:EE_
x-ms-office365-filtering-correlation-id: c4111a2f-c4b6-41df-f44e-08dde1b273c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?qT3gCF3jER/nM9wb4WgjybFt0QBM3YnMLaYh3hXrd9ACeF6UDWDS0ITL2cmU?=
 =?us-ascii?Q?30i57WICaJDDoADkW/BYLw8pwPneAK/ljH1OhOkmuVUNJyyqYen/xrstIg1n?=
 =?us-ascii?Q?kP0VP/nXByrxSjX0ACzeSAhRpr1Hz70UzRsDnmkwUuoCbqE50PRgqNhH5nKi?=
 =?us-ascii?Q?Zp60eB4xA5AhkmKtnjJ3CEA4u80jjv0UMWtAPOmtcF16Q2M7/Ma1QF6L0U5p?=
 =?us-ascii?Q?vEai0XdKQl4hzkmR8LraEgEx4ExN5yqeCbsBGp6qpcOV1vjmjt9Lut69SWkJ?=
 =?us-ascii?Q?wiIftvzYSoIjqVne3r64ybhH21PxTDTBi9ohTeoQrqZGrWvI7YOnniP2/zxS?=
 =?us-ascii?Q?CvWJo/YR7VeSAGDDuSVe0/DUM5nfX9kWl6Ufup2q3TQRMAXne93BpPCUIfy8?=
 =?us-ascii?Q?aC3TwUPVT6kOYWFnWr90N9TYp0AADqcFvvZnn5LxAd0amklquFbpF3cWjHaG?=
 =?us-ascii?Q?XZHX+nn/rChm3slBpUtNb4nUmnwRTWVjQcHXCD/R4B+gXIRJlwx5gl91IL82?=
 =?us-ascii?Q?a5+EmIbTQq331tThhz7IBL1qBIQrIWMf4E2DbOU20gGw3udhS58gkXLF6PPQ?=
 =?us-ascii?Q?uqDtL0H3+XJKOvaLgnQ4OIICoG5WNxPetPlPoaLBG8IaubZYwjm/QNbeYhYx?=
 =?us-ascii?Q?94tJOXITjwJXt9/YYw37C0iG08geGlTKwd3+iPlTIXBz4Yn67xi1NsbGEP2N?=
 =?us-ascii?Q?G6lfZrYA1wEIZLc1o9mLGqRgA/gMBO+AkhT8ZCLcDjuV6vWmW6uAmsUiavOh?=
 =?us-ascii?Q?6NLkCq26N1OTSaBh9rfGCdjXHwSZcOAIQ6+9Hk0Gleospobzy0yxZd/1OFsX?=
 =?us-ascii?Q?1baIucIcwTd+eK+odHbbg1iv7EWw6Ec15O8uDoy4RBtqWbKe/QYH9Z+wHw12?=
 =?us-ascii?Q?VeGAE259WP32/I0mULM5b447MVButwlHqgmg0o37F5HfKeF36vZlqMJP6O8k?=
 =?us-ascii?Q?C1kLWxS2spFpxXWRMMIIgIQqyWDkK/nFFYKPP861LDb+1UgKmxU+fW0wZzBS?=
 =?us-ascii?Q?RmZJNFmEofmgKQKCky2/fCMRkGFBDoETKNg2SozbbHr9X7Y4fYQYCV04b1EQ?=
 =?us-ascii?Q?d+Qoarkr5ZrPStqwKeuQVySSl5LncKg9MNzTevS7rb8dblZwFVcwn5FH/fOF?=
 =?us-ascii?Q?cAlujD07L4s+Ga1xx5e6wQywnUCpOpgLDUWL6iwS/gZTIkBlefXLldsXrDkJ?=
 =?us-ascii?Q?Dy54Q8oAIMK90mtTIOWYoU+7l5l81HtzavNCsXPFYzm/bj1u1dr9b8SI6jH/?=
 =?us-ascii?Q?oWti48Kzxuz9s7w03l5vB8bbVrc+DLJsb6Ky5mYGr5a/0j58GqJ32trRCmnB?=
 =?us-ascii?Q?Ds4AB9AxPIBLmSru76ObZWGIJaGC4jtkTy8CEQoK1smN/3VC16u4lvOy+pi6?=
 =?us-ascii?Q?A2BLER2kr28qnHjQmJYaf4mXDQCEePJi5lD2OMpBK49G6IDh0xcSk49Kd6BG?=
 =?us-ascii?Q?dklGNs1i7gM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mPn+QOPsKwNr8CJsbND1QZ+REL75knUtHGGeKv6CZnJqx6A+4GDl7GwCfHNG?=
 =?us-ascii?Q?ecOH+VsWtU79dNfHSPNV1e3ZiItU/ZMnytrSgOV2PrXT+ram35ESfN8HgdL0?=
 =?us-ascii?Q?SyWJ7WBXgiDIc7H1c+81Dq9g7UgprtzTsHjBMRf3RAwKbsKYHJ64rXuKbi85?=
 =?us-ascii?Q?025W53EhwUhPLYDvrEVo2WVDWG2b5b+ty92kEgwSeC0nfgGa2pQqCozapQnM?=
 =?us-ascii?Q?AfVThKHhz70vq4UBSeaBNf7qlnTZzdmhvpCkQ1hLodMHFMUZoZud0iMnp4q6?=
 =?us-ascii?Q?zFFvFTWbrvuIiT7grEskNqYhjr7Lu55ZI21fkD1mJsYFbkD8w1zxrh9G3zxO?=
 =?us-ascii?Q?0EmBDSXV+BSeEK57nAo90Ni2R9Egrf7ecKxBktrfJiz4NNXOrm9i6E9sS7uV?=
 =?us-ascii?Q?XT1fwfPF9KD8LDU7ASrrlcBi2f/1RrtOhZTmClEowgsbMOGsgnKLjSfSx7oG?=
 =?us-ascii?Q?StOsAd14Fy+stKYCP5paMiiV4rye6L2FRJoNSPasBAO4pmW4zfgihoUJDE9Z?=
 =?us-ascii?Q?A3GiZspryD96u9qZTjhvTwpwjT2SAfptTbRjIyG+7cq68QbYBHDnmzkKwPk2?=
 =?us-ascii?Q?pRfzRuVt5dVA1OcGkoDV64JcKG1zzqXCSJj8+T8hIH5Fw21S4dGFgcNtxlKj?=
 =?us-ascii?Q?Q8QSMNo//z/OX7NeFKEcAF+IklDW0t11LaRkF/6dFH4cZHiR1AkTmY44Y6+L?=
 =?us-ascii?Q?GMAwMCzsXpOKN3btmlMM0SQcheT2d2o61YmcgN6JI+sczS/Qh96a8NHjMRK0?=
 =?us-ascii?Q?U64uiwdtEy1qqi51h1EjiO4t57nSf4/5kVe/BzMauV5utl1aNgvRIpG/K0HG?=
 =?us-ascii?Q?aXxvsuQiOy4aizcdbhSp6nZw/LZ9K42e7pLSstrBDTuNvIvsPEl1mRTfcH71?=
 =?us-ascii?Q?ymoz2ZrsiOuN1EiFxGPAr4YIvfTDXaZENkMBIn0CfpUcUOSSOkEDcWnT0H3i?=
 =?us-ascii?Q?qypI4G7gZIjHpptwa7lWOAJvWAoEJAx7gdF931pmoZAqfJHt5lc4zjvsdY5k?=
 =?us-ascii?Q?FqUZlIkzp30ZRsuIx7e0qpTo6OOIYvds40ppvQUvF2RkdBx1m2GmiBw7xEF/?=
 =?us-ascii?Q?vrzfTXwVlh9W+QTeR1qA+Kpa6JjHlV+pQk6kwsGFaR8aDXrkUnoC3np+5hpG?=
 =?us-ascii?Q?DXXsiywjflatqqFx0v9odCF7Ksxr5rm73E0apVIiRDJqd9nrhdQYN3tyNwR8?=
 =?us-ascii?Q?fvCFN7twhuXDz5cs3cJd8y68pWXzL3BvJ2v38LH7j6YKXF9Cual7owhjlwNZ?=
 =?us-ascii?Q?x7F+XGy3z2aEo5Pk90OvYgaeYZCNOqeghv+XJVyOcMd3mIfW6wlLke58+Eel?=
 =?us-ascii?Q?PeIt/jph0mwjQAUMwUWjqwApvK3AakT7gA4w7jNwi6uZozNES5KiqTRN2lph?=
 =?us-ascii?Q?rbFziv6Ple72vprnj+KYMwUHBrWICd398iiREuUJxr50PnLYd6l8IL2cJSd5?=
 =?us-ascii?Q?itc9DLydyojPTsRWOK+lgPF9OS8kX3X3/+N73aYXt3OkYNPEgsOPthmX3KZz?=
 =?us-ascii?Q?GriOzKeEGre1D7J2V8IIRaiCSs+UCH+maNI0AvF6CsQh3cR/gnnSkEpHwTyr?=
 =?us-ascii?Q?qhBRZe4m5BG1W5KP8e/AcGaPPk9brvqyDqgIUqhrcApdRJu1hBa2nzgb3Q1Z?=
 =?us-ascii?Q?Jg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4111a2f-c4b6-41df-f44e-08dde1b273c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2025 19:31:11.8875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TNXNei5DRet0VjGDnf5pt8EJ5CBpJDqHXrLi1YnIFBJ77pEWIoLwbGH8zXg6Pl6bXo38HrCiL/Dekch5yWQwQeRarp7QozcjsIHU3RGg4lY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4563
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 1657E20007
X-Stat-Signature: gfgm1chb9sxr1okpjgcf8getb6fnmr9f
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755891077-89841
X-HE-Meta: U2FsdGVkX1+rvZAd631+4ChsXHX9QqENOoZLztNVCaaHqKPaTS3Zn8R9wYdQFtWvhEM05h3187AcyUw5aNj7QhxO0Eb+CCIgyqhqydkYp6C79ePs2U7SXG85PjJBcqYJnBR/zo+YRFht+LhxM40Sp4iq+var9cWgHfYYE89MUjEdgPn4e5SUt6485GnsSxi63X5dY4z0PwfvJ0oi7EEu06EkafnECPlyRS7g7CEW+fKDbgyZZzppqo4Lx9GtxuC1KYWSH8rF11lODwvH4OLg9AxIZ17tKNSzDWgs9zq4fHM2cb8Jm2LyTFJfchmECB9+xcl7Uu6K67mLPIkm7ONawI+uR19LyrVjpEsZmmHZ1FhDcNIX3SOjQ1iDZX2kY8x/o6BbCZjE+ZCcjxtkS41XwN1eS5wgF0zC10MAbIVi9FHSSCFj+UipMyWlPSxzn+3z+R93qDWzsaJt+nOX6mXeMZgXeKhUTs3IASDzDlOew+s5oNZBkagdZBeRgGIITy4nDzfX3Ka618MmxvSQZGcOwCteRR48VvXfsi1eKL21SMZHed1LNmmnXoh6Qyz3L1NxnrCwKwYzhM7NAiwrLj8Bb96SthWPlgNIaN96TbhZBP2Mpnrg3h2LHrHbVqcSEPBr8j5IYwMt/saXvKgeuX3LsH6V8uklc24sXYh15IkOg/0NjAtPrAaqK7rvMfPw3w23/+Oa2aF/rEhAH1vbuClk+8zRuUe/Q9HfiMmBYdY2jHiQbIodgIvGnJeC4w1/8mYJ4WpCsBmjJeXb74WiHSuhDz4HpS+ruLr15fOdPPM3dl6d+RhDmmsjLo5PBWPnasUo/HhPvjxMsiSus5/+cTJX+JobG3EGjBUPM05S7SGV/sR1Wht9MDhCYAUTb+ptd89RCFvkWasv6IK0vI9F5qjdMewxbblD4wcNV1YOLSaEk7WIkb0hqYZSCPhh2W6wvoTIpjpuuY1hIOWJoJ+6I4x
 XJnp+4ob
 0f1T90xu8Vt9OTf8QlBkEu+QWw47YjkoZjjj04phRvLwnDkwhTq+VnQxD41Zv3xuTNRvhLTaav21vdznHeM28RPOArV1ASBfwixx4z/bfrivSRBKtv/5PfozFXofwtyTjOLofpT2EUykbmrzrbazgAV0E9Ac22l8LR8zCV5xf6DfQ5RB8yTNmsHBwdGNkPvShoqEPZymhfCG7nqkbBpq1/R2k01+rG+VC80RK9Ven6VsCLg3ECeNbXQhjK6vPEvp/NJb8pKvhUzRhsaH81sRRZhAZtcxFkY2S6uooGxi6WC9bt/pjZDkBTXAAKlB8M3qQZTkWjWpWtQVw3hgl+YNUSdaM0GDpPQOyHAGruXWhVPTwqdIhP13e2UrrQiTu2SvklwEbvgUE8wQzrF5gagw5rUa08Hwe94s8EsUJYpqoSorRCYQ8ZI7fPnPk5o1u9InuqFzynhvWijBsYgn9qvI3qC/QpVEUU0w+nsU+5HPoJHb78ICODjMRbnQ69KeQ8NZr/wgARSRRKKgL2Lj2EByB+Md3AUXrH/whTSCFRkmS2w8N7HbKiNHTBriGke6FKX+eM/fU1S7RkhxG+QmFYA/xlNkb3iEVexGZggm7VWiwZCoDb/EQzLQzFDKaLa8ew5IQWzYtTvjc0BaPHSi3dL0QRz/jTAhPVjv5yCH1QmPB/+G4REmcUqBUoxRyaaNZxvZj3AwpI0C4zX68didaJmSjvMmrXZZQemDwy8c5qXMYrA+szKumMSehF8ERzTZN0y1ZpLRSNIlqVrC2TgxJ03HzJZS/7fUtNNrI1To2ZKqDv7FLqWl0zTYRWUTC7jRdHQx8Xu2Ww11kyxnyjwyy4d/jkvjBSe8qayagreOIy2IuOo12LbwDBFSha77KcgBZWUaNAHltBI3V0LUIKNJtaXrhQ5TCGrPLgSAG3D8Okb/5wOaI/PFvxUk066jNcHWr2riy7S3vOOppBmoCm31eHkA3oyEMgCpz
 EtoJxM2l
 /Y0ULKnTl0A1cB2cv+9NyXED9TAdcxeDK15vD+CB5HZGYVmNm+/YOqE7J8tVQsaNlYa1sjg2J/TSPR37xbKCl1dGzzJK09roG2PR9as7Lc6uR2rcvHNk1C7sa/UIX6YiA8OQ0om4v+NHvyyx/AYQPeZXs5Lx67/WluV1HKH3vkDYNzkRm1qPm4WK7fDwSBuOq6KbsKFCKSE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Thursday, August 14, 2025 10:29 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
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
> Subject: Re: [PATCH v11 18/24] crypto: acomp - Add
> crypto_acomp_batch_size() to get an algorithm's batch-size.
>=20
> On Thu, Jul 31, 2025 at 09:36:36PM -0700, Kanchana P Sridhar wrote:
> >
> > diff --git a/include/crypto/internal/acompress.h
> b/include/crypto/internal/acompress.h
> > index ffffd88bbbad3..2325ee18e7a10 100644
> > --- a/include/crypto/internal/acompress.h
> > +++ b/include/crypto/internal/acompress.h
> > @@ -28,6 +28,8 @@
> >   *
> >   * @compress:	Function performs a compress operation
> >   * @decompress:	Function performs a de-compress operation
> > + * @get_batch_size:	Maximum batch-size for batching
> compress/decompress
> > + *			operations.
> >   * @init:	Initialize the cryptographic transformation object.
> >   *		This function is used to initialize the cryptographic
> >   *		transformation object. This function is called only once at
> > @@ -46,6 +48,7 @@
> >  struct acomp_alg {
> >  	int (*compress)(struct acomp_req *req);
> >  	int (*decompress)(struct acomp_req *req);
> > +	unsigned int (*get_batch_size)(void);
>=20
> I can't imagine a situation where this needs to be dynamic.
> Please just make it a static value rather than a callback function.

Hi Herbert,

I am not sure I understand.. Kernel users such as zswap/zram need to query
the algorithm to get the maximum supported batch-size so they can allocate
resources for dst buffers. The get_batch_size() callback and associated
crypto_acomp_batch_size() wrapper help accomplish this.

Can you please clarify what you mean by "static value"?

Thanks,
Kanchana

>=20
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

