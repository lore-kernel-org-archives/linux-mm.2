Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 618F3CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4846B0095; Fri, 22 May 2026 09:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54DF6B0096; Fri, 22 May 2026 09:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACED56B0098; Fri, 22 May 2026 09:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0776B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:39:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AED91617D5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:13 +0000 (UTC)
X-FDA: 84795162186.02.F6C8656
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf11.hostedemail.com (Postfix) with ESMTP id 49BE040003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="g 0SM78Q";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=qmqs2E2j;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779457151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=60TM9NRLcDxoLP/n4ee+semPNu4DhUvbIg8bvNUrqi4=;
	b=sHHOC8o7wnOfm+00slo366XeJ1EyURHBPP7lWIEeYUbodu4WzIgpbT/byfMxHfitVVXGiG
	3Vjk/4hgX3Z8P8avXxQbDHXDyajLLlUh57z2xFFPs25bCfAwvtHRkv/BokAIZXf1kuW/9g
	eUq29oiSZVc9UngUoebMrSsmRNKcG0c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="g 0SM78Q";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=qmqs2E2j;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779457151; a=rsa-sha256;
	cv=none;
	b=2gzHXIgatlpx+QScWyNu2bDFg9CVrMcGpbSyd29z2maT9ojE45pxFmxMHZKfRUpTuJxhko
	2fklYlnT03OJfzbYMdOE34k/5coRx3ebfpQxgxQig9VQeenntrzIaTFE+Y9nNwg+kUzX4i
	mE99+R1T0Vkt331VNBuvGn3wvuO8CBs=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 7E8801D00072;
	Fri, 22 May 2026 09:39:09 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 22 May 2026 09:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:message-id:mime-version
	:reply-to:subject:subject:to:to; s=fm2; t=1779457149; x=
	1779543549; bh=60TM9NRLcDxoLP/n4ee+semPNu4DhUvbIg8bvNUrqi4=; b=g
	0SM78QPPZ8Oo9MTi/aqHJBBQiJUbflFBPUIbImkl9HTX8KN9SS7RvIafM/dGK/lQ
	BsTl+TLxrpPYHrAAmpCROTpHjkGMFB+Q13tGBdguErqtr+dp8sqvj+CU7twMEd9K
	sFiQelyFRbDVGzPxNcwhpTGy/41HpPcPs9PXirMrzj2DBtlNxQxGdUtG7k+rCO3r
	lBxjdnWXiUyz0AATnXGvKg63GpaPBJ7KgKHE2r8ipVftJtGbUY2coHh9ZLJNAUQz
	nvvxK/e08tKI62yW8oJJut9+C3tukT6I9Z2zsToYTJSpWYCn2D0DOltUZtASaFQo
	+AejVbWf81Gwo6ftXjERw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1779457149; x=1779543549; bh=60TM9NRLcDxoLP/n4ee+semPNu4D
	hUvbIg8bvNUrqi4=; b=qmqs2E2jze8pqhsy4cfzmYRldy3j6mC8xGjucE6TWyjp
	9dM+t7NEaX+v+94rWolbGTOEcxgNAdUwNqonR9DcsFPkS0mI/AZZho2wE8pxcUgi
	qTA/5NXzwaBIB3UVDQAERUoT7p0ioGjRZoh584GxTC2zK1x4LqG21X21hVYlBfBP
	aw8AEwa7TjtNJ5WmoFX9UtKSVuwEoPGD7cmL6T8kKXuZHcGqv5ZmElM+BilJhJ1J
	ncetrLgZ1epYFfnfVK+h65E7xKd85qIu6iQ0F1gpgwdazVQpWolDWy3J+/L/ctQu
	ZfIpTBiMolVI9YMHuFkTKg+Bexb0b+Xb9Ek4ZnWwAA==
