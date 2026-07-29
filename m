Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01B68C54F52
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 01:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47696B008C; Tue, 28 Jul 2026 21:36:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8A56B0092; Tue, 28 Jul 2026 21:36:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90F956B0093; Tue, 28 Jul 2026 21:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA9E6B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:36:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 927D1A19B1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:36:43 +0000 (UTC)
X-FDA: 85040099886.13.F73D673
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id B6713C0002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:36:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Z6Ay37eU;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785289001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SB586ydHGWZbCwKFeIZOob7iAlVPrWpwQZgvCFX8MT8=;
	b=dtjoBMea74imQs9rvlrxI15b1oKGK7MRyk39pO16MiyNr9r7vjavMmxWoujLw0zi8C7wN9
	if/qCCtkwbu75nRNWT/3fyEYsuSbaQ7QaHt50BrPaeTAy+mt6hmYYNq8rOrJndHNvuvTQV
	i3PtSX2ZBzXo7mAQIRV+u1SN4RJDky0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Z6Ay37eU;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785289001;
	b=bDZqJAHhRTxrP+p02/ZlbYqL3DKCsUVd6Z8Tex3AOff4YscyagnQ0wLAT0/PS+L8A5ggDo
	7z5lBwCLKLUdcmhjzFnZGIyzTnTELaJiwtXKDanYHg30Lu0Tg8SdPSh7JmFiNOOP31hOXN
	cK4sTCWXG/0NGmM0vAKiFhxzDyMYDl0=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c0a81d286so10000741cf.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785289001; x=1785893801; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SB586ydHGWZbCwKFeIZOob7iAlVPrWpwQZgvCFX8MT8=;
        b=Z6Ay37eUrv/i/eNNx6Nabtowu3S4UnRfGgfbgYUI4KWcj9hl6xX++I3jP46YNtGXKP
         6PDMv27iAbndrfnB+Kk+5Nq0Q19Zci0t10YaKsBE416twRT9R26knGH9mI9TDaEKnoY5
         1nxcRzrzMjl2KIIAG7h8Iyg/oyqWAzW0BkkI8AokJ0lgj1lqsYJ32CbIMo/Ci8AtpSFe
         Rjr0teEzx/yoaivRxl329vqpUOnOo/SE16jcUNaAQoURC2KUdr8kZKkA1UdN9G0d36Yp
         CPRW6wUK6Ok55Nr+o2UWeT0kgyEve0ML4VoHTInjjTCkjxiFQmlqjAmKRkX0MEK/6ihN
         88zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785289001; x=1785893801;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SB586ydHGWZbCwKFeIZOob7iAlVPrWpwQZgvCFX8MT8=;
        b=rIdtRrKaBHzB6Ceg3M5QeCJStsGwEnVv2gvr7pb3WuwzQhDoA8wBFLsYWgMVDwhXlR
         EtvfZLj1PyZqooNapVJrNNY8mUOZwZEcgFT+Z/vEkT3LccrEuKWnKsDIRb64Ln3xDZ2B
         P/bUgP2kN0w7+p4unOHYv2OfIAuq2CpbocZajSqwfrRQArWF80KhSHRtQBy2cg34oKLR
         Ny15Mi4tMJdxdCVmso+xquRiGAKLLLwXgt72iDWszcDYtZnM1pYdBtOnhFwluIsz8bIi
         2JDVc8vTLSsJzgtH0QZj/l0suh1xy9UL2WHjRCf/Rt69Vj3OyM9+cARTEqTsX4el4UXF
         UHXA==
X-Forwarded-Encrypted: i=1; AHgh+RqUL+qBW7tj/B/E5JC1GINYRThlcLVKb6hks85SpTFWUQJBPYH2nAuTe8X9TF5Uf1izip+NKICoew==@kvack.org
X-Gm-Message-State: AOJu0YzVYs5fcTTZnPjpt5zuDQQrCzwAVLhPTOo0cqoPWn4nT5o+AaUH
	ZcYtJrfW8ZZQ8BAKuDBB8wXz9yZW9mkfWmD4AvL0OMAE1IdhXyXVhqKVpIp+V/UhauY=
