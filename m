Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327B5D2A521
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874A06B00CE; Thu,  4 Dec 2025 14:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824486B00CF; Thu,  4 Dec 2025 14:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C48A6B00D0; Thu,  4 Dec 2025 14:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5636B6B00CE
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:30:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26EC2133056
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:51 +0000 (UTC)
X-FDA: 84182781102.24.EB55C30
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2AF5A40012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b6mu+q5L;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8w/Sn1GWGZ3JxXkJdoutyob4Ias8G2wfwgOnm+/mbHA=;
	b=41TKJPqFgKcWe9bwkxkXTnvFXwgeG7DDZY/+eigDkw+xJaAI4vwNtsXzRMRfgwfaCiFNMu
	bxUsMtw1DIFF13sn8e7nmdR7ghcYVu7OYvaCrUPZklS7s6sbTNYBDOrhazcNGM0G1JEUQ4
	K8Jed8OEhlpVEKLmNnsp+LqBQ8WBNgY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876649; a=rsa-sha256;
	cv=none;
	b=e5GvgUJXdAtJwzmOZQWbI2CX0bkW+zd7mgyUedpchK2bTfP+oW3z/LD0ycsNIZZYsgWd9b
	54qDRQ/ppUGFxM3vF/7W24aLTJtARBVhVZqDW7/jRpuUEcfFOhLrkEWv1uqk+wt1rnEWov
	qOABlPx7cbwx+d3RHsSMpIiUV4sPlKs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b6mu+q5L;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b75e366866so623209b3a.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876648; x=1765481448; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8w/Sn1GWGZ3JxXkJdoutyob4Ias8G2wfwgOnm+/mbHA=;
        b=b6mu+q5LCqtIIrYIthk26myDtzuJl5Clmi2LTMj0wmwcFCVJAaeegptVgE3aRhL2kj
         hg0wGFxWLmDw7MUjjQa2Zx97isHUiZkP2Vl8l2XOElS0CCuly56rQ/UgZjN1xmc6axSU
         zoV3MNYe9DVof+SUq4JvWixeIGMmE/hTZoJOYC63ktAFA0Epu4sazz8xRctBjM+PaFbo
         rgvs5j5PtgpEjKYQ9GzxJZMC5/Z3Qnb3SwX9wAKv3Ny0/gMIXhWE3/T4Oi9DK85sMEYg
         S1Jd4DM03rtJ0841FLJHQXYxHb7EvUdwpa3Ul5W90mk1WDeMSW47eFjJamHhDiFZXbdE
         cTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876648; x=1765481448;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8w/Sn1GWGZ3JxXkJdoutyob4Ias8G2wfwgOnm+/mbHA=;
        b=lhi+NAo4Y3yN2xd2UWuofLKEGa5zSPF7UlxoCk4XhI3JMsKscpPFCyHuS85y81apr+
         BREz7/+kWU2qFWd6QKLK2BWMm/lvDk17OXJJEw7g/C4sQeAtUxUFNI9XAvKk7+WVEAiO
         V8TTNATgfKGb8Ljo+sx5Eb90WiNPVQQDPl76jJ0jnS8RAcGCAStDFC+oXOt8t5TuTUQ5
         z4puQCqFlFEe0vrHfKY0KSbV/5AwNC6C+/WRr3RQDj4PeGdi6KNVkBEqKlLWs2C6hPca
         ijMz5pjP8Kwnh1L24KFZwsdvOsbfSh2XVKe+Z0jXtgSV5wzqMUMo8WfHa3AIMnn7/vdJ
         kukw==
X-Gm-Message-State: AOJu0YweILwBYGAlg5ExV7D4rR1yeuvS4S7ddVagyc/1mpwfAukoK4h2
	WBxoKKaMvxn0gxu9kjVXNCZT5tQhdKhMarhP2BXlCY8G8MWhbcKXFafP
