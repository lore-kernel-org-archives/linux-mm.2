Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73432CDC192
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 12:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96AA36B008A; Tue,  6 Jan 2026 07:28:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9414E6B0093; Tue,  6 Jan 2026 07:28:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840556B0095; Tue,  6 Jan 2026 07:28:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF986B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:28:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF55C59308
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:28:48 +0000 (UTC)
X-FDA: 84301467936.30.0DA9BF3
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010017.outbound.protection.outlook.com [40.93.198.17])
	by imf05.hostedemail.com (Postfix) with ESMTP id 05217100004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:28:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h9g0ziEx;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767702526; a=rsa-sha256;
	cv=pass;
	b=xjne3qKlHVyxnrRr72X0LJeA/eAlj4Nl3Ot8SsJwbLhmvuqxniQ33MHoj3tNKL7x+ahFNC
	3RCUlD8GQVy6Hz3475JfS9nXSlB8WyzmTDN1nBaQ2KMcO6YR+9G5NKqQFyi7N/vY76IFJH
	9IVCKSdG717YGWBWqahWIwbX1Vp1xnI=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h9g0ziEx;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767702526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/836k5CLkiA1LpBC7UxnUv8CPBkLHrUjXOtvyeWib/Y=;
	b=VqgfLVpZJWIBW1lu7U+Q1hL6baSmvfNoGZ1HhJXm6J9c2CntL8tTk8EAoEmH7sKoFwGkYW
	eZcQd6BMLEcyQJ4R/c9cG7PQUs/n16ra5rZBW3Ep/cUbR2WOBnDieD/jHmhGPYHvgWUcLG
	azzwtY2D8EfgyqURM8dOF5QSRo6YBIM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHjYAYkSw4Rkbhd3HYIsot4zlRUKSid5tdftmp1HeT2jcQYjv9QOuUm8866on6E2ILRiVjHFZJnLZnGlfaZG/ci/hRtzxZWDBWNJDxxlyWJqfV5m3NyK5NH/FdGJRpSqZVQ/wtN7nQpjxoF/HIbFvcogY8WPxm7YXsoQb4/jRHt/A9v+V6SYYoBORaOizB6y/N9gE1l2hpeuBYc2TyR8d3GSzg/kOjl8z3voo+2yas09A2fauf9KGbbpKtQ2YXBK0lG6C3Euu4aSgbRyqyRK33gkcvCd08CLn7kBvFji82cnx0zGgnF3aLJNP1iglptnUxPxm20RTIPdy0tFSXdoIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/836k5CLkiA1LpBC7UxnUv8CPBkLHrUjXOtvyeWib/Y=;
 b=lUMK3CcNXMyJKpasY0esLBGwUTmnIVntUzrGuASZ7TAVQFGFeTwqNSn9vmtfiF1L9mQEJykcwxh+ZqLxGi3Pmui9AO11FyCJ4XrGx61SToBy0REpm2csgESQLHNx6k4giGKjkUnq2r9bsuYN+oCdour3JkggT7STdV1IR2a87fyovl23jiHtaZ/SEj7OZrDj7Sf8iq/oUe11bD7CjR8lVbmK2g8acCKwqgVKIga+sk3sqZ4Adkg/XdOOqzi+b7zTaKOO28sSvjOm1BhENmTitFCazYJPK+sAw6DejN1PVTnnocjsFjqv5iJjnuB59ivO8ORzZPp3jd8lmVxOr/Nwqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/836k5CLkiA1LpBC7UxnUv8CPBkLHrUjXOtvyeWib/Y=;
 b=h9g0ziExgepmqCm98T8p6XkgA7ln7rOMKftiGc7uF2q1C1Bk4Tu4CsrJE1Vk4a2M0weOyQ2XgG3sLqye5cf4I+gXWaFHJkQZHZER4zba90lE2mkNTp5Vgqe9GV7C0joF6VH+7CGiL9ZKbpI0Nh/vIrlXDGXrA+ZTCXS+2ia84uxXTB1e8+ac12LmYb4A4Vn5dF87Yt/E6JkhUgNfq+QkIm0rOdu4TpRObpHUnEqzroeX5cZltp8nKJeTjhTdPy0lqDOev+ffK/jM9fBPOus/554wHcT1Ck1cvxM6gxMD+0ncQL/j2tYNpsosyjMNAW0HnY0HP/+gqJK3UysGAvmq3Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6885.namprd12.prod.outlook.com (2603:10b6:806:263::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Tue, 6 Jan 2026 12:28:43 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 12:28:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2] mm/huge_memory: consolidate order-related checks into
 folio_check_splittable()
