Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB48C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 10:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C176B0005; Mon, 13 Jul 2026 06:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5E06B0088; Mon, 13 Jul 2026 06:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089716B008A; Mon, 13 Jul 2026 06:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3AAE6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:55:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71CB41C922E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:55:53 +0000 (UTC)
X-FDA: 84983448186.21.4C3FB46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B27CD20007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:55:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QqW05C7F;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783940151;
	b=oZT4P2dQCD4jmxkNPcdWmHcp337r+HAczsFjjGfIq61GqY71jmilR9rXu0GIFpOz2hLnrQ
	WzqevYi2ecmyaBRiat4Dbic7yQvyAN4ABis9veGlPdS3vLKmz5M4BYOaxv8P1LUYJMulQl
	fUkfr7jwDyudWIdTJOdk1iWNjQss+1A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QqW05C7F;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783940151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c0ggmWwX6GQOIV2l6a9PTnt/FjxjzQ5JHVZFBNdoHA0=;
	b=WNETqzChaVv3YO02+B23fp7WZl90fKmy9OPhV/0PZy4WwdC+abaClsBFD4uRClJmYiRBlE
	aS5ifxw4aX4hFkG5rZOoIb7JZ0sbzWv8m6zrtY1fvOzoG4sAS+amRX0edWSdVtZkI1sVoy
	GgXU8dLdNvBEocbnjmXpRNq1nCO9gGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A38F6004E;
	Mon, 13 Jul 2026 10:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC801F000E9;
	Mon, 13 Jul 2026 10:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783940150;
	bh=c0ggmWwX6GQOIV2l6a9PTnt/FjxjzQ5JHVZFBNdoHA0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QqW05C7FDH/qY4mqQTK/rn2Z8orF2/BAGrrSIH/MKrBIfeJS2VkDrHXWEUeT0foEd
	 OHQSGFcgVgNHQnJNMr4U/aQYgBMXT9iTkr0RnBe+3Yp2dtocgfBhQwhOr2RtaBiKtK
	 11RtZ6fmUGSAlfNSC32jUacIKi3fGNNjHP97AdNaqeObRSnH+DJRjucnwCsodSvUnQ
	 HejdBAYDHoOY1nPXbvcZR+5p5WbkE1oddzzBQQCkUHLrEpf1nbXxsqY2H7t+Vz8Cfy
	 6YVR3o+tfhmFEYDOowXc6b4h/7XAsXQNrMjfjvpHkccIHNv3zUMRoTAByahUrWxYqu
	 qY+PGicp9lQ7w==
Message-ID: <157f60cb-ff83-4fed-8b05-e6c6390f85bc@kernel.org>
Date: Mon, 13 Jul 2026 12:55:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] slub: apply new pw_queue_on() interface
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Leonardo Bras <leobras.c@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Waiman Long <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Randy Dunlap <rdunlap@infradead.org>, Feng Tang
 <feng.tang@linux.alibaba.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Li RongQing <lirongqing@baidu.com>,
 Eric Biggers <ebiggers@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Thomas Gleixner <tglx@kernel.org>, Douglas Anderson <dianders@chromium.org>,
 Gary Guo <gary@garyguo.net>, Christian Brauner <brauner@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Coiby Xu <coxu@redhat.com>,
 Masahiro Yamada <masahiroy@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev, Marcelo Tosatti <mtosatti@redhat.com>
References: <20260519012754.240804-1-leobras.c@gmail.com>
 <20260519012754.240804-5-leobras.c@gmail.com>
 <20260520145308.nay9zt6r@linutronix.de> <alQWr2L_Kn23pxd9@WindFlash>
 <20260713073634.3Hrxpfcx@linutronix.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260713073634.3Hrxpfcx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B27CD20007
