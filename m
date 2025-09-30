Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68EB8CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 21:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8774D8E0005; Tue, 30 Sep 2025 17:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 828978E0002; Tue, 30 Sep 2025 17:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8E28E0005; Tue, 30 Sep 2025 17:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6438E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 17:56:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6EF3114080F
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:56:45 +0000 (UTC)
X-FDA: 83947276770.27.732C3A3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf27.hostedemail.com (Postfix) with ESMTP id B71D34000C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:56:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OEojJq0n;
	spf=pass (imf27.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759269402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EirQLQX2fMyHpwVo5HCP5F8xTR+t4UEdNpY2JmTy4s8=;
	b=vTV4nPEYYXK/jMKReGF5S13M4zMlgZyXIvjMyOsLj6rp8DCiXXtXTyQ0IqeKuMK7nryJsW
	0xPMkhgJAPWi6DDyAujvUsjRZY30VYw805uRbVYQ/079dzp2On2jvBxk9B/fnfRiWmrXM5
	z1BWFyyMuHCCH+qDVm/sfj90QDaNwJ0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OEojJq0n;
	spf=pass (imf27.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759269402; a=rsa-sha256;
	cv=pass;
	b=i6jmFJkY2S1FW/H6OKDwcK1GenzKwxMYfW/1sQjoEwMss/iR1XJac7XYxIRgMvLL2FzQG+
	xd0NwlWNo4RPBXZ9Jk0sBkC6r3f0k4OVMHAFGXYScbyveiDDTBB1eruaStN8gVf8G35O4B
	NXZel4gBy+Ya5K2w1/I4ArnOxuisq14=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759269401; x=1790805401;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/+proPD6EabriQrBPRmv8ne6HQ0nLBfFjjkrL/CqQxY=;
  b=OEojJq0nKIDBCHz2clXFsvX7IosQbjy8D8zxISxJ29FxPyyU9GeMaBuK
   cEcpTsfhGwQdaexUTZEBidEHnDL1BQmlob55aSTl7ei/2X3ZRTBbVNaRs
   3DM3wcD2NkEZFcEgkW5halmt7juyqLeYLhz7W+hF69kv2/mVCa2TY1miY
   MPRzdZ7LiPAQSIJEJ+4/QUOGI8KrQsVb8Ln+eucKooFxobnUjXASAdeO4
   IcA4CISmJicEEhqYtwYIiwYjES/dpaJnkMEeJ68i3qkWurouF/9FOzYRK
   IEDQWjjajb2Ts4s7on7ob9bljF55i4Dyy3AV2DgjGfmrJ4vVTCVJ6oGBO
   A==;
X-CSE-ConnectionGUID: PNm7DPSsQY2Rhv8UORWoew==
X-CSE-MsgGUID: wg+NsK6hR+m0j6TpRjXMNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61704142"
X-IronPort-AV: E=Sophos;i="6.18,305,1751266800"; 
   d="scan'208";a="61704142"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 14:56:39 -0700
X-CSE-ConnectionGUID: y+465KVMSw2uIfvlpXRqqQ==
X-CSE-MsgGUID: lC0GzjlUQ8qDITAB7EVWwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,305,1751266800"; 
   d="scan'208";a="183824729"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 14:56:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 14:56:38 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 14:56:38 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.9) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 14:56:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N3mVk0QsT8/ay/Umrh9ZW6B671FCYSS8+mMUs80SEReMMHCZ0InrWwryMfpI7oUW4UN+KIN5X61jz1FFIJiza1r+GPlCT8TRoO5uEGqHW3IiLj83/W6JgX3iNjKD6voSzVIoh/3ycvMQFPuQ8bnRi3ttIFYkzgeijlUvvyKG1hlhNZ7fB/qsTyFtBrwCBwXa1YZ78NimjgpYdUUrC60n5/B7XiKxq3JxJifttYj7IYlcoRLvHG4TEPhzWC98zGRryrasdTUlSqbgwNgediOqQpp7fs/j37SVF1JrEl9Bxs9Mq2+ehbP4PUrG3ghqQ2ZAVeZxXMFhZDqT2MCp+DktYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EirQLQX2fMyHpwVo5HCP5F8xTR+t4UEdNpY2JmTy4s8=;
 b=KQM4PkzU4yV7JdgwvK3KpSckXEj34SHi7xOJD7xLaCx9k6qT8Lnp/Brkhnt95ECpAdvVeOdi6sjcBCIdn/Z9+5uWXtoG4d//A3BJYzQsUojEN+90KoSJAr7Ob3VP042oQtJWBHGY/xwk4BuEO4NQ5p38vhcmvarUBlW8CR1bzse44rdqpGg/K4eMB87smMffNdMJ04iyqyWz4kqgTnX/RKDx7iR8MiVE/D8E22hY327ba54DY8YPuhJ/M54IgkkGcNXNW+R8YmbMUNKMofOPc2OBxnr5ewTH9DklKiII5xpQzWn/wzfF/5fuu9/jZ+2uZKRq0aGUYlPlClktorIOQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by PH3PPFF8C186950.namprd11.prod.outlook.com (2603:10b6:518:1::d62) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Tue, 30 Sep
 2025 21:56:33 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%4]) with mapi id 15.20.9160.014; Tue, 30 Sep 2025
 21:56:33 +0000
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
Subject: RE: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Topic: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Index: AQHcLpaVftDjct+5Jkq/fUkbn0Rx3bSr5mcAgAAXwZCAABUagIAAJKswgAAK3QCAAAiGUA==
Date: Tue, 30 Sep 2025 21:56:33 +0000
Message-ID: <SA3PR11MB8120D4BDA8A6980A4BC5447FC91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-21-kanchana.p.sridhar@intel.com>
 <j4o53f24yeegzrj7aj2mbu5c2xyqksnb6uz2fjkwgi3dbbtqsw@cwatjnrsgbco>
 <SA3PR11MB81201CE73D6CCF274BB2265FC91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
 <7gnj6tcuvqg7vxqu4otqznvtdhus3agtxkorwy3nm2zobkd7vn@hqanfuyklt7u>
 <SA3PR11MB81209CF02417CED3C0459504C91AA@SA3PR11MB8120.namprd11.prod.outlook.com>
 <6xb7feds424kfld4udwmbtccftwnnx6vmbpvmjcwlionfdlmuj@vz4uzh6tog5g>
