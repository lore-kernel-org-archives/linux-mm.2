Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29048C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 10:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1473F6B00A8; Wed,  1 Jul 2026 06:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7D66B00A9; Wed,  1 Jul 2026 06:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0101F6B00AB; Wed,  1 Jul 2026 06:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC89F6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:23:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56E4C4028E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:23:57 +0000 (UTC)
X-FDA: 84939822114.01.2411845
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id AE48AC0003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:23:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X0gX0K89;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782901435;
	b=YF3ziUOxStGz9/3AZShlHVc+kRQ1PWNSO/mMxI3RQp/AqVjzw1rotReYM3iHJf7CWMoI6j
	NRlpOYz6GujRiQSXxQ++Q3liUmDUiwYPPhEHwk8eUGytRDGp/+0kKHQ52ShrQ8NCFCVRm/
	Urb+GKksClf5r68hmwqlZeGflBPF3/E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782901435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQ8qOYDe5kXztHH+xJLUrlU+iOY7jfOVJOn8zyUOgpA=;
	b=5jF3a5NhLpY1Ev5YF8Ii2/OqPaN8ykOndlosWhniDP20RP26+/ONPMFolfJYZ8vDObbEyv
	j/1bLdG5ywmeYBl5v1tQml1N9E7+I5k9JVF5vGP4JsylzJfdqScR2zDREhyXGbUdfn3Xu7
	anpVIjng5uQ1P9MfJQreV16LwVy09sg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X0gX0K89;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDF7541A77;
	Wed,  1 Jul 2026 10:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0407C1F000E9;
	Wed,  1 Jul 2026 10:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782901434;
	bh=wQ8qOYDe5kXztHH+xJLUrlU+iOY7jfOVJOn8zyUOgpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X0gX0K89AEhl6+DSq4hnkO/hI4W5rOjmCIJb0AR9m+PwyStRVf0lIsm/lmnjt2vr3
	 QxxOaKesl67hWCdXgvKo+yOXn58N6erfdHWm5E5l6GC7BwwLVwkXmXRyxW5k3Sdh8a
	 pFg3Ga20/wO8l/9OrwmZWpU6QT16+77MTPfQtnqjmXLhA97yuKPAMSI8Ce8HQUgOiD
	 Z9Z+zl5gR/d5+5LKPvAE1TbLsnsdcls0ABM3ZpwFrdUIwSmvHq1LahwFbuwY2jpleM
	 q24N7RvO92QuU/OrfqEfDeB3FWoTeokeWPDzPMfSDJ/vOpgSizL3Y7rBN2vzef42g/
	 o6Wu3FpN1225A==
Date: Wed, 1 Jul 2026 11:23:42 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/9] mm: use enum migrate_reason instead of int for
 migration reason parameters
Message-ID: <akTqXYFncsSLniIn@lucifer>
References: <20260701061101.344679-1-ye.liu@linux.dev>
 <20260701061101.344679-4-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701061101.344679-4-ye.liu@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 5fyta5yoas1qk1buhconuppa6hubqe1a
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE48AC0003
X-HE-Tag: 1782901435-705658
X-HE-Meta: U2FsdGVkX1+LfRwHBFY27eEHZeZgXz66JHqbR25yM94Nz17sW1nblxb/v2R2u9AJn9PbIsKXhisSdQL+RD4S9qKoCKakh4b6j1xveLAhXnAJEXOnRhin3AOlH1vhbI/pihJ61oOF+AqtMprGspuON53fDHUEcqGboHQRoNcDZomTbS/VmpxckAznXaLn4vc1CI3WjxIKzncoC2KNxyjCPnTGv8+JzW451OWnedm3R9wBGtZbL5vAdpOeLp/gxsytH4g2s4oxwSpf2IWtbPYVzcjP7OdAd2N70DjdRqSproEoUN4KoyePnBvdn+fLo4awa0dBYVXm8x7UZYXkbTwTywyN6N7LE8zeXfygBCN6I5NP9A2NP9h65yH+MvuUDvIRhkmUNL9DEqW998VGnIT5wBdIgJ7oKrwe2pJheTVjL/OJCxXEoJyssu+0kFpQkpDwU1tYiFzG5ltVa9K+AztljQ0CPxCd+PDhL1X0mxecOUbv2SueJmr5WBl9DnM3yxcdhiZ6t70E94ufLWHKtJpjcUuhPQVI8RQqOBGEBThXibsG+v5oYvkibjLXQM7CiZmrFgAZ3LZWECnGn2k7FPss3tMvfX77zINzYgr7Ag6NTb0M7Bima4Rmx6oLOWUrycc7k1UXbk0kxNGtSXj0gJ+kNGfrZ47+hu6soGka30xVuoIkovpGxSfbV47S9HsUCkjYtrQrQP8OFPRAjfKc9cXyoYPLaj2y9m62UwmW848KgDzjLMqO+hWtQZwJCTbx1WWFj/TPpbLD74YHt92P4GUuD80KPxMj4IqR0h6SxkzHopt+8Gf203BiCS6Z2IPYWBeqe6eZSHn+kVqjnu58mbxDpGTlVsMBnzDOrSOdlzx4CddUN/vYLnnzjN6w7qMUny27IbkRmzpC0z625SnwBm5SJ4/LGSDhyqgFhMiuztfVx7foUl4SYyFEjQ1RYZ96gGVM6BcO1scP+bk/t5GQHqT
 mkkLZcuN
 B4ZiHX9EataR50PytnZNEeK354HexoOy8VVKdvM6c+qjHPWmwijIiSxlqMkGedphKy+MIOdYAamFVd69BNUMFnte2blBjn53z52PHiPx414amzrsQjwldQeF7iB80huaVyf6fO6rqI5B8k2odn6lEBcw45F08wthwplbph5jtThP2OX0bkavowZPzZ3x77NmWt54pBIRMrSdbIRHDmKi2IPDaTn+r/eHt4jd02K7M/gA6mhEjY46EX6qtR8s9uCxItOEL0BXs5m4Uu7Rv1kpmGlnJ1YIAE+i51D9ZmkKdb+S7pyI2JRTm0iWRuUVI+7p1ABosfk80mUEDP6fcO2CGPZlExgRxTGzZ/DNg/akfUs0q/6LtG7p4kx1tJFTqoNy7QhlCFmMFG76sAhIebuH5QP/vnGVaklIEhuhAlcgRPNVeZMw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 02:10:46PM +0800, Ye Liu wrote:
> Replace all 'int reason' function parameters that carry migrate_reason
> values with the proper 'enum migrate_reason' type.  This makes the
> intent explicit and leverages compiler type checking.  The affected
> subsystems are:
>
>   - page_owner: __folio_set_owner_migrate_reason(),
>                 folio_set_owner_migrate_reason()
>   - migrate: migrate_pages(), migrate_pages_sync(),
>              migrate_pages_batch(), migrate_folios_move(),
>              migrate_hugetlbs(), unmap_and_move_huge_page()
>   - hugetlb: move_hugetlb_state(), htlb_allow_alloc_fallback()
>   - trace: mm_migrate_pages and mm_migrate_pages_start events
>
> The 'short last_migrate_reason' struct field and internal helper
> parameter in page_owner are intentionally left as 'short' since they
> store per-page metadata where size matters.

Based on my own personal experience, it's ok to be short ;)

>
> No functional change.
>
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

