Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACCDC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 19:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFE86B0088; Fri, 28 Aug 2026 15:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480C36B008A; Fri, 28 Aug 2026 15:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F466B008C; Fri, 28 Aug 2026 15:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1E36B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:53:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 909561404AA
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:53:24 +0000 (UTC)
X-FDA: 85151727528.09.9431323
Received: from mta1.migadu.com (out-215.mta1.migadu.com [95.215.58.215])
	by imf01.hostedemail.com (Postfix) with ESMTP id 64AAD4000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:53:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eVza7e58;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787946802;
	b=YmoxXgM1jwqLlz8PRLruQIU1y1kO1ArvbOmVS7L4dV85nwsq8lKBKoIySk1ES9/T0LVqG8
	a74UH8NFIJ98hNOfyXhXn+50jaVNn/71LsWyvjmX8u69kisssvfZihZZFYvFPaDtqukaTE
	H8Iwam+Mwd4BlFILHxJN1wrz21JFzHQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eVza7e58;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787946802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7JXcpUPgY0/5OhAI7zQu5AlxZy8ieSPOaVx8bbadOg=;
	b=hGBo/STJOYeLHi56kbjMwO/lnSv6cOoxZ2deXWSICmAHv2NwLrT7NqHq9zcwTwEkZWFVDR
	XdGg2BSMapofDFEfg/llApq0lVQjcxgKJrDcLC8tZBmWFxuGdPDTwJZsdGdSdzL3kko2BL
	Txn9/WGup9zgYWqpYiPM7Igz0w89IWE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2DsvoO8trPann3gGlgHfEvV8zzD6F/Yb3aERd3YdNwY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787946801; v=1; x=1788551601;
 b=eVza7e58vsCYz6nTeSUGSC0tDD2EiRtk3eLY2ekL7Hmt60HFR7XCaVkd7DBKy64F3qBKqrhF
 dgwRDueTFjDD/CPdw3Vxnbrb4ImP202YwGftcCsRsTjUvIlprG4ccoxR6ft8WapGQatdUPeNZEK
 ImClpGQJEKqZgkyjMvRUrqbY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id da07200143d5a7cf;
	Fri, 28 Aug 2026 19:53:20 +0000
X-Mizu-Trace-ID: da07200143d5a7cf
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 12:53:19 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <inwardvessel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v5 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Message-ID: <apHk86Y8araBlXcq@linux.dev>
References: <cover.1787826402.git.zhuhui@kylinos.cn>
 <5dfdc7800469eac4e9a240f2422ba65d4ef4c4ba.1787826402.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dfdc7800469eac4e9a240f2422ba65d4ef4c4ba.1787826402.git.zhuhui@kylinos.cn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 64AAD4000A
