Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FEFFF531CE
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 22:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 898F66B0092; Mon, 13 Apr 2026 18:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F966B0093; Mon, 13 Apr 2026 18:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75F1E6B0095; Mon, 13 Apr 2026 18:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6722D6B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:40:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9703140163
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:40:00 +0000 (UTC)
X-FDA: 84655001760.10.A6724BE
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id DCBBC1A0004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:39:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Mv8FD/s/";
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine);
	spf=pass (imf19.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776119998; a=rsa-sha256;
	cv=none;
	b=tl7iRQNMmW3I/i3sHXtotjcpxXHH996u8yo03ETj1WNEaMwKluC9s7wrMXBHNYvQzxTEBY
	O0Kdnz7G/YS9ywU7SvY6gzzYPsJuynFpRwlh0q2xmm+j0DjsCwxAw6jovQ92FQ3b8Xnorq
	2PqDTjygy0ScK0LiPQ9/VfNaoXJ2iLo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Mv8FD/s/";
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine);
	spf=pass (imf19.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776119998;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5SZlDYq9EPQdnrcj2kdyj1ENxPSAFfrXTE89MwF4qY=;
	b=sr4COMb4Fko55fOrbqYUHrN9E1eK8mM701rkYoDOFBCrQU0mQI7yBy4bPGjbKg8jEqBgLl
	uiXgnGmRpwMn6KXpn7yI56PkCUeH+tg6jR4LCI237MxK4TOX82VmdDeEzGMDlqDgZ4uXdK
	5i32hr0qFfy5o6AtiiSaGCP8OgAkZFw=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2bd9a485bd6so10326544eec.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776119998; x=1776724798; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m5SZlDYq9EPQdnrcj2kdyj1ENxPSAFfrXTE89MwF4qY=;
        b=Mv8FD/s/O3mtYc6PYd4ufDA8UCl0ASWF7aZW8zj65z1Iq3LgOWgvmi4ZMkiH400zt3
         NHVHZ4Hdsu61HhFxS3qvjJW2RVAYy9EEyBQ77PP3RKhR0130VqTwOetVmOfWxXXY3Xms
         Dpzt4boqUFcJSzAfGfL/hfhJDJswspwRD2iV5wuOIoKPgS//i3mvXNai7Svj9S1gFl95
         mVNnZZbbzsi/JPy8CbLPT8ktTKqA0f749+685gVoIx7f3MF9OQxPtx/GkJb7mmDkNOs6
         AV3xZr0V66U/WnlJU1YD4txk0WlB0+ehmokmOXIlu2/DjO4eOEr6SbvnasSwXH7OHQbO
         /M8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776119998; x=1776724798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m5SZlDYq9EPQdnrcj2kdyj1ENxPSAFfrXTE89MwF4qY=;
        b=tQ3Vb4IMsgFnl/FkyOJHAB7JL5yij9Q7CpY4+pa1tfNo8pJE5kOtHvPg/XFMiDHced
         8g8k8w3q9UWTHr0qmXbllirGCbkK+Er17Iti+7sIT4Fqy2u3OfaW+picTOpJ5lzs8c7h
         MIh4AW9+/NYzbZNOiwnz3wNgPcc5qRbKNAMyPN2dHnOwScU8tYTEs51jrkxvcZIqDgjM
         JFpNkTqepS/k+JEQMO7cqVhd4q941J91nGZSLrmMunxZJjlmjBsf7BwuGK1fHlfWbl7z
         od9IYe6sGl/BYNnzmIybyKsLqYNnO3+R7MrYmjFvhQtThCdd7giootlt5DlUB1ZkQQr8
         MJTA==
X-Forwarded-Encrypted: i=1; AFNElJ+ID0uZeDBRJSOJ8rv0dN8AIGA2ArYWDMVjtiBUT7NL+k0V71Nzvad2PpgCytAk/6jBxi/ytCvAcA==@kvack.org
X-Gm-Message-State: AOJu0YzsoUYyX245u+vhjwgSDwFckgFFU+TrP3XAYBc8JEZi50MHlVbS
	ZMi+8sVztNHmslvVqkqUKl29mEKTfbAgo8xufZ4iARdJdpQQv3r2VB7P
X-Gm-Gg: AeBDietALkI696AiSTyvGy18QraIizhn0WrnOvRwqoJ1wrh7bldCH8eK9/4mV7HSse2
	0NQih5AtqRdjtUdVbeJZVnIX8nEhYA328ZrgRSgYxCcHR/ZO6105v2p2h9i9nXrlCH99Lqeeec9
	5Q9byiHE7tcdr2Q41fe0sBndbbgo6AgL/8G4twnjqrn7ymGEnBplTXI9Q73gYndkDuxMWnz3pzP
	C8J0apsw7Co4DH75qzZRmM5DEizirNI5rfNWoQsFi2YBLra4deObPdhhHt6LqICCEcSvR1r+XYO
	jDJyJK32wwKkTPTfCMLW6uArBHLFAk3GYLlDA6zSvb2SGEySXuB30dMJNw0egx4u5p5NgOg36P3
	vHYL9KKsDUqWTnc1v8wC7bWEYb61xm96ZBhwxjronj9C4ieLy7qgIodck2XamzZLhk4Qfbo6KF9
	l/w1U+YM2sjWMAaDfG0MH4K3GQVohGL0pU6Fxk8km2vL6aUbiFrw9Z8XWV+T8bXjAVlgODIuwL2
	e7HAhDj5lX/G58=
X-Received: by 2002:a05:7301:6086:b0:2d2:c60d:4fc2 with SMTP id 5a478bee46e88-2d5871bc5a9mr9173087eec.4.1776119997625;
        Mon, 13 Apr 2026 15:39:57 -0700 (PDT)
Received: from bbox-1.mtv.corp.google.com ([2a00:79e0:2e7c:8:c871:4088:5cd5:bd1b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561cd3138sm18577297eec.14.2026.04.13.15.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 15:39:54 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	mhocko@suse.com,
	brauner@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	timmurray@google.com,
	Minchan Kim <minchan@kernel.org>
Subject: [RFC 1/3] mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
Date: Mon, 13 Apr 2026 15:39:46 -0700
Message-ID: <20260413223948.556351-2-minchan@kernel.org>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
In-Reply-To: <20260413223948.556351-1-minchan@kernel.org>
References: <20260413223948.556351-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DCBBC1A0004
X-Stat-Signature: y58jsksroow74hschx63to57awnkaq9j
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspam: Yes
X-HE-Tag: 1776119998-581635
X-HE-Meta: U2FsdGVkX19HHMRMzBDEkIZoanwhGk1248sEwmfMNIheehkotcCZqHM7O6YSHcZK19tTyZXaxyxq4X1M9n9rDO4pSCR0nCAYOfNnCfsUwT2hPZIjIp8JWz/52jzJZC1Jse3KzJcmkYBkS3n45cKhsJKn2j+4ns4gPBGStDxNVkLD1mtg11lNSFCtU2jH9OluGHvRLnnuguQA292s32gz8BoRswSJuLhcx9/ERGvIAY/eB94KLO3CFxaTn6bu3Kp0oXmG/5WMUF70UFAIl7rJCNIiXeUeV6yToQNwGjjG5V0t2BzyOoop0GXlHMUPM3Co5NEKsFatS2cf4bcbqR+oJWzY22O12tIV795SMyD1yfzcLZYO4HaQtuwv0XG2tJPPbwb9tfIlH2v6h/PG3p8jDJ+EBpGqfxF6sUaNslW2YAqFJX3q+1c6badNqs/OXOzryTZnk9XCwjnD8pFAVijrlslCIh0JEhdWymnG6fSELSqDDDDKZzYQ7hdkew8vsFhU6rIzP4CUwIDylkTKZWZIDAjY2cXrP/GsQVrDWDEjacostZdB96T6Ev+SKUOu8RRTzjo2dcCjXSnejmoFhSpqwgK2jeO7MRCJsym438+PBNcAIOJFjJNWolEPgs5dZNmTyKEY4itVH8Hlzkr9/E20xf0D7zoUKaeE7I4iffoEGHKUdV4wyFjH6UkdDHtJkedahDwdPxA+swpSjcvzLWFUSApAHxHI9z6tIqRi/LXLXKqWQZQ5WWjfN1UQGjtuLOLZkDxWhdTX0B5sLQWB8w3LC9LfwRxW5xU12qaNz4y6kvN2iQEaPPK2koIoQp4+HSr0dWMYtlMlnsI60y7lfYncST9uxX7XTQC+rE2R6a5wPysDxD0EfZzuHBUhJ2rRH3TQ+MRRzQ2HW72UmEhvTOe/bPzPPvbch/Ing20LfJ2jeq41PAOi3yru2wrsUdkiUcH71rkwfZ4ifb3Tzn1MHJk
 xnMzvTNq
 Et5BJFidL8o/SU2kLMQ0xfnnYb+Tp6W27QBAwDLXTdEje7lDHypy++ERuRc9CqacCuQ7IcFIAE+TNk9dMMdb+eY3W5P+eZ+vHhymsnsQK8qEYUqChoPKQXLzZvLVF6SqM/M9wHf6b+wHpcqKidj6UMf/Zx11AyD0nCYicfeUOt4BCAUlSyeJ2P8BjGxNg28XdmIpIMdmMc8l+wj2E4DIIh+kbXjUM5aNhXkbQ/6qWg/3FlPArDTlm5VFIYo2o3vgV7h6yIkM5iLGKmGfqtATKNzrx3mC5Fa8IjtldEqeLIc73pos13eEGNKBqhpHMZJpK0B09JaNflHHYEiJFlnbRm2oncsuEi4ha6D1eCCOLTwZ5GmdtAvsWval4uvsN2bkA0Z4bKb4IoJ+i92SwPB5Vhjg2fSLgY+ywoqZpnS2HysRDRuoCL3n4MEqPXLi7L73m6G1w+mYgL6McNduIzD128V6nGYTwyTBK4lR5GuhZNsq20FRUCXI0M97zqCJsymfqTunH8CkyTzy9JLHJfkfFzE1r8MnUBA7hL7/iOMva8GSWQv4ylOGIFC5mDzh92pd3N6TRfHb6wlP6fzF7uToVmUL9wnEoJw4GGutxVLPtM+BxPUPbQLG37kLIMrZ2mDmMFO8K3objr39lmQ8l9naOZgUeMiYxmZbq4fycBkg8GId7gjJcEul3xwQ6ZP6fp0vzBxOW/OtW7xeF9Js1LxxfW0ZLaQeUZ8Zaq8OBW9ZyY+YWuLlYrY9+ZfhetfYIh6Q2abjd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, process_mrelease() unmaps the pages but leaves clean file
folios on the LRU list, relying on standard memory reclaim to eventually
free them. This delays the immediate recovery of system memory under OOM
or container shutdown scenarios.

This patch implements an expedited eviction mechanism for clean file
folios by integrating directly into the low-level TLB batching
infrastructure (mmu_gather).

Instead of repeatedly locking and evicting folios one by one inside the
unmap loop (zap_present_folio_ptes), we pass the MMF_UNSTABLE flag
status down to free_pages_and_swap_cache(). Within this single unified
loop, anonymous pages are released via free_swap_cache(), and
file-backed folios are symmetrically truncated via mapping_evict_folio().

This avoids introducing unnecessary data structures, preserves TLB flush
safety, and removes duplicate tree traversals, resulting in an extremely
lean and highly responsive process_mrelease() implementation.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 arch/s390/include/asm/tlb.h |  2 +-
 include/linux/swap.h        |  9 ++++++---
 mm/mmu_gather.c             |  8 +++++---
 mm/swap_state.c             | 19 +++++++++++++++++--
 4 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index 619fd41e710e..554842345ccd 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -62,7 +62,7 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
 	VM_WARN_ON_ONCE(delay_rmap);
 	VM_WARN_ON_ONCE(page_folio(page) != page_folio(page + nr_pages - 1));
 
-	free_pages_and_swap_cache(encoded_pages, ARRAY_SIZE(encoded_pages));
+	free_pages_and_caches(encoded_pages, ARRAY_SIZE(encoded_pages), false);
 	return false;
 }
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 62fc7499b408..e7b929b062f8 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -433,7 +433,7 @@ static inline unsigned long total_swapcache_pages(void)
 
 void free_swap_cache(struct folio *folio);
 void free_folio_and_swap_cache(struct folio *folio);
-void free_pages_and_swap_cache(struct encoded_page **, int);
+void free_pages_and_caches(struct encoded_page **pages, int nr, bool free_unmapped_file);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
 extern long total_swap_pages;
@@ -510,8 +510,11 @@ static inline void put_swap_device(struct swap_info_struct *si)
 	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
 #define free_folio_and_swap_cache(folio) \
 	folio_put(folio)
-#define free_pages_and_swap_cache(pages, nr) \
-	release_pages((pages), (nr));
+static inline void free_pages_and_caches(struct encoded_page **pages,
+		int nr, bool free_unmapped_file)
+{
+	release_pages(pages, nr);
+}
 
 static inline void free_swap_cache(struct folio *folio)
 {
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index fe5b6a031717..5ce5824db07f 100644
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
@@ -135,7 +136,8 @@ static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
 			}
 		}
 
-		free_pages_and_swap_cache(pages, nr);
+		free_pages_and_caches(pages, nr,
+				      mm_flags_test(MMF_UNSTABLE, mm));
 		pages += nr;
 		batch->nr -= nr;
 
@@ -148,7 +150,7 @@ static void tlb_batch_pages_flush(struct mmu_gather *tlb)
 	struct mmu_gather_batch *batch;
 
 	for (batch = &tlb->local; batch && batch->nr; batch = batch->next)
-		__tlb_batch_free_encoded_pages(batch);
+		__tlb_batch_free_encoded_pages(tlb->mm, batch);
 	tlb->active = &tlb->local;
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6d0eef7470be..e70a52ead6d3 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -400,11 +400,22 @@ void free_folio_and_swap_cache(struct folio *folio)
 		folio_put(folio);
 }
 
