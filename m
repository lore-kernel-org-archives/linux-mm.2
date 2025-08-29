Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5807BCA0FF2
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 03:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986666B002E; Thu, 28 Aug 2025 23:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957A56B002F; Thu, 28 Aug 2025 23:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81F598E0001; Thu, 28 Aug 2025 23:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FACF6B002E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:12:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23A5B119201
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:12:32 +0000 (UTC)
X-FDA: 83828322144.22.B2809A1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9EC9F1C0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:12:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MLttOId8;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756437148; a=rsa-sha256;
	cv=pass;
	b=vzKqu1O0N6t8OfFV6/KY49Vf10xF1W4GEp8JGJaABvfrBjCaKw5zAX8UJ6bCVcPjJETKVq
	vgvFG+NSdUBZAqRkmryZ5vcQjejfE9XwGu0eEfYX1usiMiFJDzWWW+332/Uzc2vQPHzyJ6
	FWUPMcy8eB2Yjm8/xl+U2/eC4oyk4FA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MLttOId8;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756437148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdYCzNMExLSjf38p5ER7aya/doGRlWPHdljJr+Widl8=;
	b=gfmUfzXfU/8VU0HZ6gYEJFDeBlYLUxWmauKlUiuseh2zCrOcd7AR6DXFckfXWl+JF23eGF
	mOt4RxwuBveZCBCSkpg/ie1kEA8b9QTUHjXUr1gK548S9/qRl4Wc30tk+mf2GmWz7giBog
	a3MlSB+63X2GvCOJF2j52rGO/sS8Bds=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756437148; x=1787973148;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YdYCzNMExLSjf38p5ER7aya/doGRlWPHdljJr+Widl8=;
  b=MLttOId8CQd0kvJ77kwYHvGL2CVjl2kJNlXVZMvKmJ76Ne7b1Jzre54F
   WwLHZg5u/P7Dh/sC75dTByavW4C6VvcnP6o0oVRvLtB6DzVmoXYYu8w9I
   VE7rH9+ut/eb5dlrilfqWDg78zf5UlxtH2X1+zTC3F+zH+AZuztRR0Qvj
   KZjHP+G09nqGG9JTfZ+EbnrXcw4dSNbT6sz9CnHcGx8QBYQm9UelvSC6D
   mfZuIYxF5K5s2trzShTTH2pWB5EvQiITI2ZljA7yDCc7QHdhE2Lh5erbE
   iPz13m09pG7p03Opgz2pmhhSuiUSlBDWJNFJGY5qbF6l9GklZDR6ClPkb
   w==;
