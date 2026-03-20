Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B44391099B4D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241DD6B00D0; Fri, 20 Mar 2026 18:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A036B013C; Fri, 20 Mar 2026 18:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109066B013D; Fri, 20 Mar 2026 18:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC01C6B00D0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:41:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9266B8D35
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:41:04 +0000 (UTC)
X-FDA: 84567913248.14.B6381B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 26CDA1C0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:41:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LB/UaFWL";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvxMUqRvY495nN+ECfres7BDibkDXVFqzs62X+6nXow=;
	b=snNnZRkR8Nw4WWsAXsiHV0Hwu1rbASU37is6OYlb1LttKwNjIrhkxunLyZqEcFsWE8iypv
	7SYKIcxkys1s1X4j7nSwyc2m2ebWtB9OpgjYq6VO+ICdPR2OmngrBf+5NXdKQI214rC6Ek
	gjKhMdjU0Bd7qlm/Ld/oBR/sWRvl3xE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046463; a=rsa-sha256;
	cv=none;
	b=dH2u/RzY8hjXcE86XjbUIsT7KsHPXurQnYRedG+37FD5WrRDeveU10e3+OzMiKNnygH4/t
	5SA20lQh1AkFZN48S9CCIBR0amw70vc5R68hqt6H2w16tjBDMJ4jftGY8KOyfGwDcEhZHy
	z3064FivQIz+0BaKU8TrWuOofzOaXD0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LB/UaFWL";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DBC860154;
	Fri, 20 Mar 2026 22:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFDFC2BCB1;
	Fri, 20 Mar 2026 22:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046462;
	bh=PC8UT5FrOE7raPDJyXK5xkA7GADphHu1Lkj1dxP3k+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LB/UaFWL0AckuWEpPx7qUcJo2w+95GJiPatq+AYNCm6c8XPlZnnCIZJXl1wxJFezK
	 3zxcUT7cyOGO99x76SslEh2hUby34dCvo8MvuZWkr5lcIJ3v/5wVebGpGDDRKm7o7X
	 kPRmOCx1iZ70VUf6k3bHoideWAt8MWrhaAi4MHAeF4s8dUupO6LPLC7/3pdRRcmMBw
	 y0xIz1koeyTRyvVzEhda9hxPIet5JrGAN+B87pO/xCRFsFwMX5rkzJA9jAX8Tc+m1q
	 8/DTtyvunjD3f5i+k8Y9xDzFlwwFJKw3EcUHLvXdfjsYFA4H2o66RqUp08jopTGG2k
	 wBawkzh53K7Dg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v4 20/21] mm: add mmap_action_map_kernel_pages[_full]()
