Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A0D8C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 05:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E3B6B0092; Tue, 11 Aug 2026 01:32:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34F586B0093; Tue, 11 Aug 2026 01:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F0E46B0095; Tue, 11 Aug 2026 01:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD9226B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:32:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5CD59C031A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:32:01 +0000 (UTC)
X-FDA: 85087867242.05.3AD46D9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf19.hostedemail.com (Postfix) with ESMTP id E67361A0006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:31:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GkJSPjWB;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf19.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786426317;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KXDPQQNVKEUfl6JkIsw153TEE64qimqT9wwotylWm5I=;
	b=41892ogDT444euS1o0MEXZbnJmVpPYXj7Rxn0GJ92ywFRAA/q/uT07rnkhePkC/SxaeFFz
	xjgEI/GxoVMhconXVG/8dOHlwH8W6Egy5MRpABt1KQGTLnZWyP9R83JVBLCwXx+xfCNG8e
	3zwQdAunJx6MhTikILuzPui0Xm3C8dg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GkJSPjWB;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf19.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1786426317;
	b=5tP12oQBzBYugDBZWZ4ZvwslPcKlrxxNsIu6c4BOq0V9h8g4zz5RGrx1dRbU+7tzY96rp6
	cvbObTZ+tiJyIkhVO5zhdNtCnlOm2tvGcSP873G5ai9VhkMZmoo4ObA1pzt+WD3CCCV5Ht
	j4XRL4KF7hPHfY8LzLdfonHqlIFXLh8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786426317; x=1817962317;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=pE7s7rvxHQKRrmhwdR9++C7UnfVHT4/S+5/AT4Za56s=;
  b=GkJSPjWBPYD/w5sgf7AS84aNGcRg7hrFFdxavYG9p7uGIIbNT1LdfpPf
   Rf006X1dZyMU1P01M7UJ+AE8mzmdbejlzWoN+oFeAS98es16BEHIMFwrB
   W8co/p52Jgh+ycByR8JTkdv+OBKl6tA3XO3CswVU7mK6cuE/Kf8Y4moFe
   gWk5PrO/Ny4nbCyaOf6HyRdMHv94p/wyPLmgcmlGlnN9vwaodeEXhyOBX
   ZQjTdXPHJJsEXNpZKX9PJN5QHbGab9SO4B5FX1wySOD1I0tpkx98gvkB0
   cijM21FgEdhzN4lMAAZ5ttf7XeSnv0dmmnrNKFaiVDfMEinRbbvw+bUOo
   g==;
X-CSE-ConnectionGUID: Ba5+h9GWQcu7eAiM67NaSw==
X-CSE-MsgGUID: 4Yx85335RRKl2pyLviRg/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11871"; a="86070971"
X-IronPort-AV: E=Sophos;i="6.25,217,1779174000"; 
   d="scan'208";a="86070971"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 22:31:55 -0700
