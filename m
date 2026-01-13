Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 040CBCF45C6
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F20A6B0005; Mon, 12 Jan 2026 20:07:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA066B0088; Mon, 12 Jan 2026 20:07:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7E56B008A; Mon, 12 Jan 2026 20:07:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 266296B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:07:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AFCFCD2CEF
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:07:36 +0000 (UTC)
X-FDA: 84325152912.06.CBFD2B5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8291DA0017
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:07:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j8G0WtuG;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768266453; a=rsa-sha256;
	cv=fail;
	b=mhNkrIy97/RZaki0vd+2d7Wsg43f5U4DtEf6q6W4wrFPwcoEyecCJmqzAr0DKDNAm7a4xQ
	QG+dVX5Dvz46TNPIiZELL5iZhhqihw/LO3UwbHtC9Hvrwkn+/SVGq0NyJgVX/ttBQQoChY
	vmbyQarIv6l4OZdap/rAHbf8SBWUNko=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j8G0WtuG;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768266453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYMarj75tuUhVe3YIvzMfki/HmkTpXw6mCy2EZZHS4c=;
	b=PTS8bJp9dJuiwfoglozBoMKY9j/c8KA1+H3329COZ+GXgxoz9bhe2xIp/df7B12X2C6k12
	zBz6f5AcsIvE9zTeS031HSN+ITshBae1zY04ZVwYXsaIDR8fP25Bdr6kV2WEfG4y1CKUJq
	2lY/8DCZQEiytYH1VO9+oi41dSnNSSY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768266452; x=1799802452;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Y9iiEyURQIXRsV4e5U2LxOIMXzLvewN8VrXTTI65AX0=;
  b=j8G0WtuG7y7dp+y/1X/ZJ2jJ3xsZqOBTRMLiq5Je7FsuBgBJQBrJcxuC
   QtUVPpwlMdgZfwk0c6Neiv/ANkqj6mBbwg1q1zx23FmCsh9JMHt/U49KR
   SBJ6L+l7rxbaHKDOyPr6fThn5SGJL1fZFKG9XzGdIp2Qrq6TFHV+u6wRY
   7pqGqzd6KQ9FuKRGHprKmrvuh4DmJ4Wn8UU8U5S10804/l8/IAQzcMY4r
   HvYxjaS+GoY+891zy0xHtRAYS6iN6ZeGEm+RJFa2LJydFsFj9sU111+hA
   zo5YIyfjdl/9WDZl6nfpjA90AJNbePOMlb+WSBLF73EqEtfblgoisohYk
   w==;
X-CSE-ConnectionGUID: KVNWjPpJRJugaUDWyLppxg==
X-CSE-MsgGUID: CYJlGdZMQT6Fqqre5zk9Hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="73179908"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="73179908"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 17:07:28 -0800
X-CSE-ConnectionGUID: d//WQFU7TaeJCWLjpU3yvg==
X-CSE-MsgGUID: C6hfhOXiRlWNVJoPGq8VUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204332191"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 17:07:28 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 17:07:27 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 17:07:27 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.40)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 17:07:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wMgecu74b7fyebrKgHtjUf3zbjkxlmVuQvKcNprVt8lxdgyAdgR0iKAcaZT7bIBn7+/SErtk7r1KA2iJF8b7RyTlV+q0RFTFg+4Sa9DfWEzQkt372YKjAE+j2hUUWiDtDFiXmkAj/yB/k5V5Bfx35MPlon86P6JBstVoOuor3LnwN1BfDVZNjTOYxNj06jqiaKYy38Jk4yKiVZEeXAqEwgt0QNCwAM79VgSOz1sVgHPBxExq7U7M4Chz9y/D8rZT11LSy6lKrkBxpbcP7zp5YODctzeQz3FyrwxjxXS+Li2rNGRf6TEqJS+or7WwcvZZGBNNub4QCWxx+CVFyiD3tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mYMarj75tuUhVe3YIvzMfki/HmkTpXw6mCy2EZZHS4c=;
 b=b7kPRNVR3w0CDxin109g7/BIBI79ucpyfdCWQ8FZP4D2rVshn3RUO7i0dMZeEdnwsncetSJIFDIwzxSeuIHelW936dp2rP6sKnHbPKTQsjeG4I3GW830lrIMwdfCWBOUspyx4qQUNNak7eavyIs7SKSBNyjqx2jpzUzblgyIvdgKoKJ90FubsyR1uNR9iqP/gkHLkYYbMwLzjX9ZlWkbiILMNILem6Kv3zJ6p1yfKVJUCTgtbjxfKRXpRje91eZqvQ2C+ZbYV5e3BgtowrT6Owh1Zg15ZU4Hgpi/I8zxp9MDkh5izI+Xe4ff6GKyDX48bWbmHlmHeGQojjEqPj9ngg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by IA3PR11MB9207.namprd11.prod.outlook.com (2603:10b6:208:578::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 01:07:20 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Tue, 13 Jan 2026
 01:07:20 +0000
Date: Mon, 12 Jan 2026 17:07:17 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Alistair Popple <apopple@nvidia.com>
CC: Balbir Singh <balbirs@nvidia.com>, Francois Dugast
	<francois.dugast@intel.com>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/7] mm/zone_device: Add
 free_zone_device_folio_prepare() helper
