Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2ACF606A326
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 07:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Ok0mOKSw
Received: by kanga.kvack.org (Postfix)
	id DCF416B05B1; Mon,  9 Nov 2026 02:23:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6BF6B05B2; Mon,  9 Nov 2026 02:23:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6906B05B3; Mon,  9 Nov 2026 02:23:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A03CB6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:23:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E40C1C3D62
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:23:19 +0000 (UTC)
X-FDA: 85414739718.15.6D0FCBF
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3E243180006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:23:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ok0mOKSw;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794208997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6nDA8hzg87sYDX5sQcrthKtLXR/A+PBINKpoUvqpz8=;
	b=nxiz+Q0yBMP+JvxDkJ50ms2wpyIYXgn7L2W/JgXK7beSze7FHn2Q5aPZ680kIuKv1OdBC6
	0G2vLZXPDZqqfFacJk/BndFb/JLbgWEZktsK9r7WlrKVZjDizJyzAYZqK9ywJ5L+8pWnOq
	Qe/zhoFEAuvUbll7aVZGa23X78TD+Hg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ok0mOKSw;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794208997;
	b=jf0zUgrRqVX76hjkvvWp+AOd8gt0/gnDP2Kgc0lKPDq++qLpcGXKRbob2ERui0D8M1NLfi
	wo5yGWtzGVWjSn6LOpmOtM3Ye2aFBYwGBzoMftiQG4VfFcYkNRYyiRC60HzJxCKk32rjdg
	0oYKFjyiBGKKMN75gcuLzO9ZMIywCuA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=O6nDA8hzg87sYDX5sQcrthKtLXR/A+PBINKpoUvqpz8=;
	b=Ok0mOKSwR8Cru3XfkK6zIROH0UcJUWt2w63KV1+GT1p8Aql2wB3s0k3EBzi+9ZEqvW6gwtPWe
	N1Cs1gQY8CEP5fufrfhbGJ1M2I/a1oEDi9bRw/TWbTNbIEUvvvURddISwnIZn5JbcY8bdQC0Zbl
	qGOKr9ALMtYumQucHjMX1lE=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jNLpg5r5XzLlSJ;
	Mon,  9 Nov 2026 15:22:51 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id B2D434055B;
	Mon,  9 Nov 2026 15:23:05 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 15:23:04 +0800
Subject: Re: [PATCH v3] mm/memory-failure: set PG_hwpoison of a non-hugetlb
 page under hugetlb_lock
To: <mt4022@columbia.edu>
CC: David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Matthew Wilcox
	<willy@infradead.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<tz2294@columbia.edu>, <stable@vger.kernel.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>
