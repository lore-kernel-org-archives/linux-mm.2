Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE00EC9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8637C6B008C; Mon, 28 Sep 2026 06:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83A5F6B0092; Mon, 28 Sep 2026 06:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB0E6B0093; Mon, 28 Sep 2026 06:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2265F6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8002D16016A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:36 +0000 (UTC)
X-FDA: 85262741592.14.3449B68
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf29.hostedemail.com (Postfix) with ESMTP id 75758120004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="m6wNgDi/";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=cauArhPW;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790589994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EKIdzuDYbjcnXOkZ7ilx5rv6C2LEWwPh1FJ9o1lqTmo=;
	b=LlcchQ4dAGqNOfv0QKK13femqql5VNsnWkRhSmnEq3wRxjviMma2Ik6vpNl33xDtYCfegj
	giOJDwm1jJlOML1oE3dmfEwvKcFYsMBHUwKI1712uSWcx5RtgH195zVXHw060Q6/ZXzggX
	qR4sSvqgCNb4gowETJeuPkPYzCwEr80=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790589994;
	b=618ecUHa+qQSGI+6BAb7SPPziTCNeCEWcwMnmJOg0xntbV75dE4QDqi50uWnELzyBvJZDr
	i6abbM9BWz368GkowqdoX1p2HOYq4kQKIoazpf47UTK/6/d+YcBpO4kyfL0xg+vQlJsTU/
	sKsEoehovQ7uXaXLqsyfiQZu9OxPs9k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="m6wNgDi/";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=cauArhPW;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id D5CABEC005A;
	Mon, 28 Sep 2026 06:06:33 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 28 Sep 2026 06:06:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1790589993; x=1790676393; bh=EKIdzuDYbj
	cnXOkZ7ilx5rv6C2LEWwPh1FJ9o1lqTmo=; b=m6wNgDi/UKuoa09Va593GWDuTt
	huGnALEr8V2IPRx2K7QexaD6Mp6gtfST6PF9bpmiqlkKdXyIWiiJDIksT9wWPGsn
	0qn8Io+inAyRXmmsbdWsaoNt3/lRDErFwzSMseGdqrjBiFM1rQqkCf0e81BWprae
	LbKgmBBssuBK4r0VwPzyU/8Q771TvhxsH7xls4cqxEUGDup1XHgFt4TAZTvw6hcj
	P4ZqDCKt0pDIB7O0nstcDn1Nhd+3YBpBXr7mglM0KcyIj0dajs5OEkTgUaLwBS+I
	ReufuEJSBEX2Es1l5ao9tY/pAAj9OConcbzTNmMXkuqzUDwkvBTzVqxmto5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790589993; x=1790676393; bh=EKIdzuDYbjcnXOkZ7ilx5rv6C2LEWwPh1FJ
	9o1lqTmo=; b=cauArhPWE3Bi25RaEEN/MjyKzbm2BWPqnRRF1Ph5h0wZ4UKkvIp
	QdWDaXMiNP0GhjuoHKlo2/ejx2BOIjDbDiNDsECY2A8vePQhQlgxLJzIgaGNIfdg
	94X9sgRLvNX0QR2Ke7B0355iLZT60bIzfJzpVJAy28EbXxkMhEPMAKh1psFcURAt
	vaBhpBvwABXPkKH5cXszAYr9dvoz2IOTDGVnTjzKuGmDQg8hcUmkOIihqqnpFlyS
	I77+grxf+PiZQFW+zL/RxdS06o6UsYvRz2hHFR6z8pji9TvUDfvm6PX01b/zxn3T
	+lrQxX85Su6oojmW4I4pLvS8xoHz9r8wP7w==
X-ME-Sender: <xms:KDy6agGq-pLyw04iUlt1BdzYP5XSwgjnJT_iUuoRorHQGyoSubCaSg>
    <xme:KDy6alQHqKmCagJWvwh_T2NLV1DlK5x3QAXU5gFnzNPOM1sZz0860BReRrAR4n795
    W1D1vh6BF5frOeWjRm3rcGNsRvjzrD-mJCxiu7aO23Vm9ouEF3BXw>
X-ME-Received: <xmr:KDy6agQzco8l7ty5qDgrczfl-2gWkDETw88J1wCy5cfAJTJrMZSpUTMJYC4>
X-ME-Proxy-Cause: dmFkZTE2O5abtobnv+lIS6a3Y/NupWRqh9S6xuTRe6ms+TtIA7iJC+oqo7j+Okki1Rz6Yk
    AN0kGqJwosM2/mIjpzYu7sPuLSo4LvS5+owwkoH7RcSsv9BrgcJ+rf8deZvR1wMXbV4kMw
    LjFU8u4SdUuxq5zqrWVenR6NhqJJ0YTlin8Z3SquObO7m4/3zUqC6Krc9BrNHzJbflFtcI
    9W3+DAc4Txem8aE4HxLsnIzQ3294ahdRFDXtMoY2wLc+RIOmUlqe+/XhgCbspJnJr+pqx0
    5wLiZpJwYdpAD/M6xNUQNKpuA2bvGmEc5CrIPVDzwrqCIeZ8M363KAubJqtdn532MKLPtL
    NwyoB3TP2BdqvWO6labtR93TfEvFAdagQdVIAqsc1iTVvaHXwNoSnLQlsKxsvSLlIPv6Qb
    /ZauXavmaEhNrqrxoYxeVoamRBeOcszDwqjRWwnygQSqFdzG+FDRcaFhscRKi6XPdnD/zy
    LRrRjoSUoq7rW+1bP5/3hSiLcrSnzqEe5sbHmvj/DDTzTOJDZN/U9qUeD7ZWAq3uhsDNqU
    lboASvlHX52S7mqynw/sTXNC/JDFfQBIAStSpj1n5ieFzgt5L66WR1GMP6LpgARL52hUjA
    0KIPftsvPIBnwr5oSYv/gG5P9QdZA2cOI2ejv0FIK8KZvY05onxa0qOtNQyg
X-ME-Proxy: <xmx:KDy6aocpy0-S851V84L15Vjy1k1lP6Ln3qb5jgGvEuG2jSw8YfwAHQ>
    <xmx:KDy6akerA-j6Crl3X3BF5q1I26ElK-4xUnkisUe6d1RH2Z65hJ-XWw>
    <xmx:KDy6au9SDio4Ee-xSMYAOidrRZW8RqzlbkBzVsrHejdiIgAzZ4gCOA>
    <xmx:KDy6akMpj8fsFHfVxZkRYCiDQGUiwucp7uTxyLpe9AKZ3vGuW2IQUQ>
    <xmx:KTy6avEZkvOIPWgq6sEDKmwZaMNlmRlThHpuVnJ1jRAxXU12BZXpmwx_>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:32 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v4 00/13] mm/collapse: separate a collapse from its callers
Date: Mon, 28 Sep 2026 11:06:14 +0100
Message-ID: <20260928100630.21870-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 75758120004
X-Stat-Signature: kak15i6b83yb8fr5kobn453cdicmpjxp
X-HE-Tag: 1790589994-414517
X-HE-Meta: U2FsdGVkX1+sOm9vHbGp+ry1le8dHWEN89XRwwLfeqr1C2vb9gGiaUc1W6dFbaWXnzX/NnXXrM/M27+R6b5CEEVrFgZzm6Axj8YSrN+DPBWHw8wj+k2X2sHjXj36YmUdeGYjC7wAuFFFsQGzcUvkcbL55UBeKx9qNak/aJW/1KYONEre1YaGj3i50poEpJfPDBUdV8NlQnLe353HbHwvvo1MsSD99FBddjiYrFC7cjVGPgG0pZHGWiKIPtyyhi5X9kB57GYySQN+w3f7EkvncVs9VXdFxB5tbps/lWhRLG7zDU6ZrIecD42JHeA3DGCBDXc0wji9lGayS9ipxkOl+FbCssCf5z2nTrDyz2eTwxpvtxDPZSEa7gAfrTkq4PlsC3gvUJi/6SWftngMkH0N1UY8IEj081ljiBR/3b3vCmVRAG/SwOaMr9+Htg9b0fYGBQLfnUI2rC9hiPK3V7ncTJwKRPrhkMqwOSHZwAufDKnsmjh3vOzOSQPYJogJqIFQL3DqF66tOb5uqeGrMFUYqoU2ixR36s+Zevb5LvzCs8zzAT1QJNZw+MUcDMIu7VBHRXh9el+WkZe13TTd7GtVZEa+CpZNrnNKUkGBuajRrgQsjwR56UO8Db9G2HQ5tI5to1KQcPBaih4NSNjkSbNZ3CYHBI1hNTjP8qGBuQtlqUBeSpvkNswwfGo1AGMuSmp1TfoX/0IgQqcwEdgiIPzEmZkUh3zwRm1dgFk7dFxfoH0qdKvcFII3Sicfd/SdMgePog+byrDc/DznpRdcm2lK/Wy5WV+2b5Sy5QUbHD8YPUvHG4HiSQ4XoPAhN8Ym4LN7Qll8bNH1ja3o+pkliTkG9u5o5u++qBkVPY+7h5qYZRsVEnuUDJLgR1i8hm9bn1d6qwZlQ5Pd5lotMFKvRBjTXsDR6Y7e0dFZjE08aT4CAu9NhCN+C7/0a1CIi93MHGjlschmiWv3GjYSTNuasun
 iTqfmnwu
 6AUl3TNas66J1xe58E/nc1hXFOyquyX0IS3I5lVZbz4bLpt7qUrFKwh3iBa2KzSUdSbMImMmmt+wJjn85x5+fBp0/gskQGeYoOHb2rVSSiaekDzkv2aSg3uvEaJAqSdYwg2NnQ81a9RyEvycbuvRGcJzQyn9PZwrJvB5GLY2gXVmAR2rlvfCnSUm9UEaaEn340QAgbaGZTzBOhmDpAeyN4tlWIpE1Wr08/AM79x2H49Ja+bdIvzLA3UYvmpWQlHk6lcpCCOQT/LJewaCNMKXyoL9qIoft77Ycjj80zdIBSWFzHhMBDsfKCFczUK1d2hxOKoHzpuXqqQby3zHoIeoAkniPR8uLas9kuxTVnZ9ExPcd/eTvk+VSXe+bP9yVpgTqhnkL+pd8984gohdAC7RCFdhPOImGNkgo8smARGRzSzbo7CdVXGxcDefdvS4uXwgxhYnwqlKKTLccUfivA3bMQCJyZur73dBXrwERREijfHDbqIzjJASivbasRngyOtUVQO7fJOM2/qpOn3kppEJhEdVCbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

[ This is the first of the cleanups I said I would front-load ]

There is no line between the collapse engine and the callers that ask for
a collapse.  khugepaged.c holds both, and they reach into each other.

 - Sixteen tests through the collapse path read cc->is_khugepaged to work
   out what they are allowed to do, when every one of those decisions was
   made by the caller before it asked.

 - collapse_single_pmd() does both halves of a collapse behind one call and
   drops mmap_lock somewhere in the middle.  Which of its paths dropped it
   is not something a caller can see, so it hands back a bool and the
   caller keeps track.

 - MADV_COLLAPSE's implementation -- the walk over the user's range, the
   per-PMD loop, the errno translation -- sits in khugepaged.c, which is
   the daemon's file.

So: draw the line.  State what a caller allows in a policy, split the call
in two with the lock as the boundary, and move the syscall to madvise.c.
What the engine offers is then three calls, with the lock state written
down against each, and a policy the caller fills for itself:

    collapse_control_init(cc)         once, before the first table
    collapse_policy_*(&cc->policy)    what this caller allows
    collapse_scan_pmd(vma, addr, ...) per table, under mmap_lock
    collapse_run_pmd(mm, addr, ...)   when a scan found work, no mmap_lock

The engine stays in khugepaged.c for now; what changes is that it has an
interface, and that neither half has to ask about the other.  madvise.c
gains the operation it should have had all along.

Changes since v3
================

  https://lore.kernel.org/all/20260916093145.4022188-1-kirill@shutemov.name/

 - Patch 5: the PTE limits come as two sets, struct collapse_limits for a
   PMD-sized window and one for anything smaller, and the strict_sub_pmd
   flag goes.  The warning for a max_ptes_none between 0 and the maximum
   moves to where khugepaged fills its policy.  The fields only one side
   reads are prefixed anon_ or file_.  collapse_policy_forced() is
   collapse_policy_madvise() (David).

 - Patch 8 is new: collapse_file() is called from collapse_single_pmd()
   rather than from inside collapse_scan_file(), so the file scan stops at
   the decision before the scan/run split.  The writeback retry and the
   tracepoint change move into it, so patch 9 is only the split (David).

 - Patch 9: no collapse_control_release().  It had nothing to release in
   this series; it comes back with the engine, where init allocates.  The
   check that the last scan was run stays at the top of collapse_scan_pmd()
   (David).

 - Patch 10: the changelog says why the lock boundary belongs to the
   caller (David).

 - Patch 11: both callers pass their TVA type as the literal it is rather
   than reading it back from the policy (David).

 - Patch 12: kerneldoc on every function collapse.h declares (David).

 - Acked-by from David Hildenbrand on 1-4, 6 and 7; Reviewed-by from
   Baolin Wang on 10.  Reviewed-by dropped from 5 and 9, which changed.

Changes since v2
================

  https://lore.kernel.org/all/20260910120238.2529819-1-kirill@shutemov.name/

 - Patch 8: the file scan returns SCAN_PTE_MAPPED_HUGEPAGE as it is and
   the run is handed what the scan returned, so it goes straight to
   retracting the PTE table when it sees it.  The scan_retract_only flag
   and the result round trip go, and the two copies of the file put become
   one helper (Zi).  Patches 9-12 follow the new signature.

 - Patch 8: mthp_collapse() and collapse_huge_page() read the orders and
   the referenced and swapped-out counts from collapse_control instead of
   taking them as arguments (Baolin).

 - Patch 11: each interface function is documented where it is defined,
   with the lock state on entry and exit.  The overview in collapse.h
   stays (Zi).

 - Reviewed-by from Zi Yan on 8 and 9, and from Zi Yan and Baolin Wang
   on 5 and 10.

Changes since v1
================

  https://lore.kernel.org/all/cover.1788533997.git.kas@kernel.org/

 - Rebased onto mm-new with Vernon Yang's tracepoint fixes in it.  Patch 8
   no longer merges the two calls to each scan tracepoint, since the base
   already has one; its changelog now says what the status field reports.

 - Patch 3: nr_occupied_ptes is nr_eligible_ptes, and the mthp_collapse()
   comment counts eligible PTEs too (Zi, Baolin).

 - Patch 4: no comments on the two constants (Baolin).

 - Patch 5: one line per policy field (Baolin).

 - Patch 8: the file side is split like the anonymous one (Zi).
   collapse_scan_file() runs under mmap_lock in the scan and only reads;
   collapse_file() runs in the run.  See Behaviour below.

 - Reviewed-by from Zi Yan and Baolin Wang on 1-4, 6 and 7.

Patches
=======

The first three stand alone and can be taken separately:

  1  drop the mmgrab() MADV_COLLAPSE has held since 7d8faaf15545
  2  count collapses in khugepaged's own walk, where the daemon's
     bookkeeping belongs
  3  rename cc->mthp_present_ptes to eligible_ptes, which is what a set
     bit means

Then the interface, in order:

  4  add collapse.h, and move enum scan_result, struct collapse_control
     and the two constants into it
  5  struct collapse_policy, filled by the caller; the is_khugepaged
     tests become field reads, and the flag goes
  6  drop collapse_possible(), a wrapper that only turns a mask into a bool
  7  collapse_control_init_scan() is a per-table reset, so name it
     collapse_scan_reset()
  8  call collapse_file() from collapse_single_pmd(), so the file scan
     stops at the decision
  9  give the scan and the collapse a function each: collapse_scan_pmd()
     and collapse_run_pmd()
 10  open-code the entry point that joined them, so each caller owns the
     lock across the boundary and the bool goes
 11  work out the orders a VMA allows once per VMA, not once per table
 12  declare the three calls in collapse.h, with the lock rules
 13  MADV_COLLAPSE moves to madvise.c

