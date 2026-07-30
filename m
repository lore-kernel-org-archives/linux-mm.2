Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2248C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88D06B008C; Thu, 30 Jul 2026 02:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38816B0092; Thu, 30 Jul 2026 02:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27EE6B0093; Thu, 30 Jul 2026 02:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74F106B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:57:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13E901608DE
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:57:50 +0000 (UTC)
X-FDA: 85044537900.04.FFF844A
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id DF6CA1C0006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:57:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=c80jw6qk;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785394668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GxtdDx0vobVNpbZd99PS3VLnLhCu/f+aaBy6tly+S4=;
	b=eNBDmbaf934Ksw2208v9mdzUDGhew8jLoTuD9QiBbD9Cvk1v7Aurn1lPv5lFf2mvEwXznl
	4RdeK3WfX2RLiJ6qv+JKCCN5OxBrpEP/9/YaRjtpC1WJOMkpDU6ED0Cr6yCsx1PGePq1BB
	vS+yRT5HbSu7yghe4ivMdb4h6Cyx1Q0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=c80jw6qk;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785394668;
	b=XsWifg/y1iiumkHQtxJJCEOM+FRCGQgcQWIIKT4cPt/CgQz6XXpemjdMeUsgeQm5AgBYHt
	yR//wdGkDOcUw/E8FS4psd/0ZrbNXgCEnUhCapX9dKGusLBppba+idu+5F6VQu4XZkhVxe
	KR+DIhUFsuLnqmG3IJHQ1NzjBnITAy0=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49557167508so14891335e9.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785394666; x=1785999466; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1GxtdDx0vobVNpbZd99PS3VLnLhCu/f+aaBy6tly+S4=;
        b=c80jw6qksigBOMA0ilr5xjb8/WJC0HRo6fk7540souR6OujPTjfPqwfS2QUe6uAh2h
         Tydkf5QGfcA36WU2tySJ4w+hULEfJgzaeucSEaRDZ7c1ggE3PLhZCPvCXTzeauR4kxcW
         7VSjShbMm6je4RANRhe7vCBg+m47/+sK3+WpEDTvcNqxjrdOjgPNxPUO/FX5RV8S7mf9
         X757h8CXdPnQ2ovCgQVlfWcqC8pfPpd6p43AXy8H11DN5gy5GTDSyNfgTaLaNCfgZzcL
         3OAyXuWi2qs1c0p/hZzqS80zF6rWOMKUiWt2EnNxJU39nPU0795In+Qq8MBuw9p6l/PR
         faUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394666; x=1785999466;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1GxtdDx0vobVNpbZd99PS3VLnLhCu/f+aaBy6tly+S4=;
        b=pWKGCYULq1BIwJZywhhgB25UYDV4dQki14CjZ9QSPJV0RlSDc8PXT2/1hr+65Vdgue
         fZpUUN1mHFa47u3Wlif+ZAtFTe8aMnRuXhCxtlYi3ZAYy/D9t1OkCpezphWLyKuXOj8V
         ZOEOSwt6bfW/g4ktVKdaFj+kg/W1qWh88lXDumq/ApAzlLgQI8stujTOTcInYdasPbo1
         hDBUKZHHQWLjxf7C6S1KU5kA1RYa4l8n95Pnhx67bv5/hxB6/VjIo9En7i8Ff7fKHFfO
         7uEhmH5/jiwuskWN7MNFisj9Dcq8lQRAwZ/vzpunf58oAAueDQAxgil3a1DcKKhLpSX6
         ms1g==
X-Forwarded-Encrypted: i=1; AHgh+RpGHsxrFbDjjn2EABSlHbZNCQ1Uza+wStu0r3OXapua+CtBfEyWevK6WGA3g1ernLjlYH7wAB5E8g==@kvack.org
X-Gm-Message-State: AOJu0YxtPhKsuCe6QoX+CXcfsk4XM+Pnng0H2Ty9PxAxsOs9qcX63oNQ
	MCbk7G79NvFk/ONPzD9MBQs2fwfGRCa5beyJ3OV28LuADpbHMQ73/8YmdAAokI9KD8g=
