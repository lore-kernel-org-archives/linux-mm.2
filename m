Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B35FCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06BB08E001D; Tue, 16 Sep 2025 12:01:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042608E0001; Tue, 16 Sep 2025 12:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B118E001D; Tue, 16 Sep 2025 12:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAB1F8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:01:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A228A140254
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:48 +0000 (UTC)
X-FDA: 83895579096.11.6343F00
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 66F0720012
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a0FYpbQE;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038505;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WUbuObwR/zGB6o+458rEcXiMc4zzBo5aJZO+2YfyDE=;
	b=f1Bd8mpdAK2eDP9vQV2iEMZHl78sF453vejgJrXcUub5yx5+p1mYArGCF/MGZT8mrSA4hH
	pez2ZQSyaLZAxJfPVbZ7vw4vuhHfXL41563+cIL5YABxfTulfjscytlMUL6uoKT4ymsL26
	vtmB0RDf60RcXe0NF2iK/8I1EQnlO98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038505; a=rsa-sha256;
	cv=none;
	b=4arXq+so3ktRMPKUdqjVKTyAqiETOn18SIbzvQKcdv1ElarHCK1lmuiU++toB7Cm5jeE7Z
	FMzofrWsSr+GWiJ228Vmvm6O2dBU/IhDpVZAZJ6STB9ByKkF5WpVgrWvBcpiLIBsQfMXiR
	KveYWk0n7IQuv1xRwEhqC7Spsm4k/+4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a0FYpbQE;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-43d2da52291so946864b6e.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038504; x=1758643304; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5WUbuObwR/zGB6o+458rEcXiMc4zzBo5aJZO+2YfyDE=;
        b=a0FYpbQE5E8a+Vorzw80UQA7LGZLM3Xf1MC/qcrqHoJGpdxYdLuGQnQ0D1c3k8I2BN
         KSzusniAj0Ggp9K3FxkZrjttqRNTZj6O5JeFMpaeYCAcacBjnJ3IEoVlvVTtji9pIE36
         1XFKa1ILHisA1wWteM44KH3yfAVjEH9fmVJuzcnpmkKYZDpxyeyx/52oIZu5Q599Pq8z
         xspx5Hxt76vyGHHjQV49okX0EYc41JJ4NowOx1hP4ncRZPBlihk+nf4N3JEtjtdJ5SUt
         EuDqSxZayMh8f/iEExYApqAWR+uHtOPTiZeeCGgvTCXGleTrf0zAr9/wBA+8SRzIeEh1
         s5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038504; x=1758643304;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5WUbuObwR/zGB6o+458rEcXiMc4zzBo5aJZO+2YfyDE=;
        b=mL4THG6waaoxKFiNMLsBfSKgsiS4YDhB8PYEly3v5kQ2ylB4JKJPAXgdT6+gQmaPgh
         cq7t1mv6eQeFtKMtJRlU9DRW/+RJBeh/Bbom9ysx6v5p3GAR9wGhE+82LlfWgnCAkLUH
         wBXEQsE2VsaONBPeIMDMr3hBQ5aE0uTlcL4jePMIykhxpOWEvLK8pqCfy32Z0Uw26dQf
         0DJj8df5UVYttwr8SadNSk2RQ8esEos9N5DZVwqzY14Q3+hk8vJ2jpYnfh2z8tWwh/dY
         5dOWrc1otiP/nRMtXqER17hgClgA35uBzso2y8lYnPV5s5G1VYJTXc+WwsYawCejcGjw
         poQw==
X-Gm-Message-State: AOJu0YwqJ6HEufRztTYXcXzhVZIHIBim0tAK7gOZ9XJjDE4UwjuDAIXo
	2D0xmvq+cw3DmNR7MHbJwSvB9e+0P2Kk/a8CkjFKtztLR47PnCCQu8aUB6uYJ3Hx6qA=
X-Gm-Gg: ASbGncuHrIBp5LBiGStEbw3ALcCYDnRCl0rzqexxPuVKNTRSss27ntyhZESWorQsj+s
	Y0SyuwAXXeJmsBfWbXUEtQtt2ce17U6DswH2YBGOc+Muht7pyO7xNFADAjcH5iCVGjGxp0CIvj+
	Yburut6HlR8YHE4OtWqahq3xS6Fzf0xdEREk0hs7OJixiFpGyl65Y/2ZRNOc5wn8nNdHGID2oi0
	QJkJ0O1Y/u2QJnBvENWwkBCh2JtWSJ68iQg38ozYYv/GiR9VrtIW8P+mHmE4d5NYTHlQFPim4HU
	h4y6pVUhc1TaKU+2XmJips5GtcfWnEZn+1En6hTqWYhGLelaLIxsiUrKRna/9bTZt5s+ZjBQyXU
	xBozMENm/Ko6xK6KWvkFfxQMHjFtbCM6/Em704bDHbHZjBJw=
X-Google-Smtp-Source: AGHT+IFBhPfVPOhAahuA6aEtJjmdTvB1mnKAm6YCg8IDJDgWKnZus2UsNTSxw89RB9zsYks/2PG9OQ==
X-Received: by 2002:a05:6808:1514:b0:437:f998:22 with SMTP id 5614622812f47-43d3f46503emr1431448b6e.21.1758038503102;
        Tue, 16 Sep 2025 09:01:43 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.01.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:01:42 -0700 (PDT)
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
Subject: [PATCH v4 05/15] mm, swap: always lock and check the swap cache folio before use
Date: Wed, 17 Sep 2025 00:00:50 +0800
Message-ID: <20250916160100.31545-6-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 66F0720012
X-Stat-Signature: ihu6szzjk3nk6w4hmkr795qmdczgo179
X-Rspam-User: 
X-HE-Tag: 1758038505-956478
X-HE-Meta: U2FsdGVkX18v/aq6R/I0/YSA5/zIskQkKhxDVRJjSYDA6FoskMEUanQEv112fG86KWz3k2Isrtc5douiUc7LRqkIbqvEm0itFhPyQFCEauoh+dfkrVJiCmci15n1gCfmNH22j8T3d3/tec8buV8o/osPdWFpR/XD+NzcnclLj2NJrPk3IcQiuviBwqrdsjCWux7TFCRy1w9+spJ/Imv8GuKS0OVfa0IE7aZ7YJ/74vkUu6WFA2uUtUmFAOcbeQ4JQzcSU8NW+bRszZtEVcjud0g7bvtnzjcQxq4oQDljPS8qDjlTSRy7r9GYdzf2m6fYMz+8slrQgr0dXWAxKQo4K3XOgqEftyvnCgajzwlzv4L3d7gy4cY7ZtNRbFZ5z1dnMSK8u+b9qtB/fyqofVsHQTSOimXxrwTq61e9nQL9O/LR3HWvVwOveFaK1Zson7XB2ciov3+OfHD4wfaxafXO4RScT7YICegUwLjPcpTSvYzzVDsA7BcssVGQW0fC0LIVwS5wbSrTyxZj/OoEyV1UT2vk/lcdsbRvDbY/tHYMeExaYyeamlcMDeK1FVQUWbdLr49Y7tCJHzTlMs0yK8vd5iKrID8NuCzAv5OyvZNeTYnwunAbKl5tSoNELCMdmnixyBBDYk38uBZQjbrBMJlLJfNWRbgifxvrUNNn0JlWqF6logwed0P43c5s0Xw27Gjc/wglP0PQGMW6DUmGkSueEd3jXWAZCk7UdBxHva9d7sBhUiRFOskJ0BOF73+J7X7gVcGscoHDUpV433qRKytISDM8Iiu1nal1qUa4DX9iRb82O9K6gaPL38SAabboWyj4sTneZTQ9UhSbHsIUFJQSgMFhq4QcayLNwKM/WUrBaoenPztDWVyV5uXIxVgH7+UW6PewLAktU3r/qKNn5NiOTs7ADgr35WSVt8LtY8b2lxBsNVVN5a6ZXLxiWiQghl7Fu89ZGBCK5Sw09VIPEkN
 oDK99qpx
 XPUc+r7hZiOQ0khqgGOpwmPT5pS3cToM1RvhoRdwN6p9tPqlucwHQLyQ3bH+8aeGEqcjE5xXWxD+KL8yMfVDFPMXocnouIeq02E3ZIbiRpZyV1yBpEctemoJzTRalwZ/jUi+ePhm8tpumwfbN2YVDjOqmuFcWhi430WuVf/f8mcpVi+6aXjlmyzSRGDkY5eW7ozbELixAeoQ7GoFtxbfZCkeCsMeeSwH8b4LLjLMFKdTbwDqpxn+p7IPo8XFcEYJAbrVZrODd7ZIcgDJ+R/Gu2eiiwKz7SDWK1ENjqyv+PoAZMGD/yedmh7sOeGH9XCeXO4PEZ/+8deDUa+8kwgJKuG4VRiAHJMVMzoEbCiVZZTXXhi02DPsVXRIShcvETww5eazD/UYUkBIldd1SoMfrxFHMkbUC3FEWWlxZZdpdx7VDoWC0XvHt8JrtQAtb4NwVX1rI1JabjUFnPD3J7nM1NwPZI+A797nAOU9yAkkz2dPqJm/OxqAkT0N26t0/QjRIXkjf4D5Z/6WKQW4MiZFvjDtr0OHHOIK3pFU0PAgTw13Fyaq/60xdvqQ8wKA5dHrpcHSUI08fKYEjsNiraJR1EgaEB5bAgBJFZ5ttR9RH4Gf+vuq/ySyKSZ6O95FH0hh8jOYd
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
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/memory.c     |  3 +--
 mm/swap.h       | 27 +++++++++++++++++++++++++++
 mm/swap_state.c |  7 +++++--
 mm/swapfile.c   | 10 ++++++++--
 4 files changed, 41 insertions(+), 6 deletions(-)

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
index 4baebd8b48f4..c3c3364cb42e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -240,8 +240,7 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	 * Offset could point to the middle of a large folio, or folio
 	 * may no longer point to the expected offset before it's locked.
 	 */
-	if (offset < swp_offset(folio->swap) ||
-	    offset >= swp_offset(folio->swap) + nr_pages) {
+	if (!folio_matches_swap_entry(folio, entry)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		goto again;
@@ -2004,6 +2003,13 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
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


