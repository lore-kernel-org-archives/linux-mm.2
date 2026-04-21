Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7680F94CB5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 23:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27E2C6B008A; Tue, 21 Apr 2026 19:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 207AB6B008C; Tue, 21 Apr 2026 19:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CFB86B0092; Tue, 21 Apr 2026 19:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE5856B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:02:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F4B2C43EB
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:02:52 +0000 (UTC)
X-FDA: 84684089784.29.BBB8364
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4139080010
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:02:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZMEHSGGD;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine);
	spf=pass (imf30.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776812569; a=rsa-sha256;
	cv=none;
	b=zrm7Yj+8SKVRhHnJETjqnnYt/g8pkL57X1/GvcGsc1VTpvNDZKXRzmOBlkU2MelMhE112y
	MHB9r/YihrSluNf82cIuxOwuUc/mQzhaEJxJ3Z4xL/B0u+DpLx0vEoTHSSdljcgvaK+cBH
	AKDvChg6NzKx3QYw5uqT6yf2c74yv34=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZMEHSGGD;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine);
	spf=pass (imf30.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776812569;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdOzQUx1kuF/ItixYZyEN7MAejmBx2S9M5lxrAx/c7w=;
	b=Q6wAZpLUWKC9e6aVOi1ghNNL9t4IdzAxPb2EWX536A9wELA9gw9eTcoJCAw65ZQ5ri+YrN
	q0d3Vv22ZTmfKtAci5Q9IugprBKz2wqEPSyEpeFx5FSDn4N7mXOzo3q5A/dKNCBGUsh7i7
	H0uCw7XrLT3Csm618IwGdgq8GPlNS34=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-12c8ccc7755so3747729c88.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776812568; x=1777417368; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mdOzQUx1kuF/ItixYZyEN7MAejmBx2S9M5lxrAx/c7w=;
        b=ZMEHSGGDvnWfHINLJAT65sXURwo92bJBKPS2w40ys5Mc0aiEk2pWh2U3USVea3+ZK2
         NhMFSJrZ/kZfU8E0NI5kvngNVJk5JB2BDDj19I+RY897fmFSpDDFTPiXPENr7MnoC+mv
         ePuIwbIjF5m1XpVVQ1tjf6JuRzcUR9dU15SJxr6dE0ZsFZMqrh807NSkEZMl0rcMF90j
         R5Tc+47Apm3arlRXfr5nLycVH7Nnifaw1f4T2e37EuFw8KkFxSOyK+4C7mEwyzL56LfN
         PPIaq6uuNgiIjWaenccHbAigeDDeeEdmndfkxKO+OkMQ+dZw2uLkHGmFiwEY8hf1iH1F
         Snlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776812568; x=1777417368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mdOzQUx1kuF/ItixYZyEN7MAejmBx2S9M5lxrAx/c7w=;
        b=VOxdYYJ8udD3xSpMja6cNe5pfLWeVw7GZhJ8mmx2eeREtqoNPynB8jGb+pXMgdBzd6
         e5xQ1LYGjTXJ9F5Ozo0/ZouAnAeDDIcWlsYkFIv2/qAxje3kBBiWSpgptpkNNOiwdlg/
         Fm0qqwVilMdMXZEkOKDl9SJLfUl5T9zZGZWSLQSzbB3SAR013tVBFofI9MqO9/yHKSgy
         kwUkG0Sez/5lT3Nby5dJ4Lnoixh8o/Aqr8qs5tb9vfnjhNh+QUjdW0XVYiBd3zn5dd9m
         2yJ+ldHqKQnRqXOCHNFlqagxZkVv7+X0lOD5G0KrxmlYy/lLwp1TdRpuGJwMmkYi547z
         lcFQ==
X-Forwarded-Encrypted: i=1; AFNElJ9fM8t79VuMlSopFNa6VRI5wFC3wbwo5WFhZ47DWXvEFVjZJF8Nri3WA+TEcQiIHvmMxb6xBnl5Ww==@kvack.org
X-Gm-Message-State: AOJu0YyGM/icuGfZzkVrJeLMpY1A1erVuSvP9yDBBFZ491HC0XO/3J97
	Gsm/2c8zRY3Gte1ZnK0JigpwO3SRFbGTV+aciSpgn5OLtHpirCcg4A60
X-Gm-Gg: AeBDieuc8/fqt9TQ+8A480ecfaEczP0EFbuMbDrAH8SQYNDgJoEEPEBjOL7dmJjmO6u
	nT313nXiEc7OQSx3aw+nSx8eVdNK9LKzIX0Wieu3kco4J1n6e+0qH/kGo1WiuUZXzD7fxNOutJ9
	u6XSoto7BvvGZcRi1pHjJ1iKCwe4srWJW7m8k+kNnQb/CDWlp6NTOd2Ttv5EGhqrAOBNMjvMNtk
	IHUDKejSLPxC6c+Ss/RyHdnJWv6ndeb5qRlpGJ0OA/KqW7Z1tuxXxnmbYqrBeCDUnKvsQkOs4T9
	aepBLJeVxvoXIZKm9nt+lesGHbi5wq4jofwKEAH+JDJZI9yX23SHEy6GSVHGgnzOQ4GO7o/O95S
	RyAmHtm24bVCke5gwmywN18UOyybx+U3pPvcuIyJFiYx1LHPLi3R4axdv7Jkn2Eaa8NSkX5nFOX
	0Q6rMOSgwvf3hjKJ6+MGC671ZcJ67Acsua2AxA+eBhm/NG3znWdpm+4xxlbKbg75f1DJ+93vVW8
	lJUD3xr7ODcUQ==
X-Received: by 2002:a05:7022:5f14:b0:12c:87f1:f40a with SMTP id a92af1059eb24-12c87f1f7dbmr3847202c88.18.1776812567826;
        Tue, 21 Apr 2026 16:02:47 -0700 (PDT)
Received: from bbox-1.mtv.corp.google.com ([2a00:79e0:2e7c:8:4678:d28b:b946:bcc])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c74a20eb5sm26453546c88.14.2026.04.21.16.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 16:02:47 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
To: akpm@linux-foundation.org
Cc: hca@linux.ibm.com,
	linux-s390@vger.kernel.org,
	david@kernel.org,
	mhocko@suse.com,
	brauner@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	timmurray@google.com,
	Minchan Kim <minchan@google.com>,
	Minchan Kim <minchan@kernel.org>
Subject: [PATCH v1 1/3] mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
Date: Tue, 21 Apr 2026 16:02:37 -0700
Message-ID: <20260421230239.172582-2-minchan@kernel.org>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
In-Reply-To: <20260421230239.172582-1-minchan@kernel.org>
References: <20260421230239.172582-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4139080010
X-Rspamd-Server: rspam12
X-Stat-Signature: 8baxuy64qoeffhefg7iuuqtr9hm4uyfb
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1776812569-2908
X-HE-Meta: U2FsdGVkX19y6snY33rPzll0IdmI/8o+bV/nj7/6ot6mb1RCaiAp67A9LW1Iwl9n+v0Uyd8P2J9gbWiJ8Z59cgvo6rs919a8+lSHrWBKoyavSfwURwMqBA+y6w9BzcOHL22Ct33XIO1akqlR75wNHVluhObJtuWn8SMJqEn1ZkZjPRs7UrfOmdJy4/JSmh9ayiSQM20PG8h3CZiAKKnkrG4p/MQ9xj4MjDp+g5AwwZWHWex5ZynUMw25z+q6slw2qVw/maHe036RCUqDhpKKxBl+FW06s0b3cvJEmutqhmbIa121PVb3IObJBgFeDpJ1cixelyVb8KMni6EhPbkEQygmzOU19FQI9TyC5mU4CIjp2I7zlbrfq6fqUUDWjXhsRTdkt5QeW4VMFC9q8+NC2JJX4ISKv/DLCw+U5AP3IaHNRwncQBe5t2q61qQburfAyczfbRkQmj05ZudiA8pF2ORzZpddbD5m+g/jB5TS2PH5Kp7lJdp1KzFVxPJhLUCn+dIJ/Y+qhTlaggGfAW3cHeY0gIJ3wPBCCGUPOO2kO9smOss0OvnozgLPvzyByrOP7HjolsQUYQazG2F1fFkR52epwwKHUIcuvE+wu+WeF7cv4KhCzgMufky2epEgS6zamO6bXT81hj6SjwIse6UM1F4uTqYhP0DEWKAPd5hHmHYkSiQtjH8JjMsUXspiWB0cjbQachOnEUiZxuU+4KJ9umUn0kGKjMahpeptraWaw7mP8C1OpsqQpHSHDSvzOzRhKVMLxnsKXyThUJI1gcu06uPVMveeuJOZZ/SHHOz+yfkzPntleUkLKDZzIR+2I8qcXxwlGfMfzXH7KJ46JEjlBuSrBJGT7Fl4lGzSdMWcmP6fXw1w0OlKPqICqdaTpOWX7M1vVvAmwo2/BoetkLZ8FSVR4HKV3G/FS5AkRNFFjyknKCHcCFGmHTbx8rYdxiaBg2XTJbNfyeXgAcFHwUX
 76PpkBxx
 mPVfBmW0Mt57fMQC44A0s7QtXQ4lQ2RoF7X/L8G3oEEchJYJJ68zFfZ1d9f7lei0vG1DH41q3LogNOaYgF73aEmAcq8Nq/WH/oAFuz07vNu/khK32aUmB+TzokzzS6VrMhUxFII7CQWP3zIFecd81RBSuCYy/M6h0b4Q2VuBFFfuH2oaKBMhJf4YaALngEOs8axGALNI7gShU1pIEFVLPUdJEjDk0h875GpADANf2m3gmHu/lZZ92jm6uInPoIq61t4svOvZPhdV7PxJ657XHApDSIQjwJmxDUUR5k3yHT1r2K8OD24Wg7yi8OGBOiJo1SdCaIP6/NRDCG0jF757ICu9kypbBcFAs6AhRgFTFWU/KA3ZhSDF8EI1YpKSKmZIUw8AvED9E/EwzAltm8468dgrWYduca9q1mwgmfQjh2uUKhJ9smloM/SFBjlSQ1FVFzozZDce/MADHUbB2uEMVu8es/zkbPzLQi5ncmHzmU2M7eI9nWZj9O8gTYJgfKpnn9FjDxTwxhl5n4Bobw/RnPJF7RV6jhLJmRJdTuy1lB6hhQtkfprqNP4zhfNwor6oV6VGyFc6uNrW0p6F0/qaWW5D5QbZ9RmNkJRtjs3ox6ukKvjhuvRZV9s9ihheiB6HuOHHLIPoyrjtHgYE/bdXhXFtlg1pL3XmFDF//J30yC/MLiNeQGck6oLDhbiRbtsceJ5qJhPugFo2PCK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, process_mrelease() unmaps pages but file-backed pages are
not evicted and stay in the pagecache, relying on standard memory reclaim
(kswapd or direct reclaim) to eventually free them. This delays the
immediate recovery of system memory under Android's LMKD scenarios,
leading to redundant background apps kills.

This patch implements an expedited eviction mechanism for clean pagecache
folios in the mmu_gather code, similar to how swapcache folios are handled.
It drops them from the pagecache (i.e., evicting them) if they are completely
unmapped during reaping.

Within this single unified loop, anonymous pages are released via
free_swap_cache(), and file-backed folios are symmetrically released via
free_file_cache().

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 arch/s390/include/asm/tlb.h |  2 +-
 include/linux/swap.h        |  5 ++---
 mm/mmu_gather.c             |  7 ++++---
 mm/swap.c                   | 42 +++++++++++++++++++++++++++++++++++++
 mm/swap_state.c             | 26 -----------------------
 5 files changed, 49 insertions(+), 33 deletions(-)

diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index 619fd41e710e..2736dbb571a8 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -62,7 +62,7 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
 	VM_WARN_ON_ONCE(delay_rmap);
 	VM_WARN_ON_ONCE(page_folio(page) != page_folio(page + nr_pages - 1));
 
-	free_pages_and_swap_cache(encoded_pages, ARRAY_SIZE(encoded_pages));
+	free_pages_and_caches(tlb->mm, encoded_pages, ARRAY_SIZE(encoded_pages));
 	return false;
 }
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 62fc7499b408..bdb784966343 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -414,7 +414,9 @@ extern int sysctl_min_unmapped_ratio;
 extern int sysctl_min_slab_ratio;
 #endif
 
+struct mm_struct;
 void check_move_unevictable_folios(struct folio_batch *fbatch);
+void free_pages_and_caches(struct mm_struct *mm, struct encoded_page **pages, int nr);
 
 extern void __meminit kswapd_run(int nid);
 extern void __meminit kswapd_stop(int nid);
@@ -433,7 +435,6 @@ static inline unsigned long total_swapcache_pages(void)
 
 void free_swap_cache(struct folio *folio);
 void free_folio_and_swap_cache(struct folio *folio);
-void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
 extern long total_swap_pages;
@@ -510,8 +511,6 @@ static inline void put_swap_device(struct swap_info_struct *si)
 	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
 #define free_folio_and_swap_cache(folio) \
 	folio_put(folio)
-#define free_pages_and_swap_cache(pages, nr) \
-	release_pages((pages), (nr));
 
 static inline void free_swap_cache(struct folio *folio)
 {
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index fe5b6a031717..3c6c315d3c48 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -100,7 +100,8 @@ void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma)
  */
 #define MAX_NR_FOLIOS_PER_FREE		512
 
-static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
+static void __tlb_batch_free_encoded_pages(struct mm_struct *mm,
+		struct mmu_gather_batch *batch)
 {
 	struct encoded_page **pages = batch->encoded_pages;
 	unsigned int nr, nr_pages;
@@ -135,7 +136,7 @@ static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
 			}
 		}
 
