Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C4B606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ilu2jzRj
Received: by kanga.kvack.org (Postfix)
	id B278D6B05B3; Mon,  9 Nov 2026 22:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6CF6B05B5; Mon,  9 Nov 2026 22:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED0E6B05B6; Mon,  9 Nov 2026 22:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF056B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:29:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 667A5140872
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:29:49 +0000 (UTC)
X-FDA: 85417780098.26.D903298
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 986BB40002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:29:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ilu2jzRj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794281387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CiQU8Ol4JXLsovxT69Zshs9sbZpZnsM4NsuiwfxRUXk=;
	b=MBkK+5JKpfCrcnSbZ5FpmGOAqdjE/1jVwMjTymqBSQK29DgcUaTd9J6PMKTlDqKPiUjnmk
	WG5ocHlKESxVimh86ikLq3bvowWIagfXr+BStSzFnNTD8M9+9Y8/Q3g7oHoJqhAFUj0bUr
	qU/yRvd2P7tvJ06rezU5HyhxbvcfyR4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ilu2jzRj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794281387;
	b=Ii7YkAtSLR4rBVHflvqF+TXufA8cXar63s7UbGYEQa6Q5n5bLvLF3/iMPd25h9i+0OQ8J4
	JTl+BnGdx033Ui6i/suByF/Q7Pv/o1CqEZHUjB6ejTd+j2KYaTI89EwdEDoRR2v0e+1sjm
	eTdpMWSNEaMBZjYrhTUI4c3UFFrAyOc=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8b904d10882so679737b3a.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 19:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794281386; x=1794886186; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CiQU8Ol4JXLsovxT69Zshs9sbZpZnsM4NsuiwfxRUXk=;
        b=ilu2jzRjiHP2bSYU5mKD1oxyJ4qPqCXmwbU5NbwU5FQ73OoB2gn3iwUreYE0Nrj0jl
         dAOgRK3gavhBZ5s0Y5GRcu5xjbruOSv2akAJmhznQyuzFzFAnon1DPTkj/uR+D6jiAJr
         I9NNgr/I/iigONxwveU/BgdkwEk3jiZ7kqJxi3fhWzGX1gqJ8Jr0n+eoHNnGxrMxkx7w
         LToH5JYy/H8yFbNkk7hLlJxOrwhRHorIMPJRyMDWqSpnJy8F33CBKBvrNzDlUEfkVuAL
         kCXXHMgDsPtGfL4K6936ls9BLydEsDhJotVf/vQZ/9aUUZRoHnt8Q4mpythUUCFPsLrs
         FNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794281386; x=1794886186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CiQU8Ol4JXLsovxT69Zshs9sbZpZnsM4NsuiwfxRUXk=;
        b=lUtxNTwpkN49UQca74qmAJxTEaIBe3WDN/SC+1/ie0KiJ670k/3QFsrtev+ftjJJph
         NIHwbeMckZZyrNqvlN4piaAI7aAuksoCtZvlpOxUGdFNd1dn98+DH99Oz+ZqYuS7U57x
         JDsARInPS30IIhDppsMcVknVpqAknM167D4HGloMJych5HzYoNHNwRqCCRh/2jjzMFPp
         sPUFsDsw09HgMJj1VBH7syfTNbDxW/9p+5T2O4jDzn0yU98+7v4CAmiudfEvcbm1qsdb
         Jj/6cLDziNRCr23u7eZj4cF4hidQPTjHkZWkPDI44OmvQ3Xq5PhCawcwxk+ULy51XC2W
         2r6A==
X-Forwarded-Encrypted: i=1; AL+hErF3opSC4+do5o8mNMdFu+91cvtjymCBuCqpPUx51k0neRDsXqFqzqiqLzD2GtCjtGPI304PkSiG6g==@kvack.org
X-Gm-Message-State: APuU4Z8JU3pe/WKUDcbBR0UHiaEpJVfT3TTQI6wX1YrvHY6fgac5M+tU
	RX5g8LGFksGtM7LlA+5hN3JUEUeXhUfUAAR/+WirI7HziFataMkMD5SO
