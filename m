Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82303C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 06:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C3176B007B; Mon,  4 Aug 2025 02:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074026B0088; Mon,  4 Aug 2025 02:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4CD6B0089; Mon,  4 Aug 2025 02:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAF1B6B007B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 02:04:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59895C0E15
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 06:04:35 +0000 (UTC)
X-FDA: 83738035710.30.6240EEF
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf19.hostedemail.com (Postfix) with ESMTP id 68D1C1A000F
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 06:04:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Q0J2ByAb;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754287473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSRLbZH+ywoLvwHXORH5c+0524CP0mry4togVdem3jU=;
	b=aw4Sh3Y1O40/SYP8if9H3HaWgVhqUY64tvP3GkTTGOzQVbXHAPyvs+vOurFQ+ZZWetcx8d
	nyx3y+7ybtD2t1eIY2SHoPgJr/onH1bvGlu2B53oQbCCPKHjOHszmGVd0+6Y8m9mrs1dSi
	fZqKzlzi6o4Sbw61mi55zCMwe0or7P4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Q0J2ByAb;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754287473; a=rsa-sha256;
	cv=none;
	b=1VCDfuKbOU8pDNrSUJLcSC0CfLUMGDRQbA68s6i1ETQ06MAXgyDoHnBygQ24TuI3G52DnD
	5mo3oQRwF9C63Y4x1pGjYpoSL8C0wpRP6YDaIPTw9oBEul0Ic6mAxWInaNo33ab5MgI3kh
	8AqRLmswCLJW8oMI+UnBnv6Ji1pJ93g=
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-4538bc52a8dso23807895e9.2
        for <linux-mm@kvack.org>; Sun, 03 Aug 2025 23:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754287472; x=1754892272; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zSRLbZH+ywoLvwHXORH5c+0524CP0mry4togVdem3jU=;
        b=Q0J2ByAbns0hQJ4JZH/JpcFV6lFLG1lPOwO328gL++N7mMvYBdUSQsMUFjJzFkPJhr
         ZK4sycXB6G2w6Uj/ISHQFhwcfM3C00OqmN79ab0pNUsDCyEwq+rjr2efo+EFmgSbo983
         lqxtY5ERkbdnA5e/zlr7ubmP9N+zKvhEzhvMGtUQ9b3+JfBYZ/LM6f4qeZqcD/mea5Go
         iWIjBV5efNbkwleqHjBR7/hwXa2dMOhTRbLffOr6KSriJl1Hp5RySkPLuFd+KXUbUb/z
         fMUt11gRg1KZhN5KVA2AQbpsrmuBT8AGnScUD4E/JDxbkRxE/xVA/Wzm0PXmjaJBz41j
         P4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754287472; x=1754892272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zSRLbZH+ywoLvwHXORH5c+0524CP0mry4togVdem3jU=;
        b=Uyro5QZNVzzaWhelMOM2nKzAPb2w4AHcfhZimCSO7/2t1xZED57yEcCAHiSeuTLtG9
         rrOkWQSb5QNW2NcyKU9grFHvPIxB3dt6avAk8dHJgHle/QS28wh4WdKsYPCjuk0n/nDO
         SfikNvhV3/cShtC7AzzMSxBLNZ9Ya2n8qdlubFnoGrhAx6vQMWE1zo7h4ltGSkXeuTCB
         AFRmOZzGkw3cnQBgL2QmdHnmefkX7IxxB6WSPXOqxVrTkV6+8z7lMR0DCv2xjBEGeh4a
         3VhpuJWJDMpgzQuUaB+eQb9d0t9W4WUYvu2nlPNnqa5sy6xOX+10J40EF8MsGjFi9/tY
         4bBA==
X-Gm-Message-State: AOJu0Yz+tza4NRwTndV/Ot0ABbyifj39FKV/hFRxQbLpiZRZAhp7cnlF
	O+MrplWpohTCZRMn/RI/J0oKh+8jaN3UfqWFgUuxq6asHSmMpdtnFK6D2kI4Ki2+JjA=
