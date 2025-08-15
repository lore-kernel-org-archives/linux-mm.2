Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E25BCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D36026B03BE; Fri, 15 Aug 2025 16:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE79B6B03C9; Fri, 15 Aug 2025 16:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87D06B03C5; Fri, 15 Aug 2025 16:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2616B03BD
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:57:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F32411737B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:57:26 +0000 (UTC)
X-FDA: 83780202492.08.651FEF2
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 468B4100007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:57:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CvlE7B3d;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755291443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2Mrvyt/8+7ldQWLC/DTktEiEdInAEKY6qseS1120ac=;
	b=BysjXBtoDN6OkwtIUAs+g/iO6QAn19WNuWmMYmdHzNczo7uI1fw436qN4wwl7BDSFGDB0h
	IpxckG6P3kCEoyVVCoipQu5eeXYHsTYR23/Zy7/sxo/NCRmt5kLeTlaLCePr6LOpYIviXg
	Ww3p5DYtXLlr38+YlmCLRyNukofczj4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CvlE7B3d;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755291443; a=rsa-sha256;
	cv=pass;
	b=RNrGPS2QtiBS6Fucug4qCoAg8CJn4XmEZlP9DYcd//+Umq9GNmAaIObz8lp3KcpY7G9814
	AcZEPtSf7kR0Jl1yYpYPu1bf7zZIsEgD2zf8NrlLJAGt9jukMg8ZIfTkmNIfTzFN5fbbf6
	cqMjyaKFXeIg6gzOnTKTJqqfgZ0ktnM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uP2O38JsyEtZ5DKDz10hlOgQPlPTGCIMXmcAn3QIwjhLeE3KwGh8qYgazrO0ATBwnUlecH3/Zmsek/MgQeWfG3Sk4qAz+NYT1hwb7bnPDb2lf8hViaMath9bT8UjEGFSiW6OqO2KJTIQ+z/2yUaNaFcNcSTvx6ijq1bOXrwDSsLGvw2xcgbNK1agimPFw0twNQZMA/TTeaglKT186c2fgfujIq0sST7Rz1FGOqxCf5jeJ+Rl6UxuoimkG9TxyMrTA5WWKUz0/ahfz/AKqAI/U5YD/dzTALwps597LQt8AmFdtZLTWIcPw64pfLvsZGNDLrSDVyoOjVgMWSBa/C6MkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M2Mrvyt/8+7ldQWLC/DTktEiEdInAEKY6qseS1120ac=;
 b=zSpcgn/8JJ+EGOMrJjhn0I2V7Vqi8Ly7JwUHY/8uEOFFoR0MNAo2EJu0eL5wvkSR8TE9wZ8QGeVzdMG3A7ZzVV4IOvl1wq1Xw3NFvcfS2ddp0lEE10ZHLU9cNBfv5csxaAv3DXJyNQnPKOb1Y/KAJS1V0r3NMzt9/WnFWpVxsYNEApBxLlboQ1Fj9wtLGSl99fJe5FCq8sq5vHpWNPP5ZS9fErWYLTNGvll7dSPXHzhQLlJdvsjCTAjD/zAcTfvbQZvLtjPwEw8lIyTWymYeMGdeWsrWl9xVRTC7GOFI2ga2UQHj1LD9MtG2UVoljGLarAnBPijTAsMnmW23qC0LVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2Mrvyt/8+7ldQWLC/DTktEiEdInAEKY6qseS1120ac=;
 b=CvlE7B3dFWJiGIWMF3qQngNi29EYPkQ0vW4Whn9soSXfzclgcM57IBrZJhMMlvmjgwBZURKG9GxgVaCBSbO0Q4lSj3Du2P2c8UNrBV7YF5q0vAf8ItrbQ+daSmNvch8LRNLDK6cgXLBPlljQoETEs8Fm2Cn0bw10hS3GB8In+0BWrydsbDKuiqq6vFzPKJYnN23hHlpaU182dCxnIsZbWALaTLTPIDSImJLmKyXkcHukytMZcKUidRq9pWbCyOjUNIfXXuW0LqdGlyrtPCSx9F/hx2Q3SZYfINIssgWNEFNpkqonMYuP4CTlY7+Mf9IcMlmfA5vENZ8mcw5LACmEDg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6459.namprd12.prod.outlook.com (2603:10b6:208:3a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 20:57:19 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 20:57:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
Date: Fri, 15 Aug 2025 16:57:17 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <DE838EF6-AC8C-4DBC-A280-0E906942EC42@nvidia.com>
In-Reply-To: <20250815090539.1578484-1-chenhuacai@loongson.cn>
References: <20250815090539.1578484-1-chenhuacai@loongson.cn>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL0PR1501CA0035.namprd15.prod.outlook.com
 (2603:10b6:207:17::48) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: 69178d6d-3d7c-48b1-b3da-08dddc3e52e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ivLqu28t70T+iydx59UtD9VWCh9iysYisxiGoQgbbNfXrAkU++z4vEzmhyYn?=
 =?us-ascii?Q?QAj2w4OaUl0ZI4ZLy6GBEqeJkC71thpye/Fx/o/XWPYkb4hCM8kMjrWREXLs?=
 =?us-ascii?Q?BNeVmAmu68rqUcnbUUq9EViHmNvJe3v3AnmZ3O0rwWsS3ziDxdMY4ORz3mCq?=
 =?us-ascii?Q?Baj89UcTqhWjJYjMGDORi1xrWAq21oGmF8GTepAwu7AaeLPb12qCXZW4upyp?=
 =?us-ascii?Q?9MXoZZNSZ4JQGfjPcIydh+CN8RVYlq0dhyZu72qlao7lRffiLmvzAV4jXQ6c?=
 =?us-ascii?Q?7mQ06IVkIJL93oI1LPnUD6ly+NGKSkaXawMxY6QpMny4iWMxR8/PbcTGt60C?=
 =?us-ascii?Q?Ab5NeUO6JtQz5bhMgo9anwf0me/50CMW31FJSertca4e30F+W/AeuH1L4YJK?=
 =?us-ascii?Q?tADM03kd8rheQ5fZZcgAWMz2p6iAZbZJj+0yIPxFKpz33rnwGs156lHF2l1E?=
 =?us-ascii?Q?S6ET9XeNqqB0VWvRuUQFSn57i7MnYsgr1KXAvjPX4j7eGaQiowNtimfORyAP?=
 =?us-ascii?Q?wqC6X4sNVuRBeyJh2IDI60SOEFjJQ/IJqSsfRJ0mOcJ2xuzXtTAYMKYmvA9X?=
 =?us-ascii?Q?7NP4aLqmi9ddMTOK94zfBMLzZXVvCRItTOqLuche1BFpkoC0f4PYpl26/A1D?=
 =?us-ascii?Q?PySSlwLuBeIb/cSgoedvpwvXN0mezUA+dhEWfjEaRJmlzrQH5PTtckgXPbM+?=
 =?us-ascii?Q?+jKANWNL8bObRG9Cqn523SYfrZxLWMjK8hk8mux0DpV7CL2N4dJYjAf5F2sZ?=
 =?us-ascii?Q?vXXXhTB0dXEtb4t4t2FDZ5+pTh2wWTlR2O5YRXsJLv5w8AKE8U4txytcQMiO?=
 =?us-ascii?Q?G+WeIM6XqG67yYGT2aLUAjlGDuL5uuRLZ+tZjbKJqAlYROAI6M+Nah6oAcIX?=
 =?us-ascii?Q?pa5h2vVBXkXHxwydJ0hfPPUpPnDi/1BR+eU/eRI8sOZp9TjCu8CHEyXs+XTP?=
 =?us-ascii?Q?rUrAGxo5TCx7OSETQJU3JnZlmqBlHfyT0B1f5dYGWno0VPiQKa/lbQT5Jh+v?=
 =?us-ascii?Q?M82q0NDjfB0whrjnvWM+8BSh6qm4rX0TocwevQK9LSzKIjb47MYgEJz87MGu?=
 =?us-ascii?Q?uQ9uKIl5yxlu+Emu/01hGTIO9nd9gQhK7zEAh0nDNaUD8n59NEl8wN+tNJgx?=
 =?us-ascii?Q?52EKiU/cGhGJJIvigmuhKHqVE9H19qJ4/kdrWc6JtUo4LwshtS6do52k0svA?=
 =?us-ascii?Q?YI7sze9C1HoNK/HGCzkH3AsFMo3GA/bTt3zMAtbUN8NjuGFicAlBYZW5PnUD?=
 =?us-ascii?Q?XjG+l7+CQTTdAeYMhInRGx/kUflMoQUIhycJJX5f/LKSWXuQ4DHSQUef5HO5?=
 =?us-ascii?Q?v9DpwTjH6mL37PmXt6Ienw0VgqmPkBxDYbTvKJBE8PQRcu8tCt6h+udoaSE2?=
 =?us-ascii?Q?iYicE4g96fJYdAf5wHB8ul0nMMoklDahZqcmnW21tgKfvDEYvA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hTc4WT4QbSJvFdkrqtQlZd4mxx8dqJiBuYuXjyIHAjkrLS1MLbE1cnc7D+RO?=
 =?us-ascii?Q?2GpcHjFHGgu9TU0ikaGVonZ/CCKS6/LQGAR8cWLBowMiZYBbqwJPxx3OxPA+?=
 =?us-ascii?Q?JxOfC3X3e6t1UxlmA+3cmD85neRMFG9XCUUoyv71eaxN4az+Zmnp3iBiIW6n?=
 =?us-ascii?Q?OULPGjHgYFMTXWyILIckdJsWH3ncsbbqAZ3LxqP2i+KYEGiZVtYad9l4bLRj?=
 =?us-ascii?Q?RozinQdC/z7ZS72181YDO2O+Pf+32Ck3Igylxt6ofWvVprUN/wf1tXRagrL/?=
 =?us-ascii?Q?rELZgKa7flwvnNwttqCeq5AYAOiH3JA+NSxf2Snf0AFz/6PHgxV0GWPWZRnt?=
 =?us-ascii?Q?eQbd/ieqKpa0bFrtuWYOOyIdXSwNPDhwfaRegDVm/RNyPoESPMpEzA4Peddx?=
 =?us-ascii?Q?oljWg0JpKQD7g7i5xZSlo6We2kD7YrdHsT0tIuEsvLTCvufW1/z5fqX0jNBR?=
 =?us-ascii?Q?Kv+kJNfLxN8QryFUm4/D8+RM9xwDca50MkmoW4WvvnXJRgzKBZq76aS+mOPj?=
 =?us-ascii?Q?Gt3tRjBqiSmClQQpJQ1qen+quX9522KgvVsWh4giVid3dOlSARHa97+UF9F4?=
 =?us-ascii?Q?dcyMhLajSotpDDDfPZL/cIt6MJJSgaCzeiWHBE5Z5gXkcINmnJdpyMX2KMPa?=
 =?us-ascii?Q?Q4QyURp35g8+1XDKXyVFQavZdsYNQMLnfT3d2CQk36PsJf0hDK4iXJDYLN7d?=
 =?us-ascii?Q?P6rF0kUFP8gVHyXfLj9dkn0fJhQxQwgzUDJ4f9ktAh/r0bWc2e/C+tG5kfMk?=
 =?us-ascii?Q?yLcJv+wy6RpXraiGI9dHGRpaUuveS9M5aAQIdITI300+Swr+PKTm494aA2Up?=
 =?us-ascii?Q?IKh7oaTZSzwpY+pocYjA6H9/P3Z+SSPMdEeeyIlTOs8tb03S2GsOeix+WseC?=
 =?us-ascii?Q?fNHd5hV1TMWcscawNlrEbRzeV0ehJuMb0N/UwbkGGj8AkFFExLRfzvNcqbv2?=
 =?us-ascii?Q?IqF1Oi9jt/uKkkS7VDyNI7c1g2bb+1c2OOiT8H8/VoSgAjXqoTBP3EGx/IrL?=
 =?us-ascii?Q?m5FWcAIJ5ShKi4SO+PEEgPna0lXYTDRO/tGY2R6CUlqpy9lxpCsKSSaxoLOC?=
 =?us-ascii?Q?hrXwfjBLcEIx7MF5KjTRF7/5VXfilJzQKfIzkjhdQD75OJyKUetw4JCYZ9W5?=
 =?us-ascii?Q?t4Pyb+Vgnc9a6VOJ73DSA/NzcjQKB7ePlK3CTu4zxdEWC9gn+rv4zTW+2H0j?=
 =?us-ascii?Q?jsfGpQrqMYkmlQcjqfvrjbzM/UOS3MkWgSO+RNPxYo9op1jSQhIbdGXb5HiS?=
 =?us-ascii?Q?T7K+jPToLRAln62iwCiwgR28Ju7v2M1So5FnTTJ8Ey/M7ce+D9j+asd/4pUe?=
 =?us-ascii?Q?0ScmPSTDRTJXEv9YU6DR4YkOA+nYLFeXBEX3XnItFo1deH9I9bECoEoOERnB?=
 =?us-ascii?Q?/rzzNhygg6CIhq7eKD5rN3yTNy16ZZFsl0XiJ1Ut39qDo4UcjOcFzgFKrZMi?=
 =?us-ascii?Q?JMMLyWmldx3OlgZLziwYImzH5aEMfsaf3B6T6hW2KEkI8nQXIfQETpJwneRu?=
 =?us-ascii?Q?N+EcJ0nRbYtMrF/3JszXxsn8D79dMXVXWUi72BfkOZGdWRnTe5m2mBllC+u6?=
 =?us-ascii?Q?jDeMgDVxNMb03ypHulz+wnYNoYJRUSXfZSbrJTic?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69178d6d-3d7c-48b1-b3da-08dddc3e52e6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 20:57:19.4576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XBoGCKljKvjmrU2FCFzDs2lF1/ZxmsCggxfUTl7PAct+0j3e09lPhvbeNWfD04jY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6459
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 468B4100007
X-Stat-Signature: n6wbxzgx1c9jqr4ozqmapmqs4mtm67g4
X-Rspam-User: 
X-HE-Tag: 1755291443-550830
X-HE-Meta: U2FsdGVkX19H9u8VSRecR9MHxOzBfsgMFXO//FcZn/P90uBTl1eVCoOJDyl/s+9lY3e8mdLLBtjOLkWfk5apStthYH5cseFdhWOgb3I6g0InkZDQg7r2tBCU/jlSCXZKoHJObRrI61NAAry0Qu0/p858z3K2BLMb5SehrFgBnWYydHifMSUD3h1WlYMmPQvoMks5MFfq/Pui/vXBaKE2pUKZMQ/HXhQxjIIYHIvMdjtcxqjo/FPKTw7rQyQYQVWPsFWSeXUCulHzOCYMmXWXRvvMuRvZ0RJFxEl+74i+LbDj8XyB7TUQr1RjwhsoJmokEoL4N1BbmHklwTgfyaLkKCr7kPtoLpmf7cLw7rjMFFLGYnIBpOps5IBGn5HRk1nomIcczai+zHD66/RcrtiXn6jhbdmZLfUt+qmubhcl8piJckw7xZ0UGopyJvhhXbn51wGLhxsxWhZOV+h4X8rQi9JLaliUAuU0IXzlioiZ7xEISBlBrEisYuDvLb10/vEQDFTGcm+ZqAYu4t2k5t6o4NCjUV5ruHY2b0HpEJ799s9tOaTx3n0Q/oGGA88BfkH+5ec3GaNSw4u9DOt+yAotxvapEV5/aDsVtFbyouG1IXxMlWyiton4WqrR6YyzKfTHDcnWlI7TAiwAefO9KC7cs0THQGVksGgqSIIFkYHMZOhYDd3Xg5tRQqqa2EOY33xQ7KScu2HESR/R1FmG9VSLBddY5pFcjSh0cnXHKncEUmDDGMeOECfgoS8VDQUABUM6t0AT1th0SeB34gRUqfrzWHjkoQ7GAO8IETU6rGuz55iwaSxxHLteMK4MR4vG/MMsk06F2RR/TmEckW3cVlCWYwuEaKWMJTKoqdCXgYXOYdgs6ivmAgxBsV3m3nf5IHmMVhNxY32Grp120Tf6FQsRNPM7YL0O7XSLp8QZOqBt+cgI6yFrCNKYci0sMzIws9Ddwy/FJ4MFe5FRq6pK47h
 mLs+k3rA
 rzufNH4zFqpRGaLt047Vv4YEQVySli+oMc8aieAQ/mgOY0vDqOFvuAhE+vPyBlh54l1KHuQa+ciAFiqfARKFyMrPqbtl7NtHKgvCcC+L84GF+FEjzCvd00rrVMas+kQplip66Vn37E+fgrQ8x6ZhNa/w9NHNp3nDeM19YmvCemCvQl4eRw5OcyP90R3/1OPxz9pGnVyklhI7rey/rc8QolAJuMuf6TBSPYMSosv4Qcwr6uBjlpiLEXR3kRPDrRVg4vYoltJnWYxGxh+8vH52XIXm4cepUFOn/eOt5tyaPImTNviu47Lz+5TyiqEdmXOv5hPbGxlD4SuLwmp/ntRiE6G01t+vzfxLO14jA1huewVr/EBooJUWs1dpug1LveFP9ae7DBN4C9e/HpOhG3XjZVHxaJFPLNjYEgZhu3zVL/sHYcjoFV5B4w6ny83q5X+RqxMuoZMP1lH8l7B/NfXH6wPHOjZN759Z0GgdfFxKx9wmUBSSwe3MM7KrYWhZlhUR/ZNz5WhmLsk+8Mj1S5y5i1sOV0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15 Aug 2025, at 5:05, Huacai Chen wrote:

> After commit 84caf98838a3e5f4bdb34 ("mm: stop storing migration_ops in
> page->mapping") we get such an error message if CONFIG_ZSMALLOC=3Dm:
>
>  WARNING: CPU: 3 PID: 42 at mm/migrate.c:142 isolate_movable_ops_page+0=
xa8/0x1c0
>  CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 P=
REEMPT
>  pc 9000000000540bd8 ra 9000000000540b84 tp 9000000100420000 sp 9000000=
100423a60
>  a0 9000000100193a80 a1 000000000000000c a2 000000000000001b a3 fffffff=
fffffffff
>  a4 ffffffffffffffff a5 0000000000000267 a6 0000000000000000 a7 9000000=
100423ae0
>  t0 00000000000000f1 t1 00000000000000f6 t2 0000000000000000 t3 0000000=
000000001
>  t4 ffffff00010eb834 t5 0000000000000040 t6 900000010c89d380 t7 9000000=
0023fcc70
>  t8 0000000000000018 u0 0000000000000000 s9 ffffff00010eb800 s0 ffffff0=
0010eb800
>  s1 000000000000000c s2 0000000000043ae0 s3 0000800000000000 s4 9000000=
00219cc40
>  s5 0000000000000000 s6 ffffff00010eb800 s7 0000000000000001 s8 9000000=
0025b4000
>     ra: 9000000000540b84 isolate_movable_ops_page+0x54/0x1c0
>    ERA: 9000000000540bd8 isolate_movable_ops_page+0xa8/0x1c0
>   CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=3DCC DACM=3DCC -WE)
>   PRMD: 00000004 (PPLV0 +PIE -PWE)
>   EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
>   ECFG: 00071c1d (LIE=3D0,2-4,10-12 VS=3D7)
>  ESTAT: 000c0000 [BRK] (IS=3D ECode=3D12 EsubCode=3D0)
>   PRID: 0014c010 (Loongson-64bit, Loongson-3A5000)
>  CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 P=
REEMPT
>  Stack : 90000000021fd000 0000000000000000 9000000000247720 90000001004=
20000
>          90000001004236a0 90000001004236a8 0000000000000000 90000001004=
237e8
>          90000001004237e0 90000001004237e0 9000000100423550 00000000000=
00001
>          0000000000000001 90000001004236a8 725a84864a19e2d9 90000000023=
fcc58
>          9000000100420000 90000000024c6848 9000000002416848 00000000000=
00001
>          0000000000000000 000000000000000a 0000000007fe0000 ffffff00010=
eb800
>          0000000000000000 90000000021fd000 0000000000000000 90000000020=
5cf30
>          000000000000008e 0000000000000009 ffffff00010eb800 00000000000=
00001
>          90000000025b4000 0000000000000000 900000000024773c 00007ffff10=
3d748
>          00000000000000b0 0000000000000004 0000000000000000 00000000000=
71c1d
>          ...
>  Call Trace:
>  [<900000000024773c>] show_stack+0x5c/0x190
>  [<90000000002415e0>] dump_stack_lvl+0x70/0x9c
>  [<90000000004abe6c>] isolate_migratepages_block+0x3bc/0x16e0
>  [<90000000004af408>] compact_zone+0x558/0x1000
>  [<90000000004b0068>] compact_node+0xa8/0x1e0
>  [<90000000004b0aa4>] kcompactd+0x394/0x410
>  [<90000000002b3c98>] kthread+0x128/0x140
>  [<9000000001779148>] ret_from_kernel_thread+0x28/0xc0
>  [<9000000000245528>] ret_from_kernel_thread_asm+0x10/0x88
>
> The reason is that defined(CONFIG_ZSMALLOC) evaluates to 1 only when
> CONFIG_ZSMALLOC=3Dy, we should use IS_ENABLED(CONFIG_ZSMALLOC) instead.=

> But when I use IS_ENABLED(CONFIG_ZSMALLOC), page_movable_ops() cannot
> access zsmalloc_mops because zsmalloc_mops is in a module.
>
> To solve this problem, we define a movable_ops[] array in mm/migrate.c,=

> initialise its elements at mm/balloon_compaction.c & mm/zsmalloc.c, and=

> let the page_movable_ops() function return elements from movable_ops[].=

>
> Fixes: 84caf98838a3e5f ("mm: stop storing migration_ops in page->mappin=
g")
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  include/linux/migrate.h |  6 ++++++
>  mm/balloon_compaction.c |  7 +++++++
>  mm/migrate.c            | 16 ++++++++++------
>  mm/zsmalloc.c           |  6 ++++++
>  4 files changed, 29 insertions(+), 6 deletions(-)

The fix looks reasonable to me. Just a comment on EXPORT_SYMBOL below.
Acked-by: Zi Yan <ziy@nvidia.com>

>
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index acadd41e0b5c..58fac171e4d5 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -57,6 +57,12 @@ struct movable_operations {
>  	void (*putback_page)(struct page *);
>  };
>
> +#define MOVABLE_BALLOON		0
> +#define MOVABLE_ZSMALLOC	1
> +#define MOVABLE_MAX		2
> +
> +extern const struct movable_operations *movable_ops[MOVABLE_MAX];
> +
>  /* Defined in mm/debug.c: */
>  extern const char *migrate_reason_names[MR_TYPES];
>
> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index 2a4a649805c1..a1d2625b5c39 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -254,4 +254,11 @@ const struct movable_operations balloon_mops =3D {=

>  	.putback_page =3D balloon_page_putback,
>  };
>
> +static int __init balloon_init(void)
> +{
> +	movable_ops[MOVABLE_BALLOON] =3D &balloon_mops;
> +	return 0;
> +}
> +core_initcall(balloon_init);
> +
>  #endif /* CONFIG_BALLOON_COMPACTION */
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 425401b2d4e1..92918fab3e1a 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -53,6 +53,10 @@
>  #include "internal.h"
>  #include "swap.h"
>
> +const struct movable_operations *movable_ops[MOVABLE_MAX];
> +
> +EXPORT_SYMBOL(movable_ops);

It is only used by zsmalloc and balloon_compaction, maybe
EXPORT_SYMBOL_GPL_FOR_MODULES is better?

> +
>  static const struct movable_operations *page_movable_ops(struct page *=
page)
>  {
>  	VM_WARN_ON_ONCE_PAGE(!page_has_movable_ops(page), page);
> @@ -62,15 +66,15 @@ static const struct movable_operations *page_movabl=
e_ops(struct page *page)
>  	 * it as movable, the page type must be sticky until the page gets fr=
eed
>  	 * back to the buddy.
>  	 */
> -#ifdef CONFIG_BALLOON_COMPACTION
> +#if IS_ENABLED(CONFIG_BALLOON_COMPACTION)
>  	if (PageOffline(page))
>  		/* Only balloon compaction sets PageOffline pages movable. */
> -		return &balloon_mops;
> -#endif /* CONFIG_BALLOON_COMPACTION */
> -#if defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION)
> +		return movable_ops[MOVABLE_BALLOON];
> +#endif /* IS_ENABLED(CONFIG_BALLOON_COMPACTION) */
> +#if IS_ENABLED(CONFIG_ZSMALLOC) && IS_ENABLED(CONFIG_COMPACTION)
>  	if (PageZsmalloc(page))
> -		return &zsmalloc_mops;
> -#endif /* defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION) */
> +		return movable_ops[MOVABLE_ZSMALLOC];
> +#endif /* IS_ENABLED(CONFIG_ZSMALLOC) && IS_ENABLED(CONFIG_COMPACTION)=
 */
>  	return NULL;
>  }
>
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 2c5e56a65354..052fcc0d29e5 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -2246,6 +2246,9 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
>
>  static int __init zs_init(void)
>  {
> +#ifdef CONFIG_MIGRATION
> +	movable_ops[MOVABLE_ZSMALLOC] =3D &zsmalloc_mops;
> +#endif
>  #ifdef CONFIG_ZPOOL
>  	zpool_register_driver(&zs_zpool_driver);
>  #endif
> @@ -2255,6 +2258,9 @@ static int __init zs_init(void)
>
>  static void __exit zs_exit(void)
>  {
> +#ifdef CONFIG_MIGRATION
> +	movable_ops[MOVABLE_ZSMALLOC] =3D NULL;
> +#endif
>  #ifdef CONFIG_ZPOOL
>  	zpool_unregister_driver(&zs_zpool_driver);
>  #endif
> -- =

> 2.47.3


--
Best Regards,
Yan, Zi

