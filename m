Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16DC8CD98EE
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 05:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4178C6B009E; Wed, 17 Jun 2026 01:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8786B009F; Wed, 17 Jun 2026 01:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30AE16B00A0; Wed, 17 Jun 2026 01:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0168E6B009E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:33:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8080C1C1967
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:33:02 +0000 (UTC)
X-FDA: 84888285804.15.90C4CE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C0B2A140003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:33:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMCuyKZA;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781674380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCy0RGVwhFQ7leuqrM8fySPSwmvrPlB9/5amWSSk2xU=;
	b=J62qo4gIm+88QYsElRC4wiaF5+E82V3BV/klqjZNKzAZT1F3zZoSxzvGZZkihXIXJ6CLpe
	y/m55NdfU8W8Z1hvBRlvj8idlciu9fTDH8jeyoRty9D9qY/omwh/XWZCDcpr5o5RKWGi6d
	X9wRLzB5wR3JxdJ9jT3MuurP8juP+D0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781674380;
	b=m5l5WNhzA0RaWVQVMs1brJjIxfzLPgufwMP75yqSSmomG9aPfciZ12oUDvh5AmxVn/P4VJ
	mfCWAQFVTDHlgp3L4Ny569i4/IjYPbUfCPlgeyjb/g71TW5valj/6PFpMVzQ3jslxvaEsJ
	XK9/uKqaYKWBlomDFbr1sF2Dhx96fi4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMCuyKZA;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1F1242B24;
	Wed, 17 Jun 2026 05:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877061F000E9;
	Wed, 17 Jun 2026 05:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781674379;
	bh=ZCy0RGVwhFQ7leuqrM8fySPSwmvrPlB9/5amWSSk2xU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aMCuyKZAe8lfdvxd9tXY5nOBo75gNBoltsHEPiWGh202rk9fIzGH/nd47z8zj+b/Z
	 Aub3vtYaviTBghykfLFvwDEFrwja9TuiNu58TIkNKnDTUsDKe6ibWQnrqcy9yRR/Gl
	 PySfsN8XOIsxsihzAc+6iRyO2uvYsp4tUyxckBeU8gxidmki9vnmFmO9bmu7EwU7fg
	 3phTLDqLdMa8RzJWw3uVxxnMzXxClIfePk+XS1zbS9bKa0taO4Le/uvZmD3KjdLTgS
	 5JDSuADJDc6H8PMHd+j0Ba9Da8TpLsfeGiq0yFeb3uzwT1B3M00zWb4LPiN00NnMNc
	 x9DAvj4bue+GQ==
Message-ID: <e8940857-4f71-4a34-ad80-81584f7378c8@kernel.org>
Date: Wed, 17 Jun 2026 14:32:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 3/9] mm/slab: handle the !allow_spin case in
 kfree_rcu_sheaf()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-3-70a54f3775bb@kernel.org>
 <4d7ebcd5-f3b7-4c73-94f1-b7d3ac12a521@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <4d7ebcd5-f3b7-4c73-94f1-b7d3ac12a521@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------gZ9AQq0y4SZlPtbwhYO0tskz"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C0B2A140003
