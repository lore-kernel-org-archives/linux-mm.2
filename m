Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACAEFC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B5C6B008A; Tue,  8 Sep 2026 12:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F2DD6B008C; Tue,  8 Sep 2026 12:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1DE6B0095; Tue,  8 Sep 2026 12:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6076B6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:49:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BB9F1605FA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:49:58 +0000 (UTC)
X-FDA: 85191182076.28.E019845
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3F3D7100003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:49:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bNj83bkB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788886195;
	b=touyDqAErUG9g96fbbyJcXsiv2xti8zls6ySCUyM39QpKKG8jyZ2WSCILKBtLKIimzBRmS
	1p5hPlPlpu3sReIIcUBJAUDfVMHNQ/xXfIv7L74g3YHnsAoiJa54hxy+53b4JHot82FjbN
	BW/lhlsFOeYu2PJ9WY0jTQpD3PG/b+w=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bNj83bkB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788886195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuqrgQc6vfzf3SIMgMo1NlBWMZ294riubwIUf9oxZws=;
	b=TLvY6JDtExoqGoXQVzwF0hC53lJ5eouAK0+o89rMoH0DLiAKEVvxWddGGqQDwBKRlgpBDs
	pwK8vIqnB3mQ+V7mhqnKcEL8XxEKToraKg/gVPPxC/aEc5rsj5vfc8Lebh5NzsdUyaQX86
	OLeNHK63lt3UR5yoX7t2tFpURFMyz3A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788886194; x=1820422194;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XuqrgQc6vfzf3SIMgMo1NlBWMZ294riubwIUf9oxZws=;
  b=bNj83bkBnzC4KLE9zoZWJeXTEJFN8apxWV7Jnw3YyhhTjkmPXUdRja9y
   cN+pwhiVXoVliXu9ZhWFH1VkpnCn0KjbRDAV5F+Q7uvK1oBOTHM92y8sv
   DhVmNBp76AmsMM7/DQrIPEjMXYT7Oqta+SJ5nWxOxBVeb5J76aoXsUspW
   FkeZyfVZuj2tivenNHTahRiYoBmUAIe8YAEoxbHaZGYJdSP77oD9p4leY
   Jge/q5+SWCH5/q3XAySHy7q48Tla85mEqOHc0dwEZPJrU2HPXC6k6RlsX
   T2elT2HaibReN1jPvhLm7kRZEo1plzDb14p7JqyN33pbMi1SdlyibuCBi
   A==;
X-CSE-ConnectionGUID: wSWqpzE4Ssuyg+gDLADy1w==
X-CSE-MsgGUID: k7QBuR8USliYF2Vo/828gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="99957898"
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="99957898"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 09:49:53 -0700
X-CSE-ConnectionGUID: UNXbs4D4REi6nCX+Vr0/Yg==
X-CSE-MsgGUID: ML/Uz4JmTwq5EPVERRmzcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="300926089"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 09:49:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 8 Sep 2026 09:49:52 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 8 Sep 2026 09:49:52 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.40) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 8 Sep 2026 09:49:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pAUF9kxJTZfT8GlxVLgJusv8e8vHwIYeZS+BEUm8tlV+SrXoiCgPjCydBDDHYFIJZZaQyp5XlVN0bFzAqqWmL9u8Cw8X75Ou11dY8MIuVUxV0VqdMvJkhibImzymFY6JXN8r0yiNOSRW6U3J1r0wab7JrecZjUnFXrtvxy9IKM5V/2IurhGm/4WWuzjBrTca+hSkVgdbxRA8Cm2mOILVMt1HDXGdK9ueztZWeiGT6W2AJ13clVR/JhMMPaMCNz5CS2xgQqWTX2Ts8VhjPURBm9CQ8VrzBPR2PELpgRkdz+tDA+9u5t/fYDV20flv78CU7MnllfqDkCJhSbplBAQyxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XuqrgQc6vfzf3SIMgMo1NlBWMZ294riubwIUf9oxZws=;
 b=Eyy8lYi3cFoqUxpz2EUa6fIB9sXMsnWXMgzE2QtmBkQ+lN6ybK22gEmmfaymuFqyeWzLNgpBt9EfAuyJiu3bK4pE92cW+JZkWdUhFzPE2zI7LPtIZf8rllLwzZnumZDd+O+Z61ZDaEs8kYcMPiihOjoYuSaoXRghZOQvlMQgRyIlAgkarPV32qFUY0j+t2qDVnkj8JZz7wNY+DBGvT7+dofjGrqoPq8rd8ZB5EYr4WVxiMQvmMiwINRsnadT7UqZNLMFs+3V6lYMTy7dif0mHHz4ZXq2jHrlMnFvwjamDlXMzUPLrp0/4BQsZUaZzEOabvo+tkjjBC45G/OMWISAgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21)
 by SA1PR11MB9660.namprd11.prod.outlook.com (2603:10b6:806:4df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 16:49:50 +0000
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d]) by SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 16:49:50 +0000
From: "Ababneh, Ehab" <ehab.ababneh@intel.com>
To: Barry Song <baohua@kernel.org>
CC: "ryncsn@gmail.com" <ryncsn@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "kasong@tencent.com" <kasong@tencent.com>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "weixugc@google.com" <weixugc@google.com>,
	"yuanchu@google.com" <yuanchu@google.com>, "yuzhao@google.com"
	<yuzhao@google.com>