X-Gm-Gg: AR+sD101mDTtIhlY+KJSC4t4z8xvZppiyVRh1bIjLDlF5CN1/4P/xzv/C3XVAgYorX1
	lvNYu5f7472Fb5SiATMqBRZ4fhz9pCLLBMQ4qt4PCW+ccUlcDOTTpAqHO3ihYEwRp4T+LIqHFVY
	tmZJ9wPNWKJN07mTcSz0T3yGKSCI+VfALl1qpR0w5OpL8UAoNbYUwOfWi7ZnD1p7iQRHrHEh1mA
	NmuCam8B2vPqcDuNuhVwmD6/uOCcp2M56uEwbH7AKDvHHOtXHr7vx6MWFUy+dLZep+w991G0C6g
	f5z/dC719nLreJjZdTdACwgNL+xseik24lS5OgDA5oilL/UpbEC8xR6u8YqNUD1jOd5SYtU0jix
	XnSkCvN5KkwsHzjMmr7N0muKkvxqyQbIyGZq19T3z5gbhyr4cK0SOy6IbDotgqTzv+/SswYgMwC
	YljJYp5xcuyO3LgamTbw4GBmcISNwWsc1WJuL8BeLsZXxIMXhDq/XjWB7YxSVyUYvbZw1tQGTOT
	BM8HaogagNde95TEAE=
X-Received: by 2002:a05:600c:55d8:b0:492:4a50:41fe with SMTP id 5b1f17b1804b1-49800ebf6c6mr10549755e9.22.1785394666265;
        Wed, 29 Jul 2026 23:57:46 -0700 (PDT)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49764d848edsm113990275e9.4.2026.07.29.23.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:57:45 -0700 (PDT)
Date: Thu, 30 Jul 2026 08:57:44 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>, Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: bypass the reclaim and oom killer for dying tasks
 once oom_reaper is done
