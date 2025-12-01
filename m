Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C38B3D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 22:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8A36B000A; Mon,  1 Dec 2025 17:11:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159456B008A; Mon,  1 Dec 2025 17:11:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3BF46B008C; Mon,  1 Dec 2025 17:11:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DAE4D6B000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:11:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D4AB140404
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 22:11:45 +0000 (UTC)
X-FDA: 84172300170.25.417A2C4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf26.hostedemail.com (Postfix) with ESMTP id E6933140019
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 22:11:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CgP0wTLP;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of dan.j.williams@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764627102; a=rsa-sha256;
	cv=fail;
	b=cQZul4N0YGLRJHe/PzHzRo0CKySRBrK8Z+mlZKHGUGUN3zYimjotma3nzUUtcfqe0BmOeF
	Cdc2wNp6XPbi9XdcrbELXwKk8RUP6oyLl55B1cdf/lhtwcH8Y60bg9tofk7/fA4KTCfGQB
	FRk+Z8OorE32mJqabk1kaSsKM8ghMDk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CgP0wTLP;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of dan.j.williams@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764627102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aRAF/PNj63dkaLOGDxhgbUHrsIEK/cIZ+CozQ1oA4SU=;
	b=Ep4WHe217xCionWR7PJ7a3r1Fro6Wui+HONC8I2fcLdqZip0CANEYj/oStaA1KlT/ceufN
	P9moCkxZKdpOTyft/rPa2KZGvr38H2k21nnJvu0yYdsatFV4ElJhQ0Qvr1gNbfbtMkxMuP
	LOGYRruStsxa9GGbUNSscvZE61YWsFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764627101; x=1796163101;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=LqO9flA6T5ZlYQdA/5GHTdz/cNr8RJZoLjQFpA4rvjs=;
  b=CgP0wTLPg5tGNqFmuDMs0l0gbOq8WSXYXGozMP95sIMbREBl9ZEC6o20
   wLqcoasq1tLzBiCgLNOwjHrTgTy3Xfjyo6SB3wUAcdUTWED2IvV9g8bu6
   iFarAsSeJGxQ5bm7BEjsEJClQBYLajzW2oaXivsJ8zr60iHOxxszUFy1/
   147Eot+PXeAZHMsEOsJSojz0H8Cmq195Cc4CJ1N57bk6QMd/AHuWULLJV
   hcDvPbjKPjVCDWaZwwA9x9UVsq2//YqpppD62nzGActELM26JFcKICHnG
   fQaSZlsFdXKnX9qPEMDE+xRM5MOz25JqNQ7vQXkr8URvuEFXng7UjgNIN
   A==;
X-CSE-ConnectionGUID: ybtm5rv4QwaR1NjwOLYvuw==
X-CSE-MsgGUID: 234Hq7fLRd60mjHRGrtrjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66474205"
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="66474205"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 14:11:39 -0800
X-CSE-ConnectionGUID: RWJCgNd9Rxy6AQOqeah19w==
X-CSE-MsgGUID: wb0q45MQRGa95i5CCfx9Gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="198393986"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 14:11:39 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 14:11:39 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 1 Dec 2025 14:11:39 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.33) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 14:11:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IMLER5HpwNThN4urZP5MdR3lv8IZS8aNDI7LvTq4rEH5yZgHRSecqfI3+qF5xUvK+DDFC3CFSFujEsOlWp0tCW0xRE72uQKE3j1/w1r8EGmbXxAb1qblE0sulIWcDjJ1iadCAirQGgMnw4KaADNNOgj/pDi76kVyC7dTi9cwDA1TKzXLKWC71kGdAu0eKaV8mBxdLuMysHbJH0XQ0chSNG8OAiKnJZmexPDlZWE4ir303J+1eC8oyBnIWgRdx2Ak4wyh/y3YR6lz+lo8lo5/izF/+Y3YhrJAKK/DfUzycHKBKlRRMQVve93FXDPj5+bNds95XBNHklCe/7jMGfBFQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRAF/PNj63dkaLOGDxhgbUHrsIEK/cIZ+CozQ1oA4SU=;
 b=c28bBLKskb3J0wXXKEF4y7OsXf1SUAuEws/phQMln/0uRAZQqjg3O05cWpaAgY7K95rgLyhCdiFYFU07eh3wAn+tnBw+XW1K/+tJNTQeVz8q3dPRZkv5zIarzPYwxPN6IeDXcu3pQFnn885CpQjrL2keKoPbjWVaWUEInNQjBVrNZJXw/Uh7gBcNlhJLwimZvCa/Y4WD68w9B4C2aDITZ9WcSY0B4rlCU4eihnq24Cp9Rx6zykgWREgKm0I/KIR8V6zkNOKJ+ECUrZsle5FgfK6WBpCxCOsRm3RONS8+UnP/mYBRhlrA+5XOY3SIGzxGlkFLEPJGs141neqOMfXLhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by BL1PR11MB5239.namprd11.prod.outlook.com (2603:10b6:208:31a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 22:11:36 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 22:11:36 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 1 Dec 2025 14:11:35 -0800
To: Balbir Singh <balbirs@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>
CC: Balbir Singh <balbirs@nvidia.com>, =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?=
	<christian.koenig@amd.com>, Ingo Molnar <mingo@kernel.org>, Kees Cook
	<kees@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Linus Torvalds
	<torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, "Andy
 Lutomirski" <luto@kernel.org>, Alex Deucher <alexander.deucher@amd.com>,
	"Bert Karwatzki" <spasswolf@web.de>, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
	<gourry@gourry.net>, <linux-mm@kvack.org>
Message-ID: <692e1297e3b6_261c110064@dwillia2-mobl4.notmuch>
In-Reply-To: <20250401000752.249348-1-balbirs@nvidia.com>
References: <20250401000752.249348-1-balbirs@nvidia.com>
Subject: Re: [PATCH] arch/x86: memory_hotplug, do not bump up max_pfn for
 device private pages
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0141.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::26) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|BL1PR11MB5239:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f7fc381-4cb8-4875-8f28-08de3126981b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NXlCT0JVYUtKNldISkhocDBwNXNxV3JzZnBWT3Y3d092RS9LL0N2ckk2ZnBu?=
 =?utf-8?B?NE1qZVRWQW14YjNhQmdzYUpMWTgvOVRMM05WVW1KM0M3SDhvTm5XdDJrMk1X?=
 =?utf-8?B?Q3l0SHpLQVJEbEVoRlJEMzZLRzRQTXUwRVQ2djQwdzFTc2tKUEdFcEhUaTBo?=
 =?utf-8?B?VDNMYTlnNXcrMS8rVFA5TmpLVnJIVlhQWnkvMFVTdFpITlorVmNYaURpdVRn?=
 =?utf-8?B?d3ZSdWd4MkxLNWF6djVhL05OVG1yZ0VxcTl5dThtdG1kUmhocXFJVFlqVi9l?=
 =?utf-8?B?MjRBeEM5Nk1Na01uZUFoYmVGYnhyNGZWaERhL0k1UDRIN2RNMkNlMGFiaEJG?=
 =?utf-8?B?Vm5WWDVuYXRvblUwelI2RVhpYkhvZ1BDM1l2N1g4Z2s2VS9zS1Q4RHRrLzM0?=
 =?utf-8?B?VXZKYUZrdjgyanUwS3JHYzg4anNqZU1hbCsvbWkxcC9TRUxXMFB0RllnSjZq?=
 =?utf-8?B?VFhWNmJZb3NUQ1dZTUZrSGh3NmdKc2FnRjhPRWkySEZjVDVTVVFGUFZjU2pQ?=
 =?utf-8?B?QlI1NWpUUExSOGFYQVgzcTNCS090c1BKeEZXVE5qVGRIOWxyYTRtMjRHaTlq?=
 =?utf-8?B?VzVUWGtlTGovZ0dIanVUd1poWk94STNFLzlibHpVMEpBeFY3SC9kU2paemFO?=
 =?utf-8?B?Smh6ZWRwb2R4bWNMbitLOTV4bGxINFYzL0YzUUpHeVdmUFdPZkNGTnkyUisr?=
 =?utf-8?B?WG1DckJXdnF4bitvRTdRME5KdE8yT0R3dGVKZy93cVorMTE2cjlGK3V6N3da?=
 =?utf-8?B?NzJsbWp6Szc2RXgvZk5WcWVBejRjZGRoWkp6bDRiaGpHSzFraGFidGNaQ3Vl?=
 =?utf-8?B?NUMvRUhtQjd2SzRDYldjeHovMkZ1TVZOeGkrTEdJRkdpalVJTmJwYlZPaG1O?=
 =?utf-8?B?LzdReTBzUk5zeVo1T2RUZE44Q2RjeEhEdWlpbFNoL2xrK2FvcVNKaytXTHk4?=
 =?utf-8?B?UWVoSlg3TzhtUFoySkNGU2Q4QnVjTDRHbVNkN1BwWXkySUZHRHFDR2VCWDds?=
 =?utf-8?B?Y25wT3cxc1hSYWF6RU5lTTlVSXh5cXVMNDBjbjd1SkFoV2g0TUFqdk41V0R4?=
 =?utf-8?B?QjdMOGRoSkJjQlArRi9SanBtSVJQS3lUQ0lJcEZOZW90bWpBblJ0dy8wWlFQ?=
 =?utf-8?B?ZUw0U1l5WEE1MG5XcDhPN253Q2lFOUlZOUVSSUJqaEN0NXY3Y0poTE10dmxD?=
 =?utf-8?B?Ri9pYVJhci8ycTVlMDc4YzM3QnF0NDRmWTZRWVp3em82bUtPaDdaaW9ENVp0?=
 =?utf-8?B?QWtMeWJPeHViMFJQTVByd2lHTGVOKzVsaWUyd3dPZ0l6UVI0YzdWZURKV2F5?=
 =?utf-8?B?ZXRRZnhaQjdOaGhQUDVIV1QzUGRJWDVkSTk5OHdkZGhrbFJuV0g4NUUzRVJt?=
 =?utf-8?B?cU1DSXo1cno4QXQ2YXJJZjVlT1k4WTE3VjRPeWp3d3RTNGxaWTdwM0RMN3R6?=
 =?utf-8?B?ZTlBQnVydWRZVEhxMUZwUzFyNlVEMkFkS2FkNEI2Tk9xdG5IamZtWENrNEg4?=
 =?utf-8?B?ZVNwcVp0RmVmTWNEZFdraTZnYzBFeVM1dmF6cUNQTVJrUStCeFE4S01YTWZD?=
 =?utf-8?B?YzV4TUQrQTlTd2wxYllkRnVLQi91aG44d2MrOHFNMnZTMWZDOUhWR3JZandQ?=
 =?utf-8?B?T1RzUWRBVHRTVjEyWlhKaVpZc0lFMlIyUFpHbERFVEpabmdtREgvYmY0YTVW?=
 =?utf-8?B?aWwxR28zblBNcXpOTmxLbjRlNVZ1WFRwOVdXQ045azBraUFWR1kxWkZMRmVE?=
 =?utf-8?B?c2pqaGx2emFzWmYrSmt3QVk3UXhhOXFKOW5WeldPZEE5aWk3SnFXeFVselBj?=
 =?utf-8?B?WGhVZXp6aTR4TmZmVkVnM2F3YlUxWTVuSjljRVpMVVh4U1BPTGJBeno2S0dL?=
 =?utf-8?B?UUVTeTdsVkc4NmpJbmFpaUxNdkpYYnFDZ2pkQ2RCMEhIcGFQRElMZ1lSYmhH?=
 =?utf-8?B?WE1RaHFncHhuWVMxU3BFbmZsZXQ1UjR4bU4xMzJETFVrSEFBZnduUEVkT2J4?=
 =?utf-8?B?bjNMcWhrOGhBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eitYSTdadjljaFV5MTFIQ0E2TzdxZW1TRS9GK1Jtc3pkRGFlOS96MjdyMHFB?=
 =?utf-8?B?ZzAzRXZuNFFYbUtKY253NzJMZGovMjlXSlpOdlE0UVBxMFhMUkpJdTNWbng2?=
 =?utf-8?B?bGRtbkIxRkM2Rk05dGRUSXJsVHM4K3RSL2oxb3YzWmlwdWJxSHVKVnQrS2Z1?=
 =?utf-8?B?L0lpVjgyWHVyUU80SWZEYUxaVm1CQU94RnBtQXQxTENyTTRqZHVRdTJxbEM3?=
 =?utf-8?B?U1NUcjYzUk1ydTREdW5WbVhrK0FuNjFvWWhPeG5VcHhSVlBEdTBSQWY3UGdi?=
 =?utf-8?B?YWRqUU82bWhabHZNL3RMMXhES3BMUUtYeGxvcElJdFVtT0trQW9rVi90U3JV?=
 =?utf-8?B?RlVLR3p5YTRadXB2eEJSbm1qV2tTQ2l0elhWM1ZQYmtzV3JEQTB3NlExYjJp?=
 =?utf-8?B?SFJtWUxoeWJKOEcya3BwcVJDQkcxSC95SkF3RDZwNUszdmpoMmlZUkZRT0xn?=
 =?utf-8?B?SXBXWDNiSEd5dzBOMUJwYmI3c3ZWbXV2RFdRaHJveGNnTENWWVBJTUJLa21l?=
 =?utf-8?B?TkFKZ2NXWGt3cmRnSUdseTM2S2s5TW85MDJEVUNVOU5oTzVsLzlrMHZ4RDYv?=
 =?utf-8?B?bFpEMkMyNUhFdWJlRDludUVSUnpnWHhjcGRWeVpRZzlEQVErY1h1VThXNC9Y?=
 =?utf-8?B?T2NwRjR1dnRSWmZkcnZ2UzM1dnp4WEdURTFVVzVUNTA2b0x3MGhhZFBOOVVC?=
 =?utf-8?B?VHFOWklMbjFhYmFtNUhYbHJSV3RILzcvVytna0tPbjBJRFFIbjdLZHc5QzM4?=
 =?utf-8?B?WWZKMnMzU2RkU2lrekQ0UENBWmhUMXZaRzNDd2QyaE5DTndySG1hZDVtb2xJ?=
 =?utf-8?B?UWRJdzU3L1VqM0J1MFd3MWlqeVQyVHJ4NkliVkF2RmxxS3ZXbW1VNTYzVGpQ?=
 =?utf-8?B?cUthaHlnSm56bVRqUmt1SnlrOERZb3NlV0w3amtpU3pzQk9PdXRVZWVMWmFx?=
 =?utf-8?B?dnB1dXZXVkRLSkNYbHZSL0ZXVFNJRXhsUUxtT2E1TnNRbGJzTDk0T2F0TUxM?=
 =?utf-8?B?aTV5L041MHpIRjlsR2hxbmljVnVheDFnVURpc2pGMTZqZGJBOUE5WnYzTkkz?=
 =?utf-8?B?MHliSXdaSVZORVZtNUhqY2RhZ29UanFqRXVSQWhibFp5enp5dXZza0wrZmpp?=
 =?utf-8?B?UTU5SnRMbHRYYVpvMXBMenBqWWN1NnYwamFaNE42U1JvNkF3cXljV0FTSWRH?=
 =?utf-8?B?NVpIVVRVckxvM1J2TnltM0hSTWprdERnZ0Z3TjgxckJ2K29aMnNoaTdXYkpw?=
 =?utf-8?B?MXAyaEIxTk9wNVFXa3Qxelhhb2svaGIrckt1Q01oZjRxV3QzdmVxWlczNGxQ?=
 =?utf-8?B?THl3bS8xbXdmTm5WOHZpSk81WjE2aVhUV1VCeml1UzVRU0hTVjhPSHZsZ1Iz?=
 =?utf-8?B?U0lpYmsxa0pSMGQ4YlMwbmtxblRTSUJjUkllYmpWMzB4UWNkRW5nRzF0dVdU?=
 =?utf-8?B?U0oxYzgwRittKzFZWEl3NHF3R1ZRclBRbnVnVXBVeXRIdERhdnFvNXBnd1Yx?=
 =?utf-8?B?RWFVbVV3VkVMdzkvNHRkd0syUWtSTkxhY0cwcjZhczFwMnZOODREVXZVSVg4?=
 =?utf-8?B?dE1wL0FGTDRaWnlER2RGNit1Y2t5aXVWQ094MVErRVY0eUNtcHY4OVdvSmE0?=
 =?utf-8?B?MkNsNy9XemhsM1VxdUNRL1FsUlg3ODdmUGhIQjhjWkd3Z3FySTRJM2dBUnhh?=
 =?utf-8?B?cHZ5YXByaUdzODVzZklEQndQRm10OUdwaVliWWs4dXpnTkZOZXRtMXVjbFBk?=
 =?utf-8?B?Y212ZDRaRHVVMGpkUUdCU0grdGhVWGVCeW8wMkZkSzhYQ0dkd0xKbGpKYTZD?=
 =?utf-8?B?VzJ6RUJsdDdrbEdLcWRUaDdMNVJoMmkrcXc4ZmJvSEhiNzcwZzZpL3hBejJJ?=
 =?utf-8?B?UzY2NlhKbVFqTnN5NDdRaUhlRFVqeUMrYUk4Ukh1OVdoYmJuRHk0a3BaVk5h?=
 =?utf-8?B?MjhmcmRtWFRPK1BIaXR3WHpLL24zSzh6SmcwRUF3elVPeFk5akNsdzBvQlIz?=
 =?utf-8?B?YzdoR3RKNDF0eUc2c3Fra3VSYit3ZnZVRUIvLzBFMURXY3pKZWcySU5iUGMy?=
 =?utf-8?B?M3orS1FMZ2l5bC9DamVsMU41Mk0yUkVNdkhhcWhrU3NMdjdrdEhZUU5OZGtZ?=
 =?utf-8?B?bE9ERzgrNmtDN2ZybE5TSFJEcnJVaWhlVERQbGV0ZmM3Qkl0dld6OGQzT1Rn?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f7fc381-4cb8-4875-8f28-08de3126981b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 22:11:36.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /2Zx488yHdySJkjgosW5iK3ZFexL84xG5OA0OQnuHJ8vbF7E/Ezd79dD8N2ddwA8aOK9RnXwPwQD/J9NZYMIKt4s30qkwUyWO4pSI9mP6/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5239
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E6933140019
X-Stat-Signature: pd4xworm4kjeostfc1x9t9n9cahaxqe7
X-Rspam-User: 
X-HE-Tag: 1764627100-716110
X-HE-Meta: U2FsdGVkX18Lu36nt/Ylca/EPQmXPT02a5q3O1Ez8Qe9hUQ6bz7IP2QZllKTnLbd5s4vg7W3lOZR2krZCJE81/PsrttbqTat1iMXqMBo9Tp7n7Rw4OKdRG1fgRNhE4yHhanWUZy7yhO1kOa4wLKuJRo9qpW/IgE2bzqYqJTcWNW7De/VuRwuAnbG8UbQoS8YKtr4GiRpuwblrra8B4l74Wk4LY4P74H2jtXcjuAULFzBsJMRSE6Q73i/W6oGt9ZkD6N2HG21YSWWjn7UojWRMTn0Ee2w6ZXi57BDeLmnzPhN0+Lah4SOGMmArdgcvllBiadYyrcvzUuHvKXTp2+vzrqCYIzAzbKX4Dx9vynGrCYtOXScgEi3opbxFUOnbbz4+J2XBfEDJqmGwRJ3Ta1S0k2W0zS/msxQzSW/fWcJdHFojcSeUmj5buX53+XC9/OTXQov7fxCQhnj1aq7hwz+DJrCpsSYKp4TjESMewYOiX8CKTcGot5BxM/WisPPAbWKsAIkWXcjUxIeYfcFP1l/TJ53PKY6aKUPE/RpBU2k9i64qd1RaZdnjbtccX26IJGi+zzWkPjKu1unPTq8uSMrQDs121vLrVkD4onl3mvonuCp13SuoR01m3AAfv7zWJhEXKKdfrkdTIllbt9GRJFs2/neajgwQepoWV2RmvQ0X5mP1uG7EKkNMOaNt9BVRKQ6PzYcyw7/ZpNFiZChpZDbf1fkxIGwWmEl2npQMi/Q0RK+1w30sR6rPe+rtGcuc0824dhVbi/R6w+8HF4lh+VUI1LmZ9H2Eiropyq3GChrtw3fjAR+1XC/KnCnoocVSlk1gMaTm0fDquOJaELpZ6vUXi/jVUVi/ZezPBotT1YUSWx4IprTsYk6HFpsidbjPkLpJ8h5EGTJlGCXTBRZDYOKTrPuMdo2Oe05487NVptgCCwmAVzrLQGoA7LWqkAAso8aoUtyAniyRgoZs+N1Lvv
 OwGzVKKq
 /5HJc9wOA847/GJ178mSxuUh47+2BSonOhxEJF8PdwFjVnyS9ASMbOuJYQ1tHpo6Vi45ESJc1y87g58mIulkZDZnYIRhny6hp0WxmW1KFWGgTutUovDJHOdFkBoEnSNKPi0JvjqksshF8hfz4DuzaIbbvePWYEhqPigFZQq4CiSNj0y43qMSt4tlZR9ZSy4UeTfCPXWpuYxs5ZtgqpVTSuXnIznDsJrFrKzzEqwt0v2cdSgNT32UfVsm0IAoLVJTuJtzR3OTgpWsgIWfFP9Cggrkcx294DXnu+Gur/KUX7PZvyBkeA6q//zn0P/XnjI6MlK2KjygjbESY1C1Z9sG3QADwPEKil3KIAJdNjreeFuMqmsblfJLV3C9aNtOV6IJrCaLepxj9KszN9NsUM3wREyA3sMQMjBoqeVYeIfIhgCLIfzOWN27HaDJ4bdqQuvpqKY+2kGPIV/km1UYJpGWBTeIP3VtcWlnJzYsgAft0JDYGdQiiO1C5bEnkHZgrawygZ5CduHWutu+XTTKC8NPBCWUTuCl8LiRck/EjHB1+cpAIEYc4pIOmbRT4gAM8mfew3m5pofTWF3czhqFzIAj3jyUGUP4Jrqx1CkCOCrmKITomBNeFMp3hgfkSECuHwIRk0pOuP6UG12eAXXQoFEC8qYoqGksCLQowl9i8BnpVXB+b1h9KUqEokv2Vy0ks+Kch5iaOugNfgQmz54UtqT5yJqhl0NIujSzySeyvoemNteQY470=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ add Gregory and linux-mm ]

[ full context for new Cc: ]
Balbir Singh wrote:
> Commit 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems=
")
> exposed a bug with nokaslr and zone device
> interaction, as seen on a system with an AMD iGPU and dGPU (see [1]).
> The root cause of the issue is that, the gpu driver registers a zone
> device private memory region. When kaslr is disabled or the above commit
> is applied, the direct_map_physmem_end is set to much higher than 10 TiB
> typically to the 64TiB address. When zone device private memory is added
> to the system via add_pages(), it bumps up the max_pfn to the same
> value. This causes dma_addressing_limited() to return true, since the
> device cannot address memory all the way up to max_pfn.
>=20
> This caused a regression for games played on the iGPU, as it resulted in
> the DMA32 zone being used for GPU allocations.
>=20
> Fix this by not bumping up max_pfn on x86 systems, when pgmap is passed
> into add_pages(). The presence of pgmap is used to determine if device
> private memory is being added via add_pages().
>=20
> More details:
>=20
> devm_request_mem_region() and request_free_mem_region() request for
> device private memory. iomem_resource is passed as the base resource
> with start and end parameters. iomem_resource's end depends on several
> factors, including the platform and virtualization. On x86 for example
> on bare metal, this value is set to boot_cpu_data.x86_phys_bits.
> boot_cpu_data.x86_phys_bits can change depending on support for MKTME.
> By default it is set to the same as log2(direct_map_physmem_end) which
> is 46 to 52 bits depending on the number of levels in the page table.
> The allocation routines used iomem_resource's end and
> direct_map_physmem_end to figure out where to allocate the region.
>=20
> arch/powerpc is also impacted by this bug, this patch does not fix
> the issue for powerpc.
>=20
> Testing:
> 1. Tested on a virtual machine with test_hmm for zone device inseration
> 2. A previous version of this patch was tested by Bert, please see [2]
>=20
> Link: https://lore.kernel.org/lkml/20250310112206.4168-1-spasswolf@web.de=
/ [1]
> Link: https://lore.kernel.org/lkml/d87680bab997fdc9fb4e638983132af235d9a0=
3a.camel@web.de/ [2]
> Fixes: 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems=
")
>=20
> Cc: "Christian K=C3=B6nig" <christian.koenig@amd.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Bert Karwatzki <spasswolf@web.de>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
>=20
>=20
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
> I've left powerpc out of this regression change due to the time required
> to setup and test via qemu. I wanted to address the regression quickly
>=20
>=20
>  arch/x86/mm/init_64.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index dce60767124f..cc60b57473a4 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -970,9 +970,18 @@ int add_pages(int nid, unsigned long start_pfn, unsi=
gned long nr_pages,
>  	ret =3D __add_pages(nid, start_pfn, nr_pages, params);
>  	WARN_ON_ONCE(ret);
> =20
> -	/* update max_pfn, max_low_pfn and high_memory */
> -	update_end_of_memory_vars(start_pfn << PAGE_SHIFT,
> -				  nr_pages << PAGE_SHIFT);
> +	/*
> +	 * add_pages() is called by memremap_pages() for adding device private
> +	 * pages. Do not bump up max_pfn in the device private path. max_pfn
> +	 * changes affect dma_addressing_limited. dma_addressing_limited
> +	 * returning true when max_pfn is the device's addressable memory,
> +	 * can force device drivers to use bounce buffers and impact their
> +	 * performance
> +	 */
> +	if (!params->pgmap)
> +		/* update max_pfn, max_low_pfn and high_memory */
> +		update_end_of_memory_vars(start_pfn << PAGE_SHIFT,
> +					  nr_pages << PAGE_SHIFT);

The comment says that this adjustment is only for the device-private
case, but it applies to all driver-managed device memory.

Why not actually do what the comment says and limit this to
DEVICE_PRIVATE? I.e.:

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0e4270e20fad..4cc8175f9ffd 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -989,7 +989,7 @@ int add_pages(int nid, unsigned long start_pfn, unsigne=
d long nr_pages,
 	 * addressable memory can force device drivers to use bounce buffers
 	 * and impact their performance negatively:
 	 */
-	if (!params->pgmap)
+	if (!params->pgmap || params->pgmap->type !=3D MEMORY_DEVICE_PRIVATE)
 		/* update max_pfn, max_low_pfn and high_memory */
 		update_end_of_memory_vars(start_pfn << PAGE_SHIFT, nr_pages << PAGE_SHIF=
T);
 =

