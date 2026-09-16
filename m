Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B67AC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E529D6B009F; Wed, 16 Sep 2026 05:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E047C6B009E; Wed, 16 Sep 2026 05:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D0A6B00A1; Wed, 16 Sep 2026 05:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A78EC6B009E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:31:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6411160627
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:31:52 +0000 (UTC)
X-FDA: 85219108464.13.D89B463
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf01.hostedemail.com (Postfix) with ESMTP id C5B0B4000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:31:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=YX6EKwou;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=k0rhja9F;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mXKUgzcTVj91VYW3M7AqXzVEAqqOMuZWDBm217bi6tA=;
	b=Syew47P+gfUT6UIxAaofEGXWG2vbkvetDO2agSi7R9ZeXimktNoHtdFUSBECAEEFvKqKeU
	xtFFjh4U0MDfXVQsLTHoRm74AyvFQ+dGwUvx32NwyQDmEBVQWulNwcy4m1cNheJBZaSdCd
	UzWfYZvZ7fsAut8OL4MH0a2FgD2XUd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551111;
	b=o2D4JNuJIuoZXpLc6OlHw9PRFJDfyl3kPdj6rUN9DC+ffC8MfAsf4bIpZpt0ViWoMUTv23
	DFDTNSadooo88+ZdXmyskc07yb6ZYa9Mh/k4O6GUFouxfVyiqkjtQF3HpHCYjAujbvyMub
	dOwGdJDJbB884zn1OGd4S0aHv9xakjw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=YX6EKwou;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=k0rhja9F;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 85BE67A007B;
	Wed, 16 Sep 2026 05:31:49 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 16 Sep 2026 05:31:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1789551109; x=1789637509; bh=mXKUgzcTVj
	91VYW3M7AqXzVEAqqOMuZWDBm217bi6tA=; b=YX6EKwouXyKen3+PFVI8pZyI7p
	Hs29HTU3PxtreLDVWQhVtUU2b7MDk4Z13WSbPdkrE8f413DVqgjx+0E0K7FxjanQ
	niRg+bpdA4sBwnCz/I/2Z5yuSwa4maGjGJNNdz9DW6IOVItusnXrlBi9Lc73iHYi
	6CedZWnH7ZcZV8c0EjOncxhJQ7sXGk7NZw5zmASL3rhIWCyBUXsp2+qCuqKu2XVz
	JBtNjHedcsScBQTmsH8oUJdWaoPzHEjo7Bye247TW8TBM7RVU2R/x9ZjqV2HzIql
	APPGmGahOFXMgRce5YuI6NxFVdjNiMLHWZd8QcAopX9sl1yam8gpNmFUhs5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789551109; x=1789637509; bh=mXKUgzcTVj91VYW3M7AqXzVEAqqOMuZWDBm
	217bi6tA=; b=k0rhja9FOsg9U3A1fsBzI++zQ2BV5JbidA2cGeGV+nPxTDLyxpu
	pPDhQFpfxtK2+ARyx/2rBP/CRC4VDTojhwekfuv6SpACZusWVIoNtH2i2P6k1R67
	uajMdUDoF3IjrgIQBBvNqZw9+EHo6GaJWTc08Ryv57btupljIo0lmNWAogSYlX1F
	scn2o9nZzIcX8wsfWVMqtZdW2FF2TUiC7nre/7cLk0d/nRx6AM9tf0nk6V5S9h1r
	F1kjUxJXX4RJu+1pq2RviUk4+jEnAlx7XAbZH58vLZgHqAj8/RGh+uqhpYfZna4m
	twvGOaPmUfcozTSBC17qbLYw85YsZXMti4g==
X-ME-Sender: <xms:BGKqai9Gj8w2hu2n0nXIL3FIuMAJTBXVhTpsyih1yZVTXrr-KfiUIg>
    <xme:BGKqakO4RApYgsfhby6Du_jJOlFlLAak-pHWk4frsdQDSncHJtcB97GIl8Jg0iaPy
    FiFYHMTSzHBKRd-h8SfiMwkL0kPDW3LWOfJ3IlI2PY3oFbhdYrtiqNM>
