Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51627FED2F1
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 08:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D87D6B0089; Thu, 12 Mar 2026 04:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786126B008A; Thu, 12 Mar 2026 04:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B6C6B008C; Thu, 12 Mar 2026 04:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52EB66B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:51:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF7388CA3B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:51:22 +0000 (UTC)
X-FDA: 84536792004.30.563E19D
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010053.outbound.protection.outlook.com [52.101.61.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 225F220008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:51:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DMs0pUct;
	spf=pass (imf13.hostedemail.com: domain of jonathanh@nvidia.com designates 52.101.61.53 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773305480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LkiqnoclMrvCG6OJctCIabOUKZPa7d5jZjnCNWTsQY=;
	b=b4oL8tg1BzEv3nxo8WMmO06ytHQ/u94eF5UyDhKWQFf/KwWtYpiHiMxA2BZKR0/vaGXqAo
	76xfUcJn9V/QDofxTFifqk0FDmisAVDv1WrOVXOqiFZ09ip05/w1D76e0XbxGF0BNLZjS7
	kthvwto1VYECnCl0K06oY5CDBxCCZZ4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DMs0pUct;
	spf=pass (imf13.hostedemail.com: domain of jonathanh@nvidia.com designates 52.101.61.53 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773305480; a=rsa-sha256;
	cv=pass;
	b=ku/yy6T0tR3rJvmQd2uinVchIc6RWtZEOSXwucUkhBzf7tlyidtbvZ6cbFYmENIFIaS4iI
	WHStT9GOhCRblwKhtQcxC7yAGJdHgIm3xG62nCijit3mPsyoTKTRZ9Y8d/o76IFzqEFDnB
	C7pTa9i656AYuN18Z+eQMzDIDZY8Ec8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o14nxkQ80t4AXUFbo6RcAiYzdbXWTIGCGE2EWSLpxryXaQq3DKzo+P5RTJOXkphICVAZL3/AY45hccaUSSsLjGPr6GNIR8MznPfBiqyaypRbauO/NdAqVNHAnQNxUyS+hLYXw9/CQV+3AbDpVPlXsKAnhhAhaAYKZfpyojfHC9PW1GpuIDqIWMpgikpSPRim0xl4fXwgWsqvkBMN3oZCXDT+AS8V3dBxTIBtNFUVZPOj8RIjQDbbwWQ++m/3Xz3W1lq3USihyX2KgO0FOlCMPYSC8kJfUe05AM0HbqRh/0fkWZUhpn8bH7N5wRK7atGO5w093WIN6PwtIsEYr1CPnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2LkiqnoclMrvCG6OJctCIabOUKZPa7d5jZjnCNWTsQY=;
 b=Yx5Jk5D4JKwtpiQbh4D+2Cea1YTxXUmpXDse/bWOXQ4oL/BBKtGYHcHbc6sBIPTrSCCslE9ZsEJOyqdzlh0Yf+XH/Qlj6VsqS0FnQbkSq2CPpboYqwZhnOl8xcmdo0dqVO7rabeHr8RBWJpu82u/doicNddHyrI8eVaZsaY6wNOd53yG2wsZuXfWmoF6ymC07AFbsut8/0qVe8T7nqSKa/1eyHGw0y1QFSKwMJn8rpORZ979Id3s2/GDtVoujZl5/JLAxzPtqukqE0eY4i3sff4svMdANPcIGcL9tciWs/XKUVs0jH6k/3AH6pvXu+SR51FyEScADOe6CuUk7TRM5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LkiqnoclMrvCG6OJctCIabOUKZPa7d5jZjnCNWTsQY=;
 b=DMs0pUctnDfWhcCHgQkEdSXQM2A736xcXQ1etnrqYJMKXrzV+WrhvzM3kddpjncjhGozdKPmkOo/5I5TXCk6d+rIRgXKbQ/uSWD3kJNl2ZG/GOH5ChfkIWjiecigLeTvY3HGoEdTv7aSAowtypAQPluhBzSE81Al75NWlFdAFMrPktizJPTL2jCCq0zXSJZ/c4O7HgY16N7DOadWrmZGtKLs3UB6Ig3uPi5kvFmFzv/lLT6dMsvRMqey46im7+HAZ/fbAFPcgDGZg5q9wlrYjDDql5Gd0qSSerHo/Xm7+BKl/xfcJQjqbTjC5oxA7Q7HTz6ZSDHZBITSNUMu6yrBCQ==
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by DS7PR12MB5792.namprd12.prod.outlook.com (2603:10b6:8:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.6; Thu, 12 Mar
 2026 08:51:14 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%5]) with mapi id 15.20.9723.000; Thu, 12 Mar 2026
 08:51:14 +0000
Message-ID: <ceeddf8e-d8f1-4520-8030-67a1277a1032@nvidia.com>
Date: Thu, 12 Mar 2026 08:51:09 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/cma: move put_page_testzero() out of VM_WARN_ON in
 cma_release()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
 Ron Economos <re@w6rz.net>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260225031231.2352011-1-ziy@nvidia.com>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20260225031231.2352011-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0379.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::6) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|DS7PR12MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: 1970be56-f0e2-4649-e17d-08de80148478
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	fvnXjG40lGwy5XENdfSPR6NfVv0lPCfngPeoPIQkCDbDsCo/DYchFUPNxT0JKe+duMWucufoZQwLzruZuyPNJJ928AI+CcKUclJR3nvAsxt09w5zUT7nsJWH1AbSQSmOJMc2UegnL7YalxMIPFnpJftjtr+qFXTz7cgBbTu9ARscnML5EbOPZaWOtvJZRqqtcbRT0SCTg3FCixPr/KppCwvx+Ev3y1ya4LZOVNmezUJRGcCEt5eCKVKDQJVSG9vYllTML239lutIWDYPdBZYk6YzG2HY1PxRsmryDeL3IZKdLFNhI8L7GKrOzRxmrWuhhabQ/HAVj69tMjV2grfzMseZSjkWLETe3jH2cIWPFhzBaAHnFkSV/XPcWmtBthHn2TA9Do0uf6sMHcYM01QZVACgtY63VOdAxb3QpK8F94vgJEHOCNgj5c2+ub07bup6bxv4oTadLhx/+hmyEACEO1hRUroGGv0collfERWkWQ48T2fxvgq/bZqrEnU6Dhe+R8g/sYWy0IFTAobaHOca/GiBuzSfM0wyvJAU6aQtaFsjtdzDRZMM+1TPEjNRJLIMN7/9HS1Ez8C1Tuw/0L5j/JQgRf7MbkMU8bMPNmSGd2Ymc4S4JmCEUzJohcPT+QD7ylrFrd1yIuutQ5Agm4Bz0pP8kcaND4f9+a2zh60xkGCtSbfNArufhvsY9DZWEKb5qz0bejWHIdYEMG230dm/Io2hkkFr7OFpnxBW5f1kBrw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bldzZEVHZDZ3SGFuNXYrczNiaVFlM1YwTFBiaXlUQ29paUIramhJaW82UEpG?=
 =?utf-8?B?cEZUbUE1TkNtTmFWUHh0Y0oraHpqV1RuUmFKQ2x3VitGREZReUdidW0vSGZ2?=
 =?utf-8?B?WGRmRXF1am1nTUVJQUZuc3piVjhMTkNQTkV1NlhrbDdXZnEwTXk1c3MrV2RM?=
 =?utf-8?B?NkZRME4zTzV3YllGV0M3d0hMYTcyY2E0TE1YQ3UvR1A3di9DR3NyaTIzdUpN?=
 =?utf-8?B?cjVOM0ZsZDRPN2hscVdHU2VVUkNhcWxLb0h0bzJJbnl3SXAyOGtZZHhoeUlx?=
 =?utf-8?B?ajQzTHFnWGpsNVVoa1dnQmNrZFg0WmhpU0tuM00ySDRHWEhXa0p1YzZBSms4?=
 =?utf-8?B?TzcyTFhxWDdaRVVjQXA3WCtJWTh5MzBMSnoyTEpDR1FLY3daZ25MR3Q5cHZY?=
 =?utf-8?B?RElUZVN0Ujl5d3F6U0Z6aUFYaHNJeHZZeEt0Qy9LUkZ3ekpsMTVZenFncUFw?=
 =?utf-8?B?K2lMMEdGemxrMWxmdlBQbngzRDZhaVhibkY1REQ2ZGhCUEpCTXE1bGdRNDJx?=
 =?utf-8?B?M0dpUVF6SXN0YTFzZnhLLzNNeVBxK21pZXBJaURtTkV0MHZGVWpSbnZyQU90?=
 =?utf-8?B?M3Mxc2RqZWFGTVFYRmk0d09DQnNyb3VxMnpLWSsrcDRpVXZkOXh0a3hQRTFz?=
 =?utf-8?B?ZmwzalFQVzJ3bU1NbDJrOTNLN1hXTnpSUnJFVmxZS2dvTjl3R3QzL1BaeHNo?=
 =?utf-8?B?TFdoTjdJNDgzejhFQmI0WVJPZ2p6NWdIYWI4OWRDK2JPakgzUms2THRlMXZn?=
 =?utf-8?B?WEtpRUFDMS9rTTEyZndqeTNsYnFRTW43VW00YUplT3o0enJvNEI0T1R4dzdC?=
 =?utf-8?B?NEVvWGppKzRnMmFCTEM4YXJtSDZwSlc2NCtrOE12Q1kxSmE4QTZrckRlREpI?=
 =?utf-8?B?NnNjdkNlT0FRMHlVQ3B1QW8vbHdzN3RNc0xCZy9rajZCTjEvSEJTeSt6Y3Ir?=
 =?utf-8?B?UjVabjd2VTg1MDlrN3p6L0IrY2kzNjFBczM2UGh6YWtSSFlpWHd4SGdJNzBJ?=
 =?utf-8?B?TWtteldHaTM1ZndWYnJkS0JSWW13eTMzYWgzdUg0VllGNkpuamcvMDJ0NE5s?=
 =?utf-8?B?b0NZbzNYUjFGYVhFaWtLMWdBUUdpY25pQ3cwOVR2anhzL1hjRjdkdmd1QlZE?=
 =?utf-8?B?UGx5cENjUDQ0d1lHREF5b2JmaU1NU0M5ZDJ4T0JjZVVvOVU0dFRvVm1uVHNR?=
 =?utf-8?B?UDFOcFVMWWRRT0s5TC9Hb05rSVExNGlvNVhtNm0xMlpzWVhBWFBhSnhVOTZw?=
 =?utf-8?B?WEwyMUlxN0pSdnVLWkM3QSt3bjhEQVJHR0FEc2ZvS3RyS0hVdVV0aTdrekd6?=
 =?utf-8?B?STR1Y3VrV28ycG1IQVBrL2lrRlVkZjRqVk9sSzBsY3dkdWJWZndGQVdsZFJH?=
 =?utf-8?B?YWNtMlNJTWRweGF1VmErYXRKRk1kL1dFOFp1czFNbnc1M0IxSTU0QTk5NXlK?=
 =?utf-8?B?aC9mcDlpRXlMV0x3VWRVTThMREFRcmNqN0JMMWZvaGJtRDJTbUNpeTRKS25l?=
 =?utf-8?B?VjcvZHc2NGUxUkNFaVZQUFowVmhCZnpBYlc3R3duMWxWZmlZcThEWjdSd2Ux?=
 =?utf-8?B?ZnVZalZ6M2QwWEZ3OGVMczdzaTE4QVBsTjdrQnIwcXBxN1dnVUVzVmVWeUJ1?=
 =?utf-8?B?dmFjYUZsNk55SjRuSHdxdFFEcDJxbEFtZTB6TlFGQ085cXRxREJMOHQrT3dN?=
 =?utf-8?B?YTQ5VkRBU3JkVFlMM1RFMzNOZXJVaTc2Y0xPS1lraTJGbmNpeFpoOG9rVXhJ?=
 =?utf-8?B?WThpR0J1a1YrOEdneTBOWTljVFVGS1NUdDB3YnZEb3R3bzUwdG9aclRYMHdv?=
 =?utf-8?B?d25HWUFhZCthS2tQMVVkeTh3VDNvQjJqYVJMZWhHL2dJVThYbjdNRTlxYUoz?=
 =?utf-8?B?Znd4bHFxTkJrN2NnUjNjc0w3OE80cVZ3RVkvQVNUNm9MOFIzQWRkNG9XclZ5?=
 =?utf-8?B?VXhaSG93TVJ1ZmRjMWE0cGFWTjNxdnNHRGxpMmFzTW1FRW41bHFvZm5mODl4?=
 =?utf-8?B?NExDVUpsVkdmUDhHWmN6T2M2a1lSZm40WHYvOTFUUGh2REpQdUtCUE5QSFVE?=
 =?utf-8?B?dHJvbFlOMi9KeVI5QWNaUmhqd0lSRG0rSjhiWmxPRG5WaTVoNmFpZGpUUUl5?=
 =?utf-8?B?dHlzQkZyL3JqblNYL3BMeS8ybXlLdlErTWJBcDBWeFZwcDJ2c0k3OFoxOTR5?=
 =?utf-8?B?V0poR1lRVkN1QkNVY1BQTEI5RGh0NGxwNEJjbGwrMGdIZ3dCN3ovVWlXOUp5?=
 =?utf-8?B?MkdNNVdYT2dYNlFveFh6TFZ0Y0prZUhrQzJZVlloSHF0UytYbzNJZkRvOTE1?=
 =?utf-8?B?NDdJYzFOODBTYU04cy9LWWZreUxDZHdvcWxEVjQ4RlZMc2xJT2ZDdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1970be56-f0e2-4649-e17d-08de80148478
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 08:51:14.5534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xL4ETf0yYVtudXMs2uPSmBjFGCEASXkpltLqAjwKxXKO50cUduapcm73u1ujPSbekOXwI409PCsyR3OvAO5HWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5792
X-Rspamd-Queue-Id: 225F220008
X-Stat-Signature: tc1rc159o1zc74ejhx3mcnnhq5gbzonb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773305479-169287
X-HE-Meta: U2FsdGVkX1+n3sp2DyeZ6C0wihb1YIM4Z8y6M3EYE4us0ia64gAB2+m8U1ie/oQvCNpk53zArIbPgLn+0S9rRla2ur6W7yoqxI8enjthsQ+JpD8ZncxfzDeAkwTZ2z8WXbwsclXd+Zus4VLgDPrc1/PQPYCWcXWGQM7tDObdt5jFtyw5/VnCPvefIMMscBBCK00TIETUidFjDp5HS6AvQmezaaIvQ+e9XhqB/us4RJsbv8l1izEZuwWOpshtFFHD1wuj6I9fJixsLj9t+ifuMFzTBvn7VIXYc5DB9wNC1Rgo3607LkC/oFn96iugWCray17AhtgRDE4kvaz5+9beez/9KYLdVabud+x14kFZrGd1/iHLNmVOXlWnJG3q7R6Z4/VqMjkXeDvC4vsS3aGS+dRLxsgul/DWT4GjOTDCsdbDfq8GUHoT/z8KM9RgqAQVfIuk3v1YRywBpE+VGhn5XfBmufiUwdylIarjql1zwJhDtzrJJ+0Y2N9dvGXkNi6WxxCTPLSEGvVDeG1ZTf5Z1di2sxFbk7NIh5fUp2p5vIDsSDNifDospIt9k8gdsovwUEYrakT68KixM6d4GxBJueyyYCuNgAnWQDncEGC+3XMUcsTRlmRDZLbiV/OQXbsdmOlpAbnPDvoy0ToF4868ON/XrWRVvUp5pv7xXQxYGcE0v/xRzAdu4aeRgeHYFg5548In+Z0mBMwdz8i1jPDO8KTPTvMw2ptczxvnMgTZsRW1FbpkBrHDPpm8E8z+gtID7r0YFRSZNom2/4pbzynU9ghDunmTUB9MzA0xDIDiS6RsC9+CEUknv5iiMGSE2SRiPHF3hEzSxQDnJY3e1Z7UjOJE9oat3N7QAbMcwA6d5jPwi7wNeRy3sM650ozKxJPFr54HkY655En7ldLARzGRXfXeuqcgyWqPoiKp4H+WmQjVBF2ta4I8iYdhGB6fPj1edHsMG8PtFTyz3/0V09g
 4ra4LNsj
 QzpG+7qb0scsNv0EXW3Uy+S9Gs07PGtwP3v2mA6zP2+H9NC9o3NmU7ZwszP7NAMEWlpZITSiKXSAHUcoCA/OKMHHUW0qmyrWkhj6YDrQ+M0+E8dBig5qgU8u7PbA/rL8etaeYSqihiD8T9g/VY8FwLC1eRLue3Isa/2NlKgV6MYZjZoYYIl5VLF/3nhbPWuXN3H44gw4byxerxqqZySbx17rYPUFuH56tFpPZFs7sWLtE7+V0E17XPlVarLtcrJvJjykUkCTHQKNO8Qph43kqorm6QB4QSpsxFsGvLTlKwnSy8OToXydf1FdI36IIkx48/7kyjw+TqyfBAjyy9g2vpF55749lBFs11u4XSlWQpPgsnFfvTyXUqC/e6SwTsuf74u6cAsHV4hzzzC8zABOyB3VUvxo7X7vnDg4xRwTPHfQ3K9ZVc9xAq68Xtg5r/31th/3ZqprFrUfKZCa8CqoDzuSKv5JHM//cG32nwtgS0tRNwy6iF2PMpILudKElCcIDgjQLQCm7G55NpnGfCxXPhsHB4lx76O+zm7FwNinmPAYehVrCAyACnPu2W1bfU5gEbkBn+m1KcD8xQmf4IYl20EDBsJOmkhAh0R7XPwqN6rS8oTcrUOIp2hJt14dKHIbd85U8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 25/02/2026 03:12, Zi Yan wrote:
> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> with side effect inside it is incorrect. Collect all !put_page_testzero()
> results and check the sum using WARN instead after the loop. It restores
> the same check in free_contig_range() before commit
> e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}()"),
> the commit prior to the Fixes one.
> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Reported-by: Ron Economos <re@w6rz.net>
> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
> Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>>From V2:
> - Collect !put_page_testzero() to get the right result.
> 
>>From V1:
> - Collect all put_page_testzero() results and do a single WARN after the
>    loop.
> 
>   mm/cma.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 94b5da468a7d..15cc0ae76c8e 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   		 unsigned long count)
>   {
>   	struct cma_memrange *cmr;
> +	unsigned long ret = 0;
>   	unsigned long i, pfn;
>   
>   	cmr = find_cma_memrange(cma, pages, count);
> @@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   
>   	pfn = page_to_pfn(pages);
>   	for (i = 0; i < count; i++, pfn++)
> -		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
> +		ret += !put_page_testzero(pfn_to_page(pfn));
> +
> +	WARN(ret, "%lu pages are still in use!\n", ret);
>   
>   	__cma_release_frozen(cma, cmr, pages, count);
>   


This fixes a regression I was seeing on Tegra. So ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks!
Jon

-- 
nvpublic


