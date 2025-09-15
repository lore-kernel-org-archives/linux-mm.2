Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B96CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F718E001C; Mon, 15 Sep 2025 12:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC02B8E0008; Mon, 15 Sep 2025 12:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD568E001C; Mon, 15 Sep 2025 12:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE438E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:47:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 429DC1A0697
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:47:28 +0000 (UTC)
X-FDA: 83892065376.02.B34238B
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7258BA0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:47:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uyL3vyqx;
	spf=pass (imf25.hostedemail.com: domain of 3HUPIaAsKCBI2s3wAzA05yzy66y3w.u64305CF-442Dsu2.69y@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3HUPIaAsKCBI2s3wAzA05yzy66y3w.u64305CF-442Dsu2.69y@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757954846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59uH0/Rs24hPqNuUZQXolv8jQt8VsNO5VNNB4W0XCmc=;
	b=K190hN22v4inlHJWVRxpGQGUex5OXtolK4SF6Hn6QD9FiuxENHqPvqUM/uGdpqphq7wnVw
	zKfAhiKH+xi/JQZ8l7bNGu7UH5pFZmsmgWJDQsrl1fm7V3UdVw9UFWpuco+weqLDnJs04V
	Zx1CkVHbrx4ApBGig1+Bs6QfH7ouXUQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uyL3vyqx;
	spf=pass (imf25.hostedemail.com: domain of 3HUPIaAsKCBI2s3wAzA05yzy66y3w.u64305CF-442Dsu2.69y@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3HUPIaAsKCBI2s3wAzA05yzy66y3w.u64305CF-442Dsu2.69y@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757954846; a=rsa-sha256;
	cv=none;
	b=XyIU5oc3V85ZO48brt5u1CB58g892Jt+V6YpxdpaxI0qczOz6qlL9fEyz2ArieX3t8Gxml
	eT/JNXZPUBy9skZH7SEab82Y5JHL8LMxCG4U89PSPmEB0hmTQQ4OJO19y2OQR9vf7aHPnA
	eeMZjAx1xCit9aOS1cF8Z3qGLz8NtjM=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-26776d064e7so9434735ad.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757954845; x=1758559645; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=59uH0/Rs24hPqNuUZQXolv8jQt8VsNO5VNNB4W0XCmc=;
        b=uyL3vyqx6nYuozKHHjay4kn9uAffGTJIfMbnm4FATap8epxmcXqfbnYYgMyyQCAVHm
         Daqd5k/M8qHepoSoCDKNLGYyksWTjAdqeIurqln23JhO2eqvDP9hR3GMYmc66ep5Exqm
         SZOIb8MOLauAI/fNWD152ovP4YQZ/z4TzeKXcL+00eVdf0DuCu0z4hi/rVbSEsZLymxa
         SXY9ELX0GobOyu8z+ws0PDf1DoPbYzdn+V5j//6T2csIFyAOcwqCeiS79QZXfcM0wjP0
         OHCK9Gg0TCWHIUMYD9xzGZqRbTqTNB28g9TR1FTQLVOHEBVc3D0PQSN7+apRWKVIZRT1
         E4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757954845; x=1758559645;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=59uH0/Rs24hPqNuUZQXolv8jQt8VsNO5VNNB4W0XCmc=;
        b=fiNe7hc3yX7152TZfk/JAbbRwXMlTvlmlj88yJbfkVLq/D6i+jjYF6SiLAyL2/IOnI
         1ulkyOmiml7DkDNRJx0CUq3VNFCO82UTsuyPnY86nJFl2qjoExINXvuTyHFQGp1IoCFn
         nieIlZwEG72pdZP4xkRXAg+X1jhpNouCdf7hXofZjsUZ08lbuagbDI5CVfzxgV/SeS4T
         h1wf1Lr3RwB5P7mo4V1aMHc0H+RlnEM6V1YNlus4+gXkgcoPvdfM4vErHt9LX8F8D/x1
         w5UX52Ev9mMhNPoy+A9w3zJ914pTPfs6O0mTH14emrM5YH2G/W0anJZcmBD1pUhloRXp
         urpg==
X-Forwarded-Encrypted: i=1; AJvYcCWGQE7VR5goB/HCKCRmWoYkfr62pMDT9V9g1r6zfubRk2QvARRh1h5wzVPPkXvLtF95VAKuujEfSA==@kvack.org
X-Gm-Message-State: AOJu0YwQ7JWQPj5fnVB3e57M7kFYYdbAA5YiYSPfnVcHLCXPpR7xVa7u
	K4SZO3DvcWwgdQZrKUmbKJACva4qPVJFA52/7kv1QOYWW8b6/gtm3AcyBTO/UrA1nETLvSfWVEg
	AttlMLC09iq6RP14mbSTMOI0D2A==
X-Google-Smtp-Source: AGHT+IHzc/fMWSswS4eA5+I14M9qXHKcg1jQwLLx5RpIwI8nZ9BGgFMV8dLNy7m9xz0Qp5xRzbGmEY4nirx7Uqh/jg==
X-Received: from plhs1.prod.google.com ([2002:a17:903:3201:b0:24c:b6df:675e])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d552:b0:260:df70:f753 with SMTP id d9443c01a7336-260df70fbdcmr125334005ad.38.1757954845285;
 Mon, 15 Sep 2025 09:47:25 -0700 (PDT)
Date: Mon, 15 Sep 2025 09:36:38 -0700
In-Reply-To: <20250915163838.631445-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915163838.631445-8-kaleshsingh@google.com>
Subject: [PATCH v2 7/7] mm/tracing: introduce max_vma_count_exceeded trace event
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7258BA0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: bagibhx79ionzfxy6ey4uxsjt3bymu9t
X-HE-Tag: 1757954846-731286
X-HE-Meta: U2FsdGVkX1+amGBWWf5ECRSJBFqoZ7wqxIlDMaQyL6Sxk8TgpAJyozLB//n51dYwDZVWvPGkKFSrsbGDPle7mjv8IsXKzmQLSXxWAHKJRoaIxoswR31MqF5BdzVCTaUi8WulRhS/7Mr179jsq669Ge5tP37vhO8sc0gHyTGsW3cgrk+UjZmrpBIT2Nt0rwpRoeQvBvo1hVuOfXNVdaJEatHz9OZMtSeMvGqtP8XXDj+mJ4VkbmZkjmmmkOjoJdIYh+oVofT34nwHEmNMOCSSc9KL2IA6QEXTJTxvRSfgo4dyf7TfCuBaF8VhyN7m+00VnVrq3+zBeXMrL4OLmhKiF6x+oo/cqltCP5ughkxGVd91u+9zLDovIOa+HQ7v12p2TR7IBIUREeLkZN3i9rrp9kCKfBShVVpD6XLQviWI12aNA4PzqELqAuub577ewMSVtFetXLhOVNc0tXrc3rWFvDws7Kjc7PQWMyJBFQOdoTFiib/pISZ4qK2N7Rk6JV8xyvS5wAJJwcYauZIAXo4R2FCJYkDJddpCEuWyNs3WI3o6o+zifKx5dpXr8rQ/VszQ+gi+EHqJ35GuSnuHQIX8ZKq+5I41WlWmFYnxOROlnZXboHDVIw4XIAL8+ElYSc7j2G2QHSd6mu+Ii3nbNprapJsAI1f7vGu9vzjFe194tDoHFNT3Ffw14ygB+EKFRCP4exGgTD5vxL07aoTyaWDfcE3uEhu1YQjVHjkgzJ2C97MNKmqS0H0l+ANjxbisnjF6xBrrhy/9ArnlF5fhi2gs4bwVTHxTQcxbast+JJZqUBWFj6PaHIcQM9aWArrZXmsrYPGGasc4OzyoSAnLY95AnKVpW7KskcWnDmj9VVRyKFaKo/jxBeErYpwYoRSbedmsq4325wUlqJtv+lhGwO9CHQo0b11oYloq+7XJpzL9uebPmzl/4jtF452JK+wpAfJj4qcxABvhlsZrooU79lF
 euE1Sqxq
 wfI7IGLmwe2/kh7fcWRFkpssqvpD0xMzAdOnJaDTVS5tpsu6fEzUKFyxRtX+ATDUyfUTOSsXCGjk769PdoaNFH2vxaX5nIwYb3uiL7zbG/8VvUMmpxJKsPCNmXeG5Vp7QmIbZ1THz2UZjdRLNWzqJmgspo739Ljfy39ywJNXRb0FL1hs+h5eqfb0XIBNbjo/K3aRSZopFBlDRhA4HW6I7i/qdk8u0lpgGF0bOwELmxJ6iVik/uFDP/uTfhCzpIp4FMDYEv/nqjR/TkXkoUnJqSlCFZjnfwoMr9p0F5cMMSFnD/umGrh69+h/4fv10EqHqVqC2qYNSusfWj8K/OgR0GfAygUSst9ofAGDBAw9Lx4TcV341E4UQEMLGwkPvPayk8elvpDnnGabcKbyxOfyxFKr033rbzM/gLCGHDNtujoEsOYgWa2SDEQ8SQxhkGnhb+1Tek52Fiv9l+Fsgkuc3RuMlYrf1h+qVnUuFC6VqOm6GlkoKIDuc/w69Hl5nf6GdrXFYli0kxVhATup43H/uv/28sd/udUv99dX87XmURGcXblAvhKA6bvW2JQnM+ceX4X+EwZQICqOmo2bBGIptPiuTsEkOT+AugayPwXbJH2gusw0LoZd6vBNJBO85C2aHAIWYRQjLY6Sgd8lS4MgYQ1LTYSHXC2rTLDg4+Nwwbcy8ZI2ms/MBJ7rLoQG1IEWAQa1WtG8lj4w7ivGnKSAYtX+Y/Kw3sLojS6VrCRO+/H2pZWcStS2ZrtAMh8rhhVxqmH6h4LOCai0kPMJxqtbYRoD1T7ec6EuvPJiF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Needed observability on in field devices can be collected with minimal
overhead and can be toggled on and off. Event driven telemetry can be
done with tracepoint BPF programs.

The process comm is provided for aggregation across devices and tgid is
to enable per-process aggregation per device.

This allows for observing the distribution of such problems in the
field, to deduce if there are legitimate bugs or if a bump to the limit is
warranted.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Chnages in v2:
  - Add needed observability for operations failing due to the vma count limit,
      per Minchan
    (Since there isn't a common point for debug logging due checks being
    external to the capacity based vma_count_remaining() helper. I used a
    trace event for low overhead and to facilitate event driven telemetry
    for in field devices)

 include/trace/events/vma.h | 32 ++++++++++++++++++++++++++++++++
 mm/mmap.c                  |  5 ++++-
 mm/mremap.c                | 10 ++++++++--
 mm/vma.c                   | 11 +++++++++--
 4 files changed, 53 insertions(+), 5 deletions(-)
 create mode 100644 include/trace/events/vma.h

diff --git a/include/trace/events/vma.h b/include/trace/events/vma.h
new file mode 100644
index 000000000000..2fed63b0d0a6
--- /dev/null
+++ b/include/trace/events/vma.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vma
+
+#if !defined(_TRACE_VMA_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VMA_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(max_vma_count_exceeded,
+
+	TP_PROTO(struct task_struct *task),
+
+	TP_ARGS(task),
+
+	TP_STRUCT__entry(
+		__string(comm,	task->comm)
+		__field(pid_t,	tgid)
+	),
+
+	TP_fast_assign(
+		__assign_str(comm);
+		__entry->tgid = task->tgid;
+	),
+
+	TP_printk("comm=%s tgid=%d", __get_str(comm), __entry->tgid)
+);
+
+#endif /*  _TRACE_VMA_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/mmap.c b/mm/mmap.c
index 30ddd550197e..0bb311bf48f3 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -56,6 +56,7 @@
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/mmap.h>
+#include <trace/events/vma.h>
 
 #include "internal.h"
 
@@ -374,8 +375,10 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (!vma_count_remaining(mm))
+	if (!vma_count_remaining(mm)) {
+		trace_max_vma_count_exceeded(current);
 		return -ENOMEM;
+	}
 
 	/*
 	 * addr is returned from get_unmapped_area,
diff --git a/mm/mremap.c b/mm/mremap.c
index 14d35d87e89b..f42ac05f0069 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -30,6 +30,8 @@
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 
+#include <trace/events/vma.h>
+
 #include "internal.h"
 
 /* Classify the kind of remap operation being performed. */
@@ -1040,8 +1042,10 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	 * We'd prefer to avoid failure later on in do_munmap:
 	 * which may split one vma into three before unmapping.
 	 */
-	if (vma_count_remaining(current->mm) < 4)
+	if (vma_count_remaining(current->mm) < 4) {
+		trace_max_vma_count_exceeded(current);
 		return -ENOMEM;
+	}
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
 		if (vma->vm_start != old_addr)
@@ -1817,8 +1821,10 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
 	 * the threshold. In other words, is the current map count + 6 at or
 	 * below the threshold? Otherwise return -ENOMEM here to be more safe.
 	 */
-	if (vma_count_remaining(current->mm) < 6)
+	if (vma_count_remaining(current->mm) < 6) {
+		trace_max_vma_count_exceeded(current);
 		return -ENOMEM;
+	}
 
 	return 0;
 }
