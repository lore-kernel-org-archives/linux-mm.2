Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D42C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB626B00B5; Mon, 29 Jun 2026 21:08:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3446B00B7; Mon, 29 Jun 2026 21:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4326B00B9; Mon, 29 Jun 2026 21:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C03596B00B5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:08:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BE36C16FD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:08:36 +0000 (UTC)
X-FDA: 84934793832.20.F25E7B7
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5442DC0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:08:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CKYJb3wo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782781714;
	b=2qnL+mRHFEN1ar0JzSiT26mM9BkK0qowwLRBIFSNPTZ018G1j9KWX5mlnRn91Eq1jPX1Tb
	U97FM+K4dQoPPFbXB1xbBX9AJhn2qhwNlPhx1FSywrxPUL2jSm9juLbjeLupdWteqqITM1
	nGmOoX9nq5VP+WHklZV8b+eHycICy0o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782781714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJUOKeF8iBbH9kuKTuF3QvNMT8clYN8OLshkYoNx0Kg=;
	b=F7smgeRBTGYrRTPwJdEihkOqz8g3mUsQh8u7t8tBV0iB/GhCeShWMMhwmFxV22D/m4Coj6
	INwcYQBb4MOopiaQtyVwjTnqea9karrvOKHuf3FVhlaS36+mK1TXBI5NDGUJYt6Aq96nz4
	RClegP7m3UBpodYe6+lRcZNLpBRpvQM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CKYJb3wo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-845eb7b96feso1075943b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782781713; x=1783386513; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MJUOKeF8iBbH9kuKTuF3QvNMT8clYN8OLshkYoNx0Kg=;
        b=CKYJb3wopsNFk1+mQRzTCLx5os6cnySXgatsGyItMuw36e8F7V89XxIyF4dc0kY9in
         yD7bje2lZrujuM/W7mcCUnoZOuM6iOVUYym8dao0DvW40GJTXpIdicg9ZfEDRlJmA/5G
         UDSmyB6bmvSZf24PcpWPz9/GjiHsnZuQ/zmI2IUXg/U61cdkXiHAR5bIX5bz5KZFjEsg
         FvwJ3CLakYRuN6Q2p1HWIyxFbPPvvUNjz+rdE1D3uT4JyDK+4pLIFMszILWcHyuimSdF
         gz9uSRcp2ZDdQgyQSdEXL2haWpSrYVHBqQqhTXd6T8+ZQy8yiWFLm5dDp8o86Ct7cbjE
         pUWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782781713; x=1783386513;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MJUOKeF8iBbH9kuKTuF3QvNMT8clYN8OLshkYoNx0Kg=;
        b=Twwg2u7ua21pDsChHyKQ829mtG7apbT3qO7MX4gIwNq/iRaN4r15SWmviFa7xO0R99
         wDzW7vGS9WByiNXD2K0PgHA4gkr8S7CZgVPBGX5u7TBie6VAnQ01HuoleAP9o+xJccDW
         HLc3SaBPiuHimaOhcQoeezzVbxCnnwY8X1LyTMNFtYX8gVL7IDllyA14HYSGRbs2WjcU
         vzZMcUSBqbnYRlQuj+W9+SvKNm7Ju5X/1mP5eFj11bHB4Fg2mX+u+HdCIdBRIOght6vn
         hxXvlIVZGXKzkkCUpcwT6e6/w/mHge2grO3uDA2VW5AxgF81Y1EMh0zifWv3uuI4FiBo
         EtdQ==
X-Gm-Message-State: AOJu0YzZai3MGn3MZQ2+QmMrROJ7Q/SWVJuiWhgY5JUQWHM85UlK/w+H
	+/u2VSaUzMWLCdIx/mwltmEcCZge58wOhpk0phClccxrIa9FGLZLqAlV
X-Gm-Gg: AfdE7cnFO9+Juj9HPx0+UvtynolMmrQY0mQUzFik2ifVsfUClqlcjYrupOoEc+i1mMH
	gK+v8lhwb8nJq8ixe57RH2thIj6qJS9zI2lPuyIWWH1bIZgEakORTf3mHV21y12mY/bNP1G4wy4
	nPWeGNcahCiArAMQeLQFhGFH1U2a5N7Xdv/G/ooaHOOBZzQhg9UH2YLClRyUQncjWIiA3QRn7fV
	jy0AV/GGxSdGSJl19+dKlm+BYgvljj6xMbUhsxk96LL6YoywFUZztlfEEFHI8QpWhwr7UsTpAHM
	jjbtJHCcntp4HI/EzfDp5waxvRj1Jj0okwBoXUUHeI7MBDW8pwfE+JKbUV2L3dY5fDYksB2KZ/Y
	f3Lq5uyw0WQlozF7nvPNiAVt9Fm2yN6TAvwttmSnVl8GY1KkKPbeDi71BNbF2GH9kJVNu/t8y4n
	CkCgrRd6ZtGFyKFQwYIlI3O+XemM2ZQuLNaJ+6Et94TDpAtlcuS9KB1Vn41NKfaqAfuUL5rQ==
