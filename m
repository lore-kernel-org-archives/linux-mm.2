Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52170C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AEC16B0093; Thu,  6 Aug 2026 10:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3601A6B0095; Thu,  6 Aug 2026 10:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24ECE6B0096; Thu,  6 Aug 2026 10:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D71556B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:26:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9AB4A25AF
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:26:37 +0000 (UTC)
X-FDA: 85071070434.29.0D46F77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1E43B14000B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:26:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VpD4TNWN;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786026396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZ2eDYGSj2XtYyLf86x9P+NytbC9JWawDjK2akJlovE=;
	b=7yEs2ckR4N6JBp/0eYEAW4Jabcmrc01zVvwrmJED/VMZ+DpU4Qb6uQr/oK0S/Z+4RSs7Qc
	sxn123OsxQtp/uettD+1CPa+7nYb4fF0zieJuJzc/R+up1LIWx+ZwmlBO5oF5ShmiIlYz7
	EoyYiE3Y8SUeDrZ+MIEpsL4o1G+L0Hg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786026396;
	b=CekUAXOpekNgNJjibQYNvZjXCb6H+QujBRCZRV/zVaIDdbhm7ItxBiNuBd5a/ugRHon6wO
	eXP3nPfo0bINkGKn1Qbiv5/NHVo6f3hj4McjXwqxnoP1emcOu+Y3MxtE78fC9Kqsvs7du8
	swS1Gi0vwQsuoEmADb+ET3fEj6bk+TU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VpD4TNWN;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63E8141893;
	Thu,  6 Aug 2026 14:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3351F00A3A;
	Thu,  6 Aug 2026 14:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786026395;
	bh=fZ2eDYGSj2XtYyLf86x9P+NytbC9JWawDjK2akJlovE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VpD4TNWN59KnyLiJVal2vHb04rgodpNvBpCOIAWYXFVetxYPhmV2HUsdaIMM182at
	 eyhJLeqf/AUdoYxSTO1Be4wjykrqpSHPIORgCpKaDFR4rirr3ugm7l5eSoQixTcVHZ
	 koWFUAmfd/j7KVGFu4oeA5q7QzjPutCp2IeDaqJOwfGD1Kvw5DQE27bZYtT3oFdgpv
	 MjPJFMvL1pjys9z9KbqsOyeahKWYSuAze9F+uU+8u92dtPCs5ggxoPGz9o3+k6XTLi
	 blcsJr3ljTqGWg8QaxSiEi9XGwyIxL6Oyw6kxPhmEx2AKMAks1vDYvaQNl2nfxha1/
	 yU4qYnbq7Ppxg==
Date: Thu, 6 Aug 2026 15:26:16 +0100
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
Message-ID: <anSZbWcdK_xBJ8Pk@lucifer>
References: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
 <anRv8ngsyOjkgOHM@lucifer>
 <d6e665cd-08a3-4598-8a4f-1af21eea4132@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6e665cd-08a3-4598-8a4f-1af21eea4132@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E43B14000B
