Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D1B1099B3A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C07D6B01B3; Fri, 20 Mar 2026 15:41:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298CD6B01F1; Fri, 20 Mar 2026 15:41:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187EA6B01F2; Fri, 20 Mar 2026 15:41:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0482A6B01B3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:41:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C09121B76F9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:41:05 +0000 (UTC)
X-FDA: 84567459690.25.53CC29D
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011071.outbound.protection.outlook.com [40.107.208.71])
	by imf23.hostedemail.com (Postfix) with ESMTP id D4DC3140009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:41:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f7cCxHLj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.208.71 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JdtUa68cBEvuLigI9LZWDpM/kKNqFw3YQQ4jJ6Qh+bE=;
	b=ErgOfZ0pXOQtHGKmM/CwophL6H3VKVaJsaBJ1M1aL9Mi/YE3tyg1c8XLqWK5Idx3FYzayU
	dFzTtwCYH4Ve0ClFNCuL7+nZ/IGk31TzDf+i4C8E7WZSy4IZ/4g2bIMmqM+zl41G/aWIzO
	c2Dy4uIaWcuDvb3z6ccprRrzslbFwmg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774035663; a=rsa-sha256;
	cv=pass;
	b=L5YB6kNoY0GR4F2lTM5evWNBad4hq6KhCG6kPyMumuaW73eZg+P1eCXgNqy2Vl7XXkFNq5
	h9BRti+dF7UgdyTFu7BH3rQiUp4jg8Gfu/eC6bQg/w7PbWBGB60IEdafxLL9PDgqyK0wQG
	pGIHvyasef+pd5vibu48609e9hwl8jg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f7cCxHLj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.208.71 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=alPCSZQtET6++CQAZ6jLgXTtfGZgmeUisltQUKQoYY67rMFRDyw7Nj9yRULq/zdiA4krTGSKpYcpLn7lFNTbrYVV2NtBBTrsS1kSge9qk89f8aQzApwJTTV/toJyYAJ8yGq2uSBOwt4KOnVBzBcGUkJmqkq7UAsKD/tkXmDch/2LQf1Tqk+//LZGRZHUBrrpvWJo8hnZUxcOeVT4KmyIraH6TZagapCS+8+m31H40yncRRiz9AhIdOh0u0TQf5aX2A5R9euf8Be3tFiTQv4PUg+Fd9PW/szOlClfSy4V5qTj9Q01ZTGV2dOzbeMKtsdeF78jZ0W8kbTusG6PYuiztA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JdtUa68cBEvuLigI9LZWDpM/kKNqFw3YQQ4jJ6Qh+bE=;
 b=fqdtHGSpd4voDNCFB6VBOmQw68nnaJFjycYkJyr3qmIu57MPOKg+onmw5PntC7BeOqf6PjHkhHBLXJBpRpiwuALAwnXlZO7ljpZUk2M5eL3flBlYPc4EcnkBV9UIyfphhjvdbMABh5q9Wpq2mwrayH7whMLAbcNxraJ3C5Q1SAaW2fmh5p8ISpojMEplZDLZjD8IvbPte1KDAW/umbP1OuI3/XvE1xg9ejbIycSmLTV4uevFsoobs67lCf9xQ5CXudSqLd977aFWaxy2i1MEQH8tJREtd7AKHkNj+7yqqqVxj1WOLgY+1MVuiS/JjR1ayYA+oCCf7et70oU7K/t8pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdtUa68cBEvuLigI9LZWDpM/kKNqFw3YQQ4jJ6Qh+bE=;
 b=f7cCxHLj6ogFs7N1PgD2pHjE40eJ0d0pDZlCg6AUczdQPeFAMb5ErTKaCpfa8ApoOMfGpouXiV1J69WUpgFCunS6VPeAUj2keDaWlhS4T3V8jZAokfnFoaiaJ1OwZFWFivGdmSM5B8aWup9IUIFTgCiRDI1q1l8J7rmU6E8w9x1/iQJvI8S+Gc1C2v2kNPvF7Jii1MsqAGpsUsjSwncIWzeYtQQS6Epl9IW7GiojHLknfPrUGb2V/fCgQA8b6GtjPPlMmBabhjnnE3XqjKyd+Hu3NRfBAX8Dmk5gkJ4sV41yPeVlBDmLlBYbU23mvIIgxGw5N0ABElYsmfbMK0ripg==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 MW4PR12MB7262.namprd12.prod.outlook.com (2603:10b6:303:228::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.10; Fri, 20 Mar
 2026 19:40:53 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.20.9745.012; Fri, 20 Mar 2026
 19:40:53 +0000
Message-ID: <1f94cf47-9898-405d-bdf2-29e21cd87528@nvidia.com>
Date: Fri, 20 Mar 2026 12:40:51 -0700
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Roman Gushchin <roman.gushchin@linux.dev>, Miguel Ojeda <ojeda@kernel.org>
Cc: "rust-for-linux@vger.kernel.org" <rust-for-linux@vger.kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>
From: John Hubbard <jhubbard@nvidia.com>
Subject: Sashiko.dev for Rust for Linux
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::29) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|MW4PR12MB7262:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ca8555b-9b12-4812-d758-08de86b898fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XCq8RC0zee+xL9N2AAyD4+Rc1kyDqwmVPwjIDc0G8u393Vlkm8gjV1Aniun2OHmFxezmnSzqB8k1/UWCK1ifLT7gOZzg2zLDpfEnt6qOGN15q7MBwEUOd9cnpmks+d37Bq5VHYBL0FOCLwJ99MUEpOKyTuT/5HpfPf9Fg5JKUS6Y3bEccJeFGB4VM/moLDLZLzHU0uPFxdfzbxj3g5akz+Edz9oVODxyq1ucZEBB2khWL+5IIQcCYF2LpjnRY9hP8c7ozgyYKHDn1H7H/EIgqZEK4m7L+//VqKrWUIEA4wvaxKKcJziNAK0a8kFpoM9mW4slIzeH6l1b9D0cqMTv54y8u3km9it2GxQIh59RxYaxDBhOUxPwAaTWQquKskMoUUJuBRpjEdkdHWPLVAUODSg3a7IiKEHCD7kpbqEPWUe9Zk89XEdwmecEHIT7eZhZr53twOKisW9AxaXlFQYD52VAwwJW2dIE6V4iUqExEs0eQ0mEVXp53pPr54UmJNh8zn5khilYKdlzikNHCcYih8M6N8vm1WahwQaXQ1dVZQwvaxjYzMWpZAZJU3MvAIunST6gf+7vPzkbdi3GfakQozPJjkhzaELfetxhTNwsHLgoxpSzUNxqkovmpTBHEdPMlXBtbhcdPHBKjQl80nKp3MiRbHt+gA18BfxGKERlZFWHu3PmiVaSnlTjsxRMmgpProkcsZAvkTX6faGRUK9xLtbMRlNs4DKuBBpW+npNo5M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUk4RmZweURmZUlpRHNrbHErbWg0eHdqdEVuNU1MQ3pYS0t5aUI4ZDdHb3Js?=
 =?utf-8?B?TUorTVBncnp3b0FXejNnWWlRQ1BiM1dIU0ttWWdySEY5QWVQSkEyUGVtSUE3?=
 =?utf-8?B?cHJlMCtiWElFd3E3dW5vVkI4R2pZQUpiMjJZTkNIakxadWw2Qk16aldPczR3?=
 =?utf-8?B?Q3pUaFJWWTZybzIrYmIxanVWQzhMZ3lYL2NES0NJcVFPZFJoVFdMWlkzTHFR?=
 =?utf-8?B?empVOFBDYnVWN3FrNEYzb0ZtT1NoSWhXbHlxVDFUVjZoRVNsSkRnNjJMeEVD?=
 =?utf-8?B?MnBvOWNwcGtzd21qSUZEZkxEWGdDek1KTXc5YlpOdWVMY1ZsakN5TVdQSmYz?=
 =?utf-8?B?RzQwb0lUUEZwVHBRc2lSWnlNQ3dkWW1rTzVyZFhsZ1hMNWZQNHNUZkxOdFJO?=
 =?utf-8?B?bytyRXV0ZjVkSjBpUXdGK1V0QXNQazB2MWRCWG9ZRXZkYU1HUVFpdkdxSnBS?=
 =?utf-8?B?ejRyMW13NEhvV1NvOVlKU1IraDRMV2lLK1ArNkhjM3VyYWdZdlZPS0tEWFlG?=
 =?utf-8?B?aDMrcmM5WWF5UFlZbXhaV3hRSHIrUzNkT2EvRkxlclM2RE9UcEhtcFo4RVc4?=
 =?utf-8?B?bytRaTFxcVRpWFpoZjJ4bEJxcmtmRTR1SGNXTjZUaHUyeFViQjYra2xRWnE1?=
 =?utf-8?B?VmZ6YU5Sc1JLWlorZHJUVTN3YWRNZ2Fzejd1NFJXWmFTcVJqcldmcUN5Ujk1?=
 =?utf-8?B?dEVqVHlzemsrOC94NFd2Q2hFT0dGODlSK25MWFUrVnJRNnpFZUVWTUVVekV1?=
 =?utf-8?B?bDNaTFVJNUdFRDkxWHpDWGdLWk0xM25xS2lJbE9OQUpOY0g1SjNJNW9XYnJk?=
 =?utf-8?B?bzI1OWFKM0hyMkV0Q094d25XeURjREd5WERNNWdKS2VaZ1pWTjA0T0ZNYWJX?=
 =?utf-8?B?Y3o2Y2QzTElyTEZPVW5sdDlnektOc0FXMzFidVI4RnBGQmcwVGFjVzJlOHlC?=
 =?utf-8?B?ejF0QnV3V1BlQ25VaXJRQVZBSGNqZ0JVeG8vdWRiNFhOUEhEc0hrSDVNVHFI?=
 =?utf-8?B?WkV4ZllRcDZmUG9PZFIrNmIzWDFFbDEzeEpzekxzdTNKQnFRdXRUQTBmZlY0?=
 =?utf-8?B?eWdNMmJtQi92NGMyZ3Z3ZGNlU3V6Unh4TVdLN1FQSDkyejVJOFNuL2I4aUtD?=
 =?utf-8?B?OTl0Ny9idW9Ldlh4Rys4dEtkdktaaEpyWGlaZzkydWlQQkZ1WHZHQzNtZ0JF?=
 =?utf-8?B?d1I4NUFJMlNkakhSd1lkS2lvanJFNFlyMlBiQlI4cUVuQUJ6MmY2cUJ1eVk5?=
 =?utf-8?B?V1k3WFRjWVFhRXpqeXdHeWlRSnQ3U1FTMVR3NGZ0Nno0L01UZEFjVnJ1d1NX?=
 =?utf-8?B?eE1hOWtUcXVFcFczMmo4TGlqVVhKcnpiZldJUWlwbmFIaTNXWjhodVRhZk9W?=
 =?utf-8?B?TlJSTDBwbjNYRlFVUG5vaWJBWXo2TU5zQ1JudFVlRUJmN05EcEtNVSs1eDJJ?=
 =?utf-8?B?cjBzWnRXcGZJeG9DMnNiTXN1KzBNTlhGZmkxcE5RMU5SVXRhcWdUQkphSFBt?=
 =?utf-8?B?QmxNeEl6ME9xSnpiWDlmWGcvRTdwTFpTVVBnRlVvU201TGlHS0VwcEdkbkN2?=
 =?utf-8?B?eEhob1BLUzFLNTlSbnJsTU5jMG9wTllLMzY1Y2FzeHVVS3BHaHE2WlBpNVpM?=
 =?utf-8?B?NnZKZWxoL0FHWVJMaU5FRkZOcFhkNGora2xOV2p0UkFOUUNEbEtUTytKSXVt?=
 =?utf-8?B?K0RjbmVWeUdCNzZ4ZmRTQllxQ2NibTVwalgwTytlaXd1M29yS0xDVGVnK21k?=
 =?utf-8?B?NEtrcmY1bkhDZjA1RE1DbTl3OGk5d0pGRFVUT0ZjVDdPcXpmdDRjSTE3eXAx?=
 =?utf-8?B?VzB2RzBHR0xhZGU5ZU0waWF5YmxSNzY1dDZpakV4bk5KaDl3ZnIzM1ZKZi90?=
 =?utf-8?B?MjRyL2M1RUdKZVBVbE9QWEdJOHRmajVOWjNhbWxnRld4Tm1wOGgzNmg1MHRW?=
 =?utf-8?B?SWVOYlNvL21PbGk5Mk4xdWg0alRkTEJtN0UyL3B2dkVVc0lsTzFtdzgyNU9H?=
 =?utf-8?B?KzFpaVBTR2p2UnNyRVJkQjhwQ2RNMjRxTmFqZnFyRlBwd28yUnRqVUZDMEtI?=
 =?utf-8?B?ckoyRTJUWGRwWldGR1d6N3dZK3p2bXowNFhDekRKUHVYdVNuVys4L2JlUHZr?=
 =?utf-8?B?NjM4Wm85Njg3bjlnNDcyZkVUN2NkRExQY0c3WTFPSHBJaWY4VlhsYWl5aW9u?=
 =?utf-8?B?ejJsQjVUK0M5ZE9nZmJxd0pZYk1PaSsyNTBBNTQwb3VYUUNrUTYybnl2aUYz?=
 =?utf-8?B?dWJHdmI3ZDl6SGJHVEl4TmNOSVNkNE1zT0RoNmhuVVJWZWxLUHQ3NVo2Nk9F?=
 =?utf-8?B?MjF1K1dpNEt1dXdqZDhSYUJDMUI1MWdvTlZJSVZYVDJIOFVsREVZUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca8555b-9b12-4812-d758-08de86b898fd
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 19:40:53.4826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bviJ8idUuud+1OrB/+5/Hm1I2t8vqojVD5cbnWLJ0VdupLu/p+cY1xgokQnoFukznhEFnteaxWWaYh/TJinRUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7262
X-Rspam-User: 
X-Stat-Signature: gn7dayzhmiiab59hqprikgs5c44tfuuc
X-Rspamd-Queue-Id: D4DC3140009
X-Rspamd-Server: rspam03
X-HE-Tag: 1774035662-902777
X-HE-Meta: U2FsdGVkX1/0+uMGrfhzKkwxCjauPIVjbVjheHLLgi+XpfsgQ3Yx4sFg2pmi+uZriaBW/fdIEI+ucHs9GsNwD7e8U10njvOj73xuN0SM7qUi7yF3pNSQl6sPUnQMVAdHMAx2z5kKSgfdHszeQC21RxAFmTe84Tr68NgyHs4oqI7QmewfVWH07QJKNszGlS1namF0N7gP2si9/w+myC5V4RR098DmFPdl4dqwDjIhxnM0bJRQEVfmU5Gg1kiKbHltY4m3ZZMpxRvX+sRU2y7lTf1IIP1Oao+qMAbU7yglLWIHhKtfeNNOewPBWO7IgneHG3DAfGLW9RKAmMZOcj/JeR900rZxKh+JZax6gfHQfKBQLZfLcRxo+C5+BEAXUBTqZ8P32Y/kXvEdZsXsavRKxF+FdjKBL3EjRHHcdWswAfO081NAYM3aoMELQCACULyV73nguvvvKk7KXLgclJ4QPGmbQCFtx4ZueZXa+DLqx2z4fzZBU/t6a119MWwMq7NbyCvSBqwTEwdbmTNIbBvH0gt2b1pkacWxxW9qmDiSUVj9/LLg2mMMpog8pFxX15qblNSmUyAv+SAig5SvXqUZAYFzA5uToat4rmeiM7ZEwyYGu/jR+rpk0jLIWr04T1y2bW/fC0XsFV5fcBfKZ+TjUed0AzVp3q4mEhdcchlgyF5jwALwACOS7/c2AkyK4/G3qT7/ygnbRM3b3F3DBSpYVwJO7Hxj0qxunQaHlcXUrVytZzbhA7r9bjeW+vaud4zsZohBE9NaAnaIVPSACLgD1pJF9JUPAwiOAwhrAD4KPJxCoXLHCDXtzcKKXzwP1b5jMiQd/Ty8UxM1ggPmBue92CbdPczbP3ctanASZUwMdK6y0be3+3s8sd118hAdJ3xCRnrDVivgMZTOz2q+af4VLhGzfMBgpTO/zvNHYCqzpFPUcif9ckfVETJI+nBSW0TS2vGsESL38Id2YnlE0vy
 A+zDKAkY
 qQ1awdckWeI3w9otg1a66X9jOQQq6pZ8Y06IlcCDVFIWx2ZLC3iDt1JF0O+82bAN3Z+fhdET/froizoKWj8pekdjgjkD07s+HSDdDBANc0rA6Gaqf5gMjvHMi3XjOo79MHvVZR5KA/W6QwWT8c5Ue9eQ1gS5E+E13Kr5EqsNJxmnFuLy41aSfgfrD3rCDMLsJwUjq1ME9yHJWHOvqKXgNUFkzk0zml3lIMi/MFHmeblXWocNJTzSbhx880QSTUp2APQnuCt4faPcQz1SbY5GPbjfv/yB7s7rFYYvkCbr0SGhlBuB0Lvd6O2LuVtg3COh2EDLH6Ey/Agyk+oDEXtN6PPVys46PCZpU2A0mX2rMZEO3NWdRLHGOB9Sc6RhO9ujCCcXwqmPFzOekLNCWuRI8JsJXY/bxqwtSLb43BGrgFo8G9/zirgWLNZ54vuXehvLDKNsf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Roman, Miguel,

I was delighted with sashiko.dev after just a very quick peek at a
few of its linux-mm reviews. Up until now, the AI code reviewers
have often fixated on trivia, but this one goes right to real
issues that actually matter. Sweeeet!

So what would it take to get similar results for Rust for Linux?
(A bunch of us are working on drivers/gpu/nova-core and 
drivers/gpu/drm/nova, which are written in Rust.)

I'm guessing a combination of "add rust-for-linux to the list
of mailing lists", and a whole bunch of new Rules/Skills?

thanks,
-- 
John Hubbard


