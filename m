Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A02BBD172A2
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 21:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87F036B0005; Sun,  1 Feb 2026 16:07:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849556B0089; Sun,  1 Feb 2026 16:07:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A716B008A; Sun,  1 Feb 2026 16:07:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 576D76B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 16:07:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED30C1399D1
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 21:07:24 +0000 (UTC)
X-FDA: 84397123608.25.272D6C3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id CB29118000B
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 21:07:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iISrkbVf;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769980041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vf9n3L7kSwUB9spfwHFBZz+atpWBrtGNsSSHMy7Yy+w=;
	b=N2jmYtl6Y6BO1ky5OPd66XoKIc7HIZB3FikR6HJs9p/rEc09G6XgF//us2677zDYszwycH
	MekIHR+8vxpG+rxzqaL056pkuSbuPg/ZtcTsH45yH2NfNHzd5hfeLo6hOS8fJt5zFBJrPG
	ZOPgukeTXZLfh0m8MPSS3dCR0EaUpTQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769980041; a=rsa-sha256;
	cv=fail;
	b=WCBoekhGvZFmX809rxFY6VFb7muroHxB9LDdWbSs5PGdu0tkk1oN/qlLhPWl1K3EcuDnMq
	rEtwn5Qv9FuB294CTwdLejuD858wphqABJJxPpkhHXbHAAYX+s/nISc4KgYJ76g0Jblzos
	0DGkL1+RaKDjbDPoPNyTPZCue/K/IU0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iISrkbVf;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769980041; x=1801516041;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=BQVaaL9YsS59O3Gsr8/yOfzVdEsGCWsYW8TiHqyBIF0=;
  b=iISrkbVffPPzqDVYP6J+9tGlEw/XRlhuw+lNCiiHszPelyTxz+qEMXb3
   vpgO2C6C2YP0DiqomHrdZvjpjvAO667WmSW3SJhmH5Lkw7Gcjj+/f3PJe
   ynUMakzhbshOg9JIYA7KhtyMCTJwU/HOyOGFp4Kv7w8QGsNShdh4Y0dJp
   uPY/ZQDngf/och4UW/e1AekSIFqJlYtHLbCOhjHI1vt7Ht/hD9favWZWj
   os8GVAK0cs+IEIMU86Ap4u0ugJBTHReLukFes1npNkBKhpzpZVe6WZuBh
   5fLgbGM4LeLZgQvIG6zkfDmUc+tmqFDor8aGZVbgllMg+EqS97aA6qUvd
   w==;
X-CSE-ConnectionGUID: Gr8s32iARAux2rAFqVsd/Q==
X-CSE-MsgGUID: wxJtzIFjQWCdk0OlQ84yNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="81462250"
X-IronPort-AV: E=Sophos;i="6.21,267,1763452800"; 
   d="scan'208";a="81462250"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2026 13:07:19 -0800
