Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F28CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 21:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C676B00B6; Fri, 22 Aug 2025 17:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D2A8E0018; Fri, 22 Aug 2025 17:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10336B00B8; Fri, 22 Aug 2025 17:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6FF26B00B6
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:58:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 639DB138A8D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:58:22 +0000 (UTC)
X-FDA: 83805757644.03.26A6156
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf06.hostedemail.com (Postfix) with ESMTP id 15BB0180012
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:58:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bhjVcBup;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755899898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m32BEeoiEtZ3F00P9nZR7gFt9pAqTcA4g1IoYAy6eV0=;
	b=Szb3imhi3exZO6/D0J/e3pglgQV3kBRTwspJiKgx6SP2/CH3ZU0LFmFnLDjMvFsOOHE+gI
	X62QLSPsjXWzFKqMnfuZA5cbikHJU0J3r7Bh6lDbNA6mWxm7PPCO2goUxNQCGTlb6FBQ5O
	IRWS2Au8e9tuREcrt5k7eJL78EXIUgw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bhjVcBup;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755899898; a=rsa-sha256;
	cv=pass;
	b=PgMhukDk+O/p1lSghK67gojoaQMl3nT/U1GLOe6475N/ZaXj9zalNfQzlKCyjPq6X6i4C/
	3AQqolm+3VPj40CA9hy/WhvnWcl4ioweWnSsqssyHr4EWx4OBkSIBOqhqLjzsETVTb6h82
	8WHtF6QNyOSxItt/8WipMAQizF/hhoQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755899898; x=1787435898;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m32BEeoiEtZ3F00P9nZR7gFt9pAqTcA4g1IoYAy6eV0=;
  b=bhjVcBupCC7lrPNDNi3lnznrmGULAK2rbChJZTcibIV4sIfcVFLSKekJ
   iMPf5g6WanEAm3yEzQDHOZYy+ldC9NQREGvMAYj2DafmOMxvZbOFlY8iE
   eVfEyG3oK2l97y7Pgm62TE65IzOF5R5G28hExI15FI3bgXDtpTwz6x6R7
   /o22ACewQ0gwHwVxwfh26x9iOsgg+NzPnWatZeIQQ0FFrjaSTUVa+/tft
   WW6DmY+ZCi2Wg9UhToyGGKTdKZI/IwPfpkgGJZ3IEtPqgGVRSBme28NGz
   T6VVzsrGEh5j1tzwByGFYE4aegyPZFkZIM6WlGRhzlkXqsuttCkiAfUEQ
   A==;
