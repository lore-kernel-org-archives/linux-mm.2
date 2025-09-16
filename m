Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0623FCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3B48E0015; Tue, 16 Sep 2025 14:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3842C8E0001; Tue, 16 Sep 2025 14:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225178E0015; Tue, 16 Sep 2025 14:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 103108E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:08:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B67EAC0295
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:08:41 +0000 (UTC)
X-FDA: 83895898842.19.22FA612
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf15.hostedemail.com (Postfix) with ESMTP id D2405A001F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:08:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OGBr1zc7;
	spf=pass (imf15.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758046118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNpfxqQcjM1YO9NoL/GWaJJuAxsHDXaSHEHbqd6PtCs=;
	b=Q3anOQb8S0C2jpjGM9TB8H+QjIVl5wbDyaXOhnes42ZvfLbu9L2KP2f1HPJdEs7ovco+DS
	6rfQRCnOi73+I9wzSNLwnSS1/x6Eba8FL/uoNrAKGqXe1hg/GeGkHiqV/XroJFtWUtVuO2
	ZsjLJr/5zdUfSeiSIaLXAoDCQfdt3y8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OGBr1zc7;
	spf=pass (imf15.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758046118; a=rsa-sha256;
	cv=pass;
	b=Z6lrYKvjC/1VotOjC5C3nLJ62ci/yZ0t9JqcfSX1MBqIN44sLjzPFWwa5VKWJS1J9YGdBD
	c/i0S3OwvFntdFusW3HYRpqnzjOyhqxvbxYL17E0rzHfTo0MABECRGItU72a9o78kahyTf
	Y+vRtWB1yYZmVEDOSrShgn0zrq41pbw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758046118; x=1789582118;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KNpfxqQcjM1YO9NoL/GWaJJuAxsHDXaSHEHbqd6PtCs=;
  b=OGBr1zc7co/F7HpteGdTd1+qfZ8j9iurdNyJdPr9dDJi9D9dC0aaNCDt
   ra73dGYF8ORSmu8WDMs/4djzrWwg5yNcqPa8eOIHMRyI+AszS3GlvJ3X3
   4v+SVm24q8q5L5Po8IpQGIAfwzsBQGfaBqMXro3R7m2rqePETntmd6Eed
   71GTKHtMDYmGB7GH48+zXxkWFMmhXnBLAGC33XHqhyhZPxJAnmRKo2bmK
   nr5QRY0C68c5seFG0H7iWYBZnznphjK1oerNb7GKkAbxXI1UQWawMMkbB
   syZj4JKilxuYL2BtjbDUzSnz59ZL3cj+BUSnnPMkX58Oj8lkXRfWD4j7T
   Q==;
X-CSE-ConnectionGUID: 1ZKLmkVjRe6vjVKGs4bd6w==
X-CSE-MsgGUID: MYy4aBHjTOOjbC5F/An3nQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="70962399"
X-IronPort-AV: E=Sophos;i="6.18,269,1751266800"; 
   d="scan'208";a="70962399"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 11:08:36 -0700
X-CSE-ConnectionGUID: XugyXWR8QiCyVeB7j5Jv9Q==
X-CSE-MsgGUID: jnfOB2HKTBWyDGjXMYYk1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,269,1751266800"; 
   d="scan'208";a="174308101"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 11:08:35 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 11:08:35 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 16 Sep 2025 11:08:35 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.11) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 11:08:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qFNpDC+fPyUDRB8bK++9eXmXfhCgroXq98I8fUgflvew4ZxOlHOj8dbUVsgA2CiDbj6km0yDle4JhudXKB7+eEE3dPOOXzKWG8CSjIZnIPLBpFMbMuIfIcpunFFDDrexZaukkM4Ideehqb9uopNn0EiRPJAAKiHassXe3tUEWhJZMWcHFNHCuXL4ZYWXrQj7rk5TG9FeCIXQUPQMjUZuBqfJCbIkQc83S9qwHQjyegpZQ6cUkzY/CyZps5+qb1KC+90JhPZ1uckMD31iZkxi8K2ChUve5/xHfdpxvl161HnhwFyDeSKFwgGHrB5K1Frc4YuNmThyY30yyqJFo9Ox2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNpfxqQcjM1YO9NoL/GWaJJuAxsHDXaSHEHbqd6PtCs=;
 b=K8Lv//rXILCAAONrwIlmPqkh75OLWH7uC1ASIiwFZGPrLzfFc4AJ/12p5zxHtoa8jOvkUpqhhReIrldXfVyNjSA33EVMEPYXLI86uJPhNm02MbH8somF6b04vvCJ+xAP4XDZIyYKD0qgFCiawEUrQIGtlK+cohKXF0PDSHcjzMAmvHYLaP36ODnJ0owfTVTScBbRrs6gt0i7qWeOURi0y2ZcoUV/XTGk/tRRUKTVuACTrIoJqgDRTqiaPlrU8DGcEFRx+FaPNJgKpp0HkaVzapRY00YC7kW2PQZuAd3d2WcuZuZGVfuUCjqkYNr45LQHP44KgZI+e0D7HeOSJzHfEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB6218.namprd11.prod.outlook.com (2603:10b6:208:3ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Tue, 16 Sep
 2025 18:08:31 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 18:08:31 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Meyer, Kyle" <kyle.meyer@hpe.com>, "Fan, Shawn" <shawn.fan@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, "corbet@lwn.net"
	<corbet@lwn.net>, "david@redhat.com" <david@redhat.com>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>, "shuah@kernel.org"
	<shuah@kernel.org>, "jane.chu@oracle.com" <jane.chu@oracle.com>,
	"jiaqiyan@google.com" <jiaqiyan@google.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "bp@alien8.de" <bp@alien8.de>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "jack@suse.cz" <jack@suse.cz>,
	"joel.granados@kernel.org" <joel.granados@kernel.org>, "laoar.shao@gmail.com"
	<laoar.shao@gmail.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "mclapinski@google.com"
	<mclapinski@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "osalvador@suse.de"
	<osalvador@suse.de>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
	"rppt@kernel.org" <rppt@kernel.org>, "Anderson, Russ"
	<russ.anderson@hpe.com>, "surenb@google.com" <surenb@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Thread-Topic: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Thread-Index: AQHcJqDfpZlme4fMVEeHtkBl9XAZ4LSVI0cAgABCfoCAAIYXcIAALjEAgAABY3A=
Date: Tue, 16 Sep 2025 18:08:31 +0000
Message-ID: <SJ1PR11MB60833884799B6AA2BC18ECE7FC14A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <20250915201618.7d9d294a6b22e0f71540884b@linux-foundation.org>
 <aMkOCmGBhZKhKPrI@hpe.com>
 <SJ1PR11MB60831F028E2FEB6B5A3390D9FC14A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <aMmlhPghbpnlCZ09@hpe.com>
In-Reply-To: <aMmlhPghbpnlCZ09@hpe.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA1PR11MB6218:EE_
x-ms-office365-filtering-correlation-id: 27c34d14-1d44-4827-9a30-08ddf54c0b3d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?hvdkty3u5908/dzjaJr1k12uIaun7aELs9GkAV/mBf63z/1/CVR2JvT49TWZ?=
 =?us-ascii?Q?S0VeMTSqoWPSequBBgQ9/RiSQY6N1RMM/81ILgNma7jddYomRpb4JwaDnegC?=
 =?us-ascii?Q?lA4Nv3M7xy3EJu9cCZUEyfcoIwnfuTkJ8M78EplEXSznK34WA43VLyyXTO57?=
 =?us-ascii?Q?zOYc0R0KWtvW+anFXwNnIOAaS2eSXgp2gQZ+gaT6aCwAwTtb2KbcZD++enfP?=
 =?us-ascii?Q?EtXZMvqIJtbU7TcJanmeCSLRE1CDLo/dgt1nRPqZCmnyI9alQL884oMkIUsP?=
 =?us-ascii?Q?kGoTTrGNLijqpweaPKYbTVfA0Iu+eRFmKhca2N9144xrzK6e3mxopAw3BU73?=
 =?us-ascii?Q?FLVU7o+FqvU+j7223Ki8fzM0RyJRpS55zUGYGXkHXK563PSI54jrE86U6fXa?=
 =?us-ascii?Q?PEh94TP5rbDoVeSbX+m/6Q/0aFbtTiSlmxlpr+mHiq891xc/oTbvP9TgJ3y9?=
 =?us-ascii?Q?nWtUp5v8O2OF7EMO1EwXvdCa9pvyrpRbzcHW45qH5imyvdDopP751UnnHzQ2?=
 =?us-ascii?Q?l/PLtBV57s3vEreM3ln2M1vdglts4hfqyGfUwwEYU5t24kohX6ayhRlgRlLC?=
 =?us-ascii?Q?Kx8FqN25Rwh75i4aCs0cL9eNZtntJySiTT18fQlqH+NthJ+5XfK1j+QTZJhD?=
 =?us-ascii?Q?oHO0o2fWD6JiXSoSt4d0oFwss1m3X7F1qJq53ZZpFpl5/i4iaiRBWAFU2dM2?=
 =?us-ascii?Q?ITKMLar8y5DcsToocd5CpEML+SND4eo3s4Mb+2ZqRP7e+IuxVnia3/sGZcur?=
 =?us-ascii?Q?uGOByn4I00Gd8BL2KIyZgTHbY5b3D+dKLJEdIn3Bty2iD3EjqCXIXfjWDMv3?=
 =?us-ascii?Q?HFwbRObeOK8+/mhN7ADuH2Rm/6h8syTcVf1zbLzu7OqBV//5v4fvxj+zrp5a?=
 =?us-ascii?Q?v2m5oHjjT0vJrKd69ibi4uDBRU9+iPBigAnyobqH4kUD78D9VAH8/sZp6WPP?=
 =?us-ascii?Q?jdtUgmZWC12akFI9lsIuaC2E7TyZWtZzR65f2zkMINPn/5UqSb3m9acTh2Vm?=
 =?us-ascii?Q?tDIYZdgR8jGiIWK6qCPaar/64MiDXpQG1ynOcBb48V1Wv/v4a/WgkRR+9Yvs?=
 =?us-ascii?Q?AP6cxHFpffHXmEn8k0cT2PIhjfIFfdKMGL6BlZDODYenIgj28IgR6vDczZXU?=
 =?us-ascii?Q?/d4dnGwGcgrxaFBtn1pGP8BdlyNqJ8dUHJ0acOjJtyrz/vMcwc/t/XTuD/Kx?=
 =?us-ascii?Q?b2TYvh5RC7/HtlhQ8WBjFSuswtY+geEDK8sHLuZ/XqvZNm63A9G971Q8lf84?=
 =?us-ascii?Q?ubJzog+X0Pl5/BaA6amWBYr5mUb0cgpe8yK8WdKcaI9zAM2imJw3ITAO8NVO?=
 =?us-ascii?Q?HyI2iePWJ5RNnmfEvlNSzmLsNUwxm+8KrQuR3XggaUEavjfZRrx2p/aEGRKC?=
 =?us-ascii?Q?INaghA9DwzJUFURmeITq/bMtFUH80ygQnzSrbep4aCN3vgXw28hDhBgfESdF?=
 =?us-ascii?Q?MjfODL00a8hrAdB4XgXwmQBQdHOBlVKe0oeGTRsdWckkXHnGACG5wQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vJS15P+meY7Ex2o2GXMo8zjH3SWdnF093Ly2pa7P6ByruEYjGPcpzQ+BzAf1?=
 =?us-ascii?Q?s2aYfD9JQ0IGol+0ZD4Sm0jPNRzfQunfh9Xc0BGHgWgPTupBt6QCJhECfsTd?=
 =?us-ascii?Q?zjbjFs94fU40kWYX13vS5Y++oguT01jMY1reWECErlhVUZ8HM1Q9mdsi4NuN?=
 =?us-ascii?Q?sAdP4WZC0Sbjg8I0hmXQU49kjOwVdnohdUO6L7mbcCm1oH4FMTKJNnQJcSQu?=
 =?us-ascii?Q?WNr5siL2N1bJ0/yLttxS+iUhoFa9j7gjXN2obWq/rIGpcjWfISMrB/QX6R8U?=
 =?us-ascii?Q?jXNwtLtFHIwhOznehioGxEPwoC0lVUn6d9hQGrwEOCpSmBfunpMiv/R1PBXc?=
 =?us-ascii?Q?DpOffsMnCAX7wjGzcniY92G7kgbOnfRNkkP0HvjTc7pLYC5Zjutl75gzZcEI?=
 =?us-ascii?Q?+GBHmOV52/fBQ4z2vRHhsGhK4KTwCrE90u6yVlOmwtqaR98mjfE37M1H7ez7?=
 =?us-ascii?Q?xzp4XSun4/gFzoHIeRP11EokJq826vxkvH94s50QHpOgsJEAc3PLbQ0knUHJ?=
 =?us-ascii?Q?PfSAXkpvK1oJNHjggSUmSVxHcAHfQ+Sbhw0YrjHrR4hG3i5nSGqiVciHWRUH?=
 =?us-ascii?Q?U3kWmtjDH0zjCM60TvwEYWyftKPHFjLxsoJ0Cq+RK3+KUY4WdDfhBu8IUwpn?=
 =?us-ascii?Q?xJ9nqx9k56ui/SV6AJH+BDaloW6dR0BVJvzMJYtGD4KfdwmWW3vbxtmfHBIW?=
 =?us-ascii?Q?VFFD+k0YwSPHirVi0t4sftqbd3nk7KqGZR/Qh/iAd1uziOwzl2fC5fMgq57L?=
 =?us-ascii?Q?EYrzNikYECY4LNhHv18lDR6sW8bgFZDaUGIwS8Mih2DhVDufe8of4jlDiqh0?=
 =?us-ascii?Q?hjNjcc4rGTtYjiE0mlAa1yP72qqydWAs197Gt6Rc2Ma83BS2+poOs7qiTzk+?=
 =?us-ascii?Q?JvqPith3rhoZyVlBoYjVPB5lt+i495WPONAvCgrqjK8PDMmNrKxJS+YnkcU2?=
 =?us-ascii?Q?DUDn6jM1pc5zQol4hrqvcUZdoaHeTMwiZNWSH4QLRcxUk2uAGC+IsPw14ooT?=
 =?us-ascii?Q?SEVtIZx1q2yhzJpP1EMU8Q2bd0FoF63CZBcZ+0AE0r5WgE/e58XE6UOGYL3r?=
 =?us-ascii?Q?cb8nJH/d/Jso9ZcRlDnQp2m4iaZ6cnW+P+NndadPadqiC0BkeZ/hAD7HUnfE?=
 =?us-ascii?Q?ylW1lXuGvj1WM+1+LFvOdkcJpLTuPsQmDciuHa5z4mgt7seIw0kHuZ61Va8i?=
 =?us-ascii?Q?Z1m//+AU1lx2wA0/oX0RcDclRY/WfVFRgGWm9uNhoUQaFl2Xd+zOspbj0RNO?=
 =?us-ascii?Q?nnJdlxrkfZo8tyBdqyX/RmajE17XjNMElTOKeX8Mrgh+Sh3nw32qJbRdZKck?=
 =?us-ascii?Q?+JxOrPmy6IOIKFOglYlTj2HonFr/FkUrDY09MJ4DuadodMwOYZfv5rWcT1aB?=
 =?us-ascii?Q?VYq/bQhg6Xy8aw5vH62drceNq45qHeyRYGdFbGZ/AjPPE/GwM24+CJGGYjKm?=
 =?us-ascii?Q?4uqaoAobB43IpfsQnSRLUx5NCSYOw/ALzYC6ALqt0xBdlQCQwHrIDWUcP1G8?=
 =?us-ascii?Q?AWBQRPWZCADSJQeoHGLs4ob8QlhTsK2dK7TjIyLuX1jwxoyUVNaRoW0J0vLT?=
 =?us-ascii?Q?K9QxhdaMkzLjKcgN99mkMwnCgJ4m2gf3sadx8UzN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c34d14-1d44-4827-9a30-08ddf54c0b3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2025 18:08:31.0768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1VWotq5LVDKDz2QyUQp8ZZROJRkWDpHkmht7DNH8SwzxIuG4rSGZH/uETVILk/BxZpe5+1SgWgCWJxTm3gTjKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6218
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D2405A001F
X-Stat-Signature: mc1pz3zyda34ncdn4ba4xia4q4mgge4j
X-HE-Tag: 1758046117-108758
X-HE-Meta: U2FsdGVkX1+NnKOhD8xTVTHbfC1x5+ycJOjON4hhc/n/fTDZn53MnjNmrgEdp37FEMeCbAeSVgbxUI9ZyH2UevwIPc19B5eCtgY7awUsTiZ3VnOlPN0K2q1vfVw8Wzbw4ahGya4GHPRVzepXtLrTHrb1p1HLV3TrcAMM8hJ2Esakp4y6uKnZzB997dJb6Q+lbD8z7I7o37wp273isFqoovwjRPsO28JBxANdgyMb8V0IKTwQ140gFar+/6kAVMj224xi6KRGF82aAprT1pXzxaBsJsiaveez2xdAGFIU78WQWPQhXU6cpgQWTnYvdx69ToggDmcU5TGYKjF3GMhaE/irGR7QdlWXBZtsNRoRNKQsUmxTX4SCISWA6HHQ2tZ4V3f1DrdsJUsMK2uYh7CBUqPc6gzMQjjvZ45yPsL3oAg8ay/IfzSkfmMG/O7esaFu32ivi6htSh+EUjE5Ijw9WyBtD+kkBloso/qgSvp9gPUEvPo/G1awPXp2OiQfJ8Jca3rDY44qirzUdVd26JxLGvG2+K+pZ7B8KeuzwB7ppCv9rWy46uZEcQv+RDrrWG+MqaivosL9l97oBmvyT/pwqwLmySSwYWEQL83Lk1YWOO6XKZcUPU6X6drs+/y9pW/HF+BhUXPPXsYJfyH+mdIGhqCjhIN0KRLgw16YEiQVxY3+16yQwK0swBKAFBDNeoRm+RJWCDwEkrqyPbna0/PKrarx9Vt/5fF5VfcCg8Yk6RX3YQWzq3tTV1Ilh0m+PrIbniHa3cF9dA8rJ06WNDJrOTnBfRYiZ+/ozWjPwaf0SAvHzZoE94iscLWXIDkWXZTJU+QwEVUxeTHNFuj7cvdN9wISYwwTAqk+vK9bwm0nOqkdIUHHLiJxwtSzNKgwkaItlRLyX65Y/XkcIP16ZCTYSrpTT7hm7Lo3fDkblP2dNcfJBaK/T4fCxJKO9jBZUz/5PiRQTHDSh30+SbP/2kT
 QJEgtTQA
 iDfqb61Efqcuw5mVcSwkGmSG0raVCv5aQVBQog7LMWBNSWSbhDxjN4+O3ZkvQ8ekpu6vnjgig/WpOr53dagnkERqGiRajeLbjpAdOcG9pHFGXjlW4F/WDYDCCY5h28dzuQmnOnUTth11kp0rjU+PN5a05HyHOiPpscECxR/R/CsGA/slfXa7GIjXDmfEEgrqx/pwAoUus7/COwnW6QRiyuIC2kn+UzT3hmVpoZ7sLztD/V9vW2P9oyHtmsUcpSKy/R4ZIzFVwswIZ2HKsxM200/OQU5fzFU65fEd+C0kX89q1NJSNEpdOoQtflAaTZ8wKpXbjs19kagt9Vq0lePyzk3zqvEq/seoQfRdYT4aIUuP0YJDnYu+S3g70mTvbi/W2P5Udwz98sLsOjx5Ytp6K2sAP8ju4KyqxPOaJW7eBQ52wC8CLn5BXxB8p2VEsIhD9Muw3hql5/kNv0hc2mmUOovGz2Q3cLeYsp/SuILQyoLyLyQCnwP9Dq0MCCcIofZDLl75cFFYP6hdeV4gLKE500+5cC+T9LkUOVjHOmwzBeobbRJJruatBcJ3Vr9tdJ/fABAHipEt+o9Ep7fkmo4LinqlKxswkGIxLwAXrehOnxq99sTmeXLasMheJLeWS6nKYpuDJu9Or0qWgVj2SEc8tHz576g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> My original patch for this just skipped the GHES->offline process
>> for huge pages. But I wasn't aware of the sysctl control. That provides
>> a better solution.
>
> Tony, does that mean you're OK with using the existing sysctl interface? =
If
> so, I'll just send a separate patch to update the sysfs-memory-page-offli=
ne
> documentation and drop the rest.

Kyle,

It depends on which camp the external customer that reported this
falls into:

1) "I'm OK disabling all soft offline requests".

or the:

2) "I'd like 4K pages to still go offline if the BIOS asks, just not any hu=
ge pages".

Shawn: Can you please find out?

-Tony

