Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB05CD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 07:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9E86B0092; Sat, 23 May 2026 03:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37ABA6B0095; Sat, 23 May 2026 03:52:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC436B0096; Sat, 23 May 2026 03:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A60716B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 03:52:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9BBBAC2723
	for <linux-mm@kvack.org>; Sat, 23 May 2026 07:52:10 +0000 (UTC)
X-FDA: 84797916420.25.D29F6FB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf30.hostedemail.com (Postfix) with ESMTP id 92DCF80007
	for <linux-mm@kvack.org>; Sat, 23 May 2026 07:52:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aG7IH4bk;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779522726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lq3SWfd6calQNpeaL08NgjTh3+lRMGOlxr58R584cEk=;
	b=SEDp9ydMu5SoMCFjpy17YsAL1yIF7v1lJGXSvU2SlkEE2Z+tah3C9RF2qkNmCn11lwqCul
	3JSE+83BOO3umxZwOGstwOXzpD8z6PMtZculf3SKFp5By3E3+QaCVANWy5q4eaHP1nJQ38
	IXtS8VIUovrFX2vulUDwYmTwn4SWK98=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aG7IH4bk;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779522726; a=rsa-sha256;
	cv=fail;
	b=NLJ7fOwhAiWx8ht08HTVKWQGudP9W0L0+LlscLFAVsk89snGxinP7Kb0v5Wa1yHbsFDUVt
	FaVx6QMQZc5VVZ7s8zGVAc3uA54a+4NsZ2iFS+NfOx7EmiMghafB4EkVByLlJZWT4HDsx1
	1FaZKfS6I/mDqHtNj36+K9dXEbt9f50=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779522725; x=1811058725;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=btXIB2KYyjkZgAvzvIZEen6VudRYrzpROE0GoVo1XeE=;
  b=aG7IH4bkrc0KTFH19boySsHRDZUnnPzVal/EQweVXQBiU2JwfTOShI0B
   /fI1CHFW9WMP1tDoCfq/m0Ici9GVZraTiWwPASa1BgeeIXBopdgIFlZAl
   V6N+dQGHvlbeRT/a9LhTeXbTk5AAetP7NCkWhtrT3rv60DqKxP4Q7Q1kn
   wgHsMew5RoZEIHbVxwHQHXPJqPVJhCFmiuNRLCK77IxHOaEjtqnTgATS4
   KngI7gkrHIxzLvphhNwL+7VUO4MVChIo8jcj5F2Cj0/bgLLew3c9uLcIk
   uiIOwAfZfMY+dU88F1P1nCXp/yE5XdQFlFjLuunDPoKqk48/fPEmjaICY
   Q==;
X-CSE-ConnectionGUID: WiRulDkLRZOz/23Um5npsQ==
X-CSE-MsgGUID: nHEt/oPPQlGP4lhhHhUW1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11794"; a="105901591"
X-IronPort-AV: E=Sophos;i="6.24,163,1774335600"; 
   d="scan'208";a="105901591"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2026 00:51:59 -0700
