Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A51CECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 02:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33986B0005; Tue, 19 May 2026 22:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4446B0088; Tue, 19 May 2026 22:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD3406B008A; Tue, 19 May 2026 22:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 981076B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:40:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1EDF714062C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:40:35 +0000 (UTC)
X-FDA: 84786244830.27.AB4D09F
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf05.hostedemail.com (Postfix) with ESMTP id E38A1100006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:40:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WTAaxDc4;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779244833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FaSlZq7+rot967gNRvfkEumv8IhDHP9pWNaSpmceWiI=;
	b=BfwZrzdiWQXg2/+PZ5vLLOuVBkxp6AA5PpcyYDsXn9BaCSwPCnvjfD3+70HARbfIuZEpk1
	GYeAyshD7P6mGsoQTo8ioonct9imrQCT05A27rQ5Adf88Dg+QtCFA4ZxART0VTQs/rHb18
	R3iqguemI0V1ZEJ33MYk/f7iB1VLuIw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779244833; a=rsa-sha256;
	cv=none;
	b=baRlvLeoANm5naG7X0hADMinwHZG31BIhv3WYv4PpjkrClFBv4MYA3tktMIwZVG2L8Qx2M
	n8xwCcAgle1mRk+d/Hj3tqmyKiMWje6y1V5ZrrXb12E5GQ/4/3IABopGoaJrUSLxeAEzB0
	qoe1Nrt8wBqoadD20GMkv0IyIRalQL8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WTAaxDc4;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FaSlZq7+rot967gNRvfkEumv8IhDHP9pWNaSpmceWiI=;
	b=WTAaxDc4eokgnuVAhzn6gLrz6PgN76SppCJNHJTneYy5V2uecBmKnrz1d4f26AG6Q9xTXvP2F
	MNeKRoJB2/Q4pZT+2OebHErmhPR3vOmMRkcqDFBI1t6utrzZliqwX587ca7DXiXvyiui42KMmd/
	dK/q3JDXmaZ5kLCmstlronE=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gKwZW1T2Yz12LfK;
	Wed, 20 May 2026 10:33:23 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 689A64056B;
	Wed, 20 May 2026 10:40:24 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 20 May 2026 10:40:22 +0800
Message-ID: <07873271-6671-4092-becb-7b2cef4217a1@huawei.com>
Date: Wed, 20 May 2026 10:40:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory-failure: fix hugetlb_lock AA deadlock in
 get_huge_page_for_hwpoison
To: Wupeng Ma <mawupeng1@huawei.com>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>,
	<ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <mike.kravetz@oracle.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20260520020128.3506168-1-mawupeng1@huawei.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260520020128.3506168-1-mawupeng1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E38A1100006
