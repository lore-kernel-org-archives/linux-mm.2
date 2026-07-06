Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A401C44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D288C6B011D; Mon,  6 Jul 2026 04:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA0D6B011F; Mon,  6 Jul 2026 04:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE806B0120; Mon,  6 Jul 2026 04:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83A5B6B011D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C49712034E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:48 +0000 (UTC)
X-FDA: 84957726336.25.12D5B7F
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1A29D14000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=BF+QbfWh;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Z 4h+QFp";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c75Xoz9iShdlcCBWN7mUU9pkULk42wEnMxyb0Cb35ug=;
	b=jLZR+fBI0LoTxmspcKigF1x9iTOIW8KFY3uqj+PqAVQJOGNqKbEd8owTV39YN+ScU/am1h
	3vikkLumiN92szT+/1tB2ySPKNDJi07ut+YT7hIzhjpty4SA/Lcat9MDTN4apl3Th8zf9B
	QnrVYt4MM5LyU8/39ZsVOA6hhlqTmzI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327726;
	b=R/Qs9CED7iylEvJanxvnRcTIW3ZH1yELFjm5IspS+squI5FXJekWPBVK91r4So2z3u9n96
	hlXb5OIbrbdG5ZhvqOUhJpaKrGD/SHl7qBBEdz+Z79tK3+pCERK+fgau3V8K40aZZrlN8r
	EjV8pv6BCj2jh0iqfqMQun/k6SRid14=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=BF+QbfWh;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Z 4h+QFp";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id F196B1D00112;
	Mon,  6 Jul 2026 04:48:44 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 06 Jul 2026 04:48:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783327724; x=1783414124; bh=c75Xoz9iShdlcCBWN7mUU9pkULk42wEn
	Mxyb0Cb35ug=; b=BF+QbfWhsU9NCVABGnDCmQXMg5om27R9YKBsQCductEOKROY
	xQHGc/kJWcjMKgXBjLnQbDVBjrw5J9Ww7VbDTOm57Ee2DllACvTsbcbpl48i6cYM
	YBW1t1jvtRS4QejlyRWcuW7aUp5chSl/b7NLFU2WKrlWeB13jsk05ofVDsvIS9ma
	CQKHLNfpYIaTJqHMprS7xjAofKqNsOdrKHpIAwn/BD/g55iggM2R/WJJavMw5zN4
	BnsCcnr2D0h4spA7kY4QtZxQMbn9yp6nr3EE6pgfU3P1ewgxmSnrw2OVluDlXN4K
	hy4RmFY5BVozPCMNxcvehJBDkCmdEBSBNrWmfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783327724; x=
	1783414124; bh=c75Xoz9iShdlcCBWN7mUU9pkULk42wEnMxyb0Cb35ug=; b=Z
	4h+QFpsPZDm2IoI5Af011sJ2bDXgZgrJN8MRZgFrsjagycKcwbH7ayQ/Tw+jOvZo
	PEUQGMSSw5st38KgW9VcswQuYwyQSoMOYdrd0Hiw/QWqsSuGFw/Xt09WyG+1DnaA
	zkyd5ZyEroHboJhsOdr7KfgEJvNemrOs/CyD6fk8UDNMVoniGh0faK57dakqSzzs
	e9iwWEqh3zh45qNqYwydHlab8SFhXStaZn/QKh7PPMl1GeQjVv3Y0oaYgEWihiDE
	BoMpp/TI9EYoqxE5TNhJzmGtnqSbriUr2v10tl0lCggnI/k/VCSksOyMFOQmMx8E
	h4QB+tE+GsvamynS/tcWA==
X-ME-Sender: <xms:7GtLahARLw18RBvPqCEJ1jGJFaHScca6VB8nvGwI3triOp8GwvRnfA>
    <xme:7GtLajfrSE82KmEER81iFaZJbm2LsC1eVxjjmropLUdK3bKZ-kfKAfAAZdx8uOUhZ
    G4PklUpE_VbYje1GvIXdm631hWl4EKgxCcEIkC9Jv_C51EPCnNQ7jQ>
X-ME-Received: <xmr:7GtLalHQ0BY7AzbX1SjRMkWgTG8zzJyiMdroN2nXfUTrDk5uN-v_qQrcnViJ6Q>
X-ME-Proxy-Cause: dmFkZTE1HAxrDWJcKyWNBJ73THul+Pni1RTBd9xrf0khQ62auo02SuQ5gbJLxkQ3Qk71Rt
    f+PGPpiBaizNM2SZ8IrfQsHK3gYtMHoaCLmDTUWsgKKZPvRJtANNe6dp0pRFbSzpZ7Ir68
    3/In0zA3QiBz7VSIJWGJB30Gj5LF7PccEnLnCBfRMAcd0Ruq/WMP2imG8KXscpScOVRs3e
    Q/wFiWTRlZPXmNZzwwnPakhtvrKLPp/eIv/XhxcMzd3pTWLxn9+uixyv/f65anc6A7PACd
    VPXopYse7MIZNJLH0eIKl8RFUktrN1v664xHjciMcFFYVrJqWrPU6fblfiG0/eGu1JYQML
    7hCtP310TGhNxid4C7axosc3nn3goCWe2O5vBZ6WRqZEy3lzfLJ9LbOWFNDZldL4VG2wQL
    CmMOdyy78HSgJ0HEfKKAzKzXVKlfLcdg3NDrgDZsUjQNO0NDCrkoHu+qwPJjUnEOJFYW3z
    e6nlczEqq6BtDreIlBH3iIzPP/hs6oNAX9M/XuQUkAyD8k6paShF49KLzUMzHQmVF5PdKR
    EL3ixFNa/rYCZbCWlnl28NptYmgcVsHtstYBs9+7oNLLe8xyuhw7aIRoxQbSlSyWRA7IOq
    SNbNze6+7LnULG5E9Di08w7nesW+vPmRugrbftqQXp9qNIgkGjyybM6NEoCQ