X-Stat-Signature: wdjnii3cdmozsjesiaqwkhejb8h5yumc
X-HE-Tag: 1781674380-970235
X-HE-Meta: U2FsdGVkX191X8UXS8Ie5MYoCB1k1sxnxRgMQwTA9QezohvQAw/RIBWWSoihAx78bfTY4Zl9dxMGKzYTyFnQVwan9XM3MfZ9Bk5F149JGzhbaisR5Sqruie67zA5XoX7m0eFhiLbx9U4i6CxYpoM+eaLoG1hMhz4P6FH1meWXrPPattuXR4gNxNLQL1bGKhAVcg7D/bNYYjTYfUq2xlFjUS4TvV3LWQyi+cUiUf8TP/YspfWQbkIoAcTrA59ExDE4lvlb6jpUMCo34DbQMuel6XBtChl9inP/5beZseya3DZgWYFfN+H+XetrNKHMcLv2LQ+SP6XALnswo8b4vf+m+dxbbdkuwlL2sqMiTTYKLjAF3NrOOUhUCt6d0tj44wXRCpMXFCJfGZLEWpuEq+HlpicjlDDR17zoA0YRuyoNdx/q6iI0mGfDUsKbhScu4P2USNM+2h6J8kMf0OD/7V1x/fiMpC0k3WQajPU8aidr1TfM876NTZ2FX/aLh0vqQhuaeIQTWWKDBMbhQVHHd+vDkNifAqaTBPAWi3d8XC4bS6jsntbMbw0dg/oY8GacEIF7xbgPmPqLZjTYTOUMkj20X29aTi3VuTPkvzYD/63SSG1CqgVQwrBtqztnibSdJAlE2auIld1gYPLZVWEwa05jkhvzqDPgkPtUleGww5pSlc7+gqoFr05pyd37PErbiHNJopLePBRVuB5/DVIXdK/+/bJzeuQ+oj0EruuoW6O8FPfJfnYtKC+Wrz5KhcHwKPxmInxsWj1gyd20PRkDj9NjA80F/RdQlWNGvROv59SzUoOKRfqZm4gb8avpHwVYL9JOlzHoBtglKZy+uAjbiOM7Gz8t7/nfRz9zKONXPU6MCDxh0G7dd+WK91RkDvV5HeokS536Scc8dozCCiZKzmbCW4FwPu4Frlqs2I/oYvLHIZ2sZ+Tsb5nr4/jhSRVl1vY2wpWq7nCtXvjx/CAkB5
 5uZ9XCgx
 beXoFrCatDMflqcZubH7xE8BIgVFJDNr9je4gBz9kkvQgpLNJQbUuBMNGgUPADIiBHJv1MveV73Y3gs1CrlHGr3F3cwRyx6hrFTNMckAgiL7eWk9cg+gCfr/CMxrNZMrgbOyX3xaAnxZVoa5Je8dROp2Km6pmAljBOUqx4H7bDF3MeyDtISAzwAw+Ro6slQAKAPl2hLWxlUywpaBgrBHxxHrsRn6mUvhLXl9lwgFOwVLimapHaDKTQRES+T+03JCbi/vDghR+kw6AvWpDHzjzr+YDX3pUc538qW6u9WcqANwrgBXxIdt/e9AhZt2E5vDkUcSpuyh+1sMYNuYzcmI8/oEIADpCJMgVoAQxKHre5uz3MkPCpgI3uIdy+NRVNvbKrA4zRn3YlQInH31gHKgT+kEVulFmLHj9ZZaZ7xCRk60O1LtMAvyZSH38o1Myy6jIvm2L1GMiHVZb9vXSLcGg/5q8hs178nEeiUHu2bsqApCdYTt+mZn19OUcVyzqlcbnPr8HtnqqvqZ3PYYykH/IltsD8ogtJCoZVCuMz41s/japMtzPpXCRq51ov44puNkzzU0h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------gZ9AQq0y4SZlPtbwhYO0tskz
Content-Type: multipart/mixed; boundary="------------oyYMwnEgsJOBwiuqZXNKiyCU";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <e8940857-4f71-4a34-ad80-81584f7378c8@kernel.org>
Subject: Re: [PATCH for-next v3 3/9] mm/slab: handle the !allow_spin case in
 kfree_rcu_sheaf()
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-3-70a54f3775bb@kernel.org>
 <4d7ebcd5-f3b7-4c73-94f1-b7d3ac12a521@kernel.org>
In-Reply-To: <4d7ebcd5-f3b7-4c73-94f1-b7d3ac12a521@kernel.org>

--------------oyYMwnEgsJOBwiuqZXNKiyCU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/16/26 4:55 PM, Vlastimil Babka (SUSE) wrote:
> On 6/15/26 13:05, Harry Yoo (Oracle) wrote:
>> Teach kfree_rcu_sheaf() how to handle the !allow_spin case. Try to get=

>> an empty sheaf from pcs->spare or the barn even when spinning is not
>> allowed. Unlike __pcs_replace_full_main(), try harder to allocate
>> an empty sheaf because the fallback path will be more expensive than
>> kfree_nolock().
>=20
> You mean that it will try to allocate an empty sheaf, while
> __pcs_replace_full_main() doesn't with allow_spin =3D=3D false.
> I just noticed the comment there is a bit stale... nevermind.

That function

>> When trylock fails or the kernel observes non-NULL pcs->rcu_free after=

