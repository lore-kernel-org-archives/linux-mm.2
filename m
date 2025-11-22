Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BACCFC515
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 02:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA7E6B0024; Fri, 21 Nov 2025 21:56:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1EA6B0027; Fri, 21 Nov 2025 21:56:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A0A6B0028; Fri, 21 Nov 2025 21:56:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 329376B0024
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 21:56:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60845567FA
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:56:02 +0000 (UTC)
X-FDA: 84136728564.23.3BEBB72
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010026.outbound.protection.outlook.com [52.101.201.26])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8B330180008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:55:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N0lwITSq;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763780159; a=rsa-sha256;
	cv=pass;
	b=Z2QhDOavtBG7+f1Q73uCosmUJl+wjFAfX+fv6ZX+e59bHn+2xdlRnas+oJVkSLS1h9S+Kp
	4lVoUgSpoAgKUguzSq661UKEaSC9mXwmkFj0Qr1vQlp2jWno9S4XwgTsOTAgdfRtI3SMHT
	z+LcEbvFZHyNiZQymUFdvPsLgAk+3AM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N0lwITSq;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763780159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7L7mUcs93JgEshzoB8bMVmhF3rXOXV/UEU8bbWiJMM=;
	b=XTtOP9eUqZZFT0AHzXQvyFCX2zrgQN5kvZwPW1cZVRm+UucusNAwytjwNcqSV0S26Myvdz
	etrNjS02iR0iYCss28mPJjGvSm8ICYOSzP0Va6ys/m5usmeNF17QVmHq4NSS9KbD1lMIpx
	A80P2W+4OvzER3W4+Tg22yWUoT3prpE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PcmzkzKq7woYHuS+1ceOIDyFJPwE2Utxae++yIIv7+qb9weUHYIkCPQ4iKA2FcVykkgyqOtj5aqhIEDeIYa+Eyx9GgPVIE0eA3WONDW23MIpVPfLB7c3jPezp3ugZXAcd+OpspueMHFIKm78RSaXQhhoH9Hn9jJJpo/PDs5bqrBPkKGH7qzwVx9MZbG8gU7wNxnueXLJprd/3ID1IGPH9efCBAWIHKHhdIzSe1D8Tok4YfIqX3MoXqvGQw9nag7VVZSE/VD0Dnhi81ku/h48+1eWWdJciql81kmTFd94N1I1b9KJr/oHLj5iJyQFSdkUhHD7eQBROX1GeUVHOLD8kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O7L7mUcs93JgEshzoB8bMVmhF3rXOXV/UEU8bbWiJMM=;
 b=GzQZB8aHJlmCP5DJYtkJGbIVBfz4Qnb50OUBIivyEuYVNwuAc6DzG4CyykLPYcrMhWNPSKQGsSGn0tY96c+ieMRc5ufmnGTLwSM1lyx06j8GQDKeRD3t11majXNHakC+V2bFqc9Xd4r2ZSchQmLmCqyhEJldSKLP+UfK+cVjZDwzL5f4IO3IEPnV+hOybzG5QL52prXrHwH2gOXhC6dSl+MuUTG0XYniUE6QByeilVrVYlvlPR9eeOQaBNWTjuJ5V7xpCKmRMEF4Cr51QlEtlj+dwNNYqPD9wFGGepLMkoAgLhc2Vg3FenuXwBpWuM1J+1UDkR8bcgLy0zAYofxIsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7L7mUcs93JgEshzoB8bMVmhF3rXOXV/UEU8bbWiJMM=;
 b=N0lwITSqHx1f2Gi3ViAob8gkab5iZwbjxr90FumEFHT30OQnU94I02k5arZI+M1s9Q2cZNeitRg/IJm574I1TgW0W755doENVz89xAhxUhiAXNV2upeqtMdKeIwgm7dBmSWULAHztUC3/XsJL8yNZgzM3tYKS4Vu+O3BWxKVOGmXCjbDXrjjwZMiivQTXZ0NybO/CyQ1ZhOUkORqKQg8wi2mwm5xzNMLonUGtl8VHR2e64qD5LG4zwLax6mu3NJSxPcB30FOBC7eXeU35z2ag1+5P3f6pk0AgymBDQTaiwSyR9V90Xcg+m1J35EE2SBODxHrznemKEhhSh85YTmXjQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6994.namprd12.prod.outlook.com (2603:10b6:806:24d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Sat, 22 Nov
 2025 02:55:43 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Sat, 22 Nov 2025
 02:55:43 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with direct refcount calculation
Date: Fri, 21 Nov 2025 21:55:27 -0500
Message-ID: <20251122025529.1562592-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251122025529.1562592-1-ziy@nvidia.com>
References: <20251122025529.1562592-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:208:236::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6994:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fbd61ae-ec75-4d11-320d-08de2972a07d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DOUVyfarF5jzG+cLhzZE7UQBKSS6jlS79FKPVfhVg1KYZ02LNAwdG7WTTePi?=
 =?us-ascii?Q?4SUQLBUoN+ecWBno3YwKORgwC4/n8VfifT+15OCqSZH7CXWOKZCUv11j6yIX?=
 =?us-ascii?Q?V2Xj3ljabYfm5t7exUt8oOQ3bBctri2k552J+IcFWes3S6YtaKfy73sFl01M?=
 =?us-ascii?Q?YHp4eqaXETZC+GUZhqEkUa2m2UErdKaptWKNuqYlmp3qaXooyPhvx9P6x6yc?=
 =?us-ascii?Q?joQvA993UH/W6gz+ztCQJMTq6+aRX8lQPEw3tNlDqjACssa22tla3q6NuY+g?=
 =?us-ascii?Q?s64mOfvAsDyC8E34LlvGtn46tm/qq+j9kCEK9HRZdAULybN4Bd149+bntyDx?=
 =?us-ascii?Q?ia/CnAhlFG6OmQgrTn7zFDeFHoG/1ufZPEoI3rtShrzTQr55lYtEglE+cub0?=
 =?us-ascii?Q?9ERpYBx5nJxbot+bmz0GjiaJWyVJwXajjQEVErQBuQF1iJqksUq9FXYSXyH1?=
 =?us-ascii?Q?U8a8hnqby+fYwYJXd2mtAdF82MT7x6yogAfEOofTaguhbwkLnPbdrO9Xq37z?=
 =?us-ascii?Q?vtz1Vre4xN6TZcjUmdnvi7lxBlXWkMM0oaZ0u+l0Rv2bjJreVq+Pw6F5ntQ/?=
 =?us-ascii?Q?5bHRQrgKq05cHmgAaW7NgGCOcrH7w2TXna/Y7RmqJG40+/WShBjKGa9ywI+g?=
 =?us-ascii?Q?QZ4srddU4lMoai9wuK/ny0crFFLqEHz5OgIsdJGz6L+d7U/SeeHGCqPiu7Ui?=
 =?us-ascii?Q?CjGEhnyT684uSYNQlEuyEsL5KdGzHVpLHSMwTkRQtHFnkD8ISDTcruhXhziM?=
 =?us-ascii?Q?uviZeKwrAiw7D6J4XJ8eeizoAYVHtgZJ9Yg3dX4XpjOpzGkMcaunz/Q52+u6?=
 =?us-ascii?Q?6U9pnvkOrrma19KEm2F26drv2JOvxzDgzPwwcGAne+ZJKTJ/tiiQQ5BdVqxd?=
 =?us-ascii?Q?k7W28pOd7vS+Upkkz9/nvuZ4NVMMrdCRqplqMN46zDfN4JsCSKC1HwqByBAU?=
 =?us-ascii?Q?f1vG91A0Dfc6fWt+iScAwmyJEUCqxi2ft80OGpNkLFXX4V/+B7uoLs5i8xDb?=
 =?us-ascii?Q?NdtttEmFKdkfzhzYzOLREqjbdmx6+VEdwloFReZkm5IoxI76B1wfh1q5b3CO?=
 =?us-ascii?Q?MTCLogaK7FjDjEbzMDJKeY4gFnI11TIQisrCfJJtBdGzQ+9MErv94rODuZK+?=
 =?us-ascii?Q?tOApaEDspB6Jbk6KAsSXR7ric3JRAbEmaLDvQ+AXoUKEQ8lFZfuRte2pZ6GU?=
 =?us-ascii?Q?Ve0tWWbuTNH2atNveSwj+bz2qcsPOA+IfWtEiG8emkPUuJwIAzegpdLjKVFL?=
 =?us-ascii?Q?XFVpq3h70cHQakualiwMvYsZPcl4Rk0Wg+073svB65XljM0aVUfvxUPrTXQq?=
 =?us-ascii?Q?wlAWy1tK12CWQssQDhyDw2RhsOnWCI/c2WU/CCYn9oVQfrL9JJLmsxHt0QdD?=
 =?us-ascii?Q?zp3XjChP4B9MOLEy5AWmA3JzkWSc9nhShbFwwPOvMemoUYfVjaNZIh1748Gi?=
 =?us-ascii?Q?UT8ewlZFE3DP5Xw8YC6NmppZIwamx4uc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6UI/08FV+A+HB4FUT3+muJCCd+nKpN8/Ga8ieej+8Nf2Yxmf8ZLXSMUBGKYp?=
 =?us-ascii?Q?vLW3uKHQI551Dqym7cB2BZoS/y2vRBGZkrMKt+aqxQ0VW+79ltetg23CEGp8?=
 =?us-ascii?Q?qOi5ywZZ4Z4YfPSrDkfs6kAOEwgaYj9bYzttB/cA4dCW5RcsAMm36IYBTZQH?=
 =?us-ascii?Q?7Ro7GSUoluKy2bnGms96Gr20G6RFnEPiOMBxmvVN793XzZLmTlSg4W9VNY8c?=
 =?us-ascii?Q?/hpGU5UCh2CKc5nWzxVUe3FcIhm5HIZSrpX7xvjrMMcBtw6opSjqpluQ45sp?=
 =?us-ascii?Q?BLc6SyJbMSNI4/0WEvmUfYZHd1C9+4efnox6g11cjBgms8SjMKXKa7dd6HJl?=
 =?us-ascii?Q?IUMXf2qe6fsbDcXEJjdas11/bBeqObxrv7epjxVTJ4GezhcydgxQFgrGALkJ?=
 =?us-ascii?Q?74CjIUKaeLMPUX6tIybIMbw72BKu/ajuodKP41FKdg+6f/VIEuOqHXPSg7dI?=
 =?us-ascii?Q?JQePtrIgwop5pR27wszKifgLG3j4l8qoSmWVHk6RMYZiWNcqmq6YvBVdw293?=
 =?us-ascii?Q?dluF5lNGqptJIRFomnYHJMninlHK025LjpEGIkVsdsLm86OZowO/we/MVMd0?=
 =?us-ascii?Q?yblYotJeY7rclryncIKvgB598UJazdQPp99VGb6YeEbiSqK/E3W2i4AiCU7l?=
 =?us-ascii?Q?qSzIu/912pHX2VtJLEfVfDM7hhOy7ExJi7hHd+swoSMO7gxwerNH0J4viEwy?=
 =?us-ascii?Q?FCZa8X1hV7oP9PX7BEINsZNCCTAnfWbCSBVwnnX+drGpCYhbJHsNtVTy6DYR?=
 =?us-ascii?Q?iSTzwWQUrt8gHu12L4OOTK0TgqL8bRx5U26l+EfxA3G8rXo9i3b2xBi+Tji2?=
 =?us-ascii?Q?jCgG7SP3d7ky1+g3I7XHVsr3wVABMhKTosq4syLiw1HiA2E46Z0NZ6rjr2lW?=
 =?us-ascii?Q?ArVswWkYsGcxC8lH0Nk1SLFfZ5EXpZxDYRMQgtXU1HrZk64oy9m36A3RnGRU?=
 =?us-ascii?Q?LJMvu5P4/vmsgiKCiNQ75PmfriF7BTZOO8daCS/eV0TxLM94iZ+L31OcL7xi?=
 =?us-ascii?Q?56iuBE0iME2dSI7wNG8rR3gtjehkh7zek+PnDTpiNYlw8Fnk1yl+NS7Uv6M7?=
 =?us-ascii?Q?pkeevP5QVR2U2W7MJ0fmItpkDtdRjYeq6Tmts0yrIgZ0yPgSmTVpf4waJjmZ?=
 =?us-ascii?Q?oN3i212w2SEK/D1LcxC6NzEhQL8gcntVb3B4Z0ZWbGaZyNoLPeMkPmxKYhrv?=
 =?us-ascii?Q?Zt1EQf9Ym1uOm4KOO+TBCtemQXQ8wl0GphTVjbFnwyjOGNVQcpYyRb9pVf7/?=
 =?us-ascii?Q?dEYTPwJmHaFBcuo4wTOxheldP1TaxG55n9J0jwlZ97fUrPMMtlKTBlSlcpez?=
 =?us-ascii?Q?EmW9MhhQH9htXGnCoyWjqKCNaxXK6ALSj2Xp0v/BSuivOxD/wEwP/uzEVm6A?=
 =?us-ascii?Q?xOWTOT6OIap7khpN6YaHwLEw5IwtXipsNL/N4U3uQrE7HddW416Aan3gaclQ?=
 =?us-ascii?Q?U4nmXHuNzd4IiN9UEf/bgbaverpLpMjlk2RkD13PQw8TC1T9lzQjafEsqBfY?=
 =?us-ascii?Q?OXTjyS6QMDhUO/IaO2xwBi+rp7q1Kng9rSzCYm+5bGvzlTtJ8HGpGvNeVVay?=
 =?us-ascii?Q?CQyZq5tCF4d9oFNKRJRtwynvk6wgAQBmwpLeZIXt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fbd61ae-ec75-4d11-320d-08de2972a07d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 02:55:42.9641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kWtHmiMLx/XEvuXfuaAYjbOqBEIqyYYV8ioeC0Y3VepYeI9aL/ctwsfS3GU23jw3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6994
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8B330180008
X-Stat-Signature: wsdu8iups3t78kmk8cdxic8rmh4hbej5
X-Rspam-User: 
X-HE-Tag: 1763780159-153916
X-HE-Meta: U2FsdGVkX1/Qhw82Im0Je4bMcL4PE2lTQ/LPG/DeI8xUmCh4ET0G+QcFbTyvFov/1K3p0i5foRfpWt0ILXtcKkGw4SA3ypRt6soSZYlCAiHv8mk+BfsngZffgV10mDHrNk4hgJPeYoOfwM3BMz9lITnXNMNQnoblXYV7IwOtIkBPhV0Y0Ok0v7KycKXOhBq8DWIK1u66rkcZsYduzc+PwpiuTtgNgkEhSVN2qmB+sj1lrEQBhXKDHu8+SAhOTFwtLX97i3w3nPWZDgCl4bMzAN6mnmevFNevq6zNCjhb9qINjRIU6ZrIntqoE00LvlqaE5Xk7l9sfzaX8wob1Qa1rlQZICwSmg34k9USTP5fpUNLb6SYP3t5nSEYulZ0fPNkHF+vA7WKkZOl0FHjiZtsOTNSAbL/5vPXlaLpppED01RDx/KXmz3x/XlwZE+x4jQli6YQZfG9M/tHbryiXC8LyjQBhD6RJxiJuIvT8sfXyV3RfvFeE404podKvMKcErSidotutLaT34vcaw8UL8RcjkqBDyzD0bViCmNyXOOj3XzzFEmbMtEo+wPLXM0HA81wOyCYKUChRbVrgUct58I49U3ZZtp6ozot032qgpQnmUUNGGMsQLxSfchqWZk07a87r4f/yCdog2ObBO2rHZmfc2ZiVHNaFHxrjP2GzJEe5rX/QjtLA3FMwmqHVD4vG3l9PajOkRz5VvKRRnaCPLyJ0WZxs6H0obdCEvb4+HBi9bbWWSw7q92tjisa2WJn+sWA3YWCQXlVFIeau72U59XWDo1jTZ5vSt9tqZLcV5whJi6DzDbIas24ifza0f00oK02cQw5QutZK2yGroP/WL2CfBORWQMmnW0Rhmsux9OwKCnm/xJoR1peUiPPglmwbTiHBojbrj3eULzPS/LJrNqI63eK95ie5152vaXa0DzQ/3R6aOIYo4f9LFse1iXOIIwep4/XZAxWSBhIdsD4Fu+
 /9TP3z/2
 M9BDzzaPauAk9pFuk0K2O8zyvtHDMrvm7wzahk7u5vEJk+lmIwxVBmjAHq3pcpBb2jvAPrg+/dl0kzdse7fTtqMns9w26JEy4bGnqcGE+HmywsWwiupeDEWDCRanBK7wmlDXC95yfEjWwZUWQusnIfZ5KzqdUUUGpE9WtIstgf2jsGvNGFtT1Onume6prsmlkvA3nX8UbR4U8xJ/qfR7+dK8v/4jooDXkq5/HDpcHephE2bjiA7abM2v/GfE7sbFg+WgRCLmscZ8aeTk9zCGIhiXAplKLErmO2i4UX5Zcggo5Z6Dn1ljX3ynTW6PjkJviFEYgEQP+jxPIoEft1WUOIQX5MXe/en76D2Ghi9mC73dyAgy0S3E5PC7rxXZUvHRRfaJUTcKuG1qvI9owFSSYJ/CB6zcGZokKElbiODmy+UNgFpY57QgZKkal0BjUtRMK9TjbA8eAVmdOXULSQwXOuC+iOPEq7G6TgXXRoLZS26OOc60WEV31VAW6lfvs7RNsylKqSFX/kYiIJ197bJA39yVAVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

can_split_folio() is just a refcount comparison, making sure only the
split caller holds an extra pin. Open code it with
folio_expected_ref_count() != folio_ref_count() - 1. For the extra_pins
used by folio_ref_freeze(), add folio_cache_references() to calculate it.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h |  1 -
 mm/huge_memory.c        | 43 ++++++++++++++++-------------------------
 mm/vmscan.c             |  3 ++-
 3 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 97686fb46e30..1ecaeccf39c9 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -369,7 +369,6 @@ enum split_type {
 	SPLIT_TYPE_NON_UNIFORM,
 };
 
-bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c1f1055165dd..6c821c1c0ac3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3455,23 +3455,6 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
 	}
 }
 
