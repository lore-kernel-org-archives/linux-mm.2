Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CECB61088E49
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0036B036C; Wed, 18 Mar 2026 18:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2AA6B036E; Wed, 18 Mar 2026 18:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A1D6B036F; Wed, 18 Mar 2026 18:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2846B036C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E25DC56C52
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:28 +0000 (UTC)
X-FDA: 84560628936.14.1AA64C7
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3209E180012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LaGxN7AZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESVpGQYFBCiWMDqw6fxjJx7j9Ms0hezUwaEqwm+xWcM=;
	b=gK8AJBP+IGdkPXPI9shCqU981D2R8MezcI7s6izvKa+gpg1NMWniGSDvMP6MDqk4hY7KQc
	A4SEJo148rtYpo1k2FCfsMGtayX9QodK+iij+zPRb2M653iewBa9ZdoG1Hjcdt5SsB3dYY
	gCjmBA3KiNFA4NLfgchc9bvpaTUYjgU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LaGxN7AZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873027; a=rsa-sha256;
	cv=none;
	b=pnWZ2osYII2EXZCFaJmiJg8aTj82wZ/JvMW5gBsEsQJx24mkVeqwHLuz4VbKXnN9MFrVUp
	PSlRPVl9I/YiXfEVFLmD3PhD1+WbIdVTpQv3YmPYTKq88hqxtu73Z6dgawpNanP3ETAdpC
	JKDmXoB1q+XBz2Ni6PHQ03NBYHcF254=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d738fe814cso40899a34.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873026; x=1774477826; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ESVpGQYFBCiWMDqw6fxjJx7j9Ms0hezUwaEqwm+xWcM=;
        b=LaGxN7AZ6VFDpSymevzuGVA2+whBAY8akfQgujw+dk5k/Zv8EkcNjQrmBgkVQZB2Hu
         zwK3rt97SIEglalg3iceFnyWko/ARepCCWCATKTrKseH6A6fQ6pk/zJhsmgjjWsOZZYX
         iXsj6m5iBSqW4C52lbRckPe+yVUPLEG/u7yvnd+7bA/KBae3nPnPAZQS/Z1w+idFG9pc
         9pnsG0/wWrWGXrX9GNaHRLDr6vqkD65t1UCHWcx2UTkO3mtq37yIzUWF4nZCTv0TgsZF
         3RAjRJAy/1FxztNpCW3D5JaBHXxRK2qsHaoRTAs/qlmyhIFTXPFNQRbliQ0uhjTU73w6
         ToFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873026; x=1774477826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ESVpGQYFBCiWMDqw6fxjJx7j9Ms0hezUwaEqwm+xWcM=;
        b=c6NFaYAHbrQE6z0vUbBQGTUI68+65MEE4RvnF9yRjhTkvWJ70HoEVamiKMFKiHwb6i
         nIVREMRtlDyG10rUfi/7BLyRfpx2m+zGtja4KepFpBjDtrEeOvMq0GVnlP2Ln7RAJ4Cw
         DlCNzUS24mQ1yRrc7a5fi6FRE/lSg9YKyQ/1JIztHqB+77IRSQGNBOgoiRBdGrgDME9C
         0frLbAHYQQczVI+0vIgATGC1uPW3ivUsxzECqF3O4CBnYYGO04OagqEM8OUIZg8OHe+K
         nMe3kMXGwvlyeBtRz3YdhVBBs6lW6TtRZpYMH6ad7DpCVMFRpC2t38Belyd/xLndd7p9
         dbJg==
X-Forwarded-Encrypted: i=1; AJvYcCVwRSlWMm7e+aOdAfSbHRlAcXFxpsTIqFBwEauZbjO7m7x2YOHDiqN3eaQfscEQlSGfp2V/wxtVTQ==@kvack.org
X-Gm-Message-State: AOJu0YyozhMNiNJsIQRvVkShVJ3oigLqhtCpoI3+iUF8Fzr5QTcqhpa5
	VuvPvN/RCquQshZpVu91gEU+Kp0F7DZKH9jdhVLhF2Jh1x/9Qgw8DX56
