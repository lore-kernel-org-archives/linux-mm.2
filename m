Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C44D7D29DF2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6EF96B0005; Tue, 13 Jan 2026 04:24:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2096B0089; Tue, 13 Jan 2026 04:24:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6EE6B008A; Tue, 13 Jan 2026 04:24:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 871306B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:24:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 32E8C1A021D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:24:46 +0000 (UTC)
X-FDA: 84326405772.04.9DC5AB6
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 06C56100004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:24:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YjLztTyD;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768296284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZyF9oSCiMio2wmOHsADV3M+vA6ApPBpXUawJoezOv4=;
	b=V6i4GtE5vrWodPSZSi+DXUEtNDoud/MGlMxqpcLRVzHl04ZIe6SYMQ6Mno6odzXtKEEquR
	M0go0g3CUssGeLq9I89649LM5RYjcnTnC1EFzi9Llco337pVTA5gCa2HX8s/SB3HwFSLlJ
	XooulPsssIO6x1v4m9Z30sZsIH9Yxek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768296284; a=rsa-sha256;
	cv=none;
	b=4GDHrP3GEmhEHQmp2BryaUzn0y2xRA3ePaL5q7AgVJaDBVsI6kWZDPI4RX52MyOcliDBsS
	dcsFisDaKIiHYuQFx6skqX2jmqmaT0zNTpCwNCXWCqStBB3w9Uka8LhpjsPH3Ilv7SGcMZ
	ZzoXfC1j4VHHto1i5g90p7NsLfdeFJg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YjLztTyD;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-432d28870ddso2756792f8f.3
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768296282; x=1768901082; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sZyF9oSCiMio2wmOHsADV3M+vA6ApPBpXUawJoezOv4=;
        b=YjLztTyDHC3rLxfL/MHZTV3KpBsjUQPO39HebWwA4ytmVwDLNoxyrdMXRjdKRFjXU4
         rTnWk/ICzUEEMVi0IIxrkbSczQ3E+ooeNUFlZuRPw8K2F+ItmmhQnW95umuKM17vdrQ6
         CJeahpdLo5xB7cmA5tPQtJ/WjmssNdM8qR/4VdlVLxquoxxrZB/+zAf8WfBBVG7PWfLu
         nvFpJO5FpMvUTCbib3pAj/x9qUk2wFuj1YDzj3a4lSy/ehCSC24H6HDB0HlcTK8Y30o5
         xJn9t67OqJTjExH7zAOCMeYSjXLYZ6+aDON5edaIiIXjqmz8OMBi+H5rKJPNE9tF0jC4
         91+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768296282; x=1768901082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZyF9oSCiMio2wmOHsADV3M+vA6ApPBpXUawJoezOv4=;
        b=U5bhnQclPrfdim1j8+3m/zPVtu5+EFFNhHw1jUOMi6gXRrv3EXyv2SU0Ng9yEEUjFN
         qE5QgUJJ3IeuGIGVWGNvvOJDsGZe/shu0CXeSD8oxVG3nwGM44KLLO4fKVPVDi3oBOSR
         bUxLmcNOnPGipTi/I3BNjPaCAH4NLM0zTWrFKr9XilcpdO4gYhwh3dn9wiVu7oqDD3VQ
         caDXPcIbe0jefCSiwKYqD+tfem3BVQz7hYhrlCm7TnpjnWeTrRWJDi6ctzB5AxY1NuYw
         7D+aBtnMgbaHOyz9NLOojBtFbFtUWGl+JiOMuzZAbJky31xx3qllIra73X7tEKBK/sX4
         xMAA==
X-Forwarded-Encrypted: i=1; AJvYcCVr1OCSgHz6wObSKGb8SbucRV8pmTugHEFN4ETGPFzwcYNqC5FuKALEAlHD2Vsgj+NpK2QYUjbwhQ==@kvack.org
X-Gm-Message-State: AOJu0YxLpcpEMTzFYm+l33KhOmLQ+1epLf6nYiyMM5dMPiOehKzRwcwC
	T3lcS+leiOjBHT/IQKvJY+CUYkYHdm4ZAOBwDjDdZEwivy4CiLn2R2DGfGYtWMoRQzM=
