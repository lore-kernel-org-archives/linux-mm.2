Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B581C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 21:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C20F6B008C; Mon, 13 Jul 2026 17:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173696B0092; Mon, 13 Jul 2026 17:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016AD6B0093; Mon, 13 Jul 2026 17:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1D676B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:44:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F0641A01DA
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:44:55 +0000 (UTC)
X-FDA: 84985083750.10.4C50B1B
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5DBF4A000D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:44:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KlQnoC+s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783979093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5DZ2wnEYE0t0eLEvNMJDLzTpJbDUy0ZG5iAhAz+AYU=;
	b=E0yYF6W5ib7oItupVNKcgi5EyHKGQqpfnKUuZ36OkNeln6g3Y/ZlSe77RVw7LlXVQOOgM4
	Hr4x92+5+H8nI+WqF6twlhSqueBkXJTXnR8gPEuy2v1UDddA47zUms2HjLOneSTBwotVcV
	nphX4fp5B668AWyUXif0mb1WuSDFncM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KlQnoC+s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783979093;
	b=lgwXCOqF6Mw/XUFc988dES3rFOxc6ICQvwxDWXP937dThHJKO6i8ywoc9j7y27TNNuXYJv
	QjcmfyU7rNCrt0M6YJiFcONdQIr5oYId9+Lk6Won2YB5EkT+DIiA56jsjqsoNl4OsXhxby
	N1lLYWhbYLPWPdfWBybqbhN1EUHcK4A=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493f25d47dcso2286205e9.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783979092; x=1784583892; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y5DZ2wnEYE0t0eLEvNMJDLzTpJbDUy0ZG5iAhAz+AYU=;
        b=KlQnoC+s/T1k/QAYcnvWIIFdjk7PPpoXQ2QcIrs+9j+5sQgmOpF9kWdAxw+K02WNG4
         Ejc0g7bfoTKVJiGlBZE2pT8uxgGsyYpk5BbzSSNIj14eJONp5Qkb95uuqzyeMmeALe9J
         rG8qSAnB6JTdM3q0eD9F0IhtuNIykxZvjzaHuiRHtGtz8WJpp/nCtd3GA5iyApLnFtFJ
         q56k8llYgkY07Rj1iOoXgyHxWbMA6yZBNJrjcKtWo9I5j9ngvoq2E/i8OwZztkGqJwtN
         r9eue+8pztGktJ+wjkoM99QE+5TUyD2vNqUHA56s1lUQk+VVI1W83mIFY7SZhpnZEoFr
         muog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783979092; x=1784583892;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Y5DZ2wnEYE0t0eLEvNMJDLzTpJbDUy0ZG5iAhAz+AYU=;
        b=NA9pFAgtx2poc2V7WliccoHKYNtnCZIi91qSQ61wWIEA0ZolA05mJmlsDGU9H0ri1D
         m/gMuVzdJA4b5lK9aMD3hC+tiM7a1tQ/0UADVPOre+JMAemRXE/rv6cA7rOtMI1mxjqU
         kC+iwgycF/1f6DmoJou9ek/FicPVhmVskfThL8UokjndoChzbX/NsNHriX2Gh/Uh4CeO
         pBSiOyXa8X8emDMU+c719l6PjKF7kza9LzkXIFLctvta079zCDUV2ZVH9B90GC+OEswr
         4MKUcOveAUm/EIJJFGwn9MahXaXImqxUcpjZ+TOfOzl8qyplhYpjCXG71dFELq7sMzfa
         vbug==
X-Forwarded-Encrypted: i=1; AHgh+Roq9g/GG6YC7gDWg+4mGeXKtL3SoLKEKJ1mR4khMFeowdQ2G9PzVLZBQMMB50B8OX5eW48YP0/V8A==@kvack.org
X-Gm-Message-State: AOJu0YzbsuOrx7o0GusppkU4HlETqFmL2zcBsBjVsNDY6NoJfNCgj4Ji
	DKaVo8jPhVG+XGpSdzDV8sfnJSn9dm/rMGqgYAZXwIiyvEgnthaZ+6J6
X-Gm-Gg: AfdE7ckSMFnrHUd/M+E4rzCvIZtG6J61/hiRm+Yh/biXSfw8pyu4nxWF8zQw21/Nt1N
	TARsbyVsAcWSRf6Nhe2zZPbYM/w4mj6IQsmvlt4NIJXgyBbEe+IjJferu7of1lhGiBzJhPV1Igr
	HQ80kXX+O9ms3XKrcd0kzJVcJe/Oz0pNVRts0Saq3za+YSI4G97EE0kdzBhXv1jPq8qyR++THF8
	L+J7zz8QSk86TZOiKquapLcxBncq/ybh3clSWKLZSV4APvA6aI3Wf0yUK7h2N2RvoWmADySYuyZ
	8BeBqilQNajebqGoizDmITjxp/VIuLDjG/hGhLvCESxwb9rUKnYfXr34cT7ZuMl9DwLJlwGRghX
	e5SW3C5ATC/LMBNtQAWMu/oxzoM8hLjBThbmC3v+3xNjOeMeK3By06eBj8ordEnbvfqYluks2j0
	GLOxt0BUrwY1VrJwHPaPferQ==
