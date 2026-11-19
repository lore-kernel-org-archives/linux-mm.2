Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AA28606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tLo+B+xe
Received: by kanga.kvack.org (Postfix)
	id 5AB116B05F4; Thu, 19 Nov 2026 11:00:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C3D6B06A5; Thu, 19 Nov 2026 11:00:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4719C6B0637; Thu, 19 Nov 2026 11:00:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2188C6B06A5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:00:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF262120B6D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:00:34 +0000 (UTC)
X-FDA: 85452331188.25.AA11E83
Received: from mta1.migadu.com (out-69.mta1.migadu.com [95.215.58.69])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8115320004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:00:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tLo+B+xe;
	spf=pass (imf03.hostedemail.com: domain of bradley.morgan@linux.dev designates 95.215.58.69 as permitted sender) smtp.mailfrom=bradley.morgan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795104033;
	b=ArTlRDH65oHdOfGxOkjBdN1RzDOO3qmJqk2fKAXiT9Ja9/brR1NXKjBmwWhytaATCwdwbQ
	LPU7krjd6HKrmBoUrWYjdG+ML2S+3u1lyosLPPEBvtPvQfkO6wE4yJi0c8caKOClTHyzcA
	UyqoKrH5+bJiotO7PTB6iByPqKj4n+Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795104033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=ghdvXRs6WeD3J65MxVpuLnA2rqhyvwGZJnk+T3/dQgs=;
	b=WFx59ed7+LyxZb2slcOydqanZCC3nC7bvnMQ6w9uosLVTBL2lYx5uHdt0D+lLQx3y1z7S2
	E/aIyoRB7jNhzHzj+Onl4QiZu5ORMiBeU2XVYGKMLF5iQby/rGq50wQUTiNAawWJtJtX0y
	aEf9Sy5YNdSS6YA1y34LBfQ0iErmxaM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tLo+B+xe;
	spf=pass (imf03.hostedemail.com: domain of bradley.morgan@linux.dev designates 95.215.58.69 as permitted sender) smtp.mailfrom=bradley.morgan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=muSluvC1BBHfMSuECvqWpxXBduhSE0/vxCvegiCzjJc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795104031; v=1; x=1795708831;
 b=tLo+B+xeCoSz52Ak/4uTpwVZqOwrb+rQ/CatO3ImXSVHuqnOp9h9UjWf+ggGqjrj2LOKzRoZ
 P1RQgF817y4R/hgad8n2Lyq0EdBtQQam5gsytoRtxMuZer73TP2gVpucEYc0r/5sxf1sBqMcL/o
 U7U6f20hfFgFf0v/hSZDGfRw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d38b154e6baa8d3a;
	Thu, 19 Nov 2026 16:00:27 +0000
X-Mizu-Trace-ID: d38b154e6baa8d3a
X-Migadu-Flow: FLOW_OUT
Date: Thu, 19 Nov 2026 16:00:23 +0000
From: Bradley Morgan <bradley.morgan@linux.dev>
To: david@kernel.org
CC: akpm@linux-foundation.org, alexander.shishkin@linux.intel.com, ast@kernel.org,
 bpf@vger.kernel.org, bsegall@google.com, dietmar.eggemann@arm.com,
 juri.lelli@redhat.com, kees@kernel.org, kprateek.nayak@amd.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, mason@kernel.org, mathieu.poirier@linaro.org,
 mgorman@suse.de, mhocko@suse.com, mingo@kernel.org, mingo@redhat.com,
 peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org,
 sashiko-bot@kernel.org, songliubraving@fb.com, stable@vger.kernel.org,
 surenb@google.com, vbabka@kernel.org, vincent.guittot@linaro.org,
 vschneid@redhat.com, yhs@fb.com