Message-ID: <aWWaxakpRiapWw5X@lstrano-desk.jf.intel.com>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-3-francois.dugast@intel.com>
 <706ba3a6-5be2-46d7-9e7d-d613f2e061cc@nvidia.com>
 <aWRLeoUJAYAWbLD3@lstrano-desk.jf.intel.com>
 <k25qmqrfmhzkls2ngdaq4wdk3xtl3epv4z3dvukon5yj2cb2hl@yci7xdpvauh7>
 <aWWQhOD8g8oLz1vX@lstrano-desk.jf.intel.com>
 <ntawk3mmrg2qihe24dk34pevtlgj3cdxnshau3wgyi5lygtuvo@jcsz5hmt4xth>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ntawk3mmrg2qihe24dk34pevtlgj3cdxnshau3wgyi5lygtuvo@jcsz5hmt4xth>
X-ClientProxiedBy: SJ2PR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:a03:505::9) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|IA3PR11MB9207:EE_
X-MS-Office365-Filtering-Correlation-Id: 214aa8de-f9cc-4fe9-7eaf-08de524019f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dUNRMks4RnphUlBaMnJPdDlqbXZPb3NpZEVzblJGVW9kc2FudVQxNzE5WTZP?=
 =?utf-8?B?Um0yL0g0MWYvTCs4TnA1a0FNcFBlMkZWTDNyNE9IamgzN0R4cktQakxtOXp0?=
 =?utf-8?B?RG0vM1NFbE91VFpON2h1ZXJoOGFxTXZ5Z2NZOE5SWGxpQ0djZ0UyTW4veXRt?=
 =?utf-8?B?Vk00MnZ5d0xEZWtDN29OdWYrL1ptbGhWUTdCVWRHMTl5U2hTUTVwM2duS2lz?=
 =?utf-8?B?NHZCbXY3V1pYa0lrRGZSN1RDWmREb2xaRVJCYVJDU3N0SVlGRGd3NjNsVXpq?=
 =?utf-8?B?T1dWMVlVWUJMWXlKYk5yQVk4Qng0Q3o4NzM5Q0U0bWc2bHZiYWtDMDF0VGNN?=
 =?utf-8?B?ZG93VC80Uk1iRFJCeWNVc3hKekEwV001MWNYQTJpcU5wWDV4ejQyT0tSUG9m?=
 =?utf-8?B?TU1ZdnpGVGtMd3l4ZTR3K25meEkrNnIreC9FQVdnVXNyOE43NW51MzlBNm5S?=
 =?utf-8?B?bnRiRDR2anhBVEtpRzl6KzhiMVRELzNNNFBya0E5VXhsL3o3eUNVckNLWi9i?=
 =?utf-8?B?OVZFL05obDRVVDV0Y1RsY2Q0YWpMSFpUV0RGRE41dkljOFcwdElPRktJbVU4?=
 =?utf-8?B?RVBZZ1ROTDZ0ZEhJdTM1YmgzelpXMGkzV1BvK1FpQ3hyNloxYzNGdFh1MCt1?=
 =?utf-8?B?Z2Z3c3BsaFNZSFFaQnpGUExMQTk3V0FmRGlZQmdNNXg1eENLU0lQRXlpamdI?=
 =?utf-8?B?MDQvakI2eHhlazRHMGVaQzNlUG9KM1hZVHcwMHhiK0VkemxPUnNESzFERXpx?=
 =?utf-8?B?L3dIczU0UGxONFBvV01XSytSejFIZG5XZFJEOXJRWmRaV1Z5N1NFbjNiR1hP?=
 =?utf-8?B?bk1lQkF2bjJ2NkJkM3gzOExrM1EvaEJ3ZlkrTEFpb0JKVHh5ZXQxL1Rrblps?=
 =?utf-8?B?VTRoZXZoZUJKc1lxVXREZzJ2VCtPQ0FqdENIYzNtMlRQdUU5MjltVnJvaFB2?=
 =?utf-8?B?dGsvazhQUXhVYUhrRE5wQlROaW9hSlVqTlhPYy9wbHpsN3RyeWtXeVlzQk13?=
 =?utf-8?B?R21yZ2lDa2IzVEJvTzJySWhySGxBQWU3N25zZkpNWURsbExnbGNmdXhBZm94?=
 =?utf-8?B?NHJYK29zejYxSTczTkZ2V3ZEU0tsbHdma1p6SGlKaVRpWXNtWlh0WmVoUXFm?=
 =?utf-8?B?QU5OZnpRWWlNakFwRVF4alFlSUZ3Q0JRb3dXK0xZdnVKeU5aVXFlenlOcjds?=
 =?utf-8?B?ZFoydW1zeWw1TkpJWG1OeGgxaThKZk1yZ1prRGxZVGtmNkhDZ2oySW9Jd2F2?=
 =?utf-8?B?dEliamlqb2puUU9wVmxBQVFlem9mNThaTjhSeDdYdWxuU0lObEVMUkFzbi9L?=
 =?utf-8?B?WVV3TVIyZEtCeFRHTzdVQlJNQzZDZ3MrSHJVK1QwM0JDZmVJM3llTFhFVTNB?=
 =?utf-8?B?dHpFbVZMZXZTcDAvMXg3VjgxdkVjVjM5M01INmQrUlJVdVZqMWxNVDBuNGRI?=
 =?utf-8?B?UThLWFo1dVZHWTJ5QUY4d0xKNVg1LzlyZ211QVVOeFBiUFdzaG1XSUFVRTlz?=
 =?utf-8?B?ZTh6WXpLZlJRZTBBNWk0bXpWdXUyVVhvN1VFR2d5U2RKRzk1MFcwUk9wY2tC?=
 =?utf-8?B?VDA4T1lGdDZubnNjRkZFUE5Wam1UNHJIdkNYM2xkYXpoeFhTcmN2ME5Zc0Fz?=
 =?utf-8?B?bzg5S3ZBa3pkb0Vsd2dST2ZlTXE1QjZtZUplQ2pqajRzejRKOS9Gb0ErVnVq?=
 =?utf-8?B?a3E3WDJYS040Z0M4V1VqRlRXd1RGNmQ0WnJzWE1LeHhJSjcyZnRhVzVlSkg3?=
 =?utf-8?B?L0JyNmJSZjJOZHBZYkg2NUMwNUkxU1BKd1M1SGE0bXh5L3l1eGJOeW5RWm9q?=
 =?utf-8?B?anJYUy9mQTJ3QVhXemRtZW9QUWxFTmwwNldPR0wzWGNheFY5YkkyYzRlTWFO?=
 =?utf-8?B?RkNBUUlFcTY3a0R5cjcweFk0Y3NqSDdIa1FNSTFoQ2NlUWVRWWxlNmZ5VnJa?=
 =?utf-8?B?SmxacTRNZWtGRUUwWVFGeFJDcWwxejZWY0htU1gwR3g4alBYS2xtd0s3Qk1E?=
 =?utf-8?B?T0swOWovZ2F3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THdzWW9uS24yQU9tb2JERDcyY0RvV3htZ0tSVkwydlU1VDg3MUk3bmo3T1Vu?=
 =?utf-8?B?REZKQ09lWU5yMWp3Tm9PTDh2cnJqbEJnTVlCUFZwWmJ2aTA3NzdPUzNiM1lz?=
 =?utf-8?B?Wndlb1FQWTJuV3E5SytSUGNoVUxBVzlpVDI3emFHVlp5VkxDVWxzVWMxMmlT?=
 =?utf-8?B?T2YyVUdEbE1pSTJhRlpCS1plNm0vMndlQ0FaUzZNM2JETXVVRzVtY041OWtV?=
 =?utf-8?B?Yy9LVzFtMUdLL2MwNnJuRW1mb0x1b29POENaWU9pN0d5d1hmNFQySmNKY2t3?=
 =?utf-8?B?MlhZd3dWd2N4UzN1YS9CYlZ5NEtCWTBqY3RVMWFCczkzcldFSlB6enNYeUVs?=
 =?utf-8?B?OW5qWThBOStNbU1tTnlicTZXQ1ZaczR3SzE4R3htZzBNd2dOMW0yM25yeit4?=
 =?utf-8?B?SHRRbGZIaDhYbmp2dHNPQkhGZDNxMXNYODEzSDlBMW9tZXNIbUh5WDd2Q3pP?=
 =?utf-8?B?UkNDU2RYcDBXdHNJNGZKeENEeTJpWDlRNC9aNTVmUXhzdlB3YW1qbE16aXdD?=
 =?utf-8?B?d09GQWdOTUZmekEvdXdVS09aK0V2a3d3S3U4VTJlc0ZQL2hXNzJOYWFlUUZu?=
 =?utf-8?B?ZVBoZXE3c0szMjVoSDZ0bVhjS2VONWFJcDlwTFh2SFlRZ2ZmTTlQYUFOWTRJ?=
 =?utf-8?B?amVJTTNBVk9GcHBjRUVFUGlXYXkxVkVoTkdYUG5TRXV6bDJndmk0SlVPZFVO?=
 =?utf-8?B?MDN4ZjF5STZsM25QVjZZUEFxeFE4STl2ZzZ0ejh0ZU5xMmRqK3cwQ2F1WUp6?=
 =?utf-8?B?OEVYZkZXTFFFNU1ZcEdOSGFjdFo3SDZ1MHdJN1h1SU5hbDY2ZXcwMmhpNDFI?=
 =?utf-8?B?WXk4ekpWWFlsV3ZoRlU2dW14V2dJWmpUNU5ENUdrYjhVLzltMWFSNUphSVkz?=
 =?utf-8?B?b2ZsVUhKSWdqc1JzeFUyNW9UK29nSXVlUjArMFRZa3c5dGN3Sng2M1h4RXRh?=
 =?utf-8?B?K0pEekdsa0UyKzlmc1FqS293M2xmZG4yeS90bjVYbUlVNTBac3hQL1oyallQ?=
 =?utf-8?B?ZXEvbTdSSFpaWDFDNi90QVRBK0tIRklEa0NiWlhhdEM2UDA1ek0rMUZpTXk2?=
 =?utf-8?B?dkFiVEFEM0xpMkNDRm82Sm95OFdUWFBHTitWY0w2bUZwWGxHTTZCRzhRclBJ?=
 =?utf-8?B?VThscWdPemtJT0ErUGpnWU9FYmRqNm1lOW9tMG1xSmlyeHFURDNaczZ4QmRJ?=
 =?utf-8?B?ZXVmOURBSzdzVUppZjk2ZGJRVWIvR2hiS2wzZVBGdmVoTW5mbmE4S1dsTVky?=
 =?utf-8?B?Rk1EbXhISEUzQldrQTB1ZkJJcy9abUNQSThkWHZTSURXRkg1ak5MbWVIYnhW?=
 =?utf-8?B?RG1hbWN0b044VC9GYjV2TnZER2RMQk8xSGZhVEF3YUdtNHcxaDE5MUh6bmNY?=
 =?utf-8?B?MnRvYkwxeVA4aHpoT2M1d1J1anlxd3g3eG9yZENBYnNjeXA3NjAwK0hITWpX?=
 =?utf-8?B?Y29WdDFYSW1vaHZZbi8rWll0LzhoNEdvRnBLcWNtZlZ2cWYrM244REJ1V1kx?=
 =?utf-8?B?WVZGS0hKWU9kL2ZEd3JnK3IvblRaMzUyRmpRdjhDajdGc0tLZU9uOTd5eXh4?=
 =?utf-8?B?Tys0UDlxWGdXUlBxeTBENnM2Y0g3NkFTbEkrNjhtYlVqOXBORDUrdnBPZXhr?=
 =?utf-8?B?ditqbkhMcmhDZm16bHM1YXlwaVdBdm9ySkxSeFdObjltZ1BHeGlDTEJ0TVRs?=
 =?utf-8?B?S2tlU0kyN1JCZ05rVEZDRTQ3SzFPOGxrblhIaUxBVlBuemQvMWJCVWRjUHE4?=
 =?utf-8?B?dkxWOTlFTEhYUWhML1ExRk5iMUI5Vk1RZkZPWHZrc2VRNm9YSlBKbnAzRWRI?=
 =?utf-8?B?Q28yc3g3bEZWOFhVODFmeFRZSHBkUFNVM2YrSXhwemVqa2pvZERiM1V2NWRx?=
 =?utf-8?B?ZVNDRjJGZ3hxeTFaa29XUjVIQ2ZGdThOZHBnY3FsQis5ZGk2d1FHMGx4UHN3?=
 =?utf-8?B?T2hZWG8rNTA5ZmRtVjR1UU5Ed0wvUVIzNFByR01USllKK1NUeHAwQW9sbjMx?=
 =?utf-8?B?V2ZvZWZNWWVGOTdLZUF3TjVqK3VVdGptZndZVFlUQ1NzbXBRUU1ndmw1VjEy?=
 =?utf-8?B?NE1vKzFnbHVXQSs4dDRON2x5ZFR1OU95V2QzMHpEaERJU3BtZm9LRHZjMFFk?=
 =?utf-8?B?MGlLSWNOaUc4S1VwY3VBUVhxaVFWUTZ4NWQrQjk1aE9uRzljWE9MVmYraVNX?=
 =?utf-8?B?cDFwU092RlJVSHBWT0xQcFdtU0ZWeGF3b0Y1NDN5SG1haGxrT1U4VWpTYXZt?=
 =?utf-8?B?aEQzK0llVmxzclVOdHZTcFFSWlE1U1FnUDdYWEMycDh4OGg2NU43UmhXdTE4?=
 =?utf-8?B?Nm1GWUNsV3c3QUptemRwM1RRV09XZ040dGwrZDdHdjZjMWFhQjUxeHp6WWNK?=
 =?utf-8?Q?C9skSHk6kswXPhF4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 214aa8de-f9cc-4fe9-7eaf-08de524019f8
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 01:07:20.2133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J9ZdUl8oR0ObZkoS+cQtOPFK/fl1Hx+ud+IcRXt2wmEQ+sTcPmlhTCVPZs83SLKllpvmMVyvwS9buDocZwZthw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9207
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8291DA0017
X-Stat-Signature: mipinfbk4qfyieadw5afsrbfce8e6e4u
X-Rspam-User: 
X-HE-Tag: 1768266452-942428
X-HE-Meta: U2FsdGVkX1/B1XtW8dezWMHek0+zVrDFYBcbJjFTy4jl5eng5l3dx3BFtS/5SRnNC9JvpM1XTB0pHX4vBdYkzzCUTksLcHAn4dr8umtd3I7zysoAIRFTjXQMF5zmHhEFzNTzEJN1jGKvA0m3tduschtxDUURbiH2M80UNvnbzruKVjEvDEBrjrn9cXK3mS4DPwFjd3tEtez5TZDRdndRarQ2uaOHhpDZ7TRPn5t+PqiNiuPunblagaIQdNgAxmK2ZU4uJ+FhAYlU4U8doYqva9BOeYcCKT/D867IXp7chUrIiLl2AWoIDh7EAqviBLf+d+fcuoDiaNb6ovF3pz8765zeropiymIYKKzBBRH2B5gBFcRjlRygChY4JYgqIa3Zt2Jp9O8sCb/53yYIyZD74+SetGG/KGMgB/czoMwDAXPq7Tl67A4rcRtbHksWqW1/p13xE55sO8fER83hKQYF44Txjl8iH4Xent9GMzXB2YaDJHug8Rry1IFJ62Nxet73B4dsbHSgLQuPgg1IExDa3rRkMVdvWJ+uaGcvXXV3kc0mxZ+fStrWoIgPjsd/Qyp3K4hs/fcmzU2B2x6RseKJWiq2OXgcrzFGu1FKd+hAe+BV3E79ufAX6y5C5OLc0NHPLqKn00hyznftGPg22+U20ytCJ5Elu6RoOvD5qEFbI6ofGGxOFWykZAnY7WCC4RMZNXiBbXfnmnDyHgxsoYZ29I8hIJCn9ROYyTFCarGCdP04qbngDdwnh1k0+KSOLyEhEXVc3hWzQIukv2G5g/2xNbIouT8kLDeDeOJU0qzFUqyGxbhdBK8KG/N3ZTGRLwWY364rAFhzP1xi2njImw7zsCgLOy9J2r1RUjjAW8NayNPaw2XNf8bjntOqB5Y8q7ZCDzqva0FKssW40Ub2BWCHooSrDnZjfpzkx+RY/LfqIIGg4g6p6be81brS0t+C2TxXE7W6q2lhMcd51ZrFStv
 ul+EFzGV
 POKzh+X9n+FSLUxg6rSq2SlRmu6AIn1APYVEGOuUXAxl4HAYk6c5QLmWAu51ADaQB/ICAGnVim1ZpLkZ2tI/qCVvrXDq1nwC+bdhLHuHlT6TFMaP0h0+lsk0G+30PnXrf6glv6hNbOyxjh58gRBywKhVUq7G5W/KUA2ytTYMkmKkiJ9X1UHGA4CPaUe/pSzgToE5KKmtIK+E8uZQvEr4tYapk1XSUrRDdJ1sxfngN1V3jjrW4xngByzPTT2zpI7CPBjRrUlvDKN+iIEamZWBYGA1rPhFjGvgY2xxLc7ZvVXu5kIeQ0mzTxgrHW2617pxDpJogvhRBR9QbrmCZO2vCvtLVUmgeZFgAq4jMCIEdj1AK4mWeXEgwVeDkVBEsxi/Sbg2gHa2amHcJwiDkUQfVS9QRvGiSR5sebFKlBwIfuNN0Hb6nc+EDv/yBakGENPLRCU72qGKEMsRH3qzUYltCZrr/mTxPQVEO8CGH5WkPq6duo87oS0zN7EYFp6UiCZ2LmTyd5N7Iled1cLrnEV8ZPuqpWcC9smshkBq8FF1lB7NpiAv+OMCPk9CwTaLPs/JhqyPZFqVvgZKKAZPMMwLoFY4Wu0u6SYyTiTOEV3sQLfbz2MIzJOO67CAS7k/xgW+JWMuMZkFyYpZDhRP26FuNPaMZSLCEWC+kG7bLUzO2kQ/iWz7irCLZdkc4+ilt354qfDhPOr7U7iMkv6Y48LJMe9lUpu5tlZfD82hOi48VNiF3iQWxCmuMDAQwAROHOzSa/hIN9ip1Ml150F3Hjo/AaDSKv8W9/59z9jT43qCcybVZkf3bBHnBJXjzHrunlkf2TEzs+YR/oGajlb6sE0c6JIWItsGc6TWKrmC8YLMy0sHi9A3ltNbrMyPPbHEuURHTbVp+5ZXRecTkNwDx88wMnGyQUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 11:43:51AM +1100, Alistair Popple wrote:
> On 2026-01-13 at 11:23 +1100, Matthew Brost <matthew.brost@intel.com> wrote...
> > On Tue, Jan 13, 2026 at 10:58:27AM +1100, Alistair Popple wrote:
> > > On 2026-01-12 at 12:16 +1100, Matthew Brost <matthew.brost@intel.com> wrote...
> > > > On Mon, Jan 12, 2026 at 11:44:15AM +1100, Balbir Singh wrote:
> > > > > On 1/12/26 06:55, Francois Dugast wrote:
> > > > > > From: Matthew Brost <matthew.brost@intel.com>
> > > > > > 
> > > > > > Add free_zone_device_folio_prepare(), a helper that restores large
> > > > > > ZONE_DEVICE folios to a sane, initial state before freeing them.
> > > > > > 
> > > > > > Compound ZONE_DEVICE folios overwrite per-page state (e.g. pgmap and
> > > > > > compound metadata). Before returning such pages to the device pgmap
> > > > > > allocator, each constituent page must be reset to a standalone
> > > > > > ZONE_DEVICE folio with a valid pgmap and no compound state.
> > > > > > 
> > > > > > Use this helper prior to folio_free() for device-private and
> > > > > > device-coherent folios to ensure consistent device page state for
> > > > > > subsequent allocations.
> > > > > > 
> > > > > > Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> > > > > > Cc: Zi Yan <ziy@nvidia.com>
> > > > > > Cc: David Hildenbrand <david@kernel.org>
> > > > > > Cc: Oscar Salvador <osalvador@suse.de>
> > > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > > Cc: Balbir Singh <balbirs@nvidia.com>
> > > > > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > > > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > > > > Cc: Vlastimil Babka <vbabka@suse.cz>
> > > > > > Cc: Mike Rapoport <rppt@kernel.org>
> > > > > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > > > > Cc: Michal Hocko <mhocko@suse.com>
> > > > > > Cc: Alistair Popple <apopple@nvidia.com>
> > > > > > Cc: linux-mm@kvack.org
> > > > > > Cc: linux-cxl@vger.kernel.org
> > > > > > Cc: linux-kernel@vger.kernel.org
> > > > > > Suggested-by: Alistair Popple <apopple@nvidia.com>
> > > > > > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > > > > > Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> > > > > > ---
> > > > > >  include/linux/memremap.h |  1 +
> > > > > >  mm/memremap.c            | 55 ++++++++++++++++++++++++++++++++++++++++
> > > > > >  2 files changed, 56 insertions(+)
> > > > > > 
> > > > > > diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> > > > > > index 97fcffeb1c1e..88e1d4707296 100644
> > > > > > --- a/include/linux/memremap.h
> > > > > > +++ b/include/linux/memremap.h
> > > > > > @@ -230,6 +230,7 @@ static inline bool is_fsdax_page(const struct page *page)
> > > > > >  
> > > > > >  #ifdef CONFIG_ZONE_DEVICE
> > > > > >  void zone_device_page_init(struct page *page, unsigned int order);
> > > > > > +void free_zone_device_folio_prepare(struct folio *folio);
> > > > > >  void *memremap_pages(struct dev_pagemap *pgmap, int nid);
> > > > > >  void memunmap_pages(struct dev_pagemap *pgmap);
> > > > > >  void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
> > > > > > diff --git a/mm/memremap.c b/mm/memremap.c
> > > > > > index 39dc4bd190d0..375a61e18858 100644
> > > > > > --- a/mm/memremap.c
> > > > > > +++ b/mm/memremap.c
> > > > > > @@ -413,6 +413,60 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
> > > > > >  }
> > > > > >  EXPORT_SYMBOL_GPL(get_dev_pagemap);
> > > > > >  
> > > > > > +/**
> > > > > > + * free_zone_device_folio_prepare() - Prepare a ZONE_DEVICE folio for freeing.
> > > > > > + * @folio: ZONE_DEVICE folio to prepare for release.
> > > > > > + *
> > > > > > + * ZONE_DEVICE pages/folios (e.g., device-private memory or fsdax-backed pages)
> > > > > > + * can be compound. When freeing a compound ZONE_DEVICE folio, the tail pages
> > > > > > + * must be restored to a sane ZONE_DEVICE state before they are released.
> > > > > > + *
> > > > > > + * This helper:
> > > > > > + *   - Clears @folio->mapping and, for compound folios, clears each page's
> > > > > > + *     compound-head state (ClearPageHead()/clear_compound_head()).
> > > > > > + *   - Resets the compound order metadata (folio_reset_order()) and then
> > > > > > + *     initializes each constituent page as a standalone ZONE_DEVICE folio:
> > > > > > + *       * clears ->mapping
> > > > > > + *       * restores ->pgmap (prep_compound_page() overwrites it)
> > > > > > + *       * clears ->share (only relevant for fsdax; unused for device-private)
> > > > > > + *
> > > > > > + * If @folio is order-0, only the mapping is cleared and no further work is
> > > > > > + * required.
> > > > > > + */
> > > > > > +void free_zone_device_folio_prepare(struct folio *folio)
> > > 
> > > I don't really like the naming here - we're not preparing a folio to be
> > > freed, from the core-mm perspective the folio is already free. This is just
> > > reinitialising the folio metadata ready for the driver to reuse it, which may
> > > actually involve just recreating a compound folio.
> > > 
> > > So maybe zone_device_folio_reinitialise()? Or would it be possible to
> > 
> > zone_device_folio_reinitialise - that works for me... but seem like
> > everyone has a opinion. 
> 
> Well of course :) There are only two hard problems in programming and
> I forget the other one. But I didn't want to just say I don't like
> free_zone_device_folio_prepare() without offering an alternative, I'd be open
> to others.
> 

