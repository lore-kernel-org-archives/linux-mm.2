Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33C97FF887E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 02:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974A76B0088; Wed, 29 Apr 2026 22:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925D36B008A; Wed, 29 Apr 2026 22:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ED2C6B008C; Wed, 29 Apr 2026 22:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2396B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:37:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 074DE1203E5
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:37:50 +0000 (UTC)
X-FDA: 84713661900.06.AF85A7F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4E8E61C0007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:37:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AAOUHuP6;
	spf=pass (imf18.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777516666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Y9BsHSm/L0aPEpfYxtuj4fBpjW3NMQF2bcx/LjsURo=;
	b=CP9tKBienzMfpkX170up8vHy18zLFkBoCeU0ViPXUeJrAfFWitdmPRh3NywThvDcACdRtl
	jTuIY+KkY9O+uVyR9F9AZVhsEnK0MK8jhDQYeGjQFu2xaP9hNVJ6/POfjjgEkQ2JObK1yK
	Y9S+Kdk/vUIUfkV5NmP5goxJVA/zw64=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AAOUHuP6;
	spf=pass (imf18.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777516666; a=rsa-sha256;
	cv=fail;
	b=StVKkmOv7PDwBUVuTjp1Hvxc5sHQ7tb/2hKNajvQ76aFh07tjr95libyBgo3vbRpb5hls+
	cVI39vOEsXcU5HdbB6xC5zTM/NJASghTysJM/DqYOrWjjaLvPYaS34WLHpnr/sI0qaGgF7
	JTlJFiqxZK+WD3I7zYE/WQCj6i3iNfw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777516667; x=1809052667;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=8WDE9x4w67Yt8BzL3A1sReRDQQ+a+5xhnEoFis7KTbs=;
  b=AAOUHuP6FCZHV4qy0X87PpmB8TS8+P9rn/xDUSjl+1vp1i8c3sXfG1O7
   7EvXwfxi91rjIG6hPYlC2GVd+Xd2As0hNgqX191DpIRHjXC1JpMiMMzrR
   f4i1CHILmlGMn1DEHcyUNI77PcHKTbavpYuCqaAeZbekr0PLHsysUMqw3
   OcHRnHn8s6TqYgMIDoORvqsqp0qY+1CjU5wdPp7E6tOupCKwRiZE5epMe
   GyVlbcwge0KAEF/D8D/g/2VqTDeIY0vRnI4+bNRn00QYUVD+b8cl2C/5z
   1sLkucmOr4C34gmgiDkJV7XfLWOkvMJheUbFBuOiwbEAL6121M20dGf8Q
   Q==;
X-CSE-ConnectionGUID: q6uhO/hXTBGURhxZpyTXnw==
X-CSE-MsgGUID: dA5BNKNATv62D+80CWB+hA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="88770790"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="88770790"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 19:37:45 -0700
X-CSE-ConnectionGUID: ro35yKJ9R32Cd4wGlwHCSg==
X-CSE-MsgGUID: xF+fHm34RHqnedFRaYRWGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="238775190"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 19:37:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 29 Apr 2026 19:37:44 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 29 Apr 2026 19:37:44 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.34) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 29 Apr 2026 19:37:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MBxcmYe1rrptDXV//p7murdotbe6FQgTBbATr4+9LMRpSFagUfwC2c5jfQ138cbhKuiy7lqdZyypnNHKWmSngBIb8dCpP3fXdxpLEJSfqxAZ/B6QwZG4eXhB+kdnci09/GCoRg8k16633Eo0JAwPepRdRg1g/Q9StBXnZmoePo47jEd7d137ARgBMxY91eOUIIZINwZa8GNJg/Bm8cKrat/xvHoK1Y3MNwSpSFWCcfIxdCAwq+tQuHJ+BcdWneOcgK8QZYITtH3CpMWQEa4c/QRq1/0jMbQN0aE55a4u590Y6boTk87ZgvJoi69GN6Lkm/BmgARQgy3ol9a8KZEzLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGdTBPBbc2SwV8hx6MnXtBCWQrz2G3qLYt+LoR/SaUw=;
 b=av+jwWhLODy7PkbhbZgNorZUPJSA3l1zWlPUZqNGjF75Sp8zKwVhss12G7z9Eacar4dzc/HOVqJ1tQKMrubI099i717cRtsx34GljcEhnbiE9pnza15OjnIMQT6FRmnfZu0PcSaN2F8WxlrFQStJI/U1I1hEVE+MVWd9PnMEgEPZXF5fr23LLBTFUJUD1BHF52g+9GZpIdGCdTrMTHzFj0ZgFUG0Tu5beEfukDDMKkgfctCWq3SJaPN2C/0aT/lRQC8ush+jr+AGkYXpW3SCibjf3pqL8QD3Nvf/bV58lCEZILAxd/PBQ4Bk0RydVsZ1xjAtbEs8Pp1OXGGkYpxxYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DM6PR11MB4529.namprd11.prod.outlook.com (2603:10b6:5:2ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Thu, 30 Apr
 2026 02:37:41 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9870.016; Thu, 30 Apr 2026
 02:37:41 +0000
Date: Wed, 29 Apr 2026 19:37:38 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Andi Shyti <andi.shyti@kernel.org>
CC: <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
Message-ID: <afLAcsbaX3YVHI7R@gsse-cloud1.jf.intel.com>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
 <20260423055656.1696379-2-matthew.brost@intel.com>
 <afCCCuLglfi70Tgq@zenone.zhora.eu>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afCCCuLglfi70Tgq@zenone.zhora.eu>
X-ClientProxiedBy: MW4PR03CA0086.namprd03.prod.outlook.com
 (2603:10b6:303:b6::31) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DM6PR11MB4529:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a83bcf2-c79b-43d4-da2a-08dea661739c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: i8VF323JGd1lHUrn0dcFlmCBupMJYCoQ7ChU5P+QpR01BIcZLnly62+9/ft+n6o8pTbbkkHQKQgs3fDea7BBgcFadICC2qvsUnpLCmUmNp9XcegVmPRqMrlEWYHNiW6d2AVb/SPy/ogJ5+YHPx+qyIMx35qPMbM7TBWsXWWjaadFdEmlQJfLIFut6F5a8pCYkFoBrafGXOETtdVfQIlgblOiaBMPQK3Bi9FyVEJtDn2oP7xayY73RmMojyM0EYqWcZIjkR/QRiPXVlU3vwrMAPI8GpYhcKkMb4Giq9z+vlfPAcUXrOdtWTu/aysXcycAvMPuVicIwNAqJMO02DtnjTIyF/Fkw3JJXJOdAaWTFbSQgLmtEixYA9kwWFt3FY+kRMWbDPoKHaEfWBDPx4STpKCag29HVQWKomaqc+Lxe9FhWTqtw8viauJqwlLtjbbAQNEDV4SCewHRkHLbEu5jdomyc3dobKRRnzJQz4II+ZqMZXEBNuluhEqlqxygPr7h3Phby3n6z2Ui1e64twFEKqB6lbRYNPD1bINsX0pKSsdJhkByP+/valNFJDMn6CFf0a8vqtPZoxRNzgbOspSMlPIhTgvmasg6VvGATWUqIBgNUttYmYCxga9EYYsD126BzDJtNBiIvg8D/QlpyJ8gsauyWRvSKs2MVir4KLbH3WO0s8aobhLdJxUzcaEYgK5lDLmgGWqzvB/R6QGcg7YKHhvlRpUKzHOTihKyW/4kqn4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?wjYJQwIJn5Kcu7mloJ8+rK30ytc/jOnENIhRHRuNdLrXiOgS3DeKxvPorM?=
 =?iso-8859-1?Q?slJu9wEaVMphh6k8tmIGJWpTSa4B0bigp8X6X/I5o/c42Uf2E167zVcXwD?=
 =?iso-8859-1?Q?9HBG+cYUXMG+7ipyn7cqvHFEbpEtyhIs28ZhnD1FJGGGrLfJpEhVSCLmgt?=
 =?iso-8859-1?Q?6PbAx3mkq3Okr0sxWz74XaERvm7Gh+1VEx8t7RK0RfVc602mCIUYz6A86b?=
 =?iso-8859-1?Q?MjSGHi3VmLAq+kyEuAKEnGYo8AdEsZQYUSxjAsVL2IcKvjGcCSnkyrSS36?=
 =?iso-8859-1?Q?Yd9rZlLDDomPWSZa1cgQl1aHixbdXKuUTiUtwz4E6liBzO6UiP8So0HQPh?=
 =?iso-8859-1?Q?AozOoxVTPNcCJJBC4KUaQ77g3+c54uSSmO9okH8ELWQwGBtLvsuUXryQSF?=
 =?iso-8859-1?Q?iEyaCFo5TSFvQM4AtHHViq+zYrHU8k4EAeA2CREiTQZFMuspmRsaPlafn5?=
 =?iso-8859-1?Q?YvzLYTzKLoie6H+XjaamLM4byo/0pROJFoUOB9Jz+iHwz5Gs1+Ccg5vmGs?=
 =?iso-8859-1?Q?q++K4EC8NgqGMx0iwfMXwG176i2F9rFtqlwhc25dI4zxAGp4DrX6PcrerX?=
 =?iso-8859-1?Q?9u1Ab9OVtiF7TIb3hoSFfpD+0JqvYcE2F/XzRh2pxSWCYuiMaSiCbmIF/E?=
 =?iso-8859-1?Q?wTYrP6pdJeP13+CTnjbldtHHF5qbXxjIROYKXU6xXzqQ3cbT+rOHXYPdVq?=
 =?iso-8859-1?Q?imLNVRvU/+OoU5Es8YNCVkRq3oM9UevCnVMHKHc9h1QWkkYN+Agyozr8i3?=
 =?iso-8859-1?Q?7/seDLZfXouOLlqeQvLA9qnPml+25zOURkogPGgecSyLjz8sxjlLTqRZM5?=
 =?iso-8859-1?Q?CSeXyvOmMY/TWUNY2vsbeIbplQH8oNeH3TxhWL05zwFG9FIX6DUnt8s4zu?=
 =?iso-8859-1?Q?PJaJ0fwS4XjVz4yLI3Gbdvl3YwvLkuG8Ol3cMr3FO1BDOGUgnRwTShJN3D?=
 =?iso-8859-1?Q?OmK6QWpHs1i9bQLLxQGLD3KR6MTPtza0fNuoYYmaQd/VgJh2gN1WGCWdhR?=
 =?iso-8859-1?Q?466SueGjAaWbdLzTb8q/VZmXhUmELB5FwgXl9TEOgEJQoXiathrctN56Ym?=
 =?iso-8859-1?Q?l050IVDqLtyIv9qCgsqCXk0slF5N5oy26xQ+wueREZE6JIoXlH+B/mf/t6?=
 =?iso-8859-1?Q?i8gwvfB6Zks7gJdBEGUKoRy+srldr5Y+9ov1MPhVeN9+UT8E/kmV90b67V?=
 =?iso-8859-1?Q?TEA6bUbtOwyKkaxDAVBTmFDDF94wzt1tQESJ2urbLJQ/L4UkfIcSLiAeNU?=
 =?iso-8859-1?Q?MavUDo/RKgMozDXpaeeVqauRZc6cli4IQs8Tzk+7sAcasda/t0m+jyK4LF?=
 =?iso-8859-1?Q?36thcvsQsb8CT5fp14ImgNG189WUlbsvARZ3O2qSmcKjSxCB+TGPZdz8AN?=
 =?iso-8859-1?Q?W7ahd+1SbcVD+X0l2YH03fiXIPGYbpCodbwy025cMFYAfyLcR4ZEp0qqBC?=
 =?iso-8859-1?Q?O4nGq5qJfHqdKvmiBgJn/qEZkWBHbv8xV16IilRQaiQPnPkMlaAh3eWc+W?=
 =?iso-8859-1?Q?A8bJ8yVl31XJJu0v+hqZsC93DuTfjVv273ST7PQxXAGcIQ4lLyIUX7WHxs?=
 =?iso-8859-1?Q?oQAkbsD50NKd/BqY2A0iHAoH0lZMderZprmNLH6G0evT/IMzQ2jSjw+Pko?=
 =?iso-8859-1?Q?mjd0E79kObgu09+QyOZtn8QD/YWQpIKIW0pFK2G87VmbFUottkI2TI2QAx?=
 =?iso-8859-1?Q?ufdYQLwqxTw9rTjo5UFack7t62nmRJyvJ9RidHjkFs8nWkS02fR6ec+q98?=
 =?iso-8859-1?Q?nbvAgKTvGYCiWITwKYX3Xbj8GgjCFW6+X/BPTjJVVe1A/nCkFeOC4OjI9D?=
 =?iso-8859-1?Q?WG5MM+vs0g=3D=3D?=
X-Exchange-RoutingPolicyChecked: HiwLk3e6wuLBjEEU8JR9ARpooS9iK3aNcJK533N0t0oobJNiwp/tjnZAqpSXvYtIqJQuTQ4fn+fpOPIaUtHWIQzKVLcX9Y6BiK5yKuQPPQnlvIIB75DSDbACrqOemoAxExQ3YWhOToZeMktNO29GfoGAHuXMHcMn6Y+4R1bleh1X4rmabMTBfiViDZ4g+p9bPXx/xe8fvbAOn4jw+uVSJN8CUHFVT3o0nPBgp4tnhiom/56D50L1KLT7VUFdlUG4R710ro5Nu08nT93WDLliL8048+r+/sQrqPcvelIrUe9SnjeIqh4StyO/ybfhy7q30sh8S5Qy8Wh23IS74G1gcg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a83bcf2-c79b-43d4-da2a-08dea661739c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 02:37:41.6072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1QCddrXe9DAf2QtfTdqrqfHtv6ypdx58xoyExjPV+OWaxknMjSwOCr+p1V9vLj0WQZpLn70u4VZ0VPtmG//Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4529
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4E8E61C0007
X-Stat-Signature: 9qkx9nudzbttketfiqokcdmm8zxwzkma
X-HE-Tag: 1777516666-774183
X-HE-Meta: U2FsdGVkX1/jcYmgLaH0nMP8mRJAHlJYHrk238JwSbeX5Hg30h6SLPaDk+h0QUhIqxCbxXDlxk0YOp/5aYej5SElY4UZzcxDs3W58V2I88pjo4lSb7AePtIQT5KiVM1UciE9OSBXjF1TTmGjVz8HHxN8vNtZTkoT4Cr7NnvDCeWfaPjJAWZ/AwJ3GKp0hXq4iIwF14zwYnq1hJ343+gE/AxZ9Ggtw8aLATf6A6FeHBYH2dqBerzysu4q3yW1SW3pfb8LVgLglgTb1e0Xn7uldmhv71fasJnkl0PEzyMjDpQNjXjCs/VJlMYBg7x4uvrANVgDvXDbcMxqYVu2qUb9Ixujfyf1DXuEfATiDDuilpNhwuzuE1DMbKxNu/OZfFKtdZ+MPUomrXsYZ2rjnBhFHMZXvDMIihr1cHlRnnfd518LfXapot9bQj3NAvIdl2zu+lPFBO3WVD2KQtcG1oXzbx0PCwxwoGbYe9hA5qAuj+iE9XQNiWJhv/lhs3B7kQspOFLFXBXc5F1zoyFxn6d9/DD8qsfrS3iqEwf539zvOcC9eo1fLbEnTmkuaclR9/3dDWsRNA8E+zt+rFR++7+U5qOO7/nkQgGeIJgViLGXtI5NDfiyMND5euIN66Tj56PGYUYU7cS2vcVYoAHZDtuidETjdK34sWkx+Hhqyrg12Oj3vfNb90aE4OFGCnUa2QR1b5cpanDEuLC+N2rFWpI/1ALd3gZ5KwFjrjxj9gqukNEPM5RQwRa7TBpOJquZnKilwxtnNS6mpZEy3MQH8kVKKnpFEnxQBdZsVEFX9MDmaSq9R0DTFnWC8A9wK6tio5n1qLZHH/0vQg1NLZaR1DE47OrqUi7vgGGX30nSbxJBVbjXFqonh500JGtuMVnasw+6cai6Q3aNt8i9gGPyIIqNN9rlapJ8iNnyUbLOBUrSlY5kn+y6bEuqk1quXz36UjI+ci9VLzKgPRLrZnhg9Zs
 yZEdOMmb
 Dj+P4WD3QIcDpTs4fuiAylpkECMnD20jLh4mA4QMzkDSWnYKCgQP+/ZyJXZsUPkf4+JboL5pb0V2CkyfZuSio/9zq+9DbNJZKgCWRMfbGNgk7MmwzDM3oH7gGiQVrHegXTyiyT2mqhLPkId7TsHz/71JvykQVCMzDkOtJucW6ZO3p2ULZAqjIUEaIS7W2mRntvuhY3YfUAfT/wvwsrKNwY3rYKQanpnRghErD1sfz8/tm9Kg7DYHOa+nvwbqJK8F/UwmUOclfGsKu5oD5CodDmdVrL8CQK0lsugkLrKOPuvp/UacWp9njrShDU98G3c+obMWkMXq8Qa9LpsW1Rz2869iEDx9Su7K/kjZNEZTQ3jnrQyMQGrpytLJEIrK9h2CtYJPx5rT+0RPPx4gBpBaQdywClTH4OL6BkDCjT3vFYvypdXEaUfN/pw195kW7u+dJSi+Q/zi+J1SrCoF42ZGna6pAx2anexnbY82HLN/bNkriyA8IL6Q4vYy1ogUcqCGaQIS2I35kp+cFQ9D4URsOR56ehIsh0/9cX5F1HUgruPGQsL+nxWAsgT+F2zBtk+06rOuVdFAMXuSyk/kTEiZr1hto4j/GEClZok7fecUEHkiVG4WWuQJNJlWRMqWyKyX4C4xziUmRb/0eMfoNACxKj1JKRjSsMvoB4t8l295QfUIm2nKbM2/+8HXsTW8KK0LDXUuYId/tn4q0cJv8FOfL4NeLy8ZEDthmcPBM4YPQjDDkNqVbrTVe0IbjRiOOyaZ/lBfqHQbmr1cagIBnazhtR3fsUqoKYmX62RKB2mw4bSqLGcLWlqPhUV5wYUHm3scDykoj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 11:51:34AM +0200, Andi Shyti wrote:
> Hi Matt,
> 
> On Wed, Apr 22, 2026 at 10:56:52PM -0700, Matthew Brost wrote:
> > Introduce zone_appears_fragmented() as a lightweight helper to allow
> > subsystems to make coarse decisions about reclaim behavior in the
> > presence of likely fragmentation.
> > 
> > The helper implements a simple heuristic: if the number of free pages
> > in a zone exceeds twice the high watermark, the zone is considered to
> > have ample free memory and allocation failures are more likely due to
> > fragmentation than overall memory pressure.
> > 
> > This is intentionally imprecise and is not meant to replace the core
> > MM compaction or fragmentation accounting logic. Instead, it provides
> > a cheap signal for callers (e.g., shrinkers) that wish to avoid
> > overly aggressive reclaim when sufficient free memory exists but
> > high-order allocations may still fail.
> > 
> > No functional changes; this is a preparatory helper for future users.
> > 
> > Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > ---
> >  include/linux/vmstat.h | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> > index 3c9c266cf782..568d9f4f1a1f 100644
> > --- a/include/linux/vmstat.h
> > +++ b/include/linux/vmstat.h
> > @@ -483,6 +483,19 @@ static inline const char *zone_stat_name(enum zone_stat_item item)
> >  	return vmstat_text[item];
> >  }
> >  
> > +static inline bool zone_appears_fragmented(struct zone *zone)
> 
> this is a bit of a strong statement and the function name might
> be misleading. You received some suggestions from David and I
> would rename this function to something like
> "zone_maybe_fragmented()".
> 

+1

> > +{
> > +	/*
> > +	 * Simple heuristic: if the number of free pages is more than twice the
> > +	 * high watermark, this strongly suggests that the zone is heavily
> > +	 * fragmented when called from a shrinker.
> > +	 */
> 
> The commit log explains it a bit better. The heuristic statement
> here is too strong and it still sounds stronger than it should.
> 

Can reword.

Matt

> Andi
> 
> > +	if (zone_page_state(zone, NR_FREE_PAGES) > high_wmark_pages(zone) * 2)
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> >  #ifdef CONFIG_NUMA
> >  static inline const char *numa_stat_name(enum numa_stat_item item)
> >  {
> > -- 
> > 2.34.1
> > 

