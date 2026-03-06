Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D5EFCB61E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186D06B00B3; Fri,  6 Mar 2026 11:26:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1356A6B00B4; Fri,  6 Mar 2026 11:26:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C6E6B00B5; Fri,  6 Mar 2026 11:26:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E24156B00B3
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:26:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87BF913B327
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:26:20 +0000 (UTC)
X-FDA: 84516165720.11.3E7D5F0
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010002.outbound.protection.outlook.com [52.101.61.2])
	by imf16.hostedemail.com (Postfix) with ESMTP id 67CB8180013
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:26:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XR+4g7IC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772814377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSWclaA1D5bPTMzMz3Zn9A6EvD/0u/4BSKisbm/Xdbc=;
	b=fbAIvjt6WjNcZjlh0swRMC7lWZCMFS73HeVpRn6kl0NyxNGpdq6jONu7MlmS7Y9x6FL6Pb
	XrjvfF4dLRmtfHsPn/Z99SWO0wsQCcpaPQAGT2WzqonND9Syb6rqDwcZu5ZsUzxmyRfl8u
	/ZD7n4xRQYpdxX/BDgA+3qGpgeJ5kcY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772814377; a=rsa-sha256;
	cv=pass;
	b=hLcgJA23YeyIEXadzzhK3K55KcBPgEP6Doj7eCCHKeS6yCsZ8GFXvk2z6PmjBPYK2AKph5
	JmYzDhUcbvZxGsADCmCpKClGoioe0F3doyWwOndHC6tXiphNbokkyMEORBQqOKMwbRrvg1
	R6VVTB5vmlfJMPG+9WHwnzoDi0AoX0M=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XR+4g7IC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UnalrTr94hkRFlnmeTNdDUTv865O5Pcmh3x6yWKKnc98FDZcD6+Cdm5GeuS1UrxhRCrCR3tBOEJ2UUxmlj9iG+9J3KdFtzkTgLcDYWGgHsLyravzuADPBsI/KT5rFUBAp08Iky3kWlNNiDinjRnZmJikjKY9b+EPcLUKYxd+V7Nit332FGnOMjvj0WR6ftLwZ1m3gLsRQ0iyvMNaO0UwWHt7pYyFpqBGqZht/UnBaS+bAeQKP49L+nXBa5Eq9vrf3Tuv9pPjScxrnpBE4Y+VNL4CfGUVcf7hnj9AfCAxvUORaAbPlqArqKyfblyySKBCschUUm8eMcmlQnNCfjeBnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSWclaA1D5bPTMzMz3Zn9A6EvD/0u/4BSKisbm/Xdbc=;
 b=NrsoLeVm8QpT7HWSzNj+neZJKG7W5GjruYETlfuLJjmg6Bja6i1oRFniqtPVyNQBDwvcLPe/jZSj5JBzVdl77VsHDkWzG4dJDtuD44h7c+Y9zB594yF4Dz2LzMBx8LumX+A3bxHwALKyk+dX8RKxcze/P0ozMop8H6PqBscvvJssj4nHsfaJCbl0w2G70AZvwsPEkQvFyWKF05WOhJF/cQTtESREYJz8ThoJsyWXz0XSKfSRKR4yZq+wY/7p6nwOR4D3HWGHxxTOjQdm1bP/AY6q4j+1FP8rpkMxq5Y43eWsC/iWbn99Bxv6bAZjB0O7bagyAzvGt7PQBhywEavhvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSWclaA1D5bPTMzMz3Zn9A6EvD/0u/4BSKisbm/Xdbc=;
 b=XR+4g7IC8tOoNV04oi0Ns4Un03XVATJdCd+/hYVoPpGr6szzMaJ/3c1XN87LR3izbaJEwMaeRjnFpADo3klqoLUnTEspP59mfYs9H6458XVbhWTJvaFvsHnIRvpDAQyH22tuEPCanc0TKdtAYmq5PpcHEbf12VxacqylBCmW/z2T5T65QNSVsN77MExnwDnhicd8/3x3DGKsP33n6uZLgtYLgGK4O6iqahJ2FLBXCcdV+s4lvwPT0xrUxQ/0ieYTvuuh1FpNHZloY6zADDc4/A3XaOysT7YW+ToSQ/vNLPq+tFFvWUTTDjsPmLFhm5BShDt2VnmINE7zb0zBXL+mmQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ5PPF3487F9737.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::990) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.19; Fri, 6 Mar
 2026 16:26:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.022; Fri, 6 Mar 2026
 16:26:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 linux-mm@kvack.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 hannes@cmpxchg.org, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: migrate: requeue destination folio on deferred split
 queue
