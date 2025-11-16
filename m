Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DAFDCD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6379C8E0023; Sun, 16 Nov 2025 13:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7FB8E0005; Sun, 16 Nov 2025 13:12:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0608E0023; Sun, 16 Nov 2025 13:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3433B8E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:12:51 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07DAA8A02A
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:51 +0000 (UTC)
X-FDA: 84117266142.28.1D4B10B
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0A349A0012
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DnnwEJ46;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316769; a=rsa-sha256;
	cv=none;
	b=qTJSrNXEUcLtH3rPj5bT/e3BSBsUR1gYFgjsNtTQn2R4N7KV3ulj5MeesjJYdbHBXPn/X+
	UaEhE7kE7AK1PgPtZTH3jMrF1zkW3yux3tbNeKCAfhyEsRUAjbDDVImQ3mCax6wl2N1agl
	s/pIf+IMMJ+9EDIneKO+xLdh8pWgv74=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DnnwEJ46;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7cVKpKHZH//zr8S57LiQqEN2eoJht/6Q46RrkqejeE=;
	b=ykTQ7MSjd0TOhC96uoLWpjYF02lgasD31Qae+NGwVku/iB0FT78y9EduZ283hpHOCJjGJ5
	AelFzf1lrj2t+i/YDlE8wkD0lhAaCk81RnqZ28thsXT+FUHXa0rMXgsaZhGXPcwGi6FL5S
	cbBVtg1qO8hcBGIypbfP+EFE0TM6JTo=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b2dec4d115so107762985a.0
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316768; x=1763921568; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q7cVKpKHZH//zr8S57LiQqEN2eoJht/6Q46RrkqejeE=;
        b=DnnwEJ460twK0x6HclAdowgar9G7k//WcM4hhtX8GSdETnKXTIIu5E/celwSoXVLhL
         YOhzgJe8iG/zbNfZTYzKEoULrMZ8BZWg37vLp0EQsHHNeybsBF9Fq7RaEWQvSpUY8HPx
         +61Tq7vZxHPTG1dk+JzcUIh+lRd10VjiAOXu54bVWJq8lFF7VSmhR0HbPBakI+mXb2T+
         D987yEpN8zCRvq9nxY5OaJ1ZJkeYOSYyhUseUvi6/YUtBF1+loFsJMKf9DobfJKQzfsB
         MsqQXvofSLDqCz5i1Q9iklb9g04Nwh1r/MXW2HPurDMlPlbbYu00KcYo378DrL+NFFEz
         YruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316768; x=1763921568;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q7cVKpKHZH//zr8S57LiQqEN2eoJht/6Q46RrkqejeE=;
        b=feVqVZfT+R+b/4aSc+LY3DmCgl79plUVlaY2Mlci973+9Pt2d+SE3cleFeVq2HKqkn
         fm9RCIgn3g9dxnF/yNp6G7Z034i2JOnIGrqQuAUqPgtFMWQDWTqPGbVNZG/SjmSI+HIx
         NzPO0GOTDLf+/W6VdkthOwGQVQQiYJ8Nxudq2OF2gwCFLWKv4U+WH8GTff7+RNi1vS+W
         MMtKhWse4u785QbZO2KTXnZXQKrr3M2idwuQHz8e0PK/USTcwepGiI9Zqe9WmSKYgIN0
         vO0RVnCJlIXrw+zaIEDlEIEcXGJUDr+zV8yGYiqh1uV4q3ju8b87IOZphnMNJ4ZoSk9u
         wHGw==
X-Gm-Message-State: AOJu0YwdCYzYkuX7OlfguTPv//L8s3cpPFU8gWXG+syWsdBxCKvhLltT
	hGWnFnRdw/+7o/GB5BmTR3k/fcpOG0R+41X712qyATRfLbJTF2oE2Lwd
