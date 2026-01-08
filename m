Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB80BD14899
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 03:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596986B0092; Wed,  7 Jan 2026 22:42:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577816B0093; Wed,  7 Jan 2026 22:42:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7706B0095; Wed,  7 Jan 2026 22:42:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27C6A6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:42:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D49191B919
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:42:47 +0000 (UTC)
X-FDA: 84307399974.13.E6DE477
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf17.hostedemail.com (Postfix) with ESMTP id A854D4000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:42:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W0W+dSgD;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767843764; a=rsa-sha256;
	cv=fail;
	b=qATHQpqmXyIp11qvjalTGimEK4w6OZ99cCiYaYU115VT+A2ew6gimwecVdzsHdKdARjH/f
	3OGnxX0+1p/Dl4l6unZMFHj4i9Y+ITraMnmyqW4uW6LTmzXJRjfEP7o3cqdtOvOeAIjgHX
	HIVkJVquKmTVJjOemwOmb5uZ5DRAXUs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W0W+dSgD;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767843764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2c44sXqI1TR3W7a0yWVlKR8HnzmyCAZf1ykE7u95SQ=;
	b=rrz4Pju4SLzvfdgmT3QxfQOctqOOxoshGeH/pVBjKNgM9uWeJCdYAxWuzhooYN6tmoBlUz
	UHjIeDzVmWAnW1086Bn7vj4+iU/P+TeaVo9QHuYpje26PutNzPWi/iKpUktG6m+35vU05G
	BaVxOtDAtnM8waD3PzaDOHA6ZvxdsUg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767843764; x=1799379764;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=nERX5Ay73Z/ayvAcdxrpOU3LCzBFhHeupVvpHsupjL8=;
  b=W0W+dSgDpjmdFaeGCdYk3B+fX0fBHvXc7jIK/TRfKBxyZrU2YfhdzkJ9
   RoyzXo1L5gsKaD5dbJaxPGJ7pNqg9ph3q96gk9NYifIet6QplR+qGgyo1
   5Po9XbfyRAiwSIgRIz18VOF6jZCZNGzQRDPXjSRuIxPw3HPBwclYa1tsM
   ey4MHf9JIIgMElg6nZhl2k3Yxk9R5lZjhDA5JhGV+xbnEXNndPYD9OuZf
   JoE0L/3N7a7P+4r93scmlAkKcGUcPfjrxkiKKZ9pu5bEKLYgGgqSiRqXe
   WtNek9hKa+l0/M2FM6hKd7Ntu2DYfJkd0hwIXN5GVLdvGXh6EsPAZ1zg2
   A==;
