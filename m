Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51461606A322
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 22:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NyW6vf1Y
Received: by kanga.kvack.org (Postfix)
	id 3A5096B07D8; Wed, 21 Oct 2026 18:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37DD76B07DA; Wed, 21 Oct 2026 18:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 244AF6B07DB; Wed, 21 Oct 2026 18:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDAD86B07D8
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:55:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41170C06CD
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:22 +0000 (UTC)
X-FDA: 85348141284.07.2C071F4
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 762AE100005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NyW6vf1Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792623320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udCmSGAkUzXb8RB9tqi7fNnGMXP8Z9/o+Pg4FL7fz5A=;
	b=KPURb4GQkA9OGMbgZ5JvXjso6KD/rnJfrLsfwszHYK9iwYD/Mx0JTY6+TL6VF86L2Qy/KF
	YO1TyVGCm9H2d9w68guja/sicj+F2TE3OyCNp55wxVBCJXxeEBYLK2QIxeMMAGnMtIxZwv
	t3saRKXHqRtfzeOpdCBZo3OiGBUXbJo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NyW6vf1Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792623320;
	b=LGF6Mb+7y9dv4VbBeReCT2uescYiwXXo+Ib+17hl68wnLInuA3QCi+cHKIV/XILFpiqR9J
	SYPfxDtb27gc9wnMmGXCAHBNH9i+1cDd+kRm4NsBq8kU+4K063j5r30DMFvwIr+e4S+rAN
	mNJknjxwS8YR5iK/mUbt6dagEI/nfJM=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-66fca0709caso1073910d50.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792623319; x=1793228119; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=udCmSGAkUzXb8RB9tqi7fNnGMXP8Z9/o+Pg4FL7fz5A=;
        b=NyW6vf1YpYVxf4mWCqOX62A9xL8ZpBTXTauwCU80X6T6mhvptoFrj/qWVI7WrEvwmo
         WM35rtq7DxQpvYXAqhS2/LUH55PpsppJu2ibHRYLt+zOh0pBJB8iNO6JG95t39gTZ2vq
         ILc+Dp5mWz94KF+UwJ6DS6XZCFCHpDTCrAWbepX6RPkZ94kIamUE3HPpZU4adbpS5Hrb
         Qory4u+jomXhTC5MlVzPdramnd3qY0dH7U5LrcaUwRwGm1/Jt6i7V2BU29ouFpPOnyuJ
         aTBBOFXpfqNvQwwd0jJXzD3djcMPVKbz1MqoAem4Rsf+3d/KU3xZETnKVV0wbsgkE5KE
         gwjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792623319; x=1793228119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=udCmSGAkUzXb8RB9tqi7fNnGMXP8Z9/o+Pg4FL7fz5A=;
        b=BEv3N9ANJfro6Oyelgzv3pUXij954kyqAMNi2/y2qC3EFtAc7xYt/0qmfLm9QUpXQQ
         MJylI4jY9V73Y3dQbwiFCNWX3PlEkMONtl0kEp2uoLUrUN7+aYpCqgbLrk9JJvxfkZ2e
         Q2+bWohTmnDShgWSlBbXi0F6fz+KPcvDDmaGb6KWvinsA9bsclL81CsHItvVQWwVYKPf
         Xa+hj2fE6HAZammmpQ1IPWGrqm4Iq56RqU56lUBMdHEAD7Rvs/FOpTjiruAXQvn3monc
         LBuR7r/MgaGbVbjDPZCLWB885TED1GTGE5yrjgZc/+3ktF/rJ644CMBvXV4y80qwtQzI
         tbqg==
X-Forwarded-Encrypted: i=1; AKwUvBzYonCa2iogV7DHpR9BjPb0W8p899+y3ctmheuVp/+RFOtXOXzkKCgNQaoKOa2s+xoLIkN6Q0TQGQ==@kvack.org
X-Gm-Message-State: AFq9FYIfPDlTvlzKuCCxO1mHsTGL3q0qMJfgIdy2QN5+zivZhU/p+54v
	RGuYQy6AI+oUSeCU5csyRgUXY/uJPz9UsjbvR1u4vP8nWOXU//4tMP0l
X-Gm-Gg: AYBFou20QMAL6G32BMUtYIHzRgUXUc+9TukJmXxJ64vCzcMgWsWd/sYIlPxugy44C0j
	DgnxTFdLthvfVVAIA5m8EMzavHQK/LuKZvumyoLjw2cRWyYNjASOusp8nao9WrywbFIoITAVBoE
	o4cErbbEBrN/vhmhZa65F/aLL/24ogR7QTOpAajYovxh800oEEcFHp20H/HzZqtotrfofgMZwTO
	B+C9vqEkrWeQYzc8CRgTZ/fTNHPJpdYzEIjL1BVkziQgN3I81AXbDJSCIW7naOgZpktiRg77sV+
	+UDHHNWsfB1Bm1l8NcVLqmL8xMEUJHDK5ovnP1wEPJT1DtgFLq+ELugVh1WNUR9MZpazyhcO8uF
	DZOfE0o0L/O667ccjw//jMvJQNS5sa3jecNio6n6ujVOVHBhFedJXywCoUDvldtxsVkXkbpDG+Y
	FAIENmryTQTf14AY2tB++UN+NyzqXhPno/DqXnzcbvQYEi3q6uDIomvOWwG/BNYPwcV2UGkmM1O
	v0u8IGTYUqAyPhEUvJugyrk/hQ7hs8RXEpN2tvRF7Jo8ssmwks0AeurUFj/eJqV0s2Xn3dadFCn
	yryALc9ezhk=
X-Received: by 2002:a05:690e:488d:20b0:677:d4b0:47fd with SMTP id 956f58d0204a3-67a0e49b2dfmr1244538d50.23.1792623319495;
        Wed, 21 Oct 2026 15:55:19 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5b::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e496732sm1729420d50.5.2026.10.21.15.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 15:55:19 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
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
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v7 2/5] mm/page_counter: introduce per-CPU stock
Date: Wed, 21 Oct 2026 15:55:11 -0700
Message-ID: <20261021225516.1620680-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
References: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 762AE100005
X-Stat-Signature: 8j3w7wmk9q87zppryybnkcu8qjoae7ff
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792623320-4085
X-HE-Meta: U2FsdGVkX1+F3xVdSpkSkUtkpSpgLZ8zN8jTOVSJztf1NJ8gpTLvCKk/LepZ1/GJ7pxY3H8cUSpcQkN2PNNS3bSVuX9qxJwPB/7cyqA1hFHK3k4Z4bnAmB4LKO/uAHRJKEv/T72ghyBsE2UYZuHx/GuCMFWEZpDvdmu/1pVAvT6S6Gfg4qlFne/AZbSQldcm4sWCkx3dNajZ8owj4tl7wafFcDSJ2ewOJQCYYXWH9oV5eBggNS5WqVGvkFIqoQmv5V8M4NBVTndzerJLO2qcftlVMcwaAOEq9QTTUO2AkcjbW7vElt+lcuRnDJznDbcQn7q4Pdplp6g49JQblC/0FB/PDvRWblyxs82oY54FNmY/wPh4HYhH2kyk8i+jZV27rnboWBalzB+g40Hsj2sqBlh4rmNbJSPc4NA3mdrPAQU2b00vkLwXoxIHiFfjn8ytvINJX9WxIMsXpa+gPJ7lop8LcPZkeOOzpnWY3AiCWclGqOMiRCjrPPKD7lOPzjOdwlYpot5orW0zwVhIGIsjiC0ELzsOagokFhtRKmQlSa5lfnzVq8TlyX8/5O/USWQcoWiHCeYYmWUsknFLSos+P4K5qVBo5zeIhp4FztxiPFIhpOuUcsZX4EFsnze6LwSbu8XUrmdnyNj2uqfV03f2yP0v6NW7EwctmpUWanKdXoUTPC1Jhd6ut/jo81i2oMNW/OGQOPNou0KFFSC4ACcD57Ygwuch/lEJEthxOxEp5MNM2lt6TTGT0B2FwEcQe7c5c8xBLVDk5llvP2WIZRMeOgNndPO17MWmuJJsK5UAKPPmeWmuN6HTmDCBYTWb5NrtF3uQcViaTAuApSJxv/vX233FzvwHmz0F9fI3zCBvlQyn+fSIcw45N5MXhRe9p9EtGIuYUSbnA7viYess4bPNjLpMoo0SN8dZM8YtUR6QQJ7+2yMYONXv3gqj7BbcoV1WbOaelzMg4D7biBceq25
 xQqRv25E
 g8dPh8n5QCZKd+d7R8Y3WSG2/wdlDkq8+y2easrWe8B7ulAfe31/4RXdnpWWJ/4tTUy9wXKIlPuzDXLC4pyLhbiSNJS+ELBSf1fgHsvoAps/sxq29fG6gn+MNpa3MsOHmYyc9zuouM9nQefWlKt+bMJrZUOtSkmiP3CfFi4ye+kHDadeGJ//6Wwtsp1g22J7n0Es2MkKJLbxOESj3ZaDiVJ+7Gu3+GHFbDvlf7e4Qx8P0iq5CDDB75IBMShGVhu6HedCVhbbH7gdXDaYFp9K2O9Q0OYhU3Wb2VnLNP+14cmJQ1KVZy8GNRlh2yV4wxkz6LX9k0q9ZjNfsaAly367UoBuR0yL+Rs4nTcNkWipHWEhv6XvRRdc/wfarumbP9v8PWUTi0Vri+ONeEGEkW69GhX3joR/lwSWBS5jSYaErVyDxrYPSDrq6AuMpOy8lA+oYA0fApwxfowuwT0SxTEWyQy0O3Eftg4fhLwoNsH9d58C32WitKF+584RvXK73Ry61mb7ioAUdNRGUaJ55gG+AusDnslTtZTrMglW0Le0AdddPY/DAAdqAfLkPu3Gt+QI4E6aVwrZ7LgecozEpG/B61lbsnr6piVoTFHiZzEa07X+xg0k=
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
index 9167ffd1380c8..71c7a89026cb9 100644
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
+	WRITE_ONCE(stock->cached[i], NULL);
+	css_put(counter->stock_css);
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


