Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644C460A2605
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G/12QFkb
Received: by kanga.kvack.org (Postfix)
	id 6B9A36B05B6; Mon,  9 Nov 2026 22:30:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6904E6B05B8; Mon,  9 Nov 2026 22:30:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD2E6B05B9; Mon,  9 Nov 2026 22:30:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9466B05B6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:30:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA682C0865
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:30:01 +0000 (UTC)
X-FDA: 85417780602.06.243E020
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id D17B21C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:29:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="G/12QFkb";
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794281399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXLX0Ahxuhi7Ry1DtDpYVsi3P/H10gWiQkGDuBbmQyY=;
	b=r4K3UWhsIAm/sHVMgRFizeVrxzQ0ej9phjton65ZJAcm8c0EcfSQgp9ef9Qm8ojrWEkPgj
	TPBXQ+uNt/1Crmh6SbOCAY0pdh+zTWGUG9Fhw9k36RpaOQc3BRZXZ3P4cOafvhw70HO96z
	OnsUkrloX1TjWbYa9vt/jrVJc1VdlTw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794281399;
	b=jfClyylaGodjQaWYmj+pBBKiFHWG1gb5jjR7AouV2dp1EM4PlEkj894XwnIh1PtDy5Xhg4
	f53z3EPeTEK2FQVlKN+qR15BWdOM6eOg9cg6jHHoxOXJkbzcKvaetbH9JZKwtjLc273v6n
	XwCzpBTVcRuhcQW2eDBApv2tj9gyBrQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="G/12QFkb";
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a070755c8cso763368b3a.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 19:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794281399; x=1794886199; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TXLX0Ahxuhi7Ry1DtDpYVsi3P/H10gWiQkGDuBbmQyY=;
        b=G/12QFkbE7Qr594sf0TObVjh3u0KaSrl3JSo6Y5OPY/UDVKEuD8+OkyuaHyrPQFy+Z
         FLaO+4Tq1wENlAsotPXvQwRG6tPeuNiIjwy9WuLN+9zrJFWBX75XZsNtyi+L1OD1A4Zd
         cBm4q97bgBWeHANAz8nJp7VXbohqLlhR4Jnlh6aPMBmrG5hkPXi4AWYTEDPL+Wf+hIgZ
         /BsY40vSzRVRECbvKndgkPMQExhV7fd9lt+JxyJNOATyOtHPHciqh1BkwHSpcIYSF77B
         JOWxhva4VsXJ2R/huCsPg05bvyk6NVTpUcI7HVZkVQUUlTbOSKQDoqUjH28D1aDhedoh
         ik+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794281399; x=1794886199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TXLX0Ahxuhi7Ry1DtDpYVsi3P/H10gWiQkGDuBbmQyY=;
        b=2S9yTHjBbqFXi71zg2dm8OFoXYo0bgPx3JgpROaQkQC21Af4RrsAaXpH/NMjFRoD2m
         D7YFEVK4FLKwt5zR3iY7dY8aHNtCujyvn2T2zi4dSxDr48k9hPRuilw+guIDmw6fbZHW
         TCME433nJNsmaF5MvAbiOVI+hr5lPzzGNLjospLvPtwxGmZQndoYIfi1OokDeDg3xygj
         mbncRJl0MJcaYupfAVheA6sm4aH1lCSnKq2BHaZUwJcf9xjM5f//CvjO10aIjHxbXTrN
         0kvwVOlcmS6RwHDVgSNohxAVn4CNN5WoGLv2rMyyEFe4RZlsr4t56Hiy/WleTOzo7T7m
         G8Rg==
X-Forwarded-Encrypted: i=1; AL+hErH39CuJcorbVBSliffFRmKDxFA+P8vhlM/0QM45ZUGwP/kg/69GhAwIkiU9fjzijPtNyONeP5aEsg==@kvack.org
X-Gm-Message-State: APuU4Z+H8prVSKtM0mqyXp8WkiTAAj+xXhCN+PM2vARx3WIycnE1W+BN
	k/CufXADyTyzAepjavvvO0GDdKvgIwFA5AKoEt/GcxvH2ofryqaKo3vV
