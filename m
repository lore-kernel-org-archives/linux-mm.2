Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B400C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7D16B0372; Sun, 16 Aug 2026 18:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598536B0375; Sun, 16 Aug 2026 18:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4604C6B0378; Sun, 16 Aug 2026 18:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 108736B0372
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B0F08058F
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:33 +0000 (UTC)
X-FDA: 85108618266.03.6A9D812
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9EEDCA0004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="g Ab0TOV";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=V9uGK6Lo;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920391;
	b=40napqOlRGvBAp+lsoi+TrfwqxEO0FZ4+bqSpD+Cc1zZl470sqRZHg1TjNV6P7t7SQV8bH
	NKsyOGJS7eGKPC5VmX4cc1V5sbw5XkCr4QPBoFZLfhKm7OhSOLLYyeo37zEr96l2KvpRSC
	3NdEd35Tf4IJ0irzuNuc4miZIZzVGvs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="g Ab0TOV";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=V9uGK6Lo;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VxCBv+v1ZXEJKNvfPy2aqiMmOmTEgUap7KvFAJc7uU=;
	b=RutMmIeJSvXP7wBQtvPo5pHVOntH53nPl+mw3W8Gp6vqgxi6iTbrGblfwIWnMWTKQrqR4k
	WYlUha2NUs1JwGXwtAx3FcumSz0yOREWsNGDZgXFR1vbws3FY2sJjGhhhUHJRnl2Paqurh
	VtZwhfkwbJGXPTALbwSb1Wv7n/T1yRk=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 3088BEC0243;
	Sun, 16 Aug 2026 18:46:31 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:46:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920391; x=
	1787006791; bh=7VxCBv+v1ZXEJKNvfPy2aqiMmOmTEgUap7KvFAJc7uU=; b=g
	Ab0TOVpn+9qoUMsUan8zShJ2eYFdfYlNN48hFz7V7rEO6adbiMjWHyXwoc9+B3D+
	hEgy73wLfFs/OKh7MXYMvZHEppDFJ7EL82dC4HldTYTGnY9wTtUrM94lz36xZo+A
	dLPF5/h3pH+dUnyJhVBrdntA79JQiU46MNqF/zWywBW7Ku1ON6cfrFnNieNxrg2x
	CaWyZa6GDa0PdOgtx/G+gP6udYy1ILjXH/+Nxb/JtwrdFYjR22UCs//sshwbpQ3R
	KY0ZQhA4JDx87QEczUD1KGu6UHQJA97P9l4WU156i78r5ULxxpwlPnKdbURvOQdN
	N9USjpiEWUpxwy5ZPNGNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920391; x=1787006791; bh=7
	VxCBv+v1ZXEJKNvfPy2aqiMmOmTEgUap7KvFAJc7uU=; b=V9uGK6LoUNikpiRjD
	CTRKPEM+RkNxg4AL9IZRimPQcHj0+Y/s89JbzBlqwOrHQ/88GlKAg2GdMr1NXvFn
	ZGeEIaBa94w9uXJBz6AAv7PFvR9TyNzdZqLG7cBc/iTIUatH2V4ReQZ3sX1bXrtq
	r87h3/tA0BPU901YuxbyyfH0h+qA7CzO60qAPIVHiQ2L3ZHoxmXQ016qObtnUUvc
	z88x10Xi7mgucQNiIIHixKQz6bKbZS3zIgVo6TXleiOwEmw+hqMlLc40SmcL50yU
	8WUCOygX0YHUHPgvoYf00XGMSY95qDV7uZmVD2pEqf5nXrvn9s71sQVrx8BsI/z2
	9p12Q==
X-ME-Sender: <xms:xz2CatKgdECJoF_4FPSo1z1p9D9IsAtaSgkNGZ3B0TvDf7z7lRK7Ag>
    <xme:xz2CaudaMGJ2SWdm_3HrEqT2rqrsjq3GIwY0NHvwR9NzVjOH99aPkh_PH2cpnF2iK
    fSWY9r5-Fh3fRB-EBOTSM-LiSCj8R1r44ADIG_UtkmnyyZWH7qtSMQ>
