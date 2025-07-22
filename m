Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDC7C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 05:36:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A07E8E0005; Tue, 22 Jul 2025 01:36:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377BB8E0001; Tue, 22 Jul 2025 01:36:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267138E0005; Tue, 22 Jul 2025 01:36:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16D6C8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:36:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E1E61A029A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:36:51 +0000 (UTC)
X-FDA: 83690791422.22.C4BD58B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf29.hostedemail.com (Postfix) with ESMTP id 50A6312000C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:36:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FwFgQbQT;
	spf=pass (imf29.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753162608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZfAw0vPxnxSLyMN2Nzt2OLaxUtvPoyIbfQXuac4tblg=;
	b=Jgt0bPRPAtWQAT8ru1CgrWT+JWSI1FYqumvr21G/qVb0out6JO4Cygv/ZUkY04ZbfNvHC9
	SLLOZjl/w01RbkhRnhDIb3zmOrBxBjG5l5jXUh48x9VVWE/H52dw2mnnRQWmeIVmzm6o3K
	PF2ITVlL/k/ckMPOgoFwjfWYf70i1FQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753162608; a=rsa-sha256;
	cv=fail;
	b=XpShECyFwrOHnwxZaHEUGv/niRJl0eDUa4Ki7wspwiu7Y1ZKDNyh/xJu2N3uT0dnfNPDxz
	6Flw5v1FsReWKb7irpHM+ztpN/573qu0haZIHkzLa2L8x4C0mOAJhXbpOTWLqT7wWG8cuG
	SUC4LTSLi9w6brNZsN6o56GUY/7g2B4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FwFgQbQT;
	spf=pass (imf29.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753162609; x=1784698609;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=5odpSWH4S4emk5ZwPzo3QyWAEkX9ri6ulhJBjLSSmyI=;
  b=FwFgQbQTmhPoVw2RhLro1lW6aS6wqQ3SKHvBeeegI5M4GtxICimTpHYo
   4jz5qR0KV9qnB41DRdPGhBgbZvxdldctAgjbsq/1U5/yUjcARvFx4ZW7s
   dmjcqMDhMJuFQbFMSHIy2CRdbkBRdoCw0bcWhZ8l3K//8nOW7/CvPRGT2
   W4iesG565HGqKkRL6jneR433/71uLMqTLnws07D9NxCT3k0BbTVmz6utq
   koxFvyOXzl0KeJuPP4asHhGoFjSOSCg4tOjXZ5A4zlm6HWsebLoeEmOSO
   Jks9yIP7rToeb3n9dF/WwNKmUoF9+CTF93XME87lgDAYhz8sFDMgYhcLk
   A==;
X-CSE-ConnectionGUID: Mm15LrsCQE+zRNEbx4evzg==
X-CSE-MsgGUID: hCEabpicTdW6IrkYnEuJbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="55355104"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="55355104"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:36:48 -0700
X-CSE-ConnectionGUID: 7bsAKnNlRqWO5rO/4hwImw==
X-CSE-MsgGUID: HcQMWbjnROmX8qVPsD2KIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="163087594"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:36:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 22:36:46 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 22:36:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 22:36:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WC+Ro1ZNNO2PwtA9qwMh7ApUiEuQiKUhJXiUmxKdW3Qip7r8BYyyRHHIkYgApdFlqBRFF2p68GzmfcW3S653bLWCvs8zcoA1bWgck/zGhfUz0Hc2j8ucUznMoJeQNQJcZ6VzoTb3pebHlut7MoQ+eXWcd0nXPcKzNWoWCjrq+8JmN+DzQSv942G2ZJDV/10IRlDd8SepXOaNo0M05pfcn31LbSGOr9kMl7vR8ZnNsygeHVSAy0tOJeLVZ8TbmmUrz9VE1z1pXJILraN+lvGe5kiQk2AMKWB2k2GlquCB3V0ZYph4PD4yMt1KKO+hapshTs73sh2PBakQSyHj7K7kpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZfAw0vPxnxSLyMN2Nzt2OLaxUtvPoyIbfQXuac4tblg=;
 b=rUwl8EZu+2e1iGAmJOB79GSS0Ontu+xy4KazY5jVgRmRNCAzT3lrtFYRySE7uS4WhMAfAXoA4ebB6al8+SO1GdSC7YQb/p0P0sUsBmlOBXYhwTZcPJu2OM9YlGZwPsvZO7u6YUy412pREtvcEEjqlshHiwla93qH0PrtugLRNQCl6QPl2OkkQTN/eReddwx0Ttof3GzF8nSmKBbtJuMR4ltNBhDO6zDc8fJHmn+wkqQEXt4VZGnFPuoxNaJIwiUuocx+o4nsZDUoZZ84dhEe939KtyoR6TGZ9Wfy7TjINDiwHLCSamgdG89JNOG5kOZUQkjrwjzVblpmNl69/rlhKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CY5PR11MB6368.namprd11.prod.outlook.com (2603:10b6:930:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 05:36:11 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 05:36:11 +0000
Date: Tue, 22 Jul 2025 13:36:02 +0800
From: kernel test robot <oliver.sang@intel.com>
To: SeongJae Park <sj@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
	<damon@lists.linux.dev>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [selftests/damon]  4ece018976:
 kernel-selftests.damon.sysfs.py.fail
Message-ID: <202507220707.9c5d6247-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR04CA0202.apcprd04.prod.outlook.com
 (2603:1096:4:187::20) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CY5PR11MB6368:EE_
X-MS-Office365-Filtering-Correlation-Id: b1787c24-3585-439f-e3fb-08ddc8e1aab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6V4ajDzKeGkYpVuFQANhvpyjyWHxkrc0aT+68A0cXEcbjidSzhE7aj7Urd0n?=
 =?us-ascii?Q?C8wbaYFt0hri32O/9ec0H4cMRU9S03YsUZN5jXtW9oB8HoqzXMWg+V+5f41/?=
 =?us-ascii?Q?X49J/KsKWaNxZeURmwZzezgTcsmav7AkobRT9eP/ErG5ZBoHeHZu2RMYIF8W?=
 =?us-ascii?Q?hJ8CkqHALNDdzAmPoA/7oUtT8v6i+7GlwjOXj4s2aYPZnwEcrW0qPUZVdRuT?=
 =?us-ascii?Q?uX2W/582g7BL7Q1tlnEh2fQ3qzpCyTq3GKmL+eiBiiKlgM12kpoktrZlxw0h?=
 =?us-ascii?Q?BOdagdQ4ZTdp7p7xcHaY7SOUDssV+LGTwmhP1ooqWFmHJNI89mLmjgwIJSr8?=
 =?us-ascii?Q?aqmWAB7blwG3Dn16Kboa+VX3MZmrYhYwJEZ44W+ZaLfg+mWn9T7o7wvx9lgI?=
 =?us-ascii?Q?tpyhT9g+oUtQKwq1lJtfCSZSou0jkrY3Kr2p93l4t3d+AQxvy7xg23RjgJzo?=
 =?us-ascii?Q?cevwHpUUoSWns4bGGpRJHVL56jowqUYseGKdZ/VP+PX1J5ukohydDyzidZCc?=
 =?us-ascii?Q?xC9cv9eOrV58vyH+PulL3hEgzoeUxzIiNjGkO/9PzgzagQwKuNyPFSmychwg?=
 =?us-ascii?Q?wGLUHxAcqvittnALGka/W6pZyqhPdJXMZJAjYg0PXTp5NL9yHKj8YdZm5xyw?=
 =?us-ascii?Q?D4+Bb7LKQyxIrA3fwjhxcquc7Qg5KgW6Gx85ZnuxUnvkJcQJs1+mwpzRY+Em?=
 =?us-ascii?Q?WhAsjEzU6nBRsJN6AaYxP/La0athQHcvvr6q1vnwJ1U3DweGiQdiaim2wbIj?=
 =?us-ascii?Q?jh734Djp2kRxd6F7Ht6m6VCsJbXvEBRMHMQm8Gpu6EP0aF3fL54P00ozRKTw?=
 =?us-ascii?Q?PqkIjAo8cQIJP9e3jHhB9IE0erBmL2t0ZCB/jZWw49K615h71q2EdnYKvQ2i?=
 =?us-ascii?Q?8T483nhSp+dqh/i+3LVczOz5weJ4V8UGxT3QKnZVMxwX7ad8H4V2jQi1+8HB?=
 =?us-ascii?Q?/czR5olL2NwOlG6uwj/CZ+Yx+MFg/48TS7QExYu4pHlZZuNMJZD2sqh5dtt4?=
 =?us-ascii?Q?AEJifkjxQv+SWjatoEXIi6XEIT8KNZI03Yq9Nag4lBweSeWAL0ecO+6052DG?=
 =?us-ascii?Q?xKs6zfgKX6YMG85becuuTyRaAhrIPOyQsl1w/en8fhi0i9NcJqfgx0VE2SDZ?=
 =?us-ascii?Q?+cl9q3mL9BE8NdJrZRZWUCMiunEitsFJXDd4kMMlaWTyFp2fZYODOZtOUv+Z?=
 =?us-ascii?Q?t6T6KyvVABteeHfmT67ZEiOj1OQFZDyNmCXkBsrEUMM51QaHE66NejO8jYHr?=
 =?us-ascii?Q?Zeh69aCSJLiaw3doLlRfLqG+4s4Pnj8/g16GABipfWqGfItSTCBadipCVp2e?=
 =?us-ascii?Q?tEmc3L6pagH93mN8qTvDzI3HFEVPtaY/F3DQeHqlKOKiLb3lN6KInyPB2DSU?=
 =?us-ascii?Q?dD/nMO2nFuVRl8H7GT7liBt2CELv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZCXxvsCRLhav2MNJdcvFqp0ug0S1UYopRBKNwiO+pJ5eGuepJkKV+IaSGPxV?=
 =?us-ascii?Q?QPtZoXhlc2Zg+uI0B8X9d+Sdb3MIHB7w/rmyulUJ8PMGKrQtQzzpZlshm2V/?=
 =?us-ascii?Q?ILM76u/EV7yh31lNJTwFquRwv7wUk3bPttqeRYkBngd4Z/9u9nArVSbfNwfP?=
 =?us-ascii?Q?ZkLZyrIKxrWSZZVaGWhsNMaDXPWUNnpgX9kSdQ98q+YvWF+MPZ7Dx8FlaYJi?=
 =?us-ascii?Q?vqUTGxxe3p3nYjzsWVsSrwBzfxKLj0L8Y14Lfo7pv7V9G2mD/qKKtz6Ju9Ou?=
 =?us-ascii?Q?DAIeasmbeqcVbpz+KoC7Giimvtyb9xporvgP8aHF2SgdYISEQdN+YAMVjsoZ?=
 =?us-ascii?Q?Opq77e1i20ZqKxeWss/uORrIFfnTealIgMFQ2IUmfBAOWSdPfGok8kMtKadv?=
 =?us-ascii?Q?i1wPB5w1iUuKr1COPUXeFa+3Do12eNHnAtdiOSQCPHFusqluUxDVauo79B3y?=
 =?us-ascii?Q?x5RZ0dm47ED8GGRK8RHuoOF3Z2VMEhp7dHRtwpHdjZ/TiNp0lea8mEEQ7Iea?=
 =?us-ascii?Q?c6kTob5Jde65BjsqKQ8km8vlnNGiSfkfxzAg2zH+Nlt0ebGbw6oTTvezmzr/?=
 =?us-ascii?Q?SGiCJc5xWyb1qjA2KF8LsERAbBJeTwth16zfLwEktWvXLd/fF0mD0i+4AIpn?=
 =?us-ascii?Q?yCPJhGiUs3rRc07wEPtNLoABiam9KCioP7/o+Yr2Bvzm0+p2qR0uvcgBmsm6?=
 =?us-ascii?Q?rQ5jbPXJXvfAsYAIFJb/cUY8yx7QR0caa9567rq+SRV5r+c3m466brWTvsdp?=
 =?us-ascii?Q?l52nKOJDVHTMzbcxd+1Ct1hYh2kzFwDTjsxrqQUVd8NDRMR6of2Q2e9QgzXh?=
 =?us-ascii?Q?g4lqxvqqdnRY6b9MJDVzCIU+KNV5h3fElSS3H//IdLME4FrznCsTyQUS+ZeW?=
 =?us-ascii?Q?RRihx9ihTMYH8tPA6KjmJWFnVLjB4hB4L1Qu5YXAXKmrdoyc52J1GpgNq7ej?=
 =?us-ascii?Q?Y+xY7tgONWL5kKxGlvC9Nup7+SJk1DLWM2eBAhnIYAua3GdLxHrpYZrklkOf?=
 =?us-ascii?Q?+NrTJaisbmbAMm4YQ6ZYxsXU4YnN+kySpFR87nDSVIHvilSAIBuxFfUFdo1T?=
 =?us-ascii?Q?fGH6QIOiAjZm5he+pshRpKxfX0zI41wcaUm50K0Zty4Ul8DjBuFiTd88RdKG?=
 =?us-ascii?Q?B5E9Un47ViP8uX+2E77xysQB7sIf057JG9aJnVldLsHLrwNcwItaW+OVs7R8?=
 =?us-ascii?Q?f3+vQ01ZUqllLgCXVhkK/9qIpIWsqYdbvjhPU/vA9AOsh+eHac8RzHQEk0wN?=
 =?us-ascii?Q?XEk6uFhaHwbmPG2uYf1aIj86RTItVPE93Ova2ESf/bwBLEvFpmmgbu/ZoBVB?=
 =?us-ascii?Q?knn1h7DKGnyKA6Ufntkezusm6Q7l18g/Ikw4Ki8mcy1mKPiSvIuQJQn9fxVH?=
 =?us-ascii?Q?i0EKMjYUmOHdSTC+D9n1CeBLHiEG/ur17sneacTK/fosrMszCx2veYq3X9ek?=
 =?us-ascii?Q?7HXxAF38MdtgKwZUsmeDnB3Qa3H8vqRHTiDV4sJ756BSJWmuBrMoOQV5hFPT?=
 =?us-ascii?Q?A379kvip0Mlcqo33ghJ6z+K6JQo1mkaS4d5aM4Ggwo1bcwnTEOIQZBH314vQ?=
 =?us-ascii?Q?DwcWw3NBAsGa/YHXXyZG/tBrgvNL7X4Rcg48nzZku0r1xV0z+VYiJX3jXFa1?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1787c24-3585-439f-e3fb-08ddc8e1aab4
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 05:36:11.5022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LR8du8iD2MNrnn2o+sfZPnSZioXV4NtD1tUHgYSbr8OfbXxDSBl/FEAFK+URZbnfzmegoEI7mJofiBNB7knZzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6368
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 50A6312000C
X-Stat-Signature: si1etpy45tr8ciehiikd43suf3eko1z5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753162608-192608
X-HE-Meta: U2FsdGVkX18s+n9pCb0+zHV5wRETV7o90qtvdw7YeyPvwPk6LXuUkCv0iyrx7Oi/IQ/AVnVDXJYivk+Z4TxOxyfXhY0GKUNa1Ubc9shtS5QbwD1VHWC1s0ZDlKyktUsW/ypd3Z1OkKktFJahgpF0MyqkRU4gK/AYE33NX30Wd1e+pehx61G1RoTM0fHf+fRqc45qUQeeQ18Y7DBJBSvfS3+UHRp9ENdPS9Vu9FQTyPBsF2ZwzKXYq8Ex3xS27zbCUDvZChxiNQ35RK+EV7q7+vn99ZJBIQoaJC4ew1UJ+Sm008Q6Xz9YnLtekya9VFTvhpOEWZpzXrywT4MIxZBiwIOBKaHBY9ffoheewzmCxPcwV6X7jLKFDskaRc4Zj1fCw2WEiMxHa2SVJYeNgYRB9MbcVueMEF9J2tmqe/dRPD1kXyQ6VU/axvWG91S0KNz4e7Yh8YuGc6JCqTSrK6qzNkCRx3vyHiTD98OiwjjKONGxGgz3un1tmL1BIg8TRMb7GjQxF80S/Gmx+9jHexwwypPU67gwSvfteJy+m2BIFmgbAwVImdGjZM5ZLkYdpqkILE8NyQfDZZF0VGPfs1Ouf+G3AuMuP7JZolYP4uIla7kEV0sGviysWmyDTGRE+M9p1FncVLqYWpKc2IGpdkrNir+LEmsSnKrSRxqmTSpybFCWeBrlKXGJrmQqgLK3wZTWsH+1U1SB0NN820zjfRMcRbnMq+YwpUm/wl2yvZ0fh5XP6jhcdua06e1rQ72i6AjYEDgsOLRA3rp2JixEsBM1c0cQRB6CDSdLouiuxhUvSlwrgh3xap1vL+oA4i5GvYfuD+hclk9ZQw7LmhM0h2P/Y1vyd0hMy4c/zXbPCizxKhl6d2onhhHAYSuyOpEXPYRhYO13WDAlx3HpQuP4MIidXYhtDPHoZVte6GnPJKJuLlS+NgIjX21puOufLmD9oYEEx9yC7VIv3xFFTHg/JkG
 DR487BZi
 lRntxuiRZHxwLLfTlu9YPUCuLy//zaN9K9mtyis6hLhIiFq45O5ctLKRzqHaQ80Q01moAQcElmhyvHJrn8t5i8K0SiatknKk1m9Qo5L04OIk8bLBVsW/LtTCZQIKOaUFUWn50Q/A4IiOEW8hNANTAauPlwwkR7jmCQgHknSuAJuEqx8DaGfR3WexQ2xFKtZZ/ab9Zv7RLoGyB1S2heMKH1QOISSNBKh24G0MUgFNugoEvVIakyN9KiqM+C30uU6+xvV25yk6G6uPMyyIHkTbhivH7imJgSw9e877D4lMfRT99REpSaRMwK3VvmDU+zAy02HiJcnKQDkpl8PUroc1zp+eKJT4yl+9uK7XwyQ64uvixC3cPKlh2t6fYFBtDSuBWodqk1OQXMVU9kJRqrbZ61gM6G/php18Y83px4GNXoAgK3pzu5Bgttr0Gj+Vmdw3LV4wfVDPdCzPpxViS7Zt8GxCXpqL5wcVGLgN1V8KVlNZWlvA209EWd6q0DuoUv346CkYnXhmrDgy50l75DFf2MXopMPplUKsxnwOHkUrtWp1TEiZ4+fbj7++PhAiXKJA7JrIMNe1xTYP7G322IFOnOrjC2Z1izs8fNIDjeHQIG9gD6JPaXAVd9D82jELvVYLfsOv7S9slZmyoJ4LkhDs3BXqA9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "kernel-selftests.damon.sysfs.py.fail" on:

commit: 4ece01897627ddeefcede4ac709cd99763994dc4 ("selftests/damon: add python and drgn-based DAMON sysfs test")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master d086c886ceb9f59dea6c3a9dae7eb89e780a20c9]

in testcase: kernel-selftests
version: kernel-selftests-x86_64-7ff71e6d9239-1_20250215
with following parameters:

	group: damon


config: x86_64-rhel-9.4-kselftests
compiler: gcc-12
test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-9980XE CPU @ 3.00GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


besides the failure of this new added test, we also noticed below tests failed
while passing on parent.

e227472ebf00b6b5 4ece01897627ddeefcede4ac709
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :6          100%           6:6     kernel-selftests.damon.damon_nr_regions.py.fail
           :6          100%           6:6     kernel-selftests.damon.damos_quota.py.fail
           :6          100%           6:6     kernel-selftests.damon.damos_quota_goal.py.fail
           :6          100%           6:6     kernel-selftests.damon.damos_tried_regions.py.fail



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202507220707.9c5d6247-lkp@intel.com



# timeout set to 300
# selftests: damon: sysfs.py
# Traceback (most recent call last):
#   File "/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-4ece01897627ddeefcede4ac709cd99763994dc4/tools/testing/selftests/damon/./sysfs.py", line 42, in <module>
#     main()
#   File "/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-4ece01897627ddeefcede4ac709cd99763994dc4/tools/testing/selftests/damon/./sysfs.py", line 31, in main
#     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
#                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#   File "/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-4ece01897627ddeefcede4ac709cd99763994dc4/tools/testing/selftests/damon/./sysfs.py", line 13, in dump_damon_status_dict
#     rc = subprocess.call(['drgn', dump_script, pid, 'damon_dump_output'],
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#   File "/usr/lib/python3.11/subprocess.py", line 389, in call
#     with Popen(*popenargs, **kwargs) as p:
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^
#   File "/usr/lib/python3.11/subprocess.py", line 1024, in __init__
#     self._execute_child(args, executable, preexec_fn, close_fds,
#   File "/usr/lib/python3.11/subprocess.py", line 1901, in _execute_child
#     raise child_exception_type(errno_num, err_msg, err_filename)
# FileNotFoundError: [Errno 2] No such file or directory: 'drgn'
not ok 2 selftests: damon: sysfs.py # exit=1



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250722/202507220707.9c5d6247-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


