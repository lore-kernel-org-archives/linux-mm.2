Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2780C606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BJLkrOXZ
Received: by kanga.kvack.org (Postfix)
	id 3A5026B00EF; Thu, 29 Oct 2026 15:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3755C6B05B2; Thu, 29 Oct 2026 15:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B38A6B05BD; Thu, 29 Oct 2026 15:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02E196B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:52:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90FA6804BB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:52:40 +0000 (UTC)
X-FDA: 85376711280.10.91712F3
Received: from mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8F553100002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:52:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BJLkrOXZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.31 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793303558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a447cVMtdkqcUJRY7pb6L3o51fer89SCf7m7k3ULuN8=;
	b=jOB17twUI8naVQICwjdyr+Rqn3maLLlrm0jmVhDWL4RkQgQhHmHWFOm2OWwC0awO2nCmbH
	e8uX2FW7ATZh/r3mTbxMG4YnKKOXR6SLgIeritpn0huDAhDOFVb/KlA3lkTKzzv7PHl6eX
	DfVfr1hA+LDuIRR+/Yiffe7tdD7wHAY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BJLkrOXZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.31 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793303558;
	b=R8N/hsMjNrDjJsKzBjClbLMdTwr2/GneaaIwR+7JkuUfss1H43swVk0/Gwfp9+2tp007YB
	ZopBia10YicVMT37x9r3WozkqVm7BTN19uCmZEwfwdMN8Noq4U6c2sYHIPEyjoakFzqYAv
	5LBYUKTgTH1Pkwe89mKbBD/1fL+PKWo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XZ2azTUUWfrxKE1K4J2pw0GmPL2WGA3CYY9gqmtHK18=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793303557; v=1; x=1793908357;
 b=BJLkrOXZx/1vobWi+dAYt72zpfjVKP52ixGzQxuNg5bTSwDs/wGRXzmwdqhf2jIHhWav8q4s
 GNGJy1yDmOp5m1OqjeANl8gOfVeCqVh9L3cMEl/qLibkW3BR83L7EnAHpVECAR/3PJSqotAedBa
 w4HH65LOIdY9hipBf3AHflLc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 682a9705787ec960;
	Thu, 29 Oct 2026 19:52:37 +0000
X-Mizu-Trace-ID: 682a9705787ec960
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 12:52:34 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 4/4] memcg: Uncharge pages outside memcg_stock.lock in
 refill_stock().
Message-ID: <auOj3mC-J9QC0hCx@linux.dev>
References: <20261029194452.3189365-1-kuniyu@google.com>
 <20261029194452.3189365-5-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029194452.3189365-5-kuniyu@google.com>
X-Rspamd-Queue-Id: 8F553100002
X-Rspam-User: 
X-Stat-Signature: chn6yaa6kakx15xfzhrenk3zmy1scm6s
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793303558-142227
X-HE-Meta: U2FsdGVkX1/djGx+6Yaef+nyx8pPEoAYaDf59QfyFVjYQhhlEw3YKgdA6VV6gtKyjJ49DG0upfRfvgfKgcxRKik2sSLaVgmC2xjhGWexNxfYbaKQTyGwKl75VOBgtGe6fdoH4LhCrXWh91IbxWuOXNmow4CCxH46VYcEXhcZGoYi+Ml2UXPc9L9hq0uunJCQ6YL9mSnEZ5f8EyFrW5UBpszfJ7KX4QZ6UP8TayHNauyy4K5nPBusWNo479WWgVXbAXyxnFrvMKWtrvxtetVFmUBEc1KemPWfqmuTCXQmLDdh0bWinxO7Xj+KogrkpXRIlGa7Tz1W7FS9xj5kl/ygCZNicpJf+IgmypiVs0UTAU9QjVi2Q9vLGgb+GPTAGpqQV9cP4s3hbS2+sFXTfqwE5nlWY/cVwTYnbN8T6Lha7GImyfmu3lwSfkl4KIwbH5gL3vJe/TrgcpgVCtG1KsIc7qtgbJ+RAx2cqgnQZ73dI46n8n+7K8eSf5pljiL06k2QDw1uf1xN4I1diBhRhwJmtQxNepBo4n1RRwNNTVOVz5YKPWga2FtGNKaCX7wdPmfIMtMvA6cHpbqDiWOrth5iT8ozlnfj44bSFGUTf/oyTHW+ne0hp6yPJjI3hYgdNja/Pyw4YsLhal9GL4bFKJRw7MUe6WGa0SN4AWUgKsfNhn2hTSL8aNNoX0MLfTo9FmmUMiU0GiSPMX9NYHINpyRI/TlPZqvY7OcajuSaYuPa59/0YJzEm8wy9Y+bs2NrSZFLEzbOC7GsrEfZcUcwp6LkaHK1TW1rlPrsIqnYwO7oIFJSvcS573rUxV4dhDBQgG4oHO3Bf2rALV04t5ACcnmROIJyHMIi+JkuvXa8jPZIYSHodgvvsLdEqK+jwe0ZzgJG28+hPVIZXqhmF7WWsUrFaM0R3yYkk3iGAyos8yogIiNOHJlTylv2SO7hcIKH6CPdTFw2HfGHFSuFoaaV9Ha
 o2/M6Waa
 zVkmbhdbfjlTqWmawE9uvi8brhOjUmWQklTP8yw+2uKyPWn/TrtFE5gHjaOlhdEXiRansSU1e46oDEV0AqpqPsMuZ6xMs3/kLqua7YpSfhTyGuJc3G9dyvHlre2sFxXX2Hq6YtZOsG6bps/oXQN7impteP1cuItQzLVGxHVL7RETab5ggMG+AoIRgN8zca7D5XG716D1l1OyCqIZERJ9s7UFdEbgKEGIe+pfOjH2+aCp/Unz/zfCVpAcy+LNP1x/DUIpiFPsw4V1YwUY9FNlcDWhqqA3618zlv2ubrHVeI0RUPaWqChQ4yIw3wz8doILUzG04mIZtXFSlptq3Z7Nklp58bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 07:44:15PM +0000, Kuniyuki Iwashima wrote:
> On host w/ AMD EPYC 9B45 128-Core Processor (Zen 5 Turin,
> 2 sockets, 512 vCPUs), tcp_rr w/ 20000 flows throughput often
> degrades by ~50%, 32M -> 17M~27M.
> 
> In the bad case, the number of involuntary context switches
> was extremely high by 12x (241733 -> 3093367).
> 
> In perf record, 96% samples had the same pattern, where the
> thread was interrupted during page_counter_uncharge() by softirq,
> and later ksoftirqd was woken up:
> 
>   # perf record -C 0-15 -e sched:sched_wakeup -g \
>       -o /tmp/sched_wakeup.data -- sleep 1
>   # perf report -i /tmp/sched_wakeup.data --stdio --no-children
>     96.36%  tcp_rr   [kernel.kallsyms]  [k] wake_up_process
>             |
>             ---wake_up_process
>                |
>                 --96.00%--irq_exit_rcu
>                           |
>                            --95.82%--sysvec_call_function_single
>                                      asm_sysvec_call_function_single
>                                      |
>                                       --95.58%--page_counter_uncharge
>                                                 mem_cgroup_sk_uncharge
>                                                 sock_rfree
>                                                 tcp_recvmsg
>                                                 __x64_sys_recvfrom
>                                                 do_syscall_64
>                                                 entry_SYSCALL_64_after_hwframe
> 
>   # perf script -i /tmp/sched_wakeup.data | grep -A 20 "comm=ksoftirqd"
>   tcp_rr  101952 [001]  9679.340985: sched:sched_wakeup: comm=ksoftirqd/1 pid=23 prio=120 target_cpu=001
>   	ffffffffb64cd0cc wake_up_process+0xe6c ([kernel.kallsyms])
>   	ffffffffb64cb034 irq_exit_rcu+0x264 ([kernel.kallsyms])
>   	ffffffffb68ad31c sysvec_call_function_single+0xcc ([kernel.kallsyms])
>   	ffffffffb560158a asm_sysvec_call_function_single+0x1a ([kernel.kallsyms])
>   	ffffffffb653c4ce page_counter_uncharge+0x2e ([kernel.kallsyms])
>   	ffffffffb6541b28 mem_cgroup_sk_uncharge+0x3c8 ([kernel.kallsyms])
>   	ffffffffb6561383 sock_rfree+0x83 ([kernel.kallsyms])
>   	ffffffffb6577faf tcp_recvmsg+0x2ff ([kernel.kallsyms])
>   	ffffffffb65604d9 __x64_sys_recvfrom+0x159 ([kernel.kallsyms])
> 
> The problem is that when stock_pages exceeds MEMCG_STOCK_HIGH
> or all slots in struct memcg_stock_pcp are full, refill_stock()
> calls memcg_uncharge() or drain_stock() while holding
> memcg_stock.lock.
> 
> Because local_trylock() only disables preemption and leaves
> interrupts and softirqs enabled, an RPS IPI arriving while
> refill_stock() stalls on page_counter_uncharge() invokes
> NET_RX_SOFTIRQ (process_backlog()) on the same CPU while
> memcg_stock.lock is held.
> 
> Every incoming packet in process_backlog() then fails
> local_trylock() in consume_stock() and falls back to
> try_charge_memcg() and refill_stock(), hammering the global
> page_counter atomic twice per packet, and slow processing
> finally wakes up ksoftirqd.
> 
> Let's move memcg_uncharge() and css_put() outside
> local_unlock(&memcg_stock.lock) in refill_stock().
> 
> With the change, the flakiness disappeared on the 512 vCPU platform.
> 
> In addition, on machine w/ AMD EPYC 7B12 64-Core Processor (Zen 2
> Rome, 2 sockets, 256 vCPU), tcp_rr w/ 10000 flows achieves 36% more
> throughput with lower latency.
> 
>   tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):
> 
>   Metric                     |       Baseline |    Patched |    Diff
>   ---------------------------+----------------+------------+--------
>   Throughput (RPS)           |     20,884,499 | 28,453,051 | +36.24%
>   Latency Mean (us)          |         478.46 |     351.07 | -26.63%
>   Latency p50 (us)           |         453.96 |     343.04 | -24.43%
>   Latency p90 (us)           |         669.00 |     479.57 | -28.32%
>   Latency p99 (us)           |         969.38 |     593.92 | -38.73%
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