X-CSE-ConnectionGUID: 6GUbduXJQWeCrlmde1KHaQ==
X-CSE-MsgGUID: CEr5pDvrStmR9aoMCw8b6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,267,1763452800"; 
   d="scan'208";a="209132343"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2026 13:07:19 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sun, 1 Feb 2026 13:07:18 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sun, 1 Feb 2026 13:07:18 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.8) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sun, 1 Feb 2026 13:07:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uhXiUedA52hpBVUVVKDkPxix9tttpPtavQ7Z4SNzivvSoE1f4AtSWED26WL5Oa+JK0ReExCDdgwRjy6d8y/mep6C0xWcMAxp2HopJiBJS6P+Cl+IZj8/Jo6mlZAEJKq03SA1yspwZpsM6Bmbf1wVq9xz5KH7apcFZdfuZG8jeEFRS0l0n8O7NLP+oSCZ+9eiC7934mJU/fjxHcLADd7M8bzjLO2h39USsDaga1xnq1r1hyMRvzPdgAC7sQ9gneUDUTFR8dk0QvrPB++kiHTgZyh56AyaJcOJhxyRpi4k+UN/ti5eCQhulj8dRH3lSgcvdIOCH7p9L5Lt1/CCPi3p3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vf9n3L7kSwUB9spfwHFBZz+atpWBrtGNsSSHMy7Yy+w=;
 b=o2eQl+3cuQAglEl4mrwfVGQmdArwt1lpUTxONLVwU2XoOoPA7hNboP1yaUBCO/TOCaqvcmRiPKEVqOm7IAm2Mzn3WojXruiI+A1kUMfaOdU1ch/d6Tbw8iQqKbAbs0F3N8ZkK5o38h/YvDm8eQqTArvG9xDhqRwjEvL82kE3b1+pRzohjP3J9Rc+SGlMK/mgJomeuoiigxx2LpP+352clUPA3E+DPzThAyawl94BSRtH0joc7whtQjIMaL6anHOaJpdqnYFFLtdTzQh5jSJOAjMAKIGiV/9yJlH1iSOx4Ie/PzrmpB3gtyEHRZJSJj+RxEIqv/p4A9XxugRazte6KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Sun, 1 Feb
 2026 21:07:15 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%6]) with mapi id 15.20.9564.016; Sun, 1 Feb 2026
 21:07:15 +0000
Date: Sun, 1 Feb 2026 13:07:12 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: John Hubbard <jhubbard@nvidia.com>
CC: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, <intel-xe@lists.freedesktop.org>,
	Ralph Campbell <rcampbell@nvidia.com>, Christoph Hellwig <hch@lst.de>, "Jason
 Gunthorpe" <jgg@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, <linux-mm@kvack.org>, <stable@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-ID: <aX/AgHAZ7Tl4iOua@lstrano-desk.jf.intel.com>
References: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
 <20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
 <57fd7f99-fa21-41eb-b484-56778ded457a@nvidia.com>
 <2d96c9318f2a5fc594dc6b4772b6ce7017a45ad9.camel@linux.intel.com>
 <aX5RQBxYB029/dkt@lstrano-desk.jf.intel.com>
 <0025ee21-2a6c-4c6e-a49a-2df525d3faa1@nvidia.com>
 <aX+oUorOWPt1xbgw@lstrano-desk.jf.intel.com>
 <81b9ffa6-7624-4ab0-89b7-5502bc6c711a@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81b9ffa6-7624-4ab0-89b7-5502bc6c711a@nvidia.com>
X-ClientProxiedBy: MW4PR04CA0122.namprd04.prod.outlook.com
 (2603:10b6:303:84::7) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|PH8PR11MB6780:EE_
