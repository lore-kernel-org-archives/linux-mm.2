Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B0ACDE002
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FC66B00D3; Thu, 25 Jun 2026 20:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999D26B00D4; Thu, 25 Jun 2026 20:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814366B00D5; Thu, 25 Jun 2026 20:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45CD16B00D3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:04:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99DD91C5469
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:04:47 +0000 (UTC)
X-FDA: 84920117814.04.C078E79
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3E0491C000F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:04:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dcKJpzgp;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782432284;
	b=WrALw1vcmLlXSE+fjLevgwe27EoIJvNCXCF+22VGJY2C5ViG0fP+mnQScj1O9e8vr6Qlct
	ErEDZQuvKV6tdwsn+Rqpw3e+RdnvuxJohGQo7/1it6TfrAIyitmP254/EgIyZIp+NIp+3N
	6dxpVxaISWIec3j03s7qEbb93CdhLrU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782432284;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8o9Ohs6Q9dYoo8Xm58GzjjDUChHFO7fAyOAyGIngCJY=;
	b=gcLgOCRUiOfZaYxiidaWTq8Q6sW7u4Aqhp28ZR5QN83XFLwrsQX1VAWRdbxXHYnmNZd9lG
	mPppD1ruBjNEF4erp1S02o8cX2LTuEHiou4gtBCgiGGBko/5T3c/UAp4oLHtGGTwDion/X
	r0K3byOv78PUBfrkYZk2JmXeplFo800=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dcKJpzgp;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782432284; x=1813968284;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=4bIcno7nZL8O8LyckrjWiqFl6CDEJ0fxotEwlAcx+XI=;
  b=dcKJpzgpsvfvhRoC4FDy3VdIRL5cRkpOPktbJgeICXLLiuKAOqfoB+aC
   MvnAZ4rsuipHYvMUclkcv0bhAdZciyB214hxNBOuP1iq/8Ge5599l71c4
   ZEpFPd87m9All2rWkRMeS3vK80eu6b8fpfAxxaUl34Mc00a/ygaACGYQF
   K/PMlgscXk4rMfPvcN8yPZMLS8LNiRO0WG0FUkFxx+qWvwq+MpdlqmuRB
   tqZydvVeiCSFrXHjahcMl145R/xHtcAWOuM7B9SZ0XQ+PPr4sHJmF4YIp
   VtAYOuLFKapxBFtVaWn1XUDQSurabw+7mIZ5bOUTpA7mH7G4qd2L8Wo9Q
   g==;
X-CSE-ConnectionGUID: fwf5E0NIRgyQWm9Tfcrh5Q==
X-CSE-MsgGUID: uCabiQyJRNG078/slpB/eQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11828"; a="83231583"
X-IronPort-AV: E=Sophos;i="6.24,225,1774335600"; 
   d="scan'208";a="83231583"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2026 17:04:42 -0700
