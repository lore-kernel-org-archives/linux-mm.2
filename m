Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27A80F9EDEB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 14:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B1F6B009D; Wed, 22 Apr 2026 10:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912076B009E; Wed, 22 Apr 2026 10:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800D76B009F; Wed, 22 Apr 2026 10:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7336B009D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:42:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 056DD1401F2
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:42:36 +0000 (UTC)
X-FDA: 84686457912.11.523E8CD
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id C8B97160014
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:42:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X4LdNw5f;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776868954; a=rsa-sha256;
	cv=none;
	b=G6fRnVTRqCHlfIrETpTF+eHC2SCCBJ00ZbOUjlm1sHRi92tttkqTMju946osWiToMqg3OB
	TG7k29vh+S6g5UNPqzF7flHFwF5xMa0jbChX+WAPHAnMPeFJjMCjfhG4hW12t45a2vrOrc
	W3NIthYznkistZbocuY2zie0IQovLo0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X4LdNw5f;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776868954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SPbsrPGLG9xMvOdF2nLoe3SEbryafUSJDEvKzQRns/M=;
	b=ezFAQq7FHURP9DZDTIsZsnoWfmYp6OIuN+oW4q9olMxlAGNHXByj9rMG5rWcJY+MngZnnJ
	O3F1ucE+tikPjKXQo+8YO34iiuB1zOv/D4149guqJoPuRTPusMQairHMDBgCXgrfI4Uocn
	rJwZb7DAsTNOO4w59EniN6q56Qsyqbc=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a3cee3a271so5711850e87.3
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776868952; x=1777473752; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SPbsrPGLG9xMvOdF2nLoe3SEbryafUSJDEvKzQRns/M=;
        b=X4LdNw5fpAa3hxpB4yQMU6Y03cQZT5QeYzItyClGAz7rZjaVcm0hBhbj8IT5YSgeEz
         p7rjLmXSzuI2IKAUJhjuvNZCI7qZrUJI0kkCzoMN3P6hoRd3k4hGKkkBtKRtb880R2/w
         XQu+8lvBhzjdm/WFEn+nluwzL9XXiOzKNiVg12YZJUQAu62wxJIuSzkGpdkFbUTV9M3A
         cJJjA5yqZGoxxyXwgutfuA3tgKxu4LYl8hykUcYhrzP+eB+vZUmdxMfK81LWWSoQzlg5
         O0gumXQQW0tRVZAcUkvMpNEvhWoynKoAuCM+3ffo1uBTBwbdk9r5ixtAeCUbMen3Pgox
         tMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776868952; x=1777473752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SPbsrPGLG9xMvOdF2nLoe3SEbryafUSJDEvKzQRns/M=;
        b=DIgydSCKmthuRF+DJSx6MiFXo2Rn6zCHu82zR51is5y9ERSrGQKVodXNDjguezRXD4
         Tt+Zs0heiH0hRttP+z85s8mjt8m/b+lwbW0leBk0THTJY9waLtNqtwqOjVwj3lD93TZc
         HX/p7r07nZb225F2QFsbwu1VAZV37heL6/EOSCpyuGChqFIFHs1T8GesSLCilVmwrgd1
         SY+3Ljl05ARr8rZRT+Pfi5jflqNym1G8pA8co8aPhh5JImhUlRxK38BCiyqAL81gPYmT
         nZMCsKBmKDM8PUM3dt3WGdmSOeEwlmJZ72OgDVnEDMkrNtQVTQAsg90ZGWW9iAcqqlTQ
         q31w==
X-Forwarded-Encrypted: i=1; AFNElJ/K/3Fs/cfDLYaw+0r1gsR+EWzb6CfKGsLUDlsDYh7SnuPQLctIsZxs/iBhz8fkn9wdzkLHbhWt/A==@kvack.org
X-Gm-Message-State: AOJu0YyqoByWLo36btjIgJfig/09+RD9aUXMXunXQT0FC3u1x3lJDtbT
	/lp67AxR4bWRHuo1bSIGqwmKp5VgF7TOAwJrFuzvkC2J+4JanI1oxYRj
X-Gm-Gg: AeBDiesNEF7KFL9nChxspmZuRAwJOiCC9Aq6QB8Hz1QHwF3J7CX4hwOMD2KLlL0ol0D
	IVtJMcUbALfNp3TKk+zsXmRvEGCmp0t2tlvXcSS8fuf0q0WvSOVc1fONK/i4lqgKNOzupoQQpDP
	G16JpgsZ0yh3fV49NP1nXt9gCvLPFMXmHFACSdp1MYLi/HZeoOuofaDQDPAomRYGcl7KMOUDVdS
	ZQ2P7bpsUPagxWEljMCuH/ao5+JuTAjb/yrnmbeexlmWyLLXy3SStaPOwvbf3CIw/gCpin40WW1
	tcUEb7OBzKVmeyT+4auziC/kccqbPee4ubrIBCnotZG99WMdSgr+t7a43rCKYNuH/rvPFgATy3Q
	clinqldS0eOn/N6CwN+093lYOKmbOj1/XPj0zJMlD7tNUSb7C66q5NcILYBkO6u2rT9fcFWRtmn
	s=
