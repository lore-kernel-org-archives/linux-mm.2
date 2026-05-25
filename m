Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9CB2CD5BD2
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AAE96B00AC; Mon, 25 May 2026 07:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DB786B00AE; Mon, 25 May 2026 07:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707B06B00AF; Mon, 25 May 2026 07:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF386B00AC
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:39:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E745401D7
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:39:22 +0000 (UTC)
X-FDA: 84805746564.14.22EDFF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id F29F94000E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:39:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GzgP1Lhn;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779709160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hye5fxZW50CCDqJ7YyOB92+pBAmmJOZ9B6SG4ApV+6E=;
	b=lcYYdtMBSZ/czxiVOp8Dj5fKWj1Euvkx+MgGG7PmubfF4AAB1K/efuSFxvyY01tpO55Oam
	dgcO054uTyglOroJ+xPZAIg02am0ixti02xdhOXxK8HLof5IIWbKl28pTYpD51vBHVqw/g
	OIcGXqwChMyo72dPkHe9wKhpcKgAWEI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GzgP1Lhn;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779709160; a=rsa-sha256;
	cv=none;
	b=yULxk7Fpjk8ClfZcZQSotlEd06XyayOggtdwGOZHd8dLFx6lRtpC2RvnpeS3rsOkah0C7+
	FhY17pYTOuix2SY77RKHGyynOnxCbHHUSfMaNX0ZhAlD+Gogw20ekkJ+3tmmL049F34Azx
	4SSpkQCiNW+Px9ygG4x7pwQN6PmhkMg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C3DA3445D1;
	Mon, 25 May 2026 11:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C537D1F00A3D;
	Mon, 25 May 2026 11:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779709159;
	bh=Hye5fxZW50CCDqJ7YyOB92+pBAmmJOZ9B6SG4ApV+6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GzgP1Lhnu3O3HWiuWZMBAVRfKCjBecJEVeWgmUGTL8+Piu6qwFOvlRudwW26q59vX
	 NAf49XSTGqp0y2ovf29vm7WQ6bm5m3XkB9WyqAqJclcl7H6GkSwQgRl/XboxGa4wLT
	 zOpt3wCNAdcLEUdrRXLRDrwpQKmBFt+d4SQ8MTpzLRgVTEOW5KaEOZ+jAKJPzgDsnp
	 nlgIducUAvNV4eKxURNLf+11t60uMh/n/6BQFwRjeqJnHH0zFJqo0Cc5YgCOq6TDlP
	 rJ50pH7WAUiJcFd+PrNQPPHDwDXfCFg3IlNMz2eEwMJ3KByuqK5DvX02njU47nyXRq
	 UvEKJcZVqQRCw==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 30278F40082;
	Mon, 25 May 2026 07:39:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 25 May 2026 07:39:18 -0400
X-ME-Sender: <xms:5jQUanLcj6vaFQSvVZHMK7QxkwC_C5NGiXOY4JbZB8vNzCbmCyPlzg>
    <xme:5jQUanCIJKpHxbHN4DslGv4TmTcorNg3WHPAoB8agflElwZ3g4qtHRolfjGHHuQwn
    blcrV3Wf6ZhLxA9zRtTVdGzv6QBYfSnmHBHpdXsKWEkL-pWaO784g>
X-ME-Received: <xmr:5jQUaojIPp35bveYwTcnZsX_hZxVmBYoBoS7kVoKxBD6qr8KzljceZ1mU-Fkpw>
X-ME-Proxy-Cause: dmFkZTEfoRdVBJYWBUADV7d9kIV+Nxm/pVUcgu2VEqiWnj8eQrxuVRmWJvpc9q3Oqv2JCI
    in3fN4Zd8kb+AIzxXT1aE8XhYzXjllPczHZpsDuave1RqUEJt2aM8NK4F+1xGB1lHbYgSB
    4+lR3LF0kMycZigQtO5w6VfLN0Aex+LApk+NDe4mN/AQtgEH82UY4yLdpanr1nUEhfYRPX
    qXaeB8tr6YycPJO/GKcHBfWh4XfvSwFXkiL84UUAHkAJqW6Bc0LpWOIYef91VRiFvO85Cg
    Xd8jmXx4jYBCkCANHtSsVLhpCbXIiIojLruOFr51QxylDrx8yfg2/g0kqIsUfNxsLFZyah
    1WtxIfMz6ZJeAiukcR6qxW5tDZd9mgUWB1AYzbt8FmzNd+EULMeBTFxo3MJeE5u3XNcdz7
    9fNnkSAm2foNSPwXtjawGXMPzu4aqtee6dQTx434U/aed7rDhTKhJccM6Na59r1bxSXJ8T
    ZQqXqvcAceMCMygwQ9LJTTduSFpyXfd1GZsCMTS9dgOfy81em/bT8UPWe4B6E3QJbHl2+7
    3/tofNLSdsio67XkIktCbDOaE/hQgFLvSTctuQb4Gnsh5pgiWiFAeXh/1m8qL1d0VxFIhQ
    etLKKCAmFyJJs2NPy5ZXhaQ781Zidp3SKMrxniyfznYg7kcaR9mrsXXu3Ikw
X-ME-Proxy: <xmx:5jQUapPkDfg8fSTzIioiXpMOlDwi4l5b14YdIrF_nrS60D8aM1bIGA>
    <xmx:5jQUanZ2E0ps6kEx8M_WdADC19wexbc7IUIt82kaUq-szInQMGVFnQ>
    <xmx:5jQUam-acN8p7pIKgkBk-qLGhP8kFQovTL-1pePfr2sPMBnDaACl7A>
    <xmx:5jQUai2qp0ZVS3ws3uEgR66g2NGaxDpubGLp8hBaykitvEcQHZt2OQ>
    <xmx:5jQUan0vDsixTwhRPUzoq-ZFPiEuvVjavpMX8lzAaFtisEAXzy1UNPkF>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 07:39:17 -0400 (EDT)
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
Subject: [PATCH v4 14/14] Documentation/userfaultfd: document RWP working set tracking
Date: Mon, 25 May 2026 12:37:28 +0100
Message-ID: <20260525113737.1942478-15-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525113737.1942478-1-kas@kernel.org>
References: <20260525113737.1942478-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F29F94000E
X-Stat-Signature: z9fxn9oq85k7hjtdnjojymecj36g3ofi
X-HE-Tag: 1779709159-934048
X-HE-Meta: U2FsdGVkX1/IYk99QXIr87Xq1hsOFqmtXIlX1C3E8J9wGTrE+rtC9z0d1Lfl3oAx1NOYfOSuzku/VUT/dqk/nRGjMi2lalCRQIAzzBBVfIiSEPbDU0S71ZlGVeuMZMW1fzAr3Chd/jQPp5MBoA7osQokuqqJWDchXApm33XOw/eb+ypGAKO8KPcPIFmSK3xcDapF9eU4Zb4hDI0yHr+nX4EVBxRZbFTQq5d+hmA67g6N0IbsHAaDmiaMwqYJb4ksAa9oem2pmJgy/akVO1JFKQLC/wgQIBuOZSvVUG6RiR6xDxwj4XzEZc9eD9COxTXpPgasW/AIaIKiw8+cw5mB0Z469teO/FSS6VDL7LqC3Ubdd10bi8sy+DXp0i70IVZf0x3YeIlvWdOUbhNVLDEq3wkySZDD0+hWMLi57UDeHDHGHXCtsrgHa69xAXdYxRvTugfTh1bpSzScoRnLkNS+hmpGXLZRpLz8To17vUy33HmbQ7f+h4uCU/jJHqy8cz1RWLTjDDcC1iOo1Wyx0QfvXtdGPmm2ftHf4gaxWmBHdpY2Ycexx98WhVFSiqb9CAY/b7xxH3aBkOQ9tNhrbFl2i0E+w+G+qbeSWMMpc2O0LGSS8bFW8I5caQd4R5yvntbA1Ax5ELISj2hNzz2mj+QAZgyhO+VmJNL7oDkyp/7dY5F80nYyiEy2AyhZ3hFepJazBEqYArErNeJAHVsSfDthwgu1nEjLXgwL15azCvX2EKDgt3YXUrTtUjJtqdUXtsXwdNbymm4OWmW+lot58K+5Ql34rJ52H69ofDYq+INAq4IaeLZoLJlNs6etVXBSftOXOpKbggjGDzmYJfPn1PqtOj3cqWFvHRJLfyst/Oj7a8E6c6FmzRkiS7DOSAXRSkp35Xu0McHdmkqIO5/VDRe0BVDARk31apd/iBrvRIlN+BPAVQzelJdYT95hWHmgkYB3ekADg41CaqvKizLYvwp
 HvhLlAVx
 n0B9bxZ8dh6ruUPu4VspWEms3PMLVviQbXC3IOoiTvvnDxIumPxaA7VPEOZs2RewIywMJM5YLDeNOcNvxtNjY3oliGBRMPXl0oXqm9QwuJngdPwqdqyDkrp2EaXgbN0q+Pc2UtK6E9ILk0LhYCLQ41zI18EkqVCbWKyqgcP2mSD7gA+GiA8TfILvEZlIFRSRsgSt5dSMeZW6Hb7vlUvCK9iwiXN+lc6QeZZJMfstIVinBTrze0SOvUaF1BgHgFNsemRW3c6D+F8pBEZTAk2KWqf8nIjKJB/gK5OW/Dco2JPwzBf8=
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
index 1e533639fd50..cb5d0e0c9fff 100644
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
+RWP is designed for VM memory managers that need to track the working set
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
+userfaultfd (``CONFIG_HAVE_ARCH_USERFAULTFD_WP``) and architecture support
+for present-but-inaccessible PTEs (``CONFIG_ARCH_HAS_PTE_PROTNONE``). When both
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
+Callers should inspect the returned ``features`` after ``UFFDIO_API`` and
+fall back to another tracking method when RWP is unavailable.
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
+persistent RWP marker today. The user needs to re-arm the range with
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
2.54.0


