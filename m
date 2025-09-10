Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB0FCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E4C8E0011; Wed, 10 Sep 2025 11:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D298E0006; Wed, 10 Sep 2025 11:15:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1C358E0011; Wed, 10 Sep 2025 11:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C97C88E0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:15:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90D2711B076
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:15:21 +0000 (UTC)
X-FDA: 83873689242.10.11CE6F9
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4DDD3C0017
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:15:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=M030sYAr;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757517319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mO4BXqgIRoVXuE8zMomfonqu7ftxdJy1svObtMu/mjo=;
	b=Wr/C7rAgDYsTm0lm32T4TAtOqjIf36+wHhTgOFwbjvNizXuT6zBYg393FuM9GvNHzUsR0R
	/MG4P87APdgv2DYN5bYH0OiLHaRiV3q6NR2XMQLABSaqqubzMQ/428jvJF/jOEkKUXcs3G
	UBjNUV8z01M1YtxXM6nVFayZKZFVhiw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=M030sYAr;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757517319; a=rsa-sha256;
	cv=none;
	b=fsJF+XZUAN/THh6rMGtlF9WHe1lYKVTWP0MuaLCnJy4HSkhybTdLfnolV//8AVX6GiaBIs
	pty8yNL0Kt9Z3uFv+bI3kAinjqUHD20AtwaONf9+IKldQrSdOrYvFEzQbA2GeMHvUY0klK
	tg8fbC9JyH/uNv3lOAcb2fEJipNBUQQ=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b079c13240eso62252266b.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757517318; x=1758122118; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mO4BXqgIRoVXuE8zMomfonqu7ftxdJy1svObtMu/mjo=;
        b=M030sYAr7WGTV12E3seqfJmn6hdRq+VD0tUyoV1CgNXrIGUF+G66UpmJXyzndF1W9+
         PfVSdb9lb8F8eA7l43T/zYxVE2kykYsjt63eDi3bmY9Qqy0/A6GBfWEpCfKuT1WiXNbr
         nxRBDiBdElv2AtpnNfu+t54M9d/rraHXibAjWltAiJFbzoaUOVvjP31ZNHrmnAn1X7k6
         p+xryKIBq93ePvScB7lBI0zS4AOnbDY46vyU9p59LRBcEZadMy6nSZx0nRfj5eqq2Cix
         KXN+/8faK9xf3GfbfA9Ij/KIxrxMWTOb0a6yLvHYb6mgJ8Q2eh7bYnf8pvTklnd8kv8P
         fe4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757517318; x=1758122118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mO4BXqgIRoVXuE8zMomfonqu7ftxdJy1svObtMu/mjo=;
        b=e+CpacL9VFfRGEpjgmGYfxJ66LASWnQ5WIn9aOkEF6NmTjyuut9EnBlQfliDTE0DDH
         OLim7mm4DqKh4raNcP2yhZD4ubsxjpGvqGGhk5OMmPtlQzOQ6+t2WHNJ1XVy9D2R/r1A
         mi2W0Tc5fBhFzuajZh5tnSa/qSznubIe72SHkh+2WpL59bO9iXfGEJRPne5I8I+srwwx
         dcO2B4PhzEughP5pL+F/GlzT64vpt+4KUJVfSdLlicx+zNwYkxwW+VeQzSoS7g47FHxH
         PQLmBBW1yZ+kH5XlMQMZdBGQvUvEOtDt+o2qfeRNtCafhUlyNgnqXFX59CEpZcxQTL5P
         jEPg==
X-Forwarded-Encrypted: i=1; AJvYcCVZBPOWFWBPLsN0rXjyr5smYaRbiCogOKeG3R0UMgUo8qP3ePEaKoZXtIOJk9BKMZ/X8jHOfT9q6A==@kvack.org
X-Gm-Message-State: AOJu0YxdpONNGOBI/Qv1BMZvS/v+jJAghYMy6tBwWznmZ5sOw4KbRh+h
	w6BoFPIFJD6lzrTfY5ANYghLCMgxo5BPWvpNAKF4qluurDl47Bhf47AYbL3++POxyfI=
X-Gm-Gg: ASbGncuKnXs+rqNtGkF6x4yVreiZrK1pX2o6uLItDgKp1uKyvqD+3qKpCqMfHmDyh/3
	1+CCBk8rlLWhQSFheyfGbNuszOZ7q2fZa4Qb4ecYnt/HHAPrN0JFiSUEWCUhmZx58cGwsTG2+RF
	Dn0x6OsgErQgzbyNsXq95jOT303Y4lNnzdIg2UQtFWrG8WWh1NXCetdvdPDon0g7nJhcoRxSN4g
	MbrYTSK/CAhKAl943hrecHJv3J0yjDWq0q6lQMgde73zF4sh+zq+27tk0HzZJ1SZMO+AMxADdJl
	CEeVlcC1CI3oRUsmKWvxln/H+mmOySSVeMGhyvaOrUG0zsIi5DBS/0g1UPJ3dpPUNVsfGux31P8
	MMVLgMeEEpxmnvcMguQ4iY/jdTMdYakpl1Q==
