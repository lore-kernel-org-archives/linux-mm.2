Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75E3FCFC50C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 06:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4138F6B0006; Sat, 22 Nov 2025 01:56:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4A76B0007; Sat, 22 Nov 2025 01:56:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3446B0008; Sat, 22 Nov 2025 01:56:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 194DA6B0006
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:56:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5065788CCF
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 06:56:20 +0000 (UTC)
X-FDA: 84137334120.16.BBEC6F3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id AD4D9C0008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 06:56:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LeemeNLp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of vivek.kasireddy@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=vivek.kasireddy@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763794576; a=rsa-sha256;
	cv=pass;
	b=r8TtotXtYECNHzcLVIjRwEZtb+bob7GJCXPKc+Ep/uj3RycsDV7Z6Boel+CVawos5iZ1w1
	D5gFpTnjXL+UquDjurjJLEFxzqeK+X5/0qkOhruKf2n8ocbPcpAjJcp6inX3w1E/7v/vHi
	tBOgGhnvs9jNjqeLwJ1wCM7kN3+dz0I=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LeemeNLp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of vivek.kasireddy@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=vivek.kasireddy@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763794576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgCtNn5j4q2TCBfZWlZcNy98qrwPZnYs1Jdw31Gm080=;
	b=1zlOUS2KYAMGBL5UpDpcayeoAzp/aZhi/tMXlltdFXmVvY8di10gYgAkr7/EJc3E5Hc7B5
	S5Lrr2urSa12TkJp6HfTJuAxxCl5liL8DAvRlmcuY/2Yn60wQk8ZWAmrYcXVL1GU3m55kR
	MwSPrJYb4a64ZhCANhBV0DYt9EAI+FE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763794576; x=1795330576;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eefMYamBnCZ+3s7kD3tXPorDXD3SFPsAA5InzetWHVc=;
  b=LeemeNLpLEdSR671zqZ6iwO89FDHuL4FbkdtX7dqfTrfrRNn++hmnkOP
   ALkAx7cOyNRKASbVY5lydRVcyCCkZrEFxzQlWo3X+eajZxvkiZ9D6hvII
   qdklS/QkvYggBwlP973tmjgo1ex3357k364XuapCKn5mYYOLw4m8a4Ca/
   Opx4oQFnQ6P7fgoiwyminnVqokZhWVTzbyOr/E2jRps3fMJqGKGrwOAxu
   Asr9bQfQP9a+tYPsyOosxrM3uLO9I4P6gdQpyW/CtZJ3OgwmTe6GOTWHF
   vWEm9R7flIS/y3Ua9XlrV5bDfCe2i2C6KAaG1C1oVHcj9nRqsfl4IgmvX
   A==;
X-CSE-ConnectionGUID: vjs+Bfm7TRyo0wh4gjZwqg==
X-CSE-MsgGUID: FJ81b2fnT+qMc8auQ+xB0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="65912715"
X-IronPort-AV: E=Sophos;i="6.20,217,1758610800"; 
   d="scan'208";a="65912715"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 22:56:14 -0800
