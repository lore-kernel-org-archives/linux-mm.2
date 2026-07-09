Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59525C44503
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D2B6B0099; Thu,  9 Jul 2026 02:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BECE6B009B; Thu,  9 Jul 2026 02:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD486B009D; Thu,  9 Jul 2026 02:42:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 093D76B0099
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:42:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8223D1C3771
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:42:18 +0000 (UTC)
X-FDA: 84968293956.29.6F81DA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E573C100007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:42:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GWdzw/kx";
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783579336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HF8QXfErBmiM4HujTPPyN2jtcCd6N6NLxq71GfMCTU=;
	b=nSg4Bop1vCm6lu8NMHwv5j7lI69It/YXb5yPARbFG99TuGVcV+GPuA3TFU4ZwAO7EC1aQf
	BoH5bX+hSllhB5NknsMpv3hQTyToTQJ6ylb3mIzYdOAAD0pyw4YswlH/04HXwmv2Ha1u9m
	/Q9g6Vw0rGmAGSgLOiKGnzY5pf0Sqmw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GWdzw/kx";
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783579336;
	b=JMkK/7T3i9s+jO9VbTQteJl935dWZBn8nWiFT4SroaV01GP1Rc9miPHgRTKIs16acLx+Yq
	l7TT2tOe0ha/yB4rlvYhCfA3NKdw/81TW9hsOjUOw8oh4xgb+n/TeyNWG3b+Y/nh1IRE6M
	4Ke+uDnRLz11a3fqyWdQgyWu7e3SlZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8304C6136B;
	Thu,  9 Jul 2026 06:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4FE1F00A3D;
	Thu,  9 Jul 2026 06:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783579336;
	bh=+HF8QXfErBmiM4HujTPPyN2jtcCd6N6NLxq71GfMCTU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GWdzw/kxChW3cZPZFf8ut2KlRoprxq1NC8Kki5VwqWmAHQUpE0hE9mq0K1SxlmQrg
	 t2zL/qZmohMkvIUWA5V3qNwEsvd8WKqGHcGU/hMNZEeAGHOd6U/8TvZeTXS7Xf6QOl
	 ri/b3AjFIKQ+buJjaOi4phbMy+mx6vElEHRRTbo6w7IXqMOMyJXKVRa89cS1fCPg4W
	 0LP0DIQtBxrbiZhqYjnqj0RoD7DPYJRcnnFl2eRCCFl29kp658LD7B2EFJdSRg8UdK
	 pkJzWS+O4BABFh7JMMOOqFNXtaEw0vFmq18kiJYD8qAzT2vvKD5bWIqA1SQaazft65
	 opJkyD1YROXHA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 09 Jul 2026 09:41:49 +0300
Subject: [PATCH 3/3] mm: split out vmalloc declarations from internal.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-internal-h-v1-3-956d5092782d@kernel.org>
References: <20260709-internal-h-v1-0-956d5092782d@kernel.org>
In-Reply-To: <20260709-internal-h-v1-0-956d5092782d@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Alexander Potapenko <glider@google.com>, 
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, 
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, kasan-dev@googlegroups.com, 
 kexec@lists.infradead.org, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E573C100007
