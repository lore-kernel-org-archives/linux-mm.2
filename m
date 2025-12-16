Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB5D1D5E130
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C58B6B008A; Tue, 16 Dec 2025 06:13:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19C996B008C; Tue, 16 Dec 2025 06:13:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041346B0092; Tue, 16 Dec 2025 06:13:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E19D16B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:13:40 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 911EE1A0418
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:13:40 +0000 (UTC)
X-FDA: 84225073800.16.F590B66
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012052.outbound.protection.outlook.com [40.107.200.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id C85801C0014
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:13:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="kTTws/gz";
	spf=pass (imf18.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.52 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765883617; a=rsa-sha256;
	cv=pass;
	b=6gvyo7u9WMQj6fKm0UEgO3DicjRXbaKQ5yPZlTDkqyU4H0tscp3P/hX3cYdh3KLcRdln94
	+rXS+97ubDL54sz8RHNH4EqnMwCBI0kLcGqaOqc7N3UJNqIqnln93OjI9s78nVUkR5261j
	lFdNVCkImzT0nlbQTWfVpBxw5R/YqY4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="kTTws/gz";
	spf=pass (imf18.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.52 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765883617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Od07SrpSk9z7pVU6vFIY7WiVnzz1TFNJ4cTAtJ+hyU=;
	b=tUsCWscaxvmRrtkcehXcvHCdStMDNs4RVrXt873LeiphNdy5ls07V2FQrKwYVLkzAevWTJ
	oiy4izzIt4ccvacYWIgJZ1+n7RINTaGsl4PFiTAZal2/rQEzTRhD9qMEfA0wNZy+Vb/Zew
	BfqgXYrXCWOELkA6VxaTFFGgRsi09Yg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CKa+lLggi7sYI/3HrEdvXsXwIm0XHMwCbyo/j5Axy7qaJifnIho8UBeT921l2+rZ8ubuKLebH/7AL9wCpW0DT/gzWVRdQ8ndJH5G80hymbhLNIPAF2knALTdQybPTt1begaZ/u578/1V2U64oteOSqAoXadA91lCFbZ3IKnvLRhLkTJ0hhG3PbyDYu2FsRLjaujhlcjwrVSiRyY5JsC8hqMannT39iKkabtvsWoJoSI+Bu6AGo8ScGpglMZh/jmLHbnC/+3GTvpjN2eDC9fIds1W2JXFoL75bGU6VKaPdgOaSq9qsAZUYLwvBf9I+Jslq5JO8gNWYHq1vDXTSQfrnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Od07SrpSk9z7pVU6vFIY7WiVnzz1TFNJ4cTAtJ+hyU=;
 b=lmEfilcg3ztk33rwVM6ZbysGXpzyTyZ4ALpdKEy8omtFYZyy2ttitkF8mCf1p8aGekBxsb9xS6zMVgx4B6ewwfp3ofEdxRrDSZZtZKTjqZCOiCnFdvYzWx4Tcw1Ck4ufmTWzOhlLc3iap31qU4zKZ3jGTfoWjjlDFUyirJD6unCk3C7R3F/C8v1X/bt8+TEQJZmZq9C7bvI5dMDHNFe2g4cwkSlqlRKiMt9UL14r0LO9QtHxyBiwtR6r3OrhrbUm2RVwmYCvJBk5HN9IJJgW/B1Mqhx/wosxmWI6QPFVn7e/ptZ2jMGFA1Nsr/LaRo17NW/yrYyLzPC0tnaBQlIh2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Od07SrpSk9z7pVU6vFIY7WiVnzz1TFNJ4cTAtJ+hyU=;
 b=kTTws/gz/qJw7godAvfQOwXr0EbZLNjyT93HU5+DsfYj92nCK4NtdK7xJdcrsGgn2kMOE7L57M2vHse/PTRK81RgSgKqZwqZO0zAHvzLCZR6VTIWY3Qfdn62vpjw3Y+HSNJmKAxgbIlDLcbbNwOgm+aph+fu/aYJWczd/U+6C4M=
Received: from BYAPR04CA0006.namprd04.prod.outlook.com (2603:10b6:a03:40::19)
 by MN2PR12MB4272.namprd12.prod.outlook.com (2603:10b6:208:1de::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 11:13:32 +0000
Received: from SJ1PEPF00002316.namprd03.prod.outlook.com
 (2603:10b6:a03:40:cafe::11) by BYAPR04CA0006.outlook.office365.com
 (2603:10b6:a03:40::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Tue,
 16 Dec 2025 11:13:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002316.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Tue, 16 Dec 2025 11:13:32 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 16 Dec
 2025 05:13:27 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<shivankg@amd.com>
Subject: [PATCH 2/3] mm/khugepaged: use enum scan_result for result variables
Date: Tue, 16 Dec 2025 11:11:40 +0000
Message-ID: <20251216111139.95438-6-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251216111139.95438-2-shivankg@amd.com>
References: <20251216111139.95438-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002316:EE_|MN2PR12MB4272:EE_
X-MS-Office365-Filtering-Correlation-Id: a2fa92f9-4e4d-46d3-ae15-08de3c9425df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ds97ZhIFJadeUvrNPVq5cyMaRqP+PVr9l2IH5DY39fZaC0n8eNYHO8ZV2y18?=
 =?us-ascii?Q?K+zhVZd33qxje/PttLQOKNogX2n1QjfQ3fD2AvPb0HuKPPEP5weeFGKMk/Mi?=
 =?us-ascii?Q?CbsWLg7WrPFWWoze9RKefijzcIeDnKajCF+Lzpgep5YCDZgSqlzN4x75VhT7?=
 =?us-ascii?Q?Mq1XE7ooSZN38NQPvGxnVr7W7MOQfCG2aGfoBAJtCujtZQ2CfM3d/YpXXUGz?=
 =?us-ascii?Q?GGAeyHGsuVo7bCHPiCrPcwpgdKTkh7QJrx9tIBzvsi78Hmo7I0zYPaeh+nRc?=
 =?us-ascii?Q?BAp60LsYm0rwdYzYOjRD4+uWrw9FLn0Oz9sr+gMHqkKZRFZxALyRxC+aDnUN?=
 =?us-ascii?Q?/e/jeUSccCHjX3FXm0XdLyCI83w6R/5nTsN+kj7kMKMwAhsubBXAk7xfxJp7?=
 =?us-ascii?Q?e17y+HwJBq/fUwPHZyw5NYkzb4kewzmpvRw/LZJ5uQcgAsBfd+6HCT5ntmNf?=
 =?us-ascii?Q?+OfK41JUQAXda46qYvGZWH2flaekdgG3Oi1UR8TKR+thT5bJCPcNsLBTq1hk?=
 =?us-ascii?Q?TndbyPaSkpbKTvq3iMA1QQX8Rx+PWK/AVYcEVfEH4CbY6eQMbyn9LOgAHOtQ?=
 =?us-ascii?Q?f5trtcEhN7in/JFqa0NVt4HyDMdI31uVF+XHdukVCwmq/06q2jp1ak4Kcstl?=
 =?us-ascii?Q?oFzvUVzl5DK5LlmJZ9I2J0+Iv27n9XrA9+52LVzKDcGDE5C5oFeYq/Av815x?=
 =?us-ascii?Q?xhVK/yxZqngIhwWPeYbMP+xxozC0FqUTFivQuGuL8kRrGc/RdZphx015UFjG?=
 =?us-ascii?Q?EBw4SACzHZhbXmFKZHE7KC/V+j8PI5wLUi4Yxnj3rNO/8h9dRtROdUSXx6hn?=
 =?us-ascii?Q?aYNoHvjfAqjGFxUO0LFtia2NqsYv5H9t2kF6PoaAzO5ExhJXd1KLRR01jwac?=
 =?us-ascii?Q?M5zb3anHwDqxOgCNlaeeihNrvrWu68U/Nddng29g6u2gUWCA3hiPEC+n2J0s?=
 =?us-ascii?Q?UCu2axoDSeyrjsLiNnIcW461yVRSCdEsCdhmWkoALOHef22U2IlX3Ert7OfO?=
 =?us-ascii?Q?cqvB2H7CP7fMmdMCvEowNqV/9SCdF89UC1i0oiFp+UbVWD51oKka5eSqsF96?=
 =?us-ascii?Q?lQ6GwiBquRLxTe576iwcvDfKuGYXZEET6E8TY1SbBy1qM8bqdKgUohTERgBV?=
 =?us-ascii?Q?loREkYMuCo0fZDqY1nXEa3NOPcPzelJxenFPFuNlI2/LCOXx4ZD/ZMS420wJ?=
 =?us-ascii?Q?uVNRTOZxMQIOMhe9Dvgp4oSVdvAEaobhZnqB67Uxq7ocLzeVLOVKq246GGqS?=
 =?us-ascii?Q?ynaAbqI8enRKMyy2xWPVjN67+vzuChoqcMcLd9q3C9+2qo1F+TwwDF4aleTS?=
 =?us-ascii?Q?77iY2izo3XbRaR1mmCee1vPN0VSC8jo1FsE9QK+8Ot+7IYUrC8ncOMLXKGds?=
 =?us-ascii?Q?c2Q4imVSrtAv/6W2/209QEGofmARuiPZrWhOxD2Gn2lauxRDlCt8hjjUvJ9j?=
 =?us-ascii?Q?iQMxJBq/B5KgBacEYdxYioyH8ZmIYx+iBC9t09KKnutHwozPAxWjPSVBtHwE?=
 =?us-ascii?Q?txMElr6FRGTKYlSUXMs1g+t8tfNK86jBvqqUXmMsoElHr+LYFWPzJBjRHJCt?=
 =?us-ascii?Q?0fTYwL7QCzvHyNQiazg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 11:13:32.0090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2fa92f9-4e4d-46d3-ae15-08de3c9425df
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002316.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4272
X-Rspam-User: 
X-Rspamd-Queue-Id: C85801C0014
X-Rspamd-Server: rspam04
X-Stat-Signature: gg9sfm45s6xayfnd71qnkg81portw4fg
X-HE-Tag: 1765883617-482638
X-HE-Meta: U2FsdGVkX1/+92qRVj/Uufd3V4mLRi7qkNJlatT0Ud3F5NtbBBFdE0ZtcwMiSz5s2Bha2FI14x5y50JikIyfUru8vVs7mFwP5yi9mRpAVyleTb2YGx3T/tpVA9++xM3qpEK+/4uonTJHvlNyx9NDgWZvIezpPQYRbH/O2ifngn4374qhJsoR/iG3nGQ/iU2bCvn+rQILI1QmMnQsUPrEzYX12J8qeHQNj0zLFjTVZasVHcQGoVvGKVjHHmlhJWfjfQ6Cm+wsA0fpPnt0MrUJJJeKpN8Lh/4473GHZW0VEILh0Ga3NKWxDJVNyWqYxPGj+jVNMAhLyf08RVJ/9qHoBetgALNcEhEDBBINdb+kh3z6Vvpad93Gk5j0P4uBLw+b/bWPiBaT8+Z3KMFr3hE6QrEF7c3nPbaGI8iqPq2C5h4hEU2kfLz7hHoNHfoAO+UQeHoCAUCyJQx4pkfVjbu2QU6E+B8kJfiMm7DprKDINWxJTubBxUbKl0BS+jO/0YxilGI0Jd/TyiGyep+cFUPz2u0mVOueP/erfvzPou9lij7RF1lFMWyJSLj2Dye5ZQBj3ewzTBM6FVoIFu17BOVdJegXL0otAsfkd6xCSdbhmO7eAILOX6KemY1Qszt6Sy9xtYLqeA7nnVG8l1IKLnC5MFXlfgpBMJfPopWnyzlVSr4yFdV1iIrujckW719XZqNFpgJSD2xrHQbGfZA58WEl9CrJCq65QyD1P0IARgbN2Rds1AapbEJblfQw28fOu2imxo/+TVQ/n8fZnjU74nuIar0QFdj8QQqr6AACQ6iRdb5Hc45hMld0J9/r/mjzUJY7Q3HrP8875C/d6ns2TMLxuyvLG/SrSdOYG0lxLVTDNHRMNOAlRASsPXPwNhxeDYcYxkqE6XI7/AJ+AHxlSBT1MQkw1kZ0qY3Y0lRSTWwURBjTnwCfVS0Hm6U2g6ijyJ6xCeev944wS0UnMvQSujX
 /U8rcJNh
 9U75qDUJhZe+jaT5FamA8fuA9ezliqYYxkZ4w0EkQSNhewB/pBG54DxeL5vhzGFpj63Vg6mFnkOWgSqj4l4AqLm/FS/xX3DoJmkpo+rhitDC6ewdUJ1SjDArPgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use enum scan_result for local variables and the result pointer in
khugepaged_scan_mm_slot(), instead of plain int. This improves code
readability and clarifies intent,

No functional change.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/khugepaged.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 107146f012b1..65b1b778378a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -547,7 +547,8 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
 	pte_t *_pte;
-	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
+	int none_or_zero = 0, shared = 0, referenced = 0;
+	enum scan_result result = SCAN_FAIL;
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
@@ -786,7 +787,7 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		struct list_head *compound_pagelist)
 {
 	unsigned int i;
-	int result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
 
 	/*
 	 * Copying pages' contents is subject to memory poison at any iteration.
@@ -969,7 +970,7 @@ static int check_pmd_still_valid(struct mm_struct *mm,
 				 pmd_t *pmd)
 {
 	pmd_t *new_pmd;
-	int result = find_pmd_or_thp_or_none(mm, address, &new_pmd);
+	enum scan_result result = find_pmd_or_thp_or_none(mm, address, &new_pmd);
 
 	if (result != SCAN_SUCCEED)
 		return result;
@@ -993,7 +994,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
 	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
-	int result;
+	enum scan_result result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
 
@@ -1100,7 +1101,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	pgtable_t pgtable;
 	struct folio *folio;
 	spinlock_t *pmd_ptl, *pte_ptl;
-	int result = SCAN_FAIL;
+	enum scan_result result = SCAN_FAIL;
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
 
@@ -1253,8 +1254,8 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
-	int result = SCAN_FAIL, referenced = 0;
-	int none_or_zero = 0, shared = 0;
+	int none_or_zero = 0, shared = 0, referenced = 0;
+	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr;
@@ -1492,7 +1493,8 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
 int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 			    bool install_pmd)
 {
-	int nr_mapped_ptes = 0, result = SCAN_FAIL;
+	enum scan_result result = SCAN_FAIL;
+	int nr_mapped_ptes = 0;
 	unsigned int nr_batch_ptes;
 	struct mmu_notifier_range range;
 	bool notified = false;
@@ -1866,7 +1868,8 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
-	int nr_none = 0, result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
+	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
@@ -2296,7 +2299,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 	XA_STATE(xas, &mapping->i_pages, start);
 	int present, swap;
 	int node = NUMA_NO_NODE;
-	int result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
 
 	present = 0;
 	swap = 0;
@@ -2394,7 +2397,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
+static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
@@ -2555,7 +2558,7 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 	unsigned int progress = 0, pass_through_head = 0;
 	unsigned int pages = READ_ONCE(khugepaged_pages_to_scan);
 	bool wait = true;
-	int result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
 
 	lru_add_drain_all();
 
@@ -2790,7 +2793,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		bool retried = false;
-		int result = SCAN_FAIL;
+		enum scan_result result = SCAN_FAIL;
 
 		if (!mmap_locked) {
 retry:
-- 
2.43.0


