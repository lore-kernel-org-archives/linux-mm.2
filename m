Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3431CCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416BA6B00B8; Tue, 26 May 2026 09:05:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EE0D6B00B9; Tue, 26 May 2026 09:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3040A6B00BC; Tue, 26 May 2026 09:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DBBC6B00B8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C9F891C171D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:19 +0000 (UTC)
X-FDA: 84809591958.10.EE30F49
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf31.hostedemail.com (Postfix) with ESMTP id BC7B920010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="M +4RRM1";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=J6DRO03z;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dhUm0CUAJz1wJmCtXbeYhR2JQBhYOMsN2R++FP+grlg=;
	b=asqVrKYL5JCW97R+f2W/ZdATilO9a16XXjvRLuRrljsqhhZOTpKW6eYlUUHgHMiAZPjouH
	3clGEu8oU6yamLvikbjyCCua/q/bx+EyDaRdPFu8l4goBbmaSQUe4Ly6Gjf4aTeozSvClh
	CyXsPM4SZjMSYdbKnjILykuXG3EVNIg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800717; a=rsa-sha256;
	cv=none;
	b=emUnxeMPaR9yC33RhwJUvWBeUFmlfYm55ye1h4Jp3Tz17J0wHVL2EqiwqXPpPBuqgjw9uy
	gxJmDTQJ1Agh+PqdGjp5gUFMypJsph7abNpUAObHZiZKH6i8wANv4rV67+Ce69SfkOOhbz
	uIX/Uf1BN4422uokMGqmUi2rNDBRqRU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="M +4RRM1";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=J6DRO03z;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 059FA7A0176;
	Tue, 26 May 2026 09:05:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 26 May 2026 09:05:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:message-id:mime-version
	:reply-to:subject:subject:to:to; s=fm2; t=1779800715; x=
	1779887115; bh=dhUm0CUAJz1wJmCtXbeYhR2JQBhYOMsN2R++FP+grlg=; b=M
	+4RRM1Oaed4lHH06olR5t31s8gb4IgvT5t7ApS6YZbcrV4jB65Os7159j5TWBTaB
	Pb0PKoXtfq6MVQNHi0BR+ZSDwPcpyZPLSBFzwDMY+55P9UXquQZ2Wd8P+ELhP22t
	8JxGCOQgPfYFar633phaupWScEVbkVIjuZhgThR4uUvqBuix3urH88AKgZsU6/xe
	Xl9R3YZP+BWL8Yj1Nk8YJNrBzIQJeRf99dBOb+9F1ep/XY6WSpKnnjlgomtjwT3X
	ZyXVlA/eXH0K/qVgDlJKpoq6g3m1PiiaZwHPiJhvLM2XUVaxgqRJhJpIiBZBfeCJ
	OY651nGw/tfWK3CImCz4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1779800715; x=1779887115; bh=dhUm0CUAJz1wJmCtXbeYhR2JQBhY
	OMsN2R++FP+grlg=; b=J6DRO03z7994Ltj2XMOL+bodkLGU3JlIwey3MT8VPXto
	rHWC3n23nGTPm5PD3+OPOJDU6jYhWKZfU31ymZv9GZpClk6xvTPDteaHtFunn7/u
	OxXIQWIFLEKj8+W63ntIRrUb/XkjHYU69GyIgqa6c8gWI5rV/HZK7U80Js85wrS2
	mZVYS0ef51YUgh7DLLowfyiBMNkhrfplfK6kWc+y3y5dOkUcLjP7bRizuma91/6p
	1G++dbu52TuzZ8Nio+2X7J2NywDRnjyz5mxtVv6E2Txee5kshqBBpnQWV+hNvOJn
	rWB9CxiGOmkIRB/4j2vwNFGevOxkXGCoBZqMQPdPTg==