zone_device_folio_reinitialise is good with me.

> > 
> > > roll this into a zone_device_folio_init() type function (similar to
> > > zone_device_page_init()) that just deals with everything at allocation time?
> > > 
> > 
> > I don’t think doing this at allocation actually works without a big lock
> > per pgmap. Consider the case where a VRAM allocator allocates two
> > distinct subsets of a large folio and you have a multi-threaded GPU page
> > fault handler (Xe does). It’s possible two threads could call
> > zone_device_folio_reinitialise at the same time, racing and causing all
> > sorts of issues. My plan is to just call this function in the driver’s
> > ->folio_free() prior to returning the VRAM allocation to my driver pool.
> 
> This doesn't make sense to me (at least as someone who doesn't know DRM SVM
> intimately) - the folio metadata initialisation should only happen after the
> VRAM allocation has occured.
> 
> IOW the VRAM allocator needs to deal with the locking, once you have the VRAM
> physical range you just initialise the folio/pages associated with that range
> with zone_device_folio_(re)initialise() and you're done.
> 

Our VRAM allocator does have locking (via DRM buddy), but that layer
doesn’t have visibility into the folio or its pages. By the time we
handle the folio/pages in the GPU fault handler, there are no global
locks preventing two GPU faults from each having, say, 16 pages from the
same order-9 folio. I believe if both threads call
zone_device_folio_reinitialise/init at the same time, bad things could
happen.

> Is the concern that reinitialisation would touch pages outside of the allocated
> VRAM range if it was previously a large folio?

No just two threads call zone_device_folio_reinitialise/init at the same
time, on the same folio.

If we call zone_device_folio_reinitialise in ->folio_free this problem
goes away. We could solve this with split_lock or something but I'd
prefer not to add lock for this (although some of prior revs did do
this, maybe we will revist this later).

Anyways - this falls in driver detail / choice IMO.

Matt

> 
> > > > > > +{
> > > > > > +	struct dev_pagemap *pgmap = page_pgmap(&folio->page);
> > > > > > +	int order, i;
> > > > > > +
> > > > > > +	VM_WARN_ON_FOLIO(!folio_is_zone_device(folio), folio);
> > > > > > +
> > > > > > +	folio->mapping = NULL;
> > > > > > +	order = folio_order(folio);
> > > > > > +	if (!order)
> > > > > > +		return;
> > > > > > +
> > > > > > +	folio_reset_order(folio);
> > > > > > +
> > > > > > +	for (i = 0; i < (1UL << order); i++) {
> > > > > > +		struct page *page = folio_page(folio, i);
> > > > > > +		struct folio *new_folio = (struct folio *)page;
> > > > > > +
> > > > > > +		ClearPageHead(page);
> > > > > > +		clear_compound_head(page);
> > > > > > +
> > > > > > +		new_folio->mapping = NULL;
> > > > > > +		/*
> > > > > > +		 * Reset pgmap which was over-written by
> > > > > > +		 * prep_compound_page().
> > > > > > +		 */
> > > > > > +		new_folio->pgmap = pgmap;
> > > > > > +		new_folio->share = 0;	/* fsdax only, unused for device private */
> > > > > > +		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
> > > > > > +		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
> > > > > 
> > > > > Does calling the free_folio() callback on new_folio solve the issue you are facing, or is
> > > > > that PMD_ORDER more frees than we'd like?
> > > > > 
> > > > 
> > > > No, calling free_folio() more often doesn’t solve anything—in fact, that
> > > > would make my implementation explode. I explained this in detail here [1]
> > > > to Zi.
> > > > 
> > > > To recap [1], my memory allocator has no visibility into individual
> > > > pages or folios; it is DRM Buddy layered on top of TTM BO. This design
> > > > allows VRAM to be allocated or evicted for both traditional GPU
> > > > allocations (GEMs) and SVM allocations.
> > > > 
> > > > Now, to recap the actual issue: if device folios are not split upon free
> > > > and are later reallocated with a different order in
> > > > zone_device_page_init, the implementation breaks. This problem is not
> > > > specific to Xe—Nouveau happens to always allocate at the same order, so
> > > > it works by coincidence. Reallocating at a different order is valid
> > > > behavior and must be supported.
> > > 
> > > I agree it's probably by coincidence but it is a perfectly valid design to
> > > always just (re)allocate at the same order and not worry about having to
> > > reinitialise things to different orders.
> > > 
> > 
> > I would agree with this statement too — it’s perfectly valid if a driver
> > always wants to (re)allocate at the same order.
> > 
> > Matt
> > 
> > >  - Alistair
> > > 
> > > > Matt
> > > > 
> > > > [1] https://patchwork.freedesktop.org/patch/697710/?series=159119&rev=3#comment_1282413
> > > > 
> > > > > > +	}
> > > > > > +}
> > > > > > +EXPORT_SYMBOL_GPL(free_zone_device_folio_prepare);
> > > > > > +
> > > > > >  void free_zone_device_folio(struct folio *folio)
> > > > > >  {
> > > > > >  	struct dev_pagemap *pgmap = folio->pgmap;
> > > > > > @@ -454,6 +508,7 @@ void free_zone_device_folio(struct folio *folio)
> > > > > >  	case MEMORY_DEVICE_COHERENT:
> > > > > >  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
> > > > > >  			break;
> > > > > > +		free_zone_device_folio_prepare(folio);
> > > > > >  		pgmap->ops->folio_free(folio, order);
> > > > > >  		percpu_ref_put_many(&folio->pgmap->ref, nr);
> > > > > >  		break;
> > > > > 
> > > > > Balbir

