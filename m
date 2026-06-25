Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD07CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 13:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BD456B0088; Thu, 25 Jun 2026 09:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F7F6B008A; Thu, 25 Jun 2026 09:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685746B0092; Thu, 25 Jun 2026 09:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 439736B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:45:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C14E5140129
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:45:35 +0000 (UTC)
X-FDA: 84918557430.23.A68C729
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 392E3140013
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:45:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KGnA5QDG;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782395134;
	b=YCl9vPh257Zcx/yAyV6onkvVqLKLr0RCv6+HjR3lEvJkH5sRW3bblb1vs4NjrUxhi5Utfu
	7EjLABeyp+ZsYDnYYaS0Y4J+9s/TwZm0Dh+FBQMED4vmAqh2jGUXxKnTCb4nmIPqfcnoGU
	Y3jDLH3CgtGQ26LE0XUzPc2zAHgtP5k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782395134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQgm/0xUjnC2uKkCTFkFQ7HDUhhiNYBzn6GFhSGt9ZI=;
	b=yJs1igODMIGxQ1QOyXu83sZXZXa4OHWRZTEedbTHqyV9ZIJj1/Ehh1CDN6/EjD770QYDv5
	0BKdt9UjAQUyM3/i5qOsVZInOPFO+j9FeTS6MxvAEV6P5aab7r17NVatOc8l1BhtS+emKM
	eeamyLUbN3AOsnI4rTPI/BREwKs0yPM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KGnA5QDG;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF48A600AE;
	Thu, 25 Jun 2026 13:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA26B1F000E9;
	Thu, 25 Jun 2026 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782395133;
	bh=MQgm/0xUjnC2uKkCTFkFQ7HDUhhiNYBzn6GFhSGt9ZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KGnA5QDGaoY8BJI8guQ+6hdBNoRkYIFOa/L7h/05sUKpKoU34O8rde5GdjZFCUkmS
	 9E4SrxlHnWdbSaKU5ucf+b68LhbnMoGzDpvRju52YFKXh27oMdjhXyIiAwTipo1GU4
	 HgiZeHTSkVZUIdPbtXPnonok2QjuIvs/lXsZnyRuHkVke2hdzV3waEUNXFRaR0A6iu
	 ToZk5v29H6YT2bQzECzX4SDgRGe2TJYBeZKugFfCYKg7hQZsB0zSD5DJ0/XCGPoc4H
	 IfQvxFcMsVBQ+LglB0e4vr5CFYO1D6eqAwdZXXN3QEPTpHXgKlHW2uqzxZa4QwVefN
	 mTcnp64eDawYg==
