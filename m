Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79EDDF364B1
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 20:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B53F6B0005; Thu,  9 Apr 2026 16:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865C26B0089; Thu,  9 Apr 2026 16:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D726B008A; Thu,  9 Apr 2026 16:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61FD56B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:02:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDBEF139436
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:02:46 +0000 (UTC)
X-FDA: 84640090332.22.240FD4F
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010031.outbound.protection.outlook.com [52.101.46.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4570E20009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:02:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="r/13kcvx";
	spf=pass (imf13.hostedemail.com: domain of jonathanh@nvidia.com designates 52.101.46.31 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775764964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=US/TPYRBbjndpDCKE3UhGYVEIbeT8xndtPlFe3vEhjo=;
	b=lDe2QZvArH3fMtl38No9kZ3KgZaMQYoyGJiKAcLa/PS985qSV+oru8IMYPSw1xQFftk2ov
	eokzPcHW+pZMEUoIlfOg9p7HD8dU9uYTObyks+gFNuWn4ka/rh0iEWKFqzUVwvy+q6OOKY
	Ywb7ROFQV2AnCtSYxDgji59bfJlvvNU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="r/13kcvx";
	spf=pass (imf13.hostedemail.com: domain of jonathanh@nvidia.com designates 52.101.46.31 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775764964; a=rsa-sha256;
	cv=pass;
	b=yO7FUAVqAgLE/uc85LAHBt2KDJw6gHrXr4jge1Y7py8Ka/879ttFY8SYOs3jmlxYSr+4Z3
	wzYA/xjhVQYAOlKWhrB8kSghwVRLZnC5wtIJqQTC4zZY6YSJffTRoaO8i3LLUjZrvSeMX6
	TVaytWEqT1hRz8clgyCIXhvzenJCDAY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a4Fji/pNC8Su0OisQVl18h1Z1PdnL4D2lxdj1OCHg3yAOFJlbl+lkh7Oo1aq5omwT+BvRyrLh+QypeilG+8/V6akBKOcUpJc8QBAbsqT2pBWpuEHmIzKR1+ajvsfhsl7YdxJpPMADlTVjlw8dfXosVu+bLTqIxMFR3aDwCdns4LstaFthSGif7IXuLLiv4MtWwbxqexKDmmhH7kcPJgOhueMHuI+hRHe0vu/D1z1al9yR2e4QpI1/OUv4dZ8+k4w+P3ylmOQnUYKx4JvronKVZbfRr7Hqx3kAvut/O3mJb6WuIsVGaq1kCNSd5OY160Q3zXyw3Est/8ytSx2q15Y0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=US/TPYRBbjndpDCKE3UhGYVEIbeT8xndtPlFe3vEhjo=;
 b=sldS00vd9XNjTc4ZjCBACUEzpvyg4OrC+fRXkMuFDLQ/XdrqpslLbJWVvfLu4VRntETn/2XfGf/scW7i1quqjova78+f8wtpya7F0XlshiB+8jt36nE2S5iwNeZ0Zw8YZHCWwroqaGwQK5caKjTPf5CY3oX4TI8H4NXETxbBTVQUoFEY9lW6LXJwEn2FGmr5jjT31VG4aYKrSIiFe3jFiQ4rCbKV6YesASAX9U6TXOQAsLU1Lm40AwIfi/+quE/VauZclXn1AmAbMDDaHMF9DhY2RHU2zLsnKVNMlwDg81TzfbmkLCXBcu7ZQxRDyU3iv2aE48/ooeahsTqAq4n1+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=US/TPYRBbjndpDCKE3UhGYVEIbeT8xndtPlFe3vEhjo=;
 b=r/13kcvxdwtR3TnEydhTBx6QUXVUDgFnRIa5J9mTDxT1bEk33gb9OH90+swvE9qDVra+ekop8hCHDk30sQaFrRB53dNDookHtRY9WcpWrI3tm/Z3UTuRFr3wBf62TUCadtNntFNBbgFLdPqaidDD+q/UILZHfYRP7wZ7xTigSSc7HNyHod/jNGRfwoFUXA2dl3KI3SIkLtv6LihptbbYyrhQa9Ovb7eANk10NnpUloadaLRkyDRiDVAOsG2mDMU08mnpu0xu5qlve49XCrLSJAyU7r1CAU5e6IB7Fnrs+oet6seCD4o+Xs0YJA1tQpVqfI4IzXY2yfXuQSwjtDy+Yw==
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by DS5PPFC9877909A.namprd12.prod.outlook.com (2603:10b6:f:fc00::661) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Thu, 9 Apr
 2026 20:02:35 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%6]) with mapi id 15.20.9769.041; Thu, 9 Apr 2026
 20:02:33 +0000
Message-ID: <da886682-c255-47de-90bd-8bd708a0ebdb@nvidia.com>
Date: Thu, 9 Apr 2026 21:02:28 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] slab: support memoryless nodes with sheaves
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <abE6uqdzMUv8k0mU@fedora> <8ab58ecb-1fc1-42a1-b67a-c3107de2ece4@kernel.org>
 <e7e4ea66-49cc-4996-a638-25f6cb08a42d@nvidia.com>
 <y5oqhhbecurzrj755sujnqyny6ohmyd4uhslrrigdgpq6shf52@nr5gp7bpit3g>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <y5oqhhbecurzrj755sujnqyny6ohmyd4uhslrrigdgpq6shf52@nr5gp7bpit3g>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0496.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:3da::10) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|DS5PPFC9877909A:EE_
X-MS-Office365-Filtering-Correlation-Id: 39632b4d-87dc-4af5-8ff8-08de9672f017
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	R5jPyQVuA7CQ6t4htTDO26Ws5/pEAVOmPQOrVDIWIqzqhLLav88Z3CCKKl4v0yssm0Du74RjId7IYvclPxCseB5PmZz9qIY7HOMNLuvjKJEhU4kWRQcRx3PzILR8KolHgAf5Hw9EMUvY0H1Pl4vOwvWxkhcGKjzfrrooE+MIu4EvFIav8f82quDDv4me382LuKFbq4/alw6O8DofAYPb7RXQdfLitnPFp7n38Qk/x0zrDE4FWQAV6/DespdjH9zQnw66feNnyayEI9+zXx45FeUbi3HuttqJ1wUxDxvr6iPn7Mmrnhg4tZ9AFBf9GzQiyPP9IZ6akrRm46045h06N+iYlzPJJ/k0dbXIl/F8IJPBzVoPt3LqcBRdRqp35hTyhZ57pt0a6yFUGgoK2UTkCfmbghQXbNK9bD04/SEzlDMPhqp2/pET3YJMS8RLH0nDtbvELTpGUh6iJ3njYMQ4YrIP1yS1Tet81UfRb3YluUjXQ3lRSkMNiyo6dwvdR18yk6DSINCP3+o0Ox56zdQ6dXiAuXdHONucnfWx/rO7AaV4J97MdfmY71FrqLAQU+dWcL7Q98RISgwGyk6wXpUsC1jTm321eLyRtYkqNWoP20+VZuzpKfo5+04Ls02GsFOL4zMOUTyMNwUVVOrUwvxoC3iJFVekMDSaoolP8yhyq9a8rhLNmJ5C9jG6L3XAHGJvQ0WToM+QsXGJOosnwnlX2DFnQYRHyTiDkq1Zus4GejI8EMC8Q2LR2kH1I3sArRUN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mk1XT0hBVmFFeWpKMW82M09OY1VoTXNLb1o2aHZaWkJZMzhQVEFPSXNtWjNX?=
 =?utf-8?B?b1J5dVloRjFLbUNvMVdzME9sRVZ0VmVOb3ExYVN2ZVJuVEI4MkREQ00yWjJT?=
 =?utf-8?B?OHJhREV1ZVpsaWQ5Nm1hYmZqb2ZSZ0pwdzZLTnhjUWcvaDBlTFFDdjFoMmV6?=
 =?utf-8?B?T3BIcWVNUDZPNUpGZFUvelo5SGdOb0NFNkJQNDVBZ0ErdUJ6OWJxUWR4QjR3?=
 =?utf-8?B?MVcrdWxXb2w1M3JFSEhHdlk5cG5MTnlWNEJZZ3NUMXMwYUFTVzI4dzF6cnZI?=
 =?utf-8?B?em92dklXbWt2YUtNM1RyVEQ0Z3FOZ29USmdTQ0hmanlKVHNJTjc0dEhoK2RN?=
 =?utf-8?B?aUJ6TFpmQ3JoRUphWng2aU03dnNiU3RkV3YyYytuWnB6bExENk04Q3orWFdF?=
 =?utf-8?B?OUxUdC9UTlBUM0lTWDhBOHlHNXZPZGNlVlhZUFNHYkJCVkJLL3RmVHhSbHZj?=
 =?utf-8?B?SUViZEIrK1lML0hZSklxOG82a3FzZXRpaDlXbEMzbjNhQ01lMUkwVnJRNXRU?=
 =?utf-8?B?cHJ2d0xUZEVLY1BFaW5ReGh0bmhxSkYreWl1SitZbUg1eTYxemxQRjJCVlda?=
 =?utf-8?B?TWJkbG0rZ0c5Nk8vQjdtNC9nWHQ5c0c0ajJYV3lKdnM3MXo5NFkrNUFDNDdz?=
 =?utf-8?B?d3dvaWs1bTZqb3lMeFRhYkk2T0JFZ2t4VXV6aW9xWENvNjQxVm5FaHptcE1Y?=
 =?utf-8?B?bWw4bGZrT3lmdUIwKzQ4ODluZ3poekxuZnhGbU9RYXkrTnlTTDcvRnlVOWN2?=
 =?utf-8?B?c0hjSkQ0bzVsbzVWdG9SN1puVFVNM1o0VGJFK1dEQUp3MHdUeG5qK1JqVTlw?=
 =?utf-8?B?TVM2aXpFdlhhdTEyNFVOTDFvTFRCQmlNS2I5UHZ5V1pYV1V5MHQ0R0J5VTBW?=
 =?utf-8?B?dFpWZ3RtUlE4Q1BuOTZPTWJObEl6THp5UUFWWGhyM1BXWnVkVXExMkpCZFcy?=
 =?utf-8?B?RGxnQ0NJTWl2MmlwdkNuZ1M1NEYwYzFuZFQxWHd4ZzN3ZVp3NzdkV0dsdjVX?=
 =?utf-8?B?a2VlODBDL2hLM05JeU5GZUNYTzNrV1U2ZE4vNkltR2RBWEhDbHR3cURRd25q?=
 =?utf-8?B?a0dBZUxWUE9EdWwwS1FOci9CU1drUXJKNndVL3BjNkFOQ2ZxckdMeWdKWHZO?=
 =?utf-8?B?dnVrN3RoWWJhaXpkL1o5SFo3eG5xbnhtRS8zbU5oemhCTWZyOGRRZTdZcEp2?=
 =?utf-8?B?RDJ6MGVrbzlYTG40aEFpaUd1S25aOEh2d0lHc0V6RVFHRG1ISXJ1MWx4QXVk?=
 =?utf-8?B?VTQ4dGVZQ0tET21Cc0ZqUm14ODU1QWgvc2dYa253SjlKNmdjYUtybG5FSEFU?=
 =?utf-8?B?VG8rMjRCUXFJQzdxOHlnSnZlTElSVUxSSTE5a2tsOS8zRFFUd2x3ZW1kQnJq?=
 =?utf-8?B?anUrQlVvR3VFM0V4Ri9RaGFoY01OWE05RVkxWkpHVDIxTmJVbmxuTkN2ZUtS?=
 =?utf-8?B?VDd0R3BTN2x1VDdrWHJFTmU0QzBpWmMvQSt3MWt4TWMxRkZQQlovMlNnVjV6?=
 =?utf-8?B?S3RiM2psK0RjUmJ0WkRjMTFidTNsYkFITDkyUE9meGcralVOaGZUaTdHbVM4?=
 =?utf-8?B?RjFDcjdnelB6RG1kMXVqL0ZEMTdXM1JvQ1F2YXB6WHRhVjRMSmNCVHl1UU9S?=
 =?utf-8?B?TG01blA0Nlh4OGkzNlFKYXRMMDMvOGZVQjRMczNoTjFGN3ZVT205NmcwVUhr?=
 =?utf-8?B?WVE0WC9VazE0SjN5ZWNrcFdEb21RVzRNU0x6QnBXSzNuY2lIc1M5VWRzVDMy?=
 =?utf-8?B?RUNha0ZPR1VydWE5b0E1Z052NjR4YXR0dG5XZm9nT3hvWkxORnpWajFXdjQ2?=
 =?utf-8?B?S0xUc2k5Q1pDSVJKMisxbEdmREJwQjM3YlpFYW55aFRmM2NydTh1cWwwMHpR?=
 =?utf-8?B?eXczemdHNDdyR2JGcjFYNW5YSnY5K0c2UzBGYkwzRHJqUEtMMEJmc3VTUXBh?=
 =?utf-8?B?RERpR0Q2R0dEZUxhSDc4VjNqaWVMUFgyNkV6TklxNThLMm0zSGVvOFZqZXZR?=
 =?utf-8?B?SWNLV1ovYXdHU1hGMCtkbEVBWGltQ05WUTNST011bDl1LytTcE95ZllHYzgy?=
 =?utf-8?B?ZnVMQnhwMUhvcm9zRksyMzR4aUJ5RlUxWTFqdVA0VElZK2tnSDh2bkNxZGY0?=
 =?utf-8?B?b2hKbzVvdlR2OHVGSDRpUFdHYUZpb3BoVk1NSDJvNkpBU1lEMW9Fbk9TU25q?=
 =?utf-8?B?VTVnY0xQM1YzUUtqSFlYeXBISXlLZ0w4dXlWOGMyUnM2VEZZZEpmNUIyYzBV?=
 =?utf-8?B?amRrRm1mYkpxUWlXVWl4Y1lkeUhKUE13L3BiYmZuc01mdGxZMmFaVUhJdjhO?=
 =?utf-8?B?VWdVWWxJeUNGQXIrTUk4YW51QmtTNEs3QUptN05NaUpUSW5GR3Jsa1ZtUEk3?=
 =?utf-8?Q?Ag19H99G+mLTRV6z1m3qeir7kiblHafNn7xh18HIbjGzw?=
