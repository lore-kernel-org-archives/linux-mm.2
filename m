Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC495C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 04:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFF9B6B0005; Wed, 15 Jul 2026 00:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAFDD6B0092; Wed, 15 Jul 2026 00:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29376B0093; Wed, 15 Jul 2026 00:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7EE6B0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:54:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0E47A057B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:54:24 +0000 (UTC)
X-FDA: 84989794848.23.0770247
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id C410CC0009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:54:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fCAI2DlK;
	spf=pass (imf10.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784091261;
	b=WmelOjJSYN+pTzlga7i7i7+8t9DI4Zlxyh/Cd2ZH6l4VoyVyATuJnTWbdXq640oZHSMSXI
	0xmZhD8rL8xRZZRSwZ2xZ588w0fqLffTKWxH+Nm2nFoAckDcMqOMYnEMhy2b8MKcQ0BBD6
	zmqtQ2nySaIdNa+tWpWO4MnI1wXh6rE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fCAI2DlK;
	spf=pass (imf10.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784091261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TJcliyH457PU7HwxUISWnSQMLtr1/Iwbzt2SfdeuSzY=;
	b=Fqn/1SycBEpPUQ/1f6vZKyDZbHWjR618aNm7mbF/YK/qbsLx/lBqZLi12GxUEXHj6fRudK
	u9//+cav+kIR8LoQbm6eltfNR+SkKbrYQ2KE9oLxvFAS+5r3iXTq0GEjpMOsAbQZW3ntgZ
	wzsg4S0+/61C31Db381aRmjyHYu5kxE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784091260; x=1815627260;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=f7j51dNJTUspj0hmZICB7CxDowbg5hA6GOyFuz8pLM8=;
  b=fCAI2DlK8VRHLCmq0tKWugoR4hf29QtXxMFhzmJ0Ja/KOxinGFOJz/Sk
   EjdayTfq5xIxkJGxBGWv30PiQPHLlRZDQcjsmJH5Ifjb6YTVffaqydvAv
   QHu0/CkMbyY31xWk7lW9E+6xF6DAYXnhfhiI9ZB0zqueviHTLL4D/7w6T
   Dlm7b+z457+YFsMVcNM+AbWr0qqXm6vtnIrikGgpeBBjt+3hpZ5/Z5y8d
   JBdUXHZnYAV9dNplU+Vk9kJ3tECsryfZMWBlKD+jSqxyqpy638waGV5Jk
   JDHL2iiNOUGmCJC8TuRJXccLLRjSncQhz/npGeJOnQof+UGED7rrg9IGx
   w==;
X-CSE-ConnectionGUID: dOG+1+PuT1K69sJ88vmthA==
X-CSE-MsgGUID: dEMzVnHiT5GAkAUK5ZcGIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="95073010"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="95073010"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 21:54:18 -0700
X-CSE-ConnectionGUID: mQj9+gGmT7m3Wyx0vedIow==
X-CSE-MsgGUID: hO3FoTZhQJGBkqCSGMIbkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="254314916"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 21:54:18 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 21:54:17 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 21:54:17 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.1) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 21:54:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X9rctvRJxhw1bZrAORTigI4uedIisX2plyt6/grnSN+bQ5QWbW1WzDKLT6Ac8KEjKqaJfSd4ekJNfSXg9BSBsoeURGzVehZse/hmCnuhEEUIQgSb3eHcAYmwnKZryrA8wXQTdkV17uXyYzFo9PHRaSAFmoroBSavS1DzWFLRS+/NvlgCi6zDfszGwE8zxXNHG1xXxWxDk+T6kC5RaBil88AsRY+gcBe9pIbwiMUtit3B9U0HPy7B2AWm1Q8dVsjpzOHs4VhaQb1Xaj5TrM2pujc0stZN9+ynK4bd0kvpx6zeo+v3XZGpJnUAbVxfVpWW4jLNuxQeZBw6hvjFd1fxtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zZtIWZYJhclzhZE0E3FIVttQ8cBSWbNmbgQnKo0KD18=;
 b=hVBhM7kUQLZeepL6x7mlJI0teyDL37y+mdJIIAt0VvVWiiKOJfF0L0qmleVag3aCpweEqWYyOzTuf3DcM2zOFC1cUVTjtFinHDWSMi5BHpsCN8tJxWOD88Ipvn4NWT4kSoK9zp81fC8qpkeYbdtdxsNnZmbwcfGNxGhCsRwzMs/GcoNJV1EAkjAtQGVCHXfDXuO7s41qr0UoySnisFbPhVtqBmnvB/f4G7MJaSHjUsuK6Np7V5t2lkNN5sXBz2532Bo5r6t/BGhd+dGgT07GXFF8ll5MPMP/a06qlhCeBAeqS0S7MLYh73JL1jaA57bS6SB8yrAKAjYNQj+yJTXgCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by SJ0PR11MB4992.namprd11.prod.outlook.com (2603:10b6:a03:2d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Wed, 15 Jul
 2026 04:54:09 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 04:54:08 +0000
Date: Wed, 15 Jul 2026 12:53:59 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [mm, slab]  ba74253126: will-it-scale.per_process_ops
 5.4% improvement
Message-ID: <202607151031.d368b744-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TP0P295CA0014.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::11) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|SJ0PR11MB4992:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ebe3b04-6f1d-4f52-611b-08dee22d1a98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|18002099003|3023799007|6133799003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: bGpeAFKNDW6SGVwjX/z1Hgwmt+G3OFPqxKDgjs7u3PKTG+9Ow7aoXm8ceUreMiDK3u2OKB+JBXaUR9JqvOkMxe6bBOca5skZQTff7nZ3o4NGFTR3Omn3x2vFvNA3GEdXukzShbOqrHNrtsbmqix5/+OVntBuZLLT+OV9xJM16PDGBDA2LWFruSCXNy9c8PDEEn/qSCl0Y3RenbY13zLxDEVJWO3/c0J76zMdpBUPHpyjaGtyf80vTyEPg3w/NHkEbwxnZe13vFULiWOLOxeVkKXiC1FuHsKNvQpi4vIbSZoHhfThsErEN9yPIXwMmk/Ulq+o2b/h1H94dq/tTliCm+I6OQlVm4tXV3r72mseig3/zBKVMKLETz7Xd6vhuHeJc7ozF50uyN9ChrmVhrcYbsLT4OcwUMGCFcZDKY0SyUTipRj9RjX9R/U1nA+VUPO5bcJMeEDWPXi8EvittviJD4VycijrcIDwZVRUttYCF8XYeROR9Pi/5tQeY+ML0EOeyF2bI0JNV71lbJ2Nb8HILw3PZIYcSrFjJHbu/zsfO6aj4T9iKMfLFBflgcTeqWVmG2aQowFd/kRCjn0QwYFQGdaje1Qi7Cqepj1dKt5PxmdgcQ/RdtQzGQZGvV+QduSU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(18002099003)(3023799007)(6133799003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?yUpd3rvPkG0hARTvq2+aHJwSygx3Rpe8EfwPy8Tuf4glrH0WGzGvs+UY1T?=
 =?iso-8859-1?Q?g43ST2XY3LAtbe3dGeNQWdO4jWiQ1Rc9E9ZYbu/dJOFXubDYffBjGuWu3P?=
 =?iso-8859-1?Q?UxUlePjkSwmFlnciSB8cOB51iHI5wZI0DMQRmabQjsUrIrV333ke89G7Yk?=
 =?iso-8859-1?Q?TW5vlkEH/8EAwBY01aGuse0XzqSYyeoNlrYXD/G4N+PyrakvZXnqzgboRe?=
 =?iso-8859-1?Q?5xchJLy1+hqKFHEw7rUdpMwzGGD4NWdEJmjJG2RU9QIbgTT5Y1c8lMFH2v?=
 =?iso-8859-1?Q?KL501GKRTaGhuorj8wEpAUV3LF2c3rgXZ2FaSFjjtDPHOHv9OM/ZF9/2GK?=
 =?iso-8859-1?Q?o/mNLl5aHY2kK5yM+J9ZLpMUfDCxMlfeNvtl99zPzCWU9gFAUj27dvQwG8?=
 =?iso-8859-1?Q?/Xu+Ui6DZ0kA1BJtIdA6U+6jH9CRodJecevc/Wfyx7F+thI8T4zlg3Nvz2?=
 =?iso-8859-1?Q?+rjAKZIACrv+KsC3MHc7z5kwvIdmdC/uB9DYiKb95rzz1H/uWyeO0Wph8O?=
 =?iso-8859-1?Q?1HFKNXbgFTB31NmblD64MTRmIK0QRPS6Qj2i0bf7YPuOZI0Iy6a+5QB7Hg?=
 =?iso-8859-1?Q?9Vy/FjUzIN5CcdRqvu7SiNA99Xw0rqFwSHb71YvSM5ZuzTxIPI4NPU+S6x?=
 =?iso-8859-1?Q?9HlmLYXSnJBb7fwBTHUre+OfYZA7Av7ll+RubH6X567ZPctJJ6ROKIhl47?=
 =?iso-8859-1?Q?jWs98bRxPpxwRRBH9aCYfu70lu7LNmZAL3I/fgllT2L3tX2zKwRsoLQuVp?=
 =?iso-8859-1?Q?n0j9lm0inqqqmnb2kwPlpsjF4EaiGGjVxWY8A0z0vK2Eavyu3ZLC1haWx4?=
 =?iso-8859-1?Q?6okaenAAZjIw3z19gwW98VRIMCO4wT3yrMdqa5RnJ6JAjXmdGQ3wwZBaKO?=
 =?iso-8859-1?Q?Ie1ZUcEtAKO/K3+DO42vxbi8UJyS3mpMtkelnowalOab13tGFbINahlRW9?=
 =?iso-8859-1?Q?MjDt05zP0HddCy5btj+pXJe3GXzN5UJdIlBtib0t0XoNB/Ije1lM27W5mq?=
 =?iso-8859-1?Q?Re3SGZ+p7spOtCAWg+9KBFnSk207FtO7xDRZHV4VZmI7rJusN6gYqvlmAL?=
 =?iso-8859-1?Q?DlCQp7UpNt9tgvSTuGthk8Wp5aDBU/Aq36TDnTshJGgkXmSshKqQWIc7Mi?=
 =?iso-8859-1?Q?Rgs2ZXoaASaGjP6dwmKYlLIA/NzSZz9FjDWhbHw6s+UKEyXBlDuwG8i2u2?=
 =?iso-8859-1?Q?19k0227U3gaaqoNlYfqFFZinliPiPwN79JCFVkOG2zPLYMecfvfZb3OrUi?=
 =?iso-8859-1?Q?8/STwDwTR7DbbT7DH3ZDfrvfGNsyALnlGW4RFa0Phc86tYWciK+ecIzEje?=
 =?iso-8859-1?Q?28cIwADCH5R8iMUtEELCdAohYgIRoKEyjw92GvmGq8oVPHFehUebEAj5vH?=
 =?iso-8859-1?Q?6ua3Og1e6xF/cN7qiUlb1T3qiVmHcYS29V0J1TBlAu/I55iqQMH5HfkeDW?=
 =?iso-8859-1?Q?V0kprz0vw7iUDtf9otYd9MT3hJ4aFf8smBBK939r6BxZkUQqzwlxqd7PM+?=
 =?iso-8859-1?Q?DmnhxBOs63nIeXO2Tk0kzfeCi1kDrklwDkQO3ClmzwzV9sG4meZwZS2Me+?=
 =?iso-8859-1?Q?yyFL4etij2jSus2hZ2/rPcG7mgdyS39zkfK4ngd07A4jXxt8xjEXFgIZgr?=
 =?iso-8859-1?Q?GXbpdpv8kOZwjiZ8rPHHluhgaRTch2/Ef4wRO30mgQKuO651JcobnYmGsV?=
 =?iso-8859-1?Q?Cn0tkS6ShVwBxXFFp+qhR4G2i89y7oKngEZCp9yd+8FNw76sx1cSw8UYiR?=
 =?iso-8859-1?Q?LBwYh6IW2tYE7+UEq05x9CzVQk1oZeMgCaxeKBNqeLQtBGTz0AO7dcC5no?=
 =?iso-8859-1?Q?REivdyZSsg=3D=3D?=
X-Exchange-RoutingPolicyChecked: U4dg1SqmSptCg5u2QnkqxyB5K+ext0bhO2g6dJfUqZSvTlSDx9/8Q7uuGTrSGyC+gM6g6QDbZAsmXLLKCL3wmJKqIkDQpQt2pwx8UU65V6+MkkmxktV7goD/PlMs/jTalaXAtZD5vpczLD9gTXcFjeJArt+n0OZ5T7/Vgc45whYYy2OcyEz2gi+hkoNy6Fw/1r1vaHTWPargHAImtcSmCakYzSsudRyHiOmoY0Y8dcorsmvHU68U7oU9MjRXkrQzTRzX4cERnFgELaqdCf298hJZi/0aP+L4rwfjX5+XxMZt8b3Ic26GSQRRoncVuk69ydieChkk1gD8tEUwkDOpVA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ebe3b04-6f1d-4f52-611b-08dee22d1a98
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 04:54:08.8602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0A80qoD3ZWZe56ASf05lSFJCViZDpSg5etN7EmgLVkX89GB7KdJYJq9FFCmBQUw5qYfzXv5r0X7HO3dIe9qQAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4992
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C410CC0009
X-Stat-Signature: 69dw8fkuhwk4mfciwerioiy553r7e67u
X-HE-Tag: 1784091259-165564
X-HE-Meta: U2FsdGVkX18m2QoT3aPzZmWWb3z+wfW7pH+146hisYA+u3btaH8EtqvbKqZqZd6Q72Qleq5GABU2CcNs0aCd5R5F4m6b2vZkXDHXSr0nevja4XN1S8QWJkB+NArgVWl/GLtTTx/8Oo7v/2wT7NPQBLgMG249fqABBmlFU7l0RQluTStBxwUZAXqdniLSK7jsM+KsB5kzxbLMR9L/9Ih4A2hcr8mQq+7w02NdbOKZdQPvRL2eRqVuTqDYd+6xJ23+VlFjFRjJTy3NUM9spme1GCP70MeEzx9GC9xrmxgznflDQb46o0lSWY3pWk1Kgw9BsQDa7nOTJ8bQAnQqmR8/RBkejNCz+yzxXKcrJJ0zH3sxiibUBQ+l4XxEpz7avZIhkd1m47rV0lAidmIWofmVxDmWoDUzOsrNQwfKUjn0LKXD0zDdipRn3DIX8JKAAyKM44y61Z3hZ7yiJniRobuZuA3gwpEPXek1CeKg070ECXBNO8ewTBMdnSIbQtKzCp8mp3vZghrHbkKoI3HwGHq4Z5j9Is4rSkAwSIscxEVvWQ6aitg7xG3nDhl2myf+43+fwmkYwk3nWKp2RxdYos7zX2jtCU44Ct79ohIrAJs5VXuRTcENCATTP9bXculvbEsu8xjxNp0rJ9e7OlM5BWmlIT2gPmBioZ6/JOzonkGDQP3BywCUTUYoATWTeMzJ8WxHNZQhsMZl2TwoffZrMtVAz5YNIUR1jo+yih5qi4sI5YRVlHuFEpjarTyQ+RVib3wvxUZoTlZJ7PeO/tWGsWd6g8PKaoeQ4QWRJo2Y92lLTp+4RAB2Uar8oVS1XcjksTIZ+RvkII0iJU3SCkfeKcP40R+dWjgQn24LQYSieA6XY2v3mFFknKsdrrHiu8evMYxUpqi9kP++NlnV4YaeJQIiCrUSc/EDMxq7/LiH1odkgM5PYNCsOP7W1HGldCKrBoS4UxfX4zrP59fCiL/gbz7
 2l5Lg9Ya
 HbgXU1mwKo+palVJsfgfydGzpqOSZlUFYV0DATxq/0/xTiVs37yMLg/6NDQLDd5A+RpQ/8Qm6CZ7Z+aY11CCQzPeaxJ4AYokV10RRiZVptRIYlTLYfyMFEGboRPbLdxkCe/yFoh66iAL5lCsyyd2aya1JxIDW+UCRoJen5+mmpBl4oCerls2jP4B4ZF8VtZOTW7mYnaqDHJbn/C6cq/LdV98xmjVu0JdnKVsZIVUwjUftwgVl75o9+mldfPXeHYM6WuMJ9Z4sR5duJB0hrrruNNTjZcbmmbYuXGFuJQEpPJBLbEAXv8rGXrG9ke06hJJGBl1BiJi/2kl6tVtDOuvWPBO6O7mNwOlnAhFRTz+caTBH2rDRztSU/0jHP8KDd9SbE4zdAARKDIRZKXqC69z3yIkrd+t5CPvyGtncceChFiA09fsWsmQ58P11s8pp/DiP1vIB/Aze72T3Ex67UzDiuhiQUeTXFPHB30GC46Xrq3+gkXdZD2Iz45yjOw9BQLfqzdMnBULkma484Hqkn6WLBlGeIcnL7Quult5lUIjZb5Tx6UahKnWMyGuH+WC1e7L1Ce59Bqttw/4+m1iVy1mOIW11BcgaKtXe5JZBIF8tbuYT1g7SssEd1YhlHCu651ruFTj+VSt4c4pPKTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 5.4% improvement of will-it-scale.per_process_ops on:


commit: ba742531260782a2646bc031f9a12cafebc22594 ("mm, slab: add an optimistic __slab_try_return_freelist()")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 4 sockets Intel(R) Xeon(R) Platinum 8380H CPU @ 2.90GHz (Cooper Lake) with 192G memory
parameters:

	nr_task: 100%
	mode: process
	test: brk2
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+---------------------------------------------------------+
| testcase: change | stress-ng: stress-ng.remap.ops_per_sec 5.1% improvement |
| test parameters  | cpufreq_governor=performance                            |
|                  | nr_threads=100%                                         |
|                  | test=remap                                              |
|                  | testtime=60s                                            |
+------------------+---------------------------------------------------------+




Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260715/202607151031.d368b744-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-cpl-4sp2/brk2/will-it-scale

commit: 
  dc795d4c02 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
  ba74253126 ("mm, slab: add an optimistic __slab_try_return_freelist()")

dc795d4c0282a4fb ba742531260782a2646bc031f9a 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
 1.198e+08            +5.4%  1.263e+08        will-it-scale.224.processes
    534715            +5.4%     563628        will-it-scale.per_process_ops
 1.198e+08            +5.4%  1.263e+08        will-it-scale.workload
     18484 ±  6%     -15.2%      15682 ±  6%  perf-c2c.DRAM.local
    278913           +11.1%     309837 ±  4%  proc-vmstat.nr_slab_unreclaimable
     31.60 ±  4%      +7.0%      33.81        sched_debug.cpu.clock.stddev
     45633            +4.2%      47533        vmstat.system.cs
   1109205           +10.6%    1226921 ±  3%  meminfo.SUnreclaim
   1258106            +9.4%    1375923 ±  3%  meminfo.Slab
      0.53            +0.1        0.60 ±  2%  mpstat.cpu.all.irq%
      2.65            +0.3        2.97        mpstat.cpu.all.usr%
     45777            +4.1%      47661        perf-stat.i.context-switches
    375.48            +1.7%     381.98        perf-stat.i.cpu-migrations
     45659            +4.1%      47537        perf-stat.ps.context-switches
      3470            -1.2%       3428        turbostat.Bzy_MHz
      0.74            +6.8%       0.79        turbostat.IPC
     33.98            +2.2%      34.74        turbostat.RAMWatt
  11512290            -8.5%   10532808 ±  4%  numa-vmstat.node0.nr_free_pages_blocks
     75055 ± 10%     +15.4%      86600 ±  7%  numa-vmstat.node0.nr_slab_unreclaimable
    657940 ± 60%     -95.6%      29042 ± 71%  numa-vmstat.node1.nr_file_pages
  11515036 ±  3%      +5.3%   12125790        numa-vmstat.node1.nr_free_pages
     18033 ± 16%     -93.7%       1133 ±125%  numa-vmstat.node1.nr_mapped
     85663 ± 24%     -65.8%      29284 ± 81%  numa-vmstat.node2.nr_anon_pages
     69.45 ± 63%     -81.7%      12.71 ±192%  numa-vmstat.node2.nr_anon_transparent_hugepages
      2897 ±  5%      -6.5%       2710 ±  4%  numa-vmstat.node2.nr_page_table_pages
     64523 ±  4%     +14.1%      73638 ±  7%  numa-vmstat.node3.nr_slab_unreclaimable
    299421 ± 10%     +15.8%     346807 ± 10%  numa-meminfo.node0.SUnreclaim
    321775 ± 12%     +26.4%     406718 ± 11%  numa-meminfo.node0.Slab
   2631801 ± 60%     -95.6%     116156 ± 71%  numa-meminfo.node1.FilePages
     72229 ± 16%     -93.8%       4477 ±124%  numa-meminfo.node1.Mapped
  46061633 ±  3%      +5.3%   48503087        numa-meminfo.node1.MemFree
   3469470 ± 46%     -70.4%    1028016 ± 11%  numa-meminfo.node1.MemUsed
    142114 ± 63%     -81.7%      26029 ±192%  numa-meminfo.node2.AnonHugePages
    342626 ± 24%     -65.8%     117127 ± 81%  numa-meminfo.node2.AnonPages
    356438 ± 24%     -56.6%     154808 ± 89%  numa-meminfo.node2.AnonPages.max
     11584 ±  5%      -6.4%      10845 ±  4%  numa-meminfo.node2.PageTables
    257072 ±  4%     +14.7%     294883 ±  8%  numa-meminfo.node3.SUnreclaim
      1.25 ± 44%     -71.2%       0.36 ± 67%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__x64_sys_brk
      0.02 ±223%   +2804.8%       0.70 ± 62%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_lock_irqsave
      0.39 ± 23%     +95.1%       0.77 ± 31%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap
      1.09 ± 21%     -21.2%       0.86 ± 22%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap_event
      0.08 ±118%    +396.2%       0.42 ± 96%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unlink_file_vma_batch_final
      1.34 ± 26%     -46.8%       0.71 ± 23%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_complete
      0.60 ± 16%     +24.0%       0.74 ±  6%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      0.01 ±100%   +5094.7%       0.49 ±213%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
      6.68 ± 28%    +154.7%      17.02 ± 48%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.[unknown]
      7.02 ± 43%     -53.0%       3.30 ± 11%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__memcg_slab_free_hook
      3.88 ± 27%     -75.8%       0.94 ± 98%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__x64_sys_brk
      0.02 ±223%   +5491.7%       1.35 ± 67%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_lock_irqsave
      7.06 ± 73%     -68.7%       2.21 ± 55%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.its_return_thunk
      7.69 ± 67%     -51.1%       3.76 ±  8%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_store_gfp
      2.30 ± 30%     +47.5%       3.39 ± 13%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap
      2.23 ± 36%     +51.8%       3.38 ± 16%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_adjust_trans_huge
      2.41 ± 37%    +103.0%       4.89 ± 55%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vms_complete_munmap_vmas
      3.49 ±  8%    +192.8%      10.21 ± 71%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      0.01 ±101%   +9390.2%       0.96 ±218%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
      2534 ±  2%     +20.4%       3050        perf-sched.wait_and_delay.count.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.brk
      1.25 ± 44%     -71.2%       0.36 ± 67%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__x64_sys_brk
      0.02 ±223%   +3229.0%       0.80 ± 79%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_lock_irqsave
      0.44 ± 10%    +813.2%       4.06 ± 68%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      0.39 ± 23%     +95.1%       0.77 ± 31%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap
      1.09 ± 21%     -21.2%       0.86 ± 22%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap_event
      0.08 ±118%    +396.2%       0.42 ± 96%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unlink_file_vma_batch_final
      1.34 ± 26%     -46.8%       0.71 ± 23%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_complete
      0.60 ± 16%     +24.0%       0.74 ±  6%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      0.01 ±100%   +5094.7%       0.49 ±213%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
      2.74 ±  7%     +20.5%       3.30 ± 15%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork
      7.84 ± 35%   +2234.9%     183.10 ±202%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.[unknown]
      7.02 ± 43%     -53.0%       3.30 ± 11%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__memcg_slab_free_hook
      3.88 ± 27%     -75.8%       0.94 ± 98%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__x64_sys_brk
      0.02 ±223%   +5491.7%       1.35 ± 67%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_lock_irqsave
     28.37 ± 79%   +4331.7%       1257 ± 74%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      7.69 ± 67%     -51.1%       3.76 ±  8%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_store_gfp
      2.30 ± 30%     +47.5%       3.39 ± 13%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap
      2.23 ± 36%     +51.8%       3.38 ± 16%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_adjust_trans_huge
      2.41 ± 37%    +103.0%       4.89 ± 55%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vms_complete_munmap_vmas
      3.49 ±  8%    +192.8%      10.21 ± 71%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      0.01 ±101%   +9390.2%       0.96 ±218%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
      9.63 ±  3%      -4.1        5.51 ±  4%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      9.67 ±  3%      -4.1        5.57 ±  4%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__split_vma
     12.55 ±  3%      -3.9        8.66 ±  4%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__split_vma.vms_gather_munmap_vmas
     13.10 ±  3%      -3.9        9.21 ±  4%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_preallocate.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
     14.59 ±  3%      -3.7       10.88 ±  3%  perf-profile.calltrace.cycles-pp.mas_preallocate.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      8.64 ±  5%      -3.1        5.58 ±  3%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
      8.68 ±  4%      -3.0        5.64 ±  3%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap
     67.85            -2.9       64.92        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
     29.69            -2.6       27.08        perf-profile.calltrace.cycles-pp.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
     11.26 ±  5%      -2.5        8.76 ±  3%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
     11.74 ±  4%      -2.5        9.26 ±  3%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
     35.38            -1.9       33.44        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
     21.35 ±  2%      -1.5       19.85        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.41 ±  4%      -1.4        0.98 ±  2%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
      2.54 ±  4%      -1.4        1.13 ± 17%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      7.23            -1.4        5.84        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      2.10 ±  4%      -1.3        0.81 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
      7.36            -1.3        6.08        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      2.01 ±  4%      -1.2        0.77 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
     89.05            -1.2       87.82        perf-profile.calltrace.cycles-pp.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      2.78            -1.2        1.57        perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      2.77            -1.2        1.56 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects
      2.78            -1.2        1.57        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      2.69            -1.2        1.50        perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      2.69            -1.2        1.50        perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node
      2.68            -1.2        1.50 ±  2%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      2.67 ±  2%      -1.2        1.50 ±  2%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
     91.75            -1.1       90.69        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.brk
     91.30            -1.1       90.25        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      1.86 ±  2%      -1.0        0.88 ± 27%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
     97.23            -0.6       96.62        perf-profile.calltrace.cycles-pp.brk
      1.79            -0.3        1.54        perf-profile.calltrace.cycles-pp.__memcg_slab_free_hook.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      2.43            -0.1        2.35        perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      1.02            -0.1        0.97        perf-profile.calltrace.cycles-pp.security_vm_enough_memory_mm.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.27            -0.0        2.23        perf-profile.calltrace.cycles-pp.vm_area_dup.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      1.03            +0.0        1.05        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      0.52            +0.0        0.57        perf-profile.calltrace.cycles-pp.down_write_killable.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      0.78            +0.1        0.84        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_preallocate.commit_merge.vma_expand.vma_merge_new_range
      0.69            +0.1        0.74        perf-profile.calltrace.cycles-pp.__vma_start_exclude_readers.__vma_start_write.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      0.60            +0.1        0.66        perf-profile.calltrace.cycles-pp.__vma_start_exclude_readers.__vma_start_write.vma_expand.vma_merge_new_range.do_brk_flags
      1.34            +0.1        1.40        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region
      0.54            +0.1        0.60        perf-profile.calltrace.cycles-pp.mas_update_gap.mas_store_prealloc.commit_merge.vma_expand.vma_merge_new_range
      0.66            +0.1        0.72        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_preallocate.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      0.90            +0.1        0.98        perf-profile.calltrace.cycles-pp.__vma_start_write.vma_expand.vma_merge_new_range.do_brk_flags.__do_sys_brk
      0.82            +0.1        0.91        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      1.63            +0.1        1.72        perf-profile.calltrace.cycles-pp.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
      1.16            +0.1        1.26        perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      0.86            +0.1        0.96        perf-profile.calltrace.cycles-pp.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      1.52            +0.1        1.62        perf-profile.calltrace.cycles-pp.mas_preallocate.commit_merge.vma_expand.vma_merge_new_range.do_brk_flags
      1.15            +0.1        1.25        perf-profile.calltrace.cycles-pp.__vma_start_write.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      1.27            +0.1        1.37        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.do_brk_flags.__do_sys_brk
      1.66            +0.1        1.78        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      0.95            +0.1        1.07        perf-profile.calltrace.cycles-pp.__get_unmapped_area.check_brk_limits.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.17            +0.1        1.31        perf-profile.calltrace.cycles-pp.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      1.18            +0.2        1.34        perf-profile.calltrace.cycles-pp.check_brk_limits.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      1.25            +0.2        1.40        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      2.04            +0.2        2.20        perf-profile.calltrace.cycles-pp.clear_bhb_loop.brk
      2.53            +0.2        2.71        perf-profile.calltrace.cycles-pp.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.96            +0.2        2.13        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.brk
      1.70            +0.2        1.88        perf-profile.calltrace.cycles-pp.mas_store_prealloc.commit_merge.vma_expand.vma_merge_new_range.do_brk_flags
      2.69            +0.2        2.88        perf-profile.calltrace.cycles-pp.memcpy_orig.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
      2.63            +0.2        2.82        perf-profile.calltrace.cycles-pp.memcpy_orig.mas_wr_node_store.mas_store_prealloc.vma_complete.__split_vma
      1.06            +0.2        1.26        perf-profile.calltrace.cycles-pp.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      2.77            +0.2        2.98        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.do_brk_flags.__do_sys_brk.do_syscall_64
      1.77            +0.2        1.99        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.04            +0.2        3.28        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      2.28 ±  4%      +0.3        2.53 ±  3%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc
      3.48            +0.3        3.76        perf-profile.calltrace.cycles-pp.perf_event_mmap.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.65 ±  3%      +0.3        2.93 ±  2%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.vma_complete
      2.25            +0.3        2.56        perf-profile.calltrace.cycles-pp.mas_find.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      2.22 ±  3%      +0.3        2.52 ±  3%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp
      5.30            +0.3        5.62        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      2.55 ±  2%      +0.3        2.89 ±  2%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      1.04            +0.4        1.39        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core
      1.07            +0.4        1.43        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      1.09            +0.4        1.46        perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      3.08 ±  2%      +0.4        3.45 ±  2%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
      3.24 ±  2%      +0.4        3.64        perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.vma_complete.__split_vma
     10.13            +0.4       10.54        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.99 ±  5%      +0.4        2.40 ±  4%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
      4.57            +0.4        5.01        perf-profile.calltrace.cycles-pp.commit_merge.vma_expand.vma_merge_new_range.do_brk_flags.__do_sys_brk
      2.23 ±  5%      +0.5        2.70 ±  3%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap
      3.95            +0.5        4.43        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
      4.04            +0.5        4.53        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      0.00            +0.5        0.53        perf-profile.calltrace.cycles-pp.mas_find.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      6.03            +0.5        6.58        perf-profile.calltrace.cycles-pp.vma_expand.vma_merge_new_range.do_brk_flags.__do_sys_brk.do_syscall_64
      0.00            +0.5        0.55        perf-profile.calltrace.cycles-pp.can_vma_merge_left.vma_merge_new_range.do_brk_flags.__do_sys_brk.do_syscall_64
      4.10            +0.6        4.65        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      2.22 ±  6%      +0.6        2.84        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
      2.22 ±  6%      +0.6        2.84        perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2.21 ±  6%      +0.6        2.83        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
      2.25 ±  6%      +0.6        2.87        perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      2.25 ±  6%      +0.6        2.87        perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      2.25 ±  6%      +0.6        2.87        perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      2.24 ±  6%      +0.6        2.86        perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2.22 ±  6%      +0.6        2.84        perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
      7.21            +0.7        7.92        perf-profile.calltrace.cycles-pp.vma_merge_new_range.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.72            +0.8        8.50        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      8.06            +0.8        8.90        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.vma_complete.__split_vma.vms_gather_munmap_vmas
      8.97            +0.9        9.90        perf-profile.calltrace.cycles-pp.mas_store_prealloc.vma_complete.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      9.40            +1.0       10.38        perf-profile.calltrace.cycles-pp.vma_complete.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
     14.16            +1.0       15.14        perf-profile.calltrace.cycles-pp.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
     18.44            -7.2       11.26        perf-profile.children.cycles-pp.refill_objects
     18.35            -7.2       11.19        perf-profile.children.cycles-pp.__refill_objects_node
     23.90            -6.4       17.47        perf-profile.children.cycles-pp.__pcs_replace_empty_main
     26.53            -6.2       20.28        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      9.20            -4.8        4.38        perf-profile.children.cycles-pp.__slab_free
     27.75            -4.5       23.30        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     28.48            -4.4       24.08        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     16.15 ±  2%      -3.6       12.54 ±  3%  perf-profile.children.cycles-pp.mas_preallocate
     67.88            -2.9       64.96        perf-profile.children.cycles-pp.do_vmi_align_munmap
     29.88            -2.6       27.32        perf-profile.children.cycles-pp.__split_vma
     35.46            -1.9       33.53        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
     22.68 ±  2%      -1.3       21.35        perf-profile.children.cycles-pp.mas_store_gfp
     89.14            -1.2       87.93        perf-profile.children.cycles-pp.__do_sys_brk
      3.33            -1.1        2.27        perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
     91.91            -1.1       90.84        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     91.51            -1.1       90.46        perf-profile.children.cycles-pp.do_syscall_64
     97.25            -0.6       96.65        perf-profile.children.cycles-pp.brk
      7.98            -0.5        7.43        perf-profile.children.cycles-pp.__irq_exit_rcu
      8.48            -0.5        8.01        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      8.54            -0.5        8.06        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      5.11            -0.5        4.65        perf-profile.children.cycles-pp.__kmem_cache_free_bulk
      5.93            -0.4        5.51        perf-profile.children.cycles-pp.rcu_free_sheaf
      1.83            -0.2        1.58        perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.48            -0.2        0.31        perf-profile.children.cycles-pp.vm_area_init_from
      0.82            -0.2        0.66        perf-profile.children.cycles-pp.mas_prev
      0.38            -0.1        0.28        perf-profile.children.cycles-pp.anon_vma_clone
      2.44            -0.1        2.36        perf-profile.children.cycles-pp.kmem_cache_free
      0.42 ±  2%      -0.1        0.34 ±  3%  perf-profile.children.cycles-pp.__refill_obj_stock
      0.52            -0.1        0.45        perf-profile.children.cycles-pp.mas_prev_setup
      1.13            -0.1        1.07        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.16 ±  2%      -0.1        0.11 ±  3%  perf-profile.children.cycles-pp.trylock_stock
      2.32            -0.0        2.27        perf-profile.children.cycles-pp.vm_area_dup
      0.40 ±  4%      -0.0        0.36 ±  3%  perf-profile.children.cycles-pp.cmd_record
      0.47            -0.0        0.45        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.16 ±  3%      -0.0        0.14        perf-profile.children.cycles-pp.__alloc_empty_sheaf
      0.38            -0.0        0.37        perf-profile.children.cycles-pp.__vm_enough_memory
      0.15 ±  3%      -0.0        0.14        perf-profile.children.cycles-pp.__kmalloc_noprof
      0.17            -0.0        0.16        perf-profile.children.cycles-pp.__x64_sys_brk
      0.11            +0.0        0.12        perf-profile.children.cycles-pp.khugepaged_enter_vma
      0.13            +0.0        0.14        perf-profile.children.cycles-pp.__pi_memcpy
      0.12            +0.0        0.13        perf-profile.children.cycles-pp.__pte_offset_map
      0.13            +0.0        0.14        perf-profile.children.cycles-pp.strlen
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.task_tick_fair
      0.18            +0.0        0.19        perf-profile.children.cycles-pp.unlink_anon_vmas
      0.08            +0.0        0.09        perf-profile.children.cycles-pp.unlink_file_vma_batch_add
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.unlink_file_vma_batch_init
      0.07 ±  5%      +0.0        0.08        perf-profile.children.cycles-pp.testcase
      0.09 ±  4%      +0.0        0.10        perf-profile.children.cycles-pp.remove_vma
      0.10 ±  4%      +0.0        0.12 ±  3%  perf-profile.children.cycles-pp.sched_tick
      0.32            +0.0        0.34        perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.42            +0.0        0.43        perf-profile.children.cycles-pp.static_key_count
      0.29            +0.0        0.31        perf-profile.children.cycles-pp.may_expand_vm
      0.06 ±  7%      +0.0        0.08 ±  4%  perf-profile.children.cycles-pp.barn_put_empty_sheaf
      0.13            +0.0        0.15 ±  2%  perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
      0.31            +0.0        0.33        perf-profile.children.cycles-pp.prandom_u32_state
      0.15 ±  2%      +0.0        0.17        perf-profile.children.cycles-pp.security_mmap_addr
      0.19            +0.0        0.21        perf-profile.children.cycles-pp.free_pgd_range
      0.28            +0.0        0.30        perf-profile.children.cycles-pp.vm_area_free
      0.23            +0.0        0.25        perf-profile.children.cycles-pp.strnlen
      0.36            +0.0        0.38        perf-profile.children.cycles-pp.kfree
      0.26            +0.0        0.28        perf-profile.children.cycles-pp.up_write
      0.23            +0.0        0.25        perf-profile.children.cycles-pp.userfaultfd_unmap_complete
      0.08 ±  4%      +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.tmigr_requires_handle_remote
      0.48            +0.0        0.50        perf-profile.children.cycles-pp.x64_sys_call
      0.24            +0.0        0.26        perf-profile.children.cycles-pp.mas_wr_slot_store
      0.08 ±  6%      +0.0        0.10        perf-profile.children.cycles-pp.get_jiffies_update
      0.30            +0.0        0.32        perf-profile.children.cycles-pp.vma_prepare
      0.06            +0.0        0.09        perf-profile.children.cycles-pp.brk@plt
      0.40            +0.0        0.43        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.38            +0.0        0.41        perf-profile.children.cycles-pp.downgrade_write
      0.34            +0.0        0.37        perf-profile.children.cycles-pp.sized_strscpy
      0.17 ±  2%      +0.0        0.20        perf-profile.children.cycles-pp.mm_get_unmapped_area_vmflags
      1.17            +0.0        1.21        perf-profile.children.cycles-pp.free_pgtables
      0.57            +0.0        0.61        perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.42            +0.0        0.46        perf-profile.children.cycles-pp.tlb_gather_mmu
      0.53            +0.0        0.57        perf-profile.children.cycles-pp.down_write_killable
      0.36 ±  5%      +0.0        0.40 ±  6%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.07 ±  5%      +0.0        0.12 ±  3%  perf-profile.children.cycles-pp.is_vmalloc_addr
      0.24            +0.0        0.29        perf-profile.children.cycles-pp.update_process_times
      0.45            +0.0        0.50        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      0.33            +0.0        0.38        perf-profile.children.cycles-pp.vma_adjust_trans_huge
      0.27            +0.1        0.32 ±  2%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.29            +0.1        0.35        perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.76            +0.1        0.82        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.36            +0.1        0.42        perf-profile.children.cycles-pp.mas_prev_range
      1.38            +0.1        1.44        perf-profile.children.cycles-pp.zap_pte_range
      0.50            +0.1        0.57 ±  4%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.50            +0.1        0.57 ±  4%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.35 ±  4%      +0.1        0.43        perf-profile.children.cycles-pp.__account_obj_stock
      0.42            +0.1        0.50        perf-profile.children.cycles-pp.mas_wr_store_entry
      0.48            +0.1        0.56        perf-profile.children.cycles-pp.can_vma_merge_left
      0.87            +0.1        0.96        perf-profile.children.cycles-pp.mas_wr_walk_descend
      1.66            +0.1        1.75        perf-profile.children.cycles-pp.zap_pmd_range
      1.18            +0.1        1.27        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.79            +0.1        0.89        perf-profile.children.cycles-pp.init_multi_vma_prep
      1.30            +0.1        1.40        perf-profile.children.cycles-pp.perf_iterate_sb
      1.31            +0.1        1.42        perf-profile.children.cycles-pp.__vma_start_exclude_readers
      1.44            +0.1        1.57        perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.01            +0.1        1.14        perf-profile.children.cycles-pp.__get_unmapped_area
      1.19            +0.2        1.34        perf-profile.children.cycles-pp.check_brk_limits
      2.06            +0.2        2.22        perf-profile.children.cycles-pp.clear_bhb_loop
      1.50            +0.2        1.66        perf-profile.children.cycles-pp.mas_next_slot
      2.55            +0.2        2.73        perf-profile.children.cycles-pp.__zap_vma_range
      1.40            +0.2        1.58        perf-profile.children.cycles-pp.mas_update_gap
      2.07            +0.2        2.25        perf-profile.children.cycles-pp.__vma_start_write
      1.46            +0.2        1.67        perf-profile.children.cycles-pp.mas_prev_slot
      2.91            +0.2        3.13        perf-profile.children.cycles-pp.perf_event_mmap_event
      2.40            +0.2        2.63        perf-profile.children.cycles-pp.mas_wr_store_type
      3.05            +0.2        3.29        perf-profile.children.cycles-pp.unmap_vmas
      1.96            +0.2        2.20        perf-profile.children.cycles-pp.mas_walk
      3.49            +0.3        3.78        perf-profile.children.cycles-pp.perf_event_mmap
      5.34            +0.3        5.66        perf-profile.children.cycles-pp.unmap_region
      5.35            +0.4        5.74        perf-profile.children.cycles-pp.memcpy_orig
     10.25            +0.4       10.66        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      4.67            +0.4        5.11        perf-profile.children.cycles-pp.commit_merge
      3.93            +0.5        4.39        perf-profile.children.cycles-pp.barn_put_full_sheaf
      6.04            +0.5        6.59        perf-profile.children.cycles-pp.vma_expand
      4.74            +0.6        5.32        perf-profile.children.cycles-pp.mas_find
      2.22 ±  6%      +0.6        2.84        perf-profile.children.cycles-pp.run_ksoftirqd
      2.25 ±  6%      +0.6        2.87        perf-profile.children.cycles-pp.kthread
      2.25 ±  6%      +0.6        2.87        perf-profile.children.cycles-pp.ret_from_fork
      2.25 ±  6%      +0.6        2.87        perf-profile.children.cycles-pp.ret_from_fork_asm
      2.24 ±  6%      +0.6        2.86        perf-profile.children.cycles-pp.smpboot_thread_fn
      5.21            +0.6        5.84        perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      5.14            +0.6        5.80        perf-profile.children.cycles-pp.barn_get_empty_sheaf
      4.71            +0.7        5.36        perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      7.25            +0.7        7.96        perf-profile.children.cycles-pp.vma_merge_new_range
      6.35            +0.8        7.13        perf-profile.children.cycles-pp.kvfree_call_rcu
     14.22            +1.0       15.21        perf-profile.children.cycles-pp.do_brk_flags
      9.62            +1.0       10.62        perf-profile.children.cycles-pp.vma_complete
     10.68            +1.1       11.81        perf-profile.children.cycles-pp.mas_store_prealloc
     15.88            +1.6       17.50        perf-profile.children.cycles-pp.mas_wr_node_store
     27.75            -4.5       23.30        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      3.54            -0.3        3.28        perf-profile.self.cycles-pp.__refill_objects_node
      0.42 ±  2%      -0.2        0.26 ±  2%  perf-profile.self.cycles-pp.vm_area_init_from
      0.90            -0.1        0.76        perf-profile.self.cycles-pp.__slab_free
      0.31            -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.anon_vma_clone
      0.94 ±  2%      -0.1        0.84        perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.34 ±  2%      -0.1        0.26 ±  2%  perf-profile.self.cycles-pp.__refill_obj_stock
      0.46            -0.1        0.38        perf-profile.self.cycles-pp.mas_prev_setup
      0.53            -0.1        0.46        perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.40            -0.1        0.34        perf-profile.self.cycles-pp.mas_prev
      0.14 ±  2%      -0.0        0.09        perf-profile.self.cycles-pp.trylock_stock
      0.21            -0.0        0.18        perf-profile.self.cycles-pp.__vm_enough_memory
      0.42            -0.0        0.39        perf-profile.self.cycles-pp.tlb_finish_mmu
      0.25            -0.0        0.23        perf-profile.self.cycles-pp.pte_offset_map_lock
      1.12            -0.0        1.10        perf-profile.self.cycles-pp.its_return_thunk
      0.48            -0.0        0.46        perf-profile.self.cycles-pp.free_pgtables
      0.09            -0.0        0.08 ±  4%  perf-profile.self.cycles-pp.cap_vm_enough_memory
      0.11            +0.0        0.12        perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
      0.26            +0.0        0.27        perf-profile.self.cycles-pp.may_expand_vm
      0.06            +0.0        0.07        perf-profile.self.cycles-pp.remove_vma
      0.08            +0.0        0.09        perf-profile.self.cycles-pp.security_mmap_addr
      0.06            +0.0        0.07        perf-profile.self.cycles-pp.testcase
      0.16            +0.0        0.17        perf-profile.self.cycles-pp.unlink_anon_vmas
      0.21            +0.0        0.22        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.28            +0.0        0.29        perf-profile.self.cycles-pp.kfree
      0.21            +0.0        0.22        perf-profile.self.cycles-pp.strnlen
      0.10 ±  4%      +0.0        0.11        perf-profile.self.cycles-pp.vm_area_free
      0.17 ±  2%      +0.0        0.18 ±  2%  perf-profile.self.cycles-pp.free_pgd_range
      0.27            +0.0        0.29        perf-profile.self.cycles-pp.prandom_u32_state
      0.41            +0.0        0.42        perf-profile.self.cycles-pp.x64_sys_call
      0.29            +0.0        0.30        perf-profile.self.cycles-pp.static_key_count
      0.29            +0.0        0.31        perf-profile.self.cycles-pp.__kmem_cache_free_bulk
      0.10 ±  4%      +0.0        0.12        perf-profile.self.cycles-pp.__pte_offset_map
      0.23            +0.0        0.25        perf-profile.self.cycles-pp.barn_get_empty_sheaf
      0.17            +0.0        0.19        perf-profile.self.cycles-pp.check_brk_limits
      0.22            +0.0        0.24        perf-profile.self.cycles-pp.rcu_free_sheaf
      0.22            +0.0        0.24        perf-profile.self.cycles-pp.vma_prepare
      0.26            +0.0        0.28        perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      0.24            +0.0        0.26        perf-profile.self.cycles-pp.up_write
      0.21            +0.0        0.23        perf-profile.self.cycles-pp.mas_wr_slot_store
      0.72            +0.0        0.74        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.19 ±  2%      +0.0        0.21        perf-profile.self.cycles-pp.userfaultfd_unmap_complete
      0.12 ±  4%      +0.0        0.15        perf-profile.self.cycles-pp.mm_get_unmapped_area_vmflags
      0.08 ±  6%      +0.0        0.10        perf-profile.self.cycles-pp.get_jiffies_update
      0.42            +0.0        0.44        perf-profile.self.cycles-pp.vma_expand
      0.27 ±  2%      +0.0        0.30        perf-profile.self.cycles-pp.zap_pmd_range
      0.22            +0.0        0.25        perf-profile.self.cycles-pp.mas_prev_range
      0.28            +0.0        0.31        perf-profile.self.cycles-pp.sized_strscpy
      0.06            +0.0        0.09 ±  4%  perf-profile.self.cycles-pp.is_vmalloc_addr
      0.20            +0.0        0.23        perf-profile.self.cycles-pp.unmap_region
      0.36            +0.0        0.38        perf-profile.self.cycles-pp.downgrade_write
      0.39            +0.0        0.42        perf-profile.self.cycles-pp.tlb_gather_mmu
      0.57            +0.0        0.61        perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.89            +0.0        0.93        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.27            +0.0        0.31        perf-profile.self.cycles-pp.__get_unmapped_area
      0.29            +0.0        0.33        perf-profile.self.cycles-pp.vma_adjust_trans_huge
      0.31            +0.0        0.35        perf-profile.self.cycles-pp.unmap_vmas
      0.48            +0.0        0.52        perf-profile.self.cycles-pp.down_write_killable
      0.41            +0.0        0.46        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.61            +0.0        0.65        perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      1.51            +0.0        1.55        perf-profile.self.cycles-pp.do_brk_flags
      0.47            +0.0        0.52        perf-profile.self.cycles-pp.commit_merge
      0.87 ±  2%      +0.1        0.92        perf-profile.self.cycles-pp.perf_iterate_sb
      0.53            +0.1        0.58        perf-profile.self.cycles-pp.zap_pte_range
      0.32 ±  3%      +0.1        0.37        perf-profile.self.cycles-pp.__account_obj_stock
      0.01 ±223%      +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.brk@plt
      0.73            +0.1        0.78        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.52            +0.1        0.58        perf-profile.self.cycles-pp.perf_event_mmap
      0.58            +0.1        0.64        perf-profile.self.cycles-pp.vma_complete
      0.61 ±  3%      +0.1        0.66 ±  2%  perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.72            +0.1        0.78        perf-profile.self.cycles-pp.perf_event_mmap_event
      0.33            +0.1        0.39        perf-profile.self.cycles-pp.mas_wr_store_entry
      0.58            +0.1        0.64        perf-profile.self.cycles-pp.vma_merge_new_range
      0.73            +0.1        0.79        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.67            +0.1        0.74        perf-profile.self.cycles-pp.__vma_start_write
      0.91            +0.1        0.98        perf-profile.self.cycles-pp.do_syscall_64
      0.71            +0.1        0.78        perf-profile.self.cycles-pp.init_multi_vma_prep
      1.32            +0.1        1.39        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.77            +0.1        0.85        perf-profile.self.cycles-pp.mas_wr_walk_descend
      0.83            +0.1        0.91        perf-profile.self.cycles-pp.__zap_vma_range
      0.70            +0.1        0.78        perf-profile.self.cycles-pp.do_vmi_align_munmap
      1.09            +0.1        1.17        perf-profile.self.cycles-pp.__vma_start_exclude_readers
      0.32            +0.1        0.40        perf-profile.self.cycles-pp.can_vma_merge_left
      0.77            +0.1        0.86 ±  2%  perf-profile.self.cycles-pp.__split_vma
      0.96            +0.1        1.05        perf-profile.self.cycles-pp.kvfree_call_rcu
      1.43            +0.1        1.54        perf-profile.self.cycles-pp.mas_wr_store_type
      1.09            +0.1        1.22        perf-profile.self.cycles-pp.brk
      1.31            +0.1        1.45        perf-profile.self.cycles-pp.mas_next_slot
      1.09            +0.1        1.24        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      1.44            +0.1        1.59        perf-profile.self.cycles-pp.mas_preallocate
      0.56            +0.2        0.72 ±  2%  perf-profile.self.cycles-pp.kmem_cache_free
      1.30            +0.2        1.46        perf-profile.self.cycles-pp.mas_update_gap
      1.54            +0.2        1.70        perf-profile.self.cycles-pp.mas_store_prealloc
      2.04            +0.2        2.20        perf-profile.self.cycles-pp.clear_bhb_loop
      1.21            +0.2        1.38        perf-profile.self.cycles-pp.mas_find
      1.53            +0.2        1.71        perf-profile.self.cycles-pp.__do_sys_brk
      1.36            +0.2        1.55        perf-profile.self.cycles-pp.mas_prev_slot
      1.75            +0.2        1.94        perf-profile.self.cycles-pp.mas_walk
      1.77            +0.2        1.98        perf-profile.self.cycles-pp.mas_store_gfp
      2.97            +0.3        3.26        perf-profile.self.cycles-pp.mas_wr_node_store
      4.93            +0.3        5.27        perf-profile.self.cycles-pp.memcpy_orig


***************************************************************************************************

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp4/remap/stress-ng/60s

commit: 
  dc795d4c02 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
  ba74253126 ("mm, slab: add an optimistic __slab_try_return_freelist()")

dc795d4c0282a4fb ba742531260782a2646bc031f9a 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      4769            -5.0%       4532        stress-ng.remap.nanosecs_per_page_remap
   1557707            +5.1%    1637875        stress-ng.remap.ops
     25986            +5.1%      27323        stress-ng.remap.ops_per_sec
    782017            +7.4%     840008        stress-ng.time.involuntary_context_switches
  3.19e+09            +5.1%  3.355e+09        stress-ng.time.minor_page_faults
     12173            -1.2%      12022        stress-ng.time.system_time
    321.17            +7.2%     344.17        stress-ng.time.user_time
      0.26 ±  4%      +0.1        0.32 ±  3%  mpstat.cpu.all.irq%
      1680 ± 11%     -54.2%     769.67 ± 71%  perf-c2c.HITM.local
     25621            +7.6%      27562        vmstat.system.cs
   1515394 ±  3%     +53.9%    2332899 ± 27%  numa-numastat.node0.local_node
   1584097 ±  4%     +57.0%    2486490 ± 24%  numa-numastat.node0.numa_hit
     26439            +7.5%      28414        perf-stat.i.context-switches
     25974            +7.5%      27924        perf-stat.ps.context-switches
      0.72 ± 44%     +26.6%       0.90        turbostat.IPC
   5033775 ± 44%  +1.7e+06     6779481 ±  2%  turbostat.PKG_%
      4.79 ± 44%     +24.0%       5.94 ±  2%  turbostat.RAMWatt
     25286 ± 14%     -29.0%      17944 ± 21%  numa-vmstat.node0.nr_slab_reclaimable
   1584764 ±  4%     +56.9%    2486572 ± 24%  numa-vmstat.node0.numa_hit
   1516061 ±  3%     +53.9%    2332981 ± 27%  numa-vmstat.node0.numa_local
     15247 ± 25%     +50.0%      22878 ± 17%  numa-vmstat.node1.nr_slab_reclaimable
     86510 ± 16%     +16.8%     101025 ± 14%  numa-vmstat.node1.nr_slab_unreclaimable
    101142 ± 14%     -29.0%      71781 ± 21%  numa-meminfo.node0.KReclaimable
    101142 ± 14%     -29.0%      71781 ± 21%  numa-meminfo.node0.SReclaimable
     60972 ± 25%     +50.1%      91508 ± 17%  numa-meminfo.node1.KReclaimable
     60972 ± 25%     +50.1%      91508 ± 17%  numa-meminfo.node1.SReclaimable
    346291 ± 16%     +16.6%     403904 ± 14%  numa-meminfo.node1.SUnreclaim
    407263 ± 15%     +21.6%     495412 ± 13%  numa-meminfo.node1.Slab
    193204            +3.9%     200723        proc-vmstat.nr_slab_unreclaimable
   3856212 ±  5%     +36.5%    5264019 ± 13%  proc-vmstat.numa_hit
   3592670 ±  6%     +39.2%    5000320 ± 14%  proc-vmstat.numa_local
    888.33 ± 24%     -37.7%     553.00 ± 17%  proc-vmstat.numa_pages_migrated
  10565763 ±  4%     +41.1%   14905584 ±  5%  proc-vmstat.pgalloc_normal
 3.191e+09            +5.1%  3.355e+09        proc-vmstat.pgfault
   9781837 ±  4%     +40.4%   13736213 ±  2%  proc-vmstat.pgfree
    888.33 ± 24%     -37.7%     553.00 ± 17%  proc-vmstat.pgmigrate_success
      0.13 ±101%    +276.9%       0.48 ± 33%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.23 ±100%    +151.6%       0.58 ±  2%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.remap_file_pages
      0.27 ±100%    +158.1%       0.70 ±  6%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.[unknown].clock_gettime
      0.28 ±100%    +188.6%       0.80 ±  6%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.check_order.[unknown]
      0.28 ±100%    +145.3%       0.68 ±  4%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.remap_file_pages
      0.26 ±100%    +148.7%       0.64 ±  5%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.remap_order
      0.27 ±100%    +153.0%       0.68 ±  8%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_time_now
      0.28 ±100%    +130.4%       0.64 ± 11%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_time_now_timespec
      0.21 ±151%    +255.5%       0.76 ± 43%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_call_function_single.[unknown].clock_gettime
      0.43 ±101%    +138.1%       1.03 ± 12%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__build_id_parse
      0.25 ±109%    +258.8%       0.90 ± 25%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__filemap_get_folio_mpol
      0.40 ±102%    +141.7%       0.98 ± 14%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__get_unmapped_area
      0.41 ±102%    +149.6%       1.02 ± 13%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__get_user_pages
      0.43 ±100%    +138.8%       1.03 ±  8%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__handle_mm_fault
      0.25 ±144%    +301.5%       0.99 ± 26%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__kfree_rcu_sheaf
      0.35 ±105%    +184.9%       1.00 ± 15%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__kmalloc_cache_noprof
      0.41 ±100%    +163.0%       1.08 ±  4%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__memcg_slab_free_hook
      0.41 ±100%    +155.6%       1.06 ± 12%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__memcg_slab_post_alloc_hook
      0.48 ±102%    +128.0%       1.09 ± 18%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__mm_populate
      0.44 ±101%    +151.5%       1.11 ± 10%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__mmap_new_vma
      0.41 ±100%    +153.0%       1.04 ±  8%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__mmap_region
      0.46 ±102%    +137.2%       1.08 ±  7%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__pi_memcpy
      0.45 ±100%    +146.1%       1.11 ±  9%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__rb_erase_color
      0.43 ±100%    +134.8%       1.00 ± 12%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__rb_insert_augmented
      0.43 ±100%    +150.2%       1.09 ±  8%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__refill_objects_node
      0.45 ±100%    +130.5%       1.03 ± 12%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__thp_vma_allowable_orders
      0.42 ±100%    +140.7%       1.00 ±  5%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__vma_start_exclude_readers
      0.45 ±101%    +158.4%       1.16 ±  7%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__vma_start_write
      0.39 ±100%    +161.5%       1.02        perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      0.11 ±223%    +729.7%       0.91 ± 43%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.anon_vma_clone
      0.44 ±100%    +162.3%       1.15 ±  8%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.arch_get_unmapped_area_topdown
      0.41 ±103%    +173.9%       1.11 ± 15%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.atime_needs_update
      0.41 ±102%    +157.0%       1.05 ± 10%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.can_vma_merge_right
      0.29 ±136%    +281.4%       1.09 ± 23%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.commit_merge
      0.38 ±101%    +167.2%       1.02 ± 10%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.copy_from_kernel_nofault
      0.41 ±104%    +195.0%       1.22 ± 15%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.cp_data_write
      0.46 ±100%    +153.6%       1.17 ± 12%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.d_path
      0.41 ±100%    +158.9%       1.06 ± 12%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_mmap
      0.42 ±100%    +146.7%       1.05 ± 10%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_syscall_64
      0.35 ±141%    +132.8%       0.80 ± 55%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.down_write
      0.46 ±100%    +118.5%       1.01 ±  8%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.folios_put_refs
      0.33 ±100%    +218.1%       1.05 ± 17%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.follow_page_pte
      0.42 ±101%    +176.1%       1.15 ± 17%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.follow_pmd_mask
      0.26 ±103%    +298.7%       1.03 ±  9%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.follow_pud_mask
      0.43 ±100%    +156.4%       1.09 ± 12%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.freader_fetch
      0.43 ±102%    +151.9%       1.07 ±  6%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.freader_init_from_file
      0.46 ±100%    +166.8%       1.21 ± 13%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.free_pgtables
      0.23 ±145%    +336.5%       1.01 ± 21%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.free_swap_cache
      0.40 ±101%    +147.6%       0.98 ± 14%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.handle_mm_fault
      0.31 ±130%    +309.9%       1.27 ±  8%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.handle_pte_fault
      0.35 ±111%    +236.3%       1.18 ± 26%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ima_file_mmap
      0.26 ±119%    +351.4%       1.15 ± 20%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.init_multi_vma_prep
      0.30 ±124%    +262.3%       1.08 ± 13%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.is_mergeable_anon_vma
      0.42 ±100%    +150.0%       1.06 ± 12%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kfree
      0.37 ±111%    +209.1%       1.13 ± 26%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.khugepaged_enter_vma
      0.41 ±104%    +165.8%       1.08 ± 19%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ksm_vma_flags
      0.42 ±100%    +161.8%       1.11 ±  9%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kvfree_call_rcu
      0.43 ±101%    +160.3%       1.11 ± 10%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_find
      0.39 ±104%    +192.8%       1.14 ±  8%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_next_slot
      0.42 ±100%    +159.8%       1.08 ±  7%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_preallocate
      0.41 ±100%    +156.0%       1.05 ± 12%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_prev_slot
      0.43 ±100%    +148.1%       1.08 ±  8%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_store_prealloc
      0.43 ±100%    +148.4%       1.06 ±  7%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_topiary_replace
      0.43 ±100%    +138.4%       1.02 ±  6%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_walk
      0.41 ±102%    +161.1%       1.06 ±  5%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_node_store
      0.40 ±103%    +183.3%       1.15 ±  7%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_split
      0.41 ±100%    +149.1%       1.03 ± 15%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_store_type
      0.41 ±100%    +175.6%       1.14 ± 11%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.may_expand_vm
      0.40 ±100%    +171.6%       1.08 ±  8%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mmap_region
      0.44 ±102%    +130.6%       1.02 ± 15%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mt_find
      0.42 ±101%    +139.1%       1.00 ± 11%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mtree_load
      0.28 ±118%    +361.0%       1.30 ± 37%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.multi_src_setup
      0.47 ±100%    +138.3%       1.12 ± 11%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.node_copy
      0.42 ±100%    +191.8%       1.22 ± 14%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.node_finalise
      0.19 ±107%    +410.6%       0.97 ± 31%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.percpu_counter_add_batch
      0.47 ±101%    +143.8%       1.15 ± 18%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap
      0.39 ±100%    +180.9%       1.09 ±  9%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap_event
      0.19 ±152%    +580.2%       1.28 ± 29%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.pte_offset_map_rw_nolock
      0.30 ±110%    +274.8%       1.13 ± 25%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.rb_next
      0.36 ±108%    +258.1%       1.30 ± 15%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.security_mmap_addr
      0.30 ±103%    +272.1%       1.11 ± 49%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.security_mmap_file
      0.43 ±101%    +161.5%       1.11 ± 14%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.tlb_finish_mmu
      0.40 ±103%    +217.3%       1.28 ± 25%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.tlb_flush_mmu
      0.39 ±105%    +166.5%       1.05 ± 18%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.tlb_gather_mmu
      0.39 ±100%    +165.9%       1.03 ±  9%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unlink_file_vma_batch_process
      0.40 ±108%    +179.3%       1.10 ± 19%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unmap_vmas
      0.25 ±221%    +469.8%       1.40 ± 21%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.up_read
      0.26 ±123%    +284.0%       1.02 ± 35%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.up_write
      0.14 ±164%    +660.8%       1.06 ± 66%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vm_area_free
      0.43 ±101%    +146.6%       1.06 ± 15%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vm_get_page_prot
      0.24 ±115%    +324.9%       1.03 ± 30%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_expand
      0.43 ±100%    +143.2%       1.06 ±  7%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_interval_tree_insert
      0.44 ±100%    +142.6%       1.07 ±  4%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_interval_tree_remove
      0.43 ±102%    +141.9%       1.05 ±  7%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_merge_new_range
      0.34 ±101%    +204.8%       1.03 ± 19%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_prepare
      0.47 ±100%    +151.1%       1.17 ± 16%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_set_page_prot
      0.42 ±100%    +146.5%       1.04 ±  5%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vms_gather_munmap_vmas
      0.32 ±111%    +256.6%       1.13 ± 19%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.x64_sys_call
      0.27 ±100%    +265.0%       1.00 ±  9%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.zap_pmd_range
      0.36 ±100%    +175.3%       1.00 ± 21%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.zap_pte_range
      0.44 ±101%    +161.3%       1.16 ± 10%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__kfree_rcu_sheaf.kvfree_call_rcu.mas_topiary_replace
      0.46 ±100%    +140.0%       1.11 ±  7%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      0.42 ±101%    +141.2%       1.02 ± 17%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__memcg_slab_free_hook.kmem_cache_free.vms_complete_munmap_vmas
      0.31 ±128%    +257.4%       1.11 ± 45%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_dup
      0.08 ±100%    +218.6%       0.27 ± 16%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.44 ±100%    +142.8%       1.08 ±  3%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.do_read_fault.do_fault.__handle_mm_fault
      0.42 ±101%    +142.7%       1.02 ± 17%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_read_killable.__do_sys_remap_file_pages.do_syscall_64
      0.44 ±101%    +140.1%       1.06 ± 17%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_write.__mmap_new_vma.__mmap_region
      0.33 ±117%    +274.2%       1.22 ± 27%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_write.vma_prepare.commit_merge
      0.46 ±105%    +162.6%       1.21 ± 10%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_write_killable.__do_sys_remap_file_pages.do_syscall_64
      0.43 ±101%    +152.2%       1.09 ±  5%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.filemap_get_entry.__filemap_get_folio_mpol.freader_get_folio
      0.45 ±100%    +129.1%       1.03 ±  7%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.follow_page_pte.follow_page_mask.__get_user_pages
      0.43 ±102%    +170.0%       1.16 ± 14%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.kfree.perf_event_mmap_event.perf_event_mmap
      0.37 ±106%    +220.5%       1.18 ± 29%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.kmem_cache_alloc_noprof.mas_preallocate.commit_merge
      0.41 ±102%    +153.6%       1.03 ± 13%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.kmem_cache_free.vms_complete_munmap_vmas.__mmap_complete
      0.40 ±101%    +172.7%       1.10 ±  5%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.lru_add_drain.populate_vma_page_range.__mm_populate
      0.39 ±100%    +169.3%       1.06 ±  5%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.mt_find.find_vma.gup_vma_lookup
      0.43 ±100%    +147.3%       1.07 ±  7%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.mt_find.find_vma_intersection.__mm_populate
      0.43 ±100%    +145.4%       1.05 ±  6%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.mtree_load.__do_sys_remap_file_pages.do_syscall_64
      0.42 ±100%    +146.9%       1.04 ±  5%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.perf_iterate_sb.constprop.0
      1.34 ±204%    +973.9%      14.40 ±129%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.rmqueue.isra.0
      0.11 ±102%    +255.9%       0.40 ± 12%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.smpboot_thread_fn.kthread.ret_from_fork
      0.44 ±100%    +122.9%       0.98 ±  8%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.up_write.__do_sys_remap_file_pages.do_syscall_64
      0.39 ±101%    +209.4%       1.19 ±  7%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.up_write.vma_complete.commit_merge
      0.44 ±100%    +141.4%       1.07 ±  3%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.zap_pte_range.zap_pmd_range.isra
      0.02 ±100%    +243.5%       0.07 ± 18%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.36 ±102%    +158.4%       0.94 ± 21%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork
      0.24 ±100%    +166.6%       0.64 ±  3%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.17 ±100%    +139.0%       0.41 ±  6%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      8.26 ±111%    +183.5%      23.40 ± 32%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      1.76 ±101%    +278.7%       6.68 ± 26%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.53 ±102%    +167.5%       4.09 ±  9%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.check_order.[unknown]
      0.98 ±107%    +235.1%       3.29 ± 11%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.clock_gettime@plt
      1.69 ±100%    +178.3%       4.71 ± 24%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.remap_file_pages
      0.43 ±130%    +276.2%       1.61 ± 49%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.remap_file_pages@plt
      1.54 ±101%    +124.4%       3.44 ±  9%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.remap_order
      1.63 ±102%    +144.5%       4.00 ± 17%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_time_now
      1.58 ±102%    +137.9%       3.76 ±  7%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_time_now_timespec
      0.44 ±118%    +322.9%       1.84 ± 34%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_call_function_single.[unknown].clock_gettime
      1.30 ±101%    +180.7%       3.66 ± 24%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__build_id_parse
      1.33 ±101%    +163.1%       3.49 ± 17%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__do_sys_remap_file_pages
      0.80 ±103%    +207.3%       2.47 ± 22%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__filemap_get_folio_mpol
      1.02 ±103%    +167.8%       2.72 ± 19%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__get_unmapped_area
      1.39 ±100%    +134.1%       3.26 ± 12%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__get_user_pages
      1.46 ±100%    +148.3%       3.64 ±  6%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__handle_mm_fault
      0.34 ±144%    +326.0%       1.44 ± 34%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__kfree_rcu_sheaf
      0.53 ±114%    +220.3%       1.69 ± 27%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__kmem_cache_free_bulk
      1.61 ±100%    +194.0%       4.72 ± 31%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__memcg_slab_free_hook
      1.10 ±100%    +203.7%       3.34 ±  9%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__memcg_slab_post_alloc_hook
      1.54 ±101%    +131.6%       3.56 ± 10%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__mmap_new_vma
      1.85 ±101%    +160.7%       4.83 ± 28%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__mmap_region
      1.37 ±102%    +149.3%       3.42 ± 12%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__pi_memcpy
      1.61 ±100%    +115.3%       3.47 ±  4%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__rb_erase_color
      0.95 ±114%    +203.3%       2.87 ± 14%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__split_vma
      1.29 ±100%    +145.8%       3.18 ± 11%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__thp_vma_allowable_orders
      1.44 ±101%    +126.6%       3.27 ± 10%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__vma_start_exclude_readers
      1.64 ±100%    +199.4%       4.92 ± 39%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__vma_start_write
      0.14 ±223%   +1149.9%       1.80 ± 55%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.anon_vma_clone
      1.47 ±101%    +156.1%       3.76 ± 12%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.arch_get_unmapped_area_topdown
      1.06 ±102%    +190.1%       3.08 ± 26%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.can_vma_merge_left
      1.42 ±106%    +157.7%       3.65 ± 20%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.can_vma_merge_right
      1.05 ±105%    +196.3%       3.11 ± 12%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.check_vma_flags
      0.57 ±108%    +319.9%       2.40 ± 34%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.commit_merge
      1.24 ±100%    +145.0%       3.04 ± 12%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.copy_from_kernel_nofault
      1.38 ±103%    +157.4%       3.56 ± 19%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.cp_data_write
      0.89 ±103%    +211.6%       2.78 ± 21%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.current_time
      0.94 ±102%    +226.2%       3.06 ± 14%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.d_path
      1.04 ±104%    +142.6%       2.52 ± 11%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_fault
      1.50 ±101%    +148.3%       3.74 ± 11%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_mmap
      1.72 ±100%    +117.0%       3.73 ±  7%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_syscall_64
      0.17 ±223%    +572.2%       1.16 ± 52%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.down_read
      0.47 ±150%    +210.0%       1.45 ± 58%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.down_write
      0.93 ±103%    +177.1%       2.58 ± 16%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.follow_page_pte
      0.81 ±105%    +288.9%       3.14 ± 16%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.follow_pud_mask
      1.08 ±102%    +182.9%       3.05 ± 15%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.freader_fetch
      1.29 ±103%    +165.3%       3.43 ±  9%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.freader_init_from_file
      0.77 ±103%    +191.6%       2.25 ± 16%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.free_pgd_range
      0.56 ±144%    +261.3%       2.02 ± 20%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.free_swap_cache
      0.72 ±133%    +304.4%       2.93 ± 25%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.handle_pte_fault
      0.63 ±119%    +332.7%       2.71 ± 25%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ima_file_mmap
      0.75 ±110%    +266.3%       2.75 ± 25%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.init_multi_vma_prep
      0.71 ±115%    +313.0%       2.93 ± 25%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.is_mergeable_anon_vma
      0.53 ±122%    +411.1%       2.72 ± 28%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.is_vmalloc_addr
      1.21 ±102%    +167.9%       3.25 ±  8%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kfree
      0.89 ±114%    +190.0%       2.59 ± 35%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.khugepaged_enter_vma
      1.42 ±102%    +138.1%       3.38 ± 10%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kmem_cache_free
      1.09 ±103%    +152.6%       2.76 ± 11%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ktime_get_coarse_real_ts64_mg
      1.48 ±100%    +145.4%       3.63 ± 22%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kvfree_call_rcu
      1.36 ±101%    +172.5%       3.71 ± 27%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_find
      1.27 ±100%    +227.0%       4.15 ± 46%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_next_slot
      1.17 ±100%    +190.9%       3.39 ± 20%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_prev_slot
      1.21 ±102%    +173.9%       3.31 ± 13%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_store_gfp
      1.53 ±101%    +137.9%       3.64 ± 11%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_store_prealloc
      1.38 ±100%    +127.1%       3.14 ±  7%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_topiary_replace
      1.56 ±100%    +162.3%       4.11 ± 16%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_walk
      1.18 ±100%    +191.2%       3.44 ± 16%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_node_store
      1.09 ±102%    +159.7%       2.84 ± 18%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_store_entry
      1.20 ±102%    +169.8%       3.25 ± 14%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_store_type
      1.50 ±100%    +140.6%       3.60 ± 18%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_walk_descend
      1.18 ±100%    +171.5%       3.20 ± 21%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.may_expand_vm
      0.48 ±123%    +336.7%       2.08 ± 34%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mlock_drain_local
      1.67 ±100%    +136.7%       3.95 ± 18%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mmap_region
      1.08 ±100%    +203.5%       3.29 ±  4%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mtree_load
      1.02 ±100%    +370.6%       4.79 ± 48%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.node_finalise
      1.08 ±101%    +179.2%       3.02 ± 16%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.path_noexec
      0.38 ±111%    +437.4%       2.03 ± 28%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.percpu_counter_add_batch
      1.26 ±101%    +219.5%       4.01 ± 44%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap
      1.23 ±100%    +172.0%       3.35 ±  7%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap_event
      0.49 ±103%    +362.8%       2.29 ± 25%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_iterate_sb
      0.28 ±166%    +493.2%       1.66 ± 25%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.pte_offset_map_rw_nolock
      0.77 ±104%    +167.7%       2.06 ± 22%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.rb_next
      0.74 ±110%    +190.9%       2.14 ± 18%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.remove_vma
      1.04 ±108%    +170.4%       2.82 ± 17%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.security_mmap_addr
      0.62 ±108%    +283.8%       2.38 ± 34%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.security_mmap_file
      1.38 ±102%    +152.8%       3.49 ± 10%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.tlb_finish_mmu
      1.05 ±103%    +219.1%       3.34 ± 17%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unlink_anon_vmas
      1.03 ±108%    +221.4%       3.30 ± 16%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unmap_vmas
      0.29 ±222%    +625.6%       2.10 ± 35%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.up_read
      0.42 ±111%    +434.1%       2.26 ± 27%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.up_write
      1.09 ±100%    +154.8%       2.77 ± 16%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vm_area_alloc
      0.25 ±142%    +427.2%       1.33 ± 54%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vm_area_free
      0.57 ±142%    +212.3%       1.78 ± 29%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vm_stat_account
      0.73 ±122%    +238.9%       2.48 ± 18%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_expand
      1.68 ±101%    +156.3%       4.29 ± 27%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_interval_tree_remove
      0.45 ±151%    +287.1%       1.74 ± 32%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_is_secretmem
      1.00 ±102%    +189.6%       2.90 ± 18%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_is_shared_writable
      0.87 ±102%    +238.8%       2.93 ± 14%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_prepare
      1.02 ±100%    +207.2%       3.15 ±  8%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_set_page_prot
      0.76 ±106%    +231.4%       2.52 ± 31%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_wants_writenotify
      1.65 ±101%    +149.4%       4.13 ± 17%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vms_gather_munmap_vmas
      0.77 ±121%    +285.3%       2.96 ±  6%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.x64_sys_call
      1.00 ±106%    +167.3%       2.66 ± 19%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.zap_pmd_range
      0.88 ±101%    +201.7%       2.66 ± 24%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.zap_pte_range
      1.23 ±100%    +228.2%       4.03 ± 33%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__kfree_rcu_sheaf.kvfree_call_rcu.mas_topiary_replace
      1.36 ±100%    +163.7%       3.58 ±  9%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      1.45 ±101%    +124.6%       3.26 ± 11%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__memcg_slab_free_hook.kmem_cache_free.vms_complete_munmap_vmas
      1.00 ±100%    +200.3%       2.99 ± 18%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_alloc
      1.74 ±100%    +151.3%       4.36 ± 25%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.do_read_fault.do_fault.__handle_mm_fault
      1.09 ±110%    +155.5%       2.79 ± 22%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.do_syscall_64.entry_SYSCALL_64_after_hwframe.remap_file_pages
      1.18 ±101%    +168.2%       3.16 ± 14%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_read_killable.__do_sys_remap_file_pages.do_syscall_64
      1.17 ±106%    +171.2%       3.17 ± 15%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_write.__mmap_new_vma.__mmap_region
      0.78 ±112%    +257.0%       2.78 ± 16%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_write.vma_prepare.commit_merge
      1.04 ±110%    +248.6%       3.62 ± 12%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_write_killable.__do_sys_remap_file_pages.do_syscall_64
      1.18 ±100%    +180.5%       3.31 ±  5%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.filemap_get_entry.__filemap_get_folio_mpol.freader_get_folio
      1.42 ±101%    +133.7%       3.32 ± 12%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.handle_mm_fault.__get_user_pages.populate_vma_page_range
      1.53 ±100%    +137.2%       3.63 ±  8%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.kfree.perf_event_mmap_event.perf_event_mmap
      0.69 ±154%    +270.8%       2.56 ± 24%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.kmem_cache_alloc_noprof.vm_area_dup.__split_vma
      0.99 ±104%    +199.9%       2.98 ± 17%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.kmem_cache_free.vms_complete_munmap_vmas.__mmap_complete
      1.41 ±101%    +152.6%       3.55 ±  3%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.mt_find.find_vma.gup_vma_lookup
      1.50 ±100%    +141.6%       3.62 ±  5%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.mt_find.find_vma_intersection.__mm_populate
      1.52 ±100%    +205.9%       4.65 ± 32%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.mtree_load.__do_sys_remap_file_pages.do_syscall_64
      2.52 ±100%    +169.9%       6.80 ± 23%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.smpboot_thread_fn.kthread.ret_from_fork
      1.34 ±109%    +137.1%       3.17 ± 15%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.up_write.unlink_file_vma_batch_process.free_pgtables
      1.17 ±101%    +146.0%       2.89 ±  4%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.up_write.vma_complete.commit_merge
      0.74 ±100%    +929.2%       7.59 ± 70%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.50           +31.1%       0.66 ±  2%  perf-sched.total_sch_delay.average.ms
     28.69            -6.6%      26.79        perf-sched.total_wait_and_delay.average.ms
     28.19            -7.3%      26.13        perf-sched.total_wait_time.average.ms
      0.46 ±100%    +151.8%       1.15 ±  2%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.remap_file_pages
      0.78 ±100%    +169.0%       2.10 ±  3%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      2.09 ±100%    +112.2%       4.45        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      4018 ±100%    +118.0%       8760 ±  6%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      8.88 ±128%   +2890.4%     265.48 ± 93%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      1280 ±102%    +166.6%       3413 ± 18%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.23 ±100%    +151.6%       0.58 ±  2%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.remap_file_pages
      0.27 ±100%    +158.1%       0.70 ±  6%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.[unknown].clock_gettime
      0.28 ±100%    +188.6%       0.80 ±  6%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.check_order.[unknown]
      0.28 ±100%    +145.3%       0.68 ±  4%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.remap_file_pages
      0.26 ±100%    +148.7%       0.64 ±  5%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.remap_order
      0.27 ±100%    +153.0%       0.68 ±  8%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_time_now
      0.28 ±100%    +130.4%       0.64 ± 11%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_time_now_timespec
      0.21 ±151%    +255.5%       0.76 ± 43%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_call_function_single.[unknown].clock_gettime
      0.43 ±101%    +138.1%       1.03 ± 12%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__build_id_parse
      0.25 ±109%    +258.8%       0.90 ± 25%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__filemap_get_folio_mpol
      0.40 ±102%    +141.7%       0.98 ± 14%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__get_unmapped_area
      0.41 ±102%    +149.6%       1.02 ± 13%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__get_user_pages
      0.43 ±100%    +138.8%       1.03 ±  8%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__handle_mm_fault
      0.25 ±144%    +301.5%       0.99 ± 26%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__kfree_rcu_sheaf
      0.35 ±105%    +184.9%       1.00 ± 15%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__kmalloc_cache_noprof
      0.41 ±100%    +163.0%       1.08 ±  4%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__memcg_slab_free_hook
      0.41 ±100%    +155.6%       1.06 ± 12%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__memcg_slab_post_alloc_hook
      0.48 ±102%    +128.0%       1.09 ± 18%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__mm_populate
      0.44 ±101%    +151.5%       1.11 ± 10%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__mmap_new_vma
      0.41 ±100%    +153.0%       1.04 ±  8%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__mmap_region
      0.46 ±102%    +137.2%       1.08 ±  7%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__pi_memcpy
      0.45 ±100%    +146.1%       1.11 ±  9%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__rb_erase_color
      0.43 ±100%    +134.8%       1.00 ± 12%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__rb_insert_augmented
      0.43 ±100%    +150.2%       1.09 ±  8%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__refill_objects_node
      0.45 ±100%    +130.5%       1.03 ± 12%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__thp_vma_allowable_orders
      0.42 ±100%    +140.7%       1.00 ±  5%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__vma_start_exclude_readers
      0.45 ±101%    +158.4%       1.16 ±  7%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__vma_start_write
      0.39 ±100%    +176.5%       1.08 ±  6%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      0.11 ±223%    +729.7%       0.91 ± 43%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.anon_vma_clone
      0.44 ±100%    +162.3%       1.15 ±  8%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.arch_get_unmapped_area_topdown
      0.41 ±103%    +173.9%       1.11 ± 15%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.atime_needs_update
      0.41 ±102%    +157.0%       1.05 ± 10%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.can_vma_merge_right
      0.29 ±136%    +281.4%       1.09 ± 23%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.commit_merge
      0.38 ±101%    +167.2%       1.02 ± 10%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.copy_from_kernel_nofault
      0.41 ±104%    +195.0%       1.22 ± 15%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.cp_data_write
      0.46 ±100%    +153.6%       1.17 ± 12%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.d_path
      0.41 ±100%    +158.9%       1.06 ± 12%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_mmap
      0.42 ±100%    +146.7%       1.05 ± 10%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_syscall_64
      0.35 ±141%    +132.8%       0.80 ± 55%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.down_write
      0.46 ±100%    +118.5%       1.01 ±  8%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.folios_put_refs
      0.33 ±100%    +218.1%       1.05 ± 17%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.follow_page_pte
      0.42 ±101%    +176.1%       1.15 ± 17%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.follow_pmd_mask
      0.26 ±103%    +298.7%       1.03 ±  9%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.follow_pud_mask
      0.43 ±100%    +156.4%       1.09 ± 12%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.freader_fetch
      0.43 ±102%    +151.9%       1.07 ±  6%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.freader_init_from_file
      0.46 ±100%    +166.8%       1.21 ± 13%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.free_pgtables
      0.23 ±145%    +336.5%       1.01 ± 21%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.free_swap_cache
      0.40 ±101%    +147.6%       0.98 ± 14%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.handle_mm_fault
      0.31 ±130%    +309.9%       1.27 ±  8%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.handle_pte_fault
      0.35 ±111%    +236.3%       1.18 ± 26%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ima_file_mmap
      0.26 ±119%    +351.4%       1.15 ± 20%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.init_multi_vma_prep
      0.30 ±124%    +262.3%       1.08 ± 13%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.is_mergeable_anon_vma
      0.42 ±100%    +150.0%       1.06 ± 12%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kfree
      0.37 ±111%    +209.1%       1.13 ± 26%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.khugepaged_enter_vma
      0.41 ±104%    +165.8%       1.08 ± 19%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ksm_vma_flags
      0.42 ±100%    +161.8%       1.11 ±  9%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kvfree_call_rcu
      0.43 ±101%    +160.3%       1.11 ± 10%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_find
      0.39 ±104%    +192.8%       1.14 ±  8%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_next_slot
      0.42 ±100%    +159.8%       1.08 ±  7%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_preallocate
      0.41 ±100%    +156.0%       1.05 ± 12%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_prev_slot
      0.43 ±100%    +148.1%       1.08 ±  8%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_store_prealloc
      0.43 ±100%    +148.4%       1.06 ±  7%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_topiary_replace
      0.43 ±100%    +138.4%       1.02 ±  6%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_walk
      0.41 ±102%    +161.1%       1.06 ±  5%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_node_store
      0.40 ±103%    +183.3%       1.15 ±  7%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_split
      0.41 ±100%    +149.1%       1.03 ± 15%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_store_type
      0.41 ±100%    +175.6%       1.14 ± 11%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.may_expand_vm
      0.40 ±100%    +171.6%       1.08 ±  8%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mmap_region
      0.44 ±102%    +130.6%       1.02 ± 15%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mt_find
      0.42 ±101%    +139.1%       1.00 ± 11%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mtree_load
      0.28 ±118%    +361.0%       1.30 ± 37%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.multi_src_setup
      0.47 ±100%    +137.7%       1.12 ± 12%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.node_copy
      0.42 ±100%    +191.8%       1.22 ± 14%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.node_finalise
      0.19 ±107%    +410.6%       0.97 ± 31%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.percpu_counter_add_batch
      0.47 ±101%    +143.8%       1.15 ± 18%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap
      0.39 ±100%    +180.9%       1.09 ±  9%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap_event
      0.19 ±152%    +580.2%       1.28 ± 29%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.pte_offset_map_rw_nolock
      0.30 ±110%    +274.8%       1.13 ± 25%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.rb_next
      0.36 ±108%    +258.1%       1.30 ± 15%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.security_mmap_addr
      0.30 ±103%    +272.1%       1.11 ± 49%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.security_mmap_file
      0.43 ±101%    +161.5%       1.11 ± 14%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.tlb_finish_mmu
      0.40 ±103%    +217.3%       1.28 ± 25%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.tlb_flush_mmu
      0.39 ±105%    +166.5%       1.05 ± 18%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.tlb_gather_mmu
      0.39 ±100%    +165.9%       1.03 ±  9%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unlink_file_vma_batch_process
      0.40 ±108%    +179.3%       1.10 ± 19%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unmap_vmas
      0.25 ±221%    +469.8%       1.40 ± 21%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.up_read
      0.26 ±123%    +284.0%       1.02 ± 35%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.up_write
      0.14 ±164%    +660.8%       1.06 ± 66%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vm_area_free
      0.43 ±101%    +146.6%       1.06 ± 15%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vm_get_page_prot
      0.24 ±115%    +324.9%       1.03 ± 30%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_expand
      0.43 ±100%    +144.5%       1.06 ±  7%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_interval_tree_insert
      0.44 ±100%    +142.5%       1.07 ±  4%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_interval_tree_remove
      0.43 ±102%    +141.8%       1.05 ±  7%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_merge_new_range
      0.34 ±101%    +204.8%       1.03 ± 19%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_prepare
      0.47 ±100%    +151.1%       1.17 ± 16%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_set_page_prot
      0.42 ±100%    +146.5%       1.04 ±  5%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vms_gather_munmap_vmas
      0.32 ±111%    +256.6%       1.13 ± 19%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.x64_sys_call
      0.27 ±100%    +265.0%       1.00 ±  9%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.zap_pmd_range
      0.36 ±100%    +175.3%       1.00 ± 21%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.zap_pte_range
      0.44 ±101%    +161.3%       1.16 ± 10%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__kfree_rcu_sheaf.kvfree_call_rcu.mas_topiary_replace
      0.46 ±100%    +140.0%       1.11 ±  7%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      0.42 ±101%    +141.2%       1.02 ± 17%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__memcg_slab_free_hook.kmem_cache_free.vms_complete_munmap_vmas
      0.31 ±128%    +257.4%       1.11 ± 45%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_dup
      0.44 ±100%    +142.7%       1.08 ±  3%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.do_read_fault.do_fault.__handle_mm_fault
      0.42 ±101%    +142.7%       1.02 ± 17%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_read_killable.__do_sys_remap_file_pages.do_syscall_64
      0.44 ±101%    +140.1%       1.06 ± 17%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_write.__mmap_new_vma.__mmap_region
      0.33 ±117%    +274.2%       1.22 ± 27%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_write.vma_prepare.commit_merge
      0.46 ±105%    +162.6%       1.21 ± 10%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_write_killable.__do_sys_remap_file_pages.do_syscall_64
      0.43 ±101%    +152.2%       1.09 ±  5%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.filemap_get_entry.__filemap_get_folio_mpol.freader_get_folio
      0.45 ±100%    +129.1%       1.03 ±  7%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.follow_page_pte.follow_page_mask.__get_user_pages
      0.43 ±102%    +170.0%       1.16 ± 14%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.kfree.perf_event_mmap_event.perf_event_mmap
      0.37 ±106%    +220.5%       1.18 ± 29%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.kmem_cache_alloc_noprof.mas_preallocate.commit_merge
      0.41 ±102%    +153.6%       1.03 ± 13%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.kmem_cache_free.vms_complete_munmap_vmas.__mmap_complete
      0.40 ±101%    +172.7%       1.10 ±  5%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.lru_add_drain.populate_vma_page_range.__mm_populate
      0.39 ±100%    +169.3%       1.06 ±  5%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.mt_find.find_vma.gup_vma_lookup
      0.43 ±100%    +147.3%       1.07 ±  7%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.mt_find.find_vma_intersection.__mm_populate
      0.43 ±100%    +145.4%       1.05 ±  6%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.mtree_load.__do_sys_remap_file_pages.do_syscall_64
      0.42 ±100%    +146.9%       1.04 ±  5%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.perf_iterate_sb.constprop.0
      0.44 ±100%    +122.9%       0.98 ±  8%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.up_write.__do_sys_remap_file_pages.do_syscall_64
      0.39 ±101%    +209.4%       1.19 ±  7%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.up_write.vma_complete.commit_merge
      0.44 ±100%    +141.4%       1.07 ±  3%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.zap_pte_range.zap_pmd_range.isra
      2.08 ±100%    +111.0%       4.38        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.02 ±162%    +210.4%       0.07 ± 62%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.wait_for_partner.fifo_open.do_dentry_open.vfs_open
      1.53 ±102%    +167.5%       4.09 ±  9%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.check_order.[unknown]
      0.98 ±107%    +235.1%       3.29 ± 11%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.clock_gettime@plt
      1.69 ±100%    +178.3%       4.71 ± 24%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.remap_file_pages
      0.43 ±130%    +276.2%       1.61 ± 49%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.remap_file_pages@plt
      1.54 ±101%    +124.4%       3.44 ±  9%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.remap_order
      1.63 ±102%    +144.5%       4.00 ± 17%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_time_now
      1.58 ±102%    +137.9%       3.76 ±  7%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.stress_time_now_timespec
      0.44 ±118%    +322.9%       1.84 ± 34%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_call_function_single.[unknown].clock_gettime
      1.30 ±101%    +180.7%       3.66 ± 24%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__build_id_parse
      1.33 ±101%    +163.1%       3.49 ± 17%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__do_sys_remap_file_pages
      0.80 ±103%    +207.3%       2.47 ± 22%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__filemap_get_folio_mpol
      1.02 ±103%    +167.8%       2.72 ± 19%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__get_unmapped_area
      1.39 ±100%    +134.1%       3.26 ± 12%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__get_user_pages
      1.46 ±100%    +148.3%       3.64 ±  6%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__handle_mm_fault
      0.34 ±144%    +326.0%       1.44 ± 34%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__kfree_rcu_sheaf
      0.53 ±114%    +220.3%       1.69 ± 27%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__kmem_cache_free_bulk
      1.61 ±100%    +194.0%       4.72 ± 31%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__memcg_slab_free_hook
      1.10 ±100%    +203.7%       3.34 ±  9%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__memcg_slab_post_alloc_hook
      1.54 ±101%    +131.6%       3.56 ± 10%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__mmap_new_vma
      1.85 ±101%    +160.7%       4.83 ± 28%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__mmap_region
      1.37 ±102%    +149.3%       3.42 ± 12%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__pi_memcpy
      1.61 ±100%    +115.3%       3.47 ±  4%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__rb_erase_color
      0.95 ±114%    +203.3%       2.87 ± 14%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__split_vma
      1.29 ±100%    +145.8%       3.18 ± 11%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__thp_vma_allowable_orders
      1.44 ±101%    +126.6%       3.27 ± 10%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__vma_start_exclude_readers
      1.64 ±100%    +199.4%       4.92 ± 39%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__vma_start_write
      4.44 ±128%   +5768.0%     260.47 ± 96%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      0.14 ±223%   +1149.9%       1.80 ± 55%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.anon_vma_clone
      1.47 ±101%    +156.1%       3.76 ± 12%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.arch_get_unmapped_area_topdown
      1.06 ±102%    +190.1%       3.08 ± 26%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.can_vma_merge_left
      1.42 ±106%    +157.7%       3.65 ± 20%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.can_vma_merge_right
      1.05 ±105%    +196.3%       3.11 ± 12%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.check_vma_flags
      0.57 ±108%    +319.9%       2.40 ± 34%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.commit_merge
      1.24 ±100%    +145.0%       3.04 ± 12%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.copy_from_kernel_nofault
      1.38 ±103%    +157.4%       3.56 ± 19%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.cp_data_write
      0.89 ±103%    +211.6%       2.78 ± 21%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.current_time
      0.94 ±102%    +226.2%       3.06 ± 14%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.d_path
      1.04 ±104%    +142.6%       2.52 ± 11%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_fault
      1.50 ±101%    +148.3%       3.74 ± 11%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_mmap
      1.72 ±100%    +117.0%       3.73 ±  7%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_syscall_64
      0.17 ±223%    +572.2%       1.16 ± 52%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.down_read
      0.47 ±150%    +210.0%       1.45 ± 58%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.down_write
      0.93 ±103%    +177.1%       2.58 ± 16%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.follow_page_pte
      0.81 ±105%    +288.9%       3.14 ± 16%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.follow_pud_mask
      1.08 ±102%    +182.9%       3.05 ± 15%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.freader_fetch
      1.29 ±103%    +165.3%       3.43 ±  9%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.freader_init_from_file
      0.77 ±103%    +191.6%       2.25 ± 16%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.free_pgd_range
      0.56 ±144%    +261.3%       2.02 ± 20%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.free_swap_cache
      0.72 ±133%    +304.4%       2.93 ± 25%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.handle_pte_fault
      0.63 ±119%    +332.7%       2.71 ± 25%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ima_file_mmap
      0.75 ±110%    +266.3%       2.75 ± 25%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.init_multi_vma_prep
      0.71 ±115%    +313.0%       2.93 ± 25%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.is_mergeable_anon_vma
      0.53 ±122%    +411.1%       2.72 ± 28%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.is_vmalloc_addr
      1.21 ±102%    +167.9%       3.25 ±  8%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kfree
      0.89 ±114%    +190.0%       2.59 ± 35%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.khugepaged_enter_vma
      1.42 ±102%    +138.1%       3.38 ± 10%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kmem_cache_free
      1.09 ±103%    +152.6%       2.76 ± 11%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ktime_get_coarse_real_ts64_mg
      1.48 ±100%    +145.4%       3.63 ± 22%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kvfree_call_rcu
      1.36 ±101%    +172.5%       3.71 ± 27%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_find
      1.27 ±100%    +227.0%       4.15 ± 46%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_next_slot
      1.17 ±100%    +190.9%       3.39 ± 20%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_prev_slot
      1.21 ±102%    +173.9%       3.31 ± 13%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_store_gfp
      1.53 ±101%    +137.9%       3.64 ± 11%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_store_prealloc
      1.38 ±100%    +127.1%       3.14 ±  7%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_topiary_replace
      1.56 ±100%    +162.3%       4.11 ± 16%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_walk
      1.18 ±100%    +191.2%       3.44 ± 16%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_node_store
      1.09 ±102%    +159.7%       2.84 ± 18%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_store_entry
      1.20 ±102%    +169.8%       3.25 ± 14%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_store_type
      1.50 ±100%    +140.6%       3.60 ± 18%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mas_wr_walk_descend
      1.18 ±100%    +171.5%       3.20 ± 21%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.may_expand_vm
      0.48 ±123%    +336.7%       2.08 ± 34%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mlock_drain_local
      1.67 ±100%    +136.7%       3.95 ± 18%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mmap_region
      1.08 ±100%    +203.5%       3.29 ±  4%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.mtree_load
      1.02 ±100%    +370.6%       4.79 ± 48%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.node_finalise
      1.08 ±101%    +179.2%       3.02 ± 16%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.path_noexec
      0.38 ±111%    +437.4%       2.03 ± 28%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.percpu_counter_add_batch
      1.26 ±101%    +219.5%       4.01 ± 44%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap
      1.23 ±100%    +172.0%       3.35 ±  7%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_event_mmap_event
      0.49 ±103%    +362.8%       2.29 ± 25%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.perf_iterate_sb
      0.28 ±166%    +493.2%       1.66 ± 25%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.pte_offset_map_rw_nolock
      0.77 ±104%    +167.7%       2.06 ± 22%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.rb_next
      0.74 ±110%    +190.9%       2.14 ± 18%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.remove_vma
      1.04 ±108%    +170.4%       2.82 ± 17%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.security_mmap_addr
      0.62 ±108%    +283.8%       2.38 ± 34%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.security_mmap_file
      1.38 ±102%    +152.8%       3.49 ± 10%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.tlb_finish_mmu
      1.05 ±103%    +219.1%       3.34 ± 17%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unlink_anon_vmas
      1.03 ±108%    +221.4%       3.30 ± 16%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unmap_vmas
      0.29 ±222%    +625.6%       2.10 ± 35%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.up_read
      0.42 ±111%    +434.1%       2.26 ± 27%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.up_write
      1.09 ±100%    +154.8%       2.77 ± 16%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vm_area_alloc
      0.25 ±142%    +427.2%       1.33 ± 54%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vm_area_free
      0.57 ±142%    +212.3%       1.78 ± 29%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vm_stat_account
      0.73 ±122%    +238.9%       2.48 ± 18%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_expand
      1.68 ±101%    +156.3%       4.29 ± 27%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_interval_tree_remove
      0.45 ±151%    +287.1%       1.74 ± 32%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_is_secretmem
      1.00 ±102%    +189.6%       2.90 ± 18%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_is_shared_writable
      0.87 ±102%    +238.8%       2.93 ± 14%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_prepare
      1.02 ±100%    +207.2%       3.15 ±  8%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_set_page_prot
      0.76 ±106%    +231.4%       2.52 ± 31%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_wants_writenotify
      1.65 ±101%    +149.4%       4.13 ± 17%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vms_gather_munmap_vmas
      0.77 ±121%    +285.3%       2.96 ±  6%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.x64_sys_call
      1.00 ±106%    +167.3%       2.66 ± 19%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.zap_pmd_range
      0.88 ±101%    +201.7%       2.66 ± 24%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.zap_pte_range
      1.23 ±100%    +228.2%       4.03 ± 33%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__kfree_rcu_sheaf.kvfree_call_rcu.mas_topiary_replace
      1.36 ±100%    +163.7%       3.58 ±  9%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      1.45 ±101%    +124.6%       3.26 ± 11%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__memcg_slab_free_hook.kmem_cache_free.vms_complete_munmap_vmas
      1.00 ±100%    +200.3%       2.99 ± 18%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_alloc
      1.74 ±100%    +151.3%       4.36 ± 25%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.do_read_fault.do_fault.__handle_mm_fault
      1.09 ±110%    +155.5%       2.79 ± 22%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.do_syscall_64.entry_SYSCALL_64_after_hwframe.remap_file_pages
      1.18 ±101%    +168.2%       3.16 ± 14%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_read_killable.__do_sys_remap_file_pages.do_syscall_64
      1.17 ±106%    +171.2%       3.17 ± 15%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_write.__mmap_new_vma.__mmap_region
      0.78 ±112%    +257.0%       2.78 ± 16%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_write.vma_prepare.commit_merge
      1.04 ±110%    +248.6%       3.62 ± 12%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.down_write_killable.__do_sys_remap_file_pages.do_syscall_64
      1.18 ±100%    +180.5%       3.31 ±  5%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.filemap_get_entry.__filemap_get_folio_mpol.freader_get_folio
      1.42 ±101%    +133.7%       3.32 ± 12%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.handle_mm_fault.__get_user_pages.populate_vma_page_range
      1.53 ±100%    +137.2%       3.63 ±  8%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.kfree.perf_event_mmap_event.perf_event_mmap
      0.69 ±154%    +270.8%       2.56 ± 24%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.kmem_cache_alloc_noprof.vm_area_dup.__split_vma
      0.99 ±104%    +199.9%       2.98 ± 17%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.kmem_cache_free.vms_complete_munmap_vmas.__mmap_complete
      1.41 ±101%    +152.6%       3.55 ±  3%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.mt_find.find_vma.gup_vma_lookup
      1.50 ±100%    +141.6%       3.62 ±  5%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.mt_find.find_vma_intersection.__mm_populate
      1.52 ±100%    +205.9%       4.65 ± 32%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.mtree_load.__do_sys_remap_file_pages.do_syscall_64
      1.34 ±109%    +137.1%       3.17 ± 15%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.up_write.unlink_file_vma_batch_process.free_pgtables
      1.17 ±101%    +146.0%       2.89 ±  4%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.up_write.vma_complete.commit_merge
      7.41 ±103%   +2361.8%     182.41 ±202%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork
      1279 ±102%    +166.6%       3412 ± 18%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.worker_thread.kthread.ret_from_fork.ret_from_fork_asm





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


