Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A11EFD6CFA4
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 20:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1E0A6B0354; Thu, 22 Jan 2026 15:57:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9016B0356; Thu, 22 Jan 2026 15:57:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40AF6B0357; Thu, 22 Jan 2026 15:57:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD0556B0354
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:57:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B365141936
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:57:07 +0000 (UTC)
X-FDA: 84360809694.23.700C627
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id F0612C000D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:57:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FhKVptwD;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of kai.huang@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=kai.huang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769115423; a=rsa-sha256;
	cv=pass;
	b=VeNUFstECWrpAVKHkjQF+0khI8F5mXuwjGfWtro0UlkN4Q3jpP0hZJk833Z97SofVOgS0Q
	7yZKTl3iPLyGuQECr3ziXWEkLqkdyeM4ax0fxcnXTNowHHvSNJl9qU+DQ1zE67rPk7W5Ai
	MMq5gBToxZOjDEedXVqq3eWYdoJucJE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FhKVptwD;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of kai.huang@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=kai.huang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769115423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTGvwXeG6OvVSbxsML89iWzdeP4cX5ASEzshYND+4gs=;
	b=wVAm4CGj3tTxdqMrZIQHU/BHKQ7F1gtV/kyFXj3T3ie3gMNB3+ES5a3ZHuBbYgFVVO07U6
	WgzBsmZkTSvcVVmuR6QWsdu9TBI4JcIdyDcYeshHMarWHOqhHPg+Rcncj5yKDYmqbTmE5H
	Zk9HSapC2Y2lv0bK2KzEyCTVVPr5k48=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769115423; x=1800651423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QTGvwXeG6OvVSbxsML89iWzdeP4cX5ASEzshYND+4gs=;
  b=FhKVptwD3tNBSPYUgE4PflrbNQfrVEP4j/g1c9+9Wl3pMxWf63AKE5l3
   26vvnxoOtU5EVPlAabYItgv8a1kGQ4owRYl2NHMkXQpabySeQ3lva/Sz6
   FB+5jrbprhqqSc61P3fXl56oZBJNx4LmCJOxegqpW2AuRmU+HjcZxlTte
   NdyWps/XS8RyTchIyvVxKrcMEh38djJAD77aRXeD46qDw9F0rUxQuz4B7
   bDMalwzgckNev9z6DohBgsle44Xe0uI5r60qQ80SCEGLXeX9g3+A/H8eO
   tF3pZALNlUcwiWe8D/YyDPevWV3VMBrajlfWMWbd6rpx4o29iTGmdtxOo
   Q==;
