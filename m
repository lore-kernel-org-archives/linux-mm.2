Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EF03C44508
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264306B0088; Thu,  9 Jul 2026 04:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215436B008A; Thu,  9 Jul 2026 04:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DDAA6B008C; Thu,  9 Jul 2026 04:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0A786B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:53:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D6D21203DA
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:53:21 +0000 (UTC)
X-FDA: 84968624202.29.12FDC64
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9536B40003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:53:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yhep0vvX;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783587198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGXZbSiscf7+vQ01rxKj4txXvstwJMfnLNI0IBMquw0=;
	b=Cdb1RShViGtNV6gNQGrF76eKS7Ffn9kHZspiujL/evo73mIKP970iBM7qwzYBvAZ/qB5fF
	LJYRydKc1Hts5aA0vQ+lhZAzjiEaYsvUl5VU6IyuIlTrH+SO7y1TUoOvc1p5JbCG+YLW7S
	8lw78UKrgABx9KXqYWwQq+TQbc8+jCY=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yhep0vvX;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1783587198;
	b=qjEfNG8DFPE69csG14kmfmnUWdouIvtkSFS0xmjaSpEs/8yK7IdS9ZptxjTErP9k+VG9ck
	uRG7d9EkCMKsRKlXQ9GYCnNUcQKDuhdERFq5g2Fdx/4MDCFu0bPxUgGrZZrnEMrej0yK1B
	6bU6sn7tb+SeKKJLmm4H38/uVTc4DFk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783587197; x=1815123197;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Y9JruPjIP0CPvR7vG/hwZuZ600O7NSwWwp1K+SrCJGE=;
  b=Yhep0vvXiqwDzgB9qaNKSfIvJe0ugNCmAYf0aEnzpCKkZgLcUKZgWbt7
   eKIaDKcNcB35UjSIz01uTwYryMc70IXX9AZ4m2TPdEO8AfDd4NLMk0BJX
   Xpdwsy4/9K8ge+NDxvl7JQUOfOK4Y0ywryoiciKNPFfuTKU49unL+IQRn
   in5R57I9CPAafgGbYgSFuKA6uci/TtkK7WZGGEFuuCbMkuRRHcx4FPUqo
   U/1l27jVDM7DYd4oJOzf+uYFL+Da++3bxxKm1GGMvESsZfdj7dOMEMvs8
   AM76sYgzIX2aqE4ykx7Bg3IYXzrFo0liziK6FaDfJCBkWwgNNCrc5I2Jd
   w==;
X-CSE-ConnectionGUID: g+bDfeaKSrGXpPgR4McQxQ==
X-CSE-MsgGUID: f3e201m3SBy8hRiw+1PZaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="94908961"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="94908961"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 01:53:16 -0700
X-CSE-ConnectionGUID: k/2BJPNBRSO+asRxaLpJDQ==
X-CSE-MsgGUID: vRsHaXsNQd+pEy1XMGvHnQ==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 01:53:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 9 Jul 2026 01:53:15 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 9 Jul 2026 01:53:15 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.31) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 9 Jul 2026 01:53:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=beo2tadN1DojwwuOJvCKKTFTaGFb0WQKMUiR+N9mwIR3xeS5a6SiyLAUVZx4FpP6WVd0GoLOz19G7ZA5wKA5NyiCA8n7vsSt0b/LTg6mhrYfNoUGowZbbW4VuRg6/YixsfE2Du/s4+HcnpbpWoVL0WaAUqRrhRhq/UIxUxzt44CpirxFBU/fQVKF1GeSDWajzWvayxLjU9bMPC1AR+H1UFTGawBtxp+HXKHbsEft3cT9FWmtP7b99J8Ket4sAyk7xEMlRCSoaZuFghj+tsBIi/00ahZV/GAR2ww84I71GL1lDjkUxqGQ3aLV4FcNXdFPQeIr4BLb8bgw1SWqz7J9uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGXZbSiscf7+vQ01rxKj4txXvstwJMfnLNI0IBMquw0=;
 b=hLYkgsPm7XuUTJddKZ9nj4uR592pONiFgB8e3fukadT0r0DT53ljeZT3Mcvrj4YllEiZoGPiSYY2U5fFOj0t9XTTYjBsXMFk33IX7MYVYt7X2IeFXsu+4AhWJ8dQMl9BpToYVASVm1dXnPQdIjoB7TtxLcg5r72JrpRlRu2xhtjkiCxkNjGqVUJXGzBrhRWMVajzPZbFfMk60KHXqsrvEJ9IQIkJuAL7hWhgUCCVeN1Ml0i+XXJoElvaHmIF+MzeyqKU/FkhX2n8wCPkc9NO2V+dXwrpHLHKXJNz5t85B6Y9gVk364S3faOHpmW9K1nOtnKvh6rfzYHpVVsFHwO2EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by BL1PR11MB5304.namprd11.prod.outlook.com (2603:10b6:208:316::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Thu, 9 Jul
 2026 08:53:13 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0181.008; Thu, 9 Jul 2026
 08:53:13 +0000
Date: Thu, 9 Jul 2026 01:53:10 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@lst.de>, <kasong@tencent.com>, <nphamcs@gmail.com>,
	<baoquan.he@linux.dev>, <usama.arif@linux.dev>, <shikemeng@huaweicloud.com>,
	<youngjun.park@lge.com>, <chrisl@kernel.org>, <linux-mm@kvack.org>,
	<dri-devel@lists.sourceforge.net>
Subject: Re: better block swap batching and a different take on swap_ops v3
Message-ID: <ak9hdtiaNFx6yqFs@gsse-cloud1.jf.intel.com>
References: <20260706132206.935272-1-hch@lst.de>
 <20260706102118.6b6ecc0557edcbb2839e2ab7@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260706102118.6b6ecc0557edcbb2839e2ab7@linux-foundation.org>
X-ClientProxiedBy: SJ0PR03CA0131.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::16) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|BL1PR11MB5304:EE_
X-MS-Office365-Filtering-Correlation-Id: 29133c45-d6a6-4791-8d42-08dedd97823c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: gQxAEsm+UH7+iHprQi/JiZkWqNJf2OoZl4sR41fRxrT6yl/3J/ki6ysFlbq8qMJVdlwbrStM99eGP8pf0E/5ogdED3duUmyisY0FQtbF60P7Zva7lzTvPr4SwSNlg6yoNo2Uh3sfSe3yLGsp3Qt2rfNwrbQHCvn7IRtdcsLGc2hvurKYlEzKmHFTFyIjMya4E0+luvjoNXlmxVTitnmTIM7gbrjt3nxnNShiXw39KwAvLG/6Bk5/psDhXx443vvHSMhtdRrMrR2oxGu0jAp3zClXIzr0fFDhY18RoIwoOTMqw6UCMwirMCCiC44XBmMW1tKNuwzUwCYmVQViJCJBG/IWsRrN46Xpecs0yxf6htpGKUJKsi5A4ABZbWfyBoPFbGQVqbfv70sCcO78gu+x/YhPLbUO7WCKKXCFNdq3cmD16d2kB9+8NbRBhraj5DUhUrHzaBp/B5O1sl8byKqRrQigb6w9EQXoiPIUoNWVCftnaLT1OmNqSUTb+/96Yyj/4/UPGLRAvNyGO56fNb48pQyF3XPEIhHiMBnbc853YQ81OrLRiqQZ3eB+cHoxvskXMIsOlW5J1fmm06S1M1YSUrjbOI1a2Of74Td5FpVzWeY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FPForokubtGy9pejybEoNH6TSa5/xpaiC8jKZS9lkQXrXYStG/9vYuXKiyCt?=
 =?us-ascii?Q?DVcCkrqTiy5wM4j2wGwkjfbQaqbLGkuDnr4qH7g1RkZc3aQECAm2Ts8qNj/F?=
 =?us-ascii?Q?ShaIaS9GfXr7t+SlBOzswBp0mBwSD2meL/hb9hCTTzLZ+86wGLStAvwElsX/?=
 =?us-ascii?Q?2hUMR50zWBK2RJA9ewE/WqP18OdNkY9Q6XdCI+Fz0MBCVbTbFVipak+lzGwJ?=
 =?us-ascii?Q?9/ehJtMLAVamWqCHnr9a4LauEtbNKfyIbOUelOAwdkwO1SK8e96Wx1R9T/IX?=
 =?us-ascii?Q?Uc9EnRt4AgIif8Nx9Py1vjS0NJ74TCssVExglR8XuLRAudQln8vGwSXXzfBN?=
 =?us-ascii?Q?+pcj+PbU0zJdEjvyL/wm9Dw4Ro736QKGqqsrXDY8kG+WarbsqtfCMB9/qdbI?=
 =?us-ascii?Q?ZRzMVJhQyYypX+65l6ECFfObf5QCHA6pZAe3S0Q02K7F/Qp78BJXZM1LLidZ?=
 =?us-ascii?Q?LH16uBlcjyqiZjqMgvJRbIBRzIfUR8nansgdxOG0s0KzWyGn2ndWeUu8o3ZV?=
 =?us-ascii?Q?qXNwzuSO29uhWsuDmijOv7GUtFakirf+hx7O7Z3O0Di+wvaQetzO1YYpuScD?=
 =?us-ascii?Q?u5MCP9LM4xg5oVZkB9SdbyEpYGnqNSQbxGVZZ7thC59N1POUqfCgMQLQXwNR?=
 =?us-ascii?Q?mtbqK0y41FluIZxuIy/1zYZlxyUUxfuZDFJ5eM64o5C+a1oNZGQ3QTNUCCn2?=
 =?us-ascii?Q?xEaSUQCOIROVgmH2YEt02vSkpMuFJ4tOZw+QOrUkM3oxKUYjzpCqu5Gc8LXe?=
 =?us-ascii?Q?qM5WHL4nSl99Dw89zoEVVwNk6n2dDvfISM+q0RUO8ywGF8W1vkSfhzbWH0RG?=
 =?us-ascii?Q?5StNyBVnEhyujjNkseuOMA1dd90Phy72uu6xEGT3gc+7X5XNSDh1Lv6jlzmy?=
 =?us-ascii?Q?6Fwcd+GGPvG6o6SajnwToeoyu+FRB34uavm+Rsu9zTxDmr4L9QjdJ/GUXZ3I?=
 =?us-ascii?Q?w7LV/8ZLQVxYXRBTmTE/zC/CqyZjnoISYq5Ul0X3Fm0dRYNhKQpDd7IHH58E?=
 =?us-ascii?Q?7koUyw7v3e9/WI45X7yw1Xizo0VX7PYMQvpfRJvwDajfSfiiyTWVZHvdRaiG?=
 =?us-ascii?Q?OL6k3BnV/k7dRl/8Z+KXCxFDKlum8i5WWrCeihRhy7hSzVyz5aeCbGTsCKxG?=
 =?us-ascii?Q?kBjl4OWzMHZK+tqJ5JBXBV99Qlrf3hzmsMo5tTmcFDXV50LfMeGTHNXmbBGn?=
 =?us-ascii?Q?nNP7XriVfnktLUVh+tI9pVf0VeV8+WrZsO8ATtOybI59ThF3fdofrPTafK3D?=
 =?us-ascii?Q?4/XF9ozeG5NJZt1WbldEGZKWPrIpo6+TdObbkRcTETEMSah4YK+5r16cCX/N?=
 =?us-ascii?Q?2Ce8Sr50P7TMJw0P9dtqa33YIGjQC/gF9TQ/CbwXjqXrg6KK2t3eyKXqCoUG?=
 =?us-ascii?Q?eesafUQOb+kOjcsOhOBzbazzR1oWNTb861leBzPu5Fmvj1/Uki4fX7iWzNf7?=
 =?us-ascii?Q?wBrAYc15Qa54qRffMgvlfeRxO+NeUCwU01nAL0KlXIcJ9WiIlrERKO63oqVe?=
 =?us-ascii?Q?wfJqRdiSpMvsyk/halLwfxgi98sRnClthECVP08teKbGn9dT4BN85tciw32H?=
 =?us-ascii?Q?XZ7lGBhXArt6PqMBlQ1hHbglXI+cNL6X3++wF04Agun9pFIX1f/SHZZPL9Pt?=
 =?us-ascii?Q?cd2AR/z96JhGjaVB7VOHB0Tx3m6Wco981q0gwDYwnjTmaIM2Dj+GZkbWaG8C?=
 =?us-ascii?Q?zlNtcu8qF/e5fwlrvrGHEvjZ/fmD1+7fvLDo+H7CgNZ58hiVwgZ/65hpSjR7?=
 =?us-ascii?Q?FOpV/Fcwgw=3D=3D?=
