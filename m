Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B046ACD6E45
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 21:30:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527DF6B0095; Thu, 28 May 2026 17:30:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FEF76B0098; Thu, 28 May 2026 17:30:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378B06B0099; Thu, 28 May 2026 17:30:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB666B0095
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:30:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DBD101A097B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:30:05 +0000 (UTC)
X-FDA: 84818121570.09.995977F
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id C956180008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:30:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KMGJ5mXR;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780003803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HPWXw9VKiy+aaD0c55tVeHWQbTXncnbogrmXqQQheo=;
	b=llwyzQikz10mu80FB+/s6ZHzMSymjSKQ3+QnP1R0c67ifUk52jKF4P31XA8uuzffsi0Lyi
	vHzkejy1FBzKhLUPgvD2DJ+77YH6nbWt00gyq8uDolYXttAlDvB2LZAU5IBQMkGISVRuzu
	5TBeWjlFFpUdiUs3W//l9oU4X67yODI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KMGJ5mXR;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780003803; a=rsa-sha256;
	cv=none;
	b=hzDg//etSfUDTrIo90200oHk5/FR5Tt/xAH7zgmcrIQB4zrui6K1CIYUAmLWwEZPmJS4yi
	2wzUvGaEdB9cnjVgWi67SisFt01ncCI8BK6JJHBnM7wu6fRt3FRho5R6MU+z+ahTJ7pAty
	d5y72SeqEJ5LD50kzFCLobJ111xfW1Y=
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-48543ae6e39so4310177b6e.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 14:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780003803; x=1780608603; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1HPWXw9VKiy+aaD0c55tVeHWQbTXncnbogrmXqQQheo=;
        b=KMGJ5mXRvh8o4Sb4RvFnu6Q4i/IqWHE5lY+YqqIAtHRrmihxsqZq3ykUVqi058Ql/y
         hT34Z3CLyYEjblM1JQEhd2FrZR0yH2fzOgAtG/hvB10tJmk9FiojRB+/AyD8BUHFnCum
         rTRlPDtWLIKZES5dHw1kTgZLDWeXN5NgsDFq4PA+vWKVzUZzSKZu/cA8EZsbbrh/BAhl
         aUxi60qZzhLp3yRyqS0yqHCIm3yWqrru43XRNu6mZWqBan6lYd9I8qeSKHPPR/8aFSVF
         jrgUDwTbsGr9LdbuW677N/9VgvMpXVlIaRtRhOhnArugwLS0BBFzqDWJeQFExlRXI3ZN
         vQ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780003803; x=1780608603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1HPWXw9VKiy+aaD0c55tVeHWQbTXncnbogrmXqQQheo=;
        b=glXK2R87ZQZgLBLqu0PPWodiwnmGchiX0nO1CbWa3KkQmMyHZz3nRwn51fIyk2qgcn
         MYDr1zmBQ4wKj9aVAPXiIsiFH+mEvVP/78AtJ2X4YxoFIV0Iq/cyWANSLCyFyk/UfA8w
         G2jQnGwGGcaRcBWQGjeMeYSVFoBPnnwmHGBjZuFt70lpTP7ufMSdMauPdnymE/av+tjY
         34eNT0Ssy0Ot0bFrI32JN2aRTOd6vOlrmFAMA2MRKcpxUV9iAO4gF5Yg9W+WfcyOTAZi
         yo21+YFJDJYyMo/6QCvzmAfC5vjCxg3Zsz9dSwzrobjsQ8gFEIWsEHIy973llyoWacBe
         vy5Q==
X-Forwarded-Encrypted: i=1; AFNElJ871cqKj/uKeEMwr4uzABsAdql/iLIK+DxVLSsaIwnj8G3FLDVuObCoShvxawuznLGAKw7oPXvjlw==@kvack.org
X-Gm-Message-State: AOJu0YyzkjILJSzdpjiDsUlbl9+LvPtefXQ/EN4s2cTC+tf/9V7i9Gzx
	feEPlaVNa/Istw//TpVtNxTNSdQrxN2PPaKDPA8XQnbsbal0FSebi1dy
X-Gm-Gg: Acq92OHhrMt8Gg0ZKi4XuEfbH0OvPRN+HrHtmDzWmloXy6rjzCpQQbpGLajaQUDHM25
	C2JI5rLmxYIPX/kLLZaRTrGtnJWsofcaAf9D4AEdotNHzmV+E8sivNfFLOp75rUpn4S90r1/Ffz
	mYIvbq4qsgVlqCanMvmiXjK9yB1MiGK+nrnSP2q5Ncx42rIA6MsoIMUcgZW0zwiCnWs7G1OxttW
	YuxlMqTzy80DjpWTC2y72I7aMebIrRxc8qJFGF7BSzSHGjBMd1R8w0OOshnCXoNjt+dDjFwD5Hi
	D1ejDP3W6di4YXqgiLDrIjOrDoUiTByyKFDBNchmDoEEBIZmkXU69Nn27yZot9TuCXOY/c9WOYG
	E0kBGmYruLHih4XaiCKsDpu2D2v1FkIevkpEGW3itAIU2QYd75gFmIodso49JbwOfbZChcuze6L
	IZMiWY0xzGYT+7Uxz5v9mOuWTXKkjF93oymiqpbeOimGIXqt4z0F9/Cym+t7L13dxW7Q==
X-Received: by 2002:a05:6808:13cb:b0:47b:c8d0:514a with SMTP id 5614622812f47-485e6e6ccf3mr181931b6e.46.1780003802480;
        Thu, 28 May 2026 14:30:02 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43c8961981bsm131440fac.9.2026.05.28.14.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 14:30:01 -0700 (PDT)
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
Subject: [RFC PATCH 3/5] mm, swap: support physical swap as a vswap backend
Date: Thu, 28 May 2026 14:29:27 -0700
Message-ID: <20260528212955.1912856-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528212955.1912856-1-nphamcs@gmail.com>
References: <20260528212955.1912856-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 7xj49mo1wz8z4pdsy6ep4shf1c77um7h
X-Rspam-User: 
X-Rspamd-Queue-Id: C956180008
X-HE-Tag: 1780003803-449865
X-HE-Meta: U2FsdGVkX18s5X4z81HmAfjb/iR5noxZL8fqLt/jgR3dwvJAsKzq/0Mrtets2hi0o1+eDq0tio/kA1zZ9Veq2HilDpf40Lihp2mntK+5D5bn/YC6wEu3urKscAxV10G8eKOvxiJuPOck29Le5Jw+ICrXiOmYsqyjljA7bUD0p590Sa1hK3W8wznXsm9D/OA871O9i9GSmeWJPNaVsYvgC+6vHUclHt1U6S1l6JFNnEmah6BklHBTCI6x0xH1k/VtMbaNB9A+6TjCaP2JcFbcdbMh4RCWPgD5xAOqluSLf13FA4RjxoySocJ/mPfuJdHuIXiiTMzM+KyXG7aw6KYpXdOC19V/Wgft6wBVf/UoSohgY1mnbwC8xkckdV/FQGcc5l77rPbP5zRORrY3QbvC8LeeYEPFMQ6nErXLO7BLw9wiFkUQrjy66NBjWG/HLNlAtEUwD/hz5Nb6xLx5He40ZSM5BReSoxqmTICBMcBN8ri5vwcbeYWifdI4cmZx36hPQbpHokIOJvcLmF6Pwz9Zx6iSCqk1vaRHfJVgCwWqqJnCMG9Xf2xuXROMu6z92S5TkYCYa7eFE3AYkF/s+Az7Kxf3tdFprqYpVYcjA2QkhPBUkiJ/GBKO10d1eB7x0ZgfeeyJe5qQBP4Yv9MiXr84G9ncIF0320UAW/KaOzqruTLxapBp+qWVPpBmpGNgEUTQqPU0xVV91DoCZ75yvHi6UoezUhCo+htyib3NQtij8YSy3lRjoshUlIakvuoY84q8ngnivu1uoQSJ87a8HPj8q7JUG8a7TlBxAT7JUlT7oERV/oFg/wAIlrgvfHGoQ7hcX+TlnhdHs5cpLFo6MRQpoGIZcSltyv9r06QVK4pw0rjIsgW+gGUwvYxd91OZMO1bjCllmOsZHDLrY5EJPK8QE4qI8zmo7axCJ6hB5WsTEOsaLuErB2P2WVARdEz6kA2I8DcMuuFRzljrbxCy3I3
 tjhoWK+9
 iSlyw5HS/p9YaPCvOryUZoamJDzY2Q2UyiEpWQUr8gvlt/X2EIQCdw/BTgABErP+iR/WSxUfLVAss0w2JDJyi/4/ZfDA06o7V0ZkOHPIwoA/gRAJ/Bek48GgClSBRmz/gtTyVo5UJZ9KAnuyipMVsFvKOes9Mb2b5Os41Br3UmbVe5+CONQBrh/KJyZ3tpPVceeUPkse0aVXfs75qKKHOr3O8M8HvJPjkgvcWd/JL63i+5y9poCgwcvIk90pUwRnmV46PAFF0F9OkmpntHMtFUyzSgp/RC1GXgJkM/snVzLNpS7b4dlqAUq97BwuFdT+YT8mt331RF8W9lfwxGfNV+EgmLna7/98QsrHj8ZORLJJveRPPPYzIvCBbZWbep7FMf26ZrakAbzVfHFXcGuuK66FmlaJX22e6VvkhJi/2mkZWFo1hw1MKiJFoKAJ1KPAAOyas0MoXJaYah+oen5pLubu92Beuhswp/rUkfYJqggeq+fzSPueWZ7fxXuTkVoaeumcBCX28M6aDy5Vfz94e0tVffO7+JrDIQQWfmhIETtedWEWILSwQzDNVlyLXS4l1dh5kNQowJEwMzAX7CLrNUORetPvd6CiUvE1NFz5oLRgl4eURTwrHZTtZGJObX1vFS1yO8ukUNA/vB8/EjG400K/H7s5uM26CYn3DhRyURlF+zeETxhHmjaRovd4/mxDAjM6FzQ9EEltBYdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add physical swap as a backend for the virtual swap layer.
Without this, vswap can only back entries with zswap or zero pages,
and a zswap_store failure has nowhere to fall back to — the page
stays dirty in swap cache (AOP_WRITEPAGE_ACTIVATE).

With physical swap backing, vswap can allocate a physical slot on
demand when needed: as a fallback for zswap_store failures, or as
the destination for zswap writeback.

Each vswap entry's physical slot is tracked via a Pointer-tagged
swap_table entry on the physical cluster (rmap back to the vswap
entry).

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  10 ++
 mm/memcontrol.c      |   8 +-
 mm/memory.c          |  14 +-
 mm/page_io.c         | 130 ++++++++++----
 mm/swap.h            |  11 ++
 mm/swap_table.h      |   1 +
 mm/swapfile.c        | 398 ++++++++++++++++++++++++++++++++++++++++---
 mm/vswap.h           | 138 ++++++++++++++-
 mm/zswap.c           |  79 ++++++---
 9 files changed, 698 insertions(+), 91 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ee9b1e76b058..3fb55485fc76 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -449,6 +449,16 @@ extern int swp_swapcount(swp_entry_t entry);
 struct backing_dev_info;
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
 sector_t swap_folio_sector(struct folio *folio);
+sector_t swap_entry_sector(swp_entry_t entry);
+
+#ifdef CONFIG_VSWAP
+swp_entry_t folio_realloc_swap(struct folio *folio);
+#else
+static inline swp_entry_t folio_realloc_swap(struct folio *folio)
+{
+	return (swp_entry_t){};
+}
+#endif
 
 /*
  * If there is an existing swap slot reference (swap entry) and the caller
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a3ad83c229f7..7492879b3239 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5541,7 +5541,13 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	long nr_swap_pages;
 
-	/* vswap provides unbounded virtual swap when zswap is enabled */
+	/*
+	 * vswap provides unbounded virtual swap when zswap is enabled.
+	 * (No per-memcg may_zswap check — mem_cgroup_may_zswap can sleep
+	 * via __mem_cgroup_flush_stats, but this is callable from
+	 * rcu_read_lock contexts like cachestat(2) → workingset_test_recent.
+	 * The per-memcg swap.max is still enforced at charge time.)
+	 */
 	if (IS_ENABLED(CONFIG_VSWAP) && zswap_is_enabled())
 		return PAGE_COUNTER_MAX;
 
diff --git a/mm/memory.c b/mm/memory.c
index c3050e49b086..d15c748d4f90 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -89,6 +89,7 @@
 #include "pgalloc-track.h"
 #include "internal.h"
 #include "swap.h"
+#include "vswap.h"
 
 #if defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS) && !defined(CONFIG_COMPILE_TEST)
 #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
@@ -4523,7 +4524,14 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 	 * are fast, and meanwhile, swap cache pinning the slot deferring the
 	 * release of metadata or fragmentation is a more critical issue.
 	 */
-	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+	if (swap_entry_backend_has_flag(si, folio->swap, SWP_SYNCHRONOUS_IO))
+		return true;
+	/*
+	 * Non-swapfile backends cannot be reused for future swapouts.
+	 * Free the swap slot unless backed by contiguous physical swap.
+	 */
+	if (swap_is_vswap(si) &&
+	    !vswap_swapfile_backed(folio->swap, folio_nr_pages(folio)))
 		return true;
 	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
