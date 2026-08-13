Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7CAC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2AA6B020A; Thu, 13 Aug 2026 04:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7846F6B020B; Thu, 13 Aug 2026 04:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 672816B020D; Thu, 13 Aug 2026 04:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 485346B020A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:29:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3F241C1581
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:29:27 +0000 (UTC)
X-FDA: 85095571974.09.2D02EEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 15D1A1C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:29:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iPH7IB6r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786609766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0j2EWmhCM0P00w1S22i5WnZMePeZSUmS6q+/vdBi8s=;
	b=e7wgor/Rog00JjqjtrV71/JiwYbCUKytbulxfCJ5gGrcsQxKoxqZNv+8GAn/7BauBmcIEM
	q9P8BzEqUdiFjs5N5QvgBrKSFhXkvOUX/DOMfeW+pSEPyhmjLVw5/O6iW7TFIPtodZOJ1e
	LrMU6w17NhxUqb4fXk+KHc/f3iX3guo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iPH7IB6r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786609766;
	b=kAQXMsIclyosxYdmBIY+0E2MkiKOHgbigZN9dsbtXBNhAZWUYxkmIdwKcq6dlmB5awrBOx
	JCtBgTLMx5NbSi3Vhowz7v5tAZbmKec8hGMe6o9gCmIXTM0mS9R618KFRHs5E8zdHww9v2
	WKOpv7rgPcXjyAYcxs19eDfIiPfnKmE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62D68410AF;
	Thu, 13 Aug 2026 08:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC001F000E9;
	Thu, 13 Aug 2026 08:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786609765;
	bh=D0j2EWmhCM0P00w1S22i5WnZMePeZSUmS6q+/vdBi8s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iPH7IB6rdaiorylVVpDDyRgdfQPy21XCoWB5/8jOtXHcfDCl5FdyYnftVKD/W10tM
	 +uQfpx7HGEYF2Gx6BeedfWKky+JEoz9IgDddbJlxzjK9LBNafJ03II47qRkCx4JaOF
	 e3m6GRuws8olyQRzpShxe4vcMgLp/VhKGXsEwBISDuN3xBbh+81gtiROQBtZJYMAW8
	 JL9u1tcXlJ8WbOXYa6X9BLdCTPHEtFprD767Ya+gtX/ZYjuQpGQLwMry5ap5LzcvMz
	 +3fWJkL2a41X1jElyeh5MrcYA2DdUy7opm0Q8adu66j/NPRYhzvyiino1p/mJprTab
	 wqi2Bz8vljeqw==
Message-ID: <a51a6236-8881-4479-8f04-39676e0e1f14@kernel.org>
Date: Thu, 13 Aug 2026 10:29:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 08/15] hugetlb: Use the has_hwpoisoned flag
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
 linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>, "Gregory Price (Meta)" <gourry@gourry.net>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-9-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805210557.1118966-9-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 15D1A1C0002
X-Stat-Signature: rzo9m8rz9xyi177watk5dqws9hdsu1jn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786609765-623485
X-HE-Meta: U2FsdGVkX1+bGuy4kKRlhgRD1V3fJexW1q/r9LH/C3w68JACaSORjJS1Zy4UTvShlKQIx55QQAHOHbQhkjMAe7FvE5HgI62kCl4DlVvE9ag4cTu6X+xbjz+3Xiv9wKkhI1wCPOisnbjOZBX/1t6cPIW4ANMIMaXPli9EGp5olr1s86ZIIVdulvLdllSaMZipGfRhZIpSAvbR/Dw2IDZMlKfZWYwr7CscZOP8p343rrGJe1uOzew3pPq6reGrAPMIPGaFCEC6RyzoQvy/a7Mcwnvo/pK5DRTfqxxc8Uo4ulUCkYXT/lGltCTBHD+5Q8a7WX7uoMhWvs9eibKmoidgzFGZYKlLcpY1R+3Vi0XyW7+xrUeJCcc4tnuQHbN7lapY4SnMMHLa3jeDbzQw+WSY1kHPvtaPyQO/+gFatVyvJ9nH2B9fdp8i6WrPnGDcPHj+96m0sJCM4uuk7kr0w+9X0MLpO8h/7a0GL0p8CsapEZqo7Wd+X6NgIbjf9Qzdpe5g4WTivrDVAMUI4T0ZftkNVkBd6w2fIW/Lb1LO2+mReERSuFWgRJK5GONMvXoXcDwfdO+xQwf/xIHzx/27i1YvaohzZUJJRfoGZORO8PP1tm6YGxmbuVZZKU2n0yIrWwfkTGye2dEyR0vyBIqhryI4vhxeeYkJoudotbOHGyqsBpLlreXsdBmabL9GS1LsUfm7AChvpuB9TsKF4SN8fbRp58bJ2OwUnEyXT0H6za8WyI009hnfQdEiBikbYZJywwyvj9BqLF8my9ZCM9GhNstGuhwJxLz9QDuPCCGOoQhzAgqT/Q9bIeFP4eMelCNSJkqoK2su/VOtJ1EJfv0hoCPcxJUnzu1QKYamqbGk758bJEN4S4YNZ0gErn1Q9ZrizpJwpjYRAZ3slMMnZ2A/q7QOyI2XMJf8nenmtusHQ54bPYcbv0xHyesRFoO6/kD6pUmmoT9NkqxXZkH919M4gWB
 +zfDas1k
 1Hpj4VfOSlj56bBNlHIkwb/CKTy1O4J7PDE5SbipUaKLLdWgTpBVnoR6Oh2gc8k4N42lonWop1JaXaXxdgTBPfO2VGzQRehoNMjEsmo0hTqcr8cuiMpsDVbgMM5ax1goaj+t0mmpVdu9H5B7XFR39VVlEK2Ogy0D/rMCm5UkQAiomQKGC/6gJVo1xZCeApmMUl2HFA/b8OWbOKGCsMKLbZgksqJvpcnKBMl48ueZK8KDIA8JDyRjqQUj35/fKFdjEMTj1ZpmrHvwa4v1r3mkEhUHp80X0wdFYTihAYn1FHP6AdRJOYs4nCq8wIXs3YfhVTgeEEG2wKopxPwt8AXBC3WogoU+rCGCl1WkYlxjD0UCH/7fsN4ba9q6fFbfNz3z9kkXG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 23:05, Matthew Wilcox (Oracle) wrote:
> Other large folios use the has_hwpoisoned flag.  Convert hugetlb to match.
> This will help us use the per-page hwpoison flag in the future.

Currently, the first thing we do in hugetlb_update_hwpoison() is:

	int ret = folio_test_set_hwpoison(folio);

So a hugetlb folio *always* has folio_test_hwpoison() set.

So we can locklessly check whether a hugetlb folios has the flag set simply by
... checking whether it's a hugetlb folio and has the flag set.

Then you write:

"This closes a gap where a page in a previously-poisoned hugetlb folio
could be observed to not have the hwpoison bit set."

When does the race you describe become relevant? When freeing the hugetlb folio
or when demoting it? in both cases, we should be holding the hugetlb lock that
nasty hwpoison code could sync with (if it doesn't already do that).


I can understand that we want something that covers both scenarios: an
indication whether any large folio has any hwpoisoned page. Such a unification
would be good.

But then, special-casing hugetlb *again* through folio_test_huge_poison(),
that's rather odd, no?

(what on earth is "huge_poison" is this supposed to be "hugetlb_poison" ? Why
"poison" and not "hwpoison"? Really odd)

I'd expect that we actually get rid of folio_test_hwpoison entirely and
exclusively work on per-page state and has_hwpoison. But IIUC, now it's some
mixture of folio checks, page checks, folio_has, mixed with some hugetlb oddity.

I am not quite clear whether the change you propose here is actually required
for the remainder of this series?

	[PATCH v9 00/15] Use generic_file_read_iter() in hugetlbfs

IOW, do we really need all this hugetlb hwpoison handling just to accomplish
that, or could some of that (bigger hwpoison rework) be done separately?


[...]

> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1978,6 +1978,22 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>  }
>  
> +/*
> + * Since we cannot split a hugetlb folio, we want to insert a poison
> + * entry into the page table for the whole folio even if only one page
> + * is poisoned.  Otherwise, we've split down to the PTE level and we only
> + * want to poison the precise page
> + */
> +static bool ttu_create_hwpoison(const struct folio *folio,
> +		const struct page *page, enum ttu_flags flags)
> +{
> +	if (!(flags & TTU_HWPOISON))
> +		return false;

Why not keep the flag in the caller? Really looks weird given that we have two
users and one of them doesn't even need the check and must fake it.

I also don't quite enjoy the function name, and it's likely the reason why we
need 4 lines of doc for a simple internal helper that checks whether the thing
(page table entry) we are unmapping/migarting is hwpoisoned. This function is
not involved at all in any kind of splitting.

Some of that code is getting reworked by Dev to better separate out all the
hugetlb oddities. At least for the try_to_unmap() path that helper will not be
required. Staring at the abomination we call try_to_migrate_one(), I assume
we'll do something similar.

I'd just call this "ttu_page_is_hwpoisoned()", and add a short

/*
 * hugetlb folios are always entirely mapped, so any
 * hwpoisoned page is problematic.
 */

> +	if (folio_test_hugetlb(folio))
> +		return folio_test_has_hwpoisoned(folio);
> +	return PageHWPoison(page);
> +}
> +
>  /*
>   * @arg: enum ttu_flags will be passed to this argument
>   */
> @@ -1993,7 +2009,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>  	unsigned long nr_pages = 1, end_addr;
>  	unsigned long pfn;

[...]

>  				dec_mm_counter(mm, mm_counter(folio));
>  				set_pte_at(mm, address, pvmw.pte, pteval);
> @@ -2423,7 +2436,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>  	struct mmu_notifier_range range;
>  	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>  	unsigned long pfn;
> -	unsigned long hsz = 0;

While these size changes are reasonable, they make this patch harder to review
and are not even described in the patch desription.

-- 
Cheers,

David

