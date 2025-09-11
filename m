Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E944CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 16:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8E86B000E; Thu, 11 Sep 2025 12:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991158E0007; Thu, 11 Sep 2025 12:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F288E0001; Thu, 11 Sep 2025 12:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73D966B000E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:28:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 178C011894B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:28:33 +0000 (UTC)
X-FDA: 83877502506.25.7BCC7D9
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4A6D212000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:28:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aUT08oIM;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757608110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fibrqaiQx8BpCfrN7ILEYptRWDkQ6tRLqjI4ub/bgmc=;
	b=zel4FQGsWWOdQhmglhe4jm2gfpgBwGn2NtjbW8TmsbsU/eyaXwtjizSnmFmvJ4qpzfmq10
	F3sRtBFwxwlapNUivvJDxljS1s72bRs9Q/FTuyTEP2x8xA20kdV7voaNTGWLD0AND13Ic2
	9tRWxsXnatnLzKMrD6CvHQGiYI7oveo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757608110; a=rsa-sha256;
	cv=pass;
	b=OsPVvF/sHzaIj5t5Hgbc4p3c4C2wG1ZexLx0F1NPB18Uf6imnTTCGy2ZBHPI/cyV0jPwKc
	1Ikvfx67vTOvXpOL9bgJOpTQ/Qdss1eQVj7xl5iexIXvkjPmeFBUPrR1v4lUUyQ2z20wVZ
	sJxD6m/14/ZB/a+xW9KeLXKyTtMuglo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aUT08oIM;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LWvsq2iZIbxNjc7lVykCSM/MT7x2wUik0cmuNFCfUZGTajo6UwsVvp6z83uaHZqSfgvpp8tFtsXhaiDMz7TlaZ02DtHtXEk3SMzj902FbzU/sceeyXoQomJeVJVhMODdygavoj337AQKPkORsv/ejE7ay4DQOA2Vj75CCz3lppNH9Tf3MQcS+dQSsGhSv7iW6uXhnozPjyj9M2mcUWl8ZDkdvZzwh/Th413XfEa0namGYEzJCX4BD4EiWWKPDoQli5bVn28dzDeZM04GEBZBOBLFZlkb6e9PNAoc4vGNEZSwoooyom01GTq30dPabC/L7ftQqlTBswEkU9kp/7AkWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fibrqaiQx8BpCfrN7ILEYptRWDkQ6tRLqjI4ub/bgmc=;
 b=QgoM/B2rNw2pfjFkdhK+lWx5PRb+K7z+iMZFBJyG4UnnzvuxuZh4cXOdgi+z7vk7Qiy2dCq6ssKuVh1jzlhIn7zwsOo6OQFCmHJN1y0ACXhC1A6seJU7Pg1k6Jl53BEEjF7VQSmU9GKWQwux4fV0k3jN6ZOiEU9rbD+7SgVSsPu/tiMfnq7jcoONuwxTPRhW3qFybR1Gw4iyj9gXQT19TfXE1YSPGSxGRybA2XzPqPNJF22PQPxS3b+sBPYGEsavp8+S+xCO605S7g5SOxnsfpEtmZBulM+sVfTUzfWC/VGHKoQabDq5Zu8JvbEu0t3x8u26913l2L5rA1I1zoqzjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fibrqaiQx8BpCfrN7ILEYptRWDkQ6tRLqjI4ub/bgmc=;
 b=aUT08oIMtkL5tKqUi6+NSY/KTyCyoaDII2damiO4LT8K8MDe9hxeXAZ/YboaAXF0PlmuhIdq5VyZD4QArhiug37AssUtDlI21JC3TVBg/ypNnHzcB7c4SWFDlE+bjB1xJbaTOJxFZkkDgO67ixQZc+NdVHB/JXZX94ZfrV1FJC4jrBXLp9RXjDg68iHuS6Pm84rrHjnF17WTbXnI6Xj92/B0Hg2QnQPbgWr1T00fpPIocv3MpvYwF3mgeBc8FnBJQWnh/pYFcXHCR46d2PSwEHaXAiBPmqdmJv9Zkt4sq7cj06kp5Y0z7ADUSSoc+A522Ck+j7obrBIt1wOW3dYXqA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV3PR12MB9093.namprd12.prod.outlook.com (2603:10b6:408:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:28:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 16:28:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Date: Thu, 11 Sep 2025 12:28:24 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <EBA618FC-889E-48A1-AC02-9A18F6B5943E@nvidia.com>
In-Reply-To: <20250911063034.uafc5mmnf7k4d7km@master>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <EBF646E5-8A7D-4115-808D-E13033240659@nvidia.com>
 <2A28BE8E-E62D-4ED2-8A35-759BFAE4C52C@nvidia.com>
 <20250911033413.qcs74q4n6n6767zj@master>
 <20250911063034.uafc5mmnf7k4d7km@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0806.namprd03.prod.outlook.com
 (2603:10b6:408:13f::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV3PR12MB9093:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e4f87ae-1f4d-4979-53b8-08ddf1503c02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUsrcEYwL2VHTXg3bzh0QUdKYUY1MHRVQUhLZFhpR2tnRC9hSlNFVHY0YWdZ?=
 =?utf-8?B?ZGFDempiM3hyUXVmMkxubzJxWjZRNDNoM2w4Z05pa1l5VXQrL0svV1ZXMGMz?=
 =?utf-8?B?bklYeTlLRk9uWENVRTZJcHFUQnlTWjJmd1BteGdOR0VvYjFCc2Z6SEhhUWZl?=
 =?utf-8?B?eHE0Yy9UTFlhQ09QMkNiR0hKWTNhVTRoVENQS1FlMTVPaVhQRm1VSHN3MDVL?=
 =?utf-8?B?R0pHb3hNM3RzaFQ1ak9JOFdRcjBTUkNnOXRuN2FvL1luUmVmcUd2WHhMaDlQ?=
 =?utf-8?B?ZUFFdG1oYjVYamw5M1hrb2RMRkJpNGxrVmZWY3lBVWhLeFBUV1EzVHNSTDh2?=
 =?utf-8?B?L1FVQTdDalIzVzNIVDdmRzJyeFAvcHBHelVEVFJSU2hvRkV1Wk1IVGF1ZjdW?=
 =?utf-8?B?T0xYdkdjcy80bFlXbG5CL3l2dG11WHQ1SXBKV0x0TmNCbVJHTDlMdkhVWHdV?=
 =?utf-8?B?WXI3Qk9TTUlLaVVCdmdSZVFiWXcrMjFnTWdLUjZlRElERnJTU29jNmQ3UFdH?=
 =?utf-8?B?RHZDekhsUlB4cy9yK3VRckRlbG9qaWZrank0dm94S2twNEoyUmU5bHZWZXlE?=
 =?utf-8?B?V3NIdk9GVC8zcmFHaHVDOVJDNHZNRm9BYnlEQkJtM29sMDE4Mm5jR3ZHRFF6?=
 =?utf-8?B?TEUvSjNlVXI0bXUwTHE4V1VxYXJpQ21JR0FzamV2R3NOdzE0cldxeVc3VWx2?=
 =?utf-8?B?UjNIQzgxalNJMDYwWTlUSzlySGtJdVVyN2J5VDZBMlVBUzA2Nk10UW02TS9T?=
 =?utf-8?B?OHU3YlhOcnJWa1I0RFlWa2lvelU2a1ZvZWVOSHRMUndsQ1RNbXJCdkpqR3ht?=
 =?utf-8?B?REViQXBRRXhnNVhMb2ZxeEVpdFZCcFNoVjNvbDVjNjdzT0IyczV3TzBHQjRt?=
 =?utf-8?B?dFFzbVI5cWFzTndyZ0htMXJ0ZjJXNkZYVGxKWnVQUDZMRFlZNjZFNzV4c1ZM?=
 =?utf-8?B?VnQ2WTBhSUVQblQwd2FVaU92WkFyeEFQU09rVHlEbUJVMzh1K2lYTjI0Q1dT?=
 =?utf-8?B?YzFvbFJsL29WTGs3bDl0Tk5GWkx3cGwzOUMyRWs2UlVVQVg4amlXWFB1L0x3?=
 =?utf-8?B?TzJzM3hzdHlaeVlsb0JoQTNMZy90a2RvS24wM2hldzZzcEUxSWpZUTBxSHFv?=
 =?utf-8?B?L1A5NU9uTWN0VTh5NTFVVGdzdXZZRU9JMytwd0N6TUlzeTdGQy9IZkdnRTg0?=
 =?utf-8?B?MGdGZDcwSHAxdUhXMGZKTXFYMzl0UVhBd1ducXYyZThncHBqTTBMem5PSHJh?=
 =?utf-8?B?aDBlSUhick83Q0J2Vm9WRmRjZ2tWR1FuTGhJVkUxMCtPSHFmQURyTWRSN3Jk?=
 =?utf-8?B?MjhEaHRWL0tzYTVtdCsyWG00UWZyNW9wdGpnbjgzVzZmRitDelY5WGptT3Zy?=
 =?utf-8?B?VnVoYlkzaXlKLzFMb1U3ak1lTXdYUElsSWdaL04wRncvaEgrL3ZwanF5cEEw?=
 =?utf-8?B?YkJybzh6YWpTZVkvclNyVW1JMlExNlpSaDZqUVlud1pXQUZkcDg3Y0xqdWxM?=
 =?utf-8?B?U2lMU0k3WklGM2RWVFpaTG0wK2o1UEd1amt6c3FTNFJFYmxLcUlNUUk1ZlJG?=
 =?utf-8?B?bGhMT2R2ZS9zd1dHTDlEeDNJQjc4eHYvTXNkTThHdlV4TEE4SFFYMlZJQ3Bn?=
 =?utf-8?B?TTFpU200TTJHR1NGQlE5QTdPTzA3dGRzUzY2V2pWelNzY2RVYVV1Q293eXdU?=
 =?utf-8?B?ZzNLTXI5UjRObzlQQWRwNzF5YTBkVFRPZVRyUUtRTTg5ejdSVU5PT3NmNUVz?=
 =?utf-8?B?SnEwRzJlL1J2ck53UHBUN0JidW5aZWJ0cXAyNy9wajkwYm5aQnFsdjgvRUNz?=
 =?utf-8?B?UUU1endZM3J5Z0FrbktCbWprZ3FCZDFtN3JIODB0bVBIM0dYK0FmL2ZZdFpw?=
 =?utf-8?B?S2FYZFh0QkFsM0t5TXE2dWVvY2xYR0xXaXhLVzdwd1BxcGRjVlVHUE04NEV2?=
 =?utf-8?Q?Kb/Oi94N2KI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlFOZTdRTUVlQm5TY3d5Uml2TW9XNlRQS3VIaHkvdmdsU3YxdDdLRURSU3RS?=
 =?utf-8?B?bXBpRWw5RDZWY2NIWkRuRVNZRDNrdzV1cW8yU0RZMDJiajVpZTFBY3R1VC94?=
 =?utf-8?B?N1JPV3drcXJ3Y1lvTGpwSkVKN2E2Nk41azk5U1BsWUR1YnM3NGkybFVVREJ5?=
 =?utf-8?B?ODMwSjBUMUdPVE5sUVY1Y01CM3NvdWFKcnRMTEhtMEJDaWVRb3FDek9rYmUw?=
 =?utf-8?B?NzluYVhpbFgwK2tla0Fxd2paaVFqcDJaeDR3cHZOYVZMbm1MUlVVOVJlNGtW?=
 =?utf-8?B?di9sVm82eDAvWmtzZUYzYjNtMG03SUk5aTVvZk9KVEVLQmt1TjFFQ01ON2xu?=
 =?utf-8?B?Q1lSNGJYcGpFaHlKUFVaV3dVVHBPZjZrOHM3ZmtVbEgrR2FhU21tRmJOZEVS?=
 =?utf-8?B?MHZIMllOc0hPeGNFQmtIOHB3ZlFFbnN5ZzVOV3lRVFpFdzNEOTFzSXhTTUM3?=
 =?utf-8?B?VEJ1ODJad043MmV6cTVJR1RzVlBUbURLWlRUS0g2bG9Xd3BpWlNEUnVobUlt?=
 =?utf-8?B?VksyUVVwK2s1RHo4R3BsME9HaG1NK0dXbmlkNFVxd2VGeWJ3YjZCWjIwQ0x1?=
 =?utf-8?B?eUV6a2dLQnRXaWViR0t2V3l4RllFVmlQemk0YVhzSkVWWE9SWGtnQ01zR0RY?=
 =?utf-8?B?N2tMMTJUS1FOM3pwL2lzQkxNdjdsd1haN09BVDBDTUxkejVoczVSd3VrVXJF?=
 =?utf-8?B?YnZ5dkNOcjZmYTNRcEExeWRNaUxVN0NybnVRR0cxQ3ZjWGMxZXcvYUdJUk1O?=
 =?utf-8?B?Z3RNdktPemNxcHFtYXpncStOeHhxM3NBbHZndFovVU9hT0dscmZaclVuTlhu?=
 =?utf-8?B?UkdoM2ZEdkhIUWFWbytsYnZxd1JDS0V0ZFVVN1hpRnZXYzdLSFpScVBHc0Zz?=
 =?utf-8?B?WGlsbzVrQlowZW1CZjJmSXdGbkRTejRzU1ZJbm5NSHRDNEZBeWROY0JmcEQ3?=
 =?utf-8?B?Zkk1bUcyT3NCemZxVkYvd1hzNC93L1NuUVpHbFpQUVBpeS9GVVcvMEN1Y2lG?=
 =?utf-8?B?dng4Rk1YQXhBaE9iMklLMUVyK3ZjOFRtdjB1U3MvOE5PN2V6V3dXZjRCWWV4?=
 =?utf-8?B?WTYxWjZLcDZtTFlmbVlDenNXeVBGSFlSZlpSZlhqL1QyZzd4RHBwZ1l6VnM2?=
 =?utf-8?B?OVM3Zk1kODljdjhDOGlLendpKytERnQzNXZhVzFQOSt1ekFNbWFzdGlOQ3dR?=
 =?utf-8?B?dUNvUmkvSzhQbW1oUlJqR0NJcURBQ0dyVVNRSXJXTjJUNEQ5Nmo5a3VlNnVq?=
 =?utf-8?B?MnY3QU9RdmlCRjN6d3lvVmZEc2NYWGFBREZBSHNnVy9za1FNMmpNOU5tTlll?=
 =?utf-8?B?UWk4SDBsQUVFUzlzK3A1djJFWVFCL1dhU3VyNVBJaDM2WXhCY2FxdWF0L2hR?=
 =?utf-8?B?M1p4NTFqKytyOUx3N0ZLQW9WOWdUbWo3aXk4RGNDTmE4aWN3ZUREb3o5ZTBV?=
 =?utf-8?B?VDl6bWREVnp5RmNyWFJaRHpYUjdCa3VFenNITC9HdHA5bjNCdGRlczRaSWtP?=
 =?utf-8?B?TWxKa1dMdFRIZXBzaTRZMkt2ZVNKcURoUFJvaWt1b1VCT0lPdk5xY0Ivb1U5?=
 =?utf-8?B?QitMTGg2REo4cnZHNmdxMW9rWWdVcmNxaHlaWVJnemV6WEYrWUd0RlRCU0VQ?=
 =?utf-8?B?UlU0MVRUWlhlSmhQZTBabm5zdDdrckVBUmM5ZTZUZmdhVzlqZENxeHFoZGFT?=
 =?utf-8?B?eXZnQStDYUZNYWpGU3pPV1NjRU1ud0ZLRUFGdDJNZVZhdmhLYUljQklkM1dY?=
 =?utf-8?B?TDM1V2JML3plWCtuSE8rYnRSSFpVN1pNY1I0Q0hxVTVvTzdnOFAyY1dHcGZP?=
 =?utf-8?B?dHJVc2JHWEV1SFZCcmVuc3FPak5PdkNOS3BRbGYzbHpNQ1Zhc0hNdGJQUXdU?=
 =?utf-8?B?WERyK3FyNDBKa2NvNlVOVC90UXN1Vy9JaHlGVEtlN3ZSNURGRFNKTGFDaVd3?=
 =?utf-8?B?UUQ2K1RNZ3pLSVZYR05vRE9yaGFrSlFybmNZSktzL3NJM0h5SWtmdWIzK2hX?=
 =?utf-8?B?cHRFTWJnYkUwbEM3YnJjVFNPdGlYelBONGxRWjJJc1o4Q0NhNTF6d3hlbmda?=
 =?utf-8?B?TndwVzVKdytGbmRpYWt1Y3Q3OUx4QTV6L0IwejNWMHBma05OTkhPSXBkeWZn?=
 =?utf-8?Q?P20oOzz+e6OjLAFxJCqE6r7n9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e4f87ae-1f4d-4979-53b8-08ddf1503c02
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 16:28:26.4511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SvDWrSi2e62M5Jsjjk+nHXNl8OUloE+yyXPPXFdI1dFS+TVfVx0hL7npJpRK3Y74
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9093
X-Stat-Signature: pyssq18p14hbgsz7h8at7h86jgezosn7
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A6D212000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1757608110-270126
X-HE-Meta: U2FsdGVkX1/PfKSNNQWcjbEKcQ5GA4iG6TPzq6rEy8/YdH9FlJXNLrhLI8NrmvhHyETMYSrRK+0Jj3AMbVJIEYC6ZFzFfgc+WREDTtRd5f2dOYmE7Kmw3UpgHWdpPLNG2VDRT0MmbSYwUilULxW4JajIYYpYr3ykw41RB2iTdwgQsLJbSg7+HZ2z6h66E4+mvrbnFwiv8v6nxizLSHI2lma4OX05Yez+H5zESA83BlK7NQvVlJcOvLOS1PmZdz+Duz/CnhuCiKb2TLnOHkAoVth7UacQMMlUflMHv+XtFgmyYIuLhPI7Siur90GyJaYA6rXRq0N0tN2MeRD3rXnoH3hQaMTug4rRyMBC8pa+Rn5CcANaLhNnZzOjXMS3XF0b80uUpDUSdhIBM+VatX5otm+LxU/IcV+67muhYVQeS6eSkVLS/5P8TxUQossoRbc3SfLz2QViZdjx/qwiRF17/HkI6TodCwB+2v2ZeWZIi9Hhc3oXXnxOya8ZITUSxJqxeDyKwDqwWmjsse+UUTWHMOpZ7g4Z2/ZHKns2l+pXRM6uXNKtJ5RLJc1PCIMjFM85f7mw0RUD71w3O7xN+TX2lIdw+ssK3kaupHkpMrFs2uwQSSeukKWB2erXOaktShIcIQOBr3S4FqlmpUYTe1ffQxN/tqVDZXHUb8Ffnzb1SWdKC1ZCPqCyDAJ+7bCR4mimPtIe/Ze9cT2wLNfoxnIEgvJRpqFbloh2joX9vMVfWDTKzCv0rDo4kByMPoRCbY3fV4OCBPZlPFuKQM/6tWtVbEBlePoDH3zuxfcODvmZUVWRBOJ3L2pcSAPf5qPwwtp4lfEvvGLCFXeEHdbfH0Oo0pRT7KSIxAChT3SWQ+GhSvvoejszYaey36ZTztuTlynwa6SACvLQXg0rIGNuslHSBwVHTTgQHHdtqfIn75FlWuVZotGxCfU0Pjlf5HzNCMCD/OIUkxkclsoL8yjnqW5
 pBmYx/WA
 jz5gIb++F2dGS41sP69swBzDK7Jn+Pj+2L2Q76kQ67K0z1dFGFs6Ii1W2QqV7RyqHKE4kaLzRZCgLgs7Bf1RBa4BjdIo3LJvwX9+Go9jpyiEgzEIa1MVpYTVg7qdouDeddIXq6cevrlHuoCo3tNRhU3K22q6YV4IXoXCiu2KAZOl/5oF68l6DH+7aKvIYNvYik1yfmMUIULigVpmEJNztIsGNEa941kiwpNjgbpodUZ2lkD0TLKlWaIxaL9z8auwIZvindzZiol59hKAA7OByTa9EHDSYDd7wEem3y0wn5mdcnVOzeo0pXk/MxE4OST6EMEcXzzjbGPGXc8IWSlXKkdSCJUlBsQs8PCTqt9mz3H5mLRz8k2A+ajN5sUl3wY/LOoVexwgJOCgI4w9+jeLRaVTGUR7Mb+UyVSlTDGww65aDRqO/bc54NlmNpA0Erwpyr/5EY4w60s/Ho1P9K3KX1Djp81396eTv/KRXhWo8KVpcNn9a5oXecE6zsuzFv0CZU2fRrUdeJM19fQjh0b5QH8tavFO+zQtOO3B1TvkUVKsEWXDvRuuJT5o4BHVyXWZJ+bPEIBkiQqllYLrOW1LcqjDOTDdrAs+euXm4F2OlGQljg8us+i7nYVUBqx7XMMxk03FpXYcmB9fRqMSrzTDfBsazew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Sep 2025, at 2:30, Wei Yang wrote:

> On Thu, Sep 11, 2025 at 03:34:13AM +0000, Wei Yang wrote:
>> On Wed, Sep 10, 2025 at 09:50:09PM -0400, Zi Yan wrote:
>>> On 10 Sep 2025, at 21:38, Zi Yan wrote:
>>>
>>>> On 10 Sep 2025, at 21:35, Zi Yan wrote:
>>>>
>>>>> On 10 Sep 2025, at 21:25, Wei Yang wrote:
>>>>>
>>>>>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>>>>>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>>>>>>> isolate_migratepages_block()") converts api from page to folio. But=
 the
>>>>>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't p=
oint
>>>>>>> to head page.
>>>>>>>
>>>>>>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
>>>>>>> which means low_pfn only advance one in next iteration. After the
>>>>>>> change, low_pfn would advance more than the hugetlb range, since
>>>>>>> folio_nr_pages() always return total number of the large page. This
>>>>>>> results in skipping some range to isolate and then to migrate.
>>>>>>>
>>>>>>> The worst case for alloc_contig is it does all the isolation and
>>>>>>> migration, but finally find some range is still not isolated. And t=
hen
>>>>>>> undo all the work and try a new range.
>>>>>>>
>>>>>>> Advance low_pfn to the end of hugetlb.
>>>>>>>
>>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in iso=
late_migratepages_block()")
>>>
>>> This behavior seems to be introduced by commit 369fa227c219 ("mm: make
>>> alloc_contig_range handle free hugetlb pages=E2=80=9D). The related cha=
nge is:
>>>
>>> +               if (PageHuge(page) && cc->alloc_contig) {
>>> +                       ret =3D isolate_or_dissolve_huge_page(page);
>>> +
>>> +                       /*
>>> +                        * Fail isolation in case isolate_or_dissolve_h=
uge_page()
>>> +                        * reports an error. In case of -ENOMEM, abort =
right away.
>>> +                        */
>>> +                       if (ret < 0) {
>>> +                                /* Do not report -EBUSY down the chain=
 */
>>> +                               if (ret =3D=3D -EBUSY)
>>> +                                       ret =3D 0;
>>> +                               low_pfn +=3D (1UL << compound_order(pag=
e)) - 1;
>>
>> The compound_order(page) return 1 for a tail page.
>>
>> See below.
>>
>>> +                               goto isolate_fail;
>>> +                       }
>>> +
>>> +                       /*
>>> +                        * Ok, the hugepage was dissolved. Now these pa=
ges are
>>> +                        * Buddy and cannot be re-allocated because the=
y are
>>> +                        * isolated. Fall-through as the check below ha=
ndles
>>> +                        * Buddy pages.
>>> +                        */
>>> +               }
>>> +
>>>
>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>>
>>>>>> Forgot to cc stable.
>>>>>>
>>>>>> Cc: <stable@vger.kernel.org>
>>>>>
>>>>> Is there any bug report to justify the backport? Since it is more lik=
ely
>>>>> to be a performance issue instead of a correctness issue.
>>>>>
>>>>>>
>>>>>>> ---
>>>>>>> mm/compaction.c | 2 +-
>>>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>>>>>> index bf021b31c7ec..1e8f8eca318c 100644
>>>>>>> --- a/mm/compaction.c
>>>>>>> +++ b/mm/compaction.c
>>>>>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_contr=
ol *cc, unsigned long low_pfn,
>>>>>>> 				 * Hugepage was successfully isolated and placed
>>>>>>> 				 * on the cc->migratepages list.
>>>>>>> 				 */
>>>>>>> -				low_pfn +=3D folio_nr_pages(folio) - 1;
>>>>>>> +				low_pfn +=3D folio_nr_pages(folio) - folio_page_idx(folio, pag=
e) - 1;
>>>>>>
>>>>>> One question is why we advance compound_nr() in original version.
>>>>>>
>>>>>> Yes, there are several places advancing compound_nr(), but it seems =
to iterate
>>>>>> on the same large page and do the same thing and advance 1 again.
>>>>>>
>>>>>> Not sure which part story I missed.
>>>>>
>>>>> isolate_migratepages_block() starts from the beginning of a pageblock=
.
>>>>> How likely the code hit in the middle of a hugetlb?
>>>>>
>>>>
>>>> In addition, there are two other =E2=80=9Clow_pfn +=3D (1UL << order) =
- 1=E2=80=9D
>>>> in the if (PageHuge(page)), why not change them too if you think
>>>> page can point to the middle of a hugetlb?
>>>>
>>
>> The order here is get from compound_order(page), which is 1 for a tail p=
age.
>>
>> So it looks right. Maybe I misunderstand it?
>
> Oops, compound_order(page) returns 0 for tail page.
>
> What I want to say is low_pfn advance by 1 for tail page. Sorry for the
> misleading.

OK, that sounds inefficient and inconsistent with your fix.

While at it, can you also change two =E2=80=9Clow_pfn +=3D (1UL << order) -=
 1=E2=80=9D to skip
the rest of hugetlb?

--
Best Regards,
Yan, Zi

