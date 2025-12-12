Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391D1D43365
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 01:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 822156B0005; Thu, 11 Dec 2025 20:59:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ABB26B0006; Thu, 11 Dec 2025 20:59:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FE516B0007; Thu, 11 Dec 2025 20:59:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42E746B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:59:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9D4014034B
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:59:01 +0000 (UTC)
X-FDA: 84209160882.01.6E734CC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8F0751C000A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:58:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nIGzO8ud;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765504738; a=rsa-sha256;
	cv=pass;
	b=7UikamEcJCcp4i/ouQlR9ltifv4HG75xdZYGdtieyMUDKzw9uOGuExw1RvYtlAfIEEAowf
	FLxdCldrxKo68qWrhuLs0mpZ2u1r0qZ/QffPlRd9Kr3+uZVcAE1TQMafQIKGbyKH/NpXc/
	Eb3eYrWxtAbnVSU/kngQ5nLQo0VZpH0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nIGzO8ud;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765504738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fS9kW1qCaFEalOohPD7CYa3dP97NCvI2OaGl9ZJQpKY=;
	b=ql6M7K9KLo52oL5piRGAUOfALgyqlP3gu2bNuHtn5UK8MUJl3/AjFAAxD7+Uk3C9FOSHbH
	rMzBdRqIzpHJTyn1Xc8h4t7h5cjvHTUG6SwTXAYMnBZETZjuWNY1L5/EackMtM83LqZpLy
	qjolbVcIUI0q1S2u1OWGJp5cK4lzsA8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765504736; x=1797040736;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3hw55Mm1ohywA7rSBr/S9j2ljhpG1RHNkbCnHN+6Uc8=;
  b=nIGzO8udlV5Cf0aS6Z+/vw/K0l0htyjtoIZs7rKlF+9InTmOtxG0APD3
   CBdZ6+itf9uYxXQrNiCus0v0XTOIxlZT01ylFFwl0L1NyfQ8hkezXOe5o
   b/CGHa48wPHutdTo5uSFjaQoQN6RMzYdyi4cPVMCjIdWnOysUcR8An6HC
   uts032pMbj2hs05rwVtZzNaFIFBar6w5EA8Sy6yGuhb/oFribTqUjLGye
   7o6U1e0oyrIVn4zT+0ooyAtheZgZjBZ0WzAh1A3xc/6rsBM8xMFyymg5y
   0ajuM123Z2dF/T+nvxtxVDb6APzUOssXR91RKVaNpW9F74dry9kuGXSq7
   A==;
