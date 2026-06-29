Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7163BC43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268AC6B00A4; Mon, 29 Jun 2026 08:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240736B00A5; Mon, 29 Jun 2026 08:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E23E6B00A6; Mon, 29 Jun 2026 08:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9E0E6B00A4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:08:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40D641C3710
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:22 +0000 (UTC)
X-FDA: 84932827644.25.500A37F
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf15.hostedemail.com (Postfix) with ESMTP id 38C21A000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=LulCwlLr;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="f 9PGnMk";
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782734900;
	b=3ttO8WMXxbES+PtuQFexcor/uBAE5HvEtFgN6TgvvN6Q8TIcY0zCpnTm8ECJgykFfwTJcu
	jm7WBF7xUUMM7j7so84eFwFp7xd2JkfRCL/RRZNpXoL73tiA8o/pLj1eUFtypGRUckHsUI
	H8ePz6Kqhd2SSIYN5gYz5DVZfvj58SM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782734900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCFrzMqg51uEweo7qE/Vf7NHVXEc3DaIoqP0PFpFxNI=;
	b=vxxQSMth6wzAMD13wLRhKRkN1wp/tLZWs3dZTz10Pvdvh0yMTERDnKGovs4tk7xopo+yiG
	2wrGwUIcGAWkBNuDQXhYRGvHxVvGZkpZ2GYzeYpIa7mZbKm3AXjYahZnycxCJSyRJH9ozv
	q3xIrrXG33/oLpfHSa6oz6ZkzGaECJg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=LulCwlLr;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="f 9PGnMk";
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C59B114000AE;
	Mon, 29 Jun 2026 08:08:19 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 29 Jun 2026 08:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1782734899; x=1782821299; bh=yCFrzMqg51uEweo7qE/Vf7NHVXEc3DaI
	oqP0PFpFxNI=; b=LulCwlLrp0i5DwUfaVngU3Junj0hbmj/esA8gmgH0s+1f8/T
	9lTXDfVdm7tivJ8imZI9kGvPYriTbiAuPjM7aQ1uhLvgKslKipwLZNlSGrFGslBP
	MDVQ7vkGr0fuWuf0klis+EHSiNOXixlq4do8VwyXbDlxyD01pic4t+QIUreow0Km
	TZ6TZPMjFMosDd/l+980+RBIzdY0OS/9cogXQycYgLCEJrgK7ybvZpDIpNWMNBJt
	40c3IcgnPLa8q5GL+mZzUiErIw9NOCxiN0JH2GBv2pHGGkZtSgBWxOWpaWXYkrXn
	T05/z8bE93geG9mKN1Y7Fa0QT4hN3anGOsSJKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782734899; x=
	1782821299; bh=yCFrzMqg51uEweo7qE/Vf7NHVXEc3DaIoqP0PFpFxNI=; b=f
	9PGnMknecthM/xH6R6zSaUxtJIU+j5fThXYpF5MpL31xSVQXjf4ErE4+q9+O4Ibp
	KvmzMHtQcUEmnIgKKV8UFPpsoNESYAwtjiu9MsLubXJGI00SWaT3D8hMVCMyU3b8
	gPLqqmVDilx4g/ocAiMdOYPLEuhpaGHAryqiYDaN/mAo6mWzkjhkAkOIepSpUie1
	dNbFJgFPkkuB6z7TVvXS/EsEAsY9UZzihmGABEjJ7aJ0LFe0MqsSh/4c8Ve/LauE
	KHBO8j2S8aUdGFCxNVWSJ6Kgp+gCUYXOBYHxBdR3+StILwRSNSTkw9onTEEbp4T6
	mMi0IDerW51yROD9rNEwA==
X-ME-Sender: <xms:M2BCanufdcIm6SoJMGwENmf_6sN6Rs1h2HYi9B6XOpP7bltWjnLfSA>
    <xme:M2BCasaw6_alwf7HstkH68M3AAIw0wZqhFNLN9FKfV5UX2rlvyNMAnwf-aTdX3A0x
    pxS7twBbHfSuJwznY7Z7Lu34ZdMH4wM9FZrcysdRYKS28XzeHNqtw4>
X-ME-Received: <xmr:M2BCajRocdZYZN8KdmgzYRVbpiPydoK1NiS-6FDoCM3WVkC3X8aU4W5DcpmLjw>
X-ME-Proxy-Cause: dmFkZTEbeJVw6LHQweWhVxV6YsjHAMw/x6M6i2UioCpAmsrJGMnjm7JCfk5Nb4aoCqvKnN
    91tRPzQkxIdfhn03N0ZpwuVqidXzNPJfeGWLvbpIh0Vb/OxkWky2JSYOHrAYJQLLSAB7AL
    toy2cpnq5TVKX0zNbh0LHZsT2sTwF0477WE69g5lswYPot14j81Ea+hOFPxysMYC/MWVnR
    3Dzoy9inuC75prIkon2ncihK+vG72WjpEkuux2GDIB97l3OQISzMRmmuo/8ZARgSjSwpQ+
    UM6vUvaQCbvfx0vplMOYjWf6ufp0BqVYgaIkGB0rpNNA+DKzK1TUU+7BMGyDUwBoGP6vPR
    n1rc6DtkgBAvysbSQ3E2eTULm3Fc1KACLScvgdGMFwMuBeAK4pVUlEgldp7c8FURq4EA8c
    SK7chA+9eNFKioMNs1mFZAU+LE1Mq18j/tBgFyJA3AmEPItCj14yzvuD1FbShZUWh9y1iB
    OsUGnSTGZjKOKDKtntwuZ7TJLrmKXgCcX2Cw1O4p+sjIknja/yaRjKCB7ZQUOO7FxzU1ca
    jWFcv6SX+GMXKP9d6B9JxyFiy+9jlP+3t8TS8AJzW+/E9e6QSgZib+68fuez2xXuLdlv7L
    8Fsce8Ucr63jn6XQVKa+KDc/ojbOkxsSaF9cfIqbAbd72gDrn3kJnAHxYFeg
