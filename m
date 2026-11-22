Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C8E8606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=eIxmltCX
Received: by kanga.kvack.org (Postfix)
	id 9720B6B05C0; Sun, 22 Nov 2026 13:45:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922FD6B05C2; Sun, 22 Nov 2026 13:45:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839356B05C3; Sun, 22 Nov 2026 13:45:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4414C6B05C0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C614A073D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:16 +0000 (UTC)
X-FDA: 85463632632.05.79378B7
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf19.hostedemail.com (Postfix) with ESMTP id DBD411A000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=eIxmltCX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3OTgDawoKCBY5F3AG23FA92AA270.yA8749GJ-886Hwy6.AD2@flex--jthoughton.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3OTgDawoKCBY5F3AG23FA92AA270.yA8749GJ-886Hwy6.AD2@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373115;
	b=CuZkClm4alb3w9z3+mVTPBAB3LII+eDz/MiTUnA+aLR57iqZu7f3BxRSv8aIyMgapH/HW0
	1B4rlD4MRlVigsaO4sy28E2JSUE/ScSuzJRrxgtLbR3tL9ToLGgmp4wqByFb0Gq13hxH92
	sJYair6QkXHCd5c1SfCUjOUqODxZfmc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TxPlxxAqJE3tW6UmldmaY6HGp5vlDJN47buBYWjQlQE=;
	b=0XSrArjTYydIKE5Xyz96vuShQSU9rG8f+34d3sQxe20gkfk8SoVXoH2eRRq/aXc10gvvU7
	P/JDF6kTpIRACmS4yXllxaYOmVBa3aeRBnhQqJa4DAGt8L9Uq41921OBYafLqAgg9GZng1
	iLO7P2Vi7skVDGDaSsXSVJefjqo1KSE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=eIxmltCX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3OTgDawoKCBY5F3AG23FA92AA270.yA8749GJ-886Hwy6.AD2@flex--jthoughton.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3OTgDawoKCBY5F3AG23FA92AA270.yA8749GJ-886Hwy6.AD2@flex--jthoughton.bounces.google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ed08904845so37289275ad.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373114; x=1795977914; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TxPlxxAqJE3tW6UmldmaY6HGp5vlDJN47buBYWjQlQE=;
        b=eIxmltCXPU1Qb0WkfGbYEbmauBTZZmY/HmKhQkm5Ok43BxIv95NNrY0vW12+hRorWm
         LcCpnEEncnFZPzNBBNWkLbR97SZs82fsQuTl5eBuaqP1RDjJOTw6N9IDnG8C2g94pSE4
         86f/+jxRQkRQHhl97B5zlcjJX/dgyoMJ6NJI2Aa5zFYiabglDN8ZhAzv4eCtAnUu8XAZ
         nW40T7VniRKJf7TLdHZYMY7dtb/ogT3uvuiPOPLWFX8pB26GuwULrRxDEvFVwcX3YwU9
         n6HNYQ+IlRwMjtP6Gy+QKUrG9NGmXV83WkrDLrGC3ZBFOQsBbnU0dUWdpmJMp8P8CLso
         BSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373114; x=1795977914;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TxPlxxAqJE3tW6UmldmaY6HGp5vlDJN47buBYWjQlQE=;
        b=c0y/fyyhvj61NVP7c+sI/jTqkzU/IYncyZvl0UtjyWOeaILzg8lu8vISeT7HIysSml
         xkDotit5lh3FxWj3sa1nUsGbF42bjQzHPC6G0pXBhYDL2MxaL8NeoC4O9DqjwMcqzvhR
         ZZfhxP1i/gdm4KUe2Kt1HdNjX8MnpQuV/3fTh2wExP/t/UUJPrKHt8Ik3YwDlH3BT5UH
         VH9sw6AHCAXGw1XosXeDK6eqFwGgHo2SZsjlfVrFQn0f7LHCOVpAVPT+JwcbMb7N/MUG
         kC8EGaZC9lJNEk71r1ekiqlK1bL9zlilwBQ8v2CnBHmI2YqX7eSrIDdjnl1NJIqWCtOY
         51Pg==
