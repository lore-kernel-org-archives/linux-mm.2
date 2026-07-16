Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5326C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E2F6B00B4; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21696B00B7; Thu, 16 Jul 2026 10:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73056B00B8; Thu, 16 Jul 2026 10:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 959726B00B4
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E4941401DD
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:30:21 +0000 (UTC)
X-FDA: 84994875042.05.E375716
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id CF0A6A0008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:30:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WHweq6s6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3-OpYaggKCIsyprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3-OpYaggKCIsyprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXj/ylmXdmqbjEPyQgiWZrVSrCcZeklAgzKFbFtJ76k=;
	b=X+mwDBP6ouUYjYN52rdupIfgpJh4rfedcxCa3/+Q2iAw+blfR/GmJwIZLt1G6/T3S4i7R4
	eIsG2tuxYy7+uTZliARAYzS4IcSb5PO3krJyzCTrx5+RhrGXv4pjO6DGReg96bkoUrbq4k
	Lx8JeY2IOw5fX6xQGz5MLn7E+Tus1jg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WHweq6s6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3-OpYaggKCIsyprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3-OpYaggKCIsyprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784212219;
	b=KgNzloSyKxmYSM7RumA1i3OGvumwMvyhpMEamdiukmHq/ZpdyDlWcPxi7ZNGEmcrca2xmB
	67OSSfgOV0WM7kzs2pYNk6pfnIFabz6NxoGiLJ8i1ct5nmNDII4xSXj6+dH0DFhppZIsjY
	K03t56csijVJ1JIoeUOPFY1CnKtqpVY=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493e94719e7so44583195e9.0
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 07:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784212218; x=1784817018; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qXj/ylmXdmqbjEPyQgiWZrVSrCcZeklAgzKFbFtJ76k=;
        b=WHweq6s6Q0X1E4vOrfX9S3MnJ7sMYhr6eIhX36KKomTomnQpazpq1i29PemXWqGYCK
         qNnpblQcx4p/dRbVDI9+LEUqhAwe6mCJfO8Pv3tzXqr01cU1euK9THI8Gc6cw9ZLw2tH
         WSbhvgWTEhYhZKKeLYMWw9Kn6I21Fno8yS3z4ayPdSjNHZfxCsEsrJl9d9BGeQ1K7mTL
         zik8r/zzwFy7NcTxDFJxifm4rl+YqTMtwrptP8+ZwY4vpLVdoNFSuzCTf2qveF2yiBqT
         4fE9z4JGvZvjbWTz8lZLjHblQEJW1XXynKj0QxFK4SacvMC6n2aIv09Aa6OkCOPomY4l
         4pQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784212218; x=1784817018;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qXj/ylmXdmqbjEPyQgiWZrVSrCcZeklAgzKFbFtJ76k=;
        b=cuUN/uCTCjpRQQ5EXM+xTV5LoikF+MX/izISJvvlXoCVwdt7btNYoqeMBrR4PiNewN
         EAJJ93TPY/b/XB/a1X3quLtdmlYELLl8Lye8bTc/hvKK72yWAgYurfMWfJwjmgfc2YBR
         TGmhrMRPusDwob14rE4WESuAQQEbTfnFQ1uChAvCLZJdKaLmDCosE6YOikVSiJSuO3BX
         SqhocryVFZV522ImZSVtyUHBLAFHETvThk0Dqnpi0AHfBkKkgfBirtwM239nzPYIulUE
         oP7M3QJWNEirUvrvc50wH0pey8deZVsVOoJCtIeIG63mi9hjZDYicMge3wcQ9X1Jctct
         cZhg==
X-Forwarded-Encrypted: i=1; AHgh+RpQPkOu7gU/NPhRCahJdziBPWpNXyHtyl8VY/hsY1fYBdNv4mV1uZcISZcODZ4cxRxjdsHFt4CcPg==@kvack.org
X-Gm-Message-State: AOJu0Yya5cSmGFzbd8bb6AhdH+ny32eBGGUokFxDSrzLiAQseDbSHfPS
	z+MIZBKi8I4+s/ncEmHOctTsLfnZLFyQKRhJf8Ka0s0BUSnyAvjEAjMJ4oG5o3C0ny+KuXNTJt3
	PCQbs24QyMHnS6w==
X-Received: from wmbdr10.prod.google.com ([2002:a05:600c:608a:b0:495:4728:580])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:628f:b0:493:d305:b8f3 with SMTP id 5b1f17b1804b1-49538ff827dmr104868985e9.3.1784212216047;
 Thu, 16 Jul 2026 07:30:16 -0700 (PDT)
