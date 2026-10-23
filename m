Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E409606A325
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cT6hVZUW
Received: by kanga.kvack.org (Postfix)
	id 90FAD6B037C; Fri, 23 Oct 2026 10:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0706B0381; Fri, 23 Oct 2026 10:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED4E6B0382; Fri, 23 Oct 2026 10:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F56D6B037C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:01:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0F2D1A040D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:01:13 +0000 (UTC)
X-FDA: 85354052826.27.69ECD8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 080111A0019
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:01:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cT6hVZUW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792764072;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HP9Ra1b1eXP/Ub6Btog3ZP8dK/E/DDVXsJ9haEXY8dU=;
	b=r839awj0NX451klnzc70VUUwTak01YKo9GN+2k4X914y0Ts8z1R26vmxvLFJFXMqBrnGdH
	4tN5eS1M9pjJwXG6abHkO4HN+3Q/jT0bGgrbr87DSOFpSKAPs853P1D1e07wS1SfM0TF5k
	r1a1vQN5FQnPtktbU8E4BaLQUDwIIHs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cT6hVZUW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792764072;
	b=y3wEne2R0IZ/QM2mRRq/Td0bxiguW3YHNS868ZAl5fB1D1QeNcpmQzJZUK4iyqcmLZWPpW
	32G0TgMgwGU8RzgmF5CRj66kVParFFNx+zRbCpEYct9vht4gkSgnXp1n3zDii44NJ3bGF3
	p2s5Y3IrG3R0UWfsirXi83gEIWEGBEk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F78C43E8E;
	Fri, 23 Oct 2026 14:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAA31F031E6;
	Fri, 23 Oct 2026 14:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792764071;
	bh=HP9Ra1b1eXP/Ub6Btog3ZP8dK/E/DDVXsJ9haEXY8dU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cT6hVZUWjoCBzeWOU1kAHJWoD5SSQjiqy8FHTJUNl5JmKFhLTD9sgxtdCCNT0ooVW
	 DylpKsBnOwKn59nm3Z6HhlSr83zyoYFlAnIiMOkBSJEUtHyQPWV1IoVGoHqOjsMC/W
	 jz4FPwofk2aVrSPG6EQwE6tHbuh/ecQl+oMXlRKX0fxc2su/khX5IncuuyigKR9rCm
	 pyR7y7LNNiDb5eRE0up958aHjQ0c5llbqgB1EAglyUaDAecDV7x/Jf0bvrHkuZbtHE
	 X8+f/qUvexJEMclRxAQcNzlUqTVgxns9JGqAbazvCR7Ak5g8WYxzLC7QyjE2qJwjDr
	 uxJDtUI8OgTWA==
Message-ID: <sashiko-outbox-182858@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] mm/filemap: read ahead downwards on descending
 VM_HUGEPAGE faults
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>, =?utf-8?b?TWF0dGhldyBXaWxjb3gg?=
 =?utf-8?b?KE9yYWNsZSk=?= <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vishal Moola" <vishal.moola@gmail.com>, fujunjie <fujunjie1@qq.com>
Cc: "Roman Gushchin" <roman.gushchin@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, linux-mm@kvack.org
In-Reply-To: <20261022-bug-mm-mmap-readahead-descending-v1-1-6d08b34862f2@gmail.com>
References: <20261022-bug-mm-mmap-readahead-descending-v1-0-6d08b34862f2@gmail.com>
 <20261022-bug-mm-mmap-readahead-descending-v1-1-6d08b34862f2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 14:01:10 +0000
