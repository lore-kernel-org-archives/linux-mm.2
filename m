Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD4FC55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 02:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7246B00B0; Wed,  5 Aug 2026 22:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AE236B00B1; Wed,  5 Aug 2026 22:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F696B00B2; Wed,  5 Aug 2026 22:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20F466B00B0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 22:36:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C22D4062E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:36:24 +0000 (UTC)
X-FDA: 85069280688.17.EF8B2E5
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010045.outbound.protection.outlook.com [52.101.61.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 51BF820003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:36:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dEdF8jhs;
	spf=pass (imf31.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.61.45 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785983781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ia8+ulcsOo5AWIssIMwNfKklN54C9RaJPVzheATMTXk=;
	b=SyuToOxLdJaXqPujZcTnnYhx/bWPtzOzhG2YqCKq5mdPJ3+xglAEMCqeVo2CFUKGK1EKn+
	P2QJ/qaCqkaKFCBdypFZ6uvRXe9/ZGzmLr2BvwldAEwsWk0vxIR8BKMBNks6ORDB3qIj8W
	JYc+dlpnf14fYGFeS18VMGsoaP1gw8M=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785983781;
	b=kHp0sLI6kXDWweRXDfrTwFh1R4D9YMCardyVlE4qaGQBSULdFBHWfVA4djyVE+ELAeN+DB
	o5HzdJsi02Pt36yx4MEvcl8JSJfrEjJoCFM/Cq78PO1PiBtYjybL+ckyvxz/rrA9cRRCPJ
	arqL+/dkj+Dot4cSb0ocZHcM7FB4swI=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dEdF8jhs;
	spf=pass (imf31.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.61.45 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qcqFpgyc2KGVVEyezv+DpcQboRUzCEKgBVM01fR4/SP1hfuNNDmzGgSVGX/UpAGaTZJj3OkSimVIdWwbPaGSHpF12wcggecpsKuwT7EN11UTTbN1CwCCXmBoClnzJy1W/wbhZI9G1fXc/x8dGeBheMPzFqCLJ/DARwREgS+er8l/kwLf86Wp+IZeJbNtPQ2hHylazmlmzmzlshQCGG0PH2Du62jqmZ9OZVLPdThwU3aw/McQmW4itjF65Zj15j6xSHy2w+CxmacySy0CnG394Vnrn+JXOhaBINgPaHmqztHpmyWWpIhrQhXTruVx8EYFYz22L72fvlw3+AFQOmpoYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ia8+ulcsOo5AWIssIMwNfKklN54C9RaJPVzheATMTXk=;
 b=bNxZbPJP9yc+W+6sR6Z9t4IkDuU7oXkZOIGW4mu4VsuYpj/tNmomNMhl3FQIKIu0jxz4hy0ZU6uvFgATOacB29Mq5vo5vsm7gTTUW0VQeQHo9Ef7Nj+Cwu5b1/Umt4cKFA5l7eN6wyoUNpAMyP+8zZQ7PW+81OZZfrvoh5qj6XC0HUJAnH9s3nN5EO8ZFyyImAVQycBQq2I1blWJMbO8AW83uE6Nk7lXEVrg9B87cEsjFZez6rH23lRD/YRrhqZdkEnO12PUMkbqf4Oo/nN/C2IWIHCWTUtsciuEkbPRZOg7h3sJogupE67/TwfckiRy5YQj1V43yeRuKA9AJV30pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ia8+ulcsOo5AWIssIMwNfKklN54C9RaJPVzheATMTXk=;
 b=dEdF8jhstX4UH6fM/ELzC7Vk9ivDbL70NkM+7qHnFSWX6CiUI8b1lLa2DbtYYJvzFTQgvBaS2+W7NbvG1zss5ZqgbxuuozqMpKVzOK2wE7Jiv26Bu9KhwS8aWw1JxxmzuLuIS02OQnV1F5VPHxiSn6r3jnBoABhkFTIzYW/XBoRHXuBtdxehyvu0y/lv0ztlRSDlG6aoEwlQQd0jO0P2x+rfGixIQY/iO2xzdF/jlOPO/HrftY7tPH05qM8FFXKKkI0dhsiG85mMw4sCFxUum9dxscRGoGdzp0YGWvTELHok+0c/INalE4Z1KTc+0x6U71tNHiRONJqN0SlyN3dqEw==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.16; Thu, 6 Aug 2026 02:36:16 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0292.019; Thu, 6 Aug 2026
 02:36:15 +0000
Message-ID: <0fc85206-ce9f-4ac4-81cc-abe127ebb92f@nvidia.com>
Date: Wed, 5 Aug 2026 19:36:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: debug_page_alloc: fix NULL buf in
 debug_guardpage_minorder_setup
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260806004556.2633049-1-ye.liu@linux.dev>
 <0159349a-41f2-467c-b91a-3775e56a660f@nvidia.com>
 <6ae9914b-7254-4a1e-8345-597d3c2d7ea2@linux.dev>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <6ae9914b-7254-4a1e-8345-597d3c2d7ea2@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0146.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::31) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|SA0PR12MB4446:EE_
X-MS-Office365-Filtering-Correlation-Id: e5f6af9b-9c78-441f-dfad-08def3637cd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7YxsoqZZ2YH1V2u286b5eFDAJKNoZwhpCNwTWIAwlHM56vSa37+UBTiepQIpNRznB3OfXOto2VSkifbwD4FepNROZXefobje2+PRWKkx90PzmFE+bt42gOvXCivhipIFWa/cNSmlx5/WGNF8/JGT1dEfEc53YVwgfxjitJH1vWClUjU5K9Jkrv2a4itPRBS8RmYyBxlSM0M4rvm1kNORadZ7WTLRHT1L51SH9L/QIX5XEUdo87KlGn4G2LAV1W57X2byfUAXoOTBe/Xevxod+nSq4IXZcj5WXj1NF0NR6n7KHeiu97MlOcTnJISdv69AiA/ZlX3D/OEu5Ve7JpZEVNzAiAEDVVhWqB7ADcPTZGnS/+YsxaSCc7JiaUacbxLnx9FhCNnfLOZALom/fN7VwgO63A0xSY8OZAF3AAGAHvppRrHpOW2WKoikCoxqtH54QatZtG9490GNLwTQGoIfriFAJR95GTv4rppkbNZKmR3rJBjd59WfafYd0xsFatSR13hhMiXdi6qz0QD2Zaw/mPsi5nVLAQzWNqxFgZFVvXxXXkkO6qnw18n00j27KVm+76pbUgOgBGYaG6FZwiQB3AKxJu7qeI/BP/l6+Vn4PvlCnHmS4xn4ssCxJIxwoDSs8hKwPJhCUxUpts9tiRTgnIMuHdBb+Q9A6Kw+TITt9QM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGQ4UlJ5ZHNxbjY3Ky9xSVo4RmtwcUNzMkFJcmVlMHZTdWpES093QTNQRXJo?=
 =?utf-8?B?UUE5VEtuU0RVYWpNak1FbHdDNTJsckR2UWc3ejlVNDFndTU4b25yV2lHM0tJ?=
 =?utf-8?B?WGtHc0hUNFpqM0swTTZDa1QyZHltQXEwSzBVdFhwMjJURmphRE5oVE5aY0Fw?=
 =?utf-8?B?YkdMb011T25rdmNFVXphaFFiQzgybnFwbXdzbTJxTXNVbklENmMydUtWN0s2?=
 =?utf-8?B?RHJjV3dRTGxFQnhIaTY4dXl2elpGWHBtb0g1Tm9DcWxCenVnMDNnNFQxOGRP?=
 =?utf-8?B?WkNvdzAwbnBodUE2OEZJWFRmK2srdlhUWFZEamtSdXBtMVZVOC93MEFsd1li?=
 =?utf-8?B?WHh1U2k1b2M0OTVVWnJqektrdDgxMEtMUHVidkhGTGtmcURFcE1McHl1MDMr?=
 =?utf-8?B?RlRac1Zna2hkMkpqRVVlZDJZQ1llNmwrS3NmSGFEVDU1L1NTMlFwNWYyTGpo?=
 =?utf-8?B?ck1IazVZTUppSVk5OUhjMGlXVm9vSzM1RUVYM1ZqQzJkT3VXdDBJYXdyU1J6?=
 =?utf-8?B?ZlJGVDhWTEU2M3Q0VXJnQXA4eE1nQ2lURy9INUxsSEdZNFFuSmRDbXc5OXZS?=
 =?utf-8?B?bGxuTkEvaS82WW4wUEQ4QUkwWll6TEVIVkRiRFpvU1ArZTl2SWJuNnozYkYz?=
 =?utf-8?B?OHVjbzJJbkNRMmFKQzZDbWVNdytjN2NseUExSjl4L0NKYTNnMzcxYWZJOGRj?=
 =?utf-8?B?Z2dHRHArVm9Sc1krbmF6a0R4NStxNEcwd2VGcFFucUlKQk5LVXovVnFHcXk1?=
 =?utf-8?B?T1RleDh5Mm5RN0k4VWpGWHhtdVdIWWhjVWNISGs4b0VnQmhpVUFnc0h4Z0Jo?=
 =?utf-8?B?Q1dBLzNRZHFoT3VkcTExZndPNVJ6UFU4M3BBWHNMUkJTVFNLblF5Tks1Ukdz?=
 =?utf-8?B?VXVwTzMvZWNWNTJXRG5aR1RPT0prMktuVUdVRFRjV3JUN0RRMk1LbkQ2NEVm?=
 =?utf-8?B?Wkc2Y1h3V1FlYmlxZ0tXalJUV2Y3dW1GL1lBRFF2YitaK2V1NFBTV3ltdGtp?=
 =?utf-8?B?YzdsWFpjRDVNeUh4b282NVBqWTVDYmdCSHo2ek0yMUtRRlVYMml5OE5CaDdl?=
 =?utf-8?B?cm5KVldMVjNWc2VmQU55dlVmVVVnRGhtcDZEeFJiT1NoUTZwZnJrYm1FSUtI?=
 =?utf-8?B?Y2hCc3VmTEJvL3pDOHkrdzdVNXlGQTBFVHNzeHZ3c2E1QXAzcWxLUFV2VDRj?=
 =?utf-8?B?aHdXd05mMlFNZ01MSlNIOUZ4N3JxaHpjSi9OVi9NZFNSWXVwY0UvT0tDK1Jq?=
 =?utf-8?B?UzlFMHEwR29ZT0M1bjNsNEszVDhMRU16WlJpeUY2RE1EZG1EK1QycEFNK1V3?=
 =?utf-8?B?cEJIKzUrQXl6WFNUL1lscUo1RFpBcGtVZUZHeGtuR3JkNTBNbC9nYVR2dUV2?=
 =?utf-8?B?Wm54NlJTOUdMMGFEd2pyVGl3bXE2VGs0SFdsU1EyWVpXbGRRMzV3US9OaTFG?=
 =?utf-8?B?Smhwcmt3RHBNall6K01VaXN4UVRIMmp3a3dnbUQ5b2JFdEFsMnRoTzV1VW5O?=
 =?utf-8?B?d0YzNGNiTWdlZGlIZnhLNVNtNnp6NlVYbjBKa1k2ZG0vVFhjS3ZQZmx0Y0dP?=
 =?utf-8?B?Q05STmRuZHdiVEd3U0IyT3g5TjZlQ3g3RWVudjcwQWlHN0ovdEYvdUJ0THVT?=
 =?utf-8?B?Z0NiQm52cHRHSGxMTXJOYzJjVUxmZVRxYmFuKzVOTlNCUXJqS2lnbU9jQXFI?=
 =?utf-8?B?SXN1ZlBELzRPcVRDMVFON2lmb1g1bE11SUFtNTlZdVV5akdKaFJUTGt0ZjBu?=
 =?utf-8?B?dnJkUGZTQ1ZmYmZZUWVKeWVsNG5SSWVxdThEcnJqcEM2RFM4SURrOFhEb09z?=
 =?utf-8?B?RVU5L0pLN1RBRUI3WkdpTk5GWjdBUmt3YkpKVkRRbkJvcjJ6a0xvU0VEcFdR?=
 =?utf-8?B?eDFPKzQ4dms5Q2VhcVhZMmxuWUcvMTNyemJ4clRzZk83eGYxczluaUhGaXEv?=
 =?utf-8?B?RkpsM2FYYktTbVo0SnZOeTJiaHRpTk92WWJqelZIaWFKci94UjE1S3RIUUZQ?=
 =?utf-8?B?YXIyUmE2Mzh5WXk0akpVVnh3dlFtRlFNRzlqSWZSZDNXVEcrcUI5bWZHUncx?=
 =?utf-8?B?MkllNW13UFlDM1hxR3lkRlJYeS95WFc2Q2NMdGptOEp1RXBkMXB4WjBvRGl6?=
 =?utf-8?B?N2dhb3ZuQSt0ZW4vRkpVOCtNUmd2UTdYQktFK2ZEL0dIMEdHKytycUNOUnZB?=
 =?utf-8?B?S2V5QmdGaHg2VnVKYUxxVjc0b0w3L3BCM1pVTUVaK1lRU1B1YWRVUzlvOVlL?=
 =?utf-8?B?WDNrV2dHM2FKbXpXRGRzYVVZU2g1TjFDRE5zc2hJSHZ3ZEJGN1k1NXhIR2lu?=
 =?utf-8?B?WjdCQkxYRlFjcFc0Y0ZhaWVKRWVCSThVcnQvM2pkc25QNXBrV050UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f6af9b-9c78-441f-dfad-08def3637cd6
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 02:36:15.6870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xs20LHMO/L1t/xSorTPKP2fiKYin8V0f8bd310Adym3+WVBivPDRiJOPn96JiuzqFlZgdlS+2op22mWCSm+xZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 51BF820003
X-Stat-Signature: insewjffteo1u9qx6ci8iwd6pa7f8z3y
X-HE-Tag: 1785983781-323645
X-HE-Meta: U2FsdGVkX1/vUhpXdCTialyOrqmM3MVzrsKLT/svIUqCvqafWTrZBG32NCzCv7m8WInoA2WyDh379Bg9MXf2+MPARdJ9D2sE+8ttMjhgvkFw2e2KM+4TXcvjUIOB1GCPiGqzGYzRflTqrP0EjEwLcWpTBj2sQED/ELG82c0ceMIMPDrmUysWU1QR0O6TCXPNkYoXEOR05IOkBtvkdmqU2c4EBgR/dX2NwWZs6lJIf4PM77Uv7otWS5D9Z+V9iE6gte3X1oFU2s4MC/TPJDDQvCuT9NAo11/WubZZWZKgdG7VO+zuJy7OLGEQ5cOPx9WP9On2mIlOBmJqZF5eWOyEGzNcttGNiGRVashgcvlW+naWuNu8YvZIttCzg9M9wbn4GT88+ffTvk1RiqCCkZObGYQ6P/TrwFgicteUilFVpg7Zfq8ENIetb/7sbmTS3p2du7jerGM8mkEbGjVuCrxKcd3uw9Qiv3AZD7HL15OZYw4adVdeFwqjEEzcgcj7xFfmHDwAyShT1MJMmZSyqdlN2JwIWYcYUzsfpPIATwS+WodtvPS2MVi2L70pZkbl1FO/8BBX9cKjdeSRV8jW+cVQQ21dh61v+/VjOzMTm6J7XrRqQumyvj9cGbBhOXjStoQxu9yYcveVpEtYA6gJNNWH66PX0C36r3xmbPBIS6Cs2OVwi1nu67bTwDGGb7BCiv1+SvBxusc8POPHSyaE6RAgj8cqsnwkLt0i9RjiBUV/c6kTsFEeanDsfmDR/mGdnUANRo5adqWI5xTiFPPVCfbEiV3VVWq9n1KIMD6Ek8BGacInz/VcTBdfwT5fXOY1SHtLfFD65TQaZBYlKGQE4yf4b8N4Nicced1TeWkK+zP74cgUY/YWeo3G8advFCfyhyPMcDVOyfwZrn1rGYbJ0B44N2ZinsgudBxnXuaQL+oNgyDftcdX2b9x2BJysvcveR5sqANjrKg20vn2a7PBWDu
 2K8CCAFx
 NNoyVY3HMKSj/zYfuhuG3m2rbna4YdlQ+FEKqcIxt9I4soXhUs8SCleDrZivHySB6KfEqkwk9Jz41Ar4rUNDbhuvUlgq+Et1tP4PqWuc7ze+tj6YZDpBTjcSV31EjmguIZPQpZX9iPeL7oQ1rG1kTwG4gQrumLOxFuMneAPtuNub3HIeVyIBYJtzBnzExHdCkTb2cztIKVJfgR2tYVzFv7fMwg9gy2/pa1kw3BIt4KV2cW+XmeWRsNrJPOLBPzo/BDyrW+V5dc35wbAR8haFdgX5gIxtBAe5pjp2op5UweAHpzSXfyNnaqTmaTTIiCB2WxVbqUTkk9geXRLiNWt82aNhC++iUrH3ivKv/E+5AtDXtXan/NdLPW9cvyzhG1OaZVrgvhieZGl7iTmk35tR0DiSjfXspn0QizmVEseMJon4hXk53x0IsTChkpI4qXbETYXLT5LK155386C30EY66RxXZsydpwDEniqauvA9d4yaUSJmc768mZ1KBBhiWgsBJQjQh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 6:56 PM, Ye Liu wrote:
> 
> 
> 在 2026/8/6 09:08, John Hubbard 写道:
>> On 8/5/26 5:45 PM, Ye Liu wrote:
>>> From: Ye Liu <liuye@kylinos.cn>
>>>
>>> If the kernel command line includes "debug_guardpage_minorder" without
>>> an equals sign (i.e., no value is provided), the early parameter
>>> parser passes a NULL buf pointer to the setup function.
>>>
>>> kstrtouint() does not perform a NULL check on its input and calls
>>> directly into kstrtoull() which dereferences s[0] unconditionally,
>>> leading to a NULL pointer dereference and early boot crash.
>>>
>>> Additionally, the error path's pr_err("%s", buf) would also crash with
>>> a NULL format argument.
>>>
>>
>> Maybe a "Fixes:" tag is called for?
>>
> 
> Add the following Fixes. Thanks.
> 
> Fixes: c0a32fc5a2e4 ("mm: more intensive memory corruption debugging")
> 

Looks good,

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
-- 
John Hubbard

>>
>>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>>> ---
>>>  mm/debug_page_alloc.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/debug_page_alloc.c b/mm/debug_page_alloc.c
>>> index 41e3d1f1ad96..fd2664c3c86a 100644
>>> --- a/mm/debug_page_alloc.c
>>> +++ b/mm/debug_page_alloc.c
>>> @@ -22,8 +22,8 @@ static int __init debug_guardpage_minorder_setup(char *buf)
>>>  {
>>>  	unsigned int res;
>>>  
>>> -	if (kstrtouint(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
>>> -		pr_err("Bad debug_guardpage_minorder value: %s\n", buf);
>>> +	if (!buf || kstrtouint(buf, 10, &res) < 0 || res > MAX_PAGE_ORDER / 2) {
>>> +		pr_err("Bad debug_guardpage_minorder value: %s\n", buf ?: "(missing)");
>>>  		return 0;
>>>  	}
>>>  	_debug_guardpage_minorder = res;
>>
>> thanks,
> 