X-Google-Smtp-Source: AGHT+IFL0J4ew5U+5dXo6aHE9wyYqH4CItTcJJ1lajrP0Q5QwvYyOBbSzJdZxQClKY9ffOUW1Ole4w==
X-Received: by 2002:a17:907:d91:b0:b04:626e:f43d with SMTP id a640c23a62f3a-b04b167b9f2mr1217252166b.47.1757517317226;
        Wed, 10 Sep 2025 08:15:17 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b0783047123sm182588966b.14.2025.09.10.08.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 08:15:16 -0700 (PDT)
Date: Wed, 10 Sep 2025 17:15:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	tglx@linutronix.de, liam.howlett@oracle.com,
	lorenzo.stoakes@oracle.com, surenb@google.com, lenb@kernel.org,
	rafael@kernel.org, pavel@kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v9 1/2] mm/oom_kill: Thaw the entire OOM victim process
Message-ID: <aMGWAg5jIitYCXdZ@tiehlicka>
References: <20250910143726.19905-1-zhongjinji@honor.com>
 <20250910143726.19905-2-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910143726.19905-2-zhongjinji@honor.com>
X-Rspamd-Queue-Id: 4DDD3C0017
X-Stat-Signature: fgsm9ejaae7si7x8gon7ybwnggpbb1wi
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757517319-213745
X-HE-Meta: U2FsdGVkX18bi5vLJqzp96vMD9JO4tOr/gMc7Sp7iNv8zxbLeum8gTWrg3foCDGHNPQ6iMzHTfSLlM32CHqFfnnEGMhyTt0SmuVVsfE14Mxiaiy0KTSBQvRKbbaLgaNhqsTOS8Is/9Rowh45E+fJIwZMkZm7G5Fi8wcjOuPd3+xjSAFJutwBEoAvYVegQnKFxKdRt5QGWn3P1d4b5/I3j3kbOTnvdstNJfcl3MUS7cJLIqn9NW1ILtbWoZsypyaG+FPpgUP+yBT3/pTktz6dgp+vKIGUjrpJ0PC0WSEkTRAyD5F8KevuQgEfTGrs0GmO4RxMfPVjNA7lZOYiz1kRaib8nLd1CMq0gszyjW8erBgwAHpeAVUGLt4uH+1iMD6JLvcEdsQnSlDuO54L6UI7IqrVlZ3gUaArgVk3ClJ+dZGKm7WB1IaYfwZM4SNIOWp7u+DE2oW3bRXh+uwG2jg4V0R4n99K59AC8G40OOMPWvFUnMrwCox4IVbCarPwOnNxA+5Ngw27J889Bp/BHNR/KyhqsLzsopXL7wFNzBnWswTqYigZar0y/ohOdQY317DqtjrPNPEBJG3UctfSxqhWDG9UYPPegxDgldmLqMz3TJeU3xf4taywwBheOK5qSV3K5UhYjkZQzR0ksRFns4yOvqKepQQAF5L7D6hC+53iiVVDJuNbicH1HPFBweNCIuzrEaF6WPI1hcyLypYXWDlq3qxfLmJAnOzOlIAFQJ6pQivNpoby6uCJoVeisEDf7cJxwuwvUFNeoWG6kL7wDyy+sXAbw1sh10eXOjjYPq5h2fLmH28se0ADJTLqke/qYJNYaZzdIJbi3C7WUAYsJlBEQ22/Dixkc25i9U4fs9m7Ax9RnMCrz+9VqsmbCTZ1MJKueFmJMDRuSCiHRm10RIBuA0FxxnlFWixqk0/YfQ6MqiGD21f3Bc51wGZq17f9Hv2octniBzfMb4lmI6ZEnNz
 EU/m0Aca
 r7aAGcpyLyJfft5jjay2MmfD3OU+/Y5T+qi95JbVezOzunlzzPTt5vRYT/WVY+IFYgzt05cVwuEDBKaryLOFMXt6qWAJ6/DfoD2ksOnfkHnqqcSEA0GbIo/0UF5s9a+gyXeOjaIqaIE+qKQlrbJAMKZKhpODeQOz8II63z7fwIeTZl1zKASR9JP8CsRPK1i19bqkZ4mhKEHyNfLNRDEyfJLG9loO4GSgDQc+JRWFxCTOnuaMZAxoZ9iOTx0dqQkkL6HJb1p0J3MmXiojc/AulcshLzCoKZf9TUXkqWC4ElX3b6gCnny1s5vcT+nRwimSdvboaJOUrjJJckmf8A9fG/YiiIoAQWE7LhVt1lNsenmqzdIw4ARevryV/LDdDgbaacu+o627z1RyawXM7rSJCdpXWovPBCYLr6Eumh879J+HP4s4Slzxc2YW/+SgpuLFMtzNBwRuPbnBst+mg01Uteu54sNodcM4MDcstaTIvtA2Qtoeljg8py8wcKUNFJohxUR57M4RILLUCDpw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 10-09-25 22:37:25, zhongjinji wrote:
> OOM killer is a mechanism that selects and kills processes when the system
> runs out of memory to reclaim resources and keep the system stable. But the
> oom victim cannot terminate on its own when it is frozen, even if the OOM
> victim task is thawed through __thaw_task(). This is because __thaw_task() can
> only thaw a single OOM victim thread, and cannot thaw the entire OOM victim
> process.
> 
> Also, freezing_slow_path() decides whether a task is an OOM victim by checking
> the task's TIF_MEMDIE flag. When a task is thawed, the freezer bypasses PM
> freezing and cgroup freezing states to thaw it. But TIF_MEMDIE is not a thread
> group shared flag, and only one thread is marked with TIF_MEMDIE. If other
> threads are thawed, they may still remain frozen due to PM freezing and cgroup
> freezing states.
> 
> To solve this, thaw_process() is introduced to thaw all threads of the victim,
> ensuring every thread in the victim process can be thawed. The freezer uses
> tsk_is_oom_victim() to determine whether a task is an OOM victim, because
> tsk->signal->oom_mm is data shared by all threads. This allows all victim threads
> to rely on it to be thawed.

A history detour for future reference.
TIF_MEMDIE was a "this is the oom victim & it has access to memory
reserves" flag in the past. It has that thread vs. process problems and
tsk_is_oom_victim was introduced later to get rid of them and other
issues as well as the guarantee that we can identify the oom victim's mm reliably 
for other oom_reaper. I recommend reading git log of mm/oom_kill.c to
get hairy history of that area and how tricky it is due all the subtle
interaction with process exit paths etc.

> 
> This change will thaw the entire victim process when OOM occurs,
> ensuring that the oom victim can terminate on its own.
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> ---
>  include/linux/freezer.h |  2 ++
>  kernel/freezer.c        | 20 +++++++++++++++++++-
>  mm/oom_kill.c           | 10 +++++-----
>  3 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index b303472255be..32884c9721e5 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -47,6 +47,7 @@ extern int freeze_processes(void);
>  extern int freeze_kernel_threads(void);
>  extern void thaw_processes(void);
>  extern void thaw_kernel_threads(void);
> +extern void thaw_process(struct task_struct *p);
>  
>  static inline bool try_to_freeze(void)
>  {
> @@ -80,6 +81,7 @@ static inline int freeze_processes(void) { return -ENOSYS; }
>  static inline int freeze_kernel_threads(void) { return -ENOSYS; }
>  static inline void thaw_processes(void) {}
>  static inline void thaw_kernel_threads(void) {}
> +static inline void thaw_process(struct task_struct *p) {}
>  
>  static inline bool try_to_freeze(void) { return false; }
>  
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index 6a96149aede9..ddc11a8bd2ea 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -10,6 +10,7 @@
>  #include <linux/export.h>
>  #include <linux/syscalls.h>
>  #include <linux/freezer.h>
> +#include <linux/oom.h>
>  #include <linux/kthread.h>
>  
>  /* total number of freezing conditions in effect */
> @@ -40,7 +41,7 @@ bool freezing_slow_path(struct task_struct *p)
>  	if (p->flags & (PF_NOFREEZE | PF_SUSPEND_TASK))
>  		return false;
>  
> -	if (test_tsk_thread_flag(p, TIF_MEMDIE))
> +	if (tsk_is_oom_victim(p))
>  		return false;
>  
>  	if (pm_nosig_freezing || cgroup_freezing(p))
> @@ -206,6 +207,23 @@ void __thaw_task(struct task_struct *p)
>  		wake_up_state(p, TASK_FROZEN);
>  }
>  
> +/*
> + * thaw_process - Thaw a frozen process
> + * @p: the process to be thawed
> + *
> + * Iterate over all threads of @p and call __thaw_task() on each.
> + */
> +void thaw_process(struct task_struct *p)
> +{
> +	struct task_struct *t;
> +
> +	rcu_read_lock();
> +	for_each_thread(p, t) {
> +		__thaw_task(t);
> +	}
> +	rcu_read_unlock();
> +}
> +
>  /**
>   * set_freezable - make %current freezable
>   *
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..88356b66cc35 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -772,12 +772,12 @@ static void mark_oom_victim(struct task_struct *tsk)
>  		mmgrab(tsk->signal->oom_mm);
>  
>  	/*
> -	 * Make sure that the task is woken up from uninterruptible sleep
> -	 * if it is frozen because OOM killer wouldn't be able to free
> -	 * any memory and livelock. freezing_slow_path will tell the freezer
> -	 * that TIF_MEMDIE tasks should be ignored.
> +	 * Make sure that the process is woken up from uninterruptible sleep
> +	 * if it is frozen because OOM killer wouldn't be able to free any
> +	 * memory and livelock. The freezer will thaw the tasks that are OOM
> +	 * victims regardless of the PM freezing and cgroup freezing states.
>  	 */
> -	__thaw_task(tsk);
> +	thaw_process(tsk);
>  	atomic_inc(&oom_victims);
>  	cred = get_task_cred(tsk);
>  	trace_mark_victim(tsk, cred->uid.val);
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs

