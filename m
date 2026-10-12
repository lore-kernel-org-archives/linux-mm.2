Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9544CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D576B008C; Mon, 12 Oct 2026 08:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24906B0092; Mon, 12 Oct 2026 08:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913036B0095; Mon, 12 Oct 2026 08:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 612D86B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:05:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C56D21A0C7F
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:05:58 +0000 (UTC)
X-FDA: 85313845596.21.3974D7F
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id EBD96140002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:05:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nLUXLLaz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791806756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mm12iLYNj8dHfuhY6D2/uuvm2SSZhahDIiqNgtVt6Cg=;
	b=RJBIvzUCPHHLqOQb2/7lmoUNlAOqQcTCOy8azyKABgX47gIamxKMhprWClKiCds7FFZuaS
	aB/YOYq9S2E23BjxAzr2cz21GRsYoGKDmkFRCGxKs6GP16Hetivcb02YYsLYZLR7TRbfc6
	7VFWysngzfOoX0OGLKJAcHwO1OeAaEg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nLUXLLaz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791806756;
	b=d9FdteXdAIzWI8k5BpCZt4Tzuqp7oclv8wcjEPe2l9Al3C+TrI0nqphzew2zqbE6D/f6PH
	Fe4p4xm+0KBnI1LPHOTDjXcprgEjHxU9Q0LE0qzfMlcoelW6yuctAksATALvuW9PEFTiwA
	DsCizNqjIOY/5iJrNvQygEHQTwqX8dM=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3aacde0cc0fso660635a91.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791806756; x=1792411556; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mm12iLYNj8dHfuhY6D2/uuvm2SSZhahDIiqNgtVt6Cg=;
        b=nLUXLLazJCMZ7qyfN1cgl9iclSfYCtTBoBLM/mq8pQUoW2mdAqIky27o8VaZY2h54M
         BvVXHMu1JfK1VMEl7JPrIrrJZYAwV6p722MEvUFHMYzk33bnGvepxTgQ80t1m7zctteG
         6pG8uJlupKY9WQL2fyWuAEcaKwPK4A1s8m9KQ7l0/4bMWOv2akZO3XpPlW07ABYQdqKG
         GS1hLq+SOYMO653J8BORMC2H4Z1OIF7IVJHuARrsDMsSSF86wDLYLRjo+FuViyepr48Y
         50SOWvn9xd8TqCGHJOvbyJhRNULz9UP/85tBwwrIDdSAWyFmPCURUZtPsanHD93fdCzS
         JMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791806756; x=1792411556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mm12iLYNj8dHfuhY6D2/uuvm2SSZhahDIiqNgtVt6Cg=;
        b=UDJDYJwdYASYG6QFPq/WUnGdXSgj3kRulnT7R2pgvOwBNKRjBTN5mcVZYLzgPeEVc4
         7oVxG6wNKMXa2FjXwafCobJz5Hr/CVtZCkYwjyWzSRnzDLt1tBZaxG4hGRvJtmxmzmLw
         R6UE9ewygkBBMQS0TmA08C0ZtvW5VbzY8aUkwV8KAAtClRfNDV736kKR1jvvcJKLGHX6
         EDnIgB+XONnUk5Jk/9Oh9fIPcBxf9UJgLd+J0s2MYDSekZQmxoMDuw5l9NlKSSs7Emay
         zxNHfZ6Ej6lWJ72aJzGKEuyWB8qr1CINpW2NfKnPt+EE4A5uO7aErtFheM6OW4WCp+2W
         1P0g==
X-Forwarded-Encrypted: i=1; AKwUvBzm+xHAOAtGr/oW0ulEveiwlPp2PM+S7TArwcGXhScVlcPmI4oJLe/OeSmpJgfXiu14vCBEUScDBA==@kvack.org
X-Gm-Message-State: AFq9FYIp4vdYmKu4H9twXzHAhkbiRcx9OLWoXJ/T4aXSpF+F26+F2Aqe
	hygu3aJ3RSxS6B8cp/YeN8duSm0UQCb+NPGaW1vbSQglL8iVY5t5Egtn
