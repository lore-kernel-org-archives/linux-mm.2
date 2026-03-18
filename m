Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95D981088E49
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF6C6B0350; Wed, 18 Mar 2026 18:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0EEB6B0352; Wed, 18 Mar 2026 18:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14EB6B0353; Wed, 18 Mar 2026 18:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BAC7E6B0350
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F65B1C27E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:03 +0000 (UTC)
X-FDA: 84560627886.23.B240E4F
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9C8F8180009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Vl/IqgZ1";
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHzOeFlaQp2gdFIuNzaMDht2eyy5SJ0a+c6tcwRztv0=;
	b=QnT/IVmBVkqaaopt2O1pWUxfZMgSPR0S9oIV10m8BUpGTb6V5SJ1vBt1FXUU2Zx1WAYPN6
	Kuwle0qJgUrF1DSUuFb8b8YeFYpB4cid2PfxFOjLnIg0yJ+fOK917c35xLQQhDYmOM0y+t
	QADuXPqX2XDpgIw4WySTLMOTZxY6oEg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Vl/IqgZ1";
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873001; a=rsa-sha256;
	cv=none;
	b=lrdUMbzcB7K6ZfGTSjenuxdizwUmFga9jjLalDxJ0vJAUkOvJUW8H/KMHBvGI4DGECPRTS
	ZOTkfsgZzBNZQ9eaV6hwlxXUUBoA4lndfA7CqqMrmgxSeZIx+414G0VCHIPe+3W515j6sJ
	wRxbBKAJsYVlrEYYoldEd2oyq1Z43yQ=
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-4670676ba03so37427b6e.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873000; x=1774477800; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHzOeFlaQp2gdFIuNzaMDht2eyy5SJ0a+c6tcwRztv0=;
        b=Vl/IqgZ1oN2YlDMsjRrv9gd5OtmxkT07MT61KmH+5aRtCqs0YR9Y1qKWWHBVRNhjSt
         hRGPZYgprKjKuA9BWRkmHDvo+UWgWrCNAXKUKNRBNbPzLLOofI1MzJqYyNQoKfcMRuID
         fK7iSBpcrVLnwTSYBtWNqVGZuzXOGZQPHF0dCD7mFBMjDK+sGQAtVxYRT2e/pNIXCns5
         6Pr86u8rjGwP0B0+ILGU6xCq2cMSFUdLVLfB0g98kFzv6ubT1RJW0bAXMvnMzSNPLo3d
         cr78CcyeC35iCtTXYmXcQUgfAYRHmuM/z3XVx6JIGDMNKeApPUoCk1BDt/cmYDbxTRWs
         qFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873000; x=1774477800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZHzOeFlaQp2gdFIuNzaMDht2eyy5SJ0a+c6tcwRztv0=;
        b=CEIKMNZaE0T/29yfLNM4LHuw2giQVh1MtY8xyRauVMsTtFDyNfjlg0s2R2DafbMgTb
         3yVUB2lrhBxToc/8iGF/ucrwIj9d5sMN3YJzbY4VxRuO1Ev/IVe1vW/6lv/ltB5//6Rc
         DbzIHv5nZJnQOg0cIuUidcUZh3ZDT10itkQWkaPrCFbAo1UAvUO5+4992vsad6Lb13jI
         w0GvTGfpVUUFNtGMnf8CLRxt55QvJfuS4ER4foIKh2TVQDFf/1u88BgZ1UjlphBVa8s5
         3AEWKTwJGpXx7mB4jD8ZwvpOcx/ymXTSrkqKsyXvxezMOi1qnJN1z/a1ogD9T4Z/R1jd
         3yUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRVwLi6SWRDyCQs2gEm/JYBN8lygeZowXLzsAcBindmZi2Dr4CFgGSJym8Rw5TKJ9UnxFZkCwR2A==@kvack.org
X-Gm-Message-State: AOJu0Ywq14a7tNk7z/euuBmaAcnJwhGBygZmAndIwXEsUWwfvOOSkXgW
	T/FDXhb77Nz2sieXQJJCEnEWNbMmjg1sqpLyHz+RO2KPcbKKeGadSiJE
