Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C5A2C5B567
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 19:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EAD36B007B; Mon, 10 Aug 2026 15:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4749D6B008A; Mon, 10 Aug 2026 15:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EEA46B008C; Mon, 10 Aug 2026 15:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0CBA6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:43:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B1D5C026B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:43:21 +0000 (UTC)
X-FDA: 85086383802.18.58BE99C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf11.hostedemail.com (Postfix) with ESMTP id 20D9340005
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:43:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G+++OWy0;
	spf=pass (imf11.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786390998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rGFq4/aWvBMXcrKp9pNytp/vkGmHCU7TvDrWZvcXdxQ=;
	b=N0D4bCHnEqSzMe2VXTG2kuFFv6AV6rAdQKG7dXz7lM6T1/3vabICZ3FwM9G4h9+shrXlki
	yql5B2kN1CnWTkFvPghxOSKQKGlM3/6sclewgz9PB+JJOuVadBhnqpgjIFNFIlYqsyRZ0/
	vp1Kiyy6/m+gWAGndsY4w3ogJTdwVZM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1786390998;
	b=VoT0NC8ggT2ELrCzrXVTiBCuu5PEPADGwKE4LGyYcLjWcTt8rzBXEFY2jSMhIX6J5Jw4QP
	arRgMxOqpJVrESi29QULphgAXpADL02GDwRyfUs6V/S7PWrLkjWnR06OWvOyVbbHX3aD3n
	Y9Nf5rq5kotGQR4jG01VTbNliqDHJpE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G+++OWy0;
	spf=pass (imf11.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786390997; x=1817926997;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=jBbd49PEfrMh50OwNryqk0kCAVljFj8QQ/HYVp4T6iw=;
  b=G+++OWy0dlWQWuUM0N5D+XS2Lq9SxPsvBBPIeWBYemgOEhU1JcyEiI+f
   ++wdND7gUidcJOjSdMtxIV+8obXriiyZGfaW3pyJcTqPUpAnurF68hOGo
   klrb30+LdBOrEySeSyaXc0tbpGyaPvfDzP0jOmoGLY8hGLeo901KXKgnn
   X8AVVBds36wQM+LNdz78i0nAJY/5Uk9balJo7EaedgSmUX26JcmF4WtRq
   DmVe7DQ71zFQt2EnqnEZGTcb94J2OYTVPgxwm5Jwoc7ctAmJrVWs4bOqg
   k6dwY9v1z6hj64GgMWJ/M3ztKlQmuvLvykYTcusSf8CpSaIY/oKsnTLj6
   A==;
X-CSE-ConnectionGUID: coExb16lQx6OlRtF+Wl28w==
X-CSE-MsgGUID: hVZFOE7ZR8aFKffMhvOX0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11871"; a="97569863"
X-IronPort-AV: E=Sophos;i="6.25,216,1779174000"; 
   d="scan'208";a="97569863"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 12:43:15 -0700
X-CSE-ConnectionGUID: Ng5pt5wDQU6V0+7Z/YkzXA==
X-CSE-MsgGUID: F3eT68b4R52JQBeEjc2GBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,216,1779174000"; 
   d="scan'208";a="263728134"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 12:43:15 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 10 Aug 2026 12:43:14 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 10 Aug 2026 12:43:14 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.20) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 10 Aug 2026 12:43:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T/+yu3Q1yuNF/HWaU42Ul7m4I2O7z59ouHrH000wgCoE/DFwxoEGzSOdnCah4y+42qNLTqm0AJlwZ85l7KgaPkzQDq9K15VxxZJmqEG3Ntxp6Q/pxu54l2acbM4tYbluHM+74Gfr8UKnINU3eCk/fV9AbKe7zXqt6z3Qav/zk3b3fKalXOdIdqHuP+/hZQk+wTVKWSt8473dWTGMljyJZRsuZC6xMJnDR+Tq91zxXnf5HFbiH+YKHRCtQ+ybNknErQSbSrQ8eh6Bx1vnSauD/uL0cOLaD853GXBii84x8DEjPcTvYu7XKsSys7+KUGHkMtSzdfNMr1FkuZGL3Wl2dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Np7CEVaAU2LKyiR5XV8sO9+N9tRFpIBRCPaAH9kT/5A=;
 b=rAKgZ5ZVygoq6T2l8AagyOXkZVRy+ueNFPV7NH2i6E901r6qpINeOFhMAmpYc9+5/LpWLD4q+pPHOqYWEfNTgzDvN6Dvv1JSddgQKv38abxPl0GLVFbI2gOgZPr+1S7a+OO3RHm3qkJ1X0RhbEwni4lhdOcojx7DQrVW4qvpMfV/kN99pJo6hrVH7Uo9yog/RkP3LTH1AFeRkpgK3ew81q4pkPqkbXKGPkVsIfVtgEAJLgvetjjk7tUt8DJ6EDj1/5InBkFsQCrByI6N2Re8yKRBEjS7Vai3j42o3+bNQY7zxZqcRcBJN2DrnxlOwD8gJM44eLWVZHX4SGMiPU2HKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by CHAPR11MB9630.namprd11.prod.outlook.com (2603:10b6:610:301::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 19:43:12 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 19:43:11 +0000
Date: Mon, 10 Aug 2026 12:43:08 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
CC: <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Alistair Popple
	<apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, Maarten Lankhorst
	<maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>, Thomas =?iso-8859-1?Q?Hellstr=F6m?=
	<thomas.hellstrom@linux.intel.com>, Francois Dugast
	<francois.dugast@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] mm/migrate_device: Fix THP splitting of a CPU
 faulted device private folio
Message-ID: <anopzF3Hk/RRh8kC@gsse-cloud1.jf.intel.com>
References: <20260805231041.3791771-1-matthew.brost@intel.com>
 <20260805231041.3791771-4-matthew.brost@intel.com>
 <87ik5in224.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ik5in224.fsf@DESKTOP-5N7EMDA>
X-ClientProxiedBy: MW4PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:303:85::33) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|CHAPR11MB9630:EE_
X-MS-Office365-Filtering-Correlation-Id: 4606da85-1120-4877-e1a1-08def7179c97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|6133799003|4143699003|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: bVVZnqnfy52dloSagqEmmwKAyb7RG8VHiHbcFwc/NqFMfF5ZV6UMo5WDAiAPLqQVW6z9lKROY/rkvWX1pjI5Yx9x7DZBX6YA0rOlyPVeOalHme0DrsSc5+zYcYdeqhUhThyr3lTOz98nB79AVh63Tbr/f3JhkgLmlIsqAKxt/r3/HU744B+FfM+aaPske02tWWtSB0KPJ4vseFJNCWepb7UfCKZwvMM332Q35+fIF7NELlBJoXja9B/kINawMqlpG3HMCjJAuw9yGwkixbrMUhXEG7Ka+uRA4ZI3EKv8MgpMvqLIdl1rKkdv1BMbCdk7cITQblZ/y8wzMdCzZbu3M2QgmqSKOl9zwqS727fGQ+/0tLJ6vG5NtdZ36CGPtl6nulQZFcePiDxf/Ub8U5ziCQmYn0GQ7WlcONrFf4EnKQazFuBhP7g6ufW6/4Oh4KAljthRPCPL57eXWns3LKPONYTFX1kDOXFnRXWZEhHpxJI6m5w3rK48ZsjeWNHdocpwhzb42qL9rugLl31ymBxpI6gbgOOr9RDlCvAOvLApARE1t2I8cSMhVBrwG+Cyo2sQk+/pR5Oq6sogvyMkqHiotUcYnkcUWo/aLVvZyiabQ8A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(6133799003)(4143699003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?JcPwuV0O8M7f/gSj6x/ExKBgqcNF2bLSXn4x2ITza51hd85EjhwmCV6Koi?=
 =?iso-8859-1?Q?DUUxSIkINfemk4Asfb02N8X899v2p7Dq1TgRp7pb65nNXPqrH6b24Lql9d?=
 =?iso-8859-1?Q?pt+VCEHBQpTeiwPhe0/9+QQ/SiACkdKizz5BG1BQt0vcszfkpyKvK4VpcE?=
 =?iso-8859-1?Q?f+/ed8+BWaXLIc6kHKO4iFyFCroRP3GSqWK4M7HA8ZhwBr83+0TdM4OYEX?=
 =?iso-8859-1?Q?Ub8InjX5EjYT64Kbf9dgK6e6Di8JDXi06VG+L2Z2WTOFOUkF8+M/g6kaIT?=
 =?iso-8859-1?Q?kDujrSmMpdasxX1gqkgMsjhBRJ+7WKM3J7zAwlZZXkSpKG8DBZyN8GAHYd?=
 =?iso-8859-1?Q?89dsP6xaAG5LQQSRehH24KiHwTn/q/qMcvu5HtQ1Hq3WaJffJFHBz+l4yj?=
 =?iso-8859-1?Q?ON1Cyw6RPKz8k8sSgo80zU9JQw3vEGVxp6Xs20ukYkSpkMc8RLIdLrslYv?=
 =?iso-8859-1?Q?NFpjSi6h6SzfA3iGoqGUnmzpiFuv7zOEeieKgXGLKxRtLr1U69O+0FRFDb?=
 =?iso-8859-1?Q?n3UOnk49c+v5pPSMUxOLqPS3tMvBjcnqM0jfQMOWWUusBWningP//dP2n0?=
 =?iso-8859-1?Q?CieoxrZeMg4dCDTOwQm+/4hUfCm7xG9JD1MbC4SOUQVt1hPp/XlnBkerng?=
 =?iso-8859-1?Q?gMXna9lYOEvPrvFjKW9x7aJXna+5LAsGqZ9awOpIcRcYcI3b2C+qxdXBgW?=
 =?iso-8859-1?Q?pR9Kw2OJuYiOgliQ0TTUKBOrFfF5zDHypAkiIEeprJfqzDj9rA9/Tv6VRA?=
 =?iso-8859-1?Q?gQz5fRHd1cHbPDHv7THNOjCbmagHXNft4lVzr+9IolptF1E8uxba6hzrgC?=
 =?iso-8859-1?Q?q87eCYuHR20Mzv62LpzGtGq+1NU9TH0r91BTjK4LaC7SleVO+KCOu1NIxg?=
 =?iso-8859-1?Q?SKSNPG6wm6XOYB1NEnoYAi1c5k1ctZRXLyK3b0TbRjaLenODa9JjL5vo97?=
 =?iso-8859-1?Q?185o5sLNB8XkbFiwilewVFWiNUnzapDmrCqh03m2HV0I0+L6emcn4eZ3wv?=
 =?iso-8859-1?Q?43BOFNUWn4Z5GIEF+96Bc7RU5iUEkwB/JAci+f8b0K8TDlwqhIny4d61Mq?=
 =?iso-8859-1?Q?HnJ152qdn3fV3l9A8ogWIi6oEQWbZzaoeDVoBHTR/riLkRdLbj/SdcRz9C?=
 =?iso-8859-1?Q?/plNJJGgS4rB2WZnnG3uPBRaxcZOX2Ad2r9AI/vd260Es4dTjwbjjXB3Qi?=
 =?iso-8859-1?Q?jI8Gtd1tDUNoentbBZzBWQXP0BGQ/4Bjmn+QERKfNkbSg3PW/xG2THUq9+?=
 =?iso-8859-1?Q?RQYi1TFsU6xsJiZSoOBljxoA+d+qUy6WOrzkv4J64jrQiR+u1Q8qKLccn1?=
 =?iso-8859-1?Q?hsYMq/uU7nFafA0wE0AsHaCEYGO4oY3QgFUyHrDo5QHFN+MSffo3a3eer+?=
 =?iso-8859-1?Q?NOxwxAoH3EJITvhmDwFGSA5gGaSoGjPz8c/HMuke1nbD4U9RGZjvs7zgK8?=
 =?iso-8859-1?Q?1FYjF//CpKtiZodSn59uQlA2RcTA0rBVcqJuQtyu+uZjomD5IWYdh2xd3H?=
 =?iso-8859-1?Q?qwQR/e/ABBUctc0A/W0xjXpQJMhdlMRUWMhZ8kd8X6habFy6Cfm/3B/rWt?=
 =?iso-8859-1?Q?7Tw3lsfRJPzaSoc++KiJ+3ijfIsvYWHlu6A0OGHZZcDJdoJX2I3Dx/612J?=
 =?iso-8859-1?Q?FCi7DDf6XgFIGr8SsTR9Y2WIvY2t8ORC6w4jcw45AKLiW6DA0EHD98F4/n?=
 =?iso-8859-1?Q?5hwyg63lWj0M0eUFn0PQvq9TzQr29h0y7yxIyVLlwygdiEeBG7UvJ8WnaD?=
 =?iso-8859-1?Q?mI7bEicsdU5NYh3hvsHAHdnYe+VK1EE0iIemxxgLCQnCUxZKY3kj78dRpG?=
 =?iso-8859-1?Q?3SkYGsW9RIrmjp7N+Ey3CGqtpPPoU0U=3D?=
X-Exchange-RoutingPolicyChecked: aS3Qw5RM/4NhlcsZcMkLo183lOtgRoM90vfJq1DVS629QtUrW323wPZoke9BlQ7KKHAS0j3o8jWIa4Iacq4/NJbVLm/K7xc/n7lFhB2SCkDjDVKDYmDoNgd95rgWmo69TM4LcY8c0+ACVyFnI3AtiQbishP7aoDxn687+PbmRGrJbjw4tXOLe9E2lEfeMAkCZV9ekLOmX9dRcQIUCesFRn2O4+KYE0rqZ6faLhI/LCu4yNxv/B1sURW/wNW/1VpWuehgZeXnVA8pU6pSSS2Lhdo3uisDzjGTAJxkAJ5YX6isrn1/tfx2/XaXABx/POBkSIPpmFQCHdDAg5BjUkiT2A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4606da85-1120-4877-e1a1-08def7179c97
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 19:43:11.8648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DjeMxMn34jcqgdj1EUufgL4m9wcYW5ww4uaC10Cd3olJz+2RT94tFqWE5YcR1Ga72WbB6PkGua4zVf9a0WVAGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR11MB9630
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 20D9340005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: zfpuy1dfnmkgrxhqdtmsg3jj75fymadx
X-HE-Tag: 1786390996-669909
X-HE-Meta: U2FsdGVkX19bPbzvFbuApzvUyJ29KFlHRoPN86m59vkDwJfvvtR1L8AMm4Y98b1rsdMaW2yzFXJmOYDiWTx+MFKeMIFhPUUXxGZ5wyssXJsYy8ba7QDlD0p6dDC4LGHZlqI0dNtuvKLrAGDBPT5NXfnHNiwqXNWV4ebz/ovn//K2UHtcEM87KqkUMJxH/KK9+KfmnHB0PAXa8a/bjdIwbQ0qZuSp1m+cLxrMZb7zr4pd3jhnMPSKPFywA+mfysqi6mzxRMFYw5yi5MXm0OR5b+U25W9Zp3WJkTn9QjEw3tscybXqGKEtabGLXg2a8daAVrxoPV1wXHajAC8fuoNjVnbYCKyifFyUT79LvnL7WMYTJfLt3ZAvZHtaP5ge/NmdHZZcadGEyacezi/PvyPmSYJuB9UnuORNUnsI2CylDC+8akmea3E+kQSsLA/qlpq2bK0bfOM5zlQfxFYuUinE1YiHV9jiExAmzilDpyjwdI4bjLIvbWfPwUugOJktK1Y443J6ZGRR6dil9kCSWKj5O09DcNj/uQSJATx+gxdjqA0aOdmtgOeL2uZ2YQsSPgsMD6LpZfFacvPjq1CdiESE05abq0ePj9xbzZoJmrx0PSl1Udxsnm4vveJb2ab36AwYLbna2KDNnpOCXRAhTyHjZpiAkDe7kZQCgv0ouUa4Mu9U9TY/kcCUH7vhsWqx7/ctg5DuxmfG+XMjnEqsSe6XA/DpZoTq7QbWbqBCAloxjfKW8UkTbKn+KmnjLybsgJAPlt5E14JvqrT+BafNyahMbOZMqSogZOnx7qw3vFwyE/CUO8yPuaPQcvpyIWY5F2xh8jZtJaqyySsX8eXz8bVbuLyPMH0nPH/ee+427k2ifbtBgUvydRph/DjmhHC3U9Ms5AT+LB+eVZQ8fpB3RbZm3C7swzV3MM9kBFjMkumgTMAfwrMutfNd77nkKGPcVxxb55FPZa2gI1uLXIenCuW
 9qCe942U
 kXh5q/VyR6sln8DCsogx7FJrig9RRJplgZ3jm6mshSVMirYQj9ACq/MbKhLijac7i7wOfa35DlxWjRRCn3n/pjS4vUAH3r9l08ixctHxwUzH8ehvBwujp/dKBN4qi6o70R1BRvE6ymYopYsd3wrPW56N0dhbwRfGgMOVLkCYG1yZLcorjI/1K+6+hoYqnQI6uxZYBv2pXTjQLZ10obBhNqyobBIzPMFievn71Pxmra3qBuWR5pbIj6w41Oo9zok4wAVaqALluYfwEpzwpjgINA4yds+xXl9uB2KyHVQl2tLELY46HtFuQ1KA/nrh6ytUXNDnQ1RIksdTWc6NbIDT8gfqOaAM2Z80gBAtA7oMz2EqQ/TgU0KwEXX/HV8OqeJWxLANoUYW+h2XH7sUszokkSbbpD1tj5cz4jAivZX4ejchIwgr0J1iBfZeLahHuPjqTeHzHV1ovXXPHqqbg1oIHN3DaVOgsWcjzRyH5KuhPcXIvYb3RKaus/WoGV2JpKsF6Ey2NElc8jt3/gJux8YsAkZ8Zf5prPpZykgmJqaoziD+AgcyGmi8egdp9bkn38TAWw6UA3EzH0NBAeij6wC6i8f7iptucoC30OWn7IIi1yMLAOSSJq5tvm91jfQhp+O9UURFjY4K1B4onTaOSEIUilBljGTwrojuV/1ltHKF8c+i09OQQuDnvEJHbwwQZx9MZvTPZdTPlxp8Hvu6dsomJwqW+xwdDdtRfZwZvk7lI9YG+bZx1uO4yZZrD4CvOTI8G6su+5qqtCZiJvTNB9TU4L5bkPxEBNqiBdezhpnudDNd8Ql8qWL1KRY4llAIUIKdUyBQGuLDdgWfDeMK5H6NHTXo5UeliTYNp955xWJzfat7D3oti5Qu1s86N1NwxxUJjizcFx56yOMcKhtIV+91y5Bck+YS/1sTzvFTFtrvqoKlKfRh7SsILpIlfXF9CRZ+gEMLYJx4VWtSVcuf7piUplvGT5W8y
 Ni1YipWW
 vUIkPmOcVGSmWCcI3rfBN60E3KxcAQDfp3CnIeZ2adBMjnx087hhYruQQ4rRYZ7TcqnkZ71RPI8VEjQvNc6hJVHmvlvUYlJ41NPYIUqiJcaNNz6oin2ikyScFsWLBoP0D9ld4IVlvbhgqsgsZBU+7+p83uA/HA2KhKMSsz6tEmnF/vecQUcPGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 10:26:27AM +0800, Huang, Ying wrote:
> Hi, Matthew,
> 
> Matthew Brost <matthew.brost@intel.com> writes:
> 
> > When a CPU faults on a device private PMD and the device driver can only
> > allocate order-0 destination folios, __migrate_device_pages() has to
> > split the source THP via migrate_vma_split_unmapped_folio(). That path
> > is broken in two independent ways when the fault is what triggered the
> > migration.
> >
> > First, the split never succeeds. At the point folio_split_unmapped() is
> > called the folio carries two references beyond the ones it is
> > entitled to:
> >
> >   1 - taken by do_huge_pmd_device_private() for the duration of the
> >       ->migrate_to_ram() callback
> >   2 - taken by migrate_vma_collect_huge_pmd() when the folio was
> >       collected
> >
> > (the mapping reference having been dropped by set_pmd_migration_entry()).
> >
> > folio_split_unmapped() requires folio_expected_ref_count(folio) ==
> > folio_ref_count(folio) - 1, i.e. it tolerates exactly one caller
> > reference. With both of the above held the check sees 2 against an
> > expected 0 and returns -EAGAIN, so the migration is abandoned and the
> > CPU fault makes no progress.
> >
> > The PTE-based split path does not have this problem:
> > migrate_vma_split_folio() is called before any collect reference is
> > taken and explicitly skips folio_get() for the fault folio, so the fault
> > reference is the single caller reference the split expects.
> >
> > Fix it by dropping the fault reference across the split and re-taking it
> > afterwards. do_huge_pmd_device_private() derives the fault page from the
> > PMD entry, so it is always the head page of the folio and always ends up
> > in the head folio of an uniform split to order 0; re-taking the
> > reference on the folio therefore puts it back exactly where
> > do_huge_pmd_device_private() will release it. The folio cannot be freed
> > while the reference is dropped because the collect reference is still
> > held.
> >
> > Second, the folio is split globally but the page tables were demoted
> > only locally:
> >
> > 	split_huge_pmd_address(migrate->vma, addr, true);
> > 	ret = folio_split_unmapped(folio, 0);
> >
> > migrate_device_unmap() unmaps via try_to_migrate(folio, 0), deliberately
> > without TTU_SPLIT_HUGE_PMD, so every VMA that PMD maps the folio is left
> > holding a PMD sized migration entry. A folio that was PMD mapped in more
> > than one VMA -- after fork(), for example -- therefore keeps huge
> > migration entries in all the other VMAs while only migrate->vma is
> > demoted.
> >
> > folio_split_unmapped() does not notice: the folio is fully unmapped, so
> > it only looks at the refcount and happily splits to order 0. The other
> > VMAs are then left pointing a huge PMD at an order-0 folio, and
> > migrate_vma_finalize() -> remove_migration_ptes() walks into it:
> >
> >   page dumped because: VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
> >                                        !folio_test_pmd_mappable(folio))
> >   kernel BUG at mm/migrate.c:368!
> >   RIP: 0010:remove_migration_pte+0x56a/0x9b0
> >   Call Trace:
> >    rmap_walk_anon+0xfc/0x260
> >    remove_migration_ptes+0x79/0xb0
> >    __migrate_device_finalize+0x113/0x290
> >    __drm_pagemap_migrate_to_ram+0x278/0x360 [drm_gpusvm_helper]
> >    drm_pagemap_migrate_to_ram+0x5c/0x80 [drm_gpusvm_helper]
> >    do_huge_pmd_device_private+0x160/0x280
> 
> Which is the branch your patchset based on?  I found that
> drm_pagemap_migrate_populate_ram_pfn() in mm-everything-2026-08-08-07-08
> still don't support fallback to single pages if THP allocation fails as
> in the following comments,
> 

