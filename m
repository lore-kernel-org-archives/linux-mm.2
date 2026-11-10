Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2867D606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J2cEU0za
Received: by kanga.kvack.org (Postfix)
	id 052326B05B9; Mon,  9 Nov 2026 22:30:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029736B05BA; Mon,  9 Nov 2026 22:30:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E324E6B05BB; Mon,  9 Nov 2026 22:30:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5BAD6B05B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:30:14 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 178BB408BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:30:14 +0000 (UTC)
X-FDA: 85417781148.10.F378208
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 38105140007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:30:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=J2cEU0za;
	spf=pass (imf23.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794281412;
	b=4TLBYsaRKUXIKU+XA8Uacm0RpmQCpzzkEbM5vxIPL7A+g8RYBYOBLYRfAjiWo/4pge6jd+
	G4b84okDTtLtHv53g5ADB0dENI7XP1RczRPGnHb+qBxR8q/jO+fHpArtVdyvOoT1vHC8dJ
	OPh+aLKlqkbssQI5ElRaXaSInVKVux8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=J2cEU0za;
	spf=pass (imf23.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794281412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xlvb3de2V5RVIaO/2xx9NtMEeDhERPuOHSMLy+u6zkw=;
	b=sK0jtzrsYJnlnwq26h+t6KEcftKQbYRjm3CGxGuWBlo+YShAlF6fqJUrwU8VFSmt0UxlaS
	muiU7T2JV/TP5h1VR7X1MBPL7AKOKDUbQ8ms1RzzWNZDIB2bolP9nz1sQtXwEMZrHqRxf4
	FZBIeGa/QA3bN5vh4hTsRDOdn7i4zlg=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8b2f59de176so1153700b3a.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 19:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794281411; x=1794886211; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xlvb3de2V5RVIaO/2xx9NtMEeDhERPuOHSMLy+u6zkw=;
        b=J2cEU0zaVWOjkHhZ51R8PLLCVYjmDbIShmWK/kfmf5/nu4z6PhQIP8EfI4vrZNa4ra
         cQa53hxefRfn25YLpAlOOfIMuY6N2TAHkIlizlu9icQwy1OUd3045AZW3vSY1ylcpY0n
         g2u1ejWVxwsk40xmhs5+aUb9SwZG+NBz9n3AuL3H50AwcVGoYF5bqIqUVB4bAF5b9xPz
         W5vs09RgI6OBqHI5hmE6nLkzDHSAiI/zTDDWyL81Uhbwt2guK90X6jHjqkdj2D8kraT8
         52BJY6yMt9JRx3pHMibDSQxMslvjjzUKPHbCL7ylyyFh7Y8AkbZvv7T+uxkNuehOSM0z
         m/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794281411; x=1794886211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xlvb3de2V5RVIaO/2xx9NtMEeDhERPuOHSMLy+u6zkw=;
        b=lVxjP9Z19WLkReJcx56xqvqZA9DNzbXz7T8U2vBktbA49LWoG48fv7QKg3Z410UCnC
         qQSIZmma1eATa2IdvpsxM46M0BgojcPrEMfjdTdhe3LWSlDI3YFmdI6RWgPpkC5JwTWy
         m0/SUrNLgzFEuNRQaW5x2IvoK7ZJE1QtMPXtxtcJsHInG4OuZNf+M+ZyfKK6RSydwKMX
         ztCPRlWKJA89ZZjE3pUwyjZYAhsDc3S0VodghFpu1kTG6i0QTsBlYNzOhSxGwPIuqR6G
         ZzlRDu7qhRlrWA5432MHOAW7oFlF2D1Tw/gmR+VNVKroT6tlRjuxlhzR4dQC9ICgzcXs
         cviA==
X-Forwarded-Encrypted: i=1; AL+hErEusdbVTXaHZ0pM6Aw80kXvItA3l/qBAVpA8LMUG/pDx5HvpZ1f4v6QVON7XMw7FExmPC4YGzsAPQ==@kvack.org
X-Gm-Message-State: APuU4Z+HCCIbMRwsowONZKAnt4HJtJImMgEoAc+9RTQbIIBviYBubTnf
	wwYyKYh+UDd3W4hp89dKfbmzCdyMl6qRc5YYOaUDI7hYYUe0eWPYegNd
X-Gm-Gg: AYBFou0vVlip2GoQz3DZan5jaN63eFjjhJ6UIcXK8DoRFhLbmfhlvMq87mJZrABsgC2
	mcOqcibHZtYcjqTbGpX4WCXQ4IZ5lLvrUIjgwahRihnnr3DG1uJVoRF9osVSjEQxHVLN5OxzV49
	VMkqVX3+a0HIJoKZVpYRElJpZ5qtON60lOdkdotiWakOvWRippeLV8atFVEeU4IHw7bDLqwQ0Qi
	bjbLtD3asEgwseVOwGvbJJHgU1Ut8TGAILSRvIevFYrJhl4WoiyHOKI7T9nTyae2dBwGVMwWB4I
	iDYpFvkbII+iD3LsU3Ke4hTdtt/C2Jq0ZgpV7R0xPKz5ZAMPKpe2x4EHseatI1vWvzO+cne8iOy
	n93OqsQN0suGmZfaJlmq7HD9gC7dWxHb2w4xqF/jnuYgvDTo3dtKMslHthZbFOX1rVoOH6W3UgK
	c1ONqjxlnMm7jHQJhYJklrLpBgeNanMtKHuqO1bQ52sXDgAokbZWKhkR+eJA/CtGSAHi6jz1/6L
	fxlZDMKwNH1p+y8LlVH8E99LPgnsCf8a3OkKcZvheuZYA49v0lXGMSBlXyPt8GpvgpgU94Jp/YQ
	IUUXSOfifEo7Xw+nRL5FXIjcYLrsli1Etx1bmRHVW1VXMdEFH9KHnUqaoRLEEnYMtm0/gw/bbUZ
	7Q4br2FCE1fvR7Cu6/aONO72ttw==
X-Received: by 2002:a05:6a00:3d4a:b0:89d:7f51:6492 with SMTP id d2e1a72fcca58-8ba89660cf8mr1574635b3a.32.1794281410670;
        Mon, 09 Nov 2026 19:30:10 -0800 (PST)
Received: from localhost.localdomain ([240e:46d:1d00:5ed4:58d0:d294:d44c:6ae8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab21835fsm336973b3a.42.2026.11.09.19.29.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 19:30:07 -0800 (PST)
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
Subject: [RFC PATCH bpf-next v4 3/4] sched: add BPF-based per-cgroup NUMA balancing mode selection
Date: Tue, 10 Nov 2026 11:29:12 +0800
Message-ID: <20261110032913.71974-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261110032913.71974-1-laoar.shao@gmail.com>
References: <20261110032913.71974-1-laoar.shao@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bhmft7tzk68tas43c9xj7zc41ykhuq3e
X-Rspamd-Queue-Id: 38105140007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794281412-915154
X-HE-Meta: U2FsdGVkX19ZUVOkDFAlIAePT4kZ3B+v6U1flskuFt7OpSlzZTwLCSrq8G0SllvZO0Lj7esdXwGGh7lkTe+fQBFc5vgaWAdITkRiez7zYAf7Vd4ezUqgfbJKAgnW3U99TPA88OnJzIOceazFV+Vpd01Vew9Shfnqr5o8oTQTQMOzikgFCyEhWtYjGRAM8y6lBsbvIJrpu5iNe/YXzDZ+CpRcOxBorEwspNdewkNEP3iGHsdG47hTJ8AMq8avJV2IYsKgYn0zalfz6jfkPTle0ZM+prSKQ6x+S5C/WfXsmKgNsPKM1iIHfz+/lCtI3cPw/urzxx2XFQ+MHxm67eRsa323+7BdFNf8Yaqkb+PZJt2dmcpyqxDuYYRtwJLFnQ7AwtKfqaMDxdd8NHmC+T3jbkOiN945hDSifTZKrH1MPSZrwEjGULyzGy6AI61+mlZnYGWj+/8vVDnomoKprfJ3oBlzqMJiGyC8eS3MSK2pTtck3gsAaHzX+omCRtDVL2pMlStODLYejYgKMzm1aNdd4nqw0mjEp2p8sx1isX/dfsoPKEiNcew784zVEoDW0UXa9rCzfeVC2yzw+nkC81x+XmxymFANm0FKaKuKCyhzpUIV7KHGz8pOfqzA/ccPOSZyjAoYHZST7M5ST3XHQH8rIKLKC9b8pQBpUp0yGGrM2LOY72LlRiYCGAtrVDB0/ryR3veq7PsskC+EKT/bRmlWHFLneMfaOFqWVz9MeW3kX4hPmsZCiiVu/j2W1CO5xszmaDIFs2eLKpkM20znXAflyhVgl0PT87Kz89pKwqqp++m53HQIH4Lux64L9RXDR9K++mwwJeoQPspw5w2mtYSD/Q/8jMfSswIXGi3vSS9Vc+OeorC7jgVLIsnU6/0dZzSQZFs73DoDVVMk5I3RPk6nX2szRKALiJs2Y0D/JB1oDZplvlNWoao75h6mtc5t6jwUJ/hetZLxa5BZSA/PoOo
 1VSQJTKt
 MVIfb9l/wFFJYEGjzBS3YNO6ywqbAyOqZ34EnSp/OaYxEPDgb7CBedRO4TORqL6QmxrBBihSLYS3XKWaeGcKN6D70K/98eyaN0JCdmHTC3DeN8WUlM3iC6HWIl8N95HYaI07vB0p/qBKbZKmems1r+n2LfQ7pO1p2xPQSKq5QHZZIX0eS0Erc88gDMSBV7/q8B5A2cvL6uNv6QLCfvG7HQ2s4nh3R6448N8CuITMQ1r5pEA9our4vyBL7bcvlsVl5McxPBrwOZXqdNTFmZxp/5geAEaoW/OAbuT0rS1C960TRqE8PD5FTYXT5Im5uL5inI2/4Zypdoj7G8OoHkAuYPmbGqzun+uXpIeIA5wP1Lr4phu0Jt7jysCsDB5Etn49Ky3VTnPMfwnqzU8DNCwfSZTbGDauV9p1FeCz1VWv0LxiVQ0R4vgvTcI8SjZufDxKkGA0dHoAade9DNgS7uN0F4jOO2kZTvBfjfhLO+u9A9MUdLGSjxM8cfFlvWkiABVXG8IPJsX5+4u+8394=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kernel.numa_balancing is a single system-wide sysctl. Latency-sensitive
workloads want NUMA balancing disabled, while NUMA-aware workloads want it
enabled. No single global setting serves both.

This commit adds a per-memcg numa balancing mode and two kfuncs to
manage it.  The mode domain is a BTF enum so BPF programs do not have to
hardcode private integer values.

Store the request in the cgroup's memcg, not in the task or the cgroup
object. Memory is charged to a memcg, so a shared folio has exactly one
policy owner; both the task-side and folio-side lookups can resolve a
cgroup without its own memcg to the same ancestor memcg. This is also why
setting a mode on a cgroup without the memory controller is rejected:
there is no memcg to own the request, and accepting it would make the
task and folio views disagree.

DISABLED wins and binds the whole subtree; otherwise the requested bits
OR together. A nearest-request-wins rule would let a descendant undo an
ancestor's opt-out, and an opt-out is only a subtree guarantee if it
binds. Additive requests let a descendant ask for more without taking
away what an ancestor asked for.

DISABLED speaks for tasks only, never for the memcg's memory. Demotion
is global reclaim, gated by the global demotion toggle, not by
numab_mode. A task-side opt-out must not become a memory-side reclaim
veto: otherwise a cgroup could keep cold pages in the fast tier, leaving
less capacity for other cgroups' hot pages and defeating promotion for
them. The misplaced-migration fallback follows the same rule. kswapd has
no task context, so the folio's memcg is the only policy owner there.

The requests are combined at read time rather than propagated at write
time. A new memcg then starts transparent and sees its ancestors' current
state by construction; propagating a combined value would need write-side
hooks to stay coherent with concurrent updates and a second field for the
folio view, which reads opt-outs differently.  The previous patch already
samples the effective mode once per path; this patch changes what that
sampled value means.

The hot paths may run in atomic context, so the lookup takes no
reference: the memcg chain is RCU-protected. The setter needs locks and
may sleep; the getter does not.  A request is cleared when the memory
controller is disabled or the memcg is offlined.  Lookups also skip
memcgs which are dying, offline or not visible, so a pinned memcg cannot
keep applying a stale request.  The tick path uses the cheap global gate
and checks the per-task request only after the scan period expires.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/memcontrol.h           |   6 +
 include/linux/sched/numa_balancing.h | 126 ++++++++++++-
 init/Kconfig                         |  23 +++
 kernel/sched/bpf_numab.c             | 261 +++++++++++++++++++++++++++
 kernel/sched/build_policy.c          |   4 +
 kernel/sched/fair.c                  |  26 ++-
 mm/memcontrol.c                      |  14 ++
 mm/memory-tiers.c                    |   8 +-
 mm/mempolicy.c                       |   8 +-
 mm/migrate.c                         |   8 +-
 10 files changed, 456 insertions(+), 28 deletions(-)
 create mode 100644 kernel/sched/bpf_numab.c

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..78ea21bfab95 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -342,6 +342,12 @@ struct mem_cgroup {
 	 */
 	bool zswap_writeback;
 #endif
+
+#ifdef CONFIG_BPF_NUMAB
+	/* per-cgroup NUMA balancing mode request; -1 follows the global state. */
+	int numab_mode;
+#endif
+
 	/* Not padded: nodeinfo[] is read-mostly too, let it share the line. */
 	__cacheline_group_end(memcg_read_mostly);
 
diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 61ab161fb481..e10093386cf7 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -36,16 +36,56 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 
 extern struct static_key_false sched_numa_balancing;
 
-/* Whether NUMA balancing is enabled. */
-static inline bool task_numab_enabled(void)
+/*
+ * Mode values used by the NUMA balancing helpers.
+ */
+enum numab_mode {
+	NUMAB_FOLLOW_SYSTEM	= -1,
+	NUMAB_DISABLED		= NUMA_BALANCING_DISABLED,
+	NUMAB_NORMAL		= NUMA_BALANCING_NORMAL,
+	NUMAB_TIERING		= NUMA_BALANCING_MEMORY_TIERING,
+	NUMAB_NORMAL_TIERING	= NUMA_BALANCING_NORMAL |
+				  NUMA_BALANCING_MEMORY_TIERING,
+};
+
+#ifdef CONFIG_BPF_NUMAB
+extern struct static_key_false numab_cgroup_mode_set;
+
+int task_numab_mode(struct task_struct *p);
+int folio_numab_mode(struct folio *folio);
+void numab_memcg_reset(struct mem_cgroup *memcg);
+#endif
+
+/*
+ * Whether any task might need the NUMA scanner on this tick.  This is
+ * only the cheap global gate; the per-task request is checked after the
+ * scan period in task_tick_numa().
+ */
+static inline bool task_numab_tick_possible(void)
 {
-	return static_branch_likely(&sched_numa_balancing);
+#ifdef CONFIG_BPF_NUMAB
+	if (static_branch_likely(&numab_cgroup_mode_set))
+		return true;
+#endif
+	return static_branch_unlikely(&sched_numa_balancing);
 }
 
-/* Whether NUMA balancing is in normal mode. */
-static inline bool numab_in_normal_mode(void)
+/*
+ * Whether NUMA balancing applies to @p: the global sysctl state, possibly
+ * overridden by the requests of @p's memcg and of every ancestor.
+ * A memcg's request always takes priority over the system setting.
+ */
+static inline bool task_numab_enabled(struct task_struct *p)
 {
-	return sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL;
+#ifdef CONFIG_BPF_NUMAB
+	if (static_branch_unlikely(&numab_cgroup_mode_set)) {
+		int mode = task_numab_mode(p);
+
+		if (mode != NUMAB_FOLLOW_SYSTEM)
+			return mode != NUMAB_DISABLED;
+	}
+#endif
+	return static_branch_likely(&sched_numa_balancing);
 }
 
 /* Whether NUMA balancing is in memory tiering mode. */
@@ -53,6 +93,62 @@ static inline bool numab_in_tiering_mode(void)
 {
 	return sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING;
 }
+
+/*
+ * Return both task-side decisions from one request lookup.  This is used
+ * by paths that need to know both whether to account the fault and
+ * whether slow-tier faults should be skipped.
+ */
+static inline void task_numab_get_modes(struct task_struct *p, bool *enabled,
+					bool *tiering)
+{
+#ifdef CONFIG_BPF_NUMAB
+	if (static_branch_unlikely(&numab_cgroup_mode_set)) {
+		int mode = task_numab_mode(p);
+
+		if (mode != NUMAB_FOLLOW_SYSTEM) {
+			*enabled = mode != NUMAB_DISABLED;
+			*tiering = mode & NUMAB_TIERING;
+			return;
+		}
+	}
+#endif
+	*enabled = static_branch_likely(&sched_numa_balancing);
+	*tiering = numab_in_tiering_mode();
+}
+
+/*
+ * The combined folio-side request, with the global sysctl state used when
+ * no memcg requests a mode.  DISABLED never speaks for memory, so only
+ * NORMAL and TIERING are present here.  Callers that need more than one
+ * bit should use this helper once rather than querying each bit
+ * separately.
+ */
+static inline int folio_numab_effective_mode(struct folio *folio)
+{
+#ifdef CONFIG_BPF_NUMAB
+	if (static_branch_unlikely(&numab_cgroup_mode_set)) {
+		int mode = folio_numab_mode(folio);
+
+		if (mode != NUMAB_FOLLOW_SYSTEM)
+			return mode;
+	}
+#endif
+	return sysctl_numa_balancing_mode;
+}
+
+/*
+ * Whether @folio's memory participates in tiering, i.e. whether its
+ * _last_cpupid carries an access time instead of a cpupid. The
+ * requests of the owner memcg and of every ancestor are combined.
+ * DISABLED never speaks for memory (it is a task-side request), so only
+ * NORMAL and TIERING are consulted here; without either, the global
+ * sysctl decides.
+ */
+static inline bool folio_numab_in_tiering_mode(struct folio *folio)
+{
+	return folio_numab_effective_mode(folio) & NUMAB_TIERING;
+}
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -74,17 +170,29 @@ static inline bool should_numa_migrate_memory(struct task_struct *p,
 	return true;
 }
 
-static inline bool task_numab_enabled(void)
+static inline bool task_numab_enabled(struct task_struct *p)
 {
 	return false;
 }
 
-static inline bool numab_in_normal_mode(void)
+static inline bool numab_in_tiering_mode(void)
 {
 	return false;
 }
 
-static inline bool numab_in_tiering_mode(void)
+static inline bool folio_numab_in_tiering_mode(struct folio *folio)
+{
+	return false;
+}
+
+static inline void task_numab_get_modes(struct task_struct *p, bool *enabled,
+					bool *tiering)
+{
+	*enabled = false;
+	*tiering = false;
+}
+
+static inline bool task_numab_tick_possible(void)
 {
 	return false;
 }
diff --git a/init/Kconfig b/init/Kconfig
index 4013781e0a02..3f38cf8077a3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -827,6 +827,29 @@ config NUMA_BALANCING
 
 	  This system will be inactive on UMA systems.
 
+config BPF_NUMAB
+	bool "Per-cgroup NUMA balancing mode selection"
+	default n
+	depends on NUMA_BALANCING && MEMCG && BPF_SYSCALL && DEBUG_INFO_BTF
+	help
+	  Allow BPF programs to select the NUMA balancing mode (disabled,
+	  normal, memory tiering, or both) on a per-cgroup basis, overriding the
+	  global NUMA balancing sysctl. A latency-sensitive service can
+	  opt its tasks out of balancing, or a batch service can have its
+	  PMEM-resident memory promoted when hot, without changing the
+	  mode for the rest of the system.
+
+	  The request is written and read back through the
+	  bpf_numab_set_mode() and bpf_numab_get_mode() kfuncs, callable
+	  from BPF_PROG_TYPE_SYSCALL programs. The mode is stored in the
+	  target cgroup's memcg; setting it on a cgroup without the memory
+	  controller enabled is rejected.  This interface only applies to
+	  cgroups on the default hierarchy (cgroup v2).  While no memcg
+	  makes a request, the NUMA balancing hot paths pay a single
+	  patched-out branch and nothing else.
+
+	  If unsure, say N.
+
 config SCHED_CACHE
 	bool "Cache aware load balance"
 	default y
diff --git a/kernel/sched/bpf_numab.c b/kernel/sched/bpf_numab.c
new file mode 100644
index 000000000000..c7f44bf383f6
--- /dev/null
+++ b/kernel/sched/bpf_numab.c
@@ -0,0 +1,261 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Per-cgroup NUMA balancing mode
+ *
+ * A cgroup overrides the global state through its memcg. Task and folio
+ * lookups walk the memcg chain; an opt-out binds the subtree, while the
+ * remaining bits OR together.
+ *
+ * Author: Yafang Shao <laoar.shao@gmail.com>
+ */
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/cgroup.h>
+#include <linux/memcontrol.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/sched/numa_balancing.h>
+
+DEFINE_STATIC_KEY_FALSE(numab_cgroup_mode_set);
+
+/* Whether this memcg may still own a NUMA balancing request. */
+static bool numab_memcg_active(struct mem_cgroup *memcg)
+{
+	unsigned int flags;
+
+	if (mem_cgroup_is_root(memcg))
+		return true;
+
+	/* Take one snapshot so all three state bits describe the same moment. */
+	flags = READ_ONCE(memcg->css.flags);
+
+	return (flags & CSS_ONLINE) &&
+	       !(flags & CSS_DYING) &&
+	       (flags & CSS_VISIBLE);
+}
+
+/*
+ * Combine the requests of @memcg and of every ancestor. A task chain
+ * stops at an explicit opt-out: a task can never be forced into
+ * balancing. A folio chain skips opt-outs instead (a memcg's DISABLED
+ * request only speaks for its tasks, never for its memory) and keeps
+ * collecting the remaining requests.
+ */
+static int numab_memcg_mode(struct mem_cgroup *memcg, bool folio_side)
+{
+	int req = 0;
+
+	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
+		int mode;
+
+		if (!numab_memcg_active(memcg))
+			continue;
+
+		/* Paired with WRITE_ONCE() under numab_mode_mutex. */
+		mode = data_race(READ_ONCE(memcg->numab_mode));
+		if (mode == NUMAB_FOLLOW_SYSTEM)
+			continue;
+		if (mode == NUMAB_DISABLED) {
+			if (!folio_side)
+				return NUMAB_DISABLED;
+			continue;
+		}
+		req |= mode;
+	}
+	return req ?: NUMAB_FOLLOW_SYSTEM;
+}
+
+/*
+ * The combined request for @p. Kernel threads have no user memory to
+ * balance, so they make no request.  The walk needs no reference: the
+ * memcg chain is RCU-protected, so rcu_read_lock() keeps it alive for
+ * the whole walk.
+ */
+int task_numab_mode(struct task_struct *p)
+{
+	struct mem_cgroup *memcg;
+	int mode;
+
+	if (mem_cgroup_disabled() || !p->mm)
+		return NUMAB_FOLLOW_SYSTEM;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_task(p);
+	mode = memcg ? numab_memcg_mode(memcg, false) : NUMAB_FOLLOW_SYSTEM;
+	rcu_read_unlock();
+	return mode;
+}
+
+/*
+ * The combined request for @folio's owner. An uncharged folio makes no
+ * request. A folio charged to a memcg whose cgroup the kfunc cannot
+ * reach carries no request and follows the global state.
+ */
+int folio_numab_mode(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+	int mode;
+
+	if (mem_cgroup_disabled())
+		return NUMAB_FOLLOW_SYSTEM;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	mode = memcg ? numab_memcg_mode(memcg, true) : NUMAB_FOLLOW_SYSTEM;
+	rcu_read_unlock();
+	return mode;
+}
+
+static DEFINE_MUTEX(numab_mode_mutex);
+
+/*
+ * Reset the request when the memory controller is disabled, the memcg is
+ * offlined or the memcg is pinned.  A memcg may be made visible again, so
+ * it must start transparent.
+ */
+void numab_memcg_reset(struct mem_cgroup *memcg)
+{
+	mutex_lock(&numab_mode_mutex);
+	if (memcg->numab_mode != NUMAB_FOLLOW_SYSTEM) {
+		WRITE_ONCE(memcg->numab_mode, NUMAB_FOLLOW_SYSTEM);
+		static_branch_dec(&numab_cgroup_mode_set);
+	}
+	mutex_unlock(&numab_mode_mutex);
+}
+
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_numab_set_mode() - Set the NUMA balancing mode of a cgroup's memcg.
+ * @cgid: kernfs id of the cgroup whose memcg is updated
+ * @mode: NUMAB_FOLLOW_SYSTEM to defer to the global sysctl state, or a
+ *        NUMAB_* mode. The kernel reads the bits independently, the way
+ *        kernel.numa_balancing reads them, so
+ *        NUMAB_NORMAL|NUMAB_TIERING engages both modes. A
+ *        NUMAB_DISABLED request only speaks for the memcg's tasks, never
+ *        for its memory, which follows the remaining requests of its
+ *        ancestors.
+ *
+ * The cgroup must have a visible, online memory cgroup; otherwise the
+ * update is rejected.
+ *
+ * Return: 0 on success; %-EINVAL for a mode outside the domain;
+ *         %-ENOENT for an id that resolves to no cgroup; %-EOPNOTSUPP
+ *         for a cgroup without a visible, online memcg.
+ */
+__bpf_kfunc int bpf_numab_set_mode(u64 cgid, enum numab_mode mode)
+{
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
+	struct cgroup *cgrp;
+	int old;
+
+	if (mode != NUMAB_FOLLOW_SYSTEM &&
+	    (mode < 0 || mode > NUMAB_NORMAL_TIERING))
+		return -EINVAL;
+
+	cgrp = __cgroup_get_from_id(cgid);
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+
+	if (mem_cgroup_disabled()) {
+		cgroup_put(cgrp);
+		return -EOPNOTSUPP;
+	}
+
+	rcu_read_lock();
+	css = cgroup_css(cgrp, &memory_cgrp_subsys);
+	memcg = mem_cgroup_from_css(css);
+	if (memcg && !mem_cgroup_tryget_online(memcg))
+		memcg = NULL;
+	rcu_read_unlock();
+
+	if (!memcg) {
+		cgroup_put(cgrp);
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&numab_mode_mutex);
+	if (!numab_memcg_active(memcg)) {
+		mutex_unlock(&numab_mode_mutex);
+		mem_cgroup_put(memcg);
+		cgroup_put(cgrp);
+		return -EOPNOTSUPP;
+	}
+
+	old = READ_ONCE(memcg->numab_mode);
+	if (old == NUMAB_FOLLOW_SYSTEM && mode != NUMAB_FOLLOW_SYSTEM)
+		static_branch_inc(&numab_cgroup_mode_set);
+	else if (old != NUMAB_FOLLOW_SYSTEM && mode == NUMAB_FOLLOW_SYSTEM)
+		static_branch_dec(&numab_cgroup_mode_set);
+	WRITE_ONCE(memcg->numab_mode, (int)mode);
+	mutex_unlock(&numab_mode_mutex);
+
+	mem_cgroup_put(memcg);
+	cgroup_put(cgrp);
+	return 0;
+}
+
+/**
+ * bpf_numab_get_mode() - Read the NUMA balancing mode that applies to a cgroup.
+ * @cgid: kernfs id of the cgroup
+ *
+ * The combined task-side request of the cgroup's effective memcg and of
+ * every ancestor: an opt-out wins, otherwise the requested bits OR
+ * together, and the kernel reads them independently, as
+ * kernel.numa_balancing does, so a combined
+ * NUMAB_NORMAL|NUMAB_TIERING engages both modes. NUMAB_FOLLOW_SYSTEM
+ * when nobody makes a request. If the cgroup
+ * has no memcg, the nearest ancestor memcg is used. The folio-side view
+ * stays internal to the kernel.
+ *
+ * Return: the combined mode, NUMAB_FOLLOW_SYSTEM (-1) included, or
+ *         %-ENOENT for an id that resolves to no cgroup.
+ */
+__bpf_kfunc s64 bpf_numab_get_mode(u64 cgid)
+{
+	struct mem_cgroup *memcg;
+	struct cgroup *cgrp;
+	s64 mode;
+
+	cgrp = __cgroup_get_from_id(cgid);
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+
+	if (mem_cgroup_disabled()) {
+		cgroup_put(cgrp);
+		return NUMAB_FOLLOW_SYSTEM;
+	}
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_css(cgroup_e_css(cgrp, &memory_cgrp_subsys));
+	mode = memcg ? numab_memcg_mode(memcg, false) : NUMAB_FOLLOW_SYSTEM;
+	rcu_read_unlock();
+
+	cgroup_put(cgrp);
+	return mode;
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(numab_kfunc_ids)
+BTF_ID_FLAGS(func, bpf_numab_set_mode, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_numab_get_mode)
+BTF_KFUNCS_END(numab_kfunc_ids)
+
+static const struct btf_kfunc_id_set numab_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &numab_kfunc_ids,
+};
+
+static int __init numab_kfunc_init(void)
+{
+	int ret;
+
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &numab_kfunc_set);
+	if (ret)
+		pr_warn("numab: failed to register kfuncs: %d\n", ret);
+	return ret;
+}
+late_initcall(numab_kfunc_init);
diff --git a/kernel/sched/build_policy.c b/kernel/sched/build_policy.c
index 2a828725a7f9..3746c6675ff3 100644
--- a/kernel/sched/build_policy.c
+++ b/kernel/sched/build_policy.c
@@ -75,4 +75,8 @@
 # include "ext/sub.c"
 #endif
 
+#ifdef CONFIG_BPF_NUMAB
+#include "bpf_numab.c"
+#endif
+
 #include "syscalls.c"
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 18b976a47afa..6c2a7550eef5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1882,7 +1882,7 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 		if (READ_ONCE(grp->cpu) != -1)
 			WRITE_ONCE(grp->cpu, -1);
 	} else {
-		numab_enabled = task_numab_enabled();
+		numab_enabled = task_numab_enabled(p);
 		if (exceed_llc_capacity(grp, cpu_of(rq), numab_enabled)) {
 			if (READ_ONCE(grp->cpu) != -1)
 				WRITE_ONCE(grp->cpu, -1);
@@ -2034,7 +2034,7 @@ static void task_cache_work(struct callback_head *work)
 		return;
 	}
 
-	numab_enabled = task_numab_enabled();
+	numab_enabled = task_numab_enabled(p);
 	if (exceed_llc_capacity(grp, curr_cpu, numab_enabled)) {
 		if (READ_ONCE(grp->cpu) != -1)
 			WRITE_ONCE(grp->cpu, -1);
@@ -2884,7 +2884,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	int last_cpupid, this_cpupid;
 	bool tiering;
 
-	tiering = numab_in_tiering_mode();
+	tiering = folio_numab_in_tiering_mode(folio);
 
 	/*
 	 * Cannot migrate to memoryless nodes.
@@ -4154,12 +4154,14 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 {
 	struct task_struct *p = current;
 	bool migrated = flags & TNF_MIGRATED;
+	bool numab_enabled, numab_tiering;
 	int cpu_node = task_node(current);
 	int local = !!(flags & TNF_FAULT_LOCAL);
 	struct numa_group *ng;
 	int priv;
 
-	if (!task_numab_enabled())
+	task_numab_get_modes(p, &numab_enabled, &numab_tiering);
+	if (!numab_enabled)
 		return;
 
 	/* for example, ksmd faulting in a user's mm */
@@ -4171,7 +4173,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	 * node for memory tiering mode.
 	 */
 	if (!node_is_toptier(mem_node) &&
-	    (numab_in_tiering_mode() || !cpupid_valid(last_cpupid)))
+	    (numab_tiering || !cpupid_valid(last_cpupid)))
 		return;
 
 	/* Allocate buffer to track faults on a per-node basis */
@@ -4315,6 +4317,9 @@ static void task_numa_work(struct callback_head *work)
 	if (p->flags & PF_EXITING)
 		return;
 
+	if (!task_numab_enabled(p))
+		return;
+
 	/*
 	 * Memory is pinned to only one NUMA node via cpuset.mems, naturally
 	 * no page can be migrated.
@@ -4619,6 +4624,11 @@ static void task_tick_numa(struct rq *rq, struct task_struct *curr)
 			curr->numa_scan_period = task_scan_start(curr);
 		curr->node_stamp += period;
 
+		if (!task_numab_enabled(curr)) {
+			curr->node_stamp = now;
+			return;
+		}
+
 		if (!time_before(jiffies, curr->mm->numa_next_scan))
 			task_work_add(curr, work, TWA_RESUME);
 	}
@@ -4629,7 +4639,7 @@ static void update_scan_period(struct task_struct *p, int new_cpu)
 	int src_nid = cpu_to_node(task_cpu(p));
 	int dst_nid = cpu_to_node(new_cpu);
 
-	if (!task_numab_enabled())
+	if (!task_numab_enabled(p))
 		return;
 
 	if (!p->mm || !p->numa_faults || (p->flags & PF_EXITING))
@@ -11237,7 +11247,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	if (env->flags & LBF_ACTIVE_LB)
 		return !migrate_llc_task_wrong_dst(p, env);
 
-	numab_enabled = task_numab_enabled();
+	numab_enabled = task_numab_enabled(p);
 	degrades = migrate_degrades_locality(p, env, numab_enabled);
 	if (!degrades) {
 		/*
@@ -15387,7 +15397,7 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 	if (queued)
 		return;
 
-	if (task_numab_enabled())
+	if (task_numab_tick_possible())
 		task_tick_numa(rq, curr);
 
 	task_tick_cache(rq, curr);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a05d9a8baa1b..3971b5b3360b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -31,6 +31,7 @@
 #include <linux/cgroup.h>
 #include <linux/cpuset.h>
 #include <linux/sched/mm.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
@@ -4266,6 +4267,9 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	if (!memcg)
 		return ERR_PTR(-ENOMEM);
 
+#ifdef CONFIG_BPF_NUMAB
+	memcg->numab_mode = NUMAB_FOLLOW_SYSTEM;
+#endif
 	error = xa_alloc(&mem_cgroup_private_ids, &memcg->private_id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
 	if (error)
@@ -4459,6 +4463,9 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
+#ifdef CONFIG_BPF_NUMAB
+	numab_memcg_reset(memcg);
+#endif
 	memcg1_css_offline(memcg);
 
 	page_counter_set_min(&memcg->memory, 0);
@@ -4532,6 +4539,9 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
+#ifdef CONFIG_BPF_NUMAB
+	numab_memcg_reset(memcg);
+#endif
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
 	WRITE_ONCE(memcg->oom_group, false);
@@ -5917,6 +5927,10 @@ static void __init memcg_struct_check(void)
 				      kmemcg_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      oom_group);
+#ifdef CONFIG_BPF_NUMAB
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      numab_mode);
+#endif
 
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
 				      memcg_pn_read_mostly, memcg);
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index c49071261078..7bfb92657e24 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -57,15 +57,15 @@ static const struct bus_type memory_tier_subsys = {
  * folio_use_access_time - check if a folio reuses cpupid for page access time
  * @folio: folio to check
  *
- * folio's _last_cpupid field is repurposed by memory tiering. In memory
- * tiering mode, cpupid of slow memory folio (not toptier memory) is used to
- * record page access time.
+ * folio's _last_cpupid field is repurposed by memory tiering. When the
+ * owner of @folio participates in tiering, cpupid of slow memory folio
+ * (not toptier memory) is used to record page access time.
  *
  * Return: the folio _last_cpupid is used to record page access time
  */
 bool folio_use_access_time(struct folio *folio)
 {
-	return numab_in_tiering_mode() &&
+	return folio_numab_in_tiering_mode(folio) &&
 	       !node_is_toptier(folio_nid(folio));
 }
 #endif
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 991b80d5e899..3534dc63b5a9 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -854,7 +854,7 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
 bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 		bool is_private_single_threaded)
 {
-	int nid;
+	int nid, mode;
 
 	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
 		return false;
@@ -883,14 +883,16 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	if (is_private_single_threaded && (nid == numa_node_id()))
 		return false;
 
+	mode = folio_numab_effective_mode(folio);
+
 	/*
 	 * Skip scanning top tier node if normal numa
 	 * balancing is disabled
 	 */
-	if (!numab_in_normal_mode() && node_is_toptier(nid))
+	if (!(mode & NUMAB_NORMAL) && node_is_toptier(nid))
 		return false;
 
-	if (folio_use_access_time(folio))
+	if ((mode & NUMAB_TIERING) && !node_is_toptier(nid))
 		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
 
 	return true;
diff --git a/mm/migrate.c b/mm/migrate.c
index 4659ecdc4d0c..f3a84a5903aa 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -819,7 +819,7 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	 * memory node, reset cpupid, because that is used to record
 	 * page access time in slow memory node.
 	 */
-	if (numab_in_tiering_mode()) {
+	if (folio_numab_in_tiering_mode(folio)) {
 		bool f_toptier = node_is_toptier(folio_nid(folio));
 		bool t_toptier = node_is_toptier(folio_nid(newfolio));
 
@@ -2718,7 +2718,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
 		int z;
 
-		if (!numab_in_tiering_mode())
+		if (!folio_numab_in_tiering_mode(folio))
 			return -EAGAIN;
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 			if (managed_zone(pgdat->node_zones + z))
@@ -2760,6 +2760,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	LIST_HEAD(migratepages);
 	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	bool folio_tiering = folio_numab_in_tiering_mode(folio);
 
 	list_add(&folio->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_folio,
@@ -2770,8 +2771,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
-		if (numab_in_tiering_mode()
-		    && !node_is_toptier(folio_nid(folio))
+		if (folio_tiering && !node_is_toptier(folio_nid(folio))
 		    && node_is_toptier(node))
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
 	}
-- 
2.52.0


