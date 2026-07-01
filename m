Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 554AFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48FFB6B00B0; Tue, 30 Jun 2026 21:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D266B00B1; Tue, 30 Jun 2026 21:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32FF36B00B2; Tue, 30 Jun 2026 21:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7A46B00B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:23:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89BAE120188
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:23:37 +0000 (UTC)
X-FDA: 84938460474.22.03911EA
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id EE7A5C0005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:23:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RFUnyybY;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782869016;
	b=ypXcGrwRPkq5XcMLuPfpyO8nhACfW8CU7zsYQ6MV4tETTa6c20vbBO7kE/o5p2+SjhKXs4
	hfKZiTsETN5rP4mz8Lk1cS9tHoq93cNcmJbR0NmLPkHvabLNW/MrBfiiocHyOg606HKBgw
	+925QteOtpTrRsYP1IF/NsYMrQP47iw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782869016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hUCwkjzO8JlsV4HHcqpi2o/7R7QmnmDlK+R08kvU+c=;
	b=gJf0QnS8lMc8ekX2KJJ0jJlCi9bRIwZqtN9lDywTKY5jSSbtdHGlsdBlAQz+hhgucIfeQr
	KtjJlbefnvi5jd3gQ9Ju/UhMbntUESrB6YeLrc0R6iO5hgPLNJM8YEv0Y5yPZVHyKpF3bB
	dDpxxcJY+G1nNk29M9JVGV90v4H7uTM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RFUnyybY;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782869014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/hUCwkjzO8JlsV4HHcqpi2o/7R7QmnmDlK+R08kvU+c=;
	b=RFUnyybY5cBKFMBKo2t6dLsRz6TC7CcGNjWDFHzURxiNcVo3Qe/vyMnoKfk/4/ghXkSEUN
	vtmWD8l8Vg6/E9RAQQh3EJX832r7kSR1AT2y0CBtGoneOx810u/xHKx2URIWOLWLpUYe1Z
	XfzrN5FuAAcG6yXfeyC86sdxgzh4MbI=
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
Subject: [PATCH v4 7/7] mm/page_owner: drop redundant page_owner prefix from static symbols
Date: Wed,  1 Jul 2026 09:22:33 +0800
Message-ID: <20260701012239.315262-8-ye.liu@linux.dev>
In-Reply-To: <20260701012239.315262-1-ye.liu@linux.dev>
References: <20260701012239.315262-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EE7A5C0005
X-Stat-Signature: wzf3698g3bcd184j7p7hunh3pankf8n6
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782869015-48123
X-HE-Meta: U2FsdGVkX1/xkUpMqNjF3ZlAvTtbUFNDV8GZjuhiISsCHqH6q+i+b1w6DCDRO189YCMHqbw/Kqh32hVHqBG57dEvAu/oOigW22ug1axtXr7RrCgKv6X8dHjQ/fMdVWt4cIj1IQVHBw7D/mGhWKMGZsNGXQmfTUeLD0EHDjc9WHRd2DodfYNAQg/PMEYjmC6EUGM+ATbi8ExROSLYu7tXdo4S2vWzeVEMliLX5EiGZTW8SA3Kt7NYSPzXzv5FZxHK+QfE2UtiSMeNaHMO1Qf59Zpaf6c28CwuKRsfoRCh2Mwx/W+qXlbwadtVTrPYVy6wo3pQLEt04h3I5ojp3Pk75V3k3GP6KIaTHLc7rqmNZFbep0MZBW/WXbyP3tX60T30DCZeYaaJ/wAnpZvJVu9NZgpcqiKJl88Iz+q2+LqFKLsIiksXQE96u/2uXtDNaW7yYzPK3OtWYakSLuJZphxjETMiCg8R9x1al+9LydugGO1fcJiLsMZ5mWGS1UTIRRvqzUnJtpJRYVaClVVLwEj670T3OlSU6W+MQJaMvOVhQkhogEegCAppMEYVhULqQhoOR2QLGS5bKErUiGcfkOPpA5yIYeM4ZTKHjRcDrvIXNcJTzjxL64PZVu6SFbg5V/kp08/U6HrZYsEnlNIlI3HQBs+MZb5FSoMAOCJj7X/Gpsm/dVrI4KlBzfuVGrtzh3h+h1xTI6PLquNKAdEoBz7fc8s9i+DOt+yus+TF6E8loBj2gUBP0hsfBwxK9NG1ctNQTQdtYrTM2HT29GpoZfuvxWXzDnigWTzfQJe7pThF++g8i0LTN9jhjec0eucQU+7N0uZKh5D+3cqb8rT9QsYo5xBQokpxzUeFaocuzgNM45ZL9tABo0W8QXS/G3jzC6UX/HlzZ29QwZvUSOm8X7XhMerTg5YccMuoz/nQHqxRVGOHt1niSx9Iwm3X3nSSiZUUaAAPWCfhp37So9xllaP
 tgU1YYxp
 ve/0152INvtTIS8jBWSGXE8mbbhS0ci6xKNX3lFN/n5sh49sulEVvEkxWonrczu2i0Dc4tfIDIDagcoKYEQEBQ6dZ6JbbpO9CwY/lHW71EAcBLxresvOr7K6uixwBtH9GJ2ek4vZoC3wXVz/caOTo3OCeYqvSgXOmiPTlNkm5D6Etxa679UBaTPSjEXr7OigKvJ+GSI2EX4dzp+n4KCqbRFYPDnDIKJn+QleVgdng+kHww+PVaeZSXgGZRQtsrY66/rEHHABP9sLsCHM++huMV4ATSqGdJnCMVduZ7mxMWABRmqE=
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


