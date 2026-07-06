Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947BBC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622846B00D4; Mon,  6 Jul 2026 04:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9FA6B00F4; Mon,  6 Jul 2026 04:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514E26B00FA; Mon,  6 Jul 2026 04:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB066B00D4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B596A0334
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:10 +0000 (UTC)
X-FDA: 84957724740.14.AC539CB
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9AEDB20007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="a OFqp5B";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=WS+4WjKl;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qVEVjN5R6x87tuu84TW3KSSD/J6nesBQ6E5fheRp1Pw=;
	b=I6vN8oQx/Dyz51ovrOmwxu03HKhWl50kkQEWBieWDemT5nSe+vuvMMJqvB8ZwCyZ7yGsmb
	RRX6DJo7DB8W7qbdegR59yRRNc1lMhwV0rLwOK/XDayjXyluZ4K6TXAvGcz0RyioP6TCO9
	VpjY9CdeLJ4LSbDTelpc1KFJdcBedWQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="a OFqp5B";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=WS+4WjKl;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327688;
	b=x6MHxfjQWUlgnK6vRHWRl8HG8vPDVfke3vlgw37qWilWzWZV0FfevYLwfyaAowfUj8xpiR
	6geqOFfQ7dCelbbM4Dex74QGVsbzzOBZq5OakoXrrTIHn3qcu+t7ZeFp0k6lURNAkIeoM4
	XGLqSVtyrd/QVQuWwDzJ4hEcFe+qSyU=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3E7037A00E6;
	Mon,  6 Jul 2026 04:48:07 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 06 Jul 2026 04:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:message-id:mime-version
	:reply-to:subject:subject:to:to; s=fm3; t=1783327687; x=
	1783414087; bh=qVEVjN5R6x87tuu84TW3KSSD/J6nesBQ6E5fheRp1Pw=; b=a
	OFqp5BjaYRMd+pwqINsvN6TrL9tozFkdqB2APTVzrv4dW+VBwQn+8ALXR0eLtqoI
	uJA6CowC+TtmMQao1vhHaxtgclGQtIfRYBar8JPQcaDectUEqH6MiEXgeCJO0ZVV
	7c/zGz+EKmc7JSFZokY8Fw1wWxf+EIu8iGj0EeOqMj2lGsGtpFiET7UlOneybgNc
	LHYG85dqLlDvcitVkfnUN/3HAnpYA0pA2dbSpsbyjxpI4KpwYFGtqWy9OHZG5yiy
	bqOhDWl7eNalKjE/krAPpR75EyoNXSzMPiQn2FGSkHlxay5WHY28SBtwJxJpAHxc
	EDWSm9Lu6WYzUYvhZamcQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1783327687; x=1783414087; bh=qVEVjN5R6x87tuu84TW3KSSD/J6n
	esBQ6E5fheRp1Pw=; b=WS+4WjKloST6KW7xg7qztPB6ZkkOESa0ta4H/xQG3iQf
	17bq3eETBaJ1uJDcvXjN2ulc8/zhYRjMK4POFTpBz+9f0vHBwU1HZJ8I6BvDC9L2
	MFNAEoxMvle+itMNC+FM0KN7BjUgEJxVf1xSzgN7UjwvbQDVzGsvOByayXjXNLN8
	BP3/hn/Z40QKgclkQCCazixsDedsT5A0+kkuOBKQ3yyPKBSUmKdxU4Qte32H++Qs
	o2g0Ys5RoKamdfxwfx9WIDezjHl9iUGqPljB4mpy1ZoAReXIfp+hC0N7pZOJ+Da+
	PtnE7QeUcrquibTKst5+1UJWfMxLuIw857W/o8Xauw==
X-ME-Sender: <xms:xmtLam7NZl9bvH5q1Lm6n2CluGZyTHlPguD7ls4xWIQiaV7Z5CPD5A>
    <xme:xmtLaj2T6I4lfU450rIILiorcmpwn2pVj3Lr6MMUCozhft7mD-PKYJpwRo_bW_FTe
    su2ruP_3SZn2_y9QYV5dEr75vcUurEPwV_P7Gl0OGpa1tDEufShr0s>
