Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D63C55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 18:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9FC6B007B; Sun,  2 Aug 2026 14:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283596B0088; Sun,  2 Aug 2026 14:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1241D6B008A; Sun,  2 Aug 2026 14:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFA556B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:38:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DB6E80329
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:38:14 +0000 (UTC)
X-FDA: 85057189308.03.4A25936
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010067.outbound.protection.outlook.com [52.101.61.67])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6A0CFC0003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:38:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q37ISOhE;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785695891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=87NnrBxy2Mw90V8oMPqqUIoaVK7V08FQ22F9FPtDlok=;
	b=tLxXKth0plCk5X/fNjswAKJSiHfhn8AQbIMDnPIhwTH7CHNIqfN/WjvbRvqJrttGmkxXys
	Mc7w0RkbJApwoi1Tn5tz5qSl1A4RTErGLAXAKmPXLhLMJ9VlFzsTmQ9w0iWlMDdNJmOM3b
	8yq6S1xKiKqu8s/JxAf7KLvX39D9XjM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785695891;
	b=TB5TSGz+Ss9PhdjoSniuGVxML10S9nB19KUIfqEPkcr7YzrOllckpC4nQQj0YUEpR8+fJb
	j69aHyr0qfpjK97fVfJEgc3GIwzj3ef9kVMeqUkM1VgG7Ryt0PamQJqrsSgTVMIxz0P6BI
	z0AisPe22q6hZW+2voT3kGCpmve6e70=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q37ISOhE;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mtp85lCgG56P1WHqspHG9tB3RwO/Vo+LUfcRj+aSNvh6rcgaJDXPQrTvC45GArsVI9CH3DwuliRKwB8KM1QeMGtou1UtS+ZsQvVe3NBPtq6EZ/Mp7Jm3ritnLs8zQZ+Zyc8nKdLZOnUwxItlb6LzORiSaOzTj28CwbX4p4y8TbVlD4fy4twMrZfdK8p+RKuIBCD9v5MGgpftp93iiF0PAXKmEMeXpk29MQMYcb5tSbfaRPvrwdE43zmxGZatVkS10rUZX+wMG/T0s1fl4p+vcOR4Icr4vrF+M/6YMrBT0NAlexyxkR7GcZvY6uHwJ0CJ5rIFkFQ/Ll4MYSgYM3XqOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=87NnrBxy2Mw90V8oMPqqUIoaVK7V08FQ22F9FPtDlok=;
 b=Ucxh+AWUnOUfTOxVsu3Hehd5ovkSME5FbGnvcZWesB+zmdUxy3JSCfhhMl/AgjC1KukmnCO8fYe0X531k2CxoVP+DVME9SHh52Gm5eOG+V2WWVw+RzljgEdBWRFn29SgSz2RxQOXJgkHmUdAE4PlDDcM4lyeMlFqF33qs8/vQO6gwrJW6II3hOdibGnHlSCWW9F5iFbAU9UXXNQvXBxFk2CDmi9KwbF3STIvFTG1fmvP71uLPzHG9XNvZfkLchsDcF9VrGMrzJokzUJ+68/CVrRYEEIele2MtAe8D7D2KI0Tx1wQzJITWmEchlllYBB6dgxNIpBusBDtUOFgXwOkpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87NnrBxy2Mw90V8oMPqqUIoaVK7V08FQ22F9FPtDlok=;
 b=Q37ISOhEJOq8GMENWv8+kck2b6RUbM+IX1L6HplAS1v9euaV1oCoEoMR5wlPkXqmvreUF6VgPwM58UGMS7w3QcnIR93qPZ9S/UNbLviantvLQc0zzMA4fErnMsEsfi9CvnSmpdRG/H/AqVj0odlIq3khtiddZm1WnH8ofQKmtHaTZ9f0ANDW54x0sA+ePeeWG0YaWjux2TJIJSxJsbhu+CVwAcL+V81hThoGKf5u2KTkWPpJqEsfvVxKM/JZy1W7OaQeQhiduepP78e6Udep/q6A51a1mvqTCou2LkW0uKvtiRbW6q8PUd60+xi+dt2TZiJvnhrZf/W2yQ6Q4xB54A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL3PR12MB6403.namprd12.prod.outlook.com (2603:10b6:208:3b3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Sun, 2 Aug
 2026 18:38:04 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.016; Sun, 2 Aug 2026
 18:38:04 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 02 Aug 2026 14:38:03 -0400
Message-Id: <DKEOCZV5LOCD.2ETK6QJX7UJMF@nvidia.com>
Subject: Re: [PATCH RFC 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
Cc: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Kairui Song" <kasong@tencent.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Minchan Kim"
 <minchan@kernel.org>, "Sergey Senozhatsky" <senozhatsky@chromium.org>
To: "Usama Arif" <usama.arif@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-1-142c97ba3562@nvidia.com>
 <20260801141259.627022-1-usama.arif@linux.dev>
 <DKE0CO9RE3TN.KYL8VQE6QW66@nvidia.com>
 <b3f03eba-02ed-4763-86af-cafc23e0006f@linux.dev>
In-Reply-To: <b3f03eba-02ed-4763-86af-cafc23e0006f@linux.dev>
X-ClientProxiedBy: BL1PR13CA0299.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL3PR12MB6403:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ff47a18-3e7a-4bcb-638c-08def0c53028
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6Yk/SJ5u6aIft0McXz/9+Dm5ve1apOUQdINxGKpKOUck+D3F4ukD8mvhYARX1VHte/glPGkJCZOaRbAlkIHgL3/hMGrqjlOOzPCPpjVUlk/oyp2EOwtJP7D64afroqJGVpCD4I4TpgB05FylzIZ80/uKp7XkUwCXMNB6z7iSoQGDQQ5vT2snzGNgTtrs2SKv3pN9TOLs782ldmrRCrnssqUCjDWrzvUR219MF9Us9RvGySnOZ7nXjMRloZdlkuNvdDve8WNy4pZ3R862gkssd30UWg0QRwPHbvrwoKzhOlxAevVukUOaI6C6PeSiieBtRJaf5ZsINhH1FxIP71Ma9LR8jaaT2VyfljNIsXmdqYABVZpv7wWcu+whxL/03nJEKC11OnNIDJQ6s6xukEsaSxxBDntPidG69wE6DogG5x61oEBOWRVCDsVDZI9jbE8hFxRbBEXQAYhKaS+Gy8B9DbrntCWVsLjUqQUz8Fe1VhwbY5355iASZrqjn4FsfVb7Q6U9HQWXmtQX+nHhC7VoqBQ8w76ZVyhUbYjTnXETt7E8sQ1CeB+5javNTbifpfLAt3ZjQruu/AIYG6mrwAYg8k09rHiY8IHWTUzsZIi1Na9IVBNGEFBnG1J8d7ShnWTYRTd3X8aksFM7H4mjeSQ5tqhDb4yHRb8iZ5+LA+obOBM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkhPSldBYTBIdkprS01Ra2xUNFFpMlVTSTVIa05tUFFxNHNlWHZFN2o0NFdZ?=
 =?utf-8?B?enRwbUplVjB4UVJtOWVud2JYTmtUSlYxWUJ5M0FCNGRZeHRFOVR3Z0ZORUFM?=
 =?utf-8?B?eTlsTXR4eGNCVWxRbEJRWVZSMG5yRlNFWFM4ajRUVVV1ZzNLVFVsMjc1a2Vo?=
 =?utf-8?B?WStkM3pBYUhLMDJ5Q2MzSFVlaHA4NlA2a05jK1gwNW5TRTFzbDA2cGNjUmp5?=
 =?utf-8?B?QVB4UzdyU2JUMHllNi9SOFJpQ3RiNnFrZzFtNVg3aGRvRDhsVWFZQm5wSFNy?=
 =?utf-8?B?V3NwNmdDVWxZN1JQUnhTN3Yxdm14cWdnOGlsdUFHTm9wQVE2T1JqUWVyeEtS?=
 =?utf-8?B?aWxaVlJndU5qS3ZoTjErZlJHRGVQMkZEUnZVUlRFc0x5WlRPdHBPemFBTWZR?=
 =?utf-8?B?UE5NV1IycHU1MVlKODJ0Q0QxcUx2dUhYRUxSZHdUTXNYV2R5VmN6S3ZSOFFv?=
 =?utf-8?B?emNkY003a2ZCQWkza3dDcEc0T0VsM3ZEaUNGbkw4bmhjQjZHdWlDMmhnSk43?=
 =?utf-8?B?RlliZHV2cEZ3NFAyN2pqQjh0dU80dm5nSEdxbWFaTzFhZWdXUWpFT2tCYUFB?=
 =?utf-8?B?cnpjbUdzYlphdW8xUFJLUUgxbDdrdVRtbjA1eWRTZUJlZENWTEtZZFBRZ2xi?=
 =?utf-8?B?T2xVWmJVNS8xcTF2TS9TRGlpWHdzektQTksrUzVXMG16UU0vVzU5Y0llTm5a?=
 =?utf-8?B?UUxDenprY3VSNjFHWVcvN2hmeHh4MmYvMk82WHpmR3g1MmJWZEFtaFd0ZHBn?=
 =?utf-8?B?L2JvUkVrNkJtbU5QM2loemZ0Q1JoYk9oZEhMVnRSSDBwTmFwTXQwVk4zOGc0?=
 =?utf-8?B?N1hXMThrS2tKdFRLUUk0NWRvQnRjWTRvcWVVVGs2RXlUbW9zUWZzT2Q4b1RM?=
 =?utf-8?B?MzRnbWJBUGRkcFBVQVpoVEM0WW14OUFWVmsvYXFGQnU2NVJ2Vk5MdDFhS1BY?=
 =?utf-8?B?WlNRWU1mN3VWcCtWV3U3RCt6R2g4Vkh0UzBZc0N0TWZyUk43YWdIclZZRXFN?=
 =?utf-8?B?RHRxb1dMRS9KS1hPb2lwc3FZRDhJa2kwRlpMaEtNZHV5QXRheTRmcU5ySVU3?=
 =?utf-8?B?Y1RyVG8yMjBoS2JhOStHRGlURVJ3U2JaaVlhZHgzTVhyNTN2dFY0SDRUZzBB?=
 =?utf-8?B?ME8yVGNQbEg3VXBXWlBsQjlhWEcwK0p0ZlVybkNraE5EazhIY0J3YVZFN1NY?=
 =?utf-8?B?ZWxPVEx4WndFOXIxcFpZOFNrTFVuZEsvSUFjYUxyaDNJR3RUdVlMWnB5VmtO?=
 =?utf-8?B?MmF4b00xZ1o1bnE2VVY4dTlRS2Y4QlZ4d015Q1JLZktWRk05U2gvR1BMUkV3?=
 =?utf-8?B?bGM0UkVDNGxDZDVacUNpZUxjT0FKQmgwZHBibllhM240MDV4MC9GSzUyNjFC?=
 =?utf-8?B?Tk8zY3FBM09QOFBIK1ZiWFpyRGUyVXpjbHR1Qll2MVRVM1VzejVJV2FleXpv?=
 =?utf-8?B?aElqOFJYMCtUY1F4NFBqVk4ranRSMWEzUWpwNGVKUnVFb1d1eDYzTTR5TEU2?=
 =?utf-8?B?NnNaYkc3SWFGNTQwN1o0bmNObEJ4Y3dTclNiR01iOWcyYWNhSkQ0ajVQQ1Z0?=
 =?utf-8?B?RzNuOTk1bS91TXpKZXF4R3Z0WXFEd09VU285KzR4bllIZkV0NjZGRnZsK01Y?=
 =?utf-8?B?REFsVVZrbnBidTRRS2N6MkJjTDA3dTJud2tGS3h0SUlrOVJMUG5QSkhoWndy?=
 =?utf-8?B?dFE2MytGRjd5Umh4Y0ZKa3BydWRBL0JUOHlseEhzdVk4ekVhYjJDTXJROG5t?=
 =?utf-8?B?WkRkNEU2VXhwTFljdWhJSUE2a1psUkUrN2JPcHpFZHJPb3l5V05PN21kSCtH?=
 =?utf-8?B?elZEZStld1liWHM3NEtOaWluU3pWa25rQktDQ2c5Y1VDWldjTzBQVXl1OGFF?=
 =?utf-8?B?TktVYjdqVENPSHhVSFA0YzRMNVN2Ujk2UlZOQXdkbVZnMVZFRmVpeVBoNy9z?=
 =?utf-8?B?dE1tczJGNHNrN0h2N2Q2Nm14aWxzVFhoYng2NllvOGNrNnZMNU5ZVE1xbHl4?=
 =?utf-8?B?bFZubkV3VHNhOG1QSVAybEcxTUFXaXZpck42citMaE1lRHIyWlByRzRnWVpE?=
 =?utf-8?B?ZnlRZll5bExQU1VXd0NQcU5nRVQwRjVYL3ZGM2ZGUllpQTR4RjYwL3hSd040?=
 =?utf-8?B?UmdBUkFad2F4ZVdvVzhBMi9zVm1lV1RJcHpjQlUwYzlSY0hWT1ZUaEpjZlVp?=
 =?utf-8?B?eVc5RFBBZFhRRVZuNzc3T00xczZNdm9ibDRrRDdtdEFjUXl4dWdNWGJ4bHJH?=
 =?utf-8?B?ejZlVVFSTUp6OW9HeWFPaHBtNW9ULzNtUmRSS0JWTytqeWQ1OTVtNVU5d0pF?=
 =?utf-8?Q?jaNO6iCYguSG4LQ3YT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff47a18-3e7a-4bcb-638c-08def0c53028
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2026 18:38:04.1569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ge0h79Ak1sTDGZIJhPx3J8tAd1PrTZ/dTW6vxHCCu4y+uHQjlvCbiUPta23OwFLo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6403
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A0CFC0003
X-Stat-Signature: xrff3k99fu3cfqtyqdpmq985j5388aga
X-HE-Tag: 1785695891-861371
X-HE-Meta: U2FsdGVkX19ddRGZUg9Sl4CFRWiqayFEuabCm+OjN767zrKUybKuQ3lvmpJnz67IzXzEkJ/OrUQINXbvOqPGYiqcLIFESUI6l3878WjEkK/St49HEfPobZNwbmPTDY/EY5c/+t9F/XEqKoRKvus+5cT0UQrbzjwCtTAEwoXpmAnEqHybyICicRQb802a0XmdVl3QNoux9ND2VifpJlnnCpad2OwSt2nRVB1DPg5Lwm9P5jILehDB+ggGfgtoRJsUVUq+T4mMi4/JkpfFF38rwYANVJrWbJaQKXGNw0HYLjEKIXQmC6XaltGxbqCfSaUgmVXjYSSVibY7PkBbsDI2sY4RZI4BpGiaMCOwx1/QwHKP6ePJpxjZRzL3bWQGXGYZYspSxgRFPB5hfNN4x3tnkAVtd6EJmWZj8x2vFIrqEARLzpjup/LO66603dThukOpdrrT/EAczF7K+WAiiLaq5CvUoqxN0b6px2IfdvZxPdcNtSrL3EWZEKMBTO4lfRilRNFze6L8M5p7ULv8+Sv+x5l8r5Oha7tZjp1QLINIc0ZEipU3/2U+6Fgthr6SN6mXxb/kFdKPHVDXcm6kcD5MQ5J2veoMn/WxxALjM5iuSlNIAkEvgJIWxiakcWLgtXnVsxWZn+zghgP2TIIq/B/W66CpJwITGz4BYLkYWIe2U4qj+WDUsKBD6fm1wjaDT54QICoCrhALoahq54WqZZE4jSR2s+RwhcNB16NrVsx0d576pITttcnnj5ObDnS+bfAqCia6l42KzNRJwl5d1IuaZvJ46WHPBf4Ud7BXwI+MgCVvKqYQB5SDf/Qn+eGwup+0vIOdf37huWN0eoLvtlWwZCF/ZFWFr8e70FPmY/n1oSvX8/L4zwxz7IgcLF/cYsj0BPEMY+qIFpsPiF9aAFEb4thT3yQOl03QjsGgCxkBDErT0SqpnImKug4AMdWKM//vKZyfRUQ+KbYEpMgZhJE
 t0y71oEm
 ChfOT8gxtvyJbemC0hkBDZL0BBRD1trYtgoLJjqHLXuVV7PTx4zW+rdtXfx6Br5Uhh9F9+0bufKcclAfb6Lov/mdBHN0iCReUN4gI93yFZydJ6lx8Qc8PN5VNb/8b27l0S1KqxwLQQFBH2hZs9AF+YiYPx5qNAFHCIluP/qT8eT1f1AFPnH1r927MARS8+dWixC17ykOMAx98p6rV8EA6D/5oEX9V8gNpgHWHB6xplSSNhRoViNl+vSFk9Bd7Ufb0R/5bdTcD7qxu87ynk6zNWIIr5GW0k7ACrWgvRzZxB5+uslvVdN98OwMi+NOrwnRA8RJfu/tXwUxyle2nBO3YzbFym9zrHD0QMlZwaU9zufwVj+rrkifck1yo5byNxmuIUYIcWfk4rt7xYlzyWNcJripO6ZpIYGowx7cWrf+QyrTzDAVOFTBbAmWYRIUvMvhiiMJsHc3+noAZK4yldTSCtX2sWTRrL2QYtDYssOxXdk92UoOuGUYCBO0ScX4A5VTK/gGXXvwB+/PpCmb942CXZ6I5Dd8qAUxXF9pth5aH9aBySHM+XRZn96/BSUQPO7HuzvmmpcgEIxpZix/x9sHiSMDLDqfLSl+vMY8X7NW5cSQ8qlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 2, 2026 at 8:05 AM EDT, Usama Arif wrote:
>
>
> On 02/08/2026 00:49, Zi Yan wrote:
>> On Sat Aug 1, 2026 at 10:12 AM EDT, Usama Arif wrote:
>>> On Fri, 31 Jul 2026 22:13:24 -0400 Zi Yan <ziy@nvidia.com> wrote:
>>>
>>>> zsmalloc uses PG_private to indicate first zpdesc in the zspage chain.
>>>> Replace it with zpdesc->zspage->first_zpdesc =3D=3D zpdesc. The check,
>>>> is_first_zpdesc(), is only used in VM_BUG_ON(), so performance impact
>>>> should be negligible.
>>>>
>>>> It prepares for a future commit that remove PG_private.
>>>>
>>>> No functional change intended.
>>>>
>>>> Assisted-by: Claude:claude-opus-4-8
>>>> Assisted-by: Codex:gpt-5
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> To: Minchan Kim <minchan@kernel.org>
>>>> To: Sergey Senozhatsky <senozhatsky@chromium.org>
>>>> To: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: linux-mm@kvack.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> ---
>>>>  mm/zpdesc.h   |  2 +-
>>>>  mm/zsmalloc.c | 15 +++------------
>>>>  2 files changed, 4 insertions(+), 13 deletions(-)
>>>>
>>>
>>> create_page_chain() sets zpdesc->zspage =3D zspage before assigning zsp=
age->first_zpdesc,
>>> so LGTM.
>>>
>>> I think the assertion in get_first_zpdesc()
>>> should be changed to
>>>
>>> VM_BUG_ON_PAGE(first_zpdesc->zspage !=3D zspage, zpdesc_page(first_zpde=
sc));
>>>
>>> in the current check, we are checking
>>>
>>> zspage->first_zpdesc->zspage->first_zpdesc =3D=3D zspage->first_zpdesc
>>>
>>> which is just testing the backpointer.
>>=20
>> Got it. Thank you for pointing this out.
>>=20
>> is_first_zpdesc() is also used in obj_allocated() for the same check and
>> getting rid of it in get_first_zpdesc() causes inconsistency.
>>=20
>> How about the changes below on top of this patch? is_first_zpdesc() can
>> be used for both sites and looks cleaner. And VM_BUG_ON_PAGE is replaced
>> with VM_WARN_ON_ONCE_PAGE.
>>=20
>>=20
>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>> index e8ef227624efa..f021d2df99404 100644
>> --- a/mm/zsmalloc.c
>> +++ b/mm/zsmalloc.c
>> @@ -471,9 +471,10 @@ static void record_obj(unsigned long handle, unsign=
ed long obj)
>>  	WRITE_ONCE(*(unsigned long *)handle, obj);
>>  }
>> =20
>> -static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc=
)
>> +static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc=
,
>> +						  struct zspage *zspage)
>>  {
>> -	return zpdesc->zspage->first_zpdesc =3D=3D zpdesc;
>> +	return zpdesc->zspage =3D=3D zspage && zspage->first_zpdesc =3D=3D zpd=
esc;
>>  }
>> =20
>>  /* Protected by class->lock */
>> @@ -491,7 +492,7 @@ static struct zpdesc *get_first_zpdesc(struct zspage=
 *zspage)
>>  {
>>  	struct zpdesc *first_zpdesc =3D zspage->first_zpdesc;
>> =20
>> -	VM_BUG_ON_PAGE(!is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdes=
c));
>> +	VM_WARN_ON_ONCE_PAGE(is_first_zpdesc(first_zpdesc, zspage), zpdesc_pag=
e(first_zpdesc));
>
> mhmm do you mean=20
>
> VM_WARN_ON_ONCE_PAGE(!is_first_zpdesc(first_zpdesc, zspage), zpdesc_page(=
first_zpdesc));=20
>
> here? ! is missing I think?
>
>>  	return first_zpdesc;
>>  }
>> =20
>> @@ -828,7 +829,7 @@ static inline bool obj_allocated(struct zpdesc *zpde=
sc, void *obj,
>>  	struct zspage *zspage =3D get_zspage(zpdesc);
>> =20
>>  	if (unlikely(ZsHugePage(zspage))) {
>> -		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
>> +		VM_WARN_ON_ONCE_PAGE(is_first_zpdesc(zpdesc, zspage), zpdesc_page(zpd=
esc));
>
> same here? ! is missing?
>
>
Oops, sorry, will fix both. Thanks.



--=20
Best Regards,
Yan, Zi


