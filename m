Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F67FFCC04D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 910AD6B00B0; Fri,  6 Mar 2026 12:38:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1FD6B00B2; Fri,  6 Mar 2026 12:38:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C5A6B00B3; Fri,  6 Mar 2026 12:38:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 61AF36B00B0
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:38:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20B2CC2513
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:38:14 +0000 (UTC)
X-FDA: 84516346908.02.0EBA5C3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf28.hostedemail.com (Postfix) with ESMTP id B5EF1C0003
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:38:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nWOQVbC6;
	spf=pass (imf28.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772818690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0JD6SphR/RoGHaq/7rwHOnOARnDf9db/adrSC6s8yGQ=;
	b=IoeiaLdcvmXNG/lLfDcizyZ3HOzGv270QLfoEmixea1p5LSvuIr2ziX2QQAWRCY5ZHaVfP
	aD9H+XoAzmnBLoU6/+EBc/v6IYcf7JDLSCVuaMaHgYkPkMsRCuUJiDifnHO3I4KaP7Jdy2
	Cx7mGZIk9GEflFFDttY2ZwyzhnZpHig=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772818690; a=rsa-sha256;
	cv=pass;
	b=zgbw+50CI3uh0d/rKEr6yFIeye5nJ1qSJ5KXoCGbyd6HtmmbR3eui6/WF0qVhjpa8F465y
	dIhhodbaZl72FOGynIGPCbJteZtYjLgYDLaF4MIkUdUiEBEUrTUp1LdEPHBKanQvXjMUuN
	ZX+bdse+/t88uwVm7bNOlBQpvrFJHs8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nWOQVbC6;
	spf=pass (imf28.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772818688; x=1804354688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0JD6SphR/RoGHaq/7rwHOnOARnDf9db/adrSC6s8yGQ=;
  b=nWOQVbC6f96+kQm0PHFLSxkKoMp/a0J3HxJ5ItmUlj4pqZBD5Sz5LiYI
   Nsf2o5Yw/6rt7mFiCA7EuQq3+eoiQW4L8fxEe7hmY628UKHXyfnwwCN4R
   vy/RSfwMstppSVk3Zn2obMTvdWyZ3CGiOANvZH7BqQJiTmHkJ7cioTYK+
   64SUQUZrTKYC+odPk8/LV0u4lq9XnM35bdaWRi4ZU0YRd3QnH1/AusE0R
   eMcpCO12DmdJihCONyQu/LQkZciJ0rs30v0bBN6u74E8Uy+13QEeBgGNp
   Jz68V5kD1Arml/E/Ukhd94p0j61LzMaySMISyINseRvsYow4+14LzdH1a
   w==;
X-CSE-ConnectionGUID: RAb4R96zQIyb5xKL5CyHLA==
X-CSE-MsgGUID: vptjiBiYQbyuv5jstj1ihA==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="73632477"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="73632477"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 09:38:07 -0800
X-CSE-ConnectionGUID: 57spJpMUTBaSMH/M/hf+TA==
X-CSE-MsgGUID: x6M6ZoJhRgqvSEHQAS7NfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="223192793"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 09:38:06 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 09:38:05 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 09:38:05 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.50) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 09:38:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SpZqWl7CB51w7g+p1ElFm+5Vz1leAi2yQExx2NV+kmqMqkh49r1Zud6ADpMaLF7oO1CLRFxH7M7tiJD5kPPp+Gy62V2chWIj32LIZXZz22boFvyQ501VWHnTvGuGoN8Hcz8MVp5DmLO4mKTosMBEXglu7CGm7zblHlzV1Mv9NjLxPYGG5Q8YcbGZcW2Rd868fBJ8gAGTavSU8FLBcSISoiEUFhz7WIlxYYxv4Qq49uaFjOryTKC1pP0Bopue5qwYjGuar908KjKF81EaPhxwnxNK1c72xzK74O0hpI2TnsXLwhkbZbMY+dwewvNADzteeIAw2EfWeEUHf67TS8/Siw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0JD6SphR/RoGHaq/7rwHOnOARnDf9db/adrSC6s8yGQ=;
 b=QuowpeF0+qrqIUtip00n713S+c9rQAD3CjHC4AVDNdlLK5S71dfrbSqt0+zqYCxImt63YNb3OXVG2SSy1/bdVZZF3FzxGv4Dn6JQzC/QG7bkuCYbDXZkxtNMJ9j6rulEvMQFpn2Sgj49bmF/+nlATKUiL6S+QjL8LL/abA8tLcuNcNhZWJ1RC4HFeSe3HaMVGVefKAt1TaO8ZSzXODbph5M2Kj0LK54LpTjHAy+jyPtvr76zzn5x1S74YiFUBzMOrPXG7XcLqeRrzBa8Adn3IwEl/qF7wcTB7gbsX0xEAK0fSZgmqx/RjhBQAed5/BGtgw0yAQykqHLEhDwEWpw6GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV3PR11MB8741.namprd11.prod.outlook.com (2603:10b6:408:21d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.6; Fri, 6 Mar
 2026 17:38:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9678.017; Fri, 6 Mar 2026
 17:38:01 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jackmanb@google.com" <jackmanb@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"david@kernel.org" <david@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"weixugc@google.com" <weixugc@google.com>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"ziy@nvidia.com" <ziy@nvidia.com>
CC: "kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, "rppt@kernel.org"
	<rppt@kernel.org>, "luto@kernel.org" <luto@kernel.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"reijiw@google.com" <reijiw@google.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>,
	"sumit.garg@oss.qualcomm.com" <sumit.garg@oss.qualcomm.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"rientjes@google.com" <rientjes@google.com>, "derkling@google.com"
	<derkling@google.com>, "david.kaplan@amd.com" <david.kaplan@amd.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH RFC 00/19] mm: Add __GFP_UNMAPPED
Thread-Topic: [PATCH RFC 00/19] mm: Add __GFP_UNMAPPED
Thread-Index: AQHcrY/2iPIp5hmehECbibh1f3IMeQ==
Date: Fri, 6 Mar 2026 17:38:01 +0000
Message-ID: <5d22bf8810fc18c326e1b12c90994a72f74916a7.camel@intel.com>
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV3PR11MB8741:EE_
x-ms-office365-filtering-correlation-id: 75663545-d03b-41b5-a8c4-08de7ba71d1d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021|921020;
x-microsoft-antispam-message-info: bvhT+PfK/5XKp739o1EXL1kwfdU/kvIhCIRY51+ISKCk/KQMnl33YlylwotDKRGskcPfZPVLvXbfO5wr1vz9tZL7BjGyHJ0pr+3/sPYA//xG0rwBLsCMT9W+JJX4Fpv5Jqvk6KuKNUPcduUWt33MzJJoae+33sEDS6nNHj9ptIVPCjLzZjBVAxKc+K0XSpBAS69IfbQ/5TfQGBbZjMCiDuLxbc9qAwyFxXpM1ZIYgUs0cVTIeT7Grk4BOMzU6pmjpkigp3McBBQCPQJdUciACqxLezfFeVvCqvJweA7JXnba7PSIp3CPuNQ7854IoOBhv42n3sYD5aw5Zx6QF2FvXwsWTCpnC1gFfvmbs41LQSSBNRpZVwy0kXtC589dC+i4jRZusIUGzOyUhe/lhzZbQn6mWRiKefazstxQ23JbIwvHAw267M8wMkO/TWrwuORZSJUyVhzqbpjlLPisoPfzjzWJPNeYNnVjVntPehjp7YzfWD+OWWpK7rtVKK52b3wEWDABpZl1/szLoO6+9ape1G9A3QoT4fpgw5DLCIld3thfts/SzdRlhk5ZoPaccQyVfl0GJSXP/Ojh08zI4+OiOpiK8ECMdl8AbJErzOZ1xjbJAKCplpehyJ1Zk8FuPwHI9L+i9+WA7izNaByGA1q+mVVWmdA5ic6HPENjbfvQ/yyZq0WohIcbLEvQ1etLrOU/z8MT2BSP2aYPKwolaLKA4mifEU98H9mHhSzrJbfdmfmYr7ZohjCaOBYprBxcYmhhi9OO8dy1hK+L0yrE7IveG1fUoyV3nENZa5f/Aia4GCEoIiyTxHw+Dhj78b1EGA0E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnpXV1pYRUZJeEo5MnlqTWl5UTZKbm5hRXJ3TU5vVlUyQ1dqTlZwZTJHWits?=
 =?utf-8?B?b0xwME5ycGRzN2hBSk9BRHNMUHZ3Y3lhazMvZVRBczRQYWx4N3hVYWtOOUUz?=
 =?utf-8?B?ell3T2NiSEtrbk4ralBlcGg4blJ6S3drdU9FYjJGUmtEcjQwazd3Y0x2MUVh?=
 =?utf-8?B?Sm04VnFZKzNXMFFpdVdTUTg4eUpPVW1qR2VZZ0V3Y1lId3hybmJScndxM2VZ?=
 =?utf-8?B?Um9kZEVNdlZsRVVjc2FMTFk2S1JLNWtMcFNWbnEvVTgzci9zRTRnZkQ4YjlF?=
 =?utf-8?B?SDlmdDNJZThYQmh4ZGJGYXFRUC9DR1l4RHZWeHg3aEx0OGFaYkVTOWRuNU1M?=
 =?utf-8?B?OHF0bFo3M1lhc1h4Z2dBa3ZpSGMybUxVVUhKT0lJaWxtS2l1K2hORGZBM25P?=
 =?utf-8?B?bWZPNVA3eVNGR2NhU0xiVC90UWhwMUFtS2VUYTVWc3hzRVMySjJHRGI1YVJF?=
 =?utf-8?B?RU8xV1I0S1NHRnltbGF1MVEwOVducWEyb3hjSTJjcXEycHdYVFFaTmhOSXhU?=
 =?utf-8?B?RWZEcVk2K0RKc0J3Z29wNEVDZzVGSnhLQ3RoMVNPMFMvTmw0NlU0UE5ZN1Fp?=
 =?utf-8?B?SVlMcml2RjJ1RDNIbUZRVzRkbkZ6MXpVR3FabTJ2YXdhWWFlVkp6dDVEMWpP?=
 =?utf-8?B?YzlYbDJ2NFBBQnMxSkY0c1ZTYXRYN0IxY0s3LzN4OTJFTFk3dGtKaWU2UlM3?=
 =?utf-8?B?eW1IRUxERThGbVVnU0VwZFNsNkZ0ZWtFeHBCMzBBTTRWazJTcEhyOTJmeXdS?=
 =?utf-8?B?RU1yWlJaT244RG5VT1c4ZWtucUpUSldwNkJvQnJ1aTlWNGNSOXIyQWNTS3JE?=
 =?utf-8?B?QVdlQzVZUzZia1VvcFNTMSs5NlBhS3RTN2R0OWF1QXMwTEhvTEFIa3UxNng4?=
 =?utf-8?B?bFBwbE9VOGJvNGFlQ3c5NXJYRGNneDJoSURhU3dYQktLT2IvOEJQSXpJOEJC?=
 =?utf-8?B?MTdZRVN1OWVBTFlyQmZJZDgyb282eVpJNEo2TDVyVmNwSHgraFVKK0xrZUE4?=
 =?utf-8?B?SGdvaU91UjJpbzFwcW05Mnd4YUxTRzQ4UVZpUGtZbHlXRlhidXNWcEhTYWVW?=
 =?utf-8?B?alJ2NEVJR0wrUmViSTJTaWxITDZiMTNnOGhySGNlY2NPc0ZUK2puSVM1b3Rr?=
 =?utf-8?B?TUFWakY4UWNwOVBPZU1YOVFiTTZxM29SUis4cytyZDZlWWxaMlVwREpIRGph?=
 =?utf-8?B?anlDYS91QTZwVU9lbjFmMzc2ckRVcU5wYmZkejExeS9hdEdRdk9HVVVFazli?=
 =?utf-8?B?bHNKdXF4WjdHcEJCcXplTjZ1d3M3TVJhRloyWTk1Wkw5ZURSbXp5cURtRTNQ?=
 =?utf-8?B?MllhOVZsQmZKN1J5eGRyYXppL295RzU2VEJJYnVhRUpZdEcvdFE1ZWFDUTZP?=
 =?utf-8?B?Yi9NUHE1VHdOeDZxdHR5NkczMFJCMVJhKzc5VXdNT2YvdHVoUFNBWStFeE92?=
 =?utf-8?B?S2JjQmNsV0lueFdvZXExUUdOZm9lcnh6aFVTN3dGYWZTOXNJUFBIQjMrUCtN?=
 =?utf-8?B?ekdKZ1V1SDNZT3NETkVDdEVXaDVHL05jUUkvZlJ1WnROR3F5d3A1cHhvL1JM?=
 =?utf-8?B?bmdrU2t4RWxOVUxtamRPQWM2ZzU4R0NoUytSSFk1dmtRQ2UrRG1maWIyaVdK?=
 =?utf-8?B?TURUUnZqR21XV0FNajg2SXQwUUxOeTZYSDFvNlJIcVVTRmlLUUh0MWlNSko2?=
 =?utf-8?B?VGx5eG9qRlpqeEZVYTZjUFZQTitwWmYwMDZsVis0aEUzOFRacTBPZTZoeEZM?=
 =?utf-8?B?SzNDTjR6VWUycDVIVm8vNTdBK1I1QjIyNmlBYlExdWNEd281SVlKNWl6T1h1?=
 =?utf-8?B?Y2JHZ0ZPL25iVzRIUmpxL0U4Ym5Rbkx4WXRJM0dlcVNVQ3dKMVhaRllmRUha?=
 =?utf-8?B?NmY5QmhtOEQ0QVNhTVhid3o0K3lveE5MelNOTzR3NjNLL1ZCY2Y1UERxZ1FD?=
 =?utf-8?B?bktGOFRCYzhkRmUvU1lDS1dKbk9sbkZlcWZHajczeFNBdUZyQVVTcU03OW1X?=
 =?utf-8?B?aXdvZWtpaGhwbU53T0dHSm5Tb0hyUDg1VFlDWUNJZ01tWWtkcVdlbUtPdEUz?=
 =?utf-8?B?bmUwNmFMclRqYTltdmtmM2dic3RVR01jdkp6dlFCWmpNaFNvd2w5VlRJc3c1?=
 =?utf-8?B?TVcyUUJZWW9VTWJ0NmY0TllOZ0Y0VS9zWUI2NjVhblRvd09UOXRSUWRDc28y?=
 =?utf-8?B?U1c3Wm50ODJDNnRNTVAwWXNQc2tudXp1UjZsMm5weUNaRERCckdoc3djbzFE?=
 =?utf-8?B?MUlCeVRqajhLUFpUNGtXNnVQaUR6c3hrb1V0T0JpVjhYcTNwNVJkQTU5SktK?=
 =?utf-8?B?ejNtUkY5R1FCcVhBZklIL2ptR3N5SVpnV0haYW1YYmc5Z0Q1aE91MllQVGlO?=
 =?utf-8?Q?8j1G4D6Dq9LW23Ug=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BA68A3577E5994BBC268F284802A918@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Viw0CHAzOlACxWCflbb27KlU/BbggCchxrpWCz6myezMTeci1lWEL39UPeKpi4PIuJ9fIsiW3/fYjtRErsirHT9ffIBsWFYPuTujYFf2/cEx+bSif1thB2AF9Mqb45OueetGSbww2dfOt9umZWlCaZVCeF1hJ6wcr2SgvLGGe0H9dNbhAm8A1PY6xpiETfuUYHn1kepHQSt6uB7o1XgnFzzb2b72iF+egv+SJwHhNqMm2mLKmoJfowAHlPBApuV3fj3LU698DMypcRgiUvwA/7cgyi4+zZ2IhvftoUd971VJlKH8pTfeQKkCdb2p+EZWYoziHjKuJdvGDu5JY1aVEw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75663545-d03b-41b5-a8c4-08de7ba71d1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2026 17:38:01.1163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5oWYFGvzEZ3DCDC7LesSV5LI3G0Z5mNkAOOvR6dPMdCBzuukZM8T6q0CZVZ5CC0Zb24LrLmiLQuPnPOvFOiDeqA3hLAaJUIpuabsYD0qfew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8741
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B5EF1C0003
X-Stat-Signature: txycqaj9otjuuyfx7onw4cnosgykuzik
X-Rspam-User: 
X-HE-Tag: 1772818687-29415
X-HE-Meta: U2FsdGVkX18Jo3XAQ/Co1p1iOp17KONasKMEQfmuYRJUBQUcg4xxxuyQ8Vy276ptayRfVZ6mWV4zZXVC5JmXh3ymEvnGQB0S6l+lSiSnkmMU8rcFZsUbngccwzB6IOMD8ZfiF7B9O3EeD7Q3IRKwILutZszKYN4RB4E5eiNk3CAWY5+F3ZVOlDx8bsTH+VRGqSv3RfxLasmCYHw11UyHdnlZ/HQZKpCmOULaM607OxqdKGfW4DLclFJ0UEwNVVrFVc3sfBdw4kxN3ACg2M7LNKG69lYJRAFeNLbJcZLmeq/VpYKAnIxZnjmK1lYDUFokK2tiaWm/bI+5bGx0aksPTo4blMeahrA4uOc1Ev5dcP7E7FHk/orbHmMJ8uo8iXfjvBZawyWEUUq0ThC5GKqguVtG2Snrj9uqDc+36bqs9Nq/5EpCe5FFMCaKIxvAJmuy0DWWZlE0bKIMUuAADYKL6Pcx3a78IOtHeRrqGfZ0i7DGo+M34DRIWWOV9hxR9itX1OqMbkTWF/06JE2jj8Yfs7Y9Bk5s+sFZYaD6u5Addcv/yOYhCqE6Tcn+JKYr/No43XfLw7skJVbHapWpmZWYYBSystpBmK25EQzjq2pKuw4a3t8LnazczM0JWeB3yroL58nYnEJK5XH5zvnhtM3Rx+VvMs9UY5gAOI4QBW/kesUs3I0DoNl0TqF4AikdXBbmBte6VP+TxY8JLp7BemDY2FtcYVEYO32UU2sIv3ZoiKB8BX+oK0cBjvQufvpP3u7Ci7E2F+25R/dRWJ+L4lSvSxbFrYa3NTFAULP8/66xvvgHBUCHlY+i/ZwggeB6jyL2Ori+zWH8UlD0lVKjcqUP/9LXZv+82t/VDI+cFroxvYFWzoGi1grCaMb+nOqDzNFSeJq6YfjoKoxHX52QJcmI51EEDSHDtUlNT7HfN77WX/dJmAHMegWbptMZ3DzVxBmQUEPzSS39vtHHGoT6EZq
 y+44m/3X
 gwJeebWZm7BjIFAnhlWkuKe/c+qDx4WccAlXid3HGRRPWUXEkLWbh1mDkCw91J+Zz4QAy/tzFiUS7g6DX6wmZWSpLwLZuDEaOYwWvjD1HHuy1StO4Nm+xeFJbCik9S5VgUfwUCPkX3Z+wOZM9mHUFwCYnW6kQ72ZV/5f+Bf/Tu4bwW0Hc9gMjP8M7GL8MGZKr3jCMbI6eDeBylILszTxUHcfc+lpReg3FwGQ57bgECdSyz5YjPNope0vE8xhNKeD8W2rbgrHcGmvrXF86+8NkifSyDj0bpnY+KljS4OnpZ4nOF1XxaSE4/3iRoEGBzjbz1rPXyfXBO43f9TdmoBIdYBSEcbfWXLELM9yo8VcJ93zAIuMSvU0UsI98gO9qR7H14AJxS0RXSafIOc4KmMSEMbSmV2RNduUBb3FMnH94VkxhSkdkNKK5uQLZLG91sdP0Cpdnr55fHG1oPJHNzFZwx1XF0tk5NXK6I4cNgLK5WN7nZQY6WfQ2fCSOCHvqDz4dPqykiHYUj6I4pvrFyPPhbOhFWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gV2VkLCAyMDI2LTAyLTI1IGF0IDE2OjM0ICswMDAwLCBCcmVuZGFuIEphY2ttYW4gd3JvdGU6
DQo+IF9fR0ZQX1VOTUFQUEVEDQoNCkhhdmVuJ3QgbG9va2VkIGF0IHRoaXMgaW4gZGV0YWlsLCBi
dXQgdGhlcmUgd2FzIHNvbWUgcHJldmlvdXMgd29yayB0aGF0IGV2ZW4NCnVzZWQgdGhlIHNhbWUg
ZmxhZyBuYW1lLiBJbiB0aGUgZW5kLCB0aGUgZGlzY3Vzc2lvbiBsZWFuZWQgdG93YXJkcyBhIGRl
ZGljYXRlZA0KQVBJIGluc3RlYWQgb2YgYSBmbGFnLiBOb3Qgc2F5aW5nIHRoZSBmbGFnIGFwcHJv
YWNoIGlzIGRlYWQsIGJ1dCBtaWdodCB1c2VmdWwgdG8NCmV4cGxhaW4gaG93IGl0IGZpdHMgaW4g
d2l0aCB0aGF0IGRpc2N1c3Npb24uDQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAy
MzAzMDgwOTQxMDYuMjI3MzY1LTEtcnBwdEBrZXJuZWwub3JnLw0K