X-Received: by 2002:a05:6512:159f:b0:5a3:f0f7:7da1 with SMTP id 2adb3069b0e04-5a4172cd17amr8844091e87.17.1776868951215;
        Wed, 22 Apr 2026 07:42:31 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4187e1248sm4469540e87.38.2026.04.22.07.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 07:42:30 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 22 Apr 2026 16:42:28 +0200
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <aejeVK0J_jHSfVhD@milan>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416091022.36823-5-harry@kernel.org>
X-Rspamd-Queue-Id: C8B97160014
X-Stat-Signature: 6u1oe6xisdkeqpow7udo3xmdye5ws47y
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776868953-156290
X-HE-Meta: U2FsdGVkX18vesJhI/MyDBOSevqLVj94dWEQ9wX9c+YYBR1/K+E8hWVyfPpdwjKRAlkeTuEoek9/BYauNnh0siJbfvoeoDjgxZjjZJWK6HVe8cHZ0y+9bK6kSeVgLaGFk7ahrw5L9HdowNxZPiYltvWoEnn1Oim+yOFUsVhCKYtUqGiV9Vu0ZJfBLquga8zSuzRxNHEd5axM5Bw8UWRupBbYn0+KKXgAKmTyjooiOQC7SDIUki34nXqFIBc3v7rXIdCwPGSIbx1h1QdP0kyNT09HgBJpqCOKCGCLU/N5zBnAyqCA9o006g8nyLASNOpxzp0THRteZh+ETg/nzEdHAQnin2rQ6TVvE4tVdsDgxMzmYFrg/9/HnWkp5ZNU5dUTfPUwprnTVT+RGxrAtypznPz8IAM5OQJ2OqZ0gG1ywWRqNEbhfzponPjwXZCeh/TTdsTsiKnZglBlbUxgFcEK5TTcs5hzf5Sp+b1/CG1xa9E9hItThUhTYGmtzHZjlT8mv8MBQmQAiE3sXH5f4Q3pqFwaQh1txyaRNsmzJz0IpPWWLfJ3YnsOn3+6ey3VtM2oB0Ss3HVnDZAUNug2HGeQ6F9Mt0LPjpk0g3e6X7TWwnSvXgLA3lN7JTIuIsqWDud4+SwGJa6FSGA7xVwKp+TR2UjPdSQzkC2bec/yj+3yvDjtV4e4Kjpqco5x3WgDn3mKB9iA/voVJVAWsQQ+45L65yu/m84hQTYg+OneXwLUpPwM5gcmYza0O6QXitPG7v1HVnyHZtqrnauk9cCjUnqeQw+Wg/sXLWKk8igVWA4o+jg7ODWqW60/JPM3JS97Z5y+Wg+LBL0YPWICexCxN71kL9tLLjU0V892UL1abX6YixcmbCBxmS87Ms8GL7oyYRFdrFALYjP/X3RTPvcNMQyypnpAh2o9l5Xnb8gaiBKvnl7kWM2AlOeBaWw0Ef4aec+DrHILIvKpYwFDKuH9C0n
 ya3qvoI8
 Ta8QZgr7y6dRF2ZSzmkmAR9jOme4dmtJ5R2FSRlCjZFLvbY7hf01K6fe5xHidK+bFma06hFDI+k0qJ1Tpi8qsTst535ZAYTZCTK890azUi53vUk98wTEQ02w3+ojDam1bpw7SN6jXaxarv5f8lr9/euAeBem1rhlD2p2/jKOqzpyuDUGfHFLyGcbNZXN3BqEWgg0fHL9XrMurdvtwaMx5eQBSuXvXY77rXgZishdT+Ftxp6pnNQ8XuH0aAWIH0VCOyVOFsiDZWuolde2LBzhl/+qqM0mr2vq2YI2hxV3MerKnQexT9SYej7tyWpBHd0f+V8u9Nbg1rLkV58DkbXh3R1ENRsp+tX//MC20x6E9MIWOw8vFSGsufGK4wAsQ1TkypqY0aX5SbpleLA7/2UX6i0PIEDFPv03Cggsp8W0Hd1ViPFEe32OsKiJ0a/RnxitAA9a1TD9uo5u8r7z2JJDITqdkH6ZtpzKCTNRXNlCBln9d4g/8D7doVFDpTpWoKX5K2GGI8V5eMg05syEyCOdYSkurlo+WWndc/lD6lzGkntYG5Xg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 06:10:18PM +0900, Harry Yoo (Oracle) wrote:
> Currently, kfree_rcu() cannot be called when the context is unknown,
> which might not allow spinning on a lock. In such an unknown
> context, even calling call_rcu() is not legal, forcing users to
> implement some sort of deferred freeing.
> 
> Make users' lives easier by introducing kfree_rcu_nolock() variant.
> It passes allow_spin = false to kvfree_call_rcu(), which means spinning
> on a lock is not allowed because the context is unknown.
> 
> Unlike kfree_rcu(), kfree_rcu_nolock() only supports a 2-argument
> variant because, in the worst case where memory allocation fails,
> the caller cannot synchronously wait for the grace period to finish.
> 
> kfree_rcu_nolock() tries to acquire kfree_rcu_cpu spinlock.
> When trylock succeeds, get a cached bnode and use it to store the
> pointer. Just like existing kvfree_rcu() with 2-arg variant, fall back
> if there's no cached bnode available.
> 
> If trylock fails, insert the object to the per-cpu lockless list
> and defer freeing using irq_work that calls kvfree_call_rcu() later.
> Note that in the most of the cases the context allows spinning,
> and thus it is worth trying to acquire the lock.
> 
> To ensure rcu sheaves are flushed in flush_rcu_all_sheaves() and
> flush_rcu_sheaves_on_cache(), deferred objects must be processed before
> calling them. Otherwise, irq work might insert objects to a sheaf and
> end up not flushing it. Implement a defer_kvfree_rcu_barrier() and
> call it before flushing rcu sheaves.
> 
> In case kmemleak or debug objects is enabled, always defer freeing as
> those debug features use spinlocks.
> 
> Determine whether work items (page cache worker or delayed monitor) need
> to be queued under krcp->lock. If so, use irq_work to defer the actual
> work submission. The existing logic prevents excessive irq_work
> queueing.
> 
> For now, the sheaves layer is bypassed if spinning is not allowed.
> 
> Without CONFIG_KVFREE_RCU_BATCHED, all frees in the !allow_spin case are
> deferred using irq_work. Move kvfree_rcu_barrier[_on_cache]() to
> mm/slab_common.c and let them wait for irq_works.
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  include/linux/rcupdate.h |  23 ++--
>  include/linux/slab.h     |  16 +--
>  mm/slab.h                |   1 +
>  mm/slab_common.c         | 260 +++++++++++++++++++++++++++++++--------
>  mm/slub.c                |   6 +-
>  5 files changed, 231 insertions(+), 75 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 3ca82500a19f..8776b2a394bb 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -1090,8 +1090,9 @@ static inline void rcu_read_unlock_migrate(void)
>   * The BUILD_BUG_ON check must not involve any function calls, hence the
>   * checks are done in macros here.
>   */
> -#define kfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf)
> -#define kvfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf)
> +#define kfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf, true)
> +#define kfree_rcu_nolock(ptr, rf) kvfree_rcu_arg_2(ptr, rf, false)
> +#define kvfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf, true)
>  
>  /**
>   * kfree_rcu_mightsleep() - kfree an object after a grace period.
> @@ -1115,35 +1116,35 @@ static inline void rcu_read_unlock_migrate(void)
>  
>  
>  #ifdef CONFIG_KVFREE_RCU_BATCHED
> -void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr);
> -#define kvfree_call_rcu(head, ptr) \
> +void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr, bool allow_spin);
> +#define kvfree_call_rcu(head, ptr, spin) \
>  	_Generic((head), \
>  		struct rcu_head *: kvfree_call_rcu_ptr,		\
>  		struct rcu_ptr *: kvfree_call_rcu_ptr,		\
>  		void *: kvfree_call_rcu_ptr			\
> -	)((struct rcu_ptr *)(head), (ptr))
> +	)((struct rcu_ptr *)(head), (ptr), spin)
>  #else
> -void kvfree_call_rcu_head(struct rcu_head *head, void *ptr);
> +void kvfree_call_rcu_head(struct rcu_head *head, void *ptr, bool allow_spin);
>  static_assert(sizeof(struct rcu_head) == sizeof(struct rcu_ptr));
> -#define kvfree_call_rcu(head, ptr) \
> +#define kvfree_call_rcu(head, ptr, spin) \
>  	_Generic((head), \
>  		struct rcu_head *: kvfree_call_rcu_head,	\
>  		struct rcu_ptr *: kvfree_call_rcu_head,		\
>  		void *: kvfree_call_rcu_head			\
> -	)((struct rcu_head *)(head), (ptr))
> +	)((struct rcu_head *)(head), (ptr), spin)
>  #endif
>  
>  /*
>   * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
>   * comment of kfree_rcu() for details.
>   */
> -#define kvfree_rcu_arg_2(ptr, rf)					\
> +#define kvfree_rcu_arg_2(ptr, rf, spin)					\
>  do {									\
>  	typeof (ptr) ___p = (ptr);					\
>  									\
>  	if (___p) {							\
>  		BUILD_BUG_ON(offsetof(typeof(*(ptr)), rf) >= 4096);	\
> -		kvfree_call_rcu(&((___p)->rf), (void *) (___p));	\
> +		kvfree_call_rcu(&((___p)->rf), (void *) (___p), spin);	\
>  	}								\
>  } while (0)
>  
> @@ -1152,7 +1153,7 @@ do {								\
>  	typeof(ptr) ___p = (ptr);				\
>  								\
>  	if (___p)						\
> -		kvfree_call_rcu(NULL, (void *) (___p));		\
> +		kvfree_call_rcu(NULL, (void *) (___p), true);	\
>  } while (0)
>  
>  /*
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 15a60b501b95..67528f698fe2 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -1238,23 +1238,13 @@ extern void kvfree_sensitive(const void *addr, size_t len);
>  
>  unsigned int kmem_cache_size(struct kmem_cache *s);
>  
> -#ifndef CONFIG_KVFREE_RCU_BATCHED
> -static inline void kvfree_rcu_barrier(void)
> -{
> -	rcu_barrier();
> -}
> -
> -static inline void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
> -{
> -	rcu_barrier();
> -}
> -
> -static inline void kfree_rcu_scheduler_running(void) { }
> -#else
>  void kvfree_rcu_barrier(void);
>  
>  void kvfree_rcu_barrier_on_cache(struct kmem_cache *s);
>  
> +#ifndef CONFIG_KVFREE_RCU_BATCHED
> +static inline void kfree_rcu_scheduler_running(void) { }
> +#else
>  void kfree_rcu_scheduler_running(void);
>  #endif
>  
> diff --git a/mm/slab.h b/mm/slab.h
> index c735e6b4dddb..ae2e990e8dc2 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -412,6 +412,7 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
>  bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
>  void flush_all_rcu_sheaves(void);
>  void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
> +void defer_kvfree_rcu_barrier(void);
>  
>  #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
>  			 SLAB_CACHE_DMA32 | SLAB_PANIC | \
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index cddbf3279c13..e840956233dd 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1311,6 +1311,14 @@ struct kfree_rcu_cpu_work {
>   * the interactions with the slab allocators.
>   */
>  struct kfree_rcu_cpu {
> +	// Objects queued on a lockless linked list, used to free objects
> +	// in unknown contexts when trylock fails.
> +	struct llist_head defer_head;
> +
> +	struct irq_work defer_free;
> +	struct irq_work sched_delayed_monitor;
> +	struct irq_work run_page_cache_worker;
> +
>  	// Objects queued on a linked list
>  	struct rcu_ptr *head;
>  	unsigned long head_gp_snap;
> @@ -1333,12 +1341,99 @@ struct kfree_rcu_cpu {
>  	struct llist_head bkvcache;
>  	int nr_bkv_objs;
>  };
> +
> +static void defer_kfree_rcu_irq_work_fn(struct irq_work *work);
> +static void sched_delayed_monitor_irq_work_fn(struct irq_work *work);
> +static void run_page_cache_worker_irq_work_fn(struct irq_work *work);
> +
> +static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
> +	.lock = __RAW_SPIN_LOCK_UNLOCKED(krc.lock),
> +	.defer_head = LLIST_HEAD_INIT(defer_head),
> +	.defer_free = IRQ_WORK_INIT(defer_kfree_rcu_irq_work_fn),
> +	.sched_delayed_monitor =
> +		IRQ_WORK_INIT_LAZY(sched_delayed_monitor_irq_work_fn),
> +	.run_page_cache_worker =
> +		IRQ_WORK_INIT_LAZY(run_page_cache_worker_irq_work_fn),
> +};
> +#else
> +struct kfree_rcu_cpu {
> +	struct llist_head defer_head;
> +	struct irq_work defer_free;
> +};
> +
> +static void defer_kfree_rcu_irq_work_fn(struct irq_work *work);
> +
> +static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
> +	.defer_head = LLIST_HEAD_INIT(defer_head),
> +	.defer_free = IRQ_WORK_INIT(defer_kfree_rcu_irq_work_fn),
> +};
>  #endif
>  
> -#ifndef CONFIG_KVFREE_RCU_BATCHED
> +/* Wait for deferred work from kfree_rcu_nolock() */
> +void defer_kvfree_rcu_barrier(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		irq_work_sync(&per_cpu_ptr(&krc, cpu)->defer_free);
> +}
> +
> +static void *object_start_addr(void *ptr)
> +{
> +	struct slab *slab;
> +	void *start;
> +
> +	if (is_vmalloc_addr(ptr)) {
> +		start  = (void *)PAGE_ALIGN_DOWN((unsigned long)ptr);
> +	} else {
> +		slab = virt_to_slab(ptr);
> +		if (!slab)
> +			start = (void *)PAGE_ALIGN_DOWN((unsigned long)ptr);
> +		else if (is_kfence_address(ptr))
> +			start = kfence_object_start(ptr);
> +		else
> +			start = nearest_obj(slab->slab_cache, slab, ptr);
> +	}
>  
> -void kvfree_call_rcu_head(struct rcu_head *head, void *ptr)
> +	return start;
> +}
> +
> +static void defer_kfree_rcu_irq_work_fn(struct irq_work *work)
>  {
> +	struct kfree_rcu_cpu *krcp;
> +	struct llist_head *head;
> +	struct llist_node *llnode, *pos, *t;
> +
> +	krcp = container_of(work, struct kfree_rcu_cpu, defer_free);
> +	head = &krcp->defer_head;
> +
> +	if (llist_empty(head))
> +		return;
> +
> +	llnode = llist_del_all(head);
> +	llist_for_each_safe(pos, t, llnode) {
> +		void *objp;
> +		struct rcu_ptr *rcup = (struct rcu_ptr *)pos;
> +
> +		objp = object_start_addr(rcup);
> +		kvfree_call_rcu(rcup, objp, true);
> +	}
> +}
> +
> +#ifndef CONFIG_KVFREE_RCU_BATCHED
> +void kvfree_call_rcu_head(struct rcu_head *head, void *ptr, bool allow_spin)
> +{
> +	if (!allow_spin) {
> +		struct kfree_rcu_cpu *krcp;
> +
> +		guard(preempt)();
> +
> +		krcp = this_cpu_ptr(&krc);
> +		if (llist_add((struct llist_node *)head, &krcp->defer_head))
> +			irq_work_queue(&krcp->defer_free);
> +		return;
> +	}
> +
>  	if (head) {
>  		kasan_record_aux_stack(ptr);
>  		call_rcu(head, kvfree_rcu_cb);
> @@ -1356,6 +1451,19 @@ void __init kvfree_rcu_init(void)
>  {
>  }
>  
> +void kvfree_rcu_barrier(void)
> +{
> +	defer_kvfree_rcu_barrier();
> +	rcu_barrier();
> +}
> +EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
> +
> +void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
> +{
> +	kvfree_rcu_barrier();
> +}
> +EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
> +
>  #else /* CONFIG_KVFREE_RCU_BATCHED */
>  
>  /*
> @@ -1405,9 +1513,16 @@ struct kvfree_rcu_bulk_data {
>  #define KVFREE_BULK_MAX_ENTR \
>  	((PAGE_SIZE - sizeof(struct kvfree_rcu_bulk_data)) / sizeof(void *))
>  
> -static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
> -	.lock = __RAW_SPIN_LOCK_UNLOCKED(krc.lock),
> -};
> +
> +static void schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp);
> +
> +static void sched_delayed_monitor_irq_work_fn(struct irq_work *work)
> +{
> +	struct kfree_rcu_cpu *krcp;
> +
> +	krcp = container_of(work, struct kfree_rcu_cpu, sched_delayed_monitor);
> +	schedule_delayed_monitor_work(krcp);
> +}
>  
>  static __always_inline void
>  debug_rcu_bhead_unqueue(struct kvfree_rcu_bulk_data *bhead)
> @@ -1421,13 +1536,18 @@ debug_rcu_bhead_unqueue(struct kvfree_rcu_bulk_data *bhead)
>  }
>  
>  static inline struct kfree_rcu_cpu *
> -krc_this_cpu_lock(unsigned long *flags)
> +krc_this_cpu_lock(unsigned long *flags, bool allow_spin)
>  {
>  	struct kfree_rcu_cpu *krcp;
>  
>  	local_irq_save(*flags);	// For safely calling this_cpu_ptr().
>  	krcp = this_cpu_ptr(&krc);
> -	raw_spin_lock(&krcp->lock);
> +	if (allow_spin) {
> +		raw_spin_lock(&krcp->lock);
> +	} else if (!raw_spin_trylock(&krcp->lock)) {
> +		local_irq_restore(*flags);
> +		return NULL;
> +	}
>  
>  	return krcp;
>  }
> @@ -1531,20 +1651,8 @@ kvfree_rcu_list(struct rcu_ptr *head)
>  	for (; head; head = next) {
>  		void *ptr;
>  		unsigned long offset;
> -		struct slab *slab;
> -
> -		if (is_vmalloc_addr(head)) {
> -			ptr = (void *)PAGE_ALIGN_DOWN((unsigned long)head);
> -		} else {
> -			slab = virt_to_slab(head);
> -			if (!slab)
> -				ptr = (void *)PAGE_ALIGN_DOWN((unsigned long)head);
> -			else if (is_kfence_address(head))
> -				ptr = kfence_object_start(head);
> -			else
> -				ptr = nearest_obj(slab->slab_cache, slab, head);
> -		}
>  
> +		ptr = object_start_addr(head);
>  		offset = (void *)head - ptr;
>  		next = head->next;
>  		debug_rcu_head_unqueue((struct rcu_head *)ptr);
> @@ -1663,18 +1771,26 @@ static int krc_count(struct kfree_rcu_cpu *krcp)
>  }
>  
>  static void
> -__schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp)
> +__schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp, bool allow_spin)
>  {
>  	long delay, delay_left;
>  
>  	delay = krc_count(krcp) >= KVFREE_BULK_MAX_ENTR ? 1:KFREE_DRAIN_JIFFIES;
>  	if (delayed_work_pending(&krcp->monitor_work)) {
>  		delay_left = krcp->monitor_work.timer.expires - jiffies;
> -		if (delay < delay_left)
> -			mod_delayed_work(rcu_reclaim_wq, &krcp->monitor_work, delay);
> +		if (delay < delay_left) {
> +			if (allow_spin)
> +				mod_delayed_work(rcu_reclaim_wq, &krcp->monitor_work, delay);
> +			else
> +				irq_work_queue(&krcp->sched_delayed_monitor);
> +		}
>  		return;
>  	}
> -	queue_delayed_work(rcu_reclaim_wq, &krcp->monitor_work, delay);
> +
> +	if (allow_spin)
> +		queue_delayed_work(rcu_reclaim_wq, &krcp->monitor_work, delay);
> +	else
> +		irq_work_queue(&krcp->sched_delayed_monitor);
>  }
>  
>  static void
> @@ -1683,7 +1799,7 @@ schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp)
>  	unsigned long flags;
>  
>  	raw_spin_lock_irqsave(&krcp->lock, flags);
> -	__schedule_delayed_monitor_work(krcp);
> +	__schedule_delayed_monitor_work(krcp, true);
>  	raw_spin_unlock_irqrestore(&krcp->lock, flags);
>  }
>  
> @@ -1847,25 +1963,25 @@ static void fill_page_cache_func(struct work_struct *work)
>  // Returns true if ptr was successfully recorded, else the caller must
>  // use a fallback.
>  static inline bool
> -add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu **krcp,
> -	unsigned long *flags, void *ptr, bool can_alloc)
> +add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu *krcp,
> +	unsigned long *flags, void *ptr, bool can_alloc, bool allow_spin)
>  {
>  	struct kvfree_rcu_bulk_data *bnode;
>  	int idx;
>  
> -	*krcp = krc_this_cpu_lock(flags);
> -	if (unlikely(!(*krcp)->initialized))
> +	if (unlikely(!krcp->initialized))
>  		return false;
>  
>  	idx = !!is_vmalloc_addr(ptr);
> -	bnode = list_first_entry_or_null(&(*krcp)->bulk_head[idx],
> +	bnode = list_first_entry_or_null(&krcp->bulk_head[idx],
>  		struct kvfree_rcu_bulk_data, list);
>  
>  	/* Check if a new block is required. */
>  	if (!bnode || bnode->nr_records == KVFREE_BULK_MAX_ENTR) {
> -		bnode = get_cached_bnode(*krcp);
> +		bnode = get_cached_bnode(krcp);
>  		if (!bnode && can_alloc) {
> -			krc_this_cpu_unlock(*krcp, *flags);
> +			krc_this_cpu_unlock(krcp, *flags);
> +			VM_WARN_ON_ONCE(!allow_spin);
>  
>  			// __GFP_NORETRY - allows a light-weight direct reclaim
>  			// what is OK from minimizing of fallback hitting point of
> @@ -1880,7 +1996,7 @@ add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu **krcp,
>  			// scenarios.
>  			bnode = (struct kvfree_rcu_bulk_data *)
>  				__get_free_page(GFP_KERNEL | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> -			raw_spin_lock_irqsave(&(*krcp)->lock, *flags);
> +			raw_spin_lock_irqsave(&krcp->lock, *flags);
>  		}
>  
>  		if (!bnode)
> @@ -1888,14 +2004,14 @@ add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu **krcp,
>  
>  		// Initialize the new block and attach it.
>  		bnode->nr_records = 0;
> -		list_add(&bnode->list, &(*krcp)->bulk_head[idx]);
> +		list_add(&bnode->list, &krcp->bulk_head[idx]);
>  	}
>  
>  	// Finally insert and update the GP for this page.
>  	bnode->nr_records++;
>  	bnode->records[bnode->nr_records - 1] = ptr;
>  	get_state_synchronize_rcu_full(&bnode->gp_snap);
> -	atomic_inc(&(*krcp)->bulk_count[idx]);
> +	atomic_inc(&krcp->bulk_count[idx]);
>  
>  	return true;
>  }
> @@ -1911,7 +2027,32 @@ schedule_page_work_fn(struct hrtimer *t)
>  }
>  
>  static void
> -run_page_cache_worker(struct kfree_rcu_cpu *krcp)
> +__run_page_cache_worker(struct kfree_rcu_cpu *krcp)
> +{
> +	if (atomic_read(&krcp->backoff_page_cache_fill)) {
> +		queue_delayed_work(rcu_reclaim_wq,
> +			&krcp->page_cache_work,
> +				msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
> +	} else {
> +		hrtimer_setup(&krcp->hrtimer, schedule_page_work_fn, CLOCK_MONOTONIC,
> +			      HRTIMER_MODE_REL);
> +		hrtimer_start(&krcp->hrtimer, 0, HRTIMER_MODE_REL);
> +	}
> +}
> +
> +static void run_page_cache_worker_irq_work_fn(struct irq_work *work)
> +{
> +	unsigned long flags;
> +	struct kfree_rcu_cpu *krcp =
> +		container_of(work, struct kfree_rcu_cpu, run_page_cache_worker);
> +
> +	raw_spin_lock_irqsave(&krcp->lock, flags);
> +	__run_page_cache_worker(krcp);
> +	raw_spin_unlock_irqrestore(&krcp->lock, flags);
> +}
> +
> +static void
> +run_page_cache_worker(struct kfree_rcu_cpu *krcp, bool allow_spin)
>  {
>  	// If cache disabled, bail out.
>  	if (!rcu_min_cached_objs)
> @@ -1919,15 +2060,10 @@ run_page_cache_worker(struct kfree_rcu_cpu *krcp)
>  
>  	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
>  			!atomic_xchg(&krcp->work_in_progress, 1)) {
> -		if (atomic_read(&krcp->backoff_page_cache_fill)) {
> -			queue_delayed_work(rcu_reclaim_wq,
> -				&krcp->page_cache_work,
> -					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
> -		} else {
> -			hrtimer_setup(&krcp->hrtimer, schedule_page_work_fn, CLOCK_MONOTONIC,
> -				      HRTIMER_MODE_REL);
> -			hrtimer_start(&krcp->hrtimer, 0, HRTIMER_MODE_REL);
> -		}
> +		if (allow_spin)
> +			__run_page_cache_worker(krcp);
> +		else
> +			irq_work_queue(&krcp->run_page_cache_worker);
>  	}
>  }
>  
> @@ -1955,7 +2091,7 @@ void __init kfree_rcu_scheduler_running(void)
>   * be free'd in workqueue context. This allows us to: batch requests together to
>   * reduce the number of grace periods during heavy kfree_rcu()/kvfree_rcu() load.
>   */
> -void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
> +void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr, bool allow_spin)
>  {
>  	unsigned long flags;
>  	struct kfree_rcu_cpu *krcp;
> @@ -1971,7 +2107,12 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
>  	if (!head)
>  		might_sleep();
>  
> -	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
> +	if (!allow_spin && (IS_ENABLED(CONFIG_DEBUG_OBJECTS_RCU_HEAD) ||
> +				IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)))
> +		goto defer_free;
> +
> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
> +			(allow_spin && kfree_rcu_sheaf(ptr)))
>  		return;
>  
>  	// Queue the object but don't yet schedule the batch.
> @@ -1985,9 +2126,14 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
>  	}
>  
>  	kasan_record_aux_stack(ptr);
> -	success = add_ptr_to_bulk_krc_lock(&krcp, &flags, ptr, !head);
> +
> +	krcp = krc_this_cpu_lock(&flags, allow_spin);
> +	if (!krcp)
> +		goto defer_free;
> +
> +	success = add_ptr_to_bulk_krc_lock(krcp, &flags, ptr, !head, allow_spin);
>  	if (!success) {
> -		run_page_cache_worker(krcp);
> +		run_page_cache_worker(krcp, allow_spin);
>  
>  		if (head == NULL)
>  			// Inline if kvfree_rcu(one_arg) call.
> @@ -2012,7 +2158,7 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
>  
>  	// Set timer to drain after KFREE_DRAIN_JIFFIES.
>  	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING)
> -		__schedule_delayed_monitor_work(krcp);
> +		__schedule_delayed_monitor_work(krcp, allow_spin);
>  
>  unlock_return:
>  	krc_this_cpu_unlock(krcp, flags);
> @@ -2023,10 +2169,22 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
>  	 * CPU can pass the QS state.
>  	 */
>  	if (!success) {
> +		VM_WARN_ON_ONCE(!allow_spin);
>  		debug_rcu_head_unqueue((struct rcu_head *) ptr);
>  		synchronize_rcu();
>  		kvfree(ptr);
>  	}
> +	return;
> +
> +defer_free:
> +	VM_WARN_ON_ONCE(allow_spin);
> +	guard(preempt)();
> +
> +	krcp = this_cpu_ptr(&krc);
> +	if (llist_add((struct llist_node *)head, &krcp->defer_head))
> +		irq_work_queue(&krcp->defer_free);
> +	return;
> +
>  }
>  EXPORT_SYMBOL_GPL(kvfree_call_rcu_ptr);
>  
> @@ -2125,6 +2283,8 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>   */
>  void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>  {
> +	defer_kvfree_rcu_barrier();
> +
>  	if (cache_has_sheaves(s)) {
>  		flush_rcu_sheaves_on_cache(s);
>  		rcu_barrier();
> diff --git a/mm/slub.c b/mm/slub.c
> index 92362eeb13e5..6f658ec00751 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4018,7 +4018,10 @@ static void flush_rcu_sheaf(struct work_struct *w)
>  }
>  
>  
> -/* needed for kvfree_rcu_barrier() */
> +/*
> + * Needed for kvfree_rcu_barrier(). The caller should invoke
> + * defer_kvfree_rcu_barrier() before calling this function.
> + */
>  void flush_rcu_sheaves_on_cache(struct kmem_cache *s)
>  {
>  	struct slub_flush_work *sfw;
> @@ -4053,6 +4056,7 @@ void flush_all_rcu_sheaves(void)
>  {
>  	struct kmem_cache *s;
>  
> +	defer_kvfree_rcu_barrier();
>  	cpus_read_lock();
>  	mutex_lock(&slab_mutex);
>  
> -- 
> 2.43.0
> 
As discussed or noted earlier, having third argument and check the
entire path with "if (allow_spin)" is not optimal and is not good
approach. I do not think it this would be a good fit for mainline.

Also, re-entering the same path with allow_spin = false feels awkward.

I think a better option is to add a separate kvfree_rcu_nmi() helper,
or similar, and avoid complicating the generic implementation. Otherwise,
the common path risks becoming harder to maintain.

Below is a simple implementation.

<patch>
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 04f3f86a4145..a9d674b9b806 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1109,6 +1109,7 @@ static inline void rcu_read_unlock_migrate(void)
  * In mm/slab_common.c, no suitable header to include here.
  */
 void kvfree_call_rcu(struct rcu_head *head, void *ptr);
+void kvfree_call_rcu_nolock(struct rcu_head *head, void *ptr);
 
 /*
  * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
@@ -1132,6 +1133,16 @@ do {								\
 		kvfree_call_rcu(NULL, (void *) (___p));		\
 } while (0)
 
+#define kvfree_rcu_nmi(ptr, rhf)					\
+do {									\
+	typeof (ptr) ___p = (ptr);					\
+									\
+	if (___p) {							\
+		BUILD_BUG_ON(offsetof(typeof(*(ptr)), rhf) >= 4096);	\
+		kvfree_call_rcu_nolock(&((___p)->rhf), (void *) (___p));\
+	}								\
+} while (0)
+
 /*
  * Place this after a lock-acquisition primitive to guarantee that
  * an UNLOCK+LOCK pair acts as a full barrier.  This guarantee applies
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..f6ae3795ec6c 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1402,6 +1402,14 @@ struct kfree_rcu_cpu {
 
 	struct llist_head bkvcache;
 	int nr_bkv_objs;
+
+	/* For NMI context. */
+	struct llist_head drain_list;
+	struct llist_node *pending_list;
+
+	struct rcu_work drain_rcu_work;
+	struct irq_work drain_irqwork;
+	atomic_t drain_in_progress;
 };
 
 static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
@@ -1926,6 +1934,69 @@ void __init kfree_rcu_scheduler_running(void)
 	}
 }
 