X-Gm-Gg: ASbGnctYRFaEqhRs8/1uCVSi5lI5YvEdVS3YCa4OGQFEswewGnn3SfgWSrsbxkITc04
	nkiEvVUQ/fAjfnSf77dLvJLPgycXpE6auMlTvL83yHBrzZPtaj/XFOz86PEYzneXSVPUKb7kMtW
	yiXGMRBJq3AI2ee/Iwlubbd1i/lQ8Lf2qQIvIKQGWsMgkQHJxv3bnRmnGr82VAzV2Fwt/0prMHG
	U+K5Wr+pW43oPIxu7ZYkItYQUmLpAtwNpK/aIfu/PZqz0rZOa55ZL8+TS7On0MI0z9KlUMrDP8H
	h/oKPhdxFn7JjabjUP07bhK5tRa/ZOjZhLuGHZmFkol3cqkt6stYFojNAIh5ZQDJlXZJt2QslPY
	2R63gx10qAiVgTuk8d94pbJkcc++ksJOEDqTJ+W/NYPeSWWXx8kK09GyAvohWXIhp/fD58dDpLR
	0BgRLF3hCBHQEN3DXpxOfUjXmWAwU5aWUEMNhSRN/MNw==
X-Google-Smtp-Source: AGHT+IGUrKl+PzZ0iZ4xoM4cTBU/LuuyfiZTHx/WuGLuLNWgLxgoroAzxxcfWBHeqXQPGrcdxLF5iQ==
X-Received: by 2002:a05:620a:1a02:b0:8b2:e924:4db7 with SMTP id af79cd13be357-8b2e924588emr238474985a.40.1763316768083;
        Sun, 16 Nov 2025 10:12:48 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:12:47 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:49 +0800
Subject: [PATCH v2 08/19] mm/shmem, swap: remove SWAP_MAP_SHMEM
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-8-37730e6ea6d5@tencent.com>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=7126;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=dny+SXWuyE8K8IiOt2sIszvBbGvpqP/hk6etEBD5hKg=;
 b=fV49ZBo98ttH/vcQHSgk1G7A+xp6sTNohz8hLqQKodxZHVkd6sIjzP90SLf+Fx591oGAtVZQ/
 xppHv2AvP0VCwBuc/2MuqSCo0w8KO7WyaIl7VrHNfunmODkQu/auvAa
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 0A349A0012
X-Rspamd-Server: rspam07
X-Stat-Signature: 8eib7rdrseanmadpgktpdjs69uxpmoj9
X-Rspam-User: 
X-HE-Tag: 1763316768-518108
X-HE-Meta: U2FsdGVkX18G2Itdr+xEQuqqGY8nz6g3hbweutzxCHoAutoILKMqqA4SplM863D44A6nhagGsJmCQwTa4IjYTGXr/h8aNSlfUc88kh83Bj1EiY+KE1V8eYtAC3hiYSY5nUFvbl7iJ52Qx2OaT68yQvWZFRDXUJsjt2JutHxqltKHsLiG1XFbnkHvdVpoXYnbEczeP+XTqsUK1DqJuiuME+wTnfictSKonqUsK9N+Kx9HWkiyP00QRQ7F6O19435YaNN7wVHzz+fJFT/llK0uwueDieN+U0d6Y0BpuBidShyHJKF346Ki80R7O324w563/VnZLsdftaAeyMFwUN/b8SOIA/wGili++sn8RWEPs784FkDN1ZFsipdRPimejo7YCWkQpdIPMinQwHyMIZri9Fjc5laCxXxr+G2r8UcrRjN7NZgFyBDvwyWUzxx10YnGY1fM85qAPLNO1ICPSA8PKhLHvYbVjaV2O9p/iXfKCd6csT7T9KL62wnQSF2xd+IR27vfUPWKqx1t6OBp+KMQgEdBYWN6C/5g6I2ZGlyF0KCrr3egiqeKNcpvyt8Chc1ZtQ5PY2ZTNVtEH4Ij3XUvCELmFax+rj5eas1eout8zIO44wcufd0fr9QrCLYMfwet50ibqepvkt3n/bgUFyrt/WGcvxnZ6QNJcHm4TnH/nhHEodLhp4rRy6oo/HIRoFkgC870za7dHI8oKqlxHr1kNpd5s1Rwfcj54FO6roC8dlp/zZlAU62kMlZebPEmJPTAHE8p9lgNMcdJEMqNonyXFF3MNhbfthMACcPJDu411XmDiQa1wSmIDVixpr2RPKlZvCuHyyn58rEUi++BylKhg6s9J3PqlNB9Z9l1EyexDyqL3Qnl1738il3QVTKJja8t1Iu4QBe3gT3hP3Nmfmv090LFDbI/2y7uAnL31j62qpeLABOiN118NkuYg9Rphx3esUyqp4Fp7w/nUIm5uFP
 fuS3zJn0
 DBusJfn38g88jZpMPTGNX+VXyikKhjMlmvKUtdTbeJf2BKMwd5ahXjCvvmMrNxLZ6ZuAt34BkcbZD/T0zn/VPObtaguilROsGexEMIVWsbd8mYobZ4b11FI1zC/bGWy/xp2DQRZ+/oxNLToBGR5vUOvTXC5s61njUdy9FoODJswMIpqmaZBI/dvPVMlab14GH+qD6z5vF0OflGbyklENc1Sjz0BRADq/uW+LZPT+7hI3uHCfdzOyPjZoBC5SfBXwzGm5UOGko57e8mosdpHzfh57Vh2m2INuKyDa1PW08RGSfOje0Z6tiHXBPSmXnn4cSkY6a0WtqdJa7hvmXD42YQevElX6+g4PYmSNKMBZWO2SwFZMMUEGxaSC2XITqSy6ZhwYflyZKebhbNymx/edviXE6vTkS1c/zyavZSXITHCWmtQJs4SXG+SFtpxVMn0tgDkZdeioz58Y3288=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nhat Pham <nphamcs@gmail.com>