X-CSE-ConnectionGUID: Ps9ZGFqrRGe3+aiZijArcw==
X-CSE-MsgGUID: q+LmgAQTTCactctl+pzZPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,217,1779174000"; 
   d="scan'208";a="265246577"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 22:31:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 10 Aug 2026 22:31:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 10 Aug 2026 22:31:53 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.68) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 10 Aug 2026 22:31:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R25YZg5A1O8jaos59md0trIvAF9cMpefwEQH/Gqd3n6gh1WukOD+ni7CXOF8DrkGsmOsomnCHoGvQ+CNyamHNEbDsDxmlh1hUCovW93PEZzgHQ3zk4dTr/YHhZADlqqAPtC0GhWIlq54LnoMyS6YwRO0kJF72tfgXavmyeTh2meGhRrrQ37SyWtljuykWwyGbUxGqKJGQMjvYHVeha2XdQ10OiNscPNLfdtrmxX0dKIFIZMpZf/KEXQvcYkThBiauuumGLuf8vggQkXxTKaotorPfEJtfrnJeGWhEkN5AOBGzxUdFJGfB5H+osD//jw0/0t44DwDgOfQdTH2G5ofKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KXDPQQNVKEUfl6JkIsw153TEE64qimqT9wwotylWm5I=;
 b=tGzKqe7uBMDIzQsUvRuQjbx6g+nQ/3MdXphAy30MD4c+LC/K/U+WVvhwJJD55lLEAvOvsmwdidGeXwvGvZel+u+LTXjRHT6H/4ZdSlMSYkCByn8YUqfWe5nAMpWYa7QOmUr0QwWuOyr4krUfX1TgyFrbiFkPhIQQntKyia6iato/eVmuSNy6cvPaleJyzUFxzSld3pb1zZ1aFoctM5xWKS8co6zmjO2E7eN/qTSU0ELXjw2aqU4UOX4gQWaq5wACHt7pRAjx5u2gNTuLdVmVibVzZfLNvcB7IIkIpDvXj3+reDJgK6xEKy5hbcffpmyDcbh/uteR0ItxCB/oQuci4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
 by BL1PR11MB5288.namprd11.prod.outlook.com (2603:10b6:208:316::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 05:31:50 +0000
Received: from DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d]) by DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d%3]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 05:31:49 +0000
Date: Tue, 11 Aug 2026 12:50:48 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
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
Message-ID: <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
 <anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com>
 <anj2bPrGqzZgZWMF@yzhao56-desk.sh.intel.com>
 <CAEvNRgFzRj_=GVy8T4P8ehhQjYomYxkngzwtKBF0iEL0Cv6fuQ@mail.gmail.com>
 <anp1I64K0KeyQuyo@yzhao56-desk.sh.intel.com>
 <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
X-ClientProxiedBy: TPYP295CA0016.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:a::8)
 To DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DSVPR11MB9579:EE_|BL1PR11MB5288:EE_
