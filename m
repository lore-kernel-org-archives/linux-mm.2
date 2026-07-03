Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA30FC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9792A6B0088; Fri,  3 Jul 2026 09:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900916B00E5; Fri,  3 Jul 2026 09:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756B46B00E7; Fri,  3 Jul 2026 09:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68FF96B0088
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFE401A011B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:57 +0000 (UTC)
X-FDA: 84947566074.21.AD414BD
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf24.hostedemail.com (Postfix) with ESMTP id CA849180013
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=ZadHbYK7;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="g Cc1iJq";
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085815;
	b=fl7keA/JKci8qZIR3vL5+VDy4tpw8O8EnZY9p2UuwAuHsOvuKdgIX0dtn86qm0qSymArJ4
	AzuLOXRm+sRASDuz7lVXA/BuTJYqYU0ndQq/UBg2/1QwJqvEl8loeYl5+H/G7AirH+J1tP
	Rac+i4AvwoQFUlcleVZbXuE11HyCZ3M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCFrzMqg51uEweo7qE/Vf7NHVXEc3DaIoqP0PFpFxNI=;
	b=vEdNYNaRx6GlZdeSyfw0RnYdqa+w48zETBvN/TYEWI29j9gvi5xx/ccB6Nx8bpMmv+6U0x
	/aHTO1N28xHNh8PFIry4M7FwGZhua7ub9+iNBNzYJilOj4KRAI+UyZXbr9giknLXykVtEo
	tKOT0a4lVdDuJx+zuVLhN76MvZMHVpQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=ZadHbYK7;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="g Cc1iJq";
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id A12631D00075;
	Fri,  3 Jul 2026 09:36:54 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 03 Jul 2026 09:36:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783085814; x=1783172214; bh=yCFrzMqg51uEweo7qE/Vf7NHVXEc3DaI
	oqP0PFpFxNI=; b=ZadHbYK7dOYSyLXnMYCOCKj6bMbZke8jrOv408Qhm4xs1dYS
	fG35zxPjAgMfL08RA/89Ytu7+bHGbuBIeaeItkEI/7t591EDicACs/HUI15hQI9J
	zI80tyJyVuuHjYb+zb/ghBbGaysIBaduMUkkRgLX6vWUfdX7eBcy5H6vrKdwAMIu
	sP4ZCiJH0NFkjBFVb4u5VOPMU8QbuelZtDhlOl+PYRPh8Owpqna7CY6n84Xd+p8b
	6vtNX0YdsYrbn3C2UPaIRrxbVlR28husu2nUYtKAmZ8g9ml8v8ngErG7Y2XOkQb2
	KeTU6t/wpxif9ivnJjfBG8aagEfcoihsviF0uQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783085814; x=
	1783172214; bh=yCFrzMqg51uEweo7qE/Vf7NHVXEc3DaIoqP0PFpFxNI=; b=g
	Cc1iJq6YA8bUeInOXFaPRXF/2uminJQAgeu2Eey4p6f1tvNLaT9G6vcTzAg+mFri
	atTnNe0KNuVQG3VaCC2pbbCPO2AiNlY+lKRDglnuX53+PkkVopCup/HIqPvmsvrh
	6ec66jySCl9fdzQEbCPuiW1K5jZUVsgWMvU2sgoZFdqKNuO4RRBOxWEGT72urxLR
	ZnMGnVzqHnVtIJhDcA5ksh5A98SpjHzxlatabP6XNL9z/KjVQnvOWHDzlr50Pj9e
	1qdORXc+S02J68560WoIi/QSnpPg23T8WMNOY7TVi2TkWML6s7yoJJJAvR/DKfS8
	gS/sde9G9LZs+GuIKG1PQ==
X-ME-Sender: <xms:9rpHaq-CmXiizI5zhorPYZmWXZD1YvOrjKwUae-Q-xy4SCfeLxbnpQ>
    <xme:9rpHamke18jy6ie1gjv-fYQwOYchGkbGlptnRtxjLju0jDV8yCFREc61nYgLlwVHy
    lqCKuTBbcxwcZf2vwwirqvpMO3dFOZffjKZm70sX2bxnU5P_FDlbw>
X-ME-Received: <xmr:9rpHao1ZklEQvdUERYcKUx3YQmpVTGrqSTOQBD-46VGhlQHFp0fyKdVje_qzDw>
X-ME-Proxy-Cause: dmFkZTF1+AtcFzjfXPBOkKcnuVuvEKWA51HaRP9bg4Pg6TSRWkw2MHE3+MEbJVMBeow/LM
    G0fikRttzVJzDKk6rANFKg424rq616qgOS/9yD5DKoV5dEBpH0UVw5qR7S6Dsd+tFle1cl
    xuwqoa20hLAx5TSmZkBbu5BqRWSSq2LwsJSfGKpcgimQ41klX/YFt9zMWoTEKqjLDdGEqk
    YAS7Sh3djm07z65afqgw6mRkP2PVAIusFaZ85XVnI6KRRQBmwxYFKmOravoaCbxfbr6lyg
    Tv6Zpys5DDsGMaV00Nb63KU6hP/F/fNB41j09tv/R6IOaTkqZwYciV6fTolkoahpFKveDW
    AoB65D7/PpZ2y8B8euclTJhwOeHAgAE10ebX+03goFVQJTBwMmAfATrs3h8hXLK5m7n5Nw
    qMyRtOFE2lu40kwGsasER5yxW6O5SdfJ9JKeWdh23xxEaU9v0pbuDLzpl6CdOW0QYaAgSi
    83ATbF2cNtX1mYvk/ok3x7ziR6jCgKq1uH6gGcCHtEF9g/+KKGQ5Mbn0yFQqPWf1kuloIh
    LdRrd5Y1q3+QavJptMuMCyK4eZeE9IZsLdu3IxZ220H8buxiUMfFOqyg9qZCZ9yg0QZvEJ
    Ixf8m5zHbb4Z/0FjBNQF4dfF4Yj0WigBdL7vUXpO0WnCRQOcfZuA27l6udeg
X-ME-Proxy: <xmx:9rpHarQhidrfRNjpoqfT1ejcRg25wSMmb7Ere2s6oYCXdQLlkQXa-Q>
    <xmx:9rpHaoMj5GlqjOS4e3qsBVM2GfoAzo-sOV8DkLfMC5ZZNcngnOe0bA>
    <xmx:9rpHavj2v7QGDEf3cj0ZtQ1ana6LCIlm4jWAiAk7rJ-2iQHIOGVXFA>
    <xmx:9rpHaoIm4YK_eGqL3wS3TdzAIHpZZCGu-lsB1o7vfADjLyhz7ic4SQ>
    <xmx:9rpHaosfPbNAZ9TmNHMURhf9S7LIS0_ZBaXooPqIWETxpUKu8ZAw54o5>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:53 -0400 (EDT)
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
Subject: [PATCH v8 15/15] Documentation/userfaultfd: document RWP working set tracking
Date: Fri,  3 Jul 2026 14:36:14 +0100
Message-ID: <20260703133615.1039465-16-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: zoai3sim1ojhpswx4kmh3kmdegtc7gp6
X-Rspamd-Queue-Id: CA849180013
X-HE-Tag: 1783085815-842055
X-HE-Meta: U2FsdGVkX1+pfeSlKKhAkdhv6RByZO3zRD1+OeY4P332zmMaKsz3eIGJ1b/jwWjK1gFRlzmbHRuucx7NKkdXv87autYaT6GtsBxRtT7voq0j+/stdUw8q6YU05+gDHPwriFvzNlJmbE1uatWvUNmqKgjs59fWivJYBlzyITerlJ6FbkIuhmawMk3fd0YACXlzYqgiDDwRPgRi3vSTx6Ol5oTbUOadAnXJb3sNq6SwMSi/PwehavxBKF342rMRrynfiK72jFmBbKXojjhrj5a5P0yxSQSs7K3I4pM6Cv2WOaRN1qhe0Q5CfgrlA3FL7/m5a/nsqR8WdX6Jd50sqVtVC3f3kndtZAFMMEcDTtWAj9+ecfMoXQyqlUHt1MsM3h1Xy7dhJfH4W0R7vYiO89mVuKLd4vD8eqF9xFdDBYTgmVGqjNuGft0hto6LZ3hie0dHG4m7hwAzhwxi4/C7bsoiImXYY4Oec8vJcTsqSg37A79fT6D8Nu3opLQoXRGhuMDJZ8pRk01UBaDJhq9QN6fYITJsRpTtBy0Fqq/e28qOR955gLINYJF0MKcAzxUdSomO4PqjrTT7bRbjl0uGGTybUqnOoTYd3cZZXBvqJ+FXrCVDlXpjfBt9p7T+bZTv4j4fETRGBKNfWoLuxo5jJ3pQNr5x5AqksxraYyCE1o4KM+EVK7UeKJHkF8FvWcIzyOBih9lYnk10HiXa7ihgtDYpkNTfa71Y2wk+xgk8daByeL5GyBuV7CYTzMhfqfCNmR1bPh/Ryccz2OjkdP5VU/hTHQjpBUHn0Y8X1rHMtnse1UMIiUk4LOrAE1ceMoytt0w+wKxWpGo5Ci3wvKzYfKLFR8HVyDZxChY5PILyqfDSAAnxuOUkHUeR9wnOMbhfJ8Ys90cdl4DtKeOE9R3hKzZDYdGp9YoXyi5Bhc9Xy9Aln6wvbec7VhIcgWzGDvBk3EoxDJvLQnPwqod+aPlsIN
 4yBFOsSN
 GmIwTvDfheodpznRD1iu1tz+SAsPoUfTZvFLKlxThd/mugVrsgHl+9OI+KVUsiiftqawPCKmjLmwcoR1kiJDSASRlwOzp8JtwPJ/qlwv+E0ut2LaDEz6T7jJpq6P9LByvC2ybN4NsSAIURQM27S0f2+JaypMFYVo9dSxjhwsqwkwDE2MVmQ16tf6XihjYpdSd+MHG526VeRB455QByca2jW8cXeOX9ZPnEHlmi/D8s1jXTZP/SjRhxkQOkBWQPAy482XQRyZWnLN9VBsf2bU71czrx0J8nJZV5p5pXdIwBXjky7jdF31B14aTSdlBTy9BtGavrBbU+s3gR/SeO6TJ0+y751d+u1/gaKAmjfDbV0UhsaobfC2b5k4bw2X9CStR4sPnklhhInN1D2GhYSP/SRVvgEbxoDotwwthR5mmmBuGcm4cx+FXWLYO+xDDcWsla6MrDZfN8YiqXKO6btjw/X5jg/IPo+CXFHDzH4iLI72hMx8=
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
index 1e533639fd50..69836e39aa0b 100644
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
+leaves the userfaultfd context uninitialized; the bitmask returned in
+``uffdio_api.features`` then advertises the features the kernel does
+support. The recommended probe sequence is therefore to open a
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


