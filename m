Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D98D7CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D351A6B00BB; Thu, 25 Jun 2026 22:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D0E6B00BC; Thu, 25 Jun 2026 22:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C499A6B00BD; Thu, 25 Jun 2026 22:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 989B56B00BB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:46:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EB1A120320
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:30 +0000 (UTC)
X-FDA: 84920525340.05.FC018F7
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7323340007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GnQ4UHJd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782441988;
	b=XjWVv30wY8gEFjyNaM17oIsd8xeFy/we9u5v89lkeFeQ8EAjs/cGlbuSj6xxGMmzceCO0v
	Gt17bhGdIkw0tBuYlUYPux6Z+Hr7iY5AFTY1duxupUOAhogK9E9Iv3s9OxpHqjSc6JQxKq
	USx/hQir3M+WP23l+QE+VGbxUxvOfis=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782441988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=suDFp7risggw2rtoydgo2giehAA74W5ozQAmjOegSsE=;
	b=RgAvMqzgy0kXzmv8If5M6TFPcNpI/jf3f27qEWxegzIHyE9GeISyG7SNNLl886ZLHUQv/N
	C35jjino6DFVwScqhqqILDWZM758SU036l0qGScOQiibeDs9j71O3wdx/UpQMOlzrpSWlC
	z1XcOW1AGZLE0Y0aZ+TXRBitmC5jwoY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GnQ4UHJd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782441986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=suDFp7risggw2rtoydgo2giehAA74W5ozQAmjOegSsE=;
	b=GnQ4UHJdgwwrsGf6BxQRrLYeoKvUTPB3tRA3TJpJsBqXXcW5YlL1dLasdTHj4DvvVixGjw
	OcRKPM8Qi+i65ld74FbFRBwOkJwODDO9IN/ofSDa3roHGPRqa6ci4ZSJ+vCTB3igCRuqVb
	RubKS+uHZU5Q3embfL8+xRFAvVi/CkE=
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
Subject: [PATCH v2 6/6] mm/page_owner: drop redundant page_owner prefix from static symbols
Date: Fri, 26 Jun 2026 10:45:45 +0800
Message-ID: <20260626024550.25677-7-ye.liu@linux.dev>
In-Reply-To: <20260626024550.25677-1-ye.liu@linux.dev>
References: <20260626024550.25677-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7323340007
X-Stat-Signature: e1yq3xyzkx3r3ofrhwukc4bnffqijjja
X-HE-Tag: 1782441988-191435
X-HE-Meta: U2FsdGVkX19n6gnyO1+GfSVrzxBMvsHQLkZpqXmqnWSJAoWLytYNeS+7KuMHnszCaK0GoAN0XDngNk+vyGCFiNLvlHtAJZ13ysBj14l7ow5MOLWCHLFOhVIYL/Z+erpeAcB0lNksS9FMjiYVDfETgIAlTAPuTos4TGTXBH3PrmvLK03ZG6A8fUYrrgXWu2lrUrc8w40PjzubI1tO3iPeoUGa8wz/DZdY6FiJjNzcAMJ6w/XHc1a1k01IzupRok/QiXiqT0R3m7RXaJ8XWft/yeiMHHUZKBv12t5PzA6RmjmcjblIGqkoNfkFTRXOJ+KCumzQArPI04PUmAGibvilczM2+wj7lCOpmRe8FChDh9LElLtIOGzc1ZQBz1ZlMhfqcxX1gZESj/Jzg+TfPdGMb6E05bXKSiSWmqPZ98vHotcJ2PgK1NYHH8qIe0xDR1sKGYGkT/JY5IGueiAav1siVn0iOZsQNAtX+wz6Yn1Ydksmou2OF1nTLlGQlgqpGB9r7QzNGkftM/3w8Jntn4AHD8fa+b+crcWbtGIL5jtsx9a+pX8hq3OHo9IoDsQUScZ7dRiHYUdbQxO6/vXBJYfL4GulmhM9+Qmgj0EC8gDU9FEBGwHcWmf9f1RGhq9jHhvMRwqXIJDGcOpPqT5GKTu+zqI+ktcjtT6ZxuxX8n2h4rXZP22etV7b6QPLTLoZBb7N/qOESuUDujC4A7d9aueuTHOIio8Ya1wOYKhUHqHzBjPMTM8imOfEAmKdy4hnGz0S11k8CtUwe9xTkS179aY15gRJlER4I6ln750QcDM1YxL0wzanUzScv0bvREF+msWd8/W3c2ns2KQ5vfxJIUOTH05463CzS7Ujfjs4N+Uz2B/ZtamUdO2Bfit8alMT2JY/SCD6fCHufwZyF/bw7LJMWC5te+6ywFIRjULslf47xANp7xfKhZeNn8SJVUjiEBSpHUHUDTqzKyes9ykvK8Z
 TSWl+Icp
 mspJ4qAS1EJsmXOEnyYm7G9X1guYY7dlxXztwoBmIBgCOkRGG4+ELpr62dsxHiAfhib0cVNDwFsNGdwSzoGJ0efuDctyW8WgoYCopThxBNTQbTXz4SH4wv+lLT1NfQN9wqDbeHJ/c8hAHdLlh12JO8eqHJsHvhZgWXwDA+5CRkZ9Cy17q70aVH8CA1aby3wpBSpFnD6CMPeDUxpGlkFsuizgNJq0amwoznRquPThfx1Sc5Jsp7NSjfqKYHA==
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