X-Gm-Gg: ASbGncvR9AVn1Z9ZoHv66TJTqzsdObhI/o33jwuNNXKa2ls+BtEg+DbA+CX6Zm5JXfp
	TKMTfAxGzbavl8mumzwWiWRft0IiIgatVTxF9DsPwauGA8fnwv3ggzNukiR1hpjkezssEeBxWav
	ffP4x1QTfCMBiBCpcSPoq7ETF6O3eKpjXj1z4hEqHkU8m0HH4YbOmm/xrn81272wtLh572YP612
	5QPUp4mhpYrRM4lBWFo3yJjMN1WKtBsbfQlb7HTsgGyYTIhMlfIb9b4CeR+YRtyRvWPOzl/1TBJ
	UjauYzACa64h0JyHMdyEdeL1f7F6g4Jx4SEoNOkth+f468pXecguOWjB0stEWes1G3hzAo5owb+
	VuhjZA93nXdCqj0M1FqkhEgl79S63OOEr1ea1SgfoCJs=
X-Google-Smtp-Source: AGHT+IGV4z76ItAlYSJtArOu2dhPWvUpQD//brr8fTRiDvDErvYBsQksalTenrcg8flqyPReDXASDw==
X-Received: by 2002:a05:600c:35c6:b0:459:d709:e5cf with SMTP id 5b1f17b1804b1-459d709e8b1mr24094045e9.3.1754287471695;
        Sun, 03 Aug 2025 23:04:31 -0700 (PDT)
Received: from localhost (109-81-86-79.rct.o2.cz. [109.81.86.79])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459de91ea4csm2379665e9.10.2025.08.03.23.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Aug 2025 23:04:31 -0700 (PDT)
Date: Mon, 4 Aug 2025 08:04:30 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji@honor.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, rientjes@google.com,
	shakeel.butt@linux.dev, npache@redhat.com,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	peterz@infradead.org, dvhart@infradead.org, dave@stgolabs.net,
	andrealmeid@igalia.com, liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v3 2/2] mm/oom_kill: Only delay OOM reaper for processes
 using robust futex
Message-ID: <aJBNbnNWa5KLciOq@tiehlicka>
References: <20250804030341.18619-1-zhongjinji@honor.com>
 <20250804030341.18619-2-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804030341.18619-2-zhongjinji@honor.com>
X-Stat-Signature: grdnjfcs587pkphngbajnbira5rtecfd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 68D1C1A000F
X-Rspam-User: 
X-HE-Tag: 1754287473-562053
X-HE-Meta: U2FsdGVkX18xo/F2UCA05FnJ1y0aMufY3IqhbfBU1DabpebLHOt1bDm02D+FsiPSblWJwA74Ohr6QGGKN9MQMnZqy6s9OmomTKMGUNwpxK43YVIv76D/wivcikDT0WaeQJOkwGWPEBWpY6rvL7JfoiC/B5NFbq3NBBbm3SQFDJSkri8MP3cKfVoDv4qNjKav4ViW3iZ8nc2a8f0E4c1o3XXOuwfaENfiNCLxLHHIn3uZ7oG+9FY1J7HMQldoeAoAMMoHGI4ijCi8T3hPtkmRDyj0GeuyoJqXOGDpvYlcOCWM0dNTOG/zJuIdznTIf3o2LzJVqgz3DomqRsEtPH+SSMfnKYeXd9tjwhQSSD7Ca0K6pyuGal1oCoYsHSUd5TKhflbW1ITK6wIa5IALh8p65hnVweAtXwlnlstHz3UraeA7uKtWES35cbABSjofmvPZrDsV+2N9JI/gtM+1GYT4QZDgEnOqpmaJhbMgC8GMvmPYUpcC1tLxUou+M/ABFLAHZ8tjg4HoQy1rPUQyh4p+GyOlwnU+OC/0nUDTxk+SvdnrtPz5oyhLdP5hrrBE2iNRPceK1fg6WBEfWRhTjgRGlEdBEGVHI4ZA0c9X/BR1A/IwTfXwumVrfxp5LdaaU0VXdAqU9+RWLOOvb06eWwTEXRORawepgQAzmeyBR+LUoHCTCJ2XDxV6dSXQo1Xdw3n/ExnCIvq1a0O+wqV9W5tw5UWr6nBw6O1oK3jQwSbJVBVNtPkzA4VCYwo2ilgJC+g/4kM/f6C4zPboY6LXY3H8R1sZMWqiEuOU91xUCsaUEVbL0SE5fKUZ6Rues8NO2ZoMJYVO+h57HXEUfYtXJ6f3GC9/KrHsl3zrgXO7aB1eD56JAGPARK3AEZgVlK0EmfF7t0rbeO8kwjwrhp9IrFo4Meq49GkTk2zGIPJE5L3+J5ZW3VRpX4cbNNcohFOJZUpNKpjwGRreo+O0i6RbZ7j
 U1RZ76B+
 RYLZkNzpnLu638H/YM8ClvjObWVuxgafXuczd0Eope7PB7WsuLs9NsU1Isk5Pqu0uCV6aqh6qGhJjnyDTRz8Xq3MfecPRwFoOAhEkFQxjkkcqPZi6CQ0IeHoeQXAaDamnto5fh4d0aeciIAOOeGhRpv153KJTHFyLAD2HeqDVXl5PM04TvF6mcsLq7jHWldWUWHjiDZfOvYagp8Jbri9pJHoHWDD0NokOCNLDrEZRwBB4Tda2ge/nCuCHTy/YKtDBrJhqiuzk5Y9EgyYuKTBF82JgWRnwESDsGBnkqD1QurglKvymXHiWeVhe55xo3ngGX1OMrU4Vq/ZDxdl41wDMuVAi/Qsbwg0gTSFjyLfhYyaNBPe9b8neBczeHXLEtnCCPNpbf84DQeAb1ah7hE70btwZPSwcOcPPJtD8EUYEllxUQbKpBDTT86pfy3V1CMlcrPzfsduUMfSPzhwL3QFizYbuHoX+b7Wu/Y6qK+AOJimPg4uWLQiZsbFniF5JgQMWIZ5lywRlRCrsYlVY5EAiFVgwip/zwLEJJyCR7Ylx8bHS5iLijBbRME9dj//Se2mk+3xOaKTW4NPCcB8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I have only noticed this now. Did you have any reason to repost v3
