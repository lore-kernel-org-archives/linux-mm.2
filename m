Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72814C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88ACB6B02AF; Thu, 13 Aug 2026 14:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83ADE6B02D6; Thu, 13 Aug 2026 14:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777836B02D7; Thu, 13 Aug 2026 14:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 492A46B02AF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:43:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90160C028A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:43:41 +0000 (UTC)
X-FDA: 85097119842.18.3827259
Received: from mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
	by imf03.hostedemail.com (Postfix) with ESMTP id 15DE920007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:43:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nqgK9xQB;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.58 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786646619;
	b=f5dTIeH/YkfQ7QTif3el12GEe/l7fwrt6vadI7Fzi3hspwjt0gR50bcp3dL6n+oxOOJQCz
	f341Cb1wCzIg+yQ6FApWkbzIrfN1PeCzcpSUnolTnxp/RcsLzu/P5IaHO7W5U5YOszJ19+
	sylvcmHiVSg5W0dforf1KMN7NpUaaDI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nqgK9xQB;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.58 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786646619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANl767K+FflPkVzxkq0TC0Xwm4jgcFSGEbqysNVgnG0=;
	b=FHHyt0qqky68i0eKbcoDeehRLCKFvJoUQkVaF7POH2sLAvlOIIdi/nY1Q+mvwB3vBkQZd+
	E9Zno0k1INRlGaxmySnNlxZ8dkYr3or2C5T08gsAV1yUa7EV0SV3ITD6kzuqrAhYCk1oQZ
	vr9kZrPCwA0X7JPpLH0eBiV0hAzCJb0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jDzUtJv+bm4xBlAKD9OaG1FnQWn+8Dk7PeYCuphZl9o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786646617; v=1; x=1787251417;
 b=nqgK9xQBc9H+Wbtrk8KubpIsAnbL6hx7Ny4rgnmTT1+MjQEbD4ZnqqQDl1R1/N339zLasSEM
 o0TghcMprqu9KQ7jvJia/2qrVaTRr+3g1ZVr74s/YnzEzwuFJj1qzakFmLQHVJR5J9wyALkmkBm
 Upseygc9JGRMbys8qkj9fEKY=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:b::)
	by smtp.migadu.com with ESMTPS id f89b51daf9b6a4b4;
	Thu, 13 Aug 2026 18:43:36 +0000
X-Migadu-Flow: FLOW_OUT
Date: Thu, 13 Aug 2026 11:43:31 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Jiri Olsa <jolsa@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, davem@davemloft.net, 
	Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Stanislav Fomichev <sdf@fomichev.me>, KP Singh <kpsingh@kernel.org>, Tao Chen <chen.dylane@linux.dev>, 
	Mykyta Yatsenko <yatsenko@meta.com>, Leon Hwang <leon.hwang@linux.dev>, 
	Anton Protopopov <a.s.protopopov@gmail.com>, Amery Hung <ameryhung@gmail.com>, 
	Tobias Klauser <tklauser@distanz.ch>, Eyal Birger <eyal.birger@gmail.com>, Rong Tao <rongtao@cestc.cn>, 
	Hao Luo <haoluo@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Kees Cook <kees@kernel.org>, Tejun Heo <tj@kernel.org>, Jeff Xu <jeffxu@chromium.org>, 
	mkoutny@suse.com, Jan Hendrik Farr <kernel@jfarr.cc>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Brian Gerst <brgerst@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Willem de Bruijn <willemb@google.com>, Jason Xing <kerneljasonxing@gmail.com>, 
	Paul Chaignon <paul.chaignon@gmail.com>, Lance Yang <lance.yang@linux.dev>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Barry Song <baohua@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next 1/4] mm/bpf: Add
 bpf_try_to_free_mem_cgroup_pages kfunc