X-ME-Sender: <xms:i5oValYa78NvXChyDw3B7aBYP8Bo_lhUSbMePEkuLO8KRjEM2IQP2w>
    <xme:i5oVagXC6eeDS_58FcIdUL3pF29MtCjhls9ffyG8T1iaWbTfqZv6x315NGTPan4Wr
    SUWkS-7QAvNiBBlSeRgf1bM2kRVKcvpgcttgBRrcCjpbRI3TlAf7sk>
X-ME-Received: <xmr:i5oVagdaMT5iNcdh6ixzWnxLZQ8BAm1fhVQbltBmVnahs4ALqVuzrfNjG5hJYQ>
X-ME-Proxy-Cause: dmFkZTEhz/TZV/wd66IHXBJc8KcvWcSfHl/ClIl4IBAbk2u6QnQIt2UGurTm6i1y9blm9P
    iuvtAwmqTlTNPMYur55ABQNhUNHPys4Q75AOPrjD9bynC4x5BOQsEgkfXxLvoZUC/bTag+
    tYjxTZYUX2EZs0JPn8Pz3m1B3KGaSmlIWi8D02OL00fC2r0rEdljp/wFVBnxDSmrUSdyB0
    oF8QiV6InrorSSKjeCVCN6VPiqmN0rrRo1G0FmVw+glzg8ImV/LcvskcU71TpwKdOkorAg
    T3e5LJDU/1hkDDYZNIJyhYuQvPGI9cFTZlMAd7K1p8Bw+s2mmJCU2Xkgs1FMm4igHtpOTA
    6xV80v58n37YPvXf6AlTwdrjdxzNh3IAIQhUSU/14121snAJ+gX1l55pUSHU8LSy0aJBbR
    x5EIAh3EW++ISPLA0vXnChTEdfB7nO/kkY6sMARk2WWixWMJUpkQ04ymaZbPAh/UDpc3jP
    5eUpkSUkC3lBxOHUbmLyXxRitHqq2a4AQPpvx8UChb++pZ5VSyZWB3CeSyMBKVyiu2C42L
    9uwQzAo4xw2+xC0y3jkzZTWw6kJet+fRNAbhWRzGGWeDNOxWfEIRi6XxhZE0REjqtH+e1c
    JBGbdTPKqfEFz6omvWT6b+g5sxyX32a5AMSD/pJ3uHlX6kjXeK9s35offqIw
X-ME-Proxy: <xmx:i5oVatOvNVT-iamnE95vfTpUt27kWKitSYIn-22nAP4jH5iz2uS_vg>
    <xmx:i5oVaoLBH_bwbi6dBbXo9blQbdPgs0Cmmff5dXZ1_4mEjx-e0PGx9g>
    <xmx:i5oVajlCgXKlBLFSL-09tQbCHTWU6xp6Z24nUgFckcwUtGsq7kBQlg>
    <xmx:i5oVanaOBa3fKvM5UUQXc1lIsjjgtwcWzbkLpJWRQ55pWvAgMTromg>
    <xmx:i5oVasbDPLCy_GGqGwd7NZ1MIPRwkOiim94OYYMfS7rmagXGjkk4H5Hr>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:14 -0400 (EDT)
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
Subject: [PATCH v5 00/18] userfaultfd: working set tracking for VM guest memory
Date: Tue, 26 May 2026 14:04:48 +0100
Message-ID: <20260526130509.2748441-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 6twqyx5zgbw797w5dnyucph6tzmq15is
X-Rspamd-Queue-Id: BC7B920010
X-Rspam-User: 
X-HE-Tag: 1779800717-309525
X-HE-Meta: U2FsdGVkX1+KbDbkTu3vsYz40AyNOBgZ00wLnJHm/JyJD4boCHQ9qr4YRiSJBSUkBfSkvKmhkbcpcjJg78xm462WSBAmMXl9Nosix9QjtjtJTp6jEPZNUz+XA+OgnimrfneveqHs2P553hJKX9c0MODk9hO0pdEU/JCR1xGYo7JgpuFPVSDa1i4NhcUUAB2UYh9r5lEHsSQCv4lix9arKMJW1g++DgrS9wxUi0FGmE4xW2JDoR8P9bKTwObH/X9V6cKfTqOFkYpHK8I0u+QfbWvt9WAtLVzsUm+jHoWmxrUHarSM29Iv8nuz97gdyxEsXFQ47SRC/SKekI1kLeAiKRgltCjozPIa85WDGxErjk9Edu4F3QWyR6NnW7UwsZ49jMgoyjA5xo12yzGTGMc1cIgxsGPTp70GhNcgkcOM8S4fya2aRZHQE1gr/dss8u582HXt0DjWeacZDx9Dwlg9oAE7HMsy2dg0dwOismhMwV/CLcGETfPkPzJ3E+TVmiQexBWDBA5grGcaPWfXCVf4/uzyy9D9eMltkLdf2xfUSMMHxLP7XefBh25nqmFL3D9R+GD1y+7c6SaZksQo19cK/VKF20ANUO17e55BSA7Cx6DN300QFcnQyZjM/PZDf9o1zyKYh67XJqPlonAdLUJ7qTdevmzBt4K2V22MKWPIb0w8CqGoKrSZux9LlrKmarvc/4ErvA4K0hCDv9OqE2sssqJmy3UCXe0e4cmZ5H62ajeJQYAmwTezb8XA8fTF35g746jVXxdMOTcxLw652Gyu+/6/a3/Ky6JRsK/XrBIgjbeszTCSPiayApBvCtzgqAfD+lhnrIZqfKL7wk67dLBGlYcsaEw/CsONuUJp+DU49Nw4NoZeHSJK+UDmD3HWO+o/a6uSK4B1ZyBYjvEx84c8EX13v5AluW5uVoV09fEXKwtDF4B/cRVUfU7WL0e81v7/UVlHSsDQBO6l8LMLK6t
 Bh0rLOpp
 NJrQlso6PTYhjWdM1e+rXbomjXi2ipLjZltm3bBrkz4s3OGfox0W9Pqzz1dksMdQF2WSuqMvD2Ld/kqY94ARIp0+mnwkv2dKbj00yal2zUjHSGoc6uFQ5qGZAOU/H4+tQ0LSebfMO+Z9miGUUT+1leQkWP2MfZMBtw4RDEuq5d2Bsf0EC+wSLkcOEx9pdi6edj2chY3gRYMS3Eh0nw/cHEjkjxln3N+PpGq3nxXi4XkStYsqOSXXhchqmEBc60HLC2PJkeBblTw2Qp2XymJFpVSqRCzylOQAWvn8RBy3bo4M/PCUDKQyCYJ5k4+hPIwJz+dCIZws2pmXOGG//B2xHPYoBQBZlS5Q7gM8c2inUzBeBQ97qYFTeXPY/TguYwUyLfR9iM61joPkmhyUc0ozmux0wveHpi61zl2YfSbLoKdPTHgMzKivf7eQOgazePFS3vZr54i1aHK1JwptGw62CU00p3hfZAiXzMPcD6swE67FyRNIqzPj/YaD/9N5c6/EPHIAMxCM+BxJ8L8cRua9S9L6XMeVJtTJBF0kwqowJm+sYlLtSdz2bEhIH4mymtONQPpSACt226cLa39wB5i7pOd90odfNIebdfp0iR+Di/kvbMzPLU/qiyC/Na8ARN4vvTFWt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

This series adds userfaultfd support for tracking the working set of
VM guest memory, so a VMM can identify cold pages and evict them to
tiered or remote storage.

v1: https://lore.kernel.org/all/20260427114607.4068647-1-kas@kernel.org/
v2: https://lore.kernel.org/all/cover.1778254670.git.kas@kernel.org/
v3: https://lore.kernel.org/all/20260522133857.552279-1-kirill@shutemov.name/
v4: https://lore.kernel.org/all/20260525113737.1942478-1-kas@kernel.org/

== Changes since v4 ==

