Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61500C5DF6D
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 15:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82C96B035B; Sun, 16 Aug 2026 11:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59746B035C; Sun, 16 Aug 2026 11:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D21956B035D; Sun, 16 Aug 2026 11:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A01E66B035B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:37:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25EA6140584
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:37:11 +0000 (UTC)
X-FDA: 85107536262.30.4B575B2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0B738180008
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:37:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mF4VWRt6;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of himal.prasad.ghimiray@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=himal.prasad.ghimiray@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786894626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9w3J8x0rYQr6MAoHAyAxTU+IuzJUl7yXIcSQywkgeqw=;
	b=ZzjgLmtvaNW6nYou7PGnvSqCBPcDMZMJpUKzyKwgdonS5aEdNO3Kbgl70seW53iC9kmT7t
	jT8u7vhcyhUNYMaaYFD8aLKFCNjvIn3n8bxezwmvFfnkiys9MA5eNsxRuMxUjAFr5Yo1dM
	p18NQrkNuqfuLjOPpAD3H1CkCfSLgto=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mF4VWRt6;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of himal.prasad.ghimiray@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=himal.prasad.ghimiray@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1786894626;
	b=kUysmPsdB6f+pjY9+tZW4wb1u3PMFjshrkwdlog7py40dqk/Y9qQ0NwJv0Em9LIVWgg7W4
	DLpnYo+tMHxQ06P5sz23kU9AO7HdMw7FKChtTW9Ld8M6n3MtyCSHDhhXo5RpIfkRSrx6ps
	aBIPWcALljDY4ve469XAazcO07UALeQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786894625; x=1818430625;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4lKeGD0s/eqkGRVHfdpNhWB7TH2+1Fhzt8s8M42qJxc=;
  b=mF4VWRt6EZl76/U26QfElrPYgd5KmQYkuv5c25fpI890vONsdOTS27Lg
   2Y+LsOIsgEHcSY/VfUwBWdVWYEX7Q+ZP8dBbOVspXZ7oDkBVevcrwvWZP
   nm5bHEROqErN3VkT01JO9Oq5low+g8C5ciBrb1u9hm4Zs3kA0fhbmXqVu
   yYQLFL6OJR8FVFl54ev44YZk7MeYaRWoaIhczIgZtZTdWUcpjHbLzWlGN
   eiUecbW+ViDZd1wUdl+/ToWY0hqWtnroxeKDjPVOzUvLdFx8E16E5y8Lo
   XR2Vl0sApohh8Dzn/C+d8OcUuG2d7VL5FFKyuZXR7QaelREo3fKEa+/Lh
   Q==;
X-CSE-ConnectionGUID: we7AVjXsQFyXSLFYAj9FGA==
X-CSE-MsgGUID: 6tMb3RYpSrOR0sA8ed0pZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11877"; a="91259996"
X-IronPort-AV: E=Sophos;i="6.25,227,1779174000"; 
   d="scan'208";a="91259996"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2026 08:37:04 -0700