X-CSE-ConnectionGUID: zPtQC8MjS2CdGazNMygDSg==
X-CSE-MsgGUID: kRXFhcGVRdCHa4FoIn5Nfw==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 22:56:13 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 21 Nov 2025 22:56:13 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 21 Nov 2025 22:56:13 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.50)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 21 Nov 2025 22:56:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J5w1azAw8CsubVJ0TMaccZHUkz6PFYLGU86eNiqxI7CNYgQ23j5hS+z9hf2rKSAIhffWqXQwMEG31cP3krwqUHGuT5MMSKHOxDG7My0PGoVLaXCGTImF+Cefi9BKKpMoC5tmbpid+Ifb7jAS8q0hgXnzoFW8z5MEn7D/wyizeTMCfV1oR9YjyyHzK0ISXNvPVsyrYTTHYlU88QKhhNHqMPMp38yG2zCZlX+K0NJpcJLML8AE0drHIjX1dB/K7qKsFqPu2pX9UEnuSVRFKKSvQk0gdW2tCOoBlL9+jR3S/p7AM3KpxaFimN5/yOJ4UDQSrJFvey5Eyt2gY3FNsMRvxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgCtNn5j4q2TCBfZWlZcNy98qrwPZnYs1Jdw31Gm080=;
 b=NOGcpdVLfvsDQ4aolut/wahsrcEui++4yj8ctQDF8SYdw+3SpsQzBz1B4ujGyjJZ7ffgcndlIQG2OY6RAh61Cb2NZtNZl/pQ7XLQgJ9jx5r1NTW9p1GB8/7yY6U1V0nSIJZ8lQzJvhKDIGbHJlBnGO4vwXBHXk6blK90RMaLVJeLB20uZ6DmV+tQWwaENxwGivhnRmInKkFCb5buAn3Gyn8jG5SxlkR/wZaqKP6Ev319ZxEBL+3EPK/0kzadP/IKvQfysjFxWLmhW2EZollQQrUPVZs46erb90+MytRHO0spdDTR8di+D+8A+Zat5PqW3/JqsGyt5NZ18j52qcIkWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA0PR11MB7185.namprd11.prod.outlook.com (2603:10b6:208:432::20)
 by SN7PR11MB8261.namprd11.prod.outlook.com (2603:10b6:806:26f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Sat, 22 Nov
 2025 06:56:10 +0000
Received: from IA0PR11MB7185.namprd11.prod.outlook.com
 ([fe80::dd3b:ce77:841a:722b]) by IA0PR11MB7185.namprd11.prod.outlook.com
 ([fe80::dd3b:ce77:841a:722b%3]) with mapi id 15.20.9343.011; Sat, 22 Nov 2025
 06:56:10 +0000
From: "Kasireddy, Vivek" <vivek.kasireddy@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, "David Hildenbrand (Red Hat)"
	<david@kernel.org>, "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton
	<akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Akihiko Odaki
	<odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: RE: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
Thread-Topic: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
Thread-Index: AQHcWd+c2Qg+ux/sU02Vsytz1SfX+bT7RY+AgAC3ORCAAMcMgIAABcuAgABykQCAAHXQgA==
Date: Sat, 22 Nov 2025 06:56:09 +0000
Message-ID: <IA0PR11MB7185919CE5971661EB5C4519F8D2A@IA0PR11MB7185.namprd11.prod.outlook.com>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
 <IA0PR11MB71851184AA5977BBAFBD55C7F8D5A@IA0PR11MB7185.namprd11.prod.outlook.com>
 <070dcd0f-ef77-4924-baf1-6c380bca192d@lucifer.local>
 <fc85d934-bd1b-4fbf-b4ab-37ba061e72b0@kernel.org>
 <cii5ukeq5uzktg6v6a5bnesjzenwkmnokdwvne333enekhtj4v@bs3jcbxafwt5>
In-Reply-To: <cii5ukeq5uzktg6v6a5bnesjzenwkmnokdwvne333enekhtj4v@bs3jcbxafwt5>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR11MB7185:EE_|SN7PR11MB8261:EE_
x-ms-office365-filtering-correlation-id: 950cc40d-843b-4e18-469f-08de299437c1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?CRv3kpkXwmznaVa8h83aCcjln9+yqAaprs638v1AaqLYM2RreQ5ZZ4FSsyiL?=
 =?us-ascii?Q?MBxBbsrVWHHN+aKxlDyzZYM77uoGgHlUxZM8ks+j23GOFgNV0uctShJD+2Qn?=
 =?us-ascii?Q?RIi2XN5A8t2fY+JTfTQUOn/9mfZd3ORKopt02xxRSFZhemnPI+g3WaHrYGCm?=
 =?us-ascii?Q?qmyJv0mlXG0LqOcvEJMIA650Qa88UPEceTBzo48eNdzOhrZy1uF+Y6NEyugs?=
 =?us-ascii?Q?j8ADHNcwRSNEaC68BV8HyVUPnQnOYRAyZ2wv2rUWe32NGgUsENzuHzNKze9/?=
 =?us-ascii?Q?itNS7JDgXE9yNrvJaNfAZ69vbmxQzECy91Dzalrnqhs/8RNU0JD/WIA/zukE?=
 =?us-ascii?Q?ol+n0NYbRj3M/qeNABrcAM+Rp7+iqey+NceHn+j8tJgBVIgwA8pDOiv1qA0T?=
 =?us-ascii?Q?5zN64LgHxxnrtliEWzM+cdVwlDnR3lyvR1SpgVOvakdBbeoADvlIwLatLNOI?=
 =?us-ascii?Q?dF3ZPNouRFIBeCznDccqm+KuqLfDTXyMGqN8jAI1euACPrTS+RbdxnPPQYhh?=
 =?us-ascii?Q?kLiPgTQCu76cewUEGYMOVzYVwATcklORZES74qsw00wd6855G9Zcnr9pkOR3?=
 =?us-ascii?Q?z+wF/+eE03h2WnHcrIi+TCt6uKgNKL+SrzjLiiirUvF/bQGVm4DkofCJ71Kj?=
 =?us-ascii?Q?2KcUqqoMWSATHGPs75zBBK+ubKS6nzsnLWXT1YLCyJA+ahCt7ffl4ySLQ6Vr?=
 =?us-ascii?Q?MAyRTaTkJ5USDIhb3bjcms3CbkxnkLUCOYfZ026yU44sXcIAkSBtL4X0KuOW?=
 =?us-ascii?Q?jhyPDlvCvWTw1iMwj5Zca4r8MghTHEB7BWc7cGKupLHqLdeVe3Ipp/IKp41I?=
 =?us-ascii?Q?ecojiX1R1ZOStVFAjP1Vzx2KSi7H/zlGwdo4eedGPhSAg3j5TjJQh/zKqUAd?=
 =?us-ascii?Q?WF/8rkpaI/DBgpe9Jc5RSQUjs7uKQ2xS6GXcP+Q8CjeZPyUS+tfBfjC7ZSJk?=
 =?us-ascii?Q?6fqw8soqrOuyhfPBex2Kd/kXL7QvBSySry2Bj6MvYNnKvIsT5daP60jsNN9g?=
 =?us-ascii?Q?9hzMkbOKnDxtXBmaUY0o2E1MnzvbUZSSdquzmY7An8yfLh/Ie350449lPNuF?=
 =?us-ascii?Q?QUxfsNqTil9ubb4Ezk7JBd6Uju606216J2ndKQwrKIhrCouciIZo6J4eD5Pe?=
 =?us-ascii?Q?9VN+c6u2Po4HsigmXKfzHRfZpVINk0fphYeVSa48NEtfV+Nx5KRAvQYlF1pe?=
 =?us-ascii?Q?tIPrVWZSKsXBJ2xicttloiHaM8et2/rL8KgQjwyjVkuysTgvSb87TZLIokkA?=
 =?us-ascii?Q?vfHC/BLkwWB0kbObFZs0Qgo5OnQ1J3XVgrUGxDEtj1kdwMnxojkAdPNAcaQC?=
 =?us-ascii?Q?k8d7JfAeTPSdPsjYPlVcBTi/KxNclkja0goKNpgZyKDs3w/AzRFPwPh/+CNC?=
 =?us-ascii?Q?xPqR8TImZqNFX99oO9hFtMWgZHG3JZ+IIlbvJRg9czKPrd7A49KrF/SJ0FGy?=
 =?us-ascii?Q?cyVL/v0LUvyB1nBMwpCuBDeTzYPD1PI2N8sIlA4hmLklYLnsM0QhAm/q9oUL?=
 =?us-ascii?Q?APvmv8/8hTZTE/aNzJ1oTPDCwqSYTyzxMP7s?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB7185.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2OGIod4UTVza8weNQeu75JgkO1uuNpNlyPr/B+zdxWgIKyPLzaa9G9v7WLse?=
 =?us-ascii?Q?Ld+IJ4ooJudFz5cGffG/JFTRdvuOscpa70weqkaUH/iGJi+OUWUtUgdrxGKI?=
 =?us-ascii?Q?B3vVpNXtyaKZj9rht5ffh1FtP4MzuMwD6uXxPiEcYlaa1UeC4DuGuyQ4j3F4?=
 =?us-ascii?Q?9xEOKGB5L3NYE7cVkYu9GK6bGCpP9QDI1U7y6yo+Yb9hhqrHQlq8L1SG/IhC?=
 =?us-ascii?Q?tsyKQrHj5alwqYieQewkubb+TEucG2n2hoi2JCWrl4chsWP852v8y5QYLu/3?=
 =?us-ascii?Q?qaP71OI7zwJg3+DSC7914ocurOsQ4eGFwcB00r18aSjQ1uXp75SI3I8FZdCL?=
 =?us-ascii?Q?ImkP9FTKkk8XKDXNrf6QAId9j0cVovOhR/bWzWuikOtXpVEAlWsgsKA9OvBF?=
 =?us-ascii?Q?2wAIgs5GFFyFYwU9s1YMpyglLcB/ypJqVdxibxnNpPKGvdU1M5B5YV6+DT/u?=
 =?us-ascii?Q?sV/1FelOPOU8iwdV7tQ30rqo/X+OK8cOx4E8/plWxoma7/rYJNtDSftiQUD+?=
 =?us-ascii?Q?Mp8bmik8e5PGKbpkwcsrRSoZMbYX85MQIr76Vcrrmw5xJklBAbpBGxX01x7i?=
 =?us-ascii?Q?IHg6EHiV+JWMyd4XK2MSFHfGgqNL6RDpolunZlYylNhjhmNKY8aBAtDXI4BR?=
 =?us-ascii?Q?T7LcAWWILy41HQBAlhM+NZEeXceHYgO56lCAFfkN8sMXjLUJndDDQxprROwr?=
 =?us-ascii?Q?KAqkKimqRJsuyN8DEl6L3jrv+PKdnsribR8VBWO5iGQnObvZSAHDk6ruAfGh?=
 =?us-ascii?Q?BVj82NjcOgoGqavtoeeXG5VPwj8iJayr9cVqU+kdXJTjNcRU74VaKQOw2LJP?=
 =?us-ascii?Q?pWIPwC7WS/bAkVIu34wu0x2gzceNyuHMCfLzD3xCNRUWh4A1OQYjuxPEgLoc?=
 =?us-ascii?Q?5ljudalkzfANEFitieCQKNL1ijHZAc7g9YVW8I+MZS98cAMrsVUmwXp+9auX?=
 =?us-ascii?Q?eVVqcEXS+MvTggtyVwxGpVvhtKZ9BUscubEe9GbsIKP/rQZJbOPP03OwATR4?=
 =?us-ascii?Q?kVWQujWgSqvpnS8bR9mypkA4kSQNioC8j2zvTAC5QbS80JTWyO8A8OLH3dWt?=
 =?us-ascii?Q?fFaM1foP61I4fXIb3UqrjMrGmj78tnJIvIdZE2oi6XPP+4ARb3W8A+t/JtLa?=
 =?us-ascii?Q?/q9HvWp/+o8yLhXf+ha4I5TUvK6FD6jC9xGoRat+G0zY7f89SP++r9WUs/yf?=
 =?us-ascii?Q?dahPwdyh+7p7LVqNwmIOUNGm1P+BtEcDzw2VQwlm8LxEwRiTkR+ly3gcKEuj?=
 =?us-ascii?Q?6d1Ihqjnpqp93/4pRpG+Jb/qcxV1GBZ58naYZOAx2t7M+G2OEpOj13i/75k7?=
 =?us-ascii?Q?BVvqJrjz4zjqNv4xnpCKgLXEElARgkzSMuYeuCtmvZ9RjdTo0FIJtttq1KZ4?=
 =?us-ascii?Q?FhoAnkaEYO1HNLOJhOh8D2yirF/4xD+d9yWBsNk5gxVimoS7M2R1J4Z2DBP5?=
 =?us-ascii?Q?Pvws3IlYcECT3dRyBsfyF+fKW4U1B4Sb3eTOAcoxvoyoSMI7Ui/qS/YcKVKg?=
 =?us-ascii?Q?G/IFxpGSIPc4Fv846xV8BgYrULqZBVPozYq9Sxv7pBIlo8lnleb0Vh9U1/Cj?=
 =?us-ascii?Q?o/oew9Bln7q5EEsmckVDdgBzX7CMXMwiYctXTuDl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB7185.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 950cc40d-843b-4e18-469f-08de299437c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2025 06:56:09.9910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5vnJQjS5uEOIMQTsDUWBuktHTKwxXADi9tb/ulFm6hknfb5GJSgzxemgrxz3w5BMRtjmrrHnsK8Khs2GJCo7XklCoA5Y8HLAo46HK2Hoykg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8261
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AD4D9C0008
X-Stat-Signature: xkfabn6dw8r6kfuwcsjbd9aw671nygnz
X-Rspam-User: 
X-HE-Tag: 1763794575-843049
X-HE-Meta: U2FsdGVkX1/X5zv01nMlx9hrmJjBRzJsZF6J0fnu8XKCzg6EhyJZSvX+kAvMbVsfItVviyAnS8Mwh2zKWA2HDPqxi4SfP1RoyDPhgyealcMRyFVguPkT1hyh3fVgWH76H4HuhchAN+gZjvG4UFq+YsTMeSvRUdQGujS80pNqJBbVBHoFvB+mAebaOXzsM3FSRRG7hTdEP5NlmBVyAoABlbgx+piwnugow4eLKZVeCFa+2xl+cktNEhqFmreISTRgXxxW1zduxIZFnhY8wmeiOZa6RKZ1oZFC1LjwCq+fyGGzeLQE5xpDuoWUwD1iPMa1lwSnw4W6L8IaVhNf3Jebs1zxJGk3LS229kG5d/7p7OtxPgfdg6n+sSVSSCUZsA4+i8ySpm2Jjj9o7hZ7VUbH6aniVFvW+Y1cV/t0mge/xPv+GyW4EfzM5w3/qzRn9TZRpEXi5klcoTp1rFM/pTCuoL1dd7HVcFc9w5HlnoxEX5b9ewLieWNuER95fC26B2sL1Am4WpXhYvBQCvTY5aLWJO5IrHWQUdfDAEfp9gJJpMxEPwWwstJsEubLsAtKrdrUzeoL1XACTMkSII1dg5jxMc1uOIE3enAI5wIiJjIe/D40A2o2+cFTNfjjoLFVDCDroH79qtAtlC+V+8p/m2nPqotYJYakGor3vPxHuGQziQN+IhvPGtGCxdJ4qaEtH1F4FBrCFk9vmryqCbJ7EvdOcz6LKiivhmc3EdD6u2no3xOxd0Otawn6FzVviHTi8Y7qCZ+/fCwgX9Lzgm55bBJAd6g0yJIO0cx7kHLMlNCh1hHAzUGjMjNALXMsTRNcXkOFRsgxhwGTw0Ec5Iyy6db1wym7F1dS7AJyFHiwx3D3ZGt86DhSrCjawPhv+YqqBvhiqnoQ0+phj/WX3RFTIBLNaLP9l7f9jFm2XetUN6fUGMy9IarDfMWEHIW0fBNlACLMLbYvSkFOBE01hEkEk07
 tnVcbmp1
 A+7QAe1WrNCRPYigge8M/og522VIy8B2YgdfK61ZnWBkor/X1hEB9/7HEajushgoh6j05uypKOSdoyYF9BSfzH6xtUoIJBFPmmg4/KeyIDSF3gH07j3Y7dFplFKfjv1fkMLn1cSYDn7mWrio8dZMwzprNFfZ8YvXYjGJKt3xKjHLjB1+A+YSRT4pO/Tqkg8uMNaTFdSU2IX/HJvhcLqn3nfXU3pnUtYaDbNXXSZRmzs32V8WtnQzMez+hxftvzIknNDh9i75me7HaRJQVF4y1pirt/HXBzaOjCj8JK8/6to+eLoNnBaJxqfrhLoqyBZPOM/GTBXUbLSpSR7HObpekKcCTvjln4oVnHhRT5QejLUVC0lyPkjNHtgvQk7MN8sfpf54lKrZRhbC5/vdKTIhsQnrZZZ+SP/LkxY1hNd8HiZZWKmcsXZHqc0lS5bFYkbSwl9AmnSQuGEbI87JyKFWvjht+LLCEGiT9ezdrQHMrCSfbu6S3dA7idpbxdZeJC//IJkFNZ/XSAWySZv6F5UDt48wvbTAGcLrqLk7COTJniafjdWvk6LSMOSaf6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Subject: Re: [PATCH] mm/mremap: allow VMAs with
> VM_DONTEXPAND|VM_PFNMAP when creating new mapping
>=20
> * David Hildenbrand (Red Hat) <david@kernel.org> [251121 03:13]:
> > >
> > > Another way round here might be to try to use userland to figure out
> the file
> > > that a mapping belongs to via e.g. /proc/$pid/map_files, determine th=
e
> > > attributes from /proc/$pid/maps and then generate a new mmap() call
> with the
> > > same properties.
> >
> > Right, if we could find some way to just obtain the file/fd we could ju=
st
> > avoid mremap altogether.
> >
> > I recall that CRIU used something similar to obtain the fd of a
> > MAP_SHARED|MAP_ANON mapping (anon shmem) VMA, but my memory
> is a bit vague
> > on that one.
>=20
> There is an ioctl query method to get information on VMAs since 6.11.
>=20
> Check Documentation/filesystems/proc.rst for this:
>=20
> Starting with 6.11 kernel, /proc/PID/maps provides an alternative
> ioctl()-based API that gives ability to flexibly and efficiently query an=
d
> filter individual VMAs. This interface is binary and is meant for more
> efficient and easy programmatic use. `struct procmap_query`, defined in
> linux/fs.h UAPI header, serves as an input/output argument to the
> `PROCMAP_QUERY` ioctl() command. See comments in linus/fs.h UAPI
> header for
> details on query semantics, supported flags, data returned, and general A=
PI
> usage information.
>=20
>=20
> ... maybe that should be linux/fs.h and not linus/fs.h.  The actual file
> seems to be include/uapi/linux/fs.h (grepping for procmap_query).
>=20
> Maybe you could make use of that ioctl to get what you want?
>=20
> If not, maybe look at adding what you need there would be more of the
> change you want to make?
Thank you Liam, Lorenzo, David for your suggestions and comments.
We'll try other ways to address our use-case including exploring the
idea of obtaining the underlying fd via VFIO APIs or using
/proc/PID/maps.

Thanks,
Vivek

>=20
> Thanks,
> Liam

