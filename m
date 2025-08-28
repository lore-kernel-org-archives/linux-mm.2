Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F98BCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 22:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DDBF6B0023; Thu, 28 Aug 2025 18:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7096B0028; Thu, 28 Aug 2025 18:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D256B0029; Thu, 28 Aug 2025 18:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E820F6B0023
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 18:47:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CD761A042D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:47:35 +0000 (UTC)
X-FDA: 83827654470.20.A56C8A2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf13.hostedemail.com (Postfix) with ESMTP id 746CF20007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:47:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U9oxyjZc;
	spf=pass (imf13.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756421252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pyOVRI57tdxreBCMeT/ii4thILCr8LqTv6qm6NJ1BM=;
	b=3cGlubIq2vg6NZsNgsnNl9cU2CDB2vVWE7OWZS/XZZ+v2NHqTiSh0zEyZfMijtb9yg3Oex
	qEYmI6X3Y939yAJhYcGV3Hqh/iQn1cCDo3dKVmW6DT/gZugbIUVBKsH70QgilKUGOHc6p5
	fHPxnGck4GYHl576puE1fa0VRrSCw5w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756421252; a=rsa-sha256;
	cv=pass;
	b=hhJ8Atjgz03uuq1eyvZ5qPTkKK6DToxcWa3Bmq+2xiiN6U8zVBL/9/TpGm2uAQq2tToe+x
	RpUNFLFHAOBdYlR1iQKjZbiwG+VyMPwL0B2KG+1u/8OwkXpI1QNBMKX1A/dzv6EgnGClLZ
	0fd8W5vdYABS1ECLCjnTYwdPUQQIAQ8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U9oxyjZc;
	spf=pass (imf13.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756421252; x=1787957252;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3pyOVRI57tdxreBCMeT/ii4thILCr8LqTv6qm6NJ1BM=;
  b=U9oxyjZcutHanih9HnzQ/hu7bjyHtSI8KNjtjEUJYKgM2w127mSpyDQY
   ihxRShIVhbbdoOzpwjY7yM+RmXaikxp3+okT8Nen3KhJGRClZ5gGlq0Jn
   EJRc/4SUkUFf+NFvtKuJeKpbfT4/pZVUCZCajHTbbtpuYbm4r4uNvV6IR
   591CB25pOCoS63b59KRoLx5IxUfrS5arF3CONFQZl7ADVTvexie0hLZle
   nWn9ptwHACvJ7CQdrHtQvf814WwcfPmUlYkBo5+tqsAXGS8aJHR3N+gxB
   dX0j9E/pnm0rqv9HgTvzSM6f9B5QisOXQRbTNaHOM8wP0eyokC5g0WGj2
   g==;
X-CSE-ConnectionGUID: +tolHhp5S46EUlS/EKv9tQ==
X-CSE-MsgGUID: tN/43W5HSc+2NYQje+sweA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="58636886"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="58636886"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 15:47:30 -0700
X-CSE-ConnectionGUID: iLqte6hOSWqHuSf5ry0tMA==
X-CSE-MsgGUID: VFImCzn/QEaaAlwtTJHXQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174582625"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 15:47:29 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 15:47:28 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 15:47:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.41) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 15:47:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZ/7R4SFKdDcckwGw0tcOQ+IIccAIDQqwOtWJmcTHDeWpO1j3GuAIwbPK+iUEQwA/PC40vTZUET3gHJZpNFi1LqmqhZJQv/E8M0ZbdKvMbex1AoL/K01odvlFey4EP5amRoxKyA3rqSy4e9gOyiinook7MiwS2XsuGzQFL8pfvjURs546DfLXRDu9hPRNLS68zRQ2nfy8eEf2csPCEPVW3SxiCGTZdKvRzgHAueDK7ByiCM+AaiP8tHXw1JSkYpNeqNQ0S3j5B4jE+lxIdkY5oppxSVWXdwaeMLaEoPwBng4YpC1xqHDqer2S7XbDdkTq+NegPQfHcQWy5R+cXY/yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3pyOVRI57tdxreBCMeT/ii4thILCr8LqTv6qm6NJ1BM=;
 b=FukH7QUnL2+y6PMZDbv7qWrLhaWMXJK8dxQC3Nc34UyV/yzNN3bQCDffpGbkcooNQtt8wc82h6XaLkywlQMpPdKcnR0ZnchhRB1ECQ4rDrcSkrEQkeuDH+bGhlC/MJbh2gvutRFDf0KjFVQ4LYJcYIlj7vZ0Bl/07Vvu5UUB9mJzEJOLgDf5rY39XBSb0Htc9+T00leSXf092DHkxf8dpBKYaUa/Z4sNQyXYiWS5s3OOjWaK6GPjotZ77MOwleAztmASKDbxWg4MMQnJfshgH8p+lRqUMXywM18IeMYu+VrdbL4+Kbjf0FTlORKVQQ7xaZGIp6CHrNN2+RHxqkoJwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by DS7PR11MB6245.namprd11.prod.outlook.com (2603:10b6:8:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 22:47:21 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9073.017; Thu, 28 Aug 2025
 22:47:21 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Barry Song <21cnbao@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Topic: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Index: AQHcAp3rCQGkKHFe602Ahq9v7LnzVLR0czwAgAAISGCAAAbQgIAAAQVggAAI1wCAATLsYIADBCAAgAAKX0A=
Date: Thu, 28 Aug 2025 22:47:21 +0000
Message-ID: <PH7PR11MB81211DD54822167C6BA238D5C93BA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
 <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
 <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com>
 <PH7PR11MB8121C1B5965584AA8E59C0B7C938A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zjPxSjrSomm3E3gOuW+AqiTKwUHJ34q9m9aJb3y3vEKw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zjPxSjrSomm3E3gOuW+AqiTKwUHJ34q9m9aJb3y3vEKw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|DS7PR11MB6245:EE_
x-ms-office365-filtering-correlation-id: 91a09f3a-c86f-442d-702e-08dde684d95b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UmJsN216bWZoRTY3NmNwWUhCb3E5ai8vQlVDRWpyb2NvVDNpMkc4VXYvem9G?=
 =?utf-8?B?TGtyRlltMXhNQjB0NmhvdWtqc0VhcVdFQ1lYVmlOMGF6Z1QvL29uQVAzeWJ3?=
 =?utf-8?B?TXNuTnVvYjcwMVIzWkRqMjU5eEJKdExDZ09kUkRSL0YvdGVibXprTm5jMllh?=
 =?utf-8?B?QkRHVVVrSTBDazdZTU04M3B3aStuQ1JyZzZLYkIrNi9SVzJhOTF1R0FISHpE?=
 =?utf-8?B?UGhMbXFwaWg4cldMS0VGRlRVZldBQXB1bTBOVytURlB3QTZ6VUhpR2NJZkFz?=
 =?utf-8?B?bkZNZVpvbkhxOGlXdGwwVGFBL3pONDQ5NGRPU01OaDkydzhIV3BBRVQwb01P?=
 =?utf-8?B?VVp0VHJDcmFnRml5YWhUbXc2RDJnM1NVQjZXU1ZNSmpQeTFYZWk5dGFBQ0lq?=
 =?utf-8?B?aCt5dHF1b0p6M3NraHZXZ2pJZVBRQ0srRFBXd25UWEJpN0dzK2djVXQxTmhW?=
 =?utf-8?B?ZTFPSlBvZGN0dUFMaUpIT2ZMZUhmdHA3TUtXRUIrSUtBYWo4VWZYUUVTQ3Mx?=
 =?utf-8?B?YzFWS2xlY2FtOXBaQmZzUWNnKzV2bmkwUWhLVTIrTTFDNXNHUmlRaHNvNXVS?=
 =?utf-8?B?VWJHemFxUjRuMXh2NXBlK29UajVGTE15WkhaZmZFVDc0eUVFZ3ZTR29Xczdk?=
 =?utf-8?B?akRnV09OZGdHTE5qMlhmVG5BN1pMQmxJMWVGZHF3eW8vTFpoKzJIam5lSVlm?=
 =?utf-8?B?MEtaVTArQWFwVEhUa0c4Sk1qdzByb05OVG1KZjJZRHhGdTdSTXBhSEkzZmdE?=
 =?utf-8?B?eVBoUytLTUY1SWJIRTB0cFhLWTlhOUkyK0pSb3ZJSEZDZEZyMC9XZ0JrMmg2?=
 =?utf-8?B?Z0xER21uRlplWVJuNXBMSTRQUnY4SVk1MUcra0QvSkY4WCtpL05CSDhONFFT?=
 =?utf-8?B?Rlo5YXVCbjBzcm5tNFNMQmZvWTJETmFXRUZvK3NOQlhGNGJHL0VIVUxKQStk?=
 =?utf-8?B?ellZaE44NWI4RDl5ZVFDTzBKYTJmeEppOWk2TmpOSXRJUkVOcWxTOExKUFls?=
 =?utf-8?B?Y2RtdlRjTG1DalpaTHp2YUVBNStIdEJyTkhQZjJoSjhBRCtPSE0xUzduQWRS?=
 =?utf-8?B?eFFVS0NIWjV0OXFUdGpjTjNuUnNncjhqNUFTOTVheTRWeGNXRTA2SjZGQ09W?=
 =?utf-8?B?T0M4QnNycHRSR2lBMjIwamdnRW1sODJWV25IUkI1SUpqSUtOUmtqd1JDVGNB?=
 =?utf-8?B?eEhGZjNZbFI3OHR3dDNFbGE5aER2QmlsODZGVG5XSy9BcmdHdEZPVmlaKzNi?=
 =?utf-8?B?MzFIRlczYWl2RXhrVWpQQzJLQlBPUEZIdnhVUzMvb0h6ZjJKM3g0R0VXSGN0?=
 =?utf-8?B?OUhIVS9ncTdIUjVLRldzSzREaDQwQ0szS3BlclBvNDNSQkJTU1hzZy91WmJL?=
 =?utf-8?B?VGJvNWNNTU1KT3FYWEF5ZmZaTy9UYm1aWmV1MTV3SHI5S251cmt2VXNVMUtn?=
 =?utf-8?B?K1Vyb1NJejM4RG5jSmhZeVh6dEViNnlDQldQekRMZTZjemQ0UFd6aWxFRUZM?=
 =?utf-8?B?eHpZVm1ob2xJZjFLeHF6d3phRjF6UkVWb3hobEtNbkVXMmliaGpGM2JBdUQ0?=
 =?utf-8?B?YlN6eXdpKzFNb056a1pJV2xhbDRCdXltWXlHUk1EN2U3U2Fyam9QN3pJR3o0?=
 =?utf-8?B?ZitPcnQ5aFJiV1gwMEF2elV0NjFTck1rcmM5SjhIYUI0QW0rdU1GbTZtM3Jl?=
 =?utf-8?B?bCthTW5RWGptdjFYR2tibWRhL2JPeEM2MERrYUlOdFY4VEd2QUR5cUI4aTFD?=
 =?utf-8?B?ZXp3TEpiL0gxV2tUU1JtNVdJVmUwalR6OEFuS0pIRW9mbDBlRVUvU1RaQVlr?=
 =?utf-8?B?TUlKNno0VCtrcWNwcThKRk9UNFNFVUt0OUtUYTNocXBjbHhTeVpaVytaTFNB?=
 =?utf-8?B?SUxuZGZQV1U2NlhZRFZGY05nZXlPUklvQkx1b0pDUTdEYjQ0RmN6Q280Sk9C?=
 =?utf-8?B?SjI0MnFIMDBYMjRvbVRYZnUvMm55aDg2WFArNkUzRkh3ZTBPWHN5V1o0N2Qz?=
 =?utf-8?B?clhxTmZ6QnR3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXRTY2hoV0wwVDdqNEJJTmluSTdpUjBHVVdJTllmZDdjR2JTN09haWpJOG5V?=
 =?utf-8?B?VCtwL3VsY3BVQVErZVAzV2ovVXlEdCtqcWg1cnFXcVQ3dU5OWDBrY3RSRlZv?=
 =?utf-8?B?aG5rejhERVA3eFlvbVQ3ZnkwVjNEOVVYVU9CamZHWDlONCt5N0Z3YlNkb2xT?=
 =?utf-8?B?ZzV3UUdJQldGOUppY0srYXZua04wVFNkTHZWQ2YxWmJUcm5xcXR3a1pSYm05?=
 =?utf-8?B?L0pFejlkb0dJMjNsVSt6SUs3WVRiQmtva05kV2hzZEtURERjY3Z6bkIxVWFY?=
 =?utf-8?B?YkdWMkZ0c3F1NFV2VmNUMVJGVVl5bmFseTVwZ2E5SFpqcERocmpIa1NHVXFF?=
 =?utf-8?B?am1md3NRKy9pSkdSWVlnYkVwVEpsMVVtR2hwTUR2b0F5ZVAvMkRaemxETFFi?=
 =?utf-8?B?dlEreElIc0JyREJXREpCcFJDWUY3YXJRSUJQb0VqM0w5MUdRY1R0T211aE9s?=
 =?utf-8?B?T1d2elhJZXZPSXA1bWcwcVRERUsySFRxN3NxS2YrcEZ3Uk1Ua1draDhDTXV3?=
 =?utf-8?B?TUFtSmxoQyt4aFdqVGdhSFp4dmlqc2ljSVg3KzJZY2lUR1A0c1N2eHZabVBV?=
 =?utf-8?B?QW1mc2djRW9hMTF3MFZvbW9WSjR3VTltTEdoWVdpa2xGMFovNW1oejBUZVBh?=
 =?utf-8?B?eHdDMnZjaGNtQ2VxazVjcFRTZW5kRDRDc0xQSGYzRVI1Rld5eWpFcUY0YkVq?=
 =?utf-8?B?TW5VZW0zZ20yNnBmL3M5OWpJbG5SRy9ueE5vbTFHdDFDeVdoK0YwQ0d0T2Y2?=
 =?utf-8?B?K2t5cFZrZFp0YjI1aW9iWnhWMjc5SCt2dVovcW9XRWtSZjYzSU1RZTJiQXpz?=
 =?utf-8?B?WjhXUWRCR1Axeldjb0xTakprYmVFeElVTndMTk1YY3ZLMGgvZWkwQi91T0pr?=
 =?utf-8?B?UnBkdkJ4aGJyZ21VaU5HSUoydHNFNnY0WEgxNjVuVkIrM2xIYXU2Z1c3K0E4?=
 =?utf-8?B?eWtxczB4OTRQcTZ2YlljOWtZaE10Mk44WFBnaFRDQ0RreEtSMytVK2dYUUNj?=
 =?utf-8?B?eWxUVEYxc2htSGk4bW9QSlJWS2h4ZDRTOHJoWFM4aHltcGRncDJuUmVDV0NK?=
 =?utf-8?B?SldHU3REWWNMZWpEczRDaUNBUGJPMGVsdFpjQnNFcEdQWUtSZGJMaTBYRHhC?=
 =?utf-8?B?OWt4L0gwUzJLRGZMcUNSOU5iYTVQZzViYTFHSXZUaXByNTJzTWgzdzNHSjJK?=
 =?utf-8?B?bGdLdFZYWFdpbXprbnFnWm5ibWVzeU1QTU0wYU1CalVaWXo2OGpzeFVtMGR3?=
 =?utf-8?B?K2ZLcFY0NVFrd3YxOWFZeENHVlFYOFdGcVpvdTh6Nm9tVGdzRWxleG13VS96?=
 =?utf-8?B?QU9zWU9MdUZGanpZRWNvTldkRnJiQ2dtblRyZTNsNkFPREhCY0xqR24yOE1W?=
 =?utf-8?B?emNvTkpvcHVTY3hFeU5NNGR5VlB5RUJEK0dVNFpmWUE3TXkydUxicCt1SUdJ?=
 =?utf-8?B?K2Y2cVpHanZVQUJadXozb1FJc2dHdVRiaG9vL1NpekhFWU4xRnJHOThRRHBt?=
 =?utf-8?B?TlFiVGV3VUY3bkU1RkMwTi9uNlZCaFhyRnAwRGx1QWJlYVpWejMyemdObnQz?=
 =?utf-8?B?NFZnMnQwUFNwa0YxT0lyVm9QWGhHaE9OY2NIQ00xVmoxWDFta0lyVE9IakdU?=
 =?utf-8?B?ZzZXOGx0V3BXcHd6dTNxRDhUZ3JEN2J1Tkd6T3U2T2lMUmV2NnFFZnNuRnp6?=
 =?utf-8?B?dUpqcTJlcE9ieWFsNWxwcU9BUGZQSjRGOUxIQnUvQlJ6TFlpMlVUQlZicVBz?=
 =?utf-8?B?T0p4dit0MDJSYUFIUHhkQ3FBS1B4VU1CWmNyWkpXWVR5d0pzci9OQktrUVlM?=
 =?utf-8?B?YW0xWlhTSTdLRzVWR0JhYWFLR24ydmRFWk9BRWY2bGRwT0V4SlFDcXJtM09y?=
 =?utf-8?B?Nmc0cG15Z096djNQUEFFd2xFSU9SU3VFQ3BzLy9jaXNQenZnb1I2a2JzUUMv?=
 =?utf-8?B?RVl5NU5qVUNRbFJHQWFmbVNHa1dJejZTcU95U2JQam82TG9XbjEyUHphb1lu?=
 =?utf-8?B?ZzBKV3dzMGJRY1phL05TK1d0Y1lCMzc2cWxyREVvY2dpellkK0IyVG1mZWFa?=
 =?utf-8?B?aWZ3dFNBcWtBS2ErMGQ5ci91eHM3YkxjZW90SXRNRDIrV3RtUUNsOUtGY1FD?=
 =?utf-8?B?c3NJZURFNlByemk4OG5pK2EvN2dHUk9HVmp6c2xaVHU0RWJyYjBJRC81YVhW?=
 =?utf-8?B?WVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a09f3a-c86f-442d-702e-08dde684d95b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 22:47:21.2886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +rdl6xGkl8xM7+UusKVNmdS3JAzyxY9R222f18Q9mujTQeb/8rYaLoNCH4Vnz1ph86mwR3xS6wiptiJ2rtyg04uiY2KFpZNhju+Ek3paSJI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6245
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 746CF20007
X-Stat-Signature: 5m3ksqim6fawsr1qjkpzrwosfnesoij8
X-HE-Tag: 1756421251-61450
X-HE-Meta: U2FsdGVkX1+OJDZjUEwmlW2aIuZ+Rm4hMGEcsOjudt9/2qxIMl/9a0Xf0THfWnNUSpmzcn+MHwj7xkDtwyAkNi+T3S/yzRZkRW8PL5SE80T5pfJabHX5z7WDnq/BpdzJDtAEax56mUbpJ/euvOwqYUIkVddhNfeDmJiTVIarqZ0X6EsqJBsP5hlu1YYw1G1iJMJ/nMgx0Wc7J9p0IiaBdag4pAsj61ko5umIp6VGCvHzJGCDWOpKaprIegZ6pEXN8MwthLR3apbWhdapOJeYkvsYzwh0a5zQj5oWEHdH0uLZ99XOHUH3Rdoa2PoXyEFey4VFZIaDeaXoqv1ai8qyoaYITPN3Ff+idiQErtfhLlOPdwHoy3N7QUBitj3uWKc4uYSCq6nP334UNBWbUt2H+N2Fo8eXEDgMQc6jAsddfp/XUaQs9m5B7JzH4YYwzX0xCVHw5hj9JyCzPh/gKliPRYE4GUtMweEfzIAne4C94DxDtYynjlrGphVcHFsY8beUDxxDeUhioU8AC79QC8Qjhfd+h7WQHzgVCQzbfFQzQDv+aRO47f0F5B2oiO97XOB92h9pAxxbmoiUVxuw41frcfbBWSjOF3GkboG+h8DJVHRRX7GoF3vEMDfL0w2xM945D+X7PI+a3iwRdXkmLJop2RswHcWBYOogB8nIa9JKROneWH/As+9pcgOzyhl82qoOUBD90b4FoBuaPPD1HQrU1Szcamqg9/2ewGVV/ONUt9E+F274tR0L3PciFM5wk2uPL92Rn8BIKcpAbO03VNmVCIZHJ7+V1W7ySbP03KDSJeWEgm2q9iAjkw29ZcKeNCdsDIRVOxUU4J+kMbf7MEfbI5WLkXJR+pOqUOUt0M8BP2BAEpKBGftM9YfWk2hs7Zm5BOzHh3D3AaprQMWZhbcPH683iIqddZVnaX70vg2Ws0+xEzaB2Wyqdakq++0x80T6hXZNG10lSSZOXdHx6hf
 pEFrekbG
 ugDta1MCLMkMHi1mr+kytyts1DO/O95lh5yaRkq9ZPQuijYpQLqZm5nrGV7GIL3+ESZfkUjmnPM6mGjRV/TZ+j0dGIf//ORPVsc9tgpa9TIQJMKWqiwd9cOGltm3gGAkMaJlLP2VIYUcncfLtPiKyfnQRe9JIftr/ejMS3U8TsZiRH7yWp69DL605KvKHJOpGLIRKz5XTncjUyoLZAZ94zu6XuaIeU+VWPwp/HNTYbtymjhK3mRRQuTfISu2llAtOe/Nf2ExL1g4upsiCZ6CIcsNw8ZSDD6JJrWDdw4kT1pMH5DcwVySwltDBU6FxqL11W1sdNHpz/J4iItsOKcrJpe2b9qXGlrTRNkrX8DrJyIwp6azEnwjQqTOarbB/V0MU2ujU5dgRPuw4T1ZfrVVW48RnL43FhsYYYvJ33gLiNogKddkUTbmPwxunEP8iYsa6pYUX54ofMKrCzgQnRwJvz0EzKmmfXBuAUL8hulRy7I97iFDU7kNqQAZqy8iio3+hH+EQqYQKm4T4eO9OKERfJGILEHEF8awZop5jfGO6Afe8OIax0BVa48SCEQdRxGFnE9vphe2N1PI4JacnP+M1bzhIM/7NbHIKiKBFhdVYkOh5/D1n20Gaei68YDQHbiG9xXqFffpJjVPLUnh+ehF/sVn2ORJiy2uONvYKz7lxaYynoF0RGcUYPoEL+WTXwa6CUpSa3GZPjpWhriVSSTO9BrUScDqB3y6jeIeBoQlItfzx8GUuWRZsUsAjmx1c4rDuJMRWZ0B0pSHa+GDeTnN+LDzQfN+EAagaGaK5GP9Of451E62MYtV65tJV6ljN9q6eoHouq8STrZGSPVdZi90lP2P7ni1vz/8D26hfZZPvMoITySagvRtfzC2lc3DsKtXpl31isuloxEDqSIIvLJLHRmInytzWuDS1XXI6GMTmPNLqDZ2wP4gdc76C3rLqHRmQdHII35C/M2VFqFDvPnHAdwBvsYEp
 NUXptAnY
 87vI/lmh5fgDmyIeMA4xjvAaM0wn5U+mnsLosm/dS17tRcXBjpLnypOoR3UmqXiUDxpEN5fl4+CZfYAiUIbb+UeRYjuKcTTTYi0ReFCb4PwuXSZT7R9oG3MpKfjH0eTWHbnRdhj3w2pc5nqPeLqurwBY8OqzFLKvK5aAW6jj0OQ0u7O/lbI42DUMBdV8Kcxh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJhcnJ5IFNvbmcgPDIxY25i
YW9AZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDI4LCAyMDI1IDI6NDAgUE0N
Cj4gVG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+
DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7
DQo+IGhhbm5lc0BjbXB4Y2hnLm9yZzsgeW9zcnkuYWhtZWRAbGludXguZGV2OyBucGhhbWNzQGdt
YWlsLmNvbTsNCj4gY2hlbmdtaW5nLnpob3VAbGludXguZGV2OyB1c2FtYWFyaWY2NDJAZ21haWwu
Y29tOw0KPiByeWFuLnJvYmVydHNAYXJtLmNvbTsgeWluZy5odWFuZ0BsaW51eC5hbGliYWJhLmNv
bTsgYWtwbUBsaW51eC0NCj4gZm91bmRhdGlvbi5vcmc7IHNlbm96aGF0c2t5QGNocm9taXVtLm9y
ZzsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsNCj4gaGVyYmVydEBnb25kb3IuYXBhbmEu
b3JnLmF1OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRi
QGtlcm5lbC5vcmc7IGViaWdnZXJzQGdvb2dsZS5jb207DQo+IHN1cmVuYkBnb29nbGUuY29tOyBB
Y2NhcmRpLCBLcmlzdGVuIEMgPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47DQo+IEdvbWVz
LCBWaW5pY2l1cyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsgRmVnaGFsaSwgV2FqZGkgSw0K
PiA8d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT47IEdvcGFsLCBWaW5vZGggPHZpbm9kaC5nb3Bh
bEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjExIDIyLzI0XSBtbTogenN3YXA6
IEFsbG9jYXRlIHBvb2wgYmF0Y2hpbmcgcmVzb3VyY2VzDQo+IGlmIHRoZSBjb21wcmVzc29yIHN1
cHBvcnRzIGJhdGNoaW5nLg0KPiANCj4gT24gV2VkLCBBdWcgMjcsIDIwMjUgYXQgMTI6MDbigK9Q
TSBTcmlkaGFyLCBLYW5jaGFuYSBQDQo+IDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPiB3
cm90ZToNCj4gPg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4g
RnJvbTogQmFycnkgU29uZyA8MjFjbmJhb0BnbWFpbC5jb20+DQo+ID4gPiBTZW50OiBNb25kYXks
IEF1Z3VzdCAyNSwgMjAyNSAxMDoxNyBQTQ0KPiA+ID4gVG86IFNyaWRoYXIsIEthbmNoYW5hIFAg
PGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+DQo+ID4gPiBDYzogbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOw0KPiA+ID4gaGFubmVzQGNtcHhjaGcu
b3JnOyB5b3NyeS5haG1lZEBsaW51eC5kZXY7IG5waGFtY3NAZ21haWwuY29tOw0KPiA+ID4gY2hl
bmdtaW5nLnpob3VAbGludXguZGV2OyB1c2FtYWFyaWY2NDJAZ21haWwuY29tOw0KPiA+ID4gcnlh
bi5yb2JlcnRzQGFybS5jb207IHlpbmcuaHVhbmdAbGludXguYWxpYmFiYS5jb207IGFrcG1AbGlu
dXgtDQo+ID4gPiBmb3VuZGF0aW9uLm9yZzsgc2Vub3poYXRza3lAY2hyb21pdW0ub3JnOyBsaW51
eC0NCj4gY3J5cHRvQHZnZXIua2VybmVsLm9yZzsNCj4gPiA+IGhlcmJlcnRAZ29uZG9yLmFwYW5h
Lm9yZy5hdTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gPiA+IGNsYWJiZUBiYXlsaWJyZS5jb207
IGFyZGJAa2VybmVsLm9yZzsgZWJpZ2dlcnNAZ29vZ2xlLmNvbTsNCj4gPiA+IHN1cmVuYkBnb29n
bGUuY29tOyBBY2NhcmRpLCBLcmlzdGVuIEMgPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47
DQo+ID4gPiBHb21lcywgVmluaWNpdXMgPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT47IEZlZ2hh
bGksIFdhamRpIEsNCj4gPiA+IDx3YWpkaS5rLmZlZ2hhbGlAaW50ZWwuY29tPjsgR29wYWwsIFZp
bm9kaCA8dmlub2RoLmdvcGFsQGludGVsLmNvbT4NCj4gPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
djExIDIyLzI0XSBtbTogenN3YXA6IEFsbG9jYXRlIHBvb2wgYmF0Y2hpbmcNCj4gcmVzb3VyY2Vz
DQo+ID4gPiBpZiB0aGUgY29tcHJlc3NvciBzdXBwb3J0cyBiYXRjaGluZy4NCj4gPiA+DQo+ID4g
PiA+ID4gPiA+IFsuLi5dDQo+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPiArICAgICAg
IC8qDQo+ID4gPiA+ID4gPiA+ID4gKyAgICAgICAgKiBTZXQgdGhlIHVuaXQgb2YgY29tcHJlc3Mg
YmF0Y2hpbmcgZm9yIGxhcmdlIGZvbGlvcywgZm9yIHF1aWNrDQo+ID4gPiA+ID4gPiA+ID4gKyAg
ICAgICAgKiByZXRyaWV2YWwgaW4gdGhlIHpzd2FwX2NvbXByZXNzKCkgZmFzdCBwYXRoOg0KPiA+
ID4gPiA+ID4gPiA+ICsgICAgICAgICogSWYgdGhlIGNvbXByZXNzb3IgaXMgc2VxdWVudGlhbCAo
QHBvb2wtDQo+ID5jb21wcl9iYXRjaF9zaXplIGlzDQo+ID4gPiAxKSwNCj4gPiA+ID4gPiA+ID4g
PiArICAgICAgICAqIGxhcmdlIGZvbGlvcyB3aWxsIGJlIGNvbXByZXNzZWQgaW4gYmF0Y2hlcyBv
Zg0KPiA+ID4gPiA+ID4gPiBaU1dBUF9NQVhfQkFUQ0hfU0laRQ0KPiA+ID4gPiA+ID4gPiA+ICsg
ICAgICAgICogcGFnZXMsIHdoZXJlIGVhY2ggcGFnZSBpbiB0aGUgYmF0Y2ggaXMgY29tcHJlc3Nl
ZA0KPiA+ID4gc2VxdWVudGlhbGx5Lg0KPiA+ID4gPiA+ID4gPiA+ICsgICAgICAgICogV2Ugc2Vl
IGJldHRlciBwZXJmb3JtYW5jZSBieSBwcm9jZXNzaW5nIHRoZSBmb2xpbyBpbg0KPiBiYXRjaGVz
DQo+ID4gPiBvZg0KPiA+ID4gPiA+ID4gPiA+ICsgICAgICAgICogWlNXQVBfTUFYX0JBVENIX1NJ
WkUsIGR1ZSB0byBjYWNoZSBsb2NhbGl0eSBvZg0KPiB3b3JraW5nDQo+ID4gPiBzZXQNCj4gPiA+
ID4gPiA+ID4gPiArICAgICAgICAqIHN0cnVjdHVyZXMuDQo+ID4gPiA+ID4gPiA+ID4gKyAgICAg
ICAgKi8NCj4gPiA+ID4gPiA+ID4gPiArICAgICAgIHBvb2wtPmJhdGNoX3NpemUgPSAocG9vbC0+
Y29tcHJfYmF0Y2hfc2l6ZSA+IDEpID8NCj4gPiA+ID4gPiA+ID4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHBvb2wtPmNvbXByX2JhdGNoX3NpemUgOg0KPiA+ID4gWlNXQVBfTUFY
X0JBVENIX1NJWkU7DQo+ID4gPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gPiA+ICAgICAgICAg
enN3YXBfcG9vbF9kZWJ1ZygiY3JlYXRlZCIsIHBvb2wpOw0KPiA+ID4gPiA+ID4gPiA+DQo+ID4g
PiA+ID4gPiA+ID4gICAgICAgICByZXR1cm4gcG9vbDsNCj4gPiA+ID4gPiA+ID4gPg0KPiA+ID4g
PiA+ID4gPg0KPiA+ID4gPiA+ID4gPiBJdOKAmXMgaGFyZCB0byBmb2xsb3cg4oCUIHlvdSBhZGQg
YmF0Y2hfc2l6ZSBhbmQgY29tcHJfYmF0Y2hfc2l6ZSBpbg0KPiB0aGlzDQo+ID4gPiA+ID4gPiA+
IHBhdGNoLCBidXQgb25seSB1c2UgdGhlbSBpbiBhbm90aGVyLiBDb3VsZCB3ZSBtZXJnZSB0aGUg
cmVsYXRlZA0KPiA+ID4gY2hhbmdlcw0KPiA+ID4gPiA+ID4gPiBpbnRvIG9uZSBwYXRjaCBpbnN0
ZWFkIG9mIHNwbGl0dGluZyB0aGVtIGludG8gc2V2ZXJhbCB0aGF0IGRvbuKAmXQgd29yaw0KPiA+
ID4gPiA+ID4gPiBpbmRlcGVuZGVudGx5Pw0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEhpIEJh
cnJ5LA0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFRoYW5rcyBmb3IgcmV2aWV3aW5nIHRoZSBj
b2RlIGFuZCBmb3IgeW91ciBjb21tZW50cyEgU3VyZSwgSSBjYW4NCj4gbWVyZ2UNCj4gPiA+ID4g
PiA+IHRoaXMgcGF0Y2ggd2l0aCB0aGUgbmV4dCBvbmUuIEkgd2FzIHRyeWluZyB0byBrZWVwIHRo
ZSBjaGFuZ2VzDQo+ID4gPiBtb2R1bGFyaXplZA0KPiA+ID4gPiA+ID4gdG8gYSkgenN3YXBfY3B1
X2NvbXBfcHJlcGFyZSgpLCBiKSB6c3dhcF9zdG9yZSgpIGFuZCBjKQ0KPiA+ID4gPiA+IHpzd2Fw
X2NvbXByZXNzKCkNCj4gPiA+ID4gPiA+IHNvIHRoZSBjaGFuZ2VzIGFyZSBicm9rZW4gaW50byBz
bWFsbGVyIHBhcnRzLCBidXQgSSBjYW4gc2VlIGhvdyB0aGlzDQo+IGNhbg0KPiA+ID4gPiA+ID4g
bWFrZSB0aGUgY2hhbmdlcyBhcHBlYXIgZGlzam9pbnRlZC4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+
ID4gPiBPbmUgdGhpbmcgdGhvdWdoOiB0aGUgY29tbWl0IGxvZ3MgZm9yIGVhY2ggb2YgdGhlIHBh
dGNoZXMgd2lsbA0KPiA+ID4gPiA+ID4gYWxzbyBwcm9iYWJseSBuZWVkIHRvIGJlIG1lcmdlZCwg
c2luY2UgSSBoYXZlIHRyaWVkIHRvIGV4cGxhaW4gdGhlDQo+ID4gPiA+ID4gPiBjaGFuZ2VzIGlu
IGRldGFpbC4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEl04oCZcyBmaW5lIHRvIG1lcmdlIHRoZSBj
aGFuZ2Vsb2cgYW5kIHByZXNlbnQgdGhlIHN0b3J5IGFzIGEgd2hvbGUuIERvDQo+IHdlDQo+ID4g
PiA+DQo+ID4gPiA+IFN1cmUuDQo+ID4gPiA+DQo+ID4gPiA+ID4gcmVhbGx5IG5lZWQgYm90aCBw
b29sLT5iYXRjaF9zaXplIGFuZCBwb29sLT5jb21wcl9iYXRjaF9zaXplPyBJDQo+IGFzc3VtZQ0K
PiA+ID4gPiA+IHBvb2wtPmJhdGNoX3NpemUgPSBwb29sLT5jb21wcl9iYXRjaF9zaXplIGlmIEhX
IHN1cHBvcnRzIGJhdGNoOw0KPiA+ID4gb3RoZXJ3aXNlDQo+ID4gPiA+ID4gcG9vbC0+Y29tcHJf
YmF0Y2hfc2l6ZSA9IDEuDQo+ID4gPiA+DQo+ID4gPiA+IEFjdHVhbGx5IG5vdCBleGFjdGx5LiBX
ZSBoYXZlIGZvdW5kIHZhbHVlIGluIGNvbXByZXNzaW5nIGluIGJhdGNoZXMgb2YNCj4gPiA+ID4g
WlNXQVBfTUFYX0JBVENIX1NJWkUgZXZlbiBmb3Igc29mdHdhcmUgY29tcHJlc3NvcnMuIExhdGVu
Y3kNCj4gYmVuZWZpdHMNCj4gPiA+ID4gZnJvbSBjYWNoZSBsb2NhbGl0eSBvZiB3b3JraW5nLXNl
dCBkYXRhLiBIZW5jZSB0aGUgYXBwcm9hY2ggdGhhdCB3ZQ0KPiBoYXZlDQo+ID4gPiA+IHNldHRs
ZWQgb24gaXMgcG9vbC0+YmF0Y2hfc2l6ZSA9IFpTV0FQX01BWF9CQVRDSF9TSVpFIGlmDQo+ID4g
PiA+IHRoZSBjb21wcmVzc29yIGRvZXMgbm90IHN1cHBvcnQgYmF0Y2hpbmcgKGkuZS4sIGlmIHBv
b2wtDQo+ID5jb21wcl9iYXRjaF9zaXplIGlzDQo+ID4gPiAxKS4NCj4gPiA+ID4gSWYgaXQgZG9l
cywgdGhlbiBwb29sLT5iYXRjaF9zaXplID0gcG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZS4NCj4gPiA+
DQo+ID4gPiBJIHVuZGVyc3RhbmQgdGhhdCBldmVuIHdpdGhvdXQgYSBoYXJkd2FyZSBiYXRjaCwg
eW91IGNhbiBzdGlsbA0KPiA+ID4gaGF2ZSBzb21lIHNvZnR3YXJlIGJhdGNoaW5nIHRoYXQgZXhj
bHVkZXMgY29tcHJlc3Npb24uDQo+ID4gPg0KPiA+ID4gSG93ZXZlciwgYmFzZWQgb24gdGhlIGNv
ZGUgYmVsb3csIGl0IGxvb2tzIGxpa2UNCj4gPiA+IHBvb2wtPmNvbXByX2JhdGNoX3NpemUgaXMg
YWxtb3N0IGFsd2F5cyBlaXRoZXIgZXF1YWwgdG8NCj4gPiA+IHBvb2wtPmJhdGNoX3NpemUgb3Ig
MToNCj4gPiA+DQo+ID4gPiArICAgICAgIHBvb2wtPmNvbXByX2JhdGNoX3NpemUgPSBtaW4oWlNX
QVBfTUFYX0JBVENIX1NJWkUsDQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgY3J5cHRvX2Fjb21wX2JhdGNoX3NpemUoYWNvbXBfY3R4LT5hY29tcCkpOw0KPiA+DQo+
ID4gSSB3b3VsZCBsaWtlIHRvIGV4cGxhaW4gc29tZSBvZiB0aGUgY29uc2lkZXJhdGlvbnMgaW4g
Y29taW5nIHVwIHdpdGggdGhpcw0KPiA+IGFwcHJvYWNoOg0KPiA+DQo+ID4gMSkgVGhlIGNvbXBy
ZXNzaW9uIGFsZ29yaXRobSBnZXRzIHRvIGRlY2lkZSBhbiBvcHRpbWFsIGJhdGNoLXNpemUuDQo+
ID4gICAgIEZvciBhIGhhcmR3YXJlIGFjY2VsZXJhdG9yIHN1Y2ggYXMgSUFBLCB0aGlzIHZhbHVl
IGNvdWxkIGJlIGRpZmZlcmVudA0KPiA+ICAgICB0aGFuIFpTV0FQX01BWF9CQVRDSF9TSVpFLg0K
PiA+DQo+ID4gMikgWlNXQVBfTUFYX0JBVENIX1NJWkUgYWN0cyBhcyBhIGxpbWl0aW5nIGZhY3Rv
ciB0byB0aGUgIyBvZiBhY29tcF9jdHgNCj4gPiAgICAgcGVyLUNQVSByZXNvdXJjZXMgdGhhdCB3
aWxsIGJlIGFsbG9jYXRlZCBpbiB6c3dhcF9jcHVfY29tcF9wcmVwYXJlKCk7DQo+ID4gICAgIGFz
IHBlciBZb3NyeSdzIHN1Z2dlc3Rpb24uIFRoaXMgaGVscHMgbGltaXQgdGhlIG1lbW9yeSBvdmVy
aGVhZCBmb3INCj4gPiAgICAgYmF0Y2hpbmcgYWxnb3JpdGhtcy4NCj4gPg0KPiA+IDMpIElmIGEg
YmF0Y2hpbmcgYWxnb3JpdGhtIHdvcmtzIHdpdGggYSBiYXRjaCBzaXplICJYIiAsIHdoZXJlDQo+
ID4gICAgICAxIDwgWCA8IFpTV0FQX01BWF9CQVRDSF9TSVpFLCB0d28gdGhpbmdzIG5lZWQgdG8g
aGFwcGVuOg0KPiA+ICAgICAgYSkgV2Ugd2FudCB0byBvbmx5IGFsbG9jYXRlICJYIiBwZXItQ1BV
IHJlc291cmNlcy4NCj4gPiAgICAgIGIpIFdlIHdhbnQgdG8gcHJvY2VzcyB0aGUgZm9saW8gaW4g
YmF0Y2hlcyBvZiAiWCIsIG5vdA0KPiBaU1dBUF9NQVhfQkFUQ0hfU0laRQ0KPiA+ICAgICAgICAg
ICB0byBhdmFpbCBvZiB0aGUgYmVuZWZpdHMgb2YgaGFyZHdhcmUgcGFyYWxsZWxpc20uIFRoaXMg
aXMgdGhlDQo+IGNvbXByZXNzaW9uDQo+ID4gICAgICAgICAgIHN0ZXAgc2l6ZSB5b3UgYWxzbyBt
ZW50aW9uLg0KPiA+ICAgICAgICAgICBJbiBwYXJ0aWN1bGFyLCB3ZSBjYW5ub3QgdHJlYXQgYmF0
Y2hfc2l6ZSBhcyBaU1dBUF9NQVhfQkFUQ0hfU0laRSwNCj4gPiAgICAgICAgICAgYW5kIHNlbmQg
YSBiYXRjaCBvZiBaU1dBUF9NQVhfQkFUQ0hfU0laRSBwYWdlcyB0bw0KPiB6c3dhcF9jb21wcmVz
cygpDQo+ID4gICAgICAgICAgIGluIHRoaXMgY2FzZS4gRm9yIGUuZy4sIHdoYXQgaWYgdGhlIGNv
bXByZXNzIHN0ZXAtc2l6ZSBpcyA2LCBidXQgdGhlIG5ldw0KPiA+ICAgICAgICAgICB6c3dhcF9z
dG9yZV9wYWdlcygpIGludHJvZHVjZWQgaW4gcGF0Y2ggMjMgc2VuZHMgOCBwYWdlcyB0bw0KPiA+
ICAgICAgICAgICB6c3dhcF9jb21wcmVzcygpIGJlY2F1c2UgWlNXQVBfTUFYX0JBVENIX1NJWkUg
aXMgc2V0IHRvIDg/DQo+ID4gICAgICAgICAgIFRoZSBjb2RlIGluIHpzd2FwX2NvbXByZXNzKCkg
Y291bGQgZ2V0IHF1aXRlIG1lc3N5LCB3aGljaCB3aWxsDQo+IGltcGFjdA0KPiA+ICAgICAgICAg
ICBsYXRlbmN5Lg0KPiANCj4gSWYgWlNXQVBfTUFYX0JBVENIX1NJWkUgaXMgc2V0IHRvIDggYW5k
IHRoZXJlIGlzIG5vIGhhcmR3YXJlIGJhdGNoaW5nLA0KPiBjb21wcmVzc2lvbiBpcyBkb25lIHdp
dGggYSBzdGVwIHNpemUgb2YgMS4gSWYgdGhlIGhhcmR3YXJlIHN0ZXAgc2l6ZSBpcyA0LA0KPiBj
b21wcmVzc2lvbiBvY2N1cnMgaW4gdHdvIHN0ZXBzLiBJZiB0aGUgaGFyZHdhcmUgc3RlcCBzaXpl
IGlzIDYsIHRoZSBmaXJzdA0KPiBjb21wcmVzc2lvbiB1c2VzIGEgc3RlcCBzaXplIG9mIDYsIGFu
ZCB0aGUgc2Vjb25kIHVzZXMgYSBzdGVwIHNpemUgb2YgMi4NCj4gRG8geW91IHRoaW5rIHRoaXMg
d2lsbCB3b3JrPw0KDQpIaSBCYXJyeSwNCg0KVGhpcyB3b3VsZCBiZSBub24tb3B0aW1hbCBmcm9t
IGNvZGUgc2ltcGxpY2l0eSBhbmQgbGF0ZW5jeSBwZXJzcGVjdGl2ZXMuDQpPbmUgb2YgdGhlIGJl
bmVmaXRzIG9mIHVzaW5nIHRoZSBoYXJkd2FyZSBhY2NlbGVyYXRvcidzICJiYXRjaCBwYXJhbGxl
bGlzbSINCmlzIGNvc3QgYW1vcnRpemF0aW9uIGFjcm9zcyB0aGUgYmF0Y2guIFdlIG1pZ2h0IGxv
c2UgdGhpcyBiZW5lZml0IGlmIHdlIG1ha2UNCm11bHRpcGxlIGNhbGxzIHRvIHpzd2FwX2NvbXBy
ZXNzKCkgdG8gYXNrIHRoZSBoYXJkd2FyZSBhY2NlbGVyYXRvciB0bw0KYmF0Y2ggY29tcHJlc3Mg
aW4gc21hbGxlciBiYXRjaGVzLiBDb21wcmVzc2lvbiB0aHJvdWdocHV0IHdvdWxkIGFsc28NCmJl
IHN1Yi1vcHRpbWFsLg0KDQpJbiBteSBwYXRjaC1zZXJpZXMsIHRoZSBydWxlIGlzIHNpbXBsZTog
aWYgYW4gYWxnb3JpdGhtIGhhcyBzcGVjaWZpZWQgYQ0KYmF0Y2gtc2l6ZSwgY2FydmUgb3V0IHRo
ZSBmb2xpbyBieSB0aGF0ICJiYXRjaC1zaXplIiAjIG9mIHBhZ2VzIHRvIGJlDQpjb21wcmVzc2Vk
IGFzIGEgYmF0Y2ggaW4genN3YXBfY29tcHJlc3MoKS4gVGhpcyBjdXN0b20gYmF0Y2gtc2l6ZQ0K
aXMgY2FwcGVkIGF0IFpTV0FQX01BWF9CQVRDSF9TSVpFLg0KDQpJZiBhbiBhbGdvcml0aG0gaGFz
IG5vdCBzcGVjaWZpZWQgYSBiYXRjaC1zaXplLCB0aGUgZGVmYXVsdCBiYXRjaC1zaXplDQppcyAx
LiBJbiB0aGlzIGNhc2UsIGNhcnZlIG91dCB0aGUgZm9saW8gYnkgWlNXQVBfTUFYX0JBVENIX1NJ
WkUNCiMgb2YgcGFnZXMgdG8gYmUgY29tcHJlc3NlZCBhcyBhIGJhdGNoIGluIHpzd2FwX2NvbXBy
ZXNzKCkuDQoNCj4gDQo+IEkgZG9u4oCZdCBxdWl0ZSB1bmRlcnN0YW5kIHdoeSB5b3Ugd2FudCB0
byBzYXZlDQo+IFpTV0FQX01BWF9CQVRDSF9TSVpFIC0gWCByZXNvdXJjZXMsIHNpbmNlIGV2ZW4g
d2l0aG91dCBoYXJkd2FyZQ0KPiBiYXRjaGluZw0KPiB5b3UgYXJlIHN0aWxsIGFsbG9jYXRpbmcg
YWxsIFpTV0FQX01BWF9CQVRDSF9TSVpFIHJlc291cmNlcy4gVGhpcyBpcyB0aGUNCj4gY2FzZSBm
b3IgYWxsIHBsYXRmb3JtcyBleGNlcHQgeW91cnMuDQoNCk5vdCBzdXJlIEkgdW5kZXJzdGFuZC4u
IEp1c3QgdG8gY2xhcmlmeSwgdGhpcyBpcyBub3QgZG9uZSB0byBzYXZlIG9uIHJlc291cmNlcywN
CnJhdGhlciBmb3IgdGhlIHJlYXNvbnMgc3RhdGVkIGFib3ZlLg0KDQpXZSBhcmUgYWxyZWFkeSBz
YXZpbmcgb24gcmVzb3VyY2VzIGJ5IG9ubHkgYWxsb2NhdGluZyBvbmx5DQoicG9vbC0+Y29tcHJf
YmF0Y2hfc2l6ZSIgbnVtYmVyIG9mIHJlc291cmNlcw0KKCpub3QqIFpTV0FQX01BWF9CQVRDSF9T
SVpFIHJlc291cmNlcyk6DQoNCglwb29sLT5jb21wcl9iYXRjaF9zaXplID0gbWluKFpTV0FQX01B
WF9CQVRDSF9TSVpFLA0KCQkJCSAgICAgY3J5cHRvX2Fjb21wX2JhdGNoX3NpemUoYWNvbXBfY3R4
LT5hY29tcCkpOw0KDQpGb3Igbm9uLUludGVsIHBsYXRmb3JtcywgdGhpcyBtZWFucyBvbmx5IDEg
ZHN0IGJ1ZmZlciBpcyBhbGxvY2F0ZWQsIGFzDQpleHBsYWluZWQgaW4gdGhlIGNvbW1pdCBsb2cg
Zm9yIHRoaXMgcGF0Y2guDQoNCiIgQSAidTggY29tcHJfYmF0Y2hfc2l6ZSIgbWVtYmVyIGlzIGFk
ZGVkIHRvICJzdHJ1Y3QgenN3YXBfcG9vbCIsIGFzIHBlcg0KWW9zcnkncyBzdWdnZXN0aW9uLiBw
b29sLT5jb21wcl9iYXRjaF9zaXplIGlzIHNldCBhcyB0aGUgbWluaW11bSBvZiB0aGUNCmNvbXBy
ZXNzb3IncyBtYXggYmF0Y2gtc2l6ZSBhbmQgWlNXQVBfTUFYX0JBVENIX1NJWkUuIEFjY29yZGlu
Z2x5LCBpdA0KcHJvY2VlZHMgdG8gYWxsb2NhdGUgdGhlIG5lY2Vzc2FyeSBjb21wcmVzc2lvbiBk
c3QgYnVmZmVycyBpbiB0aGUNCnBlci1DUFUgYWNvbXBfY3R4LiINCg0KVGhhbmtzLA0KS2FuY2hh
bmENCg0KPiANCj4gVGhhbmtzDQo+IEJhcnJ5DQo=

