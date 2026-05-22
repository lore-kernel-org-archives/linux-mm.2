Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD365CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 06:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1FC6B0093; Fri, 22 May 2026 02:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082376B0095; Fri, 22 May 2026 02:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3C16B0096; Fri, 22 May 2026 02:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA1EF6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:54:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F188A09C9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:54:04 +0000 (UTC)
X-FDA: 84794141208.02.FAD5A65
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41DC2160009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:54:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lpxJXcAA;
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779432841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uLfGHr2o5k/dAHdXOLxT+XDDTjeoz5TbelNOAMveXVA=;
	b=H2uXW4KsTaYIg2Rix5EjrflLP7t5ZDgz40iVKYbl8K0ySNN1qBaf+YQ9A2AvpPMIgSlKHY
	B0vu33IuDKduK/ENluYATvmdUCKpV9LDeThy9dKifUgtrv86WkLBwqbtInAsfVuD/Xspxb
	d26vtSNajLR95tvjJlPXx++M+QnKI38=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lpxJXcAA;
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779432841; a=rsa-sha256;
	cv=fail;
	b=aPsyv2z+W6kXbrc30LG2fKgyRcf23AvvqtR4tu+VihBY8O622fx39wCfp0rA5vcAPxd1Em
	u7GphcJ7MC8O8elw1hUbSqynLalFFiQtjh3kKbHfbE4giL8L4B+O6Kst/yRcDsC03hzTRH
	uQxhQ7nVKtfyElMDj5aXNhSHBQAjLfE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779432841; x=1810968841;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=bzpudyAfZw7KzxudqlI96rQNvhFedfHi6I0IFAlqFb4=;
  b=lpxJXcAA7qZzqzPEGLvNgOhh8QVvL7g+4XkwNPCQibjh015vqxXRAN1c
   9gjsGBUMi4hykHrTWf+qYfYujYZb1doLwQVpJkg/6EybTdoNnRWaiBClI
   ZpNz2iphaD5pnSqNNfDpe9aJ3dociV/1oplfCO3AX3bztr6hZYxjFQ2xm
   4ahX8hlKzCFLNMQf54MKTJH40JmIgm/xfArNnDAIjpvmIMkx9qfAetqBj
   isw0j7h1AA4ZRw05iH/h/EiwD0NGNjcVGSnb4854sV2Wi+dSOa9Hmhk5s
   3Cy03txEIVQQvZXVuh/GwhD/AsRRLh7wWPHmSb7OMGzp4wMBfyasNvdrk
   A==;
X-CSE-ConnectionGUID: tLOVqp31RYOKPZzqIis31g==
X-CSE-MsgGUID: Az980p15RG6/PYQ+pUa5pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11793"; a="103038021"
X-IronPort-AV: E=Sophos;i="6.24,161,1774335600"; 
   d="scan'208";a="103038021"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 23:53:59 -0700
X-CSE-ConnectionGUID: TqZTld5NT+m7fVG1qYw2aQ==
X-CSE-MsgGUID: BJj4m7lJQV2NIqqm0CtltA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,161,1774335600"; 
   d="scan'208";a="239998573"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 23:53:59 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 21 May 2026 23:53:58 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 21 May 2026 23:53:58 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.65) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 21 May 2026 23:53:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MxgPR1LbGdo1uvHdf0iO0rQUFhyN2kyruLtSzBTIVTFnkoJ9o8uzU5APiVUNePZyiAqpm463JYKofM/x7y0z8XmEKvVjEqmB7LcntQoesbn+bI427wNEbzPWvIQElB2MyA5gmSX10PhhloHHFSs0TwEd4PLFkqBoAJSX32aWl9eZfmXnf5DYJ0FzuWJaY6ca3+AUylx3tAzyfQ+iDjcTNwdwwxrjBuL/qVgR2jtmPlrb3tbY52sQdvBB77cLSi5i9l+kWRuqaaqL55oZOBXE6R558d7gfyc94YAp2uGWFpaQgMuJ+xgLjWhvwrixM6b5nmKopvbK3/g80KGlOx+m7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fN64u3blXUDbRUPN+ICvOQHAR9sl/X5+6iHOGZMo42w=;
 b=HtaFbMY4NPc5bKM9JFG4eB9b7uubz8U+MSeYzNV48D88HnRsV9yrY9xZQjtbIamoIHveqjKu/yhUWx/5zCpKi8M22An3Ee9S3Zp+1mUD2hAbdLg1sFYlk09/cJYR++eqG78cTw0cCeyGvlMLvUhGFFpMhosI+9tJNaySAO/G10f84F6CNmcy09JIxVuIDFGR3ivfS6Eq4aMbQUzAlZSPsgesRgd6bCQvP51+DkzEk56ZbFus+ejTwYpj383mJR4YOTOw7jLMpsk/lzxr7M0nKX+59gayn2jG1BsVDhk2+dBlxDqUVcOSnVEJhGuDUz12owukne4xTzrl8QRF1vqyCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by SJ5PPFC295640A5.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::852) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Fri, 22 May
 2026 06:53:49 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.21.0025.020; Fri, 22 May 2026
 06:53:49 +0000
