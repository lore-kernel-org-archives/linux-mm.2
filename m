Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F240ECFA477
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 06:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DD8D6B0026; Fri, 21 Nov 2025 01:51:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567146B0027; Fri, 21 Nov 2025 01:51:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407E96B0029; Fri, 21 Nov 2025 01:51:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BEAF6B0026
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:51:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE1E412FEB7
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:51:41 +0000 (UTC)
X-FDA: 84133693602.09.5C53938
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5229E40007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:51:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FkJlGvPU;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of vivek.kasireddy@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=vivek.kasireddy@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763707898; a=rsa-sha256;
	cv=pass;
	b=YK3K+3hwCNr691rxYtUV5otdULNil/cEAgVfioEevB8kXgFTxnEjLupUspSpFD51s4fW9b
	/A+CXdFb606a2qSPll4lJDZ8jz6oKOa+43tBvETKrwFoGm6XAV4ICGSOXREQmdlJcbq7Qi
	5KTd4jNTjuoA7EEn86ItWMsyn0kUGLA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FkJlGvPU;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of vivek.kasireddy@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=vivek.kasireddy@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763707898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouvhk0ohDL9PjD8UU6CaS+3RiyJDH9GE0DAtPH/n6U4=;
	b=hdDW7FUnxMFfnMJPJh6+ikLgS2ZovzYt3XALcTDwfapWPLMEN/zHaII1Ezj4Sun5j0kMIp
	c29nDtrAFiaUHnAtxzLymec/0FOBEkUEXAyAavmY3O0KJ/R5FxE71WIPnMmEfU57aJITR4
	J0mYTRvTOeZweewCKJPOJitACgI2lf4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763707897; x=1795243897;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ge1QgJTH0Mj676qOlRZX2pD+fpY1EAjJWYJWFXoVciA=;
  b=FkJlGvPUEP13d398PUQBIQW4S4yHejyxfkfrOT/9o28p+X2Bi34JjCps
   TCWHS5G5DzdL2uVwpe6ZSFgzf7ZjpkZQxdXMjiX822Dfmu0zOcUgsn6m9
   k2pNTcF7gJlMjtvyBXUsUogFdQzRfOzWAcnC0niTu3QRbbd4PlBl/+jYR
   v2kKviiDfrTy39gvk+d2GICAQaP9iNk5eR11nevhbVXwJXHlRh5QL16ZA
   hYs7arHYPyBQFIx6xstU43gQHFtX3QvwgIkrDBgjLXOIfbdPByDgB07tG
   m1m2qiOOeIoOt42wKRtzlmKL24/HtPh0CQgiM0muiyB4rcJM6LV9hYR3y
   A==;
