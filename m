Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A325DC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9362E6B00B9; Wed, 12 Aug 2026 05:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90D236B00BA; Wed, 12 Aug 2026 05:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB286B00BB; Wed, 12 Aug 2026 05:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5789C6B00B9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:18:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DBE181C0457
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:18:07 +0000 (UTC)
X-FDA: 85092065814.14.DB55C4B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf26.hostedemail.com (Postfix) with ESMTP id F3FBB140006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:18:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O4E8cxBS;
	spf=pass (imf26.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786526284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1W9TB29qlQm2gygaiFtqfuEzSNEziYWXawMggffWrs=;
	b=krITTBWaaokJOw1MBaSiJOntgoiPqN6hrKpOxVu8x1mj+U+liIyH5Q+MEHwcHCRdFDU39f
	FWptcCeLy957iJhlUqsxqei2pwObQ2TG7r6Ij/M2LfYZ0g72r4DUsZGW1bFA9gviK7Q1J8
	rANMlpHADBoQtXPzjICQ6rhCftgmiJg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786526284;
	b=GfzqsJvI3HnY/pczEYLHyF1EXJpxtsdGnHonjH9w4CG6ywxejpLMEZ/YQaJxBb/FO4LW/5
	rtdjHQ0s5sPwsdNhlQcMowx0Nd/Bq59VVAVPIEcS8pHj0F2ftfCog4DTckRErNMnc7d3A4
	zsyjZce9aSNBkD0DD3U6vXKhzzXwaFk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O4E8cxBS;
	spf=pass (imf26.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786526283; x=1818062283;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G1W9TB29qlQm2gygaiFtqfuEzSNEziYWXawMggffWrs=;
  b=O4E8cxBSv72OA708O+kyj7r7fu/hlzEDbZ/5GsDtAAmeYjmfDMdTGnQN
   6APhik9WCtwF2Fubo6ZuByFV6+dPqPNJ9bl9q/fMYGeEcwYxEInFncy8I
   AjMO2DGxbiX8T7VMQ/UrIgZuVw2RwJbHGXTnQdSXyqVeGztReRPVTEd/t
   lC2av72YcUdHcomKWgAz7iOegp62OIVE2YSno0r83/ZAUUSlsJFBEfPGF
   LLQqF4pQzfY6liwJJFLwCUKXplIsBh1F4elopso+yFfLDsvER0+wqSTVt
   kZ/Cs7D84iFEqNbUvCtusbhx6Km0ITKIK4GvtTmTXUKsrUsKQ5yNeNZTV
   g==;
X-CSE-ConnectionGUID: mvrOAveaQIepPAp41TPEeA==
X-CSE-MsgGUID: k6DMlNZhQpao209qFeb8/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="87001877"
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="87001877"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 02:18:01 -0700
X-CSE-ConnectionGUID: M3mrEllmSreNNpGmTyPtSQ==
X-CSE-MsgGUID: yQyvOoUtS/KFaKTUR8N0eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="260969967"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 02:18:01 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 12 Aug 2026 02:18:00 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Wed, 12 Aug 2026 02:18:00 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.10) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 12 Aug 2026 02:18:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kne/u7F2B1ZjzpEfLj48+Ric0gvavS/YaA8GhkcbPRcpoK/Vji+QpgWUE/WtTn8G+mL0l/Omn5GElwb+C9Vj6TzW3+fxgs24hC/GzwYJOH2lT7iJbCT4WPQhvo6ODBFXN4L5X5UOM1LwLcr7HV0B1oG8weMHl8zqodfYMmGenjPS1JIzafzP8mHK7DLJBrEfDrpyfbq+A7Sa/h33hjIzQ4KX8xcs5ZUtcM0H3fM/Q34vuni2+o0KH0DoiJImVc4QFdRMpKkDVFgfaZhMjyZrpmqVFl+F3Vu3Jda1AEEbkhDOEnSeKXJgA9QxjMvCBCD7V02c/x2Uio9AxgB5lvGWWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1W9TB29qlQm2gygaiFtqfuEzSNEziYWXawMggffWrs=;
 b=Rev39y9BT8fIkbEh/XLdMduvZFu+I5zprzb1lDjGcux+LN2H5Y1KPv2zNNMJFp/2bh2PudRnLgqaSV3ajKlIylc9nD+otw6X9wqHorxAi2QsciirFNER6H6uGiqI9otzA2+KBE+Qt3iUCzrPFFgsCw5NjyLxGRsINN71x2CEnYbzQmreV4ktKXb/STemZqunf6E+VEAfc98h2V/J9Uiz5NmfuHrGBeC5R4HBrziAnS+zzC+9m6UwsmxPmMVewpZR1AR5PFZqQ2o9U645toSKUtTFJs5MUtGeTNYlmNJaXCglIboU9RsUPqAxtEcesUyOqoQyniXdVFgTdMKPf8ZTow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by PH7PR11MB6521.namprd11.prod.outlook.com (2603:10b6:510:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Wed, 12 Aug
 2026 09:17:56 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 09:17:56 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou"
	<tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng, Jason"
	<jason.zeng@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHdGn+xVv6zTQASmkebGsn1WtDYrbaPbQmAgAFEj3CAABlOAIAAETHQgAGvAgCAAAi/UIAE2WgAgAF2IQCAAV0yMA==
Date: Wed, 12 Aug 2026 09:17:56 +0000
Message-ID: <MW4PR11MB6936466F8C60509BDF73F9D1A3DC2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
 <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
 <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
 <2cbd42e1-b5bb-474c-b0e7-ce3f46541891@kernel.org>
 <MW4PR11MB6936594CC6B15968AAB781DCA3D22@MW4PR11MB6936.namprd11.prod.outlook.com>
 <0b02ef3e-363f-4b49-a208-54cdfea56c75@kernel.org>
 <MW4PR11MB69363CCE15647FD7D85542B6A3D12@MW4PR11MB6936.namprd11.prod.outlook.com>
 <f0593f56-870e-4e79-8552-1760fad255bc@kernel.org>
 <01795519-54e8-4ed8-a94e-2b77780abc3a@kernel.org>
In-Reply-To: <01795519-54e8-4ed8-a94e-2b77780abc3a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|PH7PR11MB6521:EE_
x-ms-office365-filtering-correlation-id: 07f4ec79-77d8-4893-5612-08def85298bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|22082099003|18002099003|4143699003|10067099003|11063799006|5023799004|56012099006|38070700021;
x-microsoft-antispam-message-info: s85PSlZ4rQe9UfJ689LlsquvqfQio9LzJKJe+DCJ0JF+F5yv06RwhmkY6VFhvKbMTctP/2Mp3Ygeyj+4SDq1rvd47XLfGJHOubueMtcSX3cgM9sz92jkXj8KLjBKSk3okGoep9uaqwlCwLzKouqnsE7STMsONPyIf+6wU9PxP+cmotgQkzwNe6SIa4GPlMdaCnOy0f6mXK/qAKA5HpZ36thjykJNw/9RxPQHjpvR5Ek5dcnnJZM2i+MVZIqsUktrbL7ovkEK1dfUtu2ZnxAJJiS4f+7Ks5GnzsFFGX2hpvSNW5ZiO9ESJMoXojK5cNFfWsC1rOeKkSryw8kB/gcFddijFcibLZcCAfZbEHoQpor7lpIZGqnmfFAhnkeUttmjwPHLWBrsDqndTs5LxiWWcHTWkSmSznctuyJzuz1tSYq0UYm8geLPBXG5Xyk8nCwkLqvEUAWvLkp9XxF8mBjd3aVfNiPeJ96sqDA2whU+7AmqVzgslU4aTrFz4XcJNY+n6mzW6m1MHoO/hPFBGb0S4ZW7W502yZ2bM5VeIFX6Nn05PlU7VRrFgecM+JOJd8ha7//Oul6imp0fAsABXqTzoMJDMRBcNz6ZnhsRA7YDT/ow9DR6tKQtQN1VcMluW8wqleQ+NZRQXkXqgTm86cZOlb+BRyaCb08qRwYuMIeiYsMIfstdXepTcD5ZFe8xF62Yn3trQBeR0xGkVc2imMRJUFnmFMzXKmqRoaRo3PDV7rA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(22082099003)(18002099003)(4143699003)(10067099003)(11063799006)(5023799004)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVZjS0ljUjl1Q3hZL1owVjZ1REtta2FKKzcxbWlmeE82OUs0bDlXK0VTWFJ0?=
 =?utf-8?B?cFlJZjRjZ2hoODl6ci8wTlVCOWhuTTRpYm9oS0hPM2d2VzRnd0pyRld3UU0y?=
 =?utf-8?B?dlZHU1JJeCswTTRHcS8wcEtiU2ZJTFpiaDlQOGUyWHY0NDMwSVM2NGRPTzlZ?=
 =?utf-8?B?NUk3dHBlR1ZiUHlvRzlDZnFVdmN5TW5MMmg5NGsxd015WXA3NzBKOW5yMjlY?=
 =?utf-8?B?M014cVVDcDRQWTEzWCs3Z21sd1k4bnozK2o3cVpueVZwUStxaVdVa0M3aTFE?=
 =?utf-8?B?VklPTEtIa2lVVlM5OFR2Smt2OTBvbnZ0VzJsTmdxQzJBMFFDbVRvekVLMzBh?=
 =?utf-8?B?bjMwWE1nSXA2U29MMG5kL1pIN0liVVZmeXRTQm52VGZ3dG5EVEdpU0ZCMmRz?=
 =?utf-8?B?NE1pekd5L3U3ZEZUNi9yWTlDSEdNMUFrY0UrNHRGN1NmeHdmQ1FDN2NlbFRY?=
 =?utf-8?B?WldQem5hNSt4T1dVRm8xUGJEdmJ3a2FTeG8rVytuWldESTFqWFBZTlJLZ1F6?=
 =?utf-8?B?Z3dETFVnWHUwVWMwdkwrMHNZTEhORjdacXYwUExHQUJBblpPUlU1eTdtRlNr?=
 =?utf-8?B?cUw4c09oakRCcnlkTUErNkxETlNYQzNwTm1vaGRIZ1NabXF1MTdVYS9QNVds?=
 =?utf-8?B?RFRsa21oMyszTm81M0tmOVZLZW1MblVmd2hpcXQvZ29lTEZZa1JpWUJwYlhq?=
 =?utf-8?B?THdwVWZwNTB3OWFtVnpiWVpFRWRkS2lyazVTK042UWpNSUY4L2VPOElxc2JO?=
 =?utf-8?B?L1d6L0NZMDJBL2FzZlpHd3g1TEZLY3IzdGxtNHRnV3QwSWRWbVRvZ2t3dUhM?=
 =?utf-8?B?K1ZYeG5qRDBUTDlDRXI2aW1QYWVzU0c1K3phcTRuRXN1VDkva2pKanZtTHBu?=
 =?utf-8?B?TkdsT3BpZVRkcmdaNW5MVVUxcmRZbmJkRDVsRVBzeGZhNXM0S2xYOUtvU3BN?=
 =?utf-8?B?cTdTOGhqWlNKeXVrbXNrcGJ3SXVUNnlTeG8vbGIrdHh3ck40dTV3OW9yN211?=
 =?utf-8?B?YmowNVdONjZtZFIzWU9paVF3UTY1V2dXY0l3SXp6WXVKMi9Tc0Nwd20rcWwv?=
 =?utf-8?B?OWZacWNlb2syM3FGRmt2eW1odWRBRjNEdEQ2VTVWdzZVRlQ3dHkxN1VOV0FK?=
 =?utf-8?B?Ny9BZEVoZmcyRXpYOXgzcEQxVVpTcWExMzNOZXp0SnBqODdyTC9wbEE5dVhL?=
 =?utf-8?B?RENCcElqL3kzL1U5dHdCc1l5M0R4YTVkbXdGazBFQnhHb1lWQ1FDVU44WW1I?=
 =?utf-8?B?eDBRK0NxSWxza3hQQ3M1SlYzUzRQVzF2cmc1Y3JqRGJHa240ckFGUTk5QnVo?=
 =?utf-8?B?ZDhBaHdsUGs5R0JDdTByVFNyK0EySno5TkVKNGs4OGZKNkwwTVhYSi9vK25Z?=
 =?utf-8?B?eXFQbHdTa2V1RlBUY3pOeTlyNmQzbC9vL0NjVCtQamJGU0d0MkNyTEtxS1cv?=
 =?utf-8?B?TEhiQ0Fndml3YWtHOUs3dnB2MVpvdFJFeEVZWExtYnJlQ2tqUDhWWVFaL0Q4?=
 =?utf-8?B?N1dtYjFxTktXUkpsaitmbGZGcG5QWGJHRmNJTDI1ZnUyelA5RHQ4RzRSL2tp?=
 =?utf-8?B?eWhGeXBJWjlYdStFSnU0VnUraVQxdUJXMGNoSStxMmFKajJUL1pIQlBDdHRi?=
 =?utf-8?B?OUlDbzdFVHRGTVVESXhJQzlnMXVKRnBiNS9ObnNUR0NBbkVtektZUVBwdzRF?=
 =?utf-8?B?eDZsNFQ3bUF4U2UxeXBtNld0RzdUTmJmQ2tjT2dMb1Y2cFRWQUdPYU9wc3hM?=
 =?utf-8?B?cVRRT1N6K1NDTDNxSDYrZFdYelZoeTFIVVZkM1poVy9ZdkliQWUxRDRVUWhq?=
 =?utf-8?B?eGYwT3NhTlVQVy9EdlNubGQvdTZVZlhjNVp1akx2alQ3aEQ0NzBOZTQ1RjRO?=
 =?utf-8?B?cnZyOGZaUGFTODBLV3dZR1JMT3ZPQXRPaFIydWZTbk5heTNvcVVlR2NqVmd6?=
 =?utf-8?B?M253T1dNL3NXeG5JbklNUlBDb2JhN3cyd0d1WVRrNzhzdCt5dmxYcUU0S3BD?=
 =?utf-8?B?RDltWEI1R0R3TmlyVHpCaTduQUZSZHJzQnhaRlBWekdPRlpxWVJ6MDBqcC96?=
 =?utf-8?B?ZWVhRU4zeHVTazRiUzhLbEZ6YVQ3QXNiMGtleThsZVBqeXQ5RGVlWWZHNjAr?=
 =?utf-8?B?a1A5R2RhZFBHMCtOYnVRQmVLL1IyemhMdGdyc2JRUkpFaTNTTGhHdDhXY2t5?=
 =?utf-8?B?Z3Y1V3JqSDhmUmlwbE5FRFNMcUh6RHA4b2FodW9MUUpVVjJWVXRkNFF0eStL?=
 =?utf-8?B?NGtLMldBNDVnQzZ1d2tLZ2VGZUloKzluRUJBeG1FL2x1NlVhNnV2bXJ4Y29R?=
 =?utf-8?Q?kOZUmg2hUWReisHIS3?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: N9BqdnUWh/RkNOm/XrT/m5LrQrsZBRa55CuJZwCOt1fDPkLDSRLr2PBS48LmRmc7WqY2yr1VjJejMnl942XIXxXflSbMERCG09g6igkrTP7CZwWS7cpkfQZdtZ3ZNgXVfmPZnD0cn5LJCwr3BiUgU2zkatvrS42oEOX+mt7zR3b8xZNjwQz7vaQUe55j/dTSzstbjVxSX/WjVo1Vc4B5KMbPoBuW4QRWeQoWBbua/G8CfSNP4R1jIRK137d6yCZZBlcwx4cu56ymfe7w8OMJ+L6ZeGe+XrF0gKW6jVa//VUF/3xRo5DJYRCeWRx+tKebePzFsOeWoU3+vvdwa4Onzw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07f4ec79-77d8-4893-5612-08def85298bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2026 09:17:56.5400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YtYyIpXMpw0SUzDJ9Yafmbi3NNNu+EZd8+0sYNNKp0uGiIAJsvJY5yue87xo05KnGsrvAh2ODOwO3ezazyuvcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6521
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: 4ezmodk4gd3y96hzbg5mqfsnwkjqsibj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F3FBB140006
X-HE-Tag: 1786526282-166636
X-HE-Meta: U2FsdGVkX19ElKaVXf59Nj9VwYP04s0h/ian6rQxJsYO1Lsvj/8f34h8cAOWZkx0YWif8XibjeCXkaqzG4mK1ryMB0zNH6wQyxfUvIEL/5gJ354H4Cg6w8At9CLvl32BpMmJGvpcRcKtE99Tc9TSysD27+BHwgcwtMzhSF1DkKEEwz3zK5Al/fQWXIbVic+YHOdetCayx+A3Ziwf7M3F5P4Gp06bOMORkNnzq60Z+WRnu7L6AeExqX/JT1jJkDnvLGZlnblZr64GMoNMjQthzUhfzN1E4TOhus3sUhxorhAUoAEEclxS1QcAeljra97QUbIira0p2l3wV6LygqC675jl4ALRC3rqnVCDJG3HDPIRSFi1iyMD9fDSVsS8AbCGyRi2xLW5sJ5Cq+j6FJQDUZXnj5B6S+urXjoifR+2WgKpMZRwNfYXL8BCFG21yaYFa8iZnONQC+t/j1xnwylINMEoysqcvH6yx+VwmfmBzPjqdo5HCpCRgawlZzc7tK3SPKQlfxoqP62+k5AmCGeQIvhYKjzQOY4emnMTVRM9IkAq6jbyEyfeivlikwlVtdap5v6qzOR8Lhbsm8CJq3WHnaFDr9qIwdcW5Q+BwUGyE6Z06X5bk2qFWyGExbOLJNdIjl1NJ3vnWDy1TZ8fodQpRFB/JM7421txcPhZb59ulYn5/+QFDXT3ptY34hYlDCJb2uQzkxYR1atqg2BDN9xxGBFAcTrrOza/Ku2fDriBuZfnGWEachVlyauZXbQLvjT/rDYEZLacE51ZuhynzIWRcxPgLkHBLUUW16iGx/G1sqeIxpO3SP9C9PliOFwt8gjUQHwerN4y3lBJVUzQqf0KyHPPR5/q+8gd+MHMvq+4tp6+B0cluhTflFOhKwqkSqcK4Qd2FcdKZfA0q/TIzfDkkY4FUuewoqebH8HW/LOaQ3KTiIaMTTg949IDVQV4a4mKJAGzqEVqxcg6if3BUde
 5zwOVQAT
 UUVhurjuaBoNzPUh6mFEf/hwmF4a2aO6Z/ywltPHJz2utjKj119yQ/fnuoQgabv03GsN82k9a8Ptg6fEQ54gBsYslXnh1cA3GUEk31lRVjKrDuA0y1CZmsfv66rW1OUUJ5nlMLJyDPaHMRA6DNdhYSLSdlyC04yh4xjouFsH0mmipHi7AZ5zSVtd9UoRIVYKRi0apFQ+g/bUa7170truErUcLqYvGGfXDAEKO+pcwNqSuGCubW1/oRG/RF8+8L2wOGzo9O/Kt8FWi5XRFVudeifrpULzNK21T59X/4S2FIhAhv+O43YbVDJge4PGeIXKC6fuoilC5q6vDLw+VysSYDoKBKGit5ATQrqHslMWCp3i2eom3s3ABoDWvITB5bLojWki1R0BHIMj4pd2VOMjD1PFSXMdxYHImhC4PTGEcAdg85WXNKR3sdUkvg+UfqpaSMLKbWnlCgXYRLeIGN1rbDeredcc39MUO/xEatJRyil4UKsTaCARpsJjCXW5la35ROo+MF0dDvdj7ltdfF43a16UXxH6W9+hk/iff2ca2pUiHF05pCC6PUHGH+62IZitXy5r7UcMr/6XLWl3PR82oXg3jahfWiAAYSuTJmrfflyHrGtTOqiY7WRUNlBgn8HoFhOaghQ5+NujexKAdnK4gU2yhZqExAwYKbBbBfevNK7pSPW3s9TGkA/ZvIJc1NDX9j2PpPVjqcTR4CiUZ1N8hiGlH36Uw8ef35fRQGOOqUc1Ta0ZKHc3ab+dnLv7LN+8+qjWmhqJXt8/97+b76xrmKQmAg136B9MXfl/RGDNbukzgg34hOZGRBdOdKTLr46y4tO423C/oO7lUFcCE05tpb/6EFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogVHVlc2RheSwgQXVndXN0IDExLCAyMDI2
IDg6MjMgUE0NCj4gVG86IExpdSwgWXVhbjEgPHl1YW4xLmxpdUBpbnRlbC5jb20+OyBPc2NhciBT
YWx2YWRvciA8b3NhbHZhZG9yQHN1c2UuZGU+Ow0KPiBNaWtlIFJhcG9wb3J0IDxycHB0QGtlcm5l
bC5vcmc+OyBXZWkgWWFuZyA8cmljaGFyZC53ZWl5YW5nQGdtYWlsLmNvbT4NCj4gQ2M6IGxpbnV4
LW1tQGt2YWNrLm9yZzsgWm91LCBOYW5oYWkgPG5hbmhhaS56b3VAaW50ZWwuY29tPjsgRGVuZywg
UGFuDQo+IDxwYW4uZGVuZ0BpbnRlbC5jb20+OyBMaSwgVGlhbnlvdSA8dGlhbnlvdS5saUBpbnRl
bC5jb20+OyBDaGVuIFpoYW5nDQo+IDx6aGFuZ2NoZW4ua2lkZEBqZC5jb20+OyBaZW5nLCBKYXNv
biA8amFzb24uemVuZ0BpbnRlbC5jb20+OyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY2IDEvMl0gbW0vbWVtb3J5X2hvdHBsdWc6IG9wdGlt
aXplIHpvbmUgY29udGlndW91cw0KPiBjaGVjayB3aGVuIGNoYW5naW5nIHBmbiByYW5nZQ0KPiAN
Cj4gT24gOC8xMC8yNiAxNjowNCwgRGF2aWQgSGlsZGVuYnJhbmQgKEFybSkgd3JvdGU6DQo+ID4+
DQo+ID4+IEhpIERhdmlkDQo+ID4+DQo+ID4+IE15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCBpbml0
X3VuYXZhaWxhYmxlX3JhbmdlKCkgaW5pdGlhbGl6ZXMgYWxsDQo+ID4+IFBGTnMgdGhhdCBzYXRp
c2Z5IHBmbl92YWxpZCgpLCBidXQgbm90IGFsbCBvZiB0aGVtIHNhdGlzZnkNCj4gPj4gcGZuX3Rv
X29ubGluZV9wYWdlKCksIHNpbmNlIHNvbWUgUEZOcyBiZWxvbmcgdG8gc3Vic2VjdGlvbnMgdGhh
dCBhcmUNCj4gPj4gbm90IG9ubGluZS4NCj4gPg0KPiA+IFRoYW5rcyBmb3IgcmVtaW5kaW5nIG1l
LiBJIHRoaW5rIHRoZSByaWdodCBkaXJlY3Rpb24gaXMgdG8gZmluYWxseSBjbGVhbg0KPiB1cCB0
aGUNCj4gPiBwZm5fdmFsaWQoKSBoYW5kbGluZy4NCj4gPg0KPiA+Pg0KPiA+PiBZb3UgcHJldmlv
dXNseSBtZW50aW9uZWQ6DQo+ID4+DQo+ID4+ICAgcGZuX3ZhbGlkKCkgc2F5cyBlYXJseSBzZWN0
aW9ucyBhbHdheXMgaGF2ZSBhIGZ1bGwgbWVtbWFwLCBzbyBldmVuDQo+IGludmFsaWQNCj4gPj4g
ICBzdWJzZWN0aW9ucyBoYXZlIGEgbWVtbWFwLiBwZm5fdG9fb25saW5lX3BhZ2UoKSBzYXlzIGFu
IGludmFsaWQNCj4gc3Vic2VjdGlvbg0KPiA+PiAgIGNhbm5vdCBiZSBvbmxpbmUgYW5kIGl0cyBj
b250ZW50IG11c3QgYmUgc3RhbGUuIGZvcl9lYWNoX3ZhbGlkX3BmbigpDQo+IGZvbGxvd3MNCj4g
Pj4gICBwZm5fdmFsaWQoKSBzZW1hbnRpY3MsIGFuZCB3ZSB1c2UgaXQgdG8gaW5pdGlhbGl6ZSBt
ZW1tYXAgdGhhdCBpcyBub3QNCj4gZ29pbmcNCj4gPj4gICB0byBiZSBvbmxpbmUgYW5kIGFjY291
bnQgaXQgYXMgcGFnZXNfd2l0aF9vbmxpbmVfbWVtbWFwLCB3aGljaCBpcw0KPiB3cm9uZy4NCj4g
Pj4NCj4gPj4gICBUaGUgY2xlYW5lc3QgYXBwcm9hY2ggaXMgdG8gYXZvaWQgYWxsb2NhdGluZyBt
ZW1tYXAgZm9yIHN1YnNlY3Rpb25zLA0KPiB3aGljaA0KPiA+PiAgIGFsc28gcmVtb3ZlcyB0aGUg
c3BlY2lhbCBlYXJseS1zZWN0aW9uIGhhbmRsaW5nIGZyb20gcGZuX3ZhbGlkKCkgYW5kDQo+ID4+
ICAgZm9yX2VhY2hfdmFsaWRfcGZuKCkuDQo+ID4+DQo+ID4+IEkgYWxzbyBzaGFyZSB0aGUgY29u
Y2VybnMgcmFpc2VkIGJ5IFNhc2hpa28gaW4gdGhlIGFuYWx5c2lzIGJlbG93IFsxXToNCj4gPj4N
Cj4gPj4gICBTY2FubmVycyBsaWtlIGlzb2xhdGVfbWlncmF0ZXBhZ2VzX2Jsb2NrKCkgd2lsbCB0
aGVuIGJsaW5kbHkgaXRlcmF0ZQ0KPiB0aHJvdWdoDQo+ID4+ICAgdGhlIHBhZ2VibG9jayBhbmQg
YWNjZXNzIHRoZSBjb21wbGV0ZWx5IHVuaW5pdGlhbGl6ZWQgc3RydWN0IHBhZ2VzIG9mDQo+IHRo
ZSBob2xlLA0KPiA+PiAgIGxlYWRpbmcgdG8gZnVuY3Rpb25hbCBlcnJvcnMgb3Iga2VybmVsIHBh
bmljcyB3aGVuIHJlYWRpbmcgdGhlc2UNCj4gemVyby1maWxsZWQNCj4gPj4gICBzdHJ1Y3R1cmVz
IHZpYSBtYWNyb3MgbGlrZSBQYWdlSHVnZSgpIG9yIHBhZ2Vfem9uZSgpLg0KPiA+Pg0KPiA+PiBU
aGF0J3Mgd2h5IHdlIHdlbnQgd2l0aCB0aGUgY3VycmVudCBhcHByb2FjaCBpbiB2NiBpbnN0ZWFk
IG9mIHlvdXINCj4gPj4gZWFybGllciBzdWdnZXN0aW9uLiBJJ2QgcmVhbGx5IGFwcHJlY2lhdGUg
eW91ciBndWlkYW5jZSBvbiB3aGljaA0KPiA+PiBkaXJlY3Rpb24geW91IHRoaW5rIHdvdWxkIGJl
IG1vcmUgYXBwcm9wcmlhdGUuDQo+ID4gTGV0IG1lIHRha2UgYSBzdGFiIGF0IGp1c3QgaGF2aW5n
IHBmbl92YWxpZCgpIC8gZm9yX2VhY2hfdmFsaWRfcGZuKCkNCj4gcmVzcGVjdGluZw0KPiA+IHRo
ZSBzdWJzZWN0aW9uIG1hcC4NCj4gDQo+IC4uLiBhbmQgdGhhdCB0dXJucyBjb21wbGljYXRlZCB2
ZXJ5IHF1aWNrbHkuIFRoZSBwcm9ibGVtIGlzIHRoYXQgd2UgaGF2ZQ0KPiBzb21lIHVzZXJzLA0K
PiBpbiBwYXJ0aWN1bGFyIHRoZSBidWRkeSwgdGhhdCBqdXN0IGFzc3VtZXMgdGhhdCBNQVhfUEFH
RV9PUkRFUiByZWdpb25zIGFyZQ0KPiBmdWxseQ0KPiBhY2Nlc3NpYmxlLg0KPiANCj4gVGhlIGZ1
biBiZWdpbnMgb25jZSB3ZSBoYXZlIE1BWF9QQUdFX09SREVSIHNwYW4gbXVsdGlwbGUgc3Vic2Vj
dGlvbnMuIFNvDQo+IHdlJ2QgYWN0dWFsbHkNCj4gd2FudCB0byBpbml0aWFsaXplIHRoZSBtZW1t
YXAuDQo+IA0KPiBUaGUgcGZuX3ZhbGlkKCkgdnMuIHBmbl90b19vbmxpbmVfcGFnZSgpIGluY29u
c2lzdGVuY3kgaXMgcmVhbGx5IG5hc3R5IDooDQo+IA0KPiBJIG1lYW4sIGluIGluaXRfdW5hdmFp
bGFibGVfcmFuZ2UoKSB3ZSBjb3VsZCBhY3R1YWxseSBmaWd1cmUgb3V0IGZhaXJseQ0KPiBlYXNp
bHkNCj4gd2hldGhlciB3ZSBhcmUgZGVhbGluZyB3aXRoIGhvbGVzIHdoZXJlIHBmbl90b19vbmxp
bmVfcGFnZSgpIHdvdWxkDQo+IHN1Y2NlZWQuDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbW0vbW1faW5p
dC5jIGIvbW0vbW1faW5pdC5jDQo+IGluZGV4IGU5YzQyMDRiNzNhZGIuLjU0ZTcxZTE3ZjJjM2Mg
MTAwNjQ0DQo+IC0tLSBhL21tL21tX2luaXQuYw0KPiArKysgYi9tbS9tbV9pbml0LmMNCj4gQEAg
LTg0MywxMSArODQzLDEzIEBAIHN0YXRpYyB2b2lkIF9faW5pdCBpbml0X3VuYXZhaWxhYmxlX3Jh
bmdlKHVuc2lnbmVkDQo+IGxvbmcgc3BmbiwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgaW50IHpvbmUsIGludCBub2RlKQ0KPiAgew0KPiAgICAgICAgIHVuc2ln
bmVkIGxvbmcgcGZuOw0KPiAtICAgICAgIHU2NCBwZ2NudCA9IDA7DQo+ICsgICAgICAgdTY0IHBn
Y250ID0gMCwgb25saW5lX3BnY250ID0gMDsNCj4gDQo+ICAgICAgICAgZm9yX2VhY2hfdmFsaWRf
cGZuKHBmbiwgc3BmbiwgZXBmbikgew0KPiAgICAgICAgICAgICAgICAgX19pbml0X3NpbmdsZV9w
YWdlKHBmbl90b19wYWdlKHBmbiksIHBmbiwgem9uZSwgbm9kZSk7DQo+ICAgICAgICAgICAgICAg
ICBfX1NldFBhZ2VSZXNlcnZlZChwZm5fdG9fcGFnZShwZm4pKTsNCj4gKyAgICAgICAgICAgICAg
IGlmIChwZm5fdG9fb25saW5lX3BhZ2UocGZuKSkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
b25saW5lX3BnY250Kys7DQo+ICAgICAgICAgICAgICAgICBwZ2NudCsrOw0KPiAgICAgICAgIH0N
Cj4gDQo+IElmIGl0J3MgYSBwcm9ibGVtIHBlcmZvcm1hbmNlLXdpc2UsIHdlIGNhbiBhbHdheXMg
dHJ5IG9wdGltaXppbmcgYnkNCj4gc2tpcHBpbmcNCj4gY2hlY2tzIHdpdGhpbiB0aGUgc2FtZSAo
c3ViKXNlY3Rpb24uDQogDQpIaSBEYXZpZA0KDQpXaGF0IGFib3V0IHRoZSBmb2xsb3dpbmcgYXBw
cm9hY2ggdG8gc2tpcHBpbmcgdGhlIGNoZWNrIHdpdGhpbiB0aGUgc2FtZQ0KKHN1YilzZWN0aW9u
Pw0KDQpAQCAtODI3LDExICs4MjcsMjEgQEAgc3RhdGljIHZvaWQgX19pbml0IGluaXRfdW5hdmFp
bGFibGVfcmFuZ2UodW5zaWduZWQgbG9uZyBzcGZuLA0KICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgaW50IHpvbmUsIGludCBub2RlKQ0Kew0KICAgICAgICB1bnNpZ25l
ZCBsb25nIHBmbjsNCi0gICAgICAgdTY0IHBnY250ID0gMDsNCisgICAgICAgdTY0IHBnY250ID0g
MCwgb25saW5lX3BnY250ID0gMDsNCisgICAgICAgdW5zaWduZWQgbG9uZyBsYXN0X3N1YnNlY3Rp
b24gPSAtMTsNCisgICAgICAgYm9vbCBpc19vbmxpbmUgPSBmYWxzZTsNCg0KICAgICAgICBmb3Jf
ZWFjaF92YWxpZF9wZm4ocGZuLCBzcGZuLCBlcGZuKSB7DQorICAgICAgICAgICAgICAgdW5zaWdu
ZWQgbG9uZyBzdWJzZWN0aW9uID0gcGZuICYgUEFHRV9TVUJTRUNUSU9OX01BU0s7DQorDQogICAg
ICAgICAgICAgICAgX19pbml0X3NpbmdsZV9wYWdlKHBmbl90b19wYWdlKHBmbiksIHBmbiwgem9u
ZSwgbm9kZSk7DQogICAgICAgICAgICAgICAgX19TZXRQYWdlUmVzZXJ2ZWQocGZuX3RvX3BhZ2Uo
cGZuKSk7DQorICAgICAgICAgICAgICAgaWYgKHN1YnNlY3Rpb24gIT0gbGFzdF9zdWJzZWN0aW9u
KSB7DQorICAgICAgICAgICAgICAgICAgICAgICBpc19vbmxpbmUgPSAhIXBmbl90b19vbmxpbmVf
cGFnZShwZm4pOw0KKyAgICAgICAgICAgICAgICAgICAgICAgbGFzdF9zdWJzZWN0aW9uID0gc3Vi
c2VjdGlvbjsNCisgICAgICAgICAgICAgICB9DQorICAgICAgICAgICAgICAgaWYgKGlzX29ubGlu
ZSkNCisgICAgICAgICAgICAgICAgICAgICAgIG9ubGluZV9wZ2NudCsrOw0KICAgICAgICAgICAg
ICAgIHBnY250Kys7DQoNCklmIHRoaXMgbG9va3MgZ29vZCwgbGV0IG1lIHByZXBhcmUgYW5kIHNl
bmQgb3V0IHRoZSBuZXh0IHZlcnNpb24gc2VyaWVzLg0KDQpCZXN0IFJlZ2FyZHMsDQpMaXUsIFl1
YW4NCg0KPiAtLQ0KPiBDaGVlcnMsDQo+IA0KPiBEYXZpZA0K

