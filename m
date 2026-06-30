Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C725EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4E76B00A0; Tue, 30 Jun 2026 12:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3546B6B00C6; Tue, 30 Jun 2026 12:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6136B00C8; Tue, 30 Jun 2026 12:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CFA9B6B00A0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:28:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FDF5C2FF7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:27:58 +0000 (UTC)
X-FDA: 84937110636.12.D1DE82E
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1F7C74000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:27:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bY7JwBsQ;
	spf=pass (imf17.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782836876;
	b=pzy0LewH98kiL+3f4Da4TUTfhWZhrrmFIprQpdykC3g+0bRysdSzOCM0lnsuk4k9PvXaFf
	cnsp0Sf6yhs2z37GMMPkqV6uU9sxfX1OXVFDTVjSABc/PikmK319Mw2jp/H8VAIAnuge/H
	bCzk4OTflRsTkxtJI/gv1TV+QRHOFYY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782836876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJUOKeF8iBbH9kuKTuF3QvNMT8clYN8OLshkYoNx0Kg=;
	b=fKrfZpEyUAlxl0tx8Ka59LbHdHhA5hQ8HG7FmG7qdj9n6tJ5GUh557WEp99Vh9gVreAJHb
	QXCG0WCHcE08cd4ipNFQ4nfZtiMhyXOG1hsQnRwAUlfO+wHsIBfq8FMRA3UIir6koR74tM
	jy6S/j102yjcCB2n+CIcXBvT+6vOJJs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bY7JwBsQ;
	spf=pass (imf17.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c9bd2f8bf7so6661045ad.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782836875; x=1783441675; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MJUOKeF8iBbH9kuKTuF3QvNMT8clYN8OLshkYoNx0Kg=;
        b=bY7JwBsQXqQCflhRAFtZFQva+x3DM0KnP+WbVPH10cFl5sMVmnHWLd+hqwLyjl+LfK
         t9Q+ZfNSKelz35F/3/oXSqFKaVIfXdtElzdyCLPVodYD9wf5FKAsK7Db7wJ14dRkdnlV
         mbUZ9hbib0wLxDCRpItMIVy6sPlT/3RKMqmjKSmjgfE/X8WCPP9684jJtFWsZ7oqx5rf
         AzKDig3Mh0cj/jNKR3bGdUv7b1Kof/v5RL2mLlW/tBOxMSvV2HVivdVJL6//pF0yeia/
         MieZWMZCQ/fwvJsqpxxoZ8gj04mrjMslC1smiWADNw27Fd0A9f9lqPExbJJ2rkHrI9tp
         4DUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782836875; x=1783441675;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MJUOKeF8iBbH9kuKTuF3QvNMT8clYN8OLshkYoNx0Kg=;
        b=dczsypOiGiHfopFWgcKsyexLRO6O8l9wnS2CnzlRf5Ao45w/uRJoULm2XyhE20HEdA
         KDSWFkPE0R8sYenm3iwUpSxdtnrJnerkb/9hcG5ib52W7Pcpz0WU41F1GZcR9Qy+Y28G
         8fF5rDIGiI+vBwzJwnLz4QWArw3piMLo5kGBD5jrZUlk0vtb42BLu2kCvHOvM4QR0Pb+
         XfZar4TJUUMDoA9meA+glIE2YMo4S0A0wark0pIp5jlC2gGjU0D88MkPVCQ1c9h70OTx
         I8iA/yaMTdoCbnYSgVv3qMWhySBU1hNa4uEyhqRrt65oS8pl2vujIZkPTfMPRDMW9yEQ
         avsQ==
X-Gm-Message-State: AOJu0YwZPmH/17TvilEzPiiTZyZdlZXhSVaQPNgymDWIoys6ZeGIw1Y4
	hLGHhWl2uqpvhwy5or5Sy50c1L1JXQTD78DWqfGA9vQFzlUweQ4N26yh
X-Gm-Gg: AfdE7ckGXaDUlQB3u+Tx0YzUoMDwyShN+JT5bgdhUQYlgDXwSYghB3xaRXaqpJFQppg
	gRrguPuDtrnvs6JSe0yffukkgSp5H8JZNutPBboJoVyWHWhLgzwEHIR4XIlM00+zWfz1qiwwBlp
	twlLG6WWoeuwBPtaz5wx5qTLJF7R4KuBfBA3rJFtSxFgpFTwgvqc78Zwi70dcbVZqeJlsMCK89E
	w/PvlPP4ctsO0AIYji8ofAMN5mYJVJR1g3yUpHTVfTZUewQT3Qw6zuwQnCnkGYNqiXGsM5JnMuV
	TB79Gtu+1yvEeJN/35fC8LlFcI45/ccBikAPDIvbAwrCbqWA8gccqeofJfcjVtjNfRlScm1D2sO
	QwSCitTy2+NezPNhk4OiohFHh/khQa9CWY462JQEPzrm6/I4sCZdjzpQj4PI2XAb4I1B12IXj1x
	9pwgf/5b/b9zpR/CFP644q2vpVcAlUZejFVdG1K/o2gWqcGHtKRHfYVP5JPJJxtw==
X-Received: by 2002:a17:903:2f8e:b0:2c9:b911:bdc2 with SMTP id d9443c01a7336-2ca448a7317mr18657075ad.6.1782836874941;
        Tue, 30 Jun 2026 09:27:54 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37c87bcesm17829375ad.29.2026.06.30.09.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 09:27:54 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 01 Jul 2026 00:27:32 +0800
Subject: [PATCH v6 1/3] mm/swap: colocate page-cluster sysctl with swap
 readahead
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-1-d4f648963382@gmail.com>
References: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com>
In-Reply-To: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1782836859; l=6043;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=5H6jS4OceC8ZRadpvqo2NMSUlsJ/HouhQ86dEL84t0Y=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QHi/QRGhll/pA5xJ0yDPc6U0JASWFzcI3JcmSI01M+jo2jI3tErPgzirNVTkhDoS9e7Y1WRGvBr
 X9sF9YqwLTgA=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Stat-Signature: nn46w9tpryzzykchgrxr5k7ifrjm1a5q
X-Rspamd-Queue-Id: 1F7C74000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782836875-698638
X-HE-Meta: U2FsdGVkX18oS6yMPQfEmXSsoBHas+mE+8cZb3RC49bQCC6UI05m1+UgYR/qkYO4Ek9Eyg7xyhM/B02qCNSV9lvsLJfIP7lk2dsMc3dSVDdljaXAy5K9e7jZKx3cRZk7lLYOu12sODEpJZff3EJtldemI4OVF8kNpLbw3YAkXMZ3BdjJMvcq0mqTZ8Gc+XHJG1gzIJ/5Jix4v9G/pxyggkakEF2avRs8KEBhPJ7pHXkpIw9FEjFajOe/U3G8+QSzfwThfCHKDLaQzJaAAPRvrh9II73OAbFwtfXT7fUeXYSKAbx4shSwSNkpjVmT06VhQ28Nthn3XBS/Yy0K9foimONg2xYrBNBB0QTWWZGHxdjzTGty6GdWhn+dp+eEe09ivNA8AinQ4KS9fUURliH/Ad/gVeMEmhgk7bcwB7qRSAtDc25I4neO/sCESStvEsUvmWKWSrrVAAw76unFOHkOJ8B0WUKZwF9+TRXNwRXWMk7GtnduLuoNee/GghuFXFgCAqd8/W0phjiIMD6cfYxYsejxGiM26lVoQSh3tvMjff4Eq/Z7xq2i8hpOwhtyHS2W6jwHBB1gQ1e6J93+N2kVa1L3+CoqpgIURmmIf+fsgMuuugHqGiOhLiX7vEHUL0Pj+pamb+ZFyMVrTWmC/A9JcnHFzzGJ8ldocnEpiJNdLOGMM/sPDWyXLTQ4+FP10obVu4X4poJZaA+cmHP/N725DfttbGibXdYBGNUldAMJuVBBdYp/STM8vJSDKFy08oIcuyZ4oi1yjvoe9XPt0PICaV6gK8qZR9Sszxt2FBGwfF7zK1zUMbeWDrXY6vDSkPKxtBGQUVuTKz/xny5ZogX/tclN0USdsZMYbmNJ96VhjBDyy6ZWD8KwVuDgDhK+4VYGCOn1gbirKN6w9lteXxVHk/uI/EvfGb9x4i7AfF9ltdmAGfksHKMUpUMF1QZ8OIJb+nGKCcnYw7oB7Kskoq9
 l0Fb4GeX
 xZ58HYRXXyP4WOLpVJvDPEmeiinfcaAeLfe1z+sh0Hf449o7ieIZKK2htK8az6M7B65Xr69SziU0ZP9rRZCHaCJLG7k0NvqYsG4mBfe1DOU6WpH8GJVrEh2Qxt7FsWE3OjEOwOXnNn+8Wlx+52yITF5JAJf/CgWp58OImsdP3IZGdE0GgMGe+QVy1JeU4ptqD9fXQjDNLGoBK1Qrro/Ye0TKz+tC9Yl4YWegPcrzhJZSsh6F17kxNikXT46CvUWeq/G7JrW3/qXru2wDXeXCjPMf9K5Y8HDUL2yMnlN0kPPL4GfG6HgqybsHt0/jo59Xdp040Zx0FyXn8palCflwrPOr/Ri/lc6xWSEDDa3QHBV/KUPMcXt2csn7jKqPFL87t4P1JGpfyHwQtjD3CTS6L2IvYdTr0gRfIOmMWqBSuyHCO1SXd161p/8pQJxcVWTy6WpUcCL77sULKneBFx/vCreuUStf9C2arki40Flpo4L8nMrF27UqNW/RoIw==
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


