Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06CC606EE8D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yRmEcL/7
Received: by kanga.kvack.org (Postfix)
	id B8A936B05B1; Wed,  4 Nov 2026 18:30:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B152B6B05B2; Wed,  4 Nov 2026 18:30:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02A96B05B3; Wed,  4 Nov 2026 18:30:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 719DD6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:30:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D32321608A8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:35 +0000 (UTC)
X-FDA: 85399033230.29.D9CC4E2
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0D1A814000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="yRmEcL/7";
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793835034;
	b=sV7XqBi3kQEvH0ZrGpmhcFCDgJ7Gs4ewmzZwTlII2p01Lr73AoW/wjiT3bpRcax4hbgIHz
	0goEep9LZb6eoqy+CSaeWFrEj1KcSUcRp31K/bSAbkrTzv2HqyjAa2mC4A1l6nH+dtHmC8
	gO5YeJGJMijhwQ5z/rh6PWy60TO1F8U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="yRmEcL/7";
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793835034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fuNaHz2eYoLXRYUaHGG3mBL1JjkfQbmi09ULNtXItRk=;
	b=8GwLBaKKmJr756I/9ZuOt6Hh92IUiOohnrlu90ev5s63BjotVX0xuvd4JLOYCv86Bhcuum
	svo9/9Qt0c+zcp3KL5e6Eo+q5FQ7q9AhdBxnF+0JRUFq6HIq1zi9OlMfiAQUUXYJIKJR7T
	O7MfrvG6yfJsK7xp5Lgbg/Zohy0eLuA=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8b0cf2c0785so11709557b3.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835033; x=1794439833; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fuNaHz2eYoLXRYUaHGG3mBL1JjkfQbmi09ULNtXItRk=;
        b=yRmEcL/7HtW9/LW6W0hTm/LVFOrTm2kFtCoFoXv5LKq4rmiYDbZ745zk9qpoHqfydw
         JSm90tbRbzRgd9OZuGZr+jJck2B02WqARFwPibDpqbIxt1Jk6ihLUx0yyYq3+8GqZOPm
         dgldZ8AYt1b9PeEMx/DU9jpRiIQ6kLxQZUJ3Sh9oC3pTpu+hxMp2n4/+Wx4HJT6v2YlO
         ZxQDzcBLzUmGxGsaL5BWbLKVe3whIRgmg2Pz/rrep5fm0BLOIQfrNqJzjFff9QPfu694
         ZlUJOhPMbD77jrE4YFVQgajqG/NHE1rXeqtE7d5BiwCrjw0FeOclR6ZgQrQYs/ZwjBNI
         sOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835033; x=1794439833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fuNaHz2eYoLXRYUaHGG3mBL1JjkfQbmi09ULNtXItRk=;
        b=naaWuTKKB7mT+s0QOLUo0/GZ/Vao7Pt0TmfCWjGHIG9wRw/vxGqDe5CHp9BCO/Xb/W
         HIsfLJR5Zs3nOVYvZJN2kG6JBaK6kgFjA2HCw4OPcaMemc0MNgqkxzkVjhARXkCn+Hra
         MT5fH0t7zB/PBah4MVmqeShROD4beeb0a5CVsWMvh/zhuq8CCwy8Ggfv4EqyNTy1pLMr
         rGBDXr3XjT44JiOIB71cz1Gr/kX4mG7E2ATLGIVlj48hsahmKYUoJRtA9VFLx+38As5q
         0FOu4KIbD6sMQ7KkSLvyagfZEHbDSIk/zDndvbZGQjaRaWaxqO8lNm2IqZ83KXWe6Tv5
         An8A==
X-Forwarded-Encrypted: i=1; AKwUvByBvelDWpS1gIt0PSTthhj1aEqjru0LSM7MCbTK6a3almtY0WLtb6pOyGhtNX97JbrUr+ViQVfvDw==@kvack.org
X-Gm-Message-State: APuU4Z9lTFs54Yvz1mYqMNVGiUjru3QODYA5hl8t8NPFgj2x/h1bpJCh
	qm5nwX3QOzkZVtJ0N8h1UglwvAzK7/ogDIBfbgw4UXb3GSciok6mviqY
