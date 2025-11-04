Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8432BCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6D7D8E011F; Tue,  4 Nov 2025 04:27:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1C858E0118; Tue,  4 Nov 2025 04:27:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898668E011F; Tue,  4 Nov 2025 04:27:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1808E0118
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:27:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EBE22160468
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:27:57 +0000 (UTC)
X-FDA: 84072397794.26.D35D47B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf19.hostedemail.com (Postfix) with ESMTP id 580691A0005
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:27:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j1iDLmAL;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf19.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762248474; a=rsa-sha256;
	cv=fail;
	b=3XQFQiif1wGbKxFms2a4Vup9q6F/8d8+NWDwSc+H0r4LjyCNqlrRtSMyM0q1ntDmlhY3Mx
	HQpJ4JIUbckWTyvdDRTIVJxO0sQeyX77WOV97G88HmW9/JMuBK1Mg6SlGmfrUitC0KGjz/
	70/u6NW5B/3o4idk7a2K8akNlOfoydw=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j1iDLmAL;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf19.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762248474;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APEJPYmw8dbnHrxrwCfV3/d0lC1ptXl3oXuA091M4Xg=;
	b=D0MnnUVH4wwYQMo31Occx6hZVKGNyKuxNJYzuixYgRet53I7wBxdLxo/m9zLmM4vQDz++v
	Ge+Qn9ji62NJ4gpdqowjlhuRiLHpxOZ/UagfY97CBH2Fi/3/pwjz5txThorykrSJmKD1A8
	QHZYCTHBapUYjhAF6sHws3iR+zRdY5I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762248474; x=1793784474;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=mbbx3FDwvOutPhQ6wt6IdkE7+Crn8+1fuAxAwZIcmNs=;
  b=j1iDLmALjuWshb2QI8Aekr24yRAf2kG5at9iunh5AuqNVuRgvo8Myer4
   qPpfQZL/jBBfci0ckgRVd5qdx8YoOEuZnNOhXDIDM+o5CZ1LMTUtJW/0g
   GO/iRwB3Gb1LBRUal0WhzFHQIcA/ynhvmB26y+4dUAGvTL2gZMc8oJkJM
   BMgB00qG1Py5PkM5E5cgBcin3rz+HuNHUA2CR/r4fQmBVj8QTR0s4+iJa
   N/zNHCECMb/H5NoHTHhs5p+jBc7hN8IDTJol3OyBq9E0lwa+pr3osfPUr
   k+jSEsg1KDC/8E59ZF1LPvWTGVTEVsX1oHg0Y3zX4BFWeQAHkSny7/FI1
   w==;
