Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EB70FED9E0
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 15:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD006B0005; Tue, 17 Mar 2026 11:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D8C6B0088; Tue, 17 Mar 2026 11:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2253B6B008A; Tue, 17 Mar 2026 11:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE2D6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:17:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6FF81C25E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:17:40 +0000 (UTC)
X-FDA: 84555909480.12.68DF708
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013051.outbound.protection.outlook.com [40.93.201.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id A770940009
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:17:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HIZh6DtO;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773760657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vt3rxOcrNDs584iVMvrkq1APdDbV4oDAKm0rMoucE6Y=;
	b=iygFQ6l9BTsh0GE1pIs8uDsiw7O3orSnSjMiHkZfRqWsU7DQvJeg/+m5GGmhExXmq/xejB
	DODY4UpU4FIf4zGmROfO5p2wFokLZa91uFmWwsrCt4dF5LX2ry+7KcnVL3Ot08CChQd5xh
	lNFzaysGXCHNLGlsxibjVUe2iFatJTo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HIZh6DtO;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773760657; a=rsa-sha256;
	cv=pass;
	b=40RTBEMqzFPhHGIj0k+UCNl8cpbp3uHDq3GMNYNgIgMhfvzMAK3EFxMAJr/lqa5gWeRuGw
	dYXHHfGPBy2ZNLhuRxMLDHiaEA0sOOVgspeaX7ArYIzK0bYR70fsHll1QTg0NriVZ+/FDq
	l0i/Nfyqqm+ElkCCpchlJR3LK2CR1/c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SYxAo/RKdR4l3TRQLcNVQLguOmtTO7N1cESq5g5X7bjpbd6Z8eVoWScpwQhjzwPnd7hg7xRRcZTmwKkDOOPNZDLwdYBF0PwE+Sf0ryc9zWESqxPk+GyU4DWc9zAoUgwrJOP6/dmLMX/hSrXTIMjInbWjRTQ0OPJNvLk7GG3qdG9QVvZo6WF0yQwiXk45LZD0UiD8bb32n5bdHpPBS/JXpsmCkAAMQ1l2q+RYIH2mKx1soM38lXCNTmRHwOzcnnji8X4V4UY16q/V6smYDKRVcRGMklv+vOL5MeXTbyIGuKrQd4GscqU17KE+WTF0ImCc4EiJbZwWKnEPyLhqid2low==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vt3rxOcrNDs584iVMvrkq1APdDbV4oDAKm0rMoucE6Y=;
 b=qP8nkKfO6u2HTjgkXw2lydyierqFL8XADEbUJOePb/o9ycmn2tgz0aKF4h4sbIQjclO8uQYXbbboMRpT6xzIHBvhFCdCyIvB2mv9fYB/vFi7tNnHmTgWgXlr3m1WYVGYFGBv/ehAqyllDKqByl7qsmpMaBE/wNM2zIL8a8jf16CBLpl4PimoaR8Sg9RAOhTCx24Nr3yWCicmhgGrEgMfla/3I6dKQlqITN6VM0/YeddAtneFQiEm+1IwBVCzYJe3CvFWQGQr5S4Yl2D2FTxnygxSJmidzd+ciq7RumX7vSHSY51Fsu36WNSkYQjiimW65LK0q1w+FuwkCWBUOLfuSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vt3rxOcrNDs584iVMvrkq1APdDbV4oDAKm0rMoucE6Y=;
 b=HIZh6DtOGZGCEsFb/VZflvCXhMNXU3C7oRmp1JAvLifjbAuvFh1Nt8XqzNh7L8bVvF8/iRJDRoAviC7LcpG8QDj3PrBWbAkcj8g3RJaytAP2kfNfa/gzLGaJ3oe2P/BlymKl7MAN4NUb4G9i7oqfN4JbVpn0bnn71ox3LzP08uR4p3EhTtwPUl21yABbpG621edCQVB1+4hjZnV5zH7+40dQ3SFOeVbuGxzfaov0W+My9m3+JC7mBkqueVvTs2qCgJzIA1Dj9UjQDnvgAOigcNx6KM5I9iggewdBYG/2u+PlC4Z12QvVZn7a+qRGY9eWXkKSIvddwh7j3VPz8Kwz8A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PPFD7DCFAC03.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.6; Tue, 17 Mar
 2026 15:17:32 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Tue, 17 Mar 2026
 15:17:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, Ryan.Roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, david.hildenbrand@arm.com
Subject: Re: [PATCH v2 1/3] mm/page_alloc: Optimize free_contig_range()
Date: Tue, 17 Mar 2026 11:17:25 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <2AE5B748-C57B-4BC1-BF9E-6299CCBF295B@nvidia.com>
In-Reply-To: <fde63978-d632-4196-b032-4cc20041fd90@kernel.org>
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-2-usama.anjum@arm.com>
 <220e97f0-dc82-4f37-b833-7160aee46cea@suse.cz>
 <703BB8CD-23D9-4012-8333-366837D7E95A@nvidia.com>
 <fde63978-d632-4196-b032-4cc20041fd90@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PPFD7DCFAC03:EE_
X-MS-Office365-Filtering-Correlation-Id: 28195b6d-bb03-4a55-223a-08de84384f57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sJdk4RLl9SuaEN5msXlnPq7u1A7YnHl12gmd9Cm0u5SRbZ4NilYBNfeHASt+/S/4pDy9wO/DVfj0SOanF7O0sW3rYQtHcPDRdKEVEJ2HNY1FX3Y0F2lUrZo5ccFJSxxk9P+QfzNKl1QBNWH07PCWuqzoVumykq2O3sqBUpgfvMbceNg6YPxDGZSu1VZvVzU9Q/eZ6yw5cXFsArNM5SgEL9qDBQvInS/1EUMCa+LyX1eIDVHnv2e4IGP2k+eQZTkvrqrdebvRV8eEIN8lt5eTjyn3yA7kp/Z4Zi8BKuF0RiHV1IZWrYSH4ePZq9ocgkQUdK2hkgI6sKTtQpRDWlbgAmO3JipfaqJ65G1jpQ+2nYKc0JUUAxZe6IjvnJ+MaUi4TJK0Eu2oWcjNHRlMndExnR+A3wIvzuxUM7PAu/v9V/P4omOCmbFQUCUTAqBEfrIXVdSAXse5y39S1O9n2O+V1LPGCIIhtexItHEu/MWu3QPmia2bwnIWP7YWoMkWkwW7W6vyQ7czC6HG/ygAMEpxOIzyGoxackC0MKa4mcGB34Y78+efysl4OfXp/vHe+O5ToKkdVQq7hD60BY/iJRqgh2MNThM/Ntx8NOmXl4uUBXFn8EygrLhcAfphjgAO3+WllTXkuzrHacGP7ewqFtok2C5rW+9wFkHXqzvDN7J4Fue390bM/NhFC4ImZpjyiYn56pWl7+NbqmNvP7bI2Q0pVIBFCc40AK/gtBnGudGSwGM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IUEvwbuzJ/AtolWaem7sESmjki9Q3AlRyGPZhVWuo0Lme+gaRRDXEY1zVmCp?=
 =?us-ascii?Q?gDrqXVd8jQq8Czh1QGUi2Yn513n6nL+MHlQ2XlBA8rVFQFarIv8JjKORLe8d?=
 =?us-ascii?Q?+BQ09GSuDq9wGqRSQjDxKO/Bo4fqEBESQtaYZaIXFNCBtNLYA/fmf9EYX0dj?=
 =?us-ascii?Q?KOsVNIho5Sqt3BA1uMbZ6fk2Y7RbA5nChgdFd+xgO1KaVX6DbO1wRgr706wa?=
 =?us-ascii?Q?Ph1fQpgzaCyosaswKyRj/A1E9m3t1LyOl2btKT55r/O6cZbsPX9ZpfeU1PZj?=
 =?us-ascii?Q?AQ9bOC0CQus7qHCXqLe3Qme5b/DTeKRbx053386kCa99PAwVzvnz+Q38Sw6T?=
 =?us-ascii?Q?iBwooCKLpigCyXrr9QkUslMUYJnVMw9eA1ZTZAqkCdKXJx8NGry6/GM/QCs3?=
 =?us-ascii?Q?fjryVKDPzu7AdxtX54BG1peamKq7/Ogt4FJx40OmLjW5hOeWz4ij9lmzCHUT?=
 =?us-ascii?Q?d0ObnD/VwICItj/SyIjGcSvJbymx1AnFko7eO04wYlwTAw4MURLzEjEF/Cj6?=
 =?us-ascii?Q?D3twDJwXSPw9LhjONySzGNxe5akfk8jXg13Hxc5ZNbvkHQUG5iklaX0NTO9o?=
 =?us-ascii?Q?DyOqnNYJLxN2HIKcFjHkbWTXnJ4w+YmiMhgqY7IGbM/cPZ6vB7LFoIcBTrOi?=
 =?us-ascii?Q?7MPhX4TJvq9XP8UpPeCzFRpoZMNsT6TwqzPrh2NtJhbmceT0C5t9tEL4efOu?=
 =?us-ascii?Q?zs4c5s2WbYsOrqpsJXZLrcW8P//9Ivbgy5FJgK79FCgosc1o2sSWJNu84b7c?=
 =?us-ascii?Q?IhnTjWMyZY2C0Uo7J/ca1XGvnp7BKpNnPQ0dgbDdlZ0VoGNvH0VKev9rCrRz?=
 =?us-ascii?Q?SZk68EKw3YDF/HWMZSZ1cG10fQ7t+rY7XXYRFx/Wj7OG3VqHuDHNPYrEv1YF?=
 =?us-ascii?Q?VbUODPhkR06RJWF4WaHNVnKpX0G46pVSoO/yy92NWR/Bnr4OluTvSFVBp2iB?=
 =?us-ascii?Q?fsb/F01zxYaq+SIBSYny3VbcUjOZ9YrBzWBOOmYVVFW+dr2dBTgN2NNzMgKj?=
 =?us-ascii?Q?SdMo8m37fAIuM+5EeWpQS9j1SrCsOPMmcRnxV0w8QUvgvyLZE8MzOsaCVAuB?=
 =?us-ascii?Q?nfSR+auQwz1hR9C+cMy/7M9hAlqyFfi4rQrefjWO55FtXUNuD3856QFx3Mr7?=
 =?us-ascii?Q?u/ghtBJ/w4rtfWC12F3RCsPt6221rz4uxO49ELU58d4dD77rRHsdLUo7d748?=
 =?us-ascii?Q?TqprDv8Wigi8RGUGNFvAxzTxyRSUbGn+ACr2yNrHPlKxf0aIQzW5ksuDtZra?=
 =?us-ascii?Q?ovmF9IrK0GuF33yIE+1g9Ht1OSxC/JP6q0WSgUezA8IKJP6tmu+WJ+taksis?=
 =?us-ascii?Q?sYrBv8jRtzK8qfqWdI/xZUDp99lvnWfyYaIJj/v+5ttQyIZJkTYPsfU3rVPC?=
 =?us-ascii?Q?NucrRN+1+Kw+QwUdml18NESDZveIdzHrJRiyS6Mm6vQqX00UWcxzPqMZcthK?=
 =?us-ascii?Q?jXCf26h83GyvODb4ZkfXUSNW2k4NMTvDutPrJt0mqInZkY8iNhBIq2QZQAO9?=
 =?us-ascii?Q?JOUI3SdzA/DFAtnLYTC30XmjtM0OqTzkaiH823T/VgB+iKd1A2ifNeIFDQ9N?=
 =?us-ascii?Q?QfxCRhuGShw9ssr7M+R6+K+iLv+AhL9/p9JRkDeMO3EPfgFR6ZJBYyZ4uvg+?=
 =?us-ascii?Q?r3+2Pe2rRNS9Gku5duNDUWrgPh5L3k2r8rsm8pYYrtT9qm+Y069sp6ANCUAk?=
 =?us-ascii?Q?HIaYP8L6+tHhFznYRnfKOxzLYAY8b6V3Z89OZhXtDIOgOXXx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28195b6d-bb03-4a55-223a-08de84384f57
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 15:17:32.0654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +dJEUJ81Mny7lQdEAlT37iPJWjeRKkXo3PexujGVbRpRfGxF6vgg4nfgBGPWre02
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFD7DCFAC03
X-Rspamd-Queue-Id: A770940009
X-Stat-Signature: eu7u1hs6es3yfwjeej7dehotu789oo5a
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773760657-548647
X-HE-Meta: U2FsdGVkX1/PyJHAhOEuSoYaVMpOmCNFhX26CX2DTLwyunIatQMl4SUSFEEgZ5k9VJhDHYKLbeF6p+cjWYNTUgiR/Fqvv1BOEa7Jid1E4OEZLEqFAzRKU6e0UYnq6WmjKM+zLGakePDzVVz3m9UdF6CX9PzBMHxo1Lfo5R26ESdZ2Wo+Tcs9gVA4+m1QQhsES/sFfzf1FkymopuesJx1AkLdZsKLb/UwqrwEn5iqnfLXrZsrc0qBU4vdJycCFRWQr+qdTevuM/uXiU+Ce6yLNlu/ZmxWcRHKn9WD6IKLuxS45bMCqpK0pPYWJx15FQQHvNTGdj3aDwgZU9eRiLPDpLpFdxJrLkfwbEnE/yG6gbvkG21zEXKJssMc04rcHWOyz8NX7NTUmpfL/dxfPcNd/WCuOImdgQvGba97WIEyuCPdEu8IO+wa8e5GHU4zO63o3H0M4dUcr5TT0vaFuCJX2RWwbI7sHc4Xdvg7HaoywBza+s2qFcLWNIqbxT8I4JxxGyej3HbO5LMldaLCT7tSKy/hCJq/+nlNbl1NbWv0BEzGpcOHs4G7mDDOf/txUasFm/0bEcjORtsnPpYZpLnpqrRfAQ51F1aMPyAJJ0iRpsfMCyEzikue+UVB45BbTiaADRAqMCJKmv7r6Ju/vutIZh402P4i3RBkwYec37alfa+Ri35+1caGIsO93l+6+IObJJDZZwI4dxhk72mufxAR2vQLK3kSsoAOopIestH8JgQLUtpYoa1t0TTiB4hq0A9Pw34LNcfgLyfwQnPOlcpEdnyNawe+v6/JJ8H6Tst5SUxeC2fq9jBTGeWBd4VSmunfj41Vv+d+k6ZARDWvrIL+pULLZCwN+UjCWLW9R1AkiUSelwnZ/vOtrPnsA7Pq5omyBZDG2kaMWvozd4RF8RkZAqK2MOGxuKYk6mDqoe9TYJATodZiWssvmtkdGAFl5e6y0LVIyDs1kKqKr0tfkG9
 IgU/32PX
 NRrL8LUbrFkKWhMJPERkHhGc/EV5Sd6tHd427JvZ7OpkaTj3hXOEzaO5uzZU9qkzWZnEqJvuV2iYNAVs2CkgPUp34f2KH2KQxOV0u5XAkwTVq/1RDRfcSU9OEC4IGDU9bE6/WKxyajHIzsgNYaPxunJ6P9CwkM90IkkheKrd0PhErE4qs8slrx7mQMq/CKyaTWF/2FcBLZX1Bj7zPXaXplTeo0N5Fgc05mh3NSnsPAQqCKVZpy5pUCVIRnkJWbMpKA9InuSK8yplcadwjID0G7xy8qJPUcgj0JZZdT9ZnmCWFJAw59ezi5JpwVrhCs23xkAAHBxfuA6ldndFwTqEqZXtRVLkQ8gyfm+dsFp/vH/QSyic/UC13+qtMhjyW5whxUlZTVaPuBkTb/VN9KT8zUlqaFrdnQXSJIXSxwPWGpLqxcTrtzTy+a8zjai4RHikJrIYH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Mar 2026, at 12:19, Vlastimil Babka (SUSE) wrote:

> On 3/16/26 17:02, Zi Yan wrote:
>> On 16 Mar 2026, at 11:21, Vlastimil Babka wrote:
>>
>>>> +/*
>>>> + * free_pages_prepare() has already been called for page(s) being freed.
>>>> + * TODO: Perform per-subpage free_pages_prepare() checks for order > 0 pages
>>>> + * (HWPoison, PageNetpp, bad free page).
>>>> + */
>>>
>>> I'm confused, and reading the v1 thread didn't help either. Where would the
>>> subpages to check come from? AFAICS we start from order-0 pages always.
>>> __free_contig_range calls free_pages_prepare on every page with order 0
>>> unconditionally, so we check every page as an order-0 page. If we then free
>>> the bunch of individually checked pages as a high-order page, there's no
>>> reason to check those subpages again, no? Am I missing something?
>>
>> There are two kinds of order > 0 pages, compound and not compound.
>> free_pages_prepare() checks all tail pages of a compound order > 0 pages too.
>> For non compound ones, free_pages_prepare() only has free_page_is_bad()
>> check on tail ones.
>>
>> So my guess is that the TODO is to check all subpages on a non compound
>> order > 0 one in the same manner. This is based on the assumption that
>
> OK but:
>
> 1) Why put that TODO specifically on FPI_PREPARED definition, which is for
> the case we skip the prepare/check?
> 2) Why add it in this series which AFAICS doesn't handle non-compound
> order>0 anywhere.
> 3) We'd better work on eliminating the non-compound order>0 usages
> altogether, rather than work on support them better.

