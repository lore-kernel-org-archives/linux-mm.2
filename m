Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5A3F606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 22:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DMjkk+i0
Received: by kanga.kvack.org (Postfix)
	id CCCA46B05B1; Sat, 14 Nov 2026 17:14:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57166B05B2; Sat, 14 Nov 2026 17:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E726B05B3; Sat, 14 Nov 2026 17:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81B3F6B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:14:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F1651A049E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:14:18 +0000 (UTC)
X-FDA: 85435128996.24.743B394
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7D07120006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:14:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMjkk+i0;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794694456;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4emrSMghF1KSYkyMa/m1CN5e0LTDInZhqSTdP3O3s3s=;
	b=SEw472W/ZJa5+GXtqp5BOLRwp3teRQWNHZjICnL4d7It1LBDX3kc+shqePR56d60TNP/qz
	aSBLyJLlictk7qDvFc31yFXoRWJapf/w7P03JCtt2Pu/QLxD35T3QwV72zV0ZDbMKQcJLD
	9BwB/XFToE3nIfr2pHFC6h2LDM0Bb2k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794694456;
	b=QM6JUoe9s3TssIiZ087KexnBsyVz2upQsYF0Ihj+RbSq9PXKc7OlqKY0xTRvX/lrbx9e7c
	yghXueLvG5axWKGnYiz6fuCOGCou5zMe5hcIOg8KA+6ElV30YNEuRm13NgbW0upjf8lJ88
	vu6dbqxwW+E9vNuZ1SxrYFK2XEgwdXs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMjkk+i0;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BFD9D60DF1;
	Sat, 14 Nov 2026 22:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E6B1F000C4;
	Sat, 14 Nov 2026 22:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794694455;
	bh=4emrSMghF1KSYkyMa/m1CN5e0LTDInZhqSTdP3O3s3s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DMjkk+i09QLm9EjE6W1c+i52LKCf8Q1p0uFCA/WNJDDTmiYucKjZWAdg1bM4CWFYd
	 DwjIUL41GaYFILC8WtO4CnZ8AecacoCiuqeUFznJM5sWqWT8FXhRHhWsiRwSvMINEV
	 N1bfom4evwizo2I6atIfYSG48yAWGueTdEsC9Ji6mD6v2rdX7wIvAfMuPOSWK6N8kL
	 lmC7UTKpRBK/yGb7MjY9A0bPLlv1QBA5y19+UyQ0bn9y93/b99CBdL4lt5B/GdrFp0
	 tSEWlsxUdLheaXDrRU2kw+yZbz5TbcvoEGmxOHaAFkDHOIAH5gadRJsOf/AIK3qW2K
	 NHrsMduNERCgw==
Message-ID: <sashiko-outbox-215057@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/slub: Flush virtual-slab work before cache
 destruction
Reply-To: sashiko-reviews@lists.linux.dev
To: "Felix Hoffmann" <f3lix.dev@gmx.de>, "Jann Horn" <jannh@google.com>, "Matteo
 Rizzo" <matteorizzo@google.com>, "Tamas Koczka" <poprdi@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, linux-mm@kvack.org
Cc: "Kees Cook" <kees@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>
In-Reply-To: <20261113221330.162567-1-f3lix.dev@gmx.de>
References: <20261113221330.162567-1-f3lix.dev@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 22:14:14 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: zhcc7dru8qz95yf9hspzxix79kjochgr
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7D07120006
X-Rspam-User: 
X-HE-Tag: 1794694456-891068
X-HE-Meta: U2FsdGVkX1/D/COfn+BMqYuUc/l2HFMQ3IFuFjZqngl6gT0iC4gNWR1SxpGHnP6MzZiXXc5CsKRtY1liqfqAAB2qqswFfcDNozNjSdMr+5UfwJu33URwfy1Rl4WOlPcnMalingKUY2UTWGA9P9bb0JpxvEYkyFfXqZIP9vXlk25eMawlDa384vQhDNCUe1igZOshOFvn1rJQMf7spnDBVp83uQErLPhKY66z03qlGIq0CTMh1Vrjbr+kiyIRMPeomI4a36+Td6l+TI7o5pxwPG6kJpCGENsjm37auLQSrcca4ju6hlOSjJ59O000zy7Fq8By20eg9fR/a8+0krTwbd7eGIzu/F48/+1Q3USr6YEBqnZ+ZzybYfgpiZgE1LhbYrLvwU1Ch0WMOwHtY5G31LIz+r7OANscgx0/7QPL7ZPtRwB6iL8MG6aoJUG1NKKFgR/CVlGQdqLpztUTOa0Vkd+nAJr8W3OD3MYK6zBt5GBad1jcVMWnnk55zaJnIkPWqGXLM524JIDrfxdL3qgpoBd8/m3LtlcKkb8npJLWVHfRoo2ziWDAxD0TkjqgmkAFzoul0SnltBJLgEB9kmPcrTkdhxCEUSsOJxbHi6usQeHyZA/Qth4TDToDDe6Gwq/gNtG8d2uduqOMEq7PvXSRYOIV99oY6Kkruxwy040xxDtWGjM1EnjVFzSK24QsBhDSE0V10sSTPFT066VfUI30TGg3jx1uo25uSvqb4EBGwxJIO+2xqQTbDdpFvGi8pom2hl3n4vshhWRyLQGC++gzQi5sKzaBuKOoMCFrVVIfuqCFQY+a08eGCui2wcSsaJ9PrqyytjfTnj+igEnMIx+dfYNKGG+MO2jC8jzYQu9NWwlfIhBiuHnh/2wN20AO7GxbmBN85fJIrEUIMSajn8Rf2g2moutYPZLMGqZC9NXDCFSdaaT1LeCq6313jb4XHPS5srE6Gd76bF2rsqAXJgJ
 X3GoS9JX
 Mu4YC4sqwukjF3wfTY9FoXb+VfMe+srm7DND+4bkYOc6aws5Y9cqwzLjMVc39jFShi8sjcBTaAIK+g79cyv2HDbSzc72YICs4Dw2kfaHt7ZQo+tdJnZ8VARQv4n/RYFMTeMVVPgh+5zZ7fQoOWYMXwEa+59HDSrUuz3DlX+YmgMcpd27Ro0AjW8MlvrYL6VvViMnHdRyzK7hEpCiqXCXGu6vIcoHOqZR5lP5AOa7/JDb2Js0e2qmUoG/KVSM7mqhShDXdR4QwFztD4rGP7W9Z1UNVmPLZgtXslGojmZwOzuDhTRZxrwwJNvhoVnbuvSCCGNJVRjKQWAnyRzgRl14pVZPXqg+u7oy6eiqRaVaep7vDTk2/WoGGy9xT9l0SaPXjgtVGVZ1uwsFSxDWDmUKAMJpvg88s8bQqfnrlSEcSaS54u2TCPYW562PY/zpDHULB1pQxxq/ruA0D/+amql0oMC/g2t3T4G040Ni1pQqQ0ayuLFEFP7oy2X1huY0eiYzv4m2qAUiAssxiRlANrJf1q5XjLHaVaZG2DYGWJrbm5sEEgD/SxdQ3nC3Uyw5a1tT+DO+s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm/slub: undeclared slub_tlbflush_work under nonexistent
  CONFIG_SLAB_VIRTUAL
