Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB2AF46122
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635716B0089; Mon, 23 Mar 2026 10:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60CEE6B008C; Mon, 23 Mar 2026 10:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522AF6B0092; Mon, 23 Mar 2026 10:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 432476B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:21:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDC6B8CE45
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:21:16 +0000 (UTC)
X-FDA: 84577540152.02.968D066
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012004.outbound.protection.outlook.com [52.101.48.4])
	by imf25.hostedemail.com (Postfix) with ESMTP id C9212A0008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:21:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XaiO6of9;
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.4 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774275674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8rknWpS4LgoYZHECnLHruXdkXFO8hDSXhTHGjL15WXM=;
	b=aB6caXXMTeGvhdaeHMPpfMFqTTbHI9Q+zVBiP9ftGxtzz0+Tvm1oE0C1cLbCcLyM4xCKLh
	EuZO2dWbPqNHN6QQ8pu3lsZl8IxkZP9I+nwqwhqmtZ7v0t4GyU5qCyiFkxfPJwN42gNCHI
	T2Ik4u/uQiTNSQET5Mrsx96/CxmaBos=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XaiO6of9;
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.4 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774275674; a=rsa-sha256;
	cv=pass;
	b=fylKGDNMKopvULY7xz8LtrHCvB9Y+Rx2WEyXM0QmD5vROn7ZehlzEnLpUOjn5tgQd8+8Ou
	Rcu+11NiKkjvP1KGhEbY5mCxXxnGtd0dbUGze6IlWUgszSkN5qNgyXeAB6P1y+eessNCvo
	Xl6M1m0/RnIP4tLgcgkNcfwuBxK5mkM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O3KgN9NpwWeedxdGmegm2IYE7lQFXSqb5wYLMaisbEPcCDIFUlyprZObeGumAF43euYXAHSHlE4tugUx1l6i/zUT0rBJN9LncOYAaG8i7B6vBBMrdBI80HBCoegW9lo5xFXlgZJ4BlMfEGTLWbdBN1d4jS/3TUPdxmXfvg9Q7/DRiON2qWxkDKzTT5KshK5ok4i/CWzCAvTM7gDLR/NsEBQcXkcWfui0L6hfquGUzG7bjqeFg/fLcLvv/w1mNZ8qwDijtOO/jiZb2FvbDtf0+1BcRw8JgT5D75v5+zgIzXcXOsEKSj9OIsgcw5OvkkCWrgcWHnRqmE1VCizovI+1Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rknWpS4LgoYZHECnLHruXdkXFO8hDSXhTHGjL15WXM=;
 b=JWICfU0bYgOzxucbAUp6qa1ACC/JCkAYO/4V25F0uOcanJU7BnUxxWGUbNUGfd8ZyE6e9LPDRouGP6jdJJML1I7HTYxorfY6I43b8nNOsUk0AG8Qn8Vn+5PmZxtZaVB5r4Ca67c6kuokrADOH2YU9sueX7QxsOeUAXFGjEcwT21Nk4Biy3R5Gr7R8aTIh5ldVf4fAC/M1Jk56Nk07dDmRCDxnGPhSt8bq/BTSgE3N3yHWxUKLTXef1rJFfKv/G1ed7mCRofgflyHFdPo31rcZwKvt87ui0alem24GEo7R7outcJAy+Usy1BaOivICDvek7sFdgh+i7w1IAvlqPmUdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rknWpS4LgoYZHECnLHruXdkXFO8hDSXhTHGjL15WXM=;
 b=XaiO6of9mpxwSPG3ZjXzLzGjDvxC3SPZnI//p1WTfT6zDTpwT5qiHZMmemP2w++0FG/ndsxbf9N9nbOy2z4xVhJTvVBYqdnfF9zSYwf1y0yf8eR9ILsn/YHSnBk3LwDjTxs2rz+xB/N40a3bCv8Z3PcwI28Dg9T8e3dEzYRf7iw=
Received: from SJ0PR03CA0299.namprd03.prod.outlook.com (2603:10b6:a03:39e::34)
 by BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 14:21:06 +0000
Received: from SJ1PEPF000023CD.namprd02.prod.outlook.com
 (2603:10b6:a03:39e:cafe::af) by SJ0PR03CA0299.outlook.office365.com
 (2603:10b6:a03:39e::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 14:21:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000023CD.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Mon, 23 Mar 2026 14:21:05 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 09:21:01 -0500
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>
CC: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
Subject: [PATCH] mm/migrate: rename PAGE_ migration flags to FOLIO_MF_
Date: Mon, 23 Mar 2026 14:19:37 +0000
Message-ID: <20260323141935.389232-3-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CD:EE_|BL1PR12MB5732:EE_
X-MS-Office365-Filtering-Correlation-Id: be3e17bf-9dd7-4a26-53fa-08de88e76b9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|376014|7416014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	7FwyeJLph9nwhYj0v2XguVPrGKlUK9wrCd6loEFQqBZl49nqhQTeeLKDlhUmQl/JdbMMHCd+66VaNku+ugI9QY9lmmONVufOZQ/LS2PGz63Kdzw/4YW3/sTHd+AvjHpUmoRWsCfB4wzi9gVNOCZd4FE64C1c5/drNNLx45qx6gWaYWSK/dvwWSK7BIPFuHCk/NEdwihVOqinKgBWkkJLIZgL8rSyjlyAdwsB6Jm+fPNkoKSyH5idNqhlp1LmoKzqfublo2oYdfyKVy8o/HMizp8/N962l5asvxhumeLXKByHqM89EnzAp0J/dCL04tCdfqW5aqWNYI7aRxVL/+C5oXFXnc+t/TdBhCn5zzd8EqzGjOut3FdzqczsBo1GWmXfj2L6Wlyi1GgpckJaSVvcvhIHdFfeV1Z82DAQtG/g+1xiLDTVR6uNNPHejZ7CMCF3HHnU2BPYnyvVUVM6I/gR5XrKM89GnRtO847W4wvWDeVyhqe9ZWbVxwbRsi3eBuk7WQiMBlJ3YkajiXY6hmlGWnuyahuQYiKLurjjH+RhQHoKI4oA5r7wey5RlCFTnuj+0kJA/CsWmj32wYuNq/J2qCngdY/Gm25VOIc4PFMALQrO/302z981TFNhycF/MDRg+bEECDciZ2kfqvVgLIwkT8ZbQCLFxdu2wSkHJF9jZmA9QKYRcCw3Z5IvmnqMV89nkWPCOzTBKRvY2co/uOTEiW7o5VIuwyW6XqR+7CMblrk=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(376014)(7416014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TOMtPtEKT5EMfx8o7A+T5amwCFfztj24feKgki0AAU3/xlJOfH5a3bPqW2hqtWmN224lrlPW//aSxbQ0YCjRPG/11jD1TfejXVNpbvVoisVvhhfYXf85nfQKxKfTTQBgsL+WXHddgySg7M2dGz4U6E24Yywk30ydyzchWvE053iP6mZEjOVGAf69omNnVK2M0sd0kFckbNWkoRl3VRhwkmhoerJY7J2jqJ5SjTzyBUpnJyGQaOhW0uUm1Tdcpo75nlIZKnl/He7kcBhAcpWwvnG2mQ+xlj8ZvUAhmDhXr+Rf3xGA9kMb8oAOWciN3bx0rY7v8GWlpEVOuSGXG1zyHqkRIO2xcZU4/lLskf5cd2d8QcBW1P58LUxanf09jprmIXWOc4eQuN+qxEx2PKNqOGbWgDZ7RUC72EbrXzb+ShwORb1NVgujGcAyDGfUiFfF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 14:21:05.6207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be3e17bf-9dd7-4a26-53fa-08de88e76b9e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5732
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C9212A0008
X-Stat-Signature: rb7drhzfns6gne8k6idy48r1mzbgag4e
X-Rspam-User: 
X-HE-Tag: 1774275673-217999
X-HE-Meta: U2FsdGVkX19LgVD4UJQkhDFVBpitGQcn6GCEx5uyEFRD0rPMPQWvgSe6RVZ+JhFhsI8FaTXxk/j1NfSG2tZ62olSK975FEwXspY28YpYpYT19aH33GCc4NgWhPanFGx2RFDyzz25t8sGaCJEfasWj3tEQ8WYwS5z/u32qPIavEMsrF59fzHuChWRnal706sqv553O6ptVtxIr8scnl9jZ/Xx6lsXk9dEGOHhxXh1AlwowKuY0sw4Q5o5tcVtqYINSFDGqIvf6W6SghOsW2v677HEnaYliVybTnxGYAguSFr+Yz6NlnByMet2cd0F8ZMbFg1/CJt64L/hmdrrbrLc2pvoUN0noNRyFRi001DjXJ9SiXgVAQCGmdfNVFlGTKUbtmDY8ZrOYEbBToHIapnd6YPtQRa9fB2izlZOf7OtadO6/72cZyTaRw+QKOG60OFp1zRpK5v357NYuv97EECrWqbiryTFekoD+YMMgLdZv1gQK71+5ZxC7SQ8OSpWm4ylY5x56h0RHUTMaFDIoNlosT2xt5jPY4hXTuaKgtz67XgLLhm6s41ihYe6FoMf+n9hQu837I00n8e3sb6McRIH5PtKFfGvtq1g6yhLGIq1fOnwzbOmFYKq9JS1CLcqT+TGBmKac8w0M9kr2iCA/huHwEDVvlVPt4kPpj8Gr5C7oJz0XQQkEwOBj6D1wSxBGStfo+mXcaCwxR2UcKrk3hLHfppMpqpunzPnY3tRjLfHvTfvTVBGE0CjezeKCD1cwp+4g7x+z+x6oLu/vzMVRHxE1kVuKnOY6mA0PSRiZwnPFdLi0usS0Jtj5IeoQhIm+lRQkXvkrU0jNJnECfLNubTBIgCLpGwmC1eic7uJOyO7AuA/VfMjJjjSQ2HUeZEia43hVZPcaIHjLFE6aHwPRqrPWy/CdQbE/RCy+Zk9hnXj5EUoj/9YhtgIfJlLYCa1OqUAmES9f/XQNxEWkY5ySeV
 hF2qY0un
 m1wC4Vpugc2e/b5BdOPMxffjb6SQIZui+nJt6Fqa9k0nFSUwpozZyDjjlPHo7tWpAbhU3MFHLL7pEpEKxT03ea9Ed3S/2IFJPMEzq+iisY4DuaYjhF1I/ry9ijF5OxCu3+bJbIlz29KKLYf2yFme4kYv0gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These flags only track folio-specific state during migration and are
not used for movable_ops pages. Rename the enum values and the
old_page_state variable to match.

No functional change.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Applies cleanly on mm-new

Ref: https://lore.kernel.org/linux-mm/4bfec2c1-9747-49d2-a490-87ab204cec1c@kernel.org

 mm/migrate.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 05cb408846f2..a1856321ae27 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1135,26 +1135,26 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
  * This is safe because nobody is using it except us.
  */
 enum {
-	PAGE_WAS_MAPPED = BIT(0),
-	PAGE_WAS_MLOCKED = BIT(1),
-	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
+	FOLIO_MF_WAS_MAPPED = BIT(0),
+	FOLIO_MF_WAS_MLOCKED = BIT(1),
+	FOLIO_MF_OLD_STATES = FOLIO_MF_WAS_MAPPED | FOLIO_MF_WAS_MLOCKED,
 };
 
 static void __migrate_folio_record(struct folio *dst,
-				   int old_page_state,
+				   int old_folio_state,
 				   struct anon_vma *anon_vma)
 {
-	dst->private = (void *)anon_vma + old_page_state;
+	dst->private = (void *)anon_vma + old_folio_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
-				   int *old_page_state,
+				   int *old_folio_state,
 				   struct anon_vma **anon_vmap)
 {
 	unsigned long private = (unsigned long)dst->private;
 
-	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
-	*old_page_state = private & PAGE_OLD_STATES;
+	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_MF_OLD_STATES);
+	*old_folio_state = private & FOLIO_MF_OLD_STATES;
 	dst->private = NULL;
 }
 
@@ -1209,7 +1209,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
-	int old_page_state = 0;
+	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool locked = false;
 	bool dst_locked = false;
@@ -1253,7 +1253,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	}
 	locked = true;
 	if (folio_test_mlocked(src))
