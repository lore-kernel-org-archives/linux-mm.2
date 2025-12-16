Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C58D4D609C2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 16:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CB746B0005; Tue, 16 Dec 2025 11:22:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC276B0088; Tue, 16 Dec 2025 11:22:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2816B008A; Tue, 16 Dec 2025 11:22:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1696B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:22:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACFA7605F0
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:22:05 +0000 (UTC)
X-FDA: 84225851010.23.67F3E16
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011016.outbound.protection.outlook.com [40.93.194.16])
	by imf04.hostedemail.com (Postfix) with ESMTP id D3FCA40004
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:22:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Frx9aAnq;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765902123; a=rsa-sha256;
	cv=pass;
	b=PJmpvSepmMyhzspjUab18tNRFti7Rq7mKjjgZmN5c3iUiq+dZkwoHYkfS3R9eX45alOaql
	bIAcfNkw0K/V9cT5yekrPgnW4T7XMrPN8AUNjl0oR/XZxx9BxteA/OkH5+DZnEFbBOdH1n
	hppyL4b8+OywW2H6pUYPTPv7FUOxIHc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Frx9aAnq;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765902123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5S4OivnR3mvu52N+3hB10iT2fO/KNvYyojzMN4FPTk0=;
	b=pqH1zLPY0GPJf9T8DhMxyocPQJ+GHzXpyMzmqzcYhh/SEMDVC9zHq36nMG5sySbCT8n0VS
	Js46b036zUTUTXxh9dl5LAT+3SA5ThXI6ApMHYz3wcAIDzPfVm5qaQB3HBKNHbHutu9k9O
	R9N+n/J2FOvyh6V4/C26nIHdx2pl5RE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mgr+eTUbrIK/X26GZV8S4GKLUkI+e/wk3mfyWX5OKCWbPJL1/avV6WiEPDJPxwPIMwIkVnvs4esaDbNTROtOZH9eAf3o5Tj2OLV21bY2ZGgtmkPpBxNlLQ3DfS6+U+VOE3OEyu2igodZYJ4dDYTLrdsdzoatNn5DNfvaPWVm8G2a3lv4vNpxgU/eJul/oQKUAND0flMoUiIOmw/Ow8l/bJ1X9EJL3B1ZK/aMp0Y22Q+m6GqfhWOs7Cp0bFUym/zAe7KpQrbyZqg7XM6M/AJQ5qbPCWn8fW11cIpzFkjZpeED9Tst0OnpTCCvpHjZ9Ob10w2bBF95+J7Ojo3OhpCTEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5S4OivnR3mvu52N+3hB10iT2fO/KNvYyojzMN4FPTk0=;
 b=Jjy7eNMf9eLAwe4CHpJB7wVCukZxOEwaCNRVO6T/BeXVqv/+p8eiXx4QpBNEHfUMcssB917VTtmv/SLym96k7YhREgTBmwnUBIL5w8xE45Su1w5+Chg5a5LgdPuROmbU9LmN2gQ0TPzV8jEKQBLFPjf4TvpGyzzZLOItNlylOp7x5bwGyI9QS37i/kA+LUnkRkyRN5xnGjr52JtJxbYZcjv/9VC41ltbw8j/lOF/1+Um71EQi0C42Bud5PCXuzFi4FSTftcCMKWHekKHC7X2MFIIOzGKZwpWp6DdX2miExlAY49K7Q5CbkpZPogppXyaxLzR5fjfqYaaZKeQ78XpgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5S4OivnR3mvu52N+3hB10iT2fO/KNvYyojzMN4FPTk0=;
 b=Frx9aAnqq+t55vvdzBqAGcjdyZHTd7QjUpjoWYUQNVNgPDvIHws1+6s4rpED6m+928TxEO9uppPuHEGu+2KzwMR0RxwOnyiPSif68CuWhlvws2xMn0EYuoyXGe7i/i8ISoSWtsmRiZFhPQlb6ioFZiNvHFJtwUIhGaaFvXKoW2b6D1l0YOE8HUYb8bDg9AkJsbcsv+nlHDCYgDSgJ+wsh+StfAt4dC9eDp0lrpf4aXw0nuesB+1zLVURwd69qW6dtmNHULPEd2XQhoyWqWmWVm/egtbiV4Pw13MO1bfTCF+eni4Ilh+6bVLO3jiNPkK3kJJq4U1Z9J76lNknWPp0iA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4301.namprd12.prod.outlook.com (2603:10b6:208:1d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 16:21:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 16:21:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v4 2/6] mm: page_alloc: add __split_page()
