Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A24B7F41807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41696B008C; Mon,  9 Mar 2026 11:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02666B0092; Mon,  9 Mar 2026 11:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFAFA6B0093; Mon,  9 Mar 2026 11:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFBE06B008C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:19:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76016B6FE1
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:19:29 +0000 (UTC)
X-FDA: 84526883658.26.7E1D441
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B243640010
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:19:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIzLDFSz;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773069567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TSEUSGyzIrSnUfG1DVi5eGrw9YR0I+2760zFGy4g+Y=;
	b=ubJWJN0vW4zmc2fSxiQzqEfjr2qfkLD35xp9/xlxoSZMRe1yIwiud3ziSOGwZIurssQGC7
	/DF8hFL6KDa4y0FQgq3OQe6h5nspsZRh0UHJWhdlXdXUzfsMVKLaVh7sgRdcb26yjnBTTz
	oOKjlDKpYYIv0nV+eRFozhgs+4yyzpg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIzLDFSz;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773069567; a=rsa-sha256;
	cv=none;
	b=JXI+ausYYsRuuOS9xVrqaIniwpTuwgmTqgFsatvpo3GH0w5uMCxe6jPVBwbUK2NJLGc1Fv
	dFVvOEZN4c64ok5TXwL7HtsnV8ReeRzk6ZjcSNQYhh9hzNLRAQYetdLkeQxosmWMH3oLNp
	T1v3/P9DjBMAwAWPP/eIhHVHd1KcOwU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0F1F43A8D;
	Mon,  9 Mar 2026 15:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B98AC4CEF7;
	Mon,  9 Mar 2026 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773069566;
	bh=Mhr7tHNnk4w6+iI/utOSEhEAAttuf6c8xcPh/66ACkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIzLDFSzRjakKohtre+2VeVYCY78KNKV3+vsvOm4E91ML/9l4r5EZZ+H73I/hKO3F
	 +ymncYI/de8NbufE4brWEUyrTiWHk5hR4K/ODmDyvuR8uVZXpCDVCky0p3O0yIIj/V
	 5/S/nWoXlmvP+gF3GyW18r8iURaGdQ7QSgf7rHclKZkN+mavll8dKHMfh11QOJA8qF
	 pn777/LRL7Y0CRCImdIB7ue6zCaTupvWYrAu67gKmPH76E13Cg6AbI7tb59lhTh8Rx
	 0Y9XxMlJvjbf32TuaMTLmyoKbJKfWIHiR7E9KZqnbICSP+ItP6CoXrazRZ5L2DRS/Z
	 auQaLD4Xrx4vg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 2/4] mm: move vma_mmu_pagesize() from hugetlb to vma.c
Date: Mon,  9 Mar 2026 16:18:59 +0100
Message-ID: <20260309151901.123947-3-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309151901.123947-1-david@kernel.org>
References: <20260309151901.123947-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B243640010
X-Stat-Signature: 7g67tdmguofg7w4ncu5ftc6udwyswq8r
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773069567-908886
X-HE-Meta: U2FsdGVkX1/N6flCWHteOP8yVDrxuFlMdvR5zhLBkLmVUcLbY2V9zfbB1AXyhu7MJbS9a17/6JGYZu1VWB7ikefIsXor47Rcf1GZ/3P34s05J+YxdO0TcQJtPUwTvhotgSE7tokIVXHmkq4IGHFzVC0MZitFAw8wtSOE7TJQdabq5m0g0MKLp2gCbG6RuS2fF6Gf79avS7mC2UKVIqWJGW+diGUCEXyjSE4DEoeLbLYfX4LnG24IioFZ312gDGTL4k/STSAkpE5CD0VOLAg4bx5hjFQdNQHNeDVuRTNyT9w+fxZDh+ccFN9TScJyaUR4HAHH7mUr3ih+NwkAWIYUeZQIPC0Q6AmuD4mV47wIVdqMcg22pv1FYEe6/fs7bHt+GNoZ7B1YOW7JS2TtYOHsZbHMF1cdWbKDid9gFohDQXdic9HwoZ2LSP+h4oYSMs/4gGd+/HKB4rdC1Kp4DRfe/sWOLgC6+PfpKjNLN0mW9mPHDfJ3uWVyYwsgagI9mGfjzI0f3EqyShzo1Qy6opIApDqy37Oh9TRLm7U1NDmETaW/iHcIpGPFaN2bYM+ufzSrSmidHRVxj+inlmtRoB8125my0l2g04BMx34mtECorG5rlzpvPd/uQz9OGkO2liaWl1QLF1po6mb0Acibt0xcOg8diMqABTbXl2QXJCo/x39g0LTOPRYf06C//Z5PmHmI3y6kc7hJskKeF7i+siIPX8DjoYfqzgQ2OENob5Bt4wJjzrTb+nbVjn4ChkGqOd4bOSKi5ZKoMs2Ws0Yk5ssKw4vGHhump0k8T9rV42K77HDnvwNMe3bQV9vUX7FGvA25hE2u35gU7bujsR6EVs1fggS5otEnaZ1OHheAEf1oHHDgXl+5oHiKRVHDjYhCakJU2ds5MzRUWnnSXV7ge/Mm7RAkUMmnVgJ+iVauCBBE0NeEmCMFrZSPFXqNOOfOwnlsTiWygFoA+X2mu81MRys
 fdv/lfXg
 VidL/kIlQxIuwe/XuCF3nGH7HUbZ+lyVbsWaGh61CZBRH6xeOkAEKsVOuiHMXwC96vCgSnMNOOsVskciiZjYDBW7MGuzyAnGP6WKjRDTwu4+0MrZ6q2qoVC04CNz+cvHvVON0zmf7/A1dvaYqGJRxiOzU8UCsg7cQe+fnmXcsntXPVtjH1k9E4wf9ZKO63njfURZxWqlTdm1XDGASM2OOrcjYGS+tVb5D/D8dliSNUqeVXvnXHpHJ/wv/y0zxGeh0tPY7O+7XVTapSX+ucGSwugTIlWZlSGUJyvn48PGS/2blTfykWn00jGxMGcQhjyagM+dp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_mmu_pagesize() is also queried on non-hugetlb VMAs and does not