X-Gm-Gg: AY/fxX67uVDgMRPW6I9CoM+7MNIdoVTqgD77kzh1rdhVLjXlKCDt5SIIRQuk56YE9fB
	mrK7X2sQb7eTP7aJTui6fHPthzXJw6DZeq8L3bR5fd+ZtgvBBwkrJC9bxnzsWO6O5Irmi7pc6TB
	ITvucGCrOA6eoIyI8txvcmadAKKxUXMJxX6GdvrLwUoJKZpohKCnNEZhLsgL0D6ZRtNkVqQH2P5
	+t58c3SJ6yp3UFn2YAacA0mFKMhGvXrWOyi9uu/T7Li3qlaXvWd0n/EeB5PLy2Z9eGeQJLCsiYX
	+8LnPTD96PevC4YKp1BOJ924aDrRKeblYBy9cC0AFJM36B6LS10fUGereWa1ND4+djZIJK/c3n7
	gbVnlx0YuwnUuj6kuwF+GYb0KtAGLc+f3d+VybcgL5wi9jJv1/v5Sdob+vHHCwxMkXPdoGO6Jj6
	wTq+/UfJHmGTvwaS0cb15uYBmx
X-Google-Smtp-Source: AGHT+IHxVARX0CcBthdCu6T5JJaZCa1h1WP2ZhQZH2siQrl0JD5UEBh8+2HwINiFB9HE7IPyLrLj0w==
X-Received: by 2002:a05:600c:a314:b0:479:3876:22a8 with SMTP id 5b1f17b1804b1-47d84b2d285mr218894715e9.16.1768296282317;
        Tue, 13 Jan 2026 01:24:42 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f68f4ddsm405518135e9.2.2026.01.13.01.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 01:24:41 -0800 (PST)
Date: Tue, 13 Jan 2026 10:24:40 +0100
From: Michal Hocko <mhocko@suse.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v13 2/3] mm: Fix OOM killer inaccuracy on large many-core
 systems
Message-ID: <aWYPWNIv4lR2FpUZ@tiehlicka>
References: <20260111194958.1231477-1-mathieu.desnoyers@efficios.com>
 <20260111194958.1231477-3-mathieu.desnoyers@efficios.com>
 <aWSz5OHBwtfYrruu@tiehlicka>
 <f2c04264-17ca-418f-bc43-e8aa6fa6cd0d@efficios.com>
 <aWVP9sPqG8VC8Oq_@tiehlicka>
 <b779c646-64c7-49f8-8847-8819227e3f1f@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b779c646-64c7-49f8-8847-8819227e3f1f@efficios.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 06C56100004
