Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE68F53D9B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48316B0380; Mon, 16 Mar 2026 17:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDEA16B0382; Mon, 16 Mar 2026 17:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA316B0383; Mon, 16 Mar 2026 17:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B39536B0380
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:13:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79B4B1C962
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:13:44 +0000 (UTC)
X-FDA: 84553177968.14.7D9B12A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B77BC1C000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:13:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pSk+Y10z;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5R/7laSZRq7MzpFxmRoHcP+sqkunbBRLC1iGGpNZHg=;
	b=P2S+cqAV+35Qlf9PX694SOE1pT8KsO3/D2bs8xiAEjFC5DKWLYHwgT7V0x8ElcWhL2ctrP
	X/0JNbGnDB4zdXmQwX6bRVr/J8mjYLgslXqXK30fALMjA0PJuuhRjQ/VOAIXxgnGQhseBb
	VjT91YPYbaHE56p1rDz+1RFMFoQmfDo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pSk+Y10z;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695622; a=rsa-sha256;
	cv=none;
	b=FX6fWUA0qdxwlkMlWUggwQY8NdBx9NQ/MI7PZ/loIfFr1HObaZD0sHgYBsbr6pKccAYI8k
	WKfiY0vL+w8TqT1vNPnCMZbzdliTgCkv/MdNUPLZS/g5T1R0sy3CIZkZ/469t53fHZOrZM
	V+cXNNtgi+6h+9gqPH/vnAbg0rB9xS0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B396344586;
	Mon, 16 Mar 2026 21:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C629CC19421;
	Mon, 16 Mar 2026 21:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695621;
	bh=c79hrhz049PrCZP30n1FB+VqjpxYYCRXbHq0tZQIBj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSk+Y10zSu7m6MzGHW+Zdj7ihMuzjF24eeuo9sMEd1SIi1ZgnsO5uEAARqCbxy3ex
	 oE6fvSH131kajwxHWZ8tt6Q6XBoxdN7smQJv2Kvv8y6mZ3cJqrjaLmcXgD0Tk02C2Z
	 mCKXapKlxaHc+x094h8DxMdZw/zMC2wEgRnXuGlYHEErx3GRYe9+gzP5eeES3W7egb
	 Ogf++b0M3MhKZdfQY5UckPy2CkE9x9ta4AkV7ew2fXdeSZ+hFb+L0MArn9fVQC4pQJ
	 /itZGiEpSxgbUm30nj1XqdaRgJbn40jjYmoPnRo1JvX7NyVWlvmu9IPR/m32IQ/C3i
	 eN2OFmCnnJ9Kw==
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
Subject: [PATCH v2 02/16] mm: add documentation for the mmap_prepare file operation callback
Date: Mon, 16 Mar 2026 21:11:58 +0000
Message-ID: <a921c8cdef8e934fb662cd585071a585e1cb3cf5.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ax3oy3mnrco6bx7s5k41yq93dxd8cxmi
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B77BC1C000B
X-HE-Tag: 1773695622-597428
X-HE-Meta: U2FsdGVkX18Q2AmSOBaQpT9FcSLriCe1aIh8saw7ltwCe9fEUp0Wgx3rRssdSDz8tVs44UJl/gxF0/EAwNyAvNcHveMta2dUmxLOlR8FTFJR1FZcWDt1E7qTx7pdXGC5xtas16i40WzLp7Sl/H9GZUDNd7z5QW/RMhJFRHUb5REPVgeyJsVeyvsPaHrYxFXphw+aN1BuU15c+l/L2ZA8rYRqic1+09u0G+0t9oqeRPJdcImqxM186CNGnPtu7lLz2K28QfCxrXo7YqsipLUzClLB3Y+MX/4wTYAXqPGlKkMm50YiPXQlGVd1B+TSWMk+12dbprwx8x3DTaeG5tZ0C8/6xEj7gDsYfcAtUQaxwuEUWRpC1R9chETBHMJ2D942dmXrjc0KLRXT4ceWXtX0rL+hN/lJ0ZVJrLxUd/p33Du+IPjsyaZj0aWYX0EaIOb27dtCa8qRRxusQ2DScp6ROC/CFvxL63V4kslwcssKvWwLrEBLElS0v4Bl7YDnRetgk1E4KcQK9V3SZ9FjxYQNuVsp9c+CVsqtEWE63MqJnGe2OxpXoanxBhFj4pKuo0rPCCfgovfIYQYFtjtIN6kCWkQjEBv9o+9n3IrJkv3+qv1YyxlP6zGemwpJ87tr/ZIXmRxaT501qssgGm3knAuoJ094iwoX/dbTVwuapWVY0YT6bmlgj3mP3JRykHJI6xiJ0Iz30Gtu21E7k5EC+jFtnOktevoUqtdFF4JEF786EAGhrKLxKzUOCDK5R4e53KAQ+qEtR/TVpnrrm17s06maMZoSBdY1rYHyFOsd+eMo7YGvjZ/h5VIVyn0MwKxY9irQ12iDUYtWyUOIRQqk+NndRe9nAeL724zj8CPGpFBftpssPhr+xgt3qXpSv5DsO0qfFgJui29nbSBekQSHfdPbsJcme9r68RlyiEYNxJZt4YJkvCErgndtezqdHPAm5pxdExjw4T7gXLlYiwKOaS3
 NCyfwZy5
 m9AfZteJh1DrhFh56zQpM5rSR1jEpnRe5W7sT7WQewEWWLGpQ/tLiVrLtWhZ1fhClJOILBKRC0LO+pO9QgjgKpQ6gs11bQAwLpg9vP75iW+nZzk99jw/brWzW5eovVXjbEgC11G1njm6/FxL/Juo5US5ThmeRslJBBmu0nwUAIKvT/yw67zxiLTpDmscNa3I45ylixFTg0/sPKUIuulZypaMDZF71KcKUohFxxle+yw7Frxos/WrQF1+IVm+L3B9+B8TeGp4XlyVJwiPnNLBoLPseGe9rIFgKvUJ1MsIUliTNaG5dt3CFG90/eGzWv9ypxdHpoebUJ4tEcMir0NZ4U5oXKoZlu6umpNrn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This documentation makes it easier for a driver/file system implementer to