X-ME-Received: <xmr:xmtLat--SLibq4avysBGgpKf2a5IM15Me6BxDCUqnZkN4ypg3PAaHhuEUiV4HQ>
X-ME-Proxy-Cause: dmFkZTEiWKmzgS4DmSJX9/KH6JTtcEz+rh9LhMhy3LsOii9iVKIKp2P2I0vdlfT7CGZ124
    aI6i9MET1EkyhEuwneLp8VAIaqnTbF93R8NI26AaRBpO1lzP4oGhu0+EYDCQVYRQn4HDOZ
    N+yvBKaYg5wasRIkLq0zIQQ7vUMLjcQLA8z/crlz9UOAGCjvTeFjBAsmVe650eGr2O0b/r
    mxXg3lJNk4zt1Ydj5Ve9/+8DJOh83cNaN/vFvTbCrzoDA3swkhm+XOb+4mqo0cvbFV43gs
    NhwCAP+3kVG72QfRXwZ+35ARfE/BDR6cMVR/B6clrvAn0pb5uFdrQtrmjs466/7YtTt8Gz
    82KFoOC0FbeeHbIAxfScKLhQXIFDv4Wz09KhJxK26H35OKWTvNI8ucYhgmcsjlsS3H6ImA
    KZG7SAoyO99pPr92ijE43Fsob9rml9DXQV1AKgSKUCU6S5r5NVnbGkJ6bCLJcamOnLNKvi
    meGoQhPv7pFJeU9ARvG9GlNtK9YOpK1db3GeT6ecT/YTuOm2Bxx4jAl1ZO//bF+ghlEUe8
    TASi40MlOuKaC9u9GxWlkAb9KhN/QSEV63uOVnI6ctPotCaQiCWX4PxiOUvxgOuHjNhLuk
    jBrVxh0qLvfoFezmOHI2omn+hrrG2lW2kO8nmjqHroeM983XmzkGgEvNLNqA
X-ME-Proxy: <xmx:xmtLasuv5ZvqiMDPKjIt7eHTpz2lmC_C6JvrzKkDPcwP0jjKgTHiSQ>
    <xmx:xmtLahqOqKQzx7Ny-VqwZnVmnwdQBrTAjeVc6vZmw0TzvwBtKfTRYA>
    <xmx:xmtLavHusBZg-_9OoWjJRMeSWVKQYDvFFRbjZy_6tXFveZjNqZMREg>
    <xmx:xmtLas5oHzSbbN9jVisv6zq7FGGd4-8JGh1MZCDbSdGxPi_YvbEUsQ>
    <xmx:x2tLah7meBzl7Eo_LinixjjEJ35QYCXu08Jg_6Ap1QqxNQYEnVjZpdDY>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:05 -0400 (EDT)
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
Subject: [PATCH v9 00/15] userfaultfd: working set tracking for VM guest memory
Date: Mon,  6 Jul 2026 09:47:49 +0100
Message-ID: <20260706084805.8400-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9AEDB20007
X-Stat-Signature: bdi1dx8mge1913mu7j81ya3s8dws63gc
X-Rspam-User: 
X-HE-Tag: 1783327688-895600
X-HE-Meta: U2FsdGVkX18/3/IBWMjektTMNN/6u15Va5H94hcb2DhSEBSt5Wu2GVXUH00azgjQua7rgarwKpv3w5kgY31bPITzseknNpsGigdN3Yrw2DDH7KwVxQAt6LBJUOoLOq6AEPXvyCGqlkEsvDNoJuunFONKXwQYFnR6qy0agBg1wxmJ+RBGG6DsGXAlu6GaomgKzGc23QjXB5ZwC/8eO1no9bS8lTovKNo00F5jZXpmeO5+epuJaIVlSQ3pkNxhzplkkxzfecOs3Ob2FIth6NGCN5J5HBPXazOacvvk4gwCPifsPFErTa2rpczzDn4vE6k17KeJ/9SbvyPDj4tEXZV3w5gwVdShtChqbqLV7MjVHpZD0gB5GYrUoHDcoy/utp7RaeKvWlo9LfPZd7i++6GsOM2RmS1bwQGoIG/Toulr8sD6qnd7BL4YFaTTcAV4LBsvBTf6Nj0MaoGfsWVjj64tMW5IIktCwN2e5xPHIUaYdfH2MZsJMqfWot1pTUWuw5DQmp8Z7dfxerFOoZZ0gNiPB7NLQbdUXwgdnl3lxmLMvBZF1bpt5iSVHiIb5ZLoCDCh9vID1dFdAvx8gxyKiyd8pmLIp1gUgkDrDr0HkpuK6e+9b4FYTCopzr66o13xzfLZxKk0pmE42Fnf4R4u133RY/Mi6Cz7NOmQgKsJTeG0oJ4HtZvMKEYkT8h4SBbChq2YgUHbZNYu2r1OogCsbkbRaEAnfDsWrzfosHbn9wVFcl6i5SM4kJaImf792ZSjUT5vHUtpur94BGusRizcPSC/cEYTh69ox312DZPHubtg0GeP2gTvCD5qTNZ5JpEknmgSXPduXLaZ3dSPl31RCWwxwiuJV017vrmz5XzPzsLh35HlQpWojlh7Ca8pS4s8yiJaYOr/fMX5/9oYW4qEOJuGqg5o39RCzztTU8uVGZnYOlF+yInGpfOBmJNR9IX1Q77ph8DsTuMz1rakXHRLtMJ
 esbIX7Av
 JjQW9rdjvFzVTAR3nyICVJzvWfJSGGbgygKl5ishQJHPkDTns4KAdKWlx/U5cvDk8Ga3x4VI8L3+Xr1CEaSy2miFw94j/EuS8r9ZJiDzKgKpedTBnWasYL1dmUN7YkvqciOxlPTkZs63L+ZvTbOZBLI2yjBORpkmSTUWq07Cnys+KjeLr2HRw/BhnXH3BMBIAjVpYABLi3Vo6rz9sCfjD3OTDu7iQVgoDm4hv74u8Es7GvS1Zcsxe5duE3PTuMMVAaXsZC4a/TSY1Ik1uesvS+OMs62NerAcywJV8fq+SppTHtMwmKjQaqAN/TXRE1OpbvHPqj/e/BmwrfX08wjUNyhiedibA/m2ePdviLvi90xXNbAQebkILdFvkUmbACDi48WdAV+Y90yMQLtGBWFCKcbIN+dOkmhzpj8XVICKAApNWeRkNRIOkbvM0Z43XhzUoxq3+FUTh8ZmvA8Q8w9C3ftSV7NAeP/ZaohfToiEKiwir5fBdftpZ+a2iLvSTc/WMkm5i5nIs19Yu2IVZJCX2NYHY8vcawfruoAse
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

This series adds userfaultfd support for tracking the working set of
VM guest memory, so a VMM can identify hot pages and reclaim cold ones
to tiered or remote storage.

v1: https://lore.kernel.org/all/20260427114607.4068647-1-kas@kernel.org/
v2: https://lore.kernel.org/all/cover.1778254670.git.kas@kernel.org/
v3: https://lore.kernel.org/all/20260522133857.552279-1-kirill@shutemov.name/
v4: https://lore.kernel.org/all/20260525113737.1942478-1-kas@kernel.org/
v5: https://lore.kernel.org/all/20260526130509.2748441-1-kirill@shutemov.name/
v6: https://lore.kernel.org/all/20260529172716.357179-1-kas@kernel.org/
v7: https://lore.kernel.org/all/20260629120749.566063-1-kirill@shutemov.name/
v8: https://lore.kernel.org/all/20260703133615.1039465-1-kirill@shutemov.name/

== Changes since v8 ==

Addresses the Sashiko AI review of v8; triage summary and interdiff
were posted in the v8 thread:
https://lore.kernel.org/all/akfmUXjqaBQnxqYX@thinkstation/

  - 05/15: disable fault-around on VM_UFFD_RWP VMAs. Pre-faulted
    neighbours are indistinguishable from accessed pages in
    PAGEMAP_SCAN (PAGE_IS_ACCESSED) and pollute the tracked working
    set; each page must be populated by its own fault. Also group the
    WP/RWP flags in uffd_disable_fault_around() and
    uffd_disable_huge_pmd_share().
  - 06/15: change_huge_pud() rejects MM_CP_UFFD_RWP_ALL next to the
    existing MM_CP_UFFD_WP_ALL check. Defensive only: PUD THPs are
    DAX-only and DAX cannot be RWP-registered.
  - 09/15: enforce the PROT_NONE accessibility check at register time
    only instead of in vma_can_userfault(), which the unregister path
    also calls. Previously RWP register -> mprotect(PROT_NONE) ->
    UFFDIO_UNREGISTER failed with EINVAL until access was restored or
    the uffd was closed.
  - 13/15: userfaultfd_register() reads ctx->features through the
    userfaultfd_features() helper instead of a plain load racing the
    WRITE_ONCE() in userfaultfd_set_mode(). Benign (the tested bit is
    not toggleable), KCSAN hygiene.
  - 15/15: fix the documentation claim that UFFDIO_API returns the
    supported feature bitmask on EINVAL; the kernel returns the
    structure zeroed.

