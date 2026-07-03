Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B147AC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B46B6B00B6; Fri,  3 Jul 2026 09:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865996B00B7; Fri,  3 Jul 2026 09:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D966B00B8; Fri,  3 Jul 2026 09:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 425156B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0B1FA0141
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:20 +0000 (UTC)
X-FDA: 84947564520.10.619BD9E
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf09.hostedemail.com (Postfix) with ESMTP id A0909140005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y TZ0xwL";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=DDG2xlVW;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085778;
	b=n9mgWo0/kcboVlP1wg6Dn3IN2Z6naYuKKxMcqyT+LYxdiQNm5JOgLJIDj6cw+8mgycavaX
	MRtQ6UZZhG1Q9Lth5gyQ0XxFFqUk3q8SlllE+n495nB96lKJ6NEnA8NPDGEvh/CqekgRwN
	yUQv3jq0xPHMBqpdyPSI4M1Vo8J4NTc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Rd9LP8Ld4C/dBeTQf9MvU/nTiMOcgtd2UZVoy1RgmdI=;
	b=UXOWZtTxgpQCRlL5XR+zLE6a2Dk9A3ySPBewoel6ximTugZKd9OxPzZc6F1pV9XprAkE8y
	xfK2prS1KQV5x9FkzOoiGlDKMx7WXEEYs+nZmmitaoL1i/QZmlQXJkZGqHOk0ert3jcKlX
	wPyeA/E7/PS5N96sDkwgiT92R/krBuk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y TZ0xwL";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=DDG2xlVW;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3FE707A00B9;
	Fri,  3 Jul 2026 09:36:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 03 Jul 2026 09:36:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:message-id:mime-version
	:reply-to:subject:subject:to:to; s=fm3; t=1783085777; x=
	1783172177; bh=Rd9LP8Ld4C/dBeTQf9MvU/nTiMOcgtd2UZVoy1RgmdI=; b=Y
	TZ0xwLsBuk3B7RQ9e2hd9rWRihBIGZnr3kZPvs8v6vObJtCBSaQHvKAbRGUEWo1w
	Vp38l4BjlK8HnyObjkbnxOFaX+dlTnQ2L/zudTGWvXCSeWZtV7Py9uJPA7zid5ZJ
	yzNr9odJ8Vpq47Fvo0hiDtkJX882pukQrN8HfYYIH4Op0DJVKASEL2q6HzaO0lGh
	QhbgB0V+0FjIEajwLxZQLDUofL3GF20j5J588G1jS1xzYGyweWFQEeIlGyqc9rSa
	sF2nnoQRyT9+d/4+cOmTFgxS7p3wcJiZTn2GmrLwpENgiWep/J3BBIyBFxT4maXq
	2eJPMa+xfSUsViuTLyqqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1783085777; x=1783172177; bh=Rd9LP8Ld4C/dBeTQf9MvU/nTiMOc
	gtd2UZVoy1RgmdI=; b=DDG2xlVW8RFVNdsNR0yMbL9SxPBZXqkME5BUaxo1xEsC
	E5M+D798bqpcuLgqo+w2C6p9j4U2eUWWzZIZnfTsAhCO8vIzNkZvu9T2Bw+XjQ/F
	8lcGEOckl9VTLvwDah+HOetpVtcCwAcFdEpXW43wZ56MXkVwO/Ms33h6T1LF8sua
	wjJ/tEvstzRO2HoWZhXcqy6hZV6D1Rm+ByJAZcwn07T6Mhn4cnacsyxHtYVqUUKT
	ANQSNcn20oHigyyy3TaUMzJS5INalLU+X795o2VE1lzvODyHd3wLyZfP2A5p0ew+
	9mcseON6UiFnTzlcLh9tLlmf8qZR51k3jSCnNlSSLw==
X-ME-Sender: <xms:0LpHangW7VMsrTECJaPEawQKYoLwYM29gKaPGNscP1B6k1wOX5IKhQ>
    <xme:0LpHav6gf80sgR6BECNvQx3_hDhJw6dSt1A-rgmRmnmqTfrdtVjGAqibvDV-fjZEf
    OwrMnPbsMB8Ipf_KufC2X43tLTvLgIEi8yoOmcCmIEoh4Bs12o4mQ>