X-CSE-ConnectionGUID: MDzHQMfRSwu/yNTjfyihJw==
X-CSE-MsgGUID: somCUz9HR+K8kOREnw6wHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="73073978"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="73073978"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:42:42 -0800
X-CSE-ConnectionGUID: t22mFSMMRV2y1IJ1kynkSQ==
X-CSE-MsgGUID: O1/SiTVASKedWUV5E5DVVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="208160462"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:42:42 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 19:42:41 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 19:42:41 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.35) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 19:42:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MGE0MVIH8lMOC7AYMJ0xBIJbK4EnDUzzjkLuhFUe40JDBk5VJuVxT38VpqH7/0zol+3xS6ipdVoqI00gC8tGGWbWAxyO4vy8lFmBeshA+DWirBtqKKjxLpQjwWfKEl4VKrKfXn4ykT3eRYziZqDqMDp7FCWmJ7PAZ4Y6LDXDDD94oCpE7RAvPeZPbbYxZg06Zdxsu4LgysYjCaOdYms78vWIZa+iGwPesNeNf4Z/OSUiznbiozoC4YEKWv6lZoOEgk2UzX0d2w54wndEt4iB+dyzgPXN9SCllfCVmbOFlRLF/wXa542OnTNI8kBeKdrBLuSqHSSWaGEfPaV9dPE5+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2c44sXqI1TR3W7a0yWVlKR8HnzmyCAZf1ykE7u95SQ=;
 b=HeXFshXU58CxIiYEzbuWqx5dthB1HTmDNgPr947VdolNh+ZOKKOUK9uMTy2FGQNaO4xjO8j5mSKPTHKyp8+8XuYhrCIg4O3GpPRuHupwh2NmL0HirXPI/ouQZEKjHqg7KBTgwRDRWgLnvEa3hDMPYpggtPr1BTwdCQ81+CwhTvqfC2SYlhPY4G0M/fsRbZ/1k+Sm6EbDgpozWB4tuDYM0DCqrf+i0LIvmfF8g3huN/RD0fPBDl4nyG8F59ezdPTh4meqrHDfcAq9A+prvHeVg84FA80FUxpR4zDbow270NoKdJstHgvyRbAo2X+4MvRGoCd6lKPWt2cFBIjLITLGFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by CH0PR11MB5315.namprd11.prod.outlook.com (2603:10b6:610:be::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 03:42:34 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Thu, 8 Jan 2026
 03:42:34 +0000
Date: Wed, 7 Jan 2026 19:42:31 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Alistair Popple <apopple@nvidia.com>
CC: Zi Yan <ziy@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, "Francois
 Dugast" <francois.dugast@intel.com>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, Andrew Morton <akpm@linux-foundation.org>,
	<linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Matthew Wilcox
	<willy@infradead.org>
Subject: Re: [PATCH 1/4] mm/migrate: Add migrate_device_split_page
Message-ID: <aV8np0dX/qSzGOdv@lstrano-desk.jf.intel.com>
References: <20251216201206.1660899-1-francois.dugast@intel.com>
 <20251216201206.1660899-2-francois.dugast@intel.com>
 <F4EAA470-C922-4066-A115-13D6D055C73A@nvidia.com>
 <95BD5D5B-C8EB-4EFA-A895-CFD660504485@nvidia.com>
 <aV7NBE3NS1wdsXBo@lstrano-desk.jf.intel.com>
 <541B31AD-1472-4D32-A968-B92895CC6890@nvidia.com>
 <b39d13b2-cc10-4803-b6b8-0a0447aa3349@nvidia.com>
 <aV8TuK5255NXd2PS@lstrano-desk.jf.intel.com>
 <0419825F-D627-41E9-887D-51E18A2D54E7@nvidia.com>
 <w22y7ioppcgcqikwko5v6zf4c42pdv345d6vt2kvk3dcmtmi6e@mn6undehc6xb>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <w22y7ioppcgcqikwko5v6zf4c42pdv345d6vt2kvk3dcmtmi6e@mn6undehc6xb>
X-ClientProxiedBy: SJ0PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::10) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|CH0PR11MB5315:EE_
X-MS-Office365-Filtering-Correlation-Id: 60ac93e3-15f7-42ad-fc07-08de4e67f5b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ci9wOEF3eDhJQnpoMXZtZ21ZQTJOK2lENEZ0Q3FqRm1qRjdqVlEvV1crRk93?=
 =?utf-8?B?MWpxN1ErakNNZXpveUgreGpCNU9DbmpIZEU1Z3k5K1A1QWF0NWdqQlhSdk9u?=
 =?utf-8?B?QkhUem1oNW43NDNVb1h4Z0pvK0xhMDRqOHpLWDQ5Sy8xZ2FWVC9hSEFDMnZV?=
 =?utf-8?B?LzYrekZhVnpvRDU0L25jb3h6RHp1SDZEcTVDRU9RRUs2bW1EeTJIOG1wbFRL?=
 =?utf-8?B?MGU5cFN2K0V1VGs4ZXJOSURXY3UxMTdwcFVVQTZlSFhJNU5ZV1dGZDNJRk9w?=
 =?utf-8?B?cUZwTG4xQy9JbnlTL1NETkF3aGNnYUVSVHp1Z3Y0bUdMcU9BZEQ0WjA1SkNV?=
 =?utf-8?B?MmNDdzBTV1pKdnhCQ0NDTXJ5YVJRUEExSEU1YiswMzkrYUdWRm5QM05ra0pP?=
 =?utf-8?B?bjZOUWJXcDN3MjVXbHlsOFdHc1kvQllhVjBFSGhuclRBV1ZIQVhEWFQrZnBq?=
 =?utf-8?B?QzJKWGVnSmpvRWdMMGpobWVlK2JlUy8rMW1mbHZ5Q3JwMXE0MjhOMzE4aTRD?=
 =?utf-8?B?Y2dWK1hCTWNKdUlpNE9OR0tEcHhXRGNOSVd6NzR3bjJZRlA5OGpFbUZZTUxV?=
 =?utf-8?B?U204R3pjVWt0Szlmak14UlBLSXJlMzQzUFd1eDFub0NtekYyNmxaRnRQaS93?=
 =?utf-8?B?Tzl3cnZEcDF4bmI2RjZQOXIwOCtNbTRtVGo5dkI4RExES1RBSnlZRDIydnRz?=
 =?utf-8?B?N1FEenVwUTV3c1kwUHB3aTVOb015aGRVeFpjNFlOaTJOdlFLeDlYeTJyMGo4?=
 =?utf-8?B?c1o1ZWxJU0VwNWNkSWFjYTFqMndXRWg5OUhJYmN6a3NiQUV2YWZhM1FhbEtV?=
 =?utf-8?B?K1JKckhoNGVZSllzZnNuU1haU3lWNTBZNEdpcmxRTXZXQko5NjB5ZmFBS0Q1?=
 =?utf-8?B?U2RJNmdaYzZxVmxVRVUrUTRGTmhUQ09iS2h3L2h1d3R5SEx5bWFqdFpRRmc3?=
 =?utf-8?B?RmpWbVpLa0cvUnNveUNTSTlLcEJCNWxJMk1CaVlWQzRYSDFGRy9GdjVzTjRE?=
 =?utf-8?B?OC9nc0JxT2c1WXZteGRmaXJ4NXNaOGZVdXJndmp5M1R5dVZSa1hMRUNoMExs?=
 =?utf-8?B?ZHF4Z1ZlYnJKMFpseGV6cUV4dEJkT3FOSjRRc2tiOWNqVEQ1ZU0wUGhKRk5F?=
 =?utf-8?B?ckFzWjZncEl2aHVqQjQvRkpYaFBaVnBtNUJYb1hkOGJYRVBkVzQxdGJNZm9x?=
 =?utf-8?B?cDh6L3dzZ0tpdGErNjBnaTc1S1FKQmRHYy81TjRnbXJtMkU5dVkzY0RzNDIv?=
 =?utf-8?B?Yk0wNk1hdFlBZDFGeE5vL3FCYk1tQjgxUHdoTmFPZmsrUmhkMGQyaWI2NFB0?=
 =?utf-8?B?ZHUzejRXM2o4b2d1QWlpZTdiTml5Rk5HOUI3Y2hrRkR6NEFkVWxaVElveEtQ?=
 =?utf-8?B?VVZnb21sVDV1azNYV3Roc0QxYnV0Qkd6V0w3M2hTbmx4aGVsYjZMRUFDb2xR?=
 =?utf-8?B?SUNLakQ0NGtFTmZDa3lRMWd4VGlBODA4dmlCMHNEenBQZCtiNlg3ZEgyb1Nu?=
 =?utf-8?B?UmJOQ1Y1b09WN0toaGRYUmZ2Tlg2RHBDTnQwWTN0Y3pKaFVnQ0d1a1ZHM0sy?=
 =?utf-8?B?SzZqMmhodVlyclNLc3VUQXY0SXpFYytDVzV6NW5RSWlTcjJzb0V6MFNoS2g0?=
 =?utf-8?B?VmhiVUphMkc3eWJ6RVVQckZMRHdlYlhCNWEydkRCR0piblV5K0Jpd2ZxbWJ5?=
 =?utf-8?B?aTJKek5hUG9XWHNIcUZpaWlHYm1ibi9tVGtTTFUrN3N2ZDZOS3U4UUVaOGxK?=
 =?utf-8?B?L3hhY1lzR2ZxdDNmMnlMSGNHdTFtaWlzV21yTWFoeVdTSnRYZDQzRlJkWlMw?=
 =?utf-8?B?THJLaDRjU1VCQkR1MTV5YU1WdE93TFhGbFJTTm9MVmlqR2RwVUVLekU5eEFH?=
 =?utf-8?B?RGY5QnJkRktUVWdNTEdKZXlIZ1VpUi9ldUtTcVJnTnFNR2tjVHVHb0s1WVVs?=
 =?utf-8?Q?nUQU6Jql6NEFWXX+/KDHinlOm7LBM8Ge?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emVGQm1LSURzemVtSnUzRmVzaFM4WDhkcVgyT0wyK3hvZEZybU9sNUlzZDV3?=
 =?utf-8?B?UEFJWTMvNGRQcVF4dHZZRHR6YytuUW5Bbm5MVndPanF0MExJanY2TEQySEtQ?=
 =?utf-8?B?YVJBRS8rUit4WEdpNGxJelhsYlRjRXNuTWhCWmxNejBCM3BMcThnOExqaElY?=
 =?utf-8?B?d01MRzUzbHdReVJZMmpxUWF4M1p3SmE3d2lyeXQrSDJzTVE3LzZlc1VXSnZZ?=
 =?utf-8?B?M0FIdEJ4cC9laVV1R1BTemNNRzVTRS9Yb2t6amtGVm8vM1U2WTVhRis4WU1r?=
 =?utf-8?B?MGdLb2VOeVN2THVxQ1RHemZsbGdIaSs0ckVqWU9DNFAzeVFxdmlYQ0NlczU0?=
 =?utf-8?B?Y0Z6ci9GOEFJL1M4bTlxeHFjWTE1SDU5RUw4d082M2l3c0E4SXNtS1h5ZEhH?=
 =?utf-8?B?TTkxRkhTakN5V0JCNWtGT0Q0RkpIdGlMKzQxM3dERk1zbjRkR0FRZWpnZXgw?=
 =?utf-8?B?L2xKT05TZFFlWERDbVFxemlyU2tWd0VsWlRBUUw2YWFVNGR5MG81eXpuMVNo?=
 =?utf-8?B?OWJtQW1RbGhlZnA5NnZpWWdaQ0pmTmUwMWZTM3J4cHBienZhSWNiR1RnTk5V?=
 =?utf-8?B?NWNrYWVvYXEyWkZlcGd5aGk1OW02YVZpNkM0ZW9VWkhzNFBBdGNjNW5rdkM2?=
 =?utf-8?B?Zll1Wk5zb09BbVA2R1FtUWpYcnQ5WlF1STJZcGRvbmlVc3B5SzNwVlFWcndV?=
 =?utf-8?B?dkpFMTZqelFoZER0czZ2NjVONFZGNGNWdDE2N0dhY3dSdWNNRmluK3B6bXdV?=
 =?utf-8?B?R0NUREZBRm1sTTJyMUxLZ1p6YjlwOWp1VGR6SnZuajFncVRheXZscEQvK2VF?=
 =?utf-8?B?RjY4VWhPSkZiRzEvY1FkaE01YWFjdlAwemJrME4xZWpnSmM4VTExaElOL3NO?=
 =?utf-8?B?aXg2bGRKVmpSR3lrYS9wRkNMOWpxSUJOVzE5cmdFTVFJSVpkeFpodkY2dTd3?=
 =?utf-8?B?TzR2RzhhalZxMllYRDhvd2grZHJMNWx6VXZWU3lXUFRUaFlmODR2MzVUcytD?=
 =?utf-8?B?azJtRnpjZ3FUUnlsb3owd2JwZTNoY1Q1K2hPNDRTaGhKN2dULzgxZVRQRlhn?=
 =?utf-8?B?VTlHL0pScGNkWmNKdjg2R0c2UjgzcUs3cm00U3oxRTZRYmVYQ211SmNTUTM0?=
 =?utf-8?B?ZUdjdzZtam1KQVo5NlhaV2lwSUxWYjVFQ1lsOHk4UmY5aUdxaVlSWmdLZkJ1?=
 =?utf-8?B?UVg5U3VZWS9PR2FXTUJtZytYSGFWZlRYNWF0eG0yVnByUmlhbWtlUng0N212?=
 =?utf-8?B?b21JSUdXN3hJQmRxMXVLd0FoaDVJeklmc0ZnUFYyRTZaK29nM0ZFSDc5anNk?=
 =?utf-8?B?MWVNWWNtY1Q0NnV6WXRlNlQ3TXZydFcyM09aZHFYb0hvTW11WldGa2JGTkVN?=
 =?utf-8?B?SWdkRS9STGZYN0dicTdpa1NCR3Z2c0p0WEpGUjAxOVRUUjE0RnFTQlJTd3hn?=
 =?utf-8?B?MGxVc3pXTkp2YmQ5V3hHRGgvdzU2L1BXWW5uKzJPMDduT3AwdTNzK2JxdVZF?=
 =?utf-8?B?UFc2MzQ2NjYxYmxOVE1Rb3dDWDhrdlh1M3JUODE2U050MjFDTXR2RUVHTjRS?=
 =?utf-8?B?WkJjUHBqVjVYM0s4SjdJUTh4eVNwYTlzdkJlN1FkWVlQZ0xzVmV0eGVjQ0g5?=
 =?utf-8?B?UWw2bXhOVC8xcjA5MVdUWmlIV2hHeVdWc0FYNGVSUDNpV0MySHBNNEhmT2hi?=
 =?utf-8?B?bS9SUEVoR3lKSnpBQ24vZWdpVFNDb2Y4Q2V3RE0xekkzZGxsaFliRUdMdS9s?=
 =?utf-8?B?dmhTN3haWGVIdkFWVDB3OFdXSjVXN1ZHcUVJK01hTWd4S3lKUkYxTXFSZ0Zt?=
 =?utf-8?B?Wnl1K0RxWHdlNnpwUjl1NWVOZTEzTU54bTFhUHMzTUM3OG90NVJlbkcxYUVP?=
 =?utf-8?B?REpNM1R3Sm9STktoZGVQQm9XUVJCOTd5cEttUEJPcDlxVTVtYUkveXhpRVp1?=
 =?utf-8?B?ZDBpOHBld1ByZ05sU0wzUlliYlpiclJITGloS3IxVnF5cDNJL0NzTU9tb2hx?=
 =?utf-8?B?dzR2czFRN0F6ZkdsaEoyYXhRMXhHV21MWGNGOHloclpINTQ0NEp5dVN1ZE9j?=
 =?utf-8?B?Z21kVHVCM1dXeXJWY3g2T3BIOERmTEhNbU9TTHd2dzVCaTlyV00wTGVlUmk2?=
 =?utf-8?B?OU1iaktwTjV4RkxYQ2dOamVOTUY0NUI2M1IvT2UzclFzWE00aDZuTTN3VUlu?=
 =?utf-8?B?eVhYRDc2UFhYWFltNng3amljOFFtS204R09LUVp1THdHWUQrUDhucFZlSWJ0?=
 =?utf-8?B?K3pPNWNZSVNwaUU3U29vcHBpWU51SzhjdkxOVTgxNzVET3V6Lzl6bFZHSWhZ?=
 =?utf-8?B?d0lmV0VuR2g1VHB2Q2NaSDd1RHVYL3BZZHNNWkl6WUdzeTVDV0R1MHdMclZF?=
 =?utf-8?Q?HhbMYBuX+HyMYuks=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ac93e3-15f7-42ad-fc07-08de4e67f5b2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 03:42:34.5219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u/4fRsufQLjUHhIGeXXkdZbJbGjLYOgE+us7BDAIaUqipUg96XgbmVeV1jGvwfT9Vhk1TjI7ldvWeO6eUY1pGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5315
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: A854D4000B
X-Rspam-User: 
X-Stat-Signature: kbux5t86bfc7i6cdgsrhhkdio9zg4xg6
X-Rspamd-Server: rspam07
X-HE-Tag: 1767843763-712887
X-HE-Meta: U2FsdGVkX1+hXR5tfZN1ImrrrQ9JKlDCt4kWTXazx8rvW7pKE/fHAwgpsTM3g6gje0M8pb7iGH1jnl22INMOsDp5EsuTfIjSh6Wd0oH20kzBRrGfXCY1dU2I7oR6uprzWxUSs76ksC0Boc0W9VjgQ3LNkKHvnpx/DiSG//7JnTS13wo2C8A7/nUGha1rXBVbb9aUlzcO5dpuouvVzCZ9Is9zFrI/pOTQWVWlm5OE2Ai4g65qs8de1A/qmAXkc7hQXqJuvchOg0ROOuzUGHWl4lSq68KdQM+2RwEkrgxRKTtATaNrWOy4NqD0xpf999hBGFPwDx+hRJdlAxASrKBYK/IMYW6OgYi0jE6oDi/w1Z94ozY0XSXzOmz+DoOEiHsvxpLT5fUQkeZ9U9YHiDjyVUYLMYItDOXT0G8g1JDRsbycLwGX/jknPn0NvjCmPtui8uTgnpVVJuxanwphGt88+TFGP31RWe83PvJVE9vibUBmGsRhNVqvkQsl4m2lVbMziFBLnGHS+3wpqU1yFTouHBxpkSyTYKIqn1+2IwDyPzAJR6I59ZsAMXazKYzG23masKmT9jPhSO+5ffWvYNhWBca5N+O1ZhIQ7O1bx40oMPNIQQUsrvXP/PGtbVQOKt88gSPC8/zOCM/Aj8NMFEcbjPVjj/ntWnw0Yqydrs7sRIwKZGjdoPRqM88ITqOckHdUKv/V8It4pVOS/c+z+4KkJHMn2xcVwDs7N2m7PcwA1JpodxK8G+H+Sg77ifPsFkNP2/298NfA0lnsr0W6BgjIpRe4Qc96XCQlY1Md06lQrtoK50aWtLuZPvH8qdCuA/QOIA/t9rIdeFXIj6nolHSA7meP8hz/QxJRqpnEXOMDfDF740fKjhKuWI0K9YT2/BkSyfHlkuGJfVTzX3v8Qf/1HtoqSdiULh6i4vSacUkJL9AQ0ZBm9xFoz72GAJT9lbvgBTKVVWFSDbsZhuCtTWa
 PrexfmS9
 hBmvy6veaq8p0VGtIkW16drtKGm/5YH+veZV8MCmR7t/ZPVm140xcRvnwf6ONAP4QMwYjN54QZzYj6k/qiEWtrgKp9y5+cfJSrVt2fIMScekeRCSwOleX8yaQJIpJZaNrWV6AsnHDPLUKuZ4ZJ42512/RxubpJIL45dl7Cac0S2tTWDEDpp2DYITWowFXkbnkrTPEHChXAQxxnOwur/jxTooHmdUOgd9idHpQnR+BvsRhRLu8veoW1i9oGdgFO+KJiThrl19pvYxfqiziJT6mda0utsNcWtNtR0AIsAp56MQZUw6CGCfgBN2o8qYArAJ52zNpoa/2+N55OORRZxuJOshKdWOIDMO1j8HO6u8LapgKrL5n7BrMoZlpj2p0MENbROQyrpRwmIhqf5lUVbUDQ3gIpm2+DRLJsZ+6A29rGkj7/ti5xiX/Ih1SmeLptGI4CQtXTH4Ma7jp22ImTruFUy/6+AVIZZcgMDCseEqQ11t1o/zIZp726HZP5bSjrahxMhE7uj96jN2Dw+qWv3AA1W1/eXasVcRJDej3v4HfMcxwk4/XuDDPtkDrPNAIsd3ygVIXh+ZYtvn2amlgi72Ublg/AMIPBXzpEu0TA8RbuKXEKt0v0pRTJ0PRwtZrfic68oodY8HGOi+wghg1mU9c47U1mObUin1tlHJI7p1vl8RD5r3RX82nf7dKLvluLx2zOPhDcDWXxgAch88WFiiU4vLlXrB1AgmHberBU0+QkAusGgg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 02:14:28PM +1100, Alistair Popple wrote:
> On 2026-01-08 at 13:53 +1100, Zi Yan <ziy@nvidia.com> wrote...
> > On 7 Jan 2026, at 21:17, Matthew Brost wrote:
> > 
> > > On Thu, Jan 08, 2026 at 11:56:03AM +1100, Balbir Singh wrote:
> > >> On 1/8/26 08:03, Zi Yan wrote:
> > >>> On 7 Jan 2026, at 16:15, Matthew Brost wrote:
> > >>>
> > >>>> On Wed, Jan 07, 2026 at 03:38:35PM -0500, Zi Yan wrote:
> > >>>>> On 7 Jan 2026, at 15:20, Zi Yan wrote:
> > >>>>>
> > >>>>>> +THP folks
> > >>>>>
> > >>>>> +willy, since he commented in another thread.
> > >>>>>
> > >>>>>>
> > >>>>>> On 16 Dec 2025, at 15:10, Francois Dugast wrote:
> > >>>>>>
> > >>>>>>> From: Matthew Brost <matthew.brost@intel.com>
> > >>>>>>>
> > >>>>>>> Introduce migrate_device_split_page() to split a device page into
> > >>>>>>> lower-order pages. Used when a folio allocated as higher-order is freed
> > >>>>>>> and later reallocated at a smaller order by the driver memory manager.
> > >>>>>>>
> > >>>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
> > >>>>>>> Cc: Balbir Singh <balbirs@nvidia.com>
> > >>>>>>> Cc: dri-devel@lists.freedesktop.org
> > >>>>>>> Cc: linux-mm@kvack.org
> > >>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > >>>>>>> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> > >>>>>>> ---
> > >>>>>>>  include/linux/huge_mm.h |  3 +++
> > >>>>>>>  include/linux/migrate.h |  1 +
> > >>>>>>>  mm/huge_memory.c        |  6 ++---
> > >>>>>>>  mm/migrate_device.c     | 49 +++++++++++++++++++++++++++++++++++++++++
> > >>>>>>>  4 files changed, 56 insertions(+), 3 deletions(-)
> > >>>>>>>
> > >>>>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > >>>>>>> index a4d9f964dfde..6ad8f359bc0d 100644
> > >>>>>>> --- a/include/linux/huge_mm.h
> > >>>>>>> +++ b/include/linux/huge_mm.h
> > >>>>>>> @@ -374,6 +374,9 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
> > >>>>>>>  int folio_split_unmapped(struct folio *folio, unsigned int new_order);
> > >>>>>>>  unsigned int min_order_for_split(struct folio *folio);
> > >>>>>>>  int split_folio_to_list(struct folio *folio, struct list_head *list);
> > >>>>>>> +int __split_unmapped_folio(struct folio *folio, int new_order,
> > >>>>>>> +			   struct page *split_at, struct xa_state *xas,
> > >>>>>>> +			   struct address_space *mapping, enum split_type split_type);
> > >>>>>>>  int folio_check_splittable(struct folio *folio, unsigned int new_order,
> > >>>>>>>  			   enum split_type split_type);
> > >>>>>>>  int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
> > >>>>>>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> > >>>>>>> index 26ca00c325d9..ec65e4fd5f88 100644
> > >>>>>>> --- a/include/linux/migrate.h
> > >>>>>>> +++ b/include/linux/migrate.h
> > >>>>>>> @@ -192,6 +192,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
> > >>>>>>>  			unsigned long npages);
> > >>>>>>>  void migrate_device_finalize(unsigned long *src_pfns,
> > >>>>>>>  			unsigned long *dst_pfns, unsigned long npages);
> > >>>>>>> +int migrate_device_split_page(struct page *page);
> > >>>>>>>
> > >>>>>>>  #endif /* CONFIG_MIGRATION */
> > >>>>>>>
> > >>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > >>>>>>> index 40cf59301c21..7ded35a3ecec 100644
> > >>>>>>> --- a/mm/huge_memory.c
> > >>>>>>> +++ b/mm/huge_memory.c
> > >>>>>>> @@ -3621,9 +3621,9 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
> > >>>>>>>   * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
> > >>>>>>>   * split but not to @new_order, the caller needs to check)
> > >>>>>>>   */
> > >>>>>>> -static int __split_unmapped_folio(struct folio *folio, int new_order,
> > >>>>>>> -		struct page *split_at, struct xa_state *xas,
> > >>>>>>> -		struct address_space *mapping, enum split_type split_type)
> > >>>>>>> +int __split_unmapped_folio(struct folio *folio, int new_order,
> > >>>>>>> +			   struct page *split_at, struct xa_state *xas,
> > >>>>>>> +			   struct address_space *mapping, enum split_type split_type)
> > >>>>>>>  {
> > >>>>>>>  	const bool is_anon = folio_test_anon(folio);
> > >>>>>>>  	int old_order = folio_order(folio);
> > >>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> > >>>>>>> index 23379663b1e1..eb0f0e938947 100644
> > >>>>>>> --- a/mm/migrate_device.c
> > >>>>>>> +++ b/mm/migrate_device.c
> > >>>>>>> @@ -775,6 +775,49 @@ int migrate_vma_setup(struct migrate_vma *args)
> > >>>>>>>  EXPORT_SYMBOL(migrate_vma_setup);
> > >>>>>>>
> > >>>>>>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
> > >>>>>>> +/**
> > >>>>>>> + * migrate_device_split_page() - Split device page
> > >>>>>>> + * @page: Device page to split
> > >>>>>>> + *
> > >>>>>>> + * Splits a device page into smaller pages. Typically called when reallocating a
> > >>>>>>> + * folio to a smaller size. Inherently racy—only safe if the caller ensures
> > >>>>>>> + * mutual exclusion within the page's folio (i.e., no other threads are using
> > >>>>>>> + * pages within the folio). Expected to be called a free device page and
> > >>>>>>> + * restores all split out pages to a free state.
> > >>>>>>> + */
> > >>>>>
> > >>>>> Do you mind explaining why __split_unmapped_folio() is needed for a free device
> > >>>>> page? A free page is not supposed to be a large folio, at least from a core
> > >>>>> MM point of view. __split_unmapped_folio() is intended to work on large folios
> > >>>>> (or compound pages), even if the input folio has refcount == 0 (because it is
> > >>>>> frozen).
> > >>>>>
> > >>>>
> > >>>> Well, then maybe this is a bug in core MM where the freed page is still
> > >>>> a THP. Let me explain the scenario and why this is needed from my POV.
> > >>>>
> > >>>> Our VRAM allocator in Xe (and several other DRM drivers) is DRM buddy.
> > >>>> This is a shared pool between traditional DRM GEMs (buffer objects) and
> > >>>> SVM allocations (pages). It doesn’t have any view of the page backing—it
> > >>>> basically just hands back a pointer to VRAM space that we allocate from.
> > >>>> From that, if it’s an SVM allocation, we can derive the device pages.
> > >>>>
> > >>>> What I see happening is: a 2M buddy allocation occurs, we make the
> > >>>> backing device pages a large folio, and sometime later the folio
> > >>>> refcount goes to zero and we free the buddy allocation. Later, the buddy
> > >>>> allocation is reused for a smaller allocation (e.g., 4K or 64K), but the
> > >>>> backing pages are still a large folio. Here is where we need to split
> > >>>
> > >>> I agree with you that it might be a bug in free_zone_device_folio() based
> > >>> on my understanding. Since zone_device_page_init() calls prep_compound_page()
> > >>> for >0 orders, but free_zone_device_folio() never reverse the process.
> > >>>
> > >>> Balbir and Alistair might be able to help here.
> 
> Just catching up after the Christmas break.
> 

I think everyone is and scrambling for the release PR. :)