The review also surfaced a pre-existing bug in
copy_hugetlb_page_range() (present-pte accessor applied to
hwpoison/migration swap entries, corrupting the swap offset); the fix
was posted separately with Fixes:/Cc: stable:
https://lore.kernel.org/all/20260703161833.57416-1-kirill@shutemov.name/

114/114 of tools/testing/selftests/mm/uffd-unit-tests pass on v7.2-rc1
(47 RWP cases plus the existing UFFD groups, no regressions).

== Problem ==

A VMM managing guest memory needs to:

  1. detect which pages are still being touched (working-set
     tracking);
  2. safely reclaim cold pages to slower tiered or remote storage;
  3. fetch them back on demand when accessed again.

== Approach ==

UFFDIO_REGISTER_MODE_RWP is a new userfaultfd registration mode, in
parallel with the existing MODE_MISSING / MODE_WP / MODE_MINOR. It
uses the same mechanism on every backing -- anon, shmem, hugetlbfs:

  - PAGE_NONE on the PTE (the same primitive NUMA balancing uses)
    makes the page inaccessible while keeping it resident;
  - the uffd PTE bit (the one MODE_WP already owns) marks the entry
    as "userfaultfd-tracked" so the protnone fault path can tell an
    RWP fault apart from an mprotect(PROT_NONE) or NUMA hinting
    fault.

VM_UFFD_WP and VM_UFFD_RWP are mutually exclusive per VMA, so the
same PTE bit safely carries both meanings depending on the
registered VMA flag.

In sync mode, the kernel delivers a UFFD_PAGEFAULT_FLAG_RWP message
to the registered handler, and the handler resolves the fault with
UFFDIO_RWPROTECT clearing MODE_RWP. In async mode
(UFFD_FEATURE_RWP_ASYNC), the fault is auto-resolved in-place: the
kernel restores the original PTE permissions and the faulting thread
continues without a userfaultfd message ever being delivered.
Userspace then learns which pages were touched during the cycle by
reading PAGE_IS_ACCESSED out of PAGEMAP_SCAN -- that set is the
working set; everything else is a reclaim candidate.

UFFDIO_RWPROTECT is the protect/unprotect ioctl, mirroring
UFFDIO_WRITEPROTECT.

UFFDIO_SET_MODE flips RWP_ASYNC <-> sync at runtime under
mmap_write_lock() + vma_start_write(), so a VMM can run in async
mode for detection and switch to sync for race-free reclaim without
re-registering the userfaultfd.

== Typical VMM workflow ==

  /* arm */
  UFFDIO_API(features = RWP | RWP_ASYNC)
  UFFDIO_REGISTER(MODE_RWP)

  /* detection cycle (async) */
  UFFDIO_RWPROTECT(range, RWP)
  sleep(interval)

  /* freeze the snapshot before scanning */
  UFFDIO_SET_MODE(disable = RWP_ASYNC)                  /* sync */
  PAGEMAP_SCAN(PAGE_IS_ACCESSED) -> hot pages (working set)

  /* reclaim everything not in the hot set from the backing file */
  fallocate(FALLOC_FL_PUNCH_HOLE, non-hot) /* or pwrite to remote */
  UFFDIO_SET_MODE(enable  = RWP_ASYNC)                  /* resume */

== Series layout ==

Patches 1 to 3 are preparatory:

  1: decouple protnone helpers from CONFIG_NUMA_BALANCING.
  2-3: rename _PAGE_BIT_UFFD_WP, pte_uffd_wp() and friends to drop
       the _WP suffix, since the bit now carries WP and RWP meaning
       depending on the VMA flag. The SCAN_PTE_UFFD enum's ftrace
       output string is intentionally kept as "pte_uffd_wp" so
       trace-based tooling does not silently break.

Patch 4 switches the uffd VMA-flag helpers to the vma_flags_t
accessors (vma_test_*_mask), so the VMA_UFFD_* masks are the single
place that knows which modes the build offers.

Patches 5 to 8 add the in-kernel mechanism:

  5: VM_UFFD_RWP VMA flag (aliased to VM_NONE until patch 9
     introduces CONFIG_USERFAULTFD_RWP together with the UAPI).
  6: MM_CP_UFFD_RWP change_protection() primitive (PAGE_NONE +
     uffd bit, plus a RESOLVE counterpart).
  7: marker preservation across swap, device-exclusive, migration,
     fork, mremap, UFFDIO_MOVE, hugetlb copy, and mprotect().
  8: handle VM_UFFD_RWP in khugepaged, rmap, and GUP.

