Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44F6A606A337
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=m0iZdjVD
Received: by kanga.kvack.org (Postfix)
	id 48B356B05BE; Thu, 12 Nov 2026 07:56:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461DF6B05BF; Thu, 12 Nov 2026 07:56:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329FC6B05C0; Thu, 12 Nov 2026 07:56:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 052FF6B05BE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:56:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A63FA75AB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:56:58 +0000 (UTC)
X-FDA: 85426466916.03.1112B9F
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf12.hostedemail.com (Postfix) with ESMTP id 63BEA40003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:56:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=m0iZdjVD;
	spf=pass (imf12.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/d4ZrZKEqMTH1maihvf8QldnzgMpcXtRE7WhIed8OE=;
	b=3CnPysTjkjfawoziMYtxDZlCKoE7QOCgdSN2CTqsJfH0UYi47MYSSu+GCPG5XJyPu1I/QR
	1XaBc3rtrGdsIbOaE0wrchrTLONHoX+IMf010EXq5eG1i6OTXGKh7FKLDFskf6VYuymboo
	uOmy+umOw7YAugrHKIrRqbnDLG92sS0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=m0iZdjVD;
	spf=pass (imf12.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488216;
	b=Hjq/cpVrTRhJK30nA1Lmk/Zk1sQw0v/oT4cWz1hxmwihsF21X6QxEGMdYrrCwiTaV4Btc8
	kF8wUBAOToWtZIbsPXQFV0kXBanb+P6QaPS87C37qwScXs8M7mOhGcP8cOnmqvCs3Nu195
	/el0Y3NgMvLN9PT/JzNiv+SEG8/CEIQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794488216; x=1826024216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D/d4ZrZKEqMTH1maihvf8QldnzgMpcXtRE7WhIed8OE=;
  b=m0iZdjVD1gY1wM0FAVrjA0/p9k2zV3FdAdRO6Fl+8dlA72XTjhBKOcRc
   RLXD6rSdldkpSZBwqtcrlECOYeyOUpkMdRqoOVKwmoJ6aqT9nfuQxfFGj
   qMXJ7xWIblTLb8RUeIXqFNVM1Vp9pDZ+10kGg84tjHQ0+uJqIsYku0TKh
   iZ3Sc2K4ev0+73QzJypfjB1wFaG4ndkzV4s/rRx5jQ0tOwqBHehl9I4/3
   ATqbQQW2j6UZDd40iLKmzShU9BH3ayRxhQUpWDW+KnTBXUw69taY8euns
   V3ND2ueEekTjvZH5q+GTfQe4q6s8r06A+yIY6BXtd66Uf3aaJMgn/iKSQ
   w==;
X-CSE-ConnectionGUID: 0bekGHWISNGLadMSnjM1lQ==
X-CSE-MsgGUID: TIokyFAQTdCLgg1s/P28Uw==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33728083"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:56:50 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:12720]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.142:2525] with esmtp (Farcaster)
 id 04382821-b0dc-4ada-83da-4360efc3a3c1; Thu, 12 Nov 2026 12:56:50 +0000 (UTC)
X-Farcaster-Flow-ID: 04382821-b0dc-4ada-83da-4360efc3a3c1
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 12:56:50 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 12:56:47 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, David Hildenbrand <david@kernel.org>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Eliav Farber <farbere@amazon.com>
Subject: [PATCH v2 2/4] mm: add vmf_insert_pfn_order() and vmf_pfn_order_ok() helpers
Date: Thu, 12 Nov 2026 12:56:36 +0000
Message-ID: <20261112125638.12209-3-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112125638.12209-1-farbere@amazon.com>
References: <20261112125638.12209-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: t34m3amgcxn9ytrfscoehww9ztr59hdw
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 63BEA40003
X-HE-Tag: 1794488216-261048
X-HE-Meta: U2FsdGVkX1/MQMId8fOCCqiQZi03dpGVeFSfFlQq983sWKDZ4UbEVK3wT8lKumAdNUf1o4Z5JCubenrcILX5XOZY+hRSKIma4Vztd6oyZ30SF3rLsSBdFT+Xt0I8t9X4H0ZRM6DEBzgaMro4tx/BGli7elAQoGihrHGVdrdQgh/ccLkDTUYU9hMtUMbQrsxpkqy5B+PpWfYRoMVAdxN4aDF0VPMKYv4qFEHykvV4TG3D/Xw4bAR9X4e3D9x0Bo8ZtkUazFNxX6Ts+e7yXTFCfpGudV/K9NCDtO6RL+Pm/RNohb3JzdqoBrGePW+iNsweayTeHs4g8kb6fLQbIkeaTvuYXH6beZrFGvhjNdxE5FtNjRg+mSXQah1N7atnJ4xZzXg0mtPgTtt7z9eBVvewB9/fqm0YJBeuzP6p9b1lPhzPt4AB1ug8OAlEhEWnnO9PWav78EbqWvs61S+gjJsuF1E/dKlQoXZ/J27fmJ37ge9cRrvuis8xYuEdD8WxwzXKtkG9PXltWRNR6JQomnpeLFfKaMSKIc/+FnwWcyqqvj5PcsNMRx+Es7I0/5w8lygT834XqdsEahMXhmT8u5ufDiJYEPB91y9aU7M3R8orXo62NXh7Jw+TUXoia5JJ7bvK4ROUY8E57TxuBQ0xurg0pJ1QYkyFV2zUGkI2RmwFm5TYqYzFyRZe9gUKLhgiayERyzToY2BtIhr/y8weAmpXpa9y55MMbyGLGHTefsAMPIDCpNxgtw25PEsastWioFGbDm80QLnqSvfigNZPKXEZNQwXoKrn41rSDIp/bHMnLnhdYHn4kKHN0hUQwhJ4Jj5XeQCaQ0TbPiUsu8QyDFcgNIOZYc8Yj7Et34R1LDZxDbpdD0Ii3b+czZiBjM+nkuhoE2uy76eCdBK+vSma1lifWe5voQ/XoTgbU/ngfZ/val+u2XLmnvNAUuc4K6sD0fD7qZgE4C56MXPNv2QblCi
 7fdUTew2
 QuqFUWj/BaWyj27AVc8AtbXiw1Vtjx8jW3fpbJqvrtp6+/2KGA7SCUhfLC2QK4gaQaFm1YZz7iIDukUiz6IndhMleUX61Nj7STrep4tVaKh7mmhLdCzer3D0RHTkGR+oxZnmbrDSVJBK3qPAnBHvwmRj/iv1Qa7kNZxFOr/QwqymMvaxfZMvYWYoXqP0MEkfgAXTiWfKagd7z5faqDL1v6L0Ynju5DnO3YhgKwKtXGWofBCBP2szOU0rp5Vm1/wLvUkv26T6dBFaXMQDxcoK3LtzWLfcjpbgIxlTwT+mRyAc4Hckb88wEIPRREsgqZtCppT6T1s9pv1AIxP2Os4oNhl7sk7IYMKzmB90MsmWI/vNbm0JMkWYsne+BsfxC90vWtiLW1xqbm2pJjSNv1756dLkQrwPNehlhIOszURZZq2jXcJnpZ+Q2wEQoZ6BrorE3P/R/lA9YmbXEq1DyLycTyZ9lUjmKjAo0RKKEFBmlf1zB92g36y1FdQ/buGe+TT9Wni/1bYHVUJeDAFpYXSU1+oMbLOz+liwTSuAGgfAjTv//XH9mok3+1AIqCPQTPvm/HfQ2S3LHx7IrjsXZmjrfCHtwnWc9bIaEY65PzEeLubGHAn57oVkdhh0MPQMbn3vrVxMjF+zCl80qm/4Zlyp5ad9Z09sbdPgosQ3seRt8WMUyC+McxyufB4L/4S26qhAPkhjmYcMkv5dOVEXcOBsw5RSQQPiH46HvqMbt79BYJnqxTlYG9gzsIrE27A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

->fault/->huge_fault handlers of VM_PFNMAP mappings that want huge PFN
mappings open-code the same steps: check that the order-aligned fault
window lies within the VMA and that the pfn is aligned to the order,
then call vmf_insert_pfn(), vmf_insert_pfn_pmd() or vmf_insert_pfn_pud()
depending on the order, guarded by
CONFIG_ARCH_SUPPORTS_{PMD,PUD}_PFNMAP, and fall back to a smaller order
otherwise. vfio-pci has its own is_aligned_for_order() and
vfio_pci_vmf_insert_pfn() for this.

Add vmf_pfn_order_ok() for the window and alignment check, and
vmf_insert_pfn_order() for the order dispatch. The latter also checks
pfn_modify_allowed() for huge orders: the order-0 vmf_insert_pfn() does
this, but vmf_insert_pfn_pmd() and vmf_insert_pfn_pud() do not. The two
are separate so that a driver can apply its own policy (access checks,
device locking) between them.

vmf_insert_pfn_order() passes the fault's write flag to
vmf_insert_pfn_pmd() and vmf_insert_pfn_pud(), as the DAX and DRM
->huge_fault handlers do. With write=false, insert_pmd() leaves a
read-only entry in place and returns VM_FAULT_NOPAGE, so a store to a
mapping that soft-dirty tracking write-protected faults forever;
wp_huge_pmd() splits the entry only when the handler returns
VM_FAULT_FALLBACK. Passing it marks the entry young, dirty and, where
the VMA allows, writable, as wp_page_reuse() does at PTE level. uffd-wp
cannot apply here: vma_can_userfault() rejects a VM_PFNMAP vma at its
mm-backed test.

The order-0 path takes the flag too, so the helper does not behave
differently at different orders. A CPU store does not need it: the
order-0 fault installs a read-only entry and the store faults again,
where do_wp_page() -> wp_pfn_shared() upgrades it. A caller that faults
a page in without retrying the access, fixup_user_fault() from an
->access handler, gets no second fault, and generic_access_phys() takes
its writability from pte_write(); I have not been able to observe that
combination failing on /dev/mem or on either UIO memtype, so this is
consistency rather than a fix for an observed failure. vmf_insert_pfn()
cannot pass the flag, so vmf_insert_pfn_prot() keeps its signature and
its body moves to a static helper that takes mkwrite.

The helper also declines the huge zero folio's pfn, which
vmf_insert_pfn_pmd() refuses with SIGBUS, so that the fault is retried
at PTE order where it maps.

They will be used by the /dev/mem and UIO huge_fault handlers added
later in this series.

Signed-off-by: Eliav Farber <farbere@amazon.com>
---
v2:
The order-0 path passes the fault's write flag too, so a caller that does
not retry the access, fixup_user_fault() from an ->access handler, is not
left with a read-only pte. vmf_insert_pfn_prot() keeps its signature; its
body moved into a static __vmf_insert_pfn_prot() taking mkwrite. Dropped
the commit message's claim that uffd-wp can write-protect such a mapping;
it cannot. Reported by sashiko-bot.

 include/linux/mm.h |  28 +++++++++++
 mm/memory.c        | 115 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 119 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c11bdee1596a..57437b317709 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5010,6 +5010,34 @@ vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn);
+vm_fault_t vmf_insert_pfn_order(struct vm_fault *vmf, unsigned long pfn,
+				unsigned int order);
+
+/**
+ * vmf_pfn_order_ok - check that a pfn can be mapped at a given fault order
+ * @vmf: The fault being handled.
+ * @pfn: The pfn to map at the start of the order-aligned fault window.
+ * @order: The fault order (0 for a single page).
+ *
+ * For a huge (order > 0) fault, the order-aligned window around @vmf->address
+ * must lie within the VMA and @pfn must be aligned to @order. @pfn is only
+ * looked at once the window is known to lie within the VMA, so a caller may
+ * compute it before calling, even when the window starts below vm_start.
+ *
+ * Return: true if vmf_insert_pfn_order() may map @pfn at @order, false if the
+ * fault should fall back to a smaller order.
+ */
+static inline bool vmf_pfn_order_ok(const struct vm_fault *vmf,
+				    unsigned long pfn, unsigned int order)
+{
+	const struct vm_area_struct *vma = vmf->vma;
+	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
+
+	return !order || (addr >= vma->vm_start &&
+			  addr + (PAGE_SIZE << order) <= vma->vm_end &&
+			  IS_ALIGNED(pfn, 1UL << order));
+}
+
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index ab29ec719ae1..2e4bb5af22ce 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2912,6 +2912,36 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	return VM_FAULT_NOPAGE;
 }
 
+static vm_fault_t __vmf_insert_pfn_prot(struct vm_area_struct *vma,
+					unsigned long addr, unsigned long pfn,
+					pgprot_t pgprot, bool mkwrite)
+{
+	/*
+	 * Technically, architectures with pte_special can avoid all these
+	 * restrictions (same for remap_pfn_range).  However we would like
+	 * consistency in testing and feature parity among all, so we should
+	 * try to keep these invariants in place for everybody.
+	 */
+	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
+	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
+						(VM_PFNMAP|VM_MIXEDMAP));
+	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
+	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
+
+	if (unlikely(is_zero_pfn(pfn)))
+		return VM_FAULT_SIGBUS;
+
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
+	if (!pfn_modify_allowed(pfn, pgprot))
+		return VM_FAULT_SIGBUS;
+
+	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
+
+	return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
+}
+
 /**
  * vmf_insert_pfn_prot - insert single pfn into user vma with specified pgprot
  * @vma: user vma to map to
@@ -2948,30 +2978,7 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn, pgprot_t pgprot)
 {
-	/*
-	 * Technically, architectures with pte_special can avoid all these
-	 * restrictions (same for remap_pfn_range).  However we would like
-	 * consistency in testing and feature parity among all, so we should
-	 * try to keep these invariants in place for everybody.
-	 */
-	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
-	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
-						(VM_PFNMAP|VM_MIXEDMAP));
-	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
-	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
-
-	if (unlikely(is_zero_pfn(pfn)))
-		return VM_FAULT_SIGBUS;
-
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
-
-	if (!pfn_modify_allowed(pfn, pgprot))
-		return VM_FAULT_SIGBUS;
-
-	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
-
-	return insert_pfn(vma, addr, pfn, pgprot, false);
+	return __vmf_insert_pfn_prot(vma, addr, pfn, pgprot, false);
 }
 EXPORT_SYMBOL(vmf_insert_pfn_prot);
 
@@ -3002,6 +3009,66 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vmf_insert_pfn);
 
+/**
+ * vmf_insert_pfn_order - insert a pfn mapping of a given fault order
+ * @vmf: The fault being handled.
+ * @pfn: The pfn to map at the start of the order-aligned fault window.
+ * @order: The fault order (0 for a single page).
+ *
+ * Helper for ->fault and ->huge_fault handlers of VM_PFNMAP mappings: maps @pfn
+ * with a PTE for order 0, or with a PMD/PUD for PMD_ORDER/PUD_ORDER where the
+ * architecture supports huge PFN mappings. The caller must have checked the
+ * window and the pfn alignment with vmf_pfn_order_ok().
+ *
+ * vma cannot be a COW mapping.
+ *
+ * A write fault is mapped writable where the VMA allows it, so a first write
+ * does not call ->pfn_mkwrite.
+ *
+ * Return: vm_fault_t value; %VM_FAULT_FALLBACK if @order cannot be mapped, so
+ * that the fault is retried at a smaller order.
+ */
+vm_fault_t vmf_insert_pfn_order(struct vm_fault *vmf, unsigned long pfn,
+				unsigned int order)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+
+	/*
+	 * Map a write fault writable at order 0 too, as the PMD and PUD paths
+	 * below do. Otherwise the pte comes from vma->vm_page_prot, which is
+	 * read-only while soft-dirty tracking is armed, and a caller that has
+	 * no second fault to upgrade it - fixup_user_fault() from .access, for
+	 * one - is left with a read-only pte.
+	 */
+	if (!order)
+		return __vmf_insert_pfn_prot(vma, vmf->address, pfn,
+					     vma->vm_page_prot, write);
+
+	/*
+	 * vmf_insert_pfn_pmd() refuses the huge zero folio's pfn with SIGBUS,
+	 * while a PTE mapping of it is fine, so fall back to a smaller order.
+	 */
+	if (is_huge_zero_pfn(pfn))
+		return VM_FAULT_FALLBACK;
+
+	/*
+	 * vmf_insert_pfn_pmd()/_pud() don't call pfn_modify_allowed(), unlike
+	 * the order-0 path, so check it explicitly for the L1TF mitigation.
+	 */
+	if (!pfn_modify_allowed(pfn, vma->vm_page_prot))
+		return VM_FAULT_FALLBACK;
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
+		return vmf_insert_pfn_pmd(vmf, pfn, write);
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PUD_ORDER)
+		return vmf_insert_pfn_pud(vmf, pfn, write);
+
+	return VM_FAULT_FALLBACK;
+}
+EXPORT_SYMBOL_GPL(vmf_insert_pfn_order);
+
 static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
 			bool mkwrite)
 {
-- 
2.47.3


