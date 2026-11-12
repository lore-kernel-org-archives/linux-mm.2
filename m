Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BF0606A8AE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=pW1q9ZnK
Received: by kanga.kvack.org (Postfix)
	id 045096B05BC; Thu, 12 Nov 2026 07:56:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34A16B05BD; Thu, 12 Nov 2026 07:56:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0EA6B05BE; Thu, 12 Nov 2026 07:56:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC7D6B05BC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:56:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CB59C058A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:56:54 +0000 (UTC)
X-FDA: 85426466748.26.383F2E1
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id D7FD1180004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:56:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=pW1q9ZnK;
	spf=pass (imf16.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2tr6CmVJPxgvJcaHtBjGtsKyEj3R3TudMQySxquzWs=;
	b=rqWqtQo+OHcipm4VIvCcAFnzKAPYncZU9YwcGTu87vgOKWAThk6uv9y2IywcTHOmi2ydTL
	LFKL8pYyKhHFvNUaVpOccukG/Ws/ZoCAxNw+2mKc6Fhr7/UojIDlz285P8NkBbiNZB93XO
	hCX1va9QOxml3TJFNPlyIbLU0uZrSYo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=pW1q9ZnK;
	spf=pass (imf16.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488212;
	b=EcWJwc9CqW7fXXtVox2tyaY4kw5qiBKt4gv8YkvsEHhBzsk8TAOxgbit+EjYyQtfyfo3dm
	oNJ8DJfQYgz+EeZ4y0UacRf31Dh0Tbcar/rMmOfCiF5a5Z0TOyBQwcl3yVm4lYO0szWLUx
	WKutgpMnD19wWE+2ipGNz8vD9ZD8QbE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794488212; x=1826024212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J2tr6CmVJPxgvJcaHtBjGtsKyEj3R3TudMQySxquzWs=;
  b=pW1q9ZnKPgSiSyPJdNEEPWSJcWPxqIT4LGNhtMCYJfNMHSB+PPreEZZK
   gR6JaG2VjqCqJYjZuY+BLKlIg8m9ehq5FJqQGnjeKem0kQTksobBmjOw1
   Gi2Ntkj7A1hYlddXVQuwKPgLFGwzFKZ6Y4bSGqhfL4SFMx5BiGRdV8sD1
   Cbv/dF/GKAauT6yb1qyuBYRXb6f2QKxeThd+aej1SSquBRL9/fQl4AOw+
   8M9zylug2OfqsIMwYZz8j/bEXNbhdfnvL+n8q7FkFkic95EIkUXB6vmoR
   pQVDk/DkJ7ezKDBFnsmdt3IMKiwBF68Z4ISp9atdO9tXYx5n1XkEsETuH
   A==;
X-CSE-ConnectionGUID: txv+//OAQemCHMTRkhRk8A==
X-CSE-MsgGUID: AnSJ6e6KQEKwCNkr3FxRBQ==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33788383"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:56:48 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:15137]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.61:2525] with esmtp (Farcaster)
 id 7af3b9b8-e90e-4072-981a-146aa3fd39fb; Thu, 12 Nov 2026 12:56:48 +0000 (UTC)
X-Farcaster-Flow-ID: 7af3b9b8-e90e-4072-981a-146aa3fd39fb
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 12:56:47 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 12:56:45 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, David Hildenbrand <david@kernel.org>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Eliav Farber <farbere@amazon.com>
Subject: [PATCH v2 1/4] mm: add MMAP_PFN_TRACK action and pfn_range_track() for lazy PFN maps
Date: Thu, 12 Nov 2026 12:56:35 +0000
Message-ID: <20261112125638.12209-2-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112125638.12209-1-farbere@amazon.com>
References: <20261112125638.12209-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: qp8ztrindpq83yjje3ys3ysn74czk9x9
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D7FD1180004
X-HE-Tag: 1794488211-142890
X-HE-Meta: U2FsdGVkX18FY0wC32d0ePmEyH9lPCsqj7yI/BVv2KX6u3s2lXcNVKppKZHKw1/qFf8nIGPZ7zJjkeDgB4oaiI5BrD9QSALDBbGtBIUo26NUMPztSCipnyXvNU6iRMamYrKpZlZH7Xqon8d1N37BUB0FZbIaAbq1geK5+nKdXEThxt5n03R6B+qm7nxVROo7cAVoTYeD+F7NGiCRunLC6qOSqrp7OkByAjUY35NBdFphO/ai8LyuiZwQ8Akb6zJezREWb7c5gMtesR/0P0VVTh42BTi6beugQRHHWFg3ZYjpixJDBRHMPx1LLkq7jGfmCpvydDygDZ6dQLttNw+aSLl181lPA5LmFdpYpPhMCfqoWhXCzfng+03sAQiy/b3da1cib1NeJCk2QD6RGb+qoUCR3YEgHTRbuItgGy4JAsfex8j11imYIxBqXrrrZiqiOH8tWitwdPifqI6vwlBghp+LHPQpKUdqBSRus+8FHcyctIrMERqJ2uHiyRFGMpVTbnbBxv2EqSHWZqTuprJs7Wp0tTaF4URIHHh6dR8OFoBAilhDhqK0XOu7qphbYKPPYaxhFNcjQcrQQjbyh4SM6uoXWo5gR90vD5pdMFgGm3Ab7pkBd7LB2x6KWs2rq8MfBf1GoxVx5QVKLE5LGzOU4lz7o3WEVDjDP3aQvwJctOPYe2SeP52HRVpVCOvi4qtcyS9epDywV9Z9Wqg3fkAzfbG65R6yprMuMuU/d5x/a7aU6uvaFTWDj4eydPF7mTMI5ySDESZ8pZqH92dd6Ic23M9nKAjxL2ltPPnnWmkxoeZxUgMKfbqye913fo3DLz67tgqcROXVBHJtlJUgORWX4ccQcOnLdTdStmcp6aSWN4MeIAS8AAmEmgbYR3LTEwYyfgDILHn+2s/D6B4/IHdfMe3VhJaxLsocw9TAs2/WxFXh7Kj769yNM73tpl7bQxfiBbpSqBCd23MZ2+CRe6c
 Fo0MLKzR
 cF3qoQR8ua0FXKcwFJ/atsLHtFNfmW7n6ChVpfeEVGI9PrXy90njPklJx4/ae1iqkOci2jKxT5QmVUgkwVx9pzjuXZ/TTJbJX9VcZUM9EkJLzVDmcZF/2kK4Cvq9+TLHwmu8VVDTtVAH/RIHgFvM/1Y8h64T4APch/XdU2gNP/Exw/nuZqObEZMhLHKqv3eqE/TD4bQczCRs46cY36+2oBnxaWH8CndPgvcJepv4owBBXifQMvtSoV5AKdAPn+CbUxkPPjHcpXhlUmo69TbVgiOgW2RxWSKiMhbr5deUORPwg1yzQz6Ik7cStjms+FVizm3+eUb8xcJYKNVkHgYo7prYy7K66003CfEYffSFenDP4fmDTeWB7Xte4kDx8IP89ouVGajgupje7xKlNVaFF7rheGIDjs5HNPn58P7qDb9Jn7Nx5fM1JG0tvGyZtSkL5uQorRhCq0kl3QI/ryPtquo+74BqfO5J3eaTpiZ7h8R3lculdrTdD4kdea1wKNjzp9DVYQ9ly0NuKlIZ2TtsaX+7jQFUehfgjPXd2Jj33cbcNwKhWUeUPquZa+Qeb5/5py2qwDysQK+wgbJp8G8BdFvCzl+HOG5Ir3BHtI3KkTepKinQy844vTGqyYD18QLYY901iU62FW4OvgDNjKLCP22qGg/q9rSrBnMYMfrc8Pjx7wTTiYgY2A/6FM3DI7TCaDB9JfRX/qaRCVfumSUldhdlX+F9r6RdKLh2vvnbPyamuNvNSMboEN5AfoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Drivers that expose a physical PFN range to userspace have traditionally
used remap_pfn_range(), which both populates the page tables eagerly and,
on x86, reserves the range's memory type in the PAT memtype tree via
pfnmap_track() -> reserve_pfn_range() -> memtype_reserve(). That
reservation is what lets the kernel detect and reject a second mapping of
the same physical range with a conflicting cache attribute (e.g. WB vs
UC/WC), which can otherwise cause data corruption or inconsistent cache
state.

Drivers that instead populate a PFN mapping lazily from a fault handler
(via vmf_insert_pfn()/vmf_insert_pfn_pmd()/vmf_insert_pfn_pud(), e.g. to
obtain huge PFN mappings on fault) get no such reservation: those helpers
only call pfnmap_setup_cachemode_pfn(), a lookup-only wrapper that never
reserves. Such mappings are therefore never registered in the PAT memtype
tree and conflicting mappings go undetected.

Add pfn_range_track(): it sets up the VMA exactly as remap_pfn_range()
would (VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP flags), reserves
and tracks the whole VMA's PFN range for its lifetime by attaching a
pfnmap_track_ctx to the VMA (released automatically on VMA teardown),
but does not populate any page tables - population is left to the
caller's fault handler. COW mappings are rejected, as the fault-driven
vmf_insert_pfn*() helpers cannot populate them.

On architectures without PFN tracking (!__HAVE_PFNMAP_TRACKING) the
reservation is a no-op, matching remap_pfn_range()'s notrack path; the
VMA flag setup still happens.

For drivers that use ->mmap_prepare, where no VMA exists yet, add an
MMAP_PFN_TRACK mmap action and a mmap_action_pfn_track() helper. It sets
up the VMA like MMAP_REMAP_PFN, and on completion tracks the range like
pfn_range_track() instead of populating it. Mirror the new action type
in the tools/testing/vma copy of the enum.

Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/mm.h              | 19 +++++++
 include/linux/mm_types.h        |  1 +
 mm/internal.h                   |  3 ++
 mm/memory.c                     | 93 +++++++++++++++++++++++++++++++++
 mm/util.c                       |  7 +++
 tools/testing/vma/include/dup.h |  1 +
 6 files changed, 124 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6af3b7008f1a..c11bdee1596a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4752,6 +4752,23 @@ static inline void mmap_action_ioremap_full(struct vm_area_desc *desc,
 	mmap_action_ioremap(desc, desc->start, start_pfn, vma_desc_size(desc));
 }
 
+/**
+ * mmap_action_pfn_track - helper for mmap_prepare hook to specify that the PFN
+ * range backing the entirety of a VMA should be tracked, but not mapped.
+ * @desc: The VMA descriptor for the VMA.
+ * @start_pfn: The first PFN in the range.
+ *
+ * The VMA is set up as for mmap_action_remap_full(), but no page tables are
+ * populated: the mapping is populated on demand from the driver's fault
+ * handler. Must not be used for a COW mapping. See pfn_range_track().
+ */
+static inline void mmap_action_pfn_track(struct vm_area_desc *desc,
+					 unsigned long start_pfn)
+{
+	mmap_action_remap_full(desc, start_pfn);
+	desc->action.type = MMAP_PFN_TRACK;
+}
+
 /**
  * mmap_action_simple_ioremap - helper for mmap_prepare hook to specify that the
  * physical range in [start_phys_addr, start_phys_addr + size) should be I/O
@@ -4973,6 +4990,8 @@ struct vm_area_struct *find_extend_vma_locked(struct mm_struct *,
 		unsigned long addr);
 int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		    unsigned long pfn, unsigned long size, pgprot_t pgprot);
+int pfn_range_track(struct vm_area_struct *vma, unsigned long addr,
+		    unsigned long pfn, unsigned long size);
 
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ed35d258d2e..b4dfc1b12c2e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -821,6 +821,7 @@ enum mmap_action_type {
 	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
 	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
 	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
+	MMAP_PFN_TRACK,			/* Track PFN range, map on fault. */
 };
 
 enum discontig_kernel_page_action {
diff --git a/mm/internal.h b/mm/internal.h
index e3f92883bf23..58a81f6041a9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1546,6 +1546,9 @@ int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
 int remap_pfn_range_prepare(struct vm_area_desc *desc);
 int remap_pfn_range_complete(struct vm_area_struct *vma,
 			     struct mmap_action *action);
+int pfn_range_track_prepare(struct vm_area_desc *desc);
+int pfn_range_track_complete(struct vm_area_struct *vma,
+			     struct mmap_action *action);
 int simple_ioremap_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_complete(struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index ec3d9d99ccee..ab29ec719ae1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3420,6 +3420,99 @@ int remap_pfn_range_complete(struct vm_area_struct *vma,
 	return do_remap_pfn_range(vma, start, pfn, size, prot);
 }
 
+#ifdef __HAVE_PFNMAP_TRACKING
+static int do_pfn_range_track(struct vm_area_struct *vma, unsigned long pfn,
+			      unsigned long size)
+{
+	pgprot_t prot = vma->vm_page_prot;
+	struct pfnmap_track_ctx *ctx;
+
+	if (vma->pfnmap_track_ctx)
+		return -EINVAL;
+
+	/*
+	 * prot only receives the reserved cachemode here; the fault-time
+	 * vmf_insert_pfn*() helpers look it up again via
+	 * pfnmap_setup_cachemode_pfn().
+	 */
+	ctx = pfnmap_track_ctx_alloc(pfn, PAGE_ALIGN(size), &prot);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	vma->pfnmap_track_ctx = ctx;
+	return 0;
+}
+#else
+static int do_pfn_range_track(struct vm_area_struct *vma, unsigned long pfn,
+			      unsigned long size)
+{
+	/* No PFN tracking on this arch; cachemode is left as-is. */
+	return 0;
+}
+#endif
+
+/**
+ * pfn_range_track - reserve and track a PFN range for a VMA without populating
+ * @vma: user vma to track the range for
+ * @addr: target page aligned user address to start at
+ * @pfn: page frame number of kernel physical memory address
+ * @size: size of mapping area
+ *
+ * Reserves the PFN range's memory type (PAT on x86) and attaches a tracking
+ * context to @vma for its lifetime, so that conflicting cache-attribute
+ * mappings of the same physical range are detected, but does not create any
+ * page table entries. Intended for drivers that populate the mapping lazily
+ * from a fault handler (e.g. via vmf_insert_pfn()), where the fault helpers
+ * only look up the cachemode and do not perform the reservation themselves. The
+ * VMA flags remap_pfn_range() would have set are set here too.
+ *
+ * Must cover the whole VMA. Must not be a COW mapping: the fault-driven
+ * vmf_insert_pfn*() helpers cannot populate one. Must be called with the mmap
+ * lock held for writing: it sets VMA flags and attaches the tracking context.
+ *
+ * Return: %0 on success, negative error code otherwise.
+ */
+int pfn_range_track(struct vm_area_struct *vma, unsigned long addr,
+		    unsigned long pfn, unsigned long size)
+{
+	int err;
+
+	if (vma_is_cow_mapping(vma))
+		return -EINVAL;
+
+	if (addr != vma->vm_start || addr + PAGE_ALIGN(size) != vma->vm_end)
+		return -EINVAL;
+
+	err = remap_pfn_range_prepare_vma(vma, addr, pfn, size);
+	if (err)
+		return err;
+
+	return do_pfn_range_track(vma, pfn, size);
+}
+EXPORT_SYMBOL_GPL(pfn_range_track);
+
+int pfn_range_track_prepare(struct vm_area_desc *desc)
+{
+	const struct mmap_action *action = &desc->action;
+
+	/* See pfn_range_track(). */
+	if (vma_desc_is_cow_mapping(desc))
+		return -EINVAL;
+
+	if (action->remap.start != desc->start ||
+	    action->remap.size != vma_desc_size(desc))
+		return -EINVAL;
+
+	return remap_pfn_range_prepare(desc);
+}
+
+int pfn_range_track_complete(struct vm_area_struct *vma,
+			     struct mmap_action *action)
+{
+	return do_pfn_range_track(vma, action->remap.start_pfn,
+				  action->remap.size);
+}
+
 static int __simple_ioremap_prep(unsigned long vm_len, pgoff_t vm_pgoff,
 				 phys_addr_t start_phys, unsigned long size,
 				 unsigned long *pfnp)
diff --git a/mm/util.c b/mm/util.c
index 80f6c714844f..5332030ed370 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1546,6 +1546,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return 0;
 	case MMAP_REMAP_PFN:
 		return remap_pfn_range_prepare(desc);
+	case MMAP_PFN_TRACK:
+		return pfn_range_track_prepare(desc);
 	case MMAP_IO_REMAP_PFN:
 		return io_remap_pfn_range_prepare(desc);
 	case MMAP_SIMPLE_IO_REMAP:
@@ -1583,6 +1585,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 		err = remap_pfn_range_complete(vma, action);
 		break;
+	case MMAP_PFN_TRACK:
+		err = pfn_range_track_complete(vma, action);
+		break;
 	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
@@ -1611,6 +1616,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
 	case MMAP_DISCONTIG_KERNEL_PAGES:
+	case MMAP_PFN_TRACK:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1633,6 +1639,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
 	case MMAP_DISCONTIG_KERNEL_PAGES:
+	case MMAP_PFN_TRACK:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index dc4927d26296..7bb7392c7fb5 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -455,6 +455,7 @@ enum mmap_action_type {
 	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
 	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
 	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
+	MMAP_PFN_TRACK,			/* Track PFN range, map on fault. */
 };
 
 /*

base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620
-- 
2.47.3