X-ME-Received: <xmr:xz2Cahw2BLyshBqjRh6zEcOTSea4TADe25TVvatc9skguuSgp1lTIBwsibU>
X-ME-Proxy-Cause: dmFkZTFt7uwKlsd4UyzlmYX1bnlzO4+qp5TmvoTS/qzkFKfMuj25xYssUPl6UU5Ie9xRba
    Y0bWuaC/AePVMhqrkCnU3j3fo4+kQ4lrNr0qcDw4ZM2xDmZI+m2r8oZbGDZU/DcLlRMJvk
    pxa8BemzxDXpf0p5hqW+oOweEwIQBvnr/hc1O3uCrLqxLkUCX+QMvT/AmKStBz4XcOBl17
    ynvfoFkCi5Qu6ZndF8QgBKMwimBrechIaqu56LTRaFtWn2N2FSoSPFDDGPAClh8o3Wii3h
    WmXtU4UIpdlwyanZt6DS7CEKxM1G2yBGNUvAI/9KSggaAyLfyuWlS9a0iep84iGUQaZXBZ
    FT7lUXICRewRR2hApjAGIT2CFP2aecTYW5WBOWdkAu3PZGJMwVOaTCXCbpyyAw5uDutR9N
    cM1vfgm+C6HgAfygQSu8EUBMJo7+djMMGvy1w1JiB0r7oXIzcj8YaeHLzsFDQuCP7Tk3JE
    VYcUFIxgd6tXhGEDYtL3d75Uwq7YHKTP8lYdadtR5e+r7ixAFvfU/UibDxJtY36j4/ENrG
    7O8W7AyTPTaJ/cCibLitvEYey+a9uFu63HUfggyD3oir7BbLzhjWVTsIkYheuXSmJhUyub
    ho7En+8+81Adj/Pfu7T+uFcVIloLHtGz/Skb7mjPPkRiSkCjwpI39xh5Zgqw
X-ME-Proxy: <xmx:xz2Caq8Uxd1pcQkIdzMX9KDdjHinFJ6jOKk1T5rOPe6YZoUBXxswiA>
    <xmx:xz2CaqpJNFCkdb0IXdrzp_UeMLbitNwuA9hIdIuso7_A1Za09NFl-Q>
    <xmx:xz2Cark3K4VPb52Y1dGXT2IhWTwp4lSeSAp59USh3gOE2emnKTpQaQ>
    <xmx:xz2CanZEy7BW4VJ1oYn0xr09C_FfbfZCzbIB3bTKUsLcsAzI80Lqnw>
    <xmx:xz2CaqNgjNTYaSskvUR4-dpE-NP3Y5rOwI4d9u1atTZc5DBUw-o28z3h>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:30 -0400 (EDT)
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
Subject: [RFC PATCH 07/57] mm/collapse: sketch the new anonymous collapse engine
Date: Sun, 16 Aug 2026 23:45:19 +0100
Message-ID: <20260816224609.308019-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9EEDCA0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qsojrn4wtm6hci1rw9myjoiqskmr85sc
X-HE-Tag: 1786920391-863829
X-HE-Meta: U2FsdGVkX18EzavEiLfOnSnfsq7qrvG0lMZQF/jS4Prppe8dG7PIi2QzDFiEP6Jc/UZuyAYkUgZmPVAd7F8kYGAaIVVINkFP7W54OPTR5YaiePAN3mdclQZeHPR4/BD1uNUA0XliDWzSmwpmsGPK8axKdacBjN79oy3CG9/jLlNcCjukBnn8nqSfl+H0VSr4aqVXH/SXtfI9AsEtgizf6ZWYp5GU3jlnz5ruuKBcWXuDegXrFWueEt8UabnYAIF9MCE+PxJEkFwABAu7N1IQ9Q7hJ99cUjYS7uz7hp9PFsTYm3NgLZkRoXvoJIJ9Z+nf8UNrOD9/c6p8PxBCQfswSHsJTApKtaw0N6NS3Du423b/CRgK/EODRbzSeaRVyeyD0GuE/3xekvtIj0YVNQ8gBBYBDMcDSY/i+ujMyLvmcI5EcdZTMyLDdb2Nenz6n0FWBDFEa/yUl5lrc8jWsmboyD5Dygjku2eVDhMvBnEXNUz9rxrY4EMNPRyfaWuClznzRbvIz/Vi5eknTUF7mayLUfgZ5Nv/YEIuYw9AO725FmMlwN09bHU/3ZoEhrzZeeb5hLeEF3YZz14Z5H+UbDCGQWjCBdbrz3FY+rMQjl/Ub1j0a/aMLstKlLZOtl/5zTAAcT9c+PF+lSSDjcNijHprXXlks4RRDrTJNzh2zHG68K5d64yNlSwgrVGhy0z3GPGNzyTlwOp0T++Cq3JOZTihn/rd9cDH1lcrfqh2TtKRwoGvklT3BMqUJ1Ily2CPtCELFb+EfNGx/a7CLNYbrzYuu87HKCfWUHUTYlJG2laDjGtZR78cxdUY5AG8rzN2BUq/kL+Z6y2B8l+p4301Vz+Ns8Vp73O8+aZZ1BGatIsasvbISPmnuhRC6QXGcLFCtGUWzTbsCabZMRwzLIk1dAY3FxhjCfSRrKsKtxPORhQFpWVD2yO1Rf9fN09kf9Ta8ShOlv7WEHBw93Z68US8/ab
 fIYn3FgG
 SMx3umG1UOy0gJIf/rFkx6Ju2pIXq7xatAwSx0c12uCaXOva0qYErgPmai3Jd0/Jz69GtxyGhpxSaLi3aRD+d1mQzETBI/jNh0EzVYk4n9hRKVwI0z0yxuD+nuHD4kcEV2SVSYMX+180W2Kn6RWpzqQvzPs6XU5U7f+wz07Nl7pUc1pmSNckRUv18sPP961KQ1MvT2QmrQrRQcXBCsebF/ZHW+wTN9uLAtYBegJj90EGqNKz/sjmAwrZnrCEZk2W8EvDIRCkupI4c9itYemhtUyKHYx4n3wqnbwIVbDJ/4/4ar0bje8c2ZKEDVuJAD6FS2uaN6Bt+x2EwrrXxqdqKjW/NfxrrFWiPRrK+NGTdZTe0Fp0oRTJXvqz91mJRbDPO+P5sjYbE334+BgdgKXyYN+fHZc5j2rjaDoomuvPyLPPP7sgcTcL550r37bKvApcM0is8/QtVAXSrYIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Anonymous collapse is held back in two ways that its current shape cannot