-		free_pages_and_swap_cache(pages, nr);
+		free_pages_and_caches(mm, pages, nr);
 		pages += nr;
 		batch->nr -= nr;
 
@@ -148,7 +149,7 @@ static void tlb_batch_pages_flush(struct mmu_gather *tlb)
 	struct mmu_gather_batch *batch;
 
 	for (batch = &tlb->local; batch && batch->nr; batch = batch->next)
-		__tlb_batch_free_encoded_pages(batch);
+		__tlb_batch_free_encoded_pages(tlb->mm, batch);
 	tlb->active = &tlb->local;
 }
 
diff --git a/mm/swap.c b/mm/swap.c
index bb19ccbece46..e44bc8cefceb 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -1043,6 +1043,48 @@ void release_pages(release_pages_arg arg, int nr)
 }
 EXPORT_SYMBOL(release_pages);
 
+static inline void free_file_cache(struct folio *folio)
+{
+	if (folio_trylock(folio)) {
+		mapping_evict_folio(folio_mapping(folio), folio);
+		folio_unlock(folio);
+	}
+}
+
+/*
+ * Passed an array of pages, drop them all from swapcache and then release
+ * them.  They are removed from the LRU and freed if this is their last use.
+ *
+ * If @try_evict_file_folios is true, this function will proactively evict clean
+ * file-backed folios if they are no longer mapped.
+ */
+void free_pages_and_caches(struct mm_struct *mm, struct encoded_page **pages, int nr)
+{
+	bool try_evict_file_folios = mm_flags_test(MMF_UNSTABLE, mm);
+	struct folio_batch folios;
+	unsigned int refs[PAGEVEC_SIZE];
+
+	folio_batch_init(&folios);
+	for (int i = 0; i < nr; i++) {
+		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
+
+		if (folio_test_anon(folio))
+			free_swap_cache(folio);
+		else if (unlikely(try_evict_file_folios))
+			free_file_cache(folio);
+
+		refs[folios.nr] = 1;
+		if (unlikely(encoded_page_flags(pages[i]) &
+			     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
+			refs[folios.nr] = encoded_nr_pages(pages[++i]);
+
+		if (folio_batch_add(&folios, folio) == 0)
+			folios_put_refs(&folios, refs);
+	}
+	if (folios.nr)
+		folios_put_refs(&folios, refs);
+}
+
 /*
  * The folios which we're about to release may be in the deferred lru-addition
  * queues.  That would prevent them from really being freed right now.  That's
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6d0eef7470be..7576bf36d920 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -400,32 +400,6 @@ void free_folio_and_swap_cache(struct folio *folio)
 		folio_put(folio);
 }
 
-/*
- * Passed an array of pages, drop them all from swapcache and then release
- * them.  They are removed from the LRU and freed if this is their last use.
- */
-void free_pages_and_swap_cache(struct encoded_page **pages, int nr)
-{
-	struct folio_batch folios;
-	unsigned int refs[PAGEVEC_SIZE];
-
-	folio_batch_init(&folios);
-	for (int i = 0; i < nr; i++) {
-		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
-
-		free_swap_cache(folio);
-		refs[folios.nr] = 1;
-		if (unlikely(encoded_page_flags(pages[i]) &
-			     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
-			refs[folios.nr] = encoded_nr_pages(pages[++i]);
-
-		if (folio_batch_add(&folios, folio) == 0)
-			folios_put_refs(&folios, refs);
-	}
-	if (folios.nr)
-		folios_put_refs(&folios, refs);
-}
-
 static inline bool swap_use_vma_readahead(void)
 {
 	return READ_ONCE(enable_vma_readahead) && !atomic_read(&nr_rotate_swap);
-- 
2.54.0.rc1.555.g9c883467ad-goog


