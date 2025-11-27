Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D3B5D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 23:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE9376B0030; Thu, 27 Nov 2025 18:37:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71CE6B0062; Thu, 27 Nov 2025 18:37:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63146B0032; Thu, 27 Nov 2025 18:37:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 948976B002F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:37:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3050D1402E6
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:37:04 +0000 (UTC)
X-FDA: 84157999968.08.2CAEB25
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1DEB5140009
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:37:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ap4vSDWm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pZCS4rKm;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Qdftk0iS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="RfFM/vp6";
	spf=pass (imf26.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764286622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0UUaCVzJQj1/iuGKRH/cFH/A07YpZOHP7llM/q/NC4=;
	b=ucP06bnVKLWfh1KuY4oQlzeszeOfHRHf553M1M3w6DoAnZ6pL24yEoHe3jwR12fi4m9+CP
	Xq1Ob5mMxbbnbiGZp/pTINKeo8xEqtHOCI0JZOvzYd4GbgjXoM2KgdCBFQHFhwwi9l1iq4
	I9vLite3bR1dFHejd7kw6BGNaDf3kkc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ap4vSDWm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pZCS4rKm;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Qdftk0iS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="RfFM/vp6";
	spf=pass (imf26.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764286622; a=rsa-sha256;
	cv=none;
	b=gOLF69hQkviGDSti3Qz0ZbjoM9zPV4BXpby0FkFP2wiPJrSZ/MSO1BNC1dZO0/0bSuGKxR
	xTGpns+PIve/En5wtT1MqGbdOuooYzz2t5jAs6IyuMnpLpNl14gcWHmr6g7By9/p786mXa
	63m6X8aYIu9Eql6vlqWkTLfXPHpzFPI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2A7AA5BD09;
	Thu, 27 Nov 2025 23:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764286619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n0UUaCVzJQj1/iuGKRH/cFH/A07YpZOHP7llM/q/NC4=;
	b=Ap4vSDWmeM14JLoIya0pM7b9gtnZKJd4TDGsh3BOnyTh+J1Y7xwX0rJ3e/aw0tCqhP0vOE
	HdJ9yzbIhkFNiTCVTbzMVOcFW8OuNO2eSHufieMWIwI4X2nIOkV+0lK3XUvcvyyXzwjASN
	YlrKMB83IdkHBvRAwepkhGRnMuchCaQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764286619;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n0UUaCVzJQj1/iuGKRH/cFH/A07YpZOHP7llM/q/NC4=;
	b=pZCS4rKmX00/K7qjGPGeGRncIEMz2ZfSI/TAe9YyeOIW7sloLQ/VAOU2EcX0g4VSbcJBfW
	UlWvNhqTyBeZCyDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764286618; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n0UUaCVzJQj1/iuGKRH/cFH/A07YpZOHP7llM/q/NC4=;
	b=Qdftk0iSZmgPWzxli5uiBsXKNZIkrmhwaRuka7bf3JoqtXoRh/Qk6y2mtVASmG6u2V0HVm
	hIhxIJxY0Rk8KWvMmT6MBvpwQ/LQMaX7x0d56MJ8ZP8+6jomlUGqah1yAgZVpFOm/a58WA
	frBAff0NWHfn1540T1u4wv7ykcC1JqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764286618;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n0UUaCVzJQj1/iuGKRH/cFH/A07YpZOHP7llM/q/NC4=;
	b=RfFM/vp6sSa9Z/nrGP4ohEtuOJWX49AKgGQPVvl7/g3pGhZxCYRDrjghsrid5emCC+xYLL
	xwQkw+YaO9oM1KBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C09633EA65;
	Thu, 27 Nov 2025 23:36:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WoV6I5ngKGlGGQAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 27 Nov 2025 23:36:57 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: linux-mm@kvack.org
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	linux-kernel@vger.kernel.org,
	jack@suse.cz,
	Mateusz Guzik <mjguzik@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 3/4] mm: Avoid percpu MM counters on single-threaded tasks
Date: Thu, 27 Nov 2025 18:36:30 -0500
Message-ID: <20251127233635.4170047-4-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251127233635.4170047-1-krisman@suse.de>
References: <20251127233635.4170047-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1DEB5140009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mwrdhzwa7qz5rbr8fddqbi3w1thf6i9q
X-HE-Tag: 1764286621-853820
X-HE-Meta: U2FsdGVkX19i/Ed4WjvlUWGXJui9MGXeuQ0BWdmUNfFFq6SRU7ALdLu6CQEK2rj2qLvuhOYcbvRUbKSNPGX51u7lmIW+OC1zLsFUvhOEcFoLTaZg6jK6gbQ/kUdLN2vy0tgXw828ksh7vHR+Xx8iJL1dMNUjq9xbJ2x3VfPaVa9Te1qCkCSZsz+uB8iCTTmRC+GPjVy4IRaa+ifn9LKfMGlJNf2NNl9PAnDnBKfmYHWt9b/wnTjtnHxAXXz3pQKxeMnsuhvD7uGbG1T927PaXtGVY+00mDh+wU/cqzrkgYe1rk04rMxDCicPQdtqXd6WN9+Stw/dbbrLi9xH5IZyJ33CSw9Dpd+c6TdKCGxUO6k1hGQ3FdHPKrTp5KzrDhedE5/mbDooKqBcBsj9kDxZ/7g+I90qHrX8+gPQ5CM2pxVTBQdOhhpxCMpmmx26s1kGY3+ZN8mnYwuOXw4X7JzXeAbkliHBiyFl89LKsEpxIUhF7GtR+f45NMnOiSMvCKz2OS6GvnDUvTb/0dj+8prrjsBq5ifVVGBL+BTG2LUyRzAu29jR+DKrErvLN7IAFOvoF1NLCgUAyFpyFFAnKwygX5UOS+mfe8Oy/rThCLkf//bKLRoTuTS1E0iYQDMceKDTJ9Eqkb7mFtSUCyRHo8aGoNDXc+00/lwCL29boPhah4H0/3V7BlpGwmh6yc8EeGUo+9U8r279+rYclc0KXIIfLhkUuGGoHh6AiV8heBuyfsuf1VbgXilZlR3fZ9OFWdEwxSZ/tOU7hMEdCKI5eB2GamzUG0ZG0lP56b50Cql//bxPTsr6olPpowuiI3uJexKfEV59wDv6Tc+UQ6+hshKFeaoz6CgKsyMBmfM3vfRRVAzRVsw7QOSfGc7yHU2+JaGVPtuie8YsO8O70/RVGGaf8evR//4P4ZiGKV2I68IBWREMwQDCEbXf7FHL7d8KQxU59bXPKtmcuE8n5NJgvj0
 9Hw2XL0Z
 BdYP8HPd/aUTQYNaMUSXKtAcr5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cost of the pcpu memory allocation when forking a new task is
non-negligible, as reported in a few occasions, such as [1].

But it can also be fully avoided for single-threaded applications, where
we know the vast majority of updates happen from the local task context.

For the trivial benchmark, bound to cpu 0 to reduce cost of migrations),
like below:

     for (( i = 0; i < 20000; i++ )); do /bin/true; done

