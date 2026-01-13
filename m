Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36940D30CDB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 21:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8967F6B0005; Tue, 13 Jan 2026 16:46:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8452F6B0088; Tue, 13 Jan 2026 16:46:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751126B0089; Tue, 13 Jan 2026 16:46:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 605FB6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:46:50 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE9A213A36E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:46:49 +0000 (UTC)
X-FDA: 84328275738.03.A1E8FF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 15AE380015
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:46:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zSX9a75q;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768340808; a=rsa-sha256;
	cv=none;
	b=jlWRRz8uwOM2gdi1pLX5IeGELp4TGW4BhIrB2u1tFOL1f/On+a9hAswIrYFHtEJ5q10CbA
	R8mvKduwAWzp3EYgrqhtt5qn5HEQYgrCE6NnXL9o0t1He+IP9VCJ/3gl5R9eG5b6fOUQSL
	UJrj4RzQvST0sk7TvdYu/pZ9/S9x4ck=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zSX9a75q;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768340808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77jbnNjGvttgRBstNEis+d0nxEaoUqq2VcZJgtc6MLI=;
	b=Evd+29eRfNUCLLcq4fjM3Dg5P5ntOpllBvqO70vTw17i2oEENAP8mdo+qhES+YdgdANOFq
	lvNQBmcwSrFM8atpfKsDHczTQGYuYc8VuWxtvsoNozpqTdvhjyprjYmqhbjdXTltduJo7X
	5vDMfeOepg/7D/frlf9NsBV1Vzw5Qi0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9867A44253;
	Tue, 13 Jan 2026 21:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748C7C2BC87;
	Tue, 13 Jan 2026 21:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768340806;
	bh=ZTDjIe3A3F2nwPPzv8C55wTsqbHPvVf8qFMA2lKaf0s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zSX9a75qVNuIkBH/sYml4picIhPSQHuMbZop2DBHmr9o0xuFX/P5JgVNgGPCjXyoB
	 rfyFfGwus4dUzPUnyLTE5G0QKL/QnrNbrCSV/Vs/2cTGSgzDZJTReh/S8r6XkmzG4G
	 LzEzuNrJT+DQT/c+j1ff7t8y5JMT3e/+pO2Gmxyk=
Date: Tue, 13 Jan 2026 13:46:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Martin Liu
 <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>, SeongJae
 Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
 <liam.howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Christian Brauner <brauner@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, Miaohe
 Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, stable@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik <mjguzik@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] mm: Fix OOM killer and proc stats inaccuracy on
 large many-core systems
Message-Id: <20260113134644.9030ba1504b8ea41ec91a3be@linux-foundation.org>
In-Reply-To: <20260113194734.28983-2-mathieu.desnoyers@efficios.com>
References: <20260113194734.28983-1-mathieu.desnoyers@efficios.com>
	<20260113194734.28983-2-mathieu.desnoyers@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 15AE380015
X-Stat-Signature: ijeowbs5onjj5doqs4myt5mabahdbduk
X-Rspam-User: 
X-HE-Tag: 1768340807-930317
X-HE-Meta: U2FsdGVkX1+qr+TXvw99cNR+tODBQUjSpz8kZ9MCfoyGBVFXyG4InuLYfchFNAmjwwhyjM/2bPcf7qykS6l+0E6y6hmhrxypVcI5soNhLMqixX49cwz+v9gGZ9YvAtDyXv2H4B+baN4f2YzLT39m0OUAnn8Oi6SidFF9w25bnlPtuFTvE7vWeR45kIxJUuiJxJGfhkbLOqztX2lLl5ymgleFSEWV7hG1ORfALFo/WNDrel5S0qp8oTMJE7gWeb97CDa7NL1ru4OsoJtU2CByhH499dlYdiPcDYoXn1O7XS6h+GIzElpxS0lnBqF1jGC7l9HWKlJmGXEFlXof8qpUXUw/yvuyVRhEHH9L3qzi3mdeRDqphcTwf09aTWLb8fECXMPv5e/FLXRsZE3RBO4K7nhGWFAGehvKddtdXw0iCDM/8SLTGbh2hUeb+tZUyRLhxp1R9ycIAIW8ZoDQ7ZZj/UHAF9YrNKQ/D5Ccrulu03xzLhH5HTR6gNuS+6AZybA0x9pPQtTx2I9Gz7Sk14CJeh70KhNfcL7aUmOI1fSjL8u9stdA5ljfmcEjMWiPlqMkraeJWDFZuJi6fup6y5RpiQnhsqzjWPQYzFWI5sdB9RtQKX9bumKIEknfXZcfMnM1ii+evHfv5EbFwFq9MhMx0wxuoKoxX84yXIKDvZk89VpSMoZjsXX+f0IMx4npeZNfA7A7+x+H05fAoZxCL8GcDPvplJbXr2usLHpwlfBHneEt3r/WzHzz0bxk42eFNiepUWVOTz7flu9Wm9dstbcaZ07cU2rzY6KjevrRaHmDtToyguSE6w2Dy/glmN7lRpH1c1ryxvMo0oxyHWt0w3jkIJ2StaCYjilCtAkn+gImVE7XaunTZCv2FK0KnpO+gm+80ChDN2iREWvxvJ3K2STHgmdU8VMGJq+/UgfjUoE5QjCmFl/6akek9Cmt9aqktOpUkzfk6fTRQR7TJd8KzMB
 rtFS/gws
 ufRaxmf+MzpdiQiMAI95k5bNrglRMKspywoF3DA/gCn06vDReWiLYxw8Hrh0xDLF8t8AZQ/7XIeXZlArwZhMz07hyLUh56ZYVNgWNT9K7UAoCjC13JAinoj+rCNlN+tlJqaJfOXhJgoa1b4c1ZPSKGzBRTKcAzkG6jYxqM8TPggWDqgUwGXsd/ixrg0XmOwE4omEt3kdOy3IfxLDmBUBqJrlCiZnrQDV7PaxacSZuc2LiAHXTroJPWtKFkBW+eINzUpNfCOhwpY6IqUPqoFOh1EI0zilvrTqTPlVt+0A2PuxggcGyTFmsx1ni9pl4ggsoCCCrjX8rsW8T7hgWmprSdeXy0o5tV1LfQOTvWhFLwdi9PHK2RIk2sCJLy6KAHveycm5G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 14:47:34 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Use the precise, albeit slower, precise RSS counter sums for the OOM
