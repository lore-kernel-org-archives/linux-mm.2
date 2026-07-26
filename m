Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46615C53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD416B00B3; Sun, 26 Jul 2026 18:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2303C6B00B4; Sun, 26 Jul 2026 18:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16CF46B00B5; Sun, 26 Jul 2026 18:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D632C6B00B3
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:24:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DB45C0573
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:24:03 +0000 (UTC)
X-FDA: 85032356766.04.61266E7
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf25.hostedemail.com (Postfix) with ESMTP id 99666A000C
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:24:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YYDcsEnK;
	spf=pass (imf25.hostedemail.com: domain of 3AIlmaggKCAcqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3AIlmaggKCAcqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AIcMu2nLYJvhdOcrbtzHu48B893eoAGC4k3fk2E0qU=;
	b=NNs5FhPEhddGwBIk+mYpa6eSQtsh3EyLsrjmu+eqkXL3WMfl75MoQapFTvgmmJGSrl0Cf3
	rP4jNkZkjXGw7X8b5MyOhyzAPI47dk4PXgal6qY73Mg3wTxKy8A76NCHln4aJTtlkuc1di
	94MNMbhD7jCPhylCySNCv2V+kjmVKJs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104641;
	b=yl7ZdSOl2cQ6TObERVc79eTbXgIW5GTGWQRlJNx+8ro9Cf3KGTzg5IkUw3mkYmPH4AS/AF
	D/LXAlSl+71YMuFMqslffzOW08HRNoJL6mVKCjoAEhxWcYeSdUWumQw3pQI+uBx4sqfuOn
	rq3AorPvs2Z3O13tz89yedEXpBU2aQU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YYDcsEnK;
	spf=pass (imf25.hostedemail.com: domain of 3AIlmaggKCAcqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3AIlmaggKCAcqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49544a639e9so10570915e9.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104640; x=1785709440; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9AIcMu2nLYJvhdOcrbtzHu48B893eoAGC4k3fk2E0qU=;
        b=YYDcsEnKc50VNlPgFDxCzx7SODGRl2VQrX7iX+Qn8knHkmRQ9vt/GQ6b50C5uwKsqT
         r98FXZtnvIM9lXF5OeG/asb6JZwuNOCq4rXjSNuD7UK9NDYjZBT002OVIISWn00Aiake
         AVJgyMz40Wgpp505TB189fvy1O3pB6OXxaJk0Bu8jmO0uspfUG15sokLCAvdDFzpNPiR
         3bM+t8CWDpb39Yq8OSGz92medj6Uq8LtaaJbKE+OnS4UVt7cSRzeq7IzvEoG0/UGGrv3
         zZJFg45SgtviHLSSJm5toEeo3eVe+tlpt71wn+pbol4azYeRsqSx8DhUR3QSYUIjKRJF
         okdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104640; x=1785709440;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9AIcMu2nLYJvhdOcrbtzHu48B893eoAGC4k3fk2E0qU=;
        b=VqUuNUlsOYu2jO/XNyo+IsIKgZCUmW7IS9jKL8nVKpzBeCZ4f66h1vh0BBZ6bURgRE
         Vfao2Hy3vzqgGNgFIQlS81qBzwYNNB1hHBwPGwb0JXZXhhOpXvE1qJQMm0v3vHYJ/Sl7
         mInOCV+0nkCARdQUrVJvH5fdv+3N5kxKny+23qANM4ZpDe/a1lquHN6LE0vayU7B7jQX
         gpDW7X6QxIKJ7mfQBaN/+SgeSgTV2slN1c9/AP9GChzH7Us9zdunHRaiDPW9RCB5Jtqh
         eZfNSjTntHL5D/AspXHhnqulKHyUXc7IwrI2tGwjbRjj2/jcUfR27Ocx9gsf1uOoS9Ax
         VKUA==
X-Gm-Message-State: AOJu0YwAeMc2hQTViHTOIfh8WsIym7hXE9b7cCFPhQ7GezXlh6nXOJm4
	lcUMe0/lIGr+N7tiqa72CNAp/FyFlg27tR9VjKTTeVubmOdEDg42mLgAwo049O8rGQdnIAOokpi
	SFlCB/Eg5jeqaYg==
X-Received: from wmbjj2.prod.google.com ([2002:a05:600c:6a02:b0:495:5422:15e3])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:19c8:b0:495:5205:86c with SMTP id 5b1f17b1804b1-496b5747d8dmr86884375e9.22.1785104640206;
 Sun, 26 Jul 2026 15:24:00 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:58 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-25-6f5729aa9832@google.com>
Subject: [PATCH v3 25/26] mm: plumb alloc flags into some alloc funcs
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 99666A000C
X-Stat-Signature: he1r1zy3fmwradg86ckj363ku7wnkgny
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785104641-695793
X-HE-Meta: U2FsdGVkX1+0H7XWcpzv9ziOrTQR2MEVJCXZ97kwNHtuVmxrsmZylZIA5syjYWUHvyMpkd8yeIOIt6r+gVc5txik38fIv/dRTIaUXV2a/0sh9mPhzekfqv38pqeLRmeM8+4hmPAAKskz22id9Tq44/ANSX3qpnBtox12ncojBCzOfTrc8k0jdUgIGjjf5dwK6KEdQna0u6t0cwakSHZQimBIjc4onilzrIWZ/neRo0KDfyV0xiK1AusOBlXeUxKWVsjCJMqkVck8jLVF6X3lI7vm4dLE4cdk5OdUtb3fNS+w86MnnaqHjsFu4l+YDZjv18IWY0Da4cSp3bMeovNzakWy4yPPZSezA3AIIxLCTaoaH2mBdXrssubM7ZFiNtaww22HQXOcz6SrY6cwx3qgwTJxM+meNMGJEJ+eZ4cgD0lCAxsPRwv5a9xKtXC4Z1L5t7HQ0xN7kh/jPRK1rVoVxJTq5vvZXCPQoNceiSeynlAexD3n+hw5xZY79SjVoeaYCHCz+Q5R1EciLQUhG1iqp7rfMuRhdapIIWJ6rRAHTtBVrlvCfpYMJkzK/OR/itc1QvN6VDoVxC/lv/vg48McCliLoyDUB9yuFULJpmaXpIfqxTrI0VYU2sEPnwlzYXd8ZUP8pXniBKxpLFnm39Gr2HlBxcv9RnfVv65Y8Zlxqr6z1ET0QUXthOTSqhWLWLaqzGR9klTmLIDbyFCqj3kCe2GY8Z+pZKTpruH2eQmmPAySJ6CTBHOc38Dl6LUkjQGnr3yTjv+4JCNN2DNUQZ3eGG2m5r2tZVw2aiWQQpT+aotnsB9YaUgc2LGgq2g/EjHrXielpR6piTbxxasF8e34Qk7ITCsMzeAOUMA5OIPzR8PVzAs2EmLPIyNjYyfKsNXDYU+UR+dkIMq/Q7xwoAt4IvpWt3WsmX2GDgeYNlriUnQyNbKYfEOflwYzI5hF9j/PFaaKmR2stuOZ3Bgw7t9
 pyqcBC3l
 +QsO8yYGLe7Yycw4Log5pHwCto31OW8KnofoJx2BcbiQA36M5qVhhRLseUXm4VYyOtt3lCstGtKhfcsagUNwRBJF0ICJW5pgfVVE7zePYjuxjvBRbxmwTWv4RjyHTdHC8DY1sRgQNuT10lQrsosV5Ehi7b07u9+Je1zLPUcXSla0hguWwHqfE4p2HqXaKTlGEKdnjRxdP2Jh4lb90eFGpz2gNjAh5qUiWjAIVLdwXzroxzFsO80LfPnihQ6quyO1y2dgJgLwgGNMtzFfbAbxVO3u8HaiZ3ddli8ugoklsF0q1I2pLtUkkem8Iy9vWU1hCZTblAAtro18+TYhQ77WX/nk9r98NI5pNpSf55/7t59v1CFAx154JRpWmMMXE4idgL+ztCmMJ6SrpKUehTaFU6hWct6cmQ/2HN5ATFT0K/KCOHe0ISe/XX5s38rLFnfJ9JPpYJgiRhcraZ65gv3BAT1P3ZQ2Pl1ckSzoxfDPROW8+9DcNzVf2dmFztimv1qaGTeDs26RBzZ/Y56JpL02rYUfYIqolyrXlOFIZAbli4qDhY7ZyDTjMBciUtpuynBWn0t6CH3CdrGjdn65BRV4p201bPQXfPqDDhshv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A subsequent patch will want to set ALLOC_UNMAPPED in the allocator APIs
used by filemap.c. To keep that patch from getting overwhelming,
split out the arg plumbing into a separate one.

No functional change intended.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/filemap.c    |  2 ++
 mm/khugepaged.c |  2 +-
 mm/mempolicy.c  | 31 ++++++++++++++++++++-----------
 mm/mempolicy.h  | 24 ++++++++++++++++++++++++
 mm/migrate.c    |  2 +-
 mm/page_alloc.c |  6 +++---
 mm/page_alloc.h |  2 +-
 7 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 341c7c5b28bc7..bf62fee570d8b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -53,6 +53,8 @@
 
 #include <asm/tlbflush.h>
 #include "internal.h"
+#include "mempolicy.h"
+#include "page_alloc.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/filemap.h>
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 27e8f3077e80f..89ce6bcbc376b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1243,7 +1243,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
-	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
+	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask, ALLOC_DEFAULT);
 	if (!folio) {
 		*foliop = NULL;
 		if (is_pmd_order(order))
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5720f7f54d942..73aeda071f5d7 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -119,6 +119,7 @@
 #include <linux/memory.h>
 
 #include "internal.h"
+#include "mempolicy.h"
 #include "page_alloc.h"
 
 /* Internal flags */
@@ -2406,7 +2407,8 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
 }
 
 static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
-						int nid, nodemask_t *nodemask)
+						int nid, nodemask_t *nodemask,
+						unsigned int alloc_flags)
 {
 	struct page *page;
 	gfp_t preferred_gfp;
@@ -2420,10 +2422,10 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
 	preferred_gfp = gfp | __GFP_NOWARN;
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask,
-					   ALLOC_DEFAULT);
+					   alloc_flags);
 	if (!page)
 		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL,
