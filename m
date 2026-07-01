Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B8E5C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA196B00B4; Wed,  1 Jul 2026 02:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1746B00B5; Wed,  1 Jul 2026 02:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D74B6B00B6; Wed,  1 Jul 2026 02:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4052C6B00B4
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:12:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCA02A0223
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:12:00 +0000 (UTC)
X-FDA: 84939187200.14.12A2DEB
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2D89B1C0007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k5VcqrXm;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782886319;
	b=zqX1P8uFMnQ2V06MlKf0OgKMcaagEfQiwC83TxyBm63NebpcR4o9t+pOFj2ZtWzpOPRSR/
	dh+KU7KItvvQ2LFd8v8U64oMHrFHauwT1s9zEkUs7AwN49FRd1gKygowxF/9s7oxC9bYYr
	6gpu8QMRSxS4LxOxxDeZuSxo7CXfWgQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hUCwkjzO8JlsV4HHcqpi2o/7R7QmnmDlK+R08kvU+c=;
	b=0NXM0YxJKWheE9VyPAKdv6HxgkF4QVtevMRQ3pJDn1jLA8/cj4b+9tE0lz0cCaNG88qHC2
	aL4LjP8hWioLNt7FBcBMxCUQNQjkSt2lRmdZQ/DXMfjKEe+ntThLhY5hdO4vzV5rAfMBVq
	pRcL65dzc0Kzjf0XNdxAtcYjyQZtFCQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k5VcqrXm;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782886318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/hUCwkjzO8JlsV4HHcqpi2o/7R7QmnmDlK+R08kvU+c=;
	b=k5VcqrXmd0wuiaBd7ziMf067Z8REaxpdhVgQmQ8m8pZbrHYIxcJnSdxwcvRUwuL7wqkXiU
	ce9ffQfetL/rgOS3IDcpTMu9nXsbWg9pbyT9bOwRsLNmISZvy01+QLoQR42q0AJ9I2qbxC
	f5RNgEah/OtehhElvOWbDVLwphsi3v8=
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
Subject: [PATCH v5 7/9] mm/page_owner: drop redundant page_owner prefix from static symbols
Date: Wed,  1 Jul 2026 14:10:50 +0800
Message-ID: <20260701061101.344679-8-ye.liu@linux.dev>
In-Reply-To: <20260701061101.344679-1-ye.liu@linux.dev>
References: <20260701061101.344679-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2D89B1C0007
X-Stat-Signature: bwfn8an1jfr7fzcthgyb3c5yo6taqd83
X-HE-Tag: 1782886318-98040
X-HE-Meta: U2FsdGVkX19zeA19wd1x2GzdavENGR08SskT7tXpsy8z7B5dTRdjqmyv7Ct3CVyrVLehug6gRVzhw30AauuOLxMGdHlBieQzIul3ueOtxPzUEix0qAMJvPLwyqC22sDmeKsRTWOAbCFLege/5TtAb1TlMZVHpzUAvQ8IEpp4CvD+wyb04n5ROu69DSP+YdrZakyyobE4g1bcBl9numZfVLnDNU+4czgvsY1YkVW4wiYTq2wNzKMNRxlqsU2kiL+T2NEP0HpHWqKI01pb9SSty/Lrv/4xPOTnxxzuFuKGtiFlR3ilsCP8JD/YRTFqN+Chqyoc728CiAkYH4OEBftZaw1GssI4jjT3KlAOss6BM8nVl4ZcGpT4gNk2Z7kOt3+a84SiMicoqTIgBczgSg/u2js3NsYSbldUcntpH9CwYe44wky97jwq4F/uvoce1Z1kHBxcfhQdnrQbwndupyzU0UPOdGOdJF+P92/f3WWd8/wCYms1iqhX8pSSe6woAfYaNLhGpxkmyu7JQ05wuBDILdweYUsJ+Kql7pKujsKGf53Tl2pATyydPqrreXJ6Df9VE8sKQDPSLbkMkMi4MyzHKpCENrcb08nq8f7n2kuVbwXfbTZbMZDEfjVJpg/pGRcBQMEyqO5uNqQbVGfN1Pubj+kJajzmoT9tA/PCjGEwrfeaPpmphLcJavpl/D3pVwsRMED7ftuStZeJqqlNwiZU+7IuuFqz5xtOS1uJGbkgbqSlsD+/Fuw7ofIukPrwb9jCh0pBomOFyA98IiSU5ueYbFqNLqeIoiDTsCSgSDaNlHKDhHdyY8vn/t0Ge/14LGeGkLPK3X5+ssKruo0B8yQrxB7+Zb3Bn2HSbrDinzr9gI6DaM98UwlAjsEhGimvbMI9rzzWubxJ62cfLtzDPQoI08J0voZ9vNsnFlkzYDECF6mZTH7q9iloWkCBkpzLy8/EHZgUutiBtg1XTNLDsSP
 Dum8gKWe
 xlkphEtsUXdiQFfiNXb9l2yre4RwM/Akw1i7s+ofJFT0nOwOOWHai7b4LkruXJfLbUH5zmjE84RKLgyYWOzCLHIxAEFsH99agtgrIITdDa3PVJ/VvlyUa0SeSmDLy9vS1Me7U1tTwCn+Fras7MsoToa+KZW6bb/JrV9kwlbHTN3OQtJ94SZovk6dATxOsnm1rlM2oUWuhci8Wh4ANaT4Wp1dbELtEMi5TfbiZAY0FCBmpYSX3MXCog9rpSf+VtV9LQCHYGGIVAGcvWYZlrLFwsxy50wvrt4erJo9GZLs5mCKLOWk=
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


