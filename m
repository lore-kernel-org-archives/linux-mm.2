Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27089CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 02:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04866B0088; Thu, 15 Oct 2026 22:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8DF86B0092; Thu, 15 Oct 2026 22:41:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F486B0095; Thu, 15 Oct 2026 22:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 920CE6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:41:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23B691C2CAD
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:41:51 +0000 (UTC)
X-FDA: 85326939222.06.0DA2762
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013053.outbound.protection.outlook.com [40.93.196.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 46F6580007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:41:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V1OB2prG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792118508;
	b=x3JhAAuy+pbFaxJ+eMDH5/ZFF+3RG/uT9VM5VKZ7dsNkCQ+cqsijZ0GjZ6P2fKS21QEMb2
	lqX2MTLpf8rlgF7PuraCkCBq/Fp+Fig65FpHAciBuYxQ/23hUduQyA9XgGfvc0ngzgXX9I
	om4sTU10FU5vE/zYGJzQRH1I5+EStAI=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V1OB2prG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792118508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OtMmLhBeLqirt0Q7kXqfUO5ffFx3ulqdNIKghKUnZj8=;
	b=3ttNrAdXpkbBjap3WSHyNg8O58Z8XLLXMZwjvSSJYFkA9NY5A/HM7BLKoTYIRpjdtSZRjJ
	rRV7w0XS6X8u6c6MHGSgVyICwEIGghWwkVKytvC4gBfVSJgxMvSirmiWPl+AJw03LJYPyc
	6BpAzzgQMXdrbNlmbG1VU52xAwYAxa8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=os/v/geUsNzeDD/1XqAHi7lhNPvKTj/+FMCF6w4YtDeCGj3FfoPq0dnDlYyNllwOXw4tlkrl9Xar+AoligZFwYcH9mlDSqDWgF3mxHEV8xSE10yOhMosYZGGslD+ByCWmnOoZBNXnfZklaKigAA+fsAn3k6zpJeM7EGtWMoeHrUU668hbdE0HZb3TndjQ6lsgREsYphja3e83s7xA/f3580xH59CXI+pjcZ6hEY9JR4IlRgqcEnAFt0D/c+bLb2q6NlvbulhpYUP0Z1Jj867r5JWUYpLWEIopgHpnz4Til1yeXlGqzP7L2WakyVz8NhwoUolywmMtqvYMQnV+4SjTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtMmLhBeLqirt0Q7kXqfUO5ffFx3ulqdNIKghKUnZj8=;
 b=KAkXh9gHuG2cHE9O+q0g4Y+8s0zAOqe0t3ilrtk8rjOgr2oxlv7rmuv9e8RXt5t7PQpk2hFZeYITw/0sokkzymupzbIVtV8rnF4d62IkWdqguipXSdvZPBxwLo78BUweIrEaTCJOVD6yKohvSQwLW0dJGldhUqy+p8aVJwynQMR2CBoKoKtYkZp1qjs5JBwiKtzUVPe7wFBPr/iSsXTNL0TNkr/C8cVSmyC4+LtstNBALrIZnAtqfj4Nqaat8kPZydNRB9WvNXG2PJXNTF9F5Xw2QLOWjt+tQ528Zfj7iHi+Ujljluq5uh1ZIAQ9ArfQwfVGD9FWY+fHl/UxdOsZYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtMmLhBeLqirt0Q7kXqfUO5ffFx3ulqdNIKghKUnZj8=;
 b=V1OB2prGU2FVQ2nMa1QLiq5NqsLupjuVSea+75Ku2p/TmpqE99HeX3Hbd+14YVeENi5XxRDiV6PFG8+6l4xUS6g6evApHWCEBjTjJA2xfN3TdYdOB2bT7mZX1Zr7Byt3sySgmDyVrYlpFpFLSyM8rG4d2pfpIE9awPiCU44Zl/Tx5hLOqmB/Q89vNXBresGO7rCxjxvKkKBTMSwO5NuHFi4rHsRCG7+rHp94ZjMLYiXl0eAN5SvuAUrzcfsBi/gLKhD9IB2qKpNRW3JSY5GRPd4qDd13nvFpVXKGoqDmK4iwcvAjIRukwzgqWMpx99Hvb4YyPXtrsv8FY8wurOXRNg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8141.namprd12.prod.outlook.com (2603:10b6:806:339::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Fri, 16 Oct
 2026 02:41:44 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Fri, 16 Oct 2026
 02:41:43 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 Oct 2026 22:41:41 -0400
Message-Id: <DM5WZM70OU86.3K6UFWD42G217@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH for 7.4-rc2+ 2/7] riscv: mm: don't let GUP-fast follow
 invalidated THP PMDs
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Zi Yan"
 <ziy@nvidia.com>, "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre
 Ghiti" <alex@ghiti.fr>, "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu"
 <peterx@redhat.com>, <linux-riscv@lists.infradead.org>, "Jason Gunthorpe"
 <jgg@ziepe.ca>
To: "David Hildenbrand" <david@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Rik van
 Riel" <riel@surriel.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Jann Horn" <jannh@google.com>, "Kyle Zeng"
 <kylebot@openai.com>, "Andrew Morton" <akpm@linux-foundation.org>
X-Mailer: aerc 0.22.0
References: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
 <20261015-anon_vma_uaf_fix-v1-2-7b977303b42b@nvidia.com>
In-Reply-To: <20261015-anon_vma_uaf_fix-v1-2-7b977303b42b@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0322.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8141:EE_
X-MS-Office365-Filtering-Correlation-Id: 5047d656-b5e6-4a9f-c87f-08df2b2f0398
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|56012099006|261009223027099003|11063799006|921020|4143699003|18002099003|22082099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	tAEXEF23cak4xMrmUmaeU5qrIcIVvLXxI3PKQkEd2kT4i8/HLCxOBc5THIYrak+83aOCatgPsmWGvQH9A4nHWqOuNftqXiiMp5+QYyv+Vqyhs5WcFCilB0W3EOlZ3czP9VeR2HyDk2h6JsLZoSmf6P1eQJ3ISQlQrnk6LU54Y3OUtJS+zSn+zQLP4m3k6U811UBUDXvmWlZw5M/t0t2zPc0CCt9S8SAWTSUHPj4zSEjKFzYHyIPBz9ZHWUAJUQA4XMoMS+whJXWHI7mZG49m9VLMtH2IIFqkMywHPugMg0BCQX/aawSTr30Ir4rptEAD2ozEK2JYwutuxxsd1VbA/q5o8zQ+kc20b1vgFd4WTY1GA4f8EXj+Zuf00+he7QJ5tqRKVN8IsG3sUJYgZ5v9tXrXz97P2AN4RXwvU+MxAzQfDu6goMwE6svwF434Du1VVuMDOhSgKq+P7IgogS8yrPqBg3poRdelxm+Ux+kQvfd5RLl4xy6Xsptr7u3k8lgCaKiIOtAqwxkQzAZQXpnWzAtdMrmt0K5OuWM+8SK1FXNyGI3O1jKLgt30z+0TDjL/pHsoPOWNVTMoSgx91Rnbf1aiVSH66AchyO0p3xIsog/0b7TMHXaHwXrg3XYJBZT746FuFOSmBmssVT6zSvOWF+QuTT/8miLg+o4noKYsa9YltFtOaNe9iEioz1hQcqHmiqjmTaDJ097I/I8i4eLMgA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(56012099006)(261009223027099003)(11063799006)(921020)(4143699003)(18002099003)(22082099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QW1QN3VBRUpJaFRvVklReGsrTDVZOFRRbVdCMkFndXNYMitibWNKSXVjTjVk?=
 =?utf-8?B?R00rZ2xOYXo3UGFsK0hZWVcrY0VITEg5VFNiMmpYeTVGZ2hobkxtMDhnL1Nx?=
 =?utf-8?B?OEU0Ung3S0hKYjFrdXFMMnBxSUloNmVSNGpjK0xKbzMrb2hzcnRjYnUrYnlm?=
 =?utf-8?B?OERic281SHBDZnh5citZRDVlTGJpQlBQeUlTQ3ZDb05hdWxiTTMwRWl1SjZ1?=
 =?utf-8?B?SXhjTm5LL3NySngvTUJPYVJWeEJJT0JZbTVML1ZRcU4veG4vNzZuQlRTWkp5?=
 =?utf-8?B?SmcxOWM0L2dVdmU2azRlektBQjhKdjdCSVBGeHFNcEJHdGY2RjM4Z1ZLTTFi?=
 =?utf-8?B?d3lhQm90SzlvM1NUaWZqazFlUGVRNzUyZS9DbVQ5YzNyL2h1b2psVjRqSnpD?=
 =?utf-8?B?ZTVidXZaN0ZPZGRjNXAyZWwzMXpPVUJzYTdPSUtZQUh4RWxhQ1AweHh5bmVB?=
 =?utf-8?B?OWZqejBuZ3o0UlFoUTBrcUlqcVdSQ28yUVYxQ2t6bjVTNEV3aHpjZy94QUo0?=
 =?utf-8?B?OHZYbm9QR2gvRytPVytTakxxZzRncHhCMGsrcjgvODJqSzNQTnMyMTZaQnBH?=
 =?utf-8?B?cDlKQXRFczFlSnpYR3B5a0FjZ0k0SDRGWlZDMGMxTW5sdThmUnM3YTgxK1Fj?=
 =?utf-8?B?Ny9JdjFFU2UzM0FvZXR2eUtWUGlDWVMwcDNOcUxFVWc5UjNYZHpoaVlYTnI1?=
 =?utf-8?B?dUZ4TlRTQUtBRUlVSWdBT1dINkF0dDk4L3NieDFGY05hQUJ6U2V6TEhrTVJO?=
 =?utf-8?B?QTg5NzFNSFJnRzdNaVZadzBxWTBod2Q4UXdjTkZzUFVxWlVnUDFWZXZjdVNz?=
 =?utf-8?B?RzV2ZmhtOXRka2xyUHVyNWVpNlduamFLaG9lZ1RpL1pWQUpXVVFzdFBOWC85?=
 =?utf-8?B?ZXdHOVZKMzNjSUZXTnZWY25pa2tQWEZsVUd5am5CNERWTTFIUXd5eDAxekJQ?=
 =?utf-8?B?WFF2bFJUUDQ2SFQxN3NoNUd1Z1dNaUVieWhXMTY3bTAxWjdXbzRSUE80YndC?=
 =?utf-8?B?Sm44NUNiRU9ybkU2emRMK0RqdHFSUlVzL3kwbGhwNlI4ZEpVTWZsYmo4cTYy?=
 =?utf-8?B?cEpBcXFUa0duN21qV3V3MlZtTi80QlB2UmMyUWtSeHN5OVRyckxucTdSbUlm?=
 =?utf-8?B?ZDM4dUJacXMzSWdaSlNUUkRUeU1WeDAydGpTbXJpUlNvM3dNYmxJMHE5K09w?=
 =?utf-8?B?RFo3R2NGaVo4eTlsMzBZR3FmS0NZeXhPV0VITDBONUNZQm54bXBSalZScG01?=
 =?utf-8?B?SlJxbUEyOXRvbit2Si9remtzY3NjUXM0TlcwblJEdkMrSDVnMzMxd0Z0bEZN?=
 =?utf-8?B?dEtKM2Y3SWlTQlZydEczb255M1pjSFNIRFlmRVdVNEQra01tdkU1eG9HdW14?=
 =?utf-8?B?MTBTWmJXTVV1MzYvbVRSN0F2QVJHU0d6MUh0cjhqWTFySVpyaDFnNG5EMEt6?=
 =?utf-8?B?VlBMckw3eFEzS0g0cjBnSXlMclFiZ0NwcDVlenhLZUhrWEUvTXZ6V2pQK1Nk?=
 =?utf-8?B?T3pIS1JhSXZ3VFZ3OTBuYkQzaUxHczVXR3hIRUhIRXRWL0Z1Z1E3a2tWUE5D?=
 =?utf-8?B?dFJGamNVVDVicVRUbGtyb1NtaWFqd1p3anpCalh0WGFLcjlRN3NPNEZSQVR1?=
 =?utf-8?B?QWpLOUtQZDIxaS9jbFVBVEtnYXFVQ3NXc2FrSFRkZXREemJteGF2ZlBGQ01a?=
 =?utf-8?B?T011eWxxT0ZWbDhlSEQ1T1lycTM3aldvK2Y5Z0FkTE9hWGEvL1lVWStPWEFn?=
 =?utf-8?B?T2VtNWc5NVhKeTU0RWorRlE4ZTZXZnBsOXJORUJOVjJhU3lXNTlLcGlWbnAr?=
 =?utf-8?B?ZkNaV215L0x5WEtacW0yMUZhWVd4WFU1ZnZMTzFISVBLOGpGc0hiNitWUjFh?=
 =?utf-8?B?eFRJczZXUHFsOWViWnI0T0NDSndPSnZ6M0hOQmg3RVE3ellLMFhuTzY5M0Fz?=
 =?utf-8?B?UUtFR29iYlhmdjl5RktocFBIMitYR2pPUmZTMnE1dGRXeFFKTnJBWk9XZW01?=
 =?utf-8?B?MUlBTVlUcEFkMXFUY3g1Z1A0WFNEdlB0Uk5TZWEzL0ljK3BwQVlGN09IUC96?=
 =?utf-8?B?YndGSEw4OWR5VjV1NTRpclZwRHZxcVBwTk9MVzBNWjRtd2o4ODVGSnoxVXY4?=
 =?utf-8?B?d214MmxZMjFpY01FeURyOE1wbGd0R1BmRkVvYXpEZExLOGszVGRBQWg1YytB?=
 =?utf-8?B?UXFXSDN6aW4rSGFwWkl6RFFqakN0ZVNUSlM4K1pQVnJHMmtWSkNkMlFISGNo?=
 =?utf-8?B?MFBqNWNmTVcyRkZTdnVSRWxqbEo3R3lEWHpYMUYraGt1VXR4ZjJuQWVCWmRT?=
 =?utf-8?Q?U4IAWwKcN8tXhakhiJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5047d656-b5e6-4a9f-c87f-08df2b2f0398
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 02:41:43.6505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z5/jMt5QB+fJdLt49q4t+8or4h4mjQ3ni7fl/mg9JS2Je938HVbwvaI8/Mhmb0aX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8141
X-Stat-Signature: 57enrr8hq11my5op9a3q8pkdzphzse7e
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 46F6580007
X-HE-Tag: 1792118508-935302
X-HE-Meta: U2FsdGVkX18wr0dEY6dNkX/YIl6DdNxywnXDCfYIW3cVEEI3u+iY2Z5C83m8DPtcBlhdKpU5gqAZr+xiVMgX3dp40tF4Cj5sGIdrwiN2jte4Uultc+nddSKUZppvZeMHH7tPMchVdsMawzY529LH2g4vRKYkB7x7QnAu+N8K+khla1edTsbJZt459cr4WInYedg9mUtGpMdlawjoUhQczEAVPNNlBLmBj7Zgj2L7958Sjch0CSpzEXAeClLTSi1QulXlx+ilrSpqkt/ULockBg1TP4sJDTpLj/VdDJVR4v/r/cNdUgNvUzWhNCwLHlI9pwAOru8J3diZX8SjAtS9Zz/i8o9nL/LaLhCIkfv6SbN2Kr+wazKPugRqRRF2CPMndBpqKQKAq36HRfE8pia7BKfeVov4E5Neb8YBzJqRLG8r/ZfgQzeHjixgD/SC5jnibD5bbogFL5rv2yL60fkp3GlKvEOcA4cYsqjydgMI9edUOQEpUu1r9kDvQEjWxL3jYewLKokBsNNlD847WMu3ccm0F1arQnpp9HUUghTrbl+wcfFDjBrFw5+uRc5Tdx/jK1QsWqzH3+CBzgT5IkpSwhv6etv2a170ja1QoJdcDgJmkz+oHBcgIhZYakAP9MSSx7/IHZR6ooMhRuLZGCOEplY+x2QxesM1fmr9iLgc6R0qso/0yaienefDhV6k7qDLt2wBOJfkOb34B7aEUtBc9vrJ8v9SQiMThFck1YVOpwteoBDFYro3i0IgCYsDcIRUhA7IfjKKRo/33nVx2CfNzTcZxc7+WtRjHmOlbsr9zYl3c4brqkDNkZFTAGmrKmti7ByappHdrYpmCm2ZVMNqdo9guu0Be7Wgr86MDB05yZQM9iy0jm6Nan9b4j3wU4ZrmisHjKSHr2YStvvSr+++wo89E3CU3EK7S/vrs1loaF6pxz1MMVLiXrPlHEu232qBb0GRH0R5dXSZi5iKxuf
 13yICjqa
 F09S+Zp0Cdxtr3ojpaj1h5IoJRT5DHhA/T9c2txW6nUKsXFKbJx6wJNGdMixhbNU9SGVmUNx/qXv4OcKE+97qcwEqcFlefUYE/ngfkb+mN4CP4bFsyJFp918q+6kgeLmDEtActKTzbzllFIjt97B1ZR6O5lAylcJEpvd1W238EIVrMyskOZjF/nhtVgXMPfD3YhEBpmmuF51OKVDnHRxm/YOYTgr3StU/T0Zx/m6QjuSDCSSjmNVvK0QRBAJsj3PgqQhzK1FpXuAFjJiiMg8roG9t02XkLgaZ+JF2HwWdxllQmxCgeEukk8qnBH45IMnGObHnBB9HmiVX7WBL2Zx31PTLoZd62vreI/zJG0zKyfIt6BMmNebtpsNum+fw13T1NpimfebXejKkBNairhvTWw7NiGA5fOghQmGyMD9bpHb6egWXA6EUFXx6cXQaUxwFkJ/D02kp+9IHD0DkFIINXHOa1IlSx+wglxA49s2XzxAj4ALJRunHdz+ZZFrpGigUx8JAKhpje6Mk2PXDSVtagDMgLGnVCiLI8DMTV7S42zm5YJQRjdbYRjtNqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Oct 15, 2026 at 2:13 PM EDT, Zi Yan wrote:
> pmdp_invalidate() leaves a PMD whose pmd_present() is still true, so the
> generic pmd_access_permitted() returns true for an invalidated PMD. Then
> GUP-fast can grab a reference on the folio and, as the PMD value doesn't
> change until the caller finishes, the recheck after taking the reference
> passes too.
>
> Code that invalidates a PMD and then decides, from the folio refcount,
> whether it may drop the mapping relies on GUP-fast backing off from an
> invalidated PMD, like it does from a cleared one. x86, arm64 and powerpc
> already reject invalidated PMDs in pmd_access_permitted().
>
> Provide a riscv pmd_access_permitted() that requires _PAGE_PRESENT, so
> invalidated (and PROT_NONE) PMDs are not followed by GUP-fast.
>
> Assisted-by: LLM
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Paul Walmsley <pjw@kernel.org>
> To: Palmer Dabbelt <palmer@dabbelt.com>
> To: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Alexandre Ghiti <alex@ghiti.fr>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: linux-riscv@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/riscv/include/asm/pgtable.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pg=
table.h
> index d48f90140841e..66aac56631f0c 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -816,6 +816,12 @@ static inline int pmd_write(pmd_t pmd)
>  	return pte_write(pmd_pte(pmd));
>  }
> =20
> +#define pmd_access_permitted pmd_access_permitted
> +static inline bool pmd_access_permitted(pmd_t pmd, bool write)
> +{
> +	return (pmd_val(pmd) & _PAGE_PRESENT) && (!write || pmd_write(pmd));
> +}
> +

Sashiko asked if this function allows GUP-fast to follow execute-only
pages so that the page can be read.

Answer:

yes, and the new patch is at[1] and fixes both issues.

[1] https://lore.kernel.org/all/20261015-riscv-gup-read-fix-v1-1-8cf7f25040=
29@nvidia.com/

--=20
Best Regards,
Yan, Zi