X-Gm-Gg: AYBFou060Vjsug5mhPj2c6tT82EyKHQlK8eOQLETZn9zUmaQA98m11gIYW/RhTTDMJX
	mZM/r8O9czRtJQpdFrxl+DJz3MH0LDRIqMvpCgIGI3Lt5NBJfSH3Ctd4WyxXccen/39DRO3OJ4T
	NKpAlseRTLODIV3mDUNfGMeatrSPD9duLBEHcuuYt3vAr0kLbRqas8KsLAennqn+gsVZOVocrdv
	8IHJvW5B/oRZhboP6qh9xKbn/DXsXBKC4APtGxCknUQQ+knnoSK6uW0XZ3UBPVQP16p/NTOwJxV
	S7bajXbT5YI3WDORQfA+zAwfULOg/HowdVW7gVWPwHSyvIuaQHMgV3n1TJmnzWRyCrwAkztKd6q
	4jRS9BUemb5Jz9xcfn+gxFRqZjM2nXVfa05rrsIibEytFmE5BVaDb1srg1I4FJ5/7US/+dDJ1gZ
	ipoTSxY71NzetPljh1bEgaRot9AoB0sBo60qjLr5msmdH+UGastPL8iuVSDAaou90Kn6SLz/UYX
	oBjgr1FXMAdJ76ry16hiGTgeWUxum6X6340BrcDuSLHRg==
X-Received: by 2002:a17:90b:224c:b0:3ab:2ad1:f10a with SMTP id 98e67ed59e1d1-3ab3a0ef48emr6942972a91.0.1791806755712;
        Mon, 12 Oct 2026 05:05:55 -0700 (PDT)
