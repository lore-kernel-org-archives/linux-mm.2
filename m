Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34B1DF3026E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 18:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374FF6B00A0; Sun, 15 Mar 2026 14:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322456B00A1; Sun, 15 Mar 2026 14:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA1C6B00A2; Sun, 15 Mar 2026 14:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD0A6B00A0
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 14:09:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 635A21A0BE1
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 18:09:58 +0000 (UTC)
X-FDA: 84549086076.25.0B00FE5
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010069.outbound.protection.outlook.com [52.101.61.69])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9F575A0007
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 18:09:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RFutWs+5;
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.69 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773598195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqI+9lZUomm+PUe/S8eYLzl0foRBtncpKZj67oZJfcw=;
	b=wIHYjA+v8N/9wPW9PEtVznG7NH+cZLiPZrNKaVj89XKf6aBlyd8JqCN9zZIQQxbvt8H+57
	701NVoinU+Wnq/d0hCCtL6LUQKXCdq1OOMAdgbKVtvkNUtoFhwTPvOMvg/hYOt7siiSYyN
	j05FpuQMeLBApigvvLixjQ++a3LwgdQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773598195; a=rsa-sha256;
	cv=pass;
	b=rmreD2uobqwup8cTtW8dknYkdCNspHdwzp7UOFqTHIjSHCCUDUI2KYCbOrjOEK5T9C5sbS
	WkS1jm67JKRrDfcSBnoR7A+VFG1d5rMxwIlVyft2UG97EuSP0h8D6F/Rd9EmN2fcNCIjvC
	hoG3mmIhYCP34LmAXbW9EsRMlDr6gtw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RFutWs+5;
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.69 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QM0XUJ8ByCoxhcyeNiTJC8wfbSePpP84dUo0unWdH6F/SnkAlCzBlGFQnjf3XCRnqmHlnDrd1dIHSvSAd2aha+a4BJVc6NHbwgicp1wNR+dodnMcXLKu6ZVrcGw6GIetWggQfY+K91K5Dtxwl2DME4lvPDqWXetM01MONZ4IjXFUj6btDz6P3agdFUKaJwntydOjBZWZHiQxfAPU17UIjq/BVxcpJ530W1+YlqBWOAIhzgPulMbS2hDoWV8I786HtTEpG5QtMA5gUoYHpO6ldUI13zLxu3LGDsx6G4HsimLo5JFD5y42kgsyM3YLCNvbAwQvQjkmHxrZahNptadlsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqI+9lZUomm+PUe/S8eYLzl0foRBtncpKZj67oZJfcw=;
 b=he3r7kCr1nAJreqPzHjVi5C1PgMA6px0/ZyCNcV8wXPrDclte2Ynxyj4UbM5zZaB7gD95edJ4JDFDSVhK9FmtZtoCQbF1uLsGa3R/dgLSF5FhtpthHc1Wcz3sp1KqNDQ1+PI2ZyP5R+RSGO1fJ7CybgO/ncHUG3AkzKKKntxHNtbj8hnENkO2AX3FRjO16z13AtN8c4JACqONtPlvYRfBDd/QfRi9MBjRYkkvkObM5xkYcF9+Xbf+lu6N78jsuspXebM5YUwgBRlMFHQtFTtLht+OPNK0rHTvk7oXxdEgEFPTjfdwzy/eyPlbLjxqivGbazOLDpb0AQ7vyCxaWUlHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqI+9lZUomm+PUe/S8eYLzl0foRBtncpKZj67oZJfcw=;
 b=RFutWs+5OpOyWfBJvFY92O51sDAX/O/4CNwq3S4/U448e+xHBwwdOdvLVRWmqk2rAFcmnc0rPHbGQ0ls6oGSk7t95YAakXa83yBNpQbFB3Dfn3Vpu2HoNPWSCV7zOQPbkcl/Y//yvyKT22ceee88xWht0hFlUL3KtV9i4ngvK3A=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SA1PR12MB7317.namprd12.prod.outlook.com (2603:10b6:806:2ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.13; Sun, 15 Mar
 2026 18:09:51 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9723.014; Sun, 15 Mar 2026
 18:09:50 +0000
