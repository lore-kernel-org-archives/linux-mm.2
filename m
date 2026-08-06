Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3CEFC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6D06B009B; Thu,  6 Aug 2026 10:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097F36B009D; Thu,  6 Aug 2026 10:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC81A6B009E; Thu,  6 Aug 2026 10:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B36936B009B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:03:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4558F1607BF
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:03:23 +0000 (UTC)
X-FDA: 85071011886.26.79CCFBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 866E34001A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:03:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eLyCODtq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786025001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcbUps+PJOKEs9ZAZx9T9otuJttHDUts9Bt8Cges3S8=;
	b=muoHpbvIT6XUcIKZlnFLj5tvKRZaEoVUu1bpamh508L9LjV+wBAmOh5sREBf1HFuG+E8v2
	URTCEtM+Q3fuTAPhWWG/8Cb3Pjqo5M+JlRMJHvW7r4aa6W6eJMm4BjNh8Ihmg/yS7A4rP8
	xuIIsq8WKzejklB/IMMoWs4VR1qbHlY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eLyCODtq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786025001;
	b=jMCYeXWkTnX1+j+tGNd04PxhIGbuH+pltIv6AOpfI24F0KpgU4PpoBdjbjX/j+JVxUPGeM
	janaP9frGXIQWDzK2GEEisSuLnKqbIqEuGW2QMmDIOEvwvjmo9SdIJSUw9U3L2uZV2h8kp
	yUt2J4fS65bCjx4+yLaNeoO0vJPGuLI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1987960A69;
	Thu,  6 Aug 2026 14:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD901F000E9;
	Thu,  6 Aug 2026 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786025000;
	bh=AcbUps+PJOKEs9ZAZx9T9otuJttHDUts9Bt8Cges3S8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eLyCODtqlzXwrcAeO8d9T/YueAUfY2dFDeHy2nYTsKalnVBNyZlAI7UN3H8sf49E+
	 AlMgYpq6Y0tUuTaS/lxnhW8ds0NU8wmIfEn/NNGcpGLtT4Uf/I1ebeQa2i0hijhMQC
	 gilaCdqouNEsxYRVNRsU7of55JH6z2RFJm4XcCH7AzuIwmPDZQeSXJZGly7V2Db3WR
	 PUGymMQsPMFwBvnklDGWQMitYiqW0aP98GFO14OCJ5yrDBzjqgltbdyj6JK3WYwEuK
	 OIsVSKJkxjMo8OrGRa35s0+vdtdfNuZUgS0KH7BzJrwRewjw8ER1W3DTEQ+pIaZrcQ
	 R+uAM4Ek/EGfg==
Date: Thu, 6 Aug 2026 15:03:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>, 
	Li Youhong <liyouhong@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
Message-ID: <anRv8ngsyOjkgOHM@lucifer>
References: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 866E34001A
X-Stat-Signature: fgq15qndqwmjmewx17dckqqjs4334gi9
X-Rspam-User: 
X-HE-Tag: 1786025001-974576
X-HE-Meta: U2FsdGVkX1/6jv7ZKkgi6n0T9EvM/ZcrB4v4B+i5dxn+02REUHKn4fMNMYtYVquNzhAcvZV0BXiD7ibSxhbWK+48v805QiYUX2h1//7dWtDGVkKTzhKvRqNxqJxQUiVAdHN9XcG+d6q5eZfJFhrmotgQmopinPxti+DJ5GpUPOc8RmQ9Yzj2w3f6vXocKoeSba3tQbMuSLxOu2372FWYfxmviHl8bNKirJiHPYA3hgEWpDJVqL76+JeqmLTYNzDNuchZQtrxcBtZ7/fYLHKbDwsxHSsQu/h2bA3xPScdUYRzVHsThHZNJnw4bGvEbiRwhl/DErqLS1Z7v3UDQBV8/sKvr+EezJKQzOPeSteCtxxJVsD2pbC47y5qlBl0LUJN5OBfvYF/7MwVC+wYmrulbWZVej34nKmL+4+0Ce7l89VrI9HZMNTbNWup0FuTOce3KFrNfcrpBfJn+6MZDxGJlj5NIB77HIHSOjEPclF9wbDUesTfooMLE8GhNi3lr2pdT7kroI/9FnmEdX6fCewd7W0WO+lE8is3lfo3lFTr0vJo2e3IpLJMzdEuzKBPHcldyf86ldC5RZjWal1oG8uTRpJ0W3+0ZuWnR9n5rO5KCvvFp8iXSOcOw6LSCnolQ6r4UpPjwWAi1q/jVz2i5ZlL7DLU9mNdnhBnMujBbaDW7coX3ize/7/BZTwd/KYDOOG5wWfhQIwWso2TU2wCzYKkwNFZy6PtYVOHLv65+r79et8XzhWw5fzRLnOWxBqGaJcVoJT2RtrMDOwBIYSre8DuiFPXdnXiQUpAvDzetxUdNR2WWVHSrkj/RnU84b9Qi7X8EFsHPd4gZIr/yGVQG8UamS/ZBQKFXxl32QWQVgjC+vRA+GdzGIXf4d4yg7JRL36Wr80wXeeVJWI3ru1EPdRZ4eYFEzJKwlo7Ezx8Bokqlht5tGAbMbre28aN31EEl2J9zf5sMUyKrkW+LD1tuS0
 8Gt4rgRM
 fjsNr9TKmv8c3Xqc6OBrr/3LkfKl1+zYWeoZvSX+989A3klqE6zT2NhqIcaZuSAB/tEhdIuB7bUPNj1dm6XoBaYpMcnrwDzloWC+/eAcLTuH21WBZYbdxnvDlVXXIdL/sdGnIzlBzGMfO+vhvmgHOpCi5TnDoYUIM2v0wUHqhfqwfhKI9IXqBgYil+02EFsJ1epK2pOmqVMjNy0/Wy/ZEDHjtq8NlVNBxchjVZHfjZ0MFsSdzlmxxnE20vGVZD2jpuG7m4++f6wdx3Fzv/MPgFIX55KK2qN3YeJ+f/eNLJXBU9M+9TsEldkBHjS5sWas3DBBtpMY83RAZnm8ZphZWTTCvNPJtAR+qmNQSuHfbZwoqwyi8RddhzQ/O6rtuGebfSnmpOnTNVSfQMy5gsF/VQQ+VK6L+sxqe7mUo17TGMPGl5No=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 01:14:38PM +0200, David Hildenbrand (Arm) wrote:
> hwpoison code can end up calling min_order_for_split() without holding
> the folio lock. There isn't really something that would prevent
> concurrent folio split. Consequently folio->mapping can get set to
> NULL after checking for "!folio->mapping", and if the compiler
> reloads folio->mapping, mapping_min_folio_order() would try to
> dereference NULL.
>
> While very unlikely to happen in practice, let's just enforce that
> min_order_for_split() is called with the folio lock held. We can
> significantly cleanup the calling hwpoison code, and just get rid
> of try_to_split_thp_page() to hold the folio lock for a bit longer.
>
> Just work on folios now, which further cleans up the code. We just
> have to be careful about doing the page_folio() after splitting, which
> we have to do already either way. Do not change the way we split for
> now, this needs more thought and should be done separately.
>
> Cleaning this up we fix another issue: in soft_offline_in_use_page(), we
> would currently have leaked a folio reference.

Yikes...

>
> In folio_split(), document and assert that we need the folio lock.

You mean min_order_for_split()?

> Drop the questionable VM_BUG_ON_PAGE(!page_count(p), p) check entirely.
>
> The folio->mapping problem was identified by Sashiko, and Li Youhong
> reported it by sending a proposal fix.
>
> This likely does not really warrant CCing stable, but I expect little
> conflicts when doing the backport, so let's just CC stable because of
> the refcount leak.
>
> Reported-by: Li Youhong <liyouhong@kylinos.cn>
> Closes: https://lore.kernel.org/r/20260804035828.2684059-1-dayou5941@163.com
> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