X-ME-Received: <xmr:BGKqalp_ODc1aM0YNmWws8C-OJ5rG6yEvmiycbbGUxY1MoAdIIBqajEq7uA>
X-ME-Proxy-Cause: dmFkZTELp3pkcK2IyU/AvzJYh/VMwv6wUErmCFIcLbA7vXPrsSIC26dAfWkgxwJ9KcT8xx
    L3UBYLclAqECI8nNGWWPzTzXoX+PvR56T+s2l7/SVN3VHlOHEwKdSUKDY8JO00X36xB3Dw
    My6deMFFZG5P9fmmhD6hW0X5hSGno5mjAkMFCkuVObGLpeVk0QgOmH/EnVMURlaKA5eSZO
    DjMV2NJ2k2DjDV9EDSxr2OjZfiU7bJFBbVuwGK0RxXJ6LTr8MnjayhxVXLK0RsosDngLYh
    8OKOPbUUypKf4TMVaET9oUwMAt3O5jS+5xshwRsJUNaC+pohOtM5oHiUOp8LAeHNHR8cZZ
    9oPQ6TBbqiF7AMXFCgQka61kcgeqdDpG/9GlfODxGBmJN5GgtEoATAZ+aPFN5AY2XuQ6Bh
    1Y1kBDoxmWs9xzbnWGu9Op0pJTENTj8bncWqJyC1exNTWp1sc/us4v8nNasVyIgxHd5RIM
    8KGb3SLdgVnRLczMRyi2tgE07UsuBm1l3LvKUYuiz6huCiZovsfcEfWKty1mSof6S0lJ2x
    sbQ13J8/jF8YWEkUW190TvPFcNKN/cNg9LNjUv8yUWQ+zM+Bdu8KrlyXmomE9jfdaDw+60
    KaJArDT6WmjMmMQuO2t6LC0T5iZD3TSz3MaZXDNKF1wzNOZqpuuZ8qUUmrCQ
X-ME-Proxy: <xmx:BGKqah7IMMX-eoxXTc6TcQo2SzQOlSxhHYLhVJdVWt1GvkWusasOzA>
    <xmx:BGKqanrEYObYN-aJOyv73ExxjNegbZIL4kjnTq4GkxXXlxDHioLXVg>
    <xmx:BGKqanJj0D50HjrnV3iOiyqudHPvtxnf7rS7ty3SWAwX9sAm7zE3rg>
    <xmx:BGKqashaReOihd8Dn0M3DUEznC04LIELEJ3YIK9yJm6UwHg5tosApQ>
    <xmx:BWKqavRIV1B_MZ1ZvXEaLpXD0xMk36hWVlctumMtkAXmd8ox9IKfM6u7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 05:31:48 -0400 (EDT)
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
Subject: [PATCH v3 00/12] mm/collapse: separate a collapse from its callers
Date: Wed, 16 Sep 2026 10:31:27 +0100
Message-ID: <20260916093145.4022188-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5B0B4000B
X-Stat-Signature: x91b5wksu7oa6isf5kenmxmezp1fhet3
X-Rspam-User: 
X-HE-Tag: 1789551110-736511
X-HE-Meta: U2FsdGVkX182/98caCTr57xk8ux+b0D9OC1C71h+3upSND+mxTI+K5pF5JaA2mw/1v+dmVQOzJFZAnvDj+WLQA83gE6pzbE+hglughTMLfw7P6r5nJ3xzXBhmkljK9DZknidhhfR+0gfCifMpqasS5nq5ouiT9Czd1jPIW2cq1FtBjRyzA4olmleuoPfAD8Hz3dRrzQn0cLY3vBn8PM/boy+ycrT9DG8CsLvJaddLAsIxTqEjfDxnFqEf09Cd6PilcJYyLv2CozyLnMuEvL1kPu9qEM5Sj5tuQaIyXHCkdw7zUN4Y9PgMBgbWUOAcuTCExFd0ihO8CCf0rXhHjvgqkOH2seo3wcQGetjzIVVN/5M5rRpQyJaSmckgfbnTZBm0ie3apx6B0Q6Il/6vR1PdJl9PKjUb4CFFZ3GyxA3qAyVF7aKqH4DD/1ZH64z29W2/95wEb8E53r6SJFLhAcCAI1txnEeB5Dt9qhQUZF0FH6WOBseQPsFEm5HbX/zuYRLpplxGbQG8usGq+4bKSgUdq2EjusKG25v2RGVHZN8ZIrR95Gm0W/oy/TSePsVFZLjQ1ORwA7vq5DINtcFVrY1GLeTHbRu+pSJzVhH7Bf+IjaXXdl6yrPIaE5pM/BKEd/Mornn53JiGWIrCdv6kSFsaxxI9BvCQqZ6O9qEwNoKoL98GoVuZeZYJUOycX6x+0yrdjYenGKFTuXk9oCm/p2eXvcgkz0PSpu81za+DfvsGP13ORy3QMYZ4GiGcB5akRbrsSGWZZ55FAu4S2IoKsRPKjb+4VjIiws/Jgs6Kmth8W/cfI9Pw6EN+QB/zZyAcKjUFZ67Hr6ffIK1ObUSL5soo02ClRuOBxoGCeUzNz8Jh5QOK7hGAZ7sx6YtTlYEJ9wL8BZUqXoqwMKYIq5OJzMes00G3Srlc/huof997NrezwntYzzn/f3oEDHsZK3aRtVkwOIu3SEeRGSmx20IH8s
 F9bB/ZJr
 PVnH29IzLITWJtEiKh+iWYnCk/jH22Lf6f4s75SjXzgpF66OWzPDwQ/PCmU4Z3XpXt35FmO5NInGeRpYwbLFCtI2bKfR9y9fYaBiTN7yHANMiz9dWpCktqPnVsYtAJYVoWePE1+teEHNCrUR5rTmKbvxICZazAV73EetMEEpjKLyuVFecZpLH8iFzi4a8rwOZ53U2Z/3wlgyRqeAXINuKfqhbze77Sgft4swnyxXMRoHwiIhcdV15hetr6sqTcsr4kdhFmSrIZ6QKVUPZLBBX4Seyw/5TyVc/jLQ8Nrl9Goo0HQsFDs6ySNKgMMmhj3cNet3c38HNJ8hcbVN7R/ji4ygdcNkr2YjB2W9EBA9iltf/Tq8qyNbrvcWXrx5JqGihu5KkLlwmiLg8od5CkD6HjtnIbqmToJQK0riXztPaU4pIbCn3Tnzzpo++89UAdwubq9ef9gmF+Z672B0=
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
What the engine offers is then four calls, with the lock state written
down against each, and a policy the caller fills for itself:

    collapse_control_init(cc)         once, before the first table
    collapse_policy_*(&cc->policy)    what this caller allows
    collapse_scan_pmd(vma, addr, ...) per table, under mmap_lock
    collapse_run_pmd(mm, addr, cc)    when a scan found work, no mmap_lock
    collapse_control_release(cc)      once, when done

