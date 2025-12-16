Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E0AD609DB
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 18:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04EE06B0088; Tue, 16 Dec 2025 13:44:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14016B0089; Tue, 16 Dec 2025 13:44:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBCBF6B008A; Tue, 16 Dec 2025 13:44:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C74126B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:44:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 633A31407CC
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:44:58 +0000 (UTC)
X-FDA: 84226211076.08.883437B
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010046.outbound.protection.outlook.com [52.101.85.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 61D8F180007
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:44:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ERn093lU;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765910695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cekPXQqiijyWsVhem3tNriBCREun933yiJtYb7mWwNM=;
	b=qfToYJNfi+gVpd8+qZSDyDmSNRYJn3X9IZuxavnRtTLvfmg5K+L3pp5HEUZxFlf1fmZH6W
	6kSjajsQSNq5zC5Z67He/NxTwvpuHmUL5v48POUPvzRucel3NTjI7t8oD+aHPdxAo5gbNc
	PtrSFEvnVqVCpjK/tsFdVZu/WXelPng=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ERn093lU;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765910695; a=rsa-sha256;
	cv=pass;
	b=VdspHLbEb52WR3YrgT+sabPLxZsB3Sk+trpJBrqJT0h6xyJQ+50eUXRMoLVahuYsAB2FK2
	PR3TLkqWMfsLDzOTMJfVkMeqiBDJbEchXU8CQxE5BX2v7/yhbq4ouae55T6RiRQVJ97U85
	X6qUKz2AfhsIvmyQWlGV9i2B405mUrQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kJnrW2J6ZVXSRd7+y8V4ljmydV6C7/xgeXqaofvn+UIUpGiddx+hypZ12VvhsWfFiNycjpq2e/MeLaDv8m7GGX2emT+W1YQlEtMeiv35Rsj79pD3yFkUVuAw3Q/5ERgGtaQtNEuybaZ7C66Ygp3jC0BhfweLKDMO7D3hqhqCXepD3AD0Ggp4cHwG9k8drmnBQ3dvmEeK3yueNhvyajUXitKaWfxTuNVIg5R2SGNljv2C8uNVQb6ZXUzAbOLJ+i2lbz1P/d2nomei6NB1euS8uMbCgX4jAOzKA7hLsK9R7846cFGkcGQpgVFr6hT8jhTzHELaxblbUrSAMkmx7nO0aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cekPXQqiijyWsVhem3tNriBCREun933yiJtYb7mWwNM=;
 b=NSaLtoaGlYM729c4iUOy/0crSpF2HbUZqwacvAljd7q82PDI6ir8+rC2S9gOArVrbcuZMwjwelFmprLCf0WOlWaHC1S4jSPszgrDFhW0hqaSYVda4lT6qefwFoatE70pqBZSp9dXC0vPgkQ1tztiawvf/YW9j4rBLaK2Gl7NpbJ4h3jt8vgtm0A27iIvTLdv/XjkNS9BhLIeag2q7d3a10K4BILdHGnEUX1dpTri5DLW2lLzUEMihAK1EBr/4+8G7nwBaTH2ohwl0hgice4cUksbdBY97fgbK5TTCYdY57V/xdWXiVAN9mq5hn9laIk+BmxlpbVPfY+gnfZhJ6stNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cekPXQqiijyWsVhem3tNriBCREun933yiJtYb7mWwNM=;
 b=ERn093lUG5Y19PXYvaEk/GXgGWopeJ7utDgJQ5xFtg5aPlX7zqTl3Wo6VX+m3UUMFZvDLIZLZ7zusHpu0cl1Fs9BCWQC6A1LsoitE7yIESFL9iJ1Pa3j2M/wEKIempPgWG+H+lMWT2cgdSFLgYIEZbHoCIkYAp39lDT1rYvq3HdctC/WoP+sejKUvEYunA7cNM+ATuizzfPpkm+X9k0mDaG0QaMYUjB3coqu7ujFH4Eh/A5Pksl4l4cQt2EooPrvFoSMA7Th3oAPo3NFj9p/lqXMy5xdgnfSJsiK/Ri8WEgT06LZc9AAYxkzLymABGXjKas6ZBRz/ztcQWGqe/piVA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL1PR12MB5730.namprd12.prod.outlook.com (2603:10b6:208:385::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6; Tue, 16 Dec 2025 18:44:46 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 18:44:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v4 6/6] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
Date: Tue, 16 Dec 2025 13:44:43 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <EA31F2A7-D0BF-4A49-8F05-C2E7B73A3556@nvidia.com>
In-Reply-To: <20251216114844.2126250-7-wangkefeng.wang@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-7-wangkefeng.wang@huawei.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR08CA0006.namprd08.prod.outlook.com
 (2603:10b6:208:239::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL1PR12MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f353b98-fe63-4d32-da89-08de3cd32f00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qe8VDtzgzvsRDVcf7Pu8CLvSW9IuAVGCUrepMzU6JB11/2CglHA15BlMOTXK?=
 =?us-ascii?Q?YNmHpw4MjVbgThll10l617gKwQHLn7jdf/AIsh0+/DJ10/6PWUTkkdZKa4X1?=
 =?us-ascii?Q?uEmmhoyAbPzeKmfVFQXxECjLQYF5VuPrMuqAzkiO4E5cbKl/1YRSHnwTKJPe?=
 =?us-ascii?Q?PyuqQBDqgK4jf31z3bmo1ik7M41EvPW7RBtMNAAgwGl5zJ01l91A1tpLq/wP?=
 =?us-ascii?Q?3LRCeCvcGsoVTZCC56WMzc2YhYlc7A2ELDi0/idnaPmO86BryCvnpUklW3FB?=
 =?us-ascii?Q?dW/E5EzODbBf3Vdd+2nzyd5nGg9xrZU7vuACLcgZGv5z8Sw395p7xoprZFVw?=
 =?us-ascii?Q?O2LCylAz+u0IKfaxiy0pazqjk2sglviw8e4XkTtPSnvTQBOYY9lgcb2XPOE4?=
 =?us-ascii?Q?B2ojSmB6E2DxeXFNKrx3A4+uJ+0AUAfBBpJR87pFUpeZs439nXKoVX9E+dzm?=
 =?us-ascii?Q?4pMAzGfZZSD+qd161sLOM2ReLzmG5+3RX/OZP/oJGPqFNiizhzpeVGlQM5LI?=
 =?us-ascii?Q?2NnSX5EjCeTFYKJyIYSHdJRUzj+7PmlLBB2poIyyPvFB+Zy5c0iGa1jzNIQn?=
 =?us-ascii?Q?Gs+axop/+d7u6g5S2v98D+zm0CUt3+93K7/90hGv6L39RDCKXylEbn3QkXj6?=
 =?us-ascii?Q?nLJCON/c0jq4psedzTqE4a1t16QusBsdiZDpfMXezfPGF2ELVO6T9onML882?=
 =?us-ascii?Q?KcRluxWg+M7Djl4t4JR4+Ir4BzB1n9XKQS7ZPBo9I4b4WdgCIrd6CT6lpFyb?=
 =?us-ascii?Q?5NY6ALcZP4hPdJPRWUr4vZsbg1hL1dg4OXcrnUNm1iWpRfnSRLPZxuHQj2CY?=
 =?us-ascii?Q?BqLtHQVnt0F9IoLMzR82rPQkSqIWsdWdUi376ORgyZxFLFedE2u3ltF+vuIr?=
 =?us-ascii?Q?W8JMBmVWpTjT51tE74jwwi5AyQVXioRN5FZ7JyrKl7NcA2yJIbLvuCZPFvIQ?=
 =?us-ascii?Q?5XpyLSfwNIWESh6zkPcFSNANjNDNF0ulz05NyjZqh3PcQ4LsSIYY1s1e9TWj?=
 =?us-ascii?Q?Erz8XvmcqhqK5KD6mDFcjbRTMDY1tuJTwSIZWXx297hwtYN9RDb+YIIZwfW/?=
 =?us-ascii?Q?E5rqDHvHHrhef8j7CvvzWSiCUXU/Qh82S6wVN4lqP7Qk79Ga/4gQ2B5Y9GGD?=
 =?us-ascii?Q?CxH3WEA4B8yGjEJlD8tp4aQ5EkxO2HZb8W1rx+D2iBlAghU5Y/fgEIcYenTU?=
 =?us-ascii?Q?mcBWvDzKg7xHZqTqgI9EB7jFZL1J67wMwGYCdIJZj0rIjgKTtrH8kemBCZFm?=
 =?us-ascii?Q?7uHXKP21Z7Mqp1TKhW62HXzFYQrrZEYtugtpru+lpjHwBPWIittM4mtZ9mk1?=
 =?us-ascii?Q?4MyGWJJYxd4iwHjtItX06bnderHild+9smC+UQsVqziSo5IkFG7eayIth4aC?=
 =?us-ascii?Q?p0HITfa7p2bh2tl3pqP/7iu/FD4DnRF8bEpt9mgkDeWKaps3OQ0ofOj0VW/d?=
 =?us-ascii?Q?ZzpL03+DpiNpFWTbyzixX9P34h7ILjgm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?owucM/ue8+dFkkmiqTgnHaRj//oIv0BdOQIh3mzNxswGFlsYew2+kZiWmodk?=
 =?us-ascii?Q?X5IRNtS3O1vEflrgd60PBu0w3gFo2Y8uMC6sG8Vc7R7f8cziJs4kbC53uKtF?=
 =?us-ascii?Q?g7mt0Lv5zBkQXZY6DlTtMj6Ps+7ZX/prQPufVTyXvPdzWmcBvZDm2LPvLGl8?=
 =?us-ascii?Q?eHzKzM+u/bW596PSVIUDxytNFwERpbfXvUyDYGq401XEPg7BzNOeZPUO+H4L?=
 =?us-ascii?Q?TjU6s6XcSn7CYPcINrsyKyFpXU1Yw76i6SGKDcHtq3Jn0HbUt9tZz1EytO7V?=
 =?us-ascii?Q?Xiz546HpBYuGtiwcHszEfTUnj5ls8v5vbsvoyiSm11lln2bmam3qBNnRNhLu?=
 =?us-ascii?Q?zj+EOjf/XayRiIeIIlr21aF0TX/GC748cJVBYjQWiwdJ4EE+tHILKOzjrGXQ?=
 =?us-ascii?Q?/KSray2dPaWeAYjcWNdNNybWpk6gM5qXGyvVjO8EURIM5CKmCVTKK9dY+xNs?=
 =?us-ascii?Q?zqNQaxxyoi9muuCLTOslEdDbdflPihcTI7AlgXg4zHHwyJ7GJuuhuKM4kZvD?=
 =?us-ascii?Q?Q0k+Ot60g85R29EH6SqPMlcRF+hlHqmBw4lxoDxwiEACowzeZSUCQn7D7oZ1?=
 =?us-ascii?Q?mkmVYYMEFe4RciIdLj7HATHjKi2CNR07B7EDNMcZURb038EvdzD3WB0227J5?=
 =?us-ascii?Q?7S2nYP9pZLaeU6YgfgMvhql1RSeRdXYC/g+eHsOTix+mTX59CglHy+jmbEZL?=
 =?us-ascii?Q?SJE9LMQCOz9NkCFMs+RH2mpBPXxRJjw0ebLCoBUwwLP+nuP7yHvw4OHpbza1?=
 =?us-ascii?Q?+tM/9zRRmxJAlwLQqnlxJrqXRNQjsbjBTUXNuSEi3rTzG62ynXAdxhnb+b2R?=
 =?us-ascii?Q?YhjlzVmDGhndsGkoFZIOkByh85fUKnlTg/LXOy0KAnlHDdrCRAZZIy8eo09/?=
 =?us-ascii?Q?SGyPBRZsoij47AcVh7ENKZXfaNJvIRYUFXNnb07OqIlsBycnXSsUQqX/Iu7u?=
 =?us-ascii?Q?iOQs4sAdkBaRj1mwR6GP0JOn9dhG0AEFBF8oEyqWQgc8BCnGbGIA9YZpGCXE?=
 =?us-ascii?Q?37gH8TV1BRkxG/GG7Hhi7DT8hIR5TWrH2tkJPCHocqKhfKsbiPWMKiS67pPD?=
 =?us-ascii?Q?ZrB1JXnHrPchr9XNrbBLMQVBMpSPWLn1b7pqsrvWNR7pi92y+tMKwoaW/Kch?=
 =?us-ascii?Q?FWQ9bnN+Vya47Dc3t7wXKeKBaYCdMikHAmkuH3M6+8jbB7AQNI0xXKSqVIr4?=
 =?us-ascii?Q?tEZ3dGz+x/3/Ytd+eR2dmFkdunQ6HxGZStLmn3dGgT07NOOqDc09QoIefkIt?=
 =?us-ascii?Q?I2DAlM1G51O86YmCMKI1SeyDSSidauxfitlGndsTkbNaQselWXXbsGPEh0IW?=
 =?us-ascii?Q?Vyjqb4zB9ZnIxoGyLgfCbJbV3i4woqhmDGTemP/cCWa0ZfmvvzvtWIvz4Y3t?=
 =?us-ascii?Q?T5f+dL7DX2eepnFrCU/HzI5LTXQzHZzHTVsmPv7ZBttu6M7dUUEW172NKGei?=
 =?us-ascii?Q?ib6Sa2hAt7iAZwLNc83jHGjBQNpoZLN4oJI0k1Elq8hlfBB3m/DVf/zGsYjj?=
 =?us-ascii?Q?8vJbgwYxi3SmVZGq67R/WsDFXDfcLmOGbBNEaSpnpY8aR9h/PcEfTPO/96fU?=
 =?us-ascii?Q?sD1mOJsMushaq9Bc6MysxXkD4D1E+IF2A9yerJ4A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f353b98-fe63-4d32-da89-08de3cd32f00
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 18:44:45.8706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGgVARjnVtnH4VT1FSotyIlG7jhbD6ZREw8+t/G0FU+JF8MqoVguNBKrLtDKq45n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5730
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61D8F180007
X-Stat-Signature: did4qefrjh1nfe38d3rb4rr5yj38gjfm
X-HE-Tag: 1765910695-80935
X-HE-Meta: U2FsdGVkX18/yewlVK9DbUzMlnml5A/e1ypbkjH93Kvz2svGGZhp1L6RUP58dHxKFDZoj3mazc0aPnsI0xM5/8kPA4SWbHKSlajGdNBVXGiK7SHa9epoJbl2+B0lCDv5D0fCDAZbh1rIyrizf6URT0D48+T+FXf07gDOY419bajc2pA+WjSGjB6RV84ShTNx+BMXFS5GFvMqnkJOiTDGNc+e2YfMkXlmAfbIrATR90m3dc92chFkxGlpdIZefF/zogPhcTQL3q+w3AW5oaaSyT/CWST2xZJ7mx8qMbhl2qBvqHvjbayL/CzPBfJOXZ2XxkaAv5xiAg231ReIkuimh020ch1MDRWnHmvz7onwKdT2g03XZdc44QJ/xtsYDzAGXFWXKhgmunSDccVCPIgaNKy8ygrJ3+BKLeM50S3Zgn7CB7eiVM0atJdN8QpHH8Fdgv1SIGA0Jq295J7Jso1RtmIRNXxJ2DZtKLtgnQ1sgt6JxPS9lFYZknzkOfxhxTOkthhcUN4pcbqe+vLX4mW2DZTv6bDpP2ao86ZU+xxyeom8E+UedEq5XBkvTW1nOsm0cKFSo1uaHcb26p05SdZ2XhhZYuc+LCK+yBU28plElJaHWd8v66xXdPlrahV3mUOdHU5SJTuvlPSR2p+T1++1zP9Rb/Q1Z5/I4ZtMPqyU3tzaklc5JuC5BtZyCSlghnMFYzv8Dc9XvINPhIGSSZdu3/o6qeGz2ScQsx6tWKZcG6UxzE7Fn//RFy7dlCaPfdR1+Cmf7CNVPK3XsbwI3ghZh61ok1DZ6OwB6sCmGJ/XM8UR9JATxJv51iuRn6VWmGLL7CRreBs9nUqdVaa0nNqQHoIMtVzvOrZilRIqYN14WnTz3phImRUT9uoeARHoG9xqPNhCbnB8BlctZkXkCKRM8PVKH/sH8Otkhv2Tpy/f6LN59cVr2Xe0LRTVAbVjEDG6/jSdfeOCEgKzMjmaBrj
 vx2BmqO+
 xz6Rwbdckz99oaiBQOfLO1LCnNMKKRILDFR6HulzfkTpZ6mNaDXMpEp6p2ccr3dCbp5jzsYuD8AKuMOqYQU7WsZxnrIjNexfn13AyNwzTm39TEnvVWs1pC04eYnXKTlmTsnpCdZelsn8Xd2i0OdRH68TxyXDT3nQLoA39akn2+s+sXo064pfUqkRQWlCEColoLgqgjBOn1aZI6jkQakiHZdmuXq6cFWplKqC2oLKT4tJKq5Hdn2EoLbwpcIB1/I7/gIdq9Q54ODLdWIL1V9dsldJ138GNn+DdZfsCTpLzERw+1ePXXlCqYKYISKk93UlkRaQsLaEb+ppoqkjw8FHd375y3zuEZVTFuzAtR3jAJihJLD4yPCTtbNvpzqj6xIns3DHiY3+uP1GYAp+2i0VyVlGVrzyLXKDStc83IwLDhH1oGrGVhCKG13BHcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Dec 2025, at 6:48, Kefeng Wang wrote:

> The alloc_gigantic_folio() allocates a folio with refcount increated
> and then freeze it, convert to allocate a frozen folio to remove the
> atomic operation about folio refcount, and saving atomic operation
> during __update_and_free_hugetlb_folio() too.
>
> Besides, rename hugetlb_cma_{alloc,free}_folio() with frozen which
> make them more self-explanatory.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/hugetlb.c     | 63 +++++++++++-------------------------------------=

>  mm/hugetlb_cma.c |  9 +++----
>  mm/hugetlb_cma.h | 10 ++++----
>  3 files changed, 22 insertions(+), 60 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ed185bbca419..7779ec838da0 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -121,16 +121,6 @@ static void hugetlb_unshare_pmds(struct vm_area_st=
ruct *vma,
>  		unsigned long start, unsigned long end, bool take_locks);
>  static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
>
> -static void hugetlb_free_folio(struct folio *folio)
> -{
> -	if (folio_test_hugetlb_cma(folio)) {
> -		hugetlb_cma_free_folio(folio);
> -		return;
> -	}
> -
> -	folio_put(folio);
> -}
> -
>  static inline bool subpool_is_free(struct hugepage_subpool *spool)
>  {
>  	if (spool->count)
> @@ -1417,51 +1407,24 @@ static struct folio *dequeue_hugetlb_folio_vma(=
struct hstate *h,
>  	return NULL;
>  }
>
> -#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> -#ifdef CONFIG_CONTIG_ALLOC
> +#if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_AL=
LOC)
>  static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>  		int nid, nodemask_t *nodemask)
>  {
>  	struct folio *folio;
> -	bool retried =3D false;
>
> -retry:
> -	folio =3D hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
> -	if (!folio) {
> -		struct page *page;
> -
> -		if (hugetlb_cma_exclusive_alloc())
> -			return NULL;
> -
> -		page =3D alloc_contig_frozen_pages(1 << order, gfp_mask, nid, nodema=
sk);
> -		if (!page)
> -			return NULL;
> -
> -		set_page_refcounted(page);
> -		folio =3D page_folio(page);
> -	}
> -
> -	if (folio_ref_freeze(folio, 1))
> +	folio =3D hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodema=
sk);
> +	if (folio)
>  		return folio;

alloc_gigantic_folio() actually returns a frozen folio. Should it be rena=
med
to alloc_frozen_gigantic_folio()?


Best Regards,
Yan, Zi