X-Gm-Gg: ATEYQzx5qLc/LmZdV9gT+LiuWg8Xsf454JRsHitStFl7MmbR4splbfr4yH2LgLARUxi
	qFNXuhb3diToROVbKLyDtveqDBh5cxa8Q12aG247VufZTHEJVCahkEB36IHylT0sx1A8MeffgwI
	qU0WiMFyCgtOIkPXcL1sZq7F9Uhxa3UbxgvMhj3UDiWaCxQQngog4OEnB5mFzUWm62dlEGxMioZ
	wv5TdKBTZxeC/NMsUWx27A+kyybrl8YzunwMmguMIy/4gv52jENNraDCtSiaG8BKw7879keD6T8
	KrMsJiOurH38k81xU4UhwWBi2QJdUkHIsQEhCI0OXn/DM11kOZDEn6fslC1RhkkVg4dFvAkekxz
	m74g9+ssHAJJfNZXAzMXt/cFEtLe+Ktq7hU/qQ5KVrReL329WGxa1I2f0wKTEn6EUiZtm/Nrou/
	eVzIo/pde9cMwQIfFDJQ8wumFNfV3SRxAQxBPXoOkqWAjUKg==
X-Received: by 2002:a05:6808:4f67:b0:450:5e3a:6f20 with SMTP id 5614622812f47-467ba15fab5mr2899816b6e.10.1773873000519;
        Wed, 18 Mar 2026 15:30:00 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:50::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467bab02e3esm2553952b6e.17.2026.03.18.15.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:00 -0700 (PDT)
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
	riel@surriel.com
Subject: [PATCH v4 04/21] zswap: add new helpers for zswap entry operations
Date: Wed, 18 Mar 2026 15:29:35 -0700
Message-ID: <20260318222953.441758-5-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9C8F8180009
X-Rspamd-Server: rspam07
X-Stat-Signature: d1y9z5bwqwgt3315az18sx59q9dkmyhi
X-Rspam-User: 
X-HE-Tag: 1773873001-437507
X-HE-Meta: U2FsdGVkX18nd+RwPsG5UHUSRbcXpEmz2YZzQgtPe9ht4f+Y3ewWAcnnas9QKOSpWUJ6KFiD+Y5ECFln5ydtexpit7NThHQQtv+W8ykNAMQQtEIBrf6uijDAkqePqFtijZNM6BEiagdpFY83WuCCbwmnuEvy9IYhIvce+bZMIaQnMeCcgwVdsodW8EdzZNcZgFpFTAJDM1LUjyfMKhiGBWJNmhnsTKZEB+KgMtqK5uB3zbxNwZ2bqfPwo3Lz4VqjhtvXHRPN+9xFVoW2iYO4XVYbekMsHwecanGpUD0YYkhFPXXAQ4fRZK6GQNVWGGSqoo7P5X8bf3qF6SQ8YLgZur8jwObNseXBJZtXA5YRtdCOALylmkXVCUTKT6+U6yPRUMD0puPVezLLKh69Bl1uTaIP3xM8/wpGnGB7mZKN4Q8rFehw2pVS2hsbVqCgsS6XVFvyPbTXepydeDMPF0lvOcWh1oWeO3JlUp8pJGXiuuON9Y0U9+vEr1NEuJL6Zs9rkkYuIORZwqcTrwcIYY7SCCANiHHfiF4E9zbBh/pfGqTjXFo9pbaybUCXNpzuLpzCtKv1Bq4zvi8MuOiF/sjpZKpvsbeJspbOOBSo25EoeBRRSF/LJRlYhaK0f5i4Mk/bzzQAJBsKtEOVnuE3cNJwHija+cjg/HOqoQQpPoraTgJNpNCYqCuPXKl7xuXUgQ+3tgP+64aibOPIpWKSQMF5H9aLpkjU2Zb1Z4s2OwUAoHpUQM5THjoDV/Nog/sgUO40Y0SMnz/klDAEel242WWigPlLePRtnX0llpgU8Fcq/J+id0gmjgTF+XHz1MqXWU7WU0lAGQNNVC2C31K2gBXhJ+d+p7ItsAtZA367GoFXaJqs63FYmHlU6pA820rcLukV2D3mbIqvi/GcocPaUkAxgxkZE8gt1+vmjMmsf9U+CdGmgkl7M0gYxYH4cbee93d2jryCxn9+TFfdS0g0QsB
 QFN6Qs7c
 vaH9EIpv13FQORR9G+xCb8pM5JKiY9U4+EvKF4dPJ2LepUH3F2Mn8xJe8nS9KAv7CcR5vOuX/YW4ZDH2HB96iVsJlgxUoAGe2InnD6gtPkizXgOdcY9DfC9pLYjyfL+Oe6JWS9JOzQ/kz6U4g1/ATWAs4kpwpKR48RUcyWpk+cVSZtUJp9tsbQwTM3d2buzx6DHDQFvoLdgsap1q1A+JYggm2U5fZPE1Gw+f9xFLR+7Ywy+U8SMNSxGKItRAYnj429MRguxowz+fv+crexpJWitDUBrp4RXR/HtZu3ZIHyTm7t+crWqR8d1g3k0TIE1V24LLnp81L6mO4J3bubjs6S5n4Xxh835HPqHA/YZNpljM1CO9T9Uvqt1styNiZiCjs/IWLqJLijldrwPMU9jGODLLOGF/K9/sXv1uOTjJLBLt7lVsve5ts5xk4EB21VDC49YltYzqcgLTNUWxtqeRxx84wp1Es7diQZ2XA5gObwYgfeaWUfvQoWoXm8LRvr61tWUPfHe7u5HiLiSgsZi7+6qYdmDGD8uZrrbMM0mTsIRVi/qqbFMqcEM1zY3mKOrEraQUqysNCpNFguBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new helper functions to abstract away zswap entry operations, in