X-CSE-ConnectionGUID: o7iTDN+sQS+WvmOlefINlQ==
X-CSE-MsgGUID: rfStUcNrR8y9OJ6R1TJNVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,227,1779174000"; 
   d="scan'208";a="268182402"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2026 08:37:03 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 16 Aug 2026 08:37:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 16 Aug 2026 08:37:02 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.30) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 16 Aug 2026 08:37:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CSYx7bRJfM/7+u2qwLUmAYWqXy70obkhBpRsAl8hwMpd/tu5xz4w4nLt3Ga+iwro4W8akyTQYoABIV5nvs65jWl5rPLdrUqUWwbcZDqqNGr2iwfROj6sRrFtcX2r9NAjbVhFaV/39tvv/iXmXIOfmXbB2oIQFJ5JItoGx3OBvEBzp+MdrY3/zOXL5bFlD4p+iNASAzNu8nIsJLB0SgtaK4+3/pZYaYX0t0cD9623khH1P9C22+gNA1jSfalVRCjMDijIPnDDD84MkTuKcLMpxLdTDhRWWzelVXdtJytlfyQrlXtAutDlSRVAW+k3phucmnhXwY/J1XZEyb3EYXSStw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9w3J8x0rYQr6MAoHAyAxTU+IuzJUl7yXIcSQywkgeqw=;
 b=xcJgYvRee2RacmthpRdA5XfpzfILGRIJZ+Prhucug+yUSJtnEqk0FeZDFiBfL+RAx2jNebd8KuMgXQwwfXyZcHLjcKAk8Su/IsU/asA9RDa7t7bvzZkv0HRjrg+Oqgw4BQPGJLZigTzM2PTqzYC/tUrpiyWUl++uh9AUepYz6G7V603HRnVul2h+9gYhXJqITPbidAbiPxn/kFpd9PccXEgOX3gsRVBOJa1M5zYX2qCSTv5rqc3fGHZfsgPG6Ka7r0TZVCdse7SQ3nIZRWUyVT7r7mascvoX3/o3qW69h/q/1OzqyeFe6n5yNt7Wo1SY7OdrXUASKk+ZMsrHozQN6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPF691668CDD.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::2a) by DM3PR11MB8670.namprd11.prod.outlook.com
 (2603:10b6:0:3d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Sun, 16 Aug
 2026 15:36:59 +0000
Received: from DS4PPF691668CDD.namprd11.prod.outlook.com
 ([fe80::5a5c:9c7a:cd1d:d687]) by DS4PPF691668CDD.namprd11.prod.outlook.com
 ([fe80::5a5c:9c7a:cd1d:d687%6]) with mapi id 15.21.0315.016; Sun, 16 Aug 2026
 15:36:59 +0000
Message-ID: <0e197017-7054-468a-b641-1b5a00d77db2@intel.com>
Date: Sun, 16 Aug 2026 21:06:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] drm/pagemap: Fix folio allocation fallback and
 use-after-put
To: Matthew Brost <matthew.brost@intel.com>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R .
 Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, "Maarten
 Lankhorst" <maarten.lankhorst@linux.intel.com>, Maxime Ripard
	<mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
	<airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Francois Dugast <francois.dugast@intel.com>, <stable@vger.kernel.org>
References: <20260805231041.3791771-1-matthew.brost@intel.com>
 <20260805231041.3791771-6-matthew.brost@intel.com>
Content-Language: en-US
From: "Ghimiray, Himal Prasad" <himal.prasad.ghimiray@intel.com>
In-Reply-To: <20260805231041.3791771-6-matthew.brost@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5PR01CA0071.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b7::16) To DS4PPF691668CDD.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::2a)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF691668CDD:EE_|DM3PR11MB8670:EE_
X-MS-Office365-Filtering-Correlation-Id: 579508dd-0d89-4b47-7b01-08defbac35a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 2Za2nTYCOop+k42sD4gE8Kj3u91sCMd+laLX/AMokeXh6fqn8s2tuz5OmwHLz4c9YufCg2Jd9lyyStqq6CGHtASNgw91BUkCVWVrXjRVLzr0Uf3oDbm7bpV4h7Ze5a/i0hTj3X8UjTnP/RwnmGEEi4nDvVmO+nTo+N8XCH+5b7PKyUbd0hhLlwDmU1QGWIBqsMB3pXKp1DSJU1kDi0DtbafstGbmGZ+/My0Bb4/T1ceGJt4oIr5GI9KOBD99W53Ia4c7Rud0+Oa3eOeZ4wUcRtQNGxN4TDMrptbu6cmUssuvtFQFZ5Og6oJYgXBaiWYN0JwyuRPgPPoeRovnG9Dn1eXr1SHPF9knXedcgTRKwmoa1A4VgR+k46+5e/gcOnmPcs48WANmMZltKxl4RXK5WnJ3nnyJgbG4NHq6jmKzc5qIc5D2NzYVdTRxgLZNqM6mnN4S9ixiBkOf0HyIfxRpEQiqpV2voV8if358OZwLB1yuybWIijAFbO6sRfzNbhWwk6K7qtufGAON9GdbpNFPu5Ditn9YrY+329dC+5Kw7+UvjLZoss5DiXZpMYI2fCColYz0Qwhcl1DSB+JaYY7/tuaAKqj2D6jOFhHAVOaeKknA5uOPCGpkv3Ppc/y4HYIiHlTw2ycz5zikwuaWhXjwWRTz6tWp2iOe0BNcCuUmb0A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF691668CDD.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXhwZ2JoOEg4ZVpYeDdqMEVITVZDMXF2QlRUczJFNVJVK2NrcWlCTEgzUE1W?=
 =?utf-8?B?SUhQbSsza0FkaThuMkNFWjlQNDlrOVdPUyszL3I2U1VUWEdUSHZTeDYyWnlP?=
 =?utf-8?B?V0Q2VnZPRWV4aFY2Q2dlcEl2R1o0MFNpUDBVWFdQRUZDVWxvblJoWHNVVHBh?=
 =?utf-8?B?VEpQcjArUmpkQitwQmR1UkU4RHROVUlwRHN3Z093Ym5wNVpkTG5DUVVrOCth?=
 =?utf-8?B?NE51ODBINnBtVzJUOW1mbU1pVEVBQkI3MGt0OHBuTVJrREsrY1ZlL1Nqd2FB?=
 =?utf-8?B?eU93WGpZL1Z6NVloak84UUJpR3ZUMjZ2Qmxia0hnams2b051eUlvRmxuT1dZ?=
 =?utf-8?B?WE9QeGZ6RktyL3o2Y3JyL056NTZidk1pQ1lXc1piTmxwdnB4Y1dqdWV0N1Nk?=
 =?utf-8?B?Sm5NUTFVdk1oSkkvVno5T3MxZC91aTRJSTRPSGRhKzhOL1NFMWJReTNTb3ps?=
 =?utf-8?B?SlJYR0ZtL1ZkSXZGdEtCOC9RYy96aW5hZ0tCRTFKc3J3OFpsSmNhUURSM1hM?=
 =?utf-8?B?Nm1YRHhDRkRMVnZhYVhpTmdUUUpWV0tpTXhEeEY2ZHd4RExUOTBBRWJWdFZI?=
 =?utf-8?B?ZHNuRGJubXdCUG4xUU1lOGI4c0tuWjVaN2J4bmptdTR0MHR1bjJSUGtxb1Rl?=
 =?utf-8?B?Z2Jvdmc2L0owRTNNM01WZ1dVMlpuOUFZNytpTFMzZkU0azgwMW5ZSjExdWIw?=
 =?utf-8?B?Z1gxbC9IdHpvUDlkUlBQOFhtakpHdzdsaFlYdHR3SkpTM3lWaWRTNVNFNFA3?=
 =?utf-8?B?TFlBKzRoeWV2cFlhQjZHdzh6Z0h2VmZjbExnS3puSUlaODJzVGkyZW1JNDg1?=
 =?utf-8?B?MnlrdXdQa1ozUkNXdkpna3BFd3V3TDREb3llU2NRUGVpaDhaTUZzYVNsb1dM?=
 =?utf-8?B?VkVNRG83T3dCOFAyNWlQWjI1TTVPNjBQU0RpSkdsY0JNeVNZR2lLWmxXalR4?=
 =?utf-8?B?VGI2cnVKNDg5cDBzZFFrbk1HMDZlQTN3MXJXR1VNSmtZeWQzQzYzM1VFdFN0?=
 =?utf-8?B?OG9iS1BWNmR1a21mMUo1RGpHRTNVa3VUTHZjcGo2YnRudmNEU3dIb1p1SExO?=
 =?utf-8?B?KzRHZVE1MENmSGNlOE9EVHBCMjlRSG1aOFRZcjlwRDJpd3B3MlZ3TVNZTGxv?=
 =?utf-8?B?QmlRYk5OOFlhb0xHWUlVZ1RRWmtTT0htN21SVFY2R0Z0YWhvTWUwOWJPVTlZ?=
 =?utf-8?B?RFQvYk1iR2hrdDAwL1NDQzluZG5GajYxYkpsbzlHSXF5clYyWTZWYUxPVzhI?=
 =?utf-8?B?dU1lT3Y2QzhERVZpMkU4WjhWZUppNGQ4Rm9McXQyOXBwd3FuSG01ZWRxSm9G?=
 =?utf-8?B?TVFTTVRNVUhLWVdQWEswdGV1MlIxampjdlBTajI2amdXeWlDVDlCaTdZSDVS?=
 =?utf-8?B?OXFHTUM5Q0Y0ZTJKeGlPMi9EZmNYM3RndDFpVnVIQ2lsZ2RJbVovekw1Nkli?=
 =?utf-8?B?eXF2MFNYZWVoZjdML3FtaVkrZUdFSHdYc3FrK0dFdGs1dkloSjB2U1U4Rmp5?=
 =?utf-8?B?Y1NpNWhKem9Cd2ZDcG12KzlmV093czJseHB1NkVHSHVuN2gxanBSOUFaTkVM?=
 =?utf-8?B?K2VzdTdxL1J1M1ZLczNYYVNvZ003dEp1WlhWV1JYbVNUU1FERHgwQ1dmUDcx?=
 =?utf-8?B?bHZqdGJvWXB2T0RSajE3RzYyS01UWG1xRjYzZlp2NEp5L3h6RkM3WEtjRjZX?=
 =?utf-8?B?UXNGL0lNaVRHdTdtOUQ1R2tWVnQySUdXMWs1eEtnTDVNQ2Jkb3AvOFRkc3o0?=
 =?utf-8?B?VUoxMklXMGlZaGFyUFM1MU13NXJNb3RBNUZrNHVIL2R4UnFXUTZPa0o1TWFu?=
 =?utf-8?B?dTNCNEVGNXdLM2Naa1hVSEdGMFo1NzFsNTBsNzJsem1HTkhRVDZxSHpvTlhI?=
 =?utf-8?B?QUhHMVIrSEVtY3BnZTVKeE5VVkJLUk5MQklZRUI1TVpENG54dWdxcEJnZktD?=
 =?utf-8?B?Smg1M1YwODBzNStFbkwzNDhzN1RiNC9wVk5vb1N6aTExV2c5YVB3bHAvUVp3?=
 =?utf-8?B?U1BhTnJVNmdXOTBaUENVTnlGbGhDL3VMY01uYXpQMmtOalo4bnN3TmppWEZI?=
 =?utf-8?B?cVMwMVhDWmFIQ2NJZ0kvdWM5N1pnTkJVWU5jSENtdUVySFQ3TG5BYlBHSGpn?=
 =?utf-8?B?Q1B5WFdGVkpCWCtvOEZoYk1OUTZNY0N0ZTRYMjIvQk1CN25CbDErQU5FM0RC?=
 =?utf-8?B?MjhuYUtscU5mUEZPNzdnNElSczUwTXB6VDY2dVl1Qyt2cnJvZmd0UURlUG1l?=
 =?utf-8?B?aG5ZdVNuNWRxOGNPeHRTKzgxaCtPZkpSN2xaL0lyNlIzOHo0ODA2TmxvRjVq?=
 =?utf-8?B?eW5rVXpkOG9TbFJQVVFzcUtXbkJvU3RIWFdsMlRGcWhZWnQ5VStCc21pWStD?=
 =?utf-8?Q?S5WURLyoReIZqjW0=3D?=
X-Exchange-RoutingPolicyChecked: Rd5+s4sK8WF59Aj9hQ1PJnQMh5TFirezffF0cH6Fn0JF6CZCFd5QHy34yhcG5LROo0CohZxDvhiVuyNQs73yHdpxBEYsfxGCl1SKpB4aEZHbiwNulbgkhPL/jUMUCSHZE5YnsiKQEDKcuFA4Wm1/f+9EN+9QFCdMDM2boU9L8bbidVTfRi1rQa5RuiVw+UYbDNBPLCfaO8OBMBQVIwiNgOoj34B2ujg11n3TNoS9dRGjhKABeZXouqvAtYKmq81N1+yj7XIxeOtxFkIOWPS74QkqUmDl90vSxW1jMlr1CNL/EFL+ejp9nh47dDQSk5JskA7PnoI02x0BMCrlY5MjLw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 579508dd-0d89-4b47-7b01-08defbac35a3
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF691668CDD.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 15:36:59.0298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UhhlHBuJ3wbMDzfyC8q0bnIxmZk/hr0skWJPyYFKrXPp0FGljNalU7ToCaHtx76kSQ/IrrktmGnGiSlSHcwPOt2vFAY7aym5CnQxHUjjdXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8670
X-OriginatorOrg: intel.com
X-Stat-Signature: qy5bf9w749dom7dw6uuahutg689q3smc
X-Rspamd-Queue-Id: 0B738180008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786894624-837841
X-HE-Meta: U2FsdGVkX1+PAQNiCZWcyhV3q8k29kcjWXEhqdkAIHdyKKuKi1qsE5IoS6h9lF7JdGUCRBJ7XiMSyo0pFpbN2+9BvS1p0Ik33CEitrZvJMPrwAoSL1nWpi0z5LA1n7eCLy98cIeNocxRDEtsoye9T0RykTDPriO0MQbzjisQNyNdwyJdat4+mqUwaymw9/atnxafOycNtT2PFz0t5KmlbZ+BWS3sGX7TYKHjHpUUyyBFG7idpRGXwSMg1r8Ds3I0PDZGBmMJSWSl7Q+iaVJH0ZOt4GxpN2FXvlDkp7GcTGJqm9jrQCUm9FFabpxobtIOZ6FcWh5gvmNNbDtXvlAFER2tmWT1KuAly/aeOsvE3WYU9cjErOKjrtwVd0Mb+wN/+p/qNTMFoNPtHv81Us9y3EesRB4PA/6o4nlaQ/lBttmml3RnrDdilkUOg7ibfgrsHPG8eOvO3cZLXZjS320wwQvuhWmAbmhqnTQr06SMdLsJdkLar5I3eaobe7RtM73CL6z85u8lmtXureeEUfkugjUcQM2xfmiRTqyRbQ2kwCOB9cmXsA/hssHQ3szolkEaYD0xEOJWpWznUbGqA3bwVFEIuxaEZ+P0PTc19muJBjVDCQx/dZg1sQuZBcoMVoeMsFPEcucZQsvakijHFLaQT6yzgzC2x/tgCwLNwFTbj6uHD5U7fbH/EKkUZJ6x6R18lLFsktbRYFuEPJHqxRl+0hjZPAvZIwVQFmsrCK59wTgMWANHwSW/P2L0FR3DLC8Vem4PKLuuye5fDSH2QdUhfSufZLcbeeapcjRjy9AlcpB1QJtiqX5y74fdpFZ8WJkGE2hpWweKYbU1wqM5ORKuoHxZCAvLpng2XRRwXyZxKvzSsjY6Ji30UZRzw+bI8c6pYEzbT2cVpjg/hiAmMnuEpwiex4gYNK+4IsFrZsVb47ct7wwuoYW87gV0pbXLcH7pYRq8SiMDdjnCk02kkp3
 JFMgRPI5
 ID/jfJ1nvS0b7hQhVIHiVmIBeAUwEOw9XOAG2ly/XYpX+UVOymFOMl6oq1Uc2mlRRtmw6J43m2cNp490tpxOc1Ga26Tk0SN3OO66utzgW73q0X8nADDM+h2H9NpyAxMxuaGCmNnVtqPWYRQdYKfd0qkMVfGGw9/HFFAWY7r8BA+v0otn2Ott8ZHmSwtY8laZtsXYusZfBx9Jx6/2zHl8hJLQmvz3rGBK6DATslmuAH2VAzZOvATWgOQ69jTL0gpjwEQN1z7GOzgfmnuQ/vkrOrrKARxzLxu8gR6YxyKr4/LHO80HLMCoUKjND5GlVDGT8t6Ovq2ydi2yhTF+IXrRw8SwyVdCN6/t+sN7CFkW0LJkLUrENst6LHPPjIet7q8WxWpIge/zy88oXlvJckvHuB2/w9wxu27htSIOkCsz//VNG+HWF37OjSYNoUc+o8Nd6KfSaen8gqakaKT3RuuaTNx6SusqXKsnaZIsLDswDtkPxi4RsKhGyVJWp9gvnPnACVY1mnfuqEQrQnVi4P+y83TYJpzdjPhs51MpIOW1kEbXW31R5do5RpWvfXfgVoQ/N0+kdmsx0H1C8gbQv+J8m5TVa9ekP5Vz/FQP6AsGdCFKUVmCp2a5JO8byB3wYVdy5xRYWB8zKdTEoLQX6sGcwyup5zmi5geJlZQQ69gRMG/kE8YyppghhsuXUfzYFjlVHq92NTSVkW2rzwA/MoqEpX1qmI8pSCYvriLvTZk1CSY7l2GjPax7lHCL1VIyaonVgK9zDd+EyGAozvqIpaVchSiyACTVMh5LYQT5pMdIthyFPtZ9mzi58KMfuagdugVF4eqF0diidwHBeQm++oC8WMK0ljo2ClQ0jmjuVlcG2zrZ+G06ig2bC5JsufPClfF4G2IdGb/nJlYi81Ttw01Kqr3VA2ZqnCydSNPoXDk+TvF1JBRZlOUGpOYJ4joZuSwgFyVV1VwD+5TiXRoU2asPoDosvBuHw
 T/dU5dzt
 iuFGPxDi365n6FpGrou7KpGYivtWV0Pr8SHrkqn+IQ8tw1/eFsIFcDGikpeVf28Yzu1VwJOMamjtuGzztmMDCsyjvvnef9MTlpF+ZIWexF6RuBWf+41cQJ6gTJn4mzDVUxySptlU+A0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06-08-2026 04:40, Matthew Brost wrote:
> drm_pagemap_migrate_populate_ram_pfn() had two issues when populating
> RAM PFNs with higher-order folios:
> 
> 1. The higher-order vma_alloc_folio()/folio_alloc() calls did not pass
>     __GFP_NOWARN, so a THP allocation failure under memory pressure
>     would spam the kernel log, and there was no fallback path despite a
>     TODO comment stating one was needed. Add __GFP_NOWARN to the
>     higher-order allocation and, on failure, fall back to order-0
>     allocations for the entire range originally covered by the failed
>     higher-order allocation, leaving MIGRATE_PFN_COMPOUND unset for
>     those PFNs.
> 
> 2. In the free_pages error path, order was computed via
>     folio_order(page_folio(page)) *after* put_page(page) had already
>     dropped the reference, resulting in a use-after-free/put when that
>     was the last reference on the page. Compute order before releasing
>     the page.
> 
> Introducing the fallback in 1. also requires the source page array
> handed to ->copy_to_ram() to be built differently. Both callers only
> populated the entry at the head of each source folio, relying on the
> copy callback to derive the rest of the folio from the order recorded
> in the matching drm_pagemap_addr. Once the destination has been demoted
> to order-0 folios the drm_pagemap_addr entries are per-page, so a source
> page is needed for every one of them; leaving them NULL makes the copy
> callback stop after the first page and the remainder of the range is
> never copied.
> 
> The source folio is only split later, by migrate_vma_pages() /
> migrate_device_pages(), so its order cannot be used to detect the
> demotion - test the destination for MIGRATE_PFN_COMPOUND instead. Factor
> the array population out into drm_pagemap_migrate_populate_src_pages()
> and use it from both drm_pagemap_evict_to_ram() and
> __drm_pagemap_migrate_to_ram().
> 
> Fixes: ddeda6136038 ("drm/pagemap: Allocate folios when possible")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Nico Pache <nico.pache@linux.dev>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Assisted-by: GitHub_Copilot:claude-opus-5
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> 
> ---
>   v2: Add THP-mid-PMD invariant (Sashiko)
> ---
>   drivers/gpu/drm/drm_pagemap.c | 128 +++++++++++++++++++++++++++-------
>   1 file changed, 103 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
> index aef1fcea663d..51c6f12e4256 100644
> --- a/drivers/gpu/drm/drm_pagemap.c
> +++ b/drivers/gpu/drm/drm_pagemap.c
> @@ -383,6 +383,58 @@ drm_pagemap_migrate_map_system_pages(struct device *dev,
>   	return 0;
>   }
>   
> +/**
> + * drm_pagemap_migrate_populate_src_pages() - Populate the source page array
> + * @pages: Array of source pages to populate
> + * @src_mpfn: Source array of migrate PFNs
> + * @dst_mpfn: Destination array of migrate PFNs
> + * @npages: Number of pages in the arrays
> + *
> + * Populate @pages with the device pages the copy callback is to read from.
> + *
> + * Entries are normally only populated at the head of each source folio, with
> + * the copy callback deriving the rest of the folio from the order recorded in
> + * the corresponding drm_pagemap_addr. That does not work where
> + * drm_pagemap_migrate_populate_ram_pfn() had to demote a higher-order source
> + * folio to order-0 destination folios: the drm_pagemap_addr entries are then
> + * per-page, and the copy callback needs a source page for each of them.
> + * Populate every entry for those ranges.
> + *
> + * Note that the source folio itself is only split later, by
> + * migrate_vma_pages() / migrate_device_pages(), so its order cannot be used to
> + * detect the demotion - the destination has to be inspected instead.
> + */
> +static void drm_pagemap_migrate_populate_src_pages(struct page **pages,
> +						   unsigned long *src_mpfn,
> +						   unsigned long *dst_mpfn,
> +						   unsigned long npages)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < npages;) {
> +		struct page *page = migrate_pfn_to_page(src_mpfn[i]);
> +		unsigned int order = 0;
> +		unsigned long j, nr;
> +
> +		if (!page) {
> +			i++;
> +			continue;
> +		}
> +
> +		order = folio_order(page_folio(page));
> +		nr = NR_PAGES(order);
> +
> +		if (order && !(dst_mpfn[i] & MIGRATE_PFN_COMPOUND)) {
> +			for (j = 0; j < nr && i + j < npages; j++)
> +				pages[i + j] = folio_page(page_folio(page), j);
> +		} else {
> +			pages[i] = page;
> +		}
> +
> +		i += nr;
> +	}
> +}
> +
>   /**
>    * drm_pagemap_migrate_unmap_pages() - Unmap pages previously mapped for GPU SVM migration
>    * @dev: The device for which the pages were mapped
> @@ -875,6 +927,7 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
>   		struct page *page = NULL, *src_page;
>   		struct folio *folio;
>   		unsigned int order = 0;
> +		gfp_t gfp = GFP_HIGHUSER;
>   
>   		if (!(src_mpfn[i] & MIGRATE_PFN_MIGRATE))
>   			goto next;
> @@ -891,11 +944,51 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
>   
>   		order = folio_order(page_folio(src_page));
>   
> -		/* TODO: Support fallback to single pages if THP allocation fails */
> +		/*
> +		 * A large source folio is always collected whole, at its head
> +		 * page, PMD aligned and flagged MIGRATE_PFN_COMPOUND: anything
> +		 * else is split before it reaches us, either by
> +		 * migrate_vma_collect_pmd() or, for the eviction path, by
> +		 * migrate_device_pfns(). Both the order-0 fallback below and
> +		 * drm_pagemap_migrate_populate_src_pages() rely on that, as
> +		 * they index the folio from @i.
> +		 */
> +		WARN_ON_ONCE(order &&
> +			     (src_page != folio_page(page_folio(src_page), 0) ||
> +			      !(src_mpfn[i] & MIGRATE_PFN_COMPOUND)));
> +
> +		if (order)
> +			gfp |= __GFP_NOWARN;
> +
>   		if (vas)
> -			folio = vma_alloc_folio(GFP_HIGHUSER, order, vas, addr);
> +			folio = vma_alloc_folio(gfp, order, vas, addr);
>   		else
> -			folio = folio_alloc(GFP_HIGHUSER, order);
> +			folio = folio_alloc(gfp, order);
> +
> +		if (!folio && order) {
> +			/*
> +			 * Higher-order allocation failed, fall back to
> +			 * order-0 allocations for the entire range covered
> +			 * by the original higher-order allocation, without
> +			 * setting MIGRATE_PFN_COMPOUND, until we move past
> +			 * that range.
> +			 */
> +			unsigned long nr = NR_PAGES(order);
> +			unsigned long j;
> +
> +			gfp &= ~__GFP_NOWARN;
> +			for (j = 0; j < nr && i < npages; j++, i++, addr += PAGE_SIZE) {
> +				folio = vas ?
> +					vma_alloc_folio(gfp, 0, vas, addr) :
> +					folio_alloc(gfp, 0);
> +				if (!folio)
> +					goto free_pages;
> +
> +				page = folio_page(folio, 0);
> +				mpfn[i] = migrate_pfn(page_to_pfn(page));
> +			}
> +			continue;
> +		}
>   
>   		if (!folio)
>   			goto free_pages;
> @@ -940,11 +1033,11 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
>   		if (!page)
>   			goto next_put;
>   
> +		order = folio_order(page_folio(page));
> +
>   		put_page(page);
>   		mpfn[i] = 0;
>   
> -		order = folio_order(page_folio(page));
> -
>   next_put:
>   		i += NR_PAGES(order);
>   	}
> @@ -1120,7 +1213,7 @@ int drm_pagemap_evict_to_ram(struct drm_pagemap_devmem *devmem_allocation)
>   	unsigned long *src, *dst;
>   	struct drm_pagemap_addr *pagemap_addr;
>   	void *buf;
> -	int i, err = 0;
> +	int err = 0;
>   	unsigned int retry_count = 2;
>   
>   	npages = devmem_allocation->size >> PAGE_SHIFT;
> @@ -1160,15 +1253,7 @@ int drm_pagemap_evict_to_ram(struct drm_pagemap_devmem *devmem_allocation)
>   	if (err)
>   		goto err_finalize;
>   
> -	for (i = 0; i < npages;) {
> -		unsigned int order = 0;
> -
> -		pages[i] = migrate_pfn_to_page(src[i]);
> -		if (pages[i])
> -			order = folio_order(page_folio(pages[i]));
> -
> -		i += NR_PAGES(order);
> -	}
> +	drm_pagemap_migrate_populate_src_pages(pages, src, dst, npages);
>   
>   	err = ops->copy_to_ram(pages, pagemap_addr, npages, NULL);
>   	if (err)
> @@ -1235,7 +1320,7 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
>   	struct drm_pagemap_addr *pagemap_addr;
>   	unsigned long start, end;
>   	void *buf;
> -	int i, err = 0;
> +	int err = 0;
>   
>   	zdd = drm_pagemap_page_zone_device_data(page);
>   	if (time_before64(get_jiffies_64(), zdd->devmem_allocation->timeslice_expiration))
> @@ -1290,15 +1375,8 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
>   	if (err)
>   		goto err_finalize;
>   
> -	for (i = 0; i < npages;) {
> -		unsigned int order = 0;
> -
> -		pages[i] = migrate_pfn_to_page(migrate.src[i]);
> -		if (pages[i])
> -			order = folio_order(page_folio(pages[i]));
> -
> -		i += NR_PAGES(order);
> -	}
> +	drm_pagemap_migrate_populate_src_pages(pages, migrate.src, migrate.dst,
> +	


LGTM
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>


				       npages);
>   
>   	err = ops->copy_to_ram(pages, pagemap_addr, npages, NULL);
>   	if (err)


