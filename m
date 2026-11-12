Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9A52606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 04:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=MKSrBppv
Received: by kanga.kvack.org (Postfix)
	id 0DBF36B05B1; Wed, 11 Nov 2026 23:58:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08D5D6B05B2; Wed, 11 Nov 2026 23:58:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97696B05B3; Wed, 11 Nov 2026 23:58:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5A0D6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:58:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BD0516044E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:58:32 +0000 (UTC)
X-FDA: 85425261264.12.AE1FD40
Received: from iad-out-011.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-011.esa.us-east-1.outbound.mail-perimeter.amazon.com [54.211.126.101])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9B6E8140009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:58:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MKSrBppv;
	spf=pass (imf09.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 54.211.126.101 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794459508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zasZMfYNsTWpPANn91IKNSeSpGR3YYhnfco+yI8xjqM=;
	b=y69eGaX7LUscavLRnUjEa4sD12IUxhTUzqLq7+T61F5pVaP3nU6U/mWP7FDh354lQb8Zh+
	gRe/haJBISfBXak8y3RYrbFFZMXecpS07SZ2/AX5LJMIJcsuRPp/CmDIQRX67mair4oW7G
	+3oTpVs1N+gTeQaZap9jpnSbHBaZ4D4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794459508;
	b=Lz9h9L2tjzn8+xbf74/iqF5JjOoLePGnhrfMc+LN5JczaTqz9PS9I0ywPo0iWc4Q3mCDNq
	T0rZEcwPEoja4oK4WkfJHdVYnmxAomhxPO2N8hChax3iBcBynMDLu/WUsL6t1WmuDvB2AY
	9+m4zKkGVUmNArbM42QddmzJ1TIC4Ik=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MKSrBppv;
	spf=pass (imf09.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 54.211.126.101 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794459508; x=1825995508;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zasZMfYNsTWpPANn91IKNSeSpGR3YYhnfco+yI8xjqM=;
  b=MKSrBppvjD6FQvppYz+lx0VRwKwSC0ujt2IYpfkfXrd+gKA2WkIYMdL0
   gc5WqcPp38YoGC7jtsfXfFgbSzcXKujHdBb23MaPlr0DyQNL97I6Wrq90
   2dLLNK0Ncxp56dZhvmWWxYAeJLZL/ep/yxNY9gszLlgHVuJ8Jsq68E/A8
   E3mT0uVg9aiUFT4ev1oto5yvorsobRGkNwsyJr8OlktRqCWKMy4ZfokU0
   UeOlPqZ5vUJGFZtft63zef/y3aP3IvlI73JExCqMh4x3QNrdf3MR/Vb2N
   qwHHFLiaL9AvmE5yPdzTA6lGGKISJOEM7HcEhoB5XPcZdrY7w/P3o5IRr
   w==;
X-CSE-ConnectionGUID: cU9KumNdS7SGifmqbVu2Yw==
X-CSE-MsgGUID: Hb3zYdLyR5CfkbWfGmol7g==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="31609533"
Received: from ip-10-4-7-229.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.7.229])
  by internal-iad-out-011.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 04:58:25 +0000
Received: from EX19MTAUEA002.ant.amazon.com [72.21.196.65:30651]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.18.132:2525] with esmtp (Farcaster)
 id 27812c00-fc59-4c11-b03a-8e3ef874e704; Thu, 12 Nov 2026 04:58:24 +0000 (UTC)
