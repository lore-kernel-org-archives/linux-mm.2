Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6357F606A333
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dbEfWOqF
Received: by kanga.kvack.org (Postfix)
	id 34CE76B05C7; Thu,  5 Nov 2026 15:38:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE0A6B05C9; Thu,  5 Nov 2026 15:38:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CCF16B05C7; Thu,  5 Nov 2026 15:38:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D22916B05C7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:38:02 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52AD080C0D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:38:02 +0000 (UTC)
X-FDA: 85402227204.29.BBA6AFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7BEA91C0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:38:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dbEfWOqF;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793911080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFERB1YnJZQ7J8N8Vjl6e8gBTQxfUW162xiJH7KJiMc=;
	b=f2VqY/2qyUXPCc/DIyWSejSwdVWsx0sVYKA8bY5qKa5zOz2CvX3qzjigPZz/kwKZU2xKge
	h62ap1GAURYUi0XHg7b7KmVBc8VdAeZWVtLyohVmvqJ/+PvxpppSB3BTcgEt3wUNNunynt
	rygBVNJRXg4r1w1UHOiuxWE6R+Z5n3o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dbEfWOqF;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793911080;
	b=6ehV7fIBQDJm6fysV+hL7UdSQLvOtAo34Diot67c/kqPVeF69clYObhwktg4eUNY33u6MC
	rzilz2yC9yVUSANYT/xuZpjEm5liHqEG4C2baRIzB5hf/0UHVEIDMUVF+2RaUYkit8GHV7
	E+0b54xSGUKGLpkV0h1yjFbflSmfSuc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACA4E41E66;
	Thu,  5 Nov 2026 20:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1EF1F0089F;
	Thu,  5 Nov 2026 20:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793911079;
	bh=kFERB1YnJZQ7J8N8Vjl6e8gBTQxfUW162xiJH7KJiMc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dbEfWOqF0nWBxai9vV12XaRkr44G6/iPt+1zOArNFr0MrunrJJ/lPqXPZVPT1Cocu
	 HFOSUAQBJZhMxbfw4qlS9MYOmgsVzPYCPKBmSTM6LUjiVlItsHVRxuzD8L8eC9kz1K
	 dh9QXfyrUO9/jw2rf0X8v2+rfI82HU6ytKwZypzygqtNqm/zad2U268KoihY3zXaCf
	 YFpFYAoCV7ChoSdpQA9FYxGqFfl7KfvZbQ4Q6dByQRDU9SQlNeJM28yWZnuAQFUfsn
	 X7+HLtWy/r/LRn8QEB8OIsw8hR5M20tlFLwVqOol2I73CX+to8jxXEeaSTsPYE5QO4
	 d2CPJowac60Ng==
Message-ID: <ecad7b3c-7244-425a-9413-04d49f221057@kernel.org>
Date: Thu, 5 Nov 2026 21:37:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/18] mm: free PG_rcu_free folios only after an
 RCU grace period
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Harry Yoo <harry@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261104130118.2507513-2-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dmncb5satg1wwqeqx4h6bdkf1grnunoo
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 7BEA91C0006
X-HE-Tag: 1793911080-873133
X-HE-Meta: U2FsdGVkX1+WOnrRSC7lNS1xWu4c5mvQ0aIGdwAmTsIf7YC6izLJ/PbgCULQTXcl7FNtdPVpXshUjQdeZPyVgyYKl7i3ZhTl0lOic+KKIa7XigFLbSz19IxnNmwy8ukWZFegMIm+YRiyu9yH3cp/9O3a6sw3dUhWGfRIF+id+M+ooUO3PuVFr8SIuOq/fmWFuk1NDeTg/YJDWi/3AFY2YDEGiHzQtz+Jr2PFE76x4FWTQ9sJQbw6lq6fbSJrP5M/XQ0N0uLcfVlvCdtBsNEjTfp9eIVAtGj3Fyfz4O1X2yGt4E6X7QzaLA1L9+YSsqZ7cTYkjlD2PoM+IsSdOTyUCQmZwsvhIVi2ugijqtIY7nEHG21KZGrkq4+T0iDypRbyZkItY+qOXtlhfzSPUmgusQZrw03qMy54eEL/2beki/qml9emNKJ2DID0THISuEFMS+ckJny0JrZZiEHwUTWa//10gOj1v/79nHCDNBspT0TRkFIHy5M3NZ1nfyqY9daLefyPt7H7aolqwGKlqW+G2AW4YWzpuN0JHUQDm53akMOttc6TdYlKakXTUyoF1Ny6pyUP76GdjtupaUmWK5efQ4jPE0cg/jekwN8pLsO3jDfeU18GbIG2ErtTmZffiLJsBLpE4wwjUTCebvPHuq+oiiJDtw/n9vcTLualHmXRjK+C3SFQwLVa9uZph5cJGpNA37GvtUB61oNQ60VOfvWID3IK2z5g499jB3Evks0hM1E0AliiPel4rc7S7uYWUP2Iq7CerFv9Tj6qqEO95edpdzTqx9YNXN5gGkJr1TcOvwm7O81Qrv2FhkANiPwFVg1AdqibuqbsGxQ0P1MyK5km4piJ51D0Xa9DGGEmqVpnl4bpUvVGNZ1EiVKjjnMMh6mn9QkLqKvVVuTd31dIaGFck+NpGXKcjjCASr53VuhTQGhAn/t7eRrh09yTEkgpdcWKYAFdGJ15BgTSpeLHE6z
 XWzEvsCf
 ZI7JrOH7ujburwxBvPtWsbOWPuV2l3w9GnKZ64NZGFXf68o5GaQF8em2+KOmT6FscTF7ZBrq9HKy6SMxJm220YTgynMpjICmtO/JzNe9+0T5hH/8WyRP9kxBghbqkTGfg58R1hLSBBDdidm9ia16TqhU/V7XbbPokRqhgiXvwojbIBm/LXCywcWR1q/vybirjWqmIbnr9rzRS8SWmHOuETEE8Utrt0uZ/xRgVihszm+wPxESCjUCPyiFXD9AhY6N+nrOZ7t4pVgOYh7sorlJAZhLdvpd+9HxU9qSfn8mNhw+0s5UyLjDUaaPLpc6DwUSWkmGTjgGHmv3kcg1BNxIfFJoI8JbOuNei1g6PpLcHVpEIjmMB+sKmPh/YdweTEi41AFwwvcdX1ngO0zRUPERZC09SODyApQQHWM17n3+sqxZitXDELCUsMZhstRxWSybE3HaUdMmrCg4iAagnH51GErU8ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 14:00, Kiryl Shutsemau (Meta) wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Reading a page cache folio without taking a reference would keep CPUs