X-Gm-Gg: ASbGnctJN1pk/+kN1aI0wLUg3NUM/tkC/g/MxxvLar1Orz8Ae1986Plceoq8yfEi67K
	VXeYxh6IboCqQ4j6k0N/gJuVziIYWnUZ+eCFcIRLxnYn8HhhFgX6n0rtJcT84qbpAvjeMWYvKlO
	dP2VbHYMFc6fTgHNUZIqxLNNPA6fi2PKAe3RpKRKlehcMSmt9Avwv0wVVZdnXNYHS2HJx2WckGM
	9Hqvtm1pKn/R+WaZSsZ5fIFUWVDLBIIKWi2LBchV2ELLA9kSKeNnhPAA9OMx5wwd5cix59+BFde
	enSEjcD7cTGtRy+DUclxmPeiGy4KVx1sXM3vy8KbhPb3rGSwlPhnJ5wOUz+SWrxKBNLYovpdkZ0
	/2wTWp0IGr45Fd/ExIMoGNmbfN3CGbncqmRQtTiXw24Ux8seGvcRM3P1IQALbIZHg//RWdhxGFJ
	DdKHmHwBnmi8see6R0LxlCG2mX7QGyCEmTlSpiUbigSh+5diiV
X-Google-Smtp-Source: AGHT+IGRyFfv1OwsxmrB4sJXk3FPbwdfaQcgh7svGxSCGbyiO4YSLHqhycFBFhQ4NQh0PM9g5RMCJA==
X-Received: by 2002:a05:6300:210a:b0:34e:63bd:81b6 with SMTP id adf61e73a8af0-364038a8011mr5080964637.57.1764876647880;
        Thu, 04 Dec 2025 11:30:47 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:30:47 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:23 +0800
Subject: [PATCH v4 15/19] mm, swap: add folio to swap cache directly on
 allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-15-cb7e28a26a40@tencent.com>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
In-Reply-To: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=18723;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=BxXagGN27AymwvRdBIePUrZRA0RRAtj5IVycx0gjxDs=;
 b=pF49cXCbStz4Hga0KWpwTB/BQpANlKQWM0Tnm+xrcnsGRhTEmaTStnNNCjaMQEixLZjY3iPvn
 YhMQUNk2n9VCNpFBa6GdL2groKvWAK4OCQrzTvwOX1gjmnH+iAQ1k3q
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2AF5A40012
X-Stat-Signature: ai8paaayyd73h478ng1n3qgae9nup61m
X-Rspam-User: 
X-HE-Tag: 1764876648-212963
X-HE-Meta: U2FsdGVkX18g5REZL/6jXoS2eO5sgwoCkvITobbFNcQ+UO7gSMd3tPM4N5qw3AGnovlr1yA6nWg0Syf3dKxxJgFqW1zBuJM7krzMTr7s3pqvDk+euhscFlLHtxIhgElgp9SawGaZj/VjthivJE7HMOx7xkcKwuML3E9unrEyUy8zJoGaIUoznqu9eBwpenOJmzkxhWbchFv5WgVNbHbViMwmHRMJ8qsfs26lnKt5kOpILQIzZwqP33r/PEtB9y/Uc2Q3Go1/znWTKyhyDRwEOeE/SNYHOo5L7CssGYgstnYWpSoM7NRHj/5qQ7Vpzsxw2zH1VrVtAqQvgnZWUoaypn1OrvB4FQB5N8T3OXhavSKQO6q/m1tiMfGRZEYKtdCGsBQsg2OY2d+VEo3pKwNFHsuj+eUnFR5QCP5sUij6IUubPKXKotSqbjyi42k05oF++KOSiTGDWVG+FaxjYKv5DN98GNascMFjSVNnR3G+PpvTX/PGkfWAobGAnWLAsj6sHRKs2NLkb4jkgs8R9ms/cMQYPzOiYiTO9EALaXe1KLmlRRU2srGx5y5+1Erm0dhykhoytY8iAaZrdMfhFSUq5tRcRYMmkNJ/7I2733/fxf77GBz47JCXa6+ztHdKCYZLMiRdPKOSMdV5mPcgxAU1uO9h4lfVw+uTDc3Uy0mKmUSOKxfs8mjvZrKg9RbxKNTR4LVYI+cL849Fv3oxa/PAR1n6laoovHE8Dm7o8eSqEpfmC6vicvyo73GFP6NQj1bLp9LLuvyn6aPdMU39AoTyHHT/Sm/hoJQEKWeiyckeJJwJb+pbsm9shVF9ZDIocHQcBv5CUchyazyAoW9IqhPKmvUWymzAFYiORPBuGDNlovEmtiE9a5Nij02a36fd+2gx0ezR/flO1DnPiwv2Z9T/rym/1/8W3BAa7jAV3zcVRj7MQWZ4YrOCnQhbw/b6gqmryUlI1t1U2flrWXIVcOu
 jHkSSr0j
 X8UM5jkPjeCvn2HfrZ+Tm9xcLjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The allocator uses SWAP_HAS_CACHE to pin a swap slot upon allocation.
