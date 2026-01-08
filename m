Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BCC0D1488C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 02:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721CA6B0092; Wed,  7 Jan 2026 21:17:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0546B0093; Wed,  7 Jan 2026 21:17:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531A96B0095; Wed,  7 Jan 2026 21:17:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 416CE6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:17:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE4638BE3B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:17:39 +0000 (UTC)
X-FDA: 84307185438.11.3255047
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf27.hostedemail.com (Postfix) with ESMTP id A4F3240002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:17:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kqyt+G0w;
	spf=pass (imf27.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767838656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gATfLoUiax4O+89DN9gTOBSkh314LJQ5X6nxHPEJVWg=;
	b=8SztYNSilc1hftQTYu+X1WX2lE1IvxfOokt1pF72T4LuEjK02JdcDfLlYXZeK8cHjDJvoU
	Vbhi6GeMUS9sthBCNLVoOGjUbMOLwckT4sTcsekRiNRI5ydWuD6254UyqKpOJhVuWET9JR
	xjm2diT70t3pcU3RLLi/iRAHClKxSBE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kqyt+G0w;
	spf=pass (imf27.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767838656; a=rsa-sha256;
	cv=fail;
	b=L61/cW7qiSy3ceMItzvJsYSealRxtNXTduKDGis1HK5v3qK/iYXtZ1Hjqhs6d3nyM9WDZQ
	RsMpcWKQLlru38QaqVLhtbw7250Bi2pAqt9njq1AWNGzSDqc9RXHu0ZKi2281UUlQ9uFxB
	Y6oPo/n+5dp98+D2oEnBqTfrT6ONTFc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767838654; x=1799374654;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=LqvQCOuY9mceru2AUYgWWLiK3dIukbjl+k1gYqxgpqo=;
  b=kqyt+G0wz4/uqd7wvSPX6wQDaPou8y8dc97e0glkn/FH249e3rJarbrx
   1Qa+SpP4aNywTafZdYVSXrqzFMRsoIC7YPq60VCZHcOIdU/Uro19mA6w2
   rVP6gRc3cmJNgaKlrnYJsrVUe2Zs13od6MaPi3e4No0f8PVV5F81V9K1S
   S+hu2+ttALIrzczM5xwJZdGa+a+0S+ilK8Ozj0SKh5jJdbMMEwCk+4TZc
   QrwbFlSqOtIfaoTMLUMUMEGHZXPBfRINQxFYU9hlOKe3qxOdOys9v+0mA
   YsW8V2zWUs5ZZ7hOn3u8eFgaZqBOkcxI2AC05EU1VVm3WBuMgg4bgGMGv
   A==;
X-CSE-ConnectionGUID: ubxDtQcAQHeEYcKBP7VIwg==
X-CSE-MsgGUID: 1VNAsfS8T82t0h7X/wNVsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="94681401"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="94681401"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 18:17:32 -0800
X-CSE-ConnectionGUID: BsGDdUgtSmqGSgkRBAcPpQ==
X-CSE-MsgGUID: Zj98x+3qSjSMBg2ty2flBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202863495"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 18:17:34 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 18:17:33 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 18:17:33 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.48) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 18:17:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CH/ojXfA8yY/F5aK3TBJ2GAhtEL13s7cbTMh9dOcIGG6Mp7HjYqaFrH0/Phmd1e25n/FsYgHeSYOy+MYixm7WwG0UXGwYEZXwvQTgP8gHS2gUdf86Pk4WJgplQPOkm8CBYQosQHO6A5Yn8STrQCYx/rM961jvmYN8ZOXkCHK6E60CYDTR3ceTN8XFAkXTlzWveMjYxnOB4s2Mq4FgFhCAxIlYN6taHzseuXrl5mrNypFos0yET0W5cMKZisocxAqJyq7hojEPzgPcIgh6ZOV3hrQqhLzeD4wKoPK72F8c+Ng3p42bfQqcImJctx+tLlo8XeN/htlBatb04paRGPgtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gATfLoUiax4O+89DN9gTOBSkh314LJQ5X6nxHPEJVWg=;
 b=eiXld0zYqMaC1dLw8S7GHitKPeCdSpIo79Azcn113IZc5DPze3Vc9JVS5hA+mewIQFiEzK0J37hI1p4Jdc7WHk/TRDcxLe7SOV0MCnBDHiKakGkddMCAtdYejDBvcLr7s6t6DugBCVLe7R5I5hEcS/pMWODkOEroqMGvmXHQB63ofjg95VfayRMD3Rw2kWL7GFLVj4kTXLOF6IlF7/KLwimiVpVjzUJ1kYodzqWLBGq4ttq3DOci5yTj/yqhDmE2g/0IYo1XuFxwPcc4/MuM1hT0UnsMPHy+rDlroKLDUFBc9Nfe9fLrsFRnsIH7Q+DoPd7m+KaJBrUPzXXTvZtIhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 8 Jan
 2026 02:17:31 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Thu, 8 Jan 2026
 02:17:31 +0000
Date: Wed, 7 Jan 2026 18:17:28 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: Zi Yan <ziy@nvidia.com>, Alistair Popple <apopple@nvidia.com>, "Francois
 Dugast" <francois.dugast@intel.com>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, Andrew Morton <akpm@linux-foundation.org>,
	<linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Matthew Wilcox
	<willy@infradead.org>
Subject: Re: [PATCH 1/4] mm/migrate: Add migrate_device_split_page
Message-ID: <aV8TuK5255NXd2PS@lstrano-desk.jf.intel.com>
References: <20251216201206.1660899-1-francois.dugast@intel.com>
 <20251216201206.1660899-2-francois.dugast@intel.com>
 <F4EAA470-C922-4066-A115-13D6D055C73A@nvidia.com>
 <95BD5D5B-C8EB-4EFA-A895-CFD660504485@nvidia.com>
 <aV7NBE3NS1wdsXBo@lstrano-desk.jf.intel.com>
 <541B31AD-1472-4D32-A968-B92895CC6890@nvidia.com>
 <b39d13b2-cc10-4803-b6b8-0a0447aa3349@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b39d13b2-cc10-4803-b6b8-0a0447aa3349@nvidia.com>
X-ClientProxiedBy: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SJ2PR11MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: 768c6824-e02c-4ec4-845b-08de4e5c13f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?blNGVi9OUS9UbmhqUHQwZ1JaYUtvdDZQRkIwbVA1U05HSnVnejU2QmI4TlZl?=
 =?utf-8?B?ZjIzazdmWkxRbGxrREwvY25xZmY2TWdIL0kzRnBFcWswR2VCZUcwOEFjS24x?=
 =?utf-8?B?NTlzZTJ4Vys1TTYwdDBjNm5EeTE3MFBmUTR0bnB0bkx4UDU4bEQwU2VpZHJZ?=
 =?utf-8?B?T3BxaktFSWpreHFDUEszVUxHRlJZZEFuNE1JQXBnYWVXSUxBNENoanNPbjJv?=
 =?utf-8?B?dHhBdlc3RElINEcvdHNzUS9BSjFGMlZLTFJ3WGdsODVyNDF6Q2FwcnV4bVIv?=
 =?utf-8?B?M0l0YUNHNjNIcWNJR1hFSFBaSForMWdPZVRuRmxNZWZFcDZwamF5Q3diTVA4?=
 =?utf-8?B?aXZOWGx0a2JrWUZSZ0pEcWtzanJaQWQ3elVRNjY5dVgvbkR3WU5aYUEyK0tE?=
 =?utf-8?B?Y2JHRi9ubVdJdUpHdUtoc056dWVlUUM0bUFEQ2FvRlpiQllJdlUxamEwTjdj?=
 =?utf-8?B?MkZZSG5hZ3hSbVRBTDVyWWgxZFo0ek44d1B2Y0FvWGJEMHJGcVQxb1VCcTJI?=
 =?utf-8?B?WXMxdXQvcDZ4VU5wREg1NDFtY3VOS3ZYeERtVitIRnVPY2cvdFRmc3ZZTFZV?=
 =?utf-8?B?c0NoVEEwOWh4TUduN1FCMUZmVGNBZDcrYXlCRGpFemZ4NnFiQllTOExZdTFK?=
 =?utf-8?B?MlFGT1VRR1Q0OUUrdjRqeklvRDlHelE5N2JJbTE3UUh2Ly9KNHAreFNabGhI?=
 =?utf-8?B?cDRjTHZGK3ZZMWRZVHRyMXNMWlFXSXdtYWdmVGptU2xpb05SRnVlWlgxeUor?=
 =?utf-8?B?L2VDK2VKMXZtR0RJaG9Vbm1PVWRtSGJLWDRraGZ5UVRoc3FORENNUWQvakVZ?=
 =?utf-8?B?bkJnNHBwYXp1UVZieWlUeExXS1JLaVFHeHhJSW5UZ2tiSnN3N2FNOURRMU9J?=
 =?utf-8?B?QnU1a2I5bkp6YktMcmpKVkxtUTZNS2RJWTh1NkEybUthcnJOYXpxYWF6eXF6?=
 =?utf-8?B?WG5KVWxIZU5ESjNXM2JHbnM5b1NaZ1ZMeVZmLy9wNFVmQkZzV2RxL08xWkRs?=
 =?utf-8?B?TEVOUmZ6Zm80eXVicUROSE84SVgxRnpKc0I3a1BrSFJnSzNHL1Blb3ZSS2Jp?=
 =?utf-8?B?WGg0WDR6SzJlZitiMzM5RTlzcmlmMm15a0RxYnRBdVhlTXdpc2RyMXBzamJr?=
 =?utf-8?B?c3lxbGNpYytTclJsdGc2ZXZoN3VMWk9PVjF0bktYTnRpSEVhdy9KN2FxMXhY?=
 =?utf-8?B?dmRHV1JCTFcyZ2Nwelo2OHNDL3RKcjZwUElUL3grNXpYY2dzY3gzdTQxZmEr?=
 =?utf-8?B?VHdoaVhVUWplZ2hkVlFYZk5rVGZHUURVb28xWnB0U3UrTVRzdmZIMEVaakJW?=
 =?utf-8?B?KzlWT1lLRkp3YmZ2Zk5TY3RRTnBUeENZUktNUGl2cXlvQnliVUs4cmlDLzZI?=
 =?utf-8?B?eDB6RDhQc3RycTM0M2ZPVG1rSjJqVE0wZHcvQnVPV2g3T1lDNHJUM1ZpYkVo?=
 =?utf-8?B?U3JOdlE5dWZyM3FjcERvR1orbEZsT3F5L3N4YUx3QVJnelF6bmlPc1J1OXUw?=
 =?utf-8?B?OFlNcnNWZlN0NHRNdHhkYXBaWXdJdTVtbDY2M3dyVU1JUC9laEExNXVEeTNW?=
 =?utf-8?B?MEs4NFN6UUZYeWIyaHRWUFl1QVRROHdmWjkwR0hMV2JHOXgxK3RLZkhjVnpj?=
 =?utf-8?B?eUxtNnEvNEZNM29LUGRMRWZDeldnL0xvbUdPOS80L3lsK0xVbGs0WHNNOEVX?=
 =?utf-8?B?dkxCMWxQQSs1dzIwOW9RUG9sNlRraG9aSmZVN05kOEFHNWszOWRRQi9oMzhG?=
 =?utf-8?B?TTJRNlFQVWFXM040ZmF5cnBLZnkyWFBtSnMwRkpsWHk2NGVmUnpQaHR6aUgy?=
 =?utf-8?B?L2tvN0hFTXUrd1hYdDZjNVd5cXpTcnJCM2xyMWxhTkhRdnlUQnVkTURUcmho?=
 =?utf-8?B?djJzeFMvR1BOdDM0aUxjOVo4dzVvbWprcW9sVmx1TzV1SmdkNWZFWUI2OHR2?=
 =?utf-8?Q?3Neo3kgBjgL54lATU+TQVEKJC95xn9g5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGhhOGNvaGpHYmFLV1p3UGIrUGxkVGpvOEkydlBnNlRpU0hqR0JNV2dCWFRX?=
 =?utf-8?B?Nzl0aFhURE0vVFMrNS95a3RUUjFNcnZNNEllOWt5amZxaGVxYUFSMFlmQlhZ?=
 =?utf-8?B?UE1VVzlFV2sxK2Y5dC9yVDZrampRWXdWMzQ2VXZucEJBS3cyTDQ5ZksxUmd5?=
 =?utf-8?B?ZDNBTjBPSHo5eVhndHpYWmx5TzN6OG9lT3QrRHU0NlhFRHJ1cERhMG5UWnhB?=
 =?utf-8?B?OVR4dUJHUWpUY3F6bmZJeUN1cFkvTWZuVVdZdTlNN3ZydUJIK1ZHY01pYVpV?=
 =?utf-8?B?UWt2YzNlMXd0V2J3eFdSU3ZrLzRReHBYVFpRTmcxVjBhRjhOYytlSE9mR1Rx?=
 =?utf-8?B?K1VxVk1IeVRtVXBiRy9jOE15cFFhTnVhWDVKYm9wVG8wbTRxbVNGamRtQ3ZT?=
 =?utf-8?B?NEFQdFRtd084dWpIVmllcjdIeVNUUUJuaGJYemxRcXloY2R4Zk1zb3lGYW1M?=
 =?utf-8?B?N1hEZDNWWWFvYk9zdDk5WG40eDlleG4rMm9Nd2ZoMXpyTVo4c012UFRLUVhM?=
 =?utf-8?B?Rnd2WEVHVnFrTE1WZUtzOHNZTmV1WTRFRDRTUmgzZ3JRM1dBZlNhTEFOcWVm?=
 =?utf-8?B?cjVVSndTZ0FyanMwblhmM0tFM3BkeUlpUTd5Z0Qvd1c0SE9PRVJaUzQwUEQ2?=
 =?utf-8?B?M2NoQ28vWGxlTTlHcVU1NElHYm02djRDamRYZ0Q3ckppeUZCOHloRXZjV1Fl?=
 =?utf-8?B?OE9DUlBod1hFMlRXU3YvNmc0T2ZlRDhOTENwR1MxK0R5a1FvbDA3T3ZNNllZ?=
 =?utf-8?B?ajdIZGtzRWtIeDFFclU5QWp0bmxaeDdFdDY0RnI4YytJZ3dNb0VaMDREd3BR?=
 =?utf-8?B?M3NONEQ3NzcrR2F2SGRaVnVZMUhxaEFpRzRNYkpJWEpReC9IcUl1RHViMExG?=
 =?utf-8?B?TWZHK3RJU01OUFk0UkdwZXc0Nk5DRlNWa3JEbHQvSWxyVnFMVEhxM1cxcXly?=
 =?utf-8?B?aUxRNCtVVjg4Q1M5eDhaUEVwR2d2TkVCcDRTWUh2dndyVUxWd1hDZHJaU3Rn?=
 =?utf-8?B?VTlONTZ5YjhMcEpWcXk4V1V6Q3NmRnZ6cmxNeGVVeGk5QXdrbG80T3JVRmxG?=
 =?utf-8?B?TG9lVmk3SzA5SjczTi95emlOb1o3SHIrTzN2a0IwV0kxN2JHZVNsZmcyY2JO?=
 =?utf-8?B?WFlMQndzcFdUUUJMQ0xPT1VkNVRKTjcvcHNmOWRmN0VjdTZnSVkrVTloNzNK?=
 =?utf-8?B?N25zYSs5OGZCWFE0NEw2VjFNUHNONW50OGhId2tGcHdMS3dvbWg1NWFiOUhW?=
 =?utf-8?B?Ui9TUGhDcXNXZCtYQXd5ZUtqd0NIV3pHNStsSzhiejdveGxUTlplQXRFeEZQ?=
 =?utf-8?B?WnJJZWhnckZKSHJ4b09abm5LT3E1VjZ3bnBweGdTeGdvQkVmUGY0eHBtdU1B?=
 =?utf-8?B?a0Q3YVVPcXNjUGpyMkx3OFBVVitmSzlYWEVxRkFlWnBLU0JtRityZWJKMStP?=
 =?utf-8?B?d2Q4SzlTbFh3MUNUcXB4eDZ0cWNITHRjZHBKYUhDbU4xdkhFblFFV2MwdkFm?=
 =?utf-8?B?NnhpUURZOUo4U1hyd1d1OGc1Z3pYSDRsUkhoZVBGeDdTa0UySTZGSytyaVNE?=
 =?utf-8?B?MWdyUU4zOFRRcGdaNTVwWFNuaFJBN3NjUkdrUENrSFBRVUlpdWtGNHF3VDJ3?=
 =?utf-8?B?SU5JR2xPRG1CbXRvajBZNkxleU9nQitlV3o4V0V2OGRQN3RpQUY2Vk9iR0Zi?=
 =?utf-8?B?STdGbWdSdXJldENLWDFyS3FtV09Ia21JeGtVM0pKN2szVFl2RGppTmlBZFF5?=
 =?utf-8?B?akxyYXE4UDVtRXV0SmRVZGNDZDVYUEREU0w2bG5GYXhaY2RDaUpZQy9FOEdT?=
 =?utf-8?B?M0phTjcyTFEvcWQyN1pMYVN2MzFiSnl0TVZERDgwU3VxSHl0dFJ6WC9QUTQz?=
 =?utf-8?B?bkJiQUtqU0dNekF2TFROa0pUd2pLT21nTzlYcHNoNmtjM0VGd0o2M3B5cW1q?=
 =?utf-8?B?Y21EKzArTmFPYUtkUElDUEdJWTZUWDZ1TER0bTBFSFRHc21xaytBZEg1MkJC?=
 =?utf-8?B?NExQZHVCV0VTTVJtUGNMSnpER251RzEzYitJOUxsUHI5UEFLQ0IzT1pXUVQv?=
 =?utf-8?B?OEtQdjd4N2ExK3J1ckxUYmt3UEwyeDBENmVidXl0c2VaUWJLcTlsK2FRVXNB?=
 =?utf-8?B?dTMzTzFNQmFIbDQwMGNMbWVoYU1DT2Q2SC85cjI2YTB1dVFmUnk3bHBaN2dN?=
 =?utf-8?B?aDVoOFlKN2hpQTF5UEl5TXl1MWRTVkhQNkRYdTk4bXBKcFloSnQvbU1IWWFV?=
 =?utf-8?B?Y3ZYS0dDd05tL1lFR0VrekNWSTV2VXBsYmxXdDkwOURJMGFDMTArcXhraktI?=
 =?utf-8?B?cSthbGZIa0x6a1NLSVZpSWh1SFU3L2x5OThwUkhiN1hTNmFqWDhzeFhyVmsz?=
 =?utf-8?Q?OH+ajKsuLEr49SPc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 768c6824-e02c-4ec4-845b-08de4e5c13f7
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 02:17:31.3328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ByL/QBBdV3EPmFNAbXlxhZXRBwaOMzQshD9Q2K/ZqgtvP/2pEX8NnBGCG+Y9eBtHbEQIVddZFUNVSvH+G08Vzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7546
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4F3240002
X-Stat-Signature: m5sd4awbymgp3zq6kyp1mecq41tb9a5z
X-HE-Tag: 1767838655-786760
X-HE-Meta: U2FsdGVkX1+y5Ij3BW5faWkyViWeSF+A2x6DIzyz7iVV6i31EswNpoHAf20mwhPTQ3/Do95729N5VCniYzCUJr0hv7t0TgGg+ojKpMgDWwV3Xxk8FW06yS9LTaoVtmOyKUfVYcyjKNgxHkaGU3426DoNNq1kaBQgP67S+2DIBmsI5nGEnmzxUGTWR/YY7hU/Z2kj9ZEN9lUm8ceZczKfqYrR4m50pAD3cszh1FllRq5yh3CPXQJ7zKvY5Z8JD8hVrM6YouYRjaBDZ4j5YAZgZplU/Ljrq/8Qedl/23JbgBO8fdnNZ1NE9Vvue2bQuBiw+8GyDYsvAE31fXv3aFyJV6Ls7j54Phgky6Nt81r+cY/SkmDZRG3fa/3cSpYaW72l5jQFP1w2ea6K5CVNSkalisX3J9rYKAqD3mjV+MgL7nDXZkLcuQYkoJBw1k/3XlT+OGwIme+0luXSEdTi4w+darQ4nGxXf2elmiAjzFjT990lgHn2xt5kS7QmfUYBtr9Gsa3FTMKL5Kg/YKFC6dco8jCbcylKEgAnTRHh0+dzo/SwJC92rUVDQDdmNepnkHhcP/wv6sRm4zWDafsop+Z+goLszrTO0Uo00L1O9lvlMP2zQWOHYYZJFgZfEoY4fllBbdzEOBQ3mYhqPMKWtYKxirPHqHDh7FGjCwhfPB9UDSL/bzTaaCBOAZgvBhtk4Y83Vvw/MQ0EhgwXfmqLfvy8PKcKGKjb/SOyfTRnqxbLh5JsOnFbwXl9149OYj4Pu7tERmGthXOCtuUlKS79tod4kUnLLOrj4pR6fohcKeeq8AHgiVS3v9EeVHkqBhmU0u9/Sy2oeTCoZTmQheXPQAlyl0Pvz7CPVlStfMWyrwuwPajdtDMfVv0/GWJ+t5wnrvuH2GbLxESNJspQsqSJVl71N1/eR1QJ6FoBvefz7SIse8m6rlMqIu+4QjnVkp6E/5E3QRMcVx2343Mql7O0R6M
 HU13t9jC
 mFyOze7Gk7z79Mf/jGgJCB7mVckV0bEN5gkr82FgYbXCcTvFqnRfLIvps+f8BJSScY5UM8R3sFL4bHwo1vtauTCZI9kiPXfi1T5J+S0DZGbMMbPTTuPkCEime/IBHtHTvMpe2MNO5jWVX7LiT9+yZ7o5OFSj2kUkBUrsNXGe2f4TdvkUb2af26UDivurCppLKW2scK6+EhfDYZazsTO7mukRbRTDUfdfkmEyEJvdSnGFEhe8/a+DIcLY6IktDJYRUxDBCY73YvkvTLKeUsQM0ikvkrBYlRP6iGFu6F4su5N14mDsiWSAlHsBMo/f1k/r7ewX8Crb3jnhAQ5+OxgKGgqSEyXpx0Iz91eHb4svfF4W6Zo/QcqH+RSJRlVU0rrENwwsS0uewntHHUO50uhAShMjuB1HdQU+jAShqPAABKHXzkDiHvzRtc3c7HzkXSCMHGve6o2S0etvwkHyQxzXaG1zub3RKrixD+HbSZwBn5ASHrQtp0YkfukPyzFJaxIsW2jUTYJOGBoAcDaoivlGf+bN7tTqYhl5XjdwOMnv/3CdE1p5XW+q4oPZSbEgubxT1OJXoanndCH/45Ngt1OgaOxZuF2RHP3xgSpD00XGFz/0tO6gSDJ3tMZ5o5DQ6rnGJ8IySgAxqRDzlubBZ0d4pQu2sWpFKLAW0MG69wFZ2PHAqe4Y3pj1YRLBOfJutaONWPB1DtYgaflElqAVGMWBuB4QkiUGP7JeFH8Ln3+tXclBcAqQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 11:56:03AM +1100, Balbir Singh wrote:
> On 1/8/26 08:03, Zi Yan wrote:
> > On 7 Jan 2026, at 16:15, Matthew Brost wrote:
> > 
> >> On Wed, Jan 07, 2026 at 03:38:35PM -0500, Zi Yan wrote:
> >>> On 7 Jan 2026, at 15:20, Zi Yan wrote:
> >>>
> >>>> +THP folks
> >>>
> >>> +willy, since he commented in another thread.
> >>>
> >>>>
> >>>> On 16 Dec 2025, at 15:10, Francois Dugast wrote:
> >>>>
> >>>>> From: Matthew Brost <matthew.brost@intel.com>
> >>>>>
> >>>>> Introduce migrate_device_split_page() to split a device page into
> >>>>> lower-order pages. Used when a folio allocated as higher-order is freed
> >>>>> and later reallocated at a smaller order by the driver memory manager.
> >>>>>
> >>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>>>> Cc: Balbir Singh <balbirs@nvidia.com>
> >>>>> Cc: dri-devel@lists.freedesktop.org
> >>>>> Cc: linux-mm@kvack.org
> >>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> >>>>> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> >>>>> ---
> >>>>>  include/linux/huge_mm.h |  3 +++
> >>>>>  include/linux/migrate.h |  1 +
> >>>>>  mm/huge_memory.c        |  6 ++---
> >>>>>  mm/migrate_device.c     | 49 +++++++++++++++++++++++++++++++++++++++++
> >>>>>  4 files changed, 56 insertions(+), 3 deletions(-)
> >>>>>
> >>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> >>>>> index a4d9f964dfde..6ad8f359bc0d 100644
> >>>>> --- a/include/linux/huge_mm.h
> >>>>> +++ b/include/linux/huge_mm.h
> >>>>> @@ -374,6 +374,9 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
> >>>>>  int folio_split_unmapped(struct folio *folio, unsigned int new_order);
> >>>>>  unsigned int min_order_for_split(struct folio *folio);
> >>>>>  int split_folio_to_list(struct folio *folio, struct list_head *list);
> >>>>> +int __split_unmapped_folio(struct folio *folio, int new_order,
> >>>>> +			   struct page *split_at, struct xa_state *xas,
> >>>>> +			   struct address_space *mapping, enum split_type split_type);
> >>>>>  int folio_check_splittable(struct folio *folio, unsigned int new_order,
> >>>>>  			   enum split_type split_type);
> >>>>>  int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
> >>>>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> >>>>> index 26ca00c325d9..ec65e4fd5f88 100644
> >>>>> --- a/include/linux/migrate.h
> >>>>> +++ b/include/linux/migrate.h
> >>>>> @@ -192,6 +192,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
> >>>>>  			unsigned long npages);
> >>>>>  void migrate_device_finalize(unsigned long *src_pfns,
> >>>>>  			unsigned long *dst_pfns, unsigned long npages);
> >>>>> +int migrate_device_split_page(struct page *page);
> >>>>>
> >>>>>  #endif /* CONFIG_MIGRATION */
> >>>>>
> >>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >>>>> index 40cf59301c21..7ded35a3ecec 100644
> >>>>> --- a/mm/huge_memory.c
> >>>>> +++ b/mm/huge_memory.c
> >>>>> @@ -3621,9 +3621,9 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
> >>>>>   * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
> >>>>>   * split but not to @new_order, the caller needs to check)
> >>>>>   */
> >>>>> -static int __split_unmapped_folio(struct folio *folio, int new_order,
> >>>>> -		struct page *split_at, struct xa_state *xas,
> >>>>> -		struct address_space *mapping, enum split_type split_type)
> >>>>> +int __split_unmapped_folio(struct folio *folio, int new_order,
> >>>>> +			   struct page *split_at, struct xa_state *xas,
> >>>>> +			   struct address_space *mapping, enum split_type split_type)
> >>>>>  {
> >>>>>  	const bool is_anon = folio_test_anon(folio);
> >>>>>  	int old_order = folio_order(folio);
> >>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> >>>>> index 23379663b1e1..eb0f0e938947 100644
> >>>>> --- a/mm/migrate_device.c
> >>>>> +++ b/mm/migrate_device.c
> >>>>> @@ -775,6 +775,49 @@ int migrate_vma_setup(struct migrate_vma *args)
> >>>>>  EXPORT_SYMBOL(migrate_vma_setup);
> >>>>>
> >>>>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
> >>>>> +/**
> >>>>> + * migrate_device_split_page() - Split device page
> >>>>> + * @page: Device page to split
> >>>>> + *
> >>>>> + * Splits a device page into smaller pages. Typically called when reallocating a
> >>>>> + * folio to a smaller size. Inherently racy—only safe if the caller ensures
> >>>>> + * mutual exclusion within the page's folio (i.e., no other threads are using
> >>>>> + * pages within the folio). Expected to be called a free device page and
> >>>>> + * restores all split out pages to a free state.
> >>>>> + */
> >>>
> >>> Do you mind explaining why __split_unmapped_folio() is needed for a free device
> >>> page? A free page is not supposed to be a large folio, at least from a core
> >>> MM point of view. __split_unmapped_folio() is intended to work on large folios
> >>> (or compound pages), even if the input folio has refcount == 0 (because it is
> >>> frozen).
> >>>
> >>
> >> Well, then maybe this is a bug in core MM where the freed page is still
> >> a THP. Let me explain the scenario and why this is needed from my POV.
> >>
> >> Our VRAM allocator in Xe (and several other DRM drivers) is DRM buddy.
> >> This is a shared pool between traditional DRM GEMs (buffer objects) and
> >> SVM allocations (pages). It doesn’t have any view of the page backing—it
> >> basically just hands back a pointer to VRAM space that we allocate from.
> >> From that, if it’s an SVM allocation, we can derive the device pages.
> >>
> >> What I see happening is: a 2M buddy allocation occurs, we make the
> >> backing device pages a large folio, and sometime later the folio
> >> refcount goes to zero and we free the buddy allocation. Later, the buddy
> >> allocation is reused for a smaller allocation (e.g., 4K or 64K), but the
> >> backing pages are still a large folio. Here is where we need to split
> > 
> > I agree with you that it might be a bug in free_zone_device_folio() based
> > on my understanding. Since zone_device_page_init() calls prep_compound_page()
> > for >0 orders, but free_zone_device_folio() never reverse the process.
> > 
> > Balbir and Alistair might be able to help here.
> 
> I agree it's an API limitation
> 
> > 
> > I cherry picked the code from __free_frozen_pages() to reverse the process.
> > Can you give it a try to see if it solve the above issue? Thanks.
> > 
> > From 3aa03baa39b7e62ea079e826de6ed5aab3061e46 Mon Sep 17 00:00:00 2001
> > From: Zi Yan <ziy@nvidia.com>
> > Date: Wed, 7 Jan 2026 16:49:52 -0500
> > Subject: [PATCH] mm/memremap: free device private folio fix
> > Content-Type: text/plain; charset="utf-8"
> > 
> > Signed-off-by: Zi Yan <ziy@nvidia.com>
> > ---
> >  mm/memremap.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/mm/memremap.c b/mm/memremap.c
> > index 63c6ab4fdf08..483666ff7271 100644
> > --- a/mm/memremap.c
> > +++ b/mm/memremap.c
> > @@ -475,6 +475,21 @@ void free_zone_device_folio(struct folio *folio)
> >  		pgmap->ops->folio_free(folio);
> >  		break;
> >  	}
> > +
> > +	if (nr > 1) {
> > +		struct page *head = folio_page(folio, 0);
> > +
> > +		head[1].flags.f &= ~PAGE_FLAGS_SECOND;
> > +#ifdef NR_PAGES_IN_LARGE_FOLIO
> > +		folio->_nr_pages = 0;
> > +#endif
> > +		for (i = 1; i < nr; i++) {
> > +			(head + i)->mapping = NULL;
> > +			clear_compound_head(head + i);
> 
> I see that your skipping the checks in free_page_tail_prepare()? IIUC, we should be able
> to invoke it even for zone device private pages
> 
> > +		}
> > +		folio->mapping = NULL;
> 
> This is already done in free_zone_device_folio()
> 
> > +		head->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> 
> I don't think this is required for zone device private folios, but I suppose it
> keeps the code generic
> 

Well, the above code doesn’t work, but I think it’s the right idea.
clear_compound_head aliases to pgmap, which we don’t want to be NULL. I
believe the individual pages likely need their flags cleared (?), and
this step must be done before calling folio_free and include a barrier,
as the page can be immediately reallocated.

So here’s what I came up with, and it seems to work (for Xe, GPU SVM):

 mm/memremap.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/memremap.c b/mm/memremap.c
index 63c6ab4fdf08..ac20abb6a441 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -448,6 +448,27 @@ void free_zone_device_folio(struct folio *folio)
            pgmap->type != MEMORY_DEVICE_GENERIC)
                folio->mapping = NULL;

+       if (nr > 1) {
+               struct page *head = folio_page(folio, 0);
+
+               head[1].flags.f &= ~PAGE_FLAGS_SECOND;
+#ifdef NR_PAGES_IN_LARGE_FOLIO
+               folio->_nr_pages = 0;
+#endif
+               for (i = 1; i < nr; i++) {
+                       struct folio *new_folio = (struct folio *)(head + i);
+
+                       (head + i)->mapping = NULL;
+                       (head + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+
+                       /* Overwrite compound_head with pgmap */
+                       new_folio->pgmap = pgmap;
+               }
+
+               head->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+               smp_wmb();	/* Changes but be visable before freeing folio */
+       }
+
        switch (pgmap->type) {
        case MEMORY_DEVICE_PRIVATE:
        case MEMORY_DEVICE_COHERENT:

> > +	}
> >  }
> > 
> >  void zone_device_page_init(struct page *page, unsigned int order)
> 
> 
> Otherwise, it seems like the right way to solve the issue.
> 

My question is: why isn’t Nouveau hitting this issue, or your Nvidia
out-of-tree driver (lack of testing, Xe's test suite coverage is quite
good at finding corners).

Also, will this change in behavior break either ofthose drivers?

Matt

> Balbir

