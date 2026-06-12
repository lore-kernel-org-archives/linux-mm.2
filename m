Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F8B2CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A106B0088; Fri, 12 Jun 2026 11:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30C66B008C; Fri, 12 Jun 2026 11:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9203A6B0093; Fri, 12 Jun 2026 11:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81B806B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:17:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E585120188
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:17:38 +0000 (UTC)
X-FDA: 84871614996.20.B1A456D
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010037.outbound.protection.outlook.com [52.101.85.37])
	by imf09.hostedemail.com (Postfix) with ESMTP id 57EEB140006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:17:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="F+Vf/ixa";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781277455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zI/nQ2rhdc54XvQOypkF8m9l7btcCNM3h5uxMa9aPnk=;
	b=bJhP8S3AfExCW3OuFyKCwjzINfrl+hFbGUdKO1zooXzjDsrZOzdrtzCrKxCXF049ULv4Kd
	oqXBFsjWe81WCrlIB9pHeSVu4/7/Dx2NDvbg+9De3ESAKwKY6cdkpXd3WHTlFJrMPrB8cc
	Y9JIIVJi1k8c7Bw6/2htqX3hvdDWIy8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="F+Vf/ixa";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781277455;
	b=KniUcyTsyr4f9o03pvO8ZRe1rPQwTgwZHX2M633CgAt28S+b++oS7EJCvb4hgTTEq4YJ1h
	HLwnM6EIizIb97il1zQkNzJNUTN+OCxYlltaAPxSYLo7jfTnAIs9ZucelJ6k4lmAtZXvyd
	uFj9cUIdt8GzcCrlxFxNiE5rhueyAyY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hcm2uWPgkM2hELVLtL/uqZhdKCAfzbUGZs3uk2qMxykILajg36Jf0zJfhrFRT1KQ03ltl9Gbu/vDVaMcjXkhRgNAzRV9hZ0JRstCOUKJ2PqJx2wLDxDbJunMGKZdY8XjnEYTBevbsrp8m83oVh73IDcDPHjFjMBXyu1s2TI2tnfa751OHyWV+t4N14WZPqP1ffz/PFxUqhzBrJigQ2zslBFp0QDkngXBXn41Ep1GeR5OkbpPZmZiTXFQ4WKH0HkKfNEDFHRvQmNRvvvxLBmJtwmGiXb17vfElITQ/ra//l5qX1JVUlFjGetC30VaY2kiUxN1+KyFKIfeY5YNrjblNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zI/nQ2rhdc54XvQOypkF8m9l7btcCNM3h5uxMa9aPnk=;
 b=deItK/WoaymgEcDSOKrAl+cAKH4qiywYw3cbUrvhHwYuhawnhMwPUXrcX6x+xP8D0YVqoZJxm9Y68R62NSSaD+ybKi/Ft6T5YD/LVCJjBJPHvH9/CYeeKAfIOSrN+dysIw+vVr3u4lb5ecig/KyoCyfEjLnIkdG1IRk9Mvh1Y0XKw+B0/yhc5w5aAimkya+fXmcaT22X6GBsTCrrSFFvN/aIVZmO8SPcBj1km0yfLZhL6gyJo82dWpeOVr0CAsTzpCNfPR9/b2xp9GAZQdr5USyV9cIQVs7yvgl7fyYJLe0y2lzsnDAIqGkWpdhkArn01Fzmb4ddYbOYS18k9DX4QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zI/nQ2rhdc54XvQOypkF8m9l7btcCNM3h5uxMa9aPnk=;
 b=F+Vf/ixaZMqBJtsQaJXIy2qxxTlVMef1t7HCaTfEU4TviAZSHp81bSmYAZlNo4fv+l3YjIAupNfsuCUIqgZSQRS7dTkERfVAU/T/61Yl8HTwJCbTeX2ki9mBDa4KhXUTbwajLZ5P0SZQgilaZCA+awRyv82wRektsgNvFQt1Ytn+Jk8LpSfSwFkvSE4n41RA/LKnawtABLVYfto9yN0fqUywAyX+TZUm0cARTJHVMjfVEsjMlsyMc1oVHgxwzcaVyZnuxJoKm0pmnAoerJGhkZAQxIhudfz5yCpnXuT/QnJxRJC0g53hCpxwSDI37De3qQXyEbY4/3BQ8Jz/I2deRA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA5PPFD911547FB.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Fri, 12 Jun
 2026 15:17:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 15:17:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Petr Tesarik <ptesarik@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: reduce NODE_RECLAIM_xxx and change to enum
