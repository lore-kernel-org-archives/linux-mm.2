Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1218FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0EC6B009E; Tue,  5 May 2026 11:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82166B009F; Tue,  5 May 2026 11:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE9F6B00A1; Tue,  5 May 2026 11:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 976506B009E
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52CCB120462
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:11 +0000 (UTC)
X-FDA: 84733774902.28.5479A3C
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 74DE1C0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vw9Rfmmg;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uq6RStVYG/AZxKiwJHi2taHWJECHTirH9n/mFE+40q0=;
	b=8bc7tN753+nJlVhY8bGwce2jPQKkmpPYWNiV+C59WvT4zq4Yx01IUyF4CUtzzD+0qM3060
	oL3meBzJunDEYBwOswrDYG/eeKt+dcm/x8bX4jPgUwYBI57F3VMPgu31EyMYODpzhIh87K
	vKTaz9rSJCbWhToMZop6OrArPBlciqg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vw9Rfmmg;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995549; a=rsa-sha256;
	cv=none;
	b=xeOkRLGTb9u8hii2iAQy0ugkWB3hOkQlxQAq78hiKd0CzKUsGRQTrDOMhtN1gl3p0U+LyH
	fklNbxg+p8bd1A4mkJtDBl7HiYjWWV6WrdK4Ja3cAfdaAm47XePrnQqLx+NjB09KYfftqy
	XpY0JqGPzo+6C6xVjYcW2HD6zLVBZ24=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7de7dc85b74so4875977a34.2
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995548; x=1778600348; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uq6RStVYG/AZxKiwJHi2taHWJECHTirH9n/mFE+40q0=;
        b=Vw9RfmmgGxHi4Sli4Mexuw8bBjS7prwjdDedyqwYMzuMVVOIK0UP3r13QdX6QfaQO0
         6DV11etEJ1oNvAig6fxmYT1hWmSsnVleP4AJrQ0AxhHDmVAHOtNTqi+H0Ek9vDc1vFhd
         fjzi0bdO+WaWqFr1hALQzwP5ZhjpKokMkgt9spm2K4JGRbQRvptv6sKidB+wib7i/or4
         6qtf82fQIcQppZrULav7XnbOYs8X6Gs2yz/rdNECYxmaFYrCPxO+o7/rkK32ZksyCBSE
         XVeQom2TsHRcxOxsFH6iXirlBVRhJSxSR8YqneNLzBSqb00RSxA+3IJmOSu5YN71BDfl
         aCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995548; x=1778600348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uq6RStVYG/AZxKiwJHi2taHWJECHTirH9n/mFE+40q0=;
        b=dOTXgCzlCZHsAw+yAkb9yxMauYEeRu+lS+CO+PPBYyiIK/t8wwhRwxb2rVDRKtjKtY
         4hwtbSqlBem8IOmLDJV2ybqbEMknxOFd1nrL6IfNuY1gQATRmdphOznqoy6bwECs6Q2f
         lkwK2llksmQYRKNscS9UAx9gwTheoeFVUdfg92egxxaWX8WMtg7+c8+Wp3YjA9YjPeRy
         HV3Jh+9OGmhajTv4PMQaA7g/KQ+q8aSQLgSfjrVuA6O259NjTFtOeaQe6KhmSv1Bjw68
         ZD1WE051bRVYcb3VYW5F3ucaYMGJ4HT34rPtFraemR1yjOGOaiAx3l8hej7220dZurVF
         5dtw==
X-Forwarded-Encrypted: i=1; AFNElJ8Xo0/JP4zIjxhmb0Ij23kJozT/MMCSFD640ahldEGUoh67RBxIshIHE0o/ZWDev3Fi4MRLsU6EXA==@kvack.org
X-Gm-Message-State: AOJu0YwNhqCXUc4FgYPNVrIHPpQhqfvF5jBfFC4R1dhH2yWspK+0Rhx3
	RYgINPs8Eg1zVz2jI2XnkHKglThUxFiy/2yoEMIhu1zq0E4KaLCegODT
X-Gm-Gg: AeBDies4Kypcdvh2wQl3P6/DduVGTpdmMrZ4AiJPm05Na3iyysrtXXQP7QdonQ/L7eC
	U5SjyQHteDtETpfg4X1Q54AOrknaiIag/sUGGfcfce3/vN2nJ0xPPywXyekXLI9f4ObUrBsogMu
	y2KG20F0iBR7idOVJ/qhxHTFbtj39m2XReG9bugUiwJDA7tmDMTZJowIWsHLnnNr+xGDmN5AF7u
	hR9xaUrAmhdpM3MS+VXCo+75zsZHcQn5SvB802LZ1Ov55d1rzoKKxhKGfuFIkOIVYFpybKOoy1z
	tJPOsxFfHz5NyHztGJmED3ivxyof1Wm0jrV5RA915vP3mmj+rQyuDNtT8DJGQX7sGHTs5Ugs8Kn
	4kwfngs/xebx2dncJU5Apad8XHJSd6EPPZ+2+GePRnAVNqcFwKriVCy15sqBu04DbMJoHlE7a4/
	gbdSLNngtdSfAqMLdWgouqgs9i9LZgldyx/73DI5lHCk9vg8rwxnmN8bCr
