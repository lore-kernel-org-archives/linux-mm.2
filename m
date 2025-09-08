Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B1A2CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78228E0008; Mon,  8 Sep 2025 13:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28C88E0001; Mon,  8 Sep 2025 13:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966068E0008; Mon,  8 Sep 2025 13:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 833F68E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:32:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30A38140221
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:32:42 +0000 (UTC)
X-FDA: 83866777764.24.2477B34
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 180D840013
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:32:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PaPT8sxo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757352760; a=rsa-sha256;
	cv=none;
	b=oHy8fj0uNtVKbK8k3NKY1RYCvyQjv6o/xkeHZAVnC8lsVVMayGebsllBYi+SKHQIOAQh2p
	FJn+KBJLW0ClZ5Euw6D/L5H/D3REg6UnkOoiCQquyYn7K3pRUAIOBZ30anIVN58wY93Fbd
	IOqki7j20Kwd7UTO73fxV+ZJkQApGVg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PaPT8sxo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757352760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zv9Ta4mThEV4XBqO1qxHvbCXn2hXPpn499vn6yt4SLY=;
	b=aaVDnNNnc/Ta4v8lpSeUVTclfDGcF9fhA/fUNMQjRWc6CxQqD864LV3L3ZlbqcAgIYnyXm
	wBRqVfQV/nAd41j5o9fTuL7F0eFtQemaGn36gNRXwP28NoouRBtuN7gV0G6psFqbJJvkPg
	WDuSegdjqbpwpyMB4kzazFIlAK8iYm4=
Date: Mon, 8 Sep 2025 10:32:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757352757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zv9Ta4mThEV4XBqO1qxHvbCXn2hXPpn499vn6yt4SLY=;
	b=PaPT8sxopmQs/goLFGqee+bzc4AGGChuBX+kzsBj8jmIJC4SPTpG5yEe882ldBSHcRVJZR
	9pXtxwb4Ye35WfAxVQOi2FCCVznhXNbfonLQctD629gDl/xwxqLvkJJRQc7p/BW6cMIaue
	pEzPqDtRAWRdjPVpinx034Gbnk2rRK0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peilin Ye <yepeilin@google.com>
Cc: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>, 
	linux-mm@kvack.org
Subject: Re: [PATCH bpf] bpf/helpers: Use __GFP_HIGH instead of GFP_ATOMIC in
 __bpf_async_init()
Message-ID: <b634rejnvxqu6knjqlijosxrcnxbbpagt4de4pl6env6dwldz2@hoofqufparh5>
References: <20250905234547.862249-1-yepeilin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905234547.862249-1-yepeilin@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 180D840013
X-Stat-Signature: r61ct9ott6qn93xcpdshqj7cmn5zymfa
X-Rspam-User: 
X-HE-Tag: 1757352759-889324
X-HE-Meta: U2FsdGVkX19uFPxSR+MblWF83Pob0ouRdAavW6ayPeiw6M90ezZtoBYf5fplU+LpMcBrnQOQrp1AfdLGnX1nPzb2F39YJHEQGIGENEIFkWaQNkVcYQDG8J4yZXdhgSFaRFctwXkgpVvrGDOWDcClXf7+BUiFyWiboSEV1NzfXr3raSWcM4craG4i+uv7HhcioTVQGTWqbtduknnLHW2iCjRKmpkBVHCYbqugsTQQUTzlyK7m58Mfuz4eDIPTQwh9Um0ChLVnHcOEIFzG+t6g8UDGynviv9baPvnrZOvtRt2j5LQ4vniHx99r8LLyd8rG0xOUKc79hlEXbnerzPVI94Nn9E5J/9f7tfHUpwcpyUZjRrkzRHCXnEMgSKVX99ccjryGFbcTKnYb7eWRoUyjUpLe1QM0DwOxBDp/Z5B93BWeu/voBQfG2Xoa0uC8XGfCybrEkwBHNydsCXpRpFMH6/I83U5sswOTvqRU4GU7gTAjvRB6VjgFOM6L9CAYlAkgkVUcHkUrAAmdJPmlGHzcbQqNiwMzf6fyBy7Ou9UcvK754KHwGyUPlPAobXMxjxuw4ldqnIP5xct0tINlBbxRP/sS8a6zS3ib7QJ5WtCMOnM9d2Q+7VYMfWokeoUT8lPu8nGI2t9UXubdAQYajLJfQOml0CJeyhyW+kMsJRhNQ5/I4+ZnXmx9LMFq8dMWNJk0zW6ZKqmyiyek7j47jUJhOtv9gjv4mJ5HT1z05o6BrouLFhUHz7hqhKz9PtnAntzkDBGQwxeCwS/7UB2omBucgg94h5D/D4fhOAKNHr22tRiFOhNxBJP+shUoNtRomsejy0I7/tTsYeVvzdBcLdi1qSVd5QK4FuoMHnToEP0kVohtkRLggaRiRftQ+qOfzKVL8olvnZmKV+Vb2wYXNZx5J6NLpeOojaT49O+R7crNHd8qNSWI3vkNDhbhjw9/KurBr85H7wW+dte0TwdWNte
 7lqT/Vq1
 m4YpVViUjK4VPXlJawZxBin6oYE3Ps96DcquuhdlHzGTVLf6q7NS25PIQmb1gCPHFakHQOPxS8ozHB3/pxMpy2hid5IYrFinu70LUaDfFZRi6PlSyfw69zlrDZsEjNNyWCRko+Kb0PLA+rWWwn9CUG5ybDUwVgilm7wMIP5WaNiuohObuG3N/rkkGYhZpa+4YTInFsPBp1s2CgJFGYUXkBf9IhqWecaV0ITGLsuTjmcNcwFzVMYG827PhVqvlfKhUqEUzQaPZVLkexqFZOt3idygZXazQhzlGH5zocKwjv9NUAobbhXdC9dp2KczXyXf/GvF+PnH4Mo4ffirc5pzPemfIVYTcPvvI43A3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 11:45:46PM +0000, Peilin Ye wrote:
> Currently, calling bpf_map_kmalloc_node() from __bpf_async_init() can
> cause various locking issues; see the following stack trace (edited for
> style) as one example:
> 
> ...
>  [10.011566]  do_raw_spin_lock.cold
>  [10.011570]  try_to_wake_up             (5) double-acquiring the same
>  [10.011575]  kick_pool                      rq_lock, causing a hardlockup
>  [10.011579]  __queue_work
>  [10.011582]  queue_work_on
>  [10.011585]  kernfs_notify
>  [10.011589]  cgroup_file_notify
>  [10.011593]  try_charge_memcg           (4) memcg accounting raises an
>  [10.011597]  obj_cgroup_charge_pages        MEMCG_MAX event
>  [10.011599]  obj_cgroup_charge_account
>  [10.011600]  __memcg_slab_post_alloc_hook
>  [10.011603]  __kmalloc_node_noprof
> ...
>  [10.011611]  bpf_map_kmalloc_node
>  [10.011612]  __bpf_async_init
>  [10.011615]  bpf_timer_init             (3) BPF calls bpf_timer_init()
>  [10.011617]  bpf_prog_xxxxxxxxxxxxxxxx_fcg_runnable
>  [10.011619]  bpf__sched_ext_ops_runnable
>  [10.011620]  enqueue_task_scx           (2) BPF runs with rq_lock held
>  [10.011622]  enqueue_task
>  [10.011626]  ttwu_do_activate
>  [10.011629]  sched_ttwu_pending         (1) grabs rq_lock
> ...
> 
> The above was reproduced on bpf-next (b338cf849ec8) by modifying
> ./tools/sched_ext/scx_flatcg.bpf.c to call bpf_timer_init() during
> ops.runnable(), and hacking [1] the memcg accounting code a bit to make
> a bpf_timer_init() call much more likely to raise an MEMCG_MAX event.
> 
> We have also run into other similar variants (both internally and on
> bpf-next), including double-acquiring cgroup_file_kn_lock, the same
> worker_pool::lock, etc.
> 
> As suggested by Shakeel, fix this by using __GFP_HIGH instead of
> GFP_ATOMIC in __bpf_async_init(), so that if try_charge_memcg() raises
> an MEMCG_MAX event, we call __memcg_memory_event() with
> @allow_spinning=false and skip calling cgroup_file_notify(), in order to
> avoid the locking issues described above.
> 
> Depends on mm patch "memcg: skip cgroup_file_notify if spinning is not
> allowed".  Tested with vmtest.sh (llvm-18, x86-64):
> 
>  $ ./test_progs -a '*timer*' -a '*wq*'
> ...
>  Summary: 7/12 PASSED, 0 SKIPPED, 0 FAILED
> 
> [1] Making bpf_timer_init() much more likely to raise an MEMCG_MAX event
> (gist-only, for brevity):
> 
> kernel/bpf/helpers.c:__bpf_async_init():
>  -        cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
>  +        cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC | __GFP_HACK,
>  +                                  map->numa_node);
> 
> mm/memcontrol.c:try_charge_memcg():
>           if (!do_memsw_account() ||
>  -            page_counter_try_charge(&memcg->memsw, batch, &counter)) {
>  -                if (page_counter_try_charge(&memcg->memory, batch, &counter))
>  +            page_counter_try_charge_hack(&memcg->memsw, batch, &counter,
>  +                                         gfp_mask & __GFP_HACK)) {
>  +                if (page_counter_try_charge_hack(&memcg->memory, batch,
>  +                                                 &counter,
>  +                                                 gfp_mask & __GFP_HACK))
>                           goto done_restock;
> 
> mm/page_counter.c:page_counter_try_charge():
>  -bool page_counter_try_charge(struct page_counter *counter,
>  -                             unsigned long nr_pages,
>  -                             struct page_counter **fail)
>  +bool page_counter_try_charge_hack(struct page_counter *counter,
>  +                                  unsigned long nr_pages,
>  +                                  struct page_counter **fail, bool hack)
>  {
> ...
>  -                if (new > c->max) {
>  +                if (hack || new > c->max) {     // goto failed;
>                           atomic_long_sub(nr_pages, &c->usage);
> 
> Fixes: b00628b1c7d5 ("bpf: Introduce bpf timers.")
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Peilin Ye <yepeilin@google.com>
> ---
>  kernel/bpf/helpers.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index b9b0c5fe33f6..508b13c24778 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1274,8 +1274,14 @@ static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u
>  		goto out;
>  	}
>  
> -	/* allocate hrtimer via map_kmalloc to use memcg accounting */
> -	cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
> +	/* Allocate via bpf_map_kmalloc_node() for memcg accounting. Use
> +	 * __GFP_HIGH instead of GFP_ATOMIC to avoid calling
> +	 * cgroup_file_notify() if an MEMCG_MAX event is raised by
> +	 * try_charge_memcg(). This prevents various locking issues, including
> +	 * double-acquiring locks that may already be held here (e.g.,
> +	 * cgroup_file_kn_lock, rq_lock).

Too much unnecessary information in the comment. Just mention that we
want nolock allocations and for that we need to remove __GFP_RECLAIM
flags until nolock allocation interfaces are available.

