Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82133CF45C8
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E371C6B0088; Mon, 12 Jan 2026 14:48:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4716B0089; Mon, 12 Jan 2026 14:48:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE35A6B008C; Mon, 12 Jan 2026 14:48:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC02B6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:48:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B5C98D078
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:48:11 +0000 (UTC)
X-FDA: 84324347982.20.3D0F860
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 434851C0002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:48:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Dwy+WMdh;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768247289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGyo51WmDqtagxgoVSIwRWG3W5A40tN9gD1xGhmOgu0=;
	b=PWnAnJM+wmhlSP9hL8CR0my4ldklESjGy4OmCNj94sU5VacxAxiA51MW3ZzF1L3LJHMROl
	EjCILIsiHObk44VrXCtUsuS4vsGEuAsm3Zz9BLduOPMmAMfl5dwN4CFyd7JKIvHHoANLeB
	qA0b8IpS9Qz9O9yq87V/rHt14e/oW/k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Dwy+WMdh;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768247289; a=rsa-sha256;
	cv=none;
	b=iqK+fEWcvGwOtJpRkSf31nOYBvMXsar/qvzl8IQNOD2bGS3LdbhDISvrqn+88jVFZEVYpx
	NYXI9GvxLFW/dAs2ueIDbvYqxziT3WCf4MXvFY57KCeV7PwmtC7hMw7aY/uvaxS+Z6H+2I
	WBmmkfu0xWkYohatr1j1wRh422llm6c=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42fbad1fa90so5841530f8f.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768247287; x=1768852087; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BGyo51WmDqtagxgoVSIwRWG3W5A40tN9gD1xGhmOgu0=;
        b=Dwy+WMdhElZsiHZrPfznMA2rdzfZms/iHSovKkahhtcxx4h392papY9WEOuFwn/p7o
         SLfzw5iA/lREBddo8Ou1hadXzQZyJkfuFfn20K1fQBOEqtzaSk+VCp7gM+UDJYzGhd/v
         giV2AFZXrLj/XCqOFQgo/p+7GS/cfmkZxE74F88oSK9wzwYNMDGr+Av7yxMU58KAx4pr
         UG8gEZzDzBmyOI8Ng/IsAxR9dYYfYjh+/4iq36jO72oKNGs/hcy+H6fj3wMv88VmPuBa
         bxCgZmE6Z7iICMpe7zuqBuVoOggpTlwcgWXgB3G+Xvxq8LUHe/Akw7ch5cK7unrzrea1
         3vjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768247287; x=1768852087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BGyo51WmDqtagxgoVSIwRWG3W5A40tN9gD1xGhmOgu0=;
        b=W57jQqLMbjw6LFDoskXZxNE5aTQFM5j7skoE78fHavBTUDKDt5t3DpDB6C44VBfHzU
         IgwsQt7GIsv3I/2+CbqoCnoTw67kE5wuzePpPVC9gNy/jY9p9zpG1N0vX62CGWfvJCvq
         pjRj8AXlRnMscu7l+rLbqNcJFTnS3n1U3TutVB7Ygy288kzPpW0mEPpojlaBOQ9d2SwL
         S98keY0n3Wve85OhBvKufSqBAGOceGUikmOO258E7Iy1EjloojQaViabMQi9xPwqOqqW
         7DTBBfWW2H0dYWxrvTT1h8h/KttislGrn1P9u8nYFqcde74vxGh62jDmDAzKcJ3UnQIW
         ZnZg==
X-Forwarded-Encrypted: i=1; AJvYcCXRAYRDuhVr1t2CIMTQ9m5RWWPcN/siWra71aX873zew4Oxhnw1Hlm6McnoR21aTDSz7RnA3GLb8g==@kvack.org
X-Gm-Message-State: AOJu0YzCPmfA0NMxms5+DVYRGXJvrBO+8RNX43XNSjxuL2d34xM8UDJb
	QSAOT5j6RlMb0C2BqPfxiJ0l10hKYTs/NG8OxqkYKfX77+mFgna53mk4ly7ILOjswzQ=
