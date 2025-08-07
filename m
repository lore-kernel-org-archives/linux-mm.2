Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D93DC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01408E0006; Thu,  7 Aug 2025 13:05:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2318E0001; Thu,  7 Aug 2025 13:05:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80A28E0006; Thu,  7 Aug 2025 13:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 964C58E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:05:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D15F116947
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:05:17 +0000 (UTC)
X-FDA: 83750587074.13.1F19EB3
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2072.outbound.protection.outlook.com [40.107.212.72])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1DF5D40012
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:05:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=swILADHQ;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.212.72 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754586314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJl8qdfovy444RxiqbyAi/xd/6Lmgw5Y9aDAQl217Jo=;
	b=nxu30o/YZQ5HFxzAa3bIBd4G7MU/XVcN6PcHzMSgeBxDXtG3DqhBY7cyG+g0fhvWp+xj7q
	EG5F6jGk3WdgNfBeIfikmZEZhuHiGiSMR6quD1jvF6lb/tIw+GlczzwDcR9rIIWcqvlh91
	3PF9Vt1aLd4/tAMnM9PGqKXf/NO5yp0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754586314; a=rsa-sha256;
	cv=pass;
	b=nqoj1GpJSpT8xuYC1q4buFWfhrL55T4e+eurBxxh3XXoRGdsUpXSJYAjbW6lNAI2qnFgeb
	VwUc9V4Pt4kuqOhZeN3PaaZAell/yIbt+HY9vbAXtneMb6zS/vR/KejbI0YfsGy2iKjqOT
	n8t6iMqD42PJlJsIU19yEFLujMapWz8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=swILADHQ;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.212.72 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LcSy8LzLSNhfpYZ84o2noTdzlqUbptouovjOQUVb0jKVAkhHDC8rhDYrEIiIcvzeHNQcF6DUfZnBe0eIqsChajKyhiD8727cl2zTKr1pOTYNyKRmry6uPKSzDEJEASRQBbB9sFvMOTOAMKUKVW000PoLT1i03GQeHWbcGv1RqWcG0LZoF3Sy4z3L9NdP+zsWb+uLr/cKcgNMPeyR+HB2rsQF/P9mRNv5gSrAKw1wT4lX9+noa0Myzc25cBnZlzXfvxTCVMjU1yXRDj708lGm/85Z0YmLQZ1L2n/NmA3XWRITI7TtY9LDIdUjrelBrD94qZkwNwr6UslI6XnRlStzaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJl8qdfovy444RxiqbyAi/xd/6Lmgw5Y9aDAQl217Jo=;
 b=sCGTVunmN2T71BJMgMaoWXsp7mSQinWMpGuID/pAGXMj8Eilm7Uhgdr/GkZWqEarw7Mh1IHwodtU3UNzj9gqN19UNAObsU94WAm2vm+YZreEtDKX4Jb1XoCDpx83TenXAhZhpwsljuhtsU3fIPVjxbLU0pvrDu3OKchyX1ktKLlnfYhD2gvl7FMIJpVG+75Dzb/zIBNbKOqBmRMYYVz5SNNwgTjSbIcNI9GKFD/KqHyoZ/nb93T4FyG2t09qiyaGldb5rbRzjodqbNyKtVLyW3nC/MXEFjzQjAQrTZcPTG6S+sNLDNmr/QnQRV21wDUQ+8FWkWvZQzEG8F1clfLVrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJl8qdfovy444RxiqbyAi/xd/6Lmgw5Y9aDAQl217Jo=;
 b=swILADHQEnsmrfEKE0mGuq+q5zRhuf+rS81pXQRrg7ruFZLosVBib5rUgTcROJaOmIQlreH9hbuHYK5oz7nA2gpYPS1Sz1LIstRXwhHS0vRCYrb5BBIZfJpeRxan3dNXRCuvc9u2/q0PPLB7g1+F8N2cBuasAA4zBcjENRC2fMtAWj2QuuWZtse3SELJVIGCBknQ5BQrJdwpLCUswl69KP1Bvy8ilfvXetxHYHuW7ZdoSR4ClZ982eYopv/I7sy0n+bXmxYIScQ5867Iz9FlO75ozPaK3pFX+VT1tEzbSgidf6CfZwolf9n+lW7I5QsYhhcxMmFcfUbsX0e+uP5JsQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL4PR12MB9482.namprd12.prod.outlook.com (2603:10b6:208:58d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.17; Thu, 7 Aug
 2025 17:05:11 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 17:05:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/huge_memory: move to next folio after
 folio_split() succeeds.
Date: Thu, 07 Aug 2025 13:05:09 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <30CEAF42-ABC1-4174-8D78-C92B8C8AEB37@nvidia.com>
In-Reply-To: <20250807085521.bhs2o6wk6pe7xf5x@master>
References: <20250806022045.342824-1-ziy@nvidia.com>
 <20250806022045.342824-3-ziy@nvidia.com>
 <20250807085521.bhs2o6wk6pe7xf5x@master>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0167.namprd03.prod.outlook.com
 (2603:10b6:208:32f::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL4PR12MB9482:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f40a43f-16a3-4729-9e13-08ddd5d491a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZJgzwhKtzLI4CR3QzSNFqlb6P6iz+xgEiUDDmFQBLhlI1mZGIRY+/q+qcR/r?=
 =?us-ascii?Q?lNALg6LeLUaAM50+Ckv1TiqtJCwjzZLgU/qGm1yiYnCkErr8ZaPZ1R2BfFlD?=
 =?us-ascii?Q?6xG13By/m2WvBnpNYOrsjWWuimgpxBnz923QAcuHFVCEB/tcX2EL0rL50UjS?=
 =?us-ascii?Q?U+HmjUqgd3JBi7NkuENvw7VaN5FuSO7ReV0KJWuwfOqAVhdFYMdM802BvI0o?=
 =?us-ascii?Q?SeYNzOSQdu54uOpjAnthOZiastsmZFhcVuxTgYJcDTn5HSGlnEOA+unPQnzV?=
 =?us-ascii?Q?GHCbnFbqcs4Z6c2d3PDb1mpk1zAQKTH+/yyyVY0WrKJjVxF2Da3E5yxdbZA9?=
 =?us-ascii?Q?kYOtglHue4kjTwywrDs/Br9dIaCtl989p53aR2cl/malhYtzTHdZact/QvYs?=
 =?us-ascii?Q?4nqdL/uXfZMFubOTzpYafzwtKqXVfYt1T/yOA9qowMoi4qGZDYc8t+f3mgVf?=
 =?us-ascii?Q?2ZdgBLrX7OaiwAcc5pXswc1WiXLD6R28QLbfQakaT+a4u9SBRNQJ189ZWy3J?=
 =?us-ascii?Q?o16rWnT1ockYI1X4sRPiYySeWxFwY0NY/Bl5mPWdsof67BOaBGKjt4iSsf9J?=
 =?us-ascii?Q?E7CpxcQLxwQP4wRkh5aFe8O3aggrm+yp5qD/0EjSHYvFT2U+3n0qQ80yHqjI?=
 =?us-ascii?Q?X8vgD0OXlZI4rDd8c27xdkuJQ43sMJBKLK2HPTJFMSIu9nSJcApHrd6DfS7x?=
 =?us-ascii?Q?29c+YtN1bjHcXek9IA+A6+8ZNb5VMeVyFegP822l7ZqQ9x0KwMGo4VMVD67W?=
 =?us-ascii?Q?+vwSdEbBNqDL3iKCgG8j6SnRs5r3nc8RWPDLqpTjGIp0tflzqmeiQMXwRL2C?=
 =?us-ascii?Q?ZzJTTfs8Hmy7kOLuCIynztf1lPtcHJcq2eC3VhmpbBQfcwlSanP7I8MG4Ns6?=
 =?us-ascii?Q?sRuZmjnt7TwUzwZitnWZWlki6soLl6EXUL2snOVic3TyUfJrVE85vCHPmVEs?=
 =?us-ascii?Q?y4DqfQt61M6bNRSUqlubdnRI1qiIyTZt+rRlZt6Du/iEnq8/RI+qrwXRp2x0?=
 =?us-ascii?Q?7uRYKrw/9FUTEJn6DFvMcUtAoBv6ep3OIdKrfHlGhaOXyqXOsqf0iDMgLa4M?=
 =?us-ascii?Q?ja43QbZd6njX0OsIAda5ChqyszjvsA1HXxBosVJuWhbKpXIziD0U9vqho0jw?=
 =?us-ascii?Q?B7aITdDiA0NjZFeSUutQJylFnmITXZum6OjbiW8jFq/B+7U7PGnF3h/xbMmW?=
 =?us-ascii?Q?+gBZp+ZVq9ByqSaLfOTBMZ05CZkl8pvuYMXCk2ulHyb+IOSqR6GuI/BQojof?=
 =?us-ascii?Q?ByGubUAxG1/VUBcrvyN/JMA5j7+8EmAUPJFEipsZvhENwDT3UQjXC7nFyx+t?=
 =?us-ascii?Q?DcpgSPDESulqsMnR47Q4I0pMTf7PXiIupuKVr2RdWJW4SjoBroNA6rsZ6nzI?=
 =?us-ascii?Q?hRcuwxhuyNDA+AnqKXqA15XYQ9pqw8QhZaS/THP/DlKroqPBvYD4UV1+2e+F?=
 =?us-ascii?Q?pusqEqTl0p4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HuTZ7YC8MAu2Hf/MPjcYTw96DhGcVlqJyOFZispNaooAfOPlAmd+uJk+n+2V?=
 =?us-ascii?Q?Og6trDwGjlqeOObP3x8rC1cA6pfNC5rjDBRmMKJqSenb6rr++2FO6X9/NIrc?=
 =?us-ascii?Q?LsaaSEP4QnFjKWLdwUHpysYxa0eGWfyVQN20AMrGt2BBM3kOLbNCBWb8EfPa?=
 =?us-ascii?Q?E4hhi59qwLGje5OwhS+sqZZZr2a4M0T0TDnBLv0Kgl7WYl5mt/Fm/ukhoQOT?=
 =?us-ascii?Q?OFzMZZUmF0poFrv3JbM6nfj+rZPGofTzXELLskmUiIp7c83+xvzCB7SKTsA0?=
 =?us-ascii?Q?Yhs9MkTOVDbm0Kwn1ZiPvKvZ/ck405+fbdkBmQaZfvRvNpOOMqKsNz9WC5iV?=
 =?us-ascii?Q?1y0/UynPSlLQnWsf+VIdZDl0vbOo4JGXD1RyXc1kOnP8iCdI427PylIQZNLd?=
 =?us-ascii?Q?mCoRmbiqqY5EykIp+rc4h4Yb7Uq9reIKoutu4BbWI4YtPRv67KG8PnMRMhux?=
 =?us-ascii?Q?Me874ZmnnQTbwMdDSx1RWke5XIC6vgKaNLFcuEgI8hIhuLv3m7JmpsvbxxtX?=
 =?us-ascii?Q?zOdb+gCSzQAxb8e4BX9fYcCPeT2pqxLTOUeTgqDONgnAGbMCYu6/ncUb8EtC?=
 =?us-ascii?Q?5fNSwXzKAPqbta5atFHfS9MpT2ZVbepVaas+8qjUK9ze1cG7bS0kbPc6K7UE?=
 =?us-ascii?Q?00rljw+43YvPVgk0dyn8Ia9B+nGBOOn9c5BAHOWSp7ZkeUR7WMB53wk4XO7z?=
 =?us-ascii?Q?7yMJpYYh/qqkGeZYC/61TBWF/MXWHqayEQXY2MNw8PTJ7CNfc3cFusKgoGAt?=
 =?us-ascii?Q?0DvWfT0cYbIsPcJDDewwbJ2dUlxTjZA/jixo09yscr+cr9oc7hGR8plvhwLT?=
 =?us-ascii?Q?xygh3hzEwTAu8A+WAzhM/gImGiOeAwnaNKVxWl/Num05zLhxdVK1QsQAPZdH?=
 =?us-ascii?Q?bMYH5Pb/vs7P2qm+liqm3NuaLO45kYxZ3WKUi9m1MvItViVNwWEF499RCKek?=
 =?us-ascii?Q?+WH9jCGlBjK++xPI1QV4eyc+qaWUaLCHUPyMBsjhpE1KtXq2pAOsXvR9ukEY?=
 =?us-ascii?Q?pLHHj37T+Lmh6UGiooXokMUv+7BC0j3GBCMu825I89Bfl5MVlmKBdHDahP2A?=
 =?us-ascii?Q?tAjK7SpEzrqYiBS6iVDPTr6JesAbvl2ZdGSj/GgnsbJPEj2SKPF5MdBsr/1Z?=
 =?us-ascii?Q?P4cK72g9AwpRvSCmnkk5o3Jqek0KAmxRkKxq9TL0BLfMAxr4XdopgbI3fHes?=
 =?us-ascii?Q?rvM/nf2GaaNq9SEGOm0F9/UnGGkLkAb9HTszYhyAQKqErreNT4UOcoZ1Fi4s?=
 =?us-ascii?Q?5G53Xr1g0rX3luaT5zB6cpEyCRgNmCogc3U5oot0fDdf1KXpurvWpCgFrQB7?=
 =?us-ascii?Q?iL1xJY/YHR4dBx5dg873FEzC17Tm0UAAUrosVeYH1cwkXG9jUJMv8k0iPaqs?=
 =?us-ascii?Q?rDAOrYkLw63rBv1wuNbtDur8X2gIVzQI7ct7qeNV6N7gKcz+fPL0A+8LOlN+?=
 =?us-ascii?Q?W2wtslEuSXs37ao0y0orfiph8pGZx/oFdPgowXFe0PgFkjlTdaFMhdkJG6YC?=
 =?us-ascii?Q?9XN8fFMcGsFSB83JWKC32pNtjGBuE9UlYAlOoltigfCaTOgt/APboCs5NYH2?=
 =?us-ascii?Q?xPw4bTD2KCGn72Drf0oyB6iYcskCy83hO0hO0uy7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f40a43f-16a3-4729-9e13-08ddd5d491a9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 17:05:11.1256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4afzWFfBbPCw+sX7tbrlRVlQhj9gubO001A6fBVwk9ygewEZJP65LX3Px40BnJoj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9482
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1DF5D40012
X-Stat-Signature: 7i1f1fta1nxbrcoko3hjyukfg78fh19d
X-Rspam-User: 
X-HE-Tag: 1754586313-933389
X-HE-Meta: U2FsdGVkX182K+kq+EY6kAyTDsG3UAYH116gs3bfppPKAh3P98E0vhVWC7ZNXcDVFYxOaP+DVif/wD9Mp7CXF+ZijkW+K4bKqB+E5DDKvTwPfDUESxcDEdMk75TXfJV1l4/10bapXs/edPK/sScsrjhjjun7Q0ttG+9U2vwHwdYRSbMLSFiHnmPqFeh6q+QeEAvQoQnOq49GyvbRChYOW9o3PKh3hg74Bi/RwTKwbpSLX9eUuN6QSpt2xC+1DBNyJXNefW9wBzzu0Jp3nAuPVjVEF2HwE8KfOOShnqBwXZND1WIisdbL03WcbuUz0pm3x6lB+cYH0zNyB03Ss07CiR161VE0N5Wbb/Cs1lL+WiOnZJtatoISvNhVpxtXSe6/efcHyNZqD3g51/r1+K5D8bgFqlIgkwfHkLXoVx/jisd2eMlPxhAzlradVXzAlyCDqq5dVWhm2gIkXozMfvXuGYf/bq8mzUQ85GD2I9onR/S4ldpuFcSprlsjHdZT5hHGp/sXPCrid3Sbh92jzxS5HX8CdWoB4zyeE5EI3vfv6T9LEdX3lqyMCEHs9Cmd8SwcfOXorA8r4OwNbv1pM3FL+mKfGx6ML3edyTLIuXus7j9jjyb5jkGmOGbaQqn+LGeJfbUu6uyCb/Or8h9cq6nxdHAV5gnOoPVHVQp7rrjUzHDnJpLr3PCdNkYHaMJw0WjROWD85R6R+Fkqm/rq5bhIbqTabaOrdPE58e5erCRiqoB0EVkYkBWt0c5ywv/l0JyH78Gcrz5RCRkzgVIwoNLC4uPqzJrTLrdEzPsyPRCTKnm6UN6bOh0SveZSEHWJ+PhN/FHiT1v8YLOJ5lYij17o6gbYSTbceOkzayJgWbimgQciqIzFsJG9NoEpFFjk25QWVBGoxBAInFXW/SNfcE7uPTfv+7Mhmlq5V8fEVhZXfMJbgy4HGSPJ9UVkSwHEkzV+d1Hkn3s0UOJLkancMbc
 +4ws/WgC
 cYzRG6vUNPCdGwiVUerRw4aBDXkC++WP9K8pHj0yjL29RRGtyROJRGLZLOhrP5uGg8XKRgkkZ3IfCcSrx/2UF1isc8rHQfUM3VcL4CiKeSFYO4tiKDMznp2RTjjRZtMGEOLAIWiPra5kcxF5na+0myAJb0QVKy5aGS/QHkq4sIqkwZLgO3aSLmuhAIb4a5hHnl3sC4cLK5FdEvNUZbJWokElTWhtzpfUkHr7M4BG//YV29QKwYJ9PS7YDU+bqJInVxLlN0W22xu/N9ThULIM7aS6mA7lM6AuKVqISuhJn72W9gPl5oafMI88XBTewcpeDBamHipbIiDUg0F2IAd+i34Bg6bXod5xhJejXG/OCvmK3OxB1AMFSD7MbyonC5myuoFE01/30xPW4bCAbOTUpIUH3kBCeUrgoxOFPFqFJ/eXEyjqahDQvUFdQ6rh+1hZf+krE9TZPFTMevKsYn9QT/AuJEmn9rU0yZAQkxPIKr6vgo6j1ss5E6KGjJg9z0UlDKP+GXephBy0J4gFki4uUOEAkHVm57gRkFpBq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Aug 2025, at 4:55, Wei Yang wrote:

> On Tue, Aug 05, 2025 at 10:20:43PM -0400, Zi Yan wrote:
> [...]
>>
>> -		if (in_folio_offset < 0 ||
>> -		    in_folio_offset >= folio_nr_pages(folio)) {
>> +		if (in_folio_offset < 0 || in_folio_offset >= nr_pages) {
>> 			if (!split_folio_to_order(folio, target_order))
>> 				split++;
>> 		} else {
>> -			struct page *split_at = folio_page(folio,
>> -							   in_folio_offset);
>> -			if (!folio_split(folio, target_order, split_at, NULL))
>> +			struct page *split_at =
>> +				folio_page(folio, in_folio_offset);
>> +			if (!folio_split(folio, target_order, split_at, NULL)) {
>> 				split++;
>> +				addr += PAGE_SIZE * nr_pages;
>> +			}
>
> Are we sure addr points to the folio start?

David pointed it out. Will use addr += PAGE_SIZE * (nr_pages - 1).

--
Best Regards,
Yan, Zi

