Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AFFC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 00:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17EDA8E0002; Thu,  7 Aug 2025 20:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108758E0001; Thu,  7 Aug 2025 20:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9D328E0002; Thu,  7 Aug 2025 20:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7DF88E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 20:21:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47E265EA4D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 00:21:58 +0000 (UTC)
X-FDA: 83751687516.22.9B764CE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4DDEE40012
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 00:21:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RN9py7Gz;
	spf=pass (imf17.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754612515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2SaOtUC6V6cEAw06zeUq6j5F9df9SNeFttF+xxsRFs=;
	b=iyYmxOLi2OcGqSjTCQgL18ZAaf0RaVaw06sVK7QSoeJcLUJbNtihO7ik36gUv63yjcksNd
	rjS0IsQ2CGdweaQVtkCzEbl/sBIFaop0g70/4xHMKth/CmipPvKunuAhE0IkxX9ndkJD7y
	uKnNeLHl2RsYAxdkU230rHXCT6z2h54=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754612515; a=rsa-sha256;
	cv=fail;
	b=t0CMuPltyp/PIed7ZnhKaGrqMuPeWcouLppTC4icchAwaLr67onhY73m1SR2xmkgCCH//x
	CwtjANWUPjV/besLHdRQwGt6EJpFfYnleDkxpib+a+ljZDR+3b0JQm646CkRtTVvfgxYE2
	X4U0yENGvNR56UiBtES+i1YVwS12A6s=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RN9py7Gz;
	spf=pass (imf17.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754612514; x=1786148514;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=te/dUd1OcVP2mdN81NEW3ytKiLNM1vRGSyiOEyAq3yE=;
  b=RN9py7GzFqA2+91GTSQqD5E6Rabnn69g1UrQRnrNbt++jLhZCWyvYiaa
   350iQRwg5L9000eWDpZmNwKsPObn+f6ACVbz076C16zacok0kGiDR7Y7W
   S3DdJzq9WUO4rm2qw6Xw9C9z+LKwOzQZotnzgcKgTNqSXAbW5uEf0TOGQ
   UykSfbUSlIAoQRKrDaGJ9FtHljWG8NWX/ogGgHOwrefWvXEErjHrVxYrX
   D9eV6ey/gvBtdkeXkHpCxbE9A8D4MNiezuXma2V6RfV8nKBXjSDe3HsI+
   vNM3ibn/y4C8v8uVNufIsYk3S1hvIM2Js/wkx4f10O7KrmEgCXfkA3Tpb
   w==;
X-CSE-ConnectionGUID: c8btAqR3QgaRXgcKXBS4pw==
X-CSE-MsgGUID: czMQyG0OQfGhXdEQX+q9LQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="67227097"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="67227097"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 17:21:52 -0700
X-CSE-ConnectionGUID: 93Og9n89STqsgv3fTjEZwA==
X-CSE-MsgGUID: EmlnImYGQeqYREoFeOnjmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="169655498"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 17:21:52 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 7 Aug 2025 17:21:51 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 7 Aug 2025 17:21:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.75)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 7 Aug 2025 17:21:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jClYqPYyAYs6I8PsuvYHPLeqmRjifloAR0zrWNgURdD0njR8nAcpgpFq/OumKVgF5IXZaEG9gMJGEY8PUQyRbm9riHh3GeEC6i7h9yllGr9yhBmDtJaLW+poPAuydsV6k1Q++DTmYME1W1FwVrrsGVqWjNHgwwKr6q1cdWh7VHVgyKQyx8HbvCuufHKim/ZN4MeUJ6YxGzRkzOXQNg8RoAbOLJ+pwGHTebzGXpHgYOqipwNhVoZXOFD7Ek2KHX6ahKnLWJn5j0J2THUP69HAsj+nJ5Nqbu4Pa2jIWLUS88iT+0/Os52Fa5DIkCGALVAWd9LB4HezXx42VJsEtl6Khg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2SaOtUC6V6cEAw06zeUq6j5F9df9SNeFttF+xxsRFs=;
 b=ACwrW87mpHR0i/jhm0/vgcKscXf7ME9KDZ/2AkkMtt4pnmEzbcfSqyYcumyfPSC0A3YMVkZHiqZlryL6f5qqr0MI9hXLQ+2hgmqmeUb8eqF8JEvH9VpWHHgKChnDABxLrjEuKJgpnIuLzOXu6wmhZh09HPOmDSrXOF/LEv+0JDNN9yqh5XefDoRqrETRxjvW71KhZj4muUd8X4x+OMN3w6hEQErwBboEZNr6082B3Hd9fNtLnZr6j3JN6S7/orMJqX3BjaW5DN1IW3SqWTWVWNBQcSYR1xk6YlVdcsIrcCbLVSI9FrqaR1vLPkv5QIUNEoinILCsJ4aCUJNbq0GD6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA3PR11MB8119.namprd11.prod.outlook.com (2603:10b6:806:2f2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Fri, 8 Aug
 2025 00:21:49 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%4]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 00:21:48 +0000
Date: Thu, 7 Aug 2025 17:21:45 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Francois Dugast <francois.dugast@intel.com>
CC: <balbirs@nvidia.com>, <airlied@gmail.com>, <akpm@linux-foundation.org>,
	<apopple@nvidia.com>, <baohua@kernel.org>, <baolin.wang@linux.alibaba.com>,
	<dakr@kernel.org>, <david@redhat.com>, <donettom@linux.ibm.com>,
	<jane.chu@oracle.com>, <jglisse@redhat.com>, <kherbst@redhat.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <lyude@redhat.com>,
	<peterx@redhat.com>, <ryan.roberts@arm.com>, <shuah@kernel.org>,
	<simona@ffwll.ch>, <wangkefeng.wang@huawei.com>, <willy@infradead.org>,
	<ziy@nvidia.com>
Subject: Re: [PATCH] mm/hmm: Do not fault in device private pages owned by
 the caller
Message-ID: <aJVDGSUzuKgy0PtK@lstrano-desk.jf.intel.com>
References: <9ae3e014-c7d0-4d58-af0e-925bcd9e4cfd@nvidia.com>
 <20250722193445.1588348-1-francois.dugast@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250722193445.1588348-1-francois.dugast@intel.com>
X-ClientProxiedBy: MW2PR16CA0057.namprd16.prod.outlook.com
 (2603:10b6:907:1::34) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA3PR11MB8119:EE_
X-MS-Office365-Filtering-Correlation-Id: bb7b5fc0-9e4e-4403-c51e-08ddd6119096
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?niYZNoe5NIybBUfV/ef7SM/LtIGMvvzxsk+ENGe7Rh6vIrcuhd96GoNVL5Md?=
 =?us-ascii?Q?0hhHMBCjUPycDIhTFlKNsL/W3LosJ3U5Lku1+T6gk/TEmpvEH/zFYTWDaUJi?=
 =?us-ascii?Q?yOY9RJYVPfdzQglODJajjF8qok0z+gtfwAobtyo/GF+RO+Q1y6Aw69Izl210?=
 =?us-ascii?Q?6JISwnWaV7jDMjz83SAH/rlaGxAK9gizrMGrDsHT+SMwpRWZ5ov3kX0Klls1?=
 =?us-ascii?Q?ZFZP4wBh1Tee+C4rNVsWiyJHSKFOKJR60kyC4wAE1xOrhnlou2qscL9HLjHg?=
 =?us-ascii?Q?GbL68ytawZlBaJbpN3knplrqMRXvYUVkL/9VCcBVmbHBvWVVcYOejy4ZoM+T?=
 =?us-ascii?Q?d6tvDfI8t4RB0B7yAASYiOWBERXPfD4Q2W0rwnjSGb09zrzqQNO/8WDLvcuU?=
 =?us-ascii?Q?Y/6Ee/pE3Qr3oav2s/MrovYe7N/5w2a/vWsLkdEQeQpvCOcWTAWo+t2oNctC?=
 =?us-ascii?Q?mVSErCpoC5MHHuxqKHz/d1WSwMsvq+Y8MYIH2ixfMYMX1Sq3uErByn0NxGiC?=
 =?us-ascii?Q?ngudDguTONUl6LK6xoq91uHOlfqsZWnyTWGcsxJWCq0h5GkHIoEOyqG+9cTq?=
 =?us-ascii?Q?6rSaWlcufMbWYrIIZe2OPwaYqJhZ5qvm7tM5W4q6nwWYfz6jdbiKu66n20iy?=
 =?us-ascii?Q?r25zXTAiOrpxeERkRUUvYwnx0Y+tYXQTFPsFItmVip9xkspfn5/tk/RYngZ6?=
 =?us-ascii?Q?RovUQi7bb4ZpMVja2Kh+MuhSEARIKSYtKv+4YyUlkkFfayJ4AFsL/UGSUsdE?=
 =?us-ascii?Q?c9zh1+MbtXInNcg2q1nSYsRLQC/aJ3n7AMYdkBcdKcSTwJgDM/kif/rYt9sd?=
 =?us-ascii?Q?jktac0gzutQTG8S96UH4P/MQR3f3G2hZB5NDvKZAvhLehX+4TxDE5BMhLAeg?=
 =?us-ascii?Q?X5K2EgPOx5Ncty0TehATFWtxUQu9wvYWxheq7WMU/3xB5xMqb40LQIk4LlIf?=
 =?us-ascii?Q?2w3D2QFR0Yo+nwTg1GXYXQRuaqiqtYAtGCCwaOnsewb+sZiDkCvmrxHgR6G6?=
 =?us-ascii?Q?1ZYBkjz741R9yKj7+WmH4sm4HKEMLKYc63wjiTtUt8YcQ6K/196GCOHDU7qu?=
 =?us-ascii?Q?7tBvzgtbonqy4K/gHgVP6fyOyxXAMyx4ptV2Mdm9GzmgUA77f+HucJA6qpwt?=
 =?us-ascii?Q?Ulb24EwKAVhmceSome4L6RJl9y3KJS2lVOPafrBkCThOb23wk3Ykdjy5Fb38?=
 =?us-ascii?Q?rdIjequo1tmRQ2Ps4KO4PX8zsQlA/sbsnCVSCnWalFIAtjF9MDdMKiF5u2sn?=
 =?us-ascii?Q?pvTPet1zIXf5zZFk+dDtMJaW27An7Uvz+3JJr3/tRDm+a2k6L0FWDXgBlNWs?=
 =?us-ascii?Q?4YT5uQmO8+toAkA0WIKZMqjr5LLwQqaxkskgq1yl0HWDJ8g8wt/KA0OAUrGD?=
 =?us-ascii?Q?AcqnsnfgmzZ5L0zZ3/m/0qbDj7nDlRe1d8nFTRIgh4F536tcBQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SgsConv8imkP2Wonj8PsFqNmMjhFEea2QexfxLdkONgeprNJIJc8QTR69ahp?=
 =?us-ascii?Q?+Qozu2gugzcGEtxorT2T/A8PSVKu5uuQMstV6vIsAguygIjTLUl4IR2xyfO9?=
 =?us-ascii?Q?AdHqq22BVm0jgsKNa1G8rHjTd++jl9RSmeOvKjpUKqzt8LzC2uMlKqDb5jSU?=
 =?us-ascii?Q?EpuKvnzDREiOV1c+Ven9yXbwtaN2e3wvmYA1jv5rjaylIR5H+YTVS6luXXGM?=
 =?us-ascii?Q?9jXP0TeNx0zbqSyb3NJESjaMHsVZb1DI5PhSTOuKrk3qqWbD4Ao8BkjQK9y8?=
 =?us-ascii?Q?yzayx37KKN41VabR+c7o//NRoxtBAmEzbgpeCotodfbYRA+LDSQxZan+K2RJ?=
 =?us-ascii?Q?BACWAcr32WaM5WFOC862nl8xK5pmKURcRKWRT+T1SY0hq9syFL2DR588smrI?=
 =?us-ascii?Q?TCo3Ua7mvQNFurjisWMMZYqMYnw7W9A4NxwOr2+vxld0qTH0R8i7UKK1HIX+?=
 =?us-ascii?Q?AQM82GA6jv5HU1rtUN6wQVSPO9IDSnSlfdZsl8FpQtJVxs3AMqcgESiOloLW?=
 =?us-ascii?Q?onX38ViCjWd49rRu3MA0H6QqRITlga10ckogJ2ckS8MIYa4glkZMezPUjvzE?=
 =?us-ascii?Q?nr6frdEf7ckN+Tg7EBu4gGq9uc+nTGk4D/poL2OrM/q/ToQMslBpZ5eU0jUh?=
 =?us-ascii?Q?IO0V4V7UiuFEBhWGz1ccZRDSw2kz9dMC4UkxzOcbBCztywC1psiE84Oj1Nb6?=
 =?us-ascii?Q?F7JElHlz8xRhU1w0xQtPv50ll/M9U61Cs2AvAgpWf3axRjw8WxMIcwVzYLEU?=
 =?us-ascii?Q?P7qS5TnATDD5DvXQ8d1l8yLkU9v128/O/MnIaXXQoZhtrhzRfBaq8eAEtxH2?=
 =?us-ascii?Q?C+HVKjNHhMgC5ImMJvd0xEo+RkL5l73hJPtu7zHgy3Fijo5/bdW8v4WZUXGg?=
 =?us-ascii?Q?kFLi6vgpuM5s2C/OU7ALSXo/K6y1sndk7IWxHzxYpBjhm24tiLsB0ZsiMDBw?=
 =?us-ascii?Q?k2NmUvACGLCjnGk6NWpc8E6okUk7m4nvjbPc2QYDYCIaNN2Lt+NIw71gaSCZ?=
 =?us-ascii?Q?czYWbzHuUmPcPfmJE+HkQLSDwe/Y1fg5/xg5ioB8SS1bh/QeIXFuz37HJi0y?=
 =?us-ascii?Q?lXz4K+HZ9+4O7c/EhckhJYwWB5dAIo70idQhn/zsGIuzsbjjk6Sv2cpBj0bf?=
 =?us-ascii?Q?Eka2NY9McTdss6xZgsnkvaNwAjGnNhmSWH0Mz7X8w4lEAZyY4bm4cVJTKOAY?=
 =?us-ascii?Q?5QNUnwQzvS7UfSrDvQfXp/3Bjcb6HDICicrI6Q/Tj3QRqljPf3LQLVE9xZwB?=
 =?us-ascii?Q?4LdTBJWBRE2VNNxvo21uYVVxIX7q+ue1ST7RnaNzaZWnYO5fbnqqHbwA8zfZ?=
 =?us-ascii?Q?DbkDPLyttf49VXIXiKIcqFncBmgPXf4EfIl3kHbwMUt0BhBzDGEB8/Yj8fq0?=
 =?us-ascii?Q?Qju18q7dVWbUWg1TzkdNd0B0kIlX8J0wcO3VeyVTK7bsD//xncIZlV+22vyr?=
 =?us-ascii?Q?hfkupay8YGZfQIEUlH4t0RvsklFZjMtNtajC6vVs0YhgfpA6vGMRGmOiBkWD?=
 =?us-ascii?Q?ZXvoCpgyw8WPs84mfnNu/JTCA/sjmIdMowBs7xmSDxJD+6rhexetOXC8vMmU?=
 =?us-ascii?Q?/WBwXV/JImYGQGHv7VrldE2imbm2QNboTPyCw6I/ZYjz7NF9v+Jn2H6bLwgq?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb7b5fc0-9e4e-4403-c51e-08ddd6119096
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 00:21:48.7695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tl9owmJ8hNHirfVTB160XFiz9SHIWXgdKt0DV7sXuyaQfb94SGlXR7TY5nXlwLnMPKR8LOdHBtNXHTYsDkg9UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8119
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4DDEE40012
X-Stat-Signature: 6qwknemerjz7konmso179c3k4fhbs4fu
X-Rspam-User: 
X-HE-Tag: 1754612514-832289
X-HE-Meta: U2FsdGVkX19upmAPivBuDs6bcJsU3Y7I4dHElfb0GKP8IGwhEXAO6S6SxdmT0X3A12CZ1JRCOZltHjCVkXdXonTT3cOiJrqvpmYKxDXWPzaOzF+FTuBY1H2sF+3WVcauIHAw4LklmMDNaZVoIfIw3KzbzRF3IUnBo1+lvKsBM4iiuJV0QDej2wipnBfBQBmfGx++HTYSBcKR/N1t9qqjFXDZaHfk3HWQGpt/ssCFUGad3GgLadFIsvdIViqoNfGPKN/61VuFjEVfb0PYbVqkLwdXXtuElh7nupsx8h+0NDYmAcvuIF1okKCkvUuEGMP3+yISHQh1e5WoJIAg2N06XaA0EH1oToCJ8T0XYzW6MDmqWhXvN8tXwA6SqIuDXUIGY3HjpPjbmIV01hvtZORo8sIjoNQncMHhCMJLSF5Gro6puZTXORzkltmA+mLXbDmCzVpGvBNsRgeOO4a9ZYzmSCOHlQ1o3WcN3n1bs91BHtAV7Pqztx3XLI18rmgJrbil5AydDEaGMrzOwjII7aZhyzNhEl7vBxmYVEbM44iIiuOmWts1XXVf+gu1+x//sJx9MwfhHJVHjoUC0bZYX/EAdtl0brfj0jrHjUithnjhzxCZHOGb9ov+ize9bkIGGJQhMge3Jy1qWUeKRyR2UD23D9SPpN/tA9Dj4l1bDn1BpfrN+nsMS+12RuquwHRInlnS0s4stKiQHNFnmA5xJk07W6DTXMDECzi5u+OsgkJnGxNIlGNRsYU4HJ0O7wf/n4NWReZzVckLagDWhaH/0edbOOV9pcyo2D13J/D+lsn9r1r012njP9akzDSWtGYlti8tuB3XbZ8LlKqbqAIMQ5teFjUj6pTg0IoAray/wKytK9Pa1nD7Vh2ijd3xQYT1XkSX8bBU1ean7kBijF0bEk2Cq1JmFWb6tHKpk42HrkOUoMmqcgUprRu4uzG5wqRwCa8R7FgJ4vFkM1mqM87csL2
 HsjBj0M+
 jx9y5H42LKtYfsDfrJ5LYbHHizHotBoulSvGasbR+KclaFPyov2XOwJ0In8gKLlJBxmlRo4fQBacGYWQ/BojbQYHThnYBbnjUKmkI1wccEqzZP1tJ2RNMwv9whHd8P1rwMPfmYpat3zFuRfWgZlhaSlR/XU+Tdu863zs6S2NLRjg7fZVZ/2WYMt/Rwl2fwFY66ucZwe11U7etFRH9Ku189+/lLotW7OBKJr9LG53l/3g7J43otGRCAGfzBpfrVHGu2Dpejr5Vi/a/mzZQIO+hOzFk3AsiTB1tqBYlZni5cmwZ8Gg2j3nTQkTJF5Ukr2iPqXag41doP8KZR3Cn7OVzZfUpuMA2CxhlSHysfg2kBvYbXdBOSK2VAVOg67rjGJgNbjxvxmGIsJTrH5Iiso113QRrJ8XdJqdag14Qxe0h+AoFEonnCUs6hVwxjI2OvHNZ2n6TI3Na2RqBuHYyxLdmC6+ItVKLS7nDiqMiR9Mbfyz/vhb1hD5jDaWPPzdB3CfAqFNZ8vcRsnSfss1HorjyDcpdIxo1BLSTRxpani23bXcko6sNQILHEn5bHRRAG/LN9j5fJUFoso+mB5xnVKpQcMmmZ/FdNiuyi1R5OEkrfX6kTl5X821/fHl+LZB2G043EfKW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 09:34:45PM +0200, Francois Dugast wrote:
> When the PMD swap entry is device private and owned by the caller,
> skip the range faulting and instead just set the correct HMM PFNs.
> This is similar to the logic for PTEs in hmm_vma_handle_pte().
> 
> For now, each hmm_pfns[i] entry is populated as it is currently done
> in hmm_vma_handle_pmd() but this might not be necessary. A follow-up
> optimization could be to make use of the order and skip populating
> subsequent PFNs.
> 
> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> ---
>  mm/hmm.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/mm/hmm.c b/mm/hmm.c
> index f2415b4b2cdd..63ec1b18a656 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -355,6 +355,31 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  	}
>  
>  	if (!pmd_present(pmd)) {
> +		swp_entry_t entry = pmd_to_swp_entry(pmd);
> +
> +		/*
> +		 * Don't fault in device private pages owned by the caller,
> +		 * just report the PFNs.
> +		 */
> +		if (is_device_private_entry(entry) &&
> +		    pfn_swap_entry_folio(entry)->pgmap->owner ==
> +		    range->dev_private_owner) {
> +			unsigned long cpu_flags = HMM_PFN_VALID |
> +				hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
> +			unsigned long pfn = swp_offset_pfn(entry);
> +			unsigned long i;
> +
> +			if (is_writable_device_private_entry(entry))
> +				cpu_flags |= HMM_PFN_WRITE;
> +
> +			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
> +				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> +				hmm_pfns[i] |= pfn | cpu_flags;
> +			}
> +
> +			return 0;
> +		}
> +
>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>  			return -EFAULT;

I think here if this is a is_device_private_entry(entry), we need to
call hmm_vma_fault.

Matt

>  		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> -- 
> 2.43.0
> 

