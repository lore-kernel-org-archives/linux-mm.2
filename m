Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE48CD3440
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2396B00A9; Tue,  5 May 2026 11:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964306B00AA; Tue,  5 May 2026 11:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A846B00AB; Tue,  5 May 2026 11:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 613E36B00A9
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 257F18BC46
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:24 +0000 (UTC)
X-FDA: 84733775448.12.EADE8F5
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4B3C1120012
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bMkiH509;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+JFZdlLRIOsIMrfXghvEsyrBvNTOwJtBsHltdBMSE0=;
	b=otV5zf2C3eh9P2ETyzxVpLKVezw/le7eV+lB/gj3YbcKzC7mWrl9aEOR6/eQj8UvHuGR4R
	qToWzrKuYqqirZHc7pN6X38fX3XgGADrgYlQqMt0xCMDpgkGAGfLMzUg7omA6XULN3ckV+
	3IMbGu03Ls1xoaTImPsNPWf5u/SDmMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995562; a=rsa-sha256;
	cv=none;
	b=cwt+EXrL0CjErfCXo/pqWRlr+eljPS9x4TuFbd6snGGwNAfI1CV/NgegL8bFQNfNcJ23vp
	DYDopAh5HLAZTyIRu5OZaV9BzSxnoCVS3b39qVO0RHPJZREEainDAIXYtwta1lqNozm05l
	QA8J/iqw9HiN2eOtSJDxSzvrrrqVuIM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bMkiH509;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-479d593a0c3so5287b6e.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995561; x=1778600361; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R+JFZdlLRIOsIMrfXghvEsyrBvNTOwJtBsHltdBMSE0=;
        b=bMkiH509RMOXiujh32YG1geMp1vzAc+LEYL8cz5cAZPtQ4r8K7xaoFYiQ55127wzn9
         vnpgRw+mYrOaOOZg6JsvHW8V51XVb74zhG/DL2KnnETP2NGBPxeaUPdf7zN7LmDmCMQo
         W+tAmA5VvgdrAEA5/G8IB0gyyJJovpDn9CJ1JjpdH4LTT9VfXAY00yX4xcXETRZUSMZO
         5ngONr9XfEGNMUlkRv12xRCA8RbFdwJfcqwv21K/BS7vKEhb3RMbrKPzT0+CUFJ350DK
         wqcCLoF293xGn1H5Np0LJtMAxHA1rPZkgfUTTiSVEGVIKGtIYXM+hGZ8AVT1d01MHMtk
         VaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995561; x=1778600361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R+JFZdlLRIOsIMrfXghvEsyrBvNTOwJtBsHltdBMSE0=;
        b=MsZxEQ9/6gWIRzu138vru5bdK6HPh+L5JXL0rm3y75rTpF8EssXG10JQOkYffjwh2V
         HaxFb3VF2S9TwhNRBncSyqEyoEQqGChHWFhujDL1W+s3YXYyn0X3vYghZTykmhieMNfU
         H9PpSPA7fQ9NlHrpNHVa5oBm+he2FKkyaZR/+thNca6R9wLPUIogpLsQG2k46EBKQtsd
         EO0BzXg7UlDmxcWwXoAclhKMNMSUQVDUHP7AyO1nkl/0IXI0fo6JUdcRxPp8m63a7pxo
         Y29Q7h/KzFmsCgSIl8U04+GpnAPeZ7UTe/ezxGBEpzoMjp1gdfJl5o/5/FXdmbUhlJWr
         gBSw==
X-Forwarded-Encrypted: i=1; AFNElJ/1UyVQHRGeFhRy25IZngJ9iP7At0GxnebNV33mGIexj9siP7enmc0MnRQUwLK5BuZe1yeGpFDAUw==@kvack.org
X-Gm-Message-State: AOJu0Ywaf8z8rv2ZyFTFvF2fvzCm5UQAGKzh7CtE90Ys7wmlf6spZagE
	HC5SEgdqMaiFZZ1dogNRrKy+PHkOIagaTH9nTiWLvY9iVwEw+hpEm3UJ
X-Gm-Gg: AeBDievEUvrVBHqxP9AT5PZoC3STRwbkdnrJwPGdpyxO7+gqn8dnYBlEA7HX3Ax9DFo
	qelKLka0mxNvIjD67Uc9O2dObY3GckBB5PKZXEDzCHFpneAez6eTIMX4Cb6SQA4wPXcmweTS/rN
	d634cs1NzGod4iFetCCSz0BbfN7ZurvTlailqtPUMKm4acEwurgRZS9KtAXWMtiFCZt3vwk0WSq
	MojRr9+qBUit+MOHYif1iakrOZyKr0ELgGTXsoqJByBLce6qtc2B3lLDBdeez2Zd51lE8fJvUbk
	2KHtu1CU1EjYjJ2oHJjGit5ml362/UtHr0+hvk3HnVFW7l3xpu8O8gtLHJ8YiHl3UuAMjLxuOJH
	uwQbAa6LrVVwc1giXCor9YZ4LOzKcJoTKGr12WR8XwD3ulVs3zIcIgmzKeL6uQJquL9xskZVxC/
	VdFOlQZ2/a8Z6ORr0xC/ipOUYO8zauQSMBP1DdMNy7OPEvira3lMvTibIeJ3mb057IzyM=