Date: Fri, 22 May 2026 14:53:35 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Usama Arif <usama.arif@linux.dev>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
	<david@kernel.org>, SeongJae Park <sj@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>, Alistair Popple <apopple@nvidia.com>, "Byungchul
 Park" <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, "Huang, Ying"
	<ying.huang@linux.alibaba.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>, Matthew Wilcox
	<willy@infradead.org>, Nico Pache <npache@redhat.com>, Rakie Kim
	<rakie.kim@sk.com>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [mm]  a2e0c0668a: stress-ng.memthrash.ops_per_sec
 32.1% improvement
Message-ID: <202605221417.62e37e78-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: KL1PR0401CA0030.apcprd04.prod.outlook.com
 (2603:1096:820:e::17) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|SJ5PPFC295640A5:EE_
X-MS-Office365-Filtering-Correlation-Id: bef78a9c-de65-4e52-7616-08deb7cee034
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|6133799003|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info: 9B6Z4ONsoKP+0wgGLGc0mbVSjvqHrweay/GwZ2r3WS7H1X5chYFY1Ha2+ph+8raE82KUj6+gyMSsv2fsV9n/TsMiWyyQcdJdGbEvOAM2VNzE2fWq2/BM2eRZ2vDgWfdzhbwmZUtn3n7KZJQTcgGi0acpFfOwdJGXnxIPDsamSSPixzP4IW6mfDZQ/BU+k5Bp85f1vaCq0qHQP+fvxPHPWUqg+F0q+5dUzZMkJcst4Mri49Sw+vrm+clmzl3xpuEnzayn4WpBGRh3Lasqq4r4H2e5Jb+IHBlhdO0zHu4F6gbpXp58wbZF5YG5WNxMIQqgDa1jpSatHMZcO5YvrqVr7StMHRDE9owa685Pgm3Si1bvtb6wsV4lM1BIqpOlKV89oG9r0QKNJp0njLcjW38oQ9nm6PQGlQnrX1gErixjrHbTw2HzAVbE25zUlvc3FJFXZ10XVbfMPJQ/I2LyktW4tr3jWGQtjtxD8tCmymzSAfuwgRAPyQ5BuoKMeKn7AnqZtzx112wONTQkRF7u2pWImyCKRxOH6Le91oCrqix36iPeECJwBDqq2SjQSH9RMyskkVV2c4g79A311F16TY3sNVv2J5frN/02kwk5KQIO6R33RE/y90o0g+0G6bfv+rYOMMGMBvTduw3xXx9PO7sHWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(6133799003)(3023799007)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?mymzBm9zvyTHklXMTG5RhF3tiJky/FPIzWcljmRak5QdQD3Pvz3IDPxyXf?=
 =?iso-8859-1?Q?NHnZqhtQrG5ZHRnhFBOKNx2nU1kAIIYFqU0tUfAlGE1TFIfFhuPaTjSlrE?=
 =?iso-8859-1?Q?I4HQ2jJNOCdXBty7GotW9pSyAGrIUHokRjfqugTs4hd1zEHutquCOTxX5i?=
 =?iso-8859-1?Q?HmrYX9L2VC6hiaz8pIoK0jwPPFv66H97kUEg23h98u9By8X3bNVzKf0zkL?=
 =?iso-8859-1?Q?H/0rjWs+9digZTTwoIB+0xLWMY3Iz/GFurEXHwgFVIo83uT4bJSwDNzmrl?=
 =?iso-8859-1?Q?aLLHgoeViYR09sctDu08kS7ceqZa19ckXsJ964GRuqLFuvEPq9LHPXqQxq?=
 =?iso-8859-1?Q?SAz/n8IKwZyeYmm8023v+xroZiWCHmnxoj7RXike58Hetv4MCJLpE6qL58?=
 =?iso-8859-1?Q?gHlCHNRzheHLWY6mptVUBC87wIG8dAvmx6ZlFqYbIOXA8VD148g85zvVoQ?=
 =?iso-8859-1?Q?mPoqxK1zvXtLr/nqqN3Ls9dG2qTeUbtIVWLsBY6YcRHwUh913FRn5o2L6C?=
 =?iso-8859-1?Q?xSchDzCYfQ2OcieI3Mx3hCLMBUUXRRtWmFEkiezEBI2mvFuHpF+PKk3+kK?=
 =?iso-8859-1?Q?MkGRADiDEOZIVsBucJMxB/ii24M5uq2ba/ai64tfJst5mVxKstqKjYvvmz?=
 =?iso-8859-1?Q?F+9WaWZtI98qYrlAm6D/2wr4gUOatIOH81A4f/Sc17qrzNnDVs3VXc9efN?=
 =?iso-8859-1?Q?uevbZiO4WXZesIUzc7ky0onkErm5MzOzIGvR6biixCtRmDpNdH3IDNLcT+?=
 =?iso-8859-1?Q?gP96RQyti8Zv1sq8XvP2bRlfMYB9YBWTy5p9wOmS6kVKKp9X//h/7FEiX8?=
 =?iso-8859-1?Q?LOr5BgogO+Q+DdE9zSkfHfyofoUoKgSIdKuRYWr0m1pELqLvzw6ZeV+r67?=
 =?iso-8859-1?Q?jI+AajNeQQgoHIgW2drrb5myE5PIoYSHb4jwI5qHJQl/fe+djNoBk7w/nC?=
 =?iso-8859-1?Q?CjPEGpmhgtX9MSChaEDrfHTCbPxPXWU/VLoWKMG2O1hX6+R2ZyS6bp8Efy?=
 =?iso-8859-1?Q?bJUV5xoF0I0+4L275XeOk/CtMMmRPlvlnV6s11c6LdyLssX9vkbGpLyYQE?=
 =?iso-8859-1?Q?kZBRI/VdUTB2EbJ35WCXCQbt+03nvbGjTh3jDzCJnR3hK5faQ8xQiZ91u9?=
 =?iso-8859-1?Q?+nT+JqhRVzKxzay9k4PXArT1MpzBK9wD7KA9XlypCL3rJxXa5No7Icschf?=
 =?iso-8859-1?Q?D9VwLmwJDowZy2dSHH1yxUn+CMF6qtQ166smsl47tQbUIsNzgL4p2gENk1?=
 =?iso-8859-1?Q?6yh/9M1hOkoAv86Y1ihkx68b9uZZIIpJIytJ8BvOfGEmWOQZThpTKtlME3?=
 =?iso-8859-1?Q?uJNglQC+McsaWVoIQh7btFKhtC9Tp98MrRCpZU2QCGHkULbeOPOVwGh5yE?=
 =?iso-8859-1?Q?d+mrf5w1Tn93TEnOCdz6R+A5nIfKNnsINZsfTHGvfg9JNbIj/2K1bxFjEJ?=
 =?iso-8859-1?Q?NqK6Kfc51HKoKcKJlXhwBrT4sK7cNz03vGARA5bM6BirOTuhnWxLIHX00T?=
 =?iso-8859-1?Q?Os1RdLxn/sgkkrFT7aaBMKp+VI+erIsaj1tE2XdCNR5j9ZozdpX3V1IDH2?=
 =?iso-8859-1?Q?+39X2ub5NNiATDQ94FdyfR+9GrXZn7SxLGJrmw4Yq0I12m2JxSX0aO9WTA?=
 =?iso-8859-1?Q?E5SQXh3uGKXamog5wM7CdTyceUUT5F+kUvf3DMZ9U6giikRmO0+g1Gq8Kb?=
 =?iso-8859-1?Q?7sE+NVsEEalGbPaMvWMprhBumsCrZyL7NUT+9BKby7c2U4C1zK70WPN3/W?=
 =?iso-8859-1?Q?f0XQxY5QinQnHffxy5azFrmahNyZ02cjvtyPD5S7F55y/t15p8Aqjx6VR/?=
 =?iso-8859-1?Q?aoLalH5l7A=3D=3D?=