SWAP_HAS_CACHE is being deprecated as it caused a lot of confusion.
This pinning usage here can be dropped by adding the folio to swap
cache directly on allocation.

All swap allocations are folio-based now (except for hibernation), so
the swap allocator can always take the folio as the parameter. And now
both swap cache (swap table) and swap map are protected by the cluster
lock, scanning the map and inserting the folio can be done in the same
critical section. This eliminates the time window that a slot is pinned
by SWAP_HAS_CACHE, but it has no cache, and avoids touching the lock
multiple times.

This is both a cleanup and an optimization.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |   5 --
 mm/swap.h            |  10 +---
 mm/swap_state.c      |  58 +++++++++++--------
 mm/swapfile.c        | 161 ++++++++++++++++++++++-----------------------------
 4 files changed, 105 insertions(+), 129 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ac3caa4c6999..4b4b81fbc6a3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -452,7 +452,6 @@ static inline long get_nr_swap_pages(void)
 }
 
 extern void si_swapinfo(struct sysinfo *);
-void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 int swap_type_of(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
@@ -534,10 +533,6 @@ static inline void swap_put_entries_direct(swp_entry_t ent, int nr)
 {
 }
 
-static inline void put_swap_folio(struct folio *folio, swp_entry_t swp)
-{
-}
-
 static inline int __swap_count(swp_entry_t entry)
 {
 	return 0;
diff --git a/mm/swap.h b/mm/swap.h
index 9ed12936b889..ec1ef7d0c35b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -277,13 +277,13 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-			 void **shadow, bool alloc);
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
 				     struct mempolicy *mpol, pgoff_t ilx,
 				     bool *alloced);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
+void __swap_cache_add_folio(struct swap_cluster_info *ci,
+			    struct folio *folio, swp_entry_t entry);
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
@@ -459,12 +459,6 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
-static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-				       void **shadow, bool alloc)
-{
-	return -ENOENT;
-}
-
 static inline void swap_cache_del_folio(struct folio *folio)
 {
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 1a69ba3be87f..f478a16f43e9 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -122,35 +122,56 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
+void __swap_cache_add_folio(struct swap_cluster_info *ci,
+			    struct folio *folio, swp_entry_t entry)
+{
+	unsigned long new_tb;
+	unsigned int ci_start, ci_off, ci_end;
+	unsigned long nr_pages = folio_nr_pages(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
+
+	new_tb = folio_to_swp_tb(folio);
+	ci_start = swp_cluster_offset(entry);
+	ci_off = ci_start;
+	ci_end = ci_start + nr_pages;
+	do {
+		VM_WARN_ON_ONCE(swp_tb_is_folio(__swap_table_get(ci, ci_off)));
+		__swap_table_set(ci, ci_off, new_tb);
+	} while (++ci_off < ci_end);
+
+	folio_ref_add(folio, nr_pages);
+	folio_set_swapcache(folio);
+	folio->swap = entry;
+
+	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
+}
+
 /**
  * swap_cache_add_folio - Add a folio into the swap cache.
  * @folio: The folio to be added.
  * @entry: The swap entry corresponding to the folio.
  * @gfp: gfp_mask for XArray node allocation.
  * @shadowp: If a shadow is found, return the shadow.
- * @alloc: If it's the allocator that is trying to insert a folio. Allocator
- *         sets SWAP_HAS_CACHE to pin slots before insert so skip map update.
  *
  * Context: Caller must ensure @entry is valid and protect the swap device
  * with reference count or locks.
  */
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-			 void **shadowp, bool alloc)
+static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+				void **shadowp)
 {
 	int err;
 	void *shadow = NULL;
+	unsigned long old_tb;
 	struct swap_info_struct *si;
-	unsigned long old_tb, new_tb;
 	struct swap_cluster_info *ci;
 	unsigned int ci_start, ci_off, ci_end, offset;
 	unsigned long nr_pages = folio_nr_pages(folio);
 
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
-
 	si = __swap_entry_to_info(entry);
-	new_tb = folio_to_swp_tb(folio);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
 	ci_off = ci_start;
@@ -166,7 +187,7 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 			err = -EEXIST;
 			goto failed;
 		}
