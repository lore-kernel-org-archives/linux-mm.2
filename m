Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AFBFC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129826B0490; Mon, 17 Aug 2026 22:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA756B0894; Mon, 17 Aug 2026 22:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B4B6B0896; Mon, 17 Aug 2026 22:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D05A6B0490
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:10:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A8A71609C1
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:10:48 +0000 (UTC)
X-FDA: 85112761776.10.1A458A6
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013022.outbound.protection.outlook.com [40.93.196.22])
	by imf04.hostedemail.com (Postfix) with ESMTP id 348A340005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:10:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uRsteFZM;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787019045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/Xq8bhfX9FBjR29vBvlhJuH2gdShXw1/Vb9mV/iH5c=;
	b=MRVCYfrjIGHxzqwTZ4CaifvPXh9o905O6hzJFyGZQmoJvC0/R3JlikxMCsmTiVfuTJi/qk
	0TJW7NQQrqq4rJUdoD3SeKI0y4D3hq0uuT9l+xvoEFWRLXFU4vOKb0diXMv8xMsmiGcPr4
	wBjTxcpvRercFVYCaxsZ9aWCBob8eAw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uRsteFZM;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787019045;
	b=7J1kGjcZrrY6PFyCCIgqFhsKRgNJj1urQgubLZTYKQZZdDuAuse028s48jVLDC3tsIwcpt
	Wc8P+o1aA8Y/1sJUMQiZrmRYBgKw2thzwYig1tmRCqFk2CIgjIggoqNugJGFgs+1vs21Sb
	Ifn5c3tHp02IlsjH0GoNeZHqsKrPpa8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TqBE2pnyN7P50tUKRUznEgwXHTkd738bWOqNlRR+JrgSFK48vubZUT4RilCZhb9IUvYQXHzlSEEFKtjlCUi+D5KiafquYBN4BcUbEFm7vsFEWws97BX46qbxyhiRAtZ5PEc5YxTDfCwhpXIF3SX32BIwoMJ+pmaVPNpng70MPm0FGOF0ZNF8d9I7DIPCq8rRhtfsMo6mqh/nUDLQhY/4t95/+F2KWPDboUOu+qub2BFTQX//sEG5yGd2xGRlMaZBr63DG9TJpKskYjNKy9SOUsJPHd84hCIBrthhsq/Vo/PVGT5tiuUCFEV0+hMhYITpEcIlgrj1haoF0o/FEA2KRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/Xq8bhfX9FBjR29vBvlhJuH2gdShXw1/Vb9mV/iH5c=;
 b=K6ikCzoX5wlJ9RGQGjxKQkeuCgwBclR528QGDHuEpbdirdjTBPTn3hoOOJtqYRg3Do/iX5xnyU5LHGyptZhX1kU6vJn/CGckxweylvbJBX8KRJrzjMr+fp+RBmjYi+LhVDsRZppJls/0wqLqo6+fbxCJOzm9suHZ9gO65CcJqDCsCrH4h6OvGzOJvi1mEniQ7kUWHN3baDdEejbhX1Ee+wscUmy4kDmFl5/1CnrwpyacwnrXxSPcWppUdwHyiAfKITOVstZnEgc2t1C0lHoQfId8+7HZ6AxO2wf0qeGuI84z+sCyWQXeAj+0Zv/f7hKvAd9c0uqJQDlg/AgJYTGeFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/Xq8bhfX9FBjR29vBvlhJuH2gdShXw1/Vb9mV/iH5c=;
 b=uRsteFZM6thbyLrIltpNqByr/pV6QT4F0u8yUCqJBhdn+NFH5t14AahcW1tn/8ABXAhxwcUXAHz2pKS/zDQL1BvCUcf7roLcnHQWyuT24/OgVU/PsNNaVZ/z0MuhI0GOOWQFAHEIOL49vfBF/7dXGzOVL0RurWxROboeH7tMy1gd4AljQNXUHUjpT9QSjrbb/eFvVN7KTcsK0uUzLVL1hDyG8KNLNbjl6an3KzWZ5e1AXu1p127OdBy0m/9fUGu+NDldoRS/ZeUx82kwHK+MuZQpFF/KtZDg83sDBsfUGJl+a4WKX2XGAE77BBPbFLuKmrKToIwxcgGzc4rEctq35w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BY5PR12MB4180.namprd12.prod.outlook.com (2603:10b6:a03:213::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Tue, 18 Aug
 2026 02:10:38 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 02:10:38 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 17 Aug 2026 22:10:37 -0400
Message-Id: <DKRPDOBRL22H.3B54F0Q6F1AEX@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Hongfu Li" <lihongfu@kylinos.cn>
To: "Hongfu Li" <hongfu.li@linux.dev>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <baolin.wang@linux.alibaba.com>,
 <liam@infradead.org>, <nico.pache@linux.dev>, <ryan.roberts@arm.com>,
 <dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
 <usama.arif@linux.dev>, <vbabka@kernel.org>, <rppt@kernel.org>,
 <surenb@google.com>, <mhocko@suse.com>, <shuah@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] selftests/mm: khugepaged: consolidate error exits via
 kselftest helpers
