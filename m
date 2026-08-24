Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E968C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453016B00A2; Mon, 24 Aug 2026 05:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A5E6B00A3; Mon, 24 Aug 2026 05:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319506B00A4; Mon, 24 Aug 2026 05:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 090E36B00A2
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:06:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D6A01604B3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:06:19 +0000 (UTC)
X-FDA: 85135581678.02.4BC0EC6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7475D40004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:06:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I47SUvik;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787562376;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/2LCvBnHaO9ANKU9V7yoMlHmoFHEgZJgIW+MbscRQtQ=;
	b=SJOVKgB+3tb8rimTqK7+0KlOZyoIfSllV6ZV12oNwtMsLRFuarFgH96ETRT8wbpLYs7bkq
	OSNiCou8ahw8hrVM7T+T7DI1Emqlv1V+KPnl7J+SHfF1sZ/WgNwbA6F5mRD2y3O3WoRntB
	2nrCnxvkn+qz8NM8mSGFXWLXRIR4rTw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I47SUvik;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787562376;
	b=I5vEufwxFogtoN7wptfow2lbtkePDxJKO7w0H9ayIum8rsgI26pTcZpTL85a/6DIfJ9Pb6
	vghYsqu4iA4ck7Z3jDa2m2ZHmnKtAuV2qF5wb31RL/OTmbFYUp3ndqsOZrkeliIcYc2UuY
	Ye2yvNLvwyJzX5hljEVKByZx5RcBWxA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787562376; x=1819098376;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2rGITChiqjTVCYTle3vemLDR0BduuUlgb4jcsbW3RQU=;
  b=I47SUvikjX5xrwplxyrYUJvZe2uVWxIzDy7/XhwpliAUuUcQ2XV6jH03
   KL7+Igpa1mp1P2gw9Gl1v2Y+s4gfsri5Sk5zp8/JnVbargaclCccLcBRh
   RGOULSoHuivjYM9L0P42aheVsprRFu9C4lqMdJzPLlZ9WDjR76H1OTAL9
   h3weLgM3mZMDNUAInGMtFUGK6d7GuDSa3rqkZ+tLPfqRccmSWlmWrlgkv
   F+7ST/xf5mUQfLNFjfM8QZbO8CK0blrQgj5ZtHTXyiFIcBAsnm0gl5U58
   DYIQ45DIG5PX8/LRQpw6PDPzRlUnjgzJAdq6otnelOJYevUfWtlD7ntvb
   w==;
X-CSE-ConnectionGUID: zOpe6FKnQ9KEXKOLK2KLjA==
X-CSE-MsgGUID: en6kBXT+QhyRrCaWfjtO7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11884"; a="87773939"
X-IronPort-AV: E=Sophos;i="6.25,240,1779174000"; 
   d="scan'208";a="87773939"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 02:06:15 -0700
X-CSE-ConnectionGUID: 1lnlxijqRAa3GxU6kc/OTg==
X-CSE-MsgGUID: mQjPLqoWT4O6LtetdrIlFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,240,1779174000"; 
   d="scan'208";a="260799742"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 02:06:13 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 24 Aug 2026 02:06:12 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 24 Aug 2026 02:06:12 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.64) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 24 Aug 2026 02:06:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n6Hs4smu1Ax69Dq+N4mrcnJhnbBd6CpjRTVBPcn/E2FfkrlOyE4zAsW6UHJdfjxLbF2NROMs76NO6qkGuKbokGbFPKE1n7v2HRU+Eb17PtXOwL6KBJHT+NvpzR14ku/dp7VUAQJikTTCS+JbsE6PCLquv6FmU0KH+8s5rRj3QP/wh19NWuDY653BQ87q+xXK+LWN7Ldf/YVjNfX6ZJVWuWdfa/npSlH5rN9vkdcvKiuggSLgVbY7wmDTlTqacHwqfR1Ef06EKmAFFAoA5fcJmJ/CnqdGT8whU9qICozTyS1xhj+yLSbHJ2cyAyLxB9nhQaUk6mWlgyT8m8yHJgXe5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/2LCvBnHaO9ANKU9V7yoMlHmoFHEgZJgIW+MbscRQtQ=;
 b=LpxduMO51rRhpQ2taOlucTzyItHR+8cqF7qkgr0P0nh8giul/a0Hk3HAVBsXxjn4VeRPnC7Wr0FuiVvdF1vKxB0PIsZqMOBDI3Y3RAngn46PASzlM1zilmc4w+HhY3sDzHSjShIhzHaPfVJKut1Z3nM2Qa5cPQ8M/8rv4wAu168a8IN99RXTWbmR0GmJmNcKGIBacB7YL+m0IQoQDDATzfb+pSZeevMiz62/KAoEq7x4rmgZDKJE9lCLXBTVhjBbLr90LqUakUjkdcDAbOyy0T3q+sNU1Fz9TtR3hc0N+oD7rwVwDNAyYlt9x0DFByfXhICugs3sa/DFLTD3MKehTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
 by SA3PR11MB969295.namprd11.prod.outlook.com (2603:10b6:806:532::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 09:06:09 +0000
Received: from DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d]) by DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d%3]) with mapi id 15.21.0339.008; Mon, 24 Aug 2026
 09:06:09 +0000
Date: Mon, 24 Aug 2026 17:05:34 +0800
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
Subject: Re: [PATCH v10 18/41] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
Message-ID: <aowJXhCdxy9j2qJf@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-18-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260807-gmem-inplace-conversion-v10-18-2fc18ee6d3ba@google.com>
X-ClientProxiedBy: KU0P306CA0086.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:2b::19) To DSVPR11MB9579.namprd11.prod.outlook.com
 (2603:10b6:8:383::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DSVPR11MB9579:EE_|SA3PR11MB969295:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b829e63-a8f4-454f-50f5-08df01bef025
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|6133799003|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: r170g3lkWIWBFucUUog1uYF/rF/POjRR1gV7KkTPeCsXWgzMfpwbfERa3txFUGU+jFmtOf5baH2ItDXLWYjSed3UylbeXRJWhbJdnMKKPlwptIolPLrYW60O6CqzH07ucvp5BP2UWpb3yqOvXJ0Q1SW2VYPIcnC8Gs8cDhRHqlO3Hk11+WfN5P9DzX9s8BNg5YcerqNobZjkf0ATgTnurnDe2pfo1XXZcAy17Q6KfDb1tJHmJAZyrGSp0GikNW/xrjsOeNMQBXlJp9O9MAkBgNEu6K8f6pAl/R/nbfW9pt3LlAL0Q4w42adv/04wtKqfs6rcBDSV5G9Uy3fBrdg7pdpXvu27f4s9YHBZ8hznJMLH5moN3NZU/WIcak+iKED0WoYkfCO5Ggs/BKJQyRqGzxJHrWkIhOTpLziAOSCkDDn+MUNo9vfIHzrCynOmoo81EMKl3BzMqbs4M4TTUQ08pU9QxlMOaiWjeRwcmO8dek3EP2gBJ+eSHQRLuWwMJnaX/RKZ/WPp2qyXr3ktxblurMbwnfPTHf3UCgLieaUYjUZJnMOdEDKbGM1AExoK1Tf1wtEnHc2rfWmLj3dc97oqZzO8RHPPuY9JbaPRB924JJd5UhkpdMbQov28YnWri4oJLc3qBMP81F3qyTRqGoMpaohK0V66XKUX/n+XUlcUEs0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DSVPR11MB9579.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9mV0qOnl0DpKQIJS0wefrHaiVSzW30FQR7z6kh+C34dkbIpxQ/aCnS7+B3JU?=
 =?us-ascii?Q?ptrPqK+TF83+V2zORcx3eTxJ+0OCEHtdqcCD+HQs1HcP5fr4gs4BGZMLxY90?=
 =?us-ascii?Q?oZXN28Vhmm7Uh5mBxEEqmfgOGVf/ybu95JOJ1lRpEsE51vWnvebpF+nR3s4S?=
 =?us-ascii?Q?cNi4dFEhimvUqu1YsU/tdaQPYu3fHophoNj+Vq70lQqxMOloxoTBh22+9HiY?=
 =?us-ascii?Q?+iqeVkJqN1gbPnYptW4xUAhLGgh+X3+/sUGe4AI8YqAp1PO1IsUVnTpI4C6E?=
 =?us-ascii?Q?nlWsBgfgbQltcObud7WILR0hSTx4m5BJgQq4bZg6MghdSqjTKnk6FlvuBOBS?=
 =?us-ascii?Q?Cn8xTxWBwXZCAJFYQZhq4543cldSooiLUkba3j9AB7YrRBO6fnewCqTnfknH?=
 =?us-ascii?Q?z7AnLaQj4GJNfeUfeonszmIwp8M7vY4IGDL6uXmThEbwUBkXtpQBpfbQRLqn?=
 =?us-ascii?Q?3DZCLKDwTQTBJjWkaXA6zySxJ+vtDsgavuLjZRLadfRFapRsMNjmGqrw5mhl?=
 =?us-ascii?Q?DXke8h+o7rnfaHKjMgAouSR7vFMx3lkVqcT5OUyVw27yZTek+TTV9BOhudul?=
 =?us-ascii?Q?33paZMomyQgYk7az4d3EuJhkqNL5HEXWHsXd2TrgauukfCxfAkpwURbuFR8T?=
 =?us-ascii?Q?X3nkDjgbS41Qen/U5qPXitGqjfesrTVnoLRWz1y34mJu0FEK0IGupJVziEdd?=
 =?us-ascii?Q?g408eDEd+MNQ+85Otr4oCmsYjSbNCrMGlXKDcFATVdApdwYpr/l8IQ5K6eJU?=
 =?us-ascii?Q?jic+pM6XUMjNlgX4sjeS/KzUUjXvEes2R9C9UX7xLEA42U42cgyBGkjVulq1?=
 =?us-ascii?Q?KZmlkuJ6pl4fxiZk1ApqA97FFc7bq9csoDC8HSttRA6stkSlS4fs84VDuB5k?=
 =?us-ascii?Q?xTOfWMX4FRdCRAgInJSlucQq4xc2i2GkWbxl6jj+OpCs97HQs9DFHo0Ks5wb?=
 =?us-ascii?Q?/7OA2N+j7rvIWLm3ARzldS0NMZ9oYZP3nV/LAu96fhYaxvOQ76Y/U0MhydeO?=
 =?us-ascii?Q?j6YN5ZU1enZldG7OVCEtjkothskpej1zp7f5GjfR4GfByBmFWNY72EjQOM3O?=
 =?us-ascii?Q?yyTNp0TD3ZjEP2R/KPD+U9jEgE75Durf/Y304N2gUw+AaC3W8IWBirP/jcgx?=
 =?us-ascii?Q?s843mdqiET8OM+2nVFoAHQo+U5p/1efFrOXA6/F4fkY6yc01GI6diPcE0y6q?=
 =?us-ascii?Q?Mg5esPheUXk3KtR3I470+EyqPo1TrOLSxD0xwpPp1uhol1WfgRZXWFjkZWqA?=
 =?us-ascii?Q?O/RxwcdaLZ/2axkOMsrL8a0jz6W4XYCVbIV7OwreSrncCvC3ladLoSBIFNnN?=
 =?us-ascii?Q?9cmm9Ou9NHC/OmjKlbe7BO9QnHNx4URIKSBOJaUPyfuJ4A4rJ5XUTiVIK77f?=
 =?us-ascii?Q?Js2FBC8e72Rh9pTEvQZ/RvgzY+jl1aGwEHFvlE8ImtOZ/zh80ItbKxTAU6fI?=
 =?us-ascii?Q?hzWgz5R22A3yG5SRY59F49oW5RVHK4CEvH7lq04VSJ5NdERVjlkrKn1K9fYC?=
 =?us-ascii?Q?Ha6mOvLjz7vtOTPoF+U6F2pefr7nieXAz4/AuZ89/6mai5bCXQzHdUAc3Vz5?=
 =?us-ascii?Q?thUlTe69PtQoXWKvz3s5aJVwSj+2vbfAKSfZ3pJj5cBDNhGC+84nY+eXttUd?=
 =?us-ascii?Q?NM7KQ32v7YBbQ3H+A1H+PmM6jnFgyYraCCOYb20sOiar2dqtYWXEC7zhRL7O?=
 =?us-ascii?Q?7BL2hnM0LJtjzwhgr9HjlM2O0li7pmklA63mat1zbsN6SALYcqvmV7yjDkZs?=
 =?us-ascii?Q?miyDjRQWPA=3D=3D?=
X-Exchange-RoutingPolicyChecked: I3Uxw5aIhiKjRl6mRa16fYOtCzIejqlFxz1OMmyH+NfwdrSfySdCEVXSclKCXfWd6aPxMOuto9PnGt80Iv6IF5hV2r7mgbE07+9HtlUgCObQXtmC+I1Fsv3uyCcsrm9ZuliKM343psx0C4QnvShuY4Tqr7jufryls7H4gZOJjRLfZ7rztIIPLjU4sT5nw5MnMbmYKdgpBbSzkbsrSSsaPTqdtMpX16lCJNZ7dWvedq35wx1zgnjRPqN0o5TkY7CCn1iHQZmTZ6d7VLykW2dub4ucxZGLUpHyjffrP4cRR8jUXpFdFVOsi48v++wOVGV6l55eagXeaOPFJxn/EHDZ0g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b829e63-a8f4-454f-50f5-08df01bef025
X-MS-Exchange-CrossTenant-AuthSource: DSVPR11MB9579.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 09:06:09.6117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4HShhGAl+T1VlVc/Sn5yBkRFT3WMDBPQuXMBb/0K9aQOLgUuSqz3euhFpFIVhjez/t0WsGxMPSPz2/t7BP58SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB969295
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 7475D40004
X-Stat-Signature: npeg5uxaqtc67kfxj35scgf9mdnuybii
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787562375-90702
X-HE-Meta: U2FsdGVkX1+ys5OYnqZppp37Hd/1Zj8Q1xMwNHKptjVFC5QTcTbWiZ6rLfXD2j+16pSCSCdU6itftYMEiXqjKv9LMteE4Z9IyB1YPpawJEF3BTE/4Z2ySwsaq46+5XpYC5JqmbDK800qVxMqdwCjMZgvkpSLjODkKpOLODCfWO+r2tPIwsZtPwsrOk8dcycfxqtxW7Nl9y7Ou1on8dxIOKlSoJigMdy9PYSlZyEOeMlxAUHYTuraD/Ubm3jtyG4SflrlS8O/FfsveymQIgbsoZsxUvjzNYINuf3c9/nF9d7eslF+Z4EdYGQOd68iB7ShGId9gc/k8B9wha4bY+nU5n82IDZq0KzoNAl+rq8Sf930zN8Yzpunzir0pKqIEYaH9k3S2AeiCxqDslEgpa8F+RB7IXPqvFTvAoqMeqTcDzWYTL9DWPWGFMEezgLHTlW6WeYMtV7+6xe7X29+xKj2f1K41sbpqqKXGpL8M9l8W3NZVIwP3P/7Tc9ttxzRObZbB/NcwDu6it8pndZlE75WizaMX8dC/fQEerbMsgNWFspNrADI53mkUDNunAhL2ATC6y+d2lbPlH3kfxuei/5TyRAxmDadhRgvaDpqNCCRUbGDL76cLl4StiLi2CTtt9ljf0WCJI+IYqabsmjFoqW7aHLov7AzG8UUKHLDuGLqr5hM7wZpAZuqzbyYpAJwOjaQKp+Mr7ivrPE7aSwVAs0+fMCTIcLmqrHM0tnmsVNK0Z+wMURVntVG7h3/FEdvRWWObofcWhIwgaDYPJQqtDYRqaCRqAL2jwU0mEZXC5WeVamZZtJ0tVfHxU9yZZ+L3cE2kIlW1A3w6M3iBajlyLf5l3O4E/oJ4zB+OWFwTfd5V8rBPAvMRmexfdjnaNceMuWdkxulOxhpZ24pBT6srbew1JhBRTAPUAAxjnAlw3P69/y4KNW2XuMhbXirimVJIVzpoy+h3ocdnM140smB19T
 NTFQGV4m
 7uWm+E0Hi8xYSv0QSIwhPd5ooGDVy/yhPeijcvK2RhHnZQhajpMiSo5K0LbVm33KDnz6TXL0P0iSLCLXTzLWm1OrHENOvtJhjbNtzwJl/K4b3VVj5yJnkI0iylN1z95Yiw2wlzgnMyC5G9bWx92M/YX2cLerICaXXb209PoaA8hlvrTQxCDnDRAr2wOp9iKez8l1cMWzi1zmMhJkLyHsKQz1GoBz6sDiTeOkQtH9urDQsXSl+/d4ttgBa3IhZXzmThEaizqiIcd+BbbDHfbm6S8xQhGnZEJcu7+ao1Apqc/qEdVn1GxXRoxuV0SHj0lAdno6hmaRf2ReK/2bUW3wVcRZagzOWQxEIgyY4ezOoa0StvTavZavrSrV6r/WmIWfOdoPkVrMEIGGOFk7HVTreHdbOTqRqNa4NGwctUh4DsUx7acjuX+MF0k8pW8WZ2kb0b1Ui8Ct8tP1uwiExFkOSxGyakXTyfJWopKTnJEOELRavhsCfNp6i2/tV5bO6jtv85gKKAKzfFAvBRovyuZEHSwZM2Nyyz7VWWZu/MzN59KA1TpGBu8SPk5l/bz29HsqIXhzsKx9T/Do2i9fjUsP/c9AXO9lPagosCSWkS9EWbrLI97j5AlOR3RNxOH3dlRLXzEYfxtzvgrGoasnb7X5d0bTfv+22BhCxdCkdYrNqgs91WBlkx2h0pGXoCyOLGPHRDjbH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 02:52:57PM -0700, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Update tdx_gmem_post_populate() to handle cases where userspace requests
> "no source page". To handle "no source page", populate (perform
> TDH.MEM.PAGE.ADD) using memory in-place at the target PFN.
> 
> Allow "no source page" only when gmem_in_place_conversion is enabled,
> because retroactively adding support for out-of-place conversion would mean
> requiring a userspace update for a feature that's being deprecated.
> 
> Also, KVM supporting "no source page" without in-place conversion would
> effectively be an obscure zero-page optimization that relies on the page
> being zeroed when it is allocated by guest_memfd.
> 
> Rejecting "no source page" without in-place conversion scenario is valuable
> for KVM developers since it helps newcomers understand what exactly is and
> isn't possible.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  Documentation/virt/kvm/x86/intel-tdx.rst | 4 ++++
>  arch/x86/kvm/vmx/tdx.c                   | 8 +++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> index 6a222e9d09541..d8d9409120e61 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
>  Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
>  provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
>  
> +If guest_memfd in-place conversion is enabled, pass 0 for @source_addr
> +to represent "no source page". A source page is required if in-place
> +conversion is not enabled or not supported.
> +
>  Note, before calling this sub command, memory attribute of the range
>  [gpa, gpa + nr_pages] needs to be private.  Userspace can use
>  KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b272c20586a74..7654a9f5fa128 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3189,7 +3189,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>  		return -EIO;
>  
> -	kvm_tdx->page_add_src = src_page;
> +	kvm_tdx->page_add_src = src_page ?: pfn_to_page(pfn);
>  	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
>  	kvm_tdx->page_add_src = NULL;
>  
> @@ -3235,7 +3235,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>  	if (copy_from_user(&region, u64_to_user_ptr(cmd->data), sizeof(region)))
>  		return -EFAULT;
>  
> -	if (!PAGE_ALIGNED(region.source_addr) || !region.source_addr ||
> +	if (!PAGE_ALIGNED(region.source_addr) ||
> +	    (!gmem_in_place_conversion && !region.source_addr) ||
>  	    !PAGE_ALIGNED(region.gpa) || !region.nr_pages ||
>  	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
>  	    !vt_is_tdx_private_gpa(kvm, region.gpa) ||
> @@ -3266,7 +3267,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>  			break;
>  		}
>  
> -		region.source_addr += PAGE_SIZE;
> +		if (region.source_addr)
> +			region.source_addr += PAGE_SIZE;
>  		region.gpa += PAGE_SIZE;
>  		region.nr_pages--;

Tested the following scenarios:
1.gmem_in_place_conversion == true,
  (1) region.source_addr == NULL.
      ==> TD launched successfully.

  (2) region.source_addr != NULL,
      region.source_addr is not from mmap() of the guest_memfd (double backends)
      ==> TD launched successfully.

  (3) region.source_addr != NULL,
      region.source_addr is from mmap() of the guest_memfd (single backend),
      GPA is private.
      ==> Failed (-EFAULT).

  (4) region.source_addr != NULL,
      region.source_addr is from mmap() of the guest_memfd (single backend),
      GPA is shared.
      ==> Failed (-EINVAL).

2. gmem_in_place_conversion == false,
  (1) region.source_addr == NULL.
      ==> Failed (-EINVAL).

  (2) region.source_addr is not from mmap() of the guest_memfd.
      ==> TD launched successfully.
 

So,
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by:  Yan Zhao <yan.y.zhao@intel.com>


