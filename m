Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B08C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E31286B0005; Mon, 13 Jul 2026 03:36:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2A66B0088; Mon, 13 Jul 2026 03:36:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1FB6B008A; Mon, 13 Jul 2026 03:36:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A75B26B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:36:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BE671C3E27
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:36:40 +0000 (UTC)
X-FDA: 84982946160.15.6FA1963
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9929B20005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:36:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=W0U7mlyj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=SP6eoOrW;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783928198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+oJ+oiAJmm6M2K7Ydw/ek8HK5Sp2SDGAkvAxlUMtUw8=;
	b=4tZxgL67YoLmLaqfQ8MFI9wdw+idlV1qbeR1fDVaVmddqKEMoQtDZ1pgbFqleLZL8zEIq5
	XgcyWwEsB+wj3eFG3xUojP7omQfLDHo2SBgAKlPQIYUZtFXyQykAbXuHiNw7thZsNBCAJc
	2AW1IYBL6DfxWEHj+MFVzMc9ZYCOcyQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=W0U7mlyj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=SP6eoOrW;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783928198;
	b=N46xinoI5G0pyCITyPTKZW8j7yedPXReDQSi0fOIFbbcal+UTU2ofKUFiywp4FaBWQmaau
	bhyMzk7OOkAEZ7jKzC83W2UpDrRQsbTIpt5OFW9rhn0Gi42u3Hj6PQRh9m0LxBM09cvYVp
	VmA3LCcc8zaI8v4JagE0AHVEKDyfVpU=
Date: Mon, 13 Jul 2026 09:36:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783928197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+oJ+oiAJmm6M2K7Ydw/ek8HK5Sp2SDGAkvAxlUMtUw8=;
	b=W0U7mlyjOkyC/qu/kf7Rx/Jyuc+9x1Bjgu+Si4Q/HR8XmxUngDgHeyNGyfbLVKEwQx9Js+
	TchO0iSQvF6zRyH4qCapFqKVvF4i6a5kiKjoA6OtHPnCdvOjtrGNgIMsHKzNBqKHaQnc/m
	whwu/Kg6jRa4Ec4PoqjhNVaiHyDF9MkI34iflFI4YvHwk5Qw4ddaxEeHf3nhXSr/51E1dd
	cW+WLkQG5DuD1uhX3ZCGTkZS/N4hmYTl3n3tTSDBTosSCmCoRBgNk5o6UV/hEKmwvAPYkl
	NMdrDjyEdLildLm2JagNZdO/2vvZaQ3o3/clC8VBAInNYKWOdCGxZw3wUTf+VQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783928197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+oJ+oiAJmm6M2K7Ydw/ek8HK5Sp2SDGAkvAxlUMtUw8=;
	b=SP6eoOrWruZC728Gbiktd+y7UFnGggX0GuRBK1mtb4RABNg/mE/y0Jy9niGxN4YM+I/pVQ
	m+9W2TOgais4OLDw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>, Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>, Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 4/4] slub: apply new pw_queue_on() interface
Message-ID: <20260713073634.3Hrxpfcx@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com>
 <20260519012754.240804-5-leobras.c@gmail.com>
 <20260520145308.nay9zt6r@linutronix.de>
 <alQWr2L_Kn23pxd9@WindFlash>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alQWr2L_Kn23pxd9@WindFlash>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9929B20005
