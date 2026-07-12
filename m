Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F1AC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 20:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532EB6B0005; Sun, 12 Jul 2026 16:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3CF6B0088; Sun, 12 Jul 2026 16:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ACDB6B008A; Sun, 12 Jul 2026 16:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14E6F6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 16:33:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DDB1408D4
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 20:33:01 +0000 (UTC)
X-FDA: 84981273762.07.619238A
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id A703BC0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 20:32:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fdhKqmGC;
	spf=pass (imf22.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783888379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hoFLr1vfVTbyBPCDDFLHELDOVM+etETDJUoaDXyGSaU=;
	b=mpFy67gO1ijBWy/Cjyyn/sDyhdiYbwrRqOIPSwqvmTeKHbPTRsVeH0W8Ia10uKOJHAsnXC
	bf3c/pLzV/D3WoicT32ZqITciBIJJn74FkQXbl1v4TuUFUk/06KGmeRLOQquA6USJpcpmv
	U8heujKfUqtOty6TNEqbmw3tIL9vH5c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fdhKqmGC;
	spf=pass (imf22.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783888379;
	b=HXSyKoVKhVJrbpYfReKW7GqXRXit08Aq+jNxHkSE6VUHd/13bqeHndhV958hp3c9CzovE8
	3Zy4YkmOlhADsje/bj9UPFDOFUlesRb2OLhqbRlig4R62wN2Jtz5bPTlo+L5VaZ1//uuhV
	w/9HhB61GYRmURpeIUwFJxQjhtAXhr4=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47ddf7b09aaso1568483f8f.3
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783888378; x=1784493178; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hoFLr1vfVTbyBPCDDFLHELDOVM+etETDJUoaDXyGSaU=;
        b=fdhKqmGCGfbPDxbvpU1fDvOcqmWt4wWfdxaDdS/y1kugwd+d1/5Q9DWhzBeA4XkjDi
         RHMqNQzXb9NqxNnKZrrFNc6RWfeWixgNdZ19NaeDM3PCHFn2jxgPIKAJA19UdwyTYidw
         oSxgAVG8EEcOs1UcqUbD24QG0bwUncWFIw19VWfTUz8f3h9QgZIge08mFzaBtc5P2cFd
         f9FXRcO/ArYJthU9Tm8RjbArXgZtE/J4rINt3DPiPHsBP4+wtptQ/daZ9BXiq5gUg3oT
         B1F+Teo9UVeHIDwtdiuspl9bmHPozG1Aptnv+3n1hZyR0L4CDro5mD5hJvsXwvxWJz38
         4jHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783888378; x=1784493178;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hoFLr1vfVTbyBPCDDFLHELDOVM+etETDJUoaDXyGSaU=;
        b=QWwYFe6gEeCZpgLv9Mw6hEXslJySmO6Cg7rLaJtPyZ99j8FSByXN2tLxbM5U+UmA88
         Mwb99wqPV/ir4K7RgGXbKJoOSKQDUOmTEcpwhoiQNMv/RPO6ejPPcy8bkrUx9dViEuo4
         6fabBSu6S6D/46W21NVFQObPN5ovTAr0vVpq9MT1FJAU2oSmCXmKuyq5EV1alDKnRNRV
         ZTLDYFZmhBgIxiToDw6W9//F50FvQ1U959EvIuqr6tfzgO9x+7SLDoBEttZmvmfpU2WN
         MDYbOdDSCTujid4vPJR2VFJEk8LlSmyCtaJzfSy4Gm8tdy/UfqkQRSvnOPgsH0fLbWUW
         NjbQ==
X-Forwarded-Encrypted: i=1; AHgh+RqwWeY1xWji/zcRBIYy10VkyHMDtk0Jev+gR7HyBZzGCuKWVQ1DNjjUQNQjKeJY1thV0R/kVqh9Vw==@kvack.org
X-Gm-Message-State: AOJu0YwNZJu8R03vqIt0/jzZGS1cjQNM4Bb/OGR5DYx0zjErnHH//1YK
	PA2a5Ul+IwTJ2EBnkwedoSSOjIlunGT6Czf1YY1nBnVcuuWcNOBMgXam
X-Gm-Gg: AfdE7cn3U0FoCgPc3qKI8kciub2fciWnfdi1DeQYvqJ5GhgHfg9IBLYgsIz05sRXyPi
	cZBusPemyMQezJvQbR+xk3k0k0a3NKekWgDdZRp6LjcaZ+VzsXZxeU706qV2cHW7LRNep4FmHGj
	pCsWjeeBTJS9sfMRQYpGMjlHhA9DuOB5j3caZZ2blgymeZIAR0x81ce7yPNpOsIzKCRSIqu5Z1g
	8euxAbwO9rWRoxmUPSjh4BYgvc/wByI6pnwTri14Jdr41DdjqZIrh+Zt/Cakj233A1zIBCZeYFk
	Evhs/Def4U6CMTJLEaSzJR3q8YEbnAZKyoIOjD0g+fHrfpXfOURGZ3E5lpZkyLTFPqUJmq3Rdjr
	uRglOM7BmtDAAMuY4zSxrsMNT/W730cmnc9JdEgIKWZYn5r2qsSSxZclSC3gnQtcPyoGoxqnYlM
	CfwOtoSr8Z8k8cg6iPAmLqTA==
X-Received: by 2002:a05:600c:b99:b0:493:b61c:72c3 with SMTP id 5b1f17b1804b1-493f8829956mr66599105e9.32.1783888377859;
        Sun, 12 Jul 2026 13:32:57 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039af67sm88998034f8f.17.2026.07.12.13.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 13:32:57 -0700 (PDT)
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
Date: Sun, 12 Jul 2026 17:32:49 -0300
Message-ID: <alP58SgTc2_8OFPc@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260520130903.Ebsd4aUa@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com> <20260520130903.Ebsd4aUa@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fh98dihowc8zbn13n6nykpue1ohze7bn
X-Rspamd-Queue-Id: A703BC0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783888379-546478
X-HE-Meta: U2FsdGVkX187x8R+MIyI8730mQGg8S+qLibLisTNAOmtrJDqoNxIY+dfNsHI+wewLYNMXEGMfVEK1XG8EPXXIDNalbj+AGYTW4iAjvEH2pg07N+ltD01hh5C8yzrt1Q1uqmDsGr2p8QOyYu8iWgOJzJuFFAsrpdnQl8zjD+MGCGqFtKtG7hGXGCoVZsf0j29OIujX45t+B4vlJUhtdrQ6s/z9ucuzS9tM4d+27HNOTjETuMxCViVlWpcJnnurd72cmybQ8wxz0RQ5aAnp8Q85Yxz9FeLlBgqcbZuzM1bhcl4D91dD6jH40s7xsp6jp4LB09r15AFWOiDmuM8Uka6z2Oru1eTRznengCoqvb4XfkU0agKH+FNjgFvNdaro1GKP52qwWeX0aJ6f5aJBmN+dUuKA3pd0peF70EdNeZqrB/PwboVRgZge5daivFXkiI8i48Whd/MBAwSAc50Fd4DtgFFtvs+HoaU48uwwUoK1S9JYuVjrf7Liy2k1avhu9qBUyY8xiwOcdoYrGer1ZSPU0/N9gycvb6Phlh1oHMjwFR7Sw/36nD49qR6ajA6e2wwxVCof0MjM2PeD7Djc7Mb7PbncRzbiy2Vqc7iIqcXU0rO7DkA38GpnYirkqHIfxoHnvzgjnreeggWw+THhqw03SIUz4eRhux8iWQilh6YdRB92GXEJdPs69EjXbEqdspl85uheTQqMfrpGxLiRHKvlYfPRLAPWqzPH8IYRudW6aDAmaQgrYKwIuBYU4cPQKUsD+grxdueepBgK5hi7xXhCEj3LDANpWi4dEMennutRSQAKNB6leO1sBEskYKnn0QITJANj8CHoVCsZMUfIhwxnomPiw0LMOs5aODO8nCD7ynvkkUKlY/mcb11IdgHkF/Kwl2nc1lvgVHa6WafeXiVt2Z72FKsy5wnoMQpN3mXZTTDTuzoUsBHMyMZ4LkSrfGErfR0THMZcXa3FgFkhJM
 ftGf73pN
 snvQq9vQloAu47L/PcdPMw63+cV8ABjWDdpasavlmpEQv2pfILyMfTBd1k+3VBlg7XjS1Wb5Ht1N6QKZio04c0Of0q54c4C24LzM/fvMwGsOcEnWgUaiOFOEzog4mJb3kMGewNChxk2+h0fPYsrxuDViOI+Np5qxlb0WfaJlB8AtfuRxpj1slIkT6AKrDkM6hpug6KtC4WsAat7Jvwa7tvTeJiluUGZWfIarLKdmeWx1dCegqT1/vOHMwBh9s9a4sfjxMi9Hpiht5yMJt8/8Nq0/jbjRXUFKxyIvSCXriiidSU1WygikEqho5rrJwKkCgmfuF9kM5VZR1gZf9LWvYmJcj7sLM7/HF/HgEEm7L/MmcKc79YS5VvrmyrsShe33mFW0VWBPmKpHNUenrcm51QS/NNgKOJh3G/twIbCsWKgwMhwiqG/pVlh7h0fmV8b3ZtQkOArcGXLjInpPZ8r2eBideMv61wSV8a6+lvY4s24WxcuBOs7JnoQbPiH2DJ688hkx8VX8GhOOKyp0UGTpbylK5JoIf6xozUqPG4CsLACWe0uHKYjNM5D/QPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 03:09:03PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-05-18 22:27:46 [-0300], Leonardo Bras wrote:
> > The problem:
> > Some places in the kernel implement a parallel programming strategy
> > consisting on local_locks() for most of the work, and some rare remote
> > operations are scheduled on target cpu. This keeps cache bouncing low since
> > cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> > kernels, even though the very few remote operations will be expensive due
> > to scheduling overhead.
> > 
> > On the other hand, for RT workloads this can represent a problem: getting
> > an important workload scheduled out to deal with remote requests is
> > sure to introduce unexpected deadline misses.
> > 
> > The idea:
> > Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.

Hi Sebastian, thank you for reviewing!
(Sorry for the delay)

> It does not become a _spin_lock because it does not spin. It sleeps.

Right, it's a per-cpu mutex. 
My point is that it's a full lock, and we could use it instead of doing the 
whole scheduling thing, since we are already paying the 'atomic overhead' 
to get the lock here.

> 
> > In this case, instead of scheduling work on a remote cpu, it should
> > be safe to grab that remote cpu's per-cpu spinlock and run the required
> > work locally. That major cost, which is un/locking in every local function,
> > already happens in PREEMPT_RT.
> 
> We did have this before but only in the RT tree. It was a bit messy from
> the naming because it started with local_ but then it was a remote CPU.

Had the same naming issue here. This idea was initially a expansion to 
local_lock() mechanism, about the same way you were planning in the past.

> The main issue was the different code path which led to a few deadlocks
> back then.
> By the time local_lock_t went upstream, the cross-CPU locking was
> removed. As far as I remember, the cross-CPU user which did schedule
> work on a remote CPU and annoyed NOHZ folks were replaced.

I understand this could be a big issue if used in a generic way.

What I am proposing here a mechanism that standardizes those 
local_lock()+IPI strategies based on how they are done today, so we are 
only explected to get 'remote-cpu' pwlocks in the 'IPI replacement' 
operations.

The idea is pwlock_local* in every local function, and pwlock*(,cpu) in 
operations that can be remote. 

Maybe being used in a more constrained way, it has less chance of being an 
issue. Also, the whole idea is to improve CPU isolation numbers by 
reducing IPIs, so maybe NOHZ people will be happier with that :)

Thanks again!
Leo