be patched out of.

Functionally, an mTHP is collapsed only when the whole PMD-sized window
qualifies: collapse_scan_pmd() reaches mthp_collapse() only on
SCAN_SUCCEED.  One PTE that disqualifies itself -- uffd-armed, not
anonymous, clean lazyfree, off the LRU, pinned -- takes the whole table
with it.  A 2M range with a single such page yields nothing, even where
the half beside it would collapse perfectly well.

For scalability, collapse_huge_page() holds mmap_write across a collapse,
and anon_vma_lock_write() with it, then does the same again for the next
huge page.  Every collapse stops every fault in the address space, one
huge page at a time.

The new engine addresses both.  It quiesces its sources the way migration
does: migration entries in their PTEs, then a frozen refcount.  That is
enough to make the copy safe without the exclusive lock, so the engine
runs under mmap_read throughout.

It also carries a batch of windows through each step together, rather
than one window through all of them.  Its verdict is per window rather
than per table, so a table that cannot become one huge page still yields
the largest windows inside it.

Lay the design out first and fill it in afterwards.  What arrives here is
the shape of the engine: the two entry points, and a comment at the top
of mm/collapse.c mapping the whole call tree.  Every step below them is a
stub, filled in before the anonymous path is pointed at the engine.

collapse_scan_anon_pmd() finds the table, asks the VMA which orders it
allows, scans it, and leaves in the collapse_control what a collapse
could use.  collapse_anon_pmd() takes that range and cuts it into
windows.

The line between the two is where the lock goes.  A scan only reads a VMA
and a page table, so it keeps the mmap_lock it was called under and hands
it back.  A collapse allocates, copies and flushes, so it is called
without the lock and takes it again for each round of its own.  Nothing
then has to tell a caller whether the lock survived a call, and a caller
that finds nothing to collapse never gives the lock up at all.

Nothing calls either entry point yet; the anonymous path keeps using the
mechanism the engine replaces.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/Makefile     |   2 +-
 mm/collapse.c   | 165 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/collapse.h   |  24 +++++++
 mm/khugepaged.c |   4 +-
 4 files changed, 192 insertions(+), 3 deletions(-)
 create mode 100644 mm/collapse.c

