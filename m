Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 385D8CD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 15:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680B36B0005; Thu,  4 Jun 2026 11:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A086B0088; Thu,  4 Jun 2026 11:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4839E6B008A; Thu,  4 Jun 2026 11:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3135F6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:43:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C66FA40183
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:43:16 +0000 (UTC)
X-FDA: 84842649192.09.E79B90A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5CE3A160002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:43:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ug94r291;
	spf=pass (imf08.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780587793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPaV4P2bIJBUi4MSiNLdGvI3z8ODLjImWgtxAumSxR0=;
	b=L3uHJAJJtsQDtcLvAE5GCh/hqCp4u7Hr7yvasqE4RTCP+hPc08dT5KFH8luddjvKT61/U2
	2dJW2pL2MEDCImuex5GhHHkie0BiQLn3q1gFn3AZZFK5Y8GS5KNmC2Z6NrTuHuO0SskF7q
	hNKhzv5jD3fWENTv8YjrflwOhaHahno=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ug94r291;
	spf=pass (imf08.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780587793;
	b=Ib2MetYcDfzznfbex88wxLSAUTzcQzy2/TQKFBFoXrFmeLfhwoMFl0L0NRuZS4Vt0XlhEP
	ruYTz5LxPr01guK1GRhWsV5+MMl1Xrb3lEuZHxDMIAurwieqDmljpknlby1AoDGumPiHP2
	3kSULZxmRMrZ0OJMKysL2POx5Vu2mGg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780587793; x=1812123793;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZPaV4P2bIJBUi4MSiNLdGvI3z8ODLjImWgtxAumSxR0=;
  b=Ug94r291id2S3kEaEqX2BkOoaVLuuieksF9tBfz2PUiTSQB6dZZpYzhe
   t8ZfOfqgY4fVj/co0GE69gPQY7FTVXouKVKNt+g1gLdkoIm6HFGalzaLt
   K/EWYbkJiPo7dpYVWdmq33zz/LxeMPVITVkcwaabji9cpvDe6Yy2r8S39
   0J8406u5CngrbJTdU72s9nTZZP3+trybtH86paUBubw+Fe9l3CfPoofsT
   Doc2GolVHavXm+42OeZ2DI+QgE3jLZOxD7zibj+olH4GOLJFhJ8G3gDxv
   Hwqted+Yud8xCgsb6EBEAtaq4YGPm5AWQ8PKANQAk7BNtjo7dVlaaYOOS
   A==;
X-CSE-ConnectionGUID: JI1iwfJtQzq5sIMPgwD2nQ==
X-CSE-MsgGUID: ECVj51B6S+as3vgceQZvTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="81324163"
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="81324163"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 08:43:11 -0700
X-CSE-ConnectionGUID: pkEpbVVwR3ilY4GAnE+sGg==
X-CSE-MsgGUID: iwRY+lr+TmmFILBQc/mD+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="268498397"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 08:43:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 08:43:09 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 4 Jun 2026 08:43:09 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.51) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 08:43:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jRr+7fBk4ceEdWg/Z68mPJlKvfkqzdyUYeobkJR4E/qu1p3O+MyyuqFk0uuY0fMPZna77xguGd4D9qBVVIdhkBOdHMr00thREgzcCutP3gmiSPvT/FRqqRIUsOgOm6YE0RQTUyhsM5n8czK5qu8uzsu4Y4sc8JeL3l4dOa3q8ucnUBc4mtjjWIiJeIAZgMkreCQagEm3hNGMBMvdylqEB7sKLYhxCtirfL8TyKmwzUKRjLsv8MhheZKO1MuitmTbXEV4IBldq4D1yXY8fOhEfp/LWAg33IdU8dWaxt16a0s8ZH38CVC0Dx1nYOyxGtnY24y0QPB7i9FbMHkACosbSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPaV4P2bIJBUi4MSiNLdGvI3z8ODLjImWgtxAumSxR0=;
 b=dawveXgoaSHhb4NGhgq6w7Q9VSqd4B+Vic0TxdhPpENj/GBNW58D45mzxxhPwAJqG+VOM6B9vI05Da6oMjkdgwQjhCBkJuWJio7peXXwDK9eSyYAyp1i1vdVcUwdDY1BlBf0uEwnX13Z4tTYyp/gfn0pVCFhxu5dGl2M0pvUNBGa7Px6ppDG2ge+Xo10xqMhvnTDQiXftxnptOkrXVd+DZ9CiOYUyX7nd8YjrIQyDLdoXO8mDXSShnuZ6mpspPP1kLXsWSwl7juVnyoSaR6VrwyjoMD370GWg5Uf7UQ/HLuXsN/4Ii0/KUtPoj8w/faJZAPoW5aKpC7/4ObfxmBh8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17)
 by MW6PR11MB8309.namprd11.prod.outlook.com (2603:10b6:303:24c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Thu, 4 Jun 2026
 15:43:05 +0000
Received: from CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::5670:5b2e:6ecb:dcaf]) by CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::5670:5b2e:6ecb:dcaf%5]) with mapi id 15.21.0092.006; Thu, 4 Jun 2026
 15:43:03 +0000
From: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Steven Rostedt
	<rostedt@goodmis.org>
CC: Borislav Petkov <bp@alien8.de>, "mchehab+huawei@kernel.org"
	<mchehab+huawei@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>, "xieyuanbin1@huawei.com"
	<xieyuanbin1@huawei.com>, "Lai, Yi1" <yi1.lai@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: RE: mm/memory-failure tracepoint change breaks userspace rasdaemon
Thread-Topic: mm/memory-failure tracepoint change breaks userspace rasdaemon
Thread-Index: AdzzWUeryVIHgoWJQJyC7gAz88QdgAABeDAAAAVQ7YAAABfXgAAAOygAAAEtTgAABKiwAAAqhkEQ
Date: Thu, 4 Jun 2026 15:43:03 +0000
Message-ID: <CY8PR11MB71340AAB7FB4C2332413615189102@CY8PR11MB7134.namprd11.prod.outlook.com>
References: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com>
 <b930678d-a1ae-458c-8705-7ca9680d4cb6@kernel.org>
 <20260603121707.7eccb9fb@gandalf.local.home>
 <20260603161947.GBaiBUI7C8WWPwD84S@fat_crate.local>
 <0c16bf3d-7c6d-4e28-b200-03b7d0ef714a@kernel.org>
 <20260603130006.7d2c4a62@gandalf.local.home>
 <b637ede2-73da-49f0-a7eb-70ec79e79624@kernel.org>
