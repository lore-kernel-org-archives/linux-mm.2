Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5C0FF887E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 02:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C2C6B0088; Wed, 29 Apr 2026 22:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD9F6B008A; Wed, 29 Apr 2026 22:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6A56B008C; Wed, 29 Apr 2026 22:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB9466B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:34:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79D6212021B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:34:41 +0000 (UTC)
X-FDA: 84713653962.10.61C0146
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5073B1C0008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:34:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fiazTicM;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf20.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777516478; a=rsa-sha256;
	cv=fail;
	b=wwSr2eYkpbrLYMwdsQWSNRIv3q90r04VDtfBiU4fGHYxuwc2eXiNAv8Gv5Xt8FrEh7f5NW
	A5fJvCVB4uzSEs35cGnCx77WJolI1YlhgNG1Ll72tZiEJYSlarmsEsomEWa21R3MhlwxQk
	JhsctrwheT4SxDMJjHgLk2nVqHJ6aww=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fiazTicM;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf20.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777516478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zVtTjTUW+nLhEJHCZCHw6NSYigxr914622q8EmdiefE=;
	b=7+D8BgP8TIpJrv7/bBAMHrJqj1XKBsDQmPqZNIFiM6Q7E+XGtMu+EXLNTfnwRYgWa5cCvU
	O/hhoIeKG8cjuvPPwClSv3Q48i7/MwRTETHT4NUZahwH0VEDeOZXnPpQ+7p4WZU5+8JF41
	gflXhY4y7J4BWz3fbs4Wy6n6R4APMak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777516477; x=1809052477;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UWxzAQsYC4ZpCK5DWOqr96/qPqTzYVNVXDhCXXBm3VE=;
  b=fiazTicMBQjE1K/OFhEnbv04b/ZAIkNhO7HVSJ9VXBL5qihL5XoFTkeU
   M50cfiHyLP6fv8ti44ys6mEt+iJZ03nFyVGNPJLFC7jzs6NuN0P1lX3lc
   bmUCciDvcDJFpCh4nQEwNSq/A3y/y4TS5Hfdcr0Rc4NYn/Lc9NE1UVaC1
   M9WRUMH9dgEzslh9bKACUMdKl/p6W7EfHmF8cxrj0kV9btUQC5sCbKONp
   yA+4TQxhsMfBEYovcANAa6/PBl0R4VRZp+okW/eQEzupMJvfAUDid13B0
   LDzt+cX3TxnY+wZLALB8OwGVEGaT31/92t+RYfC9FdkWZJFMmNgVcytpr
   Q==;
