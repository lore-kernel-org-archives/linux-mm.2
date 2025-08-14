Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A958ACA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47249900193; Thu, 14 Aug 2025 11:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42403900172; Thu, 14 Aug 2025 11:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3A0900193; Thu, 14 Aug 2025 11:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1489D900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:34:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C18111DDB06
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:34:57 +0000 (UTC)
X-FDA: 83775761034.13.9869FED
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
	by imf03.hostedemail.com (Postfix) with ESMTP id DA0D72000E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:34:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=UYuVJwPS;
	spf=pass (imf03.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.92.86 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755185695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gS7utFbKjKorv2yT1Bf/w1CLnRdTjrnJQe1GOY/Q9Y=;
	b=77eHOkLse1wS5E6/35UPhtzZh3rjiJsb1CuKjT6a7bXr88oevh5NAJPgIHQX7sMIseGxpl
	l3+kp0UfK42GtFIxAJh+2sTzbKL7gHSDt0ryC0AUSE79jwJ8kj02fwXpBX8K3RUnOj6Ps1
	ado5/KPa44VViUwJTCDBDSPTeZx6KJ8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=UYuVJwPS;
	spf=pass (imf03.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.92.86 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755185695; a=rsa-sha256;
	cv=pass;
	b=gKSP3lOiEtiINsSp74mpEZeI9wzW5rMGOe8EvlpvpkTwslk5AEmiga5XN0hiL+aGVr0pFz
	dIF83TN5toxW/6Ktc9AuTt9ARctHXNmvJy7nOAqoqLhquGBcv4jSB/rJFWwMs4l9VxN6Tt
	pWjGPmf+rQ6jnOE0rjlhkSy006ioOW8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZFerDHx3OqYKTErY+3AnRnDnuCUkIx3tHJbwOQZlrbawLemybtvmsRcmDGeWuJMHkbdC32hKXCICBIz0JP3m23hY4GrZjdyNfxHoSZyYelo//QVNqebo7x/Lliiv8KRcmL/M0dQ3S+UI5Y0VjmeTm9JvgabLuH5ZEYiTvag1Neu/no/kyDWvkI7JacMcHzRG/ZtdCNawagpYp/CEMP2tTigAjHSzMB0v42nYRT9L41pbzFDPc8LCGa8tkmjWlUi9BRNVB24P65AxPwQjDVAvxNV2QpwKJFkEa2OPLUZvdqhLwNRToVa07zrMEZXR9myopabHzomDL7PpmDmfnzUvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2gS7utFbKjKorv2yT1Bf/w1CLnRdTjrnJQe1GOY/Q9Y=;
 b=KeTUvX6QubqFPzif1N2RpqSzuXF4uzTyKZFtmdiMaZ/YTwx5yVrvVHE0JbzUdyeS8MqkpJ1Ppx3Wyh9+/VLwXrH3frEc+F4uJWbuRTvt6r/rDsoSZ9WQJ5pVO2H3Ap7oYFVQEluzbrwW4mmDW1MmgZpliA98MiJ2cPyDh9z8m+Ncz519wXa9jE53p3KE5TIcW9Z3k1k/bXdRPjsfWm91MBmOXLN+ptByLWcwZ2zrdchCCFYhZR1cV1aB5wBgNXsa1zZ7hIJcNvVahboOJVcDyr96HXshoN81HULcYJDefdjZ5XjYlfoh5U5PgLF6Bwki9apZomXi3GidO52IKV/ZnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gS7utFbKjKorv2yT1Bf/w1CLnRdTjrnJQe1GOY/Q9Y=;
 b=UYuVJwPS11l2EOFw17xfj/FtreMFgyzm1yWzNabIARaJO5puQKwzB39E2TWkKwNx3TSaZm3KqLSxnYukUhOHFYIXUwK+G2FBy6br7mq8ig6pTYTNY+6MB2N4zZKxDBV84nAISa8RZ/gnxuZ2fDPoHxJT07jScwfq0CjR2Deee1w=
Received: from MN2PR06CA0020.namprd06.prod.outlook.com (2603:10b6:208:23d::25)
 by CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 15:34:52 +0000
Received: from BN3PEPF0000B078.namprd04.prod.outlook.com
 (2603:10b6:208:23d:cafe::eb) by MN2PR06CA0020.outlook.office365.com
 (2603:10b6:208:23d::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.17 via Frontend Transport; Thu,
 14 Aug 2025 15:34:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B078.mail.protection.outlook.com (10.167.243.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 15:34:52 +0000
Received: from tunga.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 10:34:35 -0500
From: Raghavendra K T <raghavendra.kt@amd.com>
To: <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Michael.Day@amd.com>,
	<akpm@linux-foundation.org>, <bharata@amd.com>, <dave.hansen@intel.com>,
	<david@redhat.com>, <dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <honggyu.kim@sk.com>,
	<hughd@google.com>, <jhubbard@nvidia.com>, <jon.grimm@amd.com>,
	<k.shutemov@gmail.com>, <kbusch@meta.com>, <kmanaouil.dev@gmail.com>,
	<leesuyeon0506@gmail.com>, <leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>,
	<yuanchu@google.com>, <kinseyho@google.com>, <hdanton@sina.com>,
	<harry.yoo@oracle.com>
Subject: [RFC PATCH V3 07/17] mm: Add throttling of mm scanning using scan_period
Date: Thu, 14 Aug 2025 15:32:57 +0000
Message-ID: <20250814153307.1553061-8-raghavendra.kt@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250814153307.1553061-1-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B078:EE_|CH3PR12MB9730:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b434760-e2d1-4668-e8c0-08dddb481cc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fNKHlSNsqoUvXqr0q+xMbMxJfU10I0xAEVrnYSiGqcULWW5ZHpLCy5wzyVlO?=
 =?us-ascii?Q?HGYIlY4KK9bwIinDHmz6SDPnbtFhziYbZ0S+AR9v0lk49vPTJrYCpDz+KPE+?=
 =?us-ascii?Q?WSuapCvDU+9HHMCUFktx0gDDTYbZpiJwMwZd2+ErBY7BgbT6CAzeTE3Lqwi4?=
 =?us-ascii?Q?BTLKWHva0q1tQ9T1Gyyun/q9MQKaeGPMjVFcVVfwK0NoEEr1bLcxmmzlSNOn?=
 =?us-ascii?Q?2hZiH4/kucgikbwLo7sw7inhlzi9ZQo/OD5ZeY3XFfSDCNa/eWRgUK5iyFku?=
 =?us-ascii?Q?jd8jZDueAVDXgtI1fe9TMhyYrv8WdIJNrX82FL4zZGryKLy0Pw+tSPpPmsEI?=
 =?us-ascii?Q?3sksd2zwYpcw0Yaqt/50EWykses6xX5Sg4S5R1Eq7GptubDtLf7ZdIlSrj1r?=
 =?us-ascii?Q?aB2PZZ5yPDnC55D4RgHDj6+fMvsChyT9P0Tedhk3rKJRXSBgbq6vBhmpC90n?=
 =?us-ascii?Q?SERveyGPAQKUjgp5kHUr9qhxVCBk8m8zVVOZHk6p+thbsTHKMUu1YL4VhwTg?=
 =?us-ascii?Q?xTI+L96Ljztggyoq1aQm2nFpuY23+VUBY7hxQ5qJiDp2g/PmohRY5BTwU1qi?=
 =?us-ascii?Q?Xlft5lrem+SjOvgVyjvq01UrbWOueVnmABPQxD1FBOiJmFQQbm2Nga3vmLBx?=
 =?us-ascii?Q?MqiukQM5p01H1LvpUbQEWImO+aeY3Wqqjo0iTu1qDdFpznkCAKga1Kul2QOa?=
 =?us-ascii?Q?wxIOor2aVohhAciC/y8Ma1ETmHWipMGLAHgRsQw4YFfUCIPHas7RU+3HX+uO?=
 =?us-ascii?Q?Z+OGZ4bn5o9tJzjjkFwwAx2T2vjbPn5A2mV19dcCyfk99TehM9anzluFV040?=
 =?us-ascii?Q?aqGydcWd/xH4FLpa7Nug+/0+hlvDOnLzFXzX5Cfl2xlmPg8rYpNm5BywqQpj?=
 =?us-ascii?Q?o8ozqfKnE6MlZxYIYgUt4QjFrXG/Zx+uU/wazUu+vw3ezEw0HE5OvWj2ZYaD?=
 =?us-ascii?Q?F8myPbtq1YyPVqCrrhkCc/p7jbJOaPBvR3y/zOuWGXXw3T2WJxiqTMy1+APm?=
 =?us-ascii?Q?lHlYtLFNpv7iFMr6PUwKfPUJ9mpef6sdYAgVLq3OyiNusxXYfB55xAmmKvPv?=
 =?us-ascii?Q?4tbCUl54CPLXSHusKOWvpQA/eF3if8fwlYZL5//qKD0fzTMkOpDi6u4j0Plu?=
 =?us-ascii?Q?Rq4/4xd3ztwXnHWgflDyy01XXo4M+uPNytveW/P+JJ2ZO769PGDaY8Y1lzVP?=
 =?us-ascii?Q?HPiunUXxj9duFMx5DmSnp+gKVlVYHZjcry2eeMko4qJUJ9oKnkeKyWpkRtra?=
 =?us-ascii?Q?SQVoyWRMFM4Nl5UdCldct1JnLdXXun7Kcl+ISVFD9xO28R42y5KMbLasJkcO?=
 =?us-ascii?Q?U9YAkv6qcJxKPLgnYDr56mVud1gzWQzK4iPJiJGcsPxtC7yHAYHbwNOWcOA+?=
 =?us-ascii?Q?xu5sk/CUekLrjYlgR1FjnuyXoyn2LwytJNpuJdJnZgFaxcXvQgf1s+0LreTw?=
 =?us-ascii?Q?AJ+j+Ayxl5hyfiF+b6+WnuOx32r7J+8vQuiKNp7cLA9Vj47g/RUAjLv7URWo?=
 =?us-ascii?Q?1zx5STivK185OHptq5Dy3CdRDwK9GPYRTh29?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:34:52.2727
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b434760-e2d1-4668-e8c0-08dddb481cc2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9730
X-Stat-Signature: u64dkjcnynsrb3jxsc463htgsustksjk
X-Rspam-User: 
X-Rspamd-Queue-Id: DA0D72000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1755185694-291461
X-HE-Meta: U2FsdGVkX1+GN2Gn6sqLOXov9bNneyXa1O5YmvV6hOMsxFFyjwIm19BgGsSIB2gRa8/u9YzH5GGlcDBCyT4IcCr60JG/9UKSbYssDwIQY+vezG5dvWF1myRsTYEC9EAOCAI6kzcmvCNuH1kkByxNjTy8G4H2ZY/J8oP0LC0N2O6bv/nJUQ84t+4Rf/vMsQ/O7iwrU1ZddwRrMn4u2+KbqZRcDFnIOfPsj0DBeli6FrCa5l6fbpIwFTGby+aGpkTd+zWnyjiIlTXhou980C5/2qess/sNTWY48BsIsN4cvS11V1fQebAnIfSL9Fp8KmCZLgm2rZGR/Aa04SsOxBd6PCUp64VrpggTy3T21pqeyq2+lxBF3RvVKukRMRtMtpnujFmRS5IyKKfiCvc8eju+gWy+6ibITXdMQkDVBqQ0/7DUknyVjB8kodZkPFYbQEIHCcAZpKO34NP3AHSLEoe7LHT+rwLdt4omrOuaCFRO4SnM8WQG5QVHn5qq69SMkrYUIvKQcqcV68xDuBXvKgVPvJ8vCVaS+t2agCFl6fyw9+fnYvyXBp9i5M9sUTodeb3/ufGuNNqPbfIgZIIFjmDQqMQlSgKKkl7StwkePxOc5Oug9ODf8Zz3PJWZPjxyt9OEXBf7Ks2QR22P0uQTJk8uTq4vpFKyiFO+suWQT5C6PLWN8DxTyyNw62lrHU0DOIP/E3YtpDhT8hWY+NoFyVvXJ/nfEDqSdcVuhKPRDjjyeMy+rnc9iLPL268AjYJ7mFYwhG+g3exNhjPo7Lw/6hA75KGe0ruPZtJWaGyhk0pWus33lZoVVvmG06qApgr9Bi9fmAdksAqEKSTsxkIsq9UtyVK5i0AYuzBLvq5XDH6vMeKAG3Hl1XITH9r+SkGRY8FIHVNxApWdezX/b3TMgT0DKom2WNoBbmZvIloHw/GAxm3oMtc2x20yrOsNNgRbpOypzrTggbzRQ97zs0ZTALm
 hNB2iOlL
 7VQW9aUCLKT5FJkjLZIh/i8W8+kY4cJYOQ4yi2bzFKjvvmRtnh1Qvq5//6kJR9yscOJACzm/wAjfWL79DG80Eytv1pmbYa0RdiCs7Sy7V6+jWaVpxr4ZbAEI4RVhKWuWLH5Z/L/Lwk9mefOO0uJUrhzAihDk9owsj+v9AIzmUPaGBGPp5f5E33B94lHor+rTsJrUmJZWCMilZIVnWtJMMFQyhsXV0K9bIQivM9zNAA8uYGcsGiBD7uzaCNkFpXYsiw6cXAfsyNbjsT+dcqJWkLcnuE1ABaQzOQdEyXYdFyntGgOdcX80pf6WJ3lJmDaDW5G50i1Pq7eNP3pDccmVYFtkb0PBv71T5Wf54mdb6aSsTAPpl5ekWdsXallddxMIv1NKgc5cnp8XmsnMOlmV9cm7f+XW5R8tcE0tywT8jFgNYaWZSyLUg6SEGnKfgklZikPtZlCI5SsALO2WfbCbtycpF1fcUVYZtpCgCNkMFzeDQz7QMVraUQJI2Zz34lXyIUcuXQALdOzpDhyGrs6SPLNk3f1aUWu+oHHTTNkiQHHRdsRI/HVMKqnFYU+mvQn2V17Pvrkkwcd7/SJThuIaMd+FH1FNgokdcU8slYrWbolZxKRwOb63rvu5T1lkNjlAjKgyZg6PbbqdQRehybViwhMD5dP+yzsIRyjKhaCF+/5Dt5B4RKb/UNOAKxrJN88p9iCZ0WmylQWRySuREboJxZrnjNNxAQktwWrH0V5lBn0d1mgWIaRm3RxfujVnIQGhoppVY2mEoHzQ4BGBrJ2uXdELA6Mlt2CdUMtP4Oz9sSfFsxSl1aQbZJTOjk7YZVenWeQzSFwPPTIKl8kG+02P9KS8WnWK+J/XPereIRUqbM0eAiKS36+xO9hKAJ7a/cFgdNT3vWqQFu/Le2xZ/5ZND4ozJuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before this patch, scanning of tasks' mm is done continuously and also
at the same rate.

Improve that by adding a throttling logic:
1) If there were useful pages found during last scan and current scan,
decrease the scan_period (to increase scan rate) by TUNE_PERCENT (15%).

2) If there were no useful pages found in last scan, and there are
candidate migration pages in the current scan decrease the scan_period
aggressively by 2 power SCAN_CHANGE_SCALE (2^3 = 8 now).

Vice versa is done for the reverse case.
Scan period is clamped between MIN (600ms) and MAX (5sec).

Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 mm/kscand.c | 110 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 109 insertions(+), 1 deletion(-)

diff --git a/mm/kscand.c b/mm/kscand.c
index 5cd2764114df..843069048c61 100644
--- a/mm/kscand.c
+++ b/mm/kscand.c
@@ -20,6 +20,7 @@
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/cleanup.h>
+#include <linux/minmax.h>
 
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -33,6 +34,16 @@ static DEFINE_MUTEX(kscand_mutex);
 #define KSCAND_SCAN_SIZE	(1 * 1024 * 1024 * 1024UL)
 static unsigned long kscand_scan_size __read_mostly = KSCAND_SCAN_SIZE;
 
+/*
+ * Scan period for each mm.
+ * Min: 600ms default: 2sec Max: 5sec
+ */
+#define KSCAND_SCAN_PERIOD_MAX	5000U
+#define KSCAND_SCAN_PERIOD_MIN	600U
+#define KSCAND_SCAN_PERIOD		2000U
+
+static unsigned int kscand_mm_scan_period_ms __read_mostly = KSCAND_SCAN_PERIOD;
+
 /* How long to pause between two scan cycles */
 static unsigned int kscand_scan_sleep_ms __read_mostly = 20;
 
@@ -78,6 +89,11 @@ static struct kmem_cache *kmigrated_slot_cache __read_mostly;
 /* Per mm information collected to control VMA scanning */
 struct kscand_mm_slot {
 	struct mm_slot slot;
+	/* Unit: ms. Determines how aften mm scan should happen. */
+	unsigned int scan_period;
+	unsigned long next_scan;
+	/* Tracks how many useful pages obtained for migration in the last scan */
+	unsigned long scan_delta;
 	long address;
 	bool is_scanned;
 };
@@ -715,13 +731,92 @@ static void kmigrated_migrate_folio(void)
 	}
 }
 