X-Gm-Gg: ATEYQzzyDWL2bJnU4WM2qxEHUH/YqO2R5UinLuGheGSBHNFhJa6dqEn5vYNolxlxgZ2
	FQv7KscV7u/Jka4kymCCEmpcAWArlSZf48pF5I6FTf2iIOkfdWFNvStei6MKJMvob7dpGdcpsBc
	USv3zu8sZQl0b24hsEHKQaE0e5GQDcJRZCVjFOVcQYwqhYKWXYHRtU5JTTDQWc4Y/UD1vA2+XFP
	mMmlCz1IqHcHr7atwX5jhe8Vkzy8Yn0yEGkyzeAVoy072A7ZIF0DkLA913QHnzDcFZ1WxYu+wmx
	S7LgWB8URFJDfCgNFzzvbk9SczRlCuf9BRqe4AZW/6pXOnLshPeAmDvWENwZdM06XLsl8xYa9mk
	g8C2DCWynkDZC9HQdCV28bRhzxP6ZgGPj5JgbxIigWp24/I6jD7NQZNWr4wQ+12g2mmYUOI+cng
	OX8sNgzeK91Zni1pezrk7NK3ndNIvXV3fhmsQybID/PTJ10g==
X-Received: by 2002:a05:6830:4985:b0:7d7:4aa5:521c with SMTP id 46e09a7af769-7d7ca6bb6edmr3479621a34.21.1773873026118;
        Wed, 18 Mar 2026 15:30:26 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7c9b837f0sm2976890a34.21.2026.03.18.15.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:24 -0700 (PDT)
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
Subject: [PATCH v4 18/21] memcg: swap: only charge physical swap slots
Date: Wed, 18 Mar 2026 15:29:49 -0700
Message-ID: <20260318222953.441758-19-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3209E180012
X-Stat-Signature: qc5zm88o5i9xwy6gw5z1kxbshffbm4um
X-Rspam-User: 
X-HE-Tag: 1773873027-689574
X-HE-Meta: U2FsdGVkX1+7yv5ZrP7CWIFBXKv6p1ssFqQ7J98tY7gIw1S8EGvx09Rbs941GiC35A27wmM8W7QM7LwiLwrVjCpu7RNyCq1+cUjl9QFewgqQ+EZqO2zAiKwSKCyy/9L92InS2DKQmSNCucpj2HRBRoxTmoGlEPJn1G5k3W6v/YRH2826rIVALeMH9TIYsVQv1Igs46LloHIV/Ox68J5lCMpv3EUhDINEh0zHQuQ5NAgzMSY1tG5SvKfVgFbj/Wqi/XSnOisAVepNjxeWsJzXHrRN+Ta0bmVmOIKram99SHeku99X+MvQkANA9OdYXz5X8fEbSM0fidaRcqT5BBFpptako0Kn9t0whULsV6tGdu3D/iBc5OnJmc0ZJsmziuwdp3SISDQO1vTix2pk23Vpgw7tedipSJQbdA4xRNjIJHTNN6d89mAFDWQpMCDZ1gvFwazY2DmF/Y0fdMT7RaAfEK4n1mIcw7INvI2p+Go4Aj/iwNgvApmBJ7GEpBCnQnKZpoCZIMzoseWTwj9uIwovKcY7s1qJzPnBvB4+7MChndVBar5QgxqUfGfgepdjBT8kPNBH9nTW/X4XyNu4S9JyVJJFxJMUHTImPfWAJAnMypf0JLfa7sCCq2MsVR6+gToQtN2UAFktHHoMYfQPmllR0y6GTalImXcf2e2lScVMFCuTNu0Crxl8M1pkycYbzGu4sS0Rq8opte2EvpV36MPIQZTNtwX32fLyN+JHeK8R3gebbPxM5WJUcne+XefghEC2CYtZeR8ZwH1iVe6AN79+lBB37CeH+lDZTTDXmvUroq6mOeHm0QlBTL+8OIcdWPafJ2unhYZmrQDmi8Ytflre+Q6+qqs4UCf8Hzn/q6gYz1EmQG4XcvPFzT98k2NZvhCl7MNXmyTRAp3+UUEWlFd/bQbFNjml5le6Ml4jDZ/veWs+sju5Ce4oduq2xHSgfl6J/KJogU9fYnN6QjCbDFl
 9uVZvGUW
 JztGvrzR0e+/nCgJ7ZxfUXHKWDR2CudehJSQhhM1g5QvDRyiG9ssxv3muRbSmdl0mgvcl1j8ebz3RjYH6qi2Q8BzVPXBsf9hZxjUkRWyuaqGBJi3NyGmIqGzQ1Go8bgrT2zRa/Udjj5bnEUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that zswap and the zero-filled swap page optimization no longer
takes up any physical swap space, we should not charge towards the swap
usage and limits of the memcg in these case. We will only record the
memcg id on virtual swap slot allocation, and defer physical swap
charging (i.e towards memory.swap.current) until the virtual swap slot
is backed by an actual physical swap slot (on zswap store failure
fallback or zswap writeback).

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h | 26 ++++++++++++++
 mm/memcontrol-v1.c   |  6 ++++
 mm/memcontrol.c      | 83 ++++++++++++++++++++++++++++++++------------
 mm/vswap.c           | 39 +++++++++------------
 4 files changed, 108 insertions(+), 46 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index cc1ca4ac2946d..21e528d8d3480 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -676,6 +676,22 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
