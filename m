Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12574CD4F3D
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 02:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38D286B0005; Sun, 17 May 2026 22:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33EAE6B0088; Sun, 17 May 2026 22:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2106B008C; Sun, 17 May 2026 22:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06A536B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 22:12:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89251A075C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:12:52 +0000 (UTC)
X-FDA: 84778917384.12.BAD3C02
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf07.hostedemail.com (Postfix) with ESMTP id EEFDF40009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:12:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="D/ZXJC42";
	spf=pass (imf07.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779070369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0quTQfdzr+dDNKIY2b6deY1AkA4auJKFhY2bmam2mA=;
	b=B2XJ9leXp36teoKwJhxvS2IWVZSmGk0ZszXzg9JcHjdsU08KFLydKydk4JS6hUIEi5bvtM
	ohGeh8A/a7r+RL/8hyAyB5EPdmOElcgpnfGBVLUbPgh7eux2+1sAqER6KhbLHNnklk+LeD
	52yIG1mr86+TwDhjuxkYc8ksQxShSwE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779070369; a=rsa-sha256;
	cv=fail;
	b=0WJzuI0FuE1GX4uPpe3WcuaX53rsjSOxd099zx5dTK9AqMYNaMx2vKb1NMIVZk7WAWG6Ii
	FoLYDE3aDuEqEMDwJ/+A1OikmE81NHNkfmsNUwT1QT/o/BTSo7zLzj6rHOobX/daZnFjb9
	g5qjqCzYa6I1Qayx82RaoV6PAX0sF5Y=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="D/ZXJC42";
	spf=pass (imf07.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779070368; x=1810606368;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=NF5ksEcj58toXJaNivyk1n+VOj7+B0Jlxj94YbvTjqo=;
  b=D/ZXJC42Y4aJsZqhH5VEo8cw/3nkeevOlDgtx9JC4gIJW4apvxDmwSoX
   D8FEGh44B2KcVRGAfgXPv2oviRxyhfYr1c2bCeWRKraUjlb0pClSSA3ft
   EInSZDm/dUWQbOvP4U9eMGAkbc4degb8iWG3mWSXGsvCxZPzECrkbyICa
   TYG7gVxuMjr4qb9I7lUkkwWyrMylZAJahFZioV7cM+rBKWHONk6m9U/WE
   9+WGZWrdvPKuN21i2yyY4fm+ajTZ4cbJcMWHL5tq+ctsH2JS4IAKQs3vC
   6b/F3uLJ4Mf9npVfr8ZKVXt3yQmtrzzzjeTsE6yMDSiz7ugHALyw4msqY
   A==;
X-CSE-ConnectionGUID: mVBat6xiRIaAXBBK31I9Og==
X-CSE-MsgGUID: ISzKhvFSRpOKBeAAPfE8bQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11789"; a="91309963"
X-IronPort-AV: E=Sophos;i="6.23,241,1770624000"; 
   d="scan'208";a="91309963"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2026 19:12:46 -0700
X-CSE-ConnectionGUID: 5VDsMiYxR4SOaxPEu8hoDQ==
X-CSE-MsgGUID: dq2uLivMQ226YRQL497lvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,241,1770624000"; 
   d="scan'208";a="235050629"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2026 19:12:46 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 17 May 2026 19:12:45 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 17 May 2026 19:12:45 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.65) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 17 May 2026 19:12:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IAD/4DUdgBFsjDaR7c9eF9hCeiZiZbWWHaGGJjg6PHYRkRl05a7iajQ32ylQ4S0dLUROYXL+sATrbkQ5T4dcPTo5d226yO7jfYO6shX/Zbmau66fD3ttrGutuVvIS10855oSpYvnsAdLltRo3bZvQfRSypVW/+QmMgf/zol9bVOWpN0iFkyGWJovLNcK+e5+7PBmzIzPW1/YHCSLAsTK3HAbQUVFR6BL3pWBQB34mtYr3/chCtnlcrkiDZTTBEyp82i1Nq1Df34SwGobEd6WK1VJXyj3a8iGFVSOT+NGRZHF21BYbUsTG1kjogR/j893daKP9CNCHrGZK9zls7q0WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5+P3LZbVYC0eEC43bX+zXzwmkIDoCyEDbUNvsnfUqI=;
 b=FoOWKt/vunDXIWJhgYI5vrVqGCqwg6FnTWm0swgTlkmyUiaFItq5pj06HlPVyzGBuWQDF/25Gp7iTm+z/j/B9t7rT+QG4l+sUdksRgkgpDtTkgV4lcYDRXxGDVKdMjP3N/iJ1kKyMTW64+d+lQ6bkFa1RTJsrHzw5FX9U+lBp1NySx+hYPnB86ccigMId52cpAm0pY6IO7VmLpXp4iEDYEfBhWDdLR+Xj9dZ9CfDwYcwyEPVWsS/zATAZAoyO4nDhGj0MvfXgxIrE8saJV+sSwrFqcxAl8Z4gBZrusrSIcg7Vf9G5y5nBSb+MK1dgycUGZVRpuNzs6dM093D2Og1+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by CH3PR11MB7761.namprd11.prod.outlook.com (2603:10b6:610:148::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.22; Mon, 18 May
 2026 02:12:40 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.21.0025.020; Mon, 18 May 2026
 02:12:40 +0000
Date: Mon, 18 May 2026 10:12:33 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
CC: "Harry Yoo (Oracle)" <harry@kernel.org>, <oe-lkp@lists.linux.dev>,
	<lkp@intel.com>, Hao Li <hao.li@linux.dev>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: Re: [linux-next:master] [mm, slab] 298cdbf5f7:
 will-it-scale.per_process_ops 6.3% regression
Message-ID: <agp1kUJSzZqyJO81@xsang-OptiPlex-9020>
References: <202605112204.9382cecf-lkp@intel.com>
 <90bf195e-45fb-423c-b686-49be9cadbd11@kernel.org>
 <eda98e7b-67fd-4a36-9d39-3de26827599b@kernel.org>
 <d28b4a2f-501a-45dc-8589-acc41633e2e3@kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d28b4a2f-501a-45dc-8589-acc41633e2e3@kernel.org>
X-ClientProxiedBy: TP0P295CA0047.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::13) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|CH3PR11MB7761:EE_
X-MS-Office365-Filtering-Correlation-Id: 84349be6-92bd-4cb6-0642-08deb482f009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|4143699003|11063799003|22082099003|18002099003|56012099003|3023799003;
X-Microsoft-Antispam-Message-Info: n7R8fXTmq5LmMVZzJJKSfY0OGG9jcp196zXEGjhArv99b4eT/p81N0FIAKUbkhCrwfnfgWkYTlDAfayauc0T/3RiTLDlwNwWTMD8V7PnyGlwA8Owxc+ju9NEOR5rqhdiNrCC0y3s07GALrc3EXfCwhxBWWEhRX51hFGJXJBgv7nwm5OjK00lJRxfS/a+zLMSZWSWC17hy1pIfkaejw8zw+oocEgxfL3WSdRLMjUy/VRhn03q08ZoymCLcSF0teqCESHizXisX6FkJ6kFyTPzhVL2YyNH+B+RffTLeVXlVlCoWsR3Ntg7OvdGhkxFe/EmuQrcsJy/vbDZDWEXqKSX/CsK9viKXXk0lSV621vDTd0JbRGE53fQCfNf5C2eDjB2wbL5kxv0b3l867j9cnBDLyucZJlSBGatAVT+j4vgx2crAGLIoBfXcsFfLSwu6NPo+pNTdfKDGFK1TyQv+gCXUFD4PQqUulL+zTOq5+DYrK34IlYzFSN9NWC8QnP19xTTv3ckgDNBJF9Ei8q9jDdD7QCRIrovEYuNaj2TJj3x/qf8uTNkgi68IFv/vMhp8ZeGw5auFr0BBTvm55PNlSD6aRDeYEonLgObHomrH0Qdfhpcr1memZ1zfm81xrBkILJ+YJNR5tOwDB3ERLJu74ZDmmx6ebjSAcH9vDbIwJ3y1jQpm8/mw4EctQYtXVWi87Dj8cxwETU2eKqQb+76ExtwQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(4143699003)(11063799003)(22082099003)(18002099003)(56012099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?igYxiuL+ZBC+fr2WxqDqnyXr82W3h90F2iTbXX33pJ7qXs95G/+Lk4togy?=
 =?iso-8859-1?Q?/H1YbMdEnbERbnZ2eau8L7Z9sRvErR9Xq6PZbKVKiVStkH6hy7MiSevBgZ?=
 =?iso-8859-1?Q?lgehsj7X+mXhU5KgamfPbXa75dlbpeb+jt5eX77krPH5XA6uckjIcfJLa/?=
 =?iso-8859-1?Q?XGW36PXZr9wm23yeg5AO9Tw0iOUoE+nb350wq+6O8jsGShcF0/1lDWpKqX?=
 =?iso-8859-1?Q?T/bjNmP/Cskl/h10rs0Rr6hzmK/0Mv34xz/gl8mMBdffUFeRy8IvL3sbsT?=
 =?iso-8859-1?Q?KAnH5AD4IPCuoJZSVhR6NrSVTGNk07JB0RR2bAtzF+skGEyD0gz8ZGRlZd?=
 =?iso-8859-1?Q?hJXFbMOJXEE6IwmhpgH5lqx9WfvPlJQX7kAAe7glLiEGGYjqCPrxxeuUk5?=
 =?iso-8859-1?Q?sJ2rQ68g9125yDQEywRCNFsCnkdxj4ul4tviaDIbRo+A4/CJGTsRzZ1srw?=
 =?iso-8859-1?Q?oTW4PBBS8Cou2prLqvBVgH/HGzMoyFuLM4HFrwcLLr7jWAW/zrhYInLRbj?=
 =?iso-8859-1?Q?74nb/5djgR5UPCHyuvo9aWwqd1IqN/yu+bIYQOEQ4rmL+C4TYDxGG5bE9Z?=
 =?iso-8859-1?Q?7SysAw4C6KNteKc3IpUu4ud81a09ox5euc6sAWg9zEXQtolnKOwLP9fLsh?=
 =?iso-8859-1?Q?z/lQq4lZZe+YucF51ogoOow2H/KNMH0ZilvIFTROXEZFExGNdfmXoJURjR?=
 =?iso-8859-1?Q?NXN/yn9vndCFfvJ1xfbwWvmP6vs5ENfKgIGTuQknffoeqyegQL2ecIS6g3?=
 =?iso-8859-1?Q?3nV2/dl41w6ZjcIC3lEfApw0Acni4d6ce9FFaPxOYcFU+oEltoJ6z3i+Ml?=
 =?iso-8859-1?Q?K3ipwktgYdNj7ncxxmY7KUGV+wjqW0Zq4EkiP5kY74Oljib0CAHLYldDgX?=
 =?iso-8859-1?Q?aUJPrctmdjT1D7kEvMxf4A6S4wgn4sFJjdkHkF/NhfYmk6O3PZWLlK3f4H?=
 =?iso-8859-1?Q?HK005dVLYRnXbR2QK63mKWDC4l8eJ4qV9cU/AAYclB80gWpCpcgesFFKwX?=
 =?iso-8859-1?Q?8e0ziRJGc4Nu4XOfo/ps1+9isI9KcJjVtB7sbZO3EbBmvah6GUMYvpEtCb?=
 =?iso-8859-1?Q?vkAMmlOCdeworXffVAxVWHEMNH3biu4G15F2Ia08v2EZyHDTp4S6kcZCSh?=
 =?iso-8859-1?Q?fDioK7BB53WkKNtOmZ9NaByZjde6SrznuFA0bDjopr8Syj3pPp2KzEswi2?=
 =?iso-8859-1?Q?VmArZ9qHRicHqdtxOiHTaQTeldLlviPnTQ4FkfBFLpnz/uWZkvQ278xJ4X?=
 =?iso-8859-1?Q?/hk7Bg75KMFs0wMDMfGMBurXncFoIMho6ZUQrnP2uAvR/rBLRA2duHBpmT?=
 =?iso-8859-1?Q?Cxu1IE5VmRBa8GLKYfHMxH83oLUmNZXjIvgU8AZVxnx1I/qO6kMBu8MyiB?=
 =?iso-8859-1?Q?LM4xsy50BROQyoM3S2dmJDOKiQUsEAA+XOgeJWoo2ruwbckU017n4t7x9G?=
 =?iso-8859-1?Q?QeKHKKfMprPF/77lbmiO+OVvBjO2DmFYwnx/7SU4jocp3WkGCsBkqc2PoX?=
 =?iso-8859-1?Q?hXwQ5U378Y/UELwnNffftX47I/G/fY7Q8wE/RptxE9V76X7mnJyOi/wOt4?=
 =?iso-8859-1?Q?9cbN3EFglJ8JoAdOmEDhrfd4uc5BRAocwMgDEHIiRJtEp38q1+9i56LPIF?=
 =?iso-8859-1?Q?iKy0b4vMvS/XqrXDDSzmbU6K2y80+0toZt2dQgtfxCxyHoldrDmQiupnpX?=
 =?iso-8859-1?Q?tKUseUwe6O09UtkYZKzL9hebCeCo4fYBVPrF1yZfmPvXuC3DkvjQbORBkp?=
 =?iso-8859-1?Q?D6S+qfc6SORQB3o1/JIaW+WTkIEqKS2WJdsb2MFYi5IlioShmL6x/omXlY?=
 =?iso-8859-1?Q?v2OFMaxzKA=3D=3D?=
X-Exchange-RoutingPolicyChecked: yIER+y4UTqvlvOi3YUCEZwbjkDSACWjhcel2/7/Vm3w9s0Mps14jiX2SS7wrKekzjwAngEb1pnahWJmf6dXzql9sR1hzoAXlpi6f6eU6ZsYfC9ZptZnIL1PHDq8hjv8q6Sr0zMA1RhkaSCcw1tzm1WfkRgfkVlQEuKPSUiMcNsndombO/GmIvILSm+8u/sa4FAfxskWF+yujANNKZjbfqdl0rBaxwcosD9abio1KsQppfBROkicBKcavQmf8qrOi+9B7pqhortwtePzaOE0n9a6G7vsWybkSaNcHUCcqqoG/7f9I5szHbUKtCg8PYdxsOLZ5XD6uxVcww76RtHGjng==
X-MS-Exchange-CrossTenant-Network-Message-Id: 84349be6-92bd-4cb6-0642-08deb482f009
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 02:12:40.1411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9FHhPnGS0JKPxJKXC5BA9zphkVfHHA0RqsYcpbD9aYgPM3zZ4wbgZBy5YKA8wv2FrBlWSjKqkLmn1bi1RtYsyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7761
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EEFDF40009
X-Rspam-User: 
X-Stat-Signature: 3eckmckm7uhbn7yxshp9c3z8b3dmygbs
X-HE-Tag: 1779070367-270404
X-HE-Meta: U2FsdGVkX19X62dc+qk6axFGz0pvJ+1nWydH9ejecv4XqN38/MIf7Z1tOTm8/pe2EU7rSk/0Rn5AIF15/84mpglEVMups6kZ8sr+2xKUrDO6x/gMWuExoY9j3074lif5TGfxvIfpOW//dPYBmiAfyq2MslM5xPq2YLZKCpwSJSBTXVBfPNUDbEmCENdNjs6lDUKps2YLibCLWpjtiPynWZ6JWDjRtOTX8N2wgzzGZKyZ5xYseBDMY8PteGeLZBLGC/lYp3eIQXiSGrj9XZjKUyYWFzzzlwUe4sJUd8nSoNQgSIq2vbNnUfmZ48O2lA2McufRXRrlCywlkJZ/p/kscvrv6l8yxnnGhxrk00EyC4Igb/pB7L3CyUtOA+ntXxpTA3rXl/Uvp8Y3JMlO6LWhP5N9g0/ZOn+ONHrxCWyQRpaq6oiKLuyvO/dpSKp4gRGKd48VTyWIZxI84wRcVfcSvdx0APJhUZqb2dnEuvY8MfVaBbAFxuvVhnPWXMv2TomQE0gCAjpGZGfBmsFFknWnZTN2MR3i/ft028e8zo+xQZpzNd1r6c7TVG2CH4QoArmROc8cFRZ/8R7PdwbnAVstKBFScxsaxjzNbX22dbMtZpQvji3EyArwT7JBj+n8oXD7DYrUz08X+G3hrec6SRc/t73F4yOOUAhhBwYgEQoZepc2vH4zU8yeN1aRt4ze3PxDiKpIy8nxswmlx7AvJQgDz2EtxY5fx1RUhRstnhxVktmHh7EKPaphiEspJIuu5xxuqaQeodxlmlVIZoXCFOtPUQkkpZjUtmwD8fx4uyVGml5YGQGoyUkKuSOoPaHjwS6Mrj1E6Ehe8tL/5B9p219y/z8ms10ts3yW+/dI637HvLvUksj9hLwXmUOvKtAiLspYPZR2lMiIeACYp2QLw1vk11/wRjD7XzSu9PBxOCE3FGQe1jN2JyKURN8WUvaHLEak3epj+rIBwxgD75eh5fE
 Llh9AR4e
 XJfOJlfhKLwNWZDp0fq8fVPFsUwF/6YidU596nbJhgOQ3bRGc8bsVtpYlJWKSiLXT5HmPVFSAOBFf35L2/goLgepanh6lrrFb0wz6RvZVVhE7U4fQy6eBkMXGQdbvbK5Bc43d8cl3jWkCl2nD9NcX44+r/Wn8Njr2/mLzchRgZUgUErsVUIKYSV3QlxFw5VOs51MsUj051V6FY97ABSEHxwyWSyhLICA0z8xwPLeR/1cjgdOY/xCNWTm+V9qvlENYfJotCnMNoo4N4nT1n8eMmqu338fHEIlrrM7cimoJhFtj+H4x9cNowHN2Kwf1bXDcLZaEorrZoM6ixFWZytlNziDV3jUCcPGgw5wJF8XPbEmHAxa2DwXLhsuBtHmtqcFexq52YaoMarKvhWxaD9Aob5LPNKqjvIt4S6/DZVhkJlP+dEa8vyCqXx1yEmGpX6TQM3/A/0j/O+OIltO5FszeU0Rpx1dtLZqI/O6usdbAmUeY6q5vPuWIPd9uBmVeVxYAUEqsfKtb2odu8M7nk2ApJvHHG6dZkl6BjxYjvXeS3OTEpZyYrDE19SL9NoT792Txlpyd/wJPBjhl9lZffX1dWhMLp0c3qAwmZKaA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hi, Vlastimil Babka,

On Thu, May 14, 2026 at 06:02:59PM +0200, Vlastimil Babka (SUSE) wrote:
> On 5/14/26 18:00, Vlastimil Babka (SUSE) wrote:
> > On 5/14/26 16:45, Vlastimil Babka (SUSE) wrote:
> >> On 5/11/26 16:45, kernel test robot wrote:
> >>> 
> >>> 
> >>> Hello,
> >>> 
> >>> kernel test robot noticed a 6.3% regression of will-it-scale.per_process_ops on:
> >> 
> >> Yay for an optimization that was supposed to have no tradeoffs :)
> > 
> > Does this help? I don't expect much, but perhaps...
> 
> And a separate measurement with this on top of the previous one, plase?

we applied previous one in [1] on top of 298cdbf5f7, then applied this one on
top of [1], the git tree is as below:

* 487ba8f16af85 mm, slab: ADD_TO_TAIL in __refill_objects_node
* 200ca7702bc5a mm, slab: simplify __refill_objects_node
* 298cdbf5f7c9e mm, slab: add an optimistic __slab_try_return_freelist()
* 1f7c8e1d52428 mm/slub: defer freelist construction until after bulk allocation from a new slab

in our tests, it seems 200ca7702bc5a have little impact as you expected.
but 487ba8f16af85 not only recovered the performance regression, it now makes
the results a little better than 1f7c8e1d52428.

full comparison is in [2].

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap1/will-it-scale

commit:
  1f7c8e1d52 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
  298cdbf5f7 ("mm, slab: add an optimistic __slab_try_return_freelist()")
  200ca7702b ("mm, slab: simplify __refill_objects_node")
  487ba8f16a ("mm, slab: ADD_TO_TAIL in __refill_objects_node")

1f7c8e1d52428cbf 298cdbf5f7c9e19289f46710ed5 200ca7702bc5ad828cf19d810f0 487ba8f16af859aade76148939e
---------------- --------------------------- --------------------------- ---------------------------
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \
    184468            -6.3%     172928            -6.6%     172299            +2.5%     189152        will-it-scale.per_process_ops

> It's just that __slab_free() would have been adding to tail so let's try it
> too.
>  
> From 8fba1377797478a945d97ad6163021d95ac7665c Mon Sep 17 00:00:00 2001
> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Date: Thu, 14 May 2026 18:00:52 +0200
> Subject: [PATCH] mm, slab: ADD_TO_TAIL in __refill_objects_node
> 
> ---
>  mm/slub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 0cc6c88f11e3..35e574e94538 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7193,7 +7193,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
>  
>  			list_del(&slab->slab_list);
> -			add_partial(n, slab, ADD_TO_HEAD);
> +			add_partial(n, slab, ADD_TO_TAIL);
>  		}
>  
>  		spin_unlock_irqrestore(&n->list_lock, flags);
> -- 
> 2.54.0
> 
> 

