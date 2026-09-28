Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4AA7CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36206B0099; Mon, 28 Sep 2026 15:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE5EB6B009B; Mon, 28 Sep 2026 15:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F1E6B009D; Mon, 28 Sep 2026 15:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC4D6B0099
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:23:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F02C71C24D4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:23:55 +0000 (UTC)
X-FDA: 85264146030.12.787F05D
Received: from mail-oo2-f38.google.com (mail-oo2-f38.google.com [74.125.231.166])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2EA8CA0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:23:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IZvdASjw;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.166 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790623434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I36Y3EED4OdoOnkWgrbUuXn4cMyXzZHgZseFGBvv25g=;
	b=4JF0aDSz9Bvv7BwQiiGnZRvbVa0KzIdUptQDpPu9Cftlif0aRGmsYdqWgqZ97VbPCun5PJ
	B61wFR5BjZOHis2wffh/wDhYvQ3UGOnVm+9gzFTO3JsndB+GkvFgEfWVtORnswfD914POA
	hc3uWxmIAa+colixS66BKKzdUTGWznc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790623434;
	b=2C3hX5Dzp31ShTFXp6BFWrpsB8r2ZkoZSASoD0yMBRNHD8RuVljd6AvNgyqFS9kp05DUWc
	ksmtwudvWFwP3+r/RfD9BJrWtqNavkhR5EsIl3HMuINMBlVXFInU4d8/44Cq3UJ6UMq0vz
	xrnLdmOYLi11fJKmBUyVlXTyVmvw4z8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IZvdASjw;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.166 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo2-f38.google.com with SMTP id 46e09a7af769-80a71781323so2055901a34.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790623433; x=1791228233; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I36Y3EED4OdoOnkWgrbUuXn4cMyXzZHgZseFGBvv25g=;
        b=IZvdASjwyI46lQLEBqci9Y3Jokv0GG/IqPJQ3tHy1S+lztPWetH+4WhqMlMeazFVT9
         syRJBWniRpE5IwnC5khP/p6BJK/FEExjepmzto+YiaLNqVLLu9/znp5P0Dvoh+z8kafm
         xEFLd8j7KXMsU81ZAHyIOGAsoOonzcYHZFjvcBo2AIYrhblooAYq1IgTedb/DcfVegOJ
         ZR6ntQNwyx0I9clA+j+cJFRPu5O+SF0eoiFyDdwyrpIPjXoBuKBlQ6rvyqB2jwYWcAsi
         lSviVYbShNHo5SJjBum+33zi4Ld5TOjLQDr2U449kSvbWC8LMZHxulykoJ94cQ8JWQSK
         Pmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790623433; x=1791228233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I36Y3EED4OdoOnkWgrbUuXn4cMyXzZHgZseFGBvv25g=;
        b=lDV32zwZqo/9DEEdseejaT2J9ioHgUuIIM/aN37/q4FQ1Ucsb7MN1mJEDIUpCxV+1s
         uwYF6+32PONDcNgtZD0P540eF5a6I0YVKML+hpHL8T6Akpg1TBAaA4752rLp/zJ+3+MY
         P4vG3s1AQzz1sHfNWzaj8CT1ePFhRcBtpAWJV1zqJjGdxcc7ud0oAm3xxffz46f2JOIe
         NVrS4PCndt8uUWsY+XYvAaIxSdRctjVTpd/nZ3ySNip4CAVWWcI/t6fpSXacq1AGzQMs
         aEDHTMKPvK1O+1NeUWD9r8prAZOX7Pyh3qgHQa/wbYLPcibJf9F6pmi4wRQBRaYcoqim
         4uMQ==
X-Forwarded-Encrypted: i=1; AKwUvBz6t1r8L5wp68cM8G9KWHVGwxVM5Q6QGd7VPEUkAGIdgfiQROdSVdrNl1WOmJxooOj4bCSCUcNhiA==@kvack.org
X-Gm-Message-State: AFuF++mlD7x4wZKAH+yiU28FbdIA5CXEmzMpAqUUlQBqP8ll3goJ1lqm
	tE51NfNXIWIcDc9coOZETqx8/j/ZXacpOyfGmGe/75DAVoipkBL1J6OL