X-MS-Exchange-AntiSpam-MessageData-1: 7c7D8yDS3KyZGw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39632b4d-87dc-4af5-8ff8-08de9672f017
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 20:02:33.2460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XVG02U2hoF5K8LgU0E2FzR3Z57/yOjfErswVA1bkLoiWwnV5MZQDDIh9PKpWwAzbPqEZnWYnczWUhucQi8BgLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFC9877909A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4570E20009
X-Stat-Signature: tmyy3k53yw6wayi9xe1iw69jhgebns1p
X-Rspam-User: 
X-HE-Tag: 1775764961-752241
X-HE-Meta: U2FsdGVkX1800b5Syl34Pold9vYz3A2qqYLZdnKp7NTMpSRQo63FFfEtDSls8UNvkSMMUeh5uX0EOZahenWBwerjNb5bnguNmJKmZWyruL9/O/VWhloGiJ0BnmmjCBby6IexoQDxCiMvQXv+w1ajuBUONnSLv60M0twRynEOxZmSO2abeFu3D4QWGZfwoqKMwOq+y9vTJsy74w2xSja2IvQiubjavc9wuf6YLHG8L4Dqz6D8vECdZF4VT+d73JRVKCEloisICrsI8vJsDhNGPAmr1HplZVvL2DDrNPdW4lYXrpz7SuxCVnAVwtx0EgX5HhJXfW9ZpPBdWgDvjhljfrX/tnHxWs3SyxwRgADrqUMz1zzGX+zQTdhEOTaZSdIk9Ot6Oe+Hojoz6MMobhScDanQmNe/Zi9F9hNdeMO/46DBhxkOS+0nJUi+DXo4xkwAn/0uPqueDFuz0ZnXltYPXMUdZ8bpFuLMEwAjIbLNIQWAue+pyo3h8oiXUbqGEmh6J9s87QHNoe96khOFNP1ecjVkCiofRFAYv29N5h5JZRa2YFtMJHKC3hesxS3emw3UYBesPTJRQSvOh5CpW0YuCJISQq1CV6CxxrEuKuWmc61JtMPnL2YXcN9i6y1v6HPSt37Al0YnDtV4CHpYhBP85jJ7L1rcmEycrxJ3slLvyLcx1qNvByEDg4gfr8IM77iCw56kmaurMTXBZA4m9lbzzkdkeZfv9vFjVxNTUEBK5Xy5a6Dvt3ucEtpZYbkKDCJIF75fVplUBRO7V25AI3s97O54a4CbZxwnPIDZvWy5li119geu7yLNBZo0rC4qXjdqpPk30bcov+TywDP8y/ekfrkG5R19wuKSxzchnUcmGKxSdh9smLYzDFFSh2a8PK4a7T2kWheynYfeSW7ZvZmlJypV79WptHzm1ferjm3d7dh5FV+PTQvPTSQ6KIU7NlwX2QRy6kndMR8D3FCNR5y
 3zKBJ6YG
 +yekZSnovSCdom65MuuTPhmXu/Xv+ggQnOorqxHBbIsw+r7UYmc0XLuTVubkliZmjNoUWZTw+rPZZGMapPCLkx66OMBvRiPmObOEi4thXrz7hA0088ydqY5yAFVVff3Egdl66fhmTjCdul8rnWLrSFlJ/SrKyPnoQ4Da6QWalH/hxKMmlsleD9s9w9zxfWBroqXUG0KPebjrlPFelJ8798ILMtZxXcd1LzJX8w/NG8XDNbOlogzX5qS8a7hHjDwmh7zZK7gdMwDWl8+v456o5TJnEL5ufUBtA4bpw0JisMyYPYgJ++nNwIvbsqRuqTUqgO2NI/QgT3nuD/TQSA7mccTZBTqGvjiT86b7NhkLpdTmkCuut3jUxqx/BNTDYaAwpvqPJSLf1o+pH3g0g5Pfs8hhtKK8MP2FwOXH/toXyWpKJD769uz5P7urhXgdfuv1LX6GQEke0JBNwCs7nGyOvvZnhxp+Q/GadC8TP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 08/04/2026 15:06, Hao Li wrote:
> On Wed, Apr 08, 2026 at 02:04:54PM +0100, Jon Hunter wrote:
>> Hi Vlastimil,
>>
>> On 11/03/2026 17:22, Vlastimil Babka (SUSE) wrote:
>>> On 3/11/26 10:49, Ming Lei wrote:
>>>> On Wed, Mar 11, 2026 at 09:25:54AM +0100, Vlastimil Babka (SUSE) wrote:
>>>>> This is the draft patch from [1] turned into a proper series with
>>>>> incremental changes. It's based on v7.0-rc3. It's too intrusive for a
>>>>> 7.0 hotfix, so we'll only be able to fix/reduce the regression in 7.1. I
>>>>> hope it's acceptable given it's a non-standard configuration, 7.0 is not
>>>>> a LTS, and it's a perf regression, not functionality.
>>>>>
>>>>> Ming can you please retest this on top of v7.0-rc3, which already has
>>>>> fb1091febd66 ("mm/slab: allow sheaf refill if blocking is not
>>>>> allowed"). Separate data point for v7.0-rc3 could be also useful.
>>>>>
>>>>> [1] https://lore.kernel.org/all/c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org/
>>>>>
>>>>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>>>> ---
>>>>> Vlastimil Babka (SUSE) (3):
>>>>>         slab: decouple pointer to barn from kmem_cache_node
>>>>>         slab: create barns for online memoryless nodes
>>>>>         slab: free remote objects to sheaves on memoryless nodes
>>>>
>>>> Hi Vlastimil and Guys,
>>>>
>>>> I re-run the test case used in https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/
>>>>
>>>> - v6.19-rc5: 34M
>>>>
>>>> - 815c8e35511d Merge branch 'slab/for-7.0/sheaves' into slab/for-next: 13M
>>>>
>>>> - v7.0-rc3: 13M
>>>
>>> Thanks, that's in line with your previous testing of "mm/slab: allow sheaf
>>> refill if blocking is not allowed" making no difference here. At least we
>>> just learned it helps other benchmarks :)
>>>
>>>> - v7.0-rc3 + the three patches: 24M
>>>
>>> OK. So now it might be really the total per-cpu caching capacity difference.
>>
>>
>> I have also observed a performance regresssion for Linux v7.0-rc for some
>> graphics related tests we run. I bisected to ...
>>
>> # first bad commit: [e47c897a29491ade20b27612fdd3107c39a07357] slab: add
>> sheaves to most caches
> 
> Hi, Jon
> 
> Thanks for the reporting.
> This first bad commit is surprising. In theory, this commit seems couldn't hurt
> performance.
> Could you possibly manually switch commits to verify this bad commit again,
> without using git bisect?

So I went back and checked out commit 
e47c897a29491ade20b27612fdd3107c39a07357 ("slab: add
sheaves to most caches") confirmed that the problem exists there and 
then reverted that and confirmed that I no longer see the problem.

Jon

-- 
nvpublic


