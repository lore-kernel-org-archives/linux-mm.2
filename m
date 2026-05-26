Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD3E5CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7436B009D; Tue, 26 May 2026 09:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37F36B009F; Tue, 26 May 2026 09:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8D26B00A0; Tue, 26 May 2026 09:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BDEB6B009D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:06:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46BB1A0306
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:06:09 +0000 (UTC)
X-FDA: 84809594058.29.1A49D29
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf15.hostedemail.com (Postfix) with ESMTP id 498E4A0012
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:06:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y/Y76rwg";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="o KR8qVl";
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0RZWxLCSQpWS7L56BzIYMW5jz8tYKTKo3QaGhAIbGbc=;
	b=fTjKvV36YzlzavuWmh70QXbcAezN2GjSiiWNkOYEUtIjiR0pck9jLZIHea3sJGifkuTUbz
	jClyzs+IGdu7lvUo+ev9aEMbdoh4138d6Rc8n8l7dnY18u4iy2w7ws1RKOpgSL0C4IGy3s
	ZgUBpHwJHY07j4keYN6RdK++Ye8u9Oc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800767; a=rsa-sha256;
	cv=none;
	b=rq7+N4SWb5ozO4RZbCtMy+oViSjdRjz4YML80giZQsKN7OSob2eOyJflYRAMLluLPCGNwY
	Syk9577mzhaJ6I4cecHd3Q+P0IcLBo/lJvKKqV6wW5F2ld/P+6nk78bsQLWa0aEZV+a3LX
	jXUslnURj8szdfAsLVO5W8czdJxRGhY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y/Y76rwg";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="o KR8qVl";
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 214707A0194;
	Tue, 26 May 2026 09:06:06 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 26 May 2026 09:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779800765; x=1779887165; bh=0RZWxLCSQpWS7L56BzIYMW5jz8tYKTKo
	3QaGhAIbGbc=; b=Y/Y76rwg/t4CKGBLZ1HS4+UHInVKNp7EDicE4hVhEt44xpbU
	jTr3Y312l2aXv1Fl9t5NZUMtAy9NBOhkqw+zTw9HNKt8NTyKHu8Fz1akG80nDvjb
	g3dz9su5XvWFnGoz2WMUBovrEYfkGpjlkkh+B9UG25oYPwMzdLEHdwQnZRDr+rAv
	k+e5PqGtdwf3t0Fkt16FRuhLJK5AJJhRytPYPVbfdFptxqPoAfgyyDeRlG+diET0
	bn2teK4oUA/q1qeB6GkA0PTYbP+WJDtQDypBJrxWfGSe3gSHzzVDVx8qmpFcLudB
	jCcxu9sCYOjT/kWbcbxcX+v0GaMzO7xa4MZz/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779800765; x=
	1779887165; bh=0RZWxLCSQpWS7L56BzIYMW5jz8tYKTKo3QaGhAIbGbc=; b=o
	KR8qVl+ORE6L9OrV2AV/iEDxv7De7HOIBWHxQWWdOnvjacWY30r/NZqcwfXZeTGI
	oFecSbMUplpetewkg/bBXavoomobua74FcHCxERIEg1Yxv6T2mENCe0r41L7PPE7
	L+0i5fHmvSt6xkoUkVhBsM4rTzekeipAVy7ntmxzJtCuV7OlnZyBZa3xKl8zEpVZ
	NjXFngzrItIBkraxyUQ6gUmNG0H5FjSiIwYlZ8EuzbOdBTC4+bduBw/wjaFR6fCs
	kiByXDlERKymtrODdLHzq/+kGOTMybx63Q/Fv9/FARdEFWDy93xW+1CWM+YD7SGT
	92fZFpHbBqeowrpKGM6DQ==
X-ME-Sender: <xms:vZoVap7GIb_LC-BxR9cuFmaY73LaAM02to8Lc4nuvhgRle-Lqna2WQ>
    <xme:vZoVaq3MpaWFiHEo9LCNhpHZ5OgVlW_uVrrGJbr8XIKxLBaHfXJS6WTni1dDGJ2HS
    Spi3ZeNl1bZixgXwS5WUtz13J4_LbxCZS55TDxyKvOT4eX19yezov4>
X-ME-Received: <xmr:vZoVao_TtHsFgbJ8qzx74L-ji8xsGGNksB3q7jryf1tbYCR27RId2PxqB54vyw>
X-ME-Proxy-Cause: dmFkZTFRxKInQFecwZPuEt+LuNBlOJGP8RsxGpm588gQviVhNq1Pa+AqWD7JQeVUR2Swte
    eyzLZOEYFGJPBoftF7cmhN7hkCk3wRua/o4v8Bw72KaC1CFplNf1sAsIMRN76GRZVrrXJo
    4g3If4FQDoPgtrZ9saDLAexzQgvrfsTwQ3/KP0AGKCFmLiVvQMOmXCsts9ZOCGk1E95eOU
    mgzRkXibxyISOqgf2hZqBdgrV6ktnG5u3x8/zXY22S6cQZP9xSB0eE/pqpJrpVnOId2p4l
    G0binpu+ah/FFZH0esjGo/wTdPAqY9SKUVzl+zWcrHaZzSyBzEWlNRkrUo/n9HkffJzpL/
    kGIu5JwsORrZsXWIEDxPvEa3Kz8I/CYeERaY4tWVAozXgw/06ELyM1NrVd22X2GFXL95ix
    pkbXc2CH3newDMbYDBStBRG/83gjwiiEfxZpqIKWVfvqJ/KWg9paUA73/pxQ68Fh2uN7VS
    Eq75y4XBDPEHn6pe4+aoTb0iU3NiiO5jgFzcuC9CnqTwkHYka4MIPFhebWLzKy/6H58x5E
    GwDA1S1AoxCpvf6vdI2L63P7VKJjRCb3qX1d8SkS3dqct3ag9qXa/v037EQPaktPXFy3HE
    jXJt3UfMPxNGn5I4uZmiGYgNUfFZqfiXwYtNxMFT1qQxi33E0BO3XMV/0YmQ
