Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E219D72341
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 07:21:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFD46B0421; Fri, 23 Jan 2026 02:21:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29DCC6B0422; Fri, 23 Jan 2026 02:21:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147D56B0423; Fri, 23 Jan 2026 02:21:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 033446B0421
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:21:44 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B22858B6F0
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:21:43 +0000 (UTC)
X-FDA: 84362383686.05.3EEFE30
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1FB2520007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:21:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TS3OAkkV;
	spf=pass (imf03.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769152900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8w4VRMslBCislIISK6BpZk4oAYrhWPJeDx0dcvrLhjk=;
	b=DY8bQDPNBGe+CWhZx87VgjY/EW8m/jQIvfEdW/kGI2aTdepY26Aei6cXHFtY45erY5I50f
	p39iUNRLN9/qqN+rRi7CUOWqlvGIg8OHnyRJLBn+cLOVCooCo8h3K7d7n1otcWSfLWypyy
	LeSXz/gRnX+xkL6Nr1y5o1SY7FKDQs4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TS3OAkkV;
	spf=pass (imf03.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769152900; a=rsa-sha256;
	cv=fail;
	b=mwTMB39AHJ6rMd40K1E4BePW9LqQi0iFOKKUjdyH8MjtyTCmpWS5FsOe0nPMqE6lwPp8XZ
	AYKIe7PDeNJXymhjOjfe+fRk3L+T+PjTlY0yT6FfFdsYV5E/I5WumkD3bAF9BODeHV0YuE
	jG6Kmksib56eF6bCgWs8NB2T00Wg21w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769152901; x=1800688901;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=nQHgT6qQ7M17QBMcwk9eLmzqmzrizGCi2jqK12XHzl0=;
  b=TS3OAkkV0ODEbyUrzOWPkstHiQp2iGK3Ci5zlYjKUvhwqd3F/7GRV4gH
   tbPKYca8VSMBE9x/mitwLYDXFSp9UItPaHUXPvkiYLCXi9Of2QJiHIPA7
   qQXrTQYswULcyj3EsiQvvhD9upnz7ODPfcehccKzsCoGr7RaLRgKCIw61
   3isbN9IRD5R6Bv/tgQxfsgcMvTJ8r6ZvS1M5DewvCS28jyqi6g9C7Vm7Q
   ZalwIcSZi9qaES/mrmTpuZfZYALU0VUG7J8grOWQM4urlcM00LArmGfq4
   /8EJZYm60J+0So0gcPoChkTJl5e7l88KT7cE2Flh5c/Gez3f23Wj1bnQT
   Q==;
X-CSE-ConnectionGUID: tvkxRG2cQWysI6nCS9DpsQ==
X-CSE-MsgGUID: LcxfJHxoSwKfLK7tWgectQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="70314029"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70314029"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 23:21:38 -0800
X-CSE-ConnectionGUID: brqrVMI6SvqRJ7u7OAOeMg==
X-CSE-MsgGUID: sTT9i/7jSpqsKl+7xQmAEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="207218795"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 23:21:36 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 23:21:35 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 22 Jan 2026 23:21:35 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.66) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 23:21:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vdHFGZtFaacpJlhWgnQ9yyQdWEHpnH8zESR4BcjC1KjyuCVlyB7/2am/FlPNxxo9JNWU74EGTj1kKZ0yhmiaBYikGcyjg2L/lGUvehGEmJXVPO+ofUbVRMpeoARQdHkf1ayWH8mp81suY7H8GCUXIrzXA4trzJwKxwYghNa0MgAulYPQNFcdSHxMy0KZQjtZof4zEgVmWYVToaFxWETxjdLfClKGb5j4DYuV6GSdZHcyJbu2k3sTxCEKFubsrFRbQg1AH/VSM8H91CxUciTAT0GuybYYn//kjcU+dI+fJeOkV3VajJdjN/Ns0DUU8IIl3t7fP/qhSCnTinZIzG/9Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8w4VRMslBCislIISK6BpZk4oAYrhWPJeDx0dcvrLhjk=;
 b=bW/U+JNQ03D/VxG6m0fwskxTPmJDwYC2KOSLjb0KJ2krlCWF2YUFlBuDQlfAEzy2UveKqavGaU70cPgeFmTKyM4e7m6/3iUoZcdwnbKcAGo73XEFZ5wllralJAMXfIHUfqD6q91mdTUH0fQdG+gGRAzsXW3Sh13MZ6TfWDfpn+nwaqenxiF1l5tYQvBk/OkGFSReev6sBC/OdMNB474MD79CMYxgwHdgGJaN/rlLtR8ug19f6IFN6EAFkZG+tivJnFttAlWjL4Y9qMr9i98PdtPS751jzr5sZmNV5mVfIs5G06FZVLZOYeahlHAOZ6rKunvPZ3jV4ZFNyKxHaqoCIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SJ5PPFEC87B8781.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::85c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 23 Jan
 2026 07:21:28 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 07:21:28 +0000
Date: Fri, 23 Jan 2026 15:21:19 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Harry Yoo <harry.yoo@oracle.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm/slab]  4fad56bdb6:
 BUG_kmalloc-#:Padding_overwritten.#-#@offset=
