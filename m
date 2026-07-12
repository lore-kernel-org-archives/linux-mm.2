Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D04B0C44501
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 22:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891AC6B0005; Sun, 12 Jul 2026 18:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B946B0088; Sun, 12 Jul 2026 18:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC2C6B008A; Sun, 12 Jul 2026 18:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 322696B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 18:35:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CBAC120A12
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 22:35:38 +0000 (UTC)
X-FDA: 84981582756.09.4111182
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id B06C6140008
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 22:35:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G27Q9coK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783895736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VdrKql7RKB+YZLcnGXRPhjkopfqYReRcnCWxRaESO50=;
	b=ikgvKFbhb7Rbr1QdWo554lpOk6Ale/C0XDsMk0dLcle/I50aj+JHatM1zchCjXYZCAv5Ap
	0zbVSMmHMtQ/3rlYSjyoVCv8s/wRmNfVT08xSUTPBNiFF8HvfpH66GOeTt4zYuTJagbgQO
	5wrz17ZEZ960h7TTMBMTPeWQSfW+L2Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G27Q9coK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783895736;
	b=ubvZj0AKmreryqlMlJejFcwPKKvNB3DAk/b5C43E6cpezFvZqsaEYGSMVXzquhXc/9AhPT
	UW3sns96Jd8Dh+9Jj0ginzDrli8ax5rmqNsqMdZMFWc/wx+Csnl3L6SLOXTI42dEbh7SGT
	MUoy9fkflz+IevHh752GDhw7KIs6fWA=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493bc8fda98so15084245e9.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783895735; x=1784500535; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VdrKql7RKB+YZLcnGXRPhjkopfqYReRcnCWxRaESO50=;
        b=G27Q9coKx2AX7ZUuUJuHiP3ioJTlQP1WeCJsiXWREA/FV+kbyAoaZDQalmICqvgG5j
         Hz2Adxw5M+UerTp3cwTZav1wdh0w4fTdn75OKDXe5vjA+IvO38lPJYgELYtNPOZqlfnj
         2I4SjMlJCoI38FKPBufh3VqyKPIe1ptLfHnFTTRB0awCwT35pa50djSqHgHnD1qVvJku
         4pbwnfcPRAxPaCGnuivUBoZxQoXamUZ6SJ7tMcJSZU7kFclEuhIYjBjTmHQFe+1OQqF5
         qo6TFv6WgdJgySnHfVcu8RGWflB6yhnlDhlS1zYkUdkLKkC5ZhFqMWMBJLVGylej9GTc
         Li7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783895735; x=1784500535;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VdrKql7RKB+YZLcnGXRPhjkopfqYReRcnCWxRaESO50=;
        b=erVZqzcrealGulpW8w1g5f+zgVMaEp8GqLJRKSQoG03iF3tQZ8yPfKEbbUUnwxkmdW
         89BChPEmnOfvvC+SCfxWADCAIJoxhgB8x1lYd7VyuP8BBqCtSxwL7RDqCltovffVoIy7
         9ZaINEnOlf1VJqM9MMlIPdfHWljaCM6vyuE4Lcx7EvjwrTARTUNK+0DGJqBMiRJoqquq
         rEvgLtlgm7w6xOxmFnaWYuv44fXt2HXpKVbZWrRYF2RjFY85/+6C9h6P0j9a1v5151oO
         q8WSrLXR9V7MMnYCwHs+vfArl7AAERwmX5mLd3jkkcy0WnY5ULrEFKuFT36VNLpJu0u3
         QZ2w==
X-Forwarded-Encrypted: i=1; AHgh+RpIHVf5Checm5Nbl0AeDU2cqfOs/x6TwcBp0ou4bsgwBnjBc2WssN1AJHFCSpxSSel6IlKQjUgK2g==@kvack.org
X-Gm-Message-State: AOJu0Yw0sU4hb6A94ROUzHWAGjvZQze1Wrc16GKc+mxK/G9GIusEQSPl
	j/TjbinjG4wJcZTbM/bhp+FJIYRyXKxlWgNAW/w+pXhzBHwjVgEY3bSn
X-Gm-Gg: AfdE7clEIo9kSu3qPrfPs3HVcI1LWlo4p7z38WQ7YFLyy7VUbNVin+MnCROkt0AncoN
	LTl6qtrwNDEQ/D2bvSj86iH81K2Wnwm3aTHzgYTnEbzkWsDjvBskRcb91/FTKKCgMEEEYZOh+XU
	nWFAyW0xhNRF3NyabnbYi3oPDLTFPlZJF/oL74nMXkIoSeCwXFTmbkX1LRqo7tJnBvYO5+2o6PF
	9ss0yZbfF+BD15LAtjJFIHfHj3I8vwGkoNUua8+38d3GvGOHFzpoOzpd5vSIHepl/22eqbqweY6
	nsmxMxlPS39wJ2OZ8dT0AuGGoCA8Aty+A4EAU/y0gFTYQPbk54zy654z8luJG8mSBzY5VOvEJEz
	7a6rCpKdNbTzUuDU+qz1Z8gM0jK3Xk06QqgwoFXbeOBhwsGv9CPvW2O7hfJkwszJlrSBlrKx/xW
	bTSiS+2UKHYBAlMipWH62v2g==
X-Received: by 2002:a05:600c:6989:b0:493:bfbf:1da4 with SMTP id 5b1f17b1804b1-493f881de65mr64503975e9.22.1783895735000;
        Sun, 12 Jul 2026 15:35:35 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6df6d9sm373068445e9.7.2026.07.12.15.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 15:35:34 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 4/4] slub: apply new pw_queue_on() interface
