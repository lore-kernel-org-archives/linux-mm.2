Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B13606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=UIZ7nvGJ
Received: by kanga.kvack.org (Postfix)
	id 4C9356B05C1; Tue,  3 Nov 2026 03:00:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7116B05C2; Tue,  3 Nov 2026 03:00:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3417B6B05C3; Tue,  3 Nov 2026 03:00:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10E166B05C1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:00:39 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A23816035D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:37 +0000 (UTC)
X-FDA: 85393060914.07.1B7860C
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by imf10.hostedemail.com (Postfix) with ESMTP id D4472C0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=UIZ7nvGJ;
	spf=pass (imf10.hostedemail.com: domain of matthew.ruffell@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=matthew.ruffell@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692835;
	b=vTYkImWhgUVZDUXBN5VeDHcc1pwM6Pmw43ZsUKJr+Fww8XN/DOIoO5Im/HQBrWAt1zIySa
	n16Or1DyvxkTEL8+hPnEZFPmSWOQgzzuFokOr4hHSGxuBbDwJjrNmveFEbg7uCumhaStfu
	2mFNFlfqmhzE3HYWaTW9UaRGLf4GeCw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T8zb3wMITIwc0YE32nW2cv2RNb7OiLJ0144r3mIJzPg=;
	b=r1QHOVFfJLkfVABpO4vDocmkaLWrjLrL2/Dlzba6RDFpl9NJcv+5RZ2amrAB6AJYEYmllz
	KlCYBse/dc5s2il4RsuI3VVZ8jWkxS2UGkO26WE2Rbjw3J4keNmn9vKkXVuVtfcmUQla6d
	swb3nlZXLuFhpppsBSf5N4UB2hMVkhM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=UIZ7nvGJ;
	spf=pass (imf10.hostedemail.com: domain of matthew.ruffell@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=matthew.ruffell@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 78EFE3F5D4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692833;
	bh=T8zb3wMITIwc0YE32nW2cv2RNb7OiLJ0144r3mIJzPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=UIZ7nvGJIG+sZFnD5a2PhAo7R+1VRHTTj5tcQ9agWWGqguxjGWfXQxShCVJNqqxjh
	 7+eYGCu2IIr/4IkbD2B9bEvoB5XJVN1oas8l8eE11iA1EddyzowpzfENN0thWISoeP
	 ME230/40+1EYDuQ9NOu5uWce3VCPSKt+qawfobSipY17OHfPqsHIROBvmybfYO8Dyn
	 8H43ByagapbMD5a7Gm6hJdXR/OaB07mxJWj+tiKyMxCQq8F9v4OiCab3ATYauCof3u
	 klIB83wh7QqxArr/oMPbt1TW/UZFf3/fsWQO9eSEroeqme4fWkJV6uH3WIyFQACdIb
	 mND213+P4+V6v9+JAkqxZmsQaDLnjrgEiBg6Bb9qr/mRaVSNMzCsCHQ3hLhyrY8ohM
	 gseKbZ00eBIXVscg1kTDlHTKDRZVRZlvZjcSorFfdZt+tg+jM1ORCu+KJKxwxVb2xx
	 nlIJu1szBd32ZNlo7QfNzVenxGCoHX0gIQx8YocXAAg4urjY4DpQ+nDH60RUn9hMw4
	 k5ehBI/nrghGdKi+An6t3RGG2LearEX+D4F7VbDWacVfBMwrsWzbWyO4o/80iUYCdR
	 KAddM6unYm7VNE67IyYpzzgd8mFdqGsP3kXnsu/0Hn6AC6OOTO+6W4ERi4kA19aCT+
	 llkWm58IhOiis8+Uj1DaThqs=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso8653648eec.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 00:00:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692832; x=1794297632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T8zb3wMITIwc0YE32nW2cv2RNb7OiLJ0144r3mIJzPg=;
        b=sEbHKOAm2/tpkTzAV72uLG9+CSgfgjJIzIjXzflrZ7qkYNu3pA73gPlo7RQEXio6qH
         4/96k81vFFXO2UP9X36ZmPGPB5cF06NlxdQXJLn0U/d4u6KbdD4mrooMbG1alkpJ9ECY
         O8pv8qIUTKtRYsDMly1eGQ6s0kjPvhLr0GIClDDmzX2v4t8b4rVy7cbvGJzMb0V1CVm6
         n4os9MtT2dagJEjtzOIH4YDWyafZSy2pKlUtcw1Dcf6UJqNrO1HCr7X9+jbPBtLidDWw
         28ADQGtjWJV9x1ipOKqAEOM0LniozmLm5BNPt6dpoeECbDKlBACgDSsgstQ5lzyGT+Ad
         XNRA==
X-Forwarded-Encrypted: i=1; AKwUvBxIAFQ5T43yXNEHdYMf7kekIusaZzByZTkCL88kg+YnQclePcZbg9Eraqc3lWB2ExsuoH6LeBn2vA==@kvack.org
X-Gm-Message-State: APuU4Z8sgaUnrHJDkh7qnf0Vg5nd3Oeo1XkZeIZvZU8mrtlqlbbBA3MZ
	v60J8PICGyTu2PX0SOpu7eokSDqS3fCxu1yCtCjdXIfKYDvpIvdzH3qD2WDQIz5r1JfmPmvyXfg
	86H+pZIBM3FwrKGwpPAPH5YhS7CfnHFxuQYNTcSBfQ29N2eKuNV8hgnpGB/ujG4Vtxn0TOmIs9z
	aO9J0=
X-Gm-Gg: AYBFou3Y2mGOvoFLYi08iRPf2XS5RPBN+YerobBYzKkSahPHeM5VS9FdBWuaRXLBV5+
	872qtHfEOem4ZuQt4GHr1oTBYg++we5RPfDzxC2ZTURxsTKvQuSCU45rvZ+yc5VDLm3OVdok0Qa
	Zfmrg0lBEePZaavpUDAHq//sepXbgyxoDH6pp3sYzYNwozzNW/J3aZo6JQCiGttSmJUnqiZyc5W
	rc9ZZIrWuvabKIrhtNL7oZd3xXocoL3gF1ZIRll1ZAJZ7RHMlpd+Z6DP5nLyWKeORaFQqXSycJ8
	x2ILsDKz35oJGZq9tOYRiKbG05Q5uhA6biyouO5AvrUVdhAdwk9yAMKnK2NdWyhjbtzlINw37s7
	EUGp8jN7DuPOu+umCKXFgATWRejbQ9A5SJIJMzIRNUtq4ETpozB7ZSjYsaVcYx/kKPNcLNDKn0l
	aBr03d4MULnCA/LpzFCQ==
X-Received: by 2002:a05:693c:20d3:10b0:369:fa21:ba0b with SMTP id 5a478bee46e88-36a42451227mr19269599eec.33.1793692831570;
        Tue, 03 Nov 2026 00:00:31 -0800 (PST)
X-Received: by 2002:a05:693c:20d3:10b0:369:fa21:ba0b with SMTP id 5a478bee46e88-36a42451227mr19269546eec.33.1793692830912;
        Tue, 03 Nov 2026 00:00:30 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.03.00.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:00:30 -0800 (PST)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 2/6] kthread: Keep unbound kthreads off nohz_full CPUs
Date: Tue,  3 Nov 2026 20:59:36 +1300
Message-ID: <20261103075940.110308-3-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: 4dy6socfqzkdqui7jj6h45udi15onarm
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D4472C0003
X-HE-Tag: 1793692834-205894
X-HE-Meta: U2FsdGVkX19so9snH854IqsJtt+4GHGQzNRl1hi60z/Za6sTsp3w2Fp0S1mwJYEcZq/y6JX/L8M+tTt05WJapDRs9+TvddLk4K4NnH1G3/Nge5cfV/Yu4Q8mQZzYvCemFjJXo2EIkaMkUZAFdknO4wDoIJab15P5gG5Z9qbEgOACTh7nD1smz2MJBvrVmXJQEc5t7iZEEwsx11HFFbWZf1G2FFcgCSYx/9Azzx0RQ9zEkwwmUE6z31Xiyw4WHZaiFMfLRZDHY6DfgGpcIo5UpT5yE//bioQaYzA5JU1BCFgLanBJ+dud5xTBUHeXZHjcE73Q/Ve4BDpOFplp8PxqQVrzhzSdo/KX/mZ47E5ThkOJ/vBUHeVLyHXAdscIKo3oxCYfiO/Y22tOfEjt0o9qiH5csRzp69EJixAhy7hq1s1Ui+HIxcJxMNGsQBWe5KYjGZxQRPplM9h6d6eh8q2ud0j7nWVtUk4wm0c1fyPvNKsEhmdADkpoRw1A3ziucf1ys9CxAf9k4U4OLg7YCKWtBrjNpFCsm9h2K35PUBpou0TVMdCNVVXuEzwZL8YtiRC//h+ccpExQ2/pjTmlJSTlgPYial2yScgSwtNDAUMU0uwaov2dhQLZsbUqz3u4dcqnWH5uL0l72K6dxjvmYQRGjZUJ+v2ql3OGlueg01szamWDcPf/llXYiTWPW8VlG8+nVYgSauX/YNTUQ1cwUYksf+Wn96IOni4jZFiOmpS0yVTNGhVu5OWa6rQToPC4tj22fpfk2oMnHdO2RBuOLKPXRVn5lsUXyB87MMmKvKIwWhhIZwO97w9DrunPEj+4b31n/MB2wIlz0n7pG5dDaGhh68ACV87YBkYAAM8Zg16cnSqzP66GgaiejbDOjYW/O926rMhZXqgcYzlPtRax5HODCBiihv+NMbSzDAKFx91wAfpug+LJ4q3IIEl2Nvj+8PCiFbglXrIIXHwsLxXuKNv
 R7D33g/1
 qhinBdgnG6QfLESvz4HkJnZ8PdckQd+EWLWZEWxzI+lq3sPZfn11mlI8n9HemrxxGaHFT0+GgcLd5ylAiagLszicUaD1XLjQ0f4QpnfPqbIdPBu18+YKsJ6f+KndqGQ9fYbW+dQlv1FEqOK8qoFCqAnmMj9SjOVagx2DGihCQQWNyYsCHoDg7hMx6K5TmOzICPp4FqVdwDyQpXG1fjBwGF+oaeb6N2pNySysizq8EmAo4uZhWlEVKygGS3vldpaoNm27VkV+F9fpCp4E4aMhVLOzjX7BBYmrKYDD0I/4LrEZCifOeUZm+7kODOQlX/o1WLphLJgfRfgbdw2eB521/+DMahq0QMl9R7+wKyrwL9MyJsH3sgXxdvFyrMhlneREnCTTYbp48RWcDsaYePy3T86u9c3K40S6xQ72brP39XBRJiMx9XDXhXM29xyqppDuxkanfa+CBlytzd2QE+j8aMwG8Phl1q4KW9gO4Zls/NuzkVWAampSWJGkJYR4cOdaH7MJZv3Kiq4Jw2Gc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caron Wills <caron.wills@pulsar.com>

Since commit 041ee6f3727a ("kthread: Rely on HK_TYPE_DOMAIN for
preferred affinity management") kthread_fetch_affinity() only removes
domain isolated CPUs from a kthread's affinity, assuming that nohz_full
CPUs are always domain isolated as well. Up to v6.13 every kthread
inherited kthreadd's affinity to housekeeping_cpumask(HK_TYPE_KTHREAD),
and from v6.14 the preferred affinity was filtered with HK_TYPE_KTHREAD,
so nohz_full CPUs were always excluded.

On a system that keeps its nohz_full CPUs in the scheduler domains, e.g.

  isolcpus=nohz,18-95,108-178 nohz_full=18-95,108-178

HK_TYPE_DOMAIN covers every CPU, and the RCU expedited grace period
workers rcu_exp_par_gp_kthread_worker/N, the RCU boost kthreads rcub/N
and every NUMA node affine kthread can now land on nohz_full CPUs.
rcu_thread_affine_rnp() prefers the CPUs of the rcu_node, so for a leaf
rcu_node made entirely of nohz_full CPUs the worker is pinned to nothing
but nohz_full CPUs.

Those workers are SCHED_NORMAL (CONFIG_RCU_BOOST=n leaves kthread_prio
at 0), so a SCHED_FIFO userspace busy loop on such a CPU starves them
indefinitely. Every synchronize_rcu_expedited() in the system then
blocks in sync_rcu_exp_select_cpus() -> kthread_flush_work() until the
FIFO task yields. LP: #2165410 captured exactly that on three 7.0
kernels: the cpuset_migrate_mm kworker sits in

  synchronize_rcu_expedited+0x1b2/0x220
  lru_cache_disable+0x15/0x30
  do_migrate_pages+0x4e/0x2b0
  cpuset_migrate_mm_workfn+0x26/0x50

with rcu_exp_gp_kthread_worker in D state in kthread_flush_work(), and
PID 1 waits behind that migration in flush_workqueue() for minutes.

Intersect the affinity with the HK_TYPE_KERNEL_NOISE housekeeping mask
as well and fall back to the CPUs that are housekeeping for both types.
On systems where nohz_full implies domain isolation the two masks are
identical and nothing changes.

HK_TYPE_KERNEL_NOISE is named explicitly rather than HK_TYPE_KTHREAD:
commit 8f78b749f3da ("sched/isolation: Make HK_TYPE_KTHREAD an alias of
HK_TYPE_DOMAIN") (v7.1-rc3) turned the latter into a synonym of the domain
mask, which is precisely the assumption being corrected here, and made a
first version of this patch a no-op on 7.1+ kernels.

Fixes: 041ee6f3727a ("kthread: Rely on HK_TYPE_DOMAIN for preferred affinity management")
Link: https://bugs.launchpad.net/bugs/2165410
Signed-off-by: Caron Wills <caron.wills@pulsar.com>
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 kernel/kthread.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index fdb8fb07f40b..b9d8dfe1b6ca 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -327,24 +327,46 @@ void __noreturn kthread_complete_and_exit(struct completion *comp, long code)
 }
 EXPORT_SYMBOL(kthread_complete_and_exit);
 
+/*
+ * Unbound kthreads must run neither on domain isolated CPUs (isolcpus=domain,
+ * cpuset isolated partitions) nor on CPUs isolated from kernel noise
+ * (nohz_full=, isolcpus=nohz). The two sets usually coincide, but the kernel
+ * accepts nohz_full CPUs that remain in the scheduler domains, so both
+ * housekeeping types have to be honoured.
+ */
 static void kthread_fetch_affinity(struct kthread *kthread, struct cpumask *cpumask)
 {
-	const struct cpumask *pref;
+	const struct cpumask *pref, *hk_domain, *hk_kthread;
 
 	guard(rcu)();
 
+	hk_domain = housekeeping_cpumask(HK_TYPE_DOMAIN);
+	/*
+	 * Deliberately not HK_TYPE_KTHREAD: since v7.1 that is an alias of
+	 * HK_TYPE_DOMAIN (commit 8f78b749f3da), which is the very assumption
+	 * being corrected here.
+	 */
+	hk_kthread = housekeeping_cpumask(HK_TYPE_KERNEL_NOISE);
+
 	if (kthread->preferred_affinity) {
 		pref = kthread->preferred_affinity;
 	} else {
 		if (kthread->node == NUMA_NO_NODE)
-			pref = housekeeping_cpumask(HK_TYPE_DOMAIN);
+			pref = hk_domain;
 		else
 			pref = cpumask_of_node(kthread->node);
 	}
 
-	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_DOMAIN));
+	cpumask_and(cpumask, pref, hk_domain);
+	cpumask_and(cpumask, cpumask, hk_kthread);
+	if (cpumask_empty(cpumask))
+		cpumask_and(cpumask, hk_domain, hk_kthread);
+	/*
+	 * Both the boot parameters and cpuset guarantee that at least one
+	 * CPU stays housekeeping for every type, but don't rely on it.
+	 */
 	if (!cpumask_intersects(cpumask, cpu_online_mask))
-		cpumask_copy(cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
+		cpumask_copy(cpumask, hk_domain);
 }
 
 static void kthread_affine_node(void)
-- 
2.55.0