X-Received: by 2002:a05:6808:318a:b0:45f:13fe:4a2e with SMTP id 5614622812f47-47d36511eb7mr2081730b6e.17.1777995561072;
        Tue, 05 May 2026 08:39:21 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c76935904sm8701471b6e.11.2026.05.05.08.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:19 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [PATCH v6 10/22] swap: move swap cache to virtual swap descriptor
Date: Tue,  5 May 2026 08:38:39 -0700
Message-ID: <20260505153854.1612033-11-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4B3C1120012
X-Rspam-User: 
X-Stat-Signature: 7mny6u46dczngab74n53q87qwpjh649i
X-HE-Tag: 1777995562-722337
X-HE-Meta: U2FsdGVkX18WafOc0j16BeGZEiKiL2J8CH729k0xii7WW95L1zFIBbuSfrwqOQjM6MnR25JACPdVerO6Q4ahVTWbJYZoxFav2apNn9p6TLm8SbCIuqrslRiOSjEY15+30ooncmmDk6PJONDTeCEXYyC1rZgDf8L7uantTmQUIClkdUz4cfxdC6fqzrj8VCKqZUiAaAxBLyDe+sEs9TXJYP5c9FY7BZgwwmnmdW+d3f/33eV8hOIs3aWXmsyWEuNC8t7rxuJWLglXZmL0cMLTLOU0xAVuOgZZCMKxBnBnNgWc7O81nG+0bl9FulaIEuRKyLvn2j6xdzZ6T9XFqUi22KVM9Q8hoCHmKz1XAhR/3XTC82DexbzymN3ToQpdBNhBDRbl/yAR/9q2qzQSaPKBFrz04lLmlNLDbPv6ljMiJQ0gxNeQpMAXOMr7TCor8NFrfI0WygJpGUYGXefbxUM08sZ+ZeRumi5XvGnyOV8VGq5eN5MgVKftAY3gpOTZLIQj6eQ3ecvdv0Yyyp7OQZykyXgJJQX9xo+AAtclNSxmoeH54thR/QgSEfye8in9tUkhmkmcEJtk9McL5Mp0RlSWMVLo9UH2DTPfwJPtf3eWnyXOyXM5cTfhk6Mz4Hn+irvBoBxviio3xhg+RqWGEt43KDEUWicnB340OZIWy+1yCr5Tp7Pd+34jV0Hzgj06eCXWNJV55SN81q6mce5qiUglVxQEGauS0YgJmKAvkxF5sAW0LZbx/vDYNtZ9xvMWDqymTzSnlMCP1ynISeAeOgWm0Opg8v6rzj6gDdx1veku2G1aaqMZ+hnY4Bw8NnQB6HW91nKswTCZ3rr2tNqZz1bPY7SgKfXde6YzeEDGDZql7hfpRpzIzyJBOI3gdqJfpOFbS73cWOlOIpbO1dBTdRPtedW66MhYYoZPrdDEIdLvht65pmhr1mOmhFC5TIKlc1KAvVNFIExfdWDtNwjS7+s
 lEq/VvyY
 9kZd074iQ+h7OKcupQFTNivYPiAc2fqbGb/ZbAAXaqKtfFjknVROPMs5YwYOizqAeLACpXFWYEAxgaq7CUr9PF8KafM1ranF1EMQfLVu314uWTtsQuaDUFPevDhXl1XYE3eKXCIq8CxZmp2Q231SsjkcSzjwJ6wxTjEcAY6CNh5ng/oNKGYmoXFHN2o5fp2wJRkX9Ehxt/8Q0F3xyJxkZwodR+0OWXalaziOryWAXyq8VZ90hNvI186gDsDB/XV7FfOJpVeq8HVtQQrww6yrDRONaWQmk0HZooE2nqYxFMaD9lINwuYCWjPfY1QsbxDSazThTqz2GR0nOaCqE2YsRciRwFFTzuvF9M60KV0BbUs6nL/Jx9Ox0G+c/Jqj8EIGdA75bi+keBGq1v9xJd9z1lLqRLt3CZ1KMZFaTPxOxAdWI18Y89Ud3w8MAnMaKg4XUczcyuChMjTS3RmJ1uM6AtXupXapE78y+OwWzdnI+wkUJCkn/yJuKmvIWtZemXV3LOuhUMYBk0Z5wxvd4N/EMz2xRobAfzXy2CUokPqL6emxPS3sdsYWzAsMN4M6zfu+k4Brx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the swap cache (and workingset shadow for anonymous pages) to the