X-CSE-ConnectionGUID: hLxGHubdQ+ShdJfAqHOGEg==
X-CSE-MsgGUID: InN8gRlEQGyZIRIG+DLzfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,163,1774335600"; 
   d="scan'208";a="245403752"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2026 00:51:59 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sat, 23 May 2026 00:51:58 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sat, 23 May 2026 00:51:58 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.31) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sat, 23 May 2026 00:51:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ltfBr40dmbOzeaVc7j1HVVpP9ucL6ortvfulhAuVv/LAU5L9pGgomay8L0We/bsaA5TBe8YIK9ZfZtU+F6yzj4B8OxDrpEXVExO3QMDT8uvgFu8umklfJ13K1nTrwHNToC8fjh4x/tbCfQp/uNN9BzlSvwoCY9xcFlP0XDIBLKDmiwR3d2zX01/AAfyT1GJsRRCsuaJ2WZq/5T6z7Bp3MdBnjArXVZ62Vp0WVO46yJv7TkDHL5EcwDQBxDw9UUiI6Xjo7q57UEjsXOGfn5BOscDmeOtj21a3y3kwcywixEbVwcmWYryUReTBo5hLkGnui7sI3MBJ8KC52cD8wR5VKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWD7UUpf2euocAQnSnaB5lAkMKLB7vcTRPftvMlng90=;
 b=U+aBq5YkYrkJtWtTMMvv2hw+A+JIk/KjLnikO5BwAZdlgz4x4AB9MarVDYGzaLaWA2U+Touudm0Fm2JZQTMxzSCHFVYU2BBOy7XrWOv5d/faxRlEXHDlcxEmuCqf539/X0c0OKc0/J2LUyvLnuwytuZ4+erCIQNtGg3ZGfEoSL5+v4C0a1+ja4fvsrSSrEuj1vjybcKeMImMQWY0or/h4zHcixtoevoDa4PW3iRktaZBUzdI2AcsSAOnMWW6u/358286NfNfVVH5h/P/4LHPXJMZYQ3sxKWluuwBiDlQJgPGg1I1kwGjOFGymYadsF3zEn1dRzBe10eg/Skj+FbPBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by PH8PR11MB6681.namprd11.prod.outlook.com (2603:10b6:510:1c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Sat, 23 May
 2026 07:51:45 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.21.0048.016; Sat, 23 May 2026
 07:51:45 +0000
Date: Sat, 23 May 2026 15:51:36 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: "Liam R. Howlett" <liam@infradead.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>, Geert Uytterhoeven
	<geert@linux-m68k.org>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Matthew Wilcox <willy@infradead.org>, SeongJae Park <sj@kernel.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Suren Baghdasaryan
	<surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	<maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: Re: [linus:master] [maple_tree]  280b792cac:
 will-it-scale.per_process_ops 6.0% regression
Message-ID: <ahFciGk6LfkOU2en@xsang-OptiPlex-9020>
References: <202605131554.92e7df6b-lkp@intel.com>
 <22y6gvr7yzwdocwpd3wxrxfykmpvhbxytiiuht32db3dh7w522@pglkrpqognjk>
 <agV3Q2fBlQrB5v9w@xsang-OptiPlex-9020>
 <g7pvhqnuloifqhbvjgtgydbitcrvmxibferexj7cunsmagttps@oxjvs3aa3l3s>
Content-Type: multipart/mixed; boundary="xUBdbXTpns5/xJ1f"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <g7pvhqnuloifqhbvjgtgydbitcrvmxibferexj7cunsmagttps@oxjvs3aa3l3s>
X-ClientProxiedBy: TPYP295CA0010.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:9::19) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|PH8PR11MB6681:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b22e99b-d9c5-416d-4f52-08deb8a02286
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|6049299003|366016|7416014|376014|4053099003|18002099003|22082099003|56012099003|4143699003|11063799006|5023799004|3023799007|6133799003;
X-Microsoft-Antispam-Message-Info: tjpmKrEva/F/TyumZZAAl8mF/nH7sZSHTXSsOdDGJQmKO+4aSCDRZViWODmNNwU2J+qOJle2+7m0qscpK/ssN/lyTSVWTxwKtgV8Dy4Oy62i0s3dcPMc4Y6MDs5VEeUe95Tu7ArQY9iE2df0S1exhjgFeaDbJjUyE8qKrqJm7Wkgt0H/fuNf5H1/VCFP5aUjv8RCvjzPtYy6BmLrq8s5WqWCcWsbb/OnRP/hYVWkVcvgFNNFF8se6N3a9bfPQQ4ulJR7/cXcNP72lgDciZLUfU4liWna1RfPywRwQ+/7bZDWnH9QXsXqI26c7ZMnjay1roiWqqbcGhYSrx5CNSft5WBYaJrF4tlZym0MaYrPS28WUg0ABH8a8+/e9Sgi0CaxQwsN2fhnkDt0PNQVfDhnHIKzIR8kiMJtaZcS13f/ajF90+y2mF488BsjxDxEwV8pkfKzjHF4bHW+fz/LISltq98e+ziSpeINirqAitw0FjtbfGkzTiXs7dVrAdYW8GkVEO2wFhco5VB3Hek/HfhwVdEg1n4k8r+OFRFLD3Ikt/ipysQ8DPTWaoHKD+AEYHFbZhgmpYusw0i4VGg5koZgjGbPIRnaL2VjJnhi0jj+P87zanXAPqP5ifn+f5rqnazthWfdhbqjSERRHZ37Sij/Sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(6049299003)(366016)(7416014)(376014)(4053099003)(18002099003)(22082099003)(56012099003)(4143699003)(11063799006)(5023799004)(3023799007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?8Sea+gmtJ2MMmPO4iB3eMyxohPt5kuvZ5CVHg7aw2vlZYHX/j2oFNR+6EU?=
 =?iso-8859-1?Q?jnyYnE1Og4DrBCbZjnAWU/81i/qrIU+et2yQ9P6wFrAq4u2zDpug00PEwZ?=
 =?iso-8859-1?Q?gQt3UAukmlZbLYoNI/80VyySgNYQx+Wo1TOwOczOz30nYuqwrzNBF3sNJd?=
 =?iso-8859-1?Q?2S4lzxlIySRYp5KUkFFE/ryYmlBoEeZokOv4pIWHatXGBrnKtoWRJjRLwf?=
 =?iso-8859-1?Q?WmLwli5s+hOowTqz219jT0lzwv8UhytDCMY1xhIzx3gxiZegBgZSHGDWxZ?=
 =?iso-8859-1?Q?PDSaliK9/EEzXObAnHwGU+JlkEdnLfAK/y0j7ICSKoUpfl3eznO5iHbSXy?=
 =?iso-8859-1?Q?WfwxWUEGdnUEgJlaebIw66oWzxp4NB38C0fWzq0lPlJOT+wEdZGXoZhxOK?=
 =?iso-8859-1?Q?uISX4wklgZ7IjL2HCkvIKmkEzs08vWPoFQXwsVPjCy82MdGvOjRVVMjxBS?=
 =?iso-8859-1?Q?zqXS0DBOOGGRsoYW0+i8uvydyq0QRy6InYv2VzLDoWTgGmkdB2+UdHPa23?=
 =?iso-8859-1?Q?sTCJLiw25VS5KN4/Wu0Y4aOImuIdCuGW++pp0EF8cJJV9ydecOL9JhFmK/?=
 =?iso-8859-1?Q?WGlR675PZZ54qJi5S2VlJMu9nrzaPAZQ8NKKdUnDFi172yIyZOpF0kz/Wp?=
 =?iso-8859-1?Q?xCA2Y38ET/1hQHb4BOzi3Wmp5LseBiU24gWKu4+FiBeluF01pFf3N9CHhp?=
 =?iso-8859-1?Q?KXEkxE42DPYI/cM7RMTJ3LTXAJ0XHDOiWtVGOTQ+PJEEst/Yc47bgEEAeG?=
 =?iso-8859-1?Q?ZiMbtJLHFizSqRaI55VBdk99gRIbA6VdxuAe21Bk9p6TUA4eoFvuVTmstm?=
 =?iso-8859-1?Q?1328BnJeb76bypCuZrhNsG81IU6hmJfJ9w1YI7eLKM57uocBUmRJXOn15z?=
 =?iso-8859-1?Q?ZkyN8s74fpYfDEBhR3aPYh13hMYSgkqtwVLXDfzUbQiHEzKWqAyWviWt2q?=
 =?iso-8859-1?Q?MqryAkhJ/8VVuHIAls855g0JkS9JSd/Dao7S4m/ny7w4Sl2uRHBY/S3WF+?=
 =?iso-8859-1?Q?dl9JliCwHQc54aiJLSM5knO644Pdt1eKIQ6eVNTxcMFI75SannL4gx/2HE?=
 =?iso-8859-1?Q?MElzno868t1AmpLH8YtPfj34CfggK1Pk0cyhnxy6ATPXxkpkFvs+rSXywo?=
 =?iso-8859-1?Q?+H/mxrFPJgnZr74TdT6I7VCnVRT+2tcYN07G7wuy+Be2ISYcZl2aSnRmxj?=
 =?iso-8859-1?Q?HiUwt9hYkE3fdlk3dQ5x+oVQ7KRQ1iYwTaPY5nZ/WuQnYtnexrgUWo9lOm?=
 =?iso-8859-1?Q?5l7ZUiYb8rXLsQ/Ryjie1QI3IS6Btjt9+bGaceKbOc/Rum/RnEioORVryW?=
 =?iso-8859-1?Q?9UFNgSwNmxnJmRcodzf1i5stVZyMqNEY6m2qduTkmq5svdBU3pNPtNZlII?=
 =?iso-8859-1?Q?sTDuemJq9JP/FoYd2RQYtOFCBzJYhnvr+8klDZjpuRwYl4/68NecN06WFI?=
 =?iso-8859-1?Q?vkqGy1SNGuTfOI2sL4Mr76FEZOYELaVVrAgTqv4F6sRX6US/aVEnXYp2oe?=
 =?iso-8859-1?Q?vd5+u/xXtXHWFXvGN7aHkFoc7rpsCYVqiqauIxi0vNU9EUjatr2zil/GuJ?=
 =?iso-8859-1?Q?I0W5VUn/afLyEGQ8ogieetKW7Yl5hkMN2D7Ej7qjtIOgvmBvDnOrgbH5td?=
 =?iso-8859-1?Q?+K8gV0h83Jgd64ZknIQBmefjsEdSZ7LBN+EXjtzZVTRl6tHY2BfO1nnNjO?=
 =?iso-8859-1?Q?Et8JPghPQXZGAIYt7alxT9ZX3QPWfgY+MeF3b57hpD8Rt52xXmbWXqh2pO?=
 =?iso-8859-1?Q?pToRGX6QH4WwYn2djQKxniLz8jiII1JVgdq3xgHczq2gpV2B/mbGIrbIGD?=
 =?iso-8859-1?Q?NuwmWbsvUA=3D=3D?=
X-Exchange-RoutingPolicyChecked: a7mElwX6HpUz82tOTvMGyL/WirOr8+hW/1oSLr5LCadmKE8F6qRjrQlEg9iiygq5PLDl25CELQhN1nf6zHa0Hk5Hn3/dssN3zunOf5oAA5k/gdcobDrrJQ8R4cN+aNRsQxYlyilvHUgrCbvbTNj+kz6IKFytf1OvXmtRyFBYqztQkIyKqNudkGG458cV0wfnRdOEmuE3J0RhbnbP+YpQyDtvk1Rh7Dlj2aqxJum+y1Xe54mTGClq3qJUuUy7jtYtTVop+P6Tn6L5lXJggjCgIiNUGh8eayz5zltaOPi7vdD81aRqU2sdd9eyGJojNN4PoSntmedtxkY1zJqws5uiHg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b22e99b-d9c5-416d-4f52-08deb8a02286
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2026 07:51:45.4920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZHIY5yKEInayePOh+k4icEP+cRbw9MOVtC/jV232ECr2bvHWRJuD2lF6FLEKSgwq8jeOfgYSicn/8sxnRc3Tqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6681
X-OriginatorOrg: intel.com
X-Stat-Signature: rfczab1xk4jqawi6bj34euafijad1469
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 92DCF80007
X-HE-Tag: 1779522725-624103
X-HE-Meta: U2FsdGVkX1+Ua/GVMdrImB3KQ8ypgCY50t8W8P6+2M6KSbpFiXSOM5hgUl7MhlFv8bQHpiEPFkI/PelB88oeNcXQ37M7cpH4W2EpC7SyPigEh6vFHeUBcgshfJx7EpYayGIR/dCBZnd8/KW1E+k619XzRK26cWCat+UaWh5Ulfk92AifeCb8boN8mjUH3JB+dvpRVSr7b8buL3p/jyshz31FBl5mWOqWMcJLJI9NzsvFa+Nh8LxJyYDqaSsg3cv8iM8mlOmhYY+x2wEO2tNxS9fsEHPerZv573LUYJ3n4uUT659w0sw+7rF7enY+u4NLccEUL0oEjDlu4GDOHzOUWn62I2IgMwPcceOOKicgHC297Ooh/JSuHmY2YbdLX3XcZrPflLR82uJpJVzySFlnYKwn4SQ1JxsPrQbWwDz/Ly+cD6A30tAOPanmp7BF+uGmblVCbWGhX5/05gKs4YtJ2w3Lt0uB5XYMjMDlTiaBO0x2RtfA/VnxctRyVV8hP3aBjgeMLxRrUKc4PgBKwUle7/39Lldz5ZPHtbdfGvH+eHZvi/HNkW5Zmh8w4Bk3JEGHXzv7MAKH2LKPtlMNj/rN0jTn37/wjixyEbevxJG+zT6Axc8g97UBHg+htBa063ZUGx4mf9GOnM8/3qCtM5sFkWJ4zZ0R8+GZx0fNspRNLLT0CrODvPk17lLCgRehS0vLdwyxDPXyX6ARn20Ai6Y6Y5ArUza42CrhiSOfZEfSJ3suQxMJRkuCbWWjcHi57/9ggCXTRuZYdyAtgNg1Ywi3SoTP7kogCMAJM3HuF6gcaYO3uAHbm4dC2UrTXm+g1IbQq0oH9frrha0J3UgkyiJGRWxeYXIlkewvty/jq2NxDnbzOxHKyvMsCoMKVK1obkTaAdDJPO9Pdk0LLs13hh2dTFZKhC978anE/vCdDR3UN/9w1dOa0SCh8EvqdVBsn1o8zKNYkTxOrgWglC7KJvN
 W+ymjj5A
 Jx/xleF9Pv8ks2xz4qzCBAvTK95Zkcyt/1vpEvrBOXidCGCIkDHkIw5ztSRQvpt0J5mz86BQWeM6LnD6ZSmIlJVPfiYSBg2/mvaIqur1QVjH7QCxAUvq6pPvS5YKFuBJQt9RMpRZ/nK2iXmJq81y1YryUNbSGV5UorqIRTlAEWcLyAiflfem9GPMBEgFo9PK3at5GHB5lIvlDn/7SHp0gdrYw263gZ1I5XxEyyh3/5U2aV+EQ24bXg/Svnf7g/af419zg7DuSYcp51UrSFg8KstqItznqD5yL0PM1qR/y86vhppMAvDx2FptH1Z3Xn6UIuKB6Qok0MdMZSlLoNZmvwPnYIgZ87J9rQfjIQ/25yrIrqDxRhtKpAfgnygTh4vr3hGQnNkFhHRuPIVZMW1i0SS4t8LhS9ZfKn0VlaLMTG0klgQf4V/Z7BDYWe3rPPHz8wRR1w8yTmgX8+2CAFkN8UuFohFl5EWlz42vgy3QsW3nfEr1wIlpVSRL3kAKSzI6QOnrqcKF4n61CnFz5gcmVDhEqlkvyfyG17PoFltU829ykSQ7hay46y1lUFvi3SXaR3blCEJ4c1pJRUw+5NNNEe4FO+/5WfjTEDLIEEBw06Rg81vMBDI5TNYjg5qzmI7F0m0daTYMVBxNQjLynQ/Jrt3vrQbcgc/BijQEguM1aLrtHb0WfluW7pGv725/ooMvvkKXzMh4qMjI4QfT60qX1D01rbP95iTf+wXKIcpqiKcCPcsdMd9OhsQOBlsVB4vdW7IkxNVJ7jpE4vDQ3lEseplrFIEF0kBWLahmiDym1Uc26to0q2fj7e4ZY4xDmQQZWcp1FLW25alMwIRo+gbFChzzQNPP6nJnWU6tK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--xUBdbXTpns5/xJ1f
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

hi, Liam,

On Thu, May 21, 2026 at 11:45:05AM -0400, Liam R. Howlett wrote:
> On 26/05/14 03:18PM, Oliver Sang wrote:
> > hi, Liam,
> > 
> > On Wed, May 13, 2026 at 08:16:42PM -0400, Liam R. Howlett wrote:
> > > On 26/05/13 03:40PM, kernel test robot wrote:
> > > > 
> > > > 
> > > > Hello,
> > > > 
> > > > kernel test robot noticed a 6.0% regression of will-it-scale.per_process_ops on:
> > > > 
> > > > 
> > > > commit: 280b792cac62ddadca2935766ca870b438c86323 ("maple_tree: use maple copy node for mas_wr_split()")
> > > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > > 
> > > > [still regression on linus/master      5d6919055dec134de3c40167a490f33c74c12581]
> > > > [still regression on linux-next/master e98d21c170b01ddef366f023bbfcf6b31509fa83]
> > > > 
> > > > testcase: will-it-scale
> > > > config: x86_64-rhel-9.4
> > > > compiler: gcc-14
> > > > test machine: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory
> > > > parameters:
> > > > 
> > > > 	nr_task: 100%
> > > > 	mode: process
> > > > 	test: mmap2
> > > > 	cpufreq_governor: performance
> > > > 
> > > > 
> > > 
> > > Thank you for the report.
> > > 
> > > 48 threads on a 2 socket E5-2697 v2 looks to be 12 cores (24 threads)
> > > per cpu (so x2), or exactly one mmap2 process per hyperthread.
> > 
> > this is the cpu information:
> > 
> > Architecture:        x86_64
> > CPU op-mode(s):      32-bit, 64-bit
> > Byte Order:          Little Endian
> > Address sizes:       46 bits physical, 48 bits virtual
> > CPU(s):              48
> > On-line CPU(s) list: 0-47
> > Thread(s) per core:  2
> > Core(s) per socket:  12
> > Socket(s):           2
> > NUMA node(s):        2
> > Vendor ID:           GenuineIntel
> > CPU family:          6
> > Model:               62
> > Model name:          Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz
> > Stepping:            4
> > 
> > > 
> > > Is this across all process counts and peaks at 48, or just 48?
> > 
> > just 48. the run script is in
> > https://download.01.org/0day-ci/archive/20260513/202605131554.92e7df6b-lkp@intel.com/repro-script
> > 
> > cd /lkp/benchmarks/will-it-scale
> > python3 ./runtest.py mmap2 295 process 0 0 48
> > 
> > > Is this across many runs?
> > 
> > we run 6 times for both parent and this commit, the data looks stable
> > 
> > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json:  "will-it-scale.per_process_ops": [
> > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143595,
> > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143474,
> > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    144104,
> > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    142796,
> > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143081,
> > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143623
> > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-  ],
> > 
> > 
> > 280b792cac62ddadca2935766ca870b438c86323/matrix.json:  "will-it-scale.per_process_ops": [
> > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    134451,
> > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135089,
> > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135080,
> > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135039,
> > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    134082,
> > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135301
> > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-  ],
> > 
> > 
> > > 
> > > My testing didn't produce anything like this.  I'll have a look into
> > > this when I can, but there isn't anything obvious that sticks out as a
> > > likely cause.
> > 
> > if you want us to test any debug patch, it will be our great pleasure. thanks!
> 
> It looks like the result of the shape of the tree changing.  Can you try
> the attached patch against Linus' tree?

I appled your patch upon below mainline tip commit when I checked.
6779b50faa562 ("Merge tag 'pci-v7.1-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci")

then build kernels with attached config.

but found a big regression introduced by your patch.

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/mmap2/will-it-scale

commit:
  6779b50faa562 ("Merge tag 'pci-v7.1-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci")
  942596e1c1037 ("maple_tree: Restore old tree layout using new scatter-gather node copy")

6779b50faa562e6c 942596e1c1037f014638541bce4
---------------- ---------------------------
         %stddev     %change         %stddev
             \          |                \
   7023559           -42.9%    4007886        will-it-scale.48.processes
    146323           -42.9%      83497        will-it-scale.per_process_ops
   7023559           -42.9%    4007886        will-it-scale.workload


full comparison is as below [1]

however, it seems the performance regression is really recovered at commit
6779b50faa562, though the configs are not same. list the regression we reported
for refererence.

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/mmap2/will-it-scale

commit: 
  11e7f22f5e ("maple_tree: add cp_converged() helper")
  280b792cac ("maple_tree: use maple copy node for mas_wr_split()")

11e7f22f5e85058b 280b792cac62ddadca2935766ca 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   6885401            -6.0%    6472359        will-it-scale.48.processes
    143445            -6.0%     134840        will-it-scale.per_process_ops
   6885401            -6.0%    6472359        will-it-scale.workload



[1]
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/mmap2/will-it-scale

commit:
  6779b50faa562 ("Merge tag 'pci-v7.1-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci")
  942596e1c1037 ("maple_tree: Restore old tree layout using new scatter-gather node copy")

6779b50faa562e6c 942596e1c1037f014638541bce4
---------------- ---------------------------
         %stddev     %change         %stddev
             \          |                \
   7023559           -42.9%    4007886        will-it-scale.48.processes
    146323           -42.9%      83497        will-it-scale.per_process_ops
   7023559           -42.9%    4007886        will-it-scale.workload
      0.66           -12.7%       0.58        turbostat.IPC
     18.34            +5.3%      19.31        turbostat.RAMWatt
      0.42            +0.0        0.45        mpstat.cpu.all.irq%
      2.66            +3.3        5.93        mpstat.cpu.all.soft%
     14.68            -5.9        8.81        mpstat.cpu.all.usr%
     14.62           -40.2%       8.75        vmstat.cpu.us
   6222969           -10.4%    5575283        vmstat.memory.cache
      7082           +38.9%       9835        vmstat.system.cs
   2474044 ±  6%    +298.0%    9845581 ±  6%  numa-numastat.node0.local_node
   2496926 ±  6%    +295.0%    9862610 ±  6%  numa-numastat.node0.numa_hit
   2770972 ±  3%    +255.1%    9840248 ±  5%  numa-numastat.node1.local_node
   2797815 ±  3%    +252.9%    9872775 ±  5%  numa-numastat.node1.numa_hit
    224.50 ±  7%     +79.4%     402.75 ±  2%  perf-c2c.DRAM.local
    130.88 ± 10%    +104.5%     267.62 ±  5%  perf-c2c.DRAM.remote
    477.25 ±  8%    +306.6%       1940 ±  5%  perf-c2c.HITM.local
     86.75 ± 17%    +190.5%     252.00 ±  5%  perf-c2c.HITM.remote
      7083           +39.2%       9857        perf-stat.i.context-switches
    243.71           -17.4%     201.31        perf-stat.i.cpu-migrations
      7059           +39.2%       9824        perf-stat.ps.context-switches
    242.83           -17.4%     200.61        perf-stat.ps.cpu-migrations
   2432336 ±  3%     -30.0%    1703846 ± 12%  numa-meminfo.node1.Active
   2432227 ±  3%     -30.0%    1703734 ± 12%  numa-meminfo.node1.Active(anon)
    456558 ±  7%     -60.7%     179634 ± 20%  numa-meminfo.node1.Mapped
      5874 ±  5%     -10.6%       5254 ±  6%  numa-meminfo.node1.PageTables
    111108 ±  6%      +9.8%     121989 ±  6%  numa-meminfo.node1.SUnreclaim
   2014977 ±  2%     -34.3%    1324406 ± 12%  numa-meminfo.node1.Shmem
      0.26 ±  4%     -16.5%       0.22 ±  2%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.26 ±  4%     -16.5%       0.22 ±  2%  perf-sched.total_sch_delay.average.ms
     33.78 ±  5%     -41.3%      19.83 ±  2%  perf-sched.total_wait_and_delay.average.ms
     25847 ±  5%     +73.3%      44801 ±  2%  perf-sched.total_wait_and_delay.count.ms
     33.51 ±  5%     -41.5%      19.61 ±  2%  perf-sched.total_wait_time.average.ms
     33.78 ±  5%     -41.3%      19.83 ±  2%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     25847 ±  5%     +73.3%      44801 ±  2%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     33.51 ±  5%     -41.5%      19.61 ±  2%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
   2718564           -24.0%    2067012        meminfo.Active
   2718343           -24.0%    2066792        meminfo.Active(anon)
   6132342           -10.5%    5486698        meminfo.Cached
    504163 ±  2%     -55.1%     226137 ±  2%  meminfo.Mapped
   7551345            -8.6%    6901581        meminfo.Memused
     11026            -5.9%      10375        meminfo.PageTables
    232673           +11.1%     258411        meminfo.SUnreclaim
   2036572           -31.7%    1390925        meminfo.Shmem
    321293            +7.5%     345548        meminfo.Slab
   7698968            -8.1%    7076107        meminfo.max_used_kB
   2496631 ±  6%    +295.0%    9862492 ±  6%  numa-vmstat.node0.numa_hit
   2473748 ±  6%    +298.0%    9845463 ±  6%  numa-vmstat.node0.numa_local
    608040 ±  3%     -30.0%     425868 ± 12%  numa-vmstat.node1.nr_active_anon
    113181 ±  7%     -60.5%      44658 ± 20%  numa-vmstat.node1.nr_mapped
      1466 ±  5%     -10.5%       1313 ±  6%  numa-vmstat.node1.nr_page_table_pages
    503740 ±  2%     -34.3%     331036 ± 12%  numa-vmstat.node1.nr_shmem
     27840 ±  6%      +9.9%      30585 ±  6%  numa-vmstat.node1.nr_slab_unreclaimable
    608040 ±  3%     -30.0%     425868 ± 12%  numa-vmstat.node1.nr_zone_active_anon
   2797544 ±  3%    +252.9%    9872464 ±  5%  numa-vmstat.node1.numa_hit
   2770701 ±  3%    +255.1%    9839937 ±  5%  numa-vmstat.node1.numa_local
     98407 ±  8%     -16.6%      82034 ± 12%  sched_debug.cfs_rq:/.avg_vruntime.stddev
    584720 ± 55%     +82.9%    1069238 ± 20%  sched_debug.cfs_rq:/.left_deadline.stddev
    584716 ± 55%     +82.9%    1069230 ± 20%  sched_debug.cfs_rq:/.left_vruntime.stddev
    584717 ± 55%     +82.9%    1069231 ± 20%  sched_debug.cfs_rq:/.right_vruntime.stddev
     98406 ±  8%     -16.6%      82034 ± 12%  sched_debug.cfs_rq:/.zero_vruntime.stddev
      3696 ± 22%     -53.0%       1736 ± 28%  sched_debug.cpu.curr->pid.min
      1080 ±  8%     +22.1%       1320 ±  7%  sched_debug.cpu.curr->pid.stddev
     24404           +36.7%      33355        sched_debug.cpu.nr_switches.avg
     35594 ±  5%     +26.6%      45073 ±  6%  sched_debug.cpu.nr_switches.max
     19226           +47.9%      28429        sched_debug.cpu.nr_switches.min
    679722           -24.0%     516709        proc-vmstat.nr_active_anon
   1446664            +1.1%    1462897        proc-vmstat.nr_dirty_background_threshold
   2896867            +1.1%    2929372        proc-vmstat.nr_dirty_threshold
   1533216           -10.5%    1371700        proc-vmstat.nr_file_pages
  14575614            +1.1%   14738179        proc-vmstat.nr_free_pages
    126756 ±  2%     -55.4%      56505 ±  2%  proc-vmstat.nr_mapped
      2757            -6.0%       2592        proc-vmstat.nr_page_table_pages
    509273           -31.7%     347755        proc-vmstat.nr_shmem
     22155            -1.7%      21783        proc-vmstat.nr_slab_reclaimable
     58291           +10.7%      64524        proc-vmstat.nr_slab_unreclaimable
    679722           -24.0%     516709        proc-vmstat.nr_zone_active_anon
   5296571          +272.6%   19736811        proc-vmstat.numa_hit
   5246846          +275.2%   19687252        proc-vmstat.numa_local
   9465911          +307.2%   38547209        proc-vmstat.pgalloc_normal
   8803386 ±  2%    +332.6%   38087100        proc-vmstat.pgfree
     19.27            -5.7       13.54        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
     15.16            -5.1       10.07        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
     54.50            -4.2       50.33        perf-profile.calltrace.cycles-pp.__mmap
      8.54            -2.9        5.66        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      8.04            -2.8        5.22        perf-profile.calltrace.cycles-pp.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      9.39            -2.6        6.83        perf-profile.calltrace.cycles-pp.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      6.62            -2.5        4.12        perf-profile.calltrace.cycles-pp.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
      8.69            -2.3        6.34        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff
      8.36            -2.3        6.10        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap
      5.66            -1.9        3.72        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      3.90            -1.7        2.20        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.__mmap
      3.76            -1.6        2.13        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.__munmap
      2.99 ±  3%      -1.6        1.39        perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      3.68            -1.3        2.39        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      3.38            -1.2        2.18        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
      2.86            -1.0        1.81        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
      6.25            -1.0        5.24        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      5.95            -1.0        4.95        perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      2.77 ±  2%      -0.9        1.85 ±  2%  perf-profile.calltrace.cycles-pp.d_path.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
      2.41            -0.8        1.65        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region
      1.53            -0.7        0.85        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.__munmap
      1.50            -0.6        0.85        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.__mmap
      4.86            -0.6        4.23        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      1.67 ±  4%      -0.6        1.05 ±  4%  perf-profile.calltrace.cycles-pp.prepend_path.d_path.perf_event_mmap_event.perf_event_mmap.__mmap_complete
      1.37            -0.6        0.75        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      1.36            -0.6        0.76        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      1.78            -0.6        1.22        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
      1.69            -0.6        1.13        perf-profile.calltrace.cycles-pp.shmem_mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      4.11            -0.5        3.60        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
      1.23            -0.5        0.72        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      1.38            -0.5        0.89        perf-profile.calltrace.cycles-pp.touch_atime.shmem_mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff
      1.37            -0.5        0.89        perf-profile.calltrace.cycles-pp.mas_find.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      3.96            -0.5        3.49        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
      1.46            -0.5        1.01        perf-profile.calltrace.cycles-pp.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      1.10            -0.4        0.67        perf-profile.calltrace.cycles-pp.security_vm_enough_memory_mm.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      1.11            -0.4        0.73        perf-profile.calltrace.cycles-pp.unlink_file_vma_batch_process.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      0.97            -0.4        0.60        perf-profile.calltrace.cycles-pp.atime_needs_update.touch_atime.shmem_mmap_prepare.__mmap_region.do_mmap
      0.95            -0.4        0.58        perf-profile.calltrace.cycles-pp.vma_merge_new_range.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      2.41            -0.3        2.07        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.71            -0.3        1.40        perf-profile.calltrace.cycles-pp.__build_id_parse.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
      0.80            -0.3        0.55        perf-profile.calltrace.cycles-pp.pte_offset_map_lock.zap_pte_range.zap_pmd_range.__zap_vma_range.unmap_vmas
      1.20            -0.2        1.00        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.81            -0.2        0.63        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
      1.97            -0.2        1.79        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
      0.76            -0.2        0.60        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff
      1.15            -0.1        1.01        perf-profile.calltrace.cycles-pp.freader_fetch.__build_id_parse.perf_event_mmap_event.perf_event_mmap.__mmap_complete
      1.48            -0.1        1.36        perf-profile.calltrace.cycles-pp.mas_rev_awalk.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
      0.90            -0.1        0.78        perf-profile.calltrace.cycles-pp.freader_get_folio.freader_fetch.__build_id_parse.perf_event_mmap_event.perf_event_mmap
      0.77            -0.1        0.66        perf-profile.calltrace.cycles-pp.khugepaged_enter_vma.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.93 ±  2%      -0.1        1.82        perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      2.20            -0.1        2.11        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
      0.66            -0.1        0.58 ±  2%  perf-profile.calltrace.cycles-pp.__filemap_get_folio_mpol.freader_get_folio.freader_fetch.__build_id_parse.perf_event_mmap_event
      1.17 ±  3%      -0.1        1.10        perf-profile.calltrace.cycles-pp.perf_session__process_events.record__finish_output.cmd_record
      1.17 ±  3%      -0.1        1.10        perf-profile.calltrace.cycles-pp.cmd_record
      1.17 ±  3%      -0.1        1.10        perf-profile.calltrace.cycles-pp.record__finish_output.cmd_record
      5.13            +0.1        5.20        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
     44.84            +0.2       45.05        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      0.70            +0.4        1.07        perf-profile.calltrace.cycles-pp.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.20 ±129%      +0.4        0.60 ±  2%  perf-profile.calltrace.cycles-pp.ordered_events__deliver_event.__ordered_events__flush.perf_session__process_user_event.perf_session__process_events.record__finish_output
      0.22 ±129%      +0.4        0.64 ±  2%  perf-profile.calltrace.cycles-pp.__ordered_events__flush.perf_session__process_user_event.perf_session__process_events.record__finish_output.cmd_record
      0.22 ±129%      +0.4        0.64 ±  2%  perf-profile.calltrace.cycles-pp.perf_session__process_user_event.perf_session__process_events.record__finish_output.cmd_record
      0.13 ±173%      +0.5        0.59 ±  2%  perf-profile.calltrace.cycles-pp.perf_session__deliver_event.ordered_events__deliver_event.__ordered_events__flush.perf_session__process_user_event.perf_session__process_events
     43.80            +0.5       44.30        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      0.00            +0.5        0.52 ±  2%  perf-profile.calltrace.cycles-pp.node_finalise.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.00            +0.6        0.56        perf-profile.calltrace.cycles-pp.memcpy_orig.node_copy.cp_data_write.mas_wr_spanning_store.mas_store_gfp
      0.00            +0.6        0.58        perf-profile.calltrace.cycles-pp.memcpy_orig.node_copy.cp_data_write.mas_wr_split.mas_store_prealloc
      0.89            +0.6        1.47        perf-profile.calltrace.cycles-pp.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.00            +0.7        0.66        perf-profile.calltrace.cycles-pp.mas_next_node.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap
      0.65            +0.7        1.31        perf-profile.calltrace.cycles-pp.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.00            +0.7        0.67 ±  2%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_topiary_replace.mas_wr_spanning_store.mas_store_gfp
      0.00            +0.8        0.78        perf-profile.calltrace.cycles-pp.node_finalise.mas_wr_split.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +0.8        0.82 ±  2%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     42.40            +1.0       43.37        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      0.00            +1.0        1.00 ±  2%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_topiary_replace.mas_wr_split.mas_store_prealloc.__mmap_new_vma
      0.00            +1.3        1.25        perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_topiary_replace.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap
     41.16            +1.3       42.42        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.3        1.26 ±  2%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      0.00            +1.3        1.31        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__prefill_sheaf_pfmemalloc
      0.00            +1.4        1.40        perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      0.00            +1.4        1.44        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__prefill_sheaf_pfmemalloc.kmem_cache_prefill_sheaf
      0.00            +1.5        1.45 ±  2%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
      0.00            +1.5        1.46 ±  2%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
      0.00            +1.5        1.47        perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
      0.00            +1.5        1.47        perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     45.00            +1.5       46.50        perf-profile.calltrace.cycles-pp.__munmap
      0.00            +1.5        1.50 ±  2%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.00            +1.7        1.73        perf-profile.calltrace.cycles-pp.node_copy.cp_data_write.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap
      0.00            +1.7        1.73        perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      0.00            +1.7        1.73        perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      0.00            +1.7        1.73        perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      0.00            +1.8        1.82        perf-profile.calltrace.cycles-pp.node_copy.cp_data_write.mas_wr_split.mas_store_prealloc.__mmap_new_vma
      0.00            +2.0        1.95        perf-profile.calltrace.cycles-pp.dst_setup.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
     33.18            +2.6       35.81        perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      0.00            +2.9        2.88        perf-profile.calltrace.cycles-pp.cp_data_write.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.00            +3.0        3.03        perf-profile.calltrace.cycles-pp.dst_setup.mas_wr_split.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +3.3        3.31        perf-profile.calltrace.cycles-pp.mas_topiary_replace.mas_wr_split.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +3.6        3.59        perf-profile.calltrace.cycles-pp.mas_topiary_replace.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.00            +3.9        3.87        perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__prefill_sheaf_pfmemalloc.kmem_cache_prefill_sheaf.mas_store_gfp
      0.00            +3.9        3.91        perf-profile.calltrace.cycles-pp.cp_data_write.mas_wr_split.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +4.6        4.64        perf-profile.calltrace.cycles-pp.refill_objects.__prefill_sheaf_pfmemalloc.kmem_cache_prefill_sheaf.mas_store_gfp.do_vmi_align_munmap
      0.00            +4.7        4.71        perf-profile.calltrace.cycles-pp.__prefill_sheaf_pfmemalloc.kmem_cache_prefill_sheaf.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.00            +5.1        5.10        perf-profile.calltrace.cycles-pp.kmem_cache_prefill_sheaf.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
     36.19            +5.6       41.79        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     36.00            +5.7       41.69        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     35.15            +6.0       41.13        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     35.01            +6.0       41.03        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     34.08            +6.3       40.39        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     32.43            +6.8       39.26        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
     12.68            +8.9       21.54        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      4.77           +11.2       16.00        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      7.25           +12.6       19.89        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      0.00           +13.7       13.69        perf-profile.calltrace.cycles-pp.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.00           +14.8       14.81        perf-profile.calltrace.cycles-pp.mas_wr_split.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      8.17            -8.2        0.00        perf-profile.children.cycles-pp.mas_wr_node_store
     19.48            -5.8       13.71        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
     15.18            -5.1       10.08        perf-profile.children.cycles-pp.unmap_region
      9.02            -4.0        4.98        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
     54.00            -3.6       50.44        perf-profile.children.cycles-pp.__mmap
      5.18            -3.4        1.80        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      8.56            -2.9        5.68        perf-profile.children.cycles-pp.unmap_vmas
      8.07            -2.8        5.24        perf-profile.children.cycles-pp.__zap_vma_range
      9.41            -2.6        6.84        perf-profile.children.cycles-pp.__mmap_complete
      6.64            -2.5        4.13        perf-profile.children.cycles-pp.zap_pmd_range
      8.70            -2.3        6.36        perf-profile.children.cycles-pp.perf_event_mmap
      8.41            -2.3        6.13        perf-profile.children.cycles-pp.perf_event_mmap_event
      5.75            -2.0        3.78        perf-profile.children.cycles-pp.free_pgtables
      3.02 ±  3%      -1.6        1.41        perf-profile.children.cycles-pp.mas_preallocate
      3.48            -1.5        1.94        perf-profile.children.cycles-pp.entry_SYSCALL_64
      3.09            -1.4        1.74        perf-profile.children.cycles-pp.syscall_return_via_sysret
      3.70            -1.3        2.40        perf-profile.children.cycles-pp.free_pgd_range
      3.39            -1.2        2.19        perf-profile.children.cycles-pp.free_p4d_range
      2.86            -1.0        1.82        perf-profile.children.cycles-pp.free_pud_range
      6.26            -1.0        5.24        perf-profile.children.cycles-pp.__get_unmapped_area
      5.96            -1.0        4.95        perf-profile.children.cycles-pp.shmem_get_unmapped_area
      2.78 ±  2%      -0.9        1.85 ±  2%  perf-profile.children.cycles-pp.d_path
      1.85            -0.8        1.07        perf-profile.children.cycles-pp.mas_wr_store_type
      2.43            -0.8        1.66        perf-profile.children.cycles-pp.zap_pte_range
      2.16            -0.7        1.47        perf-profile.children.cycles-pp.mas_walk
      4.91            -0.7        4.26        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      1.68 ±  4%      -0.6        1.05 ±  4%  perf-profile.children.cycles-pp.prepend_path
      4.81            -0.6        4.24        perf-profile.children.cycles-pp.mas_find
      1.80            -0.6        1.24        perf-profile.children.cycles-pp.perf_iterate_sb
      1.72            -0.6        1.16        perf-profile.children.cycles-pp.shmem_mmap_prepare
      0.65            -0.5        0.13 ±  3%  perf-profile.children.cycles-pp.mas_update_gap
      4.12            -0.5        3.61        perf-profile.children.cycles-pp.vm_unmapped_area
      1.13            -0.5        0.63        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      1.39            -0.5        0.90        perf-profile.children.cycles-pp.touch_atime
      3.98            -0.5        3.50        perf-profile.children.cycles-pp.unmapped_area_topdown
      1.16            -0.5        0.70        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      1.00            -0.4        0.62 ±  2%  perf-profile.children.cycles-pp.atime_needs_update
      0.99            -0.4        0.60        perf-profile.children.cycles-pp.vma_merge_new_range
      1.12            -0.4        0.74        perf-profile.children.cycles-pp.unlink_file_vma_batch_process
      1.05            -0.4        0.68        perf-profile.children.cycles-pp.__vma_start_write
      2.42            -0.3        2.08        perf-profile.children.cycles-pp.vm_area_alloc
      1.73            -0.3        1.41        perf-profile.children.cycles-pp.__build_id_parse
      0.89 ±  3%      -0.3        0.59 ±  3%  perf-profile.children.cycles-pp.kfree
      0.92 ±  2%      -0.3        0.63 ±  2%  perf-profile.children.cycles-pp.prepend_copy
      1.51            -0.3        1.24        perf-profile.children.cycles-pp.memcpy_orig
      0.68            -0.3        0.41        perf-profile.children.cycles-pp.__vma_start_exclude_readers
      0.59 ±  2%      -0.3        0.33 ± 10%  perf-profile.children.cycles-pp.current_time
      0.82            -0.3        0.56        perf-profile.children.cycles-pp.pte_offset_map_lock
      0.83 ±  2%      -0.3        0.57 ±  2%  perf-profile.children.cycles-pp.copy_from_kernel_nofault
      0.54 ±  8%      -0.2        0.33 ±  3%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.61 ±  3%      -0.2        0.40 ±  3%  perf-profile.children.cycles-pp.fget
      0.58 ±  4%      -0.2        0.37 ±  4%  perf-profile.children.cycles-pp.ordered_events__queue
      0.58 ±  4%      -0.2        0.36 ±  5%  perf-profile.children.cycles-pp.queue_event
      0.59 ±  2%      -0.2        0.38 ±  3%  perf-profile.children.cycles-pp.vma_set_page_prot
      0.64 ±  3%      -0.2        0.44 ±  3%  perf-profile.children.cycles-pp.process_simple
      0.50 ±  3%      -0.2        0.31 ±  3%  perf-profile.children.cycles-pp.x64_sys_call
      0.61            -0.2        0.43        perf-profile.children.cycles-pp.up_write
      0.61            -0.2        0.45        perf-profile.children.cycles-pp.__thp_vma_allowable_orders
      0.41 ±  2%      -0.2        0.25        perf-profile.children.cycles-pp.fput
      0.41 ±  2%      -0.1        0.26 ±  3%  perf-profile.children.cycles-pp.down_write
      0.40 ±  3%      -0.1        0.25 ±  2%  perf-profile.children.cycles-pp.up_read
      1.16            -0.1        1.02        perf-profile.children.cycles-pp.freader_fetch
      0.38            -0.1        0.25        perf-profile.children.cycles-pp.can_vma_merge_right
      0.30 ±  2%      -0.1        0.18 ±  7%  perf-profile.children.cycles-pp.static_key_count
      1.48            -0.1        1.36        perf-profile.children.cycles-pp.mas_rev_awalk
      0.38            -0.1        0.26 ±  2%  perf-profile.children.cycles-pp.remove_vma
      0.24 ±  2%      -0.1        0.12 ±  3%  perf-profile.children.cycles-pp.unlink_anon_vmas
      0.80            -0.1        0.69        perf-profile.children.cycles-pp.khugepaged_enter_vma
      0.29            -0.1        0.18 ±  2%  perf-profile.children.cycles-pp.cap_vm_enough_memory
      0.91            -0.1        0.79        perf-profile.children.cycles-pp.freader_get_folio
      0.30 ±  2%      -0.1        0.18 ±  3%  perf-profile.children.cycles-pp.mmap_region
      0.35 ±  4%      -0.1        0.24 ±  2%  perf-profile.children.cycles-pp.strlen
      0.30 ±  2%      -0.1        0.19        perf-profile.children.cycles-pp.downgrade_write
      0.45 ±  5%      -0.1        0.34 ±  4%  perf-profile.children.cycles-pp.down_write_killable
      0.26            -0.1        0.15 ±  2%  perf-profile.children.cycles-pp.freader_init_from_file
      1.95 ±  2%      -0.1        1.84        perf-profile.children.cycles-pp.kmem_cache_free
      0.36            -0.1        0.25 ±  2%  perf-profile.children.cycles-pp.may_expand_vm
      0.33 ±  3%      -0.1        0.22 ±  4%  perf-profile.children.cycles-pp.vma_interval_tree_remove
      0.34 ±  2%      -0.1        0.24 ±  3%  perf-profile.children.cycles-pp._raw_spin_lock
      0.23 ±  3%      -0.1        0.13 ±  6%  perf-profile.children.cycles-pp.prandom_u32_state
      0.32            -0.1        0.22 ±  2%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.29 ±  4%      -0.1        0.19 ±  5%  perf-profile.children.cycles-pp.uprobe_mmap
      0.37 ±  3%      -0.1        0.27 ±  6%  perf-profile.children.cycles-pp.vm_get_page_prot
      2.24            -0.1        2.14        perf-profile.children.cycles-pp.mas_empty_area_rev
      0.26            -0.1        0.16 ±  2%  perf-profile.children.cycles-pp.__vm_enough_memory
      0.36            -0.1        0.26        perf-profile.children.cycles-pp.mmap_action_complete
      0.24 ±  4%      -0.1        0.16 ± 13%  perf-profile.children.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.32            -0.1        0.24 ±  2%  perf-profile.children.cycles-pp.mas_next_range
      0.68            -0.1        0.60 ±  2%  perf-profile.children.cycles-pp.__filemap_get_folio_mpol
      1.17 ±  3%      -0.1        1.10        perf-profile.children.cycles-pp.perf_session__process_events
      1.17 ±  3%      -0.1        1.10        perf-profile.children.cycles-pp.record__finish_output
      0.19 ±  4%      -0.1        0.13 ±  5%  perf-profile.children.cycles-pp.cap_capable
      0.30 ±  2%      -0.1        0.23        perf-profile.children.cycles-pp.tlb_finish_mmu
      1.21 ±  3%      -0.1        1.15        perf-profile.children.cycles-pp.cmd_record
      0.19 ±  2%      -0.1        0.13 ±  4%  perf-profile.children.cycles-pp.__x64_sys_mmap
      0.20 ±  2%      -0.1        0.13 ±  3%  perf-profile.children.cycles-pp.__x86_indirect_thunk_rax
      0.34 ±  2%      -0.1        0.27        perf-profile.children.cycles-pp.userfaultfd_unmap_complete
      0.14 ±  3%      -0.1        0.08        perf-profile.children.cycles-pp.unlink_file_vma_batch_add
      0.10            -0.1        0.04 ± 57%  perf-profile.children.cycles-pp.can_vma_merge_left
      0.19 ±  3%      -0.1        0.13 ±  3%  perf-profile.children.cycles-pp.vma_wants_writenotify
      0.17            -0.1        0.11        perf-profile.children.cycles-pp.ksm_vma_flags
      0.22 ±  2%      -0.1        0.16 ±  4%  perf-profile.children.cycles-pp.vm_area_free
      0.16 ±  2%      -0.1        0.11 ±  3%  perf-profile.children.cycles-pp.__pte_offset_map
      0.23 ±  2%      -0.1        0.18 ±  3%  perf-profile.children.cycles-pp.testcase
      0.20 ±  4%      -0.1        0.15 ±  2%  perf-profile.children.cycles-pp.uprobe_munmap
      0.15 ±  4%      -0.1        0.10 ±  3%  perf-profile.children.cycles-pp.vma_is_shared_writable
      0.12 ±  5%      -0.0        0.08 ±  6%  perf-profile.children.cycles-pp.__rb_insert_augmented
      0.23 ±  3%      -0.0        0.18 ±  3%  perf-profile.children.cycles-pp.ima_file_mmap
      0.18 ± 16%      -0.0        0.13 ± 16%  perf-profile.children.cycles-pp.memfd_check_seals_mmap
      0.15 ±  2%      -0.0        0.10 ±  6%  perf-profile.children.cycles-pp.mm_get_unmapped_area
      0.13 ±  4%      -0.0        0.08 ±  7%  perf-profile.children.cycles-pp.rb_next
      0.09 ±  6%      -0.0        0.04 ± 37%  perf-profile.children.cycles-pp.flush_tlb_batched_pending
      0.17 ±  3%      -0.0        0.13 ±  3%  perf-profile.children.cycles-pp.mas_prev_range
      0.48 ±  2%      -0.0        0.43        perf-profile.children.cycles-pp.mas_prev
      0.10 ±  3%      -0.0        0.06        perf-profile.children.cycles-pp._raw_spin_unlock
      0.20 ±  5%      -0.0        0.16 ±  3%  perf-profile.children.cycles-pp.vma_is_special_huge
      0.12 ±  4%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.mas_next_setup
      0.29 ±  2%      -0.0        0.25 ±  2%  perf-profile.children.cycles-pp.mas_wr_store_entry
      0.07 ±  7%      -0.0        0.04 ± 57%  perf-profile.children.cycles-pp.finish_rcuwait
      0.07 ±  5%      -0.0        0.04 ± 37%  perf-profile.children.cycles-pp.__mt_destroy
      0.22 ±  2%      -0.0        0.19 ±  2%  perf-profile.children.cycles-pp.copy_from_kernel_nofault_allowed
      0.09 ±  5%      -0.0        0.07 ±  7%  perf-profile.children.cycles-pp.prepend
      0.24 ±  2%      -0.0        0.22        perf-profile.children.cycles-pp.mas_prev_setup
      0.09            -0.0        0.08 ±  6%  perf-profile.children.cycles-pp.get_align_mask
      0.10 ±  3%      -0.0        0.09        perf-profile.children.cycles-pp.mmap_action_prepare
      0.32            +0.0        0.34        perf-profile.children.cycles-pp.tick_nohz_handler
      0.29            +0.0        0.30        perf-profile.children.cycles-pp.update_process_times
      0.07 ±  4%      +0.0        0.09 ±  8%  perf-profile.children.cycles-pp.trylock_stock
      0.06 ± 11%      +0.0        0.08 ±  6%  perf-profile.children.cycles-pp.maps__fixup_overlap_and_insert
      0.05 ± 39%      +0.0        0.07 ±  7%  perf-profile.children.cycles-pp.machine__findnew_thread
      0.10            +0.0        0.12 ±  2%  perf-profile.children.cycles-pp.__kmalloc_noprof
      0.11            +0.0        0.13 ±  2%  perf-profile.children.cycles-pp.__alloc_empty_sheaf
      0.05 ±  6%      +0.0        0.07 ±  5%  perf-profile.children.cycles-pp.mmap@plt
      0.06 ±  8%      +0.0        0.08 ±  4%  perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.13 ± 10%      +0.0        0.16 ±  5%  perf-profile.children.cycles-pp.map__new
      0.05            +0.0        0.09        perf-profile.children.cycles-pp.schedule
      0.14 ±  3%      +0.0        0.18 ±  2%  perf-profile.children.cycles-pp.is_vmalloc_addr
      0.08 ±  6%      +0.0        0.12 ±  3%  perf-profile.children.cycles-pp.__call_rcu_common
      0.18 ± 12%      +0.0        0.22 ± 11%  perf-profile.children.cycles-pp.__refill_obj_stock
      0.05 ±  6%      +0.0        0.10        perf-profile.children.cycles-pp.__schedule
      5.19            +0.0        5.24        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      0.00            +0.1        0.06 ±  5%  perf-profile.children.cycles-pp.add_callchain_ip
      0.28 ±  9%      +0.1        0.34 ±  3%  perf-profile.children.cycles-pp.machine__process_mmap2_event
      0.05 ± 42%      +0.1        0.12 ± 11%  perf-profile.children.cycles-pp.build_id__mark_dso_hit
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.00            +0.1        0.07 ±  6%  perf-profile.children.cycles-pp.barn_put_empty_sheaf
      0.00            +0.1        0.07 ±  6%  perf-profile.children.cycles-pp.thread__resolve_callchain_sample
      0.04 ± 79%      +0.1        0.11 ± 12%  perf-profile.children.cycles-pp.sample__for_each_callchain_node
      0.00            +0.1        0.07        perf-profile.children.cycles-pp.build_detached_freelist
      0.00            +0.1        0.07 ±  4%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.03 ±101%      +0.1        0.10 ± 12%  perf-profile.children.cycles-pp.__thread__resolve_callchain
      1.53            +0.1        1.60        perf-profile.children.cycles-pp.mas_prev_slot
      0.15 ±  3%      +0.1        0.22 ±  6%  perf-profile.children.cycles-pp.xas_load
      0.07 ±  5%      +0.1        0.17 ±  2%  perf-profile.children.cycles-pp.barn_get_empty_sheaf
      0.10            +0.1        0.20        perf-profile.children.cycles-pp.__pi_memcpy
      0.07 ±  6%      +0.1        0.17 ±  2%  perf-profile.children.cycles-pp.__refill_objects_any
      0.00            +0.1        0.11        perf-profile.children.cycles-pp.alloc_from_new_slab
      0.51 ± 10%      +0.1        0.64 ±  2%  perf-profile.children.cycles-pp.__ordered_events__flush
      0.51 ± 10%      +0.1        0.64 ±  2%  perf-profile.children.cycles-pp.perf_session__process_user_event
      0.46 ±  9%      +0.1        0.60 ±  2%  perf-profile.children.cycles-pp.perf_session__deliver_event
      0.47 ± 10%      +0.1        0.60 ±  2%  perf-profile.children.cycles-pp.ordered_events__deliver_event
      0.25 ±  4%      +0.1        0.39        perf-profile.children.cycles-pp.__account_obj_stock
      0.06            +0.2        0.21 ±  2%  perf-profile.children.cycles-pp.kmem_cache_free_bulk
      0.06            +0.2        0.21 ±  2%  perf-profile.children.cycles-pp.kvfree_rcu_bulk
      0.06            +0.2        0.21 ±  2%  perf-profile.children.cycles-pp.kfree_rcu_work
      0.06 ±  7%      +0.2        0.22 ±  2%  perf-profile.children.cycles-pp.process_one_work
      0.32 ±  2%      +0.2        0.48        perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.07 ±  7%      +0.2        0.22 ±  2%  perf-profile.children.cycles-pp.worker_thread
      0.04 ± 38%      +0.2        0.24 ±  4%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      0.09 ±  5%      +0.2        0.31 ±  3%  perf-profile.children.cycles-pp.setup_object
      0.66 ±  3%      +0.2        0.89        perf-profile.children.cycles-pp.mas_wr_walk_descend
      0.10 ±  4%      +0.3        0.38 ±  2%  perf-profile.children.cycles-pp.shuffle_freelist
      1.70            +0.3        1.99        perf-profile.children.cycles-pp.mas_next_slot
      0.12 ±  5%      +0.3        0.46 ±  2%  perf-profile.children.cycles-pp.allocate_slab
      0.76 ±  3%      +0.4        1.14 ±  2%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      0.00            +0.4        0.39        perf-profile.children.cycles-pp.kmem_cache_return_sheaf
     43.84            +0.5       44.31        perf-profile.children.cycles-pp.ksys_mmap_pgoff
      1.87            +0.5        2.35        perf-profile.children.cycles-pp.kvfree_call_rcu
      0.00            +0.5        0.51        perf-profile.children.cycles-pp.mas_prev_node
      0.00            +0.5        0.52        perf-profile.children.cycles-pp.mas_wr_walk_index
      0.00            +0.7        0.66        perf-profile.children.cycles-pp.kmem_cache_alloc_from_sheaf_noprof
      0.00            +0.7        0.67        perf-profile.children.cycles-pp.mas_next_node
      0.00            +0.7        0.67        perf-profile.children.cycles-pp.mas_ascend
      0.00            +0.7        0.71        perf-profile.children.cycles-pp.multi_src_setup
     42.42            +1.0       43.39        perf-profile.children.cycles-pp.vm_mmap_pgoff
     41.20            +1.2       42.45        perf-profile.children.cycles-pp.do_mmap
      0.22 ±  3%      +1.3        1.47        perf-profile.children.cycles-pp.run_ksoftirqd
      0.23 ±  2%      +1.3        1.50 ±  2%  perf-profile.children.cycles-pp.smpboot_thread_fn
      0.31 ±  2%      +1.4        1.73        perf-profile.children.cycles-pp.ret_from_fork
      0.31 ±  2%      +1.4        1.73        perf-profile.children.cycles-pp.ret_from_fork_asm
      0.30 ±  2%      +1.4        1.73        perf-profile.children.cycles-pp.kthread
      0.00            +1.6        1.64        perf-profile.children.cycles-pp.node_finalise
     44.66            +2.0       46.68        perf-profile.children.cycles-pp.__munmap
      1.47            +2.6        4.04        perf-profile.children.cycles-pp.__refill_objects_node
     33.33            +2.6       35.93        perf-profile.children.cycles-pp.__mmap_region
      2.63            +2.7        5.35        perf-profile.children.cycles-pp.__irq_exit_rcu
      1.76            +2.7        4.48        perf-profile.children.cycles-pp.__slab_free
      3.08            +2.7        5.81        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      3.13            +2.7        5.87        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.50 ±  2%      +2.9        3.41        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      1.64            +3.0        4.67        perf-profile.children.cycles-pp.refill_objects
      0.81 ±  2%      +3.2        3.98        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      2.24            +3.6        5.89        perf-profile.children.cycles-pp.__kmem_cache_free_bulk
      0.00            +3.7        3.67        perf-profile.children.cycles-pp.node_copy
      2.60            +3.9        6.46        perf-profile.children.cycles-pp.rcu_free_sheaf
      2.75            +3.9        6.69        perf-profile.children.cycles-pp.rcu_do_batch
      2.78            +4.0        6.73        perf-profile.children.cycles-pp.rcu_core
      2.82            +4.0        6.79        perf-profile.children.cycles-pp.handle_softirqs
      0.00            +4.7        4.71        perf-profile.children.cycles-pp.__prefill_sheaf_pfmemalloc
      0.00            +5.1        5.09        perf-profile.children.cycles-pp.dst_setup
      0.00            +5.5        5.47        perf-profile.children.cycles-pp.kmem_cache_prefill_sheaf
     81.39            +5.7       87.09        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     80.99            +5.9       86.88        perf-profile.children.cycles-pp.do_syscall_64
     35.17            +6.0       41.14        perf-profile.children.cycles-pp.__x64_sys_munmap
     35.04            +6.0       41.05        perf-profile.children.cycles-pp.__vm_munmap
     34.11            +6.3       40.41        perf-profile.children.cycles-pp.do_vmi_munmap
     32.45            +6.8       39.28        perf-profile.children.cycles-pp.do_vmi_align_munmap
      0.00            +6.8        6.84        perf-profile.children.cycles-pp.cp_data_write
      0.00            +6.9        6.94        perf-profile.children.cycles-pp.mas_topiary_replace
     12.75            +8.8       21.59        perf-profile.children.cycles-pp.__mmap_new_vma
      4.79           +11.2       16.02        perf-profile.children.cycles-pp.mas_store_prealloc
      8.52           +12.4       20.93        perf-profile.children.cycles-pp.mas_store_gfp
      0.00           +13.8       13.76        perf-profile.children.cycles-pp.mas_wr_spanning_store
      0.00           +14.9       14.87        perf-profile.children.cycles-pp.mas_wr_split
      8.95            -4.0        4.94        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      4.07            -1.8        2.32        perf-profile.self.cycles-pp.zap_pmd_range
      1.87 ±  3%      -1.4        0.48 ±  3%  perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      3.09            -1.4        1.72        perf-profile.self.cycles-pp.entry_SYSCALL_64
      3.04            -1.3        1.72        perf-profile.self.cycles-pp.syscall_return_via_sysret
      2.76            -1.1        1.70        perf-profile.self.cycles-pp.free_pud_range
      2.75            -0.8        1.92        perf-profile.self.cycles-pp.__mmap_region
      2.03            -0.7        1.35        perf-profile.self.cycles-pp.mas_walk
      1.14            -0.6        0.50 ±  2%  perf-profile.self.cycles-pp.mas_wr_store_type
      0.63            -0.5        0.12 ±  4%  perf-profile.self.cycles-pp.mas_update_gap
      1.26 ±  5%      -0.5        0.78 ±  6%  perf-profile.self.cycles-pp.prepend_path
      1.38            -0.4        0.94        perf-profile.self.cycles-pp.zap_pte_range
      1.46            -0.4        1.02        perf-profile.self.cycles-pp.mas_prev_slot
      1.60            -0.4        1.22        perf-profile.self.cycles-pp.mas_store_gfp
      1.57            -0.4        1.21        perf-profile.self.cycles-pp.mas_next_slot
      1.20 ±  5%      -0.4        0.85 ±  3%  perf-profile.self.cycles-pp.perf_iterate_sb
      1.20            -0.3        0.88        perf-profile.self.cycles-pp.mas_find
      1.42            -0.3        1.10        perf-profile.self.cycles-pp.memcpy_orig
      1.06            -0.3        0.73        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.84 ±  3%      -0.3        0.53 ±  3%  perf-profile.self.cycles-pp.kfree
      0.83 ±  8%      -0.3        0.53 ±  9%  perf-profile.self.cycles-pp.shmem_get_unmapped_area
      0.85 ±  3%      -0.3        0.56 ±  2%  perf-profile.self.cycles-pp.do_syscall_64
      1.20            -0.3        0.91        perf-profile.self.cycles-pp.__zap_vma_range
      0.63            -0.3        0.38 ±  2%  perf-profile.self.cycles-pp.mas_preallocate
      0.70 ±  2%      -0.2        0.46        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.59            -0.2        0.34 ±  2%  perf-profile.self.cycles-pp.__vma_start_exclude_readers
      0.59 ±  2%      -0.2        0.36 ±  3%  perf-profile.self.cycles-pp.copy_from_kernel_nofault
      0.48            -0.2        0.26        perf-profile.self.cycles-pp.__vm_munmap
      0.58            -0.2        0.37        perf-profile.self.cycles-pp.ksys_mmap_pgoff
      0.49 ±  8%      -0.2        0.28 ±  5%  perf-profile.self.cycles-pp.perf_event_mmap_output
      0.54 ±  4%      -0.2        0.33 ±  5%  perf-profile.self.cycles-pp.queue_event
      0.94 ±  4%      -0.2        0.74 ±  3%  perf-profile.self.cycles-pp.do_mmap
      0.57 ±  3%      -0.2        0.36 ±  3%  perf-profile.self.cycles-pp.fget
      0.51            -0.2        0.31 ±  2%  perf-profile.self.cycles-pp.vma_merge_new_range
      0.42            -0.2        0.22 ±  2%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.47 ±  3%      -0.2        0.27 ±  3%  perf-profile.self.cycles-pp.x64_sys_call
      0.58            -0.2        0.39        perf-profile.self.cycles-pp.up_write
      0.38            -0.2        0.20 ±  2%  perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.40            -0.2        0.23 ±  3%  perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.91 ±  5%      -0.2        0.74        perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.32 ±  2%      -0.2        0.16 ±  7%  perf-profile.self.cycles-pp.current_time
      0.62            -0.2        0.46        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.62 ±  3%      -0.2        0.46        perf-profile.self.cycles-pp.perf_event_mmap_event
      0.42 ±  3%      -0.2        0.26 ±  2%  perf-profile.self.cycles-pp.vm_area_alloc
      0.88            -0.2        0.73        perf-profile.self.cycles-pp.__mmap_new_vma
      0.51            -0.2        0.36        perf-profile.self.cycles-pp.free_p4d_range
      1.40            -0.2        1.25        perf-profile.self.cycles-pp.mas_rev_awalk
      0.38 ±  3%      -0.2        0.23 ±  2%  perf-profile.self.cycles-pp.up_read
      0.39 ±  2%      -0.1        0.24 ±  3%  perf-profile.self.cycles-pp.down_write
      0.38            -0.1        0.23 ±  2%  perf-profile.self.cycles-pp.fput
      0.53 ±  2%      -0.1        0.39 ±  5%  perf-profile.self.cycles-pp.__mmap
      0.44 ±  3%      -0.1        0.31 ±  4%  perf-profile.self.cycles-pp.d_path
      0.64 ±  2%      -0.1        0.51 ±  2%  perf-profile.self.cycles-pp.kmem_cache_free
      0.40            -0.1        0.27 ±  3%  perf-profile.self.cycles-pp.__thp_vma_allowable_orders
      0.34            -0.1        0.22 ±  2%  perf-profile.self.cycles-pp.can_vma_merge_right
      0.36            -0.1        0.22 ±  2%  perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.32 ±  3%      -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.unlink_file_vma_batch_process
      0.58            -0.1        0.47        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.22            -0.1        0.11 ±  3%  perf-profile.self.cycles-pp.unlink_anon_vmas
      0.34 ±  4%      -0.1        0.23 ±  4%  perf-profile.self.cycles-pp.touch_atime
      0.28 ±  2%      -0.1        0.16 ±  3%  perf-profile.self.cycles-pp.mmap_region
      0.33 ±  4%      -0.1        0.22 ±  3%  perf-profile.self.cycles-pp.strlen
      0.21 ±  3%      -0.1        0.10 ±  3%  perf-profile.self.cycles-pp.vma_set_page_prot
      0.35 ±  2%      -0.1        0.24 ±  2%  perf-profile.self.cycles-pp.may_expand_vm
      0.33 ±  2%      -0.1        0.22 ±  2%  perf-profile.self.cycles-pp.pte_offset_map_lock
      0.42 ±  5%      -0.1        0.32 ±  3%  perf-profile.self.cycles-pp.down_write_killable
      0.28            -0.1        0.18 ±  2%  perf-profile.self.cycles-pp.downgrade_write
      0.32 ±  3%      -0.1        0.22 ±  2%  perf-profile.self.cycles-pp._raw_spin_lock
      0.35 ±  5%      -0.1        0.25 ± 12%  perf-profile.self.cycles-pp.atime_needs_update
      0.26            -0.1        0.15 ±  2%  perf-profile.self.cycles-pp.cap_vm_enough_memory
      0.30            -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.free_pgd_range
      0.34 ±  2%      -0.1        0.24 ±  7%  perf-profile.self.cycles-pp.__munmap
      0.24            -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.freader_init_from_file
      0.24 ±  3%      -0.1        0.14 ±  9%  perf-profile.self.cycles-pp.static_key_count
      0.35 ±  2%      -0.1        0.25 ±  2%  perf-profile.self.cycles-pp.__vma_start_write
      0.35 ±  4%      -0.1        0.25 ±  7%  perf-profile.self.cycles-pp.vm_get_page_prot
      0.31            -0.1        0.21 ±  2%  perf-profile.self.cycles-pp.tlb_gather_mmu
      0.28 ±  4%      -0.1        0.18 ±  6%  perf-profile.self.cycles-pp.uprobe_mmap
      0.34            -0.1        0.25 ±  2%  perf-profile.self.cycles-pp.mmap_action_complete
      0.21 ±  2%      -0.1        0.12 ±  4%  perf-profile.self.cycles-pp.prandom_u32_state
      0.25            -0.1        0.16 ±  3%  perf-profile.self.cycles-pp.unmap_region
      0.68 ±  3%      -0.1        0.59 ±  2%  perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      1.12 ±  3%      -0.1        1.03 ±  2%  perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.33            -0.1        0.24 ±  2%  perf-profile.self.cycles-pp.__build_id_parse
      0.23 ±  3%      -0.1        0.15 ± 11%  perf-profile.self.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.20 ±  4%      -0.1        0.12 ±  8%  perf-profile.self.cycles-pp.__mmap_complete
      0.25            -0.1        0.17 ±  3%  perf-profile.self.cycles-pp.filemap_get_entry
      0.27            -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.__filemap_get_folio_mpol
      0.22 ±  2%      -0.1        0.15 ±  4%  perf-profile.self.cycles-pp.vma_interval_tree_remove
      0.09 ±  5%      -0.1        0.02 ±100%  perf-profile.self.cycles-pp.can_vma_merge_left
      0.38            -0.1        0.31        perf-profile.self.cycles-pp.free_pgtables
      0.19 ±  3%      -0.1        0.12 ±  4%  perf-profile.self.cycles-pp.remove_vma
      0.28 ±  2%      -0.1        0.21        perf-profile.self.cycles-pp.tlb_finish_mmu
      0.19 ±  3%      -0.1        0.12 ±  4%  perf-profile.self.cycles-pp.cap_capable
      0.31 ±  2%      -0.1        0.25 ±  2%  perf-profile.self.cycles-pp.userfaultfd_unmap_complete
      0.18 ±  3%      -0.1        0.12 ±  3%  perf-profile.self.cycles-pp.__x86_indirect_thunk_rax
      0.28            -0.1        0.22 ±  3%  perf-profile.self.cycles-pp.perf_event_mmap
      0.28 ±  2%      -0.1        0.22 ±  3%  perf-profile.self.cycles-pp.mas_prev
      0.08 ±  7%      -0.1        0.02 ±100%  perf-profile.self.cycles-pp.flush_tlb_batched_pending
      0.12 ±  3%      -0.1        0.07 ±  6%  perf-profile.self.cycles-pp.unlink_file_vma_batch_add
      0.15 ±  2%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.ksm_vma_flags
      0.14 ±  3%      -0.1        0.09 ±  3%  perf-profile.self.cycles-pp.__vm_enough_memory
      0.29 ±  2%      -0.1        0.24 ±  2%  perf-profile.self.cycles-pp.shmem_mmap_prepare
      0.14 ±  4%      -0.0        0.09        perf-profile.self.cycles-pp.vma_is_shared_writable
      0.15 ±  2%      -0.0        0.10        perf-profile.self.cycles-pp.__pte_offset_map
      0.20 ±  2%      -0.0        0.15        perf-profile.self.cycles-pp.mas_next_range
      0.16 ±  3%      -0.0        0.11 ±  5%  perf-profile.self.cycles-pp.ima_file_mmap
      0.19 ±  3%      -0.0        0.14 ±  3%  perf-profile.self.cycles-pp.uprobe_munmap
      0.14 ±  3%      -0.0        0.09 ±  3%  perf-profile.self.cycles-pp.mm_get_unmapped_area
      0.33            -0.0        0.28 ±  2%  perf-profile.self.cycles-pp.unmap_vmas
      0.12 ±  5%      -0.0        0.07        perf-profile.self.cycles-pp.__rb_insert_augmented
      0.12 ±  2%      -0.0        0.07 ±  6%  perf-profile.self.cycles-pp.__x64_sys_mmap
      0.23 ±  2%      -0.0        0.18 ±  3%  perf-profile.self.cycles-pp.freader_get_folio
      0.10 ±  4%      -0.0        0.06 ±  5%  perf-profile.self.cycles-pp.prepend_copy
      0.27 ±  2%      -0.0        0.22 ±  3%  perf-profile.self.cycles-pp.do_vmi_munmap
      0.19 ±  4%      -0.0        0.14 ±  3%  perf-profile.self.cycles-pp.vma_is_special_huge
      0.10 ±  5%      -0.0        0.06 ±  5%  perf-profile.self.cycles-pp.rb_next
      0.09 ±  3%      -0.0        0.06 ±  9%  perf-profile.self.cycles-pp._raw_spin_unlock
      0.10 ± 13%      -0.0        0.06 ± 19%  perf-profile.self.cycles-pp.memfd_check_seals_mmap
      0.10            -0.0        0.07 ±  4%  perf-profile.self.cycles-pp.mas_next_setup
      0.19 ±  2%      -0.0        0.16 ±  4%  perf-profile.self.cycles-pp.copy_from_kernel_nofault_allowed
      0.12 ±  2%      -0.0        0.09 ±  3%  perf-profile.self.cycles-pp.vm_unmapped_area
      0.08 ±  5%      -0.0        0.06 ±  8%  perf-profile.self.cycles-pp.prepend
      0.23            -0.0        0.21 ±  2%  perf-profile.self.cycles-pp.freader_fetch
      0.24            -0.0        0.22 ±  2%  perf-profile.self.cycles-pp.mas_wr_store_entry
      0.21 ±  3%      -0.0        0.19 ±  2%  perf-profile.self.cycles-pp.mas_prev_setup
      0.09 ±  4%      -0.0        0.07 ±  4%  perf-profile.self.cycles-pp.get_align_mask
      0.08 ±  6%      -0.0        0.06        perf-profile.self.cycles-pp.__x64_sys_munmap
      0.07 ±  7%      -0.0        0.05 ±  8%  perf-profile.self.cycles-pp.vm_area_free
      0.12 ±  4%      +0.0        0.14 ±  3%  perf-profile.self.cycles-pp.is_vmalloc_addr
      0.05 ±  6%      +0.0        0.07 ±  7%  perf-profile.self.cycles-pp.trylock_stock
      0.06 ±  9%      +0.0        0.08 ±  5%  perf-profile.self.cycles-pp.rcu_cblist_dequeue
      0.13            +0.0        0.15 ±  4%  perf-profile.self.cycles-pp.khugepaged_enter_vma
      0.06            +0.0        0.09 ±  3%  perf-profile.self.cycles-pp.__call_rcu_common
      0.04 ± 57%      +0.0        0.07        perf-profile.self.cycles-pp.mmap@plt
      0.11 ±  4%      +0.0        0.15 ±  4%  perf-profile.self.cycles-pp.security_mmap_file
      0.14 ±  7%      +0.0        0.18 ±  7%  perf-profile.self.cycles-pp.__refill_obj_stock
      0.06 ±  5%      +0.0        0.10 ±  3%  perf-profile.self.cycles-pp.__pi_memcpy
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.build_detached_freelist
      0.60 ±  3%      +0.1        0.66 ±  4%  perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.00            +0.1        0.07 ±  5%  perf-profile.self.cycles-pp.alloc_from_new_slab
      0.03 ± 77%      +0.1        0.10 ±  8%  perf-profile.self.cycles-pp.xas_load
      0.01 ±173%      +0.1        0.11 ±  4%  perf-profile.self.cycles-pp.barn_get_empty_sheaf
      0.23 ±  4%      +0.1        0.36 ±  2%  perf-profile.self.cycles-pp.__account_obj_stock
      0.32 ±  2%      +0.2        0.48        perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.00            +0.2        0.17 ±  2%  perf-profile.self.cycles-pp.mas_wr_walk_index
      0.62 ±  3%      +0.2        0.81        perf-profile.self.cycles-pp.mas_wr_walk_descend
      0.08 ±  5%      +0.2        0.27 ±  3%  perf-profile.self.cycles-pp.setup_object
      0.30            +0.3        0.55        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.53            +0.3        0.81        perf-profile.self.cycles-pp.mas_store_prealloc
      0.00            +0.4        0.36        perf-profile.self.cycles-pp.kmem_cache_return_sheaf
      0.00            +0.4        0.36        perf-profile.self.cycles-pp.mas_prev_node
      0.00            +0.5        0.47        perf-profile.self.cycles-pp.mas_next_node
      0.00            +0.5        0.52        perf-profile.self.cycles-pp.kmem_cache_alloc_from_sheaf_noprof
      0.00            +0.6        0.60        perf-profile.self.cycles-pp.mas_ascend
      0.00            +0.7        0.65        perf-profile.self.cycles-pp.multi_src_setup
      0.00            +0.7        0.71 ±  4%  perf-profile.self.cycles-pp.kmem_cache_prefill_sheaf
      1.12            +0.8        1.95        perf-profile.self.cycles-pp.__refill_objects_node
      1.18            +0.9        2.06        perf-profile.self.cycles-pp.__slab_free
      0.64            +1.3        1.94        perf-profile.self.cycles-pp.__kmem_cache_free_bulk
      0.00            +1.5        1.54        perf-profile.self.cycles-pp.node_finalise
      0.00            +2.2        2.21        perf-profile.self.cycles-pp.node_copy
      0.00            +2.7        2.66        perf-profile.self.cycles-pp.cp_data_write
      0.00            +2.9        2.88        perf-profile.self.cycles-pp.mas_wr_split
      0.50 ±  2%      +2.9        3.41        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.00            +3.5        3.53        perf-profile.self.cycles-pp.mas_wr_spanning_store
      0.00            +4.3        4.26        perf-profile.self.cycles-pp.dst_setup
      0.00            +4.3        4.34        perf-profile.self.cycles-pp.mas_topiary_replace

> 
> Let me know if it'd be better to provide a copy based off 280b792cac62d
> instead.
> 
> Thanks,
> Liam

> From 98e443b159a75a6cc34af839c122a9e5eea2fe19 Mon Sep 17 00:00:00 2001
> From: "Liam R. Howlett" <liam@infradead.org>
> Date: Fri, 15 May 2026 17:37:06 -0400
> Subject: [PATCH] maple_tree: Restore old tree layout using new scatter-gather
>  node copy
> 
> The prior bignode rebalance and split operations were greedy in getting
> data to the lower range nodes (often referred to as the left side of the
> tree).  The new scatter-gather node copy was more fair on splitting
> data, but this lead to a regression with mmap2_processes.
> 
> Restoring the greedy nature of getting data further left in the tree,
> when possible, turns out to perform better.  Note that it's not entirely
> greedy and tries to leave some room for modifications to both nodes
> later, if possible.
> 
> The decision of where to push the majority of the data is relayed as a
> 'hint' on which side to favour.  Passing around a hint turns out to
> simplify a lot of logic that was otherwise derived from the siblings max
> or size.
> 
> Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
> ---
>  include/linux/maple_tree.h |   1 +
>  lib/maple_tree.c           | 427 ++++++++++++++++++++++++++-----------
>  lib/test_maple_tree.c      |   5 +-
>  3 files changed, 305 insertions(+), 128 deletions(-)
> 
> diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
> index 4a5631906aff..c4c3b31614b0 100644
> --- a/include/linux/maple_tree.h
> +++ b/include/linux/maple_tree.h
> @@ -192,6 +192,7 @@ struct maple_copy {
>  	unsigned char d_count;
>  	unsigned char split;
>  	unsigned char data;
> +	unsigned char write_start;
>  	unsigned char height;
>  };
>  
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 60ae5e6fc1ee..b83a5b902e56 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -89,6 +89,10 @@
>   */
>  #define MA_STATE_PREALLOC	1
>  
> +#define MAPLE_DST_NEUTRAL	0
> +#define MAPLE_DST_FAVOUR_LEFT	1
> +#define MAPLE_DST_FAVOUR_RIGHT	2
> +
>  #define ma_parent_ptr(x) ((struct maple_pnode *)(x))
>  #define mas_tree_parent(x) ((unsigned long)(x->tree) | MA_ROOT_PARENT)
>  #define ma_mnode_ptr(x) ((struct maple_node *)(x))
> @@ -1720,21 +1724,26 @@ static inline void mas_wr_node_walk(struct ma_wr_state *wr_mas)
>  	wr_mas->offset_end = mas->offset = offset;
>  }
>  
> -static inline void rebalance_sib(struct ma_state *parent, struct ma_state *sib)
> +static inline unsigned char rebalance_sib(struct ma_state *parent,
> +		struct ma_state *sib)
>  {
>  	*sib = *parent;
>  	/* Prioritize move right to pull data left */
> -	if (sib->offset < sib->end)
> +	if (sib->offset < sib->end) {
>  		sib->offset++;
> -	else
> -		sib->offset--;
> +		mas_descend(sib);
> +		sib->end = mas_data_end(sib);
> +		return MAPLE_DST_FAVOUR_RIGHT;
> +	}
>  
> +	sib->offset--;
>  	mas_descend(sib);
>  	sib->end = mas_data_end(sib);
> +	return MAPLE_DST_FAVOUR_LEFT;
>  }
>  
>  static inline
> -void spanning_sib(struct ma_wr_state *l_wr_mas,
> +unsigned char spanning_sib(struct ma_wr_state *l_wr_mas,
>  		struct ma_wr_state *r_wr_mas, struct ma_state *nneighbour)
>  {
>  	struct ma_state l_tmp = *l_wr_mas->mas;
> @@ -1754,7 +1763,7 @@ void spanning_sib(struct ma_wr_state *l_wr_mas,
>  
>  			r_tmp.end = mas_data_end(&r_tmp);
>  			*nneighbour = r_tmp;
> -			return;
> +			return MAPLE_DST_FAVOUR_RIGHT;
>  		} else if (l_tmp.offset) {
>  			l_tmp.offset--;
>  			do {
> @@ -1764,11 +1773,13 @@ void spanning_sib(struct ma_wr_state *l_wr_mas,
>  
>  			l_tmp.end = l_tmp.offset;
>  			*nneighbour = l_tmp;
> -			return;
> +			return MAPLE_DST_FAVOUR_LEFT;
>  		}
>  	} while (!mte_is_root(r_tmp.node));
>  
>  	WARN_ON_ONCE(1);
> +	nneighbour->end = 0;
> +	return MAPLE_DST_NEUTRAL;
>  }
>  
>  /*
> @@ -2151,74 +2162,147 @@ static inline void cp_data_calc(struct maple_copy *cp,
>  	cp->data += r_wr_mas->mas->end - r_wr_mas->offset_end;
>  }
>  
> -static bool data_fits(struct ma_state *sib, struct ma_state *mas,
> +#define MAPLE_TEST_ALT_SIB 3
> +#define MAPLE_NO_SPACE (-1)
> +#define MAPLE_MIN_SPARE_SLOTS 2
> +
> +static int data_fits(unsigned char end, struct ma_state *mas,
>  		struct maple_copy *cp)
>  {
>  	unsigned char new_data;
>  	enum maple_type type;
>  	unsigned char space;
> -	unsigned char end;
> +	int spare_slots;
>  
> +	/*
> +	 * end is an index while cp->data/space are sizes, so a strict fit would
> +	 * allow new_data <= space.  One spare slot (new_data < space) avoids full
> +	 * pack.  Keep one more spare slot here to reduce split/rebalance churn.
> +	 */
>  	type = mte_node_type(mas->node);
>  	space = 2 * mt_slots[type];
> -	end = sib->end;
> -
>  	new_data = end + 1 + cp->data;
> -	if (new_data > space)
> -		return false;
> -
> -	/*
> -	 * This is off by one by design.  The extra space is left to reduce
> -	 * jitter in operations that add then remove two entries.
> -	 *
> -	 * end is an index while new space and data are both sizes.  Adding one
> -	 * to end to convert the index to a size means that the below
> -	 * calculation should be <=, but we want to keep an extra space in nodes
> -	 * to reduce jitter.
> -	 *
> -	 * Note that it is still possible to get a full node on the left by the
> -	 * NULL landing exactly on the split.  The NULL ending of a node happens
> -	 * in the dst_setup() function, where we will either increase the split
> -	 * by one or decrease it by one, if possible.  In the case of split
> -	 * (this case), it is always possible to shift the spilt by one - again
> -	 * because there is at least one slot free by the below checking.
> -	 */
> -	if (new_data < space)
> -		return true;
> +	spare_slots = space - new_data;
> +	if (spare_slots < MAPLE_MIN_SPARE_SLOTS)
> +		return MAPLE_NO_SPACE;
>  
> -	return false;
> +	return spare_slots;
>  }
>  
> -static inline void push_data_sib(struct maple_copy *cp, struct ma_state *mas,
> -		struct ma_state *sib, struct ma_state *parent)
> +static inline int push_data_sib_left(struct maple_copy *cp,
> +		struct ma_state *mas, struct ma_state *sib,
> +		struct ma_state *parent)
>  {
> -
> -	if (mte_is_root(mas->node))
> -		goto no_push;
> -
> +	if (!parent->offset)
> +		return MAPLE_NO_SPACE;
>  
>  	*sib = *parent;
> -	if (sib->offset) {
> -		sib->offset--;
> -		mas_descend(sib);
> -		sib->end = mas_data_end(sib);
> -		if (data_fits(sib, mas, cp))	/* Push left */
> -			return;
> +	sib->offset--;
> +	mas_descend(sib);
> +	sib->end = mas_data_end(sib);
>  
> -		*sib = *parent;
> -	}
> +	return data_fits(sib->end, mas, cp);
> +}
>  
> -	if (sib->offset >= sib->end)
> -		goto no_push;
> +static inline int push_data_sib_right(struct maple_copy *cp,
> +		struct ma_state *mas, struct ma_state *sib,
> +		struct ma_state *parent)
> +{
> +	if (parent->offset >= parent->end)
> +		return MAPLE_NO_SPACE;
>  
> +	*sib = *parent;
>  	sib->offset++;
>  	mas_descend(sib);
>  	sib->end = mas_data_end(sib);
> -	if (data_fits(sib, mas, cp))		/* Push right*/
> -		return;
>  
> -no_push:
> +	return data_fits(sib->end, mas, cp);
> +}
> +
> +static inline unsigned char push_data_sib_split(struct maple_copy *cp,
> +		struct ma_state *mas, struct ma_state *sib,
> +		struct ma_state *parent)
> +{
> +	struct ma_state left;
> +	struct ma_state right;
> +	int left_spare = MAPLE_NO_SPACE;
> +	int right_spare = MAPLE_NO_SPACE;
> +
> +	if (!mte_is_root(mas->node)) {
> +		left_spare = push_data_sib_left(cp, mas, &left, parent);
> +		if (left_spare >= MAPLE_TEST_ALT_SIB) {
> +			*sib = left;
> +			return MAPLE_DST_FAVOUR_LEFT;
> +		}
> +
> +		right_spare = push_data_sib_right(cp, mas, &right, parent);
> +
> +		if ((left_spare >= 0) && (right_spare >= 0)) {
> +			if (left.end <= right.end) {
> +				*sib = left;
> +				return MAPLE_DST_FAVOUR_LEFT;
> +			}
> +
> +			*sib = right;
> +			return MAPLE_DST_FAVOUR_RIGHT;
> +		}
> +
> +		if (left_spare >= 0) {
> +			*sib = left;
> +			return MAPLE_DST_FAVOUR_LEFT;
> +		}
> +
> +		if (right_spare >= 0) {
> +			*sib = right;
> +			return MAPLE_DST_FAVOUR_RIGHT;
> +		}
> +	}
> +
>  	sib->end = 0;
> +	return MAPLE_DST_NEUTRAL;
> +}
> +
> +static inline unsigned char push_data_sib_rebalance(struct maple_copy *cp,
> +		struct ma_state *mas, struct ma_state *sib,
> +		struct ma_state *parent)
> +{
> +	struct ma_state left;
> +	struct ma_state right;
> +	int left_spare = MAPLE_NO_SPACE;
> +	int right_spare = MAPLE_NO_SPACE;
> +
> +	if (!mte_is_root(mas->node)) {
> +		right_spare = push_data_sib_right(cp, mas, &right, parent);
> +		if (right_spare >= MAPLE_TEST_ALT_SIB) {
> +			*sib = right;
> +			return MAPLE_DST_FAVOUR_RIGHT;
> +		}
> +
> +		left_spare = push_data_sib_left(cp, mas, &left, parent);
> +
> +		if ((left_spare >= 0) && (right_spare >= 0)) {
> +			if (left.end < right.end) {
> +				*sib = left;
> +				return MAPLE_DST_FAVOUR_LEFT;
> +			}
> +
> +			*sib = right;
> +			return MAPLE_DST_FAVOUR_RIGHT;
> +		}
> +
> +		if (right_spare >= 0) {
> +			*sib = right;
> +			return MAPLE_DST_FAVOUR_RIGHT;
> +		}
> +
> +		if (left_spare >= 0) {
> +			*sib = left;
> +			return MAPLE_DST_FAVOUR_LEFT;
> +		}
> +	}
> +
> +	sib->end = 0;
> +	return MAPLE_DST_NEUTRAL;
>  }
>  
>  /*
> @@ -2232,29 +2316,27 @@ static inline void push_data_sib(struct maple_copy *cp, struct ma_state *mas,
>   * indicate it will not be used.
>   *
>   */
> -static inline void rebalance_data(struct maple_copy *cp,
> +static inline unsigned char rebalance_data(struct maple_copy *cp,
>  		struct ma_wr_state *wr_mas, struct ma_state *sib,
>  		struct ma_state *parent)
>  {
> +	unsigned char hint = MAPLE_DST_NEUTRAL;
> +
>  	cp_data_calc(cp, wr_mas, wr_mas);
>  	sib->end = 0;
> +
>  	if (cp->data > mt_slots[wr_mas->type]) {
> -		push_data_sib(cp, wr_mas->mas, sib, parent);
> -		if (sib->end)
> -			goto use_sib;
> +		hint = push_data_sib_rebalance(cp, wr_mas->mas, sib, parent);
>  	} else if (cp->data <= mt_min_slots[wr_mas->type]) {
>  		if ((wr_mas->mas->min != 0) ||
> -		    (wr_mas->mas->max != ULONG_MAX)) {
> -			rebalance_sib(parent, sib);
> -			goto use_sib;
> -		}
> +		    (wr_mas->mas->max != ULONG_MAX))
> +			hint = rebalance_sib(parent, sib);
>  	}
>  
> -	return;
> -
> -use_sib:
> +	if (hint != MAPLE_DST_NEUTRAL)
> +		cp->data += sib->end + 1;
>  
> -	cp->data += sib->end + 1;
> +	return hint;
>  }
>  
>  /*
> @@ -2267,18 +2349,64 @@ static inline void rebalance_data(struct maple_copy *cp,
>   * Note: @cp->data is a size and not indexed by 0. @sib->end may be set to 0 to
>   * indicate it will not be used.
>   */
> -static inline void spanning_data(struct maple_copy *cp,
> +static inline unsigned char spanning_data(struct maple_copy *cp,
>  		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas,
>  		struct ma_state *sib)
>  {
> +	unsigned char hint = MAPLE_DST_NEUTRAL;
> +
>  	cp_data_calc(cp, l_wr_mas, r_wr_mas);
>  	if (((l_wr_mas->mas->min != 0) || (r_wr_mas->mas->max != ULONG_MAX)) &&
>  	    (cp->data <= mt_min_slots[l_wr_mas->type])) {
> -		spanning_sib(l_wr_mas, r_wr_mas, sib);
> -		cp->data += sib->end + 1;
> +		hint = spanning_sib(l_wr_mas, r_wr_mas, sib);
> +		if (hint != MAPLE_DST_NEUTRAL)
> +			cp->data += sib->end + 1;
>  	} else {
>  		sib->end = 0;
>  	}
> +
> +	return hint;
> +}
> +
> +static inline unsigned char cp_hint_split(struct maple_copy *cp,
> +		enum maple_type mt, unsigned char hint)
> +{
> +	unsigned char min_split;
> +	unsigned char max_split;
> +	unsigned int target = cp->split;
> +
> +	/*
> +	 * Keep the original split bounds: these preserve minimum occupancy and
> +	 * leave the one-slot margin used by the NULL-end adjustment in
> +	 * cp_data_write().
> +	 */
> +	max_split = mt_slots[mt] - 1;
> +	if (cp->data - mt_min_slots[mt] - 2 < max_split)
> +		max_split = cp->data - mt_min_slots[mt] - 2;
> +
> +	min_split = mt_min_slots[mt];
> +	if (cp->data - mt_slots[mt] > min_split)
> +		min_split = cp->data - mt_slots[mt];
> +
> +	switch (hint) {
> +	case MAPLE_DST_FAVOUR_LEFT:
> +		target = mt_slots[mt] - 2;
> +		break;
> +	case MAPLE_DST_FAVOUR_RIGHT:
> +		target = min_split;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	if (target < min_split)
> +		target = min_split;
> +	if (target > max_split)
> +		target = max_split;
> +
> +	cp->split = target;
> +
> +	return cp->split;
>  }
>  
>  /*
> @@ -2286,9 +2414,11 @@ static inline void spanning_data(struct maple_copy *cp,
>   * @cp: The maple copy node
>   * @mas: The maple state
>   * @mt: The source node type
> + * @hint: Split preference from write placement and sibling side
>   */
>  static inline
> -void dst_setup(struct maple_copy *cp, struct ma_state *mas, enum maple_type mt)
> +void dst_setup(struct maple_copy *cp, struct ma_state *mas, enum maple_type mt,
> +	      unsigned char hint)
>  {
>  	/* Data is 1 indexed, every src has +1 added.  */
>  
> @@ -2300,8 +2430,10 @@ void dst_setup(struct maple_copy *cp, struct ma_state *mas, enum maple_type mt)
>  
>  	cp->split = (cp->data - 1) / 2;
>  	cp->d_count = 2;
> -	if (cp->data < mt_slots[mt] * 2)
> +	if (cp->data < mt_slots[mt] * 2) {
> +		cp_hint_split(cp, mt, hint);
>  		goto node_setup;
> +	}
>  
>  	if (cp->data == mt_slots[mt] * 2) {
>  		unsigned char off;
> @@ -2407,16 +2539,23 @@ static inline void init_cp_src(struct maple_copy *cp)
>   * @l_wr_mas: The left write maple state
>   * @r_wr_mas: The right write maple state
>   * @sib: The sibling maple state
> + * @hint: The sibling direction hint
>   *
> - * Note: @sib->end == 0 indicates no sibling will be used.
> + * Note: @hint == MAPLE_DST_NEUTRAL indicates no sibling will be used.
>   */
>  static inline
>  void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
> -		struct ma_wr_state *r_wr_mas, struct ma_state *sib)
> +		struct ma_wr_state *r_wr_mas, struct ma_state *sib,
> +		unsigned char hint)
>  {
> +	unsigned char offset = 0;
> +
>  	cp->s_count = 0;
> -	if (sib->end && sib->max < l_wr_mas->mas->min)
> +
> +	if (hint == MAPLE_DST_FAVOUR_LEFT) {
>  		append_mas_cp(cp, sib, 0, sib->end);
> +		offset += cp->src[cp->s_count - 1].end + 1;
> +	}
>  
>  	/* Copy left 0 - offset */
>  	if (l_wr_mas->mas->offset) {
> @@ -2424,8 +2563,10 @@ void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
>  
>  		append_wr_mas_cp(cp, l_wr_mas, 0, off);
>  		cp->src[cp->s_count - 1].max = cp->min - 1;
> +		offset += off + 1;
>  	}
>  
> +	cp->write_start = offset;
>  	init_cp_src(cp);
>  
>  	/* Copy right either from offset or offset + 1 pending on r_max */
> @@ -2433,7 +2574,7 @@ void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
>  		append_wr_mas_cp(cp, r_wr_mas, r_wr_mas->offset_end + 1,
>  			       r_wr_mas->mas->end);
>  
> -	if (sib->end && sib->min > r_wr_mas->mas->max)
> +	if (hint == MAPLE_DST_FAVOUR_RIGHT)
>  		append_mas_cp(cp, sib, 0, sib->end);
>  }
>  
> @@ -2506,21 +2647,51 @@ void cp_data_write(struct maple_copy *cp, struct ma_state *mas)
>  		/* Handle null entries */
>  		if (cp->dst[d].max != ULONG_MAX &&
>  		    !ma_slots(dst, d_mt)[dst_offset - 1]) {
> -			if (s_offset == cp->src[s].start) {
> -				s--;
> -				src = cp->src[s].node;
> -				src_end = cp->src[s].end;
> -				s_max = cp->src[s].max;
> -				s_mt = cp->src[s].mt;
> -				s_offset = src_end;
> +			if ((dst_offset < mt_slots[d_mt]) &&
> +			    (cp->data - data_offset > mt_min_slots[d_mt] + 1)) {
> +				d_max = node_copy(mas, src, s_offset, 1, s_max, s_mt,
> +						  dst, dst_offset, d_mt);
> +				dst_offset++;
> +				data_offset++;
> +				s_offset++;
> +				if (s_offset > src_end) {
> +					s++;
> +					if (s >= cp->s_count) {
> +						cp->dst[d].max = d_max;
> +						node_finalise(dst, d_mt,
> +							     dst_offset);
> +						return;
> +					}
> +
> +					src = cp->src[s].node;
> +					s_offset = cp->src[s].start;
> +					src_end = cp->src[s].end;
> +					s_max = cp->src[s].max;
> +					s_mt = cp->src[s].mt;
> +				}
> +
> +				cp->dst[d].max = d_max;
> +				if (WARN_ON_ONCE(!split))
> +					split = 0;
> +				else
> +					split--;
>  			} else {
> -				s_offset--;
> +				if (s_offset == cp->src[s].start) {
> +					s--;
> +					src = cp->src[s].node;
> +					src_end = cp->src[s].end;
> +					s_max = cp->src[s].max;
> +					s_mt = cp->src[s].mt;
> +					s_offset = src_end;
> +				} else {
> +					s_offset--;
> +				}
> +				/* Set dst max and clear pivot */
> +				split++;
> +				data_offset--;
> +				dst_offset--;
> +				cp->dst[d].max = ma_pivots(dst, d_mt)[dst_offset - 1];
>  			}
> -			/* Set dst max and clear pivot */
> -			split++;
> -			data_offset--;
> -			dst_offset--;
> -			cp->dst[d].max = ma_pivots(dst, d_mt)[dst_offset - 1];
>  		}
>  
>  		node_finalise(dst, d_mt, dst_offset);
> @@ -2600,7 +2771,7 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
>  
>  		cp->data = cp->d_count;
>  		cp->s_count = 0;
> -		dst_setup(cp, mas, mt);
> +		dst_setup(cp, mas, mt, MAPLE_DST_NEUTRAL);
>  		init_cp_src(cp);
>  		node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
>  			  cp->dst[0].node, 0, mt);
> @@ -2625,9 +2796,9 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
>  }
>  
>  static inline bool cp_converged(struct maple_copy *cp, struct ma_state *mas,
> -				struct ma_state *sib)
> +				unsigned char hint)
>  {
> -	if (cp->d_count != 1 || sib->end)
> +	if (cp->d_count != 1 || hint != MAPLE_DST_NEUTRAL)
>  		return false;
>  
>  	cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
> @@ -2646,14 +2817,12 @@ static inline bool cp_converged(struct maple_copy *cp, struct ma_state *mas,
>   */
>  static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
>  			    struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas,
> -			    struct ma_state *sib)
> +			    struct ma_state *sib, unsigned char hint)
>  {
> -	if (sib->end) {
> -		if (sib->max < l_wr_mas->mas->min)
> -			*l_wr_mas->mas = *sib;
> -		else
> -			*r_wr_mas->mas = *sib;
> -	}
> +	if (hint == MAPLE_DST_FAVOUR_LEFT)
> +		*l_wr_mas->mas = *sib;
> +	else if (hint == MAPLE_DST_FAVOUR_RIGHT)
> +		*r_wr_mas->mas = *sib;
>  
>  	cp_dst_to_slots(cp, l_wr_mas->mas->min, r_wr_mas->mas->max, mas);
>  	if (cp_is_new_root(cp, mas))
> @@ -2692,16 +2861,16 @@ void copy_tree_location(const struct ma_state *src, struct ma_state *dst)
>   */
>  static inline bool rebalance_ascend(struct maple_copy *cp,
>  		struct ma_wr_state *wr_mas, struct ma_state *sib,
> -		struct ma_state *parent)
> +		struct ma_state *parent, unsigned char hint)
>  {
>  	struct ma_state *mas;
>  	unsigned long min, max;
>  
>  	mas = wr_mas->mas;
> -	if (!sib->end) {
> +	if (hint == MAPLE_DST_NEUTRAL) {
>  		min = mas->min;
>  		max = mas->max;
> -	} else if (sib->min > mas->max) { /* Move right succeeded */
> +	} else if (hint == MAPLE_DST_FAVOUR_RIGHT) {
>  		min = mas->min;
>  		max = sib->max;
>  		wr_mas->offset_end = parent->offset + 1;
> @@ -2716,7 +2885,7 @@ static inline bool rebalance_ascend(struct maple_copy *cp,
>  	if (cp_is_new_root(cp, mas))
>  		return false;
>  
> -	if (cp_converged(cp, mas, sib))
> +	if (cp_converged(cp, mas, hint))
>  		return false;
>  
>  	cp->height++;
> @@ -3049,6 +3218,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
>  	struct maple_copy cp;
>  	struct ma_state *mas;
>  	struct ma_state sib;
> +	unsigned char hint;
>  
>  	/* Left and Right side of spanning store */
>  	MA_STATE(r_mas, NULL, 0, 0);
> @@ -3107,11 +3277,11 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
>  
>  	cp_leaf_init(&cp, mas, wr_mas, &r_wr_mas);
>  	do {
> -		spanning_data(&cp, wr_mas, &r_wr_mas, &sib);
> -		multi_src_setup(&cp, wr_mas, &r_wr_mas, &sib);
> -		dst_setup(&cp, mas, wr_mas->type);
> +		hint = spanning_data(&cp, wr_mas, &r_wr_mas, &sib);
> +		multi_src_setup(&cp, wr_mas, &r_wr_mas, &sib, hint);
> +		dst_setup(&cp, mas, wr_mas->type, hint);
>  		cp_data_write(&cp, mas);
> -	} while (spanning_ascend(&cp, mas, wr_mas, &r_wr_mas, &sib));
> +	} while (spanning_ascend(&cp, mas, wr_mas, &r_wr_mas, &sib, hint));
>  
>  	mas_wmb_replace(mas, &cp);
>  }
> @@ -3377,7 +3547,7 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas)
>   */
>  static inline bool split_ascend(struct maple_copy *cp,
>  		struct ma_wr_state *wr_mas, struct ma_state *sib,
> -		struct ma_state *parent)
> +		struct ma_state *parent, unsigned char hint)
>  {
>  	struct ma_state *mas;
>  	unsigned long min, max;
> @@ -3386,21 +3556,19 @@ static inline bool split_ascend(struct maple_copy *cp,
>  	min = mas->min; /* push right, or normal split */
>  	max = mas->max;
>  	wr_mas->offset_end = parent->offset;
> -	if (sib->end) {
> -		if (sib->max < mas->min) {
> -			min = sib->min; /* push left */
> -			parent->offset--;
> -		} else {
> -			max = sib->max; /* push right */
> -			wr_mas->offset_end++;
> -		}
> +	if (hint == MAPLE_DST_FAVOUR_LEFT) {
> +		min = sib->min; /* push left */
> +		parent->offset--;
> +	} else if (hint == MAPLE_DST_FAVOUR_RIGHT) {
> +		max = sib->max; /* push right */
> +		wr_mas->offset_end++;
>  	}
>  
>  	cp_dst_to_slots(cp, min, max, mas);
>  	if (cp_is_new_root(cp, mas))
>  		return false;
>  
> -	if (cp_converged(cp, mas, sib))
> +	if (cp_converged(cp, mas, hint))
>  		return false;
>  
>  	cp->height++;
> @@ -3420,19 +3588,24 @@ static inline bool split_ascend(struct maple_copy *cp,
>   * indicate it will not be used.
>   *
>   */
> -static inline void split_data(struct maple_copy *cp,
> +static inline unsigned char split_data(struct maple_copy *cp,
>  		struct ma_wr_state *wr_mas, struct ma_state *sib,
>  		struct ma_state *parent)
>  {
> +	unsigned char hint = MAPLE_DST_NEUTRAL;
> +
>  	cp_data_calc(cp, wr_mas, wr_mas);
> +
>  	if (cp->data <= mt_slots[wr_mas->type]) {
>  		sib->end = 0;
> -		return;
> +		return hint;
>  	}
>  
> -	push_data_sib(cp, wr_mas->mas, sib, parent);
> -	if (sib->end)
> +	hint = push_data_sib_split(cp, wr_mas->mas, sib, parent);
> +	if (hint != MAPLE_DST_NEUTRAL)
>  		cp->data += sib->end + 1;
> +
> +	return hint;
>  }
>  
>  /*
> @@ -3445,6 +3618,7 @@ static void mas_wr_split(struct ma_wr_state *wr_mas)
>  	struct ma_state *mas;
>  	struct maple_copy cp;
>  	struct ma_state sib;
> +	unsigned char hint;
>  
>  	mas = wr_mas->mas;
>  	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
> @@ -3455,11 +3629,11 @@ static void mas_wr_split(struct ma_wr_state *wr_mas)
>  			mas_ascend(&parent);
>  			parent.end = mas_data_end(&parent);
>  		}
> -		split_data(&cp, wr_mas, &sib, &parent);
> -		multi_src_setup(&cp, wr_mas, wr_mas, &sib);
> -		dst_setup(&cp, mas, wr_mas->type);
> +		hint = split_data(&cp, wr_mas, &sib, &parent);
> +		multi_src_setup(&cp, wr_mas, wr_mas, &sib, hint);
> +		dst_setup(&cp, mas, wr_mas->type, hint);
>  		cp_data_write(&cp, mas);
> -	} while (split_ascend(&cp, wr_mas, &sib, &parent));
> +	} while (split_ascend(&cp, wr_mas, &sib, &parent, hint));
>  
>  	mas_wmb_replace(mas, &cp);
>  }
> @@ -3478,6 +3652,7 @@ static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
>  	struct ma_state *mas;
>  	struct maple_copy cp;
>  	struct ma_state sib;
> +	unsigned char hint;
>  
>  	/*
>  	 * Rebalancing occurs if a node is insufficient.  Data is rebalanced
> @@ -3498,11 +3673,11 @@ static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
>  			mas_ascend(&parent);
>  			parent.end = mas_data_end(&parent);
>  		}
> -		rebalance_data(&cp, wr_mas, &sib, &parent);
> -		multi_src_setup(&cp, wr_mas, wr_mas, &sib);
> -		dst_setup(&cp, mas, wr_mas->type);
> +		hint = rebalance_data(&cp, wr_mas, &sib, &parent);
> +		multi_src_setup(&cp, wr_mas, wr_mas, &sib, hint);
> +		dst_setup(&cp, mas, wr_mas->type, hint);
>  		cp_data_write(&cp, mas);
> -	} while (rebalance_ascend(&cp, wr_mas, &sib, &parent));
> +	} while (rebalance_ascend(&cp, wr_mas, &sib, &parent, hint));
>  
>  	mas_wmb_replace(mas, &cp);
>  }
> diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
> index b9367c61e8b5..4033d1b85fee 100644
> --- a/lib/test_maple_tree.c
> +++ b/lib/test_maple_tree.c
> @@ -1723,9 +1723,10 @@ static noinline void __init check_gap_combining(struct maple_tree *mt)
>  	mn1 = mas.node;
>  	entry = mas_next(&mas, ULONG_MAX);
>  	MT_BUG_ON(mt, entry != xa_mk_value(index + 4));
> -	mas_next(&mas, ULONG_MAX); /* go to the next entry. */
>  	mn2 = mas.node;
> -	MT_BUG_ON(mt, mn1 == mn2); /* test the next entry is in the next node. */
> +	MT_BUG_ON(mt, mn1 == mn2);
> +	entry = mas_next(&mas, ULONG_MAX); /* go to the next entry. */
> +	MT_BUG_ON(mt, entry != xa_mk_value(index + 5));
>  
>  	/*
>  	 * At this point, there is a gap of 3 at seq100[6].  Find it by
> -- 
> 2.47.3
> 


--xUBdbXTpns5/xJ1f
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="config-7.1.0-rc4+"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 7.1.0-rc4 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-14 (Debian 14.2.0-19) 14.2.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=140200
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=24400
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=24400
CONFIG_LLD_VERSION=0
CONFIG_RUSTC_VERSION=0
CONFIG_RUSTC_LLVM_VERSION=0
CONFIG_RUSTC_LLVM_MAJOR_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT=y
CONFIG_TOOLS_SUPPORT_RELR=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_ASSUME=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_LD_CAN_USE_KEEP_IN_OVERLAY=y
CONFIG_PAHOLE_VERSION=131
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_UAPI_HEADER_TEST=y
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_BUILD_SALT="5.14.0-427.20.1.el9_4.x86_64"
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_WATCH_QUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_ARCH_WANTS_CLOCKSOURCE_READ_INLINE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST_IDLE=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CLOCKEVENTS_COUPLED=y
CONFIG_GENERIC_CLOCKEVENTS_COUPLED_INLINE=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HRTIMER_REARM_DEFERRED=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_IDLE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING_USER=y
# CONFIG_CONTEXT_TRACKING_USER_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# CONFIG_POSIX_AUX_CLOCKS is not set
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
# CONFIG_BPF_PRELOAD is not set
# CONFIG_BPF_LSM is not set
# end of BPF subsystem

CONFIG_PREEMPT_BUILD=y
CONFIG_ARCH_HAS_PREEMPT_LAZY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_LAZY=y
# CONFIG_PREEMPT_RT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
# CONFIG_PREEMPT_DYNAMIC is not set
CONFIG_SCHED_CORE=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_PSI=y
CONFIG_PSI_DEFAULT_DISABLED=y
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_NEED_TASKS_RCU=y
CONFIG_TASKS_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_DEFAULT_ALL is not set
# CONFIG_RCU_LAZY is not set
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_IKHEADERS=m
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_INDEX=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# CONFIG_SCHED_PROXY_EXEC is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
CONFIG_CC_MS_EXTENSIONS="-fms-extensions"
CONFIG_GCC10_NO_ARRAY_BOUNDS=y
CONFIG_CC_NO_ARRAY_BOUNDS=y
CONFIG_GCC_NO_STRINGOP_OVERFLOW=y
CONFIG_CC_NO_STRINGOP_OVERFLOW=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_SLAB_OBJ_EXT=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
# CONFIG_CGROUP_FAVOR_DYNMODS is not set
CONFIG_MEMCG=y
# CONFIG_MEMCG_V1 is not set
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_GROUP_SCHED_WEIGHT=y
CONFIG_GROUP_SCHED_BANDWIDTH=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_SCHED_MM_CID=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
# CONFIG_CGROUP_DMEM is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
# CONFIG_CPUSETS_V1 is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
CONFIG_CGROUP_MISC=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_TIME_NS_VDSO=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
CONFIG_BOOT_CONFIG=y
# CONFIG_BOOT_CONFIG_FORCE is not set
# CONFIG_BOOT_CONFIG_EMBED is not set
CONFIG_CMDLINE_LOG_WRAP_IDEAL_LEN=1021
CONFIG_INITRAMFS_PRESERVE_MTIME=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_LD_ORPHAN_WARN_LEVEL="warn"
CONFIG_SYSCTL=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_SMALL is not set
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_FUTEX_PRIVATE_HASH=y
CONFIG_FUTEX_MPOL=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
# CONFIG_IO_URING_MOCK_FILE is not set
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_RSEQ_SLICE_EXTENSION is not set
# CONFIG_RSEQ_STATS is not set
# CONFIG_RSEQ_DEBUG_DEFAULT_ENABLE is not set
CONFIG_CACHESTAT_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_SELFTEST is not set
CONFIG_KALLSYMS_ALL=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_GUEST_PERF_EVENTS=y
CONFIG_PERF_GUEST_MEDIATED_PMU=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y

#
# Kexec and crash features
#
CONFIG_CRASH_RESERVE=y
CONFIG_VMCORE_INFO=y
CONFIG_KEXEC_CORE=y
CONFIG_HAVE_IMA_KEXEC=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_KEXEC_SIG=y
# CONFIG_KEXEC_SIG_FORCE is not set
CONFIG_KEXEC_BZIMAGE_VERIFY_SIG=y
CONFIG_KEXEC_JUMP=y
CONFIG_CRASH_DUMP=y
# CONFIG_CRASH_DM_CRYPT is not set
CONFIG_CRASH_HOTPLUG=y
CONFIG_CRASH_MAX_MEMORY_RANGES=8192
# end of Kexec and crash features
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_AUDIT_ARCH=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
# CONFIG_AMD_SECURE_AVIC is not set
CONFIG_X86_POSTED_MSI=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_FRED=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_INTEL_MID is not set
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_XEN=y
# CONFIG_XEN_PV is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_PVHVM_GUEST=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
CONFIG_PVH=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_BHYVE_GUEST is not set
CONFIG_INTEL_TDX_GUEST=y
CONFIG_CC_HAS_MARCH_NATIVE=y
# CONFIG_X86_NATIVE_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_HAVE_PAE=y
CONFIG_X86_CX8=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_BROADCAST_TLB_FLUSH=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_BOOT_VESA_SUPPORT=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_ACPI_MADT_WAKEUP=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
CONFIG_PERF_EVENTS_AMD_POWER=m
CONFIG_PERF_EVENTS_AMD_UNCORE=y
CONFIG_PERF_EVENTS_AMD_BRS=y
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_LATE_LOADING=y
# CONFIG_MICROCODE_LATE_FORCE_MINREV is not set
# CONFIG_MICROCODE_DBG is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_X86_CPA_STATISTICS=y
CONFIG_X86_MEM_ENCRYPT=y
CONFIG_AMD_MEM_ENCRYPT=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
CONFIG_X86_CET=y
CONFIG_X86_KERNEL_IBT=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_ARCH_PKEY_BITS=4
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_X86_SGX=y
# CONFIG_X86_USER_SHADOW_STACK is not set
# CONFIG_INTEL_TDX_HOST is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_HANDOVER_PROTOCOL=y
CONFIG_EFI_MIXED=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_ARCH_SUPPORTS_KEXEC=y
CONFIG_ARCH_SUPPORTS_KEXEC_FILE=y
CONFIG_ARCH_SELECTS_KEXEC_FILE=y
CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY=y
CONFIG_ARCH_SUPPORTS_KEXEC_SIG=y
CONFIG_ARCH_SUPPORTS_KEXEC_SIG_FORCE=y
CONFIG_ARCH_SUPPORTS_KEXEC_BZIMAGE_VERIFY_SIG=y
CONFIG_ARCH_SUPPORTS_KEXEC_JUMP=y
CONFIG_ARCH_SUPPORTS_KEXEC_HANDOVER=y
CONFIG_ARCH_SUPPORTS_CRASH_DUMP=y
CONFIG_ARCH_DEFAULT_CRASH_DUMP=y
CONFIG_ARCH_SUPPORTS_CRASH_HOTPLUG=y
CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
CONFIG_LEGACY_VSYSCALL_XONLY=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
# CONFIG_STRICT_SIGALTSTACK_SIZE is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
CONFIG_HAVE_KLP_BUILD=y
CONFIG_KLP_BUILD=y
CONFIG_X86_BUS_LOCK_DETECT=y
# end of Processor type and features

CONFIG_CC_HAS_NAMED_AS=y
CONFIG_CC_HAS_NAMED_AS_FIXED_SANITIZERS=y
CONFIG_USE_X86_SEG_SUPPORT=y
CONFIG_CC_HAS_SLS=y
CONFIG_CC_HAS_RETURN_THUNK=y
CONFIG_CC_HAS_ENTRY_PADDING=y
CONFIG_FUNCTION_PADDING_CFI=11
CONFIG_FUNCTION_PADDING_BYTES=16
CONFIG_CALL_PADDING=y
CONFIG_HAVE_CALL_THUNKS=y
CONFIG_CALL_THUNKS=y
CONFIG_PREFIX_SYMBOLS=y
CONFIG_CPU_MITIGATIONS=y
CONFIG_MITIGATION_PAGE_TABLE_ISOLATION=y
CONFIG_MITIGATION_RETPOLINE=y
CONFIG_MITIGATION_RETHUNK=y
CONFIG_MITIGATION_UNRET_ENTRY=y
CONFIG_MITIGATION_CALL_DEPTH_TRACKING=y
# CONFIG_CALL_THUNKS_DEBUG is not set
CONFIG_MITIGATION_IBPB_ENTRY=y
CONFIG_MITIGATION_IBRS_ENTRY=y
CONFIG_MITIGATION_SRSO=y
# CONFIG_MITIGATION_SLS is not set
CONFIG_MITIGATION_GDS=y
CONFIG_MITIGATION_RFDS=y
CONFIG_MITIGATION_SPECTRE_BHI=y
CONFIG_MITIGATION_MDS=y
CONFIG_MITIGATION_TAA=y
CONFIG_MITIGATION_MMIO_STALE_DATA=y
CONFIG_MITIGATION_L1TF=y
CONFIG_MITIGATION_RETBLEED=y
CONFIG_MITIGATION_SPECTRE_V1=y
CONFIG_MITIGATION_SPECTRE_V2=y
CONFIG_MITIGATION_SRBDS=y
CONFIG_MITIGATION_SSB=y
CONFIG_MITIGATION_ITS=y
CONFIG_MITIGATION_TSA=y
CONFIG_MITIGATION_VMSCAPE=y
CONFIG_ARCH_HAS_ADD_PAGES=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_HIBERNATION_COMP_LZO=y
CONFIG_HIBERNATION_DEF_COMP="lzo"
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_USERSPACE_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_QOS_CPU_SYSTEM_WAKEUP is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
CONFIG_PM_GENERIC_DOMAINS=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_PM_GENERIC_DOMAINS_SLEEP=y
CONFIG_ENERGY_MODEL=y
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
CONFIG_ACPI_TABLE_LIB=y
CONFIG_ACPI_THERMAL_LIB=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_PLATFORM_PROFILE=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NHLT=y
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_HMAT=y
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_EINJ_CXL=y
# CONFIG_ACPI_APEI_GHES_NVIDIA is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_ACPI_DPTF=y
CONFIG_DPTF_POWER=m
CONFIG_DPTF_PCH_FIVR=m
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_ACPI_PFRUT=m
CONFIG_ACPI_PCC=y
CONFIG_ACPI_FFH=y
CONFIG_ACPI_MRRM=y
CONFIG_PMIC_OPREGION=y
CONFIG_ACPI_VIOT=y
CONFIG_ACPI_PRMT=y
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_AMD_PSTATE=y
CONFIG_X86_AMD_PSTATE_DEFAULT_MODE=3
# CONFIG_X86_AMD_PSTATE_DYNAMIC_EPP is not set
CONFIG_X86_AMD_PSTATE_UT=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPUFREQ_ARCH_CUR_FREQ=y
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
CONFIG_CPU_IDLE_GOV_HALTPOLL=y
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_AMD_NODE=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
# CONFIG_IA32_EMULATION is not set
# CONFIG_X86_X32_ABI is not set
# end of Binary Emulations

CONFIG_KVM_COMMON=y
CONFIG_HAVE_KVM_PFNCACHE=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_DIRTY_RING=y
CONFIG_HAVE_KVM_DIRTY_RING_TSO=y
CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_READONLY_MEM=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY=y
CONFIG_HAVE_KVM_IRQ_BYPASS=m
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_VIRT_XFER_TO_GUEST_WORK=y
CONFIG_HAVE_KVM_PM_NOTIFIER=y
CONFIG_KVM_GENERIC_HARDWARE_ENABLING=y
CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG=y
CONFIG_KVM_MMU_LOCKLESS_AGING=y
CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES=y
CONFIG_KVM_GUEST_MEMFD=y
CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE=y
CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=y
CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM_X86=m
CONFIG_KVM=m
# CONFIG_KVM_WERROR is not set
# CONFIG_KVM_SW_PROTECTED_VM is not set
CONFIG_KVM_INTEL=m
# CONFIG_KVM_INTEL_PROVE_VE is not set
CONFIG_X86_SGX_KVM=y
CONFIG_KVM_AMD=m
CONFIG_KVM_AMD_SEV=y
CONFIG_KVM_IOAPIC=y
CONFIG_KVM_SMM=y
CONFIG_KVM_HYPERV=y
# CONFIG_KVM_XEN is not set
# CONFIG_KVM_PROVE_MMU is not set
CONFIG_KVM_MAX_NR_VCPUS=4096
CONFIG_X86_REQUIRED_FEATURE_ALWAYS=y
CONFIG_X86_REQUIRED_FEATURE_NOPL=y
CONFIG_X86_REQUIRED_FEATURE_CX8=y
CONFIG_X86_REQUIRED_FEATURE_CMOV=y
CONFIG_X86_REQUIRED_FEATURE_CPUID=y
CONFIG_X86_REQUIRED_FEATURE_FPU=y
CONFIG_X86_REQUIRED_FEATURE_PAE=y
CONFIG_X86_REQUIRED_FEATURE_PSE=y
CONFIG_X86_REQUIRED_FEATURE_PGE=y
CONFIG_X86_REQUIRED_FEATURE_MSR=y
CONFIG_X86_REQUIRED_FEATURE_FXSR=y
CONFIG_X86_REQUIRED_FEATURE_XMM=y
CONFIG_X86_REQUIRED_FEATURE_XMM2=y
CONFIG_X86_REQUIRED_FEATURE_LM=y
CONFIG_X86_DISABLED_FEATURE_VME=y
CONFIG_X86_DISABLED_FEATURE_K6_MTRR=y
CONFIG_X86_DISABLED_FEATURE_CYRIX_ARR=y
CONFIG_X86_DISABLED_FEATURE_CENTAUR_MCR=y
CONFIG_X86_DISABLED_FEATURE_LAM=y
CONFIG_X86_DISABLED_FEATURE_XENPV=y
CONFIG_X86_DISABLED_FEATURE_USER_SHSTK=y
CONFIG_AS_WRUSS=y
CONFIG_ARCH_CONFIGURES_CPU_MITIGATIONS=y
CONFIG_ARCH_HAS_DMA_OPS=y

#
# General architecture-dependent options
#
CONFIG_HOTPLUG_SMT=y
CONFIG_ARCH_SUPPORTS_SCHED_SMT=y
CONFIG_ARCH_SUPPORTS_SCHED_CLUSTER=y
CONFIG_ARCH_SUPPORTS_SCHED_MC=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_CLUSTER=y
CONFIG_SCHED_MC=y
CONFIG_HOTPLUG_CORE_SYNC=y
CONFIG_HOTPLUG_CORE_SYNC_DEAD=y
CONFIG_HOTPLUG_CORE_SYNC_FULL=y
CONFIG_HOTPLUG_SPLIT_STARTUP=y
CONFIG_HOTPLUG_PARALLEL=y
CONFIG_GENERIC_IRQ_ENTRY=y
CONFIG_GENERIC_SYSCALL=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_KRETPROBE_ON_RETHOOK=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_ARCH_HAS_CPU_FINALIZE_INIT=y
CONFIG_ARCH_HAS_CPU_PASID=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_RUST=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_UNWIND_USER=y
CONFIG_HAVE_UNWIND_USER_FP=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_MMU_GATHER_MERGE_VMAS=y
CONFIG_ARCH_WANT_IRQS_OFF_ACTIVATE_MM=y
CONFIG_MMU_LAZY_TLB_REFCOUNT=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_ARCH_HAVE_EXTRA_ELF_NOTES=y
CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_KSTACK_ERASE=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_ARCH_SUPPORTS_AUTOFDO_CLANG=y
CONFIG_ARCH_SUPPORTS_PROPELLER_CLANG=y
CONFIG_ARCH_SUPPORTS_CFI=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING_USER=y
CONFIG_HAVE_CONTEXT_TRACKING_USER_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_PV_STEAL_CLOCK_GEN=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_HUGE_VMALLOC=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_PMD_MKWRITE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_ARCH_HAS_EXECMEM_ROX=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_PAGE_SIZE_4KB=y
CONFIG_PAGE_SIZE_4KB=y
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_PAGE_SHIFT=12
CONFIG_HAVE_OBJTOOL=y
CONFIG_HAVE_JUMP_LABEL_HACK=y
CONFIG_HAVE_NOINSTR_HACK=y
CONFIG_HAVE_NOINSTR_VALIDATION=y
CONFIG_HAVE_UACCESS_VALIDATION=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_ARCH_SUPPORTS_RT=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_ARCH_HAS_CPU_RESCTRL=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_ARCH_HAS_CC_PLATFORM=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SUPPORTS_PAGE_TABLE_CHECK=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
CONFIG_DYNAMIC_SIGFRAME=y
CONFIG_HAVE_ARCH_NODE_DEV_GROUP=y
CONFIG_ARCH_HAS_HW_PTE_YOUNG=y
CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG=y
CONFIG_ARCH_HAS_KERNEL_FPU_SUPPORT=y
CONFIG_ARCH_VMLINUX_NEEDS_RELOCS=y
CONFIG_HAVE_GENERIC_TIF_BITS=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
CONFIG_FUNCTION_ALIGNMENT_4B=y
CONFIG_FUNCTION_ALIGNMENT_16B=y
CONFIG_FUNCTION_ALIGNMENT=16
CONFIG_CC_HAS_MIN_FUNCTION_ALIGNMENT=y
CONFIG_CC_HAS_SANE_FUNCTION_ALIGNMENT=y
CONFIG_ARCH_HAS_CPU_ATTACK_VECTORS=y
CONFIG_HAVE_ARCH_GET_SECUREBOOT=y
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
# CONFIG_MODULE_DEBUG is not set
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
CONFIG_MODULE_SIG_SHA512=y
# CONFIG_MODULE_SIG_SHA3_256 is not set
# CONFIG_MODULE_SIG_SHA3_384 is not set
# CONFIG_MODULE_SIG_SHA3_512 is not set
CONFIG_MODULE_SIG_HASH="sha512"
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/usr/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLOCK_LEGACY_AUTOLOAD=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_CGROUP_PUNT_BIO=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_ICQ=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_WRITE_MOUNTED=y
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
CONFIG_BLK_CGROUP_IOLATENCY=y
CONFIG_BLK_CGROUP_FC_APPID=y
# CONFIG_BLK_CGROUP_IOCOST is not set
# CONFIG_BLK_CGROUP_IOPRIO is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLK_PM=y
CONFIG_BLOCK_HOLDER_DEPRECATED=y
CONFIG_BLK_MQ_STACKING=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SWAP=y
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_DEFAULT_ON is not set
# CONFIG_ZSWAP_SHRINKER_DEFAULT_ON is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSMALLOC=y

#
# Zsmalloc allocator options
#

#
# Zsmalloc is a common backend allocator for zswap & zram
#
CONFIG_ZSMALLOC_STAT=y
CONFIG_ZSMALLOC_CHAIN_SIZE=8
# end of Zsmalloc allocator options

#
# Slab allocator options
#
CONFIG_SLUB=y
CONFIG_KVFREE_RCU_BATCHED=y
# CONFIG_SLUB_TINY is not set
# CONFIG_SLAB_MERGE_DEFAULT is not set
CONFIG_SLAB_FREELIST_RANDOM=y
CONFIG_SLAB_FREELIST_HARDENED=y
CONFIG_SLAB_BUCKETS=y
# CONFIG_SLUB_STATS is not set
# CONFIG_RANDOM_KMALLOC_CACHES is not set
# end of Slab allocator options

CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_SPARSEMEM_VMEMMAP_PREINIT=y
CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP=y
CONFIG_ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP=y
CONFIG_ARCH_WANT_HUGETLB_VMEMMAP_PREINIT=y
CONFIG_HAVE_GUP_FAST=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE=y
# CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_AUTO is not set
# CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_KERNEL is not set
# CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y
CONFIG_SPLIT_PTE_PTLOCKS=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_SPLIT_PMD_PTLOCKS=y
CONFIG_BALLOON=y
CONFIG_BALLOON_MIGRATION=y
CONFIG_COMPACTION=y
CONFIG_COMPACT_UNEVICTABLE_DEFAULT=1
CONFIG_PAGE_REPORTING=y
CONFIG_NUMA_MIGRATION=y
CONFIG_MIGRATION=y
CONFIG_DEVICE_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PCP_BATCH_SCALE_MAX=5
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_WANTS_THP_SWAP=y
# CONFIG_PERSISTENT_HUGE_ZERO_FOLIO is not set
CONFIG_MM_ID=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_TRANSPARENT_HUGEPAGE_NEVER is not set
CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER=y
# CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ALWAYS is not set
# CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_WITHIN_SIZE is not set
# CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ADVISE is not set
CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER=y
# CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS is not set
# CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_WITHIN_SIZE is not set
# CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ADVISE is not set
CONFIG_THP_SWAP=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
# CONFIG_NO_PAGE_MAPCOUNT is not set
CONFIG_PAGE_MAPCOUNT=y
CONFIG_PGTABLE_HAS_HUGE_LEAVES=y
CONFIG_HAVE_GIGANTIC_FOLIOS=y
CONFIG_ASYNC_KERNEL_PGTABLE_FREE=y
CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP=y
CONFIG_ARCH_SUPPORTS_PMD_PFNMAP=y
CONFIG_ARCH_SUPPORTS_PUD_PFNMAP=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_SYSFS=y
CONFIG_CMA_AREAS=7
CONFIG_PAGE_BLOCK_MAX_ORDER=10
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_ZONE_DMA_SET=y
CONFIG_ZONE_DMA=y
CONFIG_ZONE_DMA32=y
CONFIG_ZONE_DEVICE=y
CONFIG_HMM_MIRROR=y
CONFIG_GET_FREE_REGION=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
CONFIG_ARCH_USES_PG_ARCH_2=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_TEST is not set
# CONFIG_DMAPOOL_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_MAPPING_DIRTY_HELPERS=y
CONFIG_MEMFD_CREATE=y
CONFIG_SECRETMEM=y
# CONFIG_ANON_VMA_NAME is not set
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
CONFIG_USERFAULTFD=y
# CONFIG_PTE_MARKER_UFFD_WP is not set
CONFIG_LRU_GEN=y
CONFIG_LRU_GEN_ENABLED=y
# CONFIG_LRU_GEN_STATS is not set
CONFIG_LRU_GEN_WALKS_MMU=y
CONFIG_ARCH_SUPPORTS_PER_VMA_LOCK=y
CONFIG_PER_VMA_LOCK=y
CONFIG_LOCK_MM_AND_FIND_VMA=y
CONFIG_IOMMU_MM_DATA=y
CONFIG_EXECMEM=y
CONFIG_NUMA_MEMBLKS=y
CONFIG_NUMA_EMU=y
CONFIG_PT_RECLAIM=y

#
# Data Access Monitoring
#
CONFIG_DAMON=y
# CONFIG_DAMON_DEBUG_SANITY is not set
CONFIG_DAMON_VADDR=y
CONFIG_DAMON_PADDR=y
CONFIG_DAMON_SYSFS=y
CONFIG_DAMON_RECLAIM=y
# CONFIG_DAMON_LRU_SORT is not set
# CONFIG_DAMON_STAT is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_NET_XGRESS=y
CONFIG_NET_REDIRECT=y
CONFIG_SKB_DECRYPTED=y
CONFIG_SKB_EXTENSIONS=y
CONFIG_NET_DEVMEM=y
CONFIG_NET_SHAPER=y
CONFIG_NET_CRC32C=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
# CONFIG_INET_PSP is not set
CONFIG_UNIX=y
CONFIG_AF_UNIX_OOB=y
CONFIG_UNIX_DIAG=y
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_INTERFACE=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_XFRM_IPTFS is not set
CONFIG_XFRM_ESPINTCP=y
# CONFIG_DIBS is not set
CONFIG_XDP_SOCKETS=y
CONFIG_XDP_SOCKETS_DIAG=m
CONFIG_NET_HANDSHAKE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
CONFIG_INET_ESPINTCP=y
CONFIG_INET_IPCOMP=m
CONFIG_INET_TABLE_PERTURB_ORDER=16
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_INET_RAW_DIAG=y
CONFIG_INET_DIAG_DESTROY=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
CONFIG_TCP_CONG_NV=m
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_AO is not set
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
CONFIG_INET6_ESPINTCP=y
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
CONFIG_IPV6_SEG6_HMAC=y
CONFIG_IPV6_SEG6_BPF=y
# CONFIG_IPV6_RPL_LWTUNNEL is not set
# CONFIG_IPV6_IOAM6_LWTUNNEL is not set
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=y
CONFIG_MPTCP_IPV6=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_EGRESS=y
CONFIG_NETFILTER_SKIP_EGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
CONFIG_NETFILTER_BPF_LINK=y
CONFIG_NETFILTER_NETLINK_HOOK=m
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_SYSLOG=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CONNTRACK_OVS=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NF_NAT_OVS=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
# CONFIG_NFT_EXTHDR_DCCP is not set
CONFIG_NFT_FLOW_OFFLOAD=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
CONFIG_NFT_TUNNEL=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
CONFIG_NFT_XFRM=m
CONFIG_NFT_SOCKET=m
CONFIG_NFT_OSF=m
CONFIG_NFT_TPROXY=m
CONFIG_NFT_SYNPROXY=m
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
CONFIG_NFT_REJECT_NETDEV=m
CONFIG_NF_FLOW_TABLE_INET=m
CONFIG_NF_FLOW_TABLE=m
CONFIG_NF_FLOW_TABLE_PROCFS=y
CONFIG_NETFILTER_XTABLES=y
# CONFIG_NETFILTER_XTABLES_LEGACY is not set

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_MH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m
# CONFIG_IP_VS_TWOS is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_NFT_COMPAT_ARP=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
CONFIG_NFT_BRIDGE_META=m
CONFIG_NFT_BRIDGE_REJECT=m
CONFIG_NF_CONNTRACK_BRIDGE=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA256=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_MEDIA_IB=y
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=m
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_CBS=m
CONFIG_NET_SCH_ETF=m
CONFIG_NET_SCH_MQPRIO_LIB=m
CONFIG_NET_SCH_TAPRIO=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_CAKE=m
CONFIG_NET_SCH_FQ=m
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=m
# CONFIG_NET_SCH_PLUG is not set
CONFIG_NET_SCH_ETS=m
# CONFIG_NET_SCH_DUALPI2 is not set
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_ACT_MPLS=m
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
# CONFIG_NET_ACT_CONNMARK is not set
CONFIG_NET_ACT_CTINFO=m
# CONFIG_NET_ACT_SKBMOD is not set
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
CONFIG_NET_ACT_CT=m
# CONFIG_NET_ACT_GATE is not set
CONFIG_NET_TC_SKB_EXT=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_OPENVSWITCH_GENEVE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_NETLINK_DIAG=y
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
CONFIG_HSR=m
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
CONFIG_QRTR=m
# CONFIG_QRTR_TUN is not set
CONFIG_QRTR_MHI=m
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_MAX_SKB_FRAGS=17
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
CONFIG_CAN_J1939=m
CONFIG_CAN_ISOTP=m
CONFIG_BT=m
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m
CONFIG_BT_LE=y
CONFIG_BT_LE_L2CAP_ECRED=y
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_MSFTEXT is not set
# CONFIG_BT_AOSPEXT is not set
CONFIG_BT_DEBUGFS=y
# CONFIG_BT_SELFTEST is not set

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=m
CONFIG_BT_BCM=m
CONFIG_BT_RTL=m
CONFIG_BT_MTK=m
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTUSB_AUTOSUSPEND=y
CONFIG_BT_HCIBTUSB_POLL_SYNC=y
CONFIG_BT_HCIBTUSB_BCM=y
CONFIG_BT_HCIBTUSB_MTK=y
CONFIG_BT_HCIBTUSB_RTL=y
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
CONFIG_BT_HCIBCM203X=m
# CONFIG_BT_HCIBCM4377 is not set
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_BT_ATH3K=m
# CONFIG_BT_MTKSDIO is not set
# CONFIG_BT_VIRTIO is not set
# CONFIG_BT_INTEL_PCIE is not set
# end of Bluetooth device drivers

CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_IPV6=y
# CONFIG_AF_RXRPC_INJECT_LOSS is not set
# CONFIG_AF_RXRPC_INJECT_RX_DELAY is not set
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
# CONFIG_RXGK is not set
CONFIG_RXPERF=m
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
# CONFIG_MCTP is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
CONFIG_PAGE_POOL_STATS=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y

#
# Device Drivers
#
CONFIG_HAVE_PCI=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
CONFIG_PCIE_PTM=y
CONFIG_PCIE_EDR=y
CONFIG_PCI_MSI=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
CONFIG_PCI_ATS=y
CONFIG_PCI_IDE=y
CONFIG_PCI_TSM=y
CONFIG_PCI_DOE=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_NPEM is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCIE_TPH is not set
CONFIG_PCI_P2PDMA=y
CONFIG_PCI_LABEL=y
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_OCTEONEP is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y

#
# Cadence-based PCIe controllers
#
# end of Cadence-based PCIe controllers

#
# DesignWare-based PCIe controllers
#
# CONFIG_PCI_MESON is not set
# CONFIG_PCIE_DW_PLAT_HOST is not set
# end of DesignWare-based PCIe controllers

#
# Mobiveil-based PCIe controllers
#
# end of Mobiveil-based PCIe controllers

#
# PLDA-based PCIe controllers
#
# end of PLDA-based PCIe controllers
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_PCI_PWRCTRL_GENERIC is not set
# CONFIG_PCI_PWRCTRL_TC9563 is not set
CONFIG_CXL_BUS=m
CONFIG_CXL_PCI=m
# CONFIG_CXL_MEM_RAW_COMMANDS is not set
CONFIG_CXL_ACPI=m
CONFIG_CXL_PMEM=m
CONFIG_CXL_MEM=m
# CONFIG_CXL_FEATURES is not set
CONFIG_CXL_PORT=m
CONFIG_CXL_SUSPEND=y
CONFIG_CXL_REGION=y
# CONFIG_CXL_REGION_INVALIDATION_TEST is not set
CONFIG_CXL_MCE=y
CONFIG_CXL_RAS=y
CONFIG_CXL_ATL=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_RAPIDIO is not set
# CONFIG_PC104 is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_DEVTMPFS_SAFE=y
CONFIG_DRIVER_DEFERRED_PROBE_TIMEOUT=10
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_DEBUG=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
CONFIG_FW_LOADER_COMPRESS=y
CONFIG_FW_LOADER_COMPRESS_XZ=y
CONFIG_FW_LOADER_COMPRESS_ZSTD=y
CONFIG_FW_CACHE=y
CONFIG_FW_UPLOAD=y
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
CONFIG_HMEM_REPORTING=y
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_DEVICES=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_REGMAP_IRQ=y
CONFIG_REGMAP_SOUNDWIRE=m
CONFIG_REGMAP_SOUNDWIRE_MBQ=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# CONFIG_FW_DEVLINK_SYNC_STATE_TIMEOUT is not set
# end of Generic Driver Options

#
# Bus devices
#
CONFIG_MHI_BUS=m
# CONFIG_MHI_BUS_DEBUG is not set
CONFIG_MHI_BUS_PCI_GENERIC=m
# CONFIG_MHI_BUS_EP is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
CONFIG_SYSFB=y
# CONFIG_SYSFB_SIMPLEFB is not set
CONFIG_FW_CS_DSP=m
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_SOFT_RESERVE=y
CONFIG_EFI_DXE_MEM_ATTRIBUTES=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
CONFIG_EFI_RCI2_TABLE=y
# CONFIG_EFI_DISABLE_PCI_DMA is not set
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y
# CONFIG_EFI_DISABLE_RUNTIME is not set
CONFIG_EFI_COCO_SECRET=y
# CONFIG_OVMF_DEBUG_LOG is not set
CONFIG_UNACCEPTED_MEMORY=y
CONFIG_EFI_SBAT_FILE=""
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y

#
# Qualcomm firmware drivers
#
# end of Qualcomm firmware drivers

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

# CONFIG_FWCTL is not set
CONFIG_GNSS=m
# CONFIG_GNSS_USB is not set
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set

#
# Partition parsers
#
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set

#
# Note that in some cases UBI block is preferred. See MTD_UBI_BLOCK.
#
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PLATRAM is not set
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_MCHP23K256 is not set
# CONFIG_MTD_MCHP48L640 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set
# CONFIG_MTD_INTEL_DG is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# end of Self-contained MTD device drivers

#
# NAND
#
# CONFIG_MTD_ONENAND is not set
# CONFIG_MTD_RAW_NAND is not set
# CONFIG_MTD_SPI_NAND is not set

#
# ECC engine support
#
# CONFIG_MTD_NAND_ECC_SW_HAMMING is not set
# CONFIG_MTD_NAND_ECC_SW_BCH is not set
# CONFIG_MTD_NAND_ECC_MXIC is not set
# end of ECC engine support
# end of NAND

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# end of LPDDR & LPDDR2 PCM memory drivers

# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_MTD_UBI_NVMEM is not set
# CONFIG_MTD_HYPERBUS is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=m
# CONFIG_ZRAM_BACKEND_LZ4 is not set
# CONFIG_ZRAM_BACKEND_LZ4HC is not set
# CONFIG_ZRAM_BACKEND_ZSTD is not set
# CONFIG_ZRAM_BACKEND_DEFLATE is not set
# CONFIG_ZRAM_BACKEND_842 is not set
CONFIG_ZRAM_BACKEND_FORCE_LZO=y
CONFIG_ZRAM_BACKEND_LZO=y
CONFIG_ZRAM_DEF_COMP_LZORLE=y
# CONFIG_ZRAM_DEF_COMP_LZO is not set
CONFIG_ZRAM_DEF_COMP="lzo-rle"
CONFIG_ZRAM_WRITEBACK=y
# CONFIG_ZRAM_TRACK_ENTRY_ACTIME is not set
# CONFIG_ZRAM_MEMORY_TRACKING is not set
# CONFIG_ZRAM_MULTI_COMP is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_UBLK is not set
# CONFIG_BLK_DEV_ZONED_LOOP is not set

#
# NVME Support
#
CONFIG_NVME_AUTH=m
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
CONFIG_NVME_VERBOSE_ERRORS=y
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
CONFIG_NVME_RDMA=m
CONFIG_NVME_FC=m
CONFIG_NVME_TCP=m
# CONFIG_NVME_TCP_TLS is not set
# CONFIG_NVME_HOST_AUTH is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_DEBUGFS is not set
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
CONFIG_NVME_TARGET_RDMA=m
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
CONFIG_NVME_TARGET_TCP=m
# CONFIG_NVME_TARGET_TCP_TLS is not set
CONFIG_NVME_TARGET_AUTH=y
# CONFIG_NVME_TARGET_AUTH_DEBUG is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_RPMB is not set
# CONFIG_TI_FPC202 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
# CONFIG_NTSYNC is not set
# CONFIG_NSM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# CONFIG_EEPROM_M24LR is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_INTEL_MEI_GSC=m
# CONFIG_INTEL_MEI_CSC is not set
# CONFIG_INTEL_MEI_VSC_HW is not set
# CONFIG_INTEL_MEI_HDCP is not set
# CONFIG_INTEL_MEI_PXP is not set
CONFIG_INTEL_MEI_GSC_PROXY=m
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
CONFIG_MISC_RTSX_USB=m
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
CONFIG_PVPANIC_MMIO=m
# CONFIG_PVPANIC_PCI is not set
# CONFIG_GP_PCI1XXXX is not set
# CONFIG_KEBA_CP500 is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_BLK_DEV_BSG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
# CONFIG_SCSI_CXGB3_ISCSI is not set
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=m
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPI3MR=m
CONFIG_SCSI_SMARTPQI=m
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
CONFIG_VMWARE_PVSCSI=m
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=m
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_QEDI=m
CONFIG_QEDF=m
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
# CONFIG_SCSI_EFCT is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
CONFIG_SCSI_CHELSIO_FCOE=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_AHCI_DWC is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_PARPORT is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_BITMAP=y
# CONFIG_MD_LLBITMAP is not set
CONFIG_MD_AUTODETECT=y
CONFIG_MD_BITMAP_FILE=y
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_CLUSTER is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_MULTIPATH_HST=m
CONFIG_DM_MULTIPATH_IOA=m
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG=y
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING is not set
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING is not set
CONFIG_DM_VERITY_FEC=y
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
# CONFIG_DM_ZONED is not set
CONFIG_DM_AUDIT=y
# CONFIG_DM_VDO is not set
# CONFIG_DM_PCACHE is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
CONFIG_ISCSI_TARGET_CXGB4=m
# CONFIG_REMOTE_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
CONFIG_WIREGUARD=m
# CONFIG_WIREGUARD_DEBUG is not set
# CONFIG_OVPN is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_IPVLAN_L3S=y
CONFIG_IPVLAN=m
CONFIG_IPVTAP=m
CONFIG_VXLAN=m
CONFIG_GENEVE=m
CONFIG_BAREUDP=m
# CONFIG_GTP is not set
# CONFIG_PFCP is not set
# CONFIG_AMT is not set
CONFIG_MACSEC=m
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
# CONFIG_NETCONSOLE_EXTENDED_LOG is not set
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_NTB_NETDEV=m
CONFIG_TUN=m
CONFIG_TAP=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
CONFIG_NLMON=m
# CONFIG_NETKIT is not set
CONFIG_NET_VRF=m
CONFIG_VSOCKMON=m
CONFIG_MHI_NET=m
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=m
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_AGERE is not set
# CONFIG_NET_VENDOR_ALACRITECH is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
CONFIG_ENA_ETHERNET=m
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_AMD_XGBE=m
# CONFIG_AMD_XGBE_DCB is not set
CONFIG_AMD_XGBE_HAVE_ECC=y
# CONFIG_PDS_CORE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
CONFIG_AQTION=m
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ASIX=y
# CONFIG_SPI_AX88796C is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=m
# CONFIG_CX_ECAT is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BCMGENET=m
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=m
CONFIG_TIGON3_HWMON=y
CONFIG_BNX2X=m
CONFIG_BNX2X_SRIOV=y
# CONFIG_SYSTEMPORT is not set
CONFIG_BNXT=m
CONFIG_BNXT_SRIOV=y
CONFIG_BNXT_FLOWER_OFFLOAD=y
CONFIG_BNXT_DCB=y
# CONFIG_BNXT_HWMON is not set
# CONFIG_BNGE is not set
# CONFIG_NET_VENDOR_CADENCE is not set
# CONFIG_NET_VENDOR_CAVIUM is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
CONFIG_CHELSIO_T4=m
# CONFIG_CHELSIO_T4_DCB is not set
CONFIG_CHELSIO_T4VF=m
CONFIG_CHELSIO_LIB=m
CONFIG_CHELSIO_INLINE_CRYPTO=y
CONFIG_CHELSIO_IPSEC_INLINE=m
CONFIG_CHELSIO_TLS_DEVICE=m
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
# CONFIG_NET_VENDOR_CORTINA is not set
CONFIG_NET_VENDOR_DAVICOM=y
# CONFIG_DM9051 is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=m
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_BE2NET_HWMON=y
# CONFIG_BE2NET_BE2 is not set
# CONFIG_BE2NET_BE3 is not set
CONFIG_BE2NET_LANCER=y
CONFIG_BE2NET_SKYHAWK=y
CONFIG_NET_VENDOR_ENGLEDER=y
# CONFIG_TSNEP is not set
# CONFIG_NET_VENDOR_EZCHIP is not set
CONFIG_NET_VENDOR_FUNGIBLE=y
# CONFIG_FUN_ETH is not set
CONFIG_NET_VENDOR_GOOGLE=y
CONFIG_GVE=m
CONFIG_NET_VENDOR_HISILICON=y
# CONFIG_HIBMCGE is not set
CONFIG_NET_VENDOR_HUAWEI=y
CONFIG_HINIC=m
# CONFIG_HINIC3 is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_LIBETH=m
CONFIG_LIBETH_XDP=m
CONFIG_LIBIE=m
CONFIG_LIBIE_ADMINQ=m
CONFIG_LIBIE_FWLOG=m
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=m
CONFIG_IXGBE=m
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCA=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBE_IPSEC=y
CONFIG_IXGBEVF=m
CONFIG_IXGBEVF_IPSEC=y
CONFIG_I40E=m
CONFIG_I40E_DCB=y
CONFIG_IAVF=m
CONFIG_I40EVF=m
CONFIG_ICE=m
CONFIG_ICE_HWMON=y
CONFIG_ICE_SWITCHDEV=y
CONFIG_ICE_HWTS=y
CONFIG_FM10K=m
CONFIG_IGC=y
CONFIG_IDPF=m
# CONFIG_IDPF_SINGLEQ is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_ADI=y
# CONFIG_ADIN1110 is not set
CONFIG_NET_VENDOR_LITEX=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_OCTEON_EP=m
# CONFIG_OCTEON_EP_VF is not set
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
# CONFIG_MLX4_CORE_GEN2 is not set
CONFIG_MLX5_CORE=m
CONFIG_MLX5_FPGA=y
CONFIG_MLX5_CORE_EN=y
CONFIG_MLX5_EN_ARFS=y
CONFIG_MLX5_EN_RXNFC=y
CONFIG_MLX5_MPFS=y
CONFIG_MLX5_ESWITCH=y
CONFIG_MLX5_BRIDGE=y
CONFIG_MLX5_CLS_ACT=y
CONFIG_MLX5_TC_CT=y
CONFIG_MLX5_TC_SAMPLE=y
CONFIG_MLX5_CORE_EN_DCB=y
CONFIG_MLX5_CORE_IPOIB=y
# CONFIG_MLX5_MACSEC is not set
CONFIG_MLX5_EN_IPSEC=y
CONFIG_MLX5_EN_TLS=y
CONFIG_MLX5_SW_STEERING=y
CONFIG_MLX5_HW_STEERING=y
CONFIG_MLX5_SF=y
CONFIG_MLX5_SF_MANAGER=y
# CONFIG_MLX5_DPLL is not set
CONFIG_MLXSW_CORE=m
CONFIG_MLXSW_CORE_HWMON=y
CONFIG_MLXSW_CORE_THERMAL=y
CONFIG_MLXSW_PCI=m
CONFIG_MLXSW_I2C=m
CONFIG_MLXSW_SPECTRUM=m
CONFIG_MLXSW_SPECTRUM_DCB=y
CONFIG_MLXSW_MINIMAL=m
CONFIG_MLXFW=m
CONFIG_NET_VENDOR_META=y
# CONFIG_FBNIC is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MICROSEMI is not set
CONFIG_NET_VENDOR_MICROSOFT=y
CONFIG_NET_VENDOR_MUCSE=y
# CONFIG_MGBE is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NI is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NFP=m
CONFIG_NFP_APP_FLOWER=y
CONFIG_NFP_APP_ABM_NIC=y
CONFIG_NFP_NET_IPSEC=y
# CONFIG_NFP_DEBUG is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PENSANDO=y
CONFIG_IONIC=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
# CONFIG_QLCNIC is not set
CONFIG_NETXEN_NIC=m
CONFIG_QED=m
CONFIG_QED_LL2=y
CONFIG_QED_SRIOV=y
CONFIG_QEDE=m
CONFIG_QED_RDMA=y
CONFIG_QED_ISCSI=y
CONFIG_QED_FCOE=y
CONFIG_QED_OOO=y
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_VENDOR_QUALCOMM is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
# CONFIG_RTASE is not set
# CONFIG_NET_VENDOR_RENESAS is not set
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_ROCKER=m
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_SFC_MCDI_LOGGING=y
# CONFIG_SFC_FALCON is not set
CONFIG_SFC_SIENA=m
CONFIG_SFC_SIENA_MTD=y
CONFIG_SFC_SIENA_MCDI_MON=y
CONFIG_SFC_SIENA_SRIOV=y
CONFIG_SFC_SIENA_MCDI_LOGGING=y
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_SOCIONEXT is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=m
# CONFIG_STMMAC_SELFTESTS is not set
# CONFIG_STMMAC_PLATFORM is not set
CONFIG_DWMAC_INTEL=m
# CONFIG_DWMAC_MOTORCOMM is not set
# CONFIG_STMMAC_PCI is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_SYNOPSYS is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
CONFIG_NET_VENDOR_VERTEXCOM=y
# CONFIG_MSE102X is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WANGXUN=y
# CONFIG_NGBE is not set
# CONFIG_TXGBE is not set
# CONFIG_TXGBEVF is not set
# CONFIG_NGBEVF is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_NET_VENDOR_XILINX is not set
# CONFIG_FDDI is not set
CONFIG_PHYLINK=y
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
CONFIG_PHY_PACKAGE=y
CONFIG_LED_TRIGGER_PHY=y
CONFIG_FIXED_PHY=y
# CONFIG_SFP is not set

#
# MII PHY device drivers
#
# CONFIG_AS21XXX_PHY is not set
# CONFIG_AIR_EN8811H_PHY is not set
CONFIG_AMD_PHY=m
# CONFIG_ADIN_PHY is not set
# CONFIG_ADIN1100_PHY is not set
CONFIG_AQUANTIA_PHY=m
CONFIG_AX88796B_PHY=y
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM54140_PHY is not set
CONFIG_BCM7XXX_PHY=m
# CONFIG_BCM84881_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_BCM_NET_PHYLIB=m
CONFIG_BCM_NET_PHYPTP=m
CONFIG_CICADA_PHY=m
CONFIG_CORTINA_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_LXT_PHY=m
CONFIG_INTEL_XWAY_PHY=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MARVELL_PHY=m
CONFIG_MARVELL_10G_PHY=m
CONFIG_MARVELL_88Q2XXX_PHY=m
# CONFIG_MARVELL_88X2222_PHY is not set
CONFIG_MAXLINEAR_GPHY=m
# CONFIG_MAXLINEAR_86110_PHY is not set
# CONFIG_MEDIATEK_GE_PHY is not set
CONFIG_MICREL_PHY=m
# CONFIG_MICROCHIP_T1S_PHY is not set
CONFIG_MICROCHIP_PHY=m
CONFIG_MICROCHIP_T1_PHY=m
CONFIG_MICROCHIP_PHY_RDS_PTP=m
CONFIG_MICROSEMI_PHY=m
# CONFIG_MOTORCOMM_PHY is not set
CONFIG_NATIONAL_PHY=m
# CONFIG_NXP_CBTX_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_NCN26000_PHY is not set
# CONFIG_QCA83XX_PHY is not set
# CONFIG_QCA808X_PHY is not set
CONFIG_QSEMI_PHY=m
CONFIG_REALTEK_PHY=y
# CONFIG_REALTEK_PHY_HWMON is not set
CONFIG_RENESAS_PHY=m
CONFIG_ROCKCHIP_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_STE10XP=m
CONFIG_TERANETICS_PHY=m
CONFIG_DP83822_PHY=m
CONFIG_DP83TC811_PHY=m
CONFIG_DP83848_PHY=m
CONFIG_DP83867_PHY=m
# CONFIG_DP83869_PHY is not set
# CONFIG_DP83TD510_PHY is not set
# CONFIG_DP83TG720_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_XILINX_GMII2RGMII=m
CONFIG_CAN_DEV=m
CONFIG_CAN_VCAN=m
CONFIG_CAN_VXCAN=m
CONFIG_CAN_NETLINK=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_RX_OFFLOAD=y
# CONFIG_CAN_CAN327 is not set
# CONFIG_CAN_DUMMY is not set
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_SLCAN=m
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set
# CONFIG_CAN_CTUCANFD_PCI is not set
# CONFIG_CAN_ESD_402_PCI is not set
# CONFIG_CAN_IFI_CANFD is not set
CONFIG_CAN_M_CAN=m
CONFIG_CAN_M_CAN_PCI=m
# CONFIG_CAN_M_CAN_PLATFORM is not set
# CONFIG_CAN_M_CAN_TCAN4X5X is not set
CONFIG_CAN_PEAK_PCIEFD=m
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_SOFTING is not set

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
CONFIG_CAN_MCP251X=m
CONFIG_CAN_MCP251XFD=m
# CONFIG_CAN_MCP251XFD_SANITY is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
CONFIG_CAN_8DEV_USB=m
CONFIG_CAN_EMS_USB=m
# CONFIG_CAN_ESD_USB is not set
# CONFIG_CAN_ETAS_ES58X is not set
# CONFIG_CAN_F81604 is not set
# CONFIG_CAN_GS_USB is not set
CONFIG_CAN_KVASER_USB=m
# CONFIG_CAN_MCBA_USB is not set
CONFIG_CAN_PEAK_USB=m
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_FWNODE_MDIO=y
CONFIG_ACPI_MDIO=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_BCM_UNIMAC=m
CONFIG_MDIO_CAVIUM=m
# CONFIG_MDIO_GPIO is not set
# CONFIG_MDIO_MVUSB is not set
CONFIG_MDIO_THUNDER=m

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
CONFIG_PCS_XPCS=m
# end of PCS device drivers

# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
# CONFIG_PPPOE_HASH_BITS_1 is not set
# CONFIG_PPPOE_HASH_BITS_2 is not set
CONFIG_PPPOE_HASH_BITS_4=y
# CONFIG_PPPOE_HASH_BITS_8 is not set
CONFIG_PPPOE_HASH_BITS=4
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_RTL8152=m
CONFIG_USB_LAN78XX=m
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_HUAWEI_CDC_NCM=m
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET_ENABLE=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
CONFIG_USB_VL600=m
CONFIG_USB_NET_CH9200=m
# CONFIG_USB_NET_AQC111 is not set
CONFIG_USB_RTL8153_ECM=m
CONFIG_WLAN=y
# CONFIG_WLAN_VENDOR_ADMTEK is not set
CONFIG_ATH_COMMON=m
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K=m
CONFIG_ATH9K_PCI=y
# CONFIG_ATH9K_DYNACK is not set
CONFIG_ATH9K_WOW=y
CONFIG_ATH9K_RFKILL=y
# CONFIG_ATH9K_CHANNEL_CONTEXT is not set
CONFIG_ATH9K_PCOEM=y
# CONFIG_ATH9K_PCI_NO_EEPROM is not set
CONFIG_ATH9K_HTC=m
# CONFIG_ATH9K_HTC_DEBUGFS is not set
# CONFIG_ATH9K_HWRNG is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
CONFIG_ATH10K=m
CONFIG_ATH10K_CE=y
CONFIG_ATH10K_PCI=m
# CONFIG_ATH10K_SDIO is not set
# CONFIG_ATH10K_USB is not set
# CONFIG_ATH10K_DEBUG is not set
CONFIG_ATH10K_DEBUGFS=y
CONFIG_ATH10K_LEDS=y
# CONFIG_ATH10K_SPECTRAL is not set
# CONFIG_ATH10K_TRACING is not set
# CONFIG_WCN36XX is not set
CONFIG_ATH11K=m
CONFIG_ATH11K_PCI=m
# CONFIG_ATH11K_DEBUG is not set
# CONFIG_ATH11K_TRACING is not set
# CONFIG_ATH12K is not set
# CONFIG_WLAN_VENDOR_ATMEL is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMSMAC=m
CONFIG_BRCMSMAC_LEDS=y
CONFIG_BRCMFMAC=m
CONFIG_BRCMFMAC_PROTO_BCDC=y
CONFIG_BRCMFMAC_PROTO_MSGBUF=y
CONFIG_BRCMFMAC_SDIO=y
CONFIG_BRCMFMAC_USB=y
CONFIG_BRCMFMAC_PCIE=y
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m
# CONFIG_IWLMLD is not set
CONFIG_IWLWIFI_OPMODE_MODULAR=y

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
# end of Debugging Options

# CONFIG_WLAN_VENDOR_INTERSIL is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
CONFIG_MWIFIEX_PCIE=m
CONFIG_MWIFIEX_USB=m
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
CONFIG_MT7601U=m
CONFIG_MT76_CORE=m
CONFIG_MT76_LEDS=y
CONFIG_MT76_USB=m
CONFIG_MT76x02_LIB=m
CONFIG_MT76x02_USB=m
CONFIG_MT76_CONNAC_LIB=m
CONFIG_MT792x_LIB=m
CONFIG_MT76x0_COMMON=m
CONFIG_MT76x0U=m
CONFIG_MT76x0E=m
CONFIG_MT76x2_COMMON=m
CONFIG_MT76x2E=m
CONFIG_MT76x2U=m
# CONFIG_MT7603E is not set
# CONFIG_MT7615E is not set
# CONFIG_MT7663U is not set
# CONFIG_MT7663S is not set
# CONFIG_MT7915E is not set
CONFIG_MT7921_COMMON=m
CONFIG_MT7921E=m
# CONFIG_MT7921S is not set
# CONFIG_MT7921U is not set
# CONFIG_MT7996E is not set
CONFIG_MT7925_COMMON=m
CONFIG_MT7925E=m
# CONFIG_MT7925U is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_PURELIFI=y
# CONFIG_PLFXLC is not set
CONFIG_WLAN_VENDOR_RALINK=y
CONFIG_RT2X00=m
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
CONFIG_RT2800PCI=m
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
CONFIG_RT2800PCI_RT53XX=y
CONFIG_RT2800PCI_RT3290=y
# CONFIG_RT2500USB is not set
# CONFIG_RT73USB is not set
CONFIG_RT2800USB=m
CONFIG_RT2800USB_RT33XX=y
CONFIG_RT2800USB_RT35XX=y
CONFIG_RT2800USB_RT3573=y
CONFIG_RT2800USB_RT53XX=y
CONFIG_RT2800USB_RT55XX=y
CONFIG_RT2800USB_UNKNOWN=y
CONFIG_RT2800_LIB=m
CONFIG_RT2800_LIB_MMIO=m
CONFIG_RT2X00_LIB_MMIO=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
CONFIG_RTL8192CE=m
CONFIG_RTL8192SE=m
CONFIG_RTL8192DE=m
CONFIG_RTL8723AE=m
CONFIG_RTL8723BE=m
CONFIG_RTL8188EE=m
CONFIG_RTL8192EE=m
CONFIG_RTL8821AE=m
CONFIG_RTL8192CU=m
# CONFIG_RTL8192DU is not set
CONFIG_RTLWIFI=m
CONFIG_RTLWIFI_PCI=m
CONFIG_RTLWIFI_USB=m
# CONFIG_RTLWIFI_DEBUG is not set
CONFIG_RTL8192C_COMMON=m
CONFIG_RTL8192D_COMMON=m
CONFIG_RTL8723_COMMON=m
CONFIG_RTLBTCOEXIST=m
CONFIG_RTL8XXXU=m
# CONFIG_RTL8XXXU_UNTESTED is not set
CONFIG_RTW88=m
CONFIG_RTW88_CORE=m
CONFIG_RTW88_PCI=m
CONFIG_RTW88_8822B=m
CONFIG_RTW88_8822C=m
CONFIG_RTW88_8723X=m
CONFIG_RTW88_8723D=m
CONFIG_RTW88_8821C=m
CONFIG_RTW88_8822BE=m
# CONFIG_RTW88_8822BS is not set
# CONFIG_RTW88_8822BU is not set
CONFIG_RTW88_8822CE=m
# CONFIG_RTW88_8822CS is not set
# CONFIG_RTW88_8822CU is not set
CONFIG_RTW88_8723DE=m
# CONFIG_RTW88_8723DS is not set
# CONFIG_RTW88_8723CS is not set
# CONFIG_RTW88_8723DU is not set
CONFIG_RTW88_8821CE=m
# CONFIG_RTW88_8821CS is not set
# CONFIG_RTW88_8821CU is not set
# CONFIG_RTW88_8821AU is not set
# CONFIG_RTW88_8812AU is not set
# CONFIG_RTW88_8814AE is not set
# CONFIG_RTW88_8814AU is not set
# CONFIG_RTW88_DEBUG is not set
# CONFIG_RTW88_DEBUGFS is not set
CONFIG_RTW88_LEDS=y
CONFIG_RTW89=m
CONFIG_RTW89_CORE=m
CONFIG_RTW89_PCI=m
CONFIG_RTW89_8852A=m
CONFIG_RTW89_8852B_COMMON=m
CONFIG_RTW89_8852B=m
CONFIG_RTW89_8852C=m
# CONFIG_RTW89_8851BE is not set
# CONFIG_RTW89_8851BU is not set
CONFIG_RTW89_8852AE=m
# CONFIG_RTW89_8852AU is not set
CONFIG_RTW89_8852BE=m
# CONFIG_RTW89_8852BU is not set
# CONFIG_RTW89_8852BTE is not set
CONFIG_RTW89_8852CE=m
# CONFIG_RTW89_8852CU is not set
# CONFIG_RTW89_8922AE is not set
# CONFIG_RTW89_DEBUGMSG is not set
# CONFIG_WLAN_VENDOR_RSI is not set
CONFIG_WLAN_VENDOR_SILABS=y
# CONFIG_WFX is not set
# CONFIG_WLAN_VENDOR_ST is not set
# CONFIG_WLAN_VENDOR_TI is not set
# CONFIG_WLAN_VENDOR_ZYDAS is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_VIRT_WIFI is not set
CONFIG_WAN=y
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_FRAMER is not set
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKELB=m
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set

#
# Wireless WAN
#
CONFIG_WWAN=m
CONFIG_WWAN_DEBUGFS=y
CONFIG_WWAN_HWSIM=m
CONFIG_MHI_WWAN_CTRL=m
CONFIG_MHI_WWAN_MBIM=m
CONFIG_IOSM=m
CONFIG_MTK_T7XX=m
# end of Wireless WAN

CONFIG_XEN_NETDEV_FRONTEND=m
CONFIG_VMXNET3=m
CONFIG_FUJITSU_ES=m
CONFIG_USB4_NET=m
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_CHARLIEPLEX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CYPRESS_SF is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
# CONFIG_TABLET_USB_PEGASUS is not set
CONFIG_TABLET_SERIAL_WACOM4=m
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ADC is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_BU21029 is not set
# CONFIG_TOUCHSCREEN_CHIPONE_ICN8505 is not set
# CONFIG_TOUCHSCREEN_CY8CTMA140 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP5 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
# CONFIG_TOUCHSCREEN_EXC3000 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
# CONFIG_TOUCHSCREEN_GOODIX_BERLIN_I2C is not set
# CONFIG_TOUCHSCREEN_GOODIX_BERLIN_SPI is not set
# CONFIG_TOUCHSCREEN_HIDEEP is not set
# CONFIG_TOUCHSCREEN_HIMAX_HX852X is not set
# CONFIG_TOUCHSCREEN_HYCON_HY46XX is not set
# CONFIG_TOUCHSCREEN_HYNITRON_CSTXXX is not set
# CONFIG_TOUCHSCREEN_HYNITRON_CST816X is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_ILITEK is not set
# CONFIG_TOUCHSCREEN_S6SY761 is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
# CONFIG_TOUCHSCREEN_MSG2638 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_NOVATEK_NVT_TS is not set
# CONFIG_TOUCHSCREEN_IMAGIS is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2004 is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
# CONFIG_TOUCHSCREEN_SIS_I2C is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMFTS is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_SURFACE3_SPI is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZET6223 is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_TOUCHSCREEN_COLIBRI_VF50 is not set
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
# CONFIG_TOUCHSCREEN_IQS5XX is not set
# CONFIG_TOUCHSCREEN_IQS7211 is not set
# CONFIG_TOUCHSCREEN_ZINITIX is not set
# CONFIG_TOUCHSCREEN_HIMAX_HX83112B is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_AW86927 is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_DECODER is not set
# CONFIG_INPUT_GPIO_VIBRA is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_PWM_VIBRA is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
# CONFIG_INPUT_DA7280_HAPTICS is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_IQS269A is not set
# CONFIG_INPUT_IQS626A is not set
# CONFIG_INPUT_IQS7222 is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
# CONFIG_RMI4_F1A is not set
# CONFIG_RMI4_F21 is not set
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
CONFIG_RMI4_F3A=y
# CONFIG_RMI4_F54 is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LEGACY_TIOCSTI=y
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCILIB=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_PCI1XXXX is not set
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=m
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y
# CONFIG_SERIAL_8250_NI is not set
CONFIG_SERIAL_8250_DWLIB=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TPM2_HMAC=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_SPI=y
# CONFIG_TCG_TIS_SPI_CR50 is not set
# CONFIG_TCG_TIS_I2C is not set
# CONFIG_TCG_TIS_I2C_CR50 is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=m
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
CONFIG_TCG_VTPM_PROXY=m
# CONFIG_TCG_SVSM is not set
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# CONFIG_XILLYUSB is not set
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_AMD_MP2 is not set
# CONFIG_I2C_AMD_ASF is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m
# CONFIG_I2C_ZHAOXIN is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_AMDPSP is not set
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
# CONFIG_I2C_CP2615 is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_PCI1XXXX is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# CONFIG_I2C_VIRTIO is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_I3C_OR_I2C=y
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_CH341 is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_MICROCHIP_CORE_QSPI is not set
# CONFIG_SPI_MICROCHIP_CORE_SPI is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PCI1XXXX is not set
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_VIRTIO is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m
# CONFIG_PPS_GENERATOR is not set

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_PTP_1588_CLOCK_OPTIONAL=y
CONFIG_DP83640_PHY=m
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
CONFIG_PTP_1588_CLOCK_VMCLOCK=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_FC3W is not set
# CONFIG_PTP_1588_CLOCK_MOCK is not set
CONFIG_PTP_1588_CLOCK_VMW=m
# CONFIG_PTP_1588_CLOCK_OCP is not set
# CONFIG_PTP_NETC_V4_TIMER is not set
# end of PTP clock support

#
# DPLL device support
#
CONFIG_DPLL=y
# CONFIG_DPLL_REFCNT_TRACKER is not set
# CONFIG_ZL3073X_I2C is not set
# CONFIG_ZL3073X_SPI is not set
# end of DPLL device support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=y
# CONFIG_PINCTRL_CY8C95X0 is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_STMFX is not set
# CONFIG_PINCTRL_SX150X is not set
# CONFIG_PINCTRL_CS42L43 is not set

#
# Intel pinctrl drivers
#
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
CONFIG_PINCTRL_INTEL=y
# CONFIG_PINCTRL_INTEL_PLATFORM is not set
CONFIG_PINCTRL_ALDERLAKE=m
CONFIG_PINCTRL_BROXTON=m
CONFIG_PINCTRL_CANNONLAKE=m
CONFIG_PINCTRL_CEDARFORK=m
CONFIG_PINCTRL_DENVERTON=m
CONFIG_PINCTRL_ELKHARTLAKE=m
CONFIG_PINCTRL_EMMITSBURG=m
CONFIG_PINCTRL_GEMINILAKE=m
CONFIG_PINCTRL_ICELAKE=m
CONFIG_PINCTRL_JASPERLAKE=m
CONFIG_PINCTRL_LAKEFIELD=m
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_METEORLAKE=m
# CONFIG_PINCTRL_METEORPOINT is not set
CONFIG_PINCTRL_SUNRISEPOINT=m
CONFIG_PINCTRL_TIGERLAKE=m
# end of Intel pinctrl drivers

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB_LEGACY=y
CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_ALTERA is not set
CONFIG_GPIO_AMDPT=m
# CONFIG_GPIO_BY_PINCTRL is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_GRANITERAPIDS is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_POLARFIRE_SOC is not set
# CONFIG_GPIO_XILINX is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_NOVALAKE is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_FXL6408 is not set
# CONFIG_GPIO_DS4520 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_74X164 is not set
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# CONFIG_GPIO_MPSSE is not set
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
# CONFIG_GPIO_LATCH is not set
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_GPIO_VIRTIO is not set
# CONFIG_GPIO_SIM is not set
# end of Virtual GPIO drivers

#
# GPIO Debugging utilities
#
# CONFIG_GPIO_SLOPPY_LOGIC_ANALYZER is not set
# CONFIG_GPIO_VIRTUSER is not set
# end of GPIO Debugging utilities

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
# CONFIG_POWER_RESET_QEMU_VIRT_CTRL is not set
# CONFIG_POWER_SEQUENCING is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_IP5XXX_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CHAGALL is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SAMSUNG_SDI is not set
# CONFIG_BATTERY_S2MU005 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_BATTERY_MAX1720X is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_MAX77976 is not set
# CONFIG_CHARGER_MAX8971 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_RT9756 is not set
# CONFIG_FUEL_GAUGE_STC3117 is not set
# CONFIG_CHARGER_BD99954 is not set
# CONFIG_BATTERY_UG3105 is not set
# CONFIG_FUEL_GAUGE_MM8013 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AQUACOMPUTER_D5NEXT is not set
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_ASUS_ROG_RYUJIN is not set
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CHIPCAP2 is not set
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
# CONFIG_I8K is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
# CONFIG_SENSORS_GIGABYTE_WATERFORCE is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_GPD is not set
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HS3001 is not set
# CONFIG_SENSORS_HTU31 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_ISL28022 is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWERZ is not set
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LATTEPANDA_SIGMA_EC is not set
# CONFIG_SENSORS_LENOVO_EC is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC2991 is not set
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LTC4282 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX31760 is not set
# CONFIG_MAX31827 is not set
# CONFIG_SENSORS_MAX6620 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
# CONFIG_SENSORS_MC34VR500 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_MCP9982 is not set
CONFIG_SENSORS_MLXREG_FAN=m
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_TPS23861 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775_CORE=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT6775_I2C is not set
# CONFIG_SENSORS_NCT7363 is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
# CONFIG_SENSORS_NZXT_KRAKEN3 is not set
# CONFIG_SENSORS_NZXT_SMART2 is not set
# CONFIG_SENSORS_OCC_P8_I2C is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ACBEL_FSG032 is not set
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_ADP1050 is not set
# CONFIG_SENSORS_APS_379 is not set
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_CRPS is not set
# CONFIG_SENSORS_DELTA_AHE50DC_FAN is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_HAC300S is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_DPS920AB is not set
# CONFIG_SENSORS_INA233 is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR36021 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LT3074 is not set
# CONFIG_SENSORS_LT7182S is not set
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_LTC4286 is not set
# CONFIG_SENSORS_MAX15301 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX17616 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2856 is not set
# CONFIG_SENSORS_MP2869 is not set
# CONFIG_SENSORS_MP2888 is not set
# CONFIG_SENSORS_MP2891 is not set
# CONFIG_SENSORS_MP2925 is not set
# CONFIG_SENSORS_MP29502 is not set
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_MP2993 is not set
# CONFIG_SENSORS_MP5023 is not set
# CONFIG_SENSORS_MP5920 is not set
# CONFIG_SENSORS_MP5926 is not set
# CONFIG_SENSORS_MP5990 is not set
# CONFIG_SENSORS_MP9941 is not set
# CONFIG_SENSORS_MP9945 is not set
# CONFIG_SENSORS_MPQ7932 is not set
# CONFIG_SENSORS_MPQ8785 is not set
# CONFIG_SENSORS_PIM4328 is not set
# CONFIG_SENSORS_PLI1209BC is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STEF48H28 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TDA38640 is not set
# CONFIG_SENSORS_TPS25990 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
# CONFIG_SENSORS_TPS546D24 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDP710 is not set
# CONFIG_SENSORS_XDP720 is not set
# CONFIG_SENSORS_XDPE152 is not set
# CONFIG_SENSORS_XDPE1A2G7B is not set
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_PT5161L is not set
# CONFIG_SENSORS_PWM_FAN is not set
# CONFIG_SENSORS_SBTSI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC2305 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA238 is not set
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_SPD5118 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP464 is not set
# CONFIG_SENSORS_TMP513 is not set
# CONFIG_SENSORS_TSC1641 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set
# CONFIG_SENSORS_YOGAFAN is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
# CONFIG_SENSORS_ASUS_WMI is not set
# CONFIG_SENSORS_ASUS_EC is not set
# CONFIG_SENSORS_HP_WMI is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_NETLINK=y
# CONFIG_THERMAL_STATISTICS is not set
# CONFIG_THERMAL_DEBUGFS is not set
# CONFIG_THERMAL_CORE_TESTING is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_PCIE_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_INTEL_TCC=y
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=m
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
CONFIG_INTEL_HFI_THERMAL=y
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y
# CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT is not set

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_LENOVO_SE10_WDT is not set
# CONFIG_LENOVO_SE30_WDT is not set
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
CONFIG_MLX_WDT=m
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ADVANTECH_EC_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_EBC_C384_WDT is not set
# CONFIG_EXAR_WDT is not set
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=m
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
# CONFIG_INTEL_OC_WATCHDOG is not set
CONFIG_ITCO_WDT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
# CONFIG_XEN_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_MFD_SMPRO is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_CGBC is not set
# CONFIG_MFD_CS40L50_I2C is not set
# CONFIG_MFD_CS40L50_SPI is not set
CONFIG_MFD_CS42L43=m
# CONFIG_MFD_CS42L43_I2C is not set
CONFIG_MFD_CS42L43_SDW=m
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
CONFIG_MFD_INTEL_LPSS=m
CONFIG_MFD_INTEL_LPSS_ACPI=m
CONFIG_MFD_INTEL_LPSS_PCI=m
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX5970 is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77541 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77705 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6370 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_MFD_NCT6694 is not set
# CONFIG_MFD_OCELOT is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_SY7636A is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RT5120 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_BQ257XX is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS6594_I2C is not set
# CONFIG_MFD_TPS6594_SPI is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_ATC260X_I2C is not set
# CONFIG_MFD_INTEL_M10_BMC_SPI is not set
# CONFIG_MFD_UPBOARD_FPGA is not set
# CONFIG_MFD_MAX7360 is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
# CONFIG_RC_CORE is not set
CONFIG_CEC_CORE=m
CONFIG_CEC_NOTIFIER=y

#
# CEC support
#
CONFIG_MEDIA_CEC_SUPPORT=y
# CONFIG_CEC_CH7322 is not set
# CONFIG_CEC_NXP_TDA9950 is not set
# CONFIG_CEC_GPIO is not set
# CONFIG_CEC_SECO is not set
# CONFIG_USB_EXTRON_DA_HD_4K_PLUS_CEC is not set
CONFIG_USB_PULSE8_CEC=m
CONFIG_USB_RAINSHADOW_CEC=m
# end of CEC support

CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_SUPPORT_FILTER=y
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media device types
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_PLATFORM_SUPPORT is not set
# CONFIG_MEDIA_TEST_SUPPORT is not set
# end of Media device types

CONFIG_VIDEO_DEV=m
CONFIG_MEDIA_CONTROLLER=y

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_FWNODE=m
CONFIG_V4L2_ASYNC=m
# end of Video4Linux options

#
# Media controller options
#
# end of Media controller options

#
# Media drivers
#

#
# Drivers filtered as selected at 'Filter media drivers'
#

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_GSPCA=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
# CONFIG_USB_GSPCA_KINECT is not set
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
# CONFIG_USB_GSPCA_TOUPTEK is not set
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_GL860=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_USB_S2255=m
# CONFIG_VIDEO_USBTV is not set
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_VIDEO_EM28XX is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
# CONFIG_VIDEO_MGB4 is not set
# CONFIG_VIDEO_SOLO6X10 is not set
# CONFIG_VIDEO_TW5864 is not set
# CONFIG_VIDEO_TW68 is not set
# CONFIG_VIDEO_TW686X is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_IPU3_CIO2 is not set
# CONFIG_VIDEO_INTEL_IPU6 is not set
# CONFIG_INTEL_VSC is not set
# CONFIG_IPU_BRIDGE is not set
CONFIG_UVC_COMMON=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# end of Media drivers

#
# Media ancillary drivers
#
CONFIG_VIDEO_CAMERA_SENSOR=y
# CONFIG_VIDEO_ALVIUM_CSI2 is not set
# CONFIG_VIDEO_AR0521 is not set
# CONFIG_VIDEO_GC0308 is not set
# CONFIG_VIDEO_GC0310 is not set
# CONFIG_VIDEO_GC05A2 is not set
# CONFIG_VIDEO_GC08A3 is not set
# CONFIG_VIDEO_GC2145 is not set
# CONFIG_VIDEO_HI556 is not set
# CONFIG_VIDEO_HI846 is not set
# CONFIG_VIDEO_HI847 is not set
# CONFIG_VIDEO_IMX111 is not set
# CONFIG_VIDEO_IMX208 is not set
# CONFIG_VIDEO_IMX214 is not set
# CONFIG_VIDEO_IMX219 is not set
# CONFIG_VIDEO_IMX258 is not set
# CONFIG_VIDEO_IMX274 is not set
# CONFIG_VIDEO_IMX283 is not set
# CONFIG_VIDEO_IMX290 is not set
# CONFIG_VIDEO_IMX296 is not set
# CONFIG_VIDEO_IMX319 is not set
# CONFIG_VIDEO_IMX355 is not set
# CONFIG_VIDEO_MT9M001 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9M114 is not set
# CONFIG_VIDEO_MT9P031 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_OG01A1B is not set
# CONFIG_VIDEO_OG0VE1B is not set
# CONFIG_VIDEO_OS05B10 is not set
# CONFIG_VIDEO_OV01A10 is not set
# CONFIG_VIDEO_OV02A10 is not set
# CONFIG_VIDEO_OV02E10 is not set
# CONFIG_VIDEO_OV02C10 is not set
# CONFIG_VIDEO_OV08D10 is not set
# CONFIG_VIDEO_OV08X40 is not set
# CONFIG_VIDEO_OV13858 is not set
# CONFIG_VIDEO_OV13B10 is not set
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV2735 is not set
# CONFIG_VIDEO_OV2740 is not set
# CONFIG_VIDEO_OV4689 is not set
# CONFIG_VIDEO_OV5647 is not set
# CONFIG_VIDEO_OV5648 is not set
# CONFIG_VIDEO_OV5670 is not set
# CONFIG_VIDEO_OV5675 is not set
# CONFIG_VIDEO_OV5693 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV6211 is not set
# CONFIG_VIDEO_OV64A40 is not set
# CONFIG_VIDEO_OV7251 is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV8856 is not set
# CONFIG_VIDEO_OV8858 is not set
# CONFIG_VIDEO_OV8865 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_OV9650 is not set
# CONFIG_VIDEO_OV9734 is not set
# CONFIG_VIDEO_RDACM20 is not set
# CONFIG_VIDEO_RDACM21 is not set
# CONFIG_VIDEO_RJ54N1 is not set
# CONFIG_VIDEO_S5C73M3 is not set
# CONFIG_VIDEO_S5K3M5 is not set
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_S5K6A3 is not set
# CONFIG_VIDEO_S5KJN1 is not set
# CONFIG_VIDEO_T4KA3 is not set
# CONFIG_VIDEO_VD55G1 is not set
# CONFIG_VIDEO_VD56G3 is not set
# CONFIG_VIDEO_CCS is not set
# CONFIG_VIDEO_ET8EK8 is not set

#
# Camera ISPs
#
# CONFIG_VIDEO_THP7312 is not set
# end of Camera ISPs

CONFIG_VIDEO_CAMERA_LENS=y
# CONFIG_VIDEO_AD5820 is not set
# CONFIG_VIDEO_AK7375 is not set
# CONFIG_VIDEO_DW9714 is not set
# CONFIG_VIDEO_DW9719 is not set
# CONFIG_VIDEO_DW9768 is not set
# CONFIG_VIDEO_DW9807_VCM is not set

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set
# end of Flash devices

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_CS3308 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set
# CONFIG_VIDEO_TDA1997X is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_WM8775 is not set
# end of Audio decoders, processors and mixers

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set
# end of RDS decoders

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_ADV7604 is not set
# CONFIG_VIDEO_ADV7842 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_LT6911UXE is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_TC358743 is not set
# CONFIG_VIDEO_TC358746 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9900 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set
# end of Video decoders

#
# Video encoders
#
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_ADV7511 is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_THS8200 is not set
# end of Video encoders

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set
# end of Video improvement chips

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set
# end of Audio/Video compression chips

#
# SDR tuner chips
#
# end of SDR tuner chips

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_I2C is not set
# CONFIG_VIDEO_M52790 is not set
# CONFIG_VIDEO_ST_MIPID02 is not set
# CONFIG_VIDEO_THS7303 is not set
# end of Miscellaneous helper chips

#
# Video serializers and deserializers
#
# CONFIG_VIDEO_MAX96717 is not set
# end of Video serializers and deserializers

#
# Media SPI Adapters
#
# CONFIG_VIDEO_GS1662 is not set
# end of Media SPI Adapters
# end of Media ancillary drivers

#
# Graphics support
#
CONFIG_APERTURE_HELPERS=y
CONFIG_SCREEN_INFO=y
CONFIG_VIDEO=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_SWITCHEROO=y
CONFIG_GPU_BUDDY=y
CONFIG_DRM=m

#
# DRM debugging options
#
# CONFIG_DRM_WERROR is not set
# CONFIG_DRM_DEBUG_MM is not set
# end of DRM debugging options

CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_PANIC is not set
# CONFIG_DRM_RAS is not set
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
# CONFIG_DRM_DEBUG_MODESET_LOCK is not set
CONFIG_DRM_CLIENT=y
CONFIG_DRM_CLIENT_LIB=m
CONFIG_DRM_CLIENT_SELECTION=m
CONFIG_DRM_CLIENT_SETUP=y

#
# Supported DRM clients
#
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
# CONFIG_DRM_CLIENT_LOG is not set
CONFIG_DRM_CLIENT_DEFAULT_FBDEV=y
CONFIG_DRM_CLIENT_DEFAULT="fbdev"
# end of Supported DRM clients

CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_DISPLAY_HELPER=m
# CONFIG_DRM_DISPLAY_DP_AUX_CEC is not set
# CONFIG_DRM_DISPLAY_DP_AUX_CHARDEV is not set
CONFIG_DRM_DISPLAY_DP_HELPER=y
CONFIG_DRM_DISPLAY_DP_TUNNEL=y
CONFIG_DRM_DISPLAY_DSC_HELPER=y
CONFIG_DRM_DISPLAY_HDCP_HELPER=y
CONFIG_DRM_DISPLAY_HDMI_CEC_NOTIFIER_HELPER=y
CONFIG_DRM_DISPLAY_HDMI_HELPER=y
CONFIG_DRM_TTM=m
CONFIG_DRM_EXEC=m
CONFIG_DRM_GPUVM=m
CONFIG_DRM_BUDDY=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=m
CONFIG_DRM_SUBALLOC_HELPER=m
CONFIG_DRM_SCHED=m
CONFIG_DRM_PANEL_BACKLIGHT_QUIRKS=m
CONFIG_DRM_PRIVACY_SCREEN=y
CONFIG_DRM_AMDGPU=m
# CONFIG_DRM_AMDGPU_SI is not set
# CONFIG_DRM_AMDGPU_CIK is not set
CONFIG_DRM_AMDGPU_USERPTR=y
# CONFIG_DRM_AMD_ISP is not set
# CONFIG_DRM_AMDGPU_WERROR is not set

#
# ACP (Audio CoProcessor) Configuration
#
CONFIG_DRM_AMD_ACP=y
# end of ACP (Audio CoProcessor) Configuration

#
# Display Engine Configuration
#
CONFIG_DRM_AMD_DC=y
CONFIG_DRM_AMD_DC_FP=y
# CONFIG_DRM_AMD_SECURE_DISPLAY is not set
# end of Display Engine Configuration

CONFIG_HSA_AMD=y
CONFIG_HSA_AMD_SVM=y
# CONFIG_HSA_AMD_P2P is not set

#
# ARM devices
#
# end of ARM devices

CONFIG_DRM_AST=m
CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_GUD=m
# CONFIG_DRM_HISI_HIBMC is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
# CONFIG_DRM_I915_GVT_KVMGT is not set
CONFIG_DRM_I915_DP_TUNNEL=y

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_REPLAY_GPU_HANGS_API is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# CONFIG_DRM_I915_DEBUG_WAKEREF is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_PREEMPT_TIMEOUT_COMPUTE=7500
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

CONFIG_DRM_MGAG200=m
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_NOUVEAU_DEBUG_MMU is not set
# CONFIG_NOUVEAU_DEBUG_PUSH is not set
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_NOUVEAU_CH7006=m
CONFIG_DRM_NOUVEAU_SIL164=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_AUO_A030JTN01 is not set
# CONFIG_DRM_PANEL_ILITEK_ILI9341 is not set
# CONFIG_DRM_PANEL_ORISETECH_OTA5601A is not set
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# CONFIG_DRM_PANEL_WIDECHIPS_WS2401 is not set
# end of Display Panels

CONFIG_DRM_QXL=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_USERPTR=y
# CONFIG_DRM_ST7571 is not set
# CONFIG_DRM_ST7586 is not set
# CONFIG_DRM_ST7735R is not set
# CONFIG_DRM_ST7920 is not set
# CONFIG_DRM_SSD130X is not set

#
# Drivers for system framebuffers
#
# CONFIG_DRM_EFIDRM is not set
# CONFIG_DRM_SIMPLEDRM is not set
# CONFIG_DRM_VESADRM is not set
# end of Drivers for system framebuffers

# CONFIG_DRM_APPLETBDRM is not set
CONFIG_DRM_BOCHS=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_GM12U320=m
# CONFIG_DRM_PANEL_MIPI_DBI is not set
# CONFIG_DRM_PIXPAPER is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9163 is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_SHARP_MEMORY is not set
CONFIG_DRM_UDL=m
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_VGEM is not set
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_VIRTIO_GPU_KMS=y
CONFIG_DRM_VKMS=m
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_MKSSTATS is not set
# CONFIG_DRM_XE is not set
# CONFIG_DRM_XEN_FRONTEND is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
CONFIG_FB_CORE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_DEVICE=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYSMEM_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_IOMEM_FOPS=y
CONFIG_FB_IOMEM_HELPERS=y
CONFIG_FB_SYSMEM_HELPERS=y
CONFIG_FB_SYSMEM_HELPERS_DEFERRED=y
CONFIG_FB_TILEBLITTING=y
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_AW99706 is not set
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_KTD2801 is not set
# CONFIG_BACKLIGHT_KTZ8866 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3509 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_MP3309C is not set
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y
# CONFIG_FIRMWARE_EDID is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION is not set
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_LOGO_LINUX_CLUT224_FILE="drivers/video/logo/logo_linux_clut224.ppm"
# CONFIG_TRACE_GPU_MEM is not set
# end of Graphics support

# CONFIG_DRM_ACCEL is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_PCM_ELD=y
CONFIG_SND_HWDEP=m
CONFIG_SND_SEQ_DEVICE=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_UMP=m
CONFIG_SND_UMP_LEGACY_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_PROC_FS=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_CTL_FAST_LOOKUP=y
# CONFIG_SND_DEBUG is not set
# CONFIG_SND_CTL_INPUT_VALIDATION is not set
# CONFIG_SND_UTIMER is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_CTL_LED=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_SEQ_MIDI_EVENT=m
CONFIG_SND_SEQ_MIDI=m
CONFIG_SND_SEQ_MIDI_EMUL=m
CONFIG_SND_SEQ_VIRMIDI=m
CONFIG_SND_SEQ_UMP=y
CONFIG_SND_SEQ_UMP_CLIENT=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
# CONFIG_SND_PCMTEST is not set
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=1
# CONFIG_SND_HDA_CTL_DEV_ID is not set
CONFIG_SND_HDA_PREALLOC_SIZE=0
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDA_ACPI is not set
CONFIG_SND_HDA_GENERIC_LEDS=y
CONFIG_SND_HDA_CODEC_ANALOG=m
CONFIG_SND_HDA_CODEC_SIGMATEL=m
CONFIG_SND_HDA_CODEC_VIA=m
CONFIG_SND_HDA_CODEC_CONEXANT=m
# CONFIG_SND_HDA_CODEC_SENARYTECH is not set
CONFIG_SND_HDA_CODEC_CA0110=m
CONFIG_SND_HDA_CODEC_CA0132=m
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m
# CONFIG_SND_HDA_CODEC_CM9825 is not set
CONFIG_SND_HDA_CODEC_SI3054=m
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_CODEC_REALTEK=m
CONFIG_SND_HDA_CODEC_REALTEK_LIB=m
CONFIG_SND_HDA_CODEC_ALC260=m
CONFIG_SND_HDA_CODEC_ALC262=m
CONFIG_SND_HDA_CODEC_ALC268=m
CONFIG_SND_HDA_CODEC_ALC269=m
CONFIG_SND_HDA_CODEC_ALC662=m
CONFIG_SND_HDA_CODEC_ALC680=m
CONFIG_SND_HDA_CODEC_ALC861=m
CONFIG_SND_HDA_CODEC_ALC861VD=m
CONFIG_SND_HDA_CODEC_ALC880=m
CONFIG_SND_HDA_CODEC_ALC882=m
CONFIG_SND_HDA_CODEC_CIRRUS=m
CONFIG_SND_HDA_CODEC_CS420X=m
CONFIG_SND_HDA_CODEC_CS421X=m
CONFIG_SND_HDA_CODEC_CS8409=m
CONFIG_SND_HDA_CODEC_HDMI=m
CONFIG_SND_HDA_CODEC_HDMI_GENERIC=m
CONFIG_SND_HDA_CODEC_HDMI_SIMPLE=m
CONFIG_SND_HDA_CODEC_HDMI_INTEL=m
CONFIG_SND_HDA_INTEL_HDMI_SILENT_STREAM=y
CONFIG_SND_HDA_CODEC_HDMI_ATI=m
CONFIG_SND_HDA_CODEC_HDMI_NVIDIA=m
CONFIG_SND_HDA_CODEC_HDMI_NVIDIA_MCP=m
CONFIG_SND_HDA_CODEC_HDMI_TEGRA=m
CONFIG_SND_HDA_CIRRUS_SCODEC=m
CONFIG_SND_HDA_SCODEC_CS35L41=m
CONFIG_SND_HDA_SCODEC_COMPONENT=m
CONFIG_SND_HDA_SCODEC_CS35L41_I2C=m
CONFIG_SND_HDA_SCODEC_CS35L41_SPI=m
CONFIG_SND_HDA_SCODEC_CS35L56=m
CONFIG_SND_HDA_SCODEC_CS35L56_I2C=m
CONFIG_SND_HDA_SCODEC_CS35L56_SPI=m

#
# CS35L56 driver options
#
# CONFIG_SND_HDA_SCODEC_CS35L56_CAL_DEBUGFS is not set
# end of CS35L56 driver options

CONFIG_SND_HDA_SCODEC_TAS2781=m
CONFIG_SND_HDA_SCODEC_TAS2781_I2C=m
# CONFIG_SND_HDA_SCODEC_TAS2781_SPI is not set
CONFIG_SND_HDA_CORE=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_COMPONENT=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_EXT_CORE=m
CONFIG_SND_INTEL_NHLT=y
CONFIG_SND_INTEL_DSP_CONFIG=m
CONFIG_SND_INTEL_SOUNDWIRE_ACPI=m
# CONFIG_SND_INTEL_BYT_PREFER_SOF is not set
# end of HD-Audio

# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_AUDIO_MIDI_V2=y
CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER=y
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
# CONFIG_SND_USB_US144MKII is not set
CONFIG_SND_USB_6FIRE=m
CONFIG_SND_USB_HIFACE=m
CONFIG_SND_BCD2000=m
CONFIG_SND_USB_LINE6=m
CONFIG_SND_USB_POD=m
CONFIG_SND_USB_PODHD=m
CONFIG_SND_USB_TONEPORT=m
CONFIG_SND_USB_VARIAX=m
CONFIG_SND_SOC=m
CONFIG_SND_SOC_COMPRESS=y
CONFIG_SND_SOC_TOPOLOGY=y
CONFIG_SND_SOC_ACPI=m
# CONFIG_SND_SOC_USB is not set

#
# Analog Devices
#
# CONFIG_SND_SOC_ADI_AXI_I2S is not set
# CONFIG_SND_SOC_ADI_AXI_SPDIF is not set
# end of Analog Devices

#
# AMD
#
# CONFIG_SND_SOC_AMD_ACP is not set
# CONFIG_SND_SOC_AMD_ACP3x is not set
CONFIG_SND_SOC_AMD_RENOIR=m
CONFIG_SND_SOC_AMD_RENOIR_MACH=m
CONFIG_SND_SOC_AMD_ACP5x=m
CONFIG_SND_SOC_AMD_VANGOGH_MACH=m
CONFIG_SND_SOC_AMD_ACP6x=m
CONFIG_SND_SOC_AMD_YC_MACH=m
CONFIG_SND_AMD_ACP_CONFIG=m
# CONFIG_SND_SOC_AMD_ACP_COMMON is not set
CONFIG_SND_SOC_ACPI_AMD_MATCH=m
CONFIG_SND_SOC_ACPI_AMD_SDCA_QUIRKS=m
CONFIG_SND_AMD_SOUNDWIRE_ACPI=m
CONFIG_SND_SOC_AMD_ACP63_TOPLEVEL=m
CONFIG_SND_SOC_AMD_SOUNDWIRE_LINK_BASELINE=m
CONFIG_SND_SOC_AMD_SOUNDWIRE=m
CONFIG_SND_SOC_AMD_PS=m
CONFIG_SND_SOC_AMD_PS_MACH=m
# end of AMD

#
# Apple
#
# end of Apple

#
# Atmel
#
# end of Atmel

#
# Au1x
#
# end of Au1x

#
# Broadcom
#
# CONFIG_SND_BCM63XX_I2S_WHISTLER is not set
# end of Broadcom

#
# Cirrus Logic
#
# end of Cirrus Logic

#
# DesignWare
#
# CONFIG_SND_DESIGNWARE_I2S is not set
# end of DesignWare

#
# Freescale
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_ASRC is not set
# CONFIG_SND_SOC_FSL_SAI is not set
# CONFIG_SND_SOC_FSL_AUDMIX is not set
# CONFIG_SND_SOC_FSL_SSI is not set
# CONFIG_SND_SOC_FSL_SPDIF is not set
# CONFIG_SND_SOC_FSL_ESAI is not set
# CONFIG_SND_SOC_FSL_MICFIL is not set
# CONFIG_SND_SOC_FSL_XCVR is not set
# CONFIG_SND_SOC_IMX_AUDMUX is not set
# end of Freescale

#
# Google
#
# CONFIG_SND_SOC_CHV3_I2S is not set
# end of Google

#
# Hisilicon
#
# CONFIG_SND_I2S_HI6210_I2S is not set
# end of Hisilicon

#
# JZ4740
#
# end of JZ4740

#
# Kirkwood
#
# end of Kirkwood

#
# Loongson
#
# end of Loongson

#
# Intel
#
CONFIG_SND_SOC_INTEL_SST_TOPLEVEL=y
CONFIG_SND_SOC_INTEL_CATPT=m
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM=m
# CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_PCI is not set
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_ACPI=m
CONFIG_SND_SOC_ACPI_INTEL_MATCH=m
CONFIG_SND_SOC_ACPI_INTEL_SDCA_QUIRKS=m
CONFIG_SND_SOC_INTEL_AVS=m

#
# Intel AVS Machine drivers
#

#
# Available DSP configurations
#
# CONFIG_SND_SOC_INTEL_AVS_CARDNAME_OBSOLETE is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_DA7219 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_DMIC is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_ES8336 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_HDAUDIO is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_I2S_TEST is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_MAX98927 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_MAX98357A is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_MAX98373 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_NAU8825 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_PCM3168A is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_PROBE is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT274 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT286 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT298 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT5514 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT5640 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT5663 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT5682 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_SSM4567 is not set
# end of Intel AVS Machine drivers

CONFIG_SND_SOC_INTEL_MACH=y
CONFIG_SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES=y
CONFIG_SND_SOC_INTEL_HDA_DSP_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_MAXIM_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_REALTEK_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_CIRRUS_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_NUVOTON_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_TI_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_BOARD_HELPERS=m
CONFIG_SND_SOC_INTEL_HASWELL_MACH=m
CONFIG_SND_SOC_INTEL_BDW_RT5650_MACH=m
CONFIG_SND_SOC_INTEL_BDW_RT5677_MACH=m
CONFIG_SND_SOC_INTEL_BROADWELL_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5640_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5651_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5672_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5645_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_MAX98090_TI_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_NAU8824_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_CX2072X_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_DA7213_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_ES8316_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_NOCODEC_MACH=m
CONFIG_SND_SOC_INTEL_SOF_WM8804_MACH=m
CONFIG_SND_SOC_INTEL_GLK_DA7219_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_GLK_RT5682_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_SKL_HDA_DSP_GENERIC_MACH=m
CONFIG_SND_SOC_INTEL_SOF_RT5682_MACH=m
CONFIG_SND_SOC_INTEL_SOF_CS42L42_MACH=m
CONFIG_SND_SOC_INTEL_SOF_PCM512x_MACH=m
CONFIG_SND_SOC_INTEL_SOF_ES8336_MACH=m
CONFIG_SND_SOC_INTEL_SOF_NAU8825_MACH=m
CONFIG_SND_SOC_INTEL_CML_LP_DA7219_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_SOF_CML_RT1011_RT5682_MACH=m
CONFIG_SND_SOC_INTEL_SOF_DA7219_MACH=m
CONFIG_SND_SOC_INTEL_SOF_SSP_AMP_MACH=m
CONFIG_SND_SOC_INTEL_EHL_RT5660_MACH=m
CONFIG_SND_SOC_INTEL_SOUNDWIRE_SOF_MACH=m
# end of Intel

#
# Mediatek
#
# CONFIG_SND_SOC_MTK_BTCVSD is not set
# end of Mediatek

#
# PXA
#
# end of PXA

#
# SoundWire (SDCA)
#
CONFIG_SND_SOC_SDCA=m
CONFIG_SND_SOC_SDCA_HID=y
CONFIG_SND_SOC_SDCA_IRQ=y
CONFIG_SND_SOC_SDCA_FDL=y
CONFIG_SND_SOC_SDCA_OPTIONAL=m
# CONFIG_SND_SOC_SDCA_CLASS is not set
# end of SoundWire (SDCA)

#
# ST SPEAr
#
# end of ST SPEAr

#
# Spreadtrum
#
# end of Spreadtrum

#
# STMicroelectronics STM32
#
# end of STMicroelectronics STM32

#
# Tegra
#
# end of Tegra

#
# Xilinx
#
# CONFIG_SND_SOC_XILINX_I2S is not set
# CONFIG_SND_SOC_XILINX_AUDIO_FORMATTER is not set
# CONFIG_SND_SOC_XILINX_SPDIF is not set
# end of Xilinx

#
# Xtensa
#
# CONFIG_SND_SOC_XTFPGA_I2S is not set
# end of Xtensa

CONFIG_SND_SOC_SOF_TOPLEVEL=y
CONFIG_SND_SOC_SOF_PCI_DEV=m
CONFIG_SND_SOC_SOF_PCI=m
CONFIG_SND_SOC_SOF_ACPI=m
CONFIG_SND_SOC_SOF_ACPI_DEV=m
CONFIG_SND_SOC_SOF_DEBUG_PROBES=m
CONFIG_SND_SOC_SOF_CLIENT=m
# CONFIG_SND_SOC_SOF_DEVELOPER_SUPPORT is not set
CONFIG_SND_SOC_SOF=m
CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE=y
CONFIG_SND_SOC_SOF_IPC3=y
CONFIG_SND_SOC_SOF_IPC4=y
CONFIG_SND_SOC_SOF_AMD_TOPLEVEL=m
CONFIG_SND_SOC_SOF_AMD_COMMON=m
CONFIG_SND_SOC_SOF_AMD_RENOIR=m
CONFIG_SND_SOC_SOF_AMD_VANGOGH=m
CONFIG_SND_SOC_SOF_AMD_REMBRANDT=m
CONFIG_SND_SOC_SOF_ACP_PROBES=m
# CONFIG_SND_SOC_SOF_AMD_ACP63 is not set
# CONFIG_SND_SOC_SOF_AMD_ACP70 is not set
CONFIG_SND_SOC_SOF_INTEL_TOPLEVEL=y
CONFIG_SND_SOC_SOF_INTEL_HIFI_EP_IPC=m
CONFIG_SND_SOC_SOF_INTEL_ATOM_HIFI_EP=m
CONFIG_SND_SOC_SOF_INTEL_COMMON=m
CONFIG_SND_SOC_SOF_BAYTRAIL=m
CONFIG_SND_SOC_SOF_BROADWELL=m
CONFIG_SND_SOC_SOF_MERRIFIELD=m
# CONFIG_SND_SOC_SOF_SKYLAKE is not set
# CONFIG_SND_SOC_SOF_KABYLAKE is not set
CONFIG_SND_SOC_SOF_INTEL_APL=m
CONFIG_SND_SOC_SOF_APOLLOLAKE=m
CONFIG_SND_SOC_SOF_GEMINILAKE=m
CONFIG_SND_SOC_SOF_INTEL_CNL=m
CONFIG_SND_SOC_SOF_CANNONLAKE=m
CONFIG_SND_SOC_SOF_COFFEELAKE=m
CONFIG_SND_SOC_SOF_COMETLAKE=m
CONFIG_SND_SOC_SOF_INTEL_ICL=m
CONFIG_SND_SOC_SOF_ICELAKE=m
CONFIG_SND_SOC_SOF_JASPERLAKE=m
CONFIG_SND_SOC_SOF_INTEL_TGL=m
CONFIG_SND_SOC_SOF_TIGERLAKE=m
CONFIG_SND_SOC_SOF_ELKHARTLAKE=m
CONFIG_SND_SOC_SOF_ALDERLAKE=m
CONFIG_SND_SOC_SOF_INTEL_MTL=m
CONFIG_SND_SOC_SOF_METEORLAKE=m
CONFIG_SND_SOC_SOF_INTEL_LNL=m
CONFIG_SND_SOC_SOF_LUNARLAKE=m
CONFIG_SND_SOC_SOF_INTEL_PTL=m
CONFIG_SND_SOC_SOF_PANTHERLAKE=m
CONFIG_SND_SOC_SOF_INTEL_NVL=m
CONFIG_SND_SOC_SOF_NOVALAKE=m
CONFIG_SND_SOC_SOF_HDA_COMMON=m
CONFIG_SND_SOC_SOF_HDA_GENERIC=m
CONFIG_SND_SOC_SOF_HDA_MLINK=m
CONFIG_SND_SOC_SOF_HDA_LINK=y
CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC=y
CONFIG_SND_SOF_SOF_HDA_SDW_BPT=m
CONFIG_SND_SOC_SOF_HDA_LINK_BASELINE=m
CONFIG_SND_SOC_SOF_HDA=m
CONFIG_SND_SOC_SOF_HDA_PROBES=m
CONFIG_SND_SOC_SOF_INTEL_SOUNDWIRE_LINK_BASELINE=m
CONFIG_SND_SOC_SOF_INTEL_SOUNDWIRE=m
CONFIG_SND_SOC_SOF_XTENSA=m
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
CONFIG_SND_SOC_WM_ADSP=m
# CONFIG_SND_SOC_AC97_CODEC is not set
# CONFIG_SND_SOC_ADAU1372_I2C is not set
# CONFIG_SND_SOC_ADAU1372_SPI is not set
# CONFIG_SND_SOC_ADAU1373 is not set
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_ADAU1761_I2C is not set
# CONFIG_SND_SOC_ADAU1761_SPI is not set
# CONFIG_SND_SOC_ADAU7002 is not set
# CONFIG_SND_SOC_ADAU7118_HW is not set
# CONFIG_SND_SOC_ADAU7118_I2C is not set
# CONFIG_SND_SOC_AK4104 is not set
# CONFIG_SND_SOC_AK4118 is not set
# CONFIG_SND_SOC_AK4375 is not set
# CONFIG_SND_SOC_AK4458 is not set
# CONFIG_SND_SOC_AK4554 is not set
# CONFIG_SND_SOC_AK4613 is not set
# CONFIG_SND_SOC_AK4619 is not set
# CONFIG_SND_SOC_AK4642 is not set
# CONFIG_SND_SOC_AK5386 is not set
# CONFIG_SND_SOC_AK5558 is not set
# CONFIG_SND_SOC_ALC5623 is not set
# CONFIG_SND_SOC_AUDIO_IIO_AUX is not set
# CONFIG_SND_SOC_AW8738 is not set
# CONFIG_SND_SOC_AW88395 is not set
# CONFIG_SND_SOC_AW88166 is not set
# CONFIG_SND_SOC_AW88261 is not set
# CONFIG_SND_SOC_AW88081 is not set
# CONFIG_SND_SOC_AW87390 is not set
# CONFIG_SND_SOC_AW88399 is not set
# CONFIG_SND_SOC_BD28623 is not set
# CONFIG_SND_SOC_BT_SCO is not set
# CONFIG_SND_SOC_CHV3_CODEC is not set
CONFIG_SND_SOC_CS_AMP_LIB=m
# CONFIG_SND_SOC_CS35L32 is not set
# CONFIG_SND_SOC_CS35L33 is not set
# CONFIG_SND_SOC_CS35L34 is not set
# CONFIG_SND_SOC_CS35L35 is not set
# CONFIG_SND_SOC_CS35L36 is not set
CONFIG_SND_SOC_CS35L41_LIB=m
CONFIG_SND_SOC_CS35L41=m
CONFIG_SND_SOC_CS35L41_SPI=m
CONFIG_SND_SOC_CS35L41_I2C=m
# CONFIG_SND_SOC_CS35L45_SPI is not set
# CONFIG_SND_SOC_CS35L45_I2C is not set
CONFIG_SND_SOC_CS35L56=m
CONFIG_SND_SOC_CS35L56_SHARED=m
# CONFIG_SND_SOC_CS35L56_I2C is not set
CONFIG_SND_SOC_CS35L56_SPI=m
CONFIG_SND_SOC_CS35L56_SDW=m

#
# CS35L56 driver options
#
# CONFIG_SND_SOC_CS35L56_CAL_DEBUGFS is not set
# CONFIG_SND_SOC_CS35L56_CAL_SET_CTRL is not set
# CONFIG_SND_SOC_CS35L56_CAL_PERFORM_CTRL is not set
# end of CS35L56 driver options

CONFIG_SND_SOC_CS42L42_CORE=m
CONFIG_SND_SOC_CS42L42=m
CONFIG_SND_SOC_CS42L42_SDW=m
CONFIG_SND_SOC_CS42L43=m
CONFIG_SND_SOC_CS42L43_SDW=m
# CONFIG_SND_SOC_CS42L51_I2C is not set
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS42L83 is not set
# CONFIG_SND_SOC_CS42L84 is not set
# CONFIG_SND_SOC_CS4234 is not set
# CONFIG_SND_SOC_CS4265 is not set
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271_I2C is not set
# CONFIG_SND_SOC_CS4271_SPI is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
# CONFIG_SND_SOC_CS43130 is not set
# CONFIG_SND_SOC_CS4341 is not set
# CONFIG_SND_SOC_CS4349 is not set
# CONFIG_SND_SOC_CS48L32 is not set
# CONFIG_SND_SOC_CS53L30 is not set
# CONFIG_SND_SOC_CS530X_I2C is not set
# CONFIG_SND_SOC_CS530X_SPI is not set
CONFIG_SND_SOC_CX2072X=m
CONFIG_SND_SOC_DA7213=m
CONFIG_SND_SOC_DA7219=m
CONFIG_SND_SOC_DMIC=m
# CONFIG_SND_SOC_ES7134 is not set
# CONFIG_SND_SOC_ES7241 is not set
CONFIG_SND_SOC_ES83XX_DSM_COMMON=m
# CONFIG_SND_SOC_ES8311 is not set
CONFIG_SND_SOC_ES8316=m
# CONFIG_SND_SOC_ES8323 is not set
CONFIG_SND_SOC_ES8326=m
# CONFIG_SND_SOC_ES8328_I2C is not set
# CONFIG_SND_SOC_ES8328_SPI is not set
# CONFIG_SND_SOC_ES8375 is not set
# CONFIG_SND_SOC_ES8389 is not set
# CONFIG_SND_SOC_FS210X is not set
# CONFIG_SND_SOC_GTM601 is not set
CONFIG_SND_SOC_HDAC_HDA=m
CONFIG_SND_SOC_HDA=m
# CONFIG_SND_SOC_ICS43432 is not set
# CONFIG_SND_SOC_IDT821034 is not set
# CONFIG_SND_SOC_MAX98088 is not set
CONFIG_SND_SOC_MAX98090=m
CONFIG_SND_SOC_MAX98357A=m
# CONFIG_SND_SOC_MAX98504 is not set
# CONFIG_SND_SOC_MAX9867 is not set
CONFIG_SND_SOC_MAX98927=m
# CONFIG_SND_SOC_MAX98520 is not set
CONFIG_SND_SOC_MAX98363=m
CONFIG_SND_SOC_MAX98373=m
CONFIG_SND_SOC_MAX98373_I2C=m
CONFIG_SND_SOC_MAX98373_SDW=m
CONFIG_SND_SOC_MAX98388=m
CONFIG_SND_SOC_MAX98390=m
# CONFIG_SND_SOC_MAX98396 is not set
# CONFIG_SND_SOC_MAX9860 is not set
# CONFIG_SND_SOC_MSM8916_WCD_DIGITAL is not set
# CONFIG_SND_SOC_PCM1681 is not set
# CONFIG_SND_SOC_PCM1754 is not set
# CONFIG_SND_SOC_PCM1789_I2C is not set
# CONFIG_SND_SOC_PCM179X_I2C is not set
# CONFIG_SND_SOC_PCM179X_SPI is not set
# CONFIG_SND_SOC_PCM186X_I2C is not set
# CONFIG_SND_SOC_PCM186X_SPI is not set
# CONFIG_SND_SOC_PCM3060_I2C is not set
# CONFIG_SND_SOC_PCM3060_SPI is not set
# CONFIG_SND_SOC_PCM3168A_I2C is not set
# CONFIG_SND_SOC_PCM3168A_SPI is not set
# CONFIG_SND_SOC_PCM5102A is not set
CONFIG_SND_SOC_PCM512x=m
CONFIG_SND_SOC_PCM512x_I2C=m
# CONFIG_SND_SOC_PCM512x_SPI is not set
# CONFIG_SND_SOC_PCM6240 is not set
# CONFIG_SND_SOC_PEB2466 is not set
# CONFIG_SND_SOC_PM4125_SDW is not set
CONFIG_SND_SOC_RL6231=m
CONFIG_SND_SOC_RT_SDW_COMMON=m
CONFIG_SND_SOC_RL6347A=m
CONFIG_SND_SOC_RT286=m
CONFIG_SND_SOC_RT1011=m
CONFIG_SND_SOC_RT1015=m
CONFIG_SND_SOC_RT1015P=m
# CONFIG_SND_SOC_RT1017_SDCA_SDW is not set
CONFIG_SND_SOC_RT1308=m
CONFIG_SND_SOC_RT1308_SDW=m
CONFIG_SND_SOC_RT1316_SDW=m
CONFIG_SND_SOC_RT1318_SDW=m
CONFIG_SND_SOC_RT1320_SDW=m
# CONFIG_SND_SOC_RT5575 is not set
# CONFIG_SND_SOC_RT5616 is not set
# CONFIG_SND_SOC_RT5631 is not set
CONFIG_SND_SOC_RT5640=m
CONFIG_SND_SOC_RT5645=m
CONFIG_SND_SOC_RT5651=m
# CONFIG_SND_SOC_RT5659 is not set
CONFIG_SND_SOC_RT5660=m
CONFIG_SND_SOC_RT5670=m
CONFIG_SND_SOC_RT5677=m
CONFIG_SND_SOC_RT5677_SPI=m
CONFIG_SND_SOC_RT5682=m
CONFIG_SND_SOC_RT5682_I2C=m
CONFIG_SND_SOC_RT5682_SDW=m
CONFIG_SND_SOC_RT5682S=m
CONFIG_SND_SOC_RT700=m
CONFIG_SND_SOC_RT700_SDW=m
CONFIG_SND_SOC_RT711=m
CONFIG_SND_SOC_RT711_SDW=m
CONFIG_SND_SOC_RT711_SDCA_SDW=m
CONFIG_SND_SOC_RT712_SDCA_SDW=m
CONFIG_SND_SOC_RT712_SDCA_DMIC_SDW=m
CONFIG_SND_SOC_RT721_SDCA_SDW=m
CONFIG_SND_SOC_RT722_SDCA_SDW=m
CONFIG_SND_SOC_RT715=m
CONFIG_SND_SOC_RT715_SDW=m
CONFIG_SND_SOC_RT715_SDCA_SDW=m
# CONFIG_SND_SOC_RT9120 is not set
# CONFIG_SND_SOC_RT9123 is not set
# CONFIG_SND_SOC_RT9123P is not set
# CONFIG_SND_SOC_RTQ9124 is not set
# CONFIG_SND_SOC_RTQ9128 is not set
# CONFIG_SND_SOC_SDW_MOCKUP is not set
# CONFIG_SND_SOC_SGTL5000 is not set
# CONFIG_SND_SOC_SIMPLE_AMPLIFIER is not set
# CONFIG_SND_SOC_SIMPLE_MUX is not set
# CONFIG_SND_SOC_SMA1303 is not set
# CONFIG_SND_SOC_SMA1307 is not set
# CONFIG_SND_SOC_SPDIF is not set
# CONFIG_SND_SOC_SRC4XXX_I2C is not set
# CONFIG_SND_SOC_SSM2305 is not set
# CONFIG_SND_SOC_SSM2518 is not set
# CONFIG_SND_SOC_SSM2602_SPI is not set
# CONFIG_SND_SOC_SSM2602_I2C is not set
CONFIG_SND_SOC_SSM4567=m
# CONFIG_SND_SOC_STA32X is not set
# CONFIG_SND_SOC_STA350 is not set
# CONFIG_SND_SOC_STI_SAS is not set
# CONFIG_SND_SOC_TAS2552 is not set
# CONFIG_SND_SOC_TAS2562 is not set
# CONFIG_SND_SOC_TAS2764 is not set
# CONFIG_SND_SOC_TAS2770 is not set
# CONFIG_SND_SOC_TAS2780 is not set
CONFIG_SND_SOC_TAS2781_COMLIB=m
CONFIG_SND_SOC_TAS2781_COMLIB_I2C=m
CONFIG_SND_SOC_TAS2781_FMWLIB=m
CONFIG_SND_SOC_TAS2781_I2C=m
# CONFIG_SND_SOC_TAS2783_SDW is not set
# CONFIG_SND_SOC_TAS5086 is not set
# CONFIG_SND_SOC_TAS571X is not set
# CONFIG_SND_SOC_TAS5720 is not set
# CONFIG_SND_SOC_TAS5805M is not set
# CONFIG_SND_SOC_TAS6424 is not set
# CONFIG_SND_SOC_TDA7419 is not set
# CONFIG_SND_SOC_TFA9879 is not set
# CONFIG_SND_SOC_TFA989X is not set
# CONFIG_SND_SOC_TLV320ADC3XXX is not set
# CONFIG_SND_SOC_TLV320AIC23_I2C is not set
# CONFIG_SND_SOC_TLV320AIC23_SPI is not set
# CONFIG_SND_SOC_TLV320AIC31XX is not set
# CONFIG_SND_SOC_TLV320AIC32X4_I2C is not set
# CONFIG_SND_SOC_TLV320AIC32X4_SPI is not set
# CONFIG_SND_SOC_TLV320AIC3X_I2C is not set
# CONFIG_SND_SOC_TLV320AIC3X_SPI is not set
# CONFIG_SND_SOC_TLV320ADCX140 is not set
CONFIG_SND_SOC_TS3A227E=m
# CONFIG_SND_SOC_TSCS42XX is not set
# CONFIG_SND_SOC_TSCS454 is not set
# CONFIG_SND_SOC_UDA1334 is not set
# CONFIG_SND_SOC_UDA1342 is not set
# CONFIG_SND_SOC_UDA1380 is not set
# CONFIG_SND_SOC_WCD937X_SDW is not set
# CONFIG_SND_SOC_WCD938X_SDW is not set
# CONFIG_SND_SOC_WCD939X_SDW is not set
# CONFIG_SND_SOC_WM8510 is not set
# CONFIG_SND_SOC_WM8523 is not set
# CONFIG_SND_SOC_WM8524 is not set
# CONFIG_SND_SOC_WM8580 is not set
# CONFIG_SND_SOC_WM8711 is not set
# CONFIG_SND_SOC_WM8728 is not set
# CONFIG_SND_SOC_WM8731_I2C is not set
# CONFIG_SND_SOC_WM8731_SPI is not set
# CONFIG_SND_SOC_WM8737 is not set
# CONFIG_SND_SOC_WM8741 is not set
# CONFIG_SND_SOC_WM8750 is not set
# CONFIG_SND_SOC_WM8753 is not set
# CONFIG_SND_SOC_WM8770 is not set
# CONFIG_SND_SOC_WM8776 is not set
# CONFIG_SND_SOC_WM8782 is not set
CONFIG_SND_SOC_WM8804=m
CONFIG_SND_SOC_WM8804_I2C=m
# CONFIG_SND_SOC_WM8804_SPI is not set
# CONFIG_SND_SOC_WM8903 is not set
# CONFIG_SND_SOC_WM8904 is not set
# CONFIG_SND_SOC_WM8940 is not set
# CONFIG_SND_SOC_WM8960 is not set
# CONFIG_SND_SOC_WM8961 is not set
# CONFIG_SND_SOC_WM8962 is not set
# CONFIG_SND_SOC_WM8974 is not set
# CONFIG_SND_SOC_WM8978 is not set
# CONFIG_SND_SOC_WM8985 is not set
# CONFIG_SND_SOC_WSA881X is not set
# CONFIG_SND_SOC_WSA883X is not set
# CONFIG_SND_SOC_WSA884X is not set
# CONFIG_SND_SOC_ZL38060 is not set
# CONFIG_SND_SOC_MAX9759 is not set
# CONFIG_SND_SOC_MT6351 is not set
# CONFIG_SND_SOC_MT6357 is not set
# CONFIG_SND_SOC_MT6358 is not set
# CONFIG_SND_SOC_MT6660 is not set
CONFIG_SND_SOC_NAU8315=m
# CONFIG_SND_SOC_NAU8325 is not set
# CONFIG_SND_SOC_NAU8540 is not set
# CONFIG_SND_SOC_NAU8810 is not set
CONFIG_SND_SOC_NAU8821=m
# CONFIG_SND_SOC_NAU8822 is not set
CONFIG_SND_SOC_NAU8824=m
CONFIG_SND_SOC_NAU8825=m
# CONFIG_SND_SOC_NTP8918 is not set
# CONFIG_SND_SOC_NTP8835 is not set
# CONFIG_SND_SOC_TPA6130A2 is not set
# CONFIG_SND_SOC_LPASS_WSA_MACRO is not set
# CONFIG_SND_SOC_LPASS_VA_MACRO is not set
# CONFIG_SND_SOC_LPASS_RX_MACRO is not set
# CONFIG_SND_SOC_LPASS_TX_MACRO is not set
# end of CODEC drivers

CONFIG_SND_SOC_SDW_UTILS=m

#
# Generic drivers
#
# CONFIG_SND_SIMPLE_CARD is not set
# end of Generic drivers

CONFIG_SND_X86=y
CONFIG_HDMI_LPE_AUDIO=m
CONFIG_SND_SYNTH_EMUX=m
CONFIG_SND_XEN_FRONTEND=m
CONFIG_SND_VIRTIO=m
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y
# CONFIG_HID_HAPTIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
CONFIG_HID_APPLEIR=m
# CONFIG_HID_APPLETB_BL is not set
# CONFIG_HID_APPLETB_KBD is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_BETOP_FF=m
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CORSAIR=m
CONFIG_HID_COUGAR=m
# CONFIG_HID_MACALLY is not set
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELAN=m
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
CONFIG_HID_EVISION=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_GOODIX_SPI is not set
# CONFIG_HID_GOOGLE_STADIA_FF is not set
# CONFIG_HID_VIVALDI is not set
CONFIG_HID_GT683R=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_KYSONA is not set
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
# CONFIG_HID_VRC2 is not set
CONFIG_HID_XIAOMI=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
CONFIG_HID_LETSKETCH=m
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_MEGAWORLD_FF is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NINTENDO is not set
CONFIG_HID_NTI=m
CONFIG_HID_NTRIG=y
# CONFIG_HID_NVIDIA_SHIELD is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PENMOUNT=m
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PLANTRONICS=m
# CONFIG_HID_PXRC is not set
# CONFIG_HID_RAPOO is not set
# CONFIG_HID_RAZER is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SEMITEK=m
CONFIG_HID_SIGMAMICRO=m
CONFIG_HID_SONY=m
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
# CONFIG_HID_TOPRE is not set
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_UNIVERSAL_PIDFF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_WINWING is not set
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2200 is not set
# CONFIG_HID_MCP2221 is not set
# CONFIG_HID_HUAWEI is not set
# end of Special HID drivers

#
# HID-BPF support
#
CONFIG_HID_BPF=y
# end of HID-BPF support

CONFIG_I2C_HID=y
CONFIG_I2C_HID_ACPI=m
# CONFIG_I2C_HID_OF is not set
CONFIG_I2C_HID_CORE=m

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
CONFIG_AMD_SFH_HID=m
# end of AMD SFH HID Support

#
# Intel THC HID Support
#
# CONFIG_INTEL_THC_HID is not set
# end of Intel THC HID Support

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y
# end of USB HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_PCI_AMD=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
# CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=m
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_DEFAULT_AUTHORIZATION_MODE=1
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_DBGCAP=y
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
CONFIG_USB_XHCI_PLATFORM=m
# CONFIG_USB_XHCI_SIDEBAND is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set
# CONFIG_USB_XEN_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
# CONFIG_USBIP_CORE is not set

#
# USB dual-mode controller drivers
#
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_F8153X=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MXUPORT=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_UPD78F0730=m
# CONFIG_USB_SERIAL_XR is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_LJCA is not set
# CONFIG_USB_USBIO is not set
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
CONFIG_TYPEC_TCPM=m
CONFIG_TYPEC_TCPCI=m
# CONFIG_TYPEC_RT1711H is not set
# CONFIG_TYPEC_TCPCI_MAXIM is not set
CONFIG_TYPEC_FUSB302=m
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_UCSI_STM32G0 is not set
CONFIG_TYPEC_TPS6598X=m
# CONFIG_TYPEC_ANX7411 is not set
CONFIG_TYPEC_RT1719=m
# CONFIG_TYPEC_HD3SS3220 is not set
# CONFIG_TYPEC_STUSB160X is not set
CONFIG_TYPEC_WUSB3801=m

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
CONFIG_TYPEC_MUX_FSA4480=m
# CONFIG_TYPEC_MUX_GPIO_SBU is not set
CONFIG_TYPEC_MUX_PI3USB30532=m
# CONFIG_TYPEC_MUX_IT5205 is not set
# CONFIG_TYPEC_MUX_NB7VPQ904M is not set
# CONFIG_TYPEC_MUX_PS883X is not set
# CONFIG_TYPEC_MUX_PTN36502 is not set
# CONFIG_TYPEC_MUX_TUSB1046 is not set
# CONFIG_TYPEC_MUX_WCD939X_USBSS is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
CONFIG_TYPEC_DP_ALTMODE=m
# CONFIG_TYPEC_NVIDIA_ALTMODE is not set
# CONFIG_TYPEC_TBT_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

CONFIG_USB_ROLE_SWITCH=y
CONFIG_USB_ROLES_INTEL_XHCI=m
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_UHS2=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_REALTEK_PCI=m
CONFIG_MMC_REALTEK_USB=m
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_USB=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
# CONFIG_LEDS_OSRAM_AMS_AS3668 is not set
# CONFIG_LEDS_AW200XX is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA995X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2606MVV is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_IS31FL319X is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
CONFIG_LEDS_MLXREG=m
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_SPI_BYTE is not set

#
# Flash and Torch LED drivers
#

#
# RGB LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_DISK=y
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
# CONFIG_LEDS_TRIGGER_TTY is not set
# CONFIG_LEDS_TRIGGER_INPUT_EVENTS is not set

#
# Simatic LED drivers
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
CONFIG_INFINIBAND_VIRT_DMA=y
CONFIG_INFINIBAND_BNXT_RE=m
CONFIG_INFINIBAND_CXGB4=m
CONFIG_INFINIBAND_EFA=m
# CONFIG_INFINIBAND_ERDMA is not set
CONFIG_INFINIBAND_HFI1=m
# CONFIG_HFI1_DEBUG_SDMA_ORDER is not set
# CONFIG_SDMA_VERBOSITY is not set
# CONFIG_INFINIBAND_IONIC is not set
CONFIG_INFINIBAND_IRDMA=m
CONFIG_MLX4_INFINIBAND=m
CONFIG_MLX5_INFINIBAND=m
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_QEDR=m
CONFIG_INFINIBAND_USNIC=m
CONFIG_INFINIBAND_VMWARE_PVRDMA=m
CONFIG_INFINIBAND_RDMAVT=m
CONFIG_RDMA_RXE=m
CONFIG_RDMA_SIW=m
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
CONFIG_INFINIBAND_ISER=m
CONFIG_INFINIBAND_ISERT=m
# CONFIG_INFINIBAND_RTRS_CLIENT is not set
# CONFIG_INFINIBAND_RTRS_SERVER is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_GHES=y
# CONFIG_EDAC_SCRUB is not set
# CONFIG_EDAC_ECS is not set
# CONFIG_EDAC_MEM_REPAIR is not set
CONFIG_EDAC_AMD64=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
CONFIG_EDAC_I10NM=m
# CONFIG_EDAC_IMH is not set
CONFIG_EDAC_PND2=m
CONFIG_EDAC_IGEN6=m
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
# CONFIG_RTC_DRV_MAX31335 is not set
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
# CONFIG_RTC_DRV_RX8111 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
CONFIG_RTC_DRV_RV8803=m
# CONFIG_RTC_DRV_SD2405AL is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF85063 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set
# CONFIG_RTC_DRV_RX6110 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_RP5C01=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set
# CONFIG_RTC_DRV_GOLDFISH is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
CONFIG_INTEL_IDXD_BUS=m
CONFIG_INTEL_IDXD=m
# CONFIG_INTEL_IDXD_COMPAT is not set
CONFIG_INTEL_IDXD_SVM=y
CONFIG_INTEL_IDXD_PERFMON=y
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_SWITCHTEC_DMA is not set
# CONFIG_XILINX_DMA is not set
# CONFIG_XILINX_XDMA is not set
# CONFIG_AMD_AE4DMA is not set
CONFIG_AMD_PTDMA=m
# CONFIG_AMD_QDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
# CONFIG_INTEL_LDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
CONFIG_UDMABUF=y
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
CONFIG_DMABUF_HEAPS=y
CONFIG_DMABUF_HEAPS_SYSTEM=y
# CONFIG_DMABUF_HEAPS_CMA is not set
# end of DMABUF options

CONFIG_DCA=m
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_UIO_PCI_GENERIC_SVA is not set
CONFIG_VFIO=m
CONFIG_VFIO_DEVICE_CDEV=y
CONFIG_VFIO_GROUP=y
CONFIG_VFIO_CONTAINER=y
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_VIRQFD=y
# CONFIG_VFIO_DEBUGFS is not set

#
# VFIO support for PCI devices
#
CONFIG_VFIO_PCI_CORE=m
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_PCI_DMABUF=y
CONFIG_MLX5_VFIO_PCI=m
# CONFIG_VIRTIO_VFIO_PCI is not set
# CONFIG_QAT_VFIO_PCI is not set
# end of VFIO support for PCI devices

CONFIG_IRQ_BYPASS_MANAGER=m
CONFIG_VIRT_DRIVERS=y
CONFIG_VMGENID=y
# CONFIG_VBOXGUEST is not set
CONFIG_NITRO_ENCLAVES=m
CONFIG_EFI_SECRET=m
CONFIG_SEV_GUEST=m
CONFIG_TDX_GUEST_DRIVER=m
CONFIG_TSM_GUEST=y
CONFIG_TSM_REPORTS=m
CONFIG_TSM_MEASUREMENTS=y
CONFIG_TSM=y
CONFIG_VIRTIO_ANCHOR=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_PCI_LIB_LEGACY=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_ADMIN_LEGACY=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_VDPA=m
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MEM=m
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VIRTIO_DEBUG is not set
# CONFIG_VIRTIO_RTC is not set
CONFIG_VDPA=m
# CONFIG_VDPA_USER is not set
CONFIG_IFCVF=m
CONFIG_MLX5_VDPA=y
CONFIG_MLX5_VDPA_NET=m
# CONFIG_MLX5_VDPA_STEERING_DEBUG is not set
CONFIG_VP_VDPA=m
# CONFIG_ALIBABA_ENI_VDPA is not set
# CONFIG_SNET_VDPA is not set
# CONFIG_OCTEONEP_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST_RING=m
CONFIG_VHOST_TASK=y
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
CONFIG_VHOST_VDPA=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set
CONFIG_VHOST_ENABLE_FORK_OWNER_CONTROL=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_FRONT_PGDIR_SHBUF=m
# CONFIG_XEN_UNPOPULATED_ALLOC is not set
# CONFIG_XEN_VIRTIO is not set
# end of Xen driver support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
# CONFIG_GPIB is not set
# CONFIG_STAGING is not set
# CONFIG_GOLDFISH is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLX_PLATFORM=m
# CONFIG_MLXREG_DPU is not set
CONFIG_MLXREG_HOTPLUG=m
CONFIG_MLXREG_IO=m
CONFIG_MLXREG_LC=m
CONFIG_NVSW_SN2201=m
# CONFIG_SURFACE_PLATFORMS is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
# CONFIG_X86_PLATFORM_DRIVERS_UNIWILL is not set
CONFIG_UV_SYSFS=m
CONFIG_MXM_WMI=m
CONFIG_NVIDIA_WMI_EC_BACKLIGHT=m
# CONFIG_XIAOMI_WMI is not set
# CONFIG_REDMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
# CONFIG_BITLAND_MIFS_WMI is not set
# CONFIG_ACERHDF is not set
CONFIG_ACER_WIRELESS=m
CONFIG_ACER_WMI=m

#
# AMD HSMP Driver
#
# CONFIG_AMD_HSMP_ACPI is not set
# CONFIG_AMD_HSMP_PLAT is not set
# end of AMD HSMP Driver

CONFIG_AMD_PMC=m
CONFIG_AMD_MP2_STB=y
# CONFIG_AMD_HFI is not set
# CONFIG_AMD_3D_VCACHE is not set
# CONFIG_AMD_WBRF is not set
# CONFIG_AMD_ISP_PLATFORM is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
# CONFIG_ASUS_ARMOURY is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_WMI_DEPRECATED_ATTRS=y
CONFIG_ASUS_NB_WMI=m
# CONFIG_ASUS_TF103C_DOCK is not set
# CONFIG_AYANEO_EC is not set
# CONFIG_MERAKI_MX100 is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
CONFIG_X86_PLATFORM_DRIVERS_DELL=y
# CONFIG_ALIENWARE_WMI is not set
CONFIG_DCDBAS=m
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_RBU=m
CONFIG_DELL_RBTN=m
CONFIG_DELL_PC=m
CONFIG_DELL_SMBIOS=m
CONFIG_DELL_SMBIOS_WMI=y
# CONFIG_DELL_SMBIOS_SMM is not set
CONFIG_DELL_SMO8800=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_PRIVACY=y
CONFIG_DELL_WMI_AIO=m
CONFIG_DELL_WMI_DESCRIPTOR=m
CONFIG_DELL_WMI_DDV=m
CONFIG_DELL_WMI_LED=m
CONFIG_DELL_WMI_SYSMAN=m
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
# CONFIG_X86_PLATFORM_DRIVERS_HP is not set
CONFIG_WIRELESS_HOTKEY=m
# CONFIG_IBM_RTL is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_ATOMISP2_PM is not set
CONFIG_INTEL_IFS=m
# CONFIG_INTEL_SAR_INT1092 is not set
CONFIG_INTEL_PMC_CORE=m
CONFIG_INTEL_PMC_SSRAM_TELEMETRY=m
CONFIG_INTEL_PMT_CLASS=m
CONFIG_INTEL_PMT_TELEMETRY=m
CONFIG_INTEL_PMT_CRASHLOG=m
CONFIG_INTEL_PMT_DISCOVERY=m

#
# Intel Speed Select Technology interface support
#
CONFIG_INTEL_SPEED_SELECT_TPMI=m
CONFIG_INTEL_SPEED_SELECT_INTERFACE=m
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_WMI=y
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m

#
# Intel Uncore Frequency Control
#
CONFIG_INTEL_UNCORE_FREQ_CONTROL_TPMI=m
CONFIG_INTEL_UNCORE_FREQ_CONTROL=m
# end of Intel Uncore Frequency Control

CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
# CONFIG_INTEL_EHL_PSE_IO is not set
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_OAKTRAIL=m
CONFIG_INTEL_ISHTP_ECLITE=m
# CONFIG_INTEL_PUNIT_IPC is not set
CONFIG_INTEL_RST=m
CONFIG_INTEL_SDSI=m
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_INTEL_TPMI_POWER_DOMAINS=m
CONFIG_INTEL_TPMI=m
# CONFIG_INTEL_PLR_TPMI is not set
CONFIG_INTEL_TURBO_MAX_3=y
CONFIG_INTEL_VSEC=m
CONFIG_IDEAPAD_LAPTOP=m
# CONFIG_LENOVO_WMI_HOTKEY_UTILITIES is not set
# CONFIG_LENOVO_WMI_CAMERA is not set
# CONFIG_LENOVO_YMC is not set
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_THINKPAD_LMI=m
# CONFIG_YOGABOOK is not set
# CONFIG_LENOVO_WMI_GAMEZONE is not set
# CONFIG_LENOVO_WMI_TUNING is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_MEEGOPAD_ANX7428 is not set
# CONFIG_MSI_EC is not set
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_MSI_WMI_PLATFORM is not set
# CONFIG_PCENGINES_APU2 is not set
# CONFIG_PORTWELL_EC is not set
# CONFIG_BARCO_P50_GPIO is not set
# CONFIG_SAMSUNG_GALAXYBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_SERIAL_MULTI_INSTANTIATE=m
# CONFIG_INSPUR_PLATFORM_PROFILE is not set
# CONFIG_DASHARO_ACPI is not set
CONFIG_FW_ATTR_CLASS=m
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
# CONFIG_SIEMENS_SIMATIC_IPC is not set
# CONFIG_WINMATE_FM07_KEYS is not set
# CONFIG_SEL3350_PLATFORM is not set
# CONFIG_OXP_EC is not set
# CONFIG_TUXEDO_NB04_WMI_AB is not set
CONFIG_P2SB=y
CONFIG_ACPI_WMI=m
# CONFIG_ACPI_WMI_LEGACY_DEVICE_NAMES is not set
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_LMK04832 is not set
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_XILINX_VCU is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOMMU_API=y
CONFIG_IOMMUFD_DRIVER=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_DMA_STRICT is not set
CONFIG_IOMMU_DEFAULT_DMA_LAZY=y
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_IOMMU_SVA=y
CONFIG_IOMMU_IOPF=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_IOMMUFD is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_SVM=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
# CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_PERF_EVENTS=y
CONFIG_IOMMUFD_DRIVER_CORE=y
CONFIG_IOMMUFD=m
CONFIG_IRQ_REMAP=y
CONFIG_VIRTIO_IOMMU=y
CONFIG_GENERIC_PT=y
# CONFIG_DEBUG_GENERIC_PT is not set
CONFIG_IOMMU_PT=y
CONFIG_IOMMU_PT_AMDV1=y
CONFIG_IOMMU_PT_VTDSS=y
# CONFIG_IOMMU_PT_RISCV64 is not set
CONFIG_IOMMU_PT_X86_64=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

CONFIG_SOUNDWIRE=m

#
# SoundWire Devices
#
CONFIG_SOUNDWIRE_AMD=m
CONFIG_SOUNDWIRE_CADENCE=m
CONFIG_SOUNDWIRE_INTEL=m
# CONFIG_SOUNDWIRE_QCOM is not set
CONFIG_SOUNDWIRE_GENERIC_ALLOCATION=m

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# fujitsu SoC drivers
#
# end of fujitsu SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

# CONFIG_WPCM450_SOC is not set

#
# Qualcomm SoC drivers
#
CONFIG_QCOM_QMI_HELPERS=m
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

#
# PM Domains
#

#
# Amlogic PM Domains
#
# end of Amlogic PM Domains

#
# Broadcom PM Domains
#
# end of Broadcom PM Domains

#
# i.MX PM Domains
#
# end of i.MX PM Domains

#
# Qualcomm PM Domains
#
# end of Qualcomm PM Domains
# end of PM Domains

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
# CONFIG_IIO_BUFFER_DMA is not set
# CONFIG_IIO_BUFFER_DMAENGINE is not set
# CONFIG_IIO_BUFFER_HW_CONSUMER is not set
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
# CONFIG_IIO_CONFIGFS is not set
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
# CONFIG_IIO_SW_DEVICE is not set
# CONFIG_IIO_SW_TRIGGER is not set
# CONFIG_IIO_TRIGGERED_EVENT is not set

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADXL313_I2C is not set
# CONFIG_ADXL313_SPI is not set
# CONFIG_ADXL345_I2C is not set
# CONFIG_ADXL345_SPI is not set
# CONFIG_ADXL355_I2C is not set
# CONFIG_ADXL355_SPI is not set
# CONFIG_ADXL367_SPI is not set
# CONFIG_ADXL367_I2C is not set
# CONFIG_ADXL372_SPI is not set
# CONFIG_ADXL372_I2C is not set
# CONFIG_ADXL380_SPI is not set
# CONFIG_ADXL380_I2C is not set
# CONFIG_BMA180 is not set
# CONFIG_BMA220 is not set
# CONFIG_BMA400 is not set
# CONFIG_BMC150_ACCEL is not set
# CONFIG_BMI088_ACCEL is not set
# CONFIG_DA280 is not set
# CONFIG_DA311 is not set
# CONFIG_DMARD06 is not set
# CONFIG_DMARD09 is not set
# CONFIG_DMARD10 is not set
# CONFIG_FXLS8962AF_I2C is not set
# CONFIG_FXLS8962AF_SPI is not set
CONFIG_HID_SENSOR_ACCEL_3D=m
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
# CONFIG_IIO_KX022A_SPI is not set
# CONFIG_IIO_KX022A_I2C is not set
# CONFIG_KXSD9 is not set
# CONFIG_KXCJK1013 is not set
# CONFIG_MC3230 is not set
# CONFIG_MMA7455_I2C is not set
# CONFIG_MMA7455_SPI is not set
# CONFIG_MMA7660 is not set
# CONFIG_MMA8452 is not set
# CONFIG_MMA9551 is not set
# CONFIG_MMA9553 is not set
# CONFIG_MSA311 is not set
# CONFIG_MXC4005 is not set
# CONFIG_MXC6255 is not set
# CONFIG_SCA3000 is not set
# CONFIG_SCA3300 is not set
# CONFIG_STK8312 is not set
# CONFIG_STK8BA50 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD4000 is not set
# CONFIG_AD4030 is not set
# CONFIG_AD4080 is not set
# CONFIG_AD4130 is not set
# CONFIG_AD4134 is not set
# CONFIG_AD4170_4 is not set
# CONFIG_AD4695 is not set
# CONFIG_AD4851 is not set
# CONFIG_AD7091R5 is not set
# CONFIG_AD7091R8 is not set
# CONFIG_AD7124 is not set
# CONFIG_AD7173 is not set
# CONFIG_AD7191 is not set
# CONFIG_AD7192 is not set
# CONFIG_AD7266 is not set
# CONFIG_AD7280 is not set
# CONFIG_AD7291 is not set
# CONFIG_AD7292 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7380 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
# CONFIG_AD7625 is not set
# CONFIG_AD7766 is not set
# CONFIG_AD7768_1 is not set
# CONFIG_AD7779 is not set
# CONFIG_AD7780 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
# CONFIG_AD7944 is not set
# CONFIG_AD7949 is not set
# CONFIG_AD799X is not set
# CONFIG_AD9467 is not set
# CONFIG_ADE9000 is not set
# CONFIG_ENVELOPE_DETECTOR is not set
# CONFIG_GEHC_PMC_ADC is not set
# CONFIG_HI8435 is not set
# CONFIG_HX711 is not set
# CONFIG_INA2XX_ADC is not set
# CONFIG_LTC2309 is not set
# CONFIG_LTC2471 is not set
# CONFIG_LTC2485 is not set
# CONFIG_LTC2496 is not set
# CONFIG_LTC2497 is not set
# CONFIG_MAX1027 is not set
# CONFIG_MAX11100 is not set
# CONFIG_MAX1118 is not set
# CONFIG_MAX11205 is not set
# CONFIG_MAX11410 is not set
# CONFIG_MAX1241 is not set
# CONFIG_MAX1363 is not set
# CONFIG_MAX14001 is not set
# CONFIG_MAX34408 is not set
# CONFIG_MAX9611 is not set
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
# CONFIG_MCP3564 is not set
# CONFIG_MCP3911 is not set
# CONFIG_NAU7802 is not set
# CONFIG_NCT7201 is not set
# CONFIG_PAC1921 is not set
# CONFIG_PAC1934 is not set
# CONFIG_ROHM_BD79112 is not set
# CONFIG_ROHM_BD79124 is not set
# CONFIG_RICHTEK_RTQ6056 is not set
# CONFIG_SD_ADC_MODULATOR is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_ADC0832 is not set
# CONFIG_TI_ADC084S021 is not set
# CONFIG_TI_ADC108S102 is not set
# CONFIG_TI_ADC12138 is not set
# CONFIG_TI_ADC128S052 is not set
# CONFIG_TI_ADC161S626 is not set
# CONFIG_TI_ADS1015 is not set
# CONFIG_TI_ADS1018 is not set
# CONFIG_TI_ADS1100 is not set
# CONFIG_TI_ADS1119 is not set
# CONFIG_TI_ADS124S08 is not set
# CONFIG_TI_ADS1298 is not set
# CONFIG_TI_ADS131E08 is not set
# CONFIG_TI_ADS7138 is not set
# CONFIG_TI_ADS7924 is not set
# CONFIG_TI_ADS7950 is not set
# CONFIG_TI_ADS8344 is not set
# CONFIG_TI_ADS8688 is not set
# CONFIG_TI_LMP92064 is not set
# CONFIG_TI_TLC4541 is not set
# CONFIG_TI_TSC2046 is not set
# CONFIG_VF610_ADC is not set
# CONFIG_XILINX_XADC is not set
# end of Analog to digital converters

#
# Analog to digital and digital to analog converters
#
# CONFIG_AD74115 is not set
# CONFIG_AD74413R is not set
# end of Analog to digital and digital to analog converters

#
# Analog Front Ends
#
# CONFIG_IIO_RESCALE is not set
# end of Analog Front Ends

#
# Amplifiers
#
# CONFIG_AD8366 is not set
# CONFIG_ADA4250 is not set
# CONFIG_ADL8113 is not set
# CONFIG_HMC425 is not set
# end of Amplifiers

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7746 is not set
# end of Capacitance to digital converters

#
# Chemical Sensors
#
# CONFIG_AOSONG_AGS02MA is not set
# CONFIG_ATLAS_PH_SENSOR is not set
# CONFIG_ATLAS_EZO_SENSOR is not set
# CONFIG_BME680 is not set
# CONFIG_CCS811 is not set
# CONFIG_ENS160 is not set
# CONFIG_IAQCORE is not set
# CONFIG_SCD30_CORE is not set
# CONFIG_SCD4X is not set
# CONFIG_SEN0322 is not set
# CONFIG_SENSIRION_SGP30 is not set
# CONFIG_SENSIRION_SGP40 is not set
# CONFIG_SPS30_I2C is not set
# CONFIG_SENSEAIR_SUNRISE_CO2 is not set
# CONFIG_VZ89X is not set
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
# end of Hid Sensor IIO Common

#
# IIO SCMI Sensors
#
# end of IIO SCMI Sensors

#
# SSP Sensor Common
#
# CONFIG_IIO_SSP_SENSORHUB is not set
# end of SSP Sensor Common

#
# Digital to analog converters
#
# CONFIG_AD3530R is not set
# CONFIG_AD3552R_HS is not set
# CONFIG_AD3552R is not set
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
# CONFIG_AD5446_SPI is not set
# CONFIG_AD5446_I2C is not set
# CONFIG_AD5449 is not set
# CONFIG_AD5592R is not set
# CONFIG_AD5593R is not set
# CONFIG_AD5504 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_AD9739A is not set
# CONFIG_LTC2688 is not set
# CONFIG_AD5686_SPI is not set
# CONFIG_AD5696_I2C is not set
# CONFIG_AD5755 is not set
# CONFIG_AD5758 is not set
# CONFIG_AD5761 is not set
# CONFIG_AD5764 is not set
# CONFIG_AD5766 is not set
# CONFIG_AD5770R is not set
# CONFIG_AD5791 is not set
# CONFIG_AD7293 is not set
# CONFIG_AD7303 is not set
# CONFIG_AD8460 is not set
# CONFIG_AD8801 is not set
# CONFIG_BD79703 is not set
# CONFIG_DPOT_DAC is not set
# CONFIG_DS4424 is not set
# CONFIG_LTC1660 is not set
# CONFIG_LTC2632 is not set
# CONFIG_LTC2664 is not set
# CONFIG_M62332 is not set
# CONFIG_MAX517 is not set
# CONFIG_MAX22007 is not set
# CONFIG_MAX5522 is not set
# CONFIG_MAX5821 is not set
# CONFIG_MCP4725 is not set
# CONFIG_MCP4728 is not set
# CONFIG_MCP47FEB02 is not set
# CONFIG_MCP4821 is not set
# CONFIG_MCP4922 is not set
# CONFIG_TI_DAC082S085 is not set
# CONFIG_TI_DAC5571 is not set
# CONFIG_TI_DAC7311 is not set
# CONFIG_TI_DAC7612 is not set
# CONFIG_VF610_DAC is not set
# end of Digital to analog converters

#
# IIO dummy driver
#
# end of IIO dummy driver

#
# Filters
#
# CONFIG_ADMV8818 is not set
# end of Filters

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set
# CONFIG_ADF4371 is not set
# CONFIG_ADF4377 is not set
# CONFIG_ADMFM2000 is not set
# CONFIG_ADMV1013 is not set
# CONFIG_ADMV1014 is not set
# CONFIG_ADMV4420 is not set
# CONFIG_ADRF6780 is not set
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS290 is not set
# CONFIG_ADXRS450 is not set
# CONFIG_BMG160 is not set
# CONFIG_FXAS21002C is not set
CONFIG_HID_SENSOR_GYRO_3D=m
# CONFIG_MPU3050_I2C is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
# CONFIG_AFE4403 is not set
# CONFIG_AFE4404 is not set
# CONFIG_MAX30100 is not set
# CONFIG_MAX30102 is not set
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
# CONFIG_DHT11 is not set
# CONFIG_ENS210 is not set
# CONFIG_HDC100X is not set
# CONFIG_HDC2010 is not set
# CONFIG_HDC3020 is not set
CONFIG_HID_SENSOR_HUMIDITY=m
# CONFIG_HTS221 is not set
# CONFIG_HTU21 is not set
# CONFIG_SI7005 is not set
# CONFIG_SI7020 is not set
# end of Humidity sensors

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
# CONFIG_ADIS16460 is not set
# CONFIG_ADIS16475 is not set
# CONFIG_ADIS16480 is not set
# CONFIG_ADIS16550 is not set
# CONFIG_BMI160_I2C is not set
# CONFIG_BMI160_SPI is not set
# CONFIG_BMI270_I2C is not set
# CONFIG_BMI270_SPI is not set
# CONFIG_BMI323_I2C is not set
# CONFIG_BMI323_SPI is not set
# CONFIG_BOSCH_BNO055_I2C is not set
# CONFIG_FXOS8700_I2C is not set
# CONFIG_FXOS8700_SPI is not set
# CONFIG_KMX61 is not set
# CONFIG_INV_ICM42600_I2C is not set
# CONFIG_INV_ICM42600_SPI is not set
# CONFIG_INV_ICM45600_I2C is not set
# CONFIG_INV_ICM45600_SPI is not set
# CONFIG_INV_MPU6050_I2C is not set
# CONFIG_INV_MPU6050_SPI is not set
# CONFIG_SMI240 is not set
# CONFIG_SMI330_I2C is not set
# CONFIG_SMI330_SPI is not set
# CONFIG_IIO_ST_LSM6DSX is not set
# CONFIG_IIO_ST_LSM9DS0 is not set
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
# CONFIG_ADJD_S311 is not set
# CONFIG_ADUX1020 is not set
# CONFIG_AL3000A is not set
# CONFIG_AL3010 is not set
# CONFIG_AL3320A is not set
# CONFIG_APDS9160 is not set
# CONFIG_APDS9300 is not set
# CONFIG_APDS9306 is not set
# CONFIG_APDS9960 is not set
# CONFIG_AS73211 is not set
# CONFIG_BH1745 is not set
# CONFIG_BH1750 is not set
# CONFIG_BH1780 is not set
# CONFIG_CM32181 is not set
# CONFIG_CM3232 is not set
# CONFIG_CM3323 is not set
# CONFIG_CM3605 is not set
# CONFIG_CM36651 is not set
# CONFIG_GP2AP002 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_ISL29125 is not set
# CONFIG_ISL76682 is not set
CONFIG_HID_SENSOR_ALS=m
CONFIG_HID_SENSOR_PROX=m
# CONFIG_JSA1212 is not set
# CONFIG_ROHM_BU27034 is not set
# CONFIG_RPR0521 is not set
# CONFIG_LTR390 is not set
# CONFIG_LTR501 is not set
# CONFIG_LTRF216A is not set
# CONFIG_LV0104CS is not set
# CONFIG_MAX44000 is not set
# CONFIG_MAX44009 is not set
# CONFIG_NOA1305 is not set
# CONFIG_OPT3001 is not set
# CONFIG_OPT4001 is not set
# CONFIG_OPT4060 is not set
# CONFIG_PA12203001 is not set
# CONFIG_SI1133 is not set
# CONFIG_SI1145 is not set
# CONFIG_STK3310 is not set
# CONFIG_ST_UVIS25 is not set
# CONFIG_TCS3414 is not set
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2591 is not set
# CONFIG_TSL2772 is not set
# CONFIG_TSL4531 is not set
# CONFIG_US5182D is not set
# CONFIG_VCNL4000 is not set
# CONFIG_VCNL4035 is not set
# CONFIG_VEML3235 is not set
# CONFIG_VEML6030 is not set
# CONFIG_VEML6040 is not set
# CONFIG_VEML6046X00 is not set
# CONFIG_VEML6070 is not set
# CONFIG_VEML6075 is not set
# CONFIG_VL6180 is not set
# CONFIG_ZOPT2201 is not set
# end of Light sensors

#
# Magnetometer sensors
#
# CONFIG_AK8974 is not set
# CONFIG_AK8975 is not set
# CONFIG_AK09911 is not set
# CONFIG_ALS31300 is not set
# CONFIG_BMC150_MAGN_I2C is not set
# CONFIG_BMC150_MAGN_SPI is not set
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
# CONFIG_MMC35240 is not set
# CONFIG_MMC5633 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set
# CONFIG_INFINEON_TLV493D is not set
# CONFIG_SENSORS_HMC5843_I2C is not set
# CONFIG_SENSORS_HMC5843_SPI is not set
# CONFIG_SENSORS_RM3100_I2C is not set
# CONFIG_SENSORS_RM3100_SPI is not set
# CONFIG_SI7210 is not set
# CONFIG_TI_TMAG5273 is not set
# CONFIG_YAMAHA_YAS530 is not set
# end of Magnetometer sensors

#
# Multiplexers
#
# CONFIG_IIO_MUX is not set
# end of Multiplexers

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m
CONFIG_HID_SENSOR_DEVICE_ROTATION=m
# end of Inclinometer sensors

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set
# end of Triggers - standalone

#
# Linear and angular position sensors
#
# CONFIG_HID_SENSOR_CUSTOM_INTEL_HINGE is not set
# end of Linear and angular position sensors

#
# Digital potentiometers
#
# CONFIG_AD5110 is not set
# CONFIG_AD5272 is not set
# CONFIG_DS1803 is not set
# CONFIG_MAX5432 is not set
# CONFIG_MAX5481 is not set
# CONFIG_MAX5487 is not set
# CONFIG_MCP4018 is not set
# CONFIG_MCP4131 is not set
# CONFIG_MCP4531 is not set
# CONFIG_MCP41010 is not set
# CONFIG_TPL0102 is not set
# CONFIG_X9250 is not set
# end of Digital potentiometers

#
# Digital potentiostats
#
# CONFIG_LMP91000 is not set
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
# CONFIG_ABP2030PA_I2C is not set
# CONFIG_ABP2030PA_SPI is not set
# CONFIG_ROHM_BM1390 is not set
# CONFIG_BMP280 is not set
# CONFIG_DLHL60D is not set
# CONFIG_DPS310 is not set
CONFIG_HID_SENSOR_PRESS=m
# CONFIG_HP03 is not set
# CONFIG_HSC030PA is not set
# CONFIG_ICP10100 is not set
# CONFIG_MPL115_I2C is not set
# CONFIG_MPL115_SPI is not set
# CONFIG_MPL3115 is not set
# CONFIG_MPRLS0025PA_I2C is not set
# CONFIG_MPRLS0025PA_SPI is not set
# CONFIG_MS5611 is not set
# CONFIG_MS5637 is not set
# CONFIG_SDP500 is not set
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_T5403 is not set
# CONFIG_HP206C is not set
# CONFIG_ZPA2326 is not set
# CONFIG_ADP810 is not set
# end of Pressure sensors

#
# Lightning sensors
#
# CONFIG_AS3935 is not set
# end of Lightning sensors

#
# Proximity and distance sensors
#
# CONFIG_D3323AA is not set
# CONFIG_HX9023S is not set
# CONFIG_IRSD200 is not set
# CONFIG_ISL29501 is not set
# CONFIG_LIDAR_LITE_V2 is not set
# CONFIG_MB1232 is not set
# CONFIG_PING is not set
# CONFIG_RFD77402 is not set
# CONFIG_SRF04 is not set
# CONFIG_SX9310 is not set
# CONFIG_SX9324 is not set
# CONFIG_SX9360 is not set
# CONFIG_SX9500 is not set
# CONFIG_SRF08 is not set
# CONFIG_VCNL3020 is not set
# CONFIG_VL53L0X_I2C is not set
# CONFIG_VL53L1X_I2C is not set
# CONFIG_AW96103 is not set
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set
# CONFIG_AD2S1200 is not set
# CONFIG_AD2S1210 is not set
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_LTC2983 is not set
# CONFIG_MAXIM_THERMOCOUPLE is not set
CONFIG_HID_SENSOR_TEMP=m
# CONFIG_MLX90614 is not set
# CONFIG_MLX90632 is not set
# CONFIG_MLX90635 is not set
# CONFIG_TMP006 is not set
# CONFIG_TMP007 is not set
# CONFIG_TMP117 is not set
# CONFIG_TSYS01 is not set
# CONFIG_TSYS02D is not set
# CONFIG_MAX30208 is not set
# CONFIG_MAX31856 is not set
# CONFIG_MAX31865 is not set
# CONFIG_MCP9600 is not set
# end of Temperature sensors

CONFIG_NTB=m
CONFIG_NTB_MSI=y
CONFIG_NTB_AMD=m
# CONFIG_NTB_IDT is not set
CONFIG_NTB_INTEL=m
# CONFIG_NTB_EPF is not set
# CONFIG_NTB_SWITCHTEC is not set
CONFIG_NTB_PINGPONG=m
CONFIG_NTB_TOOL=m
CONFIG_NTB_PERF=m
CONFIG_NTB_MSI_TEST=m
CONFIG_NTB_TRANSPORT=m
CONFIG_PWM=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_PROVIDE_GPIO is not set
# CONFIG_PWM_CLK is not set
# CONFIG_PWM_DWC is not set
# CONFIG_PWM_GPIO is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
CONFIG_IRQ_MSI_LIB=y
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_GPIO is not set
# CONFIG_RESET_SIMPLE is not set
# CONFIG_RESET_TI_SYSCON is not set
# CONFIG_RESET_TI_TPS380X is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_CAN_TRANSCEIVER is not set
# CONFIG_PHY_GOOGLE_USB is not set
# CONFIG_USB_LGM_PHY is not set

#
# PHY drivers for Broadcom platforms
#
# CONFIG_BCM_KONA_USB2_PHY is not set
# end of PHY drivers for Broadcom platforms

# CONFIG_PHY_INTEL_LGM_EMMC is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_CPCAP_USB is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
CONFIG_INTEL_RAPL_TPMI=m
CONFIG_IDLE_INJECT=y
# CONFIG_MCB is not set

#
# Performance monitor support
#
# CONFIG_DWC_PCIE_PMU is not set
# CONFIG_CXL_PMU is not set
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
CONFIG_AMD_ATL=m
CONFIG_AMD_ATL_PRM=y
CONFIG_RAS_FMPM=m
CONFIG_USB4=y
# CONFIG_USB4_DEBUGFS_WRITE is not set
# CONFIG_USB4_DMA_TEST is not set

#
# Android
#
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_RAMDAX=m
CONFIG_NVDIMM_KEYS=y
# CONFIG_NVDIMM_SECURITY_TEST is not set
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_HMEM=m
CONFIG_DEV_DAX_CXL=m
CONFIG_DEV_DAX_HMEM_DEVICES=y
CONFIG_DEV_DAX_FSDEV=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_LAYOUTS is not set
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
CONFIG_STM=m
CONFIG_STM_PROTO_BASIC=m
CONFIG_STM_PROTO_SYS_T=m
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
CONFIG_TEE=m
CONFIG_TEE_DMABUF_HEAPS=y
CONFIG_OPTEE_STATIC_PROTMEM_POOL=y
# CONFIG_AMDTEE is not set
# CONFIG_MUX_CORE is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
CONFIG_COUNTER=m
CONFIG_INTEL_QEP=m
# CONFIG_INTERRUPT_CNT is not set
# CONFIG_MOST is not set
# CONFIG_PECI is not set
# CONFIG_HTE is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
CONFIG_FS_STACK=y
CONFIG_BUFFER_HEAD=y
CONFIG_LEGACY_DIRECT_IO=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_SUPPORT_ASCII_CI=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DRAIN_INTENTS=y
CONFIG_XFS_LIVE_HOOKS=y
CONFIG_XFS_MEMORY_BUFS=y
CONFIG_XFS_ONLINE_SCRUB=y
# CONFIG_XFS_ONLINE_SCRUB_STATS is not set
# CONFIG_XFS_ONLINE_REPAIR is not set
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_EXPERIMENTAL is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_F2FS_IOSTAT=y
# CONFIG_F2FS_UNFAIR_RWSEM is not set
# CONFIG_ZONEFS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FS_VERITY=y
# CONFIG_FS_VERITY_BUILTIN_SIGNATURES is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_VIRTIO_FS=m
CONFIG_FUSE_DAX=y
CONFIG_FUSE_PASSTHROUGH=y
CONFIG_FUSE_IO_URING=y
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set
# CONFIG_OVERLAY_FS_DEBUG is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=y
CONFIG_NETFS_STATS=y
# CONFIG_NETFS_DEBUG is not set
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_ERROR_INJECTION is not set
# CONFIG_CACHEFILES_ONDEMAND is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
CONFIG_EXFAT_FS=m
CONFIG_EXFAT_DEFAULT_IOCHARSET="utf8"
# CONFIG_NTFS_FS is not set
# CONFIG_NTFS3_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_TMPFS_INODE64=y
# CONFIG_TMPFS_QUOTA is not set
CONFIG_ARCH_SUPPORTS_HUGETLBFS=y
CONFIG_HUGETLBFS=y
# CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON is not set
CONFIG_HUGETLB_PAGE=y
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
# CONFIG_CRAMFS_MTD is not set
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_CHOICE_DECOMP_BY_MOUNT is not set
CONFIG_SQUASHFS_COMPILE_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_COMPILE_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_COMPILE_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_COMP_CACHE_FULL is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_ZSTD=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_RESCTRL_FS=y
CONFIG_RESCTRL_FS_PSEUDO_LOCK=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_COMPRESS=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_PSTORE_BLK is not set
# CONFIG_UFS_FS is not set
CONFIG_EROFS_FS=m
# CONFIG_EROFS_FS_DEBUG is not set
CONFIG_EROFS_FS_XATTR=y
CONFIG_EROFS_FS_POSIX_ACL=y
CONFIG_EROFS_FS_SECURITY=y
CONFIG_EROFS_FS_BACKED_BY_FILE=y
# CONFIG_EROFS_FS_ZIP is not set
# CONFIG_EROFS_FS_ONDEMAND is not set
# CONFIG_EROFS_FS_PAGE_CACHE_SHARE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_0=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFS_V4_2_READ_PLUS is not set
CONFIG_NFSD=m
# CONFIG_NFSD_V2 is not set
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
CONFIG_NFSD_V4_2_INTER_SSC=y
CONFIG_NFSD_V4_SECURITY_LABEL=y
# CONFIG_NFSD_LEGACY_CLIENT_TRACKING is not set
# CONFIG_NFSD_V4_POSIX_ACLS is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
# CONFIG_NFS_LOCALIO is not set
CONFIG_NFS_V4_2_SSC_HELPER=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_AES_SHA1=y
CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_CAMELLIA=y
CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_AES_SHA2=y
# CONFIG_SUNRPC_DEBUG is not set
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_CEPH_FS=m
CONFIG_CEPH_FSCACHE=y
CONFIG_CEPH_FS_POSIX_ACL=y
CONFIG_CEPH_FS_SECURITY_LABEL=y
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
CONFIG_CIFS_SMB_DIRECT=y
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CIFS_COMPRESSION is not set
# CONFIG_SMB_SERVER is not set
CONFIG_SMBDIRECT=m
CONFIG_SMBFS=m
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
# CONFIG_AFS_DEBUG_CURSOR is not set
CONFIG_9P_FS=y
# CONFIG_9P_FSCACHE is not set
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_NLS_UCS2_UTILS=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_HAVE_TRUSTED_KEYS=y
CONFIG_TRUSTED_KEYS_TPM=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_USER_DECRYPTED_DATA is not set
CONFIG_KEY_DH_OPERATIONS=y
CONFIG_KEY_NOTIFICATIONS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_PROC_MEM_ALWAYS_FORCE is not set
CONFIG_PROC_MEM_FORCE_PTRACE=y
# CONFIG_PROC_MEM_NO_FORCE is not set
CONFIG_SECURITY=y
CONFIG_HAS_SECURITY_AUDIT=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_INFINIBAND=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
CONFIG_SECURITY_SELINUX_AVC_HASH_BITS=9
# CONFIG_SECURITY_SELINUX_DEBUG is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
# CONFIG_SECURITY_APPARMOR_DEBUG is not set
CONFIG_SECURITY_APPARMOR_INTROSPECT_POLICY=y
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_APPARMOR_HASH_DEFAULT=y
CONFIG_SECURITY_APPARMOR_EXPORT_BINARY=y
CONFIG_SECURITY_APPARMOR_PARANOID_LOAD=y
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
CONFIG_SECURITY_LOCKDOWN_LSM=y
CONFIG_SECURITY_LOCKDOWN_LSM_EARLY=y
CONFIG_LOCK_DOWN_KERNEL_FORCE_NONE=y
# CONFIG_LOCK_DOWN_KERNEL_FORCE_INTEGRITY is not set
# CONFIG_LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY is not set
# CONFIG_SECURITY_LANDLOCK is not set
# CONFIG_SECURITY_IPE is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
CONFIG_INTEGRITY_PLATFORM_KEYRING=y
CONFIG_INTEGRITY_MACHINE_KEYRING=y
CONFIG_INTEGRITY_CA_MACHINE_KEYRING=y
CONFIG_INTEGRITY_CA_MACHINE_KEYRING_MAX=y
CONFIG_LOAD_UEFI_KEYS=y
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
# CONFIG_IMA_KEXEC is not set
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_NG_TEMPLATE is not set
CONFIG_IMA_SIG_TEMPLATE=y
CONFIG_IMA_DEFAULT_TEMPLATE="ima-sig"
# CONFIG_IMA_DEFAULT_HASH_SHA1 is not set
CONFIG_IMA_DEFAULT_HASH_SHA256=y
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha256"
CONFIG_IMA_WRITE_POLICY=y
CONFIG_IMA_READ_POLICY=y
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_ARCH_POLICY=y
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
CONFIG_IMA_APPRAISE_MODSIG=y
CONFIG_IMA_KEYRINGS_PERMIT_SIGNED_BY_BUILTIN_OR_SECONDARY=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT=y
# CONFIG_IMA_DISABLE_HTABLE is not set
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="lockdown,yama,integrity,selinux,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_BARE=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y
CONFIG_INIT_STACK_NONE=y
# CONFIG_INIT_STACK_ALL_PATTERN is not set
# CONFIG_INIT_STACK_ALL_ZERO is not set
# CONFIG_KSTACK_ERASE is not set
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
# CONFIG_ZERO_CALL_USED_REGS is not set
# end of Memory initialization

#
# Bounds checking
#
CONFIG_FORTIFY_SOURCE=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_DEFAULT_ON=y
# end of Bounds checking

#
# Hardening of kernel data structures
#
CONFIG_LIST_HARDENED=y
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# end of Hardening of kernel data structures

CONFIG_RANDSTRUCT_NONE=y
# CONFIG_RANDSTRUCT_FULL is not set
# CONFIG_RANDSTRUCT_PERFORMANCE is not set
# end of Kernel hardening options
# end of Security options

CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SIG=y
CONFIG_CRYPTO_SIG2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_ACOMP=m
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_SELFTESTS is not set
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_KRB5ENC=m
CONFIG_CRYPTO_BENCHMARK=m
# end of Crypto core or helper

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_DH_RFC7919_GROUPS=y
CONFIG_CRYPTO_ECC=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_ECDSA=y
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_MLDSA is not set
# end of Public-key cryptography

#
# Block ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_ARIA is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SM4=m
CONFIG_CRYPTO_SM4_GENERIC=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# end of Block ciphers

#
# Length-preserving ciphers and modes
#
CONFIG_CRYPTO_ADIANTUM=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_HCTR2 is not set
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y
# end of Length-preserving ciphers and modes

#
# AEAD (authenticated encryption with associated data) ciphers
#
# CONFIG_CRYPTO_AEGIS128 is not set
CONFIG_CRYPTO_CHACHA20POLY1305=m
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_GENIV=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m
CONFIG_CRYPTO_ESSIV=m
# end of AEAD (authenticated encryption with associated data) ciphers

#
# Hashes, digests, and MACs
#
CONFIG_CRYPTO_BLAKE2B=m
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_XXHASH=m
# end of Hashes, digests, and MACs

#
# CRCs (cyclic redundancy checks)
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32=m
# end of CRCs (cyclic redundancy checks)

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
CONFIG_CRYPTO_ZSTD=m
# end of Compression

#
# Random number generation
#
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_JITTERENTROPY_MEMORY_BLOCKS=64
CONFIG_CRYPTO_JITTERENTROPY_MEMORY_BLOCKSIZE=32
CONFIG_CRYPTO_JITTERENTROPY_OSR=1
CONFIG_CRYPTO_KDF800108_CTR=y
CONFIG_CRYPTO_DF80090A=y
# end of Random number generation

#
# Userspace interface
#
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
# CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE is not set
# end of Userspace interface

#
# Accelerated Cryptographic Algorithms for CPU (x86)
#
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
# CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_ARIA_AESNI_AVX2_X86_64 is not set
# CONFIG_CRYPTO_ARIA_GFNI_AVX512_X86_64 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
# end of Accelerated Cryptographic Algorithms for CPU (x86)

CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
CONFIG_CRYPTO_DEV_QAT_4XXX=m
# CONFIG_CRYPTO_DEV_QAT_420XX is not set
# CONFIG_CRYPTO_DEV_QAT_6XXX is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
# CONFIG_CRYPTO_DEV_QAT_ERROR_INJECTION is not set
CONFIG_CRYPTO_DEV_IAA_CRYPTO=m
# CONFIG_CRYPTO_DEV_IAA_CRYPTO_STATS is not set
CONFIG_CRYPTO_DEV_CHELSIO=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS8_PRIVATE_KEY_PARSER=m
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y
CONFIG_FIPS_SIGNATURE_SELFTEST=y
CONFIG_FIPS_SIGNATURE_SELFTEST_RSA=y
CONFIG_FIPS_SIGNATURE_SELFTEST_ECDSA=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_MODULE_SIG_KEY_TYPE_RSA=y
# CONFIG_MODULE_SIG_KEY_TYPE_ECDSA is not set
# CONFIG_MODULE_SIG_KEY_TYPE_MLDSA_44 is not set
# CONFIG_MODULE_SIG_KEY_TYPE_MLDSA_65 is not set
# CONFIG_MODULE_SIG_KEY_TYPE_MLDSA_87 is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
CONFIG_SECONDARY_TRUSTED_KEYRING=y
# CONFIG_SECONDARY_TRUSTED_KEYRING_SIGNED_BY_BUILTIN is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# CONFIG_SYSTEM_REVOCATION_LIST is not set
# CONFIG_SYSTEM_BLACKLIST_AUTH_UPDATE is not set
CONFIG_OPENSSL_SUPPORTS_ML_DSA=y
# end of Certificates for signature checking

CONFIG_CRYPTO_KRB5=m
# CONFIG_CRYPTO_KRB5_SELFTESTS is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
# CONFIG_RAID6_PQ_BENCHMARK is not set
CONFIG_PACKING=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=m
CONFIG_POLYNOMIAL=m
CONFIG_PRIME_NUMBERS=m
CONFIG_RATIONAL=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y
CONFIG_CRC8=m
CONFIG_CRC16=m
CONFIG_CRC_CCITT=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_T10DIF_ARCH=y
CONFIG_CRC32=y
CONFIG_CRC32_ARCH=y
CONFIG_CRC64=y
CONFIG_CRC64_ARCH=y
CONFIG_CRC_OPTIMIZATIONS=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_LIB_UTILS=y
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_AES_ARCH=y
CONFIG_CRYPTO_LIB_AESCFB=y
CONFIG_CRYPTO_LIB_AES_CBC_MACS=y
CONFIG_CRYPTO_LIB_AESGCM=y
CONFIG_CRYPTO_LIB_ARC4=m
CONFIG_CRYPTO_LIB_GF128MUL=y
CONFIG_CRYPTO_LIB_BLAKE2B=m
CONFIG_CRYPTO_LIB_BLAKE2S_ARCH=y
CONFIG_CRYPTO_LIB_CHACHA=y
CONFIG_CRYPTO_LIB_CHACHA_ARCH=y
CONFIG_CRYPTO_LIB_CURVE25519=m
CONFIG_CRYPTO_LIB_CURVE25519_ARCH=y
CONFIG_CRYPTO_LIB_CURVE25519_GENERIC=y
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_GF128HASH=y
CONFIG_CRYPTO_LIB_GF128HASH_ARCH=y
CONFIG_CRYPTO_LIB_MD5=y
CONFIG_CRYPTO_LIB_NH=m
CONFIG_CRYPTO_LIB_NH_ARCH=y
CONFIG_CRYPTO_LIB_POLY1305=y
CONFIG_CRYPTO_LIB_POLY1305_ARCH=y
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=y
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_LIB_CHACHA20POLY1305=y
CONFIG_CRYPTO_LIB_SHA1=y
CONFIG_CRYPTO_LIB_SHA1_ARCH=y
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_LIB_SHA256_ARCH=y
CONFIG_CRYPTO_LIB_SHA512=y
CONFIG_CRYPTO_LIB_SHA512_ARCH=y
CONFIG_CRYPTO_LIB_SHA3=y
CONFIG_XOR_BLOCKS=m
CONFIG_XOR_BLOCKS_ARCH=y
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMMON=y
CONFIG_ZSTD_COMPRESS=y
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_ARM64=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_RISCV=y
# CONFIG_XZ_DEC_MICROLZMA is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_INTERVAL_TREE=y
CONFIG_INTERVAL_TREE_SPAN_ITER=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS_HELPERS=y
CONFIG_NEED_SG_DMA_FLAGS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_SWIOTLB=y
# CONFIG_SWIOTLB_DYNAMIC is not set
CONFIG_DMA_NEED_SYNC=y
CONFIG_DMA_COHERENT_POOL=y
CONFIG_DMA_CMA=y
# CONFIG_DMA_NUMA_CMA is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_DIMLIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_OVERFLOW_PROTECT=y
CONFIG_VDSO_GETRANDOM=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACKDEPOT_MAX_FRAMES=64
CONFIG_SBITMAP=y
CONFIG_PARMAN=m
CONFIG_OBJAGG=m
# CONFIG_LWQ_TEST is not set
# end of Library routines

CONFIG_PLDMFW=y
CONFIG_ASN1_ENCODER=y
CONFIG_FIRMWARE_TABLE=y
CONFIG_UNION_FIND=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
CONFIG_PRINTK_EXECUTION_CTX=y
# CONFIG_STACKTRACE_BUILD_ID is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_BUGVERBOSE_DETAILED is not set
# end of printk and dmesg options

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_AS_HAS_NON_CONST_ULEB128=y
# CONFIG_DEBUG_INFO_NONE is not set
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_DEBUG_INFO_COMPRESSED_NONE=y
# CONFIG_DEBUG_INFO_COMPRESSED_ZLIB is not set
# CONFIG_DEBUG_INFO_COMPRESSED_ZSTD is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_LANG_EXCLUDE=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_HEADERS_INSTALL=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B is not set
CONFIG_OBJTOOL=y
# CONFIG_OBJTOOL_WERROR is not set
# CONFIG_VMLINUX_MAP is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN=y
# CONFIG_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
CONFIG_HAVE_KCSAN_COMPILER=y
# CONFIG_KCSAN is not set
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
# CONFIG_NET_NS_REFCNT_TRACKER is not set
# CONFIG_DEBUG_NET is not set
# CONFIG_DEBUG_NET_SMALL_RTNL is not set
# end of Networking Debugging

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_TABLE_CHECK is not set
CONFIG_PAGE_POISONING=y
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
CONFIG_DEBUG_WX=y
CONFIG_ARCH_HAS_PTDUMP=y
CONFIG_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_PER_VMA_LOCK_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SHRINKER_DEBUG is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VFS is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_MEM_ALLOC_PROFILING is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_KASAN_SW_TAGS=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
# CONFIG_KASAN is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
CONFIG_HAVE_ARCH_KMSAN=y
# end of Memory Debugging

# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_SOFTLOCKUP_DETECTOR_INTR_STORM is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=0
CONFIG_HAVE_HARDLOCKUP_DETECTOR_BUDDY=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_HARDLOCKUP_DETECTOR_PREFER_BUDDY is not set
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
# CONFIG_HARDLOCKUP_DETECTOR_BUDDY is not set
# CONFIG_HARDLOCKUP_DETECTOR_ARCH is not set
CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=0
CONFIG_DETECT_HUNG_TASK_BLOCKER=y
CONFIG_WQ_WATCHDOG=y
CONFIG_BOOTPARAM_WQ_STALL_PANIC=0
# CONFIG_WQ_CPU_INTENSIVE_REPORT is not set
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_ATOMIC is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

# CONFIG_NMI_CHECK_CPU is not set
# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_MAPLE_TREE is not set
# end of Debug kernel data structures

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_REF_SCALE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
# CONFIG_RCU_CPU_STALL_CPUTIME is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_DEBUG_CGROUP_REF is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FREGS=y
CONFIG_HAVE_FTRACE_GRAPH_FUNC=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_SINGLE_FTRACE_DIRECT_OPS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_REGS_HAVING_PT_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_NO_PATCHABLE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_JMP=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_OBJTOOL_NOP_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_TRACEFS_AUTOMOUNT_DEPRECATED=y
CONFIG_BOOTTIME_TRACING=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_FUNCTION_GRAPH_RETVAL is not set
# CONFIG_FUNCTION_GRAPH_RETADDR is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_DYNAMIC_FTRACE_WITH_JMP=y
# CONFIG_FUNCTION_SELF_TRACING is not set
CONFIG_FPROBE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
CONFIG_OSNOISE_TRACER=y
CONFIG_TIMERLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACE_SYSCALL_BUF_SIZE_DEFAULT=63
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_FPROBE_EVENTS=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_EPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_BPF_KPROBE_OVERRIDE=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
# CONFIG_USER_EVENTS is not set
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_VALIDATE_RCU_IS_WATCHING is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_FTRACE_SORT_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_RV_MON_EVENTS=y
CONFIG_RV_MON_MAINTENANCE_EVENTS=y
CONFIG_DA_MON_EVENTS_ID=y
CONFIG_RV=y
CONFIG_RV_PER_TASK_MONITORS=2
CONFIG_RV_MON_WWNR=y
# CONFIG_RV_MON_RTAPP is not set
# CONFIG_RV_MON_STALL is not set
# CONFIG_RV_MON_DEADLINE is not set
CONFIG_RV_REACTORS=y
CONFIG_RV_REACT_PRINTK=y
CONFIG_RV_REACT_PANIC=y
# CONFIG_TRACE_REMOTE_TEST is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_KCOV=y
# CONFIG_KCOV is not set
# CONFIG_RUNTIME_TESTING_MENU is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# end of Kernel Testing and Coverage

#
# Rust hacking
#
# end of Rust hacking
# end of Kernel hacking

CONFIG_IO_URING_ZCRX=y
CONFIG_IO_URING_BPF=y

--xUBdbXTpns5/xJ1f--

