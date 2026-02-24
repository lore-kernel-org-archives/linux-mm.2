Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A612F4BB71
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 18:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2083A6B008A; Tue, 24 Feb 2026 13:26:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9906B008C; Tue, 24 Feb 2026 13:26:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB646B0092; Tue, 24 Feb 2026 13:26:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D210F6B008C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:26:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 985381402AA
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:26:35 +0000 (UTC)
X-FDA: 84480180750.18.6E6B182
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id AEC13C000E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:26:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bF3F2z5K;
	spf=pass (imf10.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771957593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GML4cQKyFDkRjMCJYN18Tp92PgzLzTZvQzyFw96BP3s=;
	b=cCaYrQlzfmSKUF/pjrXaPvyVRRg1ewj4Uqn+tZbqKX1tSMvYbFXqKa8QRykI36xXk0kkAC
	CRjfbTKpoB+h7pMYrSaYd2WF+Ygd3qTwSerIEd8OLYv3oSgixgA8b/zigq7OAN/Vx3zQRv
	//sog13dM1lsVItDXQh1MzlIdrtcHQQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bF3F2z5K;
	spf=pass (imf10.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771957593; a=rsa-sha256;
	cv=none;
	b=2OArGir+XWSYhp4WkpUxaiEcojBJN+YLp9AcNWHlpb5vrYalnRaRbPdg7B8xP04GNfbqrW
	DaDTqQwU4uxbdt3xbbyvbPmA0A584aNK1CZ6GqrrwJUSuqa0Ho3m9d/gHAOmusWZNyonPV
	2O03oobbXwhwTURtfIyyswO9efR38xc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771957593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GML4cQKyFDkRjMCJYN18Tp92PgzLzTZvQzyFw96BP3s=;
	b=bF3F2z5KPKvrW+rZuaf/dwt8q4GKDZOOoRHjnOacrHc/n7ly0Ixgx1w8RgMGebx8n982i1
	GQNepjq9iCQABVlEqf2n5vBogWNvOEt7D0Le8LL0ZHDnRotqCGBAAVRNaVJVLoqkyHdEd0
	VRYuZaXHci70go+ZWWGteJjjhXuh6vw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-140-4_cKb8SaPYe60uVj9YEhjw-1; Tue,
 24 Feb 2026 13:26:27 -0500
X-MC-Unique: 4_cKb8SaPYe60uVj9YEhjw-1
X-Mimecast-MFC-AGG-ID: 4_cKb8SaPYe60uVj9YEhjw_1771957582
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09ED319560BA;
	Tue, 24 Feb 2026 18:26:22 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FCBC3003D88;
	Tue, 24 Feb 2026 18:26:19 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 976304028250B; Tue, 24 Feb 2026 14:23:25 -0300 (-03)
Date: Tue, 24 Feb 2026 14:23:25 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZ3ejedS7nE5mnva@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <aZdk19MqYhWK90Do@tiehlicka>
 <aZzM_44L1vKzcOCy@pavilion.home>
MIME-Version: 1.0
In-Reply-To: <aZzM_44L1vKzcOCy@pavilion.home>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: EyDBwsyoMPtk1XhdOPNIaMPP-ZyB-vKHBADI6Cw06kI_1771957582
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: trmhuwjk953mn8t1wo1qjtthn669hsis
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: AEC13C000E
X-HE-Tag: 1771957593-839997
X-HE-Meta: U2FsdGVkX19hMEtsPEij3S6SyhZKkzQUsVRyJnekdRVoTpewQ4DM9RUn2WoVbLYDQUyMKe7ECtwI969rw1Ne4jXnOjomzy0y3aSpop6N6t+D4FdHpAk4SRXletTLY3gPjInK6RCIYkTT7EsEOSid4Rmp5sFNazbbYau2M5HOSq5/UtQi2CA1kvYavu8+598UdWS5bEfpz5dVvb8IFZLAKfs7cdBgcVDnDQvxQ6r1aXJJgNuvVV40tCzSwWo2R/pX6Rj/j/1/t8I6/9DkTq6eTVLE5v2lu1Ne4+gaEYKwpxT2X3j1GDHeftMqxje2vWPKcBKFebSq2l1m8KoVeqeiDLOweMeVAa4igvy9TvMBTRx6jMdX8GIxG3liDhU4/YfabH2Y3Cb7RHJhutZDbX6p94illA5ggNo+Xp4p8+QK9e/JXBPFHZMsORHj9xCi3Fj3KbmROQBfMhwm1Ome1O8RsS/Txdq8J80ht5fToAA4HkYo35WlO230j27Kl2B0EiCX0OVUXrvliTrhMlA8p27wUf1BGRpOzxeX+FXxqgzSok/jkleyv9LlBr5oOuEkzd3tAQG5EYCcvvjZIGNqF5kV6hGuDrNlGQzkGdJx0SpNbW6Pz8WTkKiXIWxUkYTfdaoPNsRerzxM9erFPbUokp+OoEbYt0oTvN55r9cO373gTzbOn6usMrTz/tbLQsro1MwgEeEc9I3+vIJD7O62wdUXZtU0bWqoEFi5VISj5ur4Jz+FzKqvB6Rk9TZ4fSnx4d0JyXFDC3WqoHIc2yZ26oSpR718xsA2yrHk6S+IG/WSUPDROWT2oe2KkHK6FAC6MG4poRaTVhhZNhoKfSz2SCn+jbDrIBPjWaoig/ZJqs8twKTMFjmflg3+mq12o/5tb7bmx3UHCXPaU0VPR5rgrAC4+0cvsmILRLQdAa9ctJ+AYdp3OaSlgfnFBH4qTh0wimW5eU4FhlFNBiy9PWFTqCT
 wD0+O+ID
 D2lIpfZJFxXfddE1EqdGYzRHLIaxwNjYxn3sX/RiKrzyZ83RmFrHAkHuTvIPcMTike36BjQmNoHMDtNd+0UXxYrBVWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 10:56:15PM +0100, Frederic Weisbecker wrote:
> Le Thu, Feb 19, 2026 at 08:30:31PM +0100, Michal Hocko a écrit :
> > On Thu 19-02-26 12:27:23, Marcelo Tosatti wrote:
> > > Michal,
> > > 
> > > Again, i don't see how moving operations to happen at return to 
> > > kernel would help (assuming you are talking about 
> > > "context_tracking,x86: Defer some IPIs until a user->kernel transition").
> > 
> > Nope, I am not talking about IPIs, although those are an example of pcp
> > state as well. I am sorry I do not have a link handy, I am pretty sure
> > Frederic will have that. Another example, though, was vmstat flushes
> > that need to be pcp. There are many other examples.
> 
> Here it is:
> 
> https://lore.kernel.org/all/20250410152327.24504-1-frederic@kernel.org/
> 
> Thanks.

Frederic,

I think this is a valid solution, however on systems with many CPUs, in
nohz_full, performing system calls, can't there be significant increase
of lru_lock contention ? Consider 100+ CPUs performing many system calls
which add 1 or 2 folios to per-CPU LRU lists.


Note: if you are confident about the above not being a problem, 
this approach looks good to me.

commit eb709b0d062efd653a61183af8e27b2711c3cf5c
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Tue May 24 17:12:55 2011 -0700

    mm: batch activate_page() to reduce lock contention
    
    The zone->lru_lock is heavily contented in workload where activate_page()
    is frequently used.  We could do batch activate_page() to reduce the lock
    contention.  The batched pages will be added into zone list when the pool
    is full or page reclaim is trying to drain them.
    
    For example, in a 4 socket 64 CPU system, create a sparse file and 64
    processes, processes shared map to the file.  Each process read access the
    whole file and then exit.  The process exit will do unmap_vmas() and cause
    a lot of activate_page() call.  In such workload, we saw about 58% total
    time reduction with below patch.  Other workloads with a lot of
    activate_page also benefits a lot too.

...
    The most significent are:
      case-lru-file-readtwice     -11.69%
      case-mmap-pread-rand        -15.26%
      case-mmap-pread-seq         -69.72%

Some Gemini answers (question was "list of nohz_full usecases"):

2. Scientific Simulation & Research

Research institutions (like CERN, NASA, or national labs) use nohz_full
for "tightly coupled" parallel workloads.

Workloads: Molecular dynamics, fluid dynamics (CFD), and weather forecasting (e.g., WRF models).

The "Barrier" Problem: In massive clusters using MPI (Message Passing
Interface), all CPUs often have to reach a synchronization barrier
before the next step of a simulation. If one CPU is delayed by a few
milliseconds due to a timer tick, all other thousands of CPUs sit idle
waiting for it. nohz_full prevents this "tail latency" from stalling the
entire supercomputer.

...

4. Competitive Benchmarking & Kernel Development
Performance engineers use this mode to get "clean" numbers when testing
new hardware or compilers.

Workloads: Core-to-core latency tests, cache-bandwidth benchmarks, and
standard suites like SPEC CPU.

Goal: Eliminating the "noise" of the operating system so that the
results reflect pure hardware performance.

...

Summary Table: Who uses nohz_full?
User Group       Primary Workload       Why they use it
Quant Firms      High-Frequency Trading To prevent micro-stutter during trade execution.
Research Labs    MPI-based Simulations  To avoid the "slowest node" stalling the whole cluster.
Telcos/ISP       5G/Packet Processing   To ensure wire-speed processing without interrupts.
Hardware Vendors Chip Validation        To benchmark CPU performance without OS interference.


Here is how scientific simulations handle system calls:

1. The "Compute-Loop" (Low Syscall)

The core of a simulation (like a GROMACS molecular dynamics step) is
just raw math: fetching data from RAM, doing floating-point arithmetic
(AVX/SSE), and writing it back.

During the loop: The CPU stays in "Userspace" for millions of cycles
without ever asking the kernel for help.

Why it works: Since there are no system calls, nohz_full can
successfully turn off the timer tick, allowing the CPU to focus 100% on
the math.

2. The "Communication-Phase" (High Syscall)

System calls usually happen only at the end of a computation block, when
the simulation needs to talk to other nodes.

The Tools: MPI (Message Passing Interface) uses system calls like write,
sendmsg, or specialized RDMA calls to move data across the network.

The Pattern: These simulations follow a "Burst" pattern—long periods
of zero system calls (computation) followed by a quick burst of system
calls (synchronization).

3. When are they "Syscall Intensive"?

There are specific parts of a simulation that are intensive, but
researchers try to minimize them:

I/O Operations: Writing "checkpoints" or large trajectory files to disk
(using write()). This is why high-end HPC systems use Asynchronous I/O
or dedicated I/O nodes—to keep the compute cores from getting bogged
down in system calls.

Memory Allocation: Constantly calling malloc/free involves the brk or
mmap system calls. Optimized simulation tools pre-allocate all the
memory they need at startup to avoid this.


