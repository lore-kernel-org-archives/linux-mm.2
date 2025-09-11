Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD42CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74EAD8E000D; Thu, 11 Sep 2025 13:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726E98E0002; Thu, 11 Sep 2025 13:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6152D8E000D; Thu, 11 Sep 2025 13:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DBBE8E0002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:56:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04C9686BC1
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:56:49 +0000 (UTC)
X-FDA: 83877724980.13.00C7110
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf30.hostedemail.com (Postfix) with ESMTP id C55C180012
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:56:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ECix1HHj;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757613406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6DBJNuN0y7gNahI+WK//UHlgh+Z3UoqKsshDDTydUE=;
	b=fFadl6dmwnSd1UxdeSnS9FwnkDsxUT0ADSk8XZtP0OnxIKMl0WUrE8kShhQ0VsFsXcfX0j
	MxTlfNtim7X250TbyVGC9dzKPZsNXzwm+pwLo6/hlX9NxKJmDukltQNVlPcVpKbH/0dk6V
	d43l4asmx1yEjuKdHMg+gEt6JWHmUKM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757613406; a=rsa-sha256;
	cv=fail;
	b=wJPOgvtV2au+BzUTOvzYMYCc7iwY2UpBpUOScYt0JpzgrGbozvgfZQCK1kma9+KceDh5UH
	/QxRStdFudDtp4n7ekKNroiDWFi1cEmUwZyyvmbMTLJSblqgjqdK7Z8BJqSCv1QCTqYyby
	yGpMeoEj/1zp9SLAxCP7GEgv5WshyUM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ECix1HHj;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757613406; x=1789149406;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Uc24lRV32xubNTYYlcpkNt2sqC83HiJ0fVUNtxch68g=;
  b=ECix1HHjBMJAMIDru9sYO+ZZXh4NXkgY5sFMQeK3Il2cYiuqldXS+3By
   9m+8UZQbTNDKZBvaFZjmY8d4x5TjH6P0mdQq6QsmPEztACPzlGgPF5aTr
   0/cJ7JeyHq5KfFgSQCiAjG5k42E40pZfLWdYNnK3o9cnJD+tczudf3HK7
   w1sOaRlOEkw9403hDEdtfku2noB65IgN+5CRgAnYb1ApuQT32ODcG5MpH
   RJAm8I7NLRkP8EWkC//YtvczAy+7dUqD4Y2ZNX6Rf5TJXqpN2agZ4/x68
   T6cyjYZJkXNap+cg51du4f1hX2aZAXdzrnx98iyvi8Z4ZBqUz3RRsxiTJ
   g==;