The SWAP_MAP_SHMEM state was introduced in the commit aaa468653b4a
("swap_info: note SWAP_MAP_SHMEM"), to quickly determine if a swap entry
belongs to shmem during swapoff.

However, swapoff has since been rewritten in the commit b56a2d8af914
("mm: rid swapoff of quadratic complexity"). Now having swap count ==
SWAP_MAP_SHMEM value is basically the same as having swap count == 1,
and swap_shmem_alloc() behaves analogously to swap_duplicate(). The only
difference of note is that swap_shmem_alloc() does not check for
-ENOMEM returned from __swap_duplicate(), but it is OK because shmem
never re-duplicates any swap entry it owns. This will stil be safe if we
use (batched) swap_duplicate() instead.

This commit adds swap_duplicate_nr(), the batched variant of
swap_duplicate(), and removes the SWAP_MAP_SHMEM state and the
associated swap_shmem_alloc() helper to simplify the state machine (both
mentally and in terms of actual code). We will also have an extra
state/special value that can be repurposed (for swap entries that never
gets re-duplicated).

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h | 15 +++++++--------
 mm/shmem.c           |  2 +-
 mm/swapfile.c        | 42 +++++++++++++++++-------------------------
 3 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df68716..bf72b548a96d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -230,7 +230,6 @@ enum {
 /* Special value in first swap_map */
 #define SWAP_MAP_MAX	0x3e	/* Max count */
 #define SWAP_MAP_BAD	0x3f	/* Note page is bad */
-#define SWAP_MAP_SHMEM	0xbf	/* Owned by shmem/tmpfs */
 
 /* Special value in each swap_map continuation */
 #define SWAP_CONT_MAX	0x7f	/* Max count */
@@ -458,8 +457,7 @@ bool folio_free_swap(struct folio *folio);
 void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
-extern void swap_shmem_alloc(swp_entry_t, int);
-extern int swap_duplicate(swp_entry_t);
+extern int swap_duplicate_nr(swp_entry_t entry, int nr);
 extern int swapcache_prepare(swp_entry_t entry, int nr);
 extern void swap_free_nr(swp_entry_t entry, int nr_pages);
 extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
@@ -514,11 +512,7 @@ static inline int add_swap_count_continuation(swp_entry_t swp, gfp_t gfp_mask)
 	return 0;
 }
 
-static inline void swap_shmem_alloc(swp_entry_t swp, int nr)
-{
-}
-
-static inline int swap_duplicate(swp_entry_t swp)
+static inline int swap_duplicate_nr(swp_entry_t swp, int nr_pages)
 {
 	return 0;
 }
@@ -569,6 +563,11 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
 }
 #endif /* CONFIG_SWAP */
 
+static inline int swap_duplicate(swp_entry_t entry)
+{
+	return swap_duplicate_nr(entry, 1);
+}
+
 static inline void free_swap_and_cache(swp_entry_t entry)
 {
 	free_swap_and_cache_nr(entry, 1);
diff --git a/mm/shmem.c b/mm/shmem.c
index 8b711b8bcdba..0b0af71ce5e8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1654,7 +1654,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
-		swap_shmem_alloc(folio->swap, nr_pages);
+		swap_duplicate_nr(folio->swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a433445e9225..580adf9d93bd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -201,7 +201,7 @@ static bool swap_is_last_map(struct swap_info_struct *si,
 	unsigned char *map_end = map + nr_pages;
 	unsigned char count = *map;
 
-	if (swap_count(count) != 1 && swap_count(count) != SWAP_MAP_SHMEM)
+	if (swap_count(count) != 1)
 		return false;
 
 	while (++map < map_end) {
@@ -1522,12 +1522,6 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
 	if (usage == SWAP_HAS_CACHE) {
 		VM_BUG_ON(!has_cache);
 		has_cache = 0;
-	} else if (count == SWAP_MAP_SHMEM) {
-		/*
-		 * Or we could insist on shmem.c using a special
-		 * swap_shmem_free() and free_shmem_swap_and_cache()...
-		 */
-		count = 0;
 	} else if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
 		if (count == COUNT_CONTINUED) {
 			if (swap_count_continued(si, offset, count))
@@ -1625,7 +1619,7 @@ static bool swap_entries_put_map(struct swap_info_struct *si,
 	if (nr <= 1)
 		goto fallback;
 	count = swap_count(data_race(si->swap_map[offset]));
-	if (count != 1 && count != SWAP_MAP_SHMEM)
+	if (count != 1)
 		goto fallback;
 
 	ci = swap_cluster_lock(si, offset);
@@ -1679,12 +1673,10 @@ static bool swap_entries_put_map_nr(struct swap_info_struct *si,
 
 /*
  * Check if it's the last ref of swap entry in the freeing path.
- * Qualified value includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
  */
 static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
 {
-	return (count == SWAP_HAS_CACHE) || (count == 1) ||
-	       (count == SWAP_MAP_SHMEM);
+	return (count == SWAP_HAS_CACHE) || (count == 1);
 }
 
 /*
@@ -3678,7 +3670,6 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-	VM_WARN_ON(usage == 1 && nr > 1);
 	ci = swap_cluster_lock(si, offset);
 
 	err = 0;
@@ -3738,27 +3729,28 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 	return err;
 }
 
-/*
- * Help swapoff by noting that swap entry belongs to shmem/tmpfs
- * (in which case its reference count is never incremented).
- */
-void swap_shmem_alloc(swp_entry_t entry, int nr)
-{
-	__swap_duplicate(entry, SWAP_MAP_SHMEM, nr);
-}
-
-/*
- * Increase reference count of swap entry by 1.
+/**
+ * swap_duplicate_nr() - Increase reference count of nr contiguous swap entries
+ *                       by 1.
+ *
+ * @entry: first swap entry from which we want to increase the refcount.
+ * @nr: Number of entries in range.
+ *
  * Returns 0 for success, or -ENOMEM if a swap_count_continuation is required
  * but could not be atomically allocated.  Returns 0, just as if it succeeded,
  * if __swap_duplicate() fails for another reason (-EINVAL or -ENOENT), which
  * might occur if a page table entry has got corrupted.
+ *
+ * Note that we are currently not handling the case where nr > 1 and we need to
+ * add swap count continuation. This is OK, because no such user exists - shmem
+ * is the only user that can pass nr > 1, and it never re-duplicates any swap
+ * entry it owns.
  */
-int swap_duplicate(swp_entry_t entry)
+int swap_duplicate_nr(swp_entry_t entry, int nr)
 {
 	int err = 0;
 
-	while (!err && __swap_duplicate(entry, 1, 1) == -ENOMEM)
+	while (!err && __swap_duplicate(entry, 1, nr) == -ENOMEM)
 		err = add_swap_count_continuation(entry, GFP_ATOMIC);
 	return err;
 }

-- 
2.51.2


