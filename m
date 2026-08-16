Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41F02C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068BB6B0366; Sun, 16 Aug 2026 18:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019D86B0367; Sun, 16 Aug 2026 18:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC2E6B0369; Sun, 16 Aug 2026 18:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BFC16B0366
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05E6212010A
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:20 +0000 (UTC)
X-FDA: 85108617720.19.059F7D9
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf26.hostedemail.com (Postfix) with ESMTP id F29A7140006
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=P8vrMzlP;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=acpPsw00;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920378;
	b=yh1gdqe8kkfwGXrV0p7pUZKNWXPw/0x1rRBWbl74qoDn4RIzIfipnHMgZ/NWM6Srw1U8ji
	7X4PozYA0TCVlXvPTvxxXfvDSC93WUJezfvgF1WDayKDgQbWc2OJg5m2vWySxlZ7m9z7Fp
	wtnA3mzQqJ8GN2cCEcMv+mYvDgMDQCs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=P8vrMzlP;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=acpPsw00;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KMOwF7RaNQPDQT30tM4Ai1c697tQZOME6gODSme32nc=;
	b=1MbYIgy7Mb2bQO1oycZblPuo09ZKDn/1qXJ+W4kAaHIJv0uwyyfDlYigD1msAz1ww/Tfwl
	nwKI9KG5QgD2UW63fIwyNrO/xaahoOApGMh2QgFhYLZZ77iQ5NqqzEb99L/p1ce2G995ng
	8vZ1gscKxjAsdJfXdMCOgtfS1uw7Mb8=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 69933EC0074;
	Sun, 16 Aug 2026 18:46:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sun, 16 Aug 2026 18:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1786920377; x=1787006777; bh=KMOwF7RaNQ
	PDQT30tM4Ai1c697tQZOME6gODSme32nc=; b=P8vrMzlP7j0qo3sbRYQ+UWfYt2
	eMTGuY7KNZnw1mpVceMeJeTzQnTGwyT5ttp6T1lpFKs9Ehe+b22o12cwlJ5q8Ndj
	y9Z4DQ4SqdQYnpOJ2dtOYL0yIMcPyRLbi8zIgEFGh9Jg7i8zHWhH9h1Xb9MnbMoO
	2SL9jjm8vIHjdHJlsfoLWB2p0u0FDeqxLZUjiFlpPodjHcnGyc+F7JeVGRWeU7/H
	rRlvZ/gQLwO01yv3/yd9MkjkhQVshj7t/ztc3L0Q+xMTyyKIAW0BmS1hMwRQLXby
	HcqZhtJ/H+18pEHYwqLkb/jndyPcKxLvBZNwlThBUcOwK8mPSTlvvkhvVOLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1786920377; x=1787006777; bh=KMOwF7RaNQPDQT30tM4Ai1c697tQZOME6gO
	DSme32nc=; b=acpPsw00x12aF7BHBjO5u9Dx9isKbVV5ZtyVxIt5V6oMNGqla7I
	sGCvDOU4IFs3B+US6xGIfR3aevvIi/YKdHDvUL+Z9QajYgeQorE2D+O5ckJyA5dp
	h4sM1gtiGPtV+rA+VY5GHWy6weof/4bxZ2j4oVLJez5nHvBFMF6I3KqXHp6NiCaQ
	PBCc+hIEqoY1MrAeC5gGE0AyhL/tr9818JjDR2Bh4SHIs+NlUuo7ZfJM85ZryZtv
	BdVAchkAdbmPrcq3xGUV1bCQx0eeGvF6U8T+OG1ovNsNcMCzxH8MH6WkkQFYJuLa
	wodmvHgPWJVB5BAuV/5E3dN6erqk2hLQnAQ==
X-ME-Sender: <xms:tz2CahbYxUBiRiO_uYHjy8BlslnzvRozhK1sGI9oSfNrr32FdYEggw>
    <xme:tz2Catv6G2eyCHm4JbnXE9mX87BviXTTo5ZjfoLFZOgjGE0DHDdLb8jRIeB44ChmG
    frEYeePpnDxTQZ7CL1hr770P8xZMtoO_Wnk0gSx9ZgorRSzzxqILQWZ>
