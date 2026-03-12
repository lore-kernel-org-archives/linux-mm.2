Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49713106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9544A6B0095; Thu, 12 Mar 2026 16:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846BC6B0099; Thu, 12 Mar 2026 16:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70ADA6B009B; Thu, 12 Mar 2026 16:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59C786B0095
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:27:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E8651C432
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:27:56 +0000 (UTC)
X-FDA: 84538547352.21.7E23F8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7B71AA000D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:27:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZK1Wltim;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ed3SaxCrfcPidl/i6tHFkbpnTzPZFsKBbUrwmMEw0JA=;
	b=VVu5+XgMNakpjITcmlEwcNYQzIlhBJDCxqfZJ0q+Bx2/cYjHlZGEK/YeGPtf/k6iQwoisD
	86Rt+kCtTCq7ep0Sxin06jTiaTYLK56Q0b3pEkAROCTSyXIaJ7//wLS5fJi/P4cuWmaEHw
	K6KS7YXaQUEPxiAHB0S9pvp/RF3btFY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZK1Wltim;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347274; a=rsa-sha256;
	cv=none;
	b=QpOHB6WPy/F9o6wKwKjVo4DrMNj+ro6HYMC60I4tYOFClCi5xBDYUnP+TD6/Sc5oUcQbWf
	Y2RQjWGxlXsZpO6qVMtuJteSxSatE/PqfIIMQQwYpWkUtwVtmmhhdYolESYCKQFGabC1kz
	ChxRsU5kVPTb9jDDUkX6HH4qRoyX24o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F423C6133A;
	Thu, 12 Mar 2026 20:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B7DC19425;
	Thu, 12 Mar 2026 20:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347273;
	bh=Vhnl6dyI6DciWh1R2wyZ1qlkDiUoqFRvSKLSiU1V8ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZK1WltimUAZc0jYB/huW7CthVu5Pu5VFPFyTyvlS4T7HMAkTnJpb74i68i41ylW7Q
	 7fyRQuCh/gLCub/cymRHsmhpsfS8DFpbAqZr1SS92G3+vQpwXbZfJnBMCChrImWhS6
	 V+8bnKKwhWmdij/nWi43ezCIkdrjaJHlgcQy5rFniS8jR/7Rlk/YDXp43NqjK9oYzc
	 FeI0J/rG34AJ6d6heDnhG73A8JiyAlXMohvdqoF701Bc7TYx5fMtntCofNtc6fMrPg
	 EWAXKwA/Mf9O9WCfz+8946sw4KO8eURIrObVsTiW6QjgNpFc+hr+6SFctAmLsbLljH
	 BJiGxYp2Ms+uA==
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
Subject: [PATCH 02/15] mm: add documentation for the mmap_prepare file operation callback
Date: Thu, 12 Mar 2026 20:27:17 +0000
Message-ID: <c5bb61cf789df1ecb32facc29df9749987c7ddfc.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7B71AA000D
X-Stat-Signature: 4ddk54y3u8pjjx41n9bj61qobusohdek
X-Rspam-User: 
X-HE-Tag: 1773347274-308747
X-HE-Meta: U2FsdGVkX18qGrCKcGTNt0ApUmUeHwMsXRZybYRbkwxFlCoP7KYA+dsDHFlnytFuTXexyyvOMYUSBgqJuRDtNIMcgW9JYpV6pbuX/QiueW4JnKR2v8bGxp9Jx4by7APjhQL4DrLBzX6D1ct/xsV8txjsHk9exTSyGdtYhRe0OYGLUewzllLsXwo8sMbIiO4Gch3CYkHl0nI5TUS5Ktq9u6HvYbocXtMRCr1UEJYjTzcTiMXojp71Uhj55NDcFUKI2TvF26D6TUVUuU+eucgrNXrFN2pIKjlhOFL/Se2oKZ49ybSlsTwQZ/wuE9pPTq08Cpn4Sa1JYdaGYfWX3xTPuurxMAJN1Ft+KPqPyy5PwzKo00v3oNNqDzwB0yrYX6dnZxTed1wL04DwxI7xVnAq9Pa5uknpmaMf8RRVd3uRjSxcDlyXs7s9+toV624N4fmHJWyhy/DnqrjKIWHJFoYibOutvULAND3YSdCJeS/z01w3Buee3FRbRk8+nPO0JvrhAHWhU28qM1lPZ89B+BfiZyh483JJfimtC3Adnu2Ik6//sADEamT5eg0zP8yBxnx/KsjiJTV+f5favKLrZxr1N3tEHPgxx6bNLcwsT4lYCFL3q8s7i0jhEZ6aJVvJhmKC0evy/m/Wj1oMdtWdww+GXJOT4yDRrYu+0L+X6Jvmi2W1m7KLeuEAopYa7AC858hEsofDkBimwtgy08Qya/SY2HGNgkeyvzvx9E0zOy/XiBY/BdAjfecPLghUzKoDHMX0HZ9sx7SqpBYV32Lb/h2GLupLatUQKYq90I2coHg9Z35FrjkjgLlzhvJhmjAIXmOsaD1trpUCFLonGKOXc/23hqqnrveqZaCGpLyQ9iVB5aTI+uR9/Zql7DHu5Q+XzQ0+lnxnvA8bWDlPitJh12UYRNl0YyihgcXSc+pi4/OC3YOaO5YLy43VYMv7YIyU0UlIdIqv+lpL14ThtK9kbu4
 bRP7uZoZ
 Qulgc7EvZD/X/g0IWMcyPwVagFIP4qBxHOqIfPN3HsfTTVt9akBlzRu57RmGEyUnoVa3ETmAxsvhC45pu/5qDtD4leSCm29D0GxXzKfaEALz/NKjl7eLqL0ek+OOA3/oMrK9utGA+IukWd1M0glzoNK5opSUd6IVrHquEhZY6yZoyjYpcen2CFHGst1HTtXfZiBVZm0Cy/nDzO4n0DAHr5gUvpcADXLnv69tZK2uSmzbYINEu8z/UhQmpqOLOfjVGuRugP8U8yzyRtdwAKACRYk+BOjfUN3+JaJtRNcx3KXzFUaeu1ALyqeEGyjcI+SB4oSpuq08CjsXFkX11gx2tvm3SKTA/2BdaWTBT
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

