Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0638DC5DF70
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 10:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30E76B00C8; Mon, 17 Aug 2026 06:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE20E6B06AA; Mon, 17 Aug 2026 06:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1146B08F5; Mon, 17 Aug 2026 06:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B74396B00C8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:31:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41605C070A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:31:16 +0000 (UTC)
X-FDA: 85110394152.08.3AF3B37
Received: from mta0.migadu.com (out-162.mta0.migadu.com [91.218.175.162])
	by imf26.hostedemail.com (Postfix) with ESMTP id 345DB140005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:31:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cFAhJGQB;
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.162 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786962674;
	b=dixmfxNjP+nTyCMaPxngzsBe24kcDNQibjaQKgt+Es+WPWg6McV+IUCvkFItNXB+xozNpB
	rWpBxhJWu7yZG4PqIabIBjHRmMM1sEc8wP8skvexwLn4AlH2dk1vk0HuvgP6Q0xNI+7YNC
	70ef+DtNIHD4LTG/ouSROvvj563vxd0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cFAhJGQB;
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.162 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786962674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=76h1z+y8we9PrF33dek8Lb6f4fqTsLxjT5NW0ngxUwA=;
	b=1Qn7wKYlFeMwriIU7JBGsrAk6RxoYp9J3EctrKzH4kmxhqwY0Mon9dzOd9OFaGVJImsHWU
	Og+bA66VGCllsqsLO0ns8fwvolYJSdCUbpqovZDUApktDmPOK6wMimrCsN9ZpuAbbLpEWC
	c1dMjISHPi634mEP+XCWtJe/0qZCKfM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PHSNppafh7ZvoaPW4R/vyyDgd1aWKargi1a4hgkd6Qs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786962672; v=1; x=1787567472;
 b=cFAhJGQBmBFu5zWJnL8n+ytDw9pjVq7UM3dNOSSm3rev4xs0AwXNScqhudLwcep8ZpCol+FI
 CHyYdlEu4F72KSMEXlV8aIYsNwMwTTqYvlF9C/BzyMImfq4C9b5WW+mlyYLN8HFSuiMFkHU578y
 n2Kq8XOEJ2QFMZQcAxRBP+Ls=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id 688d5662f1f063b2;
	Mon, 17 Aug 2026 10:31:02 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 18:30:51 +0800
From: Hao Li <hao.li@linux.dev>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm/slub: preserve one previous object lifetime
Message-ID: <aoLcw91-afP2Mjtb@fedora>
References: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
 <20260813161244.74476-1-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813161244.74476-1-pengpeng@iscas.ac.cn>
X-Rspamd-Queue-Id: 345DB140005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: o1ab1hztcbez85u4afq9kqmujzwe7x3p
X-HE-Tag: 1786962673-222812
X-HE-Meta: U2FsdGVkX188eagId1TCsp2RaR2jtVWQEkmeNWEgowhKwfL23kF44GXv/HHjiyGj3NTTMQVLsYR4YW7wkkzlBrejGAQtg8GbkvAGbQ0wf117cY4PrYqrn6Wbllo2MWwille/1HjvMHeta65ZxM222uu0oRINb1d5gPZWBjXAKe3Nr5UKmaIwJJrwVjB89Rug8YT3EkoQ7t2ONBgOX8GJajI4J83kW374H8kZQ3iiS1ucBVPc5Vh62F6OJoyuYN9zLzlAD4ilyad6q8PbhBqlSQ7cgPWNF0HZrZf8hL5ECFZh/vggUHjW0H7lO1r3erY//EWfI3TAvP9RWc3DLWktzooP1m1aDBbNjElmNOZGhjd/jqbeFFetUu8NhuiTvh9NB4dpbhSwEzvQt+GuzrQ9gPhqITN4bj/CuLY9Z3CNLuyEOx+jnWLpgTngcKksA1OLYpkMob7oNeDc1RgRF0PT9DZc6A5Mmql2dTfKF2uM1qD78pfRNVU1i6vvGqZoBVhUtHTSVpMQM/zs/YzkQW4Dq7+JVfXij4X50GQDyM3LNS+3ykwTIV+GiZqp9vGgycFWzv2qxNoZMhf5jSooA601mlkpUviSo/wTXmiUY5gSmmKDsypuzK31DxaBjK3xGPpC37HWQs70bMHIyVazC2whOCjzd1G7I8cZFr5dBuKNCbxX5EIMVqZBMXZXOnKysJjXVS34zO99UZSGJFXcBUAJZlWN5NlxNZ953UdgQeeD5s79yavpOPWXhrVcbYXAg4g5tsjMIyS45K4/JdAuPye0RKeKIKKF6G4MNCwDY1uxgPUT9I0uSog3yKJ4t/r+jGWa9+JzQNmAlOEcjK6lSpw6MWlC82uqB1egv79ADucWYJYgfMSp2XRl0hMtDmMeZ4rWpCOsH5H0LqKPZ7AqEjIJC8XyPwCTBT4eNuCWsw7fOWAHiBzkUueFuaTzlpcM5iyWPWBqkv6WASfKo1AvIZx
 TK3hUSXT
 NKo00++O0ntt+AN/MTBcMGfE2cxNDQA7fxSpcgWsw3DM1/rdmoq+XAP4BS5DHYIciR+ZITMCFLB+d+cwIfthNlubbcaBIq4qJQbeuK36cJgIP3obt5fVIBuqDeY4rDGBKDGytEYRiM2CoIG8aqigDmOhcb0BJJZ8U7DvcqSW9Q2KzhU0bz4/ZmCSngs33HytY5IE/VXPOw1cwwvQNDxndTacV0NfelJx0wMDLmXTlCcyCp5AyVmGSAZ6CdwSE4FV8OfYrRzSpUd0uoc4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 12:12:44AM +0800, Pengpeng Hou wrote:
> SLAB_STORE_USER replaces the allocation track when an object is reused.  A
> later stale free can then replace the free track as well, leaving the
> report without the completed lifetime that created the stale reference.
> 
> Store one additional alloc/free pair.  Before recording a new allocation,
> copy the current pair to the previous slots only when both records exist.
> Keep the current free track intact to preserve existing SLAB_STORE_USER
> behavior during the reuse window.
> 
> Print the previous pair when available.  These records are diagnostic
> history and do not infer semantic ownership.
> 
> Assisted-by: Codex:gpt-5
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  mm/slub.c | 45 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 36 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 0653def0fe36..355fbffb981f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -329,7 +329,13 @@ struct track {
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
>  #ifdef SLAB_SUPPORTS_SYSFS
>  static int sysfs_slab_add(struct kmem_cache *);
> @@ -1074,12 +1080,23 @@ static void set_track_update(struct kmem_cache *s, void *object,
>  	p->when = jiffies;
>  }
>  
> -static __always_inline void set_track(struct kmem_cache *s, void *object,
> -				      enum track_item alloc, unsigned long addr, gfp_t gfp_flags)
> +static __always_inline void set_alloc_track(struct kmem_cache *s, void *object,
> +					    unsigned long addr, gfp_t gfp_flags)
>  {
>  	depot_stack_handle_t handle = set_track_prepare(gfp_flags);
> +	struct track *alloc = get_track(s, object, TRACK_ALLOC);
> +	struct track *free = get_track(s, object, TRACK_FREE);
> +	struct track *prev_alloc;
> +	struct track *prev_free;
> +
> +	if (alloc->addr && free->addr) {
> +		prev_alloc = get_track(s, object, TRACK_PREV_ALLOC);
> +		prev_free = get_track(s, object, TRACK_PREV_FREE);
> +		*prev_alloc = *alloc;
> +		*prev_free = *free;
> +	}
>  
> -	set_track_update(s, object, alloc, addr, handle);
> +	set_track_update(s, object, TRACK_ALLOC, addr, handle);
>  }
>  
>  static void init_tracking(struct kmem_cache *s, void *object)
> @@ -1113,12 +1130,22 @@ static void print_track(const char *s, struct track *t, unsigned long pr_time)
>  
>  void print_tracking(struct kmem_cache *s, void *object)
>  {
> +	struct track *prev_alloc;
>  	unsigned long pr_time = jiffies;
> +
>  	if (!(s->flags & SLAB_STORE_USER))
>  		return;
>  
>  	print_track("Allocated", get_track(s, object, TRACK_ALLOC), pr_time);
>  	print_track("Freed", get_track(s, object, TRACK_FREE), pr_time);

When object is in allocated state, under normal case, this "Freed" line
duplicates with the "Freed" line under "Previous object lifetime:"

Would it make sense to add a check here? something like:

if ("free track" isn't the same as "prev_free track")
	print_track("Freed", get_track(s, object, TRACK_FREE), pr_time);

> +
> +	prev_alloc = get_track(s, object, TRACK_PREV_ALLOC);
> +	if (!prev_alloc->addr)
> +		return;
> +
> +	pr_err("Previous object lifetime:\n");
> +	print_track("Allocated", prev_alloc, pr_time);
> +	print_track("Freed", get_track(s, object, TRACK_PREV_FREE), pr_time);
>  }
>  
>  static void print_slab_info(const struct slab *slab)
> @@ -1366,8 +1393,8 @@ check_bytes_and_report(struct kmem_cache *s, struct slab *slab,
>   *
>   * [Metadata starts at object + s->inuse]
>   *   - A. freelist pointer (if freeptr_outside_object)
> - *   - B. alloc tracking (SLAB_STORE_USER)
> - *   - C. free tracking (SLAB_STORE_USER)
> + *   - B. current alloc/free tracking (SLAB_STORE_USER)
> + *   - C. previous alloc/free tracking (SLAB_STORE_USER)
>   *   - D. original request size (SLAB_KMALLOC && SLAB_STORE_USER)
>   *   - E. KASAN metadata (if enabled)
>   *
> @@ -2024,8 +2051,8 @@ static inline void slab_pad_check(struct kmem_cache *s, struct slab *slab) {}
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
> @@ -4493,7 +4520,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  
>  success:
>  	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
> -		set_track(s, object, TRACK_ALLOC, ac->caller_addr, gfpflags);
> +		set_alloc_track(s, object, ac->caller_addr, gfpflags);
>  
>  	return object;
>  }
> -- 
> 2.50.1 (Apple Git-155)
> 

-- 
Thanks,
Hao