X-MS-Office365-Filtering-Correlation-Id: 200641ab-e2aa-41ea-76bc-08def769d788
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|3023799007|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: RQCV23OFPxH7TCgCW/yTZmlbe2MEOHhHeHu8BRVWrcihV8NF3MjZXd7Hs5yq//4YjXd3lA1gIMLOwOLrvCejLTCwRzMxA9/63ReKAfABdius5ChK5cTTiJR6BKXZrInyMQYY/dF84aI2PuKeHp4jIKv8+82MyG9OfC2rcgX4cwjzBKhhYwzRQrduFb1nIiaqrgCQ1sUeo+dW0oJhBesQcbS/y713Lknw+9xBO+DSxDaNn7+1UKZSoN98Fje1z2VKPJ5yIhL5gMMVhjJ7k29FV83dyfAP0tMuaINPExW40mdbKR1x0x3ZkTOUydi8y8pk/nbVC+fZXvhXFohH4OPcUYlAIilAkAQ2I3hMNxmUii7UhbK+XwqQUQGOnWLamNN4mLXaJy1OSLh9krQoBi4r7PPQC3RuV9IX5P0YjgGev8QR0+XtbuZDVcKkFuWt8S5FUEhpvPJQa3E4J+AKRNew5mVAoPcSeDjQSDo6UfRP5th310KB5oGt5kzJdT53d7Ujv+gLwxXSvBay55J4Sab8JSiK2N1aVXUE4w9xyLgoJLp1yNYTCEYD5gnj77/3Q+2JfigHAL8FizwdtqoaPxVuu2r9zV3nnNzaenYzStTjf7aJlx5lvD9e8HpDZ2R6bTBX1aH2CwEcBmd6lIFYt3vVhQre70j/X6qxsT3U/CVnYxc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DSVPR11MB9579.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(3023799007)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QE9YXjw2ig4X/YJ5qRpu3ZLgV015unQBRjOHF6VTFjkf1Mp1FWwB7NJ32E6u?=
 =?us-ascii?Q?nNDYA6tabgI8/zfh9a+p4rTnQ/SG9+yC+Cj2I/ELZn9p38Msh5G1sehurLIo?=
 =?us-ascii?Q?09zkK/5JzCXpUqsXUu8CL4HMnznbue+BZKsUK9G9td4TDkiMSASz25ATDHqA?=
 =?us-ascii?Q?W7Z5JdJw7vPQ0aegq+mO/a1LB7XHFFXKeNOiVRWwRw/Tvm6d1FmExQGpKpq9?=
 =?us-ascii?Q?xk7Roh7lqKRhi0mmK+oX1INdMaRqkzN/AKUFKT9BJMz+n75OsLA6OLgy41v8?=
 =?us-ascii?Q?FbzhclCMXolZoR4mRoFAz8eEbJkbHL/nJNEjMD/RzRUfVvuZUe8riFBZhfoJ?=
 =?us-ascii?Q?/ysTdXY/iNGpzf3ESLHAPeR1OtwNkqFrBdfIOCSQC3EK+/gjxpxPQ2Ittz2z?=
 =?us-ascii?Q?63G/9a5a0jsFmCHSB1S3lToAwJKCP50PLWIdtLnvvRqEWAOLVZlE3rXjUE49?=
 =?us-ascii?Q?Ate5Z2YcaHx4M2QQPZBsM4sdrOxHOnfxayuqW7h/Rv1qQIsJ8ZqLsGRgRx6o?=
 =?us-ascii?Q?lEsM2Am0dz2YX25X4vI/XfmecqojQD29FZuvAqG9/PqBhB8KHolBNWXnUWbV?=
 =?us-ascii?Q?qjpN6+gZ78nex3JIHryOvCvbtVEcHYNofSksxzfPs+hYcbnc5a7Dpxi5b5tY?=
 =?us-ascii?Q?z0FBV15kDr5U8JVqZhT3PuCdaNNJ6iLhHQsMNH/lptI3IyU9+vzkH9rjk8e+?=
 =?us-ascii?Q?j7T9jOMSzDmOsJo0s9d5htREVBzd4rw/yZgaczjfIyNJM1CPrP7hbRSGG/Ff?=
 =?us-ascii?Q?l2+knzX24kxwBsyc5HiL6f1smx4ZQ3iUoZzRSPyjhshZJy/L/zn7EIZdZ+Eg?=
 =?us-ascii?Q?GZqFrtev8y01vl0YCTtVYpKdGIwFvsaUHeyKOiETrdWYmjNx0J7OTpYW4jun?=
 =?us-ascii?Q?0ErHipushq1sAw8NiZ8T9ekEBE5NxgMfL7lTC70NyVEOlKww1z2YduoWU1wW?=
 =?us-ascii?Q?KNLHZTSYjqfgCjr+MtM1PVBAMd+e3RKaHOIdyuhqHtWUPnssOjr1VRfU78Yb?=
 =?us-ascii?Q?UNIMsqXX1CK0Pw8ZsYw/ltH5+89FuIFECAstFG6Aom6UYIxDJOlN4RWaihLV?=
 =?us-ascii?Q?s/R3WIoZjf9iVXmhITGK8nJBYLqX0mV0aX0q30vVVA9O44B2DejKve3dyZv+?=
 =?us-ascii?Q?fQjRXZqNxO8tJCEQ1VBwX8CuCI0Gcrj0mMoKdpBCjd5TTa16PDEg8Swz0Eap?=
 =?us-ascii?Q?d0VWlPsLtZYx0qGYAZTP7GV1PKhJjdQQbD37UteorAkvfqHDR60XF/AJNqzX?=
 =?us-ascii?Q?Sp3uyEF4AJ+yfJSz6Fnm7mtvw6nN26BB2qeOpGUfdgcjHSl1HtPVzVa1XBKc?=
 =?us-ascii?Q?w8jPOHe06hknNQvrsMzJfBLEeu2X/z0gbhS6b6WmjIF4y6ieg34zezjr+iFA?=
 =?us-ascii?Q?GIPeDIQ+PkjIyH72BvIM4elVMYrvoCi+wTpSCC4x1KtOnZ/HVYOibaWP8gyA?=
 =?us-ascii?Q?AuabMlq6zQpilcQpklKd3Pe5IiCt9vCBB9y4ZwdKKF7fz/GlqO2pOSb/IaW+?=
 =?us-ascii?Q?TATuUUdFY2dH7DxTf/Ik9OVkejGFdh9on/koU22N3Yty9CEMIt/xJQ9Po98K?=
 =?us-ascii?Q?8SoX0XXigs/a+yXkwEaQ7lUY/hVvXpZIk2HVbxkkq/KHnLswY97SY7kfxFSN?=
 =?us-ascii?Q?MKVp0C4IBRFkkmxF3awvHAsqbbXWbHP2WuSjZeRrgdTVPv6W8xkfY2EScD5G?=
 =?us-ascii?Q?50hiZqsqiwT2ad/yQ7phgGAB0awC035T9reFWeG1HsnsWfIFGZa/RwQreSnD?=
 =?us-ascii?Q?c1+xK5yaBw=3D=3D?=
