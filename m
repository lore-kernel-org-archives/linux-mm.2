Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57326CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 14:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1D8900182; Thu, 14 Aug 2025 10:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA976900172; Thu, 14 Aug 2025 10:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9951900182; Thu, 14 Aug 2025 10:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98BA5900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:47:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12755160628
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:47:57 +0000 (UTC)
X-FDA: 83775642594.18.6A86EE7
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 552A712000C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:47:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ns2OTndW;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755182874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zf4PqAOlnr7BD+MW1FzZR5tu1aLCGhAvosH0pHfNb9Q=;
	b=hB82wzqrNOgxF083QPF6ZLjJ1wOOW2uShuLnOtyS+Ag+bd7GN1OgBUWBBZ3KMJBo9nvI8d
	fE3WDD58XT8EmV1rju2tTv52hRHhgq6d1H2WnD5BC3R7rWUZ+ZtBoWF6GkJMaYPfYAAFBD
	PJ5ccNjGpebzxpEPFmfd9xaactfFG74=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ns2OTndW;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755182874; a=rsa-sha256;
	cv=pass;
	b=e0XkJirSzFmBxGJWPOIEQgBX5pyDRzuZL2pYFsGcChgW+zP8S1mQlGHX0gbzsF+YsC2+e5
	G2KBPBiPXiQbUcLq9NTyOAYrX6Syw7Hfp3UgZ7qhoAMR2Wa1qiTCyi8v3Fn5oTsrCKSQbA
	59Zkx36rzeEE0YHHPPlCORjRGIoBpko=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iQe7onT26a3f9XwrXTvTyOTlGq2qqG1JpLWSBtMEdHmokIhUrzSzjBTTsL94E7IsreUAwXQHEgKT0/Vu3GdEb2OtzKqsM6TGShthfUMZCPYReLC7lcWC/fgN5cee9pZjLvYUKR2r7jJD1yCL0TGgJk+S/aAdifCbB9hDMIrsehlFw5Lq9Nv+8QsBPBQZsiBqxDKI6ZRO2VSApOwzo3b9zHGs7+LfKFSU+HvthtBwWNMqp+Zj+w462Eo1EUSY5wsg1h7PePlkgGCfOfVmmXG56JwmaCmaHVbwaRDKuNVnr3uqTnTAHAofAXvhjEDLhOD2Qs64Ft2pm5sMZWp2nUsc4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zf4PqAOlnr7BD+MW1FzZR5tu1aLCGhAvosH0pHfNb9Q=;
 b=sHzBh0eXYzff2mW2KkU+QPQgD11l4+MdpbILJPBhaj3QC6+2e/bLgVamFnoP8aUBwn3QLmlrFOF1/bHazhneEhyCABXxyfhIOhlrUUnXENrVlTphn7u+ZAKzO41/9oVJ5xb+sB2/i8u0KIqvoex2GZP5+16TIsw9Q1TmtzGXykCg4R/hGy90blabncN0i9Qo3wFl25gFqbB68gCpR4GitvnVCPMHHK9muDzlwmQcxcnoj05OhMDLRZAcEUKPVpWaY3ArY/ejnIceiLcFSRWNE5LyAMdkXaQzojo41iO8EozMNaNI7FQ/t8sKl+5JXJmyJnh+VgZxZD+Zz2p4zwy5AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zf4PqAOlnr7BD+MW1FzZR5tu1aLCGhAvosH0pHfNb9Q=;
 b=Ns2OTndWgFmWxe+JWI8wZhAtt8OpoyogLXSa5iuuHU6VApwOG8rcipgyxlgkFPsNTijo3MVx3A/6KaKYzZcwCJJPf9iZl24d7bqXswVBb/3Aj4YtuP5A8WDsEi/e4HbE1N+H0+gjDEtwJn1NPzrBVKOFmDC7Dqpw43MxtOOC8bEU+hQjCdWoi6q+CbX/8WpJYeU33XN4OiM2dpIOG6x3WJ51a11BkyGQg0QuiMkwQH0LiZrTaAUGUUTfJzqWp7ltrCrXxWZ1JUcS3huWqscWzJy/k0puG8sViiIJLObGF5AaYsXWCNpv5GQ7NllW84KqoaoyJfidVQVtnQ7mmf6vnQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH2PR12MB9543.namprd12.prod.outlook.com (2603:10b6:610:27f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Thu, 14 Aug
 2025 14:47:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 14:47:51 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Ye Liu <liuye@kylinos.cn>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: simplify lowmem_reserve max calculation
Date: Thu, 14 Aug 2025 10:47:48 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <EF575A1E-6AE2-45D7-9AC0-49C462A0CE5C@nvidia.com>
In-Reply-To: <20250814090053.22241-1-ye.liu@linux.dev>
References: <20250814090053.22241-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0074.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH2PR12MB9543:EE_
X-MS-Office365-Filtering-Correlation-Id: db9bac72-795c-4f53-8d2e-08dddb418b53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dTZQTlZKMGJCYlNvY3Fkc05oaXlnV3hrV3g1WHNFa0RyQTIvenJycTFmWXRL?=
 =?utf-8?B?YUFWR2ZJZlhFdVNVU2hSYWVvRldLaDd1ZHJEL3dleFJMRzZaL3FQdUc3KzZQ?=
 =?utf-8?B?c011MTNiNVl5SUx1TEViT3pBS0VSWis3R0ZXdCsxVVBGTkpORzRXcnZyeHhN?=
 =?utf-8?B?YjMwb2FVS0x3OHgvZGtoTEpBM0l2UWVBMGZGNXpTaENnS05rUnVldVNBNnZh?=
 =?utf-8?B?Ulhxd3NjbEdUelhsVWltYVNUNVh0b2ZEaElScy91RGxnT0M0Vlc2WnB4YVgy?=
 =?utf-8?B?WE51eFRaZDM4UFMwbWI1dnZXZklrQ3R1b0FDR2MwbTEyOU41d2hobVVIOTJq?=
 =?utf-8?B?WGk5TjhzbUhNWTRhaVhBaDVLZjQ4MmlCRExVY0pvODVPVXEyekhSWk1DUDhO?=
 =?utf-8?B?S3JBd2RhZjNDRkNFcGRpbkZhdDcyOFk4TUxsMGl4WUVRclYwRnZpMVlQa0xi?=
 =?utf-8?B?ZENtRXNjRjZ3RXdlSnp4RnF4UUJlV0dlY2tHK1ZvSlFMWGhlNC9zbzNOUjJj?=
 =?utf-8?B?NUNDRUpXT2puK2tTd3NlYW5wMm1vVldDaHJrcUpYQmkvKzJtVVRhbGZkaFVE?=
 =?utf-8?B?eHdZMlFtTi94ZFQrVTl0eHlMRjlodythY2xhb0FXNHE0R1IxNVdBYXhuUlFl?=
 =?utf-8?B?S1R5ZzQzLyt5dHg2NUgwdHdiYkhtUWNpZFNYY21hVVFiM2tCRXB1ZGNPUWd6?=
 =?utf-8?B?S3JiMFdZN1pVdkJxTyt1eVJobytQZ1dqNWc2U242cFNkdEhNbUc0dFRiSFBQ?=
 =?utf-8?B?dS9PamlBWk5SMjdndUljQWlybXhtVFY3Uk9PZlQzREoyZ012VGlqV01VYS9z?=
 =?utf-8?B?U20rdFdBc3hkL2szckY4RUpxUzBGSDBOMkJ2TE1MaHFTUE50Qi9qek5RWWRq?=
 =?utf-8?B?bkRZOTA1OTBndGlNWER3L0lKZm9zbER1UWphM1NzbjgrU0pGQUdYc1RtdW1X?=
 =?utf-8?B?N3k2czRydjVOYmwxcWtHOTVFQ2pLcGR6Nnc4T3pKY3BEM3NkMFRNYzNreWtV?=
 =?utf-8?B?YlI3T09SYm5PV2Vic0JzdkZwTW1PN0creEJ6NVNkUTJjTEdZTVpLR1hycGdu?=
 =?utf-8?B?YWw2aFZKMEFxS0NGNTIzNytML05MZGgyUStkOVJxRE9FV3p3WkRuY2FKSWNW?=
 =?utf-8?B?Tm5wUUJ5QWxSUkh1M2gweFArZmRtdUFwNnA2UVhZOHNTZ2NEcFZJenlxUE9R?=
 =?utf-8?B?b0U1TGdlcGJhcWtRa1dtT2l6QU0zdXMzYzdxMWhkMWxKUWFiTkdQQkRJT2tV?=
 =?utf-8?B?WEtxUjBzOXJsRENOSlJhNi96eldIMzhlVmF1dktLaEVDTDllbFNVb1JTVUNI?=
 =?utf-8?B?cWlqR0tXUmx6ZFlZRHJWWHdJZWRoZHVnWktPTWFFbTkwQUU0U1hGdmI3VGcz?=
 =?utf-8?B?dHZnd29IbnhQUnNROVBpZzlURVI0QitlS3RtL052ejdPeENGMlFxcWpuc1I1?=
 =?utf-8?B?eUk4TDNUaEUzWVYwcXRMK3I4NFc3V1UrVHFhK1crR3pyTEtkR1FTMDlVQ3o1?=
 =?utf-8?B?YUQvNGFwUTRrT3RRQ0liRnVIOVd2d3hmSzVQS0dFMlljeER1RzdYTzhqQk8r?=
 =?utf-8?B?d0lXbTdjcXNHbHFHWGR0b2k5U245YXFUMU54YVFVdURsMVJCayt5VWlDeWtT?=
 =?utf-8?B?eTdKNm9wVSt2SVlpZXhtVXB5dW9hbG5IejBBU1ZxRGJ6cjQ0TXl1bjgrUGlw?=
 =?utf-8?B?c293SWJFVmdZNy95azdybWlCNTJJR00rNkdIVFAxMm5lVG5tRnhpNFhXM2FH?=
 =?utf-8?B?L2dXRnIwTkhRWWVKNm9UU1FJZGl2WFU0b05YcXlETXdYcms3cHVYenkxa3l5?=
 =?utf-8?B?TzNXRUF3UlI1RXpVVEhtMk1HSVNjYXc1U3dmbktJRkNZeVA3UVN3NnVGV2Rz?=
 =?utf-8?B?ekF2a0lnN2hDRmlSM0JYYzFGdG5QaWM4RmVIWnpBTllUT1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGxYQ0dJZWcwalU4V0tPSDczRDNFWkR1WitqL2tFRVMwbWNOeWtPY2tOdmhJ?=
 =?utf-8?B?UTNYekJ5VEROejdoUHJWVUVuVzhkMnYvYVl2a0NGcjVZVlhoUis1eVoxYkNi?=
 =?utf-8?B?NEdETVBUSHJsWmNQTER0dXlpRUx1YThrYnQwYTUyK3J1Tzk3ZDJJTnl3Qjlp?=
 =?utf-8?B?TzBDR01ic3JUam1TQm14SHVvTHpIUFFTMVJjaTY5VWY5NzE4VmxxV3J4Zkt3?=
 =?utf-8?B?RmJqZDFiOGE0YlhGTDltV1ZSZS9UUHlCWTBxVFk4dUZVK25zSEpPNk4zWVda?=
 =?utf-8?B?bzFoWlJONFRUeWd5SDAxOEhMUlZoL0JXUEdGelc1eXpLZkJQMXp2K2hJQlN1?=
 =?utf-8?B?bXM1QjZhVHNBWCtjamljc0NuU0ZYOEJZY1hLc3pTekMxbEJMMi9HcnVkNndC?=
 =?utf-8?B?Vk9TYzA4WkE2akJacnpBU3grb3RkK253eklDUzNBV1ZmZjVjZUNpVFlDY3Rw?=
 =?utf-8?B?MEJKb2o5UkcxQzEwekVtK0N6dHRIc09kcW5kNXFXZDRiWmVodXVtU2hDT3Nk?=
 =?utf-8?B?a0JOSFJNa1BCdTlBd2FleGlEZGlNbUdnUkpqbGhsS25rb2duSGNXdU52amJh?=
 =?utf-8?B?TTg0UzdvMjJrcXlSaU1RLzk4Z0pDeVI5dTA1eVF4M0sybXk2MUg2MkNFdXpG?=
 =?utf-8?B?NExRSXRydjFkUTRMTlEvT0Jvdk1ZR3ZaaENyKythMmVwQVJ3WEtNdWVPL1g2?=
 =?utf-8?B?N28zM2JVUHI2RTkya2VTTzBLV29UVll6bndlZUM2VnNOOE5ZTTk1TmpMZzVy?=
 =?utf-8?B?cEJrcFFyaU5hQVRhbGpoS21CaEQ2SG1tOTlWNjJ0UC9YazBJcHprY296OGFK?=
 =?utf-8?B?S1pPWXEyUnpEQjNwdUpuUnUyQUROT3dZTEthMXZ1Y0Y0YkF1ZDNKVmZlK1Nh?=
 =?utf-8?B?M1pvY1huU2hZOE40VHNsUXhXbDZTWUFlZ0QrS0xOc2paWCthZHR2QUdsUTZq?=
 =?utf-8?B?Z2dtM21EOU93OGlKT0lLaGs3eXJ0RUIvR2xTVDV6ZFBMZ1k2N2krcUF5VDZw?=
 =?utf-8?B?TlVFOU9MemlBaGdmc2g2VSszRzUzRmVaYTFlcnhiM3hZWStRUWxITzhYenFB?=
 =?utf-8?B?TXpYTWdVc2VReW5rMVJnQlBqYkRtL0RYSEJPaWU0UGRwRjFkUEp2UXNsWTdk?=
 =?utf-8?B?UUttQS9oNUV0bzZmUDF1YVVmMFc0bFIvWmZTOUtxVmVaL0dhbUVxNG9CMjhw?=
 =?utf-8?B?ZUtMcTJrRjdxZ0ZtRnVmVUlMYUZvZFhERytGWjMxanBOckhQd3U4YU1leGhL?=
 =?utf-8?B?RmR6cW51R3RVMEFUUVl3RU5Ubk11RGxRdWpZaDZBUFJRamRWQzF0T1hSQWxY?=
 =?utf-8?B?cEF5SnZObGYwblh1THczejlrV0QranZiemZXYW5QL2tKZGdNNVlubmhiODZ6?=
 =?utf-8?B?YjlBTUU2SWRqMzVXN0hvY09NUG53VUVVU0p5cVJLdFhxUVJhSS9zRlZidVEy?=
 =?utf-8?B?NU1FZkVlbkpaRVY5aVora2JzV0dydG1tUDg3cUpaSzA3ckpXczUxbG5tbHJZ?=
 =?utf-8?B?a2pGcjZjNmhwS3hoZkNtQXJDdS9WazNiZ3BkOWtEUzhibDU2ZFpyL2dZV0ZL?=
 =?utf-8?B?RG9JcForREtDVXNlTjAwbDErY0lpNnYwZ0p1MG1FTnJ1UEJpQzRoa3Z6Ymow?=
 =?utf-8?B?VjZGQ3FxMzV0Z2xWNmw3OTkzenplSjBYUkt6UkVzcXZFV091NFBSckpWRlNh?=
 =?utf-8?B?Z0R0YXFnQklLN0c4Z1hxVlRwTndpU1dsZ0szVUxXMmg3ODNtTFlDUXRvRmFR?=
 =?utf-8?B?eG5tOTdpVCtFWTVKQ1N6SC9XYmN2N1orS2JxUFdJTkNOTDJHR3NBRmEzcWhP?=
 =?utf-8?B?bUlGS0hUbWl0OUl3TVJSVStQWHVKNVM1aDhJUU9kellUTjZBSVQzZE5wZCtT?=
 =?utf-8?B?Sk9OcE9RT0llYlZDK0VDeDFpUThZY01HaVRCMUZHK0tRRWptRndFeG5FcTl0?=
 =?utf-8?B?TWNiTmxJWDZEUVJQWmVlZVlPWkpGVnBoeUZVSXRia3EvOUFmY3FlZDVBTHVT?=
 =?utf-8?B?bWdKMmRNTWZlbWk5L2ZpUkVwZGdsM1hvZ1NuWW4zNi9CT2xYbmRsaFlySWxC?=
 =?utf-8?B?MTNlL3R4TXVPc3RSWUovbU80U1kyTFFEWFpqK3BWeWJaa3ArbXhxN3FMN1Bn?=
 =?utf-8?Q?NMnb7xPc6Ca8fGxGzULNTVDr4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db9bac72-795c-4f53-8d2e-08dddb418b53
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 14:47:51.4461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/EKIHGd0FUhmYFVnPE25HF5gzrBJvkqpcsaN1a8CTH2UbtqiZMM9zeRf9f3Cg4z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9543
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 552A712000C
X-Stat-Signature: hr8x36a9m38wfifjp7czq8o8gh4kdiqi
X-Rspam-User: 
X-HE-Tag: 1755182874-584064
X-HE-Meta: U2FsdGVkX1+HLjHQZ/dtxhVWEz1vaSvIDDpTX5evnRcApV4i3U4MxqrSZKEW2WG80+4wkpIjVB93bQbM0PprnqaLVcaQLdPAbHPj/frTxlchbcSLWaTxmhP3XnKBAiqxJeAjcrV8Vtts74ZdAosxbgK2jhtgYDo22snWFYFlxkF/nckNnzKvOy2VWTH6AUAPvH6S7CPjko8s9YEogjD1pbhe8AOwu27USNGwdGMkB3bL9GNb9+7FgTROBbgwT9hO1EFDXgNqg/9d4D9+KikNLK1eHFnkD/MQfXp5sgVzjJccCSDOfjDEfne4JUjh3VOELuePWKcGjS5Fov9eM6KQ9J6PaL0XI7ONgQaocWC5jvOhj6GLSO0tyBi95hGBXFsz2lntRsAIVfDgm98WajzjGUa0fncilSmuKEMhdECSt0CoQtlnWCMJwUD7itlyyJ1r17z8E/YX0aRd7BmfH3AVGJH9icEi8kS/hh5DkI2Fk4ysQXSMJFpWvRGFlp/a7hueHvOeCw9HElS2N4dFAljnHUtDESbc8GjWQAe0iS7OLGFRiqpCdy28g+yOQnJaa33/n45bz6pxcwBxUInLMqcAyhcckdKK9nyVXolPAyyc+46a7umKvogl9DTc/S8guI3MVgWlxMg8HlMixVqWhF8RK7zySIX00FUp/iTVOpMdegoTgXfmHuzaCusQesZB12/NIfcc0r1JUtWHaBO127nh9r+U5emxtj2hnXE53z4PBgu/9uvmKmfNx0Or5FIdLrOrurGLMiBF2DZaqmHNNbJLprf+KvAwjCHIZnTD19FomTPja3VDgOPNQH6myrf0ROL72ydx4N07BetxtG/GAsUKWxwF/npIyNzRzYD1MMj3DNHNsnUarPKYX1qD0xfEhvqgOO6EGh6T9pw8ppXTOyrHUGLU2Yegal9Fb1fHey3Rw49qoqYDFws6UOBDdG+Ljo7quSdizijjxYBCLj50pPL
 ILXbAXtY
 +8PMFH2u32AbpskAxsamU+P2EJ8dZb9dv86bPc8wYU4Wds2GfDaNStRPW35e2T/HSWsUSkA0sKKTfBW6828PpJNXUanZQempFysh5OQfvNLtjaGaY47xP7OvQKCMjckqopoo4VI8Svfu0ZwDE8e3WtQ4fld7qjSe997/AHpd2fzCXXb6MouMlUXEgcDXXngmz+rxg1L1sT89dTtyG/RQYO+9DCdX7vw5cDB5G8ffHBw2djzj7y8w0jKq2X4N5H4IqnNm4HYCs7iDkFCNCzrEj+YVqoe27RnQwwOztp2WELOlN/FerEzB0uZ974yYLXCfXRbMszavMQVSrKKAu5CSy0OdD8ARFA34iQS35xTwCbB4KAIh/7pGOXCxtwmBu+GjUGX6vcd4zkibNEml/qPNzxUBpPFMAtiUy/WYVpdsiO4x4+JZoBFYAWBz/ABjCCEqnC6+Z/Qs3+IxYpoD/X959W0BKHCnmPdObIQscWil/IAWIVW1xtJajv+hJgRVPE3A8PR/5wmWLNk+aMrI8/U9syr1fqTRYbMnpvE+RIkob2ZlhEUvWlk6i5Eaigw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Aug 2025, at 5:00, Ye Liu wrote:

> From: Ye Liu <liuye@kylinos.cn>
>
> Use max() macro to simplify the calculation of maximum lowmem_reserve
> value in calculate_totalreserve_pages(), instead of open-coding the
> comparison. The functionality remains identical.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/page_alloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 64872214bc7d..8a55a4951d19 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6236,8 +6236,7 @@ static void calculate_totalreserve_pages(void)
>
>  			/* Find valid and maximum lowmem_reserve in the zone */
>  			for (j = i; j < MAX_NR_ZONES; j++) {
> -				if (zone->lowmem_reserve[j] > max)
> -					max = zone->lowmem_reserve[j];
> +				max = max(max, zone->lowmem_reserve[j]);
>  			}

There is a “if (max > managed_pages)” below. Maybe convert that as well?

Feel free to add Acked-by: Zi Yan <ziy@nvidia.com>.

Best Regards,
Yan, Zi

