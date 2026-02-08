Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D024EF06F8
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4896B0098; Sun,  8 Feb 2026 16:58:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27CBD6B0099; Sun,  8 Feb 2026 16:58:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40096B009B; Sun,  8 Feb 2026 16:58:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E56B66B0098
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:58:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B532D1B3172
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:58:55 +0000 (UTC)
X-FDA: 84422655030.09.0B36788
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2AA1318000E
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:58:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dRPMC3fs;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCzAnUs0VtYcvzowlURB7PfVAQtyZ2LBB9m2XBAedLE=;
	b=Rkvczawc11/ak5RsEFutAkgyfLdQ/IcrzjtdfGlc4Sm+I1FcFo2F4XbPIXNIinrYmVOaSO
	6AqYPZ/9b96QEp/spjk68ATon1C/1lPxDRo7tQBlHXHjkQsudmcJLD5c0Iv3PooJwT5rpZ
	HludHOAvFXs9KyYD69NRDyV9oCQgbBE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dRPMC3fs;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587934; a=rsa-sha256;
	cv=none;
	b=umFjhLUTGqFKrgfztHqSPA6Ix2mmSAHThHxAbGhviysICQv0rMJsi1PmV1uU07W918XcBl
	KfwCz12yNBXImWRfMfxpK9aQAL18VcqEf/iDWvlE3xgoCjijkA3C27tE4+WFG4ne92g8mS
	W7lYOxRlMcTgKZ3+Z2jDBH4w4lvV5Ls=
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-4042905015cso1478263fac.0
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587933; x=1771192733; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCzAnUs0VtYcvzowlURB7PfVAQtyZ2LBB9m2XBAedLE=;
        b=dRPMC3fsZqD0WnEQrNJhdkJsFQ4YeNCD2m/tCfNCXF1IDZCuKvYz77TwAXNp6yauX8
         r1vEgCo1kPrIqK6Fofh73Mqv2J2t5aD5zNM7nbr689OhKgfK/N185cN4WgdCjOgnnyef
         x0nhqOfFBikNzWZGH1G9FlI4iDHqDdEXdq/CC+4EKXbe6GB4lSMVlsru2gkgGwq0vJuw
         otL4uocSvSV/8ndqyP2BvCrs8tXTgi4ZuQEGaimpYsO5D58yUS+p8xWAGOonYtSlm3y0
         Y631ae4CVl01p8A03UOlOmT7O/tXHc/KstHrcF0Ix3xl+FfWSnt8N5wehyMrZxp/cKdG
         jiaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587933; x=1771192733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YCzAnUs0VtYcvzowlURB7PfVAQtyZ2LBB9m2XBAedLE=;
        b=X3z0RzUwhAubAnUF8a8nSLmB5GA07WNsc0l3OAgd55e4RY6tLrlY5Ls71FUFZW7q+3
         pC2WNjH5Usl8kaconMliBFLMdCW6nl6tV8z1Qlz3xeFzPsOmBlCRxcQPcXi5q3nUF1zC
         EpNpFa3dmDMEN6P8mcvEZdexCHefCDXtxq5Fbxp0qy2Iy8w8gGo49qLb2lndXA15dlVC
         46HPsJzxriYU6rsDCpLBveCtpFk3dOLUesGIOXI9daKAPFg/R7yirQcLgI+cANC02tC2
         YpkRJv/EL4uMN16LKWNzTpK1w+RX7pD0OBtkvhcg6fek3iI1zwbkq8K/SbZVbjuySVdB
         6XUA==
X-Gm-Message-State: AOJu0YwhpqFOKC2wfXxlbSUmDXX4kIkZqqk/QfAqaGUosKOUEjlHpopj
	GIUVCoFT6VWEaNbrhGzUqT5kqGimMKY61WkGSdd8GnO2aSt/0fyrHTySil+wYw==