1 nit below but otherwise LGTM so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  include/linux/hugetlb.h        |  9 +++++----
>  include/linux/migrate.h        |  6 ++++--
>  include/linux/page_owner.h     |  7 ++++---
>  include/trace/events/migrate.h |  8 ++++----
>  mm/hugetlb.c                   |  3 ++-
>  mm/migrate.c                   | 12 ++++++------
>  mm/page_owner.c                |  2 +-
>  7 files changed, 26 insertions(+), 21 deletions(-)
>
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 2abaf99321e9..fa828232dfcc 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -154,7 +154,8 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
>  bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
>  int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
>  void folio_putback_hugetlb(struct folio *folio);
> -void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
> +void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
> +			enum migrate_reason reason);
>  void hugetlb_fix_reserve_counts(struct inode *inode);
>  extern struct mutex *hugetlb_fault_mutex_table;
>  u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx);
> @@ -424,7 +425,7 @@ static inline void folio_putback_hugetlb(struct folio *folio)
>  }
>
>  static inline void move_hugetlb_state(struct folio *old_folio,
> -					struct folio *new_folio, int reason)
> +					struct folio *new_folio, enum migrate_reason reason)
>  {
>  }
>
> @@ -956,7 +957,7 @@ static inline gfp_t htlb_modify_alloc_mask(struct hstate *h, gfp_t gfp_mask)
>  	return modified_mask;
>  }
>
> -static inline bool htlb_allow_alloc_fallback(int reason)
> +static inline bool htlb_allow_alloc_fallback(enum migrate_reason reason)
>  {
>  	bool allowed_fallback = false;
>
> @@ -1238,7 +1239,7 @@ static inline gfp_t htlb_modify_alloc_mask(struct hstate *h, gfp_t gfp_mask)
>  	return 0;
>  }
>
> -static inline bool htlb_allow_alloc_fallback(int reason)
> +static inline bool htlb_allow_alloc_fallback(enum migrate_reason reason)
>  {
>  	return false;
>  }
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index d5af2b7f577b..1f83924615d6 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -57,7 +57,8 @@ void putback_movable_pages(struct list_head *l);
>  int migrate_folio(struct address_space *mapping, struct folio *dst,
>  		struct folio *src, enum migrate_mode mode);
>  int migrate_pages(struct list_head *l, new_folio_t new, free_folio_t free,
> -		  unsigned long private, enum migrate_mode mode, int reason,
> +		  unsigned long private, enum migrate_mode mode,
> +		  enum migrate_reason reason,
>  		  unsigned int *ret_succeeded);
>  struct folio *alloc_migration_target(struct folio *src, unsigned long private);
>  bool isolate_movable_ops_page(struct page *page, isolate_mode_t mode);
> @@ -77,7 +78,8 @@ int set_movable_ops(const struct movable_operations *ops, enum pagetype type);
>  static inline void putback_movable_pages(struct list_head *l) {}
>  static inline int migrate_pages(struct list_head *l, new_folio_t new,
>  		free_folio_t free, unsigned long private,
> -		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
> +		enum migrate_mode mode, enum migrate_reason reason,
> +		unsigned int *ret_succeeded)
>  	{ return -ENOSYS; }
>  static inline struct folio *alloc_migration_target(struct folio *src,
>  		unsigned long private)
> diff --git a/include/linux/page_owner.h b/include/linux/page_owner.h
> index 3328357f6dba..9fe51dfccf26 100644
> --- a/include/linux/page_owner.h
> +++ b/include/linux/page_owner.h
> @@ -3,6 +3,7 @@
>  #define __LINUX_PAGE_OWNER_H
>
>  #include <linux/jump_label.h>
> +#include <linux/migrate_mode.h>
>
>  #ifdef CONFIG_PAGE_OWNER
>  extern struct static_key_false page_owner_inited;
> @@ -14,7 +15,7 @@ extern void __set_page_owner(struct page *page,
>  extern void __split_page_owner(struct page *page, int old_order,
>  			int new_order);
>  extern void __folio_copy_owner(struct folio *newfolio, struct folio *old);
> -extern void __folio_set_owner_migrate_reason(struct folio *folio, int reason);
> +extern void __folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason);

NIT: We drop externs when we change them as a rule, the extern is unnecessary.

