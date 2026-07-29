Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9909EC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 02:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1582B6B0088; Tue, 28 Jul 2026 22:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1099F6B008A; Tue, 28 Jul 2026 22:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39956B008C; Tue, 28 Jul 2026 22:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFBDB6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:46:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5597A1205AC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:46:23 +0000 (UTC)
X-FDA: 85040275446.09.3A294CA
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5BBEA80005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:46:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PUh4jrLR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785293181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sZtuESiuIRQ4N1of0slvw0/N5xfIAJFkwfNnHgaMXeU=;
	b=ztN31NJMPpCN2TGa/z4nQzNxfhJZAPrdeFOA2aUZFq/hpjHvdkXlGbIZJh5HVeX133e6lx
	YYj7/8zOt/c0eetYFLVfIXE4Io7fNkKLM89tPNfqyhjrcSL6+8Z18QtE+N9kZew5VYKuHq
	UKPJeg3HEXU56PGX6YE4ogn/8QM0//g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PUh4jrLR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785293181;
	b=WZxW84eIKyhGqav80Ifm4aw/qVOFU/BccL2dRdMBGLcF7JVsNjVRT80zmoZ8nzVFBqRR/2
	znZJRQ9mkJKf37DChuZi8PlzUjOD1rGiY7pD0FLMxEB5ztdgDBODoexViCznMcdlPZBlb2
	gxYtA9VlE+oEnUFiTv6SyohoMwGsgz0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785293179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sZtuESiuIRQ4N1of0slvw0/N5xfIAJFkwfNnHgaMXeU=;
	b=PUh4jrLROnXPX+AwgvxhBFx58YU7jD8d+FVTou3nxGLGiqnd0jYlEDmF0IPJdTVqkayzAN
	r0Y+rKHNlFQp/lehNuVyav+g99DgkYMnTBQy8uj60Fokxc1HPk/8dGlCh0X0iHnjDo4fNt
	bM7eX/+GI7YnQWLOBloryPu6SSIYxio=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] memcg: bypass the reclaim and oom killer for dying tasks once oom_reaper is done
Date: Tue, 28 Jul 2026 19:46:12 -0700
Message-ID: <20260729024612.3369005-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5BBEA80005
X-Rspam-User: 
X-Stat-Signature: mdwt38z763z79xbds8roscn7xnhuoc1m
X-HE-Tag: 1785293181-828890
X-HE-Meta: U2FsdGVkX18eoNI+f9+0RjY/c/d8w6Mow3oGlu3iAqcJEjyBIwwFE69bbUw+v9yhdLZGqovcCy4TbwHbiTvnbtYtLFmnt8hxffNJVSgVvjslDPfzMFwED0rE2KXkePYXB3FVozj4VCz8/yDNxajHnsL7rEcxFtQEbXFU0ezRebS47jmdh4RSshO8sWFPc9Y/oab090al41DfQABhpls3iJUASA+1juGgnwYZzruE1dqkknyGXzEuPXkuGsKLf91kt/SNhQjxFKkfkeoQJwevWDylzQe51a+uJO8ktRFblAX4uC3g5ScZMMuMwTOBOe+yXWKgzKfI8bErOuez22BHJM0wFxfj1APMrZZam3r2en7zp5/c56IuyjHRJF1P5q5+abN7n9J1ip4X9mKeTOOTkM8NfXufj4GD4o9x6XnpsauyN7kiM3FGz/FqgRKbJIy7e5I/+WjChLwIr+31vmhqk7H0hyV6N2Ha64mlsvU0xcbpvPSuDjBMGrhFPumT9ZT1DE1J8rhFa2j4WRwrdmOGZ9JZOT3JT5jpBMQjvLu0PJJeJucgc2vO9wlr3vLKAY1OJlsRX8un4XgKw1Xu79oBw5Qcwuje0AUxpOBmpv5INqc0yofh3vRQuYnwPVnKR4/gsRm+3tbb2KWfIeXlZLqn6QVP1JgsgagPZ/bRQb1NlHrX5ZG3oFXomw+HPHGUbDBbtnR4FfZJ0M4vpr7yJQCuH8eS/A5e4Nh8sPW4CZ/o2YVP47l39haC2v/uTXtoRLJyIVgfRd7f0H24WABUnXafVwcDj154SEZxZrJPwLVc8NaQM7L0O7ZtyJ5sA+FTKn4h15yUU0EQL45u6T66K6+aqX8CgWGGp/ep7dOzqGp5DARgExBBzji+LLGRKRjr2ryNs8x4wzCiZw5f0bXqDr5AoUQoog5zf0v5pNXz9icRL47So2RQ7fRXHO9/7y1peWUyRRXnTgjgL3Ldpoea56P
 vtVJ2vfv
 p07EhXXjRVdn0X2MN8SztrhZrDuR79MXZDSMBxYyXDB1RD/cCUNRTqGkJgUuKMlGko2zlvb6bjmKKePlhCXlKvqcxQhzYrL3V+2YQgUIb96JXpnHauuyXJRhsHxvGzZBoDtzZVEehmLDswHgH3n0amChKl0vCLZudmw71ukqhWviDFWN2dcLijKZk4jGmcTUXWeMueWtdJTUCMRWPHbJzpZFAB63alausoicVYawzMbZS2Y3uvi/V8d0yfmMmhTL95TiZq7Jt3crs20P0YONxt2CxAgqvxU9/e/laXBpvA5BM/l6lL0pdB7WUAhNoiXBJN7IHpT5Lwj8Jv9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At Meta, we are seeing instances where an OOM killed job is stuck in the
