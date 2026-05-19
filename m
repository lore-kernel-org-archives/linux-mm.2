Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12D21CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 21:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CCF16B0005; Tue, 19 May 2026 17:52:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E8D6B0088; Tue, 19 May 2026 17:52:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293E16B008A; Tue, 19 May 2026 17:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 182916B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:52:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 798C7140B69
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:52:18 +0000 (UTC)
X-FDA: 84785518356.13.F2F07F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B03E81C0006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:52:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MsYoRyby;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779227536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hbNL8A/9L4h5m2K9/Sbmf4X0mZVOLkpQOD2l2GUfgH8=;
	b=oATf7AGNRd1Y3ArFnTSALISEU9UZrxZScwL/y0EHK7nsdXtQNR5eDgsprxsQcuRinhbkQv
	87FFA7CCgeklzOAsdrApma3wPpKcpPtRhJUOziEvHy+7N3xRw7uCtKtIMDHHhdyYlBdUlJ
	/8NH95vj+0OEAlfGVY/ap6Q4rIMlgsQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MsYoRyby;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779227536; a=rsa-sha256;
	cv=none;
	b=eNBHepJUb3R2HGHeJFzpSN1B0xMvEzKrdbu6VP2ChBPmxzLEgLoysa1mRAzGP4KR2d9ZG3
	ViyVRHd6jU/roVZqXjy9T/Ili07J9cWoHWzdEuXu0UEJ5aJ7Kd/9aiBVi9HvXxHVLJg4/O
	cmTkSK4jxvuPDfxrT2VMcugRyc009Og=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0E5A6022A;
	Tue, 19 May 2026 21:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD7E1F000E9;
	Tue, 19 May 2026 21:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779227535;
	bh=hbNL8A/9L4h5m2K9/Sbmf4X0mZVOLkpQOD2l2GUfgH8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MsYoRybynENNTCGOj5Sb8uoJZTBelACh8X0O4u0SEIFR8bp3JIv7dY6FB8uFgA6A3
	 xucxjzUu0ZeFXZyo1rMG8scATrsvJrwORBPMMZxfH5vwvSZ3uSlVEDkZmM7jf2JAC8
	 1bTSmmO76PGlxvuLXyw7BV/GcLZkdFDTWtf40E4k=
Date: Tue, 19 May 2026 14:52:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: David Carlier <devnexen@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, YueHaibing <yuehaibing@huawei.com>,
 Mina Almasry <almasrymina@google.com>, linux-mm@kvack.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: restore reservation on error in
 hugetlb_mfill_atomic_pte() resubmission path
Message-Id: <20260519145215.ef37484626f23a82fc7ef992@linux-foundation.org>
In-Reply-To: <EE9ACFDB-E601-4C1D-87D1-F5DAC2767CE2@linux.dev>
References: <20260322052120.14021-1-devnexen@gmail.com>
	<EE9ACFDB-E601-4C1D-87D1-F5DAC2767CE2@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B03E81C0006