X-Rspam-User: 
X-Stat-Signature: i3q3rz8woanf6td6nf7pfabx75uj5a1a
X-HE-Tag: 1768296283-790728
X-HE-Meta: U2FsdGVkX1+Ezhk9H9SL33HyQFPvBz9mQvEKWnGploBFU7tHB9n3qN9YPPwYSY9Jtlj9reY2Qhz49kK/HCAAlW6GNhcbzg+wMJNgMzhchmTRVzAAbS3gaQUU/JDJeBKeJrlW7KLjwpw6OR9rvTOpW0Ip1C58zTWymHvIWAUWKrNSa30MVetbt0rvW4qGnf47Q/GmW9CUPrTTn5naBjUn5hhwQsJgKJcK8Be3XqatFyB8dqcaQJoSW+BeSpujNLwuLVsKkKRZxcpR4nH8mliAhbmk1hEKcuecdXtmz4pSmDvZGxXZwSwkU1eb58pJ4ErvDnjGNpVSGzg1GoAEsOudFgZVTH+46aUp1/TQ/y374kln1WWKWBz9LqEoU4PNpYo4uORbjFk7IKTM57Ky50NzOtY+8zIluATwCmSxrf6NGMgzC0UyD5WAH18qnxlVHrGEjK0Rq1xPtlRr+OiFCG3xBoZjYXB9Wgcz6AVOgJsdbacjTy4ofhY+M2zU3KSdvTuOAnj8PAA+3JxFM3Ej9PtLCQXEbmg/ap8hjnw7tn2i6TZpeGdGK7smtyczBxVTHHye2aqlieiXWQiCMc1ZvkvDy8THDKrS2EH8bq2bPDlCJiFOCpxz4Gj5fc1eAaxRuRrAUibGO2AcsqObn4BSJ3tq2sn6fWTedOc2Wdh6J+G7pWSPX6M9y4bZHF9RWtihJjwcg4FVBGsHyDyUffTOJmguq8LzqioNmuDLeHLQzJWFK9a2+d7a//asW346r0Rbv/4q6/5/8lGoW79PvoAsbZx80yhtrTk1cq3o5+40dNIrnKYdB8l1uJTS2yoPrJABhwVoiwjoHjsHnwrTGw1nt3lRMkoblYbqJ/B/fbnd3fuq8Rzpki9oC7IxmG/ewR+A19Y/SeB/+YpuPKgfiqc3T08Dh9+x0/zisqzfcB6FfC71bEqx3E4gQl3EuOt2xEIjnvx1P0l3M57pqjpsfDLEBP4
 0u2DYEeI
 BCzp/HyNdjMKYZBQhexMbzxOrA3ZIHYPbZGe0u0Rr5Ua0/Je6uQkpANYB4jVMVR6ri51iuni4JqpbSdhDgh7ctgrtQzLXSmfi4FdbW5c4mjKApHDfj6abYmXo0soMJnSr85BwqNueTlRUCa/rBZSzxD/hUDzD8CPgQFf3jbQ/QSrIoLSHGmHln2Gz7B5xdUBHaoGlRQvPOntaWou1pV27L7BEqWODiJNPl3d4f29nYXq3nr6C426Lm6XwK+w2OnFH9ZLEMm0HPyyMTnakgv4eLvDmuwtjWT8sO6AAtn1h1OiN4SfnghPT1a0POAJZhQfAe8t3vzcKQOtUgQE3ZLJc6fzO1ujVyQVpa08Q2zgxrKfgxJ4Z1gZZuDc4T3OVF3AS15iStue0lCLeZANL2lW5l9WFVquWq9/m9Gq5wqq/MSM35Y/P1np9lZCYmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 12-01-26 19:47:54, Mathieu Desnoyers wrote:
> On 2026-01-12 14:48, Michal Hocko wrote:
> > On Mon 12-01-26 14:37:49, Mathieu Desnoyers wrote:
> > > On 2026-01-12 03:42, Michal Hocko wrote:
> > > > Hi,
> > > > sorry to jump in this late but the timing of previous versions didn't
> > > > really work well for me.
> > > > 
> > > > On Sun 11-01-26 14:49:57, Mathieu Desnoyers wrote:
> > > > [...]
> > > > > Here is a (possibly incomplete) list of the prior approaches that were
> > > > > used or proposed, along with their downside:
> > > > > 
> > > > > 1) Per-thread rss tracking: large error on many-thread processes.
> > > > > 
> > > > > 2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
> > > > >      increased system time in make test workloads [1]. Moreover, the
> > > > >      inaccuracy increases with O(n^2) with the number of CPUs.
> > > > > 
> > > > > 3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
> > > > >      error is high with systems that have lots of NUMA nodes (32 times
> > > > >      the number of NUMA nodes).
> > > > > 
> > > > > The approach proposed here is to replace this by the hierarchical
> > > > > per-cpu counters, which bounds the inaccuracy based on the system
> > > > > topology with O(N*logN).
> > > > 
> > > > The concept of hierarchical pcp counter is interesting and I am
> > > > definitely not opposed if there are more users that would benefit.
> > > > 
> > > >   From the OOM POV, IIUC the primary problem is that get_mm_counter
> > > > (percpu_counter_read_positive) is too imprecise on systems when the task
> > > > is moving around a large number of cpus. In the list of alternative
> > > > solutions I do not see percpu_counter_sum_positive to be mentioned.
> > > > oom_badness() is a really slow path and taking the slow path to
> > > > calculate a much more precise value seems acceptable. Have you
> > > > considered that option?
> > > I must admit I assumed that since there was already a mechanism in place
> > > to ensure it's not necessary to sum per-cpu counters when the oom killer
> > > is trying to select tasks, it must be because this
> > > 
> > >    O(nr_possible_cpus * nr_processes)
> > > 
> > > operation must be too slow for the oom killer requirements.
> > > 
> > > AFAIU, the oom killer is executed when the memory allocator fails to
> > > allocate memory, which can be within code paths which need to progress
> > > eventually. So even though it's a slow path compared to the allocator
> > > fast path, there must be at least _some_ expectations about it
> > > completing within a decent amount of time. What would that ballpark be ?
> > 
> > I do not think we have ever promissed more than the oom killer will try
> > to unlock the system blocked on memory shortage.
> > 
> > > To give an order of magnitude, I've tried modifying the upstream
> > > oom killer to use percpu_counter_sum_positive and compared it to
> > > the hierarchical approach:
> > > 
> > > AMD EPYC 9654 96-Core (2 sockets)
> > > Within a KVM, configured with 256 logical cpus.
> > > 
> > >                     nr_processes=40    nr_processes=10000
> > > Counter sum:            0.4 ms             81.0 ms
> > > HPCC with 2-pass:       0.3 ms              9.3 ms
> > 
> > These are peanuts for the global oom situations. We have had situations
> > when soft lockup detector triggered because of the process tree
> > traversal so adding 100ms is not really critical.
> > 
> > > So as we scale up the number of processes on large SMP systems,
> > > the latency caused by the oom killer task selection greatly
> > > increases with the counter sums compared with the hierarchical
> > > approach.
> > 
> > Yes, I am not really questioning the hierarchical approach will perform
> > much better but I am thinking of a good enough solution and calculating
> > the number might be just that stop gap solution (that would be also
> > suitable for stable tree backports). I am not ruling out improving on
> > top of that by a more clever solution like your hierarchical counters
> > approach. Especially if there are more benefits from that elsewhere.
> > 
> 
> Would you be OK with introducing changes in the following order ?
> 
> 1) Fix the OOM killer inaccuracy by using counter sum (iteration on all
>    cpu counters) in task selection. This may slow down the oom killer,
>    but would at least fix its current inaccuracy issues. This could be
>    backported to stable kernels.
> 
> 2) Introduce the hierarchical percpu counters on top, as a oom killer
>    task selection performance optimization (reduce latency of oom kill).
> 
> This way, (2) becomes purely a performance optimization, so it's easy
> to bissect and revert if it causes issues.

Yes, this makes more sense.

> I agree that bringing a fix along with a performance optimization within
> a single commit makes it hard to backport to stable, and tricky to
> revert if it causes problems.
> 
> As for finding other users of the hpcc, I have ideas, but not so much
> time available to try them out, as I'm pretty much doing this in my
> spare time.

I do understand this constrain and motivation to have OOM situation
addressed with a priority. I am pretty sure that if you see issues in
OOM path then other consumers of get_mm_counter would be affected as
well. Namely /proc/<pid>/stat. There might be others but I can imagine
that some of them are more performance than precision sensitive.
All that being said it seems that we need slow-and-precise and
fast-approximate interfaces to have incremental path for other users as
well. Looking at patch 1 it seems there are interfaces available for
that. I think it would be great to call those out explicitly in the
highlevel doc to give some guidance what to use when with what kind of
expectations.

Thanks!
-- 
Michal Hocko
SUSE Labs