X-Gm-Gg: AYBFou0fWZnr+eMGYPs7ZpYMs7trju9H0KidPOAyEPixIvHLpWrTXcWF5EOUfuwezvi
	PSKx+Edsh3y2/0tr4z66AVdYWSUrVZRp44G+uNxRugHNxz9YRcoqn+jpLv/6vmBUIv/QKvaajG3
	L8ww/NKVsuGQ+dm/Ez1RVCeIqSlAltwTerQWrD/4vjB1wTzKv06+1nnI9W9tETBpGv096vfBLQq
	bQAjKyh89z0Sz3MNPh2+JSnNMe6fiR+P7FU3b1hgUcU8citz1PNHrO1oNce0F5X1eznzsyr+QeG
	2CIfmaeY+XZHKj6wgJl0cDIFq9AalRJ0cEdJgFmYE7LqEQILzzG5pk5QCeZACDZi8xQik0I2rvK
	IL4/rn9DwS47rf9QDUUKLto0uBCEnRsnvlRmehQNy9puKDVPfLS0EGOExy6T5u4q2WpLU62vJzG
	OqhY466YlI+BAS43RbrBHm3kqjqsx32rw2DZWcOZEzVi73AYU1ncPz2qgN4SBDy52QLFQGZDp4k
	NjDwIv0BwIVaK58L+xpANjsBOmMWMxeZy+xd0QLTmL5ej+LeNTkPqqZU0hBa00yBdY5yLzN6vu7
	c7SLt6BZT4NfRgInpOoCQ320JGKlgP1teIXCXQHcUfoenw7071PfgJPJZ0Ic
X-Received: by 2002:a05:690c:39a:b0:89a:63da:fa90 with SMTP id 00721157ae682-8b2b6765816mr108513857b3.75.1793835032878;
        Wed, 04 Nov 2026 15:30:32 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b30999b889sm29096017b3.33.2026.11.04.15.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:32 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v8 2/7] mm/page_counter: introduce per-CPU stock
Date: Wed,  4 Nov 2026 15:30:23 -0800
Message-ID: <20261104233029.3282438-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0D1A814000A
X-Stat-Signature: byrraosg3cpzq7kzt8mot6om6d3x87aa
X-Rspam-User: 
X-HE-Tag: 1793835033-689939
X-HE-Meta: U2FsdGVkX19ueIISHAohaJvlqUnxN/bQYvH7HryFtjRrOWuUnT4WWelbbcTxVqpFND7L+cSqcFGv95He2tNu9P+A20X7g+HfxaFqDcFdkUFwnBvu+YWXD6CX45ONtqhae+Td7nVyht6LcMvx+wn490VC+T3iz0bQo/El4kJD6AT2G9z5ehEcaDtyawvgGMXKsMpDGT+8aw7h/UMN4HLH8B74UuLLfjeiKQD6+OtpmZR+3pGXWCy9OfjUahF4VITBWzyLrHW1qstbWJgyHzdlHgK+xW4lLjPmBMw1pYsPvB3On33FY5KCiHv5ecxzZ7RnMA9I3HMniRwROKndnAEpqNLWxWQtGKm4HD35F1CPjfelVZJcaOH5ad0cPis03omwdsGeqzVZ6WVStcMJVBuinwVQLWwjAElIRUTEH52T3ejvBFXrBnvGen1hmQzeXwuHMypQS1lDx8tC6jEKVv3CxIOX5Ofckvs5rVm0lvwfMpVq3GbokJLEUTX5xJEOrLarg064iwx+36qzzfWENf7zJ5Fc+VMNI/CkWBIQcN0g3t8GkXhjAPTR5NrYrlsKgLBCrGHwcIrsTN7OxO6D5rA0WOnGRhDOr1ZmLIkmeTqnjQIxAQTMe15qCYGFD6OivLmEesM+ryIhIWX6yhuEhDxQG77yu5LgvDMJERDBCwW2SAJ6dSwDq9f+T+pyxo26LDt5VWrks3UG2dITslHMRzuEeve6FZiLCZIQ7whiO3SY0/miCDyRWf1t70Vd4EwSlhNJQyUu0DP1SozQRQDZ277SDwQjsZ9zqKv4zFjlO7v5m0Oxu5Y85N8cnnK/a7KaS8T7NUBCXdqHFiZHID0uljeBQXZw2AQo29r7s0NeNBTa6YAHoQBynD4odH87DHoCQrH2PHch4W2FT63uYfjWK9PthpnnykllGR9zX9atuZxSqetqfDuYRC7fkD8YCXibBxtI+lik/simA2xX85tcdQl
 K+A5T9IP
 WHPWHcyiluv9x2jnW4FU/QUfkqdTUpVwcbs0kWTqlGQ+nmHfnbTvDT1IwPwheuf2gJdrZG0OOdODtxBzRT4raLlPa066P7mb8VzzYgbCt+CoUvgXs5Z8BQJppET/2jhLnGneBDwQsXiGX/FpxdgHF4DYqrZmZP2HbKp2QfeudiiyCKK0dkGgCvvLtaZ21pkNlc/nI+0X3plb7MU3B3TThfdHZt8uILgNJ1EXLYDTeVAAFxDqxykxk0HR4OUVj4FIfvLM2Eydn6F1QB+R1U1yEKeC3BEUeIe/pWdeZC60fK0EkreSAZsjhnNrtOu5Nf3L9zRZV6+f6fBxkHaTbg6KWuSDXZck9PDE91n/hRamCgac10lwcrCMg9s6dvGW/01Sk3KwqMVNklKJ3y0SOtiiXFU0mBZqp314Ugo5dxfj+BoZeKjpMuB8VIFQ58MApbhIMLf3h9+rNeIYd9wrRoTx98lX68T6XPiAJ0s2ZjVQOUyOsom836jwkE9ijdt4bNoc+QJWp8053J6zBeLWJQzqxHQvHPEtCWaziFXJurGBHYYrQwfdm5qOr/SiAaVWWJ8grKHwA9FbxwCwznsB/cJZIb9co3YB41SqAxYrGr03VtM/c9d8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
 include/linux/page_counter.h |  31 ++++++++
 mm/page_counter.c            | 142 +++++++++++++++++++++++++++++++++++
 2 files changed, 173 insertions(+)

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
index 5293460831f80..70d76689e3212 100644
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
@@ -127,6 +136,24 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 	}
 }
 
+static void page_counter_drain_stock(struct page_counter_stock_pcp *stock,
+				     int i)
+{
+	struct page_counter *counter = stock->cached[i];
+	u8 nr_pages;
+
+	if (!counter)
+		return;
+
+	nr_pages = stock->nr_pages[i];
+	if (nr_pages) {
+		page_counter_uncharge(counter, nr_pages);
+		WRITE_ONCE(stock->nr_pages[i], 0);
+	}
+	WRITE_ONCE(stock->cached[i], NULL);
+	css_put(counter->stock_css);
+}
+
 /**
  * page_counter_try_charge - try to hierarchically charge pages
  * @counter: counter
@@ -192,6 +219,121 @@ bool page_counter_try_charge(struct page_counter *counter,
 	return false;
 }
 
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
+	struct page_counter_stock_pcp __percpu *stock = READ_ONCE(counter->stock);
+	struct page_counter_stock_pcp *pcp_stock;
+	struct page_counter *cached;
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
+	if (unlikely(!stock || nr_pages > PAGE_COUNTER_STOCK_BATCH ||
+		     !local_trylock(&stock->lock))) {
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
+		cached = pcp_stock->cached[i];
+		if (!cached && empty_slot == -1)
+			empty_slot = i;
+		if (counter != cached)
+			continue;
+
+		stock_pages = pcp_stock->nr_pages[i] + nr_pages;
+		if (unlikely(stock_pages > PAGE_COUNTER_STOCK_HIGH)) {
+			WRITE_ONCE(pcp_stock->nr_pages[i], PAGE_COUNTER_STOCK_LOW);
+			stock_pages -= PAGE_COUNTER_STOCK_LOW;
+		} else {
+			WRITE_ONCE(pcp_stock->nr_pages[i], stock_pages);
+			stock_pages = 0;
+		}
+		local_unlock(&stock->lock);
+
+		if (unlikely(stock_pages))
+			page_counter_uncharge(counter, stock_pages);
+		return;
+	}
+
+	cached = NULL;
+	stock_pages = 0;
+
+	i = empty_slot;
+	if (i == -1) {
+		i = pcp_stock->drain_idx++;
+		if (pcp_stock->drain_idx == NR_PAGE_COUNTER_STOCK)
+			pcp_stock->drain_idx = 0;
+
+		cached = pcp_stock->cached[i];
+		stock_pages = pcp_stock->nr_pages[i];
+	}
+	css_get(counter->stock_css);
+	WRITE_ONCE(pcp_stock->cached[i], counter);
+	WRITE_ONCE(pcp_stock->nr_pages[i], nr_pages);
+	local_unlock(&stock->lock);
+
+	if (unlikely(cached)) {
+		if (stock_pages)
+			page_counter_uncharge(cached, stock_pages);
+		css_put(cached->stock_css);
+	}
+}
+
 /**
  * page_counter_uncharge - hierarchically uncharge pages
  * @counter: counter
-- 
2.53.0-Meta


