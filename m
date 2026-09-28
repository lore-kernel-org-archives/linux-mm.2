Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA525CA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 14:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F93C6B0088; Mon, 28 Sep 2026 10:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA306B008A; Mon, 28 Sep 2026 10:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 672FD6B008C; Mon, 28 Sep 2026 10:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 396816B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:44:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C4E641A01DF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 14:44:26 +0000 (UTC)
X-FDA: 85263441732.17.9CC0183
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id 410DF120004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 14:44:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iQcW2y+K;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of pan.deng@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=pan.deng@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790606663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yV+ev1qoA4T647LlvKBRZb+j9ouVSMVC7ScJNmpNCnQ=;
	b=JasL76On1rt+4nOUvFy9qY7+6nyFbtEKPCWam6A1Qirw/YVlCwTAyJfQcs9Nv1OITi8q+t
	BOh+CGXjJ+46NN8yTIgdtNChVmvIPd/nbShW8sty+0WlyIrTFYGChAPC06hE11229zX91T
	s2LtE8JWh2wWh6hBuCbm/uxcvtaZWVY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iQcW2y+K;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of pan.deng@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=pan.deng@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790606663;
	b=Fr3z1P5+BgZ86mGwZAbpJrS2e5qeiqRykgqR8VFejoqyx8N6fXnapQvlhvRItfdCRhewtz
	Vh415u0lgFb7+LpY0I9BbygyN7TeJTrogo9DtW0yetUgDkdX+FA94VkXiUKqzk1TIIiedz
	bWoOPe4/OrAjopczL5cUTATv7Rk60OQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790606662; x=1822142662;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2VLvxYrEJCH+iSkWfUYA66HjEWBX+pJK8YOl8Z7iI4M=;
  b=iQcW2y+KtIoTm78aaZze+4spKoLq81JjYf69SV2R1fwOSwn9IT/lssa9
   3M4Ll0jVFeUeHNCDtJfT9mMcEsHqOBiNV7nRRP4Du3iQfhEmF5l5x8AWA
   XPWpJJYsXqDuqedmE0f0gRznV3mjWD5v4sLqagUrsPnT44mVvstj6R5Jb
   un5ErS3vrfdRsQWxwcNsfTu/US9oKXSDEWAxBBHwgcxjr6vZhOFquPA1B
   u2uWgaqT/Ft/R2Ef6/FIKEocQFMRjr1g3RJey1VlOb7rhrfXj5h7te1ev
   NmozLWvUMtTNvDP/E/1D+prQIFQnio+dlu3BJ9yEIGqW+qKUnOPb3iw9g
   w==;
X-CSE-ConnectionGUID: H12S0mYkTNq6ZlGqHN2G6g==
X-CSE-MsgGUID: +TmygRPJQwutSwYUKS7mXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="93796112"
X-IronPort-AV: E=Sophos;i="6.27,128,1787036400"; 
   d="scan'208";a="93796112"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 07:44:20 -0700