X-Gm-Gg: AYBFou2YRSQTQ5+CBQ1glFLTYw80jUWQ030ENwyZPrz2QoC8rK266MiEEY0mgpl4049
	eRZngkhD6nuqKxiwnjGSx/tnL+oOUNsJqN8HFdpnwtZeJsvXGjtNnxsUyen1yJxnak8S+EE7d9Z
	IkyfXXcvj8Gmgrirgnk0WV86xJCMFHVDhNht7pHvZue864HsuoLE44r9psNNSs9SELEPxzjrZRB
	Psu4fNY3X2rP32LzvPOFzzrW192tPwm6xEFlj38UT4wq54MU3NIZSlP+QKhyyyRiGveLTklo1m4
	ZTbs6f6aBmT+CSrkJnC1an2x0C9p6GIUBO64Zxp+QAOEmRNfEGwQOuaHWJVqIqX+r9wc0dpN3Lp
	yLBnDIsU0ECTVvvHvbyXwN3VGPsSM9Wz11A2bsaaE2g0t2l3YiCqJHpu8/ow5sQ6xJErNR0lPRT
	YijJvUZhWK/77Z5zq/OFUYP8EJy59VWwx1cnv/nwf9ahrAXmqWamWuBJsNETLKSu2ho1tSiZMqJ
	2eAaTFBReGl+axwbTFQrAoxCMPsbT1KW9/uqWc292UyMwHOGLhL8qsKDKEYy8hiEj9oq1IeOqiB
	r42qdthDMfH3jzRznw1XT+AVEbuOacLjieDA6hShV9tzq/loy8Jd3mK/xjeUsDJxNwRNtEa9Fc2
	HUvjGQF8LvTVm8pB1noJM6GqD
X-Received: by 2002:a05:6a00:390b:b0:8a0:6905:248 with SMTP id d2e1a72fcca58-8ba83bd70bamr1752498b3a.3.1794281398643;
        Mon, 09 Nov 2026 19:29:58 -0800 (PST)
