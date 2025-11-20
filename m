Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F26CF58FB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 03:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1FD6B008C; Wed, 19 Nov 2025 22:15:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891FB6B0092; Wed, 19 Nov 2025 22:15:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7329B6B0095; Wed, 19 Nov 2025 22:15:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C65E6B008C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:15:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D66512FD9F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:15:14 +0000 (UTC)
X-FDA: 84129519348.29.801E585
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf21.hostedemail.com (Postfix) with ESMTP id EB0091C0007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:15:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IMwG3aJG;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763608510; a=rsa-sha256;
	cv=fail;
	b=nsOUYPNCPJemUHR4cFOgdv+2ZjyzoRZ1IEE7KYx5/cGGQcn1yCvaMBzjk3hP46aegjzJno
	mKxlq2N1EQUxvAeQc8CrmILmwKUhWEqfhew95ynnQDNoyx28oYozSvXEAN/DCw+rUo8UFi
	Xh7buniSe7tbQKpd5usOLO1JNk6yYns=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IMwG3aJG;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763608510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIZbKyRP8iNACyfWCtffQJnInLTYnBWmOCDIwfR3Yj4=;
	b=Vrgz0VvDbFX2BqIgiIJr+ynvAhkUwtDBGP7SHTA8CzvT7rECjXtHxCr8lxu5B/NyIJCZ2R
	AG2t200q8Ks0/0lLGSA9yGxp8KSfA7esRhDpCar6Nn1IDfJ0z6s+IPac9IgjTmQB5b+2Y7
	ixr2JTQvE+I3EOrLNPdQ6tPrHjUEG80=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763608510; x=1795144510;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Vh6ZmFzN8ZzGyN2icu9njjlV2c4YDe6x0frJPyz80wA=;
  b=IMwG3aJGtx1KeRxu1lJE/uuhI39jCqPriuOlc2r0tCWWkfl0r2jzbRBe
   lYX7BUJDmX6bbdwoB9Ha3XyNNYKGER/aguElo5zEbnkkzbDFlONh+Jm8U
   9EQAi5Cg3EA+36L+kMHUrmsGB/k4QD6As8N482pX4pfy07ETEgBeDTmRC
   rJ+F8phJcTdgiIRPf1ZbWfyeWnHUHcFeOvut8oF+2mDDHg5GyznvSYt8u
   v824dyTWIEQYuNajFI14DJMO/MME/Mq8RzsMORf1cCp+pNcO+BLQwrawF
   lHEfvvs0qmftyer75hubJ2u2CiZd1TSxNSiB2kXCsstfSOaGD1aeRAeMO
   w==;
X-CSE-ConnectionGUID: H0wvMlh0RwWLlDCudzwDqA==
X-CSE-MsgGUID: MZa+6wMdRFu8XrKrlYtvTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65605523"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65605523"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 19:15:09 -0800
X-CSE-ConnectionGUID: NliNd+wARpms4Ddv/dVPXg==
X-CSE-MsgGUID: qNDHwIwjSH2a3/5A6Ag/8w==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 19:15:08 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 19:15:07 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 19 Nov 2025 19:15:07 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.9) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 19:15:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xQVrzW/g3N3bWmgvsl6/nIQweqIL8bA0o9RPB0aYyLcDxO8/o7rN6idhuE42mk+1fsJoHHRh2kNBo2CGsKpNQBTPGN0VqedxfcfxHzV8cyXehPlok5JRt6AE1Qm9e8N4koQ9U+DfM9+TpS2Pqt78iGghouFQNHuRpUu3JY9j5N5d6nGbbhp6q08wjIa7skBuvDq+bJvG2UpxdQOAVVlgc3KuWHYKE6H+Dw9CjVLGb83JektRUguRHW6TGSpjkPu+YUwEakJa50UNUpNxrAmDOGLGCsqvqSDvEe4SryAlyH6nlXMkl4QsrlaV0/fEQHaE8Jz7GxOZVHWKMPBlRAg3Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIZbKyRP8iNACyfWCtffQJnInLTYnBWmOCDIwfR3Yj4=;
 b=wxS/348843bwYyucU+hbNjA2CKD8NduJgK+4wd5vW5SlLWouJVluwqZqI9TToa2jfx7zDjW3LPJbhI+eK2hQFkCltqXCM1LJOpVbCXyUblOFFg+YCqVbRTyOaLDloA4hqRdrDODQp05Umm15NtRG6ifhSjS6acAOi2USzR+And98f/XV+SXOKflZdqK9ZDxZWPmfRkUzJN2d1ZUy5uiPfJ4jno0Vjun/gtV7kLEIOgHl58CnHn+ka5nDaYHaIvSDmd2q49PxYMkB+ZBCdm+pPVbjYFBoy1I6LJbRU8c0E4nCwVEg5Lr32xnqAOVn2S65nuhULeoh6Stg9kPQU2QDDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA3PR11MB7628.namprd11.prod.outlook.com (2603:10b6:806:312::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 03:15:05 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%3]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 03:15:05 +0000
