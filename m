Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C02DD3CC84
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 23:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7EE6B009E; Wed, 14 Jan 2026 18:51:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5AF6B009F; Wed, 14 Jan 2026 18:51:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5915C6B00A0; Wed, 14 Jan 2026 18:51:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44E4B6B009E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:51:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11B131A012B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:35 +0000 (UTC)
X-FDA: 84332218950.28.168C19D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 045E31C0007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:51:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UqeCbIVG;
	spf=pass (imf21.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768434691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7n0GD4vskBV4uZ5XKLmIpS8Wy9noTZ87ZQvr4tng9Y=;
	b=LsZrs0xYtzH7SN3Ag020ZRgfr/lYdzUbzCdqRMHGYh3CvmlgYl9+dAx1kOSlmsqhz2Uzmw
	LmZu2jJ6MTBpcflqmHVmB3wnTdnWGm3zts2m7n4R59sp0psvbKoP0I/He+nIOFaqu1YlVT
	2/XzgUne2Wwg37bAv01ElXmcW9V206o=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UqeCbIVG;
	spf=pass (imf21.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768434691; a=rsa-sha256;
	cv=fail;
	b=JH6kucGiTDftnXHRysXoG192gt3u4Cfyy4aBPVI8iODUl/beEC5g+ag0fqP3+7MzLOcXGZ
	k9kVrRDyKO9KxON1mFc4LqQ9Qv9xcnadsTewFIVU0iNHGOXKK+33UqhRVI7OlUtlZS1Kob
	rpGB1c0HniJPuvIE+p46kd4nK4PRwnc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768434691; x=1799970691;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=RSHtL2IVsWfSWQz/HURV6vT7mdg6jKwj7p+aZQCh38g=;
  b=UqeCbIVGlfUHxPAp2X8QNOSfV9L0bdKebZSBcVczfdKp2PfWJHlgQTtR
   7x6/8K4PipqKAYH8/5EIwmFeLyfkMJaSi/Ag4g8wR6g284v0gcm3VpwaV
   qRd1SwVME2UFcgtQMR/CBgmPerysk25hNmHCCzRfPCZKxtZPRbz+AWG2v
   vH9ZFfFyCA4SBIuDwdW5XeogQz9galnBfMpzeLSM0ONNDMo8KJUz7eaMw
   QONqAwClo8Z5lb3o1/s9GLcD7TR0AlGcroyMPDjIpwqSZ3UULCNNhhlFw
   HKXY4NPMdd1pUUEv3knqOmybXF18zgutOw/SEF5bRq+t+c1/THez35Gtb
   w==;
X-CSE-ConnectionGUID: kqej+JjITpSGqwmT5tpj/Q==
X-CSE-MsgGUID: 1o58XeBTTBCpRuwBRzasMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="68950613"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="68950613"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 15:51:29 -0800
X-CSE-ConnectionGUID: T5JgkYtuQjmoqBByqnj6+g==
X-CSE-MsgGUID: t9JFJ52qTjuFuGl8wCa5iQ==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 15:51:28 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 15:51:27 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 15:51:27 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.61) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 15:51:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fa1U7u1NYksEim8Cus9r+dGM7rl2YE6ZOtdXpjamA6Wkh/5LfChYImVYSOFY3UVVPltZiB57glKAOqY9NPwf/+ad3XrAwQ0YgbF3wtH7YqPRmSsTOdBKVoBQK8plFleTdUBbgQrwlxuP72zCt8+11+qH9zJSveVaFR1Fi2tyTrxk6NJ/YhX0kbcoSUMeTtaFH4bi/z9HzisnIk46h0BFzZ4WPeBa5FrKWJRLwBf453v9NB5IcpYnyB205KX6jU6bfIQ8RklcujDdE/1+bKOE1VOTv3KDJkJwlAP4ydbL54EBox+oDWBLhIDOFe5aFRohbKrGJ9RCEwoX+2z5v+DJtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7n0GD4vskBV4uZ5XKLmIpS8Wy9noTZ87ZQvr4tng9Y=;
 b=cH99+FZMMUO3zu3Z6TIV1I7Cx1WSWoDOEH1cNC2ddTqJLxAZ0WTrceLSc8ldm50jMpkqacOpttxFueT+dCXKt80x4zSmjDXKMWwsCogJUIE5T8/dnEeLXAq3k2fu/vZ3WuD6a9nZtWzHb2hyZb3wTdpmkKgUD3azGH1aa+GK/aYSaAdDzI213ERPPA7fuf2mJ/nuau0e9dpeuw0sYzCiEab9Xu/xEco4sky4cWjosx2fgZYpOVY3SV7ePKvmZF3B8aZHDv3tOI9S1B3py1hzsCQJWXQ6FohVSJ1YU3Wei/jY8Wx/lhyi/MvlnLtnoBPrLprdSrXHHvQQZXB5zlMuCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA2PR11MB4796.namprd11.prod.outlook.com (2603:10b6:806:117::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Wed, 14 Jan
 2026 23:51:19 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Wed, 14 Jan 2026
 23:51:19 +0000
Date: Wed, 14 Jan 2026 15:51:16 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Francois Dugast <francois.dugast@intel.com>,
	<intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, Zi Yan
	<ziy@nvidia.com>, Alistair Popple <apopple@nvidia.com>, adhavan Srinivasan
	<maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman
	<mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>, Alex Deucher
	<alexander.deucher@amd.com>, Christian =?iso-8859-1?Q?K=F6nig?=
	<christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Balbir
 Singh" <balbirs@nvidia.com>, <linuxppc-dev@lists.ozlabs.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <nouveau@lists.freedesktop.org>,
	<linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v5 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-ID: <aWgr9Fp+0AeTu4zL@lstrano-desk.jf.intel.com>
References: <20260114192111.1267147-1-francois.dugast@intel.com>
 <20260114192111.1267147-2-francois.dugast@intel.com>
 <20260114134825.8bf1cb3e897c8e41c73dc8ae@linux-foundation.org>
 <aWgn/THidvOQf9n2@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aWgn/THidvOQf9n2@lstrano-desk.jf.intel.com>
X-ClientProxiedBy: BY3PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::12) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA2PR11MB4796:EE_
X-MS-Office365-Filtering-Correlation-Id: 82b5003e-13df-436e-8938-08de53c7d069
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QmlEWVc2M25wbGhwZFU4U3kzYW9Bc3gwZGhhRVdWSEhVVWcwN3c2R0Z6MlFi?=
 =?utf-8?B?NTh2dkFnT0s3b0JXWm43S3FsVFZQYS8zN1k2TC9Ndng0a0t1OTUrUnVmUGJQ?=
 =?utf-8?B?b1hBeGtVcUF1S2hXeEpRVkJHYk1ZdWtMWTkxWWZiM1J2NytudWFSQW5CY1E0?=
 =?utf-8?B?bFQ1UmVheHVoUXJTcFhvYWk1UnJqdTEyZzdrSGRhc2Y0QzZpcXVESHlvbVgz?=
 =?utf-8?B?Y0NETnNxdFk0Vzg4NXBFMEcreHBpV3NodXhMSXg3SEpLS3EzY01Edi9OZFE0?=
 =?utf-8?B?eVNiTTRnR3hTZUhzTk01YVF6QWtOdmQxNUVBazNtT2h6SzVScEJDVmJYOEZw?=
 =?utf-8?B?c2pvTmg2Uk1mT1ppS1dWS2RlZUJPVSszdENPeE5ZSThuWFRXYmNOODdBN1V1?=
 =?utf-8?B?dmt2aldTTDdSdXdvcTI1YVVlZDZSZGhUSHlhYXkyU2U1dkszM1RsenA0K2Zx?=
 =?utf-8?B?ZlBuODN3QVlxeDFDNC9oRk5pNmNiMnZ2Ykh6RGhsQVM0VnRrOXI4eFllb2Rj?=
 =?utf-8?B?OVlHL21kMEVjR3FtaW5Lc0xFNUE2cnFvVkY0bkFxcGhLUHhXOUl5MisySmdk?=
 =?utf-8?B?TEpQVVdjVGlPMHZjdUd0NU84MUJJZzI0MUdjcHlsSVMxWWE2b0Z3a2xoWUhj?=
 =?utf-8?B?QVUvbEtCR1hsTXBoODZSeFRKVjd0MndHbmhKR3Ywdzg0dlJBRjlQOUl6YWtE?=
 =?utf-8?B?eUI0ZzJqajd6NDhHMWhFUkRmc3RTcGgxcTZMWFRZRURtODhqUjFuSnhTMWFT?=
 =?utf-8?B?UzQ1STluWFpXOGZBWFdWZGIwdzJ1QzY0Sms5NlIrMmxnWUtRRCt3SDlqRUhR?=
 =?utf-8?B?bis1MExWOFBKV0tNRWtvcjROcXhKT1JjWk5OWjQwR2NublRCRWFqWWhCbkhG?=
 =?utf-8?B?c1RHN1Q0ZXNTNUc4N1Yxd2hkN09rS1I0dkoyc0drTWdobnp6b1FJODZhUTND?=
 =?utf-8?B?NUtvZVJleUxWa2F4WUJJcVhVZmxVR2VBdDJVWE1nZFJpa3NrUWpUZ3g0Tmx2?=
 =?utf-8?B?RlRBNlpidnM5K2dROHgxS3hJalFSa3ZLWGtCUzhpbEoyMEFITk5XTG5YUWQr?=
 =?utf-8?B?bC9DVmIvbXFyZW9XNDJmWmQxZDdJZ1gxMnlobXFXTnR2eEZWK0ZRMFNlRkJI?=
 =?utf-8?B?MHFTa09BU0p2bHpkWkMvQkcxTWtwSkdlU1NaLzZteGlIT2JXdTZrM1dDaFNk?=
 =?utf-8?B?Z0dPL2VFUWREa2tMK2JtblMzWEVOZlNQeUpyYjZIRktNcjN3N0d5VGtwRzFB?=
 =?utf-8?B?eEp1R2tGbWVNSE1JY1phRzd0VkJkclVWSHZBNFNLOEhPRSt1UythWDZMVXl3?=
 =?utf-8?B?TVk0VU92a2ZzWWQxdUZwVm5sc0paTFZqK0p2OWY1Tk45dDZLZUdUTHI3cTVW?=
 =?utf-8?B?eEViRjllajdib0x1RzI4bHFCaU1BVXpwb3Uvd2QvOGUyYUZzalQzaDdGMzg4?=
 =?utf-8?B?ZC9EWEJIRzRsN21ZSmhGeTliSXFyYlJ6TVFWeEVzTnM0L2h2L1A1ZEhmbUJ1?=
 =?utf-8?B?ODNtbFFRWExIblMyUmhzQWE0TE12d2x6eVJsMjdCU2NKUjQvMlA4SkM3OURP?=
 =?utf-8?B?ejh1MWhmRmZZZGVMemM5SmlRZW05cjRBTitoZUo0YmoweTFLc1R5eVBBaTI0?=
 =?utf-8?B?bFZvb09uTXJsUnh0azl2NG81OUpQbUtnQ3Nrbi8yRkpIL3pRRW5nNmhWZEFW?=
 =?utf-8?B?cGpUZmthR2p5UVIycFgwbHpmZmU5clp5Q1FMNjgvZlJ4UmQ3VmplVW9Pd1pm?=
 =?utf-8?B?VHJiQSt5WVIxQkJsMW5hNmRGT1kybFFzRnAxR1RROUxwcWpDVnQvMFkwTnhQ?=
 =?utf-8?B?NU50WFlEUWhnelB1N01xUVdrVGRkeUNtMm1XL1dnRXNEdHBQdWJ4MzQ0SWFL?=
 =?utf-8?B?Tk5yY0JCRFdKNkk2UXl1TStIOUR6M1lYMjFpUVE5UllJblIybkdLTmhYTm45?=
 =?utf-8?B?SEpybG1md2VqVTZCYnk5YWJNRkU4bHhzWHg5ZXJxaHR6bkFYT05mQWtKS3g2?=
 =?utf-8?B?ZjFrV0w3cWxyY0RNRDd1eEx5VHdTakQ2TmZkc0ZOc0pYWENtVHgwd1YwT3Zl?=
 =?utf-8?B?cUJlMVRuV08xRHEvNVBicXBIVEV5bFEzWTRzMThKeXhSNlV3Ti82c1lJOS9T?=
 =?utf-8?Q?q6Z8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUFIOUdDYW9QdWpMOUxaZHNBajlUK01FajR5cXNmYWdSTHlVWXM1bDBJZEVs?=
 =?utf-8?B?WWQ3ZTBocnZMU014K2xpejE4ckgveW5UdmVxVi9oS1A2c3VOVHNubUxLZTJ0?=
 =?utf-8?B?ZFJzaWRzWkZ4M2tLMnhRWmJIYzR1SzVqOEVISzVpOVVKNmovek11eEE2dEs5?=
 =?utf-8?B?MDIwaU44N3EwZE9DUE52a21rbnBxdFNHMGl0ZkRLRlp2c1FTdnpGejZ6U0ZT?=
 =?utf-8?B?QlY4YmQ2MWkwamdTRmtmVkEyUW9jNVpUejF3T0lwNVllZWtVR0RleWVJdWJy?=
 =?utf-8?B?dnczUGZXWVVzNFlvL21uSEhnVHZiOGVHN2VKNTRwcDFxV3laNGlMM3hLV0xN?=
 =?utf-8?B?cUtLUEtiSk9QT2llK1RxRWhtWkF3anZWakhZUWtERW5pYUFhOGE2VTZZV01H?=
 =?utf-8?B?MGl5bTlSbHp6TzduNWt5TkV5S01WamJUVWZwMTlEb2Q3N3lmdWVvVndra2pK?=
 =?utf-8?B?b2pqZERVVjR4QkM2TEtsRjZoN2RoSDd4RGp3SzMxRDdBRFFmc2pNeDlYelRt?=
 =?utf-8?B?YVJ4NXRnUWVxL1BiTjdGM3lIQkRRWDQ0SnVGR01xNWl2amZUZE55eDRtU3I1?=
 =?utf-8?B?M1ZzK1dvYzNEUlI4SUQ0RFFvU3Z0TXVRVkRwUUJvaXVVbjZybndLeVhuUVJv?=
 =?utf-8?B?RlE1K21OWDVhU0I2TDJCNXBqaUQzeU0rNjRsdlNsQjl1OUJSTXFKN0xVa3Nr?=
 =?utf-8?B?dUw5SWhlNkpLazh3Z2V3dlBHSDJPUzQyQTJsV1hsSWJjUEZDZHFSa1ovMEEw?=
 =?utf-8?B?YTYzRE53QlVzR0dZd2FrQnpQUmVhTUhQa0p4cTBldW5lZCtsd3RoWStxbGdm?=
 =?utf-8?B?UFhQN0NGeE5xUVRCUk5xcEFNTnZxRHBtY3o0Q0gzczczc3pJVkt6MkUxTFRL?=
 =?utf-8?B?QVgxaEJ4ancwRGJqM2dIUTd1NmplNktUUDhLeWs4Z3RqYVRjMnphQmlMSllX?=
 =?utf-8?B?UVB0bi95V2p1V2I0cHJOYXdFYzRudXFvQ3dKODkzMjJveDg4V01EdUhqRTVC?=
 =?utf-8?B?M1ZtcmFmQWM5ai9EVnRZd2o0MG0xb0crUlZLT2ZmQ3FWT1J5bllPZlhRbzVC?=
 =?utf-8?B?cGVSS05henQwVGdXS2REb2FVTm9UcGlKVXBTR1NYQmtpOWZBcGhUQ1JYcmNz?=
 =?utf-8?B?ZlVBRU1yL1JBSHZ1UitUQU5RaWdRcmk0YXNUcFV5SG01SzlJa2Z5NlF3aWJJ?=
 =?utf-8?B?MlQ4ZW9YaEZkYkpQWkVmUGR3ZjFaa3ptTG0rVmF5QkZLMkZyRWlBRnd3TGdx?=
 =?utf-8?B?VUphWlk3TElteTl0K2ZLbGY5VUJwMTBOZEg3Q0hoQmRIbm5mdlprcUVCUE9F?=
 =?utf-8?B?c29hSk9nZUlLcis0OFF6dUVPMjV5WDJFcjhNWWxPMUJiN1Q2V0FLSmNoaUl6?=
 =?utf-8?B?OTFBUm9RcWlwUW5EMFZ6VmhNT0ppUEFEWUYySTM2Q2cweEQvM25uSXZTeDJp?=
 =?utf-8?B?QmJYbEkzekova01pOG11Q1VXL1liWXZVNXcvRzA3UWVvU0ZwMFVES0xzYW5X?=
 =?utf-8?B?QVZpMUc2RzZIYkxveHRxaUZveUFYalFUc0lpMkt6TGR1WjNrVG1mOENUNkwr?=
 =?utf-8?B?MU1KanR4VWF2RHB5emVyQlUvQnE4U1N0OTAya1dSRHFkRGQ4YUFBaVhqN0Vo?=
 =?utf-8?B?K1NxckJkYnZ3TzBqdUdFRWdYQU91LzBxdlVJM2V1b0E5VU54WWY0KzFkSFYx?=
 =?utf-8?B?b3VvNlhOTHdMREtxRk5VWmJuQkRLUWNHaGE1UjdrK25NeGxSWDJ5bVlxVjBW?=
 =?utf-8?B?SHJMTndmM21FSDRBYmRXKzh0TzVxVVQvT2dWbk1ncnZSV1BpSk92SkpYczFG?=
 =?utf-8?B?Zi93cHpXQkY2YmlXYnVZMkdsaWw3S0UzUStzNXBjNzBwY3Bld1ovZW1PQXhD?=
 =?utf-8?B?WnBRSWZTelZwM1pkbVFtR1VyaWxZV2J4K0U1SzNKY1Z4QTE0Y1hKc2hRQUFE?=
 =?utf-8?B?Sy8wNmtrTDk0V0wyeEFBcEZWYlRDcUQvVE5NUHBQTWx3Q2ZjRXFQY1pZL0dC?=
 =?utf-8?B?OXNHMHIwaVgwM2phZVhqenhkd2JMblM2dEUrT0FMdGNLUGJ5bjFiQXRPOTFF?=
 =?utf-8?B?Q3JQMGRjTWRhSlJMTXVIU0lyeDJxNUdkbEZuTWVZVHEzU0FpdWRKK0lUZ05Q?=
 =?utf-8?B?VzkxZ2NhYStTVml2MDhDdTlRVmVwTmtCS1U3S0VPaytIOC9SQTB1Mm9SZi9M?=
 =?utf-8?B?K1NPTlZsNVhsUWpSNE1YVUpCdU9WallPSDFqanFDWjZ6ZXNnZnRnWGNBWktt?=
 =?utf-8?B?bzRkNjJxK0NxSTNhS21sd2xQRHgyQ3hHdzRkMk9FR2RqL0pMa0tFT0s2Zngv?=
 =?utf-8?B?dURtUnQ4bDFUNDBpL1hGZmp6YWJjS1BhdEJWMmVTd1dUekRsTWwycDZkd1I4?=
 =?utf-8?Q?C5028yi6b8vnG9sM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b5003e-13df-436e-8938-08de53c7d069
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 23:51:19.4949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIQ194zIB1rI9qRl8zQWVcQUQp6CkhoONlGgmsYQk/nqc03h38d2D8MCfTtKKn9qSfOqAqHGhnsq1iKOXNB5kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4796
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 045E31C0007
X-Stat-Signature: 7jc7wrk9xjtmqm6t3z84mymai4mzemqp
X-HE-Tag: 1768434690-66713
X-HE-Meta: U2FsdGVkX1+ts6rCQMPW9Roqm9KN0/HVasRF1R43J2uzfk1xXm08QrB5EmQ13EGWAXDRQr+K35L9TnF75sq7xog1w+yT2L7U3AE0sE6HMJYCSqDN2DJxN4RbS2KeSzBvsZ2P1+YDbq1me+eZP3gD9QREj8zuIIjtx0H0TzLxLT5MVCa5+1JgMR7W1Yzs0T5foVRSs40oCXHlRznFAXg5VpPOQ4RS8fMM+Sg8bKJ+8Mh3CFYwCP/oR1jQ5lSZOgkiCAMa+BpMyzyHY5LOX88xzThKGl6gkciNn7i7F54h17I/0AmYR2duu0wMd91Lq1iYVBzAVpi2VObAqZkVY/Waisx1C2SzSXGZjz9otpCTQvQhGz3SpmXlN0NONaYdS13ydLbr93sJVtalrg6TQI9yvtdSdpF2q7IFuMX8/8IjVCTAcum1KQbl9EhZLZtTRCsQEChC+IZ0MS6CzXr0UOYdRZIlJ18BuWj8DNY2SJvM6HkGMCRuwZF4TF4bcO2vHH+sCm6/zJqPZ/Mx4tv6v/VIpWNnIkly8p1NfO12l7QXT/jQUkLBbexT/Ti8iZwHNHbUmB2RRkLA5kWDAFCMrPjIiG26v9rLvkFdZ+Rpll0gKFFzsKD2tC5dy/vSHCn3qI4m5JCZVtPakdZYz36zTSxh6CYKUlv7eaxvzvU85IHkMZC3CR0cTuvB7qlYrE4CveRGofIGUuIDDr5PA4OqLdns0w2mTfW2RQfkKPdPo1/LNz+62drw7Ii7ijf69bQW456gRyX6Yhf/qYvEavcgS6OnEW7NYDZWSVU+rmN5d1pqtbemBVqPrQDHhLiuTSbU64yi92ahEpj3tt62RmizLgH6yeV6WFvXXr+0f2d9lnzB/kCi2/DxQY879W85mpNU34Ia+vy8TV1ZG1kk8nHhhbeapprdjmjro6JnsShgF9Hyo6JYqgKPrWRF38Q2dc1Gv/zgJMFb671IKyAR/h4m8Nc
 3SHMIoZK
 STYkPtqpXTv6t0ymbFqZ2dM09hImafdCBsX9td1/ymAkfAOS9Ssvn4A3IR5Sorc1pBVgITJ39nw9GgKaVzuN4UZlii2ruYYXQvGX0ampz+uCVuvi1ObrGQGc48/Bxbvfr3P/W2e53kv00yhKGZfj8WAcr5aP4mJ29IP6h5IrFLaZ3DdCd0AsNzv2hH6ib435kq5iC4vCrzRNqesCoPe0UH0lFSPn1HY+S7RjN4FSd65CqyFtgCdI0DPbTctlQiaaSYn7GnCt0QJlSLnBtVSSR7I7HQ3wF4gGYGq+oBttRbm7r29GA0a2oGrCVRcZO/4GYGzTPszQgm4EikAqvy4OY8XmIa1FaGMfFa+D/iHVgkkSwk/YVm+Hf+AeYPufQMzB1/szHtQj295BQKInHFPIzR9VhxklcRkvrNIWZuH+YBbL80l5PlMgIopi0E/Fbu2Q9M0Z6ORA+EQNMOY21/sKnilQqIIiqQFHnoWuEmvALqNya8LBVOeZNzljRuPg5tvstQqiE34E3n1nFhIe/nxPISSjONz2dOFEP5esNXR1+rdT7paap+a/qoFYzW7BBXjKVFSWt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 03:34:21PM -0800, Matthew Brost wrote:
> On Wed, Jan 14, 2026 at 01:48:25PM -0800, Andrew Morton wrote:
> > On Wed, 14 Jan 2026 20:19:52 +0100 Francois Dugast <francois.dugast@intel.com> wrote:
> > 
> > > Reinitialize metadata for large zone device private folios in
> > > zone_device_page_init prior to creating a higher-order zone device
> > > private folio. This step is necessary when the folio’s order changes
> > > dynamically between zone_device_page_init calls to avoid building a
> > > corrupt folio. As part of the metadata reinitialization, the dev_pagemap
> > > must be passed in from the caller because the pgmap stored in the folio
> > > page may have been overwritten with a compound head.
> > 
> > Thanks.  What are the worst-case userspace-visible effects of the bug?
> 
> If you reallocate a subset of pages from what was originally a large
> device folio, the pgmap mapping becomes invalid because it was
> overwritten by the compound head, and this can crash the kernel.
> 
> Alternatively, consider the case where the original folio had an order
> of 9 and _nr_pages was set. If you then reallocate the folio plus one as

s/_nr_pages/the order was encoded the page flags.

Not clearing _nr_pages is probably bad too, not sure what the side
affect of that is, but it can't be good. 

> an individual page, the flags would still have PG_locked set, causing a
> hang the next time you try to lock the page.
> 
> This is pretty bad if drivers implement a buddy allocator for device
> pages (Xe does; Nouveau doesn’t, which is why they haven’t hit this
> issue). Only Nouveau enables large device pages in 6.19 but probably
> best to have kernel flying around with known issues.

s/best to have kernel/best to not have kernels

Matt

> 
> Matt

