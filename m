Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F13606A33C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 20:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4sw6wQ3
Received: by kanga.kvack.org (Postfix)
	id D27C26B05B0; Mon,  9 Nov 2026 15:35:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2866B05B1; Mon,  9 Nov 2026 15:35:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52346B05B2; Mon,  9 Nov 2026 15:35:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F56D6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:35:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1150F1605EB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:35:46 +0000 (UTC)
X-FDA: 85416736692.10.5F03F98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3AD08C0003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:35:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4sw6wQ3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794256544;
	b=gS0YN4pwCpCdjwYFUGuLEj0exq9rfZsXSLrfMm4QeEVEFf6A862TU8MCa7QRFUiw9Ve7zC
	z0lreMWVh2w29YvnVQlJiksd0hquQVs8r1DgsaJMf7vkkJt2c9DLq/+TQB+4VRaB15WRhT
	3AEdc2b42Rfchr6tsbLunGv0lG4LUNo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794256544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4S0ZASTCxuNpF4rd1cySC3wOXo2N6s1iGqE54udrluA=;
	b=MrhKDRXJRVc9Rexegi4qDi/tsa7/KT4OzpAy2RfAwAgEoHKmXyc9QGFAkuMwG/34guZw6r
	zy+UFhQEJkO+ZW9h8fN5ccYQyQzWgMlEYEDpdS5QjdCz3etAmsRK5oi2AzlvX6Ih2VBKTC
	p0BvpJ+aTMiS41gNoeFI1kJk9i0wMN8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4sw6wQ3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 223B56124B;
	Mon,  9 Nov 2026 20:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BE31F008A3;
	Mon,  9 Nov 2026 20:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794256542;
	bh=4S0ZASTCxuNpF4rd1cySC3wOXo2N6s1iGqE54udrluA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P4sw6wQ3f4dx6u4pFALkqAd21ksXEckvh8fTjSyAtPK7pCZ5oCMgj9geo1WMAb8Zy
	 T3WPTAqBAfrjyOIGwG13GeeN3JYJDQ0p0EnAA+3SeB7wR5mcK6LoOA4Lu6t6CzmY36
	 2VQiGF1vIwZSWSmDUN9g9kebIsNKZ6E22tSOaeIO94SWxGBVGJ3qOC1yPcnVsH/Cn0
	 UZ5K32bWw2VUooDNxET6m7PVp4kstgbO6IwT0nw08/ddOnnD9tbaGGmpT3knr++bkh
	 7m8kKDrBrff07mDjClfAY1zac5v1ooNQvpK1hlOKoCgLMNjgZlX5N8FMDDhhJGVMAI
	 B6ihb0Ustt8og==
Message-ID: <88a96126-11be-41cc-ab0d-372d32189e79@kernel.org>
Date: Mon, 9 Nov 2026 21:35:26 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v24 00/10] Hierarchical Percpu Counters for RSS
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>,
 SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Yu Zhao <yuzhao@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik
 <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>,
 David Carlier <devnexen@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>,
 linux-trace-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
References: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3AD08C0003
X-Rspamd-Server: rspam12
X-Stat-Signature: 7wsku7ddckmff3eoyoxdfougmf8yj1jw
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794256544-927622
X-HE-Meta: U2FsdGVkX18mRhCr/x5l5lHt6E5jK901jLDpoSywEf6fdQHfTAjBO8ZEIui3IYWewBRknqNOTqzJ3c24btLiXYGh1EXHnMmz89QE+UGiYcEHwuUvMGwSAO6S/OpYQjuSMI78p1rmAl/7oM4/5FZXQppHmXKX3ie0yVol0GwyhZvLh4Ok1uBSIqPTdifRujv8MUaxR5jgdcX0vpnLv7jJdDxlkS0ijlVIuoTFRkK3GdnxUtiy9W7djt5hdK49b1Y1VdeAdXkUi4jT6SEmcunexypfuSDoVZV3zs9Ni4t34gnUw2BpFfLl0JB+m3OF/bBvXz+GFul3X8nR/Ff7TeUYz4B4JIZ1IC+QiOGI0A+0UA6QDCsdJn2SP3W3bfXHsQ/G+gYybm1rZM+ti7M0H3WqrGUToaKM6uN0A9u78gpFfHwfsyKLDgTHobHOaDRDJe7e7HLTd65mOL+H++efkPgkR5bAqfDBMeH6ZKFCNmZvR+jABPKLO+oYeVNmU2DVcY/6H212JpQ6yBQDkaMyIZcxKh8Zw1Wyd/v5VUSD0PMiZlHJ+DyrJ0rJ4vy4faWGHi5dALfLGtHdYiXQ7dKPtD5kMwwipS+Fl8OELnl8SR3AwwyZN9kkAfyT7iip+23mPff0W5jyANxFvnEt1qKRVpGG1daaGAbPMHJrY4wxcDopIvI+s106Z2Jwm2a+NfNWutj2gkZZZdy2jZopfoxSohcmW1+FqAji5XxvwcvBm9urp9F0O7xwZOh3rt0f+PLtXCw8JB6VldaZlTWui5meSfMQC/3cLucKnPcRBG9Zm+kBTuALhZl3Vm0R7KN3TObarIm//7Wj2y30QfchHvWfVpnvj9vYmoyuGLg3km/wSUZ4xjRFqwoEE2YAA6CEa1Y4txpqqIyNurN9iG1AF80uoQQ5vWUyYP+RYGCfo+npd1FOg4SOYM7mAYWC8w+sXRIP6xarZ5Rbdv9QSCOGaJZMM3b
 U/bF/PvX
 0Yu+mnAwI+V109sMfFzdZBLwWCiLc+Jj4ypCjMdvObfT+eJl5ltCOlv4K3ELxk9K3m8++77oYiism7HlVyjwcYqeX4vJJiPrwIo44MecKSGexeStbRX2lj6lpaW4Uyb3QEFX8nRKqlNKIMhuI00hlQQFR3MMRnvYLlHtynPte+nTiSxhYKXnLDWjtFkav18+Y4iL0eUq9gG40tfBCDWJLBdi3xSCmvHCx12D5mtlUfKCnby33Y7TH8xLkJ7DA3rbHMxkAITY9flli6QcoZZOmY/84rW0AcXT73iXZ25IAVhQOmvXx885QOT1nrQMD7vjxFEi74VRtJBF4la/K/Zwz5ZiBVOpNt939G1Ro7t8wF7lGkJRagg4OPOG4H2oSO8aaeF3q7yM2ONr2ObBgDZwJRgJNjt0YM43N24ktUxY0Hrsdb+X2jxKv9/9cDKlLE8ZCMj2P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 21:36, Mathieu Desnoyers wrote:
> Hi David,

Hi!

> 
> Here is the hierarchical per-cpu counters series for the RSS counters,
> based on v7.4-rc1.  It is an RFC because of the questions at the end,
> and because of the significant changes since v22 [1], notably the
> per-cpu counter size (long -> byte), the configuration heuristics, and
> the lazy activation introduced by patches 6 and 7.  v24 fixes the bugs
> found by the Sashiko review of v23 [2], including a NULL pointer
> dereference in patches 3 to 5 on sparc64.

I think we discussed other possible applications (IIRC Michal expressed concern
if a single user is sufficient motivation for these additional LOC). Did
anything result from that discussion that is relevant to v24?