on an 80c machine, this patchset yielded a 6% improvement in system
time.  On a 256c machine, the system time reduced by 11%. Profiling
shows mm_init went from 13.5% of samples to less than 3.33% in the same
256c machine:

Before:
-   13.50%     3.93%  benchmark.sh     [kernel.kallsyms] [k] mm_init
   - 9.57% mm_init
      + 4.80% pcpu_alloc_noprof
      + 3.87% __percpu_counter_init_many

After:
-    3.33%     0.80%  benchmark.sh  [kernel.kallsyms]  [k] mm_init
   - 2.53% mm_init
      + 2.05% pcpu_alloc_noprof

For kernbench in 256c, the patchset yields a 1.4% improvement on system
time.  For gitsource, the improvement in system time I'm measuring is
around 3.12%.

The upgrade adds some overhead to the second fork, in particular an
atomic operation, besides the expensive allocation that was moved from
the first fork to the second.  So a fair question is the impact of this
patchset on multi-threaded applications.  I wrote a microbenchmark
similar to the /bin/true above, but that just spawns a second pthread
and waits for it to finish. The second thread just returns immediately.
This is executed in a loop, bound to a single NUMA node, with:

       for (( i = 0; i < 20000; i++ )); do /bin/parallel-true; done

Profiling shows the lazy upgrade impact is minimal to the
performance:

-    0.68%     0.04%  parallel-true  [kernel.kallsyms]  [k] __lazy_percpu_counter_upgrade_many
   - 0.64% __lazy_percpu_counter_upgrade_many
        0.62% pcpu_alloc_noprof

Which is confirmed by the measured system time. With 20k runs, i'm still
getting a slight improvement from baseline for the 2t case (2-4%).

