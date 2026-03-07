Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78810FC9EC0
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 04:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5736B0005; Fri,  6 Mar 2026 23:02:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4930E6B0089; Fri,  6 Mar 2026 23:02:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 367976B008A; Fri,  6 Mar 2026 23:02:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24A4C6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 23:02:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AB38B981E
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 04:02:44 +0000 (UTC)
X-FDA: 84517920648.03.8A592C9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf04.hostedemail.com (Postfix) with ESMTP id 931DB40003
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 04:02:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W+1iD2Wd;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772856161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IOGVOGNSc13RjcEeOj1HdEdKgutdfrTeqjyzoixgSkU=;
	b=7gp4COKkZ7XsJ7jXrkNJEVAyjncJOMqF56kmyseRBJQu2u7wJIPEKkO71nRK54rRLmmQI7
	Q0ZCQST1THh/kgIu7wwBfnG9Kjv/ukB52ZpRQY5ofSvGv2cGiQ0rvx7sz71QzObsIPVdSP
	M4N6rwNtRL9rgaDqajpwc5XOe3csoQA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W+1iD2Wd;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772856161; a=rsa-sha256;
	cv=fail;
	b=u11RIEvIK3qMFWnVXQkegZfwxAgzoCkkvYwxckZf6olsa1ci/paU0wATDH3LAYjEU8NESI
	xnkJ14MLo0dc/gkslIZ+heDoAqsiicfR6pDVjFEYLj5Xkbi22KvtBohpOW5dC16wU9BbEo
	fePnKshcR/l0P/C7v0PXPixgk8kssJk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772856159; x=1804392159;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=GyGm+7jahbaUgvy+iUJe6kwqRdYPduuHSuWWNaSzN1A=;
  b=W+1iD2WdWgB5PLT0ATQ4vcY42XWgPPuT7DWPgbz3g9OfMzoDzawDV0LB
   OE2ekaEg9h31XuVettecZPr4wYJyIGFa1oowBGeUxJBVoH2+mo5isRy7G
   j9AxxtZ7PtgA77ErrbItiXUB/4R1IA1yK3c8bXFb0wyrALpwq0ZxtW8N4
   IBW+5LU9iKPCqEgO2Ypi3ydwuR0mCm/edUXDHverwgkulHHhpx+YZs1R2
   9p/S6LITCWIuldMcvI8tqlpjPuHxseboZCskvjBjRWukSTIiVy4uh6fE6
   vqclLp5If+P73X2CHiEppeJubingFq0hF7aqhyUVKrwkZFatopcKNOw8p
   w==;
X-CSE-ConnectionGUID: Fm3tiDIwQzq0ImNlAmXypw==
X-CSE-MsgGUID: DPPWADGeQem7Y701sr8eBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="73841185"
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="73841185"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 20:02:37 -0800
X-CSE-ConnectionGUID: QA/PCF+BSOa6vTmoTn1zXg==
X-CSE-MsgGUID: 8LR6BfryR8aOXUQXGm2Ucg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="245385979"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 20:02:36 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 20:02:35 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 20:02:35 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.10)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 20:02:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YcfpxGTIWmpgf/fnCfNdDs4Nv8BlPxFdmLipFwQWfWqCb63mUTiQcZwYP9THW2tXznXM4i1fhuO/Alll7T1mOmEt2BvuWaMloARb7pojfWpRoPD1/tz4B5NzJJNCbpj4roFIDgMtW7S9abc+M33i0Fl5t6hye0H3PDn4SFuG/TLdnGKXmXr16RC3zddJ6tiE7T6LmFOJMLTeBq8Qz71f4mswwqCc/Ivw+xk/J95rwAGiHAZk9NaHdtPHeM0SjW4IEn4MBGhlNYASUhJ3TZo0eEvvIwhfQ6D6kp3loQ1uQCc3R0EvzD8WRebnBgBokyfwVt8BznUyKW3ybuWMID/RHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IOGVOGNSc13RjcEeOj1HdEdKgutdfrTeqjyzoixgSkU=;
 b=IxFoBpCmU/nFfGkjRVLMhz7EP8EcCwBUfpHt1VatiifeIqxIGMqkgHuA2mn+04uykAt5CpgbWI5taXRct5vvNU++VMK7EBp83CEvcRAp4XwRHBmjjZK1+YZE50ZyIjst36hzgGoxz68ICr7h9uJVuSwd21nEu1CJCG4Vr8Z4AgDxQphRhXASL4PbJxlPoODjIRIixWk96w2XMfbWOvK3oSyA3KFxTyyZyO99tR4azfusOSxPH9MUSEfK0LBEeBHXcUZ7Vfp6Ybq+abPmSJNWAZQZyDh0DDmB8q28sr1xmEWoxkzRPyt5LtZpprr1IwtbFiAlQq9I5MAYARsIbqLGkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7710.namprd11.prod.outlook.com (2603:10b6:510:298::9)
 by MW4PR11MB6983.namprd11.prod.outlook.com (2603:10b6:303:226::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Sat, 7 Mar
 2026 04:02:27 +0000
Received: from PH0PR11MB7710.namprd11.prod.outlook.com
 ([fe80::dc6:ac78:d884:137b]) by PH0PR11MB7710.namprd11.prod.outlook.com
 ([fe80::dc6:ac78:d884:137b%5]) with mapi id 15.20.9700.003; Sat, 7 Mar 2026
 04:02:27 +0000
Date: Sat, 7 Mar 2026 12:02:17 +0800
From: kernel test robot <lkp@intel.com>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
CC: <oe-kbuild-all@lists.linux.dev>, David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List
	<linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 285/313] ../../../mm/vma.c:2592:33: error:
 'VM_NO_MLOCK_MASK' undeclared; did you mean 'VM_LOCKED_MASK'?