X-CSE-ConnectionGUID: rzxDhC1lS66TH1t8+w8vNQ==
X-CSE-MsgGUID: lH1gIchkSUu2unBTzB6jhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,225,1774335600"; 
   d="scan'208";a="289261963"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2026 17:04:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 25 Jun 2026 17:04:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 25 Jun 2026 17:04:40 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.32) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 25 Jun 2026 17:04:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JBMUB9cwtWSH4mfGMN5emSmOQcvxLPwUXC6HnfPYA1E/MkEudaLBsfXH88uGVUiP/PtcfQ3Y4dBzNDc7UrOsNhS2Q1GQnJUsdUlVHxuBGQEFuGsHjwmEBqymnfb+LP88uWK4G+QBiQLrOa8UdTum9m/WbNM4E/Pr9BTecslO7WYvulZZnCcxD+uGCa7bieUyaakxInvPfJpDMXgoiJmggXqz+a17GltGI2qvCFoAbVvJNq+kxhpo8e+k2cTJQntJrflyOE5SUfjQxJWvtD+q26DFuxk3GYjW/4YbiWT4XQyy9PHHlJ0GnOVdkrPtl/6iYCSvnsHE/JbBcS56Do7mZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8o9Ohs6Q9dYoo8Xm58GzjjDUChHFO7fAyOAyGIngCJY=;
 b=sW71M1Kb3SESxC+1Vhx7pI1tqj4jhmUFWH5XMVDudHOlMH8cspMZ+QCO3OMcUJmkgxlfYfLo87KmStFsZ/wZDhp5UrTc9gY2h0e8yvNQXr3gljSwdJXT9HxJNLpH7VzxhshSb1m903Gwg/nn4oAXVAU2G5MjZ0UrGNWzRkj0lH3dSc1vhtSrvNzL13VcpyLQPJFtkHWSvWdwdslLz25kGkXKyVm+ohv/dzs7BqCYU1EFOBrLpGQqCXSXrt05UwwDcUupj3idFfz+80madcnbytRRMUvn9aaPq6m+c7nu42Kwnnh7EAaKkyg+zN4ZcZhqbm3IO1KFH7ORMh78eL8ZUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by DM3PPF7C7D8332C.namprd11.prod.outlook.com (2603:10b6:f:fc00::f31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Fri, 26 Jun
 2026 00:04:36 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.21.0159.013; Fri, 26 Jun 2026
 00:04:36 +0000
Date: Fri, 26 Jun 2026 08:04:29 +0800
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
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-coco@lists.linux.dev>
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the
 default
Message-ID: <aj3CDdxADTduxPmz@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
 <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com>
 <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
 <ajyCn0PnFtQK+Nka@yzhao56-desk.sh.intel.com>
 <CAEvNRgFfgV0FbQLzP8hhNH5hMGaQao6OFQin4cb3TAmC7SVhfA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgFfgV0FbQLzP8hhNH5hMGaQao6OFQin4cb3TAmC7SVhfA@mail.gmail.com>
X-ClientProxiedBy: TP0P295CA0017.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::11) To PH0PR11MB7472.namprd11.prod.outlook.com
 (2603:10b6:510:28c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|DM3PPF7C7D8332C:EE_
X-MS-Office365-Filtering-Correlation-Id: fa4e1473-dca1-469e-f74d-08ded316820d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|18002099003|22082099003|4143699003|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info: ombbUJ/DI1bKO4pKg2/GTG8aOM+UON+F2YGGJD8YjRKVYRrDqNdHa9Dd6CL/MMP0J2BYttc2bGFU66mdsiwFXlLoZmq3EGElJJ7Zo13eYB1XlxkEtqfkf2zWOFwhDWTUsnmk8o2mjXP1CHaOpz1osNvi3Rr1QRBVIR9JSyjY74NzhjFnbxVy4HTCtGQ84jOzgLwNjodoaJm6SKhexg1mfHIxYMIrGvWRMDDuMHk+16l677H1ZKP23VJwh0tdZF47ZgiB+CVgTfaE1flk7sxxnWhbKnpHoV04ZGeKDOcewbTfqCVYuRKgUQi+913beA9G83DrY82jm/yxHzGJeQMnJXi9Ks7nTWUiybRMP4czevqbC2SxjBM8zR/P4bhCqFyp6Rd/2Hovn6AVs38292uiaqpfxT+J9jq+v/TQHajGzgM+iWXMZlcNFuTv4MpKvn81uv6aDHwtcNZrspWqFiy7sKT6UgvRYzp+5zPu4nhcB+e2Zuer5p1oKPmH12QrCvY7Q6+MhSH07cQB0nY23UgSEj98ydFkfkaCtVVsHprEe2ALnGLHJ8asp82RVQv5vfTWm4+c3sYTsLqx7EvDrpvtnLOm8la3pyh6oyk9LfkXWmGJFUfGXewEzv6Tg+lfggpXdufPXMNraxzB1qfBmt5PpjyCc1fcPOKAzVw2RqDc+D4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y+wnaDBQbUDRF9F0e0hsYxpTN4zr2TywDkM4qqzQ37gLQRR++RiqmeQ8OxFK?=
 =?us-ascii?Q?5iDd/31fWycKHuKDIs762z9toqZQYEQ6AZL12igSOUeg51DDLc7EZv/9vErH?=
 =?us-ascii?Q?svxm8VuR77j32ybvXaTM0LhJfuHEoPcu4ZEby+tNyopduXMmYFJNN0nEKVw+?=
 =?us-ascii?Q?Fy/qsAbiXv1ZNx/Bb4i1U9ih4USWKo1WCeEpsT5mApoBDtF5aIR2Cz2iyb3Z?=
 =?us-ascii?Q?HP54vmFoyWzOGHuziAZyFZFcRMRfmEKPCa8pGVkghTAQdQjAgWwJfn78ZopI?=
 =?us-ascii?Q?ZrT4/vvRIMlFLfPlhIHyfPR5ujd6A+eDtkh2iZQ7z/4xPOlAw77W6PSuSS1N?=
 =?us-ascii?Q?lVJ6qEN0hXeBGCtpV1teSSGuzQbmkxvBNk+NVEkyeFy8Ms5d4taij20g6EZt?=
 =?us-ascii?Q?RkL2I+FnN2K9lEGdWPOtn8bwnHknqTexqOdQaet2GR+UYzZ7X/dw2F5hdQ9m?=
 =?us-ascii?Q?WBLyd06FjblNpASWkzajEN7BA92B0pcG9ZjLix79igszTdupd/riyMZFA4rc?=
 =?us-ascii?Q?uF3wIj1my706JNTXswkrKfPAVuwsI8ZGQdD8dGMyV/xONtpRjfhIkZjHKiWI?=
 =?us-ascii?Q?OWVXCmf15bX+ZhI7SGwV3cQMIqj7FK70Hc0byLjv5bCIgBEeCcCm44IrBJJW?=
 =?us-ascii?Q?rB6vKHAsFPjTZYOqugsQvDBZsK6wbxRISX4mYLzJGewNGXxZ/g9cIYwPhTdu?=
 =?us-ascii?Q?+s8sCLPEsHV0mcyHU0slTNH+7iCCUEaLEI5NcYydF1L2f9C1PdIGHMfHddqe?=
 =?us-ascii?Q?009TqnZ+j4wUI/5EH01vC110N4CDzCCySfBcenVm6qm0gPLN7kfIXLEUwu61?=
 =?us-ascii?Q?xWDR5iWUIATSwyXp0s/m0cUu9yHTosD1vwHvgfpAmfQQvpk5ughOObmQBIlI?=
 =?us-ascii?Q?Pd96TNwzzYJaBlblmNgEQuLSGuYYG3BCikn1aGtp647u2CFgPeNHZWM6LO/R?=
 =?us-ascii?Q?+b0reaqHS76VE6YgQ6YaUU0mhz89xYpzWrlRwqc7EtxO3okRG6pcrWNBtCxJ?=
 =?us-ascii?Q?DXuF6lW44WgijrQYY4JJn/1Ih75EJMh/uMaEZtlefzSHs2A+h0OfBBvdyDVD?=
 =?us-ascii?Q?kOJntcmhYlj3W2i0ungfnaMXQKlvozC9tJMdzUhNq1kzBLHn/+eXkjLeEw4D?=
 =?us-ascii?Q?Ro+e1BYdQfcDLu/3qspMmmvAlSKbbh5jFbfCJx2A9wSWckZRRlzCF2KvUtyL?=
 =?us-ascii?Q?ntoEWfcCTB4yN4vk9qaTr6cNxkkxZL8UdY0OEcnxjNnPfhv8xVb2Q4BRtk+m?=
 =?us-ascii?Q?JN6h0Mt7AwpfT53fe9u7SJyn57i75i7hHYoax2Zra9DZBh53o1TqBVMx0C8z?=
 =?us-ascii?Q?3A6bmLFHHpfGxe4utB3c27TQFd2YTjH+VXa2Rj4Y51dqnTcLUsn1plucAokw?=
 =?us-ascii?Q?TdA1qfmWZTBctmyrocg2h+hSivj65AZWSPMfUvhckiFIgSq1MkJfa0+VBOAv?=
 =?us-ascii?Q?LJYVzMf4tJ88nYT2gtJv1UDLSoSiK01A4jZ2NU9NNGnVihP3adY3nSpOGQLr?=
 =?us-ascii?Q?7G6tGkFNlTSa5t2rYlATzNVArVjL+RVXJ+pMbyGsiGukZuNCuEO8EBLQXMaj?=
 =?us-ascii?Q?RcvK9bTucTPRBOgF/ZYNWR+Rfbqj9k6MxBMPDhmjaLIvxlg0bot2lQsri2Hw?=
 =?us-ascii?Q?LYw/qUNXUKtzAssNiDK4VThbe18gYAtxueCmu9vQNbLesLasVRHL44/MYYmN?=
 =?us-ascii?Q?V/RvhfkhP6Dn5mp2mJYNMgIMQ6TPr8ViwuqZHfoDLUZW/PBNZZpW+Wudm9OF?=
 =?us-ascii?Q?lNY9N9CrNQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: hWHfAq6yfJIYVGbbGNKvGTdr906zRDm2XXU6DbtChu3aQjmschdvQPOC4FN2lFLn4fEyet6be8xe9FAdxN5QCdfKx/eYTo26YrIJgoRULHzyV5HLboyqnFVhCXt5D+LYuogoTdQpiHVgBLpMH3wf2c49fC82SjCiqqj9UPePykgohUILTB+5DCVdxsXq4OW8uNdtzQHYb9ss3piew1HFHLOs98KrXG1SMn4mwYnXCkZXv915xr1Imwr9zBZlA6UqdYtSSRCzUZT3lgyt1GPGL4GFtZ+dGaTE5q7OzQqMke/58jCQx1G23dsiPMcBYWYuLkTGWl9FoPKZ+bcLO5EXXA==
X-MS-Exchange-CrossTenant-Network-Message-Id: fa4e1473-dca1-469e-f74d-08ded316820d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 00:04:35.9733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Uc5lmj4e5MhfvLdgzsHaA0rhhc+6pPjE0LhLqMFSWWvJOvjqrpNas7inWnFCL1J6Fv8hyTW6eKVENVABHhf6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF7C7D8332C
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E0491C000F
X-Rspam-User: 
X-Stat-Signature: 64tsntis1spestsoti7odi3uoihdrwd4
X-HE-Tag: 1782432283-648963
X-HE-Meta: U2FsdGVkX1+0RSHogzeE8uqQ+xZJFyF20taMlUszm4tTxPhFEoI6HF1CesfY1jfx2maxGBIo2QVZEgQxSsw2EMTD6PAHdK3sQOxd4i1NaD13a7X9eSHwo8hhxWfS1Gcs4D693FIu4qEUHKRPrI3/9En5FjYg+fhHQq6C7m+CnJUqdSYYPJLnhMC0iuy61JavO/O3f710WP6JJG41Oy/dKITcHnP3EbTpoT7wVrwKBOwsWg9uXoA6LHZKtyLXuevHohCdgRB5UqWM/BTQ+gG6ud1r/xEIivd7L6ZQO1ulJ+Y8Tei7J18rNINJuYJbQbAV4E5iVk07v/7HeSRhX5Tjnze0rDQPlMNcvrWcZ3U+eyE+nagZaVcmJjua0W8GGJzU6XaesSOLSmD7YcTGM5xjRdIDV7CYISJ3kd+RwwuDOROZ3+WQZejAzsdQSDDUI0X3uDLjYGLK116IV+M1WaDheK9fHukT1215T/OpAlxfiqY9Gs/cDooDkw5nfhGz1qPMFoPAPFsTh+iYBar8KlZoXgpKb8z7iqIDx0uKFq3Lo+SvDGf4Eu6ohPQvgjVPFQx/z/5THgJpwjYF3L4GtzujTp0upnTBRgf/c12QxitgykrDVrs5fHWivWginltUU6zqVHzZP5dKyGqcoRbhnBKoocpOsqfFUQhxwZA/zE2XscsT1Yx5poc/L7E7bxRSPsUh3LczjUh1c+ZB704ICPG5sjGxvB4pDxlaLNXeAT8otk57G3wvZU7arMRqewuU7hBmzuaBDy4zmnuzPchcTZLPek8Abuo4cjFH1egYQBBeNhyP9G5dy+dFXCY+7UtsV7KuXo8q0Hnl2azgchdjeFSRa3JHubl3LZCfY0pz139g6OCoVX11D+oNsaYvZhcBNKYQb49+z5w+7uJwppMMcP1kAXfuM7AFY/ZKGJsRqoJoN0IND6SOfoEMzi68hIq9VDZJMJNyGuygTi4ojhfsWvS
 lPJ83wGx
 V6isneqKUiucRgseQ9PNx1JEkxNQk85f9yDO0oONq5bJyIsAhxqP9ZJo8v75icAiNAeiRZdR5msZFa/kRdyu/WguyUmDRsGWDBLuojVX3bz3EzYz28CIemARBGlZ5tlMjOqwgXd18R47+2traK6S5434sPZlj6K87U7n2ajBppmTSiehr5EXApCnu9w/alONSOI4uwWnWTgWLAjnlS6vNLIolzecpXiFPSOr8syBET/7g9291c31b7zpvScX5szxs/zot/XX0i/XteqjhzajOeZn9/dGwsMMbBM0QgnNlN7P0BjbbCL/fG3ygGSTxlBxDSN7lEWK/8lD8r9zGsdce1fu/cgYv96dZxNOzCWekDy71jFZRxA4N7R1aecEgy1GHDXzLvxMfK6ehlXybCXjce95H2cl66PkEE8SAHS0iox5FXt6yEx7LKn8PNVAndzHUd0LeG9Yx8lHmkSpCmttWL2tQ6XmOy1ID6wxJslIXybHCdbcgG7Ef3VsHQjWdJACwXv0VR7Fw67Dd8DjWvrkm549y8d4Uzkbz0ziX+EHFtLS+u6b+cgOXW52xnOzHjortIu14HWqPw5IQ+NMzviLu6CsX8+WIS5vf67HunlSlvlpKuoZP3BHlgsFeXsi6eHoLp9fczzD3X0Ii4D5FAxd1iCxdNdeJ5qQrM64Z6uzcYP8D9wEKk5d8GCnqTB11+sWB4KO+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 11:20:30AM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Wed, Jun 24, 2026 at 05:05:44PM -0700, Ackerley Tng wrote:
> >> Yan Zhao <yan.y.zhao@intel.com> writes:
> >>
> >> >
> >> > [...snip...]
> >> >
> >> >>
> >> >>  #ifdef kvm_arch_has_private_mem
> >> >> -bool __ro_after_init gmem_in_place_conversion = false;
> >> >> +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
> >> >> +module_param(gmem_in_place_conversion, bool, 0444);
> >> >
> >> > With gmem_in_place_conversion=true, userspace can create guest_memfd without the
> >> > MMAP flag. In such cases, shared memory is allocated from different backends.
> >> > This means this module parameter only enables per-gmem memory attribute and does
> >> > not guarantee that gmem in-place conversion will actually occur.
> >> >
> >> > To avoid confusion, could we rename this module parameter to something more
> >> > accurate, such as gmem_memory_attribute?
> >> >
> >>
> >> I asked Sean about this after getting some fixes off list. Sean said
> >> gmem_in_place_conversion is named for a host admin to use, and something
> >> like gmem_memory_attributes is too much implementation details for the
> >> admin.
> > Thanks for this background.
> >
> > Some more context on why I'm asking:
> >
> > Currently, I'm testing TDX huge pages with the following two gmem components:
> > 1. The gmem memory attribute in this gmem in-place conversion v8.
> > 2. The gmem 2MB from buddy allocator. (for development/testing only).
> >
> > The gmem 2MB from buddy allocator allocates 2MB folios from buddy for private
> > memory, while shared memory is allocated from a different backend.
> > (To avoid fragmentation, only private mappings are split during private-to-shared
> > conversions. In this approach, the 2MB folios are always retained in the gmem
> > inode filemap cache without splitting.)
> >
> > Since shared memory is not allocated from gmem, there're no in-place conversions.
> > The reason I'm using "gmem memory attribute" is that the per-VM attribute is
> > being deprecated, as suggested by Sean [1].
> >
> 
> v8 of conversions series changed that slightly, per-VM attributes is
> going to stay around (because of work on RWX attributes, coming up) and
> RWX will stay tracked at the VM level.
> 
> For v8 and beyond, only tracking of private/shared in per-VM attributes
> is being deprecated.
> 
> By extension the entire thing about using guest_memfd for private memory
> and a different backing memory for shared memory is being deprecated.
Thanks for the info. I was actually referring to the per-VM shared/private
attribute, which is being deprecated. Sean hoped TDX huge page would be the
first mandated user of the per-gmem shared/private attribute.


> > Besides my current usage,
> 
> I think you can set up guest_memfd+2M for private memory and shared
> memory from some other source, and that's the deprecated usage pattern.

Yes, though this is the deprecated usage pattern, gmem_in_place_conversion=true
allows it.

In fact, even without huge pages, v8 allows userspace to have shared memory
allocated from other source when gmem_in_place_conversion=true.
(My default testing of this series for the 4KB setting is with this
configuration).

> > there may be other scenarios where gmem memory
> > attributes is preferred without allocating shared memory from gmem.
> > (e.g., PAGE.ADD from a temp extra shared source memory).
> >
> 
> Is this TDH.MEM.PAGE.ADD, used indirectly from
> tdx_gmem_post_populate()? This use case isn't blocked. Even if
> gmem_in_place_conversion=true, you can still set src_address to
> non-guest_memfd memory and load from anywhere you like.
> 
> Please let me know if that is broken! I think I accidentally used that
It's not broken. I tested it with my hacked-up QEMU.

> setup in selftests and it worked. The selftests are now defaulting to
> in-place conversion.
> 
> > For such use cases, I'm concerns that the admins may find it confusing if they
> > enable gmem_in_place_conversion but still observe extra memory consumptions for
> > shared memory.
> >
> 
> Hmm but I guess if someone enables gmem_in_place_conversion but still
> allocates from elsewhere, they'd have to figure it out?

If gmem_in_place_conversion=true means gmem in place conversion is allowed (but
not enforced), I agree.

I'm wondering if we could rename it to "allow_gmem_in_place_conversion":)

> > [1] https://lore.kernel.org/kvm/aWmEegVP_A613WIr@google.com/
> >
> >> Sean, would you reconsider since Yan also asked? If the admin compiled
> >> the kernel knowing what CONFIG_KVM_VM_MEMORY_ATTRIBUTES means, then the
> >> admin would also be able to use a param like gmem_memory_attributes?
> >>
> >> There's the additional benefit that the similar naming aids in
> >> understanding for both the admin and software engineers.
> >>
> >> Either way, in the next revision, I'll also add this documentation for
> >> this module_param:
> >>
> >>   Setting the module parameter gmem_in_place_conversion to true will
> >>   enable the KVM_SET_MEMORY_ATTRIBUTES2 guest_memfd ioctl and disables
> >>   the KVM_SET_MEMORY_ATTRIBUTES VM ioctl. If gmem_in_place_conversion is
> >>   true, the private/shared attribute will be tracked per-guest_memfd
> >>   instead of per-VM.
> >>
> >> Let me know what y'all think of the wording!
> >>
> >> >>
> >> >> [...snip...]
> >> >>

