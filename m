Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D48E3CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3996B01A3; Fri,  8 May 2026 11:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135DA6B01A5; Fri,  8 May 2026 11:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F8D6B01A6; Fri,  8 May 2026 11:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D8F756B01A3
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:56:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93E88160126
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:38 +0000 (UTC)
X-FDA: 84744705276.26.8676338
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 69D4914000E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H7C/H6Xq";
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778255796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1Z3BClU8qDiTUf/O1YbMN7RrsrqwTvTzGmh1AZCe9w=;
	b=iwZBRgnMzh7mQpzG0ZWreJVtuN/hs6W4YlUDtpwiWmmBUm1IYi9XixwjzwqJ6QlOtvabGt
	ur4Krq8BNxJAb3PIzSYD/UoD1h3hAKnGKE9EAMOgYmYXWtjsVVb32JIOyw1jpANtJlaH9O
	WEAIqioKgtlVn96zpu770KPvI7lYHnA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H7C/H6Xq";
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778255796; a=rsa-sha256;
	cv=none;
	b=tbp9/S8JKs84ZjfigiPz10KoUZDKfJnYrQ5aeM2E6MMK3gAIi8Yxjrq90rVy4KULM7Th4S
	r4/j7wtW7ZdJh/SvhSIrrttbo8kE6nWvMa7+MPJ3ZpfqbzkW5BhkqK6V6ETjoHu62wcX+p
	3JDqH3RjwBYca1q0TD7MMBFRL/BEWSk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71EB444186;
	Fri,  8 May 2026 15:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735C6C4AF0C;
	Fri,  8 May 2026 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778255795;
	bh=l+dbYwiiQbDz3s8iB2jjpc10RatHEFNUV+AOLXxI2j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7C/H6XqccfhOCs5tsXVw4QyNDjQmKogsrkQtiaBXtz32BVbKGPfyiONc62i+b+VM
	 m5IwbwaId0SCXoej+zvS6jvoworQTKYnZXIPF0eQ0dsm0v9a+mL2J0eXBO3PCnswUC
	 dPHC9sluY5DfqaRNyQuPHoz8g23xdeMs4wSVfwt4BPDuSXdlcdn4X4ZEjVNWKoEcfN
	 3j3Fu5eaWiweIKCUx9LIXIdwOFx1IRnsC/wsRb/5y870gbGGtPf6Jpp983TZ9jo8ye
	 Ye3bX8O/ZcAsN04VdEGZKLazXtehYY8CrWkct0zJbiz1xExBGm9AWNd6uY3JoA3GEU
	 4Uxd3SIsaFwZA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id B22ABF4006C;
	Fri,  8 May 2026 11:56:33 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 08 May 2026 11:56:33 -0400
X-ME-Sender: <xms:sQf-aRVeVR4woM8Pq60F7OO11YwFnxcOwxh5kl6K9JwdRhN-OY7i7g>
    <xme:sQf-aVg0ZlwZycHNo_MdELexKCN8pYnfAx7Y4l4YXwfPzafKPrFC_TyylUmjaLrCP
    WsFiRh-PY5gV7muUjdRpPfnbauGmm109CAVG75JJL1-OSIH7DXjnqE>
X-ME-Received: <xmr:sQf-aV6ZaARKi2x1hty9BXwE1aQgM1kTp8BsBlawM1NognXHqLnBj6tRoGZ3QA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduuddtjeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfgggtgfesthekre
    dtredtjeenucfhrhhomhepfdfmihhrhihlucfuhhhuthhsvghmrghuucdlofgvthgrmddf
    uceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpefhvdefvdevje
    evhefhhfevudefudejfeduvdekheeludfhiefhhedujeffffeigfenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmth
    hprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdek
    qdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprh
    gtphhtthhopedvgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehl
    ihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehrphhptheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgt
    phhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhr
    tghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmh
    drhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihgu
    ihgrrdgtohhm
X-ME-Proxy: <xmx:sQf-ad7R1zLPQFPnbJNNkaUZPcDT9Rj-V17qhEMKPC_wC0fV_l_Ulg>
    <xmx:sQf-aTEi4ldgD5UMDfKlrfXMm0Hws-82BiKbq9kMCJGBIMwucgwEnQ>
    <xmx:sQf-abymdZiSFikbcd_aaUnl6HfibX_C282mhgABHTmlP3BlB9EBHQ>
    <xmx:sQf-aT0MJqsUGpKFXXHyN3JuXkQpWZ8_ftJrU1-kNBfO6eluudNMmw>
    <xmx:sQf-aeMyEJUUnUIB4UKsSHwhkSS2gI535muC5-xZrzHearwNkWHc8Sxf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 May 2026 11:56:33 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v2 14/14] Documentation/userfaultfd: document RWP working set tracking
Date: Fri,  8 May 2026 16:55:26 +0100
Message-ID: <0b6f87fd4809245f9eebee73f34e2fb14230330c.1778254670.git.kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1778254670.git.kas@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1g3akt7nzergdsxrbyozh617ap1a38aw
X-Rspamd-Queue-Id: 69D4914000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778255796-423383
X-HE-Meta: U2FsdGVkX1/tR6HQfE6Sa7jAT8+K5UUGcqiT7tCJtk/S+/si47/YvrpD+nGXbhwhqAsF00cvvViGcCRQ60SP1XFJRlT4uj1RCmb/HRuKx2MfCMHG+XDsrfzWm0aS9r1mPl6ik+9jvCli+N2RGeTlTn8gBnBVOyuJ/+YzvD746LRMOeT1oRNOg8O5nbOw7I7NyfRSsj9Jjec+ClWvRsSfooVYJ/2oMVvqoMrCNd97CKa/klt/qat3xeEnsKqzJlyiTz7mzBuoI8cROU8YeFOvzqF6ZUlgWz64LNOscf/K3y71kbGIcG6dIvcBzm6tcbQR3IcicmgDTODS5PfvywYg5JF0ksmRzWjnP8rMuqyMdrOdes3DFhzL5X7mLMoRdTz3yaYsxkD84EKlRVTD0yXSLqX91o982q6mf5UtSN0vNK11frs9qs3q+da2uBAmW1T8cUOgPvCV8ptMuJQJv/INJ37Zb93sNbIET8Qip+zLw/puQWpCMggLKhhNGCOkNaojR1Xi0r7gcVr5cZrdXAkAMLM8IV/YHq3d1afnpo+fcGdCal7LKkHa3KK6g6f060rHsyAQOzKbuS2rFyrHOSVJIF69nWwZih1+Ad3Vl8ChCPYpxEGQfa/LHz88iMwByEZZjkPicGvi40YRel+ZImvotIAcKoRnQiDNwTm0sqGHymIkSXERCw812vijchEVbbJ6hbB/grxKFX0Z4egrihaU7/B8DTaSv+ZZdnlHieQd9UzMvnH/GAKRSNrCn6HqDswgY2RJ/htFsoJy7oKvOtezSnxmERqhsHbq/+m7xOvSAy7JGJ2Vn1TYPTIGQccTJ9rjbSvfnXadj/Js1K8131mN+IH2jQP4HP35ZDp78mKgLjAJlgNcCvLo+hvkp5Z3CREjuUjO1gkixhLHOmPVxLf4jPU4rzslhAG3u5mIpFX7Fw1SSCUSgcW7OUeYCjDgYfi/W3HRkPtj+B8ggyJPEeH
 TNRgQ3uP
 6xQ9i/y7mOgIF6RpR1EdnzFlgqS8GEUze4nJyz0sjz4aWPjnrZAi5bolb15aacDa+2tJb9Hz9cTHUDc9xOG1UsI3bPoPa27NKaYrfqeCPAzYHa7d8dm8vbOGtyHqk+qKS3DT9TFhO8Hl5LJqgagSsUub1s6efJlgpTtCstoN+whUyVgy3xZh+yjJNlEV2jLiFyx9iV2EgCd2gPO68vdeF+rv8jP7h0/C6dq0wBKtnR3T7vMoHZkDnPgSUbVEs+GbxfvfTWAvDay7GWqoZY52p7NHck6CxCy5u0GpJhy1WsSStgXA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an admin-guide section covering UFFDIO_REGISTER_MODE_RWP:

  - sync and async fault models;
  - UFFDIO_RWPROTECT semantics;
  - UFFD_FEATURE_RWP_ASYNC;
  - UFFDIO_SET_MODE runtime mode flips.

It also covers typical VMM working-set-tracking workflow from detection
loop through sync-mode eviction and back to async.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 Documentation/admin-guide/mm/userfaultfd.rst | 226 ++++++++++++++++++-
 1 file changed, 220 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
index 1e533639fd50..5ac4ae3dff1b 100644
--- a/Documentation/admin-guide/mm/userfaultfd.rst
+++ b/Documentation/admin-guide/mm/userfaultfd.rst
@@ -275,16 +275,16 @@ tracking and it can be different in a few ways:
   - Dirty information will not get lost if the pte was zapped due to
     various reasons (e.g. during split of a shmem transparent huge page).
 
-  - Due to a reverted meaning of soft-dirty (page clean when uffd-wp bit
-    set; dirty when uffd-wp bit cleared), it has different semantics on
-    some of the memory operations.  For example: ``MADV_DONTNEED`` on
+  - Due to a reverted meaning of soft-dirty (page clean when the uffd bit
+    is set; dirty when the uffd bit is cleared), it has different semantics
+    on some of the memory operations.  For example: ``MADV_DONTNEED`` on
     anonymous (or ``MADV_REMOVE`` on a file mapping) will be treated as
-    dirtying of memory by dropping uffd-wp bit during the procedure.
+    dirtying of memory by dropping the uffd bit during the procedure.
 
 The user app can collect the "written/dirty" status by looking up the
-uffd-wp bit for the pages being interested in /proc/pagemap.
+uffd bit for the pages being interested in /proc/pagemap.
 
-The page will not be under track of uffd-wp async mode until the page is
+The page will not be under track of userfaultfd-wp async mode until the page is
 explicitly write-protected by ``ioctl(UFFDIO_WRITEPROTECT)`` with the mode
 flag ``UFFDIO_WRITEPROTECT_MODE_WP`` set.  Trying to resolve a page fault
 that was tracked by async mode userfaultfd-wp is invalid.
@@ -307,6 +307,220 @@ transparent to the guest, we want that same address range to act as if it was
 still poisoned, even though it's on a new physical host which ostensibly
 doesn't have a memory error in the exact same spot.
 
+Read-Write Protection
+---------------------
+
+``UFFDIO_REGISTER_MODE_RWP`` enables read-write protection tracking on a
+memory range. It is similar to (but faster than) ``mprotect(PROT_NONE)``
+combined with a signal handler; unlike ``mprotect(PROT_NONE)``, RWP only
+traps accesses to *present* PTEs, so accesses to unpopulated addresses in a
+protected range fall through to the normal missing-page path. It uses the
+PROT_NONE hinting mechanism (same as NUMA balancing) to make pages
+inaccessible while keeping them resident in memory. Works on anonymous,
+shmem, and hugetlbfs memory.
+
+This is designed for VM memory managers that need to track the working set
+of guest memory for cold page eviction to tiered or remote storage.
+
+**Setup:**
+
+1. Open a userfaultfd and enable ``UFFD_FEATURE_RWP`` via ``UFFDIO_API``.
+   Optionally request ``UFFD_FEATURE_RWP_ASYNC`` as well — it requires
+   ``UFFD_FEATURE_RWP`` to be set in the same ``UFFDIO_API`` call.
+
+2. Register the guest memory range with ``UFFDIO_REGISTER_MODE_RWP``
+   (and ``UFFDIO_REGISTER_MODE_MISSING`` if evicted pages will need to be
+   fetched back from storage).
+
+**Feature availability:**
+
+RWP is built on top of two kernel primitives: a spare PTE bit owned by
+userfaultfd (``CONFIG_HAVE_ARCH_USERFAULTFD_WP``) and arch support for
+present-but-inaccessible PTEs (``CONFIG_ARCH_HAS_PTE_PROTNONE``). When both
+are available on a 64-bit kernel, the build selects
+``CONFIG_USERFAULTFD_RWP=y`` and the ``VM_UFFD_RWP`` VMA flag becomes
+available.
+
+``UFFD_FEATURE_RWP`` and ``UFFD_FEATURE_RWP_ASYNC`` are masked out of the
+features returned by ``UFFDIO_API`` when the running kernel or architecture
+cannot support them — for example 32-bit kernels (where ``VM_UFFD_RWP`` is
+unavailable), kernels built without ``CONFIG_USERFAULTFD_RWP``, and
+architectures whose ptes cannot carry the uffd bit at runtime (e.g. riscv
+without the ``SVRSW60T59B`` extension). ``UFFDIO_API`` does not fail;
+unsupported bits are simply absent from ``uffdio_api.features`` on return.
+VMMs should inspect the returned ``features`` after ``UFFDIO_API`` and fall
+back to another tracking method when RWP is unavailable.
+
+**Protecting and Unprotecting:**
+
+Use ``UFFDIO_RWPROTECT`` to protect or unprotect a range, mirroring the
+``UFFDIO_WRITEPROTECT`` interface::
+
+    struct uffdio_rwprotect rwp = {
+        .range = { .start = addr, .len = len },
+        .mode = UFFDIO_RWPROTECT_MODE_RWP,  /* protect */
+    };
+    ioctl(uffd, UFFDIO_RWPROTECT, &rwp);
+
+Setting ``UFFDIO_RWPROTECT_MODE_RWP`` sets PROT_NONE on present PTEs in the
+range. Pages stay resident and their physical frames are preserved — only
+access permissions are removed.
+
+Clearing ``UFFDIO_RWPROTECT_MODE_RWP`` restores normal VMA permissions and
+wakes any faulting threads (unless ``UFFDIO_RWPROTECT_MODE_DONTWAKE`` is set).
+
+**Scope of protection:**
+
+RWP protection is a property of *present* PTEs. ``UFFDIO_RWPROTECT`` only
+affects entries that are already populated. Unpopulated addresses within
+the range remain unpopulated; when first accessed they fault through the
+normal missing path (``do_anonymous_page()``, ``do_swap_page()``,
+``finish_fault()``) and the resulting PTE is not RWP-protected. To observe
+the population itself, co-register the range with
+``UFFDIO_REGISTER_MODE_MISSING``.
+
+Protection is preserved across page reclaim: a page swapped out while
+RWP-protected carries the marker on its swap entry, and swap-in restores
+the PROT_NONE state so the first access after swap-in still faults. The
+same applies to pages temporarily replaced by migration entries.
+
+Operations that drop the PTE entirely — ``MADV_DONTNEED`` on anonymous
+memory, hole-punch on shmem, truncation of a file mapping — also drop the
+RWP marker: the next access re-populates the range without protection.
+Unlike WP (which persists via ``PTE_MARKER_UFFD_WP``), there is no
+persistent RWP marker today. The VMM needs to re-arm the range with
+``UFFDIO_RWPROTECT`` after any operation that explicitly frees PTEs.
+
+**Fault Handling:**
+
+When a protected page is accessed:
+
+- **Sync mode** (default): The faulting thread blocks and a
+  ``UFFD_PAGEFAULT_FLAG_RWP`` message is delivered to the userfaultfd
+  handler. The handler resolves the fault with ``UFFDIO_RWPROTECT``
+  (clearing ``MODE_RWP``), which restores the PTE permissions and wakes
+  the faulting thread.
+
+- **Async mode** (``UFFD_FEATURE_RWP_ASYNC``): The kernel automatically
+  restores PTE permissions and the thread continues without blocking. No
+  message is delivered to the handler.
+
+**Runtime Mode Switching:**
+
+``UFFDIO_SET_MODE`` toggles ``UFFD_FEATURE_RWP_ASYNC`` at runtime, allowing
+the VMM to switch between lightweight async detection and safe sync
+eviction without re-registering. The toggle takes ``mmap_write_lock()`` to
+ensure all in-flight faults complete before the mode change takes effect.
+
+**Cold Page Detection with PAGEMAP_SCAN:**
+
+RWP-protected PTEs carry the uffd PTE bit; the fault-resolution path
+clears it. ``PAGEMAP_SCAN`` reports ``PAGE_IS_ACCESSED`` once the bit is
+clear on a ``VM_UFFD_RWP`` VMA, so inverting it efficiently reports the
+still-protected (cold) pages::
+
+    struct pm_scan_arg arg = {
+        .size = sizeof(arg),
+        .start = guest_mem_start,
+        .end = guest_mem_end,
+        .vec = (uint64_t)regions,
+        .vec_len = regions_len,
+        .category_mask = PAGE_IS_ACCESSED,
+        .category_inverted = PAGE_IS_ACCESSED,
+        .return_mask = PAGE_IS_ACCESSED,
+    };
+    long n = ioctl(pagemap_fd, PAGEMAP_SCAN, &arg);
+
+The returned ``page_region`` array contains contiguous cold ranges that can
+then be evicted.
+
+**Cleanup:**
+
+When the userfaultfd is closed or the range is unregistered, all PROT_NONE
+PTEs are automatically restored to their normal VMA permissions. This
+prevents pages from becoming permanently inaccessible.
+
+**VMM Working Set Tracking Workflow:**
+
+A typical VMM lifecycle for cold page eviction to tiered storage. Two
+mappings of the same shmem (or hugetlbfs) file are used: ``guest_mem`` is
+the RWP-registered mapping that vCPUs access through, and ``io_mem`` is a
+private mapping for VMM-side I/O. Reading ``io_mem`` does not go through
+the RWP-protected PTEs of ``guest_mem``, so the VMM's own ``pwrite()``
+never traps on its own ::
+
+    /* One-time setup */
+    fd = memfd_create("guest", MFD_CLOEXEC);
+    ftruncate(fd, guest_size);
+    guest_mem = mmap(NULL, guest_size, PROT_READ | PROT_WRITE,
+                     MAP_SHARED, fd, 0);  /* vCPU view, RWP-registered */
+    io_mem    = mmap(NULL, guest_size, PROT_READ | PROT_WRITE,
+                     MAP_SHARED, fd, 0);  /* VMM I/O view, unprotected */
+
+    uffd = userfaultfd(O_CLOEXEC | O_NONBLOCK);
+    ioctl(uffd, UFFDIO_API, &(struct uffdio_api){
+        .api = UFFD_API,
+        .features = UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+    });
+    ioctl(uffd, UFFDIO_REGISTER, &(struct uffdio_register){
+        .range = { guest_mem, guest_size },
+        .mode = UFFDIO_REGISTER_MODE_RWP |
+                UFFDIO_REGISTER_MODE_MISSING,
+    });
+
+    /* Tracking loop */
+    while (vm_running) {
+        /* 1. Detection phase (async — no vCPU stalls) */
+        ioctl(uffd, UFFDIO_RWPROTECT, &(struct uffdio_rwprotect){
+            .range = full_range,
+            .mode = UFFDIO_RWPROTECT_MODE_RWP });
+        sleep(tracking_interval);
+
+        /* 2. Find cold pages (uffd bit still set) */
+        ioctl(pagemap_fd, PAGEMAP_SCAN, &(struct pm_scan_arg){
+            .category_mask = PAGE_IS_ACCESSED,
+            .category_inverted = PAGE_IS_ACCESSED,
+            .return_mask = PAGE_IS_ACCESSED,
+            ...
+        });
+
+        /* 3. Switch to sync for safe eviction */
+        ioctl(uffd, UFFDIO_SET_MODE,
+              &(struct uffdio_set_mode){
+                  .disable = UFFD_FEATURE_RWP_ASYNC });
+
+        /* 4. Evict cold pages (vCPU faults block on guest_mem) */
+        for each cold range:
+            /* Read from io_mem -- bypasses RWP, no fault. */
+            pwrite(storage_fd, io_mem + cold_offset, len, offset);
+            /* Drop the page from the shared file. */
+            fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+                      cold_offset, len);
+            /*
+             * Wake any vCPU blocked on the RWP fault for this range:
+             * fallocate() does not iterate ctx->fault_pending_wqh.
+             */
+            ioctl(uffd, UFFDIO_WAKE, &(struct uffdio_range){
+                .start = (uintptr_t)guest_mem + cold_offset,
+                .len = len });
+
+        /* 5. Resume async tracking */
+        ioctl(uffd, UFFDIO_SET_MODE,
+              &(struct uffdio_set_mode){
+                  .enable = UFFD_FEATURE_RWP_ASYNC });
+    }
+
+During step 4, a vCPU that accesses ``guest_mem + cold_offset`` blocks
+with a ``UFFD_PAGEFAULT_FLAG_RWP`` fault while the eviction is in
+progress. After ``fallocate()`` punches the page out and ``UFFDIO_WAKE``
+fires, the vCPU retries the access, faults as ``MISSING``, and the
+handler resolves it with ``UFFDIO_COPY`` from storage.
+
+This workflow targets shmem and hugetlbfs (both support a private
+``io_mem`` mapping over the same fd). Anonymous-memory backings need a
+different inner-loop strategy because the VMM has no way to read the
+page without going through the RWP-protected mapping.
+
 QEMU/KVM
 ========
 
-- 
2.51.2


