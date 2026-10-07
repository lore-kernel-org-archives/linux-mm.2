Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E63BBCA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 17:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABDE26B0092; Wed,  7 Oct 2026 13:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6F596B0093; Wed,  7 Oct 2026 13:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9835F6B0095; Wed,  7 Oct 2026 13:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 776BF6B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 13:47:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 089DEA74BC
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 17:47:23 +0000 (UTC)
X-FDA: 85296561966.08.F01A0BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6E22318000D
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 17:47:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EquxJzNs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791395241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrN5jCbJ23KzWZs6wwkV2zHBbc7V4zUmP1BS2E476mc=;
	b=SIBGHM03ZhxaFejr9jZXXdbQlRgWkJJcJ2rhkbHfne6QMSCGtiNN0EHk3WS1u9/N4jfMXv
	Ge36HtnnTPR2b5/Rh5rC1Ic9G9cFkmV5geqORMPcHYZ5BTz1hK3YdCHBJrBqZzckXYiwiV
	Drig6tUyAYh9SnehjY7R64ekQnnMZQ8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EquxJzNs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791395241;
	b=kkrMF6H9UYK/SwCWgieIHYMGzNpkodNvxZnakh6WfmzQgkcPdi9Gg/cVjT6x8QEvFj1cOi
	N8+Vxi6bhKBwBuW5gqSx4wE3Mm84Hxp/0BaMAWNSzXuG5YYdD5DDf0He0E5L4+n1J0udN5
	8R6Ty8aw8eFRqQG0hSxtJKDOQgIw7J4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31F4D601FD;
	Wed,  7 Oct 2026 17:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CF61F000FF;
	Wed,  7 Oct 2026 17:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791395239;
	bh=hrN5jCbJ23KzWZs6wwkV2zHBbc7V4zUmP1BS2E476mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EquxJzNsDMw/0KeyNG4auMBMP0wP6kLplxNS0LhgoG8NQkbThad0GD4F+LIHwhjKQ
	 lzhs7kZ8PLpagPgk0y1dQEr2sKoxFTF4VqcLYltNa+9zSNkt0qihVmYvm+T7RLeoJg
	 0skBcNxgWndYoIykw748fEC/y2ZM0C+tGqWjJ4uN4Vo+bDlXfcJlVBUnTuJU++ujdI
	 AWXgAEYuzlFNBO/4/LHlsFkVJjlNRPHpJWiyQc13ZMYSpJPnZIMPqrriMGpFzGpFXq
	 GrlYjW1py4ss8EaIqhW5r6lIrFAFskZdX6ngh+EV5yo8Eo01UwhN8e8q8Pn2aEFvW+
	 7v4SNSGFvSfOA==
Date: Wed, 7 Oct 2026 19:47:14 +0200
From: Harry Yoo <harry@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Hao Li <hao.li@linux.dev>, linux-mm@kvack.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/slub: clamp slab_min_order to MAX_PAGE_ORDER
Message-ID: <asaEdFRDdZlRdAc4@thinkpad>
References: <20261007163403.1643768-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007163403.1643768-1-ekffu200098@gmail.com>
X-Rspamd-Queue-Id: 6E22318000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: m6uun1ofm5z5sc9jey34zws33kwzjtap
X-HE-Tag: 1791395241-287643
X-HE-Meta: U2FsdGVkX1/JE3Uj2S3DpkVNvHdi7EuFsrupNEW1sH/lsX3lBFSzbLkLWkJg3jwYFSVVN4CAotxrL0guGg2CHK/L9u+cZzYfwF5SHIqj8/sq47qK15OmkFLjc8/GMcm8NmCjFWwd0OvcohH+oc2YyTcjMppdvEHjy5KS1AmEa4DhD9TGYdJwKbZxRyGwOEVA9wUnPOQKno//WbVibOY6pM7+4zsex89XKoLDPf1ywOgnbrLA0287xOW8v+aP1+d77BcPOZtkfhZE6F/hHYkhqgS4xhba86KI/WhC2eJ24WXuvZAyy5zk9+knxfr6EytGZWPFVGxXdsGWq8WPJrhMZCmXM/ub/bSuYmjxonlL0U0AEQp9g2LYozIIwnzge9PEgGIQ0ShIAqCBn2Gzg8MUSaPyJsOTflNj+ugZMWWfwcl54mT5NH93dsacMuLOBW86ERxE9FYQlZ/JQQIxbDep3xzOkdy7u0DaEEVYGdamXoKSBub6y31LnwIJtJf9CBKEwxb+ZDw/fZqps4E+TuxbTL7Tx2Ntra670Ad/1f8tN9T+ws61e7uIq0Tl9lJuseW5+C3gl0dJBRDX6u56v5/5ypd5M0Uwkd8XWU7twN55Jp9dUEebqVqK/JcyiTAT0TowSoSEKx0MZzhc+FVI5b95ecDlTNJ2MFMzqTUGYUNTP8rUaPyJ51topRmhFDe3f6k77cZsAT2xpfSCXaUvFoPqPKTO3XPYV6Fugx+XpYsmNghmY/InMqQZ/xji1bOParNVhtQnXpRG0lj6Kfdy8elKIWQbuoxCCVldYuzQ42iaxiihPQeOrqI5dYyRAwPzzWAAbkaI+ik2R4++gyxby76oG/cPNcssUR1uPSWwerrJrp25h1QLFneq+5MlMfHtYm/RkMFke7fI9/WsqFoHsi8g1ifRr7+7chW8rTMOguw389lLUukyyioQpMdjBgdaOrk+E/rcUtygTBQ3stH5Sl3
 QwKgWbyy
 eJSmqFxMbCzQo67JrKIEp7PzQAZV8Nd1vnse8pohamTHAaoxzvdvN8Qfxd4+J/jKmFV4ipiZPpKEELY2N6KKC1FZRPV6CV4RZ5eajgDQN4NWBqPxOgEmqTRpcclzwZSxlZgIvPUlK2VQdUFShD7QSwtkNJfAT2TvQRDpWJUjNaZ8fT2RhFIWQktyFPt1OYrfsc0CcKrTEyzj38jX4juAimSJGt0mxFuSvOI9sAOkiJN8jiuHKInLgP6eYLSops8wQNG1x5GFSHHCx2XRq+W7bKOwhnJiykhFrxLRC4zPy2ZoUGwIVwIrclNvHTzFWWRUHYaInf8nFi4ALYEPqBLnPIX+nww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 01:34:02AM +0900, Sang-Heon Jeon wrote:
> setup_slub_max_order() clamps slab_max_order to MAX_PAGE_ORDER, but
> setup_slub_min_order() has no such clamp.
> 
> The buddy allocator cannot allocate more than 2^MAX_PAGE_ORDER pages
> at once, so slab_min_order above it makes no sense.
> 
> If slab_min_order is set above MAX_PAGE_ORDER, it can even panic at
> boot or invoke undefined behavior in order_objects().
> 
> So clamp slab_min_order to MAX_PAGE_ORDER as well.
> 
> Fixes: 818cf5909701 ("slub: enforce MAX_ORDER")

I think Fixes: should be the commit that introduced slub_min_order.

> Cc: stable@vger.kernel.org

And no need for Cc: stable? It's been there for decades and people
should realize the kernel parameter is broken when it doesn't boot.

Otherwise looks good to me.

> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> QEMU-based test results
> 
> - Booted with "slab_min_order=20"
> 
> 1) AS-IS (before fix)
> [    0.094926] mem auto-init: stack:all(zero), heap alloc:off, heap free:off
> [    0.097776] Kernel panic - not syncing: Creation of kmalloc slab kmem_cache_node size=64 failed. Reason -22
> [    0.099542] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.2.0 #1 PREEMPT(undef) 
> [    0.100903] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    0.102607] Call Trace:
> [    0.103040]  <TASK>
> [    0.103417]  vpanic+0x32a/0x4b0
> [    0.103976]  panic+0x5e/0x60
> [    0.104491]  create_boot_cache+0xe3/0xf0
> [    0.105194]  kmem_cache_init+0x12d/0x410
> [    0.105890]  ? mem_init+0x1fc/0x210
> [    0.106521]  mm_core_init+0xba/0x140
> [    0.107153]  start_kernel+0x441/0x8b0
> [    0.107814]  x86_64_start_reservations+0x18/0x30
> [    0.108638]  x86_64_start_kernel+0x10c/0x120
> [    0.109401]  common_startup_64+0x13e/0x158
> [    0.110145]  </TASK>
> [    0.110584] ---[ end Kernel panic - not syncing: Creation of kmalloc slab kmem_cache_node size=64 failed. Reason -22 ]---
> 
> 2) TO-BE (after fix)
> [    0.008976] mem auto-init: stack:all(zero), heap alloc:off, heap free:off
> [    0.011366] SLUB: HWalign=64, Order=10-10, MinObjects=0, CPUs=4, Nodes=1
> 
> Also, I'm not sure about the Fixes commit. Please change it if you know
> a better one.
> 
> ---
>  mm/slub.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 1559cbace469..8400df7c222e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -8354,6 +8354,8 @@ static int __init setup_slub_min_order(const char *str, const struct kernel_para
>  	if (ret)
>  		return ret;
>  
> +	slub_min_order = min_t(unsigned int, slub_min_order, MAX_PAGE_ORDER);
> +
>  	if (slub_min_order > slub_max_order)
>  		slub_max_order = slub_min_order;
>  
> 
> base-commit: d755441b7672c74f29d1241ffdd2b067ecab1ca0
> -- 
> 2.43.0
> 

-- 
Cheers,
Harry / Hyeonggon