-/* Racy check whether the huge page can be split */
-bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
-{
-	int extra_pins;
-
-	/* Additional pins from page cache */
-	if (folio_test_anon(folio))
-		extra_pins = folio_test_swapcache(folio) ?
-				folio_nr_pages(folio) : 0;
-	else
-		extra_pins = folio_nr_pages(folio);
-	if (pextra_pins)
-		*pextra_pins = extra_pins;
-	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins -
-					caller_pins;
-}
-
 static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
 {
 	for (; nr_pages; page++, nr_pages--)
@@ -3776,17 +3759,26 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	return 0;
 }
 
+/* Number of folio references from the pagecache or the swapcache. */
+static unsigned int folio_cache_references(const struct folio *folio)
+{
+	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
+		return 0;
+	return folio_nr_pages(folio);
+}
+
 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
 					     struct page *split_at, struct xa_state *xas,
 					     struct address_space *mapping, bool do_lru,
 					     struct list_head *list, enum split_type split_type,
-					     pgoff_t end, int *nr_shmem_dropped, int extra_pins)
+					     pgoff_t end, int *nr_shmem_dropped)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
 	int ret = 0;
 	struct deferred_split *ds_queue;
+	int extra_pins = folio_cache_references(folio);
 
 	VM_WARN_ON_ONCE(!mapping && end);
 	/* Prevent deferred_split_scan() touching ->_refcount */