A typo above and a nit below about a comment but otherwise LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> v4 of the last fixing attempts:
>
> https://lore.kernel.org/r/20260806031958.677935-1-dayou5941@163.com
> ---
>  mm/huge_memory.c    |  4 ++++
>  mm/memory-failure.c | 56 ++++++++++++++++++-----------------------------------
>  2 files changed, 23 insertions(+), 37 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9b1f3b24f7e0d..a00df56a68b57 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4362,10 +4362,14 @@ int folio_split(struct folio *folio, unsigned int new_order,
>   * If a file-backed folio is truncated, 0 will be returned. Any subsequent
>   * split attempt should get -EBUSY from split checking code.
>   *
> + * Context: @folio must be locked.
> + *
>   * Return: @folio's minimum order for split
>   */
>  unsigned int min_order_for_split(struct folio *folio)
>  {
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +
>  	if (folio_test_anon(folio))
>  		return 0;
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index aaf14608b30e2..f4f3f1fc9eaff 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1705,26 +1705,6 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>  	return page_action(ps, p, pfn);
>  }
>
> -/*
> - * When 'release' is 'false', it means that if thp split has failed,
> - * there is still more to do, hence the page refcount we took earlier
> - * is still needed.
> - */
> -static int try_to_split_thp_page(struct page *page, unsigned int new_order,
> -		bool release)
> -{
> -	int ret;
> -
> -	lock_page(page);
> -	ret = split_huge_page_to_order(page, new_order);
> -	unlock_page(page);
> -
> -	if (ret && release)
> -		put_page(page);
> -
> -	return ret;
> -}
> -
>  static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
>  		struct address_space *mapping, pgoff_t index, int flags)
>  {
> @@ -2509,9 +2489,6 @@ int memory_failure(unsigned long pfn, int flags)
>  	folio_unlock(folio);
>
>  	if (folio_test_large(folio)) {
> -		const int new_order = min_order_for_split(folio);
> -		int err;
> -
>  		/*
>  		 * The flag must be set after the refcount is bumped
>  		 * otherwise it may race with THP split.
> @@ -2526,24 +2503,25 @@ int memory_failure(unsigned long pfn, int flags)
>  		 * page is a valid handlable page.
>  		 */
>  		folio_set_has_hwpoisoned(folio);
> -		err = try_to_split_thp_page(p, new_order, /* release= */ false);
> +
> +		folio_lock(folio);
> +		split_huge_page_to_order(p, min_order_for_split(folio));
> +		folio = page_folio(p);
> +		folio_unlock(folio);
> +
>  		/*
>  		 * If splitting a folio to order-0 fails, kill the process.
>  		 * Split the folio regardless to minimize unusable pages.
>  		 * Because the memory failure code cannot handle large
>  		 * folios, this split is always treated as if it failed.
>  		 */
> -		if (err || new_order) {
> -			/* get folio again in case the original one is split */
> -			folio = page_folio(p);
> +		if (folio_test_large(folio)) {
>  			res = -EHWPOISON;
>  			kill_procs_now(p, pfn, flags, folio);
> -			put_page(p);
> +			folio_put(folio);
>  			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
>  			goto unlock_mutex;
>  		}
> -		VM_BUG_ON_PAGE(!page_count(p), p);
> -		folio = page_folio(p);
>  	}
>
>  	/*
> @@ -2861,9 +2839,8 @@ static int soft_offline_in_use_page(struct page *page)
>  		.reason = MR_MEMORY_FAILURE,
>  	};
>
> +	folio_lock(folio);
>  	if (!huge && folio_test_large(folio)) {
> -		const int new_order = min_order_for_split(folio);
> -
>  		/*
>  		 * If new_order (target split order) is not 0, do not split the
>  		 * folio at all to retain the still accessible large folio.
> @@ -2871,15 +2848,20 @@ static int soft_offline_in_use_page(struct page *page)
>  		 * preferred, split it to non-zero new_order like it is done in
>  		 * memory_failure().
>  		 */

This comment is:

		/*
		 * If new_order (target split order) is not 0, do not split the
		 * folio at all to retain the still accessible large folio.
		 * NOTE: if minimizing the number of soft offline pages is
		 * preferred, split it to non-zero new_order like it is done in
		 * memory_failure().
		 */

Which references 'new_order' twice - probably need to update this.

> -		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
> -						       /* release= */ true)) {
> +		if (!min_order_for_split(folio))
> +			ret = split_huge_page_to_order(page, 0) ? -EBUSY : 0;
> +		else
> +			ret = -EBUSY;
> +		folio = page_folio(page);
> +
> +		if (ret) {
> +			folio_unlock(folio);
> +			folio_put(folio);

Wow, incredible that we had a refcount leak here for ages and didn't know. Ugh
what a mess this hw posion crap is!

>  			pr_info("%#lx: thp split failed\n", pfn);
> -			return -EBUSY;
> +			return ret;
>  		}
> -		folio = page_folio(page);
>  	}
>
> -	folio_lock(folio);
>  	if (!huge)
>  		folio_wait_writeback(folio);
>  	if (PageHWPoison(page)) {
>
> ---
>
> base-commit: e5492213654050379e78ec6f9acfd6c9fe00f334
>
> change-id: 20260806-try_to_split_thp_page-a359f4d8c90f
>
> --
>
> Cheers,
>
> David
>

--
Cheers, Lorenzo

