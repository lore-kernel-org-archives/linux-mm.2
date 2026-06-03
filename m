Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D390CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C936B0092; Wed,  3 Jun 2026 09:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D566B0095; Wed,  3 Jun 2026 09:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6F06B0096; Wed,  3 Jun 2026 09:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7C36B0092
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:05:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E5011A0390
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:05:55 +0000 (UTC)
X-FDA: 84838623870.19.D077409
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1E6CCC000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:05:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pgv0vwuw;
	spf=pass (imf10.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZmim4euVDCn+80CwcLTmPjvLnCY+FRk6xMurYlZYXg=;
	b=hjaojp3Uq+/MQUcYr5Zn2C9SNwRTxiEmFrt2b1O3/5J6s/wXF4FPET09GAeupS/ns4Wyll
	Pz3q6xW6aBS7N50W+morMDTwSBbByBUFjB8dzdl4pt+KLNSgwiUBssZQOHogV/ncxa/ZPd
	Lxu/iuNqsgugctV7z5JipYFK3km9VLU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491953;
	b=PwMuGa/gJvh8V2g9Y4hcs3DiwMFsCNO5lzrNxyFKbwhd36LimiZGQQ+9+jkqhU6/4e0O6h
	gQIfdEu96CFF9y4ZIoUP4+mA/b1tnFnezTtXLVDt0ujYhgo2h+R0olRVZ0OltbVmRGteW7
	FfHEgi+IcWbOnsAlTUaw/fr/BPPEAqM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pgv0vwuw;
	spf=pass (imf10.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8422524cb38so1373167b3a.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 06:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780491952; x=1781096752; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iZmim4euVDCn+80CwcLTmPjvLnCY+FRk6xMurYlZYXg=;
        b=Pgv0vwuwVSIpQoMKdJHuSDBQHzn99G1FqkdMRhgbESlh9TTrxIgJiP51C0CDJdwwRM
         kRIP2M6cFyQxJABL96cpmXEB8SOMRS8PNp+rJbGXTkaMgNeXsX8iEwysNchGuEWAV5SS
         QzkMiGlz6xFo+09h6YwfAJ7qOKfJLXPtMHT1OD6SB9xFhBeU1ZtbUv5PXrhoFMg7sMTZ
         dBFx3ovESKaMGoQDLXrMJ693LJvgpT2MbiddTQBsaAXBoVvCzorc7teoz8dLFFEp/VuZ
         sYw66QH9M1R/KLpfUKiej4x6HWXM1w90sKx6wVUdkHlHtkpe14/03oZjRrZ8IpI75lBB
         k+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780491952; x=1781096752;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iZmim4euVDCn+80CwcLTmPjvLnCY+FRk6xMurYlZYXg=;
        b=iGQVaZyjGQG2L/hvubzyZp1rO24jpiZd0TX4uN51giy5TBSEMaZFGANmA/jEn7TELg
         CSRfqjCIlF1okQqDzw2ffUZIYP9pflOktcxaK8086BCfjTDWtnOcOykvGC2uuO6JGxWK
         fFKTkzN1OrpDRCySjfEWrhw7BAQ4j/zxyz+IqC7TEWfNwi9t2f7VUC4c9XRRKq3Mqd/v
         pG6Jrf5NLrKwu4RR1E2k/nbRQKeA/qAXzP5K+5Qi8hOVHuDDazYx3R1jA4n4lcC8ASrc
         8lk7Sn2fG/Yq2BHFFE3Q9y0uUh9UidONwzewOHFiQ+X/S/yyg8SYeip5vldVA83NIqrM
         5v3w==
X-Gm-Message-State: AOJu0YyvwiokR6YTvdAbFcQSvurETXuoWXrEk/wsqaXX20Zj1O+6f0oB
	f2ZhTQq5bBJ2XgkVq6aw3Xpg1aJfgAFD1uwZGmK3jHy9928b0kvrU2kN
X-Gm-Gg: Acq92OEgKMbQiXZPNqs+XlqROJUIZNm6/TSKRhsKyqebrJ8Dc3IGBf/In0GyzPE7iC/
	xtOWjEK9IcTNutM9GJ//n/0Fs9dnbtmftqHZfy6pWTmOilADn6BRSfx8AQnp+Zz6moRP33ms4r5
	MWgLWK/zFzpnrMYipj/5IbAcClTqYrBoJR6E+DlmdN3B7qkm069GA/pT82J4YsBN2fQCcQjgQ74
	yibOWZS/bYG8cTCmkrgFZxCs9YzaZZ9cG7O0sXFl5HP+DHYbcOi8RQMB6Dxex+Q4RZnClQutb/i
	gT/0HT71GuVXsvU0R+o943Cqc5ZDmdtNY7Q757Smh7LIfxK9xsULexouwT2hvetVZNu2Rv+/FWc
	v5zexFsltTj8MsFCEs5cqY32IyDlwWBT/LDfglcBb9YhuoTSxE7f1N7T7UpDXY8Ogz7R2r/FJKf
	wzW/O7xZLaYuTfWXT+yVckM5IpxT/YQucuyLhgEhQvnqNY2inAtAmTKViL6tzcclPRhmiYHBk8M
	2Kjl2ryUYI=
X-Received: by 2002:a05:6a00:6c86:b0:837:e9cc:d470 with SMTP id d2e1a72fcca58-84284e3dfd9mr3361328b3a.20.1780491951832;
        Wed, 03 Jun 2026 06:05:51 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828821d0sm3018661b3a.28.2026.06.03.06.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 06:05:51 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 03 Jun 2026 21:05:32 +0800
Subject: [PATCH v4 1/3] mm/swap: colocate page-cluster sysctl with swap
 readahead
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-1-ce0219e100d9@gmail.com>
References: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
In-Reply-To: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
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
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1780491936; l=5961;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=B2zySw4XfRB2t18q7HPRhKqCF62NY7gTd3VMGsHZBCA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QCBfGpKO1jJ3e4xC0R/6gCIE6NYRVNWuLXftrS8cDrAnF7gu9fkKd1hTFnTgY8bBkkBWjlsSmjt
 xBhvb2olpogg=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E6CCC000A
X-Stat-Signature: jg471ykzhdmz9jpdn63gs9mcu6ga76ni
X-HE-Tag: 1780491952-283142
X-HE-Meta: U2FsdGVkX19q3a+ZmOlNjCNxHQ/LW4TXFGQ/lp7s7eE4mNUKgYEob3E/bNfTyiv49aZ+lcKYdmqWj4BhD8+pIfEkK72ouZ4aXr1r+xLzRoTA5WggXpJ99iOw7DjpnExL3SXykfqZ9XDexoQ/GnevZTAX6hXGo095GcJ4hee/66PiMZBWQ/HBIZ+G3v64QbJZziKkhebta4cHmfE+pgXph/sqrPcL6eZEs+I6LkNzrkwDHqXvTJeSaVjN34zt3rSpa079QyOC2cWzdK2LWFweIXvjFZyh+bx87x5iNPe0Vy/gID9pGlnqdgCFSYmJztF/BIAuXL4GP0Zq6SovUwYUq2qzYnPekC7jMrQfXD2rBNqGhAV99OrJ2rCpLch1TXpdEyhNCbKt6zcO3XO1rLa6Th8ACDlbqqt4obt35bavcz67yC9yhJxaG50wzVJ/tX/CHl5W2Cnn+ypDSEGD+1va6R3f402Mc0vTlg84eID+kkRWpdB9CQPcjsJMTFVcI63jW0eHyD2emXQOJWzC2oLfM2CKSrtp/kMENfZ5aYJlafWoVSzC+ozcMPtDcJqZOxqEQNPu1ifOZpNe/l3vAqQMiRQCcL8Aq0F7iUblWN1fiPAAhenlsE1WJTOJw3iXfmhSFokfXUxrGt+8zhnF2B8ET8wnbnc3lyoTRqPigwPlsqx8oMarjAk36Eeku0o3DILV1R0ppNOwmkn0VMSzEmPTeb0lULbOAemqEH/k+RElUPA20q6zOeINtQaEUsXU+iJt7GbyL81EkAc7Fdblb/d6Cr9giR3CP2BoOfVymmo+Llv+gWrGl4ieFEJMSEd8LmMhjTDn71VHWJ4qreraQH/Kmzxf7DsRmphbs4SEBSgoq7i3O4mYJBScAdVij7Ax6v4AZiVj0+ImHpvFtlk+5sztZAMTPmcoFQWNbIpK6vS2KVvBTdXVCwGEIFWMy40PFx+TicIjPhi6GjgdLVHhfsr
 A+QKMHez
 ZlrMtjm/NvXR7Y7oTDtW21bVKQMZCBSMclEM8SWEGRdO+98y3c/LfTU4eIb4U9RiEwv24s1xFXmWg1AL5OJxS8dNn0o193vY2hXtoGK1AszIG2VFIx7ao9nApw8Pz3EGDpdE89W0pz3TU9/a8np6m5+X5rvjwCKqgPtwwnpvhu7Z8b1s3XZVsff7fGMaeRYJq6fIiB/v/91/EKzx+BhlUcglPz4GRDfBz+pzmOU1OEx9Ck1W6yjDpurDDKIomibma2gy9Qcz3lxQaPXCHpnSHkJnqB3BVzL2zyxrskpsquoBMtr2KYNJC1+6ukuY1xhB1NPHjjUI2E7GuU04l/gzvm9BosXEeqamp4kBnh6D7E1IVwSE5CHV3nQzW1k789x3rH7P5TEaBe5Gwwpdr5nx40vGPDs5tlkWvaB8FAKLvNJaaHtTxcG5pMggwqGZbAzFxqjUBOQIuuLMKwVKGfNIhjBFP5Y4cstmk6Pt+C/lz5AXHMbJrhjpv+LAxr8rKwx+KCbPBvmEzLiLn8vHEhNQ6w4PTGg==
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
index b9613026950e..692dfcd89bcd 100644
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
@@ -986,6 +991,38 @@ struct folio *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
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


