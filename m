Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6E6109E556
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2646B0088; Thu, 26 Mar 2026 03:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9A16B0089; Thu, 26 Mar 2026 03:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098D06B008C; Thu, 26 Mar 2026 03:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC3B46B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:30:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93836160C10
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:30:13 +0000 (UTC)
X-FDA: 84587390706.17.B4DAA50
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 886661C000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:30:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=k2AgTeIl;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774510209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gu9ydUtNOVj4676RbmWtvNEjhFwdPOujDEBA4obFDQM=;
	b=eO8P3dzXxb+Zo5USVFvmFLEZnMb/mjcriXW5nJj7hRLe5giq0Y+d/kEMPB/K1crymNiriD
	vTuPblh8OuhHibsF0/3H6Ur/jaQoEOk0XqM/7Vh8vcpEwhvp6xDXAaSn54yu7ZUbulhb30
	fDOQeq0akhRfMUjOX3lmDgXy6Tzv6g4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774510210; a=rsa-sha256;
	cv=fail;
	b=TtLNym7bs7XNXWb1CnKitCsNesN53i7GdVVwoKKDXwlhVZ2C4Tzhy5Rp9njuSge1za6sqs
	lA82Wf0qD+pkAtZVjOObsfBCIdeyAD5CxodzK7Hf6P0nHN+wk6buyZK6mp14neWPjP1r6W
	UAu2TuZOlDUp3uGymQupVot9r5ZGJMw=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=k2AgTeIl;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774510208; x=1806046208;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gu9ydUtNOVj4676RbmWtvNEjhFwdPOujDEBA4obFDQM=;
  b=k2AgTeIlf1MeU5l8i+R60JkYAbeYEYhDqY5OsoWOV5vJYQmJKCDa2uzQ
   AlBeSS4UnTYV02hOHJJQ9i1W3WBgNzUYh4fl9IaLyfTu2LoYzMl2rADin
   1q3e9T7qt7wY8sl/M5BbTxoP8E9w3JJQeSbAGwpviteiTphbSdxRx5A3N
   eHFY42xJkGyfwbh/27UQROoqmfLP4bScjL9uAiDa4wv9KN9kw6l4CY/M2
   tRoJpMecnem1IDq57blCBbiXs373VG+ljHwHoZ7rmXjqZ1AVvFd5O7I3G
   sdsWbFqks2+BETsXqnxMTWHf833LxihVFsI+svxK/RXOXv044jbzF1Dom
   g==;
X-CSE-ConnectionGUID: JljbY2i7TMOPiYetF0zVFg==
X-CSE-MsgGUID: 9lq/mEnPRverM/OSkb44sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="74742523"
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="74742523"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 00:30:07 -0700
X-CSE-ConnectionGUID: aabN2omERAq0VkECufGjVQ==
X-CSE-MsgGUID: qatV4PZGRXyidf6XGWCh1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="222022243"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 00:30:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 00:30:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 26 Mar 2026 00:30:05 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.31) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 00:30:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Maq390+lqG2j+8Azoapi8XmPrmyeLQKm7gZnhOGLZ8W8RSPuAuopryw6gsMUN2o3Md0ZCjeTrs74syGKkx3kUAIVbEdhnJIHRLWE6/S68ajG8i7keBIktv5kF7FQlXGyiaVt0S3GFOOztgELIGHMBRWEnBzHKZqVrV10DEdBriX3BXuMnaKmq6YGMTJsEKvAtQClkcfU7z43cmDwqrKMNkeFPhYFJjdKSSatytgboOmuiAPXFIIo9b/EAmXVkrkqhxbYFn7CM40vMhqXjplxHkbgqPVcc/padhz0bEcfY722aoY93AdMN4Yie3VSauDcw3UoFHFwd4tp//sNajUS8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gu9ydUtNOVj4676RbmWtvNEjhFwdPOujDEBA4obFDQM=;
 b=bp2NxCPQfsoY4WwEIi0QiOaE/yXml+iu14TT/tVH/Kl8q7urTiRz/q7KU+Tc74JAeXc8KNcI3nzuYyAbdS0Yj3FRIXctRzLbImf2kg7wNUPppZvl6qLVDjCmmo5RtoWNA8U2n9n65oswtM1k1VaXQ980u0gzPno+VarE+kRcYAQlGxWIgJPodM3AS3/xj4arqdBVu1hZMV7rdnKP4hLs5MjflRtfojNokoU4KD9x8yGmqcbkxg1MZbkcE6NUHq6fDhuRlrACgCYxV76pbgY66D/RNzPsbcGOUaM+3UWz3uuFZsVAiWT6O/Dq05gv+f7eg6Xx91Txs/DTg9tNbe+pWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA4PR11MB9009.namprd11.prod.outlook.com (2603:10b6:208:56f::21)
 by SA2PR11MB4971.namprd11.prod.outlook.com (2603:10b6:806:118::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Thu, 26 Mar
 2026 07:30:02 +0000
Received: from IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541]) by IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541%7]) with mapi id 15.20.9745.007; Thu, 26 Mar 2026
 07:30:02 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Mike Rapoport
	<rppt@kernel.org>
CC: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, "Chen
 Zhang" <zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHct4abryaKSRoUW0qNNchDaIVkzLW7+GGAgAAJqICAAAMeAIAEZ1oA
Date: Thu, 26 Mar 2026 07:30:01 +0000
Message-ID: <IA4PR11MB90092536DE2D9DF404E3B3EDA356A@IA4PR11MB9009.namprd11.prod.outlook.com>
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
 <48b497e5-1545-4376-a898-f3813a6ef989@kernel.org>
 <acEkfaycrJI-kWjk@kernel.org>
 <168ab3c0-c44f-4d48-b7dc-33196b7ba6a5@kernel.org>