> > >>
> > >> I agree it's an API limitation
> > 
> > I am not sure. If free_zone_device_folio() does not get rid of large folio
> > metadata, there is no guarantee that a freed large device private folio will
> > be reallocated as a large device private folio. And when mTHP support is
> > added, the folio order might change too. That can cause issues when
> > compound_head() is called on a tail page of a previously large folio, since
> > compound_head() will return the old head page instead of the tail page itself.
> 
> I agree that freeing the device folio should get rid of the large folio. That
> would also keep it consistent with what we do for FS DAX for example.
> 

+1

> > >>
> > >>>
> > >>> I cherry picked the code from __free_frozen_pages() to reverse the process.
> > >>> Can you give it a try to see if it solve the above issue? Thanks.
> 
> It would be nice if this could be a common helper for freeing compound
> ZONE_DEVICE pages. FS DAX already has this for example:
> 
> static inline unsigned long dax_folio_put(struct folio *folio)
> {
> 	unsigned long ref;
> 	int order, i;
> 
> 	if (!dax_folio_is_shared(folio))
> 		ref = 0;
> 	else
> 		ref = --folio->share;
> 
> 	if (ref)
> 		return ref;
> 
> 	folio->mapping = NULL;
> 	order = folio_order(folio);
> 	if (!order)
> 		return 0;
> 	folio_reset_order(folio);
> 
> 	for (i = 0; i < (1UL << order); i++) {
> 		struct dev_pagemap *pgmap = page_pgmap(&folio->page);
> 		struct page *page = folio_page(folio, i);
> 		struct folio *new_folio = (struct folio *)page;
> 
> 		ClearPageHead(page);
> 		clear_compound_head(page);
> 
> 		new_folio->mapping = NULL;
> 		/*
> 		 * Reset pgmap which was over-written by
> 		 * prep_compound_page().
> 		 */
> 		new_folio->pgmap = pgmap;
> 		new_folio->share = 0;
> 		WARN_ON_ONCE(folio_ref_count(new_folio));
> 	}
> 
> 	return ref;
> }
> 
> Aside from the weird refcount checks that FS DAX needs to at the start of this
> function I don't think there is anything specific to DEVICE_PRIVATE pages there.
> 

