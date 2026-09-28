Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69CD5CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4B626B009B; Mon, 28 Sep 2026 15:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD6B6B009D; Mon, 28 Sep 2026 15:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800316B009E; Mon, 28 Sep 2026 15:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 554FD6B009B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:23:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C927F802E9
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:23:56 +0000 (UTC)
X-FDA: 85264146072.24.D7AD3D9
Received: from mail-oo2-f38.google.com (mail-oo2-f38.google.com [74.125.231.166])
	by imf01.hostedemail.com (Postfix) with ESMTP id EEEAC40007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:23:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jr3dg4oq;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.166 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790623435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tK8/WIiTpcUHPrQYJYKTFLDFb/7dqUCiogR273O7EAg=;
	b=DotMlU807z/ZkOfBD9kVgGGhEWxNLmIXpW6Xb28Ee5v9QCCQ++p1hByMXA2bu0X4+L2u0R
	pq57gZHDTLpkNE1pQKtKLeQcK32Ly25pAYL5KC8uSjZKtjA5TQicl/yrCaKeD1m7KxC16D
	Twk6c8I16OKhQX/9bIb2B9a30x9uf/g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jr3dg4oq;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.166 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790623435;
	b=uIHWzvHgZW9rkrmpKY49+HNDCkUZmo7KpJggmnq+wdk1hKAFbbyHC9tAzlV0qqtVRlexPG
	2ygP2uVJ1zsk807f6yHYdeWYQyOJAnXjOk1/6vf0ZN5ThTjgZwJAqjAym33oy+ko/xnzKq
	u0pUGNehtZoVgfYH5R6V7PuMN+Xeeu0=
Received: by mail-oo2-f38.google.com with SMTP id 46e09a7af769-81be5042c56so1269204a34.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790623434; x=1791228234; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tK8/WIiTpcUHPrQYJYKTFLDFb/7dqUCiogR273O7EAg=;
        b=jr3dg4oqAjCmjqzNUQRCPRjG33FsfnnG9pqJ4onE2VTO+9e+38h6jdATR6bLT56eii
         /V8lTk5d8sS8KQCQ/LthaQRfG7LzSy33EiPhnj7LDsf8m/tMMP9tGbvhZnlTqtQWIMMB
         g6lTlqn7yR7Vm//zaVUdNBJuD0tJzzNoJq6GS68WiBQ0qTOfEEA4qBsBVV25BkJcyrpB
         LkrX/qK24g2dGOoy8EHiAbfEegCH7vpygzvZc+EMGGXYtmzXbQwgOQnsrDysRt0x77Vv
         Y4ADpIFcqEgmm09GzOHGiQ17IEuiTOG4uc3HEzKiaPHiq0Ufip974S7lhlcSDjiYrrC7
         0JVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790623434; x=1791228234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tK8/WIiTpcUHPrQYJYKTFLDFb/7dqUCiogR273O7EAg=;
        b=Zce+hANntGmITYxJhEN88tumAVVLaGtp/XyUQPTAKYsU/7L5ff7ahhf5h15EnObLZk
         UM2Ic72efGVxgdAmhrPgbZbeFR9sB77cLBbdyxTNHEtARlD1ETMLpE4b63+ledB7i1Ie
         BfEaIe+H0EVG0ALWp6IjsISxl2+YbU5rEbO0KHsLzpq6iT4vDlxhQzUjvhXmNleMnzUV
         EGrF70sZULf2lo8nOWL20/KK3UYhklCg8/ltXMImWEY0N/h4oep6XyfujIRzg/OomIv+
         +8pmtpgtGshCXo7Yz9x1oRenvCT9fy/IksQWETUBU6lGihI0rFu9021mBjyHtblAHdNu
         xceg==
X-Forwarded-Encrypted: i=1; AKwUvBxLZWPMQ9IFvy47/OuqxILzR+rD0aj6x0lHzulvHTCPN/6JSkAMq5ACMqb8xvmDqpO6B/fTtmbghA==@kvack.org
X-Gm-Message-State: AFuF++kasgaGatubJndrgVgmjD0+31S8fVcg2eg50U05MzXGSVdKbzUX
	7UOmKp3BeFklEvvi28BFd0kXZI3a77n0IyU+qfoEcoNylUBAadlmbNqn
