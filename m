Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4C1C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1DE6B009F; Wed,  9 Sep 2026 06:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B886B00A0; Wed,  9 Sep 2026 06:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4B56B00A1; Wed,  9 Sep 2026 06:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 566206B009F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:33:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F481C0192
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:33:19 +0000 (UTC)
X-FDA: 85193861718.24.3845314
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf17.hostedemail.com (Postfix) with ESMTP id D6BE340009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:33:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O7ETnvxm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788949997;
	b=1kKXbC4OizgwLdljquV+kjocXttzisowonVCgQvGjq6u0BoR6cXxhLQ17lhJaISQqsG029
	kTyFxyVp0dHkJP1xVYcy5dStxiQTC/Htd8cqRQ4ni0LvD/10mieCuTcNM8d7ZJMaYSKPJG
	DFnQEOMVkk6ueCk85DH4T2TrDlqPJsg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O7ETnvxm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9XKIfsbwB2WTm2tTUcIYzMdzj76RrLfvaApBm113T1U=;
	b=YClrHADbsLEcE7SXCI2ZFZf9CXax0/z0zzD36rB2fVPDGct8lrw27ItYXsPr7p/wDY3qYh
	A9PaIpgKBhRKYLFa7oSPHOu56gmmPB2vFzcvF65qlxN4fKOEwoPJTNEhKPGqZCAyMtBllX
	i+AwDDGS0dq0v3AFNZOtJ5A6UrWQv3I=
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d46e4cdcdso9727267b3.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788949997; x=1789554797; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9XKIfsbwB2WTm2tTUcIYzMdzj76RrLfvaApBm113T1U=;
        b=O7ETnvxmbexi668OGZbgTGaS6DJNcd9OLn1Y70m/BEYwpFObXxl7INpzG2QziqOdfR
         UQuJuvCAjKzvjtFcZyiyV61HF7dx1kHwAsU547GGrOPm46YqyGzc9BPU6jStT2tnwEbW
         NsLYclEJnq15LZik6436IPjHm4byjuGu7JUITaRcmKwfuEr4tK5avQTAAFEXSJMbU0ap
         //Y6jdP1wzrRX8qT4VNNudOS4a7LQsrZX9S1yj6WtOopfOApbZyYazh1v+urBr2VWqAo
         A4TJxTYfc63AJTo95zNMetSPibwJ5BnPegbYXKMo3pxRFzFF0SyBg1v9878MmBUYWAtU
         Qo0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788949997; x=1789554797;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9XKIfsbwB2WTm2tTUcIYzMdzj76RrLfvaApBm113T1U=;
        b=lsSLovMYrLPrDi0VzYVdkwblziP990xgS9i9p9Zf1h2chO1Ynfhgzx3L5UMVffdnTn
         oxO+WhjremksGdITj8Haa/IT+BA1UUz0sqlgTgGRX0cVWftaBapDquHuLqDnWEBAzClw
         shSegY9QX6ReXyatBhLL2HUw3G28uNLNrLfaFOFRj8suaPtRpyg5YJS4VJE9XXeII0rq
         vyr3tNJj9F1QSF1YNjTOIh8p/2ofElookKM1JlsvCVRowp2diLfjH7hk7fRcdiLjOFqp
         BkVKKw//vlTjEEoVtOXWutbgfvesZiWST4DtRnbXktwqxJ75M/prmZudlOkTiJybvlqH
         6RaQ==
X-Forwarded-Encrypted: i=1; AKwUvBzUjofHBpUGvvKpk+t/CAt/ForXBydqRZRbZc66Fqgl8FCs8JUL1p8sCGt5AnEl2k67syn9XO50sg==@kvack.org
X-Gm-Message-State: AFuF++kbMyXLKT0Yb3Dul4F6zniw/6eBGBjzeNAAd0YQm3iBY6BOg8kb
	8lv75StTDbWeUqGcSY1ZnkBM2K9airIvsmaB03sHoTlBCQpk1RCJ9CZBP18YAhFgfw==
