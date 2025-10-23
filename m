Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 463D0CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2CE18E000E; Thu, 23 Oct 2025 03:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DD988E0002; Thu, 23 Oct 2025 03:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 857138E000E; Thu, 23 Oct 2025 03:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7ED8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:22:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 229A3140A2A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:22:37 +0000 (UTC)
X-FDA: 84028536354.11.282AC0D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C67140003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:22:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EVlu+aH2;
	spf=pass (imf12.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761204153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=Pl+R1ksjcmCYjl+t66f9Q+Fi31Vy9zlBXTJtywsEncw=;
	b=KWM8VDkp0VOUhDdDX1QFBiffeUMed08FsERdztR4ZQQyll3WyiwbxY0fYlccKfWXco2RjV
	3NsGxv1Gd2BaIP50Fge0tyROvlRlPosoEj+Slqxs+b1BYyQ3p0onFb3YPK0YgvFTt1ceYs
	ADRFWSn+U3OQ1xG/cstrmHycdZ9+wPQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EVlu+aH2;
	spf=pass (imf12.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761204153; a=rsa-sha256;
	cv=fail;
	b=mPFeRVq+eQ5gCD1/OdNBooSwJBq12UKJW7rFSERDYhPMYZcSvzobJJPW8a8k4BkZeoUUXT
	hEYjZLpTEQGs2vllyIMhyL0wa0UR7hSoJYZCX+BcrkuTpmsPeyP3yaRMrvYqH/hsB7NmsC
	Ryrk25vzX4Q/Jxhdour/fC6VEA+hefs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761204153; x=1792740153;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=GAbDjeb7H9qDzgm9UIZn36O9p9Rx6L34vsDuSirEv7w=;
  b=EVlu+aH2rYs2Xcdq/m+HOn6685DZR9+4RwFjLlh2H908ZEYAR9ePt2W6
   acQK3G8b/rR2Ymf7enr0JgcaGyk7fT/thydRtXRqop1IP6N9kG0B94nmp
   MeyrjLbi8Eh34sE03D2nCPygtxOk0gj7TE/LmnUkejdutcGQrN84CSu7l
   DdJO2A42ZJCD5UQqMkZk61drvYflHDS4fPk6vtEvE5lVrGs/guAaQLn4c
   mEVqYkNb5VkoO0RuRKIHkCfEIVG/gXBB1uqHUDDRUMKT61FXCaqPJd0Px
   pB/eygDclXdWUTcu673cSJvmP9+SH0y7CCH3n/TJ0IZ4jhLnn92YUj7Mz
   g==;
X-CSE-ConnectionGUID: daZ7+c9OT860QBjAq/Mwdg==
X-CSE-MsgGUID: oGoVIyotSVegoMxLvPMDaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67230896"
X-IronPort-AV: E=Sophos;i="6.19,249,1754982000"; 
   d="scan'208";a="67230896"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 00:22:32 -0700
X-CSE-ConnectionGUID: I/zKLharRQqOx+Fjrwy7ZA==
X-CSE-MsgGUID: 7xw6S5TMS2O2CG6lpwvTsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,249,1754982000"; 
   d="scan'208";a="183977919"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 00:22:32 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 00:22:31 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 00:22:31 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.22) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 00:22:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZAyUd4Xh3B0jZe/6iSkEUxj3KTMpHV+t723QfgLdgEFdJQlzZvjeaY7MjnUt8p2GnkbBJSrQCWD8CdjYNjqjoUiUMjVPLxCZEewuR/U3qjzswlsdLkobAKT715x0VGUfpV3XG4HvnXoQXUPZbZZU7LioZ1oqH6wYmcWdB9scDv33uXx6v5XJHXsEal/RAr8465QagRPLRkelMCjp3nuEf5yU3v/tKn0GoREAZBkn7gHm7pD40vfuMTozFaKDFJzpmOIStkJQ4TsjecdkqF+Wl329qn/6SwtYgEZbZmpdVWkPFoodVl5bYO4VggDcmisbp4CWDxsfP3nKUu7vt5Ppyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZwqCYwkXszFYpVn9cZbpEhJSjALonWmo9eKWuVmgjI=;
 b=GQrG6Ma/2ztdLCDt8pIoW/fy5q+W71KNfsoIf1yi8cqAChFWrHfH9aMVsnxbHTCWxaY7RvcymNP1fExPhabCCIV+ce+mv3EZTQrwbPnAh5vR95NEYLfbMVwyLTXi6pkE5MFN8sANqCSnkI50WuIqtrfesbafUTr7RbviDZ8biMFNRiFxB5+OF58Dc4G+fkRE7y7TUWzNkKy6m0PTsM8tka5yH6SAnxQRJvAfVKrMiNd4UMw3shqjaSEWosHuAwvfXmI4qguolX+bd5ag2lczPeOJPIVTUNiQkf4VeB6y6+jubSnqV14osLhx9pd0UjbFe2DqzGBzqtsS5T4R7nzdAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DM4PR11MB5312.namprd11.prod.outlook.com (2603:10b6:5:393::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Thu, 23 Oct
 2025 07:22:29 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 07:22:29 +0000
Date: Thu, 23 Oct 2025 15:22:11 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<aubrey.li@linux.intel.com>, <yu.c.chen@intel.com>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, "Gautham R . Shenoy"
	<gautham.shenoy@amd.com>, Vincent Guittot <vincent.guittot@linaro.org>, "Juri
 Lelli" <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, "Madadi
 Vineeth Reddy" <vineethr@linux.ibm.com>, Hillf Danton <hdanton@sina.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>, Jianyong Wu
	<jianyong.wu@outlook.com>, Yangyu Chen <cyy@cyyself.name>, Tingyin Duan
	<tingyin.duan@gmail.com>, Vern Hao <vernhao@tencent.com>, Len Brown
	<len.brown@intel.com>, Aubrey Li <aubrey.li@intel.com>, Zhao Liu
	<zhao1.liu@intel.com>, Chen Yu <yu.chen.surf@gmail.com>, Libo Chen
	<libo.chen@oracle.com>, Adam Li <adamli@os.amperecomputing.com>, Tim Chen
	<tim.c.chen@intel.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH 16/19] sched/fair: Exclude processes with many threads
 from cache-aware scheduling
Message-ID: <202510231406.30bc8aec-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <637cdb8ab11b1b978d697ed744cc402d32443ecc.1760206683.git.tim.c.chen@linux.intel.com>
X-ClientProxiedBy: KL1PR01CA0072.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::36) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DM4PR11MB5312:EE_
X-MS-Office365-Filtering-Correlation-Id: 1656fedf-b339-43b0-7bb1-08de1204ec5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?D+kO1uIsS+MyZocnsrFyPSJMrqST0I9Z1Kij7cCv7BzPtm51yAuua65OcA?=
 =?iso-8859-1?Q?enzZ4kAEC12jpnX9x0H59Gumciig8+6p3IztltUVmIamy0CHUwBlnBt5ld?=
 =?iso-8859-1?Q?h5o0XIPmQcjpCY4Nlx68vDf0sYd/4qViGDkA9h7X7JfiU5R9CIYHoaHb8f?=
 =?iso-8859-1?Q?It2DR0zBCcfWMiDxrwni5lJ8En1/VQ6u7Wn/E84sXi8afAjgL2fdj0uulN?=
 =?iso-8859-1?Q?k3tGgVfaoK0Eqwf9EcqcX6+hEnQTHXXqsT8VusQB7NbzjXnQLMo4xmS+0J?=
 =?iso-8859-1?Q?TJjB+GuHTn+VyM6sRQQXHlAlTIQ7oNa8zHCYIz71gvA59kPGrITun8pCzm?=
 =?iso-8859-1?Q?p6Tp2tudMaG/NbyoKmATyRj75t4L2HxGK5ZUR3IpUbb+OBhQ8SJo+ZrYzP?=
 =?iso-8859-1?Q?HJG+XK17fnCyhtwCwOqYVcKvTgzVvc4TS69i/w1hDUKFRSFmjygjuDeuP8?=
 =?iso-8859-1?Q?5g70vEQkHSbURlDduQjtgyyItFZZN4GT0JTUZYtFCxgNUDO4CWHycPzqs0?=
 =?iso-8859-1?Q?In2UtrqatKyiRZHQpx5Ti91Z4+38aK2vDMnKqvNZwUqbMe12WVro4gvSy5?=
 =?iso-8859-1?Q?xpfNWJapuYfbjQ54/a0B/lmY1c2I00/P+QFl0vpuzBV1FdPuxowp+wA0Eo?=
 =?iso-8859-1?Q?s+7fgzMAeWqAPDwFcVPYMtNKwlKGiRN7S9xua6OVihwsL7VbhfY98UjnJC?=
 =?iso-8859-1?Q?c6EyeMruK3Q1vVpVKWCIdZj0aG5HQN06CcO39W/VZ7aPIfMxzDUeJO5pLS?=
 =?iso-8859-1?Q?h36R6NJfCMysrbLRHa9WBmCXN9QlhZxs87VMUXvFpqhMt5stGKZNc2jnr4?=
 =?iso-8859-1?Q?MS+ZvVkt866vqhQpVSqRiYOMj4YxD7MtoRWtyIwgdSTOKNrxYhHC4uxsRU?=
 =?iso-8859-1?Q?wO67VVnGmMKzGmPnogsSks20jp5FasHRdCq4PdICIq8cMSvcvG6teEZcrG?=
 =?iso-8859-1?Q?0jT+vdP51exus57+4uRnX4LM+UR46OZIVKkCtNlR85/7W34ydrO0MAxe0X?=
 =?iso-8859-1?Q?zLBb8LyIHcJtiiMfTZj+5JyLUAEuKClSZqzLBKOaAsW6aXOC9c/qHpXXU4?=
 =?iso-8859-1?Q?sR15n+MRQn/9R99W0gdgPdMVRF92SjlLHZR8FtLpL39I9XGGV9B1XUujcl?=
 =?iso-8859-1?Q?pYx4Mnea2Y9sCT+gRJazfkV5y8MYy56gIi0pFJJN+MJe0CG39HUUchv4Ii?=
 =?iso-8859-1?Q?jOR6r6heBAWVy9SILeXPqSMgna8Qe94Q4elJLxgxekqIqpX43lvaxj8zAI?=
 =?iso-8859-1?Q?kLOy2raQZS08DB5G753g1AeBI1coEPN+bIHa3lVkf5p4pzflQYkINmGyI8?=
 =?iso-8859-1?Q?iC0NcjOQ4XxLZwzfdPpgO0HiQdggYHvYQf/xgvYcHeFe69CkF4Iy4jFKEl?=
 =?iso-8859-1?Q?6+AeuWqrYV2ryl2Qc6dYWOooTo1Z/SbxF2m+pCUTwu2sXEzhvZGCYd/fSF?=
 =?iso-8859-1?Q?yGefrho+ffpwWmW+pucZfAhuDsEux0y56wt9GSRQd5cyvYGK7piQP7sOuh?=
 =?iso-8859-1?Q?MrSgdv0VZv5aSvGmSr1mRXAQF5R7VxrlC13lWUzGM3Gw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?TQcSdbV4qXSClicb/Mxg40UKVILwNuUlXUlxd3Qbug4wAbA3e/a3gj+1Gw?=
 =?iso-8859-1?Q?hjc07Vbdu8lnhL1fvk55U69vEAkl6s3kwlBgR3BIJfj/MlUgtbHrtOcYIa?=
 =?iso-8859-1?Q?F3ztrGPDvHEgtSCWNU7u2QhUSegI3/ShoTYnvkRnQcC0q/nd++eoFEcm51?=
 =?iso-8859-1?Q?zb0Em+7XJr2T8mpR8pL7a7/M8maw0UXw/hGJ9qzOk02UfYPM1+6eereSSV?=
 =?iso-8859-1?Q?xl87ZLGyL6yo5Pm5kg+4J23Sp9IRv+S957bv9aereqLSlJpPtIA86l1jhA?=
 =?iso-8859-1?Q?YhoJo6osKeVB0a5vPN/NJ/35xM/cX4xMB6fqbN90quXgc9X6Y3G4m8refW?=
 =?iso-8859-1?Q?qJSkUCBpBVdCl3eLhgTtllUZPy8UaxfE9ihgmmHkMAxhxNYcMMIA5pagB/?=
 =?iso-8859-1?Q?UQ+xxosHcY7hIss8OE3uSoLucsTh6/TkvJWlF5wzmqu5liFcwP0PVEr2qR?=
 =?iso-8859-1?Q?a4xj7qRIOaYQCNtXmAGcwGqzYnMJ52MVepfzf3OG8yWN3HYIhPCwJFT2Un?=
 =?iso-8859-1?Q?f7XK6c2uhXmyokoYgXop2AKRb9f3jnzT0q0GQbvH52SUcpln4dqOa6P8WS?=
 =?iso-8859-1?Q?516Hg47lYlnm8LYl7sTM0EtPxlPsp4ncYn4SWyd9OgzF8l+kyIF5hDWWLf?=
 =?iso-8859-1?Q?loB04QOMQkSIxAd5EPU8eKgYA0tbvQg5rqPzO+ZtVsUApFpciR3bQPx+bi?=
 =?iso-8859-1?Q?U3zZmZRjj4xox4wm/FEIZDoHrUBBG06R4jBEUcSw0J9LhbTtotH+teUj31?=
 =?iso-8859-1?Q?/x+2YdlOXXZ8YYu4rdkGBwFr4pxGwCqlDqWJR6E8bpCRjUFjPM6UuGBlzp?=
 =?iso-8859-1?Q?+d45KcXzCtqKurT8plp7U6MW6FaFTKHHSkc5yM5pvsnXatsB9YiRYkEShA?=
 =?iso-8859-1?Q?WcUloaoQ26rhXBMDsTDFnrFFfM9G6kAKcrnhkKhdlKLScjz7RJEPkd3aiZ?=
 =?iso-8859-1?Q?EBzidJE3ALMeV2Gj6YeD8in4dbpTpOzmRlteXkeVUBDb+lxA1Y/ZM/yF3t?=
 =?iso-8859-1?Q?QcP21kpJD+jr43BS/+9Alydjj7qmhS5Qog70wwLPrMfaRTz8XNclm7N1TH?=
 =?iso-8859-1?Q?z+rat0ZWIAD53gCJIzq20ItG1ULrhYR9VzFp0Nis9EmvVJ3ttu9tktP2Fd?=
 =?iso-8859-1?Q?Ff1ZTsuhZXChSDyFl5ZN6BiDHDgWBuNoCdeoQP9cb/lfgMVUfe7iQ4PsIb?=
 =?iso-8859-1?Q?ylBGNEO+Ki0hTKEi3MoB0/vVNcZQlAXtpRXXVpkliLqi2712D2oW6dAmnt?=
 =?iso-8859-1?Q?D7UNBvjku0iq/kpPSKSrGU7iVV5GGE3D9HxPGA5T0BoJuH1pYn5OB97QTS?=
 =?iso-8859-1?Q?2Lkf9iURcToItDlkSw5TtREst5wvr5KRZwE0L3EtVRR8QX9wu8vWsQSRyV?=
 =?iso-8859-1?Q?ngbTdk67+9FoczTVF+wa5Xm6599+lMAZvxoCLdm1IQrAa+kIibDG10sZ6X?=
 =?iso-8859-1?Q?QxuzxTpuilxScONxL+O2CcLLvSHQUClcqemXWqmvarloJej0IycLPJujmA?=
 =?iso-8859-1?Q?JxifwlxHy+3+shG9cQkqaOfkxbt+2LkHBiF2mpTZuI7NURZBwCaU/AvYPp?=
 =?iso-8859-1?Q?QuodtmrKrgPCSiUYDZ0QVm86wOTzh1AZxGMcL8KVhYpqpjejyzEPfd1x8V?=
 =?iso-8859-1?Q?DQC2kfActPnDQCaVL/EQ3QB+PTxVA6paftFRynSYpsFLRZ6TedSi+nCQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1656fedf-b339-43b0-7bb1-08de1204ec5b
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 07:22:28.9927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZROiVAComI+WSVqzQqMOZzFMnUvGMyMHbemruCvr6GXLLZOz9sHsOKJAh7jyuZFP+b5ug7aDMJiGuJXOlt3sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5312
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6C67140003
X-Stat-Signature: s4yjdnceahnoso97a3196f3z9tkg5q7p
X-Rspam-User: 
X-HE-Tag: 1761204153-933751
X-HE-Meta: U2FsdGVkX1++UF9hIU6IkhAu3SFIUvzTwzVSAue78XYYZsM7z5v1pz5TAB7LF9ta1TgFM0eBPtmFVINWLfs6f0bLmJrpc6vqa/5rwVPnkbyrPt1x7Njq0NEEGt9KDeBCOLqX+gUokJHpdb0xib+gl88hzJYz4sGgeCBal5lkp9CrHfalT17Aad2hVhbR1sXMVOc/XT3IC8SbBkFpRHv86hfq/Y9bqKwc3e1v2/KNUQ1iDGQdl8uNcS5k5FQ2AstzZ6qpWwquO/Lf4Y4yq4LBk2FYvouxQD2NJr3VURPHQht+6zrU1fstjk/rfHpxRYB1mUa7VxWDFNk5qi0wlwsliVjpCOoGGZ2QKSuaM4zPtxLQ0SIHhrrxTo1ALJHphqm4y0wl5rSEHMZJZEzH6y3QP6Evn6EV+aQ76FWsRuupGHYYiJb3LOH47lwBvv+1Cb9d3tV3XSpn4zYggzgavHjbteYVgpukKxhQxjW9ws2NbxiGHJDzohapSNVBmbHf3veXAv+qU4A9AAGeh6BAt8TlAEKHwA51QU3/JA/G01xlVx5LuL5TR9xZswbuQsF8g2GgDBzcfAyjUGT/Pae4GdyR+/yPKwYRUXY3OdZeO9MhlWhL8rb8P0+eNNzGZgMz7muXswA2RIFP32BxZIP+TlrD/RIMlUQgUQujf2xnTNBNDV6L1g5TnOlcrkYd4K/E4O2FuEboM02TrJZWkvL15oIkl6ynrPScQfNAG21hfv9AZ14RYL509LglIK6zdmgz5zMs1ZhxqXfQFGXQ9Dj+EkwkXSAwMuiBesHU3KOXDQL8HQmH+2P13Eh0/sEGwWQUnjzLRuLy0sUKxm6P7Xaw10JhnxRe6c2EaSUJ8g9j2hkO4PeeREsNKKl/biCaPzLUpInJkZKkHVm6lHMz+eSHGL8hg3nA5AIP49N899CrH/CfUs3CIDqcQQ1e6us5TXUvGdLpW+oVgeu5lhLoIsGBpDB
 nokkJE11
 pLa1xEFmyOo+cPvhh85gPxEOcIBtdhBGH3A8l2hmLSQRabi8XtyXl6rTZyWz9k/j+YEtx/AJSJVX7soJKAwWPHEeVXpIATedoKcwNDx6Qs2N0wCXg0/PbcGg9Uiq2DYDRBjAGN2ab89BBMR8N2Wa1kxngS4StqW5gWA4M0ygFT13Wpj2Aq3lq8p4LzbxVIEZHWvZRs2920aXlMow6nv5dMGwzcVzMFhFkkY0PIsQBxww8cfib3fHp2PC8MGIpEWPQ7liqH8hlJWtG7U8Dw9DwgLrZemhj2WC1ggSJzB6mn3UcTyPP8QZbPGejEUhDap5zuWQFIAcpZvKYpcwShxPo1ZYVkBwD9CGN3EA7yMpnLPmaJ9Df2ULhSjsk5Ntb9Cg1NnABZW+7JGply0syEznlKWAW24IG9IRLXeNf5DpMRd6jiUPw+be5uBFfkxJgNGzW0qm5Gzfl2JZbWMlvv11JqMX2MDOHHPTSQktKnE+ElKoaws0mF+hCTbrz/mPhE1rFs/RlgJ0oq+Kuq6suG+cXTb+zk+9hEhxfrJPSPEITW3Ae5BXzOc6N1zI4NNAncql6csxIEdD7Z5REzAobKBx052Nc9RoRUwi3wzJ1ZF/WxmikDT+KlIEdc1cCfndGWSS2ap5HVC/BalAzmv+9Pz1pf2/EDKIZNWpwe6mVDaSy30tnZm1dwiDrgd6X85/3Icxz3BYr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 2.1% regression of will-it-scale.per_thread_ops on:


