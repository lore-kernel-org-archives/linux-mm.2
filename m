Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2793D2D0E3
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE036B0089; Tue, 13 Jan 2026 07:13:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46ED46B008A; Tue, 13 Jan 2026 07:13:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37AE56B008C; Tue, 13 Jan 2026 07:13:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 244A26B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:13:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D3FB1402E4
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:13:02 +0000 (UTC)
X-FDA: 84326829804.17.C1AB110
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7AA43140002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:13:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VccR2Tfw;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768306380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0CR8k0pTAI0hGNUsgPy6QCqv5Ph7dVkX9F3Lq2Xl3H0=;
	b=2LE6tzzrISy18xCzPcDd5L+HdW7NDlMk8kHD25Zd5zzahyAwxRjWqqLqLUR8LJ/Zuj0MLM
	+R4SgycGdq1D+bAJGXs/dnWolh4tfWNDTJGLlKLTgvwaWN4ptJ/U9u6Zw2AlDMhUWWJiX4
	InYdCQR2BmJuJBXxA9PRTfSzdwxGnkw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VccR2Tfw;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768306380; a=rsa-sha256;
	cv=none;
	b=EBmK9FUjcLE5PTKuQWUw6TiVSY1yLtyCMQynGVUHkV5i2EvoRWOndEsCTWFtw4WsjHpbP0
	hbHlCPcq3ToE8j0T4O+YD0LOabxvHm7dE3tpQOKlTmFHZObWE0h0Ta2Skjr/j9pYrfOsK/
	vCjIUr5xieNPlPVluh6TJRGIzWVNY3U=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-81ed3e6b8e3so1614351b3a.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768306379; x=1768911179; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0CR8k0pTAI0hGNUsgPy6QCqv5Ph7dVkX9F3Lq2Xl3H0=;
        b=VccR2TfwgCdSkqUClmstvBozpHEEIP7uU86YPkJ4yGDrucXN23G8uPgUK/F0T/Ppia
         GRQkr4v4x3HtP/fbnhbnK+8IJTfItBZCcD06mxDSH6Wuq7H6tAg5FunPp7BUBwnJ3gu0
         NamR3grebYqXps3cxS9xkkyPEQI/PhJFcShPyxVDb7qrtvpTuU/oLbFQQ9jLOXnUJQKk
         Hv4hgFuO751r40X4TM7lfZDtVm+VoGEG3wlMx6kCQ+UnWDK3GcxweAwYdoMZePG0Ueg1
         SVve+DiDF7xnAu8Xbir3n+9P1KNoNmGl89064xhrbhA1taNRpVrbxIv/phybiLoacW43
         yRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768306379; x=1768911179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0CR8k0pTAI0hGNUsgPy6QCqv5Ph7dVkX9F3Lq2Xl3H0=;
        b=gknhtCeWv9v4irxsT12Ua+hEiiZsU4xmvz2YyH2RCASfkP2lp35fuMZeXCzAWhm9gc
         FChDZ1bt/NKCDWRZ43i/1soDOdPJ8y7A3aSFZgb+yAOJrDx05VYCbIUBOY4rP5zbvHtO
         jTBtOHDd6BrU6iEgGDVMh0FTe1+cH/OQGVwT4sc/1nkmbwaE42rSeaXIYnkPakAbOrZW
         OcPE/bKY15s1iteX0FyyhnCxQmIKq3sFlc+BV9mPbmP4hBFnoWNNUuLuLN0s+OpU8ea/
         2U0VGPaTsQnLzU8cUDvAlR5YVRCd/fp9pXN0Kk7ggTfSARyKnvcbgTjw4BnSEb24F7vE
         bVxw==
X-Forwarded-Encrypted: i=1; AJvYcCWaCRW5qal61ji6rxN26RHMO6naxRDkScz0ezsZTb+ow/u2jhCWN/blfVQAf0eXjvoW4U2pZ2PgWQ==@kvack.org
X-Gm-Message-State: AOJu0YxYp0UNrf6YyNBx8ZbvbAxIuXF11b/7T97TIVTPeDMltKopnJYw
	3jLKQSJP+1qR9c9ZKvgQDKUxZvnFKhHlSJLLtxc41Xi5/zmpoH0Vx30h