X-CSE-ConnectionGUID: VbuQKoOqQDCG8l5fq1OUNg==
X-CSE-MsgGUID: b73W41l0SLuoO+pj9SwVXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,128,1787036400"; 
   d="scan'208";a="304580650"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 07:44:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 28 Sep 2026 07:44:20 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 28 Sep 2026 07:44:20 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.39)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 28 Sep 2026 07:44:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L6YkilstOopptoLjJmILfeMaRZlF/MJHaLEwa+EaBkfSN7QOnW4PIQkHdX371DvGLzkqxVNeAnf3FFh/3ZEXCW/zIGdz525BCUQw1VViqcQkWVnBUDr5v1fJf6P7+6E2Szzd1KK3L8a0OwUu5V3HhLaqV6yEF1DIbE+N8Lc+wv29LYXTwz2ga7omWAdc/z60WX3UCfspt6Ovsh91h5DBBFztzfbAJ5kMQz62WtpuqqsbDWO5PMcNuRVvo0ylAtR7jTSpNc+01x9Wv8b3K0up7qZbVxg/gZNr8+ruT9rUIqLP7cCeYcn7d4eegWV310ol8LyboJP8zlGNEurerG1CeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yV+ev1qoA4T647LlvKBRZb+j9ouVSMVC7ScJNmpNCnQ=;
 b=xaY4/6x0+Yc5xK8gYgc1fURV0GHuMMGgym4+jQxnOM/z4AtvWOmhOBTUp8efjow0COetx9q/9m8CzgoOf/GOS3vWaqGcKd0yxYoDb+E7U9M7tvJXR6JcVAnmxDrnliagwwuyFD2nrcCCgr1AMK45xwjf45OeIxJv/NZ5ekRWU0xmQNy+fz2k6DT2CzgCc1uNWAE0wN3A3QRbZ5bLwqPWLaWiubcCz5l/YWJ/R8RPjuLR23YOIIiwRfC4wdqboJvWYthoV0e7p8Mb+OfAmBqXo3FWlaIcNYRFoJ4dNyiCNhjNJvRVtVjbhw5dkmy6IPFWAqUigVMy/zSM5oRm9vvIxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB6832.namprd11.prod.outlook.com (2603:10b6:510:22c::8)
 by CH2PR11MB8780.namprd11.prod.outlook.com (2603:10b6:610:284::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 14:44:14 +0000
Received: from PH8PR11MB6832.namprd11.prod.outlook.com
 ([fe80::63fe:d2bd:3fc9:1d08]) by PH8PR11MB6832.namprd11.prod.outlook.com
 ([fe80::63fe:d2bd:3fc9:1d08%5]) with mapi id 15.21.0451.014; Mon, 28 Sep 2026
 14:44:14 +0000
From: "Deng, Pan" <pan.deng@intel.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"liam@infradead.org" <liam@infradead.org>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "jannh@google.com" <jannh@google.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Li, Tianyou" <tianyou.li@intel.com>, "Guo,
 Wangyang" <wangyang.guo@intel.com>, "Zhou, Zhiguo" <zhiguo.zhou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: RE: [PATCH] mm/vma: avoid redundant file rmap tree re-insert on
 new_below=0 split
Thread-Topic: [PATCH] mm/vma: avoid redundant file rmap tree re-insert on
 new_below=0 split
Thread-Index: AQHdTQJ2IWgb0v7YE0+qNmQ/GCpDurbfbz2AgAAHEACABJzHcA==
Date: Mon, 28 Sep 2026 14:44:14 +0000
Message-ID: <PH8PR11MB68327CAD97AC4E0B161BB997968D2@PH8PR11MB6832.namprd11.prod.outlook.com>
References: <20260924054301.2330822-1-pan.deng@intel.com>
 <araI4WsI0XMXOR10@gremlin> <araVBBBVY-jafePL@pedro-suse.tail5790ac.ts.net>
 <arab1d8-4b3SzoI6@gremlin>
In-Reply-To: <arab1d8-4b3SzoI6@gremlin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH8PR11MB6832:EE_|CH2PR11MB8780:EE_
x-ms-office365-filtering-correlation-id: 17e6e3a4-97d2-4a7d-1908-08df1d6ef7ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|38070700021|56012099006|3023799007|6133799003|10067099003|11063799006|4143699003|18002099003;
x-microsoft-antispam-message-info: zV2ZWRaRq1HIWih1brR/OOL8YUTQ6ZszzE7Yfe0454CS2ucPZc1RLEPXLL58uqG5iQyhHJ/H3fgjEadcsDn1gE4DTzz7G+9O764vo6jr5NWD4Pi/RJOSmqAev7LUfYP4bfZWQF2GO20pqgL3WWapU6XMtbfuyOBTS4hqoSlrFWB0L0+g3+pPlrlL5QLdM3WVJiumafiwCaaGIzioeVilLMbBdH2eXTGKjSILx6bdXZkRCYUnraeOzW0NUm8i1UKXTRubelgo3kpRtyQCPJxnR1ZnsDc6kW3y0M9npSGPa7MPvk6eyS2+mI4ZKVIK4OGPQau4WXenZ97BnuziDR2WKypJxpHlf7qNJFHLptijEPVxS0cmVWGtG/KkNaBnI38/QU2JO3zYSRjAFbM4vUBncZNn+7lUV1k9uDRa6gmUJFml8cOqLWDft//JV2z9gW+Xu2gA/7Cu6+xPnQPDOryJ94Bx3bFrumhQtfXtPzjcTidbIE7xMPvzJEF2C7z4BEaGqeh1hVcnp2bZMkJourrwkf552nnu1PEqJyMRTpc8sKEpZqcWFm8MC7oWpvC1W3LZFpZ8xlMvHUC+GHKdIl/wkK7XD3cbWq4KbRRo38a++U2QUUpvOrguC3q1pK/VVdUd80U6ZbkJLwr9vgNVj089GXto6vyygi6yhX/hruGLB13en1JcnxfvGoTb+ClUD5MQlwTkNk6AfDf9H3nJlqvuJbkowhFNEm+cUMe6chklTpU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(38070700021)(56012099006)(3023799007)(6133799003)(10067099003)(11063799006)(4143699003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l14Pe+QI/3gRmeWC19CRWcO0zEBuk/bPZMMlLC7q9sfa8bsSNv8zCchu8WIa?=
 =?us-ascii?Q?o1XPZUUBA37uy6OIZbAfO447NcBDdm5TNsBSCLVv/6OI5Ewjlu4+8APVoe3Q?=
 =?us-ascii?Q?tJJ7DDPxBqOEaMiQpwDiQUK0qMV0zLYiPMl36AGdtbEaFArliTKnfpPaZdjK?=
 =?us-ascii?Q?fkDI54595wK/JtMDzlFQYgGfQZCAl8TZr1A4uvU23K3o27voUSMVHowQCpk9?=
 =?us-ascii?Q?keW8BHsrGcZ6XYdyAMAoYCWxoLP11BGGNbwk5U3/T0w0bfZAO/1shgEkkORz?=
 =?us-ascii?Q?Awi4MteagMcGz4hFcl63Vw2UODmxKtF8uIXXuywtZ/pmY/ANgvaPq7gtQm/H?=
 =?us-ascii?Q?e/Dt7KlHWSsLp6pR6F6FINmOBUrHI9OwgT0xUuKN/YlhyGA7KQxTj+Q7SaGe?=
 =?us-ascii?Q?R+dS2fi+hrY6gBEGdaQCC4I/TNnCdd5jo5wIGYOrmLcLwbW2xPSz1NQ/hBh1?=
 =?us-ascii?Q?FqDRDGpjDieaT7txIn3RQ2x1YMSQYchxH76X5LAOoocNAe27FhhkiWXI8FBV?=
 =?us-ascii?Q?heHKPA3f1vqKHi+rS/uHCF4Uw/TLspJ88qFraZOHetOBl5RV0r1uZ0Ulj0on?=
 =?us-ascii?Q?aZL3xd5JkhWRZ/SIv5OiK6MTZ76WaNDAQXz4vU5RKMkTKX4EQI8FY1uKAaax?=
 =?us-ascii?Q?R/2Xczvw1Bh7/ysYhDgR69rKzuJ7NLnBE9ubNAj3+587GTi557dkKjg3YLUD?=
 =?us-ascii?Q?9qSD5AkBiaT6NNwQMLyhM3trNs8Tz3opDf7/AwBXNvZsaBtt6AxLwPBFqSyn?=
 =?us-ascii?Q?LfdQIUxk1CMYxrWMDGtQoLIdWVRH9RS8kZZ2ZDDy69vxlE24OlPUpzvT94vX?=
 =?us-ascii?Q?fARKLvJG70US98QFiyiaAKkCQKi91TPaT+EUzwTxaCslo5bKrimPcpk28c7f?=
 =?us-ascii?Q?z1u1NhbE9gj8d8ZhgWBHpFX6U8ORYd3jt2WEshYXSp2ozX/TqSJKY6utaCHL?=
 =?us-ascii?Q?8Ww7MR3IrthdFWAL+tBIFOAgSOlY8vfeongtvZahiVSH86b88S07D4655+tq?=
 =?us-ascii?Q?MGl7ot5Hf9Txlmg/g/AeDD05yxH+S3ZtPx3QKJ+kP7NFLC3TOF04v8c/HdMz?=
 =?us-ascii?Q?RkS/ny4nfbyEvRZ2FCveeFf3BYFrg2keA0XPlv08JAfiPaxQufmuO0e/NNST?=
 =?us-ascii?Q?Zf7sMLVIrp8MB2yh4o4m+K1EeRJ0kldKLR7oiDybRwxRwV0B4XAphJJdGBcJ?=
 =?us-ascii?Q?vlOsLdRgtO1VIVZOCHz+KY5xV3CKdnqzKZLzaYE47In+2dH8tIkOJ+dOxu/E?=
 =?us-ascii?Q?Ji73Jd6y+mgYCa2TvdygzqNw03JjIkTCN53EoiWOsISE/NA3uj2B4bFiKSHH?=
 =?us-ascii?Q?xiaND3Qd2Q+QVWYa5fw9scJwr9pWT7ggl/PrL/ROt8grVnHKTlzx4TwmaByk?=
 =?us-ascii?Q?nRrCJD7YOTXxtk5+wQRO3tgyTizQackFaSVU41Bklkb/rg693N2CUV0P1ddW?=
 =?us-ascii?Q?yten6N+vVEmFwTtjlpQUomsImlBWoFDLcbJ2mATOeeLr410aw4lR7AwgEn0w?=
 =?us-ascii?Q?YiWoBZrayYK/ZiMggdHNBSCytU+wcB9N7gLKC3dldyaNzNVk8zqFcQ4NVp/L?=
 =?us-ascii?Q?0PkKCbaxwY9EgGBhEpYWA7YLSujCFHeHsEaMK7X4gu2tnStLUiFWC36ow5dg?=
 =?us-ascii?Q?7v6+cBaAvLuaZtpNXbbLQBivje9db/VRYwNFno33FcEiSLoJmaGJIQOsDsaX?=
 =?us-ascii?Q?YFGBBJ1kcHz5qnVIKPlNmJgWf81I7fTCJpBkqEOG3Vm1gZ1e?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: LVOfk0811Iwpy7Veb8LZujQgQhWWogNPGyttDbtAwi5Ta9St0PtHynPXWThNj4Xt2fFvlGwQ6hOCsQQph80tcX3C99HNT6Dwx1n9sxJQGrlIRR3V1YouMrJYom6t1Awo3Zs1AQwufzWQ+uE7Pyt3ucEWw0AZj0U2IDSodGhfTydez5Vbrf78ft6h+stn2Ml7fKKquk3xpnt33B1c6+EPGVuGeWoIr8BH/334wjWHc+N2x20I3UHfSCmyyJNSC7TvU5c+Rcgv17ZYeMCS8PQ4zxR7nf+EUr4c7iJbIT0Gkwvuk7FNNAv8S7IJem80E45BxAXX77l6cjznc9kI9IYQIA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e6e3a4-97d2-4a7d-1908-08df1d6ef7ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 14:44:14.8423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Upfjdoz4s4SiSj4vUsjstdsYxhxrHAij2iSMMT5z2bUjGPPtmHvY2fKMRhTQcP5Y4+AINSseHLVU1MMFP6+z6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB8780
X-OriginatorOrg: intel.com
X-Stat-Signature: 8cj7wjzabuq7anytio8x7enrr7sdhgyj
X-Rspamd-Queue-Id: 410DF120004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790606662-987840
X-HE-Meta: U2FsdGVkX19x4Y7E1iHP7eakuH01zdLZRDWGs8tgREvT+rJwJV6ryAR7e4dfox/+xT6YLA0SjK2NkOz11jGqh3PP4SQGTQFsAi9jSffsi+/ARAVv3NUQgmDmBx4XEJAjGVIHzo1KvD+L1b26DinadKWbk8csVofOXkIF8huhGo52TjLmTQq7yED6gvCq9mnTH/uOa4NYT9/hmcsocGcGubxKzt3lvT+91kXshqzxhP+UJg4Sonedvd119j6MRlT5G1hr1uRWqI71ejWNTWAdVMHcZfnEN4M5omfHjd/CkcXrO06AW4JhGB/v6sjOZf3t380KK3eBFc1gFXDx1EGGiLJ3CiN/HbD/kgcqqgdgzOw3ehfGbqVQDnk0HDLCe04P4l/FqroF+PyhZsmiVHU/naHPNwzqHcnzbI0NGs2PSlRNXdh4gjwGFKoEFjozgSGKA3gUwVQAShZR3C0P+iySMiczN8uKDynDjUwktAolIRAHV0rfjLqQDZW51M/90WfgIU9Yh9wmoP/EluXLcXbwWzv52KT9qeqQCjwMT/xY2XMRCAMaKWIVLTI5Ry02+dqR8iHTAafHCRlKf+0Sva4fWDn4bKfX18NO99NF48eeyeJ6IWREOgqCz0+El7z6yDgH+P8IODyjJ2WSJjLHVzby6kxb7S0NkXaqgy4VsC+2R8HnDAyxBe5gnnrOcldYtIRFj5XZtiN0Za37jZxp8NcTVn8a/W0IkeWS91Ho/cHR3pezhP5+u+vRMLUu9s86OAO6snlACdbL/Z0zJmcjRVVRjAmoXYv5yxtHt375/TvzvCJQKyKYTgks/iXeUX33Xm+6iiIFU+m38SnrYRdAB2fgcZP3Q9bOfCQUzm/I4lAqdzdWV3RKHfDO4ld2XjvoIB9tlK44JjcvI0bglKZWnkxQsjA9ENN9+lzdrhXGM7yt01AuU06H7HmGadj5Za3wzcg1zy/r7OJXY64djEQApRv
 U1tOokCI
 /hQI6epWWHsBHi6vbkU13UgXyiySSqpNnM70zvdP28x12cPFGES3kuk5pFXzXOEYcTWH1gZjlEdyC2GLg8WdHJf07oZsiQag7b9Yq7uNrHm7ZRRAB0HqfOQiAKPeOajHUqbLu55zPp4Ptpo0M4yjXTiaM+PnYWFq9LmsRluwAVUJDEmp80dUa/b4FxwGx2aPqPjsyV5iJZwlwKu60c9oD6eAJYOzhNu6YnPoNhyiCHBDGV5B6ZEb6BklKxpwsQaUveJIGkxXU8+uGG8JhXfC3uvlrZfYl9+QPC8W4Xtujg6WzP4PfE6+H7P9HMcDi8nrgIvWtpkRrBvcZ5wR198c+O9fU7fjIp3CYLjaKc4m2JAsPnR36ldflamj2704T9+sDTpGSv5u7UoKG5W1lL9BfUSVnf7Oq8DorXDpZXafQYDK9z8WRZWyQXsrQLBf41panwcYWL/Yql/AuNeLDvpEPk4jkwOqPcufRxfieZUVrVtwk2yLRbxSHW6GznVm+LIxM+r9twdhSb+w97JzR1royJK8LHSe01l9veqbGB8+sxj/GYgN+oiDmcjq5VXbvjysu5kyP9NQJfv6JjGCm5l9tA33FyZc88SJsAZWBTXN/KlEUXb2iHUZ7scRdMhbftKKcJmhjrf7aXAQ3MEGnOju2AY3Rujlns9wZSmtYrPgedhOHszurMJxopFwX0h7VMP3fROGFD2QXF+l/meyIdn/hVsUneaxzWl0tpu31YzoIsZXMNaoNAGF4OHGmyoe8N0Riv43nBM2AHNVxiqpcIbNhBIrzrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Sent: Saturday, September 26, 2026 12:09 AM
> To: Pedro Falcato <pfalcato@suse.de>
> Cc: Deng, Pan <pan.deng@intel.com>; akpm@linux-foundation.org;
> liam@infradead.org; vbabka@kernel.org; jannh@google.com; linux-
> mm@kvack.org; linux-kernel@vger.kernel.org; Li, Tianyou
> <tianyou.li@intel.com>; Guo, Wangyang <wangyang.guo@intel.com>; Zhou,
> Zhiguo <zhiguo.zhou@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>
> Subject: Re: [PATCH] mm/vma: avoid redundant file rmap tree re-insert on
> new_below=3D0 split
>=20
> On Fri, Sep 25, 2026 at 04:43:37PM +0100, Pedro Falcato wrote:
> > On Fri, Sep 25, 2026 at 04:27:44PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > This change skips the re-insert for that case.  vma_prepare() no lo=
nger
> > > > removes vp->vma from the tree; instead vma_complete() detects that =
case
> and
> > > > only recomputes shared.rb_subtree_last up the ancestor chain.  Ever=
ything
> > > > else keeps the remove + re-insert path.
> > >
> > > This could really do with a diagram and a simple explanation.
> > >
> > > In general you should rewrite the entire commit message yourself and =
not
> > > use the LLM output at all.
> >
> > +1 on this. Even with the Assisted-by, this needs to be understandable =
by
> > hoomans.
>=20
> Yes.
>=20
> > > >
> > > > Measured on v7.3-rc4, on a 2-socket 192C/384T system running
> UnixBench
> > > > execl (384 concurrent execve of the same binary), dropping the redu=
ndant
> > > > remove + re-insert yields ~14% higher throughput by shortening the
> > > > i_mmap_rwsem write-side critical section during the file VMA splits=
 that
> > > > execve performs on the shared libraries.
> >
> > For what it's worth, I'm vaguely accepting of a similar change, but thi=
s needs
> > to be _really_ well commented out, and ideally in file rmap code, _not_
> > spaghetti'd in VMAs. The interval tree is complicated and some bits are=
 not
> > very intuitive. This needs to be robust. Not LLM'd into existence.
> >
> > This also reminds me that I should reboot the sharded file rmap effort.=
..
>=20
> Indeed, which is why I'm treating this as a report rather than a patch.
>=20
> A member of the core team can do the actual work.

Thanks everyone for your patience and time to review this patch.

You're right that I should not use the LLM output for commit message. As a =
non-native speaker, I used it to generate commit message and comments to ma=
ke it read more natively, unfortunately it had an opposite effect. I'm writ=
ing by myself, from now on :)

I just saw Lorenzo has picked over this work in https://lore.kernel.org/all=
/20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org/. I've read th=
rough the new patch, which extends the scope to anonymous and covers merge =
and shrink scenario, more complete than I just sent, it is great. I fully a=
gree that it is a very subtle and fragile part of the kernel, I did spend t=
ime and struggled with the patch, very appreciate your help.

One last thing, and please read it as a question rather than a request. I r=
ead submitting-patches.rst, and it says "Reported-by" tag is intended for b=
ugs. While I wasn't reporting a bug, so would you consider "Suggested-by" i=
nstead (or even "co-developed-by") if you feel that describes it better? I'=
m fine with which tag you think is accurate, and I'm not trying to reopen t=
he decision to take the work over. Again, very appreciate your review and l=
ooking forward to your help in the future.

Best Regards
Pan