X-Stat-Signature: htpbkpiib3x11ks53mwwspjwhu8a976y
X-HE-Tag: 1783940151-771462
X-HE-Meta: U2FsdGVkX182JGjCDNl25Nnn2CdieWs+EweEThT2ynzkDm5zo+V3ZEO8b9dHV0MSPzrxo7CGx8V72SR3gSSB8xmmSYFQ6hHsdzkBxhsFNSKkOMR6OJw6rFZbOqZhbxFL9+ZCqbx/WOKqmEvNnwqis+3LLxU0+ryUaIQwvaW1LWUMFLCIg3Hh4Nb2VonJO9dhm5YWEVUSHO2ZKQ6LD5dzWjSpHiMMkQ0uEgQGrTY7OC+BJGSkt6fmKn/RxWiSgidI9/xMEd8nEiBLnnt+3+Yub5SgGODa8GoxLscjPq+CrYkHiu+XINVursWUivfiabuZiovDZ0QvbayGXYywzJcUYMj4+vevbHZEVgNRC5k7/+aLFZuJvqWrtexLs8dG0+Sv9DepHa+/nmC0xUNsA1/EVopK1dNOWVE0y0Wcr2hWIecjNGN5Arg8u+7qRf3DGktItg1Ca9axTmBemiPbxzf8BGthX/2ZGtgynxxnMZS8DWp+9SDxlvyu1thPAN8oNgsNUicIgTBuJ8fbuqh82B81F1w3e6yWfjK+Swq4lPRXmVA4u3imQqCFM9rrpQzyCUXBVRyq7P/d5Z3qj2QXlCzzxNOQsD0zSB+qTyq7UJOb9PowCs3ibDDAUucm+9gfc6L2UgqvJv5ge3EgIQqXRQLHOFFoeZwMH+mXRLTSR/bRwlpUh57jApCoYLKxdwyHrJxeLPkhCPkQmSwxMxyJ1ZTF0gk2VsxdCDRhA7QylcZ68EnwMLEd/oDxQcXSOpvqpKKpimvoyjn9OblY/fHhFyefi2GTn2ShRt96eQktHh8OyMFA1AwQtGtUoR4+SZ0SVddligWzkjxZjkeOnT9Ursn2t9oP4C45rfykLv+XNX8NdTHXG6l0llvloaNQa+XXRChBCulfFN1QQXzT1lxlJBZtct6YWN4t+aGex1XCp1Mr9kD/YBzcI1UsUYCCUrcapIFXiY6yFW+mfPfwsjM3GI1
 ROBHSxz2
 jYAbeWVZtttNH7cfuicc+xcuaHByE8YA4AeEQelgx61/0p1SC1Buq3gPU+NvHczp3rof6fos3S5PhxDlJHwf6haLWrHJE1Eza4lDCpkYfVEnQxdmjZaVHUrirzp7um5Ryq0JXZrATVYrYNog823KpHecfncdH4/RfxjjSZCBn9zPUyfgW6lhkI4Znj0yqkvs+SlBH2mzTHx0vy42+iDr6cXt9QKiyUGhCERqVB7LW5H3xx7ysbSjiBBhGcEJz6xKL4rbRmnkIrJ18qvMiyYlvisBdsL/y+OObH54VhhpyVInxk+uhOuqVkU9rWSYqrMh9aT+jn3vHyBqSdQtJE8ZUo8upe9ufplPyKJX1g1RyzdU5oNaA2SkrLgkwtPTUKug5WoEQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 09:36, Sebastian Andrzej Siewior wrote:
> On 2026-07-12 19:35:28 [-0300], Leonardo Bras wrote:
>> On Wed, May 20, 2026 at 04:53:08PM +0200, Sebastian Andrzej Siewior wrote:
>> > On 2026-05-18 22:27:50 [-0300], Leonardo Bras wrote:
>> > > @@ -4733,121 +4735,121 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
>> > >  
>> > >  	/*
>> > >  	 * We assume the percpu sheaves contain only local objects although it's
>> > >  	 * not completely guaranteed, so we verify later.
>> > >  	 */
>> > >  	if (unlikely(node_requested && node != numa_mem_id())) {
>> > >  		stat(s, ALLOC_NODE_MISMATCH);
>> > >  		return NULL;
>> > >  	}
>> > >  
>> > > -	if (!local_trylock(&s->cpu_sheaves->lock))
>> > > +	if (!pw_trylock_local(&s->cpu_sheaves->lock))
>> > >  		return NULL;
>> > 
>> > alloc_from_pcs() can be called from kmalloc_nolock()/ NMI context.
>> > I don't remember why exactly local_trylock_t was introduced here instead
>> > of a per-CPU spinlock_t. 
>> 
>> Probably to save the cost of using atomic operations on locking, and having 

Yes. Also function call overhead as spinlocks are often not inlined.

>> about the same restrictions that would allow using local_locks

Indeed.

>> > But there should be nothing wrong with a
>> > trylock on it from NMI as you do here.
>> 
>> Awesome!
> 
> The problem is always the unlock which requires full locking and is
> usually the problem from NMI.
> 
>> > 
>> > One thing worth noting, on !PREEMPT_RT, spin_trylock() always succeeds
>> > on UP. kmalloc_nolock() checks for it, not sure about other callers.
>> 
>> 
>> Sorry, I did not sure I understand that part. 
>> You mean we have since it always returns true, we may be in NMI context, 
>> after it was interrupted holding this lock, and it will return true which 
>> will use the protected area even though the lock should avoid it?
> 
> from include/linux/spinlock_api_up.h:
> | static __always_inline int _raw_spin_trylock(raw_spinlock_t *lock)
> |         __cond_acquires(true, lock)
> | {
> |         __LOCK(lock);
> |         return 1;
> | }
> 
> on UP a spin_trylock() always succeeds.

Indeed. This was a problem in the page allocator, because there we don't
even disable irqs, so it wasn't just nmi, but an irq that could get a
false-positive spin_trylock(). See 038a102535eb ("mm/page_alloc: prevent pcp
corruption with SMP=n") which was a hot fix.

This was later cleaned up with 3 commits starting with a373f371166d
("mm/page_alloc: effectively disable pcp with CONFIG_SMP=n").

Since here you're also replacing local_trylock() (with no _irqsave) with
effectively spin_trylock(), the problem also won't be limited to NMIs and
thus the checks in kmalloc_nolock() won't help.

But I see in Patch 1:

+config PWLOCKS
+	bool "Per-CPU Work locks"
+	depends on SMP || COMPILE_TEST

So that's basically avoiding the problem in the same way as the page
allocator after the clean up.
Maybe just remove the COMPILE_TEST part? It's not clear to me what it
achieves. Just make it require SMP as there's no point for this on !SMP.

>> Humm, but if that scenario exist, then is it actually ok to return true on 
>> trylock() in that scenario?
>> 
>> Thanks!
>> Leo
> 
> Sebastian