Date: Tue, 06 Jan 2026 07:28:34 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <3BC7839A-B086-42CB-A1A4-F4FDB513739C@nvidia.com>
In-Reply-To: <20260106095413.aqkrh4byh32qltli@master>
References: <20251223122539.10726-1-richard.weiyang@gmail.com>
 <20260104023756.jufklyl3bl64fnck@master>
 <7ca733d2-ba0d-4792-bcd8-bc153e7b1b15@kernel.org>
 <20260106095413.aqkrh4byh32qltli@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR17CA0062.namprd17.prod.outlook.com
 (2603:10b6:a03:167::39) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6885:EE_
X-MS-Office365-Filtering-Correlation-Id: cacecf98-e5fb-48d6-f75b-08de4d1f2112
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmJ0TzVWWkNNRFlIcDlkcXNCdDJQaDZ6M28zUldBWHBUWVVkSHB1ZnpHbWtu?=
 =?utf-8?B?NWE3QVYvcWVyaWNFWEs4VVdyZm5aRW5PU2R4Slg4blF3QmlSbmt6ZDlxLytN?=
 =?utf-8?B?NVlubkNsTEw1dXg4aGc5U21qUTdyWWVhMHAyVFNBdEs4aENNSlh4NnVlMkZq?=
 =?utf-8?B?eGk4aUdYMWlFMC9BNDZUa09nSnJJT21aU3RQK2N6TzROS0NjdFhvOGt0WklW?=
 =?utf-8?B?ZnZPT2ZSTkdxNS9uYU9iRmIxS2QwQmFIQWNrYktCeVF3ajZkZ283QnpGcHRE?=
 =?utf-8?B?bk9GK1JpMnd4aW9uUy9WeXExQmtKbFFrclp0VGg5Vk8zMDM3K3JVWE9HdTZi?=
 =?utf-8?B?ZEkyUG9HYlk1Snh6bW1ld0MxOExuM2NrS1Y2Zkh4UDVvRS9rV0oySFRUajln?=
 =?utf-8?B?a0E0MUhKRm9oWEVockV1OGdnWUxZbHU4cENHcHY3blRJUnE3ZkdqU0kvOGhl?=
 =?utf-8?B?Ui84RXBpMzU3ZGNUcmVkWDNnOGIyTTB2eTJxTnN3ZWd2SUJCQjlXWEVBUEE1?=
 =?utf-8?B?dHFyOFZjZytVZUppWnV2OUorcnZpN21tU2dDLzNXZThxRy9hbFNtaXY1V0RB?=
 =?utf-8?B?NzdXblVlOUhwODdYR0dTaGxaU0t0R1E1dmlMMUhlS3dyOVhRbjJ1a21YYzNW?=
 =?utf-8?B?R3B1RktKV015RDhieWJqRitrOFg0WGx5SUJoS1Y2eW0yY25hc2F0VlhIUzVo?=
 =?utf-8?B?bVlyOEFvOGcwZzdJM3JDRTMzL2UwZjUrZEJrbGpiMmZoaEU5MTgxdTdoQVFK?=
 =?utf-8?B?dlB3aHE0amJFYWZDNUJwVUZ2YmhuUm5DMzlJa2N2Nm9FVk8wNG82dnJjbVFM?=
 =?utf-8?B?WUU0dHVZdFk2a1dhdjQzUmp1bDB5VGRhQlpLc2ZPRUFQdTNhbkc4amdEQmo2?=
 =?utf-8?B?ekNINkdqblpEeW93K1BLLzVwNkp6Mk9UV2pFMXJjRElDejgveUxudnROR3Y5?=
 =?utf-8?B?bXFRamtlMkZNYzdLVjZOSGJRb3NvQXE3aG81RDFSM0ljY2laWEd1NXN2THp4?=
 =?utf-8?B?K2tIZkdWRm55YjA2bmFBTU52VVM4dXdvR056NUx3MktTVkpyTkp0eHBvTHFK?=
 =?utf-8?B?bmtMNGRiaGp3ek1SZDJ0Y005YWNsVG9sbktNVnNuTzhncjhvRmYweTlqVEZt?=
 =?utf-8?B?UEJMczRhc1NCdWtmelg2Q1JGUVlEeTVUTzJlMyttek44eTFmcFJOYUR4RmVK?=
 =?utf-8?B?RmMzVDNlYzBFYmlhUzhHNVFiQlQ5azJ6cXBNOTgvT0M5T1dBdC9LakZGY0hK?=
 =?utf-8?B?bVlOL2w1akV2WWNZVEJlOXJtVFM4QjdpRXZxUUM3ZnJaY29WUUhYRnVMYXVC?=
 =?utf-8?B?R2xjWWZKajZnTTQyVGNON3JObUtRa1czc0Y0MzUxa0ZJRENwekt3bEVDakhs?=
 =?utf-8?B?OEdTMzBoY3Z4U1orL3BGa3JrNk9PZnlOYlRQOVZRNWZvd1UxVW83a0VNeldv?=
 =?utf-8?B?elpRdVQ3OWVFR3lYempZQWZuQmFQVzUwZGxPRXFRZi9RRUlkZHRRUktUdk9C?=
 =?utf-8?B?VG82SzFVbHdNY21oOVVxeUxJU2dORERyZGFVRm5tcUR0WklQYkNaUWNxZkpT?=
 =?utf-8?B?dUFoUVlsZE1WVDlQVmo3clUyR2F5bi84emlrVGNRT1JBZ25aS1FsWVJFc0dC?=
 =?utf-8?B?SmtEKzlsZFZ3dHBsOE5ZT2lLWVZ2WFhTclNjQ3BqbVpJVVZ0bTVqY0FuOEk4?=
 =?utf-8?B?c2p3QzRhZHpUaVJJbEc5OWJvVmY3R011Wjk2eTl0SDRONFFLek1QT2w4U3Fy?=
 =?utf-8?B?aGdEMktINVVCb3NRSUo3ZEswbVRLZkFoMXB0Z2lkbjlZM25WdFl1ZHRZdHVu?=
 =?utf-8?B?ZHlQdWExZGdKQ2w4OGlOSmk3SnJJN29IcDdreTJJN3ZOR1ZuZk5adTlDNzdi?=
 =?utf-8?B?MHBNMUthN3BNMmViS2JkNVl3Qm15enlVMS9teFNNNzhob1cvdStDNmJLU2J4?=
 =?utf-8?B?QWNiaUcvckFma2VjbHU3STNZT2U0Ly9wY3YwVkpwcFRGclUrVGZtcG81WkQr?=
 =?utf-8?B?OGhEODF2V3ZBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFR5U0RFSVFGNDhGRGpYWWU1K1U4MHMzSm9vQnpqUjI2eWlrZTZVT1o2dEZN?=
 =?utf-8?B?YjNwRW9xNkdVbzBMTDBIL0FZMkRQSVpTcFUzVE8zaXcwc3JtMFdvckY4a3pO?=
 =?utf-8?B?ZTl3cjhWOU9ncGlHbGFjNndlWXNmaXBJalo4cGwrYURpOG5iWkdTdkpjcndu?=
 =?utf-8?B?aUJBeEFFdzJha2NZZmVKUHB1ZW5oQnhaZmRkZnMxOFg1cnJpaEtuRnlzd3Ew?=
 =?utf-8?B?SmlQNzkvdVlUdVRFOEdzcDJTT1JoYmRmV2k2RCtVVmhnTUlPOVpCUFFpTmQx?=
 =?utf-8?B?RUtMb3UrWlZrRGhRZEx3c2RDVjNxZWxlaTZRTDBheFlmL3Bvc0tyTGFIcWFX?=
 =?utf-8?B?ZEpOZTU2UFZhanQzS1VkOXNIaTdnUFlScm40VFdBWDRIRU9TQTFZRXJ4Z0FJ?=
 =?utf-8?B?SzZVQjMrU0gxS2RieWI5TDVRd2N3YUxMdXVRTWx4NmdmUlFQa1M4N3VhczBq?=
 =?utf-8?B?NTRTODFtd0xIOUN2aVg5Vk1DdWIwSzUrcUhvTG45eE4rUjMwT3dML1UrUHd6?=
 =?utf-8?B?UGdkZGYrZXFiL25hcVE2SUpLbkY3a3ZkNktKYWJ3ZEtNNzhqYzJhRUpsWmty?=
 =?utf-8?B?OHhBU0oyYmovZFhJcTlkeGw4L1lCYTZlOURmSXF0MkRVeGFOYmV6cmc2bXg4?=
 =?utf-8?B?TktYNGlHbnFiOElOVTlFUGRmcllBR3FRb0dRVXhwT05UazNTdFpCY0hKblNw?=
 =?utf-8?B?VUxuT1BMdFI2OGZXc0xtNHBFMmdDKyswcndiem9Kb2pOYXNRMnhqRTF0L1pT?=
 =?utf-8?B?bFpxQk9iTnhzdm9EbXMxQUJ2TmxlNHhlSUxjaUk0aEdtSTdlbE1NaWJIZ1RM?=
 =?utf-8?B?aDFIVWxXdTBKV2RoY3QxYUtPVnNaeGlCNG1sOW9ZNnR4VmVSczFkOUlTODZJ?=
 =?utf-8?B?UDF4cm56UXU3Wk1LR04vZnRZRmNDME9EZTBZTTZrblJ0ay9MMjl4OGw2QTBj?=
 =?utf-8?B?VWd1OHQwVHZKYUREYUV3UksveVdQRnlLaDZ1bnJDdSthZktlWXduWDBzcmRp?=
 =?utf-8?B?WFI4cDlKcnh4NDJIWUJSNHQ0eDJ3ZDViNHdFd0g1QzVWMC9GNEZpZUpNZHRl?=
 =?utf-8?B?UjFlRWlwRkpieDhjQ3kwT2g5U0FYeTRnUWY5YVd1RnUxZFZJdUtuSHp2YTV2?=
 =?utf-8?B?WjZlcjFZYUJHMUlmVDliTngzREU5UUovMUE3OWJXU0dHZ0dTTkhwN0hkb0pB?=
 =?utf-8?B?eGxQaUZIQXJELzdpOWFiaTRsaFc2bmNyaGltVFpFZmpITU56WC84bCtVWWhu?=
 =?utf-8?B?dk9PdmRuVENXUTJDbHlUSXY1UGNPaFBQZ0Q0dU56R2ZzOStpQlhqZmN5VUw1?=
 =?utf-8?B?dnFRenI3eHpaMnpOTVpGQ0NOSzJsSHYxTUplcHZjNkZRMXFOY3BWKzJLT0oz?=
 =?utf-8?B?MnlnbGpGbkNPVDdldE92TUNVTGZiVVk5VW9HK0Uwb3J6SzZ2YXFqM3M1WWVv?=
 =?utf-8?B?bmhSY3E2ejZ1ODh6dys1SU9UUkJlTStPa1FZeEN0ZzJmdG5OczdhRGtyNFov?=
 =?utf-8?B?QXdMYno0b1NrTHBHNW1wU3M0UFVrQ1JJT3ZFeDdrUThsZHF1VzQ0bUpZUExL?=
 =?utf-8?B?UWxJMGJESDQ2U2V2RHdQZlcwQVd5SzE0dDNkZXFCWHFWeFZVQnhMZkRkL1o4?=
 =?utf-8?B?amRjbDNGRnRtbDgvM0h6QmZtMi9MUTUzUTE3S0ZiT01DUGw5Z1lqbzFNZjV3?=
 =?utf-8?B?T1hyYmUyNzN0RWtCYWM1THdUU3VZMzFya2h4cEJaU1BWaUdEMTFPMFZqYWZL?=
 =?utf-8?B?ditpaXlkdVhRbHJJbVBWSERuN2pkYncwaTRVejA4Q2d1UWxmY0Jic1FURjRt?=
 =?utf-8?B?YThWSHdlRy9lbmVwSVd2VHl2NWZHQk13ditnSTU4Y214R1hmdGhzMU1saDZO?=
 =?utf-8?B?UndoMnN5aGhaaS9IZ2Z6RTZsdTJ2b2Q4bzltWmRMSHllQzkzdndvU09sbmJ4?=
 =?utf-8?B?WDdVU3hVSmVzRTVxOTZRWEpldXdlMTVmNGVkRlZuc2EySjh1dDZvaXNnM0d2?=
 =?utf-8?B?dUVpNlRNR0dIYTRnUWpKRnpMMGhNTThEK2NOMUhHU0x1UWhkYTNRY2ZFbFJN?=
 =?utf-8?B?MUJSVm9YUHRBanByRmlxNHZTMERqN0xCYmtRVWx4L290VzMyS1Yzc0VlRVRC?=
 =?utf-8?B?TXdPdGErdGNyOVFtVmhtSnVscHVNbHYzZlVrc0xiOElkd3JLVmJxNGJDQ08v?=
 =?utf-8?B?M3YwQXF4SklDYmtIbnoyMUh2S2Z1VE9hc3ZuRnQ1YnFVZFh4NkxtSEhsYXp4?=
 =?utf-8?B?QUN1RkVTczJHK2ZpdW9wOUV4NEMzMVpwbUNNWllDOS9zR3lVK01XU0Z5aXhB?=
 =?utf-8?Q?1eP2Ugh5n5ca2jOM3v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cacecf98-e5fb-48d6-f75b-08de4d1f2112
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 12:28:42.8452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m5/Bn5q2ZWcGhj46pp0umFrirXiiEyMxnFrm9x/6znScYWyyuXZRQwbdvpRFZBrN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6885
X-Rspam-User: 
X-Rspamd-Queue-Id: 05217100004
X-Rspamd-Server: rspam04
X-Stat-Signature: q965prb8kirda3n6gmfozrn58asizde5
X-HE-Tag: 1767702525-91853
X-HE-Meta: U2FsdGVkX1+LzCWYLzInKutttxXZWQsSN0rveizXQidH5BtIut/84kGPHazer0r9gRNkVX1shFNwkg4vBvUE17RXe09zje9USxoY6I/BjF9r6eEyy1PDZhX26I0xsPJdOdl6pXxst7EwLItor9qIzjMZdwNdG+0OiKxoSforTuJS77mZRPpFdGQKzZ+l3Qm45HW48xexETAzNYlxmP8Im5Ulxs37mewnZJMRApoQ3lqIvejEhsp24RQa0YvhZOJsxwWVPIvhkOwPYLLcFLqsKtWyBUH7iobGx7atvxeM0bPRcn96jeJ2/Nwu2LKD407oHkwSyHo9RrCxpSw6+ssf56OauEvGdeY2k7otYWQGHHkocq/p07MwkOMmA5M/ijm5NAWaSzuFuW+WnwXlsh3OwzC69xWFpxTZVUeiIMvnm0ut6fqLfOIlahSSJAJxsEf9hxJDeuLe6G8yockhOJS5qqcIDmJkEwwU88esx584vd4V5n0zp2NRWlJftR0QlvzMX/zKWDCWFzRcQDVSLVSyG9/rqTGiuRggy54cqf1Z84T/lgViZIqgEzhPYz3zi9VoaLikYR6LTuaU8zdWEy2j/E1FZC5UX9dwmFD8n7fkiWNzstiIZuwdOItac7h05hZfZYT8AeKDJhjqsmlKa+puqCHfmbL3Tese0P4/bEV4NOuOlwCowTYH7T7tDRVowtwr+sn/qJo5eno2KjCa5DI5RmN+M0isv2JtgF2as8wwV1oBKoQ6x4szdZqs0DJnFU+sEwG1H1pxwQU+njXaDdA5rrxP82TqTGpTK97qOgWXOmMrKorZRCVw/nSi8KtL4noDxtCuH9zNEEIisQLPEOV+HEOr5vsGaPv41+DXI4W+EZzh7cFdPXIH+kcwxsy5C+vRlVJWjfdwP6mYkiDeBDgz4E9J+d+qNLuvKn9nDbZOR000CbOi0lVBV/X+rMDV3Ow3NqgEeS9M6/ANtvkRiHe
 KsEsRAp3
 AuwzMLvjynFf3ACtn37QPVPlm/fraAzI7t4sPxB1nKNaVAsM43SdIUfJImnqyUh3he5YpSWyt64HMxWdRCU+gMl/5vYaNcAN3Z3ggb7GU1FEixGoDs3v99T5vQ5HSoM412noeE+ezzlI+MQS5CSpNhg8KKwbxYr1AVqin4i2bjB7CtYdnJvTjBr+UFUkKyjcW58rRiAMsfcrO5WTvCGTvGeJYTLZILzYNHEV3NRqrSjirCE5RIIiOAqDffL56HuDTWerlOx5ZEGIwV6uBc4uQ9pZEfIL6Oao9PnuP3Rigy6McObmdx7Gv2TxgNFxtJfPtXe76GfGUrzZcdyJID3jnOYNV6xJk6XCE0v8VACYah6VtE0/AF2uo10Zy4JBd5fBZ/uRGA8DDMHEUPeGsUlXhzY58nuJKaVZFb922IbUWmcMcNr0B1GHXAFXMfRBXErG3iVXLZaxw0qhRo11BmkzC9cweqIpI1aELuIjcPcpXDyGeAaUSKog6cNY/LzU8hpRHEXYOOBFyK8tc1x5rS/LbHPGWf0TzrcMB18fOhDFK+bNyumy3fJwW2Q+ewQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Jan 2026, at 4:54, Wei Yang wrote:

> On Mon, Jan 05, 2026 at 05:16:45PM +0100, David Hildenbrand (Red Hat) wro=
te:
>> On 1/4/26 03:37, Wei Yang wrote:
>>> On Tue, Dec 23, 2025 at 12:25:39PM +0000, Wei Yang wrote:
>>>> The primary goal of the folio_check_splittable() function is to valida=
te
>>>> whether a folio is suitable for splitting and to bail out early if it =
is
>>>> not.
>>>>
>>>> Currently, some order-related checks are scattered throughout the
>>>> calling code rather than being centralized in folio_check_splittable()=
.
>>>>
>>>> This commit moves all remaining order-related validation logic into
>>>> folio_check_splittable(). This consolidation ensures that the function
>>>> serves its intended purpose as a single point of failure and improves
>>>> the clarity and maintainability of the surrounding code.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>
>>>> ---
>>> [...]
>>>> @@ -3719,28 +3723,33 @@ int folio_check_splittable(struct folio *folio=
, unsigned int new_order,
>>>> 		/* order-1 is not supported for anonymous THP. */
>>>> 		if (new_order =3D=3D 1)
>>>> 			return -EINVAL;
>>>> -	} else if (split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_order) {
>>>> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>>> -		    !mapping_large_folio_support(folio->mapping)) {
>>>> -			/*
>>>> -			 * We can always split a folio down to a single page
>>>> -			 * (new_order =3D=3D 0) uniformly.
>>>> -			 *
>>>> -			 * For any other scenario
>>>> -			 *   a) uniform split targeting a large folio
>>>> -			 *      (new_order > 0)
>>>> -			 *   b) any non-uniform split
>>>> -			 * we must confirm that the file system supports large
>>>> -			 * folios.
>>>> -			 *
>>>> -			 * Note that we might still have THPs in such
>>>> -			 * mappings, which is created from khugepaged when
>>>> -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>>>> -			 * case, the mapping does not actually support large
>>>> -			 * folios properly.
>>>> -			 */
>>>> -			return -EINVAL;
>>>> +	} else {
>>>> +		if (split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_order) {
>>>> +			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>>> +			    !mapping_large_folio_support(folio->mapping)) {
>>>> +				/*
>>>> +				 * We can always split a folio down to a
>>>> +				 * single page (new_order =3D=3D 0) uniformly.
>>>> +				 *
>>>> +				 * For any other scenario
>>>> +				 *   a) uniform split targeting a large folio
>>>> +				 *      (new_order > 0)
>>>> +				 *   b) any non-uniform split
>>>> +				 * we must confirm that the file system
>>>> +				 * supports large folios.
>>>> +				 *
>>>> +				 * Note that we might still have THPs in such
>>>> +				 * mappings, which is created from khugepaged
>>>> +				 * when CONFIG_READ_ONLY_THP_FOR_FS is
>>>> +				 * enabled. But in that case, the mapping does
>>>> +				 * not actually support large folios properly.
>>>> +				 */
>>>> +				return -EINVAL;
>>>> +			}
>>>> 		}
>>>
>>> Hi, Happy New Year to all :-)
>>
>> Happy new year to you, too!
>>
>> There was an offlist discussion about some of the text below, because a
>> couple of people wondered whether it was an LLM-generated reply, and whe=
ther
>> it is even worth the time to read.
>>
>> So I am curious, did you end up using an LLM to compose this reply, and =
if
>> so, to which degree? Only to improve your writing or also to come up wit=
h an
>> analysis, code etc?
>>
>
> The first three paragraph of the mail is polished by LLM, since once upon=
 a
> time Andrew suggested me to use LLM to refine my text.
>
> Others, including the code change is not LLM-generated.
>
>> Feel free to use an LLM to improve your writing, analysis etc. Just a no=
te
>> that nobody here is interested in getting LLM-slopped, so don't send
>> unfiltered/unchecked LLM output to the list.
>>
>> In general, I think it was raised already in the past, please don't send
>> patches for code you don't fully understand. It consumes quite some band=
width
>> for us reviewers/maintainers here and it just gets very likely to break
>> things by accident.
>>
>> The comment change suggestion below does not make any sense to fix a war=
ning
>> we trigger. If an LLM wrote it, you should never have sent it. If you wr=
ote
>> it, you should have invested more time to understand the problem and com=
e up
>> with a reasonable solution ... or not worked on it in the first place if=
 you
>> don't understand the details.
>>
>>
>> To the issue at hand: Zi Yan pointed this very thing out in v1 [1], no?
>>
>
> Hmm.. this is not the same thing.
>
> Actually before sending v2, I have talked with Zi Yan off-list and he sai=
d it
> looks good.

The off-list discussion was purely on V1 and you never sent me V2.
The last off-list email exchange was:

you: The related cleanup looks merged. Do you think it is proper to send v2=
 now?
me: Sure, feel free to do so.

No one would interpret it as =E2=80=9CV2 looks good=E2=80=9D.

In addition, if your patches are solely relying on other=E2=80=99s =E2=80=
=9Cit looks good=E2=80=9D,
please do not send them. You are responsible for the correctness of your pa=
tches.

I am done with wasting time on you.

>
> But after triggering the warning, I re-read the history and found the log=
ic is
> correct but comment is misleading. And current upstream don't report the
> warning if we want to split folio uniformly to 0 when the folio doesn't
> support.
>
> Or more worse, we should split to 0, but we didn't.
>
> Thanks for your patience on taking a look.
>
>> The patch as is cannot work: we cannot return -EINVAL for something that=
 is
>> not supposed to trigger a warning.
>>
>> [1] https://lore.kernel.org/linux-mm/01FABE3A-AD4E-4A09-B971-C89503A848D=
F@nvidia.com/
>>
>> --=20
>> Cheers
>>
>> David
>
> --=20
> Wei Yang
> Help you, Help me


Best Regards,
Yan, Zi

