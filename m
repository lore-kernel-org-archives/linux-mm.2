Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C88F46C76
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 19:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0046B0005; Mon,  6 Apr 2026 15:11:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160B16B0088; Mon,  6 Apr 2026 15:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000DC6B0089; Mon,  6 Apr 2026 15:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2A386B0005
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:11:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77F2659577
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:11:43 +0000 (UTC)
X-FDA: 84629075286.23.AA97AF2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf02.hostedemail.com (Postfix) with ESMTP id D712680011
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:11:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ROdV1nPC;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf02.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775502700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iniYLQ+AY+oSfaum2VE93E/Oft7BWGHQ/rzsbcKKKs=;
	b=1bX1dXtJSK3TQdkqOAw/3tBmopFfsHlt8VIXAX4hHqg/MKubHrT0zyR3qkiUG4dsE2AmhS
	oqu7GqcyzbyaQVsQ2cjUymktNOfU/DsTNLQrNDT8/SHuyi0EXpFruQqp4Wc/n54RCL271g
	Ok/9oJdydN2P+CCA2WvBx38ThOeE2hA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775502700; a=rsa-sha256;
	cv=fail;
	b=ePJkhY9XRxAK1D4GhtwhhBzWs2WFbf+sZbaM0nhUe7CXM4SJh843/dNxe9BIZbqIpLahal
	MvWr7WdYiWQ5PcFakbAyuNkAxTC3HfczA7ibxihr3lDZrCHrCt7qluPvRMCrnr0xWJKJf9
	HWsP3o8Yg1jqmxghPRxijymKoQJVhfo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ROdV1nPC;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf02.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775502700; x=1807038700;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=1pc/LyeuDUMA//nI0GhJIg8LjxleMficc5uEJV007zg=;
  b=ROdV1nPCIp9AhxGHWqjmm/V8VNtfj3wQrgAQHluB7GY0zmnwNOVelrts
   0Gc4UOrEEtkRafnAg0KIKAauJP6+Mdye7a7ZgpgswswdCX4dwh4HJ7D99
   aeNj1LvH419+JSIbz1USbYwfWrte7l0XWORFuyIfD1+CON3YS8N3pFhlO
   223V54OeIIFVRMVviD9YPVFvILOo4n9w4gtXPsf3/BmSUEyq1CUZlWFoD
   5epeM6LagQv19Je5dohG6twipusirMUIjUEZThjXJjKhOak70oNLfZVL3
   9HhlQcdtAQDswb2m4cGNMQjR0HJhtJ8+7qIaZnB+WzHjcbLLtFVjUR1+1
   g==;
X-CSE-ConnectionGUID: pBX886X6RES4ZTuFDaiFkQ==
X-CSE-MsgGUID: wBbE2u0lTliQPwKM/CDT8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="76526636"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="76526636"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 12:11:38 -0700
X-CSE-ConnectionGUID: AIT3iP0sR5qdY02Uw+gp4g==
X-CSE-MsgGUID: FZggQcK9Qpiww8fW6e6R1Q==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 12:11:37 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 6 Apr 2026 12:11:36 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 6 Apr 2026 12:11:36 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.55) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 6 Apr 2026 12:11:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GPAmXgHpIoxiGKcEB43uRi/c0uRpLY2eD573beba2pQCoMnd0KN6Pe1tzdJgyt3wRu2uL90IORIOdwQLCvC0ctWtD71AtoFPCNNGHFZSU7mp4WBO91LuiAr7KHiBRbwRMQVJehIepC7+bSa4IrDKyM4zB22Ta8M7kG93UD9rnbhEvshS1j+Pef4EYMz1D3z0zCUhwQ+y3xIJjFjWFwXUZk0NGapCFpj72aJ+oFPTvVynoyVv1BdhJUUN/WAuPXf3PCrP/aXiFYMXnVfLOtiBe1DTOdXykx1EyWiuEilbytNunU8FkvCT9XG4WixRsACsVbl2ogpxUzDgB1jiBKJPFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1iniYLQ+AY+oSfaum2VE93E/Oft7BWGHQ/rzsbcKKKs=;
 b=mq0iWGqccbTcF1H9US5Y3yCP/qz4fLIer+HWhK7IMq+7jxNntkV4CScN29i+WVKysMewqs2UcERkjb6FFGrdvHEIpLz9OGh8YhvMUDiwDG7ODgzX4X8l5bZrN9/g7GiO5tRgm/ub4mmIbJXTGHokF+jvMLnLux3BYpwGsZYKeV0+14zGCtRCrR9pJXUDmXk17+H2wWdAKhYmOxG3iW2DnVU70FzYCM/L480XNaOSSz6amjwL3oHVhSIEnTTRFCG8fic6Kyjj4H/7wgOPZPy0HNR3oTKgkrXUiF/2p3yq+zv4Zd/kJrnVJw4yYFTgqVDOP4BdXX6cwL7r5EnqyZAZlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5)
 by PH8PR11MB7070.namprd11.prod.outlook.com (2603:10b6:510:216::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Mon, 6 Apr
 2026 19:11:34 +0000
Received: from BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::53c9:f6c2:ffa5:3cb5]) by BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::53c9:f6c2:ffa5:3cb5%7]) with mapi id 15.20.9769.016; Mon, 6 Apr 2026
 19:11:34 +0000