X-Gm-Gg: AY/fxX4eXvNQnhVfEGPoPDOVc77mVC8WcLKqFm7L7inxERBvAZA+bX0ZztErxkmJaGa
	yDRu8PfQLVKtmCcrFlO+c5few9TEGeVAZvw2OdnrxAMLIbpplDvNrNSzk3tcMDe3eNc8KkGmsaB
	y/sCSr61kEpJ2zblOEzY33cZR9vqpI+eNToCbx2tICn4JjKSqWDCKjvNiHwdy0K+w55J8Yx4Qxw
	CsH72MfWQ75b1ewfkiss5TpzqxmVf7KU/MRINTHtNGoo7rrPDcMQ6nCt9V8zMyzBqrxXo+tIQCY
	9hXUffXqrRcPffQTCL7LHdY+RmRMucYy17Y/iazYqWCHOPJU7nz+jPKv9kpmAxmQQx2NEZLVRMQ
	3xobWkHBdRiNGKtH87PVYp6yC5pN5va2rPnginKta390nmNTn4NeFFBYLfLPvrVDw4METH724aq
	wUpOP+HjmOht0hHalifrpxOSrY
X-Google-Smtp-Source: AGHT+IHE1lXvEz53VmoWzLLJVZRvVBwxgOdGb5mMIjcwZPpGkPDDOGRk+/iknTtt3x3D/wmw7rPQqQ==
X-Received: by 2002:a05:6000:1886:b0:432:a9f0:48c with SMTP id ffacd0b85a97d-432c38d26f6mr24261001f8f.63.1768247287544;
        Mon, 12 Jan 2026 11:48:07 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ee893sm39721819f8f.37.2026.01.12.11.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:48:07 -0800 (PST)
Date: Mon, 12 Jan 2026 20:48:06 +0100
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
Message-ID: <aWVP9sPqG8VC8Oq_@tiehlicka>
References: <20260111194958.1231477-1-mathieu.desnoyers@efficios.com>
 <20260111194958.1231477-3-mathieu.desnoyers@efficios.com>
 <aWSz5OHBwtfYrruu@tiehlicka>
 <f2c04264-17ca-418f-bc43-e8aa6fa6cd0d@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2c04264-17ca-418f-bc43-e8aa6fa6cd0d@efficios.com>
X-Stat-Signature: w88tt3w7don8hgak5sb18fjh3hwnz1ah
X-Rspamd-Queue-Id: 434851C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768247289-248103
X-HE-Meta: U2FsdGVkX1+LAo64MfKxr4qZpxkbApicK3i1YozUNNgdYVY6CeyzEv2eNpAy5Sr38sFaoW2/gkYpIqx1VYg9a+jw2zvN5hN0xGt68KMgxWPNtOnV9RDKg6LhZKtu0wwjOM9S2DeNQJOtDDxSiCGgTsSZFC0KBl0PM7xtjJXjCbd22/KHnLVwhngmc0j4LOAeJU9FXj+G4y+NJ0yXv6G2aNkB9v1aEtbcpRpOp0kKsmAaixAUd5EzLUug16/OTvzLURecxgnj3sLrbFIlzNfLbRrkEJ/jtJwBXIaTdl8zQlhmxSTDlLbZta8VBYaEl73WyKxCXtcsCJ1Iua7tIFuXXi1sDTnCo6NCdyT/eZd0xzSwL9kTPzbm/bUDDN0TmFMc5H+Becrwr7ZNdeCzZsMFPkK1LCUBfSAyEI0DTNkNF3/PwDltcDe6Y3V94PoX0+hcBXnYPejJh8Pr+JxOGsOcjF82dTgtCwqmD0YE121AFCyxN05iL3G+TSSGHdrF9fZUaQOx6H8nTtNuKlBOerI+AdY6mfaKNZQ/kEhW893vveUH1AjVq6yCo5QWwgyft/mHwJl3dWz/V9A0uO7pWQJq0idq5xpr59Udthkfggu7xe3D/2HW7fj51nlMR2Wbn8Tg5oS4D1xZfb80QR0g9gJhGlbboNNvKHZfj/HCDc3UdGNJ3bMaLSm8npb7xu/RcvSHFwguVLH6ykYihO6HEyYVrghBPJW426aEDcWbbRlSHWPJRDY18f+GF+cVp4b9x1ZfL3P3rlPDBtzys2XWzFHadctje+iE+YJC70WomvcCzrddt/d7xl1H5OOusu8l9MSrF1PW88aaxCxm+vXAgPAkxSDOx2apDhRsSG0jnHWfQUxSIk5HVbi53LR1mM/pz5UX9DBaw/Ml0yjrashCZidVAkHYbxK8BFIAEiqnuDre2Ls5b/NxmUh6v6K3SAkjZBbjbJLTzGHhW5lbOjabt9L
 sgrGH3+N
 +vWpV2EGlNz8zN420rFiteGSakkNEQeg90E5pu9S/LASjCyV6nHuLUlIp8CL3K5heDT1sNqvTLJn3Xp1JELdRelvVCPpoD9tTjf7cesC2a8R8NAhaMCFsqTt11jt2racPChGni9Kpmb3l3sc4W+db1kLBRQK/KkQlhqidKTrVoxK+YpO/y39rMg99tg0i0E0V5zhrZu8FWqywZMjWRiTUM55sxCc4naOaKZGHHpDjbHo7K9WcDCBfoC9hd28kKGqh03zjf6HoxpA18oEJR3GSi2LDit0tUlWwSps68egP9Xyt/3vq5bDkbNaY3GGSezM9OZ8zwWzTe6R2tkgrEw7BPAYRa0qAVOoQkWru98rfWLvsSs3XSBgUJxH6uFlEN5881fYeRBNWz8uWPntoMC9Y12YnGlBI2Q12aBxmASLgMwhub+c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 12-01-26 14:37:49, Mathieu Desnoyers wrote:
> On 2026-01-12 03:42, Michal Hocko wrote:
> > Hi,
> > sorry to jump in this late but the timing of previous versions didn't
> > really work well for me.
> > 
> > On Sun 11-01-26 14:49:57, Mathieu Desnoyers wrote:
> > [...]
> > > Here is a (possibly incomplete) list of the prior approaches that were
> > > used or proposed, along with their downside:
> > > 
> > > 1) Per-thread rss tracking: large error on many-thread processes.
> > > 
> > > 2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
> > >     increased system time in make test workloads [1]. Moreover, the
> > >     inaccuracy increases with O(n^2) with the number of CPUs.
> > > 
> > > 3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
> > >     error is high with systems that have lots of NUMA nodes (32 times
> > >     the number of NUMA nodes).
> > > 
> > > The approach proposed here is to replace this by the hierarchical
> > > per-cpu counters, which bounds the inaccuracy based on the system
> > > topology with O(N*logN).
> > 
> > The concept of hierarchical pcp counter is interesting and I am
> > definitely not opposed if there are more users that would benefit.
> > 
> >  From the OOM POV, IIUC the primary problem is that get_mm_counter
> > (percpu_counter_read_positive) is too imprecise on systems when the task
> > is moving around a large number of cpus. In the list of alternative
> > solutions I do not see percpu_counter_sum_positive to be mentioned.
> > oom_badness() is a really slow path and taking the slow path to
> > calculate a much more precise value seems acceptable. Have you
> > considered that option?
> I must admit I assumed that since there was already a mechanism in place
> to ensure it's not necessary to sum per-cpu counters when the oom killer
> is trying to select tasks, it must be because this
> 
>   O(nr_possible_cpus * nr_processes)
> 
> operation must be too slow for the oom killer requirements.
> 
> AFAIU, the oom killer is executed when the memory allocator fails to
> allocate memory, which can be within code paths which need to progress
> eventually. So even though it's a slow path compared to the allocator
> fast path, there must be at least _some_ expectations about it
> completing within a decent amount of time. What would that ballpark be ?

I do not think we have ever promissed more than the oom killer will try
to unlock the system blocked on memory shortage.

> To give an order of magnitude, I've tried modifying the upstream
> oom killer to use percpu_counter_sum_positive and compared it to
> the hierarchical approach:
> 
> AMD EPYC 9654 96-Core (2 sockets)
> Within a KVM, configured with 256 logical cpus.
> 
>                    nr_processes=40    nr_processes=10000
> Counter sum:            0.4 ms             81.0 ms
> HPCC with 2-pass:       0.3 ms              9.3 ms

These are peanuts for the global oom situations. We have had situations
when soft lockup detector triggered because of the process tree
traversal so adding 100ms is not really critical.

> So as we scale up the number of processes on large SMP systems,
> the latency caused by the oom killer task selection greatly
> increases with the counter sums compared with the hierarchical
> approach.

Yes, I am not really questioning the hierarchical approach will perform
much better but I am thinking of a good enough solution and calculating
the number might be just that stop gap solution (that would be also
suitable for stable tree backports). I am not ruling out improving on
top of that by a more clever solution like your hierarchical counters
approach. Especially if there are more benefits from that elsewhere.

-- 
Michal Hocko
SUSE Labs

