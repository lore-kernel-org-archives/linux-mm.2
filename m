Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80AC3CF258C
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 08:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C236B0024; Wed, 19 Nov 2025 03:33:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB57B6B0027; Wed, 19 Nov 2025 03:33:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E356B009E; Wed, 19 Nov 2025 03:33:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 991796B0024
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:33:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BC761403B0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:33:00 +0000 (UTC)
X-FDA: 84126691320.03.D3CF3D1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id D81551C0004
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:32:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TGVncszb;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf20.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763541177; a=rsa-sha256;
	cv=fail;
	b=le3bLjG41qd4s2gcK8oy/9wXQq+Ea+7x3faiTV5bCVmFP0+4kS6vDBHOJE7m9bWW1jvasN
	TAxc1f4u8HmKPaWvTo10DdcI7AjMktWvF2eNyxyXIE42v/Ua3RN1t9tS+m73kuB+CK8aC8
	lpxT6NIPfSXaT1CNvdpCP/ooBylSCY8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TGVncszb;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf20.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763541177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xPcee2QCr1oCBIANsWHuZhaw/QN27pWHUKVhZdMKXmo=;
	b=unW0EKCosv+Um9pjnlmmCUnKjSpTLdqOOghOLRWTPVPy46qMWZ/BgVsN+RxYKJsKdKmuf8
	tYjhS2QXb7mRIPZUXkU5EWUjL6Yiavu+wEytNEiR/ScvhfQSf/h+KcL4BJqMSUgPB+RsVD
	6GG47sBW/lkhaMcWHudP0CnhDtlvzQk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763541176; x=1795077176;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=uWTsh+9W6L4OKU8I5QFR6y4aNxBhzi7MR+Wf9d8bgFw=;
  b=TGVncszbqgeMYe0xX26aL9pD0U0qqfuwFobvsQ5yX4bJP9M5EWer3FJ+
   uHxyywYVZXgLFhU4OZrq/Lv4XY1pE/WM/6SRCqkHPP9QLysLgGBPDdE6O
   x2ldJ52Ew64OcBnqGFHMK/dnquGf6djML5DAEaHat75BrL1EhyVp652qq
   oA442QoHnUQ3xRf6zqnJshtMEGrSMwe3oq/aDVh5PXVgqsBqC7T+9EUJA
   9T1rDF2HaRelhwagQA4wxsivAQOu257yyMTX9XAYV8w2t2DjW0GbVJ7uO
   sZDHz/EYygDj7gLUOmkUdxAG4yy4DolYJTviE1irqSO4QoeXMxFM+0zMM
   w==;
X-CSE-ConnectionGUID: Od/xquBsTT+HrzXRePek5A==
X-CSE-MsgGUID: flAi9dxCQtGb1H0wULLVVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="65472949"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="65472949"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 00:32:54 -0800
X-CSE-ConnectionGUID: DwlFGXT5SIOcUnxO66DqQw==
X-CSE-MsgGUID: UqmeTotaQm+4Lu/nyrNVGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="195110912"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 00:32:54 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 00:32:53 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 19 Nov 2025 00:32:53 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.66) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 00:32:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UgJdAvbcIu1MwdcrywnUTr3YX0HFAzJrTNl5FSm8J2utP0QGOjeD3NIl6caYbroYaTmAXKWpCTlE9kpXcIaCXbX38Jin18LYtM787WJk8V4YbwAUaIYu0J7MAq5ktAqrx3v5k45bXWWlblNFRGiPg5WuaAaJ54AeaXPQeZ7apiHa5ELkod01V5mULtM1ccIIX7Dd3w3xQany4aFXjDaz0vrMEURG5iTJu1aTlM8OdI297K41iKwcTc84YxLkTsnsvHo0QI2VKNVOpcyIx65Ak1PTiEMaSUGPZCAaTGFHIGgtlEQK9v5LwWB3q0BCqfUEjLJBR1yoAk64gN0LMWfGNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPcee2QCr1oCBIANsWHuZhaw/QN27pWHUKVhZdMKXmo=;
 b=IEXZWGub2t/p7LXXcmfaoEQtvHXfNgxUeVS69sza5UaH1tNHvxM84N6GReVI2vjrtmW/ZivvJQ0HjYjDQFaI02/XLoqEvs9iPe41Dc3FT2uOnOvsUTROXV1BEX3eJNLrQCBw6a58Mw/4qBuySyDTZpEuPeEi36W3+ognllCjIu/VAEE0mGWeX0pZlgd1VASXf2fO3zyfKyreWPoidRKm5vrfRfRyPZEHbGH8Z5PA1PkCn6038C47TRx/w2Jv0cewatVZsKK9wJIXIqB7rE6XjuwmUDaLqBIW8exgkQ+A/I5ztxA0AHwwQVOkSGzayNHdQBigt7YIUAxI67AyCoKenw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS4PPFEE549A404.namprd11.prod.outlook.com (2603:10b6:f:fc02::60) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 08:32:46 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 08:32:46 +0000
