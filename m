Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C775FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63C86B00B6; Mon, 27 Apr 2026 07:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38AF6B00B8; Mon, 27 Apr 2026 07:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50836B00B9; Mon, 27 Apr 2026 07:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A18846B00B6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:48:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E6544017D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:48:12 +0000 (UTC)
X-FDA: 84704162424.25.9533BCE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 688934000A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:48:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O7gBAPoR;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWoUekCfceDWAoSP9U7z0Obsn3wMOg4GRgJXzd/rX7Q=;
	b=2Fpy1rVAuRHB648UkMVF1sB7HkfD6jFtsOTYB6F6T4RakX0RdLJn6FhXUaDgChMRJhk4/P
	E8xHxiEXp3ptk5dBjIhzDWZIDMIspKRQSBMykvdUlKrvSBc6hDZDE5iC0Ki0zefmcSRbTq
	4CLq1Iq/F7GY+KE4xJjUj0WTq7NVeqo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O7gBAPoR;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290490; a=rsa-sha256;
	cv=none;
	b=XGES48+/58l83lsZYKGDMjI/seWjMJv8JJoRU5hqRDyLAWIqv+ZDwN3zK3dIO5a69+LRDf
	eujherCrWrOxxDQfxKbEzieCGfV5I7Uc8/e5onlfV68xTvcbR0PCSmHWqm+t//C3ioamA2
	ProeyyIHNu08s0CBsK5hFRJ7gqmoy3I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D6BB560180;
	Mon, 27 Apr 2026 11:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD3BC4AF09;
	Mon, 27 Apr 2026 11:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290489;
	bh=pjmD2rpWCTaX/fu8VNsiLzZf3zO/e5i0dzsoenQP/qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7gBAPoRN7OpkMaur6cH9VpqNyNmw3fv3zNQOigJejeBqwr+VoIhqnt8BAUz75A6n
	 4W0m+4sopJjPubKP6ES01G/OhspOCer+CC/SU0zoDnYSuNEInSXR2LEgo7KtFTWJpH
	 c+grh1VyfSk7fzzgW4qV2zaNFTpn47mJUl69YAZ5js8ijvg9bMQ8flfDTSl4GwCxyN
	 agXu+0NhyEtFkXp+py79KBvA7mW8dqB3XYSc40jk1paz0tx42dijZ82nda09NXNxg+
	 Mk+SAwTd6P3LvkGWTVlDQ2kLCNdxmwcpxBLzuYe0GZ88fZJulS75cmnI5Q/LYd81yW
	 A5A6V6KxUA0nw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 15FDAF40069;
	Mon, 27 Apr 2026 07:48:08 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 27 Apr 2026 07:48:08 -0400
X-ME-Sender: <xms:-EzvaekTZyx5qVbzGFEDxvU_StAcrPifBl41S1Tk_r6Kp8rhavt0Ng>
    <xme:-EzvaZwXvbrFUKEHfYlDscqkn7QVCrAlnPHuY6xRL2ghfg0jiS3SIPcgJVJVSD6f2
    _U3GZFhPefLD78fGUrvaAQtrUAjnVrJQacDiqV-67V6sp1ElDaNSw>
X-ME-Received: <xmr:-EzvaVJ1Rrpcst0AmAzbM-acln8iL3li_S8DFBZMd5UVZ-HyL-CeXKoFyA2HZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejkeeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvvefufffkofgjfhggtgfgsehtkeertd
    ertdejnecuhfhrohhmpedfmfhirhihlhcuufhhuhhtshgvmhgruhculdfovghtrgdmfdcu
    oehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhephfdvfedvveejve
    ehhffhvedufedujeefuddvkeehleduhfeihfehudejffffiefgnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtph
    gruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedq
    khgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtg
    hpthhtohepvdegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhi
    nhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgt
    phhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrd
    hhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughi
    rgdrtghomh
