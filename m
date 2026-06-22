Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B2F2CD98F6
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 05:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C6A6B0088; Mon, 22 Jun 2026 01:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D9B6B008A; Mon, 22 Jun 2026 01:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315796B008C; Mon, 22 Jun 2026 01:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 029996B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:34:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E8C91A0586
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:34:51 +0000 (UTC)
X-FDA: 84906434382.09.D4FB8A4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3EB0F40007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:34:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cHnlhdRy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782106488;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RyFfjhYxdsWMr+khTg3aRZNYL9VtLYMYKjKB+g+p2vc=;
	b=22AuFwJ+Rum6bxaYhGL28VlT+XMUgIijP3aRq6xBlza0MkW9ZiSzM5u01QouGpHnVFkMGm
	MJkskEZPzSU/XwZgQQGKEnX1ck716cIEo+KMtcGFYRTPvGXy7nmmDK+q3umjBgoT6zQ1sv
	koaxZ5Mcw0m2ZILNuIWMDwj8200bZ0E=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cHnlhdRy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782106488;
	b=4GKTx9gw3q8/1fE7zjDtxakAOJrJSY7JkwaEFG7KPToUN83ExGatJ2xd+9EbDGG83w6ddj
	aV3YYtxlxwPpJQVjreijf2uzs+WAaN/L1gbjjQ6HCZJq55TXuL5McVfr+49I6k1KdNHSzO
	ffnDA3a2SSaNwNPdxA43SUAKA22YTl4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782106487; x=1813642487;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=FIUuEA9lJI5YjoxLOH/bnJ6tHCB6l+esN7OrPdYqTSg=;
  b=cHnlhdRyluRdldjgGs0bwfKnyNNXt62veOUIeG3mR2M+iggWKMz8t9DO
   Vqp/1LD6TAdoG5TKp//i8ciW2JblU4rEY0NOKBKGRPIMV8Jv4Z4iSoJfh
   lvod8WDWlX3j0GztIfaYnWt38piYzdPQMrfpedhu6Aw1pQfY5XWD7a/+q
   BORCTgkEWP1UXuuZ/rVuo5ipthtY5Q4FxN2Uy4zw7VEblPBgnK2tOZstP
   pKvEq1IFoJtgYdO/rB5ON3CqWqUaEhvouZQMJdz5V/nOsBkq1GNM+Tbdq
   TgUuOP+PhdIUlxfvVKPF1dthyhKVot0M00QoAxnuETapmvhIz6wiG7wB5
   A==;