X-ME-Sender: <xms:fFwQaqs9Hf1sa2lok2s5q_gTa130KuC8aVjRqsd0tbWv1MK-QSxLJA>
    <xme:fFwQagibLxasFfYptt8TVlaDZ8V2OibFa0_cV-rPfVKCRG7gsa8JdOr4qCElffI6p
    IyOa8Fv9vUUbM-Cv5WfrlynardUghqnbc9szUwL-s3P8ygRxws-uA>
X-ME-Received: <xmr:fFwQaosHdknRjB_nDut5r3QA3Q_n93kWldDvEClgL2k9_q_R_emn4TMXJsl5SA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtfedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffogggtgfesthekredtre
    dtjeenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhh
    uhhtvghmohhvrdhnrghmvgeqnecuggftrfgrthhtvghrnhepueeltedvledugffghfehie
    dufeekheeijeeiveeigfdvudeifffghfeftdeltdegnecuffhomhgrihhnpehkvghrnhgv
    lhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdei
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghpthhtohepuggrvh
    hiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopehvsg
    grsghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrdhhohiflhgvthht
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:fFwQai5eBiMnN667hBm3cDiOGpL9jEKsPNrWB9m3QQGGcd2E2EeL3w>
    <xmx:fFwQajspDHcV6GCykoxP7SQTwmb1tiBBgWKt6bTvEXr9s--zDFFTOQ>
    <xmx:fFwQas0o4TNpJTwLNCJtAN3Ssn_8NsZ2wUOdK_YqSpTHvUbjJhfNQg>
    <xmx:fFwQao_lRu8vcvZlmrSu0bywGqfgFQVxHmJpqiJCDXH_roX6-gvMoQ>
    <xmx:fVwQamjbMWSs4iStWlBnShbnjZTbmtwqNloUMhgcM2KzqQW_S-N5knfG>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 09:39:08 -0400 (EDT)
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
	linux-man@vger.kernel.org,
	alx@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v3 00/16] userfaultfd: working set tracking for VM guest memory
Date: Fri, 22 May 2026 14:38:41 +0100
Message-ID: <20260522133857.552279-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49BE040003
X-Stat-Signature: efa8i6r18oh6p8p44a55yqowia8ize48
X-HE-Tag: 1779457151-680428
X-HE-Meta: U2FsdGVkX18ydzq36m5ce+EXfYdoqXXUEsEJGLbKCeLcxIZ3l1CXD3tVgmmQEONBeXzSD/4R3L1wnaZOGxlD8UMN/Afrn8PMTPbibD5dBICEKkloaXEhB1w/wAkUD2sWNWedU4Mwqjq/hrIBMx+rVDvUR4E++r2UqJOijkQQxy2uFJDr/98Ree94JvEMCtzUN6XpFhWS8lW+euIQKYviQaIwHOnVCRswP5RzVmd52FCyYmW6ztJgTtIuB6CeMN4hoOAJC5i0V2SLN/qVkDOb0K7d4o+4dNpnQOi2BVyOEeMmonkRUgCpZXIpWcHCL3DaHTRBZrkeaWU/UdNfQ2UoJThvW9Rt5T8iff0QQefm9AWroM3tokFovIj0JNuJPWfz3FxXataSPwsqM22bwV/NrGhZb2GV4ffPr/s9+ORjVPTjsqHHwU4euJUiwOrnm/TMwGt2XodqwzTbVSAr5G1vZZAk800DWRobmSr/gT5/yUV0S1uxy+d2C0aG0AD9Kqs/oXsgxR4ROgvcZieJuw6AwJeNW2a+6X/iGNCrIC6eWpo8KhcvCCjMmY1ilAFtf+pEoS1unnI0g5Mm20TokPxbjyeP7CxXHvAGMwVml/nZvDmlej4YnH+j1wyhGfcEbzTB1hL/wGPkE9AwrFmPGMpROavnfxZg62dHh6mg7YROmmfsMg7OX6movjFkFzPSnmO1jVksOi+vLC4mzSvcOE+ib+Ao30kZztxbuMej/+ez3tNPhOgC8BDaxzPA9esTA9Fd5gGY6ZmdrrXT1tX7qJH2/0lJOSdj1gNEgnhU0shXyJIQmUauW/SmBccG9a7/uFYw+Yl2Z/o0uI74NrxIElduTlZGLtl5cJwgeQ3QnFnD5GLjuGHqKVz05L/Kin8Gw4yV2zGSU6BD95FXIx0HXv679p5ajb+BwSDs5s4kG8VMnH0ZO2h0CFZ47HqZDb84oiy65VmX29DfpjBgbaT8oCc
 U6G3y8G3
 kkijtqCUppaQE15qVpk55ZxdnM3E4I+5H24e3805N+Cnqoy6894QuGL5efQibe3Naceu9vANlAEV/GinnU7LenQSTAa4G/WcvYTm3sKP6BPy2rxPw8UQ6KLItVxVndzPr2x1LOrrf8Vo3MYNuOTlz/bjT8qP9452wfD056MwIq8/u9V4xeD906xXoQCRTDTlt2zlhrzmqS7kpNEyANoCFVOLtz0ZrRMR46jzREo2+xlFvhnSG22y34Y7XFffk7qU76pFtbibiR2QE4NDV6pb6nx8jF0GG269ti1VSIynwgb+VrfLBTZ+YK+ltEDC32YRz1bV2EhbEHLh/3a70G0HujAjuws/nIMtlf4Za7pvyX4aMwxFY7MBkO3DH6zyviobcAZKL2+nmPooo9gRHmnrKpvbHUKogx246c7a9dEJoGoJtJj/apGVlR2rEf113ulRQeX/+4Y6YUjJ6XzU=
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

