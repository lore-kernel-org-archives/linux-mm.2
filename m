Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6544CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 04:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48708E0008; Mon,  8 Sep 2025 00:50:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C205C8E0001; Mon,  8 Sep 2025 00:50:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B36688E0008; Mon,  8 Sep 2025 00:50:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD058E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:50:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 083E85C0FE
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:50:07 +0000 (UTC)
X-FDA: 83864856054.29.910BEA7
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id 427D340007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:50:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SR+3bWZ9;
	spf=pass (imf27.hostedemail.com: domain of 3fGC-aAsKCIMsvrlzonpkyhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--lokeshgidra.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3fGC-aAsKCIMsvrlzonpkyhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757307005; a=rsa-sha256;
	cv=none;
	b=hk4ODNWhm2XIxxdJmNQ6wOoSqkuQR3SQsrBYjl378yalyI7uCCZ/ZYyOGoCr6+WljgTd98
	UJ5ZS7tvCE5XPQlbz4ZJRylAGRQJpvuNBiT9xPn5aRh7onm+cDIACRjdNEAySPboz3HECk
	HLnh/SWwfywA1GaVtsjCfKEXzxfLFq4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SR+3bWZ9;
	spf=pass (imf27.hostedemail.com: domain of 3fGC-aAsKCIMsvrlzonpkyhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--lokeshgidra.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3fGC-aAsKCIMsvrlzonpkyhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757307005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=X2X3MtFTyLRiZtJRwCavGgKr1cLGqB8t8a1EeEIc6Xk=;
	b=2HWWgVmrI/UsoJcQL84M2Zjyu9mNmYdkiViKiXjqJX32jCiZ9ZdwmBUJ7jfes97NQW+Q3g
	RYHDepUic33+LM27dGju7cXzOkocncLy1WY7s/UTNHnPgCCyVS//Hv6DuACET1ei7da4jU
	9D369YSm3Zm3Z5r8jRBH/01fExZgjWE=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24cc4458e89so89858065ad.1
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 21:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757307004; x=1757911804; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X2X3MtFTyLRiZtJRwCavGgKr1cLGqB8t8a1EeEIc6Xk=;
        b=SR+3bWZ97ntDnrSMnJFPkFkWnrIowOZCqk3+9XJRjflYl51kUlSHmyIgahjm4ox0/K
         ZYQBucHayRQ9uOm6K/6unPAY3yWe37ItjJrmrS6k86u8PtuK7yzhrB5o6lsXER6PF8Dh
         8Pybu4qPoz4yCSYDf6rLeyAGQnWjBe1F8SuxyTMRGpreoAzE98xjSbc9LdxARLWtrGf9
         nynR3HqUbgy5joprslxt7Y1jdzZ0gEM7Ia5PdqmDShrRC5o4lPSppsL9LiEkZgYpxwH/
         cgMj90u4tG2zhY6gjbA9xQ3f+5vrS+59fehhPlAsKmEkObS3CSQUESuHVEjyJX73GGaI
         YfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757307004; x=1757911804;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X2X3MtFTyLRiZtJRwCavGgKr1cLGqB8t8a1EeEIc6Xk=;
        b=Eo3Fnq9C9tmdCRvA7NtPqEua8NgL1fUQ+x3CzYn474FEDawQHTlo5iA3R0c2y55v+i
         iisIBs0QaiTmQ3KjN+OcJ7hWKoX87Xicy+Z8jj7w7cmwSXbDQYGFPTArCh4wWWAoV5ft
         hrKRZ79r6kkAf0FmM22w1sksDSEfnRBd6vImiUFIGMiluJzNMZG+A4C0d2fyMN5zEQnR
         IwKoIi8fm0/ILGd6Q9I5+augGyIZyMdOeNx3CeIulRatWmAk9M1L7nmiMAzKtwIhBcvl
         oYd7s/PoJMziUPBd1gdT8ukzDPZK2O50Fe5Dw1PzbXbX75BccFki5Nz3ZErl9GN1cJc+
         JXxA==
X-Gm-Message-State: AOJu0YxlJrej1Q3MAHRKNbWz2noc9p38Nu5qsVthGkPK4rofwAcDaEPd
	0pyWhg0ms7YGYpazGrSUFRDMJTPaMgmkVCfrluu6eNFp1E+N17sQ2LL6+lrjXol7YjR0Kl9dJsq
	GuOPBrrAsFd3n0/FOwEtlO0pacA==
X-Google-Smtp-Source: AGHT+IHVWWuGSgOnHa1JpBVSXE5lehOwB+xvJWbRsFZGbjJJVVMxXvInygIqn0d61ESlhZOqGDYEW/bnjw7Fkmp8BQ==
X-Received: from plbku14.prod.google.com ([2002:a17:903:288e:b0:24c:c577:8e97])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2b0b:b0:24c:e9e8:6caa with SMTP id d9443c01a7336-2516d52c99dmr90751445ad.4.1757307004001;
 Sun, 07 Sep 2025 21:50:04 -0700 (PDT)
Date: Sun,  7 Sep 2025 21:49:49 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.355.g5224444f11-goog
Message-ID: <20250908044950.311548-1-lokeshgidra@google.com>
Subject: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com, 
	Lokesh Gidra <lokeshgidra@google.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, 
	SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 427D340007
X-Stat-Signature: jer1xu3u7jfn5czw1hbur5ohj9yig8xn
X-Rspam-User: 
X-HE-Tag: 1757307005-529339
X-HE-Meta: U2FsdGVkX1+pJUCc+V2eAhmnDL9CyYVww0Qv2n69w7EMxi0BLEM7+ucpc5X6JbL80A8XfFlCkhfqTSpZhs9JeOZnjZyT4y4hpkHt4In0kh8XCI5GlM/IYImldpmLUjLsjSuxqLAJfvL9Mj0MeKYx/QBff1LH6rvwMqTMJEn8V9wUJ85+m0sqOT5GbynzLWK7E9orS+sOUiLgLwzJok/LG6cuwI64Tx8Bw1sLgChUVSJkfZMJrOasjGH6JpR4kWvHh88G/hjX8Zwq+draTv/PbCiRYBRafpmKByYCxdMgQG3lurMZoJRz8rBtT4QYAom2NK3Khbc0k1GLr7H6vibo1sSdbIXKKHbN0Ui3m1vTFV5dLBwnGQpqYCcdUTRG3yvduRD3ufVD4mP58KVbc4hCQ4EK8NrQW9zEu5Qj6zOOq6ZSJpu8B0IhRy3ZzfbzpGZxdAX51oKV6CChcmdUsOaN/sPxCOVxhj7J8XzMhdTBdXNDq8Fkdnykdwl7qsbw7FlXCAeYuvPn849wbhJtSlrnK2Yvz/utzjsJhuz8peRC6NxxQNJCgNFJliG0Be1ooXT/xZi7pbZrne82Dgm6yX3GUyMUl0Kw9aSh1JvscWqlnWXnK9ONEJDuglvw06+tPMs0W98aLqYXMhoY5MA1mW0sjyMT1ARxk79y9qrpzmAMwlXmmGnAqcpZ0SbkdTg8HbQiNNY6xMxS00xikJqny1kKEV+EiHxiPZM7aQ/ANjYgX7huQYrMTFARTOd5yNyQnd5RQrO6sfXdEXGe0F48yDRL8T0krlns4fvxXNbnwTXdu3L2QGTGmqSU00+xXgU6BR1eaKuuuipQTGYCGWKwH8xKx4cIgrRvAsnpBkdOdKNDoa8RolkLqZ6LAFcMbWZ13eGsiWuODCcDPv9DRIppj8gUYafRh2HXujg0BQcPEt2a3rDAs4BWnRlVleXTIw9+3kX6dMRQvUAFGFbjaGp8z+6
 JF1A91be
 vFbDqVaIXryQu9l2fTV9aubGgrjp/mS7Qu8yQFswQKRNfL7YSNMDMCoVlYHRLoPkYgtryoXRmk7JnXTMugkDskfF4FAsa4St2o3+z3iNjrdgAaI8+yEH+mY85JW/3VeikIOlFLrNr1VPkZAXv0p+QFzgEPfTITiNH/pd4Z8FlhQQwz/MZ48LHw5P7NPKxVT9ajT4xziEtVwC0rk538gF01z3LQpU9xA0KJkevkWG9pDrTHNckfbMZ/C0mYfguZNDy8PpNP7FG6gu5PHZucjRGUTvicQFqR3PLYFLjpv0TlBV1EOH5CSOUZofP8diy8NHaXnBIVdtRLFiT1FP228jtgufwQtRsAU5cjXLZlDw4TI1I7tNXyRq50/onWUzusxzuujtxUYLr+ezksJX7y+haHv/O62IvDgixx6+W563MODOuEJfYG+wnTXQeqiIkq3cMP64J3yKCxA1erGHSw/8OVwrJpbuDM8cLfWjtt7hghGu8eMPbDz5sGXK6JdgNJJ8OkOEYUD2W7nw0GYD8/xMsETcuyczueWL8yd5tH+/OXcZ6D65GZzw6yKk10keeQiwX26CgkoWW4GDm7Aa9UMuKPSyFn89lHeAH8/Gpwzx7ANq8QTSJ2Hp+9SOd+iZnXvBMkS7a97m4ynacc6oUXQIa7UQxKF9k0q8LhK8iwo/B49CeRM7UUzNg5WH4PTU+034kYX18XDswA2/YIKMcFpe1Yut44wZ+SofdOqZ0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prior discussion about this can be found at [1].

rmap_walk() requires all folios, except non-KSM anon, to be locked. This
implies that when threads update folio->mapping to an anon_vma with
different root (currently only done by UFFDIO MOVE), they have to
serialize against rmap_walk() with write-lock on the anon_vma, hurting
scalability. Furthermore, this necessitates rechecking anon_vma when
pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).

This can be simplified quite a bit by ensuring that rmap_walk() is
always called on locked folios. Among the few callers of rmap_walk() on
unlocked anon folios, shrink_active_list()->folio_referenced() is the
only performance critical one.

shrink_active_list() doesn't act differently depending on what
folio_referenced() returns for an anon folio. So returning 1 when it
is contended, like in case of other folio types, wouldn't have any
negative impact.

Furthermore, as David pointed out in the previous discussion [2], this
could potentially only affect R/O pages after fork as PG_anon_exclusive
is not set. But, such folios are already isolated (prior to calling
folio_referenced()) by grabbing a reference and clearing LRU, so
do_wp_page()->wp_can_reuse_anon_folio() would not reuse such folios
anyways.

[1] https://lore.kernel.org/all/CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com/
[2] https://lore.kernel.org/all/dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com/

CC: David Hildenbrand <david@redhat.com>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Harry Yoo <harry.yoo@oracle.com>
CC: Peter Xu <peterx@redhat.com>
CC: Suren Baghdasaryan <surenb@google.com>
CC: Barry Song <baohua@kernel.org>
CC: SeongJae Park <sj@kernel.org>
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
---
 mm/damon/ops-common.c | 16 ++++------------
 mm/page_idle.c        |  8 ++------
 mm/rmap.c             | 40 ++++++++++------------------------------
 3 files changed, 16 insertions(+), 48 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 998c5180a603..f61d6dde13dc 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -162,21 +162,17 @@ void damon_folio_mkold(struct folio *folio)
 		.rmap_one = damon_folio_mkold_one,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
-	bool need_lock;
 
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
 		folio_set_idle(folio);
 		return;
 	}
 
