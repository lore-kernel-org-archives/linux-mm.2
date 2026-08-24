Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B5CC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327116B0096; Mon, 24 Aug 2026 10:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D73F6B0099; Mon, 24 Aug 2026 10:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19EE66B009D; Mon, 24 Aug 2026 10:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAC4B6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:49:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75139C019C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:49:23 +0000 (UTC)
X-FDA: 85136446206.07.EFF64AD
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id A7AB0A000E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:49:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IPKpcvpS;
	spf=pass (imf15.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787582961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJghNqQ8GHnzdXaTAtv+ShGeZ67uYvDYnO7pv3lrswI=;
	b=cUO/M2hG77QwsnvntfZR/VyTx34+cktWSjy8PdU7QF7ryTQaZqZHjyZwJbXzNP7cVC6H0e
	w2E968C41efEHbhrxI/QcMYxpvxX6PGBEchHLHlLgwl9ukZH7u4oqI0IXz7z9G6Y+XEhR0
	AlbqKJTcqcN66s04xYkdiYx0M0tT5Sc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787582961;
	b=n90mzqFmm5hqcw6tKN6/UiygyJdKzK0v/xnoDPEAdmiUURaiQAsyvcWx8sdMu4rLtSdMlI
	CCfxhj2YouCJwmKWpBjYRwgs5A7k0LUoJao+Xz/fr6GchHmLLpq9qVDUbr+dtnF+vf9YGZ
	B4biR90VMei38MgAzJwiPxrzTy0YYlQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IPKpcvpS;
	spf=pass (imf15.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-836c5b01e82so47910407b3.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787582961; x=1788187761; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bJghNqQ8GHnzdXaTAtv+ShGeZ67uYvDYnO7pv3lrswI=;
        b=IPKpcvpSB12XfBFH6D4Hm8e0VZJEp2frs+5xhGO9Q7OOP4MtyknMIfAVLPac8jTulh
         igPICLVkPc2hgYNn5ec8LE/975nDTnROy/y/PXw/zm+R0+4syPrKoEfthLbjk0CrcnZa
         eZcS/BDKGuHVvaayf4BKA4qIkCpRjyQ8znvm2PfIfh89EZkAmCxIlzceOd5Y9/4myQYE
         SJQHlibZ7YAM+hQvxNtBalt1hloeRr6Z5yIPOFjhhrqFIHi5Dia2t6SWr8pfJjERJnV3
         GZK6bC12dRrzrJmhjdYh1J6mIDQWKpQJIN6P1VZVJvvX8zGSnNg4nW1y8m41pC+dmxBN
         iC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787582961; x=1788187761;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bJghNqQ8GHnzdXaTAtv+ShGeZ67uYvDYnO7pv3lrswI=;
        b=mDbj7ggwWMBCMkastpYRWh+TtggMLewCYnUPLvNHOd0Tz/mAJGlSucC7Se/hN5WZrj
         RNcwBsVaA3AuIQWDGYDgbnDS0ZI9NlSqe8+ZNmwpQxrX2DqHQHn3RylfAHrB1nQjDD+2
         zMmDgwkGcpBc8uClrBDH8IK0Rg617cz1pu/jQF+UYi+nLmJkCpDCl4K7t9opeHAK7bzY
         J4cc2lF5e2d+DMGtPKAt6hlaT5jM8lCIlc7yyrqFwPUEU2cRrZ3me8+6oVcB1EqDXlbN
         Ch4LVLdLFU/2B/uHGAjwjk6QCz2CP+lSsit+8N/vIwXHuekpRREc5+VIX8ky9jvOihhn
         n0EQ==
X-Forwarded-Encrypted: i=1; AHgh+RrJjsbz21JKdip5PMFmqzOiVXyvFqGAzfjqf8k5mpsx1iy/9DSiTP5FeocH7/IhtokQkujIMiuo5Q==@kvack.org
X-Gm-Message-State: AFuF++kSd1bTq9n9rGmDK+nGjTsSm1BwrzH0ZiOBK280IT2LDqxO3uJG
	Txhl3udDpJNzUVcC1qP2t1t/7afFoUBGPdBCm8HJBqfpwfpp69s0K4aYVuBzqSYyLg==
X-Gm-Gg: AR+sD13jcu71SpPP3RPzccKbt8PXCqEMGE3PF4RKqCpHWu4iC0oc99CaMre9yC3Dm5O
	6N56KRPutRf05NVEG2qiImijx0gV61vrC+2FPpi96qegAlgw6Ob4bz3+LOvPMIJpMoalzIdNJCq
	Jx7fzk072sF4f7BA/DQV7m2BNHzt1XE+mQubDmbIxtcIKKwSLMRiMPgpQxkcreRKSH/f9doB4AD
	wBYjCuvyUGAl+oFzD8t0AVJkdlXzA2jHq0UlZEOnIBU1TVjLk+O5MjEL75VTBWc+jJh2LMA7ke5
	6kZe7dA5AnoCErs+vsC1LKothN7UgeyK47tVacg82/1C39E4gGoNi+pjb6CGUIUYgm3fehI1OKD
	Gdf1E0k17aXI85YDR6SZwj1JBaytZxfuACAl1a/9TGVaVZ8zeUDYBDi2vZhj4YiIX9op4WI7xql
	0hJHjSF15w3GqCX2E+h8yVk6xno4ViwGs6Q8us/Hr9R9u3k6UM+lqsG67Fe+iuxqGIw/WXjk0zF
	szRS0IEHeTuF7Gira6NpzxgK8K+mAyCq7QG2jwTpvInJ+m1wEbhYZirJtw=
X-Received: by 2002:a05:690c:e1c4:10b0:820:1281:8deb with SMTP id 00721157ae682-849f08113c4mr88243297b3.8.1787582959923;
        Mon, 24 Aug 2026 07:49:19 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84cab854483sm34302067b3.33.2026.08.24.07.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:49:19 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:49:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 24/25] fs,mm/fbatch: lru_cache_disable() keep off buffer_head
 lrus only
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <9dde166b-c9b8-9f09-03ef-6c15a26cbc77@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: zghoykc5waransm6pek745ckn9y5jrnc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A7AB0A000E
X-HE-Tag: 1787582961-92582
X-HE-Meta: U2FsdGVkX18P+lwBJxrJVwwiha2Sw/v1l07cFG+cdD46xK9bIZEJykIs2ipg7svOMNcP2REBRqKTfbdBtcLXSRrTmGf64jdGU8Rwmf7FEALtZgR1ru9VGAzLgEdlIBfnXkxz0Oc1F0Wzg0yEeS6xUqLtAbYkwXswCVuQUy2xG7g8kIaVsLzgZb+pgUw98nPYuA1bH9S/8gt726Qt9BYbtaenb2xJNL86wCI1QLKAM/ehre8RxOVioztuka3UQI3L3kCLuHXKjhi8a/lF+7V0frZ45PbTGCpacHJzivmJUlUq+PKp42Df/7UTT/Tv6NXYcSjqntIjHZKvN4yAHd2KK2KhjbErJy3w7FWUuVVLBU0b5EjaJ/P9HOhp0OmQo6n8s3fawjV9svCxBMmMWk3cbrSIWEM9tDgMkP6AfXE3CipmUHZ57M78auvQgEZCazeC1oqtNRZdaVdRkx8kgJGqFNX9u3z6oRwUZThGpYNrSRwxpYJu9D4NaTrBMyMl55e83ICtk3zz+wjvy+j4al/a1Qcs17QOxaQs7t+qfDx6GSEAZYaw+llon4iVp/vdaMx3RN1EPev+PtkJroOqSai8WTXEYBcbjcV/XbRguHm1Wgb/lsXIeBTGm8Z91Ngx95pEgfdE70zcjOipxXW0Rkcin+IKyWPvfp6IT/dgr20gT5pwMTE2he0Hoq6nXAAfm3j7RN9RCv0WaBKzsVd2JjZpO9YospSEF/k14gQzzmTFacDu2pgsVoNEukxPZVMkFM+cNLgsYQfJnCh4p7Yg8Rb2e5iVid69WWlOUNhbpYQTWjwBCBJ7zrvG7Mis7yCjiz58r44K5MATfdOrzl8KhAl7c1wpd0AGLAIGBZtRIM2J4JmmjVJnuwr/PwldjVJD/Kq6kzc0c9aF3qMf8RiWJwU3kDYFiGTLk2Dl5/3PSsYJUAsvPsXYJLFprPdwkgWGclbFibrl9eZ0mw/6slbOmHz
 Mb9V9tPD
 h3G+yuDfNfXKW05pxFHwynpgOMr5ynRmoMZ9zKMSfzgcUkeIzAjr1ibEiswwuw0L6VL7/1Vd/7IdXJ1q/ykKD3y2r0CwyXCBepEfh1NH3UwGr5uC/hJEySQmlG5TeZST9pQMbbuXKRbBm2Q/auazMaGsCjvyGQFgpjgneRS29MjUPx/1Z4pqzE9wbGiBTATZzbcAF1Pn8eZ4C3RrI+FuRcPd5o3bMiONFz1PkfRjkx0tT1s2IcfVGIiIx1QM689257xikb9zDP3L0yA87jb6yXeJNqJupq/lq2x3SIxVWAlQMKqK+v+g3eNeI/VF2I0M4bpN0ONPV9u9AK/YCGxY7dvmTTxp3XEvTye84j91GQD9Yd73XmEdYr9nvwmd0ee+ktHpI73mhmtD7DFayHDt0/Mx+9jFIyfTsut7hInjjzk4EmdqN7FxCw0+PoiHPyZLOg/Kf7iCOclLC6ECOiE7PVGDU730/q6NomEhZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the per-cpu fbatch folio references are gone, there seems to
be no excuse for lru_cache_disable() there - other than offline_pages()
needing to lru_add_drain_all() to erase stale pointers from the fbatches.

Remove lru_cache_disabled() checks from all except bh_lru_install():
assuming that lru_cache_disable() might have value in preventing repeated
calls to invalidate_bh_lrus() when migrating folios in memory hotremoval.

So move all that from mm/folio.c to fs/buffer.c: but I can't see how any
of the paranoid synchronize_rcu_expedited() business is needed now (or
even before) - leave it out. And back at the mm end, lru_add_drain_all()
does not need that force_all_cpus either - it stopped forcing all cpus
in 5.18 commit ff042f4a9b05 ("mm: lru_cache_disable: replace work queue
synchronization with synchronize_rcu").

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 fs/buffer.c                 | 24 +++++++++++++++---
 include/linux/buffer_head.h |  4 +++
 include/linux/swap.h        |  7 ------
 mm/folio.c                  | 49 ++++---------------------------------
 mm/internal.h               |  6 -----
 mm/memory_hotplug.c         |  4 +++
 mm/mlock.c                  |  4 +--
 7 files changed, 36 insertions(+), 62 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 7d114e5b9c62..7455a11dfc4a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1200,6 +1200,24 @@ static inline void check_irqs_on(void)
 #endif
 }
 
+static atomic_t lru_disable_count = ATOMIC_INIT(0);
+
+void lru_cache_disable(void)
+{
+	if (atomic_inc_return(&lru_disable_count) == 1)
+		invalidate_bh_lrus();
+}
+
+static inline bool lru_cache_disabled(void)
+{
+	return atomic_read(&lru_disable_count);
+}
+
+void lru_cache_enable(void)
+{
+	atomic_dec(&lru_disable_count);
+}
+
 /*
  * Install a buffer_head into this cpu's LRU.  If not already in the LRU, it is
  * inserted at the front, and the buffer_head at the back if any is evicted.
@@ -1215,9 +1233,9 @@ static void bh_lru_install(struct buffer_head *bh)
 	bh_lru_lock();
 
 	/*
-	 * the refcount of buffer_head in bh_lru prevents dropping the
-	 * attached page(i.e., try_to_free_buffers) so it could cause
-	 * failing page migration.
+	 * The refcount of buffer_head in bh_lru prevents dropping the
+	 * attached page (i.e., try_to_free_buffers), so it could cause
+	 * repeated calls to invalidate_bh_lrus() during page migration.
 	 * Skip putting upcoming bh into bh_lru until migration is done.
 	 */
 	if (lru_cache_disabled() || cpu_is_isolated(smp_processor_id())) {
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index f19f9e80be8f..3b6a41b7932f 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -517,6 +517,8 @@ void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping);
 bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
 void mmb_invalidate(struct mapping_metadata_bhs *mmb);
 int mmb_sync(struct mapping_metadata_bhs *mmb);
+void lru_cache_disable(void);
+void lru_cache_enable(void);
 void invalidate_bh_lrus(void);
 extern int buffer_heads_over_limit;
 
@@ -525,6 +527,8 @@ extern int buffer_heads_over_limit;
 static inline void buffer_init(void) {}
 static inline bool try_to_free_buffers(struct folio *folio) { return true; }
 static inline int mmb_sync(struct mapping_metadata_bhs *mmb) { return 0; }
+static inline void lru_cache_disable(void) {}
+static inline void lru_cache_enable(void) {}
 static inline void invalidate_bh_lrus(void) {}
 #define buffer_heads_over_limit 0
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index f21e1dd6febc..ddfd9b7bb861 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -305,13 +305,6 @@ void lru_add_drain_all(void);
 /* linux/mm/folio-compat.c */
 void mark_page_accessed(struct page *page);
 
-extern atomic_t lru_disable_count;
-
-static inline bool lru_cache_disabled(void)
-{
-	return atomic_read(&lru_disable_count);
-}
-
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 long remove_mapping(struct address_space *mapping, struct folio *folio);
diff --git a/mm/folio.c b/mm/folio.c
index 3212c7a58623..dac2f2d5dcc1 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -173,7 +173,7 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		local_lock(&cpu_fbatches.lock);
 
 	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
-			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
+			!folio_may_be_lru_cached(folio))
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
@@ -501,7 +501,7 @@ void __folio_add_lru(struct folio *folio, bool mlockit)
 	smp_mb__before_atomic();
 	folio_set_lru(folio);
 