X-Stat-Signature: thnaaf9k7zguar3qjiqtr7w6tjq7rz8j
X-Rspam-User: 
X-HE-Tag: 1779244831-414060
X-HE-Meta: U2FsdGVkX1/W0XsdJsExDLw6DQB+Udfmv13junOPdIQa8Ki1LnLZS0SlMnZ7QXToSzd7C0e23SieUTggExu+C04aPAltNWIMQdyvZsUN+S/Jf7gFDdvxoidLl0G0Pcx0HSaP4uu1REf3fdsonM3ZWJJD17qSty1vOZuVt2DZpPL/qdmaOmE+8/XhLoeH0XBa+SmhBTVAHpktWf9sdEW1Dink+PJvXJwayfJwaozuHdimG5vjHn4asYtqrtmWwWdXidRVh9s9XQsH6OtmOIrXdrEFZ8VRkG/Rb2qs1v4c4xnXUGaJhl3nt7FAchl6BsATnh1P5wL43mep1bFTryDBVOjO7sEHeEkuEG+yWKT8ILOxqQ5Kl057wyCEN51TL41tpiEkaTGpodf7Lp1T0aN6JZsx+NFsdCKcI3eXZ29Unal+sTIRWj2+LktTqgyxXhfmxgg1vvpMxYI+Ie4V4LGR9/6ufAcbwAwGwKOJln0nTxFtFwOA16bdjQ1ZchYUlByLh9oPne4cuOz7/kPgZYgm9nKt+8+SRz/4aD8HAh16I3dj85W52vXxahC6w6LJkeMn3bebkBR4Vbrrh7P2ldlfh4sYUkmaVq59/f+agUx7Nx3H2gQ7HixsbMcnaDpCXcKxfuxQUsYw9V6IEjJcZfF+CZVQ7kwdqrUL+tc1dtc2zIYx0iEgVXIb0m7DFsAlzp9jmLGwpHErH4gLzvb81T8wkmof248pNMjZhTep7PE8CDHlrMXES3tDGclfoalKh4SFeDOVyl0eZTboTNNZplIoINbO2Vg6zaL2qbnfFuGf8vONcce5I+yyuuioadc7KlOvH+D0AFQcR9MpMMOYZPaUyi5DuyCWc8ITTDJg/I/+esN7q3zlzaRMMVQty50M8sgghJtwEXKrlIa5giDc8cDn7um4xcaWauPunaM7Iode4Xm0E3nExfWx3e33H5BcPuRQFac3LjQqE55dOiJwlQX
 opor2UdI
 7K3q+BaQLYzPCxvJBKQIwgzq58JJ1xw72J0RkGbNCbZ8aDq2mGidUqfbiLc8BXOXXQeUn9ePe5KeDNoGRKS8dEbmZ2BIaKFqMAzpJO36nssIp/zUXSkFnqC1LodbGSjNSnnkH99ZhR5p3tU61clQHOzdFEMAXV1aZ4zSag7YFtrYMIoguewp5PpFoJ8Dwjanw85234rVx14OQpWdf1RbKwFCq+j9/kyIC0XCjViWEUQXdz+ZkWT3KUn+mY16gi4MgIsqBqkFw2B4/3njvEtQjI2zqoxZ4mm3+IB1joU7CMG4cLRSXenwx23jX6ce9xSGw2aQpc/7wdKov38/Cl1sZeggXK1eOty1h7SIeoddzDt8wnGJfe9ZlHAy/u/ejPF1QWVbWdssM6YEeSs2iO5EnzaCoQjRvWAAsjrBnaD9ez0xM7yL5M4NWycseJHx7HAB2JJBMHOTbGZ0T7WVnyiKmDZn7YD4S+lV58yV27qfJ3DV0cqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

You should remove the v3 since this is the first version for mainline.

On 5/20/2026 10:01 AM, Wupeng Ma wrote:
> madvise(MADV_HWPOISON) can trigger a recursive spinlock self-deadlock
> (AA deadlock) on hugetlb_lock due to a race with concurrent folio
> unmapping.  The race scenario:
> 
>    Thread 1 (madvise MADV_HWPOISON)          Thread 2 (unmap)
>    -------------------------------          -----------------
>    madvise_inject_error()
>      get_user_pages_fast()  <- refcount++
>      memory_failure(MF_COUNT_INCREASED)
>        get_huge_page_for_hwpoison()
>          spin_lock_irq(&hugetlb_lock)
>          // refcount == 2 (gup + map)
>          // MF_COUNT_INCREASED path:
>          count_increased = true
>                                             zap_pte_range()
>                                               page_remove_rmap()
>                                               put_page()  <- drops map ref
>                                               // refcount: 2 -> 1
>          hugetlb_update_hwpoison()
>            -> MF_HUGETLB_FOLIO_PRE_POISONED
>            -> goto out
>          out:
>            folio_put(folio)  <- drops gup ref
>              // refcount: 1 -> 0
>              free_huge_folio()
>                spin_lock_irq(&hugetlb_lock)  <- AA DEADLOCK
> 
> When Thread 2's put_page() drops the mapping reference while Thread 1
> holds hugetlb_lock, the folio refcount drops to 1.  The subsequent
> folio_put() at the out: label frees the folio, and free_huge_folio()
> attempts to re-acquire the non-recursive hugetlb_lock on the same CPU,
> resulting in an AA self-deadlock.
> 
> The same deadlock can also occur on the folio_try_get() path: when a
> migratable folio is found and folio_try_get() succeeds (refcount rises
> to refcount+1), a concurrent unmap and a hugetlb_update_hwpoison()
> returning pre-poisoned status will land at out: where folio_put() again
> may free the folio under hugetlb_lock.
> 
> Fix this by removing the hugetlb_lock wrapper from hugetlb.c and
> moving the lock acquisition directly into get_huge_page_for_hwpoison()
> (formerly __get_huge_page_for_hwpoison) in memory-failure.c.  Place
> spin_unlock_irq() before folio_put() at the out: label so that the
> folio is always released outside the lock, preventing any recursive
> lock acquisition.  


