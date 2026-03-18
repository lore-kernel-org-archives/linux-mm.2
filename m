Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7DC61088E48
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575816B0352; Wed, 18 Mar 2026 18:30:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460CC6B0354; Wed, 18 Mar 2026 18:30:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E416B0355; Wed, 18 Mar 2026 18:30:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07BAD6B0352
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C70B51B6F94
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:06 +0000 (UTC)
X-FDA: 84560628012.05.68CAEDE
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id EBD2940012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dv36+IVe;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2la7S1lv8SZ13es345xjBt9aiwYWClPAry0jC6dTWYc=;
	b=KodaouJttsNtuFNx1V4NYYEvqExDjLr4G/JgdAm6ACXMwvva6loSer3Av8cfBGK3/eCZD4
	+GFs7elfHDUdjd2EB8GWQgpdvUW8qe+vtJdL9GVcRzVMnqn0PrDFtMkloumIY75bUbQPLL
	ul9Da0I+UNFsQwAprSieB50MUYUjnBQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dv36+IVe;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873005; a=rsa-sha256;
	cv=none;
	b=sjD7kHEjwLGHhB1KReh1SRtb1uIW3CDf15XyQGJeO6TaOjr77++F+qiPClWHxiC58tHELZ
	H3YUVH3pfGS8x1IobFpWs0wwujdV6y4OR2oxJCg2Xbgkg/mAi6MgL5+NYO42S1xD1CdkJf
	GQPpR5VOayfb0m5cXj5Q4eHSCcgKefk=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d743cd9e5bso238398a34.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873004; x=1774477804; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2la7S1lv8SZ13es345xjBt9aiwYWClPAry0jC6dTWYc=;
        b=Dv36+IVe3La/oriCIsRzysoXX07CnpPxgAW5SY34+ZdPpFdiOXmumLVh8o4bP0ueXp
         zf89QQc0rkRb1+pNCSaZ81bDOB40O4O5du6aliJsehDpJBVVLec7mhoK/OhZMLke1Ja4
         vHkP5WTmohgrZoH+iaFBcHmgOyjCkbG/uZOoo/t0OfjPh9bqWehFIlcW5sOxIawjqS2H
         C5OdRjptuZdk6wxp0DStVYt8GJLg6FrQhcjYOmsQ+sR8c4G08hHQAupC4/udFqk0/flZ
         is4Q9jRpUUWbZ0gvPyROpmKG1sg/0JC1DxiWwlOgipfY6a3wIP1+nN1zW0f4xruJ4laG
         NZjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873004; x=1774477804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2la7S1lv8SZ13es345xjBt9aiwYWClPAry0jC6dTWYc=;
        b=Vn2xUWJxKxtNq202ikZwB4QnNzBBgJcMRVRCcH14UDKVTb7fshEiWon4hAzGol7H9k
         hmNiA4GyRFxjQp7S2wRXOtj1YUExN4RnP/5HiL3eBUsg+wpYeWbXXe0JcRFIBdeo3b91
         0+CQ/SjwT2OnaL3IKs6WO4EooYi0/y/SvUtKZcSoDSmtWpqDxotToIwHBnHv+7W6LZ2z
         p5PuttvNDTw+FWWhMlwl2Lcng5ymYPBtGJfl8KjyOY4CB4M+biKCC1pQ4DW5Y2k0qoRL
         fm5Nh4k22CXsPew9jXduuIS3c3uuoQyht6E5sWn8FHlypqT/alu06MXcZuvZRBUe95Qy
         1nBA==
X-Forwarded-Encrypted: i=1; AJvYcCVNQ2llz3gnPCiBmV7ykNlWp6ezhCA8AdV9wKNPWO4YqL/VELr+uIvAsri/Sbh2aCx2r0IJJNfH7A==@kvack.org
X-Gm-Message-State: AOJu0YzbRdSo8QyxXHUKNZbXiwdyZSsrLgiwY9u9bAeXtggXDpfIi8AG
	E1FO4190WACGXAL1f55P/RCie71qM8cZobF+ZUZFBTS+DcympvsUNUkk
X-Gm-Gg: ATEYQzw6++O8qiWbp/iVHpcK+z0JQr3IpkZW0zu6mKjfICq3U1r+BWWvuhWe53Rfu2C
	y0yjQRTXL/0uwWQ19IPM5oFLBdojXDBd6KO+iR4uxj5RqBoTmok2Y8Gl7UkBePslfw6keH8YRx0
	HouaqzVyBAGzWhFUN/+jDPqQ2O+xk1fOlc6SC4xIY2759jARxZYy00Q/n7OJowK1KazH8lkfMqg
	9g9str7lQ9GkyicebzMMFaadMt8xKN5cGehBH1MSDyUukvDB/EputEUITo1Js52YdFKo4uUSUlj
	2E1WktfRpR34g93WG0u8LuCK7+Zu0rpSgX/op4cfRkXaZr9Y9KUmApEuBZHl/udMe8cz+CLfgie
	BBw9vdikSFOqX8B7SFAln7FKqnqqSp4/p5z/2QCYhb+ib5POkcA24HP2cJ3IhjUHBQ0kBJ3X7vF
	K08T+YwZGl2XBaBVgwY9XDkWmAtTI0MV6rkqmbxVE/scW4
X-Received: by 2002:a05:6830:498b:b0:7d4:96c3:3f97 with SMTP id 46e09a7af769-7d7ca566cf8mr3460497a34.2.1773873003460;
        Wed, 18 Mar 2026 15:30:03 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:6::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7c9be847fsm3020992a34.27.2026.03.18.15.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:02 -0700 (PDT)
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
Subject: [PATCH v4 05/21] mm/swap: add a new function to check if a swap entry is in swap cached.
Date: Wed, 18 Mar 2026 15:29:36 -0700
Message-ID: <20260318222953.441758-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EBD2940012
X-Rspamd-Server: rspam07
X-Stat-Signature: jpsjse8zx6xsn5xw3rgpwrch7q7mtym1
X-Rspam-User: 
X-HE-Tag: 1773873004-336631
X-HE-Meta: U2FsdGVkX1/bqZhjKmue7r8kQJg99vfXu4a2Zm+oomAK8BoUFIaAH6W55Qk3PLZ/iC5FVBdjXBw5RrEH/ssNnz8+F/nF7zST2oXnmowsAOMT7zDDE6aNpcgAIZZpQkoGkg9IEAKDKqa0xo+JihtMD5vryIFB5LAKvM38FaqRFgkpYS8F+NqBJ0WU/VWCcW0SNjKOmdbcsIh1K7jy3Ia9qnYXTWZNqJ0Bo2j28WF4EYo/SAzHeXapgI5fnaaIPJmna+g8ePyWNgCKGK7KcvZV51FGCcnx6F/dgOvTLkVr+JOcxZ3xJ8TuhLADEkrGtWjxDclWBRf2Gwkn/xp1cD9aWT3YIutEqUVuMyzefJ5k9O1xZG3rYwu6xZXTrdZ7wlyz8K3Sv/wmSnpOrVsmsCFJaO7bTrAZBiBDCN3EkNhNtiX8RwgaMrzw5aZS5YGtao25CdjXEBlXpI1G64bsZrX1YrKuXZX2Pv2hreSMOBY93PBXKmVUnnCMje1Q89zVSoDPytNWxp64rtabkMBLrmXcvppq/FPiEO0EdxUWc6dWTrhQwvGC0zU6k27ua1MX6VwOoep/PUJwErR4wARqA54hI5rJFNFeXhNGpR5lIM4leccIHwlVnyv9CVB15HQuWiApcQEVsRWMpXONpjJhZIfcgGsaocoyb8nmBE5tCMG1w7Q02OIFg1vhtQmp+kWdJRxeiorE/Lj8vMIWsxsOCPGr2URR1QkZYnNDXaHXOv5lC7sTY0oqntycqfSs4TaYLK1HwvSHKOZ2ctuT1ByEh5NsHAjqmt8qBO8LoOGZU3aFm2d5rRMnhLSWFZJd805suCkTS1Snd1dOnQQFHDA3HueLWk2MoNf1vfZIyt7QH91qsNDSGfI4tm6RE+vfSstQT1a0ydMmMtIfwKplIHrPTXA2SBRQPVWL/JNxk9ntxau4W6o3/0Uxw27fJ8gSWzD0TB++kQd1aJn+DxBGKJmsF/F
 okXvAsfM
 CBVUyaXWtKIHGWtVUnC8c3LImxTQgWoVUHhtUh+DFuBBdk2ifPfIgQPMLG8fcaJxvSEWzwhqytnC/7tkm3rvF9oqxi4Iv9lM56Av/hebFQxiifZxJedLXaYUkrkunTqdEN0bjfYLb7EQAaJPrR1T21Ux1CSQsxkXO2yd0pW7xTjvYAeOICqavUcetfTi0KPBxm8NRxX1Zq/nfe1oCbInjvjx+PJ+voYWaF1a6U828e7UOPh7cD/M1azmq+Z3BWPLJwg8CfQt4hVXWVGs9OFCvpgrAjbDLq/MGhGiBJ8k8Ax+86MSW4LCpHBt1sH6stGcZxdMG//Co/1TMdyi3kzHJj9hBlFQ/EqH4SqrfDtzJxlAXa3Xl/VIhGNpEnPtD8PBRL5Ji/zd5iVb32NrzwxhpNDkPnMwpA8FLTedCmskrggMUfkdX0BcnkJo8RfbaawxJd/gtFiA1KsBE/WVyNLvjyu0VB7waUUPYPorDfAvs52r35IH4ML1fZsFSpEBIw200JjyLGlsbyM1t0bGh94Im/FM/vYeBc8EVDxGdPpECu4MkSsI9BANZLhNHzJeklBrgcbwKSBBwbH/EmqvKWFjn8/Sl3XalE9BCUd/7
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
index 46da28c533bbe..0471a965f222b 100644
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
2.52.0