X-Gm-Gg: AR+sD11XMF58+28dG/DRr2FchbHE7De4ZNViS8h/uRKjwSI0RbXFVl5imlIMQXlBC/U
	ifn2uzHuqryED8oUuFJc2pD6YNbNEnFVFDHl9X1koxYnwSAG6SzCXdYtQbdTElXS68Z5WJSXQfQ
	ItEVEnTWKY8mZSLE7Oa+ESMqcTMfvz6IOLW9QwjvvInnhf/YW6D9gCT0IiL6nAldRJ1Pvm/JUZ2
	gbbGx7OvYbRtwnb/1+U51qPvLiRqLQnvqTXWk8X4+XsV1RsKTf/V+s5xcAZs2TpVQsN6FUw4dOf
	rfr938KUEgNr0NiCOzot4GE5qaZl7fSKI+NT1+C6kjJVs8NrjZ36fxAjArrrvQFQXIob1EJEHVa
	DevQzNSXmOqi/1uRDDDzbGzKN1gq3pSdGFfV8PRXXRN+PC1iWynsSIC7Xl0Zn1aqfoCjfNyJuFI
	U8WcSEvbf9LqZsM9DAJHRD3oZoBVEoerN0dXoKzrqy+HKcqSj0YDiGl5LXzUD5uKZra+69Iyw5m
	LilF+c9hahBOGjcb1SBidMwZia+5cAxkjQGpxWLjAgL
X-Received: by 2002:ac8:7f42:0:b0:51c:b91a:33f9 with SMTP id d75a77b69052e-52b2ad31474mr2986601cf.13.1785289000917;
        Tue, 28 Jul 2026 18:36:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dc496f7sm12776896d6.3.2026.07.28.18.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 18:36:40 -0700 (PDT)
Date: Tue, 28 Jul 2026 21:36:37 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v7 06/13] hugetlb: Use the has_hwpoisoned flag
Message-ID: <amlQYkGgLmxmwX9_@gourry-fedora-PF4VCD3F>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728204409.3396238-7-willy@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B6713C0002
X-Rspam-User: 
X-Stat-Signature: fcn63wz9oqbu7xsntwrws6g9o6j94fmg
X-HE-Tag: 1785289001-724322
X-HE-Meta: U2FsdGVkX186bHwLIy5iXbpOPJ2y68JnRGEotTWNYM+JVcl+6PCnkIw/MOlMpTOqmRT6iNZoT1pGDCe6AazbK1MeumU8REi1p1YTIMLImExdiB8rsYGt7WhrTTOnKGRnyQ05d1rVziLfLJO0UBHJFbpAusQrWCXMmsOEWudC+qpeX1/ODAC8P93CMn/qPdWeNrChPv7i16iLx9KpJ3Fdrwjux/zWU2g/lXgHr/56VhR6HT531H7fwQYZePl+BeEzMvzbxGkzxnC/p88nPQTCrmlZZLOVWFCjnzqExI9ZM3q3LIuxe+l+MZdsA1voTpIxNqTFbls76n4wPCBgvgq0JciBow5B3Zo+vobNWQDa9WtR4BaSdYzgro4Fe3odf16/OT92/QNtDF7m0u74CwUDo4XePJ0pK4YoBxUkTrvrU5ATrjx3zZSQ8qHGZxHA+VwCeTOQQXN3c8CrzhBc0kYmJVQ5syyXi4anSqqgl2gIQqEx6lqlpwwnWJqGdq0nmyvuBuUvt28mSfZaALMioTINRRmuIDbvlo+IjGEDsZX+BXZ0j1o4SiMxXOYXS5yoJINCv9yuXWLSXQmbrtzwyxMK2LQZ26xBFLvJqBcMCrBvOCwEeAc4SWu6iRyMjDpl9AwPcCOpZA4jGbmHACgYVxT5tiq4kkkHVQ16Zx8NK4Kl8xi9viG4eAwr+H9mPf5eQ3kylh/WIbvzDOdoD9kdF6lunvjPou8QN1AXih3QHkXmQRgDdvGzLs0QzR02jKtJJX/KWm2tvHqAq1YARWaiC1AmWGIyvc+VRPHwWsELLFgGM5UanYTWNC7cjFe1x9pXfEogjc7kiVqbsWf6fRFhJQpCG2fNiL9Uh7ls/lEMP5iT105l9lu+yIZ3uWV4nF3r3QC8Y5MIQsMIhJHOVSocZmopmba9589d9yqRvPeS4v87GdKVqpbpHNd0+Do9z3Uzgy7II/DfVlv/Tqvt0QPF6Vi
 E3q7hJT4
 FfEFL9+Cf3neK+fQNpsGr03N9zflILnZg04qZB7+jM5nC8iXkO88qrmIeE0L+4HXEeEL7ZzEgo9vy4bQ0kJDsy/JFsRu/L0hgTPYB0+2AXdkABk/wNlnk1faGhTfZsn5Kfu9mB0+PvMdMqt00ACRqckBm2xhYVwJ+P8tD3pzZjswvqDf1OOWTYqG9tDWhSOLSWvTyv4ukRMTOzm/pYyJ1pGsj64Ic4pw+ZtAFYkibV2IQQHlMmTmbY+IM0QGar9GuHlgwjxG/8utzjKfRQWpI+1sT1K/5St6aKlLqv80tg5VOT+g2LPWr1U+g/9P706EhuwOsS+zUjcDcng0tfj5PsT6jO9owK2NJtsXQz2gpJoQba0L5S93jQCw8X4h0Y1z/Kuq8fza3ft+5SmrKgpgW40kdYXwFdyzTPmEOwreJZ2gZ34f9iCIVbia8l/yP3g935aEnwMOOAoCMgT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 09:43:58PM +0100, Matthew Wilcox (Oracle) wrote:
> +
> +#ifdef CONFIG_MEMORY_FAILURE
> +static inline bool folio_test_huge_poison(const struct folio *folio)
> +{
> +	return (READ_ONCE(folio->page.page_type) >> 23) ==
> +		((PGTY_hugetlb << 1) | 1);
> +}
> +
> +static inline void folio_set_huge_poison(struct folio *folio)
> +{
> +	folio->page.page_type |= (1 << 23);
> +}
> +
> +static inline void folio_clear_huge_poison(struct folio *folio)
> +{
> +	folio->page.page_type &= ~(1 << 23);
> +}
> +#else

Took me a second to realize why this was open-coded instead of using
the generator macros.  The reasoning is buried in this comment:

/*
 * Check if a page is currently marked HWPoisoned.  This check is best
 * effort only and inherently racy: there is no way to synchronize with
 * failing hardware.  The caller may not have a refcount on the folio
 * containing the page, so we must be careful to not trip any assertions.
 */
 static inline bool is_page_hwpoison(const struct page *page)
 ...

which i presume is referring to VM_BUG_ON_FOLIO() in the set/clear in
the macros.  Might be worth just note here if only so no one comes along
and "fixes" this or writes more of these without the same reasoning.

> @@ -2725,13 +2748,19 @@ int unpoison_memory(unsigned long pfn)
>  
>  	ghp = get_hwpoison_page(p, MF_UNPOISON);
>  	if (!ghp) {
> +		spin_lock_irq(&hugetlb_lock);
>  		if (folio_test_hugetlb(folio)) {
>  			huge = true;
>  			count = folio_free_raw_hwp(folio, false);
> -			if (count == 0)
> +			if (count == 0) {
> +				spin_unlock_irq(&hugetlb_lock);
>  				goto unlock_mutex;
> +			}
> +			ret = hugetlb_clear_poison(folio);
> +		} else {
> +			ret = TestClearPageHWPoison(p) ? 0 : -EBUSY;
>  		}
> -		ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
> +		spin_unlock_irq(&hugetlb_lock);

Adding new synchronization here without noting why - it's not
immediately clear what this synchronizes.

Is this just fixing an unrelated bug / should it be a separate patch?

~Gregory