virtual swap descriptor. This effectively range-partitions the swap
cache by virtual swap clusters (of PMD sized), eliminate swap cache lock
contention.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/huge_memory.c |   4 +-
 mm/migrate.c     |   6 +-
 mm/shmem.c       |   4 +-
 mm/swap.h        |  28 ++--
 mm/swap_state.c  | 252 +-----------------------------
 mm/vmscan.c      |   6 +-
 mm/vswap.c       | 389 ++++++++++++++++++++++++++++++++++++++++++++---
 7 files changed, 392 insertions(+), 297 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 21215ac87014..dcbd3821d617 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3825,7 +3825,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 				return -EINVAL;
 			}
 
-			swap_cache_lock();
+			swap_cache_lock(folio->swap);
 		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
@@ -3901,7 +3901,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			unlock_page_lruvec(lruvec);
 
 		if (folio_test_swapcache(folio))
-			swap_cache_unlock();
+			swap_cache_unlock(folio->swap);
 	} else {
 		split_queue_unlock(ds_queue);
 		return -EAGAIN;
diff --git a/mm/migrate.c b/mm/migrate.c
index 11d9b43dff5d..e850b05a232d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -600,13 +600,13 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	newzone = folio_zone(newfolio);
 
 	if (folio_test_swapcache(folio))
-		swap_cache_lock_irq();
+		swap_cache_lock_irq(folio->swap);
 	else
 		xas_lock_irq(&xas);
 
 	if (!folio_ref_freeze(folio, expected_count)) {
 		if (folio_test_swapcache(folio))
-			swap_cache_unlock_irq();
+			swap_cache_unlock_irq(folio->swap);
 		else
 			xas_unlock_irq(&xas);
 		return -EAGAIN;
@@ -652,7 +652,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 
 	/* Leave irq disabled to prevent preemption while updating stats */
 	if (folio_test_swapcache(folio))
-		swap_cache_unlock();
+		swap_cache_unlock(folio->swap);
 	else
 		xas_unlock(&xas);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 13f7469a04c8..66cf8af6779c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2168,12 +2168,12 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	new->swap = entry;
 	folio_set_swapcache(new);
 
-	swap_cache_lock_irq();
+	swap_cache_lock_irq(entry);
 	__swap_cache_replace_folio(old, new);
 	mem_cgroup_replace_folio(old, new);
 	shmem_update_stats(new, nr_pages);
 	shmem_update_stats(old, -nr_pages);
-	swap_cache_unlock_irq();
+	swap_cache_unlock_irq(entry);
 
 	folio_add_lru(new);
 	*foliop = new;
diff --git a/mm/swap.h b/mm/swap.h
index e8fac77a6e4c..391eed8b7e42 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -147,10 +147,12 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
-void swap_cache_lock_irq(void);
-void swap_cache_unlock_irq(void);
-void swap_cache_lock(void);
-void swap_cache_unlock(void);
+
+/* linux/mm/vswap.c */
+void swap_cache_lock_irq(swp_entry_t entry);
+void swap_cache_unlock_irq(swp_entry_t entry);
+void swap_cache_lock(swp_entry_t entry);
+void swap_cache_unlock(swp_entry_t entry);
 
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
@@ -198,13 +200,12 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-			 gfp_t gfp, void **shadow);
+void swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+			  void **shadow);
 void swap_cache_del_folio(struct folio *folio);
 /* Below helpers require the caller to lock the swap cache. */
 void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct folio *old, struct folio *new);
-void swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
 
 void show_swap_cache_info(void);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
@@ -349,10 +350,9 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
-static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-				       gfp_t gfp, void **shadow)
+static inline void swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+					void **shadow)
 {
-	return 0;
 }
 
 static inline void swap_cache_del_folio(struct folio *folio)