-		if (!alloc && unlikely(!__swap_count(swp_entry(swp_type(entry), offset)))) {
+		if (unlikely(!__swap_count(swp_entry(swp_type(entry), offset)))) {
 			err = -ENOENT;
 			goto failed;
 		}
@@ -182,20 +203,11 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 		 * Still need to pin the slots with SWAP_HAS_CACHE since
 		 * swap allocator depends on that.
 		 */
-		if (!alloc)
-			__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
-		__swap_table_set(ci, ci_off, new_tb);
+		__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
 		offset++;
 	} while (++ci_off < ci_end);
-
-	folio_ref_add(folio, nr_pages);
-	folio_set_swapcache(folio);
-	folio->swap = entry;
+	__swap_cache_add_folio(ci, folio, entry);
 	swap_cluster_unlock(ci);
-
-	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
-	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
-
 	if (shadowp)
 		*shadowp = shadow;
 	return 0;
@@ -464,7 +476,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
 	for (;;) {
-		ret = swap_cache_add_folio(folio, entry, &shadow, false);
+		ret = swap_cache_add_folio(folio, entry, &shadow);
 		if (!ret)
 			break;
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 772356c38b83..aaa8790241a8 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -884,28 +884,57 @@ static void swap_cluster_assert_table_empty(struct swap_cluster_info *ci,
 	}
 }
 
-static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster_info *ci,
-				unsigned int start, unsigned char usage,
-				unsigned int order)
+static bool cluster_alloc_range(struct swap_info_struct *si,
+				struct swap_cluster_info *ci,
+				struct folio *folio,
+				unsigned int offset)
 {
-	unsigned int nr_pages = 1 << order;
+	unsigned long nr_pages;
+	unsigned int order;
 
 	lockdep_assert_held(&ci->lock);
 
 	if (!(si->flags & SWP_WRITEOK))
 		return false;
 
+	/*
+	 * All mm swap allocation starts with a folio (folio_alloc_swap),
+	 * it's also the only allocation path for large orders allocation.
+	 * Such swap slots starts with count == 0 and will be increased
+	 * upon folio unmap.
+	 *
+	 * Else, it's a exclusive order 0 allocation for hibernation.
+	 * The slot starts with count == 1 and never increases.
+	 */
+	if (likely(folio)) {
+		order = folio_order(folio);
+		nr_pages = 1 << order;
+		/*
+		 * Pin the slot with SWAP_HAS_CACHE to satisfy swap_dup_entries.
+		 * This is the legacy allocation behavior, will drop it very soon.
+		 */
+		memset(si->swap_map + offset, SWAP_HAS_CACHE, nr_pages);
+		__swap_cache_add_folio(ci, folio, swp_entry(si->type, offset));
+	} else if (IS_ENABLED(CONFIG_HIBERNATION)) {
+		order = 0;
+		nr_pages = 1;
+		WARN_ON_ONCE(si->swap_map[offset]);
+		si->swap_map[offset] = 1;
+		swap_cluster_assert_table_empty(ci, offset, 1);
+	} else {
+		/* Allocation without folio is only possible with hibernation */
+		WARN_ON_ONCE(1);
+		return false;
+	}
+
 	/*
 	 * The first allocation in a cluster makes the
 	 * cluster exclusive to this order
 	 */
 	if (cluster_is_empty(ci))
 		ci->order = order;
-
-	memset(si->swap_map + start, usage, nr_pages);
-	swap_cluster_assert_table_empty(ci, start, nr_pages);
-	swap_range_alloc(si, nr_pages);
 	ci->count += nr_pages;
+	swap_range_alloc(si, nr_pages);
 
 	return true;
 }