Date: Mon, 6 Apr 2026 12:11:28 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
CC: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	<intel-xe@lists.freedesktop.org>, Alistair Popple <apopple@nvidia.com>,
	"Ralph Campbell" <rcampbell@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	"Jason Gunthorpe" <jgg@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, John
 Hubbard <jhubbard@nvidia.com>, <linux-mm@kvack.org>,
	<dri-devel@lists.freedesktop.org>, <stable@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, David Hildenbrand <david@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Matthew
 Wilcox (Oracle)" <willy@infradead.org>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>
Subject: Re: [PATCH v5] mm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-ID: <adQFYAVGLqv6amZK@gsse-cloud1.jf.intel.com>
References: <20260210115653.92413-1-thomas.hellstrom@linux.intel.com>
 <adOqU0UDzpxvQuwA@lucifer>
 <adOtS_q1MuFOawGM@lucifer>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adOtS_q1MuFOawGM@lucifer>
X-ClientProxiedBy: SJ0PR03CA0226.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::21) To BL3PR11MB6508.namprd11.prod.outlook.com
 (2603:10b6:208:38f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR11MB6508:EE_|PH8PR11MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 38088216-8658-4266-fdc7-08de9410517b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: r/q7jeO0Z7VWORa+islw3wbJFw8SHFBvqijFgo+7LeO8+phf8/0/D2OJF3VQNU+LnVsbLnl+ylMaLxlMeEywKYs8c+lsrZvA9ih83GYg2lhD4l7zI1zzKsCABNEx9UFwQZk4zEpJ1TIZmoBH99BYRP0ee4W8/YnSLob3pF7POG3TQVvK32IkXz7CUHELC3ETUP9lKfH3GS3tk58lFv1Kp7DxNI09FrLh49qRM2tZwqMPY7B+ZZDfxDzwhLQbcEJL4gRKujwPiBbO3I8byXk4gfKuv1OdUfyGrddydB5JkJd3Ex13L7SzDcENfLr+0HJk2YwfIRO6GWBPUe/D9EoonFESnhrs+OtPFQeaBUOA4Jtk3qAKG6AI67H8bSnBYb5XZAjJKLCMZFg5Cw8H+pJcjpoMBdcl/7pFf6Pqa6RZPkAAdRBIYDU3DVLp1cfQXOLDrAjYHBStQVFAS4yiyLbZbzeKG3RCjpny+m8gnoMyxRP/hGuqo6NJUiUK6tedDH8jDDZYVxi8td68RZkGhphUyjwuYJQOHwsN3qHt9vM7FsBk0/r4OYl/02BXVtt06uVs28XRsWqCTyLfLdrIW3tH4nDSxxiMh3mpIabdzV4FA/+4vDEEaGeov+INnYCc5jWt9v5sOplbxYpeMThdwsqvZBiOq2C1+N4S2ECc/gxzjaZBu5Ga3EZmhKm6wJhVHEfO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR11MB6508.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUZEa0VBN1VLbHFXWmgrblRXNkJnZms3RE5TZU1jdnpjVGd2STdqcHFxVVVm?=
 =?utf-8?B?ODIzeTJEeG5hL0VIc0Q5RkUwQk0vYjZKNkNGa3VWQk9YeGdXZnQwWWkzdmlZ?=
 =?utf-8?B?anhnNVdJazNaQlNZQVd3bXBJR3E1d1FZSHJGZXlmUWVqdTRXZGMzdVdFV0FK?=
 =?utf-8?B?UHFUSXNVWFdNSU1KRjBTM0lFeFpmNHJtNktQd1kzdlhSNXF6OGwrSGNPaHow?=
 =?utf-8?B?MEdwUDFxMnRYQXZoWGlYc2pzczdHZ2JSMGpPWWZWQjg3bmhwVHhzeUZ4QTJo?=
 =?utf-8?B?a3BPUnBubVhEaEhUZ1h4VjQxOE51NjRiUUtrUDUraTVFVWJWSTJXNnF2WkRT?=
 =?utf-8?B?TGNDSE10bWt4M3owN1cxUjNISXdxdXZJcXBUbkh3cU9obmpUMit2SUpRdUVZ?=
 =?utf-8?B?OFBFNkttTHZuUjhDQnJ6SWMwbUsrRWdEaGdKTUxFUDdYUmw5ZTFiY0M3SGl3?=
 =?utf-8?B?OUc5SlUxbWpMVFNkK1ZmK2NOdzBUWk1tdHF2amY1QkE5V1JTcDNNSFRMZjJi?=
 =?utf-8?B?WnUyYlFLVDlWMHN3Wm8zMXY3VlJIbndjdnJIL29SU2ZlMVd4ODkxamovVVda?=
 =?utf-8?B?WHJFazdyMVN6N21FZEdtWVNTL2EzVHVTZnFZemZGRCtwbVZDYmpLL08vTlFv?=
 =?utf-8?B?VjRYc3N1TVVoQWRHYlhDT1U0T1luVjZqeVFGUUxEL0hqR3BEL3cyMkZrNTBw?=
 =?utf-8?B?SE15bzBoekFSVXhGa0pJYUZpSlBna2I5K0RSVjhKeStORmoyaFlxWlBPQ1A1?=
 =?utf-8?B?OENFbG8wQWJrZVRZU2Y0MmUrVlM2NjBtT0pBeW1HWkdIbjBlcFYvblRpYTlL?=
 =?utf-8?B?QTNpYnZOdlV5MjNQYTJJU3loM0hxcHpXR0xhZVY0UlBZK1dHRlNYWUNodTJ6?=
 =?utf-8?B?RkJzRnVDWFEzUVFWUlBuaUtMcVpQeGt5MG4xVVJOY3NjZC9FdnB4V0Z3RnRZ?=
 =?utf-8?B?NG5CdXlHTXhoTlhOZVVFeHVlRFdCUWsxeWJ2Mm9HNisxR3Q0cjFGL1JQZmZ2?=
 =?utf-8?B?RTdkM0tGc0FLTUdaUUozUWd0MmMvdGhWYkxGMnNnNHV2MEt0OWNwL3BsZzlw?=
 =?utf-8?B?Y2lmT3VCVEdPY0dDMVBsQ2Z2QUFoS3hVUFYvV0Y5T1VOSnpiYzNRV1FNbzI1?=
 =?utf-8?B?YVhOeHZBK1l3TDFHRFNqVXZMSFY2WU90TExSMWJJdE85Zks5ZEZLdWdnZnhy?=
 =?utf-8?B?RzVoU29ZWHhzQ0ErMjBxOEl6ZjZ5cFIwUVJ0elVKMVFPbWl6cUw5Mk1KNjlj?=
 =?utf-8?B?QmJHenVUVjAwYStBQmpLU0hScG0vaCtVdkhDckFwTGQ4MjZ3aTc5U2poUXM4?=
 =?utf-8?B?VDlhaXlhVzZHeWEzQXNQUE1BbWhRMVUyS0FGNjZ2U1dxLzNwYjZ0bEg1MkFs?=
 =?utf-8?B?RDZKMi9IaUQzdnNyUzBmMVpZWHUrL1hQMkVxeXNhZUo0Zmw1ZVQ4Qkw3TXdn?=
 =?utf-8?B?eSs4MHpHQlhEelMveTRDV0c2Q3BwN0FvaGJVaWJNbUVSc0pSSXc2Vi9USG9B?=
 =?utf-8?B?ZmdlMFhDOTFGbmtiUnZLRjlwOU9RZVdpR0k1S05jR283N1M3RmROcGhjWGVh?=
 =?utf-8?B?RUZWNXlnYzcxYW1GNU1HTW1qclFTRVhZdTV0WkdWUFdXbm5YbkRiUWRqOHNP?=
 =?utf-8?B?MDJyZ1d3dVloNkthSTVMWFFXQlVyVERTWjlsWWgvTU5SeGhQZVBQUGVkVGpl?=
 =?utf-8?B?eHphTTZEdndEWUplQ0x6cW1yQjlaa1VDQTB6d05kYVg5R2hycEdqWkFhQSt3?=
 =?utf-8?B?dlVmTUtEWHRidy9udEMrWEVFMkhGZU5IL29GSDlYRkJGdWZ1UzRrdEhWMlNJ?=
 =?utf-8?B?d056Uk1wSGV3dmhYMzNUUlYyelJRZWNuZVpobzlDVEdkZ1IvQXJyWUxBaVJx?=
 =?utf-8?B?bUNlbllicGdSc0FTRmFSSklKZGJNa3ZTamlEL0lFRldDM3JEWktmYlRHUGVR?=
 =?utf-8?B?WGpsN0hHMlZBY1U4VlAzMENpMGVHK2FFZC9tTmdMY20rMnM2OFl3Wmh1M1ZQ?=
 =?utf-8?B?QWFpaDU4d0ZiTmJmMldFU2RzeGhpR1lSbWY0clhWb1JhQmJhL3ZOOUdYcTMv?=
 =?utf-8?B?ZDkxdkR6MDNsaFZtb082MFRlT2wvbXlVc1pFZ0wrNjFlVVd1akVOYmgxRVE2?=
 =?utf-8?B?MGFpSXBzYkl1a3pKZ1N4ZHV4bFF6NVFkWC9lZ1lQaXlXWGFkaHpNMWRsWlpL?=
 =?utf-8?B?Vk1IUGIwSTZianpyVmNEOUxIY1VEaDVLVTRzb3dUdENXSTNWdzR1WkhORExS?=
 =?utf-8?B?bC9iek5EalBxOHcxNlNxNzhCaWhDMFNkOU90M2tnNWM5eDdKb3Bna0FSc0hU?=
 =?utf-8?B?TmwvamkycEthZGtGUjNoRFJQK2hraG4xcEJMVXAxam5kQzlweUR4cmFocGZ6?=
 =?utf-8?Q?JIh28MyYhSmu3RUQ=3D?=
X-Exchange-RoutingPolicyChecked: ojGWN2ELAMiKlphVvCH4Yuq7q+yK6GNjiJl6jx3rq7UC1NCqWRjA7FNM9AIcoKPI2ZTFAjQ9WwJc3/vPSvYPzX2SFsl0Q8NsLpSEmJuHGGPjZywEyAY0qGdurB1hcXdzbTk1AaaEnuTZ6gi9/9mOi0h1SrH8iEvzyNafg/NUCn/zOwjNVjHBfNGPfX1ca9jAxzpkOOeMOqQ28u4tiI3sw5x1hsj0WHhMNpC+mAiUcc2Sz7CtFKPCMZ4CU3qsBS8sAgpA7KwhR97j1VBewr7lMp0mH0Wnzgzs2NQ9Uuv9ubg4EQ4xJS9szsIVEPIYA4zr5W930ODn25zybh+17k65qQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 38088216-8658-4266-fdc7-08de9410517b
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6508.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2026 19:11:34.1939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yw3Mh7YtmyJJvvmzE1kfei6xjgVHd6Dtzt+nfKzMzPJh1aSx0IasSiuzgumxZTvzmXzLhUIiwIvHKy5m9ahU8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7070
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Stat-Signature: 3btpd5d8kf7jomem3refmz1jxxrqop5m
X-Rspamd-Queue-Id: D712680011
X-Rspam-User: 
X-HE-Tag: 1775502699-168618
X-HE-Meta: U2FsdGVkX1++Ok0t+vAvB9GKUFynESIAx45/wkdK4GQGPcCzv5O76ZGzwIr6M9L4GhyifLJGEWQ8lNL03L0cEen4UWMQVxIPkDE1hti5j9jX4CDElmgq7ySBZuupT1G5HEw7RSl9PjOt7DVQfhio1ssaVSFYT+obLPLdQ2ZJ3Fm0eg4BaAemTT1esB+VG/VRdW+/vhiZ3kjNv3DObI43uKOsOazsnifZ93mD+5dppx3TlQYRdS2l1NyWVFRcK8C83NfqHrTViqdTosr6bLrnAkDGxwz6opOK6k0xGjnjguiLomOngSVmMFOPKGfraVMPm33rgrrb/aY0UFrCBUg8pdMMRkhbhWUsDT2GEGqAsmVzQ/lsFIhslGFA51ch5wBWqBdPKUuJ7o8hu5OFJ7BIppGwPummkF5Y6Yo4ahBmrnYBrBWYa3wmjPQkvdhttP4XRs8GtsYH3TVnVPt2ozpFwkqF+4EIosq6s+Hsdm5yjJ3cOmbdS4AWARVC3E8SMjIJwsfVwBtruN+7ItPPF9f8TWOHcsVii0O0htZV8fnrqghyRryGiAiKYKFPe1qAh8wWAkcH1+UkD8qgPq6EYP6Xzan4jXIwLzL9BPYE+fCQ6f+lXecfwQy3MWkJFyQpVmrxW0lzDKepix94pIvRIgGeXLcsSLNfoU64BUY2sYc3M3+VwqwyS1lyfTXhfaGGVcrME1LiyI+fEaa9fdFc0IKHWEXsQXc/TdOTGKYV+qHgaZG6WiwE1J4WPVPhyyvj3Km33RbA6/ydz0emyrjTdxgm2Y84cv7MpGJ/Atp7y4ryLf11F3w6M+u56SnaQSf1sLEQTbqzkDDqHKQ//IkBusclaJyK7eOGm9QCtGYw2KGCjl4xIbtsB5v4VRDL/F+u6sZCNNn6BSNLEjQX0Pj7F8CT3N0qf/mu5zCSjy4D+8tJkcqHCNMZfKJZ0hjb8KPai6jOmlZ2WV0MKHsfOmRiaoO
 e11XMcJH
 CErd7GkfnHGCBTaM41XL6SZL9yxwHgIE8iLuSoe4VamTooNBtO1qG61dWh0bkbhpoFlkAixWc6R3PlT6xlZZn5QZ3aKYGXEHTkQRL6RH6Ux+vGqslJDo+CKU9PJqbTbJ/kDnn+dODT1VzlyuBNdQJuJ4lLdIK60nXRkc+zQe2P1TSl2F6TMrVTtYjpVYsr/IqUZ/KoQCYCwpvLyRXk1rH5DYdKLW0IpUopT0AxAG9Wpme3Jq2BAaFqonOca+9kj5kK7NvR9hr/BBoRCC8wkPmCXINFa/EWs3SVIgVjqO4T7Xek14k3Yue+eORGrBwnnwIiZGjinOLYNa0CovO7eiTvmiSyhCucyu2qzBtS0oeS1iw9L7BXOH2MoTrSrgdtPieJ67EMTW9uofq4d1v0kDvkI1WZJEVJe+lOdmftwe4hUS9hxD6a4i/RV6esCJHf68S9CpNaaCt6GphoxHhtvcXcmyRQgYxVzMBitLWp9nLQ4kneMge1htBQaqauUXwH8nmIGLlAVBCj8CbX9ktPGum8JGrxGJ5h9JtEt9opW4c8LfqTQGqbULD1NVJDwEJh+LO2P+lgfdl7tUdJ55U7YNqv283T8wiT3Cgqrfbo2LvOTfL6Cf7cPF0L5Llx3m1ImE8+B/hr/iMWCchKM1Z6PKixbEoeUnWDmlyPq6CK/wMrPiZQEYAMG8XsEMl/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 06, 2026 at 01:56:49PM +0100, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Apr 06, 2026 at 01:54:13PM +0100, Lorenzo Stoakes (Oracle) wrote:
> > I see John gave a tag (and he's great so that gives me confidence here),
> > but we should really follow the procedure on this properly.
> 
> Oh and just noticed Alastair also :) so that adds further confidence, so this is
> really a point about cc/M signoff requirement going forwards.

+1.

Andrew did ACK this via DRM here [1].

When we take external subsystem patches through DRM, our merge script
requires ACKs from an external maintainer, as determined by
get_maintainers.pl.

I’m not sure what happened here, but it looks like Andrew’s ACK was lost
on the patch, and somehow our merge tool allowed it to go in regardless.
We will be more diligent going forward.

Matt

[1] https://patchwork.freedesktop.org/patch/703183/?series=161082&rev=3#comment_1294670

> 
> Thanks, Lorenzo