Received: from localhost.localdomain ([240e:46d:1d00:5ed4:58d0:d294:d44c:6ae8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab21835fsm336973b3a.42.2026.11.09.19.29.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 19:29:57 -0800 (PST)
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
Subject: [RFC PATCH bpf-next v4 2/4] sched: sample NUMA balancing mode once per path
Date: Tue, 10 Nov 2026 11:29:11 +0800
Message-ID: <20261110032913.71974-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261110032913.71974-1-laoar.shao@gmail.com>
References: <20261110032913.71974-1-laoar.shao@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: knu8be4dpa8q6yj3wofzpeqdfqyusd7g
X-Rspamd-Queue-Id: D17B21C0005
X-Rspam-User: 
X-HE-Tag: 1794281399-711868
X-HE-Meta: U2FsdGVkX19cxIgH4e3ZnkCmy2g0Nwkpw/RNFmZtUPtdQ4EkyZ3cvinL8b3PgU89AnVpEGJZulyvl3QpRssR784ZJA88KBqwrfLyESl/aZrvqmy/PciNkZlt9FNUAqW6p/MjCSNHlEYNC/EKtQkNM/nCUQV/hf0AT0POPGkcV0tXxo3sgNVBIDs/EbzG11cSQ2ouw2k8l93OmCwYcJHbi7I+4663cdHJJygThf9z4b51Q76fA+wJAB1BLrKeGj/uchUYvPrH/dEbbnA0QhU8YGo5HPk1swOH28PqCX/9/yzmpJMxyp579Gati+alezcLpGGbcwdbUyjoICqI3+AVcFKCGdGnb7FnG7xkBufkZ1xB3gLiGgWuQAYcShjkf9+Cm0zNR+QCkb44YmkacyZJCUuwpngB/CBRxWYCDrPFlwY8s4pbDJJEpA+e6ZelYiBuAZaN26/5t+xaggnCBHPnROpWtdq8JldZjlx0wBmZlJQv/B/sgHYHG+FIauxYxpRp71xozOT5Lc12h9wUcI0kh8ixMmsfTK7BHlt4eKdIgFOtLkAFv8nHPJLXSN0Ko9fMOUgHITvsw2b6poYvzDWExHb2Zp8im4K8XfdGi8m6RvytzRDxaQhdLoStZyp2huDALu4nN2+GDcPiyvb80/cNf+OfHdXjR2+fN9xNnj7H//zWtG38BPq4Tw81mdrS+tRMwPoDg+T3K2ZJgEPg+O+2vJ1I6XUZSmM8Z4mnDLVvhc6OOakmwICdKKwjYhePV58Lod0qe1Ezz7KH5M1LZXH2woRzBy9K5lkkEz6Zf9L8AILMy78dlfRgnFpl/CUC5+4sI1Dw6jC/00z8LE54JjLZOjC7F9jNgAlxkTKcr40Vj9Tph3HtmUraNd8N0hq902xj1uxKu4kTUGFrXiK6ABXTwcNpXY5DxYk2fexmIreJ6WLxYB8gFtG48+G0Hon//ZTBtWcROZLOw2U4umLY4yo
 lehoWEYg
 hJtc8MedcB/yOHU3bT+DWOr7NbZNfiPjYAbuXIyoRJF0BpS5yNF+ujsvWcplX/6+VnYWXM5vZu3THcWKM8fJI6aSzKOVVvhmBlthfcE3HYc/q7vMq6lMLuAFBkekzSc6/AIl0zFWoUXmMPHdO/gSj+a94U/iu6AgxAhWT5LOZL32mXZRTEwIpG0uDyxNdeqlLHbNcNw0TNm/MDnITohp6pYVGLfoDNhIehmXes/+ON/iLmOP+eCdQaN3Vv2YNpWvJpSdF2ZaYOOfE1u2rgwQmvLAc8sz/40bj7quUm0FxUsi1m7FOBMMtaQ+OALJgXjQsQebWGisFoSC06iHRsctRJVpxBLzAMZGHjDWyTVZ1WtiNtMUXICpNtGLqMF0fKQ+DFHvNFW2q0MmagMZ6wzsaUaCRlIx3lm83B3HDrxjCST5fcE7G74cAVzagiKVpVwA2altlZxBTuJeW6yw8h+wwVxFfxJfqIPpvh2OtVV83n9Nwh/Ij3iJ6RaCwvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Take one snapshot per path and pass it down.

No functional change.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/sched/fair.c | 77 ++++++++++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 26 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 672dda541458..18b976a47afa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1422,7 +1422,8 @@ static inline int get_sched_cache_scale(int mul)
 	return (1 + (tol - 1) * mul);
 }
 
-static bool exceed_llc_capacity(struct sched_cache_group *grp, int cpu)
+static bool exceed_llc_capacity(struct sched_cache_group *grp, int cpu,
+				bool numab_enabled)
 {
 #ifdef CONFIG_NUMA_BALANCING
 	unsigned long llc, footprint;
@@ -1435,7 +1436,7 @@ static bool exceed_llc_capacity(struct sched_cache_group *grp, int cpu)
 	if (!sd)
 		return true;
 
-	if (task_numab_enabled()) {
+	if (numab_enabled) {
 		/*
 		 * TBD: RDT exclusive LLC ways reserved should be
 		 * excluded.
@@ -1801,7 +1802,8 @@ static unsigned long fraction_mm_sched(struct rq *rq,
 	return div64_u64(NICE_0_LOAD * pcpu_sched->runtime, rq->cpu_runtime + 1);
 }
 
-static int get_pref_llc(struct task_struct *p, struct sched_cache_group *grp)
+static int get_pref_llc(struct task_struct *p, struct sched_cache_group *grp,
+			bool numab_enabled)
 {
 	int mm_sched_llc = -1, mm_sched_cpu;
 
@@ -1823,7 +1825,7 @@ static int get_pref_llc(struct task_struct *p, struct sched_cache_group *grp)
 		 * than sched_setnuma() at least -- and thus the
 		 * conflict only exists for a short period of time.
 		 */
-		if (task_numab_enabled() &&
+		if (numab_enabled &&
 		    p->numa_preferred_nid >= 0 &&
 		    cpu_to_node(mm_sched_cpu) != p->numa_preferred_nid)
 			mm_sched_llc = -1;
@@ -1842,6 +1844,7 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	struct sched_cache_time *pcpu_sched;
 	int mm_sched_llc = -1;
 	unsigned long epoch;
+	bool numab_enabled;
 
 	if (!sched_cache_enabled())
 		return;
@@ -1875,14 +1878,19 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	 * its preferred state.
 	 */
 	if ((long)(epoch - READ_ONCE(grp->epoch)) > llc_epoch_affinity_timeout ||
-	    invalid_llc_nr(grp, p, cpu_of(rq)) ||
-	    exceed_llc_capacity(grp, cpu_of(rq))) {
+	    invalid_llc_nr(grp, p, cpu_of(rq))) {
 		if (READ_ONCE(grp->cpu) != -1)
 			WRITE_ONCE(grp->cpu, -1);
+	} else {
+		numab_enabled = task_numab_enabled();
+		if (exceed_llc_capacity(grp, cpu_of(rq), numab_enabled)) {
+			if (READ_ONCE(grp->cpu) != -1)
+				WRITE_ONCE(grp->cpu, -1);
+		} else {
+			mm_sched_llc = get_pref_llc(p, grp, numab_enabled);
+		}
 	}
 
-	mm_sched_llc = get_pref_llc(p, grp);
-
 	/* task not on rq accounted later in account_entity_enqueue() */
 	if (task_running_on_cpu(rq->cpu, p) &&
 	    READ_ONCE(p->preferred_llc) != mm_sched_llc) {
@@ -1919,12 +1927,12 @@ static void task_tick_cache(struct rq *rq, struct task_struct *p)
 }
 
 static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p,
-			      struct sched_cache_group *grp)
+			      struct sched_cache_group *grp, bool numab_enabled)
 {
 #ifdef CONFIG_NUMA_BALANCING
 	int cpu, curr_cpu, nid, pref_nid;
 
-	if (!task_numab_enabled())
+	if (!numab_enabled)
 		goto out;
 
 	cpu = READ_ONCE(grp->cpu);
@@ -1991,6 +1999,7 @@ static void task_cache_work(struct callback_head *work)
 	struct task_struct *p = current, *cur;
 	unsigned long curr_m_a_occ = 0;
 	unsigned long m_a_occ = 0;
+	bool numab_enabled;
 
 	WARN_ON_ONCE(work != &p->cache_work);
 
@@ -2019,11 +2028,16 @@ static void task_cache_work(struct callback_head *work)
 		return;
 
 	curr_cpu = task_cpu(p);
-	if (invalid_llc_nr(grp, p, curr_cpu) ||
-	    exceed_llc_capacity(grp, curr_cpu)) {
+	if (invalid_llc_nr(grp, p, curr_cpu)) {
 		if (READ_ONCE(grp->cpu) != -1)
 			WRITE_ONCE(grp->cpu, -1);
+		return;
+	}
 
+	numab_enabled = task_numab_enabled();
+	if (exceed_llc_capacity(grp, curr_cpu, numab_enabled)) {
+		if (READ_ONCE(grp->cpu) != -1)
+			WRITE_ONCE(grp->cpu, -1);
 		return;
 	}
 
@@ -2033,7 +2047,7 @@ static void task_cache_work(struct callback_head *work)
 	scoped_guard (cpus_read_lock) {
 		guard(rcu)();
 
-		get_scan_cpumasks(cpus, p, grp);
+		get_scan_cpumasks(cpus, p, grp, numab_enabled);
 
 		for_each_cpu(cpu, cpus) {
 			/* XXX sched_cluster_active */
@@ -2138,7 +2152,8 @@ void init_sched_mm(struct task_struct *p) { }
 static void task_tick_cache(struct rq *rq, struct task_struct *p) { }
 
 static inline int get_pref_llc(struct task_struct *p,
-			       struct sched_cache_group *grp)
+			       struct sched_cache_group *grp,
+			       bool numab_enabled)
 {
 	return -1;
 }
@@ -2867,6 +2882,9 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	struct numa_group *ng = deref_curr_numa_group(p);
 	int dst_nid = cpu_to_node(dst_cpu);
 	int last_cpupid, this_cpupid;
+	bool tiering;
+
+	tiering = numab_in_tiering_mode();
 
 	/*
 	 * Cannot migrate to memoryless nodes.
@@ -2878,7 +2896,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	 * The pages in slow memory node should be migrated according
 	 * to hot/cold instead of private/shared.
 	 */
-	if (folio_use_access_time(folio)) {
+	if (tiering && !node_is_toptier(folio_nid(folio))) {
 		struct pglist_data *pgdat;
 		unsigned long rate_limit;
 		unsigned int latency, th, def_th;
@@ -2907,7 +2925,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
-	if (!numab_in_tiering_mode() && !node_is_toptier(src_nid) &&
+	if (!tiering && !node_is_toptier(src_nid) &&
 	    !cpupid_valid(last_cpupid))
 		return false;
 
@@ -10696,13 +10714,14 @@ static int task_hot(struct task_struct *p, struct lb_env *env)
  * Returns 0, if task migration is not affected by locality.
  * Returns a negative value, if task migration improves locality i.e migration preferred.
  */
-static long migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
+static long migrate_degrades_locality(struct task_struct *p, struct lb_env *env,
+				      bool numab_enabled)
 {
 	struct numa_group *numa_group = rcu_dereference_all(p->numa_group);
 	unsigned long src_weight, dst_weight;
 	int src_nid, dst_nid, dist;
 
-	if (!task_numab_enabled())
+	if (!numab_enabled)
 		return 0;
 
 	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
@@ -10744,7 +10763,8 @@ static long migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 
 #else /* !CONFIG_NUMA_BALANCING: */
 static inline long migrate_degrades_locality(struct task_struct *p,
-					     struct lb_env *env)
+					     struct lb_env *env,
+					     bool numab_enabled)
 {
 	return 0;
 }
@@ -10946,7 +10966,8 @@ static inline bool sched_asym(struct sched_domain *sd, int dst_cpu, int src_cpu)
  * destination LLC in terms of cache aware load balance.
  */
 static enum llc_mig can_migrate_llc_task(struct lb_env *env,
-					 struct task_struct *p)
+					 struct task_struct *p,
+					 bool numab_enabled)
 {
 	struct sched_cache_group *grp;
 	bool to_pref;
@@ -10971,7 +10992,7 @@ static enum llc_mig can_migrate_llc_task(struct lb_env *env,
 
 	/* skip cache aware load balance for too many threads */
 	if (invalid_llc_nr(grp, p, dst_cpu) ||
-	    exceed_llc_capacity(grp, dst_cpu)) {
+	    exceed_llc_capacity(grp, dst_cpu, numab_enabled)) {
 		if (READ_ONCE(grp->cpu) != -1)
 			WRITE_ONCE(grp->cpu, -1);
 		return mig_unrestricted;
@@ -11060,7 +11081,8 @@ migrate_llc_task_wrong_dst(struct task_struct *p, struct lb_env *env)
  * Check if migrating task p from env->src_cpu to
  * env->dst_cpu breaks LLC localiy.
  */
-static bool migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
+static bool migrate_degrades_llc(struct task_struct *p, struct lb_env *env,
+				 bool numab_enabled)
 {
 	if (!sched_cache_enabled())
 		return false;
@@ -11087,7 +11109,7 @@ static bool migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
 	if (migrate_llc_task_wrong_dst(p, env))
 		return true;
 
-	if (can_migrate_llc_task(env, p) != mig_forbid)
+	if (can_migrate_llc_task(env, p, numab_enabled) != mig_forbid)
 		return false;
 
 	return true;
@@ -11113,7 +11135,8 @@ migrate_llc_task_wrong_dst(struct task_struct *p, struct lb_env *env)
 }
 
 static inline bool
-migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
+migrate_degrades_llc(struct task_struct *p, struct lb_env *env,
+		     bool numab_enabled)
 {
 	return false;
 }
@@ -11125,6 +11148,7 @@ static
 int can_migrate_task(struct task_struct *p, struct lb_env *env)
 {
 	long degrades, hot;
+	bool numab_enabled;
 
 	lockdep_assert_rq_held(env->src_rq);
 	if (p->sched_task_hot)
@@ -11213,14 +11237,15 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	if (env->flags & LBF_ACTIVE_LB)
 		return !migrate_llc_task_wrong_dst(p, env);
 
-	degrades = migrate_degrades_locality(p, env);
+	numab_enabled = task_numab_enabled();
+	degrades = migrate_degrades_locality(p, env, numab_enabled);
 	if (!degrades) {
 		/*
 		 * If the NUMA locality is not broken,
 		 * further check if migration would hurt
 		 * LLC locality.
 		 */
-		if (migrate_degrades_llc(p, env)) {
+		if (migrate_degrades_llc(p, env, numab_enabled)) {
 			/*
 			 * If regular load balancing fails to pull a task
 			 * due to LLC locality, this is expected behavior
-- 
2.52.0