X-ME-Received: <xmr:tz2CagCJ_JLDeQ24aeGl9ss9PrPLRhzZmIax2jGmOv5aBADEq7Cuv1A6-aY>
X-ME-Proxy-Cause: dmFkZTFbCYZrON7GHnFBAPU1Krpos2uameokKZSzsDNNiRFuKEeMF/qF3g4szPwPpFXL+t
    b6LOI5RUi8UTUHTgtNMThjzxQnbX4+l77+aqJB23DX+f1S251w/8mrs6yag0xeRwJsvw6t
    S7CZ1rz+5gbtAanQa+AJiRKqOFYxpmPNfGHSYtWiA9D+e+wmCBm81EmHF6RKRdGLlkJ9v1
    Jjj/zAsKIy3c8TYRGGJc/x0qNGzjCezb7JYt4osH8UmNbf2ECT5as2uUYGo1uZh+USD5Wn
    SNio1GDB08UT1mOLIAZwO3Czn/AJkiCFBPoG2cp9YkqiVVAZseuObubo1nHkQ4I8BjyeGz
    kCFLn1eobCDDSBuO4+EIrAQTN24ftXMaTDHeaIGvg2tac/2TKmhk8Jls8wGJtiprAvbySe
    MUyuVBsaH7VSAwMwjKcLy/zqTUEiouWSGFoGx07Y27YTmIQ9cBbHuE0DvDi2sfzisuoHe0
    5FyLY2BTWrCQJimorz86OtqckN6nCsp6RGwdhblbPOoLI/oVR8izi9riGk+5yCzCLbNeG6
    JiTC4P+iwYBPOj9FG5k3BQxB0EHKQPOv5USKgTpiuFN8GJ9AaOqHYtudxPDpgWBJ2ggSG/
    m03+k/twEtRsrkGJnOFcfVSbiGzz9CXxoouLa1NpVRRD0u8m7ZiShfsi9/Dw
X-ME-Proxy: <xmx:tz2CasM3KaLFC4tOxeKQqVTL-kJb2UqEOf53XcPL9xVp0Dd5KUeAOA>
    <xmx:tz2Cai4xy5TnKEKePYyARxNYIqKJFmZbJuvL_jxgacjPYgRlgAq16w>
    <xmx:tz2Cau1iHDM4kz5x4DUOtFS2uNwGF2mhcB_ghPliI52wmaAC3LxVRw>
    <xmx:tz2CapphO1kPVpWkOMwCSs34aQbsWqNSue-6iyO5adZ394s1d688tg>
    <xmx:uT2CaheRAYD0EKUc8UvkihIwBiGGC9W7U2bzF7EIQsHI5zM2EkWJSmFS>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:15 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration primitives
Date: Sun, 16 Aug 2026 23:45:12 +0100
Message-ID: <20260816224609.308019-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F29A7140006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 5p1jbj7mc3fbbqqfr3ah1ioyqjmqxdx1
X-HE-Tag: 1786920377-981509
X-HE-Meta: U2FsdGVkX19/3ibRvu7uf1fmFbVTMUhMqOVYXf9B5/DiBxuIxWyuYGS1ZPeA0ncsAel4+4l1rogQZ5xaLOx1J7BfhAbJDtcL0cnhYlVarCEfrEqxoRScARwsd8ZtJe+j8hXm4BM83JZg5ajDZ7z1n6QkYv6BjmIRttaZGljwy8Jj0BIx6CGL6THcOaLy+j8lWKfs8ipjfJnPjP5LDULVdxu9mIvVF/Vn9zvnaw20H3V00lG8m57qkbQKlSnyOC+vslAMgQ/HxURqjRuyzQ0NFfDlKSNA3ncEyYpL/DR2bUaPHA6tGrAnCVjggghNyUWr/LGQrANGFX3BrlXi0YpP4oTurZOfJ8R9PccR4DNbVG6u43JLWfjE+TvRvusqf8hsGCwNNIwzpqOHyD6OWRyLnpV0M1gVMnq+nRuFvK7dBElow1hPxgB4Yp6gjrj0infk5hprcKt83nJpNIpekHV7CXO87ZGCTK5CvAsJROexoBwm+vD5V2NbkKzWkQ4qEi6Ty2mcVD1yCWcPkJ9+fL8/SAx+nslFrabd3R4BrannHvEbM9oycXatclthuozZVLVYwCJFh29P0utrE4qZaAP7U7ql4VI1i6xOgl0vhPFQFus1qH/it+IhlHXou0PJ9Dx+FcBZGy/j6b6aQrePsnB1ZAdY/n3e62gtn3Uh6MVs1SVi/2fp5LeYC83BJUHAHX1muwjZPP9HdEBS4MVHnxKAlVxsp0aHP/BOqoT5j7xLiWAHQOnIjIR6KjhFxfEqAsU8RVX8cnjccNViFQ1xOeYeMxXdX9zRU6bcacdiz5BXtY6CWadPUcDBb61zVIs4gX9C2cplOSfD9xkRd+ykwFSKuXJS8LTlEVGM+Cg9+PBOt2U9Vsahr+k5epaD3n73ZSH1fa+gdIV+kcMe8GUCkvLHOaZ8LAXJUrGPe7eGeyWy+I+ub5W6CKm64orrPtFabX1FdxjWlZjZNCwRxblaHR8
 Gg2+fvzg
 0bJ6hzTCGQTk6bDJ5AYC2TBtLs1QGjvm354+6HuIokNpsF+0dLWxo/rovS5IEejN5gAh++nYkuUNPB/lrdYdkWX2H4mLbMh7fvOz3/5fYNC1BNRS79ZKr3PdPHHetqjoaqo4OzwVwrd2fRi0GJ2bJTqvtFF6j0sjuGnu+Y1xTPTa1J6Z3jcUUZji0NmhkDipEizep0E8xtL7srU32zBNIK+joucdKCOTUZzoRtiGcqm3qnRr1qfNWLs/KzAdj5pe6OpLOOKHTQwn5G7GIiChuxSNCxhZFsf2cxuVEA3cqRUpNulGJrS6vi/xsh5z3PHgovSqgcul8JHvymuC+ScmoS37/iCyQQiI00f1oA5Z0tTWTA315t5rR+hAVaEMdLdzbNpfe+ncJbiZ4nrbwHanHE6aKD/wq+c9MGN+Apz/DXcH7qtVvtFYMmrHOR2h9B7E2NU9DuS9GrqSDk2qA2fkBmzt5DdkY2P8YPuUcfmzSoyNo7T3uQyn4tCwKOgXsfyrygk6P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Yes, I know, this is a lot of changes. But I'm happy with the overall state
of the patchset and the only reason I tag it as RFC is that it is tricky
to get 57 patches upstream.

I wanted to give a view of the end state first. I will suggest a possible
way to split it below.

I would appreciate any feedback.

TL;DR
=====

This replaces khugepaged's anonymous collapse with an engine that
can collapse sub-PMD ranges. It is built around migration entries and
frozen folios instead of heavy locking and isolation, aiming for better
scalability and less disruption to the workload being collapsed.

Why
===

mTHP collapse landed in khugepaged in 7.2 and I was glad to see it.  We
at Meta run arm64 with 64K base pages, where a PMD is 512M: PMD-order THP
is of limited use at that size, and mTHP is exactly what we want.

It turned out not to help us.

khugepaged only ever looks at PMD-aligned windows, and it is not an easy
limitation to lift.

Fixing the alignment is a one-line change, but what it feeds assumes the
PMD everywhere that matters: collapse_huge_page() clears and flushes the
whole PMD whatever order it is collapsing, installs a PMD leaf because
that is the only thing it can produce, and keeps everyone out with
mmap_write_lock, anon_vma_lock_write() and an IPI broadcast while it
does.

Which is why hugepage_vma_revalidate() demands that the VMA span the
whole PMD even for an mTHP order -- "we'd need to lock all VMAs in the
PMD range to support this", as the comment there puts it.  A PMD-granular
operation is only safe when one VMA owns the PMD, and that is exactly the
restriction in the way.  The alignment is the symptom; the PMD is the
design.

So both roots have to go.

Design
======

The old mechanism holds the address space still because it has nothing
else stopping the sources from moving under the copy.  The new engine
makes the sources themselves inert instead, with the two barriers
migration already uses, raised in that order:

  1. migration entries replace the source PTEs.  Faults and GUP-slow
     now wait on the source folio's lock, which is taken before the
     first entry becomes visible.
  2. the source folio's refcount is frozen to its expected value.
     GUP-fast, pfn walkers, reclaim, compaction and memory-failure all
     fail folio_try_get() and back off.

