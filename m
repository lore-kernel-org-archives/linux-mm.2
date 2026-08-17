Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A42C5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D6A96B0928; Mon, 17 Aug 2026 03:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187EF6B0929; Mon, 17 Aug 2026 03:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076276B092A; Mon, 17 Aug 2026 03:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C873B6B0928
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:36:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56398A2F94
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:36:08 +0000 (UTC)
X-FDA: 85109952816.17.BA6E909
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013056.outbound.protection.outlook.com [40.93.201.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 65B9C80009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:36:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="thXoL/VV";
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.56 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786952165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBSTZu0tzcZCs4JdaxABFX/E7P8cf7Z9Tg0XpgIhTCM=;
	b=wPeFF6n5HYWOQj3rKKxKGQGjs+SSEz0j8qcd10SDpYdlTCN5DsXrfeeHQqVO/iUHMZgYub
	y3iRj3l7QPakcwa+ndK2JGeqXxTb15c+2/iFxwNF2OWr9ioGbPdL4jW+cKDhZMsx7Ro/CI
	4GaAxH6uq7NwVIV8bHq67Fv+aZ2OwII=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786952165;
	b=bbZxFOEf3mWJ1S0DnqEairQMuh49FMmOqM/o2QLYQNtNPiS+WeztihW23PHGkyojvSy41S
	QTwsadXSwWZiNtQk8vjm7K8h3MgBc5zhe2IcuVP/xpXDM1I5OMEbONtvhsdSdIfBJ2gxA3
	lQR74fBYVUx6l9nFQPprPV/aljKKfAI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="thXoL/VV";
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.56 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y8l3j895EJmqwGRyR78+3pSrUg77w9QyDE6OQ3G1ZuhKopkcYRlu16+4iXK6EotnqjvnPKgacedGT2TpyREuijAPzlWwMgN6tK2YJtcmr8IxbklNNdf6jwcREzSE/kwQWK5/QaOtgpxINOY0wb2eQ3KMA1BYCCsjUGu3tDpZ8anYKZw2ira4rVfPirIxGBiw5n6AmRXN3WIB250ylNk1S7TMl3P7GtlJGrmMGamLXMN6cK2Ik6mSJDcsEpydHxeb53ln1v4bP6I9yxkQIamirVNm821vZTsclnKFN8NWlzoIpCsOBBUR3eJsUYdK/WyijCMf7LpwyP5p+Wuz3zKSWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QBSTZu0tzcZCs4JdaxABFX/E7P8cf7Z9Tg0XpgIhTCM=;
 b=ZUG3jo/ilD8D2LtWIuJdnjU969s7zRYTFjRE1jkfQ30Enfa6vIpDfwFOwavtdWAJ0uksSJgVbyuakfGnmnqWw85hmUR0kgjvZWKBoroFF2flY4EkhawNUgcS64LR5/SFV1y8KrpaHJZfy3SPvSZig+8DY5IOHRW5ynurJll3a/JjnQ22eiQYiqwCg4NtZRmH+5+hiMfbEf2MoDwEeeznG5p66mj5q7zYbDuIgIirQWGSh2mGGC+foBAMQk1XFWk8LafGz9mj34whHJJb/5y3nkYNJ5KE2ztIi8OxlLinIUWkxJ4R564SiLifR1qUze0J391Er7Gn0HiqMZZ4fdIyrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBSTZu0tzcZCs4JdaxABFX/E7P8cf7Z9Tg0XpgIhTCM=;
 b=thXoL/VVXwe1Zf+0+ZJlsZ854EaIyH/O8u52h1EBHThMfSW8L0yzNHs4+ax4qbEz9oFKl4Z22utpV7mVmi3YVYGXpM3lsLszImBgTm2JikM96ofN7bC/1zYFFOu3pmEjPcv/lV+jtqMk6nxcz1vsBLMH6dS9jJNN0npcL8QiJSAb2znZ5K2T62Y0Pj3JM1jM+B20I3r6z9sRvgkzVBvSgYOTbwyscTHSsireKmelDVJ49d1BotKYDNhYBuIb0P6nkYwNxHGTjhbBsyj2zSEDaNdPOgQo29fGF44lot6/kGkGRDVz+l69OgaO9XQQC9E8Ljs5VZxibNbKWXi4Go9tMQ==
Received: from CH1PR12MB9670.namprd12.prod.outlook.com (2603:10b6:610:2af::6)
 by CH1PPF5EBD457EF.namprd12.prod.outlook.com (2603:10b6:61f:fc00::610) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 07:36:00 +0000
Received: from CH1PR12MB9670.namprd12.prod.outlook.com
 ([fe80::416:ea1f:d17b:2811]) by CH1PR12MB9670.namprd12.prod.outlook.com
 ([fe80::416:ea1f:d17b:2811%6]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 07:36:00 +0000
Message-ID: <b93756df-143d-4463-9f88-5a9a8a92dbdb@nvidia.com>
Date: Mon, 17 Aug 2026 17:35:53 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix cache flush when replacing huge
 zero PMD
To: Hui Su <sh_def@163.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260817060845.377800-2-sh_def@163.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260817060845.377800-2-sh_def@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME0P282CA0018.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:20d::16) To CH1PR12MB9670.namprd12.prod.outlook.com
 (2603:10b6:610:2af::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9670:EE_|CH1PPF5EBD457EF:EE_
X-MS-Office365-Filtering-Correlation-Id: 242400bf-e09a-4915-fbbc-08defc322f51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|18002099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	0kTqL7LNJ+/3KXwOlp9pl0qfVP5b/T+IyciOYmyMYFgV3emFxQ0ASbSOzg9XxMvTnDHf1vFewG/rezKpatPcYRFsxHwftIqh9yYTdDw0inaw2w7d/6PQx6wlMKRALYtnUKUVyPTAuJP9AaUsKP8nql1r7cW2T4wF5+1ufqgewMYM1pkOdDwa7HUNnMkz8vJLn+luh5FtgF5XjetvwtWeBhlkSWDCBPNWIXV/N9LOnwq5zwBVhxRgUh3f7RJq13w7gVtBMo9iMpVHdOFAcujUYDfON3OVi7LjD/J1XLy4vKbIhaIZ5f7SOwz/iyYmV7OOO0uL/iOX5iFDSJa2KbiiJZyGeQpRQEN7eo5EpVD7ek2I9L3c9pW58yDFuYjuC0zjPhwhL0LuQSiawj2YRhsHMNyS43GzHDjhKmjeTBIjWGQ5ibwKkX0/7haaSox+88zKVTXoBJ8+8KKsUIty9kjn4OPd0UexkB/I5vkV35Y5LDwqtFpb7QHG4VOynaPr4cTQTnDqLreT4UnZUoXLcQk7FpDvwzp5kcTR7C4Clx8QFenDe2hswHxYq5YdrmlvnvuP13KRyYNW7MLKy8geh+ep6KCWNcAVZPESlX3BBFCdNthm4sbDFG9pyBnIaK6aTTcNe371ijXeHIbXJT9Cj5pNsEoAOxpnTSCOJ5dFcv9shQg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9670.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wjc4K1NqdmNiQkg5aU9Qb1hCcGVZMHJ6V2ZTc0FBRit3LzZOVFZZVGt2bkRV?=
 =?utf-8?B?L2pGZnBTL3ZzbE5aUDUzMzFvTHZUd0c3ZlNPSzY2YVZWa1NURnpoYlVsZmNm?=
 =?utf-8?B?KzNaQjU1c0tYL2JTUjM2dWRNQlZQbTlhZUgvVlFCbUlMTGlrMGZ0NzY5S0Jz?=
 =?utf-8?B?bWszSUhoalA3WUo4TElxMWdwcFlDNFJzdUhiWFUvTW5WNGpvVmJjdUZlazhB?=
 =?utf-8?B?U1FYUkNSQllFQ3dqeDRGTzZZalNTZlA4bDJWTXZlVmltUzgwd3dDRXpudzRV?=
 =?utf-8?B?Qko5aE56NHd5MDFEMFFTRFRDdm5rcG9ZdmxUYkFDWDhQN0tZSnRzVHBBQWZF?=
 =?utf-8?B?TjRRcHF3c1BXSTAweXlla0wyd0lEMFJxNUJQRmtsZ2JBNVVkdzRuQjVQUE1m?=
 =?utf-8?B?UmtoUDZ0WXgyUTIxa3VId0J2bWxoZGtQRU5NbWJUTnMwdndMeVBSRzgwK3FB?=
 =?utf-8?B?L2ZLN1dFenJ2TUJaeHdLK1dIZGttZWE5RkhSd0pnSDNWZVNzc1dBUldLbE5l?=
 =?utf-8?B?cEEvSUhSVDV0TDVvaklBNWVEWENVTWViRDNFK1V0NlNEZFB5ZFVFcVJOc20x?=
 =?utf-8?B?ZjhnT3VSdkwrNmFTN2FDaDk5ZUIyUDZNOWI0Znp2bXM5N0ZFbUxPbU5CVWxn?=
 =?utf-8?B?LzhXZHBPOUJrbEVna0NmRzlYWks3V2d0c0I5UFhIbERveVZlaEFUWS9wTnpG?=
 =?utf-8?B?ckZpcVpKaElGb2I3clhIN2ZnZjVkaW0zYTNSM1o1U3ArVFFLN2tyRXh3dlll?=
 =?utf-8?B?dlVjQ2lRV25Wc2tBeW1lYVFTazBJRHg2RGhoNlhGZm04NHZFN1lBbzRpOWVE?=
 =?utf-8?B?UDZhb0NlV1hRdFc1WXhFb3ZpZlRHN05FUkc3K2pHbmNPbXJBOFFQY2FBMkMx?=
 =?utf-8?B?NWg4aW1iak9oVHRqaTNoWXhXVjQ2RWt5bGppVE9qRjR1RzNSTktlRkljMG8v?=
 =?utf-8?B?amxIdnByaEhKWEkyWXh3TE1oZENoOTRlRTZWaWpqMlBka1JlUUZ6Q0d1eDNz?=
 =?utf-8?B?UE9VOHNQdllQT3M5eHpublRIcjBHVjdVYys3WEx5T0hVdGFSQVdpdjRMRDk3?=
 =?utf-8?B?MDI0bTNrOEhuTTRwU0lsNjkrYTZUc3VDNVdWSHA0NHFqWXFPa0JqcUJLY3Vu?=
 =?utf-8?B?NzRPVk9xMjdydS9zZzNkNUhuQis2ZXBhSDE3TG5qRVpTam1yeTVCVm94Ui9k?=
 =?utf-8?B?eUpocjN3SHlJOEhtMld0MlRGWnRZYVJFMG55WWtEb3ZHVE83WGxpMTVGVWtC?=
 =?utf-8?B?R01JNVZYUStMa2l2UUIxZytXTWdzYk5yckxHWS8vbFgwZXFnMHBtNVpDMnVu?=
 =?utf-8?B?YmJGdUdqQ2Z1emJlUm92dUxzcTF0b2hESHA0UVdPbU5kVXhsbTRUZTBrdnRW?=
 =?utf-8?B?SFIraW9yOUk3YmRIZDUrbSs4QW5rV1kzSjNyMU1tTE1oUFpOSm9Sa1hkd0E4?=
 =?utf-8?B?cUFwYWNZTEpNdXVHZnF2VGlhUWptNU5uNUYvVmlBRHhnS0NrNE1xcGErWFBa?=
 =?utf-8?B?MkhyK0d4V1NYbW5leE9ZR0ZDSXo1T2VTRWVvaHZDZUVJdTh1c09RVk80REZ3?=
 =?utf-8?B?aHVYMjJQcE1IUkJMVk16bE5uUmI5VFIwTXRzZ3FPVitSNnVWZ0JFd0VOWk82?=
 =?utf-8?B?cFRramw3RHZVa2dQZUZMQ3l2KzNMOGw3SExBUDhaeXVDYkNIc09oaXUzSjlE?=
 =?utf-8?B?T3BSdEk5SGlUUG5QbHhoaStDdFNPSVhxdlVQME1Ea0ozSDJTeFNRNjFESU5h?=
 =?utf-8?B?TnQxRCtPdHN6ZXB1akFrTGhLZ1FmZE9xMVVMd0owKzcraFNCcnl3eU1hNC9W?=
 =?utf-8?B?V0hjaXVSUXFEeXhDZnBndUNVd2E0NHp1Q3VaTFdwTUsxQ3dWelJIN1N2amdz?=
 =?utf-8?B?Yk9ONVJYYzBQRjMyQVJicVZOWi9sWk5rbzkrWXNXZDlGUStOb0p2Z00xYkls?=
 =?utf-8?B?N25wOUhyT2lDRnIyMmNEWXYzWHpzTzZ5M01xS2F2eE9MeTJhTUZzUDBPYnQ0?=
 =?utf-8?B?dUtqcUNydjRLc0krU1BoZzlQaHVnQURJUm9HUnpUVVg5eUEyMCtQOFpBWVIr?=
 =?utf-8?B?TnV6Uk90dUV1UWw0aEFBNk5VQnVFa3VUOHBhM2ZqZUhwYklWWks4V3RxM2Iw?=
 =?utf-8?B?RGZCcFR0OHVpTGNYMTJBdlRnbkxDMmN0RjJuVnRsVTROVWd0VmFMajRlMHNC?=
 =?utf-8?B?VllYUm5FS1FvZXlvYnlQamU4Y2JDRjkwT05uUWJxcGNJbWlpRHMvazNDREJl?=
 =?utf-8?B?bXNleTN2SDlvK2ltUjRINmFLNFBWWHNHdjdHck1IMCswYWxnWVYzamppaFpF?=
 =?utf-8?B?WFJlaVlHdHVLYXNTVmZxM0lnU2ttQ0M5ajhYK3d3Zk1XWXkzVHMwQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 242400bf-e09a-4915-fbbc-08defc322f51
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9670.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 07:36:00.7245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 73FK07OOh312MvQbUbx+0Yk30coRIK8urUu/XBCmR/Q2f26tUixhxgw2Hsx6YhBhC4pxGbny8xeXeKhzwoCJow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF5EBD457EF
X-Rspam-User: 
X-Stat-Signature: pc7mn1ogps3disgiqq9aehwhnj3dzeuu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 65B9C80009
X-HE-Tag: 1786952165-509265
X-HE-Meta: U2FsdGVkX198FOgtYj/Y6Ggi9j2cBaZmRs04lnak75c8iz1JKKyvDwMLP2C10dnfjUspa06oLp63P6AnRM6xTDVYqxNUG7xK3pg2OlWP0XAycyC1Guxkg6y9mjGRrNuYwTEFW1tX651RGstQbjApo0O1mbbxJM7aPwOB3/iJ7r7PooCOJxfcvSmshUOS3Pq5AzhWqlRQkaBsQC/cggJ+vOnFoHhXAVBv7waOhBJZ6Idpsmk0au/DxRUjAj/ybrvnMCHsK1Z+C4UemO4mIEYIrDe+TMBGgvrsBVJo1Qvl8i4K81DFFMj0eYLi+NHfxT8vC1xZlspbqBygqeKvkN85ecXsyZYR/1IYOD221z1WvsYG52ScqFduXYqmSZILarURKUPPD3+zIaKbsMs32ICsWBILreszmhyo7K10A/ZrLNjwaWJsB1W5pV2dVGluOQSJ2BxyYIueGnSisLqC5e9qcP5dSEoCnaZXN54H/+6T4DL5fQEmrlu53qgIEirBP2OF46dVKRKxUbN6GKqWPEhhgKUmCnMN3lCYUSZjGJhPYmmnADdLoZ4me6QE/EEnt4cXYfa5ct1tnBAMLd3h2i8BPJue48iMr5X1g2SVD5QcK6FGOVvUuuAz1Ne35L8feyCIYl/0O5v5937WJrlmcbgiu38G4yO98L9GVrYR1duTmaqV5fg4Ge/Y0llpiHwuvJOpOaJEmBH4SauBnmXdxeaYwKrCjv/uM/EKX3KWzNvlISv8wzZrtpYI6KYwC0fQUSl5RsUVsebbcRxny9B9Ks5ZzJjQeoJs67LMQ34+gUczGNsqkVH7mXxnm07fJY14cPRzlThTKrEtx+K3FB3JCEDjIorf+WXRcVlnuwI94oy4VzMLLDdAg21drbJw5eOYmzL9zc09ksTwr1lX3MYIwFta8x5mWfcq0o5e5/hoaA5lngvGAZAnUsbvkD8Ts01SIstCjHXHoghrKZGCUlTukSn
 TvVw4Xyq
 XYMJHmJZ6F778RUYL1/e23NCmvTZdibw1Tg5cahlAZmQGa4fvETsTYsa66NL9OuywqK3OYx4hhi792cVoxY0gqlRgcbXoy/TQl4IPS8t2uiWx0KwKrb4WA21i5Io1M3dKZng0i0m1eISEClXI2qpZVARPuVX9F11nF9FB7estyTZlbCskCL4eq2DgkltKWw+ZPFghqb6w5r9Xh3iYLFBe8CUbfoGU1vk42c/dVMTIsTLOXZT46vg5cDFkfCIKyx1fHmEPMLmDul3AAwQ/SxyTjzKcyQHSaG5ajOa5WsWgUjQURdWjCtpWh3dsz9/oLj6BR4vN2Pw0WP2rghcOrldTBtv1waElYPW5HgDLAZ+EjkB7uWd5jJVldJlX+FLmo2B988IesV1JtZXqsDy5Ev8of1fBKiQOyxOcIhqU0vhpLffyc3dS6H5rdNni58HYxSrIwcQCe40l/1DlpCwBf4uR9GQb4t0WZTJ5eeBPWRztwANFKyLKRtZBLluntNfaArZiJnLcG+Ze8CwUZZG4gCbM/1mik588SuI0VAjvHNCa03yp05NmKum1VLy4sKzih+NPOSFNlTkc26OM4EI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 4:08 PM, Hui Su wrote:
> migrate_vma_insert_huge_pmd_page() calls flush_cache_page() before
> replacing an existing huge zero PMD. However, the third argument to
> flush_cache_page() is a PFN, while addr + HPAGE_PMD_SIZE is an end
> virtual address.
> 
> More importantly, the mapping being invalidated is PMD-sized rather
> than PAGE_SIZE-sized. Flush the whole PMD range with
> flush_cache_range(), matching other huge PMD invalidation paths.
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Signed-off-by: Hui Su <sh_def@163.com>
> ---
>  mm/migrate_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 908d2d4ec43a..098c04c1b124 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -872,7 +872,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  
>  	if (flush) {
>  		pte_free(vma->vm_mm, pgtable);
> -		flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
> +		flush_cache_range(vma, addr, addr + HPAGE_PMD_SIZE);
>  		pmdp_invalidate(vma, addr, pmdp);
>  	} else {
>  		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

