Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3672BF5141C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 23:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B786B0005; Fri,  6 Mar 2026 18:20:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013416B0089; Fri,  6 Mar 2026 18:20:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82856B008A; Fri,  6 Mar 2026 18:20:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D84E86B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:20:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6DF8B1406FF
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 23:20:47 +0000 (UTC)
X-FDA: 84517210134.26.BEDCB96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D2B354000C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 23:20:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IgOnLcro;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772839245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vdvaJB1LXFNDY6a15oc69M98GTl99EifvhmpoI/28Eg=;
	b=NRQKdYXjjAHRokkEaNF/hXQGxMnnB1+6oxUydC9Ek8zQZmJhxmfP6HFK18jOYu0ecDuGuP
	g8GqhUqwVlOAQjqUM4hN/b6/sL+sgLNmI9imFlznbT3qRAV4TvJObQECTa8toCZQSczAwg
	nNtMswPda+/pGMFLIgclgJu/tdNxDLY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IgOnLcro;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772839245; a=rsa-sha256;
	cv=none;
	b=xpCBx9249ZtkFxtM9ajdaTacw4pnukEw7Gas9TIsVgjpKPl4rRHRI2kW0Dt2yCcBo/P1q1
	WqxOGHrJScsHB+nIeGczg50RJ0+Qp+gSOeRTHJTGD/9yVCVvgwmTbCWkSoov+GgIHYW8l8
	oXY9IBwmGGhY5uGqxYmu6SO5HJWGKLE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D945560053;
	Fri,  6 Mar 2026 23:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC82C4CEF7;
	Fri,  6 Mar 2026 23:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772839244;
	bh=ax1SAYo+iTD471lZ8SZC4G6BL2Js8nhv7iBqCbhvGm0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IgOnLcroN+Cq4+uoc9rtF5U2JdkUFn/isXguriJYr4aQzvF25A5VeON8B+f31ceaY
	 sxF4gZK9IF/xbEJi8UmLT5YkJqdECPNh7wKqzOYAy+udOV+IQEhKFAet4DKkkeRx9X
	 X106S6MIa49lZe6PUl6PJ2LzW+cudcfxt3A1T4Xk=
Date: Fri, 6 Mar 2026 15:20:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: david@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] support batched checking of the young flag for
 MGLRU
Message-Id: <20260306152042.8516ec644e95e9a23df30e5f@linux-foundation.org>
In-Reply-To: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D2B354000C
X-Rspamd-Server: rspam08
X-Stat-Signature: 3k5g78f4z7agrr63j8wnpppti3hoa4re
X-HE-Tag: 1772839245-386819
X-HE-Meta: U2FsdGVkX18cUzLXeZejuJhohtvvywTHrS+MFUXEsxlTdq51ZT4wGIYby6ARecBq20GqBasqEmh52rJpy179iwnixbGmztG2UB9dkLjvj7YcfplUesEpwjgRuBTVSgBQqO+r172QQPH+064hQ7+0Lwk2Cz3vbry6/Z8LcArO2XNcXKX2mE86+4MZzOfzaEdMlSb8I19MPCg6PHggsJZwZHwC77XeEM4MlwdHf6u0ZwQ/z74ZozlMtwkcpHx82IwIwdOMeYC5o/EIIsWUQ5Y2saU9Hfcs3SzTAUGrRM1MSg5xoWGQYVvjjLu0WmTFDPeYfF9SpBH/DX/xpHi1Mp74vUTFM1CyfezwdjxX6VqILyOroABh/gg1gpIxJZgluZuaRxFUIfEe0JD5RsBOvgYk9S59zYmdmbqnMl4NwHlRh/wJrh8EYYnroau3xlpM6du6UZLSbi5aapplpyFnd361M3L4gJ+WJCYcM5PDdvggczBA7BXFyoDCMycD3AqzaXgMvGXhFHcgwFe6PI15CJgAg3VU82xcRoJ5NSmpVhVZek2+DQSyKzXaNNt+kmts9l0khMTdoGlxtrQCUHp5mzN5S4L7BiYwOdE2YYNZOfi8TuKfS0eWi3v/SFEHpiQ3YmLWK1qsZHihnXtJ8p3ghvnZq+KfG/4dCY5BaGDuq5f2FYRgRiBI2YyYg8/LFjB5shelpVjn9IPqckV6R86/DkZzIRESWZDY1JcU5a8Te1ZyHbU8fMr+4VXSwF37n1qOF8FMx7zj/T2xBlgNPkIg1GqtJuu3qGetd4+Xd9+b3OoEIdPUeBTEM0qWK7U/Kvsg0iTrtRRdapsUGcVRWeDui0JQFaJGSTd8atgL6RRSP2IXmVrSmyJe/OihUC01Czc2qZzka7S+6IXg5kJuSl8d1wF8+Ve0I/IjGV6AO6/wODoCFKy2rv0YEwhnKKFhx4tk6nH5lSklbDMJAGIrD9nDZzN
 6KL8IE3e
 exC3lnjJVvIsx8j+ldrmGvAR35ZUZsV/6gDPMGYGpsDHdmPk0qzb3STbJAh40ZCkPwQmaygxMGiDizOPzKSYnMeKXRg7xuNSXyce9X/ue14P+wHcsQ6lCAPOC1ZPBrNrirVIFixSEaJTZdy/QK6zSbUxLHwK1DooSjnGdkmh3cjGFwA4yGk3X53pKugzixRI3DeKigpv+5O8SDXvrvawYWmPNMjuTz/pDsWReyZTiw1Vkog/45EeH5QeA0bcVyW57NY27u/sc8on/K4Ehz2c9qf6tyntGtNVGIGwXzbPe4ldXbpQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  6 Mar 2026 14:43:36 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> This is a follow-up to the previous work [1], to support batched checking
