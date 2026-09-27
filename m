Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD97C9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 21:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14DA6B008C; Sun, 27 Sep 2026 17:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC59B6B0092; Sun, 27 Sep 2026 17:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DECA6B0093; Sun, 27 Sep 2026 17:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 778D86B008C
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 17:45:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 247E61A0A9A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:45:50 +0000 (UTC)
X-FDA: 85260874860.01.B7CB6A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 56F7140002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:45:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QaJRi6ZQ;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790545548;
	b=7ZAuJu0x/FkBBjCORpybDztPQlk2URkfuSEBnGnenJ3JYY6Pn8ugdvbWmIvfQSHSgxTUTA
	tbiktZUJD0eJpv+TRwJKqko7kX5vz9C92oPchAaCZc8GdcwyWR44XMY5HfNekTcmwRzeyr
	VVVMuf5Kw1+U8cVV6JBoD8fcCC6rfog=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QaJRi6ZQ;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790545548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGNdxSSdZkDgEWIxbIrSONNvgQ0foWsTVx0VRCiF5LY=;
	b=vspAuQYBCoGkZREiOBESokitO27pMDCVn88HBcQG2ch32GL8IysSa5W+b4yahwhNFXQ5jk
	nNzDzO1voW5qaoBnJeHCyBCrwFcN4fw3BS1gAER/EAi4l94W2KPJSRKvwFK/GgrAAH1BHY
	grc7zKrDys1MiwWr5tDnokHUe3H9QHY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5C6A60052;
	Sun, 27 Sep 2026 21:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0B31F000FF;
	Sun, 27 Sep 2026 21:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790545547;
	bh=KGNdxSSdZkDgEWIxbIrSONNvgQ0foWsTVx0VRCiF5LY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QaJRi6ZQjZOcqFIQsABru6Fxu7eHrYrTmN+siAsqk6ml3AhbO3meqysbRPj+lNI9d
	 5s0Dt/o+tP2L/+sk7+SIhi8NR++NyRXnq9jc9lXF3inCKDMhOWT+0txtKu+Tn4kNy6
	 l8A7g6vag+IL1N22uGqH8srlrVQFjO3G3rKtOAFI=
Date: Sun, 27 Sep 2026 14:45:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 liam@infradead.org, ljs@kernel.org, david@kernel.org, vbabka@kernel.org,
 jannh@google.com, ziy@nvidia.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, peterx@redhat.com,
 jgg@ziepe.ca, sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH v3 0/2] mm: stop calling pmd_folio() on special PMDs
Message-Id: <20260927144546.5141169bddc0ff1868c8ec17@linux-foundation.org>
In-Reply-To: <20260926105110.2156652-1-gourry@gourry.net>
References: <20260926105110.2156652-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ktzstnt95xd4t4tge93puo4zhw431u3n
X-Rspam-User: 
X-Rspamd-Queue-Id: 56F7140002
X-HE-Tag: 1790545548-971137
X-HE-Meta: U2FsdGVkX18fFKViZOGIIk5nvDyEjoCwP3fkt4P6RSQZ3HqZ8TenzvbmGfaha2hvWARiQLbQhR5ENyKlII3ASWaT9Rx64XHLlbT3iCZhsNxQMsNfUCYXmvkyTcrwo+GJ/a61mf67zd5diHA9u5f7u5NGUCfGlx6ulbY+fPqqIN28+eju7ahbVWbfemlRfFUAW/evJdlsdt283ZP4iDlrG/70r0F2Na2AeLevvoxTZUg3dnGYu0aanibPkVlRRsP5sEjXznckBPkYe8iwZmbA6lYIa1W2hi2qu2Qaf44eeS/2uFPJbudkpJgnnz+9HoE7dpby3ubli/Ud/uzodO/q2x1rR5rzEOMIsepGGJYnu6YjVWlYLMaoYpee4GAexhxGLhzbPh/qQYf8zDnajPuZVPfUtYz0sSH6M1TDBpzXqksG0E0815pJo3pvPyVMRp7MOw/IUxt7mpu1YC3JDJiJv7CtUc5ssWtbpFHc9Mx6lRJhiFifusMeZFtmHkX/6jlrUfV7lJCUra7W5hhxq4bBblFDVlmfaFLBdEDWq84DoxGsFiWzgditDlEMRqZquaOb8WVlPFGvUuSEfNDsNtbTilUOYJt9rfsGNAMpjx9cudVTqacbQZ8EY1sdFxgoxNUQxpQ6fRhLOH505HiIhlGmRujaG4/DZHepIoyH8TSntpN7+mtUJg8wHc7CcwfFyN6XXVv4nXpBRmP8OCDBiT2OkgMmWvaGsdEqpXEBofKym299FmoxT5hB6MGQa52kyBVjoJwJGbUMRoEqUJjGoXdPTqT8pqsMfZ3Uzs47UKGE6D30F7ro1pZGxSfbwdWahqLzE+W8CxdWMO6bY2Ld2qfTn+y4/exTi5IMIRD+KgLSX3qIEBmR5MrbR8yYLEs8uLT1Y9nN9KcLSLSlKsw5Zxn9I+C1YDv28qvwmC5zHKRrI/4PGRqYWoLr2vP+n8q339j/1BgiBeWpA47dArJy4Zp
 dIs0GtFv
 Le2Jcj7f6F38xlRDDCMBW8TZlqNnxLkVdsPaMJkkLbnIhwXioqr30tDn/JkOz2rJP4Lg7V/sGvVhtXdbaCBtfYn6Hsy7OGIxPmOL+uk5AQQ1hXtDNlqMmdKNvKIq71aWyIMGpsUEF3AspqdpqiZODntPUqAh22oW+2YRxqnnapjdlBL3XG7SrEjbKmbRdzZX+TvW8jB/XnlvicBAf6dtHEUvRKTtUIFDmwifnNg88ii+bxikSZw8MP40d5sA/O6tcspmREl0PwJDqYTOds5m1ksnLsJ/DMt8AlfK4dAsL6juKmDyo2aeCgMYvnVfcN1Ua4NeL/66P4sKm8X6TGq2l2tzq98mRDETJEhX1KffIyRvI11Ps+ZFxdhZWiO8lW9XJ9fNmWvjr/gHofN795p5LZoo1GBMHB6wVXNtCY24RCMAsx2NIA2PCNhrnxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 26 Sep 2026 06:51:08 -0400 Gregory Price <gourry@gourry.net> wrote:

> Two page table walkers resolve the folio behind a PMD with pmd_folio(),
> which is only valid for a PMD mapping a refcounted struct page:
> 
>   madvise_cold_or_pageout_pte_range()   mm/madvise.c
>   queue_folios_pmd()                    mm/mempolicy.c
> 
> vmf_insert_pfn_pmd() installs special PMDs holding a raw pfn that need not
> have a memmap entry at all.  Both walkers can reach one and fault on the
> first folio field read.  The PTE halves of both already use
> vm_normal_folio(); these two patches make the PMD halves match.
> 
> The four callers of vmf_insert_pfn_pmd(), and which walker each reaches:
> 
>   drivers/vfio/pci/vfio_pci_core.c        VM_PFNMAP     mempolicy
>   drivers/gpu/drm/drm_gem_shmem_helper.c  VM_PFNMAP     mempolicy
>   drivers/gpu/drm/panthor/panthor_gem.c   VM_PFNMAP     mempolicy
>   drivers/hv/mshv_vtl_main.c              VM_MIXEDMAP   both
> 
> can_madv_lru_vma() rejects VM_PFNMAP, so only mshv_vtl_low reaches the
> madvise walker, and that needs CAP_SYS_ADMIN.  queue_pages_walk_ops
> supplies its own ->test_walk, so walk_page_test()'s generic VM_PFNMAP skip
> never runs and vfio-pci is reachable by any process holding the device fd.
> Hence the different stable tags.
> 
> One behaviour change: mbind(MPOL_MF_STRICT) over a PMD mapped VM_PFNMAP
> region now returns 0 rather than -EIO.  The PTE loop already returned 0
> there.  drm_gem_shmem and panthor are where this is observable, since they
> PMD map pages that do have a memmap entry and so never faulted.

Thanks, I've updated mm-unstable to this version.

> v3: improvements from Lorenzo

Here's how v3 altered mm.git:


 mm/mempolicy.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/mempolicy.c~b
+++ a/mm/mempolicy.c
@@ -668,7 +668,7 @@ static inline bool queue_folio_required(
 }
 
 static void queue_folios_pmd(pmd_t *pmd, unsigned long addr,
-			     struct mm_walk *walk)
+		struct mm_walk *walk)
 {
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
@@ -680,12 +680,7 @@ static void queue_folios_pmd(pmd_t *pmd,
 		return;
 	}
 	folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
-	if (!folio) {
-		if (is_huge_zero_pmd(pmdval))
-			walk->action = ACTION_CONTINUE;
-		return;
-	}
-	if (folio_is_zone_device(folio))
+	if (!folio || folio_is_zone_device(folio))
 		return;
 	if (!queue_folio_required(folio, qp))
 		return;
_


