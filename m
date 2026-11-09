Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB10606A5DB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EvTqzDfX
Received: by kanga.kvack.org (Postfix)
	id 72A326B05B7; Mon,  9 Nov 2026 13:25:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DAD06B05B8; Mon,  9 Nov 2026 13:25:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57BDF6B05B9; Mon,  9 Nov 2026 13:25:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2871B6B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:25:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B18D41406CD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:45 +0000 (UTC)
X-FDA: 85416409050.06.EC96F5C
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf06.hostedemail.com (Postfix) with ESMTP id E57B1180003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EvTqzDfX;
	spf=pass (imf06.hostedemail.com: domain of 3JhDyagYKCG0WcTkkZRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3JhDyagYKCG0WcTkkZRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54ExQeOShcGppfyJua980qoDBOFtyYHHsHDIcQmw4W4=;
	b=v3R606aIP94h8Yyhudrp/S+DFtHXfN64U8pVsnAMxT/z/LnY2KFJSgOKrMUO4iiDxvPJKx
	ie368wTzomWZamUCcyyhsHgFoCs3359ep9PhGAKTthd5dJNG6UZ/r9K627ji3gxh2AiVtK
	pXp58Fmf1XRjQZfgMlVD7Ze1kCZd26w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248744;
	b=SHtmOGTOmq/cuWQ7q7xXE7/e3nGLSRyq5MHVAuU8D02NXIMRC06V/80oYdO/0Sm3czyTkY
	SZa99I0gMw/3kgxAlF6AsDMBJWqJ+WXhha+JZGRNm/5FN1m9W3oZQn8UkPlA7RkTFPN9pH
	AgJqLy42nJ+bsvg4gHHU8Ziu5LG+UZE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EvTqzDfX;
	spf=pass (imf06.hostedemail.com: domain of 3JhDyagYKCG0WcTkkZRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3JhDyagYKCG0WcTkkZRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c4d58203e40so98520066b.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248742; x=1794853542; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=54ExQeOShcGppfyJua980qoDBOFtyYHHsHDIcQmw4W4=;
        b=EvTqzDfX7D/UnJuzp9Y4D7h29QPsAc+YwXbKuRpcdL1fZvrArawsVvnGMhd9iEEYTj
         tvRsM1MUmBhbEP0xu5BtQECST68R09OTV+uniS5yVkgYqQI1itgFZhNs9jezmu25TeeV
         koyLEbRlrb7GEGTpjIYEMyypX3ttb+NvbzPg/fAzXPChPAWj2urU0sMmWyNh+KFfYc1g
         LxiAgGGt4150T+SE2Jh6jlF8+A0PahBMJQIkXLnDyuYyu9+K1sJSXIht2pHxdPCal0fY
         Wd0G5XstREYXD2P1q1e9ljmGx+ItSfc250ScAI7MPzftnSJUlrMgws/ijIhduDW/eJfu
         Zz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248742; x=1794853542;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=54ExQeOShcGppfyJua980qoDBOFtyYHHsHDIcQmw4W4=;
        b=fLwgazkhGQ6MP3O+lR2BhwrG6rRdDiHXPsDDLk/s9T02DOs0iznxvj2YkI0Kv+9YPf
         UbwWchxxPVYw8wg0zocrjtPSB9MLn1Du9Qv2/lM4l1ASezV+gBP++Og/DonI2CJBQwOd
         PszrCSk6WkJhsyNl3uLqaDhs56nea0uWZ0ScwnGjh7XAf9wQYY3Jsb/Fyf99kylT0ate
         9aKWI7xcG1uFVO3mNZKXpStJEcGSl9ybJTCJIQKtTkZzc/6m9ts6wKVK/f0HVfQlZ6xJ
         06ktq/Wa9MYiiSjRtK+nVlziASUNLiXfIoNN37G1yIWzOD7Zp6BL9Z+SD8yNMVKYwQhq
         gHog==
X-Forwarded-Encrypted: i=1; AL+hErHnWLNvxGZcYNWBUfklznhMZ7tjs9LW3wKc33ajtln6+qbvbfP14k1OUP9xKse0w6CnfMJkXRQE/g==@kvack.org
X-Gm-Message-State: APuU4Z9Ppj3bDYEzBkQ8W8XFOR14srrDe6E3FLzxwyHBjMYQ8udzJUsZ
	H8TNOIeEkizpDWJhIbIBLJnBIh9YfLslpoGV66Vs5/y1ZTIdqr9IdThJi5MsUuiNdH8kQrocqDM
	omvnBBw==
X-Received: from ejblh15.prod.google.com ([2002:a17:906:f8cf:b0:c34:bb1f:3bc4])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:c155:b0:c2d:fade:e089
 with SMTP id a640c23a62f3a-c5048c88b3cmr21975766b.0.1794248742269; Mon, 09
 Nov 2026 10:25:42 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:13 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-6-lrizzo@google.com>
Subject: [RFC PATCH v2 05/25] iommu/dma: Add global cap and shrinker for PISA pages
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 5ex6qsispedr9jatepf35jcxoos5su6b
X-Rspamd-Queue-Id: E57B1180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794248743-62797
X-HE-Meta: U2FsdGVkX18dr0IbcdtCL5L2JkRTgthdgoKoYJFzvU6RMCQdC4TGX1dCOiVLiPdcLcAWKgK6BeGgfLR29U5gdIlqM/Mz9mUeUEKwLyA1+S4kBcTibE94YYoKYs266dF/2r8/l2KHQvDhnHn0HHBG2HIz3bGqylmPBLUxuDb/OxYDMdvtfLe9b6l6PDR3NLgNJphNrg2JBjvMaRxvYqcKMGxX26ZwNu4FPwrjwlIZ+4D25oBCa1Ji+NsphAZuOgHEbW1Wfz+OKtoUBbXc6ka1PGrBHZvrkRTjeDm64ZilJSTkLDaRQTfZDwU343N3pJEfd/OdIr38evW1EwiC3RS086R9t/0QN9Am0q1t0ksDWbquNMgEOa4zEWOVbHAjzEmg3k9rfWv4LNTjtCzlYaqXtN9768ukEOfQOmWd12PJYpYvmUcQ3HmlZMNv+pcqt0cM7LokXUF2SyxJdHsIIo2jej4cz+1glDJqTKsXR5Rbb7Xf4yAHzOi0pASq/iduP/0aXBEnHZIWgedP8TA9uJsI2WD11GXBzBdceATl4OCKjtJd9+J/D/9q5arSY9dZ+KbJfRgEeQ0m8fvwIoxI3+cbhZtXq8cv0bAhNREmKk3wFN49L64qKSyZt61hEi2vY6/G7ygggJUef4GsmIlsMt5/w3L5GVIcSKAJGxOnEGn3f2tXFwbnxLSzWCS2njS6n+WgkoXHkVvUvIOTKu0loFNGrGaesSLUTJb5cvcPU7kZ9cGmKzNx2tIF2+o+pIqxv9RuS8Co7Rgh14ghIHXJd/LBgiIP4mCc3Z5CXS3q/KjEA0nMy+tC4EZ31ijrV/SYAdp/0pNBBIiF0iuqI0C/pUbQuQcQYgpsL0YB/cNp2UeEqhjZcSejl3az3ItrZ3Puk7QoNR8Pfsrt6dCaPZhhvskj7O2POaVqQUu9bArZBWFFl4zYJq0EYA87fvoD225OqpJmdP0P2d8YZlCdl0AovZ4
 uYRPMovM
 LMT4ynqgMjHVi9WzNrMkauN6QVkrKAWXL1K2LQ1FxGLsAklhnMvX0LwtYqphJCt3/c08D1NMp9TGVZVURf1OCp16E3Ocu1nEZ0Jz2Q9Bs2tL0PwlEWgFFRWpM5QdwWrjFO6q1CCOCJd3g3JHMjhiuS5wzy/sPpW0yg24PCEBwFkLhBXzeu5wmjM+vfQY/+cjMgzFH2W186DNXsPfinf9/5MZnYkCc3fAKUylVCmMqRxz3OXWrrR6JcYm+VIx1Mw+TR/J4aErI8CS4vus9sgDso79FjazM9l//mtOEU5ZZbXGFn45ndHXZuT6r7iJhQqMCpX55SQK5ddePxGaGZN7P+XxeA1JL/GQPY2MAytU+/Y2RlspDLpPu2Ui7bRXHKmq/+ltQ+XwRppEHQI+rcpjkZ9YoJcVQV22KsgnJlFZ2I1j0twdpfNAryI936KrtuAow/HEGs9Ess2gzQ8L8lbnAB7h4TZ+Y+LMIFwzCBoMs0V4J3kAEWatqxvuPxlMZFGPFnyKKAPNs/SyhoJD94j05eTC3cCYXMP5WQivrOmf2iJc+lC+0nvCTXzhqHznTAjS5lMu93CqJd3mgSMV24WGIhRZ6I/fFyPQ9jGYoMOs8k8AdNOvdCKNaTDzwOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add two mechanisms to bound the number of unused PISA pages:

 - a global ceiling, pisa.max_pages, on the number of PISA pages pinned
   across all allocators and reservoirs, defaulting to one eighth of RAM,
   with a floor for small machines.

 - a shrinker that, under reclaim, drains the per-node reservoirs first
   and then completely idle pages across all allocators.
   Idle pages are detached under the allocator lock but retired outside
   it, to avoid holding the lock during the expensive unmaps/iotlb flush.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/pisa-alloc.c | 91 ++++++++++++++++++++++++++++++++++++++
 drivers/iommu/pisa-kunit.c | 15 +++++++
 drivers/iommu/pisa-node.c  | 25 +++++++++++
 drivers/iommu/pisa-priv.h  | 15 +++++++
 4 files changed, 146 insertions(+)

diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
index 1f1b99023094c..de8009fd6fff3 100644
--- a/drivers/iommu/pisa-alloc.c
+++ b/drivers/iommu/pisa-alloc.c
@@ -4,6 +4,7 @@
  * See Documentation/core-api/pisa.rst for the architecture overview.
  */
 
+#include <kunit/visibility.h>
 #include <linux/atomic.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
@@ -22,6 +23,7 @@
 #include <linux/pgalloc_tag.h>
 #include <linux/rcupdate.h>
 #include <linux/sched/mm.h>
+#include <linux/shrinker.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -40,6 +42,11 @@ static LLIST_HEAD(pisa_free_list);
 /* Dedicated WQ_MEM_RECLAIM workqueue, can run without allocations. */
 static struct workqueue_struct *pisa_wq __ro_after_init;
 
+/* Global count and ceiling on PISA pages across all allocators and reservoirs (0 = 1/8 RAM). */
+atomic_long_t pisa_nr_pages __cacheline_aligned_in_smp;
+unsigned long pisa_max_pages __read_mostly;
+module_param_named(max_pages, pisa_max_pages, ulong, 0644);
+
 /* Max completely idle PISA pages kept per allocator before async release. */
 static unsigned int pisa_max_idle __read_mostly = 1;
 module_param_named(max_idle, pisa_max_idle, uint, 0644);
@@ -81,6 +88,7 @@ static void pisa_release_page_rcu(struct rcu_head *head)
 
 	WRITE_ONCE(meta->pa, NULL);
 
+	atomic_long_dec(&pisa_nr_pages);
 	for (i = 0; i < PISA_BLOCKS(order); i++) {
 		block = page + (i << order);
 		page_ref_unfreeze(block, 1);
@@ -93,6 +101,7 @@ void pisa_release_page(struct pisa_meta *meta)
 {
 	if (!meta->pa) {
 		__free_pages(pfn_to_page(pisa_meta_to_pfn(meta)), PISA_ORDER);
+		atomic_long_dec(&pisa_nr_pages);
 		return;
 	}
 
@@ -688,6 +697,72 @@ bool __pisa_free_page(struct page *page)
 	return true;
 }
 
+/* Shrinker: releases reservoir pages first, then idle allocator pages. */
+static unsigned long pisa_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
+{
+	unsigned long nr = pisa_reservoir_count();
+	struct pisa_alloc *pa;
+
+	read_lock(&pisa_allocs_lock);
+	list_for_each_entry(pa, &pisa_allocs, node)
+		nr += READ_ONCE(pa->num_idle_pages);
+	read_unlock(&pisa_allocs_lock);
+
+	return nr << PISA_ORDER;
+}
+
+/* Detach PISA pages from @list onto @release_list up to @nr_to_scan base pages. */
+unsigned long pisa_shrink_list(spinlock_t *lock, struct list_head *list,
+			       unsigned int *nr, struct list_head *release_list,
+			       unsigned long nr_to_scan)
+{
+	unsigned long freed = 0, flags;
+
+	spin_lock_irqsave(lock, flags);
+	while (freed < nr_to_scan && !list_empty(list)) {
+		list_move(list->next, release_list);
+		(*nr)--;
+		freed += 1UL << PISA_ORDER;
+	}
+	spin_unlock_irqrestore(lock, flags);
+
+	return freed;
+}
+
+VISIBLE_IF_KUNIT unsigned long pisa_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
+{
+	struct pisa_meta *meta, *tmp;
+	struct pisa_alloc *pa;
+	unsigned long freed;
+	LIST_HEAD(release_list);
+
+	freed = pisa_reservoir_shrink(&release_list, sc->nr_to_scan);
+
+	if (freed < sc->nr_to_scan) {
+		read_lock(&pisa_allocs_lock);
+		list_for_each_entry(pa, &pisa_allocs, node) {
+			freed += pisa_shrink_list(&pa->lock, &pa->idle,
+						  &pa->num_idle_pages, &release_list,
+						  sc->nr_to_scan - freed);
+
+			if (freed >= sc->nr_to_scan)
+				break;
+		}
+		read_unlock(&pisa_allocs_lock);
+	}
+
+	/* Retiring must not run under @pa->lock. */
+	list_for_each_entry_safe(meta, tmp, &release_list, list) {
+		list_del_init(&meta->list);
+		pisa_release_page(meta);
+	}
+
+	/* Charge do_shrink_slab() for the full PISA pages reclaimed. */
+	sc->nr_scanned = freed;
+
+	return freed ?: SHRINK_STOP;
+}
+
 static int __init pisa_init(void)
 {
 	const struct {
@@ -698,10 +773,15 @@ static int __init pisa_init(void)
 		{ 2, true },
 		{ SKB_FRAG_PAGE_ORDER, true },
 	};
+	struct shrinker *shrink;
 	int nid, i;
 
 	pisa_node_init();
 
+	/* Default ceiling is 1/8th of RAM (floor of 16 PISA pages). */
+	if (!pisa_max_pages)
+		pisa_max_pages = max(totalram_pages() >> (PISA_ORDER + 3), 16UL);
+
 	/* Preallocate the supported per-node allocators. */
 	for_each_node_state(nid, N_MEMORY) {
 		for (i = 0; i < ARRAY_SIZE(cfg); i++) {
@@ -724,6 +804,17 @@ static int __init pisa_init(void)
 	if (!pisa_wq)
 		pr_warn("pisa: no reclaim workqueue, falling back to system_wq\n");
 
+	shrink = shrinker_alloc(0, "pisa");
+	if (!shrink) {
+		pr_warn("pisa: shrinker registration failed\n");
+		return 0;
+	}
+
+	shrink->count_objects = pisa_shrink_count;
+	shrink->scan_objects = pisa_shrink_scan;
+	shrink->seeks = DEFAULT_SEEKS;
+	shrinker_register(shrink);
+
 	return 0;
 }
 subsys_initcall(pisa_init);
diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
index bdc52e6497b05..96bc8dbc38fb4 100644
--- a/drivers/iommu/pisa-kunit.c
+++ b/drivers/iommu/pisa-kunit.c
@@ -6,6 +6,7 @@
 #include <linux/gfp.h>
 #include <linux/pisa.h>
 #include <linux/mm.h>
+#include <linux/shrinker.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
 
@@ -98,8 +99,10 @@ static void test_alloc_and_recycle(struct kunit *test)
 		{ 2, true },
 		{ SKB_FRAG_PAGE_ORDER, true },
 	};
+	struct shrink_control sc = { .nr_to_scan = ULONG_MAX };
 	struct page *p1, *p2, *bulk[3];
 	struct pisa_alloc *pa;
+	unsigned long old_max;
 	unsigned int i;
 
 	KUNIT_EXPECT_NULL(test, pisa_create(first_memory_node, 0, DMA_NONE));
@@ -115,6 +118,7 @@ static void test_alloc_and_recycle(struct kunit *test)
 
 		pa = pisa_node_pa(first_memory_node, order, cases[i].ro);
 		KUNIT_ASSERT_NOT_NULL(test, pa);
+		pisa_shrink_scan(NULL, &sc);
 		KUNIT_EXPECT_NULL(test, pisa_alloc(pa, GFP_KERNEL | __GFP_ACCOUNT));
 		KUNIT_EXPECT_NULL(test, pisa_alloc(pa, GFP_KERNEL | __GFP_DMA32));
 		KUNIT_EXPECT_NULL(test, pisa_alloc(pa, GFP_KERNEL | __GFP_THISNODE));
@@ -155,6 +159,7 @@ static void test_alloc_and_recycle(struct kunit *test)
 
 		if (p2)
 			__free_pages(p2, order);
+		pisa_shrink_scan(NULL, &sc);
 	}
 
 	/* Plain alloc_page() without __GFP_PISA_* comes from the buddy allocator. */
@@ -162,6 +167,16 @@ static void test_alloc_and_recycle(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, p1);
 	KUNIT_EXPECT_FALSE(test, is_pisa_page(p1));
 	__free_pages(p1, 0);
+
+	/* Global budget cap (pisa_max_pages = 0) refuses new PISA pages. */
+	pa = pisa_node_pa(first_memory_node, 2, true);
+	KUNIT_ASSERT_NOT_NULL(test, pa);
+	old_max = READ_ONCE(pisa_max_pages);
+	WRITE_ONCE(pisa_max_pages, 0);
+	WRITE_ONCE(pisa_reservoir_max, 0);
+	KUNIT_EXPECT_NULL(test, pisa_alloc(pa, GFP_KERNEL));
+	WRITE_ONCE(pisa_reservoir_max, 16);
+	WRITE_ONCE(pisa_max_pages, old_max);
 }
 
 static void test_reservoir_and_scrubber(struct kunit *test)
diff --git a/drivers/iommu/pisa-node.c b/drivers/iommu/pisa-node.c
index 524f0d4457ad7..0f23b94a7a6f8 100644
--- a/drivers/iommu/pisa-node.c
+++ b/drivers/iommu/pisa-node.c
@@ -74,6 +74,10 @@ static struct pisa_meta *__pisa_page_alloc(gfp_t gfp, int nid, bool can_block,
 			return ERR_PTR(-EAGAIN);
 	}
 
+	/* Racy check against global ceiling across allocators and reservoirs. */
+	if (atomic_long_read(&pisa_nr_pages) >= READ_ONCE(pisa_max_pages))
+		return ERR_PTR(-ENOSPC);
+
 	/*
 	 * Long-lived active pages must be unmovable, lowmem, non-compound, and
 	 * must not dip into emergency reserves or trigger OOM/warnings.
@@ -102,6 +106,8 @@ static struct pisa_meta *__pisa_page_alloc(gfp_t gfp, int nid, bool can_block,
 
 	meta = pisa_meta_of_pfn(page_to_pfn(page));
 	memset(meta, 0, sizeof(*meta));
+
+	atomic_long_inc(&pisa_nr_pages);
 	*clean = (gfp & __GFP_ZERO) || want_init_on_alloc(0) || want_init_on_free();
 
 	return meta;
@@ -256,6 +262,25 @@ unsigned long pisa_reservoir_count(void)
 	return nr;
 }
 
+/* Detach up to @nr_to_scan base pages from reservoirs onto @release_list. */
+unsigned long pisa_reservoir_shrink(struct list_head *release_list, unsigned long nr_to_scan)
+{
+	unsigned long freed = 0;
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY) {
+		struct pisa_node *res = &pisa_nodes[nid];
+
+		if (!READ_ONCE(res->nr_pages))
+			continue;
+		freed += pisa_shrink_list(&res->lock, &res->pages, &res->nr_pages,
+					  release_list, nr_to_scan - freed);
+		if (freed >= nr_to_scan)
+			break;
+	}
+	return freed;
+}
+
 void __init pisa_node_init(void)
 {
 	int nid;
diff --git a/drivers/iommu/pisa-priv.h b/drivers/iommu/pisa-priv.h
index f15934ccdeea4..d5ea83745ba47 100644
--- a/drivers/iommu/pisa-priv.h
+++ b/drivers/iommu/pisa-priv.h
@@ -115,6 +115,16 @@ int pisa_meta_ensure_pfn(unsigned long pfn, bool can_block);
 struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn);
 unsigned long pisa_meta_to_pfn(const struct pisa_meta *meta);
 
+struct shrink_control;
+struct shrinker;
+#if IS_ENABLED(CONFIG_KUNIT)
+unsigned long pisa_shrink_scan(struct shrinker *shrink, struct shrink_control *sc);
+#endif
+
+/* Global PISA page budget across all allocators and per-node reservoirs. */
+extern atomic_long_t pisa_nr_pages;
+extern unsigned long pisa_max_pages;
+
 static inline int pisa_sanitize_nid(int nid)
 {
 	if ((unsigned int)nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY))
@@ -149,12 +159,17 @@ static inline struct page *pisa_alloc(struct pisa_alloc *pa, gfp_t gfp)
 	return page;
 }
 
+unsigned long pisa_shrink_list(spinlock_t *lock, struct list_head *list,
+			       unsigned int *nr, struct list_head *release_list,
+			       unsigned long nr_to_scan);
+
 /* pisa-node.c: per-NUMA-node PISA page reservoir and work item */
 extern unsigned int pisa_reservoir_max;
 void pisa_node_init(void);
 void pisa_schedule_reservoir(void);
 struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean);
 unsigned long pisa_reservoir_count(void);
+unsigned long pisa_reservoir_shrink(struct list_head *release_list, unsigned long nr_to_scan);
 
 #endif /* CONFIG_PISA */
 #endif /* _DRIVERS_IOMMU_PISA_PRIV_H */
-- 
2.56.0.542.g3ef89b7020-goog