Date: Thu, 25 Jun 2026 14:45:25 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	willy@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	lance.yang@linux.dev
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
Message-ID: <aj0vjdBN-oNMI2yI@lucifer>
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624082359.2869-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 392E3140013
X-Stat-Signature: z6f689stiq6aee4om64r5zd1oks9h7r7
X-HE-Tag: 1782395134-590142
X-HE-Meta: U2FsdGVkX18BRXBGc8D3TbQTPJjEwLbBTZjyqF2Mxoe/djbcCJrThEf+T6GEBoHaPJYG/HuFHuQixBVgSUe+sQydtA1qkL5HIPpFIfRDfVfAWMPrKomnAghB9q9iC4noYfLNPhTEKzA1ue5P7AXWScGaPCPjLvYtT/Brkr5QEBePTzKHiDIifEZEDGdpioKKJyepXs4QAeSsKfAkN++EfBuLtTkHF0+5itgqX8DRDQaHw3QBdJD4BUOD8DabysPAXMCbLL/GgCwxxhv8WG/+IkqWThpjgo3oPicTAcVCO9LDWgctxsCGKJFdBbcxgGQD1qNL7BPbJbCm+kmnxpeXTtisL2UNAxYkTluPoUbfOATHllVkCpJPH+qjx2+qGxzMg4LttNI26bSxFogrHFAJwLmsCQd4isy8rzs2Co66F8ELmAdkny9hCvxovysyv+vzz7Prp21+VV5NrTuSAxLiiYKiNjvy+2EZDO+P1guNxN/opaAY1Gyz08YtCPatC3+BAOQGHJ+TJATU4iamdPXyhoEywc1uZuMeXbPPuGno/WozJ8nzaKV8lmgQXU2j2Mo34O6r0FNCu/Pgaz1PXj9SS/z4vL7D6YhMURnI8YkM5Ba9QqqvuLFopjpRVVWni1/xP/BFl75JNM8MwYeVIL5Z36TDOT7BSo6eH9isFf6E9lUIhDUt7lTWvL3moWk4+9F/EZ6m9vFwvevdJpC+hkaTwmRCL9IZX+Xm/BIRgcHhb7cwuBi3YuJoflQbcyDAQ1r9p+iz7SQYqFC9cyEjLt19lVe9tefReloSghIV1eNfQ0mCnbaOd3yJ6+S7fIwUSWQjPOUwJZizrvyLLjOGhCSUUrOFX7uSw5polnI/jXwSkuAd/7X1raRKtp0GzXRwpH044dlH2xvxk8s7lx8n89NRCheV3gzfIKqnw066eyG94E9gVInXuXQjERWKkV1cugEb9pyu3yQapUBEO8CPafL
 8Vc7Z0E9
 +DI6Fi770wC7Qdu6ib2GWgEqF3Wzd4687GeDMdN5afhqVDN7CE0+w+DaUEe/+qtsQ3LQpvm4oQlNE6YfPO4suSV2UqYbAnfZy1t9Fjk/0px42b6MOCLeVAmJs8B5oA2Vxk+90DbC9T0DEDtUJfs8Bvft4EalK5Twchhftwlubo0q7YFKYkA+389Dw1eF5LZ16NUKCIlZhC16JrBUJp0dbyyvyDiwDHdkYNB4ZerqDneV7DQ0Iid+YJyf/pThUT0RRueCYE908iPfOIdlOXABjmJVwqzvSJf9FgxgWMZr4DkwaHmTu15E0PT24N6TyS4IqZp0Z5zV4nZxTa1ODHN7DDnQ2tvqk8VnTaZDq5XQrXV7emrKa/1FbvVR+vnQo21CD+KRthCA+2iGJDBYX7AfV0pu4kOh1wFIy2l07GBwX7A7xc+EDuBjlz2LOGrnrIxLdYPdWH43s2CkFIzcfaeWv/5r4fOAgny+By6VF/4sFXpjMNlrCVx7ln0Cqn7crP3Tao6hV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 08:23:59AM +0000, Wei Yang wrote:
> The kernel test robot reported a build failure on the parisc architecture
> when expanding HPAGE_PMD_NR in check_pmd().

Let me first say that I absolutely hate that we continue to support museum
piece architectures to the point that we have to make changes in core code
to accommodate them.

It's not unreasonable to ask retro people to either use older kernels or
make a downstream fork.

People having to think about this upstream is so incredibly silly. As if we
don't have enough work already...

Anyway, with that said...

>
>    mm/page_vma_mapped.c:142:13: note: in expansion of macro 'HPAGE_PMD_NR'
>      if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
>                 ^~~~~~~~~~~~
>
> The config [1] in report link shows neither TRANSPARENT_HUGEPAGE nor
> HUGETLB_PAGE is defined. Then trigger the BUILD_BUG.
>
> Fix it by define check_pmd() under CONFIG_TRANSPARENT_HUGEPAGE.
>
> [1]: https://download.01.org/0day-ci/archive/20260624/202606240042.ffPsEXVc-lkp@intel.com/config

I think the fact this wasn't detected for 4 odd years goes to show how well
tested stuff on this arch is... (unless this is a very unusual
configuration at least).

>
> Fixes: 2aff7a4755be ("mm: Convert page_vma_mapped_walk to work on PFNs")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/
> ---
>  mm/page_vma_mapped.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index 17dff8aab9f9..4aac94d9e8a9 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -136,6 +136,7 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>  	return true;
>  }
>
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE

As per Andrew, this should be CONFIG_PGTABLE_HAS_HUGE_LEAVES I think.

I don't like that CONFIG_T..HP is taken to mean 'anything to do with leaf
page tables'. That's a mess and one we should unwind.

So don't make it worse, use CONFIG_PGTABLE_HAS_HUGE_LEAVES.

>  /* Returns true if the two ranges overlap.  Careful to not overflow. */
>  static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>  {
> @@ -145,6 +146,12 @@ static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>  		return false;
>  	return true;
>  }
> +#else
> +static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
> +{
> +	return false;

Should have a WARN_ON_ONCE("bug in stupid arch") or similar here ;)

> +}
> +#endif
>
>  static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
>  {
> --
> 2.34.1
>

Thanks, Lorenzo