X-ME-Proxy: <xmx:-EzvacKw21LaXNJMXCZyLXnXadXxqN12RkCJu6M4OaCWBXIO69Ch9Q>
    <xmx:-EzvaUXh-KXNWOJWE29bn8QGh3V47iKVqWc4c8Pg2BW4cidBjBT82Q>
    <xmx:-EzvaUD6QMZ6mWC9wjVoxVP65ESaeOEDg4NnW-zzevwE6L121jhCPg>
    <xmx:-EzvaXEzcU3n9hCJORUJJftNQACO3pwzRo2pF1lJ0MBKZj7sAAR5PA>
    <xmx:-EzvaQecOHD1Y6YsCN9oPVNEkjaBvP4xDltJmuX64Wb8kqfceoK5DMan>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Apr 2026 07:48:06 -0400 (EDT)
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
Subject: [PATCH 14/14] Documentation/userfaultfd: document RWP working set tracking
Date: Mon, 27 Apr 2026 12:46:02 +0100
Message-ID: <20260427114607.4068647-15-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260427114607.4068647-1-kas@kernel.org>
References: <20260427114607.4068647-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t7sn3p3ikqq6tgemrwhhttgnoffbwcjq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 688934000A
X-Rspam-User: 
X-HE-Tag: 1777290490-529777
X-HE-Meta: U2FsdGVkX1/h9pDWYgNeXiKFyGYmAhbQi98v9XVm7srtlKfxSqRyT1MceDXqQ06aESut6yH+FTL5kDpmbbYqRDYZi5jmvhGcHMyq8P1OlQQOuwkugsz7rTtIDYX1rI5FWdgazC6eg2QdYZqegKuLy+n2mMCYetC7fXyKQcOHbL8nRqKzRZlis+DSpnhKa/Jk0swh7VuMBHlC9gxkL7TpvSbwWTINyvypi2+RDt8qpzHPFViBL5gffhuLkIeoivCmGOl/Ov+oR/0Zw9bePKmCDeWVKA/+CEakKvSRFAUbUfZKZx8kmCeKZsDKvspYLBFKWVltUm5Rmrj5Lw7pXfq1ddWzUyPLp6zutexCbSjsKAWK7LpsLBI+W/MM/Yaj+FMOUzi3+a2BaSpynOUJ5JAHiELbw+sggIjeyUr8QD30kmfMfwnFaBT+05hPDFZBmHF60WzXZGAMgbqZyWgVxsnxA6GE6dIpHU/Ct0jO4fiK22gdgsoXndZnKQ+HsJ6NvFSa9+SeDdhG34UiA+6wNCl4E56IpqeITGJQ7to6ThV74wBmySWMYO3oqgFxwqVbW12hM3x/BeEkWH+Di1mX05YqnQ/paCeWUETEmwu2ZzrzWZ//IWi5hiO3BYABAe62Q598H7OCVeXMUCAv4lcDZPJW8qHct+osmK3jBgI9jyvCHKbjAz7KsvfIzE4Oxr8Z6DahyU5By0fz+SbBNTrLiVdOzUvO9fkkDe0W+Zjk1QkDVuw3dqmevmQ1QcFrnVawTCTZvPCUCjONLKjDIVkCvuDY7/wcX/wZYfwzr1e0cHdR/rbeRkjvReiy+/ehDUMADFngOPwdCsR8ThyD8fK44jtORta+2IpF6B3X22yqz7XgTeD49u/NbaCejq5xdj7W9siztuCuSMrWrwWCIAEXfAxJT6UnPvD2/fF6tvZg44E4/uXMO/yW+3Gp3KfJ7RJXO+19ardxJDjjq0VAi3Oip9Y
 ogLXrb4O
 jbWmO0icpQBkvXSpuwDhPbrFXTgGq6KT/LVMrPWBAxvwQM52afOTUI1q4hAp1HLrVhskf0phE4RWhxoXmDRGvwKA10zWQpyb4/pvfonsUSHVm8LO4cEcqacVFqGyy8B3fR54jDeaUbPx4GVavTInckrYhmb6Umqma17fEGBcdY0PjX0x9wZXHAS9uBCIWd+GMj0u8t86Jva5qkvlkF2KAiEgPGDCvaFKaEWl6Kok4iFcSZR8TF6MkBaLamvNU4Pc/PYAJEboZxQBaBN86iKmxIEgtQ2C2mDPS6889cRoOivtbkQU=
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
 Documentation/admin-guide/mm/userfaultfd.rst | 201 ++++++++++++++++++-
 1 file changed, 195 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
index 1e533639fd50..c6304ddcf238 100644
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
@@ -307,6 +307,195 @@ transparent to the guest, we want that same address range to act as if it was
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
+A typical VMM lifecycle for cold page eviction to tiered storage::
+
+    /* One-time setup */
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
+        /* 4. Evict cold pages (vCPU faults block in handler) */
+        for each cold range:
+            pwrite(storage_fd, cold_addr, len, offset);
+            madvise(cold_addr, len, MADV_DONTNEED);
+
+        /* 5. Resume async tracking */
+        ioctl(uffd, UFFDIO_SET_MODE,
+              &(struct uffdio_set_mode){
+                  .enable = UFFD_FEATURE_RWP_ASYNC });
+    }
+
+During step 4, if a vCPU accesses a cold page being evicted, it blocks
+with a ``UFFD_PAGEFAULT_FLAG_RWP`` fault. The handler can either let it
+wait (the eviction completes, ``MADV_DONTNEED`` fires, the fault retries as
+``MISSING`` and is resolved with ``UFFDIO_COPY`` from storage) or unprotect
+it immediately with ``UFFDIO_RWPROTECT``.
+
+This workflow works identically for anonymous, shmem, and hugetlbfs memory.
+
 QEMU/KVM
 ========
 
-- 
2.51.2


