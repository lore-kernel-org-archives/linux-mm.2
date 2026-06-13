Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32FDFCD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 01:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505966B0005; Fri, 12 Jun 2026 21:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B67A6B008A; Fri, 12 Jun 2026 21:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E586B008C; Fri, 12 Jun 2026 21:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 256296B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 21:16:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C85A01C3070
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:16:55 +0000 (UTC)
X-FDA: 84873125190.17.4A1B8C9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf13.hostedemail.com (Postfix) with ESMTP id A9DE520003
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:16:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DkdflDkH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781313412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0luNcXS2Cblt6VWpYbuul8wCEHYocrC1TCFdbFYrArE=;
	b=XwR+UubnL/ZUHlbAQXHHhT2JqxY1uJdq5VNkdWrCl48Zg2VKhfmh0YbXdAjVYiLDCig47j
	UGCOm6l9I8i0hFKjFkLBij9+XxYGGLuOAQ0KV+ugTzYssWPJaDW1hCt9dHrvAe7QJW3TLm
	XY2/3y8+v46jRJjrZGOjiUQbYy2mTDw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DkdflDkH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1781313412;
	b=YI+KGRVULSeplunJAnRodz7wkx4NOOxENtrudUreXCjCo+XUjX4AxSSQ9/y5j8DZxYbepw
	cLTjFAQTTam76B47y5Yyp1xYpQ77q/WDGO4UzUzHuUPol53DgI6H2oRalEEfM2aId17GoN
	/S4h63oWn/TNDyXkJhsU9k8PUgPPn3k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781313412; x=1812849412;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=3JeH2AZBTu1kZ4TrN9ihIU0bOgjNqBZyWsQlXyErwYk=;
  b=DkdflDkHLZv/MvG0FQvkuM6tKjhKT3MZXZVAqt+kdoolLMj/N1Ukfs2P
   QAsHP1MEqKY0FLeIQNsxY09ELdsdA+E/O1u2mNfGfwg7VmBxorBXhOZFh
   CTTf8P0F1/IDMKjBRyJoT9m4Ugnw5AygrU43bWxfMvwVT5aKuVPYsGNSR
   siDyAH/r+m7G83+/vvqdB5fKRemvUwNcj5v0MFwsX5oXresDHZKwkVGu2
   OahU7kSEdcAfQIJnqVeT4cjCUt/Ma1VAdRRbFHrCVnPwPv8bWlivFDZzk
   V+H9ykOzSjXgb2leNTydnSH7eE2L7Z0BDTVPEms2QgmsBU6wFbi580rMf
   A==;
X-CSE-ConnectionGUID: Xw7bpDLzTeeXO4EolJj/tQ==
X-CSE-MsgGUID: Xmdro9zsQgu1mDRO12FbEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11815"; a="85996532"
X-IronPort-AV: E=Sophos;i="6.24,201,1774335600"; 
   d="scan'208";a="85996532"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 18:16:50 -0700