correctly use this callback.

It covers the fundamentals, whilst intentionally leaving the less lovely
possible actions one might take undocumented (for instance - the
success_hook, error_hook fields in mmap_action).

The document also covers the new VMA flags implementation which is the
only one which will work correctly with mmap_prepare.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 Documentation/filesystems/index.rst        |   1 +
 Documentation/filesystems/mmap_prepare.rst | 142 +++++++++++++++++++++
 2 files changed, 143 insertions(+)
 create mode 100644 Documentation/filesystems/mmap_prepare.rst

diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
index f4873197587d..6cbc3e0292ae 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -29,6 +29,7 @@ algorithms work.
    fiemap
    files
    locks
+   mmap_prepare
    multigrain-ts
    mount_api
    quota
diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
new file mode 100644
index 000000000000..65a1f094e469
--- /dev/null
+++ b/Documentation/filesystems/mmap_prepare.rst
@@ -0,0 +1,142 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================
+mmap_prepare callback HOWTO
+===========================
+
+Introduction
+============
+
+The ``struct file->f_op->mmap()`` callback has been deprecated as it is both a
+stability and security risk, and doesn't always permit the merging of adjacent
+mappings resulting in unnecessary memory fragmentation.
+
+It has been replaced with the ``file->f_op->mmap_prepare()`` callback which
+solves these problems.
+
+This hook is called right at the beginning of setting up the mapping, and
+importantly it is invoked *before* any merging of adjacent mappings has taken
+place.
+
+If an error arises upon mapping, it might arise after this callback has been
+invoked, therefore it should be treated as effectively stateless.
+
+That is - no resources should be allocated nor state updated to reflect that a
+mapping has been established, as the mapping may either be merged, or fail to be
+mapped after the callback is complete.
+
+How To Use
+==========
+
+In your driver's struct file_operations struct, specify an ``mmap_prepare``
+callback rather than an ``mmap`` one, e.g. for ext4:
+
+.. code-block:: C
+
+    const struct file_operations ext4_file_operations = {
+        ...
+        .mmap_prepare    = ext4_file_mmap_prepare,
+    };
+
+This has a signature of ``int (*mmap_prepare)(struct vm_area_desc *)``.
+
+Examining the struct vm_area_desc type:
+
+.. code-block:: C
+
+    struct vm_area_desc {
+        /* Immutable state. */
+        const struct mm_struct *const mm;
+        struct file *const file; /* May vary from vm_file in stacked callers. */
+        unsigned long start;
+        unsigned long end;
+
+        /* Mutable fields. Populated with initial state. */
+        pgoff_t pgoff;
+        struct file *vm_file;
+        vma_flags_t vma_flags;
+        pgprot_t page_prot;
+
+        /* Write-only fields. */
+        const struct vm_operations_struct *vm_ops;
+        void *private_data;
+
+        /* Take further action? */
+        struct mmap_action action;
+    };
+
+This is straightforward - you have all the fields you need to set up the
+mapping, and you can update the mutable and writable fields, for instance:
+
+.. code-block:: C
+
+    static int ext4_file_mmap_prepare(struct vm_area_desc *desc)
+    {
+        int ret;
+        struct file *file = desc->file;
+        struct inode *inode = file->f_mapping->host;
+
+        ...
+
+        file_accessed(file);
+        if (IS_DAX(file_inode(file))) {
+            desc->vm_ops = &ext4_dax_vm_ops;
+            vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
+        } else {
+            desc->vm_ops = &ext4_file_vm_ops;
+        }
+        return 0;
+    }
+
+Importantly, you no longer have to dance around with reference counts or locks
+when updating these fields - **you can simply go ahead and change them**.
+
+Everything is taken care of by the mapping code.
+
+VMA Flags
+---------
+
+Along with ``mmap_prepare``, VMA flags have undergone an overhaul. Where before
+you would invoke one of vm_flags_init(), vm_flags_reset(), vm_flags_set(),
+vm_flags_clear(), and vm_flags_mod() to modify flags (and to have the
+locking done correctly for you, this is no longer necessary.
+
+Also, the legacy approach of specifying VMA flags via ``VM_READ``, ``VM_WRITE``,
+etc. - i.e. using a ``-VM_xxx``- macro has changed too.
+
+When implementing mmap_prepare(), reference flags by their bit number, defined
+as a ``VMA_xxx_BIT`` macro, e.g. ``VMA_READ_BIT``, ``VMA_WRITE_BIT`` etc.,
+and use one of (where ``desc`` is a pointer to struct vm_area_desc):
+
+* ``vma_desc_test_flags(desc, ...)`` - Specify a comma-separated list of flags
+  you wish to test for (whether _any_ are set), e.g. - ``vma_desc_test_flags(
+  desc, VMA_WRITE_BIT, VMA_MAYWRITE_BIT)`` - returns ``true`` if either are set,
+  otherwise ``false``.
+* ``vma_desc_set_flags(desc, ...)`` - Update the VMA descriptor flags to set
+  additional flags specified by a comma-separated list,
+  e.g. - ``vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT)``.
+* ``vma_desc_clear_flags(desc, ...)`` - Update the VMA descriptor flags to clear
+  flags specified by a comma-separated list, e.g. - ``vma_desc_clear_flags(
+  desc, VMA_WRITE_BIT, VMA_MAYWRITE_BIT)``.
+
+Actions
+=======
+
+You can now very easily have actions be performed upon a mapping once set up by
+utilising simple helper functions invoked upon the struct vm_area_desc
+pointer. These are:
+
+* mmap_action_remap() - Remaps a range consisting only of PFNs for a specific
+  range starting a virtual address and PFN number of a set size.
+
+* mmap_action_remap_full() - Same as mmap_action_remap(), only remaps the
+  entire mapping from ``start_pfn`` onward.
+
+* mmap_action_ioremap() - Same as mmap_action_remap(), only performs an I/O
+  remap.
+
+* mmap_action_ioremap_full() - Same as mmap_action_ioremap(), only remaps
+  the entire mapping from ``start_pfn`` onward.
+
+**NOTE:** The ``action`` field should never normally be manipulated directly,
+rather you ought to use one of these helpers.
-- 
2.53.0