-	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
-	if (need_lock && !folio_trylock(folio))
+	if (!folio_trylock(folio))
 		return;
 
 	rmap_walk(folio, &rwc);
-
-	if (need_lock)
-		folio_unlock(folio);
+	folio_unlock(folio);
 
 }
 
@@ -228,7 +224,6 @@ bool damon_folio_young(struct folio *folio)
 		.rmap_one = damon_folio_young_one,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
-	bool need_lock;
 
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
 		if (folio_test_idle(folio))
@@ -237,14 +232,11 @@ bool damon_folio_young(struct folio *folio)
 			return true;
 	}
 
-	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
-	if (need_lock && !folio_trylock(folio))
+	if (!folio_trylock(folio))
 		return false;
 
 	rmap_walk(folio, &rwc);
-
-	if (need_lock)
-		folio_unlock(folio);
+	folio_unlock(folio);
 
 	return accessed;
 }
diff --git a/mm/page_idle.c b/mm/page_idle.c
index a82b340dc204..9bf573d22e87 100644
--- a/mm/page_idle.c
+++ b/mm/page_idle.c
@@ -101,19 +101,15 @@ static void page_idle_clear_pte_refs(struct folio *folio)
 		.rmap_one = page_idle_clear_pte_refs_one,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
-	bool need_lock;
 
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio))
 		return;
 