X-CSE-ConnectionGUID: gmfE9WrhRSSU/XWfMv90cw==
X-CSE-MsgGUID: n6GfHjX2TvCd4bw910l9Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,201,1774335600"; 
   d="scan'208";a="270633392"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 18:16:50 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 12 Jun 2026 18:16:49 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 12 Jun 2026 18:16:49 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.62) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 12 Jun 2026 18:16:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MiyRON6jQSQgmKikjGgBP+FklAXhP67TCxVGv0ewGAHcvWrRnA9M5v2ygOfyahk6b7rVre7qo41AwCDWOY5V/sOapdCB0rcGEKs0/o3Wmkaj8/iThLGvZaP/FjtTyG5kkUyhxlV5FbgaLZ9Fow25YMqcRE6hUXMjlOJxaj9qXYmYx8Ouv6UEPNXXU5vn/WYpraoX4vUeV6B90iZDa3uiiNELgTzAe26aNfeI0pBMnIZR9kUEVTcmpqHfvAjbEz2YVTOHb/y3rKMhgNB4qLAObDI1IDQHHD3CuncEe10vXro9nGn1rLuIUSu1G2TwSJLel5tI6DcSTawNeRoMeTi2gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0luNcXS2Cblt6VWpYbuul8wCEHYocrC1TCFdbFYrArE=;
 b=whFUPCmKpAAMKoQODb7H1x4f2vrFAMp+4rYYFZhS7NGAxEUFoSxH85nJE2rY/m6WOLfdpb1KWSTaDPjBUJM/zUGqv3/mZumwViZnibMhWk4Vm+pInnPCHzysHR4GDKo40WrakPl7zClHurjrTcWoXRCwlVtmkLFv885vh4ZHeixN2Xx1a0XibSbgguahViDuUVZW/FSaiyG25WUW4pTicfw8QueQYtPFTpnjx8pLA42MojvorVfJ8LCJaGTnGr4NmkGlDbM6tktNGRDP4DuupHF/ZCkdAwZcbgNawPRkaAilgk3jNafE3806S7pSNwiiMngV88SCek//m/mvZO2sUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3493.namprd11.prod.outlook.com (2603:10b6:a03:81::16)
 by CH3PR11MB7392.namprd11.prod.outlook.com (2603:10b6:610:145::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.15; Sat, 13 Jun
 2026 01:16:46 +0000
Received: from BYAPR11MB3493.namprd11.prod.outlook.com
 ([fe80::887f:a81a:8389:1259]) by BYAPR11MB3493.namprd11.prod.outlook.com
 ([fe80::887f:a81a:8389:1259%5]) with mapi id 15.21.0092.011; Sat, 13 Jun 2026
 01:16:45 +0000
Date: Sat, 13 Jun 2026 09:16:36 +0800
From: kernel test robot <lkp@intel.com>
To: Samuel Moelius <sam.moelius@trailofbits.com>
CC: <oe-kbuild-all@lists.linux.dev>, Andrew Morton
	<akpm@linux-foundation.org>, Linux Memory Management List
	<linux-mm@kvack.org>
Subject: [linux-next:master 12966/13336]
 ../../../lib/interval_tree_test.c:315:17: error: implicit declaration of
 function 'pr_warn'
Message-ID: <aiyvdAugnSzVlm+6@rli9-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: KL1PR01CA0085.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::25) To BYAPR11MB3493.namprd11.prod.outlook.com
 (2603:10b6:a03:81::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3493:EE_|CH3PR11MB7392:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a2bd48a-9919-474e-b86a-08dec8e96f26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|3023799007|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info: JozIwoHIwpQeXh4cOY7kuxxQImjN3Z7vJEgoe8vwl7xYtAm9jI3Hep3RGK4UYTzewRIJ1XdCZoY3mn8l+QicdovQHa5mvBLEYJj3wT4V2/jLPq2j0Yky9uaJXkIosFIbmqol3U7Lh+LbSvR1/TfNbT1d7Ne8szAvCs037Oyw6+zcPDiCccZKqGbfpi3tA1fhMwgvAL9oiMv+Q5Xb0ep0wu1KZMq0lQuZgZvCvqiD6QeEelRaAAIrUMCmZB01si3430W6+I68KJqk/6FKmH1R/AUNMxHBvGu1JPOd+IpD6y2ROAXh21THwdklYfzcMbx44Tc7vDUQ8yg10sqD6WJNWJ53EElWlZuz0IrBOk7N3rk2lX9cxOATrdsF/sZ2IXzozEXrgpZ1nrRVIgr7qC31PKxLqzrOlIVv2KanLJR2Z43yePD8Zw4VvNqRbDG5vVG//tHFMYfWKvFWDwEd58Fem3bWmottxyyP269428dUcz1SHZhABsOfXFzBtCRCrmHNYENJzKIMIp/NfAneKU4LJZcHyboCkMACJQE+JjWJN2dwTqKattuaDcZS5WoFlE0p/3bTSAdRZZLQMzPh/zmZL47DMgLIb2gCvd/NWc5294Pg8EaoK3XqvbfnayC+2vwvSSJG7Ow9HJFOaBtveTa/n2NELT7yHwAxVNjQcg+E4TmUYR+8YvZyWWEXO6a2P9r9E6cVH94oF2KdR77ZdETlGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3493.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(3023799007)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p96iFZxJ8v30OTP4gfaPLNPSozcECYKWZBsYqSr00ny7qW5WA40nQYpMuM1L?=
 =?us-ascii?Q?5h6KSapoS2ysJeqb+xHgOutEj+iU8bT40BR78Ez/xnp2cptEEH80yHVWx69n?=
 =?us-ascii?Q?2Czha5RE4X85UYYQz/Xe7u3MpKuRBRbA0QhQuSKtdnnUP7AyZEkTiIkz4Cw4?=
 =?us-ascii?Q?dnOArqksMN8T5eF68GMpkxftP5ssn8RJthUGaDK63+QoEKZZdeWa17pVjHJ2?=
 =?us-ascii?Q?WSUneDz5wO65cwMZNJpwBO/U40dBawNSP6QOsHo4qO4XYlqHsDBdED206lI/?=
 =?us-ascii?Q?d4Fv/HgWzieTiq7SwYreXMcckc7RRvynhglLK0stPXAZR+llTgc6ZjfQNbbq?=
 =?us-ascii?Q?2xjQ8F3pUFeNiXWwGCUU/EDvvxQrpAi4puyNqQqGbONnCO92rK9UXLvUPpiW?=
 =?us-ascii?Q?MG+Xia8VlznsaDXzyAxaOu8/SAABbFufkkMwCoH9/kEcxSDRb+RY3+oDWgJm?=
 =?us-ascii?Q?J/amnN/5GOVwyzfs+MGFfdKAbZvYhbzvMW9FW68dXCI1UaYMnh7U9Mr64inz?=
 =?us-ascii?Q?oQ7irIin5gDG/vK4jyI6KsaNtj1CcvdVXRnxlXtFiiXljO1Vl6EofEk2RgBT?=
 =?us-ascii?Q?O3JwMHULTphB0M3PIAGZ0mCR9I4ej7XaVk95tWYECVAsMySbg4OQj3UYUxpc?=
 =?us-ascii?Q?7ToUN8AkhBMMzx4Xudx63qu+DX6wgJgoaT4xhNXnWlWksRF3CMMZK0nqVBwe?=
 =?us-ascii?Q?bI55QCRfQ9ghjQCPOuYxLzHnWf/lfVDOjgr3T+TJFncYsT3T/DygdX4N28qR?=
 =?us-ascii?Q?MTjZonGM80Jq9fypHkTp6YoVuIq9x7Jhcm2/PHdmaRQbYInAV/y7WiFE9zWK?=
 =?us-ascii?Q?1kUr9CmDLUjiDZyiBKiES6aCJFsap50S/5KHBh9W7y8FS03sc7WVHq/kH7bM?=
 =?us-ascii?Q?EtRrTVLktLBZoyYNnO3TdhNhdvKfsm/hN244rXfcCT0O/rTHyyaUAP+Pwusw?=
 =?us-ascii?Q?/zCnV96vf3dXX5ohyUulADH4ZTKCxEGDT3jSgqBaGIJoIT0WL/Vt1ieldyzD?=
 =?us-ascii?Q?nNa60Qt09WRzC0na6MqVL6uJ9xYCPCsyuSXF5QD+yMvQU8Rg5CllTONC0osP?=
 =?us-ascii?Q?9k74HmwEZ2vo7HNuSAFkyvlKl5w3WAC48RmOd+OzYNswcQIW7AEd4RIJRiOP?=
 =?us-ascii?Q?JIEUbzYsDzbN3M2QYuw1P8rXTQUlbzl0AyqLXdGeHLmkmKHfmIliWegsW0iW?=
 =?us-ascii?Q?lizlef9b0St+8vTp0Wprci2GOGRzGLsVumk9VEs7U/jjFTrjZdpKP01BNq1q?=
 =?us-ascii?Q?RDSPM5taYmXZTqhoIKX4qmG2CVgcf0ZPD4F2UgdosVt3mCXw+g6yLi2jJpCz?=
 =?us-ascii?Q?7v+nuXJ2lzCaa9aeXzW770RxcUWEXns0h11VEMPmxVk3Q1FI6/3acJdwLwIC?=
 =?us-ascii?Q?cxzLnhNDLHa45MlHxWCjSTfMNYmAyEuxsSfoVcevtst8+hCmyYdfG+kgfhO3?=
 =?us-ascii?Q?XcQ+ElK8pgj9GQvNUm9ub3xchmNVlNpC81B3q/gBeTtoavCnykNgzs96gBih?=
 =?us-ascii?Q?nvPnZtn4RkzUsHgmUxFf7CXzhZfi4hmOuRSW5Lo9s3nGrXRxBX/bK4Sy/xem?=
 =?us-ascii?Q?R/tVXSAIpHQHSes2y2OrKbHpX4gwJ68bGS8pn5lvKQLPlZhUVYxWbivNOqsn?=
 =?us-ascii?Q?HE0iu3RvwdVTsCEcFyqm9dDQVM7oksuO5XQs8mP0AH/uId5wuc1rqaDn/2Fu?=
 =?us-ascii?Q?mcPLYpMvkpSJkM9ImwhbuZHIC42AsG2U5oj7q9BLNW7fh/+TohMsj7U5rCJ1?=
 =?us-ascii?Q?/qVMsX4BoA=3D=3D?=
X-Exchange-RoutingPolicyChecked: TiHzsAh+rgekT1RFPB9UpHRnz3xFfj7FcTEJVRY/JWS6Xs2jCJWlzoMvn4DU+YEwE8VNCb+IhjKWhFJ3+mA0nq/M1KAIOWmDx2Murg2mHkdpF7dLmlyB/ZmUTIF3i972Pp49OxDKwDk/IM1cwsShQFmqypNMPjHt1gt8j5XqyT0ecblgCD33ltYavo8dxxzZ0mbnzLx0hLSq+5Dsvo6+eGvYV9YmxxXzwiDLdbilEqKhkzcFWH2y2kyjcCfkMoIVP0nvOpDyUQN39ELEyzMlYx6hf8ujtzI0bjdqfOscmXpvTYMNIPAWcaYWNNXHyiHn02yG2B6lfzKqnQXS93FPDA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a2bd48a-9919-474e-b86a-08dec8e96f26
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3493.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2026 01:16:45.6492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFNZGn97YWfK3Cmqm4B6e+SkpwJK42NImEleBowriLR/GFViAatjOhqfNgJt372W1BsmG7/iXKVJ8+kUyJXjkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7392
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wxc6zt6mn54bkmm7dhhotbk5geoq7pda
X-Rspamd-Queue-Id: A9DE520003
X-HE-Tag: 1781313411-468708
X-HE-Meta: U2FsdGVkX1+pPKYQdzrC4x1TxhDel4KPXwn+fy6UvXbfZU8gL58ykbDI+UsPmfVaA4yhOmtSHH5sqT6TTf+cc2I+vgoZ23pgo6VP96NZtltaCOA3xMG1L+WKXEwXkkw6Lw9sy3oxeFjX5kGRH5hWh3jScq0kaRMXzDXY4c3w1JxR7EYqAuF7+si6jKXZbeJ6g491oV3uTN8iScj0oZt/oc784tkNCF4qlg7mQfvlD9WRHIuDyWpJSf5q4bd2AjTbs/HR7BgVHMLEHn6c/HoaggP93pWGbT0SlhXU9S9Z2yQO4M/DArHdwrfd+W6fhs6tAyPBXGJNe47/aNYYURT2aSl7DNNx5pNO3E6rwZeTa5aujfcSrZe/3+DCyi4COPj/eSZxIkGeHNeXAKSkZmLbUQtFLLdeFYnTgYS37GgfqTRpdFbFmajUaLpvRzj9mnz4BGmQ8Ew4AC8NGtc6m2OhXJHYwdw0WJybaxU8rW8CuDd3XpRRuJQjGi/QlA9/1L8U6DoQ4oca/S82JUrmTzztlC4o6N2wUDkT0wO6T7g9m34sEoR5quWH6xuC9hi8g0tT4Kw1enGNajbld/ql0AokcLnB5+TfH+rICAaFBs9qd+1l1SrLohGRLfocQPQeAAEAkGAoguC1poOKu/yMDrL9yTNhPgeSADgj5jIooseY0TPdj3cPiW0U7y48AwOEB0+mm6WQ3/CMpvuFPTfyhvDye2fKptAM4KvwdbR879QMLZuGdlcrJkqJkuxO/VImr4TjEgoTc0/O4yJnc2dDb7iZYi2T9XuVUSRcFuj5O3MsnlvxGipfi+5ma2chIYVTu4oVSrKZfiiyqms8c7PKxEXJWsRsHUeiTxLsl2rqP0onpb1+JWag3w2ONEbTCPGEs+hDNc331ZfhpaaBSqsO0o8ukI7a36PxpCJNa78kCopVjm8p5Vl+fPf2ZCH/DcQTDF3czUvFYji0T0I4IigBB5W
 gNeUFu0K
 1QeyVKsTF7YJ29L9hhQniIuzubj02dn7T1nPOYFpOBVzDke6OgE7OyA9UrJT63lxo+mvFsYGvT5RjO/+dCRO8utMY92GTdvGsSLfMefMrQ3wPi2aYEVnxU5eYigJ8MoYCDuu8VXxKlHPq0WIah7dzlQp79EKlJnsn1chCFuxLvaNHG1vTWeCrRiRM265zuE7JIR36t0cqX8dx8pcSO5NY1JEDY3HYfaQWBHotpk2TctGTnOsybya8NlsCa3y+2xMQ1HjHs6OHtiNXAADGbtohixSKMibdNTjy7DQgIJInqwsVbGq6ZTk9U1jIybAJcgjVY+z82rEHBST6As5E2IaarBB8wSJUeNWMjL9hw/AdcVXCMeY6yHwGcPIpQG6MudSghu7xT+RMZEesj8lAwixA5vyg+Xo9C/HR2ZP9lIAFUd5G1pfJ0Q1M/ouO16Pa/FjYUL4uCI8CRzQFlSvNkOXDyHIteAHXTOaBfdR2qpB8LQUAe+Vx/srJ8SkV22SCLi0qIbBtI1fSKq61j5W2daYFFw6/0cnD93V+eWRdj9QdbAF52n/jonE95kLGDoiEasN4hE3zLe0/0N5gDa4aVMryK2jKdjXcSRQbuGOdP7KLQQNL1DRo0CccybieHbomRP+W2Aa7qpUFgr/fqZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   c425609d6ac4012c8bbf01ec2e10e801b1923a7b
commit: da58d4edb02fe347b676a3be230fd16da68c4fc8 [12966/13336] lib: interval_tree_test: validate benchmark parameters
:::::: branch date: 2 hours ago
:::::: commit date: 2 days ago
config: x86_64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260612/202606122249.neYsYssG-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260612/202606122249.neYsYssG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202606122249.neYsYssG-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from interval_tree_test.c:11:
   ../../../lib/interval_tree_test.c: In function 'interval_tree_test_init':
>> ../../../lib/interval_tree_test.c:315:17: error: implicit declaration of function 'pr_warn' [-Wimplicit-function-declaration]
     315 |                 pr_warn("nnodes must be positive\n");
         |                 ^~~~~~~
   ../../../lib/interval_tree_test.c:335:17: error: implicit declaration of function 'kmalloc_objs'; did you mean 'kzalloc_obj'? [-Wimplicit-function-declaration]
     335 |         nodes = kmalloc_objs(struct interval_tree_node, nnodes);
         |                 ^~~~~~~~~~~~
         |                 kzalloc_obj
   ../../../lib/interval_tree_test.c:335:30: error: expected expression before 'struct'
     335 |         nodes = kmalloc_objs(struct interval_tree_node, nnodes);
         |                              ^~~~~~

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


