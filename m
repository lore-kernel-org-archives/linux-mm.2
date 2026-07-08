Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A90C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7F96B00A5; Wed,  8 Jul 2026 07:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF296B00A7; Wed,  8 Jul 2026 07:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6256B00AC; Wed,  8 Jul 2026 07:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 039936B00A5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:37:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93E49A0733
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:37:22 +0000 (UTC)
X-FDA: 84965408724.20.FC7FFD7
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id B5D52100004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:37:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mbw9NJMK;
	spf=pass (imf05.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783510640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9KelEc/lur7aRZA0dSSKGcLt9wGz9DkT1jITO75cYs=;
	b=Ci3We2kbQ4/fyy9316nPfO6X05TQQ7vNdgLEwmJ2MV6wXP9MJ0gf1nTvvZXpmBfM9nbw6V
	XH3esl0h1CkWP0usy5cXRGX9Kc0gPDxCK/5tek6GCmY7WMDiZxc3tstHsWAAspahjGjR3p
	Mzr/yg/rQCCmeUVVRiP5QfKL2H7LWjE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783510640;
	b=zximGUlpRvHHF19+w3hAlFyh1+FyYfAm5CRicxFEP4ayKtFdQbIf0sbgtK2kn79tzuvHpu
	1VOXIQt38MAgQmtUpUxcoemKZDbVukwuAlidSIfav7BYz2K6j4AHR1PJOe6OgJRGW1ooWN
	H+WPcvM9W/Km8GsqZqRN4syk5a/ph1U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mbw9NJMK;
	spf=pass (imf05.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cab973140bso7216885ad.3
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 04:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783510639; x=1784115439; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d9KelEc/lur7aRZA0dSSKGcLt9wGz9DkT1jITO75cYs=;
        b=Mbw9NJMKbb1OaJINYTwQCxiGQT/7dQqOtc3sqV9RzfEePU9dMjRRssHDT2XuZBGXGH
         oVuowiZJoukBWVpMONjLqCENDHaSq9McppUKTdVBNCubgGo/Aib9ArS/3eGPNsAtJPej
         OmWl67okATx95FaWy7Eou3pqiCNfa/9206zmtvDPsrLFX5e3SID1zB/sgaPadCCnCN+y
         Rf6yDOLJekFMKMJR5wV+ZZ/TriaaxJSKTXO3xO81/mnWirfHxtYpb/99AoLKPg8/MpGM
         enxEHl/vIKdQzIPPNCIRneyO+rufTu6+u09rmkmcsLW1Vh8ZwcLVIAkJoOrvGAYVDVaM
         DxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783510640; x=1784115440;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d9KelEc/lur7aRZA0dSSKGcLt9wGz9DkT1jITO75cYs=;
        b=FX3jm4UsKrVwGbMX3uVqIx18askSvHPS1upvTlgVzNs4QEMe6/NDRfXWdXLvi2yT4j
         MDrCmygOw3YcJj+bu3t9EH4HkAM86QhfszgnDVIHgBS8O0k/cwEfw42bI1hA7QYuEH9M
         dIx6BFCxhCKv4ghfVwbGXiL3OeearD+fnlGMUUfpxFxo1e3sJJDTl7VQMIsp4Mc2xE9M
         vO2wUxj3Xx8bwA6Rct504qwdTUgTr7ifCGjROUfeh6eJc61FC3whcFpnT2ZULAyna/Gn
         xHg7OY4yvLH/Ub0i4TjYI6uJIsXkRXpcH2y6yC2d9x3HEJluPYGl8hUUgzxexJ4m+qeY
         mlrA==
X-Gm-Message-State: AOJu0Yx7fj8sEYFo67f+YpfSGFXlONYcLeTfIY98i3d07Np7Lw01CLNd
	roZ9rEHqzmpchHOhRYa4WvBgjGYdvfkzSHoTnsQNg+SpPGDQQIqRTF/3
X-Gm-Gg: AfdE7ckKFYhePmK8K/93OZKd1TX93VR7E35S0UTGwCI9+sqDu2ilw7Q0oHBBtiM4Wir
	zUc307LeEnrlWH6xTDzbylJ1wUAl7TzTQOlNCEoK4cWpEryoZfZmy3PWsn9c0kruQ9WOG1EUzsD
	lfJki+zYGPCa96oP1aCbGsoNsuMR1eX0f6krgl9YLCYUo6A5MTlisYBJ+GczW7b4KFRKYJF207d
	CGeTmNXOVzbyfzZEGr+eVB5cAzHuoC+d0n0MSc9Z+RGBapRGIBTRP1Czl9nf4js4tNSmbZKLucd
	oFRovUSjO82mLYZ588UQnOw50DyNIWcUgXlqW7yfrduHgrk+DZQio/NSOb/dTe2ox+p0cciJf3F
	qDAIbBjURhMYMg6/xj8PecoWbOrSSPiak9mZ7yENCiS/P2e9Ep18PaG8YP6RiZeZseE/ZuIASIM
	8yfAy/3Jf9LCQiRwCl2dvcthIPB5BzwwcWNoYDBJQg2KCfa6P13SiuhlctDes=
X-Received: by 2002:a05:6a21:4d8e:b0:3c0:b766:74f4 with SMTP id adf61e73a8af0-3c0bca47d59mr2582996637.31.1783510639405;
        Wed, 08 Jul 2026 04:37:19 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([203.18.50.8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3a2e42bsm2260788a12.30.2026.07.08.04.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 04:37:18 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 08 Jul 2026 19:35:43 +0800
Subject: [PATCH v9 1/3] mm/swap: colocate page-cluster sysctl with swap
 readahead
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-ch-swap-series-plus-folio-lru-cleanup-v9-1-2bc72b4f8730@gmail.com>
References: <20260708-ch-swap-series-plus-folio-lru-cleanup-v9-0-2bc72b4f8730@gmail.com>
In-Reply-To: <20260708-ch-swap-series-plus-folio-lru-cleanup-v9-0-2bc72b4f8730@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, Baoquan He <baoquan.he@linux.dev>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1783510625; l=6347;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=KGxOwAYZ7vHV9hZpL4rzDKx+pwJ0+0rkmt8rvsjthpg=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QGjwQeFlFTXXA8I17uwgpK0sErgmRpUT6KnOfdqbzYpuWvutuP01WgezoQ8k3H4chJY+Bmc9m/P
 gQCWH7xRH1AY=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B5D52100004
X-Stat-Signature: 6f11fcaeyefnadq86tbrnhwpcbi16cu9
X-HE-Tag: 1783510640-280125
X-HE-Meta: U2FsdGVkX19sYtDL3vQQ0HHO/h4Gs1jFB+N7EyzE3MV+7iJg+/qurKjRkLLlpCQrdW4NQb5VivuI1iyJeBorC/uf8izJPKi2dtsSDeNqy2RWvH1ib4J0CqOpBH3kAY9CLlwtSFnEP6PcD94BYtTvNvMLgsIX7tLFVL+q3Petn3efkbzS5F8MOMT+Y67neonKkhWr3ZwbiBr6I/ex1fgSnaa6GTAW5c+sqKfGW3kcSKytF2JyNtiyLH/41LvY+57P2LAOjzxsFeJhVkz+gw3c2q8Uwo6xul1AxcRsZBzKbfLAX8oN5j2TFKt1/gt6cIQO2hEyj9cTCFchlyDHlNR04TtL8OT99MUNjGYTwCFi8jAelyOSwS6hOWd0pHJ9h+Hu+agX2FCYGU+myedT/7p8g30XkTCObGnx/Y+ZLxIBbgfagtUOobuazwuLpUe86SyIWEib3zkVcvPnkt8pzR6FH7BkmICnkZmGnFBTB7TAjqv4kw1Tv6d5QwqgALPKQLnNmWdHWpgtBjkEh21J8Ea7AZzgHF1eBxO38d1Zm2Y4ysVVdTRgH24LOQDrcVsWziXoEyl1TFHK5g4Ns4qDojIMh+s+sdg/EZvH13ZSZZxB5yQRP5gDtW4+s37tUfWvjDi3DK/megL0zHXjkzDbfDwaI9ClgMzpiUpaR4quJ4H483bbW3jaKYqs/9coH2V/W2vkDRk2652XsGbdxfE2l1DDE27sChAPrX7yO8c2Pye06heg3hj/n25GuN3TX3oxtZgD7yHRMnJsoNerBmk16S7S6epnV1thfzbpSzSuj0lGok8xk6ByHPVCkK8nSrMEn3RXLeiCtpayNNd1tIFU3mdT6uVwhs1FETASsWa9Wc/4wNgV0J7bZ24DXybqYmxg2XZl8FdQf6oMzmV5JNnpqzfxcCga9kEg7HvatC0tj7LoLyxvOY/1/wykaEWuQ3HkvN0qFu9MFaVlzxeDIasaSfF
 Pz5xtq7c
 YFRTaTCeyz9yyeLNDC0FTpvcbctD9oGfuZuaUkwao25k8gwCrpn70w4BiV7Fi67W//wEXRyTchbVhnMaOr/EOA7bEWNy/VbyCpOKvawcfhI5Jw7O1SrJf3/kkKbqSNAPeioT+5aWcMT0A7YCjyIgsNseumtwL4y+8AK19s7KQEE7Tfq8Vj4lb6HS7dykAU3HrVqehThJ2I0K6BdbR5F8IE64f0PbDGm25+9XjebL19q6gnsxzt4oCOSzJ3UFPABrcojbWSRjT5kcqblFlAkxWlTkTIPIUVj4DnnZcPaGDDp70Hy41PxSdhj+k8HMhaNtmneL8+iDS+c7cifGY7KGWyLPg1s4NFd0wXz6dxwuMKJLhoDWyF7psqxxmNeFxSn1CxneFzcDgqWkDgFd5Bf2XKRtHt/1xJPH1CKv0EYN2b3vNyLjSmn/z30JSjpC1tw7ry+dRwAfRhePhE9AET05Vay1AuaAtrfHzcMX9oRjl7UhimFtihNxa9OCUmSPEW5Gvf+MKXXfo5xjooUQVtM84ih9zc6CnvMkkz8HQeNcSGqeAcaZKXXddDJVQqf/LARr6kWPgYIzqn7R2tt3PZIwvl7mua5O4HCTXVKT5XYHe8ZmIA2JEh9ETdvJB0YvRYqraV3D6
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

Call swap_readahead_setup() from swap_init() after moving it, keeping
the readahead defaults and sysctl registration with swap_state.c
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
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 include/linux/swap.h |  1 -
 mm/swap.c            | 36 ------------------------------------
 mm/swap.h            |  2 --
 mm/swap_state.c      | 50 ++++++++++++++++++++++++++++++++++++++++++++++++--
 mm/vmscan.c          |  1 -
 5 files changed, 48 insertions(+), 42 deletions(-)

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
index 44ab8e1e595b..b51ad3071a73 100644
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
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6fd6e3415b71..1444d20a40e9 100644
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
@@ -985,6 +990,35 @@ struct folio *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
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
@@ -1014,7 +1048,7 @@ static const struct attribute_group swap_attr_group = {
 	.attrs = swap_attrs,
 };
 
-static int __init swap_init(void)
+static int __init swap_sysfs_init(void)
 {
 	int err;
 	struct kobject *swap_kobj;
@@ -1037,5 +1071,17 @@ static int __init swap_init(void)
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


