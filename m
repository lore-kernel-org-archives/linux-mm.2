Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 783A7CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09276B048B; Tue,  2 Jun 2026 00:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BA426B0490; Tue,  2 Jun 2026 00:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA0E6B0492; Tue,  2 Jun 2026 00:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7610C6B048B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:22:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0260C407F3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:22:28 +0000 (UTC)
X-FDA: 84833676018.25.3D1002E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 46C14C0004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:22:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SeRc4CB3;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780374147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXGOCPORwRtBIOtgSlL5BmqNdJWalyZfji2BLv/IMKg=;
	b=huTYo/t6mP0YqElz9XL4qAazZmQ6JkwY0duTsimkEqK2GncdYHbiFkQyilXaGxUxUuok1x
	o/tl1yvw8BsX/K9lnTLSto02B0Zhn/cdSz3rREbsRgAkzToRsr+oHaJD/VPRFB0Rs45yZ+
	4PaidaCFi0rjXmHhVH0mjWu3hypDrGg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SeRc4CB3;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780374147;
	b=aMQxvXOzlxVNKZ0JrzqoWL3obQpNYp57zFMVk8mgt8z6n/uEUF7Uw2pVQ/IJGkcLSXwrXy
	rjGek1gcQtbazDtKElUwAJj9vbfAUZAG8DwrNv9eIRoUYbYLsG2m+/vHaKih1rZ8pMUKlV
	rp8La62BndJpXwDjuOdSSARVHgw96fo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A14516001A;
	Tue,  2 Jun 2026 04:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285571F00893;
	Tue,  2 Jun 2026 04:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780374146;
	bh=nXGOCPORwRtBIOtgSlL5BmqNdJWalyZfji2BLv/IMKg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SeRc4CB3tfoKRBhIV6CGSKRkthW7QoclBiBsZUpKUThMOsXOQD8ty6QdCV0U8iGvs
	 qb9WbjKCfWAijL1XQoR2zdLBhNf8zE90wk4B7r+Vg1SkFv/MvZPhepzVtpqXtRVNPB
	 IjhNm2dPXy3wlmsU+kVOfZzq6mhQwdo4CryaCDdo=
Date: Mon, 1 Jun 2026 21:22:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, will@kernel.org, david@kernel.org
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
Message-Id: <20260601212225.11f277a85d5ed15083b08cc2@linux-foundation.org>
In-Reply-To: <ahACfQ6kCfONqz5h@arm.com>
References: <20260521032730.2104017-1-apopple@nvidia.com>
	<20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
	<ahACfQ6kCfONqz5h@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 46C14C0004
X-Stat-Signature: 6qgjuma1jb48oyzp4i4xn1aj1giekbrm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780374147-696574
X-HE-Meta: U2FsdGVkX1+VSUIhxF1PcxjnhMqFJwcQA5NcrGtFZL9PZtHZY04k/vr9ZiPcbM2EXpMgiqJ21lNP3FxII02EQ1Lk8eKGMV3gvYcLcHNCyKciljMiHYNx2+Hc2QgCywVTGpOpYD9mLu4aJycq1G6f4S2vMhnkMf0D4L+l7fGjGRZoCrlRmFkHQ8NHthWxbEiUT28mSGo8R8qgqZKkc0/ADJHGELISIZH9Lvo0FunzE+GrOqdwVpnw1T6+QYefbEzOI8/Vs118ZT5Mor1T65ihvNbFMuRySqwiKr80vdTpJxW2buDGzwIwMdGC2Jg3epCbyvELOEMx089F0f13+1YHkp+t67qQz23TWO4SPkhxHiYeMYaFLLvQ49gehAKlJiM61j4tWc3cPwt6/a5iQIVXdc9G8MpjtOqRwmYO8sdoVqj/gHArmHNbR1mrQt4TPmxzno/gEltsDAnKIEnmsa4f5E3lOq9971I/pYcvYafL7n46lPpYpSQO9GD8l5ol63TpzUP8agrzkMDaphnMZ5mzlMt8l3w6d1eRgJ5H2Flcsg/Aa5hvsfsMkWIM4F61ho9AQUPZLfJYcMyZ+CqcfwtdYUuonWEiKzXtf+WGnL6O8i5wUrCdNvLx0hqpusY4KEeciI/oW2Z++qmPeGpNwl56y/EZR93I03cMyjpwp+GT4Hsu2+NsJ7PXrxhjOUgy01PN56ELVGJMTjgJJ7jBT54t9Dk1jyWW/9cqJwDkomKTXmzT5j14zFCffSCvKnXFEwJLYS8ZwshcrpB7GLLgGyMjvHAM4jlyAsg1LATnnsRH/onSHTLYYW5FOAEoz65WMs1/AMAJXVtkasiwzyM4DyvYLzdLHe3sebKVrU6CNLNqW3Lwseb2kXaYb1VW6LniJOs8py8Oazsz9LkRIY2CLWVxWaVLISsz4RmkG9JJKwDandVSN5X3ocGiRGIzdF/fGEDvAz9hjq+PtaILJeAkRWr
 RcvboRvK
 EXvJkh/JzYLA1MluIa7ecAYb3KIajxOYqV34d3m4yywr3pHL+rj6sdkb/6Ora1D1pjPLNd4+4kx0GIrKb6LeMsKCU5NSVPrqWbMvSPlmvczH6a/6kN+38uEm0R4mlqitvSln4ktpNKc5gJdHvHd+Y2B/aTNRxGqAgGEfhI8pIwhWSDmwu0rRPDDYu8hqKrQLuNLFH/11P8dwc4BRPA7kE9L/JbvULAUwOLEGtC1sCpVsRX84AfdbUgPdfMa6WoDG88vdjXh9lGemVkid4Kvkqws4Rk7SkOVb9lM1XweRvAnRa3Iyiz7dT9cTAXrU+drloLeiugRSJn7ZWtoewOw9QKbPGI4Xnguwcvfa5qJGjdT3/39IwINwfyFpZOVW9Kg1ymqtECcAlzZpMnX3oPJ3hxt4PkoB4vZ9s9B/GBYOM9Zkos1Y5OvdqzjWiZTLm7VenGpanWYpXigMHAOtOyDooSIx4Cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 08:15:09 +0100 Catalin Marinas <catalin.marinas@arm.com> wrote:

> > > --- a/arch/arm64/mm/mmu.c
> > > +++ b/arch/arm64/mm/mmu.c
> > > @@ -1422,6 +1422,7 @@ static void free_hotplug_page_range(struct page *page, size_t size,
> > >  
> > >  static void free_hotplug_pgtable_page(struct page *page)
> > >  {
> > > +	pagetable_dtor(page_ptdesc(page));
> > >  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> > >  }
> > 
> > I'd of course prefer that arm maintainers handle this.  But
> > 5e8eb9aeeda3 came via myself so convention kinda-dictates that I get to
> > fix it.
> 
> That's fine but Sashiko has some points:
> 
> https://sashiko.dev/#/patchset/20260521032730.2104017-1-apopple@nvidia.com
> 
> The __remove_pgd_mapping() path is fine but we also have the
> vmemmap_free() path where the constructor was never called.
> 
> We could pass around a bool dtor argument but I wonder whether we could
> just check it's a pgtable page:
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 4c8959153ac4..9d42cbddce27 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1441,6 +1441,9 @@ static void free_hotplug_page_range(struct page *page, size_t size,
>  
>  static void free_hotplug_pgtable_page(struct page *page)
>  {
> +	if (folio_test_pgtable(page_folio(page)))
> +		pagetable_dtor(page_ptdesc(page));
> +
>  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
>  }

This patch is still floating around in mm.git awaiting some
finalization.  What to do?

From: Alistair Popple <apopple@nvidia.com>
Subject: arm64: mm: call pagetable dtor when freeing hot-removed page tables
Date: Thu, 21 May 2026 13:27:30 +1000

Since 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in
__create_pgd_mapping()") page-table allocation on ARM64 always calls
pagetable_{pte,pmd,pud,p4d}_ctor().  This sets the page_type to
PGTY_table, increments NR_PAGETABLE and possible allocates a PTL.  However
the matching pagetable_dtor() calls were never added.

With DEBUG_VM enabled on kernel versions prior to v6.17 without
2dfcd1608f3a9 ("mm/page_alloc: let page freeing clear any set page type")
this leads to the following warning when freeing these pages due to
page->page_type sharing page->_mapcount:

  BUG: Bad page state in process ... pfn:284fbb
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x284fbb
  flags: 0x17fffc000000000(node=0|zone=2|lastcpupid=0x1ffff)
  page_type: f2(table)
  page dumped because: nonzero mapcount
  Call trace:
   bad_page+0x13c/0x160
   __free_frozen_pages+0x6cc/0x860
   ___free_pages+0xf4/0x180
   free_pages+0x54/0x80
   free_hotplug_page_range.part.0+0x58/0x90
   free_empty_tables+0x438/0x500
   __remove_pgd_mapping.constprop.0+0x60/0xa8
   arch_remove_memory+0x48/0x80
   try_remove_memory+0x158/0x1d8
   offline_and_remove_memory+0x138/0x180

It can also lead to leaking the ptl allocation if ALLOC_SPLIT_PTLOCKS is
defined and incorrect NR_PAGETABLE stats.  Fix this by calling
pagetable_dtor() in free_hotplug_pgtable_page() prior to freeing the page
to undo the effects of calling pagetable_*_ctor().

Link: https://lore.kernel.org/20260521032730.2104017-1-apopple@nvidia.com
Fixes: 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in __create_pgd_mapping()")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/mm/mmu.c~arm64-mm-call-pagetable-dtor-when-freeing-hot-removed-page-tables
+++ a/arch/arm64/mm/mmu.c
@@ -1441,6 +1441,7 @@ static void free_hotplug_page_range(stru
 
 static void free_hotplug_pgtable_page(struct page *page)
 {
+	pagetable_dtor(page_ptdesc(page));
 	free_hotplug_page_range(page, PAGE_SIZE, NULL);
 }
 
_


