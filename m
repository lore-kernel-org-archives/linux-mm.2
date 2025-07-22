Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694BBC83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C3C6B0088; Mon, 21 Jul 2025 21:13:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23D66B0089; Mon, 21 Jul 2025 21:13:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39B96B008A; Mon, 21 Jul 2025 21:13:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B4A086B0088
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:13:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 349571D9149
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:13:32 +0000 (UTC)
X-FDA: 83690127864.05.F9A6150
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6A5F518000A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:13:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PO9wQe+t;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753146809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUHta6sNvihvfE+aRaKQcYxqylCHmaq3A5N8b8g8Vlk=;
	b=AzPRPaaEmEQiKdG70HKXHgxEou/rDEEXLUwuQ7Cu/M242k87MsfO2L7LiOq0+6KoQQz3nU
	f6x/CDYSZej50+i/K5nL4+/VJz14ENCmc9PuVGE3Wi7EVitKlwQ3AFsnS3D8tq0LuO5o8s
	pJ7Z8voqhaDRsolxD7IbX4ltk+TA/L8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753146809; a=rsa-sha256;
	cv=pass;
	b=zD5CLYcXgJyGk5T3to0ntItEAGgn9vxi/cIqPProU+cjB11IeWmzdY3iwy6P+f69c3NSoo
	u1Ix+SKo1S00TTJh7k78+0yQylHGqqfTvAF5ZLW5/FxOK/0r5HKIP5bsbYybCXNq8l1Y4+
	ibLsQmOXmXLFjrhxkxnxo5cRBdVlAas=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PO9wQe+t;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g5wv8tgcnVXS9dJBl2nnYGmng0vIlUkCfPAUeHaeFMXUfJofdwp/QAdI+Z0cb5m38mJ2efzoPKyErsmuyCCnO+EVUHU2Ylq77lwGj5KoIdxhFKlxOlRelFZL/1tBpVXoOXdWHBHd9MFwEFgCyD6W2LtHqXW6nNoEpCeSY9yUgbC8UFZOs1PP0aTXtClWnVhHv/u0sHQWcCTaag0aM7sp4YgGdSGEUbn0qR0LejnuUS+VIIB3yUdUlaZs8uAx5TUAZrDpfM9qp30svmki4+q5KYjE7yoxc55AMuDV9v1OMRBS0hfIe5/50tQyvwkCfnsb9jnT8VqQ20nXGi0POKejBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UUHta6sNvihvfE+aRaKQcYxqylCHmaq3A5N8b8g8Vlk=;
 b=bDiZAGwjZVl4dghNM1ZubTGBPge6qYiNHXgxgC1OVCcoImL4kjeH2XCw5r16ijWsqNECEZbBxUZodhHHDE9B8EIosRaau4ewoCuuLy+VW/QMpF1wnw3x/E6wImRvR8PUuNBqyJRGoNJq5mZvDPr0X8jogdzJgQIonC7lGQdWp6Isc0N5PDCzkrSWRquMzh1XJbokAuR70UU+L9jWsz4eY0KvoLPjwBIAdkGkmc1/3urSqqknWoginUJBScr4Sjz+kFQcwyYGtQcGvLNRuauqSEpkIp4Dpg5SlLOXic+Hb11UwV5o3JLF5UGFK9zFxXIDLRrSleq1ryJD30tCLMikqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUHta6sNvihvfE+aRaKQcYxqylCHmaq3A5N8b8g8Vlk=;
 b=PO9wQe+tKtnHjF2WLA4ecfg4BsOYs3a554RCT1z4Ad5xqjouO+d3OBkoOUiQKWRU9hYdtuFkYuf6QiSnPqMt5EgIzT+wa2Tk/dTihfUzo1XItc+SWEc9S1WySGWwhIC2jkXlHmIkV5oZcRKcOyNo2C9fsREcPMmB6JVSAwcummfEANodyx2XWv/gqWTGkmZGS1iBO4y2NV3SBXDvM8Fq/mbMIpqu5P15b8XiSS/hBFRkXguqwXot8aSQ4n77O/j3QTuLHbirZ/PHRS6K3ozcY884mwZFHpJ2BkzdDp6HvsViSEn5ijquaH2GSIND1BMrRoDIBPMHQh+7IO3C2OFvLw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6917.namprd12.prod.outlook.com (2603:10b6:806:24c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 01:13:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8922.037; Tue, 22 Jul 2025
 01:13:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: update THP documentation to clarify sysfs "never"
 setting
Date: Mon, 21 Jul 2025 21:13:21 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <E48F7A00-D103-4C5D-901D-44085E92AB7A@nvidia.com>
In-Reply-To: <20250721155530.75944-1-lorenzo.stoakes@oracle.com>
References: <20250721155530.75944-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0688.namprd03.prod.outlook.com
 (2603:10b6:408:10e::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6917:EE_
X-MS-Office365-Filtering-Correlation-Id: b19d1ea5-2db7-4f00-4324-08ddc8bcf5b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WbohhIXPX7eBma+cosaj9kGZREowCwfJTg28ADhMJNN6/19kIp9+TdOPR8IO?=
 =?us-ascii?Q?7rQ+xDbzVNEKPad4wCfrz2uIZs/4OWkrWFx7je7Zbm3NFwFGPJMLAwKer0ax?=
 =?us-ascii?Q?3cje4zitJjgayXqG2MFYqsw8iBWkh6EQc3ZSfWdKdSzuoNR/zy1K2JSvaZXv?=
 =?us-ascii?Q?cQzD8DCuLNdBsvDNmB5gfXAUH4BOLk9AYcb8og3bulmPsVpsKrEqoQ48ROS7?=
 =?us-ascii?Q?0b06xdBoG85qiud//Vn8zOk6vBXCqwfEpFIMROU2+T3hi6Lpn3vIrBh+l4bT?=
 =?us-ascii?Q?0P0cwAC0g8xlS/TKGcc7lLCoquoWjRzekF1jDHvD9AlqXAgwSUL93trm+IhI?=
 =?us-ascii?Q?TW8s92YD6QMDGDK2CAFfUfpx8sAj5XO0SXTHCnLApC5Q+x1S2uZ4gLRYHB1M?=
 =?us-ascii?Q?9YwYBjEqKpRG3r6mxGkj5d9Wrtna+rSBhj6fhNMBQYmLxVxvIbRVxVSZXKNu?=
 =?us-ascii?Q?bSq8my5YAwuaRoG/Mv6f8B+BJrn60vVpTpMLPTGlSkP+fTw+mDyUjN+d5uNT?=
 =?us-ascii?Q?Ty/ooqd1fNIXiJ2RjeRV42iKBsCgYe/YnkYmpNdii1Nwx1M9xQ26UIZaXu3l?=
 =?us-ascii?Q?RFQBBJHAPhrGCtVn0YBccdXNPt9kpNcL6UvTl+8HM0nhUU9nu5kyudDpScss?=
 =?us-ascii?Q?q9rtb5OBd3m6tRMXBzwxL3CCeybV4cELQqTil6fgprDThJ1E3oK2DFWZjjOx?=
 =?us-ascii?Q?7ypGJimkWLOT4Ph3qe6fD7YV5Xe1boa21M4DtbkAOIp5hQDdBB8aSh8vnwei?=
 =?us-ascii?Q?lFw3h3aWGM4divAwJsqmn0YQpzaGEV/qdDJ7r2SPzXLR3nLm+NS5LPNhxYAA?=
 =?us-ascii?Q?Ytv+9uwhH2ABvROU+3TNxNNALhu48k5hm/d/wt3kSUd6yip+HEFzH3uwmA1S?=
 =?us-ascii?Q?6v3a8VjabLX2UO7hSGbohs/zVWRb1iFKj93ovepwUMZUrp4tqvQnWE2O9mXt?=
 =?us-ascii?Q?96eCromT/2zn5XTyxoSZD30+fEUDOuZxzgHqaJmejfwye9Wuuujm6MDHXfnC?=
 =?us-ascii?Q?UVJy6pIFt0vAfJ9tlbOwmGttR9ihEfkbv2dSRnzbW0zKjEzB/wF2DEJ6CorK?=
 =?us-ascii?Q?8His1zP4HqF5XLjLV3MM3sSfmoL9b9kIyMERluI5z5VwB6XrcNv0Nw6tvVHu?=
 =?us-ascii?Q?++L8ilrwREcBPLBaAukWsPkA+ayhIKnVyUGlepss1xzOYq7r7f2Z3SIZxkGf?=
 =?us-ascii?Q?ZHz56SIgN2uR3wHryqBny4JsbjUJ2DWGoknMsfI+oRzkly0tvcUyv6TTGcLd?=
 =?us-ascii?Q?0CNsyBVYSxVawhTnKb5D9nAvYwltGmzowy2b21nqP8LX6sBc9sLa+gCpVBDY?=
 =?us-ascii?Q?UTt1/tXQb8H8O8mNIGAhAUOfAaFXDvy6dtmw+fR9HQ6R+jDfR2wGxkiNH73h?=
 =?us-ascii?Q?OncHQsGjgacrYTCWCUjokipyFWtDL/rtnFVNpROx7nHlre1RqOjv3K8qLTFr?=
 =?us-ascii?Q?zX5xIroHhpM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DmgZuHRS7wnqLHn0LKQX4O88NSC86BIt9Cx3Ofsrm7McfT6DWzo005WVhxyF?=
 =?us-ascii?Q?L7K6qXAHe4I1qp4/w18B+BC4g98EhA7WnsAj29VjN8kVNDTK4fufzoAqIRkx?=
 =?us-ascii?Q?vHxUm5c6sQiDqDUED99x5e313oNC96b2TRA9ps8udtabgvMqcbilHA2SJAk9?=
 =?us-ascii?Q?rVrV0ds+RYQUGCgwZroue54s1c7CxL2/tg/+KYtYxXtcgmP8INh7IqSGtnjE?=
 =?us-ascii?Q?Ku7YSp/87XopCfAS54mmu1GNmmR7AbvhWDiOjW9Bgiq3ilTJyGIbHVnSCJk2?=
 =?us-ascii?Q?OAc1FJglATevv97IoEaS/EvvKLBY3jr/nHo6fiG7PdGzGPVtI9/EXNYRgolb?=
 =?us-ascii?Q?8FhDfmKYJ8ezrHfagJP7SD3/9LAfCgs64UdawBDEKP3Z05osfJcRpMIzAkd8?=
 =?us-ascii?Q?ajIxL+GsICFyqjz1FG65H7999Pchkbg+W9ym0dM1NpgTrGYsDkZ/4fAwZ+OF?=
 =?us-ascii?Q?5U2mWAB2U3vu0LzFg5ke7j4ZOKfOhbXqfPWw8+pENXdPSQZswJKjATqI5tYl?=
 =?us-ascii?Q?vvO/8m2NZCMnfgBLOB63BkSEofLz21e8idmB6lPIZU6xo5lcvrYToxi9x9Xo?=
 =?us-ascii?Q?K0xxv2OYt2wuGXB2ekOmEAqAwLJfvpW1HufB2tPFEf/H+uwwjt23OlerS3pz?=
 =?us-ascii?Q?b7CS0CVmntbpu+ebEOqI9Vt+KYDZOfT6HlNZcfwDevOwYNOIYzfQyn0JDnoQ?=
 =?us-ascii?Q?kH8WQh2uBzeUkz4mIuFcNid1r/uEbGVaLgVOHgAZL1pKJX0fQopC1GQBW6s9?=
 =?us-ascii?Q?CADNS5Pp+LhLNHwfVrX10D77jtf+DXZXpNVYmZGxglQaVIo1mawvT8grOx9i?=
 =?us-ascii?Q?361XN5zyGzeBY+nb3IwJ8jsFu08HS33gJrmbX1ese95LnzGA2mSJW+EVPrv7?=
 =?us-ascii?Q?qh2B8HcH1qAfPcFGSVFymFumQISFcPFcbALy9aLrZ+mH4pC6qtO4MJKDYMEV?=
 =?us-ascii?Q?2BOde4SNpLg6BG8Ge8MiMhDc+1H4FoB2YwcEy7f+WaApQdJFaao8Cu344pK9?=
 =?us-ascii?Q?e+5Td5+e4pTyJnzXf163oRMcALoY6Zt+wuK+SuVkgfNSgm4CX/iVa+xkegKQ?=
 =?us-ascii?Q?Qo1HqhGAvCAKOBHOXxSTvMBU7Uwjw/GrozMZxX9HVcR8u8CcrOUjjl8APQJC?=
 =?us-ascii?Q?0EXKVftNGwQqX64RPNCYAJ2O99k21v+c6zIZgSYq2N97WhGFGtoAG/kzg/c9?=
 =?us-ascii?Q?8YWDeBOCH903xzM6F7gJpz6eBD6rsWh8A6sUmq6KHqa5uEg7Be8nozPiRXhl?=
 =?us-ascii?Q?tP/e0h8IXvGBB59v9SgjHlJTZc/zmMkoN7wXqERaUa/c8yGQZCY0Qa8EDMPJ?=
 =?us-ascii?Q?6pkE7/I1hr5KANxvCX/saBTas2r3SROBW8WVB6x8U6kGLrNFwgkfKC4b2i0K?=
 =?us-ascii?Q?SARVinLonVQVYVojtrhb8Hpy1oI6WAYconC9se899pEQTrcxUzQEA/2ou4+z?=
 =?us-ascii?Q?v2ujC8Za/kFTChS9bZpTqM/a2yNHSpmRkcRuSlAmlLJI+TBp5Ts5H3PhFzjs?=
 =?us-ascii?Q?u7Z6YHKeopHhK80G6fxZlk3TxS2IMzsajge/TGNKat1vpvtqcMnDGgA8OvGo?=
 =?us-ascii?Q?iSwl1No6Qkgan3jUdyhYZZPVIJUGpPmC9W9bPruf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b19d1ea5-2db7-4f00-4324-08ddc8bcf5b2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 01:13:25.9417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +BH/WbGSrjHuogXtP//aMj6ZM9pSwS6Rn+kAzj/9UwlRjv3HSJHP1z9KlpMEwP4c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6917
X-Rspamd-Queue-Id: 6A5F518000A
X-Stat-Signature: xb9y6icwbg5htkr7bihcqyhbaixzj3tk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753146809-79713
X-HE-Meta: U2FsdGVkX18Rkc6aysRwQITJYK0A7OdulLCDM7bUH7xiwY96XiilooLidj98wvicEt4z4fnAZX700jaePPs8072nu8SnnYq/l81qyn7lOJ6wqY/BwxE9d8aNhZJsYVwwZDJav24Pk/0HZzZShtCZBzV7XHk/Kk8QKHDtxktOMGzbHzVFhxnDlJC6st2z5gLuPa8Yp/SDl/odkcS0bJ6u8zD0XnWgBVpeL7jPO7od4JAP7EQoRB1SQ3rD+h3nPkyuwyVkOw0sTAFlSLbDBFtjQp0mFuMw8QWMut72Qn4yq9WIuE7iAHg//djq/S+H8n0akv/pUSYgINzPf02uFdD7wEPXo5vRSN45qvhB+Y0kvsehejmWxMvWtjOuWJz4DklyqeXZiSjUOhQKJnTjJblZdqg0tKXWXp9QzuBXZc+1nwSnaISI5JmaX0u2lzd/juZs9g0up4wk/NupO9e0x6efoo+e8H7lj09ZMqhH/ykw3ijxVfNruYxT8Yoatdj1ero3jghINx+GFyPN7/0IaalIxUhGpKL7tfza3VqXAe3BJaAsNHWtk2aiNdp+g5TXscnwxLrKL8CivN6CF/RPavYqWIp+opKLwh8g5xGnaPJELKZn+HjwU5IDub5mIPqCJRT+RjlyrmBLQDAaOSRkLviyTdhbWj+Pa9VNmL2k/I11yTKK0wzB+CLqho6/VVbieL6vCMfYxBKAblBIJc5V7LfyDILNmLFFvkRWvPYzF5sBv3Atqu6aTeylZAVE1P1jp4NcyRplxPrJ4N9ClavmScUMpW57UTgdsTAkoo9BlZyQyTGIaZYIeqAjvZjtYw4EWxwuWrGYjSXACW2seCxvCnOA9HtehOy+PK86Zs6wyQSWQ/5616segpjKyVaBefxFmLY5vJWDilnERAbst3CC1K4vDlT1vgYIfy4zBwxwI0G5bAx1tlO1RaBmWey+gYDHDPREFVFYQfs5tTluSwlO65P
 mx+EytcO
 gUn8d7014s/rNqD/WbjGa0BBN0UbncIYTfeo54DEZ7S1SlCPS0HfbD9/1bWm5QBnPLf0BPz4KrAl8VR/VQmPqAbxSmWtrvgFhV8oXZMzJSxa0V6BPUbiFP/fux4klhgWxiIsZMZcJUEfzXwqlHM2gqxEvJuS6R07y59hDB8w4GUbew/wikxcnnDAcVXR1lHat5TkSn8i5z9MLYXp9JF+swo9Co3+Dyh2d1mX18g7CxCBn28X5BYNv9JgaTmhky2BgjbvAClCZbu1kLT8MhmUrQ1jNPb0wdysdHIcvejXJc4hiQBikomPUkdZAfQpt1PPO3ekNv1VpZpjhM4VRBrNlhgbp8LTIcJdGkzRHwIHMs3+nfjASOZl1b3qHZr+SMTTSHb74Je9RIuiaQWy8VthhTVfhnilvTzXRWrNkDgz8TRPtY3A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Jul 2025, at 11:55, Lorenzo Stoakes wrote:

> Rather confusingly, setting all Transparent Huge Page sysfs settings to
> "never" does not in fact result in THP being globally disabled.
>
> Rather, it results in khugepaged being disabled, but one can still obtain
> THP pages using madvise(..., MADV_COLLAPSE).
>
> This is something that has remained poorly documented for some time, and it
> is likely the received wisdom of most users of THP that never does, in
> fact, mean never.
>
> It is therefore important to highlight, very clearly, that this is not the
> ase.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