In-Reply-To: <168ab3c0-c44f-4d48-b7dc-33196b7ba6a5@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA4PR11MB9009:EE_|SA2PR11MB4971:EE_
x-ms-office365-filtering-correlation-id: 41e91876-58b6-43c0-a905-08de8b097e26
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info: Zm3ScK1Yxk5YB7VMVwa4bpYA7t6aFSyHXRpThfKwJTb3ziPYJp5jAVQNMS+qLNblsI/hF9sCTD/5SfLisvjFoBww7t8FMPg4ltiS31GUb4z9Lh+rMSKaylYdR1WrYmqysmh+gTik2gFvCvs+fF82NB3a66TlQCqLaKwSF+g8tI39PDuajv5ZfxKEBTR+sZQwCmFdFWnOb8bHjm7uWxPaCcUo3B0drJ60GJ/F8ZlTf19xqjY1RVuY4Id61b5rtfDGpABCTYosdvw6azdl7P02qHq5M5ZbQ9WbNhOOd53SrJ9JOiUGBU/Inmk2CpYDlY3PB+P2/eTpGJ46w8cfkMswUh9Is9DD59rXufd+cO9Var3ah9gkgFChYDYykj57hOdCQWr1Q+xwNfLGsav30eJLypuZf6HFiL6ureAZODnAdNVpIxfp3h+PTjhdfnqYeNsZcSdYu4xb84u/3nzq+w48ykK3YnF8dKWLThnSsB08PeIg4J2lWnCwvIvukreQmNbavlFknWQoh+t0WwgZ1z6mpYrls4USyYAJx/OyobIG/zCbTdSxYd+seN2tsIe4Ca6baRQn0Snsg2kOP4I5ZnKpqskJZf5Wo/2Q0zpSh1noqGbaZ2xsd+IBt4d4Ly4qHd9TGSG6OQ8R2iHM0o5/fvZHAgh1nfJd7cZmXQNoDpQ6lVAgg3Cp2YikJdK53+bW8GJNuN+AJYlyg84fr36pMAi1Yk7n2EVeEH+7QlRWBWJXdqFNzckFXu4DB/i3rkHMysB1idVjYB7hMt69R2yGneLE72BGxPC+MvJ8ctV5IH5j5Sc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9009.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlNzLzYyQ2pZY3pNRFRoWVpJaldPVUM2YVNFbnpxZWQ0N21MbGZQMDRaelBq?=
 =?utf-8?B?Y1oycWF3a1FSc21jZG50OTZncFFSZ0NvdG1SVndqUFBZVEZwZlRvczNJbmNX?=
 =?utf-8?B?dXhxbU10MW5MbU1PN28xaDZBWEllc3NUbnYwVlRBbVBKSUcwL0liU0YvZUNl?=
 =?utf-8?B?TG9wNDlmUXN3QnRld3pPMDBSblphZGZlQ3pXVWRTenFzSEtvSTAyMnlYNTIy?=
 =?utf-8?B?bXVFUmRmTWhleXJVTTVzYjh1ZXJnTFR1OTJlVHNXcEZ5M3EwaTJ6TFV3Z1Vk?=
 =?utf-8?B?Rk9mMnZ3Rncwa3Zpenh0ZjkybEdnYTg2VWUxSk5hNXJBTGMwVjhSTFhkVFhL?=
 =?utf-8?B?d294WE9Sb3prNklDVVMvc0RqejNvQnVlVGVJN0kyV2ozNWxqTmVRV1E4WXRS?=
 =?utf-8?B?NHZDL252d3Z2djFZbGZBREt0ckxZMElJdlViUlZYd1NjTXhTQ2h6WWpWbmRG?=
 =?utf-8?B?bkJGdlhoek44aU1QaEltOExmUHduamZQQnIzZnlVSWE2dGg5L2ZtRzJWNnB3?=
 =?utf-8?B?V1ZlRkt5QlM5cytBYUI4WTVpUEZtWkRCTnNnbHBleWlrbzRpYlFUVklMWWda?=
 =?utf-8?B?UGZ0aHhsNG9lV2FJY0VWWXRkYVYveHN1dzNweVBHWDN1V2xqcm5TYVlkNll6?=
 =?utf-8?B?eWsrYjB6K0NNQnA3SDB5UmZ0RFFiZlZCVFBzTkY4amdpUnlBS2YwdE00U0dr?=
 =?utf-8?B?VU5XaFIyYXFibVVjbXBtdjMrbkJjTGtkanFQR01zMDhiVWJXLzdXSzVEZXNI?=
 =?utf-8?B?NUgxbENhTGc0U2M2R05ZYlhoT0lVc1BveG5lVGFYcmQ5RU1ML1pMbWQ3WXIy?=
 =?utf-8?B?TU9TcHhjR3JLckt6OExkZHozcE9xbForTEo5T0duZG5JYXVLb0ZTWFM3U3lw?=
 =?utf-8?B?cTVTY3lGb2xpamgvZHRSbVRmeGJIaDA4YWE2djM0enFzaWlkNXBqTFlGRkJq?=
 =?utf-8?B?WGF0WVEvVWk0V3pnaDBUQXZYdXNBWVo2Z0ttbmRLMGdWN2x2Q1BFRVc3S2lM?=
 =?utf-8?B?cGpYM0lyUE4xdy8zbjdZMjVFK1pRZzY0U2VlZ0g5dTQzcFJndEgwb1dmbjNr?=
 =?utf-8?B?SU5ZM2ZLUFIrc2ovaGxiRGRTNnhlb2p3aHRGZnhnV3NwOUZvc2dFZk9qUXAz?=
 =?utf-8?B?ZWhrbGJQS0hkV3BTUVRLZTYwUjZFeVZCU3doYnJkck9pWjN3ajJRYVJBL2JG?=
 =?utf-8?B?TDkvckRUelJ4K2hpdm5JN3hHVFFjL1VINDI0RVpUV0lwazBHQVp5Q0x5Nlhx?=
 =?utf-8?B?a1ZzK2c2RjBibnJMZXhuYm1yeXg2RWlPVm5wVTlYTEI1a3R0V2VjL3ZYbXNq?=
 =?utf-8?B?Q2VHbVZ0RlEvR1RHazJ3YnhuUHdobHVhRkNKcDRyWHY4aXBObFpoZHJPWGlt?=
 =?utf-8?B?a1FoRlNBd0M5bXExL28wL0lReStjQUpHQmM4Y0ZYNWdQM1NOUU1Dc0pYajY0?=
 =?utf-8?B?d3I3a2tzSTlab1JVL3l1WUdjRnoxaXZKL1NPR2xmQUczU3gxNEd4dzRsQVB4?=
 =?utf-8?B?M0dZOVc4ZWY5eVJaK3pldzFTYnVNRkNpUlhocHorYkNySjhVVUNPa0Jlc013?=
 =?utf-8?B?Z25oM0xWc2YwSXZRVVVkbU43bmN1d1VDSFBPQ0pUQlNYb3Rpb2JYaURqcjZz?=
 =?utf-8?B?bWpQMWFXUXNWWlpZSHpJeHVKZ2RuMjlxNHZJUkkwVU1QWlViWUVZZEMxek9Y?=
 =?utf-8?B?MlpiZSt6cStsYVUyNkorTzJxM1dDbzM0WHpFaWdxSDEweHNDWEs5ZUdNbWJj?=
 =?utf-8?B?cGUzSVgvVzNXcW9RTkZoNGVWckNzVm9Ld1hZSnRpS3NueVFwZG81VGxUL2ln?=
 =?utf-8?B?NVAwRUJTbitaTHkwOENwaWp1QnJvR3I0VVdKcVByYmVuZFUyRzg3aTFZU1pP?=
 =?utf-8?B?K0s2c005SkxRQnp0b0FNbjltbnNFM1pncWxtNTduVEUrOEhpQlVqSVZjVmw2?=
 =?utf-8?B?ME9mWS9vcVg4SjE2QzJhMzg5aS9GaUwvUkZIV3FqMStnMGxvd2VHeFhuelhs?=
 =?utf-8?B?cUZvUHZRSE1jdkxHTjYrMEwrd0Z0UlVlNkJnbjFFS2lIblNiWnNnU2xBamFS?=
 =?utf-8?B?UXlZQ0VQeFF6L2s3UEoyZ2NTbXlVOTdqMkdRSThySExxNkRwUU9CMFBibkl3?=
 =?utf-8?B?bWUvZXJYOFFXMDRuTmx1S3NMMENObE1iclJ1bWphUmZHV1FkK0c1TlR5WEdF?=
 =?utf-8?B?RWZFeUQwanlXRjRYOHVJN0V6OHhDZnVKSHA5d3hVNlRHeEoyYmg4cW0vNVpm?=
 =?utf-8?B?TU8zNW16ZStUdzVHOXV5YWVqWTRKVmNvMGRIb3d3SjFLS1k1U3p3ZjByTC9y?=
 =?utf-8?Q?Lr6ZV0p8OwG2hU1C9G?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: vcidRomWMOuiNlGj1Znf55gE6+aThVfiRUNvXdF5e2VwQ2SnlwHlM6kGvfY9EiDzX/8kMC1PfkRBwUqEkprPfGmC2uSIfB8Uh+xxAFy5buHjwsNINX17kWqOj0bkYAgrDS2qCEdlB4/FAuvtkwyihduj3WlZW8X0LylogiwkXvPPDhW4YrKyMwB8zz8y+ACHpCS3/Fc5BguMIgajduiYhK36d4D1s8aFZBGKuO3W3a1N5WxL46zewGjLtN6HGlO2leHc9mygGNAxA1G4miNnmkfWyOGth9NmGKE6+f60J5cNHdZFi/CaG3K2MBo5vfOU1F0fqLfU5i9ETlSdneGgcw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9009.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41e91876-58b6-43c0-a905-08de8b097e26
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2026 07:30:02.0297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G8rBLtiBX/Fq3IYMYktZiJsncSOhjhdwywkCvcNrFSmqlCb7mVjxlfyS3dgtLKD2bnA2UH/0LaPwUgirNiuWcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4971
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Stat-Signature: miuwg9xkqcwz6b6ejcjpbk43xhzcfqf5
X-Rspamd-Queue-Id: 886661C000C
X-Rspam-User: 
X-HE-Tag: 1774510208-511669
X-HE-Meta: U2FsdGVkX19Fbz1sb7uSMsW2eraV+FQ5DZ9QdmpCEA15FLfT1eqjk7sTSb0lyxAnYZuQv2aQxeT9FNH2Xq5Ob0ogvOx/sXx9ZS24R+wOZlGSqW9vQZs8YP/k6gmb28iCO39dyHVVMjmTdD0MAWzbyTvyJY17sgEbeB234wsxfHINr3toTz8W0h1oahDWB5UevZGRQnSTPGPcUChObmyeUuOdNw3Gf5S9FSLg5mBW9ZiwJAMfrKVT8/hmk4QMXtSzzd6HcvMg+cph6jF2eyi8j+8MdVas1pU4EV9kDStV54565KO6x7RNL/BfNwEE51Y+dE00HL53befqayFF3SOSQMyI07irPAKNrX5Kg/pdUDe+r3cGTvTOuyMmguEd0kJ51aFbXWZ7lcDTqkq1+68Li+fu0bzB6RYTFScQdU6l/3P/kC+9zYH9OYlq7olWK1kdCASGS+s6plpN5CF54wrisx5XYWFkerV5ncZyI5dJ7HKHhubpW9fjfGVvVCO2hez3AIwL94H6/5uVZBacpqdVZKymK7e51UIyjED2R10p3C/uRhUK6t9dCUTzNni9F9DfWOw79ychyeL+0n8QYQjiqH9L8gsrPu4e5VFZcD+ZzEXYYIo8eP11VsPL+TLo6j0Ty5Ch5z/rexBrIj0phzV6JLBMVDg6Vu89uK9PrsMR2RS8hba+ukvm26yFonPC0E4rBldDHy0W7G3KCQY6+1IamNVxZJ6t3roBO72VoSVNMSsoCHZykhFVHioZNz+8y7IP7yIdnei1+kbw3GkMBLmIzaWLfvCrPI9ii8cLL6wf2uk/pYpppxTOskWgyDinlkl8X0X0XudceWanEjBw5N6YvkVyr0dxuPdf8VsTT4cXMZVnTmmg8ZQFTdABAQ8ZsLKKq7pkvlPvgIJ0UTijiWrCbPV7R9iv+OK4bXxpyq+f51l+rpa9EnelIcrIsWLF1I615NPxrHNxEhfnvMcG08b
 KtOtNz9M
 a5c+ynDkfPnczXJM3UwA9KvRPcTug6wb2EpywkK6GauZFNaaHZgRIj0eZEF1Sh6gqKBW4tC2x3KzuceeF1s2aQASPSmIpMiPLjtii5Hflkb8yYin7eyYXzWNRQolum8Ug/30WgIlVC0HXa2jTW7t+vGDpHQdK4Afg9Y8dAprwPQnRXFv4uUu1Svgyo10bsCcyeFQKdjOaUBRz6++472YRBACLYeLfLmILa8+AVI2L3VpOafMibpEsm4z8uljvis5T/TkKxuzDszdUvmfUQYlqOzuhQud8y9AMDOw8brEO3GNKcwW1JDjodD+NMfOBTy8XNQh415Kk/paGeQSO93aOPxbpN45+itXWUqpYdeFjn23HUsmvALmt9VxlxNIPty/66IlcNCmlmUyiYXgaCHczjOVQTAjHzp2NLzBjZUZf5cvv1nY1MlmKCUDlLss6HLlhDmMs5bFsSQjCx5J1poSReB4+dlY0pIobDVDXxilXiWw/w1HcjECpdFTae3GOUDgAojgFwRrwvhGf/IqAIstQMxyoAL6SSsnX8td7Z7Gu7dmvKmfFISrEzLdsVZ91kARJw4A8UyEIjMJosh0d0/3fz91UXfzrzEq+c7uVv7eWtma0ipE/qOxdqKnGYkNgoOLhYj2Um4Ej/VYdIxrJvVUc9CkWATip4vHxuBlYSF6dKNRkeWKgJ4VXsrG4yom9FviYaoTp7TzX0qoDbY2RUjKEklvfj529eA4+TRjNuiMY9HcrN9ytqs4vy+lTHSZLC2D2rGg6+C2/aZrDUkWG8SsYwjEKMIH5Y4iLygWjLmdXA6QkKylGPj3c37lGjih4vdoeYydteUAZFliupak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogTW9uZGF5LCBNYXJjaCAyMywgMjAyNiA3