X-Gm-Gg: AYBFou0qjXp6K15t7xYszZtjMTE/ubnfFIp9rlw9X9qJ8oYq709EBdwmyx8AErjA+O/
	hhFD9eMZJyiaznI6gE2R/IKosHMF0oUKPaROYZVrwrAhdHmFTrGR2hsusbla8e5E13JsX8/2yCP
	Ny61Mh6PTHgTMxwq7NILGGhN1UpzYA0W/TQiBMBbt8d0lQEulD9+mo0LEQGYRjM8PZs7aMqsPEk
	xF3PPOaYQcBH/VesR+x3C4ITh32MWhqeTuua9oIJ0WXeXuZjysj7swg4GHHGlix3cz5U7f97OJ4
	QnfFSvk9e/SdwMdSvWwBgjAOTrG49/ECLH/pqr+G533FC+D3yj3+3Pwdgl5TEb3urJ/dSR3ENn3
	d3qHYdMJWt4nH+gRpHEUi66zAszf0po+Lhr+evJkV1btr8zmhsPiCZwmfKOP9jbfsU680enE+An
	udWGWqFjd/i3Eh33NQnXDOAPl3jHFOGE/0/9D6cFP6NrIHzgpjgnT9mVu1B+VVvFDcaZQPu1+6t
	LlUqp/lXe25FRzVr9I5W1QvCjxgVolHkOvS716U3et1irNB8ZIxZzrcwprfZZJIOQCPanWlGfP3
	NOGi+1pPNXMzfSqAKW9mEOBZdBpSHmtC3bd20UmTO3P1Xq8gq/HimNvkiSDzx/++GvkeBauPwmv
	ZQr/mVFB0tVaUpBXRpXVx9/tt
X-Received: by 2002:a05:6a00:410d:b0:886:458a:42e9 with SMTP id d2e1a72fcca58-8ba87e0a231mr1422297b3a.49.1794281386416;
        Mon, 09 Nov 2026 19:29:46 -0800 (PST)
Received: from localhost.localdomain ([240e:46d:1d00:5ed4:58d0:d294:d44c:6ae8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab21835fsm336973b3a.42.2026.11.09.19.29.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 19:29:45 -0800 (PST)
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
	zhao1.liu@intel.com,
	tim.c.chen@linux.intel.com,
	lizhe.67@bytedance.com,
	ziy@nvidia.com,
	mgorman@suse.de
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next v4 1/4] sched: add helpers for numa balancing
Date: Tue, 10 Nov 2026 11:29:10 +0800
Message-ID: <20261110032913.71974-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261110032913.71974-1-laoar.shao@gmail.com>
References: <20261110032913.71974-1-laoar.shao@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 986BB40002
X-Stat-Signature: u16a7udxa44nabjxc6467kh1yqozyorm
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794281387-612599
X-HE-Meta: U2FsdGVkX18Hylip4WGJqw4cgjbl7ivXw1IQXm7G26HKD8a0tCFO3/roxALqogjINnxJz0WUfUmMpm4dHactfKX9Tb9zAGOvcZdW6vfqMTcr5MEJlUtXKlvX4KmjjZbwl82x/w9l8r8LBh/ZJadQQwK+N8u1ywjlSJyYpKz8nEJu936Aykaryq7mnhFG3AHs9XFAtOzp8Xc0dRF4G4v6mWX/UN0SV2WbpU/xrn3VJaT4KZOyMCFZfJOtIXTLian2ju6tY5gfK7jHXeaVfS0sRtbcOS5tKSvOWGx0lPElhUjRzdWRX1FLl7F4EX7h6q5u/Y7fWf8YGlpgV7L1NhpYrese3DrvYaSH8ssohDiqZDTGFOi09w/hlBt03JXMYNnu2xoi0YvGLq/0ZduHfWPmWVkMMBsW+Hy/Lh1aHScJCWJ0G6IKjdZ6L03m/ufeihQ7OOUzBRbZHNQMvV6+3I+C9p3RexhYPbMG/slw4YSd1HVf38i+nnXBRbE2P9NByKMMY8V3sIXiSfGA+TxVQcft7et7Pz6twGeaD1purfm98Ug2FjW3yg6AtA8Bnw2Gl5K9mY/K1JL+RgYK4y16IxPqe2j/ikbPTOE6aPfyBsF7nfMrD7mgEl0h5yBxVYPSH13jV3VRtKEnC70BLthR0n+tHRc20QAzLJvQjSWFPnpZRCrOx9pnLy0BUm/0E+mrJiSxsPtO8sq8uD1a0k07zlCqCeEXxUPkHZnuSvYKs/7uSyU64Jf2J/WOAUX0G7sUDwH7xR76IKmc/FhKRvEC1kkExiVwDhr4yI0UzikHRxJ9wLxfWFMW1QtzizR5La24zeM8ycAmYbeEhbsZ1KL1sa7qMCzYDPALv0x5iZGKvNoZm22ruWvUcCVYwZWOLtmOC34CNVM+fAG+S3pxrOU6hwNeRKz5Dmn5eqoMdcLpFJ4NBHEb/pu5LuUWv8GpqVayetQ88NqDAYlXHmhxrlxXBJs
 iCfdrjTl
 3OUIZ2nA7LcTuOnJSFjH2rUS2eT/z4/vS6UOp4dCPODaw5FMop8x+3PwzsDoN9tyFkDOdDJHABuz6rijXAkqc0iAvIKepnBexWe76aO+/VTr+BCZ3RPcuEHE3sOnTQBomyx+EMjDD0UQdE4fvwIdoeRFUvgl3uRaEHpoqBS3gG6EnKPL+gOssZQULtd9x4kab2Ma1jE9YCki/XTlcglMMkeDGPA3aiTLLCE9L2DI0z6E17f8t0ClET1/SeToV/0krctEEId2j6LCiiPvL6u0qQ8h8jcM7iiMYZI05vSws3epooDbUHbZO8SYta7SFIBXpLES20zemQYsXZ2gYkZm43VgfD3y5kXr+ntjcTIKQoFu9eqAMg4gtBlQQJtLW95i4T7cwEb6CzXiHH1D21Vbwqdpci1q3Rj40sVQJyCBn8z7KnX+QILwV8UcCmfzNl6c/35rrU5g+4gQU9hGn3CH1LvPxYlfvdrLDjqlZ48nKU2ymG7nE7WIdCBXu/N2UlsrjXLB0WhcaROjHcL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Introduce task_numab_enabled(), numab_in_normal_mode() and
numab_in_tiering_mode() to replace the direct accesses to the
sched_numa_balancing static key and the sysctl_numa_balancing_mode
bitmask.

No functional change.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/sched/numa_balancing.h | 36 ++++++++++++++++++++++++++++
 kernel/sched/fair.c                  | 22 ++++++++---------
 kernel/sched/sched.h                 |  1 -
 mm/memory-tiers.c                    |  3 ++-
 mm/mempolicy.c                       |  3 +--
 mm/migrate.c                         |  7 +++---
 mm/vmscan.c                          |  6 ++---
 7 files changed, 57 insertions(+), 21 deletions(-)

diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 52b22c5c396d..61ab161fb481 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -8,6 +8,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
 
 #define TNF_MIGRATED	0x01
 #define TNF_NO_GROUP	0x02
@@ -32,6 +33,26 @@ extern void set_numabalancing_state(bool enabled);
 extern void task_numa_free(struct task_struct *p, bool final);
 bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 				int src_nid, int dst_cpu);