X-Gm-Gg: AZuq6aIaDHz6SkDsAGYE2RQBjsJ5fEUsx62Gb6GD3bnqy6EMNAEu1s1Gm2xY9wuCltK
	ppm0z01FR880pZJBcb0+hT/KX3uJ5BgJmP3bP9Xl3yvOjGUT60ff3AOuPppUDbCTQ3u//HozURE
	n+BxqDFQGEIQSwmSHe6F+yk91WQ/QSkI0/6N67hvx6LtLKZIeo2tLUPvSKVZYIJZ+l43mi5ShnY
	FuQ8W1/kKb+bdALqjo0o6qGHZaqillrgKlm3LRu/gpHjMixBNgnFY4y6N5NXXMksSi8VEcdr0dC
	8567e/19hPm8H6uONzl41CDqk84J3WNNOx+daY3M6ia+nYVyqBHrUxZ44TXgVpv94pWBUg4U/44
	Wtx3ytwUCeA7INiQ1/pIy9lBHdNO5f2NLH8HOVl1xk6q3KbYD1b0QvzyKaRRv9YDfsPCBBbEEdg
	wSF68zbYDMrFld7ZPGvlG1Ud6s1zbnx2iqBQ==
X-Received: by 2002:a05:6820:1514:b0:662:c369:8af1 with SMTP id 006d021491bc7-66d0d5e38b6mr4727396eaf.78.1770587933119;
        Sun, 08 Feb 2026 13:58:53 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66d3adcae3csm5051168eaf.9.2026.02.08.13.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:58:52 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 05/20] mm/swap: add a new function to check if a swap entry is in swap cached.
Date: Sun,  8 Feb 2026 13:58:18 -0800
Message-ID: <20260208215839.87595-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m4hkdkxsxda6swmzocoiywddsic3ijpq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2AA1318000E
X-HE-Tag: 1770587933-306648
X-HE-Meta: U2FsdGVkX19gBRbehaOZXVImCG1qE3xNBP1SgFbsKUYcR+i13pMfHgsjBeLv2tZTldeEYHFkEyVhAaoq80Xk1HW6i7kuTW7vduVlChz6MvvQvwRM9z8fHQYxD4prLlpLnSzVrKE3GHOiJisaxLL2DQwfqG0SV+R7DSlWZkhym5x/6mhu1HvKnwg7JhoEw4goa1bVNQKiQEzhj8Aypsb75J/oAA5/xBjgm5QjHzwJMT4VTgNWOV7yq3TixbttcWE31QbWk9Plfql1jZAUK6f1ihfi5+QNDMQon5O8Oqbf5zluQK/Y0qLE4QE36TWD9lUyG5saK+3qz1WwWILphiyT5UqhJKb4LfW0a3zWmgnrrvU1KIxQo1259xJUA52L6dEqqT1DNpXPBRm7V6fTKQeAzL2SoC7VYb26zuwRl6dfTGmGGoQOLQiq9F2iKRoU9feXm7sYPZQWhE7oiQTL6nC8BXjS5TXuA8lpXws4Rq1aMoquPN/0BDuUdHFLv31gNcSHVY7DxM+ZZa1YgJlSqom09RparW4imih94GTQNXYdmxY38FhRxGFQPMPxdaKB/r/UmP1DxEq0ARGXHbnqphzqmbM2ZhbsA6b4ovU4FcNpstXpQcIAtSbisyOm94SxUJ4TZsasVFO2hXvCfrIGRYCmaovSipaq+KfgMIDKM3L4LzfMPACm15gNx+xpx7i1xptuFMFRSVRXhPDEAb6CP2Zu/83WEuGwK1f82OMnaBKILrYqZN3+rZhDDVlRCnjCKpfiWSGLNuWvpskH0tOE+vTE1P8lkWSjqB7Squ/YSt3HtUk6/8klahCZ7ieWNyCifBaWbQcd2ZvTqSmo16bYbi4Ib4qi9zJ0KAOwEKV54+5rfAk0l6VK5a5mS56r+SIGXcRiWSENYIuWhmqoO6UyWfkf0l6T5Xnzj00QsnWBfxsOmMJi5yqTEvH12ysapd6lADbDfYVZJcVS+b2o6uw3auo
 t0JhdkRo
 5AQANY8z4KzVi4yMbjtHuBipAPzgl3ZZAXqFDYRJULtlhcUjKJtLgLvbUdXc9Mq5SC9QrRPq3iIk92QcbueoEsPUbPyFPYDH2vXJGEMv73GqUC1QqZesFI/bMFBzQqOL1VhIwvrqBwXzL/CY2JR3YYdON0HTm+6Klhi3O0lDvWOdPGiKt4+FY4cdNqDY79xAT9pA044Xs2YuhqlGnggVpC7pjS7IdGD/tHnoy/Jo3aZ5ch/SgN3rrrRCvZtBOAQG01o5SqmUHdJ+38hA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Userfaultfd checks whether a swap entry is in swapcache. This is