X-Farcaster-Flow-ID: 27812c00-fc59-4c11-b03a-8e3ef874e704
Received: from EX19EXOUEB002.ant.amazon.com (10.252.135.74) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 04:58:24 +0000
Received: from EX19EXOUEB002.ant.amazon.com (10.252.135.74) by
 EX19EXOUEB002.ant.amazon.com (10.252.135.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 04:58:24 +0000
Received: from BL2PR08CU001.outbound.protection.outlook.com (10.252.135.42) by
 EX19EXOUEB002.ant.amazon.com (10.252.135.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56
 via Frontend Transport; Thu, 12 Nov 2026 04:58:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q0dZs3X5XAfMchQHAYeEgf80sc9aIr/r3d04rUFZOZLCYVCmBhSKBnccuCaH35LFvXGweGfZoBwm7CebRTVaECxzi8ajsUowTe7luo6ZTyGxv+Oe+Zw6ys/68BHJnl5XDEd4XqqMu64KpIab+bPqet7odoWbUXnBjC+an+RVGxROySP8G5BHkadVWDzqOBrSIrIsm27SkZT5oiWcYREqqgTIa9g2kOc86XRK1Fj2YX2lakiycjdWdRb4/LWPLbRBtAxIwidIN+CAxYmu6+FuaDG1mBJkxkjc+vUPJa6vSCRWTXX1YjQ3dtmmwqRBLgZ0URpEVtm2ges/AC+M2GbLmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zasZMfYNsTWpPANn91IKNSeSpGR3YYhnfco+yI8xjqM=;
 b=CqGHS6X2lMItA4DYmBkhUIPSJxocJ6wZXKfk2c8txpa7aDKGaVkrVA7wpeTvLaVAk1lo0bUbdBsf33zBKVEPoVGsQRDBAH/nzQuDrf59CtheYLnE2o/kYUpaV9hA5i//Ock4DqX3B0AxA+yHY5UzaAwzd412MOaHB613PDzfDm5sGJsLVehFqAlgKvv8bWXA55BN9ri7jQNY2Sb9zzeuvjsOdMhKrbzLLwrVoT8mQfEhyF7uHsaE2RGpeT0b8Mxaz/6dHsW1JSx/s+4JbU8lj3ASD2DuLGc0tdzEYDrbHRJNPaMrABNUkU3g5Iw18cTJjKmspMYlFZd2u5U6e1RHXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.com; dmarc=pass action=none header.from=amazon.com;
 dkim=pass header.d=amazon.com; arc=none
Received: from BY3PR18MB4722.namprd18.prod.outlook.com (2603:10b6:a03:3c9::19)
 by MW5PR18MB5068.namprd18.prod.outlook.com (2603:10b6:303:1cf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 04:58:07 +0000
Received: from BY3PR18MB4722.namprd18.prod.outlook.com
 ([fe80::e307:5f61:2694:b219]) by BY3PR18MB4722.namprd18.prod.outlook.com
 ([fe80::e307:5f61:2694:b219%4]) with mapi id 15.21.0592.009; Thu, 12 Nov 2026
 04:58:07 +0000
From: "Farber, Eliav" <farbere@amazon.com>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, William Kucharski
	<william.kucharski@linux.dev>, Vishal Moola <vishal.moola@gmail.com>, "Alex
 Williamson" <alex@shazbot.org>, Peter Xu <peterx@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/4] mm/huge_memory: use the large-page PAT encoding for
 huge pfn mappings
Thread-Topic: [PATCH 4/4] mm/huge_memory: use the large-page PAT encoding for
 huge pfn mappings
Thread-Index: AQHdcmJoXcZZsP6Jtk6RNI0rE+R5kw==
Date: Thu, 12 Nov 2026 04:58:07 +0000
Message-ID: <BY3PR18MB47223FC764D8F207D0B4B21BC6702@BY3PR18MB4722.namprd18.prod.outlook.com>
References: <20261111140655.34281-1-farbere@amazon.com>
 <20261111140655.34281-5-farbere@amazon.com>
 <8c221ebf-ccc0-4541-bdc7-ae216d149dae@gmail.com>
In-Reply-To: <8c221ebf-ccc0-4541-bdc7-ae216d149dae@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4722:EE_|MW5PR18MB5068:EE_
x-ms-office365-filtering-correlation-id: e815098f-e143-4d08-e51e-08df40798ac7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|366016|38070700021|10067099003|11063799006|4143699003|5023799004|261021121427099003|261009223027099003|261102123227099003|56012099006|261022075727099003|22082099003|18002099003;
x-microsoft-antispam-message-info: NFpbjkzHBpOl4ntw5Dc6CGTZL96JcsqJutLCRT/F4tuiCxK/EZbrZF/h8A7kIHo37gQVtzPtPgNK6RzR1PbmJF6a+e3NhWxCnGUh3FnsycEdqQ/IPXbcTVp+4TSTmPzXlzfA9UgaZGor1TEsEJ498ePPT+xIW3gwLzn15iQ2N3KOxHyASov7e86Lg22KPaxy9Zb8EQiPBD4HYArljGnpiJ0EHyk3xzYOWN37sUyZLAUIoyH3TV2uFRSfr6Odud1xE60jOCTc435NQmLIYX2vKoD/1xA8p9LAjMbI7+WSrJ8t6/SCi9+ZjFCgwQ+BWdyTDvOjZidxC1zfRAaxGvmn363b6fViNdSd8WiAjwAdklspX/AwjOOCiC+MjMDyHmH/NO5yld1UrFiW85dI/sQVEo7BqHafjZOCaIZwEzh21bQyK1YlJruaaGRJXcomt5rGneFwLELuoEGW384MFNeYKkO/2yieFRQ+YEqw5k7sXPrK3UZq0SahBEh0hiiRjSIVEZeD+q4Ti54P07jwAOMu51Fcx7Gxx3IGNCRgKW6uGHqyqb+WGiDy6LwUw/YqUqrgfH8pvr74YPdaviILhvaSclyxNlJ/R7jVpxqkI7uGgztP110HMXJNTlqcRTQAG5KLvzThwcGUqKbcqeXqMM0oE5znHOABAnHpCiv08tw+7YJbzg5oKDMN48VY8rUsuWpB6wHSR0lpUv84bc4B3ec1pzjeDtLAgnVCr/SXiFyqZ2I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4722.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(366016)(38070700021)(10067099003)(11063799006)(4143699003)(5023799004)(261021121427099003)(261009223027099003)(261102123227099003)(56012099006)(261022075727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFJlK1JhNjAwR2YrYkx2ZjNyUGFkS1VaRlZubWJSbWhLMnNoWEZRTW5kcStr?=
 =?utf-8?B?aVRLcHEyNGxIbUpoQ0V5bi9BTStZb0ZaYS80cFQ4Zno4UDdZdmYzU0p5SVB6?=
 =?utf-8?B?U0dzVjZnc0lRQysxTmZXaWdGanlMSW1kOXV3MEx0eVZRaVVrcTR0aUtlRVBn?=
 =?utf-8?B?a2ZNcE5KbnJYUGVTT0hVQmRSblhwTWlPSjJWaFVtU1hTSWp4RDJScGRrSVBK?=
 =?utf-8?B?T2Q3RnQ1Vk12c2dlRzNoVVM5MENvU2NTRFFnTEFXb3YzQnVvU0UxZTlTaTJP?=
 =?utf-8?B?eEdjWTJaQXF0MTdDWnZyWFNmeVA4NFlrRTlyQ2NrbVBmYkhLdkxIaFpzVE9M?=
 =?utf-8?B?bUJkb3M0K3AxMG1jTjJPbldJOXZKQzFPczkrTUR1MjQySXRPbkpyV0hqeTY2?=
 =?utf-8?B?T1N1V1kzWFArck8rNFN2TWFBcmdGdjVmcHZsQlRnNlkyZ3l1M2dRMzBFM2xh?=
 =?utf-8?B?VEdXM3VCWnVBZTN2OG1JaFo2Wnk5VEd6ZGZ3MjhPbjJBbm1ROXVRYmhxMmpl?=
 =?utf-8?B?R29zUFY1WEtqb0FzS1ZMYVowUWJoc0piVE0yVG8reDF6REFMVmVpRzJiY1ZX?=
 =?utf-8?B?VExDc1o2U202ayt2TUdDWWtQV3ljd0VzaHhHSEJjNXptRGtCQTNwVU9rSWNG?=
 =?utf-8?B?ZGtienBSMnpkYUxaSTdqMnNzZ2x6cE15REhQRUZxZUtjNGkzYklXTElFaU5p?=
 =?utf-8?B?Mk5IN3BvTzBldzVSMUlKemNXQ084WFlrbWhrNDFuWnFraTg1WDhpTDdVdWdi?=
 =?utf-8?B?eVByMSs2QW8xRDN1ajRUNDFYMkdWUDE1MmFhbzB5TE5OMkZ3RDdLbmpUcndY?=
 =?utf-8?B?L20yUHEvNU5xN2FDcDZBV3F2bU4yVktPMk5kTEdDS2hpUXNKWUdXaE5RVFdG?=
 =?utf-8?B?N3kzbEdZM0haRkJqK2k0Qm0xY2wwVThCTWdUUDJGNW5OVWNLd1NucGtTZmVo?=
 =?utf-8?B?UzAvaVppSDc2ZE9QVkNSOHNOYUc3WXVHbGJaYVFuVG05WVBzcjBUQTg0NmtU?=
 =?utf-8?B?QTJudkJqa2wrVVlMQjAvUUVzeTNkRTFXdjgzS0ZNNVZCWVljQVNvV3lLSHlP?=
 =?utf-8?B?OEN6dXR4ajA1RWxaVFoyd1pQc1E0MnB3czhZSytaT1JZYTFoS0Vxd1UrbUpU?=
 =?utf-8?B?d3V2RHZ2ZGhhN0loZnZualU5emJsNFVLU1RmYmpuRzNPK0RQU2xjZzhlT2RN?=
 =?utf-8?B?Q0tzMGZTTXNBZTVLZXZaZnlvaFlIaU50NHV1L3ZZUEgweEhQWEJhR1BvdVRz?=
 =?utf-8?B?YWF5YjNMOGRFUm85L2dSOFo4emJLV0YrdE55N1JMODdGV2EyWWtOOUtlNDdO?=
 =?utf-8?B?c084MDMvQ0dJMkJ3WTlCc096WXFWcUtVS09sRWR3TEticEZUckEwRm12bHVl?=
 =?utf-8?B?ajFXTFZZVmxhQmJ3WGVUV0R6clArNSs2WU80Y1pKdFlMUmw5Y2JnYkpZY1NJ?=
 =?utf-8?B?T0ZCU2dPSkEwUzZzS3pqbHBjNHZKeDhFRTZxaGlCaEl2TWU5M3ljWGhldTUy?=
 =?utf-8?B?aklrSWJrL2JHVkxzdnRGOFIzbU9seU0zMkVTMXQ1b3o1UE96NEZHN2Y0Qnh5?=
 =?utf-8?B?aC82Uyt4RXFlUG45UjdrRjQ1TElqcUJNa0Q0OHljSUg3ZUF2OENMUlY2OHNn?=
 =?utf-8?B?YWlpYkV3d21ucWRZdTYzcU1Bc1hLaWRLL3crTy90SXhraTJWQURWZVhaKzNQ?=
 =?utf-8?B?cHRHdko4aGVhemswM2xyVFhsRUxaSGVWTGtRNzRQVWVMTVJWU3hLYXhwZGUr?=
 =?utf-8?B?R3VMaDRsV1FwMlhpa256N3ZDZkpBS2FyczUyUVZqTHlYNEZZb3EzZ3BZWm5s?=
 =?utf-8?B?cDI0L3c2cDByeVQxT0w0OXYzWVAxS1grc1JzNGxMSEx4N09mRkg1L0UweG9M?=
 =?utf-8?B?RE9WRjZ0dVU0NnRYbEd6RkF5ZlN5SGFuTEw4RWljL3JuRUwrWHdKN2JDMEtz?=
 =?utf-8?B?K25OQ2s1dzlKTjhMNmZVY1hIZGpsYWtuRzRTdmZqdzQzcHhWdm1ENHhNNkJa?=
 =?utf-8?B?Zm96L1dNTVM0TlFuWUNhcUtQQnZzeEdBQXJvWkxqTjIyUitzSUR2aFZYbDRO?=
 =?utf-8?B?bFBOVXVDRk5ZakZLU1pmUm9Tcit4OWJ0RlJVMFAwVVI2YVRvRDlrS1ZGdk9W?=
 =?utf-8?B?aEl2Nkx2VG9MTGlQOEdKZjhFc0dJZVN3THY3Z1plRzdOeUtHOS9uQUk5eEZZ?=
 =?utf-8?B?KzRYY0RaWVNoeXRkUC9SYi9vQ2VkNVAzWEpPditEMm9paGhpWE5XT3ZKVE5Q?=
 =?utf-8?B?Z0U0dlpWYU9FSmd1L2ZRNlQ2SFIrWEpnQXhnSm1vWEp2WVpWcW9ieDdtQkRI?=
 =?utf-8?Q?JrO2Tcl9cAnewyv5Z+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: p3S1QKf8XOEVVYWpDzLYfV6ZnK4liuOXfxYBEkL+fL+n+UMTYh5bdg4uXBOCarcOcEsRnh7VWqMhmHYnP8W2dIURtmedidZEtWEAwUscI6X9qfWcdzHLbNWPp5YRCvEGHqETfceucinsYU6lLLkKKn1W0CVFxyGz16UJq22KTuH46Trmjn6FFhpxiz9SxfdJTkQ7osmtqd2Z47t6WvRic1mEQL5yxsW9rE8b5OZosWzgQ843R44o0EkkqnD9u4f2zEUx+O76i4NDlmQRujKUaHQ/dFS+1Sq5/YnuhN1YcbcsRwZC502nOve4R1ciR+zVRJGx8xxi5L9tHTY1mGhNtQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4722.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e815098f-e143-4d08-e51e-08df40798ac7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2026 04:58:07.2452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +avQFXJ+3XAxFptJ/U/NpY5jDn6h0BfATDsNb5QyEZXYI7ymjAaQXbTya2L830cUIb+CPgdKj823VNP0eFVqVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR18MB5068
X-OriginatorOrg: amazon.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B6E8140009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 7yhor4zf3ecn77wuc1x9zidhnxz5wmmy
X-Rspam-User: 
X-HE-Tag: 1794459508-835519
X-HE-Meta: U2FsdGVkX18iyM2+39yz8vnTZeltBQtmXFvumZvjUrmLZ2D8/CWdHB8MadQxO/1nKLARmsD25kKKt6uIajhCYEdWZFykkon/KI3Oe8hkv8syQNkSRRSsM/Yf9Nq4PCi208fIPXZiWLsDAf2JIW3sv6IUNPsNGAYNT4pnpt4Z9idOpw9DE19PSa9ydMcinw9tobfGxEnfuj6DDaSo+hYg5UM/uVOnTupbdUkgBBMrEyYCotXb1NPUYXn8zvT6+EoNGJWxmd0lHc2hbGOK13kddctW/nwoSfp8g/+d8UG5IAsVM5dv+4tZAanAcy73+8Wxs1SKme3/dGmdii7/Lx2nUI9o+zEI2cBSW08OJ8xlrN9hQ0doYgMZ+geF+TEfaIRowCIHwXWy5n+S8x9NgsWMVuH580UMAEL4QaJuCK5EKwy7r3JSzPQ1i9y/Mnw3PUV6tjSYz6ih8SAIUq/IU37yJlUfwaFnNtgnK/RaNGreUkiVyzlVqeX0luxgXsxrND9C9VzB9midW9H3gbyS+o+dSY7ba81D0b2eOEVB+Hjxr19zF/Nb28cX/MRNwQ3iNM+AJFjmVJlL1aFsnopzN0HNHBB3llDd9D4UITPDJ4rjYEqodvb8wK4VUJRCRRnQ2X5iOmtloVrYMQHIg5MOPKOO3Rv1MPN9JfMedCQqzzxPA+curYDMkl++ib0uVjLh+pNMjy7CZqpszpO6j+kFBfWXdAE0u8dVOe77o8coyOpQoYl+q1QkNr0/J8OO8SZ3nl6250UPJmsVr7iL+IItTfeNZc5rcE1X9MF3YmJXKL9yceE2X7wynoIZvBEjzRCnDjFHROAOaIE9dMk907e0+BYg7IeF9aw5ubpsrTBaO1fu5wlvolfW/aks/JvpPj4/lgIVNvzqLIr0sgMhVnCgzdHoin5iDusJUtuoNiVKj/TLyKe6PgZAbq6yka/nEbK7nD0yeP40nRQBj1v8KKktXP9
 4N8UZWCe
 j80hUCxaEGGuRUSBXcRQywoBVxz5ZxHde33FxnehqVOQteJpZtJHeP9zRfSh5Tcw9G4YkrZimd7O5d9+gzAdKITCe614O4EyUsCMCoqhh0kDfViN0LEfcFmP48fTMGmy0sLAgi2mcF0dfl0y3SBybW5GiNB8HoJoDAI3M/c3RcQswJzrVWDSqMUKPBtjApUi7ZtjShduT35SJKlMllZepGTmEstOtd/fwe0tQ4s+lyLGaCma/PqdEsRRcv2goQ7pz143QueGT2U/FCWTZpy0Jssg7seHDVRMYc+9Wl1khWjvd1I9aTSZuGPF3EOZVb4PENpI3auZrFHGP77Wr5WN0AQ+CGn9H+wSK3O/RniblAQMSO950lYVpxh6OsQrNuL7qWsREnvl02SHzpqnL7Hvw3GCcU87xDc7w0om6jiDpApJfwPCshus6gFqMl6gbd1rQewPnzb5TGxng14pWWlkv3CIvJuRyDm0FAmkj18Iv7XErTik4ZnMv99Rv2bCkhidKUPi72nFR+1febb/DQlWVZLzAjzjkxPijA9xm8sAoVe9BQbHKt+V7Aq+ZGNtc5QISjbX6Phu2MdZk4lYRKmvXKU2C4xvVqsV5ZRXHgFcX6fEWo/L64ApC5dL1OiiDLEQc0dEoHLJWR/TAAJeWEpjp3gFSwCHS5Tv14dD+NnVfPxpPSeoXrL6dKIiTZQd/fw6bX1x0FV6OvgeY+SvIzm1o0EQxnDduBGN0h6z9MkY4Mre3Vs7tp7cqjAeDMt/xK2UxZBMVJU8FRb44BbsCJIzs9VMNaOFa+WDpgW1io1ymnndKip+R4k7hn2s3dcTeB7kZQVscwkp+Z7H0V1HbDPMY4YZO0HIe70VEAE8CkjS98IoV7Rn5LpuzDLtBp6TeKwP71JjdGrM+SZCKeKvGjW64P1zOIvMMGPofAKPKv0a2moDghvbv7hX2zESj/sbI5o6bwWkovjIBiTxrFKPQ+3rDal/j4B8n
 kIHEBjyc
 /hb4987p+Nxeg+Fs1q147BpPAGB+JuTE6sy5Ms4e3UDEruFLMsOd41UGuB9kchvlQs5H2dMQVcmbbFcjiUEYglsVumtwR/kw0E/xyuzA4Z3+tWZ1+9t6OLAujgG0AEudjg4U4SNyuVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gMTEvMTEvMjYgNDo1NCBQTSwgSm9zZSBBLiBQZXJleiBkZSBBenBpbGxhZ2Egd3JvdGU6DQo+
IE9uIDExLzExLzI2IDM6MDYgUE0sIEVsaWF2IEZhcmJlciB3cm90ZToNCj4+IEEgbWVtdHlwZSB0
aGF0IG5lZWRzIHRoYXQgYml0LCB3cml0ZS10aHJvdWdoIG9yIHdyaXRlLXByb3RlY3RlZCwgbG9z
ZXMNCj4+IGl0OiB0aGUgY2FjaGUgbW9kZSBpbmRleCBvZiB0aGUgaHVnZSBlbnRyeSBkcm9wcyBm
cm9tIDQtNyB0byAwLTMsIHNvIGENCj4+IHdyaXRlLXRocm91Z2ggcmFuZ2UgaXMgbWFwcGVkIHdy
aXRlLWJhY2suDQo+IA0KPiBoZXJlIGNvbnRyYWRpY3RzIHRoZSBjb3ZlciBsZXR0ZXIsIHNob3Vs
ZG4ndCBpdCBzYXkgdGhlIHNhbWUgYXMgdGhlDQo+IGNvdmVyIGxldHRlciBzaW5jZSBpdHMgdGhl
IG9uZSByaWdodD8NCg0KVGhlIGNvdmVyIGxldHRlciBpcyB0aGUgY29ycmVjdCBvbmUsIHRoZSBj
b21taXQgbWVzc2FnZSBpcyB3cm9uZy4NCnBhdF9icF9pbml0KCkgcHV0cyBXVCBpbiBQQVQgc2xv
dCA3IGFuZCBXUCBpbiBzbG90IDUNCihhcmNoL3g4Ni9tbS9wYXQvbWVtdHlwZS5jKSwgc28gbG9z
aW5nIHRoZSBoaWdoIFBBVCBiaXQgZ2l2ZXMgNyAtPiAzLA0Kd2hpY2ggaXMgVUMsIGFuZCA1IC0+
IDEsIHdoaWNoIGlzIFdDLiBXcml0ZS1iYWNrIHdvdWxkIG5lZWQgc2xvdCA0LCB3aGljaA0Kbm90
aGluZyBhbGxvY2F0ZXMuIHYyIHNheXMgVUMgYW5kIFdDLg0KDQo+PiBGaXhlczogNjg1N2JlNWZl
Y2FlICgibW06IGludHJvZHVjZSBBUkNIX1NVUFBPUlRTX0hVR0VfUEZOTUFQIGFuZCBzcGVjaWFs
IGJpdHMgdG8gcG1kL3B1ZCIpDQo+IA0KPiBJIHRoaW5rIHRoYXQgNWNhZDQ2NWQ3ZmE2ICgibW06
IGFkZCB2bWZfaW5zZXJ0X3Bmbl9wbWQoKSIpIHdvdWxkIGZpdA0KPiBiZXR0ZXIsIElNSE8uDQoN
CkFncmVlZC4gVGhhdCBjb21taXQgYWxyZWFkeSBjYWxsZWQgdHJhY2tfcGZuX2luc2VydCgpIGFu
ZCB0aGVuIGJ1aWx0IHRoZQ0KZW50cnkgd2l0aCBwbWRfbWtodWdlKHBmbl9wbWQocGZuLCBwcm90
KSkgd2l0aG91dCBjb252ZXJ0aW5nIHRoZSBwZ3Byb3QsDQpzbyB0aGUgZGVmZWN0IHN0YXJ0cyB0
aGVyZS4gNjg1N2JlNWZlY2FlIG9ubHkgYWRkZWQgdGhlDQpBUkNIX1NVUFBPUlRTX0hVR0VfUEZO
TUFQIHBsdW1iaW5nLiB2MiB1c2VzIDVjYWQ0NjVkN2ZhNi4NCg0KLS0NClRoYW5rcywNCkVsaWF2
DQo=