commit: cb57b28051ef1d84e7cb14db4e1ab99b4f33b4b5 ("[PATCH 16/19] sched/fair: Exclude processes with many threads from cache-aware scheduling")
url: https://github.com/intel-lab-lkp/linux/commits/Tim-Chen/sched-fair-Add-infrastructure-for-cache-aware-load-balancing/20251012-022248
base: https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git 45b7f780739a3145aeef24d2dfa02517a6c82ed6
patch link: https://lore.kernel.org/all/637cdb8ab11b1b978d697ed744cc402d32443ecc.1760206683.git.tim.c.chen@linux.intel.com/
patch subject: [PATCH 16/19] sched/fair: Exclude processes with many threads from cache-aware scheduling

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory
parameters:

	nr_task: 100%
	mode: thread
	test: tlb_flush2
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202510231406.30bc8aec-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251023/202510231406.30bc8aec-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/thread/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/tlb_flush2/will-it-scale

commit: 
  4ac141e433 ("sched/fair: Respect LLC preference in task migration and detach")
  cb57b28051 ("sched/fair: Exclude processes with many threads from cache-aware scheduling")

4ac141e4330723c0 cb57b28051ef1d84e7cb14db4e1 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   1482496            -2.1%    1451299        will-it-scale.48.threads
     30884            -2.1%      30235        will-it-scale.per_thread_ops
   1482496            -2.1%    1451299        will-it-scale.workload
 4.447e+08            -2.1%  4.355e+08        proc-vmstat.numa_hit
 4.447e+08            -2.1%  4.355e+08        proc-vmstat.numa_local
 4.447e+08            -2.1%  4.354e+08        proc-vmstat.pgalloc_normal
 8.884e+08            -2.1%  8.698e+08        proc-vmstat.pgfault
 4.446e+08            -2.1%  4.353e+08        proc-vmstat.pgfree
 6.446e+09            -2.0%  6.318e+09        perf-stat.i.branch-instructions
 1.462e+08            -1.4%  1.441e+08        perf-stat.i.branch-misses
 1.467e+08            -1.6%  1.444e+08        perf-stat.i.cache-misses
 7.692e+08            -1.4%  7.587e+08        perf-stat.i.cache-references
    101348 ±  2%      +3.6%     104965        perf-stat.i.context-switches
      4.14            +1.9%       4.22        perf-stat.i.cpi
    883.41            +1.4%     896.20        perf-stat.i.cycles-between-cache-misses
 3.083e+10            -2.0%  3.022e+10        perf-stat.i.instructions
      0.24            -1.8%       0.24        perf-stat.i.ipc
    124.71            -2.0%     122.18        perf-stat.i.metric.K/sec
   2944589            -2.1%    2882055        perf-stat.i.minor-faults
   2944589            -2.1%    2882055        perf-stat.i.page-faults
      4.17            +1.9%       4.25        perf-stat.overall.cpi
    876.76            +1.5%     889.96        perf-stat.overall.cycles-between-cache-misses
      0.24            -1.8%       0.24        perf-stat.overall.ipc
 6.417e+09            -2.0%   6.29e+09        perf-stat.ps.branch-instructions
 1.455e+08            -1.4%  1.434e+08        perf-stat.ps.branch-misses
  1.46e+08            -1.6%  1.436e+08        perf-stat.ps.cache-misses
 7.653e+08            -1.4%  7.549e+08        perf-stat.ps.cache-references
    100692 ±  2%      +3.6%     104309        perf-stat.ps.context-switches
 3.069e+10            -2.0%  3.008e+10        perf-stat.ps.instructions
   2931887            -2.1%    2869944        perf-stat.ps.minor-faults
   2931887            -2.1%    2869944        perf-stat.ps.page-faults
 9.273e+12            -1.9%  9.096e+12        perf-stat.total.instructions
     62.03            -1.8       60.18        perf-profile.calltrace.cycles-pp.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu.do_madvise.__x64_sys_madvise
     63.66            -1.8       61.82        perf-profile.calltrace.cycles-pp.flush_tlb_mm_range.tlb_finish_mmu.do_madvise.__x64_sys_madvise.do_syscall_64
     61.19            -1.8       59.36        perf-profile.calltrace.cycles-pp.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu.do_madvise
     65.49            -1.7       63.79        perf-profile.calltrace.cycles-pp.tlb_finish_mmu.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
     75.54            -1.5       74.02        perf-profile.calltrace.cycles-pp.__madvise
     71.89            -1.5       70.41        perf-profile.calltrace.cycles-pp.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe.__madvise
     72.40            -1.5       70.92        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__madvise
     71.83            -1.5       70.35        perf-profile.calltrace.cycles-pp.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe.__madvise
     72.35            -1.5       70.87        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__madvise
     15.31            -0.6       14.70        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu
     12.04            -0.5       11.52        perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range
     10.97            -0.5       10.47        perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.smp_call_function_many_cond
     11.08            -0.5       10.58        perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask
      4.36            -0.2        4.15        perf-profile.calltrace.cycles-pp.flush_tlb_func.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function
      4.53            -0.2        4.34        perf-profile.calltrace.cycles-pp.llist_reverse_order.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function
      2.02 ±  2%      -0.1        1.95        perf-profile.calltrace.cycles-pp.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      1.47            -0.1        1.42        perf-profile.calltrace.cycles-pp.folio_add_lru.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.83 ±  2%      -0.0        0.80        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      0.65 ±  2%      -0.0        0.62        perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.do_user_addr_fault.exc_page_fault
      0.73 ±  2%      -0.0        0.70        perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.64 ±  2%      -0.0        0.61 ±  2%  perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.do_user_addr_fault
      0.73            -0.0        0.71        perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.testcase
      0.84            -0.0        0.82        perf-profile.calltrace.cycles-pp.clear_page_erms.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol
      1.65            +0.0        1.68        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page
      1.92            +0.0        1.96        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.79            +0.0        1.83        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault
      0.92 ±  3%      +0.1        1.04        perf-profile.calltrace.cycles-pp.tlb_gather_mmu.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.83 ±  6%      +0.2        3.04 ±  2%  perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      7.06            +0.4        7.48        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      6.25            +0.4        6.70        perf-profile.calltrace.cycles-pp.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
      2.48            +0.5        3.02        perf-profile.calltrace.cycles-pp.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.00            +0.7        0.74 ±  5%  perf-profile.calltrace.cycles-pp.get_mem_cgroup_from_mm.__mem_cgroup_charge.alloc_anon_folio.do_anonymous_page.__handle_mm_fault
      0.00            +0.9        0.94 ±  4%  perf-profile.calltrace.cycles-pp.__mem_cgroup_charge.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
     19.08            +1.3       20.36        perf-profile.calltrace.cycles-pp.testcase
     14.17            +1.3       15.46        perf-profile.calltrace.cycles-pp.asm_exc_page_fault.testcase
     12.74            +1.4       14.10        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.testcase
     12.49            +1.4       13.85        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      7.97            +1.4        9.38        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
     62.25            -1.9       60.39        perf-profile.children.cycles-pp.smp_call_function_many_cond
     62.26            -1.9       60.40        perf-profile.children.cycles-pp.on_each_cpu_cond_mask
     63.94            -1.8       62.08        perf-profile.children.cycles-pp.flush_tlb_mm_range
     65.76            -1.7       64.06        perf-profile.children.cycles-pp.tlb_finish_mmu
     75.72            -1.5       74.19        perf-profile.children.cycles-pp.__madvise
     73.51            -1.5       72.02        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     73.48            -1.5       71.99        perf-profile.children.cycles-pp.do_syscall_64
     71.90            -1.5       70.41        perf-profile.children.cycles-pp.__x64_sys_madvise
     71.85            -1.5       70.36        perf-profile.children.cycles-pp.do_madvise
     18.46            -0.3       18.12        perf-profile.children.cycles-pp.__flush_smp_call_function_queue
     19.79            -0.3       19.47        perf-profile.children.cycles-pp.sysvec_call_function
     22.68            -0.3       22.36        perf-profile.children.cycles-pp.asm_sysvec_call_function
     17.97            -0.3       17.65        perf-profile.children.cycles-pp.__sysvec_call_function
      7.64            -0.2        7.46        perf-profile.children.cycles-pp.flush_tlb_func
      7.49            -0.1        7.39        perf-profile.children.cycles-pp.llist_reverse_order
      1.47            -0.1        1.42        perf-profile.children.cycles-pp.folio_add_lru
      1.99            -0.0        1.94        perf-profile.children.cycles-pp.__pte_offset_map_lock
      1.84            -0.0        1.80        perf-profile.children.cycles-pp._raw_spin_lock
      1.31            -0.0        1.27        perf-profile.children.cycles-pp.folio_batch_move_lru
      0.93            -0.0        0.90        perf-profile.children.cycles-pp.error_entry
      0.42            -0.0        0.40        perf-profile.children.cycles-pp.vms_clear_ptes
      0.89            -0.0        0.87        perf-profile.children.cycles-pp.clear_page_erms
      0.94            -0.0        0.92        perf-profile.children.cycles-pp.prep_new_page
      1.66            +0.0        1.69        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      1.80            +0.0        1.84        perf-profile.children.cycles-pp.alloc_pages_mpol
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.__pi_memset
      0.96 ±  3%      +0.1        1.08        perf-profile.children.cycles-pp.tlb_gather_mmu
      2.90 ±  6%      +0.2        3.10        perf-profile.children.cycles-pp.intel_idle
      3.23 ±  5%      +0.2        3.45        perf-profile.children.cycles-pp.cpuidle_enter
      3.32 ±  5%      +0.2        3.54        perf-profile.children.cycles-pp.cpuidle_idle_call
      7.09            +0.4        7.51        perf-profile.children.cycles-pp.__handle_mm_fault
      6.27            +0.4        6.72        perf-profile.children.cycles-pp.do_anonymous_page
      0.43 ±  6%      +0.5        0.94 ±  4%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      0.25 ± 11%      +0.5        0.76 ±  5%  perf-profile.children.cycles-pp.get_mem_cgroup_from_mm
      2.49            +0.5        3.03        perf-profile.children.cycles-pp.alloc_anon_folio
     19.67            +1.3       20.94        perf-profile.children.cycles-pp.testcase
     14.47            +1.3       15.77        perf-profile.children.cycles-pp.asm_exc_page_fault
     12.76            +1.4       14.12        perf-profile.children.cycles-pp.exc_page_fault
     12.60            +1.4       13.96        perf-profile.children.cycles-pp.do_user_addr_fault
      7.99            +1.5        9.44        perf-profile.children.cycles-pp.handle_mm_fault
     42.94            -1.2       41.71        perf-profile.self.cycles-pp.smp_call_function_many_cond
      6.02            -0.2        5.87        perf-profile.self.cycles-pp.flush_tlb_func
      7.46            -0.1        7.36        perf-profile.self.cycles-pp.llist_reverse_order
      1.44            -0.0        1.40        perf-profile.self.cycles-pp.lock_vma_under_rcu
      0.88            -0.0        0.85        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.91            -0.0        0.88        perf-profile.self.cycles-pp.error_entry
      0.07            +0.0        0.08 ±  4%  perf-profile.self.cycles-pp.get_page_from_freelist
      0.76 ±  2%      +0.1        0.86        perf-profile.self.cycles-pp.tlb_gather_mmu
      1.10 ±  5%      +0.1        1.24 ±  2%  perf-profile.self.cycles-pp.tlb_finish_mmu
      2.90 ±  6%      +0.2        3.10        perf-profile.self.cycles-pp.intel_idle
      0.20 ± 10%      +0.4        0.62 ±  6%  perf-profile.self.cycles-pp.get_mem_cgroup_from_mm
      0.15 ±  4%      +0.8        1.00 ±  3%  perf-profile.self.cycles-pp.handle_mm_fault




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