Date: Wed, 19 Nov 2025 19:15:02 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>, <linux-mm@kvack.org>, David Hildenbrand
	<david@redhat.com>, Zi Yan <ziy@nvidia.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, "Oscar
 Salvador" <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich
	<dakr@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>, Mika
 =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>, Francois Dugast
	<francois.dugast@intel.com>
Subject: Re: [v7 00/16] mm: support device-private THP
Message-ID: <aR6HtvxhmVxUvd+h@lstrano-desk.jf.intel.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251008201740.d9507f4807a73058d4da23a8@linux-foundation.org>
 <a5992f11-5841-4bbf-b190-b5df41b68b0c@nvidia.com>
 <aOePfeoDuRW+prFq@lstrano-desk.jf.intel.com>
 <20251111154326.bc48466a6962fbbffd8ebdd0@linux-foundation.org>
 <7a0f2704-80b5-4cbd-8f3b-ac03692eefd3@nvidia.com>
 <aR5/uUFboeeSwN0z@lstrano-desk.jf.intel.com>
 <7ecb3faa-8bc7-4eb1-9342-404a9ff52b97@nvidia.com>
 <24d8d39b-5ebe-4f29-93ff-3f7ca2a9b1cc@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24d8d39b-5ebe-4f29-93ff-3f7ca2a9b1cc@nvidia.com>
X-ClientProxiedBy: BYAPR08CA0005.namprd08.prod.outlook.com
 (2603:10b6:a03:100::18) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA3PR11MB7628:EE_
X-MS-Office365-Filtering-Correlation-Id: 88982e39-b5d0-4f27-e278-08de27e3003a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bjRXZWZ6RTc4YkJRYld6dDgzaU9BeFJURmJ4SkFlNE5QcWs1NktqQVVwcjE1?=
 =?utf-8?B?T1dsTUttcmdpVUZ2Q3VYQmFWZGU2aXRVTkNsYWF4dGRTdlBEZ1phTFZWRVly?=
 =?utf-8?B?ai9uMis5MlN4bkhnaTVYY0lvTUJPdjJ2L3pLK2wwV2ZtTnU3a0dNSmRUTHBo?=
 =?utf-8?B?bTBrTWl2Sko1NTk1V3hRbWZpaTdLNmFUNXJhd2FJL3pLZDdIR0taVGlnenFE?=
 =?utf-8?B?NzVqWVZkS240b3plY0hNQWZxRmJMREJyeStBTkpHc3BJQ1ZxU2RjcjVFa29P?=
 =?utf-8?B?MVdJM2MxTlNRVWlSbk5qUGxEY0ZsUHl5bjJ4bm1DYmZiT09kb01OOXRZYWV3?=
 =?utf-8?B?NmpnYVl0Q1p0c3pHWE1QNVpna0pFQy9XcnBXNzhzMlFZNnYyQWtYb3R1bjVF?=
 =?utf-8?B?cndsZ0NnRlhLOUk0ck12ZmpjM1hRNW5sbnNFMmJHYklrU3R2eldvbzcrUXZN?=
 =?utf-8?B?RFIwYUNjTlFtL2MvanFXUENiUWd5T29MZFpqN3lJTkxXMG1vVzJWMTVPdTRS?=
 =?utf-8?B?NU12eTh5QXpOL01GejZOQ0JhQ0dQUDNuSmszYi9XK2JQVXljcXNnYWhvcE90?=
 =?utf-8?B?bDArT0VFMWtLV2J0NDRQVjFkUDJrMkpzcjI5d0NRMW5SeWZDZ0V3WVdtSDc5?=
 =?utf-8?B?RldLSlRFSFB4a1IzN2ZHVU9zaiszTHdTMGJoVFlLd2RVVFAzR0VsN20vK0Jm?=
 =?utf-8?B?OUpFY2YvVUl0UXdVQno3U01rNkVzTDVQWW5WbEIyT2MxcDFVaVFQWkJEKzcz?=
 =?utf-8?B?SWw5K05IRkUyMTBoWXNVenc3L1ZyajBaUk1ZZ3k4aHlIQ29ab1BzNEtZczJW?=
 =?utf-8?B?QklHVjd5VFR0MjZwQzBxL3F6NXg2K2xwaUdycTZLSVJyQkJwRExFTnlOc0NM?=
 =?utf-8?B?V01hZW5rVG1uek5rVjk2K2s5T0tkanVERFYxbzRYVWIvQThGelpKNng4YUFa?=
 =?utf-8?B?bWJadlhSUEhuUDlaY1VwamlqZjVTdXV0Mko5aDdEcFJlLzBkVDVlakRwM3pF?=
 =?utf-8?B?RHQzZkxrYldMV0Z0K3lJU1E3Rkl3czJhUkh5NTc3Rm5KKzNxM3REczdtZkI3?=
 =?utf-8?B?bEY4T05MejVBWHpsWHpSVFpHL3cxUm5vQ2FPdEYrR21vdExOZkhxVEZ1RGlM?=
 =?utf-8?B?ZEVsa0pySyt4K0plUFBzcmFhbVJraEJudGNMblBKRUFLS25RbUFxUC9qc1lx?=
 =?utf-8?B?MEVlSnNWSUpCVnpsRnhsbEcrbWR1aHN3VDk4cUsxelhJbkx0MHZKa21Qd2sw?=
 =?utf-8?B?TW5XdE1pb2Y1ZlVkTmpLNDJZZmc4WW9INzdTQzRWaExqNkNqQkxGODZKMC9y?=
 =?utf-8?B?YWdtVHcyVG1YSEU2R0JUNzBPVkRhc0MrRGxvTk9manRMSWZFL1FDdlhDMFJY?=
 =?utf-8?B?RHRITlA3UzhrdmpaVThNZk9OeG9zVmxMUkNjTWhRaWg3ZXVmdXRNeFBKUEhD?=
 =?utf-8?B?aEwzSUxIbWMreUowWEtIYnpCZDFTdWU2dFAxOE9uQklDcFlyeE9MMlNRNkhi?=
 =?utf-8?B?WE00UEw4ZjZtR2xvWVFqbFBGSVEyVkJsZUhKMnh4MDVETzJDazJBc05xRS9z?=
 =?utf-8?B?azVIRWtMUEZHMEo2OHhLd3pnT2d1YjUzbFlvOVlJcEttZC9vakxtK0crQlZP?=
 =?utf-8?B?cmZCNG5sODRLajVld1hlTU9xMTFXSW4xUG5hbWsvR3RwYVI1Mjh5TXdLYXVI?=
 =?utf-8?B?RHg1SUxDYkZpdE8wMlU1RHdhN1hwMzB0VkhVQllFMUtrdFZHcGlUZVlxZGZC?=
 =?utf-8?B?TjVNSUEvbWppSHVubnc2Mmo4MHFYRWFTQ05ZU0dTRHFTZkp3UzQ1SUpTVk1Y?=
 =?utf-8?B?bWFjNVgzTzBTMStPSnl4alA0NEJNQkdobWFhWjc3WVdMbXpMM1FHdCsvWnc5?=
 =?utf-8?B?dExVNWgwWlZpakFkTCs4emkrTHEzNzhiT3B6TmlrUUhmTkw4K1JjNDg4VGNo?=
 =?utf-8?B?RWZhaHBVSXhSSk4rNjJYWGlqY1FiTHVuUkJVaFFEZEk1UE5ZdUI2NS9ZZVNq?=
 =?utf-8?B?UDg5UHdWSEtRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXZnc1A3eG5KM3dBbnlEajZndENOSlFMaEZsZlZ1Nk1yR2VJck0yRk5lbEpt?=
 =?utf-8?B?OHpTSHBGYzV3UUxLV2dQZmdLb3U0UGo5Nkp1L2hiRHh1WUJRbk13VVFFU2NQ?=
 =?utf-8?B?QU9QenRScEIrQUM3SEhrTENabk9lVkZMbTNpbHg4VmZvV05LNXdmYk9Ed0RL?=
 =?utf-8?B?dUpqK21ESnV1bHp3L2w3bThJNDcxOHN6ak1seTIvYmVKL0M5ay9VUk12V1Rt?=
 =?utf-8?B?V3FMZC9SUjViVDhOSm1BZWhOdTRTNHNkaU1pUEkyN3g4cTJBb3BiM3VMRlc4?=
 =?utf-8?B?djk1UXRxaXJxYlhwSlB0UEw0TWhuSUVXMEQ5ZnVmVmhyb1c4VXB3VjVaSThT?=
 =?utf-8?B?OTlSbldKcGhXa2Z3YVFqQ3BTdFVLSkVsZEtKcklpb1hWTHRmWVFqTjk1MnB5?=
 =?utf-8?B?UTgydG9SZjJ0azRodEh6OTNoOW51b1ZZMW1sU3hnQXcwcmRmMDBOQ0dtNVJq?=
 =?utf-8?B?UHcrRXQvVjlJTkdnUzdBYW45d25zUnRmQ0dITE9iYTNaUlFmeU1ua2IyY0VY?=
 =?utf-8?B?c3RJeEtjSUcyZTRYK3Q5SlZsSWozZGRoYk53TE41a1Uxb2U4b1BlRGM5QVpZ?=
 =?utf-8?B?aVdWL0dlUjRkZjJpWG9iV0dpY1VHV0xSTnJaRk9UQndOelQrUi96YnVScnJH?=
 =?utf-8?B?ZXJaL09WQ1M4b0lIZWtwY0I5cjJKUjNTanhKdkVWZXlGNkdUcFlTR3FLTG5z?=
 =?utf-8?B?WGRMeUp5UVpDbHlIeklFYVFaUzY1Q3I5ZHRHbVFxa1ZWOFZTQTVuanR2SHVW?=
 =?utf-8?B?OUNCUG05dE4ya3Njb29UbUFHN0tYd08xaHlYNU85end4bG15K0hUcENnUGEw?=
 =?utf-8?B?M3Y5cTBlZG0vTmxWMW9EdDFsS08wVU1SYnJCUktteU9WdFJseEwzK3Bwb2JG?=
 =?utf-8?B?N1JRSjZtRVAwT0FvQUFVcXBGUEV4Q3ZGVzNCMzQyYlJpYXhMSXlHeHZhaDFz?=
 =?utf-8?B?LzNIM3JWVE0wcit1RksrM0w1RmszT2FFN3N0ODVNY01Ua2hNeEFFMTNwbnFR?=
 =?utf-8?B?MERpY3lRTzJMeDBjdUVnNGF6UEFkL0R2ek5CVm9ZQ2k4cW44cFdlUmtHNHBn?=
 =?utf-8?B?cm5JWS81blZtcFRCQmxvK0ZiZ1QzN0ZHZTFTaStVcVJhRU12SzdtNFhEdW9w?=
 =?utf-8?B?RWpIeVdqeGtmVloyMHpjYmdxRlZOdVkwaC9XTEg0RlBSRG5ZeThYQUQ4cExi?=
 =?utf-8?B?akFlYzNQTFJ4RjV2WVg1MTRBc2I0NFJiREl5aFZJVnZpNG9JZitjcU5QemlF?=
 =?utf-8?B?Q3ZPM1FDazFSdGNBalM3cTBpTVJZOW5QdC9ySEVNdWxPcHQraUNFTVdOTmRV?=
 =?utf-8?B?QXN5a0IxMmxpTjBXbzkzMTZUd3BXQlROa0pzRDBsNUJHWmZSZFpPVGZ1VTJl?=
 =?utf-8?B?ZGFETE43VituMnFwZlJyc2lmVXhvOWlwbTBvRUhtTjBFUVZtanEvYkNPOUVu?=
 =?utf-8?B?NDlIYzRzTDhJTUZGaGZzeUNVQTBKYTQ5bjZXeDBhT1lDUFA5ZUJQY0UzaktK?=
 =?utf-8?B?REhqNjJJQWVLeDNFT2NqaFh6V1lwMWNXNWg5UHpobU90Wk9vMnBNWFpPRWNL?=
 =?utf-8?B?NThTSWp3THJGMkYxOHhkTkV6bTVuU1dRdjU5dTNjVENIWGNiZWY1V2xmRDNS?=
 =?utf-8?B?SENDaHVCdEcyWWFaSm1yY05oN0lkZlF2cUNwZXR4Vm1RajdDTlhybGI3aUZq?=
 =?utf-8?B?ekYzU2d5cFEyQW0wMFlFaEMxVU90OVBOS2xFSmxiRjIvK01rT1NpMHhnTkgy?=
 =?utf-8?B?WG9LbGNUNVVXUWZwNGJzdXVZUUVhRnR1MFNsaEZ6RE1LZytUbXNXRXZMY3BV?=
 =?utf-8?B?Z3doWWw3cURZR0hMMUNrZ0s2aU9IOUI5aVRQK1hkamlsRjg2SVRObDFtY3Ax?=
 =?utf-8?B?aTN3UENwa0tLU0x0VnVHb0lEL1FFZ0RKRnFwNFgyVTcyRkl5UDBIUHorMTZk?=
 =?utf-8?B?NEJ3UHA3dzkrbzBxUHNEQ3hwVERJTVpCNUU5RjVNMmY4MUIrbllzbDNFVy9C?=
 =?utf-8?B?VjMxOEpMWEJZUU9jU25VQ3NoRDdZQVVhUXBIZ1gwRTl5OWYyT1REY0xjUC9y?=
 =?utf-8?B?NUFGU2s4eStIR1JKVnJjREFSN0VURWRkeXdoTXc5QnhoN2p4ZU5EMHdQcXNM?=
 =?utf-8?B?cUhkRkliYUh2M2p6Q3NrUVdVUWdRei81V3pqa2dVejdjckRXbUlrdXBLQm1T?=
 =?utf-8?B?M1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88982e39-b5d0-4f27-e278-08de27e3003a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 03:15:04.9894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OXJPAgQxx2VM78HLGL3AJ/qJJMT0lOaMaqUqVp/NgWg+Ms9DGhFdRfk2vPZnVS1+VF12NV69YtVii0QVyX50YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7628
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB0091C0007
X-Stat-Signature: qt95zhfu9gjt4x67knbder9xp91dxsn1
X-HE-Tag: 1763608509-492015
X-HE-Meta: U2FsdGVkX1+j4ondJUX5m/l0ltgps/r/Mo220N722Lu+D4Kz0IiiLypZpZjwBgv70avO5JbH4zA2ShVvzGLZSAUy7e8gnnEoK/1Ph6WxP0rMMIkTlKVgGu8Yy7s2ZfKGf5FUEQtQzfDGgrATkYnpNJYdKF9FgUrzjuoeEbiF4+A4TJChRBDQGlTnzLubGyFJCrOlKw7hHk6I6AwIi2azLXCFxokyQibh3kLNScrOOl262CihCGtjyUZGgjtgXAw2poh1lLScOK2Id0HCZRFhftnk/xw0R7bnKlgj/Y9VzqlpRXiZxUHI0xL/Orc7qsukfqYJhZ6mFFEmgJrhbOHuctbiF2BK76jyur98c8yNNiu9TfjJducYe6tEz/ejbCQXDWfFBeMazw9dkagaLUCLpegwdiGEye2fdk2o0viyLgqaeh0AQkq/7v2QVJYv53b/yiXaCZqTAEgZhCGoJd8y6vpBcHo+eqmDgW63akjt4nDdQPgxGQBe6H2LKKdcBUNrkaGJtYSI7cbK1ERMEVHXrZ636L3jWhin1mj4jTO9LhUzJIREG2YOB6CDovr9ZyqBQbL7ZN3IKuzbvYWowPh6vDBZD05g9Bhyf7q4b5xVXzXIJ+1+Ksl//NLzDOgRMDULe8E8Pnq25PUcuBUrrB/IWfspwni+EiEP9Vu+RZcMtwGrvEpiPcqmCqOrgblEyRK+JkU9JC9M6CPGkq8yI/WPT1MTHUWQOMpnoaDEya4lIPNkPmBybDv9tzH7OHu0OzzX2YAreY6g0fxd0BtYPxpBu6kU2oPbrD/r/4ZhUrPk8BmE7ZtIFXZnXcVXQrRjjaF87OOwV25ZtcnOc1Iwi8mlwKuKuq6DzS56+S8JkzblrIdHGjaXWegeVJeUJKQsBXZu8+RZDVvvi0fscyk1rmTKIuYNN6ojNA/++mhabx7LFXd2e2AqWCNHziwmB1bDSEJw7Bi7wKG+dGJTZzVIxzG
 YKCX5Umi
 07Y2dX8c6cM9hbJu1GsC/G2dCn0hQ13vHWDeQdqNgdHA4KPC3ewmnM3KeMVBNi/uwQUdr/jcZqtuqn40ogRdbI9Re1KBhCq8AKYqNzYPjTW3Fh2HbDQsVTTI8nkMC9hH3o0J9FpM/GoOTHVwqwaa1crMKqaHvPJOBdmPo54SzdtHmuE2IAL1OVNjeh994VfNx7CBWW0N/K6f2XSR18WYp5Hn8fITzlRufqlviK2o7wCS/AI93GwUAhz15yU+XcHSzgV53kRb0FRIIsDMsB82yczgqhKhOWqHIic5y8EkBWJ7MDDVx40H3UYm0A/b7+z5+NyPp5WDsMrz8sN7hhzmuYgEutXhd5Mgxq5/ofRaphYqgGd9sQuHYwCbJ4NmDOk0I246R8IVwB/QSbWwogVkbiDOH2dB4ztNmAROwOywEktfymb7Y5dharq+p0HZeTybrVeGacrrFsxfW4kXPRlvtqJEfLSo0TeEYUxaLM6DkHb5wZ/1fEWATIJDKmtAGRKo55prKrSuOH8nKSmKoNt1WrgjEZCE5FkiMT5DdAnF2r56/RZNCEePHtYv73QAfuF/qYDQT8RHYzA6xsoJzN1NvKCj6UUBTeBnKgNo0q5A1GxJqgEisTV6chVlAdHkUCU0pLNgQNQ7o38tIS8b+TgjONLCmfI27xEnngy/d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 01:59:09PM +1100, Balbir Singh wrote:
> On 11/20/25 13:50, Balbir Singh wrote:
> > On 11/20/25 13:40, Matthew Brost wrote:
> >> On Wed, Nov 12, 2025 at 10:52:43AM +1100, Balbir Singh wrote:
> >>> On 11/12/25 10:43, Andrew Morton wrote:
> >>>> On Thu, 9 Oct 2025 03:33:33 -0700 Matthew Brost <matthew.brost@intel.com> wrote:
> >>>>
> >>>>>>>> This patch series introduces support for Transparent Huge Page
> >>>>>>>> (THP) migration in zone device-private memory. The implementation enables
> >>>>>>>> efficient migration of large folios between system memory and
> >>>>>>>> device-private memory
> >>>>>>>
> >>>>>>> Lots of chatter for the v6 series, but none for v7.  I hope that's a
> >>>>>>> good sign.
> >>>>>>>
> >>>>>>
> >>>>>> I hope so too, I've tried to address the comments in v6.
> >>>>>>
> >>>>>
> >>>>> Circling back to this series, we will itegrate and test this version.
> >>>>
> >>>> How'd it go?
> >>>>
> >>
> >> My apologies for the delay—I got distracted by other tasks in Xe (my
> >> driver) and was out for a bit. Unfortunately, this series breaks
> >> something in the existing core MM code for the Xe SVM implementation. I
> >> have an extensive test case that hammers on SVM, which fully passes
> >> prior to applying this series, but fails randomly with the series
> >> applied (to drm-tip-rc6) due to the below kernel lockup.
> >>
> >> I've tried to trace where the migration PTE gets installed but not
> >> removed or isolate a test case which causes this failure but no luck so
> >> far. I'll keep digging as I have time.
> >>
> >> Beyond that, if I enable Xe SVM + THP, it seems to mostly work (though
> >> the same issue as above eventually occurs), but I do need two additional
> >> core MM patches—one is new code required for Xe, and the other could be
> >> considered a bug fix. Those patches can included when Xe merges SVM THP
> >> support but we need at least not break Xe SVM before this series merges.
> >>
> >> Stack trace:
> >>
> >> INFO: task kworker/u65:2:1642 blocked for more than 30
> >> seconds.
> >> [  212.624286]       Tainted: G S      W           6.18.0-rc6-xe+ #1719
> >> [  212.630561] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >> disables this message.
> >> [  212.638285] task:kworker/u65:2   state:D stack:0     pid:1642
> >> tgid:1642  ppid:2      task_flags:0x4208060 flags:0x00080000
> >> [  212.638288] Workqueue: xe_page_fault_work_queue
> >> xe_pagefault_queue_work [xe]
> >> [  212.638323] Call Trace:
> >> [  212.638324]  <TASK>
> >> [  212.638325]  __schedule+0x4b0/0x990
> >> [  212.638330]  schedule+0x22/0xd0
> >> [  212.638331]  io_schedule+0x41/0x60
> >> [  212.638333]  migration_entry_wait_on_locked+0x1d8/0x2d0
> >> [  212.638336]  ? __pfx_wake_page_function+0x10/0x10
> >> [  212.638339]  migration_entry_wait+0xd2/0xe0
> >> [  212.638341]  hmm_vma_walk_pmd+0x7c9/0x8d0
> >> [  212.638343]  walk_pgd_range+0x51d/0xa40
> >> [  212.638345]  __walk_page_range+0x75/0x1e0
> >> [  212.638347]  walk_page_range_mm+0x138/0x1f0
> >> [  212.638349]  hmm_range_fault+0x59/0xa0
> >> [  212.638351]  drm_gpusvm_get_pages+0x194/0x7b0 [drm_gpusvm_helper]
> >> [  212.638354]  drm_gpusvm_range_get_pages+0x2d/0x40 [drm_gpusvm_helper]
> >> [  212.638355]  __xe_svm_handle_pagefault+0x259/0x900 [xe]
> >> [  212.638375]  ? update_load_avg+0x7f/0x6c0
> >> [  212.638377]  ? update_curr+0x13d/0x170
> >> [  212.638379]  xe_svm_handle_pagefault+0x37/0x90 [xe]
> >> [  212.638396]  xe_pagefault_queue_work+0x2da/0x3c0 [xe]
> >> [  212.638420]  process_one_work+0x16e/0x2e0
> >> [  212.638422]  worker_thread+0x284/0x410
> >> [  212.638423]  ? __pfx_worker_thread+0x10/0x10
> >> [  212.638425]  kthread+0xec/0x210
> >> [  212.638427]  ? __pfx_kthread+0x10/0x10
> >> [  212.638428]  ? __pfx_kthread+0x10/0x10
> >> [  212.638430]  ret_from_fork+0xbd/0x100
> >> [  212.638433]  ? __pfx_kthread+0x10/0x10
> >> [  212.638434]  ret_from_fork_asm+0x1a/0x30
> >> [  212.638436]  </TASK>
> >>
> > 
> > Hi, Matt
> > 
> > Thanks for the report, two questions
> > 
> > 1. Are you using mm/mm-unstable, we've got some fixes in there (including fixes to remove_migration_pmd())

remove_migration_pmd - This is a PTE migration entry.

> >    - Generally a left behind migration entry is a symptom of a failed migration that did not clean up
> >      after itself.

I'm on drm-tip as I generally need the latest version of my driver
because of the speed we move at.

Yes, I agree it looks like somehow a migration PTE is not getting
properly removed.

I'm happy to cherry pick any patches that you think might be helpful
into my tree.

> > 2. The stack trace is from hmm_range_fault(), not something that this code touches.
> > 

Agree this is a symptom of the above issue.

> > The stack trace shows your code is seeing a migration entry and waiting on it.
> > Can you please provide a reproducer for the issue? In the form of a test in hmm-tests.c
> > 

That will be my plan. Right now I'm opening my test up which runs 1000s
of variations of SVM tests and the test that hangs is not consistent.
Some of these are threaded or multi-process so it might possibly be a
timing issue which could be hard to reproduce in hmm-tests.c. I'll do my
best here.

> > Have you been able to bisect the issue?
> 

That is my next step along with isolating a test case.

> Also could you please try with 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
> reverted?
> 

I can try but I highly doubt this is related. The hanging HMM code in is
PTE walk step after this, also I am not even enabling THP device pages
in my SVM code to reproduce this.

Matt

> > 
> > Balbir
> > 
> > 
> >> Matt 
> >>
> >>>> Balbir, what's the status here?  It's been a month and this series
> >>>> still has a "needs a new version" feeling to it.  If so, very soon
> >>>> please.
> >>>>
> >>>
> >>> I don't think this needs a new revision, I've been testing frequently
> >>> at my end to see if I can catch any regressions. I have a patch update for
> >>> mm-migrate_device-add-thp-splitting-during-migration.patch, it can be applied
> >>> on top or I can send a new version of the patch. I was waiting
> >>> on any feedback before I sent the patch out, but I'll do it now.
> >>>
> >>>> TODOs which I have noted are
> >>>>
> >>>> https://lkml.kernel.org/r/aOePfeoDuRW+prFq@lstrano-desk.jf.intel.com
> >>>
> >>> This was a clarification on the HMM patch mentioned in the changelog
> >>>
> >>>> https://lkml.kernel.org/r/CABzRoyZZ8QLF5PSeDCVxgcnQmF9kFQ3RZdNq0Deik3o9OrK+BQ@mail.gmail.com
> >>>
> >>> That's a minor comment on not using a temporary declaration, I don't think we need it, let me know if you feel strongly
> >>>
> >>>> https://lkml.kernel.org/r/D2A4B724-E5EF-46D3-9D3F-EBAD9B22371E@nvidia.com
> >>>
> >>> I have a patch for this, which I posted, I can do an update and resend it if required (the one mentioned above)
> >>>
> >>>> https://lkml.kernel.org/r/62073ca1-5bb6-49e8-b8d4-447c5e0e582e@
> >>>>
> >>>
> >>> I can't seem to open this
> >>>
> >>>> plus a general re-read of the
> >>>> mm-migrate_device-add-thp-splitting-during-migration.patch review
> >>>> discussion.
> >>>>
> >>> That's the patch I have
> >>>
> >>> Thanks for following up
> >>> Balbir
> > 
> 

