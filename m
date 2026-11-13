Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8048260A2634
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qmGhMeGs
Received: by kanga.kvack.org (Postfix)
	id 724636B05B1; Fri, 13 Nov 2026 17:05:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701C76B05B2; Fri, 13 Nov 2026 17:05:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9D16B05B3; Fri, 13 Nov 2026 17:05:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD8A6B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:05:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7944F120275
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:48 +0000 (UTC)
X-FDA: 85431478776.21.3D42C62
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9CD44180005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qmGhMeGs;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794607546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cu+cTJ0hL/GwCE7XQ3GWlN1dT5x6HJrmKisyxShQ97Y=;
	b=hAzaHJnFlXhlZwntXBaPO75l9PT9Y2d5XfkyS2VIV9RmmLRxJFkh9VjU2TZTWIXO/ivTzp
	leewlzq4/aW42PcYz5UNAHRzgHW6jEYaKdpgSu4GvnRoeQmZHWlrZNtIYmlvo9IZfPm9Zh
	pidhUyYkWYw0YdJxX3U2cPDYPuxQTMk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794607546;
	b=JCIRfz5pN2QqAerKBu53o9g954gTScsJChul7na6ELyyc47Kd1L3w8uLQ2UxMprZ9IOysU
	b9BIFNMwR9WBow+HwzSBY3gn18hi+HJn/uEd3Q6l/zSB7o/JDCnj3dnPfGlzontd1nrmjQ
	2oYJfh/g32Jp/c9A/jP+dmp221IjC9w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qmGhMeGs;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b349d21fd1so11158377b3.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607546; x=1795212346; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cu+cTJ0hL/GwCE7XQ3GWlN1dT5x6HJrmKisyxShQ97Y=;
        b=qmGhMeGsVd7PmP+X+54LzV1BeK2a1iS/2v+FOUKdkZTjW7FjvDdkT9NqDWo9ugnLrF
         uG3rmxTzFswsnVcUFR2FVTjuX7C+/DZ8SjH2aTCiX6aHKVKO6kRfANirqLQXGkc20aCv
         7Nry23PHFvQoyj3AJcEtdu7ltUWk/MEuWnKObkZHdF3zwJTBKHl/0Ds+lCR1rnUsWWdA
         G8TSj/d8wm93DkFlMohw7X2Gf3R17KsPnlahaptWSFn5ypiE3oc05015MX0aDLhzHdoO
         ES5nRUyYuGGnyP/3Z7BnZWEcUCQ+dtnHI1AYsJp6uOuwA7N8nxjOKIaXwAuvmgnrDG5y
         ZsCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607546; x=1795212346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cu+cTJ0hL/GwCE7XQ3GWlN1dT5x6HJrmKisyxShQ97Y=;
        b=VgWWzgNZXycZzaJ44l3BKrSpCy40GIrb54uSK/OwUHqWtligKb6GdlFACb63HhEj3B
         j+34P6i3IMXNmHWgxvu/ZsfNaa7SSPxHcBD8um6caa3fkC/HVPDftH3NaQKx4vv1o/fb
         WP6Ks6ySeOBsIvvCReV+6s/rXshfrognNsuiEyLu9be2PDTYSq2jz7S0pDIBK5glJfny
         am8pq3il2oJUGxbj72AiEyYUXq1m+sNcxDvM28y2vkD4Y6YhKrQByWMG4Y1ID8mslMSC
         Ir8L86NHArJ4VLBNbP0njzGznxUJ7yWvAg06DWe+Lu7UCjO6hTKBFwJFyFmdtYGveSrQ
         luCA==
X-Forwarded-Encrypted: i=1; AL+hErFMhf45w/6hgju49RaxRI9FbEQTYIk3sIEXeQz99+AxcEMYjr/ZNr1irgnBJFSH1kZMseOpzEvhWg==@kvack.org
X-Gm-Message-State: APuU4Z9egGNQDtBwM6CRo5RE8vQ23zeIPZMx+GOFu/XcVv7H1cb5GYcC
	hNxUO8q7sWib91OsENTFAJg87MUE+k7McWLqK6yteW/m6+R9J5CA7TaI
X-Gm-Gg: AYBFou3Sl9ZoYD418g77ZSpejIhQIYCUkz2vRPBg5cIygz28Tc9ypl93NFu+lKJ4ref
	kZbXXO3SNRPjPIk7JoAwMcLpx5ezDtWwwDiPZpyK7RXBOpgCqNTHKZIAFXYWAcDmLQfnRA/3dCZ
	6KBxr9pCSOGhHEIZH9rOhKbL1Ggl/7+dDZw7IWjfZ0q+97JiVOs6euNOQXtBUsfhI4/HBIaf+Vk
	4IVPAK9rjy2UAC05N6H89LUbTipNOxru0wnYrht0hKREjTMQTOimxMIsE1+Xw5CN7LptAHAPKTV
	87hYn+y03aFAKN7TRR44r85kbXZjZhUlMNyR1JD2sFL37lQK48I203CSFIUerq6erZGRjuEYSXW
	N3j8ybI0PbdlNlcTwT+YsQdkpeEJ5VF6/Is0jskU2X8b6oHU1TYqr9qy9x4fF+8TdXvaL+S2mpQ
	uThl6vBN/azkQiAPJKs3U4XPTiFTWrn2P1qLjCFPUTdqr0pEHLCHBepZEAJUOeeX4/n7O4duKnQ
	XecpRTHNGvmd8otn0rE45Sslo2bh1dzmVjKk2QW91EVZolT9e4gYz3m8rV3qWDzstC/rT0Rgpqt
	OPXKDXuR8Y7+NSLlxIa3zb8jEIJwa//APxkUDib1qAbW9sk+UZ95JhVsMFs=
X-Received: by 2002:a05:690c:e3cc:b0:8b0:e13c:284d with SMTP id 00721157ae682-8b4aa2e997bmr20151567b3.49.1794607545154;
        Fri, 13 Nov 2026 14:05:45 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa8ea7c4sm31092547b3.10.2026.11.13.14.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:43 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Koutny <mkoutny@suse.com>
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
	Balbir Singh <balbirs@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v9 2/7] mm/page_counter: introduce per-CPU stock
Date: Fri, 13 Nov 2026 14:05:29 -0800
Message-ID: <20261113220539.2275715-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
References: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 43g4ssjksgq95b6bo4z67jt1gi4t4wq5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9CD44180005
X-Rspam-User: 
X-HE-Tag: 1794607546-408441
X-HE-Meta: U2FsdGVkX1+lcPTa38PNtup4WboWv0KZqq7YnUpBbQAXJR3DpDOGEDY3XvFgWBtRZxte6nP5ppAXZ4kUDhpZ7NpegYbpC6dhCfTxUKAfodxEgZLO2dfewVe4fg5Y4Wp2wKtgEkt5doCkVrcWHzuGSG5WVV0VMM1LjDVvjQrwlgip3TBETvfgj8tpJR/bsDx6m9vCJK8ncId3wgapT5abvqOTVxaAnulMy5feOYKCAh+0LVch0LT/pMv3nqQgAXdkaHiZ/sgMEYc1Zguq8rjzAsWEDs889mTwYnZktmRethIbxUMj/pX1Jf9KbHV5tuLfrx/ChjPLrM76rFmSAzPd9lCDnhcGkHHLXLB83gk5qpxhMiZT+FopqjPGQQr28XUISYT18s3Zv1ZHRO6G59zvc3GW53L3sYNmqMXQioGO8WF6IJ0SZw7K/k0UlHunF/ZwPEcQbXvOrPPF5mSXU37GnxuYz4hpiTEczgLZT7HOo+D1Qrblh/pn4Y5x8LSybYyIjUwnxCG+4xmojNvLRox+XTFDFptp+FbyZ4O8Axbl1mTUaXBQ5VC3MLaB9q/H4daDs6NNoPXChBmrSIQsn0onHeiV8JJ0z+V99fdKKTxOCFWq/BI30YIL9Dt9FAvckI00RzYZRxws6SAGoVcXry7ewjvk5hVfNqjuSva/+NGv8LzBwcgZCwhwH5sF2+bjCfAwqNui71JHO7/WphHGugj3BZkFT/GNjG+nqjeWIGVV7FMb3R19nZ2uZeoxw7MgEKLybwiiHKTq3FsWCIOzR8N8ZPTECGL/iRhfC7t+fco/W+Pvq1Pbn6v7H4+km8BIsyUmPCmgI9Tp9Rwq0rRx3lNMbtzgJED86jN4UIwxqxIAgUwyWNN2Jydxm8AN+khcjTKzEUy4D+gdt2ZQKpnC2KGU3mCmJYx2m0QkDkkR88hmlUMl9Im9iJ7s2tdFTfQCWsrfyyYsNO2mmJJY04lQzP1
 uz0i4fuh
 bF+v4am4k/FvFnn/Je6Omqak03IMhNYZbh5qcW1VmnGRqACEwNyck2sFcz6cYr21VMAqKvBT/stAUR+bwQ8BOl34x3HY6A07ArVvHHgHTNwonBaRmnXLBWWiDT6Qh8KT2frSIa7qSanmwvdRV1lim5LbzAG2RIOep73BCBduRNMP2MrwhwJqi/w/7W1hP1uG9HLgQAV3N09tcP170+bZvmHcC4fptUwgNNq2DW1Dbaw28V+ZbBq/8K7Y3Nx9l2ScW6tZyq2u3tNSTM6zsQVJOrqCFqG5yVR8lJKfm5FZHVDJiv7Z+0yHRzsrQnxsqWRlkiRgW3ucmOYUFZTeuvPabYhMBVad1y0WQwqksfOmy1waOTL8yjXM1ShDm5Mnr2o9Lmm7SgzZWV2oy0dTToqZa5Yuz0fkfIEj+afxxGy867Iv7sf0k1Mtr2tRhRnFcp7XnjaFeNHnQQj9NEA7HVYK4y96YaMepi9aHKLVU9tH85VyCyP3ZD9jJ8D00x1VU8vRPjNJibmuCfJOhaJ8lX8ckbFTkEYbn9qVNOyPTw22HesFyBX/pFyloLS2ZLOw+U0CHhDOSNaRnFKOndAWiN0WWAKyR+RUeCX8TOTL7TZOWJOA/UpY=
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
2.53.1-Meta