X-Forwarded-Encrypted: i=1; AL+hErEBeikpW2TBMMU4plMFsKgH2H9IXLaLCWWimZQNANlzTRwgihPB87YFWr0PVKR1He3MPg8RE4Z+fA==@kvack.org
X-Gm-Message-State: APuU4Z88AEDtZi1ktJ7EuIGYjFcepJOQf4bU9nMMGDhbehFPg8tBSzOX
	ZTTgg3dYmMJyBI23SztTFVe01YDUiXvPekxxftttL5fYhALcsdmaJkjt5maCDOH0AB9Qi90KPYc
	YqIWmTp0WmrNqObKKBiA6aw==
X-Received: from plfn5.prod.google.com ([2002:a17:902:e545:b0:2ef:d037:6013])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d2cf:b0:2f0:25ea:8fb3 with SMTP id d9443c01a7336-2f03efb1073mr100873735ad.1.1795373113358;
 Sun, 22 Nov 2026 10:45:13 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:47 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-14-jthoughton@google.com>
Subject: [PATCH v3 13/19] hugetlb_vmemmap: Add fault injection for in-place
 vmemmap PTE updates
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: isnsj7r4mkrym1k83cbizx9smhirk9ik
X-Rspam-User:
X-Rspamd-Queue-Id: DBD411A000A
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795373114-782031
X-HE-Meta: U2FsdGVkX1+Mw6ksm5NyMvoaxXd6a93ooMSGf8ZBdGOjRTw+5a7ksG+sWyBoZHNM1FbohAamYSX5iqpQICboGWoy0jFquww1ksPbcets8zCNfJG4qFrf6WV9QPCnYCYOy0CpOIoNvcOv+jWOWCsg1hwVJVfjb2t+ojdQLnpqz9M0pUqb88hIWBuMr3+TQLkjri6WZniaFqEQ06tozQ9QucDrYC/sozlMTQMoHjOs3yIpDbtmgUYfeprk9gTntOjHS72SRfbPY/a3gUc6Esk7fCcvSvwfuDknifuxkn/09pkB7US2aUOjU4QGs45T2DXEMy2Et5o8yvI79l6oO21nNmi+8ryFWfQcwU2CVItpjj9+WffzZU7sjC//05eqY1pdLa82xY8/F+Q6zWPSbtNwkLYZqdOIvzftqDhUi5RiOLclhHnTzn3xohjZP/Rdv1DhO54/eYOy+m60bsGikncc1U7YgunhSAMXGDPchdDIzK6A9Mxu3JD8rhcGgGSyIfQaLt49w1IX+/Zx2BfOajWTSq646OF0H9SlgVpSQ8ZFysN7vq0cCJTo2RP/X5zFcvcP+/FOmTh3GvBHOeB1hWyVt1Ix8VuRxmbRk6+DbVdcc9FyhRUEnUsVlUTY153gJotzL484jQtimhrdzS178fgUqLQIy/9gHdP92pGCdJN1Wq6RtCogEZtiLi7gL49yFBDPz7Tnfw3PbqJMUEm/nCZOzvaD7AHjZ4vI5JwmRRFdZKCmPF4w7oqZfqfktiV01wGy6f7C8hx/Nat17SDNtZEPNoai5MoA6rTB8aUEZcLtPs6vv+YmlxQ6XP2nltfmzZaI3v52BMqeG/YvDJHK3vP0kJxaklZcJhb2DITbYVWNB9RYgqM4Q17IFc/OpV7uElEAw70j9lz+0V2PY3SiqyZR9PtcqMEQHOCF1nZYbHTkBStiny+VZKr4Xq0Kk5RIs4kPE1LUEBa1C5PNH+EhxZO
 pSLoJQLf
 zhxc5edTuNrdYz+8nZxmoBekCktmgwBO1Tr0FnaG5Ml7veSpddL/GvHQYysmuxrsov4tC4O0bu6MHuD9N5uwdr8zhqVYwSCecOCu9rLAyk5Au+GMoTEUjq1TJ9OgVKrn9quAv74ADD3Uzu1i/9qRD/VnKGTno4N6Xc68k6c1q25S3LVPLcrE0H2cYAWGRNFeWhHZOwc8vQuiv9sD8sLuYvobGXT717cZ52JC3v2eCNGRMUh5ReyUwkdXbXo7R0nclSsPZj44SeLQLKoRdWQItfxxvTomK162PQAD7IzekmvXz3nE96v4qS+5E01oLzXxI3Pk/BTakqt7u4lK1im1R8daHnr+WQFB9Bi1GOYnYBmo1HPz3cG/EOgYOEx5UlUV12iu/xF5d0qsnQIANY7r3DTBqtMHcQRSrI7oPGMAcwq3zc1uI+MadW48GZpRAQ3Efl6xh5ALSMJOF2Ac/x/Q90MLSOjhRDjIkxzQQvh9mxxxK4DFrd6GU5chwbz3Q22EVoGzMQh5nIzqF7ZvDBkAUsn41RPJ4pUTIPq5oUZOsSC7H6wRJixbPIZ42YDdHSl1l3NAvbRUkbLxjNoiYxQs6BbxzSk6jdcO04dFo2+zO2XMAmkqGQFtXROcwL8SubZX5+hAF0RiVd/TJEL27HhsrBGSKMUek2LzdDJGkfofoAgYcFkXOmbpyNAxB8WFPAbrdh2OjEMKNuyzojyx4MqQuOUMjQAhcgclwnZP5ewKk1d7CESRtLi4FbbFJhu6bJNTYmMrGcQ/DfGJGwS4GDvyNdr6+ZJy8duWIyNryRqv+dHUzCnEkrCBex7q3ZDf+hO2zPUf3rOe4rZCeHcwprQCUo7RjilmlWk9/jhIISYV+Jlf4tfEoiqoR9nRRBV5mHR6B238T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  1 +
 .../fault-injection/fault-injection.rst       |  6 +++
 lib/Kconfig.debug                             |  9 +++++
 mm/hugetlb_vmemmap.c                          | 38 ++++++++++++++++++-
 4 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 176648941aec..b8a8771631c0 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1694,6 +1694,7 @@ Kernel parameters
 	fail_usercopy=
 	fail_page_alloc=
 	fail_skb_realloc=
+	fail_hugetlb_vmemmap_pte=
 	fail_make_request=[KNL]
 			General fault injection mechanism.
 			Format: <interval>,<probability>,<space>,<times>
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
index 2d22638ec13a..a6a9bc01a320 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2098,6 +2098,15 @@ config FAIL_PAGE_ALLOC
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
index a01377c37c96..4cacd7aee719 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -17,6 +17,7 @@
 #include <linux/pgalloc.h>
 #include <linux/rwsem.h>
 #include <linux/vmemmap-optimization.h>
+#include <linux/fault-inject.h>
 
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
@@ -44,6 +45,39 @@ struct vmemmap_remap_walk {
 
 DECLARE_RWSEM(vmemmap_remap_rwsem);
 
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
@@ -274,7 +308,7 @@ static int vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
 	 * after it. The refcount is zero, so the cmpxchg fails and leaves the
 	 * page unchanged.
 	 */
-	ret = try_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL));
+	ret = hvo_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL));
 	if (ret)
 		return ret;
 
@@ -313,7 +347,7 @@ static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 		return 0;
 
 	dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
-	ret = try_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL));
+	ret = hvo_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL));
 	if (ret)
 		return ret;
 
-- 
2.56.1.809.ga0b61035b5-goog


