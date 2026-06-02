Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2132CCD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 01:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88CB06B04E7; Mon,  1 Jun 2026 21:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83DB86B04E9; Mon,  1 Jun 2026 21:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753976B04EA; Mon,  1 Jun 2026 21:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 603296B04E7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 21:01:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C2A091D51
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:01:36 +0000 (UTC)
X-FDA: 84833169792.11.FB4E866
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id ED79FA0013
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:01:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pBipOFoE;
	spf=pass (imf15.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780362094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGPIJKEwlEpJKHH4SLNL7cs1Yqvspn4Cra5AaU0HUME=;
	b=S8njgNOsciBVY3NrXmACrjrrOXe+c1H3QynpHKHTCtKjX+hFPWfUpL7DAPdMpkqge96+ar
	IzcSnwMEB7YGtuHt+sYz1v0JdF83wGa0OTVuT/8ZlINuDadwJmDrGRetVDsLhjQLdShPSs
	lYGmz+cSZGSS7bRz3nJitPksi9OJotY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780362094;
	b=MOuBBVM+m1D+03G67ODAG2JI6w92E6GZtsshDgVzs8e1kotH2Qy0ZTkpQZj5sSJmjUELF/
	QwEcaxrhpgem0q9F33TkBx2ouHh+1JbuoT8bIeE5ItGC5lstLAoyXPw72YTSl5qgobIL4z
	YccI0PZvrJy3BrgYwAOGJ2cNVYnutMI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pBipOFoE;
	spf=pass (imf15.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c0bd02d97eso23154675ad.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 18:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780362093; x=1780966893; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wGPIJKEwlEpJKHH4SLNL7cs1Yqvspn4Cra5AaU0HUME=;
        b=pBipOFoE9w/Kl6DimWaNkstroYQ2i1rh0s68z847dMEOAyWrbIEL9donBj+45kN0Jy
         cyDkvbwZDDeJzfe/0cDdw16iWHpcxQMeFn6caYsbXiiDdTZRnBEDdJA+MX+Gdc/Hj9DU
         8DcoY3MiP1Yl0rvdnm0f5uVBAxNWdIhlKzsYPkNwkBtpSfzXUUWJ7K/k+0UgjCy4Em3+
         HJWEq626Tv8ZPx2fudQ3oSQs/qW+byU0enfpccdMYvTLsemWBJCajawNqRzkQIhNH1KV
         xVQi2yNYl1M1KdhSvLOfS+o6k/C2S6njv7DPi23f6yoHezSSl7VdUO/e1qU9aEu2fDvJ
         SNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780362093; x=1780966893;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wGPIJKEwlEpJKHH4SLNL7cs1Yqvspn4Cra5AaU0HUME=;
        b=BRXWY1AV0ZS7wPot2S09AJ/FjUNJgZ1auD6NYolX46v8QO507eNnMgQ50UWx/pCq5t
         T317Ngugr2MXqcEDg5aYCw5EkR0nKlTlzlRhxEnWygbg73yfGzyDoYrtCm0Q0iHezSMZ
         NdJcVi9bovEG/92fBhYUR+nyfEvfUrIf2SqtYe92eaLU4gq9ZKEwL+7BURuzC0SH/pGk
         jyrHIe7lvOYJG6aP9WubURYT7b4SiD46wXou+WbZWQwXyKwPuzoJnXz90XYaGjr+YUa8
         4HiNhMMGZpe2AYx5/MMKKYy30zFlxJ0AVpcYmkCx7EboxrCCpc3yCyCIQNY2APD7Ifw4
         7MCA==
X-Gm-Message-State: AOJu0YzsmnXfcNQyWtzTft0k47ufDvA2PPqumgDclVbf9l2nIz9V3Eu6
	vwVHLe7JiCr7KKNsFOsEXhfkU7Ki6+w6dYyB6mheY1H8GWkPKEyU0p83
X-Gm-Gg: Acq92OGoLq7f1poxc+MpbUKGlppJpx3bpcuEscyPBwyLerZUrQVMTIHt9IYbH2nRzH0
	F5gQlDV5gAilVBh/PO/K9A2B9pE/1FnjOQo6jtfXYjsp3PGKlW6hdrqXQbsX2CoTazqSoEubXmf
	1ShYR7GpMmWUUKRBcL/FpQjrlbzwmfB5KgXpva+d1QWCA5VfNof1cRPXefNSpFtdms+n3lShqr/
	qTLphxtJJM1+pdPUfOkqXe0WFAyGQDMm14d99V7lyfS0hzOoxaUnhUqUy9s7kw3hSF8h0lmCIVf
	tOX0K2RYQRCCeJogDnA+lU0Z2Xow4cirHjRufKqxi4r1HukyRAhdHfjTujtn2LzjLVyco4jBOwV
	XNS8bfgctCOwi4b9OyINfwWOYKIGlLILG+Rcf+LRSNT2giYIf/rqE2i9mSxXR1vVFwAdxHIgpDe
	ycTSOKZGtWWz/vD9NHt9jhriQlkgfxbbMGZC5AF3wCJlGMs2FGk5Ma2IoJnz42N88G5JUxTkKn8
	zBWaRmKp0LJu4wrLjR6aJJnwNrTJeTz
X-Received: by 2002:a17:903:234c:b0:2c0:abd3:32fc with SMTP id d9443c01a7336-2c0abd339bcmr122968685ad.34.1780362092572;
        Mon, 01 Jun 2026 18:01:32 -0700 (PDT)
Received: from NV-J4GCB44.localdomain (nat-hk.nvidia.com. [203.18.50.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239fd85dsm111693355ad.25.2026.06.01.18.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 18:01:32 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 02 Jun 2026 09:01:15 +0800
Subject: [PATCH v3 1/3] mm/swap: colocate page-cluster sysctl with swap
 readahead
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-1-5bbb567f8c99@gmail.com>
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
In-Reply-To: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1780362076; l=5610;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=U//WgOrwvoq/HPdRnaVsUGDxXeZw9r2BdejpXkkxLy8=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QGjiGdfDmt3WVhe35BVC83RzIiuXHwIOkCCP/23I7fR1WOnmaBSSeLPMcQ7kpBgUQbNl1iu8/jP
 lHda0dYyPIQk=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ED79FA0013
X-Stat-Signature: sxicrgahr9cm653zh9tybjw5gsgketo4
X-HE-Tag: 1780362093-299019
X-HE-Meta: U2FsdGVkX18Vh9OdI9/4RIbGcEct9+lZSpHzylARIe2qqA2E+M2pP/KRtc6zI7OuSaFzQkG27mEtk3WUKOQG31G+3hNpgb9f07yJj7fNFyX287R1V29zzGtelAzPotKVvZLdI/AVIaUWJ94wOx8oDDoyym1yoLLDQRl1oCkIDxuyOtg8cpz5pshbs+bKNtUMsochHYeB2rCKc4zCz5h2IBvpy1dogmXyf3nKeAdJrwWntHeJD3pVYvsIXez3ZIk6CObolXnNuOAx25uvC4RZ4qUtHnGmep8IvsvlVEya+QCwcwo8YIqwV4em4GGCFeypeKrXDoSbaRhjxwp4IjSH3E6o3LWif25AQi8ZK50D2ut85wRYVkm7+ymmZADDx2N91znocTUQLbIiG4b4nTrcxlB8ob7n+mmTaAyKFCy3VJ8JjgfoAqxqGkXP4vVfV6jzJhp0uZ5LwnFZGAaloacnzlf7ohvMEG2q80Fc2pEZ0jkbBUfUVsfN2ZxF9ccobarX34bVy7xj+YceYg7TarYbQ+HLewzjCpIk23+F7qYJUZt878dR27bT9bFcZvfwinPh+RMuWddu0wrdBXbXLXPfEnq8oNF9+usFu6JfpUG7XfZCld3YoWj2DJcr+R7F4wbXXaGutia13P4vMrqaakPK0pE9c5gzVciNHvEdfQmO0DZiRm0WNECQ93HX714gHaP9NLjqI4RrtK3abEJxRst7DEGSTjeQXk7OPaiO57jtISPjPhOVBUDsYjjmiJZi9cCYoKxxZUkuVjjPXKi54ubN73OWfznONDamESMoeE6iptD3rpZfvTNeS7EPO07zPoXdwzdyNFWOWS7xJuh4W2eNzgNjP0DlyNH/RZnAccGTf1VYMYf7Mdkm06lZeTkwddnt181pnXgU9fotGCwn7L9n3W0nK0jvPCDFijWjD3sMz7xzMRk0mJ+uu2mt9M7xB/OU/3XVthKIa2F+dlV6km/
 xKXHOWT6
 SiJT8SzBgL8nzeCPElOGYYtIMBtxm2Cqys8ktefDQKKPAOmQRcl8S5QKkwNdWOZN/roiZvTDgcUTTDPWOYNk+C+ryfSN6SftXJ+v28Yx2fn30SRNP9/vApi/MRBwuuP82L8DbPPIEC8qZ2yHUpiZ1R4/ObAapFCutT8cBFBkMrO7vvDsxJWq+XOJrlcqeKp0qnaU1s7lgXpMbRODWb9lWB7VP0AA7vFlp13I1u0J70nL+XgVaE668tHj/y2oH3yV+2dkiWl5t3rlAA+CwUbi7/+T07X4N7HYg2MK86PGxT1AuC62Lx9o+KMythAIY+rEvfgigTzSZBuCiJ6XuFKDujEHbIRnB556rKQD4m4Hii5S2vukLphpm77lJeOVTlVaOVUInUYbFOLt2y+X9VBqTeYD6HmvZB6k91tlmptxCHvy3xPMkZN0bcjclSNhStys18VV5Ag6EwZ+Kse8zalqrPr9NhzQkY8oaqBRQeGmIhOb/BrSzIUiL2G9Hgomt0zvmScmmXcLUAnKKRWwelP/E3krqIg==
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

Suggested-by: Baoquan He <bhe@redhat.com>
Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 include/linux/swap.h |  1 -
 mm/swap.c            | 36 ------------------------------------
 mm/swap.h            |  8 ++++++--
 mm/swap_state.c      | 37 +++++++++++++++++++++++++++++++++++++
 mm/vmscan.c          |  2 +-
 5 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 636d94108166..5bd6f1d5984a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -345,7 +345,6 @@ extern void lru_add_drain_cpu_zone(struct zone *zone);
 extern void lru_add_drain_all(void);
 void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
-extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8..e4b3dadaa6dc 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -43,10 +43,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/pagemap.h>
 
-/* How many pages do we try to swap or page in/out together? As a power of 2 */
-int page_cluster;
-static const int page_cluster_max = 31;
-
 struct cpu_fbatches {
 	/*
 	 * The following folio batches are grouped together because they are protected
@@ -1171,35 +1167,3 @@ void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int
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
index 8742b82cd0db..f860f8c669e8 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -9,8 +9,6 @@ struct mempolicy;
 struct swap_iocb;
 struct swap_memcg_table;
 
-extern int page_cluster;
-
 #if defined(MAX_POSSIBLE_PHYSMEM_BITS)
 #define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
 #elif defined(MAX_PHYSMEM_BITS)
@@ -96,6 +94,8 @@ struct swap_ops {
 };
 
 #ifdef CONFIG_SWAP
+void swap_readahead_setup(void);
+
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
@@ -345,6 +345,10 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 }
 
 #else /* CONFIG_SWAP */
+static inline void swap_readahead_setup(void)
+{
+}
+
 static inline struct swap_cluster_info *swap_cluster_lock(
 	struct swap_info_struct *si, pgoff_t offset, bool irq)
 {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index b9613026950e..e8f1fb37a6cf 100644
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
 
+/* How many pages do we try to swap or page in/out together? As a power of 2 */
+static int page_cluster;
+static const int page_cluster_max = 31;
+
 /*
  * swapper_space is a fiction, retained to simplify the path through
  * vmscan's shrink_folio_list.
@@ -986,6 +991,38 @@ struct folio *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	return folio;
 }
 
+static const struct ctl_table swap_sysctl_table[] = {
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
+void __init swap_readahead_setup(void)
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
+	register_sysctl_init("vm", swap_sysctl_table);
+}
+
 #ifdef CONFIG_SYSFS
 static ssize_t vma_ra_enabled_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2d44ebfebdea..e34f1565f42f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7651,7 +7651,7 @@ static int __init kswapd_init(void)
 {
 	int nid;
 
-	swap_setup();
+	swap_readahead_setup();
 	for_each_node_state(nid, N_MEMORY)
  		kswapd_run(nid);
 	register_sysctl_init("vm", vmscan_sysctl_table);

-- 
2.43.0


