Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC595C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 20:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16656B0005; Sun, 12 Jul 2026 16:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A08B6B0088; Sun, 12 Jul 2026 16:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8187E6B008A; Sun, 12 Jul 2026 16:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5221F6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 16:49:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB0A7C634F
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 20:49:53 +0000 (UTC)
X-FDA: 84981316266.24.0946175
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id EA2511A0002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 20:49:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fHXZma0n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783889391;
	b=WETDNnN0tYCiFKrvPHL3gYyTXZyZyU1RMm1SFTwiyRJkgdmFU7rsn22jdvYxKILATmlhjx
	SvtTZP9w5cSvxGYPTDR/24SKdV8Mjib7j1jchbVOPwJDKtbLdDa8Dnkv/DTVB+b77haWyT
	azcPVPbQPXGQpJfcJ2svpJnZrdyPgO0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fHXZma0n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783889391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDEBrmK5ELlZI3KMGYQTdjOrzTJtzhLAoIt0p9CXoVI=;
	b=LF4y7R2QF7qqX9e/WULIhFiAZKoxGRAxpbsWRZZ9N2NOqmYtTt/epLxb4ZKvRQ5+ePpgxj
	MLaKxU5ol1+7rInsArvdGZq/zyCAm3Qqm/qhTDKDW/Pkm2sOMYb/NVVa7CPjhMQ/xlY5ZP
	SRlTdzf0fhvNHt3+TsAv60D9ml0m7is=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4758b2a9e2aso1406351f8f.2
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783889390; x=1784494190; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iDEBrmK5ELlZI3KMGYQTdjOrzTJtzhLAoIt0p9CXoVI=;
        b=fHXZma0nH5r0gAmhY/KJLuGbUAFEkVBJesk67j8pq/30tdtU2qL7Ozh94EwwkArkAK
         wi54j1x1DpDT0SRoUwMkstig/ctwhGCYAjamotGE7SOT02xwAnjxPHdCGQps+DpLMfza
         kZprj0c1XxHA+UrHUusvPc5yUkdl93AC0DguwMGSnWT/QmSiVnDCO4x4mM+A/IpPkbMP
         +9tTcV1PklPKtjUNgFgS+aJuRDiTldmKnvyO7uXh8Uoml0tXk2oBxhvIBqA6KHlAROSh
         VqehXAh34ojOPzQYMflwQXGV2yjibCHpYwKMleP21jWqdUZ8gZAQ5dxyKiahsXJlQUUq
         1lew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783889390; x=1784494190;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=iDEBrmK5ELlZI3KMGYQTdjOrzTJtzhLAoIt0p9CXoVI=;
        b=poQWbfN1+Stxwbcsnbp3441aunKa7gVozaUGIQpCfJrkFxRue+K2Mt/CqLymCq/2qo
         lgihvDOQvCyGv07Q8AbvWDS0wC10H0relq4y0gyWjcdsdO/5+wNCVZ8/02kK/yRroweZ
         8CMpWxC/enAHhLYrZ8LHBdPxzpZt6lQl9OKJdzSQM8Vlq/b5QTjYifMAtTu9bwej3le2
         vC131iIbtwXEsZhqR7SYo35bqCTHQW1dKnkPgfYDvABQmcW6dVSIhvHLN0vvLhxAAx75
         5CrByXqB1A0N15kgdmUYucv4Oka8x0stswF/OxQci5WfRh8jP8LgGq7+GC1J5gUiCirw
         Ih1w==
X-Forwarded-Encrypted: i=1; AHgh+RptYjWrnTxPWCOqIapmXmYbu6/3XZO0mbtpxHCdowShsvmjxaow3zJ2UwkcBT8KMDi8XpKVTttFvQ==@kvack.org
X-Gm-Message-State: AOJu0Yw4Z34Tc/b7ujwiM6XiiuR7Vq+rcpuPXR/sUPjR7tQz1oaPoTBc
	tBQA1FbOUDv1jt6OqqnCw/SzFsXsrpIpZoqJt87jT+yvOyOsCcZ6Q9S7
