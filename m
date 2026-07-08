Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75118C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D546B00AB; Wed,  8 Jul 2026 07:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E0B6B00AC; Wed,  8 Jul 2026 07:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CFC6B00AD; Wed,  8 Jul 2026 07:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5736B00AB
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:15:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5EA5A0715
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:15:00 +0000 (UTC)
X-FDA: 84965352360.06.C8F1574
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf21.hostedemail.com (Postfix) with ESMTP id C856E1C0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=pjPk02Km;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="M Eh3dk9";
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c75Xoz9iShdlcCBWN7mUU9pkULk42wEnMxyb0Cb35ug=;
	b=TzJ4IxPerzPrQLwaNQedcZAO0+koojTtM9Ir1uLQ2H0cZd2zTiYjVQVPmCtkpRmLmMgcPY
	zEguTSfZYI/jwnABpxbIBXVtojyggZyXGITwFNyo8ac8ytMCsR8YDF9hbO1nl5E6SXN4sX
	YOSKJYwpcpcJAZRh+m+S86O2Sg7hOHk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=pjPk02Km;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="M Eh3dk9";
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509298;
	b=2ITnBHOpuLV3lBCt2oTD9IYuRHY+CpDjxEboywcuMTEoWNMIQGazRrKokyk3nfFosDXtQv
	Zp7YgBnMP+SseEtbw6dgK7DmbBT4EMci97UUGhT6urEZ5MndeXSefs1E1beP+U6+3sJsq3
	1Md8+LVhj+TKANhagPsARfcqEGdIr70=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A3FEC7A00A1;
	Wed,  8 Jul 2026 07:14:57 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 08 Jul 2026 07:14:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783509297; x=1783595697; bh=c75Xoz9iShdlcCBWN7mUU9pkULk42wEn
	Mxyb0Cb35ug=; b=pjPk02Km428I6MowRDWkpjdFHItpxgjiqlNr9NHqOiGUYyI4
	ZR14hnxgJqu3zFAgIAlZLnhOYvH2+pUHZRkMMGzIUnVKMGfWTMuGTtrJzdgLXuuF
	LUTVjPdKCXpN43DDTZTBGl8trKPQSIumkC9puwN/whZ00/8SQAkF+3gt8vfsN7Uq
	1ZXuBa9YswqCBn81rL80l16uq1wmp7r+mG82ig5pmsTcHdVO4a9aWqpbag0dyRyh
	iXxouI6RffrtfWrG16R6co74WOQEOGlMKGrOL6GlZ4pn9iEp5bGrLH9QmE0ut/lz
	GQRHscGvvTJKoJnaKeYKrhO9bd1pmgu/KDfVlg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783509297; x=
	1783595697; bh=c75Xoz9iShdlcCBWN7mUU9pkULk42wEnMxyb0Cb35ug=; b=M
	Eh3dk9UwaWuhcBrSPMMHtpKDSn7sZqz8GT69OJANL4EC8wQSaUTm+M0/iJQp6wJo
	nuAxV6AJKdsWQVrfWBayJTHJ5kmvbjKJVBiunytHWBa12N0LKipnGQ2vnV2Q71PL
	eFuUgkjC62r46vT3CMEPU18qMrzc5C9bamg1u99+j61QBgSTkjYdrWIEkjpe3gAj
	XF6RM8lt3DpYrE2gNfEnZP36l7IcKduCVS6gzMF6WJIsBuA6twUMGCUjqmohn+4o
	lrnoBpjk2cL/mwJfU4JX0DMZwFgwcTAbXDs8B29uhwZxjLX3PlqAPOH9kw4qdXC4
	Lr1iAHN9Acn4nF3OqjNTA==
X-ME-Sender: <xms:MTFOavgImwqNvwEudUXbjigW3cED7ZXb654qqBoZUeQFjnQMjQO_mg>
    <xme:MTFOav_o2_BVOFJFfd5xjlPYlggmTAaegMwMkDMvlThc9rlSKyc9M7DpFQFimmx07
    WAEZw74W_HqMnsBYy0fZIbUw8aGnAYeVV_gtKproJpvyLj5Q-shsYQ>
X-ME-Received: <xmr:MTFOanmOyFbxOwfU0ampFhOsGTidfSHWcIano_8lwmw4DY8uvBq4JCfglbTHdg>
X-ME-Proxy-Cause: dmFkZTE642N9vI6I4TUMXnKMLsTKz3xPbgYTrIbuL7KmCcVoCJiIc6Wm4lPhpvCEkD2tyP
    RG+/Ls0yZPn9QIhyfgvnnfwco+9qzSBeAmOLrQcxJ9RK1xGo/G8FPgm9qado94bGUvvBrb
    gYA8KKGMae74UYT9vjFW60FgdgMR8AvdDtCMokbON/LVfyCbFXtVAmgP3mBheTWe3J+3o3
    /+BDy7u0RK1wUbrh03+DH1OzHcp510gy8h+uoiCnL2a3mmFbImJkwXlDDUCggXu1YkR6KT
    /GmmaykcOOvk0Njejzko4jJ77/swdGWeyLoHswpxAkRA72PZch6kdYJpETVwqSoCtmWEAM
    HgqNjsKptHtFMmgyOeWbUJBPMb/KlidCKlSmtExrhCjGHOiZdsX40lQgleHoOEbPJUP5x6
    wvUdAqFCPfMncRzPLluOcllXroefYC2iiaD54dSkVdLOxeglWDSIfopXwb9dFxwRAP8XDE
    hGio4ZuVBMFVjeIEB2cCLBneWRsC5S0hReeOZSF5PA1lMGknYx/eCt8g7YJwC0WiBsLR5B
    th3274vaEyOL862XREFQpxvhxmlowLzfRMDFzd+KB3eHnSV0EtNUEd/3TNmhjsytJ9GdjG
    OH0rNSk4KHje7CfVE3CfVQvWPbTg075aDO13wEJx+2b62YLr/j3lxZFw4/Bw
X-ME-Proxy: <xmx:MTFOal1wzdrCHPr2GFP6rhyNSVV7BHLzp_afvzWShaalYByCHGkCAw>
    <xmx:MTFOakS48MbJqKeSXXu_ahJOxuV9dKrcfqwjiN0jWLtdO925DIbiaQ>
    <xmx:MTFOatOeBNC_eugnwWHsipe9Ta0X6-Q7Hl9j4uEXc0TjVjLOGXKOYA>
    <xmx:MTFOaghYHm2HVqlbqTabqhBwPz6yb7zBOc9l9f8inUoqOLoDzAklBg>
    <xmx:MTFOalgzBj5Lcdqv1CzScyyPTo1z9Gt-pKD2OT-X82alt0uH7JnFM2Nf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 07:14:56 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
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
	kas@kernel.org
Subject: [PATCH v10 15/15] Documentation/userfaultfd: document RWP working set tracking
Date: Wed,  8 Jul 2026 12:14:16 +0100
Message-ID: <20260708111417.173443-16-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C856E1C0003
X-Stat-Signature: nubnxegapuxajeq31bqtgc8wqya8tkm1
X-HE-Tag: 1783509298-736386
X-HE-Meta: U2FsdGVkX1+Q39coA0Vnk4/yKYlXDFzA08nXFX0W411/ppyCi7qGy4dCwWzm3IMT7KefNKM+R1zwx4aTTbN+eI+NZVHnThY+TjUSBTaO0aEzB/1XVROCm2alesIGgQY28bspvFDmyidIdZqbTwmdSEGHlt4IdFKapuB2CqClnw/nHcMmQcU7D+fEPUu98ba9edzH2Fc52t0es85O8FfnBSnZn23q7laj2QfRVxIYVn1YjUOC80RlRbkkk6jTcJ3RxO7xBB9pgHKR08zM9MUZjteud+PLRZptp/V17/jIC75GTx99xmdJzI7vrAiPNJuAmRmFENE+rf7lWY8MUS+xTBm8t9djvAW0nIqRfcFmyM+dt+3m2OWnzIJiVYBMnEhsb0+DmpE0VTzZxnmD6OiIsrxdZq8hGT0cvjNb+43FSphNJna96OxhnhHzCC8RgJnLn3j7lmmcRsTOIoULfcagHVPuebJREdLgC5//wRUYB2kf2bXAI0n98oeDQkGk0VEJGHswvvTxZRWQNpnAxcJfSWE8Lm5p6E151FJS8SooRI2OvoJzCe+UVK1gzjJy2dCRSPEuBlLBz/kT3fJL/wU3D2ef+S66YNiAA2se4/rSw7z93xcqTyfZTKMppTnKPYZ/CtwWyBAVdzOXf+9yKYUJ1saBeqUf/x0ybVhUCYwlJD02czvGL9dZ5S035cNfp+hArTk2TJBFq+V2wg0DxFVazXiz/QUbdqWtUqhQQyuv1ZdZ5sNwpU8KQfLPfOpAz3Dhz6v2ZZ2GKCeBBgtp6QPtdOCjGcX/OH6BFYhP3Wp2q3ksLs6U4WVxunnyin5VsUqfmsI0qBXzuSzG8gPf+PZ2eLeYE/1a/nHCt9RIMzFkThLLrVC58GECrw/YvSe9n7lweTkEfIGB16aTwDCYM+njumIOh5JlMXk3JntJ4ITuRhpIH07RhihbUDeMKoWl6H0mprZ87ovsBxrTRRk3kZW
 jt3YMg0x
 oEsuNaPusBpRf+GHTjROI4yfQEb0NCIGMqEIFSF4dbM/QGapO3S7b8g3zvtmU+IxFejHYQSTA8l5aSkr4iKCcIxSG23puAeY8aLshWHqMTK3I7Wq+tigL0JpSz4NVPZMMb402w99uiblbOCICYHtVS2xHsHY+DXjk7Q231t1Grhr+aIs3SHVFAXrm5QQkmAT1idQ2ur4fOxiE+/qEDkfLcRu18q08AyZIJG3CHWU/Ri4v/w5OYuF/5ie86mGHNWfnde/SB1eycPyhPOT0ofLsTgNEEj+ucx1bcmEU2tqbpNztgMk1WKdKY3K3ogXEOzP2g5g71k22bOOwbfW+vnAHsHffbMLvMMOzvsZ1mv+2sCTi8laEQGkxKhRFm3L7BYiMUY4EIuviw8Q9ubEVI+0scAhUkDllv5JwDI1YjV5Ahc3jTbNuuwGj5EphP+2+He5iuJyXz7RsrutQlQOYIb5jtVJ8y6xcC+N6oWkviTBaih/Hht0GgVZXP7mgfYoX5D9akPhBnDykrm8jdb2J+W6Bu1qZC932npOb9qJOdjS5/XQD+z8LER6RTHrcUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

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
 Documentation/admin-guide/mm/userfaultfd.rst | 259 ++++++++++++++++++-
 1 file changed, 253 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
index 1e533639fd50..783d969f0e28 100644
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
@@ -307,6 +307,253 @@ transparent to the guest, we want that same address range to act as if it was
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
+``UFFD_FEATURE_RWP`` and ``UFFD_FEATURE_RWP_ASYNC`` are unavailable when
+the running kernel or architecture does not support them — for example
+32-bit kernels (where ``VM_UFFD_RWP`` is unavailable), kernels built
+without ``CONFIG_USERFAULTFD_RWP``, and architectures whose ptes cannot
+carry the uffd bit at runtime (e.g. riscv without the ``SVRSW60T59B``
+extension). Requesting an unsupported feature in
+``uffdio_api.features`` makes ``UFFDIO_API`` fail with ``EINVAL`` and
+leaves the userfaultfd context uninitialized; the structure is returned
+zeroed, so the error path cannot be used to discover what the kernel
+supports. The recommended probe sequence is therefore to open a
+throwaway userfaultfd, call ``UFFDIO_API`` once with ``features = 0``,
+inspect the returned bitmask, close that fd, then open the real one
+and call ``UFFDIO_API`` again with only the supported features set.
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
+eviction without re-registering. The toggle takes ``mmap_write_lock()``
+and calls ``vma_start_write()`` on each UFFD-armed VMA, draining
+in-flight per-VMA-locked faults before the new mode takes effect.
+
+**Working-set detection with PAGEMAP_SCAN:**
+
+RWP-protected PTEs carry the uffd PTE bit; an access (and, in async mode, its
+auto-resolution) clears it. ``PAGEMAP_SCAN`` reports ``PAGE_IS_ACCESSED`` once
+the bit is clear on a ``VM_UFFD_RWP`` VMA, so a *non-inverted* scan reports the
+pages that were touched during the interval -- the hot set::
+
+    struct pm_scan_arg arg = {
+        .size = sizeof(arg),
+        .start = guest_mem_start,
+        .end = guest_mem_end,
+        .vec = (uint64_t)regions,
+        .vec_len = regions_len,
+        .category_mask = PAGE_IS_ACCESSED,
+        .return_mask = PAGE_IS_ACCESSED,
+    };
+    long n = ioctl(pagemap_fd, PAGEMAP_SCAN, &arg);
+
+The returned ``page_region`` array lists the hot ranges. ``PAGE_IS_ACCESSED``
+is set on an accessed page whether it is still present or has since been
+swapped out, so the hot scan needs no ``PAGE_IS_PRESENT`` filter -- unpopulated
+holes carry neither bit and are excluded on their own.
+
+Track the hot set and reclaim everything else from the backing file (see the
+workflow below). Do **not** invert the scan to enumerate "cold" pages
+directly: an inverted scan reports only the ``VM_UFFD_RWP`` PTEs that are still
+protected, i.e. the resident portion of *this* VMA. For a file mapping the
+working set spans the whole file -- pages that live in the page cache but are
+not mapped into this VMA (a pre-populated tmpfs file, or memory populated
+through another mapping) are ``pte_none`` here, never appear in the scan, and
+would never be considered for eviction even though they occupy memory. Driving
+eviction from "file offsets minus the hot set" avoids that blind spot; a cold
+PTE scan cannot. To additionally record the *first* access to a cached but
+unmapped page (e.g. pre-populated content) as hot, co-register the range with
+``UFFDIO_REGISTER_MODE_MINOR``: such accesses then fault as minor faults
+instead of mapping the page silently.
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
+    struct uffdio_api api = {
+        .api = UFFD_API,
+        .features = UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+    };
+    ioctl(uffd, UFFDIO_API, &api);
+    if (!(api.features & UFFD_FEATURE_RWP))
+        /* RWP unavailable on this kernel/arch -- fall back. */
+    ioctl(uffd, UFFDIO_REGISTER, &(struct uffdio_register){
+        .range = { guest_mem, guest_size },
+        .mode = UFFDIO_REGISTER_MODE_RWP |
+                UFFDIO_REGISTER_MODE_MISSING,
+    });
+
+    /* Tracking loop */
+    while (vm_running) {
+        /* 1. Detection phase (async -- no vCPU stalls) */
+        ioctl(uffd, UFFDIO_RWPROTECT, &(struct uffdio_rwprotect){
+            .range = full_range,
+            .mode = UFFDIO_RWPROTECT_MODE_RWP });
+        sleep(tracking_interval);
+
+        /*
+         * 2. Switch to sync BEFORE scanning. In async mode a vCPU
+         * access races eviction: it would auto-resolve and mark the
+         * page hot just as the VMM writes it out and punches it,
+         * losing the update. Sync mode makes such accesses block and
+         * be delivered, freezing the hot snapshot for the rest of the
+         * iteration.
+         */
+        ioctl(uffd, UFFDIO_SET_MODE,
+              &(struct uffdio_set_mode){
+                  .disable = UFFD_FEATURE_RWP_ASYNC });
+
+        /* 3. Read the hot set: pages touched this interval. */
+        ioctl(pagemap_fd, PAGEMAP_SCAN, &(struct pm_scan_arg){
+            .category_mask = PAGE_IS_ACCESSED,
+            .return_mask = PAGE_IS_ACCESSED,
+            ...
+        });
+
+        /*
+         * 4. Reclaim the file offsets that are NOT in the hot set.
+         * Driving this from the file's offset space (rather than from a
+         * cold PTE scan) also reclaims pages that are cached but not
+         * mapped into guest_mem, e.g. pre-populated content.
+         */
+        for each non-hot offset range:
+            /* Read from io_mem -- bypasses RWP, no fault. */
+            pwrite(storage_fd, (char *)io_mem + off, len, off);
+            /* Drop the page from the shared file. */
+            fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+                      off, len);
+            /*
+             * Wake any vCPU blocked on the RWP fault for this range:
+             * fallocate() does not iterate ctx->fault_pending_wqh.
+             */
+            ioctl(uffd, UFFDIO_WAKE, &(struct uffdio_range){
+                .start = (uintptr_t)guest_mem + off, .len = len });
+
+        /* 5. Resume async tracking */
+        ioctl(uffd, UFFDIO_SET_MODE,
+              &(struct uffdio_set_mode){
+                  .enable = UFFD_FEATURE_RWP_ASYNC });
+    }
+
+During step 4, a vCPU that accesses a ``guest_mem`` offset being evicted
+blocks with a ``UFFD_PAGEFAULT_FLAG_RWP`` fault while the eviction is in
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


