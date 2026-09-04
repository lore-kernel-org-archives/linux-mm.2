Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 534EBC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A1086B008C; Fri,  4 Sep 2026 11:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578406B0092; Fri,  4 Sep 2026 11:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467186B0095; Fri,  4 Sep 2026 11:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2184A6B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:10:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A200C160158
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:32 +0000 (UTC)
X-FDA: 85176416304.03.824CAF2
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf16.hostedemail.com (Postfix) with ESMTP id BA97F180006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=OohAyuAr;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=f82OfUi9;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788534630;
	b=pJOCvyHGB260RGoX/4YWUINRvYDSY6wPj3iEx0sy+ePWIIUn3bQBzfQWxpux6o/6z8Ad3O
	WIcmqvQJezNlhm6gv1kxrnExFUuooZPimU9FYj49KaCASrPuexBzGz9hoHIg6uImqLB5z4
	Ur3RivqkVRTTXawjbJ/1DXTaJaXOpRk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=OohAyuAr;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=f82OfUi9;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sWZdeNTpDfZal7sA5I6DjoJlT7YvBna/p9VwtQoOngM=;
	b=5oeFI6bIQqiZpckg1CM42P7mrWoOBFgsqOotp69CdXOPTXKQWSChEfCoX9fLDS2Pwadyrc
	QKusDuGn2DtcgCwmITPeDhVkg/XRCXZIvCE1QGcjs72VSLmG344vwamNVCl0xV66G8MGRA
	wLyaSUsIA9sGyGdeL5B0heKgdU1ZBc8=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2DF2614000EA;
	Fri,  4 Sep 2026 11:10:30 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 04 Sep 2026 11:10:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1788534630; x=1788621030; bh=sWZdeNTpDf
	Zal7sA5I6DjoJlT7YvBna/p9VwtQoOngM=; b=OohAyuArc+InZP0fjvGszelKX/
	97vDVbqz0UbpRnQ/uKRPyPOJrPA8KIU7nVdEMueT4JqakYUfP2oDBKH0C3GgP/Yy
	4gjWtVW0bMwyQUI+Zpajtp3zC6CWXoJiefEhi31GZKfLgMFiwAB8Ds7t2Qv66nMb
	98KjWhIMkstwFYUfYvd0At46CBYHX3W/nHyJCl1oMHU7u8FQlUtKPZfNC0ynn9++
	qLLu7UKe9W24rt616mPKGmX6AptVLCIZ97bKQOS0ncIiOpnTfIhMmNBOTEfvrcKQ
	sftj8VnrA185hMwC85bNQ7z73ZHQA+B+WVHk+Jt8i1DHVhJDfoggHNlMl6FQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788534630; x=1788621030; bh=sWZdeNTpDfZal7sA5I6DjoJlT7YvBna/p9V
	wtQoOngM=; b=f82OfUi9PQyc9ZyscutS34C+kiO8p6UUMpqQZ//65GEWmJrvr7V
	3JjkwpafYnahwlu42fzCKTXqjMcWyD0PNLX1arXcHbghSor01O8+8uBNtY+yBxPD
	dCSuSPi7RbKlB871P3WB4R7wK+iwYgmC+o3uVZqlD6kvTgixtjHdT/7NEfCZ3InA
	zUlGNJ6jWpUJHWtExwtFiok0oqGxdoQyjH7mR0O7sHsB87gIRHwTNBbSHBQsyO8z
	xbkR6k97V7PATC9p8X6qyZx02jRc6yN2Crj4f+tlGyB0T6NmWDontTkUsRB4eD9r
	eRftq3+eTTatB4QkS9tYNyG3L/8Jm5uOzQw==
X-ME-Sender: <xms:ZN-aash9HPsRjC61LfLPtGYFzlpPOgRJx5tyZuQ_JshRBq2Rfb67cA>
    <xme:ZN-aag_9xzF4e-0L7DyemdGmfuVV3973BNNUyjHRrTjPg5TL8-NWT0UxZlssHK0f1
    HJh7SgMbe_6Xfp9mkW3lxuwQ-DFmlRMelxHz_d3IoG3xR17TU3bkzke>
X-ME-Received: <xmr:ZN-aaqPVN-7ideQmTbXYsKu-Fofv12cjnOucCB5rRVpadIdT8pF9qqTcxsw>
X-ME-Proxy-Cause: dmFkZTFcO4YtRyfx0zGlS1IZtYzfJDLiS5VWMDQ/DlxcC5gkXLU0X6DiHSpyBj4RqcC62C
    owXC/Tcw8vUQP18cXWx42X4mQmQjXvTz4di7+X/8P4W8WDuFAmwObT8X98gUkk36ZyyCTh
    5LzMVAcNQc556hgoHfuune7PVx98+FQlPl2ghcvi0inDW050eT+ASyAAgWfajSFZZEfF/+
    ojHB12p51f+GfotZnXjh8HSikMvkEhpQxXkMP4ISkoKemvUGfP15SjvbYIknVcLpDbNfZ/
    BN2uj3rQlyE/GoRwtqruV3sIFfiun3YwgCFJqhKkTCzyFIkwsAUNI1YG2ZvvSNn0Y9boRK
    TJI+JQONRxlk4qDs/+ZJRTTdj4lah/50JPc7033pcq4N3mFNZk8szrF32XTkwc6o/sDGgq
    RPuU3CDrS/CNluqFxddRn2qZFF4tYvyksCvlnPGzcj2I2T37HvRMfb7jTt0HMCyTKAW6bJ
    znlx26bkxZKKL61aD14JhZ9beBlp8pALfL4aDoxlFwDMGyRv197cTRWzclZgGS0z888kzI
    hRfBNO4Xc6jfWeZLphq+U83z2zc68OCvmIONgsR7JeQ16lUaTL+NMjcEbtU/2iQMq/HCUL
    MikIqxe1c5epCg1gdraOdYffN5jxURy78K7RUCCjNvZx/ZyJLz2sabkZuJWw
X-ME-Proxy: <xmx:ZN-aajpBoAaNOVv1Ovf7MO09CL2nOUNI508vGRE09XQYKTvc0Yh25Q>
    <xmx:ZN-aan6UDUdJLqlU0xR5rL186bo795Fv5tEIgzJQHKWIoUUkR1__FQ>
    <xmx:ZN-aaloJgjmkAaWZVVSf9FeJ1dclPhUmsMs_pA5O-fpDL2viKY-d6w>
    <xmx:ZN-aatL2W0Z3qWYDKM9JSd8E-QGWQUoGNMyvBXbC0QgCegoID3f6tQ>
    <xmx:Zt-aanmfnEnNyVxNovfb9435xJyFXJORIs3sEtFHh4xKEeazdA7crnmM>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Sep 2026 11:10:28 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 00/12] mm/collapse: separate a collapse from its callers
