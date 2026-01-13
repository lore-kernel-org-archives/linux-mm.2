Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3C77D2F33F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 16:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C8A6B008C; Tue, 13 Jan 2026 11:29:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 314016B0092; Tue, 13 Jan 2026 11:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216856B0093; Tue, 13 Jan 2026 11:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13AC16B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:29:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB6B48968E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:29:53 +0000 (UTC)
X-FDA: 84327477066.12.880B1EA
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011013.outbound.protection.outlook.com [40.107.208.13])
	by imf25.hostedemail.com (Postfix) with ESMTP id 14969A000D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:29:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ln2b7zEx;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768321791; a=rsa-sha256;
	cv=pass;
	b=GA6WrPel+KnOe/UxajwTeQX44YV/yYArgm20YBDfhA1HRZR7nAi6L246asqzY8ExXVKusj
	Pe+Yaf/+I87AEkd/oNSZMEAxflNLAd2BVzIEL94s7xFK/ztPfza3/8sgEnac1ENdEjt9xE
	KriXtB68J48dKpIUEPeQ3rxCqh3qvMQ=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ln2b7zEx;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768321791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hq370RCI729iKNPJ9K4FlWCtCHGbW/viQS96lERCDtk=;
	b=QGEhWzJX7Q3bUwP+k4luND2zTthNNce5c9L73jDW95Kzfz3vh7gRaOEMHVR++M25U9XjSg
	a1AsgwXuClfyIqDs2Z+2NuFyAXg833amXh2JfJmHSosjiS4WWA094xlu+QxeyktHgRrZsZ
	Zt+87AMRT8Kx9jkdHgizbcPtCeooKok=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xab+q+3l6vGi/N8foOh3WtmZRImWzp5+XsKy9BWX0m8IQt8ZD30SmOhG6NbaOENhURBVhiywqYJRUFcHGHi5MBWZMb9DLuSalUpGU14PetLcQYqaaIyawtfF3k3NStJv3N8OvVmxSMN5pXJfFHkkGvrFgFqXvc41US3P3KE+rn6drOtRjB2IpWtfZ/aQmuZ2arTrXjMve8sT2XbpBmZm/apbtuDyA1Mk46EbjgArJYyTjOsuKlhxiCObN6IBcRUNlHIt6929qvCkzBOGHZVbP+1NG93e0tFPEvZ4GT0MrrYHXmrA8z0i1gPr7l1cR1LV9zhZNTYgjt9vzPIAdLEn2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hq370RCI729iKNPJ9K4FlWCtCHGbW/viQS96lERCDtk=;
 b=gKYDRlbiakNaSa7jlQj+miELQAtRbIggnPK9XKW44E7YTjCTqTnd4IMgobXauTiwv6onDtz9dbXYOWtduS26xTCfwtojzrgZJcyra7Lm/mh2hJaXBYzQZz5ZQFfK41srVMi5SB7egVP9kcxYx3WLJagDqCreIarfLRbufpAYc9rwpvh0EMIultJeQfivIXEqXjaRIOfRztPB7WuXq/PPEupnVlYc8OLGGq2qycXro8co5uigmbCrEjPRQ0Vu15RpNusddEq2pbTlKqtGWhG9CChkAif8uKcNkwwWQulGzzNJBStkdOtmUSBGYoxfpvArzlzwWr2X9jkg424j96ADLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hq370RCI729iKNPJ9K4FlWCtCHGbW/viQS96lERCDtk=;
 b=Ln2b7zExlSJts8n53sZ1diRzcDDBUCoWSJFljqta8bdV25Z9vIgFJUfZdDDTYIyhKVQahwRd65PQuaO1iG3YPx1hsdaV+htrRtKVKpRp/OoJ5CqAGEYcILFJVYkJi7Hb3OFQXUDPK/wlq7NOphnP2XtG21yAbYopYfjv5SgFJ8Lo+P/zlhuyVurVLmvh6JsMnoJlD/aTRyKJEf3E8L1RVLiDzl//XLQ2EB5ncgb3GWEjznlfax406sAvBPIwJQr0C13E8Bh1U64sH7knXZ72Z7hnEWqN+98WwaantMtiuF+o6wLXl/L0qg8k3e7aBTS5W7kR90bnw1CETyj8XNwnDA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV9PR12MB9759.namprd12.prod.outlook.com (2603:10b6:408:2ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 16:29:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 16:29:43 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 5/5] mm: hugetlb_cma: mark hugetlb_cma{_only} as
 __ro_after_init