really belong into hugetlb.c.

PPC64 provides a custom overwrite with CONFIG_HUGETLB_PAGE, see
arch/powerpc/mm/book3s64/slice.c, so we cannot easily make this a
static inline function.

So let's move it to vma.c and add some proper kerneldoc.

To make vma tests happy, add a simple vma_kernel_pagesize() stub in
tools/testing/vma/include/custom.h.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h            |  7 -------
 include/linux/mm.h                 |  2 ++
 mm/hugetlb.c                       | 11 -----------
 mm/vma.c                           | 21 +++++++++++++++++++++
 tools/testing/vma/include/custom.h |  5 +++++
 5 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 44c1848a2c21..aaf3d472e6b5 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -777,8 +777,6 @@ static inline unsigned long huge_page_size(const struct hstate *h)
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
-extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
-
 static inline unsigned long huge_page_mask(struct hstate *h)
 {
 	return h->mask;
@@ -1175,11 +1173,6 @@ static inline unsigned long huge_page_mask(struct hstate *h)
 	return PAGE_MASK;
 }
 
-static inline unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
-{
-	return PAGE_SIZE;
-}
-
 static inline unsigned int huge_page_order(struct hstate *h)
 {
 	return 0;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 227809790f1a..22d338933c84 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1327,6 +1327,8 @@ static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 	return PAGE_SIZE;
 }
 
+unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 66eadfa9e958..f6ecca9aae01 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1017,17 +1017,6 @@ static pgoff_t vma_hugecache_offset(struct hstate *h,
 			(vma->vm_pgoff >> huge_page_order(h));
 }
 
-/*
- * Return the page size being used by the MMU to back a VMA. In the majority
- * of cases, the page size used by the kernel matches the MMU size. On
- * architectures where it differs, an architecture-specific 'strong'
- * version of this symbol is required.
- */
-__weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
-{
-	return vma_kernel_pagesize(vma);
-}
-
 /*
  * Flags for MAP_PRIVATE reservations.  These are stored in the bottom
  * bits of the reservation map pointer, which are always clear due to
diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..e95fd5a5fe5c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3300,3 +3300,24 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 
 	return 0;
 }
+
+/**
+ * vma_mmu_pagesize - Default MMU page size granularity for this VMA.
+ * @vma: The user mapping.
+ *
+ * In the common case, the default page size used by the MMU matches the
+ * default page size used by the kernel (see vma_kernel_pagesize()). On
+ * architectures where it differs, an architecture-specific 'strong' version
+ * of this symbol is required.
+ *
+ * The default MMU page size is not affected by Transparent Huge Pages
+ * being in effect, or any usage of larger MMU page sizes (either through
+ * architectural huge-page mappings or other explicit/implicit coalescing of
+ * virtual ranges performed by the MMU).
+ *
+ * Return: The default MMU page size granularity for this VMA.
+ */
+__weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
+{
+	return vma_kernel_pagesize(vma);
+}
diff --git a/tools/testing/vma/include/custom.h b/tools/testing/vma/include/custom.h
index 802a76317245..4305a5b6e433 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -117,3 +117,8 @@ static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits)
 			vma_flag_set(&flags, bits[i]);
 	return flags;
 }
+
+static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
+{
+	return PAGE_SIZE;
+}
-- 
2.43.0


