Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2389CD98E3
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 21:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1516B8E0008; Thu, 13 Nov 2025 16:46:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A328E0002; Thu, 13 Nov 2025 16:46:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32CB8E0008; Thu, 13 Nov 2025 16:46:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE2A38E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:46:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7ED6385C87
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:46:10 +0000 (UTC)
X-FDA: 84106917300.06.87D9D54
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010002.outbound.protection.outlook.com [52.101.85.2])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9E2041A0009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:46:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FrMDGHZV;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763070367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0GAL7HpVFek+G6Dl9pDzqHrCopwP32zIzr1ZU1mD+w=;
	b=g4XlhshPzjyeCmgP3CqwXZcqmVaArhl2vVcDDqCILt5R4X80lBtK0Vhj5OdVaegFhrsc/H
	yJXIh/q9KbdnJPLvBzDpZgLj9btT8T0C/U9++0QN44QRpAqxEr6invyrrFI2jpbj/o4iVC
	FoSkn1RZ6vlFQsOREKqfkn5b8jYx8KU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FrMDGHZV;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763070367; a=rsa-sha256;
	cv=pass;
	b=S1rvcB7WSe9SL+1mWZFDnjXv9gco+u7xz39ckBP9w7IXed7uney9RNb8Z+rPBXsH8vg8DP
	17Fl9fEq2KT1DRiFXlZIcewBbAr6irs/L5hff46H3fMR+sk2Ze+wYVahJRkjaUuVogaO0N
	CSdYYaie4VUpln8kSTWCKWz7wEdfUoA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pFw0xWLsVKd0LJnIeO0uM6Az8h84E1IZV5vSwZqW/JSUssTaHTTD1A6sg2IJGgtanqCuWBvlxKx/bXYg4kbRgEB6ep7nR+q9lPzWUZmEWLao6PIpw9sHY1E+l1iAc16bFFMdV2972EIQQrs0rM0t8JOnFf6HACjBnuKqcSoc0gEx36U/T4YBMoQlCBHy2nS6BhzawhXyIQZzY6CiO8KEtmPUD8NTiTsxJgS8VUgUlg3CEKnj56XICRibEgxrXqJA7U0zDhtqtBtDqJGDwoXb4h12eOsHIfodkroDaKL61Ab0vMXFNzzU7sA3u4fMgwQ/ajbmU6Ry7IRnWpGoYl3++g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0GAL7HpVFek+G6Dl9pDzqHrCopwP32zIzr1ZU1mD+w=;
 b=fi1VsKXjE5zfmYBa83xom9LJhy7+DBKEOHZIVQEaKMPWoi4gGS+EzSCkOs0fowZiQzbB6JPchp7nXyxaSMaLp0JNLWptcfLK+oIWKO/26OGYpggJKvZvowAYmZ4ZnUsau6IIpsTKv/bb7W1PEaKk4f6S/RpOCsAuZu6CifA5dtHPhs7D4BaRBdxqCkl7EwohAc7J6gFICT7iYr42l0fWcKtwMjDaBb2AJ7xi82EQtzmNqNQwJie36jrocSpFtBCQk7yIzyItOl7gCRo9Ibf3xQlhfjknBerHxr/eh2lBNdAmHk4MqJNOAR+gDCqhdV0Q2Kv7rwi6CYsvePl6BNV4fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0GAL7HpVFek+G6Dl9pDzqHrCopwP32zIzr1ZU1mD+w=;
 b=FrMDGHZVlWGHbe37EX2W+s8QBi3T0mJ+bHO170/K1/PdUhCxcAyd9DMaKefjBK/pwUzJE+SVIwLY3e3jY21hZNozfCy7Mdc4gknu1q0hsbrpjf2OaiHoWcXhj+6Q4mYADDa5B65dcMGANmON7EaeTTcwTk6I3eNz8scBNUarNtxZbkTFd3A4mbGjNFsHIN2h/GIySL44m60dEOD/AWnWt7lYPVxGEUqoX51dqsKsJHxoLeMxFor3Z67/t1kQZ9Cb+nvKHZcFFDNwYcav0rb4fiqq+9katn/zPiG7XLIAr59jhUe5TkiO4akChDldIm5MI6IUeFtejsQt0HPbSnB/Yg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 21:46:01 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 21:46:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH] mm/huge_memory.c: introduce split_unmapped_folio_to_order
Date: Thu, 13 Nov 2025 16:45:56 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <EB4C7FF1-8350-43FC-B879-20EA0E733F09@nvidia.com>
In-Reply-To: <20ad8b5c-1bb3-46bb-bc03-8e9222a7f7e1@nvidia.com>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <048134fd-6a3d-4a6c-a2eb-9a9911c3b35f@kernel.org>
 <efa37c4d-8c9f-4094-a713-4fd4452ae917@nvidia.com>
 <826df5b1-b61d-4794-a96c-dcf9ac19e269@kernel.org>
 <bf8e0c95-15a1-4eac-ba2e-52d361050039@nvidia.com>
 <20ad8b5c-1bb3-46bb-bc03-8e9222a7f7e1@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW6PR12MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a7130f5-efbb-43f3-4c03-08de22fe0977
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RytrUnJxMnFnMDM1S2VyMnV2aXNmZnQxNHFVNm1wQVgxZkluZk81YkwwbGJT?=
 =?utf-8?B?a0tqZDUzbDVyWkVOZUc3YUM1TjR0NEt2ZjBiRlpRaFZ4WDNEMlFPNXBhWEFM?=
 =?utf-8?B?MStBY3B1QldBWGFpVGdIU2RFaVhLaEdQUFlNMENzbFg4Z0FRQTJqeHcwc1dG?=
 =?utf-8?B?cERJVytqd3FUUHlDT3NEbDBzTG1iUThwYW04dThaRE9OVGxMSll1TGpZT1BC?=
 =?utf-8?B?UWRQeXJLbXNzV1FWTVZGby8vdGNaMitlNEVmbTJZTTNXNTZZNTlQeW9CUWYv?=
 =?utf-8?B?SFR4RzhQMG4ydTZYYnBxRkVxYXl4RVE5YkFneXJQdWFTaG0xNEVyK21wc3ls?=
 =?utf-8?B?WXloMXVlWWE5SlRrMU15bzZIblBUajcxT1ptNnJ0a1ZzaE5ucEJ6R1RvemxM?=
 =?utf-8?B?NUR2Q3llRXE3NEMzWE56MVFnamQ3KzZaNkI4bEEvRG5OMEFRYy95R0MrM29n?=
 =?utf-8?B?U2ZETmZmNThHcDdzRzRvUEhGU044Ry80VGVFUXc1cHNzcVlDZ2lUSnJlYzRw?=
 =?utf-8?B?VUVYMFRaRXlkN3ZZcjlpQ2tqZVdnS3FhZzdwUzgzbmhNTlE5NVRTWWY5VERU?=
 =?utf-8?B?d0U5bVNCSEJaZWl3NTVPbmYrWEQ0bXFibjJLejVzeGd1QUZvVFJyRUtyRjlJ?=
 =?utf-8?B?K3ZGNlZ5eXI3VGdFdnAzZkljTDdET1BlY0NJak5RZmx4S1NFbnd6RUYwZlFE?=
 =?utf-8?B?YXd3b280dnlTNnFBS1IxMFlIK1RqaTdLSFdMTW5tRFVoemkzaWJvSnhWV2RM?=
 =?utf-8?B?bDEyQXZGMlZpTjRMQ1dnZnlYaXliNGEvOXJodmpHM3JGQi9TZ1N1VmRlRGpZ?=
 =?utf-8?B?V3FnY3VhR1U1My8raWxYeWZFRXkvb05rV2ZDMnJiZTVqM3NqMmFTK2JmN3R4?=
 =?utf-8?B?T1pnUytjTVo5S1FUbk8wY3ExbFJYMmZzN2ZGa1VZNlhxT2dFVHhRNVhjSGw4?=
 =?utf-8?B?TklsQ0xCUnZGUi9JZnNXdVkweWdmVW9qbTVOdVFUQTViekpuVlZJdng0MzJo?=
 =?utf-8?B?bWNIdjBCVHh0cE93WUdlWWlYTzR3V0N4Tk1KV2dHN1hEREpIcy9UR0dGSXhG?=
 =?utf-8?B?SlI5ZjVoT1RiK2dnVUxXR29iT2xNQXBremVuZTFnL1FLSWNFSVVBdUlNQVlt?=
 =?utf-8?B?U3h6Z0J2UkJvQmthbVNlWjRxQ3BoRDZPNTZ6b0ZhTE5Vc0tzallMNDU5STRi?=
 =?utf-8?B?MDMwWTlsbm9SUnA3bFJMOUt0UjNzeWhSSzlIemNhbFdrbFA1QmhQWENNSW5T?=
 =?utf-8?B?WlBaR21IS3RxS3J0eEhlUjlsSmdERmhlRHZUcUpLVEtTTWowMWhMdVpKbVNv?=
 =?utf-8?B?Y2Z6NGJ1WGdJQW5KOHo4bGpOT283WkFlVTlRYkFmMlVTODlLaUNJY0NpNFVk?=
 =?utf-8?B?bWJFVW95dUxZQmxFK1A1TWNtMFpJZWtaUjV2SzloeitueFhPTEZIVngxeFla?=
 =?utf-8?B?bjFZODdveGNNRndORFNTOU5kSGFONm5zRTF0b3JHV00vWmxRQlQ1aEhoRnB0?=
 =?utf-8?B?eis3RGdITWR3Ti96dnAvVjJWd0ZVMWthQ0VsWndmWWlSVXpwUXlnSkM0UnNL?=
 =?utf-8?B?WlJ2c0MxRTFUZWVZdWlCVFM2TGdpRnAzTUl6aTdvaFhqejNYblVmMUdsOXhG?=
 =?utf-8?B?SWRvZTVaZEMzK0l1UHRHT01wSjBPdHdSazd0by9nY1NoRTl6UDJkRk1jN29B?=
 =?utf-8?B?V1c5Z0t4d205M2kxYXdyeHVNcUxDSy9ub3laSEdvQk9tQWdRSW9RczBocWV4?=
 =?utf-8?B?RVk2SGNWcWYyR2N5aUt2c0QwbUExUmNETFBYUzZrdkFHZ2swUnZaWXIyWkVE?=
 =?utf-8?B?RTRuRnNKVHdMU2lkcjBCRi9LM1UyamdWYmZYWUJ0cXRqWmpzRm04Z01hZnNr?=
 =?utf-8?B?OC9nL0xSL2I2cmV5Mkd2VktZbVlnaFFMOFExWDVmaU5JdzJVcENMMHEyYUpz?=
 =?utf-8?Q?dJWk1Ip/8ZroTnCvEkHddvvgLv/SVMPD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2t3US9MSVBob2dxQTNEeUY3eW1BVVB4akJ3Szh1ZmxrUXFSS0hVOHVIUjM4?=
 =?utf-8?B?dzRGQUY2MTFGVW1FaWk3ZU9zQ2NNendxMGxTOTlxSzA3YjVzZENQdlhRZmRk?=
 =?utf-8?B?YUdqSWpJZEVBUFE4R1dLczRIbzdYaGxvY2lCaDJyZHBWdzdUWFBidEM5Y21J?=
 =?utf-8?B?TSt0cVBQVkpxWVhjck1wZVhmUmg4T2NtdXFPL1JkbHdSMjVBbFc2T1dqVUZL?=
 =?utf-8?B?R25xWmN1bUVTc0xrVlRPbjFURVh2RVF4c2tlYWZqdzZ1b2x0MEszWVZWMVJG?=
 =?utf-8?B?eGcvVGFIRC9zejBmaEJaL2FCQkhGZ1VpUVpzNlRXU3ZvM29Zbk1YdHl0Mmc0?=
 =?utf-8?B?YmtXcVBnbmF5OXpoUVVmK2lqOXB4dzJaQXRTNkR1MTAvT2Q0dU1vdUhmcW1t?=
 =?utf-8?B?MzVpci9lWFRZRXBFYUl2TW1LVk1SWEpJRWU1UDJkclFyVFJLSkxCR0V2RXhn?=
 =?utf-8?B?WnI1bml1R2ZUc1Rkei8yUUpqbitDa3BSL2hEcGZUUUpON3diRHlvbzU1eVIv?=
 =?utf-8?B?d1I5QS81UkFLOEZRd2pvMWh6UEdPaUh2cnU5c0lZTHVKMkhPMWx6Ly9wTXJX?=
 =?utf-8?B?OXdhczBjaHBDbXRDRlZObGFCVEJXUjFXTk9YSmsxTDByYWl2Znl4YXgzMlEr?=
 =?utf-8?B?bWUyaDFnWTU1ZkhId2lVRStKRW9qOTZOWVl6K1I5aEJSbnBpamc1L1R5R1JW?=
 =?utf-8?B?MGhCMlNkbkc4bmNTRGlYVlJ4SWhjZ2FqVHJBWDkzTlhQK1llRXcxRitzQTcv?=
 =?utf-8?B?bmlDY2VGWkk3WWlGYm5IUHdhaTUwSGQxSHdreTZJVk9GMnR4UEJaU3lrV2Z3?=
 =?utf-8?B?bndrbFRSd2VEeDB6cmllNVFiMk1vVkRaYWNLVE41elM0TUl2L25iZkVtU1F3?=
 =?utf-8?B?aDZHdnVVbFNwVmVZQ2tvSmhqT1NYYVJ6bHUrcERtcVFhZnREcnlhUFMwNlpk?=
 =?utf-8?B?eGxpTkNzK01HS0owekxIK3BCU2d6NWpHbGVNM2RYZnExdVFXam9aa2VrbDZy?=
 =?utf-8?B?Y2wvSktkTGNiYmJ5aW9HK3VxeHlLYllLRC9JaU5mN1orTnZBdC84YU1GVVVv?=
 =?utf-8?B?cWtMV0lqS2JQbjB0OHIwL242STVENENKYUpkcVBmdlFGMXJEK1U4V3NQbG41?=
 =?utf-8?B?QmlaVnd2RGx6TklCbUV5eE1vd3JDai84dGlHb201b3h2cHN5WWdBTkJidElG?=
 =?utf-8?B?QVA4blFObzNVSzhrNkRMSGhVRTUrTzNlVmtYMFdCM3A3azhKMGk2enIvd0hN?=
 =?utf-8?B?S2VnT2gvS09sS0Z4VVBQYnFZcE05aGMxbEQ1TzB6UHZJcHY4SGtXeUlyQW53?=
 =?utf-8?B?Z09JSHhzSXZJOVM5ZjFhaVowUk01SkRZUHRjU1BraWhqdUMzYlhKUjFuTmVt?=
 =?utf-8?B?NVRkNEFDSTRBQm5ndjFidDc0OVFyWnorSnIvTVBJUzErdVltUTU3eHdtSmZP?=
 =?utf-8?B?dUlwSitaRlYzUENLNHk3MndXOGxsVVBVRWdxankxc3daMXE3bjYyNjBRamUr?=
 =?utf-8?B?R1crUXVGazFyQ1hwU043NmtWVmhqcTFHNFJTVkY4WUU4NjhvZjBMOTlZSHBy?=
 =?utf-8?B?bkppRE11clovaTFwUEIxTHRSRnZrNjVPQW5lcHUvTEZtWUIzTC8yU3FzU3pG?=
 =?utf-8?B?WFdudWZCanRqQVRFelU3MmlYR1RCS2VsRENNaW9VTEdZZUEzelhubzlSTkUr?=
 =?utf-8?B?cTNpdVNnRDJhNVMwYUx6Z0xWSUxMcWlBSzJrVHl5dnVKdk00Y0ErVisvTXVP?=
 =?utf-8?B?WXhPTDVVT3lNMXlOelZ6MTFZNXVCbUtNdkxmTW9vaUZwWStad1g5cnUrV08y?=
 =?utf-8?B?clN2RjVNR2VKVjM0SzZyeWRKMGZ4S3dqSTdIUTFkRTk0Rnowc3ExNzZFWXdX?=
 =?utf-8?B?UjBUN3dwaXE4SFpRNGxScG5oTUVMVmlzYmc3NGY2b3l1ckhkOUxiZFJXcm82?=
 =?utf-8?B?akYyZEpDYjIrdFVzbEE2Tmw3TUNhbm1pMlpveWlpTFJsVUY2bEE0WFBxdktQ?=
 =?utf-8?B?V1FreVprMXlIY3Z3dDFyOW11UStET24xa2ZmZEw0NUlOK3BMSkpaOTk3emZX?=
 =?utf-8?B?anR3aUVVUGJ5QzFxeE5OTVRBMmtsTkQ0TmRyUXdqWHFJcjRxK3VNUGdVNE1T?=
 =?utf-8?Q?w8EIk9TK3GkVbeXFjbUWS1V9S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7130f5-efbb-43f3-4c03-08de22fe0977
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 21:46:01.1930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAAw0P5XCvsJOgYOm1aLlj8zbliT5mL7l9Cr0qWBG28RdsJUh7HinLRyh9zSJD8z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7086
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9E2041A0009
X-Stat-Signature: r3yawpr7eeaog8kpdqpj6he6zzs91bk4
X-Rspam-User: 
X-HE-Tag: 1763070367-741588
X-HE-Meta: U2FsdGVkX1+5gtkSVw4F8uC30XAz5OBOUzpNr34zQfpGdSnvHFXDvXLF545CkuWPalCeA4DtkPaa9VS4M+g0a4lX/GtmSr0SR3JHTF7l/FKsYYR4py6W4VgEQfOYnmIoz5nifRj+4rcliI7MiYWKOqBhAkfMJsYswtau6z1wTswaZHZ3tSrJlWERAMdQxxnYNbEsMAlLeFKmpMUrOmB/PEBSwnylB7h9N0ZL+oabEiLV7MZ0kyCQfvQLfkSZLQGYiBGQmU3f0t8ythb8Fbq0s80lpzyYgsBy9ek12K/jbvkw/PBmU1WR3EtXoK64mEIjZfHbP3uLmko/w98VWGUxstdmtJdS5gYgmcVv+L3NKmLzeocUsjBkdxOZR5oigA40F9lRaJQP+ne8eqFd8aMcjnwzOA9tE+Le8jN2vBw45zFQAdLvGb7AX9WYVeKaRsuo3gqNrx1RprPAFCRVaYYvEvk0whK/qvdqsjBLIUyuV/Ec/fZz2r9RHeYeL0UoDZ1nCSADPoihkuGF7SgoIXRHa6O6PUPHhdG3iMzRJSTHA0yRLIxskVQUCqqamRCtO+jQJI0qrCAEZHmgdcb3K9owGlsLGOGzxKEfdE1E4I8VfMOnRPWxrtN4kqY84iMIrcH/K42IXXIAYEzJZ6ce6Y/Ej5uA+3Oe3ZTRnL8HCkHPKI56cCE7HsjCImQhiy8oDxM2p+2OVpc2zwXogZg4OawiaB4QDCNr5Im5d5iaBPjrhyAiYhODIwEF4cYzr8FtmUhBbdC8VarSeLIUnrN8bs9JqLwh48HVV0rgxotBONG2fRrk+ibT56YXH5b/p/NsgDXXq7y6EZR58W1FV6g+2pL7vQkC+DVWuOyQwIKlsFvCpAE2qgYNCR9d5tkI7WTFo0oDcUm3RL3xM2Q99WxICarVEsRagScdTa0410WajRlmXF6DkWJnav8L5U2nn0xje0c7MkcyvIhkbYE9G+gj/zH
 WbK7n4DA
 Gc1eKJMbT7Rosur973VO8i4jkcjjBVh3ydQ6e52km7KDZvcW5bM/L4uwwBsInIVI95SxWKJWYqLybwiRBn3ts+jHVta9Ix8/kFU7rilPPeANbWK+qYEXAlhL1FEgrHPsV089+f0gUCXFqbNkU6fVAKlXQQlTCrKNRIWWP5gf9V4Z0HLMlkuySs8jY7J6Nnhz34v5eafMTYpi4OGVhhsOaRVsY6iVzHswizg7PZPjdtf4Ov1fi7zMdDfY4+CDNSbLou/iQQ12+CKGi/miU0lcu7bXPKhLwGtT32tpgcu/q5ai6A7VsSstym89mLQXdUtyT7dxzeaiSvZ9zP/b1km4afqr22DaS2SxDpyzPSxg+tnqmhiujeXZ6xxAu9ILVWkJI5Bta3E5cHFmjr/MXUDkBHku0lHTejS88C7YGjJ/yY+QgSyr4nJ5jisR04HLsJyZ5kJbyAdQzDu1embyDP/hwbsCYuUs0Lg9HCyHzn0naDNNN703+p0hhr7olc/ekVBNntzzZL8oUsoifPmIy16hPLi2z1M5N5aQIdiDkknDB+QX3iaG76pOfg6Hg4ans3M2rWF/oq53u6lsq0Jp1UN+dCPuKqe+n1i0kfwVHbaOo5sxWAtylOhjvDIhXM3UpQjW5gMiIf17cnPISMbHhRG0kkfufYh/rPJ1p6klAgGt6UusctXwb32Xgsyu/p66FZ76xdqTjQwFnYvhAwubqZdNP54OmXzuCZRAVq17tAJa8pZWTPJdJ09r3Go6fS9dchQJwKcNc9lIxM6ukIxwicIxbQZSwAYZ72dmlbR6sP0gyoo9zG9GzrHVDN+O35nQRO0/tU1388jJWIMQPO+0uLBBXFRlucnQ0zMgkNSc2m4quUjsrdtsinacaCL32ZBKQaSUWWAbrexGfB5djJrU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Nov 2025, at 16:39, Balbir Singh wrote:

> On 11/13/25 10:49, Balbir Singh wrote:
>> On 11/12/25 22:34, David Hildenbrand (Red Hat) wrote:
>>> On 12.11.25 11:17, Balbir Singh wrote:
>>>> On 11/12/25 21:00, David Hildenbrand (Red Hat) wrote:
>>>>> On 12.11.25 05:46, Balbir Singh wrote:
>>>>>> Unmapped was added as a parameter to __folio_split() and related
>>>>>> call sites to support splitting of folios already in the midst
>>>>>> of a migration. This special case arose for device private folio
>>>>>> migration since during migration there could be a disconnect between
>>>>>> source and destination on the folio size.
>>>>>>
>>>>>> Introduce split_unmapped_folio_to_order() to handle this special cas=
e.
>>>>>> This in turn removes the special casing introduced by the unmapped
>>>>>> parameter in __folio_split().
>>>>>
>>>>> As raised recently, I would hope that we can find a way to make all t=
hese splitting functions look more similar in the long term, ideally starti=
ng with "folio_split" / "folio_try_split".
>>>>>
>>>>> What about
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0folio_split_unmapped()
>>>>>
>>>>> Do we really have to spell out the "to order" part in the function na=
me?
>>>>>
>>>>> And if it's more a mostly-internal helper, maybe
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__folio_split_unmapped()
>>>>>
>>>>> subject: "mm/huge_memory: introduce ..."
>>>>>
>>>>
>>>> I can rename it, but currently it confirms to the split_folio with ord=
er in the name
>>>> The order is there in the name because in the future with mTHP we will=
 want to
>>>> support splitting to various orders.
>>>
>>> I think we should start naming them more consistently regarding folio_s=
plit() immediately and cleanup the other ones later.
>>>
>>> I don't understand why "_to_order" must be in the name right now. You c=
an add another variant and start using longer names when really required.
>>>
>>
>> Ack
>>
>>>>
>>>>
>>>>>>
>>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>>>> Cc: Gregory Price <gourry@gourry.net>
>>>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>>>> Cc: Nico Pache <npache@redhat.com>
>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>
>>>>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>> ---
>>>>>> =C2=A0=C2=A0 include/linux/huge_mm.h |=C2=A0=C2=A0 5 +-
>>>>>> =C2=A0=C2=A0 mm/huge_memory.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 135 ++++++++++++++++++++++++++++++++++------
>>>>>> =C2=A0=C2=A0 mm/migrate_device.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 3 +-
>>>>>> =C2=A0=C2=A0 3 files changed, 120 insertions(+), 23 deletions(-)
>>>>>>
>>>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>>>> index e2e91aa1a042..9155e683c08a 100644
>>>>>> --- a/include/linux/huge_mm.h
>>>>>> +++ b/include/linux/huge_mm.h
>>>>>> @@ -371,7 +371,8 @@ enum split_type {
>>>>>> =C2=A0=C2=A0 =C2=A0 bool can_split_folio(struct folio *folio, int ca=
ller_pins, int *pextra_pins);
>>>>>> =C2=A0=C2=A0 int __split_huge_page_to_list_to_order(struct page *pag=
e, struct list_head *list,
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int new_order, =
bool unmapped);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int new_order);
>>>>>> +int split_unmapped_folio_to_order(struct folio *folio, unsigned int=
 new_order);