@@ -367,19 +367,19 @@ static inline void __swap_cache_replace_folio(struct folio *old, struct folio *n
 {
 }
 
-static inline void swap_cache_lock_irq(void)
+static inline void swap_cache_lock_irq(swp_entry_t entry)
 {
 }
 
-static inline void swap_cache_unlock_irq(void)
+static inline void swap_cache_unlock_irq(swp_entry_t entry)
 {
 }
 
-static inline void swap_cache_lock(void)
+static inline void swap_cache_lock(swp_entry_t entry)
 {
 }
 
-static inline void swap_cache_unlock(void)
+static inline void swap_cache_unlock(swp_entry_t entry)
 {
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 69303e949862..00fa3e76a5c1 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -41,28 +41,6 @@ struct address_space swap_space __read_mostly = {
 	.a_ops = &swap_aops,
 };
 
-static DEFINE_XARRAY(swap_cache);
-
-void swap_cache_lock_irq(void)
-{
-	xa_lock_irq(&swap_cache);
-}
-
-void swap_cache_unlock_irq(void)
-{
-	xa_unlock_irq(&swap_cache);
-}
-
-void swap_cache_lock(void)
-{
-	xa_lock(&swap_cache);
-}
-
-void swap_cache_unlock(void)
-{
-	xa_unlock(&swap_cache);
-}
-
 static bool enable_vma_readahead __read_mostly = true;
 
 #define SWAP_RA_ORDER_CEILING	5
@@ -94,232 +72,6 @@ void show_swap_cache_info(void)
 	printk("Total swap = %lukB\n", K(total_swap_pages));
 }
 
-/**
- * swap_cache_get_folio - Looks up a folio in the swap cache.
- * @entry: swap entry used for the lookup.
- *
- * A found folio will be returned unlocked and with its refcount increased.
- *
- * Context: Caller must ensure @entry is valid and protect the swap device
- * with reference count or locks.
- * Return: Returns the found folio on success, NULL otherwise. The caller
- * must lock nd check if the folio still matches the swap entry before
- * use (e.g., folio_matches_swap_entry).
- */
-struct folio *swap_cache_get_folio(swp_entry_t entry)
-{
-	void *entry_val;
-	struct folio *folio;
-
-	for (;;) {
-		rcu_read_lock();
-		entry_val = xa_load(&swap_cache, entry.val);
-		if (!entry_val || xa_is_value(entry_val)) {
-			rcu_read_unlock();
-			return NULL;
-		}
-		folio = entry_val;
-		if (likely(folio_try_get(folio))) {
-			rcu_read_unlock();
-			return folio;
-		}
-		rcu_read_unlock();
-	}
-
-	return NULL;
-}
-
-/**
- * swap_cache_get_shadow - Looks up a shadow in the swap cache.
- * @entry: swap entry used for the lookup.
- *
- * Context: Caller must ensure @entry is valid and protect the swap device
- * with reference count or locks.
- * Return: Returns either NULL or an XA_VALUE (shadow).
- */
-void *swap_cache_get_shadow(swp_entry_t entry)
-{
-	void *entry_val;
-
-	rcu_read_lock();
-	entry_val = xa_load(&swap_cache, entry.val);
-	rcu_read_unlock();
-
-	if (xa_is_value(entry_val))
-		return entry_val;
-	return NULL;
-}
-
-/**
- * swap_cache_add_folio - Add a folio into the swap cache.
- * @folio: The folio to be added.
- * @entry: The swap entry corresponding to the folio.
- * @gfp: gfp_mask for XArray node allocation.
- * @shadowp: If a shadow is found, return the shadow.
- *
- * Context: Caller must ensure @entry is valid and protect the swap device
- * with reference count or locks.
- * The caller also needs to update the corresponding swap_map slots with
- * SWAP_HAS_CACHE bit to avoid race or conflict.
- *
- * Return: 0 on success, negative error code on failure.
- */
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry, gfp_t gfp, void **shadowp)
-{
-	XA_STATE_ORDER(xas, &swap_cache, entry.val, folio_order(folio));
-	unsigned long nr_pages = folio_nr_pages(folio);
-	unsigned long i;
-	void *old;
-
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
-
-	folio_ref_add(folio, nr_pages);
-	folio_set_swapcache(folio);
-	folio->swap = entry;
-
-	do {
-		xas_lock_irq(&xas);
-		xas_create_range(&xas);
-		if (xas_error(&xas))
-			goto unlock;
-		for (i = 0; i < nr_pages; i++) {
-			VM_BUG_ON_FOLIO(xas.xa_index != entry.val + i, folio);
-			old = xas_load(&xas);
-			if (old && !xa_is_value(old)) {
-				VM_WARN_ON_ONCE_FOLIO(1, folio);
-				xas_set_err(&xas, -EEXIST);
-				goto unlock;
-			}
-			if (shadowp && xa_is_value(old) && !*shadowp)
-				*shadowp = old;
-			xas_store(&xas, folio);
-			xas_next(&xas);
-		}
-		node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
-		lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
-unlock:
-		xas_unlock_irq(&xas);
-	} while (xas_nomem(&xas, gfp));
-
-	if (!xas_error(&xas))
-		return 0;
-
-	folio_clear_swapcache(folio);
-	folio_ref_sub(folio, nr_pages);
-	return xas_error(&xas);
-}
-
-/**
- * __swap_cache_del_folio - Removes a folio from the swap cache.
- * @folio: The folio.
- * @entry: The first swap entry that the folio corresponds to.
- * @shadow: shadow value to be filled in the swap cache.
- *
- * Removes a folio from the swap cache and fills a shadow in place.
- * This won't put the folio's refcount. The caller has to do that.
- *
- * Context: Caller must ensure the folio is locked and in the swap cache
- * using the index of @entry, and lock the swap cache xarray.
- */
-void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry, void *shadow)
-{
-	long nr_pages = folio_nr_pages(folio);
-	XA_STATE(xas, &swap_cache, entry.val);
-	int i;
-
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
-
-	for (i = 0; i < nr_pages; i++) {
-		void *old = xas_store(&xas, shadow);
-
-		VM_WARN_ON_FOLIO(old != folio, folio);
-		xas_next(&xas);
-	}
-
-	folio->swap.val = 0;
-	folio_clear_swapcache(folio);
-	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
-	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
-}
-
-/**
- * swap_cache_del_folio - Removes a folio from the swap cache.
- * @folio: The folio.
- *
- * Same as __swap_cache_del_folio, but handles lock and refcount. The
- * caller must ensure the folio is either clean or has a swap count
- * equal to zero, or it may cause data loss.
- *
- * Context: Caller must ensure the folio is locked and in the swap cache.
- */
-void swap_cache_del_folio(struct folio *folio)
-{
-	swp_entry_t entry = folio->swap;
-
-	xa_lock_irq(&swap_cache);
-	__swap_cache_del_folio(folio, entry, NULL);
-	xa_unlock_irq(&swap_cache);
-
-	put_swap_folio(folio, entry);
-	folio_ref_sub(folio, folio_nr_pages(folio));
-}
-
-/**
- * __swap_cache_replace_folio - Replace a folio in the swap cache.
- * @old: The old folio to be replaced.
- * @new: The new folio.
- *
- * Replace an existing folio in the swap cache with a new folio. The
- * caller is responsible for setting up the new folio's flag and swap
- * entries. Replacement will take the new folio's swap entry value as
- * the starting offset to override all slots covered by the new folio.
- *
- * Context: Caller must ensure both folios are locked, and lock the
- * swap cache xarray.
- */
-void __swap_cache_replace_folio(struct folio *old, struct folio *new)
-{
-	swp_entry_t entry = new->swap;
-	unsigned long nr_pages = folio_nr_pages(new);
-	XA_STATE(xas, &swap_cache, entry.val);
-	int i;
-
-	VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcache(new));
-	VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new));
-	VM_WARN_ON_ONCE(!entry.val);
-
-	for (i = 0; i < nr_pages; i++) {
-		void *old_entry = xas_store(&xas, new);
-
-		WARN_ON_ONCE(!old_entry || xa_is_value(old_entry) || old_entry != old);
-		xas_next(&xas);
-	}
-}
-
-/**
- * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
- * @entry: The starting index entry.
- * @nr_ents: How many slots need to be cleared.
- *
- * Context: Caller must ensure the range is valid and not occupied by any folio.
- */
-void swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
-{
-	XA_STATE(xas, &swap_cache, entry.val);
-	int i;
-
-	xas_lock(&xas);
-	for (i = 0; i < nr_ents; i++) {
-		xas_store(&xas, NULL);
-		xas_next(&xas);
-	}
-	xas_unlock(&xas);
-}
-
 /*
  * If we are the only user, then try to free up the swap cache.
  *
@@ -498,9 +250,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	if (mem_cgroup_swapin_charge_folio(new_folio, NULL, gfp_mask, entry))
 		goto fail_unlock;
 
-	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (swap_cache_add_folio(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
-		goto fail_unlock;
+	swap_cache_add_folio(new_folio, entry, &shadow);
 
 	memcg1_swapin(entry, 1);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 558ff7f41378..c9ec1a1458b4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -712,7 +712,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 	BUG_ON(mapping != folio_mapping(folio));
 
 	if (folio_test_swapcache(folio)) {
-		swap_cache_lock_irq();
+		swap_cache_lock_irq(folio->swap);
 	} else {
 		spin_lock(&mapping->host->i_lock);
 		xa_lock_irq(&mapping->i_pages);
@@ -759,7 +759,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 			shadow = workingset_eviction(folio, target_memcg);
 		__swap_cache_del_folio(folio, swap, shadow);
 		memcg1_swapout(folio, swap);
-		swap_cache_unlock_irq();
+		swap_cache_unlock_irq(swap);
 		put_swap_folio(folio, swap);
 	} else {
 		void (*free_folio)(struct folio *);
@@ -798,7 +798,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 cannot_free:
 	if (folio_test_swapcache(folio)) {
-		swap_cache_unlock_irq();
+		swap_cache_unlock_irq(folio->swap);
 	} else {
 		xa_unlock_irq(&mapping->i_pages);
 		spin_unlock(&mapping->host->i_lock);
diff --git a/mm/vswap.c b/mm/vswap.c
index f28ca2517c10..3be42c45a1bb 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -38,9 +38,15 @@
  * Swap descriptor - metadata of a swapped out page.
  *
  * @slot: The handle to the physical swap slot backing this page.
+ * @swap_cache: The folio in swap cache.
+ * @shadow: The shadow entry.
  */
 struct swp_desc {
 	swp_slot_t slot;
+	union {
+		struct folio *swap_cache;
+		void *shadow;
+	};
 };
 
 #define VSWAP_CLUSTER_SHIFT HPAGE_PMD_ORDER
