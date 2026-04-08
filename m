Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3639E1073C98
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 11:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789DE6B0089; Wed,  8 Apr 2026 07:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760616B008A; Wed,  8 Apr 2026 07:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6501F6B008C; Wed,  8 Apr 2026 07:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 525536B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:17:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3BAF13BF54
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:17:04 +0000 (UTC)
X-FDA: 84635136810.22.B6AC131
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010054.outbound.protection.outlook.com [40.93.198.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0DC2E20008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:17:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TKVBV51e;
	spf=pass (imf13.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.93.198.54 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775647022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n54BVczbEN8JrCWcfMdvaqIYyA82nocyzX6thte2GNw=;
	b=dsDFtrAIZr31jHbF5jeW/h2d6fcji3Df/SmY9JVvqIhZeyvwNszJ4ZvSfyOSPMr4vF+b4x
	LjJ6slWPsWnZ7tYUt5+y/cIxFHPNnGW6IpORT7cKRzybjM/czgAM9uqYpTtCVRZi0Lrvdu
	5zAvPHgqTpB16g61MWHfVNJC6H3w/+w=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TKVBV51e;
	spf=pass (imf13.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.93.198.54 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775647022; a=rsa-sha256;
	cv=pass;
	b=kzYTcY1T/X6HC1LjVDTQAiyicG2hS7dZQIO+XEntBRF6acpNAtNNmcAyQ5Svpz0z3Flb0u
	FHxCtAyhKPIZzlrCDKLrMWv/kLG0yX4DSSkXeqQG3SU4FQnvY1QIxGKs4wGCb4t0sm6Kud
	dnaFAUaa5pEnSceKLAfUDwtx4uWauwc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V1znlrEriL+F2RM2W3PyHkbFeqPrANzEgIn90hAmwvOp4UCAQMDK7S8hwwkXp0NA28YeCwKTdXOCoR0CKApmtpO4/YrIfLTjbGHWTAoD9d69PYcc7wGQVqFEq0FXiMIp7+JGga49c9u5hLUZNJBN7je4Wu6pHEVHQbypRTqypnwsanUJfmxBdQh4GV3Ng3zYv1HNmWZwIQfVswWDa1v6Bvhs3xiJjsBnnWfmxZB6HqwA+mjBXOl4qht8IA4mbYakO13BLEcSAKaguvZ3CiRvbhrgL23sljfMFkcx39uy4a6ptmnsm8dTQl8Ty3R3Uq7Ruph8x6OC8r+tQMewIXMhJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n54BVczbEN8JrCWcfMdvaqIYyA82nocyzX6thte2GNw=;
 b=STtOk6t4oCn2r5vE/+uUvJ5zR5pU5q+QpA393EkV5FWL70Cn9J+kPyMIfFp4zjs6UEd5dQL4ZeiGdiJxz/dSugAl4KdlEcOsmFiFHspKsyWG2X6wHG3Jc9kMv8UUG0CssIHMpm3vbfD7u7yk9MJXD0pB0sP2FICE9c9V/AbxEywhMhsC2ZIIAKqDVXcuYcPfz94snsMSjmuuwO6J0bv8AQtB3xLgHrdYFlThowaY55I9Tq44Cyy22Ax5rOJYxbWgAjJ45Rqe6fbWh3issar97SsfdELJfEggkbhS3dudXe241rA4PC1JX6CPkCCzrcu81yYImn5xEUHdLI0mt3rlcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n54BVczbEN8JrCWcfMdvaqIYyA82nocyzX6thte2GNw=;
 b=TKVBV51eO3jnfjlUTa1069rmQd1+hTHwq0Wgv1UA4L6HwLqlxoI7oxVPIqtiwZ5zf36YJANT6e1JWZr/5reDV3Q7zJTSRykS7Z+QDFjWYWlDLHl7ZsezDsHm9IGEJ22HTcuK3UB3RmP0V84Z/AzUOxCXYHGIESZU3EYIgdXtUFY=
Received: from PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Wed, 8 Apr
 2026 11:16:58 +0000
Received: from PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::35dc:5b7a:52da:c8f1]) by PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::35dc:5b7a:52da:c8f1%5]) with mapi id 15.20.9769.016; Wed, 8 Apr 2026
 11:16:56 +0000
Message-ID: <aceb0077-b206-4484-b102-07de537dcb1e@amd.com>
Date: Wed, 8 Apr 2026 16:46:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
To: "Salunke, Hrushikesh" <hsalunke@amd.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bharata@amd.com,
 ankur.a.arora@oracle.com, shivankg@amd.com,
 David Hildenbrand <david@redhat.com>
References: <20260408092441.435133-1-hsalunke@amd.com>
 <22b6ff3c-9d41-4eb0-9beb-cb92f3ada89f@kernel.org>
 <4e8c218b-ac5e-4674-9e1e-acf750f0a5c8@amd.com>
Content-Language: en-US
From: Raghavendra K T <rkodsara@amd.com>
In-Reply-To: <4e8c218b-ac5e-4674-9e1e-acf750f0a5c8@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PEPF0000017D.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::48) To PH7PR12MB5805.namprd12.prod.outlook.com
 (2603:10b6:510:1d1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5805:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 840e0f2f-0cf2-4868-b69d-08de95605863
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	I9dXTQbAvAtMR4I0n6H8d3qHHmYR/hjMkS87RsF0qG8l6jcSL5lbc4W2or5/0RGpG5F+AEhltdtCHHW++rCxELH0KOYVWScUFYHeMkPlcYgCOf1kKwfARbP3QlEgiCuJJCn1g9+oXRz+AsV1iwYHNH0XQ92nrDCzi+p9wBfWjG/ieqBQOJ1y/sg++xnXzV+mlE4gHeHFEc2gQIYna+tz6hBsI8qjGILtwd6NZYS86UM4330C/exCsXJElPRTzW8LRLYWp7ehp0X3MMwKmsQ8bCcvbb6rS7WVqswrvU/o/45PqyZmhPW5iR6USqNVAPofFIcPHcdc9bUhNQyK2CjXmFlP3DzkEK5Y9gw/FXsX6W16+uzHMqSvaQ/H8Ql20583xj0Q5nYRYi22eqPt058MfKDZnxbNbheyAxgplVEMyye4SGY5Vm1oxSlKWRublGfN0ZAqO47s1c+gORHsa6HDlEsYBJb+QW5tFb1nqRtlC8UrqK9rYawvedUQFsCVak6wI2AS5cRLpIRkQjTA/r3KqtpjBJQ3X1GPOWLIUyVE2Z44eWwfvySYrVBik7p3IKPhjLW+zZlH8Y/L6LWpADs7LTgdo7DiTvnBH3UdEsWCP1BHtuzv9E4RFXsYQTdSjx1r415p8DqY2oBuQRaE/bIfZm3rFSfaRvUiVxBpL4zLAD1qaMYsw0tgMYg5VfTUgIwjf0+hXbsnpfaEWjf7U/0/ziQjN5HS0AJJzuwzh3ME80cggXIgycAxIJPy82XXxN6r
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5805.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NXdnY2c3NnBRZzBFUDk1VUY4dDcyUjNuU2ZURGJVZVpQVU9MS1hFcys3cytj?=
 =?utf-8?B?UWRBRFlJUU5tMUV4djRuV0ZLMnp6SzZDZHNLaGZMY2laNVJvblIyTmREU0Fq?=
 =?utf-8?B?cVBCbVBOT09IVGRzOUI4UmhnMGhERnlNRHBucWVKSXA0SmxOR3dsY1BOakMy?=
 =?utf-8?B?M2JmanlTemkvT0pkbnV1N0tJL1k4ZENCcDNYQmxqZmFGcHl3bFJhMitMK29x?=
 =?utf-8?B?S2JoNURXM214ODlETk82NUZ4QVFzZ3BvM2tUTFcwUjY1NmpZd1B5VFE2RlBa?=
 =?utf-8?B?QmFzSGhDdmVIY3dyTE51dlVwRkVFWjA0RERlNWxzQnUxWGxuc0lsOVJqQUZy?=
 =?utf-8?B?Y1U4dWI3dEVCN2NTN3gwU1Z5a2tTamd4d3F3bmVuQTZUOE01b3l2bncxTU00?=
 =?utf-8?B?VW9oRUkrdis3ak5tU29LY05WUlFvaWMweGVPUXp3Z0twQ3hhTVhPaG5ES3h6?=
 =?utf-8?B?U25IVXozeWFBK0U5dFZMTG1TMEhxWCtnLzUzRlRSLzE1TVlKcmVXSThxZ01I?=
 =?utf-8?B?Y2tpMTZ0RjBKVTl6TjdOcWdPODRCRTBjeFU2UnAxSzFmc3VvSTNzeHNPTzhj?=
 =?utf-8?B?eHFEekNNZlkvTWFvbUFLeEU1UmdsNmh6cVZKcVg5SjdhWTFDdkFJZUlWaDhh?=
 =?utf-8?B?cUFxZDFmNzV5YzY3azVwbmN5Z0ZaeU5pVWNSTnM2QTRDbHcxTkF1dlJvdU5F?=
 =?utf-8?B?TEtQdXllbTlxYmE3VFNETVZxUGhnRkYwK3hxTjlBMHVkbTFmMzQ0aXlyWWNJ?=
 =?utf-8?B?SDloT3BWN25aOGhpOXBpZm5JKzN0UkhLbVJhOEErNEJYZFE1VGJ5OENsRHJV?=
 =?utf-8?B?a3Q2MTlXaW5hRjY5bi9qVFdVcSs1VVZlU3JoNFRxVnl5U2VFMnIvajBtbzFi?=
 =?utf-8?B?aUJxZ2psbHN4aVBtWTdwQUlVamxUbDN1UlpFVzE3alFhRjk3V0hQcEJzcUlj?=
 =?utf-8?B?bFR4bWkyNTRVWkdwK2lRaS9jVElDMitLbzZNOEdIWjhldjh2T3BOZFh6ZThR?=
 =?utf-8?B?UzZYcHNMMEwxdVV5WjFTTDFvWDA0cWxtZWpUd3pDbCtnOTljRUVuUWROVW1W?=
 =?utf-8?B?RDFnMW5oY2ZyK3lkNldRU0lvRWY0VHF3ZUNMTE1TUHJOQlo1cHFNL1lOSFlh?=
 =?utf-8?B?c3hGK1VmMDQvOHl3SzkyZGtNSm9STmNsUmxOajJIcUhlcjFZamJxd014MW9D?=
 =?utf-8?B?S3ZRaHRtWE1YOHNsMjlTdTN2OXVad2xGMnhrZjhROUlrRVFrQTZPLzc5OHFh?=
 =?utf-8?B?Z0l3Vi9hRDFhSTJuS0F2ZG9EMnNCbFFpQ1IvWmFsUklmNzVXK3h1bmgyMVl1?=
 =?utf-8?B?c2NnVEt3TzZ5T2JxRC96R0dXQlRHd0QreW1iZWZGUDJFbTh2V21iaEV0QUgx?=
 =?utf-8?B?a1QwUzZTeVRhVWJxc3dmbmZ6ZDFrdFR6MS84VEd4UXRpOFBZcmtSR3VVSThY?=
 =?utf-8?B?NkRoTjR4cjNyVWxEaStOa0VKSFFDVXM2OFpqT1VBNS9jbkZXWEpVWWg5djJP?=
 =?utf-8?B?T3ZqQ1p4dStTMHZ1MkZhSUYzTzRFcnNkSVhDZnNhd1RsM3ZFNEY0Sy9oVk40?=
 =?utf-8?B?ZzduUXFPdWZpSnNYRnhRcklqd240THp2NXp5UUpoNXZ0OTNSTVltaXR3dGNF?=
 =?utf-8?B?bUNxUWN1R0ZoTU9vRmtUNVZjbS91UWhBUURVcHVISFNUZlJZcE42dHVPV0d2?=
 =?utf-8?B?Zk1tekFOVXJvaS9yaUlPN0pBT2drZElQWnhuYyszSHpoL0drK0V4bGZNOWMz?=
 =?utf-8?B?bE1MWFUrbGo2akMxN0JjU1ZEbHNwTHNoR2M4MHJWRzdTVjhtaG5XVnpjNHlZ?=
 =?utf-8?B?WTJOR0hYRys0ZitwZ0dhK2FCY2FsWlJWb1gzTlZiYVRHclREK1FmNFlSSEs0?=
 =?utf-8?B?cTd6eGRQQTBBVWdYcXBjR2lNUlI0UTUxVjFVRGpNMHBtRkRZdUFVVVFFaW10?=
 =?utf-8?B?VlVVaVMwcG9NR3BEVnlJRTE1TnpvVHpLVG9CbmxpTXJpMFFOaUJWMUJLS0dP?=
 =?utf-8?B?WFpudHJFS1h2N3BnViswNG1MN0VEMHNRdFErbHpYMWJNYmZLN2c5VVYwQWc3?=
 =?utf-8?B?Ui9iU2hpSkFDVU5ablFnd3ZrRDZETE5RM0tQRHN5SnV3c25lNkl2TGtVV2ZY?=
 =?utf-8?B?WGxEbWZFWnNsS1JhRnVLY0dGRHBqdFNnSmY5MnNSdEU3WWR1aWpCZ2pzYlhG?=
 =?utf-8?B?cEN1cmpSMmMwamRDZ3pVZjh5OWVMQ1FZMU1zUGlpWDFRS1lNbExSUUpmWCtE?=
 =?utf-8?B?WU5SS0NxS1J4NkdOK2dsYlVWWVJBa3Z4QzYvVzhGdE5jcGRreGZmZjg4Tisr?=
 =?utf-8?B?RTlHdDdSbEV4VXY2Z1BaUWxDVkVHckxVY3lPODUvcnZiSEJPbnJmdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 840e0f2f-0cf2-4868-b69d-08de95605863
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5805.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 11:16:56.6775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pAF4kryb5HrH7fO/k/nMSkyFh3O3f2vxS6uoEzqrggukfdw0Z/bPaB6zogFm7n8hdE74E3TSU6xYmRbBfkfB8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565
X-Rspamd-Queue-Id: 0DC2E20008
X-Stat-Signature: nfxca6nzpz8qji5wy6c1do6mefqatx7h
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775647021-43313
X-HE-Meta: U2FsdGVkX189gIgcS+R5Y2IBOC2NE7ax7q9iuElvOB3efvE9g8+G7tH4PB2ZFImFJfVaVU8LTeldb9fWFt/1O7cmK4QI2mj9xbbslATwefgawwJGByRwMFeGKlqH9wbq+Kw9rDiEbDuV2xTSOi54/g3pq/pUrBJHH8qq59FN9yAm9So5/PBtQFxbp8Nys9N5rKw9Kb2MFNPBrh71OYWI+fXUMMlhg3DisUlWimoInLaCZgZDVxYk47PEugD/NaAiSUxrZ8P+YajOyA2MGsB1Va47hU+Hh6KHWRbsJCFjhuI9H0KByU8D7VqdZsYofpTiY7cs0hSTP1RwFm/s1mFujNHBoI3n6TfHJrGmqqRlCn/r6sdiNdhUHIaIsy6IDtC8hH5myk/uPKfzPaByAkHPRnx8D6jsKHXYIJQqn9+1tDaJlqfKMwzoEG8TyMQb3GyoSlWQXZzjmlZThpiSmixsQ2ix0aOu6Rr0hQhsUKExV0CnO8iziMhksICoVHpQ3m7T+GQWFAdJ/xwLczQxVe8XHu7sH0xlOODx6tqUpnh+v1I5v2cAU+nMoP7Kdsuzt0TMyrxJ1xMeN9nwSOUuN+/YCJWL79yCZE9B9Uy2C8NSHF1wvuL0oF+56hP1VqT5RrSGYDzkQVtH166BbTVkbinmDLTExWK2PctAJsoj7o2nlcqw0YPwoh52thKWYC0yEV9sCCKJdimMJPpZRs2na3366UE+y36g/anDgGH8cPU7ZPDLWMqeksq1qaJ7JLmbrmypFpt8e3cDzpAs78398SDUENy1WM9Al9dPrHSE2rzQDe/olsv8oK5D9dK0hua/52JFIahxFDDf1jGOdbP3oEDlVvCkI8WnGBcvH4MhpBVZYiN5aoTL5Q8wy8qvXfB3WcoUWz/4shv9QzHg4fcFvoVytUVdm2Qlcfg6Hn33MBE5mHf0LCIImIfyyncPH0EGa0rdp8rqdYcd0YMjXQcZHSA
 0CIiBa8I
 MOnzwC9veQPkmF6/O7/fBdBGglGMsVPcGaBBX/U9ZFredJIGuXZcV3dkY9kQWCea5iyO22zNkJm36MngXru+82R65LaxhquoPzyUfdRRDRGC693TLYoFswLdCmXQALFOsFnFEereaQKkrJaz2+UjtbWZKTWt/tl4kQ78VpCFXjibdP75z3gNITmCG856lBfvi6hw5gL0PaMwFTj2T5dviEOgoGFA+IfDzQn3fn9sD8CpPctb1yOlRkH57GKoAIO1lDcmeC5KoDSayqrQlkzGZHcp8Yg28+DNkvyVbL+vXj6l3AJ2KIs0UsrLhBFcG+/SD2gZyr1ZKX3QkL6MyD5jLy0Dv7E97VT+3bfx7SssPeMNxyDDFu00VwmUVMekKkc9r9HH9HXygXLdi6//C4UNCNUXrhnA7c8rCqSP4/hQZB2fkHQzCfM+cFPGIpQeM1/KGQG4IPn8fOxB+ZmFiauDg9cPqFAA/D3RK+a5HeHDXlt6rh8Cj9XmboP8BtzC+dhRxP72cD5kD7YzHPF/dyfKsXl6H1oAjF5UeFHeksbNm++j2qiJoA1VBhXfNE+nuKFCeQXLDIkKZOwiXPoRcb+YmsjMDtxbKiAwceuV31H5c9N726vawP3JZfOOXbby2wlDj7OMBNe788rMtXkYl8eSikMwTKT/CBRm6U+TN+cZzGGb1IjrleHWbZFeS8IiHr5Tz8Kto7bKeVvo2GpmVb1u3ZC0W6fqHpJiIj6MnfvwlBi+2n+XUyWo1nbLZaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/8/2026 4:14 PM, Salunke, Hrushikesh wrote:
> [Some people who received this message don't often get email from hsalunke@amd.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On 08-04-2026 15:17, Vlastimil Babka (SUSE) wrote:
> 
>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>
>>
>> On 4/8/26 11:24, Hrushikesh Salunke wrote:
>>> When init_on_alloc is enabled, kernel_init_pages() clears every page
>>> one at a time, calling clear_page() per page.  This is unnecessarily
>>> slow for large contiguous allocations (mTHPs, HugeTLB) that dominate
>>> real workloads.
>>>
>>> On 64-bit (!HIGHMEM) systems, switch to clearing pages in batch via
>>> clear_pages(), bypassing the per-page kmap_local_page()/kunmap_local()
>>> overhead and allowing the arch clearing primitive to operate on the full
>>> contiguous range in a single invocation.  The batch size is the full
>>> allocation when the preempt model is preemptible (preemption points are
>>> implicit), or PROCESS_PAGES_NON_PREEMPT_BATCH otherwise, with
>>> cond_resched() between batches to limit scheduling latency under
>>> cooperative preemption.
>>>
>>> The HIGHMEM path is kept as-is since those pages require kmap.
>>>
>>> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
>>>
>>>    Before: 0.445s
>>>    After:  0.166s  (-62.7%, 2.68x faster)
>>>
>>> Kernel time (sys) reduction per workload with init_on_alloc=1:
>>>
>>>    Workload            Before       After       Change
>>>    Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>>>    Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>>>    Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>>>    Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
>>>
>>> Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
>>> ---
>>> base commit: 1a2fbbe3653f0ebb24af9b306a8a968287344a35
>> Any way to reuse the code added by [1], e.g. clear_user_highpages()?
>>
>> [1]
>> https://lore.kernel.org/linux-mm/20250917152418.4077386-1-ankur.a.arora@oracle.com/
> 
> Thanks for the review. Sure, I will check if code reuse is possible.
> Meanwhile I found another issue with the current patch.
> 
> kernel_init_pages() runs inside the allocator (post_alloc_hook and
> __free_pages_prepare), so it inherits whatever context the caller is in.
> Testing with CONFIG_DEBUG_ATOMIC_SLEEP=y and CONFIG_PROVE_LOCKING=y, I
> hit this during exit_group() -> exit_mmap() -> __zap_vma_range, where a
> page allocation happens while the PTE lock and RCU read lock are held,
> making the cond_resched() in the clearing loop illegal:
> 
> [ 1997.353228] BUG: sleeping function called from invalid context at mm/page_alloc.c:1235
> [ 1997.353433] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 19725, name: bash
> [ 1997.353572] preempt_count: 1, expected: 0
> [ 1997.353706] RCU nest depth: 1, expected: 0
> [ 1997.353837] 3 locks held by bash/19725:
> [ 1997.353839]  #0: ff38cd415971e540 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x6e/0x430
> [ 1997.353850]  #1: ffffffffb03d6f60 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2c/0x220
> [ 1997.353855]  #2: ff38cd410deb4618 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: pte_offset_map_lock+0x92/0x170
> [ 1997.353868] Call Trace:
> [ 1997.353870]  <TASK>
> [ 1997.353873]  dump_stack_lvl+0x91/0xb0
> [ 1997.353877]  __might_resched+0x15f/0x290
> [ 1997.353882]  kernel_init_pages+0x4b/0xa0
> [ 1997.353886]  get_page_from_freelist+0x406/0x1e60
> [ 1997.353895]  __alloc_frozen_pages_noprof+0x1d8/0x1730
> [ 1997.353912]  alloc_pages_mpol+0xa4/0x190
> [ 1997.353917]  alloc_pages_noprof+0x59/0xd0
> [ 1997.353919]  get_free_pages_noprof+0x11/0x40
> [ 1997.353921]  __tlb_remove_folio_pages_size.isra.0+0x7f/0xe0
> [ 1997.353923]  __zap_vma_range+0x1bbd/0x1f40
> [ 1997.353931]  unmap_vmas+0xd9/0x1d0
> [ 1997.353934]  exit_mmap+0x10a/0x430
> [ 1997.353943]  __mmput+0x3d/0x130
> [ 1997.353947]  do_exit+0x2a7/0xae0
> [ 1997.353951]  do_group_exit+0x36/0xa0
> [ 1997.353953]  __x64_sys_exit_group+0x18/0x20
> [ 1997.353959]  do_syscall_64+0xe1/0x710
> [ 1997.353990]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 1997.354003]  </TASK>
> 
> This also means clear_contig_highpages() can't be directly reused here
> since it has an unconditional might_sleep() + cond_resched(). I'll look
> into this. Any suggestions on the right way to handle cond_resched()
> in a context that may or may not be atomic?
> 
> Thanks,
> Hrushikesh
> 
>>>   mm/page_alloc.c | 19 +++++++++++++++++--
>>>   1 file changed, 17 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index b1c5430cad4e..178cbebadd50 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -1224,8 +1224,23 @@ static void kernel_init_pages(struct page *page, int numpages)
>>>
>>>        /* s390's use of memset() could override KASAN redzones. */
>>>        kasan_disable_current();
>>> -     for (i = 0; i < numpages; i++)
>>> -             clear_highpage_kasan_tagged(page + i);
>>> +
>>> +     if (!IS_ENABLED(CONFIG_HIGHMEM)) {
>>> +             void *addr = kasan_reset_tag(page_address(page));
>>> +             unsigned int unit = preempt_model_preemptible() ?
>>> +                                     numpages : PROCESS_PAGES_NON_PREEMPT_BATCH;
>>> +             int count;
>>> +
>>> +             for (i = 0; i < numpages; i += count) {
>>> +                     cond_resched();

Just thinking,
Considering that for preemptible kernel/preempt_auto preempt_count()
knows about preemption points to decide where it can preempt,

and

for non_preemptible kernel and voluntary kernel it is safe to do
preemption at PROCESS_PAGES_NON_PREEMPT_BATCH granularity

do we need cond_resched() here ?

Let me know if I am missing something.

>>> +                     count = min_t(int, unit, numpages - i);
>>> +                     clear_pages(addr + (i << PAGE_SHIFT), count);
>>> +             }
>>> +     } else {
>>> +             for (i = 0; i < numpages; i++)
>>> +                     clear_highpage_kasan_tagged(page + i);
>>> +     }
>>> +
>>>        kasan_enable_current();
>>>   }
>>>

Regards
- Raghu