> 
> The problem
> -----------
> 
> Since commit f1a7941243c1 ("mm: convert mm's rss stats into
> percpu_counter"), the RSS counters are struct percpu_counter with a
> batch size of max(32, 2 * nr_cpus): their approximation error grows with
> O(nr_cpus^2), up to 1.1GB per counter at 384 logical CPUs.

Okay, so that's a per-MM problem, not a per-system problem. On a large system
with many CPUs I'd have said "likel we don't care" :)

> /proc/PID/status, /proc/PID/statm and the OOM killer moved to precise
> sums (commits 82241a83cd15 and 5898aa8f9a0b), but the other readers
> still use the approximation: the RSS high watermark (VmHWM, the
> ru_maxrss reported as "Maximum resident set size" by /usr/bin/time -v,
> taskstats), /proc/PID/stat (ps, top, monitoring agents), the taskstats
> RSS-time integral (coremem, sampled at each tick), NUMA balancing and
> the mark_victim tracepoint.  On the test machine below, the
> /proc/PID/stat RSS of a test process was off by 17MB while
> single-threaded, and by up to 134MB with 64 threads.

What's the resulting impact of that (temporary) imprecision?

> 
> Precise sums cannot fix the high watermark or the RSS-time integral:
> update_hiwater_rss() samples the RSS on every unmap path, and the

As a side-note, I absolutely hate update_hiwater_rss() on the unmap path.

> integral at each tick, while a precise sum reads every possible CPU,
> about 4us per counter at 384 logical CPUs.  A smaller struct
> percpu_counter batch takes the counter spinlock on every carry: at batch
> 32, an update of the counters of a shared mm costs 4.4 to 69us with one
> thread per CPU, compared to 26ns to 1.2us with this series.
> 
> The series
> ----------
> 
> Patches 1 to 5 replace struct percpu_counter for the RSS counters with
> hierarchical per-cpu counters: per-cpu bytes carry into a tree of atomic
> counters shaped at boot from nr_cpu_ids, with a fixed batch of 32, an
> error bound in O(n*log(n)) and no global lock.  

How does this interact with CPU hotplug?

> Each level carries only
> once its residual reaches the batch in either direction, so updates
> going back and forth around a boundary do not climb the tree.  The
> comparison functions have no user in this series; a follow-up will use
> them for a faster OOM killer task selection.
> 
> Patches 6 and 7 keep the RSS counters of single-threaded processes exact
> and without per-cpu memory: until a second thread shares the mm, the
> task running on the mm adds to the bias of each counter without atomic
> instructions, and other tasks add to its atomic bias, both read in O(1).
> Creating the second thread allocates the per-cpu counters and tree
> items, and activates the tree.  struct percpu_counter cannot do this as
> is: its count is an s64 under a raw spinlock, which the remote updates
> (reclaim, khugepaged, remote GUP) would then take.

What was the particular reason to special-case single-threaded apps? Do we
expect them in practice to really be that RSS heavy+dynamic such that it would
matter?

> 
> Patches 8 to 10 are the tools to tune the tree shape on other hardware:
> the percpu_counter_tree.arity= and rss_stat_batch= boot parameters, and
> a KUnit benchmark.  The default shapes were measured on one machine,
> with up to 384 logical CPUs, so results from other hardware are welcome.

Hm, so that means one might have to fine tune these toggles to get the best
performance? That's a bit unfortunate.

> 
> Results
> -------
> 
> 2-socket AMD EPYC 9654, 192 cores, 384 logical CPUs with SMT (the CPU
> counts in this letter are logical CPUs, as in nr_cpu_ids), tree 8,8,8,
> batch 32, whole series; details in patches 3 and 7.  The bare-metal
> results were measured on v7.3: the rebase onto v7.4-rc1 had no conflict,
> and the hpcc update costs of the series as sent, measured in a pinned
> 384-vCPU guest, match the bare-metal ones within 2%.
> 
>   Accuracy per counter: bound, and largest |approximate - precise| seen
>   by get_mm_counter() while a process hops across all CPUs doing
>   mmap/munmap of 1 to 16 pages (384-vCPU KVM guest pinned to the host):
> 
>                                         hpcc   upstream
>     bound                            158.5MB      1.1GB
>     measured, single-threaded      0 (exact)      841MB
>     measured, with a second thread      96MB      845MB
> 
>   Update cost, ns per update per thread, one thread per CPU, bare metal
>   (mm: the 4 counters of one mm; private: one counter per thread; batch
>   32: local change of the benchmark, bound 46.5MB):
> 
>                                               upstream   upstream
>                                        hpcc  batch 768   batch 32
>     mm, +1                               26        288       4370
>     mm, random +-32                     135        385      69171
>     mm, random +-512                   1174      20229      69186
>     private, random +-32                 31         20          -
> 
>   /proc/PID/statm read with 1000 to 16000 processes, bare metal:
>   5.3-6.5us vs 16.5-19.0us for single-threaded processes, on par for
>   multi-threaded ones (14.4-16.0us vs 14.5-17.1us, guest).  fork + exit
>   of a single-threaded child: 116us vs 139us.  will-it-scale
>   page_fault1, 2 and 3: no regression (-0.6% to +5.1%, one boot each,
>   the upstream one on the previous day).
> 
>   Memory per mm, counting the slab objects of mm_struct and of the tree
>   items, and the per-cpu memory of the RSS counters, in bytes (guest,
>   v7.4-rc1):
> 
>                   single-threaded   threaded   upstream
>     16 CPUs                  1820       1948       2076
>     384 CPUs                 1928       8145       8072
>     1024 CPUs                2185      17204      18569
> 
>   The tree items are allocated with the per-cpu counters when the second
>   thread is created, and the mm_struct slab object keeps its upstream
>   size.
> 
> Behavior changes
> ----------------
> 
> - The allocation of the per-cpu counters and tree items moves from
>   fork() to the second thread (clone() with CLONE_VM, without
>   CLONE_VFORK), which can then fail with -ENOMEM.
> - mm_struct gains rss_owner, the task running on the mm, compared with
>   current and never dereferenced, and rss_stat_mutex, which serializes
>   the activations of the tree, as mm_cid.mutex serializes the mode
>   changes of mm_cid at fork and exit.
> - The precise sums (/proc/PID/status, /proc/PID/statm, the OOM killer)
>   take no lock: under concurrent updates of a multi-threaded process,
>   they can miss a carry on its way up the tree, where upstream counts
>   each concurrent update either whole or not at all.  They are exact for
>   a process at rest.
> - The rss_stat tracepoint reports the approximation (patch 5): exact for
>   single-threaded processes, within the bound otherwise.
> - Like struct percpu_counter, the tree is sized at boot and not
>   reshaped on hotplug; its shape and bound depend on nr_cpu_ids, while
>   the default upstream batch follows the online CPUs.
> 
> Caveats
> -------
> 
> - From 33 to 39 CPUs, up to 1.37 times less accurate than upstream.
> - The tree is shaped for the number of CPUs rounded up to a power of 2:
>   just above a power of 2, the RSS counters of a threaded process, with
>   rss_owner and the mutex, use up to 1.50 times the memory of upstream
>   (129 CPUs, 1.28 times at 65 and 1.38 times at 257), compared to at
>   most 0.90 times at a power of 2, and 1.02 times at 384 logical CPUs.
> - Private counters with random +-32 updates: 31ns vs 20ns, the price of
>   a 7 times tighter bound.
> - A multi-threaded process which ran on few CPUs can hold more error
>   than upstream: 2047 pages per CPU path vs 767 at 384 logical CPUs.  A
>   follow-up could index the counters by concurrency ID (mm_cid) instead
>   of CPU, so the accuracy bound and the precise sums would scale with
>   the concurrency the process uses.
> - Before activation, concurrent remote updates of a single-threaded
>   process contend on one atomic per counter.
> - The second thread allocates per-cpu memory, which the per-cpu
>   allocator serializes, as it does upstream at every fork: with 384
>   threads at once, init + destroy of 4 counters takes 874us per
>   operation (1004us upstream, 6.0us alone).  Tree item slab objects
>   owning their per-cpu counters, with slab destructors, could avoid it.
> - The accuracy was measured in a guest, with a debug patch and a test
>   program which are not part of the series.  The bound is analytic and
>   tested in both directions.

[...]

> 
> Questions
> ---------
> 
> 1. Is mm->rss_owner acceptable, or would you prefer current->mm == mm
>    (without PF_KTHREAD) and an "activated" flag?

I'm afraid I'm the wrong person to ask that question. I'd have to look into the
details. If it's just a simple member, we likely don't care about the addition
memory footprint (if that's your main concern).

> 2. Is moving the -ENOMEM from fork() to the second thread acceptable?

I'd assume that's not a problem.

> 3. Would you rather take the single-threaded mode first, on its own?

Again, the question is how much we care in practice, I guess.

> 4. Should the rss_stat tracepoint report the approximation, stay
>    precise, or report both?

No strong optinion on that. Do we know who uses these and for which purpose?

> 5. Should the tuning tools be merged, built only with the benchmark
>    config, or dropped later?  Who could run them on non-AMD, 4-socket,
>    arm64 or POWER machines?

Is there some way to have it be an auto-tuning instead of requiring this tooling?

> 6. Is tools/testing/hpcc the right home for the topology test?
Good question, I'd assume so.

-- 
Cheers,

David