X-Rspamd-Queue-Id: 080111A0019
X-Rspam-User: 
X-Stat-Signature: twsgd4y4aaf5qosggte8znuart3jjcij
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792764071-381619
X-HE-Meta: U2FsdGVkX1967iWvb9EG4hP9z05qWH+orlr13Mhf9iLCmOfSpCMLRlseRgHQBIo45r4BfJHKTAPvrQu75jiWb0nc+pG8eL6tMF1lftXr+GzWb23h4H9FRAbv2MzQi+G16pI4UTP8Po9JXSG9pf3xcZlOyyxKLwrAknWs/6BTTBe4Ph3HKEG0x5QjkYK/HTHQriaK4ouo5aGEdol8el3b8jOyW/zuU700awxislFEwxA51ZpQUihwDUoAXsQCVq5D03xIr6qIP/qsIaTfRKd2zlJXQQe7uxC7bZ/NoBlDjGj0HXWbK5q2x4lAIHJurBxfbKjR5PeZ+qc6zDjcfp4GaJLak9C7JlLf2E8xcREqLvnNmRsOqxDk5CuKCGuKaWdyyK0EcuLRyTzlAv3ezbhf3H+7ztqZwC8eEGZTiDnRIVCEbHbFrjPS0YcwB4s8TkeZwBu+p75iE7YieAnrg3rJyCBLYcbdPyJZk/FildTJMiC5q501xE/jW0e8Vh/vLD1zHF4NC4wlO+6q43dkwbgO6QQuzukX7LK2yrLlckTV/f2fYF0TzZic5nfdRz8yHtfo7V3B2Qelis9XE7dt/h50PUxO2s9b/mKw01USzV8Lk9aHkB0OARFpn4XvmObK41Zx8V0Dd35vjrbfb2HmnLdtN1jSG0b+MHQ5iAsBHBENQC8137x10NXoOa6hvFcARVQ3QdcpcBLMxO3FXU3WxJpe7KHFlL9Pt6+X8Eo+v33zzr6mKsettm1qoI/ux+82glOAyFyoRMsSrBLpXx4VzqeUQExEYr9uvIfe+zx33DHTrZG5FGINjt2PEaZao4W0ek+/BKJ7QxNOKLt7H5NZIl4f+4ROaYvNmX8ysmn1bku/eck+StCapiiUCg9n5ITQmrLLPTg054uXSVEqcEcec/QMeht1DpJsk87vaPfOnuAsfYg8WdHzS3UU6hJLmKI3x5hk1NX46MnwNaIEstv6iW/
 6HP8BOkG
 1EktBSp3UHrGa6mn3AY+5FC1q3pP5dEJhC25e6XZfFbJGs5n8Q12IDt+etMLzfh7J68Um+AT+wKl5es4E4ewOU4KbuEYKrlqZS2rvEWb6agoYywS9HtrzjT1s2aqJLr35pd+pzuTs0fJNMSCcUd8sKYMhvXPeyJMNzyT7Lwx/RHR1VC2s2hoIs8CfKWXrKBvWmynxFb5EUH+GrPb+b+5NQ2qs7qkbwlatghdjUi9yTDbZH3g4v0KsVJsT1siXgROMoOYhFFRWwJttzz8/PdTSVgWlj5DR3x+CMDilh6SfOTd0V8RMuWXvyabdWQLciYKl2vIezIXlZtjciuS42ZL0QVnctQFYM9pkS97nwdUSxUc6TJzdQj75NMnVBh1zRJVtDFrXSSErHBrSkkyX/138NZll7vQh0t6pWKrYMQJlj9BNXosJsj7O5IrQzDoYqb2Z1E14qMN79iAKoBrcoCsdoaMnhBV0Vw8nNzH7pnOsqwxZIEo7/VECsSPJL58sxBQ5WGabznjDeIBlowyeVs3o738USkriLMC/sr7Ox20yzUX6jKCLLPc0+NHsRnOo+KwtwqKeSwpAS3yy7TwdRcXIxuuAwFoYBj1YIdFuX84rKeQSd0IYTXSUOJmZoOQcQqDg+vcE4sxpL9ffD90SNciQzFVJRA3BSrBwJHhpHnE0pqftm9lYIU2bCKyyreYc3TxWTHLEUnZ14w0nWVZPDDJt/jtfZh92WtN8Z8TyeDTQflG9MiaraiPPd1oVQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/filemap: descending VM_HUGEPAGE readahead falls back to order=
-0 if lower folio cached
--

commit 137f4cfedf4000c009512ee87ca8b229bcf35fa5
Author: Qiliang Yuan <odys.yuan@gmail.com>

mm/filemap: read ahead downwards on descending VM_HUGEPAGE faults