Date: Sun, 12 Jul 2026 19:35:28 -0300
Message-ID: <alQWr2L_Kn23pxd9@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260520145308.nay9zt6r@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com> <20260519012754.240804-5-leobras.c@gmail.com> <20260520145308.nay9zt6r@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B06C6140008
X-Stat-Signature: ciqddx4y6heew9rz31dn3wpfwqif66my
X-Rspam-User: 
X-HE-Tag: 1783895736-766821
X-HE-Meta: U2FsdGVkX18zzrrz1ZX8hgkYOknz0H/wfA/KnHTILmlu5TBf6h37Ale8F7dwlwd6FPTYsiwe+rIXzB599Z22bY8fdxQt6MuGmTytmrEkk9a4r5TtGkJHcmgTR8uLYha8mbeoLUlFeJaMCiTt6Hf6QjK59CuIKjwTapzbpjMIoGdqu0VadFvnZIyPRIYroIhOunUn/cizc3qIeb4eVqiXgyvrV6ZPsFC6Sf8tc0xAmIdai+/kuDa0/7KxU4ZY+vur2XtKLz3h7fMdlQhtWj4v6nML0PTwQMAWJUSndYm2/+ta5U+UY2lJGhvEm8oVxwAMQfh78PuCato0AqehR03SkA3UYp4KRVdzpJn7Ywbmea0i0qBiZU6/PH9lr9hoJKA0jbuMNoFAlxsrF5EJgHDxeYPAkjXKRSKa30uREeWZJMUxecKrRHsEEevGE0ej1pGmkRlR0TEVEDauq5OJs5Gy69t0St1WK4XurOjAQj0W0w++UAPjwTvzE5dpXfTbTzhu4qJJ7inXNFS5a3E9eypIuRiTLRRkwDHnd5+khVisovlXcTGUu//oTPoeAFmMzwL1WR9DcgL6lkQSICArrWOA/iRJ4a/UlGD3Hj2YnQt4osTLtS+oKNqK09QoFkJd2jU5Y/ucGRO7OaI886n0g8kYTyylYJKEqVxiqu58eNWAWlzlYv5vILznaKlp8BX/2tnExeRWIA+TNBUfRA0ZxErTk67L+aWONX0I8SrPnGD9zgliALfJA120h2WmtQ+1I8C5JC5Ki3AOWoJ1IlQKLJQzwoMPZX46pqTQ8qWzWvpyQFiydfkNEw47wn9J/A/MzDQ8GQOUt3f7tS8UGFjKnm2bwu5+bAaPPaDO5Gg4zHqrwhJa0yohk2SPB+DJ5Yu56vG0YFIK4Et6dL9ad90At5Noivi4Bm7P+i8rn5NnBV5HxjM6Rra4yKWNc1stED5GfXPpoQz7yaWoWGIniJsELQk
 vq0806sR
 uRv/VhVlipMSOMJ3Oh8VatyFrnxQ4I3ULu+2BSRdfoX4pAKGnLQop95uxgQP2T5/KU8H7XKZWnKhn7mEgjFfU/JBy/SPP3H2NvDWr/g3APC3JsHF8WSABjRIgKtzetzaNoaJPZyJXNVfMiIQVsJ8eWZs5vQC4IvAhJwUE/X1q2Qmdclr0Kgf1QQgjlHqxN0Z22uk/u3kxF54BcTYAlY0Mg9uvw32Bh4sytTlvZ22AjBv5qokD+Kv2UUe5gbx+/THOBv+bX0JN0x7mA7x8W0ctnk+1fRz+7J+G7a1Pl7s3ZL5e7iSSih677uBKjOD7RIMD7p/f08rgUSaVmDaG/hWON8OsrnEm2N1MUbRcRVGJEVGch4MJwsengU/Ya3oUaJhTtmtCv6R54ah/OEmpCMvtn87tmsUViEIu9XNma0VbFQcmHLG3WVEj44inTKJ1EpAqSwHuCflAlCEsZOxJIV4ZnvGBQVRFBBtkdzjK/KimwJrlEmARNB9WoZOLGX1wYwEBmLiRw+5gX23Xnl76kChuVDpuirAWWQe5YE2SIpDQ3/dFEtWYa66pSwTzEH1+J1IP9QB/ujXT9yOGzWQtJs7owuPInbU+jxEamnKL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 04:53:08PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-05-18 22:27:50 [-0300], Leonardo Bras wrote:
> > @@ -4733,121 +4735,121 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
> >  
> >  	/*
> >  	 * We assume the percpu sheaves contain only local objects although it's
> >  	 * not completely guaranteed, so we verify later.
> >  	 */
> >  	if (unlikely(node_requested && node != numa_mem_id())) {
> >  		stat(s, ALLOC_NODE_MISMATCH);
> >  		return NULL;
> >  	}
> >  
> > -	if (!local_trylock(&s->cpu_sheaves->lock))
> > +	if (!pw_trylock_local(&s->cpu_sheaves->lock))
> >  		return NULL;
> 
> alloc_from_pcs() can be called from kmalloc_nolock()/ NMI context.
> I don't remember why exactly local_trylock_t was introduced here instead
> of a per-CPU spinlock_t. 

Probably to save the cost of using atomic operations on locking, and having 
about the same restrictions that would allow using local_locks

> But there should be nothing wrong with a
> trylock on it from NMI as you do here.

Awesome!

> 
> One thing worth noting, on !PREEMPT_RT, spin_trylock() always succeeds
> on UP. kmalloc_nolock() checks for it, not sure about other callers.


Sorry, I did not sure I understand that part. 
You mean we have since it always returns true, we may be in NMI context, 
after it was interrupted holding this lock, and it will return true which 
will use the protected area even though the lock should avoid it?

Humm, but if that scenario exist, then is it actually ok to return true on 
trylock() in that scenario?

Thanks!
Leo

