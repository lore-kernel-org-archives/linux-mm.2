Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F0C0D4A5F4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 08:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D251D6B0131; Mon, 19 Jan 2026 03:03:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF976B0133; Mon, 19 Jan 2026 03:03:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F0A6B0134; Mon, 19 Jan 2026 03:03:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CCEA6B0131
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:03:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D0441406A7
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:03:29 +0000 (UTC)
X-FDA: 84347973738.25.16EDFF3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf18.hostedemail.com (Postfix) with ESMTP id A65461C0005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:03:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PLsdbfsS;
	spf=pass (imf18.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768809805;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sB4LxW1Chlm2kIHtKsmG5jzdQpZRxHKZaNYdn6kr+2g=;
	b=FHpcntwFMcSPOqXnyfecMjsbhGbehbCbFP1TbzJfrpDpjsfeeclpi+0EAOaX7qVttHpUjs
	f06PYtRWbRa+HpjKq6mzrdfUtPcFDQGs5HHDLELNE8EF8U9WTXu1D1uTwkpFgUU25aXeJB
	oFAoupKe5rYQ7MdShKf1CjRmbz2gjok=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PLsdbfsS;
	spf=pass (imf18.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768809805; a=rsa-sha256;
	cv=fail;
	b=JUl1gjkpypHoqd1TGPrSgpMukPKUvFPjv2E+nHsisk0C4D5RAOz+ySwO5OzKyNHOo94tVm
	xFW+8wnuhCbUjZOOcIazW8fo3fPFHrnSQjoRkajFMrMzwRI3Jqj6/34nzJ5hKVMBpK08O+
	3ItCgmMC5GMPmDD2df4GGp3F+Wc0a4s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768809805; x=1800345805;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=MA7GmuZDOnxNSGB3qYApMpomRrmq2/xMchfrqr2BUmQ=;
  b=PLsdbfsSCTIiqY3PsmgtRW1uUFy1eXJHOEKQ1+PeJB4CUYxKJij3cvq3
   dtXOi2qTHIw+J08GlZ4nv0sDrkBJZCchGoR/5xsE4ZTf1ltbz7ACZuzzE
   s72FeOaHyQ4BRokEUrRyh+meJSbgXkN4fPfes0Y3sxmtldZJf495E8Cel
   GzWz8MvK6q8FI4oHhgi0kLlqc9n63jeR3rhtndk+pB6cqUfyuucZeZm9g
   BEhuV4Lu2QcAWE1iBuuYqQAMgN9sxfHnP0jnGWyW+3GpCvKpLrzh47Rm2
   tIH0vvhQ5X0l33VqdyJB48Sl3+ce76junVDV5fdRbS6rQbLRhZ+dW79/u
   g==;
X-CSE-ConnectionGUID: dsW7epU3RAGxwQojAPW19Q==
X-CSE-MsgGUID: a+cbok4oTKaSryPNBo+/dA==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="69919922"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="69919922"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 00:03:20 -0800
X-CSE-ConnectionGUID: 3Qk5rQz/RXK3Ti7JZc8tvQ==
X-CSE-MsgGUID: Y6I75pqsTlG34pD6cE++Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="205419650"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 00:03:20 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 00:03:08 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 19 Jan 2026 00:03:08 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.4) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 19 Jan 2026 00:02:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C2OiRn7AV4hjTW8BRvnoiSojiDeP/SlAqXcT9hziAXsRlx3R+OeMufbp/DMfL3Fvr+SXzH8dRzOy0TfXkkigCstk5ifZ4C1xyTtsXgOF5XheW7w8w032FbXhXY+HYvvGWUt8G0/8TmTn9VpYGyBDLRmaw7+eLh0rCgvWiFFaQOKgmR5qJUwHU91IdFpEcT2gT0wMW/GxDH7zA9O0kPaTmPcTgtHrRgW9D/gbzuYSYB1WZVBg2VxmjV1L7CTmcbnFYU9EPMox46LY4ZG2UbM6u9bhnehf7/IzV3pBsENBot2gll0r23RbPzna+8ACXCE4TFsOn2+QX+X/05iLi1GezA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sB4LxW1Chlm2kIHtKsmG5jzdQpZRxHKZaNYdn6kr+2g=;
 b=t3lWn66Q3hz6nH/LDXbx45BhwNaAsskvk36vhTwiiIvksAgKdGWjpxBy2z6dh/fkY4IQSduZ/uRxremRB2mVKOa+PSCkxzNcknOJGuxWLgPjj/H/ircxP4Y8Ajnbqup/xg9wwkRO+6jzK5l6oGxt1HcF7WKIsCe+1vxymk97MFWhr2vDLt842GIoUnY7sYIa5iByDJyWmmiaRCRubofl9EmMS5X8AK47UjCvL8Bc1au1Mb6/9aYtb4t8QsynTevyBZ9+EhPeoUugPlcq2S1EE2zE4UZkdR12p4gOdRJ0q/g93cqscXmz45WgjYWQIUWwhA2xw3BIvoB9WSjFRMFYDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7318.namprd11.prod.outlook.com (2603:10b6:208:426::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.11; Mon, 19 Jan 2026 08:01:56 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 08:01:56 +0000
Date: Mon, 19 Jan 2026 15:58:50 +0800
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
Subject: Re: [RFC PATCH v1 01/37] KVM: guest_memfd: Introduce per-gmem
 attributes, use to guard user mappings
Message-ID: <aW3kOgKL7TjpW4AT@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <cover.1760731772.git.ackerleytng@google.com>
 <638600e19c6e23959bad60cf61582f387dff6445.1760731772.git.ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <638600e19c6e23959bad60cf61582f387dff6445.1760731772.git.ackerleytng@google.com>
X-ClientProxiedBy: KU2P306CA0018.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3b::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7318:EE_
X-MS-Office365-Filtering-Correlation-Id: e9aebaa6-1ff9-49af-6eb7-08de573103fc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vVYEliQ/LonOBolkZv2Q5oe0XBFj7QD5zoZgYtLDBQrbJEe+/DPYNSxfIYKF?=
 =?us-ascii?Q?fiN5lI62/uDxnWspOXPAsFeLK+a/nRCGimACzWpoJFUESaIluabZzkbtM0cb?=
 =?us-ascii?Q?ZY52UDr9w6IV5x44wjhCsqGeiwpThJrYy1JuIet8QVQGmTH3ZI43gnlR3F7m?=
 =?us-ascii?Q?0PWWIqTuCZNuhyZ1Szre/GMsMuDzx8o1q12Hj8xOXwdE77NalZjdQgCAxKOy?=
 =?us-ascii?Q?vMhiUZAeo//FEOQ/FNrW9dUMJDyCYlyqXqI9L0fvkGcqL5+atJW1FoIpwkmL?=
 =?us-ascii?Q?iTjk18jrBYwHiub3vUHp5z/f0j3Q45Aisw2ZyjFxincfD4z+Sx3kNGKv3Xwr?=
 =?us-ascii?Q?HOm60QWUmEYe7MRAR4yiEZ71ABZvzYBDvZuO+/2P+x1dbtKoy7wOu15G0ZVD?=
 =?us-ascii?Q?btZNo40AuP6WjBUkQMarp3YmOy7kXBpYu+S2zpXD3hszA/M7M9ByuNgEAQUe?=
 =?us-ascii?Q?DR0X9p+NAdV9floxiAhahbCb0NXy+uQ+9lC6GA/Rz4o1d+VX0MfSMmEbdZS9?=
 =?us-ascii?Q?4FqJXFlWEAYMt30+6qrB/Ma5sdjf7/39uSn9B0pEWJFJWeafotVaWR8MRmB0?=
 =?us-ascii?Q?D4sIsg48WnF8ZJeTJhHLQGFxoVMYCaUP0FEo7Vqe4AfCwI0kkte3Oi6Seuxz?=
 =?us-ascii?Q?aNKWyA+fq5f6Rjmj412/8wXR+CMS7wcozINuKGJOF0AE+wyw+2nK1Th/k5MT?=
 =?us-ascii?Q?Wwih5dA+BScPFvxU1Qi7FCVSeEkGYHwzovwoUf9oDU6gUjCjQpd/NqphPCe9?=
 =?us-ascii?Q?TlH8exxvSCsa4GTJ0l4noPSERZyD43fe0qQJ0dpatntyXQKalQeUC17qTI1r?=
 =?us-ascii?Q?B+WBK2L3gMmbKoLKOM/pJGc4p3JdBVWxrhRLgJrQwsihguMjkZX1jifbnQm5?=
 =?us-ascii?Q?D9u5Vqcc4uUuq9gfNEKeRQ8C9WzXzGP6PO2mNK1ATH+67Kk7B3yGUgvSR1bJ?=
 =?us-ascii?Q?weOFCUDFJVAkQf4mZrnN24uP0vPYDbljZwvkPulduQAzz+jfHBNOhWkhH9Rz?=
 =?us-ascii?Q?TpjzOAOXs9sQo3eIvcjJJ2jrdbb9gj69X4XJPVFKQckwwWZz+5dEm1xyd2wh?=
 =?us-ascii?Q?tJeiOw76HZYqjXaKl+vAn9j0kk4L2lmQSeKTDtIbMm82C0nhCem4T0QsxffQ?=
 =?us-ascii?Q?W9VHhQ8zJXu0+Yg0UOiuIKCyoYSYYjRKSCLQyj+wtKGyyxX9bDr9fQwpTMPO?=
 =?us-ascii?Q?kPxbAFPXvCoe61UEyHQAQBx0l4m1nT6GZ1Gospnn5X518sFmgnFmuVibVgBk?=
 =?us-ascii?Q?izVGEWKdVnQ5Su+iUaMAN/6VRayPQQcwLNrYBXCR3X/MPve8bsTk+DgSp0tW?=
 =?us-ascii?Q?6u+cAna+Psi9o+uDnHqN4Km2OnHtUgzaLGno33C7hAP2ZTCJ3NFNrRypsvZv?=
 =?us-ascii?Q?XvS/Zc0Wj+C2gWcc2yXX8KTgU3CQcKxF2XHubP01sel487mpPBKpEQxzs+Tk?=
 =?us-ascii?Q?4mUwfMcjc+wcjb+qRPrc9Xd68fKC07+zMCJTTkSwP8LRD6rvz4EDR8DL2t6j?=
 =?us-ascii?Q?HWtd8ac258VF+WQIF82s5YL/BJsSmAqkISqsY75Us1k9Aw/n0vpwl3YVfu/0?=
 =?us-ascii?Q?wyy8JpibX4Z15EhI6HE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mk+II8GlOPbxLsfdzqvDDcoV6reG4Amx9JC1FVOlmFhyt7Rb18i0MsaqxHBg?=
 =?us-ascii?Q?khVDv0Gi+TTvUaPeS/aLetiwUynXBN2IlGXIwHeNywag4lVvDKbG5eCCzlmY?=
 =?us-ascii?Q?barwTCrQJu2lQIbN2Ny0LbL6gBzP2sqbyjXuIUqt+GRnyPJZcHxTTzMdSThO?=
 =?us-ascii?Q?Tt0jTKHTfdkcMPe1mxm11zJtEnBgTyUcLpkmtt9mruJZzcOuxOVybslScD16?=
 =?us-ascii?Q?nFWeCT/ttKObZuYPCf4BXvWH6xL8bM+19xSPzMsI+M4HmcT26fvjpgccAOZq?=
 =?us-ascii?Q?x+2unrHKpWsa8czQV6iWTnuQMy0ob0zu4EW8LfX9tf2t9V4VAxYWJAox1fjQ?=
 =?us-ascii?Q?120FZBtQv2fNHFkpmYfrW6e/oCphlODPFZJeu31UWJBAqN4No6P96A/Vzfab?=
 =?us-ascii?Q?ve0WA7nC4TGi+wvQDfrbkr7CDbA793UIUQb3cgoFMS0s5nCPYixzlv7Yq1Pl?=
 =?us-ascii?Q?wlCCkzv6YgEMa8NWX3P8UE9cL58puwmaPFp2InX0SMA3MSbV8sP8I8n6e0sG?=
 =?us-ascii?Q?mTgwS0hdpor41QNHXcLoNgUYiukcJem6EnyOOpWk/DoC91SVjRf6PjT26Thn?=
 =?us-ascii?Q?0pNKQBZ0crY0uBYvpO7aPh7h8m/sNPEgdyAJeFG9EUJo1z2v2esFfaKB17+/?=
 =?us-ascii?Q?3Jkr8+R3+/VD3I8sd8hohpjJtsTcDvM1K2Jo2pzSidEk6Dtl6u98k9yEPHoe?=
 =?us-ascii?Q?02O+h3WGFJEiRwCCtgGk6u+zzyDsOa2jA5Mox3Vm1CTaOln4sxTvMlmKK3T5?=
 =?us-ascii?Q?XCa9Gi5cImeR87NKWL2V64e19Af/Bp15U7UtQeGbz5ws6req5o017NBPDjf3?=
 =?us-ascii?Q?wOjavsr/KZWUOvK8fIufW3uazRBRqMIjuqiSSydKwP89NJSiKgdjNTgUX3mI?=
 =?us-ascii?Q?QAOGaO35kJJOj6pLuZSgEzpg6/35OiL89ae3WWt+YFPmHDz8T0SHbxTyf2bi?=
 =?us-ascii?Q?XOtRgYnL/Ji2PBK15gtdRqKR4bxCK7/4QB+6H9vGD48J1G0ebB+x+QfiNXRr?=
 =?us-ascii?Q?9FKOsWTs9DQK5/HvL/Y8vcZvesHWyGTYdOeoxDTvb6ZIM2YzJNbGvjJJm33E?=
 =?us-ascii?Q?G11g0FKR+IZdGKKnzob0l5wlmlYVq4Fw0RtdJI+rsI0HqUpyW/v4v5pUglex?=
 =?us-ascii?Q?DAbjfCCeawNFhyBtEWO0JYbxI1p5dLEPYpQ1S1ghHba+UWBa5lBeuo99YVZu?=
 =?us-ascii?Q?OqimYnhF/HoFp/UD0qLZjqt0IrmsIZUdAnq7pY1eVns7uYnR79IeTlJgESK4?=
 =?us-ascii?Q?HWmy1rpGmdSD1zP3BRp44scJ4jk6W7wRjJCjwWe+Fa/8+p8VLHifgZvZgmX7?=
 =?us-ascii?Q?xbAAnf6waE3O1YjPzR6647L3p6wyWLgVrP68xz+QNWc7dLW5LVIiCrj6stcx?=
 =?us-ascii?Q?/pWVeVcYwa+fC4/6N7oQ5FcROgezJqWqa5gcFAe9dlSzjt1Yud2qxOl79acQ?=
 =?us-ascii?Q?oMsmg/bBwCYikikdg72i4Wq1LXMwzgoVzol1P1cal85IJaGrkr3PcYmfMkLF?=
 =?us-ascii?Q?1vfXwZPDJkg3/5ujNtjYbAC474gNEdvEo8eECfhznZdycKs6tWcwzCKZScW4?=
 =?us-ascii?Q?i/Q0iAN0f9qv7i8jp5fkVt5uq9piuuykx60lA9x+odtneoXU2aGSFpjuvQUx?=
 =?us-ascii?Q?x3l5PGEf0kEPNm4daE8l29rsz0ADNcsQFBcsHB1VcU7yd/EzCA53yjrvZUEI?=
 =?us-ascii?Q?8Le8dJWbRMFqbBx4PWgEcBc6wzsdhxJLAxpNgY4QQS0cOfUJjPK4EC4c0jXx?=
 =?us-ascii?Q?k5zb7FkoTg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9aebaa6-1ff9-49af-6eb7-08de573103fc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 08:01:56.7488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /I/VKXl71tByz1N0PLdAnEVN+FEV7A4CewPoV/LHNxHibidz/KYicbmjeYFYPrtC9GUF+30eQCGZF5FryDQdjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7318
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: A65461C0005
X-Stat-Signature: 9xj6onughczhfx7zsbbz4rp5hz865gsm
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768809804-708974
X-HE-Meta: U2FsdGVkX19Qim/EKlGv4MrHdwPgBvQONEYIyf2UpDVjjFcg51db0W3mwsxnEy3s3/oV+7acKRBrVt6TjyKibq5IxqPKvCRo5OWtorjv0MzwwtThg7WrSjb956S+ftnhgSSvvG6VuxDSwukX3+DUol7rTbYk1LZ6HJdDiVv6NM9CODiJtmYcTuhDfOLA8Vyiaob0V9FxOWjbRrUD/wVBUlDS16qBrB54TcsRy+p/+s8AFW4/xwzU7/07mH7X6T6Dk3OEhAv11H9WlWJq5Qa0q7CdDYAADLwu+VapWAV+8F+U+9PstROtgzIEDYvvVLQmIMLLwUBfDJQtChyj7XHF+a5SK6TdqE9lGNISRUuPsv4V7m/CcKm3MepD61gPqI7O1ntQ8HliU/IM1fqkiFXE4ALsapJYllPcIMQPEf9WlVcuILe5hy7pprImae6ZoVMtjVSbDIEE+dD+Yaix+qmRmcj+e7PziTWmYa8JVQxXVFYsqyagSbde4u0+0a6CpKUcitkd1X62crUWDR4h/RRTZPpzHse8OGPequ3cLeNF5xEeRITQzT6yZRj1VWfwpOXLQ6uHLABoqup53L70OwukzAhvcJFKMZa8rOmbDSkhV38l330AJ7u0h7345r+OIEcW/9rCRoJY9JWr8MAD1QkYebJ/mOJM4p0uBHb2vAHjI0+jVU2IxeC0iriywt7rND18FnxhiRbArKHJBklVAz5ynj0nDleZySkc0fp3iMkYkGPWp0U2otoW7TqEKT/iyTEDyFe0jzN5oam/MCzrcw+Q6/6iYqLmSA+nOvndhASQ0m586+VMwDjzwRHo3WukwA5WfoHNuPyp7kOv/gNUbKG005YIYyGfC8LsdjCZNOFMa8c9dZr3SmTYTqffzXpi8fInqcMFxf32n/aRv2chBpuMldbJEPFLARbpDyqWu84IzCXqQYS7yPglvt+pCAgHOwVJzeb+3XEbZubCS7Y8mV6
 +4+s62LU
 VGI6a+qanfvwIVdqs0p41Bo0/LQqKg69ex9ErWbFaJWx4WHtW+d74MDM5KaQF1vPmIUYQ9jiBwgMZ81nmVxWVy+XMaKOEYllBKc+2gBBjVPR7YF0KRw0VZVrxtNMXaBJE+Y3HM4nm96Z656p+Pa7bG1n5nApLYcJR85v9o7Vee0qs0LVizEDKLEfMC9x8iUQUlzcEASiZB6tiJfora42Wckd3DKWmoRMhRcpsjkOtC6W9Mzf2ti037j2HsvLcHzwPuFNJ3NMerqzt5cqtmhsPpr+wZOH5qs6uB04M5c5OOUXMh/cTtv6dDjDViEDD8ZfFPqUyR9bdIdpUi2aXbKMNOpnJAaK5lGSV1RYkBCFFPTVeSjMclFee7leF9N132EwvHZF6b6TrPxM26X9mHzUgCnH0M96L3kpAvXFwB/XwuL+v4fxBmRifVi6dNalVoR+QT+Vo5eI4lJfxo/WJEeM7vqeqNdigAee8hQ93zcQSfs05+4YEyR1XjsWe7EsMdHxsgwnJdg5rRzA16EBL+7ZndTfauanwjj0UOLUdAjwfMm3nmX9t7Lpup2MvjsKLwQTUdZIVOzYU74vbScKk2ocsceLhBsnE1MnvsHBOnJ+46hDPv1VgktPSY/lniV26KbKA4Eqhl9tF3oEVSbrp345ZKtcBpJgEbuWF6t4kWTMxptfWMWGC0vzew2IXtIu+i98ioiubueZoxdY4abaDkbpndNngJXgFYjQ7KyOvRVJ7qRcoJeU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 01:11:42PM -0700, Ackerley Tng wrote:
> Use the filemap invalidation lock to protect the maple tree, as taking the
> lock for read when faulting in memory (for userspace or the guest) isn't
> expected to result in meaningful contention, and using a separate lock
> would add significant complexity (avoid deadlock is quite difficult).
... 
> +static u64 kvm_gmem_get_attributes(struct inode *inode, pgoff_t index)
> +{
> +	void *entry = mtree_load(&GMEM_I(inode)->attributes, index);
> +
> +	return WARN_ON_ONCE(!entry) ? 0 : xa_to_value(entry);
> +}
It looks like kvm_gmem_get_attributes() is possible to be invoked outside the
protection of inode->i_mapping->invalidate_lock.

kvm_tdp_mmu_page_fault
    kvm_mmu_faultin_pfn(vcpu, fault, ACC_ALL)
        kvm_mem_is_private(kvm, fault->gfn)
            kvm_get_memory_attributes
	        kvm_gmem_get_memory_attributes
		    kvm_gmem_get_attributes

> +static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
> +{
> +	struct gmem_inode *gi = GMEM_I(inode);
> +	MA_STATE(mas, &gi->attributes, 0, (size >> PAGE_SHIFT) - 1);
> +	u64 attrs;
> +	int r;
> +
> +	inode->i_op = &kvm_gmem_iops;
> +	inode->i_mapping->a_ops = &kvm_gmem_aops;
> +	inode->i_mode |= S_IFREG;
> +	inode->i_size = size;
> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> +	mapping_set_inaccessible(inode->i_mapping);
> +	/* Unmovable mappings are supposed to be marked unevictable as well. */
> +	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> +
> +	gi->flags = flags;
> +
> +	mt_set_external_lock(&gi->attributes,
> +			     &inode->i_mapping->invalidate_lock);
> +
But here, it's declared that mtree is protected by the invalidate_lock.

> +	/*
> +	 * Store default attributes for the entire gmem instance. Ensuring every
> +	 * index is represented in the maple tree at all times simplifies the
> +	 * conversion and merging logic.
> +	 */
> +	attrs = gi->flags & GUEST_MEMFD_FLAG_INIT_SHARED ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +
> +	/*
> +	 * Acquire the invalidation lock purely to make lockdep happy. There
> +	 * should be no races at this time since the inode hasn't yet been fully
> +	 * created.
> +	 */
> +	filemap_invalidate_lock(inode->i_mapping);
> +	r = mas_store_gfp(&mas, xa_mk_value(attrs), GFP_KERNEL);
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	return r;
> +}
> +

> @@ -925,13 +986,39 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
> 
>  	mpol_shared_policy_init(&gi->policy, NULL);
> 
> +	/*
> +	 * Memory attributes are protected the filemap invalidation lock, but
> +	 * the lock structure isn't available at this time.  Immediately mark
> +	 * maple tree as using external locking so that accessing the tree
> +	 * before its fully initialized results in NULL pointer dereferences
> +	 * and not more subtle bugs.
> +	 */
> +	mt_init_flags(&gi->attributes, MT_FLAGS_LOCK_EXTERN);
And here.
>  	gi->flags = 0;
>  	return &gi->vfs_inode;
>  }

So, it's possible for kvm_mem_is_private() to access invalid mtree data and hit
the WARN_ON_ONCE() in kvm_gmem_get_attributes().

I reported a similar error in [*].

[*] https://lore.kernel.org/all/aIwD5kGbMibV7ksk@yzhao56-desk.sh.intel.com
 