@@ -172,6 +178,24 @@ static int vswap_debug_fs_init(void)
 }
 #endif
 
+/*
+ * Lockless version of vswap_iter - assumes caller holds cluster lock.
+ * Used when iterating within the same cluster with the lock already held.
+ */
+static struct swp_desc *__vswap_iter(struct vswap_cluster *cluster, unsigned long i)
+{
+	unsigned long slot_index;
+
+	lockdep_assert_held(&cluster->lock);
+	VM_WARN_ON(cluster->id != VSWAP_VAL_CLUSTER_IDX(i));
+
+	slot_index = VSWAP_IDX_WITHIN_CLUSTER_VAL(i);
+	if (test_bit(slot_index, cluster->bitmap))
+		return &cluster->descriptors[slot_index];
+
+	return NULL;
+}
+
 static struct swp_desc *vswap_iter(struct vswap_cluster **clusterp, unsigned long i)
 {
 	unsigned long cluster_id = VSWAP_VAL_CLUSTER_IDX(i);
@@ -208,7 +232,8 @@ static bool cluster_is_alloc_candidate(struct vswap_cluster *cluster)
 	return cluster->count + (1 << (cluster->order)) <= VSWAP_CLUSTER_SIZE;
 }
 
-static void __vswap_alloc_from_cluster(struct vswap_cluster *cluster, int start)
+static void __vswap_alloc_from_cluster(struct vswap_cluster *cluster, int start,
+				       struct folio *folio)
 {
 	int i, nr = 1 << cluster->order;
 	struct swp_desc *desc;
@@ -216,11 +241,13 @@ static void __vswap_alloc_from_cluster(struct vswap_cluster *cluster, int start)
 	for (i = 0; i < nr; i++) {
 		desc = &cluster->descriptors[start + i];
 		desc->slot.val = 0;
+		desc->swap_cache = folio;
 	}
 	cluster->count += nr;
 }
 
-static unsigned long vswap_alloc_from_cluster(struct vswap_cluster *cluster)
+static unsigned long vswap_alloc_from_cluster(struct vswap_cluster *cluster,
+					      struct folio *folio)
 {
 	int nr = 1 << cluster->order;
 	unsigned long i = cluster->id ? 0 : nr;
@@ -239,16 +266,16 @@ static unsigned long vswap_alloc_from_cluster(struct vswap_cluster *cluster)
 	bitmap_set(cluster->bitmap, i, nr);
 
 	refcount_add(nr, &cluster->refcnt);
-	__vswap_alloc_from_cluster(cluster, i);
+	__vswap_alloc_from_cluster(cluster, i, folio);
 	return i + (cluster->id << VSWAP_CLUSTER_SHIFT);
 }
 
 /* Allocate a contiguous range of virtual swap slots */
-static swp_entry_t vswap_alloc(int order)
+static swp_entry_t vswap_alloc(struct folio *folio)
 {
 	struct xa_limit limit = vswap_cluster_map_limit;
 	struct vswap_cluster *local, *cluster;
-	int nr = 1 << order;
+	int order = folio_order(folio), nr = 1 << order;
 	bool need_caching = true;
 	u32 cluster_id;
 	swp_entry_t entry;
@@ -261,7 +288,7 @@ static swp_entry_t vswap_alloc(int order)
 	cluster = this_cpu_read(percpu_vswap_cluster.clusters[order]);
 	if (cluster) {
 		spin_lock(&cluster->lock);
-		entry.val = vswap_alloc_from_cluster(cluster);
+		entry.val = vswap_alloc_from_cluster(cluster, folio);
 		need_caching = !entry.val;
 
 		if (!entry.val || !cluster_is_alloc_candidate(cluster)) {
@@ -288,7 +315,7 @@ static swp_entry_t vswap_alloc(int order)
 			if (!spin_trylock(&cluster->lock))
 				continue;
 
-			entry.val = vswap_alloc_from_cluster(cluster);
+			entry.val = vswap_alloc_from_cluster(cluster, folio);
 			list_del_init(&cluster->list);
 			cluster->full = !entry.val || !cluster_is_alloc_candidate(cluster);
 			need_caching = !cluster->full;
@@ -328,7 +355,7 @@ static swp_entry_t vswap_alloc(int order)
 				if (!cluster_id)
 					entry.val += nr;
 				__vswap_alloc_from_cluster(cluster,
-					(entry.val & VSWAP_CLUSTER_MASK));
+					(entry.val & VSWAP_CLUSTER_MASK), folio);
 				/* Mark the allocated range in the bitmap */
 				bitmap_set(cluster->bitmap, (entry.val & VSWAP_CLUSTER_MASK), nr);
 				need_caching = cluster_is_alloc_candidate(cluster);
@@ -468,7 +495,6 @@ void vswap_free(swp_entry_t entry, struct swap_cluster_info *ci)
 	if (!entry.val)
 		return;
 
-	swap_cache_clear_shadow(entry, 1);
 	zswap_invalidate(entry);
 	mem_cgroup_uncharge_swap(entry, 1);
 
@@ -480,6 +506,10 @@ void vswap_free(swp_entry_t entry, struct swap_cluster_info *ci)
 		return;
 	}
 
+	/* Clear shadow if present */
+	if (xa_is_value(desc->shadow))
+		desc->shadow = NULL;
+
 	if (desc->slot.val)
 		vswap_rmap_set(ci, desc->slot, 0, 1);
 
@@ -500,7 +530,7 @@ int folio_alloc_swap(struct folio *folio)
 	struct vswap_cluster *cluster = NULL;
 	struct swap_info_struct *si;
 	struct swap_cluster_info *ci;
-	int i, err, ret, nr = folio_nr_pages(folio), order = folio_order(folio);
+	int i, ret, nr = folio_nr_pages(folio), order = folio_order(folio);
 	struct swp_desc *desc;
 	swp_entry_t entry;
 	swp_slot_t slot = { 0 };
@@ -508,7 +538,7 @@ int folio_alloc_swap(struct folio *folio)
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
 
-	entry = vswap_alloc(folio_order(folio));
+	entry = vswap_alloc(folio);
 	if (!entry.val)
 		return -ENOMEM;
 
@@ -554,20 +584,19 @@ int folio_alloc_swap(struct folio *folio)
 	 * decoupled virtual and physical swap slots, we will only charge when we
 	 * actually allocate a physical swap slot.
 	 */
-	if (mem_cgroup_try_charge_swap(folio, entry))
-		goto out_free;
+	if (mem_cgroup_try_charge_swap(folio, entry)) {
+		put_swap_folio(folio, entry);
+		return -ENOMEM;
+	}
 
-	err = swap_cache_add_folio(folio, entry,
-				   __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN,
-				   NULL);
-	if (err)
-		goto out_free;
+	folio_ref_add(folio, nr);
+	folio_set_swapcache(folio);
+	folio->swap = entry;
 
-	return 0;
+	node_stat_mod_folio(folio, NR_FILE_PAGES, nr);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr);
 