X-Stat-Signature: 9szs1mxgyxmqs3sn3ahafcsj94n7qp5n
X-Rspam-User: 
X-HE-Tag: 1786026395-218140
X-HE-Meta: U2FsdGVkX190AtLMgMzrXfWFs6tYo/tsKI7Rb8F1a3Yd/ej351b59syJtgiPsoKrV1UgoSOlPq9TqFrQMt6yxTtbn/ZtpMt9fr9WqRZRWHjWvXoNPt4sc97UEU/u07YlaFTW7kladnFuAkIlekSdpZqEE7a5xNiSbiyAVEYf/CAUUIatd1T/hieJSnZ52o0TWq9uK1Py/bAhxvgqdq3Wreg99Di4PkrJnwMSGSeveAXEf02k4InhJrsBIEXsQYFLQmYdM6U192RI0cxGq49/Zqgwoio1aJFzMQG05qvVHSmKNGpN2fIHVJS6LKN2wW5sdJ3mD44eFJEElGezbSKdyWSavTbw4kO7WKs+DugOM/a6hPxaY0sRaxVPF1gPY0WeB217CZdryW3ryl3G6FOmaoeEin/mbePR9tqndmu+ZUXzwjIMWji6NFeIEO8qKXkStGsnC0DOTh9SSpqGfznWsFJm53fnhbMtPf/POdmHqGNH9zyGW6mSQEoLE6i22HsGMo8jx7IKeN3ahR/Rhy+VMSIMMCJIBoqwbtOK4eOmoSrkFWPDby9572KU8KizMV58CnihcG4DbbPchx7YbfcRrhpUGxoYppyosLOBiUT8Bwinkr2ggVnmBmqyOinLJQgO9vLsuZzRi9ZuLTrW0eu8ERUxOzERdtzKfThIfgCqpWl73oWbQR9vCHYCgdYMZlPIdnHX0pTqdCuGzWJyTWzSxts7+yz/UmlORRAODixqTwPA812a9s4FIRnZ+E1rJQzH92rMq1A8Ow9kTXjD5SlS42t6mUKJ2bOF6b/Uq7a/Sg75oy+v/LvbepHTyHCH36O6j+BrS+pgbFRNaaYT1Ztz+3J2v50Zmm+iv0HwDkFY2M1bH2Pl1K0UK6fXHGQ5cNWmw30T9mete0US+K4vT2NVX6yXuZ/GPMWJlpY7wwT5W7+1W5N0rL2DmlnJ7fhMBB8xL+e3KuGPjL6OWKzeL7g
 iCfpnqFq
 8wtrqJ2oVdtgaVLG/IRHyWPp0MIw1MPnBOPAM5rsGsdDjp5O0PxUFvQ/2KSaGmziv+99iWeHpKFrrYyPMWUPneCSaev2jwWTeRHXdl12kYz9wU7uyAFmSDMonj6IsLdAIHsFMswAMt89wlHVXnik/e5QZb2duWgxxTqEVG6qiUab1VY8MbPa5BNCASYIgQjpkwJrW7krk+hLpmojaD2d6KgQGcMWn/52eNznzIbvc4tJNrKbwstjx2MHf7DVWKeRl7fREeSrj88ddBqZnVGSGI6p9xrzGOfrld/4o6tTj9K5u4n/VKwsEDHskZkrxFHPkhpe5V7Z29/KkDL3UnuS6dHvlon9nqLl7NwB/EV2p5TXXm9Criu2tY5YDr0CvVUVeR8L+YKM+nZr5zNWtZO6TDXQDshopTtXADwhWH1dde5xUAmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 04:17:21PM +0200, David Hildenbrand (Arm) wrote:
> On 8/6/26 16:03, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Aug 06, 2026 at 01:14:38PM +0200, David Hildenbrand (Arm) wrote:
> >> hwpoison code can end up calling min_order_for_split() without holding
> >> the folio lock. There isn't really something that would prevent
> >> concurrent folio split. Consequently folio->mapping can get set to
> >> NULL after checking for "!folio->mapping", and if the compiler
> >> reloads folio->mapping, mapping_min_folio_order() would try to
> >> dereference NULL.
> >>
> >> While very unlikely to happen in practice, let's just enforce that
> >> min_order_for_split() is called with the folio lock held. We can
> >> significantly cleanup the calling hwpoison code, and just get rid
> >> of try_to_split_thp_page() to hold the folio lock for a bit longer.
> >>
> >> Just work on folios now, which further cleans up the code. We just
> >> have to be careful about doing the page_folio() after splitting, which
> >> we have to do already either way. Do not change the way we split for
> >> now, this needs more thought and should be done separately.
> >>
> >> Cleaning this up we fix another issue: in soft_offline_in_use_page(), we
> >> would currently have leaked a folio reference.
> >
> > Yikes...
> >
> >>
> >> In folio_split(), document and assert that we need the folio lock.
> >
> > You mean min_order_for_split()?
>
> Very right :)
>
> >
> >> Drop the questionable VM_BUG_ON_PAGE(!page_count(p), p) check entirely.
> >>
> >> The folio->mapping problem was identified by Sashiko, and Li Youhong
> >> reported it by sending a proposal fix.
> >>
> >> This likely does not really warrant CCing stable, but I expect little
> >> conflicts when doing the backport, so let's just CC stable because of
> >> the refcount leak.
> >>
> >> Reported-by: Li Youhong <liyouhong@kylinos.cn>
> >> Closes: https://lore.kernel.org/r/20260804035828.2684059-1-dayou5941@163.com
> >> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > A typo above and a nit below about a comment but otherwise LGTM so:
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> >> ---
> >> v4 of the last fixing attempts:
> >>
> >> https://lore.kernel.org/r/20260806031958.677935-1-dayou5941@163.com
> >> ---
> >>  mm/huge_memory.c    |  4 ++++
> >>  mm/memory-failure.c | 56 ++++++++++++++++++-----------------------------------
> >>  2 files changed, 23 insertions(+), 37 deletions(-)
> >>
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index 9b1f3b24f7e0d..a00df56a68b57 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -4362,10 +4362,14 @@ int folio_split(struct folio *folio, unsigned int new_order,
> >>   * If a file-backed folio is truncated, 0 will be returned. Any subsequent
> >>   * split attempt should get -EBUSY from split checking code.
> >>   *
> >> + * Context: @folio must be locked.
> >> + *
> >>   * Return: @folio's minimum order for split
> >>   */
> >>  unsigned int min_order_for_split(struct folio *folio)
> >>  {
> >> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> >> +
> >>  	if (folio_test_anon(folio))
> >>  		return 0;
> >>
> >> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> >> index aaf14608b30e2..f4f3f1fc9eaff 100644
> >> --- a/mm/memory-failure.c
> >> +++ b/mm/memory-failure.c
> >> @@ -1705,26 +1705,6 @@ static int identify_page_state(unsigned long pfn, struct page *p,
> >>  	return page_action(ps, p, pfn);
> >>  }
> >>
> >> -/*
> >> - * When 'release' is 'false', it means that if thp split has failed,
> >> - * there is still more to do, hence the page refcount we took earlier
> >> - * is still needed.
> >> - */
> >> -static int try_to_split_thp_page(struct page *page, unsigned int new_order,
> >> -		bool release)
> >> -{
> >> -	int ret;
> >> -
> >> -	lock_page(page);
> >> -	ret = split_huge_page_to_order(page, new_order);
> >> -	unlock_page(page);
> >> -
> >> -	if (ret && release)
> >> -		put_page(page);
> >> -
> >> -	return ret;
> >> -}
> >> -
> >>  static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
> >>  		struct address_space *mapping, pgoff_t index, int flags)
> >>  {
> >> @@ -2509,9 +2489,6 @@ int memory_failure(unsigned long pfn, int flags)
> >>  	folio_unlock(folio);
> >>
> >>  	if (folio_test_large(folio)) {
> >> -		const int new_order = min_order_for_split(folio);
> >> -		int err;
> >> -
> >>  		/*
> >>  		 * The flag must be set after the refcount is bumped
> >>  		 * otherwise it may race with THP split.
> >> @@ -2526,24 +2503,25 @@ int memory_failure(unsigned long pfn, int flags)
> >>  		 * page is a valid handlable page.
> >>  		 */
> >>  		folio_set_has_hwpoisoned(folio);
> >> -		err = try_to_split_thp_page(p, new_order, /* release= */ false);
> >> +
> >> +		folio_lock(folio);
> >> +		split_huge_page_to_order(p, min_order_for_split(folio));
> >> +		folio = page_folio(p);
> >> +		folio_unlock(folio);
> >> +
> >>  		/*
> >>  		 * If splitting a folio to order-0 fails, kill the process.
> >>  		 * Split the folio regardless to minimize unusable pages.
> >>  		 * Because the memory failure code cannot handle large
> >>  		 * folios, this split is always treated as if it failed.
> >>  		 */
> >> -		if (err || new_order) {
> >> -			/* get folio again in case the original one is split */
> >> -			folio = page_folio(p);
> >> +		if (folio_test_large(folio)) {
> >>  			res = -EHWPOISON;
> >>  			kill_procs_now(p, pfn, flags, folio);
> >> -			put_page(p);
> >> +			folio_put(folio);
> >>  			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
> >>  			goto unlock_mutex;
> >>  		}
> >> -		VM_BUG_ON_PAGE(!page_count(p), p);
> >> -		folio = page_folio(p);
> >>  	}
> >>
> >>  	/*
> >> @@ -2861,9 +2839,8 @@ static int soft_offline_in_use_page(struct page *page)
> >>  		.reason = MR_MEMORY_FAILURE,
> >>  	};
> >>
> >> +	folio_lock(folio);
> >>  	if (!huge && folio_test_large(folio)) {
> >> -		const int new_order = min_order_for_split(folio);
> >> -
> >>  		/*
> >>  		 * If new_order (target split order) is not 0, do not split the
> >>  		 * folio at all to retain the still accessible large folio.
> >> @@ -2871,15 +2848,20 @@ static int soft_offline_in_use_page(struct page *page)
> >>  		 * preferred, split it to non-zero new_order like it is done in
> >>  		 * memory_failure().
> >>  		 */
> >
> > This comment is:
> >
> > 		/*
> > 		 * If new_order (target split order) is not 0, do not split the
> > 		 * folio at all to retain the still accessible large folio.
> > 		 * NOTE: if minimizing the number of soft offline pages is
> > 		 * preferred, split it to non-zero new_order like it is done in
> > 		 * memory_failure().
> > 		 */
> >
> > Which references 'new_order' twice - probably need to update this.
>
> Agreed, thanks!
>
> While at it, I'll just drop the NOTE that is not of any value, really?

Yeah rip that out.

>
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index f4f3f1fc9eaff..9f1e547e7b472 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2842,11 +2842,8 @@ static int soft_offline_in_use_page(struct page *page)
>         folio_lock(folio);
>         if (!huge && folio_test_large(folio)) {
>                 /*
> -                * If new_order (target split order) is not 0, do not split the
> -                * folio at all to retain the still accessible large folio.
> -                * NOTE: if minimizing the number of soft offline pages is
> -                * preferred, split it to non-zero new_order like it is done in
> -                * memory_failure().
> +                * If we cannot split to order-0, do not split the folio at all
> +                * to retain the still accessible large folio.
>                  */
>                 if (!min_order_for_split(folio))
>                         ret = split_huge_page_to_order(page, 0) ? -EBUSY : 0;
>
> >
> >> -		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
> >> -						       /* release= */ true)) {
> >> +		if (!min_order_for_split(folio))
> >> +			ret = split_huge_page_to_order(page, 0) ? -EBUSY : 0;
> >> +		else
> >> +			ret = -EBUSY;
> >> +		folio = page_folio(page);
> >> +
> >> +		if (ret) {
> >> +			folio_unlock(folio);
> >> +			folio_put(folio);
> >
> > Wow, incredible that we had a refcount leak here for ages and didn't know. Ugh
> > what a mess this hw posion crap is!
>
> I mean, soft-offline handling is not what runs on ... everyone's box. And the
> memory will effectively be dead soon either way (hardware tells us that this
> memory is likely going to get hwpoison soon) in most cases ... :)

Good. I think we should burn the whole thing down tbh.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

