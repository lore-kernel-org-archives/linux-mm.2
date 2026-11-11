Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1E8606A336
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=XGv1BJX0
Received: by kanga.kvack.org (Postfix)
	id 540866B05B3; Wed, 11 Nov 2026 06:31:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517C76B05B4; Wed, 11 Nov 2026 06:31:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DFF6B05B5; Wed, 11 Nov 2026 06:31:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 141C96B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:31:01 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A596C1C2F6C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:31:00 +0000 (UTC)
X-FDA: 85422621480.01.06967CC
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf07.hostedemail.com (Postfix) with ESMTP id 734A940004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:30:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XGv1BJX0;
	spf=pass (imf07.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794396658;
	b=3ZJc/VLQN8UywvmZ6oDqmHjbYVU1+FjgT/2vrv1G0NrqRncrJjosHlheeru5T29t5SDj+S
	vUV8AyNPVHXqkDgoH2+52UoKuZpbTTRj/RVFlCtLY3v3MHtqOsYxDMZVpJkJEG5wRkkbif
	uBz8Cx6ejEu6+ck7n1IF63N2rZEStPk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XGv1BJX0;
	spf=pass (imf07.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794396658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBMjWezikr45NoJ66aB47iMoKkdotttd3ck0karoe8g=;
	b=xJWoY7wE/6elPZONG+nSqPXeqdstDTcG1/ONVRNRmbU6azwc98oGKgfbxfDFYu3zgKuNfP
	xHvNyZ0iiIdKnINESqtUgpJKJXx2LeBAHymKp8jCmGM12/ANpTdjvvb008SWVmxoKzioki
	fyJM7ZqQf2Y/kw0K+trsBiPETJwFogA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794396658; x=1825932658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RBMjWezikr45NoJ66aB47iMoKkdotttd3ck0karoe8g=;
  b=XGv1BJX0IlmIALu77BOPjnTacizczwwUnF7cryXD1QUvArKCwwAYnT0W
   3cm9AK/Rytx4CZqb67qM0QMtgsC326nlQjA0PgWNr7Wo8ESQQlM+r4zQ9
   naVUw+onfUY+RWAiydFBDxPPa9MG7MYIUacf2UL/pVdJgFosTYrDjUEZ1
   2z5D+62OWIeb0eIhceA1xOR8X1mCQcdERCFgR+84wg2dW7VEVoQc5lWDi
   pbeCxbyak8AdBo9babJPF0FVEffhDMX+YINzR9P13DCdBRwiqHLcZUeBZ
   BCyRr9kEC6rLraMZxJe/eshIpSutNTH506JISDePYiGjX6MzsLZdPGp3D
   g==;
X-CSE-ConnectionGUID: 7WZUimJ7SEqG4s0iEl+c0Q==
X-CSE-MsgGUID: 4wT+xqG7TnaeYfLrx8kMhg==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33704163"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 11:30:55 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:23569]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.128:2525] with esmtp (Farcaster)
 id 4ba67a46-d01e-48b2-92a7-4753eaddb340; Wed, 11 Nov 2026 11:30:54 +0000 (UTC)
X-Farcaster-Flow-ID: 4ba67a46-d01e-48b2-92a7-4753eaddb340
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 11:30:54 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 11:30:52 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 1/4] mm: add MMAP_PFN_TRACK action and pfn_range_track() for lazy PFN maps
Date: Wed, 11 Nov 2026 11:30:42 +0000
Message-ID: <20261111113045.35368-2-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111113045.35368-1-farbere@amazon.com>
References: <20261111113045.35368-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: ojzkj7qewu9orptkhqpffziye9dc1gu9
X-Rspamd-Queue-Id: 734A940004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794396658-642440
X-HE-Meta: U2FsdGVkX1/sNr76nGK6KrJI8AORmUX++PO+Xrqfz0tsD04ZkGVziHcM1mX8pH8mxtwhPLp+umWzWIBgAeKyeo619a6RI1100KfF3GnTCYTcZx21Oq1Ks2AzvSTINJ5F7tDdD8gf1Z98t8fMvN4Mh/aNoAfAocZ2nnwCeaTs/gp647ULsoYJui/DixE9hfRW35kSedyJsjssrWXOxnK0Kq+cWhhGzLiRrpRl9eHj6OEcP6v4Muh8EwQ2RtRnNW3otCbcQ8V2xQ5jtqDjPry+ylLbfHUs2M+IkaiVc8otU9TYVSJO3vlHnwmHTgz0dIs1OXrTOv01QsGit7Ts38CURbEDpUHOaNR/Wr3C02yyBrsd1b9+W1upVfY98KpoSvRWJzzkenYz3bHk/w1R1tMSv5hByvpsmbeJDnZCZPc/FXQzECohM8BIVVsBIidCBqGqsy2CMhrKT+T8W4gQt8MF31l9tpT9YmdW6klyjQRvKdTr5qtQzD74Ic00VF1IuXl/6L6OM9WYy2SifEHY4jD7rTmfo5xtFnsL4OZQRWTi7i9rl/tSCHE6rOdFKafjQA8WGV8n0R0mxdzwT73glrcEyUeT6IaEH4UgIN5I7wNS0HRKahEiY6SSnIU6qut9SQ7i1zenTzHZELn6tHqdOZc39sAMiz3B6HxuoSgFh3d7vp579KRThpZuZgVQq0cs5JGJfOldBJcW8kS8oa7efGAZbeSQg+wzP+Mg3vpP+oSXEfw4dUxeZhlB9OWJs7VZo1SMb7brEIJLgD3L+u7C9RYLWGgjMxhmzGrSsHjDf4Z1dNg21JJ7JPHyus3sVyVCsjCV9V2dsxnC4K3ifBHL9g27IF/qQ5X12Nz5nJ3HHoKddFEDW73PNnYw+JLo2TmR0QgNi+gxyGiQFT0ExIPyNPxNKs4ocpIoWLS8xcgjcyoq+wd7gV4FSOL0n9mlyzXiyizoaqj21QMClWBiObB2/r+
 VEYr5RIB
 /V16eLoUTRKgLN6ou4Nz3ZijC8+QbcxObofk6b+ol2ITdY510B5uYrpotY6g9jiLFIUZK+kV4c9P6vAmSVDdc5KCGP48rVgICC79o5N4BxoxjMsh2Y4o5cQmREWhdtrJ/ZFL+FWkStmTW/RqChXskfUp1p/Y+OIY1o/panTdl3lxVqEUM/onrWpvRuHok1pDvsnft2wKcfOPmbvYMII9M+NioumdCuZen1P4O6qK1IQ7S+NB86Yejzeo2ZNcyEmptUAnZj1Cx7VRq+LvAg8LvwpUCMRjo9NA5hbn9X9pxg6pMYrdFOKExvW1Gar1q+BNo+dzVIGv/edfVmCD4IYvplX8NyHrlxdWZ14OXTxg6Q3Ch1/o0SBDkuqD0LVYc7CVDblcjiubP2UEXCS/C0nb3tJUSs7i0rWx03X9EHNjIl8gd+Gm/e14fvYRrMF+a2NGJKZg6cXmRxrD0g7p4O8DrJGzYfx7KdiaS0kPJ9ZZ6dZWnN3PIbSDJUdfJaepZqtAq5JAlpP5QCpwKGdTcRwYIZdnLswkSV9NW31G5K7sFR66ezNr1gWx2aH+x0C+njvPUb8Gl/z9Tm31H+90mXbMcucvkUivGE9QMC+kPvIAvDJRoaD0b6LcgyZSF8bz8Q5W4nRrBx9ZjqAyv+mZuU8bRsvzY/I5Vn9WwFXlRhV6UDohDVBwIS40fa9bJ3rOebNGN6c6623kC+tjbPmvTJ6MYJbMl5wo4UY6cVzGv5yuPRRBQzk28FMpKr3zUDzrjlf28hLUw
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
-- 
2.47.3


