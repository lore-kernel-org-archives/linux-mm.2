Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40E04C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AD6D6B0005; Mon, 29 Jun 2026 07:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05DCD6B0088; Mon, 29 Jun 2026 07:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1ADB6B008A; Mon, 29 Jun 2026 07:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCD346B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:40:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 417B51C37AD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:40:17 +0000 (UTC)
X-FDA: 84932756874.09.50A97C1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf31.hostedemail.com (Postfix) with ESMTP id 02D1D20002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:40:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N3pP0hBn;
	spf=pass (imf31.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782733213;
	b=qTfk1+PjjmnP/yr2/rpngFKwVcwjWszdiTFqkqDSlbdWVSYBrvTyFB78MnmUKfrunm5D9v
	CDfiCh6pA7sDXy80tajqo7D1vApQuGfV4ax5SshhiVz4Kqybw8eR7Ez/q1VFA2wbRFDjTZ
	Eb98CoEOyfgEOC1slaIWgoEYzi8UL/k=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782733213;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLGDlUX45pyH4n6zMqY8n2u597JQXzQICQmu1s5kct0=;
	b=5ZfQyYgOGu8V7Qzvr3z5o0BMP36s6fy0DL0I56j4CvvmHU8CQkrtoaVbUngiBSrdJlm9ys
	QhAltms1HoPRXDrbCKRxYnq6xzCbxFH+KZjfHKlXoKCbxVXCkQZUFtmeIiRZAgFeSrU1ea
	71ZCJb4Nj2kXwQWaM9ypGBgl2ABENGE=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N3pP0hBn;
	spf=pass (imf31.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782733213; x=1814269213;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=RQ2NcPVxyBOn3i9vV7zLzpSLZRYXl513Ob5PJjA//eA=;
  b=N3pP0hBnHSwbgG8RUNGxuTg/LyqgAPcVyY1jflndI0Wn8fabGQI9lrYC
   PRuroQm0+YmJzgMUlQOcAdFJNlHH4V9OCyNLtSHH4fejrJQOj/kjqBK6d
   1xeLlC5DjEpI7wN1CMj4mG6PIUcO+oo0E2lce+boY5Z3MdzOegSPwzF2B
   iIz7Mynn58qnTCTpQ6SYlUNYj02jhQeclzim9Ljv2SH2gHG9nnR72KyzP
   Y2LLUuUxx5zjbMtYPn+d9EaYlKd0Jaymcr8I1/1E5bVsxucKoYPvkJzk+
   oblFtiKssetDSuYznfmpjPxdn+x8xGXxnWg/b4XXntkJYnLWlxYjcHX9P
   A==;
X-CSE-ConnectionGUID: fJ7ihlEcS12J6lvkAEL1vw==
X-CSE-MsgGUID: kN6NQXxuSNKkOdpsr6D4uA==
X-IronPort-AV: E=McAfee;i="6800,10657,11831"; a="83449389"
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="83449389"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 04:40:12 -0700
X-CSE-ConnectionGUID: 9eZFGVeRQveht1wRLxGYUA==
X-CSE-MsgGUID: J777P0kbQqyc0F4sc/QyPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="245574281"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 04:40:11 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 29 Jun 2026 04:40:10 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 29 Jun 2026 04:40:10 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.4) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 29 Jun 2026 04:40:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g/5r/FAc3fvH6ANAQWEqy2Db5sWkJuGyLqmFexoiB4bw6p9U1Ax+jqFnKw22CmZeeaaJiXH2qcDjFBMjpByA49aD/CthjF9lF+08h45Kdk08C2bGI4rpidbOZaLqlC0Kt7vF05OMAjcTZR9HaGq1LoQn54eWzdJwtU9dyULtajWdhHn5zArYS/NX3zB8HrrdQnLx/UCPvxi4Y63sHdxkk5u2xKhw2LmXSrZG/308yc1AkoB1IF4TepuASUTraQORBbHB+ysp/ksA7qsmeObuqOAcZw19XBdyCajoa+jTnhYq1DCIpzf/OY/RAJSuz5CtGZ/lvBGmV486mbzp+VDz3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nLGDlUX45pyH4n6zMqY8n2u597JQXzQICQmu1s5kct0=;
 b=wTiQVxcLCqKF79LRiIefvMWLvoumwdrwTk5SKbkaI61uDlSCg1czxT2/6loah+rmD7pSuFABNjMMrmuvuFKxYPVB2qGD8elRQ1993ZGbuTWJ/PDDGm7cXlj9DmWWBQfmer0+NZPIZau8ltHMP3lkbV9VP7UwgZJ39UoJ5Vki4g08AMPIen9ouFQWSwWdlh0cpQ57DYhS/wDmcEFn/r3pzq7mIhq+8sl484UlvQAkuJmMhsUNfwQnhQqGDyUKmeGE+cyDePJOJKIArQnIRk8b94KlLYVylSLYCtCGQh0kv460FQsGbF0Ir0aiGpHhXkkYAnKpQrTxRUT9ocLa8Ov7+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by SJ0PR11MB5103.namprd11.prod.outlook.com (2603:10b6:a03:2d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Mon, 29 Jun
 2026 11:40:01 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 11:40:01 +0000
Date: Mon, 29 Jun 2026 19:39:47 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, <aik@amd.com>,
	<andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>, <brauner@kernel.org>,
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
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the
 default\
Message-ID: <akJZg/2P4TxJGBGq@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
 <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com>
 <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
 <ajx5Vrz9ma--hrGH@google.com>
 <ajyJhZcgfYFtGfS2@yzhao56-desk.sh.intel.com>
 <aj0Jf30PS2f7x1nt@yzhao56-desk.sh.intel.com>
 <aj087H1UWSFxbShR@google.com>
 <aj3H2sxymOYTWTnE@yzhao56-desk.sh.intel.com>
 <aj7NwCRwWEfLK-gQ@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aj7NwCRwWEfLK-gQ@google.com>
X-ClientProxiedBy: KUZPR04CA0015.apcprd04.prod.outlook.com
 (2603:1096:d10:25::7) To PH0PR11MB7472.namprd11.prod.outlook.com
 (2603:10b6:510:28c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|SJ0PR11MB5103:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c867b55-048d-4ca5-8bf5-08ded5d3278a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|18002099003|4143699003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: krJrgMsDGR+fnw7RnJ7SPihbyuWO9qRAFmCKJ5W/zMtpXBPUwQOEZoTW7nF9ODmb8Uv+oczC1Fb07egihRAup+cmgPFDlYPMckqk7iAE0wAWVDx4Tn61u/dm5YNyD5lXMbxMi7vL2ho5Yf6mY2EvKe+jGuCjdWRYDKT2RvfqPhmVe07mCqsDBlGeEBlw9NH+C+iLfW7PatJRoND4tmL195q75GnaJz63l72P1SktcNZ5QREopOj+xY2DRaQNtR5G3O6sJGuT+C0wV7ju941kQ4Y1cNERZ/GbzJN6JE5dv8XxSEddCWvFtkYZYCI22uW74u5lWvCz5T5t313vkzO5c7Uma2cMXxInReuWCd0NKKBeUjZDEdbviuy0M4hQGjbsXrfxzjmuV/8B7RbekOCDz5dQphWEvpGolsMoe3yWZ2hHdaP5otVEAxw5QnrA2zEmnGvHc41+JEZr53UmgR+MeQNV0vE93LvDuEyNvqMa/i1ZkNUKQDNU3Zl8C2dyt/xhW6amvFfI9TCpqFD6Y7zdPHIhouGvVj8JTerScg5ce8JVroghH1FvWb86kiBF7uPqdS85dvVp6ua/FA6LmPfV4ZhY8LihEJqJLVcV7OJ86xf9zJ/gxliRyHctZOmY9l42ZD6M2BCNhGZMw4sH00wVaM31ZaUU2LR4MzSiWolv8tw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(18002099003)(4143699003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MctI+KHDN/+MfCiH2PjThHhm/l28rkcJf2F0PTZa9rpgpdIPXzt9RwLsl6tQ?=
 =?us-ascii?Q?Zyf4Wa7yb1S2FJa0fxeThRrCyJERt/2/bSUf7i+Ipvjfi7t3RYomAuocDjaG?=
 =?us-ascii?Q?u5BSXFdB8cLSgfPk0k56w17mvvGYodaCbqrFuRZMkef34ms8d500BKwEBMI0?=
 =?us-ascii?Q?wQc1NzgWBEeYXMSpdsdSnKV3hXyzY77wPUQtWJAP77d0kbUxNvRK5QkboECv?=
 =?us-ascii?Q?Fvxe+GiiQP8vYJXS6gocWrYUYFDuR0lsWIezuvY/4omMTIz/IUb+w1YG+LlB?=
 =?us-ascii?Q?FSpg70NDjKlpU3HB/vnRSNRFb7S1BTogylz1kQnSQjM4PNw7dc4mAYI9ro1H?=
 =?us-ascii?Q?5/2nJ7MvRA3k2USF07FpJL/BZYFJwcOmtGNwVstT7WpLI5BZNNhZAbZ92slQ?=
 =?us-ascii?Q?CAYtT2gEoHBkHUabXHnTf6NRmZCkPsYykp6TOd4y8qlQpVoJRBvWNjGngGEf?=
 =?us-ascii?Q?hthFvpwnVsVDGlSL5GJliD2+lEpXi2E0gLH3YE+VA/Hnz64WLdY0oanbnUGe?=
 =?us-ascii?Q?YKRuM7jc7w9/s9rW0FswCPf7ZY+sWJ0cq32lHO3jTMENfL0E0D2o0ONt74Dv?=
 =?us-ascii?Q?9jIDMPg2QXqxw48i1GikY770UeG0XlINxZdPfK1QRZhpJGy28xZlftI9CDZe?=
 =?us-ascii?Q?u58XcmdxDezx0tH0bI7yjykUSWRxAruN5XXwBC4H025SxnKsARE/MHexBwri?=
 =?us-ascii?Q?uxNGtHmhpOip50tjbX05LRoS+LHyYRSPrza2dsLyLZ7DZ95pH7kuZSud2Tce?=
 =?us-ascii?Q?/q4QSRfMMVOzatNsZ9HnYgtGL2ayUuZrRCYDoaK8Mk2dqor3XesGdPYV1W6G?=
 =?us-ascii?Q?HRCHWdBZBSqih7Ay2s6eRQzcldmQaSUQLOccsGih0Gi/7DxJDUuLCqDRnsQ/?=
 =?us-ascii?Q?B8t/JPJvRt4wtI2dy0km+7niCTh/Yp9J+8Hbd5PrcqI3SI+UyIEluHwefvT9?=
 =?us-ascii?Q?84fBo70SWAJZWuQJmA7sC8pr84W0pCpLCBxxAO/Hi4D0DRULS/ceK9DquvDB?=
 =?us-ascii?Q?i8AgOrHkIA6tK4rUe7Cl6BaFA+PabpbG5EGnn4HqA6dFRPyRv817sDxn0zQO?=
 =?us-ascii?Q?18JcYYJxepWasSWM61rkxkWpTm3oeHNxQ8fO4O75T0/DP1xi+64nyEYR+VKt?=
 =?us-ascii?Q?deinWUXd/OJSDCQDPjBE/6UESjm3xo9I7GMQmbwNwzwadkb/p1cB7YAsVbKd?=
 =?us-ascii?Q?kRKn3bIwzB9T5MHTrZXuvfMrEmgNZQyjWavTGBnFkotQ8U8KJUxXEQhiLxoh?=
 =?us-ascii?Q?bc/83+JoFpop72SxcIbhfOKqdmKgaxO6lqPwAc0Ytf9qDOZSaL1iicxfZCWP?=
 =?us-ascii?Q?AbbKx0jAAHNnFV7Lt4gurSBq+Xnj7GIE+AiDgJjWbfWsOihCbYOvHwfQCSZd?=
 =?us-ascii?Q?8Xvglot05MAakzb5y4D9UHi3n8PHUZNvJBubk5mtfGoAaSmr98qbdbAvWFT0?=
 =?us-ascii?Q?q10aHjtxrtzWJnpicj1wcGeNYL/qr4o+lEpJYmFdpyDpoD0qdssCeCtPu6WU?=
 =?us-ascii?Q?eSvB3lBxOyaXX2AnQsAbHOsxvhvJX8GYaCaHR9Y5RSeSTlhpNOaeDbvskgt1?=
 =?us-ascii?Q?knTT8ZTiinrjdeypiD8dXYTraazix8HX8y01ZBXJVu+7KcakEBtOOjM7pNWD?=
 =?us-ascii?Q?StNyesrZqp0gfGAHOfF/04iNJ/P3pZDJp9aBgV4UQaMeYLyvik8rJ5ZwFsb/?=
 =?us-ascii?Q?GlPJoHaZuCLh3cldx3vN066MYJ+JA0ymAmklbRq82kuebBNMzDnpXQhOnA1E?=
 =?us-ascii?Q?CGNAX0v4Tg=3D=3D?=
X-Exchange-RoutingPolicyChecked: EVGDCS81BVvFz0d2oG2mV8NpYCEIircdhM8fwDc6X2e03thTPbWroPZucO6vNkTOUIVyVWGDjVhdFnOr9dLBuNEv8h6Be+VZqjsenli/YCsTfOTh4BAMRNkJMFI0hR0ISt5MvicaHbcZbZt8TzsRMbaa7Cvzcd/BjfUF+U9NQUZpSM13lOOzSgWZR1XKHw6vxGMno8be1AtheVf50sM+5PyeHCwNb32TRyoeDIHpo5wFsTP6YKzzwhGP17/opm8XZlCDjhxtLsn3xmKAZWnynYXJPByiEZkEQCHuszicJadfGQYoDdn2L1kI8JoaKlLNC4HXtLeQ9Xoldveo9fmFoQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c867b55-048d-4ca5-8bf5-08ded5d3278a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 11:40:01.2802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /SpRTppMlgt4cSQtTIPMBjLsTtmvaSuoc8ncTj8LaGZGP40WJwqlXTXdZ7gE/R9QYdAx8KagIhJfpFXd5gSnag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5103
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 02D1D20002
X-Rspam-User: 
X-Stat-Signature: ezbhc9odcp99xai1njep6jsq358mg5df
X-HE-Tag: 1782733212-949693
X-HE-Meta: U2FsdGVkX1/Ia1odmeGMDF2IQx5BBmXqVWrx8e08BiyR+o18P+3ei1HJ8yY5HCRoThR229vKuEXoH7io6jpHiDvf2zf21OUIjwTlAjUJoOd8tRIiYvl4d7uAoqvsnPWuZ93a0n/u94M8kMi9FweJBZ05WpGW6RuDe8DQo5E8Z9n3kDSZmAlg4xWcoJhLf2IJ/Ip4hAIyhq4RWsgMOiDtN5N6rU8p0fcpy0aaexgj510CMk2gU/G2vRcWGhU7cN1grtCYKlCFm4i0wDx6ohAo4inlhlC08Sw3oGRh0EHlBH6CRw2XC8mNrqU4s6x87SuJRLDx65rc/2kDOfSEjJI5l2ktFAB4KMyCO2BSjVLteom+yes2Gjp8dYcAjpcJLW2N0PogB81okvHTiOHp327Ucb/EatZImwSQtiCY2/skx1l+1Mzc+O0ku8mV3o8PvKx9MZkZ1DJejD5lZfsuF0PjL9ARVQQCh5NlKEl8a1uFKp7pOLLnZcKjMbXSeDzZUIDznqhhk5IuWhD5DU+SM8eBL1dgMWcaOgiuLenAD8oIVT9mLMTyi88cbzQvW3pJGfnqCfVWUCMGomEzbySgJCyBEcORewO0bkNjzIITnffFFnKRs+At+ho/FCL+zPTMtKDdpO8vnOS8ikc8A8gg176JXeT4dmQNRGx8SbyhlgdH85pDk8xE4t0VauWmA5ytzts4b4WH9x2lp0Lvf/dzRijJ+F+JJEVz0ndyrBb0kW0mJZp2SJRRTV+GrjR8FB2A8/pfIlUJ7C9wjimv4znL4SipItSFm8R7vzwrLHcv1+ILPAAPyEBuc7GqEgCccdXjgpHnTOoEFTPSQXK3rhwi4bH5n44jgUhjrH5fegJFzjb39AXzl0VpcoQ/vVwaLcqABPQtQ/w9YxbWwSi6rvkyP6/PmcYaHkzxX7oQSjYmvnxUJFC66K7dSpyQu9nS+tSVODVPRngUdO2u0iU9r+jTDXU
 8WlOXMIG
 7zQdCXp4d8cIVRSHsxEQFyaCsk+oe8VD6ndXQv+u6Anw0gVuCsPK2OlzJen4aspwHjuYwOtkI3L9U8wcLZde8U2kqwNPG9xKomiIA4AlVem92p6AE+2qeI6BJ0IjljinLL+7dtFw8rBNCyL3AsoRBZLqjQwgJyCsv9MaIlixOzDqivT2vShbOUFuaBTqpDIzW6OSxJOKlYsUy8nE/6zbeJe37ek1KpV5gIx9d3RKLfKSieMWIVJqCwFYD+UGzwZp1l4y6g9wlWU5qJcJLmBxPhMVNKY4fB0MHbB2BHWpskqCfLbRK1/c+A0yx0QIjOrBHKmMWz2hArq+OLenRFfFV93U5c2phj4J9JZclQ74m+E0tAPovEyu4rnXzeYwn/UWjGEpmB57LhCmTIn/1X4zG3sA8P2tLslLw9NrTWEC3tu7470bM/0Pq24ir1LmJnmzEdrxSqtLbWz/CWcAFwNnBrtWuL1WXUvdY1H8DvMcUNNOjjU9j3cjqzjEvmI3q54nMWMKrtrclXO+ZJFM5UY2Jn8DJcUWM5HHxVw7devqmvyT6hztSnfJPk/TXYHi2OLT9vkRyEYZVGbzpSJ9FMK9pq8qgVQIaiS+1JD5teyh0TbcLWBHUvUIreTQtpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 12:06:40PM -0700, Sean Christopherson wrote:
> On Fri, Jun 26, 2026, Yan Zhao wrote:
> > On Thu, Jun 25, 2026 at 07:36:28AM -0700, Sean Christopherson wrote:
> > > On Thu, Jun 25, 2026, Yan Zhao wrote:
> > > And I'm not remotely convinced that prepending allow_ to the param will help
> > > end users diagnose "unexpected" memory consumption, in quotes because anyone that
> > > is deploying a stack that utilizes out-of-place conversion absolutely needs to
> > > understand and plan for the additional memory consumption.  I.e. if the memory
> > > consumption is "unexpected" to the end user, they likely have far bigger problems.
> > My first impression of gmem_in_place_conversion=true was that it enforces gmem
> > in-place conversion. However, it actually only enforces per-gmem private/shared
> > attribute.
> > My worry was that people might think it's a kernel bug if userspace can still
> > have shared memory from other sources after they configured
> > gmem_in_place_conversion=true.
> 
> Ah, I see where you're coming from.  FWIW, truly enforcing in-place conversion
> is flat out impossible.  E.g. userspace can simply replace the memslot, at which
> point the memory effectively reverts to shared.
>
> > However, I have no strong opinion if you think gmem_in_place_conversion is good,
> > and with the above documentation. :)
> 
> Ya, I think this largely a documentation problem.  I agree that a param name
> like gmem_private_memory_attributes would be more precise, but I think it'd be
> far less informative for the vast majority of users that only care whether or
> not KVM can do in-place conversion, and don't care about how that is done.
Ok. 

