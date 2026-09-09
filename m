Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E10CC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C7286B008A; Wed,  9 Sep 2026 06:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0846B008C; Wed,  9 Sep 2026 06:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B3416B0099; Wed,  9 Sep 2026 06:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51DD26B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:41:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A51FB140163
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:41:09 +0000 (UTC)
X-FDA: 85193881458.11.2E2B2D1
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id E0EEB100009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:41:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mWPRqdcd;
	spf=pass (imf05.hostedemail.com: domain of hughd@google.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788950467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGN+ybR37+qvtDqf9cFN47582j44el3q/H5/GSGFvrU=;
	b=GdNpc9POh8f9lPWYnND0S1y30HmO7J2c46yW4BgNyFRz1tQcK2EJNGdhqhB9LBjTePiibr
	GBNizJntyTLxN3AxCEZCOGIzJNfvw89AxotnGhs6MI1g3y9n3NGRJ0IVKkHYImucKXMIfW
	fgJY/mGKQHZs61lbn1p6quNOYUlCjlA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788950467;
	b=47pLXLWxpg4TjWGnbNMs2qNjPapS6R1lfmJbaRPeych+jrlmffqcOw68VyXIePraNLgIRu
	AjEEJdohMjJz2eeCSxLUcvQ1N2QH1tpVEBQNShdricfgrqDqsOr0/PZwpM2Z8zZs0GeD6W
	ftIPqQe6c6PFURDN861Nr0RI7Pb4deY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mWPRqdcd;
	spf=pass (imf05.hostedemail.com: domain of hughd@google.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-855c26cf490so41292997b3.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788950467; x=1789555267; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PGN+ybR37+qvtDqf9cFN47582j44el3q/H5/GSGFvrU=;
        b=mWPRqdcdYuXM8O4NckhIxOaSvPwjnTkN3k1jlw8AGmEwWvMxqKYxdW9fBMfUr3RqDu
         jYSXWlrgRSfHVb4IT+X+NqOnHTsuUOqF/4kEpAiheyd+VAdF52/zSkJrD10eKjdl6oPl
         MLmhonYwo2FXsaTNcOXka+SjhUFLs1asNvudaHA+1YGRBGy+szsn+HvfggX90Xorjx6N
         49B6OS0/Hgjpx46wDal8JK0XSYxiYq4ffVuWIjn2efFNVAlI3udEPMTcrLX+407DbcUF
         K1A/3E7hbDm9g71Nlzh+tbyQgfEhV3ZtXsGps7CR6Qr5UIwp+oqm+Ag79Um8x/BVant4
         gCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788950467; x=1789555267;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PGN+ybR37+qvtDqf9cFN47582j44el3q/H5/GSGFvrU=;
        b=LwlBhBCONabfEtBvUCn6WD8iig2XmT2QtvmXBblCXdvReUMk9tH71CQGDv2pGfmsqX
         NyjrJPzkBge3ZIify5pihaYd/Uk9D35pqVc2XAeDeLFV+qQlpH469d1HWrRXNJSJ+cDx
         +maP99X68Fg5PR1HJLs0cWZYw7O+Kvr3ajBTJSqOm4kDwAVVqhTt+UG8di9s0oklNRGP
         hqeOsHG8/Z4Nnp7irtHP781bARYSTAekyMvr3MBf2BX+m4AjlzpXNTfC93IK+gFRVCJ5
         bLKt4VNyHJhjVc0z1fdKDybxhXJdIGQ+B25XbGC3wxwnLB6iue3MuWj9D8p5RlJ90gcB
         jNmg==
X-Forwarded-Encrypted: i=1; AKwUvBwCbD98hpWpE0Y/BvBmE1Qhn53OasMLTFwVtSpADCcyO6mEhcVymCiYxP41DNuIfEx8gB7sBgbdig==@kvack.org
X-Gm-Message-State: AFuF++kfusaBmcjOsnB/6hkyroMyhIhglifWrQ1tKbjfioYDTbLvMiIX
	UsEjqjmklK748vaAUgOQK0abS3tsK5ZSFnpgG7EjtBaQYOouGTZD5sPngai3v16wzg==
X-Gm-Gg: AYBFou2qJrJ03NaaT9kk4qaoDstscMLomMskFft/lzxqGZ+w2J944yuf0VgaHUK4sR8
	ZlgFVoaosNc7akPdSsQvCJy/y8NzNRrGlu/+25nUORPw0UohVMBwWrESzVDTlO4hAcXvEf1md3m
	A72Dhi+29G3G8DhOrf2iXoeEOgVe6v9+7TX3UUxowsKInr9kNbEerytz6DGbzxNKK5KAe0RQfxr
	H5fWm7qPGEeR3LDbKjMUBEFTcFYHceDFs1xJJJl/xS0l9+o3NPP6EpxMuE/QnrDqEk18WNexTxj
	cNN3KigMjAPs+uTRofO8fxOJ/FdlcTs3JPrgmT2tsMc8gL6MU6I1hSPhZhHwSlBq0gw+7FHJco/
	hGEHnlZS1BMiOgM0Yv1JXAgzsOzhAQHEMkxlhBpcoSYeI2UoJ77MTTa7+FItT4yfJ5FVyMphxX1
	lFHkKPHleyNHI7EA+4b3CyaLoXvZmjTxpUAyxF5g7rNjYMqJ7ZjGWPRgHtCjelGTrqFv8sEUIKR
	OI/ZYrQtaa+VgZ9SqVJ9Uz3hShpsmTXPmsHH9mZcKmLY9gG6cJORJCQ/zs=
X-Received: by 2002:a05:690c:e3e8:b0:81e:9826:942c with SMTP id 00721157ae682-8711c7488c4mr132269777b3.0.1788950466181;
        Wed, 09 Sep 2026 03:41:06 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714ab77c4dsm108323097b3.34.2026.09.09.03.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:41:05 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:41:01 -0700 (PDT)
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
Subject: [PATCH v2 27/26] mm/fbatch: paranoid folio vmstats in
 folio_batch_move_lru()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <f86f8e55-3f07-fc87-c64f-f34a3be9a013@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: kusarqmwx5zfxaqjfmz47yomb5x8u56r
X-Rspamd-Queue-Id: E0EEB100009
X-HE-Tag: 1788950467-633604
X-HE-Meta: U2FsdGVkX18gXvS9XpigIIm0FS3rcTRXiLyeYDnBCa2v4q+OTTX+M1emYr23JjpT9l6K+I7EI8hQt7oBOywk+MW22QvaTRzMkhEoj92l27MAxPF7ZaELLvunPy4nO+tZfX1j3REhzatsXisj4okOeKzIEV4bPfNA68unde0iRPrbYQ3ePEP6JnfzecaSrEjF7BbAS5LkC0weNurlriu7jBfUU0gVojyMrXo45hiKYWFuOHEX6P00+gvDICIJuDsM+GjsaIl+aA64y7XHgnh5kLC3BPBWFldJhoz6yr/dgWNeCvqxn/hCXNv2zrDzdRcFFMmfzXotL4P1vHV/jmPAt1DN9myJXzxL5NJY6iuaW3PLmwXJbSrpl+xUBJp5Pa866ls7eviS5F5tvy1BqJk1MMJwhmJ1IsjdRhQ31X5NhbAcan/sCZgzAsLVatLPSSYQcA2zkxFeOsEdSgC9hOxT2NHHBdxbflpz3uwd9WWGhAdtGF76Wc9TVCmuO49pHkWUnqrjnE44yPa/lmEmb5ssFBL+SeuvRWaKFvBCmTKsQk4snQPoBNKB1XOxxvU4p08J7GKGvZ6ecu7gXdcav2iZx1xi1vztd1rL2sR/Bqq6uWxic5WPmxU6ffNEU2fq0Y2WNDsl8/nqe592iB7HBCCFGEdrX0s73/Zn5KXhs773ClecMQa3CChDJV2SinCRfFKClOE0UTgP/8hyKf7pCrqyFaYVy+rRnKeIyg+wECCquc/vAnIwhZuNfcKlwmoqdCM0Id5oxWPBqBfbkxG12wFG8eQLKweHY9FKEc/MCY7LvqvET16NUyFpg4Gf4yTyKwTDy86d/+0nXlWjLqP7FVK85oKLEkvekSmJOFyAiAeZRp6HMyCVVh7ScEZDqg+gS5sJEMFmw51vPohVKZVIxaALGicraDuCL0Gn6wBpkmKyd9lpW+LqsdQOLI+bbVm/EJZTDENNUJvBk8/541cMF5a
 0Tws3+PW
 9m0FYvqO+zdnj7UIgfT/qD5877rgapSwG4XWXLvHyFrFaUFaKdSjN+4scg/lPHI/wV9xY8+ATm3m1y/ykxnqg5tVEJsAvSbIMn7Y+X5wVQXqj7MLy1Q73c5I9gqB9L1PSVEa4wYYX2QwOeGWRA00oHfNG/erbN6bSx/wJL2oKyv2Sh87AfTGEywiYL3CFTSpYgF7zqeq+pBaa6CvxiVfe9v+wdCnKMuK/hKk1Nk16IU+wpqVC6r8Elk31p1V5zUv2TTCl2iHjZS7OQWQddfUaK4G/nigCy4XKm/w5ish0lzsaDMz78iovLQuDplgm7OP3Ph0heP0Kj/wNhS8HbjQ/fStoLOMTM7mm4Nksvq5YjU3fLvLCpyvJFXcbyacLpboL1smKj715vYpSHivXErQ6pxLJBMOSJlsA4j77iFJDQep3m7gO+kuhny8lvSpaBfEGeAJ0hA1eHuGTChQWpCfo5aEBeaAgGKFwEkZM9yWY1RBLu1bdkXYeyQoY0DxgeLwzLokE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Save mapping and index when adding folio to per-cpu fbatch, check them
when draining the fbatch, show folio counts at the end of /proc/vmstat
when CONFIG_DEBUG_VM=y.

This is a work-in-progress hack, not intended for kernel release:
hence the 27/26 leaving it out of the series; but a useful framework
for study and reassurance on stale fbatch entries.

Could be extended to the mlock_fbatch, but probably nothing new to learn
there. May be more useful if separate stats kept for the lru_add fbatch
and (together) the other four - their characteristics are different.

Needs refinement: the current numbers raise more questions than give
answers. The folio_hoisted, folio_changed, folio_already numbers mostly
record nothing worse than LRU-eligible folio pages getting freed before
drain, and soon recycled for fresh LRU-eligible folios: no harm there;
but these stats do not verify that.

For example, after hours of kernel builds on tmpfs while swapping:

folio_not_got 65750323
folio_off_lru 357827
folio_hoisted 10458363
folio_matched 2888574439
folio_swapped 113626282
folio_changed 11558942
folio_already 12717475
folio_skipped 705

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/vm_event_item.h |  10 ++++
 mm/folio.c                    | 101 +++++++++++++++++++++++++++++++---
 mm/vmstat.c                   |  10 ++++
 3 files changed, 112 insertions(+), 9 deletions(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 2628ccda076a..4572463fb65f 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -179,6 +179,16 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		NRSWPIN,
 		NRSWPOUT,
 #endif /* CONFIG_SWAP */
+#ifdef CONFIG_DEBUG_VM
+		FOLIO_NOT_GOT,
+		FOLIO_OFF_LRU,
+		FOLIO_HOISTED,
+		FOLIO_MATCHED,
+		FOLIO_SWAPPED,
+		FOLIO_CHANGED,
+		FOLIO_ALREADY,
+		FOLIO_SKIPPED,
+#endif /* CONFIG_DEBUG_VM */
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/folio.c b/mm/folio.c
index 7c545e4c090d..9f0cb755595a 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -40,19 +40,35 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/pagemap.h>
 
+#ifdef CONFIG_DEBUG_VM
+#define PARANOID_SIZE FOLIO_BATCH_SIZE
+#else
+#define PARANOID_SIZE 0
+#endif
+
+struct mapix {
+	struct address_space *mapping;
+	pgoff_t index;
+};
+
 struct cpu_fbatches {
 	/*
-	 * The following folio batches are grouped together because they are protected
-	 * by disabling preemption (and interrupts remain enabled).
+	 * The following folio batches are grouped together because they are
+	 * protected by disabling preemption (and interrupts remain enabled).
 	 */
 	local_lock_t lock;
 	struct folio_batch lru_add;
+	struct mapix mapix0[PARANOID_SIZE];
 	struct folio_batch lru_activate;
+	struct mapix mapix1[PARANOID_SIZE];
 	struct folio_batch lru_deactivate_file;
+	struct mapix mapix2[PARANOID_SIZE];
 	struct folio_batch lru_deactivate;
+	struct mapix mapix3[PARANOID_SIZE];
 	/* Protecting the following batches which require disabling interrupts */
 	local_lock_t lock_irq;
 	struct folio_batch lru_move_tail;
+	struct mapix mapix4[PARANOID_SIZE];
 };
 
 static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
@@ -60,6 +76,57 @@ static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
 	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
 };
 
+#if PARANOID_SIZE
+static void paranoid_count(enum vm_event_item folio_counter)
+{
+	count_vm_event(folio_counter);
+}
+
+static void paranoid_save_mapix(struct folio_batch *fbatch)
+{
+	int i = fbatch->nr - 1;	/* folio has just been added */
+	struct mapix *mapix;
+
+	mapix = (struct mapix *)(fbatch->folios + ARRAY_SIZE(fbatch->folios));
+	mapix += i;
+	mapix->mapping = fbatch->folios[i]->mapping;
+	mapix->index = fbatch->folios[i]->index;
+}
+
+static void paranoid_check_mapix(struct folio_batch *fbatch, int i)
+{
+	struct folio *folio = fbatch->folios[i];
+	enum vm_event_item folio_counter;
+	struct mapix *mapix;
+	unsigned long lru_next = READ_ONCE(folio->lru_next);
+
+	if (lru_next & BIT(LRU_NEXT_BATCHED)) {
+		lru_next ^= (unsigned long)&fbatch->folios[i];
+		if (lru_next & ~(BIT(NR_LRU_NEXT_FLAGS) - 1))
+			paranoid_count(FOLIO_HOISTED);
+	}
+
+	mapix = (struct mapix *)(fbatch->folios + ARRAY_SIZE(fbatch->folios));
+	mapix += i;
+	if (folio->mapping == mapix->mapping && folio->index == mapix->index) {
+		folio_counter = FOLIO_MATCHED;
+	} else if (!folio->mapping || !mapix->mapping) {
+		/* Truncated? Swapcache? Needs more cleverness */
+		if (folio->index == mapix->index)
+			folio_counter = FOLIO_MATCHED;
+		else
+			folio_counter = FOLIO_SWAPPED;
+	} else {
+		folio_counter = FOLIO_CHANGED;
+	}
+	paranoid_count(folio_counter);
+}
+#else
+static void paranoid_count(int event) { }
+static void paranoid_save_mapix(struct folio_batch *fbatch) { }
+static void paranoid_check_mapix(struct folio_batch *fbatch, int i) { }
+#endif
+
 static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
 		unsigned long *flagsp)
 {
@@ -135,22 +202,32 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
-		if (!folio_try_get(folio))
+		if (!folio_try_get(folio)) {
+			paranoid_count(FOLIO_NOT_GOT);
 			continue;
+		}
 
-		if (!folio_test_clear_lru(folio))
+		if (!folio_test_clear_lru(folio)) {
+			paranoid_count(FOLIO_OFF_LRU);
 			goto restored_lru;
+		}
+
+		paranoid_check_mapix(fbatch, i);
 
 		/* Do not add to LRU if it has already been added */
-		if (move_fn == lru_add && !lru_add_del_folio(folio))
+		if (move_fn == lru_add && !lru_add_del_folio(folio)) {
+			paranoid_count(FOLIO_ALREADY);
 			goto restore_lru;
+		}
 
 		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
 		move_fn(lruvec, folio);
 
 		/* Do add to LRU if not already there (move_fn skipped) */
-		if (lru_add_del_folio(folio))
+		if (lru_add_del_folio(folio)) {
 			lruvec_add_folio(lruvec, folio);
+			paranoid_count(FOLIO_SKIPPED);
+		}
 restore_lru:
 		folio_set_lru(folio);
 		/* See mm/vmscan.c move_folios_to_lru() comment on ordering */
@@ -176,16 +253,21 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		struct folio *folio, move_fn_t move_fn, bool disable_irq)
 {
+	struct folio_batch *cpu_fbatch;
 	unsigned long flags;
+	bool full;
 
 	if (disable_irq)
 		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
 	else
 		local_lock(&cpu_fbatches.lock);
 
-	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
-			!folio_may_be_lru_cached(folio))
-		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
+	cpu_fbatch = this_cpu_ptr(fbatch);
+	full = !folio_batch_add(cpu_fbatch, folio);
+	paranoid_save_mapix(cpu_fbatch);
+
+	if (full || !folio_may_be_lru_cached(folio))
+		folio_batch_move_lru(cpu_fbatch, move_fn);
 
 	if (disable_irq)
 		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
@@ -440,6 +522,7 @@ void __folio_add_lru(struct folio *folio, bool mlockit)
 	}
 
 	full = !folio_batch_add(fbatch, folio);
+	paranoid_save_mapix(fbatch);
 
 	/* Ensure folio->lru_next visible to folio_test_clear_lru() callers */
 	smp_mb__before_atomic();
diff --git a/mm/vmstat.c b/mm/vmstat.c
index d66cb67f55ce..cc61ac10782a 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1507,6 +1507,16 @@ const char * const vmstat_text[] = {
 	[I(NRSWPIN)]				= "nrswpin",
 	[I(NRSWPOUT)]				= "nrswpout",
 #endif /* CONFIG_SWAP */
+#ifdef CONFIG_DEBUG_VM
+	[I(FOLIO_NOT_GOT)]			= "folio_not_got",
+	[I(FOLIO_OFF_LRU)]			= "folio_off_lru",
+	[I(FOLIO_HOISTED)]			= "folio_hoisted",
+	[I(FOLIO_MATCHED)]			= "folio_matched",
+	[I(FOLIO_SWAPPED)]			= "folio_swapped",
+	[I(FOLIO_CHANGED)]			= "folio_changed",
+	[I(FOLIO_ALREADY)]			= "folio_already",
+	[I(FOLIO_SKIPPED)]			= "folio_skipped",
+#endif /* CONFIG_DEBUG_VM */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.51.0