X-ME-Received: <xmr:0LpHav7Q_0nIQ6Q3TSdJwS1rS0zMRNVqYB_rpoLfFNC_mjsCLujowm2QxUVzrA>
X-ME-Proxy-Cause: dmFkZTEQvC9TwQhmGP/fzqhqMrw0ck25D6Pb3tqvYmVT0nhfW33U1g1unjLyu+XNhrW44a
    3Tro+9KrdDGesL2pvZesRCpWG9QAYcnKeEUbUCrn0h4gEXNkmsHzvCzAvwebsFadbHasb8
    hP792AYrHeL5Uk20MC3H2aZ/F90vNEYUA62OP+/KMcB8n8oAtFR4kuyKFbiCyAucWTru+I
    j20y0+3T3mN4WE16fkRO6W+AmuXsQ12N0WtuTeHPT0Puo+1hEdIIC37rOLafOoTSmz3TfL
    /gmmrImq8XTPlGq87+RGdh7d+SCmi+XUM62fA3id7txDLkT2jDYJGn3A0K2iYV1bosbsMK
    pYQbS/Ldiwpe6zte+ZnnUXpYb6gNKPVob6mw/pL68iq5j7fgOCdes4fXdjK9DzDgjerRGz
    78BO1d9Wvq1V0/EkcX9+8ssKgySAk9AdEIIyJSxc0rMEmA4j0wDbI9uB01HV6j6T9NKDYr
    hi5+o2Ph7rvehElYFJTw2K2mRqPuCr9qrUuk0e554H30egDoTx41OaUmo+dbkVZQIwH7ht
    WW9v3AEB0lRFPmsaeUYpsAarrHjYA7GRzeidB5HR+e6wJZveOCtoPDNx4QMmBE/W9fF72+
    E4BdQk750/GXwqNtOnPb14vHpEIFQqKotjWGna+gPJObnwgKBCVkgKplpl1g
