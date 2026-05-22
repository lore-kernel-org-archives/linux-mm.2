Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE564CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 09:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DB606B0093; Fri, 22 May 2026 05:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384B56B0095; Fri, 22 May 2026 05:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 273876B0096; Fri, 22 May 2026 05:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14CBB6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:22:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7B79140795
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:21:59 +0000 (UTC)
X-FDA: 84794513958.01.98DFADA
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf04.hostedemail.com (Postfix) with ESMTP id 149CE4000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:21:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TxJNTDkd;
	spf=pass (imf04.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779441717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7xGK62mRDtxiOSxUrHZC18KBCBUyKRrfRPKIIO/WHk=;
	b=EvfKaGAaGkJVgs0MbGhREkzytluyRVVlcDtGoWSwQ62+fAX5Z5o3enmkI3MULAa6sOStQO
	Pe4A3EhsDJHeGyfhUZ9+f8oJ7vHAEdFqAgVmWauGhG9SIMDKfL5vImoufyU1ioJz46aXPi
	88KpQ2RPvyVYmTMlnwk2m1AQh7d6btc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TxJNTDkd;
	spf=pass (imf04.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779441717; a=rsa-sha256;
	cv=none;
	b=V0IRafdMuWlXuCChPllCtGIGE8dye5xRwRHVx0s28h461ZsNED7SZcVpd7bfySwVVQY7QI
	j8IE2dhI2RbQeBTF3Zsq+CLocPlkwvq5phOxY+mYvImZkhV6RoMVfvFMfidtVAJhrGCsWd
	Knj1hrYt6GULXVuuI9VMMlU8OUXRGBQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=K7xGK62mRDtxiOSxUrHZC18KBCBUyKRrfRPKIIO/WHk=;
	b=TxJNTDkdY8hFEDKVpQYBuvrlxmE5XCXPZ7K3wxWRAJUlswsJZTspV3lVVJjvJHxa9ZM/WbgB4
	Lc8kvXPdciuUFpnXb3pQYvGxTGy3EtZ9MasLt0hlvmzfgWgtovqYFgIBTuwnogks14xtMUwOpY4
	a5AQkmjiHFKt8Uru+co1sck=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gMKN06dWCzmVXb;
	Fri, 22 May 2026 17:14:08 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id BBBF140565;
	Fri, 22 May 2026 17:21:52 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 May 2026 17:21:52 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 May 2026 17:21:51 +0800
Subject: Re: [PATCH resend] mm/memory-failure: fix hugetlb_lock AA deadlock in
 get_huge_page_for_hwpoison
To: Wupeng Ma <mawupeng1@huawei.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
	<akpm@linux-foundation.org>, <ljs@kernel.org>, <Liam.Howlett@oracle.com>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <nao.horiguchi@gmail.com>
References: <20260522010305.4099834-1-mawupeng1@huawei.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f39f405e-4b4b-8f79-70fe-a2b5b62114eb@huawei.com>
Date: Fri, 22 May 2026 17:21:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260522010305.4099834-1-mawupeng1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 149CE4000D
X-Rspam-User: 
X-Stat-Signature: bs5a9m6scyztskt1wygqqur1euggx1a3
X-HE-Tag: 1779441716-951315
X-HE-Meta: U2FsdGVkX19N+1AAmwfpvbxjF/4oO13ymvdaDiGpvFzDOQL36QjZM7SKrt1MzlW6hlCZpPkA18OAy2H1FrnITRpYQyp/0a9T1vGtNVfGiW5lGOlnhczf/BclzGpI9MXO4aClMwTe5ltdsFtUUgNxleUdVwQApi1ShNSqykFnEjbwj0Mk1Cy45oYBVsfJB8+5GpMFl8qE8DRO+1A3p8GZwuIxoYwiFpNJurZSc+XhRG+36JxKf1PJ3kMvRgHCdq/8pTKFNRT1M50MrR+8und5Oq2sUP+BTFBgVIPVFKuVlDXzscHhkshe1+tLpWFvBA1/bPKpJIxwpwG4ir/2EwHPzaRvTXGErxxNwnYHxidllZYhP3OArhRuukCOTDKkz26LlsO2orlGoKS52O9Ut2mFivpQFYrWJCwEneYC1uaA5sdhT3IL+YuIrZuQqGeS1rM9Asc7yGP3+fV4ttocV8YInmUaP1Xc5GZwhhkZ/nUjJf0rCWSekBwlfAYK6SOL1OGGWvN81arEH7rft/P9+cMSy42sF8EwlPp9eSkhC/RCN3D87yWC3noWQ8bw1eCeBaAue8+cMaiSmnTg06hnsWIsU4OoLcVhaxeCJQrpG9U8csUXNr+n/uLcBaGcfGbvl+uDdAUOynSGDICVAJ/h3j6NX+QP0LgplU2x/ZIxYJVRRzJJ/o6EHklJgsFVb5FjRD/8FLsdhWkGOCij4adrVhJs+lJU7THlt07YAkwKmy9T4miVgGGxLOdARWxL/hJOCGtGOEdIOVK7cC89YPs94/84RwEjFLa+gIquJ3JByWeR+rTPkVFyHcb4fdyc3Myadmlz6i8ChxcuXNPEy5mTw3c9K9YKjQI2+IUUfcqGPSeSkQ9GEabXLKEjZ4YjGXCorr2dkHbERYm00xtAhck/VZ/HofI0hZVAMQvFAQUkGQOQsWZnegIrc3iqnt+eJimwufUk54IutKGgEJAdTIEq6GM
 Uaa+H1x+
 45Ie3c0WGv7JaHgMpAFsF0b1SR0X8VddL6vm3CnTTe/ST69m4r51YaA2TRGWMB+GMjirvTXk6tNwrwpaFWBoWgiPHMZXI/McEHUIfPpF3tRPurW5vtjVLsBmOhI5mhbB2EqOjB08uaDctCEwNaPdB0YsUjME/39RWsZFQgi8oC6jKRCLOh03+mGk4AI98ILBAKA6PXmySDxI3qd3Y0xZ+t7UK2qW4EywqjHIOLZtoOfwy9bWCM/8H3LCXwlUhNJnUhhf9s/5fUXMDW3bZNLdA3Jvzee1/c+MX+wytVVPCRp6sYvlFC158iwO7Vlszi9mLtEaYSCDGPSg0KVBidXo5OoXnhBCRcgDmeKVlzKrpTGhP+i76MjeH/4L9qwXvkq2hinhtwYI/C4Lgr1Fcv9PHzywYPqsMeOquldoNhWbpQj27SQpWfWx13+4HmecCbJW1VHbYr87/QMy1RTlNembQdU8Ud+K8twYPPvUj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/22 9:03, Wupeng Ma wrote:
> Two concurrent madvise(MADV_HWPOISON) calls on the same hugetlb page
> can trigger a recursive spinlock self-deadlock (AA deadlock) on
> hugetlb_lock when racing with a concurrent unmap:
> 
>   thread#0                              thread#1
>   --------                              --------
>   madvise(folio, MADV_HWPOISON)
>     -> poisons the folio successfully
>   madvise(folio, MADV_HWPOISON)         unmap(folio)
>     try_memory_failure_hugetlb
>       get_huge_page_for_hwpoison
>         spin_lock_irq(&hugetlb_lock)    <- held
>         __get_huge_page_for_hwpoison
>           hugetlb_update_hwpoison()
>             -> MF_HUGETLB_FOLIO_PRE_POISONED
>           goto out:
>             folio_put()
>               refcount: 1 -> 0
>               free_huge_folio()
>                 spin_lock_irqsave(&hugetlb_lock)
>                   -> AA DEADLOCK!
> 
> The out: path in __get_huge_page_for_hwpoison() calls folio_put() to
> drop the GUP reference while the hugetlb_lock is still held by the
> hugetlb.c wrapper get_huge_page_for_hwpoison().  If concurrent unmap
> has released the page table mapping reference, folio_put() drops the
> folio refcount to zero, triggering free_huge_folio() which attempts
> to re-acquire the non-recursive hugetlb_lock.
> 
> Fix this by moving hugetlb_lock acquisition from the hugetlb.c wrapper
> into get_huge_page_for_hwpoison().  Place spin_unlock_irq() before the
> folio_put() at the out: label so the folio is always released outside
> the lock.
> 
> Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
> Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>

Thanks for your patch.

> ---
> Changelog since v3[1]:
>  - update commit message to fit current issue  
> 
> [1]: https://lore.kernel.org/linux-mm/20260520020128.3506168-1-mawupeng1@huawei.com/ 
> ---
>  include/linux/hugetlb.h |  8 --------
>  include/linux/mm.h      |  8 --------
>  mm/hugetlb.c            | 11 -----------
>  mm/memory-failure.c     |  8 ++++----
>  4 files changed, 4 insertions(+), 31 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 93418625d3c5..059749ed519f 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -153,8 +153,6 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
>  						long freed);
>  bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
>  int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
> -int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -				bool *migratable_cleared);
>  void folio_putback_hugetlb(struct folio *folio);
>  void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
>  void hugetlb_fix_reserve_counts(struct inode *inode);
> @@ -422,12 +420,6 @@ static inline int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb,
>  	return 0;
>  }
> 
> -static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -					bool *migratable_cleared)
> -{
> -	return 0;
> -}
> -
>  static inline void folio_putback_hugetlb(struct folio *folio)
>  {
>  }
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0b776907152e..4c4d1a61a6a7 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4975,8 +4975,6 @@ extern int soft_offline_page(unsigned long pfn, int flags);
>   */
>  extern const struct attribute_group memory_failure_attr_group;
>  extern void memory_failure_queue(unsigned long pfn, int flags);
> -extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -					bool *migratable_cleared);
>  void num_poisoned_pages_inc(unsigned long pfn);
>  void num_poisoned_pages_sub(unsigned long pfn, long i);
>  #else
> @@ -4984,12 +4982,6 @@ static inline void memory_failure_queue(unsigned long pfn, int flags)
>  {
>  }
> 
> -static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -					bool *migratable_cleared)
> -{
> -	return 0;
> -}
> -
>  static inline void num_poisoned_pages_inc(unsigned long pfn)
>  {
>  }
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f24bf49be047..67243923fa24 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -7154,17 +7154,6 @@ int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison
>  	return ret;
>  }
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
>  /**
>   * folio_putback_hugetlb - unisolate a hugetlb folio
>   * @folio: the isolated hugetlb folio
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index ee42d4361309..28522180cf7f 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1966,10 +1966,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
>  	folio_free_raw_hwp(folio, true);
>  }
> 
> -/*
> - * Called from hugetlb code with hugetlb_lock held.
> - */
> -int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> +static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>  				 bool *migratable_cleared)
>  {
>  	struct page *page = pfn_to_page(pfn);
> @@ -1977,6 +1974,7 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>  	bool count_increased = false;
>  	int ret, rc;
> 
> +	spin_lock_irq(&hugetlb_lock);
>  	if (!folio_test_hugetlb(folio)) {
>  		ret = MF_HUGETLB_NON_HUGEPAGE;
>  		goto out;
> @@ -2013,8 +2011,10 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>  		*migratable_cleared = true;
>  	}
> 
> +	spin_unlock_irq(&hugetlb_lock);
>  	return ret;
>  out:

It might be better to rename out: as out_unlock. But that's trivial.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