-	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
-	if (need_lock && !folio_trylock(folio))
+	if (!folio_trylock(folio))
 		return;
 
 	rmap_walk(folio, &rwc);
-
-	if (need_lock)
-		folio_unlock(folio);
+	folio_unlock(folio);
 }
 
 static ssize_t page_idle_bitmap_read(struct file *file, struct kobject *kobj,
diff --git a/mm/rmap.c b/mm/rmap.c
index 34333ae3bd80..fc53f31434f4 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -489,17 +489,15 @@ void __init anon_vma_init(void)
  * if there is a mapcount, we can dereference the anon_vma after observing
  * those.
  *
- * NOTE: the caller should normally hold folio lock when calling this.  If
- * not, the caller needs to double check the anon_vma didn't change after
- * taking the anon_vma lock for either read or write (UFFDIO_MOVE can modify it
- * concurrently without folio lock protection). See folio_lock_anon_vma_read()
- * which has already covered that, and comment above remap_pages().
+ * NOTE: the caller should hold folio lock when calling this.
  */
 struct anon_vma *folio_get_anon_vma(const struct folio *folio)
 {
 	struct anon_vma *anon_vma = NULL;
 	unsigned long anon_mapping;
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
 	rcu_read_lock();
 	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
 	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
@@ -546,7 +544,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 	struct anon_vma *root_anon_vma;
 	unsigned long anon_mapping;
 
-retry:
 	rcu_read_lock();
 	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
 	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
@@ -557,17 +554,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 	anon_vma = (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_ANON);
 	root_anon_vma = READ_ONCE(anon_vma->root);
 	if (down_read_trylock(&root_anon_vma->rwsem)) {
-		/*
-		 * folio_move_anon_rmap() might have changed the anon_vma as we
-		 * might not hold the folio lock here.
-		 */
-		if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
-			     anon_mapping)) {
-			up_read(&root_anon_vma->rwsem);
-			rcu_read_unlock();
-			goto retry;
-		}
-
 		/*
 		 * If the folio is still mapped, then this anon_vma is still
 		 * its anon_vma, and holding the mutex ensures that it will
@@ -602,18 +588,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 	rcu_read_unlock();
 	anon_vma_lock_read(anon_vma);
 
-	/*
-	 * folio_move_anon_rmap() might have changed the anon_vma as we might
-	 * not hold the folio lock here.
-	 */
-	if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
-		     anon_mapping)) {
-		anon_vma_unlock_read(anon_vma);
-		put_anon_vma(anon_vma);
-		anon_vma = NULL;
-		goto retry;
-	}
-
 	if (atomic_dec_and_test(&anon_vma->refcount)) {
 		/*
 		 * Oops, we held the last refcount, release the lock
@@ -1005,7 +979,7 @@ int folio_referenced(struct folio *folio, int is_locked,
 	if (!folio_raw_mapping(folio))
 		return 0;
 
-	if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
+	if (!is_locked) {
 		we_locked = folio_trylock(folio);
 		if (!we_locked)
 			return 1;
@@ -2815,6 +2789,12 @@ static void rmap_walk_anon(struct folio *folio,
 	pgoff_t pgoff_start, pgoff_end;
 	struct anon_vma_chain *avc;
 
+	/*
+	 * The folio lock ensures that folio->mapping can be changed under us to
+	 * an anon_vma with different root, like UFFDIO MOVE.
+	 */
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+
 	if (locked) {
 		anon_vma = folio_anon_vma(folio);
 		/* anon_vma disappear under us? */

base-commit: b024763926d2726978dff6588b81877d000159c1
-- 
2.51.0.355.g5224444f11-goog