Message-ID: <amr16BmkkidgRolL@tiehlicka>
References: <20260729024612.3369005-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729024612.3369005-1-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DF6CA1C0006
X-Stat-Signature: fd8oknax3wwa9dm6fxw9pg88f4bc9hza
X-HE-Tag: 1785394667-69226
X-HE-Meta: U2FsdGVkX18nIJXFkxauxrde43SgZxrMR6+iF3MXn/o7uLqpocGKC/J50Aou9p5aEGc7l0XDsJBSZ3FVJ80URA6VXSksNfw7AFxfER1sElixVMi85L7pr/aamnvywe1CNVEb0naQLSA1IdhqaRsmNKnR+5It9IL9V+fqu9XK8eBk+eOV3gST0UZ1gyDDZAJXrPCIrRqDETPNZKq2nbtsD5gDCejM3GNJHjKHm1WytNXwtUUeJbDvaB2BlBFcaiMp3mnWj+bo4vwJZgXPaqJna+K+0Utb/9ehYt1rGZ4f5Z0ifWC0bJ/s/FBwsnYGtaBV3xFTVgucc2VjfcaPI4+aR93PD1YcJerbTF9cWWzsAK5Qbn9s8JzK3wpmTNGxTW5yFUXsVTWlQywaCS6bfX+WhbTC+q89oUHTRXJZqn29ImSQvgMntw0ZucpTobeEf234HO9bAhFwjkMGEkX2enRzbU6+6ekDq/bHOeKE2fM6dYqwFcy26ahbrkmjJ7EpUCnCRwAEL6+ZIjY/q+PKb5/kWrYnGAbsArDknEHqbfzPcDLHLr5S6dkpg35HBl5vU4uXMPP7pWpYgyRcAqPDBvjyF2k9wc2mjMdtGuSCucXUjbHvhKHM/2ER7Qn48KzkgCj9Ye8YmHD2SoTSQdT3ajSjLyAEl096RuTGFwF/94u7EJwO7PJD7pkxexVHfQh7XlDHtKJhjH2GqPiRylsOqsSjhZZ533OZ9DIZEjKcYgkMdi56kA47Hlx/TMCSDJLc5PKUhUN4yXj4wxiptDqxLEmJ+8vTBeDMK5pYscAdeyrkx+0oT0pLxCa1spGBhjOcpipQS4cMasmpgty6JtO6ECkCxLJVc1g1WSt9iSUvde3etSsXBsuBpChErZ6fBXzl++tTtDRD9jzJXTHIqhgo5XGHk3TgVdm/DSLeoQG42M37qGKB2C+VXlLqnX4g5FbfWOrsLMVrloBwA3p0uLCpPdL
 VA2Q92kO
 WJi+KcdzhpOQxDqjsIwJn0VF10OUMK0fDe2oQEWfVEjFFeRyQ9cFcrWAHAC9+RJxpHxVeDOCuytw/0lPDjtxFpECh5VppjAAQi4/qg4s6Gg9q+zUzCjmFpK0ZFBZJCEoztx8t8BGZQVxa9kKdytQEjTBkgnATk3hN2WohKfb/jPqi/FjN4VkYuloJ1F3JKkYz9oND9PBX+ucvqJgc1akHQFk61oXGc5TlNzm29iC7F6YEZ846GtL3lDmxoeQ5VJI9m+hPzpBTrm9u+xEKC3k1l2Xq82EFjIdGLbBZV0xmxh0UK9NyTfIZODMvytbeEQfaF/tnSITJWYoIAkMei2fBuiv8L97/VVrRWXO0ZZVCDKXbcmxoB18qtrAvZ56zBvVKo2lnn1JfpWoCJXFhG6ahAguNAxo9oSaT6Zs2NbjMFr4nLPcfHy0LFkzHzNu3+w0VbiJDn9mIZeBZaxyhELK/CKI4mkMhVhN2Iyzw73Q4KH93PR1arEqHWN7gOAxrQ/DuZkwJua6OnaXWkKQZEalrLNehSmem7jENA907LS/mAHjBaVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 28-07-26 19:46:12, Shakeel Butt wrote:
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
> limited number of times and then gives up, there might be a thread of
> that process which had mmap_lock in write mode at that time.
> 
> My initial suspicion was the futex_cleanup and kernel page fault causing
> infinite fault and charge retries but that was put to rest in previous
> discussions happened on similar problem [1].
> 
> My current theory is that it is just a simple slow serialization behind
> the oom_lock. Unlike page allocator, memcg charge code takes the
> oom_lock without the "try". Though memcg oom code uses
> mutex_lock_killable(), note that in the call stack get_signal() consumes
> SIGKILL (or sigdelset(SIGKILL)) before calling do_group_exit(). So this
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
> Once MMF_OOM_SKIP is set there is no more asynchronous reclaim coming for
> the mm, so a dying task charging against it has nothing left to wait for:
> it frees its memory only once it finishes exiting. Running reclaim and the
> (no-victim) OOM killer for it is then pointless, and doing it for 10s of
> thousands of exiting threads is what serializes them behind oom_lock. So
> before reclaim, if current is an OOM victim whose reaper is done, fail the
> charge.
> 
> Reproduced with 20k threads, each parking a robust futex head on
> its own zswapped page, OOM-group-killed while a sibling holds mmap_lock
> for write so the reaper gives up and sets MMF_OOM_SKIP. Tested on
> next-20260728 and baseline show ~90 seconds exit time while with the
> patch the exit time reduced to ~3 seconds.
> 
> Link: https://lore.kernel.org/7a4e5591f45df455e6a485fc5400989569d3d22d.camel@surriel.com/ [1]
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks

> ---
>  mm/memcontrol.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8319ad8c5c23..f7a5f8a6cfee 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2653,6 +2653,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!gfpflags_allow_blocking(gfp_mask))
>  		goto nomem;
>  
> +	/*
> +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> +	 * help but it might fail on mmap_lock contention. If the victim is a
> +	 * large thread group then all exiting threads might compete on oom_lock
> +	 * just to learn that there is nothing really killable anymore. Bail
> +	 * out early and fail the charge to expedite their exit. They are
> +	 * considered fully reclaimed by the oom reaper and they shouldn't
> +	 * contribute further charges.
> +	 */
> +	if (tsk_is_oom_victim(current) &&
> +	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
> +		goto nomem;
> +
>  	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
>  	raised_max_event = true;
>  
> -- 
> 2.53.0-Meta
> 

-- 
Michal Hocko
SUSE Labs