v5 mainly addresses Sashiko AI review feedback on v4.

  - Patches 1-4 are new pre-existing fixes surfaced by that review
    (each carries Fixes:/Cc: stable@).
  - 05/18: LoongArch select of ARCH_HAS_PTE_PROTNONE gated on 64BIT.
  - 10/18, 13/18: gate RWP disarm/rebuild paths on pte_uffd() so
    NUMA-balancing PROT_NONE markers survive.
  - 12/18: reject UFFDIO_REGISTER_MODE_RWP on PROT_NONE VMAs.
  - 14/18: PM_SCAN_WP_MATCHING on a VM_UFFD_RWP VMA silently skips
    instead of -EINVAL, preserving the atomic read-and-reset.
  - 16/18: UFFDIO_SET_MODE feature check goes through
    userfaultfd_features() for KCSAN clean read.
  - 17/18: drop _UFFDIO_SET_MODE from the baseline UFFDIO_API check
    so the test still passes on older kernels.
  - 18/18: VMM example switches to sync before PAGEMAP_SCAN; names
    uffdio_api so callers can read back negotiated features; fixes
    a couple of stray identifiers in the eviction loop.

113/113 of tools/testing/selftests/mm/uffd-unit-tests pass (46 new
RWP cases + existing UFFD groups, no regressions from patches 1-4).

== Problem ==

A VMM managing guest memory needs to:

  1. detect which pages are still being touched (working-set
     tracking);
  2. safely evict cold pages to slower tiered or remote storage;
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
Userspace then learns which pages were touched by reading
PAGE_IS_ACCESSED out of PAGEMAP_SCAN -- pages whose uffd bit is
still set were not re-accessed since the last RWP cycle.

UFFDIO_RWPROTECT is the protect/unprotect ioctl, mirroring
UFFDIO_WRITEPROTECT.

UFFDIO_SET_MODE flips RWP_ASYNC <-> sync at runtime under
mmap_write_lock() + vma_start_write(), so a VMM can run in async
mode for detection and switch to sync for race-free eviction without
re-registering the userfaultfd.

== Typical VMM workflow ==

  /* arm */
  UFFDIO_API(features = RWP | RWP_ASYNC)
  UFFDIO_REGISTER(MODE_RWP)

  /* detection cycle (async) */
  UFFDIO_RWPROTECT(range, RWP)
  sleep(interval)

  /* freeze the cold snapshot before scanning */
  UFFDIO_SET_MODE(disable = RWP_ASYNC)                  /* sync */
  PAGEMAP_SCAN(!PAGE_IS_ACCESSED) -> cold pages

  /* eviction (sync mode traps races) */
  pwrite(cold) + fallocate(FALLOC_FL_PUNCH_HOLE, cold)
  UFFDIO_WAKE(cold)
  UFFDIO_SET_MODE(enable  = RWP_ASYNC)                  /* resume */

== Series layout ==

Patches 1 to 4 are independent pre-existing fixes (Fixes:/Cc: stable@)
that the RWP code shares paths with -- they can be picked separately
if needed:

  1: fs/proc/task_mmu: huge make_uffd_wp_huge_pte() prot-update race
     -- missing huge_ptep_modify_prot_start() can lose hardware
     Dirty/Accessed updates.
  2: mm/huge_memory: change_non_present_huge_pmd() drops
     pmd_swp_uffd_wp on the writable -> readable device-private
     PMD rewrite; plain mprotect() silently strips the marker.
  3: userfaultfd: must_wait() applies pte_write() to a locklessly
     read PTE without checking pte_present() -- swap/migration
     entries decode random offset bits and the thread can stay
     parked on a stale fault.
  4: mm: mk_vma_flags() OOBs into the first word of vma_flags_t on
     32-bit when called with a bit >= BITS_PER_LONG. Harmless by
     coincidence today (the wraparound lands on a bit that's
     already in the mask), but any future high-numbered bit would
     silently corrupt the result. Add VMA_NO_BIT and skip negative
     bits in DECLARE_VMA_BIT().

