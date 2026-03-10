Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70675FCC9CF
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 06:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA106B0088; Tue, 10 Mar 2026 02:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958356B0089; Tue, 10 Mar 2026 02:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4FA6B008A; Tue, 10 Mar 2026 02:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CC226B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:39:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02D61B98D2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:39:47 +0000 (UTC)
X-FDA: 84529202856.25.B01087F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf17.hostedemail.com (Postfix) with ESMTP id 343C540008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:39:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="UoQz/cu6";
	spf=pass (imf17.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773124784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OJhN1dSHLW7qcTvRJqYCyP/y1kk74TR+Lx1V2c2h1Nc=;
	b=NLfzLh993ghgJ4kFAIJbXeOmwVbCr4Jcx5XY0OIrrQAoofbIRgLKgtmIokntri2TOKeb0W
	lE8itML/dawC2iJKnGMgcZUFgfv9WoZ67sFuAixkSg4tbn7300jc07ycogiSS+Gl41WKSw
	0/3WS7yR1t1+ZGUFMlVDCMnwTyT2eRQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="UoQz/cu6";
	spf=pass (imf17.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773124784; a=rsa-sha256;
	cv=fail;
	b=v7z+hIQe9zifUR4lUjRMeGvdcDpTDqg5H512RTTE6ax9XY7m/aq7Hr+lzkckxbIoMITKUl
	X3l2dKWyL7Peco2gWNVcWbMSvfEDe9rlgrhulQErqVkuwKkqct8t1zjkosn60G9UInByxp
	9oqXv/8Yaej/UgWI0HhXNW5Zt5iu4Xk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773124783; x=1804660783;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=siMysJOAUZAecAUsR3CaGV0K9lPHHa9d/dWZjLaaKOk=;
  b=UoQz/cu6By2pn1Korkg/Sc7wfkQ99g9ENyEJ2BX/2NLIxefceBDyJ8yT
   jJf912apqoe5IuyA7FnBmiDG30jbeYtfHNAgYM/z82KW1j5C107vwAjx+
   mU+CluiCsu1CgpkfYFYSsOcOWR28Wany6NGvq8I5Xu+Akr8Jjx2/0ppVP
   AxW0vJnzoMpvb2HKi+ieanoJGLPxILJE9DlXVvFhnBuBCeHPh4e0r79ll
   SiiBoG3yAzocEgUfbZgpogR1IZ69Q7dOMgBQlOhMVrf+iHuVpoyq7V7fP
   nUz4JeIwfxfY8Hk591Gcxo/PEyAaaMPVSGNM6PQAkb5IqjaTmrVBSGNre
   g==;
X-CSE-ConnectionGUID: 2ets2fyBTDSOxNCCU9HD7Q==
X-CSE-MsgGUID: XuAixVLaQc6TpG9bzlDE9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11724"; a="91546009"
X-IronPort-AV: E=Sophos;i="6.23,111,1770624000"; 
   d="scan'208";a="91546009"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 23:39:41 -0700
X-CSE-ConnectionGUID: u3ohMSqMSOWstCj1ON+Ngg==
X-CSE-MsgGUID: pjEdH1gYTempEuKsrJTlaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,111,1770624000"; 
   d="scan'208";a="219138709"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 23:39:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 23:39:40 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 9 Mar 2026 23:39:40 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.46) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 23:39:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xREHR7U+IiUzJ3lXyrEZ2zuJqSCQWEXVZdC6bYoskqlzwVUTtcsi+cwxzsKuN99kHqzmKMZ+cRlaj6NNSo/rHpRk7j7xZgCv6UNCxGgpKe2+gjAZzY2raSyRw/hgN7drtU8SGV9E+izyYVeh7wxoMdp8XrCNArBvplvof7RmpqEQiG8PZogpvvyasDoipzAUwxpkts2ribqBiLR92N3/ETy/TL0i9KaNQP1PUzJs8nT5DTMmknuramSY7J6zEgL7P1x8VP4dfHSIPBUmESzBXqgoqgTYwPvwge5i9YD4/WwDO6KtnUmPX5RiDNsgNUjugWOIw7Xxxy1i4zH47WG0ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iTj7k+EsCjhpxTT63gG4/sU41bRjK3sDYS6Kwx1pT5g=;
 b=uMiTzWYljZNrqfLsf3taMKcTAG4/+WsAjQuymPPX/J6UmR926P8mGVrIUxrY4LhCiQbDz5Zoo7p8sD7X8j8eojBePxssI277qiYGzAJjIqy8gDn7QZHJk2BtZPH0G6vj8PVWqKkJeiszJuo8bDqfimSFXR4JVwwnkuGgft1SWiVs1m06GKDuUdjGQs9iXHZ8UayVZl/HU3OjIE/roZxm6xgm1GcVBB3O+TW0BfRohtbxSTXmKEXGk9JWGu0exj662pDSwlQib1uDPQJ17pd9YBlkh1A+Qkw8C7ZGoTgzICWb4UUc4H3YJlILpsgi0jIQEno6UeFQLJqgQscPIoilFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB4033.namprd11.prod.outlook.com (2603:10b6:405:78::25)
 by CH8PR11MB9457.namprd11.prod.outlook.com (2603:10b6:610:2c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 06:39:36 +0000
Received: from BN6PR11MB4033.namprd11.prod.outlook.com
 ([fe80::2c28:2983:2947:24b1]) by BN6PR11MB4033.namprd11.prod.outlook.com
 ([fe80::2c28:2983:2947:24b1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 06:39:36 +0000
Date: Tue, 10 Mar 2026 14:39:23 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Raghavendra K T
	<raghavendra.kt@amd.com>, David Hildenbrand <david@kernel.org>, "Andy
 Lutomirski" <luto@kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>, "Boris
 Ostrovsky" <boris.ostrovsky@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>, Konrad Rzessutek Wilk
	<konrad.wilk@oracle.com>, Lance Yang <ioworker0@gmail.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Li Zhe <lizhe.67@bytedance.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Matthew
 Wilcox" <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
	<rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
	<surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [mm]  9890ecab6a:  vm-scalability.throughput 3.8%
 regression
Message-ID: <202603101342.297fb270-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TP0P295CA0014.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::11) To BN6PR11MB4033.namprd11.prod.outlook.com
 (2603:10b6:405:78::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR11MB4033:EE_|CH8PR11MB9457:EE_
X-MS-Office365-Filtering-Correlation-Id: 859d1fb7-31cd-4d2e-c88e-08de7e6fcbdb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: iXwTqM65KqJqdUiLjZDcSZAKtAtJ2s6/IsRprduFr7hrmiO72uu0aAFocGPrTrxszBNhuCZRFWjqtmt8p+Rwjxd30MJI6swlQLqoIXkVoqQDa5AVIhYSs52O1Q7MP/oQWhOdNIcvXfsCng2XYXEazcfEYtyb0cApq/1fU9bEpKgG5cWG3LR7qb4uli1TsS+/fgPAVvIUZwrP4S4sRrEJ6bWArBTdT0C0qpbydT4C/nf4pFto084+94w73C4gICCiweDDHlx4qKI6Hcna0rFloCBriJ33XmE53Jp3oY1R4mLpC/fUE9EwNodZ8np/Pka9wNrhWPUVj6pxVkj/6dzAwuWNY8NSWnbH3wiolZJbYmozimlKTM7kxsAFmvLq8r6Nk1BSdzR21BNaIM4/TBxvrnaHP+Yu0G2j+NuQuC7iIhHzj7aItv+gRidDXBJlDIVxzmc07YQNy4W+vgPZue1OGPtgw7A6tXJv7c+LXm5LDZQCN9TYlJH6FEyo25l65McErossBNpTFLtzOBlgJcbGA/iygRvzGAW6tySDkgdcDRfWlNBZxxkyqAzYZ+bk0+3E3kobVi6euV9WZbd/l7zcVaeXi/2mRWvo2MrFToFR1HgLM7xJIMRRZGyfc9v4o63UfnWMJVpKDr1A9FWTEdDsWg+OGrmkq0zMy9nSRbP0jlM22F203hCkB96VAx+W1YCL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4033.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?z58jVlJ52gsslYYVaqnnCQvE5Xi9StlIRTODHqu5QxgAVe/9jrNQL3HPm/?=
 =?iso-8859-1?Q?EfTUU2OBAR/1B4YBKiGsJkXFYfB4EvQGeKJ+DkOTi4DbGqapqSg+dUVqry?=
 =?iso-8859-1?Q?r3CymyOpWPVR7+DCj5ndJX/1dBrCvGJ0cMCizuf5IRNl8YuLGszZ3qJKR3?=
 =?iso-8859-1?Q?WG0O44xI9YdOvEp5T9/dfiglex0jXcwBpPhfyFiNdH808sGqTyiRfuCxHq?=
 =?iso-8859-1?Q?UtKqX1rW4bWsTfx30vkItbH4LN7gwnXT5C0iMr1S83PHxPzBd+dPKLGDSB?=
 =?iso-8859-1?Q?OvPaBcNBAxKhm1wXz09Q1jsI1VDsEu+O25KYdODjLD2BCcMWeMqvuWXDSY?=
 =?iso-8859-1?Q?xnPJ2BebosAoBt3Xe+g2/2a4F1WliVceJX2CRBvuhXuFnL4ERqtJX1LNXI?=
 =?iso-8859-1?Q?C2ecMZN9xXF/rmYBVqSDhIx/ABiIgIH8efM37JYR0bWcfmBnzssLLpn/w3?=
 =?iso-8859-1?Q?X0Q/sRIp0dqBCaXjMSO8ne1aiQWS8UghOmx8gJ1t7h3GEgoH4lKro7SkOm?=
 =?iso-8859-1?Q?yQETHkJD67t9HZ9kumnX/meOQ5JBQpaCiKMxnzB0vxC7ii8cEOOdAVV3e0?=
 =?iso-8859-1?Q?a5gxyPNQ6MB5qB+d52Te+KE4x0xUO5XHPQQQT1JrUJVLyfxogtTn8G9ev/?=
 =?iso-8859-1?Q?KQGzpOyDT1XLzcddOv2VSE1jo6ULUReRX3C0T56YKUWh0fyzBTqqEqQI7l?=
 =?iso-8859-1?Q?wVJGkODAnJMLESW/PJDyi+TuAtCbidAQ+S6ocbbxHAcK3zR4560Dcto6HJ?=
 =?iso-8859-1?Q?klCWukYprtnXFel6Pis7YunNxZtnHunT7AWsU8iLB/26tmJHCRcJ6pnRvq?=
 =?iso-8859-1?Q?y4hwsFs0DROpJmyGNzeIVAryWLouf+MhlRTFpCDkD/ocOyJjbjoknZjEiq?=
 =?iso-8859-1?Q?qgfXjLbqP5vpGOzaIkJDNoevY3hJ7KYe1jVwI5J0NlGniXadHkaMyTMSYk?=
 =?iso-8859-1?Q?lAl2BnqnhRn+s2qiL45ITHnt6J0H8f5LMnP4uC6Ka4T1Nslhf8Ahcj4kQC?=
 =?iso-8859-1?Q?lK7c5C7FJT/Oe6hSdRTkdsDmtEgzVJPOa+eC2u/mh827ujoyIGwaErn5mC?=
 =?iso-8859-1?Q?Z5ldp8I93lPufnZzs15lhCGIgDQou4tlxuA2qbPbRa8vd6HblnEoJnLV8G?=
 =?iso-8859-1?Q?3T3wRX0LqeMRpSJ1FvADLMemaBn6+J45V0UaodEPP7pa53sVlLDP/mYoJF?=
 =?iso-8859-1?Q?4/G2ehDkBKqLaz894KRw91WLdiugiwWyK52i278HhrPniGJM0oBKMVANkM?=
 =?iso-8859-1?Q?MwHF+P2+0p5OthUIJpC+HgjD3KI3oU8OPr09fCf/xeFJHx1tjBvnwZ+Ae5?=
 =?iso-8859-1?Q?Sqb01EZQopaILgAkeMGjMaNpAITqd6lbQDhyeSUSzz3+t8qB1g3L5cuDRI?=
 =?iso-8859-1?Q?TkYy/vH/S7SX/Rl8Af3X51ZQIR/XgfsZxyCg1+JgaRxjPeZNZi4IhohT6C?=
 =?iso-8859-1?Q?ij25w/R9/lIQ7LEriGTNTwRDW6QHh+/JffWoFMsZ7/dmx+rLJhSwZZ7oCp?=
 =?iso-8859-1?Q?3UGp4d7xM05Qmdy/+kxCmIx4K+i/hb0Rwvv5RXkAsat781K6ZGSV2fIs18?=
 =?iso-8859-1?Q?PbaCjK4H4wOUGKGwULfWLdSyOTr120CvSHH73/GOua/LF+k5v5q5Nfo+0M?=
 =?iso-8859-1?Q?tWizN2AKkVUHbut2s6Ulqlp6cgJcr+GnTQ2ZnG4+Vmkv3pBpyffpTmnVoe?=
 =?iso-8859-1?Q?GiSXv2LVcPaPPDFHbBFXyaUayACmllFhXQdiyoyUI8AT8g5DkD1srgOln6?=
 =?iso-8859-1?Q?3Qs9FoFKSShhCB7rGFOaidtWFwPQrzYTEmPD63cjwMldxBPBePcEu2giSK?=
 =?iso-8859-1?Q?fVaiBc34NQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: DaMseHbPJoElW/as5wktHxcBrhlk/8AKvONKEv9SBfcO245dq0oynA2GcaZnjRbprxrXrNdeXeGCtK/+yMUBIJSZpAtBXEDfJKQA5QkPDgYbN7+uHRMYYXn4uBNTQsyZd0MqrEHXclLw92d3vOsmuUOLm5tb3Ws2+c+Jj1ODrSia6YbMKriG+lJRCgR9+9Gr8HySTSv2HlrRAaoGZiDrjKFxfJIpQUDES85zNEDfc4C74smc6DaqfOmOC/wE2jcLiAeIuRtBEfGnhjmxYsZ8Q83LGmFfH0QtaqCPFHoXmfBAg0IlqpDQlG4aYd+XsAL2gS6OCRnyIpxwFtiizQydnA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 859d1fb7-31cd-4d2e-c88e-08de7e6fcbdb
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4033.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 06:39:36.1145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fH74CkpH3SG6tOMzWx8AcxSI8+0xFOv2pcttkD1ju2qKOxQDoCXv30xESORXYfd3tIEvsDsOZ6IylaKsSN11/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR11MB9457
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 343C540008
X-Rspamd-Server: rspam08
X-Stat-Signature: kmgeksruyyuuy35fbhye54jzxx77f6we
X-HE-Tag: 1773124782-933539
X-HE-Meta: U2FsdGVkX1/B3g2jHy1110fDVo0wi7Si5fcfOwFLpvbQl3sa8V85aKw1VNMlLVUgji9o8MO0pdLAgUWlrzPMFG7O0d8rxNWcZBezd2qwocEN2vJ7Wr43G1bVLLFterpgKhyMXpTeJyLw+1ZFmU/axcVpoLcbo6zOFWIhAPICrQ7xHseb6yTZvnmO8qE+PfjJU1vaEPiW+lHVKhqP4mPVqb256oiBpqeugp82NiK+tvvt7g6ElTwDqp4CXTb7v29Zh3KBTXiN5rqwqytqum0fOUOH/OyKf2OpojohuCaExmdLqpd/jmZDhvaIbc/xNQ1qrZIqZeEQWVJ1BxkKXnx3Ijusm8vu6wJ2PyuMTsKbf2+j1dYpomWJrUPEZaSN0zCG/5dsLXSiuvANoW8APW2UArGHZ08Y9L3Rv2TbQiUPTEYRn82EdU0MDJQbro7xvNgvZR7+h7/CoapuZ+oDNlCmvht7D0dEJFi4v9ZEy/rvaZzmiP0+Jk7LOvq8ko/SWovOJ/OSmMRee5P+/0fThoxr3D5J8ucP5Y6CfnmJ0qvsTXSEeKtcYtSwikuBEWFMT0R1EYaQ2Z1socfndzmO6kpFP/AATVZQ6MrcIB/n04WOcFa+IQFPuu/14JVpxLiTRxHbJ2AE8uojbScGEcUqY18JJ4n2pve3H1EpIaP/G3FxBwL8oKlE4QpWw26RoBtLRFWDKxXO22gLQSzmIzkF62TEdw/97w9NJxfc2UTTXk1ivQ+IOyljVuFZbUQ6Un+MYyCRv2beawWiNt0VABBh3Xk+mwN0R81tyDEBluQe29eB6FRs7p6bIeA0rCQBBA31dPfxTS+QFQE0fUWHLc3EOIit6psHy0ZyfYYGZeaS2Y79MnK6kp8k2vdBmsYmtgo7aPI9UXmYnaQkLhrFADxRuYIjF+WsAba6zEt2+It2jDKPX4RiBK0x20Cge2Lu124DhL8Mjjjj5Fh6Zo0zxJ7guIt
 kO0q/3gn
 OLTzfzhrem+3b6q8okwQwNrd/eLmWgSFW+n4BdYA/n6udFNFSDsTt7CRXCaOkBUKPqQnwz1GVfxT/vRhilylX6Mh7GWg5MTAA3k190RkXtC+jvW+BK02VbNE7hn5YOEAeo0hPf1Iuh0NpqGeShnVWa03oQ9skhtIoq9CXBRN0cCDy5TQoZuGItgGNP+na0x585zbXzlYfi3mThQkNsAnhi//2K+uP4eK5JuI+LOF0ffIUSb9CIuSTpm+6PAiSnzc60bb9431cdXCF2YXWBHbx465Az9rAhBGqsPnouQetID7Xl92XnU2rVYbNI1AJSXQpVEbHtto7HVIkuJQTZ4ON64HFuVjDiMa2OXVpDGBR6yJSwgosZr35xRRRjKpXQBSyNyahQeRFxhP2APLyUkISc0+OtMurRvXXLzPeDXtzAUMbG2FqjtE4zvn6K2E2MtHf3pgibLGwpgspqH7MYeyGdLkgnkzia5ZeWnRMsjNt6uegaSNQZjAleIRRX+HtOR/wLckngDPTRs2LvIkzN/uW/xYDOvApPsw+9GDnka3mXRLBlX+d/WmqoUcxCMhhC+EjMuJezZFpRaX6QHW1ENGl+NfVTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 3.8% regression of vm-scalability.throughput on:


commit: 9890ecab6ad9c0d3d342469f3b619fd704b5c59a ("mm: folio_zero_user: clear pages sequentially")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      0031c06807cfa8aa51a759ff8aa09e1aa48149af]
[still regression on linux-next/master c025f6cf4209e1542ec2afebe49f42bbaf1a5c7b]

testcase: vm-scalability
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 4 sockets Intel(R) Xeon(R) Platinum 8380H CPU @ 2.90GHz (Cooper Lake) with 192G memory
parameters:

	runtime: 300s
	size: 8T
	test: anon-w-seq-mt
	cpufreq_governor: performance



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202603101342.297fb270-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260310/202603101342.297fb270-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/rootfs/runtime/size/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/debian-13-x86_64-20250902.cgz/300s/8T/lkp-cpl-4sp2/anon-w-seq-mt/vm-scalability

commit: 
  cb431accb3 ("x86/clear_page: introduce clear_pages()")
  9890ecab6a ("mm: folio_zero_user: clear pages sequentially")

cb431accb36e51b6 9890ecab6ad9c0d3d342469f3b6 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.08 ±  3%      +8.7%       0.09 ±  3%  vm-scalability.free_time
    357969            -6.6%     334511        vm-scalability.median
 1.034e+08            -3.8%   99382138        vm-scalability.throughput
    634243           -13.6%     548120 ±  6%  vm-scalability.time.involuntary_context_switches
  12706518            -6.6%   11872543        vm-scalability.time.minor_page_faults
     15142            -4.2%      14512        vm-scalability.time.system_time
     16939            +6.1%      17975        vm-scalability.time.user_time
    251227            -6.8%     234071        vm-scalability.time.voluntary_context_switches
 1.791e+10            -6.6%  1.674e+10        vm-scalability.workload
      0.30            -7.5%       0.28        turbostat.IPC
      9203            -5.5%       8693        vmstat.system.cs
      0.08            +0.0        0.08        mpstat.cpu.all.soft%
     25.14            +1.5       26.62        mpstat.cpu.all.usr%
      3.13           +18.3%       3.71        perf-stat.i.MPKI
  6.22e+10            -6.6%   5.81e+10        perf-stat.i.branch-instructions
     61.69            +9.8       71.51        perf-stat.i.cache-miss-rate%
 6.147e+08           +10.7%  6.805e+08        perf-stat.i.cache-misses
 9.904e+08            -4.7%  9.436e+08        perf-stat.i.cache-references
      9303            -5.2%       8823        perf-stat.i.context-switches
      2.17            +8.2%       2.35        perf-stat.i.cpi
    598.97            -4.6%     571.28        perf-stat.i.cpu-migrations
  1.95e+11            -6.6%  1.822e+11        perf-stat.i.instructions
      0.47            -7.2%       0.43        perf-stat.i.ipc
     43153            -6.5%      40334        perf-stat.i.minor-faults
     43153            -6.5%      40335        perf-stat.i.page-faults
      3.16           +18.5%       3.74        perf-stat.overall.MPKI
      0.02            +0.0        0.03        perf-stat.overall.branch-miss-rate%
     62.11           +10.1       72.19        perf-stat.overall.cache-miss-rate%
      2.19            +8.3%       2.37        perf-stat.overall.cpi
    692.89            -8.6%     633.07        perf-stat.overall.cycles-between-cache-misses
      0.46            -7.6%       0.42        perf-stat.overall.ipc
 6.121e+10            -6.8%  5.705e+10        perf-stat.ps.branch-instructions
 6.054e+08           +10.5%  6.689e+08        perf-stat.ps.cache-misses
 9.747e+08            -4.9%  9.266e+08        perf-stat.ps.cache-references
      9124            -5.6%       8613        perf-stat.ps.context-switches
    583.66            -4.9%     555.21        perf-stat.ps.cpu-migrations
 1.919e+11            -6.8%  1.789e+11        perf-stat.ps.instructions
     42389            -6.7%      39549        perf-stat.ps.minor-faults
     42389            -6.7%      39549        perf-stat.ps.page-faults
 5.812e+13            -6.5%  5.434e+13        perf-stat.total.instructions
     40.26           -40.3        0.00        perf-profile.calltrace.cycles-pp.clear_subpage.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
     40.76            -2.1       38.66        perf-profile.calltrace.cycles-pp.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
     42.59            -2.0       40.61        perf-profile.calltrace.cycles-pp.asm_exc_page_fault.do_access
     42.54            -2.0       40.57        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.do_access
     42.54            -2.0       40.57        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.do_access
     42.40            -2.0       40.43        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.do_access
     42.32            -2.0       40.36        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     42.23            -2.0       40.27        perf-profile.calltrace.cycles-pp.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
     41.70            -2.0       39.74        perf-profile.calltrace.cycles-pp.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.76            -0.0        0.72        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
      0.72            -0.0        0.68        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page
      0.67            -0.0        0.64        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd
      0.72            -0.0        0.69        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
      0.56            -0.0        0.54        perf-profile.calltrace.cycles-pp.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof
      0.00            +0.8        0.76 ±  2%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.folio_zero_user.vma_alloc_anon_folio_pmd.__do_huge_pmd_anonymous_page.__handle_mm_fault
     30.25            +1.2       31.46        perf-profile.calltrace.cycles-pp.do_rw_once
     40.49           -40.5        0.00        perf-profile.children.cycles-pp.clear_subpage
     42.61            -2.0       40.63        perf-profile.children.cycles-pp.asm_exc_page_fault
     42.55            -2.0       40.58        perf-profile.children.cycles-pp.exc_page_fault
     42.54            -2.0       40.57        perf-profile.children.cycles-pp.do_user_addr_fault
     42.40            -2.0       40.43        perf-profile.children.cycles-pp.handle_mm_fault
     42.33            -2.0       40.36        perf-profile.children.cycles-pp.__handle_mm_fault
     42.23            -2.0       40.27        perf-profile.children.cycles-pp.__do_huge_pmd_anonymous_page
     41.70            -2.0       39.74        perf-profile.children.cycles-pp.vma_alloc_anon_folio_pmd
     40.83            -1.9       38.92        perf-profile.children.cycles-pp.folio_zero_user
     63.93            -1.2       62.77        perf-profile.children.cycles-pp.do_access
      0.95            -0.0        0.91        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.78            -0.0        0.74        perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      0.95            -0.0        0.92        perf-profile.children.cycles-pp.alloc_pages_mpol
      0.79            -0.0        0.76        perf-profile.children.cycles-pp.get_page_from_freelist
      0.63            -0.0        0.60        perf-profile.children.cycles-pp.prep_new_page
     40.31            +2.5       42.80        perf-profile.children.cycles-pp.do_rw_once
     39.77           -39.8        0.00        perf-profile.self.cycles-pp.clear_subpage
      9.54            -0.3        9.23        perf-profile.self.cycles-pp.do_access
      0.55            -0.0        0.53        perf-profile.self.cycles-pp.prep_new_page
     38.35            +2.6       40.96        perf-profile.self.cycles-pp.do_rw_once
      0.36 ±  2%     +38.0       38.32        perf-profile.self.cycles-pp.folio_zero_user




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