-						   ALLOC_DEFAULT);
+						   alloc_flags);
 
 	return page;
 }
@@ -2435,11 +2437,12 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
  * @pol: Pointer to the NUMA mempolicy.
  * @ilx: Index for interleave mempolicy (also distinguishes alloc_pages()).
  * @nid: Preferred node (usually numa_node_id() but @mpol may override it).
+ * @alloc_flags: ALLOC_* flags.
  *
  * Return: The page on success or NULL if allocation fails.
  */
 static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
-		struct mempolicy *pol, pgoff_t ilx, int nid)
+		struct mempolicy *pol, pgoff_t ilx, int nid, unsigned int alloc_flags)
 {
 	nodemask_t *nodemask;
 	struct page *page;
@@ -2447,7 +2450,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
 
 	if (pol->mode == MPOL_PREFERRED_MANY)
-		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
+		return alloc_pages_preferred_many(gfp, order, nid, nodemask, alloc_flags);
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
@@ -2471,7 +2474,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			 */
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL, ALLOC_DEFAULT);
+				nid, NULL, alloc_flags);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2483,7 +2486,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, ALLOC_DEFAULT);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, alloc_flags);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
@@ -2499,11 +2502,11 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 	return page;
 }
 
-struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
-		struct mempolicy *pol, pgoff_t ilx, int nid)
+struct folio *__folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid, unsigned int alloc_flags)
 {
 	struct page *page = alloc_pages_mpol(gfp | __GFP_COMP, order, pol,
-			ilx, nid);
+			ilx, nid, alloc_flags);
 	if (!page)
 		return NULL;
 
