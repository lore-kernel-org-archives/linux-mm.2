Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269B5C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118536B008C; Thu, 27 Aug 2026 04:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A29F6B0092; Thu, 27 Aug 2026 04:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5FFA6B009D; Thu, 27 Aug 2026 04:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF51B6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:33:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43C3F40367
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:54 +0000 (UTC)
X-FDA: 85146386388.12.2A9AC98
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf30.hostedemail.com (Postfix) with ESMTP id EFE7A80004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZYuU15qw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787819630;
	b=NIbdGNR0oEmhwyjht53nt6VMyz4jyl+BjwJTxZN449OSdthgMZBMwrFCDnNxTpkpoRpofF
	8oTi37Nl45XlQ4ZYRTthsTKsg9gxFWDyKfcSPxJe9Suf0UKnGEHloU9ln7Fet+UeI7h9JE
	OT4/LwI3CJPxCiOFXB4AotugJ4CYYdw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZYuU15qw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787819630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NqQkHB+j5hmq0NuZG/sfwJQxQUvpAmNp0yR8IG5k3M=;
	b=YK5Ef5NFuOUlktJahEyTvdhUZzqZCM6lP0kDm5nbCFKg4Cdg3FOIegrdRZt7qrqnDT3brg
	gHgsulfV9xTABnXL0pShLJzo/cXIr3frb6tkZOUiOy+ReI0Ve8Ef9XIvTL0YTC6J4KzOwW
	K6w6geLz/BE4WZ6draJNIENEOX7Hdh0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787819630; x=1819355630;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9NqQkHB+j5hmq0NuZG/sfwJQxQUvpAmNp0yR8IG5k3M=;
  b=ZYuU15qw3Ih2j+NWrecuvnsEtIUiH5NzSIVLl5et6EYWWeH9NPsid/sz
   gYE+OqPF0rytR8sAehIDVuaBkCUGxh/jt95ge/4dVqxmbVh+fBEodYpYf
   HDj4+p8XN7+aHorvp+Y5LenfStBR751hnb1Xf0AF6/ZuL/wQnZbP/XIXI
   iM0kLWShu3zm6ncXwfZ+xRY/xPquPKRpFHsNQKEYTbmLf9E9wubrc6Yy0
   EYmcsitextyVvQGt1udJXwDkAIRZU1I1bDn/NIetZt/ovE3I0BU/m4+Gw
   Y0ROW3+1Z34r1Rj3C+93g52GQvRy5wCO/NgaaTU8tbDm7akrAZ28hE3Ea
   A==;
X-CSE-ConnectionGUID: P6QjljrxShGLQ724d83Teg==
X-CSE-MsgGUID: 2wobQn8tT0aTNxSsdl35BQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11887"; a="105689351"
X-IronPort-AV: E=Sophos;i="6.25,246,1779174000"; 
   d="scan'208";a="105689351"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 01:33:49 -0700