X-Mailer: aerc 0.21.0
References: <20260817061955.45454-1-hongfu.li@linux.dev>
In-Reply-To: <20260817061955.45454-1-hongfu.li@linux.dev>
X-ClientProxiedBy: MN0PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:208:52c::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BY5PR12MB4180:EE_
X-MS-Office365-Filtering-Correlation-Id: e199c1ec-f26a-4ffe-4095-08defccde56d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|22082099003|18002099003|921020|10067099003|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	sa6L7iALuwvbVA8OGC4eL/9m0Urycj0HB5k+7zNo9IUe4MoJVOnzpXhQEHhvJmOxuI0JO3XAZsWK3GdBxx7kgjbjifgdV8Zz8vQPnqy//Fv8wtHnR4JLQeuEj3fT72CVAFEkVb9lzjAwqQXo9V8VjCPvugL7OXeWPAYnTkQKV9k17DhfB6hpvFdbws6auy34mR0gES/I8uILqj5Aq+P/ogFjm83qFp+pZYG9yMJ8PBZVOEQBJhsUE//g74T8NJygju5whpLeNQtyz/ic5dpBbnEuN2m8jqqVCZAsZSvipHjhXypIgywjka6RatFNpMNRAoLMT7c+JqFTt5F+F3EjisxSV0ZJwYMJfAASermhJBnVdZw9sZ0HbyJOxQGiDgBpPOUjwh2VJygDL5gU/tlD9r7g12hMgmrZOnbBU9gl8SH3loyM8Ad6lg8C4KtAJHE/cABruY4vP84JW5Thci27KG3EmahnbPktO5wqjvlhsOYXxYUuGR22vnXGOZQBKo2P2L+9dMc9rGHZ81J4lTHfak4a9Z+0bilAHX3A+YjigwYSVD3sD7NrxiM1ASEqUF2nVigIyp5m93AMAt4qp6DTkDSKBmI0eLUkYhOH0t+48ixlbGCX0hOVph5c/kAnNPsWsob8HEdiudhVRLa400chCSNJhiQZ2q2IDCfsmmHhuMmomFfvCcjOt3aVBrmVVWJ2od+Q74JF2Y4w4lyV7xcoZg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(22082099003)(18002099003)(921020)(10067099003)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDdwa2p1eEtROXhEQ3lFUU5mVS9yRXRxMmRiRkUzcDZ0TXlPTmE0SnMrU1My?=
 =?utf-8?B?eEVudjZVenFnaFZJVGFxdnBCaDVKZmM2TE1qVGY0WnpxSXdCSWM0OWxUU0lK?=
 =?utf-8?B?ZTJsRnJPWStwZHJ0MWl3TXdiRWZ5RnJmTDJQN3BwUzJqbGx5N1UwVlpOakov?=
 =?utf-8?B?empQbFNEYVgvSjZqVDQrbFJDbjViTEhKV0E0dTMxdnlRbU9VNjNWa1hSYzJx?=
 =?utf-8?B?cU05SjU5Q3diM0VwREFRR2c0ZmxCZS9HSXFoZERUZllieTVmbW1mUjV2RlZR?=
 =?utf-8?B?YlZVejNSdWE1cVNxK2piK0ZFdS9aZ2pKbENXK2ZNNkRMd2gyRzBoY1JIdzUx?=
 =?utf-8?B?SHJGdU9vTUhBbm52ZldoUTArbkJqK0xENk54UXBGN1NWeTNmTFNwbWROei9Z?=
 =?utf-8?B?aVVnWkQ4ZGt1Uk5QSFQ3LzV5c1orSE1zSm1yd3c5Qms3M04vWFBVMUtpZUM3?=
 =?utf-8?B?czNNNUN1aHYvNzhUQ29nQ3NEY1Y3R3RFUUZGRmVTK08xcUdPS2lQVTdieDNX?=
 =?utf-8?B?b2VBQWdySTJERkc1dnB6dUlSaVhENmVSTFNwT2JyMWRlNWtvb3hrd1FZQmE1?=
 =?utf-8?B?MFJnNDFmNHlGdDUzTGQvQWxFUGNqdTI5Mm9IcU1nVytDd24rMHJUZHlJRERV?=
 =?utf-8?B?TjZHNE9KUjcweHdEQUNNUy96bElDT3oxa0JpM01aNWVnbXFMTUNlZnhtMldy?=
 =?utf-8?B?dFU2Mk40SWxZa212Y2RlZEFaNkFuYkJ5dHJuSjRCWFpRRk5lUnFkQlBwVFA5?=
 =?utf-8?B?TmJUNVF1bUx0aDh0K2w2eXU4VWtPeUw2eXFrZVdpa0swMDEyN0Exb1dyYlBx?=
 =?utf-8?B?Zjk4aXpvek05c3M2WVUyS2EwVXhwck01RFF6TXNGZmViU3NCNm1VdzJ4ak5C?=
 =?utf-8?B?SnF3YkxOdEgzRFZjRkIrbHRmY25hcnZJS2VJUG5zeEkvekpUSG1Wd3VjbnhD?=
 =?utf-8?B?UldZK0RHQjVLYnpERWQ5TXdCdjZRaFV6cTV2NE5hQ1pvUUREUlBYOHROSlV3?=
 =?utf-8?B?cVNCZG1wT1VrTmU2ODJOTytJRmorbXU5ME1hSlNKdWN3WGxrNXpZSkl0cjd6?=
 =?utf-8?B?ZkFyazRQTmYrRGdzS05GOGlPQ0FYdXI1aU9vdkd5bVJwVFFnbDdvSHhLU1FM?=
 =?utf-8?B?YVpweEY2NXR6VWpuVWpxbUh4T0N6bDgrZllhbFJkQ01ib1lJaFVxVFZybWtv?=
 =?utf-8?B?eCtOVG81NURtZlNLcmt0eDBjL05qWWxuVFRUbU1lL1JNc1RMeWZEQ2RZbE5l?=
 =?utf-8?B?d1BmbnF1cWc3dm9WWGpLZWErUzBzVUhmM0trRm9hSGc0Q1BaTmdLT2VyUHZh?=
 =?utf-8?B?YkFjdEV1TmpLeGhRZ0hqRjVVK0dub1BXL3J4QWJHT2ZPWWhMUjZIci9XcUJP?=
 =?utf-8?B?RnUzcVoxamE5b2NMd2RpMHl0VkFpTFVpUUdiVXFjdXR0dUdDd3JLZ25rRy9m?=
 =?utf-8?B?S2Z5MDg0QkJ6N1p1UFpIZmZQTnhaQncxVGJmT2JWbjFPZ1lxNWNDaWhFTk1j?=
 =?utf-8?B?TDB3RkJibWpVZVFNWXJzRXZMbGkxNVNSVUZibTVPM3RqQzhXU3Z6OTVYd2Ro?=
 =?utf-8?B?WnFISTFCYWY0aWdzazZha2t4Ly8yTGlNTXFtT1BpTStDb0VPYnpOeHN6dG9t?=
 =?utf-8?B?WEZYdXVtTmhzOWVVRTh4dVVJeHhGTGpLL2NiMEk0b0dSSGJFZklHK005K0Rt?=
 =?utf-8?B?c3AxM0JoWnBuWlhSeEpMdHd1MGh0OVlLSnhYMHFLRHdBcHFnT3AwL0ZGR0Rq?=
 =?utf-8?B?MU9JZHQ0clFjOFRpOFpsVHJlQU9qOEgzWm9odHhDMnp4dEZHK1ErZU8vbDJj?=
 =?utf-8?B?YkRFZ3BkclRPRzRIK2RtQ09qT0JWS1E0dE9xWk5BTTE2Vmc0MlZkSDdPbWdP?=
 =?utf-8?B?MGowcWlSRzNUeXVJZ3FIQXpON0ZSODVmRlZnWDhUUEFvS0VJUVcrdXZGcUxw?=
 =?utf-8?B?ZXRuRWt4cVBVOVBkL1R2bC9hQW5WRExUeS9wUlpSTUtTRlYxakhwdjYzRStv?=
 =?utf-8?B?djlKSll2WFNseElHa2tib3gyYXhTMmc2dFkyRk5rOElQZzA4bVFjWkd3YUJI?=
 =?utf-8?B?dHFrZ2l4S2o5cldDQXJnVmFyOWFQWHltYkp2UUlHQmkxUndyQjJKWWhuOHN5?=
 =?utf-8?B?TTFJQlBqOXBXVmdwNHk4N2RGcGpQWW85d243dTFvT2dsbFJmTHJNb09iL3Ba?=
 =?utf-8?B?YmdnQ2lpSnBYMUV5ajFVSlIrQjBnblhkbUFIWXNnUjBvVlBtNFFGUGllVUkz?=
 =?utf-8?B?K29FUElxUjI4M2pMQkdzNGFVYnVycjMySVl2QVVra3JRelN1ZXUyVVV2S2xF?=
 =?utf-8?Q?6v1EUTM/HKqLiWaL92?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e199c1ec-f26a-4ffe-4095-08defccde56d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 02:10:38.2593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LPMcFaxEJCZQRpJabaFSIz4k9eUCf6ru+BiRkqjlpSYvmsb9i23qSNG7ZgYOZpIz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4180