X-CSE-ConnectionGUID: NzTZzwaER9WAJdUHxireCQ==
X-CSE-MsgGUID: VObRkp/ZSBSzD1n8TyBWxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="63780381"
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="63780381"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 10:56:44 -0700
X-CSE-ConnectionGUID: 9tycMnT5S0eM8+ZngyE7Gg==
X-CSE-MsgGUID: QJxOMmNsSlmvJzmwChoFzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="174136548"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 10:56:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 10:56:42 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 11 Sep 2025 10:56:42 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.49)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 10:56:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e6nt2sh2blTQty2OTR6EJV7HMHj6uHD9yMYqGNgPBorx0N+XSisAdLabYClFB2aXl7iJBo6nZ0Sl3TbU6EyLSRZbkeq9vfTZK+2SRiE2xc6nOPdwFKqBJ6BT5OAUbet7mGdfqEgKXAZafOErZTrFTJCx7NHCGuuciwhUXtYUy3KDEDZ7qH7zvQyI1tJvKYgu2DLMz/1+XNX197jQlhYxuknQon6Vlv/1N/u3XdQkScrHFIjSa4rrfqRyepMkl+QyHSTm0xbPfvsOyo0cp4pWvNemguUEe07uuUGPuh9yfyX2CNtJhRctKr4nMqEdsMyylRWiQNz4Lm7dHScbljOEDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6DBJNuN0y7gNahI+WK//UHlgh+Z3UoqKsshDDTydUE=;
 b=o++2LJXOk82w+NYkvTgeI+APl924bVwCkr0ru24lY2YyppljZ1lfzrqj+Yv3qKvwfAcDZK8fq1U+whf9RrEg6ct6n4dzElnK90YBGu1QrDIAL2om3mTbJAdZIm/arlWhitgxxFmkqLp/NWrZjR+o6N9A8rOzZALZvt0oQimfxEOjPuEDiBlSys+VOGerPD9ozDsnDm8W2AVHpkwgFdoDnx9ricc9IR1T5/2ZlcuoyE8EJsHi3wi5GL2xn4KAls4YjVH4YOcOweIwU8Prg3zlhqueEwbLra7sNKL0cMszx3hVa0FHHHWjxLpC4IHB4CE9vatXdv/hvttoVuXVWvXBtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA0PR11MB7356.namprd11.prod.outlook.com (2603:10b6:208:432::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 17:56:39 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 17:56:38 +0000
Date: Thu, 11 Sep 2025 10:56:36 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: David Hildenbrand <david@redhat.com>
CC: Kyle Meyer <kyle.meyer@hpe.com>, <akpm@linux-foundation.org>,
	<corbet@lwn.net>, <linmiaohe@huawei.com>, <shuah@kernel.org>,
	<Liam.Howlett@oracle.com>, <bp@alien8.de>, <hannes@cmpxchg.org>,
	<jack@suse.cz>, <jane.chu@oracle.com>, <jiaqiyan@google.com>,
	<joel.granados@kernel.org>, <laoar.shao@gmail.com>,
	<lorenzo.stoakes@oracle.com>, <mclapinski@google.com>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <osalvador@suse.de>, <rafael.j.wysocki@intel.com>,
	<rppt@kernel.org>, <russ.anderson@hpe.com>, <shawn.fan@intel.com>,
	<surenb@google.com>, <vbabka@suse.cz>, <linux-acpi@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/memory-failure: Disable soft offline for HugeTLB
 pages by default
Message-ID: <aMMNVA9EXXHYvmKH@agluck-desk3>
References: <aMGkAI3zKlVsO0S2@hpe.com>
 <749511a8-7c57-4f97-9e49-8ebe8befe9aa@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <749511a8-7c57-4f97-9e49-8ebe8befe9aa@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::19) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA0PR11MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: c8cb49a0-edb7-4ba6-d60b-08ddf15c8e7e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Vz2LzDw7V76RxZMQIIgxHXg3zX5MHIIec7z+GhTghHz8yCQcSEZ4uva+5iDp?=
 =?us-ascii?Q?UJksfQsyQckT7e6+LBHnq5nDutqL39fSlU9zbuPB7CkizQvYVNOE7oZJOuT+?=
 =?us-ascii?Q?JbHRDnx/6/bUrkso6O99xBG+mLr2VebAQo219dtXLinTHjU4lRz08DX5Os7q?=
 =?us-ascii?Q?EOHMSKFp8WcFmWX3gwf5t+cyWxYPKKYJI0Ht89LF0RnT14hy2/PfCjgiTPjj?=
 =?us-ascii?Q?hvMElxsgN+m24hLl21+/MmNqAcmzJ2rEnqYCsoojWfDvCj7zXnuLcu/b6TXg?=
 =?us-ascii?Q?m78oULM26DzpfYvf9puhjTXWqjv8tab7+A6lSIKb1QUucNu9Co9/NptT6qW+?=
 =?us-ascii?Q?KADf5gXoZXo5yRRajR8xENyQz4mWRuavSb5QC+CxaSl3MF2F8Adb/u/czKIS?=
 =?us-ascii?Q?eEukOSX10nGbcPgP4vzfccpU9pakuk41A0fMLhLVRWzj4yTfHtqZ9V/LjlCU?=
 =?us-ascii?Q?U0pnJnkIpuTTUK0/GLIZDMM1hOAWieZvmEwJJeARnHptOPlOxyB+pmZ3dXC1?=
 =?us-ascii?Q?jH7U6VUmX7AU0QMRQwkByELFEXtz+EMZguyRVJA9H0H09O1bUaXhdnRR3Yuo?=
 =?us-ascii?Q?T0FVOg+OdEfy3OR6ayVqIQ8dfR2PXpblVgMxHMd0kHMuy0UNdiSacK6jcU/o?=
 =?us-ascii?Q?EC1pUmGJIxVkFWMsXkXbv9pBtB3aWeFPH0VbDBVr1pxz6TdzgzsLE2qy7drn?=
 =?us-ascii?Q?w+kXCpktmUSELaNybYBexK+BN7l5cPIhM4zajtGxf4PLsGwtEJ+wnjp4DyW8?=
 =?us-ascii?Q?gbsYJ9AL0BJxmhSo+zbs5kweaP9MWc+FfefwD/JP9CNSGxdpX3ESGwPheINt?=
 =?us-ascii?Q?QhptlScn0lcmJuRwrW7wM6s+OuQyklz2bOZ4pwyYFwy9x4r3pYYKCPwlhSlX?=
 =?us-ascii?Q?oWeXieXPvQlTTyST/AZTTZ8WwFVFuLRbOsERZQaWCXUzuux42FEHqbiDtKKM?=
 =?us-ascii?Q?3Al0XFmkbw0VfQmHGyrjQDsT0aHAcIX0+g5R4Y0fDHHfdjIhgSgMKSJafSsW?=
 =?us-ascii?Q?Qj9Vp1D0wTskVQVtOxT0WoMT+x0wnA2zGu0eUaGA94OvDLw5lYJr8kh9pYfG?=
 =?us-ascii?Q?NYh+crs7YYILFztM3SSTAX5Nqld3zUfZPNpml38jfAEgCy2y7/CD3ma5aTeN?=
 =?us-ascii?Q?QiqiaD/y6vlfWz7gBMsU+0G+PI07U5Ll+13SFv6lqN6I9zPbeDKqfUrQ+KUP?=
 =?us-ascii?Q?EQrqH28dTtINEC1qysC0dWAuW3b/nqIKiueVLuRJB5CgrOI62MMLbLXryogd?=
 =?us-ascii?Q?7ieQz9j8WOHsAcbU5x9gwupB9GaXBfaul0dcVuSnHnAQi8OnVXlTVkyk24El?=
 =?us-ascii?Q?w5KNf7Y1hbEowSzgipuufTzAiA4GxxbewuzrDWb+l/o/ezwKDedgepbelpOy?=
 =?us-ascii?Q?IWCYBNw3mTfWPELkkoYXVQWY0waNJEc1UBQVXyK/SusIoqNRBaPOteY2Q6yT?=
 =?us-ascii?Q?82FCvaz8HvM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hTLSWhV6IHv1H7zD+W5KrJy3jiD9gUyxktZmA/0PAVWpNjc/6tmY/TMB2BwB?=
 =?us-ascii?Q?KqbZs/bKDFp88y0NJsdCLmENV5rTx9lHfh6/zEdNqFD0RILbaZ0YOEP8uHA0?=
 =?us-ascii?Q?BFCB8IlbjJ+KdKJ7wSeIM69VfI8y9E5UmN/Mkd+bRlmO035XusGFNJE/HGTu?=
 =?us-ascii?Q?Y6Bz3DlGzPIUn+qfE0fWwfsGZNZjOxfzQs32kbWp6pN1JXwwTE3QJNe5BAsD?=
 =?us-ascii?Q?Srg1nOI9qXbTS3LI1t4Ojlu75ArQQQJjYa3qI/ZDFhuS3QIWARyJ2DdlKPba?=
 =?us-ascii?Q?zGA10jp74lCUykCmWROCnr8/1lVM+VevnK9C1LewubUTRKH+GIDejXW6Bt4h?=
 =?us-ascii?Q?96H70OCaPSkWDyH84BQLJYsUdigO34z637Pb1wNJAuAX5POyBg8Fj//0dbRm?=
 =?us-ascii?Q?aYV0s9Kb7uqvUdiUD6KWYta7YioVz+OyCQHRs1wAb2jDh4D5+0eAEWCJ2dYK?=
 =?us-ascii?Q?2+/Z9pTfLxu0qjnEuOIzLQWZCAWeycaHJTyArEFxVW8Crn0SVabV2yiLk6Q9?=
 =?us-ascii?Q?vU6s6zh/2+pj3Nf/WcTQxr8dw/Pqj7rccG6qM1uaf2R8wTrll1jNbJC+CDNu?=
 =?us-ascii?Q?21DsO6VgiCDZmn8nBDjKjBmgb9nqp+XVUMZ7HJs2uF/pxIn/LQGIPUH+fXhx?=
 =?us-ascii?Q?sGW7BVQOhKVpm7B/GPvs36r4SqfcX9e7Gek+0XEprUO+3Uq6hncg2n153ZSo?=
 =?us-ascii?Q?Q9HP0E7I4Q8qQ5HPsHbp7mN7kMp3PTCvFuxJXFV2nG/C6C5nieZAYFhZHDv3?=
 =?us-ascii?Q?Eqn2rSAY2YMML4sKxGg0EsjG4urVB9PrpuHSz/dCE/f+OlJEfr+kmgaqjMY9?=
 =?us-ascii?Q?QZLblPItz9qgiiWn03WUJ/oaa3CmQ7f+j7iJxWm1rF48lO0nnwPddXST0rWe?=
 =?us-ascii?Q?7Em5zumcVZ/sTMbE9k8JOQSOzyIcYsPCuEyP+F76/1j6BDrUq1E9aN2M9H5T?=
 =?us-ascii?Q?zJoL2/NLUJYpJ7fMQM/bRtqwXe1liI3UEgR61ZR+uWWALK5RUB6h2D1rTAnS?=
 =?us-ascii?Q?cXE2UwX89LJnJI8k7En9sgE9tek7s0CvXTljFPDNFRzdhghTBaNzOOdeBj3e?=
 =?us-ascii?Q?AvqCQRC4wAm51iOL+Nf/hCrOirjbU7i+AJZXqgG4o+9c2weOC1pvc1PqKom4?=
 =?us-ascii?Q?ippDB3ayFeJync3f/0QlyHN0Yj9Bfyb0qOFJI8wZVTEEmfpqL97W+Q/nzNU1?=
 =?us-ascii?Q?sdcFFahhSdpRCKVrrz3oPlMP95f7W7BYYKU3BI3UjXir4dmtX69xtzTzvvgE?=
 =?us-ascii?Q?pYTTHXiqOcVHWGH2Wqt7TnSi3EKrRFPZIcaQREUH2M85qwC7ichViYmyf8h4?=
 =?us-ascii?Q?GYoYlvoGmgKmITiTj0lsrLvIW4K/IcUauYi0d+P8e12YUkpgRnZI7QieNzR4?=
 =?us-ascii?Q?oN3DaeEJS5LJWDcXpEBhoV09MMB4h79vNGwC8+S84XKOQWim2+2DQsazKGKy?=
 =?us-ascii?Q?HI+KcIi6VLG2GiimT7MZ+nip6YdTG3f9fVESINXY2OVk6qAXAWQKh49+dTfn?=
 =?us-ascii?Q?7JYuZxHU2hlWRr3C+VwzUoVmHeTd1LNiMejjngssLGae5ZkdNW418gNn0Okl?=
 =?us-ascii?Q?to0PW2OiG6GB6qJb1SFv+tSOH65UPUoppcUUyimw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8cb49a0-edb7-4ba6-d60b-08ddf15c8e7e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 17:56:38.7832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bnhC/g9gngKIyNckmX7yBVzm2wuWTr9TewJHSnLH9itgHecBxiV9Ap4uTT1VL2Lq5W9YsjZji74sz6LwKg/u/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7356