X-CSE-ConnectionGUID: kmgc9prvQn6Hbda8ecWN+w==
X-CSE-MsgGUID: GOfuspH5QWW2GPnCVNyvVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="46292185"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="46292185"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 20:12:26 -0700
X-CSE-ConnectionGUID: SvzI65q6QIWGmT6snNEzdw==
X-CSE-MsgGUID: /aK/ClRnSxKXYcHwwA/J/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170174702"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 20:12:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 20:12:24 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 20:12:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.83)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 20:12:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RljvRlBJE9zZUniqZH0kt/AX5SK+ZGgj9EajdyDwK47e7HalTjkftd3yxtx9yGfyWRyRkRH87kO3nI++LaK9ypNZBD67ncHG7Wx10OpKeOHHeimwGvhaz1euWArHnu+oZA0E6OvG6grDbAFy2deagrzDgYo55lQ2zKQ+yQxA3k2T0MOSJ3QVQCE9HTQAT/zXyfqanDhfKPgqPrFdRhkDhFVETmPfeEPw/H+0xANDONh1/HaT++wePl/sJGPpHXYhzHjxWE4pT3oSDKaLrARq55T6IfQtsueBbb4Q9RUuh9Mt7byInJylkWD+HrVjYObLTJh67m155kl+m0xp4NpQug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YdYCzNMExLSjf38p5ER7aya/doGRlWPHdljJr+Widl8=;
 b=ClNBO2BuohgfjYrRTYCIsGUgJfiPqrvM4cJOXfMgYu/P79fDJscuVIgm2fNbbykG1I3cUm5MXB2uAFFfdeiGWd1fShCnQMMVDdOoV/HOWFrjwort6935XCwgrBrAuiFo9RJg1zy3K3AjllcsZQdMU8lpooqkOYvS3tARTO1zbbqkPZJL0I74hY3Lwua43pIHvQExS+jdGg+VM7JfeLPFT9Y3rjzsWquVvoo5VX3WST9/OCf+jiZKiYnGIdALaPGhCzI0PQpz8AxIG/yUBy7Q/+tmIEkGX3SwTL1oRHHTXGjnHw7PSsOu/exUe1Dq1KOk2ojjpd06v9O0aFCXXG8v1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SN7PR11MB6946.namprd11.prod.outlook.com (2603:10b6:806:2a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Fri, 29 Aug
 2025 03:12:18 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9073.017; Fri, 29 Aug 2025
 03:12:11 +0000
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
Subject: RE: [PATCH v11 19/24] crypto: iaa - IAA acomp_algs register the
 get_batch_size() interface.
Thread-Topic: [PATCH v11 19/24] crypto: iaa - IAA acomp_algs register the
 get_batch_size() interface.
Thread-Index: AQHcAp3pOTTEpERXoEuBr6AbKNHOibR47zOAgAAwDDA=
Date: Fri, 29 Aug 2025 03:12:10 +0000
Message-ID: <PH7PR11MB81219B313D6C18AE26AB06A7C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-20-kanchana.p.sridhar@intel.com>
 <CAGsJ_4xuMEDzX0z-oEyPQyb+jhnytfrfyASKxwR+5XRzxayJPQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4xuMEDzX0z-oEyPQyb+jhnytfrfyASKxwR+5XRzxayJPQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SN7PR11MB6946:EE_
x-ms-office365-filtering-correlation-id: 659f4e21-a1e6-4ecb-b964-08dde6a9d862
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?R0NQMk9wd2cvcHJ1VUJRa3MrZXlIZVhUWTYzUnhnQjgxWjlDUzdVT25aREZL?=
 =?utf-8?B?djhEMENDbzZmWWp1ZDVoTFh4eWRnVitaL3RRVDhkTEJCOXhsRGVjbWl1cVpW?=
 =?utf-8?B?Zk9SdmRIMXVMMmYwdi9jc1R3UnlCRUV5UHNseG90WmJhdm9SVFNTeWk1U1g5?=
 =?utf-8?B?cE9FQUZrRDN0dkd2cVJ1K08yMGp6SUVZMmdIYWtCVDZPVSt2ZW1Na3BEc3ls?=
 =?utf-8?B?bjBoU2o3MUFESW9qQnJqK0IrbHJBZmd6M0gwY1lEVTk3OTVuMUV1QUZQR0xr?=
 =?utf-8?B?RTBYVmxUdlJDelNza1FEa3lkVzNoZm1jblduMGJiU01aK252ZWpUVU0zT2Qz?=
 =?utf-8?B?bzh1cDNRb2djWTg1Nk5GalozYlR0MllIc3RRWlJubmhZdDhpV3MxTEFSbUxk?=
 =?utf-8?B?cUpXZEJMdmoxRnFUN2ZOL2w4VjdXb3FiVUVSVzZIbUphSHdxUTRtMDc3Szho?=
 =?utf-8?B?RHpBTHdIUTFEVTNhb2dFMTBldy9pWU5PQVludForM3gzREZ0ZnFUcCs5QUtu?=
 =?utf-8?B?N1Via3ZPellhYTkwN2paNmZ3UkdKdFBRTTdjbE5nOXR4YXRlTytVNTdSZ3ZE?=
 =?utf-8?B?czRqbFFiazVCa0hrK2NsOElCTnJJekdCbHFWcnlONkFQME84c3pWaUJlR2lx?=
 =?utf-8?B?OTNuY3FveFhDNHBqQ3NDWWk3aFFnNnR5MWprRGtsRzdmeDRhYTZnY01PNUU3?=
 =?utf-8?B?OVNsWUpuaEN4dktWQ0RTMGpLQ3dGV2hNaTR6c3QwMWR5WklXbkhEendXYmdi?=
 =?utf-8?B?YUZWd0NxL1Z0SWVPWVYvYmhlWVpIa2pYOWVWcTBsczh4eUtsWm9zellPRkFx?=
 =?utf-8?B?eitDUGp3WWhjbUhiLzVZUWdzZUJiYUhrK0RTSEFzMTJuWjVqeHRKVFFjMVp0?=
 =?utf-8?B?Q2tockJkdWYxTHE5NVJyclZxb0x0d2FSMU5YRHo3dDlseG1wOVVrcjk5NHBt?=
 =?utf-8?B?akJNNXJrL1Fnbm9vanFwbWt3VFZLL2hCcXZOOStTUkZNZU1iY2dPVktuZlhB?=
 =?utf-8?B?KzdmeE5Pbm1iNWJCVDRCTnAvSGxVbzBoRk9VMlJtQ1RMRjVSWkxFbUZaNkxy?=
 =?utf-8?B?UFJJRHJHeFd1R3pmQWJJMUw5WjRkUWZMR2VXdURYN0h0b2dRQ1pEbUtPaXRM?=
 =?utf-8?B?cWRJdzhwSkorNmthZnJYQmh4K2c1UmJqZXVjM3ZVTDBrQUs2UkllcnZydFVu?=
 =?utf-8?B?KzB4dXhCS0RyN3p2Zk9TWVlkc3lTWGd6NVkzaHNVR3F3dnFjaUYyMXI5UmJk?=
 =?utf-8?B?Mnl4b0dReE5RMVhiUWJIZ3ZZVjB4TU9ueGFzbVVjK1Exd2lRd0poaXBpUndN?=
 =?utf-8?B?YWFEU3FaRmh2K1I3dGNsNkUvVC9oamVvekFMeWNCUXIybFo0T2RjR2pURkhU?=
 =?utf-8?B?M2ZQWldRbDF2dnMwRnNpVU9xQ0pkTUF5QjFtL0VUNktwcHRORHVWS2d4dWVK?=
 =?utf-8?B?RDBBcitCcitMUzNSd2M0V2Rhc01kUFdicktPQWRwcEd4Qis1ZEFVNksvVE5H?=
 =?utf-8?B?aENaRTNsRlJHNmMzQjZNYVpmNVVVc0lTUjZ6ZXdPcWRxNlN3Z3VjZlZFd1ZI?=
 =?utf-8?B?bUIvbW1EcnM4VjEvdVNIMlg4a3RyNC9Yc3BaOWt2aDBMR1YwOEQ5bDRGY3Za?=
 =?utf-8?B?Qnp2SVNXbFlYenJXbkdGYjY0dGJqeUFzQ3Y3ZkFad1U1dDRNKzBiSTk0UWcy?=
 =?utf-8?B?OTVJSmk0bFlTNWcvN1NYYk8vNkdxcFFWaVd2UXRxU1JXV3p0VzlMamFHaVhQ?=
 =?utf-8?B?UWQxUkNObUZPKzlMQzVXWnFoZ0VtYWlwTmlHNkhTOXJOc1ZqSDNLMEJJT0xi?=
 =?utf-8?B?NmNNaWk5YkNxR3hOQUhWL0ZCVDA5SDNUV1ZsNVQ1Q29XVHlFb0JxaXlZaUNR?=
 =?utf-8?B?Q3FuOXBYVS95Z1hhd0tYNnJEMXRVd2x3OGtKZkNDU3l4cjVBb1hpT3dURkpt?=
 =?utf-8?B?a1loQlFQSGRvdXU4bWMyT3VzWFpkWFlSaTRQbzlaUm1LYUw4b3ZZTlJ3anNs?=
 =?utf-8?B?N0RtejR6SE93PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDd4RmtiYVhqTU5HSitDeXJEQ01uQ0VvWkVSQnI4U0EzbUFvUUIvZkdCd25K?=
 =?utf-8?B?dmJqdlo4OVFETkpjamp3SXphTkk3Y3hzVjVoSmNxMnRIaFJ5bXRxUmhaQUlG?=
 =?utf-8?B?TVZJT29VMVpkRVNucmJvOEd2SzZtT2x2QnNKaHBiZFZRZHZrZm44WWE0RzFL?=
 =?utf-8?B?NVdscUFsYWxlUXRONEVHcTk3RHVyOSt1b2pmL2o3NnJqcjlrRTc5Q290ZUNx?=
 =?utf-8?B?Vzl1bVJDUGpRS0J6bnd2YzljRVJBWTAxeDBuL3F0blEwcWt2Z081bHBYbTNN?=
 =?utf-8?B?dUpCS281MmZCV0JRRWxhaCsrSnZXRC9hMW5ERmhscGFGd2lnRjJ1VEZSMmxN?=
 =?utf-8?B?TS9IWElSMUU2SGt6aVl2VTNhTlk1eXZYNlg3UHppWlNxbGkybStWVUs4T1ht?=
 =?utf-8?B?V0c3QkFSb1BPVzBxdzI3ZmdjU2FOU2xWOWpDTDJaNk90Kzh5N0dVZVo1NkI3?=
 =?utf-8?B?VzBBamtwd2ladUoxWG5WMmlZZEdZM3dsVy9xVS9XdzI5R2lzeWltWDBvbTNS?=
 =?utf-8?B?elRqdTJMWjlRaG14Um1NSTREVWxyREpiVkJ1QlhoOExHOG9tSGMyb2xVcktB?=
 =?utf-8?B?V3A0TGd6Njl5UVdKME1aWUZlZ0w0VjIzb1lEMm9HUXRiU3JVVzVNYzdnMmNy?=
 =?utf-8?B?bVZkWXZRRHhYT09WVHEwQitsOExNcGV5c09qeCszVSsrL0FPblk3ZlRqcWYw?=
 =?utf-8?B?ZDFuNncwMUphZkVNU3lyeDhXL0pQRVBzdTliV2YwNzZ2QUc2VytPQ05qMEF1?=
 =?utf-8?B?UUJCSmZLMFVOKzgxSjN2ZC84L1ZHQ0J3TFkvY3lIZ016MW5lZjJteWNIRUJw?=
 =?utf-8?B?eVVIUkVLanp1Wkd5SWNha3RuWWJWVjdzTk8rSS92YS9hTnB5N0xnR0hvcHBv?=
 =?utf-8?B?Q3dMakxQZytVdHpUNU1GL2NMclkxMmpqUEp3WTdPSnRPQVlSTGl5eHlveUta?=
 =?utf-8?B?bUJVOC81djFkWmhnaEZKRVFEUUdaU2QzSUxDSjBBTzJ6aSsyL0VjYmdIY0pm?=
 =?utf-8?B?eFNQODU1Y2lnVlg1Y05RcEVYOWdHWHNVZy9YQ1ZkTW1uYVQ2QjJFSHlxc1Rj?=
 =?utf-8?B?RU9PQjVzQzJJbWNuN2NhREpCTDkvVkd4UkRMbngwOUc3SkpUMzNROThBNjVa?=
 =?utf-8?B?M3o2MTZ4aStHdXR6aFhzaFpjTk1MVjlrOFB6c2U3dDlMRmVIRDhGcFR6WU0y?=
 =?utf-8?B?RG5abnVrVmhyQnZnTWpVbDA5MFZMMk1LaXlGeHNRZkV1S3E1Q2taQkhTazJp?=
 =?utf-8?B?ZmZ1WFE4SEZEVVQvQnV2QjlldmMrblJTYS9mV3E5em1GN2twNFR6MUtoU3Zt?=
 =?utf-8?B?RTA5QXczRHU0VGw3QlgvQWxzY1kyQkxxVXBTbzF6T2F5MmNEeFN3cWlWV2NV?=
 =?utf-8?B?cnJCZ1ZYOFFRRy80N0I5bFdXZVRROWYxNFdHWlBtNzJsaFkwTXVYUHdVTmFC?=
 =?utf-8?B?eFc1djN0Qko0TGhEVjhwRDlacnVmNHQybnUxYWNwNEhTRGtyQ0llYWhmZHhK?=
 =?utf-8?B?U0E4NGoxdVd2NUtUL2tDTy9ZUVZQbkVOR2k5WFd6SUpiNTNEVlh3ZDBXeTlY?=
 =?utf-8?B?T04xSEFnWkxUUVdXS2Y4ckc2M0xKcWZzNjJFemdJUlNNQ1hMSTAvQjlrc3Ny?=
 =?utf-8?B?WnB0M21aTEFwU21MMm9NK3Z0Vkk5cFU5emJnSU9NSzIyOFpVTWJBMnlZYk5G?=
 =?utf-8?B?Nm5yblVjcEJEcXE5eHEydmlFRDlzOHNKejY3QWFGZkcwaStnOXlhWmF6cDlT?=
 =?utf-8?B?L0QxNTNZekRGSkgvTmltTmQ3V1lUZE1zdkRGdko1UWZyMW51T215YmVzVmtx?=
 =?utf-8?B?S1ZiSUxSemZBTU1zR09HTXhtaU9OR1NMQmhQbnpaMHFXMVZFSmw1R3lvTHNH?=
 =?utf-8?B?UEdRdUJ4MTFTYjBjRCtvc21NUmpqU2F0VWxDZ2Y3alpnQnVwVXR3b1B3aVlD?=
 =?utf-8?B?V2tMNEVHMEdwVVRaT0tzUnFBalpNTk5qVWg3NG9iQ1VnTlllRmR4dEhGNXhF?=
 =?utf-8?B?Mno5M1p1L3JBQjAxaWdGVmRGaE1TRlBjMjdXQVpwN2JobFlOTTV1V0ZLRUcr?=
 =?utf-8?B?VlQ5QUFBNldpWGozVXVxY2tFa3I1RkVhWFdsdHRtSTBJS2lqM3o2eGFhYVNk?=
 =?utf-8?B?TXYrcEY2ckVSeE1BNGhGQUtlRDd0OGU1S1pVNjNZNEtTZU01Rlo1a3VlZ2cz?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 659f4e21-a1e6-4ecb-b964-08dde6a9d862
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 03:12:11.0107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZBCDyaCtwgzOBViljITPyQpPNvn/lv+feifWkTxAcn+Q9Tgjj+UUnty2YtJG8FoyC0bvTT1WbqoyH7Uxhm25m2z0ugemzzOTi0gEiDdVABE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6946
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EC9F1C0007
X-Stat-Signature: d6kr683cfn8brz58y43sfrtfgif5bad8
X-HE-Tag: 1756437147-733893
X-HE-Meta: U2FsdGVkX19KvF1l9EbQt+lZ8dkIrFiNHZrBB7EMUJv3blcfyrR6n5ViukXHQwwrYHw4+GFxQRt8DO7zAs2FVlQegw2OFXaM3vGW54/UdX6I7NoV/ZJ+LXEapdFmbUIrfCLsIWvyN8p/xVKvQoj28Yo4FhmbyWO/QYRugjKPDQ6rJwEB8s5Gh8kjNqNl/iy8V8BXnqUmUCWlJH6Y6Wd7Or9wSWU5REr9RriZsEgxA4kp7OSJGC6KdwkUKAC8Ngp0iXeYHDAZDAHvZ2p4m9DaewDC717XvRwB9n6ferjHmKD8a8T+N7FINCo85bK/zXNIwuCA10Z1C1gT8i9PFwx0G87S6dtxwcSLWVpAgJyfuhFrYeNbGZ/jcM/LybOJlxlEkkGIgU3xb+rMxc/XAZYXFOBZ7hBLTIZ/eQjOh+/wMsKL+ZWm4rqAIOVrntUXbHa9MpruiqyzAzd3LIqica3onl1IAo/ItgOLyN3MaKFxX4C8hGDMnP8p6+gNCLnS8QWIEOrAnOESUz5ZS09T5dZsX3oSx2HkZvdkCQK7Y7xE4li/d12VsstaugqTnn+Zzo4nBLMF+tE1yDYKlPMPWMVSDbLMfOOvv3QYisp4/NXdz2yOKxlIy+aGGpxqI4wwIPRI/djhONN5/v5Krpr30faAV+Bt0q14tCZIbi5G2obhscpAo2XrxOZrMGtwAN49jDSdTSqfUwQERseV4+Vfg/G8H/SxlbXSylhq3vfbeYQlWvu6KulO9QV/SL4msyHxqlvWOr5xb9qwdjbFREtr4EoRA7e25+HB8WADcErpab9dEcYqqlh1X93mqEfLQrhvsBEGpg7UBEtB+1Fvri8sANhP5Brwa6EhPSCHwgY20RYz2B2Tx69J/wArZuT3K9FljCW2IbLOrAg7ejOWUgb1NDK/HtRQLdV96FsSf18Zrid4O/kRd88f0uHotDeQqtmYQOowMBqxhPxFuHg4V4zB9nQ
 qQjiE7RW
 qotxPCKoi7tRCp2qV8vYhRlkK5qoMS8RlOYHyPGYc+jQu6iHQet502c2i9o617oNOztq/WI79gRrSVkctwmnAi8rfkVyflF7SMSgKLpbAMemA/SPOuQN6YCy+WpHqK+nYsjsWOxSJc5vb29i3FmF+NZlBTkG1g7FqXvFPRwd8JQQwvqaEyX4bC9WNpSpya6q0xrD38jFLS2Q9GcRGtFHefqogOUizoXP0/7u08Jhg+DQHm12a0t53N+tISdvOHNTl7QvfzSGjaYLxgZ9Qwr6HCcFGVWazljkgkW5ZDVc4St3+iLdBsBgVoqD/ktiu/Eth+4TIB4Usg+ptBoWi4LXyjFe1IDDEtQss8OesvffHCLpPk6yiwPhghbY9GkgQKd5ntRmZggVW8iKoauSCbzN4lDoke33mQWPBmkJlsZ5ZB6kmw1SHurjqNuqOlwes5xFM7Dcgjgx+RBAqonTMF0CjqUwOphiVrOQPf+ui2Zp1E0YMrb4xM2uUzADljsHDI7+PtO937u4Kkek5BXzXB1seZbhDJbynaObtAkuO3PTNBVc4gO0tKnS7qX0I6CpFh2Pevjk5E5IjNOzbDc/TXV4BI2rcbhP/kzsibWkBnY6KEv/4lDZ+I5hkJFsFxRO8JRMXFbmg51E+mMo5Zc/G42SjLtnp7gBBrHrLyaQEJarifT2paxaFanoI+7U3DvyJK+CsvEYAGyBd4Ck/FBodXCJlr0O/83H046qFIci8KEiyY8KWxr9wconE0LaCqYGDtrT4O56FnYe0kD8fViWX6TSzd5/ciuuFYYCFlHoRjDB+IH4E0cNhXQQ8KvMrBbMHhDa7U+PBgt9XhhA/vASVShS0uXur07u0at8wZKbHXe1aVbRqJ8iIdanoiMOa54Eob2QD9RP1y1VDNhMMEEDcTUDAEslzKxMtLUMx5RGSCjnMEiXFL00y671z8ycn69hmRQTJ9PcIpAS2xzz+cm8+ssYkI9xJiJm8
 MbmGKka/
 bZOTEPSTeDSAB1oiSX0OdNATYLl1tdz4wQ1ggyerAp7l/7fUEHyn237YSGeIGNQk7ZjPipC5cJGDN+xqQ52ioIx/cH1QZyuYefQR1TZCj1IubZyoxPhh/jxyX6dv06Qwki5YB2S2SxHcJkhRHX0auxqIJ86ld68/VTJchs/H8iMNOZ1BNL69txtNijX2FKkgimI2AfKPmCZqJXxI4uqquItI/zS9H8yhOJBTSsc80PvSfHq3JbnvXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJhcnJ5IFNvbmcgPDIxY25i
YW9AZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDI4LCAyMDI1IDU6MTcgUE0N
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
bEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjExIDE5LzI0XSBjcnlwdG86IGlh
YSAtIElBQSBhY29tcF9hbGdzIHJlZ2lzdGVyIHRoZQ0KPiBnZXRfYmF0Y2hfc2l6ZSgpIGludGVy
ZmFjZS4NCj4gDQo+IE9uIEZyaSwgQXVnIDEsIDIwMjUgYXQgNDozNuKAr1BNIEthbmNoYW5hIFAg
U3JpZGhhcg0KPiA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4g
PiBUaGUgRml4ZWQgKCJkZWZsYXRlLWlhYSIpIGFuZCBEeW5hbWljICgiZGVmbGF0ZS1pYWEtZHlu
YW1pYyIpIElBQQ0KPiA+IGFjb21wX2FsZ3MgcmVnaXN0ZXIgYW4gaW1wbGVtZW50YXRpb24gZm9y
IGdldF9iYXRjaF9zaXplKCkuIHpzd2FwIGNhbg0KPiA+IHF1ZXJ5IGNyeXB0b19hY29tcF9iYXRj
aF9zaXplKCkgdG8gZ2V0IHRoZSBtYXhpbXVtIG51bWJlciBvZiByZXF1ZXN0cw0KPiA+IHRoYXQg
Y2FuIGJlIGJhdGNoIFtkZV1jb21wcmVzc2VkLiB6c3dhcCBjYW4gdXNlIHRoZSBtaW5pbXVtIG9m
IHRoaXMsIGFuZA0KPiA+IGFueSB6c3dhcC1zcGVjaWZpYyB1cHBlciBsaW1pdHMgZm9yIGJhdGNo
LXNpemUgdG8gYWxsb2NhdGUgYmF0Y2hpbmcNCj4gPiByZXNvdXJjZXMuDQo+ID4NCj4gPiBUaGlz
IGVuYWJsZXMgenN3YXAgdG8gY29tcHJlc3MvZGVjb21wcmVzcyBwYWdlcyBpbiBwYXJhbGxlbCBp
biB0aGUgSUFBDQo+ID4gaGFyZHdhcmUgYWNjZWxlcmF0b3IgdG8gaW1wcm92ZSBzd2Fwb3V0L3N3
YXBpbiBwZXJmb3JtYW5jZSBhbmQNCj4gbWVtb3J5DQo+ID4gc2F2aW5ncy4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IEthbmNoYW5hIFAgU3JpZGhhciA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVs
LmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9jcnlwdG8vaW50ZWwvaWFhL2lhYV9jcnlwdG9f
bWFpbi5jIHwgMiArKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vaW50ZWwvaWFhL2lhYV9jcnlwdG9fbWFp
bi5jDQo+IGIvZHJpdmVycy9jcnlwdG8vaW50ZWwvaWFhL2lhYV9jcnlwdG9fbWFpbi5jDQo+ID4g
aW5kZXggNDgwZTEyYzFkNzdhNS4uYjdjNmZjMzM0ZGFlNyAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL2NyeXB0by9pbnRlbC9pYWEvaWFhX2NyeXB0b19tYWluLmMNCj4gPiArKysgYi9kcml2ZXJz
L2NyeXB0by9pbnRlbC9pYWEvaWFhX2NyeXB0b19tYWluLmMNCj4gPiBAQCAtMjc4NSw2ICsyNzg1
LDcgQEAgc3RhdGljIHN0cnVjdCBhY29tcF9hbGcgaWFhX2Fjb21wX2ZpeGVkX2RlZmxhdGUNCj4g
PSB7DQo+ID4gICAgICAgICAuaW5pdCAgICAgICAgICAgICAgICAgICA9IGlhYV9jb21wX2luaXRf
Zml4ZWQsDQo+ID4gICAgICAgICAuY29tcHJlc3MgICAgICAgICAgICAgICA9IGlhYV9jb21wX2Fj
b21wcmVzc19tYWluLA0KPiA+ICAgICAgICAgLmRlY29tcHJlc3MgICAgICAgICAgICAgPSBpYWFf
Y29tcF9hZGVjb21wcmVzc19tYWluLA0KPiA+ICsgICAgICAgLmdldF9iYXRjaF9zaXplICAgICAg
ICAgPSBpYWFfY29tcF9nZXRfbWF4X2JhdGNoX3NpemUsDQo+ID4gICAgICAgICAuYmFzZSAgICAg
ICAgICAgICAgICAgICA9IHsNCj4gPiAgICAgICAgICAgICAgICAgLmNyYV9uYW1lICAgICAgICAg
ICAgICAgPSAiZGVmbGF0ZSIsDQo+ID4gICAgICAgICAgICAgICAgIC5jcmFfZHJpdmVyX25hbWUg
ICAgICAgID0gImRlZmxhdGUtaWFhIiwNCj4gPiBAQCAtMjgxMCw2ICsyODExLDcgQEAgc3RhdGlj
IHN0cnVjdCBhY29tcF9hbGcNCj4gaWFhX2Fjb21wX2R5bmFtaWNfZGVmbGF0ZSA9IHsNCj4gPiAg
ICAgICAgIC5pbml0ICAgICAgICAgICAgICAgICAgID0gaWFhX2NvbXBfaW5pdF9keW5hbWljLA0K
PiA+ICAgICAgICAgLmNvbXByZXNzICAgICAgICAgICAgICAgPSBpYWFfY29tcF9hY29tcHJlc3Nf
bWFpbiwNCj4gPiAgICAgICAgIC5kZWNvbXByZXNzICAgICAgICAgICAgID0gaWFhX2NvbXBfYWRl
Y29tcHJlc3NfbWFpbiwNCj4gPiArICAgICAgIC5nZXRfYmF0Y2hfc2l6ZSAgICAgICAgID0gaWFh
X2NvbXBfZ2V0X21heF9iYXRjaF9zaXplLA0KPiANCj4gSSBmZWVsIHRoZSBwYXRjaGVzIGFyZSBi
ZWluZyBzcGxpdCB0b28gZmluZWx5IGFuZCBhcmUgbm90IGZ1bGx5DQo+IHNlbGYtY29udGFpbmVk
LiBZb3UgYWRkZWQgaWFhX2NvbXBfZ2V0X21heF9iYXRjaF9zaXplIGluIHRoZSBwcmV2aW91cw0K
PiBwYXRjaCwgYnV0IHRoZSBjYWxsYmFjayBhcHBlYXJzIGluIHRoaXMgb25lLiBXaHkgbm90IGNv
bWJpbmUgdGhlbQ0KPiB0b2dldGhlcj8gQW55d2F5LCBzaW5jZSB5b3UgYXJlIG1vdmluZyB0byBh
IHN0YXRpYyBmaWVsZCwgdGhpcyBwYXRjaA0KPiB3aWxsIGJlIHJlbW92ZWQgYXV0b21hdGljYWxs
eS4NCg0KWWVzLCBiYXNlZCBvbiB5b3VyIGVhcmxpZXIgc3VnZ2VzdGlvbiBJIGhhdmUgbWFkZSB0
aGUgbm90ZSB0byBidW5kbGUNCnJlbGF0ZWQgcGF0Y2hlcyA6KQ0KDQpUaGFua3MsDQpLYW5jaGFu
YQ0KDQoNCg==