Date: Fri, 20 Mar 2026 22:39:46 +0000
Message-ID: <926ac961690d856e67ec847bee2370ab3c6b9046.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: uoyf7zuy5d3dhn9txtfzio86uy3k1dwz
X-Rspamd-Queue-Id: 26CDA1C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1774046463-373639
X-HE-Meta: U2FsdGVkX1/VKumxWp5OlMUq6oPBFR4qc4fwo6t5rZneOGRVd2ve7UlWgbiDja91SdbhLyzLupbTmcogC/IMQzByAkf0WPan8CkwjMybnrBVgpSourYchAE/Xade5QtRQ9r1+2gdbV78HfQ4V5oneC73dkZvT4XhQlzWGkk6+QIz2xFCapwBzHyxK29ocenc45Vp3XliWgNaDGGrUH9BMnvwsOpfvu1+f25H7bS4Mtk9p0lxPN2QiYOG0sXQDu91+w3RbQUOPpvm5opiD4VK915CCFTnnzvBLcqyIZqOd76x0o4S+htjWo0OPqd5xMUL8G7/CdGy/Bqv7t4ngegEC5SzHqTMLA69Wt12rP6Ue3Ohn98fH0pI2J0UujSaNVX2P4Ac2hhUPLAsiSfNWyLGv9Nb/sEb5nHLip386zeCRSv4mHIP498rkJQbfMXi3ia8tv8bAcKuUYqpE814od1fwhXUN/0ilVjsADtBagr8WIBm2LItcj4nXzYT4AYIwOm3GrDlMDyTl3+wcH54Krf3lY/GKXHFMtiGi03rkxOljykAFfLMHYnQnZVGD2egKZcvEDl4WZmyaRHZepmNrvIFfkzOGdMFAkdXARlDwbLbxaUatgiMVKz5OP4db5D0Zx1/k5HtvWmu5Se82aOE+kT87CX7wjJr8X08KXfu6MsXNjIewdG8P3po1ZF+j4hOjt4um0YLzxz3bPd5NMV569Vn2sYCu3hDcVxqS6NNjgkK7fLl8C+QWJHzNu5hCGe6ErTvlizwjuYaqfPseeIGCsZwaez8vrDouWIKdugnMa/RzKfbzUV+AESDcMcplObBtTkAVI5PFe/OLfh5niVcLQiE5ejRJgVNcdd4cnvxRdtPtYN8IoWKZT4ieIcdqDXUoZ9ggq+us1YDg4Gwm4x/srnJXy8SwuppKUkYhgmtES3rBie+/+Rgl+OlikaE7p/pXlXZMjIcQ0LNsKyKSwB8vmi
 5bc9pw2b
 x+lQx5BVJZCjZq92GIBkCmsQBshjzKQbM6dckbL6VhWFHNtR1HygvElaxd/DPqQlzO6E0TXZsZduAHt3ZYKS0hB6xpc9PJaFo2pLZPk2UfUAQS5tRE05Doo/G9sJySXXZZ6eL5OoOl0JVjs1rkamq6ZWdD7yXJ9CbVgD8Mo0oirqQmcocEhNhBNPRfjZ13Xvh6o/traIJE6MxRmHyd4GWxSjJc+sij53QoqN7Lc9zNAVzS5kdR6n4Qk614LTG4upuWlPb5prBKYx9rG5GImkQgvbxt+/Zi7AulPUAJbKwqCt6KtEBOjuW/Z3Bo1ZQkPTuHXFwK/guEdDwSuluEsm0mqvNo1aZhBwuc2cSLWhAdXysZ9UIlUa+wtwcIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A user can invoke mmap_action_map_kernel_pages() to specify that the
mapping should map kernel pages starting from desc->start of a specified
number of pages specified in an array.

In order to implement this, adjust mmap_action_prepare() to be able to
return an error code, as it makes sense to assert that the specified
parameters are valid as quickly as possible as well as updating the VMA
flags to include VMA_MIXEDMAP_BIT as necessary.

This provides an mmap_prepare equivalent of vm_insert_pages().  We
additionally update the existing vm_insert_pages() code to use
range_in_vma() and add a new range_in_vma_desc() helper function for the
mmap_prepare case, sharing the code between the two in range_is_subset().

We add both mmap_action_map_kernel_pages() and
mmap_action_map_kernel_pages_full() to allow for both partial and full VMA
mappings.

We update the documentation to reflect the new features.

Finally, we update the VMA tests accordingly to reflect the changes.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 Documentation/filesystems/mmap_prepare.rst |  8 ++
 include/linux/mm.h                         | 95 +++++++++++++++++++++-
 include/linux/mm_types.h                   |  7 ++
 mm/memory.c                                | 42 +++++++++-
 mm/util.c                                  |  7 ++
 tools/testing/vma/include/dup.h            |  7 ++
 6 files changed, 160 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
index 14bb057be564..82c99c95ad85 100644
--- a/Documentation/filesystems/mmap_prepare.rst
+++ b/Documentation/filesystems/mmap_prepare.rst
@@ -156,5 +156,13 @@ pointer. These are:
 * mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
   physical address and over a specified length.
 
+* mmap_action_map_kernel_pages() - Maps a specified array of `struct page`
+  pointers in the VMA from a specific offset.
+
+* mmap_action_map_kernel_pages_full() - Maps a specified array of `struct
+  page` pointers over the entire VMA. The caller must ensure there are
+  sufficient entries in the page array to cover the entire range of the
+  described VMA.
+
 **NOTE:** The ``action`` field should never normally be manipulated directly,
 rather you ought to use one of these helpers.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index df8fa6e6402b..6f0a3edb24e1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2912,7 +2912,7 @@ static inline bool folio_maybe_mapped_shared(struct folio *folio)
  * The caller must add any reference (e.g., from folio_try_get()) it might be
  * holding itself to the result.
  *
- * Returns the expected folio refcount.
+ * Returns: the expected folio refcount.
  */
 static inline int folio_expected_ref_count(const struct folio *folio)
 {
@@ -4364,6 +4364,45 @@ static inline void mmap_action_simple_ioremap(struct vm_area_desc *desc,
 	action->type = MMAP_SIMPLE_IO_REMAP;
 }
 
+/**
+ * mmap_action_map_kernel_pages - helper for mmap_prepare hook to specify that
+ * @num kernel pages contained in the @pages array should be mapped to userland
+ * starting at virtual address @start.
+ * @desc: The VMA descriptor for the VMA requiring kernel pags to be mapped.
+ * @start: The virtual address from which to map them.
+ * @pages: An array of struct page pointers describing the memory to map.
+ * @nr_pages: The number of entries in the @pages aray.
+ */
+static inline void mmap_action_map_kernel_pages(struct vm_area_desc *desc,
+		unsigned long start, struct page **pages,
+		unsigned long nr_pages)
+{
+	struct mmap_action *action = &desc->action;
+
+	action->type = MMAP_MAP_KERNEL_PAGES;
+	action->map_kernel.start = start;
+	action->map_kernel.pages = pages;
+	action->map_kernel.nr_pages = nr_pages;
+	action->map_kernel.pgoff = desc->pgoff;
+}
+
+/**
+ * mmap_action_map_kernel_pages_full - helper for mmap_prepare hook to specify that
+ * kernel pages contained in the @pages array should be mapped to userland
+ * from @desc->start to @desc->end.
+ * @desc: The VMA descriptor for the VMA requiring kernel pags to be mapped.
+ * @pages: An array of struct page pointers describing the memory to map.
+ *
+ * The caller must ensure that @pages contains sufficient entries to cover the
+ * entire range described by @desc.
+ */
+static inline void mmap_action_map_kernel_pages_full(struct vm_area_desc *desc,
+		struct page **pages)
+{
+	mmap_action_map_kernel_pages(desc, desc->start, pages,
+				     vma_desc_pages(desc));
+}
+
 int mmap_action_prepare(struct vm_area_desc *desc);
 int mmap_action_complete(struct vm_area_struct *vma,
 			 struct mmap_action *action);
@@ -4380,10 +4419,59 @@ static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 	return vma;
 }
 
+/**
+ * range_is_subset - Is the specified inner range a subset of the outer range?
+ * @outer_start: The start of the outer range.
+ * @outer_end: The exclusive end of the outer range.
+ * @inner_start: The start of the inner range.
+ * @inner_end: The exclusive end of the inner range.
+ *
+ * Returns: %true if [inner_start, inner_end) is a subset of [outer_start,
+ * outer_end), otherwise %false.
+ */
+static inline bool range_is_subset(unsigned long outer_start,
+				   unsigned long outer_end,
+				   unsigned long inner_start,
+				   unsigned long inner_end)
+{
+	return outer_start <= inner_start && inner_end <= outer_end;
+}
+
+/**
+ * range_in_vma - is the specified [@start, @end) range a subset of the VMA?
+ * @vma: The VMA against which we want to check [@start, @end).
+ * @start: The start of the range we wish to check.
+ * @end: The exclusive end of the range we wish to check.
+ *
+ * Returns: %true if [@start, @end) is a subset of [@vma->vm_start,
+ * @vma->vm_end), %false otherwise.
+ */
 static inline bool range_in_vma(const struct vm_area_struct *vma,
 				unsigned long start, unsigned long end)
 {
-	return (vma && vma->vm_start <= start && end <= vma->vm_end);
+	if (!vma)
+		return false;
+
+	return range_is_subset(vma->vm_start, vma->vm_end, start, end);
+}
+
+/**
+ * range_in_vma_desc - is the specified [@start, @end) range a subset of the VMA
+ * described by @desc, a VMA descriptor?
+ * @desc: The VMA descriptor against which we want to check [@start, @end).
+ * @start: The start of the range we wish to check.
+ * @end: The exclusive end of the range we wish to check.
+ *
+ * Returns: %true if [@start, @end) is a subset of [@desc->start, @desc->end),
+ * %false otherwise.
+ */
+static inline bool range_in_vma_desc(const struct vm_area_desc *desc,
+				     unsigned long start, unsigned long end)
+{
+	if (!desc)
+		return false;
+
+	return range_is_subset(desc->start, desc->end, start, end);
 }
 
 #ifdef CONFIG_MMU
