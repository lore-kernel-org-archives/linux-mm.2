Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BA5AC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B46A6B009F; Fri, 18 Sep 2026 12:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B8B6B00A0; Fri, 18 Sep 2026 12:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1DF6B00A1; Fri, 18 Sep 2026 12:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 427796B009F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:57:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2B3714071E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:57:13 +0000 (UTC)
X-FDA: 85227488346.09.D786009
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012008.outbound.protection.outlook.com [52.101.53.8])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1F37C0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:57:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=J4q06CEu;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789750631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GtYQbNW/+kj4mH5TXU7lE8M/uEyCkXWcWPlPOBQXds0=;
	b=2KaM28qK6XTAf8dlqYgDaWclkYZzBH++FcG9oNcx7DG+Y1SQjWmPDQHJkYzVoCIgp3wtMj
	6L4l5r3bqc4sG7vxiX1Gmj6AjVk3yeZq2iVjHA9u6X0DYGG7Yra+RzzpiW6P3RLVTKR2ck
	anDSZQ3qnt8RytDiUu96rCcsg9SJ+x4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789750631;
	b=SARWA+b9cv5S6PgytONmgfg64l7xgyDbw1OmBWI6s2tYgF9afYgm6ndsuTwiT7zPviyhQ/
	yyiUHXRNr2SSqFw9hNJ4yNZ8sp9+8HsTZOkcpyk8zUfJx1w3JaRqN+emsuE7U0aqmtgal/
	9RoZ3z2Kgxt+GzQz8xbzrGgpaw3ueuo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=J4q06CEu;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bw9+P6iNn/K6C/mHon7WKWw8Jc1tdN9ZkD8+te32rmfsNUszbgfJ2c6x03NEVCPgKluNV31xgzueKEyfVavYEoP47csrqH5s6iG3Vzr5ti7aBr9E0f9pUzFHK53eJfLX7jrIWyAfMjQnqVURfLGLNYFcTPZ8uwDdilhsvS5I88Lc5LGbIfmaTISKOsPvtahSC4IKOuB/uqvArzimB7gt6WLm5DzCVtX2LY+W1VSHBt0fdZ1Ey3iv/2nCdz4Rs4SI5iXTVy6sYjVE/hW92L4xFry7BveUpexEe6TI2PME0CgLSS+sL5+izQWc16207pUh8luCG+Atz+GxFhzYhuuAEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtYQbNW/+kj4mH5TXU7lE8M/uEyCkXWcWPlPOBQXds0=;
 b=vUBVquuqv1Kx0sfYySVI8GKx61BZ1Rx4WJLn+RzP48j00hzbHadlPXxzbJju5X16pyAf3qCsSnDx+flb0SjcdqU+NOvgl/t4hOkEwSo6lXMWi5QuDUNyZxMkMDOuFyxxS97xRBis0TKATarVViezKV/LG3jrFg2cGp7ike5kF44AjgYlGVHEMF2E4aTD0LXWq4AJFtVwCnI2YLKrr0qstAX7OVGncf6BZz7jNB/y+r+C8P8f7snMcgHEPiEi6W/P7cK3Ydp7S0jW0FcgEFzxJVGpCRB1AxWPAuroPSj/PrbxDLM72dMsRhC5rdO43WvIWDc+wcmr4AzVLQw8fnHU6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtYQbNW/+kj4mH5TXU7lE8M/uEyCkXWcWPlPOBQXds0=;
 b=J4q06CEuDX/UtzBtWq82QfCzD+7ngBlhelTD077lCqhNQJOiBtBGfMuJ1aRqG/+uc9vH+T7+TIzTI5JFUj9N7KkYw8BK7p+Auy33WTmbS4csAMefC66iUeR49XTPnGI4Aam3970IcRTY/eGjAeho2XmeQD+AHzClbsU8xoP6gdE+ifUdjvEvwm/FuNiaqGuWBQvUjjildTwiFVoleAnlBBv4LozrQfO88GYsFWNYEZnqo8DZ23oK96PXL4Oh41mmoqQJk2nftc/Bwq7m+OmQEwDIzjjU9RNSH+VVa13NA/7J5vtTKt9E/b8f39aa8JZlQ8l8kHskbEzoZgfoctbHtQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7617.namprd12.prod.outlook.com (2603:10b6:610:140::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 16:57:03 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 16:57:03 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 18 Sep 2026 12:57:02 -0400
Message-Id: <DLILN9GUNDMG.1BNRQJEWPQGF8@nvidia.com>
Subject: Re: [PATCH 2/3] MAINTAINERS: move memory tiering under MEMORY
 MANAGEMENT - NUMA PLACEMENT
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Rakie Kim" <rakie.kim@sk.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
 <20260918-maintainers-mempolicy-v1-2-9a94cac6d135@kernel.org>
In-Reply-To: <20260918-maintainers-mempolicy-v1-2-9a94cac6d135@kernel.org>
X-ClientProxiedBy: MN2PR08CA0010.namprd08.prod.outlook.com
 (2603:10b6:208:239::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7617:EE_
X-MS-Office365-Filtering-Correlation-Id: d37db73c-474a-4fdb-af8a-08df15a5dd20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|10067099003|921020|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Phe5v4VLqp1W+dPjszkCQWuAVNgjtx5g/HSplkFKwPG1Z4YRwFyWKB+ERABdzB/pnU7o2AzoD1NTE8CocSIwmy33qNnK3nJ+sWEY+kHuBKVIZNrnfbxfZBr+Ao1K7xHuwba0GRfH9q+utMsB3720SoSUk21cwoqcYSF9dtEwkT3Cql8CwOZJqWZTLKeX8mTgqhrobluKVqoHvqjQV4496AmQWIfMMWTE7UpDuWwX4asgT1xvl7Duwd83oatdM4/fJESjp7aERFj7DmW67vHC65O32+VapIPol122aa5ROb6FnAO8XfaTvqxAeB5k4K+pPP/Z2yZwNcolsM/keDvs64CZEMgY4S9CjVZJ7GwIzEeLrIKUun1/+wPQzZeK0tISzXOB6Nf5BLOXhqtPTkJ3RBJG/X6GH0DfJroNBbKtQUJAsUkHniwt7EUreDC0blLp0zq8zOg/kzO+JBEMJdOgh6TPPzGBxvVSW4pVQLqmyoaM8NN4PkLmUGXeMn6SdaQhdUMJ9tsCpOlp5+AxUTDu4TdNYkihLyW8qnb0F0CCrOQwWq0QyMljzlRdl9l010cz9qvwGwpCbStNTAukzwgu8Usa0N+JmEVBK2S8+Atg6rOEMuXRGSpV4qmkQRhru6yMKCd9dCBV5pCK0ftUrrWvwtxnV39bFu2P5+Vn9OKAcGFbjSnpgNAlKxzkHvU7BMN4oBAoLw/CGr9JyB1ef3v/xw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(10067099003)(921020)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OVVKNE9pQno4bUZtYUZDdFVnZVVIVisvNU5Fbk10TlZneUNNNjRFQmF5ZUd5?=
 =?utf-8?B?VFl3OVpNUkpralRHdzlwVkFTNkV2Uk90QWlNcXdpYWt0SkZzWnFabkEveGEz?=
 =?utf-8?B?UHFRZWNaUUhVbDI3QTFjbWNGeHVMTzNRQ1AzT2RLRzdUYXRQQ2ZwVzB1a2hQ?=
 =?utf-8?B?UWhPeEp2UmFjZzVGclZ4L29JT0dYbjdWQytGQXV3cGx2cm9qOFJ4a2FHQk9q?=
 =?utf-8?B?WWZBSlhQbFVFQ1locUN2Wi9mVW16OGtHVVhPTGZtTjQvRFFwa0hwWHdOOEJX?=
 =?utf-8?B?VERGaDJuVEY3a3dXeWRneEY3eXk1OVludU9NMXhyTzlNWlhCRldJOTVKUUtI?=
 =?utf-8?B?c1lzS3EvYWF0NXpDUG00bWpIUXRtUGZNS2ZrbmVNa1ZMd3V2K3hlRWRLZ0E4?=
 =?utf-8?B?WWJOQUlJTlhzK1BPMndhWGNOb1krSWhENy9yZ2tNZk5YN3E3ODlJNzRBTWJq?=
 =?utf-8?B?cGtZUWZWZ3BqTzY4bU9qOEpGRFc1bG5XTGg3QUdRQ0U1ZmMrMERmVlBmYUlt?=
 =?utf-8?B?bVZYYTdOajhRNmhvVHhBcXppUTA3NWVITlZEMGZXaVA2ekxucVhyNkZNWVJB?=
 =?utf-8?B?L2pkUlkzUmorU2FkaUlRQWcyWk1oeW8wblZTc0tuKzd0TzdheFQ5L3Z5bmx5?=
 =?utf-8?B?RVJ6NVpzVktZQWN4RlNnSU4xdTlCQ01OME5mTE5DVTNJS0NBNUdRbkRtam9W?=
 =?utf-8?B?S3hiTUo5UUpsK2lyUDMzdk14MVlRaFJNM3cxWTNSVmc1U2lBVWhWRGsvK245?=
 =?utf-8?B?NWZTWWQ4MTJZRzljT3VnNExoeVZpYUFSMTNhd2d0K3krYXBwZXRFekM5TWxH?=
 =?utf-8?B?UzdURXJLQk5PK1pVeWE4NW5rOWxaZFpBN0ZtVkhwdVcrZTU3eG51cnZIM1ho?=
 =?utf-8?B?ZTJYTHB0cERiWGIvcmwrU1Jtc3BwTVNwVU1FbVpheWxjU3NBalFKTjhZV2hv?=
 =?utf-8?B?SnhoUFdaZEgycFV1ejZqM1IyKzRhUHd6TjRRdktDWVFFWUlaSHArY3ladnBD?=
 =?utf-8?B?cHo3bmVrMkVrZzE2dkFkRU5ucGpSK05teEtZL0xrajRFeGdsNnpYS0l4YTZh?=
 =?utf-8?B?Y1lxdjc3MGlPck1LS0dsVW51T3pKRERqeFpsM0ZJM0RrM3ZOWEM0Vmw2ek1M?=
 =?utf-8?B?TWdhcHBCQmN1a1pmQXZENHUwRjhtNi9FYlF0VWV2VDBvZnBHWmlMMndxUldP?=
 =?utf-8?B?WlVxRjNlTkoxQWUyQnc0b1Y5UjVlQXdnT25HUURmeTl5Zi96OUpreUZ6bU1C?=
 =?utf-8?B?eDRzekdmdHRRNVd0Mmd3YTRmaDllYmpBZEVsNVdhczRLODdMZGJpQkZmanZx?=
 =?utf-8?B?eEpLai84V3Fta1A5RnU4andQNUxyUXNLUTdRMUhOU1dmR1V3RWRlbXJZMHVw?=
 =?utf-8?B?elVHOFB4OXNZTnN5bnB2eHlGeTBmSVJiOUNhRzc1czJRcXBYNHR5RlBXK0Ft?=
 =?utf-8?B?S0dldElWeFVGQTMvM01xOVpmdE1lUnQ3RWxtUzA0VFpEK0Q3djlUVFU2bTVT?=
 =?utf-8?B?L0M5eVJzSGJ1ZXVpQ0hJUDVERjkveUtud3kwUlI2WEtaSGdOSDVzWHN5MXB5?=
 =?utf-8?B?Y0FkTjgwSVNuV3RYcFh1V0VUTndCVTFEZm5ybEYrZFQ4QjNMT2dldmhHc2g5?=
 =?utf-8?B?cWRSbk5KU2RlR0U2U2lwdEJrcjVLQXBlS29Wc3BJSEhHVmVTZmlnTzJ4d0l0?=
 =?utf-8?B?Qi92UnhRMVFtVDREczV2ZjQxRW5nVGZrZFFaR0VhdEl4SXRKS1hHVytaMURF?=
 =?utf-8?B?QmlET3ZwNTNjRWdOZ2FQZy9ldnMrK3lsMEt3dFZINXdrQzlZVjFHcno2aDBx?=
 =?utf-8?B?TEZqVWJ6MlAwdGJuNUFCWXY3TEtWZmhqVjdhOTlScWVZa2ZqK3BndnltVHZW?=
 =?utf-8?B?ZWN4VUNZN1ZpNWUvOVpTSVNSV2RiZVZJTzJ1MmRNSGJpNEw3YUczcTBxZVNx?=
 =?utf-8?B?NmN2TC9tVGxudG0vNjRuRk1jQmg5NFNxT3M4dlRaVlcwS25ZYmsxV3puMlZF?=
 =?utf-8?B?YkVxN3RQNnFndDU4SERzVEJzYkptaG8vZTdTc2RzQnQvYW1JdXlwQXdtKzQ0?=
 =?utf-8?B?SzRBM1I5bkxneXREc29lQjZucDh4aWVRTDRaMk9WVVVPRTVCS1VTQ3BiRjNt?=
 =?utf-8?B?Q1NMU1pmajBSbzBkU1U4THBpUm5WczRyd1lzZnhObyt2SEkzT3oraVEySWcv?=
 =?utf-8?B?U1ZicFZQRG5Jbnd3MEk5WXZjRkErWWt2d3VENHVNVlN2MnJmL0NQcGFOazB5?=
 =?utf-8?B?QWdyVGhsaTEzNU5XR2ZCbVJ3dzVmYmJQZEwza0UzRWpCTno1ejVOTnY3bk9n?=
 =?utf-8?Q?JFQkCqiDNiBXqvPqYl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d37db73c-474a-4fdb-af8a-08df15a5dd20
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 16:57:03.4590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5gc8DrFEe/hnWnHp2LtXMbuW97kKcqOAZpR9pNeEZsblL4YaKK83hIhkt4YhK7s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7617
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F1F37C0003
X-Stat-Signature: 765y77pb464sipcr15tpz7kgp6b835ak
X-Rspam-User: 
X-HE-Tag: 1789750630-727181
X-HE-Meta: U2FsdGVkX1/v3V3SnI2GAA2nquR9tbpquJrDlZCGU/em2X44XjibcnMWl67IekA0702KlTdyYUqZB4sE1CFjVuC7RMZSliXKIZzAInHsqRgEuNvLGa4BxOGLVDdC14EXQtHP8ze77RbrJIzekpF2cnkPBV50+3a8gSSwQ8WEQkXpUP2yhSO/nc5WbWGoJDjFe7Lkbxti63/Wsxz/ypVd5R9cLUxNuFn+3bxI1n1E1IH1pA6yBKFMz8ycUJcJagOt4eZFCKgajGw4GxZYkwvl3xWJuYEUkWA2XyiKSXHmmSxanGgJgLdxlwxgfN1B0/PnJLH5nhmSHN5fZQ5BkKtgkHySjR/2cnWbudD42WHeEPtGigTdbFD+Bqdu2jEvkaCsnvi9fDlmirLoCfRVOh5B13UD144Nm8Iecofz8c8AtO6qag8RF7anE/vZ700GC08GhCP3kMNnQukpre+3eMXbgW1F9NBU154AwraGmIDc517jCUJe+/+NMve7o8Ydz9dCILfi7bo7AReJ0x78H5h78ffQ/Bg/qNm8CqhWuD3HW+s4odWFbl5pWlPTzDXQfiBzz1L7dFDfV0un4TA3b4QgDeRnZBWLz8PC8fQGYE5xrssbchDMSpO/IGUmG7MP2/xmTKd8Jqf84qy625MgoPTm7jN8T06wNsXSdI+b0L+ZkXpAw+viX3XDmxx493Mx8zbO28YkKka2YiCf+f5egaHKvxLxncdVsv9ZIDW/+kCFYS5hcMVJu2MZw8eN4vdoLloUo7TSBAYez7Oc3xZxPBnqKXQBhYMV7pqWFmg0L87aU9tDcYBskg/yYP89fjR3spVQSP0PDuwhqFwU+Dqfj3Y/NYxfs9SXco8EtvT8AcULaNbaOU7UvYE+ahg8U+k4bhSuJHacbhNLv2xLKTb5IgRPr/AEc3n12yMqHxaB8HCO15YSCEJXE0QF+/EQ4EQ5zp4MxknppGdv2gO6V3A357Q
 J3liaHfN
 xuqTkOtETYfQBZIVRrkX2vHZK/xoQUyNs6uE9qNHgpl/8x8vVYeCUMFTLT8YE4ZpIkYduZaeMRmIk/jQ4lzNmJbiaE5Husc9tqKQdnXGuyTJ3ejUa4Wc4g/2wxCuA8rnqiMVltsShBXsdTivGuhbVIKD64w3Kbv1YKLQujlwFFdBMuihwNUNL84Y2YFN5JxGM7fKfsR98YWiYIwxUUXI4OIOEVLEBQKVWTehoKDTjQ5Pj4KuM+HRWqaXFJ1HLS+q7YEOyJBzUriTsgT26iSNHCTqJUI/+SOfdGqk84Rx47ROE1T5TK6g40H68hdH4kOxz8bGv95SBY1u56To6rjxhpJu27dRULj9jxHcYD7oiIWVVOvCf9xA2HpgK3ZR8Hktwx351yiqVDn2z3dxnPqb0KbN+VcEXBpR31kz+j1TYiR1Cb/SOmDOWlWUasVlhqy8Bg3G33M1oXo3/0QcPujDEPa5S0e3lvDMHuI/H42SGYZqHetyrSVriE3n3jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 18, 2026 at 12:34 PM EDT, David Hildenbrand (Arm) wrote:
> NUMA PLACEMENT is a better place for memory tiering.
>
> My best guess is that existing MISC reviewers are not that interested in
> memory tiering, so don't carry any over.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  MAINTAINERS | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>

I agree.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


