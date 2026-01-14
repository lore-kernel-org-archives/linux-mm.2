Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F85D38FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AE936B009F; Wed, 14 Jan 2026 11:48:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999C66B00A0; Wed, 14 Jan 2026 11:48:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89BD56B00A1; Wed, 14 Jan 2026 11:48:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B60B6B009F
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:48:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 138DC5958C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:48:06 +0000 (UTC)
X-FDA: 84331151772.08.1F745FF
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id E1FCC1C0003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:48:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RZrRKAdj;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cWihw0KAMXVM/F7Z84yiMzol9tq02jR8sEQFJ5oi4pA=;
	b=P4/SYjVQlMueAzbAHyWBtWjmv+29TfYekSFVVd7r6bvpPI9LyduId0WVGq/esQxCsaW6Ri
	6wUrkMOZ3nQWUJ6ZdsqqtIaBYA5D0wbS/C+SjFSeGdrpflU2kpKfPEuCnm774PsETfbURQ
	phDEzmCwZkTP6YMnRA79A543EiAgBM8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RZrRKAdj;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768409284; a=rsa-sha256;
	cv=none;
	b=qI5SV6m7qZTqO0pTX6ucEOedt6OpkdY0ZtwZVTTYOe1P8OYcMt2+wxyB/hVuaAhJ2rCtCu
	OD+jtvd03tsUmQx3Lk314yT3zmwsALSHCZVUcFQxpYd1g7JzZuCs5wuovc1d/r3f0qUfhp
	wMFxHq29zMcEzR0pzoZj6O8S4XKLbeY=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47ed9b04365so421135e9.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768409282; x=1769014082; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cWihw0KAMXVM/F7Z84yiMzol9tq02jR8sEQFJ5oi4pA=;
        b=RZrRKAdjzyqvcRVk+dZcEF03BSoP9eLEqmMZPB1fG2dADyyhRXMzsHHjPxAsbDjl3f
         TekHUyDbxujKqUkNKE1ED7vvdFeADkk/+4kweWt8JH0Oy1ss/odoXpfiqgQzSKrWr4lr
         To7ON9Y0tGR3swNCzaeGPH6MfyeUCs9TzkeIGTHBthzfidu/+A3Y94wjMZKTCV5VqlZ2
         MUaSMDGsN1kb1S56xWThdghcPaB8PisPujkFFHZ+pTaaGAY3YpyZfLQGcLMF19bLQNbx
         HcRIrMUi6fYqYE4JB6r+4buMrwfwGzMJsygt++M9CNIN88ZI1FoFLUAMDLYxxcdL2tby
         1b4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768409282; x=1769014082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cWihw0KAMXVM/F7Z84yiMzol9tq02jR8sEQFJ5oi4pA=;
        b=Kx/h0awLHNn+ln1nXb5B3himPxyJWorQC+fld01h7T3JDJAoabOjJlNM1YSeGm5qDF
         kMFw3YsEJ7wLp/x3xEVGxicetxgO9hjb0WW51/UhJ6Znw+H2w1PygkzwFMXiXU7XsTRk
         /tUpMv5GqGG+9Kwath5JOtSZPFeicH+Q4+hJr6g2/+VYt3vRcAfMLiE052T4fj5EwlY1
         Ttt0QcfImbmLhJ59Xa+bg6nXG2Dx0BMkx7VW+lqYstKo1JtyVGSHNsQNEJtdQ5bjwOYw
         6i7fcbZjja/+YtBVV6WH7iOW0wM+RAtTjj19lfLtWK2dtFxCqCOcj1jbcTOgtqalAlHm
         BDiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzxIs56KgfPRotdAQ3c4VnzpFA7LJG0E9JW0g8e6LnrEIUyofuUrw+VkrRragkfKJrtRbXPe64Mw==@kvack.org
X-Gm-Message-State: AOJu0YwPLBX5dS4Pom5gKzAauQKPbI8VgazgqcFxLoKEU57L0kX4U5IH
	yHiLXoBStkyqEQIFzyxEJnrGJ2KUXj7nHkUdAzzsdFes+XzcME5ekuh0YBAVimZOdl8=
