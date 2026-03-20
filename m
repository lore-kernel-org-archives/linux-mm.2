Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D961099B4C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044E76B0119; Fri, 20 Mar 2026 18:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C516B011B; Fri, 20 Mar 2026 18:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F036B011D; Fri, 20 Mar 2026 18:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D63366B0119
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 881CD8B6BA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:14 +0000 (UTC)
X-FDA: 84567911148.14.23288AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id EEDC940002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BP0JNkME;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=muQ2vb+DeP+Kx+yWNukCGR6BL2huHM03jsXFybg5T5g=;
	b=PaylpC4RZsaM1CekaauRtnHXF31OkJA8wCb2ELDL+n2jm64va5Ht3dExfvXpowKb2uQj5B
	LgsHhBqc7OwuLgVL4E6GkLhO1vDw1i1Jnfmsb6r1zD2OB0y6XIuaLuDS7eh3jF75QCKM+i
	xbHA+vIYDbncqUtgcA1r88g3liYV83A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046413; a=rsa-sha256;
	cv=none;
	b=lpaMdlUvS/HFB273Hfd82vWSTwU6WJ5Ut93DoagsOm8SC4/7WfpjaKzY3/gNrBcOj9ZIOA
	PzBPnAlcnYuXFRn9PuJ2z4+anSEITLh0vIdiTQCAm3zhaU9NRLhcNhh3KkhWHNclMJGcoa
	Xbw9cP2bMXdfnhNiAOhrkPKS/4+POOE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BP0JNkME;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 50ABF60130;
	Fri, 20 Mar 2026 22:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63142C4CEF7;
	Fri, 20 Mar 2026 22:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046412;
	bh=rSE44385lXGA3oPgZHQ6HYyHSrWEMNs2rXYUR/5mlfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BP0JNkMEU9ScWU1MBWdpsdyiCOPYpMtqHGutZnAF+H9Hw2B/NTyZwP8ZoBjTHaKeD
	 2sUyw6954caQDGYcilIX5Uh+SUzlPL13IU/boE3byXeL3s+gbquRuTBJwclJInPvKc
	 NH0v05BIyTeUhqynoazNkMeGIrVHEIcKpA5XRR4fvGwsOHM4q6X+IkqPg11Cbh3Vm7
	 OI9UOBefBD1DiVEwKzychhVbDGAcTugDy0cBTJlfo0Lj+bK0D1n0qTOash8Ie3TDlf
	 an+5lvHTjnqzeymP9HW5N+UAVpq23W2rinElVbNPJveGfcQwgA9vbH+Hx5zvjOao7L
	 3KSMdtjAvGnCw==
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
Subject: [PATCH v4 02/21] mm: add documentation for the mmap_prepare file operation callback
Date: Fri, 20 Mar 2026 22:39:28 +0000
Message-ID: <3aebf918c213fa2aecf00a31a444119b5bdd7801.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: srni9ut74w7th5emc7cwefc6xhpcyoaa
X-Rspamd-Queue-Id: EEDC940002
X-Rspamd-Server: rspam03
X-HE-Tag: 1774046412-781384
X-HE-Meta: U2FsdGVkX19eJwupEdYSQKjeL1dH2g2uXqQWNYkInTfiPd0/PZhENPR9Q0M5RG1HVtbp7yjBlNET1kiTPrKZLO/rObLCd5PnejfX8R1absHGkNjA2FtUa+O5Y4dJE4VekpDqGfl9ngZMaOfzKlxg5Dff8H0xPEmHlojro6m8EPP9WfwO1lUeyr/BQ6bd0Ue0dqBhludL0hue04qFj3Uxt6+OXM2aBUMYWW06fhSdY/wRAus45DTRFck0YXWN5JZpO110VPOLnbdeCHG8vv2SumlAJBxYjWq9C3YIJq8WDOJZ+yGRe+Iawc8inBvXwKJphUrIK5QLi8nC6nDh+S16yNAkC++pF5nakJkSHB01EW7y2sLV2i+9bmotGAwDEfzr2dJ5bN3HcKy+04BBC9ZHFbsHqlfVSyIwUGZ8XsFP9gtAcpepfd79hcyl7UKqzm4d9bd+JGwMxgwRyk2A5rBB59jPFK+L0TshkqUa5rsKrBwW+O1myZS6IwH4onLnnYhACkhCwUyGP9O9JQdc16IaRl/C+iUHN1evPM+jWZWEua+S6BW4gWDRGbaHDEakNAaXhomhd6unpYKE3jzgwecDNnLoP7FnkWlKtAE17F98u+Q3/Nq20SKphf3Fsec2bgJXAODUzUSah0MK/OpPMXFuGTQ/JZqnVSRkpFuG/k8o78xK2rdFsp57obpcpSnbHAwqTpS34buPEAB4dT7MZ2Q+oyQgFHYoy9FQZjQ4QnYjjhYdCQKaTkPTIbYiaaccA+MY2BJsO2GhnL/MbdmNV06zd4apJMc8HmiUpov4VMzWudHCVSxfKb4yOBSOEakW8ET7cvTPG3Rnzb1QyQScdEBGGxFUwOaCZKKhcdy4xyNSqHM0O2M7aIwEmftbOqsZ2Nzr6pxJ6sayf+Ukw5XD9AgONAy7KjwZSRaZvlonO6gapXyg75iQHKUzsfzJeEOaNp1TlP/pU0CgpyR17xkDLxb
 SyW2Fd4J
 6onOtFgvelB2/Zpo9VrSBRSrdZbtYsLi6XEhEp9cq2z6kHfOh5hiYk+AKEPKEp0vSJNeuRcxnp6RAqdqu+7ZQq0xhvyevjLByyE1mbQKyUFXr8+XVy3ZVgHV445RyV2cKBUrma/id41djQlVZjHx0jGWomagFA9hpdrZgItUTT/re/w3asUxzqTzT/7pjORRuqIGxOEhDgbPeFblpqM376KHN8TkoHqwOb2CqZIoInRRRcXbqnhdHB9W64zjyqVQsXJXl5neXD8ZeF+sH2CvZ+t5Vir8i+Zm3W10MCHwDKXg+IF43dMP7pZFwQK5iLqA3gF6IgOLbJr1NLGzX9FYTbmoat3sSJ2AJ8/wE
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

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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
index 000000000000..ae484d371861
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
+* ``vma_desc_test_any(desc, ...)`` - Specify a comma-separated list of flags
+  you wish to test for (whether _any_ are set), e.g. - ``vma_desc_test_any(
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