X-CSE-ConnectionGUID: PP1NzxbfSpK3ydhVvvFylQ==
X-CSE-MsgGUID: 9feS9rIZQ1iNtux+rqPcZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="70534240"
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="70534240"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 12:57:02 -0800
X-CSE-ConnectionGUID: 3gab4ChGRi+pYq5CzMOVTw==
X-CSE-MsgGUID: diF6+sVtT96kWSULxqbXEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="207092215"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 12:57:00 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 12:56:59 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 22 Jan 2026 12:56:59 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.46) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 12:57:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HEX4myrVlKnTO720vYTsE4SUUhm9DjXyIbTuFu4PfhX+0RZys1JwbEjN+2oSE/pnenXqUwXAPlWc/8kvff0244iWXjL2TeipEfN3JgMwWr9tNA6Ud1NSpnOhJY3XDFc13Y5cy8cCM7a35aZBAl/0yNqgmCEP4xrxnYbB5aqyX0wRSWD/f009zKpx970hbiXtfqITTZ/qRlG2z/KwZtv+9R7PcwM4q8DCvs04Qnhg2HZ/+ZnaWlS6k0h/IDGoSVtbugCJaTF64KMu50luDURLK68szujDyRbCUOzPqfa5i51JwjWmhSzzn+oAV+BtGVIgn+I0+SEEesgp/fNF9+qLtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QTGvwXeG6OvVSbxsML89iWzdeP4cX5ASEzshYND+4gs=;
 b=SS3MsAnnXV0HduIuz59WI7PLTX1oBdcD4y5UH2CEj4+1D0IFqvLBN205jaUuTrX9ij83XLxu3iTUFSeZ6Npc2kU6hwBIbHx2ccYNJREWr5EV52McHgt0d9GwD3QUsVm6vR2g+AHcpj6H6xNjk2WlCAR2lMguSezX5xb+df4lCMG1/GvCq57jROM+Z2iyZxmTxKxYreLoggSZnSyv7SWfpKmMBi/hbKdObP6ZjTn0mE60u9P2XiTrUmudjO6mABJ3aozuUfBzeTj990hy1uT19TeylEMmxSHVbE8nZJ98bvE+ee26mAlEGuEioZDaNtjsYPv2isGZcut3VpFgb++TGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CO1PR11MB5155.namprd11.prod.outlook.com (2603:10b6:303:91::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 20:56:57 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9542.010; Thu, 22 Jan 2026
 20:56:57 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tianwentong2000@gmail.com" <tianwentong2000@gmail.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
Thread-Topic: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
Thread-Index: AQHci6Q5tvQw1foINE2mfXMlwjgvW7Veq/4A
Date: Thu, 22 Jan 2026 20:56:56 +0000
Message-ID: <5961c2655b49a7d384140c33d6897e53f89cb5fe.camel@intel.com>
References: <20260122133633.79792-1-tianwentong2000@gmail.com>
In-Reply-To: <20260122133633.79792-1-tianwentong2000@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CO1PR11MB5155:EE_
x-ms-office365-filtering-correlation-id: 0ac5aa20-21f3-42d5-8fad-08de59f8c7b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?b080UG5wZXpsNFRLZXhKT0UwcmxQUkJrU3BjTUNsS2FRRStWSGtWamFXalVo?=
 =?utf-8?B?Z3ROOW9RYWkxcnBXcmw0ZXV2Rm9FUlNYZTJBMmNJU1RVNW9FMUV5cGg3cUtq?=
 =?utf-8?B?czB2eVdFeTJGL1Z4NHFMaDlPQUdCNUV1S2hNdVllR0tGKytZdXlPWVAxMjgy?=
 =?utf-8?B?QjlucDFrN21aR2JTNW9KbEUyZGV3Vjk3TnN6ZVV4aW1lRmFRU1F3YnZqbmV6?=
 =?utf-8?B?L0IvTDk3STZJWFdaaktxZExSNDRKMUJLbytJdHJ4TTFQZ0J3WE14MnBtWlU0?=
 =?utf-8?B?NWxJM09oSFpTaFRPdHEvby84ZVFsNkJTTE5MWXpUYi9IaWFPYzJVeTBsa0Jh?=
 =?utf-8?B?aWRLUU5qdmFJUjNzTDgwU2wvd0xGRUp3eGJIbFJscWFCOGN2RDB6TzFtWHpQ?=
 =?utf-8?B?dGc0MFBCSCthZ2hpT1ROS3NBYWE1ekVEQjRvQ3pScnpYeFFOTHIrSGxlRHM5?=
 =?utf-8?B?YWhIVjUzTHVueENWL0c5UXhsQ0xJNXpHNmpmR2ljSklLcUxGRjl5MVMyNlZY?=
 =?utf-8?B?NC91VExIaUtlaTFYOU9sTjZlTHUzUzk0cFlFUVE1Z0J6MGtERTZYWHN0V0RX?=
 =?utf-8?B?Q0JYVm8yenk0dlRqZGpPbDMzaG5xYTBEM3hibEx5OU1TYUVNSlRoUE94SDkw?=
 =?utf-8?B?YUN3R1NLZ1dPdEJoZEsvbU9TYkc5QTRLMjdzek9tbmNma3Q3YjN4dmlxQjZ2?=
 =?utf-8?B?TnRWWFhGenNwdUZtVExoZDVHUk9sMmhnSVkwbFo4c1JoLzFRQWVsNlZTMk9Y?=
 =?utf-8?B?VDEvUTZBMlpESlY3b1dZVmo2dEVnbWpWQTdpcXA0TzFYa2hNTUQzTUJjT2Ix?=
 =?utf-8?B?ZzRCNkNSVTdlZ2VaWGxZWUFWRGFVbFBZbmxBSG53U3B6UnJDOEZpaVRlR3pT?=
 =?utf-8?B?Vy9MVjlXRUgrNHRaV0JWd1RlTVpiRjRPdWRDbk1pbi92dHJRWURhYmpDSUN2?=
 =?utf-8?B?OS9DZ3ZZaG1CaXBKaVBtVHh4UWdmZEpvQk0wTGlJRFJYazJFektxc0xhQm1w?=
 =?utf-8?B?R3doMWxYMHFpd1Ywa2RUVGJUNW9VUXN5T1RkOGN4VWVwUEh4MlVsbEFSTzNJ?=
 =?utf-8?B?aHBaN21ZekRCaGlvVG02VXFNMlpmbHgxd1plSmY0eFM1Qk94Wk56TzJHazVG?=
 =?utf-8?B?MkgvV2NKSHB3TXdERTVINkl2NnYvYnVHRVdKYXVncnU5THVEYW9sSzlUQ1c5?=
 =?utf-8?B?STh5NnhQb0FNYmMwLzRLUVBRT3ExMktLUjU5VHRwVFJxWTIvc0tPN2JLc0Nm?=
 =?utf-8?B?dkE4RjBFWFJBbFB1U29vU3NsTDBIWTZoM3hxbUVIYk1ra296ZDFsWUJYM3Zv?=
 =?utf-8?B?UkFEZTdDOEVzZVpyTHpqRmNNTFg2RHgzd3hESGV1YVhDL3BTTmpXR0dOUHBT?=
 =?utf-8?B?N0Q2Z2cxTE90cjNteUVjWGt5dEpPWkxZNmwwblV2bzM1aHZUYXl6dnp4aGFE?=
 =?utf-8?B?WUNYSFprbHBnUnBTNHV3dlFYT2FGclhKQ2tHNm9CcDA2MUk3WXBRb3drbTBN?=
 =?utf-8?B?RVhGTXFTNm03eVh5ZkY5V0lFazl1NXMydmF3dGhGMkgrd0ZUYXUyajB4RXZN?=
 =?utf-8?B?dlJhWHJlU0VoVWZ6NnQ5WjZPWDdLWFdTU09vQXRoM0tJaVBpS0c1ZkJ0K0kx?=
 =?utf-8?B?TG9vVldiVC9KSzJlaUpwenlaN0J6MFVPTlUxOVBNMVdDdm9ybm1KVmxyb3N0?=
 =?utf-8?B?RVhKeU0wTHJGNDJXN1FTRnlTcW5kNUhHczduOGJ2QlIycUtMK3NDQWdNWWZx?=
 =?utf-8?B?ZkZXd3l0NnlZOVRGeFVyd1FCeGVwSXVoR1g1L1RMYStUV1VoWGNBZExWanhV?=
 =?utf-8?B?Wk1SVjVuNUtHSjRrTzBNNFlEaGhTS0hUNVduazVGbTFYYU5lMWI2ZzRYTXNs?=
 =?utf-8?B?QVVZZXRqamdiNHJkSFNvZ1VwWjZUWEE3KzhFWUVNdXpRR3Z0eVFreTdXVTlZ?=
 =?utf-8?B?MGY4dFM5Tk4yOUtLbHM2MkgydWsvM3YwemNwS2p5eVM1a0szMzFwRnVBc0FW?=
 =?utf-8?B?aGNEVExQb20vekdYVVNPSGNBQlNiOTEzN2hBU3dtM1ZtNlh5aDZCZGRhZktp?=
 =?utf-8?B?QU9kOEVIV0p0MXMwQThMMEQwaE9GeEc4eGhFNWNBeFM1UFN0cVMrWnhPb1JI?=
 =?utf-8?B?MVNUQ3BsRkhRYW4wOHBSVEVZYVpiWlcxL0J1N1R4NzhBTlRCZ3dzQmVkQ1Fm?=
 =?utf-8?Q?96uRz4QfKYLruOa5Tyb0hfU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmdoSXdLSUJwMmN6K28ycnVXNnZYbk5XMnJCbzFnTGFRRXJkdm8wTFEyS0FS?=
 =?utf-8?B?UVdnKzQ1YzUxaDhSYlVPeHE0S0xadHVFSGRGNFZmRGtQNEd3M1krMmw5clB6?=
 =?utf-8?B?MTIyQzhMTm16K0hENzJ4VisxMG1Venp2YzZ2ZC9KYUhyeS9UcTBGVXA3VmFH?=
 =?utf-8?B?VkZRTjJSUEpiT3BCVE4xT2tURk9GR3hWREJLekdaNk4xS2Zhb0M0K0o5eUFH?=
 =?utf-8?B?SE41RkU3Z3lzWlNUTWF2c0loWmM2NzlnM05nTVNqcG5FQmtEZ2d6MkF1VUF4?=
 =?utf-8?B?VEp3M2dJMStKSldRTW9WN1dER2xIRnBwVC9CdWZyVWRhZkJtNjN2djBCQXps?=
 =?utf-8?B?Zk5HTmRCTjZBR3F0SUNyMEc5Vmg2UXc2ajJ6UlFUNkxQTjMxYkI0T0dHNXFE?=
 =?utf-8?B?YWRWUDZFWTl1OWpRdFJ2bDVGeUFwaHlZVGI4TTNTMlV4aEFsT2ZqV3RwdkZt?=
 =?utf-8?B?L1hHZ01zNlhVYis5TnZjSXBmSjUvYVFwUUE5OHlCdU9SKzVZOEYzODlFZ25J?=
 =?utf-8?B?RTE3UGRVcFlEU0ZIUU90MXBFMkM5ZG1sWFo4YXllcGxvbVFuTjh2WXI1Sms0?=
 =?utf-8?B?ekY3NytadUlhOVRjV1hpSXhRMXFKMkxFcVU4aWVxd0preEt6ak1uV255S1py?=
 =?utf-8?B?bndCNUVyVGNVaStPcko0Sk1Fd1RYUmIwT3ZWc2E3ZHBFbjZOYUYwaCtJVHR0?=
 =?utf-8?B?M3hiTTdNa2E1ako3SDhFb01rZWJvY3hOczFlRkVQTi9yZmJWTTc4N015R1Fn?=
 =?utf-8?B?dXpjNHFITVR5Q0VvZGJ3OEpBa2JtbTV6ZW41UmpqeUlnODgzWHFTdS9CMFhx?=
 =?utf-8?B?dGl6eEdVa2xySWlDN1F1SVFITm5vd0dXUzlDalRRcGVKUGE2VHRFNHBRNXg5?=
 =?utf-8?B?TURTNnd5cTU4RG1EZnRjR0t0eXUyNUxjK3FmK0xIVHFaSkIxY3M4d0kwVG1L?=
 =?utf-8?B?M0p3WXkzdjkyQi95UVNtSHpEZDBQYTUwc0poLzFqcHNCNnhSMWZXeWE5VmlE?=
 =?utf-8?B?dlprWHRlYVNDdDdZTmpzNk9jZU1WdUhqUllsb0E3VGlGU1d6WWpoOHdwd2Fk?=
 =?utf-8?B?UTlCYzMvMW1JYmZJUkpZclNQKzE1M0FycDY3d3owQWVaY21DSmducERMWkRk?=
 =?utf-8?B?WVM0cGtNVHRIbjJ5ZmxCMkt5TGJKQ0xsTjYvUW5Md1FpUnArSXo0Tm5GVGtl?=
 =?utf-8?B?ZGJvRS9uMmx6RGx5QzV6Nlo4OUJNMGcyekxEK0sydjEyREt5VjA1VSs1b1ln?=
 =?utf-8?B?bU1JUGUrR1BwY3l5SnJ0QUJYeTRoVHRidFc3UWhFQ3d4WVBXOUhZNzYzbVFs?=
 =?utf-8?B?OFFhZksxUzVaMDQyYU5tbEZFaEJDZE01cGRtRnJxM0M0ZmZmT1B1U093WXVq?=
 =?utf-8?B?Q3BTN1krd0R1Z04yRjhtWFE5OGMrcnBnRDFXSDVXcHliaitJRTRySll6Z0Nz?=
 =?utf-8?B?YUF0d3FMcHJTZ2tBUTBHZ1d2Tm9YM2ZHeVA2eDRBeWFjWEVmZVlaYXJLZStG?=
 =?utf-8?B?VGlMTnZURHppVEg5ZEJBQm1CbVdXN2l5cjY5NVFwTWFwd2JxcjNhZVVlNEVI?=
 =?utf-8?B?dXZ6RlZaNTAreGdLOTFVcHhBcWg5N1NqRlVGM2JPbGxSdTFvQkdVTDVKYm8v?=
 =?utf-8?B?RUJLV1ZKc3JwYjlYVDZxdkw5dUZzeEgvRTVuYUJKVVVtZlk2WHBnTWE3d3hE?=
 =?utf-8?B?c2FNa0J2U2kwS2Z4YkhvTjNtOUlzcVFiVFB6aVRYWVF2K213ZEVCUzFFSmdE?=
 =?utf-8?B?bi9CVFhxRmRGNmIzcHpBTXNxZjF6d3VhY0c2akxaeFR3TVhwSm9MR0JnSFJU?=
 =?utf-8?B?UmxISGc4MUEraU42bHZGR3Fod1crcDVPbFd3RTRlZ1dlVkFMTk9iWTV4NWJ0?=
 =?utf-8?B?YWFBRW84K3JDMmkxV0dBZDBVTmNsNmlqbGFhMS9WWXR1ZGQ5QWJXMWwrR1h2?=
 =?utf-8?B?R3dBN2RGNXUyQkdGelZmQklKU3FTZ3dUK0t5QkRUU3VvUHhnbzdzbGhaRndD?=
 =?utf-8?B?V3pYVkFkMFFuL1pTZmNYeTAyaU0yaTQ0b081WWMwU2lKeHJ0bzRDbDlmTUhx?=
 =?utf-8?B?QWpzUUZHYklWU1FTMjA0Tnp6cEpUNGF1am1neWxPSkttRWF4c3ZQb0pjQVda?=
 =?utf-8?B?dGVWSlZMZTg1T2tZd0V2OGY4S3F5Q1h3ZU1mMnJ1OHM0d2Vhb0lZYmpjWU85?=
 =?utf-8?B?MU94dGJjMUtGWmFRWFFDWFl5VExCL3p1dVBsK29UQXFpZUVwRGoyb1lSNnJq?=
 =?utf-8?B?MTZNUyt5NGJHVWZqU0E1NWZHR2YrR2V0RGpHeitEU0NyamVUMXhSNG0zQnFq?=
 =?utf-8?B?ZUpqT1VzZ0VBR2Jmc3FSNUxibFFkZzdsbFFFL21wUUNTNjZ2WDNBdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2BE6274AFBC7434CA713C1A24209DA78@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac5aa20-21f3-42d5-8fad-08de59f8c7b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2026 20:56:56.9659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fG4qlgi7PpT1hR/b55OeK8u0ZiWCwhHNbIkkntwrHpS1GqFXuCzbqDjQCvauYie0UMwURvqXXgeTlC5ty1VghQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5155
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F0612C000D
X-Stat-Signature: 7wfq1mzi9bb977dq3hwsmw4c5xficdmu
X-HE-Tag: 1769115422-450863
X-HE-Meta: U2FsdGVkX18wia6S2q3PNH97R/L2v7emvCiUpxglcWNVdI9AxPhIbraUCezh6fd90Sq1/N0/K6DiquXOpEFLTT5xjh8sFCswiA3WfCGf7iio75wQzJncsxxWnxtI74wXfYveC/VNuEVFkxlCvusv878j5Nr/9xTnBcMDPOe2nHYlQp0iBaUVhwbVjkI9Q+MkC1PFFvbWaxmNZKBGli1lTwWxvyviPBUU2akWMIyLKW0mmqfIsdeXyqOdNlbE5g8duLcynPKKC8Fw1BRvmXCMDGlTX50TFRj/op4TaoF0pqQS6+oEN0vqXFKJsFOQRaxuay1VbGAN/6DHdkZJ+kTBDtPHX+nLlBOnaTt8AVh8RbRYTB1ygaqFA8udjrWg/Ao1TnxINhct8odB63o2k2P15Y7J/AUVeKQokOpstIsm3FA7HXMNgfVGnxOJqDtvJwuRaC9wx6F/q6smf4xHMnANYAUBM/6bUY6o5+FD+5/kX1Dp4bi3aNKYvsRzmouSVbbJQQ56kROamspYaFTqpKxtgAgW0wO0+uEM9otZLPS1S0VjArmqtIlK8gc830bxuos3xHZqqIMWrRoZrWjtHAyOQRsM70CLk04v5fpqa8DrgntyeQA0oeKl0ftprlG30Q6nx7IqifioQZf6/sYgUeVA/euhL6Z3ub9wnIpNHs3ENLGoVVcXDS/IeoX/fZy2rhpZmY9oyEI3XNxK9J5b9IrHYF8tYEdGlEj+ZH2nBbHr5SSazMl5IfomdR8072Kjd7NmVPsXC7xOy6eHXBh4epYDGGWNw9dGmwgPJctA8pHmfuW1ZS5lWQkMozIHzUbVzL10eLMmod334hbfDOhyi8D9nlhf5P3shupLZ7fJnHxhERNVC4Bh6CRz7XkB7u60p7+qHpegTIWDOfYWLfU9tizRxUAd7sVc5wKezi3hvD710rnKDknflpVzbqhuwAn+BRXYQREoMjzpKI+UMSMglZI
 e/W6SHpA
 Ha5xNrxKE4Wgu/znKSMb7aKov057YTMEb+O3pUNPYgNFVvxNFVJ2uCdqENlNzzzcYWGp4Nkjm9LpLNtwelR9huZIhmhVF6qGWRjMaoeci3ujyNB0MVzJrAK6YYzP+UGIKVp7ulgR887y2M3MNSNQbfb0yYDYY5FJBtNKgkCkQ6zIOXdfgo25/oDa4KpngPlcAl9FwEaU0VnsSxoJy9HOtU5UJqP9r2E1qRpXcN0ZaNDicNHPxamENeGTRdqxIfOtZxkRynPQdvNt1uEGKK7YBmzSHJiz0ibw9IUHQEPQlji/AwH1A57UHSaH63tEwQFZSZrp44KRG6ylSACtIUleJEIo7tXLGYM/254WdyCpWuDsZZC/zBwo8/BfUHaGnWEsemkvOeL9hrsaZzEg3vWFkLy6aXHsA+f1300SS80J6C4/wuYUgB2wzCG8NdsB1qksq6CPXQNkWcB8qEYnH0ZlTOKZ2crsn+WOhOCiHfF0W5newHj1tdHPPE/IawRPFpqjsS64DjpqPVII14DzBPL8+OiN88Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTAxLTIyIGF0IDIxOjM2ICswODAwLCBXZW50b25nIFRpYW4gd3JvdGU6DQo+
IFRoZSB2bV9mbGFnc190IHR5cGUgaXMgdGhlIGRlZGljYXRlZCB0eXBlIGZvciB2aXJ0dWFsIG1l
bW9yeSBmbGFncy4NCj4gQXJjaGl0ZWN0dXJlIGFuZCBkcml2ZXIgY29kZSBzaG91bGQgdXNlIHRo
aXMgdHlwZSBpbnN0ZWFkIG9mIGFzc3VtaW5nDQo+IHZtX2ZsYWdzIGlzIGFuIHVuc2lnbmVkIGxv
bmcsIGFzIHRoZSB1bmRlcmx5aW5nIHR5cGUgbWF5IGNoYW5nZSBpbiB0aGUNCj4gZnV0dXJlLg0K
PiANCj4gVGhpcyBmb2xsb3dzIHRoZSBjbGVhbnVwIGluIGNvbW1pdCBkNzVmYTNjOTQ3NTAgKCJt
bTogdXBkYXRlDQo+IGFyY2hpdGVjdHVyZSBhbmQgZHJpdmVyIGNvZGUgdG8gdXNlIHZtX2ZsYWdz
X3QiKSBieSBjb252ZXJ0aW5nIHRoZQ0KPiByZW1haW5pbmcgdm1fcHJvdF9iaXRzIHVzYWdlIGlu
IFNHWCBjb2RlLiBBbHNvLCB1cGRhdGUgdGhlIHZtX21heF9wcm90X2JpdHMNCj4gdHlwZSBpbiBz
dHJ1Y3Qgc2d4X2VuY2xfcGFnZSB0byB2bV9mbGFnc190IGZvciBjb25zaXN0ZW5jeS4NCj4gDQo+
IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogV2Vu
dG9uZyBUaWFuIDx0aWFud2VudG9uZzIwMDBAZ21haWwuY29tPg0KPiAtLS0NCj4gdjI6DQo+ICAt
IEFsc28gY29udmVydCB0aGUgdHlwZSBvZiB2bV9tYXhfcHJvdF9iaXRzIGluIHN0cnVjdCBzZ3hf
ZW5jbF9wYWdlDQo+ICAgIHRvIHZtX2ZsYWdzX3QsIGFzIHN1Z2dlc3RlZC4NCg0KSG1tIEkgd2Fz
IGFjdHVhbGx5IGp1c3QgcG9pbnRpbmcgb3V0LCBidXQgbm90IHN1Z2dlc3RpbmcsIHNpbmNlIEkg
YW0gbm90DQpzdXJlIChob25lc3RseSkuDQoNCkJhY2sgdG8gdGVjaG5pY2FsOg0KDQpHY2MgZG9j
IHNheXM6DQoNCiAgQSBzdHJ1Y3R1cmUgZmllbGQgZGVjbGFyYXRpb24gd2l0aCBhbiBpbnRlZ2Vy
IHR5cGUgY2FuIHNwZWNpZnkgdGhlIA0KICBudW1iZXIgb2YgYml0cyB0aGUgZmllbGQgc2hvdWxk
IG9jY3VweS4gV2UgY2FsbCB0aGF0IGEgYml0IGZpZWxkLg0KDQpXaXRoIHZtX2ZsYWdzX3QgSSB0
aGluayAidGhlb3JldGljYWxseSIgaXQgY291bGQgc3RvcCBiZWluZyBpbnRlZ2VyIHR5cGUNCnNv
bWVkYXkuICBCdXQgSSBndWVzcyB0aGUgYWR2YW50YWdlIGlzIHdoZW4gc29tZW9uZSBkb2VzIHRo
YXQgdGhhdCBjYW4NCnRyaWdnZXIgYnVpbGQgZXJyb3IgaGVyZSAoc28gdGhhdCB3ZSBjYW4gYmUg
YXdhcmUpIHdoaWNoIHBlcmhhcHMgaXNuJ3QgYQ0KYmFkIHRoaW5nPw0K