Thanks for the reference, Alistair. This looks roughly like what I
hacked together in an effort to just get something working. I believe a
common helper can be made to work. Let me churn on this tomorrow and put
together a proper patch.

> > >>>
> > >>> From 3aa03baa39b7e62ea079e826de6ed5aab3061e46 Mon Sep 17 00:00:00 2001
> > >>> From: Zi Yan <ziy@nvidia.com>
> > >>> Date: Wed, 7 Jan 2026 16:49:52 -0500
> > >>> Subject: [PATCH] mm/memremap: free device private folio fix
> > >>> Content-Type: text/plain; charset="utf-8"
> > >>>
> > >>> Signed-off-by: Zi Yan <ziy@nvidia.com>
> > >>> ---
> > >>>  mm/memremap.c | 15 +++++++++++++++
> > >>>  1 file changed, 15 insertions(+)
> > >>>
> > >>> diff --git a/mm/memremap.c b/mm/memremap.c
> > >>> index 63c6ab4fdf08..483666ff7271 100644
> > >>> --- a/mm/memremap.c
> > >>> +++ b/mm/memremap.c
> > >>> @@ -475,6 +475,21 @@ void free_zone_device_folio(struct folio *folio)
> > >>>  		pgmap->ops->folio_free(folio);
> > >>>  		break;
> > >>>  	}
> > >>> +
> > >>> +	if (nr > 1) {
> > >>> +		struct page *head = folio_page(folio, 0);
> > >>> +
> > >>> +		head[1].flags.f &= ~PAGE_FLAGS_SECOND;
> > >>> +#ifdef NR_PAGES_IN_LARGE_FOLIO
> > >>> +		folio->_nr_pages = 0;
> > >>> +#endif
> > >>> +		for (i = 1; i < nr; i++) {
> > >>> +			(head + i)->mapping = NULL;
> > >>> +			clear_compound_head(head + i);
> > >>
> > >> I see that your skipping the checks in free_page_tail_prepare()? IIUC, we should be able
> > >> to invoke it even for zone device private pages
> > 
> > I am not sure about what part of compound page is also used in device private folio.
> > Yes, it is better to add right checks.
> > 
> > >>
> > >>> +		}
> > >>> +		folio->mapping = NULL;
> > >>
> > >> This is already done in free_zone_device_folio()
> > >>
> > >>> +		head->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> > >>
> > >> I don't think this is required for zone device private folios, but I suppose it
> > >> keeps the code generic
> > >>
> > >
> > > Well, the above code doesn’t work, but I think it’s the right idea.
> > > clear_compound_head aliases to pgmap, which we don’t want to be NULL. I
> > 
> > Thank you for pointing it out. I am not familiar with device private page code.
> > 
> > > believe the individual pages likely need their flags cleared (?), and
> > 
> > Yes, I missed the tail page flag clearing part.
> > 

I think the page head is the only thing that really needs to be cleared,
though I could be wrong.

> > > this step must be done before calling folio_free and include a barrier,
> > > as the page can be immediately reallocated.
> > >
> > > So here’s what I came up with, and it seems to work (for Xe, GPU SVM):
> > >
> > >  mm/memremap.c | 21 +++++++++++++++++++++
> > >  1 file changed, 21 insertions(+)
> > >
> > > diff --git a/mm/memremap.c b/mm/memremap.c
> > > index 63c6ab4fdf08..ac20abb6a441 100644
> > > --- a/mm/memremap.c
> > > +++ b/mm/memremap.c
> > > @@ -448,6 +448,27 @@ void free_zone_device_folio(struct folio *folio)
> > >             pgmap->type != MEMORY_DEVICE_GENERIC)
> > >                 folio->mapping = NULL;
> > >
> > > +       if (nr > 1) {
> > > +               struct page *head = folio_page(folio, 0);
> > > +
> > > +               head[1].flags.f &= ~PAGE_FLAGS_SECOND;
> > > +#ifdef NR_PAGES_IN_LARGE_FOLIO
> > > +               folio->_nr_pages = 0;
> > > +#endif
> > > +               for (i = 1; i < nr; i++) {
> > > +                       struct folio *new_folio = (struct folio *)(head + i);
> > > +
> > > +                       (head + i)->mapping = NULL;
> > > +                       (head + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> > > +
> > > +                       /* Overwrite compound_head with pgmap */
> > > +                       new_folio->pgmap = pgmap;
> > > +               }
> > > +
> > > +               head->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> > > +               smp_wmb();	/* Changes but be visable before freeing folio */
> > > +       }
> > > +
> > >         switch (pgmap->type) {
> > >         case MEMORY_DEVICE_PRIVATE:
> > >         case MEMORY_DEVICE_COHERENT:
> > >
> > 
> > It looks good to me, but I am very likely missing the detail on device private
> > pages. Like Balbir pointed out above, for tail pages, calling
> > free_tail_page_prepare() might be better to get sanity checks like normal
> > large folio, although you will need to set ->pgmap after it.
> > 
> > It is better to send it as a proper patch and get reviews from other
> > MM folks.
> > 

Yes, agreed. See above—I’ll work on a proper patch tomorrow and CC all
the correct MM folks. Aiming to have something ready for the next
release PR.

Matt

> > >>> +	}
> > >>>  }
> > >>>
> > >>>  void zone_device_page_init(struct page *page, unsigned int order)
> > >>
> > >>
> > >> Otherwise, it seems like the right way to solve the issue.
> > >>
> > >
> > > My question is: why isn’t Nouveau hitting this issue, or your Nvidia
> > > out-of-tree driver (lack of testing, Xe's test suite coverage is quite
> > > good at finding corners).
> > >
> > > Also, will this change in behavior break either ofthose drivers?
> > >
> > > Matt
> > >
> > >> Balbir
> > 
> > 
> > Best Regards,
> > Yan, Zi

