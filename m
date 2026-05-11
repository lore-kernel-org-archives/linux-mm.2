Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D878CD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 22:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30F26B00A1; Mon, 11 May 2026 18:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08436B00A2; Mon, 11 May 2026 18:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44BF6B00A3; Mon, 11 May 2026 18:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A355E6B00A1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:49:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 370491602C1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:49:58 +0000 (UTC)
X-FDA: 84756633276.16.3973EE2
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2A583160003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:49:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MsUw8y4N;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778539796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zl7dNXWt7F9OqtH4+S7o9Rj18+0i9R6DqaVswvCUV9U=;
	b=7gfZuqB7OEHik1XZf0JPsZtIKcaeSEutKecc0avQ2FjLCkHV0QatcF2J4eqkadzXOhGWfh
	rajemUbUDPrhoEAshgWiDd+zvmpj1DK64CGvFCRRn6O76MRfaWCBmI+kdb3y3J7sA0Vfsj
	7JSI2p6p4lY5Omja/EIORPxoz5Fg7a4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778539796; a=rsa-sha256;
	cv=none;
	b=XlLjnV8I5tNheQ/WHlEOxXYI4qATnroNTGpIu20Vy4AGO7ZEKK2sHu9NfWp8h5UeaL6r/F
	ZxPeYWKSWJJCXlRw3B2cDGT7atXaEm6udWoZ5fvb5OyVZKC2O/JiqEkz87uk/CFAW4WC+x
	vfJXijop8+OyZHElB98aQlUkSYxcfi0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MsUw8y4N;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Mon, 11 May 2026 15:49:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778539793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zl7dNXWt7F9OqtH4+S7o9Rj18+0i9R6DqaVswvCUV9U=;
	b=MsUw8y4Nh1M1V2Emwy6pVbFE8hAHwOjgMp9bBEB+MhCxCaMAQFux5M9IU57jk5e9iWq++Z
	2wnAAnRmfW+Cfb7edlB/gWnQjwi1f4HtwGB6mlw9efep6OkJJE1f0RKSrR2NkFpBSqPqR/
	Wpop3HAstO13WDxuHAO51TqHpPo/Cvw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Minchan Kim <minchan@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Wei Xu <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 1/8] mm: memcontrol: propagate NMI slab stats to memcg
 vmstats
Message-ID: <agJYrraKk_wbHe07@linux.dev>
References: <20260511202136.330358-1-alex@ghiti.fr>
 <20260511202136.330358-2-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511202136.330358-2-alex@ghiti.fr>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2A583160003
X-Stat-Signature: wnes66d548oo5snaun53g3zfh7tmtm57
X-Rspam-User: 
X-HE-Tag: 1778539795-87820
X-HE-Meta: U2FsdGVkX18SIuS0ASjdN/7xkAdcErh7DXwUtu/c6L2TyutqtgE4bUcQP+HeLnRLIFdLIQYOY3ZkOsWU9GrfhLOmfdeWpkLtmiM8tm7EQmpKzpCQRR6VqhJFcy2N8E5gGb2RIsS0MIkMrayBoKrRnpyQWT//JfAtq5RRz3QHq7Ch4fjtCzlLlnpUlTaIQSM67chNIojryckg2KWUOJVw+5rKDQQmTenSrjCxrtQPr1MNS/RUYLiScCUwWwWkihgohvLH89RGGWP5MkaEh8j75FW23uFKaRV2CYeldMLuyHFbeD+9Kmg8+FNBL3hAmHga/GDPG9DnCH7rCK041V84F/uEMMPt9NWJms8JfruktnpYP3RYYhgCfiLnRPL598a8oDRBEUtKzVthqQUkEyZDQ0G1RqAgTDwHtd2Yrk2Y6xtk1X34s9/6HOXng9mIqkjlPBGPaEWDWCaauWJMUY5/zJy0VProWyX4yRkQ2LxO430uxer07/cZ9w6+pow4Qv+oAfz9Ix9cr4T3BE1WlVfSJ0JNqU4IYDG/CpGUDnJkX8UH1ZyAAv4QjGKGqCJ04gPTPwkDhiG73FJNjEs9TpN9ULZbuyFM8bR2lMS2zqDIiMnwPrMG80Ja7KPPnMSYxnv6+UAUymuFq/J4O460dyV+TIJd2FC6Wt0JFl0lkVXnDk39C7pDbZyCkfa/zubmUMfJjgmcDc3f4UsEIKt/csd7IKUVWjMJ8jtqMTz4z/hA//e8sDyTDnVpC0apyFiDPDIzx6eDfKccy/ztL74h8NqxUWhraa22rIoHazmUCI+F75KMDXSdp38fNKYtPXWIq3D5uoSzv7oGDz4KpH7MwujPV3sIOC0ZOu16UoW1jQ1wNLiiolkVVQFU6CsZUKl6wLMnjqXMgzRIp1dsFhpFJ/33Hg+OgLHDxrOaSenEf2xp+Pl4oXvZLbuay86dPW8bVlNNgci4l3LSRKhY1hEnrMz
 ksL0wflf
 NBtketl7X240Gb9QFOYvxpTgBcIqPLcBNJysOJGPSmbm+9Gv2syqtPKKWhmzDkQcve3qQSzD0EK24UWTUBsMT1yaDFfaSkx2R+cdTZWqPJY3emusGwHLEvSbldscHqghNuOm25J7+eLoclsFMS4kbQawCAubbA2Y5FuLG2qFQN1UZTXK3uSyb1TBtjVfUuuUOMPIYQjqWJuvvy8rMWVVleLu++4iSNdtYEi7kbQWzB/nO0pIDnQrK4YEPPpIeztYCb5hS4whIMYXEdXKlj8L3+mByjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:20:36PM +0200, Alexandre Ghiti wrote:
> flush_nmi_stats() drains per-node NMI slab atomics into the per-node
> lruvec_stats, but does not propagate them to the memcg-level vmstats.
> 
> This is inconsistent with account_slab_nmi_safe() which updates both,

I think the above sentence needs clarification. Something like "For non nmi
case, account_slab_nmi_safe() calls mod_memcg_lruvec_state() which updates both
per-node lruvec_stats and memcg-level vmstats, so flush_nmi_stats() needs to
flush to per-node lruvec_stats as well as memcg-level vmstats but at the moment
the memcg-level vmstats flushing is missing. Fix that".

> so fix this by propagating the NMI slab stats to the memcg-level vmstats.
> 
> Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/memcontrol.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c3d98ab41f1f..d81a76654b2c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4341,16 +4341,22 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>  			int index = memcg_stats_index(NR_SLAB_RECLAIMABLE_B);
>  
>  			lstats->state[index] += slab;
> +			memcg->vmstats->state[index] += slab;
>  			if (plstats)
>  				plstats->state_pending[index] += slab;
> +			if (parent)
> +				parent->vmstats->state_pending[index] += slab;

Nit: please keep all three code lines additions together.

>  		}
>  		if (atomic_read(&pn->slab_unreclaimable)) {
>  			int slab = atomic_xchg(&pn->slab_unreclaimable, 0);
>  			int index = memcg_stats_index(NR_SLAB_UNRECLAIMABLE_B);
>  
>  			lstats->state[index] += slab;
> +			memcg->vmstats->state[index] += slab;
>  			if (plstats)
>  				plstats->state_pending[index] += slab;
> +			if (parent)
> +				parent->vmstats->state_pending[index] += slab;

Same here.

>  		}
>  	}
>  }

With the commit message fixed and nits addressed, you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

and thanks for catching this issue.