X-Received: by 2002:a05:6a00:4214:b0:847:99bb:b6d8 with SMTP id d2e1a72fcca58-8479f17addamr1209373b3a.26.1782781713116;
        Mon, 29 Jun 2026 18:08:33 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([203.18.50.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a005afbfsm653310b3a.27.2026.06.29.18.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 18:08:32 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 30 Jun 2026 09:08:17 +0800
Subject: [PATCH v5 1/3] mm/swap: colocate page-cluster sysctl with swap
 readahead
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-1-4627aba8ed1e@gmail.com>
References: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-0-4627aba8ed1e@gmail.com>
In-Reply-To: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-0-4627aba8ed1e@gmail.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1782781697; l=6043;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=5H6jS4OceC8ZRadpvqo2NMSUlsJ/HouhQ86dEL84t0Y=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QKgZYDdWdy1yZ0mK8Zmk7hRvcQzBrf6rOmRUfAyEDmVfJ+qgUx/f/r+vxV1famtvuUJ83DLryYi
 r6hZdN0vDAwM=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5442DC0003
X-Rspam-User: 
X-Stat-Signature: oyr3qkmbcibbzqc3gagjohbx7xgpbbih
X-HE-Tag: 1782781714-727209
X-HE-Meta: U2FsdGVkX1+2FMhaC4tLXYv8D83tBNIU7ua/QD1BC9wj2ER67OSaBN1BHpNmjCfD9gBu78UgTvn78ro5nyuLuwiHA27ybWEFTX6jdH/owZYMeT4mf6+6D8A3Kd0ml9Akw/06VD6AsqoGQ3FMp9jiH58+AIsr+TpiIQTDDxqX3tOkBfKHUWbH2IcR5vXXemFEggJ3vPiXe2+yBxxrNQgSsMjUjSWQd2YQftbNtB2kgkTtMMX8+sbP6pLdd6b3mI4TBWKT4M3y5+WF1xcmjYYZvTxyfAVHLSYgIEHFVOcB9MBNGfUFa5Frc2I41ephXsFYCNe8ZKHN6Uqq56l9/bWJ15knvoIXqnzscFaykwPP6uOYs+IehwVFZdh/f+jUH9rhRLcEZHKaoz286JL/R8tTTKY7YRSDm1MjzK28XHRqvMF9FNIMo0TUIUCq3umM1LyJJ40ag0z1HpYJWzstVzx+8ZQ6Qnn4Dktar1VzZ3rzF1iwFjPhQXffj0BM0p5SeUJlgQygRgOT8euNnOwyzJwZvPvdlfoiZvC/1nIE3CUD8hxxD9dpntt4O79m/J78ZiWvbZvO7oWv0h/U8Y9hMJeIEqCrgDfarJXeLiC91S4qmSei/yS9pyBOWCjPt5X98BsHRDZQWrgDcQ6Cl2V+FYeD6qc3hO5PMtySgnPeAbkm9qR8OB7aRcHICvjeRSCZNTnL0FrXbJpVLwGE/zQjXKIKhzcLAKnYBth/f7YhE0GAqEopxliiKogoWDWzx4WOWQzMKffHthkq5Kxg8ivY2+kcsIV3gXJaVQM34YmVXo8gWH5+Sk+CoV/5/NXDkBtApWl4yMU+lIu19Gxd0hSO7vWhjPicWE5JiKpGsXas7DFXpY0tKHhsfzPpEHn0vthzvtmGqZlqgblK29e+9OS/qYolhXj//NsnGOxXry2xDKpg+Zz4yFyUfbw587h7MHlJN1I8pt3zPtz6c2avhPVO/s5
 SVq+uPiu
 8Tly1UjtdpbQ5B8E4KqsGW3Xru9Njp3e6IV//DB4bx0HNDEPZHGsI4VlHWRxE3GRGMYOhGpCojWl270Ha2rNUbeOVBBge0zpyH9flT+CPGyIfLJYEL47Rp2SPHLixTB1S2pSjwwN46T/wu6tX768nL/I5VjD6aMh9XF51liCOS1xrK9y6NFJADbOJwDgcg/4ENdaQiAJe1CvS5whDw6ve1WtbTRd445P+/SHbJZHC3DA52TH/WkLYysdnEtm3FC2NYdDoKNgocUB3Uacw70j8X+gdUYOMX7jJC7P4G3UwFdhA+D4NlnXvqCeSQJs22Tn381FYQB65KxiB30V9YpHBDX7NYljysNP5l9hnHrUJ3FZcu2OxXSZpE20c+/3JfC6/JFnGr8ZcasEIA6Eu/vFK1sXQpC1yssIuNbZvhwhhXMIkPuYDwHbeYCfyoyi4AbITwDmhmr80Y7G0d18g4DslMpmqp3+7c51uIjKEEzxS3xODHs5IEk87A8Ogfw==
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
index 8f0f68e245ba..48cbcbe534bd 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -346,7 +346,6 @@ extern void lru_add_drain_cpu_zone(struct zone *zone);
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
index 77d2d14eda42..0911bdfe03f0 100644
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
index 9c3a5cf99778..d06f8bc46e77 100644
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
@@ -987,6 +992,38 @@ struct folio *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
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
index 8190c4abec84..ecd92ec21ac5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7654,7 +7654,7 @@ static int __init kswapd_init(void)
 {
 	int nid;
 
-	swap_setup();
+	swap_readahead_setup();
 	for_each_node_state(nid, N_MEMORY)
  		kswapd_run(nid);
 	register_sysctl_init("vm", vmscan_sysctl_table);

-- 
2.43.0


