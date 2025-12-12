Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B11DFD59D6F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 18:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2A6A6B0006; Fri, 12 Dec 2025 13:03:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA3A6B0007; Fri, 12 Dec 2025 13:03:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7B6C6B0008; Fri, 12 Dec 2025 13:03:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9192A6B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:03:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C93F160277
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:03:14 +0000 (UTC)
X-FDA: 84211590708.27.A8AD307
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf15.hostedemail.com (Postfix) with ESMTP id 80FD9A001B
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:03:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="T2ETkEZ/";
	spf=pass (imf15.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765562590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qjUk8joeli+U+Hf6ZydaPsUm++uKgydk6f4GgF6nkE=;
	b=ndfPpQvGuR5RUuPGC/U0sPKKQEfJprH8pANj7Nv44JXdp8bjrhB5bd0DKwK5VvnSrEc4lV
	F7PTcUXO2CiT4PdEy8i5TygnvmAg+ZFDwzPZZeivm7kPP0qdAI6pOmXzIm7icL897fIpCs
	kPEh1Pu+/DSWSR4cA4h4ERhAMHtzeEc=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="T2ETkEZ/";
	spf=pass (imf15.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765562590; a=rsa-sha256;
	cv=pass;
	b=vzi598Fin+l26hLXPKL0ke/e6+dX+nA6JjPG2BcIuz/gvJgdef4bZyhRSwZucBpvl3SnmC
	qkmJa738jnSyn7w2L2unqLX71SJk57m5PTv03Thdvx9vdmbaIxNI/mlIgoDCMxnxoPk+Rd
	Wl1PAPb/jqEX/8N2c1+dzG6wMjwf/Ao=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765562590; x=1797098590;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1R9IIjusy8Q7B+W9S12Ct1dGPZ1UQpQAlhz2YAJOldE=;
  b=T2ETkEZ/H4lB4vYKtx/VS+YgLyFhddntv6j6ZYbW3+Mu2Ly7RlNLPaEE
   qJO3kzN/2riubbxInt+/2omDjw316lXxhqEp3v2Fope98LutEdjd0b1Hj
   IfVwBfDt2bVXhZriWdyv/XjvQUhOq/AAdN49zlTdjjj8yJg1lkCnQ65do
   uZ26W2JZfpJHN7Hvtp9C8F4uKpNm6ypOu/rtkCpulFFwbKzkCBtSzd6WS
   ogfutLLZmbw2a56XZ1034DZJSHuc+rKmjuDAzyLpTcr4PPN7bvjnaTNeH
   3XHRBQifm5+vBWLPxaUzd9pK+r7hZ5rQq5s2XSXKi46L2InQXDfMtX3E7
   w==;
X-CSE-ConnectionGUID: L02+p3RASpGXcW4N81Oilw==
X-CSE-MsgGUID: 82XZn530SFGbXq2b2Na8/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11640"; a="90221775"
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="90221775"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 10:03:08 -0800
X-CSE-ConnectionGUID: EjxlTsqCSyiqRy+sJMZ7yQ==
X-CSE-MsgGUID: hd1pcm4wRfu/TnZjAeNhoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="202233365"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 10:03:08 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Dec 2025 10:03:07 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 12 Dec 2025 10:03:07 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.49) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Dec 2025 10:03:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FMO4FfOtVghAZs6NBF5l3RehzfBS6fB8TkMGbZNxtZw6IGXRAYXTXHE+eITQDVfa7KizO7U5gzw0bg+GOoSZAORyBlLPQl7t9NtHOeWaRVLm18sCQpG5PyEygX2kJEpnwF1sZkwaLKlbW1h60wXcaZjJk+LBCfceHYg+cb6lti4+tLz8YU4lC+T+1/uOaPQwSqP8GBdgM7qyNYSkaKWCpdenS6eRl+nZITGWn2YEbYWo6twWAjJ7J/I3bD3GLSrtuiSnmYgV3Bpe8BdBwxCwfmrWpW09u0/B4RTazJQx3ex3pGEnAEmlnLmNMQNXpvaPgIs/A+XZ2aRI6bathqv69w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qjUk8joeli+U+Hf6ZydaPsUm++uKgydk6f4GgF6nkE=;
 b=LA8IjMSM6t3UWuT8oNEEWS7/0YeF0XNKpz4puwBWG10b+rgJfT7Objs4MqQyKlUE/ZkC0wHU2iHto5h5Ir/S2+wKFoy1M0rRv1IpxHNGp9TXxTjxvW3/hPG52355slPhOPodNt5VWaDxXMP9ZBrNQlTNiLqlwTZzyLAVUzgDNRzLgHc93zTYdGCe5tjQ3y2einOaRwOQMyHHwfejI35pE7XzJ7taQf9cFpN1NQqJIefAJ+lQ52IVg7E8L/xmvkI/90CUsoNyurhqJbAvySGbCedZ0TwDMt0g2IWjzTI8OYBlGXHAEA83z6fX0ptg5FSvEfEBjpdqFdhSLxO3XmL/0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by SJ0PR11MB4911.namprd11.prod.outlook.com (2603:10b6:a03:2ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.12; Fri, 12 Dec
 2025 18:03:03 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 18:03:03 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
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
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Topic: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Index: AQHcTWsxfEPA0eGp6kWYA/H17miOhLTxI7AAgCxKBKCAADpygIAA3mcA
Date: Fri, 12 Dec 2025 18:03:03 +0000
Message-ID: <SJ2PR11MB84728FA0B92A86B7D1C92AD8C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-22-kanchana.p.sridhar@intel.com>
 <3i4jpzank53niagxzddc3vmzi5s3o5kmernzitktyavd5jwvp5@ytxzww57ux7a>
 <SJ2PR11MB8472875DB2900920EB2C51DCC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <okfbc6hqk63qn4bxcryhmfmtjnzzaswtk2emev7lpjr5flrwiu@3g2o7geu5zgm>
In-Reply-To: <okfbc6hqk63qn4bxcryhmfmtjnzzaswtk2emev7lpjr5flrwiu@3g2o7geu5zgm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|SJ0PR11MB4911:EE_
x-ms-office365-filtering-correlation-id: 3ba2b43c-6728-49b5-4b04-08de39a8b204
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?moYEczGGmvwaaakKkQlHzkRKEH8Kb+ivbTNel348BVi5v5h9zgD4OdWzE26l?=
 =?us-ascii?Q?n+a/H5nWTU4Ll+nxZt2VKtqXJ5vVaYrSdt665vQVC73jwcPertKVzla1+vhO?=
 =?us-ascii?Q?In3D2+RPZumafzjVLdi0CXSVkdRVsnnK0c3IDlZgJuD/i/A4XaJEUVNhDWTz?=
 =?us-ascii?Q?SsdIGUhdYQAlH54n5p/2ykJO5NRCTcDUnR8sP+BiO29MW7FdYsPB0sjRzpLd?=
 =?us-ascii?Q?+mHdHF+FLtifS/SoxP4B07fFAasb5B1jRo98PRZbcfw7ij+4ssgc9i5K703V?=
 =?us-ascii?Q?ay2x1CPK5tKryToGS83+av0WGTteXcH4zpwKSjddHFG1+rUbQQxmnvSnbG0B?=
 =?us-ascii?Q?5D99c/TuDEhPOQfkQhXRsHrwqLz0vkT+/a/N5jbOhaIz6aP5K/Ug0Sskbk6/?=
 =?us-ascii?Q?zYgdafIRpHTwP0ZLjj2Ud7ceCIbH3yvj/P0ipM5lsQIq0jqO9eSXQ9Wi9Kd6?=
 =?us-ascii?Q?MWjEkPhcyVwjHuZX35b/RbprktdLQRcls/JVOz03L7Cr8rTNTLSDjIHkZ5JY?=
 =?us-ascii?Q?WeKJiL3nUrRWSi7TZrgg6/2LYIpPGdMijatuI28+yoCpVqjJRT7QjdZFvHuS?=
 =?us-ascii?Q?Oo69dQM+BZcI1xLLIYNhC6LaF1+iw3EOu20DQjd8/bYUoYsuG/PfnZHfkxTV?=
 =?us-ascii?Q?y/uyAhAEz4bB4WNo9oRh3+gBrMa59u9Xl9DYmB8vQtFAFJA1ZMGgfnkc4NGA?=
 =?us-ascii?Q?CKIzjTcUPmXubQnnkuJUV6Fm1kf0vhyFnymMILwvIfu019/Z0hKjlv08+mO7?=
 =?us-ascii?Q?h8OkvsPaEAwU50LpXQS6djGv98u9/U1bTO6466sOtIbCrURgmRCVwmv6WeHe?=
 =?us-ascii?Q?eNa0yDhGxW91hweTsoPVfsJ2CKYthyxdqvbeq6NsSURrFCiN74bC3x9GDfrU?=
 =?us-ascii?Q?qnyDPjq2xy916mFvNVrJPd29mWyN5GvprQiOWIMt6rBA7MUPUtBXP0NJmKrM?=
 =?us-ascii?Q?5n69wBO9PT/9MQjL9vm5hV4k7BeTzioEQD9i4y/mWGC6aPUdfimERmzTTLH+?=
 =?us-ascii?Q?XKBWERXohVyYkPSMj3wZH3RxcNARJS5PcHiEWiiNR/Ea0LVBx2QzeApedpI0?=
 =?us-ascii?Q?w156G8FfMknZaBIbUsbTOnRy9P4IyncAMpCGfzgmhnvFNlAN6kW0AwLGPwA8?=
 =?us-ascii?Q?iPU2DCq6XAyVc5MWgQ8Pvb7+f/+awB2tWFT4pK+VLWxOYLBGeup/oFZ4TzrM?=
 =?us-ascii?Q?BczqWuOtWb32S7eGH1CLXTND+iVVmQhmH7NapgkAlVcF26uDf2nHMTQe3Qgx?=
 =?us-ascii?Q?H+skpXFNo6IHE5XXOYHyCPKcDRxlsDEMFgtKI2irkIw6kBjZgJxoAT9H/sob?=
 =?us-ascii?Q?CluQNHVifCLwGoOyWQQfwlHl1tVG53SDawflabPzwA6sFRmgC26ab3PTsXVW?=
 =?us-ascii?Q?IyhTijScn5/fQz8e1NX5qLh1VvmM992WYxS7zYzYuWovufKr8A8GlYQcYZaB?=
 =?us-ascii?Q?Zh+zdB4lQk/XGvcnDqcdkrR0loRxFPM3EuVDRE1Gd4pVDNmifaIF/YhtHL3h?=
 =?us-ascii?Q?7E5FCufP/htASy1b7N/UR03LRZhy4VMTCCp2?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WK/j/CP6HIliCki8EgQcXI98ZDvkeKz0xyy8lhA0jPiboCl1mbIMM3T74AkW?=
 =?us-ascii?Q?bPrD3V2q0LgoG7T46StugwKmp0BA30Gg+BWyCn6296j1LLtp8FE5RZbh4q4N?=
 =?us-ascii?Q?mVvrFZcx+VYSqhocTUAdrQlhhXCJsaVvV3W8AXolfjIXvkmDQEPbk9xhnEdV?=
 =?us-ascii?Q?/67yROrSGgQKf22iSc07DRq0Hud5yF9lLofOFv49cmBw22xUgFuZShz4T//R?=
 =?us-ascii?Q?pclIRA/WnU04dK3TMZk8CUrl2EK8NkmDVU089wAbJKRp+rlYfgYtoRrNXSnR?=
 =?us-ascii?Q?r5GxTf+q7o5Fd4cZnxzB/EWLBkAwivPTD5fQGkdjli69ZoPy37qHb6VsnT6I?=
 =?us-ascii?Q?uMud9AIAWYH8FredCPjCf7eT1F5fr1fPuxACVegMxg9J8UA/XDNCtzB4++/a?=
 =?us-ascii?Q?Yhv4LYjrfAzfWIvSwiojdLcvsXWWVWu6QPJ+B/UJjSRKUZLnWksTl78UXHW4?=
 =?us-ascii?Q?IVI4X+V9dtR+SAZztf3WV0yZ58uzO01sQCqNG2yA0ILkXC3/InLh0CK/yjYs?=
 =?us-ascii?Q?hLJ8rc7+hqJEH8c9mnYbMuF+rOabCSWmZwNBAnnKg0Pkdie8BPTS7Mgw4Wxk?=
 =?us-ascii?Q?RKfyqZokeT8yqWouLc3d4cxQUVgFmtxY5avVDow+Daqe131u78HfAG5pNqkK?=
 =?us-ascii?Q?q3KXMbFrq+uCHNc4RPEfoJhQKeBuhP3bFsKZYDX2sRrs6oOHlqe/4nziGrAX?=
 =?us-ascii?Q?ptaPbiFiAFu02pAT9ztftqzjeO2qZIuvCu718c6HCsLwd7rtAjCRkIG98fWZ?=
 =?us-ascii?Q?yrc3VrgoMrqG9rC4QuoMV+se0vgnqpgjLnRCa6hBeGBymJ/+XFrLTN3Mio3p?=
 =?us-ascii?Q?sSVS8pQWX+GEPv6oIBCqjjmj/oAgWobaSAdhdH8vvIBXrKsTR68OFGu93KrE?=
 =?us-ascii?Q?K9CmhRMUNmCmYSs6giixiyVf9yilDlcmsz0NCg52U6zNpIzBZrY5Z40iPlxq?=
 =?us-ascii?Q?4rXw0R7IHJ54bEvUPadLkP6oGT81/IBPBGb/rjn1PmdsrZk/UxvQa017QZLt?=
 =?us-ascii?Q?um1+m15QGJ+SrcZXEJG02ei+3KxhK7prff/5rdmOMxbVmQImapmmIL8cQxni?=
 =?us-ascii?Q?fb/egxXJ6H89J14MtFonF9VGglmQvNQCZRNV9+NjfjCtUpPOWnoyo5rdiTos?=
 =?us-ascii?Q?kj6bz25djjcLxsulU8H8RFCIqsquBgRpnhM2VPJHw6rRpeU6pHeYTFm4WUNf?=
 =?us-ascii?Q?H4Vd0NH0N71zRrMVEG/Z1ayM49mO/xQ5SPPnQMMhW9i5Mmy40sB8kdl8PHNo?=
 =?us-ascii?Q?vS0aoeEtkKWDuyxAp9shaRdrv2JjJ4B4MeD83PDA7h6vTNtjdoLeswBow/f9?=
 =?us-ascii?Q?9t4c6d7TOQVzGeePyeoqgFLHu0tX7eYA5ivxQBbByiU+fbZpdPNT7o/pnYWy?=
 =?us-ascii?Q?9B+I3L30FhpvmGtV4C5fszJLXxKotqT0DMrzOk0ecUTf3+nW7UqP2Bqig5un?=
 =?us-ascii?Q?WCPKV8USOx5MgnxPU7GHZ2aIFWTj05t+QMBNBjanpiA7xwWVLTEETUKoWFqe?=
 =?us-ascii?Q?7afscshvspS1jS1sZvrBbhco2VIR/cxWb4z2+DEirpNgD9EPmvTVW5frYDt0?=
 =?us-ascii?Q?YTL/5ZgJ8Ei5OGK3hF7fY12CncTIVudDSqZjLj7wqj5mbDj5GkliGcCUm5Hq?=
 =?us-ascii?Q?VrX1p+cQdrTItsm49JUlHgcJer2F2jRM10km+79nT800Zr9rsTwZnm8BiOKm?=
 =?us-ascii?Q?OGK5bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba2b43c-6728-49b5-4b04-08de39a8b204
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 18:03:03.6954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dERzU1StpJnj5XygeaD2ytvZR2VlhggvslJ9QhkXeV+mey+MpTtTCJB2e61w2sakXDHj0nQgT15iQK0zeTt/F/hckC6JJR/ssU9g0OwFBeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4911
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam02
X-Stat-Signature: itjw3unayoa4ke46zswzg8qchkzyombg
X-Rspam-User: 
X-Rspamd-Queue-Id: 80FD9A001B
X-HE-Tag: 1765562589-844247
X-HE-Meta: U2FsdGVkX1+uuG1DpRWkXIGKhhvFGvKJzguvVdEW1wIts65745Szz1jNVXTAN9WOC6zn047lqcsA2BUM7i0FRDaBvaZ1m6WNKfRytMcp0/Z1TH2caJFyGAG5GN7D5wfRvxmBlGxvG72u2t5BjjSUAi3ieGdPbW0+5zMIyvZO2QXlsjgMZDhBKAOhjYAdiK6lcRABxziSvdbRDI1FWgYopm1n8VPXX958VWxGjGoe7eIZycULQyGG9jZgyXRtgntNDd9e89msHyqP2QrRE8xReScI6nRnu/+HIzyv2e/ziNkX7/ERjEWhjgsLhONXpvnBSS9H5qJBAQUBJgBAQOqbG2pxLRnC+fEcbJ2F/1sqX0Xct4kUbTnsvistf0egQywYV+C8brBd1agkzXKhxqrSHSLMLFbkt6fI1kFrCORs+Cxyo4LMuvi86Mu5Kz9t71gO5ibL0XrpOWdGG/YcU3lM4iJZRcmJWI8KLnGMbPur+zUtm+c51UQhFvpYz+1s4ckhiliXQTjY2XRW0GsNxB/e+LS1nJoctORVsAu0hZcBNawViPwsivt1vqXaHU5eucIa+F75YxmNXrFyDmIk76UYL0xThS0VlJltaFotPWrTOM9Bs/eo3masj2/AQRGlDaX/T92BCGlqe3t2nBbSpDXYjoorNymJczynyLpJVI/bBmN9M4ytOlyFc92hOD5X/cj9/JGYPKxi9XrSaPzjFZAoW5B2k4sRvuD/exgNXW0EL2VxUnuiEN/mzjocxIDgsBMd99LNY9Y8v99aYoRbNCnL6CdnKQk6RbrHS2lN4XZdkq8pII4GGWRYttQUt0nhPY/v6lSRulKlSgxRl8E6FeMTXm9+kArb2tEt3CmHvIVsMDfN4b3nNHxw9u6U5eEIjLufWM8mTXRH4g2xzhUWTCe4tJS6YDkJnVRPeJk0yGu9XEKoTzo/6nJajv+IUhNmbrcNX1KhBmi7yedV1h+s/94
 zfiVOr36
 rXHjJg6P1/Yd3nqXbAgfrjTPC+Fz8eXrQ60WIeATOxgGJlO6FkvWPdN2s04f2um8NFxM6CXYJdgSltyNf565EXRxe9YYFumeW0xgcA+F0tuDAqufhF/wktzEPIbWwi6dqXv9xrQgfgoLVKRCaPlWNMgdYNlKz9AFgpyDN/yhX7wy6SBwrnv/1wkAnPk2rq8UuNnh9rUaYQ3756Q9VMtVLq/XefPeRR2NB/guTs8GSZGX8cdca+fPeaoM02HQlQqM4IdzzhfopisZaXbSvPeIQD5WU3KVKn1C0wwE4gtP2XV2s9YOEtWJ4jx77RHLu2i1+uNcqSsmAZGNcQGb6SbTYj9RxKihoYTkmE0qO4e6eo2v3CHyC2XnWxoXk/djgwzxqAj+NdwvOHaQSnmjo5uFBPmRzCARHh4OozbZ71h0reI+eU0l0YV760v/zUPy0xhDbux2yZQEIQeN5Jo0WcdlEtb4IHp0SxVT9+6mh/W+6Yehp8+zKaUnwRrK7S/UJB5b6RAU1pH8Icu3a/GXZpIcZKu/V6n0uTp2oy3RtJ+NE9yytEMiEj8RfnD5Pw+mCBw9VjOUMSfZlJNQ06VurCNBHPTHa4TgehvN6neGlFG2Bzq+80p7ZX5rZohA17skyoxsEBJC+LzbboZBPwllKjrJqlKZQnmtBZyJADr2PyFPeDLvnSbO7yIeGjY8hMUZAOmoET+bJkF3tHgDlrDZdA6ipfgKSVewFZPW06/6vvGpJ9mOdxPAP+agSwCtAFVKRfCYTu2LD1aRX8YAxr5zv/Xwo2RtcDepU8MsH/c2rV6yPvLk6XqOU6rGzM9EoVVFqe97dpcMWWIbmgNyKYWQba0/qOwo/y47K9IwvksFGERV/UO7wN4zc5mePUDUhxXmrWCk2XRr/GdlblXQtqOUVmDEFMWfPOFTeuwz+vBs4cczGKgHOG3iKyrdDolHC0LjFidCbmfmyZ9WijNZyoHOje7mUPv2kX4+P
 2Ed+LN53
 VxuEtGOr9jMQkjbF0+LVt7hVGUHgj4SnkfWUqtN1FKt946NpPoMNXD+jPinfii6UBVaNsoh4H4hYefomX/fySpwPOltKdBNHPsxieY6+BlPbshc4tvO3+FIoJ/HQUe0u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, December 11, 2025 8:41 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 21/22] mm: zswap: zswap_store() will process a
> large folio in batches.
>=20
> On Fri, Dec 12, 2025 at 01:43:54AM +0000, Sridhar, Kanchana P wrote:
> [..]
> > >
> > > Instead of this:
> > >
> > > > +/*
> > > > + * Returns 0 if kmem_cache_alloc_bulk() failed and a positive numb=
er
> > > otherwise.
> > > > + * The code for __kmem_cache_alloc_bulk() indicates that this posi=
tive
> > > number
> > > > + * will be the @size requested, i.e., @nr_entries.
> > > > + */
> > > > +static __always_inline int zswap_entries_cache_alloc_batch(void
> > > **entries,
> > > > +							   unsigned int
> > > nr_entries,
> > > > +							   gfp_t gfp)
> > > > +{
> > > > +	int nr_alloc =3D kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
> > > > +					     nr_entries, entries);
> > > > +
> > >
> > > Add this here:
> > > 	/*
> > > 	 * kmem_cache_alloc_bulk() should return nr_entries on success
> > > 	 * and 0 on failure.
> > > 	 */
> > >
> >
> > Sure.
> >
> > > > +	WARN_ON(!nr_alloc || (nr_alloc !=3D nr_entries));
> > >
> > > WARN_ON_ONCE() is sufficient, and why do we WARN if
> > > kmem_cache_alloc_bulk() fails? I thought that was expected in some
> > > cases.
> >
> > I can change this to a WARN_ON_ONCE(). The code for
> kmem_cache_alloc_bulk()
> > makes sure that either all entries are allocated, or none are allocated
> > (partial allocations are freed and 0 returned in case of the latter). I=
t can be
> expected
> > to fail based on this.
>=20
> Right, I mean specifically the !nr_alloc case. This should be expected,
> so we should not WARN in this case, right? IIUC, we should do:
>=20
> 	WARN_ON_ONCE(nr_alloc && nr_alloc !=3D nr_entries)

Sure, I could add this, but it would be for potential future changes in
kmem_cache_alloc_bulk() since at present, if a non-0 nr_alloc is returned,
it is the nr_entries.

>=20
> >
> > I believe there was an earlier comment for which I added the WARN_ON? I
> can
> > either change this to WARN_ON_ONCE() or drop the WARN_ON_ONCE(),
> since
> > we anyway have a fallback mechanism.
> >
> > >
> > > > +
> > > > +	return nr_alloc;
> > > > +}
> > > > +
> > >
> [..]
> > > > +static bool zswap_store_pages(struct folio *folio,
> > > > +			      long start,
> > > > +			      long end,
> > > > +			      struct obj_cgroup *objcg,
> > > > +			      struct zswap_pool *pool,
> > > > +			      int nid,
> > > > +			      bool wb_enabled)
> > > >  {
> > > > -	swp_entry_t page_swpentry =3D page_swap_entry(page);
> > > > -	struct zswap_entry *entry, *old;
> > > > -
> > > > -	/* allocate entry */
> > > > -	entry =3D zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> > > > -	if (!entry) {
> > > > -		zswap_reject_kmemcache_fail++;
> > > > -		return false;
> > > > +	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> > > > +	u8 i, store_fail_idx =3D 0, nr_pages =3D end - start;
> > > > +
> > > > +	VM_WARN_ON_ONCE(nr_pages > ZSWAP_MAX_BATCH_SIZE);
> > > > +
> > > > +	if (unlikely(!zswap_entries_cache_alloc_batch((void **)&entries[0=
],
> > >
> > > Is this equivalent to just passing in 'entries'?
> >
> > It is, however, I wanted to keep this equivalent to the failure case ca=
ll to
> > zswap_entries_cache_free_batch(), that passes in the address of the
> > batch index that failed xarray store.
>=20
> I understand, but I think it's clearer to pass 'entries'. Also, can we
> make zswap_entries_cache_alloc_batch() take in the proper type and avoid
> the cast at the callsites?

Sure.

>=20
> >
> > >
> > > > +						      nr_pages, GFP_KERNEL)))
> > > {
> > > > +		for (i =3D 0; i < nr_pages; ++i) {
> > > > +			entries[i] =3D zswap_entry_cache_alloc(GFP_KERNEL,
> > > nid);
> > > > +
> > > > +			if (unlikely(!entries[i])) {
> > > > +				zswap_reject_kmemcache_fail++;
> > > > +				/*
> > > > +				 * While handling this error, we only need to
> > > > +				 * call zswap_entries_cache_free_batch() for
> > > > +				 * entries[0 .. @i-1].
> > > > +				 */
> > > > +				nr_pages =3D i;
> > > > +				goto store_pages_failed;
> > > > +			}
> > > > +		}
> > >
> > >
> > > Maybe move the fallback loop into zswap_entries_cache_alloc_batch()?
> >
> > I could, however, I would need to modify the API to return the error in=
dex
> "i",
> > so that the "goto store_pages_failed" works. Imo, inlining this makes t=
he
> error
> > handling more apparent, but let me know.
>=20
> Hmm yeah. Maybe make zswap_entries_cache_alloc_batch() free the already
> allocated entries on failure? Then if zswap_entries_cache_alloc_batch()
> fails we exit without goto store_pages_failed. This is the first failure
> mode so we don't need any further cleanup anyway.

Sure, this can be done.

Thanks,
Kanchana