@@ -4832,7 +4840,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		swap_update_readahead(folio, vma, vmf->address);
 	if (!folio) {
 		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
-		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		if (swap_entry_backend_has_flag(si, entry, SWP_SYNCHRONOUS_IO))
 			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
 					    thp_swapin_suitable_orders(vmf) | BIT(0),
 					    vmf, NULL, 0);
@@ -5007,7 +5015,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			 */
 			exclusive = true;
 		} else if (exclusive && folio_test_writeback(folio) &&
-			  data_race(si->flags & SWP_STABLE_WRITES)) {
+			  swap_entry_backend_has_flag(si, entry, SWP_STABLE_WRITES)) {
 			/*
 			 * This is tricky: not all swap backends support
 			 * concurrent page modifications while under writeback.
diff --git a/mm/page_io.c b/mm/page_io.c
index b3c7e56c8eed..a65734564819 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -260,6 +260,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
  */
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 {
+	swp_entry_t phys;
 	int ret = 0;
 
 	if (folio_free_swap(folio))
@@ -292,6 +293,12 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 	 */
 	swap_zeromap_folio_clear(folio);
 
+	/*
+	 * For vswap: release stale non-swapfile backends before writeout.
+	 * If already PHYS-backed (contiguous), keep it. Otherwise free old
+	 * backing (e.g. ZSWAP from a previous swapout cycle) and set FOLIO
+	 * so zswap_store or folio_realloc_swap starts clean.
+	 */
 	if (swap_is_vswap(__swap_entry_to_info(folio->swap)))
 		vswap_prepare_writeout(folio->swap, folio);
 
@@ -309,8 +316,19 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 	rcu_read_unlock();
 
 	if (swap_is_vswap(__swap_entry_to_info(folio->swap))) {
-		folio_mark_dirty(folio);
-		return AOP_WRITEPAGE_ACTIVATE;
+		/*
+		 * zswap_store may have partially populated the vtable with
+		 * ZSWAP entries before failing. Reset to FOLIO (freeing
+		 * those partial entries) so folio_realloc_swap can install
+		 * PHYS cleanly without leaking zswap_entry pointers.
+		 */
+		vswap_prepare_writeout(folio->swap, folio);
+		phys = folio_realloc_swap(folio);
+		if (!phys.val) {
+			folio_mark_dirty(folio);
+			return AOP_WRITEPAGE_ACTIVATE;
+		}
+		return __swap_writepage_phys(folio, swap_plug, phys);
 	}
 
 	return __swap_writepage(folio, swap_plug);
@@ -402,12 +420,12 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
+static void swap_writepage_fs(struct folio *folio,
+			      struct swap_info_struct *sis, loff_t pos,
+			      struct swap_iocb **swap_plug)
 {
 	struct swap_iocb *sio = swap_plug ? *swap_plug : NULL;
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct file *swap_file = sis->swap_file;
-	loff_t pos = swap_dev_pos(folio->swap);
 
 	count_swpout_vm_event(folio);
 	folio_start_writeback(folio);
@@ -439,13 +457,13 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 }
 
 static void swap_writepage_bdev_sync(struct folio *folio,
-		struct swap_info_struct *sis)
+		struct swap_info_struct *sis, sector_t sector)
 {
 	struct bio_vec bv;
 	struct bio bio;
 
 	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_WRITE | REQ_SWAP);
-	bio.bi_iter.bi_sector = swap_folio_sector(folio);
+	bio.bi_iter.bi_sector = sector;
 	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
 
 	bio_associate_blkg_from_page(&bio, folio);
@@ -475,6 +493,42 @@ static void swap_writepage_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
+#ifdef CONFIG_VSWAP
+int __swap_writepage_phys(struct folio *folio, struct swap_iocb **swap_plug,
+			  swp_entry_t phys_entry)
+{
+	struct swap_info_struct *sis = __swap_entry_to_info(phys_entry);
+	sector_t sector = swap_entry_sector(phys_entry);
+	struct bio *bio;
+
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON(swap_is_vswap(sis));
+
+	if (data_race(sis->flags & SWP_FS_OPS)) {
+		swap_writepage_fs(folio, sis, swap_dev_pos(phys_entry),
+				  swap_plug);
+		return 0;
+	}
+
+	if (data_race(sis->flags & SWP_SYNCHRONOUS_IO)) {
+		swap_writepage_bdev_sync(folio, sis, sector);
+		return 0;
+	}
+
+	bio = bio_alloc(sis->bdev, 1, REQ_OP_WRITE | REQ_SWAP, GFP_NOIO);
+	bio->bi_iter.bi_sector = sector;
+	bio->bi_end_io = end_swap_bio_write;
+	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
+
+	bio_associate_blkg_from_page(bio, folio);
+	count_swpout_vm_event(folio);
+	folio_start_writeback(folio);
+	folio_unlock(folio);
+	submit_bio(bio);
+	return 0;
+}
+#endif
+
 int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
@@ -493,14 +547,10 @@ int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 	 * is safe.
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
-		swap_writepage_fs(folio, swap_plug);
-	/*
-	 * ->flags can be updated non-atomically,
-	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
-	 * is safe.
-	 */
+		swap_writepage_fs(folio, sis, swap_dev_pos(folio->swap),
+				  swap_plug);
 	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
-		swap_writepage_bdev_sync(folio, sis);
+		swap_writepage_bdev_sync(folio, sis, swap_folio_sector(folio));
 	else
 		swap_writepage_bdev_async(folio, sis);
 	return 0;
@@ -624,11 +674,11 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 	return true;
 }
 
-static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
+static void swap_read_folio_fs(struct folio *folio,
+			       struct swap_info_struct *sis, loff_t pos,
+			       struct swap_iocb **plug)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct swap_iocb *sio = NULL;
-	loff_t pos = swap_dev_pos(folio->swap);
 
 	if (plug)
 		sio = *plug;
@@ -659,13 +709,13 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 }
 
 static void swap_read_folio_bdev_sync(struct folio *folio,
-		struct swap_info_struct *sis)
+		struct swap_info_struct *sis, sector_t sector)
 {
 	struct bio_vec bv;
 	struct bio bio;
 
 	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_READ);
-	bio.bi_iter.bi_sector = swap_folio_sector(folio);
+	bio.bi_iter.bi_sector = sector;
 	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
 	/*
 	 * Keep this task valid during swap readpage because the oom killer may
@@ -681,12 +731,12 @@ static void swap_read_folio_bdev_sync(struct folio *folio,
 }
 
 static void swap_read_folio_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+		struct swap_info_struct *sis, sector_t sector)
 {
 	struct bio *bio;
 
 	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
-	bio->bi_iter.bi_sector = swap_folio_sector(folio);
+	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = end_swap_bio_read;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
 	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
@@ -695,6 +745,22 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
+static void swap_read_folio_phys(struct folio *folio, swp_entry_t phys_entry,
+				struct swap_iocb **plug)
+{
+	struct swap_info_struct *sis = __swap_entry_to_info(phys_entry);
+	sector_t sector = swap_entry_sector(phys_entry);
+
+	zswap_folio_swapin(folio);
+
+	if (data_race(sis->flags & SWP_FS_OPS))
+		swap_read_folio_fs(folio, sis, swap_dev_pos(phys_entry), plug);
+	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
+		swap_read_folio_bdev_sync(folio, sis, sector);
+	else
+		swap_read_folio_bdev_async(folio, sis, sector);
+}
+
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
@@ -702,6 +768,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
 	bool in_thrashing;
+	swp_entry_t phys;
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio) && !synchronous, folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -726,20 +793,15 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	if (zswap_load(folio) != -ENOENT)
 		goto finish;
 
-	if (unlikely(sis->flags & SWP_VSWAP)) {
-		folio_unlock(folio);
-		goto finish;
-	}
-
-	/* We have to read from slower devices. Increase zswap protection. */
-	zswap_folio_swapin(folio);
-
-	if (data_race(sis->flags & SWP_FS_OPS)) {
-		swap_read_folio_fs(folio, plug);
-	} else if (synchronous) {
-		swap_read_folio_bdev_sync(folio, sis);
+	if (swap_is_vswap(sis)) {
+		phys = vswap_to_phys(folio->swap);
+		if (!phys.val) {
+			folio_unlock(folio);
+			goto finish;
+		}
+		swap_read_folio_phys(folio, phys, plug);
 	} else {
-		swap_read_folio_bdev_async(folio, sis);
+		swap_read_folio_phys(folio, folio->swap, plug);
 	}
 
 finish:
diff --git a/mm/swap.h b/mm/swap.h
index 640413e30880..50c90a35382c 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -285,6 +285,17 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
 int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
+#ifdef CONFIG_VSWAP
+int __swap_writepage_phys(struct folio *folio, struct swap_iocb **swap_plug,
+			  swp_entry_t phys_entry);
+#else
+static inline int __swap_writepage_phys(struct folio *folio,
+					struct swap_iocb **swap_plug,
+					swp_entry_t phys_entry)
+{
+	return -EINVAL;
+}
+#endif
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swap_table.h b/mm/swap_table.h
index b0e7ef9c966b..814bc75597a0 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -406,6 +406,7 @@ static inline swp_entry_t swp_tb_ptr_to_swp_entry(unsigned long swp_tb)
 	return entry;
 }
 #else
+#define SWP_RMAP_CACHE_ONLY	0UL
 static inline bool swp_tb_is_pointer(unsigned long swp_tb)
 {
 	return false;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c90d83fd628a..a0976be6a12b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -145,10 +145,16 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 static bool vswap_alloc(struct folio *folio);
 static void vswap_free_cluster(struct swap_info_struct *si,
 			       struct swap_cluster_info *ci);
+static void vswap_mark_cache_only(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned int ci_off);
 #else
 static inline bool vswap_alloc(struct folio *folio) { return false; }
 static inline void vswap_free_cluster(struct swap_info_struct *si,
 				      struct swap_cluster_info *ci) {}
+static inline void vswap_mark_cache_only(struct swap_info_struct *si,
+					 struct swap_cluster_info *ci,
+					 unsigned int ci_off) {}
 #endif
 
 /* May return NULL on invalid type, caller must check for NULL return */
@@ -350,19 +356,24 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
 	BUG();
 }
 
-sector_t swap_folio_sector(struct folio *folio)
+sector_t swap_entry_sector(swp_entry_t entry)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(entry);
 	struct swap_extent *se;
 	sector_t sector;
 	pgoff_t offset;
 
-	offset = swp_offset(folio->swap);
+	offset = swp_offset(entry);
 	se = offset_to_swap_extent(sis, offset);
 	sector = se->start_block + (offset - se->start_page);
 	return sector << (PAGE_SHIFT - 9);
 }
 
+sector_t swap_folio_sector(struct folio *folio)
+{
+	return swap_entry_sector(folio->swap);
+}
+
 /*
  * swap allocation tell device that a cluster of swap can now be discarded,
  * to allow the swap device to optimize its wear-levelling.
@@ -880,6 +891,60 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 	return ret;
 }
 
+/*
+ * Try to reclaim a Pointer-tagged physical slot backing a vswap entry.
+ * The physical cluster lock must NOT be held. Returns < 0 on failure.
+ */
+static int try_to_reclaim_vswap_backing(struct swap_info_struct *si,
+					unsigned long offset)
+{
+	struct swap_cluster_info *ci;
+	swp_entry_t vswap_entry, phys_entry;
+	struct folio *folio;
+	unsigned long swp_tb;
+	unsigned int ci_off;
+
+	ci = swap_cluster_lock(si, offset);
+	if (!ci)
+		return -1;
+	ci_off = offset % SWAPFILE_CLUSTER;
+	swp_tb = __swap_table_get(ci, ci_off);
+	if (!swp_tb_is_pointer(swp_tb) || !(swp_tb & SWP_RMAP_CACHE_ONLY)) {
+		swap_cluster_unlock(ci);
+		return -1;
+	}
+	vswap_entry = swp_tb_ptr_to_swp_entry(swp_tb);
+	swap_cluster_unlock(ci);
+
+	folio = swap_cache_get_folio(vswap_entry);
+	if (!folio)
+		return -1;
+
+	if (!folio_trylock(folio)) {
+		folio_put(folio);
+		return -1;
+	}
+
+	if (!folio_matches_swap_entry(folio, vswap_entry)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return -1;
+	}
+
+	phys_entry = vswap_to_phys(vswap_entry);
+	if (!phys_entry.val || swp_offset(phys_entry) != offset ||
+	    swp_type(phys_entry) != si->type) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return -1;
+	}
+
+	vswap_store_folio(vswap_entry, folio);
+	folio_unlock(folio);
+	folio_put(folio);
+	return 0;
+}
+
 /*
  * Reclaim drops the ci lock, so the cluster may become unusable (freed or
  * stolen by a lower order). @usable will be set to false if that happens.
@@ -903,8 +968,13 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 	spin_unlock(&ci->lock);
 	do {
 		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
-		if (swp_tb_is_pointer(swp_tb))
-			break;
+		if (swp_tb_is_pointer(swp_tb)) {
+			rcu_read_unlock();
+			if (try_to_reclaim_vswap_backing(si, offset) < 0)
+				goto relock;
+			rcu_read_lock();
+			continue;
+		}
 		if (swp_tb_get_count(swp_tb))
 			break;
 		if (swp_tb_is_folio(swp_tb))
@@ -912,6 +982,7 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 				break;
 	} while (++offset < end);
 	rcu_read_unlock();
+relock:
 
 	/* Re-lookup: dynamic cluster may have been freed while lock was dropped */
 	ci = swap_cluster_lock(si, start);