In-Reply-To: <b637ede2-73da-49f0-a7eb-70ec79e79624@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR11MB7134:EE_|MW6PR11MB8309:EE_
x-ms-office365-filtering-correlation-id: 4626df7b-fc3d-4164-1518-08dec24ff6bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|4143699003|56012099006|22082099003|18002099003|11063799006|38070700021;
x-microsoft-antispam-message-info: GQyjBEh0rcQu1NRXHI4fGUIYRQiYl45NoSIteRi7mmZIywzwevHyvgplseR5yXIVF65ymDCyKjKwIQ33TCTJ9eLGNdvip8oFcKlGf78QbCRJfVeLQG1nQHrrDFocdSbwb5xn3X8NvNDIq6RPRZSEotWO5pu6dcNMGk8w1zormrR7Et41mxOEJxu5XqPo6vxACadzb572XkwvjHONNi/v6SQU9Oe5Ng+JumwoM+WP1eOlXlFuB36PO21TrOriDV51gwvEW3lAyCP+R7nQ2XXMmj0OFBdX8BveSMlBGZ10eeHnbzzMlYAsvtj1PK8W5jayQHGO3ifn83dvVk1Y1QUK3et5jbV+43M4YK7BhbV/J2oDnsDC371j/B+X8qPeODZznKgfedcA+oVdxrYT95y5QB20wujSzY3GMYk1I98AxJHZE42CY1uDD9tcJRP6+iBs+nX1t+AOwwwPIn/kX4B0HRe6wRbZWM8OEzngmUSXc4Ss2jz1tVllRl3MF0nnQh/yVCr2cviRLZSW6Fq9BWRhL7seSh4rkGno4VL6P1V4YMzla58XVFIGGPcHmXA0eFk74uSZVZUqSYX3OdOGX/hm/Ws0Keyf6FIRi1xRvPgNw//KJj0wHs3VSjwez03TytgmS6CAg4YbDRHae2mZycy6l8jbs0rpE405uQmwF9VBLBrFLaMzoVzd8GAdKwY+xiaUwvZoCtsYCjmbIW1ifTsGkt8POo1JF9ImqTMYUMQxCdpTLnNL4V1AVUrhf8n15CMz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7134.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(4143699003)(56012099006)(22082099003)(18002099003)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFVWbm9DbmF6VkNnTkRyZitDbExQcFNhMTd5amljamY3d0lLM3ozaEF0YUl5?=
 =?utf-8?B?VUtpd3ViU2xteUM3ZjBtU2I4L0NkTlRSN1NDdDE3bVRuYnpvem54dGhyaFZx?=
 =?utf-8?B?dTViZHY5Q09manlTNGJLd3NSanhjV3hGOWFpbmt2b0dSc2xocUsxeEJjZmpV?=
 =?utf-8?B?WG1LNnRGV0F0N1U2NUdQUXBtYkc1VlRqOGw3Y0xGR1Y1cnl2OTc2VU9icy9V?=
 =?utf-8?B?N2xDcnphMzJ0cEZjUmlIL3hjbXBMRUVQVVlxY1lWRmNVckg3UXd2SHUxRytN?=
 =?utf-8?B?RU5SUVJ3MWZJRmVCdUVubGZZR055ZkJXQnNZRnJDQllpMWdaaGo1S2pwckFU?=
 =?utf-8?B?eVNVRlhQM2dpSWc2clllTTR1dC8rckdxQzJZYzhDb3ZMUlpGMGVsLzVQV1pj?=
 =?utf-8?B?WjVhTGRlNkJUak14Y2RaRm5PY2VSMEVNSmVjdWVCNWhkRW1HRmJnRDJWMDgx?=
 =?utf-8?B?c3BWcm13U2paRTRmaXJFYmlBcHVKcFR0dUJLeGcwUXNQWWcrdWFuQ3QyYzhY?=
 =?utf-8?B?MHA2b2FWVDZ2ekFCeFhsalVsRmJBN04xcjc2LzJ0L2VXRFFvVXlOSDdVamFB?=
 =?utf-8?B?Uk9ZTzdMU0txYVkxZXJpOXJUOURwT2VPendSZktzSlBmUXpOZTNVODF2cTE0?=
 =?utf-8?B?bEtDS3pIUzJoUHdXWjlJYjl3MldJWUYzUFNLWUErWUJzdm82NjRVOUEwaE0v?=
 =?utf-8?B?UDNNTDJFczJKZ1d1a1F4RVZSbWhYV3BZZ0ZxZ3JzMVZma0pZUE9vRmt6OXps?=
 =?utf-8?B?cGl1M2pYSTNxTUtkK1ljMWVDUmExZzZuTXU0RW9GcmIwbDdHOGo5Z2wwTHgz?=
 =?utf-8?B?bmhzcGpzMnFNNFZZVzRNRGhhQWlITjVJZU9qOTZOdzdaZnE5MnBTODZrOFdV?=
 =?utf-8?B?SHF3Wm1MNkl1M0lXTGJkL25PTnFucFozNmtjeTJ0YjdHWlBDdjBDSVFzcElj?=
 =?utf-8?B?WU15Ym12b082cmRDRHFwc1FVS00wZCtLVE1EL0F6Nng2REVEb2hESHZ6YmZ6?=
 =?utf-8?B?UHhweGd3aWVNcFhuR0NYK21qVW9pdmh0OHI3eWxBb2kwbVhqY1pJSVpwQzdX?=
 =?utf-8?B?aHNjZmpSNkdvNTVaNCtTajNqQ3V3aFBXRlJLZk9KZVkrSlpBQlVlb0VOamJ1?=
 =?utf-8?B?VXh4VzM1cGk4cmozTUVlVkljcEp0SUg2cXFTcnM1ejhVZDViREJIVDJiQkdx?=
 =?utf-8?B?TzI3alFwR0JhKzI5SmhkUTkzOXhvbWZZd0pSMTg1NkFqYnZ1M0RsZ002ZFlm?=
 =?utf-8?B?Y0Y4c3dNU0NJM2V4ckJ2VHowOERpWEUwbHdOdGpFZi8zK0ZaVkJZR1ZYZ2JN?=
 =?utf-8?B?cnVDd1NDeU9TY0oxT1V6VEZ1Tk9QQWNNdytBbHZmTHQxejRlSFBWd0dMYkta?=
 =?utf-8?B?VitvaUh0bnlGdVJGWmluSTlPUURwSUJxM0VQaHo5NkE5emJsQVNVQjZYcW42?=
 =?utf-8?B?TXFFeUFaNXBSL2ZidExYK1pIVnNsUTEyVE05RzBsYVd6c3h2YjBxNGFDd21K?=
 =?utf-8?B?cEVONkVyR1hkREl4OUEvWm1mQjdMbG5XSTBFeDN2bGwrRnE0TzRPSDV2ZnY3?=
 =?utf-8?B?MWpaejgvbytSd1ZNdkcxalVYZHpmcjhqV3lpRVlicktFNGdyZ0k4R1Y2YS9F?=
 =?utf-8?B?Qnp3Tmk2RjhtVUZ2U0pHRzdLejR0dEZRTWxxTWZEaHRncEloWFhpbElwZEQv?=
 =?utf-8?B?MlBhQTF6S0wwSDN6WFpNa01YVW5hcVl5OU5jNnA0R1NBRXFyWWU1OS9KTHdu?=
 =?utf-8?B?azBtYlo1Um9aUm1tTWFWWEZodGplVFBqQ2FiS3NJVnBEOEtEUVpEUGdTSS8r?=
 =?utf-8?B?WUpoWSsvRjVKcnN0QVRFSUhYWDN5VlU3MHEzbWpyek5XOHRzOTg4NGZ0cnh1?=
 =?utf-8?B?WnpXOGliZ2xlTEFnU1J2b2NTVkUxWHJhQnZCTmZhTW9xaG92eFJaMTdhSUwy?=
 =?utf-8?B?eEV2NkFKWUJmZWpVcHpnNHI5cWxYdVZzMzFtVWdEUEk5am5FcHJ3WkdwL0tQ?=
 =?utf-8?B?cTFDUUpkc2pKYWJiT3RoVFNnL3doZXpZaVBKZ0pVMkJ5TUZ4eEl1YnlrZS85?=
 =?utf-8?B?U0krSW9pb0RIaTFhTXBibllES1ZWTHdtSG1mZ1hMdWNKK2UwM0s2eFpvWWRV?=
 =?utf-8?B?SlU1aWZlT0RnMFU4M0VoUm5WS1RKek92a3hDZWtaelJzZXVVNmszVHd0Z29Y?=
 =?utf-8?B?ei9MaHd5Mlo3b2l1OEE4SnQ5cTNhTkVoN05kaCtEK3ZqS1hRQzh4R24zc0Fv?=
 =?utf-8?B?ZnR4OXNMcXhCd2t3blNPbW4waXZpM2RvbWgrSVZ0cE5xRDlHbldFS3RzeGtq?=
 =?utf-8?B?NWkzWG45c1JiVXNwa2VjOUMvKytmTDJ5VDg4VG53NU05M2QyRzRRZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ap7rbWCwtiZLnvLbbDuWsOVuSmFVgBkLsxgP+XI3RqgJVT5tLN5DEO/7EKdQBtmeeZKgJHV7P+wH8seE6QbTQFFBJ4IAuq4CAUMjt8i45Qd3KYySnho4bli0mytxL9HGhEEMreoLcTRitOeJwjiCbgmxM0OqQLf+hOFub+ti7VkY4bLLxrplWI5syfij/MWuU+yAQGjVgrHUPLg1WEyTsa60dWIF54LglMdUKUDSUP20zxMW05zprHNAmq2R0BU4/oM8cm3lobG83+eRO8GwFO0qmuVnbqfI9AuErM96T3uO+kKg5H9iiLp+W34mcjj3e+Z22pGBJtzphKZXq8y3Ag==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7134.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4626df7b-fc3d-4164-1518-08dec24ff6bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2026 15:43:03.0533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4+ip8RjwPqF1BlIb2eoEF5MjjMlR48Vuda0qjt0DFTsqOR/iGEi5rBv3DBLie7OXzFaxIARZStfmD2Wrpc+zOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8309
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5CE3A160002
X-Stat-Signature: bu4b5uusx99mkgaqoi6g3985646n6iyh
X-Rspam-User: 
X-HE-Tag: 1780587792-90346
X-HE-Meta: U2FsdGVkX1/SCFbxW6VN2ZJt4fsA6J+HkVC7VUJxPsQ4IEmT/le9TKbvUFhrqNwDry1/n0ktblUgP3vRFWAdGb4SBrDxS4SGhkI/b9NZhTKpJJ6gBZHFYor+iVYXsTa1fmnxZw2HErSx3PHwMk90poTiyIaH7HXCuUzd0RMAHq79AP8ddeuquAtD7TFv9sxSgwaKi8XdgJ52DtQYx2nuZNu/5B6JOKP4JwFVvMBspXwdS0WyOsc5nahaPF16i8DNNtKtPLyOaDR3z3Vu4Rfw0BbXFlbtK0HPg1yYsZU0WpwHttzjxWacEERryiDq0lSXiO4OH/da6XrfGLoCbB+64iokOV3J+rPFr4HsEiWERNaVPCnG8s64q9z8ZYpaf0SFzftcHyU98M7pOdGRj12lBUMuI4R0ofP2qddv7/P8IU4c6i9fQptfoj349gZaJ203JPLVj0/erlZDY4wHam7g5rH17+CcfLUouGfuNbn/d4oVPI/QLvrmBEuGwdfTN+S9Yc9vXERjk1COw/j/Pwut51/11WEhIdTYxdV7olhS/bzHKI5LlUy1h8k5LAJ96ByLvMQwZmNQlH9jJGt6u7mmAVoanX52IIQIHB8ioflNL6ra6CnxqfGDGOA7DwOtR7s+b//lUAjejwVLo5hIQ7+0XIwLkktAuDJCUGKn5vCRVhVO1dxvfH6HxT7l1N1enntKYPquinawZspEKbORaifHRPIBT4MdI2O58Et4/TaOH55LWECkVja8LBZHo2UxFeuI1Y4BwvPsSdrx+7FGUiBQPYjK3nOsALjj/mU0ya3T1poX7Sarm8sVT2rBgBiKQ666CW42ITOxBD8E7ZKcHKAy3sU9M9QLcA6CTDt0w//P01eX+YhiW8g61WEsaZRtg3Hm0eFgcaJkIlxKM4pVPhAmyz/2WmUhn2YfpeghkNKEoqCT1TZTEdhet4JS1XaVrFK7430z77NKWue3Tn72ETF
 5cEsOank
 Q39GoWcabU3r1Jmb4kIrqtQcX3vhQAR8FDWdqD7fepFeG+b/1aFzsSytT2CZlQk7eeEf7450+4hYN7c8ZoRz5pfVnYd9ctz5QBs0xOa4IE/18fa1Nn5abWCAwCwVeqM4AZ2ACoeVODoUvYVp2L+BoRY00eXpBgzTAkkf/zriQhbg62rmgbfLGfOhaE1wrb5C+3rG5hAvvNpYXiDllEm0wSGWP7Nmb4/cL7wY4vfjj3w81BrYiOx9jB3mYKYey9IdIb6oRZaPVSLbY7ZkXxkZ9fD4u2rCIMbzMlD8f4t+Ue/iAz1XRbZ4bAAH5dCQm1YxocgVnTCKM9C8nR5XOOHEhznl7U7wiFrcT6GizrX+RBfj8vWuLdMZVqs/a3dGDo575VoQ1f/ggfB5Hdq2v6MKc+2PW2LsANRmezP7S/UlYdz0gdHIwPp2P8XNJUDQxzfEksvo/NYk01/d3303ytGu9YjvGshkEG9L58RdDKlVIgzW6vpVMK00qlmAK3l/7v/O8cefWv84qZkUkDOxJlTLAmcc8DTpSBp+H24ybIzJySShkqUGGaHbKPhw+2YvzjA/d83gqlFryYDw1o+XkQP6GNNLSoszvW78KUVTSxUenVODEh9USU+JTEXangDwbwsnqtxrsY2O7Y+ZNwGshl8EyEoJMTJJqyCPTajmyRCA10rKfecC+Z7ahby5E8QHrQhDBu6p9tteIgs/QfC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAoQXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gWy4u
