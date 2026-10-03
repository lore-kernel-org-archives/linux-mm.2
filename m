Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9C0CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085526B00AE; Fri,  2 Oct 2026 20:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05CC56B00B0; Fri,  2 Oct 2026 20:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83A66B00AE; Fri,  2 Oct 2026 20:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A59BA6B00AE
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FAFF1A088C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:50 +0000 (UTC)
X-FDA: 85279411980.02.3EB989E
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf06.hostedemail.com (Postfix) with ESMTP id 77E53180003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wDB7VVia;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3m0rAagoKCI41Bz6CyzB65y66y3w.u64305CF-442Dsu2.69y@flex--jthoughton.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3m0rAagoKCI41Bz6CyzB65y66y3w.u64305CF-442Dsu2.69y@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4g1ObsslfRrIxGm9J1WErW3kJq6TK7lBBQX23Z9YIM=;
	b=K5Hukghwvj+y6iyuxRaIwAcrGehjwXhGyKqLQH2qan1nnwnlS5klJ7zCDhPnFXt5WYD5YF
	rpz2+suZP0+njMowLHuEL6QWLL7XLO2P45rHAH+PbCZvu8bfH+SEq8Bo+ji66+A0DhcxsI
	3xqK5G3LrGsys7+XUX/FDDlrtf/5jMg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wDB7VVia;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3m0rAagoKCI41Bz6CyzB65y66y3w.u64305CF-442Dsu2.69y@flex--jthoughton.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3m0rAagoKCI41Bz6CyzB65y66y3w.u64305CF-442Dsu2.69y@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986908;
	b=qZtVv8IILYtZJQ80xFfQ09zTgVbmWdOVnGAY1EsQsDRqt1Gd8aFVJwhK84tY6pDqs/ioNg
	ZXBfLq3mjmkmWkt0zJufqZeqJ+iRt33CuiWakBR29l8TF+oKuLEUHQmmIeJj3Gf8AuLuMc
	ddJxMAvCPJCEwluqvrd5N/WYZ+U8dDA=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39deb05ef51so61839a91.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986907; x=1791591707; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I4g1ObsslfRrIxGm9J1WErW3kJq6TK7lBBQX23Z9YIM=;
        b=wDB7VViaSeHeZ52xs1lXUrySiIBJ0PS7yaciysalBqrAdd9vFpFIboFHt1EftKc6Qu
         FxqQR/cd9/FqbchlopoWX2FOPx1OSAuENtgG0Yp2zFZrdkXr3pCupdQM8EtJyEE7w5E9
         lNoYZsfvJjPYiNbeB3HS2dZxLcmUnHClaRJj0wbd41+vf2kLs6HSt6u3CU2GvJjea69r
         J56XuAEaNc/GCMNdoQX7wLx66g6RAzut2H0frLXnoQCqlsEuY8Zcjqx2RIa2bPD/6IuH
         S+BEQkQDYMeHbpGVJoNUGO7gDDDuiiKl/agTE1gMLb/3f55a8Bxdq1xQFl14x8FJA4TF
         VmYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986907; x=1791591707;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I4g1ObsslfRrIxGm9J1WErW3kJq6TK7lBBQX23Z9YIM=;
        b=t9nWRtUspt9lHFwSBwPX4RxsbbBtiSXcBp3v7T7wKAlfdwz5f3KmpFZl0dFullOhlz
         h1Dtn0fAP5Zcur1Z4JRwaNIXgTofKPDEKec5vSf7ruF1/YOSRm52GncZlExjEXoip7bD
         6Ar3+RVFV6BHwDpQmWRNTj6CUIvinj+v6pEkwDd6Lg83SS/aFNtuQm+e5/8u8nF+ACRq
         ATYBAXw+tZka9bK11ySJhWfYHMYfACibAjecckWVCp8hMpoKpRbQ7WRQfNyjerAZa2F5
         nqpHJUI7QfsOomAUagSe9Xr2jDvgnb0AGwhbEeeyh7BkrAWsEZzyV8XEBlZCH0S0ctg5
         lHKQ==
X-Forwarded-Encrypted: i=1; AKwUvBzR0xrX4EG7yr9cquy2nGaF3zcaoUcwJeNNz29pQug28bduLdtd6y95qr7/fDpKSUuFjdMee1M2cg==@kvack.org
X-Gm-Message-State: AFq9FYLfY/r8r3OGKUmrkkYQqOyxpdtobsSks0OVG8LS6/vz9vyeh1bg
	ysPnJbdFwh+Xr2SaHLxizmVIN7yWWFPXoQ5m74swWI0rCwUb30k+q9jqExW9HDEmRubNI+mAwzg
	B4RoivAeTznqa8Ep/Ime4Nw==
