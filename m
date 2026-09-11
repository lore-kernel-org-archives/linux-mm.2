Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D139C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 02:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40F076B008A; Thu, 10 Sep 2026 22:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BF0E6B008C; Thu, 10 Sep 2026 22:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2616C6B0092; Thu, 10 Sep 2026 22:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9BDA6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:38:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1C3E8068C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:38:27 +0000 (UTC)
X-FDA: 85199922654.04.7FC4B86
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011051.outbound.protection.outlook.com [40.93.194.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id CF7A440003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:38:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kdNSnGBZ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kdNSnGBZ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789094305;
	b=ZVpBLn0UsoqwiN3JMypvxKAmr/RZA5j4V4lg374s1Ml3V6md97bkdrZxiv6XD2RBAoHtRU
	rJOM7tAMDcVrCatBpSn+k1g8KfmAEVNBagAml29Sq1ch4A7+tDqsuMJffSVtX+ohXCqmXG
	B0HV8QUT2OKvH4CTIH9XoT2Ir6yrASo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789094305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLcyHGopRQOaCTBhCNb4mbosmdjsvInDdNFQrIVuV7k=;
	b=Uo0ij78XJUVLSrT1AnFY9HZ/H7/m4BHFspDhCjh+9FWlHU3kiUGpZgiCXE/bm+I4udMj7n
	J+PgKu1zWwX1ASB7YbwifGYWjdb2ZxukvrteRRvwQ8T+cFJeCzYTtHi7qAq4thnKGc8N6a
	o7SKqx/O3EfZlxZqYa+hfXY8RFbxKrs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r/tJlKYMmO4M4oq20qWeMWSSsgaPXaFMAiV5aGgekLQrF0fz1alT0lYbPHlHCzfBazS/3qTW2j2OaoFjcquhBRfvptGRzCQIAD0etPYb+TI6idoCkgslX+t4pJHt07zn72YtAUWU0Y0VENAXU+bLSE1mUd1S5pfS/y00+k4ekIRoLfD2gR4reC2iLO2kkvFDtq4AxpS/uanxmpSbXXQBXBnPcaQQlPKIem7dCHXsJEGo0vBRiNlZ43CXezvBKu6svzA+xpoENGqdmVp+QyHEIDKN4UzktHhfaWtuB9AdXIdDSNPE9FeumPyelT+dHfu7dXuDReXEB5K2wnDX7Qu7Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uLcyHGopRQOaCTBhCNb4mbosmdjsvInDdNFQrIVuV7k=;
 b=ByxyVqLn/SOs2qkf6QAvAe2xBQPYt0lHFA//x2VpB92DkG2iJoULgk9dhU5tMhfrSgf2cJsCHxsU+Vxfy5UsYr3dYkEuhSRl1Jtk7NTojBWbSrDj8ItaS53T/U6V8U4jbS1DLah6U3IyJWX/J6igUjEOC/HDfJ5TE5q1LGn9x+kQkxiNpVjPNQXPGiz5MLJMvPuigG4U9MV85WB7kKysPMmsG6K5qTNfwst/rH24bu719/gZgvqD0jQRuEMBVlpjQ8aG2PwfEOfny6faxJ58pKhsyrSPMxJn8SNO5RYRXtDrOsVrJ3A5AWyIyKkKEE7/NZVS2ubi9cWQprby2htx3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLcyHGopRQOaCTBhCNb4mbosmdjsvInDdNFQrIVuV7k=;
 b=kdNSnGBZbqwBgMun3u+ijpGYeekxfr/yd/MUp+cSGh2FyBjpYyCMN+C49q9UlKJ0yNM+FsNFPy7OKv5bBnvDrdlGmEKEVBnV68IzZCAcXlM7wPk90h9lAGd5I2taiR0YZGVQegqqOOo64WEdeJugp1VOLKLS1XyYgBOanTKvlISa8Lgdt+XMBmhKt8c4Vi7QWoCHQ5MdSMQ7HUHRzmOOQ3/fwigAujS+Jep629aRxfwzHOkPmCqmLL5NbbiQU1vVUkDRDgrqK3r3Bo008zGFMuDj4IZgjnhKAFvjVbr1lkXYVIv6PrMhqkVjfneoUTfLjE0XHMqfn9QeBY78BCl3vg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV2PR12MB5774.namprd12.prod.outlook.com (2603:10b6:408:17a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Fri, 11 Sep
 2026 02:38:14 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 02:38:14 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 10 Sep 2026 22:38:13 -0400
Message-Id: <DLC4ZVU8JXFG.3SS0W4STZKWBA@nvidia.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>, "Liam R . Howlett"
 <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn"
 <jannh@google.com>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 08/12] mm/collapse: separate scanning a PTE table
 from collapsing it
X-Mailer: aerc 0.22.0
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-9-kirill@shutemov.name>
In-Reply-To: <20260910120238.2529819-9-kirill@shutemov.name>
X-ClientProxiedBy: BL1P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV2PR12MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: 50d5350c-5a0f-4a31-867c-08df0fadba48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|4143699003|10067099003|6133799003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	d57eFfbOTAbI59dfixuy17oDCdaLL+glfBZqJAX9w9Vklz1d6N9OIMJog569DQ0MwMs1M1g7cJ62Xc26BoIUfmHy7oSAttwQozWhbe4mIHlvFz5DcXJgmHmhUBt+QGneUXBAX2WsB+8+xGt2BDlYunrEGJTIWRg8mfI1Chs0nFhQV07Y52Q5gs+7Ty6uODWjuKg58pgFcOjduaF0lcFaYYLHHWNvYLCS0jL3mGGrbv82pS5Qz6qsSuV6+LK3l71DjDy57GxfEfrvSfShxU7lLPrFv7As2O7U8SFu/vBTzD/nKli0t5HKSK9dDVvHiuaeJeVpDrTxky1ui8K3h7ZheOTfur1fmBu95UDE1taUG1i2bcDl302EXAcF5wT2pJ+50FjByzQ87CpQqpqW+nhJcbh9HNTqhvR5P9iuFik1IMPEDGwZ3s6sva3NU1xTDHjtOaE/zH1GUKTRWyzr/+Ns2sbkjCC9IIXmAoR9Fz5VvbYc1SwPV7ZOUP5mahF7I9FhY9JeiOxRetkwE0heZzlbt3muUDxqw8MLqBLP0IAw2owFwBRIr/5ku4Is9rfW38azWCpM7hu85FNRIiGapWjW2AdkOnjBK8jnKnvIgHuenIju8UFIaF5bCwvSAg7B+anFJFe9LM4MDuUHFGcb8HEWgEYju4DsrrdTPW7QC+aD8jo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(4143699003)(10067099003)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUNsTVphQ2s2N0NpMHEvOFhhb2w3TndlMElWQWtpM0hRcnIySm1ZS1h3aDRn?=
 =?utf-8?B?dVEwZTNwWHlzUXN5Zk5aV0d4QTJ0THJZdmpYdjVlUTNzWEhpTGw2UXBNU3Y3?=
 =?utf-8?B?MFN3TFZuZ05RNGVzL2JtOUFEVUE4ZVRFZHFyQWdobXYxSGdoOFpUeWh0Wk4w?=
 =?utf-8?B?N1A1dVVWS1lmT0I0dThIWmxYYi9sOVk3QXplWWxET0RGMDFUbXZmYTdEdnJo?=
 =?utf-8?B?T09yRy9NUThObU96WDg3NHgvWnVMTVNMbE1sOExVcjhGbTVpNEtTeS83aENu?=
 =?utf-8?B?aDlKalEzZFpwTTU0UXhwdlAvSjh1aXJ5dkFLdEpZQ2htU0xTWU1IbGhPQ3ow?=
 =?utf-8?B?aURsVnJmYXNiS3pSTWZWd0JFNmw3ZXFzd2U4T2NLU1JaRFN1RTFyRWxZQVFz?=
 =?utf-8?B?RjhEYnZjRTRxWnFZVDNqV0hzTzFjRnpDYjRPcGtRWmh5dkZ4Wk15c2FEQ2hs?=
 =?utf-8?B?Zm93OHhwR2tqU04vb21rRXV3MFlqVHJheGlhR2U3VWNucXNGbkNzT3RIQjhz?=
 =?utf-8?B?clViZlBCYkRDMFJEZXRwSG53aUlmSVBHTFpUT21oQmRzSlZWaW5LYXhKUFAr?=
 =?utf-8?B?YzZGeXRHbVdwWFlqNjZnemdTRnFGMlRaWk9rYWRqSVlaekFFTWxidkZwYTFU?=
 =?utf-8?B?VXNJSmloQmNmdWdQUEhmbHFaa3lNVmpHSk56cHg1L0htNUVHTWwyUnIvcDlk?=
 =?utf-8?B?LzhJcEJyYjMxSkNDUEloRjBsMDNSNkd0T1RGUmdjaW1oT3hkUS9TVklvb2tz?=
 =?utf-8?B?bEVpY0FvdUNZemdOZlFTdDRZa1pUSUdYRVM3Vmd1MXZ4cGdiUkJlaFlJMHdy?=
 =?utf-8?B?NmpvOS85MnZnKzU1Q2RvQjB1dTlsNU9kYksyRkhyY0Q4ak9MT0ZPZ0hjRGJh?=
 =?utf-8?B?dHBHdWlZZG1pWnNhK2E5bVU2c0c3YXlZcEgyaDhxMEpYV1RheWNTYVRadGs5?=
 =?utf-8?B?U1E1Q1FGbWFiMnI3R3c2R0k0SFlwWGhhSnp3YTBTWDluMWNkRTlVOWRIcmNI?=
 =?utf-8?B?OGtZNGQrVk9GS2ttMzVKVUQ0L05Wek5KeEVEWnpWTFNKMlIwZERVTktZaXI2?=
 =?utf-8?B?RlZsK1FuYU41WEFwZ3ZCMWFlSkpvZkJOVHI0QUFxLzY4OUt1ekpkc3g2MldW?=
 =?utf-8?B?M01nNWlLYjJQb2g4MXowdmRyL0NZWU5tQ0hXcHZSSTB6TGhzVlE5R3FKdXdZ?=
 =?utf-8?B?bDE1a0Q5SDJGeWJaTEZzWjJGVFc0ODhUMWdWMk9weFNUbG84ZnJnZXlBOWty?=
 =?utf-8?B?czkxS2lTUnV4R3Y2THFObVlhU2ZBSHpaWWFpQngzK2xnQWRjSEpZUERmUUwz?=
 =?utf-8?B?Vk9QNHo4eTZjZWxXMWk0Y3dTcGlZN3lEQmcrSG9sWG1DcFBhM1h4Wkg3c3dB?=
 =?utf-8?B?bUFxYkhycUNQSUhEaXdXMG0vU1I4dmhQN2NuU3Bpb0ptVHliUldXU2YrNzVP?=
 =?utf-8?B?bXVMb01yWENuYXNKZU45WnBNckNQemhrWDFHaHVQcU1iaEpDalM1MjBwd3NZ?=
 =?utf-8?B?WFZ3dS9pQm1iRkZuUzhadDhyRFYybjk0YzJ5clBaSmhpRklBN3QvUmlXYTJs?=
 =?utf-8?B?YXprTU4rSS9XY2RjWExhSFFwWEYyU2hGTi80S3BvZEwya2RUVGlYZWtxL0JY?=
 =?utf-8?B?ZVVnTUl6ZTlwNm1JQ1VkUXlTcC9WRFRZUFQxZldsV09BdGhRdlJVZklnbk5W?=
 =?utf-8?B?bjU3alV5Ym16SkVNbU0xRDNWZ2hEWGZFazlnZURSUFAwSjhlWkU0YzdTc3Q0?=
 =?utf-8?B?emVBdlFQRm9xdmtsUERRWWJGbUNCMzA0Qlpla21aSnEyd0pvYUVBbnBscVZ6?=
 =?utf-8?B?NzNnSXFhSTlHWkVNbU5OSU9NVjk3ZkhTSitnVFNaQmFHSXdVdWRiUnpxaFZl?=
 =?utf-8?B?V3dnUzhoOGNFVEZGZHlwVDNuVTFPMXpUeFNlcTRRaDZ1aFJSSGpXRk1GWmxa?=
 =?utf-8?B?NkVTNEYzLzBsRHF3cnJnWVdpM2E0QjdPZ3lGTHo4cmxtZkJsYlZWaE9IY0dt?=
 =?utf-8?B?dzBjUWNZWmErdzFqMFpHd2laZEJiZ1VmM0xMTWh5UC8xdnI0YzRnb3RQMzF5?=
 =?utf-8?B?aWM5eC9UY0xjSVVab1lpZXQxN3Ryd0VaSUFXTis2cTRPR296YXczZ2JLYVpU?=
 =?utf-8?B?K0VtKzhCK1dsdkV0Tjk5T3NyQjlEMnhLekJSWVRtUko1anJFbGVPNWd2WGpI?=
 =?utf-8?B?aU1xSFhoQ0poTHZwS0ZONGpCdHE3bkprQVBLMDl3Z1htRUlXcUExMEZYQzBu?=
 =?utf-8?B?TUhjZmQ4SWlKZzZLOW9yWUQyNkRPc0tGMTF1TmFLUzlpbE55dDRsQ3g5VXRO?=
 =?utf-8?Q?SevsLNMBBi374khhEA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d5350c-5a0f-4a31-867c-08df0fadba48
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 02:38:13.9994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Adxu4jC0foXnGZsPBWqlSQvynuxMmyr0lzpYEO74PXTcnxGPLZSIx/d6M6vRim0K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5774
X-Rspam-User: 
X-Rspamd-Queue-Id: CF7A440003
X-Stat-Signature: b56jfdm5qp4f9n6481s4empskkfpb99w
X-Rspamd-Server: rspam01
X-HE-Tag: 1789094304-948016
X-HE-Meta: U2FsdGVkX18efFLbQqWBBwP9+hKCjln8PtMIkNTLplX41TsVFuj8OMymlgBqvnUg5w5nVg8rnWP5AAr0aXZfXXEAYupyLwZlw4QT+OTL+4olM6Fkyj2YWPgzOz1MrhM9w/ygTKKbdtQSzSi4Ik6KOYEbCAPWzSxAJgQYyNnxRYa0v68mvLNv+wIEQ3QS7EKzTs5eaX3WZhxx54TdntsT2H13CFM63PlUMxixYs8tH0Xy2eLGAVgI/lh3O+j4EzRm/jscvnB0/4O+ITpWq37HoHi3SSaK7XEkU0T8phq2GDz/DBu4MqJ26rus9nJq4XmaEm3mUPoLFskHkcSqZAiG/M51Zg7aGQM6Mrk4GwkaxcsgaN3o2THgwlird4UE2xz+Ifad1FUf7xSkIgM1Dit8k7Ax/KBxGcqg5J7S94IjIHHk+zS0H+0Kl9LmTdlOB9+YjFwIGYQoTVaVsPGrTiKszR3AYVraoBNenWmVael2GfeClOf82EmucvGD95M7JD+PEaa352vCc4fY0vqaMutQ0quR1a8qyqcp+YrucLf6uOYsXIq7zDGJ7ab5HszQ0djjhnPG6r9Q8jZOLJ6agE1Jpo9M54tEP8HbT5yjBzAScVNe2BLxqxlLZC8+z8GIP3RZ5iukpZ17H3wywa2pfGzzIj6YY3TBHhSN+LN438qs/RdbXV/exVCcy214Q1axk5dQL4KT0AEZyi1VTLcbanLwikqkorVQZQS7P4nbbRX5+To1Er0tbxE91Jy+bggY0nF3f+ieAIqob+u1nOF3D49gFcORwzVY8193Rxffp9mMkPw4XBshMXVTywFzCRTMfPmD9rA/I58UR4Q7Bl37JrGFni3LenKSHvliZFIYgH4BcC+gY7rfjpVIEGW+g93utQaw929KEvcG/k2TSEP5oyQJeL2V1dQJZp3Z1EedtyRCVEpDUxoJDDMgfjuM/SC2zoHPh618gvSNB1+sgpGQ/uy
 UlegdHED
 8ZXxGNbStOZ28/O2ThEIGkXHDmAAinv3kRp90S+ISFnzOClBN7n2L4GWCreCEOFFO2kQojFecAakFay89UJWY4NkfjLDnZdFGHIHFeiwkshanIPev7eFFKkb1eY4osA6zNocVcVQ8YYDpVHLKfos6LHkstn300OoFtcay3nKMhdKvClx3GHQa+jLNskdXeEL+SQ/VQU6W2oo9AnQtJ4HANGXXuRgiVOz/Gcrud6vqS3ENRMBmrjvrv+F+JHYfE7Aath38QV3Kz6g9VKL20AUC8wXG+FVPZ5dbNozCv/tiLGKtwZAUeAVe6JIpsYvbyigWoifCNm97yfSYEtQ2FjiRTF1O9qvoETBr0FuYlxMnDnIRl2ie4xBlb3mD1xucbNG+Cln1a7WMdkpDWSN/URGFThSwxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 10, 2026 at 8:02 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> A collapse is two jobs.  One reads a PTE table under mmap_lock and decide=
s
> whether the range is worth collapsing.  The other allocates, isolates,
> copies and flushes, and wants the lock given up first.
>
> collapse_single_pmd() did both, so the boundary between them was somewher=
e
> in the middle of a function.
>
> Give each half its own function:
>
>   - collapse_scan_pmd() scans one table and only reads.  The anonymous
>     scan that used to carry that name keeps its body as
>     collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entry
>     that picks the anonymous or the file side.
>
>   - collapse_run_pmd() does the collapse the scan asked for.
>     SCAN_SUCCEED from the scan means there is something to run; anything
>     else is why there is not.
>
> collapse_single_pmd() is now the two of them with the mmap_lock drop in
> between, so its callers see what they saw before.
>
> What the scan found and the run needs travels in collapse_control.  For
> an anonymous table that is the orders and the referenced and swapped-out
> counts.  For a file it is the file itself, the offset in it, and whether
> the PMD folio is already in the page cache.
>
> The file side moves with the anonymous one.  collapse_scan_file() used to
> run with mmap_lock already given up, and called collapse_file() itself
> when the page cache looked worth it.  It now runs under the lock like the
> anonymous scan and only judges; the run does the collapse.  A file
> collapse works on the page cache and never sees a VMA, so the scan takes
> the file reference while it still has one and the run gives it back.
>
> That changes what a refused file table costs khugepaged.  Every file
> table it scanned used to end its pass over that mm, because the lock had
> been dropped to scan it; now only a table it goes on to collapse does.
>
> Two things on the file side stop being rescanned.  When the page cache
> already holds the PMD folio, the scan says so and the run goes straight
> to retracting the PTE table.  A run that refuses dirty pages and may
> write them back retries collapse_file() alone.  The checks the scan makes
> ahead of it are ones collapse_file() repeats under the page cache lock.
>
> Tracing changes with it.  mm_khugepaged_scan_pmd and
> mm_khugepaged_scan_file used to fire after the collapse, so for an
> accepted table their status field carried what the collapse made of it.
> They now fire before it and read SCAN_SUCCEED for an accepted table.  Wha=
t
> the collapse then made of it is for mm_collapse_huge_page and
> mm_khugepaged_collapse_file to report.
>
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/collapse.h   |  16 ++++++
>  mm/khugepaged.c | 147 ++++++++++++++++++++++++++++++++++++------------
>  2 files changed, 128 insertions(+), 35 deletions(-)
>
> diff --git a/mm/collapse.h b/mm/collapse.h
> index 7044dc71c7c2..346859a2184f 100644
> --- a/mm/collapse.h
> +++ b/mm/collapse.h
> @@ -88,6 +88,22 @@ struct collapse_control {
> =20
>  	/* Each bit marks a PTE the scan accepted as a collapse source */
>  	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
> +
> +	/*
> +	 * What a scan found and the run after it needs.  Live only between the
> +	 * two, and read by nobody else.
> +	 *
> +	 * The file side takes a reference while it still has the VMA, since a
> +	 * file collapse works on the page cache and never sees one; the run is
> +	 * what gives it back.  A scan that found the PMD folio already in the
> +	 * cache leaves only the PTE table to retract.
> +	 */
> +	unsigned long scan_orders;
> +	int scan_referenced;
> +	int scan_unmapped;
> +	struct file *scan_file;
> +	pgoff_t scan_pgoff;
> +	bool scan_retract_only;

scan_retract_pte_only ?

>  };
> =20

<snip>
> =20
> -/*
> - * Try to collapse a single PMD starting at a PMD aligned addr, and retu=
rn
> - * the results.
> - */
> -static enum scan_result collapse_single_pmd(unsigned long addr,
> -		struct vm_area_struct *vma, bool *lock_dropped,
> -		struct collapse_control *cc)
> +static void collapse_control_init(struct collapse_control *cc)
> +{
> +	cc->progress =3D 0;
> +	cc->scan_file =3D NULL;
> +}
> +
> +static void collapse_control_release(struct collapse_control *cc)
> +{
> +	/* A scan that took a file reference should have been run */
> +	if (WARN_ON_ONCE(cc->scan_file)) {
> +		fput(cc->scan_file);
> +		cc->scan_file =3D NULL;
> +	}
> +}
> +
> +static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
> +		unsigned long addr, struct collapse_control *cc)
>  {
> -	struct mm_struct *mm =3D vma->vm_mm;
> -	bool triggered_wb =3D false;
>  	enum scan_result result;
> -	struct file *file;
>  	pgoff_t pgoff;
> =20
> -	mmap_assert_locked(mm);
> +	mmap_assert_locked(vma->vm_mm);
> +	/* Whatever the last scan found has to have been run by now */
> +	if (WARN_ON_ONCE(cc->scan_file)) {
> +		fput(cc->scan_file);
> +		cc->scan_file =3D NULL;
> +	}

scan_file should be set to NULL by collapse_control_init(). Anyway, the
code is duplicated here and in collapse_control_release(), maybe add a
helper.

> =20
>  	if (vma_is_anonymous(vma))
> -		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
> +		return collapse_scan_anon_pmd(vma, addr, cc);
> =20
> -	file =3D get_file(vma->vm_file);
>  	pgoff =3D linear_page_index(vma, addr);
> +	result =3D collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc=
);
> +	switch (result) {
> +	case SCAN_SUCCEED:
> +		cc->scan_retract_only =3D false;
> +		break;
> +	case SCAN_PTE_MAPPED_HUGEPAGE:
> +		/*
> +		 * The page cache already holds the PMD folio; what is left is
> +		 * to retract the PTE table, which is the run's job.
> +		 */
> +		cc->scan_retract_only =3D true;
> +		result =3D SCAN_SUCCEED;

<snip>

> +
> +	if (cc->scan_retract_only) {
> +		result =3D SCAN_PTE_MAPPED_HUGEPAGE;
> +		goto retract;
> +	}

<snip>

> +retract:
>  	fput(file);
> =20
> +	/*
> +	 * A PMD folio is in the page cache, whether the collapse just put it
> +	 * there or found it: retract the PTE table, and map the PMD if asked.
> +	 */
>  	if (result =3D=3D SCAN_PTE_MAPPED_HUGEPAGE) {
>  		mmap_read_lock(mm);
>  		if (collapse_test_exit_or_disable(mm))

result is changed from SCAN_PTE_MAPPED_HUGEPAGE to SCAN_SUCCEED to
SCAN_PTE_MAPPED_HUGEPAGE to get here. Is there a way of avoiding this
result churn?


> @@ -2805,6 +2857,28 @@ static enum scan_result collapse_single_pmd(unsign=
ed long addr,
>  	return result;
>  }
> =20
> +/*
> + * Try to collapse a single PMD starting at a PMD aligned addr, and retu=
rn
> + * the results.
> + */
> +static enum scan_result collapse_single_pmd(unsigned long addr,
> +		struct vm_area_struct *vma, bool *lock_dropped,
> +		struct collapse_control *cc)
> +{
> +	struct mm_struct *mm =3D vma->vm_mm;
> +	enum scan_result result;
> +
> +	result =3D collapse_scan_pmd(vma, addr, cc);
> +	if (result !=3D SCAN_SUCCEED)
> +		return result;

Can it be changed to?

if (result !=3D SCAN_SUCCEED && result !=3D SCAN_PTE_MAPPED_HUGEPAGE)
	return result;


--=20
Best Regards,
Yan, Zi