Message-ID: <f0481d72-db3a-4b47-80d6-0652a8a218a4@amd.com>
Date: Sun, 15 Mar 2026 23:39:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 1/6] mm: introduce folios_mc_copy() for batch folio
 copying
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 willy@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 akpm@linux-foundation.org
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-5-shivankg@amd.com>
 <d55153d9-4ff2-4975-b00d-5877ae80a820@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <d55153d9-4ff2-4975-b00d-5877ae80a820@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0021.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::24) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|SA1PR12MB7317:EE_
X-MS-Office365-Filtering-Correlation-Id: f8fa146c-2d58-4719-6bdf-08de82be0cef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	4IuNYBxx+l1oO0zkK7t3DFEeLiHiS+QPzMinD/w04A4Ecugu0Lb3/IV0oARgNpctvWwXLy/aIyvD4CfB6moC0FGrwqtmYQi8LUTkrMSAuIbR6uQUFIHpuVIK8Ue2kORWn/l+fDmdMPY9SUzz73HVczbiNUVW1G13Z30ZXX4uMQTSiGmSJiROIGoGzjwmxt0QtRSxw3V3EtTGN0telCGRVGrYD+te5CdVy9THBdIfUxdSqj+LXEi3Nmq9IAns5vPrMm2LGVAs3UYd116WiQS7UhZ6uuidKqsFGtQCk2H3J/rpGLm1z0QVW/zbb/NRO9YoRuni+srKPFXphjauQoUY7rJzRrqWrS7PkU4FGro16c7yJvjy1t59FI957+XYvldlNi84prGOYZ0lV4bipvEvI+y7L3qPzeW+KbrXfqbBYvUalfKV3I5zB2nZCWWFwafu7xoyyTJE1IKmNeMrNNpRZLJ6a2xEshp7oHCI8Dtlj6Z6jrXdtRdKgiEDPFOWXqYIxKeC9sz/5+CBbwkkp9jW2dnT87c4Add1feSsJVqWxI+jFxLUKDIwq8EEmIZbixL91Qt4DrojyacYtGWAXyo8akLYwNw379Ml3i/HUg/1bAmOEpyE5OSlHtGMzLxysNoVpMNmDuOXnkK835GLjEU9MHwWK6HEJtqSkY2NWqJoZBAlgq/SUlbMm6m+lfUTuXJ2pjApvLhaVOHA3xlKDCk9K8SjpCpUFVbfI7AHnVoodOQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1lHeXZJcWh3bEgyNGtWMStnWC9PUlFMK1ZPRmRzYmgwNThncUJFbDFXU21r?=
 =?utf-8?B?MEhsUGFaaXdENE5SSkoyUW1BeDROVWw2M0tIOVBRd3JqeVQ0ZFRVTFdnME80?=
 =?utf-8?B?Y3FHc2FCSjU5Sm5UaEVjWmM0bWUvSjJ5bTBka1RlK25LRVVUV09wRFVMMThq?=
 =?utf-8?B?dVpqUkxCU0RIUXJlUVVuSFN3bnF3bjU1REF0eitwOVdKZHdGcEpKVCtoM29O?=
 =?utf-8?B?M1VPcXR1RHgzMVV1U3k1Z0tTZDJ6N21GQS9MZWxhdWVMdzVpZUYrSHRmV0dL?=
 =?utf-8?B?SmlUZHI0Y0FiMXBRaTR6clZrUnc4aWJ5aHo1cmtScXE1WTIvWE92UEtJREZV?=
 =?utf-8?B?ZDhUN3RnRG1ZN2UrejhPVm9Ha1c0UkRHSzRFQVl2SFhVQnFqWndLYXk0UGp2?=
 =?utf-8?B?UEQ5NW5SVU9JMDJEbmd6c2g4eTFKYndpbFM1NEcyN0NsaEgyRGxKTUJaUm9m?=
 =?utf-8?B?allMcWEwTFFwUmtNUkV6WGw5ZnBJMEc5djl4eFdUVWNDbHoxWW8wV0dXV2Zw?=
 =?utf-8?B?RzBmLzA2WS9UcHFHdWhrTXVVS2RWMWZaTDNFYlZtNVdyTnJxbm03WXZ0YkQr?=
 =?utf-8?B?aVRwUkVBVUFTbHcyS2tSZFdsNk5tczArcG1QYTgvVy9Vd0Y1Q2taeHFsU2J1?=
 =?utf-8?B?Y1N5TGtQSkxPajdvMGphUWZKR1ZoeVQ2VlZ1WkZQbGNSZFdBbUVLOEtsMWsw?=
 =?utf-8?B?WXd2Q3h1R1p1VTRPTitmbjlvVitpcFFGZ2FFaTVPZ01PVWJnN1pWcXdORGhO?=
 =?utf-8?B?VEdldUdXeU1nUnZpZ241azg2VU8vQ1JRS1I2SlRibGF3VllFNERQMXUwMFR0?=
 =?utf-8?B?dEZVc0laSE5tME5nVmcrMWZRM1VDTUxIemZoTVhJSlo2cXczYjBlcjdXNytQ?=
 =?utf-8?B?TTBuOXNZWjZZcVUrZFQ1bmpoRThXOHpjRDhNQzJrVktxMXYvRXFGUUVMTWFZ?=
 =?utf-8?B?WkdOMTdRYkhQQldXRDNNNUxnZXBNdnpXUGNCQkxKNUxLVk5nT3dMeGt2R2RF?=
 =?utf-8?B?aDFDZzNQVmE1Z3I1WW1OeHNlYTBHY0R4N2F1ZzVHZFd5M1Bxd1VpUFM4enFU?=
 =?utf-8?B?QnBvc1lwU3Y0SmVOM1poQ3k1dkhacWk3U2x3ck5zYkhXa1MwNVh2bXVMSit0?=
 =?utf-8?B?NFN6RHBzRE0zeW85TEZ2cDFtbGdaKzNGLy9BSzNnYkJQUkJxaW5SSTlmbmov?=
 =?utf-8?B?eER2N09TZUsyUVNPYVBjVWFUMXYzSmwwamc1S2xuTXc4SVVMdkYrOVAyWUxn?=
 =?utf-8?B?NnZlSGpEaGs5WG5JN3BmK3ZMYjdBY1JGbkZWQnhpdE9XOGZ0OTNSdHdoS09K?=
 =?utf-8?B?aWl1UFhHa3dHZjBRQVIyOVRpT0p3WW9oNFVySnlQczlGSTVjU28xaCsvOUlU?=
 =?utf-8?B?T2w2VGdwcXhjUEtVRkRNWVBSVUozWUxOWEEvTTZ5S1BnaHNnanQwWVBaeW9m?=
 =?utf-8?B?N3JiazFyaGd5eHg5WHZOK3hYd0c0R1NDQUwvZkZCWGhqTXNpdFc3cUVUN1Vj?=
 =?utf-8?B?bHA1dzFLS3BvRFpRTnZFRDZubWw1RHZGU1ZRUU54S2p0TlBweHlVczI3aXRI?=
 =?utf-8?B?cDkxU2U0OVpIdGZSS0hMY1ppdXFaZWt4NHYrL0JhMmdnWlhJUWJIMWt6MThM?=
 =?utf-8?B?dEdMcWpLSUdhWkZzME5VRTZFSHlwbGM1VjQ1eTFPQ2xtcGRYSExUcysyOCtL?=
 =?utf-8?B?OWtaSHlvOU9KY0Z6YXlBYXlCQ0gwbHlVcUVYblJCeHVJTmNzSDRQMnBwbHBV?=
 =?utf-8?B?SHNzMEh2cTIvT3lEOWt0V3BMMkJ4Vm1YdCthTHhQMTlRV25lMUQrRXVGbTQr?=
 =?utf-8?B?YmVGNXRNbHkveFJYcmMxbUt5VzFmWTVVU3pUSXdGdndMc2tTbW1lT0ZaVStk?=
 =?utf-8?B?UTFFdTVROCttWm80SlBySFlqdk52MDNwQ3VKYm02UmxzT3hCRVlSZFZVZ2xH?=
 =?utf-8?B?VTdaOHRkVVVGRjA2Mm9SekpnRHMzdWxOM3B2RDQrSExhUnh0TS9oNUh6OEtR?=
 =?utf-8?B?QmlSb1VqNmFmMXNrdDBiUVBmOWhsSzVIZHFYcmpJL3FQSTRENnJ3aXV5LzBn?=
 =?utf-8?B?Mkh5VEtwTUN6K3U0UFdNbEl5ZXUrZVYxQWxBcnNqR3liYWlnVkJhaFNjVHcx?=
 =?utf-8?B?RWdGbGxsbVlLTTREMk5SakprTnd0THZjdzVKbjdRNUF4b3NKQktMZ0RzMXVB?=
 =?utf-8?B?SkpmZ0lZdFVlTjFrY3hnelF0K3F5NktjdDdoUFpWSFlqNWl1c203UmtSemdO?=
 =?utf-8?B?cFJNVStZODBEKzBvVGRmL1kzUUlpUXduRlU3bm84VFJoc1JSTTM1Q3pXKy9k?=
 =?utf-8?B?YlRaUERYem53NlA1U3pJYmdoRHRaSW1ES1QzVUFwZ3pkZnV1UnBydz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8fa146c-2d58-4719-6bdf-08de82be0cef
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2026 18:09:50.7260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BO5c1LLYrGdqY3SGliOJ3UnyUFJQHK7M32IHoCD3xwoPN/n7w0GoGVLdYoPIZKRtZ6luohwsx78yYRTCdWVpiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7317
X-Stat-Signature: q4u7t6k4fdhx883u44edmt4uknye9ath
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F575A0007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773598195-892510
X-HE-Meta: U2FsdGVkX1/Rs0VhD5NFxImtyv4VrvcN6hjrfGnXWbX50fwV3dE1JpFcgBb6G8wr1M2myputY3c4GYkMjw9KrrDLXk7lDElXGwLmhuvJMVXHjdBMp45QLHlGvnO7pldPjSG2XXV5UgaWRP1gE5BI+nvLPzxHtacuRn389lI+y0QybAvdBBWFcU389yuBdsdg18zgwq51/tPOl6dvgFmDmwjFQeqnQR/OrTL6JCEDFSwCh6TC2Iur1rbDeL13ZrgKwNarMcNXQovvb8VXlxhN+7hJ+jzCHPraG1aucIdBdfmhIeNceP4Rtu0e/+UqsvFRQ54/FIy17XqzK273qOiC3QMkm7AS+zuTraylhY7ocFetFAE8yj+t9eelXjKUcGA2Qu+ZtQPqBU96/3xvLdGmSZpm5hv8vl/l+NsMyxhIqY29QQ6UJCciHfLYazrO/VA8R41iKKIRqgA1mqBz2CEdn4c3KBT/cdq7fvgqhRpf9mpc1FBYOfGbFMDIKYJ/Z5qQiOlAe4WQCFcZgTGNtQ7wZ8i3Bqu4j2XiwH/eFXJyqIRQrS64hjJfO14LV+Hk9OUVCblhj0RSA67G7NSN26B7duyNkkebC/UgBeGRi86Suv4vLTatLGQUnH2eNYW1wVeHcUyiHwoPvX+J0VrXx7aunwA99Ps5/Fqb+aABRGk9gYDlj7kcKZsNhzgcMZAkKWt9y3DO+5rtq/RdD37eORC2c6OmlI7Zk1/UgwFZIFaxmV5lMlZc2DAcXH6Nsqm7mJBuHxE6T1/+cDA0fOaCeMpMWLKFEp929xyFEu6Itq2u1OCrqOJgcgGcQnLfpHQzsScpsWDhyrpaijPxRtlXioOlzFBcLEV+5dYPiNju31rLy41wAXXoPmVlaQXnMwTCrg/7WX+4cl6p8upcovOkNfR73/ayQXlf2N/qo9sto8Bj0TcFqvM4Q/yTt0kfTdNDNck3Q0CHLnJSf3H09wNhffM
 mhTsN9/f
 OGPX3eH8ZRDCM4IfVZX/LxKUsYB7U9+1xwc8GrvZcoi0BvnRrLm7Q8GpSQP8kfiPclqlh5EXxnCr+YQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/12/2026 3:11 PM, David Hildenbrand (Arm) wrote:
> On 3/9/26 13:07, Shivank Garg wrote:
>> Add folios_mc_copy() which walks list of src and dst folios in lockstep,
>> and copies folio content via folio_mc_copy(). folios_cnt parameter is
>> unused here, but is part of the offload_copy callback signature used by
>> later patches in the series.
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
> 
> I'd just squash that into patch #3.
> 

Done.

