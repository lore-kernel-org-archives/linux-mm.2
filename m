Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DC7DCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 07:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017DC6B0005; Wed, 17 Jun 2026 03:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B356B0088; Wed, 17 Jun 2026 03:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20A06B008A; Wed, 17 Jun 2026 03:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8D256B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:54:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 48B581A0399
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:54:53 +0000 (UTC)
X-FDA: 84888643266.05.EA62679
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 60AF340006
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:54:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MItORZYP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781682891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWtYSes6tIGGuR+SZXDuYlRAGjOXZD/BHMUqdQhGjyg=;
	b=3Ytrt30SSf9upzKBrzlEtnt5x7VTDvti+ImNe6AECM5QTBP8LwA1o5LYq++mLGgvMJ4duM
	TOeu6oeqlBYmhqyCGKu6xxOtNfahBVKYoOTAg4SYpGBL9IJu3suIeHMyMjlLcRiS93WcXQ
	fZ5+Wf+RpBIuSYiQ9V9DufXFnQFjW5w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MItORZYP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781682891;
	b=XhdZ06TmvNyxgTJ6ohj/fbRylH8YFZIOzGvZT6ovv/uEyn7bhbV/VeUL+QiPF7hni3V3/f
	J4VpDkqgMo7gA8K4d1XPnq//jyLVBTzZw6XIPPPRFiZLi3si5dc876ba70HtvUQLouhsN/
	yyOU95TYjac/SVi7Cci9HTQHcPAo4mY=
Date: Wed, 17 Jun 2026 15:54:37 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781682889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MWtYSes6tIGGuR+SZXDuYlRAGjOXZD/BHMUqdQhGjyg=;
	b=MItORZYPQB5EbHt4M+9GB1KAhkcS+MMAvZLJXzBqJsqjvpcm9DeRX6Tg2H5CQIWEfjVHWY
	UZEWyL9WIShc2Ar1Dr0zKLywX3jRRb62KeYUq7oKmL+ewMHCK0QP1xar9uLSi0qycxTVXO
	rCU7ilHgsA6gHpQ47KstM85VADdXBUg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, liam@infradead.org, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/slub: preserve previous object lifetime in user
 tracking
Message-ID: <ajJMzHe3W8a8NGqK@fedora>
References: <20260616141410.52117-1-pengpeng@iscas.ac.cn>
 <20260616141410.52117-3-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616141410.52117-3-pengpeng@iscas.ac.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 60AF340006
X-Rspam-User: 
X-Stat-Signature: urgxkbru8og1mzh47qxr8rrjz3xpizzp
X-Rspamd-Server: rspam09
X-HE-Tag: 1781682891-240552
X-HE-Meta: U2FsdGVkX1+BClrAauwl2fXzwKf99zBcE0PKAsz781E2DiZal7trVYw/torR5OVFf4rNqnXj/EDZZw6HJ2zHhPr9f4aM93llIOWKxEtPnqCE5CrKGat3bqs8+ssoKRH6ZGoYSuVSZkaXw4uwuGg4KZr1qQZnriR/7olD2kAyUIfhbyWAsyszLjO71F/Iku7q+YlojIPFnrOo7pBZVsjuTofHUwN3y1eK1DA2CgCIh5SanU1AW6Xs1cSE5lzZiy5ZqFO4aMTK6CfUUYgR/6KZ/YgkFoSDdi1h8VZOuej/AIE8Ct0LqTH+283vW3SZFuN/G2hop+hs+2qzg0rs7U8P4FqVB/tVPprHLQ7RWtv8Nisj3HhwgeTmVxlySi0pbmphmR9gFrV8aiWqj0fMQKDYe70sR1pnbCBASWsXHaznaNPsJo1lRFEnU3VNsVPebhMIZSmBuNrk7IrK5MN9Hz4j/jy1bE148AjRLRjJ85KPi8qNUDlmuRhaHz3DvgwUuEaiQ+i5q09shGRr3QwYu+VZ+Rc038VRZ8jmpq491tLPQNWIyJZ8Fs2LgxSzOisfyfvz+SlTfkQcAUxNa+KdZa68eoaEzqFYrFxJ5bzji4avUrgbooDEYkacK94WMbP7Kc+HpNJFS1jFhYemdWhn7V57Kc01KyarsBLdcCy1alm5W0kztZbuJ7y0vcmz+fEcjXcOsGl9SerBScw7zi2bmiKegfgO14lG9nMPN+bAIwTTYXuWSE5/rHxFklF9/fNjQRypYhqN/EpGKNZgwDNP1F5D+6z2ueD7pR55emV+idpBdCpTbu5mSj4Lr+2DMaaoj2pyCCLPdMHRzrk6rLYlfwwAz54xjZCRyhE+whwjsjrVM54qlNEAj5HggTf2Xl81huDthKCfvDtQw2L+CgjADnhir9WX0kQXs7kJfMazTWJ+Xsz9D3hB14kabSGS78zY1soJPrxP0CHfiTS3JMrcPFq
 UIuZKlKJ
 pSG/xeqxkcYLtoneKYHxLhtYPVbNZS7Z1O+7Ziwe4NlaIcaJs3opDA3Wf09Bf42hHyJWGBHLwR+JUZgIeTtVVBUn43sJS+RAaS/J20pZh1OF7eqhDePfWF0H2wD8sdkRnlFj99nwntYHtXU7fgg576D5Es18sEAWY/qpPhKGuUatZr4espXcZhinO7ALkdcLh3ErMAza8x5n+HMsT00Xm605RQm3NybXvFYBaICLDozYhd1qlyex3zYVOWva1GJPL1l5oTUmdvW7lg54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 10:14:08PM +0800, Pengpeng Hou wrote:
> SLAB_STORE_USER stores one allocation track and one free track for an
> object.  When that object is reused, the next allocation overwrites the
> allocation track.  If a stale pointer from the previous lifetime is later
> freed or otherwise reported, the free/check report can contain the victim
> allocation and the stale operation while the previous completed alloc/free
> pair has already been overwritten.
> 
> Keep one previous completed lifetime in the existing user tracking
> metadata.  When an object is allocated and the current allocation/free
> tracks both exist, copy that completed lifetime to the previous-lifetime
> slots before recording the new allocation.  Clear the current free track
> when the new allocation begins so the current lifetime does not continue
> to display a free from the old lifetime.
> 
> Print the previous object lifetime when it is available.  This is
> diagnostic information only; it does not infer semantic ownership or
> identify the root cause of a use-after-free.
> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  mm/slub.c | 66 +++++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 55 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 43d4febd5bf2..358f42e92207 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -327,7 +327,13 @@ struct track {
>  	unsigned long when;	/* When did the operation occur */
>  };
>  
> -enum track_item { TRACK_ALLOC, TRACK_FREE, TRACK_NR };
> +enum track_item {
> +	TRACK_ALLOC,
> +	TRACK_FREE,
> +	TRACK_PREV_ALLOC,
> +	TRACK_PREV_FREE,
> +	TRACK_NR,
> +};
>  
>  static inline unsigned int user_tracking_size(slab_flags_t flags)
>  {
> @@ -1080,12 +1086,37 @@ static void set_track_update(struct kmem_cache *s, void *object,
>  	p->when = jiffies;
>  }
>  
> -static __always_inline void set_track(struct kmem_cache *s, void *object,
> -				      enum track_item alloc, unsigned long addr, gfp_t gfp_flags)
> +static bool track_has_record(const struct track *t)
> +{
> +	return t->addr;
> +}

how about inline it

> +
> +static void clear_track(struct kmem_cache *s, void *object,
> +			enum track_item track)
> +{
> +	memset(get_track(s, object, track), 0, sizeof(struct track));
> +}
> +
> +static void save_previous_lifetime(struct kmem_cache *s, void *object)
> +{
> +	struct track *alloc = get_track(s, object, TRACK_ALLOC);
> +	struct track *free = get_track(s, object, TRACK_FREE);
> +
> +	if (!track_has_record(alloc) || !track_has_record(free))
> +		return;
> +
> +	*get_track(s, object, TRACK_PREV_ALLOC) = *alloc;
> +	*get_track(s, object, TRACK_PREV_FREE) = *free;

Maybe we can use memcpy instead of copying them one by one.

> +}
> +
> +static __always_inline void set_alloc_track(struct kmem_cache *s, void *object,
> +					    unsigned long addr, gfp_t gfp_flags)
>  {
>  	depot_stack_handle_t handle = set_track_prepare(gfp_flags);
>  
> -	set_track_update(s, object, alloc, addr, handle);
> +	save_previous_lifetime(s, object);
> +	set_track_update(s, object, TRACK_ALLOC, addr, handle);
> +	clear_track(s, object, TRACK_FREE);

sashiko has a comment:

https://sashiko.dev/#/patchset/20260616141410.52117-1-pengpeng%40iscas.ac.cn

It seems a simple fix could be removing clear_track() and allow the stale free
track.

>  }
>  
>  static void init_tracking(struct kmem_cache *s, void *object)
> @@ -1120,11 +1151,22 @@ static void print_track(const char *s, struct track *t, unsigned long pr_time)
>  void print_tracking(struct kmem_cache *s, void *object)
>  {
>  	unsigned long pr_time = jiffies;
> +	struct track *prev_alloc;
> +	struct track *prev_free;
> +
>  	if (!(s->flags & SLAB_STORE_USER))
>  		return;
>  
>  	print_track("Allocated", get_track(s, object, TRACK_ALLOC), pr_time);
>  	print_track("Freed", get_track(s, object, TRACK_FREE), pr_time);
> +
> +	prev_alloc = get_track(s, object, TRACK_PREV_ALLOC);
> +	prev_free = get_track(s, object, TRACK_PREV_FREE);
> +	if (track_has_record(prev_alloc) || track_has_record(prev_free)) {
> +		pr_err("Previous object lifetime:\n");
> +		print_track("Previously allocated", prev_alloc, pr_time);
> +		print_track("Previously freed", prev_free, pr_time);
> +	}
>  }
>  
>  static void print_slab_info(const struct slab *slab)
> @@ -1371,10 +1413,12 @@ check_bytes_and_report(struct kmem_cache *s, struct slab *slab,
>   *
>   * [Metadata starts at object + s->inuse]
>   *   - A. freelist pointer (if freeptr_outside_object)
> - *   - B. alloc tracking (SLAB_STORE_USER)
> - *   - C. free tracking (SLAB_STORE_USER)
> - *   - D. original request size (SLAB_KMALLOC && SLAB_STORE_USER)
> - *   - E. KASAN metadata (if enabled)
> + *   - B. current alloc tracking (SLAB_STORE_USER)
> + *   - C. current free tracking (SLAB_STORE_USER)
> + *   - D. previous alloc tracking (SLAB_STORE_USER)
> + *   - E. previous free tracking (SLAB_STORE_USER)
> + *   - F. original request size (SLAB_KMALLOC && SLAB_STORE_USER)
> + *   - G. KASAN metadata (if enabled)
>   *
>   * [Mandatory padding] (if CONFIG_SLUB_DEBUG && SLAB_RED_ZONE)
>   *   - One mandatory debug word to guarantee a minimum poisoned gap
> @@ -2029,8 +2073,8 @@ static inline void slab_pad_check(struct kmem_cache *s, struct slab *slab) {}
>  static inline int check_object(struct kmem_cache *s, struct slab *slab,
>  			void *object, u8 val) { return 1; }
>  static inline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags) { return 0; }
> -static inline void set_track(struct kmem_cache *s, void *object,
> -			     enum track_item alloc, unsigned long addr, gfp_t gfp_flags) {}
> +static inline void set_alloc_track(struct kmem_cache *s, void *object,
> +				   unsigned long addr, gfp_t gfp_flags) {}
>  static inline void add_full(struct kmem_cache *s, struct kmem_cache_node *n,
>  					struct slab *slab) {}
>  static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
> @@ -4522,7 +4566,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  
>  success:
>  	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
> -		set_track(s, object, TRACK_ALLOC, addr, gfpflags);
> +		set_alloc_track(s, object, addr, gfpflags);
>  
>  	return object;
>  }
> -- 
> 2.43.0
> 
-- 
Thanks,
Hao

