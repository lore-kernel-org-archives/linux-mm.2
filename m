Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D987ECD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD776B0005; Mon,  8 Jun 2026 15:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C945F6B0088; Mon,  8 Jun 2026 15:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83656B008A; Mon,  8 Jun 2026 15:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA1AF6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:33:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D68D1402C1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:33:18 +0000 (UTC)
X-FDA: 84857744076.29.58BA8BB
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011057.outbound.protection.outlook.com [52.101.52.57])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6B2D7100009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:33:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=5sWMvpL8;
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.57 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780947195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UiPm+l2DShL7lJx3UlBmx53UZ+ZgQUHbki0urBNjho=;
	b=CGHP5ngHZJmQi4mUD1x4RhtwwRFBLsqogftuXEmDrwnmXmKTIY7oTTfwH5V+/BAKBPBdAz
	iUbgJolfRuSD4JVoHVBbSiOPsDeHe8txp3eXyHjPPnBKLk/Yakmby9WmF6MXvAqYXnMAAX
	XImm/wTJ4d2QXTbo2Xd7dR4eU44KMZQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780947195;
	b=U8E6m9aCHVeekfMMiHdsCpORew9iZwh9O71NXevR0q5n0mHBYyOpN6i3kHx30xuAl5yyUU
	rF3MNtbTZLCLxxXqbyCpNGPDoWE8Beaiq3BO3rse3E9hp4m6WtA99Hwcs3zKd4PAz4DA8s
	feOeBIwHnCxV6tbPIrtnHo0sc0dOkMg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=5sWMvpL8;
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.57 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nnAnPwBK8UtfH4hE8pc5ytmZ/oS9BStwo60eZol3HW11TC97FhnFdk4fP7aE096R+ks1WlGkHzIprWEhSJKt20Y4BrFZq9mgv9bnb6VvvtxKX9mI2frwGKDr1EbH+O8ddaK/gdKCMje0/kZmw8jZXUHuW1ZFKc100wChfNAVQSV643UP+70+1HTnK2yMe9VClQfLnwX9moakaX9iUhDk/7mowdo2EAiOvhdrSSUwxVRV3o5oCJK/tOVpb44wsg2DOfrGTe86sbqJDBTabkXuopYKuizMBG9a8jY6/jsizl+Lg5uGyzvT8uxOHY4Y+f9XVMA4VfPyTgeGKYrpFjdvuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UiPm+l2DShL7lJx3UlBmx53UZ+ZgQUHbki0urBNjho=;
 b=cJR4Qiz5CCd51pj9CEkLNFTN4+qMQZGHIFa6OORomcQP8gJr7v/aCGk4Kr1xVBYn5QAwbPxyEsCtJV1edeVCxNJ4/ziGECr18J1Orxtvak4/OGupfzJYCQmOIzFXtq/HYt1HrpTwdNodex9gXc9eQNQzQJHq27+mvp7k/yFKR7O9ZFrFNQorB4kg+YlYbFBKdxOVSbWLPH5pCklhQdtlIRKiLwXTlVrDeBM2YCfeKPTiiZOtYD634tdlqPwQEdh7l+CVXvDUoKLH8JPWRdrKkcOpCiJIaK10ajpEmLNBiwKz6tSWCZC3z/i+CCq+iT3GOEecabuqOsrpjef1Su4IWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UiPm+l2DShL7lJx3UlBmx53UZ+ZgQUHbki0urBNjho=;
 b=5sWMvpL8ltMTptFopMdzzInva+cAuHTsixIe7klqYhngUPKWn21fnVVkkZxkS2z48nq3CEN9oKMcGD/1u5v9UMjISZSmALu+TYM7P/+eyOdLuHFIuTwBAIVBnE7qMlpealn8y1SJ2rkuiHGSfl9oD5yP/bjF5+2zkugfzCHb4EI=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by CH3PR12MB9100.namprd12.prod.outlook.com (2603:10b6:610:1a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 19:33:08 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 19:33:08 +0000
Message-ID: <f255a2a5-7bcf-4627-b132-380485124f0d@amd.com>
Date: Tue, 9 Jun 2026 01:02:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] mm/migrate: skip data copy for already-copied folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, kinseyho@google.com, weixugc@google.com,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 willy@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, jic23@kernel.org, aneesh.kumar@kernel.org,
 nathan.lynch@amd.com, Frank.li@nxp.com, djbw@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-8-shivankg@amd.com>
 <810e9a58-9c08-4f5e-af5f-866685ca09b2@kernel.org>
 <a36348d0-73f5-4599-8d06-c9472d0b8d72@amd.com>
 <7e6a7626-5a1b-4672-91bd-85b0f4ee2ecb@amd.com>
 <7430d69a-616b-40cf-a2e8-6ef4e57b6857@kernel.org>
 <F496EB0C-B329-4A61-B4B4-0D434563281F@nvidia.com>
 <c9d98321-60be-4cf7-998c-7657d93fd683@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <c9d98321-60be-4cf7-998c-7657d93fd683@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0054.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:270::9) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|CH3PR12MB9100:EE_
X-MS-Office365-Filtering-Correlation-Id: b515a901-4e62-4411-6de7-08dec594c4e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|11063799006|4143699003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ompxh71fuxEqVlXmIA2dpMyB3N/0bolMeIkeMSOyEsovjVodldyNqVJQ7cKb2T5AXI3ZNxmPsPBI0sXJ0yQBQsAY95aympj+9bYMqJFuNrlZbGqxFftq4DsGNl27nKE6nG5F6ehoniLrvVDQFJWVy3KtzN6IgIWQKFO5aFYHjUP3Iz/UBJmAtbYO0ShnnKIZktUOPQ3Hq1A4GEj8oGUnmkk6lPAOr2izKXDYvGxXhB9OzQ/Hvd0bs2uLK3eHhMRGGY5cXOdTWhSSwIkpZ1ey8D6YTIwomiIfqZk9a3NVdTjTmJG6T+muP1bVzigsUXlI3n3tG6qMB03OjUaLZreMIySgOXEpFxQDYiagwnUtieSGUOuEvJ79xBH3Wha4lmSgPKmAoP/ZtswvLAoox5jhH72+VhXczg+Jqg5v3aG+pXMlE6/XgJXOarHrMWbXupFiL1wKetG/JXyT4QtJwyne1+qWzcJ+Yj98XT1U4inb/gwBwY4fFWSPLTS5FNTYxmxNRiRvDgf3Mv8nDPWKAaCay17jYCh8pS2xw1v/hlWSgO9Vjkc2j4qi5nEk83skU4NqYqsndTq14r7pbNAKPsErkL7JLCl7UDiXg/vJa5QbhJxI0gKo3fEUoNc1CtSZhmGs44VdF3sDDyvfWJ1AdvQzuhiALy+lQ5pkI5gNgcAR71kFHEKoTydAz785Y8+XuZfKOvMgRhH3dmzwl16b0WvjXg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(11063799006)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2pKeEJBS1BCdEZGRzY5b0ZWaUE0aWJGZHlyRkhsSjE1SlFjbW5rUkJmazF6?=
 =?utf-8?B?NVZMSGw3WDVOVnRvTVlqK1JuMHJtTWgzRzNOWlMvTkhwOTNGdzNiOE50UE5s?=
 =?utf-8?B?NFNYejlncVpUTWlCRGUvanZyenQ5UTJ5V1I1VTJJQlF3d2lOUWN4SWNObS83?=
 =?utf-8?B?dWw0N29QTFYwU2QwV1BCbjYyYWVPd1hSd3dCTnhCQ0t2MUhjNFBPcWFmeHRn?=
 =?utf-8?B?MkRLdWVVMDU1Rm1QYlYwUWhyVFB0dU1iRTQzcXpaSzd6MHIzOTk3U3NlT3JK?=
 =?utf-8?B?TkIvZW5ERHpjb2J1MC9ZcExTY1ovK0pxY0hacmp1dlJuYVJ1VWFLOC9USnNE?=
 =?utf-8?B?MG5hMHVDa3BHbzJCUHRYSlpBNlAzaUVsdGJOSTRuN3d2WmEwRWxDby81MGs4?=
 =?utf-8?B?Y2t5ZnNBMUR2UlpYb1NRQVg0S2ZaNjFXZ3RhMlBVUFVBTlZUVHF2MEoxVXZD?=
 =?utf-8?B?M240TWE2NHUybjRsWGFFQUtNVGk3aG5DWVJoUEQ0SFlpL0NqUyt0YkEveHBC?=
 =?utf-8?B?M2E4a2g3bkhZS0JyTnNjSDh3M1Rhb0M0dDNwdXZySFVxU0E2WUpUNDBjNDhD?=
 =?utf-8?B?TCtzTFB1cXJSRCtnVlBzWjRpRWVuWDJQQ1BNd3NwS2Q5S2p0eWFKYVBzOCtL?=
 =?utf-8?B?ZnJ2bm1PQTBQTFovQ3F0amFJWjlaaCticjFEQ3BHVkZ2cFJqakRIcWlOZlln?=
 =?utf-8?B?bktNN1lVT1l2UUplVmhIWjBtSlp5NkUzdE5FcnB4WVNyMlVzeEttTVNVR2Jo?=
 =?utf-8?B?R1Y5YTJjM1lCQVlmVk1tcDZzK09IVjZDWElpL0YrV25CMHdJcHFpemc5QjIv?=
 =?utf-8?B?MlI0NFZUVGEwVW9pQU0ycmFCQ1RvRi9STjRDQ1czUmxRaUNVMmkxeENTS1RJ?=
 =?utf-8?B?MlBXVlczU2Z1Wk5adFZGbFVLN0FLSnpZdVJKN3lxSWU5dWNVYll6RUhsM3Ri?=
 =?utf-8?B?d1lBeGhqZStXK3grNjZ3RUpxKzRvbjRGd0hjb1hYbzBzTTVsK0ZwZHAzOEdr?=
 =?utf-8?B?U3Vod3A4ZktQZnRPdCtkMk8xbGs4dHhCOWlzRzRSeVdYMm45MXNVNUNvb3I2?=
 =?utf-8?B?SGJ6UFpzQnFQQnhrbGlvTFFid1lGUUIxWjg3TWFEK3NnWXM4SnlGN2daUTcx?=
 =?utf-8?B?YXZ4MHdPeFJkVmU2SjVCRWJTekFPQytoRmpSeVdKOGQ3TmFzTGNvQStCdzVF?=
 =?utf-8?B?OEJUc2dLeDhMVzgwUVhRaUdVbDRYbUtNM1ZBWjdaZVh1OW8yaHkvTGpyV08v?=
 =?utf-8?B?TnJ6RlRoZFB6QXZqMURYcSt0cWR3QjB6T1UrVm1aTURJMlJIM0gwRVdKeG5S?=
 =?utf-8?B?bWRURzg5QzZsUDVCd2xlNndWQnFpcUpSSHBmdlV6M0xtaTRNWDhBa00ydElh?=
 =?utf-8?B?ZXR2bzFpbHEyb1dXV1lqTFI4bDZ6Yytpd2hiL0xBRnV0Umh4Z1pRbmovWEx1?=
 =?utf-8?B?VUZCUDhOb0w1MEpmR1pXUFMyU04wU0xBR25DS3RHU2hYWmNSSUNZcmxLTGZN?=
 =?utf-8?B?Zy82MmYxY1dpbkUvU0R5ZTBVL2ZVelUzb3B6enh3Y1E3Slhzcks0Q1gwd0FD?=
 =?utf-8?B?aGd0K1VuMkp0RHZ6U3Qwakl2SEYrMU94WlZ5Tm5JWXdPQlFGQlpoemJDcUpO?=
 =?utf-8?B?UEV1Si9KdmJmcGpVSzhrUHdGUGJmeGJPNkhmYXZ1RmY5dzVzV3VFZU00ZnNx?=
 =?utf-8?B?NzNrTTVNNkxMZmpWVGJFTy8vN0RocmtxZWZxVGpaVWc2cStvLzBBSFlMUmU0?=
 =?utf-8?B?ZEFIM1Z5ajZUQkhDdzRLeHdzczNod1ZJQVVWbXdSaWZDWkZwV2dzc1RFTnND?=
 =?utf-8?B?eTlDQ0pIMDRLUVpRekZ6SXdIQVZqMHArQk5uSVNiQVBjb3E4T2ZhSFRwWHgw?=
 =?utf-8?B?aWtJRDdiQ2FHM29kWVZSUThqcjIwNFdiaTR6aXRyTVoxOTNVR1JxTWZKNTZm?=
 =?utf-8?B?V1dET0tTZndKTzF3U09FWENxYTdYME5USmJVRTZSY2pMZDg4U2RoSThNbklj?=
 =?utf-8?B?cndCVzUvOExRcGhZVFVad0ZGejZxRDJhVUFaTzJEOEtpQ3hjVittNEgyQ0xV?=
 =?utf-8?B?dnNoSlRPZWFDL3lzNEd1dzBJc1FuY3ZucUQxMUlRSmt1TmxIVGNZMlZhb1ZP?=
 =?utf-8?B?NC95aEV2NUdKMlZ1Z3ZwSGNHL3grWXpwS2p4emloaXZoMllEL3l3Z1hIempl?=
 =?utf-8?B?NDUvcUJkaWNoN00zVTJybWR0T0QxWmlTbTl1SXA4ZXI2ZVBPZFdBZFZvTVBL?=
 =?utf-8?B?YWYzdDhKZDJKekxVRHRyQ1hNclFMYnlrdDEveWVTWXlZNlA5UGhKcTJ3RjN0?=
 =?utf-8?B?enpDbXpXSGZsNVNrSGZWbTJwTUNJUSt6cFNXUVBTNnVDeTVaV0UwZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b515a901-4e62-4411-6de7-08dec594c4e0
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 19:33:08.5054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8XXLT4/1MGsqj7iGzclrZMKq/zv7FBTD1yyTBWF3jG2IPp+CQeObQrvp5TH3pWaYgEqDTvpBJsPSqsMizGsuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9100
X-Rspamd-Queue-Id: 6B2D7100009
X-Rspam-User: 
X-Stat-Signature: ma8m4imq7h1sy4am3ziwnto6jzn56zwa
X-Rspamd-Server: rspam08
X-HE-Tag: 1780947195-867532
X-HE-Meta: U2FsdGVkX1/bXIq3iIf1i45UpAFlBN0kEUIiCx4FSjoF2vnJCD2oKMf9BJQ0eC2sjrm/w0w+rjjuDmOhvxqhklPV+pcwpkBAH1DG+yJK/lZqfPW4RP4aMTQzUsVwzGXgqWY2R4iMSttxW5ansMnwCu0gastO0NHj7yH4pisEGlLof8CwbUPN/Cj9RMh94SFsQxwkTrZJQ09D1o7q0dyWHW1a1N5yVpLs/jGGI/buxitOpr7ThE2ZoUnSPYNo54UBWkRwNQnvW8yo8oqghTHJnBRuPuuGGuSXVub9uaIDaR1YuiYpLIBUmPgV3M5RevGtuMdXh9yqhHvWjr+bJxB4ijLiJfUxI7yZ0QIIrOUeDPNJOlaCcjF8QU8YRE3ZHVtN2QESf1gJ7KciRm/muQjgSuyTaxertxvxEKgA1LpapSjiXG7uxkILqd/5q8uLobVyzAEtTXzlERC+9Bl0EarwJvDf3pbVavtbaaP6CjAIfRPhhMCRBt3hIfDTsq885TI6I7+G0x1PYNOt86H2+CPbKNsMJltRGOovGviKOyQUvOAqagrhP/01sotIee1la6JEBpV5zsgXQdNuB1Ud6vmfjLDEkXR4RP09QvSQjmv64xB7O8WrssLjXilryS/ENLStbQ7TyoqzzuOvDOBHJ5J1XDnov4RIkScjJvLT8lhQqMsjcARKTV9phABLK44nNU8mngCXyLqrWb7YAueqZPCB/xBUfrQwxX+93opCN1TC1cp5cM+s9Y3RbioQXYsB4AkPRu8JBNvuTw5vNEUq8ScT94Rt7Foyf9njtzKIkfMlD4qaZedWRs2MvbZg2lLZ1RRJ4jEnMpkcXrmbh8u3Kj9agGVGytmU10rEMGJiyPgCFhj3IbiyOw03AWaKR0CjMiYaWm9MTY+dDY7Zsdi1X/kK48EbDk/W//FyTB7cfACvhkmGk5t4aCi0IBj6v6J57KAbQrUu3IOgYI0Wxi6bkac
 Q+jv2jIK
 efrprL55EkxkgSXYpVbHuKrFLPjgjaH8XyAyM1/GR6g6BS6AGHmoxjUWtQK+bNLbL5AtakSnpKGm9igv7Akv//EjnCX5eeQFx4+pr2XHN+3BsTG3UldQzE9UpI0h2N8Rkc2MqP9wuVCfBkvKD9cGhRl333wCraDFhPSBcPrdoLYTRANmlHN2IOACpcYSNK+5YDvZSHUMjEFFubBjW/4yp8ejkU2//T/ZyS3qlszf6cmVgr1Q6XQxxuPGbiO2IQyc3scDJ+aWxCoUI5OMn6rcbFHCKVZBv6Xi0UzP14HglkfEe3AMAIR9cs9zqIktrk33O7nG/ZOVsT5IL+ms20gGGHTbHrzgTUxEvf2aJq7HS7zNo/wrOISTwsbifuoxOkQ7m24vPF+l7sbFn1VlCp7vwbI9wJSFWS50wa+XYgQk7sJ859knAzCm3zbPihk0A6o68/SQdNg8cjrtWR5mB8zW8ASXGfQqLi67Yf8iWtTmfrzWGpf4HqpvfbO5SM6HD1dnTpBNs/qmVy6mol/9IHqU8BJgwBZFGH4xnES4tLIfA0PCvdvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/8/2026 9:13 PM, David Hildenbrand (Arm) wrote:
> On 6/8/26 17:41, Zi Yan wrote:
>> On 8 Jun 2026, at 11:18, David Hildenbrand (Arm) wrote:
>>
>>>> Sashiko Comment:
>>>> Does expanding FOLIO_OLD_STATES to include BIT(2) silently corrupt anon_vma
>>>> pointers on 32-bit architectures?
>>>> The anon_vma pointer is packed with FOLIO_OLD_STATES inside dst->migrate_info.
>>>> To separate them, __migrate_folio_extract() uses info & ~FOLIO_OLD_STATES.
>>>> Since anon_vma objects are allocated from a kmem_cache with align=0,
>>>> ARCH_SLAB_MINALIGN defaults to 4 bytes on many 32-bit architectures. This
>>>> means a valid anon_vma pointer can legitimately end in 0x4 or 0xC (meaning
>>>> bit 2 is set).
>>>> When __migrate_folio_extract() masks the pointer with ~7, it will silently
>>>> clear bit 2 from the anon_vma pointer. Any subsequent call to put_anon_vma()
>>>> with this corrupted pointer could cause a use-after-free or a kernel panic.
>>>> --
>>>>
>>>> #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
>>>>
>>>> I initially assumed this to be always 8, confusing it to be same as size of
>>>> unsigned long long.
>>>> But the GCC docs note that alignment can be smaller in size:
>>>>
>>>> https://gcc.gnu.org/onlinedocs/gcc/Alignment.html
>>>> "For example, if the target machine requires a double value to be aligned on
>>>> an 8-byte boundary, then __alignof__ (double) is 8. This is true on many RISC
>>>> machines. On more traditional machine designs, __alignof__ (double) is 4 or
>>>> even 2."
>>>>
>>>> If my understanding is right, Sashiko concern is valid, and I can't safely
>>>> use BIT(2).
>>>
>>> 32bit makes this tricky indeed. And that's also the reason why
>>> FOLIO_MAPPING_FLAGS is currently limited to 2 bits.
>>>
>>>> I see few option from here. Either I can gate batch copy for CONFIG_64BIT,
>>>
>>> That's a bit nasty as we'll have to special case 32bit vs 64bit.
>>
>> IIRC, multithreaded copy is already gated by CONFIG_HIGHMEM, otherwise
>> it needs to perform kmap_local() at each copying CPU, which complicates
>> the process. Then, this code will only used for 32bit without highmem,
>> I assume there will no page copy DMA on 32bit platform. Maybe it is not
>> too bad to limit this to 64bit.

I agree.

> 
> I'm more concerned of CONFIG_64BIT handling in the code, but if that can be
> avoided easily, fine with me.


MIGRATION_COPY_OFFLOAD will not be enabled for !64BIT at config.
config MIGRATION_COPY_OFFLOAD
	bool "Page migration copy offload"
	depends on MIGRATION && 64BIT

I think only place in code we need #ifdef is:
enum {
	FOLIO_WAS_MAPPED	= BIT(0),
	FOLIO_WAS_MLOCKED	= BIT(1),
	FOLIO_OLD_STATES	= FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
	FOLIO_CONTENT_COPIED	= BIT(2),
#else
	FOLIO_CONTENT_COPIED	= 0,
#endif
};

With FOLIO_CONTENT_COPIED=0, this will be no operation for its bit operation.

eg:
const bool already_copied = dst->migrate_info & FOLIO_CONTENT_COPIED;
evaluates 0 for !64BIT.


Git tree (Work-in-progress):
https://github.com/AMDESE/linux-mm/commits/shivank/batch-migrate-offload-v6-wip: 4cd9324a


On 6/8/2026 8:48 PM, David Hildenbrand (Arm) wrote:
 
>> align arg. Or I can change the migrate_folio() callback to pass already_copied
>> info to change to dst->migrate_info enum.
> 
> Can you elaborate how that would look like?

migrate_folios_move(.., already_copied) -> migrate_folio_move(.., already_copied) ->
 -> move_to_new_folio(dst, src, mode, already_copied) -> a_ops->migrate_folio(mapping, dst, src, mode, already_copied)
             = migrate_folio / filemap_migrate_folio / buffer_migrate_folio (many other sites in fs to change)   


Thanks,
Shivank




