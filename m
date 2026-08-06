Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F2D8C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 12:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6096B0088; Thu,  6 Aug 2026 08:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7DE46B008A; Thu,  6 Aug 2026 08:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9E66B0092; Thu,  6 Aug 2026 08:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 813E76B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:07:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA6CA1C0019
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:07:31 +0000 (UTC)
X-FDA: 85070719902.08.9FDC5C3
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf09.hostedemail.com (Postfix) with ESMTP id CA770140011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:07:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q887c7pa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786018050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49BApBT44VNf2oHdmYMv0Gennxw3e9jZQmU5d15l048=;
	b=btxzoeNC+xeLE04z6bj/gnv6vnaLBDUyqDhWR0/20h5jR9Bbimfwe9j5kdr8nsq/ohPYae
	hDqh0lNDQ24pPVz4pz/l0SehsBPDp+u2baIicKDIqrod6kKa8Gy24hqDbYuuubpIsAIY7P
	Ae5nRkMFEp7LzTkuMMvoewFE4/fiyAA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q887c7pa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786018050;
	b=Ux328EupEwM6GjUnXRt5Ex2IyqTttecsp8J8mPV7suFGdj1Jckl3XFDONIaEtcwQe9Q2n+
	99h24gfXQpacFGlYEDld5Eo6Iaa0Pk2gL1aXBv3faMr7dtAxHDbRqcu433Pzcwg2hcjarf
	sR/PcBT4yBNJp8PTIFEHAWzVWKDo/MA=
Message-ID: <563848c7-f9eb-45c6-af25-facf0fdc9b4b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786018046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=49BApBT44VNf2oHdmYMv0Gennxw3e9jZQmU5d15l048=;
	b=Q887c7paPBj+KusvSUNvM7sGK5rvi0S9in+Bbs+WZ12U2p/zKpimsZ81hiKXjkDAjwTslV
	QAfWevIcAwaPfUzSNVYbI1blcEFfWZh8Pju0hVKHeTwONRUbYaJp2UxEPF6mufz+YRYh7e
	64xhxmayFMud07+IDss37p9a17avry8=
Date: Thu, 6 Aug 2026 13:06:00 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>, Li Youhong <liyouhong@kylinos.cn>,
 stable@vger.kernel.org
References: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CA770140011
X-Stat-Signature: bwj6exyip7mn9o4f6ni58u5ppnf3rdtx
X-Rspam-User: 
X-HE-Tag: 1786018049-771192
X-HE-Meta: U2FsdGVkX1/tCGItuRaiSCL2lvJEeOUzrb2HMtgoVGXCEsJpncwtgAb05L3/ehuIygquXxUmFFjJlh2td4skR2s9f06PMJCmFtgyHZztc9coHeKL/K6iSYQEmsyPw+hC68O4vbwdHxzAp2HAdCX9V/3we2ag4e8re0qE50hPpHENfsNa5G5GN6JgexfuoaG+hz6p0YWaHsBVpbjcAmt83BXpFxDn3kAwPGREtP+l2PtGE0vh8oIGmwKX8t4a4tTtkW61xR5ULXXHuxZVxHTtEiwJVdgdN9PZ9L1qqP8QS389cyY7dscWXzmlJ4Cq7M7C36QC4a90ucFESnUhrxkblx0xs2CRpBO0454lgdNsk8ZNEYAzJZZxOGTxSHs9+qE7L82viFY8R7LhZIZ96WZrLgCx12piMO3UbhH16lQ6wOKr9FQAWges1sf86lNHWiu2xt50dsTF/bUZiUiteS/+9F2iA7lfXy9OPfzSANKISWGLUVfubym3otWT60iJ970t3dWGlIF0YfLCvUBR7jCsO+pDDeijQ29RcHyj7TqXSbESmgdcizYLj2PkjqWysp6nHenveaqn4dDfwgSXIFyCkuJ/corhvUEmTXKtAH+n2aJajf711hnHcJdWlxM/HgX+Ic18dJ+N+9O97gbjaHMxhHiRYXVZlbUST9clZf5lJ3cetQ7CaUL6qz/psp8wYqy2meL2nbYD4yx5y/7UYm1WcBSBD9W/u3xDuOBXgdcr02TftfA+suTYTf6XbTPtUI1J3lXjleloT/ZISLCje/lKu5yFacbC+kjoxwl57sXPp/39SBCO+ihFMdJ7+wnfQDzhWxBQlK/Pw4snqxnMWO++cPJ6jVSCg4vz/qZZgn4Kg/1JbllHJgagZ5SN0827lKBF4R9JBUUweiNcQtUECVnHmp5VLGqI4x9J93UYkgmHEWQbk7cNzijv+9s1/XfyOLRoFDTRpHtFCt9132ujjN1
 i+yq8jVI
 u5Lg+dWcKJMYDThxtnPWPE0cTARk/ws/gycrFZHSamgqtidKhl62xsAqWPocnI6jTZfUwQIsULsVUnsXiNQJzRUSdNK+yIrA+GJybfj1rRbruOPh96gwW41PTOspeUCOpkr2lPf3SsUV6a2zdzieODMzwDfKkqXpJwzOWRVcZX+HDNClvnPZrcNVyEq2THUQJVq6PyvrugC2ii0KBUQduiqQxO+KnQ0Ghlp1qNEgQd5NGIoJfYjGoYkYWKKf2rLlLO+Ubz6pVR22ElXfq7EuWUrvk34yNcyf3tIE9WpbGoGOouNExwyCzo4NP2KB9QCHnWBobtRxYVYLuVdBVkO1AjHwFK1wtU8ALEs8oA55r/mEXd3Ai/1k9x9C1bSIQFioks80a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/08/2026 12:14, David Hildenbrand (Arm) wrote:
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
> 
> In folio_split(), document and assert that we need the folio lock.
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

Makes sense here, folio->mapping can become NULL after the `if (!folio->mapping)`
check if folio_lock() is not held.


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

Looks cleaner and preserves existing policy where with successful split to order 0,
you continue handling the individual page, but onl split failure, folio remains large and
you report the failure.

  
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


LGTM

Acked-by: Usama Arif <usama.arif@linux.dev>

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


