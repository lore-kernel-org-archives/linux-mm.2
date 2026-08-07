Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A0BC5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 12:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8043F6B009F; Fri,  7 Aug 2026 08:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5876B00A0; Fri,  7 Aug 2026 08:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6323C6B00AA; Fri,  7 Aug 2026 08:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 304C56B009F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 08:16:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD6E316023B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:15:59 +0000 (UTC)
X-FDA: 85074370038.01.8D3071D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 60ACA8000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:15:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jK4x1WWm;
	spf=pass (imf02.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786104956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCxMS0FRRzw9RUz1jEEQj41ODdhbRBjrDwr/SyBvriA=;
	b=IEdi6ZSQdKQUK6s38Tbuc1Wt4YPiJM9wOGMfhLm1CY8h00Put530yM6W8AtTQODg2cuqmr
	5C4p7Y5inWMhT+bXBlbO99wS1p6xDoTzRioGldDdfHpJh6TohDij8gSKt4q7bcZxlSdpy0
	WmzCXCicQx+IGMdA2zjuHKsEDYPnrCI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jK4x1WWm;
	spf=pass (imf02.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786104956;
	b=qEsM9Ehi18PwTYeX3arzUtWuPuJwa1feevW9KHg8YC5BrCweIpUaZ/3tExBCFjTSh3HhIB
	tykPNa1+x6plPlQHkATLFSjoxH+PKxUsiuOWkOtdyZh0cI3aNGyEef7O2xxGJi+oO/4jeg
	SHBxmIfu+zdsvpIDnAWm47az1cxe0WE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786104955; x=1817640955;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tCxMS0FRRzw9RUz1jEEQj41ODdhbRBjrDwr/SyBvriA=;
  b=jK4x1WWmdhaLb5UA2m3mqlHqDwdj925cf9OcrFPjyXma4+yVLm+8+6M6
   HJegIkarI7US4AasTu2mqf9I3t8M2Tju1T3qU1G2rB9b4kQfqR8pMwIPQ
   nfEFXD4UKP6TtwF+0CCpRecVVsZUhY2RgCFv4QrrFvIRg4Mr/lpwBnGoV
   iJ1Vl7IUJ8vaveJwV7T1LP5xQWDjCCSwKfakaL83rz9Ch0N0vZLGwQ+0I
   uVbczQM2uYGLcmzWRiLpm0IQbwr8973E/Qwatl7eQhNnDhbsq5qOmW0/a
   W6/GBMbVlMYjWeOjQfgybPEDvAFwLPSrz29FIbThula5RY0pAbmC6f5vD
   g==;
X-CSE-ConnectionGUID: xHedeMVqRDaPLPQQAXyYwQ==
X-CSE-MsgGUID: yGF/39hTRsezV5YHfgh8cg==
X-IronPort-AV: E=McAfee;i="6800,10657,11867"; a="97307129"
X-IronPort-AV: E=Sophos;i="6.25,210,1779174000"; 
   d="scan'208";a="97307129"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 05:15:54 -0700
X-CSE-ConnectionGUID: 9+yCmUfyT5eYxQKUHFIPnA==
X-CSE-MsgGUID: ELUuVMGgQHanRYkzJEK+Ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,210,1779174000"; 
   d="scan'208";a="300597575"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 05:15:54 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 7 Aug 2026 05:15:53 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 7 Aug 2026 05:15:53 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.26)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 7 Aug 2026 05:15:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HrRndBXAQ7QB72+gzMAJjHg49yrv6oU0ZPEr5A6QVVnv+d18VtDNcI87tZDdOrVNAZ/taPVeR0nwTDeF/LrlQYitZ/t2WC2jztpgA7TpXM/+idvXDE4Re52reqVCMvY9S0zxRVMM0DT0xAisG2riMmvHlt+vXU10vrvTy/W/+/av06Wf2vhXVIGqd1S2GOWxrPNImXYCZM2OOxQB6g/WfdZt6o0+1DNBtnx5WlfhdE4ifrMJ4viD2qGYrxr231EKu7CMflr8fK9Atj0Zb6TRm6JQSrjOK+taSbw4j8mvKPschPMYk23r/61EH0bg/RSgStQnlTrkx0KOYbEVtfIaPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tCxMS0FRRzw9RUz1jEEQj41ODdhbRBjrDwr/SyBvriA=;
 b=R7H1ePdDT9UMS+abj6CU4e6Fu9hL0HRChZHtr2vYk0IgSpm3JTg6Chi09IZfrKQmIZ2vmUM81RKIo1i+fXYlVZ69JHyRd20QG77zvhyqY8dLjUVqaVyDtPb2K3lUzoERcMLkGy3XcGngeTY/QtRfDP6bKpkUHZJZvHUnNHZ/V+Kpj55IhTLLEDvZcs3m6PIMNmPVYxKyWvzXBgoKXQqrf/DHcjnP7N3eZMQGPjDAYsyC0bjvCVe6CrdPfPOObILGAFdY4TxAucSYwlgiQOuFXv3Pnp1fhjzUoaZdwv3C2gHURnwvHtt5rCmlkvCAR3wjuahV6hGj14XzyIa2J1zo6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by PH3PPF2CAD058EC.namprd11.prod.outlook.com (2603:10b6:518:1::d12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 12:15:42 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.21.0292.022; Fri, 7 Aug 2026
 12:15:42 +0000
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
Thread-Index: AQHdGn+xVv6zTQASmkebGsn1WtDYrbaPbQmAgAFEj3CAABlOAIAAETHQgAGvAgCAAAi/UA==
Date: Fri, 7 Aug 2026 12:15:42 +0000
Message-ID: <MW4PR11MB69363CCE15647FD7D85542B6A3D12@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
 <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
 <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
 <2cbd42e1-b5bb-474c-b0e7-ce3f46541891@kernel.org>
 <MW4PR11MB6936594CC6B15968AAB781DCA3D22@MW4PR11MB6936.namprd11.prod.outlook.com>
 <0b02ef3e-363f-4b49-a208-54cdfea56c75@kernel.org>
In-Reply-To: <0b02ef3e-363f-4b49-a208-54cdfea56c75@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|PH3PPF2CAD058EC:EE_
x-ms-office365-filtering-correlation-id: 40ecb1c7-74ad-4984-3f2c-08def47d99e4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|38070700021|22082099003|18002099003|56012099006|4143699003|11063799006|5023799004|10067099003|6133799003;
x-microsoft-antispam-message-info: AyfRI5Vx2LSObfxNM35D0WiUv2J9PGJbIXl7pXUO2oo0yVplinUALVNv4Th6mXgztkHVNlgjeJ63k2o9fe61LtLC9tA93pePvRIxO16KzNqlEdr0jpcZigQH6cQBnXLdRuQ9Aln3mgcFiD0mUW6tr41DIWfop2xwTYHcqFRlwqAl7ATPBrcdO9R++h7CuvcbtzBqk5vFVpk6Ykr4i4jLGP19gbL/xQURZ+kGt6mVf+y6h75wtJqfDglTRrUm8TpXk3WwJJ1Yp7EUKuTx4By3mYU5QNY/H8MFdNkUv0e0BDZzimgprFSfV1B+pUcXpBjv7grVc4u+ym+1QwpK8ewdPriJMyuWh3Jo9zesyeSSTcr2jh+oMm1g11cBPHB6TqN0giIQQy3QgOXn5qY/0vICOSRfdcGgOQ7ZBbNEPanGtGji5s2066qld+4A6siqy9XBTMO2FgkBwnuFt5ZPFigENRWQkmi60c3lak74eDEHSEGWYsdBtITAa+01SQzf2uShcAMUsVPqUqx0ovYkpUA2Pzhund1/XQDALDtGjLs4qlU8nWwxLWkVufIxFNijVB0fMyx+XZYAqRP6L1Gcx9XjfSsUqmgEjlGlr6cvTadqiEr3bBloE2+WWDU/B8onuvBuRoXFTB3JnjeZMLRMAIaq7OTCUOSSo4byh3EYsfASp04=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(38070700021)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(5023799004)(10067099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjJzR1oyaWM3Q0dQdytwRnFhRzdRTkRDRG5BK1FINVpNSUcrZmtscmJyaHhX?=
 =?utf-8?B?Q0cyZWNWTkcvbjNoN1ROVjM1V3hzWDRCKzU1TWZWaHhHZWVFb0hiZDM0RENK?=
 =?utf-8?B?WGFFdldxRVovQlFTMThoL0lmbStrNkQxaTRNTW9pWmtFQ3puUTlzTktHd01R?=
 =?utf-8?B?VFEwZlhVS0hnSUY3NE0xeXJKZ0lQaUxjT1RWbTl3WTdPcGNQKzZsR1dZUWZI?=
 =?utf-8?B?ckdVSmZldXVyS1ZVWVcxKzhCNUwzSmFuR25kaUdZcklyaVFpRnphRmU5VFRF?=
 =?utf-8?B?NVpGNy9SK2hLendkZU03UTc3dWZJbndaVTVYWHVxTklDUVVZNk1uVzdNVEdZ?=
 =?utf-8?B?eXJ2R0p5NzZIdHA2UlNyaWFMRUQxMU1MV1NVZ29wMGNLWmYvS05Od25OY2dZ?=
 =?utf-8?B?citYeWdPc2doQXgwVmhMVVdNZzZ6dWFlY0I4WWpGY3d5cmtLU3E3VlY1NmRs?=
 =?utf-8?B?SThadE5mWUIrYUYyenZZNHMzdGprRXpRRUZvMHJNdzBqYkRTblhmd3F0YW5P?=
 =?utf-8?B?UUFHTjcvSWhCYXJDRGRva21ELzlvRWFIOG5HMFVjWlB0aExWcmxoa0c5UmZz?=
 =?utf-8?B?ZmRnS04rWEE2dmdKbUdKWm9HYnNLTGQ4QVVQREd2VER6SytHdEd2V2NBT1FX?=
 =?utf-8?B?S1RPQ2J5T2FJS2xldEk1dWttcVJNeVVSeEIzUDJiOStXM3hOY1ZoNFpubnR6?=
 =?utf-8?B?NCtYdEVpZVRhSGs3TERySGVCa05lK0lWbHg5VEVncGdkOHhPZk5DYm1pNDhS?=
 =?utf-8?B?N0ZLQmxKc0FPTFpYMWxPUk10SHpQV2VDUkZQQWNtVFVOVUxTTEx2R0FVUm5G?=
 =?utf-8?B?ODk5cmpjd0JrKzEyNW0yWDBFdG5IM2JVZjlpN20vbEhtYUk5QVV0eUR0YVlN?=
 =?utf-8?B?R2FvWlBsVUZ2aVpzdzd1Vk9rc2lOZWZ6TDFwcnlYZGNlZUpLOFpVbU51MklY?=
 =?utf-8?B?b0J4V2lsdFJORno3cGNiTHJZSXp4NWxIQU13MW00VTNzNDVicjlyOGowMS9D?=
 =?utf-8?B?SWpZaGR3M1VHVy9WYlZ4MldpVGcvdDNDMWdpTlAwL2xrSWFsaEI2T1ZUUU9r?=
 =?utf-8?B?ZnFYNU5ldk1EZDVNb2IwOFFnTVJUQnFJMFMxOGlib2hGamZ4eElYNUNaMzEz?=
 =?utf-8?B?NndxS2VUdVZvdk1nQ29ZUjgvTU0zUDBVZXdLd3JHOXBhRW9FdzNYNytrb2NR?=
 =?utf-8?B?Tzc1ellBZWEzdUVBSUNXTS9JMThoUjVzRi81K2hENnU1TEdGcTJ5ZEZGQkVM?=
 =?utf-8?B?eXVVelB5cVpHcHZnNkhlaHcweUMvVlYrTENHOWJzTlYyaWV0N0VIQTl5TUJL?=
 =?utf-8?B?TVBVSDZVNm0yWkJMYWF3NW1pRmhFWFNoUC9qQWE4dlpBQlFVanNIYmFDaW5a?=
 =?utf-8?B?MFlha1QvNzlUNjQ0Q1YyNjBBZjNxQW5LeW5qNkd4cEthc050SzBaMzdQbk1Y?=
 =?utf-8?B?KzgvSXJEeFdjSUgvOHhwWlBTK2FHNjJWc1dpME9WOXoyOGFjNWJDdzYzZm9w?=
 =?utf-8?B?UHlqTjNxR05oeWhpL3RYNVh6MVpvZHhVck93ZXdqODUrTi9TWENXN3Q5TWlx?=
 =?utf-8?B?eTRRUGxPTHIxTjgrQWtwRVQrOU1BWEJTbC93Z2psdTN5aDJPVlpKNnNndmZF?=
 =?utf-8?B?RTVBdUdKM2xmQTByYlpNZHczeGl1cVkyVGs5WEx1VGplUnArOFVLdkJOeVgy?=
 =?utf-8?B?cUovUC82TENlSDNxSWkxYXBDbG9rOWdFamJnUEFoUlNNK3R3RnVHQXVZUktC?=
 =?utf-8?B?aGRWWndLcGNxWmx6T2VIck9Sak0ydFFwQkpHbG5rUjBuc2lsQXloVU9IaGw3?=
 =?utf-8?B?ZWhiZ0pITUlydjZxWmRKMGUvVU9wQ1djMkUxS2h6TmZOenlQcngyOU1QQkt1?=
 =?utf-8?B?ejg2TzIvVjlPb0lmMUVLY245aW1WbjlYOFQ5enZ3VjhianZSMHF6RnZKR3E0?=
 =?utf-8?B?YUlqTzNlSGZFeUVXL3JlN2pmcFBNWHhyS3V4UHRicENQbmtMSmdEYXhpUk5l?=
 =?utf-8?B?WmhnUEg3RmVvWll4eDEweU5iTndGZEFWZi9DN1R5Nk4wUVk1RzBwKzV5MUs2?=
 =?utf-8?B?L0RCTmJvc1o5bkJIUy9kZm4xdjZWenJoMSsrQlRUYlNSbS9PRXRqMVZxVE9C?=
 =?utf-8?B?QTBKdHl2SGRKNm1rWVE4ckV4WVJPc09uc3NmUjR3b1Fsa0V3WUVKNkVJTUZl?=
 =?utf-8?B?a3R6MVBqWXMyYUpzYm41VTUvNmJZQVJlK29qU3k4N21nZXFTUlBrZnljRjU4?=
 =?utf-8?B?czF5OUF2SUhWbW0yTmtkNlRlMGlJZ0YxdFFYNFRXelpWVldIMVJBWlpPYkpY?=
 =?utf-8?Q?n9KEeLGcMqtX2kYiGW?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: m1vKrV0ypslzcLWrcpOqzPLtJ15ugFhe/oYfXVqCnPR9pX3+PjEDx2QOYgbfdIGFPuJDAy9w/Cp7zGNygnpGKfvPbETNy8Rt8BXtE61BfQklN17o9GIptMyGc/QYeN3zbzC2dDYIsWVolJnAA8EwnoCThv3hY4A0N/nClJzUH5eskWhWt3cxSLgi+KelHZJK12agQRHIVUdONywd9EHIFU5HB2Y+cVPpzpi/ZRXvVoNFHfkq9fThVpJ/88fD5VUt2Mij/z5LlawQE5vIWKodRXOLENgHYhMzhvrWgB2irw5cxhQYkm+FLcd4Qn6Z9x1e5TNgtqESkh1CqyQFuGax3A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ecb1c7-74ad-4984-3f2c-08def47d99e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2026 12:15:42.2950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D+WtdL8WXNPiAmZx2s8pksbRHk+Mvn57SyohlSwkdSZpRBW/GJjGMQnHJDcOqP0DKa7V2O4yB5WLUZ7+kcqMfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF2CAD058EC
X-OriginatorOrg: intel.com
X-Stat-Signature: z3qt45shk6aa1e8fphr77knwwa6hdfyk
X-Rspamd-Queue-Id: 60ACA8000F
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786104955-405607
X-HE-Meta: U2FsdGVkX1+dBS9iy8ohX9VRvrlUDcjXPb6Eoyd6nsg4qyaktuZuFXQfPK4m1sKrx884oh3Vx5qXryXH8Q5Vl3+I3Fx3tA0H5aR2o2AVE7NMQRW0aVrJ29kzuBE6+szP/Q8M3yCo+WYpHX6kj1Pv9HXLkLzpxVAYOBIl8uPpOP59DI6Qg3K2TqVxpx0PT2b6qUsVJejyQr87SO0PM5StM7snd6aKIX8QyrRh7WmeYnQ+24Wcg5pJ5MrtClmyNF/KcvvqCyLlo3RO6cYyJK2Jr7V3R/eSwXCx/2R2I+5bVIhKi21xULWYL8nbOLa61msYU6WTOwsXY9fr7xu2lMVDPNtKUe3juZcAR7jN4s6t8iViLHq/LNIzJqj4vW4hZE7QSaQK020/0/a/SayFRexCmNxCLNfb81zwxGQOJ1UHU5VGWMwiKwJx/EESgJG66S8uIgRtnC5SCUaB9B94Rv6DIrt9B7ZNlYxF37UcUOCfGngUom1oQDF/kR4dJGhc6ZfM3B/x6u5jX94cMdMq2A6nH4T/Wc9saK2PVPGBuX0FEjQS0yzTivLhGnAkjMIAiAqp8SzvJdQUsbIyldnvGEzNfMEGq1EjkOWpBIP+gJnsis1nTjakd02Fhsex9yTuiZ4PoEAHvZWL4RG/xzN4F7E5rngsEAL2jE+XLD6xjnZSmzp1ojDL19Pcfe87PG4UuHDAp/2aSQtc71ynEWttEVh0yJXEA6MkA0+IuCMylUiEUJCknv20ZV7wJWZQkU90cBbSkEVew0djPFXIexBrRPT55JN+237dkO6lFz8jxNJw0qMV02iL1EFny8CD1E5/wVrL5H5ZK4OXP/BretUcA7Bsyl6uZZfTcpwwLB4TK5hcN61+XxNmDfm90HWPvEQv2sJBBeedTOC2UWlqo5AOvuVPE3V1x+HpG1o++8EB9/Bk3/L2KbDdgebkCu00aDln0QA7xvR10OHtJd+rB1BFF9N
 Su5uq5uT
 wK/kecngtVdTr7U9nct9UeC/rUQzR+RoFmHuAqTbxWKHnp8//UcXj2VvSiNIv63BOirWDU0NyVbxulKiR1G4zay2Vzs9Q1MgwqnKcFsY0J+wtiQqDCrzI5tS7Sx5ZrTVquqEzT/b0Y6BFRS4NbFVSugmau0dFCFozhzB1F4f9/RjizQYLTPVAvTT8cbvZUtunWhYLpMcuYDdluRdsYBeDKb5me3NkNXwwwiqAGmbFieGkHCKAP7BQ35AkSGXyfsC0LqlQQxvp/rWoRLi5ik7ObzTe0lIJBVWx0XXK1a/N4PrRsJNpVVnH6W9/tDqKKF2UkzAggl+uxh7ux23fhkstmg28MvqzgX8jwGmze30FCXl1rRueoHeL6YApEUOTK1wq2usKCJh8aZP9jVFNUMdWZnSaFKKGSgYhv1vAmoPe9vFIJOgTiJp0azA++XvXjoRATRITCxHJAJkvdQIOt2VuQq/7a4aR6+cs8H5Y+XtQYntnue7c9t8NhsXdOvGrKv8wI4kK1RPRGfw8YB4yekXkfl4qk2fO1F1Duv7iyLDZhEc6XC4VFRNafexYZuzzE+Bgb5IPGOr+CZETsC20RtEb0gzg88tgq5v3J49+QvX3rhfCa7fIyCKMIb9IE6MGGHETF2gZFZ++CFEdIgEJWv1pdNJtT7twi+oYu34BoL6QSrFbxEgqufmgB4W/u7IDCTVqsh9TfSvSVXkMrktcuX4Yf/dH0AtPAweiX+U678Kbt3EZqvPQvHqzbkZZtGv21Fi8UKBdElED8tHibbcGwTGL7HAKYLfNh3UEMDOPsRH+ahm/4CdFm7AFVdkuP0sIJqpV25gwKcpbhuFGvU36tyEyO1P3zkRVRoAex2jM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogRnJpZGF5LCBBdWd1c3QgNywgMjAyNiA3
OjMwIFBNDQo+IFRvOiBMaXUsIFl1YW4xIDx5dWFuMS5saXVAaW50ZWwuY29tPjsgT3NjYXIgU2Fs
dmFkb3IgPG9zYWx2YWRvckBzdXNlLmRlPjsNCj4gTWlrZSBSYXBvcG9ydCA8cnBwdEBrZXJuZWwu
b3JnPjsgV2VpIFlhbmcgPHJpY2hhcmQud2VpeWFuZ0BnbWFpbC5jb20+DQo+IENjOiBsaW51eC1t
bUBrdmFjay5vcmc7IFpvdSwgTmFuaGFpIDxuYW5oYWkuem91QGludGVsLmNvbT47IERlbmcsIFBh
bg0KPiA8cGFuLmRlbmdAaW50ZWwuY29tPjsgTGksIFRpYW55b3UgPHRpYW55b3UubGlAaW50ZWwu
Y29tPjsgQ2hlbiBaaGFuZw0KPiA8emhhbmdjaGVuLmtpZGRAamQuY29tPjsgWmVuZywgSmFzb24g
PGphc29uLnplbmdAaW50ZWwuY29tPjsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcN
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NiAxLzJdIG1tL21lbW9yeV9ob3RwbHVnOiBvcHRpbWl6
ZSB6b25lIGNvbnRpZ3VvdXMNCj4gY2hlY2sgd2hlbiBjaGFuZ2luZyBwZm4gcmFuZ2UNCj4gDQo+
IE9uIDgvNi8yNiAxMTo1MiwgTGl1LCBZdWFuMSB3cm90ZToNCj4gPj4gLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCj4gPj4gRnJvbTogRGF2aWQgSGlsZGVuYnJhbmQgKEFybSkgPGRhdmlkQGtl
cm5lbC5vcmc+DQo+ID4+IFNlbnQ6IFRodXJzZGF5LCBBdWd1c3QgNiwgMjAyNiA0OjQ2IFBNDQo+
ID4+IFRvOiBMaXUsIFl1YW4xIDx5dWFuMS5saXVAaW50ZWwuY29tPjsgT3NjYXIgU2FsdmFkb3IN
Cj4gPG9zYWx2YWRvckBzdXNlLmRlPjsNCj4gPj4gTWlrZSBSYXBvcG9ydCA8cnBwdEBrZXJuZWwu
b3JnPjsgV2VpIFlhbmcgPHJpY2hhcmQud2VpeWFuZ0BnbWFpbC5jb20+DQo+ID4+IENjOiBsaW51
eC1tbUBrdmFjay5vcmc7IFpvdSwgTmFuaGFpIDxuYW5oYWkuem91QGludGVsLmNvbT47IERlbmcs
IFBhbg0KPiA+PiA8cGFuLmRlbmdAaW50ZWwuY29tPjsgTGksIFRpYW55b3UgPHRpYW55b3UubGlA
aW50ZWwuY29tPjsgQ2hlbiBaaGFuZw0KPiA+PiA8emhhbmdjaGVuLmtpZGRAamQuY29tPjsgWmVu
ZywgSmFzb24gPGphc29uLnplbmdAaW50ZWwuY29tPjsgbGludXgtDQo+ID4+IGtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NiAxLzJdIG1tL21lbW9yeV9o
b3RwbHVnOiBvcHRpbWl6ZSB6b25lIGNvbnRpZ3VvdXMNCj4gPj4gY2hlY2sgd2hlbiBjaGFuZ2lu
ZyBwZm4gcmFuZ2UNCj4gPj4NCj4gPj4NCj4gPj4+DQo+ID4+PiBXaWxsIGRvLg0KPiA+Pj4NCj4g
Pj4+DQo+ID4+PiBwYWdlc193aXRoX29ubGluZV9tZW1tYXAgY291bnRzIGFsbCBQRk5zIHdoZXJl
IHBmbl90b19vbmxpbmVfcGFnZSgpIGlzDQo+ID4+PiB2YWxpZC4gV2l0aCBDT05GSUdfU1BBUlNF
TUVNX1ZNRU1NQVAsIHBmbl9zZWN0aW9uX3ZhbGlkKCkgb3BlcmF0ZXMgYXQNCj4gPj4+IFBBR0VT
X1BFUl9TVUJTRUNUSU9OIGdyYW51bGFyaXR5IOKAlCB3aGVuIGFueSBwYWdlIGluIGEgc3Vic2Vj
dGlvbiBoYXMNCj4gPj4+IG1lbW9yeSwgdGhlIGVudGlyZSBzdWJzZWN0aW9uIGlzIHZhbGlkL29u
bGluZS4gU28gd2UgYWxpZ24gdG8NCj4gc3Vic2VjdGlvbg0KPiA+Pj4gYm91bmRhcmllcyB0byBp
bmNsdWRlIGhvbGUgcGFnZXMgd2l0aGluIHBhcnRpYWxseS1wb3B1bGF0ZWQNCj4gc3Vic2VjdGlv
bnMuDQo+ID4+DQo+ID4+IEJ1dCB3ZSBtdXN0IG5ldmVyIGFjY291bnQgZXhjZWVkaW5nIHRoZSB6
b25lIHJhbmdlLiBTbyBJIGRvbid0DQo+IHVuZGVyc3RhbmQNCj4gPj4gd2h5IHdlDQo+ID4+IHdv
dWxkIGhhdmUgdG8gY2FyZSBhYm91dCBQQUdFU19QRVJfU1VCU0VDVElPTiBoZXJlIGF0IGFsbD8N
Cj4gPg0KPiA+IFdlIG5ldmVyIGFjY291bnQgYmV5b25kIHRoZSB6b25lIHJhbmdlLCBiZWNhdXNl
IGBzdWJfc3RhcnRgIGFuZA0KPiA+IGBzdWJfZW5kYCBhcmUgc3RpbGwgY2xhbXBlZCB0byB0aGUg
em9uZSBib3VuZGFyaWVzIGFmdGVyIHRoZQ0KPiA+IGFsaWdubWVudC4NCj4gPg0KPiA+IFRoZSBz
dWJzZWN0aW9uIGFsaWdubWVudCBpcyBuZWVkZWQgZm9yIGhvbGUgUEZOcyBiZXR3ZWVuIG1lbWJs
b2Nrcw0KPiA+IHdpdGhpbiB0aGUgem9uZS4gVGhlc2UgaG9sZSBQRk5zIGFyZSB2YWxpZCBmb3IN
Cj4gPiBgcGZuX3RvX29ubGluZV9wYWdlKClgLCBiZWNhdXNlIHRoZXkgc2l0IGluIGEgc3Vic2Vj
dGlvbiB0aGF0IGhhcw0KPiA+IG1lbW9yeSwgc28gdGhlIHdob2xlIHN1YnNlY3Rpb24ncyBtZW1t
YXAgaXMgb25saW5lLg0KPiA+DQo+ID4gfC0tLS0tLS0tLS0tIHpvbmUgcmFuZ2UgLS0tLS0tLS0t
LS18DQo+ID4NCj4gPiArLS0tLS0tLS0tLS0rLS0tLS0tLS0tKy0tLS0tLS0tLS0tLSsNCj4gPiAr
IG1lbWJsb2NrIDF8ICBob2xlICAgfCBtZW1ibG9jayAyIHwNCj4gPiArLS0tLS0tLS0tLS0rLS0t
LS0tLS0tKy0tLS0tLS0tLS0tLSsNCj4gPiAgICAgICAgICAgICAgICBeDQo+ID4gICAgICAgICAg
ICAgICAgfA0KPiA+ICAgICAgICAgICAgICAgIHwNCj4gPiAgICAgIHN1YnNlY3Rpb24gYm91bmRh
cnkNCj4gDQo+IFJpZ2h0LCBidXQgaW5pdF91bmF2YWlsYWJsZV9yYW5nZSgpIGNhbiBqdXN0IHJl
dHVybiBob3cgbWFueSB3ZXJlIGFjdHVhbGx5DQo+IGluaXRhbGl6ZWQ/IFdoeSBjYW4ndCB3ZSBw
aWdneS1iYWNrIG9uIHRoYXQ/DQo+IA0KPiBJIHRoaW5rIHdlIGhhZCBzb21ldGhpbmcgc2ltaWxh
ciBwcmV2aW91c2x5LCB3aHkgY2FuJ3Qgd2UgdXNlIHRoYXQ/DQo+IA0KPiBXZSBrbm93IHRoZSB6
b25lIHNwYW4sIHNvIHdlIGNhbiBqdXN0IGFjY291bnQgYWxsIHRoZSBtbWFwIGluIHRoZSB6b25l
DQo+IHNwYW4NCj4gdGhhdCB3ZSBpbml0aWFsaXplLg0KPiANCj4gV2hhdCBpcyB0aGUgcHJvYmxl
bSB3aXRoIHRoYXQ/DQoNCkhpIERhdmlkDQoNCk15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCBpbml0
X3VuYXZhaWxhYmxlX3JhbmdlKCkgaW5pdGlhbGl6ZXMgYWxsDQpQRk5zIHRoYXQgc2F0aXNmeSBw
Zm5fdmFsaWQoKSwgYnV0IG5vdCBhbGwgb2YgdGhlbSBzYXRpc2Z5DQpwZm5fdG9fb25saW5lX3Bh
Z2UoKSwgc2luY2Ugc29tZSBQRk5zIGJlbG9uZyB0byBzdWJzZWN0aW9ucyB0aGF0IGFyZQ0Kbm90
IG9ubGluZS4NCg0KWW91IHByZXZpb3VzbHkgbWVudGlvbmVkOg0KDQogIHBmbl92YWxpZCgpIHNh
eXMgZWFybHkgc2VjdGlvbnMgYWx3YXlzIGhhdmUgYSBmdWxsIG1lbW1hcCwgc28gZXZlbiBpbnZh
bGlkDQogIHN1YnNlY3Rpb25zIGhhdmUgYSBtZW1tYXAuIHBmbl90b19vbmxpbmVfcGFnZSgpIHNh
eXMgYW4gaW52YWxpZCBzdWJzZWN0aW9uDQogIGNhbm5vdCBiZSBvbmxpbmUgYW5kIGl0cyBjb250
ZW50IG11c3QgYmUgc3RhbGUuIGZvcl9lYWNoX3ZhbGlkX3BmbigpIGZvbGxvd3MNCiAgcGZuX3Zh
bGlkKCkgc2VtYW50aWNzLCBhbmQgd2UgdXNlIGl0IHRvIGluaXRpYWxpemUgbWVtbWFwIHRoYXQg
aXMgbm90IGdvaW5nDQogIHRvIGJlIG9ubGluZSBhbmQgYWNjb3VudCBpdCBhcyBwYWdlc193aXRo
X29ubGluZV9tZW1tYXAsIHdoaWNoIGlzIHdyb25nLg0KDQogIFRoZSBjbGVhbmVzdCBhcHByb2Fj
aCBpcyB0byBhdm9pZCBhbGxvY2F0aW5nIG1lbW1hcCBmb3Igc3Vic2VjdGlvbnMsIHdoaWNoDQog
IGFsc28gcmVtb3ZlcyB0aGUgc3BlY2lhbCBlYXJseS1zZWN0aW9uIGhhbmRsaW5nIGZyb20gcGZu
X3ZhbGlkKCkgYW5kDQogIGZvcl9lYWNoX3ZhbGlkX3BmbigpLg0KDQpJIGFsc28gc2hhcmUgdGhl
IGNvbmNlcm5zIHJhaXNlZCBieSBTYXNoaWtvIGluIHRoZSBhbmFseXNpcyBiZWxvdyBbMV06DQoN
CiAgU2Nhbm5lcnMgbGlrZSBpc29sYXRlX21pZ3JhdGVwYWdlc19ibG9jaygpIHdpbGwgdGhlbiBi
bGluZGx5IGl0ZXJhdGUgdGhyb3VnaA0KICB0aGUgcGFnZWJsb2NrIGFuZCBhY2Nlc3MgdGhlIGNv
bXBsZXRlbHkgdW5pbml0aWFsaXplZCBzdHJ1Y3QgcGFnZXMgb2YgdGhlIGhvbGUsDQogIGxlYWRp
bmcgdG8gZnVuY3Rpb25hbCBlcnJvcnMgb3Iga2VybmVsIHBhbmljcyB3aGVuIHJlYWRpbmcgdGhl
c2UgemVyby1maWxsZWQNCiAgc3RydWN0dXJlcyB2aWEgbWFjcm9zIGxpa2UgUGFnZUh1Z2UoKSBv
ciBwYWdlX3pvbmUoKS4NCg0KVGhhdCdzIHdoeSB3ZSB3ZW50IHdpdGggdGhlIGN1cnJlbnQgYXBw
cm9hY2ggaW4gdjYgaW5zdGVhZCBvZiB5b3VyDQplYXJsaWVyIHN1Z2dlc3Rpb24uIEknZCByZWFs
bHkgYXBwcmVjaWF0ZSB5b3VyIGd1aWRhbmNlIG9uIHdoaWNoDQpkaXJlY3Rpb24geW91IHRoaW5r
IHdvdWxkIGJlIG1vcmUgYXBwcm9wcmlhdGUuDQoNClsxXSBodHRwczovL3Nhc2hpa28uZGV2LyMv
cGF0Y2hzZXQvMjAyNjA1MjAwOTM0NTcuMzcxOTk2MC0xLXl1YW4xLmxpdSU0MGludGVsLmNvbQ0K
DQpCZXN0IFJlZ2FyZHMsDQpMaXUsIFl1YW4NCg0KPiBDaGVlcnMsDQo+IA0KPiBEYXZpZA0K