Date: Fri, 12 Jun 2026 11:17:27 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <CC333D7A-02FE-4001-B57E-DD75FF6528CE@nvidia.com>
In-Reply-To: <DJ7605JADQD4.26TWN86L7IJJD@linux.dev>
References: <20260612085052.59291-1-ptesarik@suse.com>
 <DJ6ZMH9VU0BE.6Q8EHJIL65DW@linux.dev> <20260612133155.71958e80@mordecai>
 <DJ7549TJF9I5.O3K9X2TP8VE1@linux.dev>
 <34223C0D-B52D-41D4-AACC-943A4BEB3472@nvidia.com>
 <DJ7605JADQD4.26TWN86L7IJJD@linux.dev>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:208:32b::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA5PPFD911547FB:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d58c1a2-46ae-48f1-30d1-08dec895b85d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|23010399003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gIoSYA+zGisHY1xa3M3tepC6bKenV5ugp+E3+hiuHE2jJqXT0tXXn55FBbIwEfSDcxiXRBLaqkl/TUPEgBZwVgeDCifW+QCRI/Qrihl+mDpok35EsJYQk433ABsTsaUvAza3/9o+VM8U7pz6Xbi02IDqBoLam4cxAxv1vi/+dQz+cHKgh0RJ25HH3haWPyMGvGFgGk+u50IJCbEsegceCltJdLUmjLXHXbXWfRyoDG17w09ZacuUSk3kXYtUwWTFt2bB3yeXoF4DLhhzOGml1CKODvGSHj4T2V37L9Uf02oI1d5miHsIEPMLiEGLZwOPR2/AcCcY0TmTztLDMv3vsJMbpll3Viu4RXbB7InW9Yi7m6JIfdoEpxB8TTXB4uIEWUCEX3QX5vJSaWdTxPjPobaOdYYj2D5/YgcVx/HlGyiYq2snrV2K9GszqOI5k/CL84PbcAoHRuGIJmJwqqY4vIuKB04Eg5KWlSOw5YfGjjLtrMYzYNhTPeNUgveorZTg3kiQQ3RuWpkPNmybF1mkbtWsvNLqVyxf3SpDQE32Z5m8kC/POoPSFNrh/Z0a4lvATCzToDHh07GoxFBq97W9HgFBEw9NBEe2aCM7njAQsowmptZFsMCwvEydNKqFVWEuaVCyaWnpKffVa98gjfLnOSqHpX/TBjRaXA4lWkCYnREIWG/Es2AshPlrVwEQEXaY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N+VNHVI8sQz1yCww81fpPEYKthodqDrviOHK4qASneaO1DqZKWUfG4kq7pLz?=
 =?us-ascii?Q?Zv9ZfBK244q7QoKj0z8DIK3lr4B7yoVaWvFCDNc6e/TTvZXdRqyByj124knR?=
 =?us-ascii?Q?uSJz+ZIXP+0cqFwTUuukDut61yCTzNV/3F4XPLc1JwMH4/YxSiUK3Yz8YIwy?=
 =?us-ascii?Q?9rW4iXJxAchDTv7aQI78MZUjJNlb+CVH5MO42kH6l3UaH/D417NwmzNETjXI?=
 =?us-ascii?Q?Ez6qLRxYCwShfMzI1ZO6B/NYtsWoLsZfxYMatK31pKoHNBZ4vXm+39RMDjXH?=
 =?us-ascii?Q?EPuyufWfIb3W0pD/9MkeT82HJAS6dJMtJREpnvXh8apOfnlEfjM8AgMLEQo/?=
 =?us-ascii?Q?GOWfTxTRMXWhnFEyGBfK/yRGIHDy1QTXIO8EliDXSOQ/ZbmFgRHc0neJSopw?=
 =?us-ascii?Q?oxEQgSxeF3UuYGDipmoQfXE3poEiHCHp5MsJEZCEDWnO10K4PY3PxXmtki+w?=
 =?us-ascii?Q?CYL5lck1zctGEJNgs/8rbqqIcFO+lyAUV8jXXXfQyWzXdOlmh8MyssHbaKuj?=
 =?us-ascii?Q?36yP6ULwhCmCqHISI4C1wqKi7WB0hOY88K2tO+GUu7+OnErdtGtDrSn3j9j5?=
 =?us-ascii?Q?MaN3E6fbGFxZ+gvrd7q0Yn3kGWuOS+5LVGwOJSLhiQ9fCF+BsWvoPV7nQNIK?=
 =?us-ascii?Q?o+Ib68khsrT56yQK6kJKcgi1m49r4M+lAi3p/HL0Jn8QsS3E6KNynV874vz7?=
 =?us-ascii?Q?RQytYfvT4aoDX8Bl3pGs6tCNUW8U3U27ewUePXBLBUby1/WqdCUFA05QBO//?=
 =?us-ascii?Q?F8RnV9qF2sqWNmc7RBq/S4HXKt/tm1rNK6UczkHOhV1ikSJ33vjRIt8+Gcqp?=
 =?us-ascii?Q?xZTdtApdww+lR1YfCDaNDr/soI70SARpxREhV4vltu8+AS1cqDZWq7aSJLgs?=
 =?us-ascii?Q?NwUPLDQ7h85Np6lae96gJ2gXmmmaEXHu3L/OXH51PFnN36Z3D4PKrfarfX6h?=
 =?us-ascii?Q?sDhVyAhwmT4K9SrPzldo+00W4vz9KMwJsgO28K6tW8ZaYY/UnrOovY9Yv/Wa?=
 =?us-ascii?Q?L5Rb/3PougM3Io/cuAzaUYnd4sNILYEO6Dmd2xTLItxjMSs7UVd92zn0EFD4?=
 =?us-ascii?Q?tF1aoQ2VB2gYgnjgX3JqOd16ybsBuQYcQBGC4+R8wzpl6U0aFak3xWhmTqHR?=
 =?us-ascii?Q?nmtAdULwp3nA99DCpoyHZS/cxqB9xNR9XnC+IsPjb6ihAJKoCKwlgPNl671I?=
 =?us-ascii?Q?7mQFSWkIaAz3FHPoMJ1jufIGO5MweCl3UElovH7ddlq1KU6q+yAIkUw4SgZD?=
 =?us-ascii?Q?kq+cAjYbZI0j4iuIxLbhqiLyLMWQA/kM44ivk5fOrqPmq4NVg3odFllk/M/A?=
 =?us-ascii?Q?cA845MdmAMMcQ01mPdfRKTiSsFPlXgh0IWV7sPtBMWcbGdVdun5cdy4/Mqxc?=
 =?us-ascii?Q?2a3zwxbeNWbg4r0/2VIjXeFd+ixH9X9EK0qGc2HdWXbuZE0Wdjbw1+u1XQAW?=
 =?us-ascii?Q?F1B6QWTqwu4MkoW/ybZTDYrMMa68usZUycmiRqVY/SBtsRSKAUuhhnyOFBZt?=
 =?us-ascii?Q?/EpFf0BA0WGmOwyxsBw0qrj/GcKM5pNG0wXsWIKx/JDaidvRv2DPA4lQM/tA?=
 =?us-ascii?Q?MkD8y8pEmweKUEi3IcVfWmVCE8OmZ7OJUFmmUVwZP5qGBtGo2VVPuwyr3wjB?=
 =?us-ascii?Q?a//OH0DXSakldeS0Pka+dabObERRh4mVU8g907C/pjLg1zYP7nsgQ0ySHlBc?=
 =?us-ascii?Q?fCADfXE0/SbpZMIWJCVp8xynb8c+FjKeRsVd29qFBGqcz2E1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d58c1a2-46ae-48f1-30d1-08dec895b85d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 15:17:30.3059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0picBKvDsZfd1cNSD5MODJHikAKjGGbIVHghMP1kzai7A5ADTgBCQ+n3mwPnxTJH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFD911547FB
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 1e69oan83iz7xkwcu47jb36i8c1chduc
X-Rspamd-Queue-Id: 57EEB140006
X-HE-Tag: 1781277455-921849
X-HE-Meta: U2FsdGVkX1/jsxlSb26ToZ7rxeJ2Y/s9wtvURSuOORSfZNE3duUaekByfi3ip+wEYXa9Kp6SQImfiTnfUZztARuxFZ3ezpalmfqIfPMsqCG2EPkpmgEtEevQKLIt8LAf/2A03o/E54YS/BjM9bfRFbHYh7tSaRVZAqy6Vg1IZdA/Vrsu439mr5wRRNtdJJifuW4W03myZ29ZaqKIZGVADJWH8HFQytSWP3kZPPKeurZzGF3wkn6XTf1N0q58Pbd3XFoXsxIxdWem1zioqNVZarVBpJlNwR1P5RzNJMt0L4YqmyYxd/lVHhoo2/60RFp+YJAto1KqJmdsb2ynvy/qQveb8d2YWWhy4hLwoc1RU70a2u1svAUhjWQba5NOz8BttyMxbdVkSERU5E6Iln+GtQfOdeguFwLvN8zErUPmDRf7YNusC9YQ1kCllIiGebsedPVV7muPG5Ro1Nhs1sKUsL/vjB0xE+20E9/ZG5hvikfvk8mkeUVOApqVpufvE7FNf1lbco22ORJK887bHtxxWSztoQQITjpHwpCTWnlhKBHMVcktXW3QiHkJDe38pvirSn7OkTdrrb6KGUTx8XstgX1rjhYnImCZfTzry5XBHNHAxrQhAXPAdZPtz9QW9vJF8MXNLzolmdvY5Ji2Xbg4V1KOlByE+UDCnEsZO0filEuqSSQkBaAA9v0yhWlWMH5eZAylR4me1rZOSFluB6zDghV1iroqBwhx1QsavgngJXbnXqYpctEQC4X901R92afUWPtsUOzvDcNp4wjATeZMk/jXXLzo2ossRIFq+4Dp1zVgmvVHokPCc7ep1XtDdMYE8vGSXBF5lns026iqXECu/f/lape0SWHP5oFmmkigql/e76WhdIpQPp+u8oRa0HbIQBt9tYBRcYLtPu1rUxQcM79722ZZ7hdd6b1b+3nOx6zVzK5sWMwCOtASqzjx729SGot5JXLStyf6q9usA1c
 zA8wtARN
 ZSyN1+nfAJCK7iqWKrUuRcAgMPJWPUFZH1rXs5+EFes9Z9IVVN4fEj7d9XWDXpv33DJKEfqaItLn/84O49YiHldckYH4BiqBb3R9D0DtUQGkrw9FXzKQzkTGLSwIugsBObhtxzdh/uInbLmc6uurrRcv0z67UwK7KcEmeIaa+SA0cD8I7/37bHoebRYc0S135kJeNEasA1fcLUh09ghjlmFSj8tBydyCiUQM30sFGVUtSclD7kzhWaOBzuy/Od1lv4KY5T5cGwj07LyPyFZNDMGi+iLswIF1N5R9BZ6yBxwdvlrVEZfLy5Q/cIhJLwH7tRHuQFnJ6aTZDUcAn5Zpt129NYbtQGc/Rb468Hi+rZZNLvbJZf/q/c6L8FKFoH2AtuVWa5q0kAAbP5xnGdkM1BguozxA7CotjQdP1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Jun 2026, at 11:10, Brendan Jackman wrote:

> On Fri Jun 12, 2026 at 3:01 PM UTC, Zi Yan wrote:
>> On 12 Jun 2026, at 10:28, Brendan Jackman wrote:
>>
>>> On Fri Jun 12, 2026 at 11:31 AM UTC, Petr Tesarik wrote:
>>>>>>
>>>>>> - NODE_RECLAIM_NOSCAN  -> NODE_RECLAIM_NONE
>>>>>> - NODE_RECLAIM_FULL    -> NODE_RECLAIM_NONE
>>>>>> - NODE_RECLAIM_SOME    -> NODE_RECLAIM_SUCCESS
>>>>>> - NODE_RECLAIM_SUCCESS -> NODE_RECLAIM_SUCCESS
>>>
>>>>>> --- a/mm/internal.h
>>>>>> +++ b/mm/internal.h
>>>>>> @@ -1373,23 +1373,24 @@ static inline void mminit_verify_zonelist(void)
>>>>>>  }
>>>>>>  #endif /* CONFIG_DEBUG_MEMORY_INIT */
>>>>>>
>>>>>> -#define NODE_RECLAIM_NOSCAN	-2
>>>>>> -#define NODE_RECLAIM_FULL	-1
>>>>>> -#define NODE_RECLAIM_SOME	0
>>>>>> -#define NODE_RECLAIM_SUCCESS	1
>>>>>> +enum node_reclaim {
>>>>>> +	NODE_RECLAIM_NONE,
>>>>>> +	NODE_RECLAIM_SUCCESS,
>>>>>> +};
>>>
>>>>>> -	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
>>>>>> +	nr_reclaimed = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
>>>>>>  	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
>>>>>>
>>>>>> -	if (ret)
>>>>>> +	if (nr_reclaimed >= nr_pages)
>>>>>>  		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
>>>>>>  	else
>>>>>>  		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
>>>>>>
>>>>>> -	return ret;
>>>>>> +	return NODE_RECLAIM_SUCCESS;
>>>>>
>>>>> Should that be returning NODE_RECLAIM_NONE when !ret?
>>>>
>>>> No. That's the thing. Before my patch, the return value here was either
>>>> NODE_RECLAIM_SUCCESS (when at least nr_pages were reclaimed), or
>>>> NODE_RECLAIM_SOME (if less than nr_pages were reclaimed), but the caller
>>>> makes no distinction, handling both cases in the default label of a
>>>> switch statement.
>>>
>>> Agh! Sorry. It's good that you are cleaning this up :D
>>>
>>> So in that case my question is: is it intended that we call
>>> zone_watermark_ok() in the case that we reclaimed 0 pages?
>>
>> It seems to me that zone_watermark_ok() here is trying to
>> confirm the number of reclaimed pages is enough for the
>> allocation, although the return value of __node_reclaim()
>> might be able to tell the same thing like you suggested.
>> But nr_reclaimed >= nr_pages might not be equivalent
>> to zone_watermark_ok().
>
> Yeah but in the more specific case of nr_reclaimed == 0, would it make
> sense to assume !zone_watermark_ok()? It doesn't seem that important in
> terms of behaviour but I think it would be a clarity win.

I agree. If nr_reclaimed == 0, unless some magic happens in parallel,
it is a waste to call zone_watermark_ok(). Now what you said
is clear and makes sense to me.

Best Regards,
Yan, Zi