- [Medium] mm/slub: __kmem_cache_shutdown() flushes work before RCU slab
  free barrier
- [Low] mm/slub: unresolvable Fixes commit 0d6f38b78adda in commit
  message
--

commit eea96dc753bff553cd7a4356f0451c5fa1889295
Author: Felix Hoffmann <f3lix.dev@gmx.de>

> mm/slub: Flush virtual-slab work before cache destruction
>
> Under CONFIG_SLAB_VIRTUAL, freeing a slab queues it to
> slub_tlbflush_work. The worker later follows slab->slab_cache to take the
> cache's virtual-slab lock and update its lists.
>
> __kmem_cache_shutdown() can report success after the last slabs have been
> removed from the cache's accounting but before that deferred work runs.
> The cache can then be released while queued slabs still refer to it. When
> the worker runs, it dereferences the freed kmem_cache and corrupts its
> lists.
>
> Flush the virtual-slab worker after confirming that every cache node is
> empty and before allowing cache destruction to proceed. This drains both
> queued and running work that can still reference the cache.
>
> Fixes: 0d6f38b78adda ("mm/slub: allocate slabs from virtual memory")
> Signed-off-by: Felix Hoffmann <f3lix.dev@gmx.de>

[Severity: Low]
The Fixes: trailer references commit 0d6f38b78adda ("mm/slub: allocate
slabs from virtual memory"), which cannot be resolved in the repository
or tracked maintainer trees.

> diff --git a/mm/slub.c b/mm/slub.c
> index a151268b97263..ec432cff15f58 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -8298,6 +8298,11 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
>  		if (n->nr_partial || node_nr_slabs(n))
>  			return 1;
>  	}
> +
> +#ifdef CONFIG_SLAB_VIRTUAL
> +	/* The TLB flush worker still dereferences slab->slab_cache. */
> +	kthread_flush_work(&slub_tlbflush_work);
> +#endif

[Severity: Medium]
Is this patch missing the prerequisite virtual-slab changes?

Neither CONFIG_SLAB_VIRTUAL nor slub_tlbflush_work exists in the tree,
and mm/slub.c does not include linux/kthread.h for kthread_flush_work().
As a result, this block is unreachable dead code in normal builds and
fails to compile if CONFIG_SLAB_VIRTUAL is defined.

[Severity: Medium]
Can destroying a SLAB_TYPESAFE_BY_RCU cache still race with
slub_tlbflush_work and cause a use-after-free on slab->slab_cache?

During __kmem_cache_shutdown(), discard_slab() decrements the node slab
count via dec_slabs_node() before calling free_slab().  When
SLAB_TYPESAFE_BY_RCU is set, free_slab() defers __free_slab() via
call_rcu(&slab->rcu_head, rcu_free_slab):

mm/slub.c:free_slab() {
    ...
	if (unlikely(s->flags & SLAB_TYPESAFE_BY_RCU))
		call_rcu(&slab->rcu_head, rcu_free_slab);
	else
		__free_slab(s, slab, true);
}

Because node_nr_slabs(n) is already zero, __kmem_cache_shutdown() flushes
slub_tlbflush_work (while holding cpus_read_lock and slab_mutex) before
those rcu_free_slab() callbacks have run.  kmem_cache_destroy() only
waits for rcu_free_slab() afterwards, and then immediately frees the
kmem_cache:

mm/slab_common.c:kmem_cache_destroy() {
    ...
	if (s->flags & SLAB_TYPESAFE_BY_RCU)
		rcu_barrier();

	kmem_cache_release(s, sysfs_ready);
}

Slabs freed by rcu_free_slab() during rcu_barrier() are queued to
slub_tlbflush_work after the flush in __kmem_cache_shutdown() has already
completed, so the worker can still dereference slab->slab_cache after
kmem_cache_release() frees s.  Should kthread_flush_work() be called in
kmem_cache_destroy() after rcu_barrier() (and outside cpus_read_lock and
slab_mutex) instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113221330.1625=
67-1-f3lix.dev@gmx.de?part=3D1