X-Exchange-RoutingPolicyChecked: r/gwS0s+IgYh3zLlWXsMk0elF3ct+fpz63ZrooPA6lbhqWjW8LRL8YbVuUlNkLqwmQ5WJEEDKEJndHl6RD5c8HPs0ePZDXIRzA7lPMG1E3eU+2P2elyYv4zTEALXCuSlEW9ATw1m7UyR5+kR1cLmwpaqHCyLYP1Na2zeoLoMMfL1UWv8fWkNsStW/395pxNAATm4P2kFl8cj52mtvfQYSgHJUgGTrMx5ANr6AId1fNuAq+s2tRlCEo5skwDyM8BpZmDNS+kfPhDBmUDff3gQaQlgu11xjBxO9Dyn9qbcXkwRKNP3oYZK97xbOF4iqlU+hYuvGlpgaB9QP7fcDn+W8w==
X-MS-Exchange-CrossTenant-Network-Message-Id: bef78a9c-de65-4e52-7616-08deb7cee034
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2026 06:53:49.1411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tAr3dl8Q0gtNadziiSpHNg7x2DQCvY2Q4nz+WP7XhtfvwnNY2ln4FW5Gwq8yfYoAf6prlOeeNTNPFD2116BiSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC295640A5
X-OriginatorOrg: intel.com
X-Stat-Signature: ngn1ww8azsgq3euambuc3jr8we1n84eq
X-Rspamd-Queue-Id: 41DC2160009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779432840-794453
X-HE-Meta: U2FsdGVkX18QmPaFnzUgvgQQy+k1L7P8IaV5V5w5h3AOw7eCjmQIsLqt9i1JWrKyIwpW0y2hybvxt9RJROWFd35q9n98SMf/TGehywaGE3b8BQHsZk3M6BvWmA1HU9fBjwQ0nAvyHz2nHk/meVLeVyoJshuDdF95NL3K0y1t3P/RlRvCtGMMRU2olDDGq888y0ELxGxD27HagohS9MD0Z9kRaa2TynZA7iHRNC5uVqIkExQVX8lH4OTMj/+xno5rLzQcOer7tJH68UMNQjvl+3MaX90/lRvcPosxT+uJ7gkjUurmj7IZLlSYlvdKa+q5+a691amSW+9HEuKESy966Hr4vHRx10yrlxuknRuBGIzv6FFipiJ98KiDyPvgdCOZKoeFPUEcA198RmIrgWL0nacPtrR5gVbiNhRMg5HAxiEReHr6LkqGbeJ30LFl9c/T8xq4scB4qew27AfUuw3ROb4rGM3ECVepwXkSFsa8IAE13TPiMX0SsQULUIJ29DiyVmVIftT2TSficNPBL17KklXAFUeiyms1gWvM6FqXepHzuiH0NXZq7sQ/bNmuZO5FEFg7L74QcZ5d5K3Ul0pcjN5xIcChmQcpyMCS0Ubl3aeYsQu3Fbvvgt8FR7W8fi6Gjb4Ff2ir+Lmg0TzC/4Vk5gWFj2lQrerUzm+tLLEv8wkT0S06Kh+/W3kjkJvLzIlhmes+fO276QFiPP5RhMdDFdO4mzgiRvvBGsA5Z+QK9GOWUDCgKwh3vB79lUoUbfIiN48cMVYJCW9WjhsvAsGQEU7We4qEmf55qTqGvTtO1BWSHYdK9Q3I3C9U4YQSLaIT6sIXPcAaAlux9xV5whb0SKAgUaMBY+iV9u1n3Fy5Z2sHUadcpwaOQkLUaZEip0Qf6WLa4WOGIIrURAjpcQTMp+7hD+mA5fgEEOPKD0FYTgo5M3SR+p1kfRzOLLh9qtB5+zXyM9HKdP13pRwa/2S
 8AT9hIVD
 73Dbt9kMnQoXdD6z3qjAhQ7tor2vCmPGp9yIBPoME/TtmFKmuBLBe25jG6+78zmK+oWqDbiVJERHv/lR+aAem/EdABkrlGl0HngqoxtLAIIo6532jBRDyCtUtTpPYeU/j0UV5/7G3brAIKTwnmsabKTpJRthx6YHsZmW83hvoop/Lp9bBFo2BeUiiB8hBMbc/o0KXKEkqpW3YK8nWKdhMiAX3SCsJGEqA8dZC8UKwwjEZj71PSfX35Q7Xon4btlXGhPk8Co2obrcZR94EVfvHkpI++GN5C/oa8E3xzTb3IeU2709S46iZ1ykPf7U4Hy0I4OBx61ItWZAGgDDd0ScCEGI1ippp0I3BeR5EDDKWNPZP1Y5+XCiYN9nhT8Xz5D61jRalsvIob4otODFunUz4bRUH0AYy+AaiOjH4AprT4Bfe/YvmGCtehIk8smvuqXqMQx6zsJ/aZBzY+G7tYMrbOK2MazIBoxcvl39M31i8Er8SEBLoV9O37tuJ0EFjjs1IL1d84pUxUE80IB38rJlVEIJjC1qDga6DEheOW0Z0A93VIxDs4zqTXZp4LFWtVo78hEEOIx33MYkQ1nVqwYT52STJeM0/8vox52KOZgCSlGJ4KU48gcaE3qubiQxqkdwKtEKIcZ5B34fQ1P5igFf/Vf6K/B8Wfir5VA3bhIyA7ppPgw8YUJUGsIsLHlMm2VtbekUTEHc1PrGMfp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 32.1% improvement of stress-ng.memthrash.ops_per_sec on:


commit: a2e0c0668a3486f96b86c50e02872c8e94fd4f9c ("mm: migrate: requeue destination folio on deferred split queue")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_threads: 50%
	testtime: 60s
	test: memthrash
	cpufreq_governor: performance


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260522/202605221417.62e37e78-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/50%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/memthrash/stress-ng/60s

commit: 
  2d028f3e4b ("selftest: memcg: skip memcg_sock test if address family not supported")
  a2e0c0668a ("mm: migrate: requeue destination folio on deferred split queue")

2d028f3e4bbbfd44 a2e0c0668a3486f96b86c50e028 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     28270 ±  2%     +34.8%      38095 ±  2%  stress-ng.memthrash.ops
    439.06 ±  2%     +32.1%     579.80 ±  2%  stress-ng.memthrash.ops_per_sec
    147882           -42.4%      85190 ±  3%  stress-ng.time.involuntary_context_switches
    267068            +6.4%     284240        stress-ng.time.maximum_resident_set_size
    317026 ±  4%    +419.6%    1647291 ±  8%  stress-ng.time.minor_page_faults
      6692           -63.9%       2412 ±  2%  stress-ng.time.percent_of_cpu_this_job_got
      3079           -88.7%     347.19        stress-ng.time.system_time
   6295697           +33.7%    8416356        stress-ng.time.voluntary_context_switches
 8.254e+09           +37.3%  1.133e+10        cpuidle..time
  22013986           +38.4%   30466146        cpuidle..usage
      8738 ± 15%     -83.2%       1465 ± 63%  perf-c2c.DRAM.local
     10218 ± 15%     -63.7%       3705 ± 58%  perf-c2c.DRAM.remote
    410.50 ± 29%    +242.3%       1405 ± 57%  perf-c2c.HITM.remote
  19232592            -9.8%   17340551        meminfo.AnonHugePages
   9561429 ±  8%      +9.3%   10446848 ±  5%  meminfo.DirectMap2M
    404415 ±  3%     -12.9%     352442 ±  6%  meminfo.Mapped
   1159036           +21.9%    1413282 ±  2%  meminfo.SUnreclaim
   1301140           +19.5%    1555377 ±  2%  meminfo.Slab
     62.40           +23.6       86.02        mpstat.cpu.all.idle%
      1.31 ±  3%      -1.3        0.02 ± 19%  mpstat.cpu.all.iowait%
      0.78            -0.2        0.59        mpstat.cpu.all.irq%
      0.11            -0.0        0.10        mpstat.cpu.all.soft%
     25.06           -21.7        3.37        mpstat.cpu.all.sys%
    589495 ± 11%     +25.0%     736788 ±  7%  numa-meminfo.node0.SUnreclaim
     19200 ±  4%      -7.7%      17720 ±  6%  numa-meminfo.node1.KernelStack
    329434 ± 15%     -35.2%     213453 ± 37%  numa-meminfo.node1.Mapped
  17149792 ±  9%     -12.7%   14965621 ±  5%  numa-meminfo.node1.MemUsed
    569830 ± 12%     +18.7%     676242 ±  9%  numa-meminfo.node1.SUnreclaim
     63.56           +36.0%      86.44        vmstat.cpu.id
      2.61 ±  9%     -99.3%       0.02 ± 55%  vmstat.procs.b
     67.19           -63.7%      24.37 ±  2%  vmstat.procs.r
    553107           +35.7%     750510        vmstat.system.cs
   1527226           -36.3%     972506        vmstat.system.in
    829785 ± 12%    +106.7%    1715157 ±  9%  numa-numastat.node0.local_node
   1442509 ±  4%     +95.5%    2819818 ±  4%  numa-numastat.node0.numa_hit
    612723 ±  8%     +80.3%    1104660 ±  7%  numa-numastat.node0.other_node
   1149611 ±  8%     +63.0%    1874175 ±  6%  numa-numastat.node1.local_node
   1739638 ±  3%     +71.8%    2988324 ±  4%  numa-numastat.node1.numa_hit
    590024 ±  8%     +88.8%    1114149 ±  8%  numa-numastat.node1.other_node
     10365 ±  3%     -99.7%      28.54 ± 28%  numa-vmstat.node0.nr_isolated_anon
    147414 ± 11%     +24.9%     184082 ±  7%  numa-vmstat.node0.nr_slab_unreclaimable
   1442492 ±  4%     +95.5%    2820145 ±  4%  numa-vmstat.node0.numa_hit
    829769 ± 12%    +106.7%    1715484 ±  9%  numa-vmstat.node0.numa_local
    612723 ±  8%     +80.3%    1104660 ±  7%  numa-vmstat.node0.numa_other
     10294 ±  5%     -99.6%      46.16 ± 28%  numa-vmstat.node1.nr_isolated_anon
     19182 ±  4%      -7.7%      17707 ±  6%  numa-vmstat.node1.nr_kernel_stack
     82493 ± 15%     -35.3%      53391 ± 37%  numa-vmstat.node1.nr_mapped
    142496 ± 12%     +18.6%     168975 ±  9%  numa-vmstat.node1.nr_slab_unreclaimable
   1739254 ±  3%     +71.9%    2988936 ±  4%  numa-vmstat.node1.numa_hit
   1149227 ±  8%     +63.1%    1874787 ±  6%  numa-vmstat.node1.numa_local
    590024 ±  8%     +88.8%    1114149 ±  8%  numa-vmstat.node1.numa_other
      1169           -60.6%     460.67        turbostat.Avg_MHz
     36.54           -22.2       14.38        turbostat.Busy%
     63.94           +22.4       86.29        turbostat.C1%
     63.35           +35.0%      85.54        turbostat.CPU%c1
     47.50            -7.0%      44.17        turbostat.CoreTmp
      0.32          +125.1%       0.72 ±  3%  turbostat.IPC
 1.114e+08           -38.0%   69064256 ±  2%  turbostat.IRQ
   3512691           -63.2%    1293273 ±  2%  turbostat.NMI
     47.67            -5.6%      45.00        turbostat.PkgTmp
    339.47           -24.9%     254.84        turbostat.PkgWatt
     47.89           -35.1%      31.10 ±  2%  turbostat.RAMWatt
      0.04           -25.0%       0.03        turbostat.SysWatt
      0.01 ± 11%     -45.0%       0.01 ±  9%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    586.78 ± 52%     -76.6%     137.29 ± 48%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.01 ± 11%     -45.0%       0.01 ±  9%  perf-sched.total_sch_delay.average.ms
    586.78 ± 52%     -76.6%     137.29 ± 48%  perf-sched.total_sch_delay.max.ms
      2.22 ±  2%     -18.5%       1.81 ±  6%  perf-sched.total_wait_and_delay.average.ms
   1256396 ±  2%     +24.5%    1564754 ±  5%  perf-sched.total_wait_and_delay.count.ms
      2835 ± 22%     +36.7%       3876 ± 11%  perf-sched.total_wait_and_delay.max.ms
      2.21 ±  2%     -18.3%       1.80 ±  6%  perf-sched.total_wait_time.average.ms
      2835 ± 22%     +36.7%       3876 ± 11%  perf-sched.total_wait_time.max.ms
      2.22 ±  2%     -18.5%       1.81 ±  6%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
   1256396 ±  2%     +24.5%    1564754 ±  5%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
      2835 ± 22%     +36.7%       3876 ± 11%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      2.21 ±  2%     -18.3%       1.80 ±  6%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      2835 ± 22%     +36.7%       3876 ± 11%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
   6388010            -2.7%    6218187        proc-vmstat.nr_active_anon
   6151592            -3.2%    5956303        proc-vmstat.nr_anon_pages
      9390            -9.8%       8467        proc-vmstat.nr_anon_transparent_hugepages
     19371 ±  2%     -99.7%      58.14 ± 16%  proc-vmstat.nr_isolated_anon
    101105 ±  3%     -12.9%      88112 ±  6%  proc-vmstat.nr_mapped
    289767           +21.9%     353298 ±  2%  proc-vmstat.nr_slab_unreclaimable
   6388005            -2.7%    6218187        proc-vmstat.nr_zone_active_anon
   3187240           +82.5%    5815893        proc-vmstat.numa_hit
     31673 ±  6%     -42.5%      18217 ±  4%  proc-vmstat.numa_huge_pte_updates
   1984495           +81.2%    3596704 ±  2%  proc-vmstat.numa_local
   1202748           +84.5%    2218810 ±  2%  proc-vmstat.numa_other
  16271854 ±  6%     -42.4%    9369899 ±  4%  proc-vmstat.numa_pte_updates
 1.038e+09           -98.2%   18939715        proc-vmstat.pgalloc_normal
    672777          +197.7%    2002601 ±  6%  proc-vmstat.pgfault
 1.038e+09           -98.2%   18467962        proc-vmstat.pgfree
  1.03e+09           -98.9%   11586287 ±  3%  proc-vmstat.pgmigrate_success
    113875 ± 12%     -58.0%      47810 ± 25%  proc-vmstat.pgreuse
   2010888           -99.3%      13200 ±  4%  proc-vmstat.thp_deferred_split_page
   2012617           -99.4%      12669 ±  5%  proc-vmstat.thp_migration_success
      4904 ±  3%     +36.5%       6696 ±  4%  proc-vmstat.thp_split_pmd
     14192           -50.1%       7083 ±  2%  sched_debug.cfs_rq:/.avg_vruntime.avg
     10454 ±  2%     -75.4%       2571 ± 10%  sched_debug.cfs_rq:/.avg_vruntime.min
      0.19 ± 17%     -50.0%       0.09 ±  7%  sched_debug.cfs_rq:/.h_nr_queued.avg
      0.34 ±  4%     -15.2%       0.29 ±  4%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.19 ± 17%     -50.0%       0.09 ±  7%  sched_debug.cfs_rq:/.h_nr_runnable.avg
      0.34 ±  4%     -15.2%       0.29 ±  4%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
    175981 ± 18%     -61.1%      68457 ±  9%  sched_debug.cfs_rq:/.load.avg
    254892 ±  5%     -23.5%     194995 ±  9%  sched_debug.cfs_rq:/.load.stddev
      1357 ± 37%     -57.0%     583.98 ± 36%  sched_debug.cfs_rq:/.load_avg.avg
      0.19 ± 16%     -49.1%       0.10 ±  8%  sched_debug.cfs_rq:/.nr_queued.avg
      0.34 ±  4%     -12.8%       0.29 ±  5%  sched_debug.cfs_rq:/.nr_queued.stddev
    404.25 ± 11%     -33.8%     267.42 ±  2%  sched_debug.cfs_rq:/.removed.runnable_avg.max
    404.25 ± 11%     -33.8%     267.42 ±  2%  sched_debug.cfs_rq:/.removed.util_avg.max
    267.52 ±  8%     -47.5%     140.35 ±  4%  sched_debug.cfs_rq:/.runnable_avg.avg
    211.10 ±  5%     +19.4%     252.05 ±  2%  sched_debug.cfs_rq:/.runnable_avg.stddev
    266.14 ±  8%     -47.5%     139.71 ±  4%  sched_debug.cfs_rq:/.util_avg.avg
    210.96 ±  5%     +19.2%     251.46 ±  2%  sched_debug.cfs_rq:/.util_avg.stddev
     75.17 ± 23%     -68.0%      24.09 ± 16%  sched_debug.cfs_rq:/.util_est.avg
     14192           -50.1%       7083 ±  2%  sched_debug.cfs_rq:/.zero_vruntime.avg
     10454 ±  2%     -75.4%       2571 ± 10%  sched_debug.cfs_rq:/.zero_vruntime.min
    619.25            +6.3%     658.23        sched_debug.cpu.clock_task.stddev
      1594 ± 17%     -54.9%     718.80 ±  6%  sched_debug.cpu.curr->pid.avg
      2781 ±  4%     -19.2%       2246 ±  2%  sched_debug.cpu.curr->pid.stddev
      0.19 ± 15%     -52.9%       0.09 ±  7%  sched_debug.cpu.nr_running.avg
      0.34 ±  3%     -17.8%       0.28 ±  4%  sched_debug.cpu.nr_running.stddev
     90326           +40.3%     126764        sched_debug.cpu.nr_switches.avg
    184140 ±  7%    +143.7%     448758 ±  5%  sched_debug.cpu.nr_switches.max
     25673 ±  4%    +210.3%      79661 ±  6%  sched_debug.cpu.nr_switches.stddev
      0.35 ±  9%     +29.7%       0.45        sched_debug.cpu.nr_uninterruptible.avg
    155.33 ± 13%     +61.8%     251.33 ± 25%  sched_debug.cpu.nr_uninterruptible.max
    -31.50           +32.3%     -41.67        sched_debug.cpu.nr_uninterruptible.min
     20.74 ± 10%     +46.9%      30.46 ± 27%  sched_debug.cpu.nr_uninterruptible.stddev
     25.34           -62.1%       9.60        perf-stat.i.MPKI
 1.194e+10           -22.8%   9.22e+09 ±  3%  perf-stat.i.branch-instructions
      0.24            -0.0        0.20 ±  2%  perf-stat.i.branch-miss-rate%
  27059070           -39.8%   16288026        perf-stat.i.branch-misses
     64.90            -7.5       57.38        perf-stat.i.cache-miss-rate%
  1.79e+09           -64.7%  6.318e+08 ±  4%  perf-stat.i.cache-misses
  2.76e+09           -62.9%  1.025e+09 ±  3%  perf-stat.i.cache-references
    581182           +36.2%     791633        perf-stat.i.context-switches
      3.20           -49.5%       1.62 ±  2%  perf-stat.i.cpi
 2.278e+11           -61.3%  8.824e+10 ±  2%  perf-stat.i.cpu-cycles
      4424           -80.9%     844.69 ±  2%  perf-stat.i.cpu-migrations
    128.63 ±  2%    +118.5%     281.11 ±  3%  perf-stat.i.cycles-between-cache-misses
 7.238e+10           -11.1%  6.435e+10 ±  4%  perf-stat.i.instructions
      0.33          +153.9%       0.83        perf-stat.i.ipc
      1.01 ± 24%     -74.0%       0.26 ± 35%  perf-stat.i.major-faults
      3.02           +36.3%       4.11        perf-stat.i.metric.K/sec
      8629 ±  2%    +228.8%      28378 ±  6%  perf-stat.i.minor-faults
      8631 ±  2%    +228.8%      28379 ±  6%  perf-stat.i.page-faults
     24.71           -59.9%       9.90        perf-stat.overall.MPKI
      0.23            -0.0        0.18 ±  3%  perf-stat.overall.branch-miss-rate%
     64.93            -3.1       61.88        perf-stat.overall.cache-miss-rate%
      3.16           -55.7%       1.40 ±  3%  perf-stat.overall.cpi
    128.00           +10.7%     141.70 ±  2%  perf-stat.overall.cycles-between-cache-misses
      0.32          +125.7%       0.71 ±  2%  perf-stat.overall.ipc
 1.178e+10           -22.7%    9.1e+09 ±  3%  perf-stat.ps.branch-instructions
  26597284           -39.8%   16001940        perf-stat.ps.branch-misses
 1.766e+09           -64.4%  6.289e+08 ±  4%  perf-stat.ps.cache-misses
  2.72e+09           -62.7%  1.016e+09 ±  3%  perf-stat.ps.cache-references
    570400           +36.0%     775987        perf-stat.ps.context-switches
 2.261e+11           -60.6%  8.903e+10        perf-stat.ps.cpu-cycles
      4386           -80.8%     840.61 ±  2%  perf-stat.ps.cpu-migrations
 7.151e+10           -11.1%  6.356e+10 ±  4%  perf-stat.ps.instructions
      0.99 ± 24%     -73.9%       0.26 ± 35%  perf-stat.ps.major-faults
      8539 ±  2%    +227.2%      27937 ±  6%  perf-stat.ps.minor-faults
      8540 ±  2%    +227.1%      27939 ±  6%  perf-stat.ps.page-faults
 4.762e+12 ±  2%      -9.5%  4.311e+12 ±  4%  perf-stat.total.instructions




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