-	if (full || !folio_may_be_lru_cached(folio) || lru_cache_disabled())
+	if (full || !folio_may_be_lru_cached(folio))
 		folio_batch_move_lru(fbatch, lru_add);
 
 	local_unlock(&cpu_fbatches.lock);
@@ -786,7 +786,7 @@ static bool cpu_needs_drain(unsigned int cpu)
  * Calling this function with cpu hotplug locks held can actually lead
  * to obscure indirect dependencies via WQ context.
  */
-static inline void __lru_add_drain_all(bool force_all_cpus)
+void lru_add_drain_all(void)
 {
 	/*
 	 * lru_drain_gen - Global pages generation number
@@ -810,7 +810,7 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	if (WARN_ON(!mm_percpu_wq))
 		return;
 
-	trace_mm_lru_add_drain_all_tp(force_all_cpus);
+	trace_mm_lru_add_drain_all_tp(false);
 
 	/*
 	 * Guarantee folio_batch counter stores visible by this CPU
@@ -837,7 +837,7 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	 * (C) Exit the draining operation if a newer generation, from another
 	 * lru_add_drain_all(), was already scheduled for draining. Check (A).
 	 */
-	if (unlikely(this_gen != lru_drain_gen && !force_all_cpus))
+	if (unlikely(this_gen != lru_drain_gen))
 		goto done;
 
 	/*
@@ -883,11 +883,6 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 done:
 	mutex_unlock(&lock);
 }
-
-void lru_add_drain_all(void)
-{
-	__lru_add_drain_all(false);
-}
 #else
 void lru_add_drain_all(void)
 {
@@ -896,40 +891,6 @@ void lru_add_drain_all(void)
 }
 #endif /* CONFIG_SMP */
 
-atomic_t lru_disable_count = ATOMIC_INIT(0);
-
-/*
- * lru_cache_disable() needs to be called before we start compiling
- * a list of folios to be migrated using folio_isolate_lru().
- * It drains folios on LRU cache and then disable on all cpus until
- * lru_cache_enable is called.
- *
- * Must be paired with a call to lru_cache_enable().
- */
-void lru_cache_disable(void)
-{
-	atomic_inc(&lru_disable_count);
-	/*
-	 * Readers of lru_disable_count are protected by either disabling
-	 * preemption or rcu_read_lock:
-	 *
-	 * preempt_disable, local_irq_disable  [bh_lru_lock()]
-	 * rcu_read_lock		       [rt_spin_lock CONFIG_PREEMPT_RT]
-	 * preempt_disable		       [local_lock !CONFIG_PREEMPT_RT]
-	 *
-	 * Since v5.1 kernel, synchronize_rcu() is guaranteed to wait on
-	 * preempt_disable() regions of code. So any CPU which sees
-	 * lru_disable_count = 0 will have exited the critical
-	 * section when synchronize_rcu() returns.
-	 */
-	synchronize_rcu_expedited();
-#ifdef CONFIG_SMP
-	__lru_add_drain_all(true);
-#else
-	lru_add_drain_all();
-#endif
-}
-
 /**
  * folios_put_refs - Reduce the reference count on a batch of folios.
  * @folios: The folios.
diff --git a/mm/internal.h b/mm/internal.h
index 9a25552cbd83..7a301c401d39 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -56,12 +56,6 @@ static inline bool folio_may_be_lru_cached(struct folio *folio)
 	return !folio_test_large(folio);
 }
 
-static inline void lru_cache_enable(void)
-{
-	atomic_dec(&lru_disable_count);
-}
-
-void lru_cache_disable(void);
 void lru_add_drain(void);
 void lru_add_drain_cpu(int cpu);
 void lru_add_drain_cpu_zone(struct zone *zone);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 226ab9cb078a..19756c45b5e7 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -24,6 +24,7 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/migrate.h>
+#include <linux/buffer_head.h>
 #include <linux/page-isolation.h>
 #include <linux/pfn.h>
 #include <linux/suspend.h>
@@ -2095,6 +2096,9 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 
 	} while (ret);
 
+	/* Remove any instances of the freed pages from per-cpu fbatches. */
+	lru_add_drain_all();
+
 	/* Mark all sections offline and remove free pages from the buddy. */
 	managed_pages = __offline_isolated_pages(start_pfn, end_pfn);
 	pr_debug("Offlined Pages %ld\n", nr_pages);
diff --git a/mm/mlock.c b/mm/mlock.c
index 971430e6251e..a3cfdb274fc7 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -247,7 +247,7 @@ void mlock_folio(struct folio *folio)
 	local_lock(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
 	if (!folio_batch_add(fbatch, mlock_flagged(folio)) ||
-	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
+	    !folio_may_be_lru_cached(folio))
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -278,7 +278,7 @@ void munlock_folio(struct folio *folio)
 	local_lock(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
 	if (!folio_batch_add(fbatch, folio) ||
-	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
+	    !folio_may_be_lru_cached(folio))
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
-- 
2.51.0