Patches 9 to 13 wire the userspace surface:

  9:  UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing
      (introduces CONFIG_USERFAULTFD_RWP).
  10: RWP fault delivery and exposure of UFFDIO_REGISTER_MODE_RWP.
  11: PAGE_IS_ACCESSED in PAGEMAP_SCAN.
  12: UFFD_FEATURE_RWP_ASYNC for async fault resolution.
  13: UFFDIO_SET_MODE for runtime sync/async toggle.

Patches 14 and 15 are kernel tests and Documentation/. The matching
man-pages series is already upstream.

The series is also available at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git uffd/v9

Kiryl Shutsemau (Meta) (15):
  mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
  mm: rename uffd-wp PTE bit macros to uffd
  mm: rename uffd-wp PTE accessors to uffd
  userfaultfd: test uffd VMA flags through the vma_flags_t API
  mm: add VM_UFFD_RWP VMA flag
  mm: add MM_CP_UFFD_RWP change_protection() flag
  mm: preserve RWP marker across PTE rewrites
  mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
  userfaultfd: add UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT
    plumbing
  mm/userfaultfd: add RWP fault delivery and expose
    UFFDIO_REGISTER_MODE_RWP
  mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
  userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
  userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
  selftests/mm: add userfaultfd RWP tests
  Documentation/userfaultfd: document RWP working set tracking

 Documentation/admin-guide/mm/pagemap.rst     |  13 +-
 Documentation/admin-guide/mm/userfaultfd.rst | 269 +++++-
 Documentation/filesystems/proc.rst           |   1 +
 arch/arm64/Kconfig                           |   1 +
 arch/arm64/include/asm/pgtable-prot.h        |   8 +-
 arch/arm64/include/asm/pgtable.h             |  47 +-
 arch/loongarch/Kconfig                       |   1 +
 arch/loongarch/include/asm/pgtable.h         |   4 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h |   8 +-
 arch/powerpc/platforms/Kconfig.cputype       |   1 +
 arch/riscv/Kconfig                           |   1 +
 arch/riscv/include/asm/pgtable-bits.h        |  12 +-
 arch/riscv/include/asm/pgtable.h             |  59 +-
 arch/s390/Kconfig                            |   1 +
 arch/s390/include/asm/hugetlb.h              |  12 +-
 arch/s390/include/asm/pgtable.h              |   4 +-
 arch/x86/Kconfig                             |   1 +
 arch/x86/include/asm/pgtable.h               |  56 +-
 arch/x86/include/asm/pgtable_types.h         |  16 +-
 fs/proc/task_mmu.c                           |  98 +-
 include/asm-generic/hugetlb.h                |  18 +-
 include/asm-generic/pgtable_uffd.h           |  32 +-
 include/linux/huge_mm.h                      |   7 +
 include/linux/leafops.h                      |   4 +-
 include/linux/mm.h                           |  65 +-
 include/linux/mm_inline.h                    |   4 +-
 include/linux/pgtable.h                      |  32 +-
 include/linux/swapops.h                      |   4 +-
 include/linux/userfaultfd_k.h                | 100 ++-
 include/trace/events/huge_memory.h           |   2 +-
 include/trace/events/mmflags.h               |   7 +
 include/uapi/linux/fs.h                      |   1 +
 include/uapi/linux/userfaultfd.h             |  54 +-
 init/Kconfig                                 |   8 +
 mm/Kconfig                                   |   9 +
 mm/debug_vm_pgtable.c                        |   4 +-
 mm/huge_memory.c                             | 170 +++-
 mm/hugetlb.c                                 | 159 +++-
 mm/internal.h                                |   4 +-
 mm/khugepaged.c                              |  40 +-
 mm/memory.c                                  | 152 +++-
 mm/migrate.c                                 |  20 +-
 mm/migrate_device.c                          |   8 +-
 mm/mprotect.c                                |  70 +-
 mm/mremap.c                                  |  17 +-
 mm/page_table_check.c                        |   8 +-
 mm/rmap.c                                    |  18 +-
 mm/swapfile.c                                |   9 +-
 mm/userfaultfd.c                             | 389 +++++++-
 tools/include/uapi/linux/fs.h                |   1 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 884 +++++++++++++++++++
 51 files changed, 2468 insertions(+), 445 deletions(-)


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.54.0


