Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA8B8CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EA7A6B008A; Wed, 13 May 2026 05:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19AB86B009E; Wed, 13 May 2026 05:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A306B009F; Wed, 13 May 2026 05:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE7156B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:01:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D948160978
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:01:25 +0000 (UTC)
X-FDA: 84761802930.15.9A9FFA7
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010044.outbound.protection.outlook.com [52.101.201.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id A4B9E8000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:01:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hhqhT5AJ;
	spf=pass (imf02.hostedemail.com: domain of dtatulea@nvidia.com designates 52.101.201.44 as permitted sender) smtp.mailfrom=dtatulea@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778662882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHWsNSGe4btIxjBPrpEbAKB5ddDPX54C5780Xr7IFzk=;
	b=j27+QiWeHiMlx49EcA4sOXuBSrVhT24/gKYj5t0w1AEyjBai6bbvYbks/t+nU+1IiNw7wn
	0BpOu3Rk6m/Z9SRcOMHokfBLOHAeFrC0ljYeYZ+6814qYVPrKMooIqSY3yjy7xd/+H5vKT
	4wawIKd8sY4OtTW7VKZJaRDIS07sRiY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hhqhT5AJ;
	spf=pass (imf02.hostedemail.com: domain of dtatulea@nvidia.com designates 52.101.201.44 as permitted sender) smtp.mailfrom=dtatulea@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778662882; a=rsa-sha256;
	cv=pass;
	b=6997y3y0Yt9T2QFA7XHnQrgXKLBsPn3EZGHkhGDeu1wf7xQgU07+L4xj6Na+8aZ4yX/Jzm
	9TYW34XcLmbkru5AmB0LxeCOtMeyRTUFTVrduDHvIyk53Orhb7ETdGsDBjjIS5TKt2ulRT
	SWSe4tJl/ddPiXHanIzAi2dvzUXZm4c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJzuhOFmNoJameyb4+WK8bvvwcR8tMrncmvjRvPgkv7HhWrXO8m9Ffrw5/dcHXpJJCjvkTXfhyjfXEhNOz7zDskDCQK0hEUqGJzLRfS/S6xA47d4dSvyJOFN2E63jrbIHIruQPyUpDyvOiYPAE0hmEuzSnN4XWnO+KLEcdvIP2rDI5cqLB/48vYNBrEAd2TMzBKv0l2lXvN1Gxli523NkdBKvYRDZPnoogiebfffvTL4Z5l5S4Ove70efnkD28aEPcxAVnxw/ih7yHAuSa1VU6vC34Jh4qoRG9YbpVwD3DE+LuYhr4FcloLyZu/Ly9o2rD0JTpwQnApKjhLXZOXLtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHWsNSGe4btIxjBPrpEbAKB5ddDPX54C5780Xr7IFzk=;
 b=XL5hYLA7dwP0f2UnJEJ8Jou2WvX3LpV4oFTOE/ztLzL4c+LeeagQv+PCA2Z6vF8s4ykGIdiUog/EJxRBe4PKjuIcL6zbgfAiZATywQFzxulF4l2NU+ihRiItoNbAvFL+inFzMbC/iYx1Kb/N+hsWF+eTdoiHIAXS8kdlbKob9O5/86+ehITIMcrhkFsGHtb2DICeH0KGGFKDcbtciE4XJyIV9deH+e6hZv+XvlQ8TU7XxPYb0PTUJLXf68nOoYTgHLZvam8Rqp53dt3HVFSYn7+mE7qHZbjU4jej9//p1DL5TIfnLWZ6ChL5pKDqnRYS03IqUmn5kb/QD2BNoqmVaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHWsNSGe4btIxjBPrpEbAKB5ddDPX54C5780Xr7IFzk=;
 b=hhqhT5AJdPKnbfnJ9hONldCO/zgnv0QnaTdl06DrbOanndWtq2kpwAUUaTtg4bEuPv0tbRx9jJ+6fcCKmM7aC7cfBbLf22nMdd9mDKnnggAhVY378PNS6z+uWgsZR9lUPh+IBSdTGch+bYco6GjwzLv+Zc/Q8OLkooruGNJ2JucHpOd84AV9MCzqNeUeuPJn/IN2NkbRZXuQJ6ynRGiVekwSpjgeKFg3aHOdZdNbNoOVdGxQaT+RRaqIs0GfrELCkzJmWlnsZSYaWT+iTI96nVbC/7uynCVMF25nvy2Am06NKS3wNLp1xIDPt6nxdsx8Eoi9S2j0+EeRdJQd0/Q8QA==
Received: from IA0PR12MB8716.namprd12.prod.outlook.com (2603:10b6:208:485::18)
 by PH7PR12MB9221.namprd12.prod.outlook.com (2603:10b6:510:2e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 09:01:16 +0000
Received: from IA0PR12MB8716.namprd12.prod.outlook.com
 ([fe80::c18d:8eab:b36c:32da]) by IA0PR12MB8716.namprd12.prod.outlook.com
 ([fe80::c18d:8eab:b36c:32da%3]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 09:01:16 +0000
Message-ID: <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
Date: Wed, 13 May 2026 11:00:51 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com
References: <20260224051347.19621-1-byungchul@sk.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20260224051347.19621-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0093.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::18) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8716:EE_|PH7PR12MB9221:EE_
X-MS-Office365-Filtering-Correlation-Id: c5c8a412-45fe-4226-96fc-08deb0ce29c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|11063799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	fvva++7zvhN1Ou+9nx5owi3opkAK7Fbb7WrihxLVI+O3lUoMJ+HCtgFw5VRZVf5b4AxtHU8vggV3KvbHNlU9DNvITqMYjZjY7+dyMz3cWEV0ZIFTVvBfxPQPSNI7UvJ0JxujuRPbPCcGt3Wp+3v7SeCsP6YAPZ6uDthmtGKKucSQlmZJA976xQUw/No2F9PcP5+4RbnF78DdpHnCZHRTBP9DB2hpWxwA2isxz+KFEAlh4uwWwKb+Uhf6oihvp0AM6WMBDGQy0AOF/hx+UEODjkuRrLP/S4xIzjsG9KWxlF8Etje5tGmeBIChvxPWRrURgPgcOMaiLSu4S7AavG3iBoxtT7hezoBRNDoi5ttSAKS0FwrNkEJxdLR7+9vbHONhyw8ZGzrVrXmxoy0cZA3BD1gHYCxQzWQz9X7jbsrE88EK8HAwXICsNSmNoDJfGC1Bia8g78VyoW4BJ9LbcRLToECg5/yoldGiFcJVPXBP13qp3e90+eJJtVNlIReNruhpFrXzxBKGmRuTl28r1QO83AN1bGavCxEKHL9vzeJje/89KEA9Bh2cdPrniTIhprg4QRMU2VuMEl60fPzQK8JBF7tO0QEvgjumKPE8cYGm8JnU2bEhmBaXD4rma0oIQtpbWgr0jKmcbDknkFaLeadU1CLOpCMiRNdUwBb4wNswkKRfcXqa1x4MPuWS8K87rHrzYryPcbf5ITIG5npASuWqHw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8716.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(11063799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUMxL2tFbWFmcjB3djhWVllENUJYYlloc0kzd095OGlYUlRNdjdMbmtGenVZ?=
 =?utf-8?B?bFNnN1E0MHpIdGZpMFJZZlVzN2dLRHV3SUk5VFBKVUcxZFBaOWZDak40MUJV?=
 =?utf-8?B?NGpzeG4wOHpWcXIyWW9kMW9vZHhRWGFoQ3JkcEM4NWFNWDgzZUFOVGRiU0Vu?=
 =?utf-8?B?dHZ3VEF3bkNrdlE1V0toQmIzanlsTC9GN3ZKa2RlcVc4aDdSZmhGUWZSUjFH?=
 =?utf-8?B?MDFhWVJLU1p5RVRKaG1qVHhmNExYdGNrYUNFQ0tYSEd2SHdJSm8zK2dLaisx?=
 =?utf-8?B?OGp4Q2VHVm1oUEY1V1U4Q1dqU2xhMUpISWwwZk5XWituQmhSdGE4eE10MDlj?=
 =?utf-8?B?WDFIYTlyZFBraEpsNkh5WjNEcTNQd0gvRjFDcW9GZGhqQlAwdXg5RmloNW81?=
 =?utf-8?B?empjRDg1THJZMHZMbkp4ZVVvaThBRFNRMm1pQWtnbG40aExDZWZORFVXRjlJ?=
 =?utf-8?B?Q1RiQ3FpcDB1TVF5NnVQSFdyalExM0NDakw4MFJ2VkEvdi9HeGMxYWo3b1M0?=
 =?utf-8?B?UUhEN0ZrQ0JHVU1xYlIxanhiSDhBYm5jRHpPQmdMK3E1cXlaOWsxQzJSTldx?=
 =?utf-8?B?UGVmVGJhbHFHVUN6TmtBbG01M1RWTWRIcVM1MXB4a1BPVEhQVlZCc3B2c3dk?=
 =?utf-8?B?ZkVMNHU4REltTTdIb2hIb2cra3JvcjZGTmk5dGNFRzU2QkRuQ0Fwb3VKOXc4?=
 =?utf-8?B?Wnk2Vyttc2FBanYxZ05BaXVPT0FLSG9WTTBYaGlyMUl2cG85NEVDNVoyUlFJ?=
 =?utf-8?B?TytQbnBSc2hDQXJZS2pLUG5xSURadGxaV1RKeEFGc2hpa1pidE5vd1IwYTNj?=
 =?utf-8?B?cld6MC9IRlptUEhrTXp5SDVmMmQ0ZEdvcHB6S3ZMTkVINUxNMHBkd3phajRP?=
 =?utf-8?B?d1p4VGZTNkJSQkRxNkRuY3B2SG9MMW9GYVlCK01CMnY0aTNBd2crQ2RjK3Ew?=
 =?utf-8?B?UlNxZjB0MnBBTEkvMWx5aFREVEVyR1E5czZSNHdoM1pNZDVrRlI3amRhUGs0?=
 =?utf-8?B?VFRza3dQOHQ2ckJ6cW9VeVFtNG1OZmFSUU1DQUNhVmNmZDNYZjZqemlKMmhR?=
 =?utf-8?B?U2dQRkNCNEVqRDFINVc4cVUzUUlxbVFkMVdGT0VWbVFzRG81TUxGQjZIUndF?=
 =?utf-8?B?OVFGdXcyQUpJbHRqZUhteGRWQnVkbm9vN2lCL2tpMDdHSWNvYkV0dmpzRFZY?=
 =?utf-8?B?R3pRT1I3V0E2MWhwc2paVkVoSFpiMDVxZXBISUZaakdMczQwTHBVVWJxYTVI?=
 =?utf-8?B?djZEVmdrMXR1WUZBaTd0V1FvbHZnRysyKzRhOGE5S1BPV2ZHMVFMdlFJblJD?=
 =?utf-8?B?NGhiQzJLb2dEbVFMb1grTDlXUDZUZFZycTFabHlQWEc0TFgwYXlrUDZoU0xk?=
 =?utf-8?B?OGJsVW56U0M4QWducWRkanphcmZENWpIcms5QldmZ0wrSGlKOGlxVUNGMGlR?=
 =?utf-8?B?VVVRakMydFE5akV2QzdsVkVEVVpreWhvbVVMSVFReldWeVRmTUpHNWt0a0oy?=
 =?utf-8?B?cFI4RVU1cDRyRkRnRlhiRms1dEpGWTdEQml4Y2w5S2MzOXBDbTR0c3pvUk9Q?=
 =?utf-8?B?UVhKWjVmL3VOMXAxaUZkK1owQUZvZUJSV0hQdktNeDcrV0UyT1V5Si82ekZX?=
 =?utf-8?B?cGg2RmN5bUhHa0h5R0diMTZnTG1ROUJKZWhaU2VTUWVvNzJvRmRNTEUrRGwv?=
 =?utf-8?B?Z0hROUxPSjNhcmJGaG9ZcURsL0VpWEJmSkx4QWo1THRWMTkvQVJ2bDNpd3k0?=
 =?utf-8?B?VXB2UlN5NFVOMFpaVjh1c2I0S0lvbGIzdTNDOWFYQW1TL3RLTFkyMlI5cktX?=
 =?utf-8?B?am8vanhKcjJzSGlqNjhLUnFsNXRVMjhHaFNibU9JZnpNYlZYL0lHSTllVkpU?=
 =?utf-8?B?TlB5d0Q2akxFd0d2RzIzamc0OGxsdFF3SVpVUmUwYTBmQWR0YTFucXE5ZFgr?=
 =?utf-8?B?YTF2MUZkRUVwMnFpSFcxblJjQVhlMUE4eWtzblJqbndWNHNLWWp4eWVtMkl2?=
 =?utf-8?B?OFBtSWw4Zi9pcUc5b1ExWm5CQXkwamxuVjNvSFk3VlJ3bVJNc3ZPRmEvZjA2?=
 =?utf-8?B?eDdjYWljUzB0QWFQWlh5c1RBUkhUbUJic2JRdlMrTytrNmM0UFJqdTU5S0dy?=
 =?utf-8?B?V0pzcEVwRStlNVJQTFN1Q08wMElkdkg3SEJ0N1VOWjM4c1BJazk2U28xM3ox?=
 =?utf-8?B?VDlyL3pTRnY5UlBneVo4RUF0V2h2cDFwRDFVa1JETTJHdHZoSm1MVFU0bEZR?=
 =?utf-8?B?QXZUNFRjbHZrZ1Q4a1crY1RwaGpmcVQzcWloUjB1SHEvZktIZkxzNkxQVWVj?=
 =?utf-8?B?dUdPKzNGWE40ajRTalh2bmVSYTlWSkpMb0JQeUZxakU0dngwWlE5Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c8a412-45fe-4226-96fc-08deb0ce29c8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 09:01:16.5905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /x4Guh25fP1dlvVEXZ70Nc5CimWxVjlBFuxqYlkc1noGqHXoayXDwhEry1lZ8Nm897zKVGRfE075zkbSoZ2mFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9221
X-Rspam-User: 
X-Rspamd-Queue-Id: A4B9E8000E
X-Rspamd-Server: rspam06
X-Stat-Signature: iiiawsm9gkmakkrcr44ij85e8jbx58r8
X-HE-Tag: 1778662882-36424
X-HE-Meta: U2FsdGVkX1/SCoULvpJDMNKQG+a3AeT3v3X6buwU7D7LtUBtYzTVt0S6tNcSyjRFILrOrsHgTao9gP4JqMOOmEfykGW1HvNX2luyBe38Y2ZZwQlthnDT9UoZokhv5l4x4S6KGpI/+5BTwfpiLVXe7OiJnm7Hg5q6xsYU8JseKzOKoqiq0EAuMIqGuZP8Fnjda8kooWXfWLuhsoZHEFA/nW0afdmbhOcwW4lJ4QM6rWlxnn2I1uPYnMxXdpeaC8htSNQRrMuZazJXmWI6nzBCmKzVmrvV4tg5eaWyan3SmlAAsC8HDSWa9+O1IANbiG1FOg6kFoTToLFHs88qlHSX8BxIkswRJmX1a86ZOl5gd5frk6pskok5blb9OtCOR/n5Esq6Kd2c2OP4Zhkw3lrZsxFs2LfZrVOPd7Pd6S6+hp5h3zhPb/s6g7Bz+aM7wAf9X/ljabqTWRPw6HEQRMu1LKJYof7ilJzOVSw1h7sN608iDA122FNCrzaK1M4JEOcaYfp4i8VVlBF5mEQLZyXhqJzd7N5rlLWQguSjNHrduVts3V1wElP/FfihmwXe2QOG92KSvkpsuVfhcgv5HnHq4qL0pjsgeEGHvnce5ZWxazo25ccBl47T6xPm50LNb2n9uJs9pYXgEIcsiNCQlZy2vgRAewnyHwWa7zdWrOqOaIx4mxBfwJAB97PsxbDZZMuFxSoZ3DoZNamgcQPnyssU2MRcfLzcYVA/0uo84Y1yCRXrTNoNxB7Ec3NNegowEeigKdFBb3ONLkz05eokMNdSBndLsaW0SUcr8jIMrZXDuMt2G1WQZfX67UH9fbNQuhF3MtCPQJdw08mzFe1miE9FosSbHWqBI7dM9qYs58mKCkhH6nq1siaJI6OWJ6BRwuNuenMjDrgb8/xhP/DnZRPjFlm03WwGhzSKQKLsTighy4SoyJE4ghosNeUlFYjXbxy0uDaydzVB45KUmk4QQIC
 c1dls0uA
 HlymExhR3GV8yx+OtDPZc3MbsbtR9UqN2feWIxYovGNjXcKN9PsIxej91eO+dDiqkurQS1JiAF1DTw8gDLfTPQPE8u4FZLWvDhDZ/Ci/VCTtnD2Xt/WB/zAqYDBbMtJw0H9yUU3r7yjsI4eM+0g/lc4ktyKFfrIIAvyeCm6pU27SEFnVNfXyhADR4CNu9Lr5L2In9IkV04j1LovI8/M4/6o+pSrRsxRxApqVhdutH8Jl4KyTdWbuVdflkBvmkPB98nsbrMS2BPLQpeDdRK35A+ewj7hKIEp1NmsAe8cOfBWMEM8mImfeQ3B0GQADb5NlOz0gc/Tl7GAr46c94t1ecRU7IIUxqy2/8ApZ9W2/988Re4/3YkXrcCljjOhIpj/9ZGpj2L++o06aa/z/LZnxt3n7zHFsKPrJfxvm+hQu5hll1KfctIld9JN9Pd88AQ7HBPfs92WC5kmtvNLxJI0Y0LwFI+BmXLfqnZEFiEFd8728VQS36aUFgY3VejgYj/pK/tEiSNxYhboDui+gWXE+CD3ZzSX06cgo4M9OYPkVMqgPrlpcCyVAnVEzzVoQs752q7YO08J8lpUhuU52u8WAroI9ZpGwLcz/KllkR9W9FdgfKcnAQ9tLR3yjazB7Pv5qdRhD/bcvFy+qLf2l1qb7KSgW8bXiaxGsDVDY+Q0VKeCUYpFdo9MV+zzbc2kW8c6qCc5z7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24.02.26 06:13, Byungchul Park wrote:
> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> determine if a page belongs to a page pool.  However, with the planned
> removal of @pp_magic, we should instead leverage the page_type in struct
> page, such as PGTY_netpp, for this purpose.
> 
> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic().
> 
> Plus, add @page_type to struct net_iov at the same offset as struct page
> so as to use the page_type APIs for struct net_iov as well.  While at it,
> reorder @type and @owner in struct net_iov to avoid a hole and
> increasing the struct size.
> 
> This work was inspired by the following link:
> 
>   https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> 
> While at it, move the sanity check for page pool to on the free path.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---

Seems like this patch broke tcp_mmap because
validate_page_before_insert() returns -EINVAL due
to a page having a type. Here's the full flow:

getsockopt(TCP_ZEROCOPY_RECEIVE) returns -EINVAL because of the
below flow in the kernel:

tcp_zerocopy_receive()
-> tcp_zerocopy_vm_insert_batch()
  -> vm_insert_pages()
    -> insert_pages()
      -> insert_page_in_batch_locked()
        -> validate_page_before_insert() returns -EINVAL
           because page_has_type(page) is now true.

The patch below fixes the issue. But is this a valid fix?

diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..4cb12673f450 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2326,7 +2326,7 @@ static int validate_page_before_insert(struct vm_area_struct *vma,
                        return -EINVAL;
                return 0;
        }
-       if (folio_test_anon(folio) || page_has_type(page))
+       if (folio_test_anon(folio) || (page_has_type(page) && !PageNetpp(page)))
                return -EINVAL;
        flush_dcache_folio(folio);
        return 0;

Thanks,
Dragos