> killer task selection and proc statistics. The approximated value is
> too imprecise on large many-core systems.

Thanks.

Problem: if I also queue your "mm: Reduce latency of OOM killer task
selection" series then this single patch won't get tested, because the
larger series erases this patch, yes?

Obvious solution: aim this patch at next-merge-window and let's look at
the larger series for the next -rc cycle.  Thoughts?

> The following rss tracking issues were noted by Sweet Tea Dorminy [1],
> which lead to picking wrong tasks as OOM kill target:
> 
>   Recently, several internal services had an RSS usage regression as part of a
>   kernel upgrade. Previously, they were on a pre-6.2 kernel and were able to
>   read RSS statistics in a backup watchdog process to monitor and decide if
>   they'd overrun their memory budget. Now, however, a representative service
>   with five threads, expected to use about a hundred MB of memory, on a 250-cpu
>   machine had memory usage tens of megabytes different from the expected amount
>   -- this constituted a significant percentage of inaccuracy, causing the
>   watchdog to act.
> 
>   This was a result of commit f1a7941243c1 ("mm: convert mm's rss stats
>   into percpu_counter") [1].  Previously, the memory error was bounded by
>   64*nr_threads pages, a very livable megabyte. Now, however, as a result of
>   scheduler decisions moving the threads around the CPUs, the memory error could
>   be as large as a gigabyte.
> 
>   This is a really tremendous inaccuracy for any few-threaded program on a
>   large machine and impedes monitoring significantly. These stat counters are
>   also used to make OOM killing decisions, so this additional inaccuracy could
>   make a big difference in OOM situations -- either resulting in the wrong
>   process being killed, or in less memory being returned from an OOM-kill than
>   expected.
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
> The simple fix proposed here is to do the precise per-cpu counters sum
> every time a counter value needs to be read. This applies to the OOM
> killer task selection, to the /proc statistics, and to the oom mark_victim
> trace event.
> 
> Note that commit 82241a83cd15 ("mm: fix the inaccurate memory statistics
> issue for users") introduced get_mm_counter_sum() for precise proc
> memory status queries for _some_ proc files. This change renames
> get_mm_counter_sum() to get_mm_counter(), thus moving the rest of the
> proc files to the precise sum.

Please confirm - switching /proc functions from get_mm_counter_sum() to
get_mm_counter_sum() doesn't actually change anything, right?  It would
be concerning to add possible overhead to things like task_statm().

> This change effectively increases the latency introduced when the OOM
> killer executes in favor of doing a more precise OOM target task
> selection. Effectively, the OOM killer iterates on all tasks, for all
> relevant page types, for which the precise sum iterates on all possible
> CPUs.
> 
> As a reference, here is the execution time of the OOM killer
> before/after the change:
> 
> AMD EPYC 9654 96-Core (2 sockets)
> Within a KVM, configured with 256 logical cpus.
> 
>                                   |  before  |  after   |
> ----------------------------------|----------|----------|
> nr_processes=40                   |  0.3 ms  |   0.5 ms |
> nr_processes=10000                |  3.0 ms  |  80.0 ms |

That seems acceptable.