X-Gm-Gg: AYBFou3V+ssSKGjLWb6JDK9v6gKBg0OV+D3/w4mU5k4rCXMvoVVZFFwdWKIQ0pWK5AZ
	H6+wLrw2pczL1WuVayjavU8NDSFGniNBsqxzp98v9KnsfvUqnFC2x4mZXu8pl86/U6tqA/KbvKe
	sDUNLV05xlfXT1jmwxGqsuzxwhEbwcV3gTa+hE4uMqyZ56HL+Ap7M9i179xyMwDdfofPfTWCbni
	i4oI2rE60BmaKeJ8IWi9tCsDbfyrnKD035joTQ0fynDplJ1LviHq9mPF+uQ1lc3wI0Cy3w/NuzU
	VUy0YeIVo8qP8TFJ4UQMIrFRYiVAjG1tdUMTVY9vIPsfdo8yUwZI/IUyZXSZQrJ8gd0g0FJ4/u2
	Of9p9M3iaTXLj1zcAdMm+W4daeWW7dKjkb+1GAgrD89MzliNEcFw471EzK1rs7sATZzg0E1B9hE
	/I8bYbokG30iwEWFSv2wntD4LaapTaXZbBGBRbCO0xfar5VRmrY3Aewc7TPTYLuwlfUjnqJ4MUE
	Euu0wCPs14K24Q3lhbpC/aK0j5VIAsEliZipsZk29WbESW2JxHRy3g=
X-Received: by 2002:a05:690c:9:b0:836:ec9b:b468 with SMTP id 00721157ae682-87f2a0de993mr24243117b3.34.1788949996112;
        Wed, 09 Sep 2026 03:33:16 -0700 (PDT)