+static void
+kvfree_rcu_nolock_work(struct work_struct *work)
+{
+	struct kfree_rcu_cpu *krcp = container_of(to_rcu_work(work),
+		struct kfree_rcu_cpu, drain_rcu_work);
+	struct llist_node *pos, *n, *pending;
+	bool queued;
+
+	pending = krcp->pending_list;
+	krcp->pending_list = NULL;
+	ASSERT_EXCLUSIVE_WRITER(krcp->pending_list);
+
+	llist_for_each_safe(pos, n, pending) {
+		struct rcu_head *rcu = (struct rcu_head *) pos;
+		void *ptr = (void *) rcu->func;
+		kvfree(ptr);
+	}
+
+	atomic_set(&krcp->drain_in_progress, 0);
+	if (!llist_empty(&krcp->drain_list)) {
+		if (!atomic_cmpxchg(&krcp->drain_in_progress, 0, 1)) {
+			krcp->pending_list = llist_del_all(&krcp->drain_list);
+			ASSERT_EXCLUSIVE_WRITER(krcp->pending_list);
+			queued = queue_rcu_work(rcu_reclaim_wq, &krcp->drain_rcu_work);
+			WARN_ON_ONCE(!queued);
+		}
+	}
+}
+
+static void
+kvfree_rcu_nolock_irqwork(struct irq_work *irqwork)
+{
+	struct kfree_rcu_cpu *krcp =
+		container_of(irqwork, struct kfree_rcu_cpu, drain_irqwork);
+	bool queued;
+
+	krcp->pending_list = llist_del_all(&krcp->drain_list);
+	ASSERT_EXCLUSIVE_WRITER(krcp->pending_list);
+
+	queued = queue_rcu_work(rcu_reclaim_wq, &krcp->drain_rcu_work);
+	WARN_ON_ONCE(!queued);
+}
+
+/*
+ * Queue a request for lazy invocation.
+ * Context: For NMI contexts or unknown contexts only.
+ */
+void
+kvfree_call_rcu_nolock(struct rcu_head *head, void *ptr)
+{
+	struct kfree_rcu_cpu *krcp = this_cpu_ptr(&krc);
+
+	head->func = ptr;
+	llist_add((struct llist_node *) head, &krcp->drain_list);
+
+	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING) {
+		/* Only first(and only one) user rings the bell. */
+		if (!atomic_cmpxchg(&krcp->drain_in_progress, 0, 1))
+			irq_work_queue(&krcp->drain_irqwork);
+	}
+}
+EXPORT_SYMBOL_GPL(kvfree_call_rcu_nolock);
+
 /*
  * Queue a request for lazy invocation of the appropriate free routine
  * after a grace period.  Please note that three paths are maintained,
@@ -2201,6 +2272,10 @@ void __init kvfree_rcu_init(void)
 
 		INIT_DELAYED_WORK(&krcp->monitor_work, kfree_rcu_monitor);
 		INIT_DELAYED_WORK(&krcp->page_cache_work, fill_page_cache_func);
+
+		/* For NMI part. */
+		INIT_RCU_WORK(&krcp->drain_rcu_work, kvfree_rcu_nolock_work);
+		init_irq_work(&krcp->drain_irqwork, kvfree_rcu_nolock_irqwork);
 		krcp->initialized = true;
 	}
<patch>

I can prepare a patch to handle NMI safe or unknown contexts.

--
Uladzislau Rezki