@@ -4427,6 +4515,9 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num);
+int map_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_complete(struct vm_area_struct *vma,
+			      struct mmap_action *action);
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d60eefde1db8..f9face579072 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -815,6 +815,7 @@ enum mmap_action_type {
 	MMAP_REMAP_PFN,		/* Remap PFN range. */
 	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
+	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*
@@ -833,6 +834,12 @@ struct mmap_action {
 			phys_addr_t start_phys_addr;
 			unsigned long size;
 		} simple_ioremap;
+		struct {
+			unsigned long start;
+			struct page **pages;
+			unsigned long nr_pages;
+			pgoff_t pgoff;
+		} map_kernel;
 	};
 	enum mmap_action_type type;
 
diff --git a/mm/memory.c b/mm/memory.c
index b3bcc21af20a..53ef8ef3d04a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2484,13 +2484,14 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num)
 {
-	const unsigned long end_addr = addr + (*num * PAGE_SIZE) - 1;
+	const unsigned long nr_pages = *num;
+	const unsigned long end = addr + PAGE_SIZE * nr_pages;
 
-	if (addr < vma->vm_start || end_addr >= vma->vm_end)
+	if (!range_in_vma(vma, addr, end))
 		return -EFAULT;
 	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		BUG_ON(mmap_read_trylock(vma->vm_mm));
-		BUG_ON(vma->vm_flags & VM_PFNMAP);
+		VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
+		VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
 		vm_flags_set(vma, VM_MIXEDMAP);
 	}
 	/* Defer page refcount checking till we're about to map that page. */
@@ -2498,6 +2499,39 @@ int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_pages);
 
+int map_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	const struct mmap_action *action = &desc->action;
+	const unsigned long addr = action->map_kernel.start;
+	unsigned long nr_pages, end;
+
+	if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
+		VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
+		VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
+		vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
+	}
+
+	nr_pages = action->map_kernel.nr_pages;
+	end = addr + PAGE_SIZE * nr_pages;
+	if (!range_in_vma_desc(desc, addr, end))
+		return -EFAULT;
+
+	return 0;
+}
+EXPORT_SYMBOL(map_kernel_pages_prepare);
+
+int map_kernel_pages_complete(struct vm_area_struct *vma,
+			      struct mmap_action *action)
+{
+	unsigned long nr_pages;
+
+	nr_pages = action->map_kernel.nr_pages;
+	return insert_pages(vma, action->map_kernel.start,
+			    action->map_kernel.pages,
+			    &nr_pages, vma->vm_page_prot);
+}
+EXPORT_SYMBOL(map_kernel_pages_complete);
+
 /**
  * vm_insert_page - insert single page into user vma
  * @vma: user vma to map to
diff --git a/mm/util.c b/mm/util.c
index 5ae20876ef2c..f063fd4de1e8 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1448,6 +1448,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return io_remap_pfn_range_prepare(desc);
 	case MMAP_SIMPLE_IO_REMAP:
 		return simple_ioremap_prepare(desc);
+	case MMAP_MAP_KERNEL_PAGES:
+		return map_kernel_pages_prepare(desc);
 	}
 
 	WARN_ON_ONCE(1);
@@ -1475,6 +1477,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 		err = remap_pfn_range_complete(vma, action);
 		break;
+	case MMAP_MAP_KERNEL_PAGES:
+		err = map_kernel_pages_complete(vma, action);
+		break;
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 		/* Should have been delegated. */
@@ -1495,6 +1500,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
+	case MMAP_MAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1514,6 +1520,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
+	case MMAP_MAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index f5f7c45f1808..60f0b15638d0 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -454,6 +454,7 @@ enum mmap_action_type {
 	MMAP_REMAP_PFN,		/* Remap PFN range. */
 	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
+	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from an array. */
 };
 
 /*
@@ -472,6 +473,12 @@ struct mmap_action {
 			phys_addr_t start_phys_addr;
 			unsigned long size;
 		} simple_ioremap;
+		struct {
+			unsigned long start;
+			struct page **pages;
+			unsigned long nr_pages;
+			pgoff_t pgoff;
+		} map_kernel;
 	};
 	enum mmap_action_type type;
 
-- 
2.53.0