References: <20261106-hwpoison-hugetlb-ro-v3-1-c11186963647@columbia.edu>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <42a60f57-5323-f981-8ef3-2e5d67623902@huawei.com>
Date: Mon, 9 Nov 2026 15:23:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261106-hwpoison-hugetlb-ro-v3-1-c11186963647@columbia.edu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3E243180006
X-Spam-Status: No, score=-24.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 75mbbwgbgyici6doqq63c76izfxfejwz
X-HE-Tag: 1794208994-93877
X-HE-Meta: U2FsdGVkX1+kNLPy+J0wj/WUzJfn0j2G5MUfYY1E3fV6BU9Xv1Cmeap5j8m2ek2+zxiaOBWhDYORqRC9posQToA1V6O5jfICbGzhk1UHCcj8SiRW3GWmCyzlLslEVHaEEaAeKobWyt7aqJMz3xCGK1C1uYAnmQ/TmXb72K+aQ493eFBdpHWjVfJ+kLVtItcMQ3pvPR+9hcUNtylTEaztXt4Pp5tkYakGaL5JRX0tjkC+yc45f/g+WvZ+ltejZWuhNy3c3Rhriacp1Dr5GEmSGLkLGqpP1rsvxuJo1gRcLwxYeDnVDbXQp34TWZZxNw7fe/VzYQ1BpRnBXfh2sMVoeBgDKjmFkJhuLHdf+7qUwX/HR9kIdhn4V8TW4Hb4i4ahj+KZfxcrJpjdMT2XsQiXLqoSMLquOKp6maxSmNpSH70sAOFb+mchWHG25RWh2iWwoV51BWUL4lVJ1YokYpJ4qFwy1fsTLqhTp0yTN7ZcKTGfOrMa+bWVxRVu+HntZRoWy+YdB2NBMUxmY/aD/BCofTXmK0B2dE4DlcngiRq2GvY4q7lY0+TgGiM+qIeB5UtE6+7dNYi3CY3znX1keCANW//37IwKfbhk1CsjDzR0zDHabnisB08iGQREw3HRpknS4f9NbGEo2MyixIQxXu/ycdTggyKDVOiYKwpuhB09kuv2E7JLoFT9NBBaGggrfxedyYOM8Sl6prmPmfulk1TEM221G/txMFTrNFa4sq13h+JcKkWZGG6G15ox09jxohvTp7VBz13giMsX92fMrG8ZBxMFpXtG2E7rjwCaG7R/i8xDuUjuTzbmGO+MPE6asM0gQ+2+sDxxmtH86vWvR6ub6rRTKMXfnQebhvtZOl5z8tNMzWYrnh0mlx5+t2Mr4IoaX0Dru2W11YeyVqhvK9c1pcWFp3xd642Elzmi+EmT7NuUgyL8pcT11j23dD9XxPWQcpMOjrdUy3qMHLCZ2AO
 +DPx2wYi
 J+FtQ7QvmwzNJaJDpK0u5YQvqUL9kFTlWJD/Io9pqEp61a0q+nuo1X4HD8xjPxJbvAw1ZdY7+nRrcCJutGIiEUWnki/isvfXKmdKZQTcYSBTzTIN7p/8075gL9n2MLCh7vu7NHJs6cViF6Hwvqm5iIC5t7SaVnsQ3PzBkEBn+aTi9GTyi+IyvvXZkIIGn8aPwOzwL9zGstCEL+/FnN2YaVQPxyAsVeU4Yghjv1skcTGz51UF+cRyM1zdNzNbFVC10Ve9YvGQKph4av+km4eLj1PDd6OlhRqHY7j2+b6bB+jMnYblXO7rHQveJPwuuebBh9gdOoeEOwxcfDMRHwzwcBqWRk0U2PVg4/FhBF/G+cmZ709ipL4d8iePk8k7lXoyi2seJGl5fKGnSOSSZpNPw/khZmpQJ9FCMkgWJRyEPNCH5g0krCQNRm33477lyDuvE7ljMDndLTOYvol27f8aFaFpZlRoyh6obF903sKm/wjHgaPL1WmbXfqEvNHLn6bSUFGVVpAk3NurqLrG3yZNf/F6JRsqiqHqvN1MDJw2gxrO+uPuxS0av6UuDIABBJqRyHJgbdYKvGePBecqiqcoWE2Zd/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/7 0:09, Mani Tofigh via B4 Relay wrote:
> From: Mani Tofigh <mt4022@columbia.edu>
> 

Thanks for your patch. Some questions below.

> memory_failure() checks under hugetlb_lock that the page isn't part of
> a hugetlb folio and sets PG_hwpoison only after dropping the lock.  The
> page can become a tail page of a new hugetlb folio in the meantime.
> With hugetlb_free_vmemmap=on its struct page then lives in the tail
> page that all such folios in the zone share, so the flag lands on tail
> pages of every one of them:
> 
>   Task A (memory_failure)              Task B (nr_hugepages write)
>   get_huge_page_for_hwpoison()
>     /* P not hugetlb */
>                                        alloc_fresh_hugetlb_folio()
>                                          /* P becomes a tail page */
>                                          hugetlb_vmemmap_optimize_folio()
>                                            /* P's struct page now in
>                                               the shared tail page */
>   TestSetPageHWPoison(P)
> 
> The error on P itself is ignored, while healthy pages of other folios