X-Gm-Gg: AY/fxX54e4wUTjppwCIf5M9fwEv/IJ4dkp4cy2etl9TGDxNoL5dXtF6MoKX5ZhTHJPn
	VDXid/Z0py4a6UX3ZiP2rCxTi5QvYsqCLaqER2Ksb6tlqo4fyUVVyH4dg47E56tE0ehitxRc4sl
	8h8TS6vVR+6KUwIGQwFKxDsBlJUj5H9QpNeCijXDCMzLBEDZ+2pLDCI/eU3eWDf0HpOMxWGDdHC
	0i9BPkvCXVLvs9NUvfjvGh7tt9tTlJu5c9cRNBb1SCIyfLI1JjesKZr5ndp/WF6MrLw7LvKcpbf
	sI+iRxk9MyiRm2d+YPQp+tWQ7Htb05PjrFJvx+OLAkWNpwNq2pvyePoJnfbXAPUSus8Q+/bcTIS
	HWljkhCRluwWMZzSd9IjW/e2Ebb6or+fHnrWNeCRWNQcEr7g/pSBSGkmwkbzp8yBzulPP5jiFhu
	Dy3c6VEF8eDP2kCyl4PmlLOebM
X-Received: by 2002:a05:600c:8b88:b0:477:561f:6fc8 with SMTP id 5b1f17b1804b1-47ee32e0281mr38831005e9.5.1768409282338;
        Wed, 14 Jan 2026 08:48:02 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4b267661sm439365e9.13.2026.01.14.08.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 08:48:01 -0800 (PST)
Date: Wed, 14 Jan 2026 17:48:00 +0100
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
Subject: Re: [PATCH v16 2/3] mm: Improve RSS counter approximation accuracy
 for proc interfaces
Message-ID: <aWfIwKzzIihhByJ9@tiehlicka>
References: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
 <20260114145915.49926-3-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114145915.49926-3-mathieu.desnoyers@efficios.com>
X-Stat-Signature: yhdkysyomjn7gbkw5quaue58t7sx7ijr
X-Rspam-User: 
X-Rspamd-Queue-Id: E1FCC1C0003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768409283-877632
X-HE-Meta: U2FsdGVkX1873lEIrhcID25XFW+LWSTJozjlpNcNSQX7IpEp/DNdt6soalCZ5wNmuekN51GQi5kDdzUJa0ZxGIMG5LJNOTiXdOC8NwKY91aHTwrrOWN6Pp1h1gluH5mtzH4TH+/wizvTJwxNCjKkCnx32Zty60iqGfncLKehQKPSXui98F58/maxboPWQIt5R/zC6EaUSOFHbgtuz56aKE3Sj8+BQzShLBxBE7hnEzNMuNW9F0C/xYtiBkDf60aWMMpjNC4U9feCmDYDNVdaxA0xO/tpbCX2IM0b9wl/cu6t/wBFVyKYtxPhFt6hay1Hw/E5RJLWnD0iNbsHBuRJhFX994ePwdk/ec57QtWGor3Tpuf4F9rqSmm4dRokmy5EIX1iFAwVeZokWEkcyBbuS46zPH1eFKBVR+HACaoL4IGq/BixD7UTfAV71jSA0wL1ek9Gp9FeA6v+t+gJJFeOUWnTWUCoGziW5zju3n2LwaSoR0XH+7b2K68sRnuWU5TLAUuN8cHv9qd2RbG94B89EUxWVQ8O39yQbPv6D7ZRdox3YzXx3/I8ccr6aDwQ3Ci9+Kybk4gEJvO8lbsGW9HnjHiQty2x6fMjjfy/foQvxOeY8aX0727pE7xEVAtDcAOg6KoBhdaNBasHv6VOy2lSbaZnSSalbiTd5UnVGQQZs4fI7r/M4AbDFOYrrb8XizPMiQlfadlkCpLpe4AbXcYhSj1+fj+ndsWDHkBwj3jhnARNmNOt+6I3Q6Xu37LzZq8GgSx05H2GvrfmfFlMiiGwSCKxixYju0eZXepXp5FqIrErRhqiVcp4pOk6rAyroOGDOkLHiGqsZOutdUKRWZFMtNu0R43AdOH4r3fbxx5n/HpTIKMjXbOF9Vubfafk2PwGLOzHq0ckQFQiWrNFzNHX+jZQ6yufbmzfkyS6tqonQ6A3f13Rirphka5b4qC4RTHbcRXpeezCLda+iHWrdPO
 2Lr44+qa
 mRRUyqB5BcfoB54PHeuk7s/BIbVAK1IkhwjGwrWqBFF9Pv0tJo17qS0u6dTylgvOq7+4vAZSIKTNXoD7SlI5bHLS7dL0DlNQLrOLmkBUpGuv3nlEi5ThVbah0OmtT6CC/je1k+HgwZOVRYJVCSS3Rg7tOb+y2GWt+6NhWXnOgfa/YJh6GFwFdSwdBPxhV9S4U9XR0magZYVjEDBGS3uL6x+y+fmnNkRipV687+3960x1rP744fIMvR7NZ/fhnbwM6K2jOQJGJAcBWtd3mJW2XNOtkSKHN6RpM+cQ2ouycQ4FChQbQYX2EHqaqK0KE54ZuOOtiXCFuyTaD9KbOELW1/eIQjiFkNxlzSKZkQwAtUOLkinjsv4+yPcH6nTE0zPGmvUDdGvSzbIMOaWoj2MyqsdAJyl2G1MauS96a8g3md60+a4c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 14-01-26 09:59:14, Mathieu Desnoyers wrote:
> Use hierarchical per-cpu counters for RSS tracking to improve the
> accuracy of per-mm RSS sum approximation on large many-core systems [1].
> This improves the accuracy of the RSS values returned by proc
> interfaces.
> 
> This is also a preparation step to introduce a 2-pass OOM killer task
> selection which leverages the approximation and accuracy ranges to
> quickly eliminate tasks which are outside of the range of the current
> selection, and thus reduce the latency introduced by execution of the
> OOM killer.
> 
> Here is a (possibly incomplete) list of the prior approaches that were
> used or proposed, along with their downside:
> 
> 1) Per-thread rss tracking: large error on many-thread processes.
> 
> 2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
>    increased system time in make test workloads [1]. Moreover, the
>    inaccuracy increases with O(n^2) with the number of CPUs.
> 
> 3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
>    error is high with systems that have lots of NUMA nodes (32 times
>    the number of NUMA nodes).
> 
> 4) Use a percise per-cpu counter sum for each counter value query:
>    Requires iteration on each possible CPUs for each sum, which
>    adds overhead (and thus increases OOM killer latency) on large
>    many-core systems running many processes.
> 
> The approach proposed here is to replace the per-cpu counters by the
> hierarchical per-cpu counters, which bounds the inaccuracy based on the
> system topology with O(N*logN).
> 
> * Testing results:
> 
> Test hardware: 2 sockets AMD EPYC 9654 96-Core Processor (384 logical CPUs total)
> 
> Methodology:
> 
> Comparing the current upstream implementation with the hierarchical
> counters is done by keeping both implementations wired up in parallel,
> and running a single-process, single-threaded program which hops
> randomly across CPUs in the system, calling mmap(2) and munmap(2) on
> random CPUs, keeping track of an array of allocated mappings, randomly
> choosing entries to either map or unmap.
> 
> get_mm_counter() is instrumented to compare the upstream counter
> approximation to the precise value, and print the delta when going over
> a given threshold. The delta of the hierarchical counter approximation
> to the precise value is also printed for comparison.
> 
> After a few minutes running this test, the upstream implementation
> counter approximation reaches a 1GB delta from the
> precise value, compared to 80MB delta with the hierarchical counter.
> The hierarchical counter provides a guaranteed maximum approximation
> inaccuracy of 192MB on that hardware topology.
> 
> * Fast path implementation comparison
> 
> The new inline percpu_counter_tree_add() uses a this_cpu_add_return()
> for the fast path (under a certain allocation size threshold).  Above
> that, it calls a slow path which "trickles up" the carry to upper level
> counters with atomic_add_return.
> 
> In comparison, the upstream counters implementation calls
> percpu_counter_add_batch which uses this_cpu_try_cmpxchg() on the fast
> path, and does a raw_spin_lock_irqsave above a certain threshold.
> 
> The hierarchical implementation is therefore expected to have less
> contention on mid-sized allocations than the upstream counters because
> the atomic counters tracking those bits are only shared across nearby
> CPUs. In comparison, the upstream counters immediately use a global
> spinlock when reaching the threshold.
> 
> * Benchmarks
> 
> Using will-it-scale page_fault1 benchmarks to compare the upstream
> counters to the hierarchical counters. This is done with hyperthreading
> disabled. The speedup is within the standard deviation of the upstream
> runs, so the overhead is not significant.
> 
>                                           upstream   hierarchical    speedup
> page_fault1_processes -s 100 -t 1           614783         615558      +0.1%
> page_fault1_threads -s 100 -t 1             612788         612447      -0.1%
> page_fault1_processes -s 100 -t 96        37994977       37932035      -0.2%
> page_fault1_threads -s 100 -t 96           2484130        2504860      +0.8%
> page_fault1_processes -s 100 -t 192       71262917       71118830      -0.2%
> page_fault1_threads -s 100 -t 192          2446437        2469296      +0.1%
> 
> This change depends on the following patch:
> "mm: Fix OOM killer inaccuracy on large many-core systems" [2]

As mentioned in the previous patch, it would be great to explicitly
mention what is the memory price for the new tracking data structure.

Other than that this seems like a generally useful improvement for
larger systems and it is my understanding that it doesn't add almost any
overhead on small end systems, correct?

-- 
Michal Hocko
SUSE Labs

