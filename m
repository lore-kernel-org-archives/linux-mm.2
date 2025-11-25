Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ECB8CFD36C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 03:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9236B002A; Mon, 24 Nov 2025 22:14:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1116B002B; Mon, 24 Nov 2025 22:14:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1E86B002C; Mon, 24 Nov 2025 22:14:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA3806B002A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 22:14:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BB45BAA18
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:14:54 +0000 (UTC)
X-FDA: 84147662508.17.91409F3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42FFC140004
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:14:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lZbcpsBh;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf23.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764040491; a=rsa-sha256;
	cv=fail;
	b=kdAC5b7M7pdeEaIpLr/xkJgSabFiRlaZD02jRDWUTzPl/Uisw5eo9WowvNukFzt7d2skOg
	VX4uYqQ258T8iQOcxmDK6lO/V9FF9DoLvstmZwYSeLMa2/s4Kitl0EoiFXuQ/+bDmPuTN9
	ca23ELUlyCZcn2sjIrupFvVzCsHA6aw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lZbcpsBh;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf23.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764040491;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaTeyeGt0cyhlrCtxN4JdTRcLzvQ6mvZJ+AAptaESXQ=;
	b=JlAoQIWZ9cJdPdMfBSbBpAx0rmSGDe7shU/KP8tL/McbHToBYRHLvjo802w3MVdoqt1cDN
	W4FQ9oOf+SRsZH2AAN3TBsePzMxIbFfWS5Hq1YspjQCrII32YXo0I7l4rclJRU2YoJnrrb
	v+ID3XDfPwEJAYtUf5kccMVqObqHWfw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764040490; x=1795576490;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=FSU5ZzTYHYOAH1Sb8SHnT7RuJjp4Lo9L1EtqMVZx0dY=;
  b=lZbcpsBhAjhsUOLmfeAH4CFZoUXIkD6PFlcL8gyKGZCkRomkO41odxF6
   SbfGh9WdiHH+T7XASl8+8rEEzYs6q6El/X10RoGR3ZyQhJ5fUdeLB/m7Q
   PLCfnn8SmI1U9cKII1IOvIL2Og7vNugL0/esYgw2UO0P0zykCYfc9zsp0
   FSpxLOKYLHwRx3e2V0rbFfGl52V8SaSisHgc1rnOVm/2IvGK6swk+JaKz
   hKJ0R2JLzsXxAhcv3eHqfJdpOUtUM1tPNzNLicr2dlrtHTL6PoCOhHZWC
   Ww8oj7xCfYbjIH/NzwUNZaLRWbDiVOqn7VD6nGNrlrNPaLV7Bv9QQb4f6
   A==;