X-ME-Proxy: <xmx:vZoVaruewJ2SpCEvp8v8y59EQthyTfNZDLMfwNQAF9COTWMlwkzJ1A>
    <xmx:vZoVakrqy4bQWKkXLU8drOraGKSVOVTDdbsA_n6Y61nt2NHqvs6Vrw>
    <xmx:vZoVamFP0sC0Jq4zQh5d0VTBABSq4QKdYRuZ98HNXqlLDZ2W2tyIzA>
    <xmx:vZoVan4YOqiKuW60Ampw0oO7JjKEUaX8VfZJXMeL3JWlWmJANcOVxw>
    <xmx:vZoVas4lsTBj2I7WpDZlDZMJTbozUwLH1_7S45QCNTtU9CtjZiQqG6AB>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:06:05 -0400 (EDT)
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 18/18] Documentation/userfaultfd: document RWP working set tracking
Date: Tue, 26 May 2026 14:05:06 +0100
Message-ID: <20260526130509.2748441-19-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 498E4A0012
X-Stat-Signature: m9f3p4qe14yxfq1gy9x8p1coxwb1kx7n
X-Rspamd-Server: rspam06
X-HE-Tag: 1779800767-443172
X-HE-Meta: U2FsdGVkX1/V8EOySaKrWmnyYrRwLd2cBEITxkM74G7fBHznTrvaN3We81NcGb2kO0Fxwzt64k4oGKDcnugxI8paDJRjC1xhhudS+bZqNVecZouiMhnOCjdXyWg6Dd5ZJT/B4ktktt7WF8nez7nK+x2eRi4CIBnBgifHUS6gjT5T9H8eZeFs6tALZ0zWl/UhFhLfpFKRO/GLJ1VN6UmDh59b7wrGSRSpu0aKwm8mErfBZg5r6BN3cNHdYNcbpCIxP4bq+782+XucseOnv8DpKvepj1v1pDR8IyE2sxQ7KP7XLC7gYlp2CKNK8b4435ie7kA7yjAEyz4UcWw+3NhUh2gSRqEhMpofWdN39aZ0TsTabDcNEqXlMbOtQyBpIvs4iqslmMIDEEol+xIWuBU1P5zvOnGFU4f9L7xWYx8/uk/xRRWKaBNNYfYAtqnMFt7Ht/Kq5zWrndW8dm19ii5+aI1Xz0TY5PM09Ai4WVeT8Hpidbo6zdDtOMjXsi3gJWYN+u407F8yIJkZmRX86+OJG2t8Qeq+S163odPnQU3JnJvjq4ithlXAs9rAm+bYMhu4cT05p7FkYp0C1G7TGi9O1k/XDXKmN0TMs8dR05wJ9Dy48TqRy1NmaD7YAvt9H8rZuhbjqbxF/phIyz+FKrGdzRAiL6frcQSyBNF4SjjZ2E+gGFX+M0c/nk8O+AMhmZa6L30yI2SE3Zgt1mJT5sTDKTlNVJWiM1I/pqDAfskAed5rY3z1w6zYP99x2aSwM+vU/0aDJiiRf6C370xON/7+k9O3OZhZO9bN1NI7NOUWUSIT4fNcjaNhvG+oMabWZp0DidiMgrLNp8uobWwoeafd/McDorVoQVj3hJ2cUY/5LtGUkGJ9B8tN+4W9BOLSUMfVGpQpHEXusjqZ5Sibjw1dINefp0dw+MHrf5JGHJcmc6wDMqi8Jpg2cov4perenfRUdSXY2Wwbi0eWNwerqMf
 0al4LzAG
 hvf/ECQx7wBVF4dBiLrQG+g2BhtxcOZNCyp1+cEswVrVGLLSzRhk8Zu+8fwRjrs7pUGtPQAkLy+xJ13cqCNOlSJbhexyGcUIwv/Kf9Q6zu5rljGmC0tM5viMa7uttYKIetz6+Vsvzux9g1mwgbnZz6vS1FmBrZM1qdtg5fQdeiMX9VSya0amgp950jzuzu1zVRcvkC7AYzylDbt7eT2ouEyrq1h+HPh28m9CLT9ekWvmexElDQYGrC6WG+qyPQwcNk1UZ8GtBpeFn1d8F/fJXPinCNL98vPmeQh3FYqPoX2u8nZsyD08coUHWd75Qs5liRUq38eRoF8k4YQnPvSw2wbDZCEUU5zfvumG1+xAr2RXQWF9Uriw81zQq8Sg28HNrZk0V5RuD74s+qRVDLbqT9zG/tl0NDAiwgDpYEVGa8l2W4xqYor/j0bRQHAj0jWA5hCTw/QzZVoO3x8FSliq121kld5ds3hcMHophnvGfdTxI9cmlhkCvsfrIihBHDKtHqgNgvjoEPhhKBU5ZtxM2fEYZm/Q7/YTWQ0aVH/xAk9wl8rPFvkSlLag8Q0kmoDtnicSWUMGIs12r6aKj+Ze1jcNht6O7wTzeTAsb6wE0MDhWGRU3uD2cnNLEkWWHOPFURnj11Nq+eLKRK/CWvq9tQbSB9JQSQVKl7VP5
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
 Documentation/admin-guide/mm/userfaultfd.rst | 238 ++++++++++++++++++-
 1 file changed, 232 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
index 1e533639fd50..1db99b5355f7 100644
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
@@ -307,6 +307,232 @@ transparent to the guest, we want that same address range to act as if it was
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
+eviction without re-registering. The toggle takes ``mmap_write_lock()``
+and calls ``vma_start_write()`` on each UFFD-armed VMA, draining
+in-flight per-VMA-locked faults before the new mode takes effect.
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
+         * access between the scan and any eviction step silently
+         * clears the uffd bit, so the scan would already disagree
+         * with the page state by the time eviction begins. Sync mode
+         * blocks vCPU accesses, freezing the cold snapshot for the
+         * rest of the iteration.
+         */
+        ioctl(uffd, UFFDIO_SET_MODE,
+              &(struct uffdio_set_mode){
+                  .disable = UFFD_FEATURE_RWP_ASYNC });
+
+        /* 3. Find cold pages (uffd bit still set) */
+        ioctl(pagemap_fd, PAGEMAP_SCAN, &(struct pm_scan_arg){
+            .category_mask = PAGE_IS_ACCESSED,
+            .category_inverted = PAGE_IS_ACCESSED,
+            .return_mask = PAGE_IS_ACCESSED,
+            ...
+        });
+
+        /* 4. Evict cold pages (vCPU faults block on guest_mem) */
+        for each cold range:
+            /* Read from io_mem -- bypasses RWP, no fault. */
+            pwrite(storage_fd, (char *)io_mem + cold_offset,
+                   len, cold_offset);
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