The engine stays in khugepaged.c for now; what changes is that it has an
interface, and that neither half has to ask about the other.  madvise.c
gains the operation it should have had all along.

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
  8  give the scan and the collapse a function each: collapse_scan_pmd()
     and collapse_run_pmd()
  9  open-code the entry point that joined them, so each caller owns the
     lock across the boundary and the bool goes
 10  work out the orders a VMA allows once per VMA, not once per table
 11  declare the four calls in collapse.h, with the lock rules
 12  MADV_COLLAPSE moves to madvise.c

Behaviour
=========

No functional change is intended.  Nothing here changes which tables get
collapsed, into what, or what MADV_COLLAPSE returns.  The tracepoints are
the one place a change can be seen from outside; the rest is where work
happens, not what it does.

 - Patch 8: mm_khugepaged_scan_pmd and mm_khugepaged_scan_file fire before
   the collapse rather than after it.  For an accepted table their status
   field reads SCAN_SUCCEED, where it used to carry what the collapse made
   of the table; that is now for mm_collapse_huge_page and
   mm_khugepaged_collapse_file to report.

Three things move that a reader should not have to find in the diff:

 - Patch 5: khugepaged fills its policy once per scan pass, so the
   max_ptes_* limits and the defrag setting behind the allocation mask are
   sampled once per pass rather than once per table.  A knob written
   mid-pass takes effect on the next pass instead of the next table.

 - Patch 8: the file scan runs under mmap_lock, where before the lock was
   given up first.  A file table the scan refuses no longer ends
   khugepaged's pass over that mm; only a table it goes on to collapse
   does.  A PMD folio the scan finds already in the page cache sends the
   run straight to retracting the PTE table, and the writeback retry
   re-runs collapse_file() alone.

 - Patch 10: which orders a table is scanned for is sampled once per VMA
   rather than once per table.  It cannot widen what a collapse does; the
   order is tested again under the lock the collapse retakes.

For an anonymous table, and for a file table that gets collapsed, the lock
is given up and taken again at exactly the points it was before; the only
difference is that the caller is the one doing it.

selftests/mm khugepaged passes on x86-64 with a KASAN, lockdep and
DEBUG_VM config, and every patch builds, CONFIG_TRANSPARENT_HUGEPAGE=n
included.

Kiryl Shutsemau (Meta) (12):
  mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
  mm/khugepaged: count collapses where khugepaged makes them
  mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
  mm/collapse: add collapse.h for the collapse interface
  mm/collapse: state what a collapse may do in the policy
  mm/collapse: drop the collapse_possible() wrapper
  mm/collapse: name the per-table scan reset for what it resets
  mm/collapse: separate scanning a PTE table from collapsing it
  mm/collapse: open-code collapse_single_pmd() in its two callers
  mm/collapse: work out the orders a VMA allows once per VMA
  mm/collapse: declare the collapse interface in collapse.h
  mm/collapse: implement MADV_COLLAPSE in madvise.c

 MAINTAINERS             |   1 +
 include/linux/huge_mm.h |   9 -
 mm/collapse.h           | 154 +++++++++++
 mm/khugepaged.c         | 577 ++++++++++++++++------------------------
 mm/madvise.c            | 169 +++++++++++-
 5 files changed, 556 insertions(+), 354 deletions(-)
 create mode 100644 mm/collapse.h


base-commit: cf558a250cf4475a8936902b8978fbb6c61016f8
-- 
2.54.0