@@ -983,6 +1054,8 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 					 unsigned int order)
 {
 	unsigned long nr_pages = 1 << order;
+	swp_entry_t vswap_entry, v;
+	unsigned int i;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -991,11 +1064,24 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 
 	swap_cluster_assert_empty(ci, ci_off, nr_pages, false);
 
-	if (swp_tb_is_folio(swp_tb))
+	if (swp_tb_is_folio(swp_tb)) {
 		__swap_cache_add_folio(ci, folio, swp_entry(si->type,
 							    ci_off + cluster_offset(si, ci)));
-	else
+	} else if (swp_tb_is_pointer(swp_tb) && nr_pages > 1) {
+		/*
+		 * Pointer-tagged rmap for vswap-backing THP — each
+		 * physical slot points back to its own vswap entry.
+		 */
+		vswap_entry = folio->swap;
+		for (i = 0; i < nr_pages; i++) {
+			v = vswap_entry;
+			v.val += i;
+			__swap_table_set(ci, ci_off + i,
+					 swp_entry_to_swp_tb_ptr(v));
+		}
+	} else {
 		__swap_table_set(ci, ci_off, swp_tb);
+	}
 
 	/*
 	 * The first allocation in a cluster makes the
@@ -1167,6 +1253,13 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 					offset += abs(nr_reclaim);
 					continue;
 				}
+			} else if (swp_tb_is_pointer(swp_tb) &&
+				   swap_rmap_is_cache_only(ci, offset % SWAPFILE_CLUSTER)) {
+				spin_unlock(&ci->lock);
+				try_to_reclaim_vswap_backing(si, offset);
+				ci = swap_cluster_lock(si, offset);
+				if (!ci)
+					goto next;
 			}
 			offset++;
 		}
@@ -1507,7 +1600,14 @@ static swp_entry_t swap_alloc_fast(struct folio *folio)
 	if (!si || !offset || !get_swap_device_info(si))
 		return (swp_entry_t){};
 
-	swp_tb = folio_to_swp_tb(folio, 0);
+	/*
+	 * Folio already in swap cache: allocating physical backing for a
+	 * vswap entry (folio_realloc_swap).
+	 */
+	if (folio_test_swapcache(folio))
+		swp_tb = swp_entry_to_swp_tb_ptr(folio->swap);
+	else
+		swp_tb = folio_to_swp_tb(folio, 0);
 
 	ci = swap_cluster_lock(si, offset);
 	if (ci && cluster_is_usable(ci, order)) {
@@ -1530,7 +1630,11 @@ static swp_entry_t swap_alloc_slow(struct folio *folio)
 	struct swap_info_struct *si, *next;
 	unsigned long swp_tb, found;
 
-	swp_tb = folio_to_swp_tb(folio, 0);
+	/* See comment in swap_alloc_fast() */
+	if (folio_test_swapcache(folio))
+		swp_tb = swp_entry_to_swp_tb_ptr(folio->swap);
+	else
+		swp_tb = folio_to_swp_tb(folio, 0);
 
 	spin_lock(&swap_avail_lock);
 start_over:
@@ -1722,6 +1826,8 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 			}
 			/* count will be 0 after put, slot can be reclaimed */
 			need_reclaim = true;
+			if (swap_is_vswap(si))
+				vswap_mark_cache_only(si, ci, ci_off);
 		}
 		/*
 		 * A count != 1 or cached slot can't be freed. Put its swap
@@ -1922,12 +2028,7 @@ int folio_alloc_swap(struct folio *folio)
 		}
 	}
 
-	/*
-	 * Skip vswap when zswap is disabled — without zswap, vswap entries
-	 * have nowhere to go on writeout (no physical fallback yet; that
-	 * arrives in the next patch).
-	 */
-	if (zswap_is_enabled() && vswap_alloc(folio))
+	if (vswap_alloc(folio))
 		goto done;
 
 again:
@@ -1953,6 +2054,25 @@ int folio_alloc_swap(struct folio *folio)
 }
 
 #ifdef CONFIG_VSWAP
