Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B407BC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AABEB6B010D; Thu, 23 Jul 2026 03:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C8C6B0110; Thu, 23 Jul 2026 03:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB6F6B0111; Thu, 23 Jul 2026 03:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 605DD6B010D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:50:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EAD78A03AD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:21 +0000 (UTC)
X-FDA: 85019268642.07.B15EA8D
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf09.hostedemail.com (Postfix) with ESMTP id 49818140009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QUT1DFGL;
	spf=pass (imf09.hostedemail.com: domain of 3usdhagcKCCsQfLZJHZNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jyescas.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3usdhagcKCCsQfLZJHZNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784793020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rrv5x+4mpVYYp8CMRoch1CZB0fcAbFjciupWA91d6dc=;
	b=7T78Wbz+rcUoE2qzy1iDXSp6ZqzBt29e/XPLQcuj0X+uB1VgZDI945IWvD0D+KjCmMFNSa
	SQhB+Mw3DSTVIuOoHeyxHIrgfJxvEZJpK4t9meW5FpvG9elU0We+f5tlqBN1SRjMzutEdF
	mFJ9YKMIUK62NPNeZ7JzjSs4ChdaOZw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784793020;
	b=c4gR0V+u5GerwRdI353kjKxoAKc6fJlPanZCsa6SUT0ukl7s7ucYesbibBluuDwD78J7hH
	KXBg3iTQQaNsot9THnw3Byr1MqlTnddITSQ38sPw37PBgoNAx5LoQZiJT5ZZAb92Vfej7d
	xAeKocLC54Ggz8ju5J15ZVwkm8B8dI8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QUT1DFGL;
	spf=pass (imf09.hostedemail.com: domain of 3usdhagcKCCsQfLZJHZNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jyescas.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3usdhagcKCCsQfLZJHZNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38dde0df80bso753529a91.3
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784793019; x=1785397819; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rrv5x+4mpVYYp8CMRoch1CZB0fcAbFjciupWA91d6dc=;
        b=QUT1DFGLvAV6DK4dYaYJzlSw4yR779csjQ7chYhW7c8EpDJiMQKuFF7ozRrE/R1mYj
         HP16ZxrL2tLcPjxhP5XaYZt8OApAzOHe652x21MhKKV/dVohi8yktyYMUKDEup9N0Hdu
         +Fm8xiWJBFJixnSOGLiXeIfdjTfvV9DgAxB3dHfq9C//xlhrrRPWAv8nHfQsniPW5yJM
         Hd0o5SAnFFFh5YVas3zAbFsHKK3+MXzKVPp9/qTpEnL+W2X2rqtYo0BcVsC1d/eU/ZKw
         Jnzx2nCDir21UOIDrNAuyBJDXKPpqlxSq3L0uPZD8UtE+Gz+9adzjcxF/x9asGd8f/EF
         dnnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793019; x=1785397819;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rrv5x+4mpVYYp8CMRoch1CZB0fcAbFjciupWA91d6dc=;
        b=Dj8XgpK8TfleDAdYwMQRWgcqk+BcxSWCmwKkY9O+VlUGPnOgkxGODA4abNB1VEb6sg
         eXGTTCAiVcPgjCYQZzF9HpAqxdiJ3rSeZqA1CeNYxNrjevGc0pVeYtIZEmCxWNEDZVKo
         3acqre1fmDGKCCqPDjxqW/WpUPKrrTUGeH2G0gmHL1iLcFu0OOOGQYDeoR3geFbAwHwJ
         g5L/efhOuYxE/CmC4VRLw2pLXVOrwdZg3DHdMvUAW/tjGkk7I6tha1LB2WU/vkuHuWP4
         OE5Bnos2iSzlA2yd1No9o7fvWtFSD1nVYSW/N1uHnqfwmGtWTpgAExZYPIL4aEDqyNmG
         1zRg==
X-Forwarded-Encrypted: i=1; AHgh+RpCih6vmAPYZjPJWJ+3kShXPCyiydyI4kGvN5xcpmVpuGmslYjxcWHgNzORc8Jgy/jvAmqOmllUNg==@kvack.org
X-Gm-Message-State: AOJu0YxcFJ4n52Nw8Z8GhlVGzyG81d/TkdAuyqFfQ0/mJ+KpZh2uojj7
	8BS78DmYKl1wZBotQUx4pMEuHSZWesGckr+FhCIYbioz0Q6JQLl/1Kw6FzvCjJMgws9540/jaF4
	Ed71VxVFsHg==
X-Received: from dlec12-n2.prod.google.com ([2002:a05:701b:428c:20b0:13b:848c:abaf])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f06:b0:38e:adf1:5b03
 with SMTP id 98e67ed59e1d1-38ec6665307mr2164293a91.35.1784793018950; Thu, 23
 Jul 2026 00:50:18 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:12 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-9-jyescas@google.com>
Subject: [RFC PATCH 08/16] mm: Define function that creates the
 "nr_pages_allocs" file
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49818140009
X-Stat-Signature: 36xwhsxtd8yujgka5o6mccm5pn89qo5y
X-HE-Tag: 1784793020-116304
X-HE-Meta: U2FsdGVkX18kdyAvurW1L3ztHv7xW8LO35XVJn2UfkkNtKoaVjftlLziYzwHdiTAENDx4ZYcXahYWUknBl4c8rrPhy/gt1jis3lwI+533luXau08fFk+n/ghCXpFA5eix1m10CC0yxrDJeWtmX7E/h+Rg4Z+Ya8NTSZQFU/Pq1XIt2iY7iJbHr6YMhT8UPWLeAldESCXBMTIkxs7aVBVd22lD3WuJGbLpj4rZ5dTfeg0rXdWQPUXHE9mzyoVhPdHwx/CZGMwV6OKJZgIiOW1VsCJPYMcW/eNBZCq0+OPVHEJ39PqzlrjZzHpLVGN2tAU4s/Gr6a2qZK23HQkX1Syjg1RzC3NImLsRkannifhbu7YmNWUtCYZmdt5i3eWz/cv7kTFJ1qagrLAqVfuLHJzXBUE1pVStTFMrLDFzPCcH97deTCdSbukDm4JRuMtT6XFM1sqtV9tT4PcFOIjewpBmQBCMHdE6LRbGR/ig8QBMZWgcN6MWI2Si8GQrG5G7eZq3XTA6l2/BuVyz9/PteSO5Qj9MdnjA3FC8mtkPwi3EMPfCP0J7XfmpGzIV71ode5j0ESgshCQtuuwk4n+CVUugASBXKRO5zu+Bbb4kulX8Bc3uyJfGEiPfbLbqGLGKKQ+EWHtFa12XE5cSu2+lQHKiwIEPnQ8t0VixqL9Yp3pkQrYARxdBmTvlrg40O+YpR2s7HAwO8K94dsoWbojBdOMHEVDgvplVvAYhJ29Kx5rzDENuxJnT9djk4hXgclzqZk76YYxap3brk2Us7Gx+QN3DtERjgBgHVjr4xOrXfFbjOZnjxQwJxsQ7QLhJbDX3Cuhm8idkF2fdgf6HsCRktJRi5UYdUm7lkDiLlQZlZc9rZ8AZK+2ijMDVeO0Pk5rIOQ3pIEszYrF4evIoZVmxl+odnon7TIve1ontkf4BHx8TK96FTJDW2oAMYLlm+7STPV27YCKJ0RR9YOUggvG/NK
 EHd4aC69
 gioVlPihaHAp6E7Zrrt3O4i5NLVQdoFB378P5U6VrG/3TOCkTnO1L9K3BvU8m5QvOW9EJLac7sxEDZkKgcBv1FmQWzeUl2QMdeOBylr4dIof3uxPrunxRCiNxW6YYPWx7ub4YJNA4aqJMs0Vr1C0diTX0MHHD9DQdpAvqDzBv0H4lZTzhLnTK6YUd2bqaJu4KukTqW9qouBD4P44306I+z3FPmjNVzZZ36+GxLafjNRsEu2IsE5TYNkjRWjlp1TQrgH0nGfYGjvvCeOVyTqF9jb70dyWqC4d76GUX5IV33sYHENaekqZk3eL4lK6OAZVf9XeZWs7Mif0O182VXvSIfp93+PbLMiFnZQA5cRmpQliMA2kwZYUE/8UvsqfcoXSeIfUJC7EP0izG8e1R+dHRsOdcRNlKgnQX+jJRwlyRsDpiX0bmcXOggyEyS7QwKgzFUfiRBG2RDC10E5hBWMIXCa1vS6qu936D+lfq0KOzGilkQO3ylB5B2gPnSWZPdXiOr0wvp4ucpFFbTzCg1yf4UYW4YhbMbJuAci+Kj3bc/JJAoBtzv/kV4zJUDsMvscbZbjIsGxwCr46rVtWI03L2BTiBhV/7NqKJmdOurm6+jSlYXFgsvjwBggvTBA2HltZBLvlVMTk1y+Zl04XVEFmLGBr2TvP+cYiE5E9+QUg9+1cBQDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change implements the function that creates the
"nr_pages_allocs". This file will be used to make the allocations.

When the user wants to make an allocation, it will write
the number of allocations to this file. For example, if want
to make 56 allocations of order 9 in the Node 0, Normal Zone and Migrate
type Movable, we execute this command:

echo 56 > <sysfs>/mm/node-0/zone-Normal/order-9/migrate-Movable/nr_pages_allocs

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 58 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index a727c4f48ffb..3ffad74a0bdf 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -127,6 +127,58 @@ struct page_alloc {
 struct kmem_cache *req_alloc_cache;
 struct kmem_cache *page_alloc_cache;
 
+
+/**
+ * req_page_alloc_write() - Allocates the pages on the requested node, zone,
+ * order and migrate type. Once the allocation is performed, a file is created
+ * to free the allocation later.
+ */
+static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
+				     size_t cnt, loff_t *ppos)
+{
+	return cnt;
+}
+
+static const struct file_operations req_page_alloc_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.write = req_page_alloc_write,
+};
+
+/**
+ * create_nr_pages_allocs_file() - Creates the file "nr_pages_allocs".
+ *
+ * The "nr_pages_allocs" file will be used to write the number of allocations
+ * that will be performed. When the allocations are performed, a new file for
+ * each allocation will be created in @migratedir.
+ */
+static inline int create_nr_pages_allocs_file(struct dentry *migratedir,
+					      int node_idx, int zone_idx,
+					      int order, int mtype)
+{
+	struct req_alloc *req;
+	struct dentry *nr_pages;
+
+	req = kmem_cache_alloc(req_alloc_cache, GFP_KERNEL);
+	if (!req) {
+		pr_err("Failed to create nr_pages_allocs_info");
+		return -ENOMEM;
+	}
+
+	req->node_idx = node_idx;
+	req->zone_idx = zone_idx;
+	req->order = order;
+	req->migrate_type = mtype;
+	req->parentdir = migratedir;
+
+	nr_pages = debugfs_create_file("nr_pages_allocs", 0644, migratedir, req,
+				       &req_page_alloc_fops);
+	if (IS_ERR(nr_pages))
+		return PTR_ERR(nr_pages);
+
+	return 0;
+}
+
 /**
  * create_migrate_type_subdirs() - Creates a directory for each migrate type
  * inside the order directory. Once the migrate type directory is created, it
@@ -138,6 +190,7 @@ static inline int create_migrate_type_subdirs(struct dentry *orderdir,
 {
 	struct dentry *migratedir;
 	char dirname[24];
+	int ret;
 
 	for (int mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
 #ifdef CONFIG_CMA
@@ -153,6 +206,11 @@ static inline int create_migrate_type_subdirs(struct dentry *orderdir,
 		migratedir = debugfs_create_dir(dirname, orderdir);
 		if (IS_ERR(migratedir))
 			return PTR_ERR(migratedir);
+
+		ret = create_nr_pages_allocs_file(migratedir, node_idx,
+						  zone_idx, order, mtype);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-- 
2.55.0.229.g6434b31f56-goog