X-Rspamd-Server: rspam06
X-Stat-Signature: mtsxg48c9npbn7y3mzksmuphzrnoydms
X-HE-Tag: 1779227536-960560
X-HE-Meta: U2FsdGVkX1/OsPLzaGpBVzFkoZewcLaG9akBUHebvGBEPfjsnbORqBkcYVuh9VvxXYCYDzoQhDJinnHNI0CXKamkUNY6aEHIVh9JVDdErb800pSF4FDPJqx/V8eXi8O9aTDKmNJuj/7R9wLdLUZgWNG4AXOYCEfjJf4zsHp0M2aWfpEZvz3sQesc+/Ec/kAIyobbBPaToX0zQDZse7XnVXNasP8XSwigTaUK6A8FNCv65DHzxSwZkD6LdR78LGKee1Bij8B5c/4vt9LwsXaqF6eiYoSb4hcRsyfL9YIrmrvj4SaIEQvmtogu2q3HEF6TFf8b9f+4tfUJbRXsnK6OPaCJlVrMrirJ455lv2iX5SamcnmdvBQzZETS4RYJDh2672UCfbgcQ3JgYGYJURNymUuX2DFUWdMRuxc058X4rMUjc44n7pq4yp6cQxv/VeK/2mdKWyZ8z/UdwuFhyNj4B4JCyktr4gklwZFEaE8j1o3geL9LbjkL8xl7mZZvs1sHq9Pf3hNU+dagugH5jcsqx9QiO9HfQHVSzOMvev0ky0YKrDz1VIdjfykxO1koe49Gn9c1waAjlHdGyS0+KP9Z1CbpVt8TLwAAMSY5llDY5FC+0ahS/M5vNG3wUeFyB3vf5owpMg3HZmOwlAlmNpUZkwaVaof2wTtbTu+vsnCQFvuTadUN8vbYthE1waRGGF/jOMKFbwv4KTju7Z/H7qh/5nOL6utifSTOADgGy3z3oMnGTi39DW6n9Kd1QMZiW4GCcfkQhocQLarPXIsZQGybeCpfHsAqo7EljD6P5nMH7/GKXVNBQZbUfcrGBono05RuAc+ZPAquebPqor3JuvmKROxyd29N7y0nA8A/4nNk1C25Wz4K7lIhLarQIe7yyjPMe0VyFOFbLeQGUUPn5fHumMdNsSIyiGF3U3ZiRDS6VAVyMZD99TAnzZ7T03C1ebb/N9X0Hl5R1gruJraqZ9e
 sGc0dF16
 z4EKnjmLRQsx4yNSLlPyqqWIFy7pJXWE7UkPi5uBqrVvpvzw9V+leKIzAtd7d0dIf5koqMpMmgBd2b7KcixNvBlG9Ufto74GXI+ymDRimd8l80HuIYwaxY3sLTXVTlsG/zU2H9S6Kg90zgA2C5HDGPs6ptA0tLhU3fI4AhLWkHqVHQ5sH8AkfDXKHiLOmyCbbBN9fgqzuFUz1DNj95NSsMhkzgSAtjsvKOUdcB02+KiW7HrOsndOajHPmoNYxSFy89afwKhUg1gb5jY02NJGNPpiNdfdWxZnl7ns2eD84EDY19O2/N0uSknaTtdSAy/otyulDF1ltQtjgytKiuaQeNxNTApGNjuG0/ziV1yruuctlJrVkt05X0jGPfcA1rrtqraMQwgggHjJ13wSekGSrqqn4dGDAfm5A6Tksficpibs0auDb/J7cp8cmHlnivHIF8Hys
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 4 Apr 2026 20:59:11 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> 
> 
> > On Mar 22, 2026, at 13:21, David Carlier <devnexen@gmail.com> wrote:
> > 
> > When the resubmission path in hugetlb_mfill_atomic_pte() allocates a new
> > hugetlb folio via alloc_hugetlb_folio(), a VMA reservation is consumed. If
> > copy_user_large_folio() subsequently fails, folio_put() restores the global
> > hugetlb pool count through free_huge_folio(), but the per-VMA reservation
> > map entry is left in an inconsistent state.
> > 
> > Add the missing restore_reserve_on_error() call before folio_put(), matching
> > the first-attempt error path which already handles this correctly.
> > 
> > Fixes: 8cc5fcbb5be8 ("mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY")
> 
> Hi David,
> 
> Thanks for this fix. The patch looks good to me and clearly solves the
> reservation leak in the resubmission path of hugetlb_mfill_atomic_pte().
> 
> However, I'm a bit curious about the Fixes tag. While commit 8cc5fcbb5be8
> did introduce this code structure and the retry path, it seems the bug
> wasn't actually introduced there. At that time, copy_huge_page() returned
> void, so the failure path simply did not exist.
> 
> Instead, looking at the git history, the failure branch `if (ret)` was
> added later by commit 1cb9dc4b475c ("mm: hwpoison: support recovery from
> HugePage copy-on-write faults"). It modified copy_user_large_folio() to
> return an int and introduced error handling paths that unfortunately
> missed restoring the reservations. Should the Fixes tag perhaps point to
> 1cb9dc4b475c instead?
> 
> Furthermore, if commit 1cb9dc4b475c is indeed the root cause, I noticed
> it also introduced similar error handling paths in other places. For
> example, in copy_hugetlb_page_range():
> 
>         ret = copy_user_large_folio(new_folio, pte_folio, addr, dst_vma);
>         folio_put(pte_folio);
>         if (ret) {
>                 folio_put(new_folio);
>                 break;
>         }
> 
> Here, new_folio was allocated with alloc_hugetlb_folio(), which consumes
> reservations. But if the copy fails, new_folio is freed via folio_put()
> without calling restore_reserve_on_error() first.
> 
> Does this imply we might have similar reservation leaks in other error
> paths touched by 1cb9dc4b475c? I'd love to hear your thoughts on this.

It's been a while.  Can people please refocus on this?

David, your patch had cc:stable but I'm not seeing a description of the
userspace-visible effects of the bug.  Can you please describe?


From: David Carlier <devnexen@gmail.com>
Subject: mm/hugetlb: restore reservation on error in hugetlb_mfill_atomic_pte() resubmission path
Date: Sun, 22 Mar 2026 05:21:20 +0000

When the resubmission path in hugetlb_mfill_atomic_pte() allocates a new
hugetlb folio via alloc_hugetlb_folio(), a VMA reservation is consumed. 
If copy_user_large_folio() subsequently fails, folio_put() restores the
global hugetlb pool count through free_huge_folio(), but the per-VMA
reservation map entry is left in an inconsistent state.

Add the missing restore_reserve_on_error() call before folio_put(),
matching the first-attempt error path which already handles this
correctly.

Link: https://lore.kernel.org/20260322052120.14021-1-devnexen@gmail.com
Fixes: 8cc5fcbb5be8 ("mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY")
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: yuehaibing <yuehaibing@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path
+++ a/mm/hugetlb.c
@@ -6290,6 +6290,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
+			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
 			folio_put(folio);
 			goto out;
 		}
_