+static void vswap_mark_cache_only(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned int ci_off)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *pci;
+	swp_entry_t phys;
+	unsigned long vt;
+
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	vt = __vtable_get(ci_dyn, ci_off);
+
+	if (vtable_type(vt) == VSWAP_SWAPFILE) {
+		phys = vtable_to_phys(vt);
+		pci = __swap_entry_to_cluster(phys);
+		swap_rmap_mark_cache_only(pci, swp_cluster_offset(phys));
+	}
+}
+
 static void vswap_free_cluster(struct swap_info_struct *si,
 			       struct swap_cluster_info *ci)
 {
@@ -1971,12 +2091,21 @@ static void vswap_free_cluster(struct swap_info_struct *si,
 	kfree_rcu(ci_dyn, rcu);
 }
 
+static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
+					     struct swap_cluster_info *pci,
+					     unsigned int ci_start,
+					     unsigned int nr_pages);
+
 void vswap_release_backing(struct swap_cluster_info *ci,
 			   unsigned int ci_start, unsigned int nr)
 {
 	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_info_struct *psi;
+	unsigned long phys_start = 0, phys_end = 0;
+	unsigned int phys_type = 0;
 	unsigned int ci_off;
 	unsigned long vt;
+	swp_entry_t phys;
 
 	lockdep_assert_held(&ci->lock);
 	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
@@ -1984,12 +2113,41 @@ void vswap_release_backing(struct swap_cluster_info *ci,
 	for (ci_off = ci_start; ci_off < ci_start + nr; ci_off++) {
 		vt = __vtable_get(ci_dyn, ci_off);
 
+		/*
+		 * Flush batched physical slots when the next entry
+		 * breaks contiguity, changes type/device, or would
+		 * cross a SWAPFILE_CLUSTER boundary (the free helper
+		 * operates on a single cluster).
+		 */
+		if (phys_start != phys_end &&
+		    (vtable_type(vt) != VSWAP_SWAPFILE ||
+		     swp_type(vtable_to_phys(vt)) != phys_type ||
+		     swp_offset(vtable_to_phys(vt)) != phys_end ||
+		     phys_end % SWAPFILE_CLUSTER == 0)) {
+			psi = __swap_type_to_info(phys_type);
+			__swap_cluster_free_phys_backing(psi,
+				__swap_entry_to_cluster(
+					swp_entry(phys_type, phys_start)),
+				phys_start % SWAPFILE_CLUSTER,
+				phys_end - phys_start);
+			phys_start = phys_end = 0;
+		}
+
 		switch (vtable_type(vt)) {
+		case VSWAP_SWAPFILE:
+			if (!phys_start) {
+				phys = vtable_to_phys(vt);
+				phys_start = swp_offset(phys);
+				phys_end = phys_start + 1;
+				phys_type = swp_type(phys);
+			} else {
+				phys_end++;
+			}
+			break;
 		case VSWAP_ZSWAP:
 			if (vtable_to_zswap(vt))
 				zswap_entry_free(vtable_to_zswap(vt));
 			break;
-		case VSWAP_SWAPFILE:
 		case VSWAP_FOLIO:
 		case VSWAP_ZERO:
 		case VSWAP_NONE:
@@ -1998,6 +2156,15 @@ void vswap_release_backing(struct swap_cluster_info *ci,
 
 		__vtable_set(ci_dyn, ci_off, vtable_mk_none());
 	}
+
+	if (phys_start != phys_end) {
+		psi = __swap_type_to_info(phys_type);
+		__swap_cluster_free_phys_backing(psi,
+			__swap_entry_to_cluster(
+				swp_entry(phys_type, phys_start)),
+			phys_start % SWAPFILE_CLUSTER,
+			phys_end - phys_start);
+	}
 }
 
 void vswap_store_folio(swp_entry_t entry, struct folio *folio)
@@ -2050,6 +2217,54 @@ void vswap_prepare_writeout(swp_entry_t entry, struct folio *folio)
 	spin_unlock(&ci->lock);
 }
 
+swp_entry_t folio_realloc_swap(struct folio *folio)
+{
+	swp_entry_t vswap_entry = folio->swap;
+	struct swap_cluster_info *ci;
+	struct swap_cluster_info_dynamic *ci_dyn;
+	unsigned int voff;
+	swp_entry_t phys_entry = {};
+	swp_entry_t pe;
+	int i, nr = folio_nr_pages(folio);
+
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON(!swap_is_vswap(__swap_entry_to_info(vswap_entry)));
+
+	phys_entry = vswap_to_phys(vswap_entry);
+	if (phys_entry.val)
+		return phys_entry;
+
+	local_lock(&percpu_swap_cluster.lock);
+	phys_entry = swap_alloc_fast(folio);
+	if (!phys_entry.val)
+		phys_entry = swap_alloc_slow(folio);
+	local_unlock(&percpu_swap_cluster.lock);
+
+	if (!phys_entry.val)
+		return (swp_entry_t){};
+
+	voff = swp_cluster_offset(vswap_entry);
+
+	ci = __swap_entry_to_cluster(vswap_entry);
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	spin_lock(&ci->lock);
+	/*
+	 * Install PHYS backing without freeing any prior contents of the
+	 * vtable. The caller is responsible for any cleanup of the prior
+	 * backing — for example, zswap_writeback_entry calls in with the
+	 * slot still pointing at the loaded zswap_entry (which it uses
+	 * for decompress before zswap_entry_free), and swap_writeout
+	 * calls vswap_prepare_writeout first to drop partial ZSWAP state.
+	 */
+	for (i = 0; i < nr; i++) {
+		pe.val = phys_entry.val + i;
+		__vtable_set(ci_dyn, voff + i, vtable_mk_phys(pe));
+	}
+	spin_unlock(&ci->lock);
+
+	return phys_entry;
+}
 #endif /* CONFIG_VSWAP */
 
 /**
@@ -2181,6 +2396,70 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
  * Free a set of swap slots after their swap count dropped to zero, or will be
  * zero after putting the last ref (saves one __swap_cluster_put_entry call).
  */
+#ifdef CONFIG_VSWAP
+/*
+ * Clear swap table entries to NULL and reset zero flags.
+ * Does not touch memcg or count — caller handles those.
+ */
+static void __swap_cluster_clear_table(struct swap_cluster_info *ci,
+				       unsigned int ci_start,
+				       unsigned int nr_pages)
+{
+	unsigned int ci_off;
+
+	lockdep_assert_held(&ci->lock);
+	for (ci_off = ci_start; ci_off < ci_start + nr_pages; ci_off++) {
+		__swap_table_set(ci, ci_off, null_to_swp_tb());
+		if (!SWAP_TABLE_HAS_ZEROFLAG)
+			__swap_table_clear_zero(ci, ci_off);
+	}
+}
+#endif
+
+/*
+ * Common tail for freeing swap slots: device-level accounting
+ * and cluster list management.
+ */
+static void __swap_cluster_finish_free(struct swap_info_struct *si,
+				       struct swap_cluster_info *ci,
+				       unsigned int ci_start,
+				       unsigned int nr_pages)
+{
+	lockdep_assert_held(&ci->lock);
+	swap_range_free(si, cluster_offset(si, ci) + ci_start, nr_pages);
+	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
+
+	if (!ci->count)
+		free_cluster(si, ci);
+	else
+		partial_free_cluster(si, ci);
+}
+
+#ifdef CONFIG_VSWAP
+/*
+ * Free physical swap slots that were backing vswap entries (Pointer-tagged).
+ * Clears the physical swap table, decrements cluster count, and does
+ * device-level accounting. Called from vswap_release_backing.
+ */
+static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
+					     struct swap_cluster_info *pci,
+					     unsigned int ci_start,
+					     unsigned int nr_pages)
+{
+	/*
+	 * Caller holds the vswap cluster lock (asserted in
+	 * vswap_release_backing). Nest the physical cluster lock under it
+	 * — same lockdep class, so use SINGLE_DEPTH_NESTING to silence
+	 * PROVE_LOCKING.
+	 */
+	spin_lock_nested(&pci->lock, SINGLE_DEPTH_NESTING);
+	VM_WARN_ON(pci->count < nr_pages);
+	pci->count -= nr_pages;
+	__swap_cluster_clear_table(pci, ci_start, nr_pages);
+	__swap_cluster_finish_free(psi, pci, ci_start, nr_pages);
+	swap_cluster_unlock(pci);
+}
+#endif
 void __swap_cluster_free_entries(struct swap_info_struct *si,
 				 struct swap_cluster_info *ci,
 				 unsigned int ci_start, unsigned int nr_pages)
@@ -2188,7 +2467,6 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	unsigned long old_tb;
 	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
-	unsigned long ci_head = cluster_offset(si, ci);
 	unsigned int batch_off = ci_off;
 
 	VM_WARN_ON(ci->count < nr_pages);
@@ -2226,13 +2504,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	if (batch_id)
 		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
 
-	swap_range_free(si, ci_head + ci_start, nr_pages);
-	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
-
-	if (!ci->count)
-		free_cluster(si, ci);
-	else
-		partial_free_cluster(si, ci);
+	__swap_cluster_finish_free(si, ci, ci_start, nr_pages);
 }
 
 int __swap_count(swp_entry_t entry)