>>>>>> =C2=A0=C2=A0 int min_order_for_split(struct folio *folio);
>>>>>> =C2=A0=C2=A0 int split_folio_to_list(struct folio *folio, struct lis=
t_head *list);
>>>>>> =C2=A0=C2=A0 bool folio_split_supported(struct folio *folio, unsigne=
d int new_order,
>>>>>> @@ -382,7 +383,7 @@ int folio_split(struct folio *folio, unsigned in=
t new_order, struct page *page,
>>>>>> =C2=A0=C2=A0 static inline int split_huge_page_to_list_to_order(stru=
ct page *page, struct list_head *list,
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigne=
d int new_order)
>>>>>> =C2=A0=C2=A0 {
>>>>>> -=C2=A0=C2=A0=C2=A0 return __split_huge_page_to_list_to_order(page, =
list, new_order, false);
>>>>>> +=C2=A0=C2=A0=C2=A0 return __split_huge_page_to_list_to_order(page, =
list, new_order);
>>>>>> =C2=A0=C2=A0 }
>>>>>> =C2=A0=C2=A0 static inline int split_huge_page_to_order(struct page =
*page, unsigned int new_order)
>>>>>> =C2=A0=C2=A0 {
>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>> index 0184cd915f44..942bd8410c54 100644
>>>>>> --- a/mm/huge_memory.c
>>>>>> +++ b/mm/huge_memory.c
>>>>>> @@ -3747,7 +3747,6 @@ bool folio_split_supported(struct folio *folio=
, unsigned int new_order,
>>>>>> =C2=A0=C2=A0=C2=A0 * @lock_at: a page within @folio to be left locke=
d to caller
>>>>>> =C2=A0=C2=A0=C2=A0 * @list: after-split folios will be put on it if =
non NULL
>>>>>> =C2=A0=C2=A0=C2=A0 * @split_type: perform uniform split or not (non-=
uniform split)
>>>>>> - * @unmapped: The pages are already unmapped, they are migration en=
tries.
>>>>>> =C2=A0=C2=A0=C2=A0 *
>>>>>> =C2=A0=C2=A0=C2=A0 * It calls __split_unmapped_folio() to perform un=
iform and non-uniform split.
>>>>>> =C2=A0=C2=A0=C2=A0 * It is in charge of checking whether the split i=
s supported or not and
>>>>>> @@ -3763,7 +3762,7 @@ bool folio_split_supported(struct folio *folio=
, unsigned int new_order,
>>>>>> =C2=A0=C2=A0=C2=A0 */
>>>>>> =C2=A0=C2=A0 static int __folio_split(struct folio *folio, unsigned =
int new_order,
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct =
page *split_at, struct page *lock_at,
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head *list, =
enum split_type split_type, bool unmapped)
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head *list, =
enum split_type split_type)
>>>>>
>>>>> Yeah, nice to see that go.
>>>>>
>>>>>> =C2=A0=C2=A0 {
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct deferred_split *ds_queue=
;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 XA_STATE(xas, &folio->mapping->=
i_pages, folio->index);
>>>>>> @@ -3809,14 +3808,12 @@ static int __folio_split(struct folio *folio=
, unsigned int new_order,
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=
 is taken to serialise against parallel split or collapse
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=
 operations.
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=
/
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!unmapped) {
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
anon_vma =3D folio_get_anon_vma(folio);
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (!anon_vma) {
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EBUSY;
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
}
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
anon_vma_lock_write(anon_vma);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 anon_vma =3D folio_get_a=
non_vma(folio);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!anon_vma) {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
ret =3D -EBUSY;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
goto out;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 anon_vma_lock_write(anon=
_vma);
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mapping=
 =3D NULL;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigne=
d int min_order;
>>>>>> @@ -3882,8 +3879,7 @@ static int __folio_split(struct folio *folio, =
unsigned int new_order,
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto ou=
t_unlock;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>> =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0 if (!unmapped)
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unmap_folio(folio);
>>>>>> +=C2=A0=C2=A0=C2=A0 unmap_folio(folio);
>>>>>> =C2=A0=C2=A0
>>>>>
>>>>> Hm, I would have hoped that we could factor out the core logic and re=
use it for the new helper, instead of duplicating code.
>>>>>
>>>>> Did you look into that?
>>>>>
>>>>>
>>>>
>>>> I did, I ended up with larger spaghetti, I was hoping to look it as a =
follow up
>>>> after the series with the mTHP changes and support (that is to be desi=
gned and
>>>> prototyped).
>>>
>>> Looking at it in more detail, the code duplication is not desired.
>>>
>>> We have to find a way to factor the existing code out and reuse it from=
 any new function.
>>>
>>
>> I came up with a helper, but that ends up with another boolean do_lru.
>>
>>
>
> Zi, David, any opinions on the approach below?

Looks good to me. We might want a better name instead of
__folio_split_unmapped(). Or __split_unmapped_folio() should
be renamed, since these two function names are too similar.

Maybe __folio_split_unmapped() -> __freeze_and_split_unmapped_folio().

Feel free to come up with a better name. :)

>
>> ---
>>  include/linux/huge_mm.h |   5 +-
>>  mm/huge_memory.c        | 336 +++++++++++++++++++++++-----------------
>>  mm/migrate_device.c     |   3 +-
>>  3 files changed, 195 insertions(+), 149 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index e2e91aa1a042..44c09755bada 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -371,7 +371,8 @@ enum split_type {
>>
>>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_=
pins);
>>  int __split_huge_page_to_list_to_order(struct page *page, struct list_h=
ead *list,
>> -		unsigned int new_order, bool unmapped);
>> +		unsigned int new_order);
>> +int split_unmapped_folio(struct folio *folio, unsigned int new_order);
>>  int min_order_for_split(struct folio *folio);
>>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>>  bool folio_split_supported(struct folio *folio, unsigned int new_order,
>> @@ -382,7 +383,7 @@ int folio_split(struct folio *folio, unsigned int ne=
w_order, struct page *page,
>>  static inline int split_huge_page_to_list_to_order(struct page *page, s=
truct list_head *list,
>>  		unsigned int new_order)
>>  {
>> -	return __split_huge_page_to_list_to_order(page, list, new_order, false=
);
>> +	return __split_huge_page_to_list_to_order(page, list, new_order);
>>  }
>>  static inline int split_huge_page_to_order(struct page *page, unsigned =
int new_order)
>>  {
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 0184cd915f44..534befe1b7aa 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3739,6 +3739,152 @@ bool folio_split_supported(struct folio *folio, =
unsigned int new_order,
>>  	return true;
>>  }
>>
>> +static int __folio_split_unmapped(struct folio *folio, unsigned int new=
_order,
>> +				  struct page *split_at, struct xa_state *xas,
>> +				  struct address_space *mapping, bool do_lru,
>> +				  struct list_head *list, enum split_type split_type,
>> +				  int extra_pins)
>> +{
>> +	struct folio *end_folio =3D folio_next(folio);
>> +	struct folio *new_folio, *next;
>> +	int old_order =3D folio_order(folio);
>> +	int nr_shmem_dropped =3D 0;
>> +	int ret =3D 0;
>> +	pgoff_t end =3D 0;
>> +	struct deferred_split *ds_queue;
>> +
>> +	/* Prevent deferred_split_scan() touching ->_refcount */
>> +	ds_queue =3D folio_split_queue_lock(folio);
>> +	if (folio_ref_freeze(folio, 1 + extra_pins)) {
>> +		struct swap_cluster_info *ci =3D NULL;
>> +		struct lruvec *lruvec;
>> +		int expected_refs;
>> +
>> +		if (old_order > 1) {
>> +			if (!list_empty(&folio->_deferred_list)) {
>> +				ds_queue->split_queue_len--;
>> +				/*
>> +				 * Reinitialize page_deferred_list after removing the
>> +				 * page from the split_queue, otherwise a subsequent
>> +				 * split will see list corruption when checking the
>> +				 * page_deferred_list.
>> +				 */
>> +				list_del_init(&folio->_deferred_list);
>> +			}
>> +			if (folio_test_partially_mapped(folio)) {
>> +				folio_clear_partially_mapped(folio);
>> +				mod_mthp_stat(old_order,
>> +					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>> +			}
>> +		}
>> +		split_queue_unlock(ds_queue);
>> +		if (mapping) {
>> +			int nr =3D folio_nr_pages(folio);
>> +
>> +			if (folio_test_pmd_mappable(folio) &&
>> +			    new_order < HPAGE_PMD_ORDER) {
>> +				if (folio_test_swapbacked(folio)) {
>> +					__lruvec_stat_mod_folio(folio,
>> +							NR_SHMEM_THPS, -nr);
>> +				} else {
>> +					__lruvec_stat_mod_folio(folio,
>> +							NR_FILE_THPS, -nr);
>> +					filemap_nr_thps_dec(mapping);
>> +				}
>> +			}
>> +		}
>> +
>> +		if (folio_test_swapcache(folio)) {
>> +			if (mapping) {
>> +				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
>> +				return -EINVAL;
>> +			}
>> +
>> +			ci =3D swap_cluster_get_and_lock(folio);
>> +		}
>> +
>> +		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
>> +		if (do_lru)
>> +			lruvec =3D folio_lruvec_lock(folio);
>> +
>> +		ret =3D __split_unmapped_folio(folio, new_order, split_at, xas,
>> +					     mapping, split_type);
>> +
>> +		/*
>> +		 * Unfreeze after-split folios and put them back to the right
>> +		 * list. @folio should be kept frozon until page cache
>> +		 * entries are updated with all the other after-split folios
>> +		 * to prevent others seeing stale page cache entries.
>> +		 * As a result, new_folio starts from the next folio of
>> +		 * @folio.
>> +		 */
>> +		for (new_folio =3D folio_next(folio); new_folio !=3D end_folio;
>> +		     new_folio =3D next) {
>> +			unsigned long nr_pages =3D folio_nr_pages(new_folio);
>> +
>> +			next =3D folio_next(new_folio);
>> +
>> +			zone_device_private_split_cb(folio, new_folio);
>> +
>> +			expected_refs =3D folio_expected_ref_count(new_folio) + 1;
>> +			folio_ref_unfreeze(new_folio, expected_refs);
>> +
>> +			if (do_lru)
>> +				lru_add_split_folio(folio, new_folio, lruvec, list);
>> +
>> +			/*
>> +			 * Anonymous folio with swap cache.
>> +			 * NOTE: shmem in swap cache is not supported yet.
>> +			 */
>> +			if (ci) {
>> +				__swap_cache_replace_folio(ci, folio, new_folio);
>> +				continue;
>> +			}
>> +
>> +			/* Anonymous folio without swap cache */
>> +			if (!mapping)
>> +				continue;
>> +
>> +			/* Add the new folio to the page cache. */
>> +			if (new_folio->index < end) {
>> +				__xa_store(&mapping->i_pages, new_folio->index,
>> +					   new_folio, 0);
>> +				continue;
>> +			}
>> +
>> +			/* Drop folio beyond EOF: ->index >=3D end */
>> +			if (shmem_mapping(mapping))
>> +				nr_shmem_dropped +=3D nr_pages;
>> +			else if (folio_test_clear_dirty(new_folio))
>> +				folio_account_cleaned(
>> +					new_folio, inode_to_wb(mapping->host));
>> +			__filemap_remove_folio(new_folio, NULL);
>> +			folio_put_refs(new_folio, nr_pages);
>> +		}
>> +
>> +		zone_device_private_split_cb(folio, NULL);
>> +		/*
>> +		 * Unfreeze @folio only after all page cache entries, which
>> +		 * used to point to it, have been updated with new folios.
>> +		 * Otherwise, a parallel folio_try_get() can grab @folio
>> +		 * and its caller can see stale page cache entries.
>> +		 */
>> +		expected_refs =3D folio_expected_ref_count(folio) + 1;
>> +		folio_ref_unfreeze(folio, expected_refs);
>> +
>> +		if (do_lru)
>> +			unlock_page_lruvec(lruvec);
>> +
>> +		if (ci)
>> +			swap_cluster_unlock(ci);
>> +	} else {
>> +		split_queue_unlock(ds_queue);
>> +		return -EAGAIN;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  /**
>>   * __folio_split() - split a folio at @split_at to a @new_order folio
>>   * @folio: folio to split
>> @@ -3747,7 +3893,6 @@ bool folio_split_supported(struct folio *folio, un=
signed int new_order,
>>   * @lock_at: a page within @folio to be left locked to caller
>>   * @list: after-split folios will be put on it if non NULL
>>   * @split_type: perform uniform split or not (non-uniform split)
>> - * @unmapped: The pages are already unmapped, they are migration entrie=
s.
>>   *
>>   * It calls __split_unmapped_folio() to perform uniform and non-uniform=
 split.
>>   * It is in charge of checking whether the split is supported or not an=
d
>> @@ -3763,9 +3908,8 @@ bool folio_split_supported(struct folio *folio, un=
signed int new_order,
>>   */
>>  static int __folio_split(struct folio *folio, unsigned int new_order,
>>  		struct page *split_at, struct page *lock_at,
>> -		struct list_head *list, enum split_type split_type, bool unmapped)
>> +		struct list_head *list, enum split_type split_type)
>>  {
>> -	struct deferred_split *ds_queue;
>>  	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>>  	struct folio *end_folio =3D folio_next(folio);
>>  	bool is_anon =3D folio_test_anon(folio);
>> @@ -3809,14 +3953,12 @@ static int __folio_split(struct folio *folio, un=
signed int new_order,
>>  		 * is taken to serialise against parallel split or collapse
>>  		 * operations.
>>  		 */
>> -		if (!unmapped) {
>> -			anon_vma =3D folio_get_anon_vma(folio);
>> -			if (!anon_vma) {
>> -				ret =3D -EBUSY;
>> -				goto out;
>> -			}
>> -			anon_vma_lock_write(anon_vma);
>> +		anon_vma =3D folio_get_anon_vma(folio);
>> +		if (!anon_vma) {
>> +			ret =3D -EBUSY;
>> +			goto out;
>>  		}
>> +		anon_vma_lock_write(anon_vma);
>>  		mapping =3D NULL;
>>  	} else {
>>  		unsigned int min_order;
>> @@ -3882,8 +4024,7 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
>>  		goto out_unlock;
>>  	}
>>
>> -	if (!unmapped)
>> -		unmap_folio(folio);
>> +	unmap_folio(folio);
>>
>>  	/* block interrupt reentry in xa_lock and spinlock */
>>  	local_irq_disable();
>> @@ -3900,142 +4041,14 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
>>  		}
>>  	}
>>
>> -	/* Prevent deferred_split_scan() touching ->_refcount */
>> -	ds_queue =3D folio_split_queue_lock(folio);
>> -	if (folio_ref_freeze(folio, 1 + extra_pins)) {
>> -		struct swap_cluster_info *ci =3D NULL;
>> -		struct lruvec *lruvec;
>> -		int expected_refs;
>> -
>> -		if (old_order > 1) {
>> -			if (!list_empty(&folio->_deferred_list)) {
>> -				ds_queue->split_queue_len--;
>> -				/*
>> -				 * Reinitialize page_deferred_list after removing the
>> -				 * page from the split_queue, otherwise a subsequent
>> -				 * split will see list corruption when checking the
>> -				 * page_deferred_list.
>> -				 */
>> -				list_del_init(&folio->_deferred_list);
>> -			}
>> -			if (folio_test_partially_mapped(folio)) {
>> -				folio_clear_partially_mapped(folio);
>> -				mod_mthp_stat(old_order,
>> -					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>> -			}
>> -		}
>> -		split_queue_unlock(ds_queue);
>> -		if (mapping) {
>> -			int nr =3D folio_nr_pages(folio);
>> -
>> -			if (folio_test_pmd_mappable(folio) &&
>> -			    new_order < HPAGE_PMD_ORDER) {
>> -				if (folio_test_swapbacked(folio)) {
>> -					__lruvec_stat_mod_folio(folio,
>> -							NR_SHMEM_THPS, -nr);
>> -				} else {
>> -					__lruvec_stat_mod_folio(folio,
>> -							NR_FILE_THPS, -nr);
>> -					filemap_nr_thps_dec(mapping);
>> -				}
>> -			}
>> -		}
>> -
>> -		if (folio_test_swapcache(folio)) {
>> -			if (mapping) {
>> -				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
>> -				ret =3D -EINVAL;
>> -				goto fail;
>> -			}
>> -
>> -			ci =3D swap_cluster_get_and_lock(folio);
>> -		}
>> -
>> -		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
>> -		lruvec =3D folio_lruvec_lock(folio);
>> -
>> -		ret =3D __split_unmapped_folio(folio, new_order, split_at, &xas,
>> -					     mapping, split_type);
>> -
>> -		/*
>> -		 * Unfreeze after-split folios and put them back to the right
>> -		 * list. @folio should be kept frozon until page cache
>> -		 * entries are updated with all the other after-split folios
>> -		 * to prevent others seeing stale page cache entries.
>> -		 * As a result, new_folio starts from the next folio of
>> -		 * @folio.
>> -		 */
>> -		for (new_folio =3D folio_next(folio); new_folio !=3D end_folio;
>> -		     new_folio =3D next) {
>> -			unsigned long nr_pages =3D folio_nr_pages(new_folio);
>> -
>> -			next =3D folio_next(new_folio);
>> -
>> -			zone_device_private_split_cb(folio, new_folio);
>> -
>> -			expected_refs =3D folio_expected_ref_count(new_folio) + 1;
>> -			folio_ref_unfreeze(new_folio, expected_refs);
>> -
>> -			if (!unmapped)
>> -				lru_add_split_folio(folio, new_folio, lruvec, list);
>> -
>> -			/*
>> -			 * Anonymous folio with swap cache.
>> -			 * NOTE: shmem in swap cache is not supported yet.
>> -			 */
>> -			if (ci) {
>> -				__swap_cache_replace_folio(ci, folio, new_folio);
>> -				continue;
>> -			}
>> -
>> -			/* Anonymous folio without swap cache */
>> -			if (!mapping)
>> -				continue;
>> -
>> -			/* Add the new folio to the page cache. */
>> -			if (new_folio->index < end) {
>> -				__xa_store(&mapping->i_pages, new_folio->index,
>> -					   new_folio, 0);
>> -				continue;
>> -			}
>> -
>> -			/* Drop folio beyond EOF: ->index >=3D end */
>> -			if (shmem_mapping(mapping))
>> -				nr_shmem_dropped +=3D nr_pages;
>> -			else if (folio_test_clear_dirty(new_folio))
>> -				folio_account_cleaned(
>> -					new_folio, inode_to_wb(mapping->host));
>> -			__filemap_remove_folio(new_folio, NULL);
>> -			folio_put_refs(new_folio, nr_pages);
>> -		}
>> -
>> -		zone_device_private_split_cb(folio, NULL);
>> -		/*
>> -		 * Unfreeze @folio only after all page cache entries, which
>> -		 * used to point to it, have been updated with new folios.
>> -		 * Otherwise, a parallel folio_try_get() can grab @folio
>> -		 * and its caller can see stale page cache entries.
>> -		 */
>> -		expected_refs =3D folio_expected_ref_count(folio) + 1;
>> -		folio_ref_unfreeze(folio, expected_refs);
>> -
>> -		unlock_page_lruvec(lruvec);
>> -
>> -		if (ci)
>> -			swap_cluster_unlock(ci);
>> -	} else {
>> -		split_queue_unlock(ds_queue);
>> -		ret =3D -EAGAIN;
>> -	}
>> +	ret =3D __folio_split_unmapped(folio, new_order, split_at, &xas, mappi=
ng,
>> +				     true, list, split_type, extra_pins);
>>  fail:
>>  	if (mapping)
>>  		xas_unlock(&xas);
>>
>>  	local_irq_enable();
>>
>> -	if (unmapped)
>> -		return ret;
>> -
>>  	if (nr_shmem_dropped)
>>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>>
>> @@ -4079,6 +4092,39 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>>  	return ret;
>>  }
>>
>> +/*
>> + * This function is a helper for splitting folios that have already bee=
n unmapped.
>> + * The use case is that the device or the CPU can refuse to migrate THP=
 pages in
>> + * the middle of migration, due to allocation issues on either side
>> + *
>> + * The high level code is copied from __folio_split, since the pages ar=
e anonymous
>> + * and are already isolated from the LRU, the code has been simplified =
to not
>> + * burden __folio_split with unmapped sprinkled into the code.
>> + *
>> + * None of the split folios are unlocked
>> + */
>> +int split_unmapped_folio(struct folio *folio, unsigned int new_order)
>> +{
>> +	int extra_pins, ret =3D 0;
>> +
>> +	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);
>> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>> +
>> +	if (!can_split_folio(folio, 1, &extra_pins)) {
>> +		ret =3D -EAGAIN;
>> +		return ret;
>> +	}
>> +
>> +
>> +	local_irq_disable();
>> +	ret =3D __folio_split_unmapped(folio, new_order, &folio->page, NULL,
>> +				     NULL, false, NULL, SPLIT_TYPE_UNIFORM,
>> +				     extra_pins);
>> +	local_irq_enable();
>> +	return ret;
>> +}
>> +
>>  /*
>>   * This function splits a large folio into smaller folios of order @new=
_order.
>>   * @page can point to any page of the large folio to split. The split o=
peration
>> @@ -4127,12 +4173,12 @@ static int __folio_split(struct folio *folio, un=
signed int new_order,
>>   * with the folio. Splitting to order 0 is compatible with all folios.
>>   */
>>  int __split_huge_page_to_list_to_order(struct page *page, struct list_h=
ead *list,
>> -				     unsigned int new_order, bool unmapped)
>> +				     unsigned int new_order)
>>  {
>>  	struct folio *folio =3D page_folio(page);
>>
>>  	return __folio_split(folio, new_order, &folio->page, page, list,
>> -			     SPLIT_TYPE_UNIFORM, unmapped);
>> +			     SPLIT_TYPE_UNIFORM);
>>  }
>>
>>  /**
>> @@ -4163,7 +4209,7 @@ int folio_split(struct folio *folio, unsigned int =
new_order,
>>  		struct page *split_at, struct list_head *list)
>>  {
>>  	return __folio_split(folio, new_order, split_at, &folio->page, list,
>> -			     SPLIT_TYPE_NON_UNIFORM, false);
>> +			     SPLIT_TYPE_NON_UNIFORM);
>>  }
>>
>>  int min_order_for_split(struct folio *folio)
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index c50abbd32f21..23b7bd56177c 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -918,8 +918,7 @@ static int migrate_vma_split_unmapped_folio(struct m=
igrate_vma *migrate,
>>
>>  	folio_get(folio);
>>  	split_huge_pmd_address(migrate->vma, addr, true);
>> -	ret =3D __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL,
>> -							0, true);
>> +	ret =3D split_unmapped_folio(folio, 0);
>>  	if (ret)
>>  		return ret;
>>  	migrate->src[idx] &=3D ~MIGRATE_PFN_COMPOUND;
>
>
> Thanks,
> Balbir


Best Regards,
Yan, Zi

