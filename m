Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10312606A338
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fiRcdJU3
Received: by kanga.kvack.org (Postfix)
	id 143AF6B05B0; Mon,  9 Nov 2026 09:43:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B066B05B1; Mon,  9 Nov 2026 09:43:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CFD6B05B3; Mon,  9 Nov 2026 09:43:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA5496B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:43:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 629E51606A5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:43:13 +0000 (UTC)
X-FDA: 85415848266.03.78945FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A3BCB100006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:43:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fiRcdJU3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794235391;
	b=JwKicGnj7HqZI7/snxKD59fmB9QjhA8ZCsJrh6+GTdj28lUfOB4tj/XYm3ShL+GDq7UCGI
	qZrAfblFX6jrCd+HCyR8/HBl3Qqux3xRcLc00CJuggglf3H9eY3B5xQHD46OTSSVNte6Bm
	B8OMfnMHZZQbMyYjFTvjXWYoijuHxyI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794235391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xp9qI2Ok6sylEAN+gwDtNeJcQqJMD2By0aR3Vam4ic=;
	b=tfzcKD8Xn9IlZxVE1JqLXuXnY+qkX8k48/PTafMwMj/QzLUoy0XfVnARdZG9Znv9JH1lnS
	CQ1rZF5Tj5yuDcH/jLe/rwq8XY1l7Oro8jFR6qVYuHduaTde3o2C2Ezac3hExIrLKA43I6
	tPkqtILArrAgCxzAWt0KJt//4CtmFyY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fiRcdJU3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27D386120C;
	Mon,  9 Nov 2026 14:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71801F0089F;
	Mon,  9 Nov 2026 14:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794235390;
	bh=8xp9qI2Ok6sylEAN+gwDtNeJcQqJMD2By0aR3Vam4ic=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fiRcdJU3ll1oX0GL0kFkxzsBFsMHgUWajfOKORb5n5LGR0Ijd/a/ZTZV+msRt+7AE
	 izmHSZ0aw7NmYNXW2GLtEsOVZAVfpyTgNpWMg0tnkNJIiyc5/KCWAsOooJ2agALkvo
	 xMx1r2vihgzi5AJitWcAdZVUonHMXvaKgl9UVq27SVx9gYsvdThm6KBH+43D8zNpIr
	 FMQ7SsNDb6DxIz8AlwOC0mr0jutSYBOHsbEGL+VL9IRKLrnSaOy3QQQC3fefk2V1Bc
	 NeugOO2gVdweOhasQ4WB+Fp70fov7x2MciIpscO2WdjUB0pXFmsgdSIiWUkB+DBpqF
	 g6u1UllN9MC0w==
Message-ID: <aa2a1e32-9b1d-4545-b2e0-03d213593023@kernel.org>
Date: Mon, 9 Nov 2026 15:42:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/18] mm: free PG_rcu_free folios only after an
 RCU grace period
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Harry Yoo <harry@kernel.org>,
 Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador
 <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 "Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Luis Chamberlain <mcgrof@kernel.org>,
 Ilya Gladyshev <ilya.gladyshev@linux.dev>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 kernel-team@meta.com
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-2-kas@kernel.org>
 <ecad7b3c-7244-425a-9413-04d49f221057@kernel.org>
 <au2lsbDkyWt-To0C@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <au2lsbDkyWt-To0C@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A3BCB100006
X-Rspamd-Server: rspam12
X-Stat-Signature: ze89onek1wnfnxhfry9i4gghyyw3d98b
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794235391-658329
X-HE-Meta: U2FsdGVkX198ImGXF2xmJCqpP80hi5Rx4etVPbQ3IUuN9nr0YWLGFM7H+0vyiTyb1oml1toW+wll7XGZhq/zHhsXaFSXur8ZSZ8R0wNNmmBfeRlnLqlfWUYDuYRispZc3Zz2jO3hFU4EUGBAWmrtM/9u57TZ8iLG4BTpsXmc3ljnFMNOTr2cM7mNMER7EprsSrz2rPGsCtfOCsos6Ur0IaaiW5fioHcgzNT9X/2QOqEn7aeCl+PhiSSTC0ZxZ2230eJILMQqh8fixMi6eEl8FPdiZS9zYsj6EZIIns+VHsKYU0Ds1XgDGCP1r378GrUORWdV7pkZUGzBRUNyX3bdM0jS/B1uBPYnBsk3JXXfC7BKi6JlgyYDq3atZy2vYRVmMlfRMoXGRRXZ/5cQVyuADHtBB2i4XvGl4e/zk9QUY/LY7h+XsX6MqEVS+WkEXUy4OCtZ9JSt3AD0tkB1cpr5h6rSAit1uwLikx8wRK3nEdjiKYScBWCHDTVpSLxU5YQZZN6sn1Bg3IvOnHhVOOSDVA8TzComhKG8WrU2SK+o6ce7SUSvSq8con+CBPK8pKue6FYeaFw2iL/I+kFvjSljCdQQd1paZhmk3ESvm5BFNKvppKbUrXbbkX4XiyvVErOOmjKKxWDViAw62wNSMiM4Vp7pr2wH0LGShEzKrZ99SJ6QThlP1hM8iYpqywwsJtQ0+RpEIiY80kvZccQk2zJBADFrOFRLha06IcyevC9Up1FIR+3+3Yy5H45bbpq/uyzbDUV/AWmxJpL9bIB5TFaHRBFiGWTz7PYegFYlmjxOQl3/F6MTQvZFdl62gsLTvrIsGN7HcDCd2CTNopLg0+lNzS2nF4NB5sNEfM0ASUmAEvFfN54/NBC413iiaNyR1HUQXW+kWgP70bNBh+8Jj3xoXzOQg8JIpf7hpMiQ/qAV/J3Od3sLebQ43v2eugYy/6VFustk6GviVweYxi0OIsQ
 f4xRTKHM
 PkxTXrHLt63TTfpigAGNFVahGJ3vBR6lRD8m87bEmI7oe+emesMDmyaXM4UO7tmrTtixkwFR+5aPlRJlTf9+ESvsxDC2GOlqSVdK7Yw2xDkQoHs7rDJnHfw4XwOuNaPFPQ05v7tvjT19/jQ2gRXz5wif2NdVXOlkuL8gFQ8EhpKahui+NKK2BHPuCFU9s3VqmMDorSZEBbyLuZc9//N/Nm9zQCmFvb11Y+16KsXudE5zF/7AnEkpDlD931ypJg7o3WcVkAB0z41LeNWPzyTr1kc5gVeh6NcgR4WuIuUiLR/k3VUu7phPDilOBC8tv92EtuTUWVsLn68H0mbNK4mAw0omc5ai8WhUfZkAS3Wi30cEipBUsv5UXcdTEansxnQMacGRvVXOJ5VxwlRmXBqpSbYCyZLj9SbmG4KdUpKcKTW+gobf6RI5rRNw+Ws+YySj2wtSaU/jKsVXAeOLT82PulTJzBVTzHqgZrPFw3a0TvYxrlq3iuzkSMgfHCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 11:23, Kiryl Shutsemau wrote:
> On Thu, Nov 05, 2026 at 09:37:31PM +0100, David Hildenbrand (Arm) wrote:
>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>> index 604c58199acb..6e5341b0bf64 100644
>>> --- a/mm/Kconfig
>>> +++ b/mm/Kconfig
>>> @@ -718,6 +718,21 @@ config PCP_BATCH_SCALE_MAX
>>>  	  latency.  This option sets the upper limit of scale factor to limit
>>>  	  the maximum latency.
>>>  
>>> +config PAGE_RCU_FREE
>>
>> I think we really want to focus this only on folios (like the current code does).
>>
>> FOLIO_RCU_FREE ?
> 
> Sure.
> 
>>> +	def_bool y
>>> +	depends on 64BIT
>>> +	depends on !PREEMPT_RT
>>> +	help
>>> +	  Reads from the page cache can copy from folios that are read
>>> +	  again and again without taking a reference on them, so small
>>> +	  reads of one file from many CPUs do not contend on the folio's
>>> +	  reference count.  The cost is that memory freed from such
>>> +	  folios becomes reusable only after an RCU grace period.
>>
>> While that description is helpful, that's not really what this patch, or rather
>> the basic infrastructure in page_alloc, does.
>>
>> I'd suggest to have a dedicated FOLIO_RCU_FREE config and maybe another one
>> (that selects/depends on) FOLIO_RCU_FREE that actually enables the pagecache use
>> and documents the details.
> 
> I will make the help describe what this patch does.  The page cache is
> the only user, and both symbols would be def_bool without a prompt, so
> I would rather add the second one with a second user.
> 
> Does that work for you?
> 
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 1e5d68acf62a..25082949a4ca 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3743,6 +3743,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>>  #endif
>>>  				 (1L << PG_dirty) |
>>>  				 (1L << PG_dropbehind) |
>>> +				 __PG_RCU_FREE |
>>
>> That looks a bit odd at first, as it's very different to the other once. But no
>> easy way around assuming that the flag is not always around.
>>
>> Maybe we should just have this be a const mask constructed somewhere using BIT()
>> and __PG_RCU_FREE etc, instead of having this growing list in this user here.
> 
> Makes sense.  Something like the diff below, on top of this patch.
> Introducing split_copy_flags would be a preparatory patch, and this one
> would only add __PG_RCU_FREE to it.
> 
>>> @@ -1327,6 +1417,19 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>>>  
>>>  	VM_BUG_ON_PAGE(PageTail(page), page);
>>>  
>>> +	/*
>>> +	 * Not for a hwpoisoned order-0 page: it never reaches the allocator,
>>> +	 * and page_handle_poison() takes a reference right after this free.
>>> +	 */
>>> +	if (unlikely(folio_test_rcu_free(folio)) &&
>>> +	    !(PageHWPoison(page) && !order)) {
>>> +		VM_WARN_ON_ONCE(fpi_flags & FPI_NOLOCK);
>>> +		__folio_clear_rcu_free(folio);
>>> +		count_vm_events(PGFREE_RCU, 1 << order);
>>> +		rcu_free_defer(folio);
>>> +		return false;
>>> +	}
>> I'm wondering whether we want to intercept on the folio freeing path instead?
>> That would be __folio_put(), before we go into free_frozen_pages() used by other
>> machinery that does not apply (slab etc).
> 
> Not all page cache folios are freed through __folio_put().  Reclaim
> frees them with free_unref_folios() directly (shrink_folio_list(),
> move_folios_to_lru()), and so do folios_put_refs() and the LRU batches.
> __free_pages_prepare() is the one place they all pass.

Can we just rework that code first to have some clear folio freeing path, IOW
doing this in a folio-specific helper?

folios_put_refs() is just a specialized and batched variant of the __folio_put()
freeing path in the end. So we can hook into these two easily.

For free_unref_folios() would need another hook or a cleaner rework.


> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index a1e52a1f8a52..6d4e534c9ccc 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -1185,6 +1185,18 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
>  #define __PG_MLOCKED		0
>  #endif
>  
> +#ifdef CONFIG_ARCH_USES_PG_ARCH_2
> +#define __PG_ARCH_2		BIT(PG_arch_2)
> +#else
> +#define __PG_ARCH_2		0
> +#endif
> +
> +#ifdef CONFIG_ARCH_USES_PG_ARCH_3
> +#define __PG_ARCH_3		BIT(PG_arch_3)
> +#else
> +#define __PG_ARCH_3		0
> +#endif
> +
>  /*
>   * Flags checked when a page is freed.  Pages being freed should not have
>   * these flags set.  If they are, there is a problem.
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 25082949a4ca..44a1aaa3f834 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3689,6 +3689,23 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  	const bool handle_hwpoison = folio_test_has_hwpoisoned(folio) && new_order;
>  	long new_nr_pages = 1 << new_order;
>  	long nr_pages = 1 << old_order;
> +	const unsigned long split_copy_flags =
> +		BIT(PG_referenced) |
> +		BIT(PG_swapbacked) |
> +		BIT(PG_swapcache) |
> +		__PG_MLOCKED |
> +		BIT(PG_uptodate) |
> +		BIT(PG_active) |
> +		BIT(PG_workingset) |
> +		BIT(PG_locked) |
> +		BIT(PG_unevictable) |
> +		__PG_ARCH_2 |
> +		__PG_ARCH_3 |
> +		BIT(PG_dirty) |
> +		BIT(PG_dropbehind) |
> +		__PG_RCU_FREE |
> +		LRU_GEN_MASK |
> +		LRU_REFS_MASK;


I was rather thinking of a


#define FOLIO_SPLIT_FLAGS	BIT(PG_referenced) | BIT(PG_swapbacked) | \

...

To make this function actually shorter :)

(ofc, you could also have a static const unsigned long, if that's what we want)

-- 
Cheers,

David

