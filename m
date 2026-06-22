Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29AB5CDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 07:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB49A6B008C; Mon, 22 Jun 2026 03:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64EE6B0092; Mon, 22 Jun 2026 03:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05E66B0093; Mon, 22 Jun 2026 03:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0676B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:58:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1DDF11C2BF8
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:58:55 +0000 (UTC)
X-FDA: 84906797430.02.4F50888
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf22.hostedemail.com (Postfix) with ESMTP id B7922C0003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:58:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dJ5sQ4Pu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782115131;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhKY9etCnJA3/I2fuAp43H9m2wzKW+K9NNHAD2KkssM=;
	b=wGkdC8PZ7Nz5BhYG1e4Tr+Bw0p54e+90RZzjS62pbEpV84qgMyl6Uniyi90sgXVHU38nFA
	BGPyRXEg9VPTHcIvFi4DqbMQbQMh/Eho1txUPhXCxzBc3864kjJfS3OPUTVJ846svMSS0u
	OfAugyUrvA9xMx6VDCY0HHBImElwrrc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dJ5sQ4Pu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782115131;
	b=CuWeRnwxuXvqhsoyRWUW+RdX2FcdnCvwIFIGEuY33Bug9zso/x5gmvex9fAjsK7UKUl8b4
	fnfoepA4k9PLNhi56v7baBdSxb6wqtlCxTZZ4DqkwOvIyHflBS3fstw5BvIciPVmgED8dN
	AFWluw7rMqFV+wNXK6heMUzRbv6IHaA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782115131; x=1813651131;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=lhKY9etCnJA3/I2fuAp43H9m2wzKW+K9NNHAD2KkssM=;
  b=dJ5sQ4PuAU7b7nlCVpJXvofiZpLgaXVrSkiWUzq+jORsQoVTL+d4yk3P
   jHpU5TdHHVYPHRujsXiVBaOKSaScbNa9TF7aKWLLg5wos8G4hn1vLWGeN
   gp4KG4cBoEBJdL+a7zTC7mspdz/PVb66D9Gtz7idMH7tI+Iic0ac0ebAI
   3RtkjUB65vWhrsS0m9X5wBV+ZiNX26HX/wQ8Y/p9vMIIa2mflcaE9nUEn
   3gHC3kiU2pp+0ZLJNoxK7Ib4eHjTX9JZ7vr1Ep/aqM5hvxoaNZsdjn5mN
   wD8FG3GvtqGO17PX2MRCapGXORhrSe6CGbBWqFUL0IOvW+D0WVWS73kdQ
   Q==;
X-CSE-ConnectionGUID: +F8S5bo8T+O0wEfG0T3QhQ==
X-CSE-MsgGUID: k4MSjIotQF+g3WmJf+DOcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11824"; a="93204495"
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="93204495"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 00:58:49 -0700
X-CSE-ConnectionGUID: nLS4n/G5SK2QIWgxpZ3mHw==
X-CSE-MsgGUID: 8nwwG6u8QTeqM2BiLUN3ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="245010789"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 00:58:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 22 Jun 2026 00:58:47 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 22 Jun 2026 00:58:47 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 22 Jun 2026 00:58:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZMpvMV/cGySFaEA+hJDKcpi+EBW7bk6UJoPHjhcEPHhu+fKeWyvo30rMfwPtVbt7hkaclUPgGuT6WCBL3wurYY/E3dfEelxGJsSCwNKdWVdU3QsOd/whOJeNZeEVQZCAZVqBEhJhd1oJ+WcE08uIKLp561UbbhGdCLb0ufsx7o1i380TNgxq5UHDPELYsmqK2FyC5lNnL2wRovf1mehyMWaT6WLQYIPnVJRdxunShjzShSA/Y2tbClMSnwSM0CaKGvdjOJJ3Y6B4ctdDBEmca8avCnz+bImXFS9cdhOn7vjwCHEJap0sYBFMiCjrcgXHP6xNvC+PiFmThtZZsM8QlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhKY9etCnJA3/I2fuAp43H9m2wzKW+K9NNHAD2KkssM=;
 b=yyVvud6/meHfXL51v6y/jJbeuYYep7zxgf0Hcj4eHceyy+B+T2v6bOgeIGhiIdjb/4Kdp20stehEOLIs54M2DMZIu7RxTfMQmvPzXxHNkksvG1BphmIzjFq00PwHk0T0vlgy/lXzq7oC3HcCgQ1WcmEie4Ts4fDv2nnP3YpPppmyiRf8aWP0/kodjLnwOlYwQZ9KbpuFiU+eg52pfgLiqsS6cWHXtCrLJWxEV1qxaZ58k0KP3FqbL6qHC1eK1NrZpxzd60sxzPU2p8x/I1h87SxZpRk1jvNJALWIl2HKwRu/9I/Y7O/1UA7eU/dCg5TGSnqAYrCLuiv4EZEukCkCKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by MW4PR11MB6839.namprd11.prod.outlook.com (2603:10b6:303:220::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Mon, 22 Jun
 2026 07:58:43 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.21.0139.018; Mon, 22 Jun 2026
 07:58:42 +0000
Date: Mon, 22 Jun 2026 15:18:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Fuad Tabba <tabba@google.com>
CC: <ackerleytng@google.com>, <aik@amd.com>, <andrew.jones@linux.dev>,
	<binbin.wu@linux.intel.com>, <brauner@kernel.org>,
	<chao.p.peng@linux.intel.com>, <david@kernel.org>, <jmattson@google.com>,
	<jthoughton@google.com>, <michael.roth@amd.com>, <oupton@kernel.org>,
	<pankaj.gupta@amd.com>, <qperret@google.com>, <rick.p.edgecombe@intel.com>,
	<rientjes@google.com>, <shivankg@amd.com>, <steven.price@arm.com>,
	<willy@infradead.org>, <wyihan@google.com>, <forkloop@google.com>,
	<pratyush@kernel.org>, <suzuki.poulose@arm.com>, <aneesh.kumar@kernel.org>,
	<liam@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
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
Message-ID: <ajjhs+bEfgpS4mFR@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
 <CA+EHjTyj-JdW8H0ii2j3dayqnT2s3VV+brSG++p335=FGd2GXg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+EHjTyj-JdW8H0ii2j3dayqnT2s3VV+brSG++p335=FGd2GXg@mail.gmail.com>
X-ClientProxiedBy: TP0P295CA0031.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::12) To PH0PR11MB7472.namprd11.prod.outlook.com
 (2603:10b6:510:28c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|MW4PR11MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: ffcd5c92-c136-479f-04bd-08ded034142e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|11063799006|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 1B+OdNLW8d1PlCMImIWyD1dEfBRPHN1f5uQ+Id+V3PzENni3Iv/3XUX+3yt5lAQvIuJhHFsf86rlbDoPqE8q9NoeFI0D4F44GnBcHZHDNj6GIKhbBnLhnN8EBLPCV5n3S/EB2712zwsO4aPKPwtR1U16FwZVTDuJm49+aJLSNd9M3uTPem/O9uPm+ne1xPGWRH15S0/C+gU9o7Su21lGOcmKGz2nGlgy4QiI55ki/PbV9u4Z6iFladLjG3d03BFWpzVm1m0aWEjyjIm0eYpI7RJgDB2L3SNS/wdjOA9vSnnk/79ki9e7FOlqUFWbaga4e/v7B1oDBLEKESf3p3DYXJYfu5FbF96rBzHx5bqu869CBVj3kxNgr4QX99bbEQAirXAmyen1t6qLb2D2cMreAN+MX9SZk4C/vW4am6t0lhtz9u/kc7XHIgQMAf3sXZwCm+PqGTErronPS0EkhpLooTd6codFtqn5Ll2UpRD2WvucyW73D3oeILzpI4Md0wODONwiEIV4oQ+pZ64m/1YCYTbzTi70LpxSq4YBpp9/n6HKNm4UIfL9ZxJkyxbDUyQlMdqY8pRfwbagvsynKvw2ZR5AVLBdIBV9K1SFu2/BYVMpwtMrlDTfDMK0WxakLpOl8stPWTMjXb/L5mswrk9X7bh9BABmdN0VwHRNBXCXX4E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mHBT0zwvvFAdvsOWMC/xsWojo9y8SyNMYv+RDoyiD9IqwvnYEIT73vuvoqNH?=
 =?us-ascii?Q?y04SYVtK8r9+ykBZ+pn0MAO9ceuT118icSapSOXx5UtdE1OIWzILSL+A3p6W?=
 =?us-ascii?Q?hyU4YNnQk7AvyRP9A1qLbud63I8UYrKmgMSRtBDyVm1W6QXd6W/UuTqAjLa7?=
 =?us-ascii?Q?21hdkpOdAx0ntbHzRfTzrjqXUSDzqNghw78YtGe1pZ8lfbKL/D9BXCJwwW8c?=
 =?us-ascii?Q?oduWG4QW69hPaf3cVOelmdO3YbfypIccurwhLo/um9xEkQ0BE11s3AxMuN8t?=
 =?us-ascii?Q?9A+1pVHa3YC7707bhtyfpqJVDnp5HC7tWXqQV2uKF+JzWlbcdTWvjnHEWOLO?=
 =?us-ascii?Q?mnpxkgU4U55zsenxWGFLbgQDtzX0601oz7lL/a02xetuYyIGtI/ISIzbL89H?=
 =?us-ascii?Q?t+3VjY4Ym8xjYdthk5zuwYY9ItWopV6loweML/qcOrkK2oRXxcBEERlfjCBx?=
 =?us-ascii?Q?/3kcqik6R781A5n6vEW8oBBiEJ7wHGy3XW/092CM1/C82bRP1WNoBOcoMIUi?=
 =?us-ascii?Q?QbZQT0xtIRHcEVYTi4ltBi5i/6t38BkhjViyV/zQWaHGB4OALaiZXKXWGrnQ?=
 =?us-ascii?Q?b7bTdtnTqYW7GTn1POJB6NAPIcAwbvTMGD+tf6eKZ7ylS+IwTvWuv/sfh2on?=
 =?us-ascii?Q?DLCm5i5YAs+za51DSfbknIj4cJCUO0bl18ECS23qPxzzGmSiVLPNqrCo8JXP?=
 =?us-ascii?Q?c7uvy3JkTfuss2S7qr2yCl555dSzmf/2oVk+rnbeYd70tLuUJ8nTGH8ub9wU?=
 =?us-ascii?Q?UmWhH4GFyk2w6cpH1WAZAowzCGyXfWYBYscMHNFa+MA57HDahVrNTiviLCwU?=
 =?us-ascii?Q?KvCpV6hAZvYPspsUDt4KTBAesbY2z1gWEKVe9Lv4ZXtmGKgOrhOU3NNI06VR?=
 =?us-ascii?Q?tD1AVm70jU1WJOH842GEojqbxYN1gpEfDO4sugKTKJ2oMWbwdNSPzO6sIxmY?=
 =?us-ascii?Q?O8e2mjv6Pa3lrf1aZ+qcIiEjCPyLGE8qH08d9ZQxgRtWdtLARofs/zQiNQue?=
 =?us-ascii?Q?pGzc3kFUtWuvoGYAEthZQRR91PjTHkkplFi9RGTCykXEqDa2OMBWw6XoeQPO?=
 =?us-ascii?Q?HEvTcPBpikCVRlncQFaUIu3OF7W/xbA1dZjL1ixr6ubUPsUeyC9iW1Aqz+il?=
 =?us-ascii?Q?/bvV+doEka7BgEXPkzRtiv33rbvTFK4oDivhwbQ+ymE0ofdKgExGqEU4CvA0?=
 =?us-ascii?Q?ABMxKpEE7AdFe49St2GACXai7DEVH5y3eO9S3fllBrXBMLecxRGeB+2sTu8P?=
 =?us-ascii?Q?l0nT3acMCo5d2RehHCDjDowumNKGdX3/pmkpIIDZF0grVUvCbC2XK0TL5eop?=
 =?us-ascii?Q?7QEEBCdHHIskBoqjkrV2F9/5p7yZGRiVX7Z5D0RR5c4+Qbub4GPE1BZ9gnQq?=
 =?us-ascii?Q?I24gnvvrASVxQ2U4OPYI3DJxHEGN6zDXdIAWyBKpQNOX3ukSLS5Se+e++g0I?=
 =?us-ascii?Q?VpAErmnQU7MaXO+BqP78nWugaySwDnnMmAPSXrSEEeomottcVgOktlAzTo8K?=
 =?us-ascii?Q?W8u7Yl9f7Y2LV43GCwnnxWIwNLNRiyrV9IJU3IW6ZcPSw1WogRhf+X2u7lZg?=
 =?us-ascii?Q?cjuPkWVw3WdUs+5v7Q/65xhxmnIcG0PK8lK4bG3IXcpzy15pMNhxXdfNdweY?=
 =?us-ascii?Q?cwtX8X70aofV6t9l/0tw6i5MyrmEsRKQoLBklE/ZoO7Ps8Axi+spQH1NjhmW?=
 =?us-ascii?Q?kIZHQRYNiDz8lzYc6xXmoTgWGdcXv/gvef+v3DMHBkCaIJUm/GZnbDuF3kC4?=
 =?us-ascii?Q?zUs4gT9+7A=3D=3D?=
X-Exchange-RoutingPolicyChecked: kaxwNY6zpcD170oQbPSfM2tyKl+1UY+zcWS7d1LpfmKz635osuzH7+o1yYKRCt6lZ2WHuUT8eWrF/FI886r0QRm3XzOJhw4IE/XcVZKFA/KjRrW7bvz9c0MNA4n4MVh39yM+z0jZ7oJ9yxJ7uX4dRYZ5GI7MJVHL7n6yGoSWJn4Ntv862Wrls/RXFfhAXbzZb2Hwnc5PDRuXZ+6LCz3DcTsqe2mkhxxKp5hhfxjQsdlf1iDKWKTx2qlbvTA4ohmLitIoCw5/Br3ftPWatw7fAGorjeOCh6QtdElAzEGjM0DSod11YqBWH0EAPWioukDf3M/GYcy34/xKt0mPLaZJoA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ffcd5c92-c136-479f-04bd-08ded034142e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 07:58:42.9480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xvTTRoNLofmSxhWG3Klz4SfVuj7SC8EDos1vF2wzHt/wFIkYEiDc/OosRqO4MZiGNeeQ6My1vMmbGFlNk9D3MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6839
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: 7y9im8thsp5bj7ho3sz1shgxxjsdzyxi
X-Rspamd-Queue-Id: B7922C0003
X-Rspamd-Server: rspam11
X-HE-Tag: 1782115130-16550
X-HE-Meta: U2FsdGVkX1+75wmcAWiBbXYow41YQQz0HubIoDQwjEUwNlbtWOAKaP+MQtiMgh3/2/iQx27PTbbaVtpppqn3yePRdIzMoKk5Q8Cx1/EcQsmysmi328+/Dh23nMjT9dZi39ZL/1ubAYgUtTrgz+8URHuVBovKfw4nmWRsPQ1eWNsTqRFE7BeP00SAeBCiWdjuRd0LcYF8YVpZQIvKna2JMmUfAtiY+pfhMy2/dzmLMrhF0ILZsEYJJdevmO8RmyELdfCbQf59dA9drM7EE9zuFCUfkPEe50G+uCLdom/nSOx7Y23vNHyUzqK6kzVA7zvDfC1lGOOCdy5TRcuk9NX3xGaJNCNbXwr30v9YuVYUq63JHfxb+r+TcpQXC0RhD/PFEQboAqEJaQJy31LqbXd1ig26aiB7g/1qhJI46aKxa4wr+5vfF0Z+qZqfvjgre5pkbQuymq4JK0BYq9nMsmcy+5oIjIILorwLQBEsh3wFykC3e/weZ07rh+KZhgyMkwP+weKGJAXLM63gffND+SoQp1NEEUXkBs+DIj7T4I8x+3cUsWscGleL7ZRaLB9q1zyQpEkydHbgru388+u1ZPQfH7b7rOEgIOmqNbBiWAlqRwxx4xDhgnBr96A0uayURD5p89IDyhaSM5FslkbehBv3a1BuRVY8kcXx7uX+njei0g9W2TOGF8x2oTP2JfH1blIcDv7uJN9+k67yqHavMzI1zIGF7+zqaJ1EvUPrr928NB0TmPoWu+jh408YXrgIAql7Ox+eD2etq5JwQdl2i2/PWndNLq21r/y3ELLyWI4yvsB1SZwaAKcQ4Yg2qSuF+JNfEZaHwqN9c9LaVwssGhXZhEjfJqTcxnzw47ldYfPg71uoEy8a34bJZ0LthC+adZWcgmHQOuj5GsXtbWDiAuEmvMybQXfGxyX5PSzYeDry//QK5r70Vn7Z9W/duQf1b4Z23Da6xZ7tcf5rcrYPQ0q
 toCUJHNk
 KSPjN5TkTbT/FoA6j2Rl6Y93PyTb4wCI3qPu3wdJdycLU5p4WDsIfBuTcYDSVb4qMlitDdD3oAmdB+bWLSV61aKJgOjgsFGeDQTZPxQb/vUZau1RhUz1D1oGIhWhmDjdIput4Lbzw3MEiDxgGJrofwiaZy7Rhlt+9hKzNNogDVe2Wb5gyFyC6AKv0vr2xbBeGvoy6muKM6jH9Xfp4GH77k4Q+UYpyDQU5JIZLJG1IRDnYFQXR6onbzeTq2YP+ijUSn0XBWJGAbLOEOn37i5GuWLLldOh26AfYmIkEYPMfc/sQDCkxYjNtfTnzOJZyNRMFBuozV9PcQcxOYUfUPJQxqztZqE7cvyrt8xv8sE1OPTAJS33Dhr3p2BPKIliEum0o2a31Jp9QIfZCY9ZX3Let6YSFRW6S2adotQmIli0+1Laxm98VW38/h2KFUuOylgQcg/5Qmt/+rxdDwxQi2SWLSTJ002B5n8z/gnPkh7lB6YFnpGvQm0Len5foo7zNGu4Cp4EUZZ2J09A4k4k0hdjLPkTec051T872L7rmow5uk50Lur5DloUC8o73r/vNdd5Ig/4mUs1ore7ezzWwrWtWfIpgEeYkRYSAMYMVAmoW4+5ibG9MB75DV0sewPBNdF58hX/h5JH9dp/2sIRCay4S4dqZb/3tR7UhEUFPVnttFYOBb9LVpQxEpOef1MGPHW1Ai1Jt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 12:09:54PM +0100, Fuad Tabba wrote:
> Sashiko flagged that when src_page = pfn_to_page(pfn),
> tdh_mem_page_add gets identical physical addresses for r8
> (destination) and r9 (source), reading with host KeyID and writing
> with TD KeyID on the same address.
This is allowed :)

See below description in the spec [1].

In-Place Add:
It is allowed to set the TD page HPA in R8 to the same address as the source
page HPA in R9. In this case the source page is converted to be a TD private
page.

[1] https://www.intel.com/content/www/us/en/content-details/853294/intel-trust-domain-extensions-intel-tdx-module-base-architecture-specification.html