diff --git a/mm/Makefile b/mm/Makefile
index e7245cb88c66..2bef749a5c21 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -98,7 +98,7 @@ obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
-obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
+obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += collapse.o huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
diff --git a/mm/collapse.c b/mm/collapse.c
new file mode 100644
index 000000000000..0e6c3c68b44c
--- /dev/null
+++ b/mm/collapse.c
@@ -0,0 +1,165 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/bitops.h>
+#include <linux/highmem.h>
+#include <linux/huge_mm.h>
+#include <linux/hugetlb.h>	/* x86 flush_tlb_range() uses hstate_vma() */
+#include <linux/leafops.h>
+#include <linux/memcontrol.h>
+#include <linux/mm.h>
+#include <linux/mmu_notifier.h>
+#include <linux/pagemap.h>
+#include <linux/pgalloc.h>
+#include <linux/rmap.h>
+#include <linux/sched.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/swap.h>
+#include <linux/userfaultfd_k.h>
+
+#include <asm/tlb.h>
+#include "collapse.h"
+#include "internal.h"
+
+/*
+ * Anonymous collapse, in rounds.
+ *
+ * The folios mapped across a window of PTEs become one folio of that window's
+ * order, with the sources quiesced by the two barriers migration uses --
+ * migration entries in their PTEs, then a frozen refcount -- so the copy itself
+ * needs no lock.  The engine runs under mmap_read throughout.
+ *
+ * A round carries a batch of candidate windows through the passes together,
+ * rather than carrying one window through the whole collapse.  [ptl] and
+ * [pmd lock] mark a pass that takes that lock and drops it again, so no
+ * page-table lock is ever held across passes; the source folio locks are the
+ * exception, held from freeze to putback.  [rcu] marks a pass that takes no
+ * page-table lock at all and reads the table racily, which only the scan does.
+ *
+ * Allocation happens on both sides of the freeze, and which side comes first
+ * matters.  collapse_provision() tries first, inside the window and after the
+ * freeze, with reclaim masked out of the gfp: the sources are frozen by then,
+ * so a faulter on one of them waits for this allocation.  A candidate the
+ * allocator has nothing ready for is not failed -- it goes back to selection,
+ * and collapse_reserve() allocates for it before the next round freezes
+ * anything, outside the window, where reclaim costs khugepaged its own
+ * progress and nobody else's wait.
+ *
+ * That second chance needs the policy's gfp to allow reclaim at all.  When it
+ * does not, a retry would miss the same way, so the first miss is the answer.
+ *
+ * collapse_scan_anon_pmd()            judge one PTE table's worth of a VMA
+ * `- collapse_scan_table()            [rcu] a bit per PTE a collapse can use
+ *
+ * collapse_anon_pmd()                 cut windows from those bits, run them
+ * |- collapse_next_candidate()        the next window worth attempting
+ * `- collapse_run_batch()             run the batch, then classify it
+ *    |- collapse_round()              below
+ *    `- collapse_classify_result()    carry on / lower / abandon
+ *       `- collapse_push_retry()      queue it for a lower order
+ *
+ * collapse_round()                    one batch of candidates
+ * |- collapse_reserve()               second try for what the last round
+ * |                                   missed, with reclaim; sleeps
+ * |- collapse_deposit()               a page table per PMD-order candidate
+ * |- collapse_revalidate()            check the VMA and the table survived
+ * |- collapse_faultin()               make the sources present and exclusive;
+ * |                                   sleeps, and may leave the lock dropped
+ * |- collapse_freeze()                raise the barriers [ptl], flush the TLB
+ * |- collapse_provision()             first try for every other destination,
+ * |                                   without reclaim: the sources are frozen
+ * |- collapse_copy()                  copy into the destinations; sleeps
+ * |- collapse_install()               publish them [ptl], or [pmd lock] and a
+ * |                                   second TLB flush at the PMD order
+ * |- collapse_putback()               lower the barriers, in order
+ * `- collapse_finish()                settle whatever the round reached
+ *
+ * Every slot of a candidate is a real source, a hole (pte_none, zero-filled
+ * and re-verified still-none at install), or the zeropage (cleared at freeze,
+ * zero-filled).  Sources come in "spans" -- consecutive PTEs mapping
+ * consecutive pages of one folio -- so partially mapped and compound sources
+ * collapse too: any order below the window's is a source, and a PMD candidate
+ * takes even a PTE-mapped THP of its own order.
+ *
+ * Nothing calls any of this yet: the anon path still uses the mechanism it
+ * replaces, and is switched over once both halves are complete.
+ */
+
+/*
+ * Scan the PTEs between @start and @end and record what a collapse could use: a
+ * bit in cc->eligible_ptes for every PTE that may be a source.  Returns
+ * SCAN_SUCCEED when every PTE in the range qualified, otherwise the reason one
+ * did not, and narrows cc->select_orders to what is still worth trying here.
+ */
+static enum scan_result collapse_scan_table(struct vm_area_struct *vma,
+					    pmd_t *pmd, unsigned long start,
+					    unsigned long end,
+					    struct collapse_control *cc)
+{
+	return SCAN_SUCCEED;
+}
+
+/* Everything a table is judged on starts empty for each table */
+static void collapse_anon_scan_init(struct collapse_control *cc)
+{
+	bitmap_zero(cc->eligible_ptes, MAX_PTRS_PER_PTE);
+	memset(cc->node_load, 0, sizeof(cc->node_load));
+	nodes_clear(cc->alloc_nmask);
+
+	cc->select_orders = 0;
+	cc->nr_collapsed = 0;
+}
+
+/*
+ * Judge one table's worth of @vma, leaving in @cc what a collapse could use:
+ * which orders are still worth attempting, and why the table was turned down if
+ * some order was.  Holds mmap_lock throughout -- it only reads -- and a caller
+ * that acts on what it found hands the range to collapse_anon_pmd() afterwards,
+ * without the lock.
+ */
+static enum scan_result __maybe_unused
+collapse_scan_anon_pmd(struct vm_area_struct *vma, unsigned long start,
+		       unsigned long end, struct collapse_control *cc)
+{
+	const unsigned long pmd_addr = start & HPAGE_PMD_MASK;
+	struct mm_struct *mm = vma->vm_mm;
+	pmd_t *pmd;
+
+	/* One table's worth at most, not empty, and inside the VMA */
+	VM_WARN_ON_ONCE(end > pmd_addr + HPAGE_PMD_SIZE || start >= end);
+	VM_WARN_ON_ONCE(start < vma->vm_start || end > vma->vm_end);
+
+	cc->scan_refusal = find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
+	if (cc->scan_refusal != SCAN_SUCCEED) {
+		cc->progress++;
+		return cc->scan_refusal;
+	}
+
+	/* Cleared only once a table has turned out to be there */
+	collapse_anon_scan_init(cc);
+
+	cc->select_orders = collapse_possible_orders(vma, vma->vm_flags,
+						     cc->policy.tva_type);
+	if (!cc->select_orders) {
+		cc->scan_refusal = SCAN_VMA_CHECK;
+		return cc->scan_refusal;
+	}
+
+	/* The scan narrows select_orders to whatever is left worth trying */
+	cc->scan_refusal = collapse_scan_table(vma, pmd, start, end, cc);
+
+	return cc->scan_refusal;
+}
+
+/*
+ * Cut the table into candidate windows and collapse what fits, from the
+ * largest order downwards.  Returns what the table yielded: a collapse, or
+ * the reason it did not.
+ */
+static enum scan_result __maybe_unused
+collapse_anon_pmd(struct mm_struct *mm, unsigned long start, unsigned long end,
+		  struct collapse_control *cc)
+{
+	return SCAN_FAIL;
+}
diff --git a/mm/collapse.h b/mm/collapse.h
index 1e969292edcb..e2af4c47cb60 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -105,6 +105,30 @@ struct collapse_control {
 
 	/* Each bit marks a PTE the scan accepted as a collapse source */
 	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
+
+	/* Orders still worth attempting in the table being scanned */
+	unsigned long select_orders;
+
+	/* PTEs collapsed in it so far */
+	unsigned int nr_collapsed;
+
+	/*
+	 * Why the scan would not take all of the table, or SCAN_SUCCEED if it
+	 * took every order it was offered.  Not the opposite of what the scan
+	 * selected: a table can be worth collapsing at one order and refused at
+	 * another, so a scan that found work still has a reason to report, and
+	 * the collapse reports it when it salvages nothing.
+	 */
+	enum scan_result scan_refusal;
 };
 
+/*
+ * Defined in khugepaged.c, which still uses them itself.
+ * TODO: move each into collapse.c once its last khugepaged.c user is gone.
+ */
+unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type tva_flags);
+enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
+		unsigned long address, pmd_t **pmd);
+
 #endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f31689bf75a6..26d25093260b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -498,7 +498,7 @@ void __khugepaged_enter(struct mm_struct *mm)
  * Check what orders are possible based on the vma and collapse type.
  * This is used to determine if mTHP collapse is a viable option.
  */
-static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags)
 {
 	unsigned long orders;
@@ -1090,7 +1090,7 @@ static inline enum scan_result check_pmd_state(pmd_t *pmd)
 	return SCAN_SUCCEED;
 }
 
-static enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
+enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
 		unsigned long address, pmd_t **pmd)
 {
 	*pmd = mm_find_pmd(mm, address);
-- 
2.54.0


