Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCE1EA7960
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 03:53:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05F7F6B0088; Wed,  4 Feb 2026 22:53:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38996B0099; Wed,  4 Feb 2026 22:53:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9896B009B; Wed,  4 Feb 2026 22:53:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C81A66B0088
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:53:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FBBC1C25C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:53:56 +0000 (UTC)
X-FDA: 84409034472.20.2DE8E09
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012054.outbound.protection.outlook.com [40.107.200.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9B2C240009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:53:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ajcdoHuI;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770263633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2EHkRTbjccN0EQ4ZRfyAxgCYFJ8OoijoJo3AylBZhU=;
	b=UCfiuYOwHGjbn5ZvHSaVHsNolKzDfRwLeeompZ1IbH024PAtu1mh7QtGPGeVfNymlIG5TX
	gjxtqPtdQuAlGaXbqS8OuqDfySlpj5xOUpXUov2vh0YPM9z01dC05zFoRbdwRipIPcAMsF
	Vuhr7S6UKOYNc87ddmHOaz+UUD5KebI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ajcdoHuI;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770263633; a=rsa-sha256;
	cv=pass;
	b=ou67LU3GT1n/1zOtGjCH0EoltFAIzEFXcyGduY1Awk6ylEg80b8kRKHVyD4TNK0xVtu4We
	zfoC9ursrO/udvU/UUoIZevIJdJ37FeEMNukFFNSsYzAaTa/1rGQJR6RORCf3+e0oIXrXl
	cM3JH+TU/YmPqmRh/SYXDUONI2/1J2U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TTKhjLq8D65nTWJ1a3rROvglUkAC5Ky8aIFl1B/NF56qN7wF7ZRsN3nc2KIiXxlUvjE0QkwK2YdF0T2WuwXZkWgRPJhLecIckH7IHP7F1IyvafZUDOVyYaZCEbYovzopZiP3LADTDp0I5woX5S5vfmGpa4gdOgFXp2jX1TDUxtTxYHcLz9v2brpaJYn+mlD0BTlrOVfLPRhWZ+PsReG4GiRbF6tjlk4gPRx1sKabqbwQiLSeY02sCQSsnmtPIDH8eh1bsuk+tvXwkLgCp6RmYTQCA09bQudDLrRIuqGdGiuaoG7tYzD9MP0TQt8WROpmFoCPYKCN3lxtfrKr2rixBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g2EHkRTbjccN0EQ4ZRfyAxgCYFJ8OoijoJo3AylBZhU=;
 b=y7OAow2IMgHvNUWDM2L2lSvADvh+cQhTcOr9ENJ4bKlwu7jJVHdSeiGzP4NLJHfSJu2R+xG+aq+vgXmuc5/vlFgfLepDIDTxq1rbUett2QtV5kDPvWT6PnDKoriQxtOSGV2o/jqNsAnLGId718Q1NzuCKB1Z/0PvlUCTNRZoQMrdow6p5ZoqB6xi0grjBtedW14IRjhu7nzQ1Duli9tGRgF+ggQ5GD7PWh7FqMkcXmZBpAWzXdEeHQq5WZuKo9oSfEpFlj1RquTxvPTCIER1n6Prnp+GBs7+lgxiU2VqOxnxw5tWO5DVyP1aDkr+gv7r/U01DgDy/yCgBmDdL60RLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2EHkRTbjccN0EQ4ZRfyAxgCYFJ8OoijoJo3AylBZhU=;
 b=ajcdoHuIrHbsAN/WwHkMnoPKOQCa8acvEK80lPW4C2+y9VQ2ddJ+f83rWzQDHYnibiGH1C7TzmUBwRXx1l3R7uLcug9J6zcZ54jhjd8PZy3RzEnrby7pJVGqaQPqo/o1MhoLOkKVPBX+qAS+fB5p1n6/KDgGhKwPr2L4zLmYz3gxn0xdkcBxR7/0p5qtp6WKMjL3Td0wQB0Q8yoNhxfnWiFk6o9dBI54IEBbzR92Ozunt6DdXFv6hvm/ajmVLGCVZ8vre1ZgIxzDAWBip4dX7OePb1AF/ifScN08JwhZtToRzWtnUOVnDIgo0jXaMYmacnlHpRccgxX7x7a6EFXiQg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Thu, 5 Feb
 2026 03:53:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 03:53:49 +0000
From: Zi Yan <ziy@nvidia.com>
To: Miaohe Lin <linmiaohe@huawei.com>, jane.chu@oracle.com
Cc: "David Hildenbrand (arm)" <david@kernel.org>,
 =?utf-8?b?5piv5Y+C5beu?= <shicenci@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
Date: Wed, 04 Feb 2026 22:53:48 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <85CB7DEA-79EE-43EE-BA9B-C2AC81F6FA02@nvidia.com>
In-Reply-To: <c5206f67-1e9e-d487-3514-8867f00cc626@huawei.com>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
 <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
 <61BBEF63-20D6-4671-B7F7-F015D49B2080@nvidia.com>
 <1bfc9e64-2961-4d2c-a6c3-fb123f66e6cc@kernel.org>
 <94DAA11B-597F-4F8F-AFFF-9D7626A7C091@nvidia.com>
 <7d5754dd-8cf5-41f3-a767-271b28b1f63c@oracle.com>
 <c5206f67-1e9e-d487-3514-8867f00cc626@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL0PR1501CA0035.namprd15.prod.outlook.com
 (2603:10b6:207:17::48) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a68ef33-5545-48cf-676c-08de646a2bae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cm01S2FIWVpGV3Q3ODlEWGw5WGQ3Y0pFalltejROeG9IVW5XY0ZMUEJHSk1E?=
 =?utf-8?B?aDJaL2JDRzVJU3gxZk50dmJNTGplZy9KVGdwRTFDdkUyWFNudDZZd0R1OGZG?=
 =?utf-8?B?ZlR0YWRleUNjdnV3TW1Mc050UllxTm1haHh3RkY4UzVRMjdvTW1SaDBvL3FF?=
 =?utf-8?B?cUhxRXRoZURjVVFLaVdhQ1lnQkxlOWhOSnYwZUhjR2Z1aG15VXJUb211RVJJ?=
 =?utf-8?B?MXNQdllnbmJpVVQzOGp0cEdEdFdYMHE4bXhFclhGYjhCcUp0dkRQWmdSeG1W?=
 =?utf-8?B?MmNPMTB5UHFJVnpaTk4yZWp4Z3lsUG4zdXBiUGJCK2VidC9kU0kvQzBrMjA4?=
 =?utf-8?B?ZG1vM2lwSjE3Vjlub3FHWEZWdjNwbTNqNnZ5YjJkbEx1SEVQcXp1dDZrL2Z0?=
 =?utf-8?B?VlFETjRnZWRqdit0U3Zrdno2TkFTZk00N1h6dFJYQjl0OFR3ek9RdnRIc0Fy?=
 =?utf-8?B?TlEvTjdLMUlXcnpCSDYrbzJ5QzVJR3RJZGw3RlBsRG1Ld3FOckhyZndpd3Uz?=
 =?utf-8?B?cFZiMDRTNmErclBtdVVRQUQ3U3dFSktrRDRBOUx0aWFQbGhxNWFHM2xVdG1o?=
 =?utf-8?B?WCtWNVphZmcxRnRHRENWMWxmbTlBZE4xRjZpalVmRUx5OHdOVGlDMFA2UVR6?=
 =?utf-8?B?VHgzKzNaQnhScVl5OVZQT1RBYnd3bjd3MmpaRjhHVG11TTdNTlRKZjVtbDZU?=
 =?utf-8?B?bHRNcjJORHprN3crNmFkTktEb2lRVlozcDFQRVhWeGtVY09NbncycHVYaWt1?=
 =?utf-8?B?aHNxRVAzTm53YXJ1Uk10RVB6Yjh0RWhWeUJYUzlJV21VQlhmeVY0Ulp5ZEtT?=
 =?utf-8?B?b25majdIU2wzQkJVVWRONU9XbGVHYnlyaUN2NGl4ZHd6SWdJdnVMcnA5NnZD?=
 =?utf-8?B?V2ZYUFJScTdCRktONjlmS0hsbmtGVUNaQUJwTFdRS3FnTGkrbmZYazFiY3NI?=
 =?utf-8?B?SDZpYXlnUUtibm4wOXU5Rk92RjI2L290SndrMHBSR1ZNL2d3Z0NYZTAwcHRW?=
 =?utf-8?B?V2Vjb2VYOUY4R2V5c2FUOFBqRTNDWHpxWUNicmFHNEdKWmRNMnRFWk91eXl0?=
 =?utf-8?B?SEh5VkVadU5NbzA0R3JIYit2MDAxY203RHB0QnZzZWR4dmJpUjlNSUEzWXRv?=
 =?utf-8?B?cTJuRENNUk1JRWhQcFBoTS9tY1YwVHlxRmcya2lSckphK3luckZCb3RLaHF6?=
 =?utf-8?B?Qmd1Zk14blUxZjNkV2JCb3dGVnRKRHlGZmhDQzVCUkZBdFJIVmduTnp4aUEy?=
 =?utf-8?B?cU9PVXBzckxsUXFlbDRSZno1ZHB4N2dURXFxQ3Ezdk5ZYXc2TUMwTitoMGlw?=
 =?utf-8?B?UEFESW9xdTBHUGpITzRLcjdRUVptUU5GMVJqUERZeDdWNWx6dm5NbEYxbjd0?=
 =?utf-8?B?Y2c4SU9TRUhvdFc3N3Nibk1KbXYyVThtdUN0ejNLUFM3WXdZQ3NCMW9qZXha?=
 =?utf-8?B?V0ZpNVBpVC9QVlB6SGg3L01ZUm15UEJUS3NQYXZOWFF3RUdIM0FZZEtMVlA3?=
 =?utf-8?B?R0M5Vk8zTTNkU3pnTEJlWTdHUmE4cVFqQUIyQzJueHoyTEtBYTRNTkFkY2dN?=
 =?utf-8?B?TUJ5aDltZXZsOHdPUVdQNm11S25RSm5uUm1EVXB2TytRTzZMTDZoVVZGWHo1?=
 =?utf-8?B?Wk9HZjZlUWlxRzlhNHVwbDNGWG1USjlXRGhjMjJzbXdaNU9aQTVuTk9VWnFm?=
 =?utf-8?B?TUZtWDlIRUdmdUNBaGJUb1l2VTg0d2FIREltWCtVSWhhcHVlT2NRRTNWbWhv?=
 =?utf-8?B?bGxzWjIyY1ZMTU5lWngrb3FGRHY3QmxSQXNoUkFyaE43eDRrVitpek9sRWtI?=
 =?utf-8?B?M2ZhVzRMS0FQV2RKWkxldGdESHJaS2FvTW5KTE9uWTVpTDdMNEdhZnBuODEz?=
 =?utf-8?B?cEtJczBPeW9Fd1NDMUF0SzJleVk2SHZ0T3JmYUptb0d1RUttejhERURIWnFO?=
 =?utf-8?B?UnE1RzMzTTJvNzFwTG8zT3h3ZFFaMVpDekduRzkxcXlkODJ0L0IxUXdMUmRu?=
 =?utf-8?B?TlVtY0thYkVjRjE2T1ZBUGM1SmZGbHoxK0ZtRkprUjFYTnJhbCsxYndQOWRR?=
 =?utf-8?B?aFh3RURkUTZZTGZpNFY0dTVHQ0FVTU84RDJFQjh6SXAxaDBPOE82R2ZaNkZa?=
 =?utf-8?Q?+B+w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDh1d0xGc1JpeGhGckoxRVVySmF0SzI3VXFuZkNCbldPQVh2a1NCWFZadnd5?=
 =?utf-8?B?c3VVWWRFaHRSVTFKSzlJdWtTSUFKV3AzRWZydFBnd2d4bTBOWTJXd3o1bkJS?=
 =?utf-8?B?M08yVUZGQU9BWmtBRGlCdFZmZVRnU0kvcVZZdk5lRjY1RE9yQlNjNjFSTEhQ?=
 =?utf-8?B?cW1DaVdoZEgwbWpnY01SblRIMDBEOWdVRWxGeHdrYUFSKzA5NWFpU0doQXNu?=
 =?utf-8?B?ckVudjh0Y2JjOW50WXVYa1lBNW5Kd3NMWTZkOUxWaVFib0FUK1o3VDhUREFx?=
 =?utf-8?B?Nk50R3RIaUFwZVo5cllwZHRnQ1dDajFiUGFLaFFpRm9meWlLUys4L1J6K3J1?=
 =?utf-8?B?Njg5bHlpOTRhdHM5TjQwWG4xdWh3OGdTK2sreEZ5UzZJMmR4WEdNR3ZQRS92?=
 =?utf-8?B?WDFVSlY3OUdQV0dNZ2lVWG5YZjJEY2lwa2MvOUM2S0hYcTJXS3oyYUJITE9a?=
 =?utf-8?B?bzVqaWVKa1NKUGZiZGkwcUJtOXNzNjl0SEpiMS9XMnQ1K0tGY2xXWEV5QUgw?=
 =?utf-8?B?b1ZuUS9uMGo2Y1VWL01LN294ODhQenZFSVBGMWlhWXRab0VrQWpiNkJDRmJ1?=
 =?utf-8?B?WXA1cjRjNUFBTlh6OUZIOFhZVVkzQmtEazlZaFZHUFNmMUpucFQwREhXbElX?=
 =?utf-8?B?TThHYXY0c251OVdneWRheG8xckZsRkc5SlIvWm1ZQmsrd1d2TDlPd3BPUmgw?=
 =?utf-8?B?d2FpcGJlcTRkYnFEZmVrdXFXZ2NETVBTdUVKUENqcE5LMmNiS3lUeEdYVWZE?=
 =?utf-8?B?VUUvOEg3REYwZllpakFlUmVMbmhpSkEwWVE3ajM0eElEOS8xNDEzbGpvbWUw?=
 =?utf-8?B?RmZYRGNoc3pwUjJUQjJpaktkMGJOamQweWZFc2tWRGE0SzNkOXp1OXYyT1BW?=
 =?utf-8?B?ZWtjMmtVOFJKeFJwODJQZWo3YTIwU3Y3VWNOZm1uaWYva2NSczhvQXM5N05I?=
 =?utf-8?B?QTRmN0E0Nit6Z3BTTzFRZnNmLzJRVUpqMUJLUDZlREx1V2ptbjhqdzJjTjNt?=
 =?utf-8?B?eURIejliUnlrSWZTM0IvRFB4aUJGYTdWa3lEZWVETUZhY09hWkVpMElJQVpR?=
 =?utf-8?B?bkZtYUsyUmtxUTJZenl4TEZBNU5JaWpxY1hlaWJNZjRuVzRkUGNuMDhNQytJ?=
 =?utf-8?B?N2JaYXAxYlgyVVpQMXJ2VjFHd3E2OVNJWDN6MHNsTGxHVGs5T0h2SGZzWnFj?=
 =?utf-8?B?Uk9VVW5HdW05T2FvTmVsQS91UTkxSUJvNEFLMERDMFBsY0NjSFFMeCsrb2FH?=
 =?utf-8?B?UHFQMVVHN3FwK2hreVJpcG1TaWtJWVFPeDVYMEltd0g2RHFHWXI1bnVHM3lp?=
 =?utf-8?B?MnpoZ0d6OU9aMXEveUUrZGUzVmd6UkRtaUZ3MFF6RlFGaExFdXFXanBvOWd0?=
 =?utf-8?B?bGg3UWgyckxyMTNMM3F3b1VJTWdiRkJWWjUyU00vcVZzMklQUUF1dnpSSXJ5?=
 =?utf-8?B?blphVzNwNDZCOGNNeEdPOHpubUtzRTcwN3FqQU1SVmo0OGVPaWhwWHRPVDk4?=
 =?utf-8?B?Z25VTVFNeU1EaFJSKy9Tbm9HbVRHK3BzZ0NmOEpiaEVBWmp3NXYwZDZoUXpL?=
 =?utf-8?B?ZkNoangxSTlsTk14SnAzRG5QTWtGOWJnbENhNlE4a0hMYTQ0MTh1VnN2UFlR?=
 =?utf-8?B?THhaNW4xRmdWLytZYVpwU2RVS0phWm5UVXlWckcrWEJyTEFVbHVsQTVTZFpt?=
 =?utf-8?B?Y1FjTW0rK0JydTByZU1OdGlDK0VJYzFnS2gyL2c1TWd0WmRqN0hPbkNQck5r?=
 =?utf-8?B?MnA5SWNzRTVaS2piN0Y0b3ZGWmloc00vVGtaMHlER0N5dTRGSWlRcHV1TmpP?=
 =?utf-8?B?M3hCcGUzbDBuenFjbEpWaUxiVjJGalRhcS9FR3J3S1B6Z2gvVUFPTjNMREFF?=
 =?utf-8?B?djZLakwzOVVYcTR2T0I2bE9XdzlrSDhmekQ5cC9uemZYY05XOHEzMTNDSG1O?=
 =?utf-8?B?RVdiM3NFNmdqNmdRU3JPWnFYbURjSXlFQlF6Sm96SVhjTmsybDd2b2hGRks2?=
 =?utf-8?B?QjFtUGtnWWcvZmVxa3B1UmVWU3JyR0ZOZGpnSkY4OE45dXdSWFRyZkQrM3VN?=
 =?utf-8?B?eDVXNzhtNS9LN1FiR3I1RUhHUGhXc2M2VUREeUtQQ1R1a2x1dkw0R2ErcmEx?=
 =?utf-8?B?QkRGVE0zeUxkOVRpMTBBUTBPc0lNejM5OXhVN1AyYllIWTY4Ums3ak9BblhD?=
 =?utf-8?B?WWM2aytRckFBUThmeloxaFNSbFk5UzdldTdBSm5CV1NTalYvSXVVZmwrMEQz?=
 =?utf-8?B?UGdvekFsYmp1QllhY2pNMTdMQWNrUnRxYm9vNGYxQkl5NS83KzJ2bURWNWlQ?=
 =?utf-8?Q?vGcai1XycdpU9i7Umg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a68ef33-5545-48cf-676c-08de646a2bae
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 03:53:49.6196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UATcaccIQIIpkaPS5snKwRk7dWdJGFhggxYFhTOfyyYF/TWj5Nk5zGN8rQl2H3K3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650
X-Stat-Signature: 5uyoorebawk3ny1rodteyfa83gmm8ftd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B2C240009
X-HE-Tag: 1770263633-115460
X-HE-Meta: U2FsdGVkX1+qza5tR8s2rC9H/+on49CExfQf+BxvsbNab0hNh6Hc5CfD7B11GpFMNkCHo9Jz3ZSDMewjPIw6qix2KOwW38Thq1ro9qiY4DVqw4XsJy6I/rOiB3ahkjnb8DiSk3m2PXV0axE2XWpEQLeppBONNKjz6Bg5FJrYCFc8kWnvwR4nJAtZ0A4L5QRmUQjm8cg2KX6nCiJs6cBp24+VzBcyp/ywz2FPeMSHGNi/teRB5BOprORO68srwVCpVqfE2PBkzZ8VnN86LYtDOypbf/o+FsIetJD5nXujaH82yQPOCkAML5pvYiSQD5EJcJyfbDXdknTg0g7QRZuU5Krc/OBkQofrm9xCRAkzUa97qD4OjyliBBhVLqr5q0izxspNj8HgY8NnK6PYVnAlS3nTcSbuUh6TTFQGD1yfMd9j/+moc1Hifq71ICJbCHBswoUOQLOytz0eLIkdAykT9Q93VaY03FTRNHOQ4keZ8WponMMC/HRTtK6z204U80Lyfq242l1DxbhJ9hH84X5w3iI4cknPgxvFPGdey/C5ZWKlEdAjnUM49JOzkGQ0uVrL7LMpnkR6Gc8i1N/62cmwsUw27vP9Ld4dNJY51I98dido2zi+VIsnYbXml2JWeO8MZFSX3z00yvUyNOk/nK6Rv+55Un/1eCjqiSusA7hqs9sAY/KaHeqoAQXCRfi7C9WqLrDN0ZLj/xD67UguzCJ2FBG2iENl3dsKPdbFjyu/wIbd7uA1AD2l/T73oGKjrAg5SYBAs9d0iyPFR1SEQRLVTeGoczbmVDTYh3FLDmpIsxbparTxmiWxPiyQxNtkkTX5+Hd/J9LqRurk9yajS/OtdDUO7FBsD5r/JtouBnVaozozkcuOaIFlsGuBqAZOnDbRWbLGKvJJZXFJhwhGryMA33rgsFJqhGjk0J5eDBK7LibwV01KN41S8Tl9Iv4MjAKoBVbbKqpKoUrGEHod19p
 cz0oQEfJ
 WDWyk7Alg7jGZxY5DSSG7di68JG3j4jKc/zRzSkfC3M+S56EhjDGhRH6/d53aXV5FEquuM/U5vCtjvTxPO8KhVc2sUvdEGaT57A3qOOXKRDwUV6GAN4vW3OVr2I6hgk57MCRY80cxZK28spOZs2fFYBfjV2PB/wh3End33D1nXXQvG0H+KHfwcEKVFQJ+ZT3oYGFIh46RylRpdavhQztjBriu/pp/u7qoxmTXZMZRXtkr+b6GwXPmvdhjxcpK3UrbeizKwF6Xl/lwF4YI2XdJJ6AZM2F+QWuzbOw3qPNMPuKw2uKOYjRp7GnisnGqKjB2QFllrWHyWpSdksT20RU4eIhKntCnAaZqJgJKzOrgVWmjXgsu+7POrxEs81Y9kcDk1BIh+TTdMfr/PJjxow7ohPn81VuEPH1l7r8929ZgiedoVeXLwFRBHvMNGHEPpEAc/LKAOTj6enB2pX/Rmvao6KIpHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 22:21, Miaohe Lin wrote:

> On 2026/2/5 10:00, jane.chu@oracle.com wrote:
>>
>>
>> On 2/4/2026 1:41 PM, Zi Yan wrote:
>>> On 4 Feb 2026, at 16:37, David Hildenbrand (arm) wrote:
>>>
>>>> On 2/4/26 22:08, Zi Yan wrote:
>>>>> On 4 Feb 2026, at 14:18, David Hildenbrand (arm) wrote:
>>>>>
>>>>>> On 2/4/26 18:41, Zi Yan wrote:
>>>>>>>
>>>>>>>
>>>>>>> More details:
>>>>>>> later at sg_vma_fault(), the driver just handles a page fault by su=
pplying
>>>>>>> a subpage from a pre-allocated compound page[3]. We then get a larg=
e folio
>>>>>>> without !CONFIG_TRANSPARENT_HUGEPAGE.
>>>>>>
>>>>>> We can identify such non-folio (but compound) things by looking at P=
G_large_rmappable IIRC.
>>>>>
>>>>> OK, back to the issue. The patch below should fix the issue?
>>>>>
>>>>> Hi =E6=98=AF=E5=8F=82=E5=B7=AE,
>>>>>
>>>>> Can you test it?
>>>>>
>>>
>>> <snip>
>>>> I think you have to test for folio_test_large() before testing folio_t=
est_large_rmappable().
>>>
>>> Oh, forgot that. Thanks.
>>>
>>>
>>> =C2=A0From 8dda4bba9964890462eca3ef3cce57bb4fab8313 Mon Sep 17 00:00:00=
 2001
>>> From: Zi Yan <ziy@nvidia.com>
>>> Date: Wed, 4 Feb 2026 16:04:19 -0500
>>> Subject: [PATCH] mm/memory_failure: reject unsupported non-folio compou=
nd page
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>> =C2=A0 mm/memory-failure.c | 8 ++++++--
>>> =C2=A0 1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index 825c706ac576..137c67fda57e 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -2440,9 +2440,13 @@ int memory_failure(unsigned long pfn, int flags)
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 folio =3D page_folio(p);
>>>
>>> -=C2=A0=C2=A0=C2=A0 /* filter pages that are protected from hwpoison te=
st by users */
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * filter pages that are protected from hwpois=
on test by users
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * or unsupported non folio compound pages
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 folio_lock(folio);
>>> -=C2=A0=C2=A0=C2=A0 if (hwpoison_filter(p)) {
>>> +=C2=A0=C2=A0=C2=A0 if (hwpoison_filter(p) ||
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (folio_test_large(folio) &&=
 !folio_test_large_rmappable(folio))) {
>>
>> Just curious, would this filter out pte-mapped THP/mTHP folios?

No. All folios (including pre-mapped/mTHP ones) are large_rmappable.

>
> Thanks all.
>
> memory_failure() can meet various types of folios. So in get_hwpoison_pag=
e(),
> HWPoisonHandlable() and PageHuge() are used to check whether the folio ca=
n
> be handled. But in madvise(MADV_HWPOISON) scene, MF_COUNT_INCREASED is se=
t in
> flag, so this check is skipped and warning triggered. Might HWPoisonHandl=
able()
> check be always used to make sure the folio is in sane types? Something l=
ike
> below (i.e. remove the MF_COUNT_INCREASED check before calling get_hwpois=
on_page):
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 825c706ac576..ba4231858a36 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2411,31 +2411,29 @@ int memory_failure(unsigned long pfn, int flags)
>          * In fact it's dangerous to directly bump up page count from 0,
>          * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
>          */
> -       if (!(flags & MF_COUNT_INCREASED)) {
> -               res =3D get_hwpoison_page(p, flags);
> -               if (!res) {
> -                       if (is_free_buddy_page(p)) {
> -                               if (take_page_off_buddy(p)) {
> -                                       page_ref_inc(p);
> -                                       res =3D MF_RECOVERED;
> -                               } else {
> -                                       /* We lost the race, try again */
> -                                       if (retry) {
> -                                               ClearPageHWPoison(p);
> -                                               retry =3D false;
> -                                               goto try_again;
> -                                       }
> -                                       res =3D MF_FAILED;
> -                               }
> -                               res =3D action_result(pfn, MF_MSG_BUDDY, =
res);
> +       res =3D get_hwpoison_page(p, flags);
> +       if (!res) {
> +               if (is_free_buddy_page(p)) {
> +                       if (take_page_off_buddy(p)) {
> +                               page_ref_inc(p);
> +                               res =3D MF_RECOVERED;
>                         } else {
> -                               res =3D action_result(pfn, MF_MSG_KERNEL_=
HIGH_ORDER, MF_IGNORED);
> +                               /* We lost the race, try again */
> +                               if (retry) {
> +                                       ClearPageHWPoison(p);
> +                                       retry =3D false;
> +                                       goto try_again;
> +                               }
> +                               res =3D MF_FAILED;
>                         }
> -                       goto unlock_mutex;
> -               } else if (res < 0) {
> -                       res =3D action_result(pfn, MF_MSG_GET_HWPOISON, M=
F_IGNORED);
> -                       goto unlock_mutex;
> +                       res =3D action_result(pfn, MF_MSG_BUDDY, res);
> +               } else {
> +                       res =3D action_result(pfn, MF_MSG_KERNEL_HIGH_ORD=
ER, MF_IGNORED);
>                 }
> +               goto unlock_mutex;
> +       } else if (res < 0) {
> +               res =3D action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORE=
D);
> +               goto unlock_mutex;
>         }
>
>         folio =3D page_folio(p);
>
> Thanks.
> .

This makes sense to me. And it gets rid of the warning as well.

Can you send a proper patch of this?

Feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>

to it. Thanks.

--
Best Regards,
Yan, Zi

