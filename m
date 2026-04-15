Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EAFAFA0C58
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613A26B0092; Wed, 15 Apr 2026 04:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C47D6B0093; Wed, 15 Apr 2026 04:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DA0F6B0095; Wed, 15 Apr 2026 04:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BADD6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:48:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB618C1D55
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:48:55 +0000 (UTC)
X-FDA: 84660165030.10.BD45021
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id ED64C140008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:48:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d9j2OtYN;
	spf=pass (imf26.hostedemail.com: domain of rhkrqnwk98@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=rhkrqnwk98@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776242934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cIih9jyLqWh/1mQVBgF5qH4tPxkp2GdHlk3qU9LOcbI=;
	b=ujbFOCGEc7B9luv3GjeaZHb5REKUDb//EaD1j6GayfNW1UHdY5b3vH/pvq8zcqf5NusqRw
	rBtwuB57nt1r8JAhEBcQa6Wc1k3R+4tH6zl2yaeHrR+MrQH4WFa0KTckcLf1xht1pZQX5O
	ESDAl3gjw/0124y102SmTuypk9v0Urg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d9j2OtYN;
	spf=pass (imf26.hostedemail.com: domain of rhkrqnwk98@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=rhkrqnwk98@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776242934; a=rsa-sha256;
	cv=none;
	b=tNwb0P2hu58PHCnIZ5WbvsCjY2tlX3UogBmJyexcnmlC+z328qcKhU8VL6a0A+cF6vvwxP
	ng0Z9IaOAdzLKfa7TwXyzHKlsuMYGdoTlmwHwYpbHccwj/Npnn+wrDtDhlpMEM37vanJYl
	PDplPg7jxnaKItYp2uHqwBxNJ0RnE0s=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82cd70febc7so4392216b3a.2
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776242933; x=1776847733; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cIih9jyLqWh/1mQVBgF5qH4tPxkp2GdHlk3qU9LOcbI=;
        b=d9j2OtYNvEBB26x5KRlbkqpCFVXllJxYOMEPf7PvPkhtOf0B+XlIy6ChnbrM+fj3kj
         Y0KLqx3T9wc+ydvyYo45NudduCgREnzJ4gzuC7d0Ky8AFkjVH5Isw5qpVLeAmyHiHbyR
         bQKRTKasGiY3GmaYzWQRlvjvITxsEcVnjLn/jWBV0Fzd34+PKEFrS1NYQGoo9WX2V5tV
         zut3KkF9Oyac58P/w2SkEpUAV/Y4OAukSl1G2cALEweXzx8XgzEF2f1L7HEJ/tnPsA9E
         UfhO6TkegRHRHfZN70/g5sP4tpPKa3y8gTeFOemN9jEB05gzMhd6LPQAbldobcN2yke6
         nCsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776242933; x=1776847733;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cIih9jyLqWh/1mQVBgF5qH4tPxkp2GdHlk3qU9LOcbI=;
        b=GgvftDxE/mfvMYaWsWpjOEPG6mHsCMT0Ahw/c784Esq9ppIe6g8rm+Ss9BgAlZa0s9
         Yc93rxXp8Ws1wlVl02n9KqDumu+ppTzvM+jsnFYR4XZudXZxPh771/I0GZLIP/OU1rAM
         luMeJt6fO+nbsW5FrRaWptC4rAaqz8TwyjB7K6J6PhxDt+ViCKI3tY/2qWy8yjDt9LWP
         7U4wueQs0nTgI0whJER2hsH9Su3cK5snObaFgp4PTuAT63gW1tw67tTEJKsA0PC/wQ6A
         bAWQnd7stxmIzFPX7NZvS71Oz+z9MoTqmFWGUkgRc1gM+J7d3ycdzUudHwlK84VgRqPy
         EmUg==
X-Gm-Message-State: AOJu0YwRxGundNINr/nFA8aW4K7Rrbz7w6zE72vFWzb6c0KfHl3kcToN
	u5E8GBwSKSZuVbEwf7rJU/FgCHUjDnJGsbD5cxhpm2d5uw8zIBa9j4nG
X-Gm-Gg: AeBDieu5E5k7pFrMtWyl4bkwnxPaQs+WECJa90TZO0H0L6NLdh1nioWOZM4CcnkxdXg
	oDaPtENaO01ZgcmME/pTM4n7Z19aZKBY+1lbeGjf3Mi+96wRIpuiTnsqq5kp+kZHCSAwKCNL5sa
	XNpE7lZheVIi8QGTHujNdw5myNj3Hg1nz9ih1wa+hgyif09jwCs7HhZ4BaOgXVEReXNnKo8bQpE
	ixxqhnwjz3nUyI0WQvByNrhz4zgenbiu5yfq7d7qxjwNMDhhnfXmp55of7v+/yONxgR2kSC9Y17
	oO0Ehb3daRXMb/ykQ4+UoXut0LqR/xcwJeyrFuetE/ejflQDKmzd/fEnbPAaNiRe7VPRaK27fQn
	f+pepfn5YM3UE8Ytsk+bXdxfV14IHEBvnpbD8s7W0PrPBj6jlUMmPHDP2AUblKEU7aqsr5GcdAq
	IfwPrYWBAKQVKlcvypA9GSzi1FhuBjuxuYrL3AC+rr9ytFyu3h4DW2z7BNtTFi7QAC9BRLGU7O
X-Received: by 2002:a05:6a00:1947:b0:82c:70a8:faee with SMTP id d2e1a72fcca58-82f0c1d9e1dmr20498744b3a.6.1776242932685;
        Wed, 15 Apr 2026 01:48:52 -0700 (PDT)
Received: from cps-manycore-1.. ([143.248.136.81])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f67085562sm1616587b3a.24.2026.04.15.01.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 01:48:52 -0700 (PDT)
From: Sechang Lim <rhkrqnwk98@gmail.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sechang Lim <rhkrqnwk98@gmail.com>
Subject: [PATCH] mm/vmalloc: Prevent RCU stall in decay_va_pool_node()
Date: Wed, 15 Apr 2026 08:48:37 +0000
Message-ID: <20260415084837.1001739-1-rhkrqnwk98@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ED64C140008
X-Stat-Signature: agm85hh1nucydnuazosq9p3zd3r6fh6p
X-Rspamd-Server: rspam06
X-HE-Tag: 1776242933-939369
X-HE-Meta: U2FsdGVkX1+6W+mhmrmSdeBoC/pu7HgSVreqK9Ro299ncK6owZGWY/1L3T3vGabqDwEXtD96u3/D+cdvARTdzVCl1VnYULNo8raQCU9XnsCWT+wBVYqPUNTo9ZDfNonjBaiOcvEcuPee/lbsxIMw0kAFsl+crd/z3sKdfDK84hBQii+tUpDa592zgokNsdP+mcmWxu26aRBMEiCfV6g/0MIchMBf13l4zV2uRpYF7csVEmQ1QE2toNreGjuoQcNZT2LYLa5tMhY6+P/wfEltwZTwAI5ddyOg9UJZ6hRKANGvEXHH9oAI3FDvK5QAfn2YbEg83XdkKGXv0bahpddnPTN79SDjknj7I0MPpwSchBDoWsR8X4dSufLjeiTxi9dOynA6PwaNEJmeggWuNxmNipc3EWvpgQMoQoatzHaj/wVnwVTsbHSll/dmxPakoTwBRAUpevMMFVkEwCAhvbXmY3wwCicE2bkGSbSTi6epAfwVjKVPTjWyJv0uEiRiluVBkJlK0LAZQjyOhZXeMbGMGtW9WFdVq4G7c783v9RotrWxeLNL9FE79c3SW73WbutQhc9j9o8ZajrPhfC5modKx0u/USjDFw45yP9sik1uRxghtPGXO6+D7OPJZj5YuCfvos4wT7va8tvVlKjwfNZYmGj5qG9BbM6w+o5NXP8oGEjC3fIEsmxpbcP8jaTFyfvQbG5IIWxEyQKYGFaPUzNBHmMZTNn3sJfcBc/iuve6Fq8d/L8K9cZpSqJ44EPcTRe4w6gFCPV5z2xCSsKOA/iOiYHVLO6qUo5pypcE68DgSxshVc/CiGI1VJvUAXBSKHFNP5fWSKl9IjbORw/1P97nYHH4lGezl24GzQmjYyMM917QgmrM48bgSTF98jmMgfNTGOdqfIb0Wuue66PQsDzb3CNzYsmxYHBdIokWNK0y49Bl/mLD0ausAN+6rinMOV7wRlHf12ryBXnuX8XjTFh
 gBNtaEFr
 GaRH5jGS1VBrR8gSrdihDQNDsh6TLln6vA3ClCfDByFlAHWEv06/Yb0QOXEazua9W3me+aMJ9l8HZc8omMG+WVNGei64/8UtgKTDo2ROkRxF9MVSRJLQ24I//eKDhaAwoDbPXn43pSoYC7ARnI/ePYUNbC/LsGt+4XDDlq52fylNrAhGMTIHL9A3lGZ0uMzgwZ4liYxy0cJbACf6wu13o3PaLUO+iYmBs5BBDMk6oiVRHtXsjnuAkmtn+3OfHa9mQ7H/4fMQJ3VDNOv2KKKHVNxifmPoKqDb1L66wsga3yLTS0i8sCLBguAMDs2qOjDCR5HLEmpxJGi3N/IfAr4+Z+inBekeOQVXTDRSahSzM/QDxy3LjXuq/c/CS+V6jKQIyqTBO274nK7QMLJzKzj8b58W9SNDSNf7z1U+mEBwRkaq5g8ii33SufXqCgrjbg20TUo676DzQ7HPtLwyigmrFgOWKrzkrlwTGfc2bzdRloPhAono=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

decay_va_pool_node() walks every per-pool free-list entry under
vmap_purge_lock and merges each vmap_area into a global RB-tree via
reclaim_list_global() without yielding. The outer loop has no
rescheduling point, so when many vmap areas are queued the function
can monopolize the CPU long enough to trigger an RCU self-detected
stall:

  rcu: INFO: rcu_preempt self-detected stall on CPU
  rcu:    2-...0: (6344 ticks this GP) idle=853c/1/0x4000000000000000 softirq=41536/41536 fqs=3211
  rcu:    (t=6528 jiffies g=37549 q=4652 ncpus=4)
  CPU: 2 UID: 0 PID: 1516 Comm: syz.5.318 Not tainted 7.0.0-rc7 #4 PREEMPT(full)
  Call Trace:
   <TASK>
   finish_task_switch.isra.0+0x23e/0x990     kernel/sched/core.c:5155
   context_switch                            kernel/sched/core.c:5301 [inline]
   __schedule+0xb3d/0x3680                   kernel/sched/core.c:6911
   preempt_schedule_common+0x44/0xc0         kernel/sched/core.c:7095
   preempt_schedule_thunk+0x16/0x30          arch/x86/entry/thunk.S:12
   __raw_spin_unlock                         include/linux/spinlock_api_smp.h:169 [inline]
   _raw_spin_unlock+0x43/0x50                kernel/locking/spinlock.c:186
   reclaim_list_global                       mm/vmalloc.c:2213 [inline]
   decay_va_pool_node+0xccf/0x1070           mm/vmalloc.c:2273
   __purge_vmap_area_lazy+0x136/0xc80        mm/vmalloc.c:2361
   _vm_unmap_aliases+0x469/0x6e0             mm/vmalloc.c:2996
   change_page_attr_set_clr+0x24d/0x4a0      arch/x86/mm/pat/set_memory.c:2082
   set_memory_rox+0xc2/0x110                 arch/x86/mm/pat/set_memory.c:2314
   create_trampoline                         arch/x86/kernel/ftrace.c:421 [inline]
   arch_ftrace_update_trampoline+0x79d/0xb50 arch/x86/kernel/ftrace.c:479
   ftrace_update_trampoline+0x45/0x360       kernel/trace/ftrace.c:8391
   __register_ftrace_function+0x238/0x340    kernel/trace/ftrace.c:365
   ftrace_startup+0x3b/0x370                 kernel/trace/ftrace.c:3098
   register_ftrace_function_nolock+0x5e/0x160 kernel/trace/ftrace.c:9162
   register_ftrace_function+0x32b/0x4c0      kernel/trace/ftrace.c:9189
   perf_ftrace_function_register             kernel/trace/trace_event_perf.c:494 [inline]
   perf_ftrace_event_register+0x159/0x240    kernel/trace/trace_event_perf.c:518
   perf_trace_event_open                     kernel/trace/trace_event_perf.c:184 [inline]
   perf_trace_event_init                     kernel/trace/trace_event_perf.c:206 [inline]
   perf_trace_event_init+0x17b/0xad0         kernel/trace/trace_event_perf.c:193
   perf_trace_init+0x176/0x290               kernel/trace/trace_event_perf.c:226
   perf_tp_event_init+0xa6/0x120             kernel/events/core.c:11270
   perf_try_init_event+0x103/0x930           kernel/events/core.c:13029
   perf_init_event                           kernel/events/core.c:13127 [inline]
   perf_event_alloc.part.0+0x11dd/0x4970     kernel/events/core.c:13402
   perf_event_alloc                          kernel/events/core.c:13283 [inline]
   __do_sys_perf_event_open+0x764/0x2eb0     kernel/events/core.c:13924
   do_syscall_x64                            arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0xa9/0x580                  arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

Add cond_resched() at the bottom of the outer loop in
decay_va_pool_node(). At that point the per-pool spinlock has already
been released and the outer vmap_purge_lock is a mutex, so sleeping
is safe.

Found by Syzkaller.

Fixes: 72210662c5a2 ("mm: vmalloc: offload free_vmap_area_lock lock")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
---
 mm/vmalloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..78e064a9c4c7 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2268,6 +2268,8 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 			WRITE_ONCE(vn->pool[i].len, pool_len);
 			spin_unlock(&vn->pool_lock);
 		}
+
+		cond_resched();
 	}
 
 	reclaim_list_global(&decay_list);
-- 
2.43.0


