Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB022C44500
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 14:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5B16B00A1; Sun,  5 Jul 2026 10:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD666B00A2; Sun,  5 Jul 2026 10:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3F16B00A4; Sun,  5 Jul 2026 10:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 517F86B00A1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 10:13:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4B26C0114
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:13:17 +0000 (UTC)
X-FDA: 84954915234.10.5AC949A
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id DC334A0005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:13:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pNY4SqMX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783260795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGC2Ga0WI22Vh20UZ+KA1glCOikUfi8xAvRltv8rDAE=;
	b=4SjF/76DuE4rRs9RTbWTD58YfWV2XSpfGI90hHNgX+3EPN6wK9nsSDuHiIpUX3KQHMcffP
	S9rHwAPSGmq5RcYeofHfRrI7vkVWmt6UDK1GG3WzI07KSVVp8ORuQ2JN+plpUm4FIqbTyQ
	+pulCQptpCSWsJX+dg6iGYQteH+YwkY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pNY4SqMX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783260795;
	b=BwalzCBqtWwwKp0tvVTAZGkx5armBgRtVaa5A27jAUA27JC5e2AHwtn4dVr96L/zockcze
	gWG7uxJVClQ9f4Gx4RrcXiJPDTlmt4Za8ZL4WcIwhIetW1xR0Ssx7MC+UR5ZbBlJWXesyS
	P8A5t9JG3sCQ7ZM4HKKdd2DiDZ5ndBg=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cc73e322dbso6890855ad.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 07:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783260795; x=1783865595; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AGC2Ga0WI22Vh20UZ+KA1glCOikUfi8xAvRltv8rDAE=;
        b=pNY4SqMXybFHOYLedPLaQU2pEVGV+AUm4SuqgUcJbcf5FaNCymV5JTUzxDCyx5xV+k
         OX2XkCtjsZbqgR5MvVnIEDdXJEL1K/cQ6JpEScWTsCG1enBtxGkIq9uzCCj+6TZXMl5o
         P1XoebpMVf9ouxkTaC86e0AYaWpgFmf7oTnLpaXZpEcVvWMB346StMuUZ/wa2aFNZWSO
         m7APyGwzoc9b1R0GQv1+wPt2TE/DVRUvvc0XzuUfMwA2vmw7wM9JVEH1+7XjmEDAOeBQ
         TqZsUxkbC6hG13ZG0+TwHRQ0HkqckcKIX4ojckHMs2+0gTq/53oDGZAexXceucXi8Kzm
         2ptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783260795; x=1783865595;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AGC2Ga0WI22Vh20UZ+KA1glCOikUfi8xAvRltv8rDAE=;
        b=bCOsNpyQXXw+RGS/XQ1bTqcxKPRMdKjxZZyQK5If0he3dz26a3B58epwRs0l1Sqyo5
         8U8agtmJNXJ+XI5/eycif0qLD31hxvinoerq9cbM3W7h/W/P4Es9VJfR7PWZZgMoUaJZ
         E81j7JbEFPZZEomYrC62xK83xSjr6SD77l2uxLXr+tsQPWnaPOyg8r8r0dvfpx72D5iu
         PLQ/dFTuB5zBeXaygVwHX6i2noT7bHV/e2FzNbPC+fPx9DJYbgrYDxjdB0cqus/QxUwh
         0EVRQ8sZOfFp5sbpwgJ8jfN3+0oZwxreqDIV6yXpw1SlxggQUex7AMh0h4rEUaL+S45O
         efvg==
X-Gm-Message-State: AOJu0YzGzO2M3IJxA/ewZ60o1/+yOreqLqL47tsvVzYBdj7QUMIzlUgQ
	DOp9IJJMyV+Vvl9i4SnJ3bgSWuUIJbGFLl3XQ3exp+y8p366aKqsL9NJ