X-CSE-ConnectionGUID: IryCWR02QcK3GlJ711JqGA==
X-CSE-MsgGUID: CfrJ/FwBSh2B2M5XL1LlQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89552407"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="89552407"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 19:34:35 -0700
X-CSE-ConnectionGUID: p5wfFwY5Qdu/Lh8HRpMqHw==
X-CSE-MsgGUID: UoWrtCXrSsujDJtkrWlhsw==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 19:34:34 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 29 Apr 2026 19:34:34 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 29 Apr 2026 19:34:34 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.13) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 29 Apr 2026 19:34:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m7o5Uu1z5pK4FpvSGuHFDia3yMdJLxsbilIpjslQcGFVBCgzSJ+KCENCxg6GyNRgW37D0XhVXBAdRld3xWUyhDPI1X7t7U2u0k53o0MRyftRzcBIjBcFcGApoMEDWHAq85PHUqTXzNz8Jz8sJiI1H3YoRmCokGtkjM3jG6A1y9vRQoN2e/407X96UbTcISQ78q6pY/dMvyLiqPC9X5jte9g1zw7QfSKTHb6iMrmcpqC0DKvTxhwl7H8vfuCEWdky9RyusCUbYbsE6+zROLi2mpbkyyDyMTP+h8Of+KgY7kO4njPLUAvrGQYPmozw4J2SiE0ryJIyqHHLYDka5K8bXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVtTjTUW+nLhEJHCZCHw6NSYigxr914622q8EmdiefE=;
 b=LrUArHUrQrjQ9/uWbb3IpVcilH75CN4wfwz8YT5k8PGPkA9Yziv7ZWlTRM+SL7KYoEeeW0eaORemICrZpLj+kaICMde2xfeuJnbEVENhNXJ7yLyRTBXxkHOY2fn8xA3kS3ucOmgAssqxbllbUvlmdFlGF7+o0Gj87/caW8cPbI9WneV3Mi056DUhxVeBRL8cHwKtrdo2HQsOVBfSnLbp4JiWMKcNYP2Z4A7E1rXCWvQh4DRr7teNoVrGl5OWVzDFiToLahc+sxmDkulE+joDHLIdlJbFQ7nacbk5BsnzuU3xJexCfK5cxuRgwH0ax43kGFMfsY0fEnjp8LNeUdqSiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DM6PR11MB4529.namprd11.prod.outlook.com (2603:10b6:5:2ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Thu, 30 Apr
 2026 02:34:31 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9870.016; Thu, 30 Apr 2026
 02:34:31 +0000
Date: Wed, 29 Apr 2026 19:34:28 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Andi Shyti <andi.shyti@kernel.org>
CC: <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
Message-ID: <afK/tPgQsuk37pYF@gsse-cloud1.jf.intel.com>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
 <20260423055656.1696379-2-matthew.brost@intel.com>
 <afCCCuLglfi70Tgq@zenone.zhora.eu>
 <afCGGC6MUi1m-Ej5@zenone.zhora.eu>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <afCGGC6MUi1m-Ej5@zenone.zhora.eu>
X-ClientProxiedBy: MW3PR06CA0013.namprd06.prod.outlook.com
 (2603:10b6:303:2a::18) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DM6PR11MB4529:EE_
X-MS-Office365-Filtering-Correlation-Id: 82c614bc-36cc-44cd-5e86-08dea6610269
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: Mfi7J4L5CIHVtoZbrtQBJyNLqITG5XkabLhyEWHj7UX8CZuAfnIaUPTsGpuaHcwVQwXnJiGFlDcd+5+MiE51tzl9gtdKsCCPSpiAcNVtgRMmq+bYDbPLr3CGsta7Naxw9QeScYHzoiXOofFnSgLB/eOEfzUrYdo+Us3x3OyjYQyBZ29jY6PVf422PWAKndu2WSob3I08UITde7CwmyFKuyg4CkBdSVYwuf187BUnqfEnYcP560VY98pgVNC/HlBd2MBQ9FHiJ8F//rplYT/ijJtjSKxd8MgCvRAv5DqdqBAoENp8JMAxEr540EOFymQsfOMKSmelQA5d5sI5+jW0uCVrirfgVzpGsX8uEQgZqLjF+IBZjD3YGd9F/kbGO34LZqIvk9nRx9MHVc82kOzNuBer55NlnO+h3HU32BJq0fVOsXvFNzrnr18PPtyYXTym2Xw7C09IZZCXZyhZUhc3jCVz+wLDXgFnsJd9ITjjJI458o7z0+K16ao36lcMtPLmYjMBO+uLddmk5xnjkVvfUYWo6h717loEM4CZkJEuCsW5r71rzdyeaBGB185Dk7HWOUi8nY/9H86AtNacwIy/OizmtjRwepHCMShU7AIbHX4gH9bb8C/2/zWHdIfAV5SJq2eI1YYTCpFN7+XkkmKKvW7AoAVXl3ZsiL4aOupkgmUfUAiSqiHMG61u3j7yyNBAYjXlIvc/laAfUxkdYjzqHxJaOX/UxuZE6eKj0GrS/VQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?keS3AXIJf14iPfqKXJ3mE0BX3pvzhVwKuMv4X+c1AMBAMwpbnzYcOjHt/krn?=
 =?us-ascii?Q?DVrTn6z6bmuKHoRQi5+39jCbowGxX9gKI6l1IIM2naneHfbRnlwjyNcIoYG9?=
 =?us-ascii?Q?5WTpHamjZHLxyDkTJeuOQlaspNM/FQzIPS0gB64XlScMEjKgKzxcbHQ1T8vn?=
 =?us-ascii?Q?jWOnbG8t8YId12EA1PniALqkexrxp+i7gzdQj/JeiekjxdXwWbMrW6OfA0Cq?=
 =?us-ascii?Q?XJHG+jmA2tNpE1kt4rdz3AO5qKhzfNshj50hDSyKI3N+uyqqepB+LfcUq0Qm?=
 =?us-ascii?Q?eawsZPXLymMuYbES3PQ4YLGvSUJe4SVuWHnAojq09NmL8uV9qrzoQYQ4f1iD?=
 =?us-ascii?Q?6kP3+Ift93frk0j6ltRvhdrVwc1WZh2FaKBIx/VM4c0pYFo4ZThQtZZj/yrr?=
 =?us-ascii?Q?taqjLzO+sAmDum36cAHHVqwhX9I9t5KHwyKD3uJQcPFo49SCLXcUcD0f+T5F?=
 =?us-ascii?Q?F9ej5NcyEqrAOMnRFuFL8VXqJvzzL6Fxz5dKmWXlVxdWPKbN+gLWyLi21DQV?=
 =?us-ascii?Q?AXpSV6hC2ZUwSc5o7HCG33ZnWKE58+HxvbNxuME19Cwtuc9q4z8Qpe7ayZ+K?=
 =?us-ascii?Q?FatiedF9sHPWrwMygWIZyla4oqih//66ALDrK44q5Lq97qXa8YrUy07yWLb/?=
 =?us-ascii?Q?XZoZhKdPjTDnc3j1gWzHFWKsCGEY6jGo09zKVdzc5C2jyXYjIGitJRMDFrcY?=
 =?us-ascii?Q?dDYC1ulO0+j+T4nHhaMSiwu5daZyH11B9DqmzfLpalzq5f3rzcQEiNSdHdbB?=
 =?us-ascii?Q?3ZJO8PehF4k+2ZODPrxpcfF3ZelkrgeTvZgH/TCngSFPNX7pq8Kc9cgjONo9?=
 =?us-ascii?Q?8IN/ysOoP1zEUBwpIpvlzhgiy4eR/Kg4s/s9O8zifyNhVW3H+zIS5sk4Ex3j?=
 =?us-ascii?Q?azkwG5yIirHPaIAw3iwBHWqMe5Sg5sj7EeUyUaKNXEf3jF7h2F8Vzb79hnT8?=
 =?us-ascii?Q?LSuqs++Ju7+VT0pFgs+vL+dldNAN4ffjCC9RwuGOzpb5zZKI050UVvXxhNTp?=
 =?us-ascii?Q?4J3/Gk1ZzUAF0QFvomFdcguMWCTcQtdbibp0Z8YcD226ycqRVOWQmuZ5Snjj?=
 =?us-ascii?Q?CPgYJ68k2o//Ocuj2Nh9mM4IDFYhz+byxY2B2Ai1F9zQvFp072Nk9XctuXSU?=
 =?us-ascii?Q?j8rmsOWjENQcNWqYvchVg4xEIeQNbGydYxgroAOhPqXPTpaaWoBw7y3nqdSX?=
 =?us-ascii?Q?opirql0EnHNVJzsEahlft7TbUhXdYUO5DXQhvE5ibNqyUb5VzWF7pIywiz1C?=
 =?us-ascii?Q?IDoGb7eaOlndjQAzboNzIcADwMUVcoSCItiym5CtUuKN8xQTWnrsi1rlljCs?=
 =?us-ascii?Q?Zj+HeJRRruP7WrCq/h0O+D4pC7v1N3L0NjA6yplCTTad1P2AYTjlzNBjK/y5?=
 =?us-ascii?Q?OLpTbBQ5GraaLfkJw7gSVdynsist8und8L4v8SwJwFgOmlFTlhPkvbyOGvMk?=
 =?us-ascii?Q?kOuXzOJ+jnAhn/kkEi6binLXewmufzq7i1jvCoLTsjf4vzJOibsoUF/BAqJR?=
 =?us-ascii?Q?PsuHK666K6UtXY66tJ4BEZGVf2Mt29iHrDGt+OUBbej3gTWy3aSGG0JZ1kB9?=
 =?us-ascii?Q?IilTsV9pmichODmLZdVt1G7QnCgtI1O2ztbGC9aE0PIJfSmOFBsF4Fxi5etY?=
 =?us-ascii?Q?lCKJeHQ1FR0EJiPuJ/jXNgzG6zNICxvz3VeIH2vx9dfC77jBjtZz8PFSppgx?=
 =?us-ascii?Q?uQJNXQQTF9BzbkIc+y/ZM0g5HJ+Xc+9gtoQgfDMGp956xIYKrJ5idUyqBzwk?=
 =?us-ascii?Q?3RJ3jg3FKCi1RsyjNmPKMx6Co1dLewA=3D?=
X-Exchange-RoutingPolicyChecked: dey0ER5DENG59xbFH0nhBtbR4MsRNzkOmgYOzKs3nbjAOMoV+lCa4xoJaSFB2FU/ygGrLCXydQt4jNqUGmgk6Xe+N6DZbqH//BBLrIbxhxdGwwuBIVg2nTlTpZxQyEfwhUwKlT44LUVBETwayF6SFGRmRH2RNMHiiMtYC1CTgHn9miG3xUH0Igv+B8p2S+T2VqckwrGtc4RDZaODZgP3Cw827+ufk47g1rnALeGOmBMgW7GGCqtHpRIUMF/C16lmemyDwbyI9Zyx+no20o2wbA/xKjy7yGxPsfINGbM5N06QxxPy7F5eqxPxjWMppt7mOVQP1CLhFF/nYHSB8RGcaQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c614bc-36cc-44cd-5e86-08dea6610269
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 02:34:31.6876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1XzN5JBA4xeu8LJMueKUrjgKUZNJUpCEA+Pfir0DSQz1LBt6yP15yyl1eTu5wF0OTeyqY8t7i7lCVGkKObmwJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4529
X-OriginatorOrg: intel.com
X-Stat-Signature: n7ojzeo9g6j9j6an9s5krtihguygc3ih
X-Rspam-User: 
X-Rspamd-Queue-Id: 5073B1C0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777516476-434952
X-HE-Meta: U2FsdGVkX1+aqTv8DHF/c60f6IZHsRbN1ArnJ3NmaLrq4x1S+v3cVTRF6VtKxChSc+F/gOMUFQX9GVMaiMUG90zp+AJo+eJU77qUue0aK6n/P45qxeJfscwwCUKlcVvXdtAP2O6y0Kb5JvYr4vfZDhUNPFMMP0T8E882wVhPb4OrqCuoOKpwuohnbNFn+C7KXpeplJtvGLvpd3o2Fi2vHZ7gjKv86UmLC2/pSMAlBNRVpyo2FcXZZyiwKtHLqwng4gNHA2PuAeY/Phu3GTE58I1PuJKJ5X644qcHyTOHhEcmuz6nIpoPkd57hOi43PQzVINz5XAXdfZdNBDnF1UuYp+y/U17pDzAhmUMS8xt0DDcP24jaOcyAQ4ZUzInbpd8NL6PTyHO6P2tFEt8BaQwBG2bNsxfQb60GtzZymItMG62AnXBVYhkuCocpkxL+YeeP7rLxLEEi9G/b4Zgv1yqfinuKob0yFCBu8V2PmghJnGr9i4EgJhGcvpeIjG2gZlZ3tvmqD+bKfjLg6+fsZ3LdvLO9mvkGchgC2QawaMsMHz6CqftdQPoUL6zrtVegzb3ZqpDpzEndt0wuk77Ra2NFBxMTYnffVCjyDLgEtQQUgl7X1seTmXq2Ybw+jiBMSq4yi8cPR+2orAsz7fWz66eNSrSYj9xDslKcBGbTRLLTNbNUUeh9E17Z8uK46eS78Vnjep636NS1tTLTTnpekO1/MCafkZ08fYft1IHQuNdotPQs1JbtStUsCrEDs8beo6PgxjhSNMxUWQZVbYGwDbJLuwf6JZu1469zwy/IanE0O5I0XwG6LGCeOGd8aRerPLmlKQx847Q+zFxj5KJL1DXHOL968uxy49VzdgRIrrWnNzVTFXVuYNEyHwyTLc6SjEUjcOdij9OqohCoC6a9140uyLeqDzcYt2FcPg9neH0qNWAZXPFA7bTCTzx4GArqYdYLXJVlFxe1SLeasnTNAZ
 B1Jh9mE6
 2o87CNlfZT4/BYVbZ87RXRKOJr3jy9HFwzFVTnc3hnmJ3vDRYrrZCEvpizyH4T4E5tivtzqnbHyA2eFO0ohVg0btlafCbqIAvb946rIs1u7cpCHlfrfaDR+3A9teHm70QxmtxcdXIZc8baJG08bfKKY5JK1LM+TqFJ8FKi/ZGWgKnG5xzB8ItKKNdmVHh4flhJ2sS2HJBeX3jiCh08k3n7+nTwiWptrV92qOkfJu/I//qdWU5Gkw62xgunTSuWJTWPKYkqQR3bCzvEhOlNa1NSnphK5er21+aLYFTPLiVmLd31kvwcK0mVEbLXI++1lXcDhtVG3KLdXyIsKUpjJJiAknSfD5HsFTrD/UDedywGB3AzRs1xxAB/qQEiD01iJWdjtOTykr5vi0ORHacNk9x2OcDB7XewyQgX6UmUS0h9qKan/TtdZztKljkanuLokRw+idP0csOerFa0xjHAHTejGEmen3Gm9I1NmBuEt6+uo7eK2rz65GznroP42I7xR1cOvigKPF4EntaGiR/mIpDzA2Y6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 12:05:13PM +0200, Andi Shyti wrote:
> > > +	if (zone_page_state(zone, NR_FREE_PAGES) > high_wmark_pages(zone) * 2)
> > > +		return true;
> > > +
> > > +	return false;
> 
> P.S.: If you want, this can also be written:
> 
> 	return (zone_page_state(zone, NR_FREE_PAGES) > high_wmark_pages(zone) * 2);
> 

Indeed.

Matt

> > > +}