X-Gm-Gg: AfdE7cmL3kmE8OuCE5LFG0UqujeMvCQ3qg+OveJ6f/u3uu8dlZcHjLd+3DloEgSuacb
	k5FtcvzMVv3tbPlk8iiR+YpgkRNfjk6tOg4SzIRCdqZe52g9sVX1uwYSQtByhonqsNRZxAO4vid
	IPCPs5eT72+iI04/9RT2wFJ94O185eT0XKWKI9/frGyGObGVu/FwsHmZ+vLT3m/a1AJ5z4yDqak
	6lUPCQrkp0mXFREOqTsbL+5e4y6sfDYgn1bWMeb0JYJzKfDHAkKH16uGt8Q0OV6WPQGJehp4tsq
	iRhhNfjFKOFWJvP2gZJTMT1c8ekg7RlkUEWj3iUjRAwPWnHxdbr9BgdUFsvNvo3wxb/Ht99qQFS
	g62lbbxARbHuAE/qNCTUXECit+A9W94bBGTL8Z2Fp0x0TdxpCRmbJARZObuWjr+lWqS7XdcKM7/
	+cz/d6woE9HoNdKoa2ZUFrTg==
X-Received: by 2002:a05:6000:2209:b0:47e:4b03:1aac with SMTP id ffacd0b85a97d-47f2dcc657bmr6545301f8f.38.1783889390356;
        Sun, 12 Jul 2026 13:49:50 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960634sm80618062f8f.26.2026.07.12.13.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 13:49:49 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
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
	Vlastimil Babka <vbabka@kernel.org>,
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
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 1/4] Introducing pw_lock() and per-cpu queue & flush work
Date: Sun, 12 Jul 2026 17:49:38 -0300
Message-ID: <alP94iaRUgnqF9Oy@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <ag2IDR-JWn8k3bUG@localhost.localdomain>
References: <20260519012754.240804-1-leobras.c@gmail.com> <20260519012754.240804-2-leobras.c@gmail.com> <ag2IDR-JWn8k3bUG@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA2511A0002
X-Rspam-User: 
X-Stat-Signature: keog5uuj8math7kf7qpr9pqb8eoog6bd
X-Rspamd-Server: rspam03
X-HE-Tag: 1783889391-792397
X-HE-Meta: U2FsdGVkX1+TjVTx33FPsc1O5UjJTPxkNN3fWUaAPCVmr2NYOGaNesKu4cOnVddg0AshqearnfpvGbiHNtzosQHFt5rmbuA/nzvdHh+pcvV86TiPjrbkZac2epNU2lrcI6G6BKTA1qUFNs2yXUMEKVvGook4ACsxLYiWxVkHSDn7jqnBIBoCQKEN6j69cz3O0eQm4QJTcdBWD2LA4LURXBAjYFWf0X4WLPtEfMZwlJ1j7EMmJiCFlEizHgqEi1jIv8wiHewK25H2JIjBqUIeVCh/5iW2DZteRSp7ItMH3gIoFkfZDnorI8Edc0D99FSc15qqdYVP7crSHQlaY/7s4n0DIWMmYomxtP7pnANzg7iOI1CziSzjvpX9V6tqrqIUUHHSUfzi5g53RS/CgWUlTgiqxfP8vkNeFNSwGqUO1XB2DjasDBgLpkMXPq3T1ATKFgb+y2Pm3+UfpOOJ7wBzGgK/iib9HMsusLbpENfxgdE53Bd4q9TYvwoIbl1lYf/+u3QqV4fnnbq7wpqMZVMEXqBSt/zixbhSr6tWDuVQm8jHZyhtT210WsM+EvGxMb7lNtU+60+SMU2Wt8auKfjEQhVZglM9XXoJvprMxAzNzLta+PaE5c6/dc0SOm1IopOi0Itf4TYRCJ9RoU6f7nHv8IRk1fk3PGltwhN0ifPURhCg9JGIzeLUk50YHtddDzdNxbnA1KJx9rtVnWdzW4NroOEM3OeNRpLv1TjfH8XbSiomHjfoj5mAOp7LlSB3F9DnaeFaQvN3Qze0aAgnwNcYUS3YTvlRUpRxTrW51XMJhv5ZGtxsg5PO9MBZRthCeECS4PxBA35sKq7cudvqrNX2ukBn5cBIPA3aEoiJ8iFWrTXmCiOo2JdZL5d0+o4hL+1KwqQlE1UaYoSu8oLPhWDnQ4TwhYHNRwfY7LD8E2O/x6yFqcCQes7eo3D3dvkjGr0cbZkTV17BDS/klsOV+qg
 SQg0cBBJ
 v7GlKj41t08CqR9IHKHFmTbkilFbZqnXOGVjyaR2nNUDnMzRBgC9gpapFgG1JwpclbaOHeFgZeU34KcFsvV+KhvkYHcWXXVwld5tfM2Lc4+YyAbx1Fy1oxQtm6qvjMiYMsNLdzC0Kql3M0R/ibCXO9nwbE4ZekevtlIdflXHv3IiD8+KP4mqQMtbkhRuoFaeM3g9tgH2VC+jX4devMT8XvSfliK/WFDfbhoOhqrVl7zCTDNI3ns57g4Krziqnhujg1uK8KstOcnQwnjjW3DeJHPOMywcZeu15XltcXHI8MgxYp609U3NsnUpNIcRKhv0NuV8DH3tB8FcOPPEDY/bjIVurmHsE0vOO+SQ+PsELQte6OWp0QYMC+NHRCAQDr1pzZYwfoWo5fZOtJeqU1nbG77PjoO7wAkj8sgyv+Pz3Ac+VDBwtdXe2ThqxUo8ZPEdb3mbNBjLBA/C735fy9w64/qTm7RTXOpZ1JfzgpuxawGf6U4ivMpgqlvPhksbVYzLs1h2B68D9eG8tko1rTHHUMYetCud0ctbIcXHznhd1Z+2fut0IkqMU+/oGDklW0QDwTPvECNQUkA21FM84aOYTuueJdwa0tPwF+FfC3Cn3B0OTM2n0LyWJ8u+6B+a9HId+qs4FNO7SBTpwv8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 12:08:13PM +0200, Frederic Weisbecker wrote:
> Le Mon, May 18, 2026 at 10:27:47PM -0300, Leonardo Bras a écrit :
> > Some places in the kernel implement a parallel programming strategy
> > consisting on local_locks() for most of the work, and some rare remote
> > operations are scheduled on target cpu. This keeps cache bouncing low since
> > cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> > kernels, even though the very few remote operations will be expensive due
> > to scheduling overhead.
> > 
> > On the other hand, for RT workloads this can represent a problem:
> > scheduling work on remote cpu that are executing low latency tasks
> > is undesired and can introduce unexpected deadline misses.
> > 
> > It's interesting, though, that local_lock()s in RT kernels become
> > spinlock(). We can make use of those to avoid scheduling work on a remote
> > cpu by directly updating another cpu's per_cpu structure, while holding
> > it's spinlock().
> > 
> > In order to do that, it's necessary to introduce a new set of functions to
> > make it possible to get another cpu's per-cpu "local" lock (pw_{un,}lock*)
> > and also do the corresponding queueing (pw_queue_on()) and flushing
> > (pw_flush()) helpers to run the remote work.
> > 
> > Users of non-RT kernels but with low latency requirements can select
> > similar functionality by using the CONFIG_PWLOCKS compile time option.
> > 
> > On CONFIG_PWLOCKS disabled kernels, no changes are expected, as every
> > one of the introduced helpers work the exactly same as the current
> > implementation:
> > pw_{un,}lock*()		->  local_{un,}lock*() (ignores cpu parameter)
> > pw_queue_on()  		->  queue_work_on()
> > pw_flush()		->  flush_work()
> > 
> > For PWLOCKS enabled kernels, though, pw_{un,}lock*() will use the extra
> > cpu parameter to select the correct per-cpu structure to work on,
> > and acquire the spinlock for that cpu.
> > 
> > pw_queue_on() will just call the requested function in the current
> > cpu, which will operate in another cpu's per-cpu object. Since the
> > local_locks() become spinlock()s in PWLOCKS enabled kernels, we are
> > safe doing that.
> > 
> > pw_flush() then becomes a no-op since no work is actually scheduled on a
> > remote cpu.
> > 
> > Some minimal code rework is needed in order to make this mechanism work:
> > The calls for local_{un,}lock*() on the functions that are currently
> > scheduled on remote cpus need to be replaced by either pw_{un,}lock_*(),
> > PWLOCKS enabled kernels they can reference a different cpu. It's also
> > necessary to use a pw_struct instead of a work_struct, but it just
> > contains a work struct and, in CONFIG_PWLOCKS, the target cpu.
> > 
> > This should have almost no impact on non-CONFIG_PWLOCKS kernels: few
> > this_cpu_ptr() will become per_cpu_ptr(,smp_processor_id()) on non-hotpath
> > functions.
> > 
> > On CONFIG_PWLOCKS kernels, this should avoid deadlines misses by
> > removing scheduling noise.
> > 
> > Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> I like it! Just a few observations:
>

