Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 198CBC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE476B00AE; Mon, 29 Jun 2026 21:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68D876B00AF; Mon, 29 Jun 2026 21:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52EA86B00B0; Mon, 29 Jun 2026 21:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EF526B00AE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:54:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92D491C690B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:54:17 +0000 (UTC)
X-FDA: 84934908954.13.0DDC875
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0810C80003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:54:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DYz0PbzW;
	spf=pass (imf30.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782784456;
	b=nl9ZL73VlRL3UBiZHzPQJwDHW7rdUD7AU9aZJ5oghbI9/T6dQ2uvhbQY0ctyLmtI5xpWsO
	YipV35JjZYgimp3jSflEwym4N+F3k2Z3Xd46JuB+RXZ8CXRDMvnlJPL5fRzCnutgkkMEEj
	cbbR+RH4DeHVgMhlUBrH3ijX5cSHqaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hUCwkjzO8JlsV4HHcqpi2o/7R7QmnmDlK+R08kvU+c=;
	b=6KDKOfFIOlfwseoskmGqQ6biYV09Bi9+Ih9A/KjUzKQaEs8BGhyO5v+tIBY1fiHPbgcWOH
	FSrIbmnXl4VL/mBe7TEaq9qyujGJLOVTYh7XMCI9x3pUX+mcbH1y+rqG28I4lXUtIv//pJ
	F3h6LRMTAVJcxoFRSSCNJK0IEA3Titk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DYz0PbzW;
	spf=pass (imf30.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782784454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/hUCwkjzO8JlsV4HHcqpi2o/7R7QmnmDlK+R08kvU+c=;
	b=DYz0PbzWsvM03L3LLKX12MieEPu/o4Xv6fXc/yHYEgf5KTlkEIG9CNnHubXK4YAMKppAO7
	vfIW0oJOcuJMCEoq9mHijuO6ld8w2TCsatGFIDySApKg6pvyIbQT5ZO9M11FfUHKdEIm9p
	gbXdPJNA2w0N/9upNWhboArd04vx8Zc=
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
Subject: [PATCH v3 7/7] mm/page_owner: drop redundant page_owner prefix from static symbols
Date: Tue, 30 Jun 2026 09:53:24 +0800
Message-ID: <20260630015331.147174-8-ye.liu@linux.dev>
In-Reply-To: <20260630015331.147174-1-ye.liu@linux.dev>
References: <20260630015331.147174-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0810C80003
X-Rspam-User: 
X-Stat-Signature: jxsuqmhdpcwiycptpfnd99rhkr9iy6an
X-HE-Tag: 1782784455-922623
X-HE-Meta: U2FsdGVkX1/nRkWm4QcA+CIYEQX7pysqyBcqM3Q7jMtjvM9O33oigeI3HKezZ/WOoXakpnNiGnlF/8NFSIM8ajPl5tC3pWKTVkebsk//h+NxDM8c9d/JCgWZhqlIPyl1ZpEl/+nKsfeHjg7AWH5I0G30QgH4ozOf+AKT2cP9Fd5iH0/cYOjgbaIGurILX5GSWDi+9lZ+kbOxPef8MetR3QBmyLx7GwqwqjiooTq0cm9HmBXdrMZE6w87uIIzFjSpiZT/L6y120DfsEO8BJrZbU5+47iVCDA69Mv10njZGVEX52CVlSP4Y7huBSQ3QMGN07gf+V6bva8FrTKfMkhbOmOFSz+dJ4NhMCLKVkUc1PanmILxXrhEWukMetxbWm8cCsv+Z14nPgNN244R7dWDXrQ4jyzyF93grXZgN96tQKmXnat4qNvboL+Tge8PCOOKv8ukdRacxGGVQ+NBxXVKBuIId01GuV4b80zk03rF9KexF45F7uUp0RbLMvtlAbhZZE4vIvzflsdguKpZ6b0TfXdj0T/8aQsOI3jDeRFjCvd4goDsraLO/JHgYC2QPod8QgnprDFBpO1Rok8eDZF+59C/crSnD2UQ3IURz0g+DZAqlQOCQT8TaG8Ge2I3VjUtcftNuX4lNFWo/IfkgLpurVRLC80wGQj+6f109BF5tFaBnO/zXIQFeMDM0FNnaU1yvcsU1oXaWFeASsMslDMMmdLVyPfbEGyyVCSW+rLym43+W7XJEvZj6bkbXrZd+hawmqErUXFG4/LTX5zNreYRhutTgeUFMIAeMxfpC5VrAx5/lU4qRDwJjLDd+UUAPyJQ43pgXfvJvs4qGGUAc36cP851VLexx0GdlZNOjDwk0LaXQVT+FPfvfVS6M44lZppSAxqHrmaVUAP+awYySXFli9hC7aPzfMQPGq/1o3G0KkwKa31Zc1iXzDYaepadLy6/aWtAw4BiuEp1Ms+1vrK
 WNn6IqwY
 3KTlrioTH9FPrRhf3Foqx5IRm12fG1Cp2ivMauUUCSGekG1O4c+H1HPFeKUOkSA2XcNm9XpFqgVdVhScPKMbh7etxsAESzPAURY59inU/whdOyGfCO+98Ooe+8UxSBUrZMyjaBauVZMkavYGyW/ihvnnrbYm7+cxr514QQOvW1KJK0XDz8W2RXjf8BbHw5nnRsuiWyNZFheCx/zYP7epr+r57q6gYUx8eMaPKoQwn4rpfwYhrb7YVtQhqxKTSfUrVUl064ab+fbkIKzlbxttGjrk8zuC3mYWjHsPnzpUeI/RjUGY=
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