order to facilitate re-implementing these functions when swap is
virtualized.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 59 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 19 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 315e4d0d08311..a5a3f068bd1a6 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -234,6 +234,38 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 		>> ZSWAP_ADDRESS_SPACE_SHIFT];
 }
 
+static inline void *zswap_entry_store(swp_entry_t swpentry,
+		struct zswap_entry *entry)
+{
+	struct xarray *tree = swap_zswap_tree(swpentry);
+	pgoff_t offset = swp_offset(swpentry);
+
+	return xa_store(tree, offset, entry, GFP_KERNEL);
+}
+
+static inline void *zswap_entry_load(swp_entry_t swpentry)
+{
+	struct xarray *tree = swap_zswap_tree(swpentry);
+	pgoff_t offset = swp_offset(swpentry);
+
+	return xa_load(tree, offset);
+}
+
+static inline void *zswap_entry_erase(swp_entry_t swpentry)
+{
+	struct xarray *tree = swap_zswap_tree(swpentry);
+	pgoff_t offset = swp_offset(swpentry);
+
+	return xa_erase(tree, offset);
+}
+
+static inline bool zswap_empty(swp_entry_t swpentry)
+{
+	struct xarray *tree = swap_zswap_tree(swpentry);
+
+	return xa_empty(tree);
+}
+
 #define zswap_pool_debug(msg, p)			\
 	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
@@ -1000,8 +1032,6 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 static int zswap_writeback_entry(struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
-	struct xarray *tree;
-	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
@@ -1040,8 +1070,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	 * old compressed data. Only when this is successful can the entry
 	 * be dereferenced.
 	 */
-	tree = swap_zswap_tree(swpentry);
-	if (entry != xa_load(tree, offset)) {
+	if (entry != zswap_entry_load(swpentry)) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1051,7 +1080,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		goto out;
 	}
 
-	xa_erase(tree, offset);
+	zswap_entry_erase(swpentry);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
@@ -1427,9 +1456,7 @@ static bool zswap_store_page(struct page *page,
 	if (!zswap_compress(page, entry, pool))
 		goto compress_failed;
 
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
+	old = zswap_entry_store(page_swpentry, entry);
 	if (xa_is_err(old)) {
 		int err = xa_err(old);
 
@@ -1563,11 +1590,9 @@ bool zswap_store(struct folio *folio)
 		unsigned type = swp_type(swp);
 		pgoff_t offset = swp_offset(swp);
 		struct zswap_entry *entry;
-		struct xarray *tree;
 
 		for (index = 0; index < nr_pages; ++index) {
-			tree = swap_zswap_tree(swp_entry(type, offset + index));
-			entry = xa_erase(tree, offset + index);
+			entry = zswap_entry_erase(swp_entry(type, offset + index));
 			if (entry)
 				zswap_entry_free(entry);
 		}
@@ -1599,9 +1624,7 @@ bool zswap_store(struct folio *folio)
 int zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
-	pgoff_t offset = swp_offset(swp);
 	bool swapcache = folio_test_swapcache(folio);
-	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
@@ -1619,7 +1642,7 @@ int zswap_load(struct folio *folio)
 		return -EINVAL;
 	}
 
-	entry = xa_load(tree, offset);
+	entry = zswap_entry_load(swp);
 	if (!entry)
 		return -ENOENT;
 
@@ -1648,7 +1671,7 @@ int zswap_load(struct folio *folio)
 	 */
 	if (swapcache) {
 		folio_mark_dirty(folio);
-		xa_erase(tree, offset);
+		zswap_entry_erase(swp);
 		zswap_entry_free(entry);
 	}
 
@@ -1658,14 +1681,12 @@ int zswap_load(struct folio *folio)
 
 void zswap_invalidate(swp_entry_t swp)
 {
-	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 
-	if (xa_empty(tree))
+	if (zswap_empty(swp))
 		return;
 
-	entry = xa_erase(tree, offset);
+	entry = zswap_entry_erase(swp);
 	if (entry)
 		zswap_entry_free(entry);
 }
-- 
2.52.0


