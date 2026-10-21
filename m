Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E47606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 01:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UyNp6vWa
Received: by kanga.kvack.org (Postfix)
	id 445226B0597; Tue, 20 Oct 2026 21:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF0A6B0598; Tue, 20 Oct 2026 21:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2704B6B0599; Tue, 20 Oct 2026 21:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1BB16B0597
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:32:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 643D8C041E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:32:13 +0000 (UTC)
X-FDA: 85344907746.27.CBEC29C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf24.hostedemail.com (Postfix) with ESMTP id 88258180002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:32:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UyNp6vWa;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of philip.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=philip.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792546330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5RsMNXArVYqGN+S8VYLIOXH9gIm1UFEKfS7YzbLOf0=;
	b=NKMssuLemM2sY4FzXzFeceL0wUSSkoy0OkkHF8Pap7sllRawWsq5gOuHIwaSHjcW2aQlET
	YEOihz/cMwRvQoehRrvbSuSU9XiobO9aH0Zid4hRLzt4T7PRNbRvqtlBlvAQcEXwTon33w
	6oOvmtaf2jiByCHsUbQ4oU/+LMJsCkU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UyNp6vWa;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of philip.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=philip.li@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1792546330;
	b=MzikuwsX96Ys1xHsoyFLmymHX8RgzqZZH547/x71lbUhPrRB9Rg9W1b4C1rAjxAC2mqaVB
	ZJm2xOt1IN/VHYTR2PSH1lWbpjvAyeFa+IIHY+tsbqHgMotUb+a1iH7UIWvDcUHigTtvVy
	uveVB9gBbHi+DAkFpv/6ZGHVQ/XLp9s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792546328; x=1824082328;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+xr7D9w5F/pFkAc1TGZXBGUR2j72lSNqnt+ivGdfoOY=;
  b=UyNp6vWayYb5pwSIE1Qd7Uig6O80JA23H4Y+R7NmGhXoCbmqTzhq0p8O
   RPaOdyEjRug9V1f5GaTGy/jAAtCECIussBWVrW91XQyCtTYDdG8VGPV0a
   6emhnKceKoeOsTHR5t7L5RFe3aLWfil4BRqf+lbvFM8qthXwGW3FfTals
   sVitQp4sN4T6DxGx9Ho6x8sphfmbkr0sy+2orz8zupb7dVUPzlF3YgoHW
   Aq2qG2J6e+QXWGMEJ3CdlGl6BDMzZu4vxGtYfqEFIpmA5cJfTeatCdnXW
   2upf7RmfiQFTOwhOOLWnMvDoxELw8djK4Z9SydmWQ3I5Na14nLpn6ZzIN
   w==;
X-CSE-ConnectionGUID: xXcsAvmBQkmBPqjxAbALLg==
X-CSE-MsgGUID: SUiJy5KOQ4aF7jFrXpPcHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1137009"
X-IronPort-AV: E=Sophos;i="6.27,169,1787036400"; 
   d="scan'208";a="1137009"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 18:32:07 -0700