Received: from yafangs-Air ([101.82.170.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm15722454a91.16.2026.10.12.05.05.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 05:05:55 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v2 1/3] sched: add helpers for numa balancing
Date: Mon, 12 Oct 2026 20:04:36 +0800
Message-ID: <20261012120438.52849-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261012120438.52849-1-laoar.shao@gmail.com>
References: <20261012120438.52849-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EBD96140002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: hx6p19hi6tcnwkunnz31ff1jjd5xexrk
X-HE-Tag: 1791806756-236639
X-HE-Meta: U2FsdGVkX1/kq0gxNb4fR1SOHPu9MJnETkzqlFuPs2q6Hpg7XQVDKyPmzVTlxvAi1YhjGnITmO+SZCJi460VQVHAThIoUAN0fMStre9B11llBIn0h8rD5NmznKA11lsVuaFakfp1VlG09HBwSM7GGwzgOB1zHhN0H8jEix61lO0EANlRUbLS8ZAAF4e7Es/EbogfEbUQXktRrGQEAheNljxHfrQ+kuz7gEGTCgMOPu1hbD7x2aH0lbwOP10iWiBb1e909Ghnq0jzjH3Z3B/RfsVyNgZcA/E3BIyuC8Nwq0z3Yq4esS97YjRESPvVbZG4tkZ9S9saqTtCDcM4oX+XjVVSKRiwwQsLhIVBZTiP9SYNLC+L5oX2XDH7FLYNFfFB74HXqnAyfSsxkBws9ullIFTyGDKPETqMhKXf48VHKoM2PY4LGIX7GXklVe6iDJIHnNJn5vVuJ04BruD8icQPMA8Q3rGyRM0Q17xNZe1FcZtmHQYeYQQhKXyK2XboEyqCHL9KChDtTDVi1WcFgYWzpiOSn3LxMlSqs3YmIE6kcQ2hXd3s8b1N9Fbl/yQM8ZO7QftsHqscu+xGqMEq67wLrhOVOCSFU8K1zHmEohSCMfcgMUP31oiE9+8E18541uI8C0enVoqTUJUgR+SqHuu9xtK7jnZMWzx21Lpb+dVrWskRwl5801y17urIqbcBBa0Qf9wt9CRQKcmzjuMLCi4xWmN6COrAZNhRXGPpJT4eiooW2LsJCClKcgxSub1Fxx0iyRMhXG1DA9AwwoqOSyicgoyWNWu93Rw39AUHcS/Q5d8oCoic0PhLE5nd2NqJqFm1tHQT8mf/VLNIs6Uqc/xnsS3AiNENjt6iU77GH1Iwa/kiyoSc8TrmZydLC3eAz+ULkfQU6vu/6EAhcrMV3+iObRGuedGC0LoFxi9+zexCPMb7EpEai3w/LVjsi4TJ/WtA61uUVn7pFX5P7YGB7Wb
 Ow+EGTYB
 zhGMeOADqKq6lQeIyMHPPibcqrMD6eV+v8w8H1biqCSKtZark/kM2C1oLHVuwCm4/N2GdgF9kVS18ninD+/O2I/PYOwinJpPrvEgq3keikdSFi4tSl/SNqT323guduh+mgqQhAEk7RMts+FzqkBTbv4pifYNunjPm7t8bQiOcPjdu1pzzQswsJEpzFfa4CmQRGZJEMRbsdNOtLix8223KrOhEXGjlPiQCzBWaq/RHwSHf0I0S67GNTxSjPfCvItAP0XICHiI2TOZncM4BMYhoVfvW3yd4S3XRaMQi15DyKLK6x2hM1VvaTcSEIMtloE8N4vHnKbdBIXHmDMaIrqIZqJqf/arTWMh+FybdWkG0REym+b2RP86WUJZ8LhlfqOKtNxqe+O1yOFVxpOoKHwFPhcotlTLDPzeFS9ssQQjSvsyhk5isDty1azmApkKXITkJXVwke4Py0FVAkKFAzrdK1QD+XepEbr3SxoqEEpcz6k5SIQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two new helpers task_numab_enabled() and numab_mode_tiering() are
introduced to replace the scattered direct accesses to the
sched_numa_balancing static key and the sysctl_numa_balancing_mode
bitmask.

No functional change.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/sched/numa_balancing.h | 31 ++++++++++++++++++++++++++++
 kernel/sched/fair.c                  | 16 +++++++-------
 kernel/sched/sched.h                 |  1 -
 mm/memory-tiers.c                    |  3 ++-
 mm/migrate.c                         |  7 ++++---
 mm/vmscan.c                          |  6 +++---
 6 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 52b22c5c396d..353772b49c5f 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -8,6 +8,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
 
 #define TNF_MIGRATED	0x01
 #define TNF_NO_GROUP	0x02
@@ -32,6 +33,28 @@ extern void set_numabalancing_state(bool enabled);
 extern void task_numa_free(struct task_struct *p, bool final);
 bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 				int src_nid, int dst_cpu);
+
+extern struct static_key_false sched_numa_balancing;
+
+/*
+ * Whether NUMA balancing applies to @p.  The @p argument is unused for
+ * now: a later patch will consult a per-cgroup BPF policy with it.
+ */
+static inline bool task_numab_enabled(struct task_struct *p)
+{
+	return static_branch_unlikely(&sched_numa_balancing);
+}
+
+/*
+ * The global sysctl state, for the system-wide tiering machinery: this
+ * reflects kernel.numa_balancing_mode only and takes no task.
+ */
+static inline bool numab_mode_tiering(void)
+{
+	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		return true;
+	return false;
+}
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -52,6 +75,14 @@ static inline bool should_numa_migrate_memory(struct task_struct *p,
 {
 	return true;
 }
+static inline bool task_numab_enabled(struct task_struct *p)
+{
+	return false;
+}
+static inline bool numab_mode_tiering(void)
+{
+	return false;
+}
 #endif
 
 #endif /* _LINUX_SCHED_NUMA_BALANCING_H */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 57360f5cdde4..45086e6f246c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -39,6 +39,7 @@
 #include <linux/sched/cputime.h>
 #include <linux/sched/isolation.h>
 #include <linux/sched/nohz.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/sched/prio.h>
 #include <linux/static_call.h>
 
@@ -2963,8 +2964,8 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
+	if (!(numab_mode_tiering()) && !node_is_toptier(src_nid) &&
+	    !cpupid_valid(last_cpupid))
 		return false;
 
 	/*
@@ -4194,7 +4195,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	struct numa_group *ng;
 	int priv;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled(p))
 		return;
 
 	/* for example, ksmd faulting in a user's mm */
@@ -4206,8 +4207,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	 * node for memory tiering mode.
 	 */
 	if (!node_is_toptier(mem_node) &&
-	    (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ||
-	     !cpupid_valid(last_cpupid)))
+	    (numab_mode_tiering() || !cpupid_valid(last_cpupid)))
 		return;
 
 	/* Allocate buffer to track faults on a per-node basis */
