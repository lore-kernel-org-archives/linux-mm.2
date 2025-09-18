Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A3BCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DC998E00B6; Thu, 18 Sep 2025 01:52:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4798E0093; Thu, 18 Sep 2025 01:52:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA3F8E00B6; Thu, 18 Sep 2025 01:52:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7899F8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:52:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36C69140784
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:52:25 +0000 (UTC)
X-FDA: 83901301050.07.1653CA6
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B3111C0009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:52:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=abOHjqoY;
	spf=pass (imf21.hostedemail.com: domain of 3Fp7LaAsKCM0473xB0z1wAtz77z4x.v75416DG-553Etv3.7Az@flex--lokeshgidra.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3Fp7LaAsKCM0473xB0z1wAtz77z4x.v75416DG-553Etv3.7Az@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758174743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5Nwep1BnaAnj6TN47zbA8eQDQD3w4YBt1QTHeVixxY=;
	b=rD2ZYFCjVOmNKHAEuHYoOkdsz02pTHEV2UCtGZDJbgJzqMDzc4ST319JssjWpM8s8BQkwr
	5BlrpcHmet/dLy4AshBe5AomvWqGImAMc1cYAtI6TdtkEQiKPZOcaFOUAqRL2dCL1r5sk3
	GaIbQaaydKJvDz6awsye45K/umaelEw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758174743; a=rsa-sha256;
	cv=none;
	b=hr3RNlpSBEs34UbINLVbvQmAK6/Y6YSgOesx0+iSnGw41lRRYRyKx9LonsqE69m7drE2jg
	NypdrE/o9/y51NU9kuR07Qf3TZx2pn4c5L/i3wi9kP2sUHfX03nUPKevyCDrZxYBuyG+o8
	DSdPohY8iL+RxVaafiCIKVXkrQnMqxc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=abOHjqoY;
	spf=pass (imf21.hostedemail.com: domain of 3Fp7LaAsKCM0473xB0z1wAtz77z4x.v75416DG-553Etv3.7Az@flex--lokeshgidra.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3Fp7LaAsKCM0473xB0z1wAtz77z4x.v75416DG-553Etv3.7Az@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-248d9301475so7867725ad.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758174742; x=1758779542; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M5Nwep1BnaAnj6TN47zbA8eQDQD3w4YBt1QTHeVixxY=;
        b=abOHjqoYjrvwa5YOLBLQX6g2+swAebLcnLnwgy5i5J2dI65tEpDUMs/Z99h1iq85jM
         wclzu4mlZvYQI+ZmroFoE9koU6KtKPrEtPueuvPxgWQiSLgJHpx0l0lPD8wCGdmozyL3
         i4sfxur9VS/2HKmiwar4eZhW0cwqJVFD9qdm9yoqkmXH6pBM/rBgVaPJQ2s8IRj9IlG+
         LuLXYBTgrR2DbyFeUkRtBDN1ujvLOyYfJ/e5tJkr0GUfHmHb4dLqoKHVJZgbv6rLsYnS
         la/L3GD46ERChExeC3JDd5z+gYyT0+X4/NrQl1or/Qau8aUAImdepwV2HV12bH+UYhja
         qZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758174742; x=1758779542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M5Nwep1BnaAnj6TN47zbA8eQDQD3w4YBt1QTHeVixxY=;
        b=vY1Az0DF5Cp8bHSzdPypsb9/0ZS9Q7+52UaiK+WMhWV4E67i1AKGByfezkfYvjx/W1
         OsEBt2GQytE6yuq7VpUKfDpewmRh4qyaHq8AlbktlCXlN0wEVb7M3YNbLR0CsKCyKt2L
         jR8ewfWP8ptrzX1jwbLBsEoSw1GEPgRQRzLKLG6qgNmzU2IkmviFrRV4BWi9fv2tZl3g
         1vitBK4uDegIhE8e/VEbXLUZw2se65UIBs1lDIRkocA6jQj4f8NQfJImsDH0FzIxLZjv
         CcrfYIvriF3dOqYUu38mtQFVNuEmevGtwdh39J3LTYCkWQ6Kdinybq+TI96HG7xmQ1Qm
         wDcg==
X-Gm-Message-State: AOJu0YzcNTM6lp9LnSqo6Io5m9E0s9MwgicJjbtrzhw3NoXphYPoAfmT
	5yVE9tm/0Z1cd7VfyE4UMdTlBfYyXKWmGtUeOpbyEPKuogow+cHMhAGFx6vxxA7ztUbEvltXTfk
	8SkvfOAqt1i70I7UU4CAJKXmQ0g==
X-Google-Smtp-Source: AGHT+IF6mbe/3xdpbFbAWb08uDBaNk2XXvfqctorMWMFQGmeMRSqbUuVrE7XBG4G1SKfkBv56kF08KkseQvB/ILKSA==
X-Received: from plbiz4.prod.google.com ([2002:a17:902:ef84:b0:24c:863e:86a3])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f70a:b0:250:b622:c74d with SMTP id d9443c01a7336-268137f31a1mr56726695ad.37.1758174742472;
 Wed, 17 Sep 2025 22:52:22 -0700 (PDT)
Date: Wed, 17 Sep 2025 22:51:34 -0700
In-Reply-To: <20250918055135.2881413-1-lokeshgidra@google.com>
Mime-Version: 1.0
References: <20250918055135.2881413-1-lokeshgidra@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918055135.2881413-2-lokeshgidra@google.com>
Subject: [PATCH 1/2] mm: always call rmap_walk() on locked folios
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com, 
	jannh@google.com, Lokesh Gidra <lokeshgidra@google.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8B3111C0009
X-Stat-Signature: 7ac34rmdrhk8hbs4rsakc9gewp57khs5
X-Rspam-User: 
X-HE-Tag: 1758174743-70287
X-HE-Meta: U2FsdGVkX184Krhq0ZP6kns6n1p8f/dO/McDywmZkxZF+VFoPxffWy6yhAWooULGRIAVZUWLaJEIredykKR6da+jcSp7qMNzAG4Rb7AX8DxLuGokPKclSeUVmGE9L8lTmgZ2dAiR6ZvVQ4DB7PCi8jqhbykHJD8g3EfAFqpCKYOTRBnHJDrct7Fy7EGexTzS4kb+RcVJQ/eDpalpq3+QBcqLMuSoF51a+mpg5nUFpNaoY7lqxamncV+jOzbuMNfp1sHZ2JvzSYSXRTAY1i7XmD8S6P1bdSKkGlougu0eETyfdX5c3FyIxxI/sXxeKtXYaTVkoEoTVEI8+6NZo+UZ6ShVye6/dJ7yPz52Rvmf9bTDMu32rD6FgXmvmNxzDkj7ftnKrzjeaONQw3uZ52jiWfuHlFU7i+d/VoWpdWmZuj7jmBuSqLy6aunACtHVfxrgBR+SBXJIKqOB4p4NJQ8J5SlU3rEbpnwBUu1IbaLjmCTqrLSUunuTZaFFQZN2vxcN4YerRvlWaqNIONMS0iZfYXsFWpAhdu3zwGqsdUvIHonulSlw2domYb634dJcWULvGOY0W/VuIz8EAIZ1vzpnvhTa0oHSfEFDAAgW4YUhFkkhCcDAaHu09YUAYTiSt3mXQ9sOaK32WImSH9EPC3RK8aPOTFs8UuSFLyz92QGBJP7pXzupXPF3i7n1wEJAtQy/ZOG/kffF0zA1WnOy/Tqc7okTJn32wo56CWuqRfs19EDvTb4NjNinCLs8cla+Jp71c8Cz0l5nIavoSIt6Jls+8SnZra+gKsF9WemeBGRIT3lZB6WkFIDPftHdM5UB8fBxK4b5L9vpxqJdW5fI3cH9x5zGBOQAHRMEOhZDm2rYD0KcjxPdR9bSqsdcrgI6de5FxhO7FBiwmtHaoLhLLdG5x8MJdq7QGGR3n9kmZN7kaD6mwCyvTVo3Tq2qTmcd9u18iPW85P4BL+wFVIciq6s
 iwMcAd71
 9y9nh8rdoHss/eMA9qu1h0dI0pTS242W/D6QYYYYM56FHdbka5i5U/zpbMPXXrC7ZUUzTOuOuz/UYrSYP8JZ8uh7QUE9EyABE5YEstFnW3bLURh+fAOnjyYC1J+4BgDEtTgNzLEoi8W2vZJFCij6J6bYe5ypoj+eHwJn64EQ1jMIBr6IsGGa+YJVmqCQaaz4eOgm+nmTKkH3+jyzydDT5Alz8MA3Us2oO/el8V1glysUxGsGL4Twk2blf7CUMUCub49prqQo2YO5a7nRmZCM6z4+IQE/rTCiL4ZXWnyMwa3uCpfzQ5mebl5Ep6PjTRzyxAnqsOz6ijWSOaj9UE556pN+uZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Guarantee that rmap_walk() is called on locked folios so that threads
changing folio->mapping and folio->index for non-KSM anon folios can
serialize on fine-grained folio lock rather than anon_vma lock. Other
folio types are already always locked before rmap_walk().

This is in preparation for removing anon_vma write-lock from
UFFDIO_MOVE.

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
 mm/memory-failure.c   |  3 +++
 mm/page_idle.c        |  8 ++------
 mm/rmap.c             | 42 ++++++++++++------------------------------
 4 files changed, 21 insertions(+), 48 deletions(-)

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
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a24806bb8e82..f698df156bf8 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2143,7 +2143,10 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
 {
 	LIST_HEAD(tokill);
 
+	folio_lock(folio);
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
+	folio_unlock(folio);
+
 	kill_procs(&tokill, true, pfn, flags);
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
index 34333ae3bd80..90584f5da379 100644
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
 
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+
 	rcu_read_lock();
 	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
 	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
@@ -546,7 +544,8 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 	struct anon_vma *root_anon_vma;
 	unsigned long anon_mapping;
 
-retry:
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+
 	rcu_read_lock();
 	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
 	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
@@ -557,17 +556,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
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
@@ -602,18 +590,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
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
@@ -1005,7 +981,7 @@ int folio_referenced(struct folio *folio, int is_locked,
 	if (!folio_raw_mapping(folio))
 		return 0;
 
-	if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
+	if (!is_locked) {
 		we_locked = folio_trylock(folio);
 		if (!we_locked)
 			return 1;
@@ -2815,6 +2791,12 @@ static void rmap_walk_anon(struct folio *folio,
 	pgoff_t pgoff_start, pgoff_end;
 	struct anon_vma_chain *avc;
 
+	/*
+	 * The folio lock ensures that folio->mapping can't be changed under us
+	 * to an anon_vma with different root.
+	 */
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+
 	if (locked) {
 		anon_vma = folio_anon_vma(folio);
 		/* anon_vma disappear under us? */
-- 
2.51.0.384.g4c02a37b29-goog