+void __mem_cgroup_record_swap(struct folio *folio, swp_entry_t entry);
+static inline void mem_cgroup_record_swap(struct folio *folio,
+		swp_entry_t entry)
+{
+	if (!mem_cgroup_disabled())
+		__mem_cgroup_record_swap(folio, entry);
+}
+
+void __mem_cgroup_clear_swap(swp_entry_t entry, unsigned int nr_pages);
+static inline void mem_cgroup_clear_swap(swp_entry_t entry,
+		unsigned int nr_pages)
+{
+	if (!mem_cgroup_disabled())
+		__mem_cgroup_clear_swap(entry, nr_pages);
+}
+
 int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
 		swp_entry_t entry)
@@ -696,6 +712,16 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_p
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
+static inline void mem_cgroup_record_swap(struct folio *folio,
+					     swp_entry_t entry)
+{
+}
+
+static inline void mem_cgroup_clear_swap(swp_entry_t entry,
+					     unsigned int nr_pages)
+{
+}
+
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
 					     swp_entry_t entry)
 {
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff7426..4580a034dcf72 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -680,6 +680,12 @@ void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
 		 * memory+swap charge, drop the swap entry duplicate.
 		 */
 		mem_cgroup_uncharge_swap(entry, nr_pages);
+
+		/*
+		 * Clear the cgroup association now to prevent double memsw
+		 * uncharging when the backends are released later.
+		 */
+		mem_cgroup_clear_swap(entry, nr_pages);
 	}
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2ba5811e7edba..4525c21754e7f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5172,6 +5172,49 @@ int __init mem_cgroup_init(void)
 }
 
 #ifdef CONFIG_SWAP
+/**
+ * __mem_cgroup_record_swap - record the folio's cgroup for the swap entries.
+ * @folio: folio being swapped out.
+ * @entry: the first swap entry in the range.
+ */
+void __mem_cgroup_record_swap(struct folio *folio, swp_entry_t entry)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+	struct mem_cgroup *memcg;
+
+	/* Recording will be done by memcg1_swapout(). */
+	if (do_memsw_account())
+		return;
+
+	memcg = folio_memcg(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
+	if (!memcg)
+		return;
+
+	memcg = mem_cgroup_id_get_online(memcg);
+	if (nr_pages > 1)
+		mem_cgroup_id_get_many(memcg, nr_pages - 1);
+	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
+}
+
+/**
+ * __mem_cgroup_clear_swap - clear cgroup information of the swap entries.
+ * @entry: the first swap entry in the range.
+ * @nr_pages: the number of pages in the range.
+ */
+void __mem_cgroup_clear_swap(swp_entry_t entry, unsigned int nr_pages)
+{
+	unsigned short id = swap_cgroup_clear(entry, nr_pages);
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_id(id);
+	if (memcg)
+		mem_cgroup_id_put_many(memcg, nr_pages);
+	rcu_read_unlock();
+}
+
 /**
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
@@ -5190,34 +5233,24 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 	if (do_memsw_account())
 		return 0;
 
-	memcg = folio_memcg(folio);
-
-	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
-	if (!memcg)
-		return 0;
-
-	if (!entry.val) {
-		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		return 0;
-	}
-
-	memcg = mem_cgroup_id_get_online(memcg);
+	/*
+	 * We already record the cgroup on virtual swap allocation.
+	 * Note that the virtual swap slot holds a reference to memcg,
+	 * so this lookup should be safe.
+	 */
+	rcu_read_lock();
+	memcg = mem_cgroup_from_id(lookup_swap_cgroup_id(entry));
+	rcu_read_unlock();
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_id_put(memcg);
 		return -ENOMEM;
 	}
 
-	/* Get references for the tail pages, too */
-	if (nr_pages > 1)
-		mem_cgroup_id_get_many(memcg, nr_pages - 1);
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
-	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
-
 	return 0;
 }
 
@@ -5231,7 +5264,8 @@ void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
-	id = swap_cgroup_clear(entry, nr_pages);
+	id = lookup_swap_cgroup_id(entry);
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
@@ -5242,7 +5276,6 @@ void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_id_put_many(memcg, nr_pages);
 	}
 	rcu_read_unlock();
 }
