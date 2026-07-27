Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAEF5C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17FC6B00AB; Mon, 27 Jul 2026 10:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA07A6B00AD; Mon, 27 Jul 2026 10:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8FB16B00AE; Mon, 27 Jul 2026 10:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B02646B00AB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:36:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4EA4C4076C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:36:28 +0000 (UTC)
X-FDA: 85034807256.14.F67CAB0
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6097C10000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:36:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="C9iK//vy";
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785162986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSC7HgsrY0npyqxa5DFWKPswHwp4PCTPNe4kvbfpoeM=;
	b=6J2HqytazHR1RPy3vL+cHAOD1YNpQcNRfj+OgKZ3kB4CXzwMwxgtOYxwQdNIxRQ0it21OU
	swHQmfqS/lFC3J8LDFlw8kbkEXYqmzLG4zvccvcbRVnH7/Dq/o1wAiaqbaJYvcG+CB/ExU
	Ez+CEeecPM6ZhwcU/QzwVvkp83MsNqs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785162986;
	b=joOzhP9umqAdN2vh7AkrWxh0f8dM8jc+oFBjrcGA4yuEY2pm4ajo3pEWG83Jsvh8S4AS7Q
	aVlAfhaMNvlA76XNNuXHAatrWBf7WH5Cj8daAq5bavYkdwwMx9kXXlsVw7jdIG58dZpzgr
	IVrrlMOxTNOU7OsP6f2zmtqP1DkR4ak=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="C9iK//vy";
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4955de8797cso17297765e9.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785162985; x=1785767785; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oSC7HgsrY0npyqxa5DFWKPswHwp4PCTPNe4kvbfpoeM=;
        b=C9iK//vyI6qS/FUguyK44nqtGWIsVtTDpY/3LsPhdNLK7HTMgy4Hy57YqxDsGlcPAy
         eSd08w5CeThfpNECWNN37GlD6mGwFfQC0PfyRzP7z+l8Hry7QSuJJnlkEbCuCCMYeEMa
         KjIssHzu/YUtENGfOTOd2aywAW3Vt1bavIoPx6/0obVDrz/kyrGJwMqWI6nzPY44QMdZ
         1AOeTYpCn2TdqBembA3WuYkbJoQrlRy9NgW538zafsN/k7SjFCD6iZmOk0RRasRF5GYy
         u0b0W97O4xRwd8Jk4Rvs0FJyu7JMPt3M68j5dM8KqeWFNbIQ61kmNw1//m6HvxmKOKau
         mGWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785162985; x=1785767785;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oSC7HgsrY0npyqxa5DFWKPswHwp4PCTPNe4kvbfpoeM=;
        b=TxUqcwVz22nHKh8dr9IspAseopPsEiJD5xLJ+uoLJzHQ9xRQdzwEBlpHsJOvMt8N4e
         +hW5oImyiTar+4sdQXy/GUdtcpv2kjCeDcbMXt3Mt3OUTjoEcLZYZJgb3L74RrRCvZ4R
         jtOnDLc8uI+apRaT6ku3xLogNAH+Dv5lE18QgwfeKYZ4RWNPMuQiTU1TL0AwJIJFJKIV
         5M3HI6TeW6PyBuZRArrfjIEG/8AxLD3VWtaoVq2zclaYLyNmfvPyZBMUCgfaBQ0OVcac
         cHNGtRGAHWSiCPSSihTIrFuXBELNLRRCFCyf4OvFlzui8+1Y6Tq3BmmHkv2nDodIopVK
         l8Fg==
X-Forwarded-Encrypted: i=1; AHgh+Rr4DLkMZEImP4EgckWrD3jyizD83roOFafHGY7R7HCJPH66hpxMQ33jJR2PpwE2g3Cwj5ob5Fzhtg==@kvack.org
X-Gm-Message-State: AOJu0Yz5dAfekYOa7H8OqzhEUwsIGI0uGYdTKNkOHnbv0XC16S8tHZMf
	Gy5SoHNkNfbrWaY+U5y9BQFH0hrmXjzcfsxyqhzC8Id2e+3GkRJWUN82GRP770tuDOE=
X-Gm-Gg: AR+sD10UcBGbR1AzRNyA1KjWyHQ7MBDFWx6CypsGY4Y3qPgCG5/nNos83eh3lK7+XkW
	wpDYUQFkz8rZJXA0LQlMxnh21i35hD7MWoQPeokdTY76FBfGUDfP7rzbWAvlMWP3OiL5+FOhU70
	6AuavOs8PzOH5xgak75auDJrwoPwwRgzYseHMlytGVlJP3bGOamePammTJar2uh9IZvSP27HMif
	b1wyY8JDtnuFhhldunxL59ZZGTS7C/TEYrXriHW0PFwwC2l6AfKzu2o0IkniTJfRbHDyxBMSpnD
	GjsrqnUGurh13d9dd7j0vw0/ZT0Pd+rJc5C93B1PWk4e/5hNtTcg9u3S6xpZK/zfqBLpZ1JLqsw
	9DqOXoVYn7iiwCZn8nwB1pivww7C5oigXoAe/KlrXC6sNV24m+PlzCh0qPgDIpObWfXNZsBZ3VC
	WBBW9aj3YBJg==
X-Received: by 2002:a05:600c:a016:b0:495:63e6:5fb8 with SMTP id 5b1f17b1804b1-496b56fa3c4mr111223425e9.12.1785162984790;
        Mon, 27 Jul 2026 07:36:24 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4858e86sm236866125e9.1.2026.07.27.07.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 07:36:24 -0700 (PDT)
Date: Mon, 27 Jul 2026 16:36:23 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <amds50dIVOiQNz0k@tiehlicka>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723001908.4046643-1-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: 6097C10000B
X-Stat-Signature: 7ccy8bconmnpoqmh883o78q3nscr75h7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785162986-26958
X-HE-Meta: U2FsdGVkX1+skwqkMc+rLsi/x2kKYlKpEaXJdnMPVgzY/M0LTg4uIqc7jYrkFr9rb10+VKJL3/Itwv42ANpFnMQxSfFgx63g9mNXcMlkeqKK5eaM0b25tUAYuvghnc3WH2txycd3fnR2JjAcwie1nWyMEXW1BEn1ctn2IU25oKXzNtEl04jxZZTTLspejys85UpD+sR0xdZuutnWz3Tjuc2HJEFOhklBqqMSmYpJ0Tue4pgrWYdVpgmJSWp2wa84w2J79mtmvn/L7uDlamO8aFgrllqGr5yZt32A+h9fRjmFCnjo2+8ia4dFoIj/2S38th21EvMHAPfBDw2ct+i38QlOXMmfdPtJPM7hfg2LD56n8JEYs4VaJ0EzBAKtlrSP8tMAK+u5xuPeD3dv+ifrn3719GmQn6e/r9vIsbPZqRX4E1O5a501yOlHTxfpO7hxPlRR6nWHh6xyqd6VRAne7pt6+Zr/5l4bIMpr0kblkJ0pLS3ROXlRYjMX2kL7TMSbTCbSfCZ7nHSTtdYJa8lBCzaXCBAghzc1O6aMY6cKgsuS959f9leiaMbZTBF9KT6ikujRLKXj5pTkuSw3vMf4J5fyML01CBPxRZEwWI2XpLsniNWVfzQqFEfZxhyW+2S7QLTIyaK6kYJEn+R0QDiyfiPqfSBr2OY0dgS1/f7VdP6+7jtfWpqJFf4zQBxCKwZyj/l+JtKKmxvC76jdSLyh7y5KXtmnFMa31cp2+cXYZr8pHTyzs/sifwxzmGdOPgBwW1rCtGnPMvU9Cfy8PlTZXZvwBgyrz21Uyd7SjU6KxGbdRHZSnntsHPUmRqFi+Ov1C7tioIbaKm0qvC//muJmphxzY1+4ePR6siEMZdRKeuYkzBEUFXJNmiKP0KHr7liDqW13ZPrI2xFj8Dgxyi7sXi8mn5RiE5ppkx6UhXZ8dfahK5yVfQFWDJjahwLcLJuZj0e7u7/AUPrufmfbaXm
 dgcvD0zV
 asX63Kqdrjj/5RBu9BMfjLrxPeQxLWAxqFroJXbIEnOILTtgzsSL4ycwLOtZ7v23Umvq9Egnx5uKdUP0p2YLqzkNgG7Ei1QKKd6S/Cf/UIWk4V8Rq6+EI7CHWC5t2CNaoc966ik5BVLdc8f8MA+ZYtysFP5LamjLuXxgme91XV/pF3ehFYsSMIttonSZiS5lWEFqMCgcUyTD7HB5XxOx7dKmAl+iTDHOTS/iddNczF4FWq5bDuKp4GwbAg+evxlumGCX5H1i1hgssmV+iX5SCEHjTR2k6oKGFJFiWLRj1GfsARmENWL0AkW6uArmlAblTBONuup1IgPu+R3uBBk63seMMnbUgpIvFSw6EibWC99XjexM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 22-07-26 17:19:07, Shakeel Butt wrote:
> At Meta, we are seeing instances where an OOM killed job is stuck in the
> exit path for several hours. In one particular case, the job was stuck
> for more than 8 hours and I had to manually remove the memory.max limits
> to allow the process to exit.
> 
> The job was a single process job and had ~55 GiB memory.max and zswap
> enabled. It had almost 0 anon in memory and ~111 GiB in zswap compressed
> to ~51 GiB zswap pool (i.e. almost all of memory.current was zswap).
> Nothing was left on the LRUs to reclaim.
> 
> On further inspection, I observed ~20k threads of that process stuck
> with the following stack:
> 
> [<0>] mem_cgroup_out_of_memory+0x4e/0xa0
> [<0>] charge_memcg+0x8bf/0x990
> [<0>] mem_cgroup_swapin_charge_folio+0x4e/0x80
> [<0>] __read_swap_cache_async+0x10c/0x260
> [<0>] swapin_readahead+0x116/0x3f0
> [<0>] do_swap_page+0x13c/0x1ce0
> [<0>] handle_mm_fault+0x61d/0x11f0
> [<0>] do_user_addr_fault+0x3e7/0x6d0
> [<0>] exc_page_fault+0x8f/0x110
> [<0>] asm_exc_page_fault+0x22/0x30
> [<0>] __get_user_8+0x14/0x20
> [<0>] futex_cleanup+0x27/0x1c0
> [<0>] futex_exit_release+0x47/0x60
> [<0>] do_exit+0x107/0x940
> [<0>] do_group_exit+0x81/0xa0
> [<0>] get_signal+0x2b1/0x6e0
> [<0>] arch_do_signal_or_restart+0x1a/0x1c0
> [<0>] exit_to_user_mode_loop+0xa8/0x1c0
> [<0>] do_syscall_64+0x152/0x250
> [<0>] entry_SYSCALL_64_after_hwframe+0x4b/0x53
> 
> In addition the dmesg was filled with "Out of memory and no killable
> processes..." messages.
> 
> I have no idea why oom reaper was not able to reap/unmap the process. My
> guess is that since oom reaper tries to acquire mmap_lock in read mode
> limited number of times and then gives up, there might a thread of that
> process which had mmap_lock in write mode at that time.
> 
> My initial suspicion was the futex_cleanup and kernel page fault causing
> infinite fault and charge retries but that was put to rest in previous
> discussions happened on similar problem [1].
> 
> My current theory is that it is just a simple slow serialization behind
> the oom_lock. Unlike page allocator, memcg charge code takes the
> oom_lock without the "try". Though memcg oom code uses
> mutex_lock_killable(),  note that in the call stack get_stack() consumes
> SIGKILL (or sigdelset(SIGKILL)) before calling do_cgroup_exit(). So this
> mutex_lock_killable() is just a mutex_lock() here. Therefore 10s of
> thousands of threads are waiting on oom_lock and one by one they get
> -EFAULT from get_user() in the futex cleanup code and bails out.
> 
> Discussion from [1] lead to the commit a75ffa26122b ("memcg, oom: do not
> bypass oom killer for dying tasks") which routes dying tasks into the OOM
> path precisely so the oom_reaper can reap their mm and free the memory
> asynchronously. But the reaper is best-effort and one-shot: if it cannot
> take mmap_lock for read (e.g. a sibling thread holds it for write) it
> sets MMF_OOM_SKIP and never retries, leaving only the glacial
> oom_lock-serialized synchronous drain.
> 
> Let's short-circuit that path: once reclaim has failed, if current is
> dying, force the charge instead of invoking the OOM killer for it. A
> dying task frees its memory as soon as it finishes exiting, so running
> the (necessarily no-victim) OOM killer for it is pointless - and doing so
> for 10s of thousands of exiting threads is exactly what serializes them
> behind oom_lock. The dying task instead faults its page in, completes
> exit and releases its memory, including the zswap pool, so the memcg
> recovers on its own without the oom_lock serialization and dump_header
> storm.

TBH I am not entirely happy about this approach. It effectivelly reverts
a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
It just makes it lockless. Assumption that a dying task will do so
quickly and with bounded resources has turned wrong on several
occasions.

On the other hand I do undestand the contention issues and I can imagine
that the existing solution doesn't really work well for huge thread
groups that all end up lining up on the oom_lock just to learn there is
nothing really killable anymore because they are the oom victim...

Would it be just safer to bail out only for oom victim threads. This
would narrow down potential runaways for oom victims which should be
more limited than any killed/exiting task. It would also give the oom
killer/reaper chance to work. WDYT?
--- 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..3e0a6b601767 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2685,6 +2685,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (gfp_mask & __GFP_RETRY_MAYFAIL)
 		goto nomem;
 
+	/*
+	 * OOM victim still needs to charge memory to exit. OOM reaper should
+	 * help but it might fail on mmap_lock contention. If the victim is a
+	 * large thread group then all exiting threads might compete on oom_lock
+	 * just to learn that there is nothing really killable anymore. Bail
+	 * out early and force the charge to expedite their exit.
+	 */
+	if (tsk_is_oom_victim(current))
+		goto force
 	/* Avoid endless loop for tasks bypassed by the oom killer */
 	if (passed_oom && task_is_dying())
 		goto nomem;
-- 
Michal Hocko
SUSE Labs