X-CSE-ConnectionGUID: 3QVEvR4dRVGDqXW+SqkrwA==
X-CSE-MsgGUID: 0k6o1PePRx2LEHlfPDZu+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="53367353"
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="53367353"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 22:51:36 -0800
X-CSE-ConnectionGUID: ZBtxemxwQn+saomg92LcPA==
X-CSE-MsgGUID: Af1ICDrTQ5CByHmQPVqh7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="191488708"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 22:51:35 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 22:51:35 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 22:51:35 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.2) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 22:51:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A8hIiZUDpUOdFdX7CHSo1V6K5jCIIMt0LXBjNPbkBJl3PyFY4NOnDZFpcskNZ+6vOQOh1EiCdDvufDjEf5TtbbcwXoitrxuUHHi6wO719zMkNyxV2TcEUhdpW9GZ4fpUiGKKEIV+b2cOrCwY0f9SFMDC0Bv8MtxMaXuklmnulwVaq8KrWaz8RHrkYjxLPbQUgQ8PGkD/SnEytmcgiSE8AlsAPacWYzcsIm13zIFXVz6tdmi/P8FGkoGyGjOtTC/fGpjmZz0ivVz6i1pJPbqov4zWNJ4CFdmNvKR3bzCeLwYn+QaPJSlqI8woGNo7Onub9hvsQSl59RgfsL/+lXX66A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ouvhk0ohDL9PjD8UU6CaS+3RiyJDH9GE0DAtPH/n6U4=;
 b=PuU+jKxuka6AUHZ/ST2LRd0N2Sj5AuBj7IhE3AIq2cOiiFL92y2DvWizcQAtLvOK+VYvbD7ft/EecooogIU2ryQ3NkIXr4L0RY/u4dju3hQNz5oHt/VJAzgZWy3Hmg7rWeN48Tmk0SftBTJfAJCmgfXLmwFAc9RspLuuKbcdsDReQIdM998UwxppsCQlEuzKFUEJI9ZrFwjMLkx0LhpLTKMVSGu8JEQNd/Us4WNBYRylrQm9yE3ORzY8sjd2ZBXs0UK05ZBbZNsIm6VgmOHChnF7f3XbsTiA93ca8x7HvXkkJ3DsSq/UiyADXJKC+c72IJ0jaFR/BI+vtM4C4k4jzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA0PR11MB7185.namprd11.prod.outlook.com (2603:10b6:208:432::20)
 by DS0PR11MB7957.namprd11.prod.outlook.com (2603:10b6:8:f8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.11; Fri, 21 Nov 2025 06:51:32 +0000
Received: from IA0PR11MB7185.namprd11.prod.outlook.com
 ([fe80::dd3b:ce77:841a:722b]) by IA0PR11MB7185.namprd11.prod.outlook.com
 ([fe80::dd3b:ce77:841a:722b%3]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 06:51:31 +0000
From: "Kasireddy, Vivek" <vivek.kasireddy@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton
	<akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Akihiko Odaki
	<odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: RE: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
Thread-Topic: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
Thread-Index: AQHcWd+c2Qg+ux/sU02Vsytz1SfX+bT7RY+AgAC3ORA=
Date: Fri, 21 Nov 2025 06:51:31 +0000
Message-ID: <IA0PR11MB71851184AA5977BBAFBD55C7F8D5A@IA0PR11MB7185.namprd11.prod.outlook.com>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
In-Reply-To: <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR11MB7185:EE_|DS0PR11MB7957:EE_
x-ms-office365-filtering-correlation-id: d5c81f43-1213-44ee-c076-08de28ca6746
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?Jc7d9EePL3RNrBykB8KAIb9ZGpLK9ezzaMNrCUQowIdQD2kvULczcvY/fhsm?=
 =?us-ascii?Q?1RGsYXMmbpuETKlVLAckvS6Nl2Km8tZvNdRWTmhFlkwOEYTtviqS4KDjEmwU?=
 =?us-ascii?Q?Nc5+8gMAAd4an8TCqVm7kUp6OyC+//OHgVLz7rNbfjkJdIkDteSiyKPj1eT9?=
 =?us-ascii?Q?4+5HZUBfovqfoZGzPkz5lQGk5MGVwtxeJw0ZcQaSfN7DD6t93Tb8NBPX7WQu?=
 =?us-ascii?Q?Jq8ZY3JAlkg/8lD3F0bjpGkKepgxOGUiyvEqcuxg5XbTbE5YSboy8AOEPWx7?=
 =?us-ascii?Q?yelni+Xf5UAkLOX0QT1GaQdbUbY1lLTbQLYm8x4VVUSEckHAQ3N+cuFqxWAL?=
 =?us-ascii?Q?rIQuv9S7xOkTB+Yj8feS9SkUK1QO9CNsdYqIlEGQtZs0k68mzjqZEBtIY22P?=
 =?us-ascii?Q?9gJrronaoQYE6EOQzrMhb9ag+0xN77f5rAXUFqrMz/kXEcCByhUsE6Om/xRm?=
 =?us-ascii?Q?6nzLQOQImog0q7e105qKAvren4qp593UhfX6kyi6SWWv6euey+oJ916uHnt/?=
 =?us-ascii?Q?yAl7FejzwphzpG6yOGDq0PIb4CZmLc6mtNAlEJ1P03kZjd1JkTkD5Nm1c5xu?=
 =?us-ascii?Q?NPvOBdSqxBe8MXrCJJPwIcNn2umDoY3Pzu5/0SXDQ9/NCiOWBL6VzBeDuZPF?=
 =?us-ascii?Q?jGF3Q7krw1hJWtCvuC/M8Ya1oVYoVbpncesi/mzqn873Xo/y2I7cLbwashLO?=
 =?us-ascii?Q?460Vm0rJ3DlVnl0bMyhZSha8kBxMFm0U/etIvBEgkVpFnCEyA594rCWUhueY?=
 =?us-ascii?Q?1V4hE7Ne6CNZctCjGu2IgusKnGwfwtnY5TZDJfkGi+etsww/Jfmtt0PbF90B?=
 =?us-ascii?Q?TwKvKHau7qGzl4TMnK959Q29BBHBX+G/xiuEwKLWuWl7G2CWN+Wb9lMAmuOC?=
 =?us-ascii?Q?CDwQfZdoxs2PeEn2iyjW6uG7SECrs9DDODO6xpwAithuB8MKycO/oJBpHaYg?=
 =?us-ascii?Q?j4Bv+dvW0CR9vCiyA5X9lv5IOzsjx9D6l4FqCcudB21q/wZ4WOsjxuNc/Xdd?=
 =?us-ascii?Q?HAI07faKg2AzdkCdHGNfXJRPdIFd0aoRw2M7ztmcgED6Bm4EgN8RGU4PkYiP?=
 =?us-ascii?Q?Qn0ORhm+j6A6VeZ2Hs3S11JZJb9bxnISL8Xm7AUfk9xOoBrJFxr3IipFfIEC?=
 =?us-ascii?Q?WnAcvSP8Lc8hrIJ9oYIMYhUnrIzlT9PCRCPBT7wXuKoMUvEXTyvmMib7KO7u?=
 =?us-ascii?Q?uoe4UyWnPFlNnH9TSNgPILDHnW9VqNpkKU8b1NlgLu818CzctfuH9cjf20uj?=
 =?us-ascii?Q?mLuIPBBusvrSNMoOnwD9sqn2jJoQoOkg3ANZDDYT1K3mm16ofqSGsjiRaVqK?=
 =?us-ascii?Q?TMWNGCN4KTQuGz6ROMm13RmwdKO1HXvMll9jHvrm2+663K3hY3jQ3wODLgqr?=
 =?us-ascii?Q?pi9mCo6ETQsG0AzphJerUZsgGFlfXoU+BIaugnxT810koxrGOBWpTurx3rqk?=
 =?us-ascii?Q?ZOfp+VXq6AEdASnKI3KfQR4vK4ZfxbyrULe+6D2LcvOtU5K2UOuV06fdYEe3?=
 =?us-ascii?Q?fJgt87sceMkYKd4IlWvRD/cV8cEFJwhJCSlc?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB7185.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GxgZzjYzFwOfYZ9DlXJ2KjOBGCV8fwrjyAxFpLmZIR1ugsPpkqMA9aBnzWsA?=
 =?us-ascii?Q?UNi2qLsfrTAYz4cu4EyrOuWk1CUbZO7wXYTLzm/Cib9gVx2iQ2sPsMJZdfTN?=
 =?us-ascii?Q?sRH+O07kbPR1k/O+9co+6y7GlAIcjTXI7yqhF/R9DZwts0tG0iP/VIUxxeAz?=
 =?us-ascii?Q?2EjtM6LpdXkvM293Pj5zdmykcG5PnoFWbES4nOAMmlJtT5C0Ug6AiNnpHVIg?=
 =?us-ascii?Q?6Gt5s8lzjiFaEqL05clslLmuihRBLrHm5PHqffDM5g3aYs0XYKrGhMNcZDJd?=
 =?us-ascii?Q?7L1LOvhmJYd3sYNa/rHOdPMapCZvNQeFvStWWusgPirTgWe3HM5KFYCUL7yt?=
 =?us-ascii?Q?T7NqmJLV75TlATyDsTADVUZP9Dh0C9bseibAt/CFxUtgLCcvtxluiJu0Klk2?=
 =?us-ascii?Q?g0qeriGM0vbFuuWmz5NIzAeBF2FtSwcBfhx5h+2Er4kZYflfFoY1m6J87bhD?=
 =?us-ascii?Q?vbzwp3JFedPBZaCiPcB+xD010hprWtYj1uKO7fCHh4ISJjBd2SmGMNLKUz6w?=
 =?us-ascii?Q?yfZTgDxzwDBMdrym7jnDbhj2STylR/QkqcH0WivasAbJ+BX6fiC7woLZHR6C?=
 =?us-ascii?Q?sORLwwojZZpyP7YeEUtzBMXaZ2eliJ7s9OqUEnSx5hlETA5GgQ3Su1Ny8SlR?=
 =?us-ascii?Q?vV4WXN5HAKG/I+M+9wRQl4SkyqB41AZwAAFPpjuftJmGkOKdR02F2VUIcK09?=
 =?us-ascii?Q?GVfWMVGXI9YJ/6Cbxdy+iQSCGNJsp1zCMjCCqcLwwekAJscR3D2EMVMg1P2d?=
 =?us-ascii?Q?F6R3zya5gw3P2FY8WiF9ca48HY7Dh1dCWY4jxZxkhe34tG6ZGJRbtvYsNQ2I?=
 =?us-ascii?Q?Br1q/tKLNRm0oU2gNFj2FUwYmzXOdEyOan3St5KEtv+mbkO1GWV2K1yDhYWA?=
 =?us-ascii?Q?/lN8ayhGpsG4qNjRuB9AJucpYmGjPCZ0naT5NEKtbvzJjuIroXyqbBZFTsZ8?=
 =?us-ascii?Q?LCLNjTKvy2ANu6G06a8j7z+lE37mLigM64LHZuJsdN00WYeGQVUhEa2h2Tgm?=
 =?us-ascii?Q?acs7Dkj4Qwbj2UeZzZZa72p20HuEZJbR787z1cGqn7JCZE0iuBD8B3wesXnJ?=
 =?us-ascii?Q?mGu56TaQkFOYU8RPIPorLD1BvUTLoPEhqYyir7K9BTywlU0lChaaP+1Efko0?=
 =?us-ascii?Q?8k6OGTbGii5QYCE5fq+Y2YvUmev6MbcMo94u51m0kQIIEsKso/GVPp1fNe/i?=
 =?us-ascii?Q?OZKA4V/tTpaXMn+OTFu0wwi2rK+9bFJjjsYsA+xWpOD0hsMQHT4ODbdwyeIo?=
 =?us-ascii?Q?4brDOiR6S0oTK9J/23uJZGgXXCOJ9C7uTyxbT1x53d0DJBIr1qU7qzCZQte3?=
 =?us-ascii?Q?LUl11tPwbhVz4HZ6I87vV7o8SwzY7WJF1PWrqT5IZ0ur36VMQzFOjrxDgyPk?=
 =?us-ascii?Q?XXKZgJNjthjZmo9PFXiSvKimsKtzTCCW5fabwXXYf8Cr5t0q7iBdZtMZNzQ/?=
 =?us-ascii?Q?Q1ZUJx6V0JSa/SPNtSjOlmXn9MDw/thlqElf1jhlH8z9Xf1J9WoH8Af5QMTD?=
 =?us-ascii?Q?SjSYYLtZ5caK2R64m5+CLwWcUDt/VuPrcqqV64x9H7QjD/d03YcK6QAdnZZz?=
 =?us-ascii?Q?quXH2+40McGVKPFpoqmIZTSaB90rYDwv0gxcoo02?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB7185.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c81f43-1213-44ee-c076-08de28ca6746
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2025 06:51:31.4253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cPDWs2ybQoQUPXdRXEtqwg1qNj1rV3dIHK68a/MKNfqQiAN/ms/KCN80YnpopTZwc4POA4wAfM0Gc9xYmkYeHwbtMhHdk/k3gVhd8Yj/lrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7957
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5229E40007
X-Stat-Signature: 9kfnjjsnuga34yjztbk18jycqtdu81qz
X-HE-Tag: 1763707897-271114
X-HE-Meta: U2FsdGVkX198vE9sLdxSD9rcuEttePhNWUTn7z3NIyW9u5qzg9Hj45xwGEn4hB2N0U5yEtizIRznjRmYpN+IN4Uj8QjCYpjNSVPUio3WCELPJJndFBBB+8bRR+CB6m1MIonJdU7i02GgnLiqkXZNktd+iW04pBJMclA7ivYvtrRGN/O+xY2qrXh0MszBrcqQPE3b/7rjnz2d8BRxyWEXZD8HcjhxsYuagFnGW3r+FPkqPjfltBjOgEs91TtvheBB6lByaelosCEcucs5XxOcEKS+ht7XCr9wnaCS97t5ns3/U8tHkmROcjGGVMQZOofdw068FUK5H8GcYXa17gdygtLjwkgLuWnPohs8lpqsXXOLKU+yX4lriaT7Zo+FSelNRwTEbYygYqPdTDbEtaiynbLwwUO+SDpoRueoi4s4C6Dw1FqgxXizQWrOS/awEjvWr0Pe5OmNVtFkFqE5vpQwwKoCvUqz2EOGya9o2gCUmisIlJA7queIGazRN/AXPug0py3VtEGOG7jtiU9Xg5lGwVL3aDslZ9WDkt+AUvB1fnd4XRos72JoqXTTnSt9VcIT6Xo7y85UKC8SMIWDu12o3y2qbY2dl4x/wGlVP5ifgQx/zWgY+te/5fZ9Ksgdcd4Fdso9uBWha1nBe+hCPB10PYymdnqY4fLEvYZsWDa91TRdnJEda6R66S/wpUZqhX4N4IlKH8XNGYrNwwIbbO5XunXsKfQxRw4qnIL2VpzAqdAcwRQ65nuZXKIXdEmeLz2z3AVnnQaawLF/5oi3Qj747Gdhnm7MfPAFZJLokMBamODhDjRwqJTVeQgxnvmi7SCqmNwr07B4VE9tqLK4vyi2+GW3JFxHGimg69lKy+LnLq6kGHlF5WIk+1izHOXNPv0cNiDw7ZU3O6+PV/isGjpvg/sBUdgpZciZAqH721ZBUCKzig8CTReIJ3fZdkfwJtJoWGIijq7gOevtnMcgUGi
 sFIRsaFF
 V44g8h4oQsAC5xfdvvMHoiZlp0mTmgtlBqeD+RXoL1ul/QtGi/4Nacn7m33NaPJ+CNoNCpjwQFOHnQcqNnRyxBPjgzNad8in41SktXbM9uJQ4TPkG5fcG1l2YujyR7U4fTmjkUFTccD7nmpwVsvsUTZ34kHlnH8Lr17sHoy/6VCxGgl3p6hjJ8voS+LNLF+z4DYCnb19Z5ky/ouREQH1W5XCRaxesJCfIE488mQwFDpojwHWp/qJmZRPh4erN2uMkvco7/MeCDdKsrqyaCtd1iMTpQ6c3q56I3vV83M8gRlex4gqItmI3EXT0jJRgPOfF8NE47yfV1RJM11xNyNrf1jk3a/tPeKgvqoRu9HstwkDJAFEfUBaEMaJWwT1rXrCRS47fwtf60zHq3j44ik5SZ6I5+47aFin9sOkOb4hOAYdEX7qn5nk3YQBCMeHbOy57Zk8hvZBpAqIrOTQ4S01sKUersR0jeZfpw9tIgwbgy7s8J6AfF0Y23VCyleGuFTaLc8ObHVqgS9lzUv1LaVoruVUfzOT9ZRcZ+SO9Z+sl4Jcagk9B7nyR3QVJZkw0oK4wDyRx/i31Xv4Uo4IPAkk5UFj5VoAuSaQo07+V4KWX1PkiChlYta5dp24BZrJiuthx/nmEzKUUA1Gyf+VtXhLzZEFrRGYs13vxnPr0lFmtMHuqidtPA1ycY2qhag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

> Subject: Re: [PATCH] mm/mremap: allow VMAs with
> VM_DONTEXPAND|VM_PFNMAP when creating new mapping
>=20
> Hi Vivek, thanks for the patch.
>=20
> In general though, let's please not make a fundamental change to mremap()
> behaviour in late -rc6. Late in cycle/during merge window we're really on=
ly
> interested in existing series, series that are less involved than this.
I am sorry about the timing of this patch. My intended goal was to just sta=
rt
a discussion to address this issue we were seeing in Qemu.

>=20
> On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
> > When mremap is used to create a new mapping, we should not return
> > -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set
> because
> > the old VMA would neither be expanded nor shrunk in this case. This
>=20
> I guess you're trying to be succinct here and 'clone' each input VMA usin=
g
> the 0 source size input.
Yes, cloning would be the right term to describe what we are doing here.

>=20
> However this can't work.
>=20
> This operation is not equivalent to an mmap(). It may seem to be for
> ordinary mappings but in practice it isn't:
>=20
> (syscall)
> -> do_mremap()
> -> mremap_at()
> -> expand_vma()
> -> move_vma()
> -> copy_vma_and_data()
> -> copy_vma()
>=20
> Essentially copying the properties of the VMA to the new region.
>=20
> But this doesn't work for PFN map.
>=20
> At _no point_ are you invoking the original f_op->mmap or
> f_op->mmap_prepare handler.
If all the properties of the original VMA are going to be copied over to
the new VMA, wouldn't that mean whatever state, page tables were
setup via f_op->mmap or f_op->mmap_prepare handlers for the original
VMA, would also be copied over to the new VMA right?

>=20
> And these handles for PFN maps set up page tables, because PFN maps
> literally do not exist as VMAs which have properties independent of their
> page tables like this.
>=20
> Equally VM_DONTEXPAND implies the same kind of semantics.
>=20
> > is particularly useful when trying to create a new VMA using other
> > existing VMAs that have these flags set, such as the ones associated
> > with VFIO devices.
> >
> > Specifically, there are use-cases where a VMM such as Qemu would
> > want to map a non-contiguous buffer associated with a VFIO device
> > in the following way:
> >
> >     void *start, *cur;
> >     int i;
> >
> >     start =3D mmap(NULL, size, PROT_NONE, MAP_SHARED, -1, 0);
> >     if (start =3D=3D MAP_FAILED) {
> >         return start;
> >     }
>=20
> Err, MAP_SHARED and -1 fd? Doesn't this always fail? It does locally with
> -EBADFD?
Sorry, I was trying different things and did not copy the version that had
the MAP_ANONYMOUS flag to the commit message. In other words, I had this
in my test code, which works:
    start =3D mmap(NULL, size, PROT_NONE, MAP_SHARED | MAP_ANONYMOUS, -1, 0=
);
    if (start =3D=3D MAP_FAILED) {
        return start;
    }

>=20
> >
> >     cur =3D start;
> >     for (i =3D 0; i < iov_cnt; i++) {
> >          if (mremap(iov[i].iov_base, 0, iov[i].iov_len,
> >              MREMAP_FIXED | MREMAP_MAYMOVE, cur) =3D=3D MAP_FAILED) {
>=20
> Trying to cleverly clone a VMA I guess.
>=20
> >              goto err;
> >          }
> >          cur +=3D iov[i].iov_len;
> >     }
> >     return start;
> >
> > The above code currently works when mapping buffers backed by
> > shmem (memfd) but fails with -EFAULT when mapping VFIO backed
>=20
> Right, which is expected, as described above, you _are_ expanding here.
If the original VMA would remain unaltered and all we are doing is
cloning it to a new address, would that still be considered expansion
of the original VMA?

>=20
> > buffers because the VMAs associated with iov[i].iov_base addresses
> > have VM_DONTEXPAND and VM_PFNMAP flags set. Therefore, fix this
> > issue by not returning -EFAULT when a new mapping is being created.
>=20
> We're not fixing an issue, we're (unfortunately, incorrectly) introducing
> an entirely new behaviour of permitting the remapping of page tables
> belonging to VMAs posssesing VM_DONTEXPAND and VM_PFNMAP flags.
I mentioned fixing because with this patch applied mremap no longer fails
with VFIO backed buffers and my use-case works without any further issues.
However, I do understand that just because it works doesn't mean anything
and that there may be other pitfalls that I did not run into, but I am wond=
ering
what those are?

>=20
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
> > Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> > ---
> >  mm/mremap.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index fdb0485ede74..d3868d941f72 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1736,7 +1736,8 @@ static int check_prep_vma(struct
> vma_remap_struct *vrm)
> >  	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
> >  		return -EINVAL;
> >
> > -	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
> > +	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP) &&
> > +	    !vrm_implies_new_addr(vrm))
> >  		return -EFAULT;
>=20
> This is just incorrect. I mean firstly, as explained above, we simply do
> not support this kind of operation and cannot correctly.
>=20
> But also here you're allowing !(MREMAP_FIXED | MREMAP_DONTUNMAP)
> VMAs to
> expand VM_DONTEXPAND, VM_PFNMAP VMAs which is really really not
> right.
>=20
> The missing context here is:
>=20
> 	if (new_len =3D=3D old_len)
> 		return 0;
>=20
> 	... all code below involves an expansion of a VMA ...
>=20
> 	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
> 		return -EFAULT;
>=20
> And making _all_ expands that aren't _definitely_ specifying a new addres=
s
> work correclty. But you are in fact 100% specifying a new address because
> you're setting input length of 0...
>=20
> So this allows _anybody_ to try to incorrectly expand VM_PFNMAP,
> VM_DONTEXPAND VMAs. So is wildly incorrect.
Is the problem here with VM_DONTEXPAND or VM_PFNMAP or both?
In other words, assuming the original VMA did not have VM_DONTEXPAND,
would this behavior (what I am trying to do with mremap) be acceptable?

>=20
> >
> >  	if (!mlock_future_ok(mm, vma->vm_flags, vrm->delta))
> > --
> > 2.50.1
> >
> >
>=20
> In any case, I don't want to try to support this behaviour, I don't think
> there's really a sensible way to be sure we can _copy_ page tables
> correctly, and even though the source size =3D 0 is a cute trick you _ARE=
_
> expanding, and VM_DONTEXPAND is very clear - do not do this.
So, the thing that is still not clear to me is whether cloning a VMA would =
be
considered a form of expansion (of the original VMA) forbidden by
VM_DONTEXPAND?

>=20
> Additionally, please if trying to make such fundamental changes going
> forward _always_ provide test code, it's absolutely a requirement.
Ok, will do. Just to confirm, your suggestion is to add a new mm selftest
to exercise the targeted codepath right?

Thanks,
Vivek

>=20
> Thanks, Lorenzo