diff --git a/mm/vma.c b/mm/vma.c
index 0e4fcaebe209..692c33c3e84d 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -7,6 +7,8 @@
 #include "vma_internal.h"
 #include "vma.h"
 
+#include <trace/events/vma.h>
+
 struct mmap_state {
 	struct mm_struct *mm;
 	struct vma_iterator *vmi;
@@ -621,8 +623,10 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		     unsigned long addr, int new_below)
 {
-	if (!vma_count_remaining(vma->vm_mm))
+	if (!vma_count_remaining(vma->vm_mm)) {
+		trace_max_vma_count_exceeded(current);
 		return -ENOMEM;
+	}
 
 	return __split_vma(vmi, vma, addr, new_below);
 }
@@ -1375,6 +1379,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		 */
 		if (vms->end < vms->vma->vm_end &&
 		    !vma_count_remaining(vms->vma->vm_mm)) {
+			trace_max_vma_count_exceeded(current);
 			error = -ENOMEM;
 			goto vma_count_exceeded;
 		}
@@ -2801,8 +2806,10 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (!vma_count_remaining(mm))
+	if (!vma_count_remaining(mm)) {
+		trace_max_vma_count_exceeded(current);
 		return -ENOMEM;
+	}
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
 		return -ENOMEM;
-- 
2.51.0.384.g4c02a37b29-goog