exit path for several hours. In one particular case, the job was stuck
for more than 8 hours and I had to manually remove the memory.max limits
to allow the process to exit.

The job was a single process job and had ~55 GiB memory.max and zswap
enabled. It had almost 0 anon in memory and ~111 GiB in zswap compressed
to ~51 GiB zswap pool (i.e. almost all of memory.current was zswap).
Nothing was left on the LRUs to reclaim.

On further inspection, I observed ~20k threads of that process stuck
with the following stack:

[<0>] mem_cgroup_out_of_memory+0x4e/0xa0
[<0>] charge_memcg+0x8bf/0x990
[<0>] mem_cgroup_swapin_charge_folio+0x4e/0x80
[<0>] __read_swap_cache_async+0x10c/0x260
[<0>] swapin_readahead+0x116/0x3f0
[<0>] do_swap_page+0x13c/0x1ce0
[<0>] handle_mm_fault+0x61d/0x11f0
[<0>] do_user_addr_fault+0x3e7/0x6d0
[<0>] exc_page_fault+0x8f/0x110
[<0>] asm_exc_page_fault+0x22/0x30
[<0>] __get_user_8+0x14/0x20
[<0>] futex_cleanup+0x27/0x1c0
[<0>] futex_exit_release+0x47/0x60
[<0>] do_exit+0x107/0x940
[<0>] do_group_exit+0x81/0xa0
[<0>] get_signal+0x2b1/0x6e0
[<0>] arch_do_signal_or_restart+0x1a/0x1c0
[<0>] exit_to_user_mode_loop+0xa8/0x1c0
[<0>] do_syscall_64+0x152/0x250
[<0>] entry_SYSCALL_64_after_hwframe+0x4b/0x53

In addition the dmesg was filled with "Out of memory and no killable
processes..." messages.

I have no idea why oom reaper was not able to reap/unmap the process. My
guess is that since oom reaper tries to acquire mmap_lock in read mode
limited number of times and then gives up, there might be a thread of
that process which had mmap_lock in write mode at that time.

My initial suspicion was the futex_cleanup and kernel page fault causing
infinite fault and charge retries but that was put to rest in previous
discussions happened on similar problem [1].

My current theory is that it is just a simple slow serialization behind
the oom_lock. Unlike page allocator, memcg charge code takes the
oom_lock without the "try". Though memcg oom code uses
mutex_lock_killable(), note that in the call stack get_signal() consumes
SIGKILL (or sigdelset(SIGKILL)) before calling do_group_exit(). So this
mutex_lock_killable() is just a mutex_lock() here. Therefore 10s of
thousands of threads are waiting on oom_lock and one by one they get
-EFAULT from get_user() in the futex cleanup code and bails out.

Discussion from [1] lead to the commit a75ffa26122b ("memcg, oom: do not
bypass oom killer for dying tasks") which routes dying tasks into the OOM
path precisely so the oom_reaper can reap their mm and free the memory
asynchronously. But the reaper is best-effort and one-shot: if it cannot
take mmap_lock for read (e.g. a sibling thread holds it for write) it
sets MMF_OOM_SKIP and never retries, leaving only the glacial
oom_lock-serialized synchronous drain.

Once MMF_OOM_SKIP is set there is no more asynchronous reclaim coming for
the mm, so a dying task charging against it has nothing left to wait for:
it frees its memory only once it finishes exiting. Running reclaim and the
(no-victim) OOM killer for it is then pointless, and doing it for 10s of
thousands of exiting threads is what serializes them behind oom_lock. So
before reclaim, if current is an OOM victim whose reaper is done, fail the
charge.

Reproduced with 20k threads, each parking a robust futex head on
its own zswapped page, OOM-group-killed while a sibling holds mmap_lock
for write so the reaper gives up and sets MMF_OOM_SKIP. Tested on
next-20260728 and baseline show ~90 seconds exit time while with the
patch the exit time reduced to ~3 seconds.

Link: https://lore.kernel.org/7a4e5591f45df455e6a485fc5400989569d3d22d.camel@surriel.com/ [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23..f7a5f8a6cfee 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2653,6 +2653,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
+	/*
+	 * OOM victim still needs to charge memory to exit. OOM reaper should
+	 * help but it might fail on mmap_lock contention. If the victim is a
+	 * large thread group then all exiting threads might compete on oom_lock
+	 * just to learn that there is nothing really killable anymore. Bail
+	 * out early and fail the charge to expedite their exit. They are
+	 * considered fully reclaimed by the oom reaper and they shouldn't
+	 * contribute further charges.
+	 */
+	if (tsk_is_oom_victim(current) &&
+	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
+		goto nomem;
+
 	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 	raised_max_event = true;
 
-- 
2.53.0-Meta


