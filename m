Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D25D1C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9AE06B00A0; Mon, 20 Jul 2026 11:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B5B6B00A1; Mon, 20 Jul 2026 11:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EC5F6B00A3; Mon, 20 Jul 2026 11:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63EEF6B00A0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:45:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC7F640206
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:45:23 +0000 (UTC)
X-FDA: 85009579326.19.C76D4B8
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012038.outbound.protection.outlook.com [40.93.195.38])
	by imf04.hostedemail.com (Postfix) with ESMTP id EDEB440013
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:45:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f+3pHEiv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784562321;
	b=W/xqzVAsNkIXHSEND9MUkrLnNlH7ZauGr1UQmOdvQVyjhP6lqNMbfLMyyJmbfYq+sASvd/
	/SHAGqLOSmyUzlZxaf1gOyAHXPkdAfyGS1Ao7wlImCHzLMpszbl3mExSgGMSryEy43zMQH
	IFyz0TSz9cM1LKkW760AdkhoZieLo+g=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f+3pHEiv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784562321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgPa/Xw/ASPcnDtwI7fZIsZT+/HMybYhb0aL4MiaVVc=;
	b=6acAU6S4CCRLj5FIlbw4rBUh1A1Jf1egF7mCAdzyMa4ec2MmKFtNkwce/0GS07C4KYuw83
	JQFrEQtTYhyHLc5SzglDM62wmQb35K1w7YmwbO4JycCDbxyohGKX3dXuxRneQEtJgBZ9jX
	YSR6ZZcE+GmDvq6SdFd5RCDvRtFMKLg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQs6Libw8tTOPlPB1DWoZ8Ebn8B32wNvADqhiEM/cnJo1IOg7nXiYGIjPKN/ZUleXo+RMoWJqebeCqJ2pAGd5IGlKi98FzAlramMEY55ZXvijQAk7j9SwrSRbnppgm8BuN6pMt9USXsKjcJOLRKpMLJpoS7U8ibRZK7eWLHq9nP1v/zWanCs1qbBjm5DiOQVOoOj3RJ51rwq4HnIxeRTNUbiJhOPz5AXkbmX1psUfnpejyotOiNBLToucpYH/3ggLDqxsJXMWUAZSelNj7NtL+Q36vHtE3EINA6n0V9ttMelSDeUlkoaSMUTjBBwKdEjlucid0vZr/YDy3qpK0S4lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fgPa/Xw/ASPcnDtwI7fZIsZT+/HMybYhb0aL4MiaVVc=;
 b=mUEFtP7jVMSDXbMLkvP+pMbv29OmSmOd8e1DQc4VM4Z6XgxxiSsgpHw5PpDa1ZcD3itwTlqArC/9w8cIx/ImzsO4ScDAfVDAqp9XNYPy7Q3s0CYsr6t5tNHt5WsKdpK+vZdJTOnn3KJ225LVcBwD1ddJXp/YOuBhYsDZ9lCSQdE3rswTmZz+KBjFcLMVd2MlO5s8ag1czTFNA4HgxH+tj/6uheF+kONBkgtsg2AG2mbHdhOi12Bqas3JZLPzwCqq6Q6ZuzxN8opavs871KvU4oV0kNYCDtBgS+IwGBcguS4l8mOy5vZi0iXtTqMputhrLps1WTu7aKyy1jmnoTBsWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgPa/Xw/ASPcnDtwI7fZIsZT+/HMybYhb0aL4MiaVVc=;
 b=f+3pHEiv361fdcTlQtAG/EwRAWOgQw9JBXHTBEh7J3lAC2lybIFEWW6PeoG+YEYCjNr2OboDFFBF73mvc0EnaBibB49ivBaR8ckqIfdWWyL2vEMtDKq+FcA021kOvF/SKjYliwV1yPETPL4C+VFW9FJbhn9b8da2iv8B+nhM+WFlwxGrnHBVU05GW+R9Xjq7I2TTdd8/APD40mJSbjsdmSb7+ONHriKSsyzd968YoqMVLstkLeJKq/jWoHK8Xywddjs7fwaiSeY+3xXDiN4Tpd+hxKduCflwgajKVxfzSB/jIBwF1IyDxEilJiA3wfUVP6Qp2vD4XhxBS8gtecgNHA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA0PR12MB7091.namprd12.prod.outlook.com (2603:10b6:806:2d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.16; Mon, 20 Jul
 2026 15:45:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 15:45:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Alistair Popple <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Karim Manaouil <kmanaouil.dev@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Teja Vojjala <tejavojjala@google.com>,
 Pravin Tamkhane <pravintamkhane@google.com>, Kinsey Ho <kinseyho@google.com>,
 Wei Xu <weixugc@google.com>, Matthew Wilcox <willy@infradead.org>,
 Davidlohr Bueso <dave@stgolabs.net>, Vinod Koul <vkoul@kernel.org>,
 Bharata B Rao <bharata@amd.com>, SeongJae Park <sj@kernel.org>,
 David Rientjes <rientjes@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>,
 Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
 Dave Hansen <dave.hansen@intel.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Tejun Heo <tj@kernel.org>, Fan Ni <nifan.cxl@gmail.com>,
 Jonathan Cameron <jic23@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nathan Lynch <nathan.lynch@amd.com>, Frank Li <Frank.li@nxp.com>,
 Dan Williams <djbw@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Mike Day <michael.day@amd.com>
Subject: Re: [PATCH RFC v6 3/5] mm/migrate: add copy offload registration
 infrastructure
Date: Mon, 20 Jul 2026 11:45:08 -0400
X-Mailer: MailMate (3.0r7022)
Message-ID: <D0E763F1-4576-415E-953D-8B46C4773D7C@nvidia.com>
In-Reply-To: <56468737-471c-4d92-af01-a0c93cafdb1d@amd.com>
References: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
 <20260630-shivank-batch-migrate-offload-v6-3-da95d7e8b8a2@amd.com>
 <87wlupx60s.fsf@DESKTOP-5N7EMDA>
 <19F47514-EBC4-4659-8252-EC3765D9B601@nvidia.com>
 <56468737-471c-4d92-af01-a0c93cafdb1d@amd.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN0PR04CA0092.namprd04.prod.outlook.com
 (2603:10b6:408:ec::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA0PR12MB7091:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c165a84-e127-4e52-ded0-08dee675e248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|18002099003|22082099003|10067099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Lukz+AdOPbWCc1H8+/k3ksjEMMjViEpvvnwIWshyNIZblELkdbRS/d8vnyFlUNmbCPRM/bUoWBJDziCSw2uXbVYS/PcKiu3bPOwv8gJ0ia2UvyygTa02Z4lNDYd1DImMKUdJFghlREXeOLBXpwP5yQZstLB+5bn3+lWoNAc+/b9ygZXYp8hCO3IbIqfyRiyE0Fp78urK4cRvActhG2uGfq6IDQK3o6OVVaqAkNAHJwxnMw6iu6RKKzN47Dch4XlHemW3wmWEP1fOZdfSOXsxKzlDVBgmW7Mp95/+RAbxTZkL6qik350cWI9ci7ujLa7+U8JwU7osAYfqI2N0iUg2PofH6JNJmmRJmfVKt31d6GE8itHRmTvFD44W3wh8YA1JQp96uo20TtX3CEzE/veCgXzbEGvFbjvtt6zrJ+J8OLLdPOTszceI2cZIy3B1prWUXe1jypYWHwShT9gToWUWzpdf19HSItX1FbfQ/4FpbQMmVk45Ax6rSJMrSIqP3PKhKiYlPlMr6d7Cl3lIQ0ihbDnfbfpEXGVnkLvUK4/xEfqdUa9jbpLMVf12ub7IoPZvAiXXy4yuPLxNAXoKiJUWUGH4o0Cf9UckgTMVXQZ+yB7J8O9l8he5y+KHD/g7T+Qgllb2tdPT7NUy4CRznWu+PyUt4m+MoNC8Bhwq16AAM8I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(18002099003)(22082099003)(10067099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z2CmmKiiKDJO7KTse3yFURLGsx9fbZHI90jISBD0/EFzuL5X2kBFa9zE7E5q?=
 =?us-ascii?Q?mTv0L3SThRgNbVbgJgZyxmwUS7e4JFpzZXVHpaptjdhBO2mq5x3z8jnzMlSR?=
 =?us-ascii?Q?BhedhvNuB297YJPViXvt33b/Ye2rh5448U4L8ei5DHwwmu3Ens00E9ZE1nB9?=
 =?us-ascii?Q?CH+Dz5D+fGD/gylXbao092IMiJGEDeXCz8emzN6u5axpHMfwW9Qmi2YZ5qOE?=
 =?us-ascii?Q?jfjVZflE4bzoo+SW5eckppcl2/OoeeIZPuMvj87PXQqXMPZJ0Eu1GheKmwZx?=
 =?us-ascii?Q?F4btv3UDlmaKlMmImvw6zgbafESEVmw0Dbyo+YT8xsPwLlZHCyq5vR+74hmm?=
 =?us-ascii?Q?uGUaB6Alhqc7HTxqhwq9Vgtarye68IqbI8sB4tWo3B1R7X7agsrDiMBFM1H9?=
 =?us-ascii?Q?Za2h2QjSjkYBjJjZzDB9xwd2D8x2z5VdVAhL/3NEEA5Xg2MmamRxA1X4EpLD?=
 =?us-ascii?Q?wLVS8p7m3KWuOavGoSHySqjkC7xNuEVdO9NrxhdppB+3oykj1k64233BmFl5?=
 =?us-ascii?Q?f3l77bqoxbBAx4TbCI5SBHMGOomyFFjhD8s2UpwJrqw3C646e1/IcDZH5AgU?=
 =?us-ascii?Q?kDNGhttz15apq/aQl7QFrKBNiDIoKn70UgcAKJA+25rerx/tbr+x5KgHXwju?=
 =?us-ascii?Q?/lsTy+9kifiw/p5V4HFJ9WPM0Avd+huXRlFBZBK9eZODbFaK5WND8N9NlXMR?=
 =?us-ascii?Q?Z6HICu4czbDho7/IEVNDNdDy0FJ5V54CA28neHpqsJvIuoaL284M3BnTwMMw?=
 =?us-ascii?Q?02VZlOqpOR21arpy/W3CJyXoyy/E1Ubw65rwe0fgQfAzWxq6Tw9fEUCnaZ6T?=
 =?us-ascii?Q?3c/kKGckk9F9M+pkQSvnCn/Ra95ETN76tUXfwlEIW1Q92IyQxAPJ0OCdLuKl?=
 =?us-ascii?Q?xJelFnT/thakzLl4nFykhmsBZ0xnZixsTgqPHEpOCFwEJl+HsuojOv6t272J?=
 =?us-ascii?Q?Q34zzFV/UM1yj1KwYddJv3pxbaKQXP/f7jNJJ45L5+o3QyCIvf6tBlU+dvhw?=
 =?us-ascii?Q?gaRRn2r0tvGQEIoG8BITE5A616NQ2RF/LIPYihd6PKHHZ7FMEZM7yiuoYlJf?=
 =?us-ascii?Q?VhFNXKKbR2/Lw8AOVZYcIwAhBlVOhob19d857yOpZ7+8wdXrCX2qrAsxI46o?=
 =?us-ascii?Q?tM+WYpc/1QHQJzLhP68vqlzPDZtWozhw+G2eS1S8WAXlSH6uAAH9XTtZ+13h?=
 =?us-ascii?Q?C010pNa03KOXkfF0v4cKm28nTCvITz1vRbfTslp/ovfLeJee2KIH7S9noh+G?=
 =?us-ascii?Q?BcVVe6PZ70PdPVbneEg9HhvWMTfwv/tvoaQMa7zJojKjUV8lTEFC9ZrFzRAG?=
 =?us-ascii?Q?Zx9EUznzWVcXNdaTCdzhKJLRFJgJnPFmy5DXMOXF/JZmyabAZaTaSKlTr3W8?=
 =?us-ascii?Q?Skq9hWED0pRnlHc34PiyVgEifDWyZ4UBt4sC0UyyhV7GjVitO31kjbL+v8y1?=
 =?us-ascii?Q?pDlKZfCY8nAXWgOpcWYRDa1Y1nmc+O+VpuyCJRcYDocDQ1HJudIVagL75xbz?=
 =?us-ascii?Q?aqkym5hSRlnkmd9EVFa9WwXc8KCWFo4x88sikj23ZpWCURa3S4yzFfKRvLKy?=
 =?us-ascii?Q?tr5HqUJ99PQM2Kg47mB3Riz0+XHHRlripWVD4mmBgwvXOHhBUHSd01bMPVI1?=
 =?us-ascii?Q?scrdHju+W/bcvCI4/5BxYVunc7/m9h97H3TTfynAQxGdi8Suj6NvR0niNzAK?=
 =?us-ascii?Q?xEX1Uitd6/P10I7akBagDxJQG1vphl90RrwmURRSpLY0xz13?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c165a84-e127-4e52-ded0-08dee675e248
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 15:45:11.8615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ClYQmjZvvxvJ82NoGk0r51Ht/IHCepMLWJ8fn/IBYQ+OWQ9dz8iyAD1Z+urSI7Ru
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7091
X-Stat-Signature: 19nqg38kp7qcbfsuqpe1figd847kg8u5
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EDEB440013
X-Rspam-User: 
X-HE-Tag: 1784562320-403673
X-HE-Meta: U2FsdGVkX1/1feTOQBVZq37OY4R8wLwciXpc41YPdYBaYlo1xICEQTPyCn13J1I8T352DN97w87wEOGRd3L3Rh7pXwOQ8u8ixG4FcfZMfZcDsCdbhQGCqn+8Xh6kAGiaCrVQ20yRnNmtK4ENpt4Inu9S09k8tBhT/iuVW0xf47epEhQrNjutpcSpYn4kVjEmG0GpGOXMbZ9k3hE3ESeSSNUrEV3jAS1lca3Z4j3jW0DpbkiOacesJVVZnXqjeQDFa0ZFFg5s3MRf/sVGOp9sVYJiOcv5T+D4eKuSufoPfSUQxm2OwagVNmo/UyA5Dn1wRNWRoe3QQBzeyilF7dnBUz6om7HVaJEnJ0OsRO4M5DaxCExP4QcGa1ya8MXxq/SvincYh6MbD6t5Q2+L7vjuZ5LhluP+QP92xbIKLErc/5Q/KwcT+57XKKphHacs/srMiWBM8G1Ej5ixuPIPGbRW4xhmETL+gSV87jxIeSWEPW+2TixHlpvL3SPEJTdgYrOVlwFmAaEt5OWO0tLyZKdH0291F8c17Ck/iYmZ77sLOgiGT/YYFNogxULNEyh2v9Q0BGTCfoYKwu7+Bwx5FoR2I0nNAsR1cDxf4WGIkX6LicDAU2E5zGqQ6nkhtLwCU+NdPVolkcIXNJD2DvNdYiD+NH0MiMmoS6Dyyr/26T+wzZm9UMBJON87pqjsyvYgk2Vo9mA96Illj7Mv/VWGtNLWCb4KNmf9o1RW0qaudviNUQ197vY3fiMSbfvonvWwvw9o4w+28xPsgug8sidNtNMEtsnfGIIAmoQhsn52DfhcngDtQPl73NzRNTTz6dSlY4mMlyraxxX6kNxikr3N0HDt2mDvD3V3LI7jPZ2t0Z70SwkTQNRJ3HNr+e+vpYae5CptWqbDkGW7Z+Tf5iwxjV60uyrC5jdVcMEzvTESdHMMDX6d29YAx+rgUuYJHBFo3ODVdXm5lBUlnDgToHm+mPV
 2kmsF9xk
 CrPqrF6nkuqF0rFTiOhRQFjcGZbfRttLJqQFZqbEE8ktQswoE2/KCdSN1nZONuPqhZiBymIjURODOlEOhy/JwfWx+qJHeFCEoet70Qevk3Ps4BrKhLb32kO/WgaYS2i65GzFehINBOBXPsjComGa5HNeqlKTTvyYL1DeLZaenWLvAzgjKVS4fITi4SJ6S6K/fWhB7GJ3hJlBUUgeATbkzdbOdIwV8+FXDJU3WrC5E+lSKaPyd37PeaLDQgtkN5yfM9NCeHji4NspsM+DMWCuwEJ1RIb3erakD4CAPhXSeBWJa7RMzCk1qBR9vY9KE3yWFFSHE+BSJSnHPG+5e/5IzTsueTq6GkhOC2ECmxbwGHo12iqOqfryCG/T1ZcDcWrT0ZvYMCtGVaDaZRxL1WBb9mQTueahVE3EiDeZRQ7QphjtO0LsKrtQSIAeP87D9ZnQGm2BrBDxEWRx1nQrFre5mbe6dGFYezs2oYCX0sE5xg0Wpp1o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Jul 2026, at 11:32, Garg, Shivank wrote:

> On 7/20/2026 8:14 PM, Zi Yan wrote:
>> On 20 Jul 2026, at 7:19, Huang, Ying wrote:
>>
>>> Shivank Garg <shivankg@amd.com> writes:
>>>
>>> [snip]
>>>
>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>> index 41b732e78a67..4fed3110ca0a 100644
>>>> --- a/mm/migrate.c
>>>> +++ b/mm/migrate.c
>>>> @@ -43,6 +43,7 @@
>>>>  #include <linux/sched/sysctl.h>
>>>>  #include <linux/memory-tiers.h>
>>>>  #include <linux/pagewalk.h>
>>>> +#include <linux/migrate_copy_offload.h>
>>>>
>>>>  #include <asm/tlbflush.h>
>>>>
>>>> @@ -51,12 +52,6 @@
>>>>  #include "internal.h"
>>>>  #include "swap.h"
>>>>
>>>> -/* For now, never offload. Wired up in later patch. */
>>>> -static bool migrate_should_offload(int reason)
>>>> -{
>>>> -	return false;
>>>> -}
>>>> -
>>>>  static const struct movable_operations *offline_movable_ops;
>>>>  static const struct movable_operations *zsmalloc_movable_ops;
>>>>
>>>> @@ -2050,7 +2045,7 @@ static int migrate_pages_batch(struct list_head *from,
>>>>
>>>>  	/* Batch-copy eligible folios before the move phase */
>>>>  	if (!list_empty(&unmap_batch))
>>>> -		migrate_folios_mc_copy(&dst_batch, &unmap_batch, nr_batch);
>>>> +		migrate_offload_batch_copy(&dst_batch, &unmap_batch, nr_batch);
>>>>
>>>>  	retry = 1;
>>>>  	for (pass = 0; pass < nr_pass && retry; pass++) {
>>>
>>> Found a difference between v5 and v6 here.  In v5, migrate_pages_batch()
>>> checks the return value of migrate_offload_batch_copy() and acts
>>> accordingly. While in v6, it does not.  Why was this changed?
>>>
>>> IIUC, FOLIO_CONTENT_COPIED is now used to indicate a copy failure.  Is
>>> this necessary?  Is it possible that some (but not all) folios fail to
>>> be copied?
>>
>> Based on the discussion[1], FOLIO_CONTENT_COPIED is used to indicate both
>> 1. folio is copied via offloading, and 2. MC copy failure. So the code
>> no longer needs to store the return value of migrate_offload_batch_copy()
>> and can just check dst->migrate_info & FOLIO_CONTENT_COPIED.
>>
>> For 32bit, FOLIO_CONTENT_COPIED is always 0, so all folios are always
>> copied in the serialized path. Hmm, that might be causing double copying,
>> since migrate_folios_mc_copy() copies batched folios and later
>> migrate_folios_move() copies them again since
>> dst->migrate_info & FOLIO_CONTENT_COPIED is always false. Maybe we could
>> make migrate_folios_mc_copy() return immediately in 32bit, otherwise,
>> we will need to find somewhere else to store FOLIO_CONTENT_COPIED.
>>
>> [1] https://lore.kernel.org/all/c2bfdf39-8caa-43bd-b1ad-2285b4cc767a@amd.com/
>>
>>>
> It is not cause double copying.
> migrate_should_offload() /and migrate_offload_enabled
> gate if folio can be added to unmap_batch/dst_batch.

So migrate_should_offload() is actually migrate_should_offload_batched_copy().
32BIT does not get batched copy nor offloaded copy.

>
> migrate_offload_enabled branch is enabled from the offload driver like DCBM (which
> again depends on 64_BIT) will call migrate_offload_register().
>
> I think I can add a defensive 64_BIT check in migrate_should_offload() to prevent
> any potential bugs.

I think a better name would be helpful and sufficient.

BTW, ideally, batched copy and offloaded copy are two separate features
and could be enabled separately. But considering the hassle of finding a
place to store FOLIO_CONTENT_COPIED on 32BIT, it might be fine to
have a combined batched and offloaded copy.

Best Regards,
Yan, Zi