Hi Frederic, thanks for reviewing!
 
> > +#ifndef CONFIG_PWLOCKS
> > +
> > +typedef local_lock_t pw_lock_t;
> > +typedef local_trylock_t pw_trylock_t;
> > +
> > +struct pw_struct {
> > +	struct work_struct work;
> > +};
> > +
> > +#define pw_lock_init(lock)				\
> > +	local_lock_init(lock)
> > +
> > +#define pw_trylock_init(lock)				\
> > +	local_trylock_init(lock)
> > +
> > +#define pw_lock(lock, cpu)				\
> > +	local_lock(lock)
> 
> For debugging purpose, it would be nice to ensure that in those off-case,
> cpu is indeed the local one. Basically all the non-local functions, those that
> take a cpu, should verify:
> 
> lockdep_assert(cpu == smp_processor_id())

I see the point, should not be an issue, as non-local functions are not
hotpath.

> 
> > +
> > +#define pw_lock_local(lock)				\
> > +	local_lock(lock)
> > +
> > +#define pw_lock_irqsave(lock, flags, cpu)		\
> > +	local_lock_irqsave(lock, flags)
> > +
> > +#define pw_lock_local_irqsave(lock, flags)		\
> > +	local_lock_irqsave(lock, flags)
> > +
> > +#define pw_trylock(lock, cpu)				\
> > +	local_trylock(lock)
> > +
> > +#define pw_trylock_local(lock)				\
> > +	local_trylock(lock)
> > +
> > +#define pw_trylock_irqsave(lock, flags, cpu)		\
> > +	local_trylock_irqsave(lock, flags)
> > +
> > +#define pw_unlock(lock, cpu)				\
> > +	local_unlock(lock)
> > +
> > +#define pw_unlock_local(lock)				\
> > +	local_unlock(lock)
> > +
> > +#define pw_unlock_irqrestore(lock, flags, cpu)		\
> > +	local_unlock_irqrestore(lock, flags)
> > +
> > +#define pw_unlock_local_irqrestore(lock, flags)		\
> > +	local_unlock_irqrestore(lock, flags)
> > +
> > +#define pw_lockdep_assert_held(lock)			\
> > +	lockdep_assert_held(lock)
> > +
> > +#define pw_queue_on(c, wq, pw)				\
> > +	queue_work_on(c, wq, &(pw)->work)
> > +
> > +#define pw_flush(pw)					\
> > +	flush_work(&(pw)->work)
> > +
> > +#define pw_get_cpu(pw)	smp_processor_id()
> > +
> > +#define pw_is_cpu_remote(cpu)		(false)
> > +
> > +#define INIT_PW(pw, func, c)				\
> > +	INIT_WORK(&(pw)->work, (func))
> > +
> > +#else /* CONFIG_PWLOCKS */
> > +
> > +DECLARE_STATIC_KEY_MAYBE(CONFIG_PWLOCKS_DEFAULT, pw_sl);
> > +
> > +typedef union {
> > +	spinlock_t sl;
> > +	local_lock_t ll;
> > +} pw_lock_t;
> > +
> > +typedef union {
> > +	spinlock_t sl;
> > +	local_trylock_t ll;
> > +} pw_trylock_t;
> > +
> > +struct pw_struct {
> > +	struct work_struct work;
> > +	int cpu;
> > +};
> > +
> > +#ifdef CONFIG_PREEMPT_RT
> > +#define preempt_or_migrate_disable migrate_disable
> > +#define preempt_or_migrate_enable migrate_enable
> > +#else
> > +#define preempt_or_migrate_disable preempt_disable
> > +#define preempt_or_migrate_enable preempt_enable
> 
> This can be no-op in !CONFIG_PREEMPT_RT because non-rt spinlocks
> disable preemption already.
> 

I remember this was useful because we were getting the per-cpu variable 
before we preempt_disable in the lock code, and that could be bad if we get 
preempted after getting the per-cpu variable, and migrated to another core.