X-Received: from pjbmw9.prod.google.com ([2002:a17:90b:4d09:b0:3a7:239:2141])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c05:b0:3a4:ba6e:65c9 with SMTP id 98e67ed59e1d1-3a6ce963ad0mr1812320a91.59.1790986907076;
 Fri, 02 Oct 2026 17:21:47 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:17 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-15-jthoughton@google.com>
Subject: [PATCH v2 14/20] hugetlb_vmemmap: Add fault injection for in-place
 vmemmap PTE updates
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xuiocyn1wy7cgjr3nh9y5dk8uno315h5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 77E53180003
X-HE-Tag: 1790986908-701362
X-HE-Meta: U2FsdGVkX1+iEUihllSWJGX5TZRUGQypruqrvOZNv297avVmu8Kh5zbrjiSBfV4tcbQTjiGQdihEEMA+qO1W9kZu9qtvD/fKUySoWW4QDiV5QirktkfXjcgGkWExnyD05oG4FR/oVQIiInZSMkLqUJ/IlVmkLsXm/hEb4vMAvVGskF8W2nV4L59ByMaYSQfVvvZ1LjSMtQoFi8FLi5WAC24akb/oMiegUUFgNbEWith7x7NrszlDpcwPvxjiHVM18V0fju9vsQWhP23gFjbFTD6QIUCriM9vSjy1+XCuHlQuHRBqunaGZrhj0QEC7RahMSeQ+yysoDyqz1FdOUjWH1qBX5z5ORfehiBq48CMGbonH43hAuHp/aOdVchIQTBWI9YF7OmQc35tYm8bjH2zQMQcvWtepB95y2E1ofLhrj+0FU9O3NK3kMir2m2jb+2kWzxQHjL/+ENMRQfYLBfAGVW1ESJjTwU1DChp8vQZYQQfb8pqaQrmAN7lhqK0lmpp+9FZQerKyJF7aTYn48z3Ycdn+pnU1SfYl+pYcJlX6wKT7T/XJQbb2rRTgYFvx/r38qV5qQkknQ2L8u2AEQkbhsqo6f4sSuspMmvqeKLbeObQfeXDr9xd6MmL3jqO1YVBbMALGx08GxBKuY+GOgs74va2WTcj4o5k7M80OBr3vUKTSf3qavNyN0YDD5Skn6Cjuv75OVYGAvf5ZAu3OZ+FbBxQI9YrR9g77Ys8QixImu6fVRp1S8YFg7NzWZxCYe1VMOppWxVJ/Ge3yvh8Ve9QStss1okQ/3fxHokSch8cyvL0KTVF/1VM4VDthVqY5v4Vy62YktjgQa7xxXqeLhHM4mhcI5h4R9XHuWRVho0p8EHqm1ccAiKgzcmUJTLg0NsXLCW7kENWhYnXct0AapWmNe7ONFB/hsKRoENy03LoTFiXqII7eDVnuCf3haG50falCz5NnKAFGHY6AocpGYH
 tON0LQlo
 Vxs76wI7BNZsBFLOGoVYbEHOiZL3Nliz/Nl0zcEmav8l4ovhc9FvQvP9lefmrIbzjoRP+2TrjjWkeiQtKMPOPKsQ0sQOe3g8O/8JD7TpIqXqivGEc3McN1D5gb5WTbRGJYQ/oq3f5or83Oz+BrVFi5eyVFarmsyh+EqtaXHkre6ClRBDmo5SuGH/vLXEtJdLM3Qxmw2bsBlVLDNnfCFy8o3PBIjJlF4cHG7vv3jaUEw4vOyx1zSY0lQaR/E6/FluTpMi+kFTZcxQ+2IwvnUUPtA+ujvfHbVD0OJI07YkW/JKCvublSWYjYJVy1D+bBKJBrMcNe4SLWvF3Knbn0Tkve66r/BhI2AAY2yF2YSK9RBm4IyBJXg5cl/HyeGoCPeArxCCp/+Rteh/2a/QOoC7J2Ti6slF8tCtSl1UIIRH9lmRxo3ulxopED/1eoq7KTqPpqZntUZMEiJt3iOG6QaT2WpGGApKOBsmkmRtPVDpi7SQEXlzTCXXJqDQ86BtbLdJhuQYwRRo0SY2VSLAdEEeNChA1j7F3K9Kqex4jGa8P7dj525YJ43fjKiMrv/1AUZcqMKkih8M91HtNUn2xqqdTiGmFsWVKiI8bbb+futYquyAeKkM8LHzpT6yrfd9f4fNFwxvvffr0oJzf8Pw/bNS8XNyfBlJXwuibCrhT6oVw2pA5zfOPWZYkJnL6KavNVxaahVXr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_update_vmemmap_pte() may fail, e.g. on arm64 when the update keeps
racing with hardware access flag updates. HVO handles such failures by
rolling back the optimization, or by leaving folios partially optimized
if the rollback or a later restore fails. These paths are rare to hit
normally.

