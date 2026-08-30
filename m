Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C904BC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 05:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FC5C6B0092; Sun, 30 Aug 2026 01:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4D16B0095; Sun, 30 Aug 2026 01:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9A86B0096; Sun, 30 Aug 2026 01:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAF166B0092
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:14:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60788A2867
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:14:15 +0000 (UTC)
X-FDA: 85156769670.13.C6770FE
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8CD7540003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:14:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=S6Dx+Nqb;
	spf=pass (imf11.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.214.169 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788066853;
	b=AeDUCdVw50O7rxQC/C3WxUjxEDJi4n5NTNq4VxEYhfaDLL9Gh7yHT8FVdQnMQaxgCEF1dr
	x+nW3TRctiWCenYAU5uFg8lMGKIP1sz5nJ4ICRYII7SGXzBPFX4mo/7QzgcJGPsUNYK0RX
	9tukDbps2Ynf8RT5lNYhePyf4ty06ac=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=S6Dx+Nqb;
	spf=pass (imf11.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.214.169 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788066853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ezj01Z6T9okgOiQa4EOGNSsW3Mil1bOoLksIRT0LM8A=;
	b=xPWLIwE+j+5er2ReFa4l74Cc0VJUvb3tUZhZsQhA1frNZr7nVUhAX0ih9ucGF6qKkwT8DL
	WJot2MeJXw+6ArWlp51Wa/ENPWwNwSLdFiUbPHJMVv5xbN+Xw0M2WZOQWgvk1X1FEXkthF
	hHvizWcDa8jIzpawFnUEVoI/5RWPMxM=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d71ae3455aso36927665ad.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 22:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1788066852; x=1788671652; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ezj01Z6T9okgOiQa4EOGNSsW3Mil1bOoLksIRT0LM8A=;
        b=S6Dx+NqbsoyAF45pxkusiGaV8/VbVxSs15kuSet3yKpFmJhJHVr/JUdSSdgl5UdWwU
         rLISVVrOGUlgkTC1SSKkn6sfqfNCLSwIHwB0qfcql55aaQU8xizAPRnn8v6W93En22Cq
         4v7qgCCaJzLN280aK22U48XA+p0LR01C2b/PHaFRiCleBcEO7wuRGc3+MPwx5iykMPoc
         Wk9/MFVTSDg56eGDIE2RPxJizoYAqRXEJ9ESjIbHsvpaQUjz8FAAZoefcd3mkpxgxgqQ
         0B1Sdtgs62RPTUFjV/iQ4DdIWIWFO3xzaCyCSD5MiIRdVwHLuVZ+GI2mfVArNKHQwvUq
         m1gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788066852; x=1788671652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ezj01Z6T9okgOiQa4EOGNSsW3Mil1bOoLksIRT0LM8A=;
        b=E8QGI9LnEkKMD2zARAs8jfrclNJ8NMtFSn9wGloLN8L2XVKhb6gSPQgATuZBWslc7I
         ZhRSlnSAxUXcxIpiO2Zr6z4QMmrqvABZwaK6rgtKNGpcubah7mtbslb6U5OofvPQKrhM
         RXISr+SvUhQPNljaRHN3KyxAcqdok2jI92KbS+BM1QpysmH9mQmrmwSAFnjfrzOoxvCS
         Mjl9fZtGHZGZSPyIpwW6d+9tsI0vL5+h1hmUU2vSRfp6FwqmS2jpQzSqzzQm819L0ulK
         boJArtJEwuIwayVZmOIJ90Za2XemnZ1/8KD+AxwovJRPPe5XI1Wk0kfl7oKEcoubWyI+
         2QzA==
X-Forwarded-Encrypted: i=1; AKwUvBwP4qu4DTDUXG6t0kQewDqW9fPVwvSsTYdWLEaXsqutPG+avgxwVqb6rIv5zH0l0yBY/w2maflLvw==@kvack.org
X-Gm-Message-State: AFuF++niV7f/lMbX1K9clw2k8iarNBd2hEIJ75h8ndTBUO1hte9JFo3Q
	mPqp9A8w3+BBy/i5YnfKcI/TVXECol4MbkrUtE6sFHZLPxIaJGUa2Iu+UnY+gx4r/2Q=
X-Gm-Gg: AR+sD12dCURxrfdpB+VO2mYwPMxx3xFBKDuNeoVNH17xRlbUwyBV6NQ07i1H6Osvl1t
	XyHRcMzfwVkV6ZowcSIe4Yli2Mngkj/oB9zzWVtY4Qj/I8t6+ytF9DGvpeKwSttV/0q9AmkolJZ
	jdl0UBef/jd2nDg65zavb1pLx34NtRIljLUsslBlVGpL0i8pTaYsfrMRjTJEzdfPtxpMPiVY1nx
	N8ZTHoEJXDBT7WH/Tn6xSfDg+9XHG6apCzZkg2RZkmjr0t/5Vztuct+0BMoQP5s7rm+6x57kyJ3
	KrCu2hGitXSH/k+8AoZuBKZWJpVLgT2S5tYwKK+9FNwndqXGdYBgHwxQ9uu3nPjcgb1bqx6hso3
	l6bXOKPKGjbH04LuPjyjHlmca0txkza7ZsWdShlRlX2fJfG/cdrnu+153TQwJWfC8tfUeX+9FIw
	QjCsMg1HpR70eCZN1S4hRjsETKl8+SD8w+apAOI907SnSjD1b5s3cNnbi1omwKhJbGmFYDqGe47
	WJF99h8GZp0P8qLSl3h1HBqyhXZ4ettCTBZ
X-Received: by 2002:a17:903:2342:b0:2d7:414e:f2f with SMTP id d9443c01a7336-2d74def676fmr265059445ad.14.1788066852465;
        Sat, 29 Aug 2026 22:14:12 -0700 (PDT)
Received: from MBP-Krishna-Iyer.civet-hops.ts.net ([2601:645:c68a:b830:d101:1d:112c:715e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286fa37fa5sm22595810eec.29.2026.08.29.22.14.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 22:14:12 -0700 (PDT)
From: Krishna Iyer <kiyer@crusoe.ai>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Krishna Iyer <kiyer@crusoe.ai>
Subject: [PATCH 3/6] mm/damon/paddr: support hugetlb folios in access monitoring
Date: Sat, 29 Aug 2026 22:14:04 -0700
Message-ID: <20260830051407.50008-4-kiyer@crusoe.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830051407.50008-1-kiyer@crusoe.ai>
References: <20260830051407.50008-1-kiyer@crusoe.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8CD7540003
X-Stat-Signature: zn1h6s7fjrgkxuh83k1jcqhbu95pjpic
X-Rspam-User: 
X-HE-Tag: 1788066853-701343
X-HE-Meta: U2FsdGVkX18arwiznUHN9BAv7uYUz0XQLxNC3E7/35H3xeckd9TUdbFRdOccs1snAAXkWQexuT//9/W+NbsXo+OYjwEl8ECOUF7BKbJ9UUbnKWq4dmFQ9fabTHMysL9NBQbSBQqcvELamqIeuf+hS6LoiU6vFfY/mMZbwQhFE8tSRIHemE10NAknh/pIz7mhwo+zC2wczaycsh7jPp/rOfCYeJX/UbmnZnOx8ixBwOR8oVoDBiYfyVd4676KAW+2/spLcD0XgqDy8uEQnDx92w01qbjDBQjGK3ucjfbkdfs3tQU5gCaHGYa2tr/EnOPVmq05f8hwnPMohOuZQVOQjiaB86EhqaeGofntakVFmjeESFHSx0SY0m+/zFwW5H27Qi5zPopidryqBJZ12tMq5YvHPVZGlX02v9DQktZUqK12m29VOfBSc89oIO/mT/Cdh2uhnEXRgvYktmCcQR2jnGPCaD0n/x7NwbnNUlSF+xD1TABeolxLjBGxzaVFUidO13nVh/rfU+SS+x6w+qFCcCgHEDavx+f7Me4+lIm4GLIbNzu37a6553kGgu/sX7pg2ex5VjTM0bDXsU2sL5IfZ1AtCFq4hezUdtw9vIKzeeCBptS9d5bR+25HAFmVmi01aZ1C4rG4Wm3yXQRQ0q9ryzEC+u7uIfwT1X+exrersfNwLyFtlMYXXxXdtB0zrqmhPUtTauzWVhEwDFcxdq81n8mPyLvE81gqP6r3FkrjMHjM379a1fVvJSJCHW16/FHGyw6L/V7aYnSLO11hwbGo49tSpstXkK8nA2apTGhIdFOqX//tToTRv0ssMnc8AQ1cYAuGu8Ozu7vEdqX4ejOQ8V5TnSeptQ43b1Jk4PuWGWxmw+TP2ciTsFoXblZHuYGvDdBIDe0kN4FusbeyOyr1VegL6UCBiZoLjCGyRsv+pLN6savuGdxK2uK8ltueNqIkIsSW5G3EhpodYwtpsM9
 +VsLFDQ6
 5Thd6K3DGYoz5xP6V0gpIt+7qHZm0gS1SYXoOnfiTV/rwc0z6z18xxulVDq+xL8+mg9Wzfe3k7QYiw6oeNhKi2xqQqe+idR3HyimXPTtDX0MfeOwlTyUYYIpTd818WhXV+Z5MIo+8tYMXd6qJToVs+LnAk23TmGDClPIGWDRD/SNkH/JzeyZOyilYdMfkvT0pFGLUqsz5b10M/eBOvWLBNT/bNO+4X1GmlqM+ZqFQJkTCKNmzDyGOtPuTOnnJISGo1BgNn+bRz0tL1lRV7p21PpOjmdBYcIdVvRQVjeK+S2JqPOe+03Nq/YTkgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON's physical address space monitoring is blind to hugetlb-backed
memory.  Every access check starts at damon_get_folio(), which rejects
folios that are not on the LRU lists.  Hugetlb folios are managed
outside of the LRU by design, so every sampling attempt on
hugetlb-backed memory silently fails and the pages are reported as
never accessed.

This is a significant blind spot on virtualization hosts.  Cloud
hypervisor hosts commonly back guest memory with 1 GiB hugetlbfs pages,
covering the vast majority of the machine's memory.  On such hosts,
modules like DAMON_STAT observe only the host-side remainder (kernel,
page cache, daemons) and report all guest working sets as permanently
idle, defeating the purpose of host-level access monitoring.  In
testing on a 1 TiB host, an hour of 4-thread random access over 842 GiB
inside a guest was statistically indistinguishable from an idle host,
while a 40x smaller host-side workload produced a quantitatively
correct response.

Add damon_get_folio_incl_hugetlb(), which additionally accepts hugetlb
folios, and use it in the two paddr access monitoring primitives,
damon_pa_mkold() and damon_pa_young().  With the previous commit
teaching the folio-granular rmap walkers to age huge PTEs and to call
the mmu notifiers spanning the whole huge page, this makes guest
accesses visible through secondary MMU (e.g. KVM/EPT) young bits.

Free hugetlb pool folios have a zero refcount, so folio_try_get()
naturally keeps rejecting them.

The DAMOS action appliers (damon_pa_pageout(),
damon_pa_mark_accessed_or_deactivate(), damon_pa_migrate(),
damon_pa_stat()) keep using damon_get_folio(): reclaim, LRU
manipulation and migration cannot act on hugetlb folios, so their
behavior is unchanged.

Note that the access check granularity for hugetlb-backed memory is the
huge page size: one touched byte reports the whole (up to 1 GiB) page
as accessed.  Also, DAMON now consumes secondary MMU young bits that
KVM's own aging uses; at DAMON's sampling rate (one page per region per
sampling interval) the interference is negligible.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
---
 mm/damon/ops-common.c | 31 +++++++++++++++++++++++++++----
 mm/damon/ops-common.h |  1 +
 mm/damon/paddr.c      |  4 ++--
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 62004206ca31..ece101d34684 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -15,14 +15,20 @@
 #include "../internal.h"
 #include "ops-common.h"
 
+static bool damon_folio_observable(struct folio *folio, bool incl_hugetlb)
+{
+	return folio_test_lru(folio) ||
+		(incl_hugetlb && folio_test_hugetlb(folio));
+}
+
 /*
- * Get an online page for a pfn if it's in the LRU list.  Otherwise, returns
- * NULL.
+ * Get an online page for a pfn if it's in the LRU list, or a hugetlb folio if
+ * @incl_hugetlb is set.  Otherwise, returns NULL.
  *
  * The body of this function is stolen from the 'page_idle_get_folio()'.  We
  * steal rather than reuse it because the code is quite simple.
  */
-struct folio *damon_get_folio(unsigned long pfn)
+static struct folio *__damon_get_folio(unsigned long pfn, bool incl_hugetlb)
 {
 	struct page *page = pfn_to_online_page(pfn);
 	struct folio *folio;
@@ -33,13 +39,30 @@ struct folio *damon_get_folio(unsigned long pfn)
 	folio = page_folio(page);
 	if (!folio_try_get(folio))
 		return NULL;
-	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
+	if (unlikely(page_folio(page) != folio) ||
+			!damon_folio_observable(folio, incl_hugetlb)) {
 		folio_put(folio);
 		folio = NULL;
 	}
 	return folio;
 }
 
+struct folio *damon_get_folio(unsigned long pfn)
+{
+	return __damon_get_folio(pfn, false);
+}
+
+/*
+ * Same to damon_get_folio(), but also accepts hugetlb folios, which are
+ * managed outside of the LRU lists.  Aimed to be used by access monitoring
+ * primitives.  DAMOS actions that assume LRU-managed folios should keep using
+ * damon_get_folio().
+ */
+struct folio *damon_get_folio_incl_hugetlb(unsigned long pfn)
+{
+	return __damon_get_folio(pfn, true);
+}
+
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr)
 {
 	pte_t pteval = ptep_get(pte);
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index f7811c9c7a02..68d7de49c87a 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -6,6 +6,7 @@
 #include <linux/damon.h>
 
 struct folio *damon_get_folio(unsigned long pfn);
+struct folio *damon_get_folio_incl_hugetlb(unsigned long pfn);
 
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr);
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5c6c3a597fd0..09d418b2874b 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -37,7 +37,7 @@ static unsigned long damon_pa_core_addr(
 
 static void damon_pa_mkold(phys_addr_t paddr)
 {
-	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
+	struct folio *folio = damon_get_folio_incl_hugetlb(PHYS_PFN(paddr));
 
 	if (!folio)
 		return;
@@ -67,7 +67,7 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 
 static bool damon_pa_young(phys_addr_t paddr)
 {
-	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
+	struct folio *folio = damon_get_folio_incl_hugetlb(PHYS_PFN(paddr));
 	bool accessed;
 
 	if (!folio)
-- 
2.54.0


