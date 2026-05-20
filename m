Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 892BECD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D130A6B00E5; Wed, 20 May 2026 11:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA656B00E7; Wed, 20 May 2026 11:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDA496B00ED; Wed, 20 May 2026 11:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF2FE6B00E5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:07:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60E121C081A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:07:42 +0000 (UTC)
X-FDA: 84788127564.17.E8BF756
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf08.hostedemail.com (Postfix) with ESMTP id A0E7D160009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:07:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="G/TgLuOa";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=FuPsFaRt;
	spf=pass (imf08.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KN1wvoHprQssDeR7+IQiZjcPmwBUmM9w1xfU6JNFOrw=;
	b=Wiu9lYblDyottTuRPWwQAT74lH/S3o3ULJtmfCpHw0gHWjQdi50Q9Nmi2hRzFOuuAEgqkA
	DImgEoGi7JAZEGxaVZoeKf7vJJW99JysexfL4pjfspS/kzAGa4gkqotDudxkp0UbZoV/C0
	8/nNOU68HW2VT8v7D4GgZcEH71yvILg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="G/TgLuOa";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=FuPsFaRt;
	spf=pass (imf08.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289660; a=rsa-sha256;
	cv=none;
	b=O0QgY9R0U5M0l38aoHCKmQEgYRSdWaL2aojWSipliF8GLq1BEETbWV/AAUWuB4ASOWriC1
	uI0hHWwCttZzYRsTd0KcnP6UW1pToJan3b87i7YO8bWKAaRjCY5fIqWwCHi1PPxSlba3rX
	z07uO5lS5U5JiV1L4AEG+ZVvXHZRIfA=
Date: Wed, 20 May 2026 17:07:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779289658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KN1wvoHprQssDeR7+IQiZjcPmwBUmM9w1xfU6JNFOrw=;
	b=G/TgLuOaBFNbegoedGpaHIgUve+xGtuBYkP+MBRC/JZnHaOPOoxXxnVK13fbwivQ/4JqeV
	qxx7q0V0cbDZtjh1jLSWCWyMp9ZuxaIyS8b0iwPdGv6vWCTfg6AdNSAJillfyBbbrLir5Q
	Xalz3aBVaK3Sr3Q6ElgJhiY9KCsoqmzAwhWb1r0D1HWWkNkEtN/PYINl7HDfczxs2oGu7L
	BpNeOiufHn78OvpO4eRoJ2fcBoVxgFi5VrkMnaeVqqMVC87+4nMWpxGR//8K2hCVIs1keB
	lcNzhF1GapHdBFXaRuB75WSY1nr0stB6Y9gOd30QTnvwR/XMr/2qXkmweDULHQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779289658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KN1wvoHprQssDeR7+IQiZjcPmwBUmM9w1xfU6JNFOrw=;
	b=FuPsFaRtD3udrdCoS4HkPjULODop/QjZowu6oOpwHxGMI4Yxeq03tl74tYZt2egyGksEbi
	TKQ2oiVLeG0D5+Bg==
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
Subject: Re: [PATCH v4 3/4] swap: apply new pw_queue_on() interface
Message-ID: <20260520150736.HZnlFkv7@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com>
 <20260519012754.240804-4-leobras.c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260519012754.240804-4-leobras.c@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A0E7D160009
X-Stat-Signature: magui4cidgynebp6tgump7ia7bkrw1a3
X-HE-Tag: 1779289660-338756
X-HE-Meta: U2FsdGVkX19cDjUq9wqyN9UgZJn16vzpbcB4eGS4k53ulJ9AzGBNdQh6GFv4FFCdql9QwpunCkDL7/vKWg5w0/jsPWySEyPf5XlqReGWXnwCh/AAyipeWj9YlTyILzzAsFC7M8Pm3MYydW7oLDOYLWJpdO0XepbNQOr/vqkMsu48VWm87WtHmQyMtbRDU2kOFbmboEpMc6qBz8LnT3VuhgsnlpOtTcsLS2NpmoxPU68Wyf6VWvY1L2AWW8cLg2kFQFFiwnwHw4Kd01REPeYgU51/z9ZE6m5ubsUEpunrfE/ndJNzGB8T/cLkJBGJi3dOd1OamIgWIwe42kQLzdsbTBMyMhnEERhWVL2eVk1LO8z+jIofGwS8Y3XA8eMRpdh3R4WeI83ZPPIx1qcYYKYWSXY95GuXrNk6DCSTuEilt1PpyViiZ9wIgD2Blpk1PYe8FkoKSjOFTN1BFerLlxj1ripMbF52FaSu5jTOuwj+aD/BsA8acb+0dul3umNgh3zGjrXx9V7rQNcbXvhy2YT16o4f84zphTmNN/ynx2624Xe/une+iPX8ccFrj32ZvANw1lozoIkOvAJRxPGcy/yClpLZHMX06J0MnC6ojC9Bq+C52qobtvTVOWqqaBgArRZp7c0CAM9eudmliSN6c1MIRxjwyUu85ZF8heVcrkvuOj3P5ZxVfIfHFOZzn70wjPTuy5g7yMdp2+qMnFqkQrk1xplvOtnV0bKVjNaFsBJAGc7Dso75KpLxs7VveJJLiVGSgvzR+b5wErrR4CuIjLJwK1MbEDwshc+wKuwSFLGW01J/F2K+4v1q7ix9Co0tuBlCktg/9rzTkgdNJu+UNn4IkDseA6qhFWpmWfIZid2GGOZOHFlAy9lounNiyqwIg4zOh5mNAYOx+m2aQ47g78QUM35oR0Et5uLHEiQ7D5fK0buCqBU1tZzlT00oM/yUzWdPQvZo2lPp3A+vnUSqbTo
 hh6BAkBV
 eI/wEqUFJ4NyFU4CMjZ82T/XsZM+grO7wCqK24Pn0GDYzuojtmCQQTPbX0pXBm5fKVEskJ4RQ0rB9vtoyE66e3KFv64REpFWitQELfThGUxAWF98Ut4+/C2zx2iOU5OjW5ATsq2+po7fVPZ5umFBKr9B84NZX7etQIDVxtW3vdI3WzUVAKJx7fmEQU39tRTrPZcRbyoxiFp2K3S9VYlCeYWdU5we6m0nC1+5i5S49tPdsCTAt6q07fWss9eS2RnyZ3qiL3OT9hf8waPhQLER7cDuKmr3V0m6dZZyskUIJkD8/gyZIzXAzQWYcrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-18 22:27:49 [-0300], Leonardo Bras wrote:

after digesting the slub patch,

> @@ -882,38 +879,38 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
>  	 * If the paired barrier is done at any later step, e.g. after the
>  	 * loop, CPU #x will just exit at (C) and miss flushing out all of its
>  	 * added pages.
>  	 */
>  	WRITE_ONCE(lru_drain_gen, lru_drain_gen + 1);
>  	smp_mb();
>  
>  	cpumask_clear(&has_mm_work);
>  	cpumask_clear(&has_bh_work);
>  	for_each_online_cpu(cpu) {
> -		struct work_struct *mm_work = &per_cpu(lru_add_drain_work, cpu);
> +		struct pw_struct *mm_pw = &per_cpu(lru_add_drain_pw, cpu);
>  		struct work_struct *bh_work = &per_cpu(bh_add_drain_work, cpu);
>  
>  		if (cpu_needs_mm_drain(cpu)) {
> -			INIT_WORK(mm_work, lru_add_drain_per_cpu);
> -			queue_work_on(cpu, mm_percpu_wq, mm_work);
> +			INIT_PW(mm_pw, lru_add_drain_per_cpu, cpu);
> +			pw_queue_on(cpu, mm_percpu_wq, mm_pw);
>  			__cpumask_set_cpu(cpu, &has_mm_work);
>  		}
>  
>  		if (cpu_needs_bh_drain(cpu)) {
>  			INIT_WORK(bh_work, bh_add_drain_per_cpu);
>  			queue_work_on(cpu, mm_percpu_wq, bh_work);
>  			__cpumask_set_cpu(cpu, &has_bh_work);
>  		}
>  	}
>  
>  	for_each_cpu(cpu, &has_mm_work)
> -		flush_work(&per_cpu(lru_add_drain_work, cpu));
> +		pw_flush(&per_cpu(lru_add_drain_pw, cpu));
>  
>  	for_each_cpu(cpu, &has_bh_work)
>  		flush_work(&per_cpu(bh_add_drain_work, cpu));

Why do we have two iterations here? Is it just a proof of concept that
is not complete yet? I am curious why it is okay/needed to "remove" the
one workqueue but not the other. Maybe the other does not bother as much
as the other does.

But essentially we can't use a spin_lock_t here because due to the
hotpath nature of the code it will kill performance. So instead we do it
anyway but behind a switch so that only those suffer from this that do
not want to suffer from workqueue interruption on a NOHZ full system,
right?

I thought that this improved since commit
  ff042f4a9b050 ("mm: lru_cache_disable: replace work queue synchronization with synchronize_rcu")

Did it get worse or was it not entirely gone?

>  done:
>  	mutex_unlock(&lock);
>  }
>  
>  void lru_add_drain_all(void)
>  {

Sebastian