X-Gm-Gg: AfdE7ck8TfW+HkC3/oVZOo+OpQ7Ypct9VuCWR/b/8wfGhxDHcVmakTJlg48qBkB0yAH
	WvQeA3NNwcIv3Vn/p0WcwHlg7y9sabchNuz/SqArWPYpTMVeD0KF71y/zOcvdK1xrsKAhoPl3t/
	qKCTmk7gdB7+e5r4y/Tc2Ho/muoSCL6WR5F28+kvxw1+/PzwygjpqADN3Nz407FIxgV8bTHy0ic
	IK3zISNuDjdxqCTrbypFpDU9DBRzwdDXl1TQoNOWBKQKlZkC6/EMjqONISSfAKiNMq3dZQGoeFy
	QFiksiwuTCoFxZ91FLCSqMKfG7F8GZpP4gn+wUYA1fXX0FrokUtVwlafZHRGcHs7O6WXTQqN/F0
	dng1NQFZymy/3qM5rTUMFQ1u+k1B3kF3VHoJU2WCo5LwcNiii3k6aFXJNrovOZNWort2h4fI2y4
	xjdUQtJkx/oOiti97kmIPle546pvmnD8dFxHoCK/gYJWDoOgU/DWfoaMV90CYOvIlDE+gIayLDs
	g==
X-Received: by 2002:a17:903:943:b0:2c9:c6f3:457a with SMTP id d9443c01a7336-2cbb9eaae60mr66571845ad.31.1783260794464;
        Sun, 05 Jul 2026 07:13:14 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad6f260basm34169155ad.16.2026.07.05.07.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 07:13:13 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 05 Jul 2026 22:12:31 +0800
Subject: [PATCH v7 1/3] mm/swap: colocate page-cluster sysctl with swap
 readahead
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-1-a028e8b5fc3d@gmail.com>
References: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
In-Reply-To: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
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
 Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1783260776; l=6143;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=/7iPqMA5mKh6rewx4QRPNnz3zQ/Y5wisYDNlXA9Fp8o=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QIX6ahO5IjnkUcegFAIck8lY1CahYT8PGJfzeSvYxhb0QGvAHsWHlqcMqn95hEZpHvjv7qk+sUk
 gPAMtOuwHDQw=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Stat-Signature: s7y87gs8xb3ah8ubtbu1fh95cq8upmwn
