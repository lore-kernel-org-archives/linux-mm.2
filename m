Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE1ED0D176
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 21:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D776B0092; Wed,  7 Jan 2026 16:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E505F6B0093; Wed,  7 Jan 2026 16:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1B0D6B0095; Wed,  7 Jan 2026 16:02:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC1F26B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:02:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 793D21AAC4B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:02:40 +0000 (UTC)
X-FDA: 84306391680.02.2153938
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010057.outbound.protection.outlook.com [52.101.85.57])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8D19B140015
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:02:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=po79M7gv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.57 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767819757; a=rsa-sha256;
	cv=pass;
	b=OU7ko7Y358/WyxvMVm/TTHjh5KMCaPkV8KtLPJbywhV6UNGJd5utHWG4LLAr4VA+tiiVdJ
	LnSNG2NFHBfsBtRMtIqv7AdDlE5b4f4hUUk1gMeOqE3Ew2GEtW9TqtQTPedWZamn80O5wB
	Y1KeYkUWmk7TOGoZPm+/WktKaxovtUM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=po79M7gv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.57 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767819757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swAUCZxgAJwsCrP0iBvWMfPhsmnhIrxfbsUSHAYYT3A=;
	b=ch40V6UQj39hL3QpXBepCqROBQs8r9ygUbXcTkndPWi+5jyPt9ayMGYXbSYkYNDPIa5FWN
	eHk3nqhjdlfit243MMKBMvdywf1RPvJthm83ZR9H+VTbNI2wKTlEVHIv59kMdQpEKqpG5Y
	b32GBRExogy/OULUj2PlOBFxe8OyNNU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DpUebXD0lyl7QaviQ8DS0rKFePdXRkb+HNvounvZtVA5g1QkQQOIlwZI29653Gi8haWSX0zwNuzVynlSgbQEAO24FgKi+LMoyAORYhqmMP6rRrPLATs2tcwfD7PqFJAXHHjX0FsT39O5pbIcbpHrp1O2KcG4vmpbULQ/Rxwhfe6Pl5z85nvw7M6peuB2KF7/7FM2K+CwJ9m/7FRISAe0S5J5512aXs35t2XUXK/GkNwHU79kZ8PnbC1GbFsMuHiESDu3Gpn8klBPsMFnYgZRafmvkI09VedOA1zhyHkz5tYrwKR3z/euNyqWPNXUfSQIzcWOQd50knZ6pHvFadGYNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swAUCZxgAJwsCrP0iBvWMfPhsmnhIrxfbsUSHAYYT3A=;
 b=KTckA9gFcgnhe0cnzDl4hcPL/GhiMuhfi7ei/9pbroLF+2F8QHHM+VcKLJCAm8UszZOftZK8kbhJ1zlmZlwhWULfUYYucyFKG8yy9bOpHfWnc50n6TV+hJShhZXpJxwAD2/G5AtUh9rC/FoPw3Az1pmQk2r987gjOhQnVQjYY2E5d52QuxQfAy0Gw/3qVl3tsRPY9CemWqm5M5vx/SKSWIq6BpVnJ6+QRSQZDiKpfJJWR5GmzmbPt9fs7YOTl4H6DDhnA/ITva0g0la2LWOm2bCIkFMHHAO9E348uXN5d4N2I6hwpd7JjvPGZ4R9ArHuJmrf+fI0Gt/h2GrCdXl0WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swAUCZxgAJwsCrP0iBvWMfPhsmnhIrxfbsUSHAYYT3A=;
 b=po79M7gv41XACuj+/WPvPfrdkyot3yCLJTBPCJ7U38BXwZd+AL455rJrMIyJTbtOm8UzS25SNVTtDeVcTxpPSQXTtUmw6bNnmZCkXsBAA+K1VIoUOM3OzeG/mu64CU/o6BUykF0KYTZ+Fguj776hJEYDe23Fq9zxsV9XeFkkrPMOEfq0jefDRY9uN+u641ZlgoruQwBzYsj8XDrsUMIe2r2GbgVzITbxkq/iQkTuIpLrNCQ+u6G9/1ubEnQdkwAerdBkKty0ioYrPcApw8LKRFi4uMPiU9zlXZkaEsp74D4VBzaK3JMWPELzc/YjQBR0O+Rw4iikmKzJ8bvmb6I66A==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Wed, 7 Jan
 2026 21:02:31 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 21:02:31 +0000
Message-ID: <c288bda8-66c4-4971-9322-e1450855f93b@nvidia.com>
Date: Thu, 8 Jan 2026 08:02:25 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/11] Remove device private pages from physical
 address space
To: Jason Gunthorpe <jgg@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org,
 matthew.brost@intel.com, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, david@redhat.com, ziy@nvidia.com,
 apopple@nvidia.com, lorenzo.stoakes@oracle.com, lyude@redhat.com,
 dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, Felix.Kuehling@amd.com
References: <20260107091823.68974-1-jniethe@nvidia.com>
 <20260107120608.5ccd2cc7e4227d2e80028bd9@linux-foundation.org>
 <20260107205404.GI293394@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260107205404.GI293394@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::43) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA0PR12MB4431:EE_
X-MS-Office365-Filtering-Correlation-Id: 44ca71d2-bd00-4b32-2b04-08de4e3012c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aUdYVkNqL2JLWHlxSXRpU1FIaE8vQkxmL3NIYndCaVo2RWxCOXVtTG9obGpy?=
 =?utf-8?B?QnMyTnVLcmtFdHhxWGpMVVdEbDFuanhxMFdYYzNLZjh6U1poREtXTytuYThz?=
 =?utf-8?B?UkpYUlRuWExBMkw3Sjh0U0RVZzByeUF4SmZoSkFqOTFoMFlEMjMvVFVqUEJ4?=
 =?utf-8?B?WTZYMFJHQklBc0xtajV1NmpNekowQ1RSYUtxN1NOaXFpakkrbzlhbERsaW9F?=
 =?utf-8?B?d2hpbk5GZERoYmtjTDY3U3JzN3J0bVVXeUVSRmhEd0JtSlIyUnFTL0c4SVhl?=
 =?utf-8?B?YmZvVzY4OVBvUmpOWUhGc1g4WTRUZzZrS2NId0xtaks1VzNEZWZiL1h4YVRN?=
 =?utf-8?B?L3BPWVJTVFFVQng2YTdFK1hQVGtjaDBBbG10M2hnRnR2N2JWejIxbm1ONXFa?=
 =?utf-8?B?ZUYrMzJJQzk0dkN0VjBDSmZVeSsxOTVHa2FkS3Yyd05aLzliMjdaMDExOTRs?=
 =?utf-8?B?Y2I0SmtrdXFENWIzeHVTSnlGTkFBTFFBRzgydk9Lc2VFMVd1ZG5EM3BQeTlP?=
 =?utf-8?B?RDRJWHNHaEZ3S0ltWXBjajhXSjAxOVA4d3BqWkFQVkpBNkR6ZWRRRHM1eW1a?=
 =?utf-8?B?ME9NdnkxWDJXYUx4YWkyYi9HRGt5eGtIMXBMdW85YjN2SVIxc0tYNEVrNjR6?=
 =?utf-8?B?SjlRbzcxdnExWkZDbzFzVXoyblA4dzBmdTVIOHExSWZ3Y2o0WTJLRjM0VEtQ?=
 =?utf-8?B?dlRCZndnQWZ3MS9XdnNjb20vcGJWQmkxcWZOb2xTV1hnelhCeVhpbEdkTHlh?=
 =?utf-8?B?djlqVXNJaDc4d29qcUtSRDIxR05nd2U3UTdQaG9ycGlncEtXQUQrbkhqRW5D?=
 =?utf-8?B?elJwTmduS0Frdk45SFdGZVpmdDdDQW5EMUtxQzUxSlhHL2N2cHMyOFluaUd2?=
 =?utf-8?B?QVZJWGx2Y0VJRzFtbVgyQjFXM1BaQzdRbkY5ME1iR01aY0FqeW9kTUFlTXFq?=
 =?utf-8?B?UHpLbGZxbjVuRlZoOTk2RW1mMzVIQ1h3WlFvUVVrTjZja3NhZlVqOFdmUlpS?=
 =?utf-8?B?T0hlY1lnOVdjWXVVWmJFRVdTRE5qWW9SRndXdTJ5UE41bFIwcG44V3h0TXhJ?=
 =?utf-8?B?OStjT2pHUzhCcWVWcGJrZDY2eTBHbGgvaXB0bW9aNE9veHlxVXpoMExaRE9Q?=
 =?utf-8?B?WGVlV25Bb1QvU3ZySnBuZTB5a2wxVksrclFWU2ZiUy9JTDNtK1FnbmdFSWVK?=
 =?utf-8?B?YzgxMCtGM2V4Yk8xUStJaHUwdkNZeG1kdG9iNDllNXc5ZWtvL3BvU1hENUNj?=
 =?utf-8?B?OTR0N3EwSWRpeHdpcVBmR3hmQVNJZjR6TXlOMElWbUF2Q05PV0VPa3FHYWtk?=
 =?utf-8?B?YWRhMXFHUWtBYTFOM09xMjFzOUFzeEpCTUR5N3pPSldaVUtuZnl0Q0d4K2VK?=
 =?utf-8?B?YzhNcUNyWU8xN2hKdjFkY2xQY0VWQ1k3dWQ3aGlCeXdWN3JlWGVISzdnUllo?=
 =?utf-8?B?dlI5Ui8reHF3UTczQVU1V3ovTElVSmxNWjNkYVErdG1HYmJKOXdIOXdsejZX?=
 =?utf-8?B?R2NaVm13NU15VStlU2MzTlh1NUQ0bXZHWjJUTElscmNXaCtRWjRZT0gxSGtn?=
 =?utf-8?B?dnF1SlRxNVQxbE5xZklaS1NKODRodFB6bFJHS0hQbWpPZ0FQdHdYQWQrbGVh?=
 =?utf-8?B?blEydWM0Z0dYaGJId0h3UHZweE9xejI3eC9uZTdnbHJEckdPWksyUXg1L0la?=
 =?utf-8?B?V3l2Q0lRODNWRjBrZGxIbnRuMklqYTlJK1ZvRHBSRlBGVy9xMlNLaEdJN0E4?=
 =?utf-8?B?V1dTZlNOTkdLUlZ2Q0ZCV2ZVd1VqMHFMNFFRZlFtZk5QL3JaaHpyajZoU0U1?=
 =?utf-8?B?MUZvbXRUYVowZEF2NjNJY3duZ2J4enJCM3RYd2lQMlR5TS9oSWt1NXlnb1lI?=
 =?utf-8?B?dWNjOFo5K2lpNHNwbG9zbC9FakpMZkwrV2pTd0xiNHJONTZieEV3clMyWEVH?=
 =?utf-8?Q?D3rI+IORTw3X5rVdXIvM94KhMh9uDYek?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TjJiOGFJSG8rL2huWmxxaDdqQnlPenBOcWhveGVLT014LzA3anBVY2RWSm81?=
 =?utf-8?B?dStjUHN2UGYraVVKTXErRWJyL2puelA3ZFFtcTVURGsyZkVldWk5VzJmcDBp?=
 =?utf-8?B?R3hZTzZQK2pnR0xQQU9BQ3FGcW43akFFV3FxTXZlQzN5ODc5b21PQzdQZm0v?=
 =?utf-8?B?djc0dDI2bE9NZlNIZjM4QkFCQU03MmY3MXVURVdYVkdHTWRaK2JIa3hKbERK?=
 =?utf-8?B?VW5kOFpoS0tNMlFxRVIwb1h2ZXFTYzVIMm5WeGRqdHNFYURGYUJaL3JXdHZi?=
 =?utf-8?B?dkxFL0VDSkM5cFp1bi9rY1dQMWVLdHgvZXFtV0hLS3VpQ2tuNkZXajBFYWY0?=
 =?utf-8?B?YzhpaUJSSFlnUlJueWpsd3o1TUcwcWJuZVNwU25sS09xN1NCRUlmSXdRQzky?=
 =?utf-8?B?ckZvc0J4aHk4SDdlbk81WXdNSVJ3S3QzTjY1UGZLK2tiYTFFZDBlNTZwL3NY?=
 =?utf-8?B?ZHBQQ1F3NW1uWTdhSGVrSTRDTWgrMnRsYU1OMi9SUHRPemQrdDgzbWd4YWdj?=
 =?utf-8?B?SU1ZZldWVVErWExaVTFrb0JCWjN1S1VNTXFObHVCN3JWY1Rzcm1FMTVrUlU4?=
 =?utf-8?B?UGcwRzNuN3FDdnlkUjByaFpGVmdpM0M2cWxQU3RScjlCcmtBc0tMYVczUnJT?=
 =?utf-8?B?RzNtUE9oekhkV21jT2xRcEpkdHY5VVFKS1N3bWVLQWJ6SDJZMDBTLy81UjhC?=
 =?utf-8?B?cGgwd1Y0YVBqbXQ3WGFUUU1rVjRxWmxBV1JTbWtjeXM5WjYvaSt3bC9XNk5l?=
 =?utf-8?B?UkZEdndiYncwMzdQQXBlVThYQmdxemFxOHNpZjhReDMySWNGVUFRbXRTRnQ1?=
 =?utf-8?B?eG1tVmNXUGp1S2JMU1E1MDZQWm1lNEZKaG9NV0lBL01CMURkSDBIK2UyVE1a?=
 =?utf-8?B?ajBKN0dkOFVJS0IyQWwrSmV5Mm9hMDNzRUhHaytCN2xhZ0E1SlQyZmFPMVRk?=
 =?utf-8?B?NE1pOVlINzdweUVxUmxiOGNRZDZqa3Z6THBkNW4zQ2FWOVFMSnNRSWtRVUhK?=
 =?utf-8?B?dFVjd0RIazczQ0lFbnFjaURIM1J6UDRnNjB1cE93NExSSW1TOEdOWS8rbWt0?=
 =?utf-8?B?R2RaYkozNENRbStJM2NqL0c1QjRKN0NaRTVTYTF3RTZYRVQ5NUJpV3VLVHNw?=
 =?utf-8?B?SkdTQ0hlc2xGRk9UVjNweFZvNXp5NFV4UlVSb21WZVE0ZkhscWRaQlBsMlZv?=
 =?utf-8?B?OUJSNW9hdzUrY2ZRc3l5RGZSNDBWbTlGT2hTMjAwWTRQVzZzVlIxRXliRlJi?=
 =?utf-8?B?MHVKRjFqTXVrQ1V1K05WcUZqNFNaWjVIYmxsemZhdnljNmNEWUJvMDE3OVUr?=
 =?utf-8?B?WENxMFFqV0V4RTQ2WmlEMm0ySlg0aU5jcm5SR0ttZGtONzduZUZSZVBHQnlJ?=
 =?utf-8?B?bmgxMXloYU1NUWNNdWxvdTZ5ZXhlcWNHb3JEaGNJVEZGcE9yaWw1WFBBN2dq?=
 =?utf-8?B?Ri9uTTRtekV1MUxqNzBISnVKRHh5NllZY1FJU2VCRU8wbEczSzBTcUtaZzYv?=
 =?utf-8?B?bFR0T0tFZG9nR1hJK1RjTW1pckFmUGhMVzlPYTByWFlXT1NpZ0RpRmZQY3RM?=
 =?utf-8?B?RXB4Njd6RFdML3VBa2RYS05KRHNUd0JDN293UDRJZERuRFk1bjJRQmVYSHBL?=
 =?utf-8?B?UUlrMGRxblQrVDRkY0c3czhWQStKN2JOOXNoa25Wb05JWVJNeElYMFBmUkxw?=
 =?utf-8?B?a2tZeVVnUFBrSW11djRoSmFoN0t3SVBndzlYWit1L0wwV01Fck1yRnlCSVB3?=
 =?utf-8?B?THJLVEdSUFdjN2RLUVdrZ3luNXpONk5PaTRUSGtWMGNteUl2cEZnRWFLM2g0?=
 =?utf-8?B?TkhvRDJFMXlLM1NOTFdFSnF4VGI2QUFSYjQxMlI5WWFZZW9VMS9ySzQ4Q1Fj?=
 =?utf-8?B?L1ZoNzM1TEdBdDZSYUF0RG5hT2QxQlZYUmhIcGtpMnE3VTVESjkzcTJYN2FJ?=
 =?utf-8?B?d0xveTBDVlpyVEMvVkM1QXVYTFM2dkZmUGt3djI2NWk5N1JPOFJZbHVIaEhQ?=
 =?utf-8?B?UjB0OTA2c1h6aGFMV1VXY29UQkZKbXFCeHpHQ2ZNd1U0M2x3MnJNMUNvNDhp?=
 =?utf-8?B?aXNzV29GT1MvZFRPRTlxdzZZaXJkZ3huWnJvL0hEekxXNlFEdjRydTBIT1VF?=
 =?utf-8?B?RHJJSXpEQU1qdlNsQWIrYVUwWVo3WEVaUlNpa3BsS1RWMnlzQ015WHpCaXRt?=
 =?utf-8?B?UXRlb2tRZSt2RWtXUGhLYXBINnhmNzhyUzZrM3hSTWltTk83TXBjbU1icGFR?=
 =?utf-8?B?bW9ncFA5MW1HSWFoeTV6TWxhcGNNWWhQU3A5ckpaL3RCRkJ5MjczZmVPcWIx?=
 =?utf-8?B?dXlSa2RYV3BwUlhlWVpsTFlwNWlTQ0QrVmUyMEJwVWRDcm5ramRsU2N3a0xN?=
 =?utf-8?Q?SKOo57DEzaInQo4y7o589A+HqiWw9rb2Wexqx3NE4qNWw?=
X-MS-Exchange-AntiSpam-MessageData-1: Jht4B071kJBCDQ==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44ca71d2-bd00-4b32-2b04-08de4e3012c8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 21:02:31.5033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f/lWBRVtu9+Uy83Q+EiwixRd2v0NT0I9qIxlekpPhmds3o0M4WNhfHTAVORQO6yQHQkLp/6gu+9d3vsUq9KiEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D19B140015
X-Rspamd-Server: rspam10
X-Stat-Signature: y5m4uzehbpk1gw7itdp3an5im87j893a
X-HE-Tag: 1767819757-987440
X-HE-Meta: U2FsdGVkX19G6U5epPw9mie8ZlO0P/SbvWURw3QpQaOzFUfhI5DLgXVAwg4eeVOSGFQqQSD9R5D8fFwWkfPk8RFD8+iTRLlj5+PRlD/HS6oEJZbTItVtdgeM4OQlBs8S5fMrn4fLMvWyMAGg8KUMpljUTY+ZxApVWodgfBGmeAMUdAEROpcx0nkYEGPfmYr1ZIgzTTyl283sBPqEq7Gik/aXYlR82ypwr6ZZW8//+V+xs9WHqP77PSdUTNqeu9D4vvZGEIR5SIn9bM7mIb/+114inAwBP1b7BSIZgW1Xh0NQrBb+lATTuCBQog5Jym09Aa6IY/XGCgCmwqXoda8isL+NglYDYiU11NvxAVnQCnN/HqmcHcRyZoeWZ6i4szlzX6CdyiEpML5MqyUAsy/4pNTJL8jo0s5O1oEF9JmuVhs0yWUdk8+wiKH7WMIVJ9QSCzFooS+t6a9ZhirCTfWlyA+WOR0d7ozNjrkzyeZSJxSw5rMyELHeQk2vxi/cmKa2VPjJa9bzqbEax8X1Ial5oEgloPPZMDr0idihZ6iuIL4PcfbvGJNY4HpsosZ9uLwI8ks3Y/Ifc1voFfL9mDinMwxum1/D0DAnY9+GqchXOkzVOqH0ov3NT5GIESdccWvh7N8XInEgfKjd1ajFXlESBvosi5gj8dWoNSLcrU2V9a3L4qk2T5/ezMxoOqZCTt26e5cfMkHbhHCkHBGp48WYUJV0tA0/s9qd7aTCJpFm5g8vtSJeMaTOzIu7bup7Lk+KAC57hwQChTmdDJu+BeTG/KaV+Dmpknuzqm3U/8o/vFrJ5FY8M/I7rmlEeTP2JVEc+ThMLl3wBRT04p4H+ACKumR8Vkmf/h6dwRkHb1EDZeelh0K/9e4j1YTjUi3jrGl4TW6Dk3lnTXbl2kl17hDXSld8iVIGjXwmo1kLwSVodEU0o5l+Ql9bn24g4r/dYlTPSndzzT1QKTnrU9iKQk9
 saWvhgW+
 MGNwkh8a8vsiDgrYxbwACT7jtEIvmkbWup8UtgPN8pCeK5N97RerrRM5qKW4Am8clq7y2taCc7i5fibadf1zCNKYWqbaivhW8utN9n91FnmoKJtz8CQi/5ZHo2xYYZhFd++6IpHfs8+UmBPBSqnUVhdzk49Ey6CK+5HTyVVdFEtjX3DazI4uho1hY2VflG1zqqc7NsL9/7SZfWjp4bcByXFO8VvQgX688CBlLnuXn9gETOfKQV4sp/8WN4rxmHa6siPT6kOn0SEBNo75i3mASmWN44PUeamGnDX53YgO5gWHmPlf85+OfrAZv3HI/RqSWVN+wusBveZX0Tgq7A0mZH5SiPayTy2qlyGhryVGCdL6tZy3KCbAleViT1Whzqy9QaIuxCHxj0CfiCSertu3/f6cRlbltCsRUJtEW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/8/26 06:54, Jason Gunthorpe wrote:
> On Wed, Jan 07, 2026 at 12:06:08PM -0800, Andrew Morton wrote:
> 
>>>   2) Attempting to add the device private pages to the linear map at
>>>      addresses beyond the actual physical memory causes issues on
>>>      architectures like aarch64  - meaning the feature does not work there [0].
>>
>> Can you better help us understand the seriousness of these problems? 
>> How much are our users really hurting from this?
> 
> We think it is pretty serious, in the future HW support sense, as it
> means real systems being built do not work :)
> 
> Also Willy and others were cheering this work on at LPC. I think the
> possible followup to move DEVICE_PRIVATE from struct page and reduce
> the memory allocation would be well celebrated.
> 
> The Intel Xe and AMD GPU teams are the two drivers most important to
> be testing this as they consume the feature.
> 

And the ultravisor usage in powerpc as well (book3s_hv_uvmem).

Balbir

