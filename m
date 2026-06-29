Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8361CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691386B008A; Mon, 29 Jun 2026 05:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A2E6B0092; Mon, 29 Jun 2026 05:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494B66B0093; Mon, 29 Jun 2026 05:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 118096B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:41:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 898C3140619
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:41:12 +0000 (UTC)
X-FDA: 84932456784.06.B615A2E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf18.hostedemail.com (Postfix) with ESMTP id 520741C000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:41:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MNdv7NJw;
	spf=pass (imf18.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782726069;
	b=iJNcTTzB8QtqJTZ4h5Uf5iM3tbgrX3/W1GJTW0uj0ryTgfP0We6fABx29x/+g+Ct/UWeus
	MdnLFIsXwgPyWngtyxE9jukBBWp1kUd5DjQ7dpK8feaqc2fOR1Pm04Z5svmylsJcBg39qM
	aPsiIdzmunht6ETy5zTDorB4Jr5SR8Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782726069;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vch3AhBzIbTU8RgBhzZ1dGBJfVm0NwQ3Na/dRm8OArY=;
	b=xCBJdWTKLPUsK6UyeOYRva2Y6o0Eqhsfn41U6+YHXlyu/JZPLOg35X0XK3WcbhGBEpOQzh
	cTLYBfsIR4Lx3EL4u5roAVb63VE5G5xkVqhlQAWq/6HW68fZ7X4uH9E3x/cp2A+x3WwNsQ
	rHnPjcioJ8D07ZrJ/74XeDAM2kTrdDE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MNdv7NJw;
	spf=pass (imf18.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782726068; x=1814262068;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=mZiP7RACyxqKPo/363oWCucvy3Jirc5hGCIBfLRJl0g=;
  b=MNdv7NJwIHAEbVX82kZXzJDGPE3G0DjcIVm5iEpe5xAR4cyF+q/lTK99
   US/gMo6LF1KjYYTFViSAh+Y1mbwwnNGvIyN63EvU8Z1+C0/jib4NY/ZJs
   VRaK8M1LoXtp0eDMKjS72tjOhFEvctatsuUWewpFBkqDg0pAtc4Yx636v
   aoKyJO7JAUkdBBxuuFEYHdjlA1AQUbNHBfoVSWkShI22Mk9t1R3bLSH0G
   MxRBH0gfAG1ZCa4+UbCdu+akF0oePwtWFjnpG5TPfYwazK+C1Z6kY5r4m
   JgEqL/LUeCmZOwy8VZxCkIvPgdMCrpWwHX+VBE92qX+WIJnWbj9RTWgBK
   w==;
X-CSE-ConnectionGUID: mlOvPMgwQcGt/+rD54u9SQ==
X-CSE-MsgGUID: 6pz8Mlj5TjeP5t3YxqE0Gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11831"; a="83414592"
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="83414592"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 02:41:07 -0700
X-CSE-ConnectionGUID: 0DK3MJ6vTdOkS7peIT2O3g==
X-CSE-MsgGUID: zkiDFfjoSgilglgINJ875g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="252048628"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 02:41:06 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 29 Jun 2026 02:41:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 29 Jun 2026 02:41:06 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.34) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 29 Jun 2026 02:41:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KSmMc09wq9M0hokLMcm1hcDHGDaXT03ebqBuCLZB/ZV3DXVFs1do23Roz+F79NR1D0iokZqEOeosGzDC/+0jDQ0cxsrRTpmS6+OMZjxKNzZsQoiH2a5z8/3e8TUj2VWKdR7YS/V6l0Bz7RNb+yFUX3+D8Chk4NpOmMLzbhN0febp0Ttl2z+PYEv3L0gE1mGEZtf/egSmGBqHIisaEVe4KBzjAN2NdqSHzOwiKYoxBHwOwVbBKwkYgVyhb/ccQIkfJQisVpKrATDAQEjTImtBtG3ArDInpG9XjXN40UkIq8Iukk3l5cihx1f9ZnmSCTigGcXJp1druTCr1cA9xiunpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vch3AhBzIbTU8RgBhzZ1dGBJfVm0NwQ3Na/dRm8OArY=;
 b=qqGKC/jHYMb475mnJMi47ZksVARI9QffWLcydIM31M7ytSvekAUO9unYNn7kxzCNsIDYz54TfVbXXjoVw9RWYOvWgH2zhRwOMOtdZZDW5se7Bd8n+HG9Wc3PXwOjg0cV845kOz80frUd4t3gzT0NaFbiofeyfc8SpMtHIPituhFD8hi1oPOEV/iNgZ+bDf/EP1T9/VmN24JWl3SwgWJqnUgu0Ltf1QJWd+FLHkeh6ZLXZCw3apAvTZpCASV2nhX2XFqDvNu/Z9bUgLMq4TkYsoLAiq1Dbky5CTFJw4M0V2DKOweMRU+N+lSjTNKaNyOtElDmfSP+ZijB4cETTNk+Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by DSSPR11MB9644.namprd11.prod.outlook.com (2603:10b6:8:374::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 09:40:58 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 09:40:58 +0000
Date: Mon, 29 Jun 2026 17:40:43 +0800
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
Message-ID: <akI9m02jgKAdi4gX@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ajjc0hw8PjGw69e9@yzhao56-desk.sh.intel.com>
 <ajnf5Z9nWZxoLS4x@google.com>
 <ajoWngKaZ+wfIyR+@yzhao56-desk.sh.intel.com>
 <ajpGxu2uQys+S2F8@yzhao56-desk.sh.intel.com>
 <ajxasFBzp_9KnQLq@google.com>
 <CAEvNRgG1nHipzw4=eBgwhvyXi8xYo7FQD_sy9Ax6FDf7YDu3Og@mail.gmail.com>
 <ajyRg3BwGu5dCfOn@yzhao56-desk.sh.intel.com>
 <CAEvNRgH5KOHoemnC9QOn_oK97=KeAH1XuX3ps36-pJ0Fn0aBHQ@mail.gmail.com>
 <aj3TGLGWT1kMFIVH@yzhao56-desk.sh.intel.com>
 <CAEvNRgHb6WmOha6Pct_Tn8Ucuov95L=fj5=2R9gcHfx=b2V_+A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgHb6WmOha6Pct_Tn8Ucuov95L=fj5=2R9gcHfx=b2V_+A@mail.gmail.com>
X-ClientProxiedBy: KL1PR01CA0155.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::10) To PH0PR11MB7472.namprd11.prod.outlook.com
 (2603:10b6:510:28c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|DSSPR11MB9644:EE_
X-MS-Office365-Filtering-Correlation-Id: 94ec3230-4391-4d73-4908-08ded5c285ec
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|22082099003|18002099003|4143699003|11063799006|5023799004|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info: avScEtzIaxtHis+AgtmBcHw0KAbZMBoItvuYeqB/Id3eB4owbeXaGFr2hOLOwUzPdb2TL8heGuh+fsjTWehfCI7RcIMZc34MpZtozw2SZRy7CBeTyFVDYfElEQ4CaGDQCiQgRfl9+S1j/t+bkdv090gGM0klLSvP0U8r/v9MuOXabszgEDWKtPh/fhXlrKMv3AScPnJPvabVZSMMWLT8p2K3DsiGB6X+3Bl81MXkjcvEy5e23ppEwQSy4dp3TtQHpTsVj+bq9Oq/giin18Tft9JD9uD9zRTModWsG91xBRvK4mkRI45rW1kS/PnKnhdNE4y480dBwWtAzJrI5VeIy5moA7t/4U861pOUlqSJsjGj7qpa6+GYvdbocpoELC+A2qumdMnFquQ0cPkg2Gn2ty4c9/OT58qAkje+7ZmIA6xh7AckstQN2VqHeafFLvTdyYL7sZPSUIiUhdeQkKm42JT8dbU3g66pIiMfVC7We1k+OLppQj+Ai3LipTxHZPkV6395jjG+QHR5MeBl7a1MJPqK2NMlLM6UPv7804XjNrkp8o2OTU4dJlvQeFOgRme0ZmTdSwkLDomp/e4a1xY76HsFK6c64F/i69XEo+9Kqp3Oy/8POjnpj30lWEG10+0MPFfrjPNjfzjjtjUJw/Ux6CPqaaz5wvynIbfFU1no11Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(22082099003)(18002099003)(4143699003)(11063799006)(5023799004)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eDpftVZal5YwBsETx+F56UEPTzR77Yw7R/6LK8/wGqQrfykaXZxJcTkEWu9C?=
 =?us-ascii?Q?AFPLO//afKXlOVNh+GoNXHnJcBLm7tLeDHxTKY98hQLc1xLG2N0uHrDpgYe6?=
 =?us-ascii?Q?OIHwOJTZghsxHyQAYrhhMqi+aLHNnWMJciFunj20cdelRlJUSyoWXTwSee2l?=
 =?us-ascii?Q?Y+KlyoFfhLqeYF5A4eKabo9z3jpgY9tMHOW2Z+2I30EDFMyXNAJtxXoG0x2K?=
 =?us-ascii?Q?0P3d/MN5jRST40X6qTmP8voVrr6b1CYGtO9g2DlTaivhdqb3/3liGkXC2bpQ?=
 =?us-ascii?Q?G7K610uRnf8l13GdSzBOXzCD5p6QCUmo5nJcdv9wbMboG/7jtQ9z3HtJtvCo?=
 =?us-ascii?Q?wjZJ1mntN39/inqtvaAXfQBKAHNC0F8CjuaCnBQhFd6pPU4qx/9voDUTyeZ/?=
 =?us-ascii?Q?FVSijqFD/jOsrOu69BDaQVPZVmXHvPrwKQUe+WmewhnQxGop11ebDHO5213d?=
 =?us-ascii?Q?tzB0pNtGxEBU6Z7qa2rRw8bggulQiYtMGuSTi3c0O9Pk5Mg1zldhWDaGTpWL?=
 =?us-ascii?Q?YDvXF2XHOLj5HohLzNSZonuOeidmtOqtI9A1B2F/bc9lzY1FUVxCQYrEwULH?=
 =?us-ascii?Q?Kyk2P2pNqQ8dOlCYuhEatD8v3nfW8ita4F5M/yr5KlZTWet5S+SDeIcBAOjP?=
 =?us-ascii?Q?rKe5aaMUAnVlo6Xb1oVNsGRW1N26+wKISztI259tW5b2wArukACsZjtYnh/o?=
 =?us-ascii?Q?KCM3c9BOVdF0RY2B/usJSBSqUe9WB/J/DMs8RJIT6jVVCiPZUgRJr2i5BVHD?=
 =?us-ascii?Q?ep3rCyn1i+xopyBdPqz0HQNmkG1uW2eHKacrUifLkB5JRzvR20ONHkiLUiq3?=
 =?us-ascii?Q?XU1RTsPEzBQlYuTlCsO00cdG940SouFotZ8UnejlKlj4orKiV8qFR/7KCZ+r?=
 =?us-ascii?Q?4yRAcJztD09MtV2HrPYJrKVZqpYwpMHFGxFXm2UuWopAx4hCvQKP9Y7jmNpB?=
 =?us-ascii?Q?hz9Dx0immSpO0y/To/ofozXddF5G8CYKZtDAPPVJnmv2P3b9JvLNQbA/9UTC?=
 =?us-ascii?Q?iri7kzf+IcjVt8ENgsHBXbosOCi8zsy3XHShWQwWNDKg/61ai+sthcWDmeYP?=
 =?us-ascii?Q?tOSMhDN1uuNU1GECU20h34LsIh0T+RmZS3Ms4WvVX7REAs47R+xcEkdg0Z/Q?=
 =?us-ascii?Q?zYoi6nNszFQ6b2POUN0qYP71UY3vy/wypCD7LVPxS6YESBHxRsJB0SZp9/FE?=
 =?us-ascii?Q?2adFNrO41A0xWX9lt9HLd21ReX+jkpAxj9tc5MzrlZY8LKGVD+7pkTtGIhNi?=
 =?us-ascii?Q?5MCS9h10pwlBVQCxn88z/+se2FanyB+XAbzYcJkIbLWYqanz+jGSOF+5dJiO?=
 =?us-ascii?Q?0tPVyBMOGdzaB/YIfJ2vpQq60FLTRu/H7tVYa7LJKyyEs4lB7nZFFcHG1k+W?=
 =?us-ascii?Q?Qlw2wTWWnP7ExLRYn0G9qC10jb19EZd6s5bg9VnkbcfXHrL55RzoSfrggd2j?=
 =?us-ascii?Q?VdI9/rvtQjA9FIRQ2MLLtaY3KHjxAbBcTMDjRDMlz2xNrQpeYso6RlCmuv7b?=
 =?us-ascii?Q?vbbAJ4vScX1tiIzYsaN23WifzNowavrf/8cS9IqrIO0zC/HTuozBJTCFjTnT?=
 =?us-ascii?Q?A+SXVJGPoLkW2UWzCjMUtiaBn4CsUhhE7yg8+ne/tiy/KHYl6/KwwdRyPijz?=
 =?us-ascii?Q?5YyTo8cSwixqdKF4OPl/v0uTdqHq6tYtS7qqfB0hQmC+THIuyH1vIUzecGMR?=
 =?us-ascii?Q?/uuE3vauK5yFzrSqPqZ3LKHr02E9cSwLpWXUQvV/+YjaH7w03Y7Q8CQWKgnY?=
 =?us-ascii?Q?N/FGy8+Nxw=3D=3D?=
X-Exchange-RoutingPolicyChecked: nUm46iTIb7S6NI3xtD0oMlWp97T1n141HP9JEB5qAnzQrc1zQBajbF9APLXzH//hkHiC+vMVuXj1d7S1p6viuID6HmG54fkC/kwYtA8zWsQTp8GOgIy3g6yZ0IZkKdiuEVSU9vQ1TOEXgQ3yrp1N9EsARvImpRgukVoSp+M5dBEfeQ5+IPzbD46HUNFIadPg+5xTtXKTA5wExeQGzM6+yUKzuuSOgaqubi+i/vf9TfxRJV6SDQzZT4umm4Dh1QWwASA0irY6hEwVLg34Zl/8qXaw2RTY22JGqi99jxGZkoVaMHu91Syh6dF1ghm/aiIz30DKkKKLVnk/OxIGE/7ZzA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ec3230-4391-4d73-4908-08ded5c285ec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 09:40:58.3635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJYkH8ENloPTRtbJJkoQ33c9R5lcxIs/1ZGru5hoXse6Y75RvbuE9xxGQMRoF+5kBw7Z119gkBFFHFzWpwGP5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSSPR11MB9644
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: qdy7z44nttgtaw37efdxugaj4usiwht6
X-Rspamd-Queue-Id: 520741C000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782726068-829337
X-HE-Meta: U2FsdGVkX1+q41c2ThTLSYYGYVgCIMwCvXemF61ZJWnSQyhp1mtKZeefGG62toXpdFcZgvt11EDA0zHKa4KzWZMAtXtG4cwXc7rXSj3x5U89sZFzInh7y3IMmxNvUgsOSvElgG4spIABM9uxVbzCsYrJRUvi75rvkBEa3yIiJO837M29htJP8P+8LVrlwd1R4ilqSlKb73oK3zSvEzAy1BM/9UYZhmaJ8VI1jeGFYv3a9cog0PZnzCitIGHWqqKYYy4iiFFVKcxWpnQfZIWcrVA2146pHmFVsLRkT5Gg6lEjn9/U4zWHhAFrUh4pcpGEmwowuyX6hIEtHTTtou7wxThC1oZzpdGCDXjmPjCHJnR0BuhzMzfzLpZb5uJSAb3DkptLxbUTEuLLVyEnZGSgp7k7h2lFMmmLmvKhk4OLORv5s6ScxgCvPtNJsmsUP+8RSR7h0SIdGgAuj/WJ8m7Ah3OHl/TC7niCbw95+xeljtjDqeiOM68cVJAvZUxDV9kcRVoDIkqgY1R7WutRv3IydfbNBRvLWEhAPnscwPL5Udv5/EYb0MorTjg9X5LT7JiAiLXqufZUQwNV0MXPZLELY6EPMC2kh6Hax7vwjYBh7M8GfBdC+7JDp21OXjHV1W9teqik0KuQ1lOccdnGXtJ3kVS8ovaTsxCbH4JnwysHTqmEmRELmucFg/ugiddFS1jAyOwfHUCxnY5wQ0PDN6sGKN85xcx5Iswu4XZu7kvHz5MWeV9t0HzyPkL7Ud4g+cavpZ4UjNWNV+r2d3bSR0qcPwHNQSWFFxgEP14a/hGcBTU31mjXpPzsYLqEvqn0ucNPywQL9ysWjnOhWFvW1SfliUay7sYJjfdZZLcTI+mAM/48e3hMMeBXYWjJFy7WDi0pNFpUmuNfErqPLfKdimChF3Bsbv0DsZW4z0WOMV+WGhlVQdJ6pUKOKP0K7nkt5Gcd/I5k2iJ5Q5x0f3yYxKz
 ngTBK9hV
 UTUqr5xq1eMprLdHaMgt7K3BOkYwLgGZNwLPGgLW7oLIdcKOLufR7YBtBiKJhhR33cQBjZHorW+fvkfAfZBwTveKyHEJCpzqw3XR7KMYEzzGnCtTi/zzkm9iSUdtO6vxf/wIw/xMiRBlrBwKy1bBWHtrUGJSJgRjrFtldH2ey/5jlZP698vD4tHFWvI9XHyxcGH8/kP1eiYBNzGqtI25v29OSkYs9PcRrnXrkSMJE0XZCMYZbh89J+RPa4U2jeW2eLDR/fVwXYvuu3zf3pmsRwJTJd9BGz24Hz0uBBHqf0XUUYKsusXtEb9x6dg8xHCsP4EYwwmpU6BRxviH3Rbu/6fsP/3qgi4C+G7wgnERsdnlysJrduuT7HnEbcryaxTTh/v/E2APuqglTqKwIqFwo61DF61cNSRae2OkvHzoAYPl32zvb3zcoTGrI54g9Aa9VEN4li2pEHvH5kuf8HvZ9XIwt0UAmn4GZ8Ftmed5dYBlP5ovOLlMcvkSIvki+3SO3RNn5XW4U0sjxzzaT9zXyb23wCv4FR5NuvGx08z7DP0dgZj2RgyOMnAYPEWWSQZQwST86Q4CgRQW0MrDJ75EmJhv364gsmuGo+R0AjkJ2E7EYrmA9CyI8CNMztqXQUiGDhiGnzR2dS3568/T5yrnm0Fq3/6rYfsBjURcXLxy9fRU/8aPczsOU5g73iafq8ZwIzput
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 08:28:32AM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Thu, Jun 25, 2026 at 05:07:23PM -0700, Ackerley Tng wrote:
> >> Yan Zhao <yan.y.zhao@intel.com> writes:
> >>
> >> > On Wed, Jun 24, 2026 at 04:00:32PM -0700, Ackerley Tng wrote:
> >> >> Sean Christopherson <seanjc@google.com> writes:
> >> >>
> >> >> > On Tue, Jun 23, 2026, Yan Zhao wrote:
> >> >> >> On Tue, Jun 23, 2026 at 01:16:14PM +0800, Yan Zhao wrote:
> >> >> >> > On Mon, Jun 22, 2026 at 06:22:45PM -0700, Sean Christopherson wrote:
> >> >> >> > > On Mon, Jun 22, 2026, Yan Zhao wrote:
> >> >> >> > > > On Thu, Jun 18, 2026 at 05:32:00PM -0700, Ackerley Tng via B4 Relay wrote:
> >> >> >> > > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> >> >> >> > > > > index ffe9d0db58c59..56d10333c61a7 100644
> >> >> >> > > > > --- a/arch/x86/kvm/vmx/tdx.c
> >> >> >> > > > > +++ b/arch/x86/kvm/vmx/tdx.c
> >> >> >> > > > > @@ -3198,8 +3198,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >> >> >> > > > >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
> >> >> >> > > > >  		return -EIO;
> >> >> >> > > > >
> >> >> >> > > > > -	if (!src_page)
> >> >> >> > > > > -		return -EOPNOTSUPP;
> >> >> >> > > > > +	if (!src_page) {
> >> >> >> > > > > +		if (!gmem_in_place_conversion)
> >> >> >> > > > When userspace turns on gmem_in_place_conversion while creating guest_memfd
> >> >> >> > > > without the MMAP flag, the absence of src_page should still be treated as an
> >> >> >> > > > error.
> >> >> >> > >
> >> >> >> > > Why MMAP?
> >> >> >> > Hmm, I was showing a scenario that in-place conversion couldn't occur.
> >> >> >> > I didn't mean that with the MMAP flag, mmap() and user write must occur.
> >> >> >> >
> >> >> >> > > Shouldn't this be a general "if (!src_page && !up-to-date)"?  Just
> >> >> >> > > because userspace _can_ mmap() the memory doesn't mean userspace _has_ mmap()'d
> >> >> >> > > and written memory.  And when write() lands, MMAP wouldn't be necessary to
> >> >> >> > > initialize the memory.
> >> >> >> > Do you mean using up-to-date flag as below?
> >> >> >
> >> >> > Yes?  I didn't actually look at the implementation details.
> >> >> >
> >> >> >> > if (!src_page) {
> >> >> >> > 	src_page = pfn_to_page(pfn);
> >> >> >> > 	if (!folio_test_uptodate(page_folio(src_page)))
> >> >> >> > 		return -EOPNOTSUPP;
> >> >> >> > }
> >> >>
> >> >> Yan is right that with the earlier patch "Zero page while getting pfn",
> >> >> folio_test_uptodate() here will always return true.
> >> >>
> >> >> Actually, this is an alternative fix for the issue Sashiko pointed out
> >> >> on v7 where userspace can do a populate() (either TDX or SNP) without
> >> >> first allocating the page, with src_address == NULL, and leak
> >> >> uninitialized memory into the guest.
> >> >>
> >> >> Advantage of using the uptodate check in populate: if the host never
> >> >> allocates the page, populate doesn't incur zeroing before writing the
> >> >> page anyway in populate().
> >> >>
> >> >> Disadvantage: Both TDX and SNP will have to implement this uptodate
> >> >> check. guest_memfd can't check centrally because for SNP, for a
> >> >> PAGE_TYPE_ZERO, !src_page should be allowed with a !uptodate page since
> >> >> firmware will zero and there's no leakage of uninitialized host memory?
> >> > Another disadvantage: the uptodate flag is per-folio. What if the folio
> >> > is only partially initialized by the userspace especially after huge page is
> >> > supported?
> >> >
> >>
> >> Good point on huge pages!
> >>
> >> The uptodate flag on the folio in guest_memfd means "this folio has been
> >> written to". As of now (before patch at [1]), this happens when
> >>
> >> + folio is zeroed on first use by userspace
> >> + folio is zeroed on first use of the guest
> >> + folio is populated
> >>
> >> When huge pages are supported, the folio can't partially be initialized?
> >>
> >> On allocation, if any part is shared, we split the page. The parts are
> >> separate folios that have their own uptodate flags.
> >>
> >> On splitting, if the huge page is uptodate, the split pages will also be
> >> uptodate. If the huge page is not uptodate, the split pages won't be
> >> uptodate, but that's ok since they will be marked uptodate on first use.
> >>
> >> On merging, the non-uptodate parts have to be zeroed and then marked
> > If that's true, it would be good.
> >
> >> uptodate. Any parts that are in use would have been marked uptodate
> >> already, so there's no overwriting data that is in use. I'll need to
> >> think more about when it's safe to zero.
> >>
> >> I'm still on the fence between the two options
> >>
> >> 1. Using uptodate check in populate to reject src_pages that have never
> >>    been written to or
> >> 2. Always zero before populate
> > 2 does not work?
> > The flow is
> > 1. mmap gmem_fd, make GFN shared, and write initial content.
> > 2. convert GFN to private
> > 3. invoke ioctl to trigger populate.
> >
> 
> This flow is correct, is what users of in-place conversion should do.
> 
> "Always" is the wrong word, I should have said "zero if not uptodate
> before populate", as in, with patch at [1].
> 
> By doing the zeroing in __kvm_gmem_get_pfn instead, by the time populate
> gets the pfn, the page would be zeroed, either because userspace faulted
> it in, and the zeroing happened in kvm_gmem_fault_user_mapping(), or if
> userspace never faulted it in, the zeroing would happen because
> populate() allocated the page.

I see.

> >> but whether the uptodate flag is per-folio or not doesn't affect these
> >> two options in terms of fixing the leak of uninitialized host memory,
> >> right?
> > yes, provided "On merging, the non-uptodate parts have to be zeroed and then
> > marked uptodate".
> >
> 
> Thank you so much for bringing this up, I hadn't considered this
> before. I'll do that when I get to guest_memfd hugepage restructuring.
> 
> >> >
> >> >> >> Another concern with this fix is that:
> >> >> >> commit "KVM: guest_memfd: Zero page while getting pfn" [1] always marks the
> >> >> >> folio uptodate before reaching post_populate().
> >> >> >>
> >> >> >> [1] https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-21-9d2959357853@google.com/
> >> >> >>
> >> >> >> > One concern is that TDX now does not much care about the up-to-date flag since
> >> >> >> > TDX doesn't rely on the flag to clear pages on conversions.
> >> >> >> > I'm not sure if the flag can be reliably checked in this case. e.g.,
> >> >> >> > now the whole folio is marked up-to-date even if only part of it is faulted by
> >> >> >> > user access.
> >> >> >> > Ensuring that the up-to-date flag works correctly with huge page support seems
> >> >> >> > to have more effort than introducing a dedicated flag for TDX.
> >> >> >> >
> >> >> >> > > > Additionally, to properly enable in-place copying for the TDX initial memory
> >> >> >> > > > region, userspace must not only specify source_addr to NULL, but also follow
> >> >> >> > > > a specific sequence (where steps 1/2/3/7 are required only for in-place copy):
> >> >> >> > > > 1. create guest_memfd with MMAP flag
> >> >> >> > > > 2. mmap the guest_memfd.
> >> >> >> > > > 3. convert the initial memory range to shared.
> >> >> >> > > > 4. copy initial content to the source page.
> >> >> >> > > > 5. convert the initial memory range to private
> >> >> >> > > > 6. invoke ioctl KVM_TDX_INIT_MEM_REGION.
> >> >> >> > > > 7. do not unmap the source backend.
> >> >> >> > > >
> >> >> >> > > > So, would it be reasonable to introduce a dedicated flag that allows userspace
> >> >> >> > > > to explicitly opt into the in-place copy functionality? e.g.,
> >> >> >> > >
> >> >> >> > > Why?  It's userspace's responsibility to get the above right.  If userspace fails
> >> >> >> > > to provide a src_page when it doesn't want in-place copy, that's a userspace bug.
> >> >>
> >> >> Yan, is your concern that userspace forgot to update the code and
> >> >> forgets to provide a src_page, and if we keep the "Zero page while
> >> > Yes. Previously, it would be rejected after GUP fails.
> >> >
> >>
> >> I see, didn't realize previously it would be rejected because GUP
> >> fails. GUP failed because it wasn't faulted into the host?
> > GUP fails if 0 is not a valid user address.
> > But GUP would not fail if 0 is a valid address. e.g., in below scenario:
> >
> > #include <sys/mman.h>
> > #include <stdio.h>
> > int main(void)
> > {
> >         void *p=mmap((void*)0,4096,PROT_READ|PROT_WRITE, MAP_FIXED|MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
> >         if (p==MAP_FAILED) {
> >                 perror("mmap");
> >                 return 1;
> >         }
> >         *(char*)0='Y';
> >         printf("addr0=%p val=%c\n",p,*(char*)0);
> >         return 0;
> > }
> >
> >
> >> That's kind of orthogonal, I don't think GUP fail leading to rejecting
> >> populate was meant to help userspace catch these issues. GUP would also
> >> fail if the user did mmap(), write to it, unmap using
> >> madvise(MADV_DONTNEED), then forget and pass 0 as src_address.
> > The original uAPI did not explicitly define 0 as an invalid uaddr. Whether 0 was
> > rejected depended on whether the user mmap()'d address 0. If 0 was a valid
> > mapping, populate() could proceed.
> >
> > commit 2a62345b3052 ("KVM: guest_memfd: GUP source pages prior to populating
> > guest memory") changed the behavior though. It would return -EOPNOTSUPP for a 0
> > uaddr.
> >
> 
> I see, I only looked at this after commit 2a62345b3052.
> 
> > But if a user configures 0 uaddr as valid, writes to it, and then passes 0 as
> > source_addr(not from gmem), I'm not sure if it's good for the kernel to silently
> > treat 0 uaddr as an identifier for in-place copy from the private PFN in gmem.
> >
> 
> I'd say the original uAPI perhaps just didn't document 0 as an
> unsupported uaddr. Given that commit 2a62345b3052 already merged, uAPI
> was perhaps accidentally changed and no customer complained, I think we
> can move forward with 0 as an invalid src_address? I wouldn't think
> anyone relies on 0 intentionally being a valid address.
> 
> I could document that, if it helps?
What about just documenting that 0 is an unsupported uaddr which will be
re-purposed as an indicator to use the target pfn as the source, regardless of
whether gmem_in_place_conversion is true? i.e.,

if (!src_page) 
	src_page = pfn_to_page(pfn);

I don't get why the two scenarios should be treated differently:
1. gmem_in_place_conversion==true, shared memory is not from gmem 
2. gmem_in_place_conversion==false, shared memory is not from gmem

In both case, a 0 uaddr could be mapped to a valid page not from gmem.
So why not update the uAPI to handle both cases consistently? :) 

> >> >> getting pfn" patch, ends up with the guest silently having a zero page?
> >> >> I think that would be found quite early in userspace VMM testing...
> >> > I actually encountered this during testing this patch.
> >> > I update most code path to follow this sequence. However, still some corner ones
> >> > for TDVF HOB, which are less obvious and harder to update.
> >> > The TD just booted up and hang silently.
> >> >
> >>
> >> I think this is just the life of a close-to-hardware software engineer
> >> :P no errors, got stuck somewhere, root cause is some unitialized
> >> thing.
> >>
> >> >> >> > I mean if userspace specifies a NULL source_addr by mistake, it's better for
> >> >> >> > kernel to detect this mistake, similar to how it validates whether source_addr
> >> >> >> > is PAGE_ALIGNED.
> >> >> >
> >> >> > The alignment case is different.  If userspace provides an unaligned value, KVM
> >> >> > *can't* do what userspace is asking because hardware and thus KVM only supports
> >> >> > converting on page boundaries.
> >> >> >
> >> >> > For a NULL source, KVM can still do what userspace is asking.  Rejecting userspace's
> >> >> > request would then be making assumptions about what userspace wants.
> >> >> >
> >> >>
> >> >> Also, +1 on this, what if userspace, knowing that pages are zeroed on
> >> >> allocation, actually wants to rely on that to get a zero page in the guest?
> >> > What if 0 uaddr is a valid address? :)
> >> >
> >> >> >> > Since userspace already needs to perform additional steps to enable in-place
> >> >> >> > copy, specifying a dedicated flag to indicate that the NULL source_addr is
> >> >> >> > intentional seems like a reasonable burden.
> >> >> >
> >> >> > I don't see how it adds any value.  I wouldn't be at all surprised if most VMMs
> >> >> > just wen up with code that does:
> >> >> >
> >> >> > 	if (in-place) {
> >> >> > 		src = NULL;
> >> >> > 		flags |= KVM_TDX_IN_PLACE_COPY_INITIAL_MEMORY_REGION;
> >> >> > 	}
> >> >>