>  extern void __dump_page_owner(const struct page *page);
>  extern void pagetypeinfo_showmixedcount_print(struct seq_file *m,
>  					pg_data_t *pgdat, struct zone *zone);
> @@ -43,7 +44,7 @@ static inline void folio_copy_owner(struct folio *newfolio, struct folio *old)
>  	if (static_branch_unlikely(&page_owner_inited))
>  		__folio_copy_owner(newfolio, old);
>  }
> -static inline void folio_set_owner_migrate_reason(struct folio *folio, int reason)
> +static inline void folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason)
>  {
>  	if (static_branch_unlikely(&page_owner_inited))
>  		__folio_set_owner_migrate_reason(folio, reason);
> @@ -68,7 +69,7 @@ static inline void split_page_owner(struct page *page, int old_order,
>  static inline void folio_copy_owner(struct folio *newfolio, struct folio *folio)
>  {
>  }
> -static inline void folio_set_owner_migrate_reason(struct folio *folio, int reason)
> +static inline void folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason)
>  {
>  }
>  static inline void dump_page_owner(const struct page *page)
> diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
> index 11bc0aa14c7e..15ee2ef201b5 100644
> --- a/include/trace/events/migrate.h
> +++ b/include/trace/events/migrate.h
> @@ -52,7 +52,7 @@ TRACE_EVENT(mm_migrate_pages,
>  	TP_PROTO(unsigned long succeeded, unsigned long failed,
>  		 unsigned long thp_succeeded, unsigned long thp_failed,
>  		 unsigned long thp_split, unsigned long large_folio_split,
> -		 enum migrate_mode mode, int reason),
> +		 enum migrate_mode mode, enum migrate_reason reason),
>
>  	TP_ARGS(succeeded, failed, thp_succeeded, thp_failed,
>  		thp_split, large_folio_split, mode, reason),
> @@ -65,7 +65,7 @@ TRACE_EVENT(mm_migrate_pages,
>  		__field(	unsigned long,		thp_split)
>  		__field(	unsigned long,		large_folio_split)
>  		__field(	enum migrate_mode,	mode)
> -		__field(	int,			reason)
> +		__field(	enum migrate_reason,	reason)
>  	),
>
>  	TP_fast_assign(
> @@ -92,13 +92,13 @@ TRACE_EVENT(mm_migrate_pages,
>
>  TRACE_EVENT(mm_migrate_pages_start,
>
> -	TP_PROTO(enum migrate_mode mode, int reason),
> +	TP_PROTO(enum migrate_mode mode, enum migrate_reason reason),
>
>  	TP_ARGS(mode, reason),
>
>  	TP_STRUCT__entry(
>  		__field(enum migrate_mode, mode)
> -		__field(int, reason)
> +		__field(enum migrate_reason, reason)
>  	),
>
>  	TP_fast_assign(
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835..17732d1fdc5e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -7182,7 +7182,8 @@ void folio_putback_hugetlb(struct folio *folio)
>  	folio_put(folio);
>  }
>
> -void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason)
> +void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
> +			enum migrate_reason reason)
>  {
>  	struct hstate *h = folio_hstate(old_folio);
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index d9b23909d716..49e10feeb094 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1469,7 +1469,7 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>  		free_folio_t put_new_folio, unsigned long private,
>  		struct folio *src, int force, enum migrate_mode mode,
> -		int reason, struct list_head *ret)
> +		enum migrate_reason reason, struct list_head *ret)
>  {
>  	struct folio *dst;
>  	int rc = -EAGAIN;
> @@ -1626,7 +1626,7 @@ struct migrate_pages_stats {
>   */
>  static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
>  			    free_folio_t put_new_folio, unsigned long private,
> -			    enum migrate_mode mode, int reason,
> +			    enum migrate_mode mode, enum migrate_reason reason,
>  			    struct migrate_pages_stats *stats,
>  			    struct list_head *ret_folios)
>  {
> @@ -1716,7 +1716,7 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
>  static void migrate_folios_move(struct list_head *src_folios,
>  		struct list_head *dst_folios,
>  		free_folio_t put_new_folio, unsigned long private,
> -		enum migrate_mode mode, int reason,
> +		enum migrate_mode mode, enum migrate_reason reason,
>  		struct list_head *ret_folios,
>  		struct migrate_pages_stats *stats,
>  		int *retry, int *thp_retry, int *nr_failed,
> @@ -1799,7 +1799,7 @@ static void migrate_folios_undo(struct list_head *src_folios,
>   */
>  static int migrate_pages_batch(struct list_head *from,
>  		new_folio_t get_new_folio, free_folio_t put_new_folio,
> -		unsigned long private, enum migrate_mode mode, int reason,
> +		unsigned long private, enum migrate_mode mode, enum migrate_reason reason,
>  		struct list_head *ret_folios, struct list_head *split_folios,
>  		struct migrate_pages_stats *stats, int nr_pass)
>  {
> @@ -2011,7 +2011,7 @@ static int migrate_pages_batch(struct list_head *from,
>
>  static int migrate_pages_sync(struct list_head *from, new_folio_t get_new_folio,
>  		free_folio_t put_new_folio, unsigned long private,
> -		enum migrate_mode mode, int reason,
> +		enum migrate_mode mode, enum migrate_reason reason,
>  		struct list_head *ret_folios, struct list_head *split_folios,
>  		struct migrate_pages_stats *stats)
>  {
> @@ -2088,7 +2088,7 @@ static int migrate_pages_sync(struct list_head *from, new_folio_t get_new_folio,
>   */
>  int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
>  		free_folio_t put_new_folio, unsigned long private,
> -		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
> +		enum migrate_mode mode, enum migrate_reason reason, unsigned int *ret_succeeded)
>  {
>  	int rc, rc_gather;
>  	int nr_pages;
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index c2f43ab860eb..4e352941a6e2 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -345,7 +345,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
>  	inc_stack_record_count(handle, gfp_mask, 1 << order);
>  }
>
> -void __folio_set_owner_migrate_reason(struct folio *folio, int reason)
> +void __folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason)
>  {
>  	struct page_ext *page_ext = page_ext_get(&folio->page);
>  	struct page_owner *page_owner;
> --
> 2.43.0
>

Cheers, Lorenzo

