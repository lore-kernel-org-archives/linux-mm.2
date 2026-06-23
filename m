Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57073CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A466F6B0088; Tue, 23 Jun 2026 05:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E9F6B008A; Tue, 23 Jun 2026 05:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6476B0092; Tue, 23 Jun 2026 05:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCFE6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:22:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D209414042F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:22:32 +0000 (UTC)
X-FDA: 84910636944.02.CE3C440
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf27.hostedemail.com (Postfix) with ESMTP id A744B4000D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:22:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WvN4FRWQ;
	spf=pass (imf27.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782206549;
	b=VvNDmvhq0i96qpurg2Jg8cyiqAldQG3H89+VqyMDRT8PO6XMrVGkabte+CoZgLL/276r8j
	WxKUsIEv1Nc3K3BhkTB7/h5JSCtB+rI3ox6GGzKE9Xn4QVFkkhG1Mpm0nFrU8R5nwnGdH2
	w/Bjrs4Keuw3b/PqjvUsfvbnZqZTvR8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782206549;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atwG1gvkW6LDew2pmpGcwMPEJG0UqvYRRFMq1mCX8Wo=;
	b=5rKjfnIqTPeh9gSxSyWimQO4Agf4E8cpuaDCOAhgOvw1v6CaewqY3XIUd7Y+RaB3TkwxxK
	tMqxfQBws60IjsKKVQx06MhlA/HsI/8AapgWm4i8tHuNp7bw/IxOXbOgPj+hoDFVcNQ+vC
	qSess+GPuudCHTXLoBnPjZZJelVYoj4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WvN4FRWQ;
	spf=pass (imf27.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782206549; x=1813742549;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=+tTyO+TGvnphviY+jqt3bQGiIDof1pMcXxgdySHU6RQ=;
  b=WvN4FRWQO8Gka6i0N32419xmAbpxhKpLWQ8nEri2yDChqx87rOHv9w7/
   ffuQS2i+jrImM7e0zlyUACej8ICRK9RA+xTHxv0cI0i6ui718nLWX+3Ek
   AzpZfp29q/FGz82tdOJf4ToiuNt8J1a6Q+/dD3l7FdZKOMAQaUOg0e9/L
   1fiDJglQElDOlPEbg1YZo8CoWFWYn2Mqy/KaiSemu/td+1/o3clyEWM1n
   4q7y7wFrcFhiQIvIE03YVBe8+KjuZ/E1yERQo0STuyCOfVUrJFQ+i32KK
   oFtdhTVhuXxy3ORIxmcHDtwFHDV7yrZJBu0WEwnPJmrC1iXyEvFcr2RVk
   w==;
X-CSE-ConnectionGUID: lCtRmftzTaasjUIHIGvJ/w==
X-CSE-MsgGUID: NhtR41k4Tb6OF4hF6lgtwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="83133332"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="83133332"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 02:22:27 -0700
X-CSE-ConnectionGUID: aJbs8VdiS3aDgu8bUe6MDQ==
X-CSE-MsgGUID: crVGv5O4RIml+0xEuSr2qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="273164082"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 02:22:27 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 02:22:26 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 23 Jun 2026 02:22:26 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.40) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 02:22:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GZj2NBm8//HSZZwWopk5t/utd42QOATmBX/nmuSIf4T1YZbZDddc012H4pDQbmSs6W+umR5HScn6dzmYelIcxL7Zkv8O+c99mMvx8JZrAozhWeJ6KVFGetBG30GKKEPItIHmArFWam6T8R8MjuP/Swbug4rEauJI5PgK78C+xmaSlJOMxooJiniXMGxlN2Ihj61c9y8wuj5rF5tF44vQlCAxQYMAfK8i6lpXhlJiOj8HYQf23zjcQ4eLoSy4RNw21j3blwZsnHXpMaolT4YWUN+SWckZluASB2EdlaYpJ2Wx1DmThe1pw9YCoJucod6gGKZl+NsRqo3M8Luw58mvKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atwG1gvkW6LDew2pmpGcwMPEJG0UqvYRRFMq1mCX8Wo=;
 b=HMAikKwxQDznnrNZPL3Sb5Diab3XCNmH7sP0NtBDDIVSBDpv26N8vXjOromL3oiFKFeVVE8Flsb7I8kgc155scDWkL/XTEcco20895xCGjQMecOQIGQeaMUV6572JuHoms1q3FIA3++8QYFty4axZeULIyfqWwUcatxe/aQe5a+ffkOG5NNmtN9dQXJm6rLbBi0LPq2RRaPazuMTviYfhQ0aawcB8mozOmYsymGD+tzewSJTAn422++0f7FdRePyl2WGOVrQSzb5SX+42pAaZYtM+f0gQAChRSowAqtxpwnNeIam8sjG0HzE4vwd4kUTqZHRYrvKis4qNzsb765N4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by PH7PR11MB6426.namprd11.prod.outlook.com (2603:10b6:510:1f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Tue, 23 Jun
 2026 09:22:20 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 09:22:20 +0000
Date: Tue, 23 Jun 2026 16:41:42 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, <ackerleytng@google.com>,
	<aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<jmattson@google.com>, <jthoughton@google.com>, <michael.roth@amd.com>,
	<oupton@kernel.org>, <pankaj.gupta@amd.com>, <qperret@google.com>,
	<rick.p.edgecombe@intel.com>, <rientjes@google.com>, <shivankg@amd.com>,
	<steven.price@arm.com>, <tabba@google.com>, <willy@infradead.org>,
	<wyihan@google.com>, <forkloop@google.com>, <pratyush@kernel.org>,
	<suzuki.poulose@arm.com>, <aneesh.kumar@kernel.org>, <liam@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
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
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
Message-ID: <ajpGxu2uQys+S2F8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
 <ajjc0hw8PjGw69e9@yzhao56-desk.sh.intel.com>
 <ajnf5Z9nWZxoLS4x@google.com>
 <ajoWngKaZ+wfIyR+@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ajoWngKaZ+wfIyR+@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: KUZPR03CA0011.apcprd03.prod.outlook.com
 (2603:1096:d10:2a::8) To PH0PR11MB7472.namprd11.prod.outlook.com
 (2603:10b6:510:28c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|PH7PR11MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: 77b53859-a975-4fb1-8312-08ded108ed62
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|921020|22082099003|18002099003|6133799003|56012099006|4143699003|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info: czkdn0//C0fLVFvbh/emZnIyVfuMgetfiTNAgHseU1z6fCc6Dez8km0KwfuE8UZbRR5+jW4+rRPeoX98zYPC4CE5bXuWhleQtdYR8BJdxtr1YkotXsfRWHUWGg752RypReVnEz4d3z7fLkaHA8WTfL+sd3anX7rld0CZMrr8AjwJ0SqbmZZOShnLziMT5MUMO1ifzZOqFtEIFD6BmjBfI9NIShVfaups7qiA1nn/dVyWhdBsre2BhGVU2wdH7wPc9hxi2WaGmKtw21+94zO9usRh2gbBOF+0VO6PhDDGPGhDSs9dOqYJXBa3EUMp+jak9vt6KFBeCSTW2w0F6ITpYBSyOHAtWW9glPMiaDaktPTGMKHtBUmk0EDdPb/kYcrNkxvuIcAQAXLuRoK01NF2g8HhnyEy2jhJln5yUuI2XSdQgwfFdMRDEu3IKz9o58ceEQWBxPrbW8NBJSDKP4QTiBB6czCBqVGlllKy/upsvGHElhCq8lRKR9gRbFZ5I8+ZK3aP61qF+2hsCGZax6OjBAFfCtNYnR/e+Qo3ZNUkz8n0QdKVT+lLa4aMxAov6H/U6AH8DsITTCsWHexmqRQruBVT2/JMqQCb6w1/yjNmuKeqNSwk7noepin5sPFdZl+ShlHkDdBfTcKCL7DFRO3yLMOcEnFAWAUro9neRoBhXDIA+SQsfxpVrTrDY1gq6942He+cnIXuWoJ1MLmJQ3SYeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(921020)(22082099003)(18002099003)(6133799003)(56012099006)(4143699003)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pKl3AuywYc1rAUbTRkzxxHLz+el66aRBpVZvsUKTe9fLbnDgg+r0ek09URUi?=
 =?us-ascii?Q?qEJrSkunaNHrh0UuU/PKJZXrpRz3L9LzbQVGTukriY84c4bQbrlOXuWcKDOc?=
 =?us-ascii?Q?R1UauWhdIiMfynEnuVbEJ9FxEh1nLky5O7nU3xn3dLa5xcRH/O8z/dH8cE5u?=
 =?us-ascii?Q?78Np/mGG6yamCZDRYDjN/0qjNXlIhzFwGwbG1S/4oeOZcB02q/BTBuvcDA7f?=
 =?us-ascii?Q?DhpMUXVjmacxBtfL8cir1zYpeVn9bG3rjKfuEMyeXPZl14oLvpULgtlhLMqc?=
 =?us-ascii?Q?qiZr9zGDn8NcVY3D0v0Lf5Lu9S0d4QwPUtyQGUuzzJIBlglGwK8ThV1/nnVk?=
 =?us-ascii?Q?mAKnwXvLLojqM99mn6GTLvOOEE7APf15R92QIsMFv+aZxLHTCoceyoDULVzu?=
 =?us-ascii?Q?J/TppcWZf7umgWwrnQJ4caQEe/2cmmrZc5/LhBXn/QJ1Kdc/hjxVMrmZ9U/M?=
 =?us-ascii?Q?eQkrcvceA0Cw+9F37W8MWuoDsf4OF2XbsCfNiSPz5egiGAQTCBeIYsi/aRXd?=
 =?us-ascii?Q?uSubyqjdbpjS8MG6oA00YkqsMGadxqSM9Rx6b9Zu1A/CTF/YR8pH24F1yUbf?=
 =?us-ascii?Q?LuvhP6gabwCDGOeHN9RjbDpKjj50TzxfEBwFAXtHBm0yVB+UFxEkLu/OJfFt?=
 =?us-ascii?Q?F2zAFJpKV0//vFR76X1KvB016lflAgcty0s6ni0CKwx9CBQ/FwSXDeDslLdt?=
 =?us-ascii?Q?ivZIx2NvodMgUmN5kZ/Azuk2WScJr/U7rNvzkj3vPK2E1MPuDp+vL0176NnU?=
 =?us-ascii?Q?MaJXmiGLIBrvsfApMyuLyKaVUncj82slNyF/6MYKX51HytpDyzEn9YhKZPMo?=
 =?us-ascii?Q?Cbx0X5God6Bs2e1JWfmWUCjLarNlTCuoLWMqAxp7htgIi0pxN/kbBlaC3n4f?=
 =?us-ascii?Q?PLRVqrs/gbzLr9eyoB0rRJcoc4UDWqxl4n4KdYhosw1K1vIeiYyi2/yb+HRR?=
 =?us-ascii?Q?G+P4K1IwL4JKRC6hzDC1Rd9KBXz7Xhrh7tiQW/77w0TANoJMbKvrPRSyRIks?=
 =?us-ascii?Q?MT9w1hHrfXvv07ck5MwO5FGk27dPpMeSUFnZyHflFL7rWT0LWvhU3Rq0Rz0l?=
 =?us-ascii?Q?nJjKLQD/kA2DHUsC/FC1SyEN2CGkz+sMqUKFao84c3dfR9bft3mLvBD1U8gd?=
 =?us-ascii?Q?lIajJZCTpruiz4aeCFHr/SbkoDo7kNdiTVXStklBxtmC1f8BV80RhFBYgBgx?=
 =?us-ascii?Q?Rr0L916BJ7Hu2TFhS2/DSxrGln9qsyQLEa3/+8cFPLi9RiJkMcl32r3XW0dS?=
 =?us-ascii?Q?upuaaKM3m1UcvnK6JGzyiV/BsvactLou37FZTOXrTaaz7jYMDhz0k2+kkFnJ?=
 =?us-ascii?Q?fjCE14PMxxQgedbkcr7CMg2nrL6oQpz6miJRmaY8pBb9RoG4UK9VPrDfqLym?=
 =?us-ascii?Q?yfcoiAPqMosjtHkbAZLHTHDZnboghKD6u6yxpxoeBKATM5xyoO56m92NmreI?=
 =?us-ascii?Q?j4I3vfkSCrODrKYqEiOxkzwB7yqs3Njen/4HnG5hlMv3fsy8TAu/Rb6dAQYL?=
 =?us-ascii?Q?z5q2Seu6GLwIQ54hUTxjWTgc4AyNMkEgRje/Btg6obNqZZdMK+4tXyRXKt4o?=
 =?us-ascii?Q?cxEvXRjkw9AhHBUk8izGwe6yH4rGD/PRiY/g/oTdkMLWU9F6teazQabhKvzi?=
 =?us-ascii?Q?yCLbaadTuKvHcsisK2jCpQNfvrGE2RQlYB1k2Lar+sDD6x7+uCJlteM1qgQq?=
 =?us-ascii?Q?qTHQTcWmmV9Wc7D8EpcovO1VmCRVuQXbLf+UcYVmh7qKt42sk7AO0pJlS2sq?=
 =?us-ascii?Q?8rMtb24zpQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: fLINlFNTJgqUi0ieckQPw2RFQUyeaWnyzKuJsbnjnAgLmQ2xrOYwHLQv8ircOG2k35HnEoVGX3wFQqxqJ9EPG8StJ47AGErXtyB6SPXuBeCliAoj/TXIaFh9WSeHLBcQkcJ/jbeLygTIltFTdi85PzWdq4NQ+1182jfLgPbiKLa+FqBWjbDmjuDl9qNz+Pe+jwq/1DvFNb9sbGeXHHXZ3M/AKJEK7nLC4TfluLyIAPyfBOV2h/RCq3ZlyuOdwFd8H4aa/JT1vG7oXOJ2Z0U29nO2GopPPD+jq9xNaCA3kLSVexgs46pywHNattCMtkOemBMn0Jgo94ByZtWvRo0HXA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b53859-a975-4fb1-8312-08ded108ed62
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 09:22:20.7047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xz5r1vzpl4koKkErabT9S1OyRPWaoyVKim5uxQyyOmNJkrY2f386d4FzFWHtIZRMcJZ2sBeSnd6ZhCr1Nba0UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6426
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: A744B4000D
X-Stat-Signature: 5c43b7pba4wj4m8xay9yhus968p7pdrj
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782206548-465628
X-HE-Meta: U2FsdGVkX18astLBJhQ8u7QS1vnDltoftF7WnrA4v6Xind0n4rArSPxfvQkcNfzkzVmIeVq4noszbDTWA+EB/FzG8nRjWmfkyYeOHJSE501vTBUeV70rAySCK0YFbfhYe78Efct9bJUsyLhi47zHYRGCLt3coDlF8LIirBJPDg8duvPLD6TzSoaLdoax5a8XNEjvV96dx/Tt1PGddHbblmbO1gjMvq+qLo19vWMwnARq1+gDWWsWW2e9NSacFWMUVg21nUsbD+91aPhkJFpQqH7/m2il8F2JaVzBeKAIvovRtLFQjeXllUZMPj94ePKIr2us0BDXl3WP8Bl8EJ0F7Hgl22PAYd95Z+grJVSGl6uD9itMCTIX4qwnKA8GeUtASOqjn+qFGG5sL877LhCDJWHTO7SZNK+sP/1hkms80JtNpoCLlKRDPf8eoG9ua9ByDQ45mQ803N/cDM5prSV+4R0Ecv5DqB9fbo3H9MS4JT8FA+JnFq65fhtntZDmq1uhAoxRhroOtbfOrvk2Yvdl6vnEXuFcOfuzUowTMJKA6nKRNkixesjDmD+Uoak1GK8psNjE74/qQ2dOTGZGsYUQj2q5g4+Qq70d4rMHPLFPIkrOMB4slIL0RbPV4p2eGUFzeFz9V+GB3ot9yqA11+D89yOanhGL0IXEureFd56UY8xYR+ropS53OJTauwewN33kWW4UxrSVFluhdqB8K3XKTMWwJZsiZd8mpACpbTkrN3VnheeHgj5da4svYSOGH433IQqwRIWGQbmVw5Ij2kbWhHSyz0U+97c+O5y0bWMFOWs4tKmRNtxfYeN4BL0uT1yftRf1Pxe/AZRSxtcO2qhbVDBWuqnIc9nVY+6rcFiQDjW7qTuCePRLicqCO/JaXNkoTiEPk1+sEEfljYHPsIzqDRyOds3ZRu2XvVX3KvTEkH5tx8LMrhBBedM4h3YONWR1LcxDrWLqArEyunDi/T3
 i6ieKzwm
 eCAN3cxpaehBb96bsYRAR0EBnsG0VyPm75Zx/OHnLrDYdtKkKUOi8b+T7M6hHw2xTJnnHOzwqOGVEqaX3CHo1o0aJqnxt/jmkmzh5+EFaCj9lsYks33OXzQKWyqL5/sORVcswkgA4qcVKy4MmbbqD2gsFxTcWEvj5jRyI7ZqpouDl62PMF6nKxujjRkgd1sUPS4u9LW7SLD8eO2xOo+vxe+/oo5/p4MvJmh+KUcA6VH0kMwqUSqpoP5IYwQ4Mtg6cg7wGi85DRbJzl3GV9oC7PYGSZ6o8WXJKBavLBVjgkX0kc48My467za4qId6nQS/1a21pRnH9/dPGOd7f2P+FSjeEhh9njQQgk125+Gl2uLuhAhZloE+F+mI3K9w+uDGaJaVp+KD/wiRxdZKj1lBKoVfP2fFFbu+l+nxrHAfqi37ab9RPUYVl72IpbUa/X+aT0j482yiba/q7fuNlccg4USwHF57jstO2v7VXKduO5bnVqi3QG7YAAkYW/drPAEX3lGtT0EES/FcsXEq3eY+jB0vg+WDcx6GDX0OJpJzBcQoKJ5POh8HqWwIF7HPSYrEiE3pe70mKpU5oQksx8p713rwDVprdQiASV5TPSUhz4KwjVXbEQi2jTGxKfGpTiIkl2q0ElNr43mCcwz5WVKcT8GzSeRgQ/3Qm3TwI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 01:16:14PM +0800, Yan Zhao wrote:
> On Mon, Jun 22, 2026 at 06:22:45PM -0700, Sean Christopherson wrote:
> > On Mon, Jun 22, 2026, Yan Zhao wrote:
> > > On Thu, Jun 18, 2026 at 05:32:00PM -0700, Ackerley Tng via B4 Relay wrote:
> > > > From: Ackerley Tng <ackerleytng@google.com>
> > > > 
> > > > Update tdx_gmem_post_populate() to handle cases where a source page is
> > > > not explicitly provided. Instead of returning -EOPNOTSUPP when src_page
> > > > is NULL, default to using the page associated with the destination PFN.
> > > > 
> > > > This change allows for in-place memory conversion where the data is
> > > > already present in the target PFN, ensuring the TDX module has a valid
> > > > source page reference for the TDH.MEM.PAGE.ADD operation.
> > > > 
> > > > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  Documentation/virt/kvm/x86/intel-tdx.rst |  4 ++++
> > > >  arch/x86/kvm/vmx/tdx.c                   | 11 ++++++++---
> > > >  2 files changed, 12 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> > > > index 6a222e9d09541..74357fe87f9ec 100644
> > > > --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> > > > +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> > > > @@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
> > > >  Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
> > > >  provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
> > > >  
> > > > +If guest_memfd in-place conversion is enabled, pass NULL for @source_addr to
> > > > +initialize the memory region using memory contents already populated in
> > > > +guest_memfd memory.
> > > > +
> > > >  Note, before calling this sub command, memory attribute of the range
> > > >  [gpa, gpa + nr_pages] needs to be private.  Userspace can use
> > > >  KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
> > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > index ffe9d0db58c59..56d10333c61a7 100644
> > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > @@ -3198,8 +3198,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
> > > >  		return -EIO;
> > > >  
> > > > -	if (!src_page)
> > > > -		return -EOPNOTSUPP;
> > > > +	if (!src_page) {
> > > > +		if (!gmem_in_place_conversion)
> > > When userspace turns on gmem_in_place_conversion while creating guest_memfd
> > > without the MMAP flag, the absence of src_page should still be treated as an
> > > error.
> > 
> > Why MMAP?
> Hmm, I was showing a scenario that in-place conversion couldn't occur.
> I didn't mean that with the MMAP flag, mmap() and user write must occur.
> 
> > Shouldn't this be a general "if (!src_page && !up-to-date)"?  Just
> > because userspace _can_ mmap() the memory doesn't mean userspace _has_ mmap()'d
> > and written memory.  And when write() lands, MMAP wouldn't be necessary to
> > initialize the memory.
> Do you mean using up-to-date flag as below?
> 
> if (!src_page) {
> 	src_page = pfn_to_page(pfn);
> 	if (!folio_test_uptodate(page_folio(src_page)))
> 		return -EOPNOTSUPP;
> }

Another concern with this fix is that:
commit "KVM: guest_memfd: Zero page while getting pfn" [1] always marks the
folio uptodate before reaching post_populate().

[1] https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-21-9d2959357853@google.com/

> One concern is that TDX now does not much care about the up-to-date flag since
> TDX doesn't rely on the flag to clear pages on conversions.
> I'm not sure if the flag can be reliably checked in this case. e.g.,
> now the whole folio is marked up-to-date even if only part of it is faulted by
> user access.
> Ensuring that the up-to-date flag works correctly with huge page support seems
> to have more effort than introducing a dedicated flag for TDX.
> 
> > > Additionally, to properly enable in-place copying for the TDX initial memory
> > > region, userspace must not only specify source_addr to NULL, but also follow
> > > a specific sequence (where steps 1/2/3/7 are required only for in-place copy):
> > > 1. create guest_memfd with MMAP flag
> > > 2. mmap the guest_memfd.
> > > 3. convert the initial memory range to shared.
> > > 4. copy initial content to the source page.
> > > 5. convert the initial memory range to private
> > > 6. invoke ioctl KVM_TDX_INIT_MEM_REGION.
> > > 7. do not unmap the source backend.
> > > 
> > > So, would it be reasonable to introduce a dedicated flag that allows userspace
> > > to explicitly opt into the in-place copy functionality? e.g.,
> > 
> > Why?  It's userspace's responsibility to get the above right.  If userspace fails
> > to provide a src_page when it doesn't want in-place copy, that's a userspace bug.
> I mean if userspace specifies a NULL source_addr by mistake, it's better for
> kernel to detect this mistake, similar to how it validates whether source_addr
> is PAGE_ALIGNED.
> Since userspace already needs to perform additional steps to enable in-place
> copy, specifying a dedicated flag to indicate that the NULL source_addr is
> intentional seems like a reasonable burden.