Message-ID: <an4GCBl_c4ub5Iit@linux.dev>
References: <cover.1786086076.git.zhuhui@kylinos.cn>
 <5cd3efa9a4c614ba0b03cf4a3bd459dea67a9f61.1786086076.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cd3efa9a4c614ba0b03cf4a3bd459dea67a9f61.1786086076.git.zhuhui@kylinos.cn>
X-Rspamd-Queue-Id: 15DE920007
X-Rspam-User: 
X-Stat-Signature: wp49khp5yei7p5ufxngwksryckxbnixd
X-Rspamd-Server: rspam06
X-HE-Tag: 1786646618-187581
X-HE-Meta: U2FsdGVkX1/ohxYf/jv+Lg0pxEAKDJkmO9zXjE6V8w7udcWfB9gLj+Zm12qkQA/soG8dChbQnOsVGioBI/X2mGfE0SeJYYnBIiz3YrsdW75mNc1SHiH3+rd3MYuU36ZGpqTbQXmeucpWkdSFQT3mQSwY2jJnPQhea5QkhhNPdvFjmHg8QWrkYQr4PQWdl0pXFZ52QueDXx9HuaEysc/QK53Yo1rBkbFmIGF+Fje2XzcklgJblTxAdJ0lsVSkX79Mdjc7Iw28U2Mcv0KMLIQyZy6ZZex+IVarEldGefTdTT5znMU/Py9L3iNKvo93oUcWVm6ALdkPdcgTDvhJmAD1tQK8OgjyDZDbCBc/J7rujomMvtmDgHCejpRBArgrLZDP4KisHWRuW1PUnfNaLMhse0bxCVJEhEPeHLtZIU5EfHwypsiaYCqxPjfwgM2kwqmFdjwfC9510e/qHGwOhZl4pxEP22OVChx8wheamCTQNULgxifqLkkUsq8pUwwno1y4ZGDlH7/2qmCBwnnKSlX+lD7ADYM5uQoDDYvVIzZEuftQFROVWaUagOx8uP1FS8lIlDN3n0NV/GlDAXFtPufv0pCKIL5LYzzMVtkzzjavsjdc5Hkk9cwy1K6i+oU59srj4KUZks8o7H/hXG7OePAkD7HxfPrqhj0Ro34D7JCVFxXYuE/7Hha+A34MdOk9CpKK4EI9g2yT7LxujTm0tNP7a19dLnoqNWPaJ+Mq7G/yF4mVSQs3NmryR9ofOHTYCnaOyCi2aJJ55nJuXD3gxAikKIiczmX04ma4KLz3ZxT1LYNOg8qemat0M6K4iWEnYTYfSYuK8cstt3m6m9toL265dP4zmpFJ1OLFJ/2LGCCAgLyU7PK0UXe2ZPMcBWAwkE8+YMo4QLnUuwZMzs4xCk/kVy6r/aGEX2/yQTSkNghJvjlEWnethd1lCm0fDwqNxhPHM6QOTUOYbvfTIIhHLiH
 AfZBr7Xr
 WyAStQlqMKotkpnvyFXBXogz1N3q6q/MUIu/a/KbGJfD/A2D2ddNHJJFUSqG0q2/rslbYQOhjeIy3D324oR7tAlGN/k0g4J9Q+Htl9wF6oTA16p6+Kya+wb1yYFyS4AQGRLwi6gFKzcHha4VU/gT74EnctGiV6lXs6guAVm00XRjOmoVpkwtW4nBNb2cg+34Phk7rBbGPid+8rigJePXB9aL3u/lm3VBL7sbHQOEpZIVUhgua09dJYuBshx0WAlto9huomgn/cBr8h8IDij8YL6nt0rK54O5L7YAG4aD7zMn3VlNgBStAvM2S7mRvmM37biPsxjhxxJb7iBR+JMXHZ1AxpFpAwbbNo6X4qBfxfuO2L7XvmyiamtsOQ3VyitokQuDL7PvLtSpZ0qvYyFmu51hTtLRmVRKr0V1mz0UhXZtQDPunTeyYdLd8qLEEb9MqS0m1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hui,