Between the two, nothing can reach a source, so the copy runs with no
lock held at all -- and the address space is left alone while it does.

What that removes from every collapse path:

  mmap_write_lock              -> mmap_read
  anon_vma_lock_write()        -> nothing: an rmap walk needs the folio
                                  locked, and the engine holds that lock
                                  from freeze to putback
  tlb_remove_table_sync_one()  -> nothing: one ranged flush per round
  LRU isolation                -> nothing: sources are inert in place

Working in windows rather than whole PMDs takes care of the other root.
A sub-PMD window is collapsed under the page table lock, so a collapse
disturbs only the window it collapses, and each candidate is validated
at its own order -- a window need only fit its own VMA.  A PMD-order
candidate still has to own the whole PMD, which is the old rule kept
where it is still needed.

Candidates are carried through the passes a batch at a time rather than
one window at a time, so a round pays for its flush and its lock
acquisitions once.

With the barriers holding the sources still, which read lock the engine
takes stops being part of the design.  A round works inside a single
VMA, so patches 43-49 switch it from mmap_read to per-VMA locking: an
mmap_write elsewhere in the mm then stops waiting for a collapse that
has nothing to do with it.  That block is the only part of the series
that needs per-VMA locking to be unconditional, and it is a separate
dependency (see below); everything before it runs under mmap_read and
does not care.

Patch 7 sketches the engine as a comment naming every pass, what lock it
takes and what it may sleep on; the details are there rather than here.

What falls out beyond the lock diet:

 - mTHP collapse in VMAs smaller than a PMD, which is the arm64 case
   above: a 2M VMA on an arm64/64K machine collapses nothing today at
   any order, and collapses to mTHP here.
 - Hole and zeropage population at every order, so partially populated
   windows collapse to mTHP under the same max_ptes_none policy as PMD.
 - Sources come in spans -- any stretch of consecutive PTEs mapping
   consecutive pages of one folio -- so partially mapped and scrambled
   compound sources (the PTE-mapped-THP re-collapse class) work at
   every order.
 - A table that cannot become one huge page still yields the largest
   windows inside it, where before a single disqualified PTE gave up
   the whole table.

Reading the series
==================

57 patches is a lot to land on a list.  They go in blocks:

  1-6    helpers and shared state: pte_folio(), pte_none_or_zero(),
         mm/collapse.h, and the policy that replaces asking whether
         khugepaged started a collapse
  7-8    the engine's shape: entry points, a call-tree comment naming
         every pass, and the scan filled in
  9-23   the collapse half, top down: the round frame, then each pass
         in turn, then selection and the retry store
  24     per-candidate tracing, before the switch takes the old
         tracepoints away
  25-28  the switch: point the anon path at the engine, widen coverage
         to sub-PMD VMAs, delete the mechanism it replaces
  29-35  move what is left of collapse out of khugepaged.c, and
         MADV_COLLAPSE into madvise.c
  36-42  tracing: the engine's own events and trace header
  43-49  per-VMA locking, and the mm reference that makes it safe
  50-56  selftests for what the engine can now do
  57     MAINTAINERS

The two patches worth reading first if you read nothing else are 7 (the
design, as a comment naming the whole call tree) and 16 (the freeze,
which is where the safety argument lives).

A possible split, if that helps:

  1-2    two mm helpers, pte_folio() and pte_none_or_zero().  Both
         convert callers outside collapse and are useful on their own
  3-27   the engine and the switch-over.  This is the smallest unit
         that does anything: stop earlier and the tree carries an
         engine nothing calls
  28     remove the mechanism the engine replaces
  29-42  moving what is left of collapse out of khugepaged.c, and the
         engine's own tracepoints
  43-49  per-VMA locking
  50-57  selftests and MAINTAINERS

Keeping the removal separate leaves both engines in the tree with only
the new one reachable, so the switch can be reverted on its own if
something turns up.  The old mechanism is already carried that way for
three patches inside the series, so this costs nothing but 975 lines of
unreferenced code until 28 lands.  That safety net only lasts until the
blocks after it land, though: once collapse has moved out of
khugepaged.c and the locking has changed, reverting the switch no longer
gives back a working old engine.

Base and dependencies
=====================

This applies on the selftests series, not on plain mm-new:

  [PATCH v4 00/19] selftests/mm: improve khugepaged coverage
  https://lore.kernel.org/all/20260815015901.1236937-1-kirill@shutemov.name/

which is on mm-new 33f61b12d297.

Patches 43-49 depend on Suren's unconditional per-VMA locks:

  [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
  https://lore.kernel.org/all/20260813193433.3318288-1-surenb@google.com/

That series is not in mm-new yet, and with patch 46 applied SMP=n does
not build without it: lock_next_vma() is behind CONFIG_PER_VMA_LOCK in
mmap_lock.h.  Everything up to patch 42 builds and runs on mm-new as it
stands.  There is no fallback path by choice -- adding one would mean
carrying two locking models through every pass.

Both branches are available at

  git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git collapse/rfc-v1

and the benchmark used for the numbers below, which is unposted and not a
dependency, at

  git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git perf/bench-usemem

Performance
===========

Measuring khugepaged is awkward.  It is a background daemon, so what
matters is what a workload feels while it runs, not what the daemon
reports about itself -- and the usual coverage instrument is no help
below the PMD: smaps AnonHugePages only counts PMD-order folios, so it
reads zero however much mTHP has been collapsed.

So I wrote "perf bench mem usemem" for this.  It touches a region while
khugepaged works on it and reports the workload's own latency
percentiles and throughput, against per-size counters that can see
sub-PMD folios.  The branch is above; it is unposted and not a
dependency.

x86-64, production configs (no KASAN, no lockdep, no DEBUG_VM, no
PAGE_TABLE_CHECK), interleaved rounds on an idle host, equal work on
every arm.

I measured three kernels, so the two halves of the series can be told
apart in the numbers below:

  A   the base
  B   the new engine, still under mmap_read
  C   B plus per-VMA locking -- what this series ends up with

The engine: a sub-PMD collapse stops blanking the surrounding 2M
-----------------------------------------------------------------

base routes sub-PMD collapse through collapse_huge_page(), whose
pmdp_collapse_flush() and tlb_remove_table_sync_one() are not gated on
order: to collapse an order-4 window of 16 pages it clears and flushes
the whole 512-page PMD and IPIs, then repopulates.  The engine does the
window under the PTL.

A thread reading and writing a 32G region while it is collapsed at
order-4, 16384 collapses on every arm:

                         A        B        C
  read p99 (ns)       3071     1023     1023   -66.7%
  write p99 (ns)      3071      927      927   -69.8%

and the workload's read rate rises by 68% on both engine kernels.

B == C, so this is the engine, not the locking.

At PMD order the same workload is flat, and that is expected rather
than disappointing: it is the one configuration where both mechanisms
disturb exactly the same 2M.  Read it as no regression at PMD order.

Per-VMA locking: address-space operations stop waiting on the scan
-------------------------------------------------------------------

MADV_HUGEPAGE/MADV_NOHUGEPAGE toggling against a scanning mm, which is
what jemalloc does with its arenas.  4096 collapses on every arm:

                         A        B        C
  ops/sec           340656   340820   603305   +77%
  p99 (ns)           77823    86015     3327   -96%
  p99.9 (ns)         86015    94207     9215   -89%

B is about 11% worse than base at p99 here, consistently across runs:
the engine alone slightly worsens hint-toggle latency, and per-VMA
locking is what turns it into a win.  Both halves are in this series, so
C is what a reviewer gets, but the middle column is the honest one.

The trade is real in the other direction too.  On settled memory with
nothing to collapse and scan_sleep_millisecs=0, per-VMA locking costs
about 47% of scan throughput against one mmap_read for the whole walk.
That is a synthetic worst case -- the daemon wraps 8000 times a second
there, where production defaults to 10s between passes -- and it buys
mmap/munmap p99 of 56us against 1.4us.

Collapse itself is not slower
-----------------------------

One complete pass over a 32G region, 16384 collapses, khugepaged CPU
from /proc/<pid>/stat, 7 repeats:

  A base    median 5760 ms   spread 12.7%
  B engine  median 4990 ms   spread  3.8%
  C pervma  median 5020 ms   spread 12.4%

The base arm is bimodal, so its median moves with sampling and the
percentage is soft.  The distribution-free statement is better: every
engine run used less CPU than every base run.

The engine also allocates one destination per folio installed, where
base allocates 5.25 and frees the rest again: nothing is allocated until
the sources are frozen and the collapse can no longer be refused.

A measurement note, since an earlier version of this series quoted worse
figures.  khugepaged CPU has to be measured per collapse or per
completed pass, never over a fixed window with scan_sleep_millisecs=0:
the daemon never sleeps, so whichever kernel finishes the work sooner
spends the rest of the window scanning settled memory and is charged for
it.  Measured that way the engine appeared to cost 10% more CPU;
measured per unit of work it costs less.

Costs
=====

At PMD order the engine issues two TLB flushes per collapse where the
old mechanism issues one: the freeze's ranged flush plus the terminal
layer's pmdp_collapse_flush().  A PMD candidate is alone in its round,
so nothing amortizes the first.  Dropping the old per-collapse
tlb_remove_table_sync_one() IPI presumably pays for it, but that was not
measured and is not claimed here.

There may be a way out -- a PMD migration entry over the table during
the window, so the CPU never caches a walk to shoot down -- but that
means teaching every pmd-level walker a new kind of entry, and I have
not tried it.

PMD collapse deposits a freshly allocated page table instead of
redepositing the detached one.  Whoever withdraws a deposited table
frees it immediately, with nothing to hold a lockless walker off first,
and under a read lock the detached table may still be traversed by
GUP-fast or an RCU pte walk.  It goes to pte_free_defer() instead,
exactly as retract_page_tables() does.  One transient table page per PMD
collapse buys the IPI's absence.

That cost goes away if zap_deposited_table() -- the only site that frees
a deposited table outright, the others redeposit it or repopulate the
PMD with it -- used pte_free_defer().  The deposit would no longer have
to be quiescent and the detached table could go straight back.  It would
defer every THP zap's table free, and I have not tried it.

A shared source now costs an extra copy.  The freeze needs every page
exclusive to this mm, so the fault-in pass breaks CoW first -- an
allocation and a copy -- and the collapse then copies that page into the
destination; the old mechanism copied a shared page straight into the
new folio and broke the sharing that way.  It is bounded by
max_ptes_shared, which khugepaged holds at zero below the PMD order, so
in practice this is PMD-order collapse and MADV_COLLAPSE.

Size
====

mm/ grows by 1915 lines net: 4475 added against 2560 deleted.

That is not a claim that this is less code, but it is less than it
looks.  khugepaged.c goes from 3283 lines to 908.  The new engine is
4052 lines across mm/collapse.c and mm/collapse.h, of which 1344 --
about a third -- are comments, which is where the pipeline's invariants
are written down.  What replaces three install paths with their own
isolate/copy/rollback is one engine and one contract.

Testing
=======

Both matrices run the mm selftests plus a race harness, on the
validation config: KASAN, lockdep, PROVE_LOCKING, DEBUG_VM and
PAGE_TABLE_CHECK, 16G of guest memory, swap active so the swap-in
prepass is exercised rather than skipped.

  x86-64        433 pass, 0 fail, 12 skip
  arm64/64K     581 pass, 0 fail, 18 skip

dmesg clean on both.  The arm64 skips are a pre-existing shmem
MADV_COLLAPSE -EINVAL on 64K pages, confirmed against the base by A/B.

Every one of the 57 patches builds with no new warnings; !NUMA and !MMU
(arm nommu) build clean.  SMP=n does not build, for the reason in the
dependencies section above.

The race harness also gets longer soaks -- 1800s per driver mode, with
memory pressure and swap -- and the engine is fuzzed with syzkaller on a
KCOV+KASAN build.  That found two bugs the selftests could not reach: a
teardown that dropped rmap while the source was still frozen, where
removing an mlocked mapping munlocks and munlock_folio() takes a
reference a frozen folio forbids; and a whole-table MADV_DONTNEED racing
the copy window under CONFIG_PT_RECLAIM, which freed the table and left
the sources frozen and locked.  Both are fixed, and both gained coverage
-- the mlocked case is patch 53.

Kiryl Shutsemau (Meta) (57):
  mm: add pte_folio()
  mm: add pte_none_or_zero()
  mm/collapse: add collapse.h for the shared collapse state
  mm/collapse: rename mthp_present_ptes to eligible_ptes
  mm/collapse: state what a collapse may do in the policy
  mm/collapse: move the smallest collapse order to collapse.h
  mm/collapse: sketch the new anonymous collapse engine
  mm/collapse: scan a table for what a collapse could use
  mm/collapse: collect candidate windows into a round
  mm/collapse: run a round and feed the outcomes back
  mm/collapse: sketch the passes of a round
  mm/collapse: allocate a destination per candidate
  mm/collapse: revalidate a round against the VMA
  mm/collapse: fault the sources in before the freeze
  mm/collapse: check what a candidate would freeze
  mm/collapse: freeze the sources behind migration entries
  mm/collapse: copy the sources into the destinations
  mm/collapse: install the destinations at PTE level
  mm/collapse: install a PMD leaf as the terminal layer
  mm/collapse: put the sources back
  mm/collapse: settle whatever the round reached
  mm/collapse: walk a table with a selection cursor
  mm/collapse: give a refused region a second chance
  mm/collapse: report each candidate's outcome to tracing
  mm/collapse: collapse anonymous memory with the new engine
  mm/collapse: give collapse_single_pmd() the range to work on
  mm/collapse: scan the windows a VMA can hold
  mm/collapse: remove the mechanism the engine replaces
  mm/collapse: move what a collapse is judged on into collapse.c
  mm/collapse: name the max_ptes ceiling after collapse
  mm/khugepaged: count collapses where khugepaged makes them
  mm/collapse: move the file collapse into collapse.c
  mm/collapse: split collapse into a scan and a run
  mm/collapse: implement MADV_COLLAPSE in madvise.c
  mm/madvise: drop MADV_COLLAPSE's redundant mm reference
  mm/collapse: report what the scan found
  mm/collapse: report what the fault-in pass paid
  mm/collapse: report the round, and what it made faulters wait
  mm/collapse: name the file collapse's tracepoints after collapse
  mm/collapse: remove the tracepoints of the mechanism that is gone
  mm/collapse: give collapse its own trace header
  mm/collapse: allow error injection into the freeze
  mm/khugepaged: check the scan budget before the work, not after
  mm/khugepaged: hold the address space open across a scan
  mm/collapse: take a per-VMA read lock for the round
  mm/khugepaged: scan under a per-VMA read lock
  mm/madvise: collapse under a per-VMA read lock
  mm/collapse: assert the mm reference the engine relies on
  mm/khugepaged: drop the mmap_lock barrier from __khugepaged_exit()
  selftests/mm: attribute collapses by candidate event alone
  selftests/mm: cover collapse inside a sub-PMD VMA
  selftests/mm: cover a hole-y window in a sub-PMD VMA
  selftests/mm: cover collapse of mlocked ranges
  selftests/mm: cover collapse beside a MADV_FREE'd page
  selftests/mm: cover collapse beside a pinned page
  selftests/mm: cover the scaled max_ptes_shared limit
  MAINTAINERS: add an entry for collapse

 MAINTAINERS                                   |   19 +-
 fs/proc/task_mmu.c                            |    4 +-
 include/linux/huge_mm.h                       |    9 -
 include/linux/mm.h                            |   14 +
 include/linux/pgtable.h                       |   17 +
 .../events/{huge_memory.h => collapse.h}      |  176 +-
 kernel/bpf/btf.c                              |    8 +-
 mm/Makefile                                   |    2 +-
 mm/collapse.c                                 | 3808 +++++++++++++++++
 mm/collapse.h                                 |  244 ++
 mm/hugetlb.c                                  |    8 +-
 mm/khugepaged.c                               | 2711 +-----------
 mm/madvise.c                                  |  251 +-
 mm/migrate_device.c                           |    9 +-
 mm/mremap.c                                   |    2 +-
 tools/testing/selftests/mm/khugepaged.c       |  346 ++
 tools/testing/selftests/mm/khugepaged_race.c  |   29 +-
 .../selftests/mm/khugepaged_sync_check.c      |   65 +-
 tools/testing/selftests/mm/vm_util.c          |    2 +-
 19 files changed, 5022 insertions(+), 2702 deletions(-)
 rename include/trace/events/{huge_memory.h => collapse.h} (60%)
 create mode 100644 mm/collapse.c
 create mode 100644 mm/collapse.h


base-commit: 8b76faf42c5d342b3bf0b1fd97bdaf603ee57354
-- 
2.54.0