The following comment is not useful and correct for this version.

Remove the now-incorrect "Called from hugetlb code
> with hugetlb_lock held" comment, and update the stale
> __get_huge_page_for_hwpoison declarations in include/linux/mm.h.
> 

The change is lgtm,  Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>


> Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
> Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
> ---
>   include/linux/hugetlb.h |  8 --------
>   include/linux/mm.h      |  8 --------
>   mm/hugetlb.c            | 11 -----------
>   mm/memory-failure.c     |  8 ++++----
>   4 files changed, 4 insertions(+), 31 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 65910437be1ca..aa3eb42e0a01a 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -153,8 +153,6 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
>   						long freed);
>   bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
>   int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
> -int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -				bool *migratable_cleared);
>   void folio_putback_hugetlb(struct folio *folio);
>   void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
>   void hugetlb_fix_reserve_counts(struct inode *inode);
> @@ -422,12 +420,6 @@ static inline int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb,
>   	return 0;
>   }
>   
> -static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -					bool *migratable_cleared)
> -{
> -	return 0;
> -}
> -
>   static inline void folio_putback_hugetlb(struct folio *folio)
>   {
>   }
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index abb4963c1f064..46e5936dabaa8 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4602,8 +4602,6 @@ extern int soft_offline_page(unsigned long pfn, int flags);
>    */
>   extern const struct attribute_group memory_failure_attr_group;
>   extern void memory_failure_queue(unsigned long pfn, int flags);
> -extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -					bool *migratable_cleared);
>   void num_poisoned_pages_inc(unsigned long pfn);
>   void num_poisoned_pages_sub(unsigned long pfn, long i);
>   #else
> @@ -4611,12 +4609,6 @@ static inline void memory_failure_queue(unsigned long pfn, int flags)
>   {
>   }
>   
> -static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -					bool *migratable_cleared)
> -{
> -	return 0;
> -}
> -
>   static inline void num_poisoned_pages_inc(unsigned long pfn)
>   {
>   }
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 327eaa4074d39..4c99bb868ad08 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -7170,17 +7170,6 @@ int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison
>   	return ret;
>   }
>   
> -int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -				bool *migratable_cleared)
> -{
> -	int ret;
> -
> -	spin_lock_irq(&hugetlb_lock);
> -	ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared);
> -	spin_unlock_irq(&hugetlb_lock);
> -	return ret;
> -}
> -
>   /**
>    * folio_putback_hugetlb - unisolate a hugetlb folio
>    * @folio: the isolated hugetlb folio
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index ee42d43613097..28522180cf7f8 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1966,10 +1966,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
>   	folio_free_raw_hwp(folio, true);
>   }
>   
> -/*
> - * Called from hugetlb code with hugetlb_lock held.
> - */
> -int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> +static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>   				 bool *migratable_cleared)
>   {
>   	struct page *page = pfn_to_page(pfn);
> @@ -1977,6 +1974,7 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>   	bool count_increased = false;
>   	int ret, rc;
>   
> +	spin_lock_irq(&hugetlb_lock);
>   	if (!folio_test_hugetlb(folio)) {
>   		ret = MF_HUGETLB_NON_HUGEPAGE;
>   		goto out;
> @@ -2013,8 +2011,10 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>   		*migratable_cleared = true;
>   	}
>   
> +	spin_unlock_irq(&hugetlb_lock);
>   	return ret;
>   out:
> +	spin_unlock_irq(&hugetlb_lock);
>   	if (count_increased)
>   		folio_put(folio);
>   	return ret;


