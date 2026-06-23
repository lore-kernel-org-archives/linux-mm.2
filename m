Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F53FCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40656B0099; Tue, 23 Jun 2026 02:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F086B009B; Tue, 23 Jun 2026 02:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F1726B009D; Tue, 23 Jun 2026 02:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8FB6B0099
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:53:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBBEDA03BD
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:53:10 +0000 (UTC)
X-FDA: 84910260540.08.DCDE4A2
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 358BB180003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:53:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XBL34jN/";
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782197589;
	b=0NuuNiGhQPCndnBg6g24jEDu97BPF/N9JHDdDRd9X2NMfmPto6APaW65ReQ3IdNV9ZaVDh
	otmT1gpXeqfhuwcgWPMDUbRmSUgfCueX46ZiGNy+m1R47FQ6CRUsZE9Nv1F7n+0HJh/jYb
	FlZu6NjW0to7z4Z9tjbuJJHzSTiVPrA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782197589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=suDFp7risggw2rtoydgo2giehAA74W5ozQAmjOegSsE=;
	b=PnQVXXhlo87BIZDTCBURlyy+Enm39l8n0gtQt7vxfgCKFvx/ho8Sevlhmh4Sf9k+nCB4iS
	aLji7p9qWMzabaA3Rv619Ai/kTW512dhlpOsOoeKX/nUvyigxbwgzF+Xs0sKwHv6W1blhm
	7dF+MxjQHof88H+fIdtn/3Z09NYc2rU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XBL34jN/";
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782197588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=suDFp7risggw2rtoydgo2giehAA74W5ozQAmjOegSsE=;
	b=XBL34jN/J0MbWyvY68b/Ifj4Z/5qfsff1mLFL6RHLh7EOsCk4GV/uMvIVHTHPlys5e2gka
	/hz6IGYb0UNa39xOyS3ewY7P1y6hcWduQe4s3oy2ks2E79CPW7SS8JFacbcNufvRN9iA7c
	dEDmZ6h7XouuubyNgxWzFx7GO9EqyPY=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] mm/page_owner: drop redundant page_owner prefix from static symbols
Date: Tue, 23 Jun 2026 14:52:31 +0800
Message-ID: <20260623065234.31866-7-ye.liu@linux.dev>
In-Reply-To: <20260623065234.31866-1-ye.liu@linux.dev>
References: <20260623065234.31866-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 358BB180003
X-Stat-Signature: 3stkz6374oa9umb8t8k8jgsu7nfhjx7g
X-HE-Tag: 1782197589-289252
X-HE-Meta: U2FsdGVkX1+9qKOyFtweTWSOPPHKoNOcGq81oC95Pcx3/JmIg1sMoxSJHDYdDlifHMsqOQTkaHeuzdjtxUdP4txBCNm30z5bKdRjT8MB8MI41NOTa9BxecBupWHO2WhiVwSWi691kaeRfF+cBqsWxgw38FywYxwLzIUxOAsWCmYCoS8y41FRZA0XLcnr2pGRnOz/2O/sEKrTyCiJZWQPxwtmKwd1QImbGhofKM96B75b95fv+vxs4J0nrM69CpSKeGweaec56Nj61jP0uU7VhCcdNityry3T2DEL+JQbOZptiIqf7VKcAfMiQvJxnVuNWnGHd4wa8psrlkXbSD2q3pptCMuvQE70h2J45Ynr5u8RdcXLK7SznTGv2AHs2SOsHZTDx076Vrv6ujGTObrUwzvoayIXFO4G5ZVT+v/GtZGTJWA0GFErNbQBcad6gyTkA6K65SN46WqGR3+90iqjcX9SBySJZ/XqAXSqyK+Fglusk6k7IEXDZyStYHp1G8Mt9ujimGtdDosyOZvmk3uTv3iIMSM7qtuXK9iUV05PerVeHIzHZqikXzv3CCnd1Vg/63MeMNRgQrg3LnaUnincB9DPSgflljlvlG218gOwmAFHoLZT/DyNob31TrtF1UEHel+xvl3cyjUsK3yAFIPBcFD6zIQHuYPgXDqIvCnfAMusrDS7zRQS7LwP/Rn/MgQvLFSA+ccT21/CKEMrodfz0s8HWZ3NuTPxnn93oOtzMbQRQ8qj8aC427VQxmxlTyikLQRKaDFjq0kr0iNkfDToDv1ajuzzxS3ZfIjTgIEjssYrCrj9/Loh/DaJuNtjtw7Skrx3oOuf1w2O6zL++XyKLfxpKtcYW2bhrkixiALufzqTMkVKG/GVCaUFC2IthTR4GIziEv/JQrzIuZZKooT+Q9DIBSPkOShgJSEjo5VAqKOMxqvZ9oEAajCgeCNyWxxq3Iu9hxKboqpQ17GMkZ5
 6vtgia6O
 wMM/RJaJ940ogcyGDMfSCWxWpJCN7XEH5HM/KwnYqq0PKwgXkgzwIcPWMvr2dCKC8xadxivH3dc0aAouwamEh1Ar8bymwUH5YnKi8LLZgfiEwO6TQ4KCW2kKB5ISqFAc9Ivp1RZEMNC8rO6B6jNBluRMEhE1fpyVVBDumhLuIRAK1pH26PNirt/fDupPSwCOwpsqXI0QwlturWqlII33flV8jQa0/OtKeoW901ZhvHC7F6YwFMNBj/3/AOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All of these symbols are file-scoped (static) in page_owner.c, so the