X-ME-Proxy: <xmx:7GtLalWJmQzexleRki-dJg8CMhbUBSkuNvt6E-3e7Twv5nGdkG6DSA>
    <xmx:7GtLatwp5m3mz9ztFDqajYQFUsqdsq9lmVgZaJa34_R6874XWy5Khg>
    <xmx:7GtLaouMtPIWs2vG5qsVMjIvz1ERqo8hEkmcPo_0-J2_HLmAcICOnQ>
    <xmx:7GtLamDfOfc4QJrVKGyXa_t1TZ7Fu80vxm_Q43SfpsPR0IL5vcAEuA>
    <xmx:7GtLarACI6a3Y_3irNWh-mOgpE8VGHPnoT2HGey2LtVNQL9mRu9z2dOy>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:44 -0400 (EDT)
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
Subject: [PATCH v9 15/15] Documentation/userfaultfd: document RWP working set tracking
Date: Mon,  6 Jul 2026 09:48:04 +0100
Message-ID: <20260706084805.8400-16-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1A29D14000C
X-Stat-Signature: ft8cq9aoefq6nmecicrckkjrmzjwu84e
X-HE-Tag: 1783327725-827900
X-HE-Meta: U2FsdGVkX1/FbqLpcFk5LoB0uk18tqpdMfHTy5OvtpOXQCuQjDxfRyAftA6BdAYfYM1xV6NsjJ27In++Brs7IW3C5cR26ZzArGdPlWUBgGmIWDDX5yRo7zM7qshwVsAtvMdoj/gYRg85T9V9Tht9wMknSscvWnNafe3IhX+5wVjJGuPllubWEOtMi4HXdG5r9CEaQSPQAe5h8xu10YdaPHnPVukso1zQp1CWk6xbycVsMsUAjEnAPxngjAj6ujuvh9AJ9Xr46XAOPwwGQ7IOf2UYnkY9mLLTmrtuGy7XxGxdE5zLy+66icElE9348YBQJ1mEIhrXeb8LaA35UxdjiroF7MGTq8H7yrnQTi6WMIv6vVaeQGxcFlA3dMmsIq1SLQ7d6aX6pCvGIky3aHat0mtdWoPiWtyfj44xFVbhLg9QGjhwkltb6NTXFHUjG5xuBsxBU5ATIA09KIcREHLG4wtxGrc1fDhOHRWxqWEO1lp5g2PPUYs3HT9ZWNhNrXG6fKAc9jBB6a/5QqWI5zd/V7V9BJUd4j/FXNUht39Z24L3VI6FW6HlxMVnrpw1X7WAKYTDDnRaOVft6AyiiR6cKofDCyXoMXjAyLatPE1NVeazPke9dg2NaKyuz7R85od1hVaKp0J064uiiL+tMlNPtyNTmsD7jerx9wgHyy0s2uNeVUIJTX+AZP3uz6JNPtVvoZ7GquXAzt4ZYgCwoh2c/7BKCHrr/Lkmiby7SvtKRApe6oWoGhQB4Wzs+9hSo17DS0e88PW25wxuL25c3br4QA+Z6fxL6c94A2l+ay7i0BvdbF6N0rh6E4ObIItMB30k2LmIEDUlYSZDiSR+9rrbxf9J/v5vvhA5/AmIX3NrLQ+p3Wdio0XMMnwH+7xxnzHbZETM5iBwDfAwqEpXeR5pvxNC92dbsqCSOA0jD8JrY31ZjnUx1+uHLQoagyvJn3LaAgLugErk2ZxcKrZSME7
 WBPAwlep
 3ZzAaV9PU7TKXs7eceRw8EUdpoh9/F4G1i7VjVX00hYxz1HIcBQ08I2cM1YFVlqJ2/AHAEgl6KyeqVGRPDoKXyTMUoYL+qozRcL3DsS0huPgNyJXBTnliFZUaaea+FKEuJSRk35kNVDSBTmyu3GuM6cLBUZszEdBvN8FsydBiNRBvO1BI96JEC/FMh6eLFG12nzgtALCy+COIu+0k9IJqOn2+c9pjF8trpvptx6y/pLTnAr6DlF10XKAbCSCGQpt1lAjkwPApVpTZMjl+/vyiqiLZJ3B07Kz64pjHzxz4wKAbHMdFoVWH9Oc+OYPF25uuUJM/83WpZiCP0SZT2abdQY4rIdZ3GFHZOMBtIrLNAvSu5fKRUKANQQSvYRp3T0W4kvwPlvcOaTHU8YAoZCmotd1zFAH77UgbtwZrq2Fs8FloUdMyrbu0TfeE3w1+3ZYRWqMil7HfaV5bk1yxGKprOFRo+s7V5XmRniU1FWJTUmTwv40ApmfhZ7bMt8tHEIt6Ua8ytu9HvJsfvke25Bh59vA7Fr1cHh38ts8uC+Pr16C3YtqmWxLhGRkHhA==
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