@@ -3070,19 +3342,85 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 
 static int try_to_unuse(unsigned int type)
 {
+	struct swap_cluster_info *vci;
+	struct mempolicy mpol = { .mode = MPOL_DEFAULT };
 	struct mm_struct *prev_mm;
 	struct mm_struct *mm;
 	struct list_head *p;
 	int retval = 0;
 	struct swap_info_struct *si = swap_info[type];
 	struct folio *folio;
-	swp_entry_t entry;
-	unsigned int i;
+	swp_entry_t entry, vswap_entry;
+	unsigned long swp_tb;
+	unsigned int i, ci_off;
 
 	if (!swap_usage_in_pages(si))
 		goto success;
 
 retry:
+	/*
+	 * Free vswap-backing slots (Pointer-tagged) first. Walk physical
+	 * clusters, read the vswap entry from the rmap, ensure the data
+	 * is in the swap cache, and transition PHYS→FOLIO. No page table
+	 * walk needed — just free the physical backing.
+	 */
+	i = 0;
+	while (IS_ENABLED(CONFIG_VSWAP) &&
+	       swap_usage_in_pages(si) &&
+	       !signal_pending(current) &&
+	       (i = find_next_to_unuse(si, i)) != 0) {
+		swp_entry_t phys;
+
+		vci = __swap_offset_to_cluster(si, i);
+		if (!vci)
+			continue;
+		ci_off = i % SWAPFILE_CLUSTER;
+
+		spin_lock(&vci->lock);
+		swp_tb = __swap_table_get(vci, ci_off);
+		spin_unlock(&vci->lock);
+
+		if (!swp_tb_is_pointer(swp_tb))
+			continue;
+
+		vswap_entry = swp_tb_ptr_to_swp_entry(swp_tb);
+
+		folio = swap_cache_get_folio(vswap_entry);
+		if (!folio) {
+			folio = swap_cache_alloc_folio(vswap_entry,
+						      GFP_KERNEL, BIT(0), NULL,
+						      &mpol, NO_INTERLEAVE_INDEX);
+			if (IS_ERR_OR_NULL(folio))
+				continue;
+			swap_read_folio(folio, NULL);
+			folio_lock(folio);
+		} else {
+			folio_lock(folio);
+		}
+
+		if (!folio_matches_swap_entry(folio, vswap_entry)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			continue;
+		}
+
+		phys = vswap_to_phys(vswap_entry);
+		if (!phys.val || swp_type(phys) != type) {
+			folio_unlock(folio);
+			folio_put(folio);
+			continue;
+		}
+
+		folio_wait_writeback(folio);
+		vswap_store_folio(vswap_entry, folio);
+		folio_mark_dirty(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	if (!swap_usage_in_pages(si))
+		goto success;
+
 	retval = shmem_unuse(type);
 	if (retval)
 		return retval;
@@ -3126,6 +3464,14 @@ static int try_to_unuse(unsigned int type)
 
 		entry = swp_entry(type, i);
 
+		if (IS_ENABLED(CONFIG_VSWAP)) {
+			swp_tb = swap_table_get(
+				__swap_offset_to_cluster(si, i),
+				i % SWAPFILE_CLUSTER);
+			if (swp_tb_is_pointer(swp_tb))
+				continue;
+		}
+
 		folio = swap_cache_get_folio(entry);
 		if (!folio)
 			continue;
diff --git a/mm/vswap.h b/mm/vswap.h
index 5e6e5b88593c..a3a84e27f819 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -24,6 +24,40 @@ static inline bool swap_is_vswap(struct swap_info_struct *si)
 
 extern struct swap_info_struct *vswap_si;
 
+/* Rmap cache-only helpers for physical cluster Pointer-tagged entries */
+
+static inline void swap_rmap_mark_cache_only(struct swap_cluster_info *ci,
+					     unsigned int off)
+{
+	atomic_long_t *table;
+
+	table = rcu_dereference_check(ci->table, true);
+	atomic_long_or(SWP_RMAP_CACHE_ONLY, &table[off]);
+}
+
+static inline void swap_rmap_clear_cache_only(struct swap_cluster_info *ci,
+					      unsigned int off)
+{
+	atomic_long_t *table;
+
+	table = rcu_dereference_check(ci->table, true);
+	atomic_long_and(~SWP_RMAP_CACHE_ONLY, &table[off]);
+}
+
+static inline bool swap_rmap_is_cache_only(struct swap_cluster_info *ci,
+					   unsigned int off)
+{
+	atomic_long_t *table;
+	bool ret;
+
+	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
+	rcu_read_lock();
+	table = rcu_dereference(ci->table);
+	ret = table && (atomic_long_read(&table[off]) & SWP_RMAP_CACHE_ONLY);
+	rcu_read_unlock();
+	return ret;
+}
+
 /*
  * Virtual table entry encoding for vswap clusters.
  *
@@ -73,6 +107,20 @@ static inline unsigned long vtable_mk_none(void)
 	return 0;
 }
 
+static inline unsigned long vtable_mk_phys(swp_entry_t entry)
+{
+	return vtable_mk(VSWAP_SWAPFILE, entry.val);
+}
+
+static inline swp_entry_t vtable_to_phys(unsigned long vt)
+{
+	swp_entry_t entry;
+
+	VM_WARN_ON(vtable_type(vt) != VSWAP_SWAPFILE);
+	entry.val = vtable_payload(vt);
+	return entry;
+}
+
 static inline unsigned long vtable_mk_zero(void)
 {
 	return VSWAP_ZERO;
@@ -136,6 +184,27 @@ vswap_lock_cluster(swp_entry_t entry, unsigned int *voff)
 	return ci_dyn;
 }
 
+/* High-level vswap lookup */
+
+static inline swp_entry_t vswap_to_phys(swp_entry_t entry)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	unsigned int voff;
+	unsigned long vt;
+
+	ci_dyn = vswap_lock_cluster(entry, &voff);
+	if (!ci_dyn)
+		return (swp_entry_t){};
+
+	vt = __vtable_get(ci_dyn, voff);
+	spin_unlock(&ci_dyn->ci.lock);
+
+	if (vtable_type(vt) != VSWAP_SWAPFILE)
+		return (swp_entry_t){};
+
+	return vtable_to_phys(vt);
+}
+
 /* Zswap entry helpers — store/load/erase in virtual_table */
 
 void vswap_release_backing(struct swap_cluster_info *ci,
@@ -188,6 +257,7 @@ static inline int vswap_check_backing(swp_entry_t entry, int nr,
 	enum vswap_backing_type first_type;
 	unsigned int voff;
 	unsigned long vt;
+	swp_entry_t first_phys;
 	int i;
 
 	ci_dyn = vswap_lock_cluster(entry, &voff);
@@ -196,10 +266,16 @@ static inline int vswap_check_backing(swp_entry_t entry, int nr,
 
 	for (i = 0; i < nr; i++) {
 		vt = __vtable_get(ci_dyn, voff + i);
-		if (!i)
+		if (!i) {
 			first_type = vtable_type(vt);
-		else if (vtable_type(vt) != first_type)
+			if (first_type == VSWAP_SWAPFILE)
+				first_phys = vtable_to_phys(vt);
+		} else if (vtable_type(vt) != first_type) {
 			break;
+		} else if (first_type == VSWAP_SWAPFILE &&
+			   vtable_to_phys(vt).val != first_phys.val + i) {
+			break;
+		}
 	}
 	spin_unlock(&ci_dyn->ci.lock);
 
@@ -208,12 +284,20 @@ static inline int vswap_check_backing(swp_entry_t entry, int nr,
 	return i;
 }
 
+static inline bool vswap_swapfile_backed(swp_entry_t entry, int nr)
+{
+	enum vswap_backing_type type;
+
+	return vswap_check_backing(entry, nr, &type) == nr &&
+	       type == VSWAP_SWAPFILE;
+}
+
 static inline bool vswap_can_swapin_thp(swp_entry_t entry, int nr)
 {
 	enum vswap_backing_type type;
 
 	return vswap_check_backing(entry, nr, &type) == nr &&
-	       type == VSWAP_ZERO;
+	       (type == VSWAP_ZERO || type == VSWAP_SWAPFILE);
 }
 
 static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info_dynamic *ci_dyn)
@@ -266,6 +350,22 @@ static inline void vswap_set_zero(struct swap_cluster_info *ci,
 
 #else /* !CONFIG_VSWAP */
 
+static inline swp_entry_t vswap_to_phys(swp_entry_t entry)
+{
+	return (swp_entry_t){};
+}
+
+static inline bool vswap_swapfile_backed(swp_entry_t entry, int nr)
+{
+	return false;
+}
+
+static inline bool swap_rmap_is_cache_only(struct swap_cluster_info *ci,
+					   unsigned int off)
+{
+	return false;
+}
+
 static inline void vswap_release_backing(struct swap_cluster_info *ci,
 					 unsigned int ci_start,
 					 unsigned int nr) {}
@@ -310,4 +410,36 @@ static inline void vswap_set_zero(struct swap_cluster_info *ci,
 				  unsigned int ci_off) {}
 
 #endif /* CONFIG_VSWAP */
+
+/*
+ * Test a per-backend swap flag (SWP_SYNCHRONOUS_IO, SWP_STABLE_WRITES, ...)
+ * for @entry. For a vswap entry the property belongs to the current
+ * physical backing, not vswap_si — resolve and test that. Returns false
+ * for zswap/zero/unbacked vswap entries: they don't go through bdev IO,
+ * so per-bdev flags don't apply.
+ */
+static inline bool swap_entry_backend_has_flag(struct swap_info_struct *si,
+					       swp_entry_t entry,
+					       unsigned long flag)
+{
+	struct swap_info_struct *phys_si;
+	swp_entry_t phys;
+	bool has_flag;
+
+	if (!swap_is_vswap(si))
+		return data_race(si->flags & flag);
+
+	phys = vswap_to_phys(entry);
+	if (!phys.val)
+		return false;
+
+	phys_si = get_swap_device(phys);
+	if (!phys_si)
+		return false;
+
+	has_flag = data_race(phys_si->flags & flag);
+	put_swap_device(phys_si);
+	return has_flag;
+}
+
 #endif /* _MM_VSWAP_H */
diff --git a/mm/zswap.c b/mm/zswap.c
index c57bf0246bb2..85622af0df5c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -993,6 +993,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
+	swp_entry_t phys = {};
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1000,16 +1001,6 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (!si)
 		return -EEXIST;
 
-	/*
-	 * Vswap entries have no physical backing — writeback would fail
-	 * and SIGBUS the caller. Bail before we waste a swap-cache folio
-	 * allocation.
-	 */
-	if (si->flags & SWP_VSWAP) {
-		put_swap_device(si);
-		return -EINVAL;
-	}
-
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
@@ -1028,31 +1019,57 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/*
 	 * folio is locked, and the swapcache is now secured against
 	 * concurrent swapping to and from the slot, and concurrent
-	 * swapoff so we can safely dereference the zswap tree here.
-	 * Verify that the swap entry hasn't been invalidated and recycled
-	 * behind our backs, to avoid overwriting a new swap folio with
-	 * old compressed data. Only when this is successful can the entry
-	 * be dereferenced.
+	 * swapoff so we can safely dereference the zswap tree (or vswap
+	 * vtable) here. Verify that the swap entry hasn't been
+	 * invalidated and recycled behind our backs, to avoid overwriting
+	 * a new swap folio with old compressed data. Only when this is
+	 * successful can the entry be dereferenced.
 	 */
-	tree = swap_zswap_tree(swpentry);
-	if (entry != xa_load(tree, offset)) {
-		ret = -ENOMEM;
-		goto out;
+	if (swap_is_vswap(si)) {
+		if (entry != vswap_zswap_load(swpentry)) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		/*
+		 * Allocate physical backing BEFORE decompress — if it fails,
+		 * no wasted work. folio_realloc_swap sets vtable to PHYS,
+		 * overwriting ZSWAP — the old entry pointer is only held
+		 * by the caller now.
+		 */
+		phys = folio_realloc_swap(folio);
+		if (!phys.val) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	} else {
+		tree = swap_zswap_tree(swpentry);
+		if (entry != xa_load(tree, offset)) {
+			ret = -ENOMEM;
+			goto out;
+		}
 	}
 
 	if (!zswap_decompress(entry, folio)) {
 		ret = -EIO;
+		/*
+		 * For vswap: folio_realloc_swap already moved the entry
+		 * out of the vtable. Restore it via vswap_zswap_store so
+		 * the entry stays tracked (and the just-allocated PHYS
+		 * slot is freed). For non-vswap: entry is still in the
+		 * zswap tree.
+		 */
+		if (swap_is_vswap(si) && phys.val)
+			vswap_zswap_store(swpentry, entry);
 		goto out;
 	}
 
-	xa_erase(tree, offset);
+	if (!swap_is_vswap(si))
+		xa_erase(tree, offset);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
 		count_objcg_events(entry->objcg, ZSWPWB, 1);
 
-	zswap_entry_free(entry);
-
 	/* folio is up to date */
 	folio_mark_uptodate(folio);
 
@@ -1060,8 +1077,22 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	ret = __swap_writepage(folio, NULL);
-	WARN_ON_ONCE(ret);
+	if (swap_is_vswap(si)) {
+		ret = __swap_writepage_phys(folio, NULL, phys);
+		WARN_ON_ONCE(ret);
+	} else {
+		ret = __swap_writepage(folio, NULL);
+		WARN_ON_ONCE(ret);
+	}
+
+	/*
+	 * __swap_writepage{,_phys} always returns 0 today — async IO
+	 * errors surface in the bio end_io callback, not synchronously
+	 * here. Either way, the entry has been moved out of its prior
+	 * location (vtable PHYS for vswap, removed from tree for not),
+	 * so we own the free.
+	 */
+	zswap_entry_free(entry);
 
 out:
 	if (ret) {
-- 
2.53.0-Meta