X-CSE-ConnectionGUID: a3qKYdFiQ5evCjEHutJCpg==
X-CSE-MsgGUID: Gbt/pPpkQtKmTc8hOKTW0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="57231505"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="57231505"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 14:58:16 -0700
X-CSE-ConnectionGUID: q0m1oPjYRD25dSeYwXb8Yg==
X-CSE-MsgGUID: HRQJAKNVTTW5PJEColqj3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="199766051"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 14:58:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 14:58:16 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 22 Aug 2025 14:58:16 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.83)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 14:58:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y/G1BpBhOXQNAgW59ZUXfAkL2B0m3htQXuuFLJYvXvkaISn5aRKIvdtpYoWGKuxsmPJri4GQgOfmq5q7I6Z5DcIaCdY2KCMFiDS7rJLPvTDyX1dQ6G96VKSRm+ml5DMOtVZX93JX6CEE+Q88NZEAdU6ZgTX2rOR8dA2QbzBk6kxdBX7NUIr0ilFfMjIi/iif1zDRHGxIVEvQB9tgZ2u2r+W8WCsADudmUI1q8SoAqYfS4ceiqY9PctoFkPNPTsPjJ5B0WU5yER7bfiw285d1WHO4UJl1D/U77jSQnDhwpyieZFgPUSQQIbpK+ONld0W8mmyVlA856gUnCO4RdxGaJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m32BEeoiEtZ3F00P9nZR7gFt9pAqTcA4g1IoYAy6eV0=;
 b=v+8pyy2kuDVM1VNPnFcjxwUj8tEhv4UXwLjCz9uaOf+KF0VTgQeeNuM+Kc2Jca4z/SNUbSlnDSFtCTVC5lTPJ114inBJEDfAVcN6CG30mAg5yF9qBIp5ape6LiQ5dj6/DyOR23/YpCo/fqCTjPEj4Qkf55kS7z0lwAkpz0aO9pzZP5Pes+Mi5KrPi3Bc4FC43F2jXHGlb8skC7gqFvXH+rbA03puJRax9waVxKKdwjM827EVJhjtvfz67egWeHj7DMdLUH7cDltR/G2nKk1b3flvlh45hzKoe7j0+/8yyT/bwIbr0SvqwKHBSUdQApeDPSIsGOsMdOtSSGTcx8/uUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by BL3PR11MB6530.namprd11.prod.outlook.com (2603:10b6:208:38d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Fri, 22 Aug
 2025 21:58:13 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9052.017; Fri, 22 Aug 2025
 21:58:13 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "linux-kernel@vger.kernel.org"
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
Subject: RE: [PATCH v11 18/24] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
Thread-Topic: [PATCH v11 18/24] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
Thread-Index: AQHcAp3rrlgug3tz+EGLnem5m/WFabRjRbuAgAvqfqCAACeGgIAAAnOA
Date: Fri, 22 Aug 2025 21:58:13 +0000
Message-ID: <PH7PR11MB8121E83F0EBE9BEF5F777466C93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-19-kanchana.p.sridhar@intel.com>
 <aJ7Fk6RpNc815Ivd@gondor.apana.org.au>
 <PH7PR11MB81210ABFD0BF9F73214080E8C93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAKEwX=M2HCsPZVmXpvpAuF2N=4BXbXAMQMrLLRp7nCdotb=abA@mail.gmail.com>
In-Reply-To: <CAKEwX=M2HCsPZVmXpvpAuF2N=4BXbXAMQMrLLRp7nCdotb=abA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|BL3PR11MB6530:EE_
x-ms-office365-filtering-correlation-id: 3b24b06b-95fb-4f5c-7a02-08dde1c6fdca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RHd0TXYrZWVERUIxTnZzcnIyajIwa1VNMXgra0VjanRkY1ZmQ2pXc1Zna1N4?=
 =?utf-8?B?ZVpVNXFrRUFFZW9ZUTZGTEUrZ1prU3o5RlN3QlZsZlpFdzhjY1NKYSs0S1pJ?=
 =?utf-8?B?NVpsMHY3dE5tUFZSaEhYZW4vb0VMc0xESHZOUHhTS1h5Z1VaTGh1cUEwa25x?=
 =?utf-8?B?b3paR1pSTnhHT25SQ1dTZVJ0eW5ydVc4MllVVTF0eDBrMXlYRmMwTG52emRu?=
 =?utf-8?B?YnVyZDlHemNuSHpGNC9kQlp5K3dadjh6T282YVkwVVpDVVBGR01DUVJsdm9a?=
 =?utf-8?B?TzlreWhMMkdzRlFxSWVvZUQ4SmFNcEljeU9QeGkwamNlRFNwWFByQUExcEZn?=
 =?utf-8?B?elI0TzhmN3JmVXVBdmkwYk9oRm83d2N4dkErSVhrOWd2TFBTM1grTVdMSllX?=
 =?utf-8?B?SFNydCt6NFZkMjVvUTNINWFMcXYxUTBHQ2liVzIvMGFWR0p5VUFnMlNMQjI0?=
 =?utf-8?B?cGU3ZUw0cFBQVkVPN0liTzRmdE02TnY2cHBiN25OMlp1Z2ZlTjc0VkZZTEdt?=
 =?utf-8?B?YkEwWUZZZHNLdWIxZnE1YTBFUEIzRzFla05qdHZkaS9CenU2dUlrUUxZM3Vu?=
 =?utf-8?B?enZSeStjblhQc1AwME9mRXpDUHF3K3E0UXFqY0J5SmxKcnZiMWlHZXNGR3U4?=
 =?utf-8?B?YUV4b0dJS2VTRUIzUVBuRkJxWE5FaVZyaG5neVJxNjJONmN2WjJyTHdGK1Qz?=
 =?utf-8?B?ZFpPdnMrMjZnNElZNXlVb0tZTnBmYUR5R1NFZnpYRm0vOTIzbWJCaEZiTE9m?=
 =?utf-8?B?WTRtRnk3MlBzS0xDbDJDUjZUUkNPK25JeFREYnUwWW1kVE10M1c4WXMvQ1p2?=
 =?utf-8?B?ZmI1dUM5NWtCY1pDOWRWUEg0dGdXeG9WN0x3UUpPbVBnWWl0R09NT0MrSVNm?=
 =?utf-8?B?UFNSeWkvRTkySkZDRTIyWHRYVTF4dVNWOE9XbXFNdlM2UGljNHVGcjNOWnc1?=
 =?utf-8?B?cXJ2MVhXRHNrZ3dnSGZNYTdrc2FZWTZFeVJzODI2RitPd2VrTXR6MUM4alpv?=
 =?utf-8?B?NldBZnlMV0Vpa0RKNkpMc3Nkcng2NzRUd1BSWWFuK1p6NlhEU0x2YmNTaG12?=
 =?utf-8?B?K1ZjdWlYQWh4M0pwWXRKVDhTVzQvbmVZbjFsVlZ4NHpKalBuK1llY2thZkRh?=
 =?utf-8?B?WElieGJYMXhiNDd1UWQ3SnVsNGtnNXRiaS9EZzJoc2FLTkxjWXBsekVnb2tR?=
 =?utf-8?B?QjhOdk5nQnFHWHFad2VLV3Y1bmVTR3JCclBNYTRDMDRmYUxNdVZNb3BmeENs?=
 =?utf-8?B?blNXMVVwVHhKa3N4cTFEdUlVZk5JbEF1SFBoZGNUOUMvaVd4REkrM3pFYkw5?=
 =?utf-8?B?bmtWUHh1N3k2MHkrZ2JaVWVJSWFOc0tmdCs5YUhpVDZTdHpwRVl1bDVDTnBu?=
 =?utf-8?B?QTdJMkNmMFB2ZmkwNEFCNDRYRi9hcmY3d0lLRStVOVFiVnc1MlM2dlJ1NjRa?=
 =?utf-8?B?YU1ORzRpcThSTWZXRVI5QVhDbytFczNSNFdnN1EvaXFFeFJkUHk3VWRVYmE4?=
 =?utf-8?B?QVBPeFU3OGQzSVFzSG1zS3NrbjQ3RnZLbmllMzdsdTliSHNWc0hyNmhyakRw?=
 =?utf-8?B?OGRGS0E2YzZQb3hvak11c1czV1AyRDJZdllXaXJLMTBDZ2pYODZONUZiYmJC?=
 =?utf-8?B?THR4aGhjc0Nsb25PVWhqb09oZXE2OUhvb0ZQcEFlc3ZXelMwdmNDaTJ2UDRq?=
 =?utf-8?B?ZkJuTHczeWRPZVZRdFgvRnJ5T0dPRFlwSEVjMmlsSDBMOHpZMXNJR2xPQkFi?=
 =?utf-8?B?S1ZrWHFFc0JoL1p0NVIwUm5zRjVUZXBaNnlob2tYZ2s1aWoyYlpCK2pVMHBn?=
 =?utf-8?B?ZTNXREVzNkVFYU44bnMyUEFSOXpJQWt6dlQzSHhrbzNKYzVPUmI3MmJ3bXpo?=
 =?utf-8?B?bUJEQUhPbEhnQzdFc3BrWEhKZndCODZldVNnQkxvMWNtOC9DZEpQTURoWWF3?=
 =?utf-8?B?VVF2TDVIb1BSMHdreGlZUkFrdHQ5b3ZjakxPaEY4U096bGtreVRzN0tZcEhH?=
 =?utf-8?B?UmVteDJtRE5nPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dW4xWjNGQWFCRWFmekF3djVtVVVqbzNWQ01YZGlQd3ZYZFEzK3lmUndRcEJT?=
 =?utf-8?B?TmhGWndPcXFkU0Eyd1h2ajJGeStjV0ZVWmd2eGorRkdHdUpHeVpmWTBFREZ5?=
 =?utf-8?B?VWk1WEZISXZQUjl6a2FUc0kwdTY0Vlg1YlZYSWJFTzRIQmJZMWJucTNEaTdV?=
 =?utf-8?B?QW93WGovOUkrVWZlZUNmTU1GQjU5QkNJU0RwU2RPelM5VHRwUEIrOEI3NG5I?=
 =?utf-8?B?QkQ2dDRDQm40SE5TU0lLZUNIcTBQaGt0OXJyemcwMWhnU21rTkZ1WkNiYWs5?=
 =?utf-8?B?L2Ryd2FhL0NBak0ybmJyOXdvdG5uNm00eG1HQThMc1IrRWpvVlJGMUhkVDFZ?=
 =?utf-8?B?S0tsUWFQQ3MwdHdYZDJRQk93cm56MXNVc1hZWjNHMHFCYnBzRjRFRDZ5SVBu?=
 =?utf-8?B?S3ZXYk5uek81VHNIQlBwR1c2dXM5anVLck5aQVVIeTdSazlmajN1MWpsS1JK?=
 =?utf-8?B?MWtBTFBoQ2ljNG05bGhBcUY0Q1ZUWWNveEgxREE0R0JkUkI0Ni9SbERJU2J1?=
 =?utf-8?B?MzFIbUQzcHVCZ0RpaWVlMndrdHVLU2hRc1lrbUh5TWJOMWR3bTdVWFdYeGZB?=
 =?utf-8?B?MlBRdk5vYzJ1V2dGUUdWdE9FTUVsNVhuMUpvM2ZLcUxBUE9uVHNZZUlsU2hP?=
 =?utf-8?B?dkpMcjA4NWYvUFMvRy8rVjV5TnpzajgrNFJYZS9salZoTzlDcDlNOC9VVjdy?=
 =?utf-8?B?STVPdlI5dmNnZVJSK2htdmVsSDUwaFVDWjRVbllTMEdVZFVHQ0ExdloxWXda?=
 =?utf-8?B?VkVvdTFHY2tBbnNIMXZhWVRMNnRrL2FUaTJmWlU5OFNIN0NjSWxvNm9UYTFF?=
 =?utf-8?B?RzV4VUpYb1U3QlpFWVVlVDh2ZjZHYit0Z3RyTVZydE9BZUExb1NqQitMQXhz?=
 =?utf-8?B?dnJGM2xLc1Ria0hxQ0IzSWxIZjhzdEJjQXFsaGp1a2RRaTZGNjNlSHg2MFpM?=
 =?utf-8?B?eFBRUGhjS09hbUxySGFjRHRMMVFweFZ5NTNJNEtXQW12dURYOGl5dGhwbU1T?=
 =?utf-8?B?U2tVVk10czYwZUtaL2E1L2FWQjF3dmdtQm5OL2tnbDlpcmdEODFrRVRFanor?=
 =?utf-8?B?YjdyVGFWTDV2allCY29hRjlHTmhRaHI5NjJzaWxyN2REM2RZaWdRRG5ES290?=
 =?utf-8?B?Q1IrWURMYnRCUEZNSmJJck1aTDU3YTdtZHBTb0tMUDBGK0Nzb1o5aEl2b2Zk?=
 =?utf-8?B?a0x2ZFNtMFZlcFVueS80Z3BSWVkzTC9Uam1aNkVZRDhaNHBmWGNHZ0hpWndW?=
 =?utf-8?B?UHFzaUZkalZxQ3lMc01Fb0dJMy92U3lpbzVNL044WFdQTU5uZ1I1Rm9KNG5Y?=
 =?utf-8?B?M0Y3QzBOZHU4NGpuZG5BSGZFYnhkeldVZEVwdzJUbFN4ek9TcUc0cWgwKzYz?=
 =?utf-8?B?MjI5dHBldWlwZmdORXF5eUdQbWd4TFkxQ0trQVRTZWlLeHc3WlVRcTh4dHRt?=
 =?utf-8?B?U2x5TSt2S0poR1dhS0F5MXE0dGNmOENJd3E4cWY0Y3N6elFsUU5aUXhFMm5s?=
 =?utf-8?B?U0Ziekk1cVBDOXZmZ1RYNkVMOTVvWmlzUUx0ZWRkd0l4dXplSVlPNnM2V3Rw?=
 =?utf-8?B?TDlHQlNKd0o1T1oxL05WOStmMVVGamRKcnNLa0VvOGNqZzY3dDhlMHpiTmxz?=
 =?utf-8?B?L1hkZ3U4RWQwNTREZWxUNlNoZVFNdUNsSzdLWFVJZitHQnI5WS9GWHhCRGl0?=
 =?utf-8?B?SnA3d2FnT2dYVXNtQ1FWYXhvWmlNbXFrakRCOWdUalZTVWl3QjhiVkRwSUh3?=
 =?utf-8?B?SklaUytVbkkvbjVML3gybFdkZkV2TDEzaDdRY1Y0QjJsQWt6Qks0ajlDK1ps?=
 =?utf-8?B?ZVR4K1RyUkt0L2lIeG9Od3JsMU9PQnRzanp1K29DU2lQRU1Rc0hPVEZzMW83?=
 =?utf-8?B?VlpEaloxUGEvUUFoMllmamZXNzdqUlN4Qm41VVZqRHFpVWhzeGhtdElwdllu?=
 =?utf-8?B?b05hZU03Y05OQTk3N2hwOG5LUzlCUjhSb2JRQ0NncFpoU3c1c0VLY1JzUjIx?=
 =?utf-8?B?OGY2L3g5WkExbnJ5UmRWMDV6Q3ZTelAvKzZDUnJSSWhURFVhRG5yd1Q1aEhk?=
 =?utf-8?B?Z1dsb3R2bXRyUFRGOEQ0b3lTOGU2Tm45TmhzZE5IM0ZaTjdTYm9WTTQ3U20y?=
 =?utf-8?B?cFhQTVNDTWRxbHAvQllmZHBuczVHQjNkNDhhdERWcWVqS2k0OW5xYW1wOFVO?=
 =?utf-8?B?dFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b24b06b-95fb-4f5c-7a02-08dde1c6fdca
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2025 21:58:13.3995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QkADjn2t+gPl/l1VEzA28LEJ7SwhjYvOZur2M2VNUgejQuDojzMHvWxlDnjIuNCEPpjsq4uSzakhScOFBqXANhzve+81KNvaY9GZRqvtit8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6530
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 15BB0180012
X-Stat-Signature: w1xbnpra1uyxwz86ud4z8egq611mxqes
X-Rspam-User: 
X-HE-Tag: 1755899897-999504
X-HE-Meta: U2FsdGVkX1+p1jsb2Krz2mMK1opCERHDP/VdoY3GLjuunhNh5xf76oAYQZ7Zr+7cvvjtSNHY1ewaxmBWv/dZ7ARcQaYPeuy8nkgttILZyY57XoZTwMxJr2togtlLIZFLzNgxtjbiyfcF4NGLGmS9+s1npx0dI5nDHHETVtO//GOgZRWj6+pQaaZUWT2aXAxwhfWnhFxcGeoR2t+dX4lkB1COsjjfMcKL3auAdCKapeqJqCriK2Iui9VbAoUNqRvPbnQkSENmFPJCKtCPOII3BO6um6pmw8ylHDlLPIqDF72ikswuAop2UVNRg/ZnamqHF2zutGJWGC6Dy1hROs833UGDRJyCJ8Pnv92CR1lLYFvUg9vijBOJzBC5SejG/aGtwDd/ZgeShfaqbJl6uILWrioq0UkBOhjdXYOxt4v1VooV+KPjcIdtzhhHtFNy2xFJhz7WoP+UuxObK1fWSF1vNRwYlHCj/9qWNaB4tux8VGgTdY3le608SRiC8k9dAyHwin/7SPO6RSjO40akU2qP0jdEh09VeaAScemkylzXyBJOlsANBGNJWqInvmJawglnlHnGpPqAeXt33gs24Hxg56oaq3wxGOwriPYFe08lOINELhLx/mWwh5J4FNET1y87HfK5Uy4kTW3do50yBCZuPcqK8jgNKGCpdxUsq7R8k3DDhoiXFmLwETJOcAb5DdtkFh0U4fkLJ2Mv+kHd13aY1qxMdyCAtt4jloem00T3SK8GVlXikkgie7jHOFG2EtjsXj4s7iQ8x6EUb6vKcKxX30zwZL+1mrp2F9DDq7n4240o4HeODF197ToGxItOQgfJYBP4syerv7/IgfjlvldyaPP1WUIrK1xJNFwHrQG8nC5BIRI6+qSF8zA+rn0wxFruxbn+MC3BEmU7GnJwRJYXTt27Q37OEnQREen3YQ0RgaG//AA7565C71REOkb03ySWNDXMfPycktaz41Zs0FH
 5R9SzL7C
 YYrHzfr/bIcULe4jVht7jAq/I8N9b0MsiC7qyYEVOgXhXeKg9Ih5YUDrrLtS1Ab3SQNF65gl5hhyjfqsOoa71++hDQdLWJ/yG1y4CKqzVA+tsAhkkiQmspIhAOgPD+/RH9gzk+odrBYcinVJYbQy/B3MEMtLQLg9SY4Hz4IErlz+JhJvNOP6jm0qFhXvOEBiM8zScaLtMRBDmuwXa7IG1AIGjsZAqLZRNG6HFBc59x/0a3ceAnMbUb5Wz68qm2DbwzOKkCXeqPY0JeaexflYPBqVhcMFo3455dXV2oGnNiXXDSnS9W3AXkFG4SpJl1GDAzBLNJU/713uzvi056WlRSWAYpEki27o+h0AcsvxHM3iCFevnQrJqJzODjDGT7tqF1puiBAoFzVamFxXOHtUte1/TmAUnFcNzmGyYGhro0w2J8PG32epJihBBPwFFT8lm/M7E2faUxb3MglsfO17mdgdxroUTYwajD9qokeemxotD1Sd8BtkWtqXxBx9/ouHHpu60JV6ov9gMJn/se4Q7CBn6fjcTht+2OhfammY/pJjVwU94Jh1NFnTqO9Uqtj7IW/X3Vlj/6z3bTn48wc/TDDY2hyuCT2BwNJB9QXozRpW1b9HeyMfTmfGeL0fP1MFy5HZp8cPcGfV4y7Z/R+MDciN746SfWonXZgp04WJopVUs/gWeKDbI3iwPESItFU525AQFn7AGW2ogwfoZq9m/F2VhwothRqeOntHz5ko6cQg+cvwGmFDRrlmeAHQzkXH2MS3zyLWlMILS+c+qNtep6nX9qPxWIDJFXoTuybarBNYL8S57I86jTzgMKbgbAz5+G/jK3QLhE8F5G8ZNd3O8aXyJ6Ku5S1LWBgkTHJlSfWMJgKfoPau1jIYAtc5GvTDAm5HATnLfzyzs8FoF6/9waNF52vJ53I4bAOIXE3PLVs6UJwUT92Xf3bdKUZRPVmx/GGd40tNsLD5+n8RFxwIR99ZGC4bF
 Hrt02nmq
 zQQ+HIx2FD6hBxXMqKWCI5jizJ5jnn0HYdMU1dBCHs7V3PGFZ6N5DlLz17Rg1dajNYYt6knM3q17KcKT8YcRcEOCKqlQ/P8I4G8ZINv4/LFH5/piXc216GycYstYJvxSqFrhY2i5Km3tpCCyeQNppqRPMCorU1dIy7c73++S/6IZRNancuxN8jzM9MC63VM3q8fyrM/UGQy09kDejY9Jbdfv/e+Ge2XBpVUqffKEkOjTqf+gEuzmFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE5oYXQgUGhhbSA8bnBoYW1j
c0BnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgQXVndXN0IDIyLCAyMDI1IDI6NDggUE0NCj4g
VG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+DQo+
IENjOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBsaW51eC0NCj4g
a2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOyBoYW5uZXNAY21weGNo
Zy5vcmc7DQo+IHlvc3J5LmFobWVkQGxpbnV4LmRldjsgY2hlbmdtaW5nLnpob3VAbGludXguZGV2
Ow0KPiB1c2FtYWFyaWY2NDJAZ21haWwuY29tOyByeWFuLnJvYmVydHNAYXJtLmNvbTsgMjFjbmJh
b0BnbWFpbC5jb207DQo+IHlpbmcuaHVhbmdAbGludXguYWxpYmFiYS5jb207IGFrcG1AbGludXgt
Zm91bmRhdGlvbi5vcmc7DQo+IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsgbGludXgtY3J5cHRv
QHZnZXIua2VybmVsLm9yZzsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgY2xhYmJlQGJheWxpYnJl
LmNvbTsgYXJkYkBrZXJuZWwub3JnOw0KPiBlYmlnZ2Vyc0Bnb29nbGUuY29tOyBzdXJlbmJAZ29v
Z2xlLmNvbTsgQWNjYXJkaSwgS3Jpc3RlbiBDDQo+IDxrcmlzdGVuLmMuYWNjYXJkaUBpbnRlbC5j
b20+OyBHb21lcywgVmluaWNpdXMgPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT47DQo+IEZlZ2hh
bGksIFdhamRpIEsgPHdhamRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBHb3BhbCwgVmlub2RoDQo+
IDx2aW5vZGguZ29wYWxAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxMSAxOC8y
NF0gY3J5cHRvOiBhY29tcCAtIEFkZA0KPiBjcnlwdG9fYWNvbXBfYmF0Y2hfc2l6ZSgpIHRvIGdl
dCBhbiBhbGdvcml0aG0ncyBiYXRjaC1zaXplLg0KPiANCj4gT24gRnJpLCBBdWcgMjIsIDIwMjUg
YXQgMTI6MzHigK9QTSBTcmlkaGFyLCBLYW5jaGFuYSBQDQo+IDxrYW5jaGFuYS5wLnNyaWRoYXJA
aW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+ID4gRnJvbTogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1
Pg0KPiA+ID4gU2VudDogVGh1cnNkYXksIEF1Z3VzdCAxNCwgMjAyNSAxMDoyOSBQTQ0KPiA+ID4g
VG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+DQo+
ID4gPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3Jn
Ow0KPiA+ID4gaGFubmVzQGNtcHhjaGcub3JnOyB5b3NyeS5haG1lZEBsaW51eC5kZXY7IG5waGFt
Y3NAZ21haWwuY29tOw0KPiA+ID4gY2hlbmdtaW5nLnpob3VAbGludXguZGV2OyB1c2FtYWFyaWY2
NDJAZ21haWwuY29tOw0KPiA+ID4gcnlhbi5yb2JlcnRzQGFybS5jb207IDIxY25iYW9AZ21haWwu
Y29tOw0KPiA+ID4geWluZy5odWFuZ0BsaW51eC5hbGliYWJhLmNvbTsgYWtwbUBsaW51eC1mb3Vu
ZGF0aW9uLm9yZzsNCj4gPiA+IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsgbGludXgtY3J5cHRv
QHZnZXIua2VybmVsLm9yZzsNCj4gPiA+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGNsYWJiZUBiYXls
aWJyZS5jb207IGFyZGJAa2VybmVsLm9yZzsNCj4gPiA+IGViaWdnZXJzQGdvb2dsZS5jb207IHN1
cmVuYkBnb29nbGUuY29tOyBBY2NhcmRpLCBLcmlzdGVuIEMNCj4gPiA+IDxrcmlzdGVuLmMuYWNj
YXJkaUBpbnRlbC5jb20+OyBHb21lcywgVmluaWNpdXMNCj4gPHZpbmljaXVzLmdvbWVzQGludGVs
LmNvbT47DQo+ID4gPiBGZWdoYWxpLCBXYWpkaSBLIDx3YWpkaS5rLmZlZ2hhbGlAaW50ZWwuY29t
PjsgR29wYWwsIFZpbm9kaA0KPiA+ID4gPHZpbm9kaC5nb3BhbEBpbnRlbC5jb20+DQo+ID4gPiBT
dWJqZWN0OiBSZTogW1BBVENIIHYxMSAxOC8yNF0gY3J5cHRvOiBhY29tcCAtIEFkZA0KPiA+ID4g
Y3J5cHRvX2Fjb21wX2JhdGNoX3NpemUoKSB0byBnZXQgYW4gYWxnb3JpdGhtJ3MgYmF0Y2gtc2l6
ZS4NCj4gPiA+DQo+ID4gPiBPbiBUaHUsIEp1bCAzMSwgMjAyNSBhdCAwOTozNjozNlBNIC0wNzAw
LCBLYW5jaGFuYSBQIFNyaWRoYXIgd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IGRpZmYgLS1naXQg
YS9pbmNsdWRlL2NyeXB0by9pbnRlcm5hbC9hY29tcHJlc3MuaA0KPiA+ID4gYi9pbmNsdWRlL2Ny
eXB0by9pbnRlcm5hbC9hY29tcHJlc3MuaA0KPiA+ID4gPiBpbmRleCBmZmZmZDg4YmJiYWQzLi4y
MzI1ZWUxOGU3YTEwIDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9pbmNsdWRlL2NyeXB0by9pbnRlcm5h
bC9hY29tcHJlc3MuaA0KPiA+ID4gPiArKysgYi9pbmNsdWRlL2NyeXB0by9pbnRlcm5hbC9hY29t
cHJlc3MuaA0KPiA+ID4gPiBAQCAtMjgsNiArMjgsOCBAQA0KPiA+ID4gPiAgICoNCj4gPiA+ID4g
ICAqIEBjb21wcmVzczogICAgICBGdW5jdGlvbiBwZXJmb3JtcyBhIGNvbXByZXNzIG9wZXJhdGlv
bg0KPiA+ID4gPiAgICogQGRlY29tcHJlc3M6ICAgIEZ1bmN0aW9uIHBlcmZvcm1zIGEgZGUtY29t
cHJlc3Mgb3BlcmF0aW9uDQo+ID4gPiA+ICsgKiBAZ2V0X2JhdGNoX3NpemU6ICAgICAgICBNYXhp
bXVtIGJhdGNoLXNpemUgZm9yIGJhdGNoaW5nDQo+ID4gPiBjb21wcmVzcy9kZWNvbXByZXNzDQo+
ID4gPiA+ICsgKiAgICAgICAgICAgICAgICAgb3BlcmF0aW9ucy4NCj4gPiA+ID4gICAqIEBpbml0
OiAgSW5pdGlhbGl6ZSB0aGUgY3J5cHRvZ3JhcGhpYyB0cmFuc2Zvcm1hdGlvbiBvYmplY3QuDQo+
ID4gPiA+ICAgKiAgICAgICAgIFRoaXMgZnVuY3Rpb24gaXMgdXNlZCB0byBpbml0aWFsaXplIHRo
ZSBjcnlwdG9ncmFwaGljDQo+ID4gPiA+ICAgKiAgICAgICAgIHRyYW5zZm9ybWF0aW9uIG9iamVj
dC4gVGhpcyBmdW5jdGlvbiBpcyBjYWxsZWQgb25seSBvbmNlIGF0DQo+ID4gPiA+IEBAIC00Niw2
ICs0OCw3IEBADQo+ID4gPiA+ICBzdHJ1Y3QgYWNvbXBfYWxnIHsNCj4gPiA+ID4gICAgIGludCAo
KmNvbXByZXNzKShzdHJ1Y3QgYWNvbXBfcmVxICpyZXEpOw0KPiA+ID4gPiAgICAgaW50ICgqZGVj
b21wcmVzcykoc3RydWN0IGFjb21wX3JlcSAqcmVxKTsNCj4gPiA+ID4gKyAgIHVuc2lnbmVkIGlu
dCAoKmdldF9iYXRjaF9zaXplKSh2b2lkKTsNCj4gPiA+DQo+ID4gPiBJIGNhbid0IGltYWdpbmUg
YSBzaXR1YXRpb24gd2hlcmUgdGhpcyBuZWVkcyB0byBiZSBkeW5hbWljLg0KPiA+ID4gUGxlYXNl
IGp1c3QgbWFrZSBpdCBhIHN0YXRpYyB2YWx1ZSByYXRoZXIgdGhhbiBhIGNhbGxiYWNrIGZ1bmN0
aW9uLg0KPiA+DQo+ID4gSGkgSGVyYmVydCwNCj4gPg0KPiA+IEkgYW0gbm90IHN1cmUgSSB1bmRl
cnN0YW5kLi4gS2VybmVsIHVzZXJzIHN1Y2ggYXMgenN3YXAvenJhbSBuZWVkIHRvIHF1ZXJ5DQo+
ID4gdGhlIGFsZ29yaXRobSB0byBnZXQgdGhlIG1heGltdW0gc3VwcG9ydGVkIGJhdGNoLXNpemUg
c28gdGhleSBjYW4gYWxsb2NhdGUNCj4gPiByZXNvdXJjZXMgZm9yIGRzdCBidWZmZXJzLiBUaGUg
Z2V0X2JhdGNoX3NpemUoKSBjYWxsYmFjayBhbmQgYXNzb2NpYXRlZA0KPiA+IGNyeXB0b19hY29t
cF9iYXRjaF9zaXplKCkgd3JhcHBlciBoZWxwIGFjY29tcGxpc2ggdGhpcy4NCj4gDQo+IEkgdGhp
bmsgaGUgbWVhbnQgc3RvcmVkIGl0IGFzIGEgc3RhdGljIHVuc2lnbmVkIGludCBmaWVsZCwgcmF0
aGVyIHRoYW4NCj4gYSBmdW5jdGlvbiBwb2ludGVyIChpLmUgZHluYW1pYykgbGlrZSB0aGlzLg0K
DQpJIHNlZS4gR290IGl0ISBTdXJlLCBJIHdpbGwgbWFrZSB0aGlzIGNoYW5nZSBpbiB2MTIuIFRo
YW5rcyBOaGF0IQ0KDQpCZXN0IHJlZ2FyZHMsDQpLYW5jaGFuYQ0KDQo+IA0KPiBEb2VzIGJhdGNo
IHNpemUgZXZlciBjaGFuZ2UgYXQgcnVudGltZT8NCg==