@@ -3956,7 +3948,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	int remap_flags = 0;
-	int extra_pins, ret;
+	int ret;
 	pgoff_t end = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4036,7 +4028,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	 * Racy check if we can split the page, before unmap_folio() will
 	 * split PMDs
 	 */
-	if (!can_split_folio(folio, 1, &extra_pins)) {
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -4059,8 +4051,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 
 	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end, &nr_shmem_dropped,
-						extra_pins);
+						true, list, split_type, end, &nr_shmem_dropped);
 fail:
 	if (mapping)
 		xas_unlock(&xas);
@@ -4134,20 +4125,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
-	int extra_pins, ret = 0;
+	int ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	if (!can_split_folio(folio, 1, &extra_pins))
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
 	local_irq_disable();
 	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
 						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
-						0, NULL, extra_pins);
+						0, NULL);
 	local_irq_enable();
 	return ret;
 }
@@ -4640,7 +4631,7 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		 * can be split or not. So skip the check here.
 		 */
 		if (!folio_test_private(folio) &&
-		    !can_split_folio(folio, 0, NULL))
+		    folio_expected_ref_count(folio) != folio_ref_count(folio))
 			goto next;
 
 		if (!folio_trylock(folio))
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 92980b072121..3b85652a42b9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1284,7 +1284,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 					goto keep_locked;
 				if (folio_test_large(folio)) {
 					/* cannot split folio, skip it */
-					if (!can_split_folio(folio, 1, NULL))
+					if (folio_expected_ref_count(folio) !=
+					    folio_ref_count(folio) - 1)
 						goto activate_locked;
 					/*
 					 * Split partially mapped folios right away.
-- 
2.51.0