The document also covers the new VMA flags implementation which is the only
one which will work correctly with mmap_prepare.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 Documentation/filesystems/mmap_prepare.rst | 131 +++++++++++++++++++++
 1 file changed, 131 insertions(+)
 create mode 100644 Documentation/filesystems/mmap_prepare.rst

diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
new file mode 100644
index 000000000000..76908200f3a1
--- /dev/null
+++ b/Documentation/filesystems/mmap_prepare.rst
@@ -0,0 +1,131 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================
+mmap_prepare callback HOWTO
+===========================
+
+Introduction
+############
+
+The `struct file->f_op->mmap()` callback has been deprecated as it is both a
+stability and security risk, and doesn't always permit the merging of adjacent
+mappings resulting in unnecessary memory fragmentation.
+
+It has been replaced with the `file->f_op->mmap_prepare()` callback which solves
+these problems.
+
+## How To Use
+
+In your driver's `struct file_operations` struct, specify an `mmap_prepare`
+callback rather than an `mmap` one, e.g. for ext4:
+
+
+.. code-block:: C
+
+    const struct file_operations ext4_file_operations = {
+        ...
+        .mmap_prepare    = ext4_file_mmap_prepare,
+    };
+
+This has a signature of `int (*mmap_prepare)(struct vm_area_desc *)`.
+
+Examining the `struct vm_area_desc` type:
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
+.. code-block:: Cw
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
+when updating these fields - __you can simply go ahead and change them__.
+
+Everything is taken care of by the mapping code.
+
+VMA Flags
+=========
+
+Along with `mmap_prepare`, VMA flags have undergone an overhaul. Where before
+you would invoke one of `vm_flags_init()`, `vm_flags_reset()`, `vm_flags_set()`,
+`vm_flags_clear()`, and `vm_flags_mod()` to modify flags (and to have the
+locking done correctly for you, this is no longer necessary.
+
+Also, the legacy approach of specifying VMA flags via `VM_READ`, `VM_WRITE`,
+etc. - i.e. using a `VM_xxx` macro has changed too.
+
+When implementing `mmap_prepare()`, reference flags by their bit number, defined
+as a `VMA_xxx_BIT` macro, e.g. `VMA_READ_BIT`, `VMA_WRITE_BIT` etc., and use one
+of (where `desc` is a pointer to `struct vma_area_desc`):
+
+* `vma_desc_test_flags(desc, ...)` - Specify a comma-separated list of flags you
+  wish to test for (whether _any_ are set), e.g. - `vma_desc_test_flags(desc,
+  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)` - returns `true` if either are set,
+  otherwise `false`.
+* `vma_desc_set_flags(desc, ...)` - Update the VMA descriptor flags to set
+  additional flags specified by a comma-separated list,
+  e.g. - `vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT)`.
+* `vma_desc_clear_flags(desc, ...)` - Update the VMA descriptor flags to clear
+  flags specified by a comma-separated list, e.g. - `vma_desc_clear_flags(desc,
+  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)`.
+
+Actions
+=======
+
+You can now very easily have actions be performed upon a mapping once set up by
+utilising simple helper functions invoked upon the `struct vm_area_desc`
+pointer. These are:
+
+* `mmap_action_remap()` - Remaps a range consisting only of PFNs for a specific
+  range starting a virtual address and PFN number of a set size.
+
+* `mmap_action_remap_full()` - Same as `mmap_action_remap()`, only remaps the
+  entire mapping from `start_pfn` onward.
+
+* `mmap_action_ioremap()` - Same as `mmap_action_remap()`, only performs an I/O
+  remap.
+
+* `mmap_action_ioremap_full()` - Same as `mmap_action_ioremap()`, only remaps
+  the entire mapping from `start_pfn` onward.
+
+**NOTE:** The 'action' field should never normally be manipulated directly,
+rather you ought to use one of these helpers.
-- 
2.53.0


