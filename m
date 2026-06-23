Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9782CCD98F0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 05:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3987B6B0088; Tue, 23 Jun 2026 01:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322776B008A; Tue, 23 Jun 2026 01:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19CB06B008C; Tue, 23 Jun 2026 01:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE3CE6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:57:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E1AA1C51B2
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:57:12 +0000 (UTC)
X-FDA: 84910119504.06.F8BA7E9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf05.hostedemail.com (Postfix) with ESMTP id D7A82100002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:57:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LKj3PJmo;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf05.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782194228;
	b=f01PXhr4G/vXUMB29Jh/pYmNEZ/vFIFYbME07X3uQWfAb3+UyWcu5HMctoYkJ2nKibjqwm
	ZLtv1tvo1CnuIbIw9+0QoKJ2Oq0F/eT5Zc7EwhyGmA8WAqollzvJA5ULlm63JHao0w6I/V
	uYmTSCdG37MeUB7MhWLlI57/9HrF0Yw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782194228;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mz2AXRrG4arAwY+RYseUNKGdgGRmUW9N6spHFjbiZ8=;
	b=okIpNBFwE/NGi3dLvcfTIS3abiRXS1KI8ASeRYdXdfOsuQQmfLzLfXh31tC11HZyhQ3ha3
	T88sh85za+SCUHZZBjvESLDf2mh408RSEdtu5DC14Yc3rTIINKiBL/iMm3tf2hxnzZ1RKb
	mFXH4TXhWd/od5Vbl8bQmXJNZKlJAvw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LKj3PJmo;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf05.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782194228; x=1813730228;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=rc/0lzZxz92Wz+qQhs+B706//1Blimav0TXnSZQtH9Q=;
  b=LKj3PJmoU7e8M1wYK6mlIWwWdl7EXp2fBLFz0YUFF6FRoZHjVl56mMiz
   G6sXuacMAg6NR7MSEUwqIBcGR78DF3xAtY5XkpoxovSFpJw3vctkpMEKx
   JNiu4qoyoJ4azUTW/IagN0R6M7NjyWckem/UXi60O8LYN15U4fRq2gB2d
   jWaAAWiBBYnoh+UXtpgxcpzH2Tf+4SY5lzFnBuDe2p6jvIzClm0m4KGpg
   FWrrOGT0KNDj/7okrbiM/tMCQo3/ya/xuKaqFkU+yVxhieRHoNtPpleJn
   AZtYKG0bWqxbI4elH2lVOWCaCXbuPUyBOtqcTCXwZrLoFz5jBd9/bU3VN
   A==;
