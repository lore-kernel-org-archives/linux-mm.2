Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0980C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 10:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72B36B0088; Sun,  6 Sep 2026 06:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23B36B008A; Sun,  6 Sep 2026 06:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39556B008C; Sun,  6 Sep 2026 06:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88FB76B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 06:00:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0237DA04E2
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 10:00:40 +0000 (UTC)
X-FDA: 85182893082.24.6109886
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3D73240006
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 10:00:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Akn72PWI;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788688839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snH3EbBb/iu4/hpnhb7Q5dASnycbjTC3AQM0O003+3M=;
	b=iay6JXfk/KcHoNq8hF/HxPHMB/u9DhwvBaAwpWwy24XQ6OGDDsTTYK9+aHnoY1fFCG7FK2
	CgzGPZcs+aKkIhAD5mL63PkDBtYCPxiS0RnmsZeArKcgr9sxTJOemqXz2di4MwVvQnm9Cs
	XqrbmaLBytI1OEI9V1NyBGq3sgoSR4s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788688839;
	b=Uo5jg8kf6hm5awOuv8LjHSIDwzDeot8k3fp8D2sCKuGjgVpTwlatfi7GNChAyK7OIRyB4d
	FMOqsbGmGCXTmlEiaKc+Aaeq9vv5w06XEiuEMHln0jMXfTpu8jQH94PGfIa5xje8oLb3ek
	w4JgsktvFs7x1/ffB6Jnu81RyDWsZZo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Akn72PWI;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F82D43D7C;
	Sun,  6 Sep 2026 10:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7151F00A3A;
	Sun,  6 Sep 2026 10:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788688838;
	bh=snH3EbBb/iu4/hpnhb7Q5dASnycbjTC3AQM0O003+3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Akn72PWIRJjwB6g+ptMXNhnydqgYB8YJdpJbWNP83TRqfLEPm6hacZqV9dTqOwkiN
	 HOC863VLgNfr8uXx/bu+2eqqCfm8crNSNg8eS2E4dk8oFFSQX/z2ECjQ+FHOvIs5Cr
	 Dn0Ws1XP98TBSlQJHHebBauNHrwOLGAoGYr/5E8RRZg7itrF4eSjIEnQ0jC0av8TvL
	 8ZeOHsokWT65OKsh8d7cTYP+aoeLFFE8FbNYwjZsIoD3/dUC3f8XKU/PlvEG4RLQSp
	 wVfhX0EnU1daZTI3X6ha/cPMtcae2UoCguWVUAJTPE9bVs1js6l0PjejQP82bmHtlS
	 OfRV0zoMv61iA==
Date: Sun, 6 Sep 2026 13:00:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	usama.arif@linux.dev, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	kas@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
Message-ID: <ap05ue1pq3TgHOS6@kernel.org>
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
 <apk8ZRr6do_YAlzf@kernel.org>
 <CA+qSx6wqd5VSR=9yarFFmyN1SyvLJqEHpA7BwmzuxNQTHbS=Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+qSx6wqd5VSR=9yarFFmyN1SyvLJqEHpA7BwmzuxNQTHbS=Xg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D73240006
X-Stat-Signature: 6k4jaa9nh9cg1gz1hr9mj8e17rjysmei
X-HE-Tag: 1788688839-517461
X-HE-Meta: U2FsdGVkX1/Z7t2XMBYdApcrQSTnN6bdxIbBHKWMFUOlEtzVFdYPJMt36/MijgteU7ww4Z0FrAWJBkWfP+k99hjk2JKjdGS/Dr1jmNQwhMSX4av9gGVS7Me5frYAZ3u2SYTVrppedezvdLr1WK1qjCrlgXlZb1jzEWmwSdE3VsokA5zQ4B1E8GtsyMgmhMdWpHIRT18vP/SUBZrfDZ7PHqn8lHyFhzYhg/DyZ6aP/jhPu+Q5xKheW3d5f+AbSGVs8lqFGriq+z+hDTljsxV9ii1KYasqBV/T3FSkG3pU7BovDn1iDJeVIekADOVWkxDGVK/9on74ns0f2JIwz/xrrtE1HNSvZDb471SsQ/1yhJuEy+qKI4mi03q9y0Jah8MLjCw0lm+1yLodVo+mvcF4fH9qLdln2T97XUVLSpVt14gZQa6iXRhSW7vnEzS9LHwd9rwS+Qh/LliTYeV753sK6Dkj7tD7czisx7w6X0Lc2ZV9hpujw1eaqjJ/w1DVE9OMbboecu0TEkWn5YFckVCFcPoRi3U5ULdtQMVqVJcxlzieixGHSKdgRSoDk40P4ykLC4o2i0g1XkUe0EprZ18W9Ti/IkdB9d9ReOK8pYcvqu2lX15QQcYrzvD9DgVxZTmtslr77QJo8m8LBGP/ngMIeRYWKsGlfvZvii8AK3o9DMdv6JADue7ygAcBkKQUPWx1+7GfoZqSQkbvVMq+RTf8YoVfSsOyLeQ6NT9p7meOFAV0X7rJXvl00z1U9rFm+Mmy6TrPcR69IJ++yyGtvAeGA4dxklvNr+cLTlUNFBYN1ieKCKwhntV6p9wYfuvRSbYaPVwKJvZ2qa3YL6EI0n0gJEBH+XOKXUuckHsoF/O1owtCKF0IxWHV/TqPhccn9tehNw0pWbN8UdZpU7TJiqp30TYK+vKtgbcr248R7m+Iqak4S89b3UtJzot7nBQ2iIQugchfMiKFO7IH36Uj2SX
 pgrbaA/y
 b8sfCeX51yE2Aui0auyimcc8v9WzKD7b0YNNI/ATJFUKkjsSIwZzVck7AvQSbxi+xZ8qU2JunzhlnkGBtVQ3210IfbPjpL7LsUqGER0zJhjlm/1RJtVxinGwdhTcKbu5YRCZxH68AMM7anmChECnJg/gFFzQw/ascLQZ6HCDoSVBGNq/SRbJhoxOMQnQ+5wx4MogyTPZuJ9X2Jf0zfF1c2Fp6dbPtY0FRx5AloGpd4KYv5DNeRdc2ia5Dm2HJyq2Yl06r1H07SGN7qIITNyfk+yuPKYrvQi9nmxUbRud59/aJMMDK+7dDAi4isyL/kOYDqVxWfBwYIwGZdZgdLNMzrt2LRiaiucV/DQ8Aug8w3bNMXln1TfM2ryUcqQm0WcgBXcYDXql9l23pxUva9nHJgcaoFpWN8OUULDwlVWnxOly7uq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 08:49:52PM +0800, Xueyuan Chen wrote:
> On Thu, Sep 3, 2026 at 5:22 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Tue, Sep 01, 2026 at 11:18:16PM +0800, Xueyuan Chen wrote:
> > > The persistent huge zero folio is shared globally and should stay zero
> > > after initialization. As Jann Horn pointed out [1], kernel bugs have
> > > ended up writing to pages that were meant to be read-only, including in
> > > security-sensitive cases. Making the folio read-only in the direct map
> > > turns such writes into faults instead of silent zero-page corruption.
> > >
> > > Add a page-based helper consistent with the existing direct-map interfaces.
> > > Handle TLB invalidation in the architecture implementation; unsupported
> > > architectures retain their current behavior.
> > >
> > > Protect the folio after initialization. Skip highmem folios, which have no
> > > permanent direct-map mapping.
> > >
> > > Inspired by Jann Horn's read-only zero page work [1] and follow-up
> > > discussion [3] with Yang Shi.
> > >
> > > Link: https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20b49@google.com [1]
> > > Link: https://lore.kernel.org/r/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org [2]
> > > Link: https://lore.kernel.org/r/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com [3]
> > >
> > > Suggested-by: David Hildenbrand <david@kernel.org>
> > > Suggested-by: Usama Arif <usama.arif@linux.dev>
> > > Co-developed-by: Lance Yang <lance.yang@linux.dev>
> > > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > > ---
> > >  include/linux/set_memory.h | 17 +++++++++++++++++
> > >  mm/huge_memory.c           | 13 ++++++++++---
> > >  2 files changed, 27 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> > > index 3fe293cfed8c..ed9ce04b18a1 100644
> > > --- a/include/linux/set_memory.h
> > > +++ b/include/linux/set_memory.h
> > > @@ -54,6 +54,23 @@ static inline bool can_set_direct_map(void)
> > >  #endif
> > >  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> > >
> > > +#ifndef set_direct_map_ro
> > > +/**
> > > + * set_direct_map_ro - make a direct-map range read-only
> > > + * @page: first page in the direct-map range
> > > + * @nr: number of pages in the range
> > > + *
> > > + * Make the direct-map range starting at @page read-only and invalidate stale
> > > + * writable translations before returning.
> > > + *
> > > + * Return: 0 on success, or a negative error code on failure.
> > > + */
> > > +static inline int set_direct_map_ro(struct page *page, unsigned int nr)
> > > +{
> > > +     return 0;
> > > +}
> > > +#endif
> > > +
> > >  #ifdef CONFIG_X86_64
> > >  int set_mce_nospec(unsigned long pfn);
> > >  int clear_mce_nospec(unsigned long pfn);
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index 54494c3fa983..742283b36d74 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -42,6 +42,7 @@
> > >  #include <linux/pgalloc_tag.h>
> > >  #include <linux/pagewalk.h>
> > >  #include <linux/cleanup.h>
> > > +#include <linux/set_memory.h>
> > >
> > >  #include <asm/tlb.h>
> > >  #include "internal.h"
> > > @@ -291,10 +292,16 @@ static int __init huge_zero_init(void)
> > >       huge_zero_folio = alloc_huge_zero_folio();
> > >       if (!huge_zero_folio) {
> > >               pr_warn("Allocating persistent huge zero folio failed\n");
> > > -     } else {
> > > -             huge_zero_pfn = folio_pfn(huge_zero_folio);
> > > -             count_vm_event(THP_ZERO_PAGE_ALLOC);
> > > +             return 0;
> > >       }
> > > +
> > > +     huge_zero_pfn = folio_pfn(huge_zero_folio);
> > > +     count_vm_event(THP_ZERO_PAGE_ALLOC);
> > > +
> > > +     /* Highmem folios have no permanent direct-map mapping to protect. */
> > > +     if (!folio_test_highmem(huge_zero_folio))
> > > +             set_direct_map_ro(folio_page(huge_zero_folio, 0), HPAGE_PMD_NR);
> >
> > Sorry, I don't remember if it was discussed previously, but why can't we
> > use the existing set_memory_ro() here?
> 
> Hi Mike,
> 
> We want to change the linear map here, but arm64 set_memory_ro() only
> works on vmalloc addresses.

I believe this is an historical artifact. change_memory_common() already
updates the linear map when a vmalloc mapping switches to RO and the system
supports it.

I believe arm64::set_memory_ro() can change the linear map in the general
case as well as long as can_set_direct_map() is true.

> So a new helper is needed on arm64, and x86 implements the same
> helper to keep the two architectures consistent. On x86 it is
> basically set_memory_ro() minus the alias check.
> 
> Thanks,
> Xueyuan
> 
> >
> > > +
> > >       return 0;
> > >  }
> > >
> > > --
> > > 2.47.3
> > >
> >
> > --
> > Sincerely yours,
> > Mike.

-- 
Sincerely yours,
Mike.