+
+extern struct static_key_false sched_numa_balancing;
+
+/* Whether NUMA balancing is enabled. */
+static inline bool task_numab_enabled(void)
+{
+	return static_branch_likely(&sched_numa_balancing);
+}
+
+/* Whether NUMA balancing is in normal mode. */
+static inline bool numab_in_normal_mode(void)
+{
+	return sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL;
+}
+
+/* Whether NUMA balancing is in memory tiering mode. */
+static inline bool numab_in_tiering_mode(void)
+{
+	return sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING;
+}
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -52,6 +73,21 @@ static inline bool should_numa_migrate_memory(struct task_struct *p,
 {
 	return true;
 }
+
+static inline bool task_numab_enabled(void)
+{
+	return false;
+}
+
+static inline bool numab_in_normal_mode(void)
+{
+	return false;
+}
+
+static inline bool numab_in_tiering_mode(void)
+{
+	return false;
+}
 #endif
 
 #endif /* _LINUX_SCHED_NUMA_BALANCING_H */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cfc982205b98..672dda541458 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -39,6 +39,7 @@
 #include <linux/sched/cputime.h>
 #include <linux/sched/isolation.h>
 #include <linux/sched/nohz.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/sched/prio.h>
 #include <linux/static_call.h>
 
@@ -1434,7 +1435,7 @@ static bool exceed_llc_capacity(struct sched_cache_group *grp, int cpu)
 	if (!sd)
 		return true;
 
-	if (static_branch_likely(&sched_numa_balancing)) {
+	if (task_numab_enabled()) {
 		/*
 		 * TBD: RDT exclusive LLC ways reserved should be
 		 * excluded.
@@ -1822,7 +1823,7 @@ static int get_pref_llc(struct task_struct *p, struct sched_cache_group *grp)
 		 * than sched_setnuma() at least -- and thus the
 		 * conflict only exists for a short period of time.
 		 */
-		if (static_branch_likely(&sched_numa_balancing) &&
+		if (task_numab_enabled() &&
 		    p->numa_preferred_nid >= 0 &&
 		    cpu_to_node(mm_sched_cpu) != p->numa_preferred_nid)
 			mm_sched_llc = -1;
@@ -1923,7 +1924,7 @@ static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p,
 #ifdef CONFIG_NUMA_BALANCING
 	int cpu, curr_cpu, nid, pref_nid;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled())
 		goto out;
 
 	cpu = READ_ONCE(grp->cpu);
@@ -2906,8 +2907,8 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
+	if (!numab_in_tiering_mode() && !node_is_toptier(src_nid) &&
+	    !cpupid_valid(last_cpupid))
 		return false;
 
 	/*
@@ -4140,7 +4141,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	struct numa_group *ng;
 	int priv;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled())
 		return;
 
 	/* for example, ksmd faulting in a user's mm */
@@ -4152,8 +4153,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	 * node for memory tiering mode.
 	 */
 	if (!node_is_toptier(mem_node) &&
-	    (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ||
-	     !cpupid_valid(last_cpupid)))
+	    (numab_in_tiering_mode() || !cpupid_valid(last_cpupid)))
 		return;
 
 	/* Allocate buffer to track faults on a per-node basis */
@@ -4611,7 +4611,7 @@ static void update_scan_period(struct task_struct *p, int new_cpu)
 	int src_nid = cpu_to_node(task_cpu(p));
 	int dst_nid = cpu_to_node(new_cpu);
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled())
 		return;
 
 	if (!p->mm || !p->numa_faults || (p->flags & PF_EXITING))
@@ -10702,7 +10702,7 @@ static long migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	unsigned long src_weight, dst_weight;
 	int src_nid, dst_nid, dist;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled())
 		return 0;
 
 	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