X-ME-Proxy: <xmx:M2BCavwmtMv-NKDijDInXlo4FzkJhI0mMDzlSrhZBzSgxYcZVUF7dA>
    <xmx:M2BCavdT091fJV0iPDO7YCE6qvlTjKW32XDO8IcPpVKJngVjG2TeJQ>
    <xmx:M2BCagq8Z-kfwDS2zleW3UaK8xTCJTeav7yifIkiorqekWJSrBTrPw>
    <xmx:M2BCanMyRemIQUWhprOItnyerfOlbRbIUt2DqNmh-irh5B0baxrD-A>
    <xmx:M2BCaurZiiEAwZVNyc7bWxTWuei9Ry_iZY79DHMFo3DjZCr6LTIlCylF>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jun 2026 08:08:19 -0400 (EDT)
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
Subject: [PATCH v7 15/15] Documentation/userfaultfd: document RWP working set tracking
Date: Mon, 29 Jun 2026 13:07:46 +0100
Message-ID: <20260629120749.566063-16-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629120749.566063-1-kirill@shutemov.name>
References: <20260629120749.566063-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 38C21A000E
X-Stat-Signature: q9ora3ikxh3ircxnzzdjnynimsaqt4ix
X-HE-Tag: 1782734900-655541
X-HE-Meta: U2FsdGVkX1/oHzp8ZRe/2ZB0qdYjD2+a9pdZdZYTSMbdeLMx+yWPhIpk1lTKjrKZ8FHerj0tcoAFggPHJGdMJiIWupElc0o2G6ikkizC2jciguK8R+B3XXJ+PRreW1hEhROJONSByeWwbeqVWBlpSftBdPQL0uNlHDBEN1W/Yze3Zk65HWDf+VltGHSw9Rxm6V5HU7EfS89Q/h5pqB3U0BvrGaMKWPRzbGOox93sBY0kofpq9mBhbHYPANsMqznkjilVDHu4U3Z5Oqz1pRjbetFISOX6gzOM6M2bG9cgUrbniW233OIMllWX1i4X4iI9ZjVPBJDqVk2KcQbRi8v9VpMp3lC58KF/G9g3a8uWlDdeH02nXA8dWPpdY4GTAB/iB4T/yRl/8yABYKOhZbr0hW6ErAv6ZZSA1nf5XL8UKLpG+pg3VhDnBPuDWIxn6T9x2x/jQfYXflE9o35z+CFSnD6hCq6bvjQ+R6vyGWQNLmwldOhRIHyyzZ7dlgEf5pj0xk8nMjgXMxzHFyJ5mxIqD704BI8MovQUcLh1R6Qtpio7/N8vJNN2K6Pl3m4SAZOTXMhLKn5f2l/MzvJSQH/nZhKlFPzRyb+D+zLYTPtee7fNJK4/IEDyO+SglJQZfWFtxFdrpeIHe9aKrYNKEcxvZL/fRQ4/+B/7b/QbFFTD9zwrtS7IPqrvC0lnisEJttjkJixE5lDV+h97Mvwspb4nC+cTueWng7vkI5lmOcLXPTAfsz/cywm02OmSNNrTzW+ntM8s5TrMMOgxBguQdHR2W4pHHuCoTa213YpVzEuSpKEJViyaJvuWTqfrdzo57FKwe07n42/UsSsrpSZ0ywsitSxFYTw5T7gz/lCswoiLhxXbgUFfo1086i9psAdQ2GuHcXpujnyqQWukpTiwKQ3n4q4TXCoEXnb+PgQHC2/vvRwelCEvce854kIa5ANXFhIQATNAUqjRHyCvLzhGUvH
 bUsWWlnZ
 6wATWWew+NgBJ52Ev2zvPV/K65F866jt99eXm55MnlqsJc9s7okK2xE8I9d4oJXqISD1kygMs3Ch+QaaLRXUo3qMAW2Ppoz3u3/cFXZ7VX1DU5tfvxGNxzTERC0LqMTIH2r+3WZqZhk7TKJIKtYL2abAu3/Z3f379iJC0i+sFqOrb1ikNeh9Q12VqQs+g23zRTQ2+afiGzWnPjBIu+jAmtHglYo6XifcyB/qZ1+nsUG8+kesk1TqoxI+agQ8Re3DS9bHgytBFlmafLDX0en2HCK2Bv4T2ZMKjZzHaGCxOii7zFbkCmHAYT1Mbx52269SSqVWCkbVJtREMvFG7+ZBrOx0B+pLrH/EbJ9curQnnOd0JwIK9xXdPYX/jZM+a+1HIG7CNph5IT7njtEy/+eli9i0ApnQken+GdAKl+q7mTs+qqQlBZhbnlub9zxaCri8QzQcUznK9L5/R8P6o21XXMvfgD39wPA7r0ulT5sUSyWzRbNA=
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