X-Gm-Gg: AYBFou1+e2hZa+3Ax6D3ABfEhxhTlc0HGO7RUghow8yQ2QO9OihOAEWX01Ez4HcrH2Z
	RjscwKoBdxnlGPs7H4rj3H5fEm/CTAGz6/BrrCOu3VczO9dhDepdmOy1r/GyrEtyBJw6QuZ1r+0
	pKtEyWC/Zk/IVieVwPj3JnA1KyEUyp0ZhojNbsfhK844DT4BVX4qLPoEGqDf42C4x6JiPW3ePl1
	LTR/xfP2PFwHz8cBtxDphrn2333lpTTiPju/6daKXg3e5aKHO4pRk8VMd4F78AscO2t+82/aeJJ
	wqfLhliqXWNlgL5jV8A4gakl4Kle0bvKx3oUXCGXg1qRhn3tUeWyV/9zfqBc1Mmq+rowMyBgo3a
	csD1L58pGIpM2nDwFwHOtWyRxgM34uj6hyGdPCMhUAGpeIsEAoJ20IqZXzPFxsRbgsG6IrrwmA+
	ifyXx/V1fuxlCmqA5ZkrOkhcQleiDtVnwWdtqDmtPTtg1EFdraeJTxVZ+x2ssVFeuFVde6wwbLB
	XeiaSApvvRXvjavOPFMQyA5EIIkrw==
X-Received: by 2002:a05:6830:2406:b0:7fa:ab72:9e01 with SMTP id 46e09a7af769-81917a258demr11321224a34.25.1790623433738;
        Mon, 28 Sep 2026 12:23:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4b::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-81d5901ac3esm2430499a34.26.2026.09.28.12.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 12:23:53 -0700 (PDT)
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
Subject: [PATCH v6 RESEND 3/5] mm/page_counter: make page_counter_try_charge() stock-aware
Date: Mon, 28 Sep 2026 12:23:46 -0700
Message-ID: <20260928192349.3432886-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
References: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6hk8aip1tzwookuphmukxff67o9s5ewb
X-Rspamd-Queue-Id: EEEAC40007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790623434-129477
X-HE-Meta: U2FsdGVkX186rjTZcux/Uikqbs8ruso4eZenrsuU4d/JKUtU+WWdRlnfmyrouf7aAj0StdoDQCuvPezPoCnbd2gasJYHrymmjDbmPca60Behj6F5u3LtPvgzeEL2ThhSSKvzmiL467Ocz0Z8P+/hUoQbCjg2gBaCw5XT8EdQFKN/ALMXnbyIezRwJ/lcSubkdf04zZ+o54rtSpEHz5UKV9GoF81a3pZOwwwc+tS1O9OcwcM95BmOYIux7Svq13CUSTefDR6/WpuvuIgrBrwfk7yirKbLZwOgJ2vNC5lcguc2kS2XT3iXF3shu3a/ycjT7fMh6N2dVswoaD4ed2kMOvDe7MTXLj/ih1SFcM/suRJ5ke1U/4sJMqfyJkH94fxIor9JKuO4nsFWTNpfU22VeGuTiicT6wztYNwLPuWAltHa1uyntI1XB6tJB2wSrkrC+lpusswWVL47a16Czgv3Pvs8dgKft/RsEtZriYCW0Yjr9pyaf59BEg+DJsv7hL13MYhXWOjfuqoWIYBo7il3uf8akM3UY/BSbKtlGb96EBST0BUnYVbck137QkTLamlvlSAnq4r69V9JVpUmCdoXGTNtUYIjH0W9j4H885IZbVdOF/+zjbxyU30S5Xj5rY3MV0SPWPGlWUKb13wo//X0hNZD45On7UG5uXEQk/4PPKaUTCcKYoxlpNVlkK+GEhExUWfUX13lkSl7XOJQ6VwfB83AlTt7K+QzIJfqbx5lu7yjxihwbTpSZakvNvdm/HZybMkPrPqk+vPgcVcmfCf7xnxy5HsCXwzOLZVz9FwVCSaYP4qEwlDlFN001U1/xmakIR949PjayIPh50H2Bfegq/PLbWwdZ5Pu/cYLEe9tlIMV7M9HekRTkc/24x79egTWyRZZv8T+LVYqyUWfzXaeEQyj5q9cc9lltjiFIlgf8i5CH7bftA/q/ZlcCXDqV4tQ+EVolopWAj+3qj4qA/U
 zpkgRYqf
 8tgf47YG/C3GQJ82AqBsxW8sNk5q95Ta5w9I8EdYl/gwaj1sYL+rYYX35c81OgG/pLpnJ6Uu7oRDfAXLLlZLM6IZ3d/4SXvrrXXCU7g+O/Z40dE9hLpa6QCuYXqUUy5uu9SbHIP7nEo4rPAzJcuTNg+eClF7Lx8d1XEEyZ2rpC5dQr67tBWHnsuelhVa/rmnlJCPGBjS9fidnTp5szsu+UVpMD8uDezNeHusGgHS1iYWvB9EyFAM+lqLjWTKpFAfFS7ffiUNhwgy453c8bC9MLUdwqMbXWe7yxQ4H4TmbDJ6yGX6JwHhZS6vXg1phZF64dXBHoMOGSAFgwXsNEFApFBHvzCU5ixVInVQCcd4omIeNnW5+xUx04gJLQsQjeDNh2MlVimXMeV/AM+M/pUPpb4uLue0B8H6mDCuRBGEvyUw1/Bb8GCXN20Gx8mwN4QgXe5JTD8c0Sw77QtXMXlnlFlx7aSLuHaEV5X4zFNb2P0KzSksYjCSxWNk7uhXLH5n5FR/gnHX3utBhNonCZxX2GzJXGENGSEDdu6+LZh92imqjcns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make page_counter_try_charge() consume stock transparently to callers
