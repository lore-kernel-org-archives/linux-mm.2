Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56CB3CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42228E002A; Wed, 10 Sep 2025 12:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF23B8E0005; Wed, 10 Sep 2025 12:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9BC8E002A; Wed, 10 Sep 2025 12:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87FB88E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:09:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 498F7B5BA3
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:14 +0000 (UTC)
X-FDA: 83873825028.25.CE229B9
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id 443071C0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H831Ewtv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520552; a=rsa-sha256;
	cv=none;
	b=r1UQzS66TOKKeEEcSxZunEp8t0Wd/B10jpDwfO7ulzVL7t2m7NhUNECfqOq4cDPdyFpH/x
	YnJUS2Ep7k5fIrHLCF2zv20FyjbyJXJEXRo0orjqKfpJi/EBs5coKSkFaqblJB9cSbHFCD
	aR37amrCsGood2xpnTkSzJtUSiOD+Zk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H831Ewtv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520552;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/WGEOxJHrA21wqgG+5kS81ezpjU55LK2AmGw+vBNHk=;
	b=kcyGT9yw+2yt4l/ixtLAd/gzPCplTAh6XLUbS9dp1GTSM8ZtvEsB183N+Kk/sdl4Td3eRy
	RVDhGCU3Ca3Jvf5C0R7X5vR++ZWfaUN7xZxP+jl1N4WEoEIhZxB8gLOxeitfBfoKoHQ3sy
	FIdZplUa3ehS9K3P/9CZkXyYtBnMqJ0=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so5816439b3a.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520551; x=1758125351; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2/WGEOxJHrA21wqgG+5kS81ezpjU55LK2AmGw+vBNHk=;
        b=H831EwtvJk7YXFWkzILif7sRgZYQ/DFXAB9QnT7zNpk3iv4+E/0TW1yDVHJ0r7f04J
         fiK5fq8zkmPP9/TgbGtjmWyFEk5Z1nTY8Xp/AvIEsvj26mEwxhcdNwHhTpY2yVDFu6De
         eRHcWd/e1haBxDXHX9VC0WqN6MsUj5/9ksXjAFgnI2AKdZpxBsDk5cQIdk7quA1xDV6h
         Q3smmohkulNrfoyqp1OdDjSiXLFsXW7qUDfxNcCOwbkeSIoxBWJEIinCxIImJ3fK07dG
         wgwgdN+GcZD2L+ptES2cxy1J6cGo7YKZ6E3Mmxj2z1zNbopUjUKH6TILM+kspXKQZpka
         xXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520551; x=1758125351;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2/WGEOxJHrA21wqgG+5kS81ezpjU55LK2AmGw+vBNHk=;
        b=mDM0dWH7b721dBGK+VeQimoVNREpSU1nG4qE/1DMNu+wtMBkWABJYCTEZrW753KCS5
         2/42/pT+nTWocMjNcBgPVOaRhx2Q5wX2iEIwRU5D8BX2z7Gq+q40irflSkWtOFbDLVwX
         OQEvsyJLbasSkVZqT9m5BtmCMB+oUKq1UX1KpHOD+RRocxNzCZ7UyRZheJLa2eAXYPPJ
         y9X8PHe/GQApu20EGRd3ah17iE9KhcKVODO7KIy735wJMhQm0hQU6V4FIttw6wOIeIG+
         Zxe9OGm6JBQB7Zi7Fce2T8GbdNLhPd3RHu6udZtiXvh+1FWg+EOhFm8lyzVapInCcW+Z
         lKhA==
X-Gm-Message-State: AOJu0Yxd3WFxznc90TP7pFA4F0mQqdzskD/d633wv6zjwEi1dnR0EzJF
	j99eZHMQsaGwIfZrgacOkEmHV3E7svGoO579Po7SXEhwMBLt4EhHymY7ODpox/JpICw=
X-Gm-Gg: ASbGncu52gSemVeSLVNDldvRvzgZT1W0kZnLmNSoCwz8CRaZbyU8a16sd26SIV3d4nn
	smAKogCXDmuLdhOxrum7v5+SgM2YmiQV9e4lqqgGUgSWUwE3rpZFVSg73koFCrpiUTLzKaqylc1
	in18WrMb+Czgt+4a1rFyxpWfH+U4JS9KDGB2bgm+ePbbFwANqWwoP7DkIPm/AVOrQS2pUo56wA5
	0hgM9xwosJBxCpZbKCR05uJodsA8m1CLWjKvNuI6e/6xwSB1/ACEaM14jeRL7BaLQq6qPA9wYlI
	MKHsgfg+lNqbTL6HJG/042rqsurTShgFlZLaIi1cXJiWYIrvJFFgbnVBw49TNiFMxR1ssIWbKYZ
	yfpAYaH8ohTNiLPqGhfMfXX26UpfdpYDYpleUZn6PZupR4FQ=
X-Google-Smtp-Source: AGHT+IGtx55UQI+upmfsPN7ALnjl37EWjQTi7JoiDM2lB8YgnmOo7UdwmjQczornIDM65bBjDgqC/Q==
X-Received: by 2002:a05:6a20:6a10:b0:248:e0f7:1331 with SMTP id adf61e73a8af0-2533e94fa7fmr24671362637.3.1757520550410;
        Wed, 10 Sep 2025 09:09:10 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.09.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:09:09 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v3 05/15] mm, swap: always lock and check the swap cache folio before use
Date: Thu, 11 Sep 2025 00:08:23 +0800
Message-ID: <20250910160833.3464-6-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 443071C0003
X-Stat-Signature: qhdm13typswkq4u7w8o9dshkf99dnqeo
X-Rspam-User: 
X-HE-Tag: 1757520552-932388
X-HE-Meta: U2FsdGVkX1/gFVcORbrLGjWwVXDls6QF3E1eKA8Qh7sOpYvHraSgD2eELDsigTrzlyCzSeMhPNPsIPCAvLBeHzJjiCggoRL256TkhkGZVOaOlGw66fXEnQsW7AzRQ4eUfhGPtEinwTFYasVZfKGiydyUVWoCjZftfpzvMmm1XERTpJtiu87uZ4iVrjJYpQ1pkxkwJ5lqwoi2eefIJx7dNchy5RQQ/05PyjCUgBswRGQenfvSnRHx1zRTTndARXd5XLoSmOSPqwMjjChJhQeO1gb78xVsFzgKlXPcnmMJ3263pTu5v9NKBAE+Mwk0H5onn6FwmGKJ2oS84Sz+Ajm6RebB5UF+p3bQ/CUV04ti7q+uE2RKpuuCLTNT1ujHPX8J8xo0EzqZe0uuuOleLc1RURmaAREG9Ed50FfBugT54CLWBgvtBqa+N8cR3etChfQm36OK49g0R8EUmVPwDobOvNQVPQqQ37EN6Tk/fnZB3KpotBcvWbzAD3Ml5kO9oKp6m061P5DIUtbkqn8DYQNlKwa+bjRipRU2Ch4QJ7dya+O7PoFhzMSxVTBdiK911OcrU4ztaekgRI2Kp9vHzJ53C8dONESrki32neL5EnD8iw+hrT6pVQs3nWpC7a5LDVhHGQIZ2cvTIPeBOcEnvYsgECvk9n3KkgZoCZcd5ivXdFw1kyyAS02sgNkIWXapx1Cgh+JeCvICgKeihAZ4AzYdURLTGUUzWBHZIp9/zyBe0QA3KJMiLt6q7TJtU8jkrREEHvSmKceYJTUSpZ2LtVNfd6PLhAIv/bjeCy3K/DGgNwaCF/BXTTIWsDLiv6cUVT+qhe811GpPg7joyR0ftDZryZc6y3QqBz7/54KCtaKNXSq18twetmDxKwo8IjEedIcujV0UGe00mNgym1Nmhw9m4pEbSovJthOqt98K+e7rHOPTLZblYsDv6miB8vhYK09TUXrygxnd5kEe3/kak9+
 YpKO+iRI
 2enV+mjNx8R7XPMJePxhMZVa9o3CKIq1et004fpUlNJYZQXqzg2gyr7NJPuLUBm8KiOlRCojJHUXTVZiLkATGLq4c52unP0CABLtiPU2nmUwssYrkRLgO1EBWie94Uk2ZiH2iu1bf7dYGLALzOeKhre1lZB2+o/zMDisB8E7SKkP45/pc9anVigV3SnWHFvGLV2QSyfnLoJdKjJ+1MNh/8iGu7ZYnnpefQfXltEleNTq6JgzJW/l7swFRSFQGZOb2qOubW5TeRLm3j0WmfMmiUKekFfq5ZGbrcw13nnEtaP0t5L51dnMflZcPaJFfET62iFuBLoFhlOagFz04NbVlGWmGYR4gymRKgLO9Eav76R7spbK3FOhhQX/39VkKdHf0HC3pmsgSbFUG38D57GL4zOWN61dfvMLmHesCC/lUePkqSHda+LHm1MX11euaX58w+v9a3Jk4MZS+10Y8ijQzqYYN6endtEDqqLGdeqttjGrWDHZhXleazdN5cGGBudmFq7gCmIvNyuXulf128goizNWQ0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cache lookup only increases the reference count of the returned
