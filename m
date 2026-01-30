Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B4C7D73EB8
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 03:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84ABB6B0093; Thu, 29 Jan 2026 22:55:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829326B0095; Thu, 29 Jan 2026 22:55:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7A66B0096; Thu, 29 Jan 2026 22:55:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA326B0093
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:55:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC7618BD7A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:55:19 +0000 (UTC)
X-FDA: 84387265158.09.9DD24DA
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011044.outbound.protection.outlook.com [52.101.62.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 21DF140005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:55:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qekvfskU;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769745317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByddRn+hZTXIUhIdIcU4QiWLDoE1Q3I3QIy7y1cPKTY=;
	b=erU1qEuzJeMI8YL48Chyru3aS0tNS3LbCAqcvXJnAsmxA6KykwsjIYx2vB+PX065e9OluI
	2+PJGYe1zaALANEqvt7fRBysgy7y615yf34h6bJGDsrRAUe45F5wqhJGD1pv1EHwUw32wU
	szohleBGANGHisBFWUquu5Y9sAEhI8w=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qekvfskU;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769745317; a=rsa-sha256;
	cv=pass;
	b=bl4ueo52bU16aBIZAt7783f1IdGlPDSjk1Ze5/6RjGEEb3UviGiGdsXTJ4wMgT0WhuKYRm
	ptNpZAvF0m8RAb77omKQMcbO/Oh4oDi+Of+UTV5BLvZhfCNIgardXnwbsnj4JqBE7nC3Pp
	WNas9Yz2IVE97QCV7XfV3P7OKF9WAVM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TEru4vIlnwdOz3JjNxXz4sVIq2b0D+WeoR7gVBhQ0Se8UZfjyW8iHNgz6RVn9xI24Z5GcVdS/loBFdkLaE9Fn/qyvrIpHBZwMlvrh7JVERvY/wmZqsuFFarB5GE+JAom7ZM6EOKlqQDIvY+riUWtNvCbHjNvLM5EciVnznRZSU1tud8YOR7VCNlYuXtAobDPfjgORGkWFUKCsDucJVJbC8yVDNJpfAMX+gDcDn4flq0SBKqjMTtT9SAAdqk59Rh8LkGD1JS/rQaPyE8zpyN7nHxQfBjv+ewS78+yIydnx3TuzssqexdWzbHgLmn9b2SPEDQQ3Uc4D3/63YXgF5JFfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByddRn+hZTXIUhIdIcU4QiWLDoE1Q3I3QIy7y1cPKTY=;
 b=htf3lWXU/XK6+UnfjJjc6u/uvebpWCx/onLtbJOH6sqCsvMbn7jMgxMjxgnp4jnHkegg5zukjXZEkXSdwN4jgzxwdYJCxPe7TPzocTj/AfemjWLty2W0D4AGrkw3a0+kyVa0qDPCS4TIsBAN3H0nLhkSRkZVGhHnsvcXYEsEG0caYtLHIi66VJFGlYrzrttlIE3llPpla3ug1t0agl3wnD/oRtTyxPy41vsgN8jlJqTOZG7wSf05hZWSCN42kjJBnSVhLY9p3RFca0wXl7vP6ZWNtjdofNQCNnJSA9WHlfqZfmPrN3aDOjzu5tl7oRHkZXMUydwYoF6unzTt+aoOJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByddRn+hZTXIUhIdIcU4QiWLDoE1Q3I3QIy7y1cPKTY=;
 b=qekvfskUE4uKEW0e1x6rYbtzhQjF81hif8k8wVRuriu7s123MKEmsbZg9E3FtCIeSVSxBLD+T69fInEf6ghGQN5pKh/u9YbWFprzOqDqhpNKG7DI2HO62MDDO+C9D23ITjrv17BL38H7Nb6GPRww2W+HeFJcQIeMsxIzBmzxZKX0ZmNvYXWFEIAqFY9mCwEIZBTV1/u44xtEJoTxPHsYDgCeS3w7OA+HY7OcrDkIDbM9kVaI8v5kTeScvlDVjKfEGb+pPr2utTpkfmJUu16uME9hndaJYT7rY/MDeVPLx1F/VrICuS2EB6HkoXKDYj3xqwtQRNx8kXnBflGyWJaezA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 03:52:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 03:52:05 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC PATCH 1/5] io_uring: allocate folio in io_mem_alloc_compound() and function rename
Date: Thu, 29 Jan 2026 22:48:14 -0500
Message-ID: <20260130034818.472804-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260130034818.472804-1-ziy@nvidia.com>
References: <20260130034818.472804-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0047.namprd15.prod.outlook.com
 (2603:10b6:208:237::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: af312b66-1add-4f82-0b59-08de5fb2ef56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?khti+3crQVF1O/I+3an1z5eLuOCgk9qwg4eqeA9YmWUUVRSDXhcNwCn9Sc3u?=
 =?us-ascii?Q?hpfB7s2GR9VYuL+bAzMt+1UsmP4tPRTyqj7db8oiQRhL6iZYqC8p822oCrIA?=
 =?us-ascii?Q?zARd75kDt00fAb941duBaiuBo4+mtcSAH1hywW8a8eA4z9cv4/rfFJZjuxA7?=
 =?us-ascii?Q?cF0TUEGn9kg68QZosC8R85X/HyxU1Ie9GoCboqKiP03+V3+JMsOZKyPlj81G?=
 =?us-ascii?Q?MWTOlKKSGA6JDBVPOwwi7I0fkKuOMb+fvxjiPljrgjVXNlxwK034A/6rxTVj?=
 =?us-ascii?Q?ISE26I76PYn1Z3BBgVbOuxbgbd2GGEMhkVx+RilbUzB1veLAyLUI6YPHPXB2?=
 =?us-ascii?Q?42Y+FS8XPLRvrNIlnk8OL8VVoJWnimWtVqp8kTGdffe/HnY/Urda1Ij0VOuB?=
 =?us-ascii?Q?+SryxkfznF7PbK64dc4VW49LyKy+nh660V5lDw4aSOhXH8hdVJSz+wDWM6Vs?=
 =?us-ascii?Q?cRpMxn2nwtgi4ua4y0JlUOJJvjVYzqAO0grolnYbDSIQdCdJzlBldwNykVpf?=
 =?us-ascii?Q?mVxTfi1imgIU4nWOJHcWqlYxiUMtGo/KAR3Pd5aXtLCFPJMOeH5cg0z/rWju?=
 =?us-ascii?Q?cgjk0XeMBdB81S0R87FqwMmp14pcqUyvrViFWZUqk3x8pg4wlC4DS1yx3ej1?=
 =?us-ascii?Q?Nba6pyKCx62O7c1/3iYQgOVajBQDuthcACU1H3FdXcWx/7bA1E77ItWqpJnS?=
 =?us-ascii?Q?txZxoUbRuiXOTDOi5G/FMAMXQzsUTuR4EMx5/XfeDgIP/cacv6Y195SVJS/+?=
 =?us-ascii?Q?dKQBpwftJYOY7FQxoxt+4t1nMxhR79ggn/CzGkMZgrf6SbwKlGVvPJ/tFGvn?=
 =?us-ascii?Q?ZSnFuWxfdVRXgZGKgnYR5z9mqrPkLWvdCNMNiFpyxJ1nJa3a1qIJnxlGqCC4?=
 =?us-ascii?Q?YtKCNxaIKIl92rLhDN1IDBubEy1Njykb/iL9fmonMu62HWvAdaGCkhzSwpqW?=
 =?us-ascii?Q?hhry+rNbPm0F+uPnqbwF/XlI3U/iNnQRp11xifokZvMMD/jvtLiOZqx23M5L?=
 =?us-ascii?Q?g5FYDxSRRGPYVSdI5EG8Yl2zdKv/o7aa8pwvR6pntENLiZg7mtzVsNDWU6eg?=
 =?us-ascii?Q?Hp7WV2qHAeuOlNpwUZM3NoOd8ABIi06kWdhtFhcmKU6K8OGY6kL9EDH2Jty+?=
 =?us-ascii?Q?SvvwhhZtfIwN+zKA4JYSLmvPPjHl+1Mnceq+LdEsgrAw2B5zM1ZtnAVtV9rB?=
 =?us-ascii?Q?5jDGdUfaBC0LzUm/aZjYT3lM3m+tE2fIBvu2AW0CURLRcOuYAylZk1SlF3PQ?=
 =?us-ascii?Q?c/+jqzhIkZzZfKJ7SbZYofguKg8SJx1xbb+cwVNHNGCzbkAOQdCx7lwY5L2P?=
 =?us-ascii?Q?ccQbfINWHXBOP2iBX0g86b/W5x2aeyNZteoZ33z7KizQCMmX24B7US0MSJ/H?=
 =?us-ascii?Q?M9A/jWR6/aNW9p/FplZpIRw3S6qzIrJldWcKXExb3o46G/c3iDnauhgL0fSg?=
 =?us-ascii?Q?6yY7TkK/OJbxWmmwG+3rZmc75VWEgrG6rXq7zFRgnCaW31nLsv13EyGhzGbF?=
 =?us-ascii?Q?NLwfnnpQliTsGFguXCzTGJ/Z1Lzqbz/ZMNOPQABPbiTjEIOn5UocQHVp3Zrw?=
 =?us-ascii?Q?TaYqTPsadr01CDZh9AE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VX4BSDT6tKDn4oKPkC9vH5WgB8oUGHTx0NTTarWYkM2XfdtL7hzvJ+/tiVlk?=
 =?us-ascii?Q?LyDHuN0sqezgKf6mo9PcJNJUf7r8OWFPeXdnd0MfZ57D1kwSJp0YGXwNwQMB?=
 =?us-ascii?Q?CD51n4qC1tOo+780aAVToejle55FaD90qyLzx+zROnajvlmoIKLQNjBzXfYO?=
 =?us-ascii?Q?T0h1EuA8IYho9RjhzafrhL43Bqze5B1TCB0XeAEyiN8PiGQLX7VfcgmZTSVt?=
 =?us-ascii?Q?kKPQDtfR34DOnLPtilfAT/uFB6tvCJOXfrqDbzD6QIuhilZV4VABLWR8DR9Y?=
 =?us-ascii?Q?oGLf1ui/b/c/mhOXBaqO58Z0geWe+a6YZKGod9yye7qhgc5G1XCn9mSljjoT?=
 =?us-ascii?Q?pNdSvWsKif9IodOJFFLPiqK3L+y52/LBilQ1DJnFZ3eRPgDCbgKQVGhD0+Kh?=
 =?us-ascii?Q?wsI1nmel9NX5aLQBFGJQiytIb9LmMRdmAXGFB2S8CBvj4S4sLoJsvmT6IRft?=
 =?us-ascii?Q?PCVewX0ynYnicK+bRfXBf8DpyXacooWJTMWNB3n3Gpa07REyi0f5GjfD3QIo?=
 =?us-ascii?Q?cyE+1L08gHn6ejEVk1I7Fs2ue6YFvjyagfaAiPD/yXoFD/WDtoItGL0ZakYD?=
 =?us-ascii?Q?gJtVTga7QDo5pWita+n+8y7F/8XP5EVmKZIAscF915Qx+mSHv3sfDKKX6jj1?=
 =?us-ascii?Q?oNnjF7o/r8gr7fBupNg7yFNY36QaPIAQaQCrfNUdeU56PklDOrn88Rf0/oaV?=
 =?us-ascii?Q?l8+CB0tYMywlHnwmevz83nvdkiMo1P5DsyzmvYN+gWvKrJ1DTZK677lVESnj?=
 =?us-ascii?Q?czQbyNdX7RgYxIoYAMSWUdAZjMGvLiXJcWE2KuXHK5UI6cm3noBsSHVDe2FB?=
 =?us-ascii?Q?CveDiIjjlTcWUMrRPU8A4wMjuKGShwZPidRMxj+LdbL3YvHOKlMG5GgBhkJc?=
 =?us-ascii?Q?9kh0/MpSFWi0xuxboZoeC7RdyhXoJzKKuoDaqVwaO8Gu1D6lhhOt9ZdJJP66?=
 =?us-ascii?Q?dyL9DiYVCpDNUprDyWjLcLpa20U4wFnuUmueYfeCTnaUkI2dprSgZHULwA5N?=
 =?us-ascii?Q?yYIL4ZdhoSd1T3tQcKeZntaeSJEaCa+TtNu/uVDH31RxwpZfRY/S56dYFfSM?=
 =?us-ascii?Q?LtEwMHKLnccITiV5T1ytbRp3YaB4NUEr/ljQ8uStKQYUA6RBh1BSTR2WFDR5?=
 =?us-ascii?Q?uukL82CetcJ+QYQvLnOkRs1iwInhfNKZg1855cC8MwFem2eISNOLnBaXPqSI?=
 =?us-ascii?Q?amRqgw+BIIUK/hpARf+QVii1auQSi0QGWtEUwlDG0bSoqjsdHg5R7qpiy/Bc?=
 =?us-ascii?Q?QHOcmfrOy20DDw7kRjoH/zGGxYuKKxuQllyT++N/Tzl339UIk0toUIBEj2zD?=
 =?us-ascii?Q?P8HDhWckOT8gXf9feLB6+9lZTLW5xsr9Pso+PtEu02dc1ceDJ+eUsZ4e2UDr?=
 =?us-ascii?Q?BYE7ev1iXZZgB5poRbvnFLLWp6GbRzWe9iQnJDD/snwRB6XjQDA+H8r0LgXq?=
 =?us-ascii?Q?lJWgYPDBUV6Ie9eeVNXant84xzjYWYOnnDGugmMF51pymU2thRZ5UYz3bHBw?=
 =?us-ascii?Q?EzjOM2D44G4Gj06KbBlUGjiFB3kOgfYO22CqY3YwvweAMb7UMu0Lf0AX27qI?=
 =?us-ascii?Q?fUuX2KupL7IzxA0HVRIkz0wZ0mLiYBoHpC6+Hpf6lg0H3V8bu940IUl9vlwa?=
 =?us-ascii?Q?f/5WDP81YPpMuJETqIKOBBQkeuwecFaNSLh5CZfgM9ZTRBpvVgNusZA4KeST?=
 =?us-ascii?Q?SyXKo9WVArJaJdAqaIHyRMPs9sBeP1aHg442DO23YBsmQClR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af312b66-1add-4f82-0b59-08de5fb2ef56
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 03:52:05.8551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q9uqps7Z2zHCOisK7OkVhsV0uooiEaqWDgGzkTDY3I8Jwn742VcQVAQJbOOEfxaA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 21DF140005
X-Stat-Signature: uqxg8otmsz1bwyyii79et3wq4zpoi5ap
X-Rspam-User: 
X-HE-Tag: 1769745316-1
X-HE-Meta: U2FsdGVkX18cfCYAaU84x6xm/IJ6sgL8Du6A8P/pSvcM51gQvJe1n/Lmhg+wkotC3CfCr2UEqhVhfS99Mv7orbxuGqqww2TToY8d8di06R0fME8fMQpcvl06QyeSLukkm55rtqX7iXD4L/ackZbnG2+bTH69p6POmdcE0eTxqyE7dnpijis/wzD6g3BwgForSdWqbUpopn2QFY4xHoYPOk75qILyf5o4qRWjtD5BULv6K+VN64DgoR7X0wLcxpIHGNbOf50kckW+Sn9BbVT6ym/6GHvwydks8MfzVTMq3Fo9CbBYvM+veEUi9kEpLwcCVul76icJDA/lmFMpZ6B9vlvvIWxw3xtvI6N8ZsBaSZDg2JL9eevKzrsmT39SnZzwPuVyI1EGMIMbR/KbeLxsmdrxILVanuXnZRJ0VQ1JpSxiOj/3ecOklx3/ilQllJZlwg2AKtomrobdyH41jpBN2aIAHb6c+GEse6fKwhWVD1XCBmwOOEA7WOAk4yA5X6ATFPF0IWuZzleu8TLxxOo3/6AdS1+YeP7EE22cnV9S+ycE5fsLJvDMaLEteOcEO+bJP9/xD8EvndXY2NhgAInJaZNRnsvTFmib/tj0RsuPx+XkYjVIBeBa39GE9oqytalj7m6UaYpzj49MqWEfLNxKgp2BaTu/xQLXSc8BaZ51byujoMHO9QXJIWpCCBBTgD7rbYL160CXSXdiBKAZqMlxCS+Y6WV1oqe4xhm4TVncskUk+915rTha0bbhZ5AGz8S8AMVWK2sbrwNEd+/+Jp1X1YhNtiroxJVMOtwTiPYhXsRj4yK747ORlsTCgCJERLDkiWYziwyToKrBsov0XPSrw7Wu6TO8o2ICcAn/pLU4A98dgMEQlwGD8MUWkfIFwGbOBECmFqYyc8mVOks5X4wgdGszJg9wpkDcAM0cNcSexjqPP9HeQACIgqBXFNKfWPPm7dOqzDo3aZaq40IY6Vp
 GyTBEBcK
 FsN5sMEfgm//z3QFzYcAlVZHwFjN8XNLL80BiwKKIV04e7o7C4tB1b0xIUzAvjJvE7/lgHSvUOsk5zEx/x8R13vZLPbmOMaVBch5b8RWgsT58T9n0vNugCz+L+Er/9ESP73im8lQwAxe9GJA1XFC82EMTRvcYcinOGjFkR0BboNLcIUbo9e1R6mSX+WxHQorEaLZnwiT1aKpPaNOTw0Tq0YRpqYV+ifmJVc+syaVL8ncBd2awPPL+XGYD62VBSr+mqbvZBhr2YbaH3BN2/9MViGcy/rVz0C76NKyhybUV/XhwsHYWSY8JOhACA0qi6G8BKQKI5VCIVDpn+c7nNlF1/YSLtZfQo775OWD55TNHriBPRTuWewem9TIeOdNNl8dvS2lMKxzQTwvVU3nzi5UptVAUyK0sPUANa/ziIr8HJ2hWAmMg3uD2mybTpGwjZeYObMCqVzmm9gBPIh0F9vUlNfJ0Qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page allocated in io_mem_alloc_compound() is actually used as a folio
later in io_region_mmap(). So allocate a folio instead of a compound page
and rename io_mem_alloc_compound() to io_mem_alloc_folio().

This prepares for code separation of compound page and folio in a follow-up
commit.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 io_uring/memmap.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 7d3c5eb58480..8ed8a78d71cc 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -15,10 +15,10 @@
 #include "rsrc.h"
 #include "zcrx.h"
 
-static bool io_mem_alloc_compound(struct page **pages, int nr_pages,
+static bool io_mem_alloc_folio(struct page **pages, int nr_pages,
 				  size_t size, gfp_t gfp)
 {
-	struct page *page;
+	struct folio *folio;
 	int i, order;
 
 	order = get_order(size);
@@ -27,12 +27,12 @@ static bool io_mem_alloc_compound(struct page **pages, int nr_pages,
 	else if (order)
 		gfp |= __GFP_COMP;
 
-	page = alloc_pages(gfp, order);
-	if (!page)
+	folio = folio_alloc(gfp, order);
+	if (!folio)
 		return false;
 
 	for (i = 0; i < nr_pages; i++)
-		pages[i] = page + i;
+		pages[i] = folio_page(folio, i);
 
 	return true;
 }
@@ -162,7 +162,7 @@ static int io_region_allocate_pages(struct io_mapped_region *mr,
 	if (!pages)
 		return -ENOMEM;
 
-	if (io_mem_alloc_compound(pages, mr->nr_pages, size, gfp)) {
+	if (io_mem_alloc_folio(pages, mr->nr_pages, size, gfp)) {
 		mr->flags |= IO_REGION_F_SINGLE_REF;
 		goto done;
 	}
-- 
2.51.0


