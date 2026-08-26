Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DFE5C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2384B6B0098; Wed, 26 Aug 2026 12:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C35D6B0099; Wed, 26 Aug 2026 12:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063AE6B009B; Wed, 26 Aug 2026 12:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D379F6B0098
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:45:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFC361C09A6
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:45:38 +0000 (UTC)
X-FDA: 85143996756.05.784FE2F
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012044.outbound.protection.outlook.com [40.107.209.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 06A348000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:45:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CJj1AsKQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787762736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUUYMidovale9j1gyJJ0rTi+LQ4pMu02wZ3xFBrC720=;
	b=JbhbA+iAQXJeMFMAVniNSjvvfJj6gUJQbOu+qjJLZ3Pbtcf1UokrH2Y+cnEA4HGq0NovAk
	YurMQUCVebSdMEiNZuxd9k91U0F3k/y9i3Ual74RbIBYJLC/8f775F4zoyBlDJAfGAatS2
	9Pnr0cY+6JB+LmGGkU4DRDCMRaV/5SQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CJj1AsKQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787762736;
	b=f4eZOmIEbjTD+MpGwJ6JvXKLpUer8trr1ce3v5L8JFbTJPeFrBsmDx8ShZhV7G+pY4MWlY
	+jMJOqUr5g6JQfuwYdeeSNPj8uf1pYeTP8QT276HA70TzDi6wBH2HVfZFFYV8JhIbeHZZ0
	onxAKXpIC63gDUtou+z2VFeXIOeRqoc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I/W6d31Wb/ck8MDIpPCO1XC2pQ8v3mVpg+DmXI5lAJlR81MOa9euPbwsu+TtmfvQbZM7XFgrbKCbiyQFJFN0/8YeXgwBedS2PPigqD4l5iiLK3xpb7iVJO2HAeVQNMvdo7voJ1OKRKCqk7MnQzmt+yzJC5UNVQZj7A5B0pDdULdM2ld4fOW22L2fYHspjr3BrepYvH7JY+GFLN12EEp6QCbSFk/hLJlK4JohbCGKLIHOEi1vJ3NNxGdGVkQIoXmkhWXWmI10SOhUx8yhkrxpeKRdm3aTDZoBJfwIIYDzXXgZ+Po8QCajcgyE6Y/xd43cmaWxnxo78e8N+vif0eBbsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUUYMidovale9j1gyJJ0rTi+LQ4pMu02wZ3xFBrC720=;
 b=gYSgDPzOAh+PWBdwN0GJHReWRsyfAy99v+N0K6LoRA83w3Fn8Sxq3z7Zml8Lwx/l4So0XWoRbEOgtmLDMf9qWqfGYQSkqPYGDX6c2yNU8EzLjexE8RZeg9jqVGcpRAllmpRR6ZZHuLoAuoMv10bmxqxQP39KlBvYqwwn9RKkh+/cHJjQhAsUbYgdpLFjOgloN6l0CSkuw1Cc50JdL15xKxfKy8gOxQOJamloE6KAvU3Rbc9laMBqHavXoJ6iQobGvffJDNlcRyq1nGb2ZUJpTLsvVyf4z1NFoF51jQSFelgtt4N+GmRtb8Uoh23q8mfzHZhovW/aMqaVcuKn/1jRZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUUYMidovale9j1gyJJ0rTi+LQ4pMu02wZ3xFBrC720=;
 b=CJj1AsKQwYnN/POmz78O1ravycp+fN1SmhMWyZQ5KbEPu0bc7ikjB6gotZhmjgWkFKihspCZ/dp0dL/7iSvJY9Np0gFYTM5+PssnvyWCloJ3r4OyBh2++vxmOudHtMbv2J+gfjzMjy6Bnp6y7HrykWzUCgOM5oaDK7SHQknBMiTRyHPmtDpz6coXFq9jdQ6/ylwsCnqSd2md07onz/M+MTSOgtZok52CtlFvBotqD+ANsqVwiAHUJg9xEc0kisLk/DOM8r4uwcXZBvt2efyKdVZyMAeYyQyrCz2C+qaQCNMNFmEeSF+O/BloVPk3BhJ6fn3/yhQz98tfJ5nP40TemA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB7960.namprd12.prod.outlook.com (2603:10b6:510:287::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.9; Wed, 26 Aug
 2026 16:45:30 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 16:45:30 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 26 Aug 2026 12:45:29 -0400
Message-Id: <DKZ0ZVTFFJAW.1EZR236WVK3IB@nvidia.com>
Subject: Re: [PATCH 1/5] mm/huge_memory: do not touch frozen folios in
 deferred_split_isolate()
Cc: <lance.yang@linux.dev>, <hughd@google.com>,
 <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>, <liam@infradead.org>,
 <nico.pache@linux.dev>, <dev.jain@arm.com>, <ryan.roberts@arm.com>,
 <balbirs@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <hannes@cmpxchg.org>,
 <usama.arif@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260826162101.1314941-1-kirill@shutemov.name>
 <20260826162101.1314941-2-kirill@shutemov.name>
In-Reply-To: <20260826162101.1314941-2-kirill@shutemov.name>
X-ClientProxiedBy: YQZPR01CA0047.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB7960:EE_
X-MS-Office365-Filtering-Correlation-Id: ee147d69-69d4-4acc-2ef2-08df039170c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|56012099006|10067099003|5023799004|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ubHIvY5eJyBDycKmF9fxArbBdgx6qrDXfY/UsYFVE/9rYfzHpGtZMtNoF6dCpZIDzDSgqZXZtp6s/icfZon2iVOc+Kpfk8lJW4oUrhOsSndMNPK1L31nGRE0+eSYpTzKtyVxl3Lr+zWP5N8Oku2jZm8PrGr2R9bRGrmo1YZkkvwf4NuTUM6EmQw8/1R5yMztLSA3SQ5CMfYAfW+IkTBo6lUotV2+xweXPggQA1t2At2Ls1FgVrROnZvgLESZHbY78OK5nfAsQmLDO4S+AMFahuVOxM8W6smfonYLI9J/csr5+cIVEk3gZFcbZUca3RP3Ib+DY0qFNS9EQFuHNYQLAlebmvgLkigwYM/fQYzqAayqGjxMHV6JhGnoojEDeA35Pm4ly4tlHeD66LCDBTAp5mGYk29z6AgVrE8018jePWR6jpE2V/Dg0Wlt916toCiyT823827UqoXzapFKDUIi3W/EpVbC8k8l4w4Ticyoy5XcItFp5uCln+/oyuNpWoEgPrKjJR+GIioRcDI7Y4DzLO9zhxzTbAgfmjLMaIxuzbaPLHcFcY+tJDaSb3Wa8mDfDXOq79uPg6Hi7sM2Shsg9qndLenRBrUUF9ZogG0xg/iie4+lyuVk/otQC0k7SNbWKWS8l79Ub7wCIMnDHY6FFsxEJqq++EP9kK29XCRoj8A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(56012099006)(10067099003)(5023799004)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akZleVlxN0V4N05rSjRacG5ZdXNoNjF0eVQxN3dsYUtSMzJXelRMaXA3YWpN?=
 =?utf-8?B?aVd3VytER2ljbit2Q0FwUTZQVlpEcHkxWTVabjJ4R1k3UUFjUS9WQzdBL1k5?=
 =?utf-8?B?L21JUkhzSy9OcjQzTy92S3lScUllZDZad2Z1S2k2bW1rdTJVZ3QvNmNFenVS?=
 =?utf-8?B?TmkyWW9RUk1xT2hNSjVqZTVCL0g2N1drUEpibzBNL20vdWlqNGhrQWYvd3hP?=
 =?utf-8?B?STY4cTF5Q3BrZFJGQXgyeFc3SFVGOWs1UDJRcE1IaDY0N3VqRVZpZjdIUjVD?=
 =?utf-8?B?enYvZ1ZZU3p4cGxWNXh5a2xob0M3VmEvd3ZpNlVxd2xSOEd2SmwzcWN1dC9Z?=
 =?utf-8?B?MklTL09HaU53MUpTR1JlaGEzK3BOZ1NReExtbXVrV2ZyZWtsTUJkREVjZzdr?=
 =?utf-8?B?dit1NUZ2dHZTb29CQkcwYWtmL0paUzVkNDNSY1NoaytwU2ZLUFgyVTR1NU5U?=
 =?utf-8?B?Qzcvb3k2SkJCQlliS3BYRzlYSC8xSGVmOFRnbTllYTNVWEh3dUdOTlo5YXFq?=
 =?utf-8?B?ajByNEdWOVg1OTNCSXM1aEJnQ045elVtSTNDNkZKK3RlL1J4dWdMVy9TSEdo?=
 =?utf-8?B?UGh4azhXZEFrNDhqR2xCcHVFajZqMjBxYXRzYUFZOHRVNDVSWWFpUkJ2R2lu?=
 =?utf-8?B?YWhRMndtQnhnSXYrb1pUbTZCZi9qYXV0aUV6blNKMW9ieXFHL0EzcGNzdWdv?=
 =?utf-8?B?eG44YXZyNFoySDNtdXZmZ3ZyOTdzTEx3TWliNDU3QzZUcktuWCt1QXZYRHJq?=
 =?utf-8?B?QXFVeVgydUMyV2YxRkljWUMwcWU1bktiQXhDUnQ5aElrSFJvdDF4UTN3TGF2?=
 =?utf-8?B?K2ZzelpKYU1rL3pPTlZsRnhCbWwrOGgzU0xwVWR2WkF0ejE3WU1EUjBvd3dY?=
 =?utf-8?B?a3h5SnNCWkd6ZkhuRURhTVpvcndibG5YR1cyVzJxVTM2OXdnSjhCVGJzMU4z?=
 =?utf-8?B?Rm9iLzVGNTlRTVB3Ym5RV2pvQ3J6Ymc3bmNqWjJwRjh2NUdNaXgzUllkYzdF?=
 =?utf-8?B?ZW1xcC9EMCtOZTNCQkNMQUY0ekNPVHJ2ZXJCbWNZM3hKMzhJSG1IZHQ4T1FR?=
 =?utf-8?B?cUhCb0tqS1I5STlqRjFUK2lCRlVCbDNvekFENjJrY1RRdGlQaDhaRElWY20w?=
 =?utf-8?B?aGsrWXpvZ2lYNnF3cWlRaDVVc3B1ZDF1RnZhY0ZkTlZjY2VXL291TWwvc2E2?=
 =?utf-8?B?RkorR0txcDd1RUZiY1JhajI4dDNoVlpIUHRpL3pTY01tT3Qra0llRmNrbnlw?=
 =?utf-8?B?SmcwK0wwTlc5RHIwVldNY3FtRkNLck11S01TeHF0Q2lGY1V1czhzZHFkN0lk?=
 =?utf-8?B?dXM1elZRdjRzZ2VEeUZMeTNaRjBZdTVHMDI3eGxkT083bXI2VTFnUEtRM1NB?=
 =?utf-8?B?NzRIVjFvNzJZWng5SU05WUhRejlTMkZTZVRxUi9GRksySWRZQytZUzJ1QUdY?=
 =?utf-8?B?Vkl1MStTMjlFdmNRNWd3Um1RVXdmSklscDVBM25vQkQ2ZkJYeTl4S3lkK0Nw?=
 =?utf-8?B?dW1uRHpaWWdyT0NDaEgyU1g5bmoxbHFQSy9rVCtiN1BHNVJiWnA5Z09BUXpL?=
 =?utf-8?B?TVNRelE3bU42S0kybnhiek9UWE5ZSVljMHBSb1BDUU9QVEVHUDdLV2h6VXV5?=
 =?utf-8?B?WGlKOXJRVWY0MGxuWGhzRVNmQWt6MUNOYU9CQ0gyUXBXTlYvZXY4M05leUpm?=
 =?utf-8?B?OVdNWk4xL3pUNUdPQWQ2TytqeU4yTCtGRHNDVVpvdEdhbzZSbHgrRWdKVVNQ?=
 =?utf-8?B?RU1tKzhlRURRMk1MWXFYMWlIZGE5OVE4TzlTTTR2QkxKQXFGTytET1RPRzFn?=
 =?utf-8?B?c3MzMGR1TTRQWEdXeW43eEJQYWV0cllSSEtIV3pLaEdyVlNUYWRxRDI0T0V3?=
 =?utf-8?B?Zm44aVBPWitCYWdadG5uMzZ0UGhJNWR6aDRDaU1CZTc4N3IvNnQ4MkFXVlI0?=
 =?utf-8?B?VzJqaENJdG1mNzJ6K0FpTWgxajNxZ09lcG4zcHdYUjViZlVqcVFqc3pGVWNC?=
 =?utf-8?B?cExYUlZFSVMwUXFjOXhqS1pFQmhpZGwrUEh6cWF3OFpqeEVMYko1ckZhbFAv?=
 =?utf-8?B?YjZidkR1VmJvbWVlMXhyRUVweGRMYjJJTjNDNEtPM1hCc3hodXZLb0tsNnBK?=
 =?utf-8?B?cktVTVpwNlZDVW4vbGVHamF4Z1F0bVkrVXBhRncydFQxSnRtaXJodXJnbWcr?=
 =?utf-8?B?NHZVeFBvS2ZNNU4waDdkaHlEbFJabkQ0b2hqZ1RvYUVuSHBtT0Y2OUdRQ3hp?=
 =?utf-8?B?cXhlNm1yM0tNc0FuQUJOenBVRHJ5N3JKNngxMWplVGxuS24yemZrUS9BTFVV?=
 =?utf-8?Q?y2il/Xi816vrZS92xT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee147d69-69d4-4acc-2ef2-08df039170c1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 16:45:30.7829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vt1qXxw0AyPtNXPhO7G2TZkvj/RaB09M84y0tN2xVqfFj8NGbaRXe/tB5SHgg55L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7960
X-Stat-Signature: jm7papmmnwqrep6c1fqngstwmbuujnoe
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 06A348000C
X-Rspam-User: 
X-HE-Tag: 1787762735-358226
X-HE-Meta: U2FsdGVkX187ZJejeCFlVeVmsYKYswMZXxl76tr7VeFjpeBojfLmpo8r99d6p7SUec0CaaRtM53yTQh8364DHYZm6VugpY43KYMaZkJeWgCVwiPsHnG49pizozqG8D7nZt9U4ZI3HuzfQMAQwXEyyiou5e511hhyw7nOZg0GGr5ku39qJS5qk8C8rkqX3HiQ+VXBEhcFfJM8zZ7OIPar3NSlww/3qBJ2DxbvRlio4V0A+dDWzOzFaJMLEDESUM7v4ABHlAKl2IIcA9VDiUbKh84WpiV4eI6t7t/M2iHY9ewrr3hZ2qJ1jqe6ECycG5Z5qzg9cuqLby1nEerzflx1gPO2VE927nD4fQZaAokvYpjvw4C1iCIebFgO8pR6HFgdmeVoTRbYZ3LNKoJkdhgzAbP7zLHUMaTdFPpQLi/X4tU11yWVkzf09WkHjtyMVy6N1sBAj+KUZu2lGr5Jrx0KSOigt3EiXKB4UduUGWyO4T3YTSqSVKIv78qa7om3Z4MQYsTdE0IgWBQtp0xsrJKSEjc6hHUrNIOI8jpjhByvw0DDR8unStxkrLQRvVe1Q7ei2xww1XU+jXIPXdRGkJ/JyVDlPkdyektWtgj8SrF9mDKnltEkbdUR++a/O+6JsFVgyZ53+ROserPBAmCUOKGbuTE+i0d8phm5iOouNuTN4Z3iAe2be5Uxpv3jYJNf8kNTDByo4MRQsMexppOzfyeFeh+PX1HZGsTx3Jazm5c06XOhF+hulBDPxNeiDbp3VqVMcyhl/uyCTeDnishztqnEw+Npe7kL2b/t8SfcquP/RhjqTcFOfHPj3f39ZHQCagHQvmK+tYn8Max63juPSZqpbXXww+lHNmsAbChwkQjzYs1j3HZ4cqPNxWWrjs1zTTEkHuxy0ybfNvubiegc2aXVsk9lSmMZQyVoSgvG2KZ6WgkkasyfFlNQ/xNNKJhwkqq6vpxWk8DGaiQ6xmhpOFi
 kZxWIEv/
 dAHJ8VBwy9oiEOJl3qE7FL78m38WmaCDWJphV9z0fwPS60s9hpg260XuWqgUbkV00EN3+stiyR86ddI9opozRplPUwViiJrC922GrZqDMsWTZ2AaTZsYU/jTUpxbkF2A3x3wv287wf73shLPoY9zI2pxZEj44ItM0dC+FiGoarSEIZUjUpnCX8kItlHZiYtX3r0o6hRow0rKz3AIGa2cgo+bVgNsKsizJaFOW6jBTLUwFi6ag6qu3BmbaEbEg7MhAIHCnVM7Jy1wZ0SDUrUmnaNqs+gbCuOVrxWYmAhdxa6sn6H7T00ry1q9NVBFJ5zwYb9bLR5KGOLYEUlLqzIGodjWsQKrjwK38OJNN0bkOLa23EnPLleDHb4m241U6Pux4JMma2OQBzcQDdAd0iuCSVkXsdtGJOFvEOAEO4+SwEOF9Q/IGK0cRnjl8ztVvdDmqt7b0m+jj/+rhWqAR4F15NTZMcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 26, 2026 at 12:20 PM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> deferred_split_isolate() probes each queued folio with folio_try_get().
> folio_try_get() failure is treated as a lost race with folio_put(): clear
> PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take
> the folio off the queue.
>
> The folio_put() race is the most common case for !folio_try_get(), but
> it is not the only option. Another scenario is folio_ref_freeze().
>
> A zero refcount in such cases does not mean the folio is going away.  It
> means "don't touch me" and current deferred_split_isolate() doesn't
> respect it. It can lead to unqueueing folios from the deferred list for
> no reason:
>
>     CPU 0                            CPU 1
>     ---------------------------      ------------------------------
>     freeze a mapped folio            deferred_split_scan()
>       folio_ref_freeze()               folio_try_get() fails
>                                        folio_clear_partially_mapped()
>                                        NR_ANON_PARTIALLY_MAPPED--
>                                        folio off the queue
>     give up, put it back
>       folio_ref_unfreeze()
>
> The folio is still partially mapped, but it is no longer a split candidat=
e.
> Nothing queues it again until part of it is unmapped once more.
>
> Skip the folio instead: whoever freezes the folio, owns it and owner is
> responsible for its fate. It also covers the folio_put() case:
> __folio_put() unqueues the folio via folio_unqueue_deferred_split().
>
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Link: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux=
.dev/

Should this be Closes: ?

> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/huge_memory.c | 19 ++++---------------
>  1 file changed, 4 insertions(+), 15 deletions(-)
>

Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