Message-ID: <aaujSXGjGBv5NVAD@rli9-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR04CA0157.apcprd04.prod.outlook.com (2603:1096:4::19)
 To PH0PR11MB7710.namprd11.prod.outlook.com (2603:10b6:510:298::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7710:EE_|MW4PR11MB6983:EE_
X-MS-Office365-Filtering-Correlation-Id: 5848d224-1e52-415c-5ba1-08de7bfe5872
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: Bn0o1wMbwuhLUZ0RLAYILjWf/AW0weJqP2VktNIfokYG6yYjom6hx0VfT/Tjq5Ng3ORgDrxnoufSX5/SL1ldT/J4BvSzb6TbpNxt/xytN0FAodF0f+Yh/C3zwLvcZjYi4lvsPT2mFXP3uZ7XavheDVVZY9klgC5U/JEj7E7ZMc+Kf2VYdCMthUDd6gaRbwkDCwdY6/XaH7i/ffUHO5hkl0o3V/c5vk6teXHfCWC/CAv9xvG8UtjeZCfRZbEb89m7QZPrXyxCEqZnV71qVJZvTe6oi9W2OzaJcqPfi1htrTJYoOFhsUHNd4uizp1JophCKhyR/yFYXqfVj+9O+fp4mV2kqAw7ED70MYfu4GRXLLfd48op54bBbaQTFQEiH6f8onvYefaUj+mowewT2J380K19TsMigs90vvCHsVj6FHTk5JuooZckKM+FXyfq7HtTunCvfIYp4qAOjVfiX4PKnjM9Kda6VhVNeEFxynQBoGnfwRbHBqegB1Ul2L9YoCWFrBG5dSJaVcDoPLRgxUUG+FnAHHUa9S+lalYKHrw6TjK5F2/U7Gz24ozgSJuK3r0e+QEpqeSjQq5i1JnO5kGBDhnGFmvjqeMMlKtlWqsozJsSa5ZHCfAjH+Qaf48kcYzUaWpOD1jReYoLpx8JEySVaSgUYKYPY+roYjKxJ9t03kTaPrOWMLBy3JSjk/NV/C7s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7710.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e9qVGrqgYoAV2H2o0t+mEmFb2TfI/7Rg4RRA/v4I6Meur+vFg/tNhz15tqHG?=
 =?us-ascii?Q?iow23tfSbK83avXdkELTUTxzRvc/t5+HUKqwKvcWh9Ro3hXyAGu/YJ5l585m?=
 =?us-ascii?Q?kHIOyxyTIy9gOCu5nw2jESSpgEUodV0Y7HqTf48mCf55X+a/Z4NGlaM4F5oC?=
 =?us-ascii?Q?Q3LdCppuEexkoYdkBjlL3TLYi9CdE+aOy8RKD8AFSuaiAHwUEu83RA0/HWP3?=
 =?us-ascii?Q?LWOT+ne5FkvkhRcqgsvUfWprhFuBt199J7hs+7XEE394IRgMyKseH6U607/R?=
 =?us-ascii?Q?wx906rA1OSaYduGvODFaWU+NuQ26fAUMdxLv6eIF8J6Z8uKOTBdrM1d7sxH0?=
 =?us-ascii?Q?OHHx9bV6O+nkFsCvTZ8bIVCZkKjjyz79bYCEWp+U8pXYg2u/zoVzQlU3xvxS?=
 =?us-ascii?Q?W1y5pa8TCia1bPCBirq7K9zqeBYMcQlaLZfDbAihOC+tJ2ahYLzhUrlMxjDD?=
 =?us-ascii?Q?DipSDn1KKoeBpWauSo3XiuSiVpToYmTQO9vKtbD7puBSJNt3p78aTRP/KHIp?=
 =?us-ascii?Q?/MYAGLsv0HAJnfpYH13+t1ISttURc9nifqJiBllJgbZB2Lh4wTyTgB6OSm0y?=
 =?us-ascii?Q?5yXLvSnC4KhTNtA3ppJOSbAlG6mUZ7r93+OnVdsH8/OVpFC/Byk78/hyqlsw?=
 =?us-ascii?Q?S/AuTrYeZtEu4gCu9+X4zTAgQoqHQVOd0bIuJBKy3981AURqxMAlS2euks2X?=
 =?us-ascii?Q?dysEk0w60JWU1QCA70Bnzr6ppjUaKdFxRmQE9JO0KoVyxox4i38TGjnCTv7K?=
 =?us-ascii?Q?ydZ6pkuzymGByVDQU5ki2c2MdKSSZDwBci2jvAgS/0pO5KQT+jK75sHuh9gp?=
 =?us-ascii?Q?Ya3W+HXQxyjhMfYEBMlg8+ODaeWohGVt4x4u/Wmf2MDLSI747qbvWvUyD30E?=
 =?us-ascii?Q?MiwrVghOJChs/HBX44zDKGqIinnLv5t31OhGqDHFE4ve4i4BvVAgXFkdZlUB?=
 =?us-ascii?Q?dTyVQpk33W3LPNbxK6BVf3tVHVn4JACSwZyA75LnurrVpN4IsBGoKTkOmY4Z?=
 =?us-ascii?Q?DYHKSmbUrMzSOsYbzfohIpTzRkZeTUcgPXvlPyn0w0EqJG8vkBFo+Vvh2j6S?=
 =?us-ascii?Q?oflOL/eKxd34s50hvHrT+CQpHM6uG58u1jri9WAf7jgP4b+3Cb0iUNTVK8NF?=
 =?us-ascii?Q?MM7A1WyAgiozmcnR1DvPuCjV/WA0ndqTMsdSXndFyfV/Cd5Wdvyr2Mcb5/yn?=
 =?us-ascii?Q?EFPJ5x2lHc/m0CNT6RhNCx/+9WlveQLoSGpjkXEwOstaZ/kU+TzocRk32a1I?=
 =?us-ascii?Q?3crXT/q77yAmA0Be8H9cL+sP5EnFTyikPwpQEXf6UlaQLjvt97Z8N1tGUw8L?=
 =?us-ascii?Q?N3QtSFhGJ4bjJ2m5E3ULwumTcdePHb9AGdhWxzqinZnkIjDu5IDzIWB/uPN0?=
 =?us-ascii?Q?aN9XngdgyNJLENjYFKX76LNHtBed8E+HLSCiA5gnW/hqsIAYDY+yQa4+6He+?=
 =?us-ascii?Q?+lMyoUOWe42yby9StuBPue7xFRDMZN40pgiTsys8k/VPCoFbVvw1/JtoZjYw?=
 =?us-ascii?Q?5BmMAumFzpMayALI9kenMG2wk6+aI5g7ee2tt8bPvaDMAUBCjBi7R1D6FpQ8?=
 =?us-ascii?Q?YTGR4qIK7+G9uWyZDBMxLCDS+OZk8AB0uyvHY+6rP2Ub5Cc0I0KxsMy1VBzA?=
 =?us-ascii?Q?H4I9Fr+T0d+HKlvAaJK/vHuxJxsDNfQl/DX+gET3LpXx1kniVfOo6e/HHhCE?=
 =?us-ascii?Q?YHlN/dN/cd4mDGpnaZcGeK6FPbWRg9lWj5w/k6c6TjQw/Aa6llHaRhmvl4fX?=
 =?us-ascii?Q?bHZfPkwv+A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5848d224-1e52-415c-5ba1-08de7bfe5872
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7710.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 04:02:27.3816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mIaO4Yc09XZU2T7rG08Y7ZAKZZWKexZKpcNSofNRqgLW1tO9WwfzKCL+Eo7kGGTYI3kx8uw/xCLzjMt4Cf7BGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6983
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 931DB40003
X-Stat-Signature: 544kygkqwpqb6x4eb9wr5o6esx57g84e
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772856158-137844
X-HE-Meta: U2FsdGVkX1+PaDSafxIPX84dHT1rpgVq6RO3+htnDguOrmfbvREOQk2xYEAlJZP77AfoCbx1l1sGJzUN6lhVk6xS3zZ+4MEq4pr7HYY0PiDVeWsfFjtvGdFHQyjqcw/52KAXCjMlRnBjGXMGw45+OzdFoAKkyzJ3pGa0JTUOx+hAa3mKr1NDUxXgM8NsDicWHVwMI9u049YyufCTnac6Dxzq6iFCBdy+hy2LRwUlgV3QO629JIAmQfWnHGUGynIOScsl5G6W+n3X/mCzyEDT0PbOIM5LYSAwsSXokCeEO2OV7MLICu6ed3o+riiyNE13ijovvN5sP9vnKiJ7CNyj3ztMwZN/xodN9tFeZVAp+yCZ1Ka1aEE1w0dlJmwm7M8AYDxGHXiQKpO8PxgJzjX8xuZ3XXzE0zATH4ruDpHDuvL+PV3LN6KDXIrrXP+ButXd1GSLEm2UmOxKIwvdVDDxVWTaef/7k8PjxDxxhDK/LANGx2z+1Cl9hvPPZGY3M+Kd1OtPBgudhZ+6lth9s5ADRGsPlsB1AIMFhK6/7rGorr0SBTd1BCeG+9NoFeA7pgvc0lEq9DQqbZjWfkwiekC1B0HpSEd/aCdbmtgldaEyRi7TFaFjqesbvddffQpSDZkaDp2OO8otgnWVJmPsMGd0BJ0lMZJqUAQI5INjTRQrjH5qsY9sWlSOEGpFrS1/T8V3I7ZENgfQcdlOnudhyFw3lBOG6okG0sCweoUF+gbUhgC1+mfHxs7lKa+OFNJmp7g1Pw1yXgXz0/3Ag9FVXjCIV0tWEHv6l5ukO5Zjl5cDvY5upLamGWuDruFvTehLt8C2q6FGwoHapsQbXeq8C5BikFX5au56kI3OCaPKQjiVfq34nQcjfolcm6A030v32FCg/tKP3QMPeaSLsT20HR2JIAG8hTzldOERhG/cQOX70KTUhOe4xcKH0V0L0CEOqwJzOby6F+oJKOvzduwkVNY
 LvZqPDid
 5CciyBeZaHpSjo1B+LXGgHTrds/OpPw5/XFdRWqx888hdM2rB1Ov759jVEhfws2ZwsoKoLlrZ6XYsS807NfUzrlIa//7TQ1/cqK0mYrWuTjlWC1KCLdIlQ6SjoVg1O5lmPImYBOr17hy6In1iTxnu7pk/rxzqJdhbDb4I6SwKKpqLx2gyOjK1q97KcgaM0nx3UDUTZQwSEA1uxn/uAb575ltn6pKX6RtXyFdZZsuRETGxnL+Sgh0y2SsbyVTsxghKIYoHe5ZDbkqWWTx+3E4wrLQ69vPTuCTVPGY3cmVgfzsigLkVycVCGYTK9Cu3YPb+iJ2svfu5gY0tM1YOCzcfxAwPvYQRN1NWtMpqsx+GCthWAb6yBzHiuKkZFKrUYiEiZqQrXqaSCU22xCMqRbf7h1+lWPE8yl2QfQFX5TrHKwQSfO2Qox1rqFaRTLHuxU+Z+05W7Le/r6Ug5tMeFgmoAGd9oAMSELsw5obP4yiP2IncZJquU8wD1UwtHaWXyKSOH4gpoqHg+N2/NMVlQXCm5XUze4d7ymAEBwwONHhbZrRKcSJOdBeIjLOLmQY9bjdhA9CV5mLvohPOj28A+7ycvj9/bNYe2HpmDejcQGsUr2uBJXikHzF7mDZO6WP91AaJZiAw6Rt2x9zPnKJB1XD1LtYe+7Mti6Y5CkmAZVeqtyK0P7/+oa4OGwN6mPaP35xsN2d+K7YWt0h2mfVvTpWeg/Gi1dn9V+ezAFde
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Anthony,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   fee41c6c27b01fdd910a9d9cd4f3b978efb92ea2
commit: 6c41b23d5f57f306c940c65a2a5240bc20a95659 [285/313] mm: prevent droppable mappings from being locked
config: x86_64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260307/202603070433.MUXyiGWN-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260307/202603070433.MUXyiGWN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202603070433.MUXyiGWN-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from main.c:10:
   ../../../mm/vma.c: In function '__mmap_complete':
>> ../../../mm/vma.c:2592:33: error: 'VM_NO_MLOCK_MASK' undeclared (first use in this function); did you mean 'VM_LOCKED_MASK'?
    2592 |                 if ((vm_flags & VM_NO_MLOCK_MASK) || vma_is_dax(vma) ||
         |                                 ^~~~~~~~~~~~~~~~
         |                                 VM_LOCKED_MASK
   ../../../mm/vma.c:2592:33: note: each undeclared identifier is reported only once for each function it appears in

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