This commit updates synchronous mmap readahead on VM_HUGEPAGE mappings to
read the folio below the faulting one when the folio above is already
cached, and counts PMD mappings of the faulting address as mmap hits.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 00fd89cf6f550..8a7d1238ae75d 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3319,6 +3319,23 @@ static int lock_folio_maybe_drop_mmap(struct vm_fa=
ult *vmf, struct folio *folio,
>  	return 1;
>  }
> =20
> +/*
> + * Whether a miss at @index, right below @nr cached pages, comes from a
> + * stream that runs towards lower offsets.
> + */
> +static bool filemap_descending(struct address_space *mapping, pgoff_t in=
dex,
> +			       unsigned long nr)
> +{
> +	void *entry;
> +
> +	if (index < nr)
> +		return false;
> +	rcu_read_lock();
> +	entry =3D xa_load(&mapping->i_pages, index + nr);
> +	rcu_read_unlock();
> +	return entry && !xa_is_value(entry);
> +}
> +
>  /*
>   * Synchronous readahead happens when we don't even find a page in the p=
age
>   * cache at all.  We don't want to perform IO under the mmap sem, so if =
we have
> @@ -3392,13 +3409,20 @@ static struct file *do_sync_mmap_readahead(struct=
 vm_fault *vmf)
>  		fpin =3D maybe_unlock_mmap_for_io(vmf, fpin);
>  		ractl._index &=3D ~(folio_nr_pages - 1);
>  		ra->size =3D folio_nr_pages;
> +		ra->async_size =3D folio_nr_pages;
>  		/*
>  		 * Fetch two folios so we get the chance to actually
> -		 * readahead, unless we've been told not to.
> +		 * readahead, unless we've been told not to. A stream that
> +		 * runs towards lower offsets gets the folio below.
>  		 */
> -		if (!(vm_flags & VM_RAND_READ))
> +		if (!(vm_flags & VM_RAND_READ)) {
>  			ra->size *=3D 2;
> -		ra->async_size =3D folio_nr_pages;
> +			if (filemap_descending(mapping, ractl._index,
> +					       folio_nr_pages)) {
> +				ractl._index -=3D folio_nr_pages;
> +				ra->async_size =3D 0;
> +			}
> +		}
>  		ra->order =3D thp_order;
>  		page_cache_ra_order(&ractl, ra);
>  		return fpin;

[Severity: Medium]
What happens in do_sync_mmap_readahead() when a fault occurs on an uncached
folio_nr_pages range in a VM_HUGEPAGE mapping where both the upper neighbor
(ractl._index + folio_nr_pages) and the lower neighbor
[ractl._index - folio_nr_pages, ractl._index) already have cached pages in
mapping->i_pages (for example, faulting on an uncached hole between two
cached regions, or a descending scan reaching a cached lower region)?

filemap_descending() in mm/filemap.c only checks xa_load(&mapping->i_pages,
index + nr) and does not check whether the lower range already contains
cached entries, so do_sync_mmap_readahead() shifts ractl._index down by
folio_nr_pages before calling page_cache_ra_order(&ractl, ra).

In mm/readahead.c:page_cache_ra_order(), the allocation loop starts at the
shifted lower index before reaching the faulting range:

	while (index <=3D limit) {
		...
		err =3D ra_alloc_folio(ractl, index, mark, order, gfp);
		if (err)
			break;
		index +=3D 1UL << order;
	}
	...
fallback:
	if (ra->size > index - start)
		do_page_cache_ra(ractl, ra->size - (index - start),
				 ra->async_size);

When ra_alloc_folio() fails with -EEXIST on the already-cached lower folio
at start, the loop breaks before reaching the faulting range and falls back
to do_page_cache_ra() -> page_cache_ra_unbounded():

	folio =3D ractl_alloc_folio(ractl, gfp_mask,
				mapping_min_folio_order(mapping));

Doesn't this populate the faulting VM_HUGEPAGE range with
mapping_min_folio_order(mapping) (order-0) folios instead of a thp_order
folio, preventing PMD mapping of the faulting range?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-bug-mm-mma=
p-readahead-descending-v1-0-6d08b34862f2@gmail.com?part=3D1

