Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C17F1CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7396B0096; Thu, 15 Oct 2026 14:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567B06B0098; Thu, 15 Oct 2026 14:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408A56B0099; Thu, 15 Oct 2026 14:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1140B6B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:13:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9055C120557
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:36 +0000 (UTC)
X-FDA: 85325658432.02.0394E95
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by imf28.hostedemail.com (Postfix) with ESMTP id AF45FC0006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UTDH38sz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RPmnAaQPjZe+jzEtzDeDLZQt7rc6Dj+85hXtD5gVDo=;
	b=kH2bj+KWh11d145/d4h10jY9lXrw1+qAmfnqvyM/xRbCbX9UqTQfxHzTDW3INKQ+c31VUG
	IYvYKJIqlCMLsUBsO0RJHkv2EqMTcR3T0xZBdvjE8bAtXDEZadING2k4kFJx4T5QT41Meh
	G1MKIRPm+HtVvPpEoqnlsaq+5gfD7bY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UTDH38sz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792088013;
	b=hFxWElBSXBeS/76NXIMbKka26YQdDzRanKwN2snMu9cW47ICsldH3BYVigJ29zIM3LizT6
	htQ8AbO3vbpdAi24rQ0Lsec1kbL5oFOw12hUhYQegOWVeHjJyClWggq11Oiu2X/zS42T2+
	X+o0qKK21ZAiQhQGYXo6gRPm5lS1mCw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ANNLSsak0rGMHr7LK/HNh03H/TrD2iAzZAqbrsyNrntyqUWOs29LXHVpdqN9Q71zvnrmJ0/T690TMxSl2Nizr8Cd1TiAnO5L533JH5nD+snCY5uGhq93YrTjC/F9IEQTEkYtv48HIxnEt1/BkgCrzeSRqLmNWgk+wgpENlootrEFl0fea0kPBkliELy6eB9bFpdMdNz3dwSOv2Xpa9rY1yRRzZxSNcy9D+bqlcVv/W9xSC8muwbZGqVkwjkCOXfP448w40xKnd6dk+oaaETOFDGljtrROoSzqriucMStKIiNyacfEmXpTrprfJDQbPtpCO29Kg+azQ+fbP59NXerpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3RPmnAaQPjZe+jzEtzDeDLZQt7rc6Dj+85hXtD5gVDo=;
 b=Zq1fYgSpbOoR6agCQSf5HlyhOGtjlZkjV1EYY0DqRtobNsxlvVNDEna7JpPclV/rOiouUsEgM8TGb3tRSGeBFgc0QFqDLwPB0JAs0r/KRaEvBeSiOl/p3cOfMj7Dnfqq3JL3LJoI/SQOloGi5wjK+kTFxNNQ5mYkHnQdKD3ZIQmcTZ1g75/aMu+i0KYr0nbzphcj9tqcI1dTvqNow5gvUxKUSTXN0ketIPHrlu2KjI8koTsK87/X3B7tzOWETy6Cpuv2lWkDHdt40N20o32zsgcxWS5CXolRTgRizQTO3zA80WqdzlWXJQ9SUeRdkdhdcSPR4EtQuYNsDsPsSNzDyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RPmnAaQPjZe+jzEtzDeDLZQt7rc6Dj+85hXtD5gVDo=;
 b=UTDH38szc/WAFXA6AriE4OqJA1GEqJBcFVufB+A81EBvCt4drfBMip0ZYxBuHlHqi27968PRd3NmHR/sIhhYfHi2e8HNtZGYGh61uL1FNg0Mw9bQ2QEjKaCedY7gWzpcsMWaX8Q54KKfDjn/hOw0esLTzaEOM+wSEUsOJ6p6fCLQ5ki3VsfQAEXDKGTN93r/Y4mjxCqeAtP220LmoSS8afNQXTQ40MLY/X5SOUdIJKXIRmIRIsC2y1YQyM2zOzvogX2fJgwUsxBa1vkDoIv4jUyRu7rDzQejPJRV6bTjQd32Rc1+E2l6444XTiMm7HMUZShRlFpdjlharjJYYCmfwQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB9058.namprd12.prod.outlook.com (2603:10b6:8:c6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 18:13:19 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 15 Oct 2026
 18:13:19 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 15 Oct 2026 14:13:04 -0400
Subject: [PATCH for 7.4-rc2+ 4/7] s390/mm: always clear _SEGMENT_ENTRY_READ
 in pmdp_invalidate()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-anon_vma_uaf_fix-v1-4-7b977303b42b@nvidia.com>
References: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
In-Reply-To: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Kyle Zeng <kylebot@openai.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, linux-s390@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQBPR0101CA0188.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB9058:EE_
X-MS-Office365-Filtering-Correlation-Id: 9092811e-ae93-42e0-7098-08df2ae7fdf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|921020|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MDPTr7kna1Bf0y9OCBJ1usa5u4YO/bnVRDGpvKvZEMJN02uNNonYOf7kAdHwU4GSiGyJumitbEfLawNhIfB+1pS0Jc7Mh3toLqfK1G/6SUKJlJFL7IrmT0DNrNQMrYDEI8FD2jXtM4U8PmYnJCExpzaWDCajMALlXnKbTZH9FDhOsllCZt4fveFjKGy8uAgahATel/rja1viRYA2zLGJqIMftmv91g4RCSK9eyiY/m/LvwF88TJQXDzhYEBNrd8VHzOO+yajalmwldAYmzO+vlbas1LSeBo2OZLYCIpsPLQzgk6gbvUs1TcW97jwhF3F+i/1P2jgGO2ndulr1S1aXm/9XB9QSwsMqZeKxUp/+OgV9EhP9YR7rahJiWp5+Un7dNM5n3FiJmWFAMI0LQHY6P8gpO5byQHtDyS4WrwVKAA0HIMZC/JBW0l4dS246Y1W0JMdf4IbHfAx1BUBrGbKO517NW0fAOnq8pGSJtxwZsyzUwt989Fyrwy2xMoYUxLRkywzIoSRrFBYPfyunuIJ7SNt9D7U9IeUr87CXu+WGqHoS/61e8TfyNl4DLitAcRDBR6RY7mvbGMKtUUafgj+rsNvER/h3iBGt9QOzCsh6qKs0jRZkMD8PlPh1WVCKvt6HLAQOyQQwRXt+VJCDA3BaQBGWxwF1QNCvaeoCi4snUOb41zxGBcYMME1Ao1xdO1j4JjwgdlYcljM2yADePYYWg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(921020)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZXdDbUJXQnh2UzRRT0haYi9XN3NlQ3FtbjJxTnZSYStQOEZxbTJjZ2MwYzZX?=
 =?utf-8?B?RHdEdFd2STMxNUt0aHk3V0dmZjRNQzVIM3B1ZjZ0S1lXazJuODV3cHE3UFBY?=
 =?utf-8?B?TFJYUEw3L29GOGg1eTFkbVVFc2NkSjk5RnJWL3NPZ21XRWIzMDluaEpveVlY?=
 =?utf-8?B?eTNzelFMTGJRSHhqLzEvd0diRE9YS01Fc3lESjNuTWoyTmV4clR0Y1RCODN0?=
 =?utf-8?B?TlhJSzczaDQvSE1iUXVsTWE1TXhSK3ZkeDZ4d0NVa0hGZkY2LzhIUUx1UU1O?=
 =?utf-8?B?K0grYVF2N1hoZ3VqUUp2ZmJTUnMxTXVrdlFtWDBVa3hSNWxMNFZEdGlVdDF2?=
 =?utf-8?B?dzRjcndqS0lDVUk5QjlsYzdUUzVvM21ZU2hubUtBL0dTUFUvWTdqenM1cnRH?=
 =?utf-8?B?b0E3L1ptR3dodE5qQ2dNZzJyMmhkaGQ0U3FqZ2N5ZXRqZktacll0MnNQTWhF?=
 =?utf-8?B?cnlESXNtMmVaMnVEWGVFd3Ezd2phYUpVYUxrdGo3NnEzei9VcTQyZHJwK21D?=
 =?utf-8?B?ZGJUL3pxWGhqbUtlV2VERWpyWjJRM3VmcjFIb0l1cGZvbVI4bUczci9lUFRm?=
 =?utf-8?B?NjNFSTBxTlF6YUdYTXlmaFZxR1NwQXJqbXUwbkVtRVlkYURMcmR6djVBemR4?=
 =?utf-8?B?Rm1ZZDZ0bzYraFBXNWRHSlJxbVk5c1c1OEoxWms2SkdvN21QN2t6UFZQM3Uv?=
 =?utf-8?B?VjZqaFJYSTAvWFBWSXNxUTlFalpOVzRiNFFIYmFLTEJhUHdZVjNGYThYZjFl?=
 =?utf-8?B?QkY5YVpDdXJmd2lXM3ZGZG14bHNrckJLVGtZVUxzZlcwMVA1NVk2cUNrNUhq?=
 =?utf-8?B?bldJOWdaRFdNUUUySngrU3dxVzhUeG0vV2U3RDNrNU5MVHFKaXplUWhzM09S?=
 =?utf-8?B?VzFxQW5xY3FVZGNRdDFWMUpmeFJjVnM4UXZCNzhRZHVoV1JNYVZQNkhUbnB1?=
 =?utf-8?B?aVNBTnA2SGxMeWx2cjRycGhodmtKM2U1RnVwa0xSRnJtaGdpUndvdUc4SDhK?=
 =?utf-8?B?WGlLQzJRSVJPTy9YZktYYlVIMnhrblR3c0FpYkxNeG5VcjQ4UjhTQjJEV0s1?=
 =?utf-8?B?bzRoczBRYkRVRkRLMklPbXp4RDA3alRRcGJjUG5BbTM2a0wyWURISXBVZitQ?=
 =?utf-8?B?MnZGMlhsdjBOTkJEamRxZjBXYTIxYU1HMVFYUVVjK0gyNVY0YTNmU2FZTEVy?=
 =?utf-8?B?WTdPbnZxN2l4UFUxZndtQ2prRjZzSjhCOHB0REtmRjVOTTZBNng1TDlSTlFt?=
 =?utf-8?B?SXNYUmk3bTBFdzJSeUlqVXJUTXc4UlZTZDFRUzRMNjR5ejc0K3lKdjlNTGpB?=
 =?utf-8?B?RUVBQnlrTExzd3ZxM3Z0cmptZmdPUVcwVVRTRklVekpRa3A4Q0JQaXNsVXEy?=
 =?utf-8?B?WThjTXM4cXhSNEgrdzNBRXlnSFlSWTBCUmQva2pFU2pMamtES3BNQWcxK0o1?=
 =?utf-8?B?K2Z0SzVQekR2SnVhdEJGZk5yYjAwT0V4a2hwRzkzQUF2bUdmdWx5K2gvOVlr?=
 =?utf-8?B?N01DMGlGWGpyUmlCMVQxTzIyd3hZUGNQaW5ER09jMkhPR1FzUFJhT1J5d2Ir?=
 =?utf-8?B?aTJjTEFCQTZRQVZRaFN3WWdQeDc4OGo1eFlRY1IxRUNzcWJSOU50RkhQUEMz?=
 =?utf-8?B?Ykh5RDlhWWZSNTZjSHRtamlUNFQ4U2pEbGhNS0lwWk9Rb2ROS2RRWDEyRFZx?=
 =?utf-8?B?UzJVbDB3Z2x1TTVnRnFGWTRRTWJkdlF5UkRJdFMxYVc0c3drTUJrdHRqT0pp?=
 =?utf-8?B?aHVwUkh2bnQ0Y1hDdTBobW8wTkdnSmovaERWMXdNNnc3QnZETi84M0tmT3hF?=
 =?utf-8?B?RzNlK1l6TytFcmJUTWVITEN4TUNpQURTcDE4WW5NRDY3VUlMWWZFbTE4dHVW?=
 =?utf-8?B?N1E3eGttekhHQXVwc1pJS1hjTzBCcnQ2K3BKWG5ZS1NyWjZxblQrRjdoa2FX?=
 =?utf-8?B?V1N4ek1uRXE4UlpnOHRUTnU0UDluMXl5Nk5PTWtzc2JpYWcyRDBWMEEvWVl2?=
 =?utf-8?B?ejFoSk8zcDNhSzU5aDFWVkM2cFpjWitzc3FDeWdFejFIMlRpb1k1d0F6Y0JR?=
 =?utf-8?B?VWFZcmRZTWNvek9JN09KMlBJWG45MklTV2pSTGxTeXlCU0VLaGJyalRreTdN?=
 =?utf-8?B?NWMxbVFMOVZoNmZrSW1xZHZHWWVpYndSeEhHQXJrbkF1WlRuMm4vVFJ3NW5m?=
 =?utf-8?B?N2xaOEFQNEJUdElxNCtpL3p5UXBsZzNMbFhuY1UyTGFobitCYkhacm0rRFV6?=
 =?utf-8?B?anZpV3JIMFh1b3ZYVk4wOFRRNW00cGRXaVpWdFc2RUlQelB6cEZ6aEUrVjhU?=
 =?utf-8?Q?4NUdpe5aEVRBTULelY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9092811e-ae93-42e0-7098-08df2ae7fdf3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 18:13:19.7572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q4n/1BODQBbj7zM2cb4D6kT+oERxJ2h5S6nCpPRli4nPzS03VJ7r1xMZXpEs3b8k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9058
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AF45FC0006
X-Rspam-User: 
X-Stat-Signature: fmtnp9zf9kx38iwtaa4ddouxgosgsg6w
X-HE-Tag: 1792088013-55364
X-HE-Meta: U2FsdGVkX18UPxeeUyBjjLP0eAXdgxlHU63uZgJvOLEuBuCo4KivMmurlQ/TnJrd5uCPgnugA5QcnYI6rjAXlbMMrksuGCFDMiuoqRfGkY7wPhfW8dNkDCc4NmD+Nvd/B+wfksla7aqMu3r4UFPcynxzef/qL77sBIBGh2EtEjZfYzd5wRFGqvjWdBr9xuaWODWzv3sROcTB2E3OyJp90gBsGxS6BN3pvDErJqXdDSyglrclhJRxMR/xUEoUN5Wq/uKPKWUOnZFWWfZkMX1z9NVk62SFmzQQDXCFk+UeMpzTDmXMjGTi+Z4HxP9HgzinAexk3Gj4PVssRFwu+kiLRvZFHqlIH1ZmL5pMpAofdklguHM5dD69Sp94nLYHNBVqNa6KKLLH7GM/7sLD/AjUujc80CT7tz2A3mV1frGvhoYbgiGUm3ongDMrBvXw4/l4iFPLhOw+qVkirdHT6/4K78yPhevY7yusf4OeoxlazAm9vScP8a6Ut9a2RAItCjMAl7kybyxnws4cNelXD0Kmacb5JHYnjIVIALj90nUEG/6ilBUXbEYjOA6JZ69WsmvSjeODlGraeXgdCIKCKCLOjouoAOEpq2NxIW+RzavF1f9RBlGDt2Bq0TGN93uiCGfCySFyhb+evwx2TlGEUWtroE6tE206rZvREnMgbzbvMB4nS6cU8P+n8FkjH5CVMT33Ji+tfk4npaIeksxizKKhhXf+DduN83eZIygxkWmahrWtKELRcvzkkGhA4Hi1UczYQBrS9+AVi/2jYwIrcULwS2lseD57QwJE+N5N77w7h0PVEnS4CQSQBU5bM+Vy7p/U9qOaIJG77NBi0Z9k/TAWL5pHjWysv/2feQgm3AzLWTtvcZ+alWhW38H4Cxh/AFam6h9LbBcQBWCmat/WFBTGi6dA3EwXb9L1+EPc2+Ki1A8IOjT2eBwN1aabR/cNwAvlypjpDDoN9rlz7SVNabM
 fTgsDoRb
 3cF3RAG9SkCbxJ0MXOXc/yDK+FSu9feOztsj2Dn2DKiFz1JRpdDDv4bziu0wreI8kKjOKPSn+VMDbBcqMvMPdM0dgz+UFpw8cevTz4fnEDK0IlZLBFrwlSt1xSMUFWIs1LrLTSgg+wEy2A5GGQj4t/iUnNTFLMqAtmbowXt5WXIqbct03fdBGXC7gIXRdsl2MwYtzD0j0ciCxoLTOBCaQiCOdejilgWDMiZR+g0zDhqEf2C6uZH4ezpH1jkqbesf+CBz4fcu1DJ/NdzY6Lyn3L1UcIjnTBy+EoZ9zPeIKxvZYJ4348Pi7oS9Ir3iFzmLLF1wJE6EvzQIbhv5onhyiJvb1+OB+yYjYRF/f5Vvb6rdibS+CJ4hA+6UMWE7TYQsvgrCtif4IezQaFuvRq46RlWVCaiYlJrlgses4pfaJKihxmZgKBZPX8b9kwvFfkDGGQvQ0kOcEWTBLxUfmLmii5a9OzVl5ZNZaxf4a/3H00KhXWfKOoVFLtvh2Kplnuf7ZsjYpyQw6NRW+RnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pmdp_invalidate() sets _SEGMENT_ENTRY_INVALID, but on s390 that bit
alone also marks an old (not young) PMD, which is still a valid mapping
that GUP-fast follows. Without CONFIG_PAGE_TABLE_CHECK, an invalidated
PMD is therefore not pmd_protnone(), so GUP-fast can grab a reference on
the folio and, as the PMD value doesn't change until the caller
finishes, the recheck after taking the reference passes too.

Code that invalidates a PMD and then decides, from the folio refcount,
whether it may drop the mapping relies on GUP-fast backing off from an
invalidated PMD, like it does from a cleared one. x86, arm64 and powerpc
already make GUP-fast reject invalidated PMDs.

With CONFIG_PAGE_TABLE_CHECK, pmdp_invalidate() already clears
_SEGMENT_ENTRY_READ, which makes the entry pmd_protnone(), so GUP-fast
does not follow it. Do that unconditionally. As noted in commit
7b4dde5e40ad6 ("s390/pgtable: Add s390 support for page table check"),
an invalidated PMD that is pmd_protnone() is fine for the remaining
pmd_protnone() users, which run under the page table lock or are
lockless walkers that should not follow it anyway.

Assisted-by: LLM
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
To: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: linux-s390@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/s390/include/asm/pgtable.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2d5c2ab06de98..fe1ba746203ab 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1781,10 +1781,14 @@ static inline pmd_t pmdp_invalidate(struct vm_area_struct *vma,
 	pmd_t pmd = *pmdp;
 
 	VM_WARN_ON_ONCE(!pmd_present(pmd));
+	/*
+	 * _SEGMENT_ENTRY_INVALID alone also marks an old (not young) entry,
+	 * which lockless walkers like GUP-fast may follow. Clear
+	 * _SEGMENT_ENTRY_READ too, so the invalidated entry is pmd_protnone()
+	 * and is not followed, and page table check does not count it.
+	 */
 	pmd = set_pmd_bit(pmd, __pgprot(_SEGMENT_ENTRY_INVALID));
-#ifdef CONFIG_PAGE_TABLE_CHECK
 	pmd = clear_pmd_bit(pmd, __pgprot(_SEGMENT_ENTRY_READ));
-#endif
 	page_table_check_pmd_set(vma->vm_mm, addr, pmdp, pmd);
 	pmd = pmdp_xchg_direct(vma->vm_mm, addr, pmdp, pmd);
 	return pmd;

-- 
2.53.0