X-Gm-Gg: AYBFou3b/6p1jhDbtnDioStcPEWDiZcsEgvjD+E7JV5cwERIzcOdE+6RnTmkDuz35zh
	Ohi+JUat3A0gYDna5DreYmpoTKxxqkjBNxHlaqwkwQrsa9bofKC3jHrIru62TTVq00ectrcpvLu
	3KEez+emLtbyl//M1hw4pcjfUlHOe2fuMAUKrtPjtxTY+cIpm8/L4ACPMQClMeY11OBbIzNNfI1
	qOM7DMA3DP9u+2IrbzJY89xK8sisTPhhrBIXGG7WZjmiPRQHOSyaTjNxx/mYLnoaEp4WmeVHLAb
	aGKJ1gJmZ+jp6qnStOPnPji8GCt4qkduR0lLBpOU0LlCkvJ0eRW8H/+I4uiruUGnxRZ5+JOf3YW
	wWP3WhD0KoKR+9xOujA554dJ6mAr25X5/jsj0NpZ9nURQWk6Ay7kdY40Beuq3NU+GZclwSrTnbh
	HdbVPxb7kDcP5AdCv/hvUnrpIhNiNGfrIOwJikMVzkDZ2l7JrVLwjGcdlNSfBkQK5AtaCQIMUKB
	+gsXa9r7O+yyERwlbu+bOdKNGE42FgkuK59kvc=
X-Received: by 2002:a05:6820:308c:b0:6d7:af74:7185 with SMTP id 006d021491bc7-6d7af747559mr4823330eaf.63.1790623432762;
        Mon, 28 Sep 2026 12:23:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-81d58f177e1sm2414743a34.24.2026.09.28.12.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 12:23:52 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v6 RESEND 2/5] mm/page_counter: introduce per-CPU stock
Date: Mon, 28 Sep 2026 12:23:45 -0700
Message-ID: <20260928192349.3432886-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
References: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2EA8CA0004
X-Stat-Signature: kk4pb39z9eqw5dbkpgfdgqpx63pwn7s9
X-HE-Tag: 1790623434-236812
X-HE-Meta: U2FsdGVkX1+DGw7lyEBeUmnABU/wqS7NcY6bM+JemBESS4l6eS5PvfLIUWEvUvSbFMnn6fJBeAkye3biXjUh815+5Di9EO8b1qmz3yc3oqed65LL0JAh1CiKAIMTKKAZ86KiXcB1M6KsPF1BIcabJle7cSuNp4MxtFBLzTT4xAj+5OCTFvIS9gX633VLTtjh7/4ujf7WHDZL2X6WNV1WstYr6p6MmiqHBZP+Pb+32IhVhglajsaFtm1it6RmPXnNTBVKJdzqSZT9wEoAQmpObV5QZlF9MgjGzuoXOBOf3yJjZJIJochzf4ZlWFnuBkeZZK0Z/7Qdzat5D7oW8RdAzYmKKlqKZqRSe7OaO9m4xIznVlLmtijkxiwUJ599oUywS+JulksUceuHZbqs0kCmINhOU/K4nFtErKFxNBW1OFHLAGNpOOlZ165txGd+OU30ZquXNG0wsSzJCqCqy56MyD9im5EcV6T7InJWOXtMweFeQeCjtlvLmahlDwpQjj1BVM9RpVNd8pLXxDYGcRWwr0lyLIMGVTWSFNfrnWhgutXaoBv0kOlKB05AyKs0DavH8XoqNSwk4kKdP+o6w8cVbBwS+ugkm+GQ40W3yWdmpwpw/s5hu6d3vdp5xj7NBQUQMn2LNquvsh32iPauo5Ps/S5IF8TNnaEBg6pB9JFUsfa2gme4UrRh4dbwZpaFFz50//jwM2ZX718IQSrrWuOd2ans8RlVJUj32xawms44HGDJoa/2ZlSw9A7sOZ5DLH/H0MDius3ifMCggAGNotTfHtSzUplrHe1yk4PXrWpy4dWPvxcbVmqsu1y0qrlwMACeTDwZvMtkMtEPjZmWzwO4QGSHujL2kdeF4GhGdu29W3b301P27fv7qyb/e02okQTQHQlpEZp8/+kXOzFTV8w7lJ9V2F0vcNHXSIF0siwd4QLL+lZZpjSbEgSFdXCkg8uxJkVcZh93+3ieMOLBniR
 h7WLvNAc
 2qwBVZDkNBVcLYsp3aZk49rk++OYvLRGZ9zFfEvQ/93zjUpZBY4KkIzRYZp3Tp2pUcO4kbmnjwZlHyyhL5SESke7pvD+p3l5gQ50FnRR4fxDQSo/+iXkL+e18MUp7C01v+Bp7FzZeCLWLAu/b1MhEgFWS8HB/tM5wT4OqOFmJwj8Lr65Q3xcRYiRNpTFm9m82pocanY51Upz9NBdepilcO3zkDKNf+bY5EfZfu/7Y+12BAgqaCWdA5Z6ddn0MP00OXjo8Fa15S+Qfhyuz8WTwwiOXiMJ6EJh2APBChMRA6VlIjFzoG0uuZ4uVMoSRZpohtYqgqPaXp12uGxmR4mi96+BRpsuiCqjtU/X+d64E1gy8X3/9UWtBPJh4c5+1gBAAICIVGbfjMH+kYf15NYj5UGpNx3Fg7jBYQb6ORylbyoqYkof7wnr26ihZoOwM0Vao+KAAtOt3LK3Wh90d0a6W1+Z0gFMZJp73Nh5NPainI67Xb8xh6d6Len1XxLgUePt91R+NF7MKVIqfMZ27vXYmMfS+85L+IV6xJDLvubxR1CSpDWl41Fkann2ov+rjTqMyYg13pdr4HmR3jrCdaP14rfGMap123mb0vUpWhdu6O6/UVgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a copy of the seven-slot per-CPU stock representation from