@@ -4665,7 +4665,7 @@ static void update_scan_period(struct task_struct *p, int new_cpu)
 	int src_nid = cpu_to_node(task_cpu(p));
 	int dst_nid = cpu_to_node(new_cpu);
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled(p))
 		return;
 
 	if (!p->mm || !p->numa_faults || (p->flags & PF_EXITING))
@@ -10697,7 +10697,7 @@ static long migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	unsigned long src_weight, dst_weight;
 	int src_nid, dst_nid, dist;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled(p))
 		return 0;
 
 	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
@@ -15351,7 +15351,7 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 	if (queued)
 		return;
 
-	if (static_branch_unlikely(&sched_numa_balancing))
+	if (task_numab_enabled(curr))
 		task_tick_numa(rq, curr);
 
 	task_tick_cache(rq, curr);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e656c7059bf8..38e21c8c57dd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2465,7 +2465,6 @@ extern struct static_key sched_feat_keys[__SCHED_FEAT_NR];
 
 #endif /* !CONFIG_JUMP_LABEL */
 
-extern struct static_key_false sched_numa_balancing;
 extern struct static_key_false sched_schedstats;
 
 static inline u64 global_rt_period(void)
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b..ec7b9aadda98 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -7,6 +7,7 @@
 #include <linux/memory-tiers.h>
 #include <linux/notifier.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/numa_balancing.h>
 
 #include "internal.h"
 
@@ -64,7 +65,7 @@ static const struct bus_type memory_tier_subsys = {
  */
 bool folio_use_access_time(struct folio *folio)
 {
-	return (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
+	return numab_mode_tiering() &&
 	       !node_is_toptier(folio_nid(folio));
 }
 #endif
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..4d2ba87eaa34 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -41,6 +41,7 @@
 #include <linux/ptrace.h>
 #include <linux/memory.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
 
@@ -818,7 +819,7 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	 * memory node, reset cpupid, because that is used to record
 	 * page access time in slow memory node.
 	 */
-	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) {
+	if (numab_mode_tiering()) {
 		bool f_toptier = node_is_toptier(folio_nid(folio));
 		bool t_toptier = node_is_toptier(folio_nid(newfolio));
 
@@ -2718,7 +2719,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
 		int z;
 
-		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
+		if (!(numab_mode_tiering()))
 			return -EAGAIN;
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 			if (managed_zone(pgdat->node_zones + z))
@@ -2770,7 +2771,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
-		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		if ((numab_mode_tiering())
 		    && !node_is_toptier(folio_nid(folio))
 		    && node_is_toptier(node))
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..af46869bb15e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -65,6 +65,7 @@
 
 #include <linux/swapops.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/numa_balancing.h>
 
 #include "internal.h"
 #include "page_alloc.h"
@@ -5029,8 +5030,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	if (!current_is_kswapd() || sc->order)
 		return false;
 
-	mark = sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-	       WMARK_PROMO : WMARK_HIGH;
+	mark = numab_mode_tiering() ? WMARK_PROMO : WMARK_HIGH;
 
 	for (i = 0; i <= sc->reclaim_idx; i++) {
 		struct zone *zone = lruvec_pgdat(lruvec)->node_zones + i;
@@ -6974,7 +6974,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		enum zone_stat_item item;
 		unsigned long free_pages;
 
-		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		if (numab_mode_tiering())
 			mark = promo_wmark_pages(zone);
 		else
 			mark = high_wmark_pages(zone);
-- 
2.52.0