X-CSE-ConnectionGUID: 1t6zXHl1SQq9g4LsfNQIog==
X-CSE-MsgGUID: 5co3uBLfSEWF9YdJRekzrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,246,1779174000"; 
   d="scan'208";a="267224974"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 01:33:48 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 27 Aug 2026 01:33:48 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 27 Aug 2026 01:33:48 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.35) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 27 Aug 2026 01:33:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xRRbvfYluD3VVcw3Q8Pw/SGhhAlFdrZxOWE1Bk7uxv9p6KllqUVN5G/EQvtV9c82l4cDmD9mMXcgf8BtYbHcIZ4ImciBl1n1XCRUNTTqfKmQJHFI+IjyLWfz8PaFaSEQBtGyzmGex8neFklozQm6zXtjIXbZcOK93HCTvvKRBc7ERxVkGHhx0NM4eb0UHSUAIeCT+5cU+gPMLgwIBTD+qaxC7830RfM7HYH0vRyxRXXzBYcILnamMYKekzV+nDyzqL10VvdkjojIxlXGlIA8GHZkW5VS86DGjs6ByIg7QbFAYnZ+4PD6AgJFJLT3Bb5rS53Dx0ZBQHxd+S1XNLTZ3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9NqQkHB+j5hmq0NuZG/sfwJQxQUvpAmNp0yR8IG5k3M=;
 b=hxQsQh/fAyAdDzYxfeRdj8yCr7M7ZhHyOVPTfrXm+a4bKDhZsLyf4p2MSs8r11DSogRqXIPiE+ALfmS3/vDFOZP8R6gIFaiBuDNEoqv/0p3p0x41nLotyHQaFOAP7SRCJrBjH3XGag/vbNwKjPjmrqU7oQqIj0lwzo7wVOaGR/e+qUTfsnyOGUyDdNrQ6I8ryrm1bgy5WSMA0lK6rmf3fPTmLqDMdEJvuNHiik8uAu6C1el/4GNcan7Bc/QepaonTNRBIxp2aLKhoU5bpNqIbbb3GM6QvkevrcUk3sGu0BCgj17w6WHHDHUYpuXTqzOepIoWwreuU64rG+HZfW7wsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by DM3PPF453C3BEC4.namprd11.prod.outlook.com (2603:10b6:f:fc00::f1b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 08:33:40 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 08:33:40 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng, Jason"
	<jason.zeng@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan"
	<pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHdLu8R8F489m5sRUGA8lOjA7/dwralh/aAgAFm0GCAAEr2gIAAnm0ggAg+UQCAAYhSsA==
Date: Thu, 27 Aug 2026 08:33:40 +0000
Message-ID: <MW4PR11MB69364661700E27E1C50A9A0DA3AD2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
 <20260818085702.3395529-3-yuan1.liu@intel.com>
 <ac77571f-4a10-4511-83e0-c6372d5b4a09@kernel.org>
 <MW4PR11MB69369259EB8B2FDF237B863AA3A42@MW4PR11MB6936.namprd11.prod.outlook.com>
 <bf298ebe-55bd-4f42-9339-9567eadaa514@kernel.org>
 <MW4PR11MB6936054EC741918CCFC6FDD6A3A32@MW4PR11MB6936.namprd11.prod.outlook.com>
 <819cc4b4-1855-4dbc-adb4-3b18d6fa2924@kernel.org>
In-Reply-To: <819cc4b4-1855-4dbc-adb4-3b18d6fa2924@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|DM3PPF453C3BEC4:EE_
x-ms-office365-filtering-correlation-id: 63f279a9-7245-4f8e-a501-08df0415e5b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|56012099006|22082099003|18002099003|4143699003|11063799006|38070700021;
x-microsoft-antispam-message-info: YgjCI++c/+NZqm8nrJmZDx5+EunndtR/uD7Nf1WCO4A9ikWsjtcHQ3Ffv2BdGxhdoHxhTgiodSciptDtIOIJv2LVp+JXzOFplreX+ywFIvLtj8nC1qX/cDz97ucCY1OcMF0/0oUdb0FOOMtDbymqsGVmHOVkIvedIhSwBAwTqWdaoC9fb6luGxxO/YVQwLqvkABkNT0fVN2aODLoDKLsoqDGroaJVhPP8tRmct/DbhoelljpcFQ0LxB3bKZuo5z9AC71heN0s+/5kKtQHSBLF/BuuNcUYhblIw7Cnlh85EegOfCmcP4gWAIZltPUqfg+K7oRzpvAe0KGrB2sFdzLw7eSxnHybmPBJPkFMg+J2p4EDhnm9kAxDThKk65Kc2kwwBahj4gI5dfRmQNNF9sc0IaBgpR5hXOCLB1IRVr8NsiaNxCqeQ0lipFL37PqC3X2KoRIdJXZeuHvk19OMB3xcCmWKSbBs7EL8QyRugxmn6Db9HncF918Lkj9VqoBSEAp1wQKIZZlX+tM43NkYzGUD8jMu3nJj2WozUyV1R5Zkm0laNBzqUTRt5tA2zvOOzpOcWSE2kaYzmFGO3+bWkm6R5wc7s1N8YM3F+FcVx/ApE+kYjHrSme2HtC8uL/QQgv3aAkqTNuBuWjvaEa4ExQna3e2iCAPX7blfs0w+l5bHv/uwT2R64HiyJm1PP04sAXM0jrJOUyzvuBXII56Jgp4uB0DvRL2cJK3ju8fHn0bz2Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003)(4143699003)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzFuR2dEOXJoVzJHZlpiY2VmUmlnays0c3JUejhCU0xBUXpmUG1uWlBPNU5J?=
 =?utf-8?B?T0NVdkN4K21XZ2hnT1E3VFhVRENYZGVSR0QyL1lybDYvd2xFTHoxa0E3QU4v?=
 =?utf-8?B?SXM3eisvMG1EcTFIM2kyem9XWnIwejMwZmN3QUNMQVhYVEI2UWRUVEs3UFZL?=
 =?utf-8?B?OW44dWtLSkRPVkg0TmFFSFBJc1Q4Y3czL1NYTkJGcURneHB6TVNULys1aE1v?=
 =?utf-8?B?ZC9HSzg5a0Z1bUxVd3FuVmh3SVBFTWtrUEgzR0h4THQ5ZHc2S0RlelN4ZWVQ?=
 =?utf-8?B?WVlxRGxxdFJRbGhRL2hnUlIzZVN4aE5oeHh0UWRsV1pBTEpnUXRPTERSMFZ0?=
 =?utf-8?B?QVV0MUpEUVE1U0w1MWhqdUJtS2pYRnQ5RGpEWEo3a29BaWFmRTFnQ0dlSUtB?=
 =?utf-8?B?UnhlYXZlQ3lEeFQ5N3hjWUF6NUR0ejh2RTVrSVFZWkNkUWVuZFR1a3pSSXJM?=
 =?utf-8?B?R0xGeWRtc2IzWktleWJsemRoenRYa2tndEZPTHhDRU1rb3o1US9Jd1dTZ1Fj?=
 =?utf-8?B?UTV3b1dHb0xobzYyL21WY2psWkdTMVN2ZHJiL1R4c0tLa29YNjQyUW5vU3ZO?=
 =?utf-8?B?UmpHQUI2bVArKytpNHdzOXhGQnRzdVF0c0VIYmlaWVpWc0xpTkRUMzVrRFM0?=
 =?utf-8?B?NkZCMW1wdy8zN3RzSExjZ3U0cUNwaTRnT3lCdEovMDJJU25oT0h4QVVCWWI3?=
 =?utf-8?B?VW5OTHdjeW40am94SVVXL0ZHeHBGY3lLb3B6QVl6T0JITlBOemZaRjJJeC9h?=
 =?utf-8?B?WWdFRERYMzBHZnJiMW9vMUh2RzBtdkJobmx2OW1TQmNrUVlVSndhdEhQQXpr?=
 =?utf-8?B?SGFOa1puTDNnTDl0eVNDdnRVUnF6elp1M2JSRkVaZlRYQUtuSmlGZllpSHhz?=
 =?utf-8?B?cTNUbzNQbEJaVWRMNjlaaW1oQ2dSVDZUd3RqVHlRWGZodjVDcTZoRFY0eHRm?=
 =?utf-8?B?R3UvanVGRlNraWdQdFUwN2RJN3IyVlM0REFWZkx5ck0yNGdnalE0ODJGTk53?=
 =?utf-8?B?Qk1lUFYrTU1BbkdqNEJzWENoWUQyUHlyRGxNU21mdWZuVnNKK2lsc0tCQzdq?=
 =?utf-8?B?UDZ1cEJHR2FXVTdoYy8zZG1Lb2toOUpIRjZoTTBpTHJqeHdQc0ttakY2KzVJ?=
 =?utf-8?B?SWVGeE5BcUlqS2ZQQmlhOWZtOE1wRE1FaG1ET2pCcDFraVFxZVZUS1lGdUtC?=
 =?utf-8?B?elduMHpTaStHdVl4ODNpU0t6K0J4RC9GYVRBN3gzSWtpaDN3OGlhZ2RwMklJ?=
 =?utf-8?B?Zm9QTDk5OWNJTjh3dXlFQytTV2RlWGtJa09YYysrVzNWUnYreTJXRW1CWnlK?=
 =?utf-8?B?aTNIQWFiTjREOHphTVpNZnZaS1JoQ0J6OVpFZ2Z4Zzc4amF6cWpOV2tVdGxC?=
 =?utf-8?B?eFVCTnVVaytEQjVoblViZzFwQnVFWjZaQVN4cWNvbFFXMWwwTkRMcGdvNHZR?=
 =?utf-8?B?SzZYcTJ4YVVPT1ZidlJjdE5uaVlyM2djY2ZHY3VoMTlTMVdRdEpMRWxpSUtk?=
 =?utf-8?B?Z1o1M1U0K0RWdVU2T2ZJbWs2WG11cmlQc0pReWh1WHpBVHQ1VWUwOUl0c09n?=
 =?utf-8?B?SzBKMEpSWGJITTgrSEtBRmFOSG5KQ0M1MWp2dEF4K0ltR2NKOS92N1FTSDBT?=
 =?utf-8?B?U2ovSnBkTDNYb3krbHJpaWdNaWVvNXFhdWJ6Nm9ZcWdad1J6NmZ0ZmNCaXNH?=
 =?utf-8?B?ZEZMRGU0OGJFZXlUYTAvNWg0WGRaWitVSklKbzFLZkdTRXdsdWMwUm9KQ1Bp?=
 =?utf-8?B?MzRLVHRHWUwwM3VXZ0M2N0g1Z0RQRW56NlhXYk1DMVU2ZHVXdjVNMFlpK3VN?=
 =?utf-8?B?TGlKYUNyTk90aEZEbEZ3Z2ZmSXlDQXozK3k5M2tkSllWMEFVbjlhZVFWMjFa?=
 =?utf-8?B?TVpqNUVlcXZ3STBwN3ZaMFhiWEJGdUFodlpnSDlNUXI0VktwRlJxb2swbjZw?=
 =?utf-8?B?NDRNbnRZdklyUWMwUWw2a3p5Vi9xRGRrUmltNlhkbzducGIrdUkrdko5eGdv?=
 =?utf-8?B?WWo0MXR4TWRYTUhJeUQvcC9sU0JKL25hRDAxdnhhOEFtTEVoSUFqOW1UR3U0?=
 =?utf-8?B?V0dJaVl1UmxvYUNQZFdqU3J3RHV6b010OFNLcXlHUE9LU0pSWENRNVdDZzMw?=
 =?utf-8?B?VzlTcnZ6ZmxISk41bUlkRVhWTVh2SnFrR1ZoSkpWQUFBOU9UbmJTV0pUeThI?=
 =?utf-8?B?MTR3aVhjSGJuTllsdWpDWDBTRENsQmZyOUx0WkRtVE9LSGxaQXNjMFZXWDBX?=
 =?utf-8?B?TW1ac0RkSkRWSk1VMkx4d0duY1pUNnpSTjdpWVdIQlE3cnk3UGF3UmxYZzhW?=
 =?utf-8?Q?c8vSWJzWEhwEiuUUW0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: GCi7Zs7VUXW0ZgusrQEyUp3NRftFGOzB7WzvKhgkKIS9IJ8K06eA7xfWIPoyldaJZWjuSarZc8Ne7axTRjZAmnYMh71b7O5tFIWaImDyzB4EjUKtG43qmtB5PyevmZpZGQgcu+5B/fuBKbnUJBlcw9LAgFrB0GJDgeZr9vw9ih+bIH0jlpx+ZNmOHNAn2WKTzYMDyBGDpwz+pQgb0GEFLHtnJueRJVCRk5fTn+3QkgCmrXrZtJzdR3tMvFDGJ6rxl7wxZCs6jFSHCRMlXy09lp2wrj67cc3YVRYw6rblucFtJCAr2ahlbPQHDuR9ZLt16LVybG8W1ZOpQlyWavfzZA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f279a9-7245-4f8e-a501-08df0415e5b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2026 08:33:40.3812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PnVIJiiFrYk2UGjP1CjbYJKzUlzQbeaGNmviSEcAtthCE/CCzKyUZtEPSObHEyoK5qq3qDEeCHv1b5AyUjoIgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF453C3BEC4
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: 8xjqfmiuyt5xitw8tz87ogb6c88uwg9j
X-Rspamd-Queue-Id: EFE7A80004
X-Rspamd-Server: rspam06
X-HE-Tag: 1787819629-125231
X-HE-Meta: U2FsdGVkX1/Yvr7ZHAqsz9uhLvBf4UnwVzu1NMRImiQ/V7ezqFO+6cTVGI5YMIqFARtUYQ6Q33vOaMt3FJV+DqXxwZuPrCeP7Z7cj4Hi542uhsOeoSQRs6Tj7Joy8WaWOVBmqp9jJ8lnnoapP2Qyu7sLHU6yx35OC0ZZHKtm8lVzbO1EEtPqmfaHFCJAWp+W7Nu0TB+VKbxItOFYahoYRgFW1J+7HFe+goM2rZ10aqtnZcJTvZPeH+MVLgLCOpeCTJQyLyNwVfSKkRR5tfiog93Z6tKPsSWQfZaX5ykF3CX+2xcWLNM+P7n1vUA6FG+ml4hyXxws+eUeFfzUknEcWlDuWQJgrU75NM/g4DSkjOiIvdghg4g/nqnOSLJhGQKwJhrzq+hvzHLIBK+DD9DTlgQ/EAVlsmDolZnibZsZXxgPT0/NHzhFWNkKST351AXvLADynl+4uq2vSe5sWX7ZG1azoWN2PwaT7ttcMKRx170YWWuUPrDZEMksNUIkdlmAeldhHSpEYTjBdXgDyPtX+iYMBXPJy7MEz2F3URFAmq2g02ClNJWjpE9zVRaEBL4yZ7+SpmcKFWPscbk54FR/WF6nsCOemQEOxsDnp1FoGyRvNRfcag3Y9pCa0BF8atg1ghAe8pvlRwJX/ON6LAhNTnJZwPUeP2HZ2zqmUxNl3js/EKXlojFPICycTyrFT7No1EvN1Lxi8VbGbT3CyCmFCX2lGM90gPPqRiT3RbPyNtkRPww4BkRiobz7kuW0zjq9W6/8m1EKsJ3CCWGcVx3GBzWAqXKleahmH0+0XgG4VGth3ZvZKD2PjnZ115on5XY7UHXK4N7SC54JSTOqN0hyr+AuGqv7IFN8w4fYZemkW2D0p9W/9G7XmUxfEAXQF4nO8x+xL7vd3hTw12NS6b1N5t3vBEUneBanMxbMPQT5IEwqWPVGIgSrSru/iSkyWiCmIk0Au/whNl285CaXA86
 R7pUK7NV
 zLT+EMRyKSijQayTlDVpRVJ/sQGNZUtBAnnkkoBI5b6wShqKxZXoxFdzHpxLaC+g4c4XfseRMJinWdd6rG32TQZT74Hi/RySMPSNTfuiO4yx8nGN9uNNy5w1S+HQ7ZKvCWIAqgf9FzqbpA1TGc+3Up09JsvC0doQTogF0jvhzIkWgnSHl5GZSTQu66KUB8J160V1ozRI4f9UW0GXrjNtdKPH6uSFC9lb2hs4NfOy6GdexmdQ17swTHXY/5/uU0eMGxoI72l/J3OxnW8RZLqrFPw3i954lQbxFKPCicx1OEaQDPiHWwpMH3VCdoEXn8o9v7P6s1YyqWpFGrrHJCmwOQFCbkzIp5z+g6Md6mGi2fDVWZt66v7QYLycClT8rxkQmpoDqzynTEN+/HbOdILit0iCS8XZyuSD7QIbic//mbdJJQRs9HqeTbSB2P17xZWA1dyZNz5/y7j2mVeJkfBNuNlSCax7hY8Sihasi6WSy8uSBfvIZov/mk9xZ2T/aGFYCGOnWGOQCc+OssOTc4mXe8IvHYClseePKMmXg8AW1aoiQh5g2Uhv9bzXz9dQQZQCNH0AVXA6AbMracfOhrvE+rMdzrSxQ8ARCQgi7qnpoVu1QT50LO78ndpqmfpMo6PxEruZo90NGWmJx3FSyn6UaoVHJb1ULuId3j7UELvAOVyrq0KU8zNmTzNqJDslruCHmev0kSKM0MBH2Wu/iivx+k2yGuUYITl/LeFH6KtBYjvEl5EqwHEdC0gWQJ6y8Bm40CFMKjRCeqRwV6uU6C6EyDl2rU2mZWx6bO2bMbKcrE/rJRHUWqjZvVsghwHlMyp7D2XR7zsP/YdDiQDVS4wD57ofqCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBBdWd1c3QgMjYsIDIw
MjYgNTowNiBQTQ0KPiBUbzogTGl1LCBZdWFuMSA8eXVhbjEubGl1QGludGVsLmNvbT47IE9zY2Fy
IFNhbHZhZG9yIDxvc2FsdmFkb3JAc3VzZS5kZT47DQo+IE1pa2UgUmFwb3BvcnQgPHJwcHRAa2Vy
bmVsLm9yZz47IFdlaSBZYW5nIDxyaWNoYXJkLndlaXlhbmdAZ21haWwuY29tPg0KPiBDYzogbGlu
dXgtbW1Aa3ZhY2sub3JnOyBab3UsIE5hbmhhaSA8bmFuaGFpLnpvdUBpbnRlbC5jb20+OyBDaGVu
IFpoYW5nDQo+IDx6aGFuZ2NoZW4ua2lkZEBqZC5jb20+OyBaZW5nLCBKYXNvbiA8amFzb24uemVu
Z0BpbnRlbC5jb20+OyBDaGVuLCBZdSBDDQo+IDx5dS5jLmNoZW5AaW50ZWwuY29tPjsgRGVuZywg
UGFuIDxwYW4uZGVuZ0BpbnRlbC5jb20+OyBMaSwgVGlhbnlvdQ0KPiA8dGlhbnlvdS5saUBpbnRl
bC5jb20+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggdjcgMi8yXSBtbS9tZW1vcnlfaG90cGx1Zzogb3B0aW1pemUgem9uZSBjb250aWd1b3VzDQo+
IGNoZWNrIHdoZW4gY2hhbmdpbmcgcGZuIHJhbmdlDQo+IA0KDQpbLi4uXQ0KDQo+IEl0J3MgaGFy
ZCB0byBnZXQgaXQgYW55IGNsZWFuZXIuIEkgd2FzIHdvbmRlcmluZyB3aGV0aGVyIHdlIHNob3Vs
ZCBqdXN0DQo+IGhhdmUgYSBzZXBhcmF0ZQ0KPiBmb3JfZWFjaF9vbmxpbmVfcGZuKCkgY2FsbCBh
ZnRlcndhcmRzLCBidXQgdGhhdCdzIGFsc28gbm90IGlkZWFsLg0KPiANCj4gSSB3YXMgd29uZGVy
aW5nIHdoZXRoZXIgd2Ugc2hvdWxkIGFsc28ganVzdCB1c2UgcGZuX3NlY3Rpb25fdmFsaWQoKQ0K
PiBkaXJlY3RseS4NCj4gDQo+IFNvbWV0aGluZyBsaWtlIHRoZSBmb2xsb3dpbmc6DQo+IA0KPiAN
Cj4gZGlmZiAtLWdpdCBhL21tL21tX2luaXQuYyBiL21tL21tX2luaXQuYw0KPiBpbmRleCBlOWM0
MjA0YjczYWRiLi5jYzdkNTVhNzFhMDYwIDEwMDY0NA0KPiAtLS0gYS9tbS9tbV9pbml0LmMNCj4g
KysrIGIvbW0vbW1faW5pdC5jDQo+IEBAIC04MzgsMjIgKzgzOCwzOSBAQCBvdmVybGFwX21lbW1h
cF9pbml0KHVuc2lnbmVkIGxvbmcgem9uZSwgdW5zaWduZWQNCj4gbG9uZyAqcGZuKQ0KPiAgICog
ICB6b25lL25vZGUgYWJvdmUgdGhlIGhvbGUgZXhjZXB0IGZvciB0aGUgdHJhaWxpbmcgcGFnZXMg
aW4gdGhlIGxhc3QNCj4gICAqICAgc2VjdGlvbiB0aGF0IHdpbGwgYmUgYXBwZW5kZWQgdG8gdGhl
IHpvbmUvbm9kZSBiZWxvdy4NCj4gICAqLw0KPiAtc3RhdGljIHZvaWQgX19pbml0IGluaXRfdW5h
dmFpbGFibGVfcmFuZ2UodW5zaWduZWQgbG9uZyBzcGZuLA0KPiAtICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBsb25nIGVwZm4sDQo+IC0gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCB6b25lLCBpbnQgbm9kZSkNCj4gK3N0
YXRpYyB1bnNpZ25lZCBsb25nIF9faW5pdCBpbml0X3VuYXZhaWxhYmxlX3JhbmdlKHVuc2lnbmVk
IGxvbmcgc3BmbiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgdW5zaWduZWQgbG9uZyBlcGZuLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQgem9uZSwgaW50IG5vZGUpDQo+ICB7DQo+ICsg
ICAgICAgdW5zaWduZWQgbG9uZyBuZXh0X2NodW5rX3BmbiBfX21heWJlX3VudXNlZCA9IHNwZm47
DQo+ICAgICAgICAgdW5zaWduZWQgbG9uZyBwZm47DQo+IC0gICAgICAgdTY0IHBnY250ID0gMDsN
Cj4gKyAgICAgICB1NjQgb25saW5lX3BnY250ID0gMCwgcGdjbnQgPSAwOw0KPiArICAgICAgIGJv
b2wgaXNfb25saW5lID0gdHJ1ZTsNCj4gDQo+ICAgICAgICAgZm9yX2VhY2hfdmFsaWRfcGZuKHBm
biwgc3BmbiwgZXBmbikgew0KPiAgICAgICAgICAgICAgICAgX19pbml0X3NpbmdsZV9wYWdlKHBm
bl90b19wYWdlKHBmbiksIHBmbiwgem9uZSwgbm9kZSk7DQo+ICAgICAgICAgICAgICAgICBfX1Nl
dFBhZ2VSZXNlcnZlZChwZm5fdG9fcGFnZShwZm4pKTsNCj4gICAgICAgICAgICAgICAgIHBnY250
Kys7DQo+ICsNCj4gKyAgICAgICAgICAgICAgIC8qDQo+ICsgICAgICAgICAgICAgICAgKiBXaXRo
IHZtZW1tYXAsIGF0IHRoaXMgc3RhZ2UgYWxsIHBhZ2VzIGluIGFuIGVhcmx5DQo+IHNlY3Rpb24N
Cj4gKyAgICAgICAgICAgICAgICAqIGhhdmUgYSB2YWxpZCBtZW1tYXAgYW5kIGFyZSBtYXJrZWQg
YXMgb25saW5lLiBIb3dldmVyLA0KPiBvbmx5DQo+ICsgICAgICAgICAgICAgICAgKiBzdWJzZWN0
aW9ucyBpbiB0aGUgc3Vic2VjdGlvbiBtYXAgYXJlIGFjdHVhbGx5IG9ubGluZS4NCj4gKyAgICAg
ICAgICAgICAgICAqLw0KPiArI2lmZGVmIENPTkZJR19TUEFSU0VNRU1fVk1FTU1BUA0KPiArICAg
ICAgICAgICAgICAgaWYgKHBmbiA+PSBuZXh0X2NodW5rX3Bmbikgew0KPiArICAgICAgICAgICAg
ICAgICAgICAgICBpc19vbmxpbmUgPQ0KPiBwZm5fc2VjdGlvbl92YWxpZChfX3Bmbl90b19zZWN0
aW9uKHBmbiksIHBmbik7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIG5leHRfY2h1bmtfcGZu
ID0gbWluKFNVQlNFQ1RJT05fQUxJR05fVVAocGZuICsgMSksDQo+IGVwZm4pOw0KPiArICAgICAg
ICAgICAgICAgfQ0KPiArI2VuZGlmDQo+ICsgICAgICAgICAgICAgICBpZiAoaXNfb25saW5lKQ0K
PiArICAgICAgICAgICAgICAgICAgICAgICBvbmxpbmVfcGdjbnQrKzsNCj4gICAgICAgICB9DQo+
IA0KPiAgICAgICAgIGlmIChwZ2NudCkNCj4gICAgICAgICAgICAgICAgIHByX2luZm8oIk9uIG5v
ZGUgJWQsIHpvbmUgJXM6ICVsbGQgcGFnZXMgaW4gdW5hdmFpbGFibGUNCj4gcmFuZ2VzXG4iLA0K
PiAgICAgICAgICAgICAgICAgICAgICAgICBub2RlLCB6b25lX25hbWVzW3pvbmVdLCBwZ2NudCk7
DQo+ICsgICAgICAgcmV0dXJuIG9ubGluZV9wZ2NudDsNCj4gIH0NCj4gDQo+ICAvKg0KPiANCj4g
DQo+IEknZCBsb3ZlIHRvIGF2b2lkIGFueSBDT05GSUdfU1BBUlNFTUVNX1ZNRU1NQVAsIGJ1dCB0
aGF0J3MgaGFyZCBhcyB3ZWxsIDopDQoNClRoYW5rcywgRGF2aWQuIEknbGwgcHJlcGFyZSBhbmQg
c2VuZCBvdXQgdGhlIG5leHQgdmVyc2lvbi4NCg0KQmVzdCBSZWdhcmRzLA0KTGl1LCBZdWFuDQoN
Cj4gLS0NCj4gQ2hlZXJzLA0KPiANCj4gRGF2aWQNCg==