without any prior feedback on v2 and without any changelog from v2?

On Mon 04-08-25 11:03:41, zhongjinji@honor.com wrote:
> From: zhongjinji <zhongjinji@honor.com>
> 
> After merging the patch
> https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u,
> the OOM reaper runs less frequently because many processes exit within 2 seconds.
> 
> However, when a process is killed, timely handling by the OOM reaper allows
> its memory to be freed faster.
> 
> Since relatively few processes use robust futex, delaying the OOM reaper for
> all processes is undesirable, as many killed processes cannot release memory
> more quickly.
> 
> This patch modifies the behavior so that only processes using robust futex
> are delayed by the OOM reaper, allowing the OOM reaper to handle more
> processes in a timely manner.
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>
> ---
>  mm/oom_kill.c | 41 +++++++++++++++++++++++++++++++----------
>  1 file changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..c558ac93ae7d 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -30,6 +30,7 @@
>  #include <linux/syscalls.h>
>  #include <linux/timex.h>
>  #include <linux/jiffies.h>
> +#include <linux/futex.h>
>  #include <linux/cpuset.h>
>  #include <linux/export.h>
>  #include <linux/notifier.h>
> @@ -692,7 +693,7 @@ static void wake_oom_reaper(struct timer_list *timer)
>   * before the exit path is able to wake the futex waiters.
>   */
>  #define OOM_REAPER_DELAY (2*HZ)
> -static void queue_oom_reaper(struct task_struct *tsk)
> +static void queue_oom_reaper(struct task_struct *tsk, bool delay)
>  {
>  	/* mm is already queued? */
>  	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
> @@ -700,7 +701,7 @@ static void queue_oom_reaper(struct task_struct *tsk)
>  
>  	get_task_struct(tsk);
>  	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
> -	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
> +	tsk->oom_reaper_timer.expires = jiffies + (delay ? OOM_REAPER_DELAY : 0);
>  	add_timer(&tsk->oom_reaper_timer);
>  }
>  
> @@ -742,7 +743,7 @@ static int __init oom_init(void)
>  }
>  subsys_initcall(oom_init)
>  #else
> -static inline void queue_oom_reaper(struct task_struct *tsk)
> +static inline void queue_oom_reaper(struct task_struct *tsk, bool delay)
>  {
>  }
>  #endif /* CONFIG_MMU */
> @@ -871,11 +872,12 @@ static inline bool __task_will_free_mem(struct task_struct *task)
>   * Caller has to make sure that task->mm is stable (hold task_lock or
>   * it operates on the current).
>   */
> -static bool task_will_free_mem(struct task_struct *task)
> +static bool task_will_free_mem(struct task_struct *task, bool *delay_reap)
>  {
>  	struct mm_struct *mm = task->mm;
>  	struct task_struct *p;
>  	bool ret = true;
> +	bool has_robust = !delay_reap;
>  
>  	/*
>  	 * Skip tasks without mm because it might have passed its exit_mm and
> @@ -888,6 +890,15 @@ static bool task_will_free_mem(struct task_struct *task)
>  	if (!__task_will_free_mem(task))
>  		return false;
>  
> +	/*
> +	 * Check if a process is using robust futexes. If so, delay its handling by the
> +	 * OOM reaper. The reason is that if the owner of a robust futex lock is killed
> +	 * while waiters are still alive, the OOM reaper might free the robust futex
> +	 * resources before futex_cleanup runs, causing the waiters to wait indefinitely.
> +	 */
> +	if (!has_robust)
> +		has_robust = check_robust_futex_rcu(task);
> +
>  	/*
>  	 * This task has already been drained by the oom reaper so there are
>  	 * only small chances it will free some more
> @@ -912,8 +923,12 @@ static bool task_will_free_mem(struct task_struct *task)
>  		ret = __task_will_free_mem(p);
>  		if (!ret)
>  			break;
> +		if (!has_robust)
> +			has_robust = check_robust_futex(p);
>  	}
>  	rcu_read_unlock();
> +	if (delay_reap)
> +		*delay_reap = has_robust;
>  
>  	return ret;
>  }
> @@ -923,6 +938,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  	struct task_struct *p;
>  	struct mm_struct *mm;
>  	bool can_oom_reap = true;
> +	bool delay_reap;
>  
>  	p = find_lock_task_mm(victim);
>  	if (!p) {
> @@ -950,6 +966,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  	 * reserves from the user space under its control.
>  	 */
>  	do_send_sig_info(SIGKILL, SEND_SIG_PRIV, victim, PIDTYPE_TGID);
> +	delay_reap = check_robust_futex_rcu(victim);
>  	mark_oom_victim(victim);
>  	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
>  		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
> @@ -990,11 +1007,13 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  		if (unlikely(p->flags & PF_KTHREAD))
>  			continue;
>  		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
> +		if (!delay_reap)
> +			delay_reap = check_robust_futex(p);
>  	}
>  	rcu_read_unlock();
>  
>  	if (can_oom_reap)
> -		queue_oom_reaper(victim);
> +		queue_oom_reaper(victim, delay_reap);
>  
>  	mmdrop(mm);
>  	put_task_struct(victim);
> @@ -1020,6 +1039,7 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
>  	struct mem_cgroup *oom_group;
>  	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
>  					      DEFAULT_RATELIMIT_BURST);
> +	bool delay_reap = false;
>  
>  	/*
>  	 * If the task is already exiting, don't alarm the sysadmin or kill
> @@ -1027,9 +1047,9 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
>  	 * so it can die quickly
>  	 */
>  	task_lock(victim);
> -	if (task_will_free_mem(victim)) {
> +	if (task_will_free_mem(victim, &delay_reap)) {
>  		mark_oom_victim(victim);
> -		queue_oom_reaper(victim);
> +		queue_oom_reaper(victim, delay_reap);
>  		task_unlock(victim);
>  		put_task_struct(victim);
>  		return;
> @@ -1112,6 +1132,7 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifier);
>  bool out_of_memory(struct oom_control *oc)
>  {
>  	unsigned long freed = 0;
> +	bool delay_reap = false;
>  
>  	if (oom_killer_disabled)
>  		return false;
> @@ -1128,9 +1149,9 @@ bool out_of_memory(struct oom_control *oc)
>  	 * select it.  The goal is to allow it to allocate so that it may
>  	 * quickly exit and free its memory.
>  	 */
> -	if (task_will_free_mem(current)) {
> +	if (task_will_free_mem(current, &delay_reap)) {
>  		mark_oom_victim(current);
> -		queue_oom_reaper(current);
> +		queue_oom_reaper(current, delay_reap);
>  		return true;
>  	}
>  
> @@ -1231,7 +1252,7 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
>  	mm = p->mm;
>  	mmgrab(mm);
>  
> -	if (task_will_free_mem(p))
> +	if (task_will_free_mem(p, NULL))
>  		reap = true;
>  	else {
>  		/* Error only if the work has not been done already */
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs

