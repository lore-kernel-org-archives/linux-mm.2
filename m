Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4411FEFB7F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B0F6B009B; Fri, 27 Feb 2026 14:29:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8B16B009D; Fri, 27 Feb 2026 14:29:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD296B009E; Fri, 27 Feb 2026 14:29:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A26866B009B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:29:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3415E140444
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:29:37 +0000 (UTC)
X-FDA: 84491225994.14.0F79549
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012019.outbound.protection.outlook.com [52.101.53.19])
	by imf28.hostedemail.com (Postfix) with ESMTP id 67B65C0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:29:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MbqkTNqh;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqOvhgHxxA6tbsCi6vwEklCq2IoKlU6xaXjDCV35SJE=;
	b=w7GPHTXH1sBAT9zq4tk5V1J2KiQ+Jj7OCWxkUBsx4mvzZqL3K9SiUQVRqs2auWKpFn9qGf
	XHIvPRIHc2jr9i3NCIp3fn3MUmvaAFK6XEuo4M30OKqCCJ+CrHe6sfXPwWlxd8EjoWnQ78
	gF9POdhopryq3MUGdanmfaclEjKrhas=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MbqkTNqh;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772220574; a=rsa-sha256;
	cv=pass;
	b=PnP8/BiEfIoMb4ghQVqWapDoCJt6qkIBj4H6ZyXiZ9UPC7KgOw09LPOap/EV6yy3s1omBe
	1P6YyInG0H+IPWOrA2nApOoStAmwyjS3l7u9MXkmrM1QEjZhY3q2d1mytQfL5ceOPjiRf6
	VgadpiaDBfB+k7bNE9aT2jwMImEYs4g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rCXKKxlkPslN6v53+Q8qVdXxzSlHjlUCTUXRzgP+vobF5ab9Y1/1CQggqiU/u7aU97p7Hb6NMEW3GCIQOqrZVgcpdts1I4U5zyG8Jbtm6wdCdQB9SyS07GpjtoJr6sMVYykZ4OTDiuybGWiMSVF88okuZRyNk39rMXhobqMLVCAsyJSudXHu8L1yBIl49shEsbNpqep5AyvE2GfhYaZbuGCdUFId4kkLIQ6Fd7a/3HPhx7MagvTR1xgxIca0KsPJIqV6FpfGMH9mwbHQzDXj+r0n5gH5+7LpxjdYbeUr1EHWw1wFInoGAPK7KEsumay6HTIijUyrQoQK4ZV7UKqxGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bqOvhgHxxA6tbsCi6vwEklCq2IoKlU6xaXjDCV35SJE=;
 b=e+sLZyGDQw0er/wM5JnwYflJryXqElvkQn7SzArd5Vi9/m6dds3tuAEFRnZhh5hFiOH1BsWm0kMYi6BLIzOTLPJCo2S1KNYbk2/lgwQLG2g1cQASJq8QdglkA72BCvd0vrOpz54JNqmuZhjzZ/Gu495wtlbWv68BIO/YmWPmnht42Qh4QSCRORlioqPRAkd94JoSmoaLPKA32xYa7V/d6Q6RqpNzF2fwV6nci3wupT0zqAQuQJNKrfMmklRZZPoxYEi7Izgh1tTJSxkeac20tGAypDy6xQpLs4510V3JC9EMwzpsB1dbxRKHYaYp18ymvnGz2zqln3V83s1Luc6nnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqOvhgHxxA6tbsCi6vwEklCq2IoKlU6xaXjDCV35SJE=;
 b=MbqkTNqhRxvshVNb4snpBhsO2NCuXvIdepgrmhZcen37fQ0wfoQ0A/zC1I0Cre8rrxHYI+aiXGHrTl7Nb9nkufwL8ZOmxxG5gy1lJYLZdishdfzY91qTw/oHbidT62+uBgLzIVd8ucmflFIfllDXQ+6d8pbaYH2Ez8sgPLSS2GQST3DQFIeXzy4T/TKXO5m1TMLOCPTCzkk3k8Omt3KawqdEwD6rRKdu+ADkofeR6ZpDhZUkleCpt270m6w1pCHUv3WP7VYyqJHqcQZ/iRv9VL0EaBgCSsYx8Lker+NwC3A7gM/+a8y8TzyTUDpzmbBcSTMVKRZco9zlQ61UkdqGPA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6080.namprd12.prod.outlook.com (2603:10b6:208:3c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.15; Fri, 27 Feb
 2026 19:29:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 19:29:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: Bas van Dijk <bas@dfinity.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, regressions@lists.linux.dev,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
Subject: Re: [External Sender] [REGRESSION] madvise(MADV_REMOVE) corrupts
 pages in THP-backed MAP_SHARED memfd (bisected to 7460b470a131)
Date: Fri, 27 Feb 2026 14:29:25 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <2EECA9B4-E1F0-42FF-9E61-3E4AC4B4DC13@nvidia.com>
In-Reply-To: <CAKNNEtwZzt3xWh_b1pn4X4FG+cq6FLOP5rR4+G=WUsjHsJRjaA@mail.gmail.com>
References: <CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com>
 <CB5EF1C4-6285-4EEC-ABD0-A8870E7241E8@nvidia.com>
 <D4BD80F5-6CA2-42E1-B826-92EACD77A3F3@nvidia.com>
 <CAKNNEtwZzt3xWh_b1pn4X4FG+cq6FLOP5rR4+G=WUsjHsJRjaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::40) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6080:EE_
