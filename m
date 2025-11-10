Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB905CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 10:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 491A58E0016; Mon, 10 Nov 2025 05:03:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4692A8E0002; Mon, 10 Nov 2025 05:03:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330C68E0016; Mon, 10 Nov 2025 05:03:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16B928E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:03:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1021894D3
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:03:49 +0000 (UTC)
X-FDA: 84094260978.24.13615DB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id 845952000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:03:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kLiaGybW;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf03.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762769026;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/CG2Kv+ZLjp/c+DlxHbry3AuswPB6FwpsohHVPIOTs=;
	b=7eTRsqUyoWOoNR+Nf060mhZzjpUhSDrm9KTw09hZuaJZRQnAPnemc1EL39G++zSg7dH5zy
	LVdJeBZnIOuaMf5y//3+I5Cv9T/nBEHqqPWJOBSMRa16KWI/zxgmx2BHxH5tzOpvk76bYV
	0qXY3FiFxr2sjjg9nSSAmnmHYvHyFJc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762769026; a=rsa-sha256;
	cv=fail;
	b=f9RDtsPt/zkTV0lqd0prp6D446tFLj0lTk1MHTGHrane9XZYpwRknd6OLJRRSrEmZ3Idfd
	kIJ/cNcljzev6iLXA1DbHJiAvYlIIq9oF2BWgyZ3ItxlQQXSnpEQwQdTE7T1Gla7wQVcgJ
	gUTlwBYqHbh2ha7vtlUtLH6kg1dA1uA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kLiaGybW;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf03.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762769025; x=1794305025;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=9kAt2K/oEK54DRORDxCZuPXD+dNxAeFEaHndxUuDUlY=;
  b=kLiaGybW7Cif7lBUFuX1CgZkOxmr+t5avico/KGoGIQru/F3QJ9gQ/m0
   TOkMZHJYzpI0AwgyagAr/j7f56L//ZDzSR1VdUt8Y5LRlrZHOQoxypYKR
   eRjh6nKeaGN0EtOlSteEIQQYy3tsDSURRKos9oQh6vSR4yaTIpQWbjkKm
   NCG/hLYJ2piRKI2pEstwSHUSBgEf5BvqviSZrOgUX3myZ6vbykn27BgAj
   RWAxjfyepLt1FUeZQVBQasF23Ch2RtFzLJfo8Lkrkts0cQpiL6BX0sXdp
   iEJwRXN588iZZRsM9P+fqLxTAqvRYM5Ckx1QAryBgQKmXUXKtXzD6PJIP
   w==;