I agreed with you when I first saw this. After I think about it again,
the issue might not be directly related to the allocation but is the free path.
Like the patch title said, it is an optimization of free contiguous pages.
These physically contiguous pages happen to come from alloc non-compound order>0
and this leads to this optimization.

The problem they want to solve is to speed up page free path by freeing
a group of pages together. They are optimizing for a special situation
where a group of pages that are physically contiguous, so that these pages
can be freed via free_pages(page, order /* > 0 */). If we take away
the allocation of non-compound order>0, like you suggested in 3, we basically
remove the optimization opportunity from them. I am not sure that what
people want.

To think about the problem broadly, how can we optimize free_page_bulk(),
if that exists? Sorting input pages based on PFNs, so that we can them in
high orders instead of individual order-0s. This patch basically says,
hey, the group of pages we are freeing are all contiguous, since that is
how we allocate them, freeing them as a whole is much quicker than freeing
them individually.

>
>> all non compound order > 0 page users use split_page() after the allocation,
>> treat each page individually, and free them back altogether. But I am not
>> sure if this is true for all users allocating non compound order > 0 pages.
>
> Maybe as part of the elimination (point 3 above) we should combine the
> allocation+split so it's never the first without the second anymore.
>
>> And free_pages_prepare_bulk() might be a better name for such functions.
>>
>> The above confusion is also a reason I asked Ryan to try adding a unsplit_page()
>> function to fuse back non compound order > 0 pages and free the fused one
>> as we are currently doing. But that looks like a pain to implment. Maybe an
>
> Yeah not sure it's worth it either.
>
>> alternative to this FPI_PREPARED is to add FPI_FREE_BULK and loop through all
>> subpages if FPI_FREE_BULK is set with
>> __free_pages_prepare(page + i, 0, fpi_flags & ~FPI_FREE_BULK) in
>> __free_pages_ok().
>
> Hmm, maybe...

Let me know if my reasoning above moves your opinion on FPI_FREE_BULK towards
a positive direction. :)


Best Regards,
Yan, Zi