X-CSE-ConnectionGUID: eZViIXjqSjGB+dbJt0xnrw==
X-CSE-MsgGUID: JfTE9zh1Q+eLrtxnjEjL3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="81742866"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="81742866"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:27:53 -0800
X-CSE-ConnectionGUID: TtF0JP5YQZuZJT4m+Kkb/A==
X-CSE-MsgGUID: 8lRoSVRgTRu3HtsxGc9fxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="224359713"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:27:51 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 01:27:50 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 4 Nov 2025 01:27:50 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.19) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 01:27:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RK0MTKFzHjrv7SwyrObqGOdVam4hsbIieKE1APjloHq2sO1rEyzWSRjBPQNvuW63ErYxDt7UDpFIF6f0uVC6Tfh1numu3Pl5qSb3/nwYSu/nyMd51GYbKQwvkVOP9Aexz3kzQ1hDmyrQ4ls/Bl0JYPt5T+VoZs1wu2fVmu64gh6GMZpGjleMsGq+qIkv5JJVLQiJwq4eL2AGC3fxVbdoRMEec/94RHILke1Ai4dQ3nKwaJc+iVrDOg7JT2gB/sKi5l/5gkxXsHiD2fwnevfe103w9FWm3HzsD5USkfPzCPmpj1qa0Sa/e8KrteAx9HD7tvcuEr/ioEnlLZaNg64xHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APEJPYmw8dbnHrxrwCfV3/d0lC1ptXl3oXuA091M4Xg=;
 b=TDjT7nPtGnum3pMj+aVqKk34ixY4+EsL0TCYDfLLV8jsU3lOkcinxoQxRoiFcicPKi06SyHIB1i5ObUq8OAycx7YVD0xcQnjTLn8bNcQOM8sW+z9ylItZ5DV7eoThmovDPfwM+kcuLBdQ6uH192M1D/RTj+eenVT25RUiRNYERALEdP7O3CFY3fB0Z4sA9np+zxN4yUSYLVQRXv5N40mG51Fipo36Lg7JTFMGQt9VtnPfRo4S9eTRrGUpajjbC3eSGDgvpu9p7vFpsMWwTB/yz+05NpsQPe1ufa326zGvK5UGHrsOqruvoPyausti3meRxn9VfXWSpuTlLV1ur5qaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6568.namprd11.prod.outlook.com (2603:10b6:806:253::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Tue, 4 Nov
 2025 09:27:47 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 09:27:46 +0000
Date: Tue, 4 Nov 2025 17:25:44 +0800
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
Subject: Re: [RFC PATCH v1 11/37] KVM: guest_memfd: Add support for
 KVM_SET_MEMORY_ATTRIBUTES
Message-ID: <aQnGJ5agTohMijj8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <cover.1760731772.git.ackerleytng@google.com>
 <5a4dfc265a46959953e6c24730d22584972b1179.1760731772.git.ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5a4dfc265a46959953e6c24730d22584972b1179.1760731772.git.ackerleytng@google.com>
X-ClientProxiedBy: KU2P306CA0060.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:39::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6568:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e3446ce-c399-4550-e293-08de1b846a28
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WytMEsmHQtu6Ngp3HqJY6i3FJF+vakmagB7KcbRqdsS1P9CDieVQBr5wikr3?=
 =?us-ascii?Q?cGJIBNOabf2Vxip1wSSbY1qpdU4nvrxX9bhKNgsAvDejhb/jBuLKN7NQfudV?=
 =?us-ascii?Q?pyjqX4aYOoOlgHiuv3j8u9GyROmPR+SPfWsELNw3YTZRQxfPZNpUGIbaUTFf?=
 =?us-ascii?Q?x5RjoqDCNmGmNqjVMZ6OV4crLq35un7i78/NoCVlSu2n7T86hpIxGSChqmVB?=
 =?us-ascii?Q?qKN25Vt1BeRv1FMn3dGJEDy486/cLTJnvBCMJPD/cP4JDtKletFaQxl2QpR6?=
 =?us-ascii?Q?VmNHPGCGMaBkTOZk976BjEuHull+8nSzzP3wEMbGXjVCa79AugvneDgzHCFH?=
 =?us-ascii?Q?i0jmkN+30XNu1YhUqvHQzVPDnmdjhhPzuOGbYDtVWMKEXj+FVHXVszczScRP?=
 =?us-ascii?Q?XYMa2U92e+zN2jWBMyaAI+SiwfRJFGDKaB/8EoABh/FHwFsxQaq8VoYuAtcg?=
 =?us-ascii?Q?VUZk0N8zBNhoR323rq5YrcLOdastykDSFhvecy9Pdg8soJMwhJIsmCcr5j09?=
 =?us-ascii?Q?gVMIf5rGxN31WcPxY5sqf0CMtlzuKYrHsu9iqJ3G/en55otklyABz/kZHUMh?=
 =?us-ascii?Q?yFzo7fh4f3NxBcMAdDJgya71HBoJnY+Mf19NZmLiMmzKKqZ1d0wGz3D2r8/v?=
 =?us-ascii?Q?2d5i/AturD3N9UEIHi1xsEowss0gjJKvYlw+kwgn8v5X8TGQdC8RjUyEt1rQ?=
 =?us-ascii?Q?+J7+LB3NFS5X3PhH6OVwBKKK2tkUuE9HgGjDHjjxA0bfb2jfGOuyjEY5+j+a?=
 =?us-ascii?Q?oM+fQ0JoqRHc3hJx/fGTIaZKn8slkhlu+OBbYV8EQKeHvMBjEFyr2qL6tIac?=
 =?us-ascii?Q?/GKXKtCDcH3KhALfw99/ki1nn089nh1JhTvNY1/oosCEBjs6jkF7/o3MiuQX?=
 =?us-ascii?Q?SJNLbcDMSkve513Cbwapy5W5cX3ar6u3vp9sIVwt1xmTtX7wPKOtDd9dtyQC?=
 =?us-ascii?Q?dPl6QXVyjhPaXQWn7D+w4pFzKSMkWoAK54TRp39qMoL+qkO48ed0fPiU1znp?=
 =?us-ascii?Q?6UPS4UMsBZPK8oeAUbHP8WzniJ3fhrVauO4xykeJE9KMzK/wGNkJOEPwODVq?=
 =?us-ascii?Q?iCBOKUgSV6Gkb2nvjKeYcMpuGKxYxjzBl2skuLchW0wQh+TjbvG4y36GlE9e?=
 =?us-ascii?Q?spr1F/x1erCuMBIGrYX2ZoVQtsIm3UryoK81BYfswwdz/0dH0Mid9QDm6gA+?=
 =?us-ascii?Q?fiHveuFKO4sXFI452eMs0GqNkXH7EwocNmhBkHy/HNu0o4P5UKj8fW+KJ8wE?=
 =?us-ascii?Q?gmI6oQhD99ZPZO+KpVCmDlAH2P/hSawTHnFy1tyc96F2G8cRNBRe2kCEvEfH?=
 =?us-ascii?Q?mwk86wq6xY7+NvtZJKXs+HdqlgdO/2kgfnihICzvrOOD3QIt2OfubVv5wk9v?=
 =?us-ascii?Q?bXniVmULbQIejKsGiZsTBF08h1uMlraaYIv0LIUrUdHw036j0WK8TfpxZvLm?=
 =?us-ascii?Q?mBr56Rvssvlz/P4At9Q5VtNI1KvpWDbx?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LFuOFfALRCu35WOxLAJgQDDelNUsHTu2l+tMD57Ya0FGzuacPS84uccOP10m?=
 =?us-ascii?Q?2jxXP3Y8uXaKx0zrkzVrUL3ykPyTkeFlthQ/XWfWcym/AomYzuX1LG9Rjwcm?=
 =?us-ascii?Q?ZbK/HRGFbqCy0goKhuAPtO29n1tlFWX6d3DQEHIC3+oRQJ5SNhMjCZ70r2TJ?=
 =?us-ascii?Q?5hcjvf0BTS7NVrz6BkYO0nQ5GhksS7q5GHmejh+GBZ5LFJLjIRDFgl8bqxWK?=
 =?us-ascii?Q?6/tsswk57GlYqdO52WhJT4kuxSdDWzu2pC1uDUq1GkKjBHWwk4wohNtx0+6c?=
 =?us-ascii?Q?Ngo/LeesxL9NqXY079AWvThz8ln3Vj7M+cAkggK7O+GwpBLh6QiHlh2jstIp?=
 =?us-ascii?Q?qfu4ivODcDDqCsW7EwrIFl/7Dj/G2vu8H7E430PWE9jR7eVkVCdSeKVANXU5?=
 =?us-ascii?Q?SgWDVgKWKPOxmzUb2R/9TBGBkyeDwyxFZegQvERWEerIWrHN9D8PhQfpepQN?=
 =?us-ascii?Q?BXMqRlaN/7TeP8SDWH4CAyXYF/1wmHc52b3ekkQzVf/vDPYP8CXYIMtTuxnB?=
 =?us-ascii?Q?3nGSzqtCbygPFirX6L1GlRRMSVrGic4qmpiOnIVMnYxtJh8N/iY12uMyB+9j?=
 =?us-ascii?Q?9XUAg7sWZIXtMyUxngi9sjxHy5lh328FeNDATmfvx45kgA6RBAAxTzmzMRah?=
 =?us-ascii?Q?RAIZd8eyQMnqWqqBgM87S3V2e/nafBQbYW+9tUwCrZb3iXgypsb9SYgqM89X?=
 =?us-ascii?Q?1NMhIkbXgeXDDKQWJ3lYgLc3ZM8q1pqXWVMp6mhmjY0NvB93IxnNkbdks3xv?=
 =?us-ascii?Q?tpn7Yz5nW5hJg+rjcr4mgOCm274x1/QvUuzwMNbcsU+RsNS/3WDj855DJaEI?=
 =?us-ascii?Q?TKFnsrai0+b9wuS5gOBkNGAuNXkiBUz9M5E9vF+QryiytcZk125orQfKxrmx?=
 =?us-ascii?Q?KlXk1qz+o2TzeszA4qHEA2zqR7ypmeMVDYZ89uZ2+3tUHRRaUFTSPtEzZJyq?=
 =?us-ascii?Q?tsyX0fKD1/sarY9p6qXJtSj2RdMX4kYkD4HE1QyWi8a8xoGCgxxLEm8Vnnzj?=
 =?us-ascii?Q?uduEakcK5Xex7NDpUeWVqTO7+Q4JddAHP+Ku1hjUT2v1yZw1OsbAEj+mW6Sg?=
 =?us-ascii?Q?CBXZQCh2hAV3qxiPxofS7WCibq6vZIrZOuiQTNN25KRoUgzbihR6k1dcWMyM?=
 =?us-ascii?Q?OIi0FoOalLGdmFpZGlmACvSttvOXRz1X2xm6viybXrBewzZmbAEB93WFI4Sm?=
 =?us-ascii?Q?i95gSZcoTz28Hpnj67FxbugE4ENAv0x/jlitZ7VD8X8n1RjaC0TxrG55czrZ?=
 =?us-ascii?Q?2MJbt755bu7iIjLVL7/xStaW7biXAfPNDEOcGxU+n4s2eK2X4fXwCTwUJW4G?=
 =?us-ascii?Q?keFqCTc8U2nHnSAOfhCCfU0rplTqzT9yeoWx2e3R8hMS1Frjdy4Uv7gRXieJ?=
 =?us-ascii?Q?5yMz0kpMX4KbcztzCaFgVHJxOQCE8xrrH9TSJmFxcmSM+30RoTXjWmwQ3jLf?=
 =?us-ascii?Q?ReVuJSjJN8aWq3xBIm5335beyjfaS2jmiNtc9F+Ry2W1N6mbsqacpaRK9G0z?=
 =?us-ascii?Q?eJZKlG6E+yosGUspyqpQvxwV7kb+PKyJ7M6a/M+f796lxfPkyM6kV9pUOM+w?=
 =?us-ascii?Q?cLti8W7bQGv9HbT7GKS6XtDFKgz2BPkZ/zbudI6g?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e3446ce-c399-4550-e293-08de1b846a28
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 09:27:46.7700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MLuR+onqznu7U13VtIZcxSDC/R+FfC/rynMFKjUob/3aVv4QCGLJ9Cer1dILsPBUOLPGpn6QaCQqi/RDT+QL6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6568
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 580691A0005
X-Stat-Signature: xak3ndxroo8q3jawrtwfakopr9pk46zt
X-HE-Tag: 1762248473-107940
X-HE-Meta: U2FsdGVkX19RbOngTDMZC7fOlzUpg6ShtouTJM3GnD9QIYorkHRxWAoW8Jm9hoU+COsTqT4cPJQcZIrM5czmtYoW3stxLrEBdMZqZWAAvydCmzHWCW9rFRvHljMcxpiHgWLOTAfdWuF2WEzC2uo9rm+r5+AY+EAeLgR3nNRxmJAUdo9qOFErupeAJKYSt/8LJJBcLmSCesmZEdMykBeo1uEEythRpse+wWbIvoip9rE1Itx/HuK7RHY8nfB9tRr8v0qVDFMgeG+B+aboU5cvaDwUJE9m58uD3jZokt8gysSVHyTBlTplA0W9mMx7FeJrqTyIze+zDFvDKW/2a6JIjsfRv94m+TEQ3kH9l2qw9HNUjLO8s1iPyuWbjUvrJrCjmwisM27t8xDmj1VgRZLym4jn8H3dmRgJ13oHXc1xz69JTdJOeLClEuLkY/mt42rw+1rQXEtQ7qTZY+GVVDMmEBve03/Qh0obiIDQYN/OtW4FVPKeV4izuPfe7IDxFV8s91IreoB2D8jzZ51XFQlWs81O+WkcW5B/d3wipELIEbIkO2TQPa+ZrC0xdEZakJRyoW3ywjYAL1rfpEr5/1kIa7sixVbPbDF7nIiFDInJD4b8deylIi//j+zWJPCwuoAtotSObI8KKTpsQCHHsiCWfkaBvUbdYVNyF6Qdgww6fy0LvokjuXWL86eAdhQCw21HonSmcsb+7rPLtqA0bjguAv6cUcoheb1bRkn7xW7Ch3Rb24jdyuw0ugDN3f55DA+1piz4zgjclqkKdXI9FC0Gt0uw5hEl3qqTdeXUAfBaIcsv3fNd5isuj81gZ9KSx3icDDiSlUtUJnYycb+HK5tKWQwNlmk6gKuJSg/3Q73MV3n3J84OGJXv36uUR0Sg5tL8fT/ctSynwdWfkyIlg0OrFmR7Ro/oaDuRMiJk51LvIp+w/ouWStFkwV9hPMyBHHMYPfVQYXNcJu9yDoMZQHX
 tApabqDE
 E5s63vjwO0S0PedboYLQee0uwexA21f0h1adawpmDuR2xqtYhQAUWKfb7p6jntYvQXjpMQVUHJxGlDy0L9iUEFy8L/NDiW2k09VQJJe1jJ7cKeLv4FGdKtk9hN83f3clg1ZYaVRA46h1YzHuRW5fIsml4xunfJkHjcsUNadSIAQB8qy6ordY49GOqCKS1aTFB5wzbhtQEOJff1Q4sZ4R17eOZSEKsKlIqr+boC26XToCvP8fvVkCYN7a6CDPRjL2csxM0RX73JHzEfXcnEpYwFjfvhnzLks5ONdcUQaezucEtBTwYhDN+VWaAgJR4ro+aPc72Tohy4hGdXoYM3UO3s86irwPF/m/W0DDIAPCPHyorE2if+6rtaaEhv9Cw4RiQH9dnsmnq6QIfWi73UY5oPWz1S/L0FxveUUSr+MiKXZspboB0F+bSrTCkX7pWt1EWPXJ+kJ6VyA/BmwrBlVnpulPtOslW04wykxGVL+70+mzGVw40l5PmaDhV+POFe7DPXrHCcyLQiPTYCMxzQFONamlRAjsdA2xXp8HMGLYIS3bLWcup9IAxRkQ2ZHHeqjQirh9iqVjzLDBAZQqV9Gv1JsVoZ6YUUwQ0xDTxr7w/tmn1UzcopAajAlYJfResEkbiGI78178ovjepqVOnYq/jdMDdhVdsVA04fQojkoy/g8O1H36zblrEtkKcV/BQt8XAGPm6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 01:11:52PM -0700, Ackerley Tng wrote:
> For shared to private conversions, if refcounts on any of the folios
> within the range are elevated, fail the conversion with -EAGAIN.
> 
> At the point of shared to private conversion, all folios in range are
> also unmapped. The filemap_invalidate_lock() is held, so no faulting
> can occur. Hence, from that point on, only transient refcounts can be
> taken on the folios associated with that guest_memfd.
> 
> Hence, it is safe to do the conversion from shared to private.
> 
> After conversion is complete, refcounts may become elevated, but that
> is fine since users of transient refcounts don't actually access
> memory.
> 
> For private to shared conversions, there are no refcount checks. any
> transient refcounts are expected to drop their refcounts soon. The
> conversion process will spin waiting for these transient refcounts to
> go away.
Where's the code to spin?

> +/*
> + * Preallocate memory for attributes to be stored on a maple tree, pointed to
> + * by mas.  Adjacent ranges with attributes identical to the new attributes
> + * will be merged.  Also sets mas's bounds up for storing attributes.
> + *
> + * This maintains the invariant that ranges with the same attributes will
> + * always be merged.
> + */
> +static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
> +				    pgoff_t start, size_t nr_pages)
> +{
> +	pgoff_t end = start + nr_pages;
> +	pgoff_t last = end - 1;
> +	void *entry;
> +
> +	/* Try extending range. entry is NULL on overflow/wrap-around. */
> +	mas_set_range(mas, end, end);
> +	entry = mas_find(mas, end);
> +	if (entry && xa_to_value(entry) == attributes)
> +		last = mas->last;
> +
> +	mas_set_range(mas, start - 1, start - 1);
Check start == 0 ?

> +	entry = mas_find(mas, start - 1);
> +	if (entry && xa_to_value(entry) == attributes)
> +		start = mas->index;
> +
> +	mas_set_range(mas, start, last);
> +	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
> +}
...

