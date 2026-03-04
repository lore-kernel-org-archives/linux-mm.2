Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46927EFCE4B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 22:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AECA76B0088; Wed,  4 Mar 2026 17:03:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA526B0089; Wed,  4 Mar 2026 17:03:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998CF6B008C; Wed,  4 Mar 2026 17:03:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A64A6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:03:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3827A13AB83
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:03:05 +0000 (UTC)
X-FDA: 84509756730.09.150AE18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id B1F0D4000D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:02:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XValxGOr;
	spf=pass (imf11.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772661782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yi6h2BrRIDnX1vjDJK7HTd0HWwqigQ3mvutLLPGjrfI=;
	b=h4CEOe61bbNpdQgGs0AehRjjOrC84WbQOhomjaFQ4IEcCYHNKlugqH5ss3iiJ/4goF6iMG
	5VnZYn1/uwTSjxKqSYl249heFu2JPEOj2hv+Y5sVnrzZUYnEC0z0iHtTeVisAnEfkvdkdR
	U8k6iiA/09Dx1MkNdujmSbCVIG5uGi8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XValxGOr;
	spf=pass (imf11.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772661782; a=rsa-sha256;
	cv=fail;
	b=YKAOwN508bMCPjO1rDYZ72mkDhs9EZCgole+MNx04t8YRQwf/eBRgba0EYoBQFFPQbU8Kd
	Kslvm2d6IBL3TpXPL6Pv96L9ZC1xHkaL7i4QF8OqLVzfgXvULUGGhd8a64CdpSlweuU99T
	UIlT0GFjE4Mqoth+gk0TGdiR8nJr8sI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772661780; x=1804197780;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Aifsn4HhFw1Z6/QaU4tZWLZVc12LFLDZCFBqo9LrLeA=;
  b=XValxGOr9YyX6qH+Afzat9jFhnb63OhSz510C63dS51tZ4z4Mq+wrrea
   zV9rN7IQ5DZkriEpEQd58aM2/oxqqZKp5lURlY29Dqe6j1Yg3b9eut76p
   31czy+toFSlpkNLFiD9GREXdgyWsueSo6miuudg+QixbVMlwRmWD/Hhul
   Lk6A6nlo0sq+7Jlaixm95slsU662HzTOXbOftdAjwRI23fdUJT+Y3lu1Z
   TIdzvQGXDYj3M+warkVnOStNy+379LBMyxyZXsBazEz51ee7p21iAsUGG
   kuFXq3ZUVaYMi7eS1nbjp12Rz26b9JHz7VHtXxtumamXIY2s8qnd4o4AR
   A==;
X-CSE-ConnectionGUID: apyBvyQyQJaVSiX7fJRMdQ==
X-CSE-MsgGUID: Y+a4mU4KQMmcxaFBU4jkTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73859878"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73859878"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 14:02:57 -0800
X-CSE-ConnectionGUID: wQinXnduTB6It1RpDEfpkg==
X-CSE-MsgGUID: GnTFtDaqTQ+pMmEWubgRWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="241486058"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 14:02:56 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 14:02:55 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 14:02:55 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.45) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 14:02:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vxSveXm/rhlDn3BgzvP4Eu0hXI9QwW1nL6DwtRWdd8AaxqFo+ZRxbwZavXcTtLcGZkF+IH+8hdQFZF9ZBEx5BkhNDSL8bl4p7CxdLVqEllrntoCb6GdY7ictA1EHVE32oUrcQI3RbF3nMVHXkLQbYbc2e/Tz5e9gGI+cL4B8tQxXyrMxYfCdwPcLRRGviHWoIxqZBotvSupnJ9tv1HAmSY0PY9kfe966bsfvsW7o6qLKkRipDLQMq+uScH4wJkkkmqhpXy+IvxBfCBpgWpeIOkdj0FeY2KEceLe13bhLOuMTXeJ1A5pf5Ka2h40z/iqWuMhIXqKGrNWjFaoQoN3ssQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yi6h2BrRIDnX1vjDJK7HTd0HWwqigQ3mvutLLPGjrfI=;
 b=FvHj+PXRL6vzBOKoOykjIb1F4IXz8LhuRDQL2jHwe5kfSvX5EazmmuzSWLnbyaetPBCXwwIQWQCYAQ14ehhc7PalnUTUmbOq74sW96B9vktQEzJm3WjkFyLNeT2/OaS3YcfTXXjClYjDE+hEj8sQl2I+qwQqc0Ay6NBReJYY2djy0F7QQ+1kZhPvNdtuxQsuot0lEB+geBgvQp8+eRgfg2GJ0/WQp1SmMtTuNdl5UtWj7hJWW+lumnBYLQQQjuf/x+ZXUVqxwfB3PFG456zl0p+Z0Y2e+eHb3z3XmundpXBsjFBURs2MiCx+Yl0V5Fl21vHuiqS5Z4R+rLM/xhXSng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by IA1PR11MB6539.namprd11.prod.outlook.com (2603:10b6:208:3a1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 22:02:48 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 22:02:47 +0000
Date: Wed, 4 Mar 2026 14:02:44 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Zi Yan <ziy@nvidia.com>
CC: Balbir Singh <balbirs@nvidia.com>, Usama Arif <usamaarif642@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, <npache@redhat.com>,
	<david@kernel.org>, <linux-mm@kvack.org>, <joshua.hahnjy@gmail.com>,
	<hannes@cmpxchg.org>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<riel@surriel.com>, <shakeel.butt@linux.dev>, <kas@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel-team@meta.com>, Usama Arif
	<usama.arif@linux.dev>
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
Message-ID: <aaisBJ7758NJ+lHE@lstrano-desk.jf.intel.com>
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
 <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
 <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
 <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
X-ClientProxiedBy: BY3PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:217::31) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|IA1PR11MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: 73db87c1-9544-4507-138f-08de7a39c507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: tAo0YwAjT5t4OvyHqwusnnlQDSxiXTHrzIRwWl3XQstC76+YKsoWN4Ni3Xod0X5vDhhyAjI8ItRdNBdJ/AhHhp7gJ5qUofb58DKZqDrO7qRSc90ypbqKMJcgqccI10pontPMd5650rw0TMEyO3hbCC4ug27yZRjZodSHKe9dd5524z1xz9eWxeit1EpXpyAteUQ0bPBvq91zxmiGGAkoAUg9QmGhAptN0FCo3mcoUyVtepyWglXCc/R+41pUnKDysmSwToYWWXC1OWXeNUzMY+uK4ixEJTuRHoExxd2FHXtklPFi8AV0OB7qSrvoLmFV2ToIQDOrepSPkxs9rKBjoQiqUk3uuefWRpzc3XWwQFuV0HfsFMUA/d97xkIhD+b8nKhb3Iwh3/H9QzbJ0SrppuLlUnyYp7vOnGYZ3peQj84NQUUIUogFxk36GW0l+VsF5GqKoNeKoMXbbkcRqXzsb6ykztAJghb/wYRguEL2S5t4walLSdEhBUO95dC2Pja1yWOa6CwMTB4IAsrn4MC1dpmVl2Fp05XpmorXbx3gUz1PEYUbA+NcZtg7q0ZBStLMUcLtRGLhEYr47L2ePZIYAcF2kaVztCePb9N3PkBuYBEHfut88/vj4njropT+fQ4d4f34rqODgj4wbAeQS89hCTaEJ6RCBnuchrLhK3YAFfdgPAqGbGuhg//dSMZDoLnY1TxYTWwYBTU+BT7LZw7Fmvt1UF8ZIXOalOun0rO+kdQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVBIdWlZaHg1K0FDRmJYSU45YlhOK05XaGpJd3h6RjM3NHp6aExoU2FMcW1j?=
 =?utf-8?B?bVZPZHM3Ny80VW5laVRwSVRBTW5TU3o2OStyVCtJQlkvYWdQMVRoeUZaNnV6?=
 =?utf-8?B?VEQ4V25vd0w2WFRRTGhMYmJrRFJiUi9BMDZlTU9QVkM0TmNpYkRack84bVdo?=
 =?utf-8?B?dW5DVEhLZVp1bzBFWE5uS0MzR1BXZWlSYllSWEdrcVN3Sm9BWmRQTGwyaWNR?=
 =?utf-8?B?UHc5aWlyT1M1LzFFazVnV2JxeUU1bEEzcUk4NUZlL0ttV01BV0tZMzFGNUJS?=
 =?utf-8?B?emhiYjVrVEY2ZGJ2Ly8rZ1hTMFdBMjgwM25jU0F4eDdFRDBEblgxT29vNWtk?=
 =?utf-8?B?dkMyZFZBSTQrOS9uaTg4aGlpam1Zd3dwaGg2VEEydGdIa3JGZU1UQ2VvTWVP?=
 =?utf-8?B?N3JxY0RiRktxNlNrR0gvY1VGQjFJTUQyZU5ML1BTSE0wbXhOV0NLeXNHa1dS?=
 =?utf-8?B?QnYvamt0aUI3aUZ4K2l6Q1ovT3JaUStWRTZ6elFyYkNCaU8zMzJTYS9HYzF6?=
 =?utf-8?B?bk9yalVnMVEvS2FSUDJpUm00RWxzUE5qMUhRQXF5endOaGZqZSt4dTBqWEFB?=
 =?utf-8?B?SisxeXBpQnh3Ylc2TThIc0RzQmMrWmcwak9Qbm1WN2hyQ0dQK1JxL25nU1Ja?=
 =?utf-8?B?MktMdC9KcmVIa05rMUNmeFUrWHhWdnM0alE1VFFuT3pCU0VVQkhlQmgzREoz?=
 =?utf-8?B?RHdQZUFQSFRsYmlZRkJWenhSQ213YlJydmFRTWZyUXdFSjkveml4eFRnYk1N?=
 =?utf-8?B?V3RSTFlOQ2xTU0NMSWZKMWZBNWFTclZMQ01nV1NJL0ZUdndTckRrY0JNN2V5?=
 =?utf-8?B?SUkvaGtDRUJlOWk3R1VXVDZTYWdnbmdSdHRWZ2NMdW85OWd1R3EvYzdyL0pF?=
 =?utf-8?B?Z0x0Sm1UaHk1RWRXY05EZEZGUzFmb2lhSDRUZHIvVElSZ2dnQ3lXSVMzOFY5?=
 =?utf-8?B?TWYyRWpqK2hDaEY4MUQ3ekRrUlNiWlI2N1k4OWxieGVPU0FjbWlKNnVSaUV4?=
 =?utf-8?B?OGo3N0FyVHJibXM0WEJOZHNEOE05dmQ5WUlYVnNoTDhxK3VWdlk4amYzV1VC?=
 =?utf-8?B?T1J5UXZkanZnc1d1c1E2NS9FTFpBTFdUY3hGNXJKc2FGTWJZRXRmQ2lxWDFR?=
 =?utf-8?B?VTBQaHpQTzZIaHQxT0ZuQjl1MVlzcHh5aGRwdlVCUnhMZTdSbGh3OERiRDhX?=
 =?utf-8?B?aFJUV2hneklUUjNCdDV1SkVobERHamltb0dDVWcrUXZzaEZCbm5NQU5jQjI0?=
 =?utf-8?B?N3A1dXJJaXE1M0tQNitPSXpDeE55R0NRQkhrSytjMk5xa2VhVGxNUUtTRDdC?=
 =?utf-8?B?aFdobHB0SjdEQUlZUzJ4NWhQM3k5L1ZWcEJQNkZDdTVBak9RcW9SVXpCVENi?=
 =?utf-8?B?dHFzNjI5ckJsbDE4WlpjZjlWd3FBV1BWVWZleXFKZyszRnRsY2RnOE1nQVQ4?=
 =?utf-8?B?MzRHZWRGYjJXaGFCcU5sQkZvcDIzd2M2U1hHMHRPQnA1WVIvYjlUWjhjdGM1?=
 =?utf-8?B?Y3dTeXpZOWpLdEpxQTE3SFVOOG5BVmVsOXM3KzVIdjZadzFHREkzVG8vYnhm?=
 =?utf-8?B?S2U3akZ5TEpicWVobEYwRzN6NGlGSys4SmxpaS8vc0ZsK1VzaThCdGpyVldE?=
 =?utf-8?B?WUl4dnZmUXp4Vkt6aGpSeWxxdXJDdHZ0dXRSSlovU0dmbmRCNmdyODhnTkJW?=
 =?utf-8?B?cnB4dUp5NExORHJvWms5OTcvQkgzSVNnM2V6MHhiVGxGK1ZhTjZGNEJtMC9Y?=
 =?utf-8?B?emJsVG94c3pKZGF0SEg5TzlUSDBVdkxWQWdTS2J1djZqeUZ5WEtrUGhnVWRV?=
 =?utf-8?B?RFVhVzM2Y0ZJNVJWREYwN3YwR3R3d3N0bjQvT0tuN3ZWS1V0OWFVbFdORW11?=
 =?utf-8?B?SmZVTEhUa0l3YU1xbWQ3N256dUdiSGFkd3R1QlZtSTdQZ1V6aXFHOVg2NU1l?=
 =?utf-8?B?eDFmSm1kcDM0bUl3R2VJaEZidDhWTjFidUQ3OVE4dGZmaUgydmNBVllFZlJE?=
 =?utf-8?B?L1dJNE5XS0dYSFpmR2xDbm84YjVKT1FKZTh5WkRDNUlKVm5zZkdBTCtkQ0ZZ?=
 =?utf-8?B?NkQ2S2NHWEdxbEhYSnRzbjV1TGdGM1lvOFp4Zldpek9lVHQ2NjlJMXNMZkJp?=
 =?utf-8?B?MXlYU24wb0dZZ1cyTDFPcmpGTngxSUNrWW11RHhoejgwb0ZwMXZpdld1L1NN?=
 =?utf-8?B?eHM0ZVdBZzdKNndwRTFSWnJUNy93cmpqekNFMkFuWGpYMXBZdXVJT1UwRnBX?=
 =?utf-8?B?SkU1RmQ3RTBpNVpLeUwzRXovRXFsbEFmTmR5KzlVVkU5SDNqTnc4anZwNm1X?=
 =?utf-8?B?VUw5YjJ6OFZIQzNyajBYclA2Qi9JVVNwWHRoK2F6SVM1bmtGMWF6bUw5alZ4?=
 =?utf-8?Q?i7yoU4cOmH6ZLnEI=3D?=
X-Exchange-RoutingPolicyChecked: jGsKt+4vM8PbMoGr7jc4NctXjiuqoLCsqWd0jcJsab3FLkZB6G1cbZnspT4Hhomd8QAQ3BAusY5hD+gVekgISJDxxDMCPYrW6iZVaGGu2jmyoGahsNkAssmXCcNL5ikOuzcr+F29oNYiYkeyAnTf1PX4hAEkoqVx6NZIWxEL7Qta88D+5hmFkKxHPYvkyMt8miKvJ85dLYOWNWa7m8603loXCmT27CwUiVUxaDbrkRlvax+WE/7zX+zSEie3M4MzdjKNpP7pHzt8/B2zGtA7XtjLh2+/UnIIj4VeJJWKDC8FrD/LOby4LjCxMoxeEVbT8Z6I9N7JQbH4x+R1zCQIlQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 73db87c1-9544-4507-138f-08de7a39c507
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 22:02:47.1801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zv3BKWKbMAWehTbwZLydsof7nPtw6ihwkkiQqV7/60Cu4HRIJtqc+suGJNoO2C31ll3EiykRGplCjkHGe+QyeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6539
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: B1F0D4000D
X-Rspamd-Server: rspam07
X-Stat-Signature: r4kf114gj6ad9w7auy37tdeoiah7dzuu
X-Rspam-User: 
X-HE-Tag: 1772661779-536824
X-HE-Meta: U2FsdGVkX1+IccaEDDzW3t9BUIe7UR/J4qsNIqAaxoJE9OCmwTMNr1hi34XaR30mG1CqRG+m71PufzhGoeNb0PB6m5wNQWVBSxMvr8CQchtozy/h8E2zOHh5kRvs5qqWbfPyStn59IyESET9x18VneNQx1xbJ+PNLHpo2mXjRm6QDajjXMriMprHm6sm40g1oFlybOY2e1rDkll11AZ3/tJaYvcWQxRP4AVE6gJSe5u7YQh4uocf06ntE48x7GgLelq4S1XwIbzcrOyLb7Iwq5nFRV07Q7bUnGnFlnBzS46A7/sBatu/P9gS7ecDN6oiF+BHrl+XbeN9jQPBef1Xn48+UK26F/IWu+H9HPK0fioYQporQNiEV9xFYOW6Hx2c4FIzX4UxNPgwluP9aMb0Y3jVp3AYavZhJXaVgtFFQ8HMD5rWw7xlIwuXJO7SHNXDc+p0N23JLLJ5/UsNLM80Z10px33+ytC8edf6wCxF6h+1ip72QENVkbFlzr4cU0txCezohIIqobpSSE7BChtvgfkdszXPVqHHWWo1Dzs3lBMWps9upsyoP23x5Chk7oZXoaatIKBAHt0aTU7O7JUPZ+V8/Ai5pcqY/CI2bYXXQfDgN81Wg1quUKg5KpnrLuarM5yJ82iHZw3PwJVD6EGVijPTIvk4n3LrlYfV7XI037x9K1QQKvSXsvzKBl0hFsR0lL0lkRAZMaO57Uy7o9hct+bT5351OmuV9o5aF5IiPFwngXU6uW+uh2gdRsPIS4MdP1T62FyIS1emZ5G+If8gxOhevwmZGmCIMPkCTjA6FswxaYefNwG6b2jwaSW+FYWLnDpCeQwu3gxe7wU2YRkXr8c3i5SmSyuspMdqfcTCyid5M/ahIoKGJqPbXR1zD/UI97iEgJaqzSDqbdAofqpVHlA1aA5IIL/GuqXVLCvCMsfPv1gSOBKhHIwfZCrlsdSJAtnSpe3HAgA/6BlvA/P
 nke7/MXZ
 Ci8ADX7WBvHQ/EO3dTVSCtT7UgwggYqULn0EcaX4OcMzyooR+4OgxjwHXGE7GRuISuEcxCAISb/BYhMJD9VwGsSAZiwsz9/LudKXlAB+R87uXlxCu1Koq4pqV1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 04:54:01PM -0500, Zi Yan wrote:
> On 4 Mar 2026, at 16:48, Balbir Singh wrote:
> 
> > On 3/5/26 02:17, Zi Yan wrote:
> >> On 4 Mar 2026, at 7:01, Usama Arif wrote:
> >>
> >>> From: Usama Arif <usama.arif@linux.dev>
> >>>
> >>> migrate_vma_split_unmapped_folio() takes an extra reference via
> >>> folio_get() before calling folio_split_unmapped().  On success, the
> >>> split consumes this reference: __folio_freeze_and_split_unmapped()
> >>> expects the +1 in its folio_ref_freeze() check, and distributes it
> >>> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
> >>> are later balanced by folio_put() calls in __migrate_device_finalize().
> >>>
> >>> If folio_split_unmapped() fails (e.g., unexpected pinning returns
> >>> -EAGAIN), the function returns without calling folio_put().  The extra
> >>> reference is never released.
> >>>
> >>> Add the missing folio_put() on the error path.
> >>>
> >>> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migration")
> >>> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
> >>> Reported-by: Nico Pache <npache@redhat.com>
> >>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >>> ---
> >>>  mm/migrate_device.c | 4 +++-
> >>>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> >>> index 0a8b31939640f..351ecd9065d13 100644
> >>> --- a/mm/migrate_device.c
> >>> +++ b/mm/migrate_device.c
> >>> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
> >>>  	folio_get(folio);
> >>>  	split_huge_pmd_address(migrate->vma, addr, true);
> >>>  	ret = folio_split_unmapped(folio, 0);
> >>> -	if (ret)
> >>> +	if (ret) {
> >>> +		folio_put(folio);
> >>>  		return ret;
> >>> +	}
> >>>  	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
> >>>  	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
> >>>  	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
> >>> -- 
> >>> 2.47.3
> >>
> >> Add Balbir, who wrote the code, to comment on this.
> >>
> >
> > Thanks Zi!
> >
> > Just wondering if there is a reproducer for the issue and how the fix was tested?
> > I expect migrate_vma_finalize() to be called for folios, even when split failed and
> > drop the lock.
> 
> Does migrate_vma_finalize() do folio_put() for failed-to-split folios?
> If so, how does it distinguish between split folios and failed-to-split folios?
> By comparing source and destination folio orders?
> 
> What we see from migrate_vma_split_unmapped_folio() is that
> it adds a refcount for all input folios, but only drops a refcount
> for the split folio. Isn’t it cause failed-to-split folios to have
> additional refcount?

I wonder if I’ve actually seen this bug. I’ve occasionally seen CPU page
faults hang forever spinning, which could be caused by the page’s
refcount accidentally being increased here. It’s quite difficult and
random to reproduce, so I don’t have a real analysis of what’s happening
in this case.

Matt

> 
> 
> Best Regards,
> Yan, Zi