X-Rspamd-Queue-Id: DC334A0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783260795-371923
X-HE-Meta: U2FsdGVkX1++WrYswxw9hTBQRHwzht95RchviZbzMohUIqnwqSxOIfaZTOb388Y3wdSGDSvMF5fcZfRhlm4KROJQW00RiRWywAO4daKNj9xYXsT/8WriqpnACPUbgrZ4zWzMxx+tEznVXeLgXvQ8EeRrcbqEkKqi7Qy2IUivSXxoM1Lt+YQNpzYuMpIBIG941LLzjylOn2970EpSPUmAsZFbbvXYh8sZjGOXg4F1Wwdbn82qf1RJb3hxOaGqp1m76WBx23fxl0WOWCe/9QjP3+mCJEQyi28pkoAiXCo0R0NmgSZNqzDcASZ4jYChkBW5ytX3LTM/O9l5qNNJqYVt3He9+meonbAe4KGYzT1FvqM76WU3qEgLZbXvf4amC/+kYX11ARQOMJuLmN88QxUWrZopVhrVqKjtiMzyowoMqC3MAxijxE6562uhe8yWfxsKuQxmD9J9Opw2qLugreV/MJkRfZDpk2JFcO9MiuaScWqfi8Vbd5Fsn0IpFHMFd6xOvQmYopygUJdnttgKb1nyqXC+dtPO9GIcxaR6jyJpSmoYs23ZpFAjZB7QIz682Jmzu01dHK7TrwahDtRKU4ldhSM7kKITV8q7Q1ktu0Vae+eq88fBvCPaCko/c6bKqyigjJ5CoDdUHcXeSbbTq15WwyYfYAdqvf0kB+eHEtvJz8RjOmU0v5WJ8uFK66Fo18avcXop1DXCWKydSwW4NBw72MuuLouSnXahixpki4ybqE0O4vbt/fIe+sGy4q3o06spMnVEf9oyY7UHIhWLORxMJJoNk1dNqsmcMr3mdaPBm47zYf7fgJbFTn2iPqrtAiK0LfTF9pJ3SZSrasKk08iP+JbkBRljC1c0ylz9Gj1dsNRDngq93g/QCkqETcmPd012B784k9iyjRpsyVM78WklGpBYPoNgstB9PrxssEpyGZomg+eV9W+tTW+nMYRw49WZjzcqVXvqhO72IzIyjNP
 TutOD+nd
 WE0crfbPdRKWFO4a4HJlxdW7Yf2ZL5uGac73zmFvQKl9jdJZ4Qp+zESDdO4Qc1WssZprPHLMD6TRr9xw/eB0J/tdIdMK8tE3r8mhNJiIjvD8l5BSqWIPEKAqBtIEonPLSB5pn91yrYSZT7b79HfzhqYr8L92DT8uu9cY5rdB2Z6+lOEfMEOsHFLkXlBQwaV1KbObIlAknebtmkbfQz0F1zvST1Ecq3tAyENH8MMyGiTqSY4TPaldARkBAKQVNWPv061INZRCVHt91vjmDX6B/2xbj8aPQGpr2x+Q0kmrWRy021u5LnMbqxBhVpjF0XzzhrThFwVZKfO6pugQg+NWUTt9PxGK8etjWeps7koxSV7MJ/HB63qsAomttBM9xPaAg9khczx7EGG9KdQb3E3Ul3TuFuZziTJRMxgt5TCE0G5pqSaW9KTLPXardsH+r9H6C0a0iQw8g9guMQmckHPWqWt0qdhzJHKEuaeRChkQDhCV9PHUlAOZM8Y+ggDR9jqio/lN3WFhrK+AH14Z9lHRwXuGGxyA9ShAGq33Xz5Sj2X7JEHqjaZ539y34uQ==
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

swap_setup() previously lived in mm/swap.c, which is built
unconditionally, so the vm.page-cluster sysctl was registered also on
CONFIG_SWAP=n kernels. swap_readahead_setup() is now a no-op stub when
CONFIG_SWAP is disabled, so vm.page-cluster is no longer registered
there. The knob only tunes swap-in readahead and had no effect without
swap.

Suggested-by: Baoquan He <bhe@redhat.com>
Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 include/linux/swap.h |  1 -
 mm/swap.c            | 36 ------------------------------------
 mm/swap.h            |  9 +++++++--
 mm/swap_state.c      | 37 +++++++++++++++++++++++++++++++++++++
 mm/vmscan.c          |  2 +-
 5 files changed, 45 insertions(+), 40 deletions(-)

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
index 58e4eff698cc..b3ea30edbaad 100644
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
@@ -1176,35 +1172,3 @@ void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int
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
index 44ab8e1e595b..624ea8ff3d0d 100644
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
@@ -79,6 +77,8 @@ enum swap_cluster_flags {
 };
 
 #ifdef CONFIG_SWAP
+void swap_readahead_setup(void);
+
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
@@ -336,6 +336,11 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 
 #else /* CONFIG_SWAP */
 struct swap_iocb;
+
+static inline void swap_readahead_setup(void)
+{
+}
+
 static inline struct swap_cluster_info *swap_cluster_lock(
 	struct swap_info_struct *si, pgoff_t offset, bool irq)
 {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6fd6e3415b71..a9f5b944172b 100644
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
+	register_sysctl_init("vm", swap_readahead_sysctl_table);
+}
+
 #ifdef CONFIG_SYSFS
 static ssize_t vma_ra_enabled_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f40cfe9d703b..ae710027d546 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7646,7 +7646,7 @@ static int __init kswapd_init(void)
 {
 	int nid;
 
-	swap_setup();
+	swap_readahead_setup();
 	for_each_node_state(nid, N_MEMORY)
  		kswapd_run(nid);
 	register_sysctl_init("vm", vmscan_sysctl_table);

-- 
2.43.0