Subject: Re: [PATCH] fork: clear p->mm when copy_process() fails
In-Reply-To: <20261119-mm_failed_fork-v1-1-b3019f43d197@kernel.org>
Message-ID: <7F08BE59-B6F6-4884-AD56-8178335F2C15@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8115320004
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 19sxjugh4mo66u45q91ofnfjdtrucn9j
X-Rspamd-Server: rspam10
X-HE-Tag: 1795104032-911100
X-HE-Meta: U2FsdGVkX18SYxWTViFXIxHqAB7wVEtIzHXzWebAzH7833kPXUVn37gnwt6vdmOEiqoGDS6GyhEYpuWsRmP1BSQZe6e9s4gJHYKtfevKEneaIatr65gRG2hMlPWVmrRd2BAoTbxP0LVheSb/wLjLKU5CKZI5/VG+6IW6K2tL+0D5cAqsc6xKLEbvI1fIHaKs4+rfFOJsJ80DXCGy6gqQIlZv+TNxEqFWJSR41aEJ5/ig76H6aERjyExvuNEAqgG7bWxPROsdXlXrDLQSKzUyILozVTnrdU82afMIvyO1ATiTKadn8gApOCE1ESa1hPmVbS5thjKkn5aA9maw2sFuPUGdcakyjECq+tjcT6t7YRxu2wKnAhpsSUOsC6UnFFba05hRf7bOuj51b8Bsbw5fq/4H0UmdfV8+JIXU6StkO/YKxzGadV7l6cI+D8/W5dizDpcGDWl0OLqT0TP+MGvz4b16XZRYs42jMtD3u2ryTTdxx29Jh1bc04iDRJAHyiXDsaiJR6I8kctDAhnIPqIjVUEUNmjgB+vD0bWBWfL183m5YDhA+hYbj1rDjE0ihqGP/oKloWjK/S6TZuCMrzl0KR/ezRhXzok1zPS8zxk6ACokki0gLDPZemvjgZWiYy4kbmURJDHnFZEwnoSR0/5R6oIal4eUFEpq490VA5MfHTPBpuoY/3HHLM6NZ1BrFUFOPpUpXkZj36pLfSdkP7moihZeY7iwhkOy8U3NAxCrvSKMFPJYJzj2o+vQOVSs2f6DHiurbVyNVWzIWNcDLWNF47FLQKyXAntpVDSRxNH+53dJlFNp1DOxHBfKd38idf9GKNpgsHZdqcVHrzTigD1NTtsk+K2g53KuElQTgsAn2JZopSZXK3KrKm9SGM5fRQzRq4qy+6JOKpkwkLmK8740NAly0UaQdqhAR3N3FEZA2LI7g19lTrpT77pnd7DuKqtJ6xGLIwJaQGpW04aaN6U
 Tx/8s7y2
 2Vu/a7f9K4mVOFRMihUmEREb9Il9yLWKHrwgf4ZL4Pu1oLZIRrXCYtdpQsc/wOEexJ+OlA/wkn2gpokysxr4Bd1g4a02r7DEl5baCZtbO/0lZIWiKOZ+5sbPy1G+2KD2pvY6HUBUZJchfV3nJwnurbouOeg9JVKS9cIhi7GfuNve2jGuqRQtZeR+F3YeD7083kcfGv1K0g2KjugmT2xtVF8XjJpYlHMQZRK58+8SL8favSjV/BF0ypmqs2MSrXckzQvOE0cfpvb+ttjVyKTd5ljkr3bxM0S32IGvDiRxgJO1DeRU/968Ed60fT8ISWmvS0FS+rHP4l3rOsFW/yfjPUwLhp5TXpwmRDBMXJ/l1p3BQqpii8vvKQPa0+lLET4Ba8SZuPX3cM9uhftmARbYzkV9DBfpLuWHGLXLaDgOc7fcY1J3PPYWI/e9IMVrjw4XAtdXbP7V/nyaPvwYG38282K/v+PggCiYDOQDjhEF7T0qFYrligwu0Tk4SiWKhRypQBXGIGp9fh3xUkOArlngcpSPgBWBCZY+O+WFavJzY2XmJvJ99olEBSE+viJ0BAKNJgLJZSrSNc3u479sS/d+zfX6sbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 19 November 2026 08:04:58 GMT, "David Hildenbrand (Arm)"