page_owner_ prefix is pure noise.  Rename them to shorter, still-clear
names:

  page_owner_stack_op      -> stack_op
  page_owner_stack_open    -> stack_open
  page_owner_stack_fops    -> stack_fops
  page_owner_pages_threshold -> pages_threshold
  page_owner_threshold_get -> threshold_get
  page_owner_threshold_set -> threshold_set
  page_owner_threshold_fops -> threshold_fops

No functional change.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
---
 mm/page_owner.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index eaccff355cb4..ec9600025127 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -901,7 +901,7 @@ static void *stack_next(struct seq_file *m, void *v, loff_t *ppos)
 	return stack;
 }
 
-static unsigned long page_owner_pages_threshold;
+static unsigned long pages_threshold;
 
 static int stack_print(struct seq_file *m, void *v)
 {
@@ -918,7 +918,7 @@ static int stack_print(struct seq_file *m, void *v)
 	nr_base_pages = refcount_read(&stack_record->count) - 1;
 
 	if (ctx->flags & STACK_PRINT_FLAG_PAGES &&
-	    (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold))
+	    (nr_base_pages < 1 || nr_base_pages < pages_threshold))
 		return 0;
 
 	if (ctx->flags & STACK_PRINT_FLAG_STACK) {
@@ -940,16 +940,16 @@ static void stack_stop(struct seq_file *m, void *v)
 {
 }
 
-static const struct seq_operations page_owner_stack_op = {
+static const struct seq_operations stack_op = {
 	.start	= stack_start,
 	.next	= stack_next,
 	.stop	= stack_stop,
 	.show	= stack_print
 };
 
-static int page_owner_stack_open(struct inode *inode, struct file *file)
+static int stack_open(struct inode *inode, struct file *file)
 {
-	int ret = seq_open_private(file, &page_owner_stack_op,
+	int ret = seq_open_private(file, &stack_op,
 				   sizeof(struct stack_print_ctx));
 
 	if (!ret) {
@@ -962,28 +962,27 @@ static int page_owner_stack_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-static const struct file_operations page_owner_stack_fops = {
-	.open		= page_owner_stack_open,
+static const struct file_operations stack_fops = {
+	.open		= stack_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release_private,
 };
 
-static int page_owner_threshold_get(void *data, u64 *val)
+static int threshold_get(void *data, u64 *val)
 {
-	*val = READ_ONCE(page_owner_pages_threshold);
+	*val = READ_ONCE(pages_threshold);
 	return 0;
 }
 
-static int page_owner_threshold_set(void *data, u64 val)
+static int threshold_set(void *data, u64 val)
 {
-	WRITE_ONCE(page_owner_pages_threshold, val);
+	WRITE_ONCE(pages_threshold, val);
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu\n");
-
+DEFINE_SIMPLE_ATTRIBUTE(threshold_fops, &threshold_get,
+			&threshold_set, "%llu\n");
 
 static int __init pageowner_init(void)
 {
@@ -999,17 +998,17 @@ static int __init pageowner_init(void)
 	debugfs_create_file("show_stacks", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
 				     STACK_PRINT_FLAG_PAGES),
-			     &page_owner_stack_fops);
+			     &stack_fops);
 	debugfs_create_file("show_handles", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_HANDLE |
 				     STACK_PRINT_FLAG_PAGES),
-			    &page_owner_stack_fops);
+			    &stack_fops);
 	debugfs_create_file("show_stacks_handles", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
 				     STACK_PRINT_FLAG_HANDLE),
-			    &page_owner_stack_fops);
+			    &stack_fops);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
-			    &page_owner_threshold_fops);
+			    &threshold_fops);
 	return 0;
 }
 late_initcall(pageowner_init)
-- 
2.43.0