X-MS-Office365-Filtering-Correlation-Id: ca251c79-0168-4647-5731-08de763686ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	+f3nQX2UetkGvf1MltWf1ivkMCtvkXuSF4zvLQB8tnfBqVNkr+gLeh7IgyRipgGKZ5csAIaH48G6So6M/ZGkd1U2ZpyrviEC8Xk133/NNDsS6uRLU7vOrgc277mt/TxeQGXz1Xbk9lXWw0r3NVRpvPcTiKKt0UiYEWajlOnZ4KyiKr/aJPm0/5AJf8MUgtFmYH6F2lPxQurBhLDq9cSY1hhiO9icjw2fcE8EyxdHdSHFI6WFXvcTBr/k/BUQNgiLCblStpa7aC1xCUbp/TjbtYNl10e/GHlyJyiRDllH08Yf5J2PcGAbeFO1ZwT7tLyrbEVwcWRIXhhvjX9q8Otpj2G3C0uId6FCRYaVflv/lpEuQkbQUNkQQtLsTZQBfPqLVT7VyAlbGlaAjAQsYZ5GTheJUAneTfKvhYNozI3Obj+lGs5ZdYYyi+4F/LbdOYNBKqhjD5ocuLYhAq4lQ/y3qhMQ4hxJLKYFzc133soQBRzzwy9NpvojYb1PM7vciePmpXF7tZTmAYhnnbDMpuSX9fp/TLnsoLc0nkqJeOZgD26hfF7fiUzkjByyvbmG+Vm6gdUwL6Yi/uKgD896TTkrOIXg3xXK10j6jdetAVDODSswy9wGESiuCPHlLtOLvrHTiEyBXfLGDrdKenInOsglazlL4Rji750gjGn4wQA1OtT+sTRWLd89Wv1T3Hj8s+Y/nXbiOZqRCzOayjMPDWWKs9PCWeXSFxjpkdPtiPV36WSoEOEAj6wc5Ql3cC6OFewE
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnhPUXVIZWlRT0M2MnZJUFJHZWNRWFRPbFRuK2NoZTgraTc2ejJ6Zzk2NTB6?=
 =?utf-8?B?eEtxenRoZUJMQzFXbnVZZU85b3BBbGd2MDZURURYaUNWN3ArOFFyRjdxZDdv?=
 =?utf-8?B?TGlzTTF2YlZTNVA5d0E3OFZab1d5eDFucGgzNnA2ZFlPT1J3RE02THNpWlF2?=
 =?utf-8?B?RDlHRFlMUUQzRHZzTkFBbVNTVmw0Z05NZHNLUnA1STFDeGNIYTVoZ2I4dWJk?=
 =?utf-8?B?djBTZEJTb25aSDZnTU56U3lDYzd5NmRUanUzSWQvQlpPY1p1eFRGaWpiM05m?=
 =?utf-8?B?UlRCeXJtL3Z5Q3NqYm8xdFJ3cG5sMkU3TjVidlNzc25zZm5qTmJkWjdOSjBq?=
 =?utf-8?B?VlZhM0E2YkdZZnFiVkV2cjVsQU9qNUtBbXoyVnBLdGNSbnNnZ0FTY1FxekJn?=
 =?utf-8?B?dFd3dTBJYkgwZXF4RHNtV0dLTXh4RkV2WmF5NHlSU1JUWWZQVDI1Qzh4M3VT?=
 =?utf-8?B?VG0wckdwZDRLN1ZLREZFaWtGZEcva3ZnbkxmaENmeDIvU0hBUXZCZlVJY3lV?=
 =?utf-8?B?TFhmRHZxVUJvR09nKzBvKzQ4dnladU5td1FOc3NQYXNkY0xEK3lEa0Q5aUdl?=
 =?utf-8?B?UVNHTVJFVENtVFRwOEVxa21rVm1YZmJOM3c1VXUxSWNvSTZRMWlJMko5VkdS?=
 =?utf-8?B?L3hYQWNhUU0ybHZBaVhMaXVJMURtaGUyKytIaTZHaUx5RGZaYzJZL3V6dHRB?=
 =?utf-8?B?R3Y3bTk1QUhxeUVNRm5wS3o5KzhHSnd5dWJmUlZVZmdqeG9obG10YXU0N2hl?=
 =?utf-8?B?YjBtT1d2ZlpyOUl5QmkvQWIzMFViQ1EybGZLZTA2TlFxVmFnT1AzOHpKb2FG?=
 =?utf-8?B?VzRiZkNJM2VKVEJMbjFFdnlZMGNxK2hLUlNJWDZrOGZyUzN2Rk1FeGJvSXdY?=
 =?utf-8?B?QWxwdEtLc0ZlQ1hLeWRTSEw5SkJDa0dWUkhRMUdnR1krN2hSZ3RDUWNCeVg3?=
 =?utf-8?B?VFhvSmdsVEZSWU9VSWZ6a0tnNHZmK21pR0lzWDVOY2plNVQ4VHhLYUtBY1Y1?=
 =?utf-8?B?NTVaK0M5YWZreU1Zd1c0QmxJeXA4V2YxVXgxQlR3K2RoRDRicjltN203VXc0?=
 =?utf-8?B?bUc0ck5IcHRUZmQwN2kydDlqK3RqeHh4bGVBUkpzUFVTZklOQkVDM05BY3h1?=
 =?utf-8?B?NkJIZjlxYnA0RUd0VzJnc2xjSlo2aTdseUtJTVJKb3U4NHFwNWxNRVp0R0dK?=
 =?utf-8?B?Q2VDWEJXSURtQ2tzS3pZOUhGYzhZdnV4R2hieStTQlR5TXVucm1ZWDhLZERI?=
 =?utf-8?B?MWFMTXpWdzFGTnU3QnRIK3RhRUtLU1ZSRlBFVVc0OUxLZno3dmxTTVJKZU95?=
 =?utf-8?B?MU5udXg2b3JRS0x5Vnp2MU9HNVlOZGowOFRlMFY3V2pWOElQUzF4ZmpaTGdT?=
 =?utf-8?B?WmczQTdMYWJQMm5NSjRIR1F2MlBGa0oxekV3Z2tndG1teUdmd3dVS2NmbDJL?=
 =?utf-8?B?aHpkWHQ4NnFicVQ1RHJHbFdRQnROUStxTVpzVmg1ekZhU3lGL2xnRlRMSmQy?=
 =?utf-8?B?eXFMQmdXZC9XVGVrWFpRWWE0SzBWdjN4aFV6SnNsbE9CWGlBMWR5aGozMkxw?=
 =?utf-8?B?eTdrb1hhK2dGTUR3dmZKWEwyQkY4VktpZnFJL0N0aUxZNVozRGFqYzVLaGwx?=
 =?utf-8?B?amd3QnZUV3JKUWdwa2hCRG0xdmtoSkhvRnpHMVFnbGtwUjh5ODVkSEhCcGFO?=
 =?utf-8?B?ZEcrV3RmU0xMbDlJOUdLUzh6RFBqQTV2ZllNaXo5QXpOUkxPVVhnL2lybnNq?=
 =?utf-8?B?OFFwMExmY3BRUEtYTlJ6cHVtcFZNNXJ5bFU3OHpVR1NpRmJ5TjZmc3ErY1VN?=
 =?utf-8?B?RERweGFpSDdPVGpkN3ZOS25aQ3JSNjFEa1JDNTZ1bXFOMGNSK1lCVzIvNVdr?=
 =?utf-8?B?Yi84NUtXWGpIVGlXeUxqMmZwNS9tSGY0SDZyMGVQSzdtbE92dFZZYTJMNlhx?=
 =?utf-8?B?c0k3QVp0WUJSaEt4N3JxdHY0dkF1WmVaTzVGZVhXMWFxK3pyVHBvOGdXeWlC?=
 =?utf-8?B?QUxhanpBODdWNkVUSEF3UW9acE5RRThFeHFYVXZpQ2hVOWVzalR0TU1Rbmpp?=
 =?utf-8?B?OUtWSDdMWk0weXJydXhzKzJZT2p1NzBpSlFHUlowZFltWVowcnAza0EvOCs5?=
 =?utf-8?B?RmRtUzhLbysrcGdtdEJYeGh4Z2ZGVzdNK0Z0L2RuTzlvOU9IYTlOakp0WTVJ?=
 =?utf-8?B?cnV6TlZrM3FQK3B4K3hFRkk5aTJGaGJaS05ndFNFNmQzcndVOEVzcS96VzNU?=
 =?utf-8?B?VXVtRXFEZ3JmTVdDRkh3dGlrQXJyZDg4cE9Bb0FSZjNDbm8rNVJFcEtjYi9L?=
 =?utf-8?Q?UDx/9nUN4TzYBWOOBR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca251c79-0168-4647-5731-08de763686ff
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 19:29:30.0335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QpEEggjBkxS5/XTrOSLIYG8YvFAQXeBe7YwxCG7vWO5bBC0dWFtgLUrK2ok3Ah18
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6080
X-Rspamd-Queue-Id: 67B65C0005
X-Stat-Signature: ep8dbmiy69h4kpfgtuedfqfoxeg3wq5s
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772220574-179309
X-HE-Meta: U2FsdGVkX19aP4b/ISi4my9AAoRI6vGOwd0nqZRuIGvhP2B09OpkTJdUytqL97TFI2NQAWC4gH1lSZYDmEBq/ux7fHTrZgaGLgxVnR7oWY7MmTIfxmTg4AjVDCeQnS8c8Cwv2+qGrhVfxDiGV7rneG0HGywa5yHUOsC84qwKgwIDNcWa9OlSikea+CuJDRLEgIInrytvq8fL6fdJNwX8FmQM4ub+rc6B8YzvVknJXOxnXRD4rU09MbU2g7a7I0I2Po5JgPBKTiYT1gvKKrqIDZpIzA0WRIQ9mhaP56dxXQUWAQIs9l/DcGsbBkDQAQwX3OBXXWiofw3gDrYD9eYg4FWxi9MoC3PBa0ihYT/LAk73YdKg5udhxLdSFemZjm9qGRF9hESpzCQaAIJ0cnUtc3xye6GlGb/l1Dkbyql1HPVueqjYSfmmNy48BVZXDYFW3HCPprqrc0D5pPU0KPbhqS/vw893hxfHm3Mt9oOma8NdQqFHNf3MdPPD82ngMGIAgAB/LQlGKTIyjLlmp40radwFFZm39Q5Uwu3o2R9ajPi48BrwSh6+EVG6cbRHNPuy01HSA1m4EoHXkPsL2vvu2vAO8mIlv5wm9uyVFjuwGRqcSUO+kwadRKYojvA5uoTSBfpK8o0WIU+UHnt+HOWC4W+3W2ruACAXuf2zxFQfHEZZU/YY4bWXuC0KpAX9wRMvUejE/YfDkwnU2SW4+iHy3CZM4Wty41RU/2FpZzUEU+n06ItlnhFA6O4F7T6iMOLalxufKVWr6p7AnGef2zCJDXf8WqcVURN/VmT5Nz2xorwi5fVobnb3RQ35LVhS9EHaEjI8hHWwmjvS9JXpi7FCktVCyBPsimVxmMjbwGaot/p0hahc58lUq1lEKQJvWUHl+IkDaf9EdXUf+yU/jV52nSroZqzyccRxIHju4O8yUvUqTh3jF4KxeSDv7QSEHHUuIXPf8dLgGB17jmiYvEH
 Am1NBbFK
 zQx5F97MntVxMSmu6vh6ztVe6OGf8c16BtL8v39atvSp6ZpyndycvcbN4Tjk4QCEOu4oHU472e2qcG5KTRVCiRARviKYFKczYAdwmbTS13Pmu9S774nYNidI+T+WXHPotBi6l2O1SvoIg7Y1TVKrrF/FJAtkQi1uy20T9iN9pyzvUjgTZcJ8nmtY5xnpMffNQqyyNDafupSwJC4YrKBDqKu+cNQyi9L1F5zAj9w00grk21MHRcLP4/NDf/zus5Lk+wZGK7tyFL1azZ+Xpnr8MJ+Bab/uyJmRnvP7FDcffD9qauRr+u/fuln2MJ4PyBDacHLy7L23dCtbLTb9WexI7SZGgB+gn5BajiZmoVnxWawyTno53SmhqK04Mvkk6yVniaZhKTp9s88FQOedDOL3pz2d8FYoe9ll/OBdv71MZ0XYiljgoCXxHUWln9BdJ0uwgXhqv3wEsM3rWfKZsng6FL4YvABaaTYDVFB3eLRo8Q2QXuhaR85kAgaslmM3SIZ6pW/Yz3xviqzhx0xFJbEp9OmIPIlImVaOdJ0EReq68CSUGK9cJc2Jrbmq24g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 Feb 2026, at 16:16, Bas van Dijk wrote:

> On Thu, Feb 26, 2026 at 10:06=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 26 Feb 2026, at 15:49, Zi Yan wrote:
>>
>>> On 26 Feb 2026, at 15:34, Bas van Dijk wrote:
>>>
>>>> #regzbot introduced: 7460b470a131f985a70302a322617121efdd7caa
>>>>
>>>> Hey folks,
>>>>
>>>> We discovered madvise(MADV_REMOVE) on a 4KiB range within a
>>>> huge-page-backed MAP_SHARED memfd region corrupts nearby pages.
>>>>
>>>> Using the reproducible test in
>>>> https://github.com/dfinity/thp-madv-remove-test this was bisected to t=
he
>>>> first bad commit:
>>>>
>>>> commit 7460b470a131f985a70302a322617121efdd7caa
>>>> Author: Zi Yan <ziy@nvidia.com>
>>>> Date:   Fri Mar 7 12:40:00 2025 -0500
>>>>
>>>>     mm/truncate: use folio_split() in truncate operation
>>>>
>>>> v7.0-rc1 still has the regression.
>>>>
>>>> The repo mentioned above explains how to reproduce the regression and
>>>> contains the necessary logs of failed runs on 7460b470a131 and v7.0-rc=
1, as
>>>> well as a successful run on its parent 4b94c18d1519.
>>>
>>> Thanks for the report. I will look into it.
>>
>> Can you also share your kernel config file? I just ran the reproducer an=
d
>> could not trigger the corruption.
>
> Sure, I just ran `nix build
> .#linux_6_14_first_bad_7460b470a131.configfile -o kernel.config` which
> produced:
>
> https://github.com/dfinity/thp-madv-remove-test/blob/master/kernel.config

Hi Bas,

Can you try the patch below? It fixes the issue locally. I was able to
use your app to reproduce the issue after change my shmem THP config
from never to always.

Thanks.

From 03b75f017ffe6cf556fefbd44f44655bf4a9af48 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 27 Feb 2026 14:11:36 -0500
Subject: [PATCH] mm/huge_memory: fix folio_split() race condition with
 folio_try_get()

During a pagecache folio split, the values in the related xarray should not
be changed from the original folio at xarray split time until all
after-split folios are ready and stored in the xarray. Otherwise, a
parallel folio_try_get() can see stale values in the xarray and a stale
value can be a unfrozen after-split folio. This leads to a wrong folio
returned to userspace.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d4ca8cfd7f9d..3d5bf3bb8a3e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3628,6 +3628,7 @@ static int __split_unmapped_folio(struct folio *folio=
, int new_order,
 	const bool is_anon =3D folio_test_anon(folio);
 	int old_order =3D folio_order(folio);
 	int start_order =3D split_type =3D=3D SPLIT_TYPE_UNIFORM ? new_order : ol=
d_order - 1;
+	struct folio *origin_folio =3D folio;
 	int split_order;

 	/*
@@ -3653,7 +3654,13 @@ static int __split_unmapped_folio(struct folio *foli=
o, int new_order,
 				xas_split(xas, folio, old_order);
 			else {
 				xas_set_order(xas, folio->index, split_order);
-				xas_try_split(xas, folio, old_order);
+				/*
+				 * use the original folio, so that a parallel
+				 * folio_try_get() waits on it until xarray is
+				 * updated with after-split folios and
+				 * the original one is unfreezed
+				 */
+				xas_try_split(xas, origin_folio, old_order);
 				if (xas_error(xas))
 					return xas_error(xas);
 			}
--=20
2.51.0



Best Regards,
Yan, Zi