X-Stat-Signature: rnz649mpqbghzgwsew4xphury3yyo94d
X-HE-Tag: 1783579336-695218
X-HE-Meta: U2FsdGVkX19xV9Bibz0XstNuCjUzbJQnoa9HXxTVAj9HgkzFRD8dOADiKe8jkRo+Xs3WYrTo0mWqmwIGuXjy70r7Zv2NQ/vhnACprt/z26BN/aTlbn51dXZaCdKgzcA5ynMMpGCnl/NfkKiswXtjPl+PsGpWOTD0vpI668G9rwR/1NMo8tYJkKEmx+PSRSBxkkpy8ZwRizqKgBz+vYi6h1tO1fNPmLlL+A0/5EXdUOpL7janUle9QpayT8p8lRKby9/tRNvwTigU6w8B7Jt7M08BPx+laRUiHLUTW3YjC9qOThvEL9d7AInp7PnhaOLWD3T1IpR2kXPLnZkLatXqjCYffFKmZGidW2z4AkXlXG7ZSSQlEs7d3JTnTZSZ6Pl2IZMl1eLN4SpSaQDOp2rdQxDsNU59zPBjF+vxfk4ZBXaj0YDDCNUZ/BfNH4lbY7AwOR74oUwO8LeTFVN6LphmEJAc3I0bquGWShBwREzdSyoC0C0hwVkSr9dY9xO08tDSe7GrnYuEISjZKy1FRgCG495jsQRCbuMslaZbDdnJkc5YL4UM8r+H3BHCXySjev2EoUvtYp2nRlirDOzG1vx1+sl3iIfquIlmf9JyrXnRBfCYUUkdybcCUb7kMhJ7FRUCyO+xh+2uF0XqAv476IMYGPtgFfObAkCW/vG1Gnvskt8wRN8FFmQaLjfpk8tmhW4h5NfUnKci7eZUPvg9+5dNqTNmE/T0HtuXesZ7sSPoY2K5mK0dOAviCIkSUb2sh7uohkvzhxNNxG5Gzt7DKmnopQRSiawJm16Qprb3iDIm73CGSyt/OWkh3x7W4NTHNqYCf5tsQP+IpDrruC1SVSAJ/Gq/s0O5KCsJlo3bySviv63sbSdo7ZFMC6OLfoR+oZKF1SI3rdK5wRi8qSahd9GuYE11n95BQT3q4M7tQynsx2oIoZAVG5yT+BaQUXznAWxMQbumCmk2xgcAEOziEiR
 1vwU9jyj
 nOOquXb/BSCAZmbybq/sHyb3UPUSLTQ3oeD59ba54hsJu9Yzh9Ng6i01LZgv26vy+LfQSnBwo2HsIw+emUF+0+hnxCAdYkHNxSsKpxDd+Sj9bKtRYFwnz64xvHIh1WAdptZEptfQ1JcTX64pNXJdLmMc9z+p52sEBLF4RPGO+/efwNkZtXYPG9fHN3VnSiRi3/PDHlbKshqv+gPL/RuNe4WZOI5QZFssTtoB5nWkzqSb59jBADKuBw+TKAiCi2+a/gljBfbZS1mhElHZIbUnwcIBt95xc1JRSMQzyYTWpXQ7Coqa0sE0pbmEVUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/internal.h becomes more and more bloated.

Move declarations related to vmalloc to a new mm/vmalloc.h header.

No functional changes.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 MAINTAINERS                        |  1 +
 kernel/liveupdate/kexec_handover.c |  2 +-
 mm/execmem.c                       |  1 +
 mm/internal.h                      | 40 ---------------------------------
 mm/kmsan/hooks.c                   |  1 +
 mm/kmsan/shadow.c                  |  1 +
 mm/mm_init.c                       |  1 +
 mm/percpu-vm.c                     |  1 +
 mm/vmalloc.c                       |  1 +
 mm/vmalloc.h                       | 46 ++++++++++++++++++++++++++++++++++++++
 10 files changed, 54 insertions(+), 41 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 406ccfe63974..804e3b0f3d97 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28813,6 +28813,7 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/vmalloc.h
 F:	mm/vmalloc.c
+F:	mm/vmalloc.h
 F:	lib/test_vmalloc.c
 
 VME SUBSYSTEM
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index fe11cbf1006e..78ff267bf51e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -34,8 +34,8 @@
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
  */
-#include "../../mm/internal.h"
 #include "../../mm/mm_init.h"
+#include "../../mm/vmalloc.h"
 #include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
diff --git a/mm/execmem.c b/mm/execmem.c
index 084a207e4278..74a178a87e75 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -20,6 +20,7 @@
 #include <asm/tlbflush.h>
 
 #include "internal.h"
+#include "vmalloc.h"
 
 static struct execmem_info *execmem_info __ro_after_init;
 static struct execmem_info default_execmem_info __ro_after_init;
diff --git a/mm/internal.h b/mm/internal.h
index 860cd31c3da5..8a2bf9bc93ab 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1092,9 +1092,6 @@ static inline void mlock_new_folio(struct folio *folio) { }
 static inline bool need_mlock_drain(int cpu) { return false; }
 static inline void mlock_drain_local(void) { }
 static inline void mlock_drain_remote(int cpu) { }
-static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
-{
-}
 #endif /* !CONFIG_MMU */
 
 #define NODE_RECLAIM_NOSCAN	-2
@@ -1209,37 +1206,6 @@ struct migration_target_control {
 size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 			      struct folio *folio, loff_t fpos, size_t size);
 