X-Stat-Signature: 3gyk3efyy6zqj56wr6gzkjkn6ys1st7h
X-Rspam-User: 
X-HE-Tag: 1787946802-800693
X-HE-Meta: U2FsdGVkX18V0SkUeoam1XqTDVi8KH/pM+brKLKXFqfNwZeD661IRmn3lRG7FXSfXkeq1Cx1gfp6hlrCee19DbAyJ6t19AXlNX6A2WyEukX4dilGFOZnV0rK+1T34lciXDJwzVVlIBnKT0jIMa9WXZYZT8Ib2yuVU+fdXN4NBtPZa/URt+kZApFVWhNbkcKUWKuMu8gA/alUwqOAdBPj9Nok/Om+ZPa3niGxmmMBWP0TupqaEj4kdSBKfllmDAuwPphxbnbGLRLXvsXGD5EbNN/CF8LYyuPmECqjFCApH4/c6XZUwaBJUsdFujBCQXh35LuRxIo03y12STkkcvGjM5Oe70yKJij/bd95GncD5MiBzT2lB/xEXgLEH1nX4sonA+xPXRYD7yX/VhbK+Mm7N4kFdprzrsNsew9Vz2/osWrx2bujAQoj4SFKCdWjXb1LQcdoHkaBw8Tiyo0OoZB4VE/yKFgX8IQ4AUoq95dKhnGbpTqIe3QrcxKpU2tPmhl064wjweCfRhsVKFYbderHjVoNCaXHs/WvHAf6d30qo6u4jFHoOTDrcJzkz+pBIoaS2yYQq6qEM+aSXMIKEQd4PJvAjxscT0+ntOEQ/AlZQ23UFxsb/5Az9ROUE28u/gPYQIjnUETEBfc093wzbgZvKxYoOpmbJ+Ie8wX3jDylqSDjHMlIKZxkrmJ5d/w777QUsSA+46VXuhpx1MNCLKeSnn1FUlXL+ld3ldWU0Fv3ZJXs24QyxyvDb+kw52clZKqC5Y1wz/nyqwopzkS6djFFwKFYFH20TWqQUVLbA8E5EKEPAQTzQO2NTkrnAWB/fOIWjECXnUOZZIT1Wd+uO2AnpGd10iDe7q48iEX7mSamBS/ucopadWO/fgdSgdnBlschDXC70b4BoFC4U5+MvVl7ebT8mtQgocynrBppRSww9vr+L8SkHM+DwFhzcs4t4nhxgghJnmzuh9VKwobITTd
 vfZYHiAO
 QCMH83LIg3+sUyfD3IB/ByS6ZOyKo4jxBMsa1jvnQkcKk8lT4lNmfhWJ3nQZUY7+4kO3uOlbCZ9U+TvleiJH5dAdH+q35VjR4+OK/boHNOaNSS6fPpHuffX8p38xa6Af9iaQwjHf77jOl/NDwRhB+OXH9/0h//31AdYjrIRgu5y4JbPVqbo+PX7e1aRR+662MYkE0W0miPmxqnZYuLonU59dC6tp1hg7HCAwASf6enwzFjtETEwdVFuxtL0nxgKqFCH6N3Mf/ZRDywuDLsRnmakjhAVpmNe5/m7lkCKjx+HlTkR2nVwPFAC+hY9VC3Cgy5Pin
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 06:36:29PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Add bpf_proactive_reclaim(), a sleepable kfunc which performs one
> proactive reclaim pass on a given memory cgroup, similar to a write
> to memory.reclaim but without retrying until the target is reached.
> 
> The kfunc refuses to reclaim if the calling task is already in a
> reclaim context, as a nested reclaim would corrupt the outer reclaim
> state.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/bpf_memcontrol.c | 46 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..297ff7f05042 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -6,6 +6,7 @@
>   */
>  
>  #include <linux/memcontrol.h>
> +#include <linux/swap.h>
>  #include <linux/bpf.h>
>  
>  __bpf_kfunc_start_defs();
> @@ -159,6 +160,49 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>  	mem_cgroup_flush_stats(memcg);
>  }
>  
> +/*
> + * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
> + * current->reclaim_state, so a nested call would corrupt the outer
> + * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
> + * reclaim_state is also checked because it is installed slightly
> + * before PF_MEMALLOC.
> + */
> +static bool bpf_in_reclaim_context(void)
> +{
> +	return (current->flags & PF_MEMALLOC) || current->reclaim_state;
> +}
> +
> +/**
> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
> + *                         cgroup
> + * @memcg: the target memory cgroup to reclaim from
> + * @size:  the amount of memory to reclaim, in bytes
> + *
> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
> + * memory.reclaim, but without retrying until @size is reached.
> + * Must not be called with a filesystem lock held: the reclaim path
> + * may deadlock on it via filesystem shrinkers.
> + *
> + * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
> + * smaller than a page or the task is already in a reclaim context.
> + */
> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> +						unsigned long size)
> +{
> +	unsigned long nr_reclaimed;
> +
> +	if (size < PAGE_SIZE || unlikely(bpf_in_reclaim_context()))
> +		return 0;

I have been thinking about this more and more and after looking at the reasoning
behind your check current->reclaim_state and also Sashiko's comment on NOIO/NOFS
contexts, I am more convinced that this kfunc can not be a simple sleepable
function. We need more than that. We need clean process context as well similar
to the userspace poking memory.reclaim. Something like kthread or workqueue.

Kumar & Andrii, is there a way to restrict a kfunc to only be called from
special BPF threads/workqueues? Is there some similar concept in BPF world?



> +
> +	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, size / PAGE_SIZE,
> +						    GFP_KERNEL,
> +						    MEMCG_RECLAIM_MAY_SWAP |
> +						    MEMCG_RECLAIM_PROACTIVE,
> +						    NULL);
> +
> +	return nr_reclaimed * PAGE_SIZE;
> +}
> +
>  __bpf_kfunc_end_defs();
>  
>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> @@ -172,6 +216,8 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
>  BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
>  BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
>  
> +BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
> +
>  BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
>  
>  static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
> -- 
> 2.53.0
> 