-		old_page_state |= PAGE_WAS_MLOCKED;
+		old_folio_state |= FOLIO_MF_WAS_MLOCKED;
 
 	if (folio_test_writeback(src)) {
 		/*
@@ -1302,7 +1302,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	dst_locked = true;
 
 	if (unlikely(page_has_movable_ops(&src->page))) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
 
@@ -1328,11 +1328,11 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
 		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
-		old_page_state |= PAGE_WAS_MAPPED;
+		old_folio_state |= FOLIO_MF_WAS_MAPPED;
 	}
 
 	if (!folio_mapped(src)) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
 
@@ -1344,7 +1344,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	if (rc == -EAGAIN)
 		ret = NULL;
 
-	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+	migrate_folio_undo_src(src, old_folio_state & FOLIO_MF_WAS_MAPPED,
 			       anon_vma, locked, ret);
 	migrate_folio_undo_dst(dst, dst_locked, put_new_folio, private);
 
@@ -1358,13 +1358,13 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 			      struct list_head *ret)
 {
 	int rc;
-	int old_page_state = 0;
+	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool src_deferred_split = false;
 	bool src_partially_mapped = false;
 	struct list_head *prev;
 
-	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
+	__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
@@ -1395,10 +1395,10 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 * isolated from the unevictable LRU: but this case is the easiest.
 	 */
 	folio_add_lru(dst);
-	if (old_page_state & PAGE_WAS_MLOCKED)
+	if (old_folio_state & FOLIO_MF_WAS_MLOCKED)
 		lru_add_drain();
 
-	if (old_page_state & PAGE_WAS_MAPPED)
+	if (old_folio_state & FOLIO_MF_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
 	/*
@@ -1439,11 +1439,11 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 */
 	if (rc == -EAGAIN) {
 		list_add(&dst->lru, prev);
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return rc;
 	}
 
-	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+	migrate_folio_undo_src(src, old_folio_state & FOLIO_MF_WAS_MAPPED,
 			       anon_vma, true, ret);
 	migrate_folio_undo_dst(dst, true, put_new_folio, private);
 
@@ -1777,11 +1777,11 @@ static void migrate_folios_undo(struct list_head *src_folios,
 	dst = list_first_entry(dst_folios, struct folio, lru);
 	dst2 = list_next_entry(dst, lru);
 	list_for_each_entry_safe(folio, folio2, src_folios, lru) {
-		int old_page_state = 0;
+		int old_folio_state = 0;
 		struct anon_vma *anon_vma = NULL;
 
-		__migrate_folio_extract(dst, &old_page_state, &anon_vma);
-		migrate_folio_undo_src(folio, old_page_state & PAGE_WAS_MAPPED,
+		__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
+		migrate_folio_undo_src(folio, old_folio_state & FOLIO_MF_WAS_MAPPED,
 				anon_vma, true, ret_folios);
 		list_del(&dst->lru);
 		migrate_folio_undo_dst(dst, true, put_new_folio, private);
-- 
2.43.0


