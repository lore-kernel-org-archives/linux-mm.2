Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43759C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE746B0088; Sun, 13 Sep 2026 22:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18EC86B008C; Sun, 13 Sep 2026 22:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F8B6B0095; Sun, 13 Sep 2026 22:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAA2A6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:15:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77A071A0EBB
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:15:55 +0000 (UTC)
X-FDA: 85210752270.16.8367E4A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf19.hostedemail.com (Postfix) with ESMTP id 498BF1A0004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:15:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I6X98Bpy;
	spf=pass (imf19.hostedemail.com: domain of yu.c.chen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yu.c.chen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1789352152;
	b=wyp2E4mWK+k0pDqqm/tVnUd850i7l9dT+/gZ4S1xRWnjwJ+zvc603+WpQbYqeeh7rF9yli
	JaX93q7AamY1/px/KiRfo0pY+7PjEaV1DkA8mb9pVJg5RhH6wng2PffRXo1CuyWLT+oCeg
	JoHlGEKtkjzUmt1SxPWAdITM9DvKXGQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I6X98Bpy;
	spf=pass (imf19.hostedemail.com: domain of yu.c.chen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yu.c.chen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0ixxxGYMo3fHST95mKjEv2XfkcW8B0vh+CJT92b0bQ=;
	b=flgkscqTppVbN4N56UudNc78T1G/k0b5ujBd/Ij+YqVEkDFbg0GUUHxtuHrn40Et3sNoTx
	K3RH0CC1AF9h78dvSZgePVo0/q1Ic6ilvL+tp4XdrsiDBJB482QCoHq4AZjspuHNJGRWkv
	8kbS0ov5dJcfoMoN2z2hiQvRVm7/mwM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789352151; x=1820888151;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=q5XAd6Rehk8ZrllzstZzlYsBwl8C15+gCU4M9murk/A=;
  b=I6X98Bpy2m9IbzZ288bZdmDKhs/HZEwF6DHJ5rWwgK8GM0IhoczfiksH
   b7maD6k5pHefg46MKMDY5/L9Kc+T9p3ORVKTxPlDOoIJSSKogUbnDIKzT
   wXhfAGuZ/mDXVKDC2Du7iKXSdN9qlH2cVuaxlSOb6y58MI6P5vd+4dsFi
   AAlEphu1N2uGhpxvy/UtKF8bbRZ4lLombr+J0iv48hHHXa0CGL0z5KULt
   2I8ZOf2Hs20eOtP0xNZFcXkb8INo9+SIvidfv03Eq9JhsnHcHN1EB4NMJ
   fNcV+5pkKDjp5Ekw3L/nWZLNloXTyIEs7nFoD3FkUAq8EKltLATPO8eRt
   g==;
X-CSE-ConnectionGUID: Gs5q0MxLTeGHNQBDT90HeQ==
X-CSE-MsgGUID: stEuD4pBQjSss6Dl5EGuKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11904"; a="101059992"
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="101059992"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2026 19:15:50 -0700
X-CSE-ConnectionGUID: rBy4U8e0Rqmd5aKpu0Py7g==
X-CSE-MsgGUID: A2H3aEG7QlGNHflVwNbTEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="269881041"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2026 19:15:49 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 13 Sep 2026 19:15:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Sun, 13 Sep 2026 19:15:48 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.50) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 13 Sep 2026 19:15:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tkc42XIktgWbY9OQ3espcnn4tNq+nm3DOmqErbQVzk9pmyPrG+o9SCff7D7bTAHXFxRAoLDfjVajKoT0l2amvGMxLdEqU0y+s5InPw+ujV1FxvVrqznHIpnejEsvj6NO1kfmCfvwuQiFA1cRQO7lEVZfS4PCqBGwR5N4Kybp6d2c3oqA7rOeVNe9K6bmyWynaLthZcDWXqWueH9M9DNFVexMrFW1MxFU3EZJGkAFQQlwvkrHykt9HKqzr0ggwExVJXyJVCO7TnBezZRzhF+zg1lZsCN8y8c5inzc/x0P/LHB65WGDKa11fZjX0wbgnhHgDN7dRbwCWJ0rNo9Ggjf/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0ixxxGYMo3fHST95mKjEv2XfkcW8B0vh+CJT92b0bQ=;
 b=l8eD3H5oIq2iDVHii4luz/3j6op9DPMKLd4BE9heFO0kDOSMJrOPaAHjCZdB4ZZC76iUUlYzqHqfiVsX5RVxrh6OUSneXjcA/R0cvqxcI/YfHUGGDmbpj9t6/RHctbTL9qztbv/3wCcI1RLNScC/3N8YUvOkaDqByZBIDY6L1JCt/GcJp2pvNYaMI92Z36xn/kGDcoSR4tfVpDTps4ormoNqAhK2r68g5U7vcy4PWEVufDGFrQgEi6vAvzjCA3Aiiq8BA6zZo3UVQWgevXTF7exwRa+uqC6GDVICjn2rO+HeJw/EG8aMizdKNKL2eXaAaQpNvDWR2ToYQN/NbgoX3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 PH7PR11MB6032.namprd11.prod.outlook.com (2603:10b6:510:1d3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:15:38 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:15:38 +0000
Date: Mon, 14 Sep 2026 10:02:12 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Kayra Cizmeci <kayracizmeci@gmail.com>
CC: <tim.c.chen@linux.intel.com>, <brauner@kernel.org>, <bsegall@google.com>,
	<dietmar.eggemann@arm.com>, <imv4bel@gmail.com>, <jack@suse.cz>,
	<juri.lelli@redhat.com>, <kees@kernel.org>, <kprateek.nayak@amd.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <mgorman@suse.de>, <mingo@redhat.com>,
	<peterz@infradead.org>, <qyousef@layalina.io>,
	<ricardo.neri-calderon@linux.intel.com>, <rostedt@goodmis.org>,
	<srikar@linux.ibm.com>, <sshegde@linux.ibm.com>,
	<vincent.guittot@linaro.org>, <vineethr@linux.ibm.com>,
	<viro@zeniv.linux.org.uk>, <vschneid@redhat.com>, <wanglu.priv@gmail.com>,
	<yi1.lai@intel.com>, <zhanxusheng1024@gmail.com>, <zhanxusheng@xiaomi.com>,
	<ziqianlu@bytedance.com>, <chen.yu@linux.dev>
Subject: Re: [PATCH 1/4] sched/cache: Keep nr_pref_llc_running in the
 runnable domain
Message-ID: <aqdVpO66OfmHvvqB@chenyu-dev>
References: <f3b70dd40e29b309ff3449a95a4af4513ad0ef70.camel@linux.intel.com>
 <20260910220331.1209469-1-kayracizmeci@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260910220331.1209469-1-kayracizmeci@gmail.com>
X-ClientProxiedBy: TP0P295CA0045.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::16) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|PH7PR11MB6032:EE_
X-MS-Office365-Filtering-Correlation-Id: e45d6d69-0e01-47ab-75d3-08df1206114f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|4143699003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: IDnM9ym4xfLpy1uH1vWb/eBjZIaTeOi31X/D7YbLv6pVW/1kAIW32ieIFOpIWpXOA0XAJuEJp8sCQjxlnf7qFh+LHRJCzmP9glpu+rd54j2bXJ2bVYtOWwW3mYSMYMNzrtSrIatVFPnpGrLqJkmJ1zGinvjbYNjDYaaOQMYZxoPYbbySKguWyvZmXwkU+cDe+Hmz/B6tcg8R8XoHqMgffROs6a1qkg80vYpcYSibn8kKcXQ8vQDON3LJ7HKXMidPVFq3jy57Haj9vrnzig43zn0ALVRdhHS+kFUvRSJ3k5krX3PG8jCP1kXtbvVujq72a2GaMsyAFJGwVEKgH04vbarFbiY5n+7Vf67NQav3iDnjWBKT/ootstAl8P/aFE7F7AXODY5CLFQMjIS7opGRKR42u5wV0YQGnUJS5nlhx4lMZU3iJA9+767AhUANjHM9Ec+hnULa9hgO4mQrF/V1Ewp9DrWVlmDP3FsLvAyH7R7DXIpy/S/kncBk8KQ0dAaRS2frVCNYAYlHVelFMAd+FSBdBk+oTIZdDt3eKm2LcZEHDD/7jGYo3+Kyr0nSFCYyidmKuQidRK7sIZC3gVGr0IKFCvDEWyRfsKi+TfHKdGunkavC+JF8ZTdVh5bJpMZUlS4yklbx4+Bk2Hkm2Gz6j1DINSASE8MH7xdCvRXn818=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8M978x7aUWsB5UmzhE3chcLtHDcW8lvcfDND9xsn485znMLeamQAI7Cf4Vmy?=
 =?us-ascii?Q?T5k6uwgAlTP1XEaOneBnqSxMmcMW+kbxyiP0Csq4AjputSuDxP3zTa/xHQ6i?=
 =?us-ascii?Q?Jb3JQoHdKHmEwQRw8ByLllG2uJYcG1mtxLOzQ6rQSNDl2n9egDGd4va0UTme?=
 =?us-ascii?Q?J5XRkpEmEKQ0N464AEQSkwrLmV3rSFmP1pEMZLu7TwAhTne5jV0LVRMV2kvS?=
 =?us-ascii?Q?+fu3OKWEbn9/sbG1SFTvwgeIjPPkfIzZmKOoGPy6+3O979T1PyKm+0HVvDg7?=
 =?us-ascii?Q?75OnZP4PZtg9lOyTMAe0rpHvmwUODwv+63RH2ZAWN+XoBGI6e3/Vp0cEBoQq?=
 =?us-ascii?Q?QeHVdiOOWwwq8/Px9kPYkcmFvwF4EEykADeFBsBLKjpCtQAxDmmEuxyIKPrk?=
 =?us-ascii?Q?/tINRDuALBI1SHt6/O7/Xa4x4bG1vIx8wPB/gxEPjx2nWUs77GiotNcqtBqD?=
 =?us-ascii?Q?g395IsbDEtR7rGsATv0o3XY9d1eHl3gbIFSXZ2PSk4Krm2z+UqUTM28UjjNq?=
 =?us-ascii?Q?XU+FY9f5e7jC1dOIKHnKlEi6rvaUu793Xjb3KYfgr8FoNKdf9SFIl7M+nd/J?=
 =?us-ascii?Q?9tUXo0fRLkZtxVDcIsIW+IRQ9slGGkw6bdFE+JjBl2yWXmY8vWrLjWt+PsqO?=
 =?us-ascii?Q?34oQXAEOL9MYBer2BU4IgDW+2TiG1I9mwg/K2Hzut00uq17DhIWm+WDAV5hH?=
 =?us-ascii?Q?6rCrv1okjiM3ZFSzSElepMu6awXTnInZBkpampPO5T7vHNny2YaWNtatYCte?=
 =?us-ascii?Q?mHRssCPWuwLmwwtc2nLt1Q0P0fmKTn17j21RricKOEXuc9ezsbaam6NuDhGG?=
 =?us-ascii?Q?lmBSGswoqB04evt62yG85P9FV6bzxlK917ek6hH1vkXy/aYoRnaOjXUaDc9r?=
 =?us-ascii?Q?lR/rIHSHcjoj6DKHEj4TAtMkZp045jw1dQ+ABJWvbDf2LR5B8ceRL4KC2ipw?=
 =?us-ascii?Q?SgseAhCaT65d2piarY9LgkAFGZNBs9a48oDr4amN7JDvEUNFxXu7OlHid6WX?=
 =?us-ascii?Q?JiuoSgZexlQh2Wxvw+5pS613TEG7kITp0qUPNTH+7Dh06QVpE4G0QRbchezr?=
 =?us-ascii?Q?wuGbGJ6bZdRb5xAtlZklHEWA1EJrbY3CS+Skdhe0VuGs/fEx5ari+1tEcj9I?=
 =?us-ascii?Q?0rXhoAkN2ddQ6p3V9+MNKMQOyfzXSwGQMH14uopWY+HvvEAt5i0vDZqpUS0Z?=
 =?us-ascii?Q?gl7ZNhOkmLjmoGNnYiy+brnLMoFsbnTmklk0p9osJsQLcv5TUmPT/gqArAGi?=
 =?us-ascii?Q?Y7s8rG/6nj+kIBPUdZ0uKu8KFBM1tIoqob4SvniddyCW+dQ8RzxA/E2jpg1I?=
 =?us-ascii?Q?7utP8OR3kvrBe5NQ5IKAc1qjWb7Q5ZtblxclfmBoA7Y83zLTvos4MKWk6F5N?=
 =?us-ascii?Q?L287aKX8gJdrYhZ8HNayHufQEEBLbfFnrm9p+yVzD0aTnqmjif/JSz/ZBrf8?=
 =?us-ascii?Q?oGAhsY6BA0Qjonupk78/BY/G0p8h5ur4Hlfh/pb0B+lRzXSE2Vwp4VhHXBaO?=
 =?us-ascii?Q?P9dFnlJqjgiNSevZ5BO2CCsNNfEqMkSDpuoslreuoGVNhyWwcN85EGEJRcO2?=
 =?us-ascii?Q?h0dje5v+RKOoutJ4rSrwnuwIW+3tDCuaO14aIbfC7wTXMYfopBBS+hmKK5IW?=
 =?us-ascii?Q?fc+G8Qjx5Vk4JgZT33JP0+Hov/vH1hktulAaG3Tn7Ev3U7Q7DeHARJhvhV+Y?=
 =?us-ascii?Q?2A/2TZ8ytyPTJh8rINbYS+sv1X/3vhP6dk+yHrq3N5VzcbnZtPYlGsOYL7po?=
 =?us-ascii?Q?zEMXAmFOEw=3D=3D?=
X-Exchange-RoutingPolicyChecked: qa7+al3OJq96+J4uz7ecv2iKCNmEeIsdSXVoiTWNDqeC45w6U9R24ezE09tNh/0cMMiBF/trRK/ELw0edU8fpPg1Das579BdePB9xShIJKy4PVeDRdWZxDy5JV6SnDketDb0AiCcoucanlOCTa1Huencrwqyyt2aXyBviLDTaBGMSu+Noi3KbXjNl+brmWwl3PKswfsNb5XedQJQF8vY4ShUwTP7mtZb+GFq+Qt8KNydVjM1ptOOS5faK/woRNOMC4MSrXAydz26AYQlgIRHBbzQt5aAqdiYnTx7HA7s2r161t8VZ+UOWTcN+yXxeEYszOVkTCRq8tTYFYuqUgFH7A==
X-MS-Exchange-CrossTenant-Network-Message-Id: e45d6d69-0e01-47ab-75d3-08df1206114f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:15:38.2592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96jqXR9ABz5gaYS7FPwPyljfh1Sh2mhdn1vsB52b5Pw+5HVbIL9JGjTqCINXz5OLebKCEk9Z9wLmWsuNRcdPow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6032
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 498BF1A0004
X-Stat-Signature: diw69kj1rucnq3aismnyh556eszpu5hx
X-HE-Tag: 1789352151-595559
X-HE-Meta: U2FsdGVkX1+zA431dSvlqxcYd73qfIlWnV+lI2JTfr5aEo7z6AMDgBFHDx/xkxTJJmpI9vk9YA5GQNQ9uFmwJgDjICVx0fNsPQDYzy1rGNTDglMurAJWmOaowUM9Sj4VYEgoy3jKY69Pvl0Difz2NONPQuFctttuuMhfKrP6XEHTM/ds+YSFgFptM2Uxw0/j9b/wT0Tsta+36f7CQLZOymW9jE12hIdH0lRmcFXGbtmkRsnLacM+chRsOTJS/v9C7sLzpt7/iGZ861EZBN7T3mIycy4JPYk8Ecf3yYmqqId60gVaIdIPbyAXHnSC9En6jwb8FPghzxVBMQ4nwKVlh3jNVisCi9GVskqwz1t9Y8J3tkFiJhybcfX6nqgZ2r96gPrl0TgFtfjRj+HoI6Av0KtMtoePS4sF2Zwi3CPEreJo0ldEpcRA6yGoE0LZFMlSMrxg6UOuTRxWCe47RNP3Yqf+Xg39QRVtNTs5CTP0GbI9MnetxnfMfx9rkKKNScnA/hQxgcWCR+PALsuHOCjqWo1DaQ+XkmP8wdg4bXZ373Iari3rR+vk1p6KAmfOlG3GG2ju6e+3StD7jjVbJwV7ML1rkrrvAads8qiE81Y2BJJFBHl0LKGgOw2ZDxO9lD2RkYxhu16Tt07H4iOXIBKRzz665Di9PERMUmlCD+9X8bmTMGz9rbHFIGGPxImfjPAc+6rerrzNyx0sDnd88U9qTjfQu91QlB2ra2FWlsdgo0gpeXFAtg12xVJyDk6ElahgB1Eor/5aMG2fAfj0CEjC6+DeNDtZIckRgx8WB1kQAes/mBm2INg0Z6UKMLiPo9Z5zEZg4ulLcnDv4B7FQDYWwWhdbze+Dud0/D16MkQQuFqTCagzGJopLp1/sPojI0aJ2YDV81Fibo5Nf0xxwIX6rOzqycwcaCpywiTBZ58Kr2tK3wkkhum66AoUj5PZ0+DBR9PpKo04BUDkkRn+V8o
 DrFnQ0wu
 5D+7n4GqZFVqLxq9JfRIAtLgHOoR1fP/LHUaE7WBBRd9UgxmD/zlaKqIk2sQx6k2GzIbHcCD02JH3G7UbqRjN0ShgmMD4rsgZdvtBk9o0abg/xpRPqDP6eryIWldIy1CnWbzx6c28LaUbWg/bi6nqqyUU6yt6XTKm7g7Jn7U0EwGLrspO9c2VE5C7yLCI7EQpCN22ObyOo0PFkDrrRlpkjWTk3qdtrA3BZeiXorF/iEsK/GAOSV8RjR70YlBJ8dB2JCpDiZnQLUvEZ8wUhei+fvEDjRH+xkmA1BycZccSQKmyduCxHqBWevqs1Jhw/qtDBQUkqUFM8eR5kFX9rEmCsaOlOI60KUgXOXxNHLQ8XH7lnMFt7Nm/HniDzosE+qhMNm8VmngHa9vup7OQkDrr5iXzMUT1bnRrzveu6VsLTUtRWuaJCK4JXsLafXhCtr6oJDrPM7dcNqKjbMwpJj/yCXvDP+bxsjnt8OoGnDTxpk9JcOh+U7xR4lI3AcGUETa5wAx1EYZT6IiyhZwUi27QchNUfrakFS+ZZBiOH8UBpD+izyDe3jxVQgH/LFRHNaY1Cktk8pm9tJ1q8neyIBAHupMrhMdvN0r/a4mU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kayra,

On Fri, Sep 11, 2026 at 01:03:30AM +0300, Kayra Cizmeci wrote:
> Hello Tim,
> 
> > So moving the accounting next to (or after) the h_nr_runnable update
> > would make task_pref_llc_runnable() return false and skip the
> > decrement, leaving nr_pref_llc_running too high.
> 
> What I really wanted wasn't getting the accounting next to or after the h_nr_runnable. 
> If we are updating h_nr_runnable in some way that means we don't need
> its check since it's already getting updated. And if it's getting updated
> that means on that branch we know how our check should behave since we 
> are a subset of it. We can skip the delayed check on that way since we are
> trying to behave as h_nr_runnable's subset.
> 
> >        if (entity_is_task(se))
> >                pref_llc_running_dec(...);      /* sched_delayed still 0 */
> >        se->sched_delayed = 1;
> >        ...
> >        for_each_sched_entity(se)
> >                cfs_rq->h_nr_runnable--;        /* sched_delayed already 1 */
> 
> For example:
> 
> In this code the h_nr_runnable is updated the same way regarding what is sched_delayed.
> That means if we want to behave as a subset of it, we don't need the check delayed,
> since we check the delayed to be a subset but if h_nr_runnable is decreasing/increasing
> we should look into our checks.
>

I had a try according to your suggestion. It seems that the code becomes more complex
and brings more headache :-( due to several corner cases. The current version is a simpler
version with less code IMO. But I agree it looks a little hard to catch up with, so I added
some comments around account_llc_dequeue() and adjusted the code sequence of clear_delayed()
to make it easier to understand. Tim, could you please help check if this makes sense?

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e64d9ad7a108..89311bbadfac 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1609,8 +1609,58 @@ static void account_llc_dequeue(struct rq *rq, struct task_struct *p)
 	if (p->pref_llc_queued) {
 		/*
 		 * Skipped if still delayed (set_delayed() already removed it);
-		 * clearing pref_llc_queued below also stops clear_delayed()
-		 * from re-adding it.
+		 *
+		 * The nr_pref_llc_running varies with h_nr_runnable, it involves
+		 * set_delayed(), clear_delayed(), account_llc_enqueued() and account_llc_dequeue().
+		 * The following shows two typical cases of how nr_pref_llc_running is maintained
+		 * during enqueue/dequeue.
+		 *
+		 * case 1 - wakeup a delayed task
+		 *
+		 * CPU0                                       CPU1
+		 * __dequeue_task [fake dequeue]
+		 *   set_delayed
+		 *     rq0->nr_pref_llc_running--
+		 *     p->se.sched_delayed = 1
+		 *
+		 *                                     try_to_wake_up(p)
+		 *                                       enqueue_task_fair
+		 *                                         requeue_delayed_entity
+		 *                                           clear_delayed
+		 *                                             rq0->nr_pref_llc_running++
+		 *
+		 *
+		 * case 2 - LB for delayed task
+		 *
+		 * CPU0                                       CPU1
+		 * __dequeue_task [fake dequeue]
+		 *   set_delayed
+		 *     rq0->nr_pref_llc_running--
+		 *     p->se.sched_delayed = 1
+		 *
+		 *
+		 *                                     --------- load balance ---------
+		 *                                     detach_task(p, rq0, migrate_load)
+		 *                                       account_llc_dequeue
+		 *                                         ** DO-NOT-DECREASE **
+		 *                                         rq0->nr_pref_llc_running
+		 *
+		 *                                     attach_task(p, rq1)
+		 *                                       account_llc_enqueue
+		 *                                         ** DO-NOT-INCREASE **
+		 *                                         rq1->nr_pref_llc_running
+		 *
+		 *                                     pick_eevdf
+		 *                                       __dequeue_task  [real dequeue]
+		 *                                         account_llc_dequeue(DEQUEUE_DELAYED)
+		 *                                           ** DO-NOT-DECREASE **
+		 *                                           rq1->nr_pref_llc_running
+		 *                                           p->pref_llc_queued = 0;
+		 *
+		 *                                         clear_delayed
+		 *                                           p->se.sched_delayed = 0;
+		 *                                           ** DO-NOT-INCREASE as pref_llc_queued=0 **
+		 *                                           rq1->nr_pref_llc_running
 		 */
 		pref_llc_running_dec(rq, p);
 		/*
@@ -6415,23 +6465,18 @@ static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void set_delayed(struct sched_entity *se)
 {
-	/*
-	 * Drop a task leaving the runnable set. Must run before sched_delayed
-	 * is set, or task_pref_llc_runnable() would already exclude it;
-	 * clear_delayed() mirrors this after clearing the flag.
-	 */
-	if (entity_is_task(se))
-		pref_llc_running_dec(rq_of(cfs_rq_of(se)), task_of(se));
-
-	se->sched_delayed = 1;
-
 	/*
 	 * Delayed se of cfs_rq have no tasks queued on them.
 	 * Do not adjust h_nr_runnable since __dequeue_task()
 	 * will account it for blocked tasks.
 	 */
-	if (!entity_is_task(se))
+	if (!entity_is_task(se)) {
+		se->sched_delayed = 1;
 		return;
+	}
+
+	pref_llc_running_dec(rq_of(cfs_rq_of(se)), task_of(se));
+	se->sched_delayed = 1;
 
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-- 
2.43.0