X-Received: by 2002:a05:6830:2690:b0:7d9:b338:a695 with SMTP id 46e09a7af769-7dee11f9cacmr8510809a34.5.1777995548342;
        Tue, 05 May 2026 08:39:08 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7deca7f46e7sm10930497a34.8.2026.05.05.08.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:07 -0700 (PDT)
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
Subject: [PATCH v6 05/22] mm/swap: add a new function to check if a swap entry is in swap cached.
Date: Tue,  5 May 2026 08:38:34 -0700
Message-ID: <20260505153854.1612033-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9a3ejn397jdix485dw1waxj3ykjp6aiw
X-Rspamd-Queue-Id: 74DE1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777995549-760242
X-HE-Meta: U2FsdGVkX19LfsUaUm0GjWUpEKX9CpQo3UvAipMnP/0iQaIfO07me8GXHvf2fZ8yFY2UXiVEfq8xLdJzlvFvHSVQN7Z1NsyDPgOEAXsvtM4VL5pRkazPOY5w6DolwP41FBAnQ5nqvJaYJrQ4CC453jb0yQrm2Q2f2kT2eKuyREraBkiZIeY2ZqlfDNlF/n8U4WUneRDU/l88dJBAHbAPz0I3cYhrEUzEBlTXJpFo4OY65eQPyMkJrDgaqZKDa/9UHSoInnCGJgelNgmRQ6OUvtJSELp79z/WQ7Tfp48jvY7MPiYWRaV3+aNDt0nbK1OkeIXvVC/hqw2XePgK2w+g9g7AQrhai47/V5RGmwa9OvRTh1rKS481FPBE6EBzItZksEG5ai71FI4LJOQcLOtvbUOcjtqcTnIXBSLbR0TAc+LJVjLVe/QCuTWIt3j+V1vzLGPRKvNGL7E+a900poytzLsFbyRZ31V0xsbV2yHq6GGfDEroNn/v/BfwxtCEc48kfqhhf2kAqQLQT27b19jICuETSczHm/L0lGCre6a6fxxJGQorc4IILAZ4RHVgJ6EQ9sGsR5pNK0cHGHCm1qvbxWtAseoOpg03s01ZcJX79ulQLYIH8C8293Ty+EZlPgs0rf3DKIwQo4KT8UYbRL9YnR98deZy/tERho9wUitSylOvO6REr9sZ+6BsgGyrLfxrwFI4zAB41A50beZcrESPbBTat3040WOGb/I2ikX8bVnl7+XxFUt47wxFR7fvYPR2OG/T9CBHQ/UizNNfkdV4qsm8dW10WHDmfXY9tjx6t6s5w+uNtijxjO5OCpPycxlDMi2AVxLd/PlrACkoqrl8d9ZYdQzrUKtrJHktF7b3/MUALLGGU1aZbyQm5oz8Gkivag38T/5JYoUx6WtQ2I2kzuqmU3qLpoBnDMSkVMEr/KnZRpC1MAZBza2oxV92U6XkS/YsilfRJ7ynUsbgDjd
 wzfumBVV
 wpH6SIPob+c5Hv6nAooFzPHwEmfa/WyYFcHyHw7R7DNNaheyqhrfL9kBDmPeGsxkqMkpqyiav3mzc5Q4z2+M0EJJdmo05A1TAJvPPpq8hbG1danZfiRCn7TILMDeg6k8uq3WfLcEuiDwHTaiXHfBH7a1/X83hfLRNt2Jt83NH7BvbcX6IBy2IqO/mK0eZtlS2BsLoWYChiHa+knAwu+DCrQjAjPo5R8MSgO/yY+GqGhz3p9atSvYhl6RHpswzMbc/iGcjMy2PstdfgI9e7HlE9pwRvMGXYkM0nyljtTbBI4mRnjoTsOU6fNoaowstkHEpav5Ub3J8C1XBczkTNR/kCu3UHDZ73vnrPFrM/gq9+dtaN0NGR7/49oWw8pSk+3LVRclQFMBWonPgaBw4dXyxzCYn5QaxKPAWyuYgLzHITUS/Rx17NsH4PLOT23pqd+FZopSZJJKgR+KROWVzEG8SW4yXS2iiG5nvvmyAaq4VaHvV5FgoWih4Wqr6bAfpKkrFasb2U61BXY9mNFHjnwj3wh+V8xcYUJkJZgN8HSJK5ePX4OWTMlka9jJmOvnWkmaWz4eWjlmdopWWxu7a/C1kFtGAtfwCjrKVNLWP
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
index 3da637b218ba..f91a442ac0e8 100644
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
index 46da28c533bb..0471a965f222 100644
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
index 25f89eba0438..98be764fb3ec 100644
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


