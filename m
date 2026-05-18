Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAA6CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BDF26B008C; Mon, 18 May 2026 19:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F96F6B0092; Mon, 18 May 2026 19:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D926B0096; Mon, 18 May 2026 19:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8316B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:42:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04CDF40B21
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:42:13 +0000 (UTC)
X-FDA: 84782166588.21.7EADDD5
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 01288180006
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:42:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=puQ78vfx;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QCtoP4NRudV33pIm9zRDQzZGMwbm5GmlU6HPmH5vp0=;
	b=svcBCqkDqfEhBfvwM7nTfTBISGupop2gr1wDy7b+0Kospx3fquTCPMxBYi4Ow7SsTmjP+3
	sXlFED+DpikIJUkuDJOz+Wbd2gVmsUlGWmdX/gFqrTd3ilQAMgn6comPtBrIspvykMQqes
	VQ6yzXIBbv86crx0X3qRJcmFpW6Dbn0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=puQ78vfx;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147732; a=rsa-sha256;
	cv=none;
	b=c7W0ed7yg8h/v08YFNd6RZAb7T7eOHHxkYHjX/IYwC8CoPODU1i8MAenM5AXzVDWwgw6hP
	Y259pMcMZVNJepzbmiYl7iuc+br/GpQ4S3ms9wmoMm6U1QAoNk+/OMT38cucfT5+pDwxl0
	9l9s9gsu8c+KE77w7muEeM8DbzzPZiU=
Date: Mon, 18 May 2026 16:41:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779147728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+QCtoP4NRudV33pIm9zRDQzZGMwbm5GmlU6HPmH5vp0=;
	b=puQ78vfxlavN/DowBTm+ommhrlzC3UKWVldJ5ENuibRKIrQ1q1IbR/KdkiqcpmkggUEn+V
	o7AIm6kvbDP7Zt3TGA18ExumKlQkRoRfOQJxJzWMAs+igS0iUlEIsSrEAMezb+rg/puubX
	p7/Q39B6ZaDa1AOoF8sYlB180hq/vl0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v3] memcg: cache obj_stock by memcg, not by objcg pointer
Message-ID: <aguiSnY3ie1y4nEl@linux.dev>
References: <20260518222827.110696-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260518222827.110696-1-shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 01288180006
X-Stat-Signature: 18s7mkeq7czis78bdt69iokdxoyndphu
X-HE-Tag: 1779147731-202307
X-HE-Meta: U2FsdGVkX18kupfBCqUp3IApUoIQ55kkrgozz9S6xU+Zs3kmzf4qhtMiAGXaz1m8J5+5PQZ2I5DeeGRqM4ciZz/RgAL4zIlcx4qOyVAyC6ig9uKB4wfCkTC3Y7k8pBSTSSE4NCvCKJikNcrRISRcnIiLp4NjiDJSEXeiHp+CvGfDsdQpQgKn/9vuN0NNwqWhvRJLdh+YllcpAY2tApCU/lzWrBAmJz7nRZ07RaawpnPqMyEKqXnC2rGvwjCTN59kt2MBTdmmmWjIZh8ZBib6f7fB5yT99bGUYPTofEGfaJtZcOhyqzPlA+c8s7QfsPc7P0nGlkOIFzJMLcIbN1B3qQi331K7Zw7Fdtz4pDyk1B49Bshu+el+TSNwyUZLaxjxG6jSA54v9wV7TBlNPlpe9Zl/M0dWC3GIWrKV+QGm+NGQ1oD8G0JkLwnAMKGvunZGraxWV2czZhBrFxv0rOTMo//PCAJ9yDoc52u2BAa/mgbn/MVJinDYaIdDhgId8iM3nLfp1m8oCACR17zbxMSKzT7oZw8ZMfJsO/Rbi4tYNhWz2ySS48xny2s6cZe7OU4/58FNCg3dcfwliGOqL13cE72NM40rkQbQwrFkppAVV/ZzLT5Bqj+sZ6WET6X3jQGEn56GcL8FXb8Iu3QwVS1dtyQPGY83s0P8eOzoWBNCsyQmvXgCc9jI22Crw8/B9DXJqftaJrNi1t7h7qgOx2vc3KHJqYFOYiEwJUNVuljG1rfE27ixYwv45TCXKAVLmtZ3lHGtqsZjoTrKtNbOb3qiLxeAPotLEUSbafqXQAQnfaPevzumxHZE5OhaY4aIJp5VYNuGqULOuUA9cfFNdgs7USojeydgGtttlGKmGRxPkjR4Mpuwx614x+1ldxmIOSUz2XWxVuHo+rbJoXPWHAFOfsbAQnfVv6a/bMeJZdFFr/oayeX+QVGeCUDqxTCtegyh7XGPPINbjC+rq64Ut/S
 mblyGF+s
 zl6Ot6nIajyDufXfhLSCCMDzA4MfAKhAhDnLaXRw4RCAHLPkR2lAxPnkmLl9/Het/QPO9eK//Iwr5ERKMt9s7QhSFuK2qsci3BLiC9NnCUcF3qtlmY505a/nqrKuuN/IdDaPAGsoKA63fMwFvRBVogLT0vaKWLYwRnkrBWl6hLaBvjdGH5iPHO7FoL6ficRRUkKPl+Pia0MXc5+eYey2RaeJXnV2cUUFs1QS47J7EyZ43hODdTMYlPaZYsHZCPE/qF27QrFITBBjk851vnchrWIgV+zyNpsUNOz6e68I6ylVuk1GQ0wnX8mb7S5TUEOnLa49tM+08L4fT60yyddryenS+yH/rNlVBUkOeRkCN9SUjAciKtkN6vQzvoP8JZowsf+9vng2zzHEX/8Z2ywo9SVnemvWShnXG78FCkaUgbjSgJZTTuIo1tt23kTGHA5KQvNXgZ0mz3vXs6QU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 03:28:27PM -0700, Shakeel Butt wrote:
> Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
> per-node type") split a memcg's single obj_cgroup into one per NUMA
> node, but the per-CPU obj_stock_pcp still keys cached_objcg by
> pointer. Cross-NUMA workloads now see a drain on every refill and a
> miss on every consume that targets a sibling per-node objcg of the
> same memcg, producing the 67.7% stress-ng switch-mq regression
> reported by LKP.
> 
> stock->nr_bytes are fungible across per-node objcgs of one memcg.
> Treat the cache as keyed by memcg in __consume_obj_stock() and
> __refill_obj_stock() so siblings share the reserve. Compare via
> READ_ONCE(objcg->memcg) directly: pointer-compare only, no deref, so
> the rcu_read_lock contract on obj_cgroup_memcg() does not apply.
> 
> Sharing the reserve without re-caching means bytes funded by one
> per-node objcg's slow path can be consumed/freed under a different
> sibling, leaving sub-page residue on whichever sibling was cached at
> drain time. The pre-existing obj_cgroup_release() path would WARN and
> silently drop that residue, leaking up to nr_node_ids * (PAGE_SIZE - 1)
> bytes per memcg lifecycle from the page_counter. Forward the residue
> into a per-node objcg of the same (post-reparent) memcg at release time
> instead, so it can be reconciled later via a refill atomic_xchg or
> another release; the chain terminates at root_mem_cgroup, whose
> page_counter has no enforced limit.
> 
> Please note that this is temporary fix and will be reverted when
> per-node kmem accounting is introduced.
> 
> Update the stale invariant comment on __account_obj_stock().
> 
> Qi Zheng built a specialized reproducer [1] for the corner case and
> confirmed the fix.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/ [1]
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Debugged-by: Qi Zheng <qi.zheng@linux.dev>

Sashiko's review below and my response.