[1] https://lore.kernel.org/all/20230608111408.s2minsenlcjow7q3@quack3

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/linux/mm.h          | 24 ++++++++----------------
 include/linux/mm_types.h    |  4 ++--
 include/trace/events/kmem.h |  4 ++--
 kernel/fork.c               | 14 ++++++--------
 4 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..29de4c60ac6c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2679,36 +2679,28 @@ static inline bool get_user_page_fast_only(unsigned long addr,
  */
 static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 {
-	return percpu_counter_read_positive(&mm->rss_stat[member]);
+	return lazy_percpu_counter_read_positive(&mm->rss_stat[member]);
 }
 
 static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
 {
-	return percpu_counter_sum_positive(&mm->rss_stat[member]);
+	return lazy_percpu_counter_sum_positive(&mm->rss_stat[member]);
 }
 
 void mm_trace_rss_stat(struct mm_struct *mm, int member);
 
 static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
 {
-	percpu_counter_add(&mm->rss_stat[member], value);
-
-	mm_trace_rss_stat(mm, member);
-}
-
-static inline void inc_mm_counter(struct mm_struct *mm, int member)
-{
-	percpu_counter_inc(&mm->rss_stat[member]);
+	if (READ_ONCE(current->mm) == mm)
+		lazy_percpu_counter_add_fast(&mm->rss_stat[member], value);
+	else
+		lazy_percpu_counter_add_atomic(&mm->rss_stat[member], value);
 
 	mm_trace_rss_stat(mm, member);
 }
 
-static inline void dec_mm_counter(struct mm_struct *mm, int member)
-{
-	percpu_counter_dec(&mm->rss_stat[member]);
-
-	mm_trace_rss_stat(mm, member);
-}
+#define inc_mm_counter(mm, member) add_mm_counter(mm, member, 1)
+#define dec_mm_counter(mm, member) add_mm_counter(mm, member, -1)
 
 /* Optimized variant when folio is already known not to be anon */
 static inline int mm_counter_file(struct folio *folio)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 90e5790c318f..5a8d677efa85 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -18,7 +18,7 @@
 #include <linux/page-flags-layout.h>
 #include <linux/workqueue.h>
 #include <linux/seqlock.h>
-#include <linux/percpu_counter.h>
+#include <linux/lazy_percpu_counter.h>
 #include <linux/types.h>
 #include <linux/bitmap.h>
 
@@ -1119,7 +1119,7 @@ struct mm_struct {
 		unsigned long saved_e_flags;
 #endif
 
-		struct percpu_counter rss_stat[NR_MM_COUNTERS];
+		struct lazy_percpu_counter rss_stat[NR_MM_COUNTERS];
 
 		struct linux_binfmt *binfmt;
 
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 7f93e754da5c..e21572f4d8a6 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -442,8 +442,8 @@ TRACE_EVENT(rss_stat,
 		__entry->mm_id = mm_ptr_to_hash(mm);
 		__entry->curr = !!(current->mm == mm);
 		__entry->member = member;
-		__entry->size = (percpu_counter_sum_positive(&mm->rss_stat[member])
-							    << PAGE_SHIFT);
+		__entry->size = (lazy_percpu_counter_sum_positive(&mm->rss_stat[member])
+				 << PAGE_SHIFT);
 	),
 
 	TP_printk("mm_id=%u curr=%d type=%s size=%ldB",
diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a9..92698c60922e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -583,7 +583,7 @@ static void check_mm(struct mm_struct *mm)
 			 "Please make sure 'struct resident_page_types[]' is updated as well");
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
-		long x = percpu_counter_sum(&mm->rss_stat[i]);
+		long x = lazy_percpu_counter_sum_local(&mm->rss_stat[i]);
 
 		if (unlikely(x)) {
 			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
@@ -688,7 +688,7 @@ void __mmdrop(struct mm_struct *mm)
 	put_user_ns(mm->user_ns);
 	mm_pasid_drop(mm);
 	mm_destroy_cid(mm);
-	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
+	lazy_percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
 
 	free_mm(mm);
 }
@@ -1083,16 +1083,11 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	if (mm_alloc_cid(mm, p))
 		goto fail_cid;
 
-	if (percpu_counter_init_many(mm->rss_stat, 0, GFP_KERNEL_ACCOUNT,
-				     NR_MM_COUNTERS))
-		goto fail_pcpu;
-
+	lazy_percpu_counter_init_many(mm->rss_stat, 0, NR_MM_COUNTERS);
 	mm->user_ns = get_user_ns(user_ns);
 	lru_gen_init_mm(mm);
 	return mm;
 
-fail_pcpu:
-	mm_destroy_cid(mm);
 fail_cid:
 	destroy_context(mm);
 fail_nocontext:
@@ -1535,6 +1530,9 @@ static int copy_mm(u64 clone_flags, struct task_struct *tsk)
 		return 0;
 
 	if (clone_flags & CLONE_VM) {
+		if (lazy_percpu_counter_upgrade_many(oldmm->rss_stat,
+						     NR_MM_COUNTERS, GFP_KERNEL_ACCOUNT))
+			return -ENOMEM;
 		mmget(oldmm);
 		mm = oldmm;
 	} else {
-- 
2.51.0