> of the young flag for MGLRU.
> 
> Similarly, batched checking of young flag for large folios can improve
> performance during large-folio reclamation when MGLRU is enabled. I
> observed noticeable performance improvements (see patch 5) on an Arm64
> machine that supports contiguous PTEs. All mm-selftests are passed.

Thanks, I updated mm-new with this.

> Changes from v2:
> v2: https://lore.kernel.org/all/cover.1772185080.git.baolin.wang@linux.alibaba.com/
>  - Update the commit message of patch 5 (per David).
>  - Fix some coding style issues (per David).
>  - Remove 'cur_pte' variable in lru_gen_look_around() (per David).
>  - Move 'ptes += nr;' to the suitable place in folio_referenced_one() (per David).
>  - Add acked tag from David. Thanks.
> 

Here's how v3 altered mm.git:


 include/linux/pgtable.h |    3 +--
 mm/rmap.c               |    2 +-
 mm/vmscan.c             |   11 +++++------
 3 files changed, 7 insertions(+), 9 deletions(-)

--- a/include/linux/pgtable.h~b
+++ a/include/linux/pgtable.h
@@ -1124,8 +1124,7 @@ static inline int clear_flush_young_ptes
  * Returns: whether any PTE was young.
  */
 static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep,
-					    unsigned int nr)
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	int young = 0;
 
--- a/mm/rmap.c~b
+++ a/mm/rmap.c
@@ -964,7 +964,6 @@ static bool folio_referenced_one(struct
 			pte_t pteval = ptep_get(pvmw.pte);
 
 			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
-			ptes += nr;
 		}
 
 		if (lru_gen_enabled() && pvmw.pte) {
@@ -982,6 +981,7 @@ static bool folio_referenced_one(struct
 			WARN_ON_ONCE(1);
 		}
 
+		ptes += nr;
 		pra->mapcount -= nr;
 		/*
 		 * If we are sure that we batched the entire folio,
--- a/mm/vmscan.c~b
+++ a/mm/vmscan.c
@@ -4201,7 +4201,6 @@ bool lru_gen_look_around(struct page_vma
 	struct lruvec *lruvec;
 	struct lru_gen_mm_state *mm_state;
 	unsigned long max_seq;
-	pte_t *cur_pte;
 	int gen;
 
 	lockdep_assert_held(pvmw->ptl);
@@ -4247,10 +4246,10 @@ bool lru_gen_look_around(struct page_vma
 
 	pte -= (addr - start) / PAGE_SIZE;
 
-	for (i = 0, addr = start, cur_pte = pte; addr != end;
-	     i += nr, cur_pte += nr, addr += nr * PAGE_SIZE) {
+	for (i = 0, addr = start; addr != end;
+	     i += nr, pte += nr, addr += nr * PAGE_SIZE) {
 		unsigned long pfn;
-		pte_t ptent = ptep_get(cur_pte);
+		pte_t ptent = ptep_get(pte);
 
 		nr = 1;
 		pfn = get_pte_pfn(ptent, vma, addr, pgdat);
@@ -4264,11 +4263,11 @@ bool lru_gen_look_around(struct page_vma
 		if (folio_test_large(folio)) {
 			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
 
-			nr = folio_pte_batch_flags(folio, NULL, cur_pte, &ptent,
+			nr = folio_pte_batch_flags(folio, NULL, pte, &ptent,
 						   max_nr, FPB_MERGE_YOUNG_DIRTY);
 		}
 
-		if (!test_and_clear_young_ptes_notify(vma, addr, cur_pte, nr))
+		if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
 			continue;
 
 		if (last != folio) {
_