while preserving the same semantics as try_charge_memcg's greedy
charge attempt, refill, and !allow_spinning special case.

page_counter_try_charge gets two new parameters, may_batch and
nr_charged.

may_batch is intended to preserve the behavior of !allow_spinning
scenarios in try_charge_memcg, where the goal is to charge as quickly
as possible, without evicting other stock slots or making a greedy
charge to refill the stock.

nr_charged is used to reflect the size of the successful hierarchy
charge, preserving the existing batch-based memory.high accounting
for current->memcg_nr_pages_over_high. As with refill_stock() today,
the full charge is reported even if the excess is later uncharged
because the stock could not accept it. This only affects memory.high
throttling heuristics and never fails a charge. This behavior may be
fixed to properly account the net charge in a future follow-up.

As of this patch, no page_counter has stock yet, so there are no
functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  4 +-
 kernel/cgroup/dmem.c         |  2 +-
 mm/hugetlb_cgroup.c          |  2 +-
 mm/memcontrol-v1.c           |  3 +-
 mm/memcontrol.c              |  8 ++--
 mm/page_counter.c            | 82 +++++++++++++++++++++++++++++++-----
 6 files changed, 83 insertions(+), 18 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index cf627c5090093..58532259e7f59 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -98,8 +98,8 @@ long page_counter_margin(const struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
-			     unsigned long nr_pages,
-			     struct page_counter **fail);
+			     unsigned long nr_pages, struct page_counter **fail,
+			     bool may_batch, unsigned long *nr_charged);
 void page_counter_refill_stock(struct page_counter *counter,
 			       unsigned long nr_pages);
 void page_counter_drain_stock_fully(struct page_counter_stock_pcp *stock);
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 4683f3d680226..569307aa4bd62 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -736,7 +736,7 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 		goto err;
 	}
 
-	if (!page_counter_try_charge(&pool->cnt, size, &fail)) {
+	if (!page_counter_try_charge(&pool->cnt, size, &fail, false, NULL)) {
 		if (ret_limit_pool) {
 			*ret_limit_pool = container_of(fail, struct dmem_cgroup_pool_state, cnt);
 			css_get(&(*ret_limit_pool)->cs->css);
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 3fb41311e4c7d..bbc2dd3fa3c97 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -304,7 +304,7 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 
 	if (!page_counter_try_charge(
 		    __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd),
-		    nr_pages, &counter)) {
+		    nr_pages, &counter, false, NULL)) {
 		ret = -ENOMEM;
 		hugetlb_event(h_cg, idx, HUGETLB_MAX);
 		css_put(&h_cg->css);
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index b7f2868885071..a146e54c6f9f7 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2193,7 +2193,8 @@ bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 {
 	struct page_counter *fail;
 
-	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
+	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail,
+				    false, NULL)) {
 		memcg->tcpmem_pressure = 0;
 		return true;
 	}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index edb2da5a326c5..53be4365e2c9e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2722,13 +2722,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter, false,
+				     NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+	if (page_counter_try_charge(&memcg->memory, batch, &counter, false, NULL))
 		goto done_restock;
 
 	if (do_memsw_account())
@@ -6026,7 +6027,8 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 		private_id = mem_cgroup_private_id_get(memcg, nr_pages);
 
 		if (!mem_cgroup_private_id_is_root(private_id) &&
-		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter,
+					     false, NULL)) {
 			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 			mem_cgroup_private_id_put(private_id, nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 77624b00b5f94..e48ef37016c50 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -136,23 +136,76 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 	}
 }
 
+/*
+ * Consume the cached charge if enough nr_pages are present, otherwise return
+ * failure. Also return failure for charge requests larger than
+ * PAGE_COUNTER_STOCK_BATCH or if the local lock is already taken.
+ */
+static bool page_counter_consume_stock(struct page_counter *counter,
+				       unsigned long nr_pages)
+{
+	struct page_counter_stock_pcp __percpu *stock = counter->stock;
+	struct page_counter_stock_pcp *pcp_stock;
+	u8 stock_pages;
+	bool ret = false;
+	int i;
+
+	if (nr_pages > PAGE_COUNTER_STOCK_BATCH ||
+	    !local_trylock(&stock->lock))
+		return false;
+
+	pcp_stock = this_cpu_ptr(stock);
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
+		if (counter != READ_ONCE(pcp_stock->cached[i]))
+			continue;
+
+		stock_pages = READ_ONCE(pcp_stock->nr_pages[i]);
+		if (stock_pages >= nr_pages) {
+			stock_pages -= nr_pages;
+			WRITE_ONCE(pcp_stock->nr_pages[i], stock_pages);
+			if (!stock_pages) {
+				css_put(counter->stock_css);
+				WRITE_ONCE(pcp_stock->cached[i], NULL);
+			}
+			ret = true;
+		}
+		break;
+	}
+	local_unlock(&stock->lock);
+
+	return ret;
+}
+
 /**
- * page_counter_try_charge - try to hierarchically charge pages
+ * page_counter_try_charge - try to hierarchically charge pages using stock
  * @counter: counter
- * @nr_pages: number of pages to charge
- * @fail: points first counter to hit its limit, if any
+ * @nr_pages: number of pages requested
+ * @fail: points to the first counter to hit its limit, if any
+ * @may_batch: whether a stock miss may trigger a batch charge
+ * @nr_charged: optional; set to the hierarchy charge size on success
  *
- * Returns %true on success, or %false and @fail if the counter or one
- * of its ancestors has hit its configured limit.
+ * Return: %true if the request was satisfied. A failed batch charge may update
+ * @fail before an exact retry succeeds.
  */
 bool page_counter_try_charge(struct page_counter *counter,
-			     unsigned long nr_pages,
-			     struct page_counter **fail)
+			     unsigned long nr_pages, struct page_counter **fail,
+			     bool may_batch, unsigned long *nr_charged)
 {
+	unsigned long charge = nr_pages;
 	struct page_counter *c;
 	bool protection = track_protection(counter);
 	bool track_failcnt = counter->track_failcnt;
 
+	if (counter->stock && may_batch)
+		charge = max(nr_pages, PAGE_COUNTER_STOCK_BATCH);
+
+retry:
+	if (counter->stock && page_counter_consume_stock(counter, nr_pages)) {
+		if (nr_charged)
+			*nr_charged = 0;
+		return true;
+	}
+
 	for (c = counter; c; c = c->parent) {
 		long new;
 		/*
@@ -169,9 +222,9 @@ bool page_counter_try_charge(struct page_counter *counter,
 		 * we either see the new limit or the setter sees the
 		 * counter has changed and retries.
 		 */
-		new = atomic_long_add_return(nr_pages, &c->usage);
+		new = atomic_long_add_return(charge, &c->usage);
 		if (new > c->max) {
-			atomic_long_sub(nr_pages, &c->usage);
+			atomic_long_sub(charge, &c->usage);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt which is only used
@@ -192,11 +245,20 @@ bool page_counter_try_charge(struct page_counter *counter,
 				WRITE_ONCE(c->watermark, new);
 		}
 	}
+	if (charge > nr_pages)
+		page_counter_refill_stock(counter, charge - nr_pages);
+	if (nr_charged)
+		*nr_charged = charge;
 	return true;
 
 failed:
 	for (c = counter; c != *fail; c = c->parent)
-		page_counter_cancel(c, nr_pages);
+		page_counter_cancel(c, charge);
+
+	if (charge > nr_pages) {
+		charge = nr_pages;
+		goto retry;
+	}
 
 	return false;
 }
-- 
2.53.0-Meta