Ll0NCj4gV291bGQgdGhlIGZvbGxvd2luZyBiZSBzdWZmaWNpZW50IHRvIGF2b2lkIGEgZnVsbCBy
ZXZlcnQgYW5kIHRoZSBkZXBlbmRlbmN5DQo+IG9uIENPTkZJR19SQVM/DQo+IA0KPiBkaWZmIC0t
Z2l0IGEvaW5jbHVkZS90cmFjZS9ldmVudHMvbWVtb3J5LWZhaWx1cmUuaA0KPiBiL2luY2x1ZGUv
dHJhY2UvZXZlbnRzL21lbW9yeS1mYWlsdXJlLmgNCj4gaW5kZXggYWE1N2NjOGY4OTZiLi5jNDZi
MTc2MDI1NzggMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvdHJhY2UvZXZlbnRzL21lbW9yeS1mYWls
dXJlLmgNCj4gKysrIGIvaW5jbHVkZS90cmFjZS9ldmVudHMvbWVtb3J5LWZhaWx1cmUuaA0KPiBA
QCAtMSw2ICsxLDcgQEANCj4gIC8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wICov
DQo+ICAjdW5kZWYgVFJBQ0VfU1lTVEVNDQo+IC0jZGVmaW5lIFRSQUNFX1NZU1RFTSBtZW1vcnlf
ZmFpbHVyZQ0KPiArLyogU29tZSB1c2VyIHNwYWNlIHJlbGllcyBvbiByYXMvbWVtb3J5X2ZhaWx1
cmVfZXZlbnQgKi8gI2RlZmluZQ0KPiArVFJBQ0VfU1lTVEVNIHJhcw0KPiAgI2RlZmluZSBUUkFD
RV9JTkNMVURFX0ZJTEUgbWVtb3J5LWZhaWx1cmUNCj4gDQoNClRoYW5rcyBhbGwgZm9yIHRoZSBk
aXNjdXNzaW9uIG9uIHRoaXMgaXNzdWUuDQoNCldlIGFwcGxpZWQgRGF2aWQncyBhYm92ZSBmaXgg
dG8gdjcuMS1yYzMsIHRlc3RlZCBpdCwgYW5kIGNvbmZpcm1lZCB0aGF0IHJhc2RhZW1vbiANCmNh
biBhZ2FpbiBlbmFibGUgYW5kIHJlY2VpdmUgdGhlIG1lbW9yeV9mYWlsdXJlIGV2ZW50Lg0KDQog
ICBSYXNkYWVtb24gbG9nczoNCiAgICAgLi4uDQogICAgIHJhc2RhZW1vbjogcmFzOm1lbW9yeV9m
YWlsdXJlX2V2ZW50IGV2ZW50IGVuYWJsZWQNCiAgICAgcmFzZGFlbW9uOiBFbmFibGVkIGV2ZW50
IHJhczptZW1vcnlfZmFpbHVyZV9ldmVudA0KICAgIC4uLg0KICAgIDwuLi4+LTI1MTMgIFswMDBd
IC4uLi4uICAgICAwLjAwMDAyMSBtZW1vcnlfZmFpbHVyZV9ldmVudCBbQUxFUlRdIDIwMjYtMDYt
MDQgMjM6MzA6NDMgKzA4MDAgcGZuPTB4MTQ0ZTZmIHBhZ2VfdHlwZT1kaXJ0eSBMUlUgcGFnZSBh
Y3Rpb25fcmVzdWx0PVJlY292ZXJlZA0KICAgIC4uLg0KDQotUWl1eHUNCg==