Date: Tue, 16 Dec 2025 11:21:52 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <130003EA-0DFF-4C32-ADF3-DDB800494264@nvidia.com>
In-Reply-To: <20251216114844.2126250-3-wangkefeng.wang@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0952.namprd03.prod.outlook.com
 (2603:10b6:408:108::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4301:EE_
X-MS-Office365-Filtering-Correlation-Id: 771a91ba-8600-4e0e-a1d9-08de3cbf3a82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9J4d2FydGMAELTj3hHnWEl1db+AAMamKK9OB/hDxFYqDq6CUxILkfO8JQctR?=
 =?us-ascii?Q?Neuum+KwMOIIFwgyxq6NSRy6IoTd+nkoEKchGIvCKgJiNdQ/Uzyo7dBFPdWC?=
 =?us-ascii?Q?0SvMSa6mUpCkjRF5D7gCzzLy9cetpoNf+g5vC/eITgY4O+rhvMcZjCNlPlxK?=
 =?us-ascii?Q?rsDeyFXA44s8+kDo9xpunAH358OejM8goaW4i+3eNnw5S/lh5HDHfhgA/X39?=
 =?us-ascii?Q?Lephp1SwFYKx9FabqoWIVBhws00+NEjVFu78MdTrEy5U013qXd6CM0FzYmPn?=
 =?us-ascii?Q?OxvJZBzqQkTF6SRo/bd3PL1j8f2GN1gdSV8RkmBrX3oR6oYEVag/HwqCHdCG?=
 =?us-ascii?Q?H6sE/VsxFcMHMpoz/b3UqqpjJfA8DccZSiGvoHx5I8eTpU1SCseOs/DSX7yf?=
 =?us-ascii?Q?BSVSI9yKlG++gHnozTBWmZBXb71CXAITcsyUW5WnI0Rltd0AtxOhimYpedN+?=
 =?us-ascii?Q?wzovUf/8LoUrX72Hdvy1+WBGeKLm+TD0A5U1LefN1H0io0enAmdEvN6TPoC3?=
 =?us-ascii?Q?ye6ZztfcpoO0ll/rb+YbBHjO8xOvKqff7g6msIiMRyhTQw2mrOuSdMNFWXd7?=
 =?us-ascii?Q?p+taZ7bcYNqJWiPDlQ9JorDDgP5CpuSJVMFFo9LIIllSoq+iIF+7ZawtJsgb?=
 =?us-ascii?Q?A6otx55tIjjIs5teTeiGto6h1a4eYryQDwc67OLdi8EK/iyo2L8k+PRw/hMm?=
 =?us-ascii?Q?e4QgE7SteWrw3YwDzDb/SpoHCIS9WjfdVmGEQdWdMFUYBwj4w8q9jlifpPCm?=
 =?us-ascii?Q?t/QkJGlEFsSevbGbSr5KdZR9Qi5wGmC/Okq3gPyc1SqhnXm4Mp6+N6MDJULc?=
 =?us-ascii?Q?ionf0LRwFrL6AVOu2QW8HYqgkTgHduP3Mq6qH1UD5hHO6B6fzv+4pFTGhDlu?=
 =?us-ascii?Q?pdyDhnqUG3EmXoga1/CDR1zprSOC7XoGdh2F1GE3+8eM2s4kANXa5fbnFMF9?=
 =?us-ascii?Q?RgQCRIE8m4EKNQ0beydRveg4tamzMFMLU7i/N/Gd3+aCDegG86w2jBzC7fuG?=
 =?us-ascii?Q?KYE8G+CfDhAseDvDBJuWKKqRNz26VAA2aSll8e8Dy5tKoI/fe2hp+hWxAXBi?=
 =?us-ascii?Q?XqZh6bDyCCJCoN8Su45wX7mj1Luymh+0ZHm5YisIe3s+S5IC2BdPK+QaHoHM?=
 =?us-ascii?Q?NY62tXjriugE8drnTSfu/R8ttRPdrqk17ZIA6McdMaKY2MxANKJHvdnX3D+I?=
 =?us-ascii?Q?heE5t32Z+v63HQ7+zU6i4C5GSkKfCuNwZcsk/V81Qg8G0k9ByZuEgg5wlAJg?=
 =?us-ascii?Q?SS/WP9DrOxdlFGSncLYbh9ybmueGt2UxaJmydujpAC+yySjXcKXOLB/WPiAX?=
 =?us-ascii?Q?Behjo7mMXWZtm9v3iONK5yfCj1hshITfrlVtWO2C56strQR81FZl5op9Km5h?=
 =?us-ascii?Q?Y8HuGhGLZbbSUPk49MwvyhvmV7weNyxTDBhH34cZ/eilLG/vWSpRG9BqIyNR?=
 =?us-ascii?Q?gYI0hnn50Xa4fhivAtSqEHd8K/nMbapm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cYbhDCKC41gNaT+P2VdB3M3KAhc02ZdXBJATUW1i6nOBDianyTGhtD0sofvh?=
 =?us-ascii?Q?btNgLEvQ48uxBkbk5HVS5VH6+xYxngd/2W0od3AUhJqiliRMUnD7Apn+jtGz?=
 =?us-ascii?Q?cy7bjv50M+CrRqfex5upQPYwblm6G0HDkGYZfb99RMy5UrpBDJKX4UbF6m1u?=
 =?us-ascii?Q?PukNSaxLbMhzm19Mt5aY2fof/vWMFKXlnDSdOGrYNn2hxR2N3z/oavbjMMc4?=
 =?us-ascii?Q?jUiJnatDt+dkNvB1xZ4cGIWf6nMg5ltkxc+Cq7EovHbbkNZgHLeQdqQasu9M?=
 =?us-ascii?Q?qMrGUbCWSW8+uqKlrt2kN/nwEb9N+LVa0toeVdAp/puBh4rbB4dpzIRxawcu?=
 =?us-ascii?Q?dFBIKWqMiEVwfWaVIfeD9ky8XXLFApRYb6v7WlksLs+5FzqA//Fb3s0MJLiv?=
 =?us-ascii?Q?Y2uaLImHMWhmOxAGgRC4jiYmAHWCpIG/whzNa7jeulHIwb9kZ4+zPDxvF76b?=
 =?us-ascii?Q?gB1uRkLEg6PWC/ya+eu45yH7yntrnYsl6q08GwgFyLPGuLUd8QxoyAYuGHHw?=
 =?us-ascii?Q?J65qV+BlTXLdQv2NUqlrwhFcazUSMKzwXOVd/2HzVnngLa1y+oyTBjbu595J?=
 =?us-ascii?Q?0gM3zOgf4TkwbF9pPCT4OjwRZdI2q9EIk4zFBcNS4oC9tasaJqnMA8CQO2rs?=
 =?us-ascii?Q?i0OyIqKAMzq3jF0/sBJhZDDhDmbdYGSq52dClMzeWy/umyKN0+4O+R/7+lI0?=
 =?us-ascii?Q?0ToLsEnbdRY7lOxG32t1vCL2YhvB/YOM0ZqqpSS7aNBRKf0I+fYfHgTefHof?=
 =?us-ascii?Q?SW2UdXO6jsfHNHvklWsFWTKuIpSVcTbdq+vSmOwfgNFl5YlK2nwRwSxjBtzj?=
 =?us-ascii?Q?M28hyCqNiV40zQeE2fm3SqE1assqRfN8vIs0P+h5iKaaeNNAtYG7CU11akk7?=
 =?us-ascii?Q?zFROSVeQJR6xM2Hkim3p7o1Y6u/QygT6vvpezu+9FP2nmtkGZwzaM2kgYvSt?=
 =?us-ascii?Q?ykc9a60G4j3GQF+n6MKMJid0FTTnJExDR2JuiK1AwYBbR23l9oEdlskDsGk0?=
 =?us-ascii?Q?b42IvDlAYZlG+kFpzjpZEhzfYmtX1ZocX5JicfPXNvjcVXL+LgZuMPzyH+UQ?=
 =?us-ascii?Q?VrBIIIx397FA6wsAERi7a16IhVRQ0VJMx77uSZLL7oUkuAb8Dlt42j6cg3VK?=
 =?us-ascii?Q?P1l/G8lg2ag4D5gpxzlbVR1nsDiwM8rJVEFhIG0eSqM+xiEk64f1nt7ik1Rk?=
 =?us-ascii?Q?CzRi6D6tW33d00x/O0rSDdB89PWp3V6ZnNo/pDYTxWEETd2/n5cGiLuB+8cw?=
 =?us-ascii?Q?zyV7web8WDNL2593gvV9uOe+z42HWTte7VLbD5eZcbtdC7l95hM/N36dt3Ab?=
 =?us-ascii?Q?NvgN+mGGiDrSbl8VpcHzmUdoJVeqylKb8e3c708/0jBh2H5KWSj3CYNWmTQh?=
 =?us-ascii?Q?JB3pkc4JChlkNQY5GKytcO9cdVLGwPZ6BB1mzZtBl8ELcvQrqvuiN28scJ2V?=
 =?us-ascii?Q?A8pPLnbaX4ndKentlfBeq37F0srBXO/Y39XovUGku9D2go32EmkCy3qqeilm?=
 =?us-ascii?Q?maQ/bJk9OzSA/qgAKagj9DFjgSJaiOG7fUgdoKlWGjpuNNr/yS5jOeoh/oUm?=
 =?us-ascii?Q?pnh5hqGVcSKgkbdpsVIPQIGrgJqaQt0oaAE3t2Wu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 771a91ba-8600-4e0e-a1d9-08de3cbf3a82
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 16:21:55.2666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9FcVEaTTd7HgAhck3vtn4DLEQQkp/dumhIKYs/7uhMpR0XUsg2cimvssBuk4EDWA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4301
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D3FCA40004
X-Stat-Signature: 9ng1gk7b467yrhbogm5noe5bjznambbs
X-HE-Tag: 1765902122-546207
X-HE-Meta: U2FsdGVkX1/AnQvJ4t2QNrPNF8+NSZiF62i4WGhwDJS285B51KPwVB0GrhVHcGyAgP0zmOUlBFj/ztfxTAEMdRRRkHHDihYHq86rX9Sb5F02KlhszpBEQM7434IJBMztnvIu9jBLD0HMVLclQgc+J3fNtOYWUkVL860RNjneK2s9bTwTpUvz8sGd9mEZRCipkOSA/XQbvHsZ+plcfu9opqScm7yD9reBaYFvAxqyBgLopWrVe/WZtweI/w0da599GaYbV7Z8TzqS73UqVyuvRWpB+OwByOOc1mii8U4PegjqjXDbCKe8XXdJACOlr7MY8+UTdDGLFqqfo2/EBMWu1G5UAfY7HRMnbpiJLx5ahnIWSIx2wvabfMF9HtCpF+5MfyqlMs1uJNsCUctTkTnpmzUsZsCFH7cHD0LrpfNUGCz71i+jruT3b1BvLYJLUCQPNuzyB3i0nQzpeaGN3LmiMHAA0hIL02fbFNwTDdlfz8cnYuAjoDFhlwzQG1r5B5QZLw9o/J+n1zkA+5zjFTETRKc4yv5p65jFAE+hcrhRzvBmqchjNTP5z1BTPDed3H9G0cjDYVKD1IUZBBp0YXd64tLPH1+wEQBveSld5S2QNMZUYgtdlz/BleKupgsLv6CI0cFrs0JV3qktv2kI6P9D8m2BfjvbYbxMZYbTRnUT4waX9Yb03oI/Buq1jc3m+p0wnu+FLJTtx+SNLTGyJ//rZCO1rb/O+O44ZR/Yedso7NVRsXryx9GA6bIgYz2emVmcjSnSmm1pe6YlcA8YppNVDXfgS4X7VgDEVFcgJZ+MTifuV1CnPAA1WBkTk7pO5jGz75eIpgaHdAXdkXyhpDZ7t8KUwtFvHniL1C4AIpvdn++4eUdXkp4ZZW20OZwrWoWAwh1LKXPW8RKo+B1/3+5WcCRZLYVqAPStqTS+JzXuBwA7sBrPZxWIB2pYFxtPJjQWKAtxYOGXt+3U5RDJgWe
 OuweW+Rk
 R7UgAtgRMPqiu7n2+UcZLTn/ZFHMlnWiIKxGbTPuLR7r8JqJwsPSVCbXoHGAEZqpd9Gcy+TCwq5d1cXm2g4B41Qs1WG4vchfvD/dsSX9AHO2tgGwNRG8C+btxuuqblDZD/M/6T7Cqvgg1QwvzQIyoZOEm9nRmMLYAcjHj8eKn//gEuOdpkUnSy76v3nhaXDU6sp+PDNvhco0rIHDSfslGZWV84mPjWb0o5NRlk0Un+QB/TLZeaG/MjaqUNlNLXQ6+rNYJ/yo968uomjacUB9YHHHjALugZ3gHe+5sJYqN9BEx7ED1jJCPpB1SCxwtISQZdzqHyRusPesbWwRXMT8skvdHr11EP/NUghMUq6BKZJZbOjyr2d1m6T0OVQcToR8XAxIqAmIB7qVEAKoyJ665txU6LA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Dec 2025, at 6:48, Kefeng Wang wrote:

> Factor out the splitting of non-compound page from make_alloc_exact()
> and split_page() into a new helper function __split_page().
>
> While at it, convert the VM_BUG_ON_PAGE() into a VM_WARN_ON_PAGE().
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/mmdebug.h | 10 ++++++++++
>  mm/page_alloc.c         | 19 ++++++++++++-------
>  2 files changed, 22 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
> index 14a45979cccc..ab60ffba08f5 100644
> --- a/include/linux/mmdebug.h
> +++ b/include/linux/mmdebug.h
> @@ -47,6 +47,15 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>  			BUG();						\
>  		}							\
>  	} while (0)
> +#define VM_WARN_ON_PAGE(cond, page)		({			\
> +	int __ret_warn = !!(cond);					\
> +									\
> +	if (unlikely(__ret_warn)) {					\
> +		dump_page(page, "VM_WARN_ON_PAGE(" __stringify(cond)")");\
> +		WARN_ON(1);						\
> +	}								\
> +	unlikely(__ret_warn);						\
> +})
>  #define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
>  	static bool __section(".data..once") __warned;			\
>  	int __ret_warn_once = !!(cond);					\
> @@ -122,6 +131,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>  #define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
>  #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
>  #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
> +#define VM_WARN_ON_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
>  #define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
>  #define VM_WARN_ON_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
>  #define VM_WARN_ON_ONCE_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index da32397b4313..aa30d4436296 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3077,6 +3077,15 @@ void free_unref_folios(struct folio_batch *folios)
>  	folio_batch_reinit(folios);
>  }
>
> +static void __split_page(struct page *page, unsigned int order)
> +{
> +	VM_WARN_ON_PAGE(PageCompound(page), page);
> +
> +	split_page_owner(page, order, 0);
> +	pgalloc_tag_split(page_folio(page), order, 0);
> +	split_page_memcg(page, order);
> +}
> +
>  /*
>   * split_page takes a non-compound higher-order page, and splits it into
>   * n (1<<order) sub-pages: page[0..n]
> @@ -3089,14 +3098,12 @@ void split_page(struct page *page, unsigned int order)
>  {
>  	int i;
>
> -	VM_BUG_ON_PAGE(PageCompound(page), page);
>  	VM_BUG_ON_PAGE(!page_count(page), page);

Could this be converted to VM_WARN_ON_PAGE() as well?

Otherwise, LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

