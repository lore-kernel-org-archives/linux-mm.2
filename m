Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AED3C5AD05
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 01:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07CDF6B008A; Fri,  7 Aug 2026 21:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BE36B008C; Fri,  7 Aug 2026 21:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35976B0092; Fri,  7 Aug 2026 21:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BF336B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:10:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 479C3140293
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:10:30 +0000 (UTC)
X-FDA: 85076321820.23.F3E9412
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf06.hostedemail.com (Postfix) with ESMTP id 562D118000D
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:10:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XZ4lSCF/";
	spf=pass (imf06.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786151426;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBqpzyOdU79Ty5gG+bY27xV4tF8RXvIpndhK9VTIeAw=;
	b=QR070L7aPSptnRVHwYkvr9yLuO4PjfU7GxPYKBC793K2x6N2U59pycYuvib71QLfF5WLJ/
	b3xcEbta5CBN0HqIr6pGGDZtA9Z1wvF60Oz2BtzLHHgD0PRmrYPkj2cdSJUFf/0NTnXigT
	ML9TqC/VlvAAxtSNoJ6u6inNc+t3dJc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1786151426;
	b=sRsMKE0dgziIWBy5k6dxQfFjKRjUMxkPFCUUVI19crSGVjWMMt79Lb5jvRA+mCe4FoVM5p
	nOV/HGrQFABZIEP/+yC9avSmtrg0asRuxJAtucCTVMyI/vTstsltBTucF+cdBGAvCJJgPU
	b6oVVHBHb8IDJDjBGLzrD8kLFMju6Uo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XZ4lSCF/";
	spf=pass (imf06.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786151425; x=1817687425;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=0F+KRvSVKg1d0yY6Q0gm92XmZy/yey6ZfkSO1D8+/0w=;
  b=XZ4lSCF/EDTNKI1XZiDDRWkwyTF3e3c6cSzmgm+KYrH8le1lvUFiSs7N
   TpcW9/KUG9b9jv88FCm/ebHM8bTMaidubfWTXrl3SPbF2p8/vN/fuWMNs
   5Hkl+qY++P62cVRR8DbPmOqReSjxb+5bxaRm7FMZ8OxsqIYC+1ISgj+AH
   lHykRxH3e/BtUYzgN5rrqkuUfD2VmZDodxeMOJDGQYKJwIQQJXThAVtOB
   dW2xpMXQle0cjZZhfOXTVJ9/gACo2K28KG9MHiC2l4CN/UoGByM4WYQsH
   1lorvsjaXV241/9aMoxnzdVXhCGDANwYAY9fWKwFGM8eFgu3QysF63ioQ
   w==;
X-CSE-ConnectionGUID: QLUei7iSRqOndoaLmVcQ9g==
X-CSE-MsgGUID: qalCxcZRSCWqjQsbk1PZbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11868"; a="74301523"
X-IronPort-AV: E=Sophos;i="6.25,211,1779174000"; 
   d="scan'208";a="74301523"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 18:10:19 -0700
X-CSE-ConnectionGUID: yKG1Qq1KSyWH8AWd8XTaAw==
X-CSE-MsgGUID: 467wbdcZTK28S8+qXn9ayg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,211,1779174000"; 
   d="scan'208";a="263158638"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 18:10:18 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 7 Aug 2026 18:10:17 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 7 Aug 2026 18:10:17 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.65) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 7 Aug 2026 18:10:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PgCWMyBfsTbKISy9WqnZ0bRKXUqdE9mctfjTDx5hOOTCYTw5d/17GrIzIZ214dnjRfx0sX8NX7UYQ9UCZoUk5ZzFT3Kd0sQeKrbUdWwMCWnyC6mG735RvFMOq3Kp+UlXsncC0x1he5ECR9J+Pj18ecTwo4xSTJ05QVveL0fnUJ/RCfZfpQtbCzt3ZjOlSMGKazbW6thmz/Khdc+QiIFBUXykj9e6u9L+pzh0y3ddb/WTXkhqpEwcnT4n9fk0Oxs7ZESvDxOV9TKIeuKCOAVkkS3L41JMLScPqCyMiFq/gG2mjIbUnAUmzHWsxs/VXRpxdrLRq14CV8tGJdBF87pAEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UBqpzyOdU79Ty5gG+bY27xV4tF8RXvIpndhK9VTIeAw=;
 b=JnGgG6dxbl4Kw/97Cc8sjrZYgmPzIK6B2eySq7btTDzPOCVR1dpttKo7xwVAUAQT6ha3d2opNfbT/9fLJfkwTaKdEWUu6GzB6FZvKIqtz9TE1s6UWhi0VdO3d0Zk5SlA4FmyS4ZNar7TaL5iSwQwuAphi7VhA+6IsZgURnbFu2kTF9GILYGJfJWI0VWsTtpG03HWS16xFHo33iDs7ymysFVmH0z7VeynahGEUNlL9K8yqlN997T0FaYoXpklx8vlnqVmsGOB/MYzll3SPT9u0JiCUbLSScUBoF7ppgQssaJzEoDR3TIuqkfOc0OrF/2Mqzdxlnvd7gISzZGHHIbIBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
 by PH8PR11MB6973.namprd11.prod.outlook.com (2603:10b6:510:226::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Sat, 8 Aug
 2026 01:10:14 +0000
Received: from DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d]) by DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d%3]) with mapi id 15.21.0292.022; Sat, 8 Aug 2026
 01:10:13 +0000
Date: Sat, 8 Aug 2026 08:29:15 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<jmattson@google.com>, <jthoughton@google.com>, <michael.roth@amd.com>,
	<oupton@kernel.org>, <pankaj.gupta@amd.com>, <qperret@google.com>,
	<rick.p.edgecombe@intel.com>, <rientjes@google.com>, <shivankg@amd.com>,
	<steven.price@arm.com>, <tabba@google.com>, <willy@infradead.org>,
	<wyihan@google.com>, <forkloop@google.com>, <pratyush@kernel.org>,
	<suzuki.poulose@arm.com>, <aneesh.kumar@kernel.org>, <liam@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Jonathan Corbet
	<corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
	<shuah@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
	<axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau
	<kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe
	<jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
	<peterx@redhat.com>, <tarunsahu@google.com>, Vlastimil Babka
	<vbabka@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-coco@lists.linux.dev>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
Message-ID: <anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
X-ClientProxiedBy: TP0P295CA0048.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::19) To DSVPR11MB9579.namprd11.prod.outlook.com
 (2603:10b6:8:383::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DSVPR11MB9579:EE_|PH8PR11MB6973:EE_
X-MS-Office365-Filtering-Correlation-Id: facd2846-6840-43f6-e584-08def4e9ccdf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|11063799006|6133799003|3023799007|18002099003|22082099003|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info: iFsfuUttelcO+P7CRsJCm4xN44vNJD01gZRQU8Mkg9kjMFfnPLOgdLvNjfsFDgOSzAJx5SY3U36Y+GrgYRcDczy0/jbGpAr4RDZtd4SQOuIapOJT2s6M2lhOJs59ASdFx70vAIAKTKZEGyGQtqdGX0fuVoY4kgHvxNRqjpdgEwZs0W9jCS64W2P2TegIXmXXb6kA16vtMI9kLJvq/epbU5r4yvEcHUeomVvAuMoeoTtepvIFTL6kmJcgAvfGqLxoJhw9umOwDv30TlUUg7+ljYw83sQMYUiy5v2VHO46LddDXKuP/VbQHXE5AVcp8ufKTLsPmGxdWsDMY0ynDpJ8usdpf/LDIr8hMYHQA56eHJ1cTc1mPzEtn0kgcPq0dDb45D5wku21IW95IQEldv4wl8kVid+9WeQgRahk7TuoBwxQLywTXgOw2rGYdJrkxpL1Z461Vlm2sHLEFPbZuvZgeTwlo5a3bN9GcBBCFj91KUPxZdIj+q4ejfZ6i2xBgWCVsKAgmIsKSUq5LIFF1qzbheqFbjLqsy2al4jGYTrscJjS1tA116DU3t3ClZ66rcpNg1TrjqpXhuW/ZMWexdsabl6qmUPpCdIsxrA/DZ/0KucIcmHPi0tUjAGh+eaQ287+mzMuf7C+R4N938d9Jh7XOa6HzaHJHjCfudfh4uv76I4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DSVPR11MB9579.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(11063799006)(6133799003)(3023799007)(18002099003)(22082099003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bpkh5a863F7+rhh+5zd1ZwYEf3De8lhoT+kNljXuhVZGpZqxjBphbshFW1dM?=
 =?us-ascii?Q?+Fph0RTU7ZHNaZxPblZOam0j5H7dWOsUICkEjj+aB7RQ1m0zEUpyHdc1n7M/?=
 =?us-ascii?Q?FRvt9fNiB53BOu71BlGbptXxLh5v7MOaR/ZfAFDhZeUEG6xQrCNFErec+TN8?=
 =?us-ascii?Q?ThVMctsBKaIlr5N6awyX0kmkPLpWdOFVe7nlGhbf2BW21l4UHDCPNDSkXoFd?=
 =?us-ascii?Q?A+3og0gwgEFFZiZcdpvntL1qTuLCYkUZZjoWMC8Q3QP/9oRNEJF8syVzCC4y?=
 =?us-ascii?Q?8GSgVtfupRBo31Ep86MGdpcf4W5okg7YM/9r3ees7snx4Sn44wG9P0Y7wy81?=
 =?us-ascii?Q?b8rzXP1Baq3UThl5bYAKnKwqPHU9tCZk2Qb/5ND7BNMiCTrB/5Q7KmKNO8cx?=
 =?us-ascii?Q?uZoge9aQX2j/ZZwnREhd9ykXigH+UvChq2ZcJZ8riBsacXVlyCBlfvJ0jpVu?=
 =?us-ascii?Q?qpOgAL2ktNuECbbAyY9e2HbU4skPACT2ZCShZuPm57wuzFDPTBUxAJnqKzbv?=
 =?us-ascii?Q?FlVV+IWTleFvenvHrwtJpvFBCvsLAsLeL/0hKdDxjMKJ7L1/U55iBHqp/lNh?=
 =?us-ascii?Q?eVTE5zL5G7k7CXLRhvDpQsZzddiERhQn/fIwAREUEky9AHCbrf52HKZOflBz?=
 =?us-ascii?Q?M4SL2/LtKK+yL/qvgdkb7yqUJQg+WfiyTOGzjRED5HZLBL+CrsB0HE3F0bcM?=
 =?us-ascii?Q?rNqXz/rn8s66rmh6YbDWs9wp/Rum+2Hg94xXRtsV2qTK5VUq3UZf4fxdMdsX?=
 =?us-ascii?Q?IuHHnb035yK3noplS6n0BX6rR+zwoeWQYobWrxoEYeEnTjKbtyRjUexteH06?=
 =?us-ascii?Q?87MK8a4lmIgRy6P7I9h3mY3i9TDEtZWux8Ci65tTpZvMHx7JKHpnJoMmn2Ru?=
 =?us-ascii?Q?99sXk9DU4Bs89kMG5HcH/7vQGVgYwA3JeQEjsbOIMv+N2umhjb2sJiTz+FTT?=
 =?us-ascii?Q?KxHo3VsiAy8/bbadwGO5Yo+1/yNaDGMVw3huzcbPgVN5dhvC1WWoWoWna560?=
 =?us-ascii?Q?G0/Pdrate0dxHUpvhIcBrCpbUh1skKoOXTg22ytGCPgp5Lu5V/oHKm/yKYHY?=
 =?us-ascii?Q?ERtPU2FOKkjCp10njwBFMe+qtPW8+3rZHFuTIPvW0cIQMazYc6OMNuLO4BGt?=
 =?us-ascii?Q?DFIBgCnovJCinAzfuMor4kmZR2XxO04QkWKHX4COQX+3PgngPYUSgbiXzLON?=
 =?us-ascii?Q?6UX88gYGrjHUeI1onlua/xTKb2142OX0+ihezfl7rNr9wapqv+xUwRuH5JWg?=
 =?us-ascii?Q?rprClewgsfOWVj4r+WTOsHbsID+NWIVlzrJwU6MSdM7rUoI0QWnUR0AfXuhW?=
 =?us-ascii?Q?qTCrx2wB8Ul9dgxsjhUUQyy6sVyQmimP9rxDJg4xXf3SsKb/rz9n9PvWFhDm?=
 =?us-ascii?Q?qaGoyxlwDDt32M3JJ2N8vr8ZV2KWNTQsR+uTTZiPlpQXhDwC2294wzVMB/Hm?=
 =?us-ascii?Q?86Xevu26zu4PBBZN/DmFMG+DczIDyfJpCcKJQmU8u7AGnnnYb0V2o6g1hC3w?=
 =?us-ascii?Q?Aru9wKYh+qnQfeI0F8xPkqNRYH32UbtU2xWDnHy/iDXehWKJYjf3d9LFOAXc?=
 =?us-ascii?Q?cpm1tlTuXVk8ifr8ww4XgCjT34DNtGR2O9Xi2VkyZOW99J38tPrBnRMOvIlI?=
 =?us-ascii?Q?xs7+Cqou/6vwh9+5XZZV4sRnr24SCWR1LbAFYpmiJDisGdNZe3lgEep5526m?=
 =?us-ascii?Q?CrmjL8KWkOaWGHjeY8SbA5kbFbeIyauFXgTOr42Z26mGv7JTHEKmV+I5Ra3T?=
 =?us-ascii?Q?2K225VlSMA=3D=3D?=
X-Exchange-RoutingPolicyChecked: UTezHCMApLwiaQjL/heW7qDf5xdYpdeSNt328VYY6/MqzRTCr8avPXpeIt5eetHA4qvn591fTBTyCF608Y8VzGtPd8BNlZFMlQQvqupycsxxG7piWCvCbQSSIn0lezZ+oam9ewkO0WCx9nFKtwUbIxRzsqcUWExEOjw3RzhYyz81PEZ0y8y6LM/aFSEljjU9cIdjBAJMq0y55YJDSzyGsdf1ZyYkBOQFfDAZUmgNii83vSai2X9YnRdSK61P1uSapABlSPDPGi0J2sO+TOykwxZ6DzmhtJqgqQ7JU4y8XDw8+2JFhbaVpxXbX676eO4jKgIzWoPJnq8vdp7SCRm6fQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: facd2846-6840-43f6-e584-08def4e9ccdf
X-MS-Exchange-CrossTenant-AuthSource: DSVPR11MB9579.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2026 01:10:13.7044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q0yu9gYZHd72CZdPjwDGbZ1AA+GYZkWuuSvhhV9dt2X7d/V+N2r0Nwlt94NM0UbIHqNzGhNMrwnXQl+ifmt0qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6973
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 562D118000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: usmmb3mocrxyo1mgco7dk7wjpzdym4hf
X-HE-Tag: 1786151425-843669
X-HE-Meta: U2FsdGVkX19oqJ8maAzmwaPHvzjEVzquly/j5rqviZCXeCFnfMraJTfYcFQh2MSo7do1dqYZWhYead91eY2AE8wtxsgLYR+2CRmcemM2CWsEsNnrRNkoiRekCl9WV4Zs4yPdA7q6kdYtJ73NtvMjNEdfNlyRTFRfuoZ999FJQsdzg93g0OGQflU67iwJ8YSXqd+wIVicBMmQCQBXwAjB2lZOscV/jdWNNG/7qrBKE+h7bUmVeceF4BvEX2ptNbd9imXITWt2d/BRf3fFKBgCYLCHmUW163Ks3NEwxSRKeojqApgdqeCkDiwbw4QRzUVdep5wH11kq0A3ifw/mtIVRsJke9A7QkGqgbTUCoe+COXr9nzwo6WQWOTe7vYDHKUGN4uIqEwgk/Y2yGJjM2sNMZkdErFsdX5V1GTZ/ywvVFW+641HgG8Hq6ckqpdC1HMfD7HBq9ZkSHOL65OUDfQfuTXCkb++5fqdFyn23vBnQIgXznYVIldRw5nWjcA60oGL+9J/Mj7+rE0mAIS5DPGnrcxt8z3ZOHNfZ92hNGH5II6r0Ouxsug7LCVygJul8pPkYNJ8hnAmjKuezxkiz8OaQvU9tMn3OafVIXMXh3QOj+wtu/h6qBGTSvxqMKAmXGjAH+xuwUhJgCC4Jzhn5tgUIkwN98O7vBMvXySx/UWKAdK5Yia1+lWh0K4C57EUOTvikUObHr/au1b/GmF0gl1LJCYAZkJ8mj5jmNzNFS7vx4OIkFdKwYtkN47JO9mkXibXyHNlue5SoXZ19JuDaBg7EauJg0W635od5NoB+K/32FZGPIt9rnJ9BLuqxc5Z6qtGOifX5w8tac+RglzyODNzPkvEf/KIvoF8ZTgnS+0BParujFp44pXAqVioNypssM5E2/1VB/SE7RuKSBTfB4qYecNdNyruM807q+Qn4bZuW1mhJ6vdfdM4QI6ASPlM1Qa1wzxAwM3F9Fwj0mkGkfU
 xhQlJQ46
 KIbZsNoBu8iO7tqalzdhmXTnmZCv74NrYIYALZnpMIW6oIuCylLrE7utE+8oRLHU3JvMmoRS/iKPmz2Uk7QIKJq0JHjq+D3LbzWLg0UaO7TfIDhjzraTEYM4wArPErTy5rIqeMFVihDn9m6sOAcbucf3bezaeGVt5ooK6N8ajpsj9S/+yh3fOun/j4YCskYBoTy3N5lTlUSO7MZDnjHdqKGjnD/T7Q0WWbpVCA/9BuxE9hR05aM2VijnpFPcGLMxtoPHnFpwcPDrRdJvtVR8WXqA5VKuUoOjCWvG/aAQhzyzqSdkF6UthCxhAQOwf1249WMgQ95eBphqRHy9GZL8wP1mz1dVSADVu0XHZ+BB8afmd7DotP8ImEIevxfE/JQ/5OqFEXjUFw/oK6GUPJzwJAsj8TNWZIFiy6PsIOzfHL8+Y1pCfljDbxpK+A+XZEusJv4aLtyVIKdrdhuulTBi94wzq9G4s9EMo55a1q97Y1kbkPB1GmVFaTrxIJR87FBuDyVINGaL1vJhpgv36pLPYdFfiE6Z9m5HXOqcPlTtw88JZNKcXX+gVu22iA7WLzDlEGD1Fxife08MDBok2R85DQf7mJGlCWv7ATYM+ibtcDNd31JPp9g0toADFHGT5QFMu3EBoYnZxu+2iNKoiRExVKOrtggkPRbfceNZmDAUCsTeZs/emUZoKmX3HGBPZ//moSdL5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 02:52:50PM -0700, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> When converting memory to private in guest_memfd, it is necessary to ensure
> that the pages are not currently being accessed by any other part of the
> kernel or userspace to avoid any current user writing to guest private
> memory.
> 
> guest_memfd checks for unexpected refcounts to determine whether a page is
> still in use. The only expected refcounts after unmapping the range
> requested for conversion are those that are held by guest_memfd itself.
> 
> Update the kvm_memory_attributes2 structure to include an error_offset
> field. This allows KVM to report the exact offset where a conversion
> failed to userspace. If the safety check fails, return -EAGAIN and copy
> the error_offset back to userspace so that it can potentially retry the
> operation or handle the failure gracefully.
> 
> Update documentation to document the error_offset field and the possible
> -EAGAIN error.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 19 ++++++++++--
>  include/uapi/linux/kvm.h       |  3 +-
>  virt/kvm/guest_memfd.c         | 66 ++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 80 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 1a3f664dbb197..1e64026d7c1e9 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6583,7 +6583,7 @@ KVM_S390_KEYOP_SSKE
>  :Capability: KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
>  :Architectures: all
>  :Type: guest_memfd ioctl
> -:Parameters: struct kvm_memory_attributes2 (in)
> +:Parameters: struct kvm_memory_attributes2 (in/out)
>  :Returns: 0 on success, <0 on error
>  
>  Errors:
> @@ -6592,6 +6592,8 @@ Errors:
>    EINVAL     The specified `offset` or `size` was invalid (e.g. not
>               page aligned, causes an overflow, or size is zero).
>    EFAULT     The parameter address was invalid.
> +  EAGAIN     Some page within requested range had unexpected refcounts. The
> +             offset of the page will be returned in `error_offset`.
>    ENOMEM     Ran out of memory trying to track private/shared state
>    ========== ===============================================================
>  
> @@ -6605,6 +6607,7 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
>  ::
>  
>    struct kvm_memory_attributes2 {
> +	/* in */
>  	union {
>  		__u64 address;
>  		__u64 offset;
> @@ -6612,7 +6615,9 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
>  	__u64 size;
>  	__u64 attributes;
>  	__u64 flags;
> -	__u64 reserved[12];
> +	/* out */
> +	__u64 error_offset;
> +	__u64 reserved[11];
>    };
>  
>    #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> @@ -6634,6 +6639,16 @@ which includes operations such as unmapping pages from the host or
>  stage-2 page tables, may result in side effects on memory contents
>  that vary across different trusted firmware implementations.
>  
> +If this ioctl returns -EAGAIN, the offset of the page with unexpected
> +refcounts will be returned in `error_offset`. This can occur if there
> +are transient refcounts on the pages, taken by other parts of the
> +kernel.
> +
> +Userspace is expected to figure out how to remove all known refcounts
> +on the shared pages, such as refcounts taken by get_user_pages(), and
> +try the ioctl again. A possible source of these long term refcounts is
> +if the guest_memfd memory was pinned in IOMMU page tables.
> +
>  See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
>  
>  .. _kvm_run:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 80985e28e3b21..129d6f6303251 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1661,7 +1661,8 @@ struct kvm_memory_attributes2 {
>  	__u64 size;
>  	__u64 attributes;
>  	__u64 flags;
> -	__u64 reserved[12];
> +	__u64 error_offset;
> +	__u64 reserved[11];
>  };
>  
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3783e63476569..13c3989136f67 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -524,8 +524,42 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
>  	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
>  }
>  
> +static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
> +					    size_t nr_pages, pgoff_t *err_index)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	const int filemap_get_folios_refcount = 1;
> +	pgoff_t last = start + nr_pages - 1;
> +	struct folio_batch fbatch;
> +	bool safe = true;
> +	pgoff_t next;
> +	int i;
> +
> +	folio_batch_init(&fbatch);
> +
> +	next = start;
> +	while (safe && filemap_get_folios(mapping, &next, last, &fbatch)) {
> +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +			struct folio *folio = fbatch.folios[i];
> +
> +			if (folio_ref_count(folio) !=
> +			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
> +				safe = false;
> +				*err_index = max(start, folio->index);
> +				break;
> +			}
> +		}
> +
> +		folio_batch_release(&fbatch);
> +		cond_resched();
> +	}
> +
> +	return safe;
> +}
> +
>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> -				     size_t nr_pages, uint64_t attrs)
> +				     size_t nr_pages, uint64_t attrs,
> +				     pgoff_t *err_index)
>  {
>  	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  	struct address_space *mapping = inode->i_mapping;
> @@ -542,8 +576,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>  
>  	mas_init(&mas, mt, start);
>  	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
> -	if (r)
> +	if (r) {
> +		*err_index = start;
>  		goto out;
> +	}
> +
> +	if (to_private) {
> +		unmap_mapping_pages(mapping, start, nr_pages, false);
> +
> +		if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
> +						     err_index)) {
Note: conversion failures could occur if another vCPU is attempting to map a GFN
within this range.

CPU 0 (setting attributes)          CPU 1 (attempting to map)
--------------------------          --------------------
                                 A: mmu_invalidate_retry_gfn_unsafe
                                    filemap_invalidate_lock_shared
                                    __kvm_gmem_get_pfn ==> folio refcount++
                                    filemap_invalidate_unlock_shared

filemap_invalidate_lock
filemap_get_folios
check folio_ref_count(folio) ==> Not match !!
filemap_invalidate_unlock

                                 B: read_lock(&vcpu->kvm->mmu_lock);
                                    is_page_fault_stale
                                    kvm_mmu_finish_page_fault ==>folio recount--
				    read_unlock(&vcpu->kvm->mmu_lock);


Retrying in kvm_gmem_is_safe_for_conversion() or moving the invocation of
kvm_mmu_invalidate_start() + kvm_mmu_invalidate_range_add() to an earlier
position does not help as long as CPU 1 stays at stage A.

So, should we avoid this failure?
e.g., by moving filemap_invalidate_unlock_shared() from stage A to after
stage B?


> +			mas_destroy(&mas);
> +			r = -EAGAIN;
> +			goto out;
> +		}
> +	}
>  
>  	/*
>  	 * From this point on guest_memfd has performed necessary
> @@ -564,9 +611,10 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
>  	struct gmem_file *f = file->private_data;
>  	struct inode *inode = file_inode(file);
>  	struct kvm_memory_attributes2 attrs;
> +	pgoff_t err_index;
>  	size_t nr_pages;
>  	pgoff_t index;
> -	int i;
> +	int i, r;
>  
>  	if (copy_from_user(&attrs, argp, sizeof(attrs)))
>  		return -EFAULT;
> @@ -592,8 +640,16 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
>  
>  	nr_pages = attrs.size >> PAGE_SHIFT;
>  	index = attrs.offset >> PAGE_SHIFT;
> -	return __kvm_gmem_set_attributes(inode, index, nr_pages,
> -					 attrs.attributes);
> +	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
> +				      &err_index);
> +	if (r) {
> +		attrs.error_offset = ((uint64_t)err_index) << PAGE_SHIFT;
> +
> +		if (copy_to_user(argp, &attrs, sizeof(attrs)))
> +			return -EFAULT;
> +	}
> +
> +	return r;
>  }
>  
>  static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
> 
> -- 
> 2.55.0.654.g21b8a5bc05-goog
> 
> 