<david@kernel.org> wrote:
>From: Chris Mason <mason@kernel.org>
>
>When copy_process() fails after copy_mm(), the error path drops the mm
>reference but leaves p->mm set. Perf and BPF can still reach the
>task, and take a reference on the already freed mm through get_task_mm()
>or bpf_find_vma(), resulting in a use-after-free:
>
>    copy_process()               PERF_EVENT_IOC_SET_FILTER
>    ==============               =========================
>    perf_event_init_task(p)
>    copy_mm(p)
>    a later step fails
>    mmput(p->mm)
>      /* frees the mm */
>                                 perf_event_addr_filters_apply()
>                                   get_task_mm(p)
>                                     /* use-after-free */
>
>Similarly, a BPF program on the task_free LSM hook can call
>bpf_find_vma(p)
>before the task is freed.
>
>Fix it by clearing p->mm under task_lock() before dropping the reference,
>just like exit_mm() does.
>
>Further, if copy_process() fails before copy_mm(), p->mm is still the
>parent's mm pointer copied by dup_task_struct(), without having taken a
>reference. While nobody can access it concurrently, there is the
>chance that it might get accessed later when a BPF program is attached
>to free_task().
>
>With CONFIG_MEMCG the task is freed after an RCU grace period, so the
>parent might already be gone and p->mm in the child points at something
>that was already freed. So let's just clear p->mm before freeing the
>task. No lock is required as there cannot be concurrent access (and we
>might not even have the lock initialized yet).
>
>This has medium urgency.
>
>Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
>Fixes: 7c7e3d31e785 ("bpf: Introduce helper bpf_find_vma")
>Reported-by: Sashiko <sashiko-bot@kernel.org>
>Closes: https://lore.kernel.org/sashiko-outbox-180866@kernel.org/
>Cc: stable@vger.kernel.org
>Signed-off-by: Chris Mason <mason@kernel.org>
>[ david: simplify description and comments ]

Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>


>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
>I can take this through my tree (rather soonish) unless someone else
>wants to pick this up.
>---
> kernel/fork.c | 15 +++++++++++++--
> 1 file changed, 13 insertions(+), 2 deletions(-)
>
>diff --git a/kernel/fork.c b/kernel/fork.c
>index 5efceb8d58a78..77d6c8fc38c66 100644
>--- a/kernel/fork.c
>+++ b/kernel/fork.c
>@@ -2628,8 +2628,14 @@ __latent_entropy struct task_struct *copy_process(
> bad_fork_cleanup_mm:
> 	sched_cache_fork_cleanup(p);
> 	if (p->mm) {
>-		mm_clear_owner(p->mm, p);
>-		mmput(p->mm);
>+		struct mm_struct *mm = p->mm;
>+
>+		/* Perf events and BPF programs can still reach p. */
>+		task_lock(p);
>+		p->mm = NULL;
>+		task_unlock(p);
>+		mm_clear_owner(mm, p);
>+		mmput(mm);
> 	}
> bad_fork_cleanup_signal:
> 	if (!(clone_flags & CLONE_THREAD))
>@@ -2663,6 +2669,11 @@ __latent_entropy struct task_struct *copy_process(
> 	exit_cred_namespaces(p);
> 	exit_creds(p);
> bad_fork_free:
>+	/*
>+	 * If set, p->mm points at the parent's mm without a reference. Nobody
>+	 * can access it concurrently anymore, but prevent later access.
>+	 */
>+	p->mm = NULL;
> 	WRITE_ONCE(p->__state, TASK_DEAD);
> 	exit_task_stack_account(p);
> 	put_task_stack(p);
>
>---
>base-commit: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
>change-id: 20261119-mm_failed_fork-a46141b503d0
>
>Best regards,
>--  
>David Hildenbrand (Arm) <david@kernel.org>
>
>
>


--- Thanks!

