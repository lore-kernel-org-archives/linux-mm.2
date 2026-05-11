Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71ECECD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 10:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9D06B008C; Mon, 11 May 2026 06:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D4E6B0093; Mon, 11 May 2026 06:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B256B0095; Mon, 11 May 2026 06:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 448206B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:37:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78F381206BC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:37:34 +0000 (UTC)
X-FDA: 84754787628.15.F3EDE7D
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013071.outbound.protection.outlook.com [40.93.201.71])
	by imf21.hostedemail.com (Postfix) with ESMTP id 569081C0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:37:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="31/57bWW";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of bharata@amd.com designates 40.93.201.71 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778495851; a=rsa-sha256;
	cv=pass;
	b=bn99Ga9yPkCJvCQr3BdG8ZnFqGNxck4ckrK7JLQhrS0FOulGwPWPJ8hVUfaIqU9qUTP65A
	OwK0aB+kpTvcWhhcg4MVmzLpck8m+Fic9vFI+5Q0y1Y73yFzuDHw/kyimlVe1IWZvR0XtR
	aoqFTtkJVefvOAPjbRQinLpCWHK1M5A=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="31/57bWW";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of bharata@amd.com designates 40.93.201.71 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778495851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2YNIlNuE5VXcN7+p7D/ySNfIzB6rJ8Nnon0b55S0/i8=;
	b=Uje1X8opfoLADFOyT8yAO363lebCzOI9YaGYy4ZCb1/F6ibAfv0iXMSduhyvbClTIYaH17
	gu5sFf00u5ISGAWjYYCgT4RNFyq2W54K+ovfKsXfFBhEnc0lV/J9Gccti+YStTiXEwqIfE
	54S486gQVwWTkK7yRjJ6hwd2z4J1rrQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J3AnXm6kTinJhUAhYeO5zExfDHR3/izvxiJ4NkMR4x0PgF1nVyNeEha3pRTh3nGGSdflnY87WOMXZ2mbAV05kzdqnaeBThfU+pK9xWoGBS+iATNfR3eC5+jF8CxmwErDRw9Ari1hIuivAW6PrOHA6Hjiz6SRfyKXIrJsHwiwW7njCtqeUk+VZKXdu1DvqsIw8gBWfH0wFTPvVEKSw8wFslve1igBqx4fupNr+F0zcybsEVN+eBMpQCnONlYtDKO8e1njQ+ktbXSbsSbt685iM6pE4V6DAPtG1mFvkLHiw+ZYxxRr0A4gwwrhBWrNJ5jV16RvSc3qMxD78zENwpzCLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2YNIlNuE5VXcN7+p7D/ySNfIzB6rJ8Nnon0b55S0/i8=;
 b=xczusauDFITHOgUGP3k/PgPHqMA7PGjZJR+d43TCDCkwxhvQpXJuAZ8tQXrPOBYqgSOOgYr2tjEHWCrazB4VQS4KJpXpu4YR0h6qvRtEM+eEF15EY9QJUJIi7by0WuyHcIRGUT05k2U/m52NkSHy45eRXNFFljAIEFm3ev32rSVGoUJ3deU7rZPHcjtcE3sM1x2MxYrwErQwBBBNzYoBZVdXtPcK42DDwi5WoQZzTFGI8bdjT1WKECYBfr1W7GeYRJAbqDkXB7+nVoUKcPYd6wFbene4uTEu92uc/6UDf/HK03tu+76wDm1yfy3NMIWoEZAlR8VBDHOoIlbyHgd2Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2YNIlNuE5VXcN7+p7D/ySNfIzB6rJ8Nnon0b55S0/i8=;
 b=31/57bWWHPAaZt2GVTqHpKMufsShM5zM+yqkCH2Nog2CAG5uTiWlAFQbsc605A7myGTyTJvd3U4Sqjjcyxvt84gQJakP5sdhoqxQ1EqrJ6Crr0Qn9soqqsBnDXfkmvI0YMKiotmLqBIXtTABzDsXXnQdHnxfgaF4AJ7jawLGjAo=
Received: from PH7P221CA0033.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:33c::25)
 by BY5PR12MB4068.namprd12.prod.outlook.com (2603:10b6:a03:203::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Mon, 11 May
 2026 10:37:26 +0000
Received: from CY4PEPF0000FCC1.namprd03.prod.outlook.com
 (2603:10b6:510:33c:cafe::20) by PH7P221CA0033.outlook.office365.com
 (2603:10b6:510:33c::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.23 via Frontend Transport; Mon,
 11 May 2026 10:37:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000FCC1.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Mon, 11 May 2026 10:37:26 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.41; Mon, 11 May
 2026 05:37:25 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 May
 2026 05:37:25 -0500
Received: from [10.143.204.127] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Mon, 11 May 2026 05:37:17 -0500
Message-ID: <893081eb-d747-458d-b6c6-86fb04bdd5b9@amd.com>
Date: Mon, 11 May 2026 16:07:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>, <gourry@gourry.net>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<david@kernel.org>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>, <shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260504060924.344313-1-bharata@amd.com>
 <5110e313-8c1e-4f73-b77f-68d20c2046c8@amd.com>
 <20260508181812.d2ab17b08529f17b330e157c@linux-foundation.org>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260508181812.d2ab17b08529f17b330e157c@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: bharata@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC1:EE_|BY5PR12MB4068:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c5a7b27-82f8-4154-b9d2-08deaf494b1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700016|376014|82310400026|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	L+XtpkERCbBBrXWODENhRPBPV3plikkenLynM5VQQ5pvvZpM+ZqE7UTCbUAYoiOIUkY8/230zc7b/nBy0mzl90tYu9ZNREAQ8RRCiKK41V7oGQfSESW+5SVwyjPjQ66CfOY7FB6GPoV+9daqLCS0X0Zac/sqAmSKqdnHEgxYCMJpbLGqQqlEZm9l/FHU9cD0LfVwa717dZ6a+xofgGd3ZGfHNVn/7Pnp6XJl9i9IvqsAQvI5JUYqDcrvVxhBvEgWrSbu2oZIbyjujWaiXty+SB1hGRJR6HB8WNRQVcoxVr+M0r2COw1o2hHYVyyxofiG0aWXDNMOw3HBYRPqp11XhVMWWswBYjz7X2rYNIWYtKbPFBitOfnFzPezwe71ZHuZDgZtwJ0Uj4GDUpj3fqPY/ywxbtLri+ivruXzLjzp4RAzTMg1RP5U3Q70w7Mmlso0qNYGm1vgbrXaUwhM+MQn/lb1bDnzwTvi4JAALQhuHajD6k+3pDed92P0NNGWqVqGDCq/oohXirqnQBeI62gRwIknVq39tpBxXWSz1GJaW1+QreUXtkksY9QV03aKvIsHhrxxKLZkaU02mG4DWA04sGKkx94NnfJJFUlQaazBg/i0Q/WzmYVGZGKrxbPdfA9aBhsaixlhQjbZ7EwNoQ3Rzv3IEgT3+Rh7VEPfUXaYUoAYlaus8WgyetxWZcFWoqJ67lbMAu3mlt2VtQN8sKZMz3/3kZUY4sxnD+VmUUoTmDw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700016)(376014)(82310400026)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/XyS+5lzRnl1AG7mRYy6f1qI6w1Q8z/GEiyXj4dMb3zAi2yZ6zIF1P3ASmvZMfK2pZwv9yf4Ek5/grPxldl2I7K+nhtfZ+X2Iyzc0fLPRwTeXIanqRF/c9R/G9oQjiCkZgj66vv0mOmWz/KvTmN6A2ZYM5zIffagtiYQSKDWR7HdEA+n2kVFZ9F6eE2+/P9FMpPg9LJI5vqOexXEHZH5ovEQzI61Xd7LVWW0ByrfDhYriE/FU6Lacq7CZdRbQfedCZXIdmvoOBeqiYDVKE3iFFV37+MnMsIH2Q07f22ms+wiQCWtRIhDdbKgbek/W1WScR2FgsNBbn/Ck/sWgc0N0oC2zqvGh08pvDv7t/KLK+OJdSxeJWYgNGpPNY2tynYWC94KwuSaRk5ZfSBCHB1bJ90yyO6ANlxAPlJ6fZLes8/EBZZnFO6xFI2vctMnfPBS
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2026 10:37:26.0086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c5a7b27-82f8-4154-b9d2-08deaf494b1f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4068
X-Stat-Signature: h6znfpma5chjyrqdi387k5uctn9gn8os
X-Rspam-User: 
X-Rspamd-Queue-Id: 569081C0005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778495851-119868
X-HE-Meta: U2FsdGVkX1+DZdaV/f7JqrtkjzSUXJ5lo91N9THcsE/aO+x9bSAKcYxHMnVwXJsz5q1yi8tLJYzVw79/5MTngsUUJTcKf/hgFbjLNYXjQOaj0l08w9Q5JEFsIsd6QsUWwpfZsUa9ctHt/Fz1m2fqHx17SdsQT0ck1V8tnG1HZkkZvYunsha6WLg3c30WeHErTP37BmXwEeLRfHqCtGOsdIhdOSt4jxQRQtatBQHhIbf5Z3uHeV+TWaf9wuZuv6eaCtPAzOjXlaQWE/FRX3kFuPoCDLb5HI8clA0qKrbt2fmlvwPmzlzeuM8R+N7G5NC9VnVfYp9zrf1PjeB7Hy40+o0PbWqnIgK+BS6gLwyJ/eIBzO1KwE9w0ddo9ntF1iDOcKkWpWlqR3v9BmRpI6tAWCg8pdGHsf/ftyaQaEfgJxWnKRXnMoWAY/+tp9qgrpWcwc8D38lOM3+FVje77DRQN3VwiiShzjslI/bbYuHj+RYqaEdHk3BQLgalokfU1t8/WUMmHVkrNwmoaHjOdNnOCifUm2bpolJD416ddioJ4Hesz3tcjtHMrAqIgxVTS3uxFhq+Q3/3YDEHs2fGlhABhyih72rTfjddcO6PZOwe//1Gcm+yedJkOrcA/ULKI54YMqBShYd4cxkoLLkNDPqBVmou0eJl4sEJJR8S9mXlzPNbavN5zsjLoou1leCyTr55qtsV48gi+rvucUoAXkwczeWyho9kFytYP1LQTiLENvTIXB1Zm3+1OaMhqT9SRpMiD9+ou6SYAuRQmz7HlUG4lI4hrtvaJIRhNjtQC2HAFT7FYul4GO5wFk62UXeM/tIqGd9JxWPmuCJn2IAx2QjiiNqfkVoZwcxuA4JmDFx45fAehzZFnZsgXqDNAShKzf8hEX6pHc+TXT7DK85A0PQMrawoYSJWOXWuycsGLTTxKFxeTTxYewuv2Koy3tIhDFI76f/4UiJK2nTAclGioKU
 3Uibulsy
 jUXx4MVbbG1x5XLFEo+BziZTllWTFKobJncTelv29LwMShTZmY2a4PZYf14qzwjOqmvBGNK4f8rwPZKzsrTsUOKVHKvDPHE+fD0u2Cz0hbk8TAQBSMFRnO1mqX2pIzPiZJrm+uvOOU9XgOFqDdwnbBVrdoM7KdxmzY+XrwuQKNmqUdxgwiRm4JL+FHRXfpnXETydXIJT7FX3Y97TJibxIQNu2llOQhJRu/ZNy3ZzD1ln10sAbVKJsDi+j3XqgJBl93YAlWLmDUM99DBbOeTgjHvIAkYRjzJcRd8c95AqOjxs9RRU9HSUzqEdb9R+gBiwyXuvfjMxBV5ceEJTcFibe4ei4Oz5QyQQQR9kmNyuwAEGlVouOTXhvnGN/+774qb16QVh1Nb6+dY58a5JzHap+Rd7+P+uAxILeiXFrv18kwpW5OmPiMSqUM6+r+sShIpUxNJPjxmPKkUT3jdqIgSFqGKbGcKwUhAjuw77j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09-May-26 6:48 AM, Andrew Morton wrote:
> On Tue, 5 May 2026 16:11:43 +0530 Bharata B Rao <bharata@amd.com> wrote:
> 
>> On 04-May-26 11:39 AM, Bharata B Rao wrote:
>>> Results
>>> =======
>>> Posted as replies to this mail thread.
>>
>> Graph500 benchmark results:
> 
> Please include (and maintain) the testing results in the formal
> changelogs (perhaps in the [0/N], in a condensed summary form).

The results and associated description were getting too long and hence I was
hesitating to make it part of 0/N. But then as you say, I shall include a
condensed summary from next time.

> 
> I mean, the entire point of the whole patchset is to improve
> performance (yes?), so this contribution lives or dies by its
> performance testing results.

The entire point of this patchset is not just about improving the performance.
It is mainly about adding a new dedicated infrastructure for detecting and
promoting hot pages. It is about having a subsystem that can act as a single
source of truth page hotness in the kernel. Though we aren't there yet, we have
started by having a minimal infrastructure that centralizes the hot page
promotion and associated heuristics that currently sits in scheduler so that the
same can be used with other page hotness sources as well.

The first source is the hintfaults based hot page promotion. Here the address
space scanning and introduction of hint faults still remains like earlier. But
the promotion engine is part of pghot. Hence the comparison numbers with base
this source is about meeting the current level of performance and ensuring that
the workloads don't suffer due to batched migration.

There are other sources as well with primary one being the IBS Memory Profiler
which provides memory access information directly from the hardware. I have some
numbers for this source as well. Initial results look encouraging and more tests
can tell us if this source can be an independent one or complements the existing
one.

Then the earlier versions of this patchset had another source - PTE A bit based
scanning where the idea was to completely replace the hint fault based mechanism
by PTE A bit based accesses thereby taking out both the detection and promotion
parts out of the process context. I have temporarily removed this from this
patchset for two reasons: a) to simplify the patchset so that we can get some
consensus on the infrastructure part first. b) to explore the commonality with
another PTE A bit scanning approach (called klruscand) that used MGLRU's
scanning mechanism.

Also on the horizon is to use hot page info that CXL Hotness Monitoring Unit
(CHMU) can provide.

> 
> The first thing your audience will want to know is "how good is this
> for our users".  So tell us!  Up front, within the first paragraphs!
> 
> The better the results, the more motivated people will be to help get
> your work upstream.

So currently it is a multi-step approach with first step of building a common
hotness infrastructure and moving existing mechanism to make use of it w/o any
regression. Then follow up with more sources.

Regards,
Bharata.