Received: from [192.168.1.242] (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714b720d82sm107878567b3.41.2026.09.09.03.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:33:15 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:33:10 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
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
Subject: [PATCH v2 24/26] fs,mm/fbatch: lru_cache_disable() keep off buffer_head
 lrus only
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <4a8ab88a-689f-d4d1-adf9-2498a1b3246d@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D6BE340009
X-Stat-Signature: 7j9enubtje86qdoqfyg7x9wm4ar9iz78
X-HE-Tag: 1788949997-485891
X-HE-Meta: U2FsdGVkX1+5AkcKmAwbhPYlHqchPmmzzBL08OkauwHsJt5SImSAAWm8BbHHmua8RUuxXF1CRay/f3oothKXGmdW6O7juFS1n+jKxP1g/y1qggeC5rzA2wkGa9T6KqUG45MzHwawShArWPDnK7bfd8jFo+Vdevjl4B9bEuSR3grEz0xJ6o1nCgdd6SjQ3xmibyH8MpqURmZettquhI7rHRhlupG1fRvuNm5ml/FLPDOXlI2rnpbOhNGAO0K7cbb6yEYU3eG7+d/xp0ColJq3ypYY1OxyLY/RXB5qAbkOvgw7ANiBAT5WCRqXoBt2hCvwMdRAiZYFZz3ME8SPSWAvdSIyN2OVuIl+6Ck0/qRb4Efu5qj4of+evc2XUaLt/Pa3S1QYdYQPDCgY1FXFpQAE4eIXRGBE7DNtN5HK6zxiARWWDNZdaxvlFNJ9M1s3GsnMxvPDyiO28J8xmkIWTdRoCwHHgIceMKhG1d5H64ZNSRwnaXefcHumwwOPJfpwF7tjDb/LZvRTDA6JaawLcBpe69K9kYaBENE+WHlh6sz/f/ZBIRfAaPdA3Zjy+CoHzYVAfIGFfr6Ag1VlXnxJkTieiODabwPP9nhhI/3WunBCHHi4Xnm9IYRi493Yf7KPL5WgI616bTCMbGPMnp6ASy1YQmGN7TkOuwrE4M1tuMwyeIHu5jdGxnpp832GJMMQc9BIoDNgp8HUiQDs6/4YW8kjuGR1fLqhwI2GpAK30ZSQP4o+xLekHtXdsG6+jyYs/w/EcPVxxIiYHbch1kn2crt1q6YdDtAOp1fFpS2wDO8G7/7dB2VGneurXnJS8t7YC9JzHYozyphup/AIWB+CAu0Op2v+XQ8kg4P5AwHRTHzsjGQ40Q/PGxo5lchZadhzBfjKoJY3JR9mDjpnVpxhYxQWvzz69WEn9y9Rs96xAnhFn3yeyqoTxF5gsRIGe6sDRHsBj3iSK1cuNeWgtvCuuVw
 71elfAR7
 aSxDyJH3TN3cx8bddXVkU6/heqqNcw43r2Kil2WpiBt/aDD3h6COaHfwBhjS8cSrleQhweYviCqwIbfB1nt6/pUl4GiPwS617+oOe60+vWFmseTn8J/lt/7SFe/NNv2XxDSKB/OlgCPO6oyVNxz4a6MMGve8X/3mwfja600cZKAynXJbbog2TOS8/qiahN6HafBTnvNa7zWcluTzoLdYgzj7Ugm8aeZOdBKGIEe9fRE+h3IO/msTt91MJ0/6bAu7zcyKIZ9X0+avzy1KFShUbThqYtnxMxk6c/erOOGGbGyaGM9RyudPK6/gq/6NPsUvlFxWGMn3VOlxizjg2wAqQLd9oSI/qUu4tSQbOBU0ef8xHWCRuwOtl/M2rygMnShswBoRRK5aYaLaISPBBFT6A6vTozEc6ur+G2/zu3qYtLNOsDl9G/sMm7BAHZnjUOd1MhDeFYsraqQ+ouppc2+nY6V3xJQ==
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
index 0052a6890435..423d9b669149 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -314,13 +314,6 @@ static inline void lru_cache_drain_for_folio(const struct folio *folio,
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
 long remove_mapping(struct address_space *mapping, struct folio *folio);
 
diff --git a/mm/folio.c b/mm/folio.c
index dbad66e805e2..55ca799a9dcd 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -173,7 +173,7 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		local_lock(&cpu_fbatches.lock);
 
 	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
-			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
+			!folio_may_be_lru_cached(folio))
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
@@ -434,7 +434,7 @@ void __folio_add_lru(struct folio *folio, bool mlockit)
 	smp_mb__before_atomic();
 	folio_set_lru(folio);
 
-	if (full || !folio_may_be_lru_cached(folio) || lru_cache_disabled())
+	if (full || !folio_may_be_lru_cached(folio))
 		folio_batch_move_lru(fbatch, lru_add);
 
 	local_unlock(&cpu_fbatches.lock);
@@ -719,7 +719,7 @@ static bool cpu_needs_drain(unsigned int cpu)
  * Calling this function with cpu hotplug locks held can actually lead
  * to obscure indirect dependencies via WQ context.
  */
-static inline void __lru_add_drain_all(bool force_all_cpus)
+void lru_add_drain_all(void)
 {
 	/*
 	 * lru_drain_gen - Global pages generation number
@@ -743,7 +743,7 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	if (WARN_ON(!mm_percpu_wq))
 		return;
 
-	trace_mm_lru_add_drain_all_tp(force_all_cpus);
+	trace_mm_lru_add_drain_all_tp(false);
 
 	/*
 	 * Guarantee folio_batch counter stores visible by this CPU
@@ -770,7 +770,7 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	 * (C) Exit the draining operation if a newer generation, from another
 	 * lru_add_drain_all(), was already scheduled for draining. Check (A).
 	 */
-	if (unlikely(this_gen != lru_drain_gen && !force_all_cpus))
+	if (unlikely(this_gen != lru_drain_gen))
 		goto done;
 
 	/*
@@ -816,11 +816,6 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
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
@@ -829,40 +824,6 @@ void lru_add_drain_all(void)
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
index 6700fff13675..d9930b752153 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -53,12 +53,6 @@ static inline bool folio_may_be_lru_cached(const struct folio *folio)
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