X-ME-Proxy: <xmx:0LpHatGCoBTe0Oh6FpsAyX2Exl_SI56GZKzIfa00-o7mUR0_RtEHMg>
    <xmx:0LpHatyK1NOFGuRr4aqRmIDFbzpVnh50Uqo-ztCJbBsVioB4Oq_0Xw>
    <xmx:0LpHat3tAUHt6W5dj5OOBRDqNDTGhiDIDo4OQEKxHYK6IVxgPAlV_g>
    <xmx:0LpHagME5a-AnBLrhv249KcFPU0JXjKWtIRon7pbVZ-aeD5s53cqAQ>
    <xmx:0bpHahwdCiYcbmqoC2V2B03pxd06LtdpH-aedRX_0r1llMQl7zPMg_1r>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:16 -0400 (EDT)
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
Subject: [PATCH v8 00/15] userfaultfd: working set tracking for VM guest memory
Date: Fri,  3 Jul 2026 14:35:59 +0100
Message-ID: <20260703133615.1039465-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xxt143n6o1qrfdhh1rzuoq8a1h61opt8
X-Rspam-User: 
X-Rspamd-Queue-Id: A0909140005
X-Rspamd-Server: rspam05
X-HE-Tag: 1783085778-808683
X-HE-Meta: U2FsdGVkX1/OS/e0XsaI+K0RsymoLBVYNM4ly/xuq2h3/iVNQe7VLoV7evmBpHXYBEyUMtqWw8fj0MouhlOK+6Ssh5eIxLXPAOqqkj2Fx4CXX1guC9pKFwidruVo+k7OzpS8QYX3Y2VW7QbHNA0AWjuFoKsrHtvT5jXp4mVQe38+RfYcyAMeiT4mSC3EXQ/69zcde0vgiNKVMcP1wZaY7R0TFIix0T8TCOndZvfYP3bH8Ijvg24SDuO8PzWE9PRsY06pDi6tsj2wxPA2ENUejx6i0sXCjCYoTO9lHFgNuY6YPTl2N1NJJKCApQ0J1S/tat9XAQINyFOLBW9kYt2s5ZfeMONdxjhz3TgA/PsilThSISdhb+6Zx8kjq8dNbrFcQOEyr996GdkBi0zF1sS/4ZxkV7hWz1kEdsAQqWtn0ATEY7zetg2pB6MxZ/5pUy7yo0ZMPb1AEuVz3WSQoW2a791bdYBOAsbPs9UR7DPXG7ChZAtH4Gx5pgsiHO4BqL4f9pqDp9E++MnLrCV5IblSlWKCHy6/L0gPW0tQrR8TXSW1n/6wuJsiPvFLcI3oMsisVikM3g6egpDPEDi3G+XR6FetkBYrBSHPORfkFHtfAczsnRVGMR1kNFD4gZgz3w7uhBuJTiaYUFrm9ICIsvZABh/30hOUXkAmMzD6eKyxFep98SQ4b2BFdzFcx3aZOMepdRvC6xdznhkMK6pCwpQRzx78v135Cn5f9uWvNSCWx8PHhfsDlp6NpNG8WBUQ77PmuxJ8MxkYEue/zaJ7TjfBelgMj1RgdN4wSiOPlgGcwG1/U803rIMkEXVwQV0SKGRjSUVYF8E/564fGwrj4c94MbhHOzHt1UpfvBmqtXy5N31s+Eeog/l18hzIGOhav2GH4FER4oe55jaxD98vcCioHBdgLkkoNln4G/oQMnv7JQAZbK0gr0NDE/hSG/j/qhPfNjkNWHktlRG9mMk1IwO
 9XVhm6z0
 fhv/uI/X+P0dqSg1/IXQfEs9GG7CggfKWbunNc9owiZp0xAmdTJ0GYb+pAc5kRcrGG+m5gK1Kh1onkKsdtoe1nvp8jDHDacY2CJKnTMXVnnZZeQh9rj7N74LAdm0NKgdZ/mIJe9nBMccB38ISbPhbxJpoXUqC68cgD0mER+SajP2dTMf0FVoiarNZwTneJ65nMZEYpRSTrjGTxNhR2Fypas0Y9FV7eLk6Zf4xubKoqoA6b5SUo4QBgR4iRxZQq1KoCIL/b0sIQatg8vOTT9kFtCkUrcUxKc16CtLd5jblPTG1lt9QiFr2t1Y69nLCruZlw085jOu/vPolC5IQ2rAHHtdFHc2eIc730kjzeAuNCPIFvVxJJ/BywkvIi6069IZDYPB5jdTD6z/CWu0Hzz23YWaa4MQey50+qfKMkkrae6FtOKfNPslIe+vwJniGDjBkxYyhjEcY5D+1hKU=
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

== Changes since v7 ==

Addresses the Sashiko AI review of v7.

  - do_swap_page(): a non-exclusive (e.g. forked, COW-shared) page that
    was RWP-protected and then swapped out kept the uffd bit on its swap
    entry, but the write that swapped it back in fell through to
    do_wp_page() and COWed to a fresh accessible page, silently dropping
    RWP tracking. Restore PAGE_NONE and leave the pte read-only so the
    access retries through the RWP fault path instead of COWing here.
  - mremap: move_huge_pmd() and move_huge_pte() normalised every present
    huge entry in an RWP VMA, not just the marker (protnone + uffd),
    clobbering the protection bits of unrelated accessible huge pages.
    Gate the normalisation on pmd_uffd()/huge_pte_uffd(), matching the
    fork/copy path.
  - selftests: add rwp-swap-cow, which reproduces the do_swap_page() case
    above -- RWP-protect, swap out while exclusive, fork to make the swap
    entry non-exclusive, then write -- and checks that an RWP fault is
    delivered rather than a silent COW.

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
 include/linux/userfaultfd_k.h                |  89 +-
 include/trace/events/huge_memory.h           |   2 +-
 include/trace/events/mmflags.h               |   7 +
 include/uapi/linux/fs.h                      |   1 +
 include/uapi/linux/userfaultfd.h             |  54 +-
 init/Kconfig                                 |   8 +
 mm/Kconfig                                   |   9 +
 mm/debug_vm_pgtable.c                        |   4 +-
 mm/huge_memory.c                             | 164 +++-
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
 mm/userfaultfd.c                             | 387 +++++++-
 tools/include/uapi/linux/fs.h                |   1 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 884 +++++++++++++++++++
 51 files changed, 2455 insertions(+), 439 deletions(-)


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.54.0