X-Exchange-RoutingPolicyChecked: SMMZOY8ZEgcB+AgMdnJMlq9vzcoVSchlGoFth+voZPMrcvfefQAHELKANyqDzEA+70j961C2Uy6kdXiBpv/KZXqgy1l/BVsQDeU7qRjGYKgVbDxn1lZ8WGb1I/XGHDEVcYNy3bfiwTW2+9XSscr24UVICFJuseRPTNakOGMyLlvSavw3GbuwlWHmO21XXShVOf95Jjob1CXRwiFZhbuFZRhiw9wCk4pAxc9qplXsSEPM3sh/BzhQN0kHsfVPsIr/WNfj6dgi5cQf3Z5FtMrXFaGhRr/Uvvv/Uuq2PjCrDrIwWcwGHpJZWkpgVnfD0mvrRnLA5WDYruemVTM9mg1Z5Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 29133c45-d6a6-4791-8d42-08dedd97823c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 08:53:12.9495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UGk+LBpGgfL9MEzAnI8orSbBzpXT7Z+kXUW8nvtNgsazHIV5bcuZnVaD0E/K0tAzBMvIXpSnaRa3t4zKEIPMfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5304
X-OriginatorOrg: intel.com
X-Stat-Signature: wdp6wiwo4y5qbmnhazjdatkyt6pogj7f
X-Rspamd-Queue-Id: 9536B40003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783587197-254418
X-HE-Meta: U2FsdGVkX1/gKcYdFF4+vkRTc1TGvvpEq3RHoK3A8Vkb7NatlLxdAsH6oB2nGoVp8YM1vY3MWRmcEAymy3KSFX/1pKzuy1QgMFKs2IChvfZfVRuBokAYL77k7OQZ2Ej5p+q8pXRxeIVFIuUHkLUDJRHrgFfqhuZK3SfLaY3Ja94fMKu8365wLDRsfq8WTsUfnRrG/A/J1CLEzdRasS8P+IPWHjj8/m/XGrVQagWqx2a3AHty1uYa0+BxnF3WWS0VjI5JOrJQlUWG1cx5w/tsbwxeR9bxpOOZ1+lwwXXf4l6VVLc7Dxykto/1ypdCr6I/QHhMEk7Te0PMHNpn628JF7Mhip4AZ819KQMy2KMm9X4n4/ArmI+MO5ftWlu93E0N/CIsoODzLDY7Xh1RRdM4xOERegqT5j41Pn2eJCNanaBr2+pwfMkJ/LU3/7cs3LkVpw5DDQWnPYwPmv/6tvPmifdvifKLN0vtEy8JedmJo+/xHQYYNOmxSfA4xX+9GpRO+UTb2jRwFeDkDmlUWvEQCACfRm+gdvEPNE6OXWqbIayhs+9S+o7WpBvNx/+HLr7dnV2qensok2QBK8KEI0EieKkt6J1sZkwkp0D6vICobwzwGUBFt6OOckAkrszVrp1AWaslxT3TNRKoAZ/y3hcvLllzEcCLjawJ31vwpvRLpBKrWpeaFOuPDbqjhRnfokz9whECTn9JsST07vNmtsU+yN33Xdvc/AfUIr1PXXjfBn922YiMrPH9p+lGhx671jFsc8yA7GPsg9g/oRj6GBo4NIVF1jRA2zMzP04GCwJHCEhof9QWdqbO5O4MCFKraTb6NiqKsI+dLXYK9/bQHoCEtaQ9psi4TbB6ZFkBtbj5gXsxx7vGVyGmbDKgPymfVp9yBQGN1M1qbPr42u0gbPfm5Rw3SVmF/jhQN1bLF4DbA0ucTowd9BZkxdce8Xsgpe1kGdA09uejLaYPg6VbQqA
 H3BpUcEM
 3HShxzaGIBAX2bjj5pb2WrzmzpvrGJ+coc3hRX2NnHJvXS8w2yFTLfUgBD3L4XWQOHYGNspwYajo14u7oQceZGkkn2SZ84Yr+RyKpGuY6IBTVGCzWgzupKqzlDjN6euLTpfa7TM0VJG+u5ACIEeEcKj2UJBucYnx/43ZJYyR7uLjYZNfWa9UDrFmlhrKhh6SVK4UfqGy3ORFRSNPE3kN9TkSV5nkMuG4k6The76UI+TdKwYc4Zd0737AI+d2W7Gbu6PUjwan+LOcQ6bkMqiI08maE9MH6Lm/D+Dgc0bGiZpAst6PsgNVHOX1udlsxVZ/e4H1e/XSO5EcSf9nG464+cBi7VniV4GGbHhLTMRNspRajVYR56gelqxIgAVeVJ1xSGy5seqPIyfbcUwFUJ1C0jX9Y+OYY0rXO+AOCtEOtWwJy00/WquWZMlHtQKZpS8lyUILr+RO37GQvt/sAAeDWGxxi64JCFaqWFkvBv7+QQy37jSf5z9JLEbu9tk5++RY4BxW15Xw51e0aRUoC4vMKWxoy2PbuRmcL4stepFsjukl76ifj0Vy2BRzgoez8IOxlM+uhIYF/rN9LhzDVqEdeK5NDdqPZm+C6qEM51Izg9xMpNLyxEjgNgzmu8dytnKw7GC2zn8jJCkvldeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 10:21:18AM -0700, Andrew Morton wrote:
> On Mon,  6 Jul 2026 15:21:52 +0200 Christoph Hellwig <hch@lst.de> wrote:
> 
> > this series makes use of the swap_iocb for block as well so that it
> > doesn't do inefficient single-bio I/O, and then rebases the swap_ops from
> > Baoquan on top of the now very different method structure.
> > 
> > When running doing kernels builds, which is a workload that doesn't
> > really do much THP anonymous memory it still gets 2x clustering for
> > writeout and 1.2x for reading back swap in.  The overall times do
> > not actually change, though.
> 
> Thanks.
> 
> AI review might have found some pre-existing bugs in 
> drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> drivers/gpu/drm/ttm/ttm_backup.c

I'm actually rewriting the ttm_backup code right now, will make sure
this part gets fixed.

Matt

> 
> 	https://sashiko.dev/#/patchset/20260706132206.935272-1-hch@lst.de
> 
> 
> 
> 
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel

