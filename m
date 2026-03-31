Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5790FF60ED
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120A96B008C; Tue, 31 Mar 2026 04:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8476B0095; Tue, 31 Mar 2026 04:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F291A6B0096; Tue, 31 Mar 2026 04:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E07BA6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:48:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 788931B92E6
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:48:12 +0000 (UTC)
X-FDA: 84605731224.24.3B6E79D
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012035.outbound.protection.outlook.com [40.107.200.35])
	by imf16.hostedemail.com (Postfix) with ESMTP id A1952180006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:48:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bjZSb0ms;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.35 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774946889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbwQ/e20JkCFdvkc8D57EBsHD434cP0/b+7Pmcb4sVg=;
	b=CjyoYQEQbrgIsjUm8L4h/vUe851vSZGBct0YKQtOOXZnGmLW/ryWjSgjE4YjfSpJVngmRm
	uFdUInWNiFKZghTxfj5Yhf6GmB+hZQ0V35ls0kognSkzy9t43vwxNDqgzmvo4/JtT/WJqb
	Qa8FGLeGmN7V7ySxCabEkFWkwrqH8HY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774946889; a=rsa-sha256;
	cv=pass;
	b=tsBXBzBoeGI2wHgneiJMDYTtGPcnY7qGF1nEICrUXSe8Nm2e8PEegbjdHQrjH9+4Ccnl4K
	kMGCRRG9KNLdnXFbMl8qhdHqp5doGpFO5DbmQiVfdpRiBO1wfiOHdvF5ZUQi6nRPOYWlwI
	wHaYYiEUrHIs7/EIJQnK8J5CD59mePY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bjZSb0ms;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.35 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XSkG1WmxD8iQJ758XkENgNQXGRP0O/t1vYSupL2axaN9A/I4QzFcg/ynCRuzuB1l0stsCuV7kcBtHW6GmoXWJ/DUoNXhTMFwRpmHYtXMSzwSmeCRtil5nh8A4A9c3vVK+7/tHZudtb5qf63tpasVsIn9kiGtYfz+BEF+3IcNo7qgvNDntiyMlmTor9H3V/P1Vo9cgKOodXFK6H++TLbPvfLFljQgt9Z9jTKd6jNtTGxWyRJtSxGZFl8Sw+rKWR+nu6gE2zv9XMCSBtMeHIybszIiI7AvH3v9FxYo3ASldJIvyDVjMxdo2Pl5b+sgEARSNyhtmC2bvux2Ks6bPuPcWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pbwQ/e20JkCFdvkc8D57EBsHD434cP0/b+7Pmcb4sVg=;
 b=D+rnNg3ppifK0he1ZbpaexhyzElOY4fnZuJekUIygpAY9BJc6IYgzHX3UUlnHMAIaUePvs8G3IZdAw9SQ5KwajJ2FW04DdWweIU+uqmvUiu2Wnm6zz4PyICZxa+hTJmvu/q6H5UGvJ1ml4Ziswg2hURrbOUGBX7QjqluMjqX093CmZXg97RX/2JJzUlrJNl311vW7k99A1HzG1X+30muLGMGARlGj4NudkoiYI4GyABNgLk9690OILNh4OxWjSVsQkTrvNMABFNYfRfbadoo/XWxBODqK9LiP/RTvia9NKI/jEHds+p52kKsbiPpl7lF68l2eJMFO88EsLrOck/V2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbwQ/e20JkCFdvkc8D57EBsHD434cP0/b+7Pmcb4sVg=;
 b=bjZSb0ms2bCW8N3lK/XAv8xwbdqWrKYrlkVy9eN+9vXTYVc8sNU8TEVJjSFkB4K3i4pVcHhoi/LH23xErWYRp0kamqQYmNnmjbYs7mIILE+PwmVpmBBibcwdd38PpTMBiEumo+GAzu1tPjS+ZE2/UxFc6Bm5rf7WugodQdzhuci/oe0gb6CndzdPgZhBqAjp7xVqmVWfqcWyPYKD3xEF6ngmqK48gkjPubTP8MGHRbNXc0VWc5LZmVKLb79+MKyENFiVKJ6887Cnbk1YxA6BsXwN0Z1GxyXA9XCEWNr9x0Som/9vYEXSk36mqf/KFHIYz9PZPzZ4OS8l4wx/Xf3KRw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA1PR12MB999228.namprd12.prod.outlook.com (2603:10b6:806:4db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 08:48:02 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 08:48:01 +0000
Message-ID: <8bfc1678-e2a6-45ca-9246-5b10b935d0d3@nvidia.com>
Date: Tue, 31 Mar 2026 19:47:54 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] lib: test_hmm: evict device pages on file close to
 avoid use-after-free
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Cc: zenghui.yu@linux.dev, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 david@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 dri-devel@lists.freedesktop.org
References: <20260331063445.3551404-1-apopple@nvidia.com>
 <20260331063445.3551404-2-apopple@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260331063445.3551404-2-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0057.namprd17.prod.outlook.com
 (2603:10b6:a03:167::34) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA1PR12MB999228:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bcb99a6-8e8c-4352-8b05-08de8f02376c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|13003099007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	6JFmj6XlRD2YbqyfalaGHknPCQFiJY4tD1XBmU1+HsPwERQ0BLb3160e6cuDW4EppfEvVYX35yn0YGvR+CX8ODwIouD/RPo3H2mLmpD3iXRKw8B/HbvcCllonVCyvasuC2EXRJW2kBZnjStEWLtJTaLwihQwV1SBRLIPC/l+FvomMhkGJ3hsq6ZsMJOl0SbWo/UiNpZNP7EiRoCFuNN28QoJIEGZV1nPqGO8ZIDfcs3rggdg9pKzc6wZmGqp8m796saTewZAAWJpgI/WqwjPpWR9ZyYvsPMkCsg7BNEDXGM3rGrCTA1t1dK1/BL50CDkVgDAlf6knspRyu6V1sUDtsiR6/+U4zgTdT2j7aAIdckWUOyCTznscY2iVZJEzU92Jh182/N4PY0oFLIch+4vyy02r7VY904jsSN8nArACYkNrYVDngRiq+KJ0M0p03S30fxvnvSBCqcfIsGaRjDwtakO2jYWF9RQM036iDqHh6gmln8yOnY+/E4kaNG+t9F5bO/N1faSA+XTMcgU6Hv98bXlMx8o9cX+Ktai2ymOrwPe6pj5L9UmrkmD8kKuhaTk31INVYQlUs4YHIZAjvsrJGG21o/NWcHq6TSXwCK7EDU3JsPiryboGFcCK7Z5/3VsJWRV55sMD8vUZ+qsVipFufaj1NNrJbmYPa/dAlv/T/o24/D7Q0bbNWGiHo3iaWsTuTtR1JyYuJE3iR6G9LhPu+Fw23GVLiYlc+WoiMDq0v4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(13003099007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUR3OWdwTlJsZDFGbVVrVjZ1Z2VSYmNBamNYSlJNWUUweG81NnJ5d2huM0do?=
 =?utf-8?B?aG5jaHdnejVlNTN0eEtiTjNtMUdmcE5LVzJlQVk0KzBGZlBWNmtJcDFjbzl0?=
 =?utf-8?B?QWxxTnk5bEJreWpnMGxtNkY3aXArVSsvdUN2T3dORUxKcUtBT3p2MmhTRzBO?=
 =?utf-8?B?VktZWS90N0RQUkpBWHo2ZFptUjlqa2FXYklnbTVyRHJjeFRTeUs4YWNOcWR4?=
 =?utf-8?B?ZDJ0NTF2eGhJMGZoZWtHVkxDN2lCSmh4Y1JockFmSHlwNW9rOFhUSWpuazZs?=
 =?utf-8?B?UVNSQnJtNjRkNS9uZU5vZzM0YTkwa0YyMk82OTNyUm1SL3lEbUVRUk9YbnVY?=
 =?utf-8?B?Wnh1cUs5SDlyWFRxbDdJdTdZOGs2Y2xwMmMwSWF6Y1ZyUWNsblhQVm90UndU?=
 =?utf-8?B?K3NvWEFHVHFsOGlkTFN3K3Z5UTBUd056a09waVZENXZRQU5FanZhMmd0Q2Rl?=
 =?utf-8?B?b1VYdGdIWkNCdzBhWldVSURJSUNOSS9YbDZMNEhydU1OcWF4QnMybTN0SFMz?=
 =?utf-8?B?dlExVllFM3p2SThvYW5hMmRxZ0dORjhHWmNqaWNCelVvc3dhaWxlS09ZUDhX?=
 =?utf-8?B?a0RWZ3R2aythb1loRVNWblZYUUhmV3JRU1kwditQTUFUU3pJMDczeGhSTml4?=
 =?utf-8?B?Sm5OcDloUktPbDZkdVZ3cU9GMDhNWU94ZHU1U1c1a25QRmUyNFBuZ1UzTEph?=
 =?utf-8?B?WnNGWWZDODdZQXR5cnNxb1BDd2RVNzNwRzlmSXlhZHVIaFgvbmZxUFZzRFRp?=
 =?utf-8?B?YVRhZ2E0QmUvYVRxYmJBWThzbGtSajhVa3Mxcm1RVnBIQnVVWWYwWC9zakdB?=
 =?utf-8?B?RmMxZlR3SmxLd2tud2hlTDgvL081dUM2NFZkS25oY0dhRzV0c1FjZFAvNWtt?=
 =?utf-8?B?VHlrTWhlcXJwZC8wUi9mcGIvSUY1Wm1zZTluYXFoSlBWb29maC9EVWlFNVUz?=
 =?utf-8?B?NTAxSHpoYjhJaUNqSnp1VnFDN0cySEo3bWwvUXN2VngyWmdFVkltZ3hqeHJw?=
 =?utf-8?B?WHpzVk1iZHRFc0FZZ2dHdUZHZzVOWVJXK3BxNmhWR2hmcklsUlIrMHVQU2Zm?=
 =?utf-8?B?cGl6T3JEd0djL05iYnlEdGs4K3BIVzZ4WVNUeUlaS0JER3lHdGExWDZuOU5q?=
 =?utf-8?B?OTNwalFiQzBIVllpWXNtVkFYSjNsZHFrcGI0MHg0c1lEWjVUSHVsbjlBdm45?=
 =?utf-8?B?ZlZkb0pNZk5tSVJ5bDFTSHptZFJLeHl3bUxwN3IxQUxaRWhwbDFLc2dXNzVW?=
 =?utf-8?B?ZW1kakx6T3RkdFJ2OTlMSDBMMjhFOSt1Rmp6SlFrWDVDTTVreWhFZm43dmcz?=
 =?utf-8?B?UXZzRm03bUhlUFNaMm5UaG9yOTdiNDIzWDAvdGFyd1hkdk5scFUydUg3alRk?=
 =?utf-8?B?R3NNZFJSWG5jTnBvdTJ3NUlvMDFSR0Vsd3B6VkNKd0NuQS8xUWF2cHJlYVRP?=
 =?utf-8?B?Q3JMMzZudjZSVmFQUXp5bGhnYjBVMmdRMS9QRHFqUHZyT0kybG9RZC9STDNZ?=
 =?utf-8?B?S0NJOUVHakVhTkg5bkNrY3YwbExGRERwZVd2c3FYRkpZRWNtK3NMMVUyYjFC?=
 =?utf-8?B?a2dFT2w4SEtLVThqRURvakNERCtucUpWV2EvUGFFdFR0bkRQQWxrTzJEdmtu?=
 =?utf-8?B?cS9QRnAxbWZNRFplTG90dVdqV2VWRHpUaGJOV0tLNjhkT1U4eiszVi83bzln?=
 =?utf-8?B?eVAxT1hUZ2dka3ZTeG1RNVMrdmVaYUt5Q09NYkZ1bjRJajFmMGUwN3A4VVd3?=
 =?utf-8?B?eHhoNDJad3lpa3ZmNkxSTFp6ZloyMVErcnJ1bUJwVVJiRnV0Mk52RlFmUlRT?=
 =?utf-8?B?MzlsT1dnbmtKUHY3NlNpZyt4YUFIL3dWK0hSR1ZKU3RpTmQvV1dhdCtVOU1Q?=
 =?utf-8?B?ZVplaU1BTCtJaklXT0FBNHRTS3liVENBeVRHbEJQYndkaUROR1hrUXdtL21O?=
 =?utf-8?B?MGRFNHpNZW1QLzlPM2pZR2V1dUlOSjNycXdTRDM1ZkhrU1EwMS91bnJVaVYy?=
 =?utf-8?B?RVZUUmllTVNqL0FFR043UGV0aEVuZGFyZFdjSWo2VnlzYm5rUk5SUlE1S2FQ?=
 =?utf-8?B?cURsRWM2MERMUTRpQjlsOXZxL0VPSzF0M0FocGtGRjE5UUNnajQybDJDdVdm?=
 =?utf-8?B?WVBoUmx1U3Zaa3JGRytVbmNKK1VCS0gvVHYwQVZyRkkyWVVzcVRsaCtxMzBH?=
 =?utf-8?B?alB3STBUNExGU2hXUG9iNVFKaFFIZHNJOVhkS1EzQjNaZVN6NWFnREpHV2No?=
 =?utf-8?B?aVhnY2VLbTVMK3JYTUtYUjhqR2N1L1NWcHp6c0FpaUh1NE5EQ2R0T3ZDQUlh?=
 =?utf-8?B?T3dTU3dacUJYTnFOOXdHL0x3Mjhqa0gvL3RzR0ZMcTd0ZU1QQjdKUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bcb99a6-8e8c-4352-8b05-08de8f02376c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 08:48:01.6996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LYrtxOqNloumMxXAyDoGyw3tm3dRdvzKJMBx8vCAQOEDxHtd0zu6xx8nDXFKxUc+JD9FQnsGUX5Hqtnt+Q0i9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999228
X-Rspamd-Queue-Id: A1952180006
X-Stat-Signature: 5gw4eqxpcgq4wo7m9w94unc61gs1zd8c
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774946889-683907
X-HE-Meta: U2FsdGVkX18JXAJVNwsh5lSiGjVbCTKD5CppZHjzOvrs2V926L9NvCqf3qLRnpy9T2unjnfKcWbYUVGEvAHG4k/obHb92uGzkwnl6FPLhIDd1MyIr+1bscg1w3Kk/2tU53YhW0CPcwudpGURax6W4hlsXwk3z9Ki986EiEi/vhF91DOBnafEUsvlQPn+oTaQCyoxUXSC7T7IGZ0KycxApWkqFYlEJqlbe2uD8Jk+dnLKWD9HfZMNIQnTHdAX5WFmZG4LKPGlX30+Nn4jTb0Hmn56dmvtrin9YmMSPvvkFtcD2nIRD4hZPA3wE5tqUpCMEhN6wdVPJk+RD7iBhOcYEd2pr1+N7m+5pAiBPxwDDOK/lXBBPnH6eR/pbxBVzam9HwYKJ/qNVOmsyZsFS7PffRCPA0xKJu7oxqGR2JavwKFlBKOeKWjsMMXUbgjP+LXE3MvbfrnvDlu25rGjSp6kp/G/hygzweDonYptvH315PpkB7IdQes3aGlARlTMZeMT3Re5fr9m2696m2BmyDjz6qe3oFuVFxht4os6JOuNf2/23sZ6srPVBr1WCAwWK3WWdE6auo4PSNd4g1szZaJ049SyC0BwHRTnVMGv78cUIYcZc6KOKlOGzCnvIGkHXv8hVwk7a2QahPyAzrgFbo7/KDqkwljbauNnSCZgmWspqccIC2A3+3w3A7oIMYtKbNmmRRAfPAwxATrS+kXI/om5+T7oKGcrFEWPH6VixKT5Oe+WXf2o0fcJ57m9aHCUduzcE8anEG/zfxVO8MYMz5ZZ5s7k+HBIdebzytY/Blgcdg90kKt3mIMaDWtRlXdCIY6DCoeBbr6c0ySwStYilzz7bT5rSbGRz93RnNkG7QX2yrNV0Y2xnSI2p0k+Xno8DI1HN5fKVScPlhXyaDkW/oswGUb7rQl67Hhs+1xhzN8LIVPcHwwPglI+pb0hiZazPPcSIXLqjT+J2+pudeZ+LWQ
 pb8Uoc+J
 IjnqvqtIPIcbfZT/Z7oZ7aJ20YONPv1YM7W3lAYBVlu/rdgSdHehpxmdr6r6lNYLUJDd4Qe/X0TZ4/ijYrmDoBwgOo/S8tPFXCiI1FHTQ0eH+1M9m5R09zXVmTNXa4E4zjHvX6SiYMTJxtbX2dyEOtuur/rSbIaKmh3YByJOtDzrxaRr4T95jH5zN6w9CLMq8/Eovbcqi9L605gtnWhlp/zZfk7bPFr+xC5+pIbVrEPUOmTz51bdGoqDChFrGaYujayvNZGWz/cLtypVk245snF1GhdpiNmAOlK59xvwRiqtRGp7A82v3AYJDGc1sfStllkQcuJMRlDmv5RYSbB3X+iBKlVPm3Munp8WIY3YgqfR3NFrPIXjtWByEsnegUPDTsAvpJdHITbumXNb0rMBVfiKTxO9YIg12k+7f6ueDYPn9lyQxzW9VZyhPgPrZljObqmpNkTFXuPfeofHSxnvD/TyCaijytJ3yYgFeJbZRAv7OYXl0NJWgEM6rU/fCJLPEMqYR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 17:34, Alistair Popple wrote:
> When dmirror_fops_release() is called it frees the dmirror struct but
> doesn't migrate device private pages back to system memory first. This
> leaves those pages with a dangling zone_device_data pointer to the freed
> dmirror.
> 
> If a subsequent fault occurs on those pages (eg. during coredump) the
> dmirror_devmem_fault() callback dereferences the stale pointer causing a
> kernel panic. This was reported [1] when running mm/ksft_hmm.sh on
> arm64, where a test failure triggered SIGABRT and the resulting coredump
> walked the VMAs faulting in the stale device private pages.
> 
> Fix this by calling dmirror_device_evict_chunk() for each devmem chunk
> in dmirror_fops_release() to migrate all device private pages back to
> system memory before freeing the dmirror struct. The function is moved
> earlier in the file to avoid a forward declaration.
> 
> Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> 
> ---
> 
> Note that I wasn't able to replicate the exact crash in [1] although I
> replicated something similar. So I haven't been able to verify this
> fixes the crash conclusively, but it should.
> 
> [1] https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
> ---

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

