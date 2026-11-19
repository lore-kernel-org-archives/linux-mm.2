Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C7E060A2604
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=B4dg8CJN
Received: by kanga.kvack.org (Postfix)
	id 62A886B0676; Thu, 19 Nov 2026 12:06:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602456B067D; Thu, 19 Nov 2026 12:06:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAED6B06C8; Thu, 19 Nov 2026 12:06:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC356B0676
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:06:05 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD35A1C4676
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:06:04 +0000 (UTC)
X-FDA: 85452496248.02.FEE2E71
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011023.outbound.protection.outlook.com [52.101.52.23])
	by imf29.hostedemail.com (Postfix) with ESMTP id BB16012000D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:06:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=B4dg8CJN;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795107962;
	b=OKrMUHEnR9d5uDlV6lNLe6gCdTWtrZ5YYkPmhJGTg23//exx0aMoCEMbwyUA0sHSeq7MqB
	y3TbXkIUtN6OygEik4my3Qo3dAF79hb6SriSFWb25CV0abFRO8h3eZMQr0ql8T8pCSlHjO
	1eA0XqbCmn9ExSxWij9L9JVsqKmj3yQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795107962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDeAFAcJCA1EX1H0ZzF/45lpRqhjW15oKF3EGMs1RMQ=;
	b=Ai5UbYjt+roJMryKDj4X8ic0FyobgjVvrHidc9N9FjelJvzFOOWt7IPUGW6ue8tHJ8bZl+
	l/xlq5MdENNQpAR3cPgK7TQ3/CHq5FC5c9s5SEzc4tyaDrna9DImsIokDEV5oiFTun0msU
	m6lb8/mHaGMA4JTLFSkm5KnH89AzIos=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=B4dg8CJN;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wqJVqP6Wog/rIsuPUkQ6V2fQaFrBcOslbUXS+U5fgbaUjA8ktCfuNScovlF0HA3tNhmfTapNawuYjFLq4LigBUKjOfM1ExGmdGPEiaunWbOWSFroEQ41URlH40PNZXZhY3xXL7ZCBLN8tx/ksLRpXX1fH4XRsv6lRx/RCFrRQouhJSmxSVIhCnpJlbSgsqD52LZXKnSyxPL/1AH6u6RhRXnbRiQFe0sVj/Igl1Xok4oy2ysswbly7eebJbGdQOeoTWlSv+PRxdjCZBzCaG8seiBOxn6w7I7rqCuqP9MbhvqkuHM7DjAebeAce/YInz8D/AcVxRzM706Mj0PloGrv0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDeAFAcJCA1EX1H0ZzF/45lpRqhjW15oKF3EGMs1RMQ=;
 b=OWxfTzCWacE7xXABN578PbmZ1An5RldLCVYsPtd3QXy+qeVvk9HP73u8xQiGOJcqYoz38dNFAIy883puMydNxjkQi+4MSAfbSY6U7fYq1zzBMT+fS789mSCWsrIqCtVEf9BTaROOiSa8kw2EsoJ+pKgnDDX8+BFHkC0rfR0a/vAP/wJ2MVb5YazaZ+hGyDkiflQhnKrk8D970OXOBMbEGr3qWb3ERD6Uv2OhHXRa+BjYXFAX1yZbUQgvlhy1xTUgLurzGF9xAQ4y2stKiVw4u0RF4dS3Wt0FJrTgoZUF+KU4x6mKGFZmk4ePzfhsSxGCDhspo87fzipsA+paWyAyJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDeAFAcJCA1EX1H0ZzF/45lpRqhjW15oKF3EGMs1RMQ=;
 b=B4dg8CJNmhjWcfLeELCrpEyWKE2E+WnZQnfdcMjdFbnk8boaRjoM/3LZi63SgbX4Wisi1nFtS96LT1RXm5l2AysdserAP6HaXroBf4tU8ZG4YvD75/tLe7tL2xkQss6F0pFcJYP7sLzYxUzMzNwOYHRvYddvew/2LLiqRxLpUErLd0gyetHAIXIX33GJKKhc6yrquna7wdKp7hPL1GYnoU7pgJVZ2ZOSAU+n+ZNY48pivXHZGrF3UrIN3sdkBzVFalTt/uP4j97VadnMZOWQocH528HZNH7vzaSJ7Rd70V9Lg4og7zI6daxfPFpJJdiC5JJ3k4msdMizqon2g/1EEw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY3PR12MB9630.namprd12.prod.outlook.com (2603:10b6:930:101::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 17:04:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Thu, 19 Nov 2026
 17:04:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 =?utf-8?q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>,
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>,
 Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
 Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] mm: flush stale TLB entries before installing a
 CoW'ed folio
Date: Thu, 19 Nov 2026 12:04:07 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <FBB72DA3-74B8-468B-9857-4397C18D4F38@nvidia.com>
In-Reply-To: <98be89bc-1394-406b-8723-0032a7b57ad1@kernel.org>
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
 <20261118-file_folio_flush-v1-1-e9e739ed14e0@kernel.org>
 <22DF2F1E-2692-48AC-AEE5-79B61947D86D@nvidia.com>
 <98be89bc-1394-406b-8723-0032a7b57ad1@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: CH0PR07CA0027.namprd07.prod.outlook.com
 (2603:10b6:610:32::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY3PR12MB9630:EE_
X-MS-Office365-Filtering-Correlation-Id: bc520a1f-b662-4eb0-11be-08df465f2206
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|261102123227099003|261026140227099003|261026121527099003|261028144727099003|11063799006|261022115727099003|261021121427099003|261021123027099003|261022105027099003|4143699003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AhF1pYP+JFrLYwtExjXDZDZMvySwwEBRJsUzxLQJA95JzZtyxoiW06Il7lm/s/T4iUxJ9e8OPclIb6QUdQfaKmXlf7yKS3YgtO0BbJqBe2/irFLufZf3aPFIgCClUQu3NEJhugDJwfBMkmTHOVAUvJ0DoECgWUDmKB1QkQ43cC43+Mfshe/R9LiVGtOhgnbtkOue0J0fvciTb7TuEas5zujtBAoR2j8vJDOaEsjhNDuT8hCU5okrYidMC0acwJs0W9C6OmN9PFZ+/Wt+1MfF1l0vh0GmnUli1iEKVvwoWbuqOS3UvMwkPPX77bOXBaENR2goBoZoPpldAMW1/bs7GoQoWxwUn7q0TZ2s+XcJ+xSZzpc2OJEasRGohoumZG8aduE4Y12rBNZ9ncyNzRNkEYztyl2SkOkpUPUfd8Fb5/tPe/GS4adlHBHlXOxPsJfKDNoD3eTkXmHr0LTG6Vv6A3gyktvE5VKysHC8yZMDZ6TKnf4aO76+YjoVKvv9jH7Hsn2f3kN3PYEb6kPXF2Ucol7XNq7lLnB+A1Ixe0JN2iK9aaQh1EfVujvNT4o5Dtj1ul05wp+YptXwG87uHAuME5j263dmo5ffeMqFOH7JtrT/5SuVObCjdz/t+3Jxp1OYDGbpaktNoBTcDO6iLHpUTKIuHddA6X2TJ4sF7rvZ7Qg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(261102123227099003)(261026140227099003)(261026121527099003)(261028144727099003)(11063799006)(261022115727099003)(261021121427099003)(261021123027099003)(261022105027099003)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1cyU2ovSS94ejZibDNNWWtCNU5UekZHSnlEZFR3dGNwNm9KS1BOUUFBWFFX?=
 =?utf-8?B?SGsrN2VYeTBlRnRCSE96bldFQnArMjZ4aVlVT0RLMUt4T3VjSmNFc0txZG0x?=
 =?utf-8?B?bkpjMFM3Sm4wS1NGNWdSWlVESUVSRGFra2svSng4dlJPd3IzRXlUR0dSMjlp?=
 =?utf-8?B?RGlaWUdxNmNIaldaQWQyeWlBdUxWRGNuK2tXK2llYnFqTGpKb0NPOGJ5MUUy?=
 =?utf-8?B?cWdxcld5WHVaL1E4aW1kczkrUDJSa3RnWmhYWFNCNWdCaEpJTXcwUlp5TXFE?=
 =?utf-8?B?cUVvcGh5b3MxMG1zL0lSSDVFS29EMFRZYlAwcmt6b0JZZzJFMGpHOGVISUVY?=
 =?utf-8?B?dWVDMGF6ajRVNURkaVM0RVpnckp6d3dENHZINTNYNTB2SU41a0Q4d0dMczRi?=
 =?utf-8?B?ckFUeU4vQ21PY2tPckJCMjBKT29xdS9kbXZCM0pxWEdVdHFQQzJrV1NqdkFa?=
 =?utf-8?B?azJvRk1GRVR5c2ZxQ1NiZjN3MHNMRmVDdDQydWRyeEhzc2xMMDZiOHgzUkMx?=
 =?utf-8?B?ZDRPbVVqTUJEYUIvelhvbHhEVjRQL3ppZDR0SWxHQ3QyN21JRW5QcHVTUUhO?=
 =?utf-8?B?NHVObUJLSksyRm5TcnBxSE5QNFJvKzl6bktZQ0xONnF5VE9uSlVEc2grVHdB?=
 =?utf-8?B?VHIyM2JzWmxudnE3TFM4ekZLQXMxUWRwZ3N1dlBXcndMdjhnUjh4clcvN255?=
 =?utf-8?B?ZGtnbnlzRGI1M0RUT1U5cHVFTlpGRnRObFVCOXF0UUxDbk5IUUZ0Rm9KcEJP?=
 =?utf-8?B?Z3F2UmQ0NUJrVGcyWG12Zkc0NExuTXBMZlBmenBrME5KaUVmN1lyb3dFNi9p?=
 =?utf-8?B?R1d1M25Qam5OU1JHRDFTMCsxU0hEWDNBMXI2a2l3UGE4VXlzT3Z2MENvMzlj?=
 =?utf-8?B?UUFoMUwxQW1vN1hIT2ZwQW52cUNkOFpqb3NwUHZnUnJZRkdXQXVoUzV4WXBU?=
 =?utf-8?B?ODU2U29qUDRPYWRpOTJWY3MyL2YzSHBscGhFazRnTGtkWHgvOGdvZXdqbTNp?=
 =?utf-8?B?Rmw5NDc1UDhyaXNmam1KV3pabVZDdWlodEJjcmMxdjhnNndZOXREclpVaXl5?=
 =?utf-8?B?Sms0V084Z0cwcnlYQk1iQm5IblRGaTFxVlBNaUQyYWZnMkxuN3o0MndsNGFu?=
 =?utf-8?B?bVlGdTNhMmNvWVJKVHM2UDU2OFFQdHBPSytoR1AwUFVGdDJ0Z0VKSG1md2ly?=
 =?utf-8?B?NkUvNGQ4ZktRamJ0anYveTNnTmxFL25MLzNnWXZZRFB2WlYrVTdydGZpbzN4?=
 =?utf-8?B?cHRBY0YyMU9SaU1TN2ZXSHlQUlAwcHNISW1peDZHaTkra0ludGxBN0tnZzNF?=
 =?utf-8?B?V2JVTlBoQVhpT1RCQ0tzUnBXaFZrQkJ3eWtrS1dMVExvUVY1ME53OGFJN2pI?=
 =?utf-8?B?TkMzRjFabWpmSFJaYjBoVEdYUTFyM21wSERwOUJSdFZlUTI2VlgrTitqT3Fs?=
 =?utf-8?B?dzdxR25hWFRiMHBXMGFpQk1UZmJlL2RxdDZOM0xaWE9jQjhjdnAxcUZTWi8w?=
 =?utf-8?B?SmJBTW5ucW9FQjBna0FJcUdsMzBMSTRRa3k2VzQweFJiMDluUXlPTkZSSmpM?=
 =?utf-8?B?c3k2TDN1UHVKRW03RnpOdnVOVlZ2bEdFNU5zZ09TQVExdDgzdkxTSzdPQWxo?=
 =?utf-8?B?MFE4TnpoSUFpMFhOUTZGVTlPc0hwUE1CS1RHNEl4STNpYkdFeWZNb09vY1RG?=
 =?utf-8?B?Q0RsZWpaRW9jT2cxblN6YWlaUlZacURrc29EalFKL2c0SDgrS0Z6WkFTZXI0?=
 =?utf-8?B?dmFlYTF6aFBDYVZIaGdiTHdORStTNlh0dUZ5dW85Z3B6Rk5ueUVYdnRoaG9z?=
 =?utf-8?B?Zkc0NE9qMXVld2xMVFd4M3EvZVJJNDRXaUI2SmpDRk9WK043eTdVN1FLM21X?=
 =?utf-8?B?VThnRkFpd1N3WHJSeGl6c2N4RTh5S0NCRXJjdlM3eGdab3lsdFJMSzBuT0tC?=
 =?utf-8?B?T0dpcnZtZTRWUURiUGJYVG1rRUxlSXZxTGwzcDJHL3RqSDNCZWRBZWlDZURr?=
 =?utf-8?B?Q1IxWmpWcDh2Q3NadStaalBtcHhHNjFFRUhRblR6Yzl6VlZmOGViZGZHQWM3?=
 =?utf-8?B?b1lBakFHaGNub05SZ1A5ZTFDdEdOaU1xdFovNmcyZUwzUFo3KzlQZHkvK0JJ?=
 =?utf-8?B?d3BNV05rSm5rNGpwQ3B6L1F2clJsR1lselBjMVFEK1h4SnRYRVJIMUljS2NV?=
 =?utf-8?B?WC9XUFdDczdINXV4Zk5CNjFJS3AzZHN5Qlgxcjh1SEJvUlhBa09mN0NqUnhO?=
 =?utf-8?B?YVhEbDZBNEFhN0phMlRnclp6QlBlSDBqd2ZDamxuRFFsRG1zaGtwSjhSU0No?=
 =?utf-8?Q?jEBi/YI9UKRoQDIdVV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc520a1f-b662-4eb0-11be-08df465f2206
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 17:04:11.9015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kf3eAjwqZUaBktI7VV0qhnzrk5CwR81+m+Hbb3XaPJJDvCedYbTsjFCEun2IMyZ8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9630
X-Rspamd-Queue-Id: BB16012000D
X-Stat-Signature: a1ctb3asm9uuwdis7pgpg5169i4zpomb
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795107961-996672
X-HE-Meta: U2FsdGVkX19JH4+t920pYj5pHKR2SJEf19iqPmjHro+2lwIWKNIrnNZCHd3pFfcsjTR+XUfjvkyzh6r/n3/mD8A1l59qB9TaAa91rwpULZUKMGU1rv/Mdt87w8iiNFDjMal+j8wJuv1bGf8k6+O/pvI7OTCgEELdFiW1NW8AhwOA3LX1qhMSYc9E/jM9PoF27OP7PahXC1KmnNtLzPV2dgOcLXlxfizDGNGiwtTQAjExAtOzWmDW5qZPaWXNhio+cLEl3iRVZm6OVDCeXaOhCo2Vv4nCs9wcQjg/+vZD93gmZk+lmEul0Vrb+9gtcDc6J+Fkprks9mkWQTa1VuQ8ikFWtXTh7sTR8DF8dtM98TgA65l87XixGqYWbMcJY3Si2m5zJo3hItImnbm9RBgdiHbqj18/C37HoxNBvHVaDfj8RguvSvPHAP54ou8jznSgcvG98T1AOMirL1Z5RNdyWqSFg+Sf67NMaFzxE0wQXfcoxm+UCZS9YZOOvtOiwOOrD22nSNIA2ZSxyL3NzxAiY3kwpcNR4X+Zgu/OYGuZyK/vPqKz08yi+zF77LUZw/TIpahmy4jIrOHmjHTIbRjRv58OtI3ic32LynhFVHBTUj1yUnvBy2CKCGqYvUdIK6aBSiUwV7OW1dL0yb/rcuy6QJpVv3t0wazEpC0doOgnUOR8Vb4C1GnVU4R9YSAU4LdmJ6JfnWJ4EDkZo953BKRDl8y75mFB2eH/R7naM0VH95w/5ekt+i/DnLVLXwLlZyuXpBvNVkZMr470hlPfFBPT0lG0l+2aGdgysL+81gH2ZasY2dybbIOVWw1YdPN8eAsjCqwRCtI9AnLcDyWzXfNyZp1yxoj89N1ePf4i/nje0kGSwst0hHeru4Ywo5YJcgITBB/ePcNArEUpg9pWw5j32KuYjoxoJjU5tZFgxlKTk8q4D81euOHtbyh5G2MkjX6C/6OWpnEyC18dcaTPFyt
 szcJe7xd
 LvcB0ksf+mFmcTlNftXDLMXMvJNa/fLKTq98WyUtJ6ADh6G/kqX8a+wt/tl9tW4W1DlG7XGYfr9mYDgzTGQNp4f2KCW/Ntt6HqeVxymmr5tgYKMyzAB2KxZcyxbGWH/MW63SHzc2enJ9/NBfMhIbQEk1XR6LvR+4SlCtOEEPWJz0yi0jRZyGNQ6b5YgD2XVl6oyOT2oF/jWVT7gNunpPOf6LLqiH7DaDZ69Yzn3EXw1e4QTTOEOG+rh+GVdOELdfDLyBFm1jPPn0eXW2ZLTEWa1tPoYkTCetxDzPAMa95FTOertZfV+fmvoj420X7pERGgKMaRvtSTWSUMgAx14/MEGoDXzdlm+3W7x86Bx+drgPQVrIy4O/qrcQN/MZgBchcV4OgMvQOt3WbN03/RpcuvUeHjmGryvCqr3g/+O3QNtnjVtZMs0ADZQP87GhZHLvTWNuugk2PjvEeyweVsvrdm2YWldH0Jg5RjwuLvHZTE4XaGnIpvsXA+DA4FRPdnEMh2DAIz8wuIFOND8HSoB+6wCNw0lInAK5PItIx0xUj28rqqw/AMz0Gd+QzGwNW0TfzuOOG84OcJVaGgiK4Ez2ZU14uOtR/W9zK47tqVP5wBEGTLd2iXlxPUEJcSsrh3nbxaFTfLw9nLaclrk6Z/G8gCeN3du89jzrHVrNhOzFsdxyJRAOEGqgEKOKeCWmoJhuXLFJaqTY3s1wrRzoAmYpHQl445HT2Nh7as1L/FYabUxOKcxuY09sZHvZdJWssfuRcD3V1ZKhs77JvhcZWS70J4B3ghizYNP15h3m1MDqRDep6qUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 19 Nov 2026, at 11:49, David Hildenbrand (Arm) wrote:

> On 11/19/26 17:47, Zi Yan wrote:
>> On 18 Nov 2026, at 4:20, David Hildenbrand (Arm) wrote:
>>
>>> Zapping PTEs in zap_pte_range() defers the TLB flush until after dropping
>>> the PTL for clean page-cache folios.
>>>
>>> A concurrent write fault in a MAP_PRIVATE mapping can then CoW the
>>> page-cache folio and install a new anon folio without a prior TLB
>>> flush:
>>>
>>> 	CPU0				CPU1
>>> 	LOAD(ADDR)
>>> 	 -> #PF
>>> 	    installs R/O PTE -> A
>>> 					fuse_open()
>>> 					 -> invalidate_inode_pages2()
>>> 					    -> zap_pte_range()
>>> 					       clears R/O PTE
>>> 					       // delayed flush
>>> 	// Other CPUs (incl CPU0) still cache ADDR -> A
>>> 	STORE(ADDR)
>>> 	 -> #PF
>>> 	    do_cow_fault()
>>> 	    copies A to B, installs R/W PTE -> B
>>> 	    // no TLB flush: PTE was none
>>>
>>> CPUs with stale TLB entries will still read from the old folio while writes
>>> go to the new folio, until the TLB is flushed.
>>>
>>> We really must process pending TLB flushes if we are not faulting the
>>> same folio back in.
>>>
>>> Fix it by flushing the TLB before installing an anon (CoW'ed) folio in
>>> set_pte_range() if a TLB flush is pending. Zapping itself stays as fast
>>> as before.
>>>
>>> Other faults are not affected: unmap_mapping_*() users only remove
>>> folios from the page-cache after their own TLB flush, so until then, a
>>> refault maps the same folio again. The exception is a concurrent
>>> invalidation that removes the already-unmapped folio from the
>>> page-cache before the zapper flushed the TLB; that is an unlikely corner
>>> case that we'll not handle for now.
>>>
>>> Note that we don't care about MADV_DONTNEED followed by a new read
>>> fault, as MADV_DONTNEED only guarantees its semantics once the operation
>>> completed. CoW faults will flush the TLB either way.
>>>
>>> For example, imagine that MADV_DONTNEED zaps a page-cache folio and
>>> doesn't flush the TLB (but still holds a reference). If the page-cache
>>> replaces the folio, a new read fault might map the new folio without
>>> flushing the TLB. That's okay, as MADV_DONTNEED did not complete yet.
>>> Same applies to MADV_DONTNEED of CoW'ed folios when re-faulting the
>>> page-cache folio.
>>>
>>> Memory reclaim, which removes folios from the page-cache before performing
>>> its own batched TLB flush, will be handled separately.
>>>
>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>
>> This is really old.
>>
>>> Reported-by: Cenk Yılmaz <cenk@deepfinresearch.com>
>>> Debugged-by: Cenk Yılmaz <cenk@deepfinresearch.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>>  mm/memory.c | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index d2f48d78b0d7b..e1d9759e6fde1 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -5888,6 +5888,12 @@ void set_pte_range(struct vm_fault *vmf, struct folio *folio,
>>>  	/* copy-on-write page */
>>>  	if (write && !(vma->vm_flags & VM_SHARED)) {
>>>  		VM_BUG_ON_FOLIO(nr != 1, folio);
>>> +		/*
>>> +		 * Concurrent zapping might have dropped the PTL but not flushed
>>> +		 * the TLB yet. Flush before installing a new folio.
>>> +		 */
>>> +		if (mm_tlb_flush_pending(vma->vm_mm))
>>> +			flush_tlb_page(vma, addr);
>>
>> This looks like an adhoc fix, but it is minimal for backport.
>> Hopefully we can find a cleaner refactoring later.
>
> I'm afraid if we don't want to throw away performance there is no way around it.
>
> We have similar handling on the uffd-wp path ...

Performance or our sanity. :)

Anyway, this is for a later discussion.

Best Regards,
Yan, Zi