Date: Fri,  4 Sep 2026 16:10:14 +0100
Message-ID: <cover.1788533997.git.kas@kernel.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5hgw3ioqrer49b6d8obcqexuy7g53j4g
X-Rspamd-Queue-Id: BA97F180006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788534630-279156
X-HE-Meta: U2FsdGVkX1+fsSAg+hy0y8ifdyfzCcRas4qL4/16nO9e+mDI5/gcFgjIPe1mrFXYOvO5f6qR1QBbGi9+OfcnREJpTPz9XMlfHDeUUY2qO4wpEraPn9Li3Z2Gkzm25I57evOFERuw+nqV60cAxHutemm4ut8Bx4pOxa8QuKGPGoYeV6hokkSMfFMb/Ybczd6EkSCdj+Gj/2J+TupMPMXADpUMDMQCafOJ2CYMcs3MEiXJwrteU674ql6yJ5V6AjCa95Gs4lfHeyvMlCI5Y8Ai9ptZIJooocSIiHJFAMOYFWD1gw08+7wRz2Jif0YAlddtOL0DHDaXp/ohY+eg5AZJ3xd0LtRsprP+1Y8FQa202WI1gJ7wK/H5fPl1mB3E7DeUzIUfzc+O19wmcZqZEc9FPnsrIlQccUDsJykt6nloSXSMINGERy+2jqkBJu+QJxwNi0xM5PQeG2shhrNbmijgFd4o9bg5kD1aKY1RRx9YSL5hSuH581cqi7vpkRtT19CTkFHvVGK6I+Ccb/0Hg8uy6mKAnpPGUUY/LDm6FUikoN8iOo0xpW7Eal3Mxhb5cqOuSBHfT5ZyLDDTvO5Ywo1g1p7a9B//muxHMBeFH6IW5LnGxi5aFQIjhXIwGwhaAofKyIJ9RXBvPSqug+ezktO4ZYLG2Bifp78WKN80mHWS4o1qKbtevYLZ6pXcK08MaVtE+lpY7O3I5RlaPKVIu9um3eNMFVBXPbGn7bUgKmzjxO+1ETseMo+bUQlfJ+ZmzCzLuq0/fr6Rs6loFHUkX4Ss1zgDjcdFCch5+6qPQszqhh5XeE2JNbxjVPaJxRbFGnNMkh+wdbfMjfU/ZBXXoVb4lH3YWu3+F2U22AN+UilmEG9KkVmtAoWWzYIqn+VPInP3VaxilipBTSZaq4k/zPCj2+TITvO9vngc8uS50CGVSJfZ1YHcSe3a2B9h+mINqC6bj1+73ZtIo2vninMcnSd
 +P9PkIeG
 OZcuNg/KngZlcUfoMQKmiCu4KddElVN7TbRgqraAlUPZA543nZxO8CZpqfAxU9BsJWjbkl/aZwPFnu8bfd4nJKcYpjTrKKU9z9Ibg2tkw8sFNjAZhbrx03HyrOzITW+8DHMFRHxTK/DFnD/wwRZASvg0z9yqTOActDP4Ue705um0wU9+v0w+YpMvQ9d9Q4qPQB9yyJ081fO6RghY5Assj/aRvJ7ceHsz6z8CtF4eDPOhmG4yMb0z8IKcihvgDpGx3GJFSPUtGqJelcImGfkmP0VhqARVfqzoNfiY2g5Nq2oJ3umNk7f4wMEXFbfnRVbMmqWpzcFA5ZIhNqgexdsCOUBbMnmkZfFgZDF6Xbplx5vnWZRTqyOSBXu5Y/m1smZmbUDmc
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

Nothing here changes what gets collapsed.  Three things a reader should
not have to find in the diff:

 - Patch 5: khugepaged fills its policy once per scan pass, so the
   max_ptes_* limits and the defrag setting behind the allocation mask are
   sampled once per pass rather than once per table.  A table scanned early
   in a pass and one scanned late are then judged alike, where before a
   knob written mid-pass split them.

 - Patch 8: mm_khugepaged_scan_pmd fires before mm_collapse_huge_page
   rather than after it, the scan having returned before the collapse
   runs.  Its status field already reads SCAN_SUCCEED for an accepted
   table, so nothing changes there; what the collapse then made of the
   table is mm_collapse_huge_page's to report, per order.

 - Patch 10: which orders a table is scanned for is sampled once per VMA
   rather than once per table.  It cannot widen what a collapse does --
   the order is tested again under the lock the collapse retakes.

The lock itself is given up and taken again at exactly the points it was
before; the only difference is that the caller is the one doing it.

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
 mm/collapse.h           | 163 ++++++++++++++
 mm/khugepaged.c         | 485 ++++++++++++++--------------------------
 mm/madvise.c            | 169 +++++++++++++-
 5 files changed, 497 insertions(+), 330 deletions(-)
 create mode 100644 mm/collapse.h


base-commit: e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
-- 
2.54.0