X-CSE-ConnectionGUID: fN1P+q3aTwCvlYziE8UpLw==
X-CSE-MsgGUID: HST8sBMJSSefNpKuB8u9HA==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="76267869"
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="76267869"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 02:03:44 -0800
X-CSE-ConnectionGUID: /Hbv84m8QZOM+rIZfRTh3A==
X-CSE-MsgGUID: 0g0vwPdHSw2LAhO9eHt/9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="212031542"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 02:03:42 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 02:03:41 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 10 Nov 2025 02:03:41 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.18) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 02:03:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i9t8SMCyFxSx3z4YsQpglM1eL2r6JG2ISCEmOJdV5hQbaJAg7n83UXZk0mFyCIRpY626FajD7j9cIjgjZxfXBr6VsCdeEJUsCKAQ+LE29+nqhm4/6fetCabfpwUZUeseFZtdWVTK3SkXR+VT0o+k52aOWbIiTizPmHXDTp+wI33rPF8HX150xBiuGJmSd7c/QOuVCzcIIJxLuUkn0WqUahJ5zgXErtwGk6MfEfSZOoqsjPNmpzb+yxsrLNIDqE77V0JQVlcZZeomjUsy92M338yFkG2OlA4DsjSWVKXDaRn7O1jASWS/M/UX8zQeRKZ+bqH153Bw8W5hqxq3ePNm1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/CG2Kv+ZLjp/c+DlxHbry3AuswPB6FwpsohHVPIOTs=;
 b=ZwiiNsDqResYRveuzMtnB2RcU08CYlukKCwzcINqFJCRZDYxOPFNtCU2t5c/k9uRFBh0UkiOgDhTEnAyng0WPeUvRLFwcAs992KmQPB277pu6MqjvBcx7w7qlDKl0K9PGe85d1VF2FmKNWd72CfTvqfRZDCcfjlacdXxIWOyjXkIpenu0NFxSvl1fyEYbNCnpMKBxrEwGWd3+A5I27Ej3ABmxli7cA2P/BZdqEdm4YJ1fzQy6mc60S7RrSZxWPcIodZ0d7roEWxvl7cDEMyvYnA9Jn9cjewQmeq88cn6hnPLhY3jZIJKPBYPq67ZMhAmLAOsNgubnBjMA2rOj1cRTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7920.namprd11.prod.outlook.com (2603:10b6:208:3fc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.16; Mon, 10 Nov 2025 10:03:38 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Mon, 10 Nov 2025
 10:03:38 +0000
Date: Mon, 10 Nov 2025 18:01:10 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <cgroups@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-trace-kernel@vger.kernel.org>, <x86@kernel.org>,
	<akpm@linux-foundation.org>, <binbin.wu@linux.intel.com>, <bp@alien8.de>,
	<brauner@kernel.org>, <chao.p.peng@intel.com>, <chenhuacai@kernel.org>,
	<corbet@lwn.net>, <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
	<david@redhat.com>, <dmatlack@google.com>, <erdemaktas@google.com>,
	<fan.du@intel.com>, <fvdl@google.com>, <haibo1.xu@intel.com>,
	<hannes@cmpxchg.org>, <hch@infradead.org>, <hpa@zytor.com>,
	<hughd@google.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<jack@suse.cz>, <james.morse@arm.com>, <jarkko@kernel.org>, <jgg@ziepe.ca>,
	<jgowans@amazon.com>, <jhubbard@nvidia.com>, <jroedel@suse.de>,
	<jthoughton@google.com>, <jun.miao@intel.com>, <kai.huang@intel.com>,
	<keirf@google.com>, <kent.overstreet@linux.dev>, <liam.merwick@oracle.com>,
	<maciej.wieczor-retman@intel.com>, <mail@maciej.szmigiero.name>,
	<maobibo@loongson.cn>, <mathieu.desnoyers@efficios.com>, <maz@kernel.org>,
	<mhiramat@kernel.org>, <mhocko@kernel.org>, <mic@digikod.net>,
	<michael.roth@amd.com>, <mingo@redhat.com>, <mlevitsk@redhat.com>,
	<mpe@ellerman.id.au>, <muchun.song@linux.dev>, <nikunj@amd.com>,
	<nsaenz@amazon.es>, <oliver.upton@linux.dev>, <palmer@dabbelt.com>,
	<pankaj.gupta@amd.com>, <paul.walmsley@sifive.com>, <pbonzini@redhat.com>,
	<peterx@redhat.com>, <pgonda@google.com>, <prsampat@amd.com>,
	<pvorel@suse.cz>, <qperret@google.com>, <richard.weiyang@gmail.com>,
	<rick.p.edgecombe@intel.com>, <rientjes@google.com>, <rostedt@goodmis.org>,
	<roypat@amazon.co.uk>, <rppt@kernel.org>, <seanjc@google.com>,
	<shakeel.butt@linux.dev>, <shuah@kernel.org>, <steven.price@arm.com>,
	<steven.sistare@oracle.com>, <suzuki.poulose@arm.com>, <tabba@google.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <viro@zeniv.linux.org.uk>, <vkuznets@redhat.com>,
	<wei.w.wang@intel.com>, <will@kernel.org>, <willy@infradead.org>,
	<wyihan@google.com>, <xiaoyao.li@intel.com>, <yilun.xu@intel.com>,
	<yuzenghui@huawei.com>, <zhiquan1.li@intel.com>
Subject: Re: [RFC PATCH v1 06/37] KVM: guest_memfd: Update
 kvm_gmem_populate() to use gmem attributes
Message-ID: <aRG35j3OhMvQo85n@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <cover.1760731772.git.ackerleytng@google.com>
 <a3795f7fb4f785ced19abe18c2f33aa478c4d202.1760731772.git.ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a3795f7fb4f785ced19abe18c2f33aa478c4d202.1760731772.git.ackerleytng@google.com>
X-ClientProxiedBy: SG2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::18)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7920:EE_
X-MS-Office365-Filtering-Correlation-Id: 39de3c03-7919-49d0-568a-08de20406b24
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?P7gxU9qmw7dF7Hk6hYea8VdGV87+Q1LMILKdeDZnLt0obaVxLP9L6p3rLOl8?=
 =?us-ascii?Q?ItSQr2Rl5p+Xo/qaeJZ6bsVg/43yMdhQrQm0yvkGG+YwvdfRpgT+M42eHVtH?=
 =?us-ascii?Q?CVc8c3Fz608+kjNEp7BRmRMTnSaqVOcYfLtcyqgwEcOY8NipPdvbbeoE5wzc?=
 =?us-ascii?Q?SeoZgw1CU0O3jxQXCpes9HwNazIEACSwU5GX5WwPApA7hAELR4B7SZpdqjYb?=
 =?us-ascii?Q?SRHQa8o7ynTKx++Cj+5bKABeczSuUkU8eN0RLoNzwrn6Q1Mmu+lOcWyc8d58?=
 =?us-ascii?Q?+HMCacvVrOF6DBHbuT+ebWpF9W/VE/1xmIOYx2cvq7lzPpsvXfYDNK8Vb+ar?=
 =?us-ascii?Q?1wx+NzHr5eY4mEJmPugPI0bomTq6cnUpwJ+iCgisbD2i5fBLl1oChMVVb9d2?=
 =?us-ascii?Q?YlLmEbPiHvGF8n3Ica/FlypR5ob76P8C+2xR6S0N1ht7K6a9c1rM1W7jdwOM?=
 =?us-ascii?Q?0nY2PbFhg4L1kdV8PINEYnDD7m37I+ysQQKf4u8FA/4vIx2c6ezg7sUh/ZO1?=
 =?us-ascii?Q?X7A1tesNd478IGaugCg7sJs5yzVTeufaisPN5ih8vD3aqFaslAPsD5KtImaq?=
 =?us-ascii?Q?rsde7ybif6csEO7ulIOnjj5zC2z3hvDJaYW+KbX0NgLLDncIOAkRHhEAlG5c?=
 =?us-ascii?Q?c7NWD70QBdCcZSIKFJ7oHvCdQzB35EaF2nwPRUnwlrcnxDtjE32HV6Mqi+LE?=
 =?us-ascii?Q?8bXacIktLzzSR4ZCQVHIKEnmyLQU53iDKLnkzqCejfN6bxwyb1xN2YBZJqR5?=
 =?us-ascii?Q?khq7rOThZhL4NHzwBz/3bOlNoY6y4ixqku4S+CXNd6U7EpJ8NUaNsG35thon?=
 =?us-ascii?Q?TCzPQnzU+2BcE1vLpE6h7ZcJgUvHjTUay297WO1Wl9p8AISfgI+56yC3RKTp?=
 =?us-ascii?Q?VR3jYDesNQPD3p+bHLaUT8xxH1/VZsLlcbu/JUqXd4Qsq/yuBespbNijmLV4?=
 =?us-ascii?Q?jSAI7T7eHPyI+cI7nsUvfFsP+PY69icO9eJLh94PBKKbBp7poSJS3oMesfUm?=
 =?us-ascii?Q?wjSXYRWf4QJRk0zV3DP4yiDSlOKcvYUj9R5HWd6equDrquDzcc3Y5rYD12Gz?=
 =?us-ascii?Q?KUQb2MWXbr300KGKK/unOOi10cxgxB1sX7aDv8+RlfPDRVIBxyLVBdXVPO/o?=
 =?us-ascii?Q?0YVT6IWeNr87mucY5q3qARL7iG/1VdbCFnEFAllqUyTT+Kov3wIaxyYGKp7E?=
 =?us-ascii?Q?g8kUCAyBsXWWEiIrz2N6PeYnVaMHX9EQGyhSZSpiWxXvcIylq8cKGwCW5bGL?=
 =?us-ascii?Q?yoKgBKzzZQZ6yoPaDEJU0wahgE+iUpPd3jhuZ4aQp+tnuh2PI+xwz5vPAu/j?=
 =?us-ascii?Q?rRiUOVAk8OC0ViMYrchvvhyObuJSEPlzusxd7lpsLs0ANoJPAxxCnFJ69qvL?=
 =?us-ascii?Q?ghWNDoPR+YEiVVGC1ZplWEbMZD+kgA4jtA+tUT1SdHkEz9K0qnR0Whbkd61u?=
 =?us-ascii?Q?T4e1GbqEsJREdKb7L7Q0A5uh2/8rYMIj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bKaJbzBw8ReM+nAI7lfOJUgBXz++Pny1x8984QUysm7ltHv6mWQ2lUSkPsId?=
 =?us-ascii?Q?Z6bAc0zZiFEnXO6WDL0QO0rv/1Wes2D1LAkD2a9ROVarLuQC32evrO6ZQ9ZE?=
 =?us-ascii?Q?TJhn2jlo5ZKTO8JkUYJ6ac+SOYt80seFnLEkiRDrN5mbO5RivNqSL33I8D7W?=
 =?us-ascii?Q?a0P44YEd87bQY1UPI/6OI605mw2vRruXpiLA/p9e7eLBItOWTIeb1cscxiG/?=
 =?us-ascii?Q?zj+g+c0rKYRjTreZEOpxK/RGNsa3lRcZXtzOJaHgFra9AJFQ2LnugZ2AtfF3?=
 =?us-ascii?Q?CPhd/SdP9ToLiywX/j/B+UGlScwXPrCuwNqz8MQAqbgG8WCxEfAbkuG4svwo?=
 =?us-ascii?Q?scwRxBB0oPFuBFMl2UB7RZ8Uimq3IGNEA6w7HsxnKUS0HnLK987ENgqO7hMf?=
 =?us-ascii?Q?55Exw1uSY1mFhjUV5ORtJ7oSTlAt7SDqTdJdaDmTZJintJV7o8O/sYpqPDvU?=
 =?us-ascii?Q?TRCmsUCZXDxYN02AALNRRo0X5gphW50ZoDZOhaMAUc6zEYfXKl9Lx5Afkclt?=
 =?us-ascii?Q?wuf5xprVWimloqQNpdFWzyvHdC/5m1/qRunEN82nta427oTIKLx9NNzfP9nr?=
 =?us-ascii?Q?5cFRNclovk3KhfkqCQLZMggbh6QArY3O42Dp27IZaJTQKcEygRKoBnjpS/FE?=
 =?us-ascii?Q?WNzFfz//nvyohxT2aB6RdjMry3S3hh1FCQa7G5l3shPp8wirepcHD8I9izyX?=
 =?us-ascii?Q?fnaM5iZiwIhbQtEspKUbnvsfkHK6gY3JcXOmc3owsaKq+7Omm60SLDiOsGzK?=
 =?us-ascii?Q?6YoxJGD26Ji7CPX2MA3FAfh3hcuScK3K96cOGsNoLqoAPCfoLYwQE7PjZSgF?=
 =?us-ascii?Q?MU2hoDwY8t177VWw74ANP++2DA7RtgQaDV9SqDRFxD+V5k/R4MOdI6W7Vbl8?=
 =?us-ascii?Q?sPwHa23gxaKKqcdX2Tkpy5mAbTrOSvhteQvsmwnsZvhkE+3bCzmARIGsBZiH?=
 =?us-ascii?Q?Kau0xW0x9WGASxOhReI4r4G19fJwnM71aln6DvNFyzt67bVQjHD1VnlZbLi6?=
 =?us-ascii?Q?3lgfimfx1yL7wKI+R4yoKOalzggeXIVso8hcXUed3kgnqhzhKZ/2F9BD+fK0?=
 =?us-ascii?Q?p3TrAHAzYOki6dj2DHMKQQ2BVdmXSciPw5orHEKrDNy6xwTmClpS46IB9x2J?=
 =?us-ascii?Q?Bsid3ZAnJO+CCKi1Z+G6pPkCaftHGEaJlAnQNeHAELrykXWTMnAABnOSgt4g?=
 =?us-ascii?Q?vkltvWnor5Y4WtLMisXxde2LVReOyUReT1ODz8IHK56YX3aswi4xNvJo6XrS?=
 =?us-ascii?Q?Ha7mTjJnNgimj0Hp2yPE8TCagsbNS+jop5GIbCSUrU6SeKx83Vi1t8jE6CML?=
 =?us-ascii?Q?n7APGEnGo9xjO5jputuUsjwvHZ89Is614wJbWPz5vnvV37sRF7HRQkaUjCOI?=
 =?us-ascii?Q?vIOaAEkSlzURfryvIC/ek55r97qXm84SLUspAVYJ500QZdQCplGKhcjrEdKI?=
 =?us-ascii?Q?1dsAzw/1fJBJL6yN8IVxw+OTFFKfrrrK/HceJNOlUZ8/Wpb7uzGM5DQuyhhK?=
 =?us-ascii?Q?oThzNKUS3CnlFlAgacpwgPZN4Ng6k6xDXk92JqENGcabNDjXdTqVH9KOhMHv?=
 =?us-ascii?Q?I1v6j9Nj1u5dORinPqaST6iDqmRifJARgAerLy2h?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39de3c03-7919-49d0-568a-08de20406b24
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 10:03:38.3215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWHHVs7d1OZCTTJikdTgC/pTPFI/Orekf2RpTVawHxWtxB7Yq7xqZFqbbodT5nh8CcI7INdKI6+3zPaOxYYoJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7920
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 845952000D
X-Stat-Signature: 7uer5m6fdq7msycxukhw9ck814n9pd73
X-Rspam-User: 
X-HE-Tag: 1762769025-572309
X-HE-Meta: U2FsdGVkX1+TZpHOeEEXw10R/sl9uYYAuykeDROGZSRe6Z+kHfe4lH8hCBJRuDQKPP0IQpz9KBf7Idzq1YEEIxXrqC2770kxwNvQDWercenT9pXF8qtULyKJdMP7A15PrA7rq2mcigXzONSOJmdnNMkjrmHLKpLqhpZZGb51TnrZtq0PRrIxXMXg0HixS192mXSb3ta+/h0vaFX7K8FjyFEG6LIHVss6hBUQRG72KkXKHd4EycAjv6K4yu5LkLPXYGh0DE3BL2BNhP8Rx2LEucELbKGvGk30ETgYpNoYIklk1AuuNzyacUWwD40k05M7df+W6YlpxeH+6eFdThpB3HxpNq5U/1iWRkm15Z8g1dBGYcEvhARe/zcePJX2KXZpdXdump0F74FNxuVh3oMjNASDepqqePVD5FVh1+RLagGKe3jkNlz0j7VAF4H093SX2uIToWoxUGLA9GcfUQGQ+CsSP1WoB3FqmAYpheXJadUE3lNiR5qQ5sjYmVLyzQeya5JRqO5UIvg0pu34/cL53ZNHleqJgvPrtJJPg/EXkDqNshVYsFmG6gWMGJ/eiMW2BfR01cJ8S+RObHkCfPoh7k5SazV7YHAKEpadQD+0yx4JxvzzLJN2u1xbZ0Ev+W60uE0wjKq0tlid7qh7LTvp8IskUslno/8oPUzDMNHqyKa2wNkCjh9vSd+o8Zj1z6OonHEFkGRtqIVc0LVQ0O7lv3vhIRaqgCY/FFXz3KqrXUXKTB3dB0YVy4Y0JCKDO7B8WkDHLvQmElCZ/ymE3BkaDUxvMuK7arySgKtQg+l6dGPhrK24du87+04zelUwVltD1YK4krlPF6TKrYVkfhqQO3qDiwDNSzcC3TYcJxC1w4QVRB9z9BG70TZvZ3IND8U7qMBpwfitRHUg2czPhIsztV/wV6pOPkBuEnumeVV6QaFRkUNS5wrsHdX5OmANXAIyfo6GEIrq56p/ZMKspJU
 SYcQ1T2Q
 fhkgjV2nVXRNWeIzyZ2LD20rYK5l2rJ9UByq33qytQ82/UJmH/XsCjs4zG4yrf+4JhBQDwas3aJJvrq5xtgScNj+TlrHy56ssD39dZhyu6mO7O2sHCxQcbF0Je6IF2vraNoUw29tzseFEmEFJLYiVm4+md0kwBoJilBLE62Y2wU9EWf5a+PPdkZ9geLwHgemKBKC5XjWxqqKjEgZHGaMhl87O2/JUxF2KBEKi6A8AcpYC9AvjFh8Y4RVAz5Rkfdx8RySb0pEk/vvjtxiGjcBqsKRGjZijOMY3hQG4Ixx3qH38MTllRgIwBiWou07+x1MsgKWtQql15oPT/QYJ8KkT2eAl1oafUhWw9X/nxz0Ht7gO6SerOFcCq7hjR5D4pW5JJEHmJ9CgNBumgkvb+e7OJ5TxHciQiXN77Un2qhbXlKBUON59U2WD8vwJK17HzhHkjyHjUJpjw0Fz4Q7VkqP/4ZNwOD5W2rM/+mGs8NJXi93bW5VNGgzHIWlbU97t0eh7KMlcP/xl39a0M2sTTNpZ/rSTfdixJ7xL8NmmOpAe1Xb95SA1NqRldD/MAFQCSU3f+7P/BfEogFHdX1GlMu09jqhDY7vTrKigz0ezfyalqa7EIpQToV6VFS67OOx21xWTaSbS5GlfFQF/n4oxkwlD4ipMHc1f7zZsFAeKGkR8ftjA6e/kugsAGMVI9Li3qV6SqoBgNBGnHOg7j0wap1nWcjT0MO93nVwrfV1h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> +static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
> +				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
> +{
> +	pgoff_t end = index + nr_pages - 1;
> +	void *entry;
> +
> +	if (vm_memory_attributes)
> +		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
> +						       KVM_MEMORY_ATTRIBUTE_PRIVATE,
> +						       KVM_MEMORY_ATTRIBUTE_PRIVATE);
Can't compile kvm_range_has_vm_memory_attributes() if
CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set.