X-CSE-ConnectionGUID: YsItkJmKRa6HLOWuU7XgPA==
X-CSE-MsgGUID: WeWlqkQQR8axLKwbTeePfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="94317291"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="94317291"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 22:57:01 -0700
X-CSE-ConnectionGUID: qcEmphcCT1+B1Ht+FTM4qw==
X-CSE-MsgGUID: SYHRGV+fRlCgInwoNs9Elw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="246510446"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 22:56:59 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 22 Jun 2026 22:56:58 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 22 Jun 2026 22:56:58 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.54)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 22 Jun 2026 22:56:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZK6088QU5+XtxwQaYC2MMqwGiTWUsZHZvEXssFAykj6ihTTDad0nOhCRAfa3+gcymaPfEa5jRSkWEjeX9jHfoenZOwDle+1dHivfa1zvvGIRLiZrLrDOhUwbdR1dp3MQwUzvzE2ADTZWiehkrYAOukESnajxB8diBraNOCSHUm831ai+kgJjtDIjHNJrOmpZV5d3NNYRycOmPNAMdjb7bweGBsIkwMtCo+R5weE9P8ThYehwgBl40BmXMKQElEQjlp5/Q6+dJVSd4rpq6+tBIyc9Mw8O3RSZ4ftoyyJlfvyXAi7+JZi/UqzGvaUJmcUK7MA5OpSXDCLbAwdD7B4LUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mz2AXRrG4arAwY+RYseUNKGdgGRmUW9N6spHFjbiZ8=;
 b=WP4zM6VZJMSPcfdJbOkKOD2vuRJ+hHcXiqKsteUjtFKsTwZbu8xsBmz9hVAchOFlc34lyeHMqLK7oIYOgPyucdywrL0P+Lcxa5KdJeFL19qtFKedSHqBGeYPJE8hj5zY/gNuI9HfZfs2qKA2OGH9Ev5iXO5LEykYxrIas/N325VKoY6dJ6nwKOqE4VEPHMZpwXBuXqZo4qPTXIfSzOD/2TARcHR1DcTwlYglURkWFhjFfgVKvOElvHgb++I7bnIO3JsQox/lcjKeTDFrV74JUWefd4L1L3+Gtd3d4FKDMqZLU/xuTJZBlPYHLwUikvjTkKj6RMfq+fyv1xVzeCVoyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by MW4PR11MB5823.namprd11.prod.outlook.com (2603:10b6:303:186::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.19; Tue, 23 Jun
 2026 05:56:48 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 05:56:47 +0000
Date: Tue, 23 Jun 2026 13:16:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <ackerleytng@google.com>, <aik@amd.com>, <andrew.jones@linux.dev>,
	<binbin.wu@linux.intel.com>, <brauner@kernel.org>,
	<chao.p.peng@linux.intel.com>, <david@kernel.org>, <jmattson@google.com>,
	<jthoughton@google.com>, <michael.roth@amd.com>, <oupton@kernel.org>,
	<pankaj.gupta@amd.com>, <qperret@google.com>, <rick.p.edgecombe@intel.com>,
	<rientjes@google.com>, <shivankg@amd.com>, <steven.price@arm.com>,
	<tabba@google.com>, <willy@infradead.org>, <wyihan@google.com>,
	<forkloop@google.com>, <pratyush@kernel.org>, <suzuki.poulose@arm.com>,
	<aneesh.kumar@kernel.org>, <liam@infradead.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
	<axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau
	<kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-coco@lists.linux.dev>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
Message-ID: <ajoWngKaZ+wfIyR+@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
 <ajjc0hw8PjGw69e9@yzhao56-desk.sh.intel.com>
 <ajnf5Z9nWZxoLS4x@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ajnf5Z9nWZxoLS4x@google.com>
X-ClientProxiedBy: TP0P295CA0043.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::18) To PH0PR11MB7472.namprd11.prod.outlook.com
 (2603:10b6:510:28c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|MW4PR11MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: d4503d11-a553-40cf-9ab7-08ded0ec365d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|18002099003|6133799003|22082099003|56012099006|4143699003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info: FCg88oh1zuHLnqk5EsZ8QtecKBsX4QRA83DPr/X5fSOmh9iidISmPLRFjXNqB+e1WCCUepDKQKCLWiPbf+q6mCSSuAXJNHk293rYAxyw0XobOdEUpxpudPbSihh+xXz3rp4NEBnDTdRFLau8XolsIKrab+rZGb1DHQV/ErIO6bUk039YS2r5EKrDtYz7zRKekrdS+zQnPfq58R6AtNBhXP6xl03mdRV3UQpujfJhbReGRS10DmMygTAyl2cF7LSu7JOshlgU7PsBj4JXC97Ifh5eomYRh9yyAGXlzsnR8M00t09hT+18fTPGow/K7sAlgh6W41iuBbPZoN4X7Nh6i5GgxWWzeYGCsFyy/FmZrHUV7Vm+ie5j/ts+3pYnGNtb1taUhk9pQuBsQqhKThuk5fGLghfK52eL3P3/0IoaVnuWwCemYUjbn6LDEWkdY7JgqwV/z+7mQHdHPGft42oZMHyiJAqVsWgCSsk37pXYADUs9CQ5aNTWf7863nSfsHAZjUrqZR/9kx/pl83GorL/Kb7WHUPqy06CALRkkFZvnABCZgL4VX54UP/u3QKN4QJS6p42vJ5dYu65pqeJAAetQmm9GCu9Y2TMsq0ytV9O2ur5Boe11kmq91NNdQGh8sfrNYSWPVB9NRnvX8JsGpiaFQiMpFLLC6hyuqIAeuFJU2w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(18002099003)(6133799003)(22082099003)(56012099006)(4143699003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dCGTagAjISviA3WzoCNvi2ouxn54hvc7WKdvgUUbJE3hrKXJYbhVNYGK/6MB?=
 =?us-ascii?Q?VjtLLqYGNPU3zpLV040LBSTmeCFgkRO11u5C3f0n6c6d5kUokLVkGDXJGQR/?=
 =?us-ascii?Q?lMFZb//aOdyBnDHk5nPIwhEYgNQeOvdDHky2gp+BooaYuPO5GXDqI+j5/d7w?=
 =?us-ascii?Q?kQCyS0j52VKUYIEQSW6/t9aIZ8LuZQYwmll7BwgisHq11rYvQGNgWzBNB+De?=
 =?us-ascii?Q?L0rJnckxhEhd9eMdGgKxKoctleAlYm2ux+5LGLe0Vkrgqq2pipAwjaKlL810?=
 =?us-ascii?Q?j5xsyIb3GuzHqSZ0MDVI1pBuT3u6H+QoRxjqJdWj3CgVuByRiTUq+ooysG1V?=
 =?us-ascii?Q?NirhySGAOaLY1jvLEWRK9pIGHtEMafyPR4MYHeTnRwo3RnxBosXGrfGwse6V?=
 =?us-ascii?Q?ZIKutYAro4EwqxhW60Jfbwt0DpvSa9AIF+SNXmqe+ao0V4gJhg4DKCrDZI+X?=
 =?us-ascii?Q?J3urEOzLlUKf0mXZQC5GP8Y9xMr67BpXuKvtilfsEiQk2OEajCR2N/k6rODt?=
 =?us-ascii?Q?44uhkMO8Z33tw9aI6pjUg+fF4Qe6KIwj1fErDB05YSrz+8+uKGamXR5sq33m?=
 =?us-ascii?Q?nEr5Sr1iwIZT+m2FoyMXo4+ey0U7mXl/17bVgS12Qg2N22Sz99HzXA9BEHGN?=
 =?us-ascii?Q?VxmGG5/8RphA8omj67/qpIa1/5ur3q9IDTk4szCh1lfQMdWG5ZLG/XiLeENN?=
 =?us-ascii?Q?v5jsa0bkU6/+TMOYd4v3cxd2ur0xUCJ9exW3mLuYxiRvjxcJ3f6HhB9iedzS?=
 =?us-ascii?Q?WTR2m28iCNr725PHifyAeZLS5PONFaySl6u2RcFmkkYP0xnG76gc3wxp1AVA?=
 =?us-ascii?Q?MD17SYGkV0WvU87uWalNlswaxCbq5QqiPfCgZeqOovC6dUC5a5q9WSRlk85b?=
 =?us-ascii?Q?QGIh+m01xcx+ur9645lNrS/PZcGATfPaLw89+TYZ9w02WdlQwM7aREiC8IQB?=
 =?us-ascii?Q?NM9B0B/pmTOYY/iSJy+bSCKkq6pIUjvtO7V11HWup4UNcHLvO33AOLztQEa5?=
 =?us-ascii?Q?6SamfOMemc82D+VOss4Xrm+tSFgAUCZBYrDuWfJIaeODKErs6/035XVXSuKt?=
 =?us-ascii?Q?yKkRtoDjXFM4BFezjGgwMS5trpg14godYqOhYbfLVhmhBevvrTr4Dz5QS2d5?=
 =?us-ascii?Q?tuCV3TzclzzxsC6+owySdDR434Af1Am28ldt0QpEjXFgkG1ztLfhtH62mGN8?=
 =?us-ascii?Q?WtZxFgZYaF5gGO+l39m1ACKQwgnO0Xy9yfxdedcyTEPXt0VFgUGbM4WsburS?=
 =?us-ascii?Q?5CQFTiOVHZgXUYAXkF/2NW4g+7tRZ3D4pSJ4HsKRrdA/p5Gd5oFpJHMikHPx?=
 =?us-ascii?Q?UHysEWxBsQ4Ix3OopHj7CYfxP+q6eHRTk6cHF+DKTouRzfmFF4CnIMB4uXWi?=
 =?us-ascii?Q?3ifVShrZnicQ7OcAwIsMqhhcNfUXcLkOqGOedozMZ08noCNUFpzzb6LHkz3T?=
 =?us-ascii?Q?VXbUbAbCIbVuwSU2alTdmHWJcwBD4rkKbN+I5Mfb4hMrvq1SptdLfdTfaiTj?=
 =?us-ascii?Q?IgpgNP/2zDnukFxc9nJkqECoCB/0nkVS+p0GR4HfGgSVKH1VYzxjjRzLmr1r?=
 =?us-ascii?Q?YM1r14i8Bc1vtBdb13nAjAqra+Ua1TzE3VCQ9QIBGngAp753Gcy7ocTUt6R3?=
 =?us-ascii?Q?I02qBo505aKjQ9sPfkcU7k1GXS5RXWVcxolre83cz4hNjQjUXpc3GA0nTNwn?=
 =?us-ascii?Q?NxMopkTtS1/YCw/p0yFDi+jovdc7qmSJlNzKqRyMkrwNA4QO54gMk3y10g8/?=
 =?us-ascii?Q?kEtrd9TjlQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: aXUXQLYo5cNt2FS/P97Yi3JTkYFtE1rGP95uLzFkyOOJzHqX2IY4BMRL2Z8HGWrc1iGQ/VvYv7Lpq7UtvWun5DMmZtwU63nGxoo5qHeSgo8JIP6KlbabdZmddcdVVRkojHytYpiUOXfBebBm3fZ0iOoyAd5SnTcvqPbUe13IrIbSfPdYUx2v4Mi5LTducZvIuZM2vIJhJX94I5pHrHwJyU8NexDmhdeskhJMBn7SLziOlg1oOovzE+yfwaGwzmIR6eoSph7ndB0HKK1cgG2el1AFHPcp81Q0Mt9nIRsVvtGsAGS9neRQpKY0/SMGGs8CFXrTMrv1Aql9xdTyt+UaMA==
X-MS-Exchange-CrossTenant-Network-Message-Id: d4503d11-a553-40cf-9ab7-08ded0ec365d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 05:56:47.7414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8858BmZHYwhGY3KmvqvZX8Vc4ObJ47P84jVYXvPUxo2FtNZ5pr7PSXPNmeLb1UBF2ofxQ60hL0Uc9RJkYfM6hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5823
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D7A82100002
X-Rspam-User: 
X-Stat-Signature: 1pap4i5nw1pgpznk4u7afn3usk5wdpej
X-HE-Tag: 1782194227-939390
X-HE-Meta: U2FsdGVkX1/Tg+ZoguqDG2yXbacz3NJnHHVL8XFVM01XExJDMboCmAXNpMRzXwDrQFy20frx3IWzxmTpjg7BRNpMIgxiEr/9Hyzd6ewz2Llop/G4Jd360xr44w+t6HKzXK++lxWRoYSw/zk7BkPN39xZFT7EE3lIfPaiGmddDqt5saCixQcSSwWrHEDSUEh4LxgwfllTUca7dv0o9lSvGLa/8AWyzT+0bIUB5kKgvmDAFLsP6/xUy2SS0L9RN07Y8CK4w+Wzc48KqkmmSys6Em9a6pREjpTbsvPln/dsMLLj59NrkQH8Gdl+T/LkWSTrKghOY+ryBtbUiYZYHvJeixn76d4XuCf8+JFZS6bWgIlXx3tW4WoEocgOMwlgvn1rO5+4pV5zDuUnB1J1uBGuujYuF6SZMouWQyY0Q9HWiXQ+AhmdOvES+FvjXXQ7qcM21Ld50EFhCpGpZrDBdyywWGEAlR9HKe61dkWlBhAzyXr2Y65YLG0Kp+mwrk75PJd6bN+1bddG41o/5qUFVqpeYJhna8KTH5ba72KJBfjLXh5B6MJmXwhDsQCmqT5zwE3pR9i78OMjZ3yG46ru2tH/1zUg5cWvtFOdhIFRTLC8Y85KYEEKpsALpkJvZ6+eofAJd3KqghXfZhxm+XbdaBcHglu6S9OPMeuEznfmlza9wfsRX8DBg/NXM0+3h7N/i4VGS58AI4t1+j/8BDTdJ3fXvn/0RW1EUhwnDUyvcl70zho/AwiSBS24jj4b0GLrJzGjABh2/kr71yOxwJrYy5QU7vUSwafQo6YF4ZfJQN020sBicUM1QPLlxjyWGnsMhrBENLwhu9+9DYkyuCboPd0qcLPorDVNDc9xVCTM7APqNtpsOpBBf5T9wW9itWVvLqgDErpGn1Ddy1wtlMkKBojdmvyZu15zsYL8RFBxPDb7zaOXpGr9WqEsEnWzQHieqDJGPpoxKVUZwtoB4Zimkon
 zqTo12Hk
 tW1Dmrmx1eOqnAGTzfClsopvFb+bM32svLCz0bKpDOnc33Hnvp4s+2OZEepNUYru+8LY3Y6qKvZPY5iMfp2YmxqMiS8JEaAewc1uRLr9VA3ICcVtl1nbk+A+iRNxXcI7dMg10qxQtBelF4FpVpMNvCHi+QjrBVJK8yMyI4yn+s7g0NvlDBwWmXNqOgoxOiEt5ARnwmjKXh8i59WbH2YbUDnjlwMW4GT9dYDrJDEDLBic9hOHiysX4QIqLXzNQOIaEMHbTrfHU/rGdAcog1w4mP/cSWMON+JFJMb4/wHQu+FxlUi922MQj5sUPxD/xVAGzJNUKS4Y8gnmLA9V7iusm6D6OID9hS1VfaswniPv+816cWbttpWCbqJXuFLn5/9RdTRw3L8jcIFuu3HxgfCEnSdcogBqrtyouNSGfrpyKCXStakPmFtgLRJAwEZgalZHtzjFkLEPJsQ7ne3/31pKNqKPpYruc7t3heh94Dh5GPRMkjtM0QLTNKJD2Ttnka7467f2yDWE8JcqmtcmNaFFQCQBknPfQziFPi8gEJDtboKTiPHovJA245V11kSi3hb/tKQMYpA9g8ySLjCqX3seor3zRjI+Bm7kQ4QKTNHSPe4esThor5Uqzqsew32njtGk0Y/ujk26sHGKEznE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 06:22:45PM -0700, Sean Christopherson wrote:
> On Mon, Jun 22, 2026, Yan Zhao wrote:
> > On Thu, Jun 18, 2026 at 05:32:00PM -0700, Ackerley Tng via B4 Relay wrote:
> > > From: Ackerley Tng <ackerleytng@google.com>
> > > 
> > > Update tdx_gmem_post_populate() to handle cases where a source page is
> > > not explicitly provided. Instead of returning -EOPNOTSUPP when src_page
> > > is NULL, default to using the page associated with the destination PFN.
> > > 
> > > This change allows for in-place memory conversion where the data is
> > > already present in the target PFN, ensuring the TDX module has a valid
> > > source page reference for the TDH.MEM.PAGE.ADD operation.
> > > 
> > > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  Documentation/virt/kvm/x86/intel-tdx.rst |  4 ++++
> > >  arch/x86/kvm/vmx/tdx.c                   | 11 ++++++++---
> > >  2 files changed, 12 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> > > index 6a222e9d09541..74357fe87f9ec 100644
> > > --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> > > +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> > > @@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
> > >  Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
> > >  provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
> > >  
> > > +If guest_memfd in-place conversion is enabled, pass NULL for @source_addr to
> > > +initialize the memory region using memory contents already populated in
> > > +guest_memfd memory.
> > > +
> > >  Note, before calling this sub command, memory attribute of the range
> > >  [gpa, gpa + nr_pages] needs to be private.  Userspace can use
> > >  KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index ffe9d0db58c59..56d10333c61a7 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -3198,8 +3198,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
> > >  		return -EIO;
> > >  
> > > -	if (!src_page)
> > > -		return -EOPNOTSUPP;
> > > +	if (!src_page) {
> > > +		if (!gmem_in_place_conversion)
> > When userspace turns on gmem_in_place_conversion while creating guest_memfd
> > without the MMAP flag, the absence of src_page should still be treated as an
> > error.
> 
> Why MMAP?
Hmm, I was showing a scenario that in-place conversion couldn't occur.
I didn't mean that with the MMAP flag, mmap() and user write must occur.

> Shouldn't this be a general "if (!src_page && !up-to-date)"?  Just
> because userspace _can_ mmap() the memory doesn't mean userspace _has_ mmap()'d
> and written memory.  And when write() lands, MMAP wouldn't be necessary to
> initialize the memory.
Do you mean using up-to-date flag as below?

if (!src_page) {
	src_page = pfn_to_page(pfn);
	if (!folio_test_uptodate(page_folio(src_page)))
		return -EOPNOTSUPP;
}

One concern is that TDX now does not much care about the up-to-date flag since
TDX doesn't rely on the flag to clear pages on conversions.
I'm not sure if the flag can be reliably checked in this case. e.g.,
now the whole folio is marked up-to-date even if only part of it is faulted by
user access.
Ensuring that the up-to-date flag works correctly with huge page support seems
to have more effort than introducing a dedicated flag for TDX.

> > Additionally, to properly enable in-place copying for the TDX initial memory
> > region, userspace must not only specify source_addr to NULL, but also follow
> > a specific sequence (where steps 1/2/3/7 are required only for in-place copy):
> > 1. create guest_memfd with MMAP flag
> > 2. mmap the guest_memfd.
> > 3. convert the initial memory range to shared.
> > 4. copy initial content to the source page.
> > 5. convert the initial memory range to private
> > 6. invoke ioctl KVM_TDX_INIT_MEM_REGION.
> > 7. do not unmap the source backend.
> > 
> > So, would it be reasonable to introduce a dedicated flag that allows userspace
> > to explicitly opt into the in-place copy functionality? e.g.,
> 
> Why?  It's userspace's responsibility to get the above right.  If userspace fails
> to provide a src_page when it doesn't want in-place copy, that's a userspace bug.
I mean if userspace specifies a NULL source_addr by mistake, it's better for
kernel to detect this mistake, similar to how it validates whether source_addr
is PAGE_ALIGNED.
Since userspace already needs to perform additional steps to enable in-place
copy, specifying a dedicated flag to indicate that the NULL source_addr is
intentional seems like a reasonable burden.