Date: Thu, 16 Jul 2026 14:30:10 +0000
In-Reply-To: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
Mime-Version: 1.0
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
Subject: [PATCH 1/3] mm: move internal mempolicy APIs to new internal header
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 3ix331dwkzqwb9ywtcbazbmmt7r3zr8u
X-Rspamd-Queue-Id: CF0A6A0008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784212219-192520
X-HE-Meta: U2FsdGVkX1/x2v9YX7eAvQ7CDbeVnZjqR3PskkF8PfWsmD/WnOeHIAC5e9mp14J5nV/3WqK3+h3ZqBcVCuVVdbogkXOCmeLorDh1k69rOUi8QLsdfYIN6nmLORmwIlg6geMZyRzPV74ygSP5pixKFU26wOHE+tA1W/JqBIUpV9iU6ypZkD8fS11Gic9VpKnO5gk31T8zRuaJX9Hf9Ecax+8STtKCKQo4QMdXl7c+ffhwDXZ1INw/yg//KGqtQxUW3GT22Fix9aH0YxhrNacy1Rbm+GxLPb9HeROLvLQOVxLLioXU3eawmAytdXyyk/blt88Sf6YUgTOKmC8v6/gUbRfM+406CDNnMFamDK9J9W7nSE6YkHx7XYxCD/5OzJC2T8C+mvQI+gDIrw5GsdCvr+6AoPGr11dB1BB6bauhhbJ8YtPgop8s6i0V3Tudo4amRhYC2jteZhjFhS+jOKvgouB7pckCqYOWLamRMt7Dm12N4jo0zJv/YtgT9DGVmSzaS5UUOH6sk7jUlKcU/+TphMX4l+VvVkH4AaYlpxoGvQPXeda683IPwbvNnS50mUZkYZ0vKl3CPJhLxsoLWV6LqxLxdtyG5kLPobIXzWwqPTnHD9kND7O5XDvzBHsEukG1y0v+eryAOF56DcT/Vxjjl2nhGGt9OXEnoLxbA3jtFTYhorbJkOfBk3EX43QQJuSLza2T18aLF7CGObH838lVLmMA27TYIGTP3JcndEYa2Z+DGerQne5vBfpTcvrtRD8wIwapJ0wQ81CUZsnQ+LalrfocOucrmywklbC3gy/cntDNFVAgUlwGNHBDsaB53qtjEQTkr0uyNu1ktCwmuY/RLZ2aCvzXrBDaXJJqKJki5rTovikdGzTd5OE9GGLuWCZVbcaaBUEMxryPzxYzrXX97YScMlzm6Acc4bgLSwCaXGtk1mtAMSX5FWzYQszzycYUJY12OdfYdSykJ0OgRoc
 FP3SmJtm
 SHWoFFB0sXhJuO8jOsrKYaJ9ubyvsSI3kJSiQe7Q6YUf57kNlgdURfMgHDe0fiqoj+v1OKmDC10Pzbn5fXyfM650wNG0SsquH9imO/58RfV06qoje+WgttDyh01MP9Jbg+51y/JX7gU9MZQwaUzvwAUtqfSKJMCCn24UK44HfwZcylN3QBxZUwA6Zuvt7rGqDEom5NeB3IWk+IHikR7KHhbmIzJRtZB0UhQjzUpBFOwkGiRfrGnQYH9uz5gXqE+usekE9b/SVMD7j2CegeRhK+ebK3QRdstXq52zLLSrnFZsnR6iLR/P7lf1eFwsCFDy2aEPVFFr2vgxuweWBh4rVp+NeS5Gdjyh04y3/KMfBJAt5hN2nVihlJYI4PcVxlYDCWWEpMI1tmhPA6s68yfhmf0aXRhcTQQjwA+I+2wHYeNZrC5fliR2NkUDETKDQBVv1leGLxpDTf4BiuUC4siYyHn78+pv8EPX/Ipx1sgwZsCHh4nark+nXVXSX1Mg35FAVL5y/7HtDS61wZ0i9cgnEdBnBrd4KPh4Mi7FVm9xXA48GpNmB7FqbvFb0uljTUhrAPGy0P2NIW6nSGQdEnoLNRYuaR8WE5kI4ji0sxhTbK/dPD2gAvttsgP+aBCnFu6GVJoJs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are no external users for this surface, reduce the scope.

Ulterior motive: a later patch will add an alloc_flags arg to some parts
of this.