-out_free:
-	put_swap_folio(folio, entry);
-	return -ENOMEM;
+	return 0;
 }
 
 /**
@@ -688,6 +717,322 @@ static int vswap_cpu_dead(unsigned int cpu)
 	return 0;
 }
 
+/**
+ * swap_cache_lock - lock the swap cache for a swap entry
+ * @entry: the swap entry
+ *
+ * Locks the vswap cluster spinlock for the given swap entry.
+ */
+void swap_cache_lock(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_lock(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * swap_cache_unlock - unlock the swap cache for a swap entry
+ * @entry: the swap entry
+ *
+ * Unlocks the vswap cluster spinlock for the given swap entry.
+ */
+void swap_cache_unlock(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * swap_cache_lock_irq - lock the swap cache with interrupts disabled
+ * @entry: the swap entry
+ *
+ * Locks the vswap cluster spinlock and disables interrupts for the given swap entry.
+ */
+void swap_cache_lock_irq(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_lock_irq(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * swap_cache_unlock_irq - unlock the swap cache with interrupts enabled
+ * @entry: the swap entry
+ *
+ * Unlocks the vswap cluster spinlock and enables interrupts for the given swap entry.
+ */
+void swap_cache_unlock_irq(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_unlock_irq(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * swap_cache_get_folio - Looks up a folio in the swap cache.
+ * @entry: swap entry used for the lookup.
+ *
+ * A found folio will be returned unlocked and with its refcount increased.
+ *
+ * Context: Caller must ensure @entry is valid and protect the cluster with
+ * reference count or locks.
+ *
+ * Return: Returns the found folio on success, NULL otherwise. The caller
+ * must lock and check if the folio still matches the swap entry before
+ * use (e.g., folio_matches_swap_entry).
+ */
+struct folio *swap_cache_get_folio(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	struct folio *folio;
+
+	for (;;) {
+		rcu_read_lock();
+		desc = vswap_iter(&cluster, entry.val);
+		if (!desc) {
+			rcu_read_unlock();
+			return NULL;
+		}
+
+		/* Check if this is a shadow value (xa_is_value equivalent) */
+		if (xa_is_value(desc->shadow)) {
+			spin_unlock(&cluster->lock);
+			rcu_read_unlock();
+			return NULL;
+		}
+
+		folio = desc->swap_cache;
+		if (!folio) {
+			spin_unlock(&cluster->lock);
+			rcu_read_unlock();
+			return NULL;
+		}
+
+		if (likely(folio_try_get(folio))) {
+			spin_unlock(&cluster->lock);
+			rcu_read_unlock();
+			return folio;
+		}
+		spin_unlock(&cluster->lock);
+		cluster = NULL;
+		rcu_read_unlock();
+	}
+
+	return NULL;
+}
+
+/**
+ * swap_cache_get_shadow - Looks up a shadow in the swap cache.
+ * @entry: swap entry used for the lookup.
+ *
+ * Context: Caller must ensure @entry is valid and protect the cluster with
+ * reference count or locks.
+ *
+ * Return: Returns either NULL or an XA_VALUE (shadow).
+ */
+void *swap_cache_get_shadow(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *shadow;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, entry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	shadow = desc->shadow;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	if (xa_is_value(shadow))
+		return shadow;
+	return NULL;
+}
+
+/**
+ * swap_cache_add_folio - Add a folio into the swap cache.
+ * @folio: The folio to be added.
+ * @entry: The swap entry corresponding to the folio.
+ * @shadowp: If a shadow is found, return the shadow.
+ *
+ * Context: Caller must ensure @entry is valid and protect the cluster with
+ * reference count or locks.
+ *
+ * The caller also needs to update the corresponding swap_map slots with
+ * SWAP_HAS_CACHE bit to avoid race or conflict.
+ */
+void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadowp)
+{
+	struct vswap_cluster *cluster;
+	unsigned long nr_pages = folio_nr_pages(folio);
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+	unsigned long i;
+	struct swp_desc *desc;
+	void *old;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
+
+	folio_ref_add(folio, nr_pages);
+	folio_set_swapcache(folio);
+	folio->swap = entry;
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_lock_irq(&cluster->lock);
+
+	for (i = 0; i < nr_pages; i++) {
+		desc = __vswap_iter(cluster, entry.val + i);
+		VM_WARN_ON(!desc);
+		old = desc->shadow;
+
+		/* Warn if slot is already occupied by a folio */
+		VM_WARN_ON_FOLIO(old && !xa_is_value(old), folio);
+
+		/* Save shadow if found and not yet saved */
+		if (shadowp && xa_is_value(old) && !*shadowp)
+			*shadowp = old;
+
+		desc->swap_cache = folio;
+	}
+
+	spin_unlock_irq(&cluster->lock);
+	rcu_read_unlock();
+
+	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
+}
+
+/**
+ * __swap_cache_del_folio - Removes a folio from the swap cache.
+ * @folio: The folio.
+ * @entry: The first swap entry that the folio corresponds to.
+ * @shadow: shadow value to be filled in the swap cache.
+ *
+ * Removes a folio from the swap cache and fills a shadow in place.
+ * This won't put the folio's refcount. The caller has to do that.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache
+ * using the index of @entry, and lock the swap cache.
+ */
+void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry, void *shadow)
+{
+	long nr_pages = folio_nr_pages(folio);
+	struct vswap_cluster *cluster;
+	struct swp_desc *desc;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+	int i;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+
+	for (i = 0; i < nr_pages; i++) {
+		desc = __vswap_iter(cluster, entry.val + i);
+		VM_WARN_ON_FOLIO(!desc || desc->swap_cache != folio, folio);
+		desc->shadow = shadow;
+	}
+	rcu_read_unlock();
+
+	folio->swap.val = 0;
+	folio_clear_swapcache(folio);
+	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
+}
+
+/**
+ * swap_cache_del_folio - Removes a folio from the swap cache.
+ * @folio: The folio.
+ *
+ * Same as __swap_cache_del_folio, but handles lock and refcount. The
+ * caller must ensure the folio is either clean or has a swap count
+ * equal to zero, or it may cause data loss.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache.
+ */
+void swap_cache_del_folio(struct folio *folio)
+{
+	swp_entry_t entry = folio->swap;
+
+	swap_cache_lock_irq(entry);
+	__swap_cache_del_folio(folio, entry, NULL);
+	swap_cache_unlock_irq(entry);
+
+	put_swap_folio(folio, entry);
+	folio_ref_sub(folio, folio_nr_pages(folio));
+}
+
+/**
+ * __swap_cache_replace_folio - Replace a folio in the swap cache.
+ * @old: The old folio to be replaced.
+ * @new: The new folio.
+ *
+ * Replace an existing folio in the swap cache with a new folio. The
+ * caller is responsible for setting up the new folio's flag and swap
+ * entries. Replacement will take the new folio's swap entry value as
+ * the starting offset to override all slots covered by the new folio.
+ *
+ * Context: Caller must ensure both folios are locked, and lock the
+ * swap cache.
+ */
+void __swap_cache_replace_folio(struct folio *old, struct folio *new)
+{
+	swp_entry_t entry = new->swap;
+	unsigned long nr_pages = folio_nr_pages(new);
+	struct vswap_cluster *cluster;
+	struct swp_desc *desc;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+	void *old_entry;
+	int i;
+
+	VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcache(new));
+	VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new));
+	VM_WARN_ON_ONCE(!entry.val);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+
+	for (i = 0; i < nr_pages; i++) {
+		desc = __vswap_iter(cluster, entry.val + i);
+		VM_WARN_ON(!desc);
+		old_entry = desc->swap_cache;
+		VM_WARN_ON(!old_entry || xa_is_value(old_entry) || old_entry != old);
+		desc->swap_cache = new;
+	}
+	rcu_read_unlock();
+}
 
 int vswap_init(void)
 {
-- 
2.52.0