folio. That's not enough to ensure a folio is stable in the swap
cache, so the folio could be removed from the swap cache at any
time. The caller should always lock and check the folio before using it.

We have just documented this in kerneldoc, now introduce a helper for swap
cache folio verification with proper sanity checks.

Also, sanitize a few current users to use this convention and the new
helper for easier debugging. They were not having observable problems
yet, only trivial issues like wasted CPU cycles on swapoff or
reclaiming. They would fail in some other way, but it is still better to
always follow this convention to make things robust and make later
commits easier to do.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c     |  3 +--
 mm/swap.h       | 27 +++++++++++++++++++++++++++
 mm/swap_state.c |  7 +++++--
 mm/swapfile.c   | 11 ++++++++---
 4 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 94a5928e8ace..5808c4ef21b3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4748,8 +4748,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		 * swapcache, we need to check that the page's swap has not
 		 * changed.
 		 */
-		if (unlikely(!folio_test_swapcache(folio) ||
-			     page_swap_entry(page).val != entry.val))
+		if (unlikely(!folio_matches_swap_entry(folio, entry)))
 			goto out_page;
 
 		if (unlikely(PageHWPoison(page))) {
diff --git a/mm/swap.h b/mm/swap.h
index efb6d7ff9f30..7d868f8de696 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -52,6 +52,28 @@ static inline pgoff_t swap_cache_index(swp_entry_t entry)
 	return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
 }
 
+/**
+ * folio_matches_swap_entry - Check if a folio matches a given swap entry.
+ * @folio: The folio.
+ * @entry: The swap entry to check against.
+ *
+ * Context: The caller should have the folio locked to ensure it's stable
+ * and nothing will move it in or out of the swap cache.
+ * Return: true or false.
+ */
+static inline bool folio_matches_swap_entry(const struct folio *folio,
+					    swp_entry_t entry)
+{
+	swp_entry_t folio_entry = folio->swap;
+	long nr_pages = folio_nr_pages(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	if (!folio_test_swapcache(folio))
+		return false;
+	VM_WARN_ON_ONCE_FOLIO(!IS_ALIGNED(folio_entry.val, nr_pages), folio);
+	return folio_entry.val == round_down(entry.val, nr_pages);
+}
+
 void show_swap_cache_info(void);
 void *get_shadow_from_swap_cache(swp_entry_t entry);
 int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
@@ -144,6 +166,11 @@ static inline pgoff_t swap_cache_index(swp_entry_t entry)
 	return 0;
 }
 
+static inline bool folio_matches_swap_entry(const struct folio *folio, swp_entry_t entry)
+{
+	return false;
+}
+
 static inline void show_swap_cache_info(void)
 {
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 68ec531d0f2b..9225d6b695ad 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -79,7 +79,7 @@ void show_swap_cache_info(void)
  * with reference count or locks.
  * Return: Returns the found folio on success, NULL otherwise. The caller
  * must lock and check if the folio still matches the swap entry before
- * use.
+ * use (e.g. with folio_matches_swap_entry).
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
@@ -346,7 +346,10 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	for (;;) {
 		int err;
 
-		/* Check the swap cache in case the folio is already there */
+		/*
+		 * Check the swap cache first, if a cached folio is found,
+		 * return it unlocked. The caller will lock and check it.
+		 */
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			goto got_folio;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4baebd8b48f4..f1a4d381d719 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -240,14 +240,12 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	 * Offset could point to the middle of a large folio, or folio
 	 * may no longer point to the expected offset before it's locked.
 	 */
-	if (offset < swp_offset(folio->swap) ||
-	    offset >= swp_offset(folio->swap) + nr_pages) {
+	if (!folio_matches_swap_entry(folio, entry)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		goto again;
 	}
 	offset = swp_offset(folio->swap);
-
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
 			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio)));
@@ -2004,6 +2002,13 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 	bool hwpoisoned = false;
 	int ret = 1;
 
+	/*
+	 * If the folio is removed from swap cache by others, continue to
+	 * unuse other PTEs. try_to_unuse may try again if we missed this one.
+	 */
+	if (!folio_matches_swap_entry(folio, entry))
+		return 0;
+
 	swapcache = folio;
 	folio = ksm_might_need_to_copy(folio, vma, addr);
 	if (unlikely(!folio))
-- 
2.51.0