X-CSE-ConnectionGUID: DXNqWrGqQvCb/7Qhg+vemg==
X-CSE-MsgGUID: B2uX25hNTlWnocbPDvD14g==
X-IronPort-AV: E=McAfee;i="6800,10657,11824"; a="82923622"
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="82923622"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2026 22:34:45 -0700
X-CSE-ConnectionGUID: ltXke1pwQ1CUr0TPB8HhEQ==
X-CSE-MsgGUID: llh7/H/sRHGDu1P4Pk2b2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="248982413"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2026 22:34:44 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 21 Jun 2026 22:34:43 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 21 Jun 2026 22:34:43 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.46) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 21 Jun 2026 22:34:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lBPCenZFsJWQW5Eql7lLMjIuzyzBj7/lsyQglW9aydxUeWhx7ZOCr5xRgqJJGEvD4e9jpCdKYNTqqwR0vfjfKwd6zFZUauIVPvgTc7opi7VvYGGPef7+wmN/qXmLPS3YgKDayHGeF1cKDsFd4ekCtdZpLGqaZF6LG/t042DeHy0hnDUy/70CcO0gFe6MAxFREcXAVd9327wTpRsCLfxw6ZjNeQ1WrdSmToaL8jcGdweam4wJigJeu4GpXLDoYZiW4Si34dkh547f697wmGqyUv8OoV1J7Cz08OaFPr0AEd2dG+O0NR/esPQAk1GnCuDidQWM3zdZ16AdRXxPZx3TTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RyFfjhYxdsWMr+khTg3aRZNYL9VtLYMYKjKB+g+p2vc=;
 b=ovqFhntPjWNIP2qmorrnW4T/TIRus+bv80xbQbasqEwgk4ACrx1Qwj7GOhDBaP4GGV5UVSk20Iq1n9TBDc1VJpYs2CnDGY1goZGGkZd/sn4v0JsnDnRo8Ch/rnVdtCPH8kNI1DtfOY/eNRXVAGkeN4AO1PbvxSAC0IEtgn9bL0IzT8kRHkXcy1mQtg/KeYCtFUS+5BCfnPSyTRCccwZ7KmSRAgjdR+UYkfaPwofXhT4LqkbH2qdUVz2abSUPGjyItD2oOGm1GyKhlG5FtkQCcf0/00ZGYrqc0hbo07iFBQem0btiW7lyY644taNLVuuj4YkFBdNNcaPyzbwUj+dk7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by CH3PR11MB8187.namprd11.prod.outlook.com (2603:10b6:610:160::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Mon, 22 Jun
 2026 05:34:39 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.21.0139.018; Mon, 22 Jun 2026
 05:34:38 +0000
Date: Mon, 22 Jun 2026 12:53:46 +0800
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
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-coco@lists.linux.dev>
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the
 default
Message-ID: <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
X-ClientProxiedBy: SI2PR01CA0012.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::8) To PH0PR11MB7472.namprd11.prod.outlook.com
 (2603:10b6:510:28c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|CH3PR11MB8187:EE_
X-MS-Office365-Filtering-Correlation-Id: a2bda0e8-04a4-4206-b640-08ded01ff3ca
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|23010399003|1800799024|56012099006|11063799006|3023799007|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 1Haw93axPivZMiJFmLfoho3IklKufJURcMBrVuIaSB4ixfBO68yXhK4l62a54hB9KVQ89K3naYc+h1w7WCvqjsDEyUR0pTZLs2lXQ4cX77GHxQ3L2LBw2FePwQJa36eGPC5rbmdMCrmJQHT32olrewAZmc1tt03JFnSQJ/SvBAHIC+Hz3fDBp4nwLMs0AxFkRACD8vcEW5RhzU+y2FZJmt0iEcjOp9D9mibji1ClmbVG8YAQ6/PoPhCjviaWFonVd9YK4DtWCsg2f7UEvJvqDf6lB+lgpLR7evOOf/oUxHyEXnVUonZYbo2QYVi+K+5SQO+C/r+E2x1Kzpy+XnKcb+m2RVehcwwK/F7SKRn3Inxs8vnoxhwqlk3GW4E+BCiJzHEIGqTnqCnSlj+P/DA4I9BS6/h0S8qfFr1f0W0mtU3vzNDxKS2/EwDN4SjtJ1OKG9L93zIEZ1+OGfe+6lB/zrahVW2dkxN/zdvHxT8AyrySvtIy+nIUnaEg1y1+New16AljKb5iSh/V2lZeCZFwzVO1bR0ZsBAs8CENgd/zHxFs6zyS/VELuQo4W8zVvrZRzL5KLqA0h7yS+Yx7QdYIpyMV70yH/aAEo42DU4v9QMLpPb4gwjb05VCfi9ZmQBn+PT/bxD3y8d8rJm7ocGPhqFkfNi/YwNW6FKB5dQAwO1I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(23010399003)(1800799024)(56012099006)(11063799006)(3023799007)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FKvJa9kbD/JQHxNmmY/E43ZtztItoRCjvuWBUZ8tmkcs8std6j57nP3MLGIs?=
 =?us-ascii?Q?4VGm2vyms+LqfZiBeE+YMhByJbithzEzQpaFF0+UEYvYGLJrHOycsawn/SGG?=
 =?us-ascii?Q?Ksf+i9S8HJfkoimve66xXwnbs9ESmvqtxiPoHcRuhPUcPsZdDfPjO/T3MpkO?=
 =?us-ascii?Q?woNYuD10KbIHWJ73NwPst1+CGgCur/j53jhOblRNMGp+j0Xiq5qqLsc0xO9X?=
 =?us-ascii?Q?JTdROvXuy7BkG/6xdW4IukLQ23V1s0vrnia25nHgxLr6GxINY3kGXwwY0xxz?=
 =?us-ascii?Q?JGeMucqiCHSRyqL60V2JbBzAr7vXxePsdp+EqGXjKY1iQvVC0Tn5O0X8640Q?=
 =?us-ascii?Q?VP/Dv0DzSS4o5BptEarcggLFXTxMcU6JlrMfahPVy7IYUyHwPOF3Srk9MvjV?=
 =?us-ascii?Q?LPKFGx8wOyJB1HJqvpYhQpWkfcTQhOn4oOfyFZVKk7vB1YZe32KzQQqloC94?=
 =?us-ascii?Q?FY9olPxPEUfNjAI8WyMQIfpcXx+oW2B9W/pQ0oENGxrxsn7tl2pS+q6krq1S?=
 =?us-ascii?Q?gUgMt0OeVOw1qlq/ldJJykWjkuPAi1Bo3pdKrplNdFRAT4OOlZ4rtouW6kjJ?=
 =?us-ascii?Q?z/icvqishD80V4gqFWMxRdHwLfDCvIfisOsvOBMQYgt+dMhInZ8kCTvXwUTX?=
 =?us-ascii?Q?t77AAbni5wUBP5hsvcMGj95erUJqC+KpepuPzLwcNqh6qJHF8LHdCE63/nus?=
 =?us-ascii?Q?zrqdsKBGkI39GWqzy5z9/Grwk0kmz5LavNutJwI2HNSbTYx07Pn52w2GOxcq?=
 =?us-ascii?Q?cN15oMmTejzejN9mMO+eFIEVQ+Jvvt5sn88oXTRoOHGtg6B1Yis0AYAkU6au?=
 =?us-ascii?Q?/HVGI7m7q8kNz25Ka246wKaS4DRdCRSh+Kx01YN18zaQDRKqGBQskADrqjUt?=
 =?us-ascii?Q?p8FtZxECGcsyYjTX27pr5z0evG+6uByomNrqY61Ue0Uav3cug1kogMGR+OML?=
 =?us-ascii?Q?YLLPbERsLR7Ggd84SOQBpNECDPzIYisOLpbeuEEYs6OkefSIFVp3KeHPGAGz?=
 =?us-ascii?Q?6Ot9KzZPWwk7mxCu0JTUTsRSb7+04ut/35+lEtA9jNKfZAmTie8R1MI/emSL?=
 =?us-ascii?Q?J4mdaDfwqugXfTByZC12JvvRsWRyN/xUJhWVw+4eALWCBisRdRBUgpZu6NPv?=
 =?us-ascii?Q?dOWG15Ej9sSyQr3hGX6yvgafE6sCx8CxBTNhFKveYSqk4BNzT3UpctnNOv/b?=
 =?us-ascii?Q?CV8QIu1uSuxKYLKTEcNULp0+9aHLjt9imScFm3xxVTuLFWshtu459ByXAtnz?=
 =?us-ascii?Q?GOq88Mcl68Z42VR7OhnIoVahTyRhIIoGIhKG6WO14XcsdrGw+LUaiJVFKz/t?=
 =?us-ascii?Q?bfEFlrgTRpObT2/tM5FCfiBhYrFQ8iM1OH3Wllz7IVq3LHsWLssaTtO/DEMm?=
 =?us-ascii?Q?qOeZRn3sbwq6Ct5tmaXg2RAMLmliKaIzsfXfCNjv9OuroO9TKP8rACMQoPXO?=
 =?us-ascii?Q?OgNS4SFs7mKpufA9HmUwgeGRoe5HU28vm2LksQ5MoxWg37exl/gMu3Cozur/?=
 =?us-ascii?Q?WmauNIb06tG7urOYhW+feMIBjC4qoACR7PtQGgaoZ54fD1SEzjzxgxX5pqBG?=
 =?us-ascii?Q?E+8yOtEgCaPaxs2VKNX7QE1LMZ90aWdqDJsRz90aYfKx9v4dPOO+MvV95CFc?=
 =?us-ascii?Q?Tv0cX/MlSSj35aOI0K9OWeeGxo6PQ6MuWvSXz6Ogrn20ucENgOIl5Vj0BJwb?=
 =?us-ascii?Q?JglUDnUM6cTptIYZqs3abWQ8IT6UpjEYdoCl595MjRu41BmqGfO9zd4CT/+/?=
 =?us-ascii?Q?U0opJ3APVg=3D=3D?=
X-Exchange-RoutingPolicyChecked: cBpo2XtC7VLIlERky94gRa1sGJc8+k2Y4t4Z4n08ffwvKx/NQfq7VG01K6c4FU4C07IF9djVBie+Ywas5+vSTuvJ+h/UdGy4Aq6bDvLXeSzi+wzmrLSGili+JQodmEJo7NNlpvsWR1RIHutXgjSD/MQzDL63TcroqwMOCg3MxLw2YYMZdEwwyxCV/Z5LZ6zVGstzmkfKanYaw0vUrnx2MgWOR5kRTUNSm7oOUCzWLB8BHx2NX9ueUoqJLzATH/ds3ReuqPnB4vSdmIcDSIQR/Ket1lFidEtVY+z7mtm8oD5lDvuQZzCrVIJj3k0MQheLoIxXAh9TOZmhZMT1ZiaVqg==
X-MS-Exchange-CrossTenant-Network-Message-Id: a2bda0e8-04a4-4206-b640-08ded01ff3ca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 05:34:38.8455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DlZekpAv8Fo/LZkF95SXAVvbfi5JiUecD7a7RKvilhG7g5TyEKw1210h5uqVLkXwwcqV2zCo+RR983ReU7TiTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8187
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3EB0F40007
X-Stat-Signature: h7wg8td43pi3nn8x5nbat8bad64518ou
X-Rspam-User: 
X-HE-Tag: 1782106487-159602
X-HE-Meta: U2FsdGVkX1/F27cNuYiWeGxTQ9klM2vtuzqdrCc+iTeMnozkEvj1tuQ25aZQZ2mQ3o+Oy/yH1/7FsgSaXzNrVBOtrxtLUlPT6fnv91ngMfIRYr/JxQVUON7XLWurGRjihEMd8WAESjixzOaO9CQR7Y3K68f16XFqcJnsB/ZlR5tmiZa87+ImlbGWjd/Uxyav0RTJ4PMkIIAs8tz8rQ9uAFcYh2sZKHxC8leJky5tlZkFBTXcYwLCio5RbwIG3/spjCBJ7/nzG3mtUGYsk647fJBTKFM70aqgu6otr0E25DJirqjfvmHvtPvx4OjBOqPm3PouDwimER28F+Al9/uTl+r+ilbejRbMKtE/dW43JJ5ZF96+htiCzsBCt71OIdUdCGneu35iAGNFcAuT9xlmALgJdFDBNUTIFTNrntC2kXo0RahWl6zkIaj471dCGEgeYPJOD6zXQf4yRv2I/GGtDF11PdeVmXktCIPXgHyMvWFvwGnyiEqfzJ50Zk1S6FAJFw2orksUPrgpVUDn4ypB/1p3Bf9cNLeqNWBlMX/sKh4UaSyM5s7JNZqEPmsWUVDaqdN6tqr3L/vcQY5GwNPgCIn/Q3+fxFi8nLWwN7y0f1E4zZYErXFtTbx7M6EcLc4Ebz0z0/qEJYIJBQQRvoNM+jM6qVZWRaA4syhXJzSVb8naPSLSmHwLT42k5adVhtdqSAXPXb2dQMNuwzjjeBaoYnMO6UOUDYzWP5k4MmPlULeMufYVbIw6GzZCF+JBFRsUTUBVAwj5a7cqfR5SM4UyKhXnmqO3viTmOoJANXCJpFY/AvENkSzj66jvDzXI/AaXxlDqODpN0ErtfR3DZdlyMcnE+GH3KjTrgg1nPbkLQYtIMUoRDIjn9t+AjNm/FqF1RV1vuvyhDVHzVvnbT7PLGjGWylF+T+wo/a/jUMGYhHxcil68sPILuBvEEUsYndEv0NGCJuPtcgOTmhNBR6V
 s7Dt3wcE
 IWTHGdJZkCsedyx7kl/Iu1wXA3gS7BmHTSejjPy15vjfojde9IvxS5BuPfmLGFdJWktzB/kQlAulXhk0VKcL/TvPrzS1LYWfE47dbHXpwwHCbeB85SeaNBTv/t3+OS1MYkpz2f9nPE18NZenO0WkMD9wmoZr5EH52Rj5OsG8I9ag9r2m/4rMJPUooSM+UvpAcM3jRN4SSAHpMZOr+qeDbIH+HLijMJyvVIuh325oIr71uOKUqAhtudZ9Q2eZis4BTRoDqJ2ZKTLSSMvh1O6wLU1YkWtFWVfuqy3mx6I/QnNDV8jecOqTPFaE3A/CoGAyGblVh5mY8DQrnLCdqouhSDhAuoNcIsKEXIqwLzL0vG+cRi9r/HuxvlEvsEaRSrr6iVk/VBQe+yYlWA2ZulSxANyroqlO4fvFkxblTMGnco1ov3fIdaLu/Oopef0zbI7+hAZnNCp+Gydb194OLNf8OAfH3bLuuYm+qG7275rNkK7uRgqix0zMGOvWbQ5wf3epd1Bl2huHZ59fwkLySzIEs5OhCbC6qtnZKKi4t6nMJQwEVRg18ENYx+TiitU/YO9/ZAsgGLUHWsBX7jgJXl12OlhnxgCgYNzodnbbCcarutFIimhGluATyPn3OBwYGKXxoFMUUdnBgTylTeCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 05:32:01PM -0700, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Make in-place conversion the default if the arch has private mem.
> 
> The default can be overridden at compile type by enabling
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES, or at KVM load time through a module
> parameter.
> 
> In-place conversion also implies tracking a guest's private/shared state in
> guest_memfd. To avoid inconsistencies in the way memory attributes are
> tracked between the per-VM or by guest_memfd, make the module_param
> read-only (0444).
> 
> Document that using per-VM attributes for tracking private/shared state of
> guest memory is deprecated in favor of tracking in guest_memfd.
> 
> Warn if the admin sets gmem_in_place_conversion as false when
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not enabled. Add warning in the code
> path where guest memory is populated for a CoCo VM, since that's the
> earliest point in a CoCo VM's lifecycle where memory attributes are
> queried. Unlike other query sites, this site is exclusively used by CoCo
> VMs.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/Kconfig   | 7 ++++++-
>  virt/kvm/guest_memfd.c | 5 +++++
>  virt/kvm/kvm_main.c    | 3 ++-
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index c28393dc664eb..a3c189d765150 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -85,7 +85,12 @@ config KVM_VM_MEMORY_ATTRIBUTES
>  	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
>  	help
>  	  Enable support for tracking PRIVATE vs. SHARED memory using per-VM
> -	  memory attributes.
> +	  memory attributes.  Using per-VM attributes are deprecated in favor
> +	  of tracking PRIVATE state in guest_memfd.  Select this if you need
> +	  to run CoCo VMs using a VMM that doesn't support guest_memfd memory
> +	  attributes.
> +
> +	  If unsure, say N.
>  
>  config KVM_SW_PROTECTED_VM
>  	bool "Enable support for KVM software-protected VMs"
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 86c9f5b0863cb..5cb73543c03c8 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -1193,10 +1193,15 @@ static bool kvm_gmem_range_is_private(struct file *file, pgoff_t index,
>  {
>  	struct maple_tree *mt = &GMEM_I(file_inode(file))->attributes;
>  
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  	if (!gmem_in_place_conversion)
>  		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
>  							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
>  							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +#else
> +	if (WARN_ON_ONCE(!gmem_in_place_conversion))
> +		return false;
> +#endif
>  
>  	return kvm_gmem_range_has_attributes(mt, index, nr_pages,
>  					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index dd1d18a1d2f68..46e92b5dc3804 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -102,7 +102,8 @@ static bool __ro_after_init allow_unsafe_mappings;
>  module_param(allow_unsafe_mappings, bool, 0444);
>  
>  #ifdef kvm_arch_has_private_mem
> -bool __ro_after_init gmem_in_place_conversion = false;
> +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
> +module_param(gmem_in_place_conversion, bool, 0444);

With gmem_in_place_conversion=true, userspace can create guest_memfd without the
MMAP flag. In such cases, shared memory is allocated from different backends.
This means this module parameter only enables per-gmem memory attribute and does
not guarantee that gmem in-place conversion will actually occur.

To avoid confusion, could we rename this module parameter to something more
accurate, such as gmem_memory_attribute?


>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
>  #endif
>  
> 
> -- 
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
> 
> 

