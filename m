Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78931C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 21:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5A96B0005; Mon, 13 Jul 2026 17:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556916B0088; Mon, 13 Jul 2026 17:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41ED76B008A; Mon, 13 Jul 2026 17:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11BD56B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:17:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 824D4140198
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:17:32 +0000 (UTC)
X-FDA: 84985014744.25.AC4C840
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id A255516000D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:17:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ad0XYLOX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783977450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=npiX22YSguzWJpXGx2hHTXeW3ywrBRl4LUKqa1yh85s=;
	b=RxhLdRSSupi7rFsoIHGTHt+8QG/2rMKt7pAIYRRw0tnxfciRiAsmhMl7nyNcF2t9fvv3aW
	JAYH2QTzAapax8C91TES7yIy1IRJFeGGIfpZea99rwzyg1fDLwdfJNW6CLY8zcZMlbJi0J
	uPEW0VMt5ttFslX/XnE1I5dgAcj68Hk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ad0XYLOX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783977450;
	b=rL9BTv7GTCVuxyBoGf68gPMqFcRRWMKx0cWheRoc2AhfQQY/qFRZ6ROMsA1cKrbYluajk3
	MpvE+uHGAQio2n3pyS6hImIyrj5S4Z4FDm35hVgdpE/rbxTMJd0zkUJx6QcGZh8lXc7iRE
	EvmJLrZ5RyDxNxKOy3zHgoU1/9eC64o=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-698a9f11776so500657a12.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783977449; x=1784582249; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=npiX22YSguzWJpXGx2hHTXeW3ywrBRl4LUKqa1yh85s=;
        b=ad0XYLOX91ddENQULLb5qI+mgPjlBzWFTWwF4XEDwIIEaZX1AnNZzCgLp4gmz9bObr
         zPHxUn7xy7Whr0V+gbl8gFXtWRdXbqDyj4IElcKmA9bJUfPabWzDi+X22ZHpAkMk4XSa
         CWIpSWslvB9yFGr/h+Ns8+8auQv5Bud3XqzkcKycgPPbTusOiQLX3JwxhwS8e+NdKJgC
         dzY//2wbDAH/+5HByng7Tf7xeF4LWmLWJSrinLH3P6inEWaJz7T3j5Goh/+CUUhPceuB
         RAqTZRKVXCZABjWZDA5ypx6OJOuEcoSLcAU+DXjYImXyyf7rK6nxkcGfSNG++LSfVFdK
         j53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783977449; x=1784582249;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=npiX22YSguzWJpXGx2hHTXeW3ywrBRl4LUKqa1yh85s=;
        b=TZxZYs+YEiFVntovMJxcvOQKht6rf/E54giciJmpeLV0zw0+6QG5VIj5eoL3j37YGC
         FEf9ZYWleNC4L//qk3cjq32Po5OTT8jT6zf3h/39xQmcT+FyPhgEW7KC5o5uz/Ek49+l
         DPIAyIwKu7GQ+kGYLYdGe4qfAUt1fjD9BlTr9j2BmAJfthfW+HniNMQKL2fC0ujSyz6G
         cNw7NvxbhkJLCvG96R34NUbF/TeA8/g5AL7iGkRu3O0hljfZkTE2D7XV0biq3mxo2tku
         bi9zChHzct3TonfqLi4HjMtmtgGADaEF6I4yZgq9VGo9NQvladTOf+1R2zXxqnig/enq
         1REg==
X-Forwarded-Encrypted: i=1; AHgh+RqYDaNMd8CUNlgNHQbCtyreQ+ueafM0tY7HgEHj6frp8QLVpuxjSmH3ToK8sU/6uUVg5JsQT2l1zw==@kvack.org
X-Gm-Message-State: AOJu0Yy6MU/MsFmV/HrzWrE9Ofmg5O5319FytfNjwtQt9MI2eka1IbVf
	R9KcaSi1JZyQf5vf6oNeVtzpzQqG3OUWUk58wC/9MWCfRFNL5MrJd7Yj