+static inline void free_file_cache(struct folio *folio)
+{
+	if (folio_trylock(folio)) {
+		mapping_evict_folio(folio_mapping(folio), folio);
+		folio_unlock(folio);
+	}
+}
+
 /*
  * Passed an array of pages, drop them all from swapcache and then release
  * them.  They are removed from the LRU and freed if this is their last use.
+ *
+ * If @free_unmapped_file is true, this function will proactively evict clean
+ * file-backed folios if they are no longer mapped.
  */
-void free_pages_and_swap_cache(struct encoded_page **pages, int nr)
+void free_pages_and_caches(struct encoded_page **pages, int nr, bool free_unmapped_file)
 {
 	struct folio_batch folios;
 	unsigned int refs[PAGEVEC_SIZE];
@@ -413,7 +424,11 @@ void free_pages_and_swap_cache(struct encoded_page **pages, int nr)
 	for (int i = 0; i < nr; i++) {
 		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
 
-		free_swap_cache(folio);
+		if (folio_test_anon(folio))
+			free_swap_cache(folio);
+		else if (unlikely(free_unmapped_file))
+			free_file_cache(folio);
+
 		refs[folios.nr] = 1;
 		if (unlikely(encoded_page_flags(pages[i]) &
 			     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
-- 
2.54.0.rc0.605.g598a273b03-goog


