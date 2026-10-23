Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09ACE606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mpcgfXNM
Received: by kanga.kvack.org (Postfix)
	id 1EDF56B0AAA; Thu, 22 Oct 2026 22:20:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19EA96B0AAC; Thu, 22 Oct 2026 22:20:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F4046B0AAD; Thu, 22 Oct 2026 22:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAA4A6B0AAA
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:20:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D3E8C01C2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:20:52 +0000 (UTC)
X-FDA: 85352287944.15.02C9AC5
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	by imf16.hostedemail.com (Postfix) with ESMTP id 21AA5180005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:20:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mpcgfXNM;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792722050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJj29YZXaCltYYYPax9FC2PzbE2sg7jlrCg6+nh2uVo=;
	b=vOYqeCthJ4Iy5UyCQNZ7alKbJhchgDJeQ5ycrdYRSqIDOZHoztk8Hdee2hmOFYpvHbdw0W
	Jlh/tr5KfRTGtXf6kKpz99Gh132zgjaZBQN7rR3GpXYNOAFndHO38Wc1UiWAnRBsGiU+zW
	rhPHQIn3uwtRYZ97GhR3dnG1xbFtfYs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mpcgfXNM;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792722050;
	b=8gXbVtToYlOLTdiBlspcyAOJ2x0HR958ogumQa/NMdgR2QIAzGCGhSU3heQVpU/n0vif33
	u6IBUHypyHVKr2BDD+3SYij3X8uLQV7PREVMfmC8i8bCKz6CYQxhrbpQPRCrlquGE13bbp
	TgJT3+umEf/btuZ6jRpf6gtKxXDRngw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KJhxT0fyggms2ovfhLdLIeLX39g35Kvjs17mmy9bPQA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792722044; v=1; x=1793326844;
 b=mpcgfXNMu0x+jvYFUegMNisiZHTA7U5VJQuxsqJx9DxvrDC9rWnOsMF8jVDAcEzWRqHQInmY
 ILVFEGtQ1rWT+0pK8FKnq2ga7gW3XJcRLITdMPN4aoTbz7TwHAid4Fu1v5E9006fe0wItbUAuW0
 QctmqteRJeFY8uqr7yKYrMyo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 559e8641fd3a77b7;
	Fri, 23 Oct 2026 02:20:33 +0000
X-Mizu-Trace-ID: 559e8641fd3a77b7
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/12] mm: hugetlb_vmemmap: simplify shared tail page handling
Date: Fri, 23 Oct 2026 10:20:27 +0800
Message-ID: <20261023022027.25898-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115824.823278-6-songmuchun@bytedance.com>
References: <20261020115824.823278-6-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 21AA5180005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fw9ecjqd5cbzhnd44e9jpp587p49r9gh
X-HE-Tag: 1792722049-302975
X-HE-Meta: U2FsdGVkX1+7weLD/yD+33pl+CJkkmm82akPVJVmvNAz1zcE+i9z2ufVhMUL5X9Md4PpJboaAY6yC8QoeSgI+mliOYxa6cWPA/nfQD1XUlkt/LSk2XbuUBj8sGzcjki+harq3uVOfmQF/vd2c71JucK+MNJr/2HXf5udkEXogM8Qx+Y+5ebo3i92jRy/HFhA2UfCKgB4BXAL5AXGjM0vMYY562wLzZv4FI7X3wl1D/SxMRFT3xfZO42aLeGvEuFDVynugptTU4j/GPGM99SYE9WWrvXerk7YHIOG8IcoiGNUmRQgjsHaMOnnh2T8LwnQcQObxV+TfUOGOK7/N6K62NMZvp2fDzex3+fVJE+ohMgA+gpPa68xd7o0jPn/H0riBCL+7S5SLEJgMXkVrkZ2JeA5VS0Cnrvix6z29p+X33iaQ9fvNuk+Fm0mRtSWLbmRkOmF0bhuodnAcDsO14SEwLmQEVYFeuPSH9SkOThNKiy54WZzdAjfkv4xpOrUDW/lVhapzlQIyElzYwWa+py7BT5xoR1ugGdFQjFnhnJfP8hgVeOeVpvZ1LnsnONGCXBDR4CpOr3pLJ4qM650jxsLRxn1UCstOEhdUXSxASqlKPaaPhvBMmz9gM/U963jxri4UnCxfnWPavDom033unQy/yTXUC1eO2ElmzYK10IjPc8dLjaYjQcAURQg765M7QLxzhRHH6JvW4lcrUL6tYzwmhTulNTM57SNlKWcyLAJDXILtkuUUaluEyCV4IDFr1OtoY2X/NuQbSZjcHCedtAURdRBG9SGCo7wQkypoIBWNU3MpJyNcCMG/ki+KCSCJXI7WU9cj45hWMnRUhui+Io7lxLlyN8E7kuwFtNRcxM2F90C2wJ3Er3DSMxMcY2sBHlR+KfdjqlYlmfHas0trVwz+eWDRTQkOEPx2E8dTryLIjb3mouM/dhlKmjASSINecCfEAgBW5KOuLtVJyASMmH
 4uaK5PQw
 Y5t4S0UcCSal7IhTjrrkM8V+rTBjPPXp2or2ItjygqE8SXb5x7PX59Bt2ltwMVNS6xvxQQQwKCTdcCeMup+f0b/kR/vU65/q75lTjaqAfaqOh90msVWXVKuyxgOhuVoT9fXIEK7xpDjc54jsD+EWlFZ+Miu/P+FfGwKugcie60z9u77Ay0Vbr9pvsA3j9oSwZ43gkmGdgSXK4vc3nPpzr9GdPsev30vXBIMWqunMhUVXWe0Xxjkuoziyh3JMonhLy0ILPQYAfEit9sr+v1lyeAbHz4lBACbtScfNaGc+HS1VOkqySkklv1Eqd/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:58:19PM +0800, Muchun Song wrote:
>The remap walker currently carries a shared tail page selected by its
>caller, even though the optimize and restore callbacks can derive the
>same information from the folio being processed.  This adds redundant
>state to the walker and couples its interface to caller-side preparation.
>
>Derive the shared mapping state in the callbacks instead, keeping the
>mapping policy with the PTE being processed and simplifying the remap
>interface.
>
>No functional change intended.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---
> include/linux/vmemmap-optimization.h |  6 +-
> mm/hugetlb_vmemmap.c                 | 89 ++++++++++++----------------
> mm/mm_init.c                         |  6 +-
> mm/sparse-vmemmap.c                  |  5 +-
> 4 files changed, 49 insertions(+), 57 deletions(-)
>
>diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
>index 065840f3c241..858311a71b0c 100644
>--- a/include/linux/vmemmap-optimization.h
>+++ b/include/linux/vmemmap-optimization.h
>@@ -91,11 +91,13 @@ static inline struct page *vmemmap_shared_tail_page(unsigned int order,
> }
> #endif /* CONFIG_VMEMMAP_OPTIMIZATION */
> 
>-static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
>+static inline bool vmemmap_optimizable_pfn(unsigned long pfn, unsigned int order)
> {
>-	const unsigned int order = pfn_to_section_compound_order(pfn);
> 	const unsigned long nr_pages = 1UL << order;
> 
>+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
>+		return false;
>+
> 	if (!is_power_of_2(sizeof(struct page)))
> 		return false;
> 
>diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>index 18b72d553955..8fac61b7d74a 100644
>--- a/mm/hugetlb_vmemmap.c
>+++ b/mm/hugetlb_vmemmap.c
>@@ -24,22 +24,18 @@
>  * struct vmemmap_remap_walk - walk vmemmap page table
>  *
>  * @remap_pte:		called for each lowest-level entry (PTE).
>- * @nr_walked:		the number of walked pte.
>- * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
>+ * @nr_walked:		the number of PTEs successfully remapped.
>  * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
>  *			or is mapped from.
>  * @flags:		used to modify behavior in vmemmap page table walking
>  *			operations.
>  */
> struct vmemmap_remap_walk {
>-	void			(*remap_pte)(pte_t *pte, unsigned long addr,
>+	int			(*remap_pte)(pte_t *pte, unsigned long addr,
> 					     struct vmemmap_remap_walk *walk);
>-
> 	unsigned long		nr_walked;
>-	struct page		*vmemmap_tail;
> 	struct list_head	*vmemmap_pages;
> 
>-
> /* Skip the TLB flush while updating the vmemmap page tables. */
> #define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(0)
> 	unsigned long		flags;
>@@ -140,12 +136,14 @@ static int vmemmap_pmd_entry(pmd_t *pmd, unsigned long addr,
> static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
> 			     unsigned long next, struct mm_walk *walk)
> {
>+	int ret;
> 	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
> 
>-	vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
>-	vmemmap_walk->nr_walked++;
>+	ret = vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
>+	if (!ret)
>+		vmemmap_walk->nr_walked++;
> 
>-	return 0;
>+	return ret;
> }
> 
> static const struct mm_walk_ops vmemmap_remap_ops = {
>@@ -213,51 +211,51 @@ static struct page *vmemmap_dup_page_from_list(const struct page *src,
> 	return dst;
> }
> 
>-static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
>-				 struct vmemmap_remap_walk *walk)
>+static inline struct page *folio_vmemmap_shared_tail_page(const struct folio *folio)
> {
>-	struct page *page = pte_page(ptep_get(pte));
>-	pte_t entry;
>-
>-	/* Remapping the head page requires r/w */
>-	if (unlikely(walk->nr_walked == 0)) {
>-		struct page *head;
>+	return vmemmap_shared_tail_page(folio_order(folio), folio_zone(folio));
>+}
> 
>-		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
>+static int vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
>+				struct vmemmap_remap_walk *walk)
>+{
>+	pte_t entry;
>+	struct page *src = pte_page(ptep_get(pte)), *dst;
>+	const struct page *page = (const struct page *)addr;
>+	const struct folio *folio = page_folio(page);
> 
>-		head = vmemmap_dup_page_from_list(page, walk->vmemmap_pages);
>-		entry = mk_pte(head, PAGE_KERNEL);
>+	if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio)))) {
>+		dst = folio_vmemmap_shared_tail_page(folio);
>+		if (!dst)
>+			return -ENOMEM;

One thing caught my eye here ... shared tail allocation can now fail after
we've already remapped the head.

IIUC, nothing to worry about there, though :) since rollback keeps the
new head mapped and flushes before clearing the optimized flag or freeing
the old backing page.

[...]

Reviewed-by: Lance Yang <lance.yang@linux.dev>

