Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D9AAD25030
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 01:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8BC6B0088; Sun, 11 Jan 2026 20:16:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156BF6B0089; Sun, 11 Jan 2026 20:16:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25BE6B008A; Sun, 11 Jan 2026 20:16:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA9D06B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:16:54 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 838C71615CE
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 01:16:54 +0000 (UTC)
X-FDA: 84321547548.04.57130CC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1A8AFA000D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 01:16:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i8EaUoXU;
	spf=pass (imf15.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768180609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWkLnXpy5l/SbI5Jy/k4RH0bwoZokalTPGydo5IBntY=;
	b=y4of128XqrMZ3WfS1AlyE7T6XLkEO8OKZJVELn8mSARC2tKTFwjVwJkPXtHPYZuMvAYfnJ
	Rd+xU2rRQOUKhJNLTMfMDRkXHMm6OIvPnHQ/44sibDjgmzmgU9l39/GN8hllE8sxKEGeDo
	BLgmsSQEKoOCv3CfMyVY4BRcqTbWsjg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i8EaUoXU;
	spf=pass (imf15.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768180609; a=rsa-sha256;
	cv=fail;
	b=uIesSXSFrvgaTzGrpyBKd3TLd29PbWRkPmz0SeJfPWXLcUWYzY3g7k2TIVmD/Fw0fRg1/g
	9PHhgxxyEagrgUUnMWjmQy+YuUcTIS8ERvu2ErxnMWghzfNy5shzGirKsDhSx5lxRrvhHj
	NRT1WRJc4ega4dpIkttypiwKg6KxMX8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768180609; x=1799716609;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=+rJp6Sm6WfumJ2crk/I7tiS3zSqMKGjV8mtQU7DQOWc=;
  b=i8EaUoXU7iIUsTHw2zSh+sjr2oKsXXZh3+71M0MQOcbaL20Bt5JOZitU
   0ZtTwr8CpkEu1Xt0NUSei6U66wEfCWnj1pxEebjLBuG/bT2YZ7vYqiRkE
   LP/Qym2L0/SMZTBCa9J+o1BbuR2hhwF86uARpAnELmo/f9eVxAKKnhMw2
   OSmYiUE0EpiQjdWL3/JW+3W8rbV+bF9OrEzesY11RVQuhzfSnRMOoFGKE
   838OwTV45+fhU4XslZx+dHboyH6CCZVYjbPjC4nbXmUscK7F70D34Q2GR
   E8/qcRlipqqtiIyrk72Mx7NzaFYW+n/ceTmmt8pM2NEpEz81ON2wWEgdm
   g==;
X-CSE-ConnectionGUID: J25uMQfASzKpQu74SMqcDA==
X-CSE-MsgGUID: 9siUTYrmR7GClGgX6hSqyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="68462577"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="68462577"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 17:16:48 -0800
X-CSE-ConnectionGUID: QKiYnFH1SwCVOoDCRxBlIg==
X-CSE-MsgGUID: +fs+a6tlTq6T4mF99tB+qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203762632"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 17:16:48 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 17:16:46 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 11 Jan 2026 17:16:46 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.4) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 17:16:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=psQAKILkGaU7MpFDGrePchbTITGzrI7FQehcVetSTFQWBWRvJPL7w4riwuwi0Wscq6vdWds7zuJezMIoC86R7bAHp0gocUykDB2Utv+4h13cZxJokuWpqelUVd2BwylRvvd51/uSjPffhJgNcv7NUrAzObpTZHZA6xRZgwCuUsxsrxA+0ubFEw834Pg0JxP5Q6bFcIEb54h+IO+h2oQ6BAV0HJnCQJA7EGTKv076VmMweJTiqzYWY78b5Razo7VEtENGFmx1xW0BePIpqG/VU3Dr/eJ+Ay8oVdgRyzHtkw7btEO0abA6M+qMfHcaXEHmQVkdobPnCLY/kJs9BqjLcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWkLnXpy5l/SbI5Jy/k4RH0bwoZokalTPGydo5IBntY=;
 b=fWcE4Gv4m1pKuOjp0Ucuiw1Rfc0sNbApt1fLXPuoZN+NO/lCXiQIaFONrOb9zeBcSw13bognPLhB0VdaJ0ANbDCI5rIcgjQPFMSY9mIbGHgKBhpltwVh/rStjksn2kOln5zqjAKcVwekaWXRYbKiOXx5MMy+wo4NhdcFmwRDpwhT6aS2ASeiKzgrBAHtZyNqH272rRzNl0vTDxIYhQ8iSyg4vbG6BGkfCkfRe8vz/LcD+KiEzyrMJACTKr9oNDl4vstgG9O//NRFT7SqEHlp4+TZErYD1VkBusENZIXRyc9sB7sFz0YoiQrph6Eqk8nFvhmaqu8V08yYtQ7Pg1AO8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by PH8PR11MB8287.namprd11.prod.outlook.com (2603:10b6:510:1c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 01:16:45 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Mon, 12 Jan 2026
 01:16:45 +0000
Date: Sun, 11 Jan 2026 17:16:42 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: Francois Dugast <francois.dugast@intel.com>,
	<intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, Zi Yan
	<ziy@nvidia.com>, David Hildenbrand <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Alistair Popple <apopple@nvidia.com>,
	<linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/7] mm/zone_device: Add
 free_zone_device_folio_prepare() helper
Message-ID: <aWRLeoUJAYAWbLD3@lstrano-desk.jf.intel.com>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-3-francois.dugast@intel.com>
 <706ba3a6-5be2-46d7-9e7d-d613f2e061cc@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <706ba3a6-5be2-46d7-9e7d-d613f2e061cc@nvidia.com>
X-ClientProxiedBy: SJ0PR05CA0082.namprd05.prod.outlook.com
 (2603:10b6:a03:332::27) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|PH8PR11MB8287:EE_
X-MS-Office365-Filtering-Correlation-Id: 68dab2c1-3bd2-427f-4463-08de5178403f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NkdLL2ZuZUUzdG0zekRFYnExazdIWnJ6UUd2QkVCYlljbUVOcHVzZ3hidTVw?=
 =?utf-8?B?elVGeVRxc1ZNN2NyQ0pIRG5UVkFiMlE2RGluTmpVclZaQlFBRVprZkRFdGI4?=
 =?utf-8?B?bVZqdklQSllUd2tWNmJqbERTbVBOM0YvaVZCUUlZeTZOUDhaR3NmRXhnaFk5?=
 =?utf-8?B?d3hUYTFaRXVLSFl4Z2pNaG14eXowYTVtNmVvSkszLzdWd2ZxRFR0b3loMTdR?=
 =?utf-8?B?N3FBc1pESGQwYWd1YklNSFBEWDN6K1UwS0w1dUVic3luaXhyb1k2Wm42OExz?=
 =?utf-8?B?WlYyTHZSTXV2U2w3b0E0T2ZoQmk0cEFsWVlhREwxYmJPSFJIZHpCdTlNK2hW?=
 =?utf-8?B?MnlLS1JqTExlY2JSalBUYzBLZ3diOThjRllnYmN3T29aM0U0Mm1WcVpvNmpt?=
 =?utf-8?B?bWppVEFjZ0luS2kvWjRjVk5Icjd5MFNVRy9JaGhCSnZPTGtTTEg2UzEwZWE2?=
 =?utf-8?B?WW0rTWFIZHBKWnNzRTFMTk92TDUrTHl0ckVSMloxOGcwdlVNK2NPOTBRTzFG?=
 =?utf-8?B?akIxTWppVG42WG4xenhvbWFyZ2RiWjJLV3huWDVYVWx5d1VwaEJ3OGZRV1Y4?=
 =?utf-8?B?ajhtOElKNDc5TWViZlpyUDdaOUNZMXIwY0hyaGxPcC9EQ1VDejdXT2pha2gx?=
 =?utf-8?B?UkFKdXBHaWZSbkRzQ2xkM3M0VjFJNlpnTGQvbUZvSTlFTndubWRSQVZEV0No?=
 =?utf-8?B?aDhzOEF3ZmdQWGh5d0YxclVvbjNVL0xFdGIxZmovZ2pjOFIyOFpaMXZlREd6?=
 =?utf-8?B?MlJZNTQzR3c1VHpzYnM3TzgvNkpuVW9RV2pINFdCNjFIY25la29maXQ3R1hC?=
 =?utf-8?B?S0FkcHRCRlFrS2x0Q0dteHRkNXp0VHcvL3A2dS9paXAraTdxSG0ydVZpVmRw?=
 =?utf-8?B?UXl1TFdMQWNKT0RlSm1idnpCNnJVY1JxaVVTMWdPaGlxSWJBTURFclNRM2or?=
 =?utf-8?B?UmN4NVhEVHlZVlA2NGMwb0pNRERVV0VwOWQzZzJ4dmM5RDBjSEFxYWxPNDVy?=
 =?utf-8?B?dGpRNHplb0VuN3ZEU2tRWlNqY2RJRXo3NTk5dzhta3MrV2FybmNvVnJ5bklu?=
 =?utf-8?B?blUxSkdkOXYzN0FvNGNvbEFFQzZWZDNSQjlTYkZnWmpyUzFMN2lCdXc4U3Js?=
 =?utf-8?B?amF6UjJiL2tPRU9Ec201NVkzWEV6OUJWVUMyL3NVK20rYkl3ckRZTmhPSWxo?=
 =?utf-8?B?YnQ4VndrSlVKaHhRa0RzaUg2N0pHN0pnbVAvSXBEWEQ5bHJTNUJyYzZ2OU5Q?=
 =?utf-8?B?dVE1Kzh4U0RiNzB4RGdad3AvL0ZuRzlTbm80QTEwMXJZKzcwTGF5QlpMTFJs?=
 =?utf-8?B?U2xEQlpxSUpLMlplVFdDVkNsVjRJTU1va0Y1MmF6bnNwbXFXcmlTZTQ1d2Zt?=
 =?utf-8?B?dTV0NzZ4ZzlIRHdKM3hqVDRITXBJYzBYeC9ITjhyZkE4TjNnZXVFQThyZFFJ?=
 =?utf-8?B?SEtPVEdIWjFjNnY3SVlBZ3M4eFA1MGd4U1dmMW92QVpndHlOc3lubjZKK3pS?=
 =?utf-8?B?S2tTMEZod1p4akdYRWxiQ08yTlA1WU51VVNuNTgzS0psT2FuTFVrUEdmZVc5?=
 =?utf-8?B?b3VKRVFuMDJOWlVzNFZNdm9qQWk4TFBNZVhjc3dIV2JhTVpScndOc2hJU0k1?=
 =?utf-8?B?eDlLcHo2VzFvaVVkaUJHRWtOWXFIemQ1dUs2WWgrZDBKREduS3ZzRjF0TE1r?=
 =?utf-8?B?QThwejAzb1djVkJ4dmlrYkhhSE5YNzlHdXFRaW5RUGNMRlBVdjZWRFBjNG1U?=
 =?utf-8?B?R0hYeCtuS241UDg3MWxNU2VIS1NtRm5MbXFYMDIwM2hCOENKbkNIUUh2YURO?=
 =?utf-8?B?MFB5cldpQVlEYWZUOFpaOHYzejVOeHpPMVNCczVvT3dSbjF6aERvQStoMmIx?=
 =?utf-8?B?dGpJYjdWaVRQWVNPTlZjVDVSL3JhU3dxbHllRExGdmx1L3c9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlE5VXdhWGQ1V0VoNzduS3RuUTJRV21kRnludnV3b0ZLaCtyS3QrNWxLdVhT?=
 =?utf-8?B?ZURyVTlPWCtjK3I4RlM5Z1lyMU1jTXM0dUt6YlZpU3hqbldvZm83bWxQbkFv?=
 =?utf-8?B?VkZoMSszVDVzdEc0dkVySWhTc3UxN3F2dHQ0a2V6YXltMnhVbXgva1QzZ0xZ?=
 =?utf-8?B?M09UTS9rclIxU3laMWhFTmdmMFlPVzJHQzByT3hhclJEVFRweDZIWE1RRWsz?=
 =?utf-8?B?SkRONUVlVDRDczc3VUtZTHdNdnR1d2xoc0x3dUt0eFE1ZytucFhsWnBscGZv?=
 =?utf-8?B?UnArVVJwSVhTdW5aTytaL0hDRG9Zd2xXQUl3a3hYQVNiRXhZcFp4a3dobXZH?=
 =?utf-8?B?VFZwYnBzM3NWTWQ2bzRlaVJ6RjJPOU1xRzlYYmhWVmZqTmFyVndXQ0hXV3ps?=
 =?utf-8?B?bzRXR3VJWlNZS1hLSFRsbW12azAyU1g4T2RTbzdaYlhqWHh4VzhzNG5nL1Nh?=
 =?utf-8?B?VTAzREdiVDdxLzh4Mm1CVFBnUiszT1hGSXo0bjI1Z2JyNk1oWWtYbXYybTBL?=
 =?utf-8?B?ZUoxeGZYdVE2MDlvVVJXSDFncEN4cEw1bVhQRFQ4SHhudHBZcmpLVWg1LzB0?=
 =?utf-8?B?cjZ3NUZKNzdiOHNWN3VaTldmai9Ya09WOU9SbXJ6UVgwZG9YbkFwQ0VEY1pD?=
 =?utf-8?B?YndiSnZuRlR3WXZidGlFemtod3JlRWV3c3JYSEJ6SWNxZDFucEFQZHNxL1h0?=
 =?utf-8?B?eDR5VSthcTNRY2c3a0dwYS9ta1lhSW91ekRWWUViQm1YNVQ5enpCaEhSL2Q4?=
 =?utf-8?B?Z21yVjA1MFdNeWphUmo5eURxRzFXY1F6K1FuWmp3L1hCSmZxV1REenJGREwv?=
 =?utf-8?B?RHB6TEd3RFNZQVNJNUFCZm05RVZRNnI1TlliRm1BajlmQlhEMnFFYTlDYjhD?=
 =?utf-8?B?MWRSNzJPRDUzdXVzd1oyNEs1ZGdlOVY1LzA1TU9FS3U3TEhaZEg1QmJBcnFM?=
 =?utf-8?B?bGVzMFpodTM2SFAra1RqYnF3SEE1S29QaXk3YlhzdlQ4WnFQcGNRMGRNMnNJ?=
 =?utf-8?B?ZGMwQkUxOE96ZzJTQURzUUdEUzkzdFBUZHRKMG5DNnNDd2NnQmp0N2pUTnpN?=
 =?utf-8?B?WTBhUVc3M3kwc3dSYzR5ZkFJcm1iZUJoWnUvNVd3WG5pS0pEVFYzL293T2JD?=
 =?utf-8?B?T2Jvbkt5K2dYcWt6OWdlbE9HdGlMNFJobUUyaW5aNGFVOVIzTGZiUmJBa3oz?=
 =?utf-8?B?UzFnYVVaRS8wNjF5UFEwZVVnTWpXMFhzRStSL1BWVmdtNHhDeE9VQzJwK0pM?=
 =?utf-8?B?bE9UcFZLSUg3SmRwMlI3UGxOZmE4elJjL2pYWHFWVXRFa01Dczl4bk51NUtL?=
 =?utf-8?B?QXQyUGd6MUlXZVlqOWdCTlZVK3dYYm4zWXRvbFZSUmtNdzRiVU0vQVdFQTM4?=
 =?utf-8?B?TnFRRXJXM2h3TGU1bXp1SEtqM3NKcDUrL3RmcG5HOXJuU25SejVTNmc3a1ha?=
 =?utf-8?B?RDl2d2RrQVpwbE50amZxQkFzQ3l1U0hic2FjNFdMSEhLTURZMHhLRWRxbWxa?=
 =?utf-8?B?QW9QMzlsVlRTL0JyaDlqMW9PMC9MMmFZRHQwZkVySUozRFJhK1pjUFBxUXdJ?=
 =?utf-8?B?OWtROGFFTGVremxtb3h6bkI1U0lyVjZWNWJuOGc3TEwycGRWMDAvTnVVckg5?=
 =?utf-8?B?WTlTamloTUhkb1VyWkpxdTM3OTYwRXZFVUVEYlBJUU1GazN5MTZpNXlFMktV?=
 =?utf-8?B?K3JTeSs2eVRSVkZOZ2hicjdzY2Z1blg5ZitvemFZRmkrbTZQT3hPTTlDY0h1?=
 =?utf-8?B?Nk0zL3dlc0duc1dVandxbFliaWJJS1hGK3RIemJ0RHVURzNCRTNIUzZiYWFN?=
 =?utf-8?B?Z0cxVmRwYVlQbTdRVVkrWW1LUEptQkRTcWErbjVzRkd6d3RCRFVEQkVTdG9o?=
 =?utf-8?B?Sk0vRnhkaHREcjQ0Ym5LVGxmWXJQY21qNlZ0M3hNYVAzWCtJMTFhdFBuMEdY?=
 =?utf-8?B?Z2tiTEN6ZHRMNzBFekduWVBzSlF5WXJ1YUtlRENtazJYTG1EcHNneStnZndu?=
 =?utf-8?B?ams3NGFCanhaR0pSWVZ3b2Rtc1lGMXFIUXhrZHp6Y0srblZ4OXN4cEswTU9P?=
 =?utf-8?B?QnFRUmhNbGdzc0p6YURVRkcwVHJtNk5QdWFZSTBVRGRScGtZWitiRHIvbHJY?=
 =?utf-8?B?NXh5R3oralZaK1YzUnlkVTBXUFJ3WlVDUTlLNmJ6T0FPRWxxdDY2b2I4VHRo?=
 =?utf-8?B?aEdjckpwZC9SaWFuZXB5YTBWNUY4bTkyaWZNOUpHbG1lbkM4bFA5dTdpSEV2?=
 =?utf-8?B?dktsWlYweThsMWRsbklqajVqODZRZlVRVStrYVJxMjRtaXYvWGp2UUxXd1F3?=
 =?utf-8?B?azgzeU5pYUxyTk5ZK2ZZa3k2dTNtMDZvaG4rTUFYSGVWaXAxdTlVY1pQN3hp?=
 =?utf-8?Q?pRus2ClpoeZGOxis=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68dab2c1-3bd2-427f-4463-08de5178403f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 01:16:45.0701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lgz00KjGOoKvUaq0Bq+cIW9JARojSIALbaNwPC+AaNsVrZ4w8irmKi3+H2A7YbYJvaEnfhjrwMJ2J3UkhTcH0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8287
X-OriginatorOrg: intel.com
X-Stat-Signature: escg4cca5dk3pgpgt8gy81a6ja9m8sgu
X-Rspamd-Queue-Id: 1A8AFA000D
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768180608-775193
X-HE-Meta: U2FsdGVkX18xPs7CC9SRhm3faxxuEyPzJwd+DNsQLZ1nEkAsJ2GtD83BNPZbHBxD9eCtYBmNswhGQ1TqAOhOJkSax7I4yN+/UZcXIJbqgOhvYwQKZiuZ6YsL6NLVhvWEKg4eytIJqoOdZ1SLFEU5+ETiG4cpxRj2mLP/cdVQhWnugL0QGd3ut4WBul6LCF9nt/SOd0PXMxCwogGDmV2p/IshsOPX+3MSamlZqCMEI5h7OGpEXZWz5IkrAmEc42G+PDH/IA0hN9ZTNAw5XGyBXci3KlzmMwJ6Q465MlS/rQBoMsabhjLc6uK6PtBPDqESI4xaSPAec5ZKJp5pCSwejugUsORBrG+vodk2NRKhj4VyukzvioGqON1FVK7we1KaD4eUxf+hHBEB1corJhyNPgPh624EtGVwI4ugPV2DfqBlRCiJGWHsKly7y9tdb3gAtdopFPsaK3ylQSQolzK22ISbES8fjz3InQv743T/TWByStJX+A85NpxNJzzARMD08RVuKllnu/TBBZIaan13P2bz/H2G2WTyvwW5375j0eXDHpZcP4KQ03NiYEvdEQ3ugdIfQ8OYmtiRXvvHdUK/YTg8AJWUwxjJiYl/oJw0zIiaskjRiHHxDAA9WBxlUzBUSpSuCDfDJ0yg2c0AoMphbMooJdD0Lx3kB+frPN/jX/PmeVoCFh6XSg1rVFtcWf1TrY710OIiokKpUIrptNR4eMl5Kfv56MuULv9OqcY0cvX+6q4GNnFLysUemy6jPyn0jNfTFuHwpra8Z2q3APxoLknDZ2JrGRdWqnZphqLyNu4MiRIV1uYrlKC7ud53qLjSZIyA6YSeQ8GXJXXpSIQEMoGZjHMj8XvR3wFLuAWB3eQIQ16DS62BB+7hEH2et+W8fVzIv4/IL47aaATALAmkYGm/iWYA3SnXGhpZeV4mO3Bfpd+DnIrMzrShin7XwdHhxqH8ivjKg49l3YHTRu0
 Edc4DhiT
 Rl3jBjvBbFZFIgAjx76i4npagybVXoQ/CNEwKErRoRbejGEImJnJ+xQkDPSZvJwjPqQsXMKKsPknvJFJuZsp8zXnVAXXxfxor9JQzLEQBBqMXL08u37xAGz+lAGD4QNeYNkgs97QEKxhGV5PqaSU+JkdMzZXwrfPdPzMwlmSGt9jULV2+v1KN7gbCYo/5ouaWgs0Y1NfCqDAX4jGMRE5e4HyEsBtOsMCaFcqKrwTGaD8qIdv8ZfV4Jv9s53p8jfSCQwJ1sN1zl23rDibC2N23QBPzXX9Q6TrrkVvshV+nCzll4xOMFdLcqzRj3iPzP+Kfz1xDnw7zAtVkASP0Vz2nBY8IVRjm3ajXKBTW0rN7tVAUs4MbCv//WF0e4gN/ar4Qmf3hMFZw+3MJbCA0bTWuBHUi+2BBKLS4fag+tuLpDTnXJEFg+MvHCBv/iFsUxr/oUmGAEoInfZXzLSOQ53p7IhNKWHCRbs90Fh4ZmSCeV1Mjab5Y8qE9WUkVe9KWgcue2WsnsO5H1BBYc853P3zRs7T61uhspAHhmVCJ9YKf0ZTh6pip/iOXMgjcKujwSCCk05oIpFOdsqEYDgDWst09seUx+6mJmYCyJia8N16kziiwQkS5X29j2L1jRwVW7Um8kcT3d6gH+2Fd8JcyToOExpWhCvYf7ip4zpFVVAOkiVTZVJKSKw20mZ1SLaehfPXTwiXLxmunEbwi6EEhq6tHDJuNTxoXcC42m70NwXBHz73rkXjsZV0PoFy1sJCgJALITdRDzEKXL0l03p/NC6Nw5++3kRXIbyr9b9AmxP/WAlR5Nv6ZQogAAfiuC8ukIZ/jo4ZdUdcJRKaOmEFGw9FaAwX8UWkQAdxJ0lIHKWVxnTItKz+4tBm4AL7/9h9Z2MExGC/dMdbnctfoavQs3ZwTByoczw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 11:44:15AM +1100, Balbir Singh wrote:
> On 1/12/26 06:55, Francois Dugast wrote:
> > From: Matthew Brost <matthew.brost@intel.com>
> > 
> > Add free_zone_device_folio_prepare(), a helper that restores large
> > ZONE_DEVICE folios to a sane, initial state before freeing them.
> > 
> > Compound ZONE_DEVICE folios overwrite per-page state (e.g. pgmap and
> > compound metadata). Before returning such pages to the device pgmap
> > allocator, each constituent page must be reset to a standalone
> > ZONE_DEVICE folio with a valid pgmap and no compound state.
> > 
> > Use this helper prior to folio_free() for device-private and
> > device-coherent folios to ensure consistent device page state for
> > subsequent allocations.
> > 
> > Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Balbir Singh <balbirs@nvidia.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Alistair Popple <apopple@nvidia.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-cxl@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Suggested-by: Alistair Popple <apopple@nvidia.com>
> > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> > ---
> >  include/linux/memremap.h |  1 +
> >  mm/memremap.c            | 55 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 56 insertions(+)
> > 
> > diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> > index 97fcffeb1c1e..88e1d4707296 100644
> > --- a/include/linux/memremap.h
> > +++ b/include/linux/memremap.h
> > @@ -230,6 +230,7 @@ static inline bool is_fsdax_page(const struct page *page)
> >  
> >  #ifdef CONFIG_ZONE_DEVICE
> >  void zone_device_page_init(struct page *page, unsigned int order);
> > +void free_zone_device_folio_prepare(struct folio *folio);
> >  void *memremap_pages(struct dev_pagemap *pgmap, int nid);
> >  void memunmap_pages(struct dev_pagemap *pgmap);
> >  void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
> > diff --git a/mm/memremap.c b/mm/memremap.c
> > index 39dc4bd190d0..375a61e18858 100644
> > --- a/mm/memremap.c
> > +++ b/mm/memremap.c
> > @@ -413,6 +413,60 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
> >  }
> >  EXPORT_SYMBOL_GPL(get_dev_pagemap);
> >  
> > +/**
> > + * free_zone_device_folio_prepare() - Prepare a ZONE_DEVICE folio for freeing.
> > + * @folio: ZONE_DEVICE folio to prepare for release.
> > + *
> > + * ZONE_DEVICE pages/folios (e.g., device-private memory or fsdax-backed pages)
> > + * can be compound. When freeing a compound ZONE_DEVICE folio, the tail pages
> > + * must be restored to a sane ZONE_DEVICE state before they are released.
> > + *
> > + * This helper:
> > + *   - Clears @folio->mapping and, for compound folios, clears each page's
> > + *     compound-head state (ClearPageHead()/clear_compound_head()).
> > + *   - Resets the compound order metadata (folio_reset_order()) and then
> > + *     initializes each constituent page as a standalone ZONE_DEVICE folio:
> > + *       * clears ->mapping
> > + *       * restores ->pgmap (prep_compound_page() overwrites it)
> > + *       * clears ->share (only relevant for fsdax; unused for device-private)
> > + *
> > + * If @folio is order-0, only the mapping is cleared and no further work is
> > + * required.
> > + */
> > +void free_zone_device_folio_prepare(struct folio *folio)
> > +{
> > +	struct dev_pagemap *pgmap = page_pgmap(&folio->page);
> > +	int order, i;
> > +
> > +	VM_WARN_ON_FOLIO(!folio_is_zone_device(folio), folio);
> > +
> > +	folio->mapping = NULL;
> > +	order = folio_order(folio);
> > +	if (!order)
> > +		return;
> > +
> > +	folio_reset_order(folio);
> > +
> > +	for (i = 0; i < (1UL << order); i++) {
> > +		struct page *page = folio_page(folio, i);
> > +		struct folio *new_folio = (struct folio *)page;
> > +
> > +		ClearPageHead(page);
> > +		clear_compound_head(page);
> > +
> > +		new_folio->mapping = NULL;
> > +		/*
> > +		 * Reset pgmap which was over-written by
> > +		 * prep_compound_page().
> > +		 */
> > +		new_folio->pgmap = pgmap;
> > +		new_folio->share = 0;	/* fsdax only, unused for device private */
> > +		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
> > +		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
> 
> Does calling the free_folio() callback on new_folio solve the issue you are facing, or is
> that PMD_ORDER more frees than we'd like?
> 

No, calling free_folio() more often doesn’t solve anything—in fact, that
would make my implementation explode. I explained this in detail here [1]
to Zi.

To recap [1], my memory allocator has no visibility into individual
pages or folios; it is DRM Buddy layered on top of TTM BO. This design
allows VRAM to be allocated or evicted for both traditional GPU
allocations (GEMs) and SVM allocations.

Now, to recap the actual issue: if device folios are not split upon free
and are later reallocated with a different order in
zone_device_page_init, the implementation breaks. This problem is not
specific to Xe—Nouveau happens to always allocate at the same order, so
it works by coincidence. Reallocating at a different order is valid
behavior and must be supported.

Matt

[1] https://patchwork.freedesktop.org/patch/697710/?series=159119&rev=3#comment_1282413

> > +	}
> > +}
> > +EXPORT_SYMBOL_GPL(free_zone_device_folio_prepare);
> > +
> >  void free_zone_device_folio(struct folio *folio)
> >  {
> >  	struct dev_pagemap *pgmap = folio->pgmap;
> > @@ -454,6 +508,7 @@ void free_zone_device_folio(struct folio *folio)
> >  	case MEMORY_DEVICE_COHERENT:
> >  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
> >  			break;
> > +		free_zone_device_folio_prepare(folio);
> >  		pgmap->ops->folio_free(folio, order);
> >  		percpu_ref_put_many(&folio->pgmap->ref, nr);
> >  		break;
> 
> Balbir

