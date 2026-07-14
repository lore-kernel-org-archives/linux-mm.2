Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32A56C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45ED66B009F; Mon, 13 Jul 2026 21:52:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4393D6B00A0; Mon, 13 Jul 2026 21:52:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374396B00A1; Mon, 13 Jul 2026 21:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1689D6B009F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:52:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94426120207
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:52:09 +0000 (UTC)
X-FDA: 84985706778.14.4B3AE0F
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B24B100004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:52:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c7lduUdd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hUCwkjzO8JlsV4HHcqpi2o/7R7QmnmDlK+R08kvU+c=;
	b=rwWFnakuCJ6mGQt3hxoAfMFH9oKOlWD6I/PLBLUdb0GuAAuOluRLG3O9PiNYy4SFR99xPC
	g+sQRALxuRWC3OWF1HqsUIN5N37o7fi3PZk+IJckeISKzBGanJdK2QPqE1KD9ysoxVH7pM
	0yExeOjH+/kXEaeCUc7YM+HTOc+vCIA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c7lduUdd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993928;
	b=kSn2Ln9ipfDWW/tgyntY/zL+kmih8lukjALBWNi0oB546DnJ9AWWdCyQfNPU0Qs5v4nGEW
	cEwSBtDlgSljurQHnuHeEiKhzYGoYa/7b0XzYDQcm4/pg/BnddeDyCgdsKEEcUFqRdskPL
	xnaTYx9oOAjzl7dy+HV/y4AtwU5LUKs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783993926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/hUCwkjzO8JlsV4HHcqpi2o/7R7QmnmDlK+R08kvU+c=;
	b=c7lduUddicEIKFtK1ufOalDWkjpj1e6uQ0u1KARNsdMvK19yMSiSGT2sZaIMYsO5FP6G8E
	wcbXw/8O16sW4mlSuRh1ce0CoIOioW9C/4EKp5p1Em1pS8PXs64yu8f0XJj4fNNIvDESdY
	/VkCeP/32yXCzDw3/2i54pTCqTU+t+o=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 7/9] mm/page_owner: drop redundant page_owner prefix from static symbols
Date: Tue, 14 Jul 2026 09:51:06 +0800
Message-ID: <20260714015117.78351-8-ye.liu@linux.dev>
In-Reply-To: <20260714015117.78351-1-ye.liu@linux.dev>
References: <20260714015117.78351-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0B24B100004
X-Stat-Signature: gyguo1fx3wd88h4a3aer3obumhz7ejfw
X-Rspam-User: 
X-HE-Tag: 1783993927-857259
X-HE-Meta: U2FsdGVkX1+Gf5WiJoTW/hULpei0pgJDcuGpCJCRyg0piou3enbw+omIf4T3NmR+0DB5b3+TTSyCGAaw6sDMWUBVkX3hKJHNwqd1eo6n25KmKZmkx6Og3gTWrdZTUZA4KLthEOYmPxbzwCUbJV2gnfm8DyEarJLTEHnngj0m+i7R6f2mz2EpwLWQn97BqH08PoJFQDZbFT2la5B/TyLOVpHqNDvlq3SGpY5SiYfDad5E+CCbmPCD1qJ/jaZGs86uq8h6Yc0+Ox7q9Cmg11h76dJGB9t9Go8+8uoK9t+CkvPGMJQyCoK/hmeb7MAPJbb/q7oDyRvuKoZ2tZPMQQOW7DtCiy/VHxqZtjCp4RWRRymKrUnVwO4F1yjHOljBK+NcgIwGHQs1C/ymjn7HTKQcPZPAhekYk1v446kB1AdD007JwE2dC8mly/a9qggwanCSoPxf6IlqDXsjBIiPiWSXKnwCwg6SCO64pP0wAYOx8IfrqQla8/UoYOjW6kRZ1739h+9wIPLjYuYNW6BnLPn5levBztD+EGWaqIM9yv6XPxtF9egSDu4HOv0oBNhynmR7JVlKCvufa2E+pYny2jpIC0KQ826mmw69uWOSenZrvJjZGU9lkOUbndjdBb7rsAVX7bpwSJo3qggxIv3EPPRQsQdD942QqpFq9MObZm56IiLeQYs9ekzmeB5M5o1cYPA3u/RqYb1qW5Nui8HtJiEQov8CaX2KY4Nm/jJMDbCJl/xTlECdizRb6u4Nw8J5pZGKX8cCG5QF7g/KlOd8+vcBtdvpVm5p/5XcbEEiSS3C1pKwuqJv6TOeoGRa5yk8+NPkzCfMLVMaqBGcFfKq4Jrbyjr8SwN593zn0GnMGjx/AwF9KBPddXGnA/9NJYaiS9lOr4VdgHIRlSlFGHiRsZbL7KWhKJqfohZkihkMbv1nzQ3sQ+sNEzaqH7fTGmKE2hwwS4mwVHEiw1Sm3IDa8sd
 h6ylOaVu
 /btE/u2LOiiezFfvsu3+MXjWbtZ7rj2mC/jm7y+hXrfsCfxl9VeJpFW2jYAyyuQU4hCD0u2lK1zI8eN9+42I4SPAe/YMPWITSMCd/a5URmj9P+T7pb3xMWUtqeR0IxgvKMs6mWMBZ+Rfe+FV48ZpQmFuUknQfywNn7oIELL/JCORwac7en+tEakf5a1s7RgiH4eoZJHU/UrdbqFbkhbD1j5sEukTf0zMrb/NSTVgfOg2Bx6VFnsQidQ2AdbCfUvnvkzeyYPQm6K0+zmJp0FlMZfqop3ZMEH4ztFN5B46bvOHCOxQ=
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
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_owner.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 84eb44459478..46a933f9c229 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -894,7 +894,7 @@ static void *stack_next(struct seq_file *m, void *v, loff_t *ppos)
 	return stack;
 }
 
-static unsigned long page_owner_pages_threshold;
+static unsigned long pages_threshold;
 
 static int stack_print(struct seq_file *m, void *v)
 {
@@ -911,7 +911,7 @@ static int stack_print(struct seq_file *m, void *v)
 	nr_base_pages = refcount_read(&stack_record->count) - 1;
 
 	if (ctx->flags & STACK_PRINT_FLAG_PAGES &&
-	    (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold))
+	    (nr_base_pages < 1 || nr_base_pages < pages_threshold))
 		return 0;
 
 	if (ctx->flags & STACK_PRINT_FLAG_STACK) {
@@ -933,16 +933,16 @@ static void stack_stop(struct seq_file *m, void *v)
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
@@ -955,28 +955,26 @@ static int page_owner_stack_open(struct inode *inode, struct file *file)
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
+DEFINE_SIMPLE_ATTRIBUTE(threshold_fops, &threshold_get, &threshold_set, "%llu\n");
 
 static int __init pageowner_init(void)
 {
@@ -992,17 +990,17 @@ static int __init pageowner_init(void)
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


