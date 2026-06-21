Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC71DCD4F26
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 02:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662F26B008C; Sat, 20 Jun 2026 22:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614876B0092; Sat, 20 Jun 2026 22:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502786B0093; Sat, 20 Jun 2026 22:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD136B008C
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 22:14:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 602B7402B1
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 02:14:04 +0000 (UTC)
X-FDA: 84902299608.25.27916F6
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013028.outbound.protection.outlook.com [40.107.201.28])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6396240014
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 02:14:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mv7wmr2h;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782008041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXp834G15RUJUTPPr334OGa0NXVXd1ekKEA9mt8CWrw=;
	b=jSlmYgslgS4XtuEn7DRRyvzw5cbB0sL6Y3rJUJ4erdrZXXONYxz0gaLucTV9VIK2xEAB0b
	OQlzA7tGO1Xsa6CR1Qb9CkNBGuNe2FntOYl+7wfjLq3Yai9PsUeNQfg/Z2kNQBeq+VVPRn
	TqT4tnAgljZcKJq05tWccXeI/9Z/Z3U=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mv7wmr2h;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782008041;
	b=f+s78xsa1Avmy82OzIGCL0v8nSPRp2tV011zRykSG3N0ja9VZNwvGbxM3ZUlwlZGD5kJpJ
	uGm8SSDbUvRPQsNkkUpVKbat6L6jBi16hJ5PxW2Zg5wZNfkhsZCDew5H7nKlDSfEdOR3Kn
	mKY6Xo0dTRBEizCeZ4iHObOUxYfFeRQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aX0W4GZ7kVreqD2YQvUrf1DAMnXuzWy/uLOr0fyDYtwk8INFIM7eQPGlcluY9u7PQgIf15icd6jen6x069L5R5p1b1jYuXxm6VaOo9fbvYrPqwxjRgssDTmLXW6v6wtvaCG0UwVGIzFekaJrwGwnjMO4stS+sCnAgrH49zUYrHgxG31goSdQOsUhEvvLmtJ9R3EedzdYkhxey5AeGqhr2oMyFYgD048l08SzjuUhZB4wF/v6n42YhKQIIZiRyKD7JWYr0aBCyFduUt4bqILrP6sv+ZA3w61TOsxqmrQ5r6ixnP5a/UnuUdxhbcLskVIkcnm3K/8HF05V8/a4bjEH1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UXp834G15RUJUTPPr334OGa0NXVXd1ekKEA9mt8CWrw=;
 b=j1PtGwsruiLnmhUlvjUgqXnN/GDuiRSQG5GMnr0vTLQn3H2BDWoMe0CoU44tZe/OWqHwbDQc8bmQhDcM6j2Wyz6FaT3P/Jg2Y2RZMq3l3F7VPMZ8fWSljNgd+ydBCGVUbxEiACa0Hksu67F65cLUKpSwugD88u+kiHNJNg1cvUo0GyvFMuR0XFqIKS+Qcpxu9ZZU3l+BEqvOcfKICaSJUwZdqKpV/GY+Jtj57EP3LLy3tI9KKHPOns0asgTpbie57yrgcPcATDUQINcvjW2ZRrXxvXupssmO5ikGfv7vvMvSEelSNI7ly7ewlNlM+aOnSNHo8rylGcfX8+r8iQTziQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXp834G15RUJUTPPr334OGa0NXVXd1ekKEA9mt8CWrw=;
 b=mv7wmr2h59PtTsKiRHf19eAkyK3bD7VWTPq1M0FHKn0CM7IrYo2RtVNW09jT6LsIbSqzY0zrSZOLLdUgib3OqkC873OWc5pt4gmUlmH4IVefnx0l0IKbnzFxuC89M61SlsdKc4FQm1HORdTdN3gmOXbRXyriASJ9UL2Y0loRGsZuvx9mHlEKhmVKZyRXwkqdSx35qALCDrivo0s9h3Z05h1Vp9uYKxy2A3sAIuynyzMZ6pSIk8UG8LqT5UEtowTidq+WgtFDFdtSGWEIaETzNnxrYQcyvc+6HGqYoeR7ab/trfV95jPuQKgkbcxXiyJ2uscMsqReA+3Q2rcyxbMK0g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB6397.namprd12.prod.outlook.com (2603:10b6:8:b4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Sun, 21 Jun
 2026 01:40:41 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.018; Sun, 21 Jun 2026
 01:40:35 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 20 Jun 2026 21:40:32 -0400
Message-Id: <DJECF2107V6T.23HGJJJ8ECKJ9@nvidia.com>
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
Cc: <ivgorbunov@me.com>, <Liam.Howlett@oracle.com>, <apopple@nvidia.com>,
 <artem.kuzin@huawei.com>, <baolin.wang@linux.alibaba.com>,
 <david@kernel.org>, <foxido@foxido.dev>, <harry.yoo@oracle.com>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <muchun.song@linux.dev>,
 <rppt@kernel.org>, <surenb@google.com>, <torvalds@linuxfoundation.org>,
 <vbabka@suse.cz>, <willy@infradead.org>, <yuzhao@google.com>,
 <pfalcato@suse.de>, <kirill@shutemov.name>
To: <ilya.gladyshev@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
 <fe53d9a75f776a5e002a3375d086c5714f558547@linux.dev>
In-Reply-To: <fe53d9a75f776a5e002a3375d086c5714f558547@linux.dev>
X-ClientProxiedBy: CH0PR03CA0331.namprd03.prod.outlook.com
 (2603:10b6:610:11a::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB6397:EE_
X-MS-Office365-Filtering-Correlation-Id: b1f7cda4-13e5-49ed-f885-08decf3616a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5S0zlgXh000dULjSr0VOcEg0HzeQxgG4rql4PrmgRTbylsEQd3fhsYzVLA8vpNItxDVGsoHV6dvDB51e91aqBJ8Gq7WQ/QlUxuQANPzR+G8W6RVLKbnggaBPfKc6PJug3PWrMFn39N8V+HDgfog8+6xVRsMiZC39SbGckTwWCuLwYzSMolJos/Ek0DGSwlTdobVEJE2ixJ3868Im6Y9SJ4dwIVnLPTkKG/qzCu+Q1AP6yfpiORtauHBkJ62chXZqotm0G8TXOnmW+2n8R4q5w0NFjoP0KzBvEjiBedCKgZilwDFlTLhnC8VWiEcUJh/hsKpYjkIyJ4dcMz07i1TsXzfJbJyjrRiMAGldMoR8PmD4brLro9ydZwZUVvuJLYG31PiaUsdROS3i17jf20HQkQqKW8+2He6Lx7OeNSKDjYVokqOMRsR9+6s48TlUf6haRg0A+xXW8Rm8QGWFcfmcjxlxzeEfQYg0j1vvkTZkJy9E7nC5dQ5IOBFx5bj11Kp3DtPESKzs0EexNoJ8mchCiOVpwVLIoj5CqVLtuYMGhhYJDVtuH271R98jCZbwpaYXT6RS1uifuAMfU9ch7rPz8IKNsQWqOZJq0GUHWh5R4IUdIeCvmqTqR3eGSCcrytPsZlz9o79iZbsiRhhsSqI5cH0TqM78w8SVHDaQnOyZ8WU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cURlR2hGL2RkZ1BzQWkwZHBOUG04cEsrREhiZ2RxZ04rVmdla2NTRld5Zjdt?=
 =?utf-8?B?YkQ1Y1ZnMmRJemk0MkJwQXh0VVRiY29UTm9pR2ljVktzOGU3Q2F6N2YxRjE3?=
 =?utf-8?B?Rld6VFd5L2h0dzN3cmYrTkY4OEZQL2UwS3FHOWFVK0YxczA0T05mbDRuQzh0?=
 =?utf-8?B?NnhHb0lwa21kd3dWZUU4NUJSK3RrSEVFMktkWHQyRnE0amVONXcwVXBPOWY1?=
 =?utf-8?B?WE80RllIT2w4TCtQSEFNanhYeDNkVjRrazcvd2xXUUVpNzBqOHJoSUZuSGFa?=
 =?utf-8?B?aitCYnR6WEt4UlkveW9GcnZoNE96OUpEbDRkdDdCUzh3RzUzZ2ViazZpSWxY?=
 =?utf-8?B?M2RVcTlVbzJPTHFOY3oybnkxaVBCWTNENVhsMGZXZ1lUZ1hMb042UEd5OEFr?=
 =?utf-8?B?clBWNzNDVm1WSm1wS05UcWtVc3VKSjZrTjdYTjNYSHhVWmRmakdpK29jSFBu?=
 =?utf-8?B?clNrNVlwUGloWUVLVU5GSlBJSmpXYzJlZ0NmQVR5T09iRWZDRExERFVvVFhB?=
 =?utf-8?B?RkJ6U1pIaEh4c1cxY0E3QzdNY0V5VHFKYjBRM1ltTko2dUh3NXoveW0ybS91?=
 =?utf-8?B?SWgrTmpCYzB0Z3NLU0tSWmY2R0xqemE0bVAyU1VldzdHUGRmYXpOcDQ3Qnda?=
 =?utf-8?B?SUl4YUoyenpWb3MzaU1lNjR1eG45ejR2NEtmTDh1WWlQVGNiTW9ZSUFpTVFW?=
 =?utf-8?B?NWNRYjdSQUZNa0sycjdHZGlQMjVYT25NQTFsZ0lJMk53TkJUcGlzUEEybU9L?=
 =?utf-8?B?RkZBZkFGM1BSYUlsTitiK1UycmJBNXBKcmV3NVlTRTRwR2VQMzJHcDdZSnpP?=
 =?utf-8?B?dkV1S252blBmTE5ib1dwUklBUk8yUk9ZNU41aTIzaGhDK1M3VGFjQU5SL0Nn?=
 =?utf-8?B?NGs4aWE1S0RsaG12emFjYVNCZG0wVjZXa1ovZ28wbUk1cFp6dk1aVzdIU2J1?=
 =?utf-8?B?L3ludHFVRmNxRnFzcU9LMllkK2dxWUQ1WUE1RFNXNTJnMGYzemF6Q2JVaktz?=
 =?utf-8?B?Yjg5S3FFbjBqOUJuTG9mSjRFZ0ZXZHc4YnlNODFMc2E4S2JnSzNEUUR5aWxO?=
 =?utf-8?B?ZzVPbVN5bDhrbGtEKzc5enhvaTJZSG54Vng5aXNzdXM5MkExQ3dHRUo1aXRO?=
 =?utf-8?B?MFFjUDEybVA4azYzOXNXdGJUejNhU3BhNW1OWGVKK0xoREhYQ3NsWU1ieFZu?=
 =?utf-8?B?SEV4SmN5ZVkxbWUvTzZwb3V4ZzdHbTRwRWhndmpsVWdLaWsyRExkbVhWWVIx?=
 =?utf-8?B?akxTb25lVVdBMmVNZS9rMC9yelVyZ0NOR2ErZ0hrSzRCL1FuVzRubFJFOEVM?=
 =?utf-8?B?dGpQSEppRk5XblI2dEZScDhLcjVRTmhFYUt2dS85TzdIZTVLLy9XaEt4RFR3?=
 =?utf-8?B?NXFiVmVkWkZRWEt1ODB5UWVnYWh1SEdvSW03Q0NVNkNDMURoU2tQWm1sN0w2?=
 =?utf-8?B?dThtdkh6VkxRajZLRHFqKzFzWWwvdGd4TXdPM1RiQXloL1RISG9TazBSL0p3?=
 =?utf-8?B?YURYMFg5V3hXd016dUIvaERJMUErV2J0eGlzeEZDUGhIS1Z2bkU4UjhRS0V0?=
 =?utf-8?B?czNxMGl1enY5eU1zaGNlaDlkVFFnMFdBQUV1UEgyYldORWVXZTROeHlDN2Z0?=
 =?utf-8?B?OFBya3JsUjYzdDNycldsL0Y4dEVVRm5iOFBqKzNTQWlKMTZ0d2hOdkpDbEh2?=
 =?utf-8?B?UURnMmZuUThMOVA1LzdSYUlHSysvK0ZlRk16aUNXbldpNWRjbnFPTVFKVmN6?=
 =?utf-8?B?ZjFkSlgyMng2aS84YXpmMFV0K0FTeVVHZjR1NmtCbSs2cWt6a2hhdEJDTHFh?=
 =?utf-8?B?SjdEZk9KYUtGZmtDWm94TUFxR3RnM0U0RUxIOUVHOW1hQ3JPaEw2UTd6aEIz?=
 =?utf-8?B?WGQwelZSWFBic2hnS0NYaVFZNTNvQVpVbjZMZEtlM0ZoeXpWVnNMSG81RkNS?=
 =?utf-8?B?Y214ZUd6eUx2dDI1ZUFyNDhTeDQwM2xrOEtBaTFvRFJac3VnbTVjY0FhU3ZK?=
 =?utf-8?B?ZGp4czliMi8waC8zRDdiTTdZdVJteERqcU9SVXdhbWEwck1EbmNPQVg4cGt5?=
 =?utf-8?B?Mzd0M0JOWm5sSWJlRGRQMmUzSURqdCtiTzhKblBLbEpvUUo0L0tjWTBXd3lv?=
 =?utf-8?B?MzVoRVh5YzFtb1dtTUUwVHRPaHRtTWpSL1lZWXNKT0d5L0RPbjdST1pmQUI2?=
 =?utf-8?B?NjhnTW00TnM0Y3pqTFR0bFdRZTJBR0Y4aW1ZRWgyOE1LSHRpNTd0OC8zYk1i?=
 =?utf-8?B?dGtTRXA3U0pWRXdFM3E0dTM2Q001OG9oZEFBT0dQcERwcWcvSkZNc2IyenA0?=
 =?utf-8?Q?DsIOwXI0XLgJbPZUlL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f7cda4-13e5-49ed-f885-08decf3616a1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2026 01:40:34.9437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3wo5AL22W3QHhvMIhm6ErL+3fOx9PeMiW9qsDGX/qeqkUZq3Q2vtId+JgC7PJeK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6397
X-Rspamd-Queue-Id: 6396240014
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: qihbdg33s1o8dk7uogixnbjgjt47qomd
X-HE-Tag: 1782008041-662655
X-HE-Meta: U2FsdGVkX1/DNqUhhVpuiCegQptp3Wgj/MiHaQ7ROpjiXJABt5d8CGKHG6GxtuAwEETwyqrbzAoPrs7IGre9EhnM64gio5RQ9nRZqyBhNPjh7dfUdVkOmMPUgR0Z0nG4fJm8MklX4oJu1pqf74GbU64D7bM/GHvz33xsopijA3lazRXcTWUxNVY4R2VqcLWgCHbENif8YQA7rDBz08uiXJPIxkvoxldRpP+wfzGrxewu0l2vFUGWDI2eTeaV3FDqfnikyDN/yTdnStpBkibRpxEh40yBMgA3t00xbycIHYc1I0OfxZOnBy8vsSFVpLZePW7TNKoqbTDNvNI9QHzF6CPRDRAElkhSoGgjvQPgI1tgPsRcnvoFfHIEH99lcsXwHAiyedSQpkBD9w3/BOGk9hRfy2wHgbNbufD+mFPj3tkTUVzLcwXbmMsbg6vIix7fcmq6xyz6s7Xbn0Jc2Zw/Uhb5pLyN6juXH3InuxdPaONZVOlarQH669a/+w8fiirTs3jV9nK8PZNZjvNpCTcDBYx7dOJ529jlqmzipA6k6eHky27SbXtW+wJc+tc+tn8Khn3J1URLhNMMBVwkTuYL4GhujGAWiUL38BUZt0Kvqipnr6K0tcc7eIrejv+AvBOHF8LBMobEQkIb/z41Do+EiRPNtA3rbEfxxrY/iXOdYqne5AVD+IDRsD8ZPe08z3fPfuVWxE11fC98ZR/dz9Ccjbc3LOjk0uzAkoTYflpnJOoroxMU1yHy8/7IECiM7Py5fJ1WnVA1Fh9KBu94DZAhhC70uix8z3tn/5Bgz6IsWXomgHDPVIOvToJ0QL6fKS3BYrzEcZ98j1fL7hMdJtDlkoiXmsrlcgbTkbKzfLRvyPNRegRBE+TE18s1pxNcoJw/4mD3bkXXIwWivbz/nssNSTfswCATj7qxtZviJgfcqRWYFPYbWvGH8PVs7W+6IHdVGd4gpP+j9DX+h12DEIb
 CX/CB+Ru
 XxxtdPoHsxmkGN9ZbpzlyjmXcusKUPa6II2CvW08MQr37exXuW8w1aOgV4ff1zDnL2EKFh+R0zhfrTB/dcZLtkZale+BygWMUQDUlQQAacaeCBCCAkrxqPN6NxAWv3Zt62/WRAdgQmCD7NJSDis+DOphIlVEjBrt9dj+vGjg11Gb1JhpDqBfs3dgQfzTb4/g22ZP5/8a2AOpaLNw2uag1Q+vhs3yBYhuJxuRUWV8WwBvBM7m9+CWJGIsq4P1VCSgKjsEZBI4qB1FeKznUPtg+fk1snLXiNnqA4EKAKo2ikGJpyugY1yYuieUF3Oee/DPSgulSP4HqRsHsVgJuDAbc3dq0TwkuR7MsDxdN4FkqKe3C0P7eTbQqkRQrWPJyWVViamf+8TzLK1r2sHzOYRzTcgf9ABWL7rffVGF84jEZ0GBBMBtxRnfz66JqHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Jun 20, 2026 at 2:19 PM EDT,  wrote:
>>
>> >
>> > This patch optimizes small file read performance and overall folio ref=
count
>> >  scalability by refactoring page_ref_add_unless [core of folio_try_get=
].
>> >  This is alternative approach to previous attempts to fix small read
>> >  performance by avoiding refcount bumps [1][2].
>> >
>> Thanks. Nice numbers.
>>
>> AI review had some things to say:
>>  https://sashiko.dev/#/patchset/df26082871b4c65b2bd38d409026237c08572836=
@linux.dev
>
> Among some minor issues, it also pointed out a funny ABA race:
>
> ```
> T1/T2 work with pages of type X.
> T3 works with pages of type Y.
>
> T1: page_dec_and_test()
> T1: -> sub refcount [1 -> 0]
> T1: -> *interrupted* (very bad hypervisor, for example)
>
> T2: optimistic get() [0 -> 1]

How is this possible? folio_get() and folio_try_get() should prevent
getting a refcount-0 folio; get_page() uses folio_get(); try_get_page()
also checks refcount before ref_inc.

For your patch, is it because of the separation of refcount-0 and
frozen? The page goes refcount-0 before it is frozen? Will it work if
the page is frozen first then gets its refcount to 0? Basically, the
frozen state prevents anyone else messing up with your refcount.

> T2: put page back [1 -> 0]
> T2: calls dtor for type X, returns into the allocator
>
> T3: receives page of type Y, sets refcount to 1
> T3: page_dec_and_test()
> T3: -> sub refcount [1 -> 0]
>
> *T1 resumes execution*
>
> T1: -> CAS [0->LOCKED]
> T1: BUG: calls dtor of type X on page of type Y
> ```
>
> While this race seems unrealistic to me because of the full allocator
> cycle between the two atomic operations, I wasn't able to prove it at
> the first attempt. Maybe there is some synchronization in allocator
> that forbids at least X !=3D Y, or something.
>
> I'll try to research fixes/proofs a little bit more, but I am afraid
> that unless someone wise with mm/ knowledge comes up with some fact that
> I missed, this patch indeed has a major (but unrealistic) flaw.
>
> --
> Sorry for the delay, grass was more touchable than ever
> Ilya Gladyshev

--=20
Best Regards,
Yan, Zi