This is supposed to cost very little, because it's planned to match 
whatever is inside the lock, which would just be incrementing a nesting 
counter.

> > +#endif
> > +
> > +#define pw_lock_init(lock)							\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_lock_init(lock.sl);					\
> > +	else									\
> > +		local_lock_init(lock.ll);					\
> > +} while (0)
> 
> It looks like all these macros could be inline functions.
> 

I think the one with irqsave does not :(
So I ended up staying with defines all around.

Do you suggest replacing all except the irqsave ones with inline functions?
(I tried that, and the macro version looked easier to read. I have no issue 
reusing the inline version again) 

> > +
> > +#define pw_trylock_init(lock)							\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_lock_init(lock.sl);					\
> > +	else									\
> > +		local_trylock_init(lock.ll);					\
> > +} while (0)
> > +
> > +#define pw_lock(lock, cpu)
> > \
> 
> And those could have the same local CPU debug check.
> 

Sure

> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_lock(per_cpu_ptr(lock.sl, cpu));				\
> > +	else									\
> > +		local_lock(lock.ll);						\
> > +} while (0)
> > +
> > +#define pw_lock_local(lock)							\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> > +		preempt_or_migrate_disable();					\
> > +		spin_lock(this_cpu_ptr(lock.sl));				\
> > +	} else {								\
> > +		local_lock(lock.ll);						\
> > +	}									\
> > +} while (0)
> > +
> > +#define pw_lock_irqsave(lock, flags, cpu)					\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_lock_irqsave(per_cpu_ptr(lock.sl, cpu), flags);	\
> > +	else									\
> > +		local_lock_irqsave(lock.ll, flags);				\
> > +} while (0)
> > +
> > +#define pw_lock_local_irqsave(lock, flags)					\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> > +		preempt_or_migrate_disable();					\
> > +		spin_lock_irqsave(this_cpu_ptr(lock.sl), flags);		\
> > +	} else {								\
> > +		local_lock_irqsave(lock.ll, flags);				\
> > +	}									\
> > +} while (0)
> > +
> > +#define pw_trylock(lock, cpu)							\
> > +({										\
> > +	int t;									\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		t = spin_trylock(per_cpu_ptr(lock.sl, cpu));			\
> > +	else									\
> > +		t = local_trylock(lock.ll);					\
> > +	t;									\
> > +})
> > +
> > +#define pw_trylock_local(lock)							\
> > +({										\
> > +	int t;									\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> > +		preempt_or_migrate_disable();					\
> > +		t = spin_trylock(this_cpu_ptr(lock.sl));			\
> > +		if (!t)								\
> > +			preempt_or_migrate_enable();
> > \
> 
> This is duplicating the RT logic in local_lock_internal.h and it would be
> tempting to propose spin_local_lock_t that both pw and RT local_lock could rely
> upon. But I'm afraid that would create a less readable result:
> 
> - we would need to check the CONFIG_PREEMPT_RT there before doing the
>   migrate_disable/enable
> 
> - RT local lock don't take the lock on IRQ/NMI, which is fine as pw is not
>   expected to be used on the non-threaded parts of IRQs not NMIs. Still that's
>   one more conditional to add there.
> 
> - we'll need to differenciate local/remote operations.
> 
> Well let's stick to what you did for now (Peter might have a different opinion though).
> 

I get your point. I will take a look on that.

> > +	} else {								\
> > +		t = local_trylock(lock.ll);					\
> > +	}									\
> > +	t;									\
> > +})
> > +
> > +#define pw_trylock_irqsave(lock, flags, cpu)					\
> > +({										\
> > +	int t;									\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		t = spin_trylock_irqsave(per_cpu_ptr(lock.sl, cpu), flags);	\
> > +	else									\
> > +		t = local_trylock_irqsave(lock.ll, flags);			\
> > +	t;									\
> > +})
> > +
> > +#define pw_unlock(lock, cpu)							\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_unlock(per_cpu_ptr(lock.sl, cpu));			\
> > +	else									\
> > +		local_unlock(lock.ll);					\
> > +} while (0)
> > +
> > +#define pw_unlock_local(lock)							\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> > +		spin_unlock(this_cpu_ptr(lock.sl));				\
> > +		preempt_or_migrate_enable();					\
> > +	} else {								\
> > +		local_unlock(lock.ll);						\
> > +	}									\
> > +} while (0)
> > +
> > +#define pw_unlock_irqrestore(lock, flags, cpu)					\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_unlock_irqrestore(per_cpu_ptr(lock.sl, cpu), flags);	\
> > +	else									\
> > +		local_unlock_irqrestore(lock.ll, flags);			\
> > +} while (0)
> > +
> > +#define pw_unlock_local_irqrestore(lock, flags)					\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> > +		spin_unlock_irqrestore(this_cpu_ptr(lock.sl), flags);	\
> > +		preempt_or_migrate_enable();					\
> > +	} else {								\
> > +		local_unlock_irqrestore(lock.ll, flags);			\
> > +	}									\
> > +} while (0)
> > +
> > +#define pw_lockdep_assert_held(lock)						\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		lockdep_assert_held(this_cpu_ptr(lock.sl));			\
> > +	else									\
> > +		lockdep_assert_held(this_cpu_ptr(lock.ll));			\
> > +} while (0)
> > +
> > +#define pw_queue_on(c, wq, pw)							\
> > +do {										\
> > +	int __c = c;								\
> > +	struct pw_struct *__pw = (pw);						\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> > +		WARN_ON((__c) != __pw->cpu);					\
> > +		__pw->work.func(&__pw->work);					\
> > +	} else {								\
> > +		queue_work_on(__c, wq, &(__pw)->work);				\
> > +	}									\
> > +} while (0)
> > +
> > +/*
> > + * Does nothing if PWLOCKS is set to use spinlock, as the task is already done at the
> > + * time pw_queue_on() returns.
> > + */
> > +#define pw_flush(pw)								\
> > +do {										\
> > +	struct pw_struct *__pw = (pw);						\
> > +	if (!static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		flush_work(&__pw->work);					\
> > +} while (0)
> > +
> > +#define pw_get_cpu(w)			container_of((w), struct pw_struct, work)->cpu
> > +
> > +#define pw_is_cpu_remote(cpu)		((cpu) != smp_processor_id())
> > +
> > +#define INIT_PW(pw, func, c)							\
> > +do {										\
> > +	struct pw_struct *__pw = (pw);						\
> > +	INIT_WORK(&__pw->work, (func));						\
> > +	__pw->cpu = (c);							\
> > +} while (0)
> > +
> > +#endif /* CONFIG_PWLOCKS */
> > +#endif /* LINUX_PWLOCKS_H */
> > diff --git a/kernel/pwlocks.c b/kernel/pwlocks.c
> > new file mode 100644
> > index 000000000000..1ebf5cb979b9
> > --- /dev/null
> > +++ b/kernel/pwlocks.c
> > @@ -0,0 +1,47 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include "linux/export.h"
> > +#include <linux/sched.h>
> > +#include <linux/pwlocks.h>
> > +#include <linux/string.h>
> > +#include <linux/sched/isolation.h>
> > +
> > +DEFINE_STATIC_KEY_MAYBE(CONFIG_PWLOCKS_DEFAULT, pw_sl);
> > +EXPORT_SYMBOL(pw_sl);
> > +
> > +static bool pwlocks_param_specified;
> > +
> > +static int __init pwlocks_setup(char *str)
> > +{
> > +	int opt;
> > +
> > +	if (!get_option(&str, &opt)) {
> > +		pr_warn("PWLOCKS: invalid pwlocks parameter: %s, ignoring.\n", str);
> > +		return 0;
> > +	}
> > +
> > +	if (opt)
> > +		static_branch_enable(&pw_sl);
> > +	else
> > +		static_branch_disable(&pw_sl);
> > +
> > +	pwlocks_param_specified = true;
> > +
> > +	return 1;
> > +}
> > +__setup("pwlocks=", pwlocks_setup);
> > +
> > +/*
> > + * Enable PWLOCKS if CPUs want to avoid kernel noise.
> > + */
> > +static int __init pwlocks_init(void)
> > +{
> > +	if (pwlocks_param_specified)
> > +		return 0;
> > +
> > +	if (housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
> > +		static_branch_enable(&pw_sl);
> > +
> > +	return 0;
> > +}
> > +
> > +late_initcall(pwlocks_init);
> 
> That should be a pre-SMP initcall. Otherwise you risk some asymetric calls.
> 

Noted.
Will take a deeper look on that part for next version

Thanks!
Leo