X-Stat-Signature: 6bnptijhu831pnoucz6a5tuasd3rg1uj
X-Rspam-User: 
X-HE-Tag: 1783928198-617230
X-HE-Meta: U2FsdGVkX1/Idg40fPsY8g5d30O41vycTwbFuUjziHUo00vHCQTWVXzfNU+PuOCZLGS6pc7h/yX06wb3uzFa2Jjr7tTBV+hKISTq12zP3tMUiSGUXOQGA/TZYKv787Bd5+L/8FPQiam8kvQhK20FFQkNQ4QDEmI2uGUs0g+WTm9yZOw81MYVJao/9uvg72DNQg+v6bEhDkACwlRpbULINxa2XHq/Qcrj3vBPYa2ptrRi423Akf1qD++675HBDqtn43QCvjKQs+Zj7N+mTYzuzb+g9wjrrjO/XJtjp4DjO8QOmHeFhjfXBADMGcwbPbMYDysXPwAN0O6Vb4GvFu/glP7b02g/4S37Nh453mPCudRZfzy7xaHZKAGs1pv89mTH6HgetxkN6Z6ppJsYIaZaNfC2Pjys7pLp7vEfhSS/xQlyaDa31XNI8QWf9mqPCWnPaTt65xVPydCqGsHJceKjpqd+J6YWrzmUc1RQtHHYjv2sqFaixNXVjAd+mKungYBrAIjrAG23ajU991wmPtH1a0OfV+VVvXDSS+nigEHPiN3ZHcxBNRkj6JLvkmEGZxmXhRm9a8utX7sayCEhVW7BATg0SXulWs/6lbGCDoAfeNKmE43B5COEXWk2lHXHvutkbJC20kEvS3JhZ4ZjMFUOpBinDFZUgKKlpR7n/CKv1ReTDFjrDQQhvSozf04KgX85o7/Hmy5DtnfYCoSMfC8B9Tmg6HO+9nHFcp0ZzUlp2l88Mq73kki7KIt5pRigYGvTsoLtiGbNOEoJ/79XZWHBq2l2awOGK/xsIfXtT1fL+VltnFPY+zCXt1iqmmnDqWeKZpFphVKELQFrZ44kj+EjPNvElRc+HOtkwbc4ByjMVo8Lf7X2kLeIjZC3DbnX/x/TZYn++hbgxltD9MF3YDzY+88MGICumXx8KKADeD4gsmUYzIJ6TMxr/UuH/icRVIRLV+7ILAI9NyjNI5RTjFS
 CFMFQvi2
 o7CKDFAfvx2WgDnU4QXDm20K3Jm9+6uVlMGrwN0wyi+91popcSuhVTBmmZ+Tq43iNynlQX3ll4C4YWaLCDHjyFGrZtNyHYs4zMPJ8Zor+nQTKNlz+/Xz0CFUPY6y9nesLZ1KnUUUT5B+2dYMmahkKjjascanLEgIXtjbZk06/IEHws9K0mVLqCLgWOwbUMK4/Tl6Xgay5a2jCsp2TgX86Gb5upoMxQ/PFvaGwIQHx7GB+us2Nqau2OFP2LeUIiyoyZSdOV9ZfHxgyggMjhMY91wZeBMeIhWLfmX0MBpHpFBOLc9JwKHtTm1WrNguql7b91i3H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-12 19:35:28 [-0300], Leonardo Bras wrote:
> On Wed, May 20, 2026 at 04:53:08PM +0200, Sebastian Andrzej Siewior wrote:
> > On 2026-05-18 22:27:50 [-0300], Leonardo Bras wrote:
> > > @@ -4733,121 +4735,121 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
> > >  
> > >  	/*
> > >  	 * We assume the percpu sheaves contain only local objects although it's
> > >  	 * not completely guaranteed, so we verify later.
> > >  	 */
> > >  	if (unlikely(node_requested && node != numa_mem_id())) {
> > >  		stat(s, ALLOC_NODE_MISMATCH);
> > >  		return NULL;
> > >  	}
> > >  
> > > -	if (!local_trylock(&s->cpu_sheaves->lock))
> > > +	if (!pw_trylock_local(&s->cpu_sheaves->lock))
> > >  		return NULL;
> > 
> > alloc_from_pcs() can be called from kmalloc_nolock()/ NMI context.
> > I don't remember why exactly local_trylock_t was introduced here instead
> > of a per-CPU spinlock_t. 
> 
> Probably to save the cost of using atomic operations on locking, and having 
> about the same restrictions that would allow using local_locks
> 
> > But there should be nothing wrong with a
> > trylock on it from NMI as you do here.
> 
> Awesome!

The problem is always the unlock which requires full locking and is
usually the problem from NMI.

> > 
> > One thing worth noting, on !PREEMPT_RT, spin_trylock() always succeeds
> > on UP. kmalloc_nolock() checks for it, not sure about other callers.
> 
> 
> Sorry, I did not sure I understand that part. 
> You mean we have since it always returns true, we may be in NMI context, 
> after it was interrupted holding this lock, and it will return true which 
> will use the protected area even though the lock should avoid it?

from include/linux/spinlock_api_up.h:
| static __always_inline int _raw_spin_trylock(raw_spinlock_t *lock)
|         __cond_acquires(true, lock)
| {
|         __LOCK(lock);
|         return 1;
| }

on UP a spin_trylock() always succeeds.

> Humm, but if that scenario exist, then is it actually ok to return true on 
> trylock() in that scenario?
> 
> Thanks!
> Leo

Sebastian