memcg in the page_counter layer. struct page_counter_stock_pcp preserves
everything from struct memcg_stock_pcp, but adds a new backpointer to
the base of the percpu stock, since there will be multiple percpu stock
base pointers later in the series (one for memory, one for memsw).

struct page_counter also gets a pointer to the base of the percpu stock,
as well as a struct cgroup_subsys_state pointer to pin its owning CSS
as long as the cached counter remains reachable.

Let's also copy over the drain, refill, and "flush required" functions,
preserving all behaviors from the memcg equivalent. In this patch they
are not connected.

No functional changes intended.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  31 +++++++++
 mm/page_counter.c            | 127 +++++++++++++++++++++++++++++++++++
 2 files changed, 158 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 2baf7a2b29b2e..cf627c5090093 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -5,8 +5,30 @@
 #include <linux/atomic.h>
 #include <linux/cache.h>
 #include <linux/limits.h>
+#include <linux/percpu.h>
+#include <linux/local_lock.h>
+#include <linux/workqueue_types.h>
 #include <asm/page.h>
 
+/*
+ * The value of NR_PAGE_COUNTER_STOCK is selected to keep the cached counters
+ * and their nr_pages in a single cacheline. This may change in the future.
+ */
+#define NR_PAGE_COUNTER_STOCK 7
+#define PAGE_COUNTER_STOCK_BATCH 64UL
+struct cgroup_subsys_state;
+struct page_counter;
+struct page_counter_stock_pcp {
+	local_trylock_t lock;
+	u8 nr_pages[NR_PAGE_COUNTER_STOCK];
+	struct page_counter *cached[NR_PAGE_COUNTER_STOCK];
+
+	struct page_counter_stock_pcp __percpu *base;
+	struct work_struct work;
+	unsigned long flags;
+	u8 drain_idx;
+};
+
 struct page_counter {
 	/*
 	 * Make sure 'usage' does not share cacheline with any other field in
@@ -41,6 +63,8 @@ struct page_counter {
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;
+	struct page_counter_stock_pcp __percpu *stock;
+	struct cgroup_subsys_state *stock_css;
 } ____cacheline_internodealigned_in_smp;
 
 #if BITS_PER_LONG == 32
@@ -61,6 +85,8 @@ static inline void page_counter_init(struct page_counter *counter,
 	counter->parent = parent;
 	counter->protection_support = protection_support;
 	counter->track_failcnt = false;
+	counter->stock = NULL;
+	counter->stock_css = NULL;
 }
 
 static inline unsigned long page_counter_read(const struct page_counter *counter)
@@ -74,6 +100,11 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
 			     unsigned long nr_pages,
 			     struct page_counter **fail);
+void page_counter_refill_stock(struct page_counter *counter,
+			       unsigned long nr_pages);
+void page_counter_drain_stock_fully(struct page_counter_stock_pcp *stock);
+bool page_counter_stock_flush_required(struct page_counter_stock_pcp *stock,
+				       struct cgroup_subsys_state *root_css);
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 9167ffd1380c8..77624b00b5f94 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -7,6 +7,7 @@
 
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
+#include <linux/cgroup.h>
 #include <linux/kernel.h>
 #include <linux/math64.h>
 #include <linux/string.h>
@@ -14,6 +15,14 @@
 #include <linux/bug.h>
 #include <asm/page.h>
 
+/*
+ * Watermarks for a charge stock slot, in the spirit of pcp->high and
+ * pcp->batch: PAGE_COUNTER_STOCK_HIGH is the high watermark at which a slot is
+ * trimmed down to PAGE_COUNTER_STOCK_LOW rather than emptied.
+ */
+#define PAGE_COUNTER_STOCK_LOW (PAGE_COUNTER_STOCK_BATCH / 2)
+#define PAGE_COUNTER_STOCK_HIGH PAGE_COUNTER_STOCK_BATCH
+
 static bool track_protection(struct page_counter *c)
 {
 	return c->protection_support;
@@ -192,6 +201,124 @@ bool page_counter_try_charge(struct page_counter *counter,
 	return false;
 }
 
+static void page_counter_drain_stock(struct page_counter_stock_pcp *stock,
+				     int i)
+{
+	struct page_counter *counter = READ_ONCE(stock->cached[i]);
+	u8 nr_pages;
+
+	if (!counter)
+		return;
+
+	nr_pages = READ_ONCE(stock->nr_pages[i]);
+	if (nr_pages) {
+		page_counter_uncharge(counter, nr_pages);
+		WRITE_ONCE(stock->nr_pages[i], 0);
+	}
+	css_put(counter->stock_css);
+	WRITE_ONCE(stock->cached[i], NULL);
+}
+
+void page_counter_drain_stock_fully(struct page_counter_stock_pcp *stock)
+{
+	int i;
+
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++)
+		page_counter_drain_stock(stock, i);
+}
+
+bool page_counter_stock_flush_required(struct page_counter_stock_pcp *stock,
+				       struct cgroup_subsys_state *root_css)
+{
+	struct cgroup_subsys_state *css;
+	struct page_counter *counter;
+	bool flush = false;
+	int i;
+
+	rcu_read_lock();
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
+		counter = READ_ONCE(stock->cached[i]);
+		if (!counter)
+			continue;
+		css = READ_ONCE(counter->stock_css);
+
+		if (READ_ONCE(stock->nr_pages[i]) &&
+		    cgroup_is_descendant(css->cgroup, root_css->cgroup)) {
+			flush = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return flush;
+}
+
+/**
+ * page_counter_refill_stock - return pages to a counter's stock
+ * @counter: counter to return pages to
+ * @nr_pages: number of pages to return
+ *
+ * If the stock cannot accept the pages, uncharge them from the hierarchy.
+ */
+void page_counter_refill_stock(struct page_counter *counter,
+			       unsigned long nr_pages)
+{
+	struct page_counter_stock_pcp __percpu *stock = counter->stock;
+	struct page_counter_stock_pcp *pcp_stock;
+	unsigned int stock_pages;
+	int empty_slot = -1;
+	int i;
+
+	/*
+	 * nr_pages[] is a u8 and a slot is capped at PAGE_COUNTER_STOCK_HIGH.
+	 * Raising PAGE_COUNTER_STOCK_BATCH beyond 127 would need careful
+	 * handling of nr_pages[] in struct page_counter_stock_pcp.
+	 */
+	BUILD_BUG_ON(PAGE_COUNTER_STOCK_BATCH > S8_MAX);
+	BUILD_BUG_ON(PAGE_COUNTER_STOCK_HIGH > U8_MAX);
+
+	if (!stock || nr_pages > PAGE_COUNTER_STOCK_BATCH ||
+	    !local_trylock(&stock->lock)) {
+		/*
+		 * For a larger-than-batch refill or an unlikely failure to lock
+		 * the per-CPU stock, uncharge the hierarchy directly.
+		 */
+		page_counter_uncharge(counter, nr_pages);
+		return;
+	}
+
+	pcp_stock = this_cpu_ptr(stock);
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
+		struct page_counter *cached = READ_ONCE(pcp_stock->cached[i]);
+
+		if (!cached && empty_slot == -1)
+			empty_slot = i;
+		if (counter != cached)
+			continue;
+
+		stock_pages = READ_ONCE(pcp_stock->nr_pages[i]) + nr_pages;
+		if (stock_pages > PAGE_COUNTER_STOCK_HIGH) {
+			page_counter_uncharge(counter,
+					      stock_pages - PAGE_COUNTER_STOCK_LOW);
+			stock_pages = PAGE_COUNTER_STOCK_LOW;
+		}
+		WRITE_ONCE(pcp_stock->nr_pages[i], stock_pages);
+		local_unlock(&stock->lock);
+		return;
+	}
+
+	i = empty_slot;
+	if (i == -1) {
+		i = pcp_stock->drain_idx++;
+		if (pcp_stock->drain_idx == NR_PAGE_COUNTER_STOCK)
+			pcp_stock->drain_idx = 0;
+		page_counter_drain_stock(pcp_stock, i);
+	}
+	css_get(counter->stock_css);
+	WRITE_ONCE(pcp_stock->cached[i], counter);
+	WRITE_ONCE(pcp_stock->nr_pages[i], nr_pages);
+	local_unlock(&stock->lock);
+}
+
 /**
  * page_counter_uncharge - hierarchically uncharge pages
  * @counter: counter
-- 
2.53.0-Meta