Date: Tue, 13 Jan 2026 11:29:40 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <B1967F28-A159-438C-8220-5F67C821FE4E@nvidia.com>
In-Reply-To: <20260112150954.1802953-6-wangkefeng.wang@huawei.com>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
 <20260112150954.1802953-6-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0038.namprd07.prod.outlook.com
 (2603:10b6:a03:60::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV9PR12MB9759:EE_
X-MS-Office365-Filtering-Correlation-Id: 63f61d7f-45a7-4b8e-d0bf-08de52c0f550
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WRgu2AvjoAHCNx9nu9b4RkO+ENF8Vh6yFA2JiNj5Q17rWuHS345TXmpO79Hq?=
 =?us-ascii?Q?hWIpEXCJi5aJvN6M+uQP9q7403BQ3L9YiCfJlDU/RpzyWIRKB/lo7j7MdeYu?=
 =?us-ascii?Q?8lCAFkxdOH6rQ/3+Xkheu6F5qNVHb6+h+1cmOKxTrdsHdEYSJTTRg6H3cmh4?=
 =?us-ascii?Q?sggDAzqcxCmE6qDYuqlveE6yRA6i4rWa+0e+ddeR1vzY046Ne/BM+DIVBj+b?=
 =?us-ascii?Q?liwP922Dr/w1vknyoRApAxMPqRbixyg0UZ/T1Y6OuZFMvDM04Zq9GlgnyDXi?=
 =?us-ascii?Q?XzNOBLB+qoCwGbyhruQEP5oBFerCSbTRXLF+W3yzUcawaVamJCME+Q2F9y7r?=
 =?us-ascii?Q?H7/Wd9RdfvleaXAYDj97bfl/94fsftqO1L7bSib+hI1QeTIpztJCAJ++WsfK?=
 =?us-ascii?Q?renwqu+S16WvmBtToFppXGn7tqxBjDp7/cRRkrfLJAae8qRwcGdcpfFddvi/?=
 =?us-ascii?Q?rxnyn9zRNDWx5jzPbw37IlsGiMaNsdp8TYlMqwRsgyYckPYE5egMz6eyyV/O?=
 =?us-ascii?Q?PWjoDNqsBEUOLoycr+Hw3YBfcV9kdUTG7TPoygTe891X8eCbSXjqybfuNhAo?=
 =?us-ascii?Q?pOXXEWUqjFuD0Uxb6lvguL8ztu+o9voKvGDsoIBDkDI4VW+e5fzpS0PIUB0R?=
 =?us-ascii?Q?S2IsBPqTnAJF1LwAkNmKOB6aaRfFKOOYP2TzahOYQMehNcevcfy8Yi++mOUb?=
 =?us-ascii?Q?dlBZU3oL/F/tlSdTxmQuVRpOMGrFjHnApreDc7KCrn92BUzl1IHI6KLUAtTJ?=
 =?us-ascii?Q?EMrfk9brIn2UGP5QGVCcWpDY9CR8UGhT/3N5o5MYUQEFpOnIuNE8xQ5hl3F8?=
 =?us-ascii?Q?O7RYrQLH5GsbivvbvtiuQVDpmvOILnsHxqUDljMaPKY15fjWBAtKfIzJTXOS?=
 =?us-ascii?Q?3D0q5TTRX9LuiO5l0jgDpJQphKu5J993cIK/VIWs0YDHGt7GOkOYv6G4nnLv?=
 =?us-ascii?Q?QC19u35VLUwG6LStJ1lC5TJMkRnaGCcUmQvhSLXQiR6DBFs5R5rJ2pOCXPFC?=
 =?us-ascii?Q?gw/w6li3oUaow5XdeqwGrvnkisLisfROO85Hr89PU9aIpZRtcHqdVquiCfNn?=
 =?us-ascii?Q?4k1seZCg8kjrPz3ITKU4+hDlZpsAzL3E774PUMQ92jnQRi6X/ff+XlvlPznB?=
 =?us-ascii?Q?PsTcbEtcMvLeHndXqOIxBiIwQfpdMhPQhJHDX3JyuWhDhCbQugsbcEfEWdvG?=
 =?us-ascii?Q?/QqKiKXJZHYKTkTByvMHjlvRjil/qtFcRTWHXgFVk4RPEdbFYJhq7+mCsYoC?=
 =?us-ascii?Q?82+WAwzvl//GfI+eSLWxEwaWYMXN4Xu1cyyndMFEIHKbfcabMdRIgmi7WRt0?=
 =?us-ascii?Q?STVNEs831SQuLLmLsVFOK8IPhiM8LlPywjINSPcA5dMitRMbGEpR1CzIx4NU?=
 =?us-ascii?Q?h3CEpUDc/DvpplupSU2EVNUPA0RKp0AszxzExriqCUfD9wg7IOcMLehsWpSj?=
 =?us-ascii?Q?HYvAf8S8huMxu++QbLSh/1M8VwMZ7+2w?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?APsuPLaZYJkNX9ZqlnAnlOgC3HT4CRf82Sng3hyFbHHgvIwg8kI8cHhu86l9?=
 =?us-ascii?Q?7bGvncM1RvMN1uwjjBVBtZQ/PY3CUKcC/tn0o/k4aCi0rHmeRIIQGlIR9A/5?=
 =?us-ascii?Q?tX8OzXgvrQgDZML9/v/kFlgf1I+1WKldW8Ppq+O8QHAWKHH2rurkKhBSxP1u?=
 =?us-ascii?Q?VB2pa0ia4ZYxez5LuGTLEpZPMiEjMVj5rZbTo52PutUDMDtii7UDNkXkcj+j?=
 =?us-ascii?Q?Jp+zSD0jx48fm9JNbtqSVqgVfZ9nZAS5vwhyQxTThYtPBSH9jqswH98SIico?=
 =?us-ascii?Q?0821pLY9RIHWdjLN1/PlGXUNXwGA5obk9WU4DtQvkkmScD3pW6QOY0l51kch?=
 =?us-ascii?Q?mx2D/PlF492R2W0CsEPHMqh0G0sTIsqFRrvDkfBYgJ7f65A703Bpu84QFDKk?=
 =?us-ascii?Q?b+5WCaZJCaMNXrljwmyWkClvkkvsc0+e25qGFLuL0BGW1bNtQaku9pwwP+2u?=
 =?us-ascii?Q?a5W5EwY9KshsSEnB24VtcXtCW+nMXKsEKlfvXLAdxt0vt4di5YtfedaDnV9+?=
 =?us-ascii?Q?w4YVE5uqLxlmVgAgPWILynvJaC9NON3Pf1XsOzsc6fxyL0pPBFNMLH+WvHkd?=
 =?us-ascii?Q?S5PY0+OR3QlanA+xm+1K9b7LR8Jlp8ZPVWE0jG0PkxwXVFDLAxzmm32muSG7?=
 =?us-ascii?Q?uMUbAWj5zgEqVnaZSg9FE4t/QAS+HgUO/mLSeDt9u9jtdm1uk5ZegiWfMy03?=
 =?us-ascii?Q?yjWjt9p6UglDObWfEZ+6LmaKI35XivOem4cgmN6b0kh+VbdEd2lYrAQxSpAP?=
 =?us-ascii?Q?S9qdKlYimxvTEtJTjnAfccVDZJ3AsiO7B7yqSjAe2U7wZQxRNhnnDNmvATMv?=
 =?us-ascii?Q?dpL/MmtH0plIDVXgdlAJzIc09EZEjbIJqq6+jfW7DAYrcW9M/cTLQV2dxUqe?=
 =?us-ascii?Q?4DUPX4V7QIhFWBimppbHWudQzwVVjgq3e/ydKh9dNPFy8LRahX9hx+Rl6lV0?=
 =?us-ascii?Q?GSz99N0HSggEx5GM6kjyx0xgnSMAOhUiATEaivrw+/Du50+iAkNjJ9JpnEXl?=
 =?us-ascii?Q?VMBL5GgvgUMVd18erjcPC9Y+SG8R3AYH+0ilKZhykT+8dq5UT9QqwjD9aMjb?=
 =?us-ascii?Q?eJYNrdb/balY3Vb4S5LH72th++/YrjZCm2TZIKm3LnhZgQNuAcMwsJblnPS6?=
 =?us-ascii?Q?p46IyTX6pCIvBe9GySBqfDOmsxwm6O6yuAI/bZqlKuFRaWqvY3vd/7ner86A?=
 =?us-ascii?Q?3QkCOw5/POT4uCJE2SYs6F7R3bQGwXPUzY6dnbDnreYqfxqeDMj/2yujA732?=
 =?us-ascii?Q?Ys6V/MHReE1vFV4xSZM4BWaxYZNPjOAND9Wk/XYvXLMbEg99zxrx+L3K413c?=
 =?us-ascii?Q?PFe+QQ+K8JmdqAy+0JNKxexTgSG4CLd1XVQxww+FCKowkLrgIFA4tOb57yp8?=
 =?us-ascii?Q?biEYCJL/SBQeGeJ2+Ed6cc5aSYvvYknxp/svErWmEzKiXUWnCaOzoVOeaQcS?=
 =?us-ascii?Q?n/32Vj7ebVn5Lk+w2vmqtQwVMd15E+0RQpLe9dW1AyuS/aXyTxolmcJ6zg8b?=
 =?us-ascii?Q?bR+fE+fsJgeZlU3Q6xtu1yTEJWpsv9xaeR7CCrZcRzuo4IntilgmiJMB88r6?=
 =?us-ascii?Q?I4ZkBJdGG7T+ddB8mjG8td1pjKcTU1YdhUiJgY8jTvcfi3o8uXe2zSgoUjLy?=
 =?us-ascii?Q?RDuHMTS07GskdmguuFiDV7jBEVf5q4hBAB3r2f1D62zg0r5V/3V0LA3DAXpU?=
 =?us-ascii?Q?p8RPusarp56o5p7CWrAMwa/k04Cv1UaerroK9VRi6bfiF8OfA1xIZJGY6Z0x?=
 =?us-ascii?Q?Y2U5ukYUhg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f61d7f-45a7-4b8e-d0bf-08de52c0f550
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 16:29:43.7248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0wELc73sh/pQ5RtUNPioJAlX6QfnkG+inyQuTwVXLdH8SEU6LsFXrUE1f/QkY/tN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9759
X-Rspamd-Queue-Id: 14969A000D
X-Rspamd-Server: rspam06
X-Stat-Signature: xdq9utmny46nnwr7m8a6bnhaf4inu9j1
X-Rspam-User: 
X-HE-Tag: 1768321790-996940
X-HE-Meta: U2FsdGVkX1+WFGOMVmJyeauYawne0bODOYzl7nadX0j+DEAq2blFk5QrULfNQd3etSlAiqQa6jfdOUJHAMYToYyGwtFEhWXdXUGZ/kkbbpgmyS8eJHVSVhuaa2fninA3qbeQc1E8dYnVBEOmmlr6zH7pvnEuictieZu3eVdagkNdNM/hyw8JiWD9jXT/7WzFXR46tbawliMjPTgeK+hnIWoeYrECxQIvKJZl2o6FhO6GsPxSGPAPa2gjoUsnYA8xzHtyN69TGJBFOt3FAP+jHZkhKYtyvt+A6Q8RvoIwLeZSIEeY+iRXQR67i8vZa46YhCN1yljtjEeLwJ2mI16/i5lvvnjdwNUTGSFy1Yg1+O78l8xxe4mLQSy+0dAIha5X1qt5vJLA4gmOK6hy3zQiFn3rSWRNeRlwtFVmzJUUNU3EDOiBSGb82bnlqCb2VOB8IVJZV3uovcOwImr92f/b9Jg9yEAD3jTZdXvU2NFvNsrV/hbfQYHcg6n2rKnBO7xB3TI3IpKpuQfeX2ie4sGslf3gOGO1rHVzwuCQRKKeXqYm0GKA23W7yVuzvQbipr/7GYmqLuG2/RkEig82Oi6olYxLNHSi3Tdd5fUhzqV43qJvOdnCYJAk+QNprxRLHQWE8yOOp8spIPbBBAOEB/Q/jGWS7kFxF8rns8z6Hli+B3xqnWBSdFUQVyhrfyTPhZC/dGNNPGfeXhoOqFn+tTO7R3A0c07TIf1EE1fx6S1aT2/gZUnyGbah2QjGtVPFXbZjaVhilOYLJOEc4CreomBOJfxeHG60XtsMPMquIfdy1usc8LuIdU62CNESbwdimBDdd2O1sAZ/csD82wo72hFy9Gbu5L58UMkLeWZ+kxHYoiStrXRc59817fylDFlVWZhWDQOy2m7FGQ4tAA/wR4bKw14R7RFy+VFXEStrfbcS6rQVXT1THG9Cbbs6qhznmiGxMzp87UtaBGQhJ8/dcmP
 5t6ABK4z
 aKIggPfg1TjkaCRITcNFEC8BZBh3R+1aXPplJzUH8EJjCsRZ0iHkGVgXDhRc3AMtOOQ0Iktd/9Pp9ZfWHqPw5eKIXYQcj3aM001QLe2nOwiokuYWSdrMf0TJ1SXvsXXOvPUSHsJPcaFMNgkfwN509ALh5Czr0lju/c0yDNgtIiaTgxo8XNrq9uLjlL0gcLVnlRdoZGQE7o7yqoDMeFuME5gzw5YQrLfs9iakfYuQxixkngquyi4ySN1BYTwnVUivje7XqBdAI/66UfZ9uB7xjnWAo+JYlTrA5Lgex5ai03irUruLwMMYcd4rQTepc/Lewu34W07Jku9KClTyctBOanWhYYi5gcdzo1buKzUVWrktZhP+1mggSX0W2TtlxQ9lZQsQY5IXO+u7sTJvnlCkAWly3KxZMjdrbzRt7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Jan 2026, at 10:09, Kefeng Wang wrote:

> The hugetlb_cma and hugetlb_cma_only are initialized once during
> init and never changed.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/hugetlb_cma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
Sounds reasonable to me.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