X-Gm-Gg: AfdE7clYJlNclFa/VkAcBEr1TpHiKJUmSxz40i7ijjttclpRZgcYY/pzSJoIBI7JsIM
	hrvjgXdtfKEnnebMhlhi6JwtdqdI13/FDR2tcSU21JS9pDu8NASqxxV5NXwAkduLyS3LcJLt/F2
	DcqMI7C1LBrseLm1leUyt5A0eFmENl+tPNgbL+wa2quzJiJFC3w+j0UMdR3zjzDivc9fp0kKGBT
	ntFmJNq0UMs3kr2xqsOOqFWuwiWp5Ib0oEECo1sZyZ1YVCChX5a4OrVXCBOWw798DFnSm7mlYj8
	WY9S2cnegw5YtLp0QIB1Kpbi5Y2X8Rr5h2kZk6Y95f2pDDU6y9L1FQZCsYbN2eawwTkSO9s/T5k
	wIK8kmYR4uNASOCwp7xmid7s1a2kCsC6o/Ofx8KKUWwoI2E8rxF1chdaOjSPBEzxSaHCHhCgXhb
	YOJwLMgkyjXtwNOf/MnmcSRIgdUIJI3tno
X-Received: by 2002:a05:6402:3220:b0:698:ad7f:9383 with SMTP id 4fb4d7f45d1cf-69c5f0c3130mr4880740a12.14.1783977448821;
        Mon, 13 Jul 2026 14:17:28 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69cd2952836sm386903a12.27.2026.07.13.14.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 14:17:27 -0700 (PDT)
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
	Thomas Gleixner <tglx@kernel.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Coiby Xu <coxu@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v4 0/4] Introduce Per-CPU Work helpers (was QPW)
Date: Mon, 13 Jul 2026 18:17:23 -0300
Message-ID: <alVV44RO_SolaqMW@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260713080723.XOTiibfG@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com> <20260520130903.Ebsd4aUa@linutronix.de> <alP58SgTc2_8OFPc@WindFlash> <20260713080723.XOTiibfG@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A255516000D
X-Stat-Signature: is8o7f4aiqj1pp6rh7rj4pxtbncetibm
X-Rspam-User: 
X-HE-Tag: 1783977450-506947
X-HE-Meta: U2FsdGVkX19VTUCPWbkmZJNgrs5piDZtm3qTnjLpyNzdoQOJzXS2rDsv57eNNyaczfQtIxRENNr47br5IQo0yOoFiQndhizl1Pm3Dklx7yPDqveMBtUAy4bhfiltI3IWgonK8JbUPolazUYQ5oXGxFVEJyZNTCNfGt7mMLL/h7aJEg7GUSbXIK/DFfRUXFKtLTEun/ELVkdlzOLapUoRvYiUpim8YEY2T1mdag7lrofj2m5lS3NV28legYQiqrQQZ+CTd+sriERbMAhXlSIJ9wE4cpai2iBBtpQDc/Z5noudo3kKB6w9DJ4TQon+9t8I7YO0Wa9QVO6cEXcv57Wl+41KwJTC8RPXyRdNrAdRDhmDqIVzijhiK+6rGLpxMpaVzJ23Pv0PtCdXBKx+5U6HA/dqqoTwLpy1aCwwSIX44HH4MBq72PaBZF1S7Xj1jVsH69o9mNEfeCpgEmoYN69k874a8C+f+i9KosUhamtXg2hxar7S80N2xkYVSI1f4qiK7unFrzy4eouLdG1t2PswpXkTS9ea8KqcMcxt18u9LpjiNeLERjupZ+d2Z9565CjIhRr2NZpo3ti8B/+Xd++3X9jm2ct2M6JqDtWcKqsgMN1C2tbNCY4fDcOjessgiERUvK8sD4JIwLPXfHozUMzNdQvxHR251dP22YFIAL53v7EhK8rCURXt/tZfi5ixbgYRr0RvMz+cJAXGT9qsUpQIB5uRsiub8TLI8+1OqOLpZMxlQ9LhEKwBf7giLFmWk5fuP+WgIkAcRBR9+tdW1VIckOA9t/48AlV+z9MLpGeito9rq84SQdg2HYArL+IMMogltbUm7bEUVVIF5SunNW2KmC82Zr1PHUShmHc1xPkqgyw+USP0Zbg8oxrG08GS//BS2mKh58h6fxKPpBXLYZAv7v15WGTRG+ka1fANabigNvD73YvC+eDWX2DyYeV8wZ3QJPnkdr4NMBCCenD5WMC
 ff75h3a/
 xwZ3X4Y/lBcT0EPm1A4UGjzeLY+vKtloI+ubt7zmtY/z8NYGxr47AdACZOSi4zGjLMzTcNVuXPKQLho8QuUF5FRapFC7XHAFtuCXxQAtOeXB2mJIk3f2vP0rnQzgC8G3jKYpT8zrS7sIWPovBNtoS+CR+Wgi9EqKv13VcdUGuGIgzJiWZUq8jwWIx3xqh/gCysZpFaDdSHwJJSW6zsbS3syppLlGXITkBNCEDduaGUPT29Qbz/Hcelwnahx2hHOELPyrbzgvBk+ssdAP6mrP2GIXkDLwzMq5nHqDoUsgF2ay6OwWMx15rMVSwfWVjKmAjYK6MlBbr3051Z+wUFtuzgFcNkAnq48Lh8clWwLnZfHhnuHTWP/XsMLU4sg1Jp3pHO+EHwhQDvC1PU1pzz7vFOT0wXGM1zl8AMFItQmyrVFzMCxkQZ2HAf7xgtpuARGI14tHpFycJcg+qmZLpuy7CczsLtQmdIxiJqQOsVFkT7FHNCzHMfM2xlh+DsOUSOL1VP8xIHSMnqk5bJR4pce+KqqeRkNQc0N1PhBdm0H1zSIPAydsDXggGM9efCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 10:07:23AM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-07-12 17:32:49 [-0300], Leonardo Bras wrote:
> > > > The idea:
> > > > Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> > 
> > Hi Sebastian, thank you for reviewing!
> > (Sorry for the delay)
> > 
> > > It does not become a _spin_lock because it does not spin. It sleeps.
> > 
> > Right, it's a per-cpu mutex. 
> > My point is that it's a full lock, and we could use it instead of doing the 
> > whole scheduling thing, since we are already paying the 'atomic overhead' 
> > to get the lock here.
> 
> The whole lock is a spinlock_t. There is also raw_spinlock_t and
> bit_spin_lock(). All three are considered spinlocks.
> 
> > > > In this case, instead of scheduling work on a remote cpu, it should
> > > > be safe to grab that remote cpu's per-cpu spinlock and run the required
> > > > work locally. That major cost, which is un/locking in every local function,
> > > > already happens in PREEMPT_RT.
> > > 
> > > We did have this before but only in the RT tree. It was a bit messy from
> > > the naming because it started with local_ but then it was a remote CPU.
> > 
> > Had the same naming issue here. This idea was initially a expansion to 
> > local_lock() mechanism, about the same way you were planning in the past.
> > 
> > > The main issue was the different code path which led to a few deadlocks
> > > back then.
> > > By the time local_lock_t went upstream, the cross-CPU locking was
> > > removed. As far as I remember, the cross-CPU user which did schedule
> > > work on a remote CPU and annoyed NOHZ folks were replaced.
> > 
> > I understand this could be a big issue if used in a generic way.
> > 
> > What I am proposing here a mechanism that standardizes those 
> > local_lock()+IPI strategies based on how they are done today, so we are 
> > only explected to get 'remote-cpu' pwlocks in the 'IPI replacement' 
> > operations.
> > 
> > The idea is pwlock_local* in every local function, and pwlock*(,cpu) in 
> > operations that can be remote. 
> > 
> > Maybe being used in a more constrained way, it has less chance of being an 
> > issue. Also, the whole idea is to improve CPU isolation numbers by 
> > reducing IPIs, so maybe NOHZ people will be happier with that :)
> 
> I get that part. The local_lock_t part is cheap on !RT and becomes a
> full lock on RT. While the lock details change the overall expectation
> remain the same. With this change it is possible to acquire the lock
> cross-CPU but this depends on the config/ setup. This might not be easy
> in terms of testing and maintenance.
> The more potential users you have, the better it might become in terms
> of a selling argument. If you have just (say) two users it might be
> simpler to address just those.
> 

IIRC there are multiple users of this mechanism around the kernel. I 
remember picking the first three (swap, slub and memcontrol) as examples of 
how to use pwlocks (QPW at the time). With the concept proven, I could then 
proceed to work with other potential users to replace it. (We ended up 
dropping memcontrol in the process)

The main idea is to replace as many potential users as possible to reduce 
as much as possible the amount of IPIs in isolated cpus, and allow Linux 
to run workloads which require much lower latency.

This idea came as a general solution to a bunch of latency violations  
Marcelo and I were coming across.

Thanks!
Leo