X-OriginatorOrg: intel.com
X-Stat-Signature: x1dfe9wg3atarqczpqcqkkfiphn1spuj
X-Rspamd-Queue-Id: C55C180012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757613405-890180
X-HE-Meta: U2FsdGVkX1/8HhPeusqDbaNE5k3DLh3r8P+h/tDu2SXx2KSpLY6qYBAimQcqebbNBtTHcJAk73VNbAhgFk9b0OkIlNZHQ4Bt8t64KAJd7EzssJsRXxKsvKJ2OeBwzHNvXLCMPZSjkUrayXXkBfRizvQCTcgBwryMWYOMvI0owz1JiWcQwiKeeB4DjEs7QTqCCSpnohVXMtYQ3jFPHHrKxjGB8+n1xFnU4eIFRpSfqzVUjRxLczQWbmZx8JAZknyJcuDxSJaS3u+0/pbc7M01ox7AR5KEGh6AnCMowds1uuwU1anZRR5DNvCgMNHQrDoHvG757Xv8f5566rpsjBS0IcAS9Qy9XIYID8VSI3QbGIsbptrVvuuyz1ZYLUnw+2Qw1/rn+bhcIg+4/mtnkpRzEsfK6eLzkMY0KlJltxek2YoD6sxDgdY5PidZZbK4nDg0hR4ZrrXMB0JXh7TCGp8pBCCcOB349l7JmnY19d2VeiZDdIjqyqPiwtgfkQtWhI0+LpDqeNPlJl3B/ubzM2+gBTS/488KBIGJI9WUmehvxyrifNWHWucUb8splnsrPkYIiNNk+YWaEYsfVG5WIbH8GSlI2BSzSDIP0mKHqugyxcIqytyCxSMwA7gTSAQYtgnLEw4LppHe8QpvqG2gtHK/T3QJ+nvsXVNyhKng+inXeLD0QhPraqZLCa2taKgAguLId2FRHNI6RFWxGW7jzahBbeCx5aKTn/z1k9q/xabLjo4SYjxHQWE43V/rpYulUHHSFav18naJv1Gjb+0wYmPWNj0AEsyophdGaZAslYQs6of/zu7iOufjQ5YzGcoHTNt5SWcy2InfLQn5vf1FvQN0nGh4Rq0pXhB96pu3pGYuGxFmaWmGuRrqGeEsDg8UA0pCw+cGAChOT8O+o61X9myO8Vsbtd5LhcXfLeARHlO+qoPQoUzx8cX8g2wFuV9g4OtPhvOJb3YueM1gZs/Ajeu
 r/HK9BW7
 DKXpbxf57ssy93BXdxDSsaj2AnKicWk43hGb3jwGPYKGy99Lbnxjkp4n1iSmTxdBo1fj9xBW/UYXga2zHh6jQYvcPK2wCtyRBtFLns8gOJ6SUbOdtNNOPc9Mwtuq4GZ4Fc/0vQCSYgYaKyQuiTgqwMxkO4pzldoXjSSUfZbEqpdXR9pzk8PO+0opbR7MtxurOXpsViVdVPh1JYTs4djAVg6YWmOX5pZ8uPViSUXS5Rj39tC2IEsFH0OpnIZy6MUKrSsPykaAj6HOiWtYqm9mTEE5bkOiiX12wUltD7a+iQyLZlB9rJmlU+QmWVC2Xamtkx3TxAoicvzDZ4KnQXp6k0OJJSqpxpvlFKByVaJGTPgdrxBooFns3qePBsDSueWKWhRrSO6bgvzaaLTZwNJeiYWloMotbnbTXYsas0YeHv+9FPKAIk3TPE9qyUHM2rp5HtL50fcZkCelfKQ74tRHyVlcpbuiG84qo1tEY2ByK2kzrr6iXaWXDBkN0Z1U98Ztd7kEN2FZqE/oRpND7BsFI/63mcf8RhhlCiioCfieBfgtFkT0SlHPXHJhGPG8qb0947US560n28OhwEq3CU2aLFM4lxRKRh2GpnhRh3oRiPT2BtftfsdRGdczLV9L6SCL0KEFKLh0BVO0Rlr8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:46:10AM +0200, David Hildenbrand wrote:
> On 10.09.25 18:15, Kyle Meyer wrote:
> > Soft offlining a HugeTLB page reduces the available HugeTLB page pool.
> > Since HugeTLB pages are preallocated, reducing the available HugeTLB
> > page pool can cause allocation failures.
> > 
> > /proc/sys/vm/enable_soft_offline provides a sysctl interface to
> > disable/enable soft offline:
> > 
> > 0 - Soft offline is disabled.
> > 1 - Soft offline is enabled.
> > 
> > The current sysctl interface does not distinguish between HugeTLB pages
> > and other page types.
> > 
> > Disable soft offline for HugeTLB pages by default (1) and extend the
> > sysctl interface to preserve existing behavior (2):
> > 
> > 0 - Soft offline is disabled.
> > 1 - Soft offline is enabled (excluding HugeTLB pages).
> > 2 - Soft offline is enabled (including HugeTLB pages).
> > 
> > Update documentation for the sysctl interface, reference the sysctl
> > interface in the sysfs ABI documentation, and update HugeTLB soft
> > offline selftests.
> 
> I'm sure you spotted that the documentation for
> "/sys/devices/system/memory/soft_offline_pag" resides under "testing".

But that is only one of several places in the kernel that
feed into the page offline code.

This patch was motivated by the GHES path where BIOS indicates
a corrected error threshold was exceeded. There's also the
drivers/ras/cec.c path where Linux does it's own threshold
counting.
> 
> If your read about MADV_SOFT_OFFLINE in the man page it clearly says:
> 
> "This feature is intended for testing of memory error-handling code; it is
> available  only if the kernel was configured with CONFIG_MEMORY_FAILURE."

Agreed that this all depends on CONFIG_MEMORY_FAILURE ... so if any
part of the flow is compiled in when that is "=n" then some
changes are needed to fix that.

> 
> So I'm sorry to say: I miss why we should add all this complexity to make a
> feature used for testing soft-offlining work differently for hugetlb folios
> -- with a testing interface.
> 
> -- 
> Cheers
> 
> David / dhildenb

-Tony