Behaviour
=========

No functional change is intended.  Nothing here changes which tables get
collapsed, into what, or what MADV_COLLAPSE returns.  The tracepoints are
the one place a change can be seen from outside; the rest is where work
happens, not what it does.

 - Patches 8 and 9: mm_khugepaged_scan_file and mm_khugepaged_scan_pmd
   fire before the collapse rather than after it.  For an accepted table
   their status field reads SCAN_SUCCEED, where it used to carry what the
   collapse made of the table; that is now for mm_khugepaged_collapse_file
   and mm_collapse_huge_page to report.

Four things move that a reader should not have to find in the diff:

 - Patch 5: khugepaged fills its policy once per scan pass, so the
   max_ptes_* limits and the defrag setting behind the allocation mask are
   sampled once per pass rather than once per table.  A knob written
   mid-pass takes effect on the next pass instead of the next table.

 - Patch 8: the writeback retry re-runs collapse_file() alone, where it
   used to rescan the page cache first.

 - Patch 9: the file scan runs under mmap_lock, where before the lock was
   given up first.  A file table the scan refuses no longer costs
   khugepaged an unlock, a trip back through khugepaged_do_scan(), a
   relock and a VMA lookup; only a table it goes on to collapse does.

 - Patch 11: which orders a table is scanned for is sampled once per VMA
   rather than once per table.  It cannot widen what a collapse does; the
   order is tested again under the lock the collapse retakes.

For an anonymous table, and for a file table that gets collapsed, the lock
is given up and taken again at exactly the points it was before; the only
difference is that the caller is the one doing it.

selftests/mm khugepaged passes on x86-64 with a KASAN, lockdep and
DEBUG_VM config, in the five forms run_vmtests.sh runs it.  Every patch
builds, CONFIG_TRANSPARENT_HUGEPAGE=n included.

Kiryl Shutsemau (Meta) (13):
  mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
  mm/khugepaged: count collapses where khugepaged makes them
  mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
  mm/collapse: add collapse.h for the collapse interface
  mm/collapse: state what a collapse may do in the policy
  mm/collapse: drop the collapse_possible() wrapper
  mm/collapse: name the per-table scan reset for what it resets
  mm/collapse: call collapse_file() from collapse_single_pmd()
  mm/collapse: separate scanning a PTE table from collapsing it
  mm/collapse: open-code collapse_single_pmd() in its two callers
  mm/collapse: work out the orders a VMA allows once per VMA
  mm/collapse: declare the collapse interface in collapse.h
  mm/collapse: implement MADV_COLLAPSE in madvise.c

 MAINTAINERS             |   1 +
 include/linux/huge_mm.h |   9 -
 mm/collapse.h           | 162 +++++++++++
 mm/khugepaged.c         | 620 +++++++++++++++++-----------------------
 mm/madvise.c            | 170 ++++++++++-
 5 files changed, 590 insertions(+), 372 deletions(-)
 create mode 100644 mm/collapse.h


Range-diff against v3
=====================

 1:  c777058f55c5 !  1:  73d87f3454b0 mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
    @@ Commit message
         Drop the mmgrab()/mmdrop() pair.
     
         Assisted-by: LLM
    +    Acked-by: David Hildenbrand (Arm) <david@kernel.org>
         Reviewed-by: Zi Yan <ziy@nvidia.com>
         Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
 2:  45e08a1d7aca !  2:  095b43905bd6 mm/khugepaged: count collapses where khugepaged makes them
    @@ Commit message
         its own counter without the shared path testing who called.
     
         Assisted-by: LLM
    +    Acked-by: David Hildenbrand (Arm) <david@kernel.org>
         Reviewed-by: Zi Yan <ziy@nvidia.com>
         Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
 3:  8caa0e047559 !  3:  66802b5676a3 mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
    @@ Commit message
         No functional change.
     
         Assisted-by: LLM
    +    Acked-by: David Hildenbrand (Arm) <david@kernel.org>
         Reviewed-by: Zi Yan <ziy@nvidia.com>
         Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
 4:  b7a8d6ebd4ce !  4:  22f00b9a706d mm/collapse: add collapse.h for the collapse interface
    @@ Commit message
         No functional change.
     
         Assisted-by: LLM
    +    Acked-by: David Hildenbrand (Arm) <david@kernel.org>
         Reviewed-by: Zi Yan <ziy@nvidia.com>
         Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
 5:  c6441dd38fe2 !  5:  4b9e43984bc9 mm/collapse: state what a collapse may do in the policy
    @@ Commit message
         Every test becomes a read of a field, and cc->is_khugepaged goes, having
         no reader left.
     
    +    The PTE limits come as two sets, one for a PMD-sized window and one for
    +    anything smaller, so that the helpers pick a set for the order and read
    +    it.  khugepaged takes no swapped-out or shared PTE into a sub-PMD window,
    +    and empty PTEs only when the knob says all or nothing; the warning for a
    +    knob value in between moves to where khugepaged fills its policy.  The
    +    fields only one side reads say which: anon_ or file_.  David Hildenbrand
    +    asked for both.
    +
         khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
         call.  That is the one change in behaviour.  The max_ptes_* limits and the
         defrag setting behind the allocation mask are sampled once per pass rather
    @@ Commit message
         cc unconditionally, so the check was already dead.
     
         Assisted-by: LLM
    -    Reviewed-by: Zi Yan <ziy@nvidia.com>
    -    Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## mm/collapse.h ##
    @@ mm/collapse.h: enum scan_result {
      	SCAN_PAGE_DIRTY_OR_WRITEBACK,
      };
      
    -+/* What a collapse is allowed to do, decided by the caller that asks for it */
    -+struct collapse_policy {
    -+	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
    ++/* How many PTEs of a window may be missing, swapped out or shared */
    ++struct collapse_limits {
    ++	/* Counted over a PMD-sized window; HPAGE_PMD_NR means "no limit" */
     +	unsigned int max_ptes_none;
     +	unsigned int max_ptes_swap;
     +	unsigned int max_ptes_shared;
    ++};
     +
    -+	/* Take no swapped-out or shared PTE into a sub-PMD collapse */
    -+	bool strict_sub_pmd;
    ++/* What a collapse is allowed to do, decided by the caller that asks for it */
    ++struct collapse_policy {
    ++	/* Limits for a PMD-sized window */
    ++	struct collapse_limits pmd;
    ++
    ++	/*
    ++	 * Limits for a smaller window.  Its max_ptes_none is either 0 or
    ++	 * COLLAPSE_MAX_PTES_LIMIT, the latter meaning all but one PTE of the
    ++	 * window whatever its order; any other value counts as 0.
    ++	 */
    ++	struct collapse_limits sub_pmd;
     +
     +	/* Leave clean lazyfree folios to reclaim rather than collapse them */
    -+	bool skip_lazyfree;
    ++	bool anon_skip_lazyfree;
     +
    -+	/* Refuse a range with no sign of use */
    -+	bool require_referenced;
    ++	/* Refuse an anonymous range with no sign of use */
    ++	bool anon_require_referenced;
     +
     +	/* Map the PMD over a file collapse instead of leaving it to a fault */
    -+	bool install_pmd;
    ++	bool file_install_pmd;
     +
     +	/* Write dirty pages back and retry once instead of refusing them */
    -+	bool writeback_dirty;
    ++	bool file_writeback_dirty;
     +
     +	/* How hard to try for a destination folio */
     +	gfp_t gfp;
    @@ mm/khugepaged.c: static bool pte_none_or_zero(pte_t pte)
      		struct vm_area_struct *vma, unsigned int order)
      {
     -	const unsigned int max_ptes_none = khugepaged_max_ptes_none;
    -+	const unsigned int max_ptes_none = cc->policy.max_ptes_none;
    ++	unsigned int max_ptes_none;
      
      	if (vma && userfaultfd_armed(vma))
      		return 0;
    @@ mm/khugepaged.c: static bool pte_none_or_zero(pte_t pte)
     -	if (!cc->is_khugepaged)
     -		return HPAGE_PMD_NR;
     -	/* for PMD collapse, respect the user defined maximum */
    --	if (is_pmd_order(order))
    -+	/* The limit as given, at the PMD order and wherever it is not capped */
    -+	if (is_pmd_order(order) || !cc->policy.strict_sub_pmd)
    - 		return max_ptes_none;
    - 	/*
    - 	 * for mTHP collapse with the sysctl value set to COLLAPSE_MAX_PTES_LIMIT,
    -@@ mm/khugepaged.c: static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
    + 	if (is_pmd_order(order))
    +-		return max_ptes_none;
    +-	/*
    +-	 * for mTHP collapse with the sysctl value set to COLLAPSE_MAX_PTES_LIMIT,
    +-	 * scale the maximum number of PTEs to the order of the collapse.
    +-	 */
    ++		return cc->policy.pmd.max_ptes_none;
    ++
    ++	/* Below PMD order: all but one PTE of the window, or none */
    ++	max_ptes_none = cc->policy.sub_pmd.max_ptes_none;
    + 	if (max_ptes_none == COLLAPSE_MAX_PTES_LIMIT)
    + 		return (1 << order) - 1;
    +-	/*
    +-	 * For mTHP collapse of values other than 0 or COLLAPSE_MAX_PTES_LIMIT,
    +-	 * emit a warning and return 0.
    +-	 */
    +-	if (max_ptes_none)
    +-		pr_warn_once("mTHP collapse does not support max_ptes_none"
    +-		     " values other than 0 or %u, defaulting to 0.\n",
    +-		     COLLAPSE_MAX_PTES_LIMIT);
    + 	return 0;
    + }
    + 
    +@@ mm/khugepaged.c: static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
    + static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
      		unsigned int order)
      {
    - 	/*
    +-	/*
     -	 * For MADV_COLLAPSE, do not restrict the number of PTEs that map shared
     -	 * anonymous pages.
    -+	 * A sub-PMD window held to the strict rule takes no shared page at all:
    -+	 * an mTHP is not worth the CoW-breaking.
    - 	 */
    +-	 */
     -	if (!cc->is_khugepaged)
     -		return HPAGE_PMD_NR;
     -	/*
    @@ mm/khugepaged.c: static unsigned int collapse_max_ptes_shared(struct collapse_co
     -	 * are shared between processes.
     -	 */
     -	if (!is_pmd_order(order))
    -+	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
    - 		return 0;
    +-		return 0;
     -	/* for PMD collapse, respect the user defined maximum */
     -	return khugepaged_max_ptes_shared;
    -+	return cc->policy.max_ptes_shared;
    ++	if (is_pmd_order(order))
    ++		return cc->policy.pmd.max_ptes_shared;
    ++	return cc->policy.sub_pmd.max_ptes_shared;
      }
      
      /**
    -@@ mm/khugepaged.c: static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
    +@@ mm/khugepaged.c: static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
    + static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
      		unsigned int order)
      {
    - 	/*
    +-	/*
     -	 * For MADV_COLLAPSE, do not restrict the number PTEs entries or
     -	 * pagecache entries that are non-present.
    -+	 * A sub-PMD window held to the strict rule takes nothing non-present:
    -+	 * reading pages back to build an mTHP is not worth the latency.
    - 	 */
    +-	 */
     -	if (!cc->is_khugepaged)
     -		return HPAGE_PMD_NR;
     -	/* for mTHP collapse do not allow any non-present PTEs or pagecache entries */
     -	if (!is_pmd_order(order))
    -+	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
    - 		return 0;
    +-		return 0;
     -	/* for PMD collapse, respect the user defined maximum */
     -	return khugepaged_max_ptes_swap;
    -+	return cc->policy.max_ptes_swap;
    ++	if (is_pmd_order(order))
    ++		return cc->policy.pmd.max_ptes_swap;
    ++	return cc->policy.sub_pmd.max_ptes_swap;
      }
      
      int hugepage_madvise(struct vm_area_struct *vma,
    @@ mm/khugepaged.c: static enum scan_result __collapse_huge_page_isolate(struct vm_
      		 * preserve the lazyfree property without needing to skip.
      		 */
     -		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
    -+		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
    ++		if (cc->policy.anon_skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
      		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
      			result = SCAN_PAGE_LAZYFREE;
      			goto out;
    @@ mm/khugepaged.c: static enum scan_result __collapse_huge_page_isolate(struct vm_
      			list_add_tail(&folio->lru, compound_pagelist);
      next:
     -		if (cc->is_khugepaged &&
    -+		if (cc->policy.require_referenced &&
    ++		if (cc->policy.anon_require_referenced &&
      		    folio_pte_referenced(folio, vma, addr, pteval))
      			referenced++;
      	}
      
     -	if (unlikely(cc->is_khugepaged && !referenced)) {
    -+	if (unlikely(cc->policy.require_referenced && !referenced)) {
    ++	if (unlikely(cc->policy.anon_require_referenced && !referenced)) {
      		result = SCAN_LACK_REFERENCED_PAGE;
      	} else {
      		result = SCAN_SUCCEED;
    @@ mm/khugepaged.c: static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
     +/* khugepaged collapses on its own initiative, so it obeys its own settings */
     +static void collapse_policy_khugepaged(struct collapse_policy *p)
     +{
    -+	p->max_ptes_none = READ_ONCE(khugepaged_max_ptes_none);
    -+	p->max_ptes_swap = READ_ONCE(khugepaged_max_ptes_swap);
    -+	p->max_ptes_shared = READ_ONCE(khugepaged_max_ptes_shared);
    -+	p->strict_sub_pmd = true;
    -+	p->skip_lazyfree = true;
    -+	p->require_referenced = true;
    -+	p->install_pmd = false;
    -+	p->writeback_dirty = false;
    ++	p->pmd.max_ptes_none = READ_ONCE(khugepaged_max_ptes_none);
    ++	p->pmd.max_ptes_swap = READ_ONCE(khugepaged_max_ptes_swap);
    ++	p->pmd.max_ptes_shared = READ_ONCE(khugepaged_max_ptes_shared);
    ++
    ++	/*
    ++	 * A sub-PMD window takes no swapped-out and no shared PTE: reading
    ++	 * pages back or breaking CoW is not worth it for an mTHP.  Empty PTEs
    ++	 * it takes all or nothing, since anything in between would let one
    ++	 * collapse feed the next.
    ++	 */
    ++	p->sub_pmd.max_ptes_none = p->pmd.max_ptes_none;
    ++	if (p->sub_pmd.max_ptes_none &&
    ++	    p->sub_pmd.max_ptes_none != COLLAPSE_MAX_PTES_LIMIT)
    ++		pr_warn_once("mTHP collapse does not support max_ptes_none values other than 0 or %u, defaulting to 0.\n",
    ++			     COLLAPSE_MAX_PTES_LIMIT);
    ++	p->sub_pmd.max_ptes_swap = 0;
    ++	p->sub_pmd.max_ptes_shared = 0;
    ++
    ++	p->anon_skip_lazyfree = true;
    ++	p->anon_require_referenced = true;
    ++	p->file_install_pmd = false;
    ++	p->file_writeback_dirty = false;
     +	p->gfp = alloc_hugepage_khugepaged_gfpmask();
     +	p->tva_type = TVA_KHUGEPAGED;
     +}
     +
     +/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
    -+static void collapse_policy_forced(struct collapse_policy *p)
    ++static void collapse_policy_madvise(struct collapse_policy *p)
     +{
    -+	p->max_ptes_none = HPAGE_PMD_NR;
    -+	p->max_ptes_swap = HPAGE_PMD_NR;
    -+	p->max_ptes_shared = HPAGE_PMD_NR;
    -+	p->strict_sub_pmd = false;
    -+	p->skip_lazyfree = false;
    -+	p->require_referenced = false;
    -+	p->install_pmd = true;
    -+	p->writeback_dirty = true;
    ++	p->pmd.max_ptes_none = HPAGE_PMD_NR;
    ++	p->pmd.max_ptes_swap = HPAGE_PMD_NR;
    ++	p->pmd.max_ptes_shared = HPAGE_PMD_NR;
    ++	/* Never read: MADV_COLLAPSE collapses to PMD order only */
    ++	p->sub_pmd = p->pmd;
    ++
    ++	p->anon_skip_lazyfree = false;
    ++	p->anon_require_referenced = false;
    ++	p->file_install_pmd = true;
    ++	p->file_writeback_dirty = true;
     +	p->gfp = GFP_TRANSHUGE;
     +	p->tva_type = TVA_FORCED_COLLAPSE;
     +}
    @@ mm/khugepaged.c: static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
      		 * preserve the lazyfree property without needing to skip.
      		 */
     -		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
    -+		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
    ++		if (cc->policy.anon_skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
      		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
      			result = SCAN_PAGE_LAZYFREE;
      			failed_pfn = folio_pfn(folio);
    @@ mm/khugepaged.c: static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
      		}
      
     -		if (cc->is_khugepaged &&
    -+		if (cc->policy.require_referenced &&
    ++		if (cc->policy.anon_require_referenced &&
      		    folio_pte_referenced(folio, vma, addr, pteval))
      			referenced++;
      	}
     -	if (cc->is_khugepaged &&
     -		   (!referenced ||
     -		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
    -+	if (cc->policy.require_referenced &&
    ++	if (cc->policy.anon_require_referenced &&
     +	    (!referenced ||
     +	     (unmapped && referenced < HPAGE_PMD_NR / 2))) {
      		result = SCAN_LACK_REFERENCED_PAGE;
    @@ mm/khugepaged.c: static enum scan_result collapse_file(struct mm_struct *mm, uns
      	 */
      	retract_page_tables(mapping, start);
     -	if (cc && !cc->is_khugepaged)
    -+	if (cc->policy.install_pmd)
    ++	if (cc->policy.file_install_pmd)
      		result = SCAN_PTE_MAPPED_HUGEPAGE;
      	folio_unlock(new_folio);
      
    @@ mm/khugepaged.c: static enum scan_result collapse_single_pmd(unsigned long addr,
     -	 */
     -	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
     +	/* Dirty pages are worth a writeback and one more try, if asked for */
    -+	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
    ++	if (cc->policy.file_writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
      	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
      		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
      		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
    @@ mm/khugepaged.c: static enum scan_result collapse_single_pmd(unsigned long addr,
      		else
      			result = try_collapse_pte_mapped_thp(mm, addr,
     -							     !cc->is_khugepaged);
    -+							cc->policy.install_pmd);
    ++							cc->policy.file_install_pmd);
      		if (result == SCAN_PMD_MAPPED)
      			result = SCAN_SUCCEED;
      		mmap_read_unlock(mm);
    @@ mm/khugepaged.c: static void khugepaged_do_scan(struct collapse_control *cc)
      
      	lru_add_drain_all();
      
    -+	/* One policy for the whole pass, so every table is treated the same */
     +	collapse_policy_khugepaged(&cc->policy);
     +
      	cc->progress = 0;
    @@ mm/khugepaged.c: int madvise_collapse(struct vm_area_struct *vma, unsigned long
      	if (!cc)
      		return -ENOMEM;
     -	cc->is_khugepaged = false;
    -+	collapse_policy_forced(&cc->policy);
    ++	collapse_policy_madvise(&cc->policy);
      	cc->progress = 0;
      
      	lru_add_drain_all();
 6:  301d92c2d728 !  6:  9ae83d07f1e0 mm/collapse: drop the collapse_possible() wrapper
    @@ Commit message
         No functional change.
     
         Assisted-by: LLM
    +    Acked-by: David Hildenbrand (Arm) <david@kernel.org>
         Reviewed-by: Zi Yan <ziy@nvidia.com>
         Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
 7:  863f4aec4750 !  7:  bfdf63c56c7e mm/collapse: name the per-table scan reset for what it resets
    @@ Commit message
         No functional change.
     
         Assisted-by: LLM
    +    Acked-by: David Hildenbrand (Arm) <david@kernel.org>
         Reviewed-by: Zi Yan <ziy@nvidia.com>
         Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
 -:  ------------ >  8:  9b8038917bc5 mm/collapse: call collapse_file() from collapse_single_pmd()
 8:  d0e612260e80 !  9:  dd6d94fdad05 mm/collapse: separate scanning a PTE table from collapsing it
    @@ Commit message
     
         Give each half its own function:
     
    -      - collapse_scan_pmd() scans one table and only reads.  The anonymous
    -        scan that used to carry that name keeps its body as
    -        collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entry
    -        that picks the anonymous or the file side.
    +      - collapse_scan_pmd() scans one table.  The anonymous scan that used to
    +        carry that name keeps its body as collapse_scan_anon_pmd(), and
    +        collapse_scan_pmd() is now the entry that picks the anonymous or the
    +        file side.
     
           - collapse_run_pmd() does the collapse the scan asked for, and is
             handed what the scan returned.  SCAN_SUCCEED means there is
    @@ Commit message
             nothing to do.
     
         collapse_single_pmd() is now the two of them with the mmap_lock drop in
    -    between, so its callers see what they saw before.
    +    between, so its callers see what they saw before.  collapse_control_init()
    +    sets a control up before its first scan.
     
         What the scan found and the run needs travels in collapse_control.  For
         an anonymous table that is the orders and the referenced and swapped-out
         counts, which mthp_collapse() and collapse_huge_page() now read from
         there instead of taking as arguments.  For a file it is the file itself
    -    and the offset in it.
    +    and the offset in it: a file collapse works on the page cache and never
    +    sees a VMA, so the scan takes the reference while it still has one and
    +    the run gives it back.
     
    -    The file side moves with the anonymous one.  collapse_scan_file() used to
    -    run with mmap_lock already given up, and called collapse_file() itself
    -    when the page cache looked worth it.  It now runs under the lock like the
    -    anonymous scan and only reads; the run does the collapse.  A file
    -    collapse works on the page cache and never sees a VMA, so the scan takes
    -    the file reference while it still has one and the run gives it back.
    -
    -    That changes what a refused file table costs khugepaged.  Every file
    -    table it scanned used to end its pass over that mm, because the lock had
    -    been dropped to scan it; now only a table it goes on to collapse does.
    -
    -    Two things on the file side stop being rescanned.  When the page cache
    -    already holds the PMD folio, the scan says so and the run goes straight
    -    to retracting the PTE table.  A run that refuses dirty pages and may
    -    write them back retries collapse_file() alone.  The checks the scan makes
    -    ahead of it are ones collapse_file() repeats under the page cache lock.
    -
    -    Tracing changes with it.  mm_khugepaged_scan_pmd and
    -    mm_khugepaged_scan_file used to fire after the collapse, so for an
    -    accepted table their status field carried what the collapse made of it.
    -    They now fire before it and read SCAN_SUCCEED for an accepted table.  What
    -    the collapse then made of it is for mm_collapse_huge_page and
    -    mm_khugepaged_collapse_file to report.
    +    The file scan moves under mmap_lock with the anonymous one, where before
    +    the lock was given up first.  The lock is now held over the page cache
    +    walk, an RCU walk over one table's worth of slots with no PTL, and taken
    +    fewer times.  collapse_scan_mm_slot() ends its walk whenever the lock was
    +    dropped, so a refused file table used to cost khugepaged an unlock, a
    +    trip back through khugepaged_do_scan(), a relock and a VMA lookup.  Now
    +    only a table that goes on to be collapsed does.
     
         Assisted-by: LLM
    -    Reviewed-by: Zi Yan <ziy@nvidia.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## mm/collapse.h ##
    @@ mm/khugepaged.c: static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
      out:
      	trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
     @@ mm/khugepaged.c: static enum scan_result collapse_scan_file(struct mm_struct *mm,
    - 	else
    - 		cc->progress += HPAGE_PMD_NR;
    - 
    --	if (result == SCAN_SUCCEED) {
    --		if (present < HPAGE_PMD_NR - max_ptes_none) {
    --			result = SCAN_EXCEED_NONE_PTE;
    --			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
    --		} else {
    --			result = collapse_file(mm, addr, file, start, cc);
    --		}
    -+	if (result == SCAN_SUCCEED && present < HPAGE_PMD_NR - max_ptes_none) {
    -+		result = SCAN_EXCEED_NONE_PTE;
    -+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
    + 		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
      	}
      
     -	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
    @@ mm/khugepaged.c: static enum scan_result collapse_scan_file(struct mm_struct *mm
     +	cc->scan_file = NULL;
     +}
     +
    -+/* A scan that took a file reference should have been run */
    -+static void collapse_put_scan_file(struct collapse_control *cc)
    -+{
    -+	if (WARN_ON_ONCE(cc->scan_file)) {
    -+		fput(cc->scan_file);
    -+		cc->scan_file = NULL;
    -+	}
    -+}
    -+
    -+static void collapse_control_release(struct collapse_control *cc)
    -+{
    -+	collapse_put_scan_file(cc);
    -+}
    -+
     +static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
     +		unsigned long addr, struct collapse_control *cc)
      {
    @@ mm/khugepaged.c: static enum scan_result collapse_scan_file(struct mm_struct *mm
     -	mmap_assert_locked(mm);
     +	mmap_assert_locked(vma->vm_mm);
     +	/* Whatever the last scan found has to have been run by now */
    -+	collapse_put_scan_file(cc);
    ++	if (WARN_ON_ONCE(cc->scan_file)) {
    ++		fput(cc->scan_file);
    ++		cc->scan_file = NULL;
    ++	}
      
      	if (vma_is_anonymous(vma))
     -		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
    @@ mm/khugepaged.c: static enum scan_result collapse_scan_file(struct mm_struct *mm
      
     -	file = get_file(vma->vm_file);
      	pgoff = linear_page_index(vma, addr);
    -+	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
    -+	/*
    -+	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
    -+	 * the PMD folio, and retracting the PTE table is the run's job.
    -+	 */
    -+	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
    -+		return result;
    - 
    +-
     -	mmap_read_unlock(mm);
     -	*lock_dropped = true;
    +-
    ++	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
    + 	/*
    + 	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
    +-	 * the PMD folio, and only the PTE table is left to retract.
    ++	 * the PMD folio, and retracting the PTE table is the run's job.
    + 	 */
    +-	result = collapse_scan_file(mm, addr, file, pgoff, cc);
    +-	if (result != SCAN_SUCCEED)
    ++	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
    ++		return result;
    ++
     +	/*
     +	 * A file collapse works on the page cache and never sees a VMA, so take
     +	 * what it needs from this one while it is still here.
    @@ mm/khugepaged.c: static enum scan_result collapse_scan_file(struct mm_struct *mm
     +
     +	/* The scan found the PMD folio in place: nothing to collapse */
     +	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
    -+		goto retract;
    + 		goto put;
      retry:
    --	result = collapse_scan_file(mm, addr, file, pgoff, cc);
    -+	result = collapse_file(mm, addr, file, pgoff, cc);
    - 
    - 	/* Dirty pages are worth a writeback and one more try, if asked for */
    - 	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
    + 	result = collapse_file(mm, addr, file, pgoff, cc);
     @@ mm/khugepaged.c: static enum scan_result collapse_single_pmd(unsigned long addr,
    - 		triggered_wb = true;
    - 		goto retry;
    - 	}
    -+retract:
    + put:
      	fput(file);
      
     +	/*
    @@ mm/khugepaged.c: static void khugepaged_do_scan(struct collapse_control *cc)
      	lru_add_drain_all();
      
     +	collapse_control_init(cc);
    - 	/* One policy for the whole pass, so every table is treated the same */
      	collapse_policy_khugepaged(&cc->policy);
      
     -	cc->progress = 0;
      	while (true) {
      		cond_resched();
      
    -@@ mm/khugepaged.c: static void khugepaged_do_scan(struct collapse_control *cc)
    - 			khugepaged_alloc_sleep();
    - 		}
    - 	}
    -+
    -+	collapse_control_release(cc);
    - }
    - 
    - static bool khugepaged_should_wakeup(void)
     @@ mm/khugepaged.c: int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
      	cc = kmalloc_obj(*cc);
      	if (!cc)
      		return -ENOMEM;
     +	collapse_control_init(cc);
    - 	collapse_policy_forced(&cc->policy);
    + 	collapse_policy_madvise(&cc->policy);
     -	cc->progress = 0;
      
      	lru_add_drain_all();
      
    -@@ mm/khugepaged.c: int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
    - 	}
    - out_nolock:
    - 	mmap_assert_locked(mm);
    -+	collapse_control_release(cc);
    - 	kfree(cc);
    - 
    - 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
 9:  ab4013d31d71 ! 10:  97d9ce4aa4a5 mm/collapse: open-code collapse_single_pmd() in its two callers
    @@ Metadata
      ## Commit message ##
         mm/collapse: open-code collapse_single_pmd() in its two callers
     
    -    collapse_scan_pmd() and collapse_run_pmd() each have a clear locking
    -    contract.  The scan is called with mmap_lock held for reading and returns
    -    with it still held.  The collapse is called without it.
    +    A scan and a collapse want different things from mmap_lock.  The scan
    +    reads one PTE table under the lock the caller holds, refuses most of the
    +    time, and the caller moves on to the next table without letting go.  The
    +    collapse allocates, may sleep in writeback and takes the lock for write
    +    itself, so the lock it is handed is of no use to it.
     
         collapse_single_pmd() kept that boundary inside itself.  It dropped the
    -    lock on some paths and not others, and reported which by way of a bool its
    -    callers had to carry along and then act on.
    +    lock on some paths and not others, and reported which by way of a bool
    +    its callers had to carry along and then act on.  Both callers already
    +    act on a drop, khugepaged by ending its walk and madvise_collapse() by
    +    looking its VMA up again.  The code that has to know is not the code
    +    that does it.
     
         Open-code it in the two callers.  Each scans under the lock it already
    -    holds and, when the scan found work, gives the lock up before running the
    -    collapse.
    -    khugepaged's lock_dropped and madvise_collapse()'s mmap_unlocked both go:
    -    the code dropping the lock is now the code that wanted to know.
    +    holds and, when the scan found work, gives the lock up before running
    +    the collapse.  The scan then has one rule, called locked and returning
    +    locked, and the run another, called unlocked.  Nothing is left to
    +    report, so khugepaged's lock_dropped and madvise_collapse()'s
    +    mmap_unlocked both go.  The engine never touches a lock it did not
    +    take, and how a caller locks its scan is the caller's business alone.
     
         khugepaged's walk carries on to the next table while the scan keeps
         refusing, and ends once a collapse has taken the lock from under it.
    -    madvise_collapse() re-finds its VMA after a collapse, which it did before,
    -    and now uses a NULL vma to say that it has to.  It still reports the drop
    -    to its own caller, from the line that does it.
    +    madvise_collapse() re-finds its VMA after a collapse, which it did
    +    before, and now uses a NULL vma to say that it has to.  It still reports
    +    the drop to its own caller, from the line that does it.
    +
    +    Preparation for moving madvise_collapse() out of khugepaged.c: what it
    +    needs from the engine is then two calls with one lock rule each.
     
         The lock is given up and taken again at the same points as before.  No
         functional change.
     
         Assisted-by: LLM
         Reviewed-by: Zi Yan <ziy@nvidia.com>
    +    Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## mm/khugepaged.c ##
    @@ mm/khugepaged.c: int madvise_collapse(struct vm_area_struct *vma, unsigned long
     -out_nolock:
     +out_locked:
      	mmap_assert_locked(mm);
    - 	collapse_control_release(cc);
      	kfree(cc);
    + 
10:  2782efd229ae ! 11:  3e43fd51b87d mm/collapse: work out the orders a VMA allows once per VMA
    @@ mm/khugepaged.c: static enum scan_result collapse_scan_anon_pmd(struct vm_area_s
      	/*
      	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
      	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
    -@@ mm/khugepaged.c: static void collapse_control_release(struct collapse_control *cc)
    +@@ mm/khugepaged.c: static void collapse_control_init(struct collapse_control *cc)
      }
      
      static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
    @@ mm/khugepaged.c: static void collapse_control_release(struct collapse_control *c
      	enum scan_result result;
      	pgoff_t pgoff;
     @@ mm/khugepaged.c: static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
    - 	collapse_put_scan_file(cc);
    + 	}
      
      	if (vma_is_anonymous(vma))
     -		return collapse_scan_anon_pmd(vma, addr, cc);
    @@ mm/khugepaged.c: static void collapse_scan_mm_slot(unsigned int progress_max,
     -					      TVA_KHUGEPAGED)) {
     +		/* One mask for the whole VMA */
     +		orders = collapse_possible_orders(vma, vma->vm_flags,
    -+						  cc->policy.tva_type);
    ++						  TVA_KHUGEPAGED);
     +		if (!orders) {
      			cc->progress++;
      			continue;
    @@ mm/khugepaged.c: int madvise_collapse(struct vm_area_struct *vma, unsigned long
      			vma = found;
      			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
     +			orders = collapse_possible_orders(vma, vma->vm_flags,
    -+							  cc->policy.tva_type);
    ++							  TVA_FORCED_COLLAPSE);
      		}
      
     -		result = collapse_scan_pmd(vma, addr, cc);
11:  7dc745fd037d ! 12:  358bba63f1ab mm/collapse: declare the collapse interface in collapse.h
    @@ Metadata
      ## Commit message ##
         mm/collapse: declare the collapse interface in collapse.h
     
    -    A collapse takes four calls:
    +    A collapse takes three calls:
     
           - collapse_control_init() - set up the control a caller carries;
           - collapse_scan_pmd() - scan one PTE table, under mmap_lock;
    -      - collapse_run_pmd() - collapse what the scan found, no mmap_lock;
    -      - collapse_control_release() - done with the control.
    +      - collapse_run_pmd() - collapse what the scan found, no mmap_lock.
     
    -    All four are static in khugepaged.c, as are collapse_possible_orders(),
    +    All three are static in khugepaged.c, as are collapse_possible_orders(),
         which says what a VMA allows, and the revalidate a caller needs once a
         collapse has given the mmap_lock up.  No other file can ask for a collapse
         without them.
     
         Declare them in collapse.h, with a comment stating the order they are
    -    called in and who holds the lock over each step.  Each function says
    -    what it needs and what it does where it is defined.
    +    called in and who holds the lock over each step.  Each function gets a
    +    kerneldoc comment where it is defined: what it takes, what it does, and
    +    the lock state on entry and exit.
     
         hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part of
         what a collapse offers now, not a helper of the daemon.
    @@ mm/collapse.h: struct collapse_control {
     + *     collapse_control_init(cc)              once, before the first table
     + *     collapse_scan_pmd(vma, addr, ...)      per table
     + *     collapse_run_pmd(mm, addr, result, cc) when a scan found work
    -+ *     collapse_control_release(cc)           once, when done with the control
     + *
     + * The caller holds mmap_lock for reading over the scan and passes an address
     + * within @vma, aligned to the PTE table to scan.
     + *
    -+ * The scan returns with that lock still held.  It only reads, and almost every
    -+ * table it is offered has nothing to collapse, so a caller walks a whole VMA
    -+ * under the one lock it took to get there.  SCAN_SUCCEED means there is
    ++ * The scan returns with that lock still held.  Almost every table it is
    ++ * offered has nothing to collapse, so a caller walks a whole VMA under the one
    ++ * lock it took to get there.  SCAN_SUCCEED means there is
     + * something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page cache
     + * already holds the PMD folio and only the PTE table is left to retract.
     + * Both are work for the run, which is handed what the scan returned; anything
    @@ mm/collapse.h: struct collapse_control {
     + * gives it back.
     + */
     +void collapse_control_init(struct collapse_control *cc);
    -+void collapse_control_release(struct collapse_control *cc);
     +enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
     +		unsigned long addr, struct collapse_control *cc,
     +		unsigned long orders);
    @@ mm/collapse.h: struct collapse_control {
     
      ## mm/khugepaged.c ##
     @@ mm/khugepaged.c: void __khugepaged_enter(struct mm_struct *mm)
    -  * Check what orders are possible based on the vma and collapse type.
    -  * This is used to determine if mTHP collapse is a viable option.
    + 		wake_up_interruptible(&khugepaged_wait);
    + }
    + 
    +-/*
    +- * Check what orders are possible based on the vma and collapse type.
    +- * This is used to determine if mTHP collapse is a viable option.
    ++/**
    ++ * collapse_possible_orders - which orders a VMA may collapse to
    ++ * @vma: the VMA
    ++ * @vm_flags: its flags, passed separately where they are about to change
    ++ * @tva_flags: who is asking, as thp_vma_allowable_orders() spells it
    ++ *
    ++ * khugepaged may collapse anonymous memory to any enabled order; everything
    ++ * else collapses to PMD order only.
    ++ *
    ++ * Return: the orders as a bitmask, zero when the VMA may not collapse at all.
       */
     -static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
     +unsigned long collapse_possible_orders(struct vm_area_struct *vma,
    @@ mm/khugepaged.c: void __khugepaged_enter(struct mm_struct *mm)
      {
      	unsigned long orders;
     @@ mm/khugepaged.c: static int collapse_find_target_node(struct collapse_control *cc)
    + }
      #endif
      
    - /*
    +-/*
     - * If mmap_lock temporarily dropped, revalidate vma
     - * after taking the mmap_lock again.
     - * Returns enum scan_result value.
    -+ * Find the VMA at @address again once mmap_lock has been given up and taken
    -+ * back, and check it still allows a collapse of @order there.  The VMA has to
    -+ * span the whole PMD whatever @order is; with @expect_anon it also has to be
    -+ * anonymous and have an anon_vma.  *@vmap is the VMA found, if any.
    ++/**
    ++ * collapse_vma_revalidate - look a VMA up again after mmap_lock was dropped
    ++ * @mm: the mm
    ++ * @address: an address within the PTE table being collapsed
    ++ * @expect_anon: the collapse started on an anonymous VMA
    ++ * @vmap: the VMA found, if any
    ++ * @cc: the control, for the policy that says who is asking
    ++ * @order: the order the collapse is going for
    ++ *
    ++ * Called with mmap_lock held, for reading or writing, once it has been given up
    ++ * and taken back.  The VMA has to span the whole PMD whatever @order is; with
    ++ * @expect_anon it also has to be anonymous and have an anon_vma.
    ++ *
    ++ * Return: SCAN_SUCCEED, or why a collapse of @order at @address is off.
       */
     -
     -static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
    @@ mm/khugepaged.c: static enum scan_result collapse_scan_file(struct mm_struct *mm
      }
      
     -static void collapse_control_init(struct collapse_control *cc)
    -+/* Set up a control before its first scan; cc->policy is the caller's to fill */
    ++/**
    ++ * collapse_control_init - set up a control before its first scan
    ++ * @cc: the control the caller carries across its scans
    ++ *
    ++ * cc->policy is the caller's to fill.
    ++ */
     +void collapse_control_init(struct collapse_control *cc)
      {
      	cc->progress = 0;
      	cc->scan_file = NULL;
    -@@ mm/khugepaged.c: static void collapse_put_scan_file(struct collapse_control *cc)
    - 	}
    - }
    - 
    --static void collapse_control_release(struct collapse_control *cc)
    -+/*
    -+ * Done with a control.  A scan that found something has to have been run by
    -+ * then: the file side takes a reference on the file while it still has the
    -+ * VMA to take it from, and the run is what gives it back.
    -+ */
    -+void collapse_control_release(struct collapse_control *cc)
    - {
    - 	collapse_put_scan_file(cc);
      }
      
     -static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
    -+/*
    -+ * Scan the PTE table of @vma at @addr for a collapse candidate.  @addr is
    -+ * aligned to the table; @orders is what the caller allows there.
    ++/**
    ++ * collapse_scan_pmd - scan one PTE table for a collapse candidate
    ++ * @vma: the VMA the table belongs to
    ++ * @addr: start of the table, PMD aligned
    ++ * @cc: the caller's control
    ++ * @orders: the orders the caller allows for @vma
     + *
    -+ * Called with mmap_lock held for reading and returns with it still held.  It
    -+ * only reads, and almost every table it is offered has nothing to collapse,
    -+ * so a caller walks a whole VMA under the one lock it took to get there.
    ++ * Called with mmap_lock held for reading and returns with it still held.
    ++ * Almost every table it is offered has nothing to collapse, so a caller walks
    ++ * a whole VMA under the one lock it took to get there.
     + *
    -+ * SCAN_SUCCEED means there is something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE
    -+ * means the page cache already holds the PMD folio and only the PTE table is
    -+ * left to retract.  Both are work for collapse_run_pmd(), which is handed
    -+ * what the scan returned; anything else is why there is nothing to do.
    ++ * Return: SCAN_SUCCEED when there is something to collapse;
    ++ * SCAN_PTE_MAPPED_HUGEPAGE when the page cache already holds the PMD folio and
    ++ * only the PTE table is left to retract.  Both are work for collapse_run_pmd(),
    ++ * which is handed what the scan returned.  Anything else is why there is
    ++ * nothing to do.
     + */
     +enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
      		unsigned long addr, struct collapse_control *cc,
    @@ mm/khugepaged.c: static enum scan_result collapse_scan_pmd(struct vm_area_struct
      }
      
     -static enum scan_result collapse_run_pmd(struct mm_struct *mm,
    -+/*
    -+ * Collapse the table a scan found work in.  @result is what the scan
    -+ * returned.
    ++/**
    ++ * collapse_run_pmd - collapse the table a scan found work in
    ++ * @mm: the mm
    ++ * @addr: start of the table, as given to the scan
    ++ * @result: what the scan returned
    ++ * @cc: the control the scan ran with
     + *
     + * Called without mmap_lock and returns without it, taking what it needs in
     + * between: what it does -- allocate, isolate, copy, flush -- is slow enough
     + * that a writer would wait behind it.  The caller gives the lock up first,
     + * and with it the VMA and anything derived under it.  The run revalidates for
     + * itself rather than trusting what the scan saw.
    ++ *
    ++ * Return: what the collapse made of the table.
     + */
     +enum scan_result collapse_run_pmd(struct mm_struct *mm,
      		unsigned long addr, enum scan_result result,
12:  7d38fee1a929 ! 13:  0ad10df0a90a mm/collapse: implement MADV_COLLAPSE in madvise.c
    @@ mm/khugepaged.c: static void collapse_policy_khugepaged(struct collapse_policy *
      }
      
     -/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
    --static void collapse_policy_forced(struct collapse_policy *p)
    +-static void collapse_policy_madvise(struct collapse_policy *p)
     -{
    --	p->max_ptes_none = HPAGE_PMD_NR;
    --	p->max_ptes_swap = HPAGE_PMD_NR;
    --	p->max_ptes_shared = HPAGE_PMD_NR;
    --	p->strict_sub_pmd = false;
    --	p->skip_lazyfree = false;
    --	p->require_referenced = false;
    --	p->install_pmd = true;
    --	p->writeback_dirty = true;
    +-	p->pmd.max_ptes_none = HPAGE_PMD_NR;
    +-	p->pmd.max_ptes_swap = HPAGE_PMD_NR;
    +-	p->pmd.max_ptes_shared = HPAGE_PMD_NR;
    +-	/* Never read: MADV_COLLAPSE collapses to PMD order only */
    +-	p->sub_pmd = p->pmd;
    +-
    +-	p->anon_skip_lazyfree = false;
    +-	p->anon_require_referenced = false;
    +-	p->file_install_pmd = true;
    +-	p->file_writeback_dirty = true;
     -	p->gfp = GFP_TRANSHUGE;
     -	p->tva_type = TVA_FORCED_COLLAPSE;
     -}
    @@ mm/khugepaged.c: static void collapse_policy_khugepaged(struct collapse_policy *
      static int collapse_find_target_node(struct collapse_control *cc)
      {
     @@ mm/khugepaged.c: enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
    -  * and with it the VMA and anything derived under it.  The run revalidates for
    -  * itself rather than trusting what the scan saw.
    +  *
    +  * Return: what the collapse made of the table.
       */
     -enum scan_result collapse_run_pmd(struct mm_struct *mm,
     -		unsigned long addr, enum scan_result result,
    @@ mm/khugepaged.c: bool current_is_khugepaged(void)
     -	if (!cc)
     -		return -ENOMEM;
     -	collapse_control_init(cc);
    --	collapse_policy_forced(&cc->policy);
    +-	collapse_policy_madvise(&cc->policy);
     -
     -	lru_add_drain_all();
     -
    @@ mm/khugepaged.c: bool current_is_khugepaged(void)
     -			vma = found;
     -			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
     -			orders = collapse_possible_orders(vma, vma->vm_flags,
    --							  cc->policy.tva_type);
    +-							  TVA_FORCED_COLLAPSE);
     -		}
     -
     -		result = collapse_scan_pmd(vma, addr, cc, orders);
    @@ mm/khugepaged.c: bool current_is_khugepaged(void)
     -		mmap_read_lock(mm);
     -out_locked:
     -	mmap_assert_locked(mm);
    --	collapse_control_release(cc);
     -	kfree(cc);
     -
     -	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
    @@ mm/madvise.c: bool madvise_dontneed_free_valid_vma(struct madvise_behavior *madv
     +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
     +
     +/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
    -+static void collapse_policy_forced(struct collapse_policy *p)
    ++static void collapse_policy_madvise(struct collapse_policy *p)
     +{
    -+	p->max_ptes_none = HPAGE_PMD_NR;
    -+	p->max_ptes_swap = HPAGE_PMD_NR;
    -+	p->max_ptes_shared = HPAGE_PMD_NR;
    -+	p->strict_sub_pmd = false;
    -+	p->skip_lazyfree = false;
    -+	p->require_referenced = false;
    -+	p->install_pmd = true;
    -+	p->writeback_dirty = true;
    ++	p->pmd.max_ptes_none = HPAGE_PMD_NR;
    ++	p->pmd.max_ptes_swap = HPAGE_PMD_NR;
    ++	p->pmd.max_ptes_shared = HPAGE_PMD_NR;
    ++	/* Never read: MADV_COLLAPSE collapses to PMD order only */
    ++	p->sub_pmd = p->pmd;
    ++
    ++	p->anon_skip_lazyfree = false;
    ++	p->anon_require_referenced = false;
    ++	p->file_install_pmd = true;
    ++	p->file_writeback_dirty = true;
     +	p->gfp = GFP_TRANSHUGE;
     +	p->tva_type = TVA_FORCED_COLLAPSE;
     +}
    @@ mm/madvise.c: bool madvise_dontneed_free_valid_vma(struct madvise_behavior *madv
     +	if (!cc)
     +		return -ENOMEM;
     +	collapse_control_init(cc);
    -+	collapse_policy_forced(&cc->policy);
    ++	collapse_policy_madvise(&cc->policy);
     +
     +	lru_add_drain_all();
     +
    @@ mm/madvise.c: bool madvise_dontneed_free_valid_vma(struct madvise_behavior *madv
     +			vma = found;
     +			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
     +			orders = collapse_possible_orders(vma, vma->vm_flags,
    -+							  cc->policy.tva_type);
    ++							  TVA_FORCED_COLLAPSE);
     +		}
     +
     +		result = collapse_scan_pmd(vma, addr, cc, orders);
    @@ mm/madvise.c: bool madvise_dontneed_free_valid_vma(struct madvise_behavior *madv
     +		mmap_read_lock(mm);
     +out_locked:
     +	mmap_assert_locked(mm);
    -+	collapse_control_release(cc);
     +	kfree(cc);
     +
     +	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0

base-commit: cf558a250cf4475a8936902b8978fbb6c61016f8
-- 
2.54.0