X-CSE-ConnectionGUID: H2X7NEx2TSSqPosVUeq35g==
X-CSE-MsgGUID: SJzJUytnQxaoVL1jHxFF4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="65757586"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="65757586"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 19:14:49 -0800
X-CSE-ConnectionGUID: f7Jx0y/6QnWx/Dt+kaFvyQ==
X-CSE-MsgGUID: gHpjU2L+QLyo7w+rlkV5qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="191648823"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 19:14:49 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 19:14:48 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 24 Nov 2025 19:14:48 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.64) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 19:14:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DO53a5MnX3RgWp73ZszXPmcdeKwQ70PRSm4MdzCWWa8tPB+elJtzU7ornyW0pUtCZwpvxNksAGgozEjyWzqhbYlf6hN9tPutcsFWwl9+FcZKSZy0f6EfQBwGb0If0eyKjoOyds7POuMdX0Lzbf6anCGrOzpA6fLyRp6ZVkrzJs8pSUwTHaGn1phuZfxrZI73P5B9N2uVNO8Y5S0S19oN5ZYuBZGsfBGat6Dgz2Vr6uJSh4ops4cBMP+kvDlDt8ZKIRdbDjyxqxi6MefpJNIQyO4vkaAH7U3zTLTu+0v06OeMiB8mi9ARVubAq6WFgMZD8ITcQhBl2SWVBdDP3W4YVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oaTeyeGt0cyhlrCtxN4JdTRcLzvQ6mvZJ+AAptaESXQ=;
 b=Ed6eDo67rGpKREsbfr8zo7bEd3dDiMC8SDCE3rker8eC8mt9GN+FFHZ5HjB+AXaJrl+13tAMv7BRd4OF3PczV0ni/LCchUAGq4ClS3Z2fQI1JTKnZeaDQ2Vzv7m91rT6QUTNFfHipXOUiTIoEiW+fonYcl38wBCslSfGVO8QJ5Aou7GsU90GWrywDS8v9zPwTdCF6GciFKil2M6SVSD/+ddPU1xexlpogkvuJ/oh1TdLksIMueoacl3c/N8HtSSJpmeAKRhgPKTYhEcNe3LSF2r39V30t/PZhW0JN+U2pR6gXFfOPCqX80BJuAeC+TSkpZW3t7/2GZs1ocNtRFjG7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6927.namprd11.prod.outlook.com (2603:10b6:510:225::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 03:14:45 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 03:14:44 +0000
Date: Tue, 25 Nov 2025 11:12:30 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <aSUeniY1WCeaPobT@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
 <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
 <69247f5fd9642_5cb63100e0@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <69247f5fd9642_5cb63100e0@iweiny-mobl.notmuch>
X-ClientProxiedBy: KUZPR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:d10:31::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6927:EE_
X-MS-Office365-Filtering-Correlation-Id: b501cddf-3f94-4abc-f536-08de2bd0c85c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/peT5ZndmSgZDW9CwuNz6uHBLsg8wAWyQWK98FX9ZMmYbL0pil8n55VWvEMY?=
 =?us-ascii?Q?CeYRNG82PEWXNJDyu7wlKcw/DstMjdMu5IBR9MTkTNXYLNuSEjZIZASOMMxT?=
 =?us-ascii?Q?nZuzC9fj1ohR3g7pLFfiP/sH5ivnfunB5ortqb0og6bc0TAfwhUvsSQqip3z?=
 =?us-ascii?Q?37QeEn4ApBLFjbx+iR7/2GFy4Ea6kHbldqWlT9WM3ib9xnkHFy5dnJYQsFQ2?=
 =?us-ascii?Q?6VeJ+KJraSnOHn6YBBhB68Y13DgEve1DKIa/Am7imYjlYW9l2AKQsjnBBbWF?=
 =?us-ascii?Q?244lrA2tKDaeGAE+N4tVC2XUZs1iguY1UrHZC/JBZhEOL4kC1UAwEGdgsUjx?=
 =?us-ascii?Q?tze/aT6ROX2J06V7PyeMmVNSl96NfFi6Yto9h96brKEEfaMqQ3r2RIWOIYak?=
 =?us-ascii?Q?oMn3WpnnQo/07uXZe3vUT53mM8GTFVe8ICOeXIPcamMFllyNv8BLtXpOp1kq?=
 =?us-ascii?Q?JOVuWvdpxpnYFlU8Z0XFbxrGI0Gm0vxzX8msVrCht1WYrCxZ1sk9nT4BzyMt?=
 =?us-ascii?Q?/hh1Yv+Q36pgaacxdbnbHR7U8yMAMBYM6TJ1Xk8TdMu3DaYPS3D2W2gOxLid?=
 =?us-ascii?Q?gI3AR1gql89PkB8aGzlA9RooJsIHu6iMeAaJBPcn7WTo+Tni6WT4YslX9hc2?=
 =?us-ascii?Q?FGw2PgiPYn9GbWrSKa8wQgqFmfTDlTDmNzuIkaqQZybS6hUyRw74hv/vjszX?=
 =?us-ascii?Q?GdIu5RaAG2dUl/6NBk7hqCvMUOXsZNTA8F3s8vN+AwxdQOxALVvlq7mJxtTa?=
 =?us-ascii?Q?RTF5KsYcBWPIqrQzhBChzBL+aUp5kuPsJ8lAJqM+kFOXn72y6dWcpQP4x8yq?=
 =?us-ascii?Q?V2ftic2KiZnq2pqGygxfhmxj18AWAUtg8uJi9j1gGwxkeJ2IpIzXIelnPYcs?=
 =?us-ascii?Q?oXrAud5d9zhbv638PYVNteXon+HHeVRPLIyILwqSZKv0/cMYmxYCFH/uDCmi?=
 =?us-ascii?Q?8Nv3asw4vdbIGXGMsxcmD2JBXbJ7ZN2WHfOnbrrBQqf1KwGHW6TwZElaNPo1?=
 =?us-ascii?Q?keyMiqWkP5bWfdwTJ/HvEKxfApMQAhSK/OppciqgL63enQi9HzfLxwRhMsiT?=
 =?us-ascii?Q?sBKz2MPMXrXzHmWkn/xn5kOXUvagTWClbCu+1VSVBij/4+b5qB9oV1mfp+dt?=
 =?us-ascii?Q?pu8jNe73SyY9Of9iKjbX35BhSHMcC9cOLDM6rGU762GXPIKkEY40jGK9HKrQ?=
 =?us-ascii?Q?SXp5YYzf9YXGGEY9V5fYVEOnSnS6OMkLgpoWyLXluGAbDZGE0LNbVr0L0x23?=
 =?us-ascii?Q?nrmJNtVyF7GrbxDnfqN6fb9KRcP85jrdaLp37nvvjhXG8x5BgAnjogsg/6tC?=
 =?us-ascii?Q?tb/7YRXYzSDfR0I3JENkw+kfZGoUHe1O7usvdTSfhfWFupciJNkxNsm3hlN4?=
 =?us-ascii?Q?x2xXvQ0dgfub+T1B9eReu20TRkNA1IrqQRKBm8jXtEOmHEqcjbiFUuCcQb6K?=
 =?us-ascii?Q?x9BrCEj0wSdWUMO0xGSD70c4B+rOPNCl?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GSnYyDGBensCFGRGs74RItVBItHE5fvr3xGtURDlpd2euqN6cgkj/IXi6HJj?=
 =?us-ascii?Q?lV+VaUBdx3GuJuotFmY/f5Nsa6VFNvPFXmpvMyFEqr9QyAqSEAr7M4hTyMPB?=
 =?us-ascii?Q?CpY0x5cWB+2/6Tkcp1prP7pxhRvzfKmhCuqB1wu8rkfr6rKZXw5ZuTehJGip?=
 =?us-ascii?Q?dQlN+3NJKdQ3yC47vOTeWtBCbNxzwZiFvs6kxI8NFg1qdHb0GQPKALxfaRAT?=
 =?us-ascii?Q?JjWt4Som0d3k5ft/7RA6ZO81RjyUW5s8wSmxUhlUlJ+IOWffePO+0ZmQ9HUC?=
 =?us-ascii?Q?g7+9A06Ryua9WKFcw7parBOQLxu1wzC1l8suDAeWIY1WapzXQ7QlsD2U5uHo?=
 =?us-ascii?Q?eSukAfvs23Fhj32g+bmHMEAo0mjhWoRV7IH1yJbF9ZX6HVM29c5j3qcaJCxX?=
 =?us-ascii?Q?rY+SuRsZKb+/ktb6FjBShfGecZ28Lns+hQ8wObgJY0BF1QvlNptQUzus9qHo?=
 =?us-ascii?Q?r9pbuYr+c9hBt0zjesR/OM2dmsdrAv5n9C1zMGSXgZz6TWy/Hi5VdG0cd3jV?=
 =?us-ascii?Q?78/M/amerTeFKL85w3Ucvaflwpsgq+HAfHymQCPLqkHZd0SFjHlBBkmpBjbY?=
 =?us-ascii?Q?0eCWjnxbuVLJJyxcEJNoQq6y/lSUY47PbWEQk9FD97sXUBPHJH8vEFMPqFjj?=
 =?us-ascii?Q?YzPlK4Lu/TGR2VWTYEwzSyhZSJyEP8b4poaDU/9OE9yYi6kxzhCIAOoL5RHP?=
 =?us-ascii?Q?f+X+8aUJznkXI84Mwk0zrg453LoXzJtk476Vf70OUjhb1BF+NYpAfw9qv1qi?=
 =?us-ascii?Q?gE+1/iicSpeAURzxuDDN4yZD9rlfZN3l2YM69h5FMV6WAi1XaZfzKFBHAe7/?=
 =?us-ascii?Q?NVin7bjo+7qKS+ZR0Q6DvsqwLqHzLMOcpRDaC/pdqEYST+OZNjldZt+U0G8L?=
 =?us-ascii?Q?GX4Qb6aLsr+9pAqqO/mCyNTkeZ7Xv+wHAaCl9pexzu114weKAShdY3pCgkUX?=
 =?us-ascii?Q?4We7llhpWRXaU3B9tgylaAlqRJglGBf+J6C/aUISqnEjjM95nDmy4zLcXye7?=
 =?us-ascii?Q?YIY5zwgY3S+tgAt3WQYMqqFumUKAj5lHhpp7LmNggBJs4nW6PLjCvy4G+3R5?=
 =?us-ascii?Q?sgCSe4dJZsH7AmFxcAInUieAYqoMo17yZz9iePXSr6poqxUeym0kNYhEM9r+?=
 =?us-ascii?Q?Qv7zgqnHc9NopAOMP6suaWcnouQRMwj+0JjgGsC8M0bi0k7+DA2gqyoT+sFB?=
 =?us-ascii?Q?8iXutVaAcIq5QpcHGkq57moYsTAsWtGtypY1ay/Wb9JUy6/gztQjvR6gtQnp?=
 =?us-ascii?Q?TF6Qq7MGjKHNE32b7T2+BrBYVqwqporyfbYinjYnhFn/Uko5ofQpz1TrA5jS?=
 =?us-ascii?Q?1KnAhEbPHG9vAq7UWg/8FLLCwxfBISlTUcJJHpd6gxS0LluZx+X/Jwfb7zce?=
 =?us-ascii?Q?rSj+cyYV04LDAMlOLkFyjR1MuHNzAcpgV6UX4FW2VEWTsRgeEyhTUp2kjuIQ?=
 =?us-ascii?Q?q6NJZBYq8IHPThx+29u+IEQEdHSobOL0gZB2Q7PspzhMrMvqFfGeWo69f6fI?=
 =?us-ascii?Q?s7cvWEnv2oe5dHTXbVSWjnojtDfnb2mkt1kstYUSk0Ry4Q9rmknvsJjSFJCJ?=
 =?us-ascii?Q?TYdVpYtx5a9qmiMNtqqu9/Ooe96bY1yTP4D6wrvu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b501cddf-3f94-4abc-f536-08de2bd0c85c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 03:14:44.9421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1K3NKvN3Sqb1aYxsyU/VkRIhrjBBxmEAZMt4D9ifgFmn3Y+n4fQOohO1E4QLkcZjKGeuNV8V5YqBJJjI3bVo6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6927
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 42FFC140004
X-Stat-Signature: roasywzdmfiefxohigx97qim5dihc4mp
X-HE-Tag: 1764040490-863898
X-HE-Meta: U2FsdGVkX192PgX7liJoWdX15WgtE1ck5AGg9y5Fd7vEUYlBlJf9oy95CDkAtyVu3iaIdW+EVAYsX1sQMBylydPS2xlLTv8uqhoaKcdgahVW8K0D0JN6iGR2L0nEmkbBm288rZyTuMzDi4gFpecV6adQpZmoBNihOem+W/TG1qs0FK3C2VtaBPHYyNN7o2sv+xnltnFCGJk7mUaPq+RT123tXjzGZIGQllmoc6gpT+TSAoeEO90LDF6QT9ikcCpHfnefgMJmBArmiPQWV2T7SN9dPf14/Fa5PMBegQi0H7nm6g4w0sqk/q61a/Ni5qrnKqfUzQhwZ+clcqB6T/C+P+KjASS2R6bX7rpLtUXe7ps6wrDdxt+zg+y4m89C+1rmn+QYerueJww9Tm7jhmIrQXD6KqnKH4G1PSvmqbVN3zZdBJgMeeqJJNFe1UguhCnmjJRJIeieSdxfUQptF8u1MgsOo4pXMM6pAnbF2wQ0drQO8fHSI4BZKRS01HfuMVloz/FNjV53AdXHHGQvXol2dxE2YJjz2ZQYHZfEaWOCKcSCuk8CZ+bBgcUIgBv7ARS58u7NeiGxP9fgZ/q1TXYkZ8WoC+93Em6pdBgtvtmUMEz7tHXuFhovUzguDmQz6UsBYHWL7A0OvXdOKct5C7Rah8IcebeOT4wSBIzVaUK69Pq3XCIEYv0nh0rMtBf6dYL8A4FGQMuSgcL0ILiITT7BLNwrEwG4GGj+KeJzOMRJxg95G8Q86lyN/wENQXRSeLfDV3g5Du6w9tVfTaTR0aVuJ5xPshbVtjddpeCVcri9okme4czht7MJPxP8vayf3EkFkS0sbnxG1/iLL45TvhxrNzO1qARsyM3g5MDQ6EZtzqftawmAz6qeuLBj+HkuqrqbZ+3hbZupVROnsGqX8LUNHxWtp1clfXEtae+rWyyd6j+k4vaIMNP/BiyOL2vsgCT4lVcfdDOar2TE0fXo5HR
 0ken2Mms
 coNjBB72I7g6RC4QGKBVbf/M+b0lR7CAWCeAIqrJras0N+rs/nzBuEjhvYYjfim3d5InPvaJqf5+yiNsEul5CpeX/YtAXSrz5fbY+LY+sQ9NxiozgAaIRbU0DcEG3cnuNss9ssyDkwPkQRkj9uJwhTwXSBJeNg5tZR4lvQn2uRT46GtKtp/+vg5dSSkBXa8ll5ijeMqwoUN7nmRpslupi81leUnMEusUOcpn08kmvtSL42UK8A8MAYvuA0c8R2Xc5ijz2WVd9B+fxiqLI4kC75ErnIxzaW5JBPa4dWmWKuzWj84Q8+I38J0D3FHOo8tSWAlUjOcOGhBIjzOU/kGqR2cKIG9o6xqKyNpALgdDJuaEFNSm4zDuNIkBdVGK3k/gPUFXjPdrbLYbg6Jf1G5unOPpQLO11C0SuYEK8dhhrUTcet/gL0x8gh6p+XqCchYjhhWw7O1/eFM+LgPdn1Lm1Vcvl4yGgcGdDpMi5BGMTmhIBpYH/mVSphbAgJj8MKh5ssEq/l41U9hq6GKEaVMHY9NwETTvl2NAp4ivRvjMz+RXCmvmyPBRbcbHPfjyglX+muLaeIuBCwUu6uqY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 09:53:03AM -0600, Ira Weiny wrote:
> Yan Zhao wrote:
> > On Fri, Nov 21, 2025 at 07:01:44AM -0600, Michael Roth wrote:
> > > On Thu, Nov 20, 2025 at 05:11:48PM +0800, Yan Zhao wrote:
> > > > On Thu, Nov 13, 2025 at 05:07:59PM -0600, Michael Roth wrote:
> 
> [snip]
> 
> > > > > @@ -2284,14 +2285,21 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > > >  			goto err;
> > > > >  		}
> > > > >  
> > > > > -		if (src) {
> > > > > -			void *vaddr = kmap_local_pfn(pfn + i);
> > > > > +		if (src_pages) {
> > > > > +			void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > > > > +			void *dst_vaddr = kmap_local_pfn(pfn + i);
> > > > >  
> > > > > -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> > > > > -				ret = -EFAULT;
> > > > > -				goto err;
> > > > > +			memcpy(dst_vaddr, src_vaddr + src_offset, PAGE_SIZE - src_offset);
> > > > > +			kunmap_local(src_vaddr);
> > > > > +
> > > > > +			if (src_offset) {
> > > > > +				src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > > > +
> > > > > +				memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
> > > > > +				kunmap_local(src_vaddr);
> > > > IIUC, src_offset is the src's offset from the first page. e.g.,
> > > > src could be 0x7fea82684100, with src_offset=0x100, while npages could be 512.
> > > > 
> > > > Then it looks like the two memcpy() calls here only work when npages == 1 ?
> > > 
> > > src_offset ends up being the offset into the pair of src pages that we
> > > are using to fully populate a single dest page with each iteration. So
> > > if we start at src_offset, read a page worth of data, then we are now at
> > > src_offset in the next src page and the loop continues that way even if
> > > npages > 1.
> > > 
> > > If src_offset is 0 we never have to bother with straddling 2 src pages so
> > > the 2nd memcpy is skipped on every iteration.
> > > 
> > > That's the intent at least. Is there a flaw in the code/reasoning that I
> > > missed?
> > Oh, I got you. SNP expects a single src_offset applies for each src page.
> > 
> > So if npages = 2, there're 4 memcpy() calls.
> > 
> > src:  |---------|---------|---------|  (VA contiguous)
> >           ^         ^         ^
> >           |         |         |
> > dst:      |---------|---------|   (PA contiguous)
> > 
> 
> I'm not following the above diagram.  Either src and dst are aligned and
Hmm, the src/dst legend in the above diagram just denotes source and target,
not the actual src user pointer.

> src_pages points to exactly one page.  OR not aligned and src_pages points
> to 2 pages.
> 
> src:  |---------|---------|  (VA contiguous)
>           ^         ^
>           |         |
> dst:      |---------|   (PA contiguous)
> 
> Regardless I think this is all bike shedding over a feature which I really
> don't think buys us much trying to allow the src to be missaligned.
> 
> > 
> > I previously incorrectly thought kvm_gmem_populate() should pass in src_offset
> > as 0 for the 2nd src page.
> > 
> > Would you consider checking if params.uaddr is PAGE_ALIGNED() in
> > snp_launch_update() to simplify the design?
> 
> I think this would help a lot...  ATM I'm not even sure the algorithm
> works if order is not 0.
> 
> [snip]
> 
> >  
> > > > Increasing GMEM_GUP_NPAGES to (1UL << PUD_ORDER) is probabaly not a good idea.
> > > > 
> > > > Given both TDX/SNP map at 4KB granularity, why not just invoke post_populate()
> > > > per 4KB while removing the max_order from post_populate() parameters, as done
> > > > in Sean's sketch patch [1]?
> > > 
> > > That's an option too, but SNP can make use of 2MB pages in the
> > > post-populate callback so I don't want to shut the door on that option
> > > just yet if it's not too much of a pain to work in. Given the guest BIOS
> > > lives primarily in 1 or 2 of these 2MB regions the benefits might be
> > > worthwhile, and SNP doesn't have a post-post-populate promotion path
> > > like TDX (at least, not one that would help much for guest boot times)
> > I see.
> > 
> > So, what about below change?
> 
> I'm not following what this change has to do with moving GUP out of the
> post_populate calls?
Without this change, TDX (and possibly SNP) would hit a warning when max_order>0.
(either GUP in 4KB granularity or this change can get rid of the warning).

Since this series already contains changes for 2MB pages (e.g., batched GUP to
allow SNP to map 2MB pages, and actually we don't need the change in patch 1
without considering huge pages), I don't see any reason to leave this change out
of tree.

Note: kvm_gmem_populate() already contains the logic of

    while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
                                            KVM_MEMORY_ATTRIBUTE_PRIVATE,
                                            KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
        if (!max_order)
            goto put_folio_and_exit;
        max_order--;
    }


Also, the series is titled "Rework preparation/population flows in prep for
in-place conversion", so it's not just about "moving GUP out of the
post_populate", right? :)

> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -878,11 +878,10 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >                 }
> > 
> >                 folio_unlock(folio);
> > -               WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> > -                       (npages - i) < (1 << max_order));
> > 
> >                 ret = -EINVAL;
> > -               while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
> > +               while (!IS_ALIGNED(gfn, 1 << max_order) || (npages - i) < (1 << max_order) ||
> > +                      !kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
> >                                                         KVM_MEMORY_ATTRIBUTE_PRIVATE,
> >                                                         KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> >                         if (!max_order)
> > 
> > 
> > 
> 
> [snip]

