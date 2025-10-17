Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 362A8CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 05:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80AEE8E002C; Fri, 17 Oct 2025 01:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E23E8E0002; Fri, 17 Oct 2025 01:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D12D8E002C; Fri, 17 Oct 2025 01:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0458E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:49:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D865916052B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:49:54 +0000 (UTC)
X-FDA: 84006529908.04.BCE9272
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9E33840013
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:49:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Amt6KqEr;
	spf=pass (imf01.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760680191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rN8odT+VLd0TFp7zFvFMJ97DqmHvRcnLl6eBb17O29U=;
	b=h4Q8Mmg/ZEQ1muFAKepCsW5sMQQvmTgNlaFRPFIKHFHw+3Jwvt7Jkumh9Y2C1Vw/Q6mSzT
	5TXKTa2/kTec98HSaimnIfDManiMVfHz5UzDWEkitJZg9nWgu6IuWu7oastJw5zRxDugsG
	qbYIlHA1HXjC9P6rWTC9Vb0LCBXq7Xk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Amt6KqEr;
	spf=pass (imf01.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760680191; a=rsa-sha256;
	cv=pass;
	b=rrLALJvcrOUphOyiPd/LVMyjftCn7vKOTxAs/wnDAePjnwtgdAbaT5RlbzpbdnKwshIXZB
	6IFyFh2mvJS+Akmwawm9hTbGa83+FeB1pUj9QiyLP4/Z2KENHJCz94Gc8Tw9WQyByzY2WP
	JZharioIy82VYLryBmJ44lvwUDoaIqE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760680191; x=1792216191;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rN8odT+VLd0TFp7zFvFMJ97DqmHvRcnLl6eBb17O29U=;
  b=Amt6KqEraVolIxv5x7ZrGNbjgeF2ti0xZn+10lOc8dkVbg3+7Q2y0JNB
   lHOK3ME5P7M/ecNuMM7Xs60ZJPrwHRXdL1h5f3LTJ9sA6TrRN7yLtHMlt
   MGExPMb39/XyP1kqtxyatd9o7IMNPeIvYHxqLEPe8MqUv5SbMAeDa6HW5
   Pk921wY8QKuw9Ehobwb4LFFRM4L0v3XBkreDS0Y/gpMK/kXLwTrFKDJR0
   vcEBNnBdeCYkkg4nOpwvTLStFsaibmxol8j/EJiEtSOAVPxqi2B/JD1fl
   y9TN6heQyv2FYWgjz9j+nbNxHZG3okyvujYFu5mpwKAoMjACQk5YclapB
   A==;
X-CSE-ConnectionGUID: +LjI5FrfTju0xumWwXoGOQ==
X-CSE-MsgGUID: hUayYSxgRsWU/yr2QfLInQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="66531034"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="66531034"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 22:49:50 -0700
X-CSE-ConnectionGUID: aUISr2IXT9Oz+3ZO1qJIFw==
X-CSE-MsgGUID: 3XQOnXfiSzeq2InwAZnt1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="182205478"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 22:49:49 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 22:49:48 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 16 Oct 2025 22:49:48 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.7) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 22:49:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QOtUoCUAKqL8PMPk3+wQk2mz/VvQr/E2yh17DJsaz3mp0qWhaYzYT7k9JunUjF5HadgRo5fC6jG1V+MyNCSztaYYNCmPKGn+WTXA0y0MgD0q1F1zedFtuj0p+7O2YLT7Kupvv1fy9LBqr7c/UFAjiNlVlzSAKpQgDOG3UQu8iPWVm5dNx4RWLY/ovpW8pQ6VWa6SIVFzqAkGt9nJQJnfyvH2UZXq8LzTGo5V3hRMKwLQscFbXf6xm52nncS74T1q1tpFPkc75AlYO0nN/8o01F9WStI13rQOsExtTbqpgcTH5tleN6ovrL/hiJQzNKEV4HvPpoaZqlnQ7IwT03JtRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rN8odT+VLd0TFp7zFvFMJ97DqmHvRcnLl6eBb17O29U=;
 b=WQ1p4LYcJsu+LInv2aLBoiAYftLFeRWFsjYj5Jvf2y+AD+EGmCU8udAJRV8EeWursD2FKiUTmbjXT6fu5eHsyA1Wlxso3xVMm/uo/4FVwBK/0gHoBbdrTCGBsFGJ29pUFv2urK0rHnkxLLINeBmZwnwMB/UMQT3A3OGhMmsxTCwPGmRPqvXSiSKL1jlJI6trAtRY9NDxJU9+zcd69MwpdYQMe9XM6Qd42cLHvm4MeL48gheY+HfsjcNjzu7xEcajhvziXXgR5wiso0kRy5t5TtqiJGz3fQ8hVYMOg3A3HoQQ2MVOrG5NmWqlRf9JRWwnXNf6BaR8OTQYeITkLBp06A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by CY8PR11MB7195.namprd11.prod.outlook.com (2603:10b6:930:93::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Fri, 17 Oct
 2025 05:49:46 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 05:49:46 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev"
	<yosry.ahmed@linux.dev>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "sj@kernel.org"
	<sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Thread-Topic: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Thread-Index: AQHcLpaVDpsUwa7oJkegsikxMLWqgbTFqD6AgAAwYoCAABNmgIAACc+Q
Date: Fri, 17 Oct 2025 05:49:45 +0000
Message-ID: <PH7PR11MB812142098AB5B49E1FC8CD6FC9F6A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-15-kanchana.p.sridhar@intel.com>
 <aPGXUxRZeYLO_CUo@gondor.apana.org.au>
 <PH7PR11MB8121C3BAD72D03573D6B4951C9F6A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <rbl5iuovk5xd2ed5ip4n6mkh5ad6d52ygkqlwbehu3rm6awkn6@tswgallufq4u>
In-Reply-To: <rbl5iuovk5xd2ed5ip4n6mkh5ad6d52ygkqlwbehu3rm6awkn6@tswgallufq4u>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|CY8PR11MB7195:EE_
x-ms-office365-filtering-correlation-id: 946a8232-834f-41d0-1983-08de0d40fa2a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700021|7053199007;
x-microsoft-antispam-message-info: =?us-ascii?Q?u8nswsvz8Tf0BGCfCKrCsm2uBFekylEFdr/3VBGL2q/mcpCT10Qo1FxZmHq1?=
 =?us-ascii?Q?IrtueUPvQwM6VQhD8qgZuPUG9YYGEBbcPVdzTzLgpwXktK27yVhBHbHuo97D?=
 =?us-ascii?Q?YG3jaEwWqRL1c4ur3waki5FvARsQxlZYQIEYVUzR25QrzAoaUJRg/Wjn9Jhh?=
 =?us-ascii?Q?HCYpXW86tIasbyYZC5Rsu7fYswTctxgIDJtIe+8jmSSt8//AiLil2TKCQ1Lz?=
 =?us-ascii?Q?0MFP8W6MtZQE/e2liyZzl9L3Qu4j97kuYwMspurM48rhROrRvrX+xuE1PTPK?=
 =?us-ascii?Q?sJojDYJobzvJnCcIuoD0wW+Toj7bO0z1A1HRoNwQcphQ0fPwNIGqyHMUbK8L?=
 =?us-ascii?Q?snLslVARIv7J9FVklKWSJwoPREXUGcGrP/Du7fjFbvTShZegNMsd9DGTPchf?=
 =?us-ascii?Q?OfFqliIaJQ5dMdctojYdB83unhv2TzDfnPKaFneP3rlOCUu5KgRO3tO3b5iB?=
 =?us-ascii?Q?T8kMPOjk7PrqJLRUyoIHiVXu+Z/zWkwF5vdaklXIZGghGJaGkSSaKhdu9nMt?=
 =?us-ascii?Q?M2F3LyLYgwLSrs7YvFL/biVqpJqr4nyrluqe0olvLCGQQt+YaL498GVjprXs?=
 =?us-ascii?Q?51E4VvYonPFWhKbMaEN6oBHrLgJo42Fb4bQBpLbprNAHkOIL0tJdMDVhrKPW?=
 =?us-ascii?Q?FiEwcrWxFEre0rnPeY1bcng3Zf9W9XilQVtYibBMyQ6RwTdDIegZ9+Ebr4ML?=
 =?us-ascii?Q?lXZb2XGq8EszYxyPt3rj2HnONqhPpA39Ww2maPjpEtIC2ACciDkoeaT6MMwK?=
 =?us-ascii?Q?TiyIFTfg9oJfr2Pfa5PjKy4Oa0zeyQ64qGPETzwZy//ranFLqRbHuQoHhBki?=
 =?us-ascii?Q?J18AcMrFC+OSLu8A5QAX8uxdTrJPWzgEoy5wB9ra7B8gmz6h5a1LoGjLTGUM?=
 =?us-ascii?Q?PQlk+cMtor7+wvNfYWemYNK/fCoP2J9yI65veMgyGdcV16MHrpZKb+s0wEOv?=
 =?us-ascii?Q?ku1+U5A2a97MBWX1PVys+6J98wcsShrxNaRoePFSuvFkDZEYIkm1r3Vwfh5z?=
 =?us-ascii?Q?gnQ0ZoSgUpLOscG9ojteGxq2iO0nFlklpUPMh9hKG6cLzX2uhl4dYOlvVJ0h?=
 =?us-ascii?Q?LnJWi93wUbs0xFS2QBULbZnVHt19mf19+aom7E4H9dqV7wajgnBxR0mcnXTT?=
 =?us-ascii?Q?zff4oM7PKKSLIIUXUJXk8mH/i8l2HQOrWbzZs8ThEqs63Oxpk9BguTpSHeTh?=
 =?us-ascii?Q?KqRPCS7CnTsKijixwDEEYMmViFH7RKDvbsoMo5cuo7nijUwLwk+3tfK3cI2Q?=
 =?us-ascii?Q?rot4UxFUHvEAiAyCHR17Eal64VCGBmviUUBvh02k83b9d80FYTAjifuGn4fK?=
 =?us-ascii?Q?t8484xOdNYLnQsZzfXdiKZ2F/tww1Ct8hMMsPZGc5oaqIx+GKfVk26S7wh+U?=
 =?us-ascii?Q?rguLFXAnZSDzIcW5kuh3vNw2QcFYXA/dX14du2Bgy646ITLoJA9Ic8CZ/rZz?=
 =?us-ascii?Q?44XEuzU56BvH7BZ8p3/hPJoQnLykHOfTBpv9MmHFaLKZ7kSkTAEG0JJbR5gy?=
 =?us-ascii?Q?DizmhIYExksPlhkwcgRBo1JtfXz2Mj+qIpZF?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?y8VirkPHBOQ+7BMN8xIKycwemvHUl++6BIsxGeXJC/tplFTy4eQpxWp63Zxw?=
 =?us-ascii?Q?E5uk7ucMO8Ae0aWsTcQLTUm8nHybyax6w92CtTxBY8tNBhVmR8hBD4KlCIXz?=
 =?us-ascii?Q?LLlyVBbwSj2Smmh8Ns2Lm3dc6w3py32E/UitWBlAivh4X1YOh7S4Z1w/UJhl?=
 =?us-ascii?Q?kIGpKcMJ5pQttTmj9F68vQv5/M4iW9qkQEMWZ1mJf/5xFZqWedWzZ65i7rRr?=
 =?us-ascii?Q?WQa3cyn3M2pzW0vWJknra2sRJo9lKdv3OSpTq30EGdvpo56r0heuAaP0pkAv?=
 =?us-ascii?Q?Ul8Fc3hqFtbqhOQPJ4UDTMbAWdNMZsPsv5kJX/eIwNspgSQRbBkJJG2c9bA6?=
 =?us-ascii?Q?l3gWMzjHUPSsjE0sbINiwVoE+2fkMOUaOBlOwCHs3U6BrJYfZDYFeXI0dob0?=
 =?us-ascii?Q?eBMQG3118HiUUJk6qy3CwGYFbt2/V+pWHzANk3EEsrzNJI/OpKJOW5xkc8xF?=
 =?us-ascii?Q?7XtwL3fH0Wx82xpH2YTWJa1YCXBnuS5y6LpKpnEmvT/Cqcqz8Q+S3LYciCo7?=
 =?us-ascii?Q?Nm0dNSxKo8f1TfO/SYcXCvFlP6xZ5kfMRSFUWV+bVqcqnTBhUl8ByJAxtHPk?=
 =?us-ascii?Q?hwrOFeWY/d1eakHoFb+dmjBPGbQYfYvPH7vYABI0zm/TSqjEx/twsrxiQp9q?=
 =?us-ascii?Q?DiX1ShVcPZ9Ad4XXRH5rkPehlrlJ72yG+PMaXLPro3fITvSjfXIxAKLsinzV?=
 =?us-ascii?Q?GLdif72m83/JwVW/KCDF2WoCG0ykPzizs/hPT0WD4sGgwxsd5/uu+GJc2F/n?=
 =?us-ascii?Q?kbysw+CuQ0Rch7ymUbv6K2oqaudvx5nCmRFfNHPzKuc2Woott6CmNBaQlcan?=
 =?us-ascii?Q?vhGsJxuGJGZqAaMrFeid2nse9d6o95Ea8a+g1IOG3w66cadeXoZUwL/56osF?=
 =?us-ascii?Q?A/CzbUIrHtVyvJiCTdUOXg1XDiwuh78BUmGgO1hYSPWAAu/WOdINPYI0qtiC?=
 =?us-ascii?Q?Kfd0JwBacgvlZvqIxJdpzwHDYsD8X3Z9T7iDZ1S2fbu2r0j85g8/kII/IGzO?=
 =?us-ascii?Q?ZItmqfzis2GAqEPM+ytwkitH4pQt+CFSdoSnfBD9f+uQbllCfH/7zIqg8FPc?=
 =?us-ascii?Q?uT+RmPaLi/VYA1bpeFvTUBga95hPQtk36dbjJ9V9f/CJeSh5sFyL10YHS2L5?=
 =?us-ascii?Q?r4UNZldXTwCOOWt9cgEPT3S4ogfGo8ptW/tJzZaF3e5kuqqJ5zwOJnYIW4mh?=
 =?us-ascii?Q?UdWoZOpe91SrdN0IadiBSrxvxQlbXf5pnERkTpv3dHGFlK5kaZXSrIs2UGNm?=
 =?us-ascii?Q?a+32nzrXzDc0wL5eTBT4+6kQOxKhCUqiTa9fmHwUGYGQxWRvqN1oGXLbHjrf?=
 =?us-ascii?Q?09gWnEYZ6J9/azwV/+JOyMwWhS8BTMAbTxWLVNUrdVZPUr2lucIIeYXaggXM?=
 =?us-ascii?Q?VPSYruFY3qf5+4LyuTvwLhc4hX7XEzv09WxfIbcVcy4/t+2WWQpwCtkDjfAp?=
 =?us-ascii?Q?wc2zC0I7geA+Lfw6q1R8lFnchOlu9fdKmr4dQxB6X2Xxpd8Vy8kum+qayTG7?=
 =?us-ascii?Q?zyAxO2MWzUTQZ/X5DFHk0TSgs1138XD3HazDNxaxqVHaVJm2UcyXb6dbJmXN?=
 =?us-ascii?Q?+BGXh92uuVkVkdDSh/oEX9zOUdpf+ZzxPUfJBtKIqUBE2q7R+mH7A+thU/Pi?=
 =?us-ascii?Q?Xg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 946a8232-834f-41d0-1983-08de0d40fa2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 05:49:45.9251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xqij2LfKswWEoplI39N4B849bocgSIucC45PX6bE2kk5SBz538hpTEdsV9mTAD4N9ivCdn6NBxtFgXKgBnjvsbxCo2LXEUVPfXlorZ+RRb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7195
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 9E33840013
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: r4adnp9sm3okwqstkcfzfdwuz7fsqori
X-HE-Tag: 1760680190-686207
X-HE-Meta: U2FsdGVkX18akcpVR6P88nOptCtPdFC2TPjCWdnwpK4V27figR8/aO46uNZha47aW1QHJqZt3/4fgI7rPVCydbr2qJRsW4sreHLfEsKpqNUDFila3GHrxN71ilAvQBAUgHJHgHIYsiE8YSE92/PUu0xEnBh5+uDqF/cGUPUWxwIeOn0vL+iGoD41B4T/1IHew7zannIj/3cZOFBvemFtKEIcc3RmSfvLt5emb8nA5fEQ2yb/ZQncZPIcG6hQR9tQrwFcufmKIQpWMNdKZoEQC6AeDxT/CXBiY5tynsHgIzhrEBobPvf3E4Y1zggeHcIVRW8awKEMVwRckUo3uFxaNgvKrJ22Xp2iyAmf7ki5lc/r90+fMfxOtKTPA7Hu0MDFSVdvh1hc5SIENIwOceQXgKX/2luH89LesLcaNhaMIjcFq0QJ48gWVW12nnVF/JWj3w3G3Zl3RW1Sxianynhc9NDePyijhY+G9Mgvt/BNH7UzJ4VXkb59uIerNoqickEm9l7gOWeARHcppZ30QDY4AQ+7rj3J7Fh9Cjqc2CADzRQvR+gG+hPUVHAFMtQ7g83k+p2DvKsOi8RNAC+4wibE5Ghv04HihW7hv9LCloPNY4Z+K4yKbG/7NvNwen96SS/XSUaugNl6G7X6UfdHHQ+SQMBg8R1LqZ86GZorue2BgsEZRCLBatzRtvLAxe7VhizWLT3u8qDiOkPf3xafVdfh9zVp71fdOJux6OB/Yaws4yQwFMKD/BB8VO7TGS4u9U9Ej1UbQu/DB/M79wv69Fn7wx8Q9T1AwAlzXXRrNyBaBRAjP4Ko3CXuLQCigKgi3Le9wE/8btMQxNuLF5lnv9fo8ADvqjwGOlPUokBhBwmVga3j85r1lFrbgCSa+JzcqwEseCGswgOnv8eSdVS6nz7pibn1ec1kYo5ysyIyZSscb6gg8jNGlQCQ93xVwDNscjNANiFdI1GT6UNqA92qsMe
 jQbufXsi
 6nkqlh/3h8jh9c141NfdHxOec2HS/vrOW5J4+S7R4eRYKS7RetYXnyPT7XmnwVt0+Iy/fNhcdmpqQ+pl3h4asO9sZPprgSk3UW1eMBXOVLtgzCFsa//THynBSn5i0mYqP0H00smsBfAIM3nOKVHjFTqvHyaJjCUNm7pSStjnOzVGdSe+bp9rLrwb1eGAosOMneNQ/E/veKBtmDQ6f4wGxNMbUlcrw7oB5lgfAR217JEXijA4mRsyM+5MU8LHZm1lcG4Wy3GvI0mkyCHlnMBakaO/xF8qqRtPz35U8hGDIdi8xgaMIuMI5VVeP8fRBkPOyhi6mLui09ZJmpnl88gsl4kgQIGqwFZBIevu8el0S56J0xtRZ3xSWCGyQj6kfhf5iLu70oVXPpcJAI0Y95uJqErYgSUKeHrcmSA95wQ5fGgp4X56cDIWCoF4dPoF5EroQJbOrv9dibyAMhsOp/WQBSaYebIaIpAPK6yaZOEWoI15OOBQbOoCbpQH/cNYQ0SWaxOxvtmLCrtudogiBltcplhdbJxvmLzhym8sBAxZ0brgnjXtxyUE5C5ro2V38MH4JnUKUgEClJ71IB5fym9vQO6aUzLX3j1z+C5BRK7KtGRwGjPQM4yoou3bnShMB561tjK22uj0bxfVYM8YinE8M2SGs3u24+USFfS+bxzXp5hdb+uw/40L1GzdkpIeUuF+TEPGk2Nph3LKfeTOpsp39plHSCK9ir5NSbi3quGB4Of/DpS7a+NHmWHnSZ5JtW8dP9c7BYosNl1ySY+oKIyrqlB5Ivwg+i+IxsrjCIt8y89rJKwEa3xZeW3chzzsH+FKWfKf7b8mgPmc/dquWNLtOB+VoIlqehNdwkWfSZ9D2mZNw0E8Q7xYXVripKneVWVcLKeS2VPt1W5rSOXnRq0SP3dzEupm1t2MAu0cgeN7KeZp9KyDBEHGrumRKT4wZB2SicBzVCib11m0difjCfNU+RIv0Fm03
 WkfAApTv
 y5MZVTxCyD3IpL8r9JhRxwa/kELQ5d7R7F2CvtYoyKrwdVagmE4lhg30ToZIiWQoo/NmGa4ibYS5T3itHsq3EQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> Sent: Thursday, October 16, 2025 10:12 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>; linux-
> kernel@vger.kernel.org; linux-mm@kvack.org; hannes@cmpxchg.org;
> yosry.ahmed@linux.dev; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel
> compressions/decompressions.
>=20
> On (25/10/17 04:04), Sridhar, Kanchana P wrote:
> > > What are these for?
> >
> > Hi Herbert,
> >
> > These are for non-crypto users such as zram.
>=20
> I agree with Herbert, I'd keep zram out of this discussion for now.

Sounds good, I will drop the IAA API intended for zram when I post v13
of this patch series.
Thanks Herbert and Sergey.

Best regards,
Kanchana