Patches 5 to 7 are preparatory:

  5: decouple protnone helpers from CONFIG_NUMA_BALANCING.
  6-7: rename _PAGE_BIT_UFFD_WP, pte_uffd_wp() and friends to drop
       the _WP suffix, since the bit now carries WP and RWP meaning
       depending on the VMA flag. The SCAN_PTE_UFFD enum's ftrace
       output string is intentionally kept as "pte_uffd_wp" so
       trace-based tooling does not silently break.

Patches 8 to 11 add the in-kernel mechanism:

  8: VM_UFFD_RWP VMA flag (aliased to VM_NONE until 12/18 introduces
     CONFIG_USERFAULTFD_RWP together with the UAPI).
  9: MM_CP_UFFD_RWP change_protection() primitive (PAGE_NONE +
     uffd bit, plus a RESOLVE counterpart).
 10: marker preservation across swap, device-exclusive, migration,
     fork, mremap, UFFDIO_MOVE, hugetlb copy, and mprotect().
 11: handle VM_UFFD_RWP in khugepaged, rmap, and GUP.

Patches 12 to 16 wire the userspace surface:

  12: UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing
      (introduces CONFIG_USERFAULTFD_RWP).
  13: RWP fault delivery and exposure of UFFDIO_REGISTER_MODE_RWP.
  14: PAGE_IS_ACCESSED in PAGEMAP_SCAN.
  15: UFFD_FEATURE_RWP_ASYNC for async fault resolution.
  16: UFFDIO_SET_MODE for runtime sync/async toggle.

Patches 17 and 18 are kernel tests and Documentation/. Matching
userfaultfd(2) and ioctl_userfaultfd(2) man-page updates will be
sent as a separate patchset against the kernel.org linux-man tree.

Kiryl Shutsemau (Meta) (18):
  fs/proc/task_mmu: fix make_uffd_wp_huge_pte() prot-update race
  mm/huge_memory: preserve pmd_swp_uffd_wp on device-private PMD
    downgrade
  userfaultfd: gate must_wait writability check on pte_present()
  mm: skip out-of-range bits in mk_vma_flags()
  mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
  mm: rename uffd-wp PTE bit macros to uffd
  mm: rename uffd-wp PTE accessors to uffd
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
 Documentation/admin-guide/mm/userfaultfd.rst | 248 +++++-
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
 fs/proc/task_mmu.c                           | 120 ++-
 include/asm-generic/hugetlb.h                |  18 +-
 include/asm-generic/pgtable_uffd.h           |  32 +-
 include/linux/huge_mm.h                      |   7 +
 include/linux/leafops.h                      |   4 +-
 include/linux/mm.h                           |  61 +-
 include/linux/mm_inline.h                    |   4 +-
 include/linux/pgtable.h                      |  32 +-
 include/linux/swapops.h                      |   4 +-
 include/linux/userfaultfd_k.h                |  76 +-
 include/trace/events/huge_memory.h           |   2 +-
 include/trace/events/mmflags.h               |   7 +
 include/uapi/linux/fs.h                      |   1 +
 include/uapi/linux/userfaultfd.h             |  54 +-
 init/Kconfig                                 |   8 +
 mm/Kconfig                                   |   9 +
 mm/debug_vm_pgtable.c                        |   4 +-
 mm/huge_memory.c                             | 157 +++-
 mm/hugetlb.c                                 | 158 +++-
 mm/internal.h                                |   4 +-
 mm/khugepaged.c                              |  40 +-
 mm/memory.c                                  | 133 +++-
 mm/migrate.c                                 |  20 +-
 mm/migrate_device.c                          |   8 +-
 mm/mprotect.c                                |  68 +-
 mm/mremap.c                                  |  17 +-
 mm/page_table_check.c                        |   8 +-
 mm/rmap.c                                    |  18 +-
 mm/swapfile.c                                |   9 +-
 mm/userfaultfd.c                             | 407 +++++++++-
 tools/include/uapi/linux/fs.h                |   1 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 765 +++++++++++++++++++
 51 files changed, 2321 insertions(+), 429 deletions(-)


base-commit: 449a5df98f8dffa9b037e3b6838fc5af327df072
-- 
2.54.0


