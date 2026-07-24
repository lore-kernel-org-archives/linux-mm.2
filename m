Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 830D3C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 07:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4DC6B0092; Fri, 24 Jul 2026 03:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385E26B0095; Fri, 24 Jul 2026 03:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278046B0096; Fri, 24 Jul 2026 03:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEB856B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:48:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3F31C02DB
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:48:25 +0000 (UTC)
X-FDA: 85022892570.02.807CF8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E45280003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:48:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SOaXFBuR;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784879304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bO3E9Wlp8V9BbDWot4WwlaXnfOfYvMBhEhsCHrbT5DU=;
	b=ETS817c5jIUtHeRdfMnOZz69HPf+PCR2fzeGUI1179MhJaNgUfrkB6SyPdU+PHhaRrOcKJ
	QbwBYUaXgN7swFTO4UmYxBsDHi55Dtn7MqIO13FDQqqPsQ7GUcj6WVGbnrMsK66QB3TOT2
	+551XlUaiSOk8fl3IkOEiAyaSYk7PxE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784879304;
	b=Erg0ZkUJvh/+Orw8v0VtCO1ltybo2aJiHNvYnJ/kxtMIZRrLFIuyg1V7y0g6nwtebAZEfU
	cxi1nY2oLhrO0RW7xiuP9lwu3H8sZiPRMn9VJRx6x1oMhveNNUP0X57cEyt9Qnymf8kVFh
	JlBuNAcGjGDxRGtNIe4bCM1q8UvC0hA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SOaXFBuR;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A91940B29;
	Fri, 24 Jul 2026 07:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B6D1F000E9;
	Fri, 24 Jul 2026 07:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784879303;
	bh=bO3E9Wlp8V9BbDWot4WwlaXnfOfYvMBhEhsCHrbT5DU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SOaXFBuRKELMe8KH64C7KST7n8Oh9frVdPW5uggd8hhm9ZcUMhgc0VxjKYDYyntAR
	 RgpRZm8msALLb35JkjbKvh6OQDWgDrgi9rVCTyy0dbFRLVWdQeKE5GnI6YwpUWYXFH
	 2vcSCKYQdqbw/yISMhIszPpPx0PxpULTXPc683yh3hwXurIMEyStUlCTTPN0/HZZxk
	 YiyxMeve7rv8BqbMoY6PxtQEG7rHICXKlA6gsJDDsxjr2kITVLSJBwk5ZeHJHvKEiu
	 tIjnOeCN/B31GCf0HayMEfBAXgVhiKspcV0CXc3TGSKzS4J8u4Ju5+oeYp/7wQbxnk
	 14DFgIcMW8FLA==
Date: Fri, 24 Jul 2026 08:48:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev, 
	osalvador@suse.de, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v2 1/5] mm/rmap: convert page -> folio for hwpoison checks
Message-ID: <amMYSap75IRc--tz@lucifer>
References: <20260710055915.638659-1-dev.jain@arm.com>
 <20260710055915.638659-2-dev.jain@arm.com>
 <amIzQmZ3eeYiVXo4@lucifer>
 <cdd37c17-b2c2-4dc0-8f1c-7f4cbd2fefdc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdd37c17-b2c2-4dc0-8f1c-7f4cbd2fefdc@arm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4E45280003
X-Stat-Signature: 8z467e4iydmtct1jfgit3ndz4gr4qhsi
X-Rspam-User: 
X-HE-Tag: 1784879304-793519
X-HE-Meta: U2FsdGVkX1//MSM3DoZgCv6LWBfBJgQrBdSLrQvRUeOmTNxGcx1DvoR5VZ747dem6Eqaph0SJtH840VYjIU/R/9pkTyNL7aiEXJs7mdG2mXCNjMGjj//iDnm8isV8LbHKZBZJVhKO4OvTo3VbdZyw6BPo200Fy94NMIn+b+Hgbl36LUSrD0LpURhr+fe0rHotUBf66QSB7I2brm4Rj1hb0DAEpuJKCxpx95lRax4giCPZILkAEj+ioyi/sZdNN28TdskY6blM3kmZY7/tseNWXbphsV2CwIJoq2w6VmPckVQf3N59P9mENEl3Zr3TN2eWObSUQR51veDu4Ko9IWJaRH5l5G+GEqq/V8oyrzkbhA2VtEqr362EQg9Ej/R6zkk4VuLUaVOla4mYB8L1ky5YpWaXXEvLYwpsDZE2mUAsEbzZbUb9FxD97wPl6QfNTdNqWC/FP25C0xHwr/4EmSXbGK9SPaaL3pHxJRFG5DTsi2IEOJUGdWqv7UcgUvQCZHH9LbRNEs1fUQcwzc/CcxJNvv8pI4SwdqkAivenqhLxuhtlNjaS7OYXNVS77ffWgyfTO+JHeYBm5guuhIQ+V+OSACUKVq3NDFpyEpAnqU/7JFJRDbk2THFBMumKWOEKKY4DHAbV+cMnz38VeqQJorxtsS0nXoF7PuuJkoMCN7tl9Jz1zA1Q6wNzvFQgRlueVzzFXNbioGPqMVgWiPS5TNikSGntq/mnJsfUmtrHdCE8+pk2iZBGRModYwqNG8+1EkZUHZny6rnCYu6Nx164Tv4ESUzt8ZrljquluQIzAbyCptiB16fk0XoKt5szF/u2g2JST/gPbEmFlpgMrqAHi6RtWJKSaol4gA+KG9J0VEr2c23aec8dUuPPsvW3j+6llXwQ5TigXLB/x7u1Zs+ZFFmFLl53UYpAxyNrPdqPxeYAp7J+xTaVp+OwUHXxYGyME530OVLYWu821uaItEJY2F
 Wc9eTg2k
 XzcKxrXqtpuaRfAl3J54rg4zJgkAWZGXUZBfNpRL4rOUyUyRswENF+Mye+e7naINBksyZwtk+XdNniAlU6QPCMpqMCNKiHgH7C4ttk24K6BoJrobXD489HPKkbtl9yQTAP3Sq1FApI8QalyE+0WQvk3CsfOPWPrtdhki4rRFA7S69RdhKnNj5AG+PYVtCkavo/IYmuFkdPPkmqM74Q6mSNbTdqTSe6lxpySMmeEMjOYDcvV4uhBhVTkgVdgTrWJ3LnYV49S1QygpSfr7GyUU0Wbo7dC6PMY0Sut/VSBp4pD7MFQrXkncHHwNHHO1DJyKGoFHa69zzzdQZSg+11fHRDWLWOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 10:35:34AM +0530, Dev Jain wrote:
>
>
> On 23/07/26 10:45 pm, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Jul 10, 2026 at 05:59:10AM +0000, Dev Jain wrote:
> >> try_to_unmap() receives hugetlb folios only from the hwpoison path.
> >
> > Horrifying :)
> >
> >> hugetlb_update_hwpoison() sets the hugetlb folio's head-page
> >> hwpoison bit, and page_vma_mapped_walk() reports the hugetlb mapping at
> >> the head PFN, so the previous PageHWPoison(subpage) check happened to
> >> work for hugetlb.
> >>
> >> For non-hugetlb folios, unmap_poisoned_folio() currently rejects large
> >> folios before calling try_to_unmap(). Hence it is always the case that
> >> if try_to_unmap_one() handles an hwpoisoned folio, then the head page is
> >> marked with the poison bit.
> >>
> >> Therefore, convert the poisoned subpage checks to folio_test_hwpoison().
> >>
> >> No functional change intended, except that, while at it,
> >> convert VM_BUG_* to VM_WARN_*.
> >>
> >> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >> Signed-off-by: Dev Jain <dev.jain@arm.com>
> >
> > Small nit below but generally LGTM so:
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> >> ---
> >>  mm/rmap.c | 13 +++++++++----
> >>  1 file changed, 9 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/mm/rmap.c b/mm/rmap.c
> >> index 9939400e77c79..dbb077f8443e3 100644
> >> --- a/mm/rmap.c
> >> +++ b/mm/rmap.c
> >> @@ -2122,10 +2122,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >>  			bool anon = folio_test_anon(folio);
> >>
> >>  			/*
> >> -			 * The try_to_unmap() is only passed a hugetlb page
> >> -			 * in the case where the hugetlb page is poisoned.
> >> +			 * The try_to_unmap() is only passed a hugetlb folio
> >> +			 * in the case where the hugetlb folio contains a
> >> +			 * poisoned page.
> >>  			 */
> >> -			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
> >> +			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
> >>  			/*
> >>  			 * huge_pmd_unshare may unmap an entire PMD page.
> >>  			 * There is no way of knowing exactly which PMDs may
> >> @@ -2204,7 +2205,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >>  		/* Update high watermark before we lower rss */
> >>  		update_hiwater_rss(mm);
> >>
> >> -		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
> >> +		/*
> >> +		 * With TTU_HWPOISON, we only expect small folios or hugetlb
> >> +		 * folios here for now.
> >> +		 */
> >
> > I think probably we can drop this? It seems implied by the code (David comment
> > similarly I think? :)
>
> I had posted a v3 here:
> https://lore.kernel.org/all/20260713050050.1017741-1-dev.jain@arm.com/

Oh sorry, missed that one! Will take a look.

>
> In that I had fixed this comment to drop "or hugetlb folios ..." . But I would
> still like to retain the "only expect small folios" comment, it adds cognitive
> load when I am reading try_to_unmap_one and then have to go read hwpoison code
> to figure that large folios would be split before coming here.

Yeah fair point. I wonder if we could rephrase it a bit, 'small folios' feels a
bit ambigious. But I'll look at v3 and comment there!

>
>
> >
> >> +		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
> >>  			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
> >>  			if (folio_test_hugetlb(folio)) {
> >>  				hugetlb_count_sub(folio_nr_pages(folio), mm);
> >> --
> >> 2.43.0
> >>
> >
> > Cheers, Lorenzo
>

Cheers, Lorenzo

