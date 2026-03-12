Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 818F5106ACE4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCABE6B00B5; Thu, 12 Mar 2026 16:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEACB6B00B7; Thu, 12 Mar 2026 16:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2B16B00B8; Thu, 12 Mar 2026 16:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD946B00B5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:28:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50A3D13A7B9
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:26 +0000 (UTC)
X-FDA: 84538548612.12.40D81E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id BBC904000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I/IDHplT";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/NDVhjTYNREyF9cprrIh8SJsayXl13p8TZcGRSjxuA=;
	b=W2w3QF3zh7atY7HBqDqaPenO2U1qbxPY19d0fuZPE0DMbfgs7yFInqs8EGOqMglJ6hPiUy
	ous5YifrLdkkMkqVZWv4r/d9kEuccTUrfH7l5p1Q+D8IZ3ssfsJVGM/YgqW/13y2Q5UMka
	gYh09bP2KNRhxF8YVJlsTfeT4ok3e4A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I/IDHplT";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347304; a=rsa-sha256;
	cv=none;
	b=FOCSCEHh8/1Ge76u4FcAgtnWTYWfastvz5QXUTtckf1WMT4z+okQWdNm4i5OWDwMTmZHLE
	wxplsA/2e5yV6OPKJpqmk+WnRecMU7EHni0yjN+lPK11rrn8PcldHCUTUoY3OJR8dxNAu3
	xazYToEWOzNWctA0vH/1j/15BGqKzCE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 31CB961339;
	Thu, 12 Mar 2026 20:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C774C19425;
	Thu, 12 Mar 2026 20:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347303;
	bh=jgGSscmoelPI8GEiWGdwMLRrmOSZJpVQGB2V/0UBDOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/IDHplTtuCF1meDV4022nAtR0eunUyZdd/Pn6AG5LG8aC/qQuhx7VdN7Xi60Ijwi
	 rWIms1/Yp+FYH2BYdTfFB1pdAG2cEqHkRwA3NI10yCiiVssqT68FLEMWGinY97G30H
	 AMhWFjHZ8hWHClGwkxaGqF16kgp5Ih0W71zaBA5EXa4DZ9lvVjQJet93KcVY1YsC6w
	 AX6++a3hDsehyLMkh/7gGoppnBdYTd7QlvNYhmEvetQv3AVQaes0b+ASuwvNaf7KHG
	 eDJy51fvOizaY5bkXRbNrzCMor4ti+9ytYmyAT8JmZfpcabApjNaTPAcwwoSPYeevP
	 bV1fSgq3LSIXQ==
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
Subject: [PATCH 15/15] mm: add mmap_action_map_kernel_pages[_full]()
Date: Thu, 12 Mar 2026 20:27:30 +0000
Message-ID: <21d8899bb1f4db61203072fb3a56a6c98a61e23d.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BBC904000E
X-Stat-Signature: rmm4hke5r7q57jtxoyoz4u3ejypbyf3f
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773347304-723277
X-HE-Meta: U2FsdGVkX18zBs+YH6xhgpo0ADlzxCVUwLeMGHgWObw9EcanXoTVT2A6335C/mZcNKyusYxN7MVzpmwVaWwKGabJmODQpbvJiP4pfsQZdaUMQd8UuXlUbK+IG9oAYY0v7gVuYsQdkPE/EwvXYCtpYW3+jSwtNBB7gPaEg8XUnpAtASjFnFWTa3Ept9CbhDIMz9wk2qz3m+oynCxL8fM74lN4aa9oJV7GhNpri3QDlQXOzhCP2Pdftco11c34DyfhhppvCUM20iFTgypuYs+OhZZIdH6o0Nfz6apKpWVDe7T1j3MqvQjb/dhPFwrVVLTxO6JM1FQwvirJk9Z2CIFfX2zhqb+mm9YYu2Kiw3Lni8b0EPUFI96OzHPa6LIUZeSDobIJQ52WEsp86qVOV5/PiVBo3fWenAPYWXTk/DpHxACwHC8Gzt61LccRb2op9zEEPvLSB5wPLz+sX1Pl4q9luEqq/9f3b6KTcQhlu/wADohFQoGbc2XK+kPQJKrxUUvbOE6PpbJliU/6e5p57pnLg3xSAm+rVeOhjjQSdOkebhfpr4FfStORYhJJqK/2EZPPNfjt+uzJinm9EIKnHb0QwGSKeKaRGdYAov3jrwB0gnGRUBzUAG7NQDTenqjNRZv3Dy5xRP4TgMonmfnTVPyQMyZOlg39qpqPIvkNhCszDbj8B7WiTpkAtYPB7Wbeor6nsG1eQTmgPzzDoblbMa8KxHRcI73rDS1AMNUIpjnlSBXEq79lFA5A8JsQVCcTlevrI27K96nxkNhvMAqEKvrgJVwQyqTOH4+8EMMlvUTsm0qGNCVfm662TuCKmT8hn/qK1KU1Bb8LuxpNQYJkhZarJvaImAwmETUG7++gN8mCTNCdZVTepeao7Fl2bDBFsH6flKNk1PLCh4MzL7CmUyXOHdnpWS6xmTgI09/T4ZW230y2OhwOmwo+icZOMCUGIChM7pHNYqmkNu2wgGNa92x
 vc25VvGi
 JgzT0V/3kXbLQLn3WQUUyn6AVeGeJpBm0UNDx0l3aFgJuW1+DWlHz+f0z3wT9oew+S7GqJcrzBl/xVykKV6F48wlIqlq8WrIny6dBy0Pqfi60fAADl1LlV5xsFYzFBRsJlopL3yLFnQUVWTckgK9YJwIU5381MNaSCAJRp3GoNVrBAqdFFn4hrECwfm9COaHg5sZT/49gYvfvm2bGpa6cKCGSWkKJc2dHI8tzcCtZbGvgeY0PSA+AT0tP/2uAXGa1vipsmZMEW8kyUCXAibGjG2TmkLaWViNlLdpgHGMZRXzevz4cwVQHhaxHbBxq1oZe/kNGCA2XREcZEXbztiX3GmxDROZxk9IZ5FIO
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

This provides an mmap_prepare equivalent of vm_insert_pages().

We additionally update the existing vm_insert_pages() code to use
range_in_vma() and add a new range_in_vma_desc() helper function for the
mmap_prepare case, sharing the code between the two in range_is_subset().

We add both mmap_action_map_kernel_pages() and
mmap_action_map_kernel_pages_full() to allow for both partial and full VMA
mappings.

We also add mmap_action_map_kernel_pages_discontig() to allow for
discontiguous mapping of kernel pages should the need arise.

We update the documentation to reflect the new features.

Finally, we update the VMA tests accordingly to reflect the changes.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 Documentation/filesystems/mmap_prepare.rst |  8 ++
 include/linux/mm.h                         | 94 +++++++++++++++++++++-
 include/linux/mm_types.h                   |  7 ++
 mm/memory.c                                | 42 +++++++++-
 mm/util.c                                  |  6 ++
 tools/testing/vma/include/dup.h            |  7 ++
 6 files changed, 159 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
index d21406848bca..f89718285869 100644
--- a/Documentation/filesystems/mmap_prepare.rst
+++ b/Documentation/filesystems/mmap_prepare.rst
@@ -129,5 +129,13 @@ pointer. These are:
 * `mmap_action_simple_ioremap()` - Sets up an I/O remap from a specified
   physical address and over a specified length.
 
+* `mmap_action_map_kernel_pages()` - Maps a specified array of `struct page`
+  pointers in the VMA from a specific offset.
+
+* `mmap_action_map_kernel_pages_full()` - Maps a specified array of `struct
+  page` pointers over the entire VMA. The caller must ensure there are
+  sufficient entries in the page array to cover the entire range of the
+  described VMA.
+
 **NOTE:** The 'action' field should never normally be manipulated directly,
 rather you ought to use one of these helpers.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 88f42faeb377..88ad5649c02d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4160,6 +4160,45 @@ static inline void mmap_action_simple_ioremap(struct vm_area_desc *desc,
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
 int mmap_action_prepare(struct vm_area_desc *desc,
 			struct mmap_action *action);
 int mmap_action_complete(struct vm_area_struct *vma,
@@ -4177,10 +4216,59 @@ static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 	return vma;
 }
 
+/**
+ * range_is_subset - Is the specified inner range a subset of the outer range?
+ * @outer_start: The start of the outer range.
+ * @outer_end: The exclusive end of the outer range.
+ * @inner_start: The start of the inner range.
+ * @inner_end: The exclusive end of the inner range.
+ *
+ * Returns %true if [inner_start, inner_end) is a subset of [outer_start,
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
+ * Returns %true if [@start, @end) is a subset of [@vma->vm_start,
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
+ * Returns %true if [@start, @end) is a subset of [@desc->start, @desc->end),
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
@@ -4212,6 +4300,10 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num);
+int map_kernel_pages_prepare(struct vm_area_desc *desc,
+			     struct mmap_action *action);
+int map_kernel_pages_complete(struct vm_area_struct *vma,
+			      struct mmap_action *action);
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 316bb0adf91d..6e7a399f0724 100644
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
index 351cc917b7aa..608a98c4c947 100644
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
 
+int map_kernel_pages_prepare(struct vm_area_desc *desc,
+			     struct mmap_action *action)
+{
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
index e739d7c0311c..7934e303b230 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1445,6 +1445,8 @@ int mmap_action_prepare(struct vm_area_desc *desc,
 		return io_remap_pfn_range_prepare(desc, action);
 	case MMAP_SIMPLE_IO_REMAP:
 		return simple_ioremap_prepare(desc, action);
+	case MMAP_MAP_KERNEL_PAGES:
+		return map_kernel_pages_prepare(desc, action);
 	}
 }
 EXPORT_SYMBOL(mmap_action_prepare);
@@ -1473,6 +1475,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_IO_REMAP_PFN:
 		err = io_remap_pfn_range_complete(vma, action);
 		break;
+	case MMAP_MAP_KERNEL_PAGES:
+		err = map_kernel_pages_complete(vma, action);
+		break;
 	case MMAP_SIMPLE_IO_REMAP:
 		/*
 		 * The simple I/O remap should have been delegated to an I/O
@@ -1496,6 +1501,7 @@ int mmap_action_prepare(struct vm_area_desc *desc,
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
+	case MMAP_MAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 4f2c9bb6b1ea..50ef2f62150d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -425,6 +425,7 @@ enum mmap_action_type {
 	MMAP_REMAP_PFN,		/* Remap PFN range. */
 	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
+	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from an array. */
 };
 
 /*
@@ -443,6 +444,12 @@ struct mmap_action {
 			phys_addr_t start;
 			unsigned long len;
 		} simple_ioremap;
+		struct {
+			unsigned long start;
+			struct page **pages;
+			unsigned long num;
+			pgoff_t pgoff;
+		} map_kernel;
 	};
 	enum mmap_action_type type;
 
-- 
2.53.0