X-Gm-Gg: AY/fxX6RIWn5r9arHv9V/7X8uveKX9wTStlHD/N/FuM4cPS/FFAmdLEIlu2W4DSAd07
	QFEG20mUCk3JZQJ9UYvjhPrPOrBpkwa+mZ3pjlcWGxgypAgXp9fI2X1E5MESQljw1GGBtr6ZxRf
	mOessu1qUy7Lq5aDOswh8FT8FTIDfPeKJLxqJfm6OppNdlntNWdDs8Q4JC9yZ4Po80qLCZYslyB
	BqgWhjAG3w72PzPaXQL7+e9bHB9Z7h8hPDfGtuwPCkQXW2StU+JTqtbNU67FfkJWVz54ecmC+3P
	z8NF5VPDQGAHpltujL8RZNbFBgG/kPJ/IfxpQ/Z2y7RFS6w9ZPYVkRo8OivFOdb+l2rCeIGCZD5
	YtE19Rrgy62+pRTtkocNf15BzYUXzrmXi9eyVI/UZEOqrd+leKZELulRL+SL/GEcg+jGa3+t///
	lgStCoqV5ZWvfs8k8eXvfSKpiv8tuJwPLIl7NU8f/ayWo9NuMBzhh74Sk=
X-Google-Smtp-Source: AGHT+IG0J1J8i4JW8r6X8gc354XKnnX74EUP/eXr+s6KgXRsgR4zZ72avJxBpsfeA9EuyLQWDSHFfA==
X-Received: by 2002:a05:6a00:430e:b0:81f:4cf5:f252 with SMTP id d2e1a72fcca58-81f4cf605e8mr7205461b3a.24.1768306379241;
        Tue, 13 Jan 2026 04:12:59 -0800 (PST)
Received: from localhost.localdomain ([2409:891f:1d24:c3f5:8074:4004:163:94af])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81e7fd708fdsm11596703b3a.65.2026.01.13.04.12.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 04:12:58 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: roman.gushchin@linux.dev,
	inwardvessel@gmail.com,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	mkoutny@suse.com,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 1/3] sched: add helpers for numa balancing
Date: Tue, 13 Jan 2026 20:12:36 +0800
Message-ID: <20260113121238.11300-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113121238.11300-1-laoar.shao@gmail.com>
References: <20260113121238.11300-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wrdeqxokcepo7zpfngjtiubxad9oke6g
X-Rspamd-Queue-Id: 7AA43140002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768306380-665658
X-HE-Meta: U2FsdGVkX1/8nqS4mlc+uLt8kExZt0OA4dhym8kNrG2ANBF5wXMZ2emHZFI9QH79pdfEFFxmrXVnQOjQSQLSOLggIUefP/fXlORFVg7tVLijj4fktFWIbQC7OVm/XGdrJAX8ZUzzf+rtAvKQclM+A9I7zFAfIN0Eb0QNxffmDg+H8nT/6i231fWd86bGj5CR+EzW2OUKGE2M31r3Gcuwu7BTbBJd5KDSWxd0pye/7/l9fImTSLyvu0nDuVJRcQCL2J+shO12erx+SnYAoSgSWMa4bTLKHyi5F3qafOLw507tgy/GeaOpCCzKPwHTl5RIaqVasQPlabfDGa38YwWOYeU2m0fMSgkGoFaWhKF6XYkS2Iutwm0Y89t/geOrSISnWBsgv1LvF216dtXzz304Oj4B5Ns46HO7SzuK12ov/ywRfNRPRyDAuXm24fKG8Sq9RP2A1jJRX7KdbZeUdDOmbMd6dvUN7rsV6sX57wYHWUGlupecSy1QkqwODhLRdKuHbUkRgLvDTZIfiEz3tI3QGoYZ/36zsw+yILOWGRL2jy5bNUKPmvrsB4gfYHMw3/tYW5UjJ5+/tuQHcrx/BotVmRBneewJ9YD8bXd6JjkuEXwoTsIvnMbYSUx7bGNhPmqQygx8wjKaddqWHJEdRncJLcT8rvQymsdiSJX6st+b+R9cTF5SchL1DwGRD7dlZbT+8I1Feoe1XAG/cclOGubNbqPXlWR1I4k6vgmpE54c+yDMVjVrSuPmkbArqT+qQJ0Be8dAWQqAKrWFkBCaB0qcOuq28FYZ4O6i/AsiLl+G5Z9uT+Ut09TmL3AnHR3v8FV3Ne4tmOU1gLGD56bCZhV0iQjTJk2qrXIsnkTr84zhm0Bmzy6N5gDBMiUnouj+IckZWvJMKfMVCsxLvyktfT55fB5tblLwqVCnqBfbewvKXdyu/uF5w4HGXZt9nQGo7VT/i3F4rbjVq9Dl8/v0La8
 9Lh+ob/T
 +aysTxV5f8yFfiH01apILosHIZTC0B+ke7/5SMYcK0HyK4su5p191v8KR2yOO0Hn7uuB6Zjk7P7T0Y0f1Sl3CbwmRcLU/uECHp+TRP0ioIbRqoqKTfCDXzQdGz1dorl2fNMdieHtiktwm+CNwdGWvsqrhmK7ihu+zZmPa5ibff0vGFnGeT0NEI51Ksu+/ZaBdy50ry/y3e3TCZ+k3yClTR4Dzeu1X3rfLeiz6pSFb8fNZBBzIPT4UMOrZCCrdjaEOL9E+cQevSptBTAB1M9R0/jXyeLbeXv7NlRPN/jzKHYkcu2oreeUlATj1DZBpvk71984G9ZsQROkV/gW3UQGBcr4I4aOZF4IjwopSqrv3mKWBUt+kYtFQJhBkTnqKgCgUYJFvoFsc/zBW6zy2IjhLh6dswG7yxg70AHCSuuwzNbOV9GKxB8dgME82/j0RmWA3I+T3cWjFFJEtTf6fOqgHJiDvffMmc92xEhAHOKeSKRL/21smevaVM4xqImNrFw4aVOl7erAmYMDqm7WSYggPf19peYqE9DduyMHw/Gg52EPxFctlJz2MkX8F/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three new helpers task_numab_enabled(), task_numab_mode_normal() and
task_numab_mode_tiering() are introduced for later use.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/sched/numa_balancing.h | 27 +++++++++++++++++++++++++++
 kernel/sched/fair.c                  | 15 +++++++--------
 kernel/sched/sched.h                 |  1 -
 mm/memory-tiers.c                    |  3 ++-
 mm/mempolicy.c                       |  3 +--
 mm/migrate.c                         |  7 ++++---
 mm/vmscan.c                          |  7 +++----
 7 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 52b22c5c396d..792b6665f476 100644
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
+static inline bool task_numab_enabled(struct task_struct *p)
+{
+	if (static_branch_unlikely(&sched_numa_balancing))
+		return true;
+	return false;
+}
+
+static inline bool task_numab_mode_normal(void)
+{
+	if (sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL)
+		return true;
+	return false;
+}
+
+static inline bool task_numab_mode_tiering(void)
+{
+	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		return true;
+	return false;
+}
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -52,6 +75,10 @@ static inline bool should_numa_migrate_memory(struct task_struct *p,
 {
 	return true;
 }
+static inline bool task_numab_enabled(struct task_struct *p)
+{
+	return false;
+}
 #endif
 
 #endif /* _LINUX_SCHED_NUMA_BALANCING_H */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index da46c3164537..4f6583ef83b2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1932,8 +1932,8 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
+	if (!(task_numab_mode_tiering()) && !node_is_toptier(src_nid) &&
+	    !cpupid_valid(last_cpupid))
 		return false;
 
 	/*
@@ -3140,7 +3140,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	struct numa_group *ng;
 	int priv;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled(p))
 		return;
 
 	/* for example, ksmd faulting in a user's mm */
@@ -3151,8 +3151,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	 * NUMA faults statistics are unnecessary for the slow memory
 	 * node for memory tiering mode.
 	 */
-	if (!node_is_toptier(mem_node) &&
-	    (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ||
+	if (!node_is_toptier(mem_node) && (task_numab_mode_tiering() ||
 	     !cpupid_valid(last_cpupid)))
 		return;
 
@@ -3611,7 +3610,7 @@ static void update_scan_period(struct task_struct *p, int new_cpu)
 	int src_nid = cpu_to_node(task_cpu(p));
 	int dst_nid = cpu_to_node(new_cpu);
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled(p))
 		return;
 
 	if (!p->mm || !p->numa_faults || (p->flags & PF_EXITING))
@@ -9353,7 +9352,7 @@ static long migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	unsigned long src_weight, dst_weight;
 	int src_nid, dst_nid, dist;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled(p))
 		return 0;
 
 	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
@@ -13374,7 +13373,7 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		entity_tick(cfs_rq, se, queued);
 	}
 
-	if (static_branch_unlikely(&sched_numa_balancing))
+	if (task_numab_enabled(curr))
 		task_tick_numa(rq, curr);
 
 	update_misfit_status(curr, rq);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d30cca6870f5..1247e4b0c2b0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2269,7 +2269,6 @@ extern struct static_key sched_feat_keys[__SCHED_FEAT_NR];
 
 #endif /* !CONFIG_JUMP_LABEL */
 
-extern struct static_key_false sched_numa_balancing;
 extern struct static_key_false sched_schedstats;
 
 static inline u64 global_rt_period(void)
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 864811fff409..cb14d557a995 100644
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
+	return (task_numab_mode_tiering()) &&
 	       !node_is_toptier(folio_nid(folio));
 }
 #endif
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 68a98ba57882..589bf37bc4ee 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -863,8 +863,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	 * Skip scanning top tier node if normal numa
 	 * balancing is disabled
 	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-	    node_is_toptier(nid))
+	if (!task_numab_mode_normal() && node_is_toptier(nid))
 		return false;
 
 	if (folio_use_access_time(folio))
diff --git a/mm/migrate.c b/mm/migrate.c
index 5169f9717f60..aa540f4d4cc8 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -41,6 +41,7 @@
 #include <linux/ptrace.h>
 #include <linux/memory.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
 
@@ -802,7 +803,7 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	 * memory node, reset cpupid, because that is used to record
 	 * page access time in slow memory node.
 	 */
-	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) {
+	if (task_numab_mode_tiering()) {
 		bool f_toptier = node_is_toptier(folio_nid(folio));
 		bool t_toptier = node_is_toptier(folio_nid(newfolio));
 
@@ -2685,7 +2686,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
 		int z;
 
-		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
+		if (!task_numab_mode_tiering())
 			return -EAGAIN;
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 			if (managed_zone(pgdat->node_zones + z))
@@ -2737,7 +2738,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
-		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		if (task_numab_mode_tiering()
 		    && !node_is_toptier(folio_nid(folio))
 		    && node_is_toptier(node))
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..7ee5695326e3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -65,6 +65,7 @@
 #include <linux/swapops.h>
 #include <linux/balloon_compaction.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/numa_balancing.h>
 
 #include "internal.h"
 #include "swap.h"
@@ -4843,9 +4844,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	if (!current_is_kswapd() || sc->order)
 		return false;
 
-	mark = sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-	       WMARK_PROMO : WMARK_HIGH;
-
+	mark = task_numab_mode_tiering() ? WMARK_PROMO : WMARK_HIGH;
 	for (i = 0; i <= sc->reclaim_idx; i++) {
 		struct zone *zone = lruvec_pgdat(lruvec)->node_zones + i;
 		unsigned long size = wmark_pages(zone, mark) + MIN_LRU_BATCH;
@@ -6774,7 +6773,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		enum zone_stat_item item;
 		unsigned long free_pages;
 
-		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		if (task_numab_mode_tiering())
 			mark = promo_wmark_pages(zone);
 		else
 			mark = high_wmark_pages(zone);
-- 
2.43.5