X-Exchange-RoutingPolicyChecked: lfpzmw1k5ZDzreQV3uR5RsnbbLKOonbtbGColL0m6E0ZBVPjmdYBxVhQ/IYKuftumUNPDkrosCvVyGcGlodzOV6R1ZqPeRPKo/39ZOXdcx/6/7Gh9xX60oCL7twSMxJcsUE8y58gN5vOx5OiUVAUWuvvaJPOKwcT5ZvHWROFbyVUzGoqM1BB5YTX5a5qd6RoNFxCYy0pZ+Jjgi5IFzhhQ9lRGdbuVrR6GV1XTpoDn1WENyqIFjz6Ea2oXvRf1IzQSKyCUJMy5d9Z1HpWowKUTHHbRERnK8avf7g+v7ilakcFhThD/iAwHb33m5hRvEIGQfFQ/658AK1YjGSlh4eR1Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 200641ab-e2aa-41ea-76bc-08def769d788
X-MS-Exchange-CrossTenant-AuthSource: DSVPR11MB9579.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 05:31:49.5524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nluw9H9XZCoBiTcb3C/HcSjw2TaGSZgLzb5HXEBgTaLv2zcywo4HEUIkxGAizOs/uGx6BbdvWeAV7Q4f+3TRCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5288
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E67361A0006
X-Stat-Signature: 3tcnsshwx5jrr1oxoa7oxasfuu8o1dj6
X-HE-Tag: 1786426316-899641
X-HE-Meta: U2FsdGVkX18GozloyN6XJixCMpH7K4sVZ2rdNmMii60dd8uFN4wT4bSRb0frrVTuDQ1EXmmsWAIJsMwepOLid3bkDGAIgIuWmc0GOoM2/S7lFuoa6EFX3ObTBC3bb2CuIB1QwB2WasiMiyS4reZhuYfuu6IAt0gJX7MPHCNo+UyYKRg1L8+RoNJYgEgxG2ueAjxuQ+2c5A1k4rQvtpKorDSwtw8MFHOoVVBGerFRC4vBFs3H66DJPKNYevU17NVpCQRH1fqTSM2tUkrxpVBfttuiBbhnzbr6hJFXEBrXnCPoswrBXuBU3uykidjISD1Jyds7Ayqy9u30DHY4gDrYfQpC5JcKksxepjhXH2RfBiZobcKHTywVG6pkSgQPg6qIx8rZhlAS7GiAytJLr9qgHzH28I3euX6w0tDbDXxRACJjXr+8kjAff6mgbhgob1iSEdgKGxYasgdq06V0F0+yF+jSzqwW2QJnRxCag30oKUG1UEjhHU5OaaIwR2GMLnYiPZfjBD8zx8m9tOZH6MeSfqnmMW/xOlFeV/VpVQyLhGZFb4qr3vZ/q0SggyUFpP4LV1ftlael3jMn0nqoi3jMDVLgR46XJe0K5KNRyRa4S0+qUk8mu+Extlp9vXO5tYm5Wfd9HlJHGSmLll90WppeC0RYuR7hsC+uCpPl9LjKmfso5vhH3PcqQSSnUHUR/TnLEdfxKhr/yJvQ+VBjhdxpoz3jxr72Bb3SUQ7LF+JV6jIeIz6pC5gmOyFWrGELHV/SxRnadGFE6JQhNkRBm+nvupASsnYYcfXVlJmRgGvIMNUzoyqWustTwy8wIP+p9Sf91jyeMe/yiUbUK9ge6qNmp/QdFwjTfacRKYtcG6nKxAw7MfJF+6cRht4W+1E69Pm2I05GjJPiSGSZ8tnwOMfxbB8X9x9q0JVpd3N0cajdisDbuf4WnK8uv+dmJS9qbl//Xy7xLoULtWIoVvw1898
 8FbJRz/o
 mezZs7CNeweXEtYtmi83AGgZ9AULRY0iFfAwqaobFzFMg5JmO8Jd3r7s3jkaReJUDDitJFdvGe6E+GVSfJ5IDx1eH9hf/F5Thxr3NN9ayBEwzbfwZGgB87UmorunfAiYpURqB/4TXsoH1yd2vl9NdGXSlaA61uYSujCBZA/77s6TW1me3WYlyFgC5b8ctuDDLuS/9guMtk+7CRO4SBPUSfgHiYBJIllLVEQi4ScGCDtHV65gN7jugkoxPoZxTO+ikveGbu0GLcRsEAXaIbaiE6JCehZZ1h0QXwwq4MLAtsT85S3Xuuz9FgDfNUVEub9GF8tqoq2aknTjC10x/uvVdGIMhs8Qnm2yQiEs4TieBI8JrJLHjzQiuJExOGQXJ28GLCVHbc3lWqidY0tITE9okkQcDvPz2b4joztEb+svKeaIpSWlL0n4SFj8+iCxUK7yIVNwkt5iuMRlIo5Hy3bL3jukHJ+7Lpwt0Af0DxbOrXIWoclf2DjpuiLrEOB/TnzH1NQbQ7SDv3dMnWfDdieQ12QWcHyZIdcfQgRc6BcFDyVF1jCtaP8t6Bshe/OtaCUbrF0ATfNk3IbtUHUbsCca7LttXDUBirDsN/0NRwmxMdSKZ7OR3Z/6IZVVsCz4M0gVyZLqMh2o32hC6d6E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 07:17:11PM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Mon, Aug 10, 2026 at 02:06:06PM -0700, Ackerley Tng wrote:
> >> Yan Zhao <yan.y.zhao@intel.com> writes:
> >>
> >> >
> >> > [...snip...]
> >> >
> >> >> > @@ -542,8 +576,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >> >> >
> >> >> >  	mas_init(&mas, mt, start);
> >> >> >  	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
> >> >> > -	if (r)
> >> >> > +	if (r) {
> >> >> > +		*err_index = start;
> >> >> >  		goto out;
> >> >> > +	}
> >> >> > +
> >> >> > +	if (to_private) {
> >> >> > +		unmap_mapping_pages(mapping, start, nr_pages, false);
> >> >> > +
> >> >> > +		if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
> >> >> > +						     err_index)) {
> >> >> Note: conversion failures could occur if another vCPU is attempting to map a GFN
> >> >> within this range.
> >> >>
> >> >> CPU 0 (setting attributes)          CPU 1 (attempting to map)
> >> >> --------------------------          --------------------
> >> >>                                  A: mmu_invalidate_retry_gfn_unsafe
> >> >>                                     filemap_invalidate_lock_shared
> >> >>                                     __kvm_gmem_get_pfn ==> folio refcount++
> >> >>                                     filemap_invalidate_unlock_shared
> >> >>
> >> >> filemap_invalidate_lock
> >> >> filemap_get_folios
> >> >> check folio_ref_count(folio) ==> Not match !!
> >> >> filemap_invalidate_unlock
> >> >>
> >> >>                                  B: read_lock(&vcpu->kvm->mmu_lock);
> >> >>                                     is_page_fault_stale
> >> >>                                     kvm_mmu_finish_page_fault ==>folio recount--
> >> >> 				    read_unlock(&vcpu->kvm->mmu_lock);
> >> >>
> >> >>
> >>
> >> Thanks for reporting this!
> >>
> >> >> Retrying in kvm_gmem_is_safe_for_conversion() or moving the invocation of
> >> >> kvm_mmu_invalidate_start() + kvm_mmu_invalidate_range_add() to an earlier
> >> >> position does not help as long as CPU 1 stays at stage A.
> >> >>
> >>
> >> IIUC CPU 1 isn't blocked by a conversion so stages A and B should
> >> complete fine, and CPU 0 would already be retrying for other reasons
> >> anyway, like speculative refcounts from elsewhere in the kernel, so the
> >> conversion would take longer but it'd work out.
> >>
> >> Is that understanding right, that this doesn't completely break
> >> conversions?
> > It depends on the timing. The max retry count cannot be expected under unlucky
> > conditions.
> >
> >> >> So, should we avoid this failure?
> >> >> e.g., by moving filemap_invalidate_unlock_shared() from stage A to after
> >> >> stage B?
> >>
> >> Not really sure about this, how will control go back to guest_memfd
> >> after the fault finishes for guest_memfd to unlock the filemap?
> > I don't understand your question. But I find this solution is less ideal than my
> > below proposal.
> >
> 
> When kvm_gmem_get_pfn() is called from kvm_mmu_faultin_pfn_gmem(), KVM
> MMU takes over from there, there isn't another call when KVM MMU
> finishes mapping the page into the stage 2 page tables back into
> guest_memfd.
> 
> After stage B, how is filemap_invalidate_unlock_shared() going to be
> called? Do you mean filemap_invalidate_unlock_shared(folio->mapping)?
Something like this. However, since this would cause the shared filemap
invalidate lock to be held longer, conversions may have to wait for any on-going
faults regardless of the GFN range, which I don't quite like.

> I think filemap_invalidate_unlock_shared(folio->mapping) is a little
> asymmetric...
> 
> >> > Or what about having KVM always treat gmem page as non-refcounted, and have
> >> > kvm_gmem_get_pfn() put folio refcount before releasing the filemap invalidate
> >> > lock?
> >> > Below patch is applied and tested at the end of this series.
> >> >
> >> > From 8c2f29bc15bceb6a8fa103cf2585ec11354fd74e Mon Sep 17 00:00:00 2001
> >> > From: Yan Zhao <yan.y.zhao@intel.com>
> >> > Date: Mon, 10 Aug 2026 06:24:52 +0800
> >> > Subject: [PATCH] KVM: guest_memfd: Return gmem page as non-refcounted
> >> >
> >> > Have kvm_gmem_get_pfn() put gmem page refcount before releasing filemap
> >> > invalidate lock and return the gmem page as non-refcounted. This avoids
> >> > gmem memory attribute conversion failure caused by temporarily holding gmem
> >> > page after faulting and before completing mapping.
> >> >
> >> > guest_memfd always holds gmem page in filemap cache. TDX does not increment
> >> > gmem page refcount when having gmem pages mapped in S-EPT. Additionally,
> >> > as gmem pages are not swappable, setting dirty or accessed bit is not
> >> > necessary. Therefore, there's no need to treat gmem pages as refcounted
> >> > pages.
> >> >
> >> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> >> > ---
> >> >  virt/kvm/guest_memfd.c | 5 ++---
> >> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >> >
> >> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> >> > index 2115e73e455a..e357b4ffa777 100644
> >> > --- a/virt/kvm/guest_memfd.c
> >> > +++ b/virt/kvm/guest_memfd.c
> >> > @@ -1332,11 +1332,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >> >  #endif
> >> >
> >> >  	folio_unlock(folio);
> >> > +	folio_put(folio);
> >> >
> >> >  	if (!r)
> >> > -		*page = folio_file_page(folio, index);
> >> > -	else
> >> > -		folio_put(folio);
> >> > +		*page = NULL;
> >> >
> >> >  out:
> >> >  	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
> >> > --
> >> > 2.43.2
> >>
> >> Hmm going with the above CPU 0 and 1 illustration, if instead CPU 0
> >> truncates the folio and the folio ends up being freed, then KVM's MMU
> >> has a pointer to a page that is already
> >> freed. kvm_release_faultin_page() is passed the pointer to this page and
> >> will dereference the page.
> > Not really. It's just like KVM mapping non-refcounted pages.
> > kvm_release_faultin_page() does not access the non-refcounted pages.
> > The invalidate protocol also ensures no mapping of stale pfn.
> >
> > As below, if CPU 0 truncates the folio, it needs to hold filemap invalidate lock,
> > add KVM mmu invalidate range, hold mmu_lock, zap KVM mappings before the
> > truncation.
> >
> >
> > CPU 0                                      CPU 1
> > -----                                    --------
> >                                          Save fault->mmu_seq
> >
> >                                      B1. filemap_invalidate_lock_shared
> >                                          __kvm_gmem_get_pfn
> >                                          folio_put
> >                                          filemap_invalidate_unlock_shared
> >
> > 				     B2. read_lock
> >                                          is_page_fault_stale
> >
> >                                      B3. kvm_tdp_mmu_map
> >                                      B4. kvm_mmu_finish_page_fault
> >                                          read_unlock
> > A1. filemap_invalidate_lock
> >     kvm_gmem_invalidate_start
> >
> > A2. write_lock
> >     zap KVM MMU
> >     write_unlock
> >     truncate
> >
> > A3. kvm_gmem_invalidate_end
> >     filemap_invalidate_unlock
> >
> >
> > A1 occurs either before or after B1.
> > 1) If A1 occurs before B1, B1 will find the correct pfn.
> > 2) If A1 occurs after B1 and before B2,
> >    a. if A2 is before B2, B2 must find the fault is stale, so it's fine.
> >    b. if A2 is after B2, A2 must be after B4 as well. So, accessing stale pfn
> >       in CPU 1 is fine.
> > 3) If A1 occurs after B2 and before B3,
> > 4) If A1 occurs after B3 and before B4,
> > 5) If A1 occurs after B4,
> >    A2 must be after B4 (for 3-5 conditions).
> >    So, accessing stale pfn in CPU 1 is fine.
> 
> It's not about the stale PFN, if there's no refcount on the page
> returned from B1, then after A3, the page can be freed.
>
> Contractually, I think KVM is allowed to reference the page?
> kvm_release_page_clean() calls kvm_set_page_accessed() on the page
In my patch, "*page = NULL;" is returned in kvm_gmem_get_pfn(). So,
fault->refcounted_page is NULL. With it, kvm_release_faultin_page() does
not access the faultin PFN or the page.
So, no worry about UAF.

> (UAF?). Not sure which other KVM architectures reference the struct page
> itself. Are we going to teach the rest of KVM to not reference and not
> do kvm_release_page_*?
It's just like how KVM maps non-refcounted pages.
And guest_memfd actually asks consumers (like TDX) not to take page refcount.
__kvm_gmem_populate() also puts the folio refcount before invoking
filemap_invalidate_unlock().

> Would like to see what Sean thinks of this. Either way, is it okay to
> follow up after conversions lands?
Let's see what Sean thinks of this :)
I raised this because the issue was encountered by one TDX's stress selftest.
I have no strong opinion on whether it should be fixed after this series lands.
But the fix I proposed is quite small :)



