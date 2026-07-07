Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B4FCC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041576B00A0; Tue,  7 Jul 2026 12:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32E96B00A1; Tue,  7 Jul 2026 12:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23726B00A2; Tue,  7 Jul 2026 12:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE9E46B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:11:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 525051A04BA
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:11:54 +0000 (UTC)
X-FDA: 84962471748.03.C603C47
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6930314000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:11:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BmOGNX98;
	spf=pass (imf26.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783440712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q08e42D6zw562DgOrRUU1GdgKThXKtrHfZYWO7DdVjw=;
	b=6/ZC1ZYJkDgOeMxXDbg/Fx/GZwZgjk4LokhBkyFYJNjZh8KNr4TsyAlmY067mbfNhh+6EI
	Ti57wAw6FWAdhff8Hao5i0iIaLQDYyz7uhGTlTRpZ7ugJY8CoY8f0F0x/wS0E/8vGWueTW
	CvT1ThW+oGJBljMM25wVoFfGJ8Dh35U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BmOGNX98;
	spf=pass (imf26.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783440712;
	b=KwMf0IyCL8gA4oB96tHLCIHeaa4XmHW1A0jjvmTuU0s8DPtC2Mc4bzRjlouTT5WICBvZ1h
	0rNOj0A8/vd9a3HRWLSJs1rf2cjwxaua7jAjWwZmWbBZrTLMUZyJ+asgHEuQZlmxKAEJHF
	+vAwp0oQcOWbqg/aYAa27dd9uDC7pX0=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cacb8416a1so37076785ad.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 09:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783440711; x=1784045511; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q08e42D6zw562DgOrRUU1GdgKThXKtrHfZYWO7DdVjw=;
        b=BmOGNX98E8/qOUenp0oxDRxyu7MvgVEYs7ZQntsSS+L3R1mbMrCbWDse6QKIbX4j+a
         +Jjrg9+MZUAatoo5UMy799zMoyrn/QoU0L3D4gpSqeiUYOKzLhYRWkud0fZUxlUpOVuX
         nhUQuaZsrH1aSM6hxGIz+84HMrJlcnIf1AvKCWSXVgaANipJDQCN6UJ52qATmDgRmO83
         FKaFqq6kK/lJrgrQH6ceCKASrmcGocKXeZKeT+5Ckugyrv7BfFP8e7Q5YPTewmsN0Cal
         iqo6rrWbWCvCoM1PK23An8RED3q2gv9DttHmvi3qA/IL5QHBeBsxWRpFd8VUlPXdy7dj
         Z2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783440711; x=1784045511;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q08e42D6zw562DgOrRUU1GdgKThXKtrHfZYWO7DdVjw=;
        b=aLn6CYA+05G63028e3cDXiS98asTzDKykRZ0dy6cq8+p3BtFFcZ5Ttv9f5osVY74wi
         Jn4QowBikv8HLzEYu6WsXx0hsm1hCkX2+6gNaso4gRvmzu+qFUV2um1BPCJuDdiaZ+B6
         kDNes+wF2Phy1efik1VblLuCg39LQK+2t2Ay3sDNyS99dNqQMmOSxdw0gaT/iNztNWEW
         7wURtsc4y05fE3+j5A2HvC6AqtcDLYA6GSSh6Ex2L9ELm0KZ3MkwFEtPAvWvI0YVitpt
         Q5t2SDhKqwRv8ccDAx6CyF6fL2KojQV/LiYGSrQMNlrKiGPIv2aFfJ1J+VxllxynW8Zs
         j1bQ==
X-Gm-Message-State: AOJu0YzOU4srN0giMVQcz9HLTNuDgjTMdTkx/cgrDcXiJVGCFDRT7kdw
	lxYP5qLi/pXcASUaipFBrU4EBAkbthfMICMPOY1yrD+ovjQF9YzAS4wQ
X-Gm-Gg: AfdE7cnRbv8EzF75pGHwc7efdtuWq5ghkWuv/h/bEJ6epT6E1SqdLLfogWaqb4Iwm0N
	Ecnq3H/J/tes/oWE664p31PSYCvQNfLWf3ppemGKlF4p4rwCp+eKAtsF2vVC/RxH5gz+/PXRngL
	hw+/b1eVADiOmkiu0Eg4BU0CLPST8YYdxwaUt86SKQU19+4x2cZEFCbZ46sNBMbWvxPJA7X0eB3
	0iMX7VcGT1UOwBaYr+59rBE7IbQEITajKcFEvC37Pt5BMkMjGgvcvcSXBdql9ToE3BtdVPxGKis
	D6xdjtzQ7Dbke2YunJh/aQwAT+14G6eH/GpnbzZm4ydbut15Cqgvp3BCtpiw9IoqqjtzUb9fxd4
	+82bxVKeakQDDzpxGcrL3QyDcgq6nucMGTdHJqZip+59s5RQ9wXhaJLydOey+epl2MOqZBpGpWi
	AES7RnfTVvJa12/lUz95HXQMWgfj2HhemLaoXUw24Il78aecTTDuIQof/XD5Ia/u08bUGdavlPa
	+pbrspE6S4niA/LcMBfow2ICl4GnQ==
X-Received: by 2002:a17:902:e950:b0:2ca:e106:8e69 with SMTP id d9443c01a7336-2ccbe615e87mr60008085ad.10.1783440711151;
        Tue, 07 Jul 2026 09:11:51 -0700 (PDT)
Received: from [127.0.1.1] (ec2-18-162-112-89.ap-east-1.compute.amazonaws.com. [18.162.112.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bfd443sm14712115ad.30.2026.07.07.09.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 09:11:50 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 08 Jul 2026 00:11:27 +0800
Subject: [PATCH v8 1/3] mm/swap: colocate page-cluster sysctl with swap
 readahead
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-1-e816812698a8@gmail.com>
References: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-0-e816812698a8@gmail.com>
In-Reply-To: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-0-e816812698a8@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Baoquan He <baoquan.he@linux.dev>, Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783440691; l=6654;
 i=wujianyue000@gmail.com; s=linux; h=from:subject:message-id;
 bh=Bfxm9viN41z6KBcPZ+DAXQmBddfe6h9567L6LJ8GoD4=;
 b=ky/dSOHS1ubZOUvyoU+rjll/uXGIHnie3NlfCBeYsPlGWWDCoYTjQkSKFR/3D2CtOZKdmu3zZ
 l1Lmf6mlXuSCI88/U6HVQ+U+gBW7DP7OttWmQWYNG9bH0X4YJ0KX8G9
X-Developer-Key: i=wujianyue000@gmail.com; a=ed25519;
 pk=49tqjvkqDVX1TtHEyTCiJGlKLg6SQ4BmgzG+HoHQW6E=
X-Stat-Signature: a94im386yab7dznmepus5jnp37tzosqq
X-Rspamd-Queue-Id: 6930314000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783440712-293691
X-HE-Meta: U2FsdGVkX18qOz2N3IyiTTqwQ4OEEqhzTfzaO7y6EkBpzKwgnl8pDRwC57T6II3SFuvyxJ7wcWYfqYFgHOrUDfvTsgoqADj6YriFyFQiWZsLMX8JU3NMw4NkAvKoYDWFT9XHETo5PHlxQx3ZTVbfbT1HGPM63wE1BS3Z08rLdVmncVAzXFZB8peaV8DefHFRjDlk+n6m3cimGkH9okm+i1RZ1wDxStM7wb9OhnMipzLalrBsn4+XsePQ7VgnzfQZhcecAYC+Ng13go+LcIpeYdb0qJFNYsxdmVW66EAhlnCEPckWWnKmyNgUxr3fvIGynZ6lZIZ6/oRUywcW90zss9jAsXB9o/M5LckSoDoKpBeprsxE/p0HnHadyoQqCuNUywaSXhMo65bu/vtyalQ9UJKJODo4iVLUKE7ZWyT6JyPLxXpBTGe+Np4HpsXhHGMGV3qLG3OjPvpVOTjWi8mdrRaizVoUYrwhtMOKKrbmd+4p3osqWFevSkEvl7DbH1jv00n1ZFARftiCE5TLsd8ORo7aFgnQ6DJUoKHP7p45CL2OiNbWmHpP6y/SM/FNJg+wbWzdQTDXmZXZSNWJYhNhonL0zND1u1vNmBvM+n278eaZxAFkOc8sSFc1EWnnBmtS0GqWTCKOm73ho1GXLMkO8Qk3pKLOaHqvYgXkjKZNcgQ4cnF5hadEiGseFzKDezzEHdiZq8nQpEz+nennsfkYdP2s0CSCPxCgAIXh4Vdked+1D9rdzz6140DiHRxqvtOlmDr49BkUdDJzuNOlgSwZWSjoQTfhB3UJ8NZeAgOSOZ79SKDkQcVaOYhE/Ew3tBAeRf6/0B0LVlSfocK+vNesE//Cxt2tA0leKWFGqHo8x1BrxApYPkLfXO/jYv9aeyF22dQsbWLGTIiv+5dyceFF7KhZyJyXvn91XDyNKZSIg0VWgB375c4bkcjm9CgUPCVGSVQXyQvmjmlX4xeWfTq
 ME+XgtsA
 /Cu0pF3VPal+Thxzo59o+z9P3PW8b9QKrjRG510IYsTzg0CJ2Wy2wzeGxPVnYKWIsYdAMyvunRY2VUZALkR5w8Z/dvYGB5RKj5wIMMGHx9wA2uWsJ+HliFa3CRDTwLOSd8HsSIJtzpbk05nYqEnaabBK84JzEnO21Fzjmd9xdHFUGtLS6lpw9pnL5NKEUAK5Nv5/CTJZRIRii9Z4Ug+rqu9qBF4cqxmF/YeMiuL0OelcYQkmhPhN2W+8OnKOqpiKcDpUdbsf1ws5HH7haMSmHkLOM4Oly2C+VG9u+Aw1A7laTE+s8Ulusz6hjiBEVssplpuHGDbtr/PPfkXq8SERpEuVd84oy595hP4pj0x1pPXk7MI4IgoSKFa/JQI1VExYagjymr0VRaCW9ATxvMFPzVdIwS+2oXjN6HDEj9dOa/jvzCwXo0GBgOJQsEXRUIaxyp9fACER0H+maktzciUJ8MGVnhWcKyn5usavzkhsZCdWzjBiKPBSqOOXU2QsaO3htmEhBo2brJit/W7QHCMM8/kWnVjTEicjIdSfwez1P22wnAt8DjYbTIwLONRL/a4z9rw3lXYKoeJS/OOJqmue0D04I+d1lTns6bFdRRi4otPS2R595v6WkHp1kVnU6+JOm6OW8yB+WEF1ppIaUcwrgIU+Dk9G+GdiuhftD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page_cluster and the vm.page-cluster sysctl are only used by swap-in
readahead in swap_state.c. Move them out of swap.c together with
swap_readahead_setup(), and make page_cluster static to that file.

Rename swap_setup() while moving it as well. The helper is internal to
MM and now only sets up swap readahead defaults and its sysctl hook, so
the more specific name matches its reduced scope.

Call swap_readahead_setup() from swap_init() after moving it, keeping the
readahead defaults and sysctl registration with swap_state.c
initialization.

swap_setup() previously lived in mm/swap.c, which is built
unconditionally, so the vm.page-cluster sysctl was registered also on
CONFIG_SWAP=n kernels. After moving the setup into swap_state.c, which
is built only when CONFIG_SWAP is enabled, vm.page-cluster is no
longer registered there. The knob only tunes swap-in readahead and
had no effect without swap.

Suggested-by: Baoquan He <bhe@redhat.com>
Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 include/linux/swap.h |  1 -
 mm/swap.c            | 36 -----------------------------------
 mm/swap.h            |  3 +--
 mm/swap_state.c      | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 mm/vmscan.c          |  1 -
 5 files changed, 52 insertions(+), 42 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3f31b6a56788..45656ca9792d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -340,7 +340,6 @@ extern void lru_add_drain_cpu_zone(struct zone *zone);
 extern void lru_add_drain_all(void);
 void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
-extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
diff --git a/mm/swap.c b/mm/swap.c
index d25131305c94..c88643e56af7 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -44,10 +44,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/pagemap.h>
 
-/* How many pages do we try to swap or page in/out together? As a power of 2 */
-int page_cluster;
-static const int page_cluster_max = 31;
-
 struct cpu_fbatches {
 	/*
 	 * The following folio batches are grouped together because they are protected
@@ -1177,35 +1173,3 @@ void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int
 		lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, nid);
 }
 #endif
-
-static const struct ctl_table swap_sysctl_table[] = {
-	{
-		.procname	= "page-cluster",
-		.data		= &page_cluster,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= (void *)&page_cluster_max,
-	}
-};
-
-/*
- * Perform any setup for the swap system
- */
-void __init swap_setup(void)
-{
-	unsigned long megs = PAGES_TO_MB(totalram_pages());
-
-	/* Use a smaller cluster for small-memory machines */
-	if (megs < 16)
-		page_cluster = 2;
-	else
-		page_cluster = 3;
-	/*
-	 * Right now other parts of the system means that we
-	 * _really_ don't want to cluster much more
-	 */
-
-	register_sysctl_init("vm", swap_sysctl_table);
-}
diff --git a/mm/swap.h b/mm/swap.h
index 44ab8e1e595b..ae81c1fa388d 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -8,8 +8,6 @@ struct mempolicy;
 struct swap_iocb;
 struct swap_memcg_table;
 
-extern int page_cluster;
-
 #if defined(MAX_POSSIBLE_PHYSMEM_BITS)
 #define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
 #elif defined(MAX_PHYSMEM_BITS)
@@ -336,6 +334,7 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 
 #else /* CONFIG_SWAP */
 struct swap_iocb;
+
 static inline struct swap_cluster_info *swap_cluster_lock(
 	struct swap_info_struct *si, pgoff_t offset, bool irq)
 {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6fd6e3415b71..df6fda588938 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -22,10 +22,15 @@
 #include <linux/vmalloc.h>
 #include <linux/huge_mm.h>
 #include <linux/shmem_fs.h>
+#include <linux/sysctl.h>
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
 
+/* Swap readahead cluster size, as a power of 2 pages. */
+static int page_cluster;
+static const int page_cluster_max = 31;
+
 /*
  * swapper_space is a fiction, retained to simplify the path through
  * vmscan's shrink_folio_list.
@@ -985,6 +990,38 @@ struct folio *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	return folio;
 }
 
+static const struct ctl_table swap_readahead_sysctl_table[] = {
+	{
+		.procname	= "page-cluster",
+		.data		= &page_cluster,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= (void *)&page_cluster_max,
+	}
+};
+
+/**
+ * swap_readahead_setup - defaults and sysctl for swap cache readahead clustering
+ */
+static void __init swap_readahead_setup(void)
+{
+	unsigned long megs = PAGES_TO_MB(totalram_pages());
+
+	/* Use a smaller cluster for small-memory machines */
+	if (megs < 16)
+		page_cluster = 2;
+	else
+		page_cluster = 3;
+	/*
+	 * Right now other parts of the system means that we
+	 * _really_ don't want to cluster much more
+	 */
+
+	register_sysctl_init("vm", swap_readahead_sysctl_table);
+}
+
 #ifdef CONFIG_SYSFS
 static ssize_t vma_ra_enabled_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
@@ -1014,7 +1051,7 @@ static const struct attribute_group swap_attr_group = {
 	.attrs = swap_attrs,
 };
 
-static int __init swap_init(void)
+static int __init swap_sysfs_init(void)
 {
 	int err;
 	struct kobject *swap_kobj;
@@ -1037,5 +1074,17 @@ static int __init swap_init(void)
 	kobject_put(swap_kobj);
 	return err;
 }
-subsys_initcall(swap_init);
+#else
+static int __init swap_sysfs_init(void)
+{
+	return 0;
+}
 #endif
+
+static int __init swap_init(void)
+{
+	swap_readahead_setup();
+
+	return swap_sysfs_init();
+}
+subsys_initcall(swap_init);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1474a7234ea1..74b43c12fbc0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7647,7 +7647,6 @@ static int __init kswapd_init(void)
 {
 	int nid;
 
-	swap_setup();
 	for_each_node_state(nid, N_MEMORY)
  		kswapd_run(nid);
 	register_sysctl_init("vm", vmscan_sysctl_table);

-- 
2.43.0