@@ -15362,7 +15362,7 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 	if (queued)
 		return;
 
-	if (static_branch_unlikely(&sched_numa_balancing))
+	if (task_numab_enabled())
 		task_tick_numa(rq, curr);
 
 	task_tick_cache(rq, curr);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6c7c5633524a..9b616abf5c9c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2496,7 +2496,6 @@ extern union sched_feat_key sched_feat_keys[__SCHED_FEAT_NR];
 
 #endif /* !CONFIG_JUMP_LABEL */
 
-extern struct static_key_false sched_numa_balancing;
 extern struct static_key_false sched_schedstats;
 
 static inline u64 global_rt_period(void)
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 25e121851b58..c49071261078 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -6,6 +6,7 @@
 #include <linux/memory.h>
 #include <linux/memory-tiers.h>
 #include <linux/notifier.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/sched/sysctl.h>
 
 #include "internal.h"
@@ -64,7 +65,7 @@ static const struct bus_type memory_tier_subsys = {
  */
 bool folio_use_access_time(struct folio *folio)
 {
-	return (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
+	return numab_in_tiering_mode() &&
 	       !node_is_toptier(folio_nid(folio));
 }
 #endif
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0884c629670d..991b80d5e899 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -887,8 +887,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	 * Skip scanning top tier node if normal numa
 	 * balancing is disabled
 	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-	    node_is_toptier(nid))
+	if (!numab_in_normal_mode() && node_is_toptier(nid))
 		return false;
 
 	if (folio_use_access_time(folio))
diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f..4659ecdc4d0c 100644
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
+	if (numab_in_tiering_mode()) {
 		bool f_toptier = node_is_toptier(folio_nid(folio));
 		bool t_toptier = node_is_toptier(folio_nid(newfolio));
 
@@ -2717,7 +2718,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
 		int z;
 
-		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
+		if (!numab_in_tiering_mode())
 			return -EAGAIN;
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 			if (managed_zone(pgdat->node_zones + z))
@@ -2769,7 +2770,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
-		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		if (numab_in_tiering_mode()
 		    && !node_is_toptier(folio_nid(folio))
 		    && node_is_toptier(node))
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce8..7ef4205b6a4e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -65,6 +65,7 @@
 
 #include <linux/swapops.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/numa_balancing.h>
 
 #include "internal.h"
 #include "page_alloc.h"
@@ -5224,8 +5225,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	if (!current_is_kswapd() || sc->order)
 		return false;
 
-	mark = sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-	       WMARK_PROMO : WMARK_HIGH;
+	mark = numab_in_tiering_mode() ? WMARK_PROMO : WMARK_HIGH;
 
 	for (i = 0; i <= sc->reclaim_idx; i++) {
 		struct zone *zone = lruvec_pgdat(lruvec)->node_zones + i;
@@ -7131,7 +7131,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		enum zone_stat_item item;
 		unsigned long free_pages;
 
-		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		if (numab_in_tiering_mode())
 			mark = promo_wmark_pages(zone);
 		else
 			mark = high_wmark_pages(zone);
-- 
2.52.0


