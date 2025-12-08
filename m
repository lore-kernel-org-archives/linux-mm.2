Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 868FAD3B7E7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 04:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC3BE6B0005; Sun,  7 Dec 2025 23:17:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73686B0007; Sun,  7 Dec 2025 23:17:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14246B0008; Sun,  7 Dec 2025 23:17:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB6D16B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 23:17:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63E8C1409A0
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:17:50 +0000 (UTC)
X-FDA: 84194995500.02.69DA372
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id BCBF81C001A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:17:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dRDxYTfK;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765167467; a=rsa-sha256;
	cv=pass;
	b=RDP58p9ORiBs2kLcsTBBi2MGbTLrmDQM+VstX1g1z3MaM3JCZTQrxQ7TU9adEUcjlfopQA
	Svt8gb2GUf7UWzQSGMAHhAZmUKAr8St5ar3R4PDrD68pdSG0AMrJCvAcVy7Zq7D9WYWfHU
	Dab0Fx/c6/KgI6JOAznBli/6nCAFe/c=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765167466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0GLB8uTQPP4hhMz9pgn+ot6cV4WnGNsawyEKETFkMk=;
	b=pZRmBQhx0aMbV/wyNumu2cfS3wFhThcs0ld5HYKpWwClNj7XIlbJBEbKptSpTvTcrOW8WL
	mavsMY9i8uujS3bHWomdFSDEgFUlyolk590oVwxazdrdMEthJgLArJq+tAGidFeG29AiOY
	rRHtbLjagobVh+QG65V4mvZllK6S3oo=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dRDxYTfK;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765167465; x=1796703465;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AUcJgIyaKZWajeYik/FM3EllKQjbSBCtE7kLIZj5rrg=;
  b=dRDxYTfKRlZPNu/Bgxsx6p5afJgNeBWParqyjra0lOAJ5UguwbB+/aY+
   yLg9CjNUApoN7z2vdxlW9ObvHWluBBQEFUKN0Vu+Ij7pN4P09nuyp95oE
   Dn7RK/Nk9SyxgXu0s5U6hjbw3QMAAsKnbmG0/bxSbn+mcVB+Es3Cwhm/u
   rvyv2nTzuDDPTfgKjLhM8rAEb8q49fFSuBJbTYNum1bgiYkqOMJHSITpJ
   9TenzqbzOA5AD0Rsb+m/6D1sXg7Izc+WUTDXVTnZGndzVGM28OzTIuUVg
   hoq9vo7ggS4YpNqG+DcDPkg0ut64/XQznn4ZqS0m0git+PhLGeD0xIf8e
   g==;