>> lock acquisition, free the sheaf instead of putting it to the barn.
>> This is rare and not worth complicating the code.
>>
>> Since call_rcu() cannot be called in an unknown context,
>> kfree_rcu_sheaf() fails when the rcu sheaf becomes full.
>>
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>> ---
>>  mm/slab.h        |  2 +-
>>  mm/slab_common.c |  2 +-
>>  mm/slub.c        | 39 ++++++++++++++++++++++++++++++---------
>>  3 files changed, 32 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/slab.h b/mm/slab.h
>> index 509f330654b8..b1bd33a16544 100644
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -429,7 +429,7 @@ static inline bool is_kmalloc_normal(struct kmem_c=
ache *s)
>>  	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUN=
T));
>>  }
>> =20
>> -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
>> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_sp=
in);
>>  void flush_all_rcu_sheaves(void);
>>  void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
>> =20
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index b6426d7ceec9..bc1a8ec938d9 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -1605,7 +1605,7 @@ static bool kfree_rcu_sheaf(void *obj)
>> =20
>>  	s =3D slab->slab_cache;
>>  	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) =3D=3D numa_me=
m_id()))
>> -		return __kfree_rcu_sheaf(s, obj);
>> +		return __kfree_rcu_sheaf(s, obj, /* allow_spin =3D */ true);
>> =20
>>  	return false;
>>  }
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 87ca154ccd80..b0d38d515386 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2815,7 +2815,8 @@ static inline struct slab_sheaf *alloc_empty_she=
af(struct kmem_cache *s,
>>  	return __alloc_empty_sheaf(s, gfp, alloc_flags, s->sheaf_capacity);
>>  }
>> =20
>> -static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf =
*sheaf)
>> +static void __free_empty_sheaf(struct kmem_cache *s, struct slab_shea=
f *sheaf,
>> +			       bool allow_spin)
>>  {
>>  	/*
>>  	 * If the sheaf was created with SLAB_ALLOC_NO_RECURSE flag then its=

>> @@ -2827,11 +2828,20 @@ static void free_empty_sheaf(struct kmem_cache=
 *s, struct slab_sheaf *sheaf)
>>  		mark_obj_codetag_empty(sheaf);
>> =20
>>  	VM_WARN_ON_ONCE(sheaf->size > 0);
>> -	kfree(sheaf);
>> +
>> +	if (likely(allow_spin))
>> +		kfree(sheaf);
>> +	else
>> +		kfree_nolock(sheaf);
>=20
> Hmm what if the sheaf wasn't allocated with kmalloc_nolock()?
>=20
>>  	stat(s, SHEAF_FREE);
>>  }
>> =20
>> +static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf =
*sheaf)
>> +{
>> +	__free_empty_sheaf(s, sheaf, /* allow_spin =3D */ true);
>> +}
>> +
>>  static unsigned int
>>  refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned in=
t min,
>>  	       unsigned int max);
>> @@ -3132,7 +3142,6 @@ static struct slab_sheaf *barn_get_empty_sheaf(s=
truct node_barn *barn,
>>   * intended action due to a race or cpu migration. Thus they do not c=
heck the
>>   * empty or full sheaf limits for simplicity.
>>   */
>> -
>>  static void barn_put_empty_sheaf(struct node_barn *barn, struct slab_=
sheaf *sheaf)
>>  {
>>  	unsigned long flags;
>> @@ -6065,7 +6074,7 @@ static void rcu_free_sheaf(struct rcu_head *head=
)
>>   */
>>  static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);=

>> =20
>> -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_sp=
in)
>>  {
>>  	struct slub_percpu_sheaves *pcs;
>>  	struct slab_sheaf *rcu_sheaf;
>> @@ -6081,9 +6090,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, vo=
id *obj)
>>  	pcs =3D this_cpu_ptr(s->cpu_sheaves);
>> =20
>>  	if (unlikely(!pcs->rcu_free)) {
>> -
>>  		struct slab_sheaf *empty;
>>  		struct node_barn *barn;
>> +		unsigned int alloc_flags =3D SLAB_ALLOC_DEFAULT;
>> +		gfp_t gfp =3D GFP_NOWAIT;
>> =20
>>  		/* Bootstrap or debug cache, fall back */
>>  		if (unlikely(!cache_has_sheaves(s))) {
>> @@ -6103,7 +6113,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, voi=
d *obj)
>>  			goto fail;
>>  		}
>> =20
>> -		empty =3D barn_get_empty_sheaf(barn, true);
>> +		empty =3D barn_get_empty_sheaf(barn, allow_spin);
>=20
> Here we might be getting a sheaf allocated previously with kmalloc().

Right.

>> =20
>>  		if (empty) {
>>  			pcs->rcu_free =3D empty;
>> @@ -6112,20 +6122,25 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, v=
oid *obj)
>> =20
>>  		local_unlock(&s->cpu_sheaves->lock);
>> =20
>> -		empty =3D alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
>> +		if (unlikely(!allow_spin)) {
>> +			alloc_flags =3D SLAB_ALLOC_TRYLOCK;
>> +			gfp =3D 0;
>=20
> Maybe __GFP_NOWARN?

Ouch. Good catch. Thanks! Will do.

> Here we would get a sheaf with kmalloc_nolock() so that's ok even if it=
's
> later freed by someone else by kfree(), right.
>=20
>> +		}
>> +
>> +		empty =3D alloc_empty_sheaf(s, gfp, alloc_flags);
>> =20
>>  		if (!empty)
>>  			goto fail;
>> =20
>>  		if (!local_trylock(&s->cpu_sheaves->lock)) {
>> -			barn_put_empty_sheaf(barn, empty);
>> +			__free_empty_sheaf(s, empty, allow_spin);
>=20
> Well we could still use the barn with allow_spin =3D=3D true.

Initially I did

if (!__barn_put_empty_sheaf(barn, empty, allow_spin))
	__free_empty_sheaf(s, empty, allow_spin);

but I ended up just calling __free_empty_sheaf() because it's
pretty rare to hit... no strong opinion though.

> But more crucially, here we might be freeing with kfree_nolock() a shea=
f
> from the barn previously allocated with kmalloc()?

Well, we don't release and reacquire the local lock when we got an empty
sheaf from the barn, so it doesn't free the sheaf from the barn?

That was indeed very subtle and I got confused :D.

When we free a sheaf in this function, it's always allocated in current
context?

> Maybe we need to track if it's the case and defer-free it or something.=

>=20
> Also maybe there could be a wrapper kfree_maybe_nolock() (~better name?=
)
> That means "I want to kfree safely in kfree_nolock() context something =
that
> MIGHT have been kmalloc()"
> And maybe depending on the debugging options that make kmalloc() ->
> kfree_nolock() incompatible, if those are not enabled, it wouldn't have=
 to
> defer, but proceed normally?

But I really like the idea of supporting kmalloc() -> kfree_nolock(),
and I think it's worth exploring that.

Thanks!

--=20
Cheers,
Harry / Hyeonggon

>>  			goto fail;
>>  		}
>> =20
>>  		pcs =3D this_cpu_ptr(s->cpu_sheaves);
>> =20
>>  		if (unlikely(pcs->rcu_free))
>> -			barn_put_empty_sheaf(barn, empty);
>> +			__free_empty_sheaf(s, empty, allow_spin);
>>  		else
>>  			pcs->rcu_free =3D empty;
>>  	}
>> @@ -6143,6 +6158,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, vo=
id *obj)
>>  	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
>>  		rcu_sheaf =3D NULL;
>>  	} else {
>> +		if (unlikely(!allow_spin)) {
>> +			/* call_rcu() cannot be called in an unknown context */
>> +			rcu_sheaf->size--;
>> +			local_unlock(&s->cpu_sheaves->lock);
>> +			goto fail;
>> +		}
>>  		pcs->rcu_free =3D NULL;
>>  		rcu_sheaf->node =3D numa_node_id();
>>  	}

--------------oyYMwnEgsJOBwiuqZXNKiyCU--

--------------gZ9AQq0y4SZlPtbwhYO0tskz
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajIxhAAKCRCGXBN6rc5S
1m+4AP9ew2whcCln80iVmFOKVQp6yA+tZBtPYjgxhkggCH1lBgD+Ot0nZKepZ2Jp
pVPDKTSYJm7mbApT5N01TQjdmN0Srwo=
=rHGs
-----END PGP SIGNATURE-----

--------------gZ9AQq0y4SZlPtbwhYO0tskz--

