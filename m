Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D8F109190B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C09966B0560; Thu, 19 Mar 2026 14:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92DC6B0561; Thu, 19 Mar 2026 14:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82866B0562; Thu, 19 Mar 2026 14:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91AC86B0560
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:23:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CF2F140703
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:23:54 +0000 (UTC)
X-FDA: 84563636388.25.439BEF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5F3B11A0015
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:23:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KTAHkHO2;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5R/7laSZRq7MzpFxmRoHcP+sqkunbBRLC1iGGpNZHg=;
	b=iCpIp42DrTmQFMHoT8xYirNmv4TXUcFhsUawR8TkSeIobESXVJuNOZ18IykfxnHvBmefS5
	iHsbrtNDrxmG8jqRnZNFeDg0u1kR7ndPIwYz44vf7RB7ze1y6G9dAkdy/DdJv4UZxua/8q
	17H4gZew9lSqCbTEqij/xijevL8fg0o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KTAHkHO2;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944632; a=rsa-sha256;
	cv=none;
	b=BhdW+7qwVudBUj7JyuHmsf+91fvRx2JyHzRGfAy6XQ8wE1Cu+6AQ8vNYy8F4omTYidZkEP
	G6tW4d0sD7cCf7D8fCc4h3RodKsWDhqmr8VPNQtUtVx1wXEWTdWMEAHlNioGYdWIs/WEdE
	AUXJ52C6iOhxQnPODU0ZNI3i7cN9QyY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FB8841642;
	Thu, 19 Mar 2026 18:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8FCC2BCAF;
	Thu, 19 Mar 2026 18:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944631;
	bh=c79hrhz049PrCZP30n1FB+VqjpxYYCRXbHq0tZQIBj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTAHkHO20jjzi2OQuuW19egzNH0jizGlK1Dc5LTVHZDVvNxkl6mXM0dgp6uLF2iuq
	 m3VvfYIj4LoeZKCD+q7y1A8+hXs1UlKUGMsz3tRSC2MlyPFmzs/kHE2gC+071pEuIy
	 kedaK6rDmGJjVNN+kuXbe7dIzP32bLhrTWp7wqVQnXLLE0i+tU/3rFCxJ9fN6UyZE0
	 MQSAtc0RHgIIbPCDvUToxfgES0OhUezL7vDYfZ36jPiDZvIDRicT3FFwNOUPYSbBtf
	 u0Dj1Nbzj9wt6ASZjk8ia+eQ6lRE1QhAvmBqDp7Z6LtPfZS36DSnpklDd3j4+9Xs6P
	 813RLiiOkALwQ==
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
Subject: [PATCH v3 02/16] mm: add documentation for the mmap_prepare file operation callback
Date: Thu, 19 Mar 2026 18:23:26 +0000
Message-ID: <172ef809d9976b067bba4cd9d2b78410c6c6d03d.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F3B11A0015
X-Stat-Signature: 3fsj3woi4nanff45wriftqbpetfkzbwf
X-Rspam-User: 
X-HE-Tag: 1773944632-126284
X-HE-Meta: U2FsdGVkX18ybvD15UwrHG8z5QWV8011eGNukpVyz9vBYUID5LVzhn1YQ2rZMnjuyZqv71KMnbfXcvey3mjL7wqdIDT+t3yFQ00HTV/4fRnL7EBE3MQx14PifghNBaLT3uyUSKqU0HFS0TAFI3slyMBctxTL90KXN4Lq/HZc3NEt5a/HGE1jUckZOvH8yp395/KzWdloQsNp+w9SJXIFgerkPm6emqRafeJZ5ryWH9K/6eAsite3mxr8I3FaK0A9j8GC7FBjjEoWQD4KyIXYsEn72fVXaSOU9foDFPHi7I8SLfjiMJxz/5hggB3wyuxqV9xLIzlPlBmby7tjCDPKQ9LOcG+fbQpHUl2Gt7hJHEpJ140WDtBDOOkBWTJd9AK20KSsJMlzqxtsc2LsXcizk+1pMUXeX/U0Xp3T0tLKAoh6SSiGU1ASfmWZqHK5rshYqGxC2PSPqsJa2JzUzeSJ+zIw7cbWP+FCIPNPkA0Gdb4mkQVUFO81F3zYie/O7TsGNVHSlqrSbqm77WiIfTpHAgO4X2utaEOZv000kfaX4GJPaVxhYoMOuoPZSkS0kDjCflhtPZG6GvPH9y37yVRCr5G7wZyYFX63ch/kEy48yF20I2wLq7hB31zssvbzcj8gsJD5Y88W1QAhGT9EUjhElQNRQnDeNBEMbrNHEEeXXk6eU2/Zc29Qk/YVwqCulsWvjDkddfkobqIMjhwbqLcFnJphfftizm8PC3TFDy+Na89owMSrqYXvCTcNm1QSfOl5r7sA1E5Vdgvxn8MYreFWk5WGwhCJ6ILGTLgOJcFkCFLBMkwMf2qf9ATEduKL+HrEMNIqjuTpjvqMaR15qvZzrBAKYBWj/SIIHNNPRglQ7XEfigO5d1mnYtmI2E/l6PCjZljsxLvvHvM/PXi+B8C0KGy2kAYwnmVJN22QJFvipNieSzcd6ioJ9IOamHtHeXQBNWAZ/HI88a8M0NMMUx4
 peQ4xJXS
 qrmjUbq9U6IKogmPe4tDhg8AMVZ/viniQ+AFy3riMOYNXAFtVkqBS23nWmhqh5dJU/wpV8BGeBQHwNVnc//i8PUwJCJpkjp258OjBtEJm13j45I4xLP8xHaK14LzD8duzw4UuQAI/vFjliwsek1M/YXENZ4EIv7L9dVV9Bd+PxHbo+f2shnVcWGA32JCOP2WaTWhAS2kli4bdB7AIidP70UHO7MAdIiyKf0tLmjNB080Ty3s3B1v4BeHcmbMmm76YDtU/MxjOK0ofnAjmxJT5UcLVq2dpfgUKUECUgeFkqvhdiSqSdyAGCEmanw7qbNf63NptltpjEsmBbesN+pWegjEIgQ3bJ35e9dgj
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