X-CSE-ConnectionGUID: jjGDHtf6Sy6279a+UnlMNg==
X-CSE-MsgGUID: L98bQVNpSuaqpYrEM5YPCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67069390"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="67069390"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2025 20:17:42 -0800
X-CSE-ConnectionGUID: 3hE49AR3SdiVQso2Z1xuDg==
X-CSE-MsgGUID: IcD6a3ePRUmXRF89VyceTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="233204252"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2025 20:17:42 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 7 Dec 2025 20:17:41 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 7 Dec 2025 20:17:41 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.38)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 7 Dec 2025 20:17:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VM9nsAvXcAPX5DnnysDIVBnFYNQ5xdEfU9cvK+I8te0YIZrmTXrMDKmtLt5gsGLoo5ZulgG0GiOzhT5rFnr/MJk9q8xMCFFLyDzZZW1Vl84tMKylLqP4dlMfJqsvFh/n2WV6JUMi44v6twIkgCnJoscDkkyPXPxWh4htTGcY7nNLfCIkFyAFbSlQ2L/L+sfPG69aOvtjO5L0ba5G/QX7IOlKtkaNk2NqpKfBo/kvUiRQ00AM49GadVHmv+uZ7/fInDIYwOaOGxWW3Kbo5lfrYnDTmwlSVkfraN8KS+onzwV5zJ+xnHg//CBaOXkLI7cSCeyJeRCPKpR2VcwTGqJIEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0GLB8uTQPP4hhMz9pgn+ot6cV4WnGNsawyEKETFkMk=;
 b=ZcqXg5a3GJBgjWgusb2lA0xZ7ySOairDNK4WCgzL85mGD0XYFWlmru87Y/CiQyzCvUQvcrBAVXo8PUM5mTaQehTUgC5kUlvjArTs8ghIEEhKL4BHfFhlb4oU4239dYMTZg+rcuKfY6+NBQnZCiqjc3blRHIscLB98tQ2PX66pSUp+cbliT6CGauNNoOQXK3fs3t+h1g68WWsVn6O1XAe4yv+3NO8a0D9In9mtsVqXzS7ivYZ7nJoMSMOxlOQJQmDQxvFWazdiWK6I0ESsZjvhwJ1yqW+MbxzJzhhPsntmCzbW/oOXs5+c4JNzRA/dFHO5DOlQvLgUc3gxg9ijsZNiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by SN7PR11MB7537.namprd11.prod.outlook.com (2603:10b6:806:348::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 04:17:38 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9388.012; Mon, 8 Dec 2025
 04:17:38 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Yosry Ahmed <yosry.ahmed@linux.dev>, SeongJae Park <sj@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "kasong@tencent.com"
	<kasong@tencent.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAAG5HAIAABzqAgACcWYCAEjbfgIAADVuAgADeg0CAEcgegIAAC4yg
Date: Mon, 8 Dec 2025 04:17:38 +0000
Message-ID: <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
In-Reply-To: <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|SN7PR11MB7537:EE_
x-ms-office365-filtering-correlation-id: 2a5885df-9fca-4743-a2e4-08de3610b8fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?5OBZxab2Vq84LT6DonV9YEvfmDOIwrufYvx06y2jSrxBl3pfw5heaDYjYgwO?=
 =?us-ascii?Q?q6SS4oGUx77x0cwEidE9DuxBODOEsKEgTXEIIN1GLb1LCoO7RlRpnOuO6a0F?=
 =?us-ascii?Q?OTrbDgq/0/T+iEyLivXvPDh4K+Bu2iO+aQFbkE2VzB7/va9CySBWhd2udQu0?=
 =?us-ascii?Q?F4Xs8xLKhpBhuSpZsKQP7grg1TM5BurpYHoI1HyTVFgcI48SWmdB0Tg5+kuW?=
 =?us-ascii?Q?RCRZXbX14Lf1/tDEsP9poaUrYaYOMIm41gkIz2cC4KqCoj+wZwOHX1lJR0Rf?=
 =?us-ascii?Q?Dz7A6m05wY3cX+4P0Eg2e1RNaJHYMkz48NkF2Ul4KiU/LkvAqN4biPj5aAzU?=
 =?us-ascii?Q?tuVb0ONGAiw6YXNau+UUy7x9xMDxnBg73Rn4BfXoz5Bks2//2DeMrr6hK/nB?=
 =?us-ascii?Q?tfW2KPM03+zAikM5dj/ndm4Oa8QTx1hAcoMPtQpQWiCVmVMGtJjJR4Uysi3T?=
 =?us-ascii?Q?VjvUnyqqk6hpHrxus2Zvb8bulXm4RKbD0v7GFptNjVtdtTnORrJG49q5e0jk?=
 =?us-ascii?Q?OqgXK/EcdF2dwxnZX27IFjSxS5Q0LqM/Pr1+PTx34Hoqul8nIGsismhOOr2L?=
 =?us-ascii?Q?Q6k+8Lh2Cg4pDFtziQWmd1y2QJCGEa6s//riOnDgFzgSXXVwJ4jtOXn7qiuR?=
 =?us-ascii?Q?Owsg4XZE7b92w+YOE0WBOcrljymJx6rgDQ/vbEvYsSFCJFrUw73YfIKpvUJx?=
 =?us-ascii?Q?yASngwwIvsGJQrxZJmhCVjNqUTK6YLxKZgut//oReXa4Rw6yEI3U7xSqYj/w?=
 =?us-ascii?Q?czzF3Q/Ol861i19WHHF1Rvrk7OvtKlzQVuEoftWmDwTJfd4bpeFAEefpLGO0?=
 =?us-ascii?Q?J9/+v0KVcgS69XaGBSJc5OiSK0JodVd18dJ+efB9CT6yz4BodFiRA20c6ua0?=
 =?us-ascii?Q?CDXIqFK7Trf99BsShgoNPRCMVtoi25a1LtfBy5QZmkj4ySBLBafqFQdlvQeW?=
 =?us-ascii?Q?ogulQ+YzSvwMFTitnznIXdE+tm4/Zy0gf5EsGC7ne3k1wvemb15TPlldWwFz?=
 =?us-ascii?Q?af56aiBIdoAhk7RPdDJQpapBTr0yjcSXyTVAciXMvyyI9E/N2VIibX9qE/eT?=
 =?us-ascii?Q?NffM6VUWro8iQTYkFSjPdfEId0u9SaaFN2x/gNm2g976QbHEwHtVRtGs+Lkw?=
 =?us-ascii?Q?qDDhqED14pP539XJqrY8QXfqxdkEIZY1y1bqkK1VSgoaHHnUg54IaoIC9vQQ?=
 =?us-ascii?Q?SF68oVjbsqKAktUtCQz+N1iJO1EaV1WGqUDCBpy/i5vbWgJaSL41IEM3kAi1?=
 =?us-ascii?Q?Nd0kAe/nPBAcxGAqyI+scSXpIQLan9Xenaq0NSfODN1wsmLtoKcQp0TfIS+G?=
 =?us-ascii?Q?uJfh8M7o3hO7RvxKcvgjGPbyt5GSYhO4lxT9V6GA2EKQorJ4MV2u7DNFxMJ/?=
 =?us-ascii?Q?QIME162VwnlQwKjyCMyBpljvwqTVa01wd5x903egEa20looqJqnFnqdEpUvO?=
 =?us-ascii?Q?mmPNSrfMgCu0B4WqVyL/UVEcx0utJA7Jm3aHr6TH5+k/CrViEKtYxw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w5ju7VyfeXFodoTf9aEpJz1zzvc60FuhMtTUPiJZhHcvhnx4n1leBdlbgwuP?=
 =?us-ascii?Q?ZlxaJnsc1Yg8/u9JkSbt7e4nDqRcUNnlR9lndH7rA5JfH+4HE36iZ59wVFeT?=
 =?us-ascii?Q?KYMtgsOiC2sJe9iRhvfP+kKyvHDRK1v5lHl4gjuBfxecFeqLIYpK5WmRWcRW?=
 =?us-ascii?Q?1yv14cNQs/8FR70xrYurTrC4ffDSqETZwuGKR4NWuGrRln58nj1Yot7etepS?=
 =?us-ascii?Q?9KXwARvAqUqADTyS379DdzxsBMZ93DsTJvgWFh10wxzSlJslGZqBHpIXpg7s?=
 =?us-ascii?Q?3FarT0W7qiApYoEMznJpF5jD1ASdCV9gddvUXk44LBRfiSYfle0Loy4/FkPM?=
 =?us-ascii?Q?g0NKl676SBQ6KIL9i2Dy4z9Sn72Ae1zm//i0Z3MKivI+LsRrOhB7AAmlR0qq?=
 =?us-ascii?Q?ql/2T1BU85CvRGJlrg593owtwVbPhNrazBEH0OpOQVoqth5PBsjpzOThkS9h?=
 =?us-ascii?Q?2S9fbBB4qIfo96EQm50QqT5MJBZRZtENWwPVUea0t9+rULXDAbU/bultWIpb?=
 =?us-ascii?Q?B6qCX5JE/Yeuv1qU/4lXCiLlH/HdTJwiJLASTHikFgEh3GlZuVWo2qZyn0vu?=
 =?us-ascii?Q?e5vm7mlnXTqq72pRT3ihKsO2sjzJcivW6NCtYGh1qDBEhu5NMMkgw3+V3K+9?=
 =?us-ascii?Q?/b1U2mY1zadaBakvzBAh859DjYPnabm6phjTXW+UZKi3VHM+RONiDYYTrLl5?=
 =?us-ascii?Q?b1Ux2q34W4v4ThZ8gdW8IQIbKq0PX6eltNcwiExyLZyYSTeVU5a2ujJq2VGc?=
 =?us-ascii?Q?JBijatW+kLQRd/dFE+O9IWAZkg1bt+gUogjIEK9qTxnY2OFTLJ67WP2fLHG4?=
 =?us-ascii?Q?vtrf5OBlBbK9QdZTOggCWF8yRrhnPP9/e7I+4Mkcv2s5EGRzBZHbJ8zcPKna?=
 =?us-ascii?Q?o/FoD13LlbfkX7aqbCpWwfK6TwWAL4ftJipgQFt1amp7VDBHD/q1zqBav3d5?=
 =?us-ascii?Q?Xrhqcy4oaP0k2B3TiTvJdnJ5Avx+KrTXfUVuvMjmA2yQUoBZtgnC1AJ9Vplz?=
 =?us-ascii?Q?ctHteWPwetx27APbcRVDKbbHi8kjQkAVYfoWAHYlWwYuCVzYVjokEBtl930N?=
 =?us-ascii?Q?BPU+pmMUlizyCGEHtW32A01X7CUHS13UcgPjX1a49XKPj4q6WTaTYEqpyJHQ?=
 =?us-ascii?Q?Oz09RKACAmWfprkgkR49OtTwuD2iEZ+Ehffz+3Q7e4svFQl0oPXchBMgfffu?=
 =?us-ascii?Q?/6chVg+bMbciykNGhDHLNrO/RoQJZZknLwUfI1AXtlrdkswGIXgBeCYjz2Jd?=
 =?us-ascii?Q?KGw8r94xsoZa8o7JS+EUynNr7NPtiQ0MrDRnz7GSoj+Ff+avLNpcfxUZb64i?=
 =?us-ascii?Q?HSXLqPZ06rzw0nRlJlJNIooSQn2uUBu8F577umen0UuIKp+yKBcSJLVTf220?=
 =?us-ascii?Q?yZzotP6gr5BKLwpaVEQ07hvYcuW7vTFpeKIJQ3Zfb5xhx66ePfEazwZllLOH?=
 =?us-ascii?Q?1N038HvMq7bh+soJmQJuN8PupD8nXbhCwjDH7/b+4kpLEf2JLDuWLV/AAoYz?=
 =?us-ascii?Q?t/B2nAK9f/gq/ArgPyHYp3iwn7OwRsyDL2x2NDpITsuF3+twLI/u9ijEzz2V?=
 =?us-ascii?Q?PpPfJYNmaXRhOz8cMdEsPkVhuf7Bzpo0QYpjAdVgxR9KIeb0pcsRijEYO4f2?=
 =?us-ascii?Q?tA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a5885df-9fca-4743-a2e4-08de3610b8fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2025 04:17:38.3782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e0e1bRqSf0J3z+TgGfHBd9V1B2ctZEmvtE8UtHGHxwTCvWIRKDhWtU616DmwJut2tyOh5RriD+eshGk7oqyq/OOt3eR3jOJyBo/5ePH3rrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7537
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: BCBF81C001A
X-Stat-Signature: 1m3mg4ut6u46rqe4t8sjw4ur1b4qgh1b
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765167464-427319
X-HE-Meta: U2FsdGVkX1/+nxofP3ZnkBdDoYgfsjKQyMlhc+wiSfNCZS+RssVfsXT5w9XR4jdbiEtC6rvm+j2SqTcwECHvHslK6H/E4S/Vq72Tno/dcuCAuwI6A5hysPGG9mWt8Ja0R7ZLDnzIFBSxpVQ4BBEqwa163kh4ZfjytQuNTjs/H0eNBrgjQpTXs99pcjsHEGwOLgKqloqhEGd5YrdGuHOrf/0lWpqaNZpHKZeILMiy7FYtUHtJKuHpjYSt4bz+BaC7CPGWZZ7ErCJpXJBfV7Ss9ONSzdtMhexY2/UadYYOiYYL9nto8KzK/Mf0Ar4wEZQy36wRVBDcAEX8IVxY9+tqts9Cxn05eTqnRobQ0bVtKrf2yIzZLl4LG5N0sdAgY1lELzKagj95lvtPBMcbxPY6LL29nZnnBOvc9k0wA+dKUGDdPA6QrKj62ONWXDzme6sxpYAQxqfhm7Of0vHtLB15Z6qCgoaesnCHt2J1pTkk5wMhyFIDcaxXwtQUVLIRblbwtUuTr455pRIBkvKtjo2Nxlwku823+kHHbG6UOWRGblQJIs22J+mTbtZcwHKA6SVFOrqD1EMyzskRZpYlDMIquQoncM+04rj88ZrFDLUINjBFabiK0ad0RFJwnhHG27+P0gJ8XFKhDdpzOvUvKW3Pht1vg7V+HIkW/oeFWUauXse23I4l2byPJVtG/lQrZajyVm2CWYvcH7+wCt073RFTUGQ5XeIkuYg/DN0GYXi0YU4nYVd0eJYW5ruc+vWY2a9q2xHlPkSVEYfMk88c95HqKiyhMkQ4L1NXO3KZ1gn/MHFR+YgUWeopVPJo8A3TJDahECPwbHbhC4f0z+t+B2+eMzX/hDJMfCUrVqW00SS/oV58t/vbK7g/hlzQWIeZYzY5nOnf/W57BKgboH4DjfgsRac8YmOGguVIQtPw/ImOo0aKZ2CoZMKe9epoghGJYAqYHiS8N+cnVBjPCevwtLr
 2ath59WZ
 goAMmc3+GFR0KcssYmQ4TeJW11cWG3nbF34n/nUHw5OB1WOXkhd1ojmm+yEUdsDzrtxf7fGxMA5Ga8THuyhjPASMjhXRYoLQE0i6GUMReZhyk77Z0OV3s7SZN+QHddhE5xz+Iz/t7XeXgC/w3wVguXuGR0d/5St0kYiKu2eDwlzuSS14mvtJua61u/7sn39nUH2V26ataU1OYIyToVqNBliwaRPyLSmFQ52UhSGuC9MsRrfiPlZk3dlZpvwl0UExGeiC2gCMfxhxfUeBy9u0bDn1s07mQy2fC2XdlUrSA+BvjyRvCiLyhXXAOicHzvf+KKBTXZrDB8KfkaixXorcYTfgqI7CqZwfedG7kej+Xw82NErKgmU3NDA0LNzjc5j81Ujrd/9WNwoOK79ZXz1Fg7r02e4yyipu8/suBSLbHVDjTOMbKLpowXY3pK7hZyIVSQPmhfatR4XXV51EHJITSLitqDokpr9g3lE+9O99RlcdUb8brVX0aRrjxg54gbVhqByHJWxb8ITXbVwyz78xG4UtcTLZFvHgEKHSBvcvePM1i2lkqj/GR26U/4nI0zA0FraG6U45y2e8QMtM1z+NV5TU+fRXw3GI3HiE85r8lF1d6ys6sOTSGBMD148y6o0miyK0vw3KEagvvMFrT5y6BHpyfvs0CC3IOgxgN0FhlNdhmOvvKymhDeSXYR13w/bt0IMUsswMvdh6Squ3Dl8dQqcawJgQTpoL96k/mw9JbyA3Au3ngozsQBYhP3obJt5WJ3x9TXBCcOWh8d1JkKYYCHzN6mcVRd/Kqpdnz9jAJ5tFAKq58ypPJ+ItHWQBQBziQoZX3g0QmmlpYCOs/Ba+GgFqrPpwsGnCR/QQb/Wd0jc8ag5MrRctMO8VIttmg7h2fNqDoXn5yMumipSJzOWfSFhqtZwN3WDPh5pmPhR6QH9MlJaVG5MEbh6KoWSu0sOVC3uaNvWcoZflKfqsM7KLAKwgQnorN
 HHbdVVnG
 BIadc4alb6Q7gnA9msS70dHk/r//S0r4hth4D4lzJeQ2QVUoSDTIJ2HENuPIl08Yl0TfLJBkMpUsFHEcZK8RVdjlEO7qg61+rgxXCVrNm5GnfkE/XeKy0Flbv27d66wP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Sunday, December 7, 2025 7:24 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>; SeongJae Park <sj@kernel.org>;
> linux-kernel@vger.kernel.org; linux-mm@kvack.org; hannes@cmpxchg.org;
> nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
>=20
> On Wed, Nov 26, 2025 at 08:05:40PM +0000, Sridhar, Kanchana P wrote:
> >
> > Herbert, to make sure I understand, will you be implementing all of the=
se
> > features in crypto_acomp for software compressors? I would appreciate i=
t
> > if you can clarify:
> >
> > 1) Error & compressed length propagation to the dst sg->length only for
> >     non-batching compressors.
> >     a) For batching compressors, this wouldn't apply since errors could=
 occur