@@ -913,13 +942,12 @@ static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster
 /* Try use a new cluster for current CPU and allocate from it. */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
-					    unsigned long offset,
-					    unsigned int order,
-					    unsigned char usage)
+					    struct folio *folio, unsigned long offset)
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
+	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned int nr_pages = 1 << order;
 	bool need_reclaim, ret, usable;
 
@@ -943,7 +971,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 			if (!ret)
 				continue;
 		}
-		if (!cluster_alloc_range(si, ci, offset, usage, order))
+		if (!cluster_alloc_range(si, ci, folio, offset))
 			break;
 		found = offset;
 		offset += nr_pages;
@@ -965,8 +993,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 
 static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 					 struct list_head *list,
-					 unsigned int order,
-					 unsigned char usage,
+					 struct folio *folio,
 					 bool scan_all)
 {
 	unsigned int found = SWAP_ENTRY_INVALID;
@@ -978,7 +1005,7 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 		if (!ci)
 			break;
 		offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, offset, order, usage);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		if (found)
 			break;
 	} while (scan_all);
@@ -1039,10 +1066,11 @@ static void swap_reclaim_work(struct work_struct *work)
  * Try to allocate swap entries with specified order and try set a new
  * cluster for current CPU too.
  */
-static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int order,
-					      unsigned char usage)
+static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
+					      struct folio *folio)
 {
 	struct swap_cluster_info *ci;
+	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
@@ -1064,8 +1092,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, offset,
-							order, usage);
+			found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		} else {
 			swap_cluster_unlock(ci);
 		}
@@ -1079,22 +1106,19 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 	 * to spread out the writes.
 	 */
 	if (si->flags & SWP_PAGE_DISCARD) {
-		found = alloc_swap_scan_list(si, &si->free_clusters, order, usage,
-					     false);
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
 	}
 
 	if (order < PMD_ORDER) {
-		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order],
-					     order, usage, true);
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order], folio, true);
 		if (found)
 			goto done;
 	}
 
 	if (!(si->flags & SWP_PAGE_DISCARD)) {
-		found = alloc_swap_scan_list(si, &si->free_clusters, order, usage,
-					     false);
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
 	}
@@ -1110,8 +1134,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * failure is not critical. Scanning one cluster still
 		 * keeps the list rotated and reclaimed (for HAS_CACHE).
 		 */
-		found = alloc_swap_scan_list(si, &si->frag_clusters[order], order,
-					     usage, false);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
 		if (found)
 			goto done;
 	}
@@ -1125,13 +1148,11 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * Clusters here have at least one usable slots and can't fail order 0
 		 * allocation, but reclaim may drop si->lock and race with another user.
 		 */
-		found = alloc_swap_scan_list(si, &si->frag_clusters[o],
-					     0, usage, true);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[o], folio, true);
 		if (found)
 			goto done;
 
-		found = alloc_swap_scan_list(si, &si->nonfull_clusters[o],
-					     0, usage, true);
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[o], folio, true);
 		if (found)
 			goto done;
 	}
@@ -1322,12 +1343,12 @@ static bool get_swap_device_info(struct swap_info_struct *si)
  * Fast path try to get swap entries with specified order from current
  * CPU's swap entry pool (a cluster).
  */