X-CSE-ConnectionGUID: XXegvsyLRvuhHhaxWR4LkA==
X-CSE-MsgGUID: SYqggdchQtulY72BfC7s0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,169,1787036400"; 
   d="scan'208";a="4790742"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa011.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 18:32:07 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 18:32:06 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 20 Oct 2026 18:32:06 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.48) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 18:32:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pKzzCz3774lAQBkGwXLS4ExgcOOMEK39JW+vDDkxirP7pSv4+R2xWHST5jaZdI02HLKla05myL827LteA+vDdsZZhboLzCvykM1r429Os48yJkJIhrstkDs0owse/eoX0/lXFZTHzTojoFcOb58vA/J3MO9kbPjNdCjbN0AAyXUypRXIfFu36h2HRwJot+1NIg/hVtJx/gn4N8hfZjg03U4CvjDqGcBpr5o5cGmMwj4EhSjIwG1FJgYqpcKhPSFCjJQX6c3osWmeOW4y/3hsu/6G7kZjBY/msFQ30XBRLpaj7w3HKnOuW9hOGnDTttHLmeun2OJPvFbtsjVOgDMiYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m5RsMNXArVYqGN+S8VYLIOXH9gIm1UFEKfS7YzbLOf0=;
 b=Y7gdbhF0JweM/OXXSydAa8/so+J/z/BgXlpiSC1Ut9ysrugwomuSNDz8xc5AD1IsAyBl/K7NyKGIpMTgGFuA2/Yw1ant2s5pNz8UMx0uPaqpEt902XyYUYDNxvSFpfM2wj66g3214YylHAhagRU7WdDF1SIfunkvt0sjDt7Ht6H5E93827dCPccdCp28nCq5Y08nVKpljW1VzwR6whtWClDQtNWn4w3DKmV+N4ZTOFy7vj9xu3QZjxIciVv1UbxMi/96xTGN9QsaQPgIxqoSLcUn29v5HlYwKIt5tU59duYNN9BnVuXixv4jrzcznDv/xi61424C+ZQBUtbZBZMyFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS6PR11MB362586.namprd11.prod.outlook.com (2603:10b6:8:4c4::14)
 by SA1PR11MB6808.namprd11.prod.outlook.com (2603:10b6:806:24f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 01:32:00 +0000
Received: from DS6PR11MB362586.namprd11.prod.outlook.com
 ([fe80::71a6:38f9:43ed:8f8a]) by DS6PR11MB362586.namprd11.prod.outlook.com
 ([fe80::71a6:38f9:43ed:8f8a%6]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 01:32:00 +0000
Date: Wed, 21 Oct 2026 09:31:53 +0800
From: Philip Li <philip.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: kernel test robot <lkp@intel.com>, Linux Memory Management List
	<linux-mm@kvack.org>, Mark Brown <broonie@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 3d229ce89862b8e82d71a9e11d6f840ca272a6d6
Message-ID: <atgWCS/iCtGXVa5W@rli9-mobl>
References: <202610210624.L8z54cjt-lkp@intel.com>
 <20261020163928.ce045b68bf2ff27ee10cf01d@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261020163928.ce045b68bf2ff27ee10cf01d@linux-foundation.org>
X-ClientProxiedBy: SJ0PR03CA0384.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::29) To DS6PR11MB362586.namprd11.prod.outlook.com
 (2603:10b6:8:4c4::14)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS6PR11MB362586:EE_|SA1PR11MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: ac4bbcb9-f077-45cc-0224-08df2f131a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|56012099006|4143699003|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info: oK+CQcMlEXKFQi07JkDNSykxwIwMIt5hDuN1zn8oH29TZGoDn/cGiga0gS8LGlElNvxvkSFZQRe89k6i99yqT1PDO7Dnbp5xv3pwemC/EzjLd/auz7e4vWeHICaliIpbJDT8uD2hQr5hETOye6A1/U3oErAY+4cdSIaEqPR2J/+KX74EjOYq3A878+gMrEqFrH/2gD7YQnvzD2egeb5iEels7Sr1nF7mnPZN09eOXAitL/1gzJHk3CkvIPlO/uOjcX3IIcculD4AfSn7lFMkTVxu3KoLyhLPUTVht/6WDccH+aL07ikIYdffTh+q5tXg606RtGqsGpnjHV8EPxF31ILFRtDd7ukImKY/ipyVmJgcusbbTNf5rxdEGJrd5YGZ1lSprM2UQqSaVTBXAUPOEVLI9AcgEawid56EXfnjoLUs6PKGjaX721vPkvIa6pHIKmnoj6VZ7rQO5gC2cOpyKW6Nu91NOTY7fpfdrbH09KEycN3MPuFD9UiT7RDrwxXq5CI29W7Qe2sbJjmyL3vyBG2VADwTF8nx+aoHOnikLy22tLNsyjeA+bnwEBx6amKIO3BW11XnsAPr4aSYL2AKJUAaTeN4UHdzaFUp8TW2KHgcFJY/HKb357vauNqd8hhG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS6PR11MB362586.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(56012099006)(4143699003)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uetk/1kIIvMM5Zmfh3QehmOYmuT1ZkypSrqXkRPjlm507biMNSvZsfd1d7iD?=
 =?us-ascii?Q?UpcSt0zC9UHskcJqgDXgZNpiQAjS5gQUIj7OwlbgOE/G8UDrZJRzGBYxGVyP?=
 =?us-ascii?Q?UUebTGsHpxi3ZAm9gHVlOn1JUa8NiNtVGlfke8ZBIvH0chQu9Hgqb0O+azy2?=
 =?us-ascii?Q?weBXaEmY1yVYRG/JSRNzCC1FUbQhd5bDyv9RN9vT5eZEkJN/4vifwZzmq15O?=
 =?us-ascii?Q?9bp9q62IGlqXDCgLFEcyliBZMXoznaol0byHaPIsIZAdzWZLij9mTXtUdsV5?=
 =?us-ascii?Q?GGWqLHuwKb1rnjFOe5uJ8UUPnC3+Kx404CTcpwzxvejdIfaSJqF9O/n1D0HZ?=
 =?us-ascii?Q?/Mk3ujwdcBYW+G/ycjsdRRpl+Ae/rgABA7kUuBu+T/Z/HMZ4TAn0SxgOl1X+?=
 =?us-ascii?Q?tqlqzKx9I7VoFp9j0RzkmH7sJagQn/ipLPdW3VMFrDhrZNy729oSUMp7IOCh?=
 =?us-ascii?Q?I0cSDnT6vI94AHA+P6Y24WuC77Y4/dpgfGBlyIgD9Z2HFX26RFHNScfO12uS?=
 =?us-ascii?Q?5+n/rLTpDeWE2stODwUVub2HYHrtemMKGP5+bVWG2bf6POnwDkybfO9Ugi0X?=
 =?us-ascii?Q?UoWsOfAJvppYVLOvxYNIC6oEcvQMlUf0qVYv2cG309kx5Np31XqHUKtyZ4rW?=
 =?us-ascii?Q?5bvgN7z31woT6Lf7Ux2gWdMcvFt7VpTtJ2NM93s4+Z9dQV2JzD4CEHYuQvC6?=
 =?us-ascii?Q?2jJVfX63qWeahnDiy2XLcKPZZU0GE3E8FFA2mu5rcseWLrJNZ6Y93oz/XIRI?=
 =?us-ascii?Q?O0vUUoKavVZx5rh5Eqb0ZvuDO/b6pso9qPo85mpQ0zu7S7PpFUbCU1my2GbG?=
 =?us-ascii?Q?T22sg5HnSRWKerG4ZI3g6rVvkTJgj0NnJDQckSBVj+kXj27IH/oK5qkYHj4S?=
 =?us-ascii?Q?/2EimFkTjOhIJTfVa//AGVZJATLGeovZJen8cpK+9FlKbKXxOI2U79UBWhvs?=
 =?us-ascii?Q?g6gRTUH2S616TMyCaSE/iFA/hN9LMtZWesHLYk7uIXwez5l1myYJtE44JlEx?=
 =?us-ascii?Q?KVZbi/ymiedKPvWMIPWivYeA4YSZav3aaFV6PKuLloRn5dCIYMJ+0hqOnIDM?=
 =?us-ascii?Q?8oPV6NdrgYnBuSiChmm2GoaA0QWevajsQWCtey5SPIEIL88YY11Y4CIS1VKc?=
 =?us-ascii?Q?5Uwl0sJXCbKiNJ/N8vNUBFgNQcvhCWtiso5qgMH6/foZM2ARXqNyBdr9Q3NG?=
 =?us-ascii?Q?oUSpgf0cW4CVxg+zklkICOVr5rkAgXHg1Xs7K4P4SD7/WP8YanI/DQDdTm+j?=
 =?us-ascii?Q?BwNPqzkAxZqq7a0dfhg0T9SimFifDnU2puShmm8Mc8JYvNZ/0RKlRwVxom5y?=
 =?us-ascii?Q?HHnvvBdCDU9sWF5lJgJ3lmUZQ0yhllM7ohaQp6NyF6b3YdHOKO3cxcBNQdQo?=
 =?us-ascii?Q?AykYOtMYWS60YhJ547iEEjm7hBkfIM9c3bWMzuFMW6G8MvnC2Okw0dkwWLA5?=
 =?us-ascii?Q?Zx7yQKe0hbbNnaCOAA+HMkTGgJFlGuXxJqTPC8r4oVJmvhzhVwVcJC3pCSXr?=
 =?us-ascii?Q?l00c3g4VfQ1K3X3Cb2kiX6+j4uMpyByI6Nbk2Wkufo3oE10Z1pX25sm9CXGo?=
 =?us-ascii?Q?rgeNVml2NL2uqhT6gqZ2+Rz1bT/IkefkDaiTnoioVyBcV8UFMFncRtCNjXfz?=
 =?us-ascii?Q?j3+oxXmYp1+OR/DnRE3W4TUVrwc+O04KH+B8Rqhq7YNXrjfRptb/H5y2cLGg?=
 =?us-ascii?Q?At1/it7kyCg+CgZUodvurMITC05NOh+V+kvLA4RuxeBVzihk9a/X2amrBMZF?=
 =?us-ascii?Q?zQBzgMI14Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: cr2dV22U5ClHObOPsrwnUZH0Q1aly9kFANOfd4OTS3bTES0pZIHSMIIiQdEkOs4aqekldT3EnQYzXgOpg19lEHHKZ54vIPhvfDYzxrmW5yOl6bZtNtjV0DrWOy/mr7A43ZnP+SkbR73+eDhWPfXov1hcivxw5Fa+Pu5Xg0SpF3w9sscRYsgb8M93Ee0GSnrI8/lVuLBcVSzk0A0Y+70WliTr1gFMzjN88xRACEqNhFXMmD50enRg8a/EWVjKxAWDj5obLRpEjkpp0RSjfvlKlECFo9X0cEYI/0Rk9G4GAl+tdE6d37YKFHvFRXh1d7IafStZSol/gAwoQ236MrfdQQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: ac4bbcb9-f077-45cc-0224-08df2f131a5c
X-MS-Exchange-CrossTenant-AuthSource: DS6PR11MB362586.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 01:32:00.4084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2sh6fFs7QiyYbeq0E9T4H50ToFoWUoQpEZHg9fu18V4ftUTjkLOO/aLmFnbVql2m5tVT7RK3GCBizDAyN23ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6808
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 88258180002
X-Stat-Signature: b69be7erke93px953ndd8o47s6ogra9q
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792546328-235368
X-HE-Meta: U2FsdGVkX194YOnQmW7B17LugA02RIomSLu/U1uIRAktyJPaCLzEXcB/Q3XBkIHgeo9PSH9svR0j3AeoeYi7htIlzLoSAO6LHJKuyhuYLdqOvXyGKOVzhL0X0cIaDjZ9R9ixayAsPHpp2bjZUgjquVd/DnPzTVDfkL4rTFSLdGT4pxGnUcVXkLLmdJcLc1PyLoerosh9rlQ3DwiR86qHnTdIhXjCN9KktM3kOaqOOB/WMLW4MV6PDGCNjkk8pYCqrwIyukOfqMiRC2Ixdn8OFjuyFJbHWulra8yK6B+rg3N51JVRicLk6K/5OIIheUYzP7gyiIXOpbYEt/f/xHQYMdlBfkCMG3dEobx2+IYzOtM3ZqmEJ06IxTxzYgwe98DErZvMZIaHUjhkhuZofwrNyfbtDswWLoFjiuHJQm11rZwmbw3XiMFZ51pvSqoLzpkLOEEgoGk/9QHPFUXrb4lexwB3bVxDBCLPG3ne1y0ZT61b5VBDwjYH+F4q8ajIwBAP+ZZE0DJjrH+kqarzmCnV2bD7NFJOXivW6dcGUGZmPoFzvNTbq5/+vYjNpbMWcPzCj1ys7wVeYO52gn/2aLP+T2HMyWsLvPR6Zj/adxDGRlIohFbmOovVkwwa5DBfvA6sDHAZT6jF5hS0iD1orkD0/myXoj9R7YQnAFcmHfY7htdG3aDJBKuy8+XDBsdIiPwcvYctKt0+GWnKR4cyeZHEzX5OOJxqBype8QNZGlZDxzQr6aP15WMKLyvJui2lHiGJD6S0w9TKDuoX6SygxCbMHv2nD/BmfYsWsJSQoUXvHcLopkwZ8zVDJuq4YxBmqhgt0hJNIs+8h4Rv1iFdRFvZpF1vMeryEG3FPjvz573t2/kFnDtxpSUFa2ws5OGHf1yvyccipA2tVekS/GQU3IVPt/QBRR3QyUBMGWXXflL73JpuZ56Ww5TdU/57hg9X6Ewi5doFfHXVqA2VpXqmIxl
 DcWrdEvX
 62wxxdEoAcxRKiOsITl2SrpH2+COofm+VG/M2zvljo/hTQsVuXTGyvhAlNAZwXXZ07Vz9mONwJtJAKSKCABAAbUq3Y78JAcBuPYDujn+je4ea8mUkAz01o2GhUp1uhrXYPgH41rSMnciFn/9BwcvrviLQl6qF2Wbe9LomIYiVV4TPpb9hiqEwioHTdMYTGZPJ6GCiirIPeEIEmoMXly3ofoL9Rtn69O4BaKAJzWe5Y6TKmzrUVCufQdfj2Ici4ZBxEKEZVGwhj3TkCSaeTWGJ7YjeEtk8dJlDjSBYtevWCVIYPZirTiFFiU9loaHZEkC8mV50ensQfKw+5w5dIUahGkFeBZxxj7HOYHyl9j8IIKdFyQmzppJOQJleqJzJIAbXeLNzy8vQqKc0rMJoVWchKjIrlmKWMofm3Dzw7rH+GaZH51c40UF5HZT0TUdo7DyMgZEjeNJPALMGL/uy2e7AJLbz6R1HrrbHJvj89PW8xuXO2EnleCeXhVHhos5s6S89wXUG4Rg5nGgtKlW7jDwiW4nJl768ky89vYlk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 04:39:28PM -0700, Andrew Morton wrote:
> On Wed, 21 Oct 2026 06:38:27 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > branch HEAD: 3d229ce89862b8e82d71a9e11d6f840ca272a6d6  Add linux-next specific files for 20261019
> > 
> > Error/Warning (recently discovered and may have been fixed):
> > 
> >     https://lore.kernel.org/oe-kbuild-all/202610210232.uzFGXnjw-lkp@intel.com
> >     https://lore.kernel.org/oe-kbuild-all/202610210332.DDqYQv5K-lkp@intel.com
> > 
> >     arch/arm64/kvm/vgic/vgic-irs-v5.c:1016:15: warning: variable 'addr' set but not used [-Wunused-but-set-variable=]
> >     kernel/sched/ext/ext.c:5178:17: error: implicit declaration of function 'scx_reenq_wait_dispatching'; did you mean 'scx_wait_dispatching'? [-Wimplicit-function-declaration]
> 
> Thanks.
> 
> cc sched peeps.
> 
> hp2:/usr/src/linux-next> git grep -r scx_reenq_wait_dispatching . 
> kernel/sched/ext/ext.c:         scx_reenq_wait_dispatching(p);
> hp2:/usr/src/linux-next> 
> 
> yeah, that'll do it.  Probably already fixed.
> 
> > Unverified Error/Warning (likely false positive, kindly check if interested):
> > 
> >     fs/ext2/super.c:1040:7: warning: writing variable 's_mount_state' requires holding spinlock '_res->s_lock' exclusively [-Wthread-safety-precise]
> >     fs/ext2/super.c:1138:8: warning: writing variable 's_rsv_window_root' requires holding spinlock '_res->s_rsv_window_lock' exclusively [-Wthread-safety-precise]
> 
> I doubt if anything else can see these things within ->fill_super(). 
> What tool generated these warnings?

Sorry, this is a false positive that there's reply from Marco Elver at [1] to
metion this is an unstable Clang issue.

I will update bot to filter this issue to avoid showing it in the report.

[1] https://lore.kernel.org/all/ataR1cznaBt-6ge2@elver.google.com/

> 