> that read the same file from bouncing its refcount.  But without a
> reference the folio can be freed, and its memory reused, while the
> reader copies from it.
> 
> Add PG_rcu_free: the free of a folio with the flag waits for an RCU
> grace period.  A reader that saw the flag under rcu_read_lock(), and
> then still found the folio where it looked, can read it until
> rcu_read_unlock().  A split copies the flag, as such a reader may still
> be reading the new folios.
> 
> The folios wait on per-CPU lists, one grace period in flight per CPU:
> call_rcu() per folio would queue a callback for every folio of a
> truncated file.  A work, which can reschedule, frees each batch.
> Reclaim depends on these frees, so the workqueue is WQ_MEM_RECLAIM.
> 
> The flag is 64-bit only (CONFIG_PAGE_RCU_FREE): page flags are scarce
> on 32-bit, and the contention this avoids is a problem of large
> machines.  It is off on PREEMPT_RT, where expedited grace periods are
> normal ones, so the waiting pages cannot be freed quickly when memory
> runs short.
> 
> pgfree_rcu in /proc/vmstat counts the deferred pages.  Nothing sets the
> flag yet.
> 
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [kas: rework for flagging at read time, 64-bit only and not PREEMPT_RT,
>  shorter comments and changelog]
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/page-flags.h     |  21 +++++++
>  include/linux/vm_event_item.h  |   1 +
>  include/trace/events/mmflags.h |   7 +++
>  mm/Kconfig                     |  15 +++++
>  mm/huge_memory.c               |   1 +
>  mm/memory-failure.c            |   4 ++
>  mm/page_alloc.c                | 105 +++++++++++++++++++++++++++++++++
>  mm/vmstat.c                    |   1 +
>  8 files changed, 155 insertions(+)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7a863572adce..a1e52a1f8a52 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -111,6 +111,9 @@ enum pageflags {
>  	PG_swapbacked,		/* Page is backed by RAM/swap */
>  	PG_unevictable,		/* Page is "unevictable"  */
>  	PG_dropbehind,		/* drop pages on IO completion */
> +#ifdef CONFIG_PAGE_RCU_FREE
> +	PG_rcu_free,		/* free only after an RCU grace period */
> +#endif
>  #ifdef CONFIG_MMU
>  	PG_mlocked,		/* Page is vma mlocked */
>  #endif
> @@ -602,6 +605,24 @@ FOLIO_FLAG(dropbehind, FOLIO_HEAD_PAGE)
>  	FOLIO_TEST_CLEAR_FLAG(dropbehind, FOLIO_HEAD_PAGE)
>  	__FOLIO_SET_FLAG(dropbehind, FOLIO_HEAD_PAGE)
>  
> +/*
> + * A lockless lookup that sees PG_rcu_free and then still finds the folio
> + * where it looked may read it until rcu_read_unlock().  Set under a
> + * reference, cleared only by the free.  Not for hugetlb or
> + * free_pages_nolock().
> + */
> +#ifdef CONFIG_PAGE_RCU_FREE
> +FOLIO_TEST_FLAG(rcu_free, FOLIO_HEAD_PAGE)
> +	FOLIO_TEST_SET_FLAG(rcu_free, FOLIO_HEAD_PAGE)
> +	__FOLIO_CLEAR_FLAG(rcu_free, FOLIO_HEAD_PAGE)
> +#define __PG_RCU_FREE (1UL << PG_rcu_free)
> +#else
> +FOLIO_TEST_FLAG_FALSE(rcu_free)
> +	FOLIO_TEST_SET_FLAG_FALSE(rcu_free)
> +	__FOLIO_CLEAR_FLAG_NOOP(rcu_free)
> +#define __PG_RCU_FREE 0
> +#endif
> +
>  #ifdef CONFIG_HIGHMEM
>  /*
>   * Must use a macro here due to header dependency issues. page_zone() is not
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index 2628ccda076a..cbe849701653 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -36,6 +36,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>  		FOR_ALL_ZONES(ALLOCSTALL)
>  		FOR_ALL_ZONES(PGSCAN_SKIP)
>  		PGFREE, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE,
> +		PGFREE_RCU,
>  		PGFAULT, PGMAJFAULT,
>  		PGLAZYFREED,
>  		PGREUSE,
> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
> index 935893e5ea53..47c3411a75e8 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -117,6 +117,12 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
>  #define IF_HAVE_PG_IDLE(_name)
>  #endif
>  
> +#ifdef CONFIG_PAGE_RCU_FREE
> +#define IF_HAVE_PG_RCU_FREE(_name) ,{1UL << PG_##_name, __stringify(_name)}
> +#else
> +#define IF_HAVE_PG_RCU_FREE(_name)
> +#endif
> +
>  #ifdef CONFIG_ARCH_USES_PG_ARCH_2
>  #define IF_HAVE_PG_ARCH_2(_name) ,{1UL << PG_##_name, __stringify(_name)}
>  #else
> @@ -152,6 +158,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
>  	DEF_PAGEFLAG_NAME(swapbacked),					\
>  	DEF_PAGEFLAG_NAME(unevictable),					\
>  	DEF_PAGEFLAG_NAME(dropbehind)					\
> +IF_HAVE_PG_RCU_FREE(rcu_free)						\
>  IF_HAVE_PG_MLOCK(mlocked)						\
>  IF_HAVE_PG_HWPOISON(hwpoison)						\
>  IF_HAVE_PG_IDLE(idle)							\
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 604c58199acb..6e5341b0bf64 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -718,6 +718,21 @@ config PCP_BATCH_SCALE_MAX
>  	  latency.  This option sets the upper limit of scale factor to limit
>  	  the maximum latency.
>  
> +config PAGE_RCU_FREE

I think we really want to focus this only on folios (like the current code does).

FOLIO_RCU_FREE ?

> +	def_bool y
> +	depends on 64BIT
> +	depends on !PREEMPT_RT
> +	help
> +	  Reads from the page cache can copy from folios that are read
> +	  again and again without taking a reference on them, so small
> +	  reads of one file from many CPUs do not contend on the folio's
> +	  reference count.  The cost is that memory freed from such
> +	  folios becomes reusable only after an RCU grace period.

While that description is helpful, that's not really what this patch, or rather
the basic infrastructure in page_alloc, does.

I'd suggest to have a dedicated FOLIO_RCU_FREE config and maybe another one
(that selects/depends on) FOLIO_RCU_FREE that actually enables the pagecache use
and documents the details.

> +
> +	  64-bit only: it takes a page flag, and those are scarce on
> +	  32-bit.  Not on PREEMPT_RT, where expedited grace periods are
> +	  normal ones, so freeing the waiting pages on demand would stall.
> +
>  config PHYS_ADDR_T_64BIT
>  	def_bool 64BIT
>  
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1e5d68acf62a..25082949a4ca 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3743,6 +3743,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  #endif
>  				 (1L << PG_dirty) |
>  				 (1L << PG_dropbehind) |
> +				 __PG_RCU_FREE |

That looks a bit odd at first, as it's very different to the other once. But no
easy way around assuming that the flag is not always around.

Maybe we should just have this be a const mask constructed somewhere using BIT()
and __PG_RCU_FREE etc, instead of having this growing list in this user here.

>  				 LRU_GEN_MASK | LRU_REFS_MASK));
>  
>  		new_folio->mapping = folio->mapping;
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a8b03e2920ba..7dde7c3c9a0c 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -211,6 +211,10 @@ static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, boo
>  			return false;
>  	}
>  
> +	/* The free of a hwpoisoned page is not deferred: wait for readers */
> +	if (release && folio_test_rcu_free(page_folio(page)))
> +		synchronize_rcu();
> +
>  	SetPageHWPoison(page);
>  	if (release)
>  		put_page(page);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..a371e92da273 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1313,6 +1313,96 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
>  
>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>  
> +/*
> + * Each CPU has at most one grace period in flight (@queued), covering
> + * @batch.  Folios freed meanwhile wait on @pending for the next one.
> + */
> +struct rcu_free_pcpu {
> +	spinlock_t lock;
> +	bool queued;
> +	struct list_head pending;
> +	struct list_head batch;
> +	struct rcu_work rwork;
> +};
> +
> +static DEFINE_PER_CPU(struct rcu_free_pcpu, rcu_free_pcpu);
> +
> +static struct workqueue_struct *rcu_free_wq __ro_after_init;
> +
> +static void rcu_free_start(struct rcu_free_pcpu *r)
> +{
> +	lockdep_assert_held(&r->lock);
> +
> +	if (r->queued || list_empty(&r->pending))
> +		return;
> +
> +	list_splice_init(&r->pending, &r->batch);
> +	r->queued = true;
> +	WARN_ON_ONCE(!queue_rcu_work(rcu_free_wq, &r->rwork));
> +}
> +
> +static void rcu_free_pages(struct list_head *list)
> +{
> +	struct folio_batch fbatch;
> +	struct folio *folio, *next;
> +
> +	folio_batch_init(&fbatch);
> +	list_for_each_entry_safe(folio, next, list, lru) {
> +		if (!folio_batch_add(&fbatch, folio)) {
> +			free_unref_folios(&fbatch);
> +			cond_resched_tasks_rcu_qs();
> +		}
> +	}
> +	if (folio_batch_count(&fbatch))
> +		free_unref_folios(&fbatch);
> +}
> +
> +static void rcu_free_workfn(struct work_struct *work)
> +{
> +	struct rcu_free_pcpu *r = container_of(to_rcu_work(work),
> +					       struct rcu_free_pcpu, rwork);
> +	LIST_HEAD(done);
> +
> +	spin_lock_irq(&r->lock);
> +	list_splice_init(&r->batch, &done);
> +	r->queued = false;
> +	rcu_free_start(r);
> +	spin_unlock_irq(&r->lock);
> +
> +	rcu_free_pages(&done);
> +}
> +
> +static void rcu_free_defer(struct folio *folio)
> +{
> +	struct rcu_free_pcpu *r = raw_cpu_ptr(&rcu_free_pcpu);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&r->lock, flags);
> +	list_add_tail(&folio->lru, &r->pending);
> +	rcu_free_start(r);
> +	spin_unlock_irqrestore(&r->lock, flags);
> +}
> +
> +static void __init rcu_free_init(void)
> +{
> +	int cpu;
> +
> +	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
> +		return;
> +
> +	rcu_free_wq = alloc_workqueue("rcu_free",
> +				      WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> +
> +	for_each_possible_cpu(cpu) {
> +		struct rcu_free_pcpu *r = per_cpu_ptr(&rcu_free_pcpu, cpu);
> +
> +		spin_lock_init(&r->lock);
> +		INIT_LIST_HEAD(&r->pending);
> +		INIT_LIST_HEAD(&r->batch);
> +		INIT_RCU_WORK(&r->rwork, rcu_free_workfn);
> +	}
> +}
> +
>  static __always_inline bool __free_pages_prepare(struct page *page,
>  		unsigned int order, fpi_t fpi_flags)
>  {
> @@ -1327,6 +1417,19 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>  
>  	VM_BUG_ON_PAGE(PageTail(page), page);
>  
> +	/*
> +	 * Not for a hwpoisoned order-0 page: it never reaches the allocator,
> +	 * and page_handle_poison() takes a reference right after this free.
> +	 */
> +	if (unlikely(folio_test_rcu_free(folio)) &&
> +	    !(PageHWPoison(page) && !order)) {
> +		VM_WARN_ON_ONCE(fpi_flags & FPI_NOLOCK);
> +		__folio_clear_rcu_free(folio);
> +		count_vm_events(PGFREE_RCU, 1 << order);
> +		rcu_free_defer(folio);
> +		return false;
> +	}
I'm wondering whether we want to intercept on the folio freeing path instead?
That would be __folio_put(), before we go into free_frozen_pages() used by other
machinery that does not apply (slab etc).

So maybe this handling could be placed into mm/folio.c instead, just a quick
thought ... reading about folio batches above I think that might be the right
direction, we are mixing too much page vs. folio things here.

-- 
Cheers,

David