> >         for any page in the batch, and the first page (dst sg->length) =
could have
> >         successfully compressed.
>=20
> This would be the first step.

Hi Herbert,

Thanks for these clarifications! This sounds like a great first step.

>=20
> > 2) Will you also be handling the case where zswap can send an SG list b=
atch
> >      with multiple pages to a non-batching compressor, and the crypto_a=
comp
> >      API will internally compress each page sequentially, propagate
> >      errors/compress lengths before returning?
> >
> > If so, this would really standardize the code in zswap for batching and
> > non-batching compressors.
>=20
> Yes this will be done as the next step.  My understanding is that
> your patch-set doesn't require this yet as all non-batching compressors
> will have a batch size of 1.

I see. So the way my patch-set tries to standardize batching in
zswap_compress() is to call it with a batch of 8 pages, regardless of batch=
ing
or non-batching compressors. In zswap_compress(), I presently iterate
through each page in the batch for sequential processing for non-batching
compressors whose batch size is 1. For batching compressors, the iteration
happens just once: the whole batch is compressed in one call to
crypto_acomp_compress().

When the next step is ready, I will no longer need this for loop that
iterates over the batch in "batch_size" increments. If Yosry and Nhat are
Ok with staging it as you've described, this should all be good.

Also, I have incorporated your suggestion to implement batching within
iaa_crypto in a manner that adheres to the acomp API. I was planning to
start creating an updated patch-set with this. Please let me know if it wou=
ld
be a good idea to wait to sync with the first step you are working on befor=
e
submitting the updated patch-set. Thanks for collaboration!

>=20
> But yes this certainly will be extended, not just with sequential
> processing, but we could also use pcrypt/cryptd to parallelise the
> compression across CPUs.

Sounds great!

Best regards,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