Date: Fri, 06 Mar 2026 11:26:05 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <F3FB310C-055D-48D8-92EF-6F732ADCE35F@nvidia.com>
In-Reply-To: <28e48b47-f215-4e4a-b55a-01dbf293ff35@linux.dev>
References: <20260306133556.2051251-1-usama.arif@linux.dev>
 <ab22e50d-3af0-4acd-9d7a-a0e86d0c4fbe@kernel.org>
 <64051a59-680f-40ae-b291-b884aeb7c77b@linux.dev>
 <993B37FF-29E1-41F5-A1E8-F38B9CD24478@nvidia.com>
 <28e48b47-f215-4e4a-b55a-01dbf293ff35@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR11CA0082.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ5PPF3487F9737:EE_
X-MS-Office365-Filtering-Correlation-Id: 3803b617-3391-44b9-5dd2-08de7b9d1498
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	YhDDoxr8VuaQq57EQ8UL9BL+HUoKC8K/qqwEG+fagXgGXmHT695j78rTOJlVcE7Azbc2Z7L9yLFcHAwnvS6REpvXuxKot+AlJNcNQFsnvlqYblC9T1e3xqbEmxO2Vm2iYxYdwrdxnALEWuPuYx+bTuVNk0U5amYNuwydB2/XhXVwuvU/7W4pqciYBT2Nj21SLvFhZBgyBzEN9Fjik5SVNmp+UnenVb3V/zXfwmnjt9qi0kqvgLD4da9C64JWG0CX2QZV99JTzf7bUYNvGqjmUCrLYw1+U6ZCi5ztY5m0RgOpmHvOTc6uvv+bOeU5+OUgUvdi/buKh9BON9amaRtL+4VyliMf3ROhIxadEPEeC9Qh/LeRJ3m6KrThHjZd1tduE7EiC1qurGn9er6GSYWzYH2NX3+pRmLfXIPonte76OPXbHYvVF6i86oVIQkS+cmlDNtYGYfzOeZiplyaGuRKawJNa2hY7D6XMv2wTbYSwr2r/00OA4EBUoMMvkwa8RR3NQxZbmfJWrEk1Z+deUPD5tLEQniPYnsTQns2DZAyuIDXay05JkmheTTIRZkLSdo7K6GdcUMZw0+pPruqeFgbwTUZO1F1ag67j2pSNwgu92SzXsrvfNcJltFFQ7V7BB7jheNcnoyxyu2F/wWFkv+N3skm4blkRyfejzU7tsfQLEA3XJxc6Q4VMFk2CP7xWZ4OyqEu6C1vJQppQpIPSPB0YugOHq5Pjo5lbnvaZ7a2zlk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h8HuLas9Rr2m1OY+p7bVRX3L11XXSL6usbE/WNWYVHJ0QGl6uUNsxoSaOe04?=
 =?us-ascii?Q?Qgb654zOrJbTILTeHWzYVYoNm5VX2ViLmk7dpyhWvgj2/TpIpTCV1vh2F49Q?=
 =?us-ascii?Q?a9oMd8RpG1eMzpLSfLPZXje5isZKVxSRpmuCP/+J4MLg/dq2M9S7aruslJT3?=
 =?us-ascii?Q?w11ApP/Cbyt2LHKcPW2INxmcFPptJIDBS7Ggl0T2us7fWfdmf0H9xNCzoqqU?=
 =?us-ascii?Q?bkKGd1afA6udIeGIR0RQL2mafslnugJ7MkIZrvytqCjLRESt73lpAfg7zzbi?=
 =?us-ascii?Q?5iFRv8q35pniBjOdCjS6OoMJhid58NEkjhlslH4FKt/UTWxZEq5nKDb3DdDX?=
 =?us-ascii?Q?bo0lIGJTbxfrEGO2BrfetTzsnCxH9iNcwuOSDi9Kr3rWHZHmyFWZG5SaWsBE?=
 =?us-ascii?Q?bk7ecU60FLbDS3q6CweVtKKkjOz4ZqFLpRNm/GwFyNqUS6T7CnvO6JU4RP/g?=
 =?us-ascii?Q?LZu4s7BV1F3K8mofdHqXSfORC6+Dif4WqAKy2ofUiIgXy2kBfxTSGUedgX1h?=
 =?us-ascii?Q?F02rZSkwQ5bjcyu0mLQLHBsIQYong3YYj3+FSwqa8s7U+wa9v/u3ZQtQFekb?=
 =?us-ascii?Q?1xMpbbJAORh2yrSo6/hmfoC6AlE9vYLV/zMnjfwv3sGAO8KQ28CWXPxHhThe?=
 =?us-ascii?Q?nnowkt1skXP1+1J/h+PaBEXMuzCiQjKiGWOB+0/ZI2kn4vITxe/VXdJayAvS?=
 =?us-ascii?Q?95Elr3aymEjjErPywBaXov4df1T72ZmRU+B0h9OmbJ5NR2k0VyCuUcGhe6bK?=
 =?us-ascii?Q?6Gu678M1pkBsix7QFTGHoHzn+OzwGEO/RboyhZn7l+q+Z/PvZ8xqgkH9wsog?=
 =?us-ascii?Q?+DqIPqlLcnU6VBndpc7rXtRdlIZ1pY+d4TFinUQoH26HDjIBQIC8k/KJUNR7?=
 =?us-ascii?Q?TOLnp49Wo0ZxwlIm3nKM4ne6OiBCjl8Ssas9YEwhAbIP5JypX9B2K0FHtQ0I?=
 =?us-ascii?Q?BdJ6oViJ34ABOAqVNLtblnw7JE1gV0bUPYub8k25GTrV5h7FTbiyNJwjluj0?=
 =?us-ascii?Q?UslvGwKFmC5cNbHXUyHYitJZCEUsOTDgQQRLWAI8iootkDrKu/59O8LzgXMA?=
 =?us-ascii?Q?1Hu12QFJvX26rmGfnyf+LGgvDMGhRD3P2XogG3Q62LknEQWU1Je0vXozJL3s?=
 =?us-ascii?Q?I41OkeOKmZVdS/vEZlvFOcpOBSv0Husknv5IxGu+E+A21TiPs/xcf/RO3WRO?=
 =?us-ascii?Q?f3jRW6yhFn4VzJear20emzCp5xBYTeS8Hwg0FdzTih4jzLei/YuVTqbemTXA?=
 =?us-ascii?Q?RlUs2bhjEFYDs7PTJGjGIoL7g/HmMcrU2SsPDR1FHkPMvwiRWDONexuzYlV2?=
 =?us-ascii?Q?KpEp3l+BfBwfqwZ2T4izrdysctUXZeLvpS/zHxRkmVZSQB7JbXYAoiU6TCIT?=
 =?us-ascii?Q?JtB4mji9OSJ3fyMGs93/47b8LHPOS8eK6XEAjtE1gRw0HjpcTiZ4Bwtw4YUz?=
 =?us-ascii?Q?e/xjgG9rrP/YBUIcw9EDYGXYz0//u7txFpIyJ3tMk8lJ9eViEBKBr+dtAZPa?=
 =?us-ascii?Q?SOEYNbOwTdK3T46aK0SN3rq4fTeauiLjI8+/A3QxCzqeiCeoGh9Fn+z2Vgls?=
 =?us-ascii?Q?SuwdPmkCb7tJmWR3WJDvcu89wZeykpDUg6Q1mP8hYqJ29xLmYFDZSTMqmKQq?=
 =?us-ascii?Q?jVAJUziv9w3PnOT9ynbZGJBGUPmi4opodOxW0E97gEBM2fqLTPZ00I1MKPGd?=
 =?us-ascii?Q?LsGD20dIXVPNtzey0oED1JWbyU2ITLO4F2w7k7ki7R34EGb/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3803b617-3391-44b9-5dd2-08de7b9d1498
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 16:26:12.0644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bqngL2z66MLifZJXpcfzvWXuysKqojjq3IbhWardk5g3qysziBVkE7BBHw5q/irP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF3487F9737
X-Rspam-User: 
X-Stat-Signature: pib3ubkamyyx45isssxqz3dzbt3gtk5z
X-Rspamd-Queue-Id: 67CB8180013
X-Rspamd-Server: rspam03
X-HE-Tag: 1772814377-568770
X-HE-Meta: U2FsdGVkX1/ksE3vU1Qsa+bc9vdRoGo5EXKEIXCkl/N0HMCIx7O9T9WrQiJBr74J/aCpJ64FYWWtATmhN6ndFVK8TQleF5vC9GLqkuynuwz6fGIQEkuEce7T8ASOgAlc6IB3m/ARb68zH636dHU3AaoKDRyrXltpmy13seY2k6hSLUHCPy44a3VlXI1n7ivcL62inVveT8nEyQnPAZEY5+6zfLKsNZpZAULoNmVO2Ym+htkmiHNaeU+zSLLS5EdQV8YdA39KB6kG6pMCwDaRbO2E+G3tCKPdx5EGCYisU8s7i0p/TEmfv5ClfHZpD8BqZxOyimXMsHzMUUlWqqEAcRIEfT36k4Ym4xvS+Xr5egCK3SVbMBxejAugYxEUdQovtdbStgLXqzOyZ8whhXEwK+SE42SnpmSgcMbDpd4mhq9yRsZDIjfOvaQypNhkgNqTQA7yftVLG/xzTGVcw1v4YuEMk4zclBYYrVyPlsWqWoh9OnDxuxYS9VpNaPhMXuKo+7/iB8jGX0JIkcjhwF1muO64giv6ZtUt+cId29pVyBhXJwE8IgYRGRTkICPeZ+xZfMyIaL+Lt4z2L4/pBErfzOuS7CU2CRuLayn1mxBch3sI6+7M0yq8A9SqOvCIb8WKxuuvwEDUxlnB3df18vnvFaffLG8ygtV5CpMIj67zQLI9+z5ZqHe7LE0wTRmVJnhCjDH8mOsNZx8eC4/cpJ9yyEaOdBrhRvDXmBIzY/UUlbNfXFrR5JQhXGtaQ38euS1AytZwkuH5n/VRrEYoUdl4pPHtXBvjKYEOPmhWzrrPlpOPhxzB5JrwHQ5l1D2NaFdex4NT5QpuMnqGhMZzDS02QpDkl2xvhLesFztAW1PpL8n9bEgz97PoYbX8f6OOwwfwWjKNaCKCpSQ/0jjL3pWf9gGFfKGRjnHyjpcl3g0c58Q425gQLsfkkNsfQB9aCGfdLmSJ+g7byzvAf36dGrt
 HubefmI0
 3jnHJxIkiNyvhDC0QwJGjYjaqEwklvp/gFwubHXOr4E/eB0cEDekGNHRvidxLWn6g5BY5HcyR3RBYoHrPvmEu1ZO13pnDnO82HwtONKAC8V2qQGms4DVw3iD7p5S0lvNtjZ37JTH9+4sQPztzr9W0WxIrW6kYzL0dmGxlQtyWqaegcFG/W6AZdNXaM6GvUBNNLi38RREwU1HGH5DAO4WzaHBkCmB4U9j+ftD/Vr/QxgLSiEUz75/q8ZqGRcpOU90dzo0Qf+BF4Sxd8TOirBA9HEcXsaFlu4QuElU5TxJVFyqGZP7Fs1XEv62mk1tHDgvqM5v1O603D4Cm9ev4kYf2wZGfZ9u0ADpG1zOdpVWhuIG228i79tUKA5dvF5nfFcqaa71NaGlF/UiH+Nlj4Lu+y/j9rigefzsi4RWVzVCz5YgNtkYrRulgUjx/sNZTy1cm/ez2+J9Guz83e+rCyMKsh+30h7fVBZcQ/1rTs/xCno3xioEY8/BlJ9EqwCJJmRa3WxoL4LEX/oXZTneTS3kaAe2ZCrQCxpPD4PhC8xJgcoztpps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Mar 2026, at 11:15, Usama Arif wrote:

> On 06/03/2026 14:46, Zi Yan wrote:
>> On 6 Mar 2026, at 9:12, Usama Arif wrote:
>>
>>> On 06/03/2026 13:49, David Hildenbrand (Arm) wrote:
>>>> On 3/6/26 14:35, Usama Arif wrote:
>>>>> During folio migration, __folio_migrate_mapping() removes the sourc=
e
>>>>> folio from the deferred split queue, but the destination folio is n=
ever
>>>>> re-queued.  This causes underutilized THPs to escape the shrinker a=
fter
>>>>> NUMA migration, since they silently drop off the deferred split lis=
t.
>>>>>
>>>>> Fix this by calling deferred_split_folio() on the destination folio=

>>>>> after a successful migration, for large rmappable folios.
>>>>>
>>>>> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
>>>>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>>> ---
>>>>>  mm/migrate.c | 11 +++++++++++
>>>>>  1 file changed, 11 insertions(+)
>>>>>
>>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>>> index ece77ccb2ec0..98d0a594f7b7 100644
>>>>> --- a/mm/migrate.c
>>>>> +++ b/mm/migrate.c
>>>>> @@ -1393,6 +1393,17 @@ static int migrate_folio_move(free_folio_t p=
ut_new_folio, unsigned long private,
>>>>>  	if (old_page_state & PAGE_WAS_MAPPED)
>>>>>  		remove_migration_ptes(src, dst, 0);
>>>>>
>>>>> +	/*
>>>>> +	 * Requeue the destination folio on the deferred split queue if
>>>>> +	 * the source was a large folio that was on the queue. Without
>>>>> +	 * this, NUMA migration causes underutilized THPs to escape
>>>>> +	 * the shrinker since the source is unqueued in
>>>>> +	 * __folio_migrate_mapping() and the destination is never
>>>>> +	 * re-queued.
>>>>> +	 */
>>>>> +	if (folio_test_large(dst) && folio_test_large_rmappable(dst))
>>>>> +		deferred_split_folio(dst, false);
>>>>
>>>> Doesn't that mean that you will readd any large folios, even if alre=
ady
>>>> previously taken off the list after scanning?
>>>>
>>>> So I am not sure if your "if the source was a large folio that was o=
n
>>>> the queue." comment is accurate?
>>>>
>>>
>>> Yes you are right. How about something like below? We also won't need=
 to check
>>> for anon and non-device folios with this as we only set the the flag =
if it was
>>> already on deferred_split list.
>>
>> BTW, migrate_pages() tries to split partially mapped folios before mig=
ration[1],
>> so what remains in the deferred_list would be:
>>
>> 1. partially mapped but with a pin,
>> 2. fully mapped but potentially underused.
>>
>
> Yes, thats right.
>
>> I wonder if you want to do an underused scan before migration and try =
to split
>> underused THPs.
>
> hmm, I think we should keep THPs as is if there is no memory pressure (=
proactive
> or otherwise). Scanning THPs for zeros has a cost and we would also los=
e the benefit
> of THPs when we dont need memory.

Makes sense.

>
>> Or to avoid this additional scan, find a way of detecting
>> zero pages at page copy time and split it after migration.
>>
>
> Yeah but I think we lose the benefits of THPs after migration when we d=
ont need
> additional memory?

Right.

>
>> Anyway, it seems that all large folios are in this deferred_list. Mayb=
e, like
>> David suggested in his LSFMM proposal, we should scan large folios on =
LRU lists
>> at reclaim time instead, since there is not much difference between de=
ferred_list
>> and LRU lists right now.
>>
>
> Yeah the THP shrinker is a very basic implementation and there are a lo=
t of
>
>>
>> [1] https://elixir.bootlin.com/linux/v6.19.3/source/mm/migrate.c#L1840=

>>
>
> Also Johannes pointed out its not great storing this information in pag=
e flags,
> we can just keep it as local variable. This is what the patch would loo=
k like:
>
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ece77ccb2ec0..48a972f158ab 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1360,6 +1360,7 @@ static int migrate_folio_move(free_folio_t put_ne=
w_folio, unsigned long private,
>         int rc;
>         int old_page_state =3D 0;
>         struct anon_vma *anon_vma =3D NULL;
> +       bool src_deferred_split =3D false;
>         struct list_head *prev;
>
>         __migrate_folio_extract(dst, &old_page_state, &anon_vma);
> @@ -1373,6 +1374,10 @@ static int migrate_folio_move(free_folio_t put_n=
ew_folio, unsigned long private,
>                 goto out_unlock_both;
>         }
>
> +       if (folio_test_large(src) && folio_test_large_rmappable(src) &&=

> +           !data_race(list_empty(&src->_deferred_list)))
> +               src_deferred_split =3D true;
> +
>         rc =3D move_to_new_folio(dst, src, mode);
>         if (rc)
>                 goto out;
> @@ -1393,6 +1398,15 @@ static int migrate_folio_move(free_folio_t put_n=
ew_folio, unsigned long private,
>         if (old_page_state & PAGE_WAS_MAPPED)
>                 remove_migration_ptes(src, dst, 0);
>
> +       /*
> +        * Requeue the destination folio on the deferred split queue if=

> +        * the source was on the queue.  The source is unqueued in
> +        * __folio_migrate_mapping(), so we recorded the state from
> +        * before move_to_new_folio().
> +        */
> +       if (src_deferred_split)
> +               deferred_split_folio(dst, false);
> +
>  out_unlock_both:
>         folio_unlock(dst);
>         folio_set_owner_migrate_reason(dst, reason);

LGTM. Thanks for improving it.

Best Regards,
Yan, Zi