Date: Wed, 19 Nov 2025 16:32:38 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [vbabka:b4/sheaves-for-all] [slab]  a7317bb8f3:
 BUG:kernel_NULL_pointer_dereference,address
Message-ID: <202511191644.dad64d88-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2P153CA0006.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::22) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS4PPFEE549A404:EE_
X-MS-Office365-Filtering-Correlation-Id: a4130482-fa8d-4384-db94-08de27463745
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?me9Tv7mIO9gAK8ZayY9HUE2nauUkZethpQFnQisbBaEEqnq0YZe2XYx8zLF/?=
 =?us-ascii?Q?dzAzt25KopCRr6Pv6K+YwEYNMO16GGvHwc4pp/IDyNHPpHSPI5RLFlIh7Wfk?=
 =?us-ascii?Q?L+kj4ei6aqRWGSkc3EHJCltx+PjS+tbgOKFB7jmXKc/+II05JnYejEAA3h3S?=
 =?us-ascii?Q?2RnlyNFsDxG7iD9naQaRYyBK74rxXK+q2I+wKcNCsoWgQm9Ke5O7hwYZ5gGc?=
 =?us-ascii?Q?tNUSMae8C6KRvXvyJjr4KANcdyK+oXlFqtzAh16EHtoPt+g2iYsrmm3pPcff?=
 =?us-ascii?Q?P+S3qlf0bh8bB7LF9Jn/1qvI5B1Cpv3lC4ttPHqrG1C8HS0JZ9CzfICDHBk9?=
 =?us-ascii?Q?Bebn79yOMlDbckSD8e5KT4krJmkZVZ2b/98CiIqtoU7zGxlD6pbFLRdUkE2Y?=
 =?us-ascii?Q?7VdNviIlBRP+na+LufN9qpLQaQhiGGQFxDPDIVhi0y9XvTLY8Fa4019vwbXY?=
 =?us-ascii?Q?EeSPG6E7bJN6zpTGCtXj750Mn5muSNq/t69elGUW0LCNIHmuqks1z3sCzPOO?=
 =?us-ascii?Q?p/jGuZNf4ECggqMdP1A8Sj74YlB7zNH5mUty+P41LuB+JmC45cmpK8iH4MXR?=
 =?us-ascii?Q?jSD1vEXoAP1dIgo6YAPf4BFi1sIWJLEMaQdRIRpxap17ZvPO/acm438yMXAQ?=
 =?us-ascii?Q?vofkKoeTBWVgo5fogjGoeqHEIYgMmGPgtF+Y4Ccf8MHew8BxtqDa7+eUbPa2?=
 =?us-ascii?Q?jKYRpaSERPtI016Rv0teyTi8S+BpUrEAO4QogGEu0PWk8xMTKzQusYTSbT3g?=
 =?us-ascii?Q?9mOroSIBRScu7qI9uH1CIuUfdyDSm3e/mBO/aXR6fEA+4SUNchae9uAMltSf?=
 =?us-ascii?Q?F+BGEeMv/4pCJKRN9iH2IauhHYK1yzMKuCu3Qvmz9yBXuurHCHGGYn6sqAvq?=
 =?us-ascii?Q?6MIzBbeMxO0jxPAJH5gIbbcIvML0p8LkDDLGwXXltRtnCC85C6jz64K2s+XK?=
 =?us-ascii?Q?BlqOFSb/AwP6TD4iQ1ECLBlOum2kaAamDzxJvrqtai95LUxLiZhbeY5dVUkW?=
 =?us-ascii?Q?PCDahhD2j65f7Rco56J32f+jVEzWRo2j5wHS9cyDEXyIXeb43Yr1pxNPl/VD?=
 =?us-ascii?Q?rwdS19ErrCq6RMt1OnlM+622MQ4l96WiTghYCRPnf3mmbJgejh/pl8bqOf+4?=
 =?us-ascii?Q?9OlPAo8E35Z1U7OKtPbXkF9EVYTW4STlOQRg5/rDsSJnNQKwWWkGj2PgEelb?=
 =?us-ascii?Q?psvH6UnW92zQxFnXY803cpPAoPqMvTuvoLxOzioSabxAowoKJrU0YV26acBp?=
 =?us-ascii?Q?B4fmngFpw56pC39773p5ETgp6XM9Z+ilv0Z/El/XfQc+u9fK4Gl4aGhFKqWv?=
 =?us-ascii?Q?+R7GsOiZx7gfpFV4V5glGTTGYELAYB3BcbzneGw3+VfePCSZi3rCMOViDjfg?=
 =?us-ascii?Q?gSj63Dlsjt0JSkKUGWZD8FEgysLIkdGQn5nR2X7Xf+08e/nrCNQUhZxHCMLA?=
 =?us-ascii?Q?c22lcmjEd1BicqH5jwXXi9xVtOoZPnKJub5/2D6o7d1tyGqikWrsBw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LsjEKua4cZxY62cIzf5EqzjVBVS6svQT7GRCQ8zBOIWEAZgrFZEY0jJ7Nkmo?=
 =?us-ascii?Q?e56AbnMaUNmw3ZVV7zHCGgHSWi0eU2BTNE81n4U3kH4ii0qJb/VbSvnj7J1c?=
 =?us-ascii?Q?Fi+Mt58M5ISSLTHnieR19PjyYyQDdOJH5phIf9yvvLEcgVTJp4OAEm+URE1s?=
 =?us-ascii?Q?icGmm8UIGpeFH349dQwQFxPfG6en4nYmumtDIcjFoWcabaQvZ/fPlkoT4FTU?=
 =?us-ascii?Q?4eZ0nBrogq9zop0JwWwNZkL7WTdj+Aoy6SXcGBDa9s0WM1g5lwz9kAvoccLw?=
 =?us-ascii?Q?Qm0j716M8Ei89iFqAEL/g0R9DadAviLqggC0s3MFEVHjfiQiBzaYynQqL7IA?=
 =?us-ascii?Q?GCQSlp2eSNIWUoI+QBQKwN6W6MyLbLrzHKZF74lGjripWf1pzhYSvl489vqT?=
 =?us-ascii?Q?ek+kHjPAL8opU1aTjeetIhHWSS3Om61obqc+udvCqGV3mXEVJvzwBt36tHIz?=
 =?us-ascii?Q?myUmZN0PVPvumelPV74U/fdGXuOQXkAl9ZflTSxStSwShBqy4OZTrjihGvrd?=
 =?us-ascii?Q?tktaRMRLwkR4Gb3MWEwIXQhY/Qb7jqTdJNtLeXeregAE1gxJGxH/IfIqOCZ6?=
 =?us-ascii?Q?fIb0QFNNTu4XnQXei6po3UYU2WZzllZkLzg8iQ3aLWiWIvq3YVDDiLqJrhAf?=
 =?us-ascii?Q?93FkLV8897aFd9XH5xQjfSVeY0vZYjxxI7qrOmQ6o171ojy7ux1SkMURZVMj?=
 =?us-ascii?Q?/Tj1MDDfUbht7jdexNxPRDhv+uLSXtxiFwa7P6Urrgwy22O81sT6iUPhrAkG?=
 =?us-ascii?Q?tXWYIVC1cmBTi/HtQmOISxbyzUSUMVQ7agcehWXfuQ0+Ql6bLlkOEnZaPJHA?=
 =?us-ascii?Q?uZtiMv8SoY2ZvdhCvTWVFKVKWaE5Tj8VG+tif+Bopn1q3SICrTn9nGwBqQNF?=
 =?us-ascii?Q?gX7PMlcLB8yr5/xfBjNkACEJbt+U1x/9wr4PceC1LzhVjTxQU0Ofz7FsbwkS?=
 =?us-ascii?Q?bRVucVEHcBkn4U9L4bwF0RQuPveuN6szMTMbjZPKJqTGJBaRLcvigLtHNbPz?=
 =?us-ascii?Q?xNWWxvRZCUUaNOGr8w1A/KGiFC6eFp0ZqMNp6K5v/uknzzo7wNecwg0Kbtv8?=
 =?us-ascii?Q?bdk5czs9cGqAs0e90hSFQdDGgdp+pzHK9Oagijtd6etOSx+V2vCGWFUBmwse?=
 =?us-ascii?Q?fAZhPM3gFZrwKf45pELzgbovN3rPFWSbaqigwLOYxBIZJAEnMe4Wbw9OrL1g?=
 =?us-ascii?Q?NN+Awt/t0AWtI/4CRobX9RTjlQXQs6JCJKZ/rezTy1Xc1sV5hqx7CfOA7s4f?=
 =?us-ascii?Q?BiaEbiR7QMSwKknlH/eZY3JULCVLjIY43KFFApASn3THjA+yePAO+4hD9oli?=
 =?us-ascii?Q?cxq4jN75giuZQxR2ir/Ok6ccLmr5NwxCZyabV0/McoxdI38QXiGjKBi3MhQk?=
 =?us-ascii?Q?acSC8hgHyHVw/O578KHw/At8d8QLHWO5XU+gU68e0/Geg0hozYUj9AqLOVoU?=
 =?us-ascii?Q?Ga5hMVoH6XK7xKPYAdVbU7vgYCLRKPaBwCgitATCTVI9Wcl4KHrZa0WgXN1A?=
 =?us-ascii?Q?zpW7IVcz8f4oMcg3gaco8R0MzUVRkmKwHc8LYVjT104GmRRH2YJgm4UM4M0j?=
 =?us-ascii?Q?NXbABJFIPTbZzVmGBZ7nPwpOfCAoBg3vHWIyBp/V+heVzELO6izFwwPC2yG/?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a4130482-fa8d-4384-db94-08de27463745
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 08:32:46.3348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7DSLKcX56dtWubCOWY2qI2EAFhL8xTs2dCA9b8HlGc7YSlsi/6tlgMUJd1L2HlcC54H9ib8nafRFwH7xT7mtww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFEE549A404
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D81551C0004
X-Stat-Signature: r9yf1qi8xsnqucr1xaok3xjudfkbmo7z
X-HE-Tag: 1763541175-324310
X-HE-Meta: U2FsdGVkX18ELjrL3rcHogNMTHZCtvRHp/MqgQAsGYtxTc03CBl8LCFI01tciwMLIPLVEq2LwEAGw0YFZP5Y51OrcuFEbZuNTxETCdZJLA3dvbnwgCi4HZWDc686aE2OCftNAyoHpzIQnDTm90hkOMrhleSM83CzoPEWGMEE1882Y0rWIzETMCWCILy2PAEVoAPlow8WZ2IwfA+O/AyFbGLs1CpokEo3n1ea6asUtj11dpWWYsGBr5ui9C6aAlO+R6iMVugU7ztYoHyrZuzY+lwFFJsQQB8kqt8bH0oM390SO3OJSz33hfCyRXusVt6XZpTdGlqpY3GKrCnzxDavR8aY9EKCFv6UNs8zGWFraUMgZiV8osUbyDQ6DM4DyqeVfCATuOhqXqqiJbv2zXzDa9pRmI3731kxm/sM18YRTVdhjc2sRhTH9DfwFwCX7qVnT+9lJOx19eechXKTt1tkGnxYPzY/l0MiMPXzcmWfefkQgeYY4OS81T/hyCJFX9vXg9oYMgM3Ehsy0ipZERWhMgKClckaCUQ5IcGrj3Fn4Ckb84fTy8rSJYn5M/kXoW5Dke18cHPPeBunXw9RNJ+1MByQ6pyVNSjEteWAswZgMhMgAbp7jyP7P6v85cez/sC8vQHVCB+6FSvkJUe74NpEzpFYv+i2bLiRav3rSlDJHWtV3K12M0B3UN5GPgJtxk6H3k4qMBhMiFSGVub7fRCnAyWt7WJxFiVQxs/ZBThRtUV1mChcLqn4fYBRdW/DrNlqm12m9EqiAeGusDyYQDH+R7CA14fiYgp+Xo/M/Bw7p99oV1Gef9Zpl8V7lXRdZUH4i2ok3QuUT5/KhHf+EJOy3JpXkynmjgcN1uLASOdoUipj+fljxLo7wojk/r5L4rktG1R2F48M4CzPmaZXeAPxpXwg2/y07gTgVyeh94CYs/x6/BybmSJn3amURBdqabcN7xhR0vcuUz24Bya9PFa
 Qel1lhSr
 1SVq/4G2dyZu4EQIBxi09XlHOPaywCBUhACoXNvJUlpmv4mx4m7p36z8JNDQweCkHxSgxm4A8L7Bpo5jdry5ZmwHPLrduiVtlXSqt+1qzfML9bxiLWZxSBUI/FsaTZzbKhzNheJ5RJFXDgiEEXQY9dxSN7OaxbrcVrCPDoA/Mi05lbhn8eBTNaqnxhFcnU5J5/q7AVSk2WcoOl9NaQHkIGNZGBl5UlxPTNE4H34Ce8riC1+EfZnF/KErbmG5EMsoltHLkact1Qt7gxi2sV5/Ptr/+i3daOiLDbNWOyiD7+PbmfGmv/uYInwuchTfgbkoJ2i1xRqBZXPRHxj6NHcXDTO0LypYZdz+xcJWjXMniRjfhJTzUZMqRBQ4a3Lv4m1PcMOkKYZrGLlNgMOigwiwSKTDGn2s3U32i0FxCB6j0T+QClZZQdhuAYPjYPgTSwkuhyjyqbMEaTMLTCe3QsrZWC2+MsRB5UWCoHVhF+XH8kcCYIgn5Miey2BKzaM2jmSw+X3xJ+cUA+cyg2MgIj/ieOwEduko4gT+Raw4Ri9jldFm+bwsZ8c0RabdzEx1r3MKtOlTS0wiOcmeXN545MZb6/3pIYaCxOGPANA9ZHFbCuwg10EqdPh3iYRN8Lqod6pC4i6bQpslXxepGZFYOXwPoX7gGfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address" on:

commit: a7317bb8f3c4bfb06e805a5b8273d0f6f7fb3dd7 ("slab: remove cpu (partial) slabs usage from allocation paths")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/sheaves-for-all

in testcase: boot

config: x86_64-rhel-9.4
compiler: gcc-14
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+---------------------------------------------+------------+------------+
|                                             | 5788d3ad0f | a7317bb8f3 |
+---------------------------------------------+------------+------------+
| boot_successes                              | 15         | 0          |
| boot_failures                               | 0          | 15         |
| BUG:kernel_NULL_pointer_dereference,address | 0          | 15         |
| Oops                                        | 0          | 15         |
| RIP:get_partial_node                        | 0          | 15         |
| Kernel_panic-not_syncing:Fatal_exception    | 0          | 15         |
+---------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202511191644.dad64d88-lkp@intel.com


[    0.200136][    T0] BUG: kernel NULL pointer dereference, address: 0000000000000020
[    0.200965][    T0] #PF: supervisor read access in kernel mode
[    0.201586][    T0] #PF: error_code(0x0000) - not-present page
[    0.202222][    T0] PGD 0 P4D 0
[    0.202577][    T0] Oops: Oops: 0000 [#1] SMP PTI
[    0.203085][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.18.0-rc3-00060-ga7317bb8f3c4 #1 VOLUNTARY
[    0.204159][    T0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    0.205286][    T0] RIP: 0010:get_partial_node (mm/slub.c:586 mm/slub.c:601 mm/slub.c:3575)
[    0.205916][    T0] Code: 00 00 00 0f 1f 44 00 00 41 8b 50 10 41 8b 70 30 49 8b 44 24 28 4d 8b 74 24 20 4c 01 ee 48 89 44 24 28 48 8b 5c 24 28 49 89 c7 <48> 8b 3e 49 33 b8 c0 00 00 00 48 0f ce 48 89 f9 66 89 c3 48 31 f1
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 0f                	add    %cl,(%rdi)
   4:	1f                   	(bad)
   5:	44 00 00             	add    %r8b,(%rax)
   8:	41 8b 50 10          	mov    0x10(%r8),%edx
   c:	41 8b 70 30          	mov    0x30(%r8),%esi
  10:	49 8b 44 24 28       	mov    0x28(%r12),%rax
  15:	4d 8b 74 24 20       	mov    0x20(%r12),%r14
  1a:	4c 01 ee             	add    %r13,%rsi
  1d:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  22:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  27:	49 89 c7             	mov    %rax,%r15
  2a:*	48 8b 3e             	mov    (%rsi),%rdi		<-- trapping instruction
  2d:	49 33 b8 c0 00 00 00 	xor    0xc0(%r8),%rdi
  34:	48 0f ce             	bswap  %rsi
  37:	48 89 f9             	mov    %rdi,%rcx
  3a:	66 89 c3             	mov    %ax,%bx
  3d:	48 31 f1             	xor    %rsi,%rcx

Code starting with the faulting instruction
===========================================
   0:	48 8b 3e             	mov    (%rsi),%rdi
   3:	49 33 b8 c0 00 00 00 	xor    0xc0(%r8),%rdi
   a:	48 0f ce             	bswap  %rsi
   d:	48 89 f9             	mov    %rdi,%rcx
  10:	66 89 c3             	mov    %ax,%bx
  13:	48 31 f1             	xor    %rsi,%rcx
[    0.207999][    T0] RSP: 0000:ffffffff84203cf0 EFLAGS: 00010002
[    0.208637][    T0] RAX: 0000000000200001 RBX: 0000000000200001 RCX: ffffffff82a9b66d
[    0.209498][    T0] RDX: 0000000000060010 RSI: 0000000000000020 RDI: ffff8b5640041000
[    0.210361][    T0] RBP: ffffffff84203d50 R08: ffffffff84f68980 R09: ffff8b5640041000
[    0.211194][    T0] R10: ffffffff83ff45c0 R11: ffff8b5640041000 R12: fffffc2a44001040
[    0.212049][    T0] R13: 0000000000000000 R14: ffff8b5640041080 R15: 0000000000200001
[    0.212927][    T0] FS:  0000000000000000(0000) GS:ffff8b5dda9f2000(0000) knlGS:0000000000000000
[    0.213908][    T0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.214593][    T0] CR2: 0000000000000020 CR3: 0000000581e24000 CR4: 00000000000000b0
[    0.215442][    T0] Call Trace:
[    0.215786][    T0]  <TASK>
[    0.216091][    T0]  ? pcpu_block_update (mm/percpu.c:631)
[    0.216589][    T0]  ? init_kmem_cache_nodes (mm/slub.c:7639)
[    0.217107][    T0]  ___slab_alloc (mm/slub.c:3663 (discriminator 1) mm/slub.c:4473 (discriminator 1))
[    0.217604][    T0]  ? pcpu_chunk_relocate (mm/percpu.c:248 mm/percpu.c:557)
[    0.218108][    T0]  ? pcpu_alloc_area (mm/percpu.c:1262)
[    0.218590][    T0]  ? init_kmem_cache_nodes (mm/slub.c:7639)
[    0.219144][    T0]  ? init_kmem_cache_nodes (mm/slub.c:7639)
[    0.219683][    T0]  kmem_cache_alloc_node_noprof (mm/slub.c:4934 (discriminator 1) mm/slub.c:4998 (discriminator 1))
[    0.220268][    T0]  init_kmem_cache_nodes (mm/slub.c:7639)
[    0.220774][    T0]  do_kmem_cache_create (mm/slub.c:8582 (discriminator 1))
[    0.221319][    T0]  create_boot_cache (mm/slab_common.c:677)
[    0.221831][    T0]  kmem_cache_init (mm/slub.c:8463)
[    0.222303][    T0]  mm_core_init (mm/mm_init.c:2716)
[    0.222761][    T0]  start_kernel (init/main.c:972)
[    0.223218][    T0]  x86_64_start_reservations (arch/x86/kernel/head64.c:310)
[    0.223768][    T0]  x86_64_start_kernel (??:?)
[    0.224247][    T0]  common_startup_64 (arch/x86/kernel/head_64.S:419)
[    0.224744][    T0]  </TASK>
[    0.225033][    T0] Modules linked in:
[    0.225420][    T0] CR2: 0000000000000020
[    0.225844][    T0] ---[ end trace 0000000000000000 ]---
[    0.226389][    T0] RIP: 0010:get_partial_node (mm/slub.c:586 mm/slub.c:601 mm/slub.c:3575)
[    0.226958][    T0] Code: 00 00 00 0f 1f 44 00 00 41 8b 50 10 41 8b 70 30 49 8b 44 24 28 4d 8b 74 24 20 4c 01 ee 48 89 44 24 28 48 8b 5c 24 28 49 89 c7 <48> 8b 3e 49 33 b8 c0 00 00 00 48 0f ce 48 89 f9 66 89 c3 48 31 f1
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 0f                	add    %cl,(%rdi)
   4:	1f                   	(bad)
   5:	44 00 00             	add    %r8b,(%rax)
   8:	41 8b 50 10          	mov    0x10(%r8),%edx
   c:	41 8b 70 30          	mov    0x30(%r8),%esi
  10:	49 8b 44 24 28       	mov    0x28(%r12),%rax
  15:	4d 8b 74 24 20       	mov    0x20(%r12),%r14
  1a:	4c 01 ee             	add    %r13,%rsi
  1d:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  22:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  27:	49 89 c7             	mov    %rax,%r15
  2a:*	48 8b 3e             	mov    (%rsi),%rdi		<-- trapping instruction
  2d:	49 33 b8 c0 00 00 00 	xor    0xc0(%r8),%rdi
  34:	48 0f ce             	bswap  %rsi
  37:	48 89 f9             	mov    %rdi,%rcx
  3a:	66 89 c3             	mov    %ax,%bx
  3d:	48 31 f1             	xor    %rsi,%rcx

Code starting with the faulting instruction
===========================================
   0:	48 8b 3e             	mov    (%rsi),%rdi
   3:	49 33 b8 c0 00 00 00 	xor    0xc0(%r8),%rdi
   a:	48 0f ce             	bswap  %rsi
   d:	48 89 f9             	mov    %rdi,%rcx
  10:	66 89 c3             	mov    %ax,%bx
  13:	48 31 f1             	xor    %rsi,%rcx


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251119/202511191644.dad64d88-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