Message-ID: <202601231457.f7b31e09-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR01CA0032.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::18) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SJ5PPFEC87B8781:EE_
X-MS-Office365-Filtering-Correlation-Id: 45c50c25-dd49-4af4-98d6-08de5a500631
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|220923002;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YdWWwTnyaMvR3Hpb3bwcnOxgPjL9mSVoqTtBKx4j8BigTvygGCMlpnOsxkbz?=
 =?us-ascii?Q?O5riCTV2ckFfK9OIxAt8e/VrEmA3c59ZW8mXvv0KInisRNBVns65LI1BBUG5?=
 =?us-ascii?Q?JAtWtQY84pAggzTnjEy7B0wbsGTA8ZmxX9gvo+JXjGr8d5NTudd2yFK+kPy2?=
 =?us-ascii?Q?GG9zIruSis5qdpvYVyQ/vFqJd11bH44fV/jenMx8w6ydcBPt7gOAkOy1uAFM?=
 =?us-ascii?Q?P2wgAdHtfC5Z5TWJxEjGg0g7PTEuGSKye7fbZEuMG9hqQe47BuRAvp8a25LR?=
 =?us-ascii?Q?GMHWpP2j/aXK1htnYr7Uq8NF/4drHOxEarWCLr9ummkxgUMklvtVzS/eY0gm?=
 =?us-ascii?Q?70y5GgV6/EmPi0HOY9jzaCjvl7TmzNvcbOCR6msMDKHFAG8HnmgbmB03lLlV?=
 =?us-ascii?Q?Uk9P6+P4QYB5xs8i8xbxonEzEKWh6GRU8AJ2T6QB6UyDKbxI+72tjHgv5VR6?=
 =?us-ascii?Q?OV5pS10WoC4IN3Vdn2Epe0ZBofBZDiiC7vWz9kzWqKVlVHCPFNLRfypL3Zwi?=
 =?us-ascii?Q?HnN+lhbsTeSwyQa86d78FIN2Y0UMRGPXB0lmmizllwlL2YaPiZ7+MYhG1Hfd?=
 =?us-ascii?Q?WP+/31tGm7om03r3s4fqfrZkHEsJ8jgCCgExQmvQhG0zlPf0vVeGxIw4enYg?=
 =?us-ascii?Q?KUphLCgva9p3dfxWt/hwtk8H2jbb0SPE9Jp1ratRnaiaQjzGRhI/oDSYlTBa?=
 =?us-ascii?Q?gYbD3468RU+PeeHynjXzWgSDMAJQwZhbZVduUFTaYA9J7q73JmyfkKhicekD?=
 =?us-ascii?Q?/5FTF5hs/wTt/86qylcc53PcOeEYETHgtUtoQ5Elq2qWMVArXoNy/Mt9+ral?=
 =?us-ascii?Q?kdqXfXP7yDi2YkckP63uEEI2KOOGzhKjsAJV648a+6Pbe+bOcHbyj6sOQpSs?=
 =?us-ascii?Q?ZFTR+j1FOy8XqSapm8E/RR0ox4eS2vbzmZ/cNqAi47sJU07Q+ZG59yQ0bhji?=
 =?us-ascii?Q?JyS9/IqsvIpylBRC63zcRQzyLQFFCRe5mzsfr9Un55Y0Wm1sKp9/l3gGXfcu?=
 =?us-ascii?Q?9pgmv0vLQ9rwU+ItQjf6k30gam+ewpB6N/5oicrCAjSEAxt/sWbyPPglqy6G?=
 =?us-ascii?Q?l73xpyVWqjplB1bgRHe5llpFAmRd2cFf6G7ruSxsclr7KeR2DIvffqA1s3cn?=
 =?us-ascii?Q?cBZZI10ciPYEfeZ7vaDpIrGfSFx3OgnTpVzBize79rN5lNQc+EYkx69rPhzJ?=
 =?us-ascii?Q?Od8AyAAzJ6Nthn6i/ZhCFxYIwmJavqFvVPVsgTzYJC6mpQB/S67GgSdUJoDL?=
 =?us-ascii?Q?ZhWiNzCplx5Q2l2qYgEShHTlY67fZQA/CKNoDG4yhD7yBzVD/7aIcGbC1Js8?=
 =?us-ascii?Q?BAJvxSs52mj4niZollN0ltfeKrGIMHoNIu7lmird5UkVeEoh/644O+1f81cH?=
 =?us-ascii?Q?2eCci1w8xZMI0j0eluJLR48mkBCSnqcDJNJb7b6tQhAXPokqYB/oTu2kW6wf?=
 =?us-ascii?Q?xX3b/u7zSEOfcgOjIVEo+3J15URpYKsCZ0AbR9IMXRjKaIQX2rIc0Xt4kT5W?=
 =?us-ascii?Q?hkQlM62fvhoBYfOo+ru85SE+xAYAorQr/S8KlXLNo0dOEd8iXsb+ldPcLueh?=
 =?us-ascii?Q?R7jNTeZfB6aqvos1TQl+dk/CjlDgmeYXFQQgHP0gKG+BHyLJH70c8GDPgOuN?=
 =?us-ascii?Q?YCxYcN0A+EaxeY35uebicL8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(220923002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xTtHc/l+THl87gw/YIXslusHj3yWoRWijoU1wMe/Nv+EFL+L2TzGnsSJ5YOf?=
 =?us-ascii?Q?XxWWsOa9U8ZEvPzttO7yhyJLBLPFT8nZxiV7IUc5m0EaNVYD7ozyVeJ9c/Gb?=
 =?us-ascii?Q?/IJmq4bYDWVKjmJxYT1e3So8S/9zVqG0aQP11MekwAZLH7SwLdq/mNlgs8lH?=
 =?us-ascii?Q?blsMclFm/4miMjfZNI3qGw7QkVuGQFMoLyKNiqqAHjMHJS0yQU+x6w/uDqiD?=
 =?us-ascii?Q?CLXmVjOkzkrV65sC3A1c3ag0DzeIxo09cWmKb/V1iNDl1mdul9ljdLRUjEK5?=
 =?us-ascii?Q?FCp0vnfv4YG2H9STxzAvea2l0m6iOkVorFhTlPY9KFkS7zuoQ0BSKHAtJAeI?=
 =?us-ascii?Q?DL8Y1qtQFGrEEndWIFtSt8mHWU4tOznFPZEvfY+27Z+3poTPb98vW8CgAdNB?=
 =?us-ascii?Q?7glSXJBeLynxmggRPEJVlNC5bx32u0yxrewqMejqpwvYIOPI3cupZhqkTYM8?=
 =?us-ascii?Q?TJWf3EuNqWrUPR8xtM8J/GhROfg8Vc+pNAhayW64DFzgyqbTC7hzSJZB44Ya?=
 =?us-ascii?Q?fHnMR2kVqu7mHXljzf6njvJ7QVmwQFc8BeznSWGbBJDnWqfWaiB/BvL7eB4N?=
 =?us-ascii?Q?6dGuZD13yMWcqrf91smsBjUCtfNputqhALya1rVkcxt99OCYLMuC5sUhxeBm?=
 =?us-ascii?Q?Q9bnWY3kE+lBFo6tYx0r4oDW9d4IpAQGb7THCNCVoiTv/2OX6Rdgy18kzW7s?=
 =?us-ascii?Q?NMrk5Lv9zMrOM1eNXttX3qTKNQ7/YqTdmEMN+TY6ZKO4Nz3umAHSenjru+r7?=
 =?us-ascii?Q?Fi/MKRMlgAizBkXLr3KBiuCETgSTCBdnnFRX33TtngFpsEcjAEKOzQ9M3jIX?=
 =?us-ascii?Q?dHhyPE+jHT+qc/rHtYcgOfNMA1DmCea5v2QrF1MY3ypkWF71vVBqRbAf7TCX?=
 =?us-ascii?Q?DYNH6GEAC1smd2Hs2AWmKq2f2YeQZYRM+NNyQBJ9NsnQmUkFFC6k6hCn5elK?=
 =?us-ascii?Q?Zkr8cRNugH57BIcHBboznMXHMd8jIayg/uUipiSxmDqlu5smrtXGzy8Rn0SE?=
 =?us-ascii?Q?xEeuwTAN1rzaWID/s6xIb4C8lINUPIUz9NQqA6b3itTNvpjeP7TVLgTvFXZF?=
 =?us-ascii?Q?OgJBoGtcJoaU4koq8SsfC8JpSbNRYOCvPnbn1t0iTsUo/HsKBqsM08BOOpeb?=
 =?us-ascii?Q?JMM0b0wMezm/TauC3DCT6g/P4ZdhdA0nMq+zR52ouqzC0OmXyo72Wtn3cSFu?=
 =?us-ascii?Q?PRShK70DQm1CypXw0V2NT7INgjHtAeuFICXN4iuCEkKbxH3O7kGRTP/+aIRh?=
 =?us-ascii?Q?LEgQ5BUpVc0l2C2wzpzi0u7yBa9/K2Zl2YT6l+wXn8ip6zkYr/Ro4BhHQ2+P?=
 =?us-ascii?Q?EmG4ICI4Qu9++XMsAJt3upPwZitn0ZmUjxmDXECGLuu+sYtMaMgVdJ014Mdq?=
 =?us-ascii?Q?FrrX/PXVitcTcS8OZxNdmionn6034XgrHaxHPv9OpAdwQ4uk409/tZytNSZR?=
 =?us-ascii?Q?s+n5CRsFxcfBoPn3B/Ez9A53BagcmhOKn9pQsrYdrnnQQwbKZgSdClUx0Q28?=
 =?us-ascii?Q?JUU6vOyYq3DRQMZ6bNTZghB5drZnu0F0JCfHh26/lanEG66yfM70XoGFjfIB?=
 =?us-ascii?Q?1Y8HBiLRez+A8fp2eJjYrvyBxmuTwOmdjbdUuFMttcjB6k7MfUhgoFHRu0/5?=
 =?us-ascii?Q?21ptJQ0o4M4zEffkBP7VqppyCtstorW7mLic7iA06qOvsIJC0WnUm5Y8j1+e?=
 =?us-ascii?Q?kAWhvE2b55RfrylzG4Vkba8nPiKnMzlt66BWG+MTKhKdAeBPKHN8MofqlgvB?=
 =?us-ascii?Q?9x+l0rJikw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45c50c25-dd49-4af4-98d6-08de5a500631
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 07:21:28.2344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ufJUam57AIkx2ze5B9BNAxBvvan4CpvEqAiWQBTgZbn2C/UGedM+teXMJ9zC2rFfPv8iE1ILkpkGv0IK4nCv9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFEC87B8781
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Stat-Signature: 7ngwwma4p1ngmbq6kwa1yhkhn4w6dg1n
X-Rspamd-Queue-Id: 1FB2520007
X-Rspam-User: 
X-HE-Tag: 1769152899-652069
X-HE-Meta: U2FsdGVkX1+yvBSFJ7K1BMYW4CEb9wm48DpWk+0nmGBtCHhPwcNR9SHUfRWusWVp/MwEh1u3AD+2oNph3+qsxuJ83xRTFVfWvIUpu88CAiZFXICD7MlbpWmGPJ7CJ1BNxwMrtuoAndRqhHM7l4NlK6QzhPaEVNSYYm+6NsQojdCLPTU3tnn3InL8zLFwOWZL/x5dHD2cOuXqTbp09401jgFIevmHEMMFQKSCkkWCEcExQjJKrpmi6ZH1mleWY2okvTv3hexWZCk6bZpn//nBMT195BS6uvh/KZjMmLbHCVeG5gBDnd+r/iEc7dSjd6XsQtsLJrCxpQ2OaOzGe8Q2i3mKuW9NaW55pyfD4pxZoQGxp3GIzxFGTzIC+D4/YiFYMBNEqdW4L5Ykv79lVoEMLQ7pO55TXC8mCMOC7qDowBRtcWsKi9ksbpTCYUz+ap/v/TnUu0xMTky7ywxfRRm4DrJMLIF24KNqwfgGs4bCGx0BiwZd4QHzJbsxw8p/vDY8fJWoSJ59xDNVlDYx4ADrhpuvmTpcoOQT4DoHO2/IC0W7eiinpAAIXiXnroIMQVIyklXwlwrCCMeJ2WUOw4CGsPfrWwOjKL45DLxOSh6mSRbGUaxPytnr0wgnaw+eq1ulFDIbGzP48KzCFV8XE9sl1uIgVoLzQwGEmERsAZspzPRyRCv74AgGADOPVV080nlLd20XpNUXF7oVKBKkKrMaWPhhjuURoi0uMnaUQ5K/ZsvMMH9pp8yULcPyyjO9W6MeJ1ws85Rz4OxALJ4PidVHe31UyUjx7bg6tZ+/Y0kcCa7EEziaCSkNOSKlpMXXJF00/0rlYFwnC2MY2xYmz7Hz1u6EsraUA4ys0F4CWY0KVXP5FvR7jmrjpJ+oG7n7o7LlcCt3NAPTobwP8XQUn6fQ2oP45vR4dXqlba1O/qPIs4ACqBrjn06qm2ESNguHmJISU6UPVZTYoiqjq7nLb2E
 Qs2/YUvE
 Z13lF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG_kmalloc-#:Padding_overwritten.#-#@offset=" on:

commit: 4fad56bdb6b4c4bc0ea2d919df1ae4eef7b69919 ("mm/slab: save memory by allocating slabobj_ext array from leftover")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master e3b32dcb9f23e3c3927ef3eec6a5842a988fb574]

in testcase: boot

config: x86_64-randconfig-012-20260121
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com



[    3.646661][    T0] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    3.647660][    T0] **********************************************************
[    3.648834][    T0] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    3.651537][    T0] Kernel/User page tables isolation: enabled
[    3.653242][    T0] =============================================================================
[    3.655191][    T0] BUG kmalloc-192 (Tainted: G                T  ): Padding overwritten. 0xffff88810006c028-0xffff88810006bfff @offset=8232
[    3.657925][    T0] -----------------------------------------------------------------------------
[    3.657925][    T0]
[    3.660319][    T0] Padding ffff88810006c028: 00 00 00 00 00 00 00 00 30 c0 06 00 81 88 ff ff  ........0.......
[    3.662476][    T0] Padding ffff88810006c038: 30 c0 06 00 81 88 ff ff 00 00 00 00 00 00 00 00  0...............
[    3.664649][    T0] Padding ffff88810006c048: 48 c0 06 00 81 88 ff ff 48 c0 06 00 81 88 ff ff  H.......H.......


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260123/202601231457.f7b31e09-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