OjQyIFBNDQo+IFRvOiBNaWtlIFJhcG9wb3J0IDxycHB0QGtlcm5lbC5vcmc+DQo+IENjOiBMaXUs
IFl1YW4xIDx5dWFuMS5saXVAaW50ZWwuY29tPjsgT3NjYXIgU2FsdmFkb3IgPG9zYWx2YWRvckBz
dXNlLmRlPjsNCj4gV2VpIFlhbmcgPHJpY2hhcmQud2VpeWFuZ0BnbWFpbC5jb20+OyBsaW51eC1t
bUBrdmFjay5vcmc7IEh1LCBZb25nDQo+IDx5b25nLmh1QGludGVsLmNvbT47IFpvdSwgTmFuaGFp
IDxuYW5oYWkuem91QGludGVsLmNvbT47IFRpbSBDaGVuDQo+IDx0aW0uYy5jaGVuQGxpbnV4Lmlu
dGVsLmNvbT47IFpodW8sIFFpdXh1IDxxaXV4dS56aHVvQGludGVsLmNvbT47IENoZW4sIFl1DQo+
IEMgPHl1LmMuY2hlbkBpbnRlbC5jb20+OyBEZW5nLCBQYW4gPHBhbi5kZW5nQGludGVsLmNvbT47
IExpLCBUaWFueW91DQo+IDx0aWFueW91LmxpQGludGVsLmNvbT47IENoZW4gWmhhbmcgPHpoYW5n
Y2hlbi5raWRkQGpkLmNvbT47IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0hdIG1tL21lbW9yeSBob3RwbHVnL3VucGx1ZzogT3B0aW1pemUgem9u
ZSBjb250aWd1b3VzDQo+IGNoZWNrIHdoZW4gY2hhbmdpbmcgcGZuIHJhbmdlDQo+IA0KPiBPbiAz
LzIzLzI2IDEyOjMxLCBNaWtlIFJhcG9wb3J0IHdyb3RlOg0KPiA+IE9uIE1vbiwgTWFyIDIzLCAy
MDI2IGF0IDExOjU2OjM1QU0gKzAxMDAsIERhdmlkIEhpbGRlbmJyYW5kIChBcm0pIHdyb3RlOg0K
PiA+PiBPbiAzLzE5LzI2IDEwOjU2LCBZdWFuIExpdSB3cm90ZToNCj4gPg0KPiA+IC4uLg0KPiA+
DQo+ID4+PiBkaWZmIC0tZ2l0IGEvbW0vbW1faW5pdC5jIGIvbW0vbW1faW5pdC5jDQo+ID4+PiBp
bmRleCBkZjM0Nzk3NjkxYmQuLjk2NjkwZTU1MDAyNCAxMDA2NDQNCj4gPj4+IC0tLSBhL21tL21t
X2luaXQuYw0KPiA+Pj4gKysrIGIvbW0vbW1faW5pdC5jDQo+ID4+PiBAQCAtOTQ2LDYgKzk0Niw3
IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBtZW1tYXBfaW5pdF96b25lX3JhbmdlKHN0cnVjdA0KPiB6
b25lICp6b25lLA0KPiA+Pj4gIAl1bnNpZ25lZCBsb25nIHpvbmVfc3RhcnRfcGZuID0gem9uZS0+
em9uZV9zdGFydF9wZm47DQo+ID4+PiAgCXVuc2lnbmVkIGxvbmcgem9uZV9lbmRfcGZuID0gem9u
ZV9zdGFydF9wZm4gKyB6b25lLT5zcGFubmVkX3BhZ2VzOw0KPiA+Pj4gIAlpbnQgbmlkID0gem9u
ZV90b19uaWQoem9uZSksIHpvbmVfaWQgPSB6b25lX2lkeCh6b25lKTsNCj4gPj4+ICsJdW5zaWdu
ZWQgbG9uZyB6b25lX2hvbGVfc3RhcnQsIHpvbmVfaG9sZV9lbmQ7DQo+ID4+Pg0KPiA+Pj4gIAlz
dGFydF9wZm4gPSBjbGFtcChzdGFydF9wZm4sIHpvbmVfc3RhcnRfcGZuLCB6b25lX2VuZF9wZm4p
Ow0KPiA+Pj4gIAllbmRfcGZuID0gY2xhbXAoZW5kX3Bmbiwgem9uZV9zdGFydF9wZm4sIHpvbmVf
ZW5kX3Bmbik7DQo+ID4+PiBAQCAtOTU3LDggKzk1OCwxOSBAQCBzdGF0aWMgdm9pZCBfX2luaXQg
bWVtbWFwX2luaXRfem9uZV9yYW5nZShzdHJ1Y3QNCj4gem9uZSAqem9uZSwNCj4gPj4+ICAJCQkg
IHpvbmVfZW5kX3BmbiwgTUVNSU5JVF9FQVJMWSwgTlVMTCwgTUlHUkFURV9NT1ZBQkxFLA0KPiA+
Pj4gIAkJCSAgZmFsc2UpOw0KPiA+Pj4NCj4gPj4+IC0JaWYgKCpob2xlX3BmbiA8IHN0YXJ0X3Bm
bikNCj4gPj4+ICsJV1JJVEVfT05DRSh6b25lLT5wYWdlc193aXRoX29ubGluZV9tZW1tYXAsDQo+
ID4+PiArCQkgICBSRUFEX09OQ0Uoem9uZS0+cGFnZXNfd2l0aF9vbmxpbmVfbWVtbWFwKSArDQo+
ID4+PiArCQkgICAoZW5kX3BmbiAtIHN0YXJ0X3BmbikpOw0KPiA+Pj4gKw0KPiA+Pj4gKwlpZiAo
KmhvbGVfcGZuIDwgc3RhcnRfcGZuKSB7DQo+ID4+PiAgCQlpbml0X3VuYXZhaWxhYmxlX3Jhbmdl
KCpob2xlX3Bmbiwgc3RhcnRfcGZuLCB6b25lX2lkLCBuaWQpOw0KPiA+Pj4gKwkJem9uZV9ob2xl
X3N0YXJ0ID0gY2xhbXAoKmhvbGVfcGZuLCB6b25lX3N0YXJ0X3BmbiwNCj4gem9uZV9lbmRfcGZu
KTsNCj4gPj4+ICsJCXpvbmVfaG9sZV9lbmQgPSBjbGFtcChzdGFydF9wZm4sIHpvbmVfc3RhcnRf
cGZuLA0KPiB6b25lX2VuZF9wZm4pOw0KPiA+Pj4gKwkJaWYgKHpvbmVfaG9sZV9zdGFydCA8IHpv
bmVfaG9sZV9lbmQpDQo+ID4+PiArCQkJV1JJVEVfT05DRSh6b25lLT5wYWdlc193aXRoX29ubGlu
ZV9tZW1tYXAsDQo+ID4+PiArCQkJCSAgIFJFQURfT05DRSh6b25lLT5wYWdlc193aXRoX29ubGlu
ZV9tZW1tYXApICsNCj4gPj4+ICsJCQkJICAgKHpvbmVfaG9sZV9lbmQgLSB6b25lX2hvbGVfc3Rh
cnQpKTsNCj4gPj4+ICsJfQ0KPiA+Pg0KPiA+PiBUaGUgcmFuZ2UgY2FuIGhhdmUgbGFyZ2VyIGhv
bGVzIHdpdGhvdXQgYSBtZW1tYXAsIGFuZCBJIHRoaW5rIHdlIHdvdWxkDQo+IGJlDQo+ID4+IG1p
c3NpbmcgcGFnZXMgaGFuZGxlZCBieSB0aGUgb3RoZXIgaW5pdF91bmF2YWlsYWJsZV9yYW5nZSgp
IGNhbGw/DQo+ID4+DQo+ID4+DQo+ID4+IFRoZXJlIGlzIG9uZSBxdWVzdGlvbiBmb3IgTWlrZSwg
dGhvdWdoOiBjb3VsZG4ndCBpdCBoYXBwZW4gdGhhdCB0aGUNCj4gPj4gaW5pdF91bmF2YWlsYWJs
ZV9yYW5nZSgpIGNhbGwgaW4gbWVtbWFwX2luaXQoKSB3b3VsZCBpbml0aWFsaXplDQo+ID4+IHRo
ZSBtZW1tYXAgb3V0c2lkZSBvZiB0aGUgbm9kZS96b25lIHNwYW4/DQo+ID4NCj4gPiBZZXMsIGFu
ZCBpdCBtb3N0IGxpa2VseSB3aWxsLg0KPiA+DQo+ID4gVmVyeSBjb21tb24gZXhhbXBsZSBpcyBw
YWdlIDAgb24geDg2IHN5c3RlbXM6DQo+ID4NCj4gPiBbICAgIDAuMDEyMTk2XSAgIERNQSAgICAg
IFttZW0gMHgwMDAwMDAwMDAwMDAxMDAwLTB4MDAwMDAwMDAwMGZmZmZmZl0NCj4gPiBbICAgIDAu
MDEyMjIxXSBPbiBub2RlIDAsIHpvbmUgRE1BOiAxIHBhZ2VzIGluIHVuYXZhaWxhYmxlIHJhbmdl
cw0KPiA+IFsgICAgMC4wMTIyMDVdIEVhcmx5IG1lbW9yeSBub2RlIHJhbmdlcw0KPiA+IFsgICAg
MC4wMTIyMDZdICAgbm9kZSAgIDA6IFttZW0gMHgwMDAwMDAwMDAwMDAxMDAwLTB4MDAwMDAwMDAw
MDA5ZWZmZl0NCj4gPg0KPiA+IFRoZSB1bmF2YWlsYWJsZSBwYWdlIGluIHpvbmUgRE1BIGlzIHRo
ZSBwYWdlIGZyb20gIDB4MCB0byAweDEwMDAgdGhhdCBpcw0KPiA+IG5laXRoZXIgaW4gbm9kZSAw
IG5vciBpbiB6b25lIERNQS4NCj4gPg0KPiA+IEZvciBaT05FX05PUk1BTCBpdCB3b3VsZCBiZSBh
IG1vcmUgcGF0aG9sb2dpY2FsIGNhc2Ugd2hlbiB6b25lL25vZGUgc3Bhbg0KPiA+IGVuZHMgaW4g
YSBtaWRkbGUgb2YgYSBzZWN0aW9uLCBidXQgdGhhdCdzIHN0aWxsIHBvc3NpYmxlLg0KPiA+DQo+
ID4+IElmIHNvLCBJIHdvbmRlciB3aGV0aGVyIHdlIHdvdWxkIHdhbnQgdG8gYWRqdXN0IHRoZSBu
b2RlK3pvbmUgc3BhY2UgdG8NCj4gPj4gaW5jbHVkZSB0aGVzZSByYW5nZXMuDQo+ID4+DQo+ID4+
IExhdGVyIG1lbW9yeSBvbmxpbmluZyBjb3VsZCBtYWtlIHRoZXNlIHJhbmdlcyBzdWRkZW5seSBm
YWxsIGludG8gdGhlDQo+ID4+IG5vZGUvem9uZSBzcGFuLg0KPiA+DQo+ID4gQnV0IGRvZXNuJ3Qg
bWVtb3J5IG9ubGluaW5nIGFsd2F5cyBoYXBwZW4gYXQgc2VjdGlvbiBib3VuZGFyaWVzPw0KPiAN
Cj4gU3VyZSwgYnV0IGFzc3VtZSBaT05FX05PUk1BTCBlbmRzIGluIHRoZSBtaWRkbGUgb2YgYSBz
ZWN0aW9uLCBhbmQgdGhlbg0KPiB5b3UgaG90cGx1ZyB0aGUgbmV4dCBzZWN0aW9uLg0KPiANCj4g
VGhlbiwgdGhlIHpvbmUgc3BhbnMgdGhhdCBtZW1tYXAuIHpvbmUtPnBhZ2VzX3dpdGhfb25saW5l
X21lbW1hcCB3aWxsIGJlDQo+IHdyb25nLg0KPiANCj4gT25jZSB3ZSB1bnBsdWcgdGhlIGhvdHBs
dWdnZWQgc2VjdGlvbiwgem9uZSBzaHJpbmtpbmcgY29kZSB3aWxsIHN0dW1ibGUNCj4gb3ZlciB0
aGUgd2hvbGUtcGZucyBhbmQgYXNzdW1lIHRoZXkgYmVsb25nIHRvIHRoZSB6b25lLg0KPiB6b25l
LT5wYWdlc193aXRoX29ubGluZV9tZW1tYXAgd2lsbCBiZSB3cm9uZy4NCj4gDQo+IHpvbmUtPnBh
Z2VzX3dpdGhfb25saW5lX21lbW1hcCBiZWluZyB3cm9uZyBtZWFucyB0aGF0IGl0IGlzIHNtYWxs
ZXIgdGhhbg0KPiBpdCBzaG91bGQuIEkgZ3Vlc3MsIGl0IHdvdWxkIG5vdCBiZSBicm9rZW4sIGJ1
dCB3ZSB3b3VsZCBmYWlsIHRvIGRldGVjdA0KPiBjb250aWd1b3VzIHpvbmVzLg0KPiANCj4gSWYg
dGhlcmUgd291bGQgYmUgYW4gZWFzeSB3YXkgdG8gYXZvaWQgdGhhdCwgdGhhdCB3b3VsZCBiZSBj
bGVhbmVyLg0KDQpJIHRyeSB0byBnZXQgeW91ciBwb2ludHMgYW5kIGRyYWZ0IGJlbG93IGNvZGVz
Lg0KDQorc3RhdGljIHZvaWQgYWRqdXN0X3BhZ2VzX3dpdGhfb25saW5lX21lbW1hcChzdHJ1Y3Qg
em9uZSAqem9uZSwgbG9uZyBucl9wYWdlcywNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgbG9uZyBhZGRlZF9zcGFubmVkX3BhZ2VzKQ0KK3sNCisgICAgICAgaWYg
KGFkZGVkX3NwYW5uZWRfcGFnZXMgPT0gbnJfcGFnZXMpDQorICAgICAgICAgICAgICAgem9uZS0+
cGFnZXNfd2l0aF9vbmxpbmVfbWVtbWFwICs9IG5yX3BhZ2VzDQorICAgICAgIGVsc2UNCisgICAg
ICAgICAgICAgICB6b25lLT5wYWdlc193aXRoX29ubGluZV9tZW1tYXAgKz0gYWRkZWRfc3Bhbm5l
ZF9wYWdlczsNCit9DQogLyoNCiAgKiBNdXN0IGJlIGNhbGxlZCB3aXRoIG1lbV9ob3RwbHVnX2xv
Y2sgaW4gd3JpdGUgbW9kZS4NCiAgKi8NCkBAIC0xMTU0LDYgKzExNjIsNyBAQCBpbnQgb25saW5l
X3BhZ2VzKHVuc2lnbmVkIGxvbmcgcGZuLCB1bnNpZ25lZCBsb25nIG5yX3BhZ2VzLA0KICAgICAg
ICBjb25zdCBpbnQgbmlkID0gem9uZV90b19uaWQoem9uZSk7DQogICAgICAgIGludCBuZWVkX3pv
bmVsaXN0c19yZWJ1aWxkID0gMDsNCiAgICAgICAgdW5zaWduZWQgbG9uZyBmbGFnczsNCisgICAg
ICAgdW5zaWduZWQgbG9uZyBvbGRfc3Bhbm5lZF9wYWdlcyA9IHpvbmUtPnNwYW5uZWRfcGFnZXM7
DQogICAgICAgIGludCByZXQ7DQoNCiAgICAgICAgLyoNCkBAIC0xMjA2LDYgKzEyMTUsOCBAQCBp
bnQgb25saW5lX3BhZ2VzKHVuc2lnbmVkIGxvbmcgcGZuLCB1bnNpZ25lZCBsb25nIG5yX3BhZ2Vz
LA0KDQogICAgICAgIG9ubGluZV9wYWdlc19yYW5nZShwZm4sIG5yX3BhZ2VzKTsNCiAgICAgICAg
YWRqdXN0X3ByZXNlbnRfcGFnZV9jb3VudChwZm5fdG9fcGFnZShwZm4pLCBncm91cCwgbnJfcGFn
ZXMpOw0KKyAgICAgICBhZGp1c3RfcGFnZXNfd2l0aF9vbmxpbmVfbWVtbWFwKHpvbmUsIG5yX3Bh
Z2VzLA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHpvbmUtPnNwYW5u
ZWRfcGFnZXMgLSBvbGRfc3Bhbm5lZF9wYWdlcyk7DQoNCiAgICAgICAgaWYgKG5vZGVfYXJnLm5p
ZCA+PSAwKQ0KICAgICAgICAgICAgICAgIG5vZGVfc2V0X3N0YXRlKG5pZCwgTl9NRU1PUlkpOw0K
QEAgLTE5MDUsNiArMTkxNiw3IEBAIGludCBvZmZsaW5lX3BhZ2VzKHVuc2lnbmVkIGxvbmcgc3Rh
cnRfcGZuLCB1bnNpZ25lZCBsb25nIG5yX3BhZ2VzLA0KICAgICAgICBzdHJ1Y3Qgbm9kZV9ub3Rp
Znkgbm9kZV9hcmcgPSB7DQogICAgICAgICAgICAgICAgLm5pZCA9IE5VTUFfTk9fTk9ERSwNCiAg
ICAgICAgfTsNCisgICAgICAgdW5zaWduZWQgbG9uZyBvbGRfc3Bhbm5lZF9wYWdlcyA9IHpvbmUt
PnNwYW5uZWRfcGFnZXM7DQogICAgICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQogICAgICAgIGNo
YXIgKnJlYXNvbjsNCiAgICAgICAgaW50IHJldDsNCkBAIC0yMDUxLDYgKzIwNjMsOCBAQCBpbnQg
b2ZmbGluZV9wYWdlcyh1bnNpZ25lZCBsb25nIHN0YXJ0X3BmbiwgdW5zaWduZWQgbG9uZyBucl9w
YWdlcywNCiAgICAgICAgLyogcmVtb3ZhbCBzdWNjZXNzICovDQogICAgICAgIGFkanVzdF9tYW5h
Z2VkX3BhZ2VfY291bnQocGZuX3RvX3BhZ2Uoc3RhcnRfcGZuKSwgLW1hbmFnZWRfcGFnZXMpOw0K
ICAgICAgICBhZGp1c3RfcHJlc2VudF9wYWdlX2NvdW50KHBmbl90b19wYWdlKHN0YXJ0X3Bmbiks
IGdyb3VwLCAtbnJfcGFnZXMpOw0KKyAgICAgICBhZGp1c3RfcGFnZXNfd2l0aF9vbmxpbmVfbWVt
bWFwKHpvbmUsIG5yX3BhZ2VzLA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHpvbmUtPnNwYW5uZWRfcGFnZXMgLSBvbGRfc3Bhbm5lZF9wYWdlcyk7DQoNCkJ0dywgY2Fu
IHdlIGludHJvZHVjZSBhIG5ldyBrZXJuZWwgY29tbWFuZC1saW5lIHBhcmFtZXRlciB0byBhbGxv
dyB1c2VycyB0byBzZWxlY3QgDQp0aGUgbWVtb3J5IGJsb2NrIHNpemU/IFRoaXMgY291bGQgYWxz
byBhZGRyZXNzIHRoZSBjdXJyZW50IGlzc3VlLg0KDQpUZXN0IFJlc3VsdHMgYXMgYmVsb3csIG1l
bW9yeSBibG9jayBzaXplIDEyOE1CIFZzLiAyR0INCistLS0tLS0tLS0tLS0tLS0tKy0tLS0tLSst
LS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSsNCnwgICAgICAg
ICAgICAgICAgfCBTaXplIHwgICAgMTI4TUcgICAgICB8ICAgIDJHQiAgICAgICB8IFRpbWUgUmVk
dWN0aW9uIHwNCnwgICAgICAgICAgICAgICAgKy0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0t
LS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSsNCnwgUGx1ZyBNZW1vcnkgICAgfCAyNTZHIHwgICAg
ICAxMHMgICAgICB8ICAgICAgIDNzICAgICB8ICAgICAgIDcwJSAgICAgIHwNCnwgICAgICAgICAg
ICAgICAgKy0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0t
LS0tLSsNCnwgICAgICAgICAgICAgICAgfCA1MTJHIHwgICAgICAzNnMgICAgICB8ICAgICAgIDdz
ICAgICB8ICAgICAgIDgxJSAgICAgIHwNCistLS0tLS0tLS0tLS0tLS0tKy0tLS0tLSstLS0tLS0t
LS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSsNCiANCistLS0tLS0tLS0t
LS0tLS0tKy0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0t
LS0tLSsNCnwgICAgICAgICAgICAgICAgfCBTaXplIHwgICAgMTI4TUcgICAgICB8ICAgIDJHQiAg
ICAgICB8IFRpbWUgUmVkdWN0aW9uIHwNCnwgICAgICAgICAgICAgICAgKy0tLS0tLSstLS0tLS0t
LS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSsNCnwgVW5wbHVnIE1lbW9y
eSAgfCAyNTZHIHwgICAgICAxMXMgICAgICB8ICAgICAgM3MgICAgICB8ICAgICAgIDcyJSAgICAg
IHwNCnwgICAgICAgICAgICAgICAgKy0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0t
LS0rLS0tLS0tLS0tLS0tLS0tLSsNCnwgICAgICAgICAgICAgICAgfCA1MTJHIHwgICAgICAzNnMg
ICAgICB8ICAgICAgN3MgICAgICB8ICAgICAgIDgxJSAgICAgIHwNCistLS0tLS0tLS0tLS0tLS0t
Ky0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLSsN
Cg0KQW5kIEkgc2VlIHRoZSBVViBzeXN0ZW0gaGFzIGFscmVhZHkgdGhpcyAoS2VybmVsIHBhcmFt
ZXRlciBpcyB1dl9tZW1ibGtzaXplKS4gDQpJIHRoaW5rIGlmIHdlIGNhbiBpbnRyb2R1Y2UgYSBj
b21tb24ga2VybmVsIHBhcmFtZXRlciBmb3IgbWVtb3J5IGJsb2NrIHNpemUgY29uZmlndXJhdGlv
bj8NCg0KLS0tIGEvYXJjaC94ODYvbW0vaW5pdF82NC5jDQorKysgYi9hcmNoL3g4Ni9tbS9pbml0
XzY0LmMNCkBAIC0xNDU4LDYgKzE0NTgsMjYgQEAgaW50IF9faW5pdCBzZXRfbWVtb3J5X2Jsb2Nr
X3NpemVfb3JkZXIodW5zaWduZWQgaW50IG9yZGVyKQ0KICAgICAgICByZXR1cm4gMDsNCiB9DQoN
CitzdGF0aWMgaW50IF9faW5pdCBjbWRsaW5lX3BhcnNlX21lbW9yeV9ibG9ja19zaXplKGNoYXIg
KnApDQorew0KKyAgICB1bnNpZ25lZCBsb25nIHNpemU7DQorICAgIGNoYXIgKmVuZHAgPSBwOw0K
KyAgICBpbnQgcmV0Ow0KKw0KKyAgICBzaXplID0gbWVtcGFyc2UocCwgJmVuZHApOw0KKyAgICBp
ZiAoKmVuZHAgIT0gJ1wwJyB8fCAhaXNfcG93ZXJfb2ZfMihzaXplKSkNCisgICAgICAgIHJldHVy
biAtRUlOVkFMOw0KKw0KKyAgICByZXQgPSBzZXRfbWVtb3J5X2Jsb2NrX3NpemVfb3JkZXIoaWxv
ZzIoc2l6ZSkpOw0KKyAgICBpZiAocmV0KQ0KKyAgICAgICAgcmV0dXJuIHJldDsNCisNCisgICAg
cHJfaW5mbygieDg2L21tOiBtZW1vcnlfYmxvY2tfc2l6ZSBjbWRsaW5lIG92ZXJyaWRlOiAlbGRN
QlxuIiwNCisgICAgICAgIHNpemUgPj4gMjApOw0KKyAgICByZXR1cm4gMDsNCit9DQorZWFybHlf
cGFyYW0oIng4Nl9tZW1vcnlfYmxvY2tfc2l6ZSIsIGNtZGxpbmVfcGFyc2VfbWVtb3J5X2Jsb2Nr
X3NpemUpOw0KDQo+IC0tDQo+IENoZWVycywNCj4gDQo+IERhdmlkDQo=

