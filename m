Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A9ACD5BAB
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 20:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A596B0088; Thu, 21 May 2026 16:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CAF06B008A; Thu, 21 May 2026 16:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DFF26B008C; Thu, 21 May 2026 16:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1EDB36B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:20:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66B571207C8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:20:03 +0000 (UTC)
X-FDA: 84792543486.16.56B5B4D
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 762E58000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:20:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nEQtuv0x;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779394801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1aLZ0HlXtKFWVVwkKR6v6sdQWwQbXSZNyJVtm2fhj0=;
	b=HH0S2dggNQhqX+XV5NConglT7IeVZlkUgzXTM9i4siZKxG5slu/LnPa5n3uEypySfWvmxq
	+dcxYv/SJOC6r9XG8s58q3Bc6onLvba7Zg9kp3TdgyUwPoBM71K29tYVtJnRdIIaHP9fqI
	EaTiIz2zPpeKaZHQxkqL6PYqVT7OQdI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779394801; a=rsa-sha256;
	cv=none;
	b=As219vhWSfMvHnWTpu8OWHH5wsrBOFSzcRILJG29uQ8Q2q2hFkaHYlIjVLUMNQ+6N+8HmP
	Yh8r2gOywRfGdRiWvUDr0GGy4W4ajMd4ApFeey69cWxsZfOfkQ4PfTpRo3jbJ9luO0MB0K
	NNe5jUoe8jytY50U4HzUyW2ELvWsPRw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nEQtuv0x;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 21 May 2026 13:19:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779394799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h1aLZ0HlXtKFWVVwkKR6v6sdQWwQbXSZNyJVtm2fhj0=;
	b=nEQtuv0xHCBw+Ve3KoqfOdRpzaPEB9fSyUJqAB7jJ9CWE3kg2sh51MdKK42+XH6TAXbx6P
	3DDdGQc/EL1VQltNQ7aksGMgEby3Ci8DmqXBqwBgl46nUnjgKj1wNkbAdbalLyY6m9HPXM
	9g0jDjIY3sbF6wtd/Uxvz1v5PosvjDg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH 4/4] memcg: multi objcg charge support
Message-ID: <ag9hFJv_LOJh7IVE@linux.dev>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
 <20260520053123.2709959-5-shakeel.butt@linux.dev>
 <4e20f643-6983-4b6e-b12d-c6c4eb20ae0c@kernel.org>
 <ag5Z9uIMoXpr3rLP@linux.dev>
 <5b09f618-3b84-4163-84f9-f3adc0f1cc97@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b09f618-3b84-4163-84f9-f3adc0f1cc97@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 762E58000B
X-Stat-Signature: nkekhy1eb97qp7d9hnsikx3exoctxpwf
X-Rspamd-Server: rspam06
X-HE-Tag: 1779394801-80957
X-HE-Meta: U2FsdGVkX18w2TE8h94u4o9Reww2Vo5P0ntETdgV3SyU3MhNisDRFIUs3UYqlpJOpZt/jg0OQ2GhgrKH01zJyytLlk0CkXNMpyFRWq2CjqSivMaVKpe2GD/9qEEFhrSAoHlsWQTdGXy9wHWLO51L85kQqF582C9dPD5S0KRWQKkYM4UjfxE3ylQRpzv4tWBS41x80lhqBTME0bRUqeSK/nTZHcPBKOjb/ho1hvaVjNKj4AzDHpCW05BkG7VlJUBnsC3XMRapPn+Jv0L17oOk+Palalh7QcyuSOxG956ZV9PjxJcgzPzGJ9OLqM/xe/2qjZ7PpHM0QOcaEZIwlUYtTsUTwBys+5RuGines4pbkLddUHV+6vdk6ABrY/HkUYCOk2IUMYqALJwDgGNWjg8qAYnQh3L3Ohe/rEl1Pv2uz3ho6MiOa1ksy4UPcFxkfRAuOYw9opJ3tR6XnDXAb2qrRVeNDxqMgOOfCW4i5DG9pZaRdpX02YUJUEMaB1/HDyjCukyuus+kxwNfwT1UTCu4HdRsOd1fmhKRqvxVJQi1ZgTUjbO5djJOD9q2BsUElp3c1jSsd/z5IWFuEu8VSxAciFeJiUg5n8LIwX+2uBte/nsverCyT0Uc3RGz3KsT3DdNNcbjG9+vCGhnGnJs5bi3tYzUdQBTk5vzRTVSJZUSrgkXjmCQjag+65BcdDUjot80TfDW99p8laiMy2KZNjV2dLxqjgux4j8sRTPBzQi1Vt1MS/PhYfQESVVwbkIj7IEImXaqetgvEBvrQCh6XEJAl1P0VbcYLx0JjfBn6lBrfoZBF0xDgUcAJh61ChWjmZd/JbSFbvCd2Tv2cVc5e3d55z40hACtdn/tNTIyURxXAp1e5OSb2+QhSE4KzsC/y7t17H8ANBOJumZRp05cQY3O+/zmYCamWLOaJfDA6a5Y1Uci5ot9Z8M0QTHmWF5CoaNevTjWoa9zp9zA4HMslW8
 d95KEPhb
 KhZ0cA/Oynk3o+ufWkT1VduL4hvAuIxmIz+nsuXHnFQH5BPg4BVAwtb8EwNNGDSVKsP0bKvneRZFQRd+WGHf/+MO6iaJwEUMDeTVsZ21Oj6J4XhUzhy1UwiiSEvQ7exu5+xv0slARmhcyVMqyTE6sY9qpsnCQcC75EvjyEmPrdJDbneqn4/zlj5Rrnz3wARGEByaQn849nto0FybSSUiy8ADHZBV/ugfL+sY+HNyNdZW1hForcAmoR5amKBHvbzPmhCbB3RpMKXJxQaKICf9T6PpuIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 10:43:11AM +0900, Harry Yoo wrote:
> 
> 
> On 5/21/26 10:05 AM, Shakeel Butt wrote:
> > On Wed, May 20, 2026 at 06:35:30PM +0900, Harry Yoo wrote:
> > > > @@ -3350,19 +3405,45 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
> > > >    		goto out;
> > > >    	}
> > > > -	stock_nr_bytes = stock->nr_bytes;
> > > > -	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
> > > > -		drain_obj_stock(stock);
> > > > +	for (i = 0; i < NR_OBJ_STOCK; ++i) {
> > > > +		struct obj_cgroup *cached = READ_ONCE(stock->cached[i]);
> > > > +
> > > > +		if (!cached) {
> > > > +			if (empty_slot == -1)
> > > > +				empty_slot = i;
> > > > +			continue;
> > > > +		}
> > > > +		if (cached == objcg) {
> > > > +			slot = i;
> > > > +			break;
> > > > +		}
> > > > +	}
> > > > +
> > > > +	if (slot == -1) {
> > > > +		slot = empty_slot;
> > > > +		if (slot == -1) {
> > > > +			slot = get_random_u32_below(NR_OBJ_STOCK);
> > > 
> > > It would break kmalloc_nolock() because _get_random_bytes() uses a spinlock.
> > > perhaps prandom_u32_state() should be sufficient in this case.
> 
> s/spinlock/local_lock/

I do see spinlock in crng_make_state() for some code paths.

> 
> > > Is there a reason why it uses random eviction, unlike multi-memcg percpu
> > > charge cache?
> > 
> > Oh I didn't know and actually we are already using get_random_u32_below() in
> > refill_stock(). So, it need fixing as well. That would be a separate patch.
> 
> Ouch, I see.
> > I will explore prandom_u32_state().
> 
> Thanks!
> 
> FYI, SLUB had a similar issue that was recently fixed:
> commit a1e244a9f1778 ("mm/slab: use prandom if !allow_spin").
> 
> It uses prandom if spinning is not allowed when shuffling slab freelist.

The drain does not really need a random number. Fixing an index like 0 makes it
much simpler but it might expose some corner cases. Round robin might be enough
for this though. I will see what would be the easiest way forward.