-/*
- * mm/vmalloc.c
- */
-#ifdef CONFIG_MMU
-void __init vmalloc_init(void);
-int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-	pgprot_t prot, struct page **pages, unsigned int page_shift, gfp_t gfp_mask);
-unsigned int get_vm_area_page_order(struct vm_struct *vm);
-#else
-static inline void vmalloc_init(void)
-{
-}
-
-static inline
-int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-	pgprot_t prot, struct page **pages, unsigned int page_shift, gfp_t gfp_mask)
-{
-	return -EINVAL;
-}
-#endif
-
-void clear_vm_uninitialized_flag(struct vm_struct *vm);
-
-int __must_check __vmap_pages_range_noflush(unsigned long addr,
-			       unsigned long end, pgprot_t prot,
-			       struct page **pages, unsigned int page_shift);
-
-void vunmap_range_noflush(unsigned long start, unsigned long end);
-
-void __vunmap_range_noflush(unsigned long start, unsigned long end);
-
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & VM_SHARED)
@@ -1267,12 +1233,6 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 void free_zone_device_folio(struct folio *folio);
 int migrate_device_coherent_folio(struct folio *folio);
 
-struct vm_struct *__get_vm_area_node(unsigned long size,
-				     unsigned long align, unsigned long shift,
-				     unsigned long vm_flags, unsigned long start,
-				     unsigned long end, int node, gfp_t gfp_mask,
-				     const void *caller);
-
 /*
  * mm/gup.c
  */
diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 8f22d1f22981..5f1b8053f9fa 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -21,6 +21,7 @@
 #include <linux/usb.h>
 
 #include "../internal.h"
+#include "../vmalloc.h"
 #include "../slab.h"
 #include "kmsan.h"
 
diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 8fde939784a7..0c88d89bf0d6 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -17,6 +17,7 @@
 #include <linux/stddef.h>
 
 #include "../internal.h"
+#include "../vmalloc.h"
 #include "kmsan.h"
 
 #define shadow_page_for(page) ((page)->kmsan_shadow)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index b557e5fe35f3..711f821f7b3c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -38,6 +38,7 @@
 #include "sparse.h"
 #include "slab.h"
 #include "shuffle.h"
+#include "vmalloc.h"
 
 #include <asm/setup.h>
 
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 7ed216192fc0..509d8901835c 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -9,6 +9,7 @@
  * This is the default chunk allocator.
  */
 #include "internal.h"
+#include "vmalloc.h"
 
 static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
 				    unsigned int cpu, int page_idx)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1191cda3b4e8..4b0362cbdf5a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -49,6 +49,7 @@
 
 #include "internal.h"
 #include "pgalloc-track.h"
+#include "vmalloc.h"
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 static unsigned int __ro_after_init ioremap_max_page_shift = BITS_PER_LONG - 1;
diff --git a/mm/vmalloc.h b/mm/vmalloc.h
new file mode 100644
index 000000000000..dcfe30eaa80c
--- /dev/null
+++ b/mm/vmalloc.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * mm-internal APIs for vmalloc
+ */
+#ifndef __MM_VMALLOC_H
+#define __MM_VMALLOC_H
+
+#ifdef CONFIG_MMU
+void __init vmalloc_init(void);
+int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages,
+		unsigned int page_shift, gfp_t gfp_mask);
+unsigned int get_vm_area_page_order(struct vm_struct *vm);
+#else
+static inline void vmalloc_init(void) {}
+
+static inline
+int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages,
+		unsigned int page_shift, gfp_t gfp_mask)
+{
+	return -EINVAL;
+}
+
+static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
+{
+}
+#endif
+
+struct vm_struct *__get_vm_area_node(unsigned long size,
+		unsigned long align, unsigned long shift,
+		unsigned long vm_flags, unsigned long start,
+		unsigned long end, int node, gfp_t gfp_mask,
+		const void *caller);
+
+void clear_vm_uninitialized_flag(struct vm_struct *vm);
+
+int __must_check __vmap_pages_range_noflush(unsigned long addr,
+		unsigned long end, pgprot_t prot,
+		struct page **pages, unsigned int page_shift);
+
+void vunmap_range_noflush(unsigned long start, unsigned long end);
+
+void __vunmap_range_noflush(unsigned long start, unsigned long end);
+
+#endif /* __MM_VMALLOC_H */

-- 
2.53.0