X-Stat-Signature: q9aqfkwnytki81umn3fs57gce7k19fw9
X-Rspamd-Queue-Id: 348A340005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787019045-245304
X-HE-Meta: U2FsdGVkX1+Y8+DXQiyBvAAC/r3drk7176yl4A6P3Ld9HxR/b3TTHCDv3fnt21/OV50OO5OZurWB19dHf3Y15Ro7EwCajiovZCl/I5vAZlfM6tYLRs5oaNnIl2YKZOvEWrfciFomyFc6nQEbfT0BkqaVKsc2k2s7PTxQifn95xoSMdtb1Ru3uzNouNhe7VqJQJKiDb7qSB45+vUU6oZ7hdFpKRxVaiWvQkNqyQhUVIHwQnmzOjxepH9RNv96bPE9vcNEC4DwtHymRwBVKyOav2lyaFf3O0pof4lF5ggTVGUJP+UvFQ8M59dL48kN/ESWMjWji5GB2plu2oKUK39Ow8O38AVVKSP9g8TxV6DoHlVPFlUo95nLdghi5B1zXiJWorVTxegIhaS2fanMighxou0edH0JRZ1rpAykJh+y6SGC/GxDITDuyTpGqojQkKygxO+oj4uHUgWpGX90tM8N5lIk/16aYvKoVoROzIrVuQ0KTaE54bKnzKaEe9fp/Iu9RN9VXHL8EQiCPQcQj3qIYr5g0giVC7SvguEsOq+7RLKvPk+EhiCRkenvQoqV7EIqp34ykpkT8uxtqrbOV0w7m3f8X0TmLXsN4NuufCFNPYs99FE9CTfLA+K8n/nCA3WoHUnTPXcMKM2X90CzZ0DYewD5SXh5oeVCj9/NVnMwUmbyBkCKnBBSJ6r/psjM1nXcJBZp9njeKt5vAuqGQ282Z/b0MwasNfwNCn40fWK04HEX4d9GSsVFrLNwEAELrfxIN/DWKWB1eLP12jzXM+CmHbHXpuuRoNabOVjTtSwAnpffNmuN6+PPKUfx8/HgnLIRGEx8btsRVv6apIx9KoyKF4jHKZs+8+hCEZdhOVw+AggifvWMTb1Jta7ust9cIy2WENagbSqAYrnNWVkSSLkoNcgaNw70QWgY1nF6VG/nkOzcxoFLDa6Zswaeji1nOxqkelQ/USVPhBlAojMX2l4
 8XM0P0fL
 pQ9J1UWh8bbKm0RCAxEHS3kLQg0fswF4Ai52jeidAhgMpEhNOarp5eJtAf8ms4mjnWLTrpt/YRE3aPOums3yEaiNqXXl1II9kLA+FylUePhKvx/BgWHL70kJ+8CtO9/U13wkh2Ofw9N7UYbuzQBwOy70dg0XgtMDzWkDSm+BRB3SF1XEWnNvI9offiHkM1iBNqCJeUpRozTT/Z+WfTvbGKNkQePCThgP/Wh7sOb5WCyGB2AULzMaP3JqsCYC5J3BDU1hhlvooopJ3gBOv5g+gKrEjU/bjHN1irkPNbHfcDjPJ4adBcXkw8aMN5pRCt0XJULCCsK+vJBD2wUMx4YTSLnc3vT2QW2Utt+KFRpAf3A9WipijxNPIFxbpMpaERrO7UG6TSnPiWC3gMy3hUYgoz1N7Bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 17, 2026 at 2:19 AM EDT, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
>
> Replace the perror()+exit(EXIT_FAILURE) pattern with
> ksft_exit_fail_perror() so failures are reported through the
> kselftest framework, consistent with the rest of the file.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
>

Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