This entire series, on drm-tip (i.e., the 6 patches posted here [1]).

[1] https://patchwork.freedesktop.org/series/171651/

> 	/* TODO: Support fallback to single pages if THP allocation fails */
> 
> 
> > Without CONFIG_DEBUG_VM the VM_BUG_ON_FOLIO() is compiled out and
> > remove_migration_pmd() installs a huge PMD pointing at an order-0 page
> > instead, along with add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR). The
> > victim mm then maps 2MB of address space onto a single 4K page, which
> > shows up later as bad rss-counter state, leaked page tables and page
> > allocator freelist corruption in unrelated processes.
> >
> > Note this second problem was latent before the refcount fix above: the
> > split always failed, and the failed attempt left migrate->vma demoted,
> > so the retried fault took the PTE path, where __folio_split() unmaps
> > with TTU_SPLIT_HUGE_PMD and demotes every VMA.
> >
> > Fix it by walking the rmap and demoting every PMD sized migration entry
> > mapping the folio before splitting it. Demote with freeze = false: entry
> > creation in __split_huge_pmd_locked() is dispatched on
> > pmd_is_migration_entry(), not on freeze, so a migration PMD becomes PTE
> > sized migration entries either way, and freeze only controls a trailing
> > put_page(). With freeze = false there is no refcount change at all,
> > which makes the demotion idempotent across N VMAs.
> >
> > rmap_walk_control.anon_lock is deliberately left unset:
> > folio_lock_anon_vma_read() depends on folio_mapped(), and the folio is
> > already fully unmapped here. This mirrors remove_migration_ptes().
> >
> > Finally, refuse the split for a folio that is not anonymous. The rmap
> > walk would otherwise reach a file backed VMA, where
> > split_huge_pmd_address() zaps the PMD instead of demoting it.
> >
> > Fixes: 4265d67e405a ("mm/migrate_device: add THP splitting during migration")
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Cc: Liam R. Howlett <liam@infradead.org>
> > Cc: Nico Pache <nico.pache@linux.dev>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Dev Jain <dev.jain@arm.com>
> > Cc: Barry Song <baohua@kernel.org>
> > Cc: Lance Yang <lance.yang@linux.dev>
> > Cc: Usama Arif <usama.arif@linux.dev>
> > Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> > Cc: Rakie Kim <rakie.kim@sk.com>
> > Cc: Byungchul Park <byungchul@sk.com>
> > Cc: Gregory Price <gourry@gourry.net>
> > Cc: Ying Huang <ying.huang@linux.alibaba.com>
> > Cc: Alistair Popple <apopple@nvidia.com>
> > Cc: Balbir Singh <balbirs@nvidia.com>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Maxime Ripard <mripard@kernel.org>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Cc: David Airlie <airlied@gmail.com>
> > Cc: Simona Vetter <simona@ffwll.ch>
> > Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> > Cc: Francois Dugast <francois.dugast@intel.com>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org
> > Assisted-by: GitHub_Copilot:claude-opus-5
> > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > ---
> >  mm/migrate_device.c | 98 ++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 89 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> > index ae9027421b80..ae17bd516d24 100644
> > --- a/mm/migrate_device.c
> > +++ b/mm/migrate_device.c
> > @@ -899,22 +899,104 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
> >  	return 0;
> >  }
> >  
> > +static bool migrate_vma_split_pmd_one(struct folio *folio,
> > +				      struct vm_area_struct *vma,
> > +				      unsigned long addr, void *arg)
> > +{
> > +	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
> > +
> > +	while (page_vma_mapped_walk(&pvmw)) {
> > +		if (pvmw.pte)
> > +			continue;
> > +
> > +		addr = pvmw.address;
> > +		page_vma_mapped_walk_done(&pvmw);
> > +
> > +		/*
> > +		 * Demote with freeze = false: the PMD already holds a
> > +		 * migration entry, so __split_huge_pmd_locked() creates PTE
> > +		 * sized migration entries from it and leaves the refcount
> > +		 * alone. There is at most one PMD mapping @folio per VMA, so
> > +		 * stop the walk here.
> > +		 */
> > +		split_huge_pmd_address(vma, addr, false);
> > +		break;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +/*
> > + * Demote every PMD sized migration entry that maps @folio to PTE sized ones.
> > + *
> > + * migrate_device_unmap() unmaps with try_to_migrate(folio, 0), i.e. without
> > + * TTU_SPLIT_HUGE_PMD, so a folio that was PMD mapped in several VMAs -- after
> > + * fork(), for instance -- ends up with a PMD sized migration entry in every one
> > + * of them. folio_split_unmapped() below does not care, it only looks at the
> > + * refcount, so splitting the folio without demoting all of those first would
> > + * leave the other VMAs pointing a huge PMD at what is now an order-0 folio.
> > + * remove_migration_ptes() trips over that in migrate_vma_finalize().
> > + */
> > +static void migrate_vma_split_pmd_mappings(struct folio *folio)
> > +{
> > +	struct rmap_walk_control rwc = {
> > +		.rmap_one = migrate_vma_split_pmd_one,
> > +	};
> > +
> > +	/*
> > +	 * Do not pass .anon_lock: folio_lock_anon_vma_read() requires
> > +	 * folio_mapped(), and @folio is already fully unmapped here.
> > +	 */
> > +	rmap_walk(folio, &rwc);
> > +}
> > +
> >  static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
> > -					    unsigned long idx, unsigned long addr,
> > +					    unsigned long idx,
> >  					    struct folio *folio)
> >  {
> >  	unsigned long i;
> >  	unsigned long pfn;
> >  	unsigned long flags;
> > +	bool fault_folio;
> >  	int ret = 0;
> >  
> >  	/*
> > -	 * take a reference, since split_huge_pmd_address() with freeze = true
> > -	 * drops a reference at the end.
> > +	 * migrate_vma_split_pmd_mappings() walks the rmap, and
> > +	 * split_huge_pmd_address() zaps rather than demotes a PMD in a VMA that
> > +	 * is not anonymous. migrate_vma_collect_huge_pmd() does not check the
> > +	 * VMA type, so a file THP can reach here; the rest of the migrate_vma()
> > +	 * machinery only supports anonymous memory anyway.
> >  	 */
> > -	folio_get(folio);
> > -	split_huge_pmd_address(migrate->vma, addr, true);
> > +	if (!folio_test_anon(folio))
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * A CPU fault on a device private PMD holds an extra reference on the
> > +	 * folio, taken by do_huge_pmd_device_private(). folio_split_unmapped()
> > +	 * only tolerates a single caller reference, so the split would always
> > +	 * fail with -EAGAIN while this fault reference is held.
> > +	 *
> > +	 * do_huge_pmd_device_private() derives the fault page from the PMD
> > +	 * entry, so it is always the head page of @folio, and therefore always
> > +	 * ends up in the head folio after an uniform split to order 0. Drop
> > +	 * the reference across the split and re-take it on the head folio
> > +	 * afterwards, leaving the reference exactly where it is expected to be
> > +	 * released.
> > +	 *
> > +	 * The folio cannot go away while the reference is dropped: the
> > +	 * reference taken by migrate_vma_collect_huge_pmd() is still held.
> > +	 */
> > +	fault_folio = migrate->fault_page &&
> > +		page_folio(migrate->fault_page) == folio;
> > +
> > +	migrate_vma_split_pmd_mappings(folio);
> > +
> > +	if (fault_folio)
> > +		folio_put(folio);
> >  	ret = folio_split_unmapped(folio, 0);
> > +	if (fault_folio)
> > +		folio_get(folio);
> > +
> 
> Is it better to pass "extra_cnt" to folio_split_unmapped()?  This
> follows the coding style of the other migrate functions better, like
> that in __migrate_device_pages().
> 

That is an option. To be minimally invasive, I went this route. I also
didn't know offhand what would happen if our head page had an extra
reference and we then called folio_split_unmapped() with "extra_cnt", or
how that would affect the reference counts of the newly split pages
(i.e., whether we would need to adjust the reference counts of all split
pages after folio_split_unmapped() returns). However, I could quickly
reason that dropping the reference and then reacquiring it was
functionally correct and safe.

Matt

> >  	if (ret)
> >  		return ret;
> >  	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
> > @@ -935,7 +1017,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
> >  }
> >  
> >  static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
> > -					    unsigned long idx, unsigned long addr,
> > +					    unsigned long idx,
> >  					    struct folio *folio)
> >  {
> >  	return 0;
> > @@ -1103,7 +1185,6 @@ static void __migrate_device_pages(unsigned long *src_pfns,
> >  	struct mmu_notifier_range range;
> >  	unsigned long i, j;
> >  	bool notified = false;
> > -	unsigned long addr;
> >  
> >  	for (i = 0; i < npages; ) {
> >  		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
> > @@ -1177,8 +1258,7 @@ static void __migrate_device_pages(unsigned long *src_pfns,
> >  					goto next;
> >  				}
> >  				nr = 1 << folio_order(folio);
> > -				addr = migrate->start + i * PAGE_SIZE;
> > -				if (migrate_vma_split_unmapped_folio(migrate, i, addr, folio)) {
> > +				if (migrate_vma_split_unmapped_folio(migrate, i, folio)) {
> >  					src_pfns[i] &= ~(MIGRATE_PFN_MIGRATE |
> >  							 MIGRATE_PFN_COMPOUND);
> >  					goto next;
> 
> ---
> Best Regards,
> Huang, Ying

