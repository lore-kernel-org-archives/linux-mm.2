Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B18DFED3C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ACCF6B00AD; Fri, 24 Apr 2026 10:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783E16B00B1; Fri, 24 Apr 2026 10:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673236B00B2; Fri, 24 Apr 2026 10:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 513196B00AD
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:24:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE1EDC0A7E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:24:41 +0000 (UTC)
X-FDA: 84693670362.08.4363CAC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7576414000F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:24:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D08zCFDd;
	spf=pass (imf23.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777040678; a=rsa-sha256;
	cv=fail;
	b=psvR9o+7Ajg851kNA7uXaeOlyBVlrjAht/R8BDg/cHL2zrjFRv4R31hmWtP8m+c4EQodRw
	5ih7Az5Yvlb2Kwt92UI6X19IWGRXeeqMyK7aJSXGc/LEOS3SJGVcHq0eqTeDM7dMQ2Ig3f
	DGGwrHOiH2jJwrMEPgvWs26Oqmb/APk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D08zCFDd;
	spf=pass (imf23.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777040678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4FR3J6Lc02Rsfv7xsfc3yeVCyHPznqtu3gECTjFxmo=;
	b=GKVpgU2cRWA6xgmx2RuucKuesoGCJTUiUcf1S5p6z6Im60WEVh8BVqdqoaerwnngaTlkVn
	h2vfWy0N3vjUBP2jWiOZSmfUzt94NAWUekOABkqm3qp580QjtoO3KwjiiufM5EaO5NIXU4
	/8JRqa5HOMpKQfoavU0rD+azFzHFWEc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777040677; x=1808576677;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pS5R7Q8SJdXCmyiGOgrlzwAfzy3iXMHA3ruZDJ65NeY=;
  b=D08zCFDdZjKMowfwlx7EFeMuGOi6pC+A10F0T1LMft/I9viwR+4k9N0m
   rIKNjWFc9wvK/tROyFcNBIlWaalIyW1/uN3HY15JKiUfOqbRXEo6te8K0
   QOIDq/+D3PKOY6KrcwlUrbd+qhDrp4biHLDGwfGyONiGk/Yi/Q/JmnQI8
   iWygt/EGRnz1i6aFxaRMgkYT1d1QWcmWVu5qTowyOaptJ2bd4X3T75e+/
   lI4w1H+X/XScsrGCMv0fXCzhkmvjkaAmeeRR7g02dm2Nx0E3Vn3QARSXC
   iPKriYu3tH2pWDZw2NdZcPPRFXHVDMf2OFD5fJFCTTYEPjmQZA7JHzmSE
   g==;
X-CSE-ConnectionGUID: nhksFco6R4ys6MUk7FzmCQ==
X-CSE-MsgGUID: lPQd6zPSQ/SCrPEW4cFogA==
X-IronPort-AV: E=McAfee;i="6800,10657,11766"; a="89405143"
X-IronPort-AV: E=Sophos;i="6.23,196,1770624000"; 
   d="scan'208";a="89405143"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 07:24:35 -0700
X-CSE-ConnectionGUID: b6GyX4bBQMKcQ+2Ao3Gqew==
X-CSE-MsgGUID: NWiYw+AqQle352806j6keg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,196,1770624000"; 
   d="scan'208";a="271090406"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 07:24:35 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 24 Apr 2026 07:24:34 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 24 Apr 2026 07:24:34 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.68)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 24 Apr 2026 07:24:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LfWt7E3KYSyGxrThqmt4e/rehH8PRvL/1Rs3WP0T4n1n8MbwKLiaQnCDAyKNvrKfGdLphue48hq/qsOgyZp4PibEw6bNcFTdtoKTEavADtvRweqYu3wxUQUVY670Vb/dnB+vb318C07P2vs+5FgwxfvnaLP8RHEwsg2ZVmuGzZUR8Md8jZ5Xhxiq52obtZ7bKjUtI/YWeREnYXv+smWguLEzI3kzi9mTOXMkFMqPJ/fZIKGjJnu6WrTj1D1TK8WGHxT6mLF9/f3yFunn+JyeYyZvry6SJ7JHZX7sRyIQoKxhs/DivZggvnWLesJAIQR6s3SW6d1RBKct++ZInYse0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4FR3J6Lc02Rsfv7xsfc3yeVCyHPznqtu3gECTjFxmo=;
 b=T2/wMgUFEEdoyK2rX7KdRtIjNRwWUZ2B4yGCF2Na+Vw34IshMQrbgHCm9GF60bYmIx9AGMulu2zSEI2Tmwcbs12zXCL9oYGg2SKbRhbeI1GaiN+YVPz7ZqklM2jz4d/wwqWvVqa/DREXx7nZv5RgLSF2hAOxSubMGKrofqRKG6UAguXAHGrUmgDe7L+lSJ24viFgwDwCPFu9GM+aTGVME7LJy4kGZarF9x791LGW4VTUn+ZCOoWK4YGXN5QBlsfIAnKtLWDVyXc+x1KSEFtlx4slVCdEpGq6BxZaN7UIXpMnQVvrivGDjFcKIpqDgvULN0KnP3bmLkWIwV7CptJWtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA1PR11MB8427.namprd11.prod.outlook.com (2603:10b6:806:373::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Fri, 24 Apr
 2026 14:24:27 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 14:24:27 +0000
Date: Fri, 24 Apr 2026 07:24:22 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nico Pache <npache@redhat.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-trace-kernel@vger.kernel.org>, <aarcange@redhat.com>,
	<anshuman.khandual@arm.com>, <apopple@nvidia.com>, <baohua@kernel.org>,
	<baolin.wang@linux.alibaba.com>, <byungchul@sk.com>,
	<catalin.marinas@arm.com>, <cl@gentwo.org>, <corbet@lwn.net>,
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <dev.jain@arm.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <hughd@google.com>,
	<jack@suse.cz>, <jackmanb@google.com>, <jannh@google.com>,
	<jglisse@google.com>, <joshua.hahnjy@gmail.com>, <kas@kernel.org>,
	<lance.yang@linux.dev>, <Liam.Howlett@oracle.com>, <ljs@kernel.org>,
	<mathieu.desnoyers@efficios.com>, <mhiramat@kernel.org>, <mhocko@suse.com>,
	<peterx@redhat.com>, <pfalcato@suse.de>, <rakie.kim@sk.com>,
	<raquini@redhat.com>, <rdunlap@infradead.org>, <richard.weiyang@gmail.com>,
	<rientjes@google.com>, <rostedt@goodmis.org>, <rppt@kernel.org>,
	<ryan.roberts@arm.com>, <shivankg@amd.com>, <sunnanyong@huawei.com>,
	<surenb@google.com>, <thomas.hellstrom@linux.intel.com>, <tiwai@suse.de>,
	<usamaarif642@gmail.com>, <vbabka@suse.cz>, <vishal.moola@gmail.com>,
	<wangkefeng.wang@huawei.com>, <will@kernel.org>, <willy@infradead.org>,
	<yang@os.amperecomputing.com>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <zokeefe@google.com>
Subject: Re: [PATCH 7.2 v16 00/13] khugepaged: mTHP support
Message-ID: <aet9Fvfnk27dlK8h@gsse-cloud1.jf.intel.com>
References: <20260419185750.260784-1-npache@redhat.com>
 <20260424065828.031775921990de37f83a2468@linux-foundation.org>
 <aet4nz/Ljn0kDjDk@gsse-cloud1.jf.intel.com>
 <20260424071930.62318a9294e07c99ba0ff8a2@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260424071930.62318a9294e07c99ba0ff8a2@linux-foundation.org>
X-ClientProxiedBy: BY1P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::9) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA1PR11MB8427:EE_
X-MS-Office365-Filtering-Correlation-Id: 018e24f4-08b7-456f-6251-08dea20d30e4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: DISh7zRKl5tDz3QOeQMLiYeavhcI+08qae68mFXuR1Zx95Kx4mlkB4UWWafNRcFmyENuQ84vElO6mQmSOUTOEoUSxKsb/4QE19QrnruQRMIxw+8J+AliaImFyU9y445AZfYD5a5AZmLN/SoFx8UfjLREZMcgy61kpvnj+x89d9WMASlq4CKYuWg492Z8HjMlg5e6Z/ZNkF6BopI0GTgKvcs8Y3V3qtjIAxALSvKGUjFKr0y0rX7x40gCS4iZgkKOK/O0P5xMhpaOT5tgETJPQH2KTOy6mnKxSXrL0fYF+YCtXkidzVZv85MaMqa/bdTxz9eT19FQFI+qMITFWy/OB0Ys4HgGQ41BOT3wD9cnPOo5w62yw/5s5dkA0v9ZO7C/eTJRFY18F4MBa0h244x2xs5Y7oIfUpzeq+wwTsfcaI/spnl3TqdFmRIJunq50yKoCAYPhnRSNSvK2STiqcoUtod7dCCNblLx+hsx4mvB06uanfyn9Dltop0uTqaS8m+c7S7/nIHxzHDST68piYPOyJv2/KZ1YR8dZgrnikr92a23jnyw4lMiYYSnBGI/Bcxk6VZ2ns7QeCo2Y09vr/0YTHgVjVuZ4td3CUXT9rUhdxO7463gpcszz3dll5VMiwcDtytsSBYM5iyL8LzJLmOymCEMZoQzWdoSSHqzIkjg1kY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V9hhfJmD0Ko3HBcTs6Q13yflnzHxpB3QIjcaOBfpqMqYGuQzqDgEwTfmTIFe?=
 =?us-ascii?Q?VZSeqBScgg1XfVe+34UcY42xy4nbk7uzPLBJGWu0cZExURkRRIImuwyfbUQW?=
 =?us-ascii?Q?VgNSV7CfdOmmSvyZYORZsbf0DmwNMA5CGLxiGgcUTUikIqUBkUtdRcNB0+do?=
 =?us-ascii?Q?G+Vt0bPCaaLaLHkVb5Ei59TLfmAumZWVTj9CFpR6kPOsobR4Z4OVFlT/AEap?=
 =?us-ascii?Q?YiK/Rvn3oPRf/PeGgllQi6pOKoPqtegYPbR/zX4+wSkhb3FwnHOUax+SSQ+7?=
 =?us-ascii?Q?dS9GjvYPOOIy1x845upQVkxCtWLHqUMKawxbl7b6I9AdCJOuhpk/iEKiIfB3?=
 =?us-ascii?Q?qaNZeQFGSBbIPoENAS4MB5DNc1t++I6uw1vIacjKVo6Xx4oSvCQWmCzqZi8D?=
 =?us-ascii?Q?1LznRRbPHF2aQybDHrrsTmWTIZHjdAkPmfGfXEpeN5p4kVOucDWM75OmijWg?=
 =?us-ascii?Q?1LfaSd4LYhBAP4pkduRmjZDFl37fQXabA8QDbQjnEiR/LfK/hzYCjAsuxnOc?=
 =?us-ascii?Q?F0rb+qXg0YDu9Zsm15HnNdDdMpfpVCSHTAWez8X+yLMF8vBgTFdFvqXrg5Ns?=
 =?us-ascii?Q?FncmH8bkYbSKWcDyL5rfSeyzq7XuXrrooN3GoGmLeE9nv/stvmihv7gMZ5C5?=
 =?us-ascii?Q?MPbMCp1Y3uXGSiu5GKoNTBGYCKBE62O9VK+lSB0nZd4l86IFenu1FHtbj/QI?=
 =?us-ascii?Q?NIgsQ7e99lptza5PYldZh8bsyj/PIESkObY+NMnWJNGKOieY9Z+cGKhU7M4Y?=
 =?us-ascii?Q?I1YHqcX8OVsrtL68/qD+eC2mf1jijFWR3qpD91+4csO1Mk2teWlLotf5ymEs?=
 =?us-ascii?Q?dGSN7LMtvBtPHiJjGZkWqqF8t/DLs9PqyV7VXZp/h9mOpFluDrI375rdxNpF?=
 =?us-ascii?Q?xGOQvF7xG8lYpQ8cWfrN+pmos6j9VG4YodpRQ2CfFJXaRmyXV59u+CNFQoei?=
 =?us-ascii?Q?aSShPU3b8MBV5wkYPLlmpyqzprWPWJCblvzMfqaiqs5vR7WUz8M+Ee3tLUY3?=
 =?us-ascii?Q?2anCBvDFvnCBaWsUU9yrMXV07wTUVDOZFNRzK9+vI21ALpQrRLmkn431QVG0?=
 =?us-ascii?Q?gNZMdjLM3TigxsW9JdhKcJz5iyXKzGMBh4F1SyhsVdYFwKe0JGnNAdIKDMLE?=
 =?us-ascii?Q?9ktTxen8ezl8UlYpkM2qJUeqxgKWRXC85HdfmxRnUJgf07/WuG4FdjUWKJD1?=
 =?us-ascii?Q?l2JF2dksUjjpaPbSvIVVgOOD/JzhCo4GpfiH2BKZgxsAOhFK+KxokktFil7d?=
 =?us-ascii?Q?aBTIFiqbre9M7O/9N2W6crqs9nRONcqo1Q95A0nXJIcMKrqZ31wptiAhNc2d?=
 =?us-ascii?Q?+yDmQAMShuOk3jW0nyYjYKnWZDJjNCtWDnFZKhYAPxY3Cn8Rxva0r0wmxhDC?=
 =?us-ascii?Q?LpscLfuFSlNhn2ujOVGh/fEeO8W5yrG4l5iDvgCjXLposjbI+XclDI4z5DjY?=
 =?us-ascii?Q?7aXYdv4XjmVXiaj8Qv1PnfYboqlSRjg4Tku5WifsqfEHbHA5U+nlap4auYBv?=
 =?us-ascii?Q?rxjzKVG8ggWy82XSmnysBrHIwADZPv/dR5nAQ0tmi9FzmuxSupZR/bm/6jCU?=
 =?us-ascii?Q?LEXm8tD1c/GopaldtTQG+xDGlLzHy6QWqe6/KYCnZPJ8CvfCesiDn2EEffZf?=
 =?us-ascii?Q?d9BJp4gY3kc/BeihkNGCr8A6etIBJ2tAJaiyNggNHFFC/mze0Xyiuy78aXd8?=
 =?us-ascii?Q?hwoZTUay49rICnsf/MuEHyxe7HlqRlBOXYxrxCLppcrqxivHO9l4LvOxj+Bf?=
 =?us-ascii?Q?2C6syokZGQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: J+JPCUoZGFqXvbUplyIfi4aXx9XbMn6HRbYXAq27o94pbqQqe9PYG5lffbAL+lD9NcHID2O4QkepiP7BNXvSTcIHbjAlSa7KSksEXmYWh8533zOS4kK66/DObCDCUSkMRPuxVPNNNvquDxUfrgRPtqvBlOhvfxZH3yQd8AgaQ+BABvKBbtd286JuLWz9Op2stFLe1P/nyGLQSUCkfbf0zf8A4/ts1oTr+vOzsYLSAQQZg2T71+McniBgfPx5SrlozWZIC7NAGeD6pQCjuPuO0Jgk4wKc9eQzIfvTEVTufQAmsCR82kFr6/LOo/xxIumoQx6ntCO/yZSgMem/WsYRRA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 018e24f4-08b7-456f-6251-08dea20d30e4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 14:24:27.3289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vi3LYE//mparhk1jVZTWMineIuMXHbxm0lQI0A1MVMs4qEFavQT8cRV0tcuUTiJkCUz56FmjCDAagXi8QtynkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8427
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 7576414000F
X-Stat-Signature: 9ot9gduswex16b386zi8rmzx6b8mqzq8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777040677-178082
X-HE-Meta: U2FsdGVkX1+Y8KJPTl+I5mu9zoC+gvUFw5Rs7z3voD+WRpkSXXm3K2+rcaJHA9MKWIPrV7EoWPyG94mcIT8VW9QqEJP2jxEXO3pBqvWh2PfPFMkSylpzcoiTuAZoccTL1hbZjYH2eyrGyK1hggc4tNyAC6E5zV/sLmExIPuIiw22lbv9nxMT/Wh/hmGFxPJZGMrCuLaXQowHlPoopnvrP/V77nn1u9lDleNHprq5bARlPh4kWLhsNN7aNhJFaAS3irjsfnUigrr5dVptcMtU8BeOXJeZU+zaAAWVvwL+gyu2lFNAPnH7oEmBNDhX++c7KFbjjEIG0Mb64zmUhQ2rADryzxjeKpHV5xp0S4SMtjvq19hhuse+c5fVsxAVpFZ4mS/FpecJeZET1R/50LkU4TBMTz+lxo8PTPkM/VGNpPZVDnXNwa9l7rdGPBY3KVFhOxcW3TZn4vZ6A+7G85P0zgMW8zySOxLpP3e9An23gfWrOAz2eoqkRF2BxIJcbldftdG1IwVvfw7M85rJ5ZGZ6QCS+yCNEwyuGdQizytkBo0/GPH9yfoCvE/yJ1eCy8SAJi/NIAzIgFajAg+cT/mYAvSspK1iwXvkp2E5ahMrrqnNh4ekAuCmshS/7jS5Esnvkz6oH0GF6pY4i2uCy2sJwuQR9R95+YEWaKcGJ75q6Pt1lVJQPso46HNd99Q3wmiwqCrP6cM6d+I3HodcIbTk22/P7Tk9olbjzDt5duDudMGHMrWjcbd2/8CKkFI+qs48XEOKwI3eTmdkVxvmllEMuHySYwejH5dsaVQba8VurWmWdx5MHl+rnY8kKUgyG+q3i0LTZ4etyJGDHYWUNhaAnxOxEOIjWn9pmp/iXlGLaPAP4cvqYyKUk3NTSodGxY5mC0tvw9Y7CGEmrXxeaEB11iMuruub0bd7YJ8/6lGH1SQLoYqkIwNqbcvLDzVCKjyTNiwVKt7pVrtr3ki80/T
 99xHM9ZD
 +aD8Wd++focRKnf7zHkRUPIq0Kt/3WmNN4jL4H2TTJsdl4NntudcBCX1yqU4IucQEDfwBhJoZMSjnliEz/Z/y3opRooHvAlXsEc/LosUauWwI7urr8OgGDs36IjsZyg8wNBrCD69eq/N2eNTlP9zeMiNlSJR8nItI+xr3uDRVWaGXSS/VT1QVKV3xHq7av8pyGXUbPqO18M+FIcV7hIjY+kHx+2Sb8lQoIFnK9VXJAQY4SbPciGLXmyyN4QlbK5a6M3fSx0wFhR6PHeua1+SWp4OZok860zGUI63mp6jbRWFcYZblFgV8nta7UqnGmfLCYjOsF/sMHIP1rZ2cB55kFyXvUpJHeJQ2ktzqDy2YcPF/r4hcGXy+bI97jHH8ADrvgg5bl+RAhwY6CE7KbujUL3uhEMiKJV1lvEz8U7BwX9HdoVK6itt7Em3f49j88lsTPor/M43qNxykaxJfvq/GhVf28G/gNS1L6z6UfnQdj0WPRB/LBhxZFESnKTRFJLm6uczUq0uAn6kkO+vFnqT10V5yMYpHs7YgIb1SGXH0PGqYu2zZflpwmd88BZPCKO52dZYgKxxioI/jHHKqcLFpXS0Di15vmc0gA6E9LjUcah1IuzHkkADgORP0uFx0Oz3Tceukrj1N6mvE9Qg9gqpI0OrsbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 07:19:30AM -0700, Andrew Morton wrote:
> On Fri, 24 Apr 2026 07:05:19 -0700 Matthew Brost <matthew.brost@intel.com> wrote:
> 
> > On Fri, Apr 24, 2026 at 06:58:28AM -0700, Andrew Morton wrote:
> > > On Sun, 19 Apr 2026 12:57:37 -0600 Nico Pache <npache@redhat.com> wrote:
> > > 
> > > > The following series provides khugepaged with the capability to collapse
> > > > anonymous memory regions to mTHPs.
> > > 
> > > Lots of stuff here:
> > > 	https://sashiko.dev/#/patchset/20260419185750.260784-1-npache@redhat.com
> > > 
> > > It's going to take some time.  Hopefully worthwhile.
> > > 
> > > As always, it's useful to hear about the usefulness of the AI review.
> > 
> > Drive by comment.
> > 
> > On the DRM side sashiko batting average is about .500 but even on misses
> > it is generally is helpful in questioning assumptions made in patches.
> 
> Interesting, thanks.
> 
> Personally, not adding bugs to Linux is so damn important, I'd be happy
> with a lot less than 50%.
> 

I'm convinced enough that any patch I post/merge or even RB, I read
sashiko first.

Matt

> > Matt sashiko
> 
> "A sashiko mat is a decorative or functional mat, such as a coaster,
> table mat, or place mat, made using traditional Japanese, functional,
> and meditative embroidery stitching".
> 
> So there.