@@ -5251,14 +5284,18 @@ static bool mem_cgroup_may_zswap(struct mem_cgroup *original_memcg);
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
-	long nr_swap_pages, nr_zswap_pages = 0;
+	long nr_swap_pages;
 
 	if (zswap_is_enabled() && (mem_cgroup_disabled() || do_memsw_account() ||
 				mem_cgroup_may_zswap(memcg))) {
-		nr_zswap_pages = PAGE_COUNTER_MAX;
+		/*
+		 * No need to check swap cgroup limits, since zswap is not charged
+		 * towards swap consumption.
+		 */
+		return PAGE_COUNTER_MAX;
 	}
 
-	nr_swap_pages = max_t(long, nr_zswap_pages, get_nr_swap_pages());
+	nr_swap_pages = get_nr_swap_pages();
 	if (mem_cgroup_disabled() || do_memsw_account())
 		return nr_swap_pages;
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
diff --git a/mm/vswap.c b/mm/vswap.c
index b391511e0f0b9..96f4615f29a95 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -544,6 +544,7 @@ void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 	struct vswap_cluster *cluster = NULL;
 	struct swp_desc *desc;
 	unsigned long flush_nr, phys_swap_start = 0, phys_swap_end = 0;
+	unsigned long phys_swap_released = 0;
 	unsigned int phys_swap_type = 0;
 	bool need_flushing_phys_swap = false;
 	swp_slot_t flush_slot;
@@ -573,6 +574,7 @@ void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 		if (desc->type == VSWAP_ZSWAP && desc->zswap_entry) {
 			zswap_entry_free(desc->zswap_entry);
 		} else if (desc->type == VSWAP_SWAPFILE) {
+			phys_swap_released++;
 			if (!phys_swap_start) {
 				/* start a new contiguous range of phys swap */
 				phys_swap_start = swp_slot_offset(desc->slot);
@@ -603,6 +605,9 @@ void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 		flush_nr = phys_swap_end - phys_swap_start;
 		swap_slot_free_nr(flush_slot, flush_nr);
 	}
+
+	if (phys_swap_released)
+		mem_cgroup_uncharge_swap(entry, phys_swap_released);
  }
 
 /*
@@ -630,7 +635,7 @@ static void vswap_free(struct vswap_cluster *cluster, struct swp_desc *desc,
 	spin_unlock(&cluster->lock);
 
 	release_backing(entry, 1);
-	mem_cgroup_uncharge_swap(entry, 1);
+	mem_cgroup_clear_swap(entry, 1);
 
 	/* erase forward mapping and release the virtual slot for reallocation */
 	spin_lock(&cluster->lock);
@@ -645,9 +650,6 @@ static void vswap_free(struct vswap_cluster *cluster, struct swp_desc *desc,
  */
 int folio_alloc_swap(struct folio *folio)
 {
-	struct vswap_cluster *cluster = NULL;
-	int i, nr = folio_nr_pages(folio);
-	struct swp_desc *desc;
 	swp_entry_t entry;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -657,25 +659,7 @@ int folio_alloc_swap(struct folio *folio)
 	if (!entry.val)
 		return -ENOMEM;
 
-	/*
-	 * XXX: for now, we charge towards the memory cgroup's swap limit on virtual
-	 * swap slots allocation. This will be changed soon - we will only charge on
-	 * physical swap slots allocation.
-	 */
-	if (mem_cgroup_try_charge_swap(folio, entry)) {
-		rcu_read_lock();
-		for (i = 0; i < nr; i++) {
-			desc = vswap_iter(&cluster, entry.val + i);
-			VM_WARN_ON(!desc);
-			vswap_free(cluster, desc, (swp_entry_t){ entry.val + i });
-		}
-		spin_unlock(&cluster->lock);
-		rcu_read_unlock();
-		atomic_add(nr, &vswap_alloc_reject);
-		entry.val = 0;
-		return -ENOMEM;
-	}
-
+	mem_cgroup_record_swap(folio, entry);
 	swap_cache_add_folio(folio, entry, NULL);
 
 	return 0;
@@ -717,6 +701,15 @@ bool vswap_alloc_swap_slot(struct folio *folio)
 	if (!slot.val)
 		return false;
 
+	if (mem_cgroup_try_charge_swap(folio, entry)) {
+		/*
+		 * We have not updated the backing type of the virtual swap slot.
+		 * Simply free up the physical swap slots here!
+		 */
+		swap_slot_free_nr(slot, nr);
+		return false;
+	}
+
 	/* establish the vrtual <-> physical swap slots linkages. */
 	si = __swap_slot_to_info(slot);
 	ci = swap_cluster_lock(si, swp_slot_offset(slot));
-- 
2.52.0