Subject: RE: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Thread-Topic: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Thread-Index: AQHdOjxqaRSPWT3KQUCvH7lHJPZvdLa6CN8AgAA+YQCAAYnQ0IAABs2AgAFohNCAACQPgIAHiFaQ
Date: Tue, 8 Sep 2026 16:49:50 +0000
Message-ID: <SJ1PR11MB610576B5616D578C48163B9A8CB12@SJ1PR11MB6105.namprd11.prod.outlook.com>
References: <apcVhWzEwkwHYjB1@KASONG-MC4>
 <20260901220430.79810-1-baohua@kernel.org>
 <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
 <SJ1PR11MB610566E5520AFF142D8C45168CB62@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4zSP7tKuaFHXH98dKKniGjauy7RSEDPnDR-ppCkVXhsqw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zSP7tKuaFHXH98dKKniGjauy7RSEDPnDR-ppCkVXhsqw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6105:EE_|SA1PR11MB9660:EE_
x-ms-office365-filtering-correlation-id: bb74090b-2dbf-4932-9cce-08df0dc932d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|38070700021|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info: WT4CFVFR/IBgYndhyQU7e/4cDVn9uPpSEoJ1m4l1Y0OseQJCrIbzcryZX+FYGPQWrT2c3Gi8NyNX3YtmK2VhfAp9z8sHyOFFYwzmyKeQyxCM/7OAReVxaMLucFY9tYB2fdCLLq5jVEpg29xLA1y80I9M+0li8Hp0EllLxl91zyX+PxSRu8RQMXaO3pPPjW17a0gZZuds52EQXfnXecrZmW05sR07lTm+qroyDGi660H0S+w4o2O87WfRgqPrg3lHAXRbwZZPsvZlZeqacFUzIQJkPMJbw0VDgE/O0h34xEm68xunNh9libGMNtmPO8+A1yBZAzHdu0Z8rwjTriRFxD+kEbhRbmWl6lxHcKe47ozfD5Jkso0O4H30Iw1aFtCnDlBKhBZclWxWVmZRkHmb1ZRCuBfq69cVWiCUq9zYR41bu4Seq8xsIFjkdsCO/0whW5PC7B5QShn0ZSKHscJxSvkFUL9awed81BBsWHLPFgfBujV9chogm2w/6BaJKaERhSoWDpnd0+F77KBvEbjD4CictpZ+7X7uIHHIL6raEax4TMEJeFPtO5Do6pexNIhbg376dANNWUmYBosCHHVJqYntzSHGLloUobkT6KJ7dlvOczJb+en3VHfSXR3j9jnZ4ZxNRlwbYaJ/jdjuUgYJ+lTvyC7R0NyRPxWNHCQBG9rKzeS8Elcj2t6P3rfhBhuJyQsCfpKPEHzpcYJFHbsVjn+kf7hwBLYgn6WY0FMmJew=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(38070700021)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QW02NlV0dmJrZDA2Qk5YUDhVNjVKTXBvbkd0eXR4cnBONmdzYy9XVVVQMmRk?=
 =?utf-8?B?Vy9iOExUOEVTWDRwQno5aHovRW40UEZiUDFkNU1PSVRPaVhyUUEzWDVLLzMw?=
 =?utf-8?B?eHFuL05UaFYrL3JuclJoRFJyeWdkazljaUI0L2RKRUxCTFMrcG5PVVlYVEN2?=
 =?utf-8?B?R2plT1MxQ0I5UURCWUREQnl2eUVGdTlocWpOQi9ra1Yxc1NIWGV5N3NHMEZs?=
 =?utf-8?B?RjJzUFhFdGxqZFV4SEhYaDBEZWR4a0lRa0orVTlWa2xYelBmcmZPVlAwZG4y?=
 =?utf-8?B?TWNPaVFJODJJbEllci80ajBWODhsdWMzSkhmUFBwWFdJbzJEdTJ1aldWU2hX?=
 =?utf-8?B?bjdZTFFtdjA2WHhJNDdyeUVzVnhuZDhwWlNEamRoUk1RcStUKzF3d0laMlc0?=
 =?utf-8?B?N203Q05RVDc5S2E1b2ozb3dkYlVNdHFpMlhhVEpBMVFQa2pWdEVSWDF1czJx?=
 =?utf-8?B?VFdXMkZUeDRFR0k4VWQ5T1BETE83cndPYzdZTURMS1dGd2VRb1h0WUI1d0xE?=
 =?utf-8?B?UjFaTGhEd1I1TitIZTBJdFdTakFWTlUyYVNjMUlBalpNMTJOUkVGaDNzWG9h?=
 =?utf-8?B?NFlTTTZhVVkxWVZKTmR4OTBEaXhLMkl4QzRzcFZ4SFQwOTNSbFdrUXZmWSs2?=
 =?utf-8?B?SGJ3RGJMS0lDcDlsWFZoYjdBK2Q0cFVKSldjOTlzaUgzb2hsU21tL25mYXg0?=
 =?utf-8?B?bG1qVDZlaVBaRkJDandHMG80eVlMdEovMWs0d1F1MnhkQzRhVFk5eW1uQjcr?=
 =?utf-8?B?cklaeThoOGlsdFFNclVVRVVoSzBoUEpTbW5JeEx0eC9HNGVyZVRjWWY2cUhE?=
 =?utf-8?B?U3dpMG8rK0t4cDZydU1uQW00dlVxV0xaTUxGb1diSFNrbGROSXdtSkZPVkpM?=
 =?utf-8?B?emJMR21ic0gyODRSZTM3UW5pbTRrQUw0OXd3aElzNFM3RzcvM2Rtb0ZzSGJ1?=
 =?utf-8?B?ZS8rOWw1UkFwYVJic1k5eHFzV25RK3RXR1RrN2w0RkJYMlBWc24zS0VXYlV4?=
 =?utf-8?B?SGh1SHk0cFdRM3pPbkh5dzlzRDNNOEU4WUZQVWo4alVsNURCbC83VXQ3ODl2?=
 =?utf-8?B?cEJrNlArUXZyR3hXMTR2Qmd4bFNhY0ovTkQwK0YvbGsrdk91bkJRQXlHc0dZ?=
 =?utf-8?B?cnVkZ2lBcjZYd04wcE5YcFJCMnVDSVFJbmQ1ZHVFYzNFSERSSVRNRzA0UHBG?=
 =?utf-8?B?ZlRkZGFFWjYyUm9RQzZsZEtrUEhUVWJrVEdheUJ2M3dBdDZROFVyeEpReDYx?=
 =?utf-8?B?aUpIaXdjM2E4MEJQQWhxQzlvak9NcG1CNGIzVmIxWnpmSFdqNFM1SDhhY2gy?=
 =?utf-8?B?M1NwMWFDYU5KaEtHcjRkWTVoSllaT1U1d0hlS2psckJkdWgwSGpFZFBKb01j?=
 =?utf-8?B?LzFRU2lQRUJDeEdwVWJvWkJKUmx6VG1qMlh1ejh4UmF4aUxVWGxrbkZuY3dX?=
 =?utf-8?B?T3NmQnU4aytLL0hybHE4MFk4ZjdZYjVObS8yRXdtQURMZnNCc1ZOc2MzZ3BW?=
 =?utf-8?B?R1IyWnR6eHJ6ai9zRmF6R3BSVFQrdFhFQnhkMTN5Mm04TE1BZUc3MW0zQk9k?=
 =?utf-8?B?VTBjK0k4cHVyTW8yWjJ6MElra2dON2JDRUEweFIralBITWw5eFFmRG13ancv?=
 =?utf-8?B?RnFTZDU2WS9lbzNyeE5wdVNjRGJEQ294UEEra08vck04N2dxYmVzbWlyL1lM?=
 =?utf-8?B?dVYvLzFSalF2UDkyc0Zlc0U5MlMwTjNaMWk1eE5BSU00MGZuN2lDSVFLYVBW?=
 =?utf-8?B?bE9ZWjBxYVRkb3U1N3hDZ0VqWEs5OHpsVU11dGdoZVcxaGlWU0NuRW00eW5u?=
 =?utf-8?B?ZGdFd2MvR3VsOXVld3dBUjBJTTN2WTA3Mi93SUZHTEtHWjMyRy9reWJFU2VG?=
 =?utf-8?B?YkJldGluNHpTNk5wU0svWkgrbTlFYTJLd0Nzb3g5N2tud2JPeUZzNk9BcWtp?=
 =?utf-8?B?WUxYMG9rL1hCeERPQ3pDeXZtU21IRElJeEpSaXQ5ZUNrcGRZT3Y2Z3dmSWpI?=
 =?utf-8?B?NE5CcDRKckh3QjY3bENRemV3WG9POVJsQi9DKzY2WVk0UDVpNGgxRGxYajlQ?=
 =?utf-8?B?Z0dPUCs5dmlUMHh2dlg0NGhVRkJ1encxUSszQTBNSVkzSFRFZW8waDNJR3hS?=
 =?utf-8?B?TFh3WEh4R3lYNHNpT0dzeHlNR2gwU0I2Y004YnJjYnNWSWh6TDI2WFpRUWlZ?=
 =?utf-8?B?ZlpDY1NyQVVyKzUxZStIckg5TExBTitnS1BFcVV5eDZJZHZrQTZMdmJNbkhS?=
 =?utf-8?B?a0xkTmc5bTF5T0RUVTN6TXlTbFZLYmFybW0wbGhTak5zWjkvdDZKLzFwS05u?=
 =?utf-8?B?N1BCbDJnZjJyeC9oU3NXQ3FSYTlyZWRlcHpkbHgrQnlaSTZBdFhqZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: l1tuFsmkkBVburs7sT2o1iQrFh90JlbHylMQMJt8aGT1ePrNGLLGaFUTyC2208nA2v2T/mc1c5eNqCK4lQp5n93whRCn6EwuPashR/jP3DCTq1sZRRHRoiu9pNnuMGxe6BnHsw7fshuNqo6FWabUaDpLmliZvUkbvE8YdgkW4IyYF9CbYOgmd4nj+Qtavh02RDtB9NtTE8DWqeWDaLF8W26fwzrlhzT+jmMjPyILoeB8F59zgMqddv1wywb14kmLM8pabrsgVXs1XzmTFkINRsk7f9Ot8JLhtb/2lVZ83i8p2KXEwOxWqYzDJmL0YaYS3QEPNvEPCipwc92MzIOpHg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb74090b-2dbf-4932-9cce-08df0dc932d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2026 16:49:50.1636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yP2G2wPfNA4LbZwbORcddyHOW/DH4JaiHgQn68LyUfRmzMCrUpkHBpTfVUFaglHKbkH/fb0HR/Sbsmzh6HwXwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB9660
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F3D7100003
X-Stat-Signature: qojcf998srcat57imbsq8wme8rq9tyic
X-HE-Tag: 1788886194-44884
X-HE-Meta: U2FsdGVkX18RE6ZKM+jsjFh1MEns1pLf+2Z3EIYNSRV7d2S14gUBw7KBstdWwAlICa8jn/B2OPGiOqvN9HMXGb+SchxtZ+rvShBQhwXCGqQMiscnKAo00AjS1mN4HMp8VDkjVaU5nV13qYovHRT06/+beB28RhpAV8gm9i+Qa9Cuokv+SZp17YfrA/fm8TZ6BVQW7kMER+M+cuOkEKkKLSlhH7d4s3nKizAbp5Hezg71VG/ydNp66QzH6fwJpzuv13I+6NilCHYFfKg/V0VcSvZ8XpriiHkz7A8a5yvN7T8qeqTweUAAksDD0iTUELlekc6XoGLbn+8yms2WwWTE+9ebqGnzSPjN5bJzfQk7rBIJeoUrKmoFdSBN4L29kgTbN4g1o85i5mpKTOlcn3hmBiypZuOY0p2Gh+walzyZN9LsadHVbsqvDHZu/5bqnHzWyI+fja2D5HVOH/my5htHJIPflNpdXQ5NiJtSySe32eO/HDBDNXP2no9RPRR1Ome497SaW/qftYC1noJ94WL8lqQFIGo7gEGgHOPaSf57XSQV9SF3szJAxtB8+rNziFt+gjSHwb6cV4eI8PHurepuZnqagYyL/r0HWHbVdQppsefg+d6rsB2F98OqavS+3mjiZKTb6oB0Lz+iN0vrkVGBMBbefz46QeiiKALQg2AvGaIwBUe0uTXYNxaG+gRhGR2wuP1VNgiP0jK1eL6wuMbOP09mq2yp+KPjyEskYhryMWYcM3C7H96DdFCLLHaKON3jMWeheQMWgThoGN3TvuxHO0vjP0ATgxrmmNWTzLSLfWO5GgUmsQHum+v6x8Gv1xuD2scaoj0JFv0GMfxqTJNbN+ppxLE8LJ0huEO4eMLiikUn6JyJjvNZm00HFDIliU0k1plpwWtCeqwGcQZyBq4bNU7k83QMBQ5PNay3jUSd87dULVfnfrHM2GuSHXWpXuMAOcvANi0Z2vNcaB6ljco
 g2DljvgP
 T+4Ke+a1NQmOmgr8dB9kU4ddfsY2Y+lsQQlQ37FZLfQ2emI7jGh1WHElCpdJveu+QfB2B+mMy2nWZftTbddetSM7Ovy45BwZFzsODhvz7A9wJt2lSDVW1H2jqpUeMMJiFN9yyyWRk8QU3CHjddA+aeWzA1fdG5O4+Am5Qjot+Ty01kGEZhzfWd0/h/5cyreqQmhMF2NDdgiO0GnA3fk5mDToi5h9bbtOxzOJtZf3xXDcgIRJWb1yD2aVvM05gs6YU+AqvH9bp7yrNdAsoWDiQ12gYwmrfPIBLe8S2mwECw3/PNRanQb8pDu2p0hW7Qa7DKoSmARGVnh6LM0azmeIJTov11ap+sS1Gf5+bnpSGhGWpWYDyqeztjxoK2CbTrC2+y0GtdXSVfMilO+pJs721XUyjHzU9/xWdd483YH4jJA2G5kHdSxDMf5L9hx2y7sfKPuK3TnYCkv7cUdwaZdUJx6T9ZyrQku2vEQIcs181SvTyItc3zhi+1NzMUo3IWsUwpuawV/aMLPshBRAMOyTCticrkC7kBKuFlLMz72BLz7YZzGiPZOaYQn+x7CF85ldRDbEIm+5cJu0Zbp7Nn4FaSzg+1ACMym6WMqx6rwuKx9Dk445io6eaGwO29yv1XyA2A1GbIMtC3w5lQa47tEI05LIOLbaPbl72TNaaCdoa25RkZV51hVQSTgTAz3JQ9Q769kRWedscl4BV53xzeYulh/CRsvxkPZOd911lQxJcJt4fW6sEYQD9xI7fnqxfS/SOLSyG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFycnkgU29uZyA8YmFv
aHVhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgMywgMjAyNiAyOjM4
IFBNDQo+IFRvOiBBYmFibmVoLCBFaGFiIDxlaGFiLmFiYWJuZWhAaW50ZWwuY29tPg0KPiBDYzog
cnluY3NuQGdtYWlsLmNvbTsgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsNCj4gYXhlbHJhc211
c3NlbkBnb29nbGUuY29tOyBrYXNvbmdAdGVuY2VudC5jb207IGxhbmNlLnlhbmdAbGludXguZGV2
Ow0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7IHFp
LnpoZW5nQGxpbnV4LmRldjsNCj4gc2hha2VlbC5idXR0QGxpbnV4LmRldjsgd2VpeHVnY0Bnb29n
bGUuY29tOyB5dWFuY2h1QGdvb2dsZS5jb207DQo+IHl1emhhb0Bnb29nbGUuY29tDQo+IFN1Ympl
Y3Q6IFJlOiBbUkZDIFBBVENIXSBtbS9tZ2xydTogZHluYW1pY2FsbHkgcHJvdGVjdCByZWFkYWhl
YWQgZmF1bHQNCj4gZm9saW9zIHVuZGVyIHJlZmF1bHQgcHJlc3N1cmUNCj4gDQo+IE9uIEZyaSwg
U2VwIDQsIDIwMjYgYXQgMzo0NuKAr0FNIEFiYWJuZWgsIEVoYWIgPGVoYWIuYWJhYm5laEBpbnRl
bC5jb20+DQo+IHdyb3RlOg0KPiBbLi4uXQ0KPiA+ID4gPiA+IEkgZ3Vlc3Mgd2UgY291bGQgaW5z
dGVhZCB0cnkgdG8gbWl0aWdhdGUgdGhlIGNhc2VzIHdoZXJlIHNvbWUNCj4gPiA+ID4gPiB3b3Jr
bG9hZHMgYXJlIG5lZ2F0aXZlbHkgYWZmZWN0ZWQgd2hpbGUgcHJlc2VydmluZyB0aGUgb3JpZ2lu
YWwNCj4gPiA+ID4gPiBpbnRlbnRpb24uIERvZXMgdGhlIGZpeCBiZWxvdyBhZGRyZXNzIGJvdGgg
b2YgeW91ciBjYXNlcywgb3IgaXMNCj4gPiA+ID4gPiBFaGFiJ3MgY2FzZQ0KPiA+ID4gYWN0dWFs
bHkgZGlmZmVyZW50IGZyb20gS2FpcnVpJ3M/DQo+ID4gPiA+ID4gKFRoZSBrZXJuZWwtYnVpbGQg
dGVzdCBvbiBteSBtYWNoaW5lIGxvb2tzIHF1aXRlIHBvc2l0aXZlLiBJdA0KPiA+ID4gPiA+IG5v
dCBvbmx5IHByZXNlcnZlcyB0aGUgb3JpZ2luYWwgb3B0aW1pemF0aW9uLCBidXQgZXZlbiBwcm92
aWRlcw0KPiA+ID4gPiA+IGZ1cnRoZXINCj4gPiA+ID4gPiBnYWlucy4pDQo+ID4gPiA+ID4NCj4g
PiA+ID4NCj4gPiA+ID4gSSBhZ3JlZSB0aGF0IHJldmVydGluZyB0aGUgY29tbWl0IHRoYXQgY2F1
c2VkIHRoZSByZWdyZXNzaW9uIGlzDQo+ID4gPiA+IG5vdCB0aGUgb3B0aW1hbCBwYXRoLiBJIGV4
cGVjdCB0aGVyZSBhcmUgbWFueSB3b3JrbG9hZHMgYW5kDQo+ID4gPiA+IHNjZW5hcmlvcyB0aGF0
IGJlbmVmaXQgZnJvbSB0aGUgYmVoYXZpb3IgaW50cm9kdWNlZCBieSB0aGF0DQo+ID4gPiA+IGNv
bW1pdCwgc28gcmV2ZXJ0aW5nIGl0IGNvdWxkIHVubmVjZXNzYXJpbHkgcmVncmVzcyB0aG9zZSB3
b3JrbG9hZHMuDQo+ID4gPiA+DQo+ID4gPiA+IEkgd2lsbCBydW4gdGhlIENhc3NhbmRyYSBiZW5j
aG1hcmsgd2l0aCBLYWlydWkncyBNR0xSVS1GRyBwYXRjaGVzDQo+ID4gPiA+IHRvIHNlZSB3aGV0
aGVyIHRoZXkgYWRkcmVzcyB0aGUgaXNzdWUgSSBhbSBzZWVpbmcuIEkgd2lsbCBzZW5kIHRoZQ0K
PiA+ID4gPiByZXN1bHRzIHdoZW4gdGhleSBhcmUgcmVhZHkuDQo+ID4gPiA+DQo+ID4gPg0KPiA+
ID4gVGhhbmtzIHZlcnkgbXVjaCwgRWhhYi4gQ291bGQgeW91IHBsZWFzZSBhbHNvIHJ1biBteSBw
cm9wb3NlZCBxdWljayBmaXg6DQo+ID4gPg0KPiA+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
bGludXgtbW0vMjAyNjA5MDEyMjA0MzAuNzk4MTAtMS0NCj4gPiA+IGJhb2h1YUBrZXJuZWwub3Jn
Lw0KPiA+ID4NCj4gPg0KPiA+IEhpIEJhcnJ5LA0KPiA+DQo+ID4gVGhhbmtzIGZvciBzZW5kaW5n
IHRoZSBzdWdnZXN0ZWQgZml4LiBJIHRlc3RlZCBpdCB3aXRoIHRoZSBDYXNzYW5kcmENCj4gPiBi
ZW5jaG1hcmssIGFuZCB0aGUgcmVzdWx0cyBsb29rIHByb21pc2luZy4gQWNyb3NzIHRoZSBydW5z
LCB0aHJvdWdocHV0DQo+ID4gd2FzIGFwcHJveGltYXRlbHkgNDkuNEsgdG8gNTAuM0sgb3BzL3Ms
IGF2ZXJhZ2luZyBhYm91dCA1MC4wSyBvcHMvcywNCj4gPiB3aGlsZSB0aGUgOTl0aC1wZXJjZW50
aWxlIGxhdGVuY3kgcmVtYWluZWQgYXJvdW5kIDcuMCB0byA3LjEgbXMuIFRoaXMNCj4gPiByZXBy
ZXNlbnRzIGFuIGltcHJvdmVtZW50IG92ZXIgdGhlIGJhc2VsaW5lIG9mIGFwcHJveGltYXRlbHkg
NDMuOThLDQo+IG9wcy9zIGFuZCA5LjAyNSBtcyBwOTkgbGF0ZW5jeS4NCj4gPg0KPiANCj4gSSBh
bSBoYXBweSB0byBzZWUgaXQgaXMgbXVjaCBiZXR0ZXIsIGJ1dCBpdCBzdGlsbCBkb2Vzbid0IHNl
ZW0gYXMgZ29vZCBhcyBpdCB3YXMgYXQNCj4gdGhlIHZlcnkgYmVnaW5uaW5nPw0KPiANCkhpIEJh
cnJ5LCBBbGwsDQoNCkl0IGlzIG5vdCBhcyBwZXJmb3JtYW50IGFzIGl0cyBiZXN0LCBidXQgaXQg
cmVjb3ZlcnMgbW9zdCBvZiB0aGUgcmVncmVzc2lvbi4gRHVyaW5nDQp0aGUgcmVncmVzc2lvbiwg
bGF0ZW5jeSBoYWQgc3Bpa2VkIHRvIGFyb3VuZCA5IG1zLiBBZnRlciBhcHBseWluZyB0aGUgcGF0
Y2gsIGl0IGhhcw0KY29tZSBiYWNrIGRvd24gdG8gNS44IG1zLiBPdmVyYWxsLCB0aGlzIGlzIHN0
aWxsIGJldHRlciB0aGFuIHdoZXJlIGl0IHdhcyBhYm91dCB0d28NCm1vbnRocyBhZ28sIHdoZW4g
SSB3YXMgdHlwaWNhbGx5IHNlZWluZyA2LjIgdG8gNi4zIG1zLg0KDQo+IC0gd2l0aCBjb21taXQg
NmNiZGQ5NzI2ZmI1ICgibW0vbWdscnU6IHVzZSBmb2xpb19tYXJrX2FjY2Vzc2VkIHRvDQo+ICAg
cmVwbGFjZSBmb2xpb19zZXRfYWN0aXZlIik6DQo+ICAgcDk5IH45LjItOS41IG1zLCB0aHJvdWdo
cHV0IH40MS44ay00My42ayBvcC9zDQo+IC0gd2l0aCByZXZlcnQgb2YgY29tbWl0IDZjYmRkOTcy
NmZiNSAoIm1tL21nbHJ1OiB1c2UgZm9saW9fbWFya19hY2Nlc3NlZA0KPiB0bw0KPiAgIHJlcGxh
Y2UgZm9saW9fc2V0X2FjdGl2ZSIpOg0KPiAgIHA5OSB+NS41LTUuNiBtcywgdGhyb3VnaHB1dCB+
NTEuOWstNTMuMWsgb3Avcw0KPiAtIHdpdGggdGhpcyBmaXg6IHA5OSB+NS44IG1zLCB0aHJvdWdo
cHV0IH41MS45ay01Mi43ayBvcC9zDQo+IA0KPiA+IFRoZSB1bmRlcmx5aW5nIGlkZWEgaW4gYm90
aCBzb2x1dGlvbnMgaXMgdmVyeSBzaW1pbGFyOiBBIGNyZWRpdC1iYXNlZA0KPiA+IHN5c3RlbSBw
cm90ZWN0cyBmaWxlIGZvbGlvcyB3aGVuIHJlYWRhaGVhZCBwcm92ZXMgdXNlZnVsLiBJbiBteQ0K
PiA+IHZlcnNpb24sIEkgZnVydGhlciB0dW5lZCBjcmVkaXQgYWNjb3VudGluZyBhbmQgdXNlZCBw
ZXItQ1BVIGJhdGNoaW5nDQo+ID4gdG8gcmVkdWNlIGF0b21pYyBjb250ZW50aW9uIG9uIG11bHRp
Y29yZSBzeXN0ZW1zLg0KPiA+DQo+IA0KPiBZb3VyIGJlbmNobWFyayBzZWVtcyBxdWl0ZSBsaWtl
bHkgdG8gYWNjZXNzIHJlYWRhaGVhZCBmb2xpb3MuDQo+IExldCBtZSBkaWcgaW50byB5b3VyIHBh
dGNoIGEgYml0IGRlZXBlciBhbmQgc2VlIGlmIHdlIGNhbiBmaW5kIGEgY29tYmluYXRpb24gb2YN
Cj4gdGhlIHR3byBhcHByb2FjaGVzLg0KDQpZZXMsIGl0IGRvZXMgc2VlbSB0byBhY2Nlc3MgcmVh
ZGFoZWFkIGZvbGlvcy4gSSBhbHNvIHRoaW5rIHRoaXMgYmVuY2htYXJrIGV4ZXJjaXNlcw0KYW4g
YWNjZXNzIHBhdHRlcm4gdGhhdCBpcyBnZW5lcmljIGVub3VnaCB0aGF0IHNpbWlsYXIgYmVoYXZp
b3IgY291bGQgc2hvdyB1cCBpbg0KYSB3aWRlIHJhbmdlIG9mIHJlYWwtd29ybGQgYXBwbGljYXRp
b25zLCByYXRoZXIgdGhhbiBiZWluZyBzb21ldGhpbmcgc3BlY2lmaWMgdG8NCnRoaXMgcGFydGlj
dWxhciB3b3JrbG9hZC4NCg0KPiBCVFcsIGRvZXMgS2FpcnVpJ3MgTUdMUlUtRkcgYnJpbmcgeW91
ciBiZW5jaG1hcmsgYmFjayB0byB0aGUgcGVyZm9ybWFuY2UNCj4geW91IGhhZCBhdCB0aGUgdmVy
eSBiZWdpbm5pbmc/DQo+IA0KTm90IHlldCwgYnV0IEknbGwgYmUgdHJ5aW5nIEthaXJ1aSdzIE1H
TFJVLUZHIHRvZGF5IG9yIHRvbW9ycm93IGFuZCB3aWxsIHJlcG9ydA0KQmFjayBvbmNlIEkgaGF2
ZSBzb21lIHJlc3VsdHMuDQoNClRoYW5rcywNCkVoYWINCg0KPiBCZXN0IFJlZ2FyZHMNCj4gQmFy
cnkNCg==