> 
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s)
> to consider:
> - [High] Race condition during memcg offlining causes a permanent page counter
> leak when forwarding `sub_bytes`.
> - [High] Unbounded accumulation of `sub_bytes` in a non-allocating parent
> memcg causes a permanent page counter leak and integer overflow.
> --
> 
> commit e90ccbfce3bb9538bf1cdf185a1c10a7269e0939
> Author: Shakeel Butt <shakeel.butt@linux.dev>
> 
> memcg: cache obj_stock by memcg, not by objcg pointer
> 
> This commit changes obj_stock_pcp caching from pointer-based to memcg-based
> so sibling per-node objcgs share the reserve. It also forwards sub-page
> residue into a per-node objcg of the same memcg during release so it can be
> reconciled later instead of being lost.
> 
> Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/
> [1]
> 
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >  index d978e18b9b2d0..a547ec7c42d16 100644
> >  --- a/mm/memcontrol.c
> >  +++ b/mm/memcontrol.c
> > 
> [ ... ]
> 
> > 
> > @@ -160,23 +170,33 @@ static void obj_cgroup_release(struct percpu_ref *ref)
> >  */
> >  nr_bytes = atomic_read(&objcg->nr_charged_bytes);
> >  - WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1));
> >  nr_pages = nr_bytes >> PAGE_SHIFT;
> >  + sub_bytes = nr_bytes & (PAGE_SIZE - 1);
> >  
> >  - if (nr_pages) {
> >  + if (nr_pages || sub_bytes) {
> >  struct mem_cgroup *memcg;
> >  
> >  - memcg = get_mem_cgroup_from_objcg(objcg);
> >  - mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
> >  - memcg1_account_kmem(memcg, -nr_pages);
> >  - if (!mem_cgroup_is_root(memcg))
> >  - memcg_uncharge(memcg, nr_pages);
> >  - mem_cgroup_put(memcg);
> >  + rcu_read_lock();
> >  + memcg = obj_cgroup_memcg(objcg);
> >  +
> >  + if (nr_pages) {
> >  + mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
> >  + memcg1_account_kmem(memcg, -nr_pages);
> >  + if (!mem_cgroup_is_root(memcg))
> >  + memcg_uncharge(memcg, nr_pages);
> >  + }
> >  +
> >  + if (sub_bytes && !mem_cgroup_is_root(memcg)) {
> >  + struct obj_cgroup *fwd;
> >  +
> >  + fwd = rcu_dereference(
> >  + memcg->nodeinfo[numa_node_id()]->objcg);
> >  + if (fwd)
> > 
> Could there be a race condition during memcg offlining here that leads to a
> page counter leak?
> 
> If this executes concurrently with the offlining of the memcg,
> memcg_reparent_objcgs() might have already replaced the nodeinfo objcg
> pointer with NULL. In this race window, fwd evaluates to NULL, and the
> sub_bytes would be dropped.
> 
> Since they are dropped without being uncharged or forwarded, it seems the
> page counter would permanently leak these charges.

This is not much a concern as it is bounded (i.e. nr_nodes * PAGE_SIZE - 1) and
previously for the warning case, we were already dropping the sub-page charges.

> 
> > 
> > + atomic_add(sub_bytes, &fwd->nr_charged_bytes);
> > 
> Does this unbounded addition create a risk of integer overflow and page
> counter leaks if the parent memcg never allocates?
> 
> If the parent memcg is used strictly as a hierarchical container (like
> system.slice) and performs no kernel allocations, its objcg is never cached
> in any CPU's obj_stock_pcp.
> 
> Because __refill_obj_stock() relies on the cache to periodically drain
> nr_charged_bytes, it would never be invoked for the parent. Could child
> residues continuously accumulate in the parent's nr_charged_bytes without
> ever being uncharged, eventually overflowing the 32-bit atomic_t?
> 

This can be a concern for a long running cgroup. However fixing this would add
complexity not worth it. This is a temporary fix and will be reverted in newer
kernels.

> > 
> > + }
> >  + rcu_read_unlock();
> >  }
> > 
> -- 
> Sashiko AI review ·
> https://sashiko.dev/#/patchset/20260518222827.110696-1-shakeel.butt@linux.dev?part=1
>

