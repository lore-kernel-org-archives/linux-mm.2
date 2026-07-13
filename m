Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F14CFC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 21:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983756B008A; Mon, 13 Jul 2026 17:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933806B008C; Mon, 13 Jul 2026 17:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB886B0092; Mon, 13 Jul 2026 17:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 480FA6B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:41:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6D5580162
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:41:07 +0000 (UTC)
X-FDA: 84985074174.01.2724CB3
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id F0667120005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:41:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kkcvohAd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783978865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBTvf+Z85P+YG7179a/IzMuusmQi/QF8ZEk+OKIxHQ8=;
	b=ML+uk414S8l6Gycs03I9SH7Ryq2d3ULNUEUV7keyvkg/htkwCwKMmSEORKw5JzTxkRxojw
	ecF1++UtjynXuTb4ygy3+kev2zANeJ2aW4FpyK5QGtuB5aJWS5EGf1nAHwuwKMTl7CbnRu
	8uMPAuFRQFvsMH6C/wwjl6s7i6a9pzU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kkcvohAd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783978865;
	b=qmfWfB4cMdb0lqz/gAD30GS2K+o8LvTq9yc6umLkotPa9dYN6xL+SqUZ/afAUcDMzYGISm
	eXdXnZA2ZyozPSR+dw+9cZwi1CAKsVwKOvxXbOVYPHQLk4h3yiGczUxBq/gAuqskenHEB1
	tUTwy7W9FlwLhVrCnG4KpO8N/1LDb+U=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493ce08a75bso14340745e9.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783978864; x=1784583664; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kBTvf+Z85P+YG7179a/IzMuusmQi/QF8ZEk+OKIxHQ8=;
        b=kkcvohAd+QNB1gAM6tjqOto6b35ayMrH+1rwN3GFSEoWwcC++yUf8cL1I2iFl0wTpz
         Lwc7XQqQVMLGsJsq6/WCxrJ4rQoab3MwZf0oN3ZtAtHf8s8QMq8/IpEPWUE4gejkLYDO
         8tkssuwEobjDCDWR9Z7MBrIfP+yNdih7wqF/qsF129c5TyRNi6/cdOLUiRTgJ2sSX6sJ
         Ajubwp13CyRydONp3Ac86NQ/4qwqChbYSqbzc2noxEz2EwCFnHjshlc5rzqupT32YL1P
         qhK2RbNteCY0gvPqkz2lmXdrMcYIh/Lz/qlDQZKGWxo5WScxIeQGBO9J0JQezkndrt5e
         SI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783978864; x=1784583664;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kBTvf+Z85P+YG7179a/IzMuusmQi/QF8ZEk+OKIxHQ8=;
        b=ZPgym2lWB5XB60XyRElzUrEvxs9TMf3FOJoQXsP9Ohy0is8udPjpKuYioDg0vgNi1c
         0vZ/OF+FdLwoQnoTBFLVLbGjBGZzQu407a9VbEP4OG359t/AQJfbNJJUHlzfIsE+UcDM
         r4Ez4rbI4fwURJMK3wMDN7uuH42Ak/XTr2vYY6H/d+3mRLDXyJFGx0+NylMgy9GOIYEO
         xU+sOQHbDzGw8HjQg5HeNNirP41c5u7rwT85rP1kSYp5APPxn62Cki9LupmVqv9hRxYt
         R81yWI45YP/B+89VEk7Nacog+5Pf6O14vFECxlChtISX7yeF96WpNip8q+xHMU1O9ph4
         hqcw==
X-Forwarded-Encrypted: i=1; AHgh+RqtUz3c5FmwJghkeqWpPWfgc4fj9OVFjVvghA3PIURFTiMFYDni0FNa1hyaN+dih9L0f9jjkzCY8w==@kvack.org
X-Gm-Message-State: AOJu0YyJg14+AA0nCMvTYMzMJY1ahkDUs89cQ2ZGRCT7Qxmh0is8Zh9f
	K2/9xaIaV4shd1hKSj72yAmKcz/5hS3Zn6YW/WZKX4f8h1WXa8enjUwu
X-Gm-Gg: AfdE7ckSbv0Vm0gI71BFQh8PVKokpOUoTpsv8MHQX+5GGDwVuPwIu4EYe1mL+Xku7y+
	sRPV48PFU/At1Og4Usq3AUebu5gH9W8nvzIox4bmi7GkIRilo2T3slhWWW2K9WKAaonB6C2gU4M
	hZMc307+NXwzZND18Fo/Y6yGHHb25tCRdB3y9th8xMaiQGV0WmzW8yuE68iQdC9c4m99VRK/G4D
	o73V7Ap52UKpZDpoqPwmXNJV9Eir391NsRbVe70Wn0UUSYUtlk7JBJW7wk4+zdOwN4rNleZNDxW
	DXc58xLpK7D1cOE0+wlhD49xy4x/UivVmlag5ADgojGcYs41/ot8bJkY6d1XKZUafVX5ApjF+e+
	9tKYevW/maA/epTJXQmlRh2Zfkg2R0d62zJpINj7+MH7OuGnsixgfK+/ubvZDK/0fdBDVxcjK9N
	vTLlUxbxjkOWnj7KxWGFp7Xg==
X-Received: by 2002:a05:600c:1908:b0:492:3e66:6c84 with SMTP id 5b1f17b1804b1-4951830e089mr11315545e9.30.1783978864353;
        Mon, 13 Jul 2026 14:41:04 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495087384casm23602415e9.8.2026.07.13.14.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 14:41:03 -0700 (PDT)
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
Date: Mon, 13 Jul 2026 18:40:57 -0300
Message-ID: <alVbaf-UVMNaEtvk@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260713073634.3Hrxpfcx@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com> <20260519012754.240804-5-leobras.c@gmail.com> <20260520145308.nay9zt6r@linutronix.de> <alQWr2L_Kn23pxd9@WindFlash> <20260713073634.3Hrxpfcx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F0667120005
X-Stat-Signature: ypwepqsxdn341b6wsgxtto3gmpuqetr7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783978865-278159
X-HE-Meta: U2FsdGVkX1+tvRSQuBzzxZSfP403NbgoxNEa0VE3Jl/RCSIlQeIhYzNxm8vi9phJkjKa1YoEkh31ysz5ZIVTofF++Loer2OBL6jo5uV/+ak787P5YOO19KlZXaWmWw5esVRTj7k6bCxgijGPQOScdJIiCGSIyh/CSFhR0xqaQsgDUY8BdYW4BXwITSI9h1DF7h1Guu1iaVJroS5X4me8c/pTybDt73O8yPAFlmsurqBknD0WzgWICZG19W+Mlz8+S372jHWafja3c9X34FTS0X6IRaIHEfojS12gxF2WgEr13zCOA96r1fjYyI9B3eWThiGSDAanq+tNuoTi+MXZWAKsulL/obG4c1+rUiKXhHEqyswj4786uoeKUCwZgnOxcweIDluKtKHC6JvTyKMwCxG4Ctn2c4P4GuSkhoPCJ0csYRVuNe3tnyWe2q5wlLGyTEYAtbgxCse/5q+sOfBTOBT2URQngGxwqtdeyqp5E4G72ypkCoyIZ/PLfmHkvjqximdYXcyL7RThGev9VRNskvUajBkqLOdQNr0srjgyOEn048apG2YhULFGGYhkxAUyjDghNgDeDtrShC9PMtI0wqtnKhrxTamIIfHYfOfqp98azcpT7vPIQfoJdm1xCBgbhawbdEhc7QZUQ1/73BM35vHiMyaXdF5ObtAKNEULD3QG8k9ooM6AmXC9AYEpoxmH7Icv0xs2R2xbpGXenrel2L9wI7QnynDWcQW8zXEb0ykg57mCV8UrJc5/1f7CZQi4bvEYRcEoPiIwMiAPzqC29m3tQ6iXPr9fIhGTmGPGf6bOEqkkGLEuO1ZSltty5MIRPznAARTK1DsCBHCFvq91Zw6giKZQUKinIqs7Qv+bONAyT8AvBwe2854cwBecjpdA+h/q0viKYpw9Lae5bOghqr5YJRtxPXambuXx2c7mpcd1BD4KcMAk+pWI6gvT8zqn+oipwUo0Uj7bthZxGMg
 mShXLLYd
 GFSSIgRzUb3rB1YkhdI8ErfazshObr22MiwadV4EZSV5FMtorYJYKEXIKdAbPc2e2MTvo0b4vUSI45YnvBENIWJONvno9KProwbY3HyrqzK4Lg1OzRb6uOc805c0qzjPpw7ZvWIL3bgMlnHwsYlNRsXZHpCATy7BRfOVYLVfKa0KUTc2nyCjnOn3z3InrYAlpXBaGpQ9+u5Fewkczug5ugyZea18wvxbRaGR5GT5tcxJ1igCVXOVe7BjIep8mZMrkiJG2LnSJq4e3CNyZnPwOJnHalKcUWZqpwC4zi6yUh5BN0exv/tmfVyggvPnUgYBoPKAVyWlcZo3wSHmALfbYeAqpZS120fLuDcmCix5dtQmMxIoRquqyFu3UAegB7QucgULedtgnM9ZEQ4AIckl+1c8RrteEgJSCLNAjHJCfRb3WfsBI7D5vHkxRudemjfw0xzpXcr0+zFByZ1A0mFGaip2DaSk7P4BoAtTK3XdnKxNzdwneR0ebskdgeTp7ICk0NSGz+aaxpi0Soe/GCjDatug/4POdDR1VeC9EZZ2HV9vVey19jK0aH4elQFm0M17WJMNTFFQILPsnAWccko5p5npHa3pCEpruC5iA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 09:36:34AM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-07-12 19:35:28 [-0300], Leonardo Bras wrote:
> > On Wed, May 20, 2026 at 04:53:08PM +0200, Sebastian Andrzej Siewior wrote:
> > > On 2026-05-18 22:27:50 [-0300], Leonardo Bras wrote:
> > > > @@ -4733,121 +4735,121 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
> > > >  
> > > >  	/*
> > > >  	 * We assume the percpu sheaves contain only local objects although it's
> > > >  	 * not completely guaranteed, so we verify later.
> > > >  	 */
> > > >  	if (unlikely(node_requested && node != numa_mem_id())) {
> > > >  		stat(s, ALLOC_NODE_MISMATCH);
> > > >  		return NULL;
> > > >  	}
> > > >  
> > > > -	if (!local_trylock(&s->cpu_sheaves->lock))
> > > > +	if (!pw_trylock_local(&s->cpu_sheaves->lock))
> > > >  		return NULL;
> > > 
> > > alloc_from_pcs() can be called from kmalloc_nolock()/ NMI context.
> > > I don't remember why exactly local_trylock_t was introduced here instead
> > > of a per-CPU spinlock_t. 
> > 
> > Probably to save the cost of using atomic operations on locking, and having 
> > about the same restrictions that would allow using local_locks
> > 
> > > But there should be nothing wrong with a
> > > trylock on it from NMI as you do here.
> > 
> > Awesome!
> 
> The problem is always the unlock which requires full locking and is
> usually the problem from NMI.
>

You mean, like, the trylock succeeds in the NMI handle, does the per-cpu 
operations, and then unlock()s? 

Or by full locking you mean local_lock() instead of local_trylock() ?
 
> > > 
> > > One thing worth noting, on !PREEMPT_RT, spin_trylock() always succeeds
> > > on UP. kmalloc_nolock() checks for it, not sure about other callers.
> > 
> > 
> > Sorry, I did not sure I understand that part. 
> > You mean we have since it always returns true, we may be in NMI context, 
> > after it was interrupted holding this lock, and it will return true which 
> > will use the protected area even though the lock should avoid it?
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
> 

Right, I got that part, I was wondering the scenarios in which would that 
be an issue.

Thanks!
Leo