I have no idea why the error on P itself is ignored, could you explain that?

> stay marked and are never reused once their folio is freed.  After
> freeing the pool, /proc/kpageflags shows them as hwpoisoned.
> 
> This is the allocation side of the race that commit 32c877191e02
> ("hugetlb: do not clear hugetlb dtor until allocating vmemmap") fixed
> for freeing.
> 
> Set the hugetlb flag of a new folio under hugetlb_lock and set
> PG_hwpoison of a non-hugetlb page inside the locked check, so that the
> vmemmap can't be optimized in between.  The retry path clears it under
> the same lock, unless the page has become part of a hugetlb folio in
> the meantime and its struct page isn't in the first vmemmap page of the
> folio, which HVO doesn't share.  The retry then knows the flag is its
> own.  With the fix, no healthy page gets marked anymore.
> 
> This bug was identified and confirmed with the help of a deterministic
> hypervisor currently under development.  The C reproducer below however
> hits it within about 35s.
> 
> Fixes: f41f2ed43ca5 ("mm: hugetlb: free the vmemmap pages associated with each HugeTLB page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
> Changes in v3:
> - Keep the flag only for a page beyond the first vmemmap page of the
>   folio, and fix the comment that said a head page is never remapped
>   (Sashiko)
> - Don't take a flag kept by the retry path for an earlier error (Sashiko)
> - Rebase onto current mm-new
> - Link to v2: https://patch.msgid.link/20261103-hwpoison-hugetlb-ro-v2-1-43876fc9eef1@columbia.edu
> 
> Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/hugetlbro.c
> ---
>  mm/hugetlb.c        |  3 +++
>  mm/memory-failure.c | 47 ++++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 43 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4eb7a8c1f7f6..da4ae43de9f7 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1792,7 +1792,10 @@ static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
>  
>  void init_new_hugetlb_folio(struct folio *folio)
>  {
> +	/* Pairs with get_huge_page_for_hwpoison(), see there. */
> +	spin_lock_irq(&hugetlb_lock);
>  	__folio_set_hugetlb(folio);
> +	spin_unlock_irq(&hugetlb_lock);
>  	INIT_LIST_HEAD(&folio->lru);
>  	hugetlb_set_folio_subpool(folio, NULL);
>  	set_hugetlb_cgroup(folio, NULL);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 78f0a13349cb..9795f07b26f5 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -61,6 +61,7 @@
>  #include <linux/pagewalk.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/sysctl.h>
> +#include <linux/vmemmap-optimization.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/memory-failure.h>
> @@ -1957,6 +1958,7 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
>  #define	MF_HUGETLB_FOLIO_PRE_POISONED	3	/* folio already poisoned */
>  #define	MF_HUGETLB_PAGE_PRE_POISONED	4	/* exact page already poisoned */
>  #define	MF_HUGETLB_RETRY		5	/* hugepage is busy, retry */
> +#define	MF_HUGETLB_NON_HUGEPAGE_POISONED	6	/* not a hugepage, already poisoned */
>  /*
>   * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
>   * to keep track of the poisoned pages.
> @@ -2041,7 +2043,11 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>  	spin_lock_irq(&hugetlb_lock);
>  	folio = page_folio(page);
>  	if (!folio_test_hugetlb(folio)) {
> -		ret = MF_HUGETLB_NON_HUGEPAGE;
> +		/* Mark it before it can become part of a new hugetlb folio. */
> +		if (TestSetPageHWPoison(page))
> +			ret = MF_HUGETLB_NON_HUGEPAGE_POISONED;
> +		else
> +			ret = MF_HUGETLB_NON_HUGEPAGE;
>  		goto out_unlock;
>  	} else if (flags & MF_COUNT_INCREASED) {
>  		ret = MF_HUGETLB_IN_USED;
> @@ -2092,7 +2098,8 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>   * PageHWPoison) should be done in single hugetlb_lock range.
>   * Returns:
>   *	0		- recovered
> - *	-ENOENT		- no hugetlb page
> + *	-ENOENT		- no hugetlb page, now marked hwpoison
> + *	-EEXIST		- no hugetlb page, already marked hwpoison
>   *	-EBUSY		- not recovered
>   *	-EOPNOTSUPP	- hwpoison_filter'ed
>   *	-EHWPOISON	- folio or exact page already poisoned
> @@ -2111,6 +2118,8 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
>  	switch (res) {
>  	case MF_HUGETLB_NON_HUGEPAGE:	/* fallback to normal page handling */
>  		return -ENOENT;
> +	case MF_HUGETLB_NON_HUGEPAGE_POISONED:
> +		return -EEXIST;
>  	case MF_HUGETLB_RETRY:
>  		if (!(flags & MF_NO_RETRY)) {
>  			flags |= MF_NO_RETRY;
> @@ -2170,10 +2179,32 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
>  	return identify_page_state(pfn, p, page_flags);
>  }
>  
> +/*
> + * If the page has become part of a hugetlb folio in the meantime, HVO may
> + * remap its struct page unless it is in the first vmemmap page of the
> + * folio.  Keep the flag then, since the retry takes it as its own.
> + */
> +static void clear_non_hugetlb_hwpoison(struct page *page)
> +{
> +	struct folio *folio;
> +
> +	spin_lock_irq(&hugetlb_lock);
> +	folio = page_folio(page);
> +	if (!folio_test_hugetlb(folio) ||
> +	    folio_page_idx(folio, page) < VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES)

I think we should clear the PageHWPoison flag we just set since the retry path expects
we have cleared the PageHWPoison flag in the first round.

> +		ClearPageHWPoison(page);
> +	spin_unlock_irq(&hugetlb_lock);
> +}
> +
>  #else
>  static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags)
>  {
> -	return -ENOENT;
> +	return TestSetPageHWPoison(pfn_to_page(pfn)) ? -EEXIST : -ENOENT;
> +}
> +
> +static inline void clear_non_hugetlb_hwpoison(struct page *page)
> +{
> +	ClearPageHWPoison(page);
>  }
>  
>  static inline unsigned long folio_free_raw_hwp(struct folio *folio, bool flag)
> @@ -2451,12 +2482,14 @@ int memory_failure(unsigned long pfn, int flags)
>  try_again:
>  	res = try_memory_failure_hugetlb(pfn, flags);
>  	/*
> -	 * -ENOENT means the page we found is not hugetlb, so proceed with normal page handling
> +	 * -ENOENT and -EEXIST mean the page is not hugetlb and is now marked
> +	 * hwpoison, so proceed with normal page handling.
>  	 */
> -	if (res != -ENOENT)
> +	if (res != -ENOENT && res != -EEXIST)
>  		goto unlock_mutex;
>  
> -	if (TestSetPageHWPoison(p)) {
> +	/* On the retry, the flag may still be set from the first try. */
> +	if (res == -EEXIST && retry) {
>  		res = -EHWPOISON;
>  		if (flags & MF_ACTION_REQUIRED)
>  			res = kill_accessing_process(current, pfn, flags);
> @@ -2487,7 +2520,7 @@ int memory_failure(unsigned long pfn, int flags)
>  			} else {
>  				/* We lost the race, try again */
>  				if (retry) {
> -					ClearPageHWPoison(p);
> +					clear_non_hugetlb_hwpoison(p);

I suspect this won’t solve the problem. The below race might still exist:

  Task A (memory_failure)              Task B (nr_hugepages write)
  get_huge_page_for_hwpoison()         alloc_fresh_hugetlb_folio()
    /* P not hugetlb */                  /* P becomes a tail page */
  clear_non_hugetlb_hwpoison
  goto retry
  get_huge_page_for_hwpoison()
    /* P not hugetlb */
					 __folio_set_hugetlb
                                         hugetlb_vmemmap_optimize_folio()
                                           /* P's struct page now in
                                              the shared tail page */
  TestSetPageHWPoison(P)

Or am I miss something?

Thanks.
.