Note it might seem like this could just go in internal.h, since it's
pretty small, but actually it will eventually need to import
page_alloc.h, we don't want to import that from internal.h so best to
proactively created this header now.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 MAINTAINERS         |  1 +
 include/linux/gfp.h |  9 ---------
 mm/filemap.c        |  2 ++
 mm/mempolicy.c      |  1 +
 mm/mempolicy.h      | 31 +++++++++++++++++++++++++++++++
 mm/shmem.c          |  1 +
 mm/swap_state.c     |  1 +
 7 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8813d5d7eb0c1..9cde99c259639 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17068,6 +17068,7 @@ F:	include/uapi/linux/mempolicy.h
 F:	include/linux/migrate.h
 F:	include/linux/migrate_mode.h
 F:	mm/mempolicy.c
+F:	mm/mempolicy.h
 F:	mm/migrate.c
 F:	mm/migrate_device.c
 
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 872bc53f32ec8..e4e974a6e5f90 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 
 struct vm_area_struct;
-struct mempolicy;
 
 /* Helper macro to avoid gfp flags if they are the default one */
 #define __default_gfp(a,b,...) b
@@ -274,8 +273,6 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 #ifdef CONFIG_NUMA
 struct page *alloc_pages_noprof(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order);
-struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
-		struct mempolicy *mpol, pgoff_t ilx, int nid);
 struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
 		unsigned long addr);
 #else
@@ -287,11 +284,6 @@ static inline struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
 {
 	return __folio_alloc_node_noprof(gfp, order, numa_node_id());
 }
-static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
-		struct mempolicy *mpol, pgoff_t ilx, int nid)
-{
-	return folio_alloc_noprof(gfp, order);
-}
 static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 		struct vm_area_struct *vma, unsigned long addr)
 {
@@ -301,7 +293,6 @@ static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 
 #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
 #define folio_alloc(...)			alloc_hooks(folio_alloc_noprof(__VA_ARGS__))
-#define folio_alloc_mpol(...)			alloc_hooks(folio_alloc_mpol_noprof(__VA_ARGS__))
 #define vma_alloc_folio(...)			alloc_hooks(vma_alloc_folio_noprof(__VA_ARGS__))
 
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
diff --git a/mm/filemap.c b/mm/filemap.c
index 1dbb4c6f824e9..0dd8e2a15d746 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -52,6 +52,7 @@
 
 #include <asm/tlbflush.h>
 #include "internal.h"
+#include "mempolicy.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/filemap.h>
@@ -63,6 +64,7 @@
 
 #include <asm/mman.h>
 
+#include "mempolicy.h"
 #include "swap.h"
 
 /*
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5720f7f54d942..31c4e9f49b5e9 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -119,6 +119,7 @@
 #include <linux/memory.h>
 
 #include "internal.h"
+#include "mempolicy.h"
 #include "page_alloc.h"
 
 /* Internal flags */
diff --git a/mm/mempolicy.h b/mm/mempolicy.h
new file mode 100644
index 0000000000000..d80fe4c559786
--- /dev/null
+++ b/mm/mempolicy.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * mm-internal API for mempolicy.c. Public API lives in
+ * include/linux/mempolicy.h.
+ */
+#ifndef __MM_MEMPOLICY_H
+#define __MM_MEMPOLICY_H
+
+#include <linux/gfp.h>
+#include <linux/mempolicy.h>
+
+#ifdef CONFIG_NUMA
+struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *mpol, pgoff_t ilx, int nid);
+#else
+static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *mpol, pgoff_t ilx, int nid)
+{
+	return folio_alloc_noprof(gfp, order);
+}
+#endif
+
+#define folio_alloc_mpol(...)			alloc_hooks(folio_alloc_mpol_noprof(__VA_ARGS__))
+
+unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
+				unsigned long nr_pages,
+				struct page **page_array);
+#define  alloc_pages_bulk_mempolicy(...)				\
+	alloc_hooks(alloc_pages_bulk_mempolicy_noprof(__VA_ARGS__))
+
+#endif /* __MM_MEMPOLICY_H */
diff --git a/mm/shmem.c b/mm/shmem.c
index 5071177059a96..69f561332bb93 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -41,6 +41,7 @@
 #include <linux/swapfile.h>
 #include <linux/iversion.h>
 #include <linux/unicode.h>
+#include "mempolicy.h"
 #include "swap.h"
 
 static struct vfsmount *shm_mnt __ro_after_init;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5be825911e645..8ccd03c39a407 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -24,6 +24,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/sysctl.h>
 #include "internal.h"
+#include "mempolicy.h"
 #include "swap_table.h"
 #include "swap.h"
 

-- 
2.54.0