[1] https://lore.kernel.org/all/eda98e7b-67fd-4a36-9d39-3de26827599b@kernel.org/

[2]
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap1/will-it-scale

commit:
  1f7c8e1d52 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
  298cdbf5f7 ("mm, slab: add an optimistic __slab_try_return_freelist()")
  200ca7702b ("mm, slab: simplify __refill_objects_node")
  487ba8f16a ("mm, slab: ADD_TO_TAIL in __refill_objects_node")

1f7c8e1d52428cbf 298cdbf5f7c9e19289f46710ed5 200ca7702bc5ad828cf19d810f0 487ba8f16af859aade76148939e
---------------- --------------------------- --------------------------- ---------------------------
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \
  35417967            -6.3%   33202379            -6.6%   33081516            +2.5%   36317289        will-it-scale.192.processes
    184468            -6.3%     172928            -6.6%     172299            +2.5%     189152        will-it-scale.per_process_ops
  35417967            -6.3%   33202379            -6.6%   33081516            +2.5%   36317289        will-it-scale.workload
     21873 ±  2%      +8.0%      23628            +5.8%      23148 ±  2%      -0.5%      21764        vmstat.system.cs
      0.71            -5.6%       0.67            -5.6%       0.67            +2.8%       0.73        turbostat.IPC
    430.37            -1.2%     425.33            -1.3%     424.56            +0.5%     432.47        turbostat.PkgWatt
      0.13            -0.0        0.12            -0.0        0.12            -0.0        0.13        mpstat.cpu.all.irq%
     18.38            +1.4       19.79            +1.4       19.75            -0.5       17.90        mpstat.cpu.all.soft%
      1.64            -0.1        1.54            -0.1        1.53            +0.1        1.70        mpstat.cpu.all.usr%
      7.06 ± 14%     +26.0%       8.89 ± 12%      +8.7%       7.67 ± 19%      -3.1%       6.83 ±  6%  sched_debug.cfs_rq:/.load_avg.min
     18788 ±  2%      +7.2%      20147            +4.7%      19677 ±  2%      -0.8%      18635        sched_debug.cpu.nr_switches.avg
     16273 ±  3%      +7.6%      17503            +6.6%      17347 ±  2%      -0.5%      16190        sched_debug.cpu.nr_switches.min
   3418653           +97.9%    6765264          +100.3%    6848097 ±  2%     +27.0%    4342032 ±  2%  numa-numastat.node0.local_node
   3479092           +96.6%    6839697           +99.8%    6950484           +28.4%    4467529        numa-numastat.node0.numa_hit
   4424809 ±  2%     +79.1%    7922798 ±  2%     +83.6%    8125728 ±  2%     +25.9%    5569380        numa-numastat.node1.local_node
   4564748 ±  2%     +76.3%    8048580 ±  2%     +80.2%    8223664 ±  2%     +23.6%    5644081 ±  2%  numa-numastat.node1.numa_hit
   3478940           +96.6%    6839185           +99.8%    6950168           +28.4%    4467175        numa-vmstat.node0.numa_hit
   3418501           +97.9%    6764752          +100.3%    6847781 ±  2%     +27.0%    4341678 ±  2%  numa-vmstat.node0.numa_local
   4565277 ±  2%     +76.3%    8048347 ±  2%     +80.1%    8223583 ±  2%     +23.6%    5643990 ±  2%  numa-vmstat.node1.numa_hit
   4425338 ±  2%     +79.0%    7922564 ±  2%     +83.6%    8125648 ±  2%     +25.8%    5569288        numa-vmstat.node1.numa_local
      3957 ± 19%     -64.8%       1392 ± 13%     -66.9%       1311 ± 11%     -45.5%       2156 ± 19%  perf-c2c.DRAM.local
      1016 ± 20%     -46.9%     540.33 ± 34%     -41.9%     590.88 ± 25%     -39.5%     615.12 ± 23%  perf-c2c.DRAM.remote
    139593 ±  9%     -18.6%     113659 ± 10%     -18.7%     113440 ± 10%     -12.1%     122683 ± 10%  perf-c2c.HITM.local
    139625 ±  9%     -18.6%     113697 ± 10%     -18.7%     113477 ± 10%     -12.1%     122713 ± 10%  perf-c2c.HITM.total
    189874            -2.4%     185345            -2.4%     185372            +1.2%     192236        proc-vmstat.nr_slab_unreclaimable
   8051058           +85.0%   14892463           +88.5%   15179987           +25.7%   10116617        proc-vmstat.numa_hit
   7850680           +87.1%   14692248           +90.8%   14979665           +26.3%    9916419        proc-vmstat.numa_local
  25073981          +109.6%   52554060          +114.3%   53727154           +32.9%   33326970        proc-vmstat.pgalloc_normal
  23597828          +116.6%   51111380          +121.6%   52304077           +34.9%   31842348        proc-vmstat.pgfree
      0.20            +8.9%       0.22 ±  2%      +6.8%       0.21            +4.7%       0.21        perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.20            +8.9%       0.22 ±  2%      +6.8%       0.21            +4.7%       0.21        perf-sched.total_sch_delay.average.ms
     26.54 ±  2%     -12.1%      23.32 ±  2%      -8.6%      24.25 ±  2%      -1.3%      26.18 ±  4%  perf-sched.total_wait_and_delay.average.ms
    108336 ±  3%      +9.0%     118099            +7.7%     116713            +0.1%     108433        perf-sched.total_wait_and_delay.count.ms
     26.34 ±  2%     -12.3%      23.11 ±  2%      -8.7%      24.04 ±  2%      -1.4%      25.97 ±  4%  perf-sched.total_wait_time.average.ms
     26.54 ±  2%     -12.1%      23.32 ±  2%      -8.6%      24.25 ±  2%      -1.3%      26.18 ±  4%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    108336 ±  3%      +9.0%     118099            +7.7%     116713            +0.1%     108433        perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     26.34 ±  2%     -12.3%      23.11 ±  2%      -8.7%      24.04 ±  2%      -1.4%      25.97 ±  4%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.25 ±  2%      -7.3%       0.24 ±  4%      -7.4%       0.23 ±  3%     +10.5%       0.28 ±  2%  perf-stat.i.MPKI
 9.213e+10            -5.7%  8.687e+10            -6.0%  8.659e+10            +2.3%  9.428e+10        perf-stat.i.branch-instructions
      0.12            -0.0        0.12            -0.0        0.12            -0.0        0.12        perf-stat.i.branch-miss-rate%
 1.098e+08            -6.7%  1.025e+08            -6.9%  1.023e+08            -0.8%  1.089e+08        perf-stat.i.branch-misses
     14.49 ±  2%      -1.4       13.11 ±  4%      -1.3       13.23 ±  3%      +1.7       16.19 ±  2%  perf-stat.i.cache-miss-rate%
 1.059e+08 ±  2%     -12.9%   92245846 ±  5%     -13.3%   91784506 ±  3%     +13.5%  1.202e+08 ±  2%  perf-stat.i.cache-misses
 7.389e+08            -3.6%  7.123e+08            -5.0%  7.022e+08            +1.5%  7.496e+08        perf-stat.i.cache-references
     21981 ±  2%      +7.8%      23693            +5.7%      23232 ±  2%      -0.8%      21806        perf-stat.i.context-switches
      1.40            +6.2%       1.49            +6.5%       1.50            -2.2%       1.37        perf-stat.i.cpi
    256.41            +3.0%     263.99            +2.6%     263.14            +3.9%     266.32        perf-stat.i.cpu-migrations
      5815 ±  2%     +15.3%       6707 ±  4%     +15.8%       6734 ±  3%     -12.0%       5116 ±  3%  perf-stat.i.cycles-between-cache-misses
 4.341e+11            -5.8%  4.089e+11            -6.1%  4.076e+11            +2.3%  4.443e+11        perf-stat.i.instructions
      0.71            -5.8%       0.67            -6.1%       0.67            +2.3%       0.73        perf-stat.i.ipc
      0.24 ±  2%      -7.4%       0.23 ±  5%      -7.6%       0.23 ±  3%     +11.0%       0.27 ±  2%  perf-stat.overall.MPKI
      0.12            -0.0        0.12            -0.0        0.12            -0.0        0.12        perf-stat.overall.branch-miss-rate%
     14.34 ±  2%      -1.4       12.97 ±  4%      -1.3       13.08 ±  3%      +1.7       16.05 ±  2%  perf-stat.overall.cache-miss-rate%
      1.41            +6.2%       1.49            +6.6%       1.50            -2.2%       1.37        perf-stat.overall.cpi
      5764 ±  2%     +15.0%       6626 ±  4%     +15.5%       6656 ±  3%     -11.9%       5078 ±  2%  perf-stat.overall.cycles-between-cache-misses
      0.71            -5.9%       0.67            -6.2%       0.67            +2.3%       0.73        perf-stat.overall.ipc
 9.183e+10            -5.7%  8.659e+10            -6.0%  8.631e+10            +2.3%  9.397e+10        perf-stat.ps.branch-instructions
 1.095e+08            -6.7%  1.021e+08            -6.9%  1.019e+08            -0.8%  1.086e+08        perf-stat.ps.branch-misses
 1.056e+08 ±  2%     -12.8%   92081686 ±  5%     -13.3%   91581504 ±  3%     +13.6%    1.2e+08 ±  2%  perf-stat.ps.cache-misses
 7.367e+08            -3.6%  7.102e+08            -5.0%  7.001e+08            +1.5%  7.474e+08        perf-stat.ps.cache-references
     21840 ±  2%      +8.1%      23604            +5.9%      23119 ±  2%      -0.5%      21727        perf-stat.ps.context-switches
    253.30            +3.0%     260.93            +2.7%     260.03            +3.9%     263.15        perf-stat.ps.cpu-migrations
 4.327e+11            -5.8%  4.076e+11            -6.1%  4.063e+11            +2.3%  4.429e+11        perf-stat.ps.instructions
 1.312e+14            -5.9%  1.235e+14            -6.2%   1.23e+14            +2.3%  1.342e+14        perf-stat.total.instructions
     12.77           -12.8        0.00           -12.8        0.00           -12.8        0.00        perf-profile.calltrace.cycles-pp.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     12.68           -12.7        0.00           -12.7        0.00           -12.7        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main
     12.60           -12.6        0.00           -12.6        0.00           -12.6        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects
      4.81            -0.5        4.28            -0.5        4.29            +0.3        5.06        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      2.52            -0.4        2.09            -0.4        2.11            +0.2        2.71        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      7.46            -0.4        7.06            -0.4        7.08            +0.2        7.68        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      5.21 ±  2%      -0.4        4.86            -0.4        4.80 ±  2%      +0.1        5.35 ±  3%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.52            -0.4        0.17 ±141%      -0.5        0.06 ±264%      +0.0        0.54        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      3.50            -0.3        3.19            -0.3        3.20            +0.2        3.67        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      3.47            -0.3        3.16            -0.3        3.17            +0.2        3.65        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
      5.90            -0.3        5.60            -0.3        5.60            +0.2        6.06        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.96            -0.3        1.70            -0.3        1.70            +0.1        2.06        perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      2.43 ±  4%      -0.3        2.17 ±  4%      -0.3        2.10 ±  5%      +0.1        2.51 ±  6%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      1.47 ± 11%      -0.3        1.22 ±  6%      -0.3        1.21 ±  5%      +0.2        1.64 ±  5%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma
      2.25 ±  4%      -0.2        2.00 ±  4%      -0.3        1.94 ±  6%      +0.1        2.32 ±  7%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp
      1.27 ± 10%      -0.2        1.03 ±  6%      -0.2        1.03 ±  5%      +0.1        1.41 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      2.66 ±  4%      -0.2        2.44 ±  3%      -0.3        2.37 ±  5%      +0.1        2.73 ±  6%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      5.57 ±  2%      -0.2        5.37            -0.1        5.44 ±  2%      +0.2        5.80 ±  2%  perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.46 ±  8%      -0.2        1.27 ±  4%      -0.2        1.28 ±  4%      +0.1        1.53 ±  6%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap
      1.27 ±  8%      -0.2        1.08 ±  5%      -0.2        1.10 ±  4%      +0.1        1.32 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
      5.06 ±  2%      -0.2        4.88            -0.1        4.96 ±  2%      +0.2        5.27 ±  2%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      2.48            -0.2        2.32            -0.2        2.30            +0.1        2.59        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      2.51            -0.2        2.36            -0.1        2.38            +0.1        2.58        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      2.00            -0.1        1.86            -0.1        1.89            +0.0        2.04        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.24            -0.1        2.11            -0.1        2.10            +0.0        2.27        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      2.89            -0.1        2.76            -0.1        2.75            +0.1        2.97        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      2.56            -0.1        2.43            -0.1        2.43            +0.1        2.63        perf-profile.calltrace.cycles-pp.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
      2.26            -0.1        2.12            -0.1        2.14            +0.1        2.32        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      2.13            -0.1        2.01            -0.1        2.02            +0.1        2.20        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
      2.00            -0.1        1.88            -0.1        1.89            +0.1        2.06        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
      2.74            -0.1        2.62            -0.1        2.60            +0.1        2.82        perf-profile.calltrace.cycles-pp.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.94            -0.1        1.82            -0.1        1.83            +0.0        1.98        perf-profile.calltrace.cycles-pp.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64
      1.67            -0.1        1.58            -0.1        1.58            +0.0        1.70        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      2.36 ±  8%      -0.1        2.28            -0.1        2.28            +0.2        2.56        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core
      1.44            -0.1        1.36            -0.1        1.37            +0.0        1.48        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      1.50            -0.1        1.42            -0.1        1.43            +0.0        1.53        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      1.35            -0.1        1.28            -0.1        1.28            +0.0        1.38        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area
      1.38            -0.1        1.30            -0.1        1.30            +0.0        1.40        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap
      1.58            -0.1        1.52            -0.1        1.52            +0.1        1.63        perf-profile.calltrace.cycles-pp.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      1.44            -0.1        1.39            -0.1        1.39            +0.1        1.50        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff
      0.62            -0.0        0.57            -0.0        0.57            +0.0        0.63        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      0.61            -0.0        0.57            -0.0        0.57            +0.0        0.62        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      1.06            -0.0        1.03            -0.0        1.03            +0.0        1.11        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap
      0.62            -0.0        0.59            -0.0        0.58            +0.0        0.63        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags
      0.64            -0.0        0.62 ±  2%      -0.0        0.61            +0.0        0.67        perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.64            -0.0        0.62            -0.0        0.63            +0.0        0.68        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
      0.88            +0.1        0.98            +0.1        0.94            +0.2        1.03        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.55 ±  5%      +0.1        0.66 ±  2%      +0.1        0.65 ±  2%      +0.0        0.56 ±  2%  perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      0.51            +0.1        0.64            +0.1        0.60            +0.1        0.66        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
      1.52 ±  5%      +0.3        1.84 ±  2%      +0.3        1.79 ±  2%      -0.0        1.50 ±  2%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      2.16 ±  5%      +0.4        2.59 ±  2%      +0.4        2.54            -0.0        2.14 ±  2%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
      2.16 ±  5%      +0.4        2.59 ±  2%      +0.4        2.54            -0.0        2.15 ±  2%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
      2.16 ±  5%      +0.4        2.59 ±  2%      +0.4        2.54            -0.0        2.15 ±  2%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2.16 ±  5%      +0.4        2.59 ±  2%      +0.4        2.53            -0.0        2.14 ±  2%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
      2.17 ±  5%      +0.4        2.60 ±  2%      +0.4        2.54            -0.0        2.15 ±  2%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2.17 ±  5%      +0.4        2.61 ±  2%      +0.4        2.55            -0.0        2.16 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      2.17 ±  5%      +0.4        2.61 ±  2%      +0.4        2.55            -0.0        2.16 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      2.17 ±  5%      +0.4        2.61 ±  2%      +0.4        2.55            -0.0        2.16 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      0.00            +0.6        0.60 ±  8%      +0.6        0.63 ±  7%      +0.1        0.13 ±173%  perf-profile.calltrace.cycles-pp.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      0.00            +0.6        0.62 ±  5%      +0.7        0.67 ±  7%      +0.0        0.00        perf-profile.calltrace.cycles-pp.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
     12.88            +1.0       13.87            +0.9       13.77            -0.7       12.18        perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     12.83            +1.0       13.82            +0.9       13.72            -0.7       12.12        perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node
     12.88            +1.0       13.87            +0.9       13.78            -0.7       12.18        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main
     12.81            +1.0       13.81            +0.9       13.71            -0.6       12.24        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
     12.82            +1.0       13.82            +0.9       13.72            -0.6       12.25        perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
     12.87            +1.0       13.87            +0.9       13.77            -0.7       12.17        perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects
     12.81            +1.0       13.82            +0.9       13.72            -0.6       12.25        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
     10.64            +1.3       11.92            +1.2       11.82            -0.8        9.83        perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
     11.72            +1.6       13.30            +1.4       13.17            -0.8       10.88        perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
     11.63            +1.6       13.23            +1.5       13.09            -0.8       10.80        perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     11.33            +1.6       12.94            +1.5       12.80            -0.8       10.48        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
     11.20            +1.6       12.82            +1.5       12.68            -0.8       10.36        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
     22.90           +14.2       37.13           +14.2       37.09           +11.8       34.66        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main
     22.99           +14.3       37.26           +14.2       37.23           +11.8       34.82        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     27.87           -10.5       17.33           -10.7       17.20           -13.5       14.39        perf-profile.children.cycles-pp.__slab_free
      7.27            -0.8        6.48            -0.8        6.50            +0.5        7.72        perf-profile.children.cycles-pp.barn_get_empty_sheaf
      5.91            -0.6        5.32            -0.6        5.34            +0.3        6.24        perf-profile.children.cycles-pp.barn_replace_empty_sheaf
     10.36            -0.5        9.82            -0.5        9.85            +0.4       10.72        perf-profile.children.cycles-pp.mas_wr_node_store
      7.58            -0.4        7.18            -0.4        7.20            +0.2        7.82        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      3.98            -0.4        3.61            -0.4        3.61            +0.2        4.17        perf-profile.children.cycles-pp.barn_put_full_sheaf
      4.70            -0.4        4.34            -0.4        4.34            +0.2        4.93        perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      5.91            -0.3        5.60            -0.3        5.60            +0.2        6.07        perf-profile.children.cycles-pp.unmap_region
      5.19            -0.3        4.90            -0.3        4.90            +0.2        5.40        perf-profile.children.cycles-pp.kvfree_call_rcu
     94.66            -0.3       94.41            -0.2       94.48            -0.0       94.63        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     94.52            -0.2       94.27            -0.2       94.35            -0.0       94.48        perf-profile.children.cycles-pp.do_syscall_64
      5.57 ±  2%      -0.2        5.37            -0.1        5.44 ±  2%      +0.2        5.80 ±  2%  perf-profile.children.cycles-pp.mas_store_prealloc
      2.06            -0.2        1.89            -0.1        1.93            +0.0        2.09        perf-profile.children.cycles-pp.__get_unmapped_area
      2.96            -0.2        2.80            -0.1        2.82            +0.1        3.03        perf-profile.children.cycles-pp.__pi_memcpy
      2.55            -0.2        2.40            -0.1        2.42            +0.1        2.62        perf-profile.children.cycles-pp.free_pgtables
      2.25            -0.1        2.12            -0.1        2.11            +0.0        2.29        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      2.26            -0.1        2.13            -0.1        2.14            +0.1        2.32        perf-profile.children.cycles-pp.free_pgd_range
      2.58            -0.1        2.44            -0.1        2.44            +0.1        2.64        perf-profile.children.cycles-pp.zap_pmd_range
      2.90            -0.1        2.77            -0.1        2.75            +0.1        2.98        perf-profile.children.cycles-pp.unmap_vmas
      2.14            -0.1        2.02            -0.1        2.03            +0.1        2.20        perf-profile.children.cycles-pp.free_p4d_range
      2.75            -0.1        2.63            -0.1        2.62            +0.1        2.83        perf-profile.children.cycles-pp.__zap_vma_range
      2.01            -0.1        1.89            -0.1        1.90            +0.1        2.07        perf-profile.children.cycles-pp.free_pud_range
      1.94            -0.1        1.82            -0.1        1.84            +0.0        1.98        perf-profile.children.cycles-pp.thp_get_unmapped_area_vmflags
      1.69            -0.1        1.59            -0.1        1.59            +0.0        1.72        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      1.26            -0.1        1.18            -0.1        1.18            +0.0        1.29        perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.38            -0.1        1.30            -0.1        1.30            +0.0        1.41        perf-profile.children.cycles-pp.vm_unmapped_area
      1.42            -0.1        1.34            -0.1        1.35            +0.0        1.46        perf-profile.children.cycles-pp.mas_find
      1.36            -0.1        1.28            -0.1        1.28            +0.0        1.39        perf-profile.children.cycles-pp.unmapped_area_topdown
      0.98            -0.1        0.92            -0.1        0.91            +0.0        1.00        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      1.58            -0.1        1.52            -0.1        1.52            +0.1        1.64        perf-profile.children.cycles-pp.__mmap_complete
      1.46            -0.1        1.40            -0.1        1.40            +0.1        1.51        perf-profile.children.cycles-pp.perf_event_mmap
      0.64            -0.0        0.60            -0.0        0.59            +0.0        0.64        perf-profile.children.cycles-pp.mas_prev_slot
      0.54            -0.0        0.50            -0.0        0.50            +0.0        0.55        perf-profile.children.cycles-pp.mas_wr_store_type
      1.08            -0.0        1.04            -0.0        1.04            +0.0        1.13        perf-profile.children.cycles-pp.perf_event_mmap_event
      0.63            -0.0        0.59            -0.0        0.59            +0.0        0.64        perf-profile.children.cycles-pp.mas_empty_area_rev
      0.54            -0.0        0.50            -0.0        0.50            +0.0        0.55        perf-profile.children.cycles-pp.__vma_start_write
      0.54            -0.0        0.52            -0.0        0.51            +0.0        0.55        perf-profile.children.cycles-pp.mas_next_slot
      0.43            -0.0        0.41            -0.0        0.41            +0.0        0.44        perf-profile.children.cycles-pp.mas_rev_awalk
      0.53            -0.0        0.51            -0.0        0.51            +0.0        0.55        perf-profile.children.cycles-pp.mas_walk
      0.64            -0.0        0.62 ±  2%      -0.0        0.61            +0.0        0.67        perf-profile.children.cycles-pp.kmem_cache_free
      0.36            -0.0        0.33            -0.0        0.34            +0.0        0.36        perf-profile.children.cycles-pp.__vma_start_exclude_readers
      0.29            -0.0        0.27            -0.0        0.27            +0.0        0.30        perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.44            -0.0        0.42            -0.0        0.42            +0.0        0.45        perf-profile.children.cycles-pp.vma_merge_new_range
      0.65            -0.0        0.63            -0.0        0.64            +0.0        0.69        perf-profile.children.cycles-pp.perf_iterate_sb
      0.24            -0.0        0.22            -0.0        0.23            +0.0        0.24 ±  2%  perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.43            -0.0        0.42            -0.0        0.41 ±  2%      +0.0        0.46 ±  2%  perf-profile.children.cycles-pp.barn_put_empty_sheaf
      0.07 ±  5%      -0.0        0.05            -0.0        0.06            -0.0        0.06        perf-profile.children.cycles-pp.mmap_region
      0.74            -0.0        0.72            -0.0        0.73            +0.0        0.78        perf-profile.children.cycles-pp.mas_update_gap
      0.30            -0.0        0.29            -0.0        0.28            +0.0        0.31        perf-profile.children.cycles-pp.vma_set_page_prot
      0.14            -0.0        0.12 ±  4%      -0.0        0.12 ±  3%      -0.0        0.13 ±  3%  perf-profile.children.cycles-pp.mas_prev
      0.30            -0.0        0.28            -0.0        0.29            +0.0        0.31        perf-profile.children.cycles-pp.up_read
      0.07            -0.0        0.06 ±  9%      +0.0        0.07            +0.0        0.08 ±  6%  perf-profile.children.cycles-pp.unlink_file_vma_batch_add
      0.08 ±  6%      -0.0        0.06            -0.0        0.06            -0.0        0.07        perf-profile.children.cycles-pp.__alloc_empty_sheaf
      0.08 ±  6%      -0.0        0.06            -0.0        0.07 ±  4%      +0.0        0.08        perf-profile.children.cycles-pp.remove_vma
      0.24            -0.0        0.22            -0.0        0.22 ±  2%      -0.0        0.24 ±  2%  perf-profile.children.cycles-pp.downgrade_write
      0.20 ±  3%      -0.0        0.18 ±  2%      -0.0        0.18 ±  2%      +0.0        0.21 ±  2%  perf-profile.children.cycles-pp.mas_wr_walk_descend
      0.28            -0.0        0.27            -0.0        0.27            +0.0        0.29        perf-profile.children.cycles-pp.down_write_killable
      0.18 ±  2%      -0.0        0.17 ±  2%      -0.0        0.17 ±  2%      +0.0        0.19        perf-profile.children.cycles-pp.vma_wants_writenotify
      0.07 ±  5%      -0.0        0.06            -0.0        0.06            -0.0        0.07        perf-profile.children.cycles-pp.__kmalloc_noprof
      0.20            -0.0        0.19            -0.0        0.19            +0.0        0.21 ±  2%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.07            -0.0        0.06            -0.0        0.06            +0.0        0.07        perf-profile.children.cycles-pp.__call_rcu_common
      0.16            -0.0        0.15            -0.0        0.15            +0.0        0.16 ±  2%  perf-profile.children.cycles-pp.may_expand_vm
      0.14            -0.0        0.13            -0.0        0.13 ±  2%      +0.0        0.14 ±  2%  perf-profile.children.cycles-pp.up_write
      0.12            -0.0        0.11            -0.0        0.11 ±  2%      +0.0        0.12        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.11            -0.0        0.10            -0.0        0.10            +0.0        0.11        perf-profile.children.cycles-pp.x64_sys_call
      0.15            -0.0        0.14            -0.0        0.14 ±  3%      +0.0        0.15 ±  2%  perf-profile.children.cycles-pp.vma_is_shared_writable
      0.11 ±  3%      -0.0        0.10 ±  4%      -0.0        0.10            -0.0        0.11        perf-profile.children.cycles-pp.vm_area_free
      0.13            -0.0        0.12 ±  3%      -0.0        0.11 ±  2%      -0.0        0.13 ±  2%  perf-profile.children.cycles-pp.kfree
      0.19 ±  2%      -0.0        0.18            -0.0        0.17 ±  2%      +0.0        0.19        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.16 ±  3%      -0.0        0.16            -0.0        0.15 ±  2%      +0.0        0.17        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.31 ±  3%      +0.0        0.31 ±  3%      -0.0        0.27 ±  3%      +0.0        0.31 ±  3%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.14 ±  3%      +0.0        0.15 ±  3%      +0.0        0.15 ±  5%      +0.0        0.16 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.88            +0.1        0.99            +0.1        0.95            +0.2        1.03        perf-profile.children.cycles-pp.vm_area_alloc
      0.36            +0.1        0.50            +0.1        0.46            +0.1        0.51        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      2.16 ±  5%      +0.4        2.59 ±  2%      +0.4        2.54            -0.0        2.15 ±  2%  perf-profile.children.cycles-pp.run_ksoftirqd
      2.17 ±  5%      +0.4        2.60 ±  2%      +0.4        2.54            -0.0        2.15 ±  2%  perf-profile.children.cycles-pp.smpboot_thread_fn
      2.17 ±  5%      +0.4        2.61 ±  2%      +0.4        2.55            -0.0        2.16 ±  2%  perf-profile.children.cycles-pp.kthread
      2.17 ±  5%      +0.4        2.61 ±  2%      +0.4        2.55            -0.0        2.16 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
      2.17 ±  5%      +0.4        2.61 ±  2%      +0.4        2.55            -0.0        2.16 ±  2%  perf-profile.children.cycles-pp.ret_from_fork_asm
      0.69 ±  5%      +0.5        1.22 ±  4%      +0.6        1.30 ±  5%      +0.2        0.91 ±  5%  perf-profile.children.cycles-pp.alloc_from_new_slab
     15.26            +1.2       16.44            +1.1       16.39            -0.4       14.84        perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
     18.16            +1.3       19.49            +1.3       19.43            -0.5       17.71        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
     18.14            +1.3       19.47            +1.3       19.40            -0.5       17.68        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
     18.02            +1.3       19.36            +1.3       19.30            -0.5       17.56        perf-profile.children.cycles-pp.__irq_exit_rcu
     60.59            +1.5       62.05            +1.5       62.04            -1.1       59.47        perf-profile.children.cycles-pp.__pcs_replace_empty_main
     61.51            +1.6       63.10            +1.5       63.03            -1.0       60.54        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
     20.16            +1.8       21.94            +1.6       21.81            -0.5       19.69        perf-profile.children.cycles-pp.rcu_core
     20.18            +1.8       21.95            +1.6       21.82            -0.5       19.70        perf-profile.children.cycles-pp.handle_softirqs
     20.14            +1.8       21.92            +1.7       21.80            -0.5       19.68        perf-profile.children.cycles-pp.rcu_do_batch
     50.97            +2.0       52.95            +1.8       52.80            -1.9       49.06        perf-profile.children.cycles-pp.__refill_objects_node
     15.07            +2.2       17.25            +2.1       17.13            -0.7       14.37        perf-profile.children.cycles-pp.__kmem_cache_free_bulk
     15.67            +2.2       17.86            +2.1       17.73            -0.7       14.99        perf-profile.children.cycles-pp.rcu_free_sheaf
     65.82            +2.4       68.25            +2.3       68.15            -0.7       65.17        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     65.33            +2.5       67.80            +2.4       67.70            -0.7       64.67        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     51.67            +2.5       54.18            +2.5       54.13            -1.7       49.98        perf-profile.children.cycles-pp.refill_objects
      2.16            -0.5        1.66            -0.5        1.66            -0.2        1.92        perf-profile.self.cycles-pp.__refill_objects_node
      2.64            -0.2        2.48            -0.1        2.50            +0.1        2.70        perf-profile.self.cycles-pp.__pi_memcpy
      2.36            -0.1        2.22            -0.2        2.21            +0.1        2.42        perf-profile.self.cycles-pp.zap_pmd_range
      1.84            -0.1        1.71            -0.1        1.72            +0.1        1.90        perf-profile.self.cycles-pp.free_pud_range
      1.78            -0.1        1.66            -0.1        1.69            +0.1        1.86        perf-profile.self.cycles-pp.__mmap_region
      0.52            -0.1        0.40            -0.1        0.41            -0.1        0.44        perf-profile.self.cycles-pp.__slab_free
      1.44            -0.1        1.34            -0.1        1.34            +0.0        1.47        perf-profile.self.cycles-pp.mas_wr_node_store
      0.98            -0.1        0.92            -0.1        0.91            +0.0        1.00        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.84            -0.1        0.78            -0.0        0.79            +0.0        0.86        perf-profile.self.cycles-pp.mas_store_gfp
      0.55            -0.0        0.50            -0.0        0.52            +0.0        0.56        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.58            -0.0        0.54            -0.1        0.53            +0.0        0.58        perf-profile.self.cycles-pp.mas_prev_slot
      0.62            -0.0        0.58            -0.0        0.58            +0.0        0.64        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.17            -0.0        0.13            -0.0        0.15            -0.0        0.16 ±  3%  perf-profile.self.cycles-pp.do_mmap
      0.48            -0.0        0.44            -0.0        0.44            +0.0        0.48        perf-profile.self.cycles-pp.__mmap
      0.49            -0.0        0.45            -0.0        0.46            +0.0        0.50        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.35            -0.0        0.32            -0.0        0.32            +0.0        0.35        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.18            -0.0        0.15 ±  2%      -0.0        0.17            +0.0        0.19        perf-profile.self.cycles-pp.thp_get_unmapped_area_vmflags
      0.49            -0.0        0.46            -0.0        0.46            +0.0        0.50        perf-profile.self.cycles-pp.mas_next_slot
      0.42            -0.0        0.39            -0.0        0.39            +0.0        0.43        perf-profile.self.cycles-pp.__munmap
      0.48            -0.0        0.45            -0.0        0.45            +0.0        0.50        perf-profile.self.cycles-pp.perf_iterate_sb
      0.10            -0.0        0.07 ±  5%      -0.0        0.08            -0.0        0.09        perf-profile.self.cycles-pp.__get_unmapped_area
      0.40            -0.0        0.37            -0.0        0.37            +0.0        0.40        perf-profile.self.cycles-pp.mas_rev_awalk
      0.48            -0.0        0.45            -0.0        0.46            +0.0        0.50        perf-profile.self.cycles-pp.mas_walk
      0.31            -0.0        0.28            +0.0        0.31            +0.0        0.33        perf-profile.self.cycles-pp.kmem_cache_free
      0.37            -0.0        0.34            -0.0        0.34            +0.0        0.37        perf-profile.self.cycles-pp.__vm_munmap
      0.30            -0.0        0.28            -0.0        0.28            +0.0        0.31        perf-profile.self.cycles-pp.__vma_start_exclude_readers
      0.31            -0.0        0.29            -0.0        0.29            +0.0        0.32        perf-profile.self.cycles-pp.mas_wr_store_type
      0.36            -0.0        0.34            -0.0        0.34            +0.0        0.37        perf-profile.self.cycles-pp.perf_event_mmap
      0.37            -0.0        0.35            -0.0        0.34            +0.0        0.38        perf-profile.self.cycles-pp.mas_preallocate
      0.32            -0.0        0.30            -0.0        0.30            +0.0        0.33        perf-profile.self.cycles-pp.vma_merge_new_range
      0.68            -0.0        0.66            -0.0        0.66            +0.0        0.72        perf-profile.self.cycles-pp.mas_update_gap
      0.29            -0.0        0.27            -0.0        0.27            +0.0        0.30        perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.18            -0.0        0.16            -0.0        0.16 ±  3%      +0.0        0.19 ±  2%  perf-profile.self.cycles-pp.rcu_free_sheaf
      0.33            -0.0        0.31            -0.0        0.31            +0.0        0.34        perf-profile.self.cycles-pp.vm_area_alloc
      0.37            -0.0        0.35            -0.0        0.35            +0.0        0.39        perf-profile.self.cycles-pp.mas_find
      0.07            -0.0        0.05            -0.0        0.07 ±  6%      +0.0        0.07 ±  4%  perf-profile.self.cycles-pp.unlink_file_vma_batch_add
      0.38            -0.0        0.36            -0.0        0.36            +0.0        0.39        perf-profile.self.cycles-pp.mas_store_prealloc
      0.26            -0.0        0.24            -0.0        0.24            +0.0        0.27        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.25            -0.0        0.23 ±  2%      -0.0        0.23            +0.0        0.26        perf-profile.self.cycles-pp.up_read
      0.26            -0.0        0.24            -0.0        0.24            +0.0        0.26        perf-profile.self.cycles-pp.down_write_killable
      0.22 ±  2%      -0.0        0.20            -0.0        0.20 ±  3%      -0.0        0.22 ±  2%  perf-profile.self.cycles-pp.downgrade_write
      0.26            -0.0        0.25            -0.0        0.24            +0.0        0.27        perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.20 ±  2%      -0.0        0.19            -0.0        0.20            +0.0        0.22        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.18 ±  2%      -0.0        0.16 ±  2%      -0.0        0.16            +0.0        0.18 ±  3%  perf-profile.self.cycles-pp.mas_wr_walk_descend
      0.18 ±  2%      -0.0        0.16 ±  3%      -0.0        0.16            +0.0        0.18        perf-profile.self.cycles-pp.mas_empty_area_rev
      0.19 ±  2%      -0.0        0.18            -0.0        0.18            +0.0        0.20        perf-profile.self.cycles-pp.do_syscall_64
      0.50            -0.0        0.49            -0.0        0.48            +0.0        0.51        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.38            -0.0        0.37            -0.0        0.37            +0.0        0.41        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.17            -0.0        0.16            -0.0        0.16 ±  3%      +0.0        0.17        perf-profile.self.cycles-pp.tlb_finish_mmu
      0.17            -0.0        0.16            -0.0        0.16 ±  2%      +0.0        0.17        perf-profile.self.cycles-pp.__vma_start_write
      0.10            -0.0        0.09            -0.0        0.09            -0.0        0.10        perf-profile.self.cycles-pp.free_pgd_range
      0.07            -0.0        0.06            -0.0        0.06            +0.0        0.07        perf-profile.self.cycles-pp.mas_prev
      0.13            -0.0        0.12            -0.0        0.12            +0.0        0.13 ±  2%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.12            -0.0        0.11            -0.0        0.11 ±  2%      +0.0        0.12 ±  2%  perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.06            -0.0        0.05            -0.0        0.05            +0.0        0.06        perf-profile.self.cycles-pp.mmap_region
      0.18 ±  2%      -0.0        0.18 ±  2%      -0.0        0.17            +0.0        0.19        perf-profile.self.cycles-pp.tlb_gather_mmu
      0.14            -0.0        0.13 ±  2%      -0.0        0.13            +0.0        0.14        perf-profile.self.cycles-pp.__mmap_new_vma
      0.12            -0.0        0.12 ±  3%      +0.0        0.12            +0.0        0.13        perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.10            +0.0        0.10            -0.0        0.09            -0.0        0.10        perf-profile.self.cycles-pp.kfree
      0.07            +0.0        0.07            +0.0        0.07            +0.0        0.08        perf-profile.self.cycles-pp.testcase
      0.00            +0.0        0.00            +0.0        0.02 ±129%      +0.1        0.05        perf-profile.self.cycles-pp.unlink_anon_vmas
      0.22 ±  4%      +0.0        0.22 ±  5%      -0.0        0.19 ±  5%      +0.0        0.22 ±  4%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.12 ±  3%      +0.0        0.12 ±  3%      +0.0        0.12 ±  5%      +0.0        0.14 ±  3%  perf-profile.self.cycles-pp.perf_event_mmap_output
      0.43            +0.1        0.50            +0.1        0.50            -0.0        0.42        perf-profile.self.cycles-pp.kvfree_call_rcu
      0.29            +0.1        0.41            +0.1        0.38            +0.1        0.42        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
     65.33            +2.5       67.80            +2.4       67.70            -0.7       64.67        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath



