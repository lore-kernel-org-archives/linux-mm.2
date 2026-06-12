Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B8A0CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 13:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592DC6B0005; Fri, 12 Jun 2026 09:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5434C6B0088; Fri, 12 Jun 2026 09:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B206B008C; Fri, 12 Jun 2026 09:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3007A6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:24:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEFB514010A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:24:31 +0000 (UTC)
X-FDA: 84871329942.28.248B35C
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id ED990100003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:24:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=KqyZDsP0;
	spf=pass (imf05.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.62.5 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781270669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QncWu+MLv49ahf0UNz1EIufeFnRD09XtctmnxW3dc9w=;
	b=PP3xLzbeZ/Iy0Lon2oP1Q5PRwpQ2p6knbOitwWIYP6gEJQo8mEL/J1inOsvaAduysLRC8H
	fneQcip7GFHgVIHgYoMz0dh2G64wN7EC3hhBJfHQW0L2+PTfoz9TRg7kQTAQhR5icnww8g
	djuhGvNaQmXw0PjEwln5Kn0QrNrS4Gs=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=KqyZDsP0;
	spf=pass (imf05.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.62.5 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781270669;
	b=qd1GfHTahpb+UTurAKxtGlm78NJtZxicJnErWyrXrKu7L3U7qRVlrp0SBz+JFcu3KI6i+r
	TKvvqps8EIMuqDcJ2qxjuWuKTYlGccrsx4WDYgz4fZupZJqcuh7AisjukB1T0aoz3oKXs0
	GAVWrqH9Lz6mC7s0Jiqamg8l3OuDSuk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AZKlhpo+8iUKOOdvZc8dPYE5ZtwGYl8CgIaw6x5BAfQhneT65EPnsAB5FsdITQ2pIgymUr7uPzXyiCHl0/ymlgLVJZmv4uy72fCZ8cc+C7IuH2B9bct6gsL6GrAVlmU/y9uA/9yt0N/TWRmVI39cmaP1yuDfkE618aAppdsl1jc8iwHRwO9b35vguywxBpUYdzuVjxz94biaZGt3VEMNAyxee//m7mANrw+OjqYO5HRlwZmUTY3JnHHhhgsz5/Wiyr05OyZofiEWzXA7f8Vzqg21W/eG0mhjRj5bi8q+6hh1/KmqV72/W+3GickSHT46irAP2A14xCUgxFH2NGlA/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QncWu+MLv49ahf0UNz1EIufeFnRD09XtctmnxW3dc9w=;
 b=ag937WknBaKQnhw3X/eTu2N8MJspeFUG22XkbQ9aYP93juZ9Q+4BV3wG56VKOvZOF8b8OiPKTd0bxEi/YNyXxZ5Coif4BDlCuTM47HTcHPZMFsL6YIHa6JNX+GRfTtKGodUmiDOrt/lR3agfz7ab0j8QKOHQujsnJN/KsfZBTb9KSPfIneqeO2sT+FxjwTXeZpiz91I4ACbBUiPBBOt1n7drTam3kivAUUad/9aXFCU8V2dHHnh0Kc5kVauhG9QIW+6MrWw5G9Tl+L6xBqMo/mUMzps4MYwG1Qr54pPYVtgtZy0w2j3juPB7Y1OBB/ttMT4iHhWfiT5L2BbsvOg+Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QncWu+MLv49ahf0UNz1EIufeFnRD09XtctmnxW3dc9w=;
 b=KqyZDsP00PEc0nT8NY2q9cx8cwYoQ+1Z4gAzW8kVKnLj+8egvEw/8ZJYUyEbDiOczxseQKF32pg4y8ZS3+MGm3NSKg1TTAJsZPwm7OQaH5qIEJvENywRhcWeCWUNsdIokfpIcKz9cr4xLbgoJo3WFZC38x7Ih3RLFDv1illDW9U=
Received: from CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22)
 by CY8PR12MB7097.namprd12.prod.outlook.com (2603:10b6:930:51::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.14; Fri, 12 Jun
 2026 13:24:24 +0000
Received: from CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6]) by CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6%3]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 13:24:24 +0000
Message-ID: <646fd09b-0dfe-4646-997f-22e464bca024@amd.com>
Date: Fri, 12 Jun 2026 15:24:12 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/22] mm/page_alloc: don't overload migratetype in
 find_suitable_fallback()
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-9-28bf1bd54f41@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20260320-page_alloc-unmapped-v2-9-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0093.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::18) To CY8PR12MB7433.namprd12.prod.outlook.com
 (2603:10b6:930:53::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7433:EE_|CY8PR12MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 946d4df4-b1ae-4661-556e-08dec885eadb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|11063799006|921020|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	D2yA9HI8JnfUrhDIO4A6r7CjVsUHXUR93pgs4i/vyzvHMxIVYbZ73tFQHP+gplXLbrMPzLdLNnpIjfG7LRYexX46dAzrgogpfWaTT5XGNuz8Y2JQqa9EMRkgfZ1slMvXaVmdlX9BlTjlBrxDTDfMDAZEp+GVfEjzpbc0ogBkJ42tNdUEUZK7JigA3+Mqj1ryS9kfG4022Nd9PiIV4a4mmAQ2ZphqL8SIR5y8EyUVqvpaYg6s/canubm4vw6zjUSxI/DEnhq8AV2nskd3Wyg+M5LT4qGE//8q2dGio2PIP6e4D2WqdgrWurMKb0Agy/A+r3JE7h3vhUIsGJJ4SVWoxnbRJRoP/TtLKdwFvjEkNSUlguNVCATab3duhDerhYsyRY9+jDOeGWG5Bb0oSqOFEE5MgLIxYGmAMm9ZqnPFlQdarI0tiF11+6rxIDWpZOswYsiKir1T4L9kpVYrYlXezZdAae3F2P2lWcAQ8/Vsk9nrXrs+UDCSZzGzxnqsL/gtjzCli6O2Lf678y+anWhHxrspGAKK/5d9of65Rpj4PxP6wzhmP9kNrK9nzHvqghWW/94TkFcEEPB1qziJDzowT0T4ALgL2TlPRZJiqoT6tYo2lMV8dbwbTPd8nOJkAZ7uiQfdKs/0HbOmYTvVKTy+cZAYOaGS6AnluCYSqAQpz+A9rfzb2fSDGAkM2I/AG94D21CrOu6JCymqjbTkZHUmjmbAo69QEItR9Xxq55gBG7k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7433.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(11063799006)(921020)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KytUT2NSNXovUHZlbzBhMm0rQUlRRFZJUWUzeDlmVklEZ0hwREtzOHI2d0gv?=
 =?utf-8?B?YWV1OFhOTGlsclAwUDlTWkM1N1R6TGdyMjN5d3F0SG51eklyV3RnQldOdVZw?=
 =?utf-8?B?eWduRFZBeDI2bGx5ek5RdlFaRWNhQjl3ckgxM2FLZ05USExzSGNQbGxySGtr?=
 =?utf-8?B?eDZOZnVvS08yRzIyMTJiS3VEaCs3dVJ4Qm9QLzV5U3pYeDBqTXFpTzhlSmhm?=
 =?utf-8?B?U2JPMUJqS2VONVEwMFR1TkE3R1NKZndmL081NTh2aVB0Tmxxc3ZOdHhGRWg2?=
 =?utf-8?B?TmtNa2pDZHYxdngvM2czREg0cFYrazBaR1FZeEMvMi80ZkR2amZ1TjJsMGpj?=
 =?utf-8?B?U252K3lyTFVEOXlkTjQ0c00rNFhneUNkTEFObzMxK3RheUVLZkM4Rld2MzBM?=
 =?utf-8?B?aDQrM1RmbUdOb2hUUGMwc041RTIzOW9mcTlxcHpheEM4U01RZkFzOGRSQzY5?=
 =?utf-8?B?RVE0czdiYVk0MFZqUW52K0NKbmVhcThMUmNXaVNZN3ZnbG9yRFN2ZGNiWjYx?=
 =?utf-8?B?bHduOURUZlZEU1ZhOVhtblpFczVZREZsWWd4MkRsc1hFUXpONTlqa2dLbjhF?=
 =?utf-8?B?STdTY2t0QnlqQkdiNVN5T0ZOaHkrc2dGS2NwbHNCQTZrVG5QaGl5MUJvY3VZ?=
 =?utf-8?B?ajlYcVAweHRnYnVkeWVJMWMwd0x6NE80QndHY1JwSlZkdlpCVWZlOVVNTnlV?=
 =?utf-8?B?c0Y5dDl0SDdYeStZSWtjendYUzUyRFlKdWpOL2lpMm1RQ1poRHBZbUR2QVhp?=
 =?utf-8?B?Mk1xZ1RGU2xSVG5VYXhQTUJjMDNVZXg4TjZDVWtOZjFIU2VQY2pyRWFvS1k5?=
 =?utf-8?B?YnV5OFJQVjJuYzJ6RmZwZ3czUlY4ZjdmOVRzQkROVS94TFAyZDdyNnByMTVK?=
 =?utf-8?B?STQyY3F1ZTFESGsxN0liUER1dXg5eG83WWwrNEZoa3Y4TjRIVUYyMzdDVElG?=
 =?utf-8?B?OU5Qb2FSaWxwTlkvU0hicG9kR0tzN1pUQzNTampsb3VkNlBvaFdXQTN3MXM4?=
 =?utf-8?B?Si9JS2hZUVBjRmxIY0swSnMyWUJlUHNqWmp1TVFlRnlLZ211V1U1WkpoU1hL?=
 =?utf-8?B?QVJTZHVmeVVoYkh6Yzdjd1hFOWhoSmZkS2FjZ0tUdW8rNnFkTjNDR3E0NEpz?=
 =?utf-8?B?VG1HOTczS00xaVduSTdsa0NlSldoczdGZmkwamJoUVNaOVo3QTVva1JlSjR3?=
 =?utf-8?B?YlNlZ1Y0QmIvRFZiMDRFSXc3NHBqTDl5UllnaGMycmNoMmduL0t0V0xveXJq?=
 =?utf-8?B?TW9UeGNkMDRRVjM3QS9YcGNQRHpUOGdjNTdEZldhM29CZTBlR0dwK0xKM2Y2?=
 =?utf-8?B?S2wyYzNFODA4R2EyTUpVdVlGL3FWZ0hKRVl3aHhWVUlINWNNdlFtMG8weG9E?=
 =?utf-8?B?ZDB1OGVqTVNsakd6ZVNPN2R2Zk4vdzhVQjNKYWJIU0kzZHBlK3QxbzZzazNs?=
 =?utf-8?B?UnpDZ08rb3J2aGhobEtlK1YwTHFYc1pGYksyY0pUWE9pdHREUzZJWG5qMS84?=
 =?utf-8?B?bDEwODJQUjFWTWdiNUIzT0wwbytrVWxlbDY4Nk56a3NlV1IzQzdTZ3JqeXlQ?=
 =?utf-8?B?a2MrS0lTNnAybTJTdGhhYy9TSmh1ZGQ2bkpXRzJjK202d1J0M1dFL2R5VUE4?=
 =?utf-8?B?UXlNUzBRaStzNkZaSVB6UXA5QjlMbTFwb0ZhKzlyQlZ2TXlpck5kNkZTZnhG?=
 =?utf-8?B?V3BHYUhTaWMxRUg5MG9zLysrOUZVSmdITy9aQXVacVRDdzN2eDNORXljaktL?=
 =?utf-8?B?aXowUHRYdWRPbGVKSTBYZHN6Mjd5K0lmYXhQdDFCcUlpYk1iR0oxa3kyWWor?=
 =?utf-8?B?SVhLcy81SWFxVTM2NUZUYzFMSEtqblN0SkNla0d4b2FYS0wwNGZSUVVnU1U1?=
 =?utf-8?B?N0Q4cnNFNkppVXdPQ0dHVGpvOVo0Zi9yQ3RneTErbk44TEZGNkJ3V0ZQNzMz?=
 =?utf-8?B?eUhkTEhTUThuejZRVTdlVTA4QlM3a0RsQ2NzclNvTTZZWk9Na3dRVU1Ec0E5?=
 =?utf-8?B?dENWd2dFcGhVMjQ4ZGNEd2V3WnM3V3lBUVdRSFRVbkhncFgxbU1mL1N3UmMy?=
 =?utf-8?B?NSt4R0NiODI5aHdsYWdPaUdZUGNEMzg0eFJXVjNpVzN5QjB6ZEJqQSt3WDRj?=
 =?utf-8?B?UVBTQkdORkJldkw3MEZLcnJNYmFuM2tqYVF0WVcwVUpMWE8rTWpWSUxoZm5Z?=
 =?utf-8?B?czBpQWRTbXVXR1p1RStPNWNCUG5TbjVFdXNqV1JPWms3Z1BVMHNsQXpSVEFr?=
 =?utf-8?B?WmZISTdURzFTOEVUVHhvVjBGMldUeDJ3KzRvMXZOeXUzMGdGMm9Nanc4SXY5?=
 =?utf-8?Q?m8M2xGpuAa9NuV10m/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 946d4df4-b1ae-4661-556e-08dec885eadb
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7433.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 13:24:23.4975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LMXUh787BdiSiisSNwrGaatpjeIhubc0q3CTawent3O80p9yIki1s+ibfqMknq6DgW1xIg+K1/fKY6C2UzZ5NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7097
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ED990100003
X-Stat-Signature: qix359h9ab5f3pk19doyz6ynm3k41fgt
X-Rspam-User: 
X-HE-Tag: 1781270668-765574
X-HE-Meta: U2FsdGVkX19E9DqJu6OSi+Qas41bsSaHdJyNzdR8hP5YZNlZK4NTpEg3PgHYakWLZY2SRBPGx877hmhIfk+hkjX1ZKAlAEwenNmXNhe+adebqleNLW0nlXhvK6hNVXWX1TX/FKVWo7S8GRG3tokoq1I3yVmcD40sEWl28v1PIr6Uwjd0a/GkGyC4F9o8Q0Un3VXNRadcxW916P/29wpniMVh08ZiHmbwhCe+t6clPrg9jrRFwKYo6Dgeb8hxCi1yxu5L6Ak3YwuO1PAc1Z3WALSz9kPA8EytrOv2+7hpqBqnHEqeyT1kHiY16THGje94jfctG9hJQpgybFLFn2JPdCAtckpv6ch4FrL94aDmR2xwnRkhotSy2yra9NGJtFkmLrQV/J42N5IGgMRe0apNQljxNc3au+EyKyGB6eTjDpBHRppBxkFleCgyi6TRA+N8tZasmFC2NIIDFfcIMXIXGPdK96l9TtJseZpTcxEtqa7qPcYC4ynj74P1YqJZrJuuKOwJJykr4shV74Q9CUjOPyBkwrKlG0pchxYh0LdleuQsQCRdMmd/z6uF2DDcaSR3FFUCimRh5klOiW9onTkOB4NBev4V+J9D18CTqz7Kwf46Q0nyJ9CGOdqmeL5r/Trggjr//4PFjdeZLd0C785YACGWKQfoEGFOAVzrKzAKfrdDgj9+3wV25mJftme6keR9X2xpmfxCMjcBlYriicBRVotK3AJrwQVSoXr1uJHbfGUGJKErOJJ2CMyCOEjZfpji/dFXOw/MIoq2Nqjgp2O4gfGXGQZ4PiRKddmM37961XzUFD2a+VZ6qTZ7GyfuADt8YyBYJZIANUv6EEPYktoXm/9S/8j1hCaM4Tk4kdsD38JvWRhL1TepdfjtUKwlQXQZH5er9Y3sTdLPOKP+8vdPw6AYsqK8eWYMxyDdN1whj8LaAm355fhghYKwBhQqxki7cUvNYO924NH7fr7w1zJ
 iwx9lyPQ
 c3mHCyfnyreaptKjAWOv27kPSRz2gTX4TcQT7paHI7KENQ6lXM3YWnrrhMbQ7cmL/xbrxu9x0HJTnUeU8ll24l5o5+fU6fy4pr8YFESqxgqGuomwmpi6pRBmrpqHvNxQeu6oNF8PAvNq/WRefpR9hNN8689tgwFal+8tU9jfQiAPfkP1/ut0NRGP3H7snS1h3D7QY+lbsD/A2FH/dlYmenA+CkAG05NPyYd/OFnjxUlmu2ymmo0tR34fFangbeuFm38+CckMxph4MBCDvxHrPqpBtx6NqRWQ92uj1GKOs4GMTXq5+rxLzjJf5DpB+mikFjGp/cFflTyT8VXKVW1ZlbHVPMXT/OcLSFgDwO0ddZ3jOpTNZFx1oKbrAH1cNNFMtxyYk0aXEYFy27Psh6bg43T3pjMV5+c5uGZEcTI9OPybWdbeXyReveA0MnyXVG53/3E9wCj1pt2nN/sQRSlHFjT6EcSbgVNcrBx5cwxJ9NJ72voBGzozgcZvqtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> This function currently returns a signed integer that encodes status
> in-band, as negative numbers, along with a migratetype.
>
> This function is about to be updated to a mode where this in-band
> signaling no longer makes sense. Therefore, switch to a more
> explicit/verbose style that encodes the status and migratetype
> separately.
>
> In the spirit of making things more explicit, also create an enum to
> avoid using magic integer literals with special meanings. This enables
> documenting the values at their definition instead of in one of the
> callers.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Seems independent patch with no functional change.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   mm/compaction.c |  3 ++-
>   mm/internal.h   | 14 +++++++++++---
>   mm/page_alloc.c | 40 +++++++++++++++++++++++-----------------
>   3 files changed, 36 insertions(+), 21 deletions(-)
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 32623894a6327..25371a75471dd 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -2358,7 +2358,8 @@ static enum compact_result __compact_finished(struct compact_control *cc)
>   		 * Job done if allocation would steal freepages from
>   		 * other migratetype buddy lists.
>   		 */
> -		if (find_suitable_fallback(area, order, migratetype, true) >= 0)
> +		if (find_suitable_fallback(area, order, migratetype, true, NULL)
> +		    == FALLBACK_FOUND)
>   			/*
>   			 * Movable pages are OK in any pageblock. If we are
>   			 * stealing for a non-movable allocation, make sure
> diff --git a/mm/internal.h b/mm/internal.h
> index f4c59534670e4..e3782721a588b 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1059,9 +1059,17 @@ static inline void init_cma_pageblock(struct page *page)
>   }
>   #endif
>   
> -
> -int find_suitable_fallback(struct free_area *area, unsigned int order,
> -			   int migratetype, bool claimable);
> +enum fallback_result {
> +	/* Found suitable migratetype, *mt_out is valid. */
> +	FALLBACK_FOUND,
> +	/* No fallback found in requested order. */
> +	FALLBACK_EMPTY,
> +	/* Passed @claimable, but claiming whole block is a bad idea. */
> +	FALLBACK_NOCLAIM,
> +};
> +enum fallback_result
> +find_suitable_fallback(struct free_area *area, unsigned int order,
> +		       int migratetype, bool claimable, unsigned int *mt_out);
>   
>   static inline bool free_area_empty(struct free_area *area, int migratetype)
>   {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0a1dc7866068f..ac077d98019f3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2248,25 +2248,29 @@ static bool should_try_claim_block(unsigned int order, int start_mt)
>    * we would do this whole-block claiming. This would help to reduce
>    * fragmentation due to mixed migratetype pages in one pageblock.
>    */
> -int find_suitable_fallback(struct free_area *area, unsigned int order,
> -			   int migratetype, bool claimable)
> +enum fallback_result
> +find_suitable_fallback(struct free_area *area, unsigned int order,
> +		       int migratetype, bool claimable, unsigned int *mt_out)
>   {
>   	int i;
>   
>   	if (claimable && !should_try_claim_block(order, migratetype))
> -		return -2;
> +		return FALLBACK_NOCLAIM;
>   
>   	if (area->nr_free == 0)
> -		return -1;
> +		return FALLBACK_EMPTY;
>   
>   	for (i = 0; i < MIGRATE_PCPTYPES - 1 ; i++) {
>   		int fallback_mt = fallbacks[migratetype][i];
>   
> -		if (!free_area_empty(area, fallback_mt))
> -			return fallback_mt;
> +		if (!free_area_empty(area, fallback_mt)) {
> +			if (mt_out)
> +				*mt_out = fallback_mt;
> +			return FALLBACK_FOUND;
> +		}
>   	}
>   
> -	return -1;
> +	return FALLBACK_EMPTY;
>   }
>   
>   /*
> @@ -2376,16 +2380,16 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
>   	 */
>   	for (current_order = MAX_PAGE_ORDER; current_order >= min_order;
>   				--current_order) {
> -		area = &(zone->free_area[current_order]);
> -		fallback_mt = find_suitable_fallback(area, current_order,
> -						     start_migratetype, true);
> +		enum fallback_result result;
>   
> -		/* No block in that order */
> -		if (fallback_mt == -1)
> +		area = &(zone->free_area[current_order]);
> +		result = find_suitable_fallback(area, current_order,
> +						start_migratetype, true, &fallback_mt);
> +
> +		if (result == FALLBACK_EMPTY)
>   			continue;
>   
> -		/* Advanced into orders too low to claim, abort */
> -		if (fallback_mt == -2)
> +		if (result == FALLBACK_NOCLAIM)
>   			break;
>   
>   		page = get_page_from_free_area(area, fallback_mt);
> @@ -2415,10 +2419,12 @@ __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
>   	int fallback_mt;
>   
>   	for (current_order = order; current_order < NR_PAGE_ORDERS; current_order++) {
> +		enum fallback_result result;
> +
>   		area = &(zone->free_area[current_order]);
> -		fallback_mt = find_suitable_fallback(area, current_order,
> -						     start_migratetype, false);
> -		if (fallback_mt == -1)
> +		result = find_suitable_fallback(area, current_order, start_migratetype,
> +						false, &fallback_mt);
> +		if (result == FALLBACK_EMPTY)
>   			continue;
>   
>   		page = get_page_from_free_area(area, fallback_mt);
>