Please narrow down your CC list, I would suggest to CC only memcg and bpf
folks.

On Fri, Aug 07, 2026 at 03:01:49PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>

[...]

First of all, good decision to decouple this series from the struct_ops for
memcg as the struct_ops for cgroup series is still in flux and I have different
plans on how memcg struct_ops should look like. We can discuss and collaborate
on how that should look like which satisfies the real use-cases we have instead
of arbitrary or imaginery use-cases.

Others are already discussing the bpf side of things, so let me focus on the
memcg side.

> 
> +/**
> + * bpf_try_to_free_mem_cgroup_pages - attempt to reclaim pages from
> + *                                    a memory cgroup
> + * @memcg:           the target memory cgroup to reclaim from
> + * @nr_pages:        the number of pages to reclaim
> + * @gfp_mask:        GFP flags controlling the reclaim behavior
> + * @reclaim_options: bitmask of MEMCG_RECLAIM_* flags to tune
> + *                   reclaim strategy
> + * @swappiness:      swappiness override value, or a sentinel to use
> + *                   the default
> + *
> + * BPF-facing wrapper around try_to_free_mem_cgroup_pages() that
> + * validates and translates the @swappiness argument before
> + * delegating to the core reclaim path.
> + *
> + * The @swappiness parameter follows these semantics:
> + *   - Values in [MIN_SWAPPINESS, SWAPPINESS_ANON_ONLY] are passed
> + *     through as an explicit swappiness override.
> + *   - Values below MIN_SWAPPINESS are treated as "use the system
> + *     default"; the override pointer is set to NULL and the cgroup's
> + *     own swappiness setting takes effect.
> + *   - Values above SWAPPINESS_ANON_ONLY are rejected as invalid.
> + *   - If @reclaim_options does not include MEMCG_RECLAIM_PROACTIVE,
> + *     the @swappiness override is ignored entirely by the core
> + *     reclaim path and the system default is used regardless.
> + *
> + * Swap usage during reclaim is gated on @reclaim_options: swap is
> + * considered only when MEMCG_RECLAIM_MAY_SWAP is set.  Without this
> + * flag, reclaim is restricted to file-backed pages regardless of the
> + * @swappiness value or the cgroup's swappiness setting.
> + *
> + * Return:
> + *   The number of pages actually reclaimed on success, or 0
> + *   if @swappiness exceeds SWAPPINESS_ANON_ONLY.
> + */
> +__bpf_kfunc unsigned long
> +bpf_try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> +				 unsigned long nr_pages,
> +				 gfp_t gfp_mask,
> +				 unsigned int reclaim_options,
> +				 int swappiness)
> +{
> +	int *swapiness_ptr;
> +
> +	if (swappiness > SWAPPINESS_ANON_ONLY)
> +		return 0;
> +	else if (swappiness < MIN_SWAPPINESS)
> +		swapiness_ptr = NULL;
> +	else
> +		swapiness_ptr = &swappiness;
> +
> +	return try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask,
> +					    reclaim_options, swapiness_ptr);
> +}

This is just a wrapper on try_to_free_mem_cgroup_pages. We don't want that. At
the moment try_to_free_mem_cgroup_pages is used by limit reclaims (memory and
memsw, high) and proactive reclaim and has become a weird looking interface. We
should not expose it as is to the bpf programs.

Let's go back to the use-case for which you want to expose this interface. Your
cover letter says proactive reclaim. Let's focus on (existing) proactive reclaim
use-case (in future we may want more functionality). Proactive reclaim is done
on a given memcg, amount of memory to reclaim and swappiness.

Let's start with just:
unsigned long bpf_proactive_reclaim(memcg, size);

And if we clearly have a swappiness use-case then let's add one more kfunc:
unsigned long bpf_proactive_reclaim_swappiness(memcg, size, swappiness);

So, my main point is let's drive the kfuncs from the real use-cases.

thanks,
Shakeel