+/*
+ * This is the normal change percentage when old and new delta remain same.
+ * i.e., either both positive or both zero.
+ */
+#define SCAN_PERIOD_TUNE_PERCENT	15
+
+/* This is to change the scan_period aggressively when deltas are different */
+#define SCAN_PERIOD_CHANGE_SCALE	3
+/*
+ * XXX: Hack to prevent unmigrated pages coming again and again while scanning.
+ * Actual fix needs to identify the type of unmigrated pages OR consider migration
+ * failures in next scan.
+ */
+#define KSCAND_IGNORE_SCAN_THR	256
+
+/* Maintains stability of scan_period by decaying last time accessed pages */
+#define SCAN_DECAY_SHIFT	4
+/*
+ * X : Number of useful pages in the last scan.
+ * Y : Number of useful pages found in current scan.
+ * Tuning scan_period:
+ *	Initial scan_period is 2s.
+ *	case 1: (X = 0, Y = 0)
+ *		Increase scan_period by SCAN_PERIOD_TUNE_PERCENT.
+ *	case 2: (X = 0, Y > 0)
+ *		Decrease scan_period by (2 << SCAN_PERIOD_CHANGE_SCALE).
+ *	case 3: (X > 0, Y = 0 )
+ *		Increase scan_period by (2 << SCAN_PERIOD_CHANGE_SCALE).
+ *	case 4: (X > 0, Y > 0)
+ *		Decrease scan_period by SCAN_PERIOD_TUNE_PERCENT.
+ */
+static inline void kscand_update_mmslot_info(struct kscand_mm_slot *mm_slot,
+				unsigned long total)
+{
+	unsigned int scan_period;
+	unsigned long now;
+	unsigned long old_scan_delta;
+
+	scan_period = mm_slot->scan_period;
+	old_scan_delta = mm_slot->scan_delta;
+
+	/* decay old value */
+	total = (old_scan_delta >> SCAN_DECAY_SHIFT) + total;
+
+	/* XXX: Hack to get rid of continuously failing/unmigrateable pages */
+	if (total < KSCAND_IGNORE_SCAN_THR)
+		total = 0;
+
+	/*
+	 * case 1: old_scan_delta and new delta are similar, (slow) TUNE_PERCENT used.
+	 * case 2: old_scan_delta and new delta are different. (fast) CHANGE_SCALE used.
+	 * TBD:
+	 * 1. Further tune scan_period based on delta between last and current scan delta.
+	 * 2. Optimize calculation
+	 */
+	if (!old_scan_delta && !total) {
+		scan_period = (100 + SCAN_PERIOD_TUNE_PERCENT) * scan_period;
+		scan_period /= 100;
+	} else if (old_scan_delta && total) {
+		scan_period = (100 - SCAN_PERIOD_TUNE_PERCENT) * scan_period;
+		scan_period /= 100;
+	} else if (old_scan_delta && !total) {
+		scan_period = scan_period << SCAN_PERIOD_CHANGE_SCALE;
+	} else {
+		scan_period = scan_period >> SCAN_PERIOD_CHANGE_SCALE;
+	}
+
+	scan_period = clamp(scan_period, KSCAND_SCAN_PERIOD_MIN, KSCAND_SCAN_PERIOD_MAX);
+
+	now = jiffies;
+	mm_slot->next_scan = now + msecs_to_jiffies(scan_period);
+	mm_slot->scan_period = scan_period;
+	mm_slot->scan_delta = total;
+}
+
 static unsigned long kscand_scan_mm_slot(void)
 {
 	bool next_mm = false;
 	bool update_mmslot_info = false;
 
+	unsigned int mm_slot_scan_period;
+	unsigned long now;
+	unsigned long mm_slot_next_scan;
 	unsigned long vma_scanned_size = 0;
 	unsigned long address;
+	unsigned long total = 0;
 
 	struct mm_slot *slot;
 	struct mm_struct *mm;
@@ -746,6 +841,8 @@ static unsigned long kscand_scan_mm_slot(void)
 
 	mm = slot->mm;
 	mm_slot->is_scanned = true;
+	mm_slot_next_scan = mm_slot->next_scan;
+	mm_slot_scan_period = mm_slot->scan_period;
 	spin_unlock(&kscand_mm_lock);
 
 	if (unlikely(!mmap_read_trylock(mm)))
@@ -756,6 +853,11 @@ static unsigned long kscand_scan_mm_slot(void)
 		goto outerloop;
 	}
 
+	now = jiffies;
+
+	if (mm_slot_next_scan && time_before(now, mm_slot_next_scan))
+		goto outerloop;
+
 	VMA_ITERATOR(vmi, mm, address);
 
 	kmigrated_mm_slot = kmigrated_get_mm_slot(mm, false);
@@ -786,8 +888,10 @@ static unsigned long kscand_scan_mm_slot(void)
 
 	update_mmslot_info = true;
 
-	if (update_mmslot_info)
+	if (update_mmslot_info) {
 		mm_slot->address = address;
+		kscand_update_mmslot_info(mm_slot, total);
+	}
 
 outerloop:
 	/* exit_mmap will destroy ptes after this */
@@ -889,6 +993,10 @@ void __kscand_enter(struct mm_struct *mm)
 		return;
 
 	kscand_slot->address = 0;
+	kscand_slot->scan_period = kscand_mm_scan_period_ms;
+	kscand_slot->next_scan = 0;
+	kscand_slot->scan_delta = 0;
+
 	slot = &kscand_slot->slot;
 
 	spin_lock(&kscand_mm_lock);
-- 
2.34.1


