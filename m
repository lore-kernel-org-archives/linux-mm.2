Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BCBFF9D0D3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E016B00A3; Tue, 14 Apr 2026 10:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565006B00A4; Tue, 14 Apr 2026 10:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7E16B00A5; Tue, 14 Apr 2026 10:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 179346B00A3
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:24:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4EC2B9E93
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:23 +0000 (UTC)
X-FDA: 84657381606.05.90CC02A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1B5A31C0003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RCACLwG+;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776176661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMwPyUIT9dAibZ7SJWPLN/2zkXPfOIBiOS00kne5pX4=;
	b=quj37Y7fykWgG5SjgZPglthojlOM87/4NG/tlYjAXWePDo2CcvNDhD+ukO5IwQqyBPkdmd
	C3U6n2gsBOeHusHetd5a7Ug0NMTphub4tLcmgg25lqUuiK48qyegNuuaWAXVGcaBYGPi7f
	FaJJRYt/1DztE8d7AlN6mQK4CCQlFjI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RCACLwG+;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776176661; a=rsa-sha256;
	cv=none;
	b=pMKkjVVO5kQMwcvm2wDccb+NfnATHLbb1r+xCd5rL6qMNJ/iiA+NV1uyQOlA4XAZRODgbr
	OfVnCZpxKyCKgKeGxAmUZXvSageGwmPwZiYXH4i6HzVJhurZXeovhhuXNaJ0PAe/OdDxmp
	uoCVa8Xy8X730s6NJ0kjdgjrh+VN4qo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E29643E78;
	Tue, 14 Apr 2026 14:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B00C2BCC9;
	Tue, 14 Apr 2026 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776176660;
	bh=ib6BF6sXb1GJqhq34QbrG0+ehgQcsgDUzfrc0LMzV2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCACLwG+eHEG647SF3/1d/glSeROj3ipRX7oyEPZX/5ahWzFmp4mX7UQQrNzddt5u
	 SxexstFAdZaJ1PjMvTw8CXXdvrx4trzvsBkSFshNDRLlEZiP0A3/pjXayR0nxkfNVu
	 PAglBiHkcw7RlP+BELjXs1UtBgMebRzoT/1oWasNRRffEbN/Nyy+rOlvIYOwVG7bV0
	 noLI0ZH9aHIsKC7ED3oGFL9uvx4Q7lZSqk1xfqLM4KFRrwJJxLBL1F41FvsYitUjn1
	 q8oRGsZV8sEYQzX3VWJisIjOZHsoHxxaDXuO9VrduqVDDfABV8K0ZcbPXBhZRTsHoC
	 oEOmhn0a/6EiQ==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id 94FCFF40068;
	Tue, 14 Apr 2026 10:24:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Tue, 14 Apr 2026 10:24:18 -0400
X-ME-Sender: <xms:Ek7eaSq22qZaKbpO86six6OpUmf-pnTIdn1lgVRbbCCI9AntKjn2wQ>
    <xme:Ek7eaXmpZPoD_hpYk-2g1fw6teoGJFqU0GmC4CtLLwiEYfa1cg50TsVk6trIYX5Iy
    oml-Balu5PyYN-y7eSSjs52fPq3cs6gofAHXJhYnf7SdasYzE8zZkU>
X-ME-Received: <xmr:Ek7eacQwmuhyW8LTitgVKaE4q9ufsyof1wBeFJ1aVYUNTFtPbFNi0mGPzT212g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfgggtgfesthekredtredtjeenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhvdefvdevjeevhefhhfevudefudejfeduvdekheeludfh
    iefhhedujeffffeigfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeduledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghpthhtohep
    uggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehs
    uhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgt
    ohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:Ek7eaZAT3aJQaPi5S8rWub9GJgZn-6Bbob-82C-6AEDGuyu3yv5Y3w>
    <xmx:Ek7eacqo0_pbYaSNq88MVS_N3hQRcnzzT7ee3ax7PDY8tof9yw-kcw>
    <xmx:Ek7eaXgxzjhPjFxRFAsbk_G90LQZkRqUarqbvzzyIG4_S9mJS1lu3g>
    <xmx:Ek7eaZwoKU7MfjkdtO4VE0RIbvEpsUEFkeP5ln40aYPZM_1L4bmUhA>
    <xmx:Ek7eaVLB1dXZ4vI8U4Fyb_CTPszURIDRhcRXLtS9rRZ-WDicAsBcqV2j>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 10:24:17 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC, PATCH 12/12] Documentation/userfaultfd: document working set tracking
Date: Tue, 14 Apr 2026 15:23:46 +0100
Message-ID: <20260414142354.1465950-13-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260414142354.1465950-1-kas@kernel.org>
References: <20260414142354.1465950-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 68of3jjdfmh966xrfh4txq694xyho4zc
X-Rspamd-Queue-Id: 1B5A31C0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1776176660-578184
X-HE-Meta: U2FsdGVkX18APEwX0rpjqfhfGTSLpLJs0bE2AWG4BOgR0Dt9gfX7bcGHWvEvnJLc6KygSCD/RwuSoMVitk91i1lzxJwgZlRmZhtrcsUGmbZDC+tNgCHEwbeoBxZfW16nOyBUCZCJ9Gzn+kX9ULBZ9/0bijjy+okFQYXIGQbPsuLIsYRMowvWn3wcZvgd1r47hAm0Q+GY/KqM0EpIckdKOlqUcgkceGuUtsHzbN14He8XB9yTZ80IPIlk2qGTEAvBU5Y7bkn81jNfMkf1l3FsWFbYE5MGXBwvlb8KG8LFn3kCXECphQQ+giptsoxfwO+mmpSTgS11VSBZ7B3PBfgHatKA3HQCog4CZo+t35FVcjlbbIcrVjH8zevhTeVxaX7NF+AdGVPPc3zQk25bmUbBS1On1miM/chuqqo/4oAZ0d0dQ3g9EBGHy6HCXHYt/43xnsw9YHk2bOaYi6ttIW82n8NDo+WW36gdhpbwRFY54s/TRBAGh8H8bSMo9PPsRJxtPgcdeRYNzXnzAWeMm9kAU/1pvxCaTLjXTdjMo8EajaL9+5O3ZDBy43qchoktm5AFB2Gsq2LdMxEY6t221napEiK4P+kEnYFui9I4/JVU2l999C0r1gMPrJAImHIHNIfRr6PTgLqy9ijCHVyKumnqoyfLAFG8PRnhJtEt62CIkLKxfyW5EUNsgISkGyHkuY6bhcT8tC0ZplSs8n9IfmSGraioiHRk/aDu409QWa/76Xsr2S4rCCi6cBBBqAwdKH/8k5Efs8J90AAs8muKkeHoQG+T2ylokb0sXM5nqIoLm5Iu8wIMv+S/Yz3GxKGFFkaUCqrx9xHqrX0Y7reWw1xOH5DKybRck1fWNMCpFbc9p+Sye55CjUdkBhFSEPuiVOp6UAMtuFR+bMCLq3kpDHjFmetD/1T0Uyoeq/N/OucLLkzLKlNXgu94DmOsTlmXnvYX1qUgxlv58W3kgk4JF4p
 jD1uNZoU
 ODxUuFSy12uUvNwO+rmg9+dgS4bmHdhAVqgnYwSQWnuWA5YEky9bv1B8trJYb9Ul4AFHlnNSmQ4Vi7X9xUI+ATfLol2N4SMnCe5WMXnpMMz+ppsZOHhIvq13EWWc94XYdt/RurkfpEcgO4ikYA9RkjuXfin1pEKzSGeZ44x0yO9/+wSnapB6LjO2a92fUhAh7w74Oq3OOiSbYSJdYtxvxw6BgAKJWKKHlcb2ZYESXP+3ac4+Ad2iavd3jtobMQy1OeOONPVTQZ8fPqrIiEVaB7Vj0mFbKGh6Lyl2OS3mZSwSqYtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the new userfaultfd capabilities for VM working set tracking:

- UFFD_FEATURE_MINOR_ANON and UFFD_FEATURE_MINOR_ASYNC for anonymous
  minor fault interception using the PROT_NONE hinting mechanism.
- UFFDIO_DEACTIVATE for marking pages as inaccessible while keeping
  them resident.
- Sync and async fault resolution modes, and UFFDIO_SET_MODE for
  runtime toggling between them.
- PAGEMAP_SCAN with PAGE_IS_UFFD_DEACTIVATED for cold page detection.
- Cleanup semantics on unregister and close.
- NUMA balancing interaction on anonymous VMAs.
- Complete VMM workflow example for the cold page eviction lifecycle,
  with a note on shmem applicability.

Update the feature flag descriptions at the top of the guide to
reference the new section.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 Documentation/admin-guide/mm/userfaultfd.rst | 141 ++++++++++++++++++-
 1 file changed, 140 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
index e5cc8848dcb3..fc89e029060c 100644
--- a/Documentation/admin-guide/mm/userfaultfd.rst
+++ b/Documentation/admin-guide/mm/userfaultfd.rst
@@ -111,7 +111,11 @@ events, except page fault notifications, may be generated:
 - ``UFFD_FEATURE_MINOR_HUGETLBFS`` indicates that the kernel supports
   ``UFFDIO_REGISTER_MODE_MINOR`` registration for hugetlbfs virtual memory
   areas. ``UFFD_FEATURE_MINOR_SHMEM`` is the analogous feature indicating
-  support for shmem virtual memory areas.
+  support for shmem virtual memory areas. ``UFFD_FEATURE_MINOR_ANON``
+  extends minor fault support to anonymous private memory using
+  PROT_NONE hinting; see the `Anonymous Minor Faults`_ section.
+  ``UFFD_FEATURE_MINOR_ASYNC`` enables asynchronous auto-resolution for
+  anonymous minor faults (requires ``UFFD_FEATURE_MINOR_ANON``).
 
 - ``UFFD_FEATURE_MOVE`` indicates that the kernel supports moving an
   existing page contents from userspace.
@@ -297,6 +301,141 @@ transparent to the guest, we want that same address range to act as if it was
 still poisoned, even though it's on a new physical host which ostensibly
 doesn't have a memory error in the exact same spot.
 