currently done by directly looking at the swapfile's swap map - however,
the swap cached state will soon be managed at the virtual swap layer.
Abstract away this function.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  6 ++++++
 mm/swapfile.c        | 15 +++++++++++++++
 mm/userfaultfd.c     |  3 +--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3da637b218baf..f91a442ac0e82 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -435,6 +435,7 @@ void free_swap_and_cache_nr(swp_entry_t entry, int nr);
 int __swap_count(swp_entry_t entry);
 bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 int swp_swapcount(swp_entry_t entry);
+bool is_swap_cached(swp_entry_t entry);
 
 /* Swap cache API (mm/swap_state.c) */
 static inline unsigned long total_swapcache_pages(void)
@@ -554,6 +555,11 @@ static inline int swp_swapcount(swp_entry_t entry)
 	return 0;
 }
 
+static inline bool is_swap_cached(swp_entry_t entry)
+{
+	return false;
+}
+
 static inline int folio_alloc_swap(struct folio *folio)
 {
 	return -EINVAL;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index cacfafa9a540d..3c89dedbd5718 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -194,6 +194,21 @@ static bool swap_only_has_cache(struct swap_info_struct *si,
 	return true;
 }
 
+/**
+ * is_swap_cached - check if the swap entry is cached
+ * @entry: swap entry to check
+ *
+ * Check swap_map directly to minimize overhead, READ_ONCE is sufficient.
+ *
+ * Returns true if the swap entry is cached, false otherwise.
+ */
+bool is_swap_cached(swp_entry_t entry)
+{
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
+
+	return READ_ONCE(si->swap_map[swp_offset(entry)]) & SWAP_HAS_CACHE;
+}
+
 static bool swap_is_last_map(struct swap_info_struct *si,
 		unsigned long offset, int nr_pages, bool *has_cache)
 {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 25f89eba0438c..98be764fb3ecd 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1190,7 +1190,6 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 		 * Check if the swap entry is cached after acquiring the src_pte
 		 * lock. Otherwise, we might miss a newly loaded swap cache folio.
 		 *
-		 * Check swap_map directly to minimize overhead, READ_ONCE is sufficient.
 		 * We are trying to catch newly added swap cache, the only possible case is
 		 * when a folio is swapped in and out again staying in swap cache, using the
 		 * same entry before the PTE check above. The PTL is acquired and released
@@ -1200,7 +1199,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 		 * cache, or during the tiny synchronization window between swap cache and
 		 * swap_map, but it will be gone very quickly, worst result is retry jitters.
 		 */
-		if (READ_ONCE(si->swap_map[swp_offset(entry)]) & SWAP_HAS_CACHE) {
+		if (is_swap_cached(entry)) {
 			double_pt_unlock(dst_ptl, src_ptl);
 			return -EAGAIN;
 		}
-- 
2.47.3


