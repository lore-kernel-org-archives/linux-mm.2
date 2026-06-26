Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FF66CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 01:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516A56B0005; Thu, 25 Jun 2026 21:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6CC6B008A; Thu, 25 Jun 2026 21:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 367F26B0092; Thu, 25 Jun 2026 21:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07C626B0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:17:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78502C19A4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:17:34 +0000 (UTC)
X-FDA: 84920301228.13.E277D35
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf08.hostedemail.com (Postfix) with ESMTP id 54A6C16000C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:17:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="QMqYd/Dd";
	spf=pass (imf08.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782436651;
	b=Y6r8noYzuJ9G4jvGv8YylqRI0Nr9LoMdRQBn0icggNOUe6i6u8ryUA3YIbi5Tux1vyu3kf
	4ob7LDgxtMsZN1wEFEXTytlOYfO+Qp1ubnLVOWRjfASxOnSVsQa+Qbocnw67cKqxlYntf1
	h5ACmQ0i6JXM1spig92VSrQmXYt3Ezo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782436651;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8A5z9PZsiUYW7RbErPIcWNLwyOIpxbQkYmw7rEsKEZs=;
	b=YnE+OOaKE5eJx6edfb+t98AIQvsetwCBGzUxinxYsBQrnDV3d9tXKKnKUjNHeBYtq7vP3n
	rCfQlVj/kDs5/qqFgKLlJauRuMgl9f2ah/LhaTyPiVZpv56hQRypA29jrEp0+9fgY0ymxu
	0ILEjV46gG50hKCrsFCfrHfYizrO0Ws=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="QMqYd/Dd";
	spf=pass (imf08.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782436651; x=1813972651;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=sh7xAKwl3vLKab8xlpiAdd6a9cFO+D+hwdwFYuahWL0=;
  b=QMqYd/DdHJqr1q0iMtUc1Mnw1KKmpidpi3oaS32VJ/dKX9y75x46HkWL
   yaKc4+nKc6NEF6N/8wQTHVAE2CKSF4M1sp9lRuxTGLOCB6PJrJ6KlbJxf
   JmipIoyXUaznYBUW7+5qYin9gg6zwIYH7qguABdRIZfaKx52kzcQCupAU
   AZDR60K03++aVNKub+54ObUaoQvB3UW1YIkbEjGCYvGm8SAl9aAoDK3sJ
   kdyyXYhXgs4pPtTKc92+3DwEBoCHmOP57ttAXlEY7AQsqMBeN9bGUHibm
   MOq7wbEHSzfPfCBHXro9KIttNkxZYGSRA8XlatAKLJCsW5Z+PipyA1V9J
   g==;
X-CSE-ConnectionGUID: uZ3O9EYxTdSjVGOSBW+QpA==
X-CSE-MsgGUID: zNWLHZxxSkCOiEotDt/BOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11828"; a="82223983"
X-IronPort-AV: E=Sophos;i="6.24,225,1774335600"; 
   d="scan'208";a="82223983"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2026 18:17:29 -0700
X-CSE-ConnectionGUID: stUXW0E9R5KsYdhKSLfjLw==
X-CSE-MsgGUID: tJSP9EtqTSeEMRlAxkodxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,225,1774335600"; 
   d="scan'208";a="256102406"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2026 18:17:28 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 25 Jun 2026 18:17:28 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 25 Jun 2026 18:17:28 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.12) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 25 Jun 2026 18:17:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CuhdYDfvVpUTNSDRjlcvdqJhFNEaGj9MVUPtgDA5Rw66Jy/5Jgn/WBDTtLK43G/sbAt/pXbynEzNxan6Yy+TX1Bg4aE0Wnn+EaLQD2gHWQIP2YWoS8n3F7/Z+35QBmKVO2bH097U7XdcoK4x2IMr7LLUjxxGC5RqYrhRj9N8iZ6hgyNwElT3V58Si7edq4NtMrd4uE4N5E383LuIOE6APU0aWtXtsGN3DnAPFNGKSx0M3IxQMhqzYKFsmdLYCOoyEO9Z2VVHIkXuIEBWsnabWME9I/D+R62htf1HZ8+H5FE1JHy+May+xC2tlzanXujlu0UFgsP8f5ITvxYLzDw59w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8A5z9PZsiUYW7RbErPIcWNLwyOIpxbQkYmw7rEsKEZs=;
 b=xw4CDshouPpK4UJ9h3iZhI11lu787yY0OY6bCN7n4l0TPjIPBAt5rIIPyHcKnoDBjmsY2vmhiWDL77Zn90+jeaX0HG7E80mbeGqCEjsBhzLoZOTatiaqXQFFar5GSQt967qyxPsRHZ0LNhAYAWZBTJ9Rko2KK28+pFd8a47M7a/Sl78Gupb8VqdWYSpsF9li6UBUh+LYikfax5hlnZ1zdF/UOCLIY212VZXvJ9F8pn6NgI8uVELTu8kpQ3i4/IMkya+Zjt0wUUUaHTsdTaxOPjoQEpEhv4NWzTdJbGB4tBJt+4PIfZcVo+bZiYgMA7HPTPZ3hx3j6+ptjQttkPvMig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by DS0PR11MB8183.namprd11.prod.outlook.com (2603:10b6:8:161::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Fri, 26 Jun
 2026 01:17:24 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.21.0159.013; Fri, 26 Jun 2026
 01:17:24 +0000
Date: Fri, 26 Jun 2026 09:17:12 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Sean Christopherson <seanjc@google.com>, <aik@amd.com>,
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
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
Message-ID: <aj3TGLGWT1kMFIVH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
 <ajjc0hw8PjGw69e9@yzhao56-desk.sh.intel.com>
 <ajnf5Z9nWZxoLS4x@google.com>
 <ajoWngKaZ+wfIyR+@yzhao56-desk.sh.intel.com>
 <ajpGxu2uQys+S2F8@yzhao56-desk.sh.intel.com>
 <ajxasFBzp_9KnQLq@google.com>
 <CAEvNRgG1nHipzw4=eBgwhvyXi8xYo7FQD_sy9Ax6FDf7YDu3Og@mail.gmail.com>
 <ajyRg3BwGu5dCfOn@yzhao56-desk.sh.intel.com>
 <CAEvNRgH5KOHoemnC9QOn_oK97=KeAH1XuX3ps36-pJ0Fn0aBHQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgH5KOHoemnC9QOn_oK97=KeAH1XuX3ps36-pJ0Fn0aBHQ@mail.gmail.com>
X-ClientProxiedBy: SG2PR02CA0136.apcprd02.prod.outlook.com
 (2603:1096:4:188::16) To PH0PR11MB7472.namprd11.prod.outlook.com
 (2603:10b6:510:28c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|DS0PR11MB8183:EE_
X-MS-Office365-Filtering-Correlation-Id: 51ba2d33-d923-4b54-9582-08ded320ad9a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|18002099003|22082099003|4143699003|6133799003|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: 17R4vo00ud8nYqvCsbC2xWzSaDjNvccyPdkH0d1DUS5a6qbzz3M7UxMer7J0xwtF+4npWY6h1BhsBvQUPFOaCbEgLsYJnMbnLmYiBlPknwVygP2KSW3W77fReSgNDjo+mgbHNCrYA0pqjIZ669+SGUNtzUl81ciD9inZW65obIUdDhaNutqez5y+1lIVQAcQmq+TjRkg4T3bz11gwrDE1EQJ3knTAHraohVJW/c8KZCaqjS+7BYikmudL41FxVeoiH6O7gCuIrhPK3txtDBfxopDdhVzihe8eaxGKf1gK6iw57KzQGqyl3SbNmAxGW5RlQ9TFoh6ROspdmMPAIRqHpoS7nD0ORpHkd+CBE43Nw4F+vIvemNEfceoLQyvYavb0SKPwiXxHVAW1iDL0SJTqZuHPv515oKYLatmefyINcuSNsJTv2LDprIUEzY1H4qBiufsUk7RuEhIXB2xkPQp3Gt4qICfMSuHPXnYZeUoV8QVMrpNvr2vnAPngRWZ2B4A+YAwZXyvyhWntstS5ipD79H1f8lO7oYHnyJMjHuoNb3GPs8MsuRkYc73LufsE9wO3AzHzertOBVgaIroefa0cXX4krI0RWfwPh/ND1v5IV9BicvZa8I4kC9ueIJzV0MVnGTPYZ31tdM474ziD9mu28fXDAtWMxaNbmSHK6gFSmE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(4143699003)(6133799003)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5gtVQXt/82HtuMa3Sb8GeuTfpbyeo0xZBMj0UExlAqWyXzr56nbNuc3B1b7g?=
 =?us-ascii?Q?6sYiSw5ALXtT5FiMrPVBiL7USpE+hAMUO39BofLuH6roIM0Z5p1hJL1JYhHH?=
 =?us-ascii?Q?pjpfvKkFg/vHSnw8aFbEAyR/vEetCjhZ5w8VcLWxliTMctnkNJZrMuw1+W/R?=
 =?us-ascii?Q?zfUFbu0q2kB6V3dyoT6Zf5khsNuTQavhHxLf+zypzDrjy8KDjAICeoqx9vfw?=
 =?us-ascii?Q?dweTDpS5elj/2YIFJI/b6U7ZTWM0cKSpJoBIDxlc4/wZKIYSaGE2iQuKwthe?=
 =?us-ascii?Q?MC/lPf0dNrxmHavT6ZpIfCHmIoEsEGK8N+/IVne4u0km19Jb6hIZCityLvNY?=
 =?us-ascii?Q?es+RTF56l3dgWVxxCLQ5KXplPvs7pyey+rOt6piE/Xm158jIpemSjb03Ggxf?=
 =?us-ascii?Q?o44Yh5SWE7SgdZkgaR1nO7d6E8Ywc6yTZjQ98rvQZCo2TgwY1J+uaq75DFdl?=
 =?us-ascii?Q?vV5NzmJXQnYPpHWva5/bYkiyZaFk/ZG3Lh+c7aFNZd1BbidJ2pNbTJ5ayyxH?=
 =?us-ascii?Q?cuK1bcYk5m++x8P067gdsBoeunS0hqDLOVFSkKlzBP3NYGj49ebq8dbGySkO?=
 =?us-ascii?Q?nCd+HT4f1IbHxY8S99q4BUgIJQOAqCaez8DfoRwLYkgkrVu9HttRLTMv8yAI?=
 =?us-ascii?Q?Xd7l2ocicz4xy4zgGwSHrqvmflMq1WIZy9c7654E2yWjhtnBW2gKsUrqsmyE?=
 =?us-ascii?Q?WMQhSSckzsNfUjOvLylng6s/venKdKNlilcFlIomRsSB23GpjGz8bMRScn9A?=
 =?us-ascii?Q?xyJO2UXUpjpXBGuiOFJMMelO2L5juPwZbnwHFbZiaDNZHI2iyTFHW6wo3Jsk?=
 =?us-ascii?Q?CZKiUKbm5UNp7JzpHzFR9arDjoGA2lK8GO7HpRJE/8col4NqvdEaGrCJTIdQ?=
 =?us-ascii?Q?qO8iGMZNcBXQCKnOG891Cp3PPK8sneC8KVPtQ2uG30PtRvfZU7cx0SGbzraI?=
 =?us-ascii?Q?7mAZqfAe5CYNeraUhcqD5KFBJwnlayMS3PBIBIj7t6mPNKoP+U2B4sUztkf4?=
 =?us-ascii?Q?mawcMjvg1vVOtvr7LDwWGG+kNOo9dagmKsv84faZaaWj6mD57b73M1vu8Qhq?=
 =?us-ascii?Q?lAcJZ1+hEfh7+RRe2TLH6WjinjFxijVybL+ofy7ZH0SJ65sQBg+ClQ+VIbCX?=
 =?us-ascii?Q?z7rZbS9GdkYAUAYPE7lm/or5B+RxPgfO2JldGbqc/WLX5Fyv0Lpr++vo+P3P?=
 =?us-ascii?Q?JLroARCz6+lkzo43UztitwNHrCwEVKVlIMpo6qdyakP7wb2kDJkn0BrzJipR?=
 =?us-ascii?Q?lfa+pgWqvwq9mITSxIXUTYGdzbJRhmll75yOkPzrSZTYxJY0/FFDuRnOWM8v?=
 =?us-ascii?Q?Aa0Fcf46w9kdl1ntLOTeo3/KynQ0gs3j4ojsGzLVUjoFywjsGQOPXXgTHo7m?=
 =?us-ascii?Q?ry4JlgQACXzd20nxz/zRek93URDJhSORD6nYnevkPbpw8olMfijWRwVhDPsA?=
 =?us-ascii?Q?k3q1G4T3XLp+6Z7c0LS7Y8QXIX2Blc7nH4oVFwJ5UcQDgFH6YMQK0XJeUroB?=
 =?us-ascii?Q?8bYZhf1UgH8P9TAF0OOnU2mYqPh8DzsA5rfFzoGtGaA2RaXqMGjfQrECgPdH?=
 =?us-ascii?Q?PVHhaIQjUOdLJpN9uoLKj7Ci/n/TUlHYyduLiRyikHyXSXTCMGdRnkembhl6?=
 =?us-ascii?Q?Wv34SmRJU2o0Ug8zSB5FSMI5IlG0/CtBAP9v5YdqeNXB93eM88+LdbQaE3fb?=
 =?us-ascii?Q?eMGG+LztXzteVNipZLll4y4XYxKJ3U0FAtiaIXlWYcsKn3pWR3FnsyFvIZZ2?=
 =?us-ascii?Q?bX1bUnzDbA=3D=3D?=
X-Exchange-RoutingPolicyChecked: QR5YmlFUmSlygnRDCOVKCHIEEQkt7m7wnW+tem2gfgeVrFmPJPQHZ89PNoL524DpmXAfQKmOgyVBUvkhPk+0lV/vC+LjGCb7lzJUYYdQb6SpqmUbli+dAX9RcYa3nmNYv7/36D7YqJB+GQaWcARAqKJpoEXQPGrYkmLEL7CqRSY3fD4SKy5FqaHKQc6IQbL/0NALT1NjjzbVbeFjTJ1m+oTeP6IwaJ0KFsMJ66TT1LBDsWrWkBFXvWUG526wJstXY/qDyf8cXiM8uM1sP2w61Ynw2i/PG6rNDgAWyzS4WIFDXmAyOiBH8hS5LC7gbW5EvVc+GfV5mC1OE2sW4OHB0A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 51ba2d33-d923-4b54-9582-08ded320ad9a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 01:17:24.2535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZCfCByBoYtykho1oPhk4zfENepU4326aQdEgNnN7cifskZn27zll1bWY9RQSnVGs7D38DMZBA2nyBDEl+lE+9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8183
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 54A6C16000C
X-Stat-Signature: trw8yx3nciu4smi5z6a6mco67iggs6m1
X-HE-Tag: 1782436650-25810
X-HE-Meta: U2FsdGVkX19mbRnanQsZgj4f2lhJuG8AYuILkHPlBNxkmR8z7rdRLHRTCjDMljZuAPUn8dQBY8x0CJHvfAiSg+119rDV6IanxlXQXsJUkybhs5QYcbkodxpiMXds9U4282nCatThZW966LytlTLgVELPnUAiaUOf0zhTAnQHiu9DVc3BFl3SN9peMG5K5lO0P6vpUfgZSC8wHvXiriuuFc6puu1S79QpE7qL3Rk1fyypyP3Z4ZOfRUGYZcvQlM0oFUwX1Uda72DeTjWKcIS5/Zn5AlyCMnJ+G4lI1zrwQrv+xbM1G7h/IuYzcZA5uwmsSrqMNnDgiIoD+V7t+fukdbIcdAqVuVdY3QiSXw4+vNUhSxgOlDhNYIFXUMCk8fNMmu/XD/M3zW9cHyC/y5wiNtJHMp4kozbL09bfj4fHA6eLAM9sn2GKyXWtLWMK7ONvx43uqGOooNnWeR4AIVEkF76a/YupR3VpznCcq7P7msDsByIfpQi7MIZ6O+N/BJqLnHuPWDAxk8QTjEdyCU+7Kl1hN3NQtJDUDE9+Bo0XKEBA5o9UGEDdR0PB4ICRFmRabx/sEbTycEe3IPUV319iDdhvjs+iYko5Kn997NgDpS1vwEik9WV9v+wHiCE2nzw5BiwLKM2F/Vdp2DNJzd83KKlt9DHNYNZWdIT+DkbCQ35gsYbuoIHseUNbrdxTLs9drGJkfK9tXiyhIhs1xoAhGvZgIjgxjsVHAousJTaKbjwA4x/qLwZ7ZAuoN1hbKsU9iDRxwM4kiSjPM9Z4l2ddvxYhnz4Kgs23jKhrYHqd6CDO1g/IUq7A03L0hXmJ3ZZ+TvipV+UC96bOAnSoNhRfEI6VY/iOwhAdATrUSkaKEaDWg493C1sSBPRITeRZwWjvkWMOUbRU/JwXtmcNzL73ZBo5AJmkdMfC9ubngutMywmhNYPc2ZRWZcMWsrzRi6nszDlHtxjTLHKiISPRixR
 YWKgB2KN
 56NJ7/CHjFiK6PrQxbiz4f0FQjFNa6Y3Dzgb2MM/TCAfU5YiGIPghj8DKl3Sfz1Shk5Jl8XB7/o54jLbxb4qC5l876B0ORe1K6h/0gMRqJ6ABvYDN17lS1KSLFvVljUpz4GplGopVzXY2x4ERCaAt+fsd8vY08vuO/UW2pTB2j0s4hY4ND8keJbqTaKGYJ4eW/8LhMS2oc7wfakpode8J5wif1EI5uRN5MivusFfEypSQ4simHh+cnAICKjnEPXLeEecqezuOX44n1dRTxQJRpj61RahhzJX78k62Z78WBxOtZJ0oIJe44RG80wwrk9phdsnQYUfLBO3aHEo26xzR1a6uE2G450MSoFW+Tb9KZlAP5Hu+DhF3zvxGjGI/14XulNVCWvZYPbWhlidIZfrnNToXRDyfzM4MbtzsSNbhsFrJ1rgTFzfEsuDllAV4/PpB8Gs3FTKirLNF96Z4LAjEadxuH0KPutuK4nIQ853yED8HWBwgnBrCx9H+6oXairN0dDQ2u4R129XXq7uV7JIU5b/M7lQdy6MiAw2eVt6fJJVYaJTkTXcO1uomEdtyEHDWQ5F6CFOnkoh1yoGo7V3hF0Odoai9X2/ETeV5T7nQuvGVvRdKcA6hG1OnZAy9/WLU8dVlWjhfZGgwnDXNpikyxFd9bJnxOwdoY9AkWeYvoqu89XIwDv2A+2EW+XNeOmuCOj1Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 05:07:23PM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Wed, Jun 24, 2026 at 04:00:32PM -0700, Ackerley Tng wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >>
> >> > On Tue, Jun 23, 2026, Yan Zhao wrote:
> >> >> On Tue, Jun 23, 2026 at 01:16:14PM +0800, Yan Zhao wrote:
> >> >> > On Mon, Jun 22, 2026 at 06:22:45PM -0700, Sean Christopherson wrote:
> >> >> > > On Mon, Jun 22, 2026, Yan Zhao wrote:
> >> >> > > > On Thu, Jun 18, 2026 at 05:32:00PM -0700, Ackerley Tng via B4 Relay wrote:
> >> >> > > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> >> >> > > > > index ffe9d0db58c59..56d10333c61a7 100644
> >> >> > > > > --- a/arch/x86/kvm/vmx/tdx.c
> >> >> > > > > +++ b/arch/x86/kvm/vmx/tdx.c
> >> >> > > > > @@ -3198,8 +3198,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >> >> > > > >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
> >> >> > > > >  		return -EIO;
> >> >> > > > >
> >> >> > > > > -	if (!src_page)
> >> >> > > > > -		return -EOPNOTSUPP;
> >> >> > > > > +	if (!src_page) {
> >> >> > > > > +		if (!gmem_in_place_conversion)
> >> >> > > > When userspace turns on gmem_in_place_conversion while creating guest_memfd
> >> >> > > > without the MMAP flag, the absence of src_page should still be treated as an
> >> >> > > > error.
> >> >> > >
> >> >> > > Why MMAP?
> >> >> > Hmm, I was showing a scenario that in-place conversion couldn't occur.
> >> >> > I didn't mean that with the MMAP flag, mmap() and user write must occur.
> >> >> >
> >> >> > > Shouldn't this be a general "if (!src_page && !up-to-date)"?  Just
> >> >> > > because userspace _can_ mmap() the memory doesn't mean userspace _has_ mmap()'d
> >> >> > > and written memory.  And when write() lands, MMAP wouldn't be necessary to
> >> >> > > initialize the memory.
> >> >> > Do you mean using up-to-date flag as below?
> >> >
> >> > Yes?  I didn't actually look at the implementation details.
> >> >
> >> >> > if (!src_page) {
> >> >> > 	src_page = pfn_to_page(pfn);
> >> >> > 	if (!folio_test_uptodate(page_folio(src_page)))
> >> >> > 		return -EOPNOTSUPP;
> >> >> > }
> >>
> >> Yan is right that with the earlier patch "Zero page while getting pfn",
> >> folio_test_uptodate() here will always return true.
> >>
> >> Actually, this is an alternative fix for the issue Sashiko pointed out
> >> on v7 where userspace can do a populate() (either TDX or SNP) without
> >> first allocating the page, with src_address == NULL, and leak
> >> uninitialized memory into the guest.
> >>
> >> Advantage of using the uptodate check in populate: if the host never
> >> allocates the page, populate doesn't incur zeroing before writing the
> >> page anyway in populate().
> >>
> >> Disadvantage: Both TDX and SNP will have to implement this uptodate
> >> check. guest_memfd can't check centrally because for SNP, for a
> >> PAGE_TYPE_ZERO, !src_page should be allowed with a !uptodate page since
> >> firmware will zero and there's no leakage of uninitialized host memory?
> > Another disadvantage: the uptodate flag is per-folio. What if the folio
> > is only partially initialized by the userspace especially after huge page is
> > supported?
> >
> 
> Good point on huge pages!
> 
> The uptodate flag on the folio in guest_memfd means "this folio has been
> written to". As of now (before patch at [1]), this happens when
> 
> + folio is zeroed on first use by userspace
> + folio is zeroed on first use of the guest
> + folio is populated
> 
> When huge pages are supported, the folio can't partially be initialized?
> 
> On allocation, if any part is shared, we split the page. The parts are
> separate folios that have their own uptodate flags.
> 
> On splitting, if the huge page is uptodate, the split pages will also be
> uptodate. If the huge page is not uptodate, the split pages won't be
> uptodate, but that's ok since they will be marked uptodate on first use.
> 
> On merging, the non-uptodate parts have to be zeroed and then marked
If that's true, it would be good.

> uptodate. Any parts that are in use would have been marked uptodate
> already, so there's no overwriting data that is in use. I'll need to
> think more about when it's safe to zero.
> 
> I'm still on the fence between the two options
> 
> 1. Using uptodate check in populate to reject src_pages that have never
>    been written to or
> 2. Always zero before populate
2 does not work?
The flow is
1. mmap gmem_fd, make GFN shared, and write initial content.
2. convert GFN to private
3. invoke ioctl to trigger populate.

> but whether the uptodate flag is per-folio or not doesn't affect these
> two options in terms of fixing the leak of uninitialized host memory,
> right?
yes, provided "On merging, the non-uptodate parts have to be zeroed and then
marked uptodate".

> >
> >> >> Another concern with this fix is that:
> >> >> commit "KVM: guest_memfd: Zero page while getting pfn" [1] always marks the
> >> >> folio uptodate before reaching post_populate().
> >> >>
> >> >> [1] https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-21-9d2959357853@google.com/
> >> >>
> >> >> > One concern is that TDX now does not much care about the up-to-date flag since
> >> >> > TDX doesn't rely on the flag to clear pages on conversions.
> >> >> > I'm not sure if the flag can be reliably checked in this case. e.g.,
> >> >> > now the whole folio is marked up-to-date even if only part of it is faulted by
> >> >> > user access.
> >> >> > Ensuring that the up-to-date flag works correctly with huge page support seems
> >> >> > to have more effort than introducing a dedicated flag for TDX.
> >> >> >
> >> >> > > > Additionally, to properly enable in-place copying for the TDX initial memory
> >> >> > > > region, userspace must not only specify source_addr to NULL, but also follow
> >> >> > > > a specific sequence (where steps 1/2/3/7 are required only for in-place copy):
> >> >> > > > 1. create guest_memfd with MMAP flag
> >> >> > > > 2. mmap the guest_memfd.
> >> >> > > > 3. convert the initial memory range to shared.
> >> >> > > > 4. copy initial content to the source page.
> >> >> > > > 5. convert the initial memory range to private
> >> >> > > > 6. invoke ioctl KVM_TDX_INIT_MEM_REGION.
> >> >> > > > 7. do not unmap the source backend.
> >> >> > > >
> >> >> > > > So, would it be reasonable to introduce a dedicated flag that allows userspace
> >> >> > > > to explicitly opt into the in-place copy functionality? e.g.,
> >> >> > >
> >> >> > > Why?  It's userspace's responsibility to get the above right.  If userspace fails
> >> >> > > to provide a src_page when it doesn't want in-place copy, that's a userspace bug.
> >>
> >> Yan, is your concern that userspace forgot to update the code and
> >> forgets to provide a src_page, and if we keep the "Zero page while
> > Yes. Previously, it would be rejected after GUP fails.
> >
> 
> I see, didn't realize previously it would be rejected because GUP
> fails. GUP failed because it wasn't faulted into the host?
GUP fails if 0 is not a valid user address.
But GUP would not fail if 0 is a valid address. e.g., in below scenario: 

#include <sys/mman.h>
#include <stdio.h>
int main(void)
{
        void *p=mmap((void*)0,4096,PROT_READ|PROT_WRITE, MAP_FIXED|MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
        if (p==MAP_FAILED) {
                perror("mmap");
                return 1;
        }
        *(char*)0='Y';
        printf("addr0=%p val=%c\n",p,*(char*)0);
        return 0;
}


> That's kind of orthogonal, I don't think GUP fail leading to rejecting
> populate was meant to help userspace catch these issues. GUP would also
> fail if the user did mmap(), write to it, unmap using
> madvise(MADV_DONTNEED), then forget and pass 0 as src_address.
The original uAPI did not explicitly define 0 as an invalid uaddr. Whether 0 was
rejected depended on whether the user mmap()'d address 0. If 0 was a valid
mapping, populate() could proceed.

commit 2a62345b3052 ("KVM: guest_memfd: GUP source pages prior to populating
guest memory") changed the behavior though. It would return -EOPNOTSUPP for a 0
uaddr.

But if a user configures 0 uaddr as valid, writes to it, and then passes 0 as
source_addr(not from gmem), I'm not sure if it's good for the kernel to silently
treat 0 uaddr as an identifier for in-place copy from the private PFN in gmem.


> >> getting pfn" patch, ends up with the guest silently having a zero page?
> >> I think that would be found quite early in userspace VMM testing...
> > I actually encountered this during testing this patch.
> > I update most code path to follow this sequence. However, still some corner ones
> > for TDVF HOB, which are less obvious and harder to update.
> > The TD just booted up and hang silently.
> >
> 
> I think this is just the life of a close-to-hardware software engineer
> :P no errors, got stuck somewhere, root cause is some unitialized
> thing.
> 
> >> >> > I mean if userspace specifies a NULL source_addr by mistake, it's better for
> >> >> > kernel to detect this mistake, similar to how it validates whether source_addr
> >> >> > is PAGE_ALIGNED.
> >> >
> >> > The alignment case is different.  If userspace provides an unaligned value, KVM
> >> > *can't* do what userspace is asking because hardware and thus KVM only supports
> >> > converting on page boundaries.
> >> >
> >> > For a NULL source, KVM can still do what userspace is asking.  Rejecting userspace's
> >> > request would then be making assumptions about what userspace wants.
> >> >
> >>
> >> Also, +1 on this, what if userspace, knowing that pages are zeroed on
> >> allocation, actually wants to rely on that to get a zero page in the guest?
> > What if 0 uaddr is a valid address? :)
> >
> >> >> > Since userspace already needs to perform additional steps to enable in-place
> >> >> > copy, specifying a dedicated flag to indicate that the NULL source_addr is
> >> >> > intentional seems like a reasonable burden.
> >> >
> >> > I don't see how it adds any value.  I wouldn't be at all surprised if most VMMs
> >> > just wen up with code that does:
> >> >
> >> > 	if (in-place) {
> >> > 		src = NULL;
> >> > 		flags |= KVM_TDX_IN_PLACE_COPY_INITIAL_MEMORY_REGION;
> >> > 	}
> >>

