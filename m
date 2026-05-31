Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD7F5CD6E56
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 09:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6FA6B0126; Sun, 31 May 2026 05:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48AEC6B0128; Sun, 31 May 2026 05:50:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32AC76B0129; Sun, 31 May 2026 05:50:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 207516B0126
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:50:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF2D4161B0F
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:50:37 +0000 (UTC)
X-FDA: 84827245314.12.8779005
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id E293680006
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:50:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aQh4gOJZ;
	spf=pass (imf02.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780221036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47mSNDa+DAxlZzYzP+q0XqpUS8vT2CNeajfZ7L+3/l0=;
	b=EZE9Zli3wTzn1eJJ6uU/+qdV8kmUthe/Vx2u7aVgcAA9aVzhZOKMyXRE+yNUdcgs6tCQA2
	GZsRk2FTBF6A6X2GvfNAshkSb4/ai+Qhofg6ZcDuFYgmg49AlUcCC7BmumKrRulZVrGlpV
	6yQYGrJw/rOvabUiF/UUAR3H+e0SchU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aQh4gOJZ;
	spf=pass (imf02.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780221036; a=rsa-sha256;
	cv=none;
	b=BPnvXecr3DHFIPOjrwL5insEbIjjLrODHO7pUhGFy76txgmSV6zpZ+JJ8U7NjyQ5fAsFv/
	BZNjrOViPyRsLWnemuujfaJqkyE3ORGQH1+B6jEn+1PWs4gLCa9AU/9UyolElWtvOY3cVb
	SBNJmSV1Bq2RevsT29vAMBndecg2DvE=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-36d98c9b596so236515a91.3
        for <linux-mm@kvack.org>; Sun, 31 May 2026 02:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780221035; x=1780825835; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=47mSNDa+DAxlZzYzP+q0XqpUS8vT2CNeajfZ7L+3/l0=;
        b=aQh4gOJZiNqnOcfw5ClxFK9R/boKkduj/vEbEEPJrhO22LAWS5k4gtBat7PlNgodS6
         bOeYM/sl1L6dNUGPEMcJ32fhV2hwsQzP1ptXQwbUDcJxmtFR7wuyQEcEDTIq5n63dgSW
         6nSTLPtwuXmb4uOD99A0WO2e5c+MWfhOQ0G5zjf4cze/yF6+FaQZmHhuj6S3Vcg4x9kW
         FmyWgfLAqO8yh1mWrWysylL8whNDpBK1xQR1p4kewxFQ8RgDWke2MBJvnNHx/wDf5FF8
         WGj4sFYNMlcsUQgLjKgWJfTNGPahMZA5C7BtOiPa4lvZq23nEjL7CUe7wElJZj0tFksf
         KQig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780221035; x=1780825835;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=47mSNDa+DAxlZzYzP+q0XqpUS8vT2CNeajfZ7L+3/l0=;
        b=EvPSSug8iCCAMUgTZcmXYVBZRsqYzPJjzPHI1aVvr94RVZwSVuFPC14pfwf4eCiU/M
         b4YbOfkgjP3aafqN9BV56UUpiSCW3UcWTyNgQeDJGpHu53AMAj3AcFppihYD7YMMUr5o
         jIACtSe0pPTeNn3hQ/HMRsfPGFIyNE7sC0RlSc8XJuTkuKofDYinLhOjQAeBpEpdRicw
         /hntzxBY3idP3a8admuNNdl0SBaxJLNIJE/oFNN2/8ow7dVG/S+toz4udRsGxR6e2oEs
         MMAEU7mZsNYqD1TL+V7RHKpkZ9OZAg6/mTq03ItwxHUhIQb9fG97TPEGDZFVmqo4GdtI
         I1Mg==
X-Gm-Message-State: AOJu0YwuyfPyZLKOpK9vbBTAUDUutV+qMeOkhVHC8G/1704O+WWbVaqC
	+pQ1IWfbgECDDAiOOCHMN5YzaRRoBYAhejBKlhSiCditQ1XYBjLkdE9i
X-Gm-Gg: Acq92OG4sU1/Svn9XAjnBFhzJvNdMiYZDoNBE1/gZs8MHbZfvgF+X62kGwJNk8kd3sb
	5dd1OtIPGSL/WFf1RPI76XJp1QatypcEfa1v5jEvSD9+AWTkS/lRpGdmXSz0dH3corXEGtBz6Yp
	UylfUXsnOG/MyW79Oz4kg+29E2m4z9nLuhRX1ReliZnS1PW9iece9d9sUc7m7otmZy/a7CoZaVh
	ak9EWPx4T8zEkXfPtmgYsv8S8AW5Wi2Rothytem/LIl3BhIcsGHGmueV+4qPDQwiyOkbYqydd1c
	r99ts18qjboEEDYW9p9P+6S9Of4zc9aJdyz2Q8lKD1h3Ob7TxWqfQZgjMvNsGG8LyPHUlHP0uVK
	ikYVjhoQQp1jNeTElIJB2vN+9xxdk0f6bZJ6v4lgPh+3S415pZdDj2PO7VDzQ0975OpLYthgNHS
	gh388QKQOBz2N4qAbdT6I5SQWGetd47JeYAdUwMS+6vMOlOKqLNn1ZxFYajEWhg71GpqzscC1SQ
	b36+cjp3g==
X-Received: by 2002:a17:90b:5443:b0:369:946d:32fa with SMTP id 98e67ed59e1d1-36c4fefb47bmr6435201a91.5.1780221034839;
        Sun, 31 May 2026 02:50:34 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bbdb5c91bsm4372219a91.1.2026.05.31.02.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 02:50:33 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 31 May 2026 17:50:13 +0800
Subject: [PATCH v2 1/3] mm/swap: colocate page-cluster sysctl with swap
 readahead
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-1-1b9a4ac255b4@gmail.com>
References: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com>
In-Reply-To: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E293680006
X-Stat-Signature: m6wdmmw99xdbu7xbucw6hm3fagg7im48
X-HE-Tag: 1780221035-510158
X-HE-Meta: U2FsdGVkX1+U7i+2zBouXuNTgqfq601upaqrsATbaFvUeJSrOiMows+6APsUm7MI4GhH7qEcEyBsHyXDtI6Jn60wHXel0cwJcdAWThZGOwAJdI7s23N9NdACT2hmyyVEXpGarSzbAtKrctx0TXl6hHlEIeWkdWbdmX8qXXBswNi8tuoA4oe6xV9ejd4bJGpZAya5BNcorO8+kLzMewv/nXZdvPVOSVz28Vpbk0wg/eA5EgMiot791CpC+jeC2lyOqy90uIsZXaxBhoB9vEvj5jQM9/YR4UqOVJYoC5yJWSGaqMpiKF0xKPRphPT8z5dd6Yrrc6uqJ5mgNthGKRnmWQitVAVEH6RRbk4xfZYnYjpC9nsNPWBzVsJMGBJ7LuYQCW+Bdyr4ag4RSO7VkMvOOA4aYq70rx9tWddbcZQO2C865eFxxsZtSYE4lMxQb9s8HgtdUd/6JHnw2klAYYu11ACSI2u7vwU4jjHw/lzYxVG2epCFF8meMrSSL8yKa+dRF2fnu9pvtja5VmDipqy8BVfrBWjMj1k78m2QJehxNz2l0irH6DE0fYOkx5rfMsuTK5QbzWL1lnEM7Yj6G3NEnKfgFr8k/fxYD4DJmI3YLogG7kfNo0w5hic3OR1WB6mRP/nBdVc57Srao8EuTc8Ldwo3w5+Ee/3OxDuF7kjfNf/pXvP9TLDJh8JdxpTN3OSbvnPUcro43jYqI1FDGEcxErz5kcQRxpgUvBKJg7+47pWweTvsy6IzJejVBLZQA7FPBBwNNXVDi0DWGgkkuErL14dhRsPQDDIvaLZVaIywOE6DRiKwX9acjbWNmdKV3Jr0XUFnK+0jJth9WD5cCovui4UmdXaYrfTLAiuPsyLHE8cNseutFxWy8G35po9FSoRcRG6QfvsxW1bUvEbHekiVY3b2/KCHnieqKOtCfeU5hJZPjBQ1NdaY8O7Hj67802ga/teQJdo4Eb/uPN8wdVS
 xVkNyNlC
 D+JNXo+8NtXl+yFY9dC4l0yjROOAbqWdzn9gszgjgpCkcop7yLO2CzAJZ3UxXaChuqE5By3ePb5r0BKbdrVeWQbMfJpx506AbKeByYgcrvdUMrNO0azEHjtn6yf/Tw9NCsClZNQcMnkROBsAGGKUbxRRz+8zASF1ez3zpg1k9fo9OoCAdk7qy61NivtRm9lTKGWtGae7MsiFws0AmxgJVxuu8i0/VE+C/oX3JEUBN8tIrlUt3s+fqZfSjo2pYENK3a/6rvBlWOtPsXXQX/I3lTJ0znGGacvkH2cSQj0y3+Ophjq6QUiNeIzezW+9WfBZUFI1YduhJC6cpCuh/4MYwm/Kf52aeozIBNLVW/GN+Ytrbn4gxfRRgfuSY289cwGg+WgE2cHMBwukJ87KUW2MT0CmNeR88nCDz32s9oE7RdeAcPjqxOl+Pii7DGemWePFFklulmr0eS2vdAte4ea2GlaVgqDc9TZ0eap7OkPGvLfMddVw=
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

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 include/linux/swap.h |  2 +-
 mm/swap.c            | 36 ------------------------------------
 mm/swap.h            |  2 --
 mm/swap_state.c      | 37 +++++++++++++++++++++++++++++++++++++
 mm/vmscan.c          |  2 +-
 5 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 636d94108166..c36f72877e8b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -345,7 +345,7 @@ extern void lru_add_drain_cpu_zone(struct zone *zone);
 extern void lru_add_drain_all(void);
 void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
-extern void swap_setup(void);
+extern void swap_readahead_setup(void);
 
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
index 8742b82cd0db..1a9b42440320 100644
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