> +static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
> +{
> +	struct gmem_file *f = file->private_data;
> +	struct inode *inode = file_inode(file);
> +	struct kvm_memory_attributes2 attrs;
> +	pgoff_t err_index;
> +	size_t nr_pages;
> +	pgoff_t index;
> +	int r;
> +
> +	if (copy_from_user(&attrs, argp, sizeof(attrs)))
> +		return -EFAULT;
> +
> +	if (attrs.flags)
> +		return -EINVAL;
> +	if (attrs.attributes & ~kvm_supported_mem_attributes(f->kvm))
> +		return -EINVAL;
> +	if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
> +		return -EINVAL;
> +	if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.offset))
Should be
if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.size))
?

> +		return -EINVAL;
> +
> +	if (attrs.offset > inode->i_size ||
Should be
if (attrs.offset >= inode->i_size ||
?
> +	    attrs.offset + attrs.size > inode->i_size)
> +		return -EINVAL;
> +
> +	nr_pages = attrs.size >> PAGE_SHIFT;
> +	index = attrs.offset >> PAGE_SHIFT;
> +	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
> +				      &err_index);
> +	if (r) {
> +		attrs.error_offset = err_index << PAGE_SHIFT;
> +
> +		if (copy_to_user(argp, &attrs, sizeof(attrs)))
> +			return -EFAULT;
> +	}
> +
> +	return r;
> +}