X-MS-Office365-Filtering-Correlation-Id: d208182f-d4ad-4c96-f1f0-08de61d5e04d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SlEzVlYveCt3ZXJsUGVHQXlnQmxHMzVPOGcyWXUrYVkxRVh6RzcyeVYrcVhs?=
 =?utf-8?B?SVBKa29uL0krS0JqKzJrZGRzaFlpeU1rc25sekRQQW5sd2M5Z1ZrNk5mYUJw?=
 =?utf-8?B?NEFXdVJtUFZDQXlZOXhYVVNBdkw2OXozZGJzTE04Rk52YkdzWjZYcHVaMVdW?=
 =?utf-8?B?SlNYOEJVeHFlazF3N1o1eGg1ZHV3dHN6ck1QeGtmTHNGaHpBN20xaFF3Q012?=
 =?utf-8?B?SStWNkE3ZXUxSjlsbHdiU3ZSajVueVNRSUcvZFRnRzY0dUx3cXY0Nk81ek9K?=
 =?utf-8?B?UXdoVXAxRGZ5a3plekpHWWZxMW01ajhDSjI0UFJ0Y3JxK29xdCtqRUNpUVpx?=
 =?utf-8?B?QitsODZSSC9LM1pkRkxWU200azREVUFOMkU0UUorWlphaTNKN1hJYWNEOHhx?=
 =?utf-8?B?ZDdPTXU2U0lQcVFnZUFVSWxuK3FUMWFWQ2JzVUlCYUdrczl3YkhIMVV5aXpP?=
 =?utf-8?B?NzMwSXNEU09vSy9TSmxpRjdIT09OcmowZU9sZHVpa2J0SERQOUZSSzZ5MlZp?=
 =?utf-8?B?Q1JKdnlONGlIZWVkcktHRlVSemQ0Nnk4bEVTYitNblloY0E2SjltSzZwWDVG?=
 =?utf-8?B?RGx4UkkwdzRhS0dHeGkzS0NraklzMFdTQ2dzYUxtaGo2ZHhSR2xScDNrRWEx?=
 =?utf-8?B?bUpxb2FuYjU1VExKcHM1THFmZVlwMWo4YmZEZ2tUT1VoN2xCV0ZUUzVISUlm?=
 =?utf-8?B?dzIyMm5EL2ZuMzd6S2RhRjdCSkllR2dIcE03RlV0VnpIWHp3azErNWwrU1BH?=
 =?utf-8?B?SUJnTEp2OHljblRhREZTNEpKK25lN0MrS1F3a3F5UC9RY1FUVnc1blZ6aFRG?=
 =?utf-8?B?Z3ErSWJDcUtHUWYyTFZWdGhjdHFLZHJ2YU9tNC9RWjBvK3E1VTJjSzJ4Z0dr?=
 =?utf-8?B?dVlZTENOMGZKOGFwd1F5d0N0WnE2SGo3NkFIRmFOTG03NHgwcXY2djNUelk2?=
 =?utf-8?B?aEVBb2ljTVZJTHh5bEJxazE5bktqdEN1ZkJXcmpadk14UHFhZytoRUM5Y1JI?=
 =?utf-8?B?blcvWkRtZFZiTm4wT201ZVRnVUJ3M2FhTmEzem5aSHIweXFHT2l0eU5XZ2Zx?=
 =?utf-8?B?a3pDUmJuZjJyZXQwQmRnT0xtMlZWNG13TytEeXdCOC9DMkFjUFNnUmpKV1A5?=
 =?utf-8?B?dE5xU2plcytRTFo5NDFsRUkxMnZlLzR3eVo0cWJBM2l1ZXlkZlJNNHlTcS9B?=
 =?utf-8?B?RndQRXh1VEhSaFJRQXFjekdCNEF4TURpM3dIOFE2ZW1Nc296OGVvMEpQZmVL?=
 =?utf-8?B?OXJic1lGQmZKa2Y5bnNsUkdhSzZzb2JGamJwdmpRMTV5N1JCT01xTnUyRnhm?=
 =?utf-8?B?Z2k2NU9nT2pWbC8yZzBUTTJDNUprWS9sV3VzRitPVmwxMXZJbHUzU1Z6YVI3?=
 =?utf-8?B?aERhdSt0ZCtpNzAvY0o3RDRxeEpwcGdESUpGUVNjZ3llY0NmUk1TTytRYUtZ?=
 =?utf-8?B?NXlkL2hTZVJIOW5TVGc1ZDZ4U2ZMdlNkUFd3R1h5MHhaenZGZjBpNnlwekxs?=
 =?utf-8?B?dG1zWmI4aWR6YTdkVG1DSjRSTlkvc3VNRkdmaWl3N3lkdkdVTmRQS1NoaGtB?=
 =?utf-8?B?b1BsSmEzSEpGT1J1eEV1QTJ5RjloWXNSUEpkNG1IMWgxNFU2S2F0MHhObWVP?=
 =?utf-8?B?Z0NncGY4d3ZUZHIrS1NzRDJSUFV6NFhHZXNjc2dXVUhwUitqc3J6VXNuT2dE?=
 =?utf-8?B?dXl6dmsxZ0N1TUpJSS80RTIraHRHa0RmYXRsaVBnZDJhdlYzcWlrVW1UNjdW?=
 =?utf-8?B?b3NLcTIrTm1GQVVoMGkvV00rY29ibUNKNllDSEZaL2ttZkRLUVBXaUprUDBl?=
 =?utf-8?B?SWhkaXk5MHlrZFZaaXNZQnVITHlpdEpuVE0yeks4SWZzaDhLeGltVTh5bG9Y?=
 =?utf-8?B?Vk5mdXJKT2VneTNhTWNybVhpNllCTVlWajVSdVNTcW1tUVRwZjI3U2tZMzdt?=
 =?utf-8?B?RkxVRUZiVk5IeTQzcTY0TUtEMEE0ak5EQkpUQktpWmhyWmUzSmpGTFNSYzFr?=
 =?utf-8?B?Mzd0ZFVnSGdnc2ovK1BDOFA0S2g0a2RRcjJXYW9NOGhrWEJxZkJ6M2pDbWVC?=
 =?utf-8?B?NHV1cE43TlkwLzVVSWZMRnEzdmhhaThreVFWVzVRNkxHMzNGZDlrUEZUbmNt?=
 =?utf-8?Q?IpM4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUJDV0llbzBjMnd5Zm1aQkJ5WEZuM2JPUTZmK2s2dHV5K3N6eVUyNXVLY2lO?=
 =?utf-8?B?YUttWnQ0NzVuSUw4a2NXRmp0UXZtWGNmSVBWeERZZThNTmlyWmx5TVp0Z0Fm?=
 =?utf-8?B?d0NDMjJqVVFhblkrQXFLUDFNL1NxNDl4WDNPeWY1eDNVQytIWmo1TGZPUFV5?=
 =?utf-8?B?WVlENmVtNlVuUW9NdlJIWnZ4cTVUQWd3NTVBZlNVbG56RWZJd3NkRVhaRFdN?=
 =?utf-8?B?SWdDV0NLemtnN1RvQlBaays4LzdESG9PZTRybkJJSlBrVCtSNWw3bENRbjU2?=
 =?utf-8?B?VVNNQ3Iyc1lCV1ArQWZFQTZ2WGlFaEpSNmIxSTQ1bUhxYmhMSEpvWjV5eWNj?=
 =?utf-8?B?K3dTSU5qZDFjcy9SRVNScHN0MXM4S3ZoUFdpYzRzYWNEaE0wb01tQ3BPQ3BD?=
 =?utf-8?B?RkFUT3lOZzJIdUxWQmw0Q2pBSTZlQWpVRForeXRGc014SU1kb2xEYTN6Ynhs?=
 =?utf-8?B?cEk4dFd3bnpVeldjM3ZjS3p6cTMycFV5c01KcEVzaE93V05GNzlvYWhCZWt3?=
 =?utf-8?B?cjY0Z1BKNWJTcEFpWThMUHlUWWhVRXVlZSsrL282NFpUZFhxc1BJN2ZhRDBj?=
 =?utf-8?B?dHI4RGV3cmpDSW5QSmhZY0dHUEIrZUg4WlgvWG51ZnJhZzhXWHFrd1F0WFhU?=
 =?utf-8?B?VlVqWUVOSTVXczRhVVM4dVdOdnlnSjBwSlptNHZmL0R2ODVXbW5GODVrY0RS?=
 =?utf-8?B?WFNUWGZRalhPdlJjV2pLVUMxQlY3dWZMUVhXRXZ2RlJieXkwbi9iR3IrTFRX?=
 =?utf-8?B?V2VMKzFTL0ZBejF4bXZYTXJSNVBiMzUyVnZRQmlKUS9mc3RETi9HZjlheHda?=
 =?utf-8?B?TXNhcDBaeUY4c3VTNWJKNUtpTVcxT0pBWlp1b1dTNHJzN01jSkozbTRGa1Bk?=
 =?utf-8?B?RGNnYTlKSDNUaU5nQ0JZTTBBaWVMMm9pUFEwNVhubFQrZW1KanZieGJLREx2?=
 =?utf-8?B?MUVRZUtCT01HN0kwdVB0UVdhVG42NVpQT0ZMV2lKdlB0VXF0L2FmT3ZoSjFD?=
 =?utf-8?B?VStMQmhWWEpYRDltL3lxOXJXZzNWUTUwRUN1a0FxaExkU2drcmltWGRPTklV?=
 =?utf-8?B?WktSSTFOTkJETGl6cDh6QzhJWmtiK25xZkkzcmdsRFR3SGtwY281Q3hqdFFh?=
 =?utf-8?B?bjVOYW9kTFAzN0VueU9zSlFrQjJxK1Boc0c2ZzFtQ01uZzBCb1BvZHBUcmt1?=
 =?utf-8?B?amxndlN0ZGw5a0NhUVRmTzIrd09lamxaTEo4Tnp3L1g4VlFOQVAwMm1TamEy?=
 =?utf-8?B?Q2Z5NWd5NnRQby9mNHB5RU1FY1pSZTFLSUlKVGg3NTR6TDc5UTRwTndtazZz?=
 =?utf-8?B?SDdCc0V1ckxjNmpMczgrV1ZWNnhRRmcrQXN0ZkZnTzJETndGMlZEYUZld1BV?=
 =?utf-8?B?bndEWlk2dmkvenkrbjNCL3NBTHBhK090UFpJUWd3ajU4TURqOGNXZHJuWkZ3?=
 =?utf-8?B?cCtqN09qL0gwZHlpR25yQ21WVmVycHZTMVZNcThqaHE0K2FkR2Qrb2p1cU83?=
 =?utf-8?B?dWtrOGptNWVreTNNdDZlMmhGNWJiSWFKZENDeHRVWmFuWlpVbjhObHRvYkhR?=
 =?utf-8?B?cEJTRGtMbi8rZS9zV1J0SktzL3FHT25zY2RjaTFBK1hIOUJNNjNOZ014WDBI?=
 =?utf-8?B?VGVnYVBIQTJyT0VjRmRVTDU5dGtudjlRY2k2c0hBcXc4bHdReVJvcUJ5aTNz?=
 =?utf-8?B?MVpKcEFoRnhDK29yUDlMRnJuc1lJaVhOL3h5Nys2Wk40NUtwd1hxMEZacE9U?=
 =?utf-8?B?cmdLUlZOL0JsM1FnZ01zZUY3aERhcG12VExHMWlYOWRmNlNlRk9sT1dnUzAy?=
 =?utf-8?B?M0FCbGF6RGROV09LTEdkU3FQcXdXM2d3YWFKY2k1TXhNV09GNGpnaHpwZk5u?=
 =?utf-8?B?T29KdDVQUTJ0K2hCRDFROWRWenlFYjc3RkxnYXZIT2N5LzlwYW5yTld2N05u?=
 =?utf-8?B?c3huU01XZ0xiMkZtMEVaQ2dvZ0RuSU91ZDV5bUhXTUdQdWZ2bFBzd0ZNRGNT?=
 =?utf-8?B?UnAwZUFEWWpMWjhzaGwyRGhnY2pHbHV6T3B2VVkxVy80dm1QS0QyZURaMmZR?=
 =?utf-8?B?Qm5wN2s2ai8rTTJuOFBxVHc3bjl3VDhjNXd6QTZqblUwM1YxaTBCWS9mb2k3?=
 =?utf-8?B?SVFjVVNhcTFaeUNuQUE4aENnQ211VjNCcTdjYU80RllzQWRZaERzTVlONndM?=
 =?utf-8?B?NXpGa2lIOWdQbmdmWUtPNVNHeEc0eVN4SE11LzQrQ1ZjNnp5K2E2ME9FY0xF?=
 =?utf-8?B?L0hyVERrRXFRNldKS3pDQlA1Vks4OUh6aTBBZGFFNjYyWGZweHljNWlKUXUy?=
 =?utf-8?B?eWJIaFFCWC83U0loU25tRXIzd0M0VHNrRzEvUEt2bkpETzc2eXF3UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d208182f-d4ad-4c96-f1f0-08de61d5e04d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2026 21:07:15.3225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DTvTaLqhs2TBPuUvntnuuDGUv+vCgu8GUM0puAIOOZ3zoV5PmX0aEoo/vYt5mG4tdzVJ4SfERBQSI3idFzPlUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6780
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: CB29118000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: u8had478r4iq1y5g3gce7qkbfhm7ggwf
X-HE-Tag: 1769980040-34021
X-HE-Meta: U2FsdGVkX1+TEGllRD3tqVq8/cSZchsCBcqe18a4Mt2FkpgjNcSi21TFLqxxJa0sFJ9Vi4eJJEqkqOFjA9iNsZyRYVgi0F30YdkDnfJn5VBX3E873ITiGzvKZNFJKmbajj21QAlutbMa0N+yKkAOHbOgpsVueZM0Ai4qZ2SsvExnmhPc0e6vUuy9egJEI3gFzH2X1ikkz9ZOPT26G/wyIG7lCkoYGnN+VfJtVEI73fZffwFzJpItaAH3vSGAmRftTgenU4oZhNgt1cllyHeBvAEBb1lobN7IaUimYM6sbGutk0lRHBOcsOPRESE6xfgtYWaPiyOP4TRNaIo/sH81i1ZD6BhN1Mq7QYeGYbnLtpQ8nkNFJRCZXOqV5yGGlgbWU2eWX0lBRkSpaUaJkHm71pKz2TQJwBBKzyXPOj7gVqP8pTPiOYy5qUwj6g4bLP70rYQOhXO0gDlqG5amw05oDUvCA7DRNA2VnprpgqCS3H3JEzhzMSYDplWCzIYZsDJBBiuzXkqZzmXntRuS3YqS42pTcY4DMH8P+6UJtvnZicFD++RdSJqXr4QQLLH/yAFy/uaxMVXdiIlOUhq6Mhf3ZNV4sOSuSCmaquhz9pYxACdP7JLJIF9MEFLj5gce+MXS2hh5fGTDYQoisDPPiN9yNLz20I4KTfRL+0pl1ffrNdDPKQNnkWQexGuwliM60jrOeUoMWtBwyRD5RiFwpsPRIsyy2yUQT+B+wXjy0hXoXeFBqe4t1Jj3I7ZDtCbQeyE5Ha4vz3jAKbIWjlaPlGy/AwS3SITuheOg5uZmPlWoKDdYFmXleo6vQRf8B6f3mAycuyBlfL0Zqt2vZMPUEFNnexJ2V3TQCwXvIh+3uuhe0K9GSUWljMvxD4xYt50GXE9WjOGyELKL6SxiKZkk4OQRmyYOf7AeQsfPlT95N7NkofqLUrY5KqegPD6IcikbXY0+sUUDEFj51c7+poAebPy
 TXJA3e+y
 A19peNi28d2yfKiGja3X+SHeqEaNWTy9NlT4u8JHfiysEMqq4x6T0uByhmEQgcsEuSsq2xWbG4+Onatrp48auLXonMyopQLEzHRiPH65KsBLylCd5tcOwhYkn1dYN4ktDVSEkiBNmTNBLCvOfBv9XvEIVC1EX3tko31kPnbPDpfyQDWkHrfo9PLRelUMXwAg2ntUqEIh1eCVj8sxybgET2aSG0Zv3JDrlI/Neon5tya+XYi98xmtXJhI2l2NW2+Mv5L4Wn1An4tciZ+nvbL6DgdkBAUFNWuygCH2rpj03qlHX3P64iC0blnYbOfGNLbTlgwgYEvxkZ8stt8ctZxzgfKtiEfjLPt68NmZ+XdCSkNnqRWw+eE59K3vofMyE8M83eBpstDIUX0XkNu3NkK/vca5XgAQLdX52B23LXFOrTiTCgVJG6hrhLkh6R3D59jjjsJVJGLKPRJmPRt/e8uKXhomve2Stu2FlecBPIyoWrjYV1kRyRguM1W0ZEkYJPfO2tLm4ymjf3OPvm09idmfpJ3fVJCDak2N4xbxVk7howx0CY+Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 01, 2026 at 12:48:33PM -0800, John Hubbard wrote:
> On 2/1/26 11:24 AM, Matthew Brost wrote:
> > On Sat, Jan 31, 2026 at 01:42:20PM -0800, John Hubbard wrote:
> > > On 1/31/26 11:00 AM, Matthew Brost wrote:
> > > > On Sat, Jan 31, 2026 at 01:57:21PM +0100, Thomas Hellström wrote:
> > > > > On Fri, 2026-01-30 at 19:01 -0800, John Hubbard wrote:
> > > > > > On 1/30/26 10:00 AM, Andrew Morton wrote:
> > > > > > > On Fri, 30 Jan 2026 15:45:29 +0100 Thomas Hellström wrote:
> > > > > > ...
> > > > I’m not convinced the folio refcount has any bearing if we can take a
> > > > sleeping lock in do_swap_page, but perhaps I’m missing something.
> > > 
> > > So far, I am not able to find a problem with your proposal. So,
> > > something like this I believe could actually work:
> > 
> > I did something slightly more defensive with a refcount protection, but
> > this seems to work + fix the raised by Thomas and shows no noticeable
> > performance difference. If we go this route, do_huge_pmd_device_private
> > would need to be updated with the same pattern as well - I don't have
> > large device pages enabled in current test branch but would have to test
> > that part out too.
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index da360a6eb8a4..1e7ccc4a1a6c 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4652,6 +4652,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >                          vmf->page = softleaf_to_page(entry);
> >                          ret = remove_device_exclusive_entry(vmf);
> >                  } else if (softleaf_is_device_private(entry)) {
> > +                       struct dev_pagemap *pgmap;
> > +
> >                          if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
> >                                  /*
> >                                   * migrate_to_ram is not yet ready to operate
> > @@ -4670,21 +4672,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >                                                          vmf->orig_pte)))
> >                                  goto unlock;
> > 
> > -                       /*
> > -                        * Get a page reference while we know the page can't be
> > -                        * freed.
> > -                        */
> > -                       if (trylock_page(vmf->page)) {
> > -                               struct dev_pagemap *pgmap;
> > -
> > -                               get_page(vmf->page);
> > -                               pte_unmap_unlock(vmf->pte, vmf->ptl);
> > +                       pte_unmap_unlock(vmf->pte, vmf->ptl);
> > +                       lock_page(vmf->page);
> > +                       if (get_page_unless_zero(vmf->page)) {
> 
> I think this ordering has a problem, because it releases the PTL before
> getting a refcount. That allows another thread to free the page, and

Yes, I reasoned that this could be a problem too after thinking about it
a bit more. The issue with taking a refcount without the lock is that
we’re back to the livelock problem that was solved here:

git format-patch -1 1afaeb8293c9a

> then the lock_page() call here will be doing a use-after-free.
> 

I don’t think it’s a use-after-free per se; rather, the page could have
moved and been reallocated. If the same_pte check were moved under the
page lock, I think it would largely solve that, but if the page were
reallocated as a larger folio, the page lock might collide with the
folio-order bit encoding and hang forever. This is likely extremely hard
to hit, as you’d need multiple threads faulting the same page plus the
driver reallocating the page as a folio at the same time, but
nonetheless it could be a problem.

So maybe back to drawing board...

Matt

> That's why I reversed the order of those, and then as a result the
> get_page_unless_zero() also becomes unnecessary.
> 
> >                                  pgmap = page_pgmap(vmf->page);
> >                                  ret = pgmap->ops->migrate_to_ram(vmf);
> >                                  unlock_page(vmf->page);
> >                                  put_page(vmf->page);
> >                          } else {
> > -                               pte_unmap_unlock(vmf->pte, vmf->ptl);
> > +                               unlock_page(vmf->page);
> >                          }
> >                  } else if (softleaf_is_hwpoison(entry)) {
> >                          ret = VM_FAULT_HWPOISON;
> > 
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index da360a6eb8a4..af73430e7888 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -4652,6 +4652,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >   			vmf->page = softleaf_to_page(entry);
> > >   			ret = remove_device_exclusive_entry(vmf);
> > >   		} else if (softleaf_is_device_private(entry)) {
> > > +			struct dev_pagemap *pgmap;
> > > +
> > >   			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
> > >   				/*
> > >   				 * migrate_to_ram is not yet ready to operate
> > > @@ -4674,18 +4676,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >   			 * Get a page reference while we know the page can't be
> > >   			 * freed.
> > >   			 */
> > > -			if (trylock_page(vmf->page)) {
> > > -				struct dev_pagemap *pgmap;
> > > -
> > > -				get_page(vmf->page);
> > > -				pte_unmap_unlock(vmf->pte, vmf->ptl);
> > > -				pgmap = page_pgmap(vmf->page);
> > > -				ret = pgmap->ops->migrate_to_ram(vmf);
> > > -				unlock_page(vmf->page);
> > > -				put_page(vmf->page);
> > > -			} else {
> > > -				pte_unmap_unlock(vmf->pte, vmf->ptl);
> > > -			}
> > > +			get_page(vmf->page);
> > > +			pte_unmap_unlock(vmf->pte, vmf->ptl);
> > > +			lock_page(vmf->page);
> > > +			pgmap = page_pgmap(vmf->page);
> > > +			ret = pgmap->ops->migrate_to_ram(vmf);
> > > +			unlock_page(vmf->page);
> > > +			put_page(vmf->page);
> > >   		} else if (softleaf_is_hwpoison(entry)) {
> > >   			ret = VM_FAULT_HWPOISON;
> > >   		} else if (softleaf_is_marker(entry)) {
> > > 
> > > > 
> > > > > But it looks like an AR for us to try to check how bad
> > > > > lru_cache_disable() really is. And perhaps compare with an
> > > > > unconditional lru_add_drain_all() at migration start.
> > > > > 
> > > > > Does anybody know who would be able to tell whether a page refcount
> > > > > still should block migration (like today) or whether that could
> > > > > actually be relaxed to a page pincount?
> > > 
> > > Yes, it really should block migration, see my response above: both
> > > pincount and refcount literally mean "do not move this page".
> > > 
> > > As an aside because it might help at some point, I'm just now testing a
> > > tiny patchset that uses:
> > > 
> > >      wait_var_event_killable(&folio->_refcount,
> > >                              folio_ref_count(folio) <= expected)
> > > 
> > > during migration, paired with:
> > > 
> > >       wake_up_var(&folio->_refcount) in put_page().
> > > 
> > > This waits for the expected refcount, instead of doing a blind, tight
> > > retry loop during migration attempts. This lets migration succeed even
> > > when waiting a long time for another caller to release a refcount.
> > > 
> > > It works well, but of course, it also has a potentially serious
> > > performance cost (which I need to quantify), because it adds cycles to
> > > the put_page() hot path. Which is why I haven't posted it yet, even as
> > > an RFC. It's still in the "is this even reasonable" stage, just food
> > > for thought here.
> > > 
> > 
> > If you post an RFC we (Intel) can give it try as we have tests that
> > really stress migration in odd ways and have fairly good metrics to
> > catch perf issues too.
> > 
> 
> That would be wonderful, thanks! Testing is hard.
> 
> thanks,
> -- 
> John Hubbard
> 