-static bool swap_alloc_fast(swp_entry_t *entry,
-			    int order)
+static bool swap_alloc_fast(struct folio *folio)
 {
+	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
-	unsigned int offset, found = SWAP_ENTRY_INVALID;
+	unsigned int offset;
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
@@ -1342,22 +1363,18 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 	if (cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, offset, order, SWAP_HAS_CACHE);
-		if (found)
-			*entry = swp_entry(si->type, found);
+		alloc_swap_scan_cluster(si, ci, folio, offset);
 	} else {
 		swap_cluster_unlock(ci);
 	}
 
 	put_swap_device(si);
-	return !!found;
+	return folio_test_swapcache(folio);
 }
 
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_slow(swp_entry_t *entry,
-			    int order)
+static void swap_alloc_slow(struct folio *folio)
 {
-	unsigned long offset;
 	struct swap_info_struct *si, *next;
 
 	spin_lock(&swap_avail_lock);
@@ -1367,13 +1384,11 @@ static void swap_alloc_slow(swp_entry_t *entry,
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
-			offset = cluster_alloc_swap_entry(si, order, SWAP_HAS_CACHE);
+			cluster_alloc_swap_entry(si, folio);
 			put_swap_device(si);
-			if (offset) {
-				*entry = swp_entry(si->type, offset);
+			if (folio_test_swapcache(folio))
 				return;
-			}
-			if (order)
+			if (folio_test_large(folio))
 				return;
 		}
 
@@ -1438,7 +1453,6 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
-	swp_entry_t entry = {};
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1463,39 +1477,23 @@ int folio_alloc_swap(struct folio *folio)
 
 again:
 	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(&entry, order))
-		swap_alloc_slow(&entry, order);
+	if (!swap_alloc_fast(folio))
+		swap_alloc_slow(folio);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	if (unlikely(!order && !entry.val)) {
+	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
 			goto again;
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (mem_cgroup_try_charge_swap(folio, entry))
-		goto out_free;
+	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
+		swap_cache_del_folio(folio);
 
-	if (!entry.val)
+	if (unlikely(!folio_test_swapcache(folio)))
 		return -ENOMEM;
 
-	/*
-	 * Allocator has pinned the slots with SWAP_HAS_CACHE
-	 * so it should never fail
-	 */
-	WARN_ON_ONCE(swap_cache_add_folio(folio, entry, NULL, true));
-
-	/*
-	 * Allocator should always allocate aligned entries so folio based
-	 * operations never crossed more than one cluster.
-	 */
-	VM_WARN_ON_ONCE_FOLIO(!IS_ALIGNED(folio->swap.val, size), folio);
-
 	return 0;
-
-out_free:
-	put_swap_folio(folio, entry);
-	return -ENOMEM;
 }
 
 /**
@@ -1798,29 +1796,6 @@ static void swap_entries_free(struct swap_info_struct *si,
 		partial_free_cluster(si, ci);
 }
 
-/*
- * Called after dropping swapcache to decrease refcnt to swap entries.
- */
-void put_swap_folio(struct folio *folio, swp_entry_t entry)
-{
-	struct swap_info_struct *si;
-	struct swap_cluster_info *ci;
-	unsigned long offset = swp_offset(entry);
-	int size = 1 << swap_entry_order(folio_order(folio));
-
-	si = _swap_info_get(entry);
-	if (!si)
-		return;
-
-	ci = swap_cluster_lock(si, offset);
-	if (swap_only_has_cache(si, offset, size))
-		swap_entries_free(si, ci, entry, size);
-	else
-		for (int i = 0; i < size; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
-	swap_cluster_unlock(ci);
-}
-
 int __swap_count(swp_entry_t entry)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
@@ -2071,7 +2046,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 			 * with swap table allocation.
 			 */
 			local_lock(&percpu_swap_cluster.lock);
-			offset = cluster_alloc_swap_entry(si, 0, 1);
+			offset = cluster_alloc_swap_entry(si, NULL);
 			local_unlock(&percpu_swap_cluster.lock);
 			if (offset)
 				entry = swp_entry(si->type, offset);

-- 
2.52.0