X-Received: by 2002:a05:600c:6089:b0:493:b7cb:c5f with SMTP id 5b1f17b1804b1-493fa8afbb6mr103142795e9.11.1783979091931;
        Mon, 13 Jul 2026 14:44:51 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49506a1fbcesm23074035e9.0.2026.07.13.14.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 14:44:51 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 4/4] slub: apply new pw_queue_on() interface
Date: Mon, 13 Jul 2026 18:44:49 -0300
Message-ID: <alVcUZcSeLf187VD@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <157f60cb-ff83-4fed-8b05-e6c6390f85bc@kernel.org>
References: <20260519012754.240804-1-leobras.c@gmail.com> <20260519012754.240804-5-leobras.c@gmail.com> <20260520145308.nay9zt6r@linutronix.de> <alQWr2L_Kn23pxd9@WindFlash> <20260713073634.3Hrxpfcx@linutronix.de> <157f60cb-ff83-4fed-8b05-e6c6390f85bc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5DBF4A000D
X-Stat-Signature: nohbmodc9abjwfp8pff5osg97k87e6wy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783979093-683191
X-HE-Meta: U2FsdGVkX1+oL/u6sOeG/ZxOdd6f9Odilstcnf62ykREaZQZ3iHawW7uifdavzBBm0SQtTZn3ZKCDfYmVnH1xAC2zDXH6VTI8VOiFzfqvBuWK2E7v1yORLR7wjN4VQL4UDozVrLCYebjqBdQqmKY4xNfg1ta9ISZJ7lwSd/a8ThaQ4tdcZ6WETY1i3aamnZmxt8nSYMLMp0VfBflcLrbgBoird0zZq4vYMZlqMR/Mqeka3yMresmapr33n7QwPDYPv8hSgHWOIYTGq+rv1sdVtN1Pzwg52ppXlL9UfyPAARo9MY6j4hvjgleFOt5oG+QcJaV/JDgDou3nWny6tTBIOiPiBWH2X1dvg3cpsKseoYjGI43BtOptV4HEyaqXjm5SNqWWaE0aU+fvReP02hMZDWRQruleyWrRyYoLchKvFHxoUoAxLGRrf7IQ0l14hQvh5nVp3sLQXjyfOfQrqGrRRe7u5Z5ZlpSrKfh0AbK+tUjp6ckrQppNwwJfF8Kp8M1OMC6qMrPXVEo7vyo/TBuvTR+ui4Ruiu4Kn7SNk9WJSL/X1SD62zAXqi6oeCIu+m2OuKuAIaZzqQVdt+ffhERbyhmdrg93xC/Brx67OWdP5hbMmkKZh9HFsmyQ2kwKGMFFIo8ZknAJ8v+yDkZyrjfn6p1ThYoGfp3AN6onJGMhffYKcsAC6QY1khRAOxjmklxXHqkbAk84ofSiptaKDr/mht4lf3RYrZIgwUUXuUNaQXfwJAhpV/YnMEhMMLqB+kmKdvxCAyZu/R4dinKrcFT0FuJ8LXySlEd6wYrSb0c0hN2tquKNS+1B3i8QTSpv/U/1Aq4/3dCmwL1+v4Qp+XwoE9bmEWNPGCli8IM1/QD+Xg+jMYCW6rQatO35tLjN35/Zd1tHtC7x50SelwyOMbhhvLCul86J2X527HYZxnkM/Qilcjg9gpFffFAXgStllfXWrLCLMeS5Bb4kyLPwMT
 eqMRS8lD
 1AwzjkJ054aIe0lPzDLuCVBFHV/3F0rG10WQD/rrf67UfmxnR6YMoW3c1Q41BNHzUQamdxuizLdMB5ighLUk9KmixP8sQqjatrQPW6HiQW+V9H9rca98fajk8ATC/fdjCkkarzaEps2fkBGdVnXCqeD4OT4OfplyFX8i1ksqqORxaT2yyhQe8CfUNaaD5KaL6Wx66DOv6YBDqvRBpa++v4COUqXj6IBkY9obHSu/ndxtcCDZuXYbiYYTe+1iJFs039Wh6pOm3u13ntpzULXLu5tpem43C4CuzRVVwaX0VVfHkKclguBmBZ+5NTMAmf4iuPYIZ7HRs3dinJk4Ei45DyHLSo9d6j/i8Y9kMlmF5qGFGXm/j+8ccsne1bAJXYNW7fh5a+bbVBvMluPpdT7cu4CQYyLPHsTcuCHkjxBGuADjPRuubbsH1CJqBv/HcdQaF54LIpJOduOTne9E/0gH+FM9b+DcyTKzB1VnaoVU2WuC6bPGv4yk5C6FHoPn1qxR+3Lj7iCOlFR5uTPUhLpU2egW8mI5/KmN3zr0xxadimaHyuQB/OjpKNhClD/Ig3I4DMIJrFW6MGxORNTOP2dfid6ltAaFgchmyYaM+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 12:55:36PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/13/26 09:36, Sebastian Andrzej Siewior wrote:
> > On 2026-07-12 19:35:28 [-0300], Leonardo Bras wrote:
> >> On Wed, May 20, 2026 at 04:53:08PM +0200, Sebastian Andrzej Siewior wrote:
> >> > On 2026-05-18 22:27:50 [-0300], Leonardo Bras wrote:
> >> > > @@ -4733,121 +4735,121 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
> >> > >  
> >> > >  	/*
> >> > >  	 * We assume the percpu sheaves contain only local objects although it's
> >> > >  	 * not completely guaranteed, so we verify later.
> >> > >  	 */
> >> > >  	if (unlikely(node_requested && node != numa_mem_id())) {
> >> > >  		stat(s, ALLOC_NODE_MISMATCH);
> >> > >  		return NULL;
> >> > >  	}
> >> > >  
> >> > > -	if (!local_trylock(&s->cpu_sheaves->lock))
> >> > > +	if (!pw_trylock_local(&s->cpu_sheaves->lock))
> >> > >  		return NULL;
> >> > 
> >> > alloc_from_pcs() can be called from kmalloc_nolock()/ NMI context.
> >> > I don't remember why exactly local_trylock_t was introduced here instead
> >> > of a per-CPU spinlock_t. 
> >> 
> >> Probably to save the cost of using atomic operations on locking, and having 
> 
> Yes. Also function call overhead as spinlocks are often not inlined.

Oh, right, I remember getting numbers on that. Inlined per-cpu spinlocks 
take much less time.

> 
> >> about the same restrictions that would allow using local_locks
> 
> Indeed.
> 
> >> > But there should be nothing wrong with a
> >> > trylock on it from NMI as you do here.
> >> 
> >> Awesome!
> > 
> > The problem is always the unlock which requires full locking and is
> > usually the problem from NMI.
> > 
> >> > 
> >> > One thing worth noting, on !PREEMPT_RT, spin_trylock() always succeeds
> >> > on UP. kmalloc_nolock() checks for it, not sure about other callers.
> >> 
> >> 
> >> Sorry, I did not sure I understand that part. 
> >> You mean we have since it always returns true, we may be in NMI context, 
> >> after it was interrupted holding this lock, and it will return true which 
> >> will use the protected area even though the lock should avoid it?
> > 
> > from include/linux/spinlock_api_up.h:
> > | static __always_inline int _raw_spin_trylock(raw_spinlock_t *lock)
> > |         __cond_acquires(true, lock)
> > | {
> > |         __LOCK(lock);
> > |         return 1;
> > | }
> > 
> > on UP a spin_trylock() always succeeds.
> 
> Indeed. This was a problem in the page allocator, because there we don't
> even disable irqs, so it wasn't just nmi, but an irq that could get a
> false-positive spin_trylock(). See 038a102535eb ("mm/page_alloc: prevent pcp
> corruption with SMP=n") which was a hot fix.
> 
> This was later cleaned up with 3 commits starting with a373f371166d
> ("mm/page_alloc: effectively disable pcp with CONFIG_SMP=n").
> 
> Since here you're also replacing local_trylock() (with no _irqsave) with
> effectively spin_trylock(), the problem also won't be limited to NMIs and
> thus the checks in kmalloc_nolock() won't help.
> 
> But I see in Patch 1:
> 
> +config PWLOCKS
> +	bool "Per-CPU Work locks"
> +	depends on SMP || COMPILE_TEST
> 
> So that's basically avoiding the problem in the same way as the page
> allocator after the clean up.
> Maybe just remove the COMPILE_TEST part? It's not clear to me what it
> achieves. Just make it require SMP as there's no point for this on !SMP.
> 

I don't mind removing it, but IIRC that was added by Marcelo, I have to 
ask him the reason he added it.

Thanks!
Leo

