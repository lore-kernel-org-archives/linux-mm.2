Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6294C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 07:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29EDB6B0093; Tue, 22 Jul 2025 03:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24FB96B0095; Tue, 22 Jul 2025 03:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0EE6B0098; Tue, 22 Jul 2025 03:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFCFE6B0093
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:08:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7620B160280
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:08:07 +0000 (UTC)
X-FDA: 83691021414.04.0B01DC6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf23.hostedemail.com (Postfix) with ESMTP id F2306140006
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:07:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NzQ5MUcH;
	spf=pass (imf23.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753168084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=T5gxakbluRT7UovxvFsF4//YhwYd+RZtwsViUTmE1wE=;
	b=yv9PdAbE/S5U3q0cr3kjOW+oGAXbHkBYXiXf1C13ITxPUEeXCUhTPCCuIHbO6qqLZMl5FG
	gRP/gdfhAvpAhRTH3C/TKJ3FHi+Uh35Y/0dgdiSKxzzRQcxOdgOs9TqZWaWMoe0sSkEFFn
	8pNFSqvIoDS9J6y0/PXwvb24L2u4Y3Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753168084; a=rsa-sha256;
	cv=fail;
	b=p9B4lqFZFGz2QNbafqjN6kf9KcGjdU2omqsaumd5dXhEixpKp3prOK6m/EgI9KLFw0WmPd
	grDIf2IkqRInVKRC8b/X/L16t30+trKaASNXToH17l8piyx7l5lMb+VEPz1101rw9wGeRg
	8l0siGop0n8tsCdKt5kaxw1kK9dGabM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NzQ5MUcH;
	spf=pass (imf23.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753168083; x=1784704083;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=QAx8Y1zHA3pdY8tnE4EHqPIaFX+eiF04PtP/RMC8Cqw=;
  b=NzQ5MUcHJsJecO/ZSMTBpqPIk/2Q9YjLe/OLkncuyqFHaoXI4VTssI4Q
   3PbwCbfHu+KEDdVAg5GTmXrQ0HuZbqJFcAxEpQMm3GQywQ6P1M6kBLnes
   /hY2w/4AAM8y1hHwN5wMvVkqviMMC1/MBsFmVVX9mOXr/DqS9ebrP8IXg
   KX2vHuo/bNECG2o313Uiu3hyHTrvXJ7My0oCcpW2OIv66t8NHolm3Q34w
   b/MsxHxT+XIvCKxtaWtDAC4VDYiQt2P7pUVPwfYngDiqz5C6p/ZuPAZYY
   P7o2SodDWMMhYDJdfPqDpwNHUYj9AcV3XbqCJ5ZQkR8TN4hH63bQ/H0Eb
   Q==;
X-CSE-ConnectionGUID: JG9ZasVCSY++YhFhoxXqRA==
X-CSE-MsgGUID: mcj19eV1SRid5OMh6v8AnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="43024457"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="43024457"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 00:07:58 -0700
X-CSE-ConnectionGUID: D5QXisHMSty/mkqonwzWcA==
X-CSE-MsgGUID: CFTJlp8hQhSSM1dRCoy6Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="163604373"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 00:07:56 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 00:07:55 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 22 Jul 2025 00:07:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.87)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 00:07:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ApZcKOcwFKXdR9voxx8uD9JGcTsxdqIiQ032rc1/HFW/1jCROoqlMXnTKpyf5VsCv8JHeyTI+wjWtOZtU8hPcTVYziRIWFNKEDW2rspF+SnqWu9jg1UE2+aGlENfSVixVAw8imV/szS0AQBALqyRiFYYHoZxaUc3TOvvK0meSxL9F5yj+3dgjuOYOPirIdwiVivV7x9Z+8bMFPAsKNBBW3ZFHQKjvHtBr8NIrmjww22tNsXtodlzsx2qTHqdpoPyO1CuqwasZTEUDyhlHC7vSmYWQR7MDdT0EkkQB4ZPgM8ZLgrg2x460uA3f8vjRrgy1IBGjpTW8uVYr385oFtXyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T5gxakbluRT7UovxvFsF4//YhwYd+RZtwsViUTmE1wE=;
 b=gjaTBfkyrUmBl1WR0rda/qlS7661ttBZFZcBPOkgnFcF9+reWl3vgMA6ihVEWYZgRBtmLC0vVaDWn+UtpSG+4FG5Vqg2TtnLOVNwfN40BwHDmBvYphrgRyPsp4N3dBO+VfwlK1jwwNwb4ehS3BzHlnXIH8LDLbYzZzNl9LtXJRrg6pnNsRVJnlR/4Wq4XybwwjV7ieiyVvmD63MHIxBzDu+sPCBlDzMHpsULcRGaf9WG/jv1DaAH2hFtSVW6lC2cPbipAxzPrWx3ubyoeHx/yFCCUkt1o+e01gXuwRTWTX5dFOJymuk6quETumCmhNhHaKTqf5SfmvcsCK1YQGP9Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH0PR11MB5078.namprd11.prod.outlook.com (2603:10b6:510:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 07:07:52 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 07:07:52 +0000
Date: Tue, 22 Jul 2025 15:07:44 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm, slab]  5660ee54e7:
 BUG:KASAN:stack-out-of-bounds_in_copy_from_iter
Message-ID: <202507220801.50a7210-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR04CA0216.apcprd04.prod.outlook.com
 (2603:1096:4:187::18) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH0PR11MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e61e94a-1dee-4818-8a85-08ddc8ee79a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JBjBp+2OgS2hbrHSbSUSoLdiCygXsCba/47YCQUOlflvZea4qiFoPegdoUN5?=
 =?us-ascii?Q?Kdzo0mTPaFnwn5mzVNdOaECocLn4Y0u6aZ9nXeQI2ZCFzYrMurASY1H4/Hb2?=
 =?us-ascii?Q?8rNILP34vtgQBsugDtqTsogPlOzpEvXJc+NIq6WG/aO7UH7UPAhQ9tg6SJ0M?=
 =?us-ascii?Q?e9sF3QPEC36SwS6b1JCMx2jQXGsTcpUoRGx3m2UycVl9LDcw4cfFX+CESi2p?=
 =?us-ascii?Q?HX0FA3CPKcQLyqvC0ou14biVldEeAW/8nNnGaOJ97NW48P7uvnusB0laK5p/?=
 =?us-ascii?Q?0EmCoiqx5FcTgLBqtgnweYL12D4T6xPUkJxkSEtq5bol5Cdgt6bpUmj4DOzm?=
 =?us-ascii?Q?pzXNcaiyKnbqdKlvOICrVrORRcw+3ZFqZ2ndanpoAHJqb2zu0k46PH+Jt8xx?=
 =?us-ascii?Q?5ugodXaQ8obIhVqmd3pMWgA+OUL54ftuieGY0wWcfypavCVwxYg6gHvc4Ody?=
 =?us-ascii?Q?AHcSzWeANhDRjKpXhvfqIy2WYVNw3WLPfFY3dEAbHU/reU9gSRvEYOLmMqBc?=
 =?us-ascii?Q?GrlKNO9v4k57cuJUg+XBDGOyiB9E56BmYtMwMciD65MXcVSXhg4nNLBWnJ9U?=
 =?us-ascii?Q?Wcix5dUuqxFy40+CeUlErHDRqHN2KyQ/eZSxLmnzR5cHZDPqmIHGC6mR5QW8?=
 =?us-ascii?Q?vucix94HXNrnRHqoxgfYKosQIvjqECSeCt985eYEJ+lb3pKUcAZELLlDT1HH?=
 =?us-ascii?Q?REB21JMyteKmiAlBo+1bT3u4DCjQbzrbWxNKDP3usfI2P6RysN/9kcGr9971?=
 =?us-ascii?Q?21WdzvRGFreoy0kmjIY6XiURh9hfY/YHSjdkpyiLBC2IvdQ1uwCmlbwlaUwc?=
 =?us-ascii?Q?TIJNjAShSko965t914UkQ6lYPGpi5Pqxp5okpS/0R8Rt65aI/wLwLn8x5KN1?=
 =?us-ascii?Q?Lf3smildDbYcB7C64yQ1z2axnw2EaBsM+X91+sjQzvyHviJMhcUyPTgsCubK?=
 =?us-ascii?Q?p4S0Xw2xZ1d4+TXSdhN9S5UlhamcIbyj/2hdbqzENAVN8RqrQieR6DwFgCJa?=
 =?us-ascii?Q?DR1ZacuzVTyxnmNS9ilLLOapnr5p1qRWQfGLi399BPPPFxFws7FZCElMfOXR?=
 =?us-ascii?Q?sQrIHMc7KSntBYzvJ8wqXRxfK9xnSNQziJTT0uaYdx/j4hyTx0ns5sP9ugiL?=
 =?us-ascii?Q?zUbT8PDgrxjsKbNyLCjcImSH/OKKmqhhpDeXphwKh9IOic3Bd5dJ28n9JdM9?=
 =?us-ascii?Q?2e9vmt8XHjU+uYAcbs1n2npuWXqiN/93ukaVAaZEoBkY2XhiHxvkor7vODPS?=
 =?us-ascii?Q?YykkRHaZSuScAB5CDkSRgX3eyf5GEMV1rwmNOjkngMa+RwvwI/oaP7aht8HY?=
 =?us-ascii?Q?Jl+1xl5kD/n3Zy7WqsV4awomEbJakgdDZpXyWT2I7EYb2SAFpmaS3PFGonmr?=
 =?us-ascii?Q?KK4gDhm3N6P42t7OvLwFJEHh3VgH?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fRF5pm9fKAzKCjugROhSITd4AUpCzRr4yU//i8sruW0tM9VJNM4w0VhKJGDB?=
 =?us-ascii?Q?KP2+4scUxmxYSE3GkFAt3to+NpKssRcb0abYtF8y68qqPho/OTJVpeqO69rI?=
 =?us-ascii?Q?wNVToxrT4p+G+Ut6XzhLHwEYcrGCISKX0GoEJH6G1GTjA0JyfKmScVcks3cF?=
 =?us-ascii?Q?YgOmNGjc/U2nD4ViB3WsI4F9zvkB50/8Rn+qPYnVkY6GXVej/68tzhiRPU2N?=
 =?us-ascii?Q?Joo13FVIzX9V9iJQTX/E42CiqwfxnGIuG4wmRFJjetC91J+IaAhIRgo1Tzt8?=
 =?us-ascii?Q?2lzYtlcKhAjtVgTSVxAYL+v8mSYbAaLvXGEWffzGXvfNTBeM2Dadg4KV8+kS?=
 =?us-ascii?Q?SvKLXypssubnK/YRReYmV3E+gaksAINd78wL5Z/3VAvAF45q8EWJ7cjynfod?=
 =?us-ascii?Q?dUaRn/ID9Ca3APaNIpf+PQbhxwbyk4+lS8w08yF/hN/00ZKgSTZHVEV+9+m8?=
 =?us-ascii?Q?an4Ig0Vs+j+ON1GmdoduIrbLXCr6b92013UO0nMPDzg/mmayzsBmrRrVVr5B?=
 =?us-ascii?Q?gnWPf+7HBTndpHYV5gWE2zh8stmwxDBbOzGcqnhbMbLRdCiwYU9hPmcn0joT?=
 =?us-ascii?Q?M5OSmaYRQClHmAQcD8y0hk2zUdjt7bLuad0zMLyD1GiUOUFDRqyus1HaVXRI?=
 =?us-ascii?Q?L6VS35BiLiLQ9lsTaD78d/rn+LX/F2YGXPiC2TsqYhYtU0N/TsZjFcDfr1bs?=
 =?us-ascii?Q?errfRxs3etl1th5lbL2/lsmcDHYjNkRM0+Gx7v1tn6l+QBp3qjaRc3Rz5PbX?=
 =?us-ascii?Q?uVMG9w1k3F47lX1kfoS1SQIdunmH5YW14wxeTteAaGlDX8BDF6v0YRfYZ8b0?=
 =?us-ascii?Q?sM/IaiF0H3qf0xB544i4SvDHY8jkzLjiZbifXvhJOBrE3FB+CC/VKay8nR8R?=
 =?us-ascii?Q?xgVXPmMgv72/SbxOZ0gmBFCd9OmLwOh5fjRo5jpjAneYJUZxAmkLFlbt22eN?=
 =?us-ascii?Q?y3buYD20LjHb9ptV0J3RYcAd/pQlHECmCfNOMDUnyEPbVbwujNArIksgi0FB?=
 =?us-ascii?Q?dknEcKC09uFeEPlBRb//PfmMgfvIdHPaHgmP818kSKSoZlcuzVl9ZVk3RIEn?=
 =?us-ascii?Q?hlesDSklMqpSIO6SXjiJBMbIOFkKwdKmMj0HFmkz2by3GZTmN66FAsZ6KY/2?=
 =?us-ascii?Q?nd1ah1dWSpEvApv3gkfAEAW2mI4NHqaWd8CDBSBJNK72XFcodJihjGWkT09R?=
 =?us-ascii?Q?Osnn2tHyajis5769G8VF0QGXxVgExsoyAm6nLDX7BHkaMJPRdSp0hyL00Q5d?=
 =?us-ascii?Q?tgKKX0ZXdeGN/ZsNYtYokwXrUbXn2ftMUwKanxZkKvLmiT1q9qp9wV3/iVgw?=
 =?us-ascii?Q?5xgre3jG1g/cqpyfout6zmikfT551FqWIGiGYtep+B+Rht8W4Vz3V0hPDD8f?=
 =?us-ascii?Q?Q1dcGrrhK0rf3JVIrpl3mMNiypECKxeaU22DEfqCo7JUcnKP8BijygIOgep8?=
 =?us-ascii?Q?XzBAfTGNoZNhF0k7o/7lC7is0D642bjRVqyw8li0EldYhpbkZZEBqMhbC/la?=
 =?us-ascii?Q?bdaTu/bT1yPuQYzNWkIm5nY2BeILxto/yFNMr19KDre5NxSYgqZjUgvSpfaC?=
 =?us-ascii?Q?Nya5PlCwENyuyIvfFpeXm9gfi8xvIrdnAbChFqtgKrD/Mu/eYOzapn2hajvi?=
 =?us-ascii?Q?+Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e61e94a-1dee-4818-8a85-08ddc8ee79a2
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 07:07:52.8180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hr8QZBztG0uleedwUCbQCddbZgJkaFQCQdFmHWjMoiaoeWWId+PiGgQ4DBEe8XNmgwZNUXBoEIzfA0bwTZN6Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5078
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: F2306140006
X-Stat-Signature: niz3aywo7kbbxbqo5uypk95c71ew717e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753168079-527466
X-HE-Meta: U2FsdGVkX185XqD5/JfIixQRAVCseUoF3jTHWK2CvMi2tpwGb7qNCqnjcqMvVQpxUHkp4cnfPXPaD5piWeL6twIaZtYCnS5TwDjxO/iOKUZDxFhwNpCwruqhVPePfjMvNl6pVc5DL+FjC6jr0OOKH/KNVInVUE+7ypRUizqQHFadxcnqMt6quU2QEyo87p9p9APiLQPaVJyiqqldxWQkjROzRfsBsOYLG0ZDfIRFXxRZgBfQJwVI4YkK4OGhRTHRK350TmjBU1tn4MbAd3tPAYyUvKURR+FSL/5K2Lth0EpMQAwn7oC7ew3HXo6zPE+BWJ55LxlvoQw764qQtB6KomRkfiBCSxsMB/bWBJRczWkmTJPooLheIlNrSf0ZkCwzn6VGZXs9Qi9kCZeXQc2oBFquSayF4DgK00K3qCZ7+Dt5DLhjqu/9pWQZw8UHlXOvLl1asJA+zlv+6Cf27YGZ+CpwAH5CQpoAbEPr6TQwwC8ZVqxBXYZ11T3gZJvklcodmiGiKdYnJBpUWf766NQbAavrtxtoikuWDn2mRgu9HUco5YzKoJolBTWc25jW1bIUBfSCF61xDJE2wMZAYm2iCqd7UO/oV7BnWUSAozyf/jV6AoeUojY5QnT/pgl0dt5r+NTq1LbR4FYrSBbBy5eUDp01QRuU6yeuAzkDuzpkxSgUEoebWYPztC+PGoidRrMvRucm8asY8alKwP0Ry7xNI7Nh7us6w5DwKocvF9OAdiqd3VlzNJ30guSLb4Oe6RKxy5u63Uyk+73LEEaiUkUDsPCI3NtsuWwYOUy10dzTj0aj+yJqiFJDfw4Og3dyCoaLxCnn8HZ7MRbZCQc3d3h9GLP6QBE+m7HBXL12TZAU9pXoWFdNkiSZgQwELUwNi3gGVFXgwBwec7cTeqR7p4ZYYLMlqoBnXLcYkp74lRHidv7+fz+XGHEH3V9/nuZC5AhZkW1y5K8H6aP5vMX0HVK
 zx2bqLgc
 rQ7cYe026i4TmeIjvANkfbWqlQiKUFrJ+TK9xy1yAa5Xeumleymexnm2CiG05R6HXFcABZ3u9vXwRH2lgvpbjY62/ybWezvr8TLq9ALfM1QdJZmItSEK/izwXivrpa5RXWwBK7v7D4n6mgfElvajo3DQXo4CQzX81fWJYWbd/82z7b3IfqiNv/H2vkxTmucBDqwC3RRT+fdy6G/iDNR9MK8ABS85j8RhrSru52VCsbPa4gUu7MhnOCH11jRXUgqL5Zb94//mmra8hWZIXG6HU1ZB2lH3100HdhSBgyL4A6gENhclWPM3KwVv8tJHxIkqdEe0VaDGgeq2DZpfmiT0H3ADIfOcf0ittsT9V/80VX3mgnh4A6C3TZYYCiHFh0jQTQHklCMn3DP73UO7lJcwCZ2ZI11iYlotOCk594jN7mh03N1MpPwlwT2hpxpK3TW825lgtXDVKt/d6bjmu+gPfbzibLpjLLPCB5FQVNVCsu+DAcnq6KeMz9v3rZisYWSh1bHTtDem4ZBeP9VUJcX00Pm+RcHNSwl1FIa/jBpuctBDafjL9pvoWPCFcsyGA7SzNdeAqwcdYDeg0p43//aoN8JFCcXXspaDAj23ZHj95DnEWP7elbqLGUVjosiml8zhz13TvliiqikdE9x4NqQ/LSasFa0AXgX47qBCrbPiF5DWB9APhOKJM5PgYOkUeQl35Ju8NZT+pGw28NGqyEyScLEHtmxNSgD7U4Jx4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:KASAN:stack-out-of-bounds_in_copy_from_iter" on:

commit: 5660ee54e7982f9097ddc684e90f15bdcc7fef4b ("mm, slab: use frozen pages for large kmalloc")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master d086c886ceb9f59dea6c3a9dae7eb89e780a20c9]