== Changes since v2 ==

Review feedback from Mike Rapoport and SeongJae Park; tags folded in.

  - 03/16: rename uffd_wp local in copy_hugetlb_page_range() (SJ).
  - 04/16: group mode and protection bits in __VM_UFFD_FLAGS et al;
    move CONFIG_USERFAULTFD_RWP to 08/16 where the UAPI lands.
  - 05/16: fold uffd_wp/uffd_rwp bool pairs into uffd_prot in
    change_huge_pmd(), change_softleaf_pte(), change_present_ptes();
    nit fixes in comments.
  - 08/16: pre-scan rewritten as bool found; CONFIG_USERFAULTFD_RWP
    moved here from 04/16.
  - 09/16: line reflow.
  - 13/16: rewrite uffd_rwp_gup_test() with vmsplice() -- write()
    went through copy_from_user(), not gup_can_follow_protnone();
    plus selftest cleanups.
  - 14/16: documentation wording fixes.

Patches 15-16 are the matching userfaultfd(2) and ioctl_userfaultfd(2)
man-page updates against the linux-man tree. Apply with
"git am --directory=" or by hand in the man-pages repo.

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
mmap_write_lock(), so a VMM can run in async mode for detection and
switch to sync for race-free eviction without re-registering the
userfaultfd.

== Typical VMM workflow ==

  /* arm */
  UFFDIO_API(features = RWP | RWP_ASYNC)
  UFFDIO_REGISTER(MODE_RWP)

  /* detection cycle */
  UFFDIO_RWPROTECT(range, RWP)
  sleep(interval)
  PAGEMAP_SCAN(!PAGE_IS_ACCESSED) -> cold pages

  /* eviction */
  UFFDIO_SET_MODE(disable = RWP_ASYNC)                  /* sync */
  pwrite(cold) + fallocate(FALLOC_FL_PUNCH_HOLE, cold)  /* races trapped */
  UFFDIO_SET_MODE(enable  = RWP_ASYNC)                  /* resume */

== Series layout ==

Patches 1 to 3 are preparatory:

  1: decouple protnone helpers from CONFIG_NUMA_BALANCING.
  2-3: rename _PAGE_BIT_UFFD_WP, pte_uffd_wp() and friends to drop
       the _WP suffix, since the bit now carries WP and RWP meaning
       depending on the VMA flag. The SCAN_PTE_UFFD enum's ftrace
       output string is intentionally kept as "pte_uffd_wp" so
       trace-based tooling does not silently break.

Patches 4 to 7 add the in-kernel mechanism:

  4: VM_UFFD_RWP VMA flag (aliased to VM_NONE until 8/16 introduces
     CONFIG_USERFAULTFD_RWP together with the UAPI).
  5: MM_CP_UFFD_RWP change_protection() primitive (PAGE_NONE +
     uffd bit, plus a RESOLVE counterpart).
  6: marker preservation across swap, device-exclusive, migration,
     fork, mremap, UFFDIO_MOVE, hugetlb copy, and mprotect().
  7: handle VM_UFFD_RWP in khugepaged, rmap, and GUP.

Patches 8 to 12 wire the userspace surface:

   8: UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing
      (introduces CONFIG_USERFAULTFD_RWP).
   9: RWP fault delivery and exposure of UFFDIO_REGISTER_MODE_RWP.
  10: PAGE_IS_ACCESSED in PAGEMAP_SCAN.
  11: UFFD_FEATURE_RWP_ASYNC for async fault resolution.
  12: UFFDIO_SET_MODE for runtime sync/async toggle.

Patches 13 and 14 are kernel tests and Documentation/. Patches 15 and
16 update userfaultfd(2) and ioctl_userfaultfd(2) in the linux-man
tree.

Kiryl Shutsemau (Meta) (16):
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
  userfaultfd.2: Add read-write protect mode
  ioctl_userfaultfd.2: Add read-write protect mode docs

 Documentation/admin-guide/mm/pagemap.rst     |  13 +-
 Documentation/admin-guide/mm/userfaultfd.rst | 236 +++++-
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
 fs/proc/task_mmu.c                           | 108 ++-
 fs/userfaultfd.c                             | 263 ++++++-
 include/asm-generic/hugetlb.h                |  18 +-
 include/asm-generic/pgtable_uffd.h           |  32 +-
 include/linux/huge_mm.h                      |   7 +
 include/linux/leafops.h                      |   4 +-
 include/linux/mm.h                           |  46 +-
 include/linux/mm_inline.h                    |   4 +-
 include/linux/pgtable.h                      |  32 +-
 include/linux/swapops.h                      |   4 +-
 include/linux/userfaultfd_k.h                |  78 +-
 include/trace/events/huge_memory.h           |   2 +-
 include/trace/events/mmflags.h               |   7 +
 include/uapi/linux/fs.h                      |   1 +
 include/uapi/linux/userfaultfd.h             |  54 +-
 init/Kconfig                                 |   8 +
 mm/Kconfig                                   |   9 +
 mm/debug_vm_pgtable.c                        |   4 +-
 mm/huge_memory.c                             | 155 +++-
 mm/hugetlb.c                                 | 146 +++-
 mm/internal.h                                |   4 +-
 mm/khugepaged.c                              |  38 +-
 mm/memory.c                                  | 123 ++-
 mm/migrate.c                                 |  20 +-
 mm/migrate_device.c                          |   8 +-
 mm/mprotect.c                                |  68 +-
 mm/mremap.c                                  |  17 +-
 mm/page_table_check.c                        |   8 +-
 mm/rmap.c                                    |  18 +-
 mm/swapfile.c                                |   9 +-
 mm/userfaultfd.c                             | 112 ++-
 tools/include/uapi/linux/fs.h                |   1 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 766 +++++++++++++++++++
 man2/ioctl_userfaultfd.2                     | 209 ++++++++++++++++++++++++++++++++++++++-
 man2/userfaultfd.2                           | 147 ++++++++++++++++++++++++++-
 54 files changed, 2586 insertions(+), 426 deletions(-)

base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.51.2