In-Reply-To: <6xb7feds424kfld4udwmbtccftwnnx6vmbpvmjcwlionfdlmuj@vz4uzh6tog5g>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|PH3PPFF8C186950:EE_
x-ms-office365-filtering-correlation-id: 09c4a26d-d9ac-442d-8477-08de006c3879
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?WmVLdPkYtj7S2qnqwVQVFci6fBl8bZy0VoXoG9+hZ8EIXitpk4Iz2PaKN2wR?=
 =?us-ascii?Q?D88zcMBtZYVDzfMsh+Nti5bkEQUAoQ08oKBcrKCeZR6VYFJmslTFt5PX8Ov5?=
 =?us-ascii?Q?xoXwOaS6NUrMD3f2vmC0ybh6Mzv7l0fLCnT0eqPPD5gZToOFVkdRgM/GfasF?=
 =?us-ascii?Q?AAf2AbNl6AU+vGNvq2GxR39FymYJc7f5qQt5c4G+ikxXneEwhYhJ/4lCWgaV?=
 =?us-ascii?Q?1fvu5rRc+EZR8KJ3ptinq+fD3EfUxIP3mjVdqXp99wznKfuo7za5I1mMmaSF?=
 =?us-ascii?Q?Q7CL55w2rEPoFotzaiY7/5MQyg4YG+th7sCVqvg7rgNiggIXPMk4lTtY6ZD/?=
 =?us-ascii?Q?rxBdonf9Z2e8ApBR/myMecLcfup3Bzpfm7ar9Lsd0Skg7xIMcibtEDtTJVgG?=
 =?us-ascii?Q?c/KPKce/JywvWn3hF6h1mtN4pCTDbxkU2vkXH0+nu04/9UVydEJlQb3bmKNP?=
 =?us-ascii?Q?wL+elWyQhHNUDC8xW7xGsODixv/RVIWNNldLXJTYZJ83djTs3D87wRyjp2M2?=
 =?us-ascii?Q?nPloEL+INE4Mi41IiK7Nte1cyBxAwP3GTYCfj63NIqxdQBt64UuiPjXnBiFy?=
 =?us-ascii?Q?p5tcilbwyOvrJZ+zBSo3N/SxnvKjdgM9OlFb7dKbafJmS7wrnSEfuqt6amdj?=
 =?us-ascii?Q?5YIEBCEZsWHxjUy0iBgyCfVy8pF5ZKLCG+CrZz1Bm02XM9FNpxPApIThqs3r?=
 =?us-ascii?Q?xPz6PL8eAGrw+N38EBTU/s7AAOMW4bMokVuvIecuYs4ANLO1gucnA1bz9gBb?=
 =?us-ascii?Q?nXdfWQ85hFH//HrugLE+TSmReUEZduaO8CqlKk9MLGZtSchzE5VoFxXLwpmo?=
 =?us-ascii?Q?MA4RMw7U3T39PtbEhKyzU+GUom1CqBTey0v4Rz84FMObxUR83obRBsqbPYzb?=
 =?us-ascii?Q?/I8wuPf8MdtK/BWbgeIX6zR62++86RMjpJvb/1dUWHh0+vALVY3dGvBWB+wr?=
 =?us-ascii?Q?qE08QbpSwRHiv14TMuhLlC26Wg9aGj5+uO+k4DCrUOxRChS8yUYRyq/0ilfz?=
 =?us-ascii?Q?n5vUhBLOKzj6WseWeW/3jZFzg8yj/RUlWwUgxVhfc9jc+iJPHyn17R8mvPHX?=
 =?us-ascii?Q?tblzsIFsXfKhcQbmUkjtpXFDkIr3i1p6/+AkeIo5Hq6cnLkG+ciXs1dCMC/z?=
 =?us-ascii?Q?9Ufhuiz+dHed1bfPfqMWOIwDW7S4Eyz17/dJRz9pXUhj2des+8PNjfev1Sh0?=
 =?us-ascii?Q?PCm69msc9PR9u1Yjnw886GqdT92nU+ACkfe+tcIWqQXxowMe5oRWVMgZPgY1?=
 =?us-ascii?Q?W/WwjWyE+zkSFeGCZ1C6SBKDee0UeUTsec+i0PqC1nUTTj2X5KaNkxtK+vLG?=
 =?us-ascii?Q?dhizHDLnKoud97l3OhKV8LJD/ar7AkgtbxkT0rVrBTrHnC4J99oc3S9f+U0K?=
 =?us-ascii?Q?4/DIxG/qxpXRLB6zexQplrTQyEizNFGxxgVUV2KtaJpEIZSukpW94eJwl+Qe?=
 =?us-ascii?Q?UxR+pYOs3TMiEnyh2QN2jFxs9vLZkj0oa1F8ZOy5dYoiA+m4BjXdVeWiQe0n?=
 =?us-ascii?Q?hO9zJu9msPk01nBvVOKKMV1bSxFmOW02Xuqq?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H+kJnarzwP2JDFZJWzP0hruy3TuPBHD0nDSAEbDmmOTApHmilT1TO0R9JOyf?=
 =?us-ascii?Q?+FOj3Z7gkYllJcAYm1U/3z5H4FDCSjO+/syg+L459Eoq5mCYZtOuIjmJqUO3?=
 =?us-ascii?Q?FYZOwLyXGIv+6NCX14IYPaXzbz0EwhfxJeg0UOKw/2vFytGIgltG5XSQMP6v?=
 =?us-ascii?Q?b1+TneDrErs7wfqMQFZK2xyQnI/9Ru4R9/G8Newxoy1j19QEaKANMh7Ru7Vs?=
 =?us-ascii?Q?azUsv+jhYmjiDB9jPdEvVbvQv/Uka2EieBXl1vrNUhsne77oRVOWAaDLSvE1?=
 =?us-ascii?Q?ZI+NRU7+VBMyhX89lAlpQUnbtR06qU7+kdAMjHPJLo0I6mFWvDraOrerk03c?=
 =?us-ascii?Q?JPBbixjKAWKa+bNB666o3o+0++0o+bwXhEwp3QBLD9pg4SB8PyB8mhiVOZS2?=
 =?us-ascii?Q?oiqFj8uv9tU/3+I3KoWFZihrstMOBiDsGRg77HsMfkqf9AjAajUtdeNtCZSN?=
 =?us-ascii?Q?zO+RaeBonNdd8WnlVs+Gm8L1ZqfXDYavInuvu93Jd/SGWIOwQNCLw6A9b0sM?=
 =?us-ascii?Q?OhcZaYSCdLWpOUvGaJp/QJRPwp4iyG5dhz8v48Gy/QhLhpwvZDqDqTeC9DkQ?=
 =?us-ascii?Q?B8CTXu9iwxw4sB9VKd8XQqaBbUPdDzOfRw4d1D4KbdKEswHStjyqCCXLRn2W?=
 =?us-ascii?Q?P3sqA4rctvkJscohKIv+fgDG13uq0anhpUe2S6kEe5yEY7KJgc67IJFVVpeV?=
 =?us-ascii?Q?L19fcF7pGrz61Ka7SWSN/yxjzGnN5bVyBZ7pysCUAzDEpKo43We/zCDCY3Y0?=
 =?us-ascii?Q?lNbk1XJY8hq5CoYaA3yh30gmDqC6UeVspRlOkWEiNhZOIyU+qBjuf19LU/QR?=
 =?us-ascii?Q?IOAHbwipPDoOfkTEXbogqBUhA8Sc53QMVUSW8jRizX6xff4FH+AQTXPmUh+B?=
 =?us-ascii?Q?yD9eJRqV9qGngUB1wOG85xb6RjoBbqxuEJoZANN4frWBBCOKRDW3Nfy2j3JK?=
 =?us-ascii?Q?e8xcg7qYjXGMKAKNmrFp/ZetNzy25Rdw3uTnYysxMCOhkFqkOLMJ3+20b6h8?=
 =?us-ascii?Q?vHia4EtwXxYgoObaArifi1MvaKJNHY04x8fsE/D+dEZQnN6bQ7WudqZu9eGN?=
 =?us-ascii?Q?NhjLng7WITL2NJM0lBPLzu/qR7jkaozTRS+OB4XbfjX+BXaxh6BUmiuEouGF?=
 =?us-ascii?Q?eq7NZHsIrXuvQnYQR1yqqo9Ilhnbr/uxPhcyNv0eHbiJ9evDGfM0wsWHcGyn?=
 =?us-ascii?Q?MufCvnb3UdiE8T/ffVgBOODyH73dQwtwHo+C6YVHBYwQxnf1DXAmAKnx2BHo?=
 =?us-ascii?Q?b/irheww0HDAN6ty4REc6fUhKFZt/4QB0silzQpejkTEbV6YaQYklhiiZB/P?=
 =?us-ascii?Q?Y8NyXbxB+IvBpMUk7dO51nTCPIE6n6i3DDbCKEK0FNbQmiPPf+LpvwxdgPn1?=
 =?us-ascii?Q?9TPgLJVI5d+U8ia/6PZEjbL6hxaYDzfVdR2sq+bITJpCn0mkgi+Bf79LuW5H?=
 =?us-ascii?Q?CdKpwOZqeRmdi6EfEESaZL+pOz8eiompv/X/7c62IKhApTeGUFv4i4GJdV+a?=
 =?us-ascii?Q?ZzedfKeSAM1vbmmHFAKB9ivNJ2v091DXsdGb/Ktnj5v206YJSg4tDWxz6X6b?=
 =?us-ascii?Q?yRwL+isZQ0oYyAfdsI9+0jsUKPTuDiglYXkGjU/LbwCjE5S2gDo6JnaiqIHk?=
 =?us-ascii?Q?gA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8120.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09c4a26d-d9ac-442d-8477-08de006c3879
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 21:56:33.6640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7OwzBPFp1FAABTfczKO67SdLBHGHN3EJ0wEW6aq6ljgbY1Qy1x1Y04oglpnK/1/fAmcghKQ+3yGiHOyiE/vBYJxOKXiWcFOiPYQC3gv0yeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFF8C186950
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B71D34000C
X-Stat-Signature: 4pe66bnikg58fqo6ug13t95pjawqaixh
X-HE-Tag: 1759269400-316984
X-HE-Meta: U2FsdGVkX18HWtPEoBKFMm+Hr8owxqjA//V4d4QH7m/719AnQ216yxZGwPtnNUgruk0j6NedxW2FfYObSvfk73BfcB9KBAUvQvzSUX4xOwr5b5ytRReg3fg09h0PqIz6xlPE5akhyE0CV7sYfo12s+SSUM3JzkQkAAqfDI1wOS1Cg5ymcZ+mipdzUVhuGdWxoU5KTISS8dTpLJCYneYOxFONxEaRBhMDIsZNoXod3jL7384blhB4IgSL6KgHb/weN1cbAwLHgIDJtm/MlMfXJxWFhXuFaIvnRd/Qf9sX3EjUkMcFPOBjF76jCMva/rPlx6cXehsWqG4V7qAGNFQC3QZc7jQybezlsfnMl3g6yfHrjpPj5lmoY0mUiHdEn06EntvfqCI7OuPnCyGpdJ545QKMrRu0QOcCDyJulb5yGk/Lj1PxIPDGltWbjDFz65fQ9rtE1D+l/rI+rhzzM0kIc+GLhtiNfb1FvoDcqcjCo3skTPQdiVaKv6Gtfpk6l7s1Bu4/ZB/mzYNp8TZtqCWSZi3Yaqk3yrL/AvSqNjG6jDGUHLOPUEZ/IYoWxLrRT7JUmjKGB41CVPvIjCksw2D3T2UGpVyFX5oFl/bsZQCx1F7WgLOAO4hHfo591H5TiQQqME7zTRTFlC5tVqE57Sb85GgBf4l+v5MHl+H3Mgftd+SvKHp0Fnm2H7f4MvWrpSmKncxoZQvY7ZuHxz7w/okMa7LrUY/5b1axguIaK9jd7SAnLvil3bgtDLX4cGCXKBnlK9tXtdUJm0Dsp4paz0uVGRVfAHOAc3qv/OdrhceQ4v2m2xFNmMtIr+9XWj7q1E7TThKbo0nXCdmMgcnc3Bp/ckg9oRCq0aQsiX5YModcxcUtOy2SZaTvHAXRh4S7xyRyTzHQLx2scmQBuq6LS/8bNI05AhAiWgw/sgs07ryV4g8Qohz8ARI9Q+Ak7eqAGBBZt1HxHaTK4fp/c9BywD0
 HO6IVdR8
 FHwKx3GyQD0wYjKpJJBOqMFaX7Sqs3zHd3QtZmi5SwRALclXcAZOcVNWGatNBCmYdPDtJVH49GMnQYvS02D7v09NHCTDqp9b2Oi0SrxBmT2hZMf9sHer4nvSFa6X09tsbeLoVBe02Mk4FsGzhgSnvV23NAswckiHHDzDN+7bJ5qhClTzLlB7PpuQUZQwj7BAFvSb9OhSCI2lzYXy5lmVT/o4sTdk53OdyDr9YTk9ycabElQzwV9bOZM3JL0uXvQXvJuabgv5XaX4q4h4xyvxjaBl1ffOi0M7+SHaJoub/pM3Pj2Pdbnjc6v2AiKTH9p7aGokknqGZkXVeeUoS9QxlGoySOJKWdd4PgvTEik4UUJNt32z9EjzBwlAnX7UTpjC8Fbbx/DgRsCVCeYyqNGPPR9osiJhmXo8mE/10pErRkxCgtgZCjSzF2P4X7QqC8SD4viojUBHDpvGo+y+LneA76RNy4pLlS6DnImJr+pKMuKl+nUpM9mOZgKXI8Gy3NWT7cVr+cxrSSV9CUroJy5qu0LfUH1QXTRDxCbfhAy/wpKURYMsze8iZ3QsOdS4S4ZrS++wBXRhATCLZGNdJQPii17Aum4hbo2EO9A7qn+HNt+Z+lv1B9oqYEPjQKRnWv7yC7yIiqcJxZBWwUTTFaWMmTHTCvQ8DACJJ9PRswlzLmstaL5/BzyablRdSRX0ehca943lBr3tAFiWNrSucP9IG2zgygBacRFAy5BuJVs42bgx7dVkcmi7QvXPzDJ7tmeOypqErwK7wMlYR3RGUr43OAw8ptGd1oKd0lfPC0okxt6Fhrc4oyMtTodS4mt51sZltTDMgRzRgdTh6JUdP/zq8AN31LzCKiklZXE5fi6RUW/qsTZEkai1GcQdfsrDQ/H81U94dD+5EYyEi3BsHqEmavVw2TF24dRv3smS2cYk56yRuop3MfmLUSHqCeiyJlQ8V/XOJvahHgYZuYD4IXWpYlBAchvaB
 svu4Mx9N
 CE41f2xLWGnJ425R0aJ6XeoecAiAyYRS56WrfgB89fn8OZp+hfNfiTrwtBeYGg/ZtTVwgSW7+tyDwGiOw67c9p3JrJKRf37D2A6FwLCk/z2HGfrOJaXVe3zK4f53sNAUPjb2r/9Q9Z7EiOj5LZw2rx7NC9tkVVCmtqoSSyAaMQDtQjsQFGIf39bckgwvRpPgGC+QkVmr2WduG9mtyzIiGV0EjD+HIDXX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Tuesday, September 30, 2025 2:20 PM
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
> Subject: Re: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources
> exist from pool creation to deletion.
>=20
> > > > > >  static struct zswap_pool *zswap_pool_create(char *compressor)
> > > > > >  {
> > > > > >  	struct zswap_pool *pool;
> > > > > > @@ -263,19 +287,43 @@ static struct zswap_pool
> > > > > *zswap_pool_create(char *compressor)
> > > > > >
> > > > > >  	strscpy(pool->tfm_name, compressor, sizeof(pool-
> >tfm_name));
> > > > > >
> > > > > > -	pool->acomp_ctx =3D alloc_percpu(*pool->acomp_ctx);
> > > > > > +	/* Many things rely on the zero-initialization. */
> > > > > > +	pool->acomp_ctx =3D alloc_percpu_gfp(*pool->acomp_ctx,
> > > > > > +					   GFP_KERNEL |
> __GFP_ZERO);
> > > > > >  	if (!pool->acomp_ctx) {
> > > > > >  		pr_err("percpu alloc failed\n");
> > > > > >  		goto error;
> > > > > >  	}
> > > > > >
> > > > > > -	for_each_possible_cpu(cpu)
> > > > > > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)-
> >mutex);
> > > > > > -
> > > > > > +	/*
> > > > > > +	 * This is serialized against CPU hotplug operations. Hence,
> cores
> > > > > > +	 * cannot be offlined until this finishes.
> > > > > > +	 * In case of errors, we need to goto "ref_fail" instead of
> "error"
> > > > > > +	 * because there is no teardown callback registered anymore,
> for
> > > > > > +	 * cpuhp_state_add_instance() to de-allocate resources as it
> rolls
> > > > > back
> > > > > > +	 * state on cores before the CPU on which error was
> encountered.
> > > > > > +	 */
> > > > > >  	ret =3D
> > > > > cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > > >  				       &pool->node);
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * We only needed the multi state instance add operation to
> invoke
> > > > > the
> > > > > > +	 * startup callback for all cores without cores getting offli=
ned.
> Since
> > > > > > +	 * the acomp_ctx resources will now only be de-allocated
> when the
> > > > > pool
> > > > > > +	 * is destroyed, we can safely remove the multi state
> instance. This
> > > > > > +	 * minimizes (but does not eliminate) the possibility of
> > > > > > +	 * zswap_cpu_comp_prepare() being invoked again due to a
> CPU
> > > > > > +	 * offline-online transition. Removing the instance also
> prevents race
> > > > > > +	 * conditions between CPU onlining after initial pool creatio=
n,
> and
> > > > > > +	 * acomp_ctx_dealloc() freeing the acomp_ctx resources.
> > > > > > +	 * Note that we delete the instance before checking the error
> status
> > > > > of
> > > > > > +	 * the node list add operation because we want the instance
> removal
> > > > > even
> > > > > > +	 * in case of errors in the former.
> > > > > > +	 */
> > > > > > +
> 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> > > > > &pool->node);
> > > > > > +
> > > > >
> > > > > I don't understand what's wrong with the current flow? We call
> > > > > cpuhp_state_remove_instance() in pool deletion before freeing up =
the
> > > > > per-CPU resources. Why is this not enough?
> > > >
> > > > This is because with the changes proposed in this commit, the multi
> state
> > > > add instance is used during pool creation as a way to create acomp_=
ctx
> > > > resources correctly with just the offline/online state transitions
> guaranteed
> > > > by CPU hotplug, without needing additional mutex locking as in the
> > > mainline.
> > > > In other words, the consistency wrt safely creating/deleting acomp_=
ctx
> > > > resources with the changes being proposed is accomplished by the
> hotplug
> > > > state transitions guarantee. Stated differently, the hotplug framew=
ork
> > > > helps enforce the new design during pool creation without relying o=
n the
> > > > mutex and subsequent simplifications during zswap_[de]compress()
> > > > proposed in this commit.
> > > >
> > > > Once this is done, deleting the CPU hotplug state seems cleaner, an=
d
> > > reflects
> > > > the change in policy of the resources' lifetime. It also prevents r=
ace
> > > conditions
> > > > between zswap_cpu_comp_prepare() and acomp_ctx_dealloc() called
> from
> > > > zswap_pool_destroy().
> > >
> > > How is a race with zswap_cpu_comp_prepare() possible if we call
> > > cpuhp_state_remove_instance() before acomp_ctx_dealloc() in the pool
> > > deletion path?
> >
> > Good point. I agree, calling cpuhp_state_remove_instance() before
> > acomp_ctx_dealloc() will not cause a race. However, if we consider the
> > time from pool creation to deletion: if there is an online-offline-onli=
ne
> > transition, can zswap_cpu_comp_prepare() race with the call to
> > cpuhp_state_remove_instance()? If so, wouldn't this cause unpredictable
> > behavior?
>=20
> How will this race happen?
>=20
> cpuhp_state_remove_instance() is called while a pool is being destroyed,
> while zswap_cpu_comp_prepare() while the pool is being created or during
> CPU onlining.
>=20
> The former cannot race, and the latter should be synchronized by hotplug
> code.
>=20
> >
> > I agree, this can occur even with the code in this commit, but there is
> > less risk of things going wrong because we remove the CPU hotplug
> > instance before the pool is added to zswap_pools.
> >
> > Further, removing the CPU hotplug instance directly codifies the
> > intent of this commit, i.e., to use this as a facilitator and manage me=
mory
> > allotted to acomp_ctx, but not to manage those resources' lifetime
> > thereafter.
> >
> > Do you see any advantage of keeping the call to
> cpuhp_state_remove_instance()
> > occur before acomp_ctx_dealloc() in zswap_pool_destroy()? Please let me
> know
> > if I am missing something.
>=20
> What about more CPUs going online? Without the hotplug instance we don't
> get per-CPU resources for those. We are not using the hotplug mechanism
> just to facilitate per-CPU resource allocation, we use it to
> automatically allocate resources for newly onlined CPUs without having
> to preallocate for all possible CPUs.

This is an excellent point! It makes sense, I will move the call to
cpuhp_state_remove_instance() to be before the call to
acomp_ctx_dealloc() in zswap_pool_destroy(). Thanks for catching this.

>=20
> Also, this makes the code more difficult to reason about, and is an
> unncessary change from the current behavior.

Ok.

>=20
> The only change needed is to drop the teardown callback and do the
> freeing in the pool destruction path instead.

Just to summarize: besides moving the call to cpuhp_state_remove_instance()
to zswap_pool_destroy() and more concise comments/commit logs, are there
other changes to be made in patch 20?

Thanks,
Kanchana

