Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CCFBCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF496B00F5; Thu, 25 Jun 2026 20:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FB26B00F6; Thu, 25 Jun 2026 20:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 120966B00F7; Thu, 25 Jun 2026 20:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDD5C6B00F5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:29:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3969412030F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:29:33 +0000 (UTC)
X-FDA: 84920180226.04.70B933C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id B98E1180006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:29:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TWs5qg2M;
	spf=pass (imf06.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782433769;
	b=PUkOapo0YkwgJt8tIh1U4yJYTx9H+R838QplnWOiBsJ3BKRU7xgWCAGcFIMso7dS176ohV
	Z5r1lQNiDUViVna+i/uS42xPb6rGH00mk6G7Nb7nxPSxSl2QBH0bLXfe8tIndobbKFgo2N
	rWBAHX4VZ7YehcUFLuj6yaLY4odHLjE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433769;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pw2RLfFF2aKP1vvoLRJnZ5aff1/WtdjX0OAAVI5NRKM=;
	b=URksErWqsdnMDIhzZuqhC+62Ybjwz2iyFBhFl8uIu0iMR8+AVpAksweszD9tG2MfY97AqZ
	yIGZrlldSZq0ufu7Pn5JhMyIA56mYOMCGeK2NI9qauL1jOe6XuuKRkjVXxUdeRleHmQSy7
	kYLCRimCyc5g2/veSvPl+JWMza1AEO8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TWs5qg2M;
	spf=pass (imf06.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782433769; x=1813969769;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=vz7jqeuH242wNbIlyAjRL73YFYLgZeRy54hjnjoZ+LY=;
  b=TWs5qg2MP5nobMcYCgjR9RNXEXscFrYY+Tk6pX0U0rNXIurEAxDP2yDe
   LpZQW+0MdPs4Ml75hx/tlPEB/OpSG3G7M8o/cdi3f8qJAsjMI1V1kBKqe
   fgeoSsqUIYlGOnHF+8bc4S1aTOn7yNU4BvkbuncwDPAIk0RgVu7yGd8jf
   1F6RzYoAHHfhQDbDPWxgi8TIsAb5vCovnasPYZoViv4aGHLQfCXpmlnuj
   DbbNmJYWl0oLj6VrRaYGIMQ0a9xSVh+vrvAqdkzbpyApziHh0yhRtAq/r
   RR8KVxzUQ5c+tYkI44fzSKgV/aKm9Xu1355GpLjm8IyB7cvNFsGC/FFov
   A==;
X-CSE-ConnectionGUID: Jcy1+mQ5Tf6qpUrxF5wpTw==
X-CSE-MsgGUID: 9mhG1wC7TSqTYkhPRp9gCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11828"; a="100653447"
X-IronPort-AV: E=Sophos;i="6.24,225,1774335600"; 
   d="scan'208";a="100653447"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2026 17:29:27 -0700
X-CSE-ConnectionGUID: pcnBUKoqTXezPt2+3iBf1Q==
X-CSE-MsgGUID: kyl3sDXxT1m2m8LXhZPDjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,225,1774335600"; 
   d="scan'208";a="247224111"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2026 17:29:27 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 25 Jun 2026 17:29:26 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 25 Jun 2026 17:29:26 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.66) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 25 Jun 2026 17:29:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JN4Foz0NdkP8cogvISD+4e6M35MUct9KRMJ4SB2pFncwHRZqbgadlXKL9ZZoCWOMs3K5QFPtKjFlWDMrAPd8ym2VS79zT+0kqjdA2PIEVlYs6XWOJ6rIpM+uOdeSxVcEk/5blwA8rms4nY+WUtNLjH/2Z8MBNiAzAXwlYb5woFtvlb5WbbrYFZvB5JxcsPm2duRI3jTYf2PADK3L3XQT8J7e0wGD1t+EROyGYFhMwSUdySbocf2+ZmQdXYS5g1brdmvaSfxoqDuSlEtE9FpYvJGlBJapYsQJA8vBcFxlzQkshkXdlW6Uz7fI0kxTArmw0xyWEw4q7nkCXr9SqkQ89w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pw2RLfFF2aKP1vvoLRJnZ5aff1/WtdjX0OAAVI5NRKM=;
 b=szfV6iSMLZWKNfJ3arq2+lugZpHzbjYeyIC+cmdAzlOXp1001wmWHw4VT0K0yK/Ov5IupL4X9GBjDTq1SUI1rW6UOfEXuGA8TjnMTc+T9evuCqq7K+vF6DWEb1N4asdqfz+BmlUO70cvr6i67tO/vQUu4CnPct1TD3p5H2xwLPILQ7/iuJ5Nt1rxx9j9C9pDJLc5Vt+z3FMhJ85F2voQHUVMXj/Jn6u+LaGpgBXPr7X1gJ7X/lzVuegDUJQ1g2PK0adFxZaD25WsZNMlFB9xPbHwf8h7eriEdsSurq6IVBkqwAFGCA8pKYppFBUshR4gKxIUWDxU1mWFMj+7VBPCnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by DS0PR11MB9478.namprd11.prod.outlook.com (2603:10b6:8:28f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Fri, 26 Jun
 2026 00:29:21 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.21.0159.013; Fri, 26 Jun 2026
 00:29:21 +0000
Date: Fri, 26 Jun 2026 08:29:14 +0800
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
Message-ID: <aj3H2sxymOYTWTnE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
 <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com>
 <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
 <ajx5Vrz9ma--hrGH@google.com>
 <ajyJhZcgfYFtGfS2@yzhao56-desk.sh.intel.com>
 <aj0Jf30PS2f7x1nt@yzhao56-desk.sh.intel.com>
 <aj087H1UWSFxbShR@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aj087H1UWSFxbShR@google.com>
X-ClientProxiedBy: TPYP295CA0059.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::20) To PH0PR11MB7472.namprd11.prod.outlook.com
 (2603:10b6:510:28c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|DS0PR11MB9478:EE_
X-MS-Office365-Filtering-Correlation-Id: edbe04b9-ff0b-44cb-6c0b-08ded319f758
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|7416014|18002099003|4143699003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: qGWFB9ItU7saGCKdAwdjYr7dYQ+oB/2V/9VxjaFlLfZ9bZBndD1s1bya3zrIuaUI1bv40YYlWuw3wJRAXSDZFOZP88XpYa2QIYPnGRYG+Bnt1jrhToJmmT5YrOiUKXZ4jDL4tVAFrbL79hfcKOeW2mY5MinnlzJgabAwVS/vtSp51U/5B9cRkeV6bPdOaZwgB6Trfv555kBUvBBZd30z2fmF640z1NNXpMY8GBQJbg/S91dkOpAG38fQdIUFQOCLqF3zDvSkK9G1g5fOtKAK91UTpDdRSvKq6VMWDHmyu7t5iV0Iq3Ls6p/ye8TLN7XN6NoaKMe0qGWarrlhPjw2F4EIkAd947hvBwBUyKsZCCG1P1ivA4J/248OhYh5iB7lp5ygIvxLDBLi9kSsYH98RIfMNky5qh34jGW6QBwY0GdKMpvFKf1+AME+J7Y6Amcukk0EnZMt/jfjCl/bFZVQe8RNMTH7G9XFXWjavQ1TjMdNGvip7CyBmtiPU5tAokkJjuN0RzN+1g78Wj94Xgwn9jDWStIF3WKfArplyZf66F05dstpjU1P5F6mEhAUytNk5nRuRCd3lr7odQwrldWLUHjMr17FE5Q30klEAg6k+TNCh96asL5Hp8/yQ0B0eXNna+qTG5Cu0o9Xp84/Z9o8Flv3/z1eHh0ovWis6Iu7Y4o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(7416014)(18002099003)(4143699003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/VfODIwbG1qQI2wmLO9N9CEdmMv7iI5LACYrCdlpIvH4b1n1Rb+cDJyFLMkU?=
 =?us-ascii?Q?ztE/LkPNl9DYd4OskeFEMuel1pMU/p+Tx01sjSROPH1ziTvg6sfpVjx9xDy1?=
 =?us-ascii?Q?HptB8JeKEVt4T07W+4vmFqW5+nRWrZDu8SQKR1esbuu3/BrUssULuw4WzdOx?=
 =?us-ascii?Q?Rtorim3mh3G/BeEBhAICmJn72Z5auMVZIa0tcWbN0og4T0rMCGLTKftcHD7+?=
 =?us-ascii?Q?mMcTH9MpqMbEN02JeI14gbGiAxmwgpcWedHDtwqe1MICVCp8o6KtBhAsV13F?=
 =?us-ascii?Q?Em0WWZvEeOljdHULCC6JubQDWTos1Z2L15p63RuBtxLRfYhukqoabDlKIMR/?=
 =?us-ascii?Q?n+vsSPs/mEJsFpKqvDkbPcCATGIapsgJkoD7D/LPQVfere+lD7baq0DRpwwV?=
 =?us-ascii?Q?6rlZZxgVDZkGxa4H3r4NwrwDvpQw2zz9dwr1endaNxUNwUXhKwvsEkNlvSRs?=
 =?us-ascii?Q?+vG2FiEpwnyrr69YUCRurJizk33/E5pY1D0hbuZBE02rJ9+9ONZRmbhO8t5y?=
 =?us-ascii?Q?IBR6+EC2VamfOLkajRC47kB7zUlpCHrNgzBLRI7Jnam6E0KIJAg1/ETJTxvU?=
 =?us-ascii?Q?wmfE9j7mSIW7PIALS6dgB1KFnGrp6GRvM/FAEdYXKlG7EBfwAb+S0A90IN6d?=
 =?us-ascii?Q?dfdZKHMMIPtwuHLZuBlu95jOUwpS0xc4zefFRKtwaaZKaEqHNGkU39IK+ZfA?=
 =?us-ascii?Q?o+pp39/CpI0MIqt+AVh5Xo7C81T1ig4Uuq0wZZcqu4Hmi+2/CyS63x2f7UGj?=
 =?us-ascii?Q?/OvtlfbuLhVdzRRpXvUKTmVBFOmLXw7JHxEqvnI2nhOG8Y0x4U9Pxw0cv8Ne?=
 =?us-ascii?Q?+ISk9sjpDQ+IW/0ba31BCka5ttvufq466T2cbXrDFbV94955OkzphBay5HLO?=
 =?us-ascii?Q?szOGMsGtF8eb5uVZf5JoGJ4f+YRrIryQKCCNX+ZIctZURsQkrcYDQyZrdR/V?=
 =?us-ascii?Q?mlYJ9MyRhxhvQ9H4pRpzU7jc6wLwcij/oG1ZYd7rIexbP4elIbGopxzDekQH?=
 =?us-ascii?Q?DwWNZOh0auxBrtDyrt3jOQ8QL3S4s2yfXbOorRN2eg/BhwwzUPx373/ezrRv?=
 =?us-ascii?Q?On04OTW7Qs+Fyh8/5BI1Eddzd5t32o8PK0l7QdvQc0sp5V8txokg++7N7cPx?=
 =?us-ascii?Q?vurT9dN3KP1XU737x+gC7270JqWvgFyFFr8JAED6AFCNgXExrrJ+74/UZel2?=
 =?us-ascii?Q?mXXIcCd5IQIoRySVdK5DIPFZSCjSh2kfY9MvDyMPd3XoC0Q7I1XBiFKp3ph8?=
 =?us-ascii?Q?qpOTh9O3v+pET2UT4T8KFPEV7zZTBf4c80RBqVbScrwe2gHc39tusLOdzR2I?=
 =?us-ascii?Q?tP9I4CUs3g5uyXMfTlFno6FA/QAEDUSiktSLbnTPjxTwFyJmTDy2u7ly14FN?=
 =?us-ascii?Q?odYK3cPyRS4DwKyEL62bYMxaQYoGjFJmDVRfSD0Ti13DlZxLKDVq+8+imxMd?=
 =?us-ascii?Q?pdAHklVjqYOhS1iU8dqWzpzAknOuVUGaCxAj7bCWVlkU8aLbBQpSetVkKWGd?=
 =?us-ascii?Q?IdinmrLsTCPQE3emwnM/MuJr+I1PP07QrCyX6egzUTvTkze4lHVtrOuBMF6p?=
 =?us-ascii?Q?dPLxkJrDoZuDEnmJ0btyVG17vLh37L5RIuNSXsnQ9k46DFHCi0Ef8zPb6dXW?=
 =?us-ascii?Q?kp9baf9jZSsSLboUr/RzmAvdJBKt7anKKjhn1Rd5bMta8H4cZCxKHYZ0EgOe?=
 =?us-ascii?Q?JHjBQnIPt4GMszpaB9uUtSGdWm6MltIm1TDw5mD+6dQ36WzmoaRfGdq0RJJp?=
 =?us-ascii?Q?lWxuBxrpNw=3D=3D?=
X-Exchange-RoutingPolicyChecked: MiVp/nsJl9GXURER+6Y0fOphR3M3M1UlGz0j9zj/dAptwwMyKeAtL3NfEmY2vt7Y1XzZwF11JKTFpYHtragj1LwSC4JSpxKsvUYNUOm75+ig3QqqTgIgA4XqRO1fAX5jfwsA5GiOkxr183fEV01f71Ik1dG2JTBmAEAPT/0BIFeIbpPtHUwAHeGFoUSwefPftIPQhIkbroWbXvO8TKIQ9yQMryjXcA+SMxFqCZD6gber/eFaQlbwFsNg1yXOIojiV+Z0sdg92YzDIunTxGIM0Ib14MAYVC3uqS/J0yLqkJihxyAQm/DTRr37cxJNdR6aSpBAaCAt6bg9DmhqabVffQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: edbe04b9-ff0b-44cb-6c0b-08ded319f758
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 00:29:21.1964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pj6Hy/iV5z+zESwbjfk63920OwPuV/BoU9xi5yxCdp2FR4Ps4paagXPmG1wnaNfnVVFDPZQrMS2gPbaHJoccsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB9478
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B98E1180006
X-Rspam-User: 
X-Stat-Signature: sz4rjfd79c843ysdfwbzkssewansyncx
X-HE-Tag: 1782433768-775650
X-HE-Meta: U2FsdGVkX1/gZpq8FuxJbnhyRfaBlHHk8qWY+PzfE2SL0FzV49StIKUGgC1r7UYlp4p3rnDarjq7AXLbJ1V3wpfpotJKnxLMJe1UDk0y/XAkweeuC+mFVL+maLJcUJc0lPsVk0N2TUnrWzx2Z+r8NAZC7LDzHAN1o+Hwtp3jraQ4h5upDFBsljy/92AVFK9xrxxEGgHjDgdlgloV2QsBpapM+biOQhGeE/I3NF7eVwHIUh51/AJsU2w2GulrIxJMDGiL2xb31Rq0nsdZjpcGxThdjuMzJHxvsFrRBC6VreTMzs1pBax1qzJU/PAymvAEIiCF/MHLdnHoL4pB/J0hJJ054CuVdLwLgLNg7T/6rxgiAioIs0FkO0G1zJRwJNxd+83044wnvqyyRrr3OOtZiQTa7BNEjA/PsF9wBxiKd+o6hQciIRALE5e5DzC8yNKDHEb1jVMmF+0MtKfQ/atd4CGr8AsIoHArikUojdOIu23lZd6arLucykf7Hok9VDjtoqKnIhcLBsyzF19C7zYO7j+IRiJbAwjEJ/zllD2vBt4ySKPehwJJftbh9yymMTLT5j4n8ea8UUd9L8zEOwzBHY+j1wYHXVfirho2fJNjmHzc68TxI+4NPk3qwzoH771g61h5i750H0ISB0mQMgEWrnI+GulHv0Ywd/6lgsTKZQqVySKPBoL9PRemaq7xxKSih0K3fB7YVq83klg2MvNgQOFBkvw29zoR+/HqPJSmS5LoC2kTIQL+x5RsZTaGKLox3D/QvW0i0YdM1wMI+8daHpki+N7PHZAScSYpHY1EJEo8EBgCm5yCt4ceSBBfA2JwbOc8lKU0C1b9tiwZpPjaXrXrN2RbZqA0j+gKaKLV5ApVOirVIqFjnsgUvq1QGgMv2LiZzAO22exo3Q5MDeLNeenslF/faAzIuhPz7XUTb97XHsSKFHNdX3PtNlgRq+P6X6Ize12Ap5vKc0I+42Z
 evXXYpEt
 hkolr80srZKZSdk5ZPbYYrUR0vyyCHQ6CDqixjyRd1jHiZcpN4rjBnRoQVgZmL2WKW5ZG4aikjlsrBAl2fuwaIotFJSnMFqFDDa2RQVJdasDt7C02gvnLL8X8CoXGwMQ/py80yS7tajzSNh3nCy3+REqXCeMoHf8mPGUjlojPZCbA8Z4hmYgqPmC+CWMGM29xJX6FdGhEudeYXTMtcUR8oiAermb5CPJ+pOrGytsFV+AHxoP/xxnWwv/Mp12n6WQrCYncMmTtZ18I+U3Pks5Qw6tSwyx+nY55muzxJP5JAhvIHBuMM4+yoloOGZwfk2xZPdtU1+njFdtEJpSryhjXZFMcM2QSSXatDvpC3wsIgb6/0oyS417BtfKnOH1pGV2WynV/rnZ0LWYSP2/02gNWwh0ICgVUsmvWy/cewo6w4Fl5UFCMwyZrp459tDfKskrwa0iZ0LH5MbU3aLYwxRLU5GYjmh+ryETvxifgOTWJiPO26oYr7QlJiGjSkGvjaVK39rxZk9ZNa86cGb6lRdNnzSi4yqgIXUtyqjOWyyr/Q48Pn4mhqIRmWkdW2NTzvDx5LUXiNCLmATOYbMeIqeMYzDNSlvKBZE78wuLkfq8QnTQY7aSnETxsq2zUMKQnblWWBj/EMh3684Zm0g4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 07:36:28AM -0700, Sean Christopherson wrote:
> On Thu, Jun 25, 2026, Yan Zhao wrote:
> > On Thu, Jun 25, 2026 at 09:51:01AM +0800, Yan Zhao wrote:
> > > On Wed, Jun 24, 2026 at 05:41:58PM -0700, Sean Christopherson wrote:
> > > > On Wed, Jun 24, 2026, Ackerley Tng wrote:
> > > > > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > > > > With gmem_in_place_conversion=true, userspace can create guest_memfd without the
> > > > > > MMAP flag. In such cases, shared memory is allocated from different backends.
> > > > > > This means this module parameter only enables per-gmem memory attribute and does
> > > > > > not guarantee that gmem in-place conversion will actually occur.
> > > > 
> > > > KVM module params are pretty much always about what KVM supports, not what is
> > > > guaranteed to happen.
> > > > 
> > > >   - enable_mmio_caching doesn't guarantee there will actually be MMIO SPTEs,
> > > >     because maybe the guest never accesses emulated MMIO.
> > > >   - enable_pmu doesn't guarantee VMs will get a PMU, because userspace may elect
> > > >     not to advertise one.
> > > >   - and so on and so forth...
> > > > 
> > > > Yes, there's a small mental jump to get from "KVM supports in-place conversion"
> > > > to "I need to set memory attributes on the guest_memfd instance, not the VM",
> > > > but I don't see that as a big hurdle, certainly not in the long term.  And once
> > > > the VMM code is written, I really do think most people are going to care about
> > > > whether or not KVM supports in-place conversion, not where PRIVATE is tracked.
> > > Sorry, I just saw this mail after posting my reply in [1].
> > > 
> > > I'm ok with gmem_in_place_conversion=true just means KVM supports in-place
> > > conversion, while we can still create VMs with shared memory not from gmem.
> > Or what about "allow_gmem_in_place_conversion" ?
> 
> No, because turning on the param also disallows setting PRIVATE in the VM-scoped
> KVM_SET_MEMORY_ATTRIBUTES ioctl.
> 
> > > Though it still feels a bit odd to require TDX huge pages to depend on
> > > gmem_in_place_conversion=true when shared memory is not currently allocated
> > > from gmem, 
> 
> I fully expect that to be a transient state, and in all likelihood not something
> that is *ever* shipped in production.  Landing TDX hugepages without guest_memfd
> hugepage support is all about avoiding unnecessary serialization of series and
> features that aren't strictly dependent on each other.
> 
> > > it should become more natural over time once gmem supports in-place
> > > conversions for huge page.
> 
> Yes, and I want to prioritize the steady state for end users, not the in-progress
> state for developers.  Once all of this settles out, I fully expect the majority
> of deployments to only support in-place conversion, at which point the end user
> is only going to care whether or not in-place conversion is enabled in KVM, not
> the subtle detail that it's still possible to do out-of-place conversions (and
> that will always hold true, it's not like VMA-based memslots are being deprecated).
> 
> > > Besides my current usage, there may be other scenarios where gmem memory
> > > attributes is preferred without allocating shared memory from gmem.
> > > (e.g., PAGE.ADD from a temp extra shared source memory).
> > > 
> > > For such use cases, I'm concerns that the admins may find it confusing if they
> > > enable gmem_in_place_conversion but still observe extra memory consumptions for
> > > shared memory.
> 
> KVM can help with documentation, but beyond that, it's not KVM's problem to solve.
> If a VMM *and* platform owner chooses to deploy a setup that utilizes out-of-place
> conversions, then it's on the VMM and/or plaform owner to understand and communicate
> the implications to the end user.
Thanks for all the explanations!
Documentation that choosing a different source after enabling
gmem_in_place_conversion is deprecated looks good to me.
 
> And I'm not remotely convinced that prepending allow_ to the param will help
> end users diagnose "unexpected" memory consumption, in quotes because anyone that
> is deploying a stack that utilizes out-of-place conversion absolutely needs to
> understand and plan for the additional memory consumption.  I.e. if the memory
> consumption is "unexpected" to the end user, they likely have far bigger problems.
My first impression of gmem_in_place_conversion=true was that it enforces gmem
in-place conversion. However, it actually only enforces per-gmem private/shared
attribute.
My worry was that people might think it's a kernel bug if userspace can still
have shared memory from other sources after they configured
gmem_in_place_conversion=true.

However, I have no strong opinion if you think gmem_in_place_conversion is good,
and with the above documentation. :)