X-CSE-ConnectionGUID: 6qm+a2WDSi66TUTG3Apotg==
X-CSE-MsgGUID: caat14jcTPaaEIARR/qX9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="84903910"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="84903910"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 17:58:54 -0800
X-CSE-ConnectionGUID: PWefHH5FS/ukwLv3sLwKOg==
X-CSE-MsgGUID: exUD2YWtQAi2Qrb3VXZvPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="228013896"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 17:58:55 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 17:58:55 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 17:58:55 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.28) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 17:58:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVPOgS9Bun404VdWpcCKR4N0uBlBwEM46pP6UwplSgpXZa45ufMlvhLP57CCfvIF6kzn8TccuONBUozKT3m7CzgwMMMLgL5tQuG6j2yfzKmihAhMoksJGAKQ+3Hsup0qeSxj+Q0BW0zxnNM4vKh97ua02lib0ytRwuye1n2TCmO6JiCRUaeLPQI0DCXDbdM8FXUbhvav9+ompNuXuHXtidlK1EK8NC43R/gSYK92WpWfGFhxgPYpMHJ0GsZGkCANFU31EbIj6eceRSwmostjExbSNgDUwfSbeaxS7EfAhmAKj8+ywT0ylND5sEfEfojuOuMhCemYb1sB0hfN9i59tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fS9kW1qCaFEalOohPD7CYa3dP97NCvI2OaGl9ZJQpKY=;
 b=O0KXvU/LJXFviNv2zLe9wP7MEd1AjfaqyR6SQWROfsZBQhOJvNJFPCpUX9lBzJr9mkehzGIogvpN9NRUDYy+UCHUohgEGsiv9mC3CixjPWN8S7KkY4OQvALQe3U33Y6WRGPeQ8Ca3QZKWObqEUe0ccJWgmh7x9tdbLoe4uci1V7m2dlLtOvG0d30M2hPxz+qyM8+0xt7JxBMAFNbieknV6V3ECfPHpBHPgviQgSGvOH5T1VmXqzeeTzJ7/THMikgTdBbC3I7WmUZHU12KODZ70Qxs4wsvvttrTictsR/AXmNpKNcjKrL1q/guBFgFgXN3eiyGjqpj40YSKWhj3YmyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by DS7PR11MB8806.namprd11.prod.outlook.com (2603:10b6:8:253::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 01:58:52 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 01:58:52 +0000
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
Subject: RE: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Topic: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Index: AQHcTWsygycgPn5uUUWANDAP/laxYLTxHCiAgCxKvnCAAAU8gIAADIng
Date: Fri, 12 Dec 2025 01:58:52 +0000
Message-ID: <SJ2PR11MB847266BEA195A20A095AFA73C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
 <SJ2PR11MB8472E5CE1A777C8D07E32064C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bv3uk3kj47iiesreahlvregsmn6efndok6sueq5e3kr3vub554@nnivojdofmb6>
In-Reply-To: <bv3uk3kj47iiesreahlvregsmn6efndok6sueq5e3kr3vub554@nnivojdofmb6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|DS7PR11MB8806:EE_
x-ms-office365-filtering-correlation-id: c812b036-cec6-40f2-2ab4-08de3921ffe0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?81sMNIFDprL0ua3rliDOoZdtM0wj6qMzCZQIDydtBMUz1Yd1oe3jaeWUeNLY?=
 =?us-ascii?Q?A1TQ3aW7g76nx0Sj8lLdlX1L7C0HPAvlOMiiYuKrlmizDve5Uop9RO+4akEO?=
 =?us-ascii?Q?xHAJe6GDjuHpQBn84xxDUBabgOM9z01e9tbMV2GjZrgKB9iG5vc69OyJCnNd?=
 =?us-ascii?Q?otHSIVmSXRNfceS/V2wOdRodLsRJx7ZoFRayl6YpKqm8GxZ+1dk8o0WQGnXH?=
 =?us-ascii?Q?bakZhyrzixLYY4FIfNGs8W7mhpnyWfx5Zkq2rsxF2icF8klwWMX5yc9Yudv2?=
 =?us-ascii?Q?U44aUxckZiOvk2wGd/FzeBI21IJWj+6jUw93b2wOH6OCSdqvkmqHD3sMJTfz?=
 =?us-ascii?Q?/ecG8J8CqU8oQYTtFMqc641iEQYvoJ5f87MP3FcRVsLqnbXDb64+PLWRZ/mN?=
 =?us-ascii?Q?17n+b/ZD9m5sljpgJOVYgMGCOrgPbuhwBYnjTvugZPCgsu4+WnUD1xnYGh1E?=
 =?us-ascii?Q?3i6ve5hoGjotSKYbJI3Ao+bQE7wO37JxCe+RMFhPQWc+c6PqF5/MFgIffZAk?=
 =?us-ascii?Q?1mgEV9VIDOHX8GI7srHeqhD/ekgQbPfXOkttkJrEXTMqiUesF3CWa6F7Vaw/?=
 =?us-ascii?Q?B+hDau4EhN8Wx2kE/70UR+wwHBbvq+Lar02YvscyBWPZHO+Nykzk0U0wNxgL?=
 =?us-ascii?Q?7V2uO9oF3fI7nk5ivxNzxHgRxnJy4D4rzFtKqM8w85Hwh12ZNLIfQr4VvLMK?=
 =?us-ascii?Q?pv5w9zEhukGvxOT0bPRp3bhK6omVwEJ0IunBcawaH/bVDbeFAbJDfCtiSP77?=
 =?us-ascii?Q?JrscR3woe3wP7OODN1S7G37cjspk4nnX8XLtgTyZGkInR9NgbHk+YJmZR07z?=
 =?us-ascii?Q?lC01VWArr5lX5v+nSaLkSa9UK/ZaAWa0mdDTP9VdpafgqLc/P0ynpbJ9DBjg?=
 =?us-ascii?Q?slrX1eA/npRY5M2dRWpnAfu62bf/PLqPKHcdVWlwZuVVXpAt7mEYOefUruX7?=
 =?us-ascii?Q?N/aERAlgairWnA0/kgA94t2l3OHktuKR/50TTIrhfqiWmsPysogp63Ur++iE?=
 =?us-ascii?Q?YRIZ/MUWxnbdYuJmvw15PbfVIpq53nMgxdWUKf29qa8HTt19I3nuk2zlGdFp?=
 =?us-ascii?Q?97YarA+V9xgCU4MlF80XzWU/0DMWTtNp7EUHmH2KfT1RjufXS/X0C2L89eeM?=
 =?us-ascii?Q?na23Sj+9NUufDUdP6NBRBoCll6FEkwy37ajH8fUu+NLBZgggELdqH0PjMGoy?=
 =?us-ascii?Q?sz0FzhdTql5oB7CPbCVdYsb/EgMQC6NkxcJgH0V2N8b0RLM7cxbKc9C/qr32?=
 =?us-ascii?Q?IMwZYMaEMGPgXEbehKNak4FXFw/BTVxvw2Ja265EGpEeM/gOAKxsVKpEHCK3?=
 =?us-ascii?Q?Gly+gm4NFIfZrP76JRg6QbNgC3oSIa2QLWf36IhNmFun8dG8SpM8iomQGGkO?=
 =?us-ascii?Q?7fSi4aXX08m2x66ut2DUFExVp5v5DOYh0TWxxF/qShJPcreg+Tkmlwi4RE4Y?=
 =?us-ascii?Q?ghTTxuY2wQ+POyQiIhdYX8jw/Tng8ylmR4DdTijM8Nn1H3LJDO1E/QTabqWF?=
 =?us-ascii?Q?Slu/oU0QiFQG6fkauRzDfSgXGYKoWOq0Gnmi?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?494B08lc4CdTCvXmyiCZdUV4oDbvJnMmwkLLevx9tbfwYb48xk8vUGn7Bp6Z?=
 =?us-ascii?Q?koxxUXanHtyVMVEfcRQ/OZL0QgBQJnQLbb7yfEJZVoMYgtrEVR2oU2QsbQes?=
 =?us-ascii?Q?X/TjK7qDuC4Ozvecbnvr5e2IL840p2VtQ7UBiFZYCLWHgnv6KpWyzQFX5mU2?=
 =?us-ascii?Q?XRfLZMIvhYoJH8PqeKc9ND54N1ryqfK840Oo0l120VSNak8PiL11OJG4iAES?=
 =?us-ascii?Q?llJlvJexS6YDutt2WHBpLamzHapEVVVFHo1MSP9v16xCJgzXbgYYFicOb2bj?=
 =?us-ascii?Q?9Mc5m8r8nuWECvW3c2oJIRePq56ZHKioxZmp5lSFRUeIbO2i3D7J8RNP7sQU?=
 =?us-ascii?Q?b9jA9s4Il9QvPucUM/oE5vhUJfR/ZBGLfLzUI+tzV01PBE4ZkURMgFPnuF7u?=
 =?us-ascii?Q?qQXUTKaZlnrCciXWgUlE6ZcR58RHNwdosG/am1PCADdmDhJEydjLlMM5Ncig?=
 =?us-ascii?Q?SB92dmFddJ+dMMD9/e7arV0gk3eLpdcpuAciP+lKeUViOqLicZbc5uSuTNfu?=
 =?us-ascii?Q?Bz5Ik2m4JCjgTvLbzJ9EJLZBM6A7DDv3ep5l4Ix1sd/z/YD5ajdYSZZqhp02?=
 =?us-ascii?Q?OopDuhHTGX6ysWEMIl0MlKUfKRgZA9PWaN/C6Prb/hMKZe26KTC7U6+Xs1sO?=
 =?us-ascii?Q?yPdM2lsq5hI5qQZJF1p5hRkObLdJvPWjW54+Nipx/fXdWwJEtPZjiBnEe7I3?=
 =?us-ascii?Q?mlOh8U9mhdYU1Bf9tshFJHxbPQQBXvtrrqUGGar/ZICp4SS+p9PvTQJZfg2A?=
 =?us-ascii?Q?TM7HdsdzRBPUwILzkMnwtDlOPf1Wa33GvsNoizzz80cqwqCCCs3Xa80vV9Mf?=
 =?us-ascii?Q?ZaiI1epjxxdCSqN6Dxza5lvB+JDmDyRfBbtD/Kqendgvx8OKuXhUUB+OrcAU?=
 =?us-ascii?Q?jyVnZ7xBSQW/WWfHLWgaPrSzz6A2/yGkTwD+7+UQSgBOYdE7K84GAf/DFAQ3?=
 =?us-ascii?Q?r8zW3iY9hSZGHZrXn9VmCLR0kf7X+qeg13W1sNI6G8aws0Gn8kvIrjD1hi92?=
 =?us-ascii?Q?1XicJLvOyGNpWDeZWNa0Tv+ZX/wZLOQS42V010Muy0nvPY+j1vJNwt6YODhN?=
 =?us-ascii?Q?h8duJWGQjb3PgbRw8Ep7qrlTj4AMNsPGk8U+ZzVODITXdJRjtc6S/OePOja1?=
 =?us-ascii?Q?aK6EX6TF5myisF/55RmoVL5RpW2myzJI8tJi0ND3hsWnrfAcWL+kn8DHNECW?=
 =?us-ascii?Q?dRvCG6eRGrhgmRixYnVugaDICd8FNokBxfJ9atJx77aE+yiBdQFvZD6k8EPd?=
 =?us-ascii?Q?egKVT/mQwnYKDLZGuH03teYLn1AGR0bB60YYOPG7fNeMUf45yfAWIro4uzBK?=
 =?us-ascii?Q?8tp0syo/IvV1c+UQ/sdFZ90SQE4O3+oIhpNhbLtUyB7H856nnwzB7jbAaGTg?=
 =?us-ascii?Q?4T49nmHTIxnNMJAYcjgrW6PsK1EBTWGPn/+pP57Th15azRSmnD6reew6jxIK?=
 =?us-ascii?Q?SPZYWxYVg1P/5MYr61yumMJzAZJGs0BDs8EQW3b4j0u07/ypvt2o3ShY2vTv?=
 =?us-ascii?Q?hQj6o6H/bVVi5j3cIq9pr+AB4hpTMaiNLs9xHl5bG2U9Hq0uEJm/WnIsfOGp?=
 =?us-ascii?Q?ec94W7absWaFRY9In7JTuf6g1RmhPnBNpx6zzYnCIxXKvKTaSbPMciTI/lzE?=
 =?us-ascii?Q?tJiOdO0tsf3Loiyr22bfPcaNT+hTvna9GV5V4GbuIV+rRb1r0XMHcVGKywbA?=
 =?us-ascii?Q?oVGerg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c812b036-cec6-40f2-2ab4-08de3921ffe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 01:58:52.2420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dg538vsfgjc7E8njzBIy+Yibn0Lvcgl1wDU8ZLU/RIqfIb4CJfdOrJ9kixwf/dyp+08RHso6oBQka70O80rkTKK1ttDZDzR6EIbvQYusTX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8806
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F0751C000A
X-Stat-Signature: 6aqyazwaf4mqmyczhsnbpa7dgch6k615
X-HE-Tag: 1765504737-273953
X-HE-Meta: U2FsdGVkX18M3ohuLWSbFwOriYdCdT12G/lw+sw2Bz1nfdTsMfYthizBVZNyzydU8eKx3HmuDx7JiRGfBhl2Xcb1VkHkZsS13cmssK7v1KFYs3JMgwLGvXi00f5CxA+QU/z4fQgANK756SKWcZ42LVe9wVyfbMSA8azEYe0uh9+iPnBgs4IaJYMiDGYk8GpEZUVPQ5A1dOxebEwFuibGLd6Hr2JjMOE+rhl1dOeRzWQAm00nSXhpweSBN/kdhx95+lB0mgifkv/rwDyDbQffkFnXasAVdu2bwW1nM9bwRtawfyPVqtXRF7BirpbQPyy52Ez0Hb6MbtTqv6D0lQ9x8OJLoqVngwycTK9Tu3S2tBH0GG9I4soZqlWnbWOARea1L0jEKIoQz8lmx1tnqqMGiPJ4/Xb/bdiqUZh8qCKM3AlalDG/yOJuEp/WAC8Rg8LVHQytGxkpEUTkVW6bXLBzUUQ5vfUy4/zCUn2+xnU1WB2QgzDW1PTcNeU+lQ4ZAGyonU9JqvQuBPDq9A3XO5/xC7wTUqHsoyqaL5esyouKKr45nehHAx1jUZHbPnLWEvc23Jmhiq04PQLF0K5UsghksyS9lCfFvUyV7+AaB6EqBALBvkPFCe+5sL5zqjuzInsfstaQyKXuTEdhSSduL23Yr+ETPukN8kOrcXYhhHQnn08Ury+S3/+II0UP13fi0XRjbNbAH5ovneAeOpZEYv97QskyNdvUGaslNfiJGTuhbMPWMpfgFyC46fAP+IspiFDcR3WGoOvxvxto2c/lFTBaJWPiic644GpXQDkNo9kf+J1qUEKv72CirKeBGsNESDcSZY3+R8omT7/7droQ7VZd2V2QZmaWlryF2uL1RndbS7z+MzTmep9aqWmrHLAvqIJBxSsKzGxffwInxa5oRFpPkfqrq8OelRBqIrlnpmdBVdz13G++gI9eOx9Vd2Nt7VZaNmB95tQAfcfaOWnsmv9
 jUXJvDUw
 Qzw1G7XtmDDdLXfQR1zgtPZLGu8IRGzrOaRrRGeQWayy5Y0YInicS0EgA65J2b4o7inqYjdY+sWHOZWjl+ZKphBp3MHnSffTF6k/q+1PoIcy7FJYXgAuzXNpgJS4Pp6pXgp8OTz9X0/VGp/wGoVROSM36dAhUbHERtrMa4KqN23ctTdN/lwDt47N+NtUlu/U1lfiACkDRCPJRtWcXYRf+q+3xvnkRieDsgHB5AfdAmY/tDzevB77j+c9Bk/ViqhETCDQQIa8cQYZYmQrtc+MPevUZ0IzCsCcQ4dEh5A2gpaoKonZono5PEIXZ7J/zYnRPGbOD0yw8FCqIoVok8AXEkclZw49TTnGl132hgnFeb/lcuCKTWcXTLpGEotxqmc11yUdBrQUaY81/1Q0mcCWKkIx9lB8qIw+Qe4pSIIXiZhtgiRPW4H0nKhPf3lmtajOpwBwpayKD22k6a0KuKUTkWzmBoOPRSc55S4UPPgZkQC5Cm7QNxem5oSw0BRDyN51HXMF9m9QzAwA4OErzUF97kEUoM4IhokD6mftXw43JSoAD+J+VOfAOFlNbtVFQU26C+nCK7OXN0hM7oxO2LPNTyUCyLlIAcH/PasO2kZjbMYhIWlepKTYYsYTcqTHyGL3NhnLQdGR/NmGsuPFmWY5zHgGGvKSRVmjr+xnmfkR1XL5ysT0JMKpBF0NMslIH/56SJ645sXrzMmQmizdqUPF+EZhWwKzNSbOrXwWzyMKfA1DcXGhl6Fjd/6+k+WA35LskIb/HUAFJBjofpiQM1Ci39OCV72wJo+zrolFx0miDEn0rZK6XvXIbSQocuPT9oFDfx8gZkQ228B04uLlX6i8hdQV7JKJVjMWRLHAaElihbyYidHJoHoIvczSx9Lbknc4E5/M6D87XpTKziDbrOqrBJSUTMiCpNwDwWVdZxUTD2IC4ifiCy/IMta+tFiFplE/NaSG8ZTBl2mLjYUV+4NFU8flPtfGC
 F03QxlsQ
 5MXtM+kwA2CV3GmwUolnGIQiI/MeRBQEbIqgD5s0pgyqSnrYQNLIk12/Jy4k1sm7Z3fyv/yCqyrxQodm3vnFFXUYNpYa5NOkxB73NPiPPxUmPO4kgDfEDKqNxcoxSBhn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, December 11, 2025 5:06 PM
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
> Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources
> exist from pool creation to deletion.
>=20
> On Fri, Dec 12, 2025 at 12:55:10AM +0000, Sridhar, Kanchana P wrote:
> >
> > > -----Original Message-----
> > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Sent: Thursday, November 13, 2025 12:24 PM
> > > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > hannes@cmpxchg.org; nphamcs@gmail.com;
> chengming.zhou@linux.dev;
> > > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > > <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>;
> > > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > > <vinodh.gopal@intel.com>
> > > Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx
> resources
> > > exist from pool creation to deletion.
> > >
> > > On Tue, Nov 04, 2025 at 01:12:32AM -0800, Kanchana P Sridhar wrote:
> > >
> > > The subject can be shortened to:
> > >
> > > "mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool"
> > >
> > > > This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
> > > > management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> > > > acomp_ctx's resources' (acomp, req, buffer) lifetime will also be f=
rom
> > > > pool creation to pool deletion. These resources will persist throug=
h CPU
> > > > hotplug operations instead of being destroyed/recreated. The
> > > > zswap_cpu_comp_dead() teardown callback has been deleted from the
> call
> > > > to cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a
> > > result, CPU
> > > > offline hotplug operations will be no-ops as far as the acomp_ctx
> > > > resources are concerned.
> > >
> > > Currently, per-CPU acomp_ctx are allocated on pool creation and/or CP=
U
> > > hotplug, and destroyed on pool destruction or CPU hotunplug. This
> > > complicates the lifetime management to save memory while a CPU is
> > > offlined, which is not very common.
> > >
> > > Simplify lifetime management by allocating per-CPU acomp_ctx once on
> > > pool creation (or CPU hotplug for CPUs onlined later), and keeping th=
em
> > > allocated until the pool is destroyed.
> > >
> > > >
> > > > This commit refactors the code from zswap_cpu_comp_dead() into a
> > > > new function acomp_ctx_dealloc() that is called to clean up acomp_c=
tx
> > > > resources from:
> > > >
> > > > 1) zswap_cpu_comp_prepare() when an error is encountered,
> > > > 2) zswap_pool_create() when an error is encountered, and
> > > > 3) from zswap_pool_destroy().
> > >
> > >
> > > Refactor cleanup code from zswap_cpu_comp_dead() into
> > > acomp_ctx_dealloc() to be used elsewhere.
> > >
> > > >
> > > > The main benefit of using the CPU hotplug multi state instance star=
tup
> > > > callback to allocate the acomp_ctx resources is that it prevents th=
e
> > > > cores from being offlined until the multi state instance addition c=
all
> > > > returns.
> > > >
> > > >   From Documentation/core-api/cpu_hotplug.rst:
> > > >
> > > >     "The node list add/remove operations and the callback invocatio=
ns are
> > > >      serialized against CPU hotplug operations."
> > > >
> > > > Furthermore, zswap_[de]compress() cannot contend with
> > > > zswap_cpu_comp_prepare() because:
> > > >
> > > >   - During pool creation/deletion, the pool is not in the zswap_poo=
ls
> > > >     list.
> > > >
> > > >   - During CPU hot[un]plug, the CPU is not yet online, as Yosry poi=
nted
> > > >     out. zswap_cpu_comp_prepare() will be run on a control CPU,
> > > >     since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section
> of
> > > "enum
> > > >     cpuhp_state". Thanks Yosry for sharing this observation!
> > > >
> > > >   In both these cases, any recursions into zswap reclaim from
> > > >   zswap_cpu_comp_prepare() will be handled by the old pool.
> > > >
> > > > The above two observations enable the following simplifications:
> > > >
> > > >  1) zswap_cpu_comp_prepare(): CPU cannot be offlined. Reclaim canno=
t
> > > use
> > > >     the pool. Considerations for mutex init/locking and handling
> > > >     subsequent CPU hotplug online-offline-online:
> > > >
> > > >     Should we lock the mutex of current CPU's acomp_ctx from start =
to
> > > >     end? It doesn't seem like this is required. The CPU hotplug
> > > >     operations acquire a "cpuhp_state_mutex" before proceeding, hen=
ce
> > > >     they are serialized against CPU hotplug operations.
> > > >
> > > >     If the process gets migrated while zswap_cpu_comp_prepare() is
> > > >     running, it will complete on the new CPU. In case of failures, =
we
> > > >     pass the acomp_ctx pointer obtained at the start of
> > > >     zswap_cpu_comp_prepare() to acomp_ctx_dealloc(), which again, c=
an
> > > >     only undergo migration. There appear to be no contention scenar=
ios
> > > >     that might cause inconsistent values of acomp_ctx's members. He=
nce,
> > > >     it seems there is no need for mutex_lock(&acomp_ctx->mutex) in
> > > >     zswap_cpu_comp_prepare().
> > > >
> > > >     Since the pool is not yet on zswap_pools list, we don't need to
> > > >     initialize the per-CPU acomp_ctx mutex in zswap_pool_create(). =
This
> > > >     has been restored to occur in zswap_cpu_comp_prepare().
> > > >
> > > >     zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
> > > >     valid. If so, it returns success. This should handle any CPU
> > > >     hotplug online-offline transitions after pool creation is done.
> > > >
> > > >  2) CPU offline vis-a-vis zswap ops: Let's suppose the process is
> > > >     migrated to another CPU before the current CPU is dysfunctional=
. If
> > > >     zswap_[de]compress() holds the acomp_ctx->mutex lock of the
> offlined
> > > >     CPU, that mutex will be released once it completes on the new
> > > >     CPU. Since there is no teardown callback, there is no possibili=
ty of
> > > >     UAF.
> > > >
> > > >  3) Pool creation/deletion and process migration to another CPU:
> > > >
> > > >     - During pool creation/deletion, the pool is not in the zswap_p=
ools
> > > >       list. Hence it cannot contend with zswap ops on that CPU. How=
ever,
> > > >       the process can get migrated.
> > > >
> > > >       Pool creation --> zswap_cpu_comp_prepare()
> > > >                                 --> process migrated:
> > > >                                     * CPU offline: no-op.
> > > >                                     * zswap_cpu_comp_prepare() cont=
inues
> > > >                                       to run on the new CPU to fini=
sh
> > > >                                       allocating acomp_ctx resource=
s for
> > > >                                       the offlined CPU.
> > > >
> > > >       Pool deletion --> acomp_ctx_dealloc()
> > > >                                 --> process migrated:
> > > >                                     * CPU offline: no-op.
> > > >                                     * acomp_ctx_dealloc() continues
> > > >                                       to run on the new CPU to fini=
sh
> > > >                                       de-allocating acomp_ctx resou=
rces
> > > >                                       for the offlined CPU.
> > > >
> > > >  4) Pool deletion vis-a-vis CPU onlining:
> > > >     The call to cpuhp_state_remove_instance() cannot race with
> > > >     zswap_cpu_comp_prepare() because of hotplug synchronization.
> > > >
> > > > This patch deletes acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock().
> > > > Instead, zswap_[de]compress() directly call
> > > > mutex_[un]lock(&acomp_ctx->mutex).
> > >
> > > I am not sure why all of this is needed. We should just describe why
> > > it's safe to drop holding the mutex while initializing per-CPU
> > > acomp_ctx:
> > >
> > > It is no longer possible for CPU hotplug to race against allocation o=
r
> > > usage of per-CPU acomp_ctx, as they are only allocated once before th=
e
> > > pool can be used, and remain allocated as long as the pool is used.
> > > Hence, stop holding the lock during acomp_ctx initialization, and dro=
p
> > > acomp_ctx_get_cpu_lock()//acomp_ctx_put_unlock().
> >
> > Hi Yosry,
> >
> > Thanks for these comments. IIRC, there was quite a bit of technical
> > discussion analyzing various what-ifs, that we were able to answer
> > adequately. The above is a nice summary of the outcome, however,
> > I think it would help the next time this topic is re-visited to have a =
log
> > of the "why" and how races/UAF scenarios are being considered and
> > addressed by the solution. Does this sound Ok?
>=20
> How about using the summarized version in the commit log and linking to
> the thread with the discussion?

Seems like capturing just enough detail of the threads involving the
discussions, in this commit log would be valuable. As against reading long
email threads with indentations, as the sole resource to provide context?



