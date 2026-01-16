Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA11D4A607
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 07:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE7056B0088; Fri, 16 Jan 2026 02:57:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94F06B0089; Fri, 16 Jan 2026 02:57:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0AA6B008A; Fri, 16 Jan 2026 02:57:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA0366B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:57:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E4B7BA347
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:57:14 +0000 (UTC)
X-FDA: 84337071588.28.55859B8
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf11.hostedemail.com (Postfix) with ESMTP id 759AE40005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:57:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TymSe3fT;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768550232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PsGNXpmMoDJe1yHU7yqWS6tBazZC3oE9e62iQ9nE4c=;
	b=ipCb6/FLL+j18Yhwgz/+MbF10gLilTVRxeMVVWlXUnru8euo2XMOJjEkC5Uq+x5rJMJph2
	hMMuJeSlbaEbjdevPOaVbDXilyWWKpMc3RPxj4Eb/Ao+j3D4WA7ieKap4qfgg7AN9vNJsI
	ozuFHxkK18uPs+cNTMI4m1nFSmyqAjk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TymSe3fT;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768550232; a=rsa-sha256;
	cv=none;
	b=IekxFTi3XOeyQJ1ttZbidQqgP8baufNVkuHk84JX5dQMkejdJ1M5nzqDq0cPsGYmganicJ
	5MKHHYAXOVvvebbU/rxcDeiSs1RIzLJd769OXY2YTA+ZAs0CtOshsa3nwK1ZolxRfRwRIP
	6WMzrybk87usauCYr98YiqgNz/LHmAk=
Date: Fri, 16 Jan 2026 15:56:58 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768550230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8PsGNXpmMoDJe1yHU7yqWS6tBazZC3oE9e62iQ9nE4c=;
	b=TymSe3fTdIyFVQMQQP7IHFHCaMh/PCzDQo+dEFkAYYQYNwDT1s9H4/71uzSbo6jpL/6qBh
	WoBMsOrlmofja3Wo5HkAZZK2f1iuTObqGZw6KxlSjG8J3zh59PfoUFX8lf2d4E9vNaHC1I
	m7Rq7f8WVgy9E1jUSKv1tQeH3+njf2w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH RFC v2 08/20] slab: add optimized sheaf refill from
 partial list
Message-ID: <5lmryxzoe2d5ywqfjwxqd63xsfq246ytb6lpkebkc3zxvu65xb@sdtiyxfez43v>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-8-98225cfb50cf@suse.cz>
 <38de0039-e0ea-41c4-a293-400798390ea1@suse.cz>
 <kp7fvhxxjyyzk47n67m4xwzgm7gxoqmgglqdvzpkcxqb26sjc4@bu4lil75nc3c>
 <bb58c778-be6b-445e-a331-ddaf04f97f0e@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb58c778-be6b-445e-a331-ddaf04f97f0e@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: c5t8exh41784mnmjdgfq918gf33sjc3c
X-Rspamd-Queue-Id: 759AE40005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768550232-713534
X-HE-Meta: U2FsdGVkX1/o7qO3eTFQEnmHsVswqj5lXLd9OHg0LvBudyZRareLU1gizbHX9cHYSFsGDp3owSLNNA8halxeG5jIBUuU/d878dhM+OA3xsmH9VCphmNMNVPQ+9Xotz64SYAcIQ5h+e3p5Jp/PoO7ryr/3InXNOx3rG7E/lS5YmI5WdeAeSinXa0pI91Gw6l7TTWG5yTGAOlPK1esgzdjWD122bKqZmg4yuVwKpT+GvLOfvNrL0eiZiHtEtI8JNMfZYVIvYkOtXRrZ2dkhiLLhuypgoYfSCAcGROS4naOGZs+mmEH/W9WTsXocMPuY30oxBGBLVv6ULy1JhuB3jiRVjbfVxAnXIl2OeDGVl8MjM5tEBNc8n1kW5b2RePMQCnjWkPbiMNuVlJM1c0yyxHVZu5dnYqZXCkm5u6sC5OHHSgaqs5e9LpAxM4hqvck4OyElvPl2VPs8dbLGcZ7eA8aJVevdzyYfkjqgOxVPW4rf6zpLtl5M5IY2pDBOaQNx8pZptjIjv9XVqofFr0gsDNA5iUXKe18qrXzoxJyiyQ5jmnih+33CO7vTi2DvBmdA6e0/IipT0CkUNUj5k0ql5e/JQbhP+5L6KCj7syJfQPe0RK/eMUiRT73zhJjEairx6CFpPUKTQffOs2RwX3ni9ybHFR3Tj8Ei6fABfKgImk9l9NSW+hfnnpqwKsdmEnN3kVm0PWEBSz2YZ1geA5tqlIcwmWBk9TFLNUO2XcJJODc8Oz5DMROZ2AaS3U16n4NetoCyIR4hCvNN5530iExp2V7MPNFeOKs3Sn+8fHCmpc78e+8S5WVmEexNXVaI2jEFQDKjKeI085H4X5B/P0/vbTZ3uoKzQmNXko8jVSWZJ+tkvrnrfJ2NI1HHnFRgsuCEnYzd0FsLBgY13+Ks78F5g1h4PWjUJF+vDmmxMmOTeNli7lPZxdES6QdKbSb4abOsglTpwpnBboOYjLZxDoG+6m
 UyoVixoz
 aU8/VD7i83KE5WvDb4nTt2SKSqPCt3HkSfsmDD1s71O73WlB/ngi0xvUFX0zmNuEwx/g9QKL7crNgNoXKIae3kQdxol9ZIy8DGdpKbOmFLFnvTjl4tFtM9fyGAuj7THNqnxTVEA2Vb9m2R3RJDeYoJaJ10wdzpm4bw7CzEaOQ89KA8c2etjc0yv1M3RZJ/5sYXRrNdxQqNUhGqRzgiAkgwovmyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 08:32:00AM +0100, Vlastimil Babka wrote:
> On 1/16/26 07:27, Hao Li wrote:
> > On Thu, Jan 15, 2026 at 03:25:59PM +0100, Vlastimil Babka wrote:
> >> On 1/12/26 16:17, Vlastimil Babka wrote:
> >> > At this point we have sheaves enabled for all caches, but their refill
> >> > is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
> >> > slabs - now a redundant caching layer that we are about to remove.
> >> > 
> >> > The refill will thus be done from slabs on the node partial list.
> >> > Introduce new functions that can do that in an optimized way as it's
> >> > easier than modifying the __kmem_cache_alloc_bulk() call chain.
> >> > 
> >> > Extend struct partial_context so it can return a list of slabs from the
> >> > partial list with the sum of free objects in them within the requested
> >> > min and max.
> >> > 
> >> > Introduce get_partial_node_bulk() that removes the slabs from freelist
> >> > and returns them in the list.
> >> > 
> >> > Introduce get_freelist_nofreeze() which grabs the freelist without
> >> > freezing the slab.
> >> > 
> >> > Introduce alloc_from_new_slab() which can allocate multiple objects from
> >> > a newly allocated slab where we don't need to synchronize with freeing.
> >> > In some aspects it's similar to alloc_single_from_new_slab() but assumes
> >> > the cache is a non-debug one so it can avoid some actions.
> >> > 
> >> > Introduce __refill_objects() that uses the functions above to fill an
> >> > array of objects. It has to handle the possibility that the slabs will
> >> > contain more objects that were requested, due to concurrent freeing of
> >> > objects to those slabs. When no more slabs on partial lists are
> >> > available, it will allocate new slabs. It is intended to be only used
> >> > in context where spinning is allowed, so add a WARN_ON_ONCE check there.
> >> > 
> >> > Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
> >> > only refilled from contexts that allow spinning, or even blocking.
> >> > 
> >> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> 
> >> ...
> >> 
> >> > +static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >> > +		void **p, unsigned int count, bool allow_spin)
> >> > +{
> >> > +	unsigned int allocated = 0;
> >> > +	struct kmem_cache_node *n;
> >> > +	unsigned long flags;
> >> > +	void *object;
> >> > +
> >> > +	if (!allow_spin && (slab->objects - slab->inuse) > count) {
> >> > +
> >> > +		n = get_node(s, slab_nid(slab));
> >> > +
> >> > +		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> >> > +			/* Unlucky, discard newly allocated slab */
> >> > +			defer_deactivate_slab(slab, NULL);
> >> 
> >> This actually does dec_slabs_node() only with slab->frozen which we don't set.
> > 
> > Hi, I think I follow the intent, but I got a little tripped up here: patch 08
> > (current patch) seems to assume "slab->frozen = 1" is already gone. That's true
> > after the whole series, but the removal only happens in patch 09.
> > 
> > Would it make sense to avoid relying on that assumption when looking at patch 08
> > in isolation?
> 
> Hm I did think it's fine. alloc_from_new_slab() introduced here is only used
> from __refill_objects() and that one doesn't set slab->frozen = 1 on the new
> slab?

Yes, exactly!

> 
> Then patch 09 switches ___slab_alloc() to alloc_from_new_slab() and at the
> same time also stops setting slab->frozen = 1 so it should be also fine.

Yes. This make sense to me.

> 
> And then 12/20 slab: remove defer_deactivate_slab() removes the frozen = 1
> treatment as nobody uses it anymore.
> 
> If there's some mistake in the above, please tell!

Everything makes sense to me. The analysis looks reasonable. Thanks!

Just a quick note - I noticed that the code in your repo for b4/sheaves-for-all
has been updated. I also saw that Harry posted the latest link and did an inline
review in his reply to [05/20].

Do you happen to plan a v3 version of this patchset? Thanks!

> 
> Thanks.