in testcase: blktests
version: blktests-x86_64-5d9ef47-1_20250709
with following parameters:

	disk: 1SSD
	test: nvme-group-00
	nvme_trtype: rdma
	use_siw: true



config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake) with 28G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202507220801.50a7210-lkp@intel.com


[ 232.729908][ T3003] BUG: KASAN: stack-out-of-bounds in _copy_from_iter (include/linux/iov_iter.h:117 include/linux/iov_iter.h:304 include/linux/iov_iter.h:328 lib/iov_iter.c:249 lib/iov_iter.c:260) 
[  232.737608][ T3003] Read of size 4 at addr ffffc90002527694 by task siw_tx/2/3003
[  232.745045][ T3003]
[  232.747222][ T3003] CPU: 2 UID: 0 PID: 3003 Comm: siw_tx/2 Not tainted 6.16.0-rc2-00002-g5660ee54e798 #1 PREEMPT(voluntary)
[  232.747226][ T3003] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS 1.2.8 01/26/2016
[  232.747228][ T3003] Call Trace:
[  232.747230][ T3003]  <TASK>
[ 232.747231][ T3003] dump_stack_lvl (lib/dump_stack.c:123 (discriminator 1)) 
[ 232.747236][ T3003] print_address_description+0x2c/0x3b0 
[ 232.747241][ T3003] ? _copy_from_iter (include/linux/iov_iter.h:117 include/linux/iov_iter.h:304 include/linux/iov_iter.h:328 lib/iov_iter.c:249 lib/iov_iter.c:260) 
[ 232.747244][ T3003] print_report (mm/kasan/report.c:522) 
[ 232.747247][ T3003] ? kasan_addr_to_slab (mm/kasan/common.c:37) 
[ 232.747250][ T3003] ? _copy_from_iter (include/linux/iov_iter.h:117 include/linux/iov_iter.h:304 include/linux/iov_iter.h:328 lib/iov_iter.c:249 lib/iov_iter.c:260) 
[ 232.747252][ T3003] kasan_report (mm/kasan/report.c:636) 
[ 232.747255][ T3003] ? _copy_from_iter (include/linux/iov_iter.h:117 include/linux/iov_iter.h:304 include/linux/iov_iter.h:328 lib/iov_iter.c:249 lib/iov_iter.c:260) 
[ 232.747259][ T3003] _copy_from_iter (include/linux/iov_iter.h:117 include/linux/iov_iter.h:304 include/linux/iov_iter.h:328 lib/iov_iter.c:249 lib/iov_iter.c:260) 
[ 232.747263][ T3003] ? __pfx__copy_from_iter (lib/iov_iter.c:254) 
[ 232.747266][ T3003] ? __pfx_tcp_current_mss (net/ipv4/tcp_output.c:1873) 
[ 232.747270][ T3003] ? check_heap_object (arch/x86/include/asm/bitops.h:206 arch/x86/include/asm/bitops.h:238 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/page-flags.h:867 include/linux/page-flags.h:888 include/linux/mm.h:992 include/linux/mm.h:2050 mm/usercopy.c:199) 
[  232.747274][ T3003]  ? 0xffffffff81000000
[ 232.747276][ T3003] ? __check_object_size (mm/memremap.c:421) 
[ 232.747280][ T3003] skb_do_copy_data_nocache (include/linux/uio.h:228 include/linux/uio.h:245 include/net/sock.h:2243) 
[ 232.747284][ T3003] ? __pfx_skb_do_copy_data_nocache (include/net/sock.h:2234) 
[ 232.747286][ T3003] ? __sk_mem_schedule (net/core/sock.c:3403) 
[ 232.747291][ T3003] tcp_sendmsg_locked (include/net/sock.h:2271 net/ipv4/tcp.c:1254) 
[ 232.747297][ T3003] ? sock_sendmsg (net/socket.c:712 net/socket.c:727 net/socket.c:750) 
[ 232.747300][ T3003] ? __pfx_tcp_sendmsg_locked (net/ipv4/tcp.c:1061) 
[ 232.747303][ T3003] ? __pfx_sock_sendmsg (net/socket.c:739) 
[ 232.747306][ T3003] ? _raw_spin_lock_bh (arch/x86/include/asm/atomic.h:107 include/linux/atomic/atomic-arch-fallback.h:2170 include/linux/atomic/atomic-instrumented.h:1302 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:127 kernel/locking/spinlock.c:178) 
[ 232.747312][ T3003] siw_tcp_sendpages+0x1f1/0x4f0 siw 
[ 232.747326][ T3003] ? __pfx_siw_tcp_sendpages+0x10/0x10 siw 
[ 232.747340][ T3003] siw_tx_hdt (drivers/infiniband/sw/siw/siw_qp_tx.c:379 drivers/infiniband/sw/siw/siw_qp_tx.c:586) siw 
[ 232.747354][ T3003] ? __pfx_siw_tx_hdt (drivers/infiniband/sw/siw/siw_qp_tx.c:431) siw 
[ 232.747368][ T3003] ? dl_scaled_delta_exec (kernel/sched/deadline.c:1481) 
[ 232.747372][ T3003] ? __pfx_sched_balance_rq (kernel/sched/fair.c:11754) 
[ 232.747375][ T3003] ? update_curr_dl_se (kernel/sched/deadline.c:1509) 
[ 232.747379][ T3003] ? place_entity (kernel/sched/fair.c:5211) 
[ 232.747382][ T3003] ? switch_hrtimer_base (kernel/time/hrtimer.c:232 kernel/time/hrtimer.c:258) 
[ 232.747386][ T3003] ? pick_eevdf (kernel/sched/fair.c:946) 
[ 232.747389][ T3003] ? __resched_curr (arch/x86/include/asm/bitops.h:60 include/asm-generic/bitops/instrumented-atomic.h:29 include/linux/thread_info.h:97 kernel/sched/core.c:1114) 
[ 232.747393][ T3003] ? update_curr (kernel/sched/fair.c:1236) 
[ 232.747395][ T3003] ? xas_load (include/linux/xarray.h:175 include/linux/xarray.h:1270 lib/xarray.c:241) 
[ 232.747400][ T3003] ? xa_load (lib/xarray.c:1613) 
[ 232.747403][ T3003] ? __pfx_xa_load (lib/xarray.c:1613) 
[ 232.747407][ T3003] ? ttwu_do_activate (kernel/sched/core.c:3719 kernel/sched/core.c:3749) 
[ 232.747410][ T3003] ? update_rq_clock_task (kernel/sched/sched.h:1327 kernel/sched/pelt.h:120 kernel/sched/core.c:798) 
[ 232.747415][ T3003] ? siw_mem_id2obj (drivers/infiniband/sw/siw/siw_mem.c:28) siw 
[ 232.747425][ T3003] ? __pfx_siw_try_1seg (drivers/infiniband/sw/siw/siw_qp_tx.c:50) siw 
[ 232.747436][ T3003] ? __pfx_try_to_wake_up (kernel/sched/core.c:4189) 
[ 232.747440][ T3003] ? siw_qp_prepare_tx (drivers/infiniband/sw/siw/siw_qp_tx.c:222) siw 
[ 232.747452][ T3003] siw_qp_sq_proc_tx (drivers/infiniband/sw/siw/siw_qp_tx.c:882) siw 
[ 232.747463][ T3003] ? siw_activate_tx (drivers/infiniband/sw/siw/siw_qp.c:996) siw 
[ 232.747474][ T3003] siw_qp_sq_process (drivers/infiniband/sw/siw/siw_qp_tx.c:1038) siw 
[ 232.747486][ T3003] siw_sq_resume (drivers/infiniband/sw/siw/siw_qp_tx.c:1170) siw 
[ 232.747497][ T3003] siw_run_sq (drivers/infiniband/sw/siw/siw_qp_tx.c:1258) siw 
[ 232.747508][ T3003] ? __pfx_siw_run_sq (drivers/infiniband/sw/siw/siw_qp_tx.c:1236) siw 
[ 232.747518][ T3003] ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:161) 
[ 232.747522][ T3003] ? __pfx_autoremove_wake_function (kernel/sched/wait.c:383) 
[ 232.747526][ T3003] ? __kthread_parkme (arch/x86/include/asm/bitops.h:206 (discriminator 15) arch/x86/include/asm/bitops.h:238 (discriminator 15) include/asm-generic/bitops/instrumented-non-atomic.h:142 (discriminator 15) kernel/kthread.c:291 (discriminator 15)) 
[ 232.747530][ T3003] ? __pfx_siw_run_sq (drivers/infiniband/sw/siw/siw_qp_tx.c:1236) siw 
[ 232.747541][ T3003] kthread (kernel/kthread.c:464) 
[ 232.747544][ T3003] ? __pfx_kthread (kernel/kthread.c:413) 
[ 232.747546][ T3003] ? __pfx__raw_spin_lock_irq (kernel/locking/spinlock.c:169) 
[ 232.747549][ T3003] ? __pfx_kthread (kernel/kthread.c:413) 
[ 232.747552][ T3003] ? __pfx_kthread (kernel/kthread.c:413) 
[ 232.747555][ T3003] ret_from_fork (arch/x86/kernel/process.c:148) 
[ 232.747559][ T3003] ? __pfx_kthread (kernel/kthread.c:413) 
[ 232.747561][ T3003] ret_from_fork_asm (arch/x86/entry/entry_64.S:258) 
[  232.747568][ T3003]  </TASK>
[  232.747569][ T3003]
[  233.078198][ T3003] The buggy address belongs to stack of task siw_tx/2/3003
[  233.085214][ T3003]  and is located at offset 76 in frame:
[ 233.090677][ T3003] siw_tcp_sendpages+0x0/0x4f0 siw 
[  233.096405][ T3003]
[  233.098576][ T3003] This frame has 2 objects:
[  233.102906][ T3003]  [48, 64) 'bvec'
[  233.102908][ T3003]  [80, 184) 'msg'
[  233.106463][ T3003]
[  233.112188][ T3003] The buggy address belongs to the virtual mapping at
[  233.112188][ T3003]  [ffffc90002520000, ffffc90002529000) created by:
[ 233.112188][ T3003] dup_task_struct (kernel/fork.c:878) 
[  233.129638][ T3003]
[  233.131813][ T3003] The buggy address belongs to the physical page:
[  233.138055][ T3003] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888700000000 pfn:0x745e9a
[  233.147993][ T3003] flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
[  233.155173][ T3003] raw: 0017ffffc0000000 0000000000000000 dead000000000122 0000000000000000
[  233.163555][ T3003] raw: ffff888700000000 0000000000000000 00000001ffffffff 0000000000000000
[  233.171938][ T3003] page dumped because: kasan: bad access detected
[  233.178164][ T3003]
[  233.180337][ T3003] Memory state around the buggy address:
[  233.185804][ T3003]  ffffc90002527580: 00 00 00 00 f3 f3 f3 f3 00 00 00 00 00 00 00 00
[  233.193683][ T3003]  ffffc90002527600: 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1 f1 f1 00
[  233.201548][ T3003] >ffffc90002527680: 00 f2 f2 00 00 00 00 00 00 00 00 00 00 00 00 00
[  233.209414][ T3003]                          ^
[  233.213833][ T3003]  ffffc90002527700: f3 f3 f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00
[  233.221697][ T3003]  ffffc90002527780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  233.229562][ T3003] ==================================================================
[  233.237471][ T3003] Disabling lock debugging due to kernel taint
[  233.243463][ T3003] Oops: general protection fault, probably for non-canonical address 0x5088000005158: 0000 [#1] SMP KASAN PTI
[  233.254872][ T3003] CPU: 2 UID: 0 PID: 3003 Comm: siw_tx/2 Tainted: G    B               6.16.0-rc2-00002-g5660ee54e798 #1 PREEMPT(voluntary)
[  233.267574][ T3003] Tainted: [B]=BAD_PAGE
[  233.271559][ T3003] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS 1.2.8 01/26/2016
[ 233.279597][ T3003] RIP: 0010:memcpy_orig (arch/x86/lib/memcpy_64.S:95) 
[ 233.284533][ T3003] Code: 89 07 4c 89 4f 08 4c 89 57 10 4c 89 5f 18 48 8d 7f 20 73 d4 83 c2 20 eb 44 48 01 d6 48 01 d7 48 83 ea 20 0f 1f 00 48 83 ea 20 <4c> 8b 46 f8 4c 8b 4e f0 4c 8b 56 e8 4c 8b 5e e0 48 8d 76 e0 4c 89
All code
========
   0:	89 07                	mov    %eax,(%rdi)
   2:	4c 89 4f 08          	mov    %r9,0x8(%rdi)
   6:	4c 89 57 10          	mov    %r10,0x10(%rdi)
   a:	4c 89 5f 18          	mov    %r11,0x18(%rdi)
   e:	48 8d 7f 20          	lea    0x20(%rdi),%rdi
  12:	73 d4                	jae    0xffffffffffffffe8
  14:	83 c2 20             	add    $0x20,%edx
  17:	eb 44                	jmp    0x5d
  19:	48 01 d6             	add    %rdx,%rsi
  1c:	48 01 d7             	add    %rdx,%rdi
  1f:	48 83 ea 20          	sub    $0x20,%rdx
  23:	0f 1f 00             	nopl   (%rax)
  26:	48 83 ea 20          	sub    $0x20,%rdx
  2a:*	4c 8b 46 f8          	mov    -0x8(%rsi),%r8		<-- trapping instruction
  2e:	4c 8b 4e f0          	mov    -0x10(%rsi),%r9
  32:	4c 8b 56 e8          	mov    -0x18(%rsi),%r10
  36:	4c 8b 5e e0          	mov    -0x20(%rsi),%r11
  3a:	48 8d 76 e0          	lea    -0x20(%rsi),%rsi
  3e:	4c                   	rex.WR
  3f:	89                   	.byte 0x89

Code starting with the faulting instruction
===========================================
   0:	4c 8b 46 f8          	mov    -0x8(%rsi),%r8
   4:	4c 8b 4e f0          	mov    -0x10(%rsi),%r9
   8:	4c 8b 56 e8          	mov    -0x18(%rsi),%r10
   c:	4c 8b 5e e0          	mov    -0x20(%rsi),%r11
  10:	48 8d 76 e0          	lea    -0x20(%rsi),%rsi
  14:	4c                   	rex.WR
  15:	89                   	.byte 0x89


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250722/202507220801.50a7210-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


