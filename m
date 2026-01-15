Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CB87D3CCB1
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 05:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B536B0088; Thu, 15 Jan 2026 00:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ECA56B0089; Thu, 15 Jan 2026 00:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1A76B008A; Thu, 15 Jan 2026 00:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7934B6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:02:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 477701ADBC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:02:48 +0000 (UTC)
X-FDA: 84333003216.09.C931711
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4484112000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:02:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=M2W93ZP9;
	spf=pass (imf29.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768453366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHtMZy+1Hf+5CFrdMNdv7JLbvIeaLMOR/Q+6FgomzqM=;
	b=YJhHPTCr5TJzY6FjjRWjURgHSr/CdWVlilVXTDIvXlUgS9HQdnYfSvi+nfQSYyQrvvrywY
	596kv8zgKBEy7RsSJJotnX4SToEgOOwZrqsd7LwoZehQSYNsCTB6idvoUmXlFv70vOos1s
	V/FyDFEXNurUa2Gr+aWgKcHDGk7KWqs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=M2W93ZP9;
	spf=pass (imf29.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768453366; a=rsa-sha256;
	cv=none;
	b=idmEuD8gV0pVvuX6QsRlt0W83RJkGhNMN9hBV9lPibm9JKSiNvTweeE/hcZJRIRf2mKIwz
	/zBbNDRSs7W7HgNrPOJDy/H0YjBGqfxDZWnl5J0atVraDKevfn/pnG8dwhiwNpn3j5KyrT
	BKzsxs3oU1v+UtzdmQ0n5YHg+hcZTIU=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-81dbc0a99d2so248607b3a.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1768453365; x=1769058165; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uHtMZy+1Hf+5CFrdMNdv7JLbvIeaLMOR/Q+6FgomzqM=;
        b=M2W93ZP9La8ZE+zHsoT54Gaii1cXZ40TpY+S6tCtWBsEneReuBUGMAfpoiV4FcxS1K
         NSVlW9xoM9sjPWtJaN+p50Lo0Fis8BShgbt874fYis5olLLbvxw7ZfGM5DcDo+4GZC9V
         w41hh72LzUXRGq2eqOp5FYc1qq6Ac2thWy8CBvqKqfUbBC3+duwD4O2jty7rYpyoj3+P
         /6laIt+2c2uJMiu1suoyO4I6+4sYzAeYuCE5fgEQ72K66B77JxislWGUDClJcwm6uZL8
         Wd7HvTf+q1fH0+cPcgSEndYb+/Av0s2z2IIsVdOAecQNtVpTrRhcunSqVq2a4CSgT84K
         8GDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768453365; x=1769058165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uHtMZy+1Hf+5CFrdMNdv7JLbvIeaLMOR/Q+6FgomzqM=;
        b=LH8k2+oq9AriDMF5I2dQmX/+VjYEvQJtrZL496mSt9Ig5Clh5CVF457GpnCX/lbpAL
         lNqQKbufKby5MKIRNZaMdDUm+LtMBPfSQIGvFrDfwT+T4+2pesm9GYFuAjpzscAWRzZk
         J3a1LYw8vYtlLcRv/YUkwnZ+wS+Uv0jOOr+LTG18pIEAgy+6vdwGqMXjYiFe1k9xKJvY
         oZMuKw5slMzuPXQgG4aUgUtFetwAAkU2OzVVM99toD9wvladLZxguiLmw8zlY5TXAoFx
         aEFEJvPhTgwklF6xk9nLayr/im3GP34YmLA7KVsQgrfsDzl/pNaNKeAYczND5PjcQjtR
         uCuw==
X-Forwarded-Encrypted: i=1; AJvYcCX7KCaDp2Y2BJJvmSE1edFPShsUa0vhFr38TdwtYE/K3PUryyHd1e/LWLW23CIN2IIK6Ezs7ZO58w==@kvack.org
X-Gm-Message-State: AOJu0Yw8e1yKzpKSuXhSJ5jefuWRrE8z8B4jFywjXYLYQ+9jkY4vVnws
	KN3qQPcT/MOnxkGc4m0CPQHOhzaRewQZ3W0nXSHoiLkQBbGGt4/m1JEAQdAZEBKQaRI=
X-Gm-Gg: AY/fxX4uUR/LrHbv5cIMlfTGEL9nAvMJ0eSnmTZkJ/jL04uxukddftWRrUgHgcDUMzk
	G2HWftpM0rrFxYdEy4uz1CHdkZNZs5bDOaDtxEoYA1zAA94/7AankqCk5eOBDCo0L24TC87g7YC
	Ugirx1R4uhgxjlhueFCz1eJDPYOK39ccYoRu3ZRFPL6ehRXKKla4S2n09BdN6XtyWzzlv2jPe+Q
	rrd+vCl+Aov0UlzYS2Hk2B6MDp8ibAn7oksMcCf1GKy9BokwS7pAFini4Rak+HCk2hVc4YK8ghy
	4AW80nuohQhuG7Mo9Qlmj9bMSqXIENu+Xx26k8b+kk+Drm8HdnH0cpkPJXeQ4oMolvF8I1OFde2
	gtggo73hAMCACGIP6Jf423QrhjKTrYyx0+Jx2ITE3kJqz4cIzjk9F7Pm3fNXpTRqf4d/YDYnhYX
	sOrurnuIK9KiMdf0hsjedgMBu2TNhm83t/WaJYxQ554TGt1vmNFCo46CgyQ0z6lP8=
X-Received: by 2002:a05:6a20:9191:b0:341:262f:6510 with SMTP id adf61e73a8af0-38befbcabdamr4401639637.41.1768453363467;
        Wed, 14 Jan 2026 21:02:43 -0800 (PST)
Received: from dread.disaster.area (pa49-180-164-75.pa.nsw.optusnet.com.au. [49.180.164.75])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c4cc95d5dbfsm23665476a12.27.2026.01.14.21.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 21:02:43 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.99.1)
	(envelope-from <david@fromorbit.com>)
	id 1vgFVB-00000003cVO-2mpR;
	Thu, 15 Jan 2026 16:02:33 +1100
Date: Thu, 15 Jan 2026 16:02:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: guzebing <guzebing1612@gmail.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, guzebing@bytedance.com,
	syzbot@syzkaller.appspotmail.com,
	Fengnan Chang <changfengnan@bytedance.com>, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
Message-ID: <aWh06YoiJrR3-J-X@dread.disaster.area>
References: <20260115021108.1913695-1-guzebing1612@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115021108.1913695-1-guzebing1612@gmail.com>
X-Rspam-User: 
X-Stat-Signature: dmt86nfg579tsssas3ttj7dtrafach88
X-Rspamd-Queue-Id: 4484112000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768453366-615776
X-HE-Meta: U2FsdGVkX19P0rDpDP9tuVL26x+Q65YYT/Rhnx4wmU/NNY8falm3d7HoPsGpfsnufyTG3wNDqzDouHnFkETnM+KEDzBL4E2o6Jmzj92vv7899LBuxy04cX9ybRnLQ9bjbsIkplXkMtHgeF6O24nOUKA5T0NXZlZgl38oaYNXcMRxiV0SIeKMfD6CTpBRT/WXizbmANlVzIZITGGAlRp9pRSfv1cAsHkTempjAx+fvZsmbvwfFvxeeHclL9QPPH9HTzahBMTAb++Y5GarEpRpdQK4mJuN+4ar1hdX84vcGQJhHaq1O0UdIPMUP1ZaKvK8QcFtJfjoNFYiBW16kBsqiOVDxKYKLSR/65t4hhda6MLXgZqVbhK0K8b2g9fqJqg3QEmyqRGM1LjyCe4pj3TCKEIDiyxSM55aPoVmuJOreP/1M3Gx/qU4ftQU8SQqkqtKxNlHU2xFdBCHbewdENfSLh2Ug/ZVDG5pyw15fu0NboY/AVK0OeQ0qHwEn9qhIqCmfghKzwcDYjQdoFo8kTzLHsw/sTTHKDVa31CV5bzq7aGsXYUZHISDX0bd5eLJKkMBocg42O/2ChcIz0m0owu2WM8eAQrgOfF6SADJy6YOIhItKekIMp/7Zkp7EQTwhkZGv8uaVShSzsaWTvzvuUk1KJl01Opk+GDOm0UrNolE267pSZtE7+cn+lgSfcHlrCyJ9+e5Uo2LBkpuQGnJOFGG5bo5lTigVKUfsdeKj4K8LerfAj+RIYHiGvJmUagKGFCWyP7QymlPRgpNqQWs4a802W9YlV4U+9UNg/9vaKf+ZJfYPpg2ro34rMGQ2OZCekAeTxbHcbHbQ8aywipc78vI+VSg3GF7EHqt5kspAdfoJKDlBO42JVw03kL8lsnSRzA9xspH/5BwFQGRWLcfDKjWl0RPCsPo0/PGAMKVkKwqCnkD46Gre6L8+xSJfteWEVCdLgvai49VgWw7ys18pBc
 JxrxNx8b
 Fo8L4Z2XnxPgYDQVZ06AAXtjaBpQLUxqzmmbKsHr0F/WysU3ftYOqKxBK+/FgQRpf9SMsTTHmMh0ZUD3rNhdPu1HmFs5aSRctoc0k8yiyhrbCJhFvYN5m90O7zYgqKpbMze16E/65XQKDDLChkmAQ/M0MUxxmdIjG1qvPo/GW8n0UnMdzMtsWL74A2crGFlvvpW0Ghh9GULWPZ62nLxLOQuPevo5HoRZbXNe0v3pdERNkSa1fJ5BhKKDGURsVL9XFzl4IYxPsC1imeB0XTiUDys5+za9hM/UXcPJyi8tBSzk7CZ75RYNP+O6hRP62UAa1gR9+9ywXFzmAPJ/ghFyO+CG47d1oEOrri6gdgbWObcO6FALjZSNde0DhHUoopedOP4ua93o/iZzf2NPVTBPfuOWU0vMVRMLKAKyAK3MQ2v2ojAltN7CLZCiHv0IlwDHjZUyOeo6pqrNAE2vUEkzYwjf1GRJqyPdY2NgLT7eawPDBeF16KxkcCwopsn6T0+hpP6YGqTrnoieGFz+kKlQb/MJxHovpe0avhLYWDEtTH6nKEgEVDsMp5y0lSl0t8kp6t86zpSoJ1ltGct/QZnKfIgf8eay/Qx5zDs4J086DqmOpIxo4BTVun4PodOnndST9RbV4QYJQHd7cOYrI2KjNBJKhCVUfzAf/vUPJTpOYg+MwJDpmbmMX72QEprMHzzzNyWIf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[cc linux-mm]

On Thu, Jan 15, 2026 at 10:11:08AM +0800, guzebing wrote:
> As implemented by the bio structure, we do the same thing on the
> iomap-dio structure. Add a per-cpu cache for iomap_dio allocations,
> enabling us to quickly recycle them instead of going through the slab
> allocator.
> 
> By making such changes, we can reduce memory allocation on the direct
> IO path, so that direct IO will not block due to insufficient system
> memory. In addition, for direct IO, the read performance of io_uring
> is improved by about 2.6%.

Honestly, this just feels wrong.

If heap memory allocation has performance issues, then the right
solution is to fix the memory allocator.

Oh, wait, you're copy-pasting the hacky per-cpu bio allocator cache
lists into the iomap DIO code.

IMO, this really should be part of the generic memory allocation
APIs, not repeatedly tacked on the outside of specific individual
object allocations.

<thinks a bit>

Huh. per-cpu free lists is the traditional SLAB allocator
architecture. That was removed a while back because SLUB performs
better in most cases....

<thinks a bit more>

ISTR somebody was already working to optimise the SLUB allocator to
address these corner case shortcomings w.r.t. traditional SLABs.

Yup:


commit 2d517aa09bbc4203f10cdee7e1d42f3bbdc1b1cd
Author: Vlastimil Babka <vbabka@suse.cz>
Date:   Wed Sep 3 14:59:45 2025 +0200

    slab: add opt-in caching layer of percpu sheaves

    Specifying a non-zero value for a new struct kmem_cache_args field
    sheaf_capacity will setup a caching layer of percpu arrays called
    sheaves of given capacity for the created cache.

    Allocations from the cache will allocate via the percpu sheaves (main or
    spare) as long as they have no NUMA node preference. Frees will also
    put the object back into one of the sheaves.

    When both percpu sheaves are found empty during an allocation, an empty
    sheaf may be replaced with a full one from the per-node barn. If none
    are available and the allocation is allowed to block, an empty sheaf is
    refilled from slab(s) by an internal bulk alloc operation. When both
    percpu sheaves are full during freeing, the barn can replace a full one
    with an empty one, unless over a full sheaves limit. In that case a
    sheaf is flushed to slab(s) by an internal bulk free operation. Flushing
    sheaves and barns is also wired to the existing cpu flushing and cache
    shrinking operations.

    The sheaves do not distinguish NUMA locality of the cached objects. If
    an allocation is requested with kmem_cache_alloc_node() (or a mempolicy
    with strict_numa mode enabled) with a specific node (not NUMA_NO_NODE),
    the sheaves are bypassed.

    The bulk operations exposed to slab users also try to utilize the
    sheaves as long as the necessary (full or empty) sheaves are available
    on the cpu or in the barn. Once depleted, they will fallback to bulk
    alloc/free to slabs directly to avoid double copying.

    The sheaf_capacity value is exported in sysfs for observability.

    Sysfs CONFIG_SLUB_STATS counters alloc_cpu_sheaf and free_cpu_sheaf
    count objects allocated or freed using the sheaves (and thus not
    counting towards the other alloc/free path counters). Counters
    sheaf_refill and sheaf_flush count objects filled or flushed from or to
    slab pages, and can be used to assess how effective the caching is. The
    refill and flush operations will also count towards the usual
    alloc_fastpath/slowpath, free_fastpath/slowpath and other counters for
    the backing slabs.  For barn operations, barn_get and barn_put count how
    many full sheaves were get from or put to the barn, the _fail variants
    count how many such requests could not be satisfied mainly  because the
    barn was either empty or full. While the barn also holds empty sheaves
    to make some operations easier, these are not as critical to mandate own
    counters.  Finally, there are sheaf_alloc/sheaf_free counters.

    Access to the percpu sheaves is protected by local_trylock() when
    potential callers include irq context, and local_lock() otherwise (such
    as when we already know the gfp flags allow blocking). The trylock
    failures should be rare and we can easily fallback. Each per-NUMA-node
    barn has a spin_lock.

    When slub_debug is enabled for a cache with sheaf_capacity also
    specified, the latter is ignored so that allocations and frees reach the
    slow path where debugging hooks are processed. Similarly, we ignore it
    with CONFIG_SLUB_TINY which prefers low memory usage to performance.

    [boot failure: https://lore.kernel.org/all/583eacf5-c971-451a-9f76-fed0e341b815@linux.ibm.com/ ]

    Reported-and-tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
    Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
    Reviewed-by: Suren Baghdasaryan <surenb@google.com>
    Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Yeah, recent code, functionality is not enabled by default yet. So,
kmem_cache_alloc() with:

struct kmem_cache_args {
.....
        /**
         * @sheaf_capacity: Enable sheaves of given capacity for the cache.
         *
         * With a non-zero value, allocations from the cache go through caching
         * arrays called sheaves. Each cpu has a main sheaf that's always
         * present, and a spare sheaf that may be not present. When both become
         * empty, there's an attempt to replace an empty sheaf with a full sheaf
         * from the per-node barn.
         *
         * When no full sheaf is available, and gfp flags allow blocking, a
         * sheaf is allocated and filled from slab(s) using bulk allocation.
         * Otherwise the allocation falls back to the normal operation
         * allocating a single object from a slab.
         *
         * Analogically when freeing and both percpu sheaves are full, the barn
         * may replace it with an empty sheaf, unless it's over capacity. In
         * that case a sheaf is bulk freed to slab pages.
         *
         * The sheaves do not enforce NUMA placement of objects, so allocations
         * via kmem_cache_alloc_node() with a node specified other than
         * NUMA_NO_NODE will bypass them.
         *
         * Bulk allocation and free operations also try to use the cpu sheaves
         * and barn, but fallback to using slab pages directly.
         *
         * When slub_debug is enabled for the cache, the sheaf_capacity argument
         * is ignored.
         *
         * %0 means no sheaves will be created.
         */
        unsigned int sheaf_capacity;
}

set to the value required is all we need. i.e. something like this
in iomap_dio_init():


	struct kmem_cache_args kmem_args = {
		.sheaf_capacity = 256,
	};

	dio_kmem_cache = kmem_cache_create("iomap_dio", sizeof(struct iomap_dio),
			&kmem_args, SLAB_PANIC | SLAB_ACCOUNT

And changing the allocation to kmem_cache_alloc(dio_kmem_cache,
GFP_KERNEL) should provide the same sort of performance improvement
as this patch does.

Can you test this, please?

If it doesn't provide any performance improvment, then I suspect
that Vlastimil will be interested to find out why....

Also, if it does work, it is likely the bioset mempools (which are
slab based) can be initialised similarly, removing the need for
custom per-cpu free lists in the block layer, too.

-Dave.

> 
> v3:
> kmalloc now is called outside the get_cpu/put_cpu code section.
> 
> v2:
> Factor percpu cache into common code and the iomap module uses it.
> 
> v1:
> https://lore.kernel.org/all/20251121090052.384823-1-guzebing1612@gmail.com/
> 
> Tested-by: syzbot@syzkaller.appspotmail.com
> 
> Suggested-by: Fengnan Chang <changfengnan@bytedance.com>
> Signed-off-by: guzebing <guzebing1612@gmail.com>
> ---
>  fs/iomap/direct-io.c | 133 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 130 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 5d5d63efbd57..4421e4ad3a8f 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -56,6 +56,130 @@ struct iomap_dio {
>  	};
>  };
>  
> +#define PCPU_CACHE_IRQ_THRESHOLD	16
> +#define PCPU_CACHE_ELEMENT_SIZE(pcpu_cache_list) \
> +	(sizeof(struct pcpu_cache_element) + pcpu_cache_list->element_size)
> +#define PCPU_CACHE_ELEMENT_GET_HEAD_FROM_PAYLOAD(payload) \
> +	((struct pcpu_cache_element *)((unsigned long)(payload) - \
> +				       sizeof(struct pcpu_cache_element)))
> +#define PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(head) \
> +	((void *)((unsigned long)(head) + sizeof(struct pcpu_cache_element)))
> +
> +struct pcpu_cache_element {
> +	struct pcpu_cache_element	*next;
> +	char	payload[];
> +};
> +struct pcpu_cache {
> +	struct pcpu_cache_element	*free_list;
> +	struct pcpu_cache_element	*free_list_irq;
> +	int		nr;
> +	int		nr_irq;
> +};
> +struct pcpu_cache_list {
> +	struct pcpu_cache __percpu *cache;
> +	size_t element_size;
> +	int max_nr;
> +};
> +
> +static struct pcpu_cache_list *pcpu_cache_list_create(int max_nr, size_t size)
> +{
> +	struct pcpu_cache_list *pcpu_cache_list;
> +
> +	pcpu_cache_list = kmalloc(sizeof(struct pcpu_cache_list), GFP_KERNEL);
> +	if (!pcpu_cache_list)
> +		return NULL;
> +
> +	pcpu_cache_list->element_size = size;
> +	pcpu_cache_list->max_nr = max_nr;
> +	pcpu_cache_list->cache = alloc_percpu(struct pcpu_cache);
> +	if (!pcpu_cache_list->cache) {
> +		kfree(pcpu_cache_list);
> +		return NULL;
> +	}
> +	return pcpu_cache_list;
> +}
> +
> +static void pcpu_cache_list_destroy(struct pcpu_cache_list *pcpu_cache_list)
> +{
> +	free_percpu(pcpu_cache_list->cache);
> +	kfree(pcpu_cache_list);
> +}
> +
> +static void irq_cache_splice(struct pcpu_cache *cache)
> +{
> +	unsigned long flags;
> +
> +	/* cache->free_list must be empty */
> +	if (WARN_ON_ONCE(cache->free_list))
> +		return;
> +
> +	local_irq_save(flags);
> +	cache->free_list = cache->free_list_irq;
> +	cache->free_list_irq = NULL;
> +	cache->nr += cache->nr_irq;
> +	cache->nr_irq = 0;
> +	local_irq_restore(flags);
> +}
> +
> +static void *pcpu_cache_list_alloc(struct pcpu_cache_list *pcpu_cache_list)
> +{
> +	struct pcpu_cache *cache;
> +	struct pcpu_cache_element *cache_element;
> +
> +	cache = per_cpu_ptr(pcpu_cache_list->cache, get_cpu());
> +	if (!cache->free_list) {
> +		if (READ_ONCE(cache->nr_irq) >= PCPU_CACHE_IRQ_THRESHOLD)
> +			irq_cache_splice(cache);
> +		if (!cache->free_list) {
> +			put_cpu();
> +			cache_element = kmalloc(PCPU_CACHE_ELEMENT_SIZE(pcpu_cache_list),
> +									GFP_KERNEL);
> +			if (!cache_element)
> +				return NULL;
> +			return PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(cache_element);
> +		}
> +	}
> +
> +	cache_element = cache->free_list;
> +	cache->free_list = cache_element->next;
> +	cache->nr--;
> +	put_cpu();
> +	return PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(cache_element);
> +}
> +
> +static void pcpu_cache_list_free(void *payload, struct pcpu_cache_list *pcpu_cache_list)
> +{
> +	struct pcpu_cache *cache;
> +	struct pcpu_cache_element *cache_element;
> +
> +	cache_element = PCPU_CACHE_ELEMENT_GET_HEAD_FROM_PAYLOAD(payload);
> +
> +	cache = per_cpu_ptr(pcpu_cache_list->cache, get_cpu());
> +	if (READ_ONCE(cache->nr_irq) + cache->nr >= pcpu_cache_list->max_nr)
> +		goto out_free;
> +
> +	if (in_task()) {
> +		cache_element->next = cache->free_list;
> +		cache->free_list = cache_element;
> +		cache->nr++;
> +	} else if (in_hardirq()) {
> +		lockdep_assert_irqs_disabled();
> +		cache_element->next = cache->free_list_irq;
> +		cache->free_list_irq = cache_element;
> +		cache->nr_irq++;
> +	} else {
> +		goto out_free;
> +	}
> +	put_cpu();
> +	return;
> +out_free:
> +	put_cpu();
> +	kfree(cache_element);
> +}
> +
> +#define DIO_ALLOC_CACHE_MAX		256
> +static struct pcpu_cache_list *dio_pcpu_cache_list;
> +
>  static struct bio *iomap_dio_alloc_bio(const struct iomap_iter *iter,
>  		struct iomap_dio *dio, unsigned short nr_vecs, blk_opf_t opf)
>  {
> @@ -135,7 +259,7 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
>  			ret += dio->done_before;
>  	}
>  	trace_iomap_dio_complete(iocb, dio->error, ret);
> -	kfree(dio);
> +	pcpu_cache_list_free(dio, dio_pcpu_cache_list);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iomap_dio_complete);
> @@ -620,7 +744,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	if (!iomi.len)
>  		return NULL;
>  
> -	dio = kmalloc(sizeof(*dio), GFP_KERNEL);
> +	dio = pcpu_cache_list_alloc(dio_pcpu_cache_list);
>  	if (!dio)
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -804,7 +928,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	return dio;
>  
>  out_free_dio:
> -	kfree(dio);
> +	pcpu_cache_list_free(dio, dio_pcpu_cache_list);
>  	if (ret)
>  		return ERR_PTR(ret);
>  	return NULL;
> @@ -834,6 +958,9 @@ static int __init iomap_dio_init(void)
>  	if (!zero_page)
>  		return -ENOMEM;
>  
> +	dio_pcpu_cache_list = pcpu_cache_list_create(DIO_ALLOC_CACHE_MAX, sizeof(struct iomap_dio));
> +	if (!dio_pcpu_cache_list)
> +		return -ENOMEM;
>  	return 0;
>  }
>  fs_initcall(iomap_dio_init);
> -- 
> 2.20.1
> 
> 
> 

-- 
Dave Chinner
david@fromorbit.com

