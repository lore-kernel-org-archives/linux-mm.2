Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0D88E6BF3C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 01:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8F16B0088; Fri, 30 Jan 2026 20:15:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D166B0089; Fri, 30 Jan 2026 20:15:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433B86B008A; Fri, 30 Jan 2026 20:15:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 284896B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:15:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0B0B1A0315
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:15:30 +0000 (UTC)
X-FDA: 84390491220.23.980FC77
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf21.hostedemail.com (Postfix) with ESMTP id 11CF51C000C
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:15:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VLyuveJT;
	spf=pass (imf21.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769822127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDwnUuSEfg9bt5Dg3NdprbCcLTlpgeFBqkM3jfDY+RI=;
	b=1fR5credt0G3i09rM1N1MZjIFsHtCgWO/JnagGHDbOgomWn6GaGRnwp+S/K6/qBttLqJpF
	AyHaiYPZvYp/SqnOX57nZzr2lDzg1U5fQ7w/Rwh0eui0d3EqmSLWx+esDHttoEBt2MHE5p
	JLyodk/rsSNXLLfd6mAn44eBvDiFFw8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VLyuveJT;
	spf=pass (imf21.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769822127; a=rsa-sha256;
	cv=pass;
	b=vBt1QPZ2gZ/4yhGTTwgw6EgTBafK2YshExZjsvVqsxaUVMeVSJU6cqlqrdLch8LUSmJUKd
	zu2qo52dNmadhm6eRrHDO9xr1w8+5z2KmCKlnbIogYGcrH01e+NO9kgLxE1KVCDVbdpISl
	9M4JYlihEB5OMRjOzh04b3jK186a1jc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769822126; x=1801358126;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gDwnUuSEfg9bt5Dg3NdprbCcLTlpgeFBqkM3jfDY+RI=;
  b=VLyuveJTyjqZPUhB+/t9t1wjZLLxAEbuVnrHAXMtcW3FpGVisKWuy8Ba
   BnxutnED34RSGjheQpuFIyx9pFGAFnnbNjtXbYz66Hb0WbMHNEIH6V8YP
   VyOCndLRo7cGVwLsLZifaQVrKvplQnKoaBYT7oMY4EdbDWOiuM5QbckGj
   rnYoyrXtzmMkqTqRAeQbvsAqjrqSveLYMoRS/ErkFqpVjuNGE/RsPjR/b
   Jv11ByPJ6Uu2q8CDQ1OkJYUc+0NTAy16XiOZ7qJJHHVlTyz5ETcyKsLvQ
   CBrcJCVA2/qa49+p45bR/WxE5dysWbw/oy5WFrZ0aMceO0pL40BqGspKS
   Q==;
X-CSE-ConnectionGUID: 2DjRLUhKQRSAzOUvaapb8Q==
X-CSE-MsgGUID: O3eDv4tVRxGRpRTKuTJsTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11687"; a="71160773"
X-IronPort-AV: E=Sophos;i="6.21,264,1763452800"; 
   d="scan'208";a="71160773"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 17:15:24 -0800
X-CSE-ConnectionGUID: 2XAqJh+qSQ6bfDczep7Naw==
X-CSE-MsgGUID: UGkfy43zSdqLnV2jsjYDdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,264,1763452800"; 
   d="scan'208";a="209345892"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 17:15:23 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 17:15:22 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 30 Jan 2026 17:15:22 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.33) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 17:15:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OOcTSA+uBNzIz421v85+5TpdX2MyN/Si5AIyhQeFxExsZoQLawgy6WFig3QWy58ibZq2z6Bo19CiFVJtVpthZwLz8vvwX2uq6VXfKn/+jiRVBI6v2vsRUH4fbwNIHrFts5lmaYbDEOL6ii2yqa9D5OyzdCyf10hWEBEGnk+QzfioauN4Lkx/DRSC+C7LuDVfYEQTR2KyGPsUv/VGLsYR4vSVYqkzMmEgT/9sfvV+fmufa01B8COjVKGhh7qKaQ/VaWkSSNsrE8G81g18k8YQfvkCDJz1J1jhCpQN8xR/qAFAou8aVSgdkascxOaCBgLfN5A9+2fVvCySlYsk1II+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDwnUuSEfg9bt5Dg3NdprbCcLTlpgeFBqkM3jfDY+RI=;
 b=ikDxGmY5CR8LCHK7kVNZ/yAntxVmz5FJ/22C1IJyZB0Yb7TEwCxkXwMOo/8eMZy3ABIaXx8zPC0KWWyHLVQCYHUAj3OATaGSRv3OYd6MbRpUu9E2r5iqE0CAWchw0Lzgw+RnaX9NdgX7douMrPuk3d+3uTRj3IS4niyvEvAQTOcZDCyZgIWPALIDWJ9G/rBF+IHdefPeEaKCeYV5b4c7TZZnM6W5AV+X15dA0jO3g66xoErvpfA8pMt/5D8i1Ul2lnlK4euR+noQIPU1M3F6us3dqTPOEEIy5xvV/5HlZxJdglJ+T+zXobVoxZscOn1Fi6Q2xyYdckunripzBxngbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by PH7PR11MB6426.namprd11.prod.outlook.com (2603:10b6:510:1f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Sat, 31 Jan
 2026 01:15:13 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9564.007; Sat, 31 Jan 2026
 01:15:13 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org"
	<sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Cabiddu, Giovanni"
	<giovanni.cabiddu@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v14 24/26] mm: zswap: Consistently use IS_ERR_OR_NULL() to
 check acomp_ctx resources.
Thread-Topic: [PATCH v14 24/26] mm: zswap: Consistently use IS_ERR_OR_NULL()
 to check acomp_ctx resources.
Thread-Index: AQHcjavI4hosS0vti0WGDsZyYtmS2LVra+EAgAALKfA=
Date: Sat, 31 Jan 2026 01:15:13 +0000
Message-ID: <SJ2PR11MB8472432D6D0E813182E80F97C99CA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-25-kanchana.p.sridhar@intel.com>
 <CAKEwX=OL1Lt88tToA7pxDAJ4QkxV=PpGZ0zAVD=oexQbEArEZA@mail.gmail.com>
In-Reply-To: <CAKEwX=OL1Lt88tToA7pxDAJ4QkxV=PpGZ0zAVD=oexQbEArEZA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|PH7PR11MB6426:EE_
x-ms-office365-filtering-correlation-id: 921cf2a6-1b31-4c9b-4a85-08de60662fb5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Z1FCaXRWQVFWNTlYN1B1cjBvUFFyZjhET21HWXVpcHNrTTBYcmovTEdWbEpq?=
 =?utf-8?B?cDV3ajV3c1ZWaURGWDNmZjk0cm5aUXJEbWd6SmdWR01rWWlrbzFpbHZWT3ZX?=
 =?utf-8?B?K1I4WWRzc1hvaVc1ZG9ZRjhjQXBSRmwxTDU0VnQ4bEpOTDNoWW9PeTVZVGpo?=
 =?utf-8?B?T3VzSi9hOFkyWHRDaHp4WGsxY2dJRERXZTZSbDdxTGlROU9JY29pVG1jRnR3?=
 =?utf-8?B?WjFxbFRtVWwyVWRCR0pZZnNiZWI0YURWZUJ4bmJwMFgrRzZDMGM5OGs4aXZZ?=
 =?utf-8?B?ZlB4VW1oZ08rSndsMmRTQTAvdmsyeU9QalFzcGhYaWw1R3djNlNVbjRsMCtk?=
 =?utf-8?B?NjFZdjh3bGx6YzlHdG9TeHgrSzcrd0VVTFVtVFFqS3pQeWlITUtLckMrVkp4?=
 =?utf-8?B?MXpxQlI0ZFl4Tmh5dDB6SDJaaTRnRzFPaSszNnZtYTVUSHFCT0xaYThOY3dk?=
 =?utf-8?B?d0JENk1nb0ppa0I4QWI4VzRpRldDOWxrelVyRkhFNS91emNiVFZVOVF0eXdp?=
 =?utf-8?B?RW9RM0NRaWlvWGJMZ3hkZ1U5Nlp4dmxtc3A1K2phcHhmb2FINXJPaDN2T2RB?=
 =?utf-8?B?aXZTek1yQUoxa085dFI4S2J3NHFvNGs1OGxrSlJ1UVBxUWUrWTBvMCtjYjRB?=
 =?utf-8?B?M3NPb3VVdDBJbldoYllZUGMwaWVJazkzMXpqYUZBVnR3TFFuM1Z4OUIrOS84?=
 =?utf-8?B?T3Y3SnR1cXR1VC92R1lwV1hmNkQ5Mk5ZVmJsMytweWV0MEVRRDJzQzRqaDJl?=
 =?utf-8?B?UnlEemp0ZHdoVzh3bkFIRDlua3RKS1Jud3NDUjVYS1RpUzJZMDRLTDhNTVVI?=
 =?utf-8?B?bGxSVVVYVUQvNS90S1JiMmJ6U3pkUjNSeVh1YTNub3lBV2o5Z3E1d1ZkaGFy?=
 =?utf-8?B?MGV4WjFIekJuMU9Fbk5NVVJFWVo2eUdSTXJhOW9QNW9JSk8zVEhSNlRnNGp1?=
 =?utf-8?B?cmxPbFpES1E2RHZhdWIwbUZEU1ZXTk9XSDNMbmdOa3pDb0gvZ1VlV1FZMEV2?=
 =?utf-8?B?a3FERXFqWElQSzZDTEpDUU1URVpPNkNoOEhkNkxBMnVnL0lXd1JvbE9UaGMy?=
 =?utf-8?B?RkNrUVJHdnRBRW1acnJ6bzZLbVhTK3BHc1VtbXhMZXlQQUlCRzRLeVE4Titv?=
 =?utf-8?B?Vm0yYXp3RHJseWs1VWR3OHppVURvOEI2WlBpY3BlQjZFdm9vdVBwNHdlZzYv?=
 =?utf-8?B?cENKRGF2L0VHdm9IN2FabGF2Z2ZRZFFXNUdTY2p3eWVxeENWMWI2Mi8yYmVG?=
 =?utf-8?B?V0M1QXF1N2cxZDVNMTh4cXBsWGs5dEhYZG1kYyt5S3FRdHovWDFTY01aVTlx?=
 =?utf-8?B?SWV1NzhRYTR1WUVNUlgxdWJLaWwrMm1OQm1QcDlHTTRHTjlFNDVEQlVXRnBO?=
 =?utf-8?B?aGxGaFZBb0VPR2NVSUlBaStWWlFOQmh1UnA1ZmlpQlI0UU10c0ZVSVFqc0JI?=
 =?utf-8?B?cUNWZjZNUVpxbnh3NEF0Q0wvMG0wbHpBMmlySEhVRjV2WDlRWE9SS21YaUkx?=
 =?utf-8?B?MzlnWm54RWFZZFA0czRhNlBWeG4wcE9Cc1BCZmprM082QTlOd01ST3pSVm1C?=
 =?utf-8?B?VTRjMEplYS9lOGtXK0FIaFVpMnZWb01wamw5Z2VlbFQ3am8xdHJFcEprSjVt?=
 =?utf-8?B?dXhxUTBJZENydTVzQkdWMVFtV3hBUlVHZHV6czFkTXRDNUpuRzg1YzlaWis0?=
 =?utf-8?B?WG5nMFFTSC9UK1FibWZEOFJLenh4KzF0N2FOWWVsL0VMT2lwYUMrZFE2MTNB?=
 =?utf-8?B?VHNjOHM4VWRCZ3VrQXJ6SzRYaWRjazdaYjZNSDYyYVYwZFoyTzNYL0FQenpL?=
 =?utf-8?B?M0txVGFPMmd6OGlJRDR3eGoxV2hiaWhybnNaeGhkMm9yczh4RHhpTFNOKzBn?=
 =?utf-8?B?cjBYNlQ2WVJOU2pyYzJ0Vk5FbDZZeXBUK004T05NYXprQ1hMekVrR1dPOVM0?=
 =?utf-8?B?THJLZitVRk1QdE5jVjZtWVFQbm9wd3dzQWQyY2JZQXd3VnBuRTFXdEVHR2Zy?=
 =?utf-8?B?K2k5NjMxVGhyVWw1cE5IVE5Way9jaHVxZWFZY1ZzNDdiSVRoQVBZdkhSd3Nw?=
 =?utf-8?B?WFp0RDJzdm1iWEtHUzRxajd3UUM3ajlhMVRqenhOa0V1QW8ycTVDaU91MEtZ?=
 =?utf-8?B?WXgvOUwyc1NiZTMvTDUyQXRUYXV1d3dLVXp1MWhaakV6YjBDTFhhRHg3blZy?=
 =?utf-8?Q?o5/lnXdOHtcEbjlFlQclTdo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXo0anVNQWNqSC9JVkZ5NHpRUlNmS1g2SnltK0JQS3ludWFVUHRBVXJqdWF6?=
 =?utf-8?B?clllU083VVdTVWY5VmwzemxUYjBVdUhydm15TThGRXVsY1J5eUJxdEtaNENa?=
 =?utf-8?B?WkREcHN0bi9NWVR5VUJ4ZFZQN1pUZk8yazVEQXZ6Tnk2clFpSTV3eG1lZkdT?=
 =?utf-8?B?VFpQbndWYm5tYWZCcEhjVkxCbkJ3R2tQcWZEOVNmZUlSMGdjVTNEVWZpZ3pG?=
 =?utf-8?B?RHRicVFnVFgvWHN1MlgyWVpEWThGM0xPcHdScklTL00zN3Y5MVljb3Q5SUIv?=
 =?utf-8?B?Skd3WkMzLzUzbXZ6YVFRNDE1bytwNUNWdFJCNTZMZE5ZM3NBQldKTmQyUEpl?=
 =?utf-8?B?Y0ZKQzJwZGxEWUVPVERGYU1wNEdiL2lkUlVpWWVGYmtGcndFWDMyYkswdnY3?=
 =?utf-8?B?Y0tZUU1URjdETXN4anBCUTRuSkFSQStqeUpFMGdkd0tKcE4xU2M0aGxsTzI5?=
 =?utf-8?B?SEpWdTFBYjZ5Sm8wMWtFTk44VVBjazVNZFZsc1BNVlJtZnlFQUthRkM2LzU2?=
 =?utf-8?B?U0RaNlpkVno0NjBuSmlzQm55NkFLSVNBOW5KbFhxLzRVUUFaK1QrdXp5S2Jm?=
 =?utf-8?B?UTBERUtlNmdYbTRESEV6TDlxckVIeVdCS0ZHMUQvU2ZoNmZabGRvYk01K1hr?=
 =?utf-8?B?MWxTSWNSTzFzK0tyWW5aT3d0S1QxV3J1MjlCU3V2WXlmY2RIUTZubmlMMjRE?=
 =?utf-8?B?M291bUFORWNUWnVaSWZCcGl1elk3NllwYU1XeFdFYmJmazFyRnZxQVRHWEZr?=
 =?utf-8?B?M0pLTnJHelVpRWVBSkZBQytPSEl0ZFpqaHpBL2pYRmlYTHZJbFZ2VFVKcEZH?=
 =?utf-8?B?RnhwRElwVGZIdjNDM2tGZDdOdy81S0lnaUw1dWxTQ0Z1VStRTGs3M1RrZ3ht?=
 =?utf-8?B?eExobWU1dDFaS28zSWNEWThOM3NVcmkwQ2wvcHg4VTF1eTUreUpkK2E5MEdl?=
 =?utf-8?B?b0lWV2Q2KzFLUTlmZUtMTEpadlVnelY3RDVGSytibDFIYTR2c1NLR3dFU1Ra?=
 =?utf-8?B?Y0h3OWxmVEcwNWc4OENWSzJOTm9sOFppaUtDZTFvS1BBa2g4TWNRWWkwZ0NU?=
 =?utf-8?B?dTF0eGlZK3lvZXVSa0oybkZNMi9xb0Uvc29SY1lVL0lHVWsxVzhMRC9PYkt0?=
 =?utf-8?B?WjBjZzA0VE1tTXRmTUl4aWgvTHFiVEsrTTUyYmVIaCtEWXg0WmtyczRxL0ky?=
 =?utf-8?B?VStGR21nU3FTUktJZXJLSlpvMHFjd3dmcVIxS3QzRUx5UTJCTU9FdmUrcU9P?=
 =?utf-8?B?bTJnTk4vZTRNMldlV2N2MjhHc0dRU0hQbEpGRnN3bjF6K1VLenBwT2d1N29m?=
 =?utf-8?B?N1hEZTlZbW40cjJYMzJFSjluK2tNVzVYN1hGNGFETlhnMVZsRCtiUmE1SlpM?=
 =?utf-8?B?RzNNaU5mQThLZnZtVXR6Wno0R3QzbkR0cVArL2FQcy9ZamFDQWloZ2pzNjJF?=
 =?utf-8?B?UmZ0OHQ4aXExUEJZZ3h2bXR4SlhrbHIwdUkrNDhoUHdLQTBKc01xaGRwbS8r?=
 =?utf-8?B?TlhaY2NVZlRZeG1KeW1mdU90QnNjdk5JTW5HSGp4bWNEMXZSV21CT0VvMWJJ?=
 =?utf-8?B?aHFPb2pUcWtaNDhWK3BwV0lmQy9NSFM2c0s4RkhlcE5vckdMTTZlVWtQOHRZ?=
 =?utf-8?B?TTB2SFpJS0VoQndROFBEekZKNEhBZzlJeG10TmNlUis4MGthWlVYOTUwL3pX?=
 =?utf-8?B?TUdzTTdYMEdZYkFFSDFvTXA2MFNSL2JNdCsxaDhTNCt1Z1hwUE9BWkt0bFov?=
 =?utf-8?B?OW92cEdQUUR6QmJKbExpZDdtalBCWTZvV1ZVdWZlWEoyMVhBSXdZaVQ3R1VX?=
 =?utf-8?B?OWpXZUZwVjdzTTlseWxGL1VBUE12Tnhmblk5K3gzSFIvcVZWZnI3ZWdlMDE4?=
 =?utf-8?B?QW9YOGg0NHExWkZ5RHl4eWxOcmNVQlE1RE82QW02Wm5tSnZxZVZjbGU5QkJU?=
 =?utf-8?B?UmdpdmpucWdIbk9MdUdtSW83QjM4RjROeFhXQzFFcVhCTlppT29IWDNvNURs?=
 =?utf-8?B?Ni9aVVk1cWxvT3BTMzBBdEZHL2pDWnBjYWtFSmtQZmpERkl1bDFRR1VDQkdj?=
 =?utf-8?B?MGFtM052NFFqbUo4bWhiWHlVSEVMcFUwVFpXUjQzSUdBRjI1NDBjS1g2N3pr?=
 =?utf-8?B?U2NxTnNwbis4VUtUUnBwQUNrNUV3QU5pb3M2R25LQW5iTFV3UDVveXArcDlH?=
 =?utf-8?B?N1doYS8xNjVoSmxRL1hwMjJNYWUrSE5hcmRuaHVvdkt0bTdRVUNLczM5VS84?=
 =?utf-8?B?b3MvS2JrOGF5Tk0vWjNFWWE5Rk1ySVVaT0Fta3gwMzVCdUpNUStWNE5LZHE0?=
 =?utf-8?B?NGJTWVBlWVVLMzVTSExWOE1nUHNQSmtsVFp1RHBTcUVDS0hRSlArQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 921cf2a6-1b31-4c9b-4a85-08de60662fb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2026 01:15:13.6363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t1BQkSzKkZqyBFyY8IzIKFsmeKA8glGesQ3fyHwJtpeX8J1HBi62/PxrNlKLqHqN9BdZo11JOvv9kdS4UELEHuPrHDxt8j7uoF4sRlzZeKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6426
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 11CF51C000C
X-Stat-Signature: 3b9fohc6ed5xh49w1mgq4rzgmiteomfo
X-Rspam-User: 
X-HE-Tag: 1769822125-895108
X-HE-Meta: U2FsdGVkX19NXj/zqjrYvrIOosxFKTKAXZaVcMrpUAkLokG47uArXTgDI9O9ueuwHM91jB6tu3ZPCJ0YURSYz2FZJv3YHno6J2Gd/1aAAlONqwqlZyAegwjz3v2hLlTP98b3PwlZLBS/KyDoRNz8dLCQgzip93C2ADJXbkzyDoL6ej/RNTQ1dIycglbJN+hkbgRvh52CA6Fveks8sUDlTIW0Q8hVu4n8riKqIzYAfxry01t4jJrg9a4Mg9CVPUi4n0ab8bYhWvnKSQn2njW/AGTM0rAKLpACjmq3r9l4kbIRoBiT2kNM9P615X9Tpo97tjJT2xbA5aw3W0CnOoJA6wqNiR36beLQ+O5vPbyYbZm7qqPPZJ9x7msntyy9FxtltjJu8vs0job7+OmwX/nJqVCl8XwZfv6saCQNPlvaTgbSK71kll7lsa+dj59VYIUbJkv8oCDtin6QyKbm5Coeda61UaCHolon+U/YwVmbmwJg2oo9ibdbwWygegvSqfZz6bh48ZOlgO1Fz70tasD8xkELHXSy5kY99ub1Ty9kIz8NDtvsUDHROzAVgnU3kjArN4Rd7Axpdcaq66moGEDJIxdVdRF9csrwPMV6Kd3REePYrdMnCjb9+KG4iNfgvslLz1MS/Nfe7q7NTCkg4Iu1Dx456NyTENRfvOUkWE4yvGLT5rELt3WiQx85pjLmDoouaxuA6aAMkXLBICr11gocCx2EPULcT/f1hLU4KmL0ZG5rVmI7su851jkTXEYiX2YUOsx3GvfoEZJcKb+FlHmCyBFS/Hdv+OaJcmNZvCM1S+/iqHTeEevzpSzj0zo8UEu4fgoBw8FKFnvEJpxJ0DGNEKvwjbk52to9syWoSG8kcY4ATp7QFRt+yvN5erJTfmoZkRfrqbToFIjbEbOqnSP4nnt2rN3xP1brkO6MTP1172+vZYAb3zQxqCOqBQGsdx7/FHQCxNdcP1MVcz3gjQP
 bg/QbBNH
 DejSLYauIZUOkE044GMC0y8GSRY5SgDmtCovPPspVe22FI6zeSkjQGdZR2XvLiTKD1N4O5bFWgTy42tnD0JQP/wPPlD4Cvk4eF2189cRy3ku11l/DcybFrcn5RiM82dRG81O1ppBDCh3G+SEZxg9WQTA7Y2+oguW4Nuhpjq302NjmJBBJ7Qx0Qpefwb4LS03tOjiESvcUmoViIjq9LRl9jAqMnT57+n49X0Q0IHiSifcoJjWhCgdkWFOYRu+CWp6metTAri5SmgMz6QKx7fsGXLpdRm8s0+nWlRGK9kT/nwdBOBpClCQZIQbGa2UCGFpKQUzC3CRvAT7I/Zw+BewNq0zheL7tQFVdgIiftnPcfnMUGh0oq6beZeO5XkZtt24fsXuAPbChNiDBsDsIYhiLBdORrG8P6+hmxnGbnQY9v0gapw3+zQ0vRzjX6Puk+zk1Op2YSuyoD4j9ttmRpSmQYlhKE+PxXwVxM3n6fMQvRCRhhgoQPsOkAA4Xn6O+ZbjMReaeqfppCvKz6Dq3+sQ2xVuWrUl3X2360zRiO6Rjt2m5Jdqj100cV2aLzj3b1s8Fq48rb2+KtvSXwLk0KBgw0BIBl67enbGOTZhdLhfoVoUQoVXh8LvI5ZXVEWwZR/7XQNS6G1YYI7r4KzlivUuWbuwH3Ihbpm3OfjukrxK028eRThDEvISocBJRspaY7092rW/ezuvAH7N8s6naanFSe9Uh8fwDwIVCuJmePK7Jixc4rd8kKNUEe/9ik/bGrC3DvOPIXKWJAkcWolZVF/7yO34TmnDepaM+eqwxPiZVoJ10gnvIV9fBDjURyUymX4L0VsNwhpj3NmXUELsHjDJWJ/IQrIj7NxX1CLD6UbQ/gdP5bnr/h32nmYVvAaOwsGlalSF4JJKTx3ktnZkd3mWaRAidzKllmrGX4wUPCUzBJ6WtnqRsbDrAmb0u4p9iB8+Q1Cbi8l2DqPXSg8a1te/GqdMmV505
 xaULxQES
 8qdyyBa400Nv9jHZfWjjwA9hHNmnPTam42ZzBfAkTSBD0LnhopLEBEne1bWhfTpF1JmtsIyGPYgTWohwTfOn6cMMCKljcA2GFcAun+I7eDvOb6vfEIx4VyoNwJ2fDES/fOv/GqfCqoI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE5oYXQgUGhhbSA8bnBoYW1j
c0BnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgSmFudWFyeSAzMCwgMjAyNiAzOjUzIFBNDQo+
IFRvOiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPg0K
PiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOw0K
PiBoYW5uZXNAY21weGNoZy5vcmc7IHlvc3J5LmFobWVkQGxpbnV4LmRldjsgY2hlbmdtaW5nLnpo
b3VAbGludXguZGV2Ow0KPiB1c2FtYWFyaWY2NDJAZ21haWwuY29tOyByeWFuLnJvYmVydHNAYXJt
LmNvbTsgMjFjbmJhb0BnbWFpbC5jb207DQo+IHlpbmcuaHVhbmdAbGludXguYWxpYmFiYS5jb207
IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7DQo+IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsg
c2pAa2VybmVsLm9yZzsga2Fzb25nQHRlbmNlbnQuY29tOyBsaW51eC0NCj4gY3J5cHRvQHZnZXIu
a2VybmVsLm9yZzsgaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Ow0KPiBkYXZlbUBkYXZlbWxv
ZnQubmV0OyBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRiQGtlcm5lbC5vcmc7DQo+IGViaWdnZXJz
QGdvb2dsZS5jb207IHN1cmVuYkBnb29nbGUuY29tOyBBY2NhcmRpLCBLcmlzdGVuIEMNCj4gPGty
aXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47IEdvbWVzLCBWaW5pY2l1cyA8dmluaWNpdXMuZ29t
ZXNAaW50ZWwuY29tPjsNCj4gQ2FiaWRkdSwgR2lvdmFubmkgPGdpb3Zhbm5pLmNhYmlkZHVAaW50
ZWwuY29tPjsgRmVnaGFsaSwgV2FqZGkgSw0KPiA8d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT4N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MTQgMjQvMjZdIG1tOiB6c3dhcDogQ29uc2lzdGVudGx5
IHVzZQ0KPiBJU19FUlJfT1JfTlVMTCgpIHRvIGNoZWNrIGFjb21wX2N0eCByZXNvdXJjZXMuDQo+
IA0KPiBPbiBTYXQsIEphbiAyNCwgMjAyNiBhdCA3OjM24oCvUE0gS2FuY2hhbmEgUCBTcmlkaGFy
DQo+IDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IFVzZSBJ
U19FUlJfT1JfTlVMTCgpIGluIHpzd2FwX2NwdV9jb21wX3ByZXBhcmUoKSB0byBjaGVjayBmb3Ig
dmFsaWQNCj4gPiBhY29tcC9yZXEsIG1ha2luZyBpdCBjb25zaXN0ZW50IHdpdGggYWNvbXBfY3R4
X2RlYWxsb2MoKS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEthbmNoYW5hIFAgU3JpZGhhciA8
a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4NCj4gPiBBY2tlZC1ieTogWW9zcnkgQWhtZWQg
PHlvc3J5LmFobWVkQGxpbnV4LmRldj4NCj4gDQo+IExHVE0uIEkgd29uZGVyIGlmIHRoaXMgaXMg
dGVjaG5pY2FsbHkgYSBmaXg/DQoNCkhpIE5oYXQsDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldyBj
b21tZW50cyBhbmQgZm9yIHRoZSBBY2shIA0KDQpBcyB0byB3aGV0aGVyIHRoaXMgaXMgdGVjaG5p
Y2FsbHkgYSBmaXg6IEkgdGhpbmsgdGhlIGFuc3dlciBpcyAibm90IHJlYWxseSIsDQpiZWNhdXNl
Og0KDQoxKSBUaGUgZmFpbHVyZSBoYW5kbGluZyBoYXMgYmVlbiBjb25zb2xpZGF0ZWQgdG8gYWNv
bXBfY3R4X2RlYWxsb2MoKS4NCjIpIGFjb21wX2N0eF9kZWFsbG9jKCkgcmVwbGFjZXMgdGhlIGV4
aXN0aW5nIHpzd2FwX2NwdV9jb21wX2RlYWQoKSwNCiAgICB3aGljaCB1c2VzIHRoZSBzYW1lIGNo
ZWNrcyB3aXRoIElTX0VSUl9PUl9OVUxMKCkgZm9yIHRoZQ0KICAgIGFjb21wX2N0eC0+YWNvbXAg
YW5kIGFjb21wX2N0eC0+cmVxLg0KMykgSGVuY2UsIHRoaXMgcGF0Y2ggYnJpbmdzIHRoZSBlcnJv
ciBjb25kaXRpb24gY2hlY2tzIGZvciB0aGVzZSB0d28NCiAgICAgYWNvbXBfY3R4IG1lbWJlcnMn
IGFsbG9jYXRpb24gdG8gYmUgY29uc2lzdGVudCB3aXRoICgxKSBhbmQgKDIpLg0KDQpTbyBJIHN1
cHBvc2UgdGhpcyBpcyBhIGNvbnNpc3RlbmN5IGNoYW5nZSByYXRoZXIgdGhhbiBhIGZpeC4gUGxl
YXNlDQpjb3JyZWN0IG1lIGlmIEkgYW0gd3JvbmcuDQoNCj4gDQo+IEFsc28sIGNvbnNpZGVyaW5n
IHN1Ym1pdHRpbmcgdGhpcyBzZXBhcmF0ZWx5IGlmIHRoZSBwYXRjaCBzZXJpZXMgc3RhbGwNCj4g
LSBzbyB0aGF0IHlvdSBkb24ndCBoYXZlIHRvIGNhcnJ5IG9uZSBleHRyYSBwYXRjaCBhcm91bmQg
ZXZlcnkgdGltZSA6KQ0KDQpTdXJlLCB0aGFua3MgZm9yIHRoZSBzdWdnZXN0aW9uLg0KDQpJIHdv
dWxkIGFwcHJlY2lhdGUgaXQgaWYgeW91cnNlbGYgYW5kIFlvc3J5IGNhbiByZXZpZXcgdGhlIG90
aGVyIHpzd2FwDQpyZWxhdGVkIHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMuIEkgaGF2ZSBhZGRyZXNz
ZWQgYWxsIGJ1dCBvbmUgdjEzIGNvbW1lbnQsDQphcyBtZW50aW9uZWQgaW4gdGhlIGNvdmVyIGxl
dHRlciBpbiB0aGUgInYxNCBQZXJmb3JtYW5jZSBTdW1tYXJ5Ig0Kc2VjdGlvbi4NCg0KPiANCj4g
QW55d2F5Og0KPiBBY2tlZC1ieTogTmhhdCBQaGFtIDxucGhhbWNzQGdtYWlsLmNvbT4NCg0KVGhh
bmtzIQ0KS2FuY2hhbmENCg==

