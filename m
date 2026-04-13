Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A41AF531DE
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 23:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9B86B0088; Mon, 13 Apr 2026 19:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA446B008A; Mon, 13 Apr 2026 19:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471D76B0092; Mon, 13 Apr 2026 19:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3532A6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:31:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CDB1F140223
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:31:11 +0000 (UTC)
X-FDA: 84655130742.30.237981E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf06.hostedemail.com (Postfix) with ESMTP id 32526180015
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:31:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="D/DLDXzM";
	spf=pass (imf06.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776123068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H47J3OKeHp8EBlS+nABi7RWlYGUdc2DzDLLCzWB45BU=;
	b=gfleHMqfohvvlYdYJlgN0Hxr58wfI7nVGXjMS6kM0MwSSq2bbXRuTi43fMGzIZeU46Cn4U
	Qg8fAjBdd9yROsVJzTGgMeYTn8vZedBo1GwMQsch4CD+pRv88gdf/8bw+5FrVplnrDA4Pl
	6b6iWVMjC+xjzHckU0/77XPQQxgwOSA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="D/DLDXzM";
	spf=pass (imf06.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776123068; a=rsa-sha256;
	cv=fail;
	b=0YmRbUxDBlCzPmpDN984qQkcNvt1PGs6d/beRX3ejxb8R/Z4bFax9j0S0DR5XE0L/OVDiB
	RPIoLkWsVerhBulSjpdzefhr/f1KMJ1Zhwst5SVbs2KVCUarS9LgOi84Zle+0mXM+cBGyh
	mvGnOQE1WFAckAH8Ifx03xNMdYp5h+M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776123067; x=1807659067;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZHsMTa42Ka24FC+UW2v/cT9wjNZ7zRG6eoWobM8onf4=;
  b=D/DLDXzM4idiJGNaOju19zJgYdYHiudhBVZRHMOqAmG6G7Q03Sy7M8BM
   xL3OXpjMmG3yO61NfRIi3yC58jp11NbkWVPdCZRWDMpQuOkR3EEHornpU
   QAix5wGMSB5sZvH9ubCqrsVOfcTAngciJYwu523icXP8f52js/Zj/27px
   Oq3ArKxTKjEp25oVgVfkjW1wDxA7qZN/1gRNsdE+AwITJhej+XOyOMp9B
   4yy9CHsfxvfcSHVTWY5sbApO1RHik6ao40+23bPV4NpLOjIdxeFpZ1r0t
   TiGYhbq16OFbvUaUZPMGeAb+VSHh3p9bBE/iUD9mEaLU+TNpu8uo6t3b5
   Q==;
X-CSE-ConnectionGUID: a4cV5ZIITFi7qU7Qmdb6Tg==
X-CSE-MsgGUID: 2tjFcxdaS6CbyKtNAiw6hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11758"; a="80661816"
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="80661816"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 16:31:05 -0700
X-CSE-ConnectionGUID: JlRLdH+JT++yBWG+icvM7Q==
X-CSE-MsgGUID: 59Fd8kiFQ5yzsPD4sKkaCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="233955524"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 16:31:05 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 16:31:04 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 13 Apr 2026 16:31:04 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.24) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 16:31:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NiqYTtynCrmVlqlUHSwERstu/Y6p2Gfkw/ghwIO/WTwBjmvMmwb2tLoNj8ICL0fKuA0xDZiDgj44EP1gTaFDHqHHOd0UgcPhyEewzpKmi3mqQdlm6FvjH/HO+O1BRi5y/dYxAjWaGBAstk8PZcTVYRud1zpv4HonCeGouTxZLTOAy6m4CJ2oaq8tiC90Tlmz7PlYse9XQPHR1aL+jyZqHxzrduvBqbGQbXnIZ/vh0DUwdwgW+s9GmgKVQJTKT5RYEs0Qserh5d6InDQmh+DZT0GV9KMNHZAcI4V5WM9BB+8btlqI4RyOQvxLI2akc1VdgMm7jGePFn9bJneliC0K0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H47J3OKeHp8EBlS+nABi7RWlYGUdc2DzDLLCzWB45BU=;
 b=Kaa0TWP2Nd/CCYe7kWMDn/TQwvcvaq3qkDzxfPdQi34Sanpq+XYcvGbrGqeVZf+zvdGOw9La5pvu3q9E3Qhd/eCDMAxbTNPxuXuJzkh8N6KPSNTTxOL9BeJirrGWz2MP5w6bul+dwOZufraRmx1ImkauNVwmny//TnEEqlLr4l0SQO/a/3T6oARm7PoFvMYJwc99RqWNBVaQWdRybOSzFFenLyOD8TwMrHW+RquKaGJ2iMA9p8kq2xdThRxi8CEOl0dMyOpxsv1olj52cOrWwQRIbbtV77egzWmP2QSkCT0vidfCMkC5U/YaK32agwZB1xbSFrmByqWrxyjD1NcUzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by CH3PR11MB8658.namprd11.prod.outlook.com (2603:10b6:610:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 23:31:00 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9818.017; Mon, 13 Apr 2026
 23:31:00 +0000
Date: Mon, 13 Apr 2026 16:30:57 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Sunny Patel <nueralspacetech@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/migrate_device: fix double unlock and remove dead code
Message-ID: <ad18sckPDwMDUtIo@gsse-cloud1.jf.intel.com>
References: <20260413130927.13263-1-nueralspacetech@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260413130927.13263-1-nueralspacetech@gmail.com>
X-ClientProxiedBy: MW4PR04CA0055.namprd04.prod.outlook.com
 (2603:10b6:303:6a::30) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|CH3PR11MB8658:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f6ca55d-6cb0-4b56-bce9-08de99b4b8cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: mWFNrWA/pbQL2nynd469OEekCgn+N2tSyFl0ejVWlr72cnpPtTyFg6qt2pHjCgClIj1NshSfZ9RMxb6oXPIbITwV+x5k+LS9J/1fqvft+qduSMQOhs3u9QSwzOfISE+RedqmC3cPKoT7fnnRte/OTZUXgBrp1lodL1L3oeiihOecFqkPZCHnURGF4F/zUbFJDNwEdqDMorOd7RqcbhVBbJ754sOQgCcR/q8O1ffybixSP7JedZgjK9AfnWOMn3F33ppoQhKuO+T7CMOR8knHJ5ygpa4EnzI+PyxeFsLd2MojvIt/uVkMGyBOGIW5e/ZpIe7HuZGr8xhvK9TwcaPWbbYPq1v9AqxQwSuG/aVZABOjPYoL+jIQTDqNrcb8Gzk1L0Emb/nifpu/eGtUAIviAg26FTMY7ow+AMSy2JOSG8Q1YktEwWj09rx6xps5KYUkRXk3NOiKdF0PVER6H/f4zk5II9SBv59lspqlFTBZgETy7iPpqUthYvjLU+fzxwiVI7TWcwhaVgaOfxPTLuMB+PE90uEQsD93x9twTFY3XLCgHH4pek2oHMJiT202c/gaa/CWXdKSnwS/uOil9PBzJcAyj8pmvez6KNWenDHBpYDjLW4KfdPBMs8IQtkw2NVuIEuTE+OKU34LR82o5lFwsrHZjO9a3EO+XfzKxrkF0+lsk605AkNmpNeMVPlhV/VQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H0xPV98Hj5HVoWwkM9vvcZQIFY3cI8zRbunqxsOIN/IdKZjYX6mKmaH9LE/j?=
 =?us-ascii?Q?9x3sDUp2OJ7NGV17YTo0NOJjlOMOAdu2LHEunq44f8lhb50aEmJ1MlEFRutU?=
 =?us-ascii?Q?TGpqPUOghDwFU+oxlpfh4Ql7SxiUSCDo8exw25oDdc4KS3s5PZfILii4OiNC?=
 =?us-ascii?Q?TocjrQU1M1AtjZScQ1IZ5DLp/i2ihyUxKd7DIeO0ROLVJE/r+r6QuGp7VMYX?=
 =?us-ascii?Q?w3uAo6rFMp7CsNjUIzCYvkdCXhT8f0PjnQtDpOXesJZKwmL9jEdlPvVPKPY0?=
 =?us-ascii?Q?nScB/6xdVsVNFqwJBNAxsFKRP/Jj9OeMu20xAxpbVX9MA9r78Fj41hW/8pvN?=
 =?us-ascii?Q?R+lV05gVXqWKaLRSEHiYOjZH3nbBbr2bCeOGDn9c9buldSKREnSwlCJWH3RP?=
 =?us-ascii?Q?Bfs4FozfBDiZS44l+2JitKy5E/3ZXuttbJw5dScwz2wmqtfTnENpta/b0cub?=
 =?us-ascii?Q?BJ67wnICbv94k2ihf+NXZy2DGxcJDueKmM3drH84BTkfQt+Itp9avc5T+X2I?=
 =?us-ascii?Q?xN00F3+OTou+badXHqm3UA2Ms0owbIAC83JlGMZJMbI4aWiUOEubYkq9SGxv?=
 =?us-ascii?Q?NW/7MOvK6l+6GKtOzipj2WoAyGr2wBJmeinl6QtsOxkkwyHHwQUk4I97rE21?=
 =?us-ascii?Q?/PI3ZMLNoFOlQ5RYGi3JrA9hAE00s+t1TS4hqU8bB0ajNWae1SjZ4glfmngd?=
 =?us-ascii?Q?Mo3naRDiMIlsiOQ7JEZqFtHVgNONlFl0O9FTHAJxGH//94SY0g5LFvcHY//a?=
 =?us-ascii?Q?reS9OY7NjTB2Tw8+lhwT3oKHwsYaRAhY4MGyl/iooy20lTmg1ZfGKU0bAzW1?=
 =?us-ascii?Q?UBgpg8JCY1y6cbCji9t8rYdAjBnFhA9v+j3Zpud8r2HeanFwVs23KSQWbMcL?=
 =?us-ascii?Q?MXQZsA0hkWXOeUGGwfv5tui6XtGaOeP4cS362WMC1dYazdq3IHlnD7JbQwQl?=
 =?us-ascii?Q?xWiFwqM4IzRJs/OvlT/6+wqvZsORAA9dt1y4iIY1q3iLqz50Hf1wriFXeWCr?=
 =?us-ascii?Q?gdDMIwnJA+N8uERgyg44B/D7UsRotHQPsxL48fWFH/hO6T4JUZGDo57RcML2?=
 =?us-ascii?Q?hIS2Vr3vhn8uGIg+GTp5yIkhYbwcKccMhQtPAb/pHpEPYm1p/qa2memJScb9?=
 =?us-ascii?Q?aJd0ALsJ4L6ViuZFGAvfCL06gseW3wwP6WrPwQykSmKFpXO83XrCQ1xLerii?=
 =?us-ascii?Q?TC6YOJ3dB0c3S2TQNtH7rAE082k4fNmOFy1mIDVwuI9vj8P42C2GS/nhkub1?=
 =?us-ascii?Q?XsSMs15YwfxY4cLb8Kg0zjyzH5k3dYxw3WNFjAVhWgaLms5b6J/nJ/392sgg?=
 =?us-ascii?Q?7f9aZrBMsIecJXc6yH3lQEn4cjKnYT5sC9/Vpwbl+HN1WKNT7lXIfbMhErgX?=
 =?us-ascii?Q?mmYHhJrMsJCJr3tmnLzmpvaS2YN7BD7SqsVXyTRYr0XDTwkR56EReYPBCCOo?=
 =?us-ascii?Q?kAAI0tz+Qp3PDANz6/83Gtfa5ZTCpsJYLvAuLJXCxOGApZJceikl+zuc7/bY?=
 =?us-ascii?Q?4ZUjP0Ic6j7AwVlAqjp+MBVjhG4lIbt7eXltd0n5z5CieyTydKNiTyGGH53s?=
 =?us-ascii?Q?qrgRdkvOGGzbQSihkgrdwDrVf5m3v2ODCjd0Mu1NhFZgQJ62wwksY+ZQAErp?=
 =?us-ascii?Q?3tQ0i6hFaomTNhhnnyVN8o/Xu2hw4C9SVzObmCmGzR9JRZ/MA0ePBmldLYeR?=
 =?us-ascii?Q?zYuxxMYU0tQdCsrdGPoz33Z8vDAOqmx0fFoGd3tqZjwxEJgmnrQdGFTPNwJf?=
 =?us-ascii?Q?yqdn/5OKZT/BEe1RlxKNBic3rcyApRw=3D?=
X-Exchange-RoutingPolicyChecked: U1v233Wa/0CJ4+wqXpPxY4/GxzF79xaBvsGgFGmCWx0/RYSB0MeJxRBoztR6k5hxqxhF9R1uDf5vD4ADQu8ulnBQe+HAo8AzTJNzwnVujFr5YV7dRfWeirbjA47uQVrGjjvxV4gxxPnppTUPHcvQei699IDlQmCxijQqEwz3Zz55EIKnueTwJQpkXH0avgvarZj0ZFy26QsWC3EbhiFC+E8s4D1X/JBlV1cuwWMBFxbZpSVpVER5HztGQHRBKk/sdtG7S991N1xy5zzTMie5Zg1F492uhseFb0/rfN3OqwWrtC9wkz7vHD6x0+kjGl8i+8rDpuY1XccM5Lqo1KdjtA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f6ca55d-6cb0-4b56-bce9-08de99b4b8cc
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 23:31:00.8007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D1JpflfxICo8FoVeuFDcbylbFFsM5rl8y6s3A9UwQwS7CkHAJ1z4WmwQiFSaBG7GUbL7kvKfCJUp8VczLkr+xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8658
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 32526180015
X-Stat-Signature: oob1cd31z6584ynegye6b9uwikmuq5ty
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776123066-760626
X-HE-Meta: U2FsdGVkX1/iHW82DPLCO213+hjtnFN8TcxYoyHREjaMx0joLZeKhiDQetHgrA8eab+ni3nTxCI8yFVCL4XG8Kk71vUYeHVMWd/hOZybnrW4YVrmMq9s2E3Et+9tFvorFzbnM2pcAYAODH4TA4e9RXn/5zzSAwQDeE8e7akX9+Suo+4ZBX0in4f73YoMjd/vOhV5bnMIhe8WsHTOGDw61OjC2OPf6zJNCHKBafwOpttUNnkBGStPlHRB/WUHU5BAPZdqz0oaJToMbQK6/Pd1yHkvQkB321eHbAWo5feAaz42OAa1WAejt3BLLbaXPmYJbdx6pu0jOHSMDS5wge3QgEPoAv5pmKXRTuGIShcjUQ9Ly9iYoADN61YFToUrdFOocZIhCH+SdLAhmNwJK68gL7wk1vC4/OArTsPHrw56+AaFDZ5op3pZ3MiXdrwhlYR0GeJESsjOWMA/rGjffFrj6MM9TnOICJK8ye76zLvO87bzYIT4LBmwr0epxNKbYVxVJ2sp05VAInA73iZ+hHiMSKIY/w34zFkJh36wQe0yZf9xnf0u6xiqrN4nFBHoF7JF0fkwyJiEGJjH6Yk2qKfefeA/LkJ+XQcfNDLszGZ5+DEYf7PuBAnnuNJTKSu9V/0DEFbHtxgyTVrGRgAAKhUIcoc/3cUOhUi+PP1lk3ZjHEJZMuxorTvKXnP8BXJhs5dVBziBKDq7QylvlcDnQJs2VeQBSRpp2meReEebnF5qh7j4IiAfhW9zTCInpY4tTeH1LacQsvhJWShbkFCNJZmxBtqw9JkNYIdgb9UNIsbrmIECgvQcmW59FOODXlcc7zy2ijKQuHIDKQCubiQyr5ZX3qsm+rAbWgFFSIVwn7CSDz2lKrFfNSCY3b6qUv5Otm2Vp3MSXbgnwKtY8aXb9MxSLFZlE54XsWOPQ1Xcl3QqOnYGzMZ0MrN5h1Ci3L3cB3Cx8n8VPXcaei7uY5Y3Eko
 TuPPD4fo
 UVtZmBa0hGOGBQ/L2brPoaBqjHNHTNG+1NuNtcoymLBYjfw5VG+32clMEcjup15H4uVeb76gFUTrK+LBqvTvKm6LeQxWtJqMBOxoJwjzuGJulecyXy6Wsx+1BEou1LwMC4bBuNqI4//p5sFKPIPxE34Tl9HYcmKUGPM/6Lb5Dg3yCueyUEfK1z5TrH4H97E3PWOGMveFu/W9IkjEY+XpYUz6swYBSamYBrkXq0x/wQA1eX7XVmOlIjXN3ESQIoHdX1oqikRXtWoV/25EG8WvX4jrskdYmy1H68eXZSMYb+bRuFWUzGDZqyZhidh7FquCYSNdKwpcgv1y3E7XovMji7tvJx2ohNoQy2u+qXB90CunkwS1Yu/Di5cu0V8vqnwge/dRtyFNUnE0GV9pPbfj/zsQHUDMX/MgPZbuEXjYRQCvlPPArLmZwl7ywiB6/JpsW7Ie9yLeT68yVvtJ7CC2EydZuJi1o+gHXUqjuyghk3uE7NYC9H9vtkZXIPypXu/0ifrH/Pfhco2jWuymV9DW9Ig0Da2lsvAwDiTyBc9GU1jtnT8bxoiOOpHLSYp4b756+nPPz4bvw8Lj783HZJJt6GK+pezC7CF1Noq/oao/JEJXIY7+mgs14LN/Bdk8bc2azFi0qAcU2Kg9gp91d8pUEVgGCMfjhsS2lNrmjWxcqCLalZjqGnRvpqSz2cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:39:23PM +0530, Sunny Patel wrote:
> Fix two bugs in device migration paths:
> 
> 1) migrate_vma_collect_huge_pmd() calls spin_unlock after
>    softleaf_entry_wait_on_locked(), which already releases the ptl.
> 
> 2) migrate_vma_insert_huge_pmd_page() has a dead else-if branch and this
>    branch is always unreachable.
> 
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---
>  mm/migrate_device.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 8079676c8f1f..0e005c26ee88 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -177,7 +177,6 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  
>  		if (softleaf_is_migration(entry)) {
>  			softleaf_entry_wait_on_locked(entry, ptl);
> -			spin_unlock(ptl);
>  			return -EAGAIN;
>  		}

This entire if statement is dead code, since we bail out and collect a
skip on !softleaf_is_device_private immediately above. I thought we
already had a patch from Davidlohr Bueso 'mm/migrate_device: remove dead
migration entry check in migrate_vma_collect_huge_pmd()' that removed
this whole if statement. I even have an email from Andrew pulling this
patch, but it looks like the code is still present in 7.0.

I found this link via a google search which contains the above patch
too:

https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/25-new/+/f405e7bc5d93a541cf11663b2424baf0a03b496f%5E%21/

Look like this change got lost somehow?

Matt

>  
> @@ -869,8 +868,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  		if (!is_huge_zero_pmd(*pmdp))
>  			goto unlock_abort;
>  		flush = true;
> -	} else if (!pmd_none(*pmdp))
> -		goto unlock_abort;
> +	}
>  
>  	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>  	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> -- 
> 2.43.0
> 