Add a fault-injection capability, fail_hugetlb_vmemmap_pte, under
CONFIG_FAIL_HUGETLB_VMEMMAP. When a fault is injected, the PTE update
fails with -EAGAIN without touching the page tables, as if the in-place
update had given up.

It can be configured through debugfs or through the
fail_hugetlb_vmemmap_pte= boot option, the latter allowing failures to
be injected when optimizing bootmem folios.

Assisted-by: LLM
Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../fault-injection/fault-injection.rst       |  6 +++
 lib/Kconfig.debug                             |  9 +++++
 mm/hugetlb_vmemmap.c                          | 38 ++++++++++++++++++-
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/Documentation/fault-injection/fault-injection.rst b/Documentation/fault-injection/fault-injection.rst
index c2d3996b5b40..403206645fa4 100644
--- a/Documentation/fault-injection/fault-injection.rst
+++ b/Documentation/fault-injection/fault-injection.rst
@@ -16,6 +16,11 @@ Available fault injection capabilities
 
   injects page allocation failures. (alloc_pages(), get_free_pages(), ...)
 
+- fail_hugetlb_vmemmap_pte
+
+  injects failures of the in-place vmemmap PTE remaps done by HugeTLB vmemmap
+  optimization. (try_update_vmemmap_pte())
+
 - fail_usercopy
 
   injects failures in user memory access functions. (copy_from_user(), get_user(), ...)
@@ -263,6 +268,7 @@ use the boot option::
 
 	failslab=
 	fail_page_alloc=
+	fail_hugetlb_vmemmap_pte=
 	fail_usercopy=
 	fail_make_request=
 	fail_futex=
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 134b15a44625..96cd1f1da94a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2066,6 +2066,15 @@ config FAIL_PAGE_ALLOC
 	help
 	  Provide fault-injection capability for alloc_pages().
 
+config FAIL_HUGETLB_VMEMMAP
+	bool "Fault-injection capability for HugeTLB vmemmap optimization"
+	depends on FAULT_INJECTION && HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	help
+	  Provide fault-injection capability for the in-place vmemmap page
+	  table updates done by HugeTLB vmemmap optimization (HVO), i.e.
+	  try_update_vmemmap_pte(). This exercises the rollback and
+	  partially-optimized folio paths.
+
 config FAULT_INJECTION_USERCOPY
 	bool "Fault injection capability for usercopy functions"
 	depends on FAULT_INJECTION
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index fabf2b25fe59..1eca03a3def3 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -17,6 +17,7 @@
 #include <linux/pgalloc.h>
 #include <linux/vmemmap-optimization.h>
 #include <linux/hugetlb.h>
+#include <linux/fault-inject.h>
 
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
@@ -50,6 +51,39 @@ struct vmemmap_remap_walk {
 	unsigned long		flags;
 };
 
+#ifdef CONFIG_FAIL_HUGETLB_VMEMMAP
+static DECLARE_FAULT_ATTR(fail_hugetlb_vmemmap_pte);
+
+static int __init setup_fail_hugetlb_vmemmap_pte(char *str)
+{
+	return setup_fault_attr(&fail_hugetlb_vmemmap_pte, str);
+}
+__setup("fail_hugetlb_vmemmap_pte=", setup_fail_hugetlb_vmemmap_pte);
+
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+static int __init fail_hugetlb_vmemmap_debugfs(void)
+{
+	fault_create_debugfs_attr("fail_hugetlb_vmemmap_pte", NULL,
+				  &fail_hugetlb_vmemmap_pte);
+	return 0;
+}
+late_initcall(fail_hugetlb_vmemmap_debugfs);
+#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
+
+/*
+ * Inject failures as if the in-place update lost a race too many times
+ * (see the arm64 implementations), without touching the page tables.
+ */
+static int hvo_update_vmemmap_pte(unsigned long addr, pte_t *ptep, pte_t pte)
+{
+	if (should_fail(&fail_hugetlb_vmemmap_pte, PAGE_SIZE))
+		return -EAGAIN;
+	return try_update_vmemmap_pte(addr, ptep, pte);
+}
+#else
+#define hvo_update_vmemmap_pte		try_update_vmemmap_pte
+#endif /* CONFIG_FAIL_HUGETLB_VMEMMAP */
+
 static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 			     struct vmemmap_remap_walk *walk)
 {
@@ -235,7 +269,7 @@ static int vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL_RO);
 	}
 
-	ret = try_update_vmemmap_pte(addr, pte, entry);
+	ret = hvo_update_vmemmap_pte(addr, pte, entry);
 	if (ret)
 		return ret;
 
@@ -279,7 +313,7 @@ static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 	 */
 	smp_wmb();
 
-	ret = try_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL));
+	ret = hvo_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL));
 	if (ret)
 		return ret;
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