@@ -2511,6 +2514,12 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 	return page_rmappable_folio(page);
 }
 
+struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid)
+{
+	return __folio_alloc_mpol_noprof(gfp, order, pol, ilx, nid, ALLOC_DEFAULT);
+}
+
 /**
  * vma_alloc_folio - Allocate a folio for a VMA.
  * @gfp: GFP flags.
@@ -2555,7 +2564,7 @@ struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
 		pol = get_task_policy(current);
 
 	return alloc_pages_mpol(gfp, order, pol, NO_INTERLEAVE_INDEX,
-				       numa_node_id());
+				numa_node_id(), ALLOC_DEFAULT);
 }
 
 /**
diff --git a/mm/mempolicy.h b/mm/mempolicy.h
new file mode 100644
index 0000000000000..92d0bb3640962
--- /dev/null
+++ b/mm/mempolicy.h
@@ -0,0 +1,24 @@
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
+#include "page_alloc.h"
+
+#ifdef CONFIG_NUMA
+struct folio *__folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid, unsigned int alloc_flags);
+#else
+static inline struct folio *__folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid, unsigned int alloc_flags)
+{
+	return __folio_alloc_noprof(gfp, order, numa_node_id(), NULL, alloc_flags);
+}
+#endif
+
+#endif
diff --git a/mm/migrate.c b/mm/migrate.c
index 0c772571610d3..583e74cd179c0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2233,7 +2233,7 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
-	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
+	return __folio_alloc(gfp_mask, order, nid, mtc->nmask, ALLOC_DEFAULT);
 }
 
 #ifdef CONFIG_NUMA_MIGRATION
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5f1dea7eee15b..f39b6af3a6b73 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5888,7 +5888,7 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 EXPORT_SYMBOL(alloc_pages_node_noprof);
 
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask)
+		nodemask_t *nodemask, unsigned int alloc_flags)
 {
 	struct page *page;
 
@@ -5898,13 +5898,13 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
 	warn_if_node_offline(preferred_nid, gfp);
 
 	page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
-				    preferred_nid, nodemask, ALLOC_DEFAULT);
+					preferred_nid, nodemask, alloc_flags);
 	return page_rmappable_folio(page);
 }
 
 struct folio *folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 {
-	return __folio_alloc_noprof(gfp, order, nid, NULL);
+	return __folio_alloc_noprof(gfp, order, nid, NULL, ALLOC_DEFAULT);
 }
 EXPORT_SYMBOL(folio_alloc_node_noprof);
 
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 5fa8fc527347c..be83a974edc2b 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -279,7 +279,7 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_n
 #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
 
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask);
+		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
 
 extern void zone_pcp_reset(struct zone *zone);

-- 
2.54.0