+Anonymous Minor Faults
+----------------------
+
+``UFFD_FEATURE_MINOR_ANON`` enables ``UFFDIO_REGISTER_MODE_MINOR`` on
+anonymous private memory. Unlike shmem/hugetlbfs minor faults (where a page
+exists in the page cache but has no PTE), anonymous minor faults use the
+PROT_NONE hinting mechanism: pages remain resident in memory with their PFNs
+preserved in the PTEs, but access permissions are removed so the next access
+triggers a fault.
+
+This is designed for VM memory managers that need to track the working set of
+anonymous guest memory for cold page eviction to tiered or remote storage.
+
+**Setup:**
+
+1. Open a userfaultfd and enable ``UFFD_FEATURE_MINOR_ANON`` (and optionally
+   ``UFFD_FEATURE_MINOR_ASYNC``) via ``UFFDIO_API``.
+
+2. Register the guest memory range with ``UFFDIO_REGISTER_MODE_MINOR``
+   (and ``UFFDIO_REGISTER_MODE_MISSING`` if evicted pages will need to be
+   fetched back from storage).
+
+**Deactivation:**
+
+Use ``UFFDIO_DEACTIVATE`` to mark pages as inaccessible. This ioctl takes a
+``struct uffdio_range`` and sets PROT_NONE on all present PTEs in the range,
+using the same mechanism as NUMA balancing. Pages stay resident and their
+physical frames are preserved — only access permissions are removed.
+
+**Fault Handling:**
+
+When a deactivated page is accessed:
+
+- **Sync mode** (default): The faulting thread blocks and a
+  ``UFFD_PAGEFAULT_FLAG_MINOR`` message is delivered to the userfaultfd
+  handler. The handler resolves the fault with ``UFFDIO_CONTINUE``, which
+  restores the PTE permissions and wakes the faulting thread.
+
+- **Async mode** (``UFFD_FEATURE_MINOR_ASYNC``): The kernel automatically
+  restores PTE permissions and the thread continues without blocking. No
+  message is delivered to the handler.
+
+**Cold Page Detection with PAGEMAP_SCAN:**
+
+After deactivating a range and letting the application run, use the
+``PAGEMAP_SCAN`` ioctl on ``/proc/pid/pagemap`` with the
+``PAGE_IS_UFFD_DEACTIVATED`` category flag to efficiently find pages that were
+never re-accessed (cold pages)::
+
+    struct pm_scan_arg arg = {
+        .size = sizeof(arg),
+        .start = guest_mem_start,
+        .end = guest_mem_end,
+        .vec = (uint64_t)regions,
+        .vec_len = regions_len,
+        .category_mask = PAGE_IS_UFFD_DEACTIVATED,
+        .return_mask = PAGE_IS_UFFD_DEACTIVATED,
+    };
+    long n = ioctl(pagemap_fd, PAGEMAP_SCAN, &arg);
+
+The returned ``page_region`` array contains contiguous cold ranges that can
+then be evicted.
+
+**Cleanup:**
+
+When the userfaultfd is closed or the range is unregistered, all protnone
+PTEs are automatically restored to their normal VMA permissions. This
+prevents pages from becoming permanently inaccessible.
+
+**Interaction with NUMA Balancing:**
+
+NUMA balancing is automatically disabled on anonymous VMAs registered with
+``UFFDIO_REGISTER_MODE_MINOR``, since both mechanisms use PROT_NONE PTEs
+as access hints and would interfere with each other. Shmem VMAs are not
+affected since ``UFFDIO_DEACTIVATE`` zaps PTEs there instead of using
+PROT_NONE.
+
+**VMM Working Set Tracking Workflow:**
+
+A typical VMM lifecycle for cold page eviction to tiered storage::
+
+    /* One-time setup */
+    uffd = userfaultfd(O_CLOEXEC | O_NONBLOCK);
+    ioctl(uffd, UFFDIO_API, &(struct uffdio_api){
+        .api = UFFD_API,
+        .features = UFFD_FEATURE_MINOR_ANON |
+                    UFFD_FEATURE_MINOR_ASYNC,
+    });
+    ioctl(uffd, UFFDIO_REGISTER, &(struct uffdio_register){
+        .range = { guest_mem, guest_size },
+        .mode = UFFDIO_REGISTER_MODE_MINOR |
+                UFFDIO_REGISTER_MODE_MISSING,
+    });
+
+    /* Tracking loop */
+    while (vm_running) {
+        /* 1. Detection phase (async — no vCPU stalls) */
+        ioctl(uffd, UFFDIO_DEACTIVATE, &full_range);
+        sleep(tracking_interval);
+
+        /* 2. Find cold pages */
+        ioctl(pagemap_fd, PAGEMAP_SCAN, &(struct pm_scan_arg){
+            .category_mask = PAGE_IS_UFFD_DEACTIVATED,
+            ...
+        });
+
+        /* 3. Switch to sync for safe eviction */
+        ioctl(uffd, UFFDIO_SET_MODE,
+              &(struct uffdio_set_mode){
+                  .disable = UFFD_FEATURE_MINOR_ASYNC });
+
+        /* 4. Evict cold pages (vCPU faults block in handler) */
+        for each cold range:
+            pwrite(storage_fd, cold_addr, len, offset);
+            madvise(cold_addr, len, MADV_DONTNEED);
+
+        /* 5. Resume async tracking */
+        ioctl(uffd, UFFDIO_SET_MODE,
+              &(struct uffdio_set_mode){
+                  .enable = UFFD_FEATURE_MINOR_ASYNC });
+    }
+
+During step 4, if a vCPU accesses a cold page being evicted, it blocks
+with a ``UFFD_PAGEFAULT_FLAG_MINOR`` fault. The handler can either let it
+wait (the eviction completes, ``MADV_DONTNEED`` fires, the fault retries as
+``MISSING`` and is resolved with ``UFFDIO_COPY`` from storage) or resolve
+it immediately with ``UFFDIO_CONTINUE``.
+
+The same workflow applies to shmem-backed guest memory
+(``UFFD_FEATURE_MINOR_SHMEM``). The only difference is the
+``PAGEMAP_SCAN`` mask for cold page detection: use
+``!PAGE_IS_PRESENT`` instead of ``PAGE_IS_UFFD_DEACTIVATED``, since
+``UFFDIO_DEACTIVATE`` zaps PTEs on shmem (pages stay in page cache)
+rather than setting PROT_NONE.
+
 QEMU/KVM
 ========
 
-- 
2.51.2


