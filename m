Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E522C44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 18:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2C26B0095; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E176B0098; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6196B009B; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E33756B0096
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 14:55:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19AF040620
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:26 +0000 (UTC)
X-FDA: 85006429452.12.E702B11
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8479040004
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=C05pp2fR;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf11.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784487324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qa4YjEBQvZIx5KKQpuyATR3R1yqVaUF8NDQIptYbS9w=;
	b=3BG4p8K0evbKB2saDJb88ufR5HnBK7iBFY3CjT44p3+DJlAMLCEJWTjJ+Z/i3hKHCIuWlV
	k8aOdpziPgVOQZI4dwvuTd4/TC/pfmqpLdFnrwpYFq2PquL6Lw0ffhKXkEWHAxJsHBJAkk
	zUiC3w2BAQ+ZO6ophf2j8AdN4xYAoFA=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=C05pp2fR;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf11.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784487324;
	b=jkVzdCrYXthYNROhHmUgD6Xp2uB3xXrBk54lH/vr3t0DEo5GTNyUiOiSX0sZWmuaPXMl6V
	VRcvPGWnwo8EtTdaDbhJszmMKMu7Am7pDw9CLDgYoYr2tGE3rcuMmoBoJXm1GeoqgQHp+/
	+ZNLSFY0dAxEqFP7bm6M2nct44ji8us=
ARC-Seal: i=1; a=rsa-sha256; t=1784487286; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=eoZkNbwBdZ3sAgobW/+MD+mXYVUfuXZoh0PW0dkgph8ontDVOymnyy1uza09p8k77a70nNrVW96Qn+v20s7gIEdyp2cENVyM1hAe5gVkW1GJ8Wkf7+xzOjnVW756s8T8BDOt102znL4MIw1E64+K/vwgxKTx6+pp2Dg5zGYvwAU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1784487286; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=qa4YjEBQvZIx5KKQpuyATR3R1yqVaUF8NDQIptYbS9w=; 
	b=RumEku92gkeZHIU445cPHdCm6F2NbcdDI8sOZqYysLMAXLb1ia2xJVM1sWdPbMOZCavKkoFq4gHjFPycY/l2woYI0GaTPtS8798o7u69arMuhea2EZK4BqlA6OGC0kkVfg7mmd07XdZxF2OvqnuPD71ytNVE+Whco2F8m61JEoc=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784487286;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=qa4YjEBQvZIx5KKQpuyATR3R1yqVaUF8NDQIptYbS9w=;
	b=C05pp2fRMkzVr8EPumtScLZSIAxiwWdUw5nGAZ6j0AL9hOYugDThqSgbodVFyuVJ
	A1Y2esHcmBZrPnoeJjnr1gPKNpdfV00uui6p8qfuO2jb3SBK4h7a0P2GXYiStBTMM2e
	p5ydWfmf3m05+2byNLHwxHVe1msEDc+gV6JSpuXQ=
Received: by mx.zoho.in with SMTPS id 1784487285082857.0950681993331;
	Mon, 20 Jul 2026 00:24:45 +0530 (IST)
From: Aditya Sharma <adi.sharma@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imbrenda@linux.ibm.com,
	Aditya Sharma <adi.sharma@zohomail.in>
Subject: [RFC PATCH 5/7] mm: add runtime toggle and sysctls for async teardown
Date: Mon, 20 Jul 2026 00:24:07 +0530
Message-Id: <20260719185409.409685-6-adi.sharma@zohomail.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260719185409.409685-1-adi.sharma@zohomail.in>
References: <20260719185409.409685-1-adi.sharma@zohomail.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8479040004
X-Stat-Signature: 4b9wiy8q3hjg45zbyn57qb5539gx9kce
X-HE-Tag: 1784487323-905291
X-HE-Meta: U2FsdGVkX1+etyXePo/lXykvvfJMDHYajkFLG+m8tvbjyvcqBc24fMq35pZTw31m3/sqBgrFOmYU+Chza/GA9NXD94DvSHWyZ1KcUXK8avy44PniXCaeytl+gRbEhmH1NmjbD55vJTOLFHZeLRNpAdQPiWq0t9XbEsudmNv+TXfcF/rFeB5F31l73x7jXUBwKzfCowfRtCO9wzvmOb8ne08rs5wOqd0oMXW9wHS+nWvoiGd7P+Qy5+fCf5ilIdHwavwmGVkiXDv4KhgD3i276raUhguPG33QwC93/IaKB3zoC6dQ4rGvm6X2oC3iwzmTXqKTs7MFoqqFmC5E4NHmXfPFdEo+JvX7brBV/QBwGLmjBWpD6gtTSZ2ovgs8PXuWYWEJoS+idyHMRQj9xxIQUqBcIGnd3ojS0AKJO5THrOGD2ZVXV0UQKu8LUfXoJpm5VeUxDNjdwqf61ADidpxE14uxb9TNAtkT8RJFYlUjePQ84AKc3PLdwzsge9l33lUrbciVJfXVAo0bbTmHylOsuooeWW1f70HLYZ+obA6hoJvDqqjDwI+1mZNMzAdCj0+Ym9pWChizi7pq8omAaUnbswGaoLgDTe/VwCftffH//iVwNqinIXvL226OP2QxF60hvTbFi/e/eZo4Al9ABCTn1b3R6H0VsiaiAm3XajktDaT2cFSRID4rNsryySOeMCWnMCBaC/UtdoLDyDSCF+yfcJ9tBjRfkHiCszU00sZHhNVzBkcG/6QfFUqblDerkdXALPgxxmwDmtLK+z/P7y/XfpD1a/IEqHsfyxw/UTxTdKcWPTTBswUJWWfx4U/q7ilR0vmumaj39PxffYAIJ6fDV6J/y9iLvzqFnG9PzXVjYRqdus8bj0Q/6/5JOpk/9+OpZMWnhKFJYONrGSgy8g6f2rZ9wOJtrYrgy3sEQT9M4ltRLwubH03RRwSIFRjhx+41BDilgXeq/ZKS1BTQ7Ab
 kZIEOaLj
 UHvp2SFZdf47wcD+JbigeGiLFG7mSp6ke+ViT9NqSCqRlJAGbtOIZ4OaE0qF5e71sXnN89Z6pzAapCXFoKDXPamLGe9Gtwnwra2a9wEDE3u55Qz1C+XKMId67szbRKy4JSgR5IKcDXtctKhVRmz8RLT/91F1w3/6iHeEOqoeazTz0G9F4xYZ4ZhU4hp9dKnkL1TzEcGKiPeAgavxoZHlYTPelkndp8SXdIUqu8VokwTwH4QJfgLgJeuEMUcp1tEPUMPmIdW7SzG51oU8mev/fDEECo6nTjaEdT76svtBia0XrfppTxsI2poloCZ0l747Z/+kn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the userspace interface that arms and tunes off-CPU exit teardown,
and the static key that gates it.

Introduce async_mm_teardown_key (static key, default false) and gate the
deferral path in mmput_exit() on it via static_branch_unlikely(); when
off, mmput_exit() runs __mmput() inline. The get_mm_rss() read moves
inside the static_branch_unlikely() block, alongside eligibility and
exit_aio(), so the default (key off) path costs nothing beyond the
branch itself -- no RSS scan for every exiting process on kernels or
boots that never enable the feature. Under CONFIG_SYSCTL, register
three knobs under vm. with register_sysctl_init():

  - async_mm_teardown: write 1/0 to enable/disable. A custom handler
    flips the static key, serialized by a mutex so the key state always
    matches the last value written.
  - async_mm_teardown_thresh_pages: RSS threshold (default ~64MB).
  - async_mm_teardown_max_pending_pages: backpressure cap.

The threshold defaults are set in the initcall outside any CONFIG_SYSCTL
guard, since eligible()/reserve() read them whenever the key is on; only
the toggle variable, its lock, the handler and the table depend on
CONFIG_SYSCTL. With CONFIG_SYSCTL=n there is no path to enable the key,
so the feature stays off and the thresholds are inert.

This patch is still dormant: nothing calls mmput_exit() yet, so flipping
async_mm_teardown on has no observable effect. exit_mm() is routed
through mmput_exit() later in the series; only then does enabling the key
defer teardown. The toggle and gate are introduced here so that, once
routing lands, the feature defaults off and an explicit opt-in is
required.

Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
---
 Documentation/admin-guide/sysctl/vm.rst | 38 +++++++++++
 kernel/fork.c                           | 90 ++++++++++++++++++++-----
 mm/Kconfig                              |  3 +-
 3 files changed, 114 insertions(+), 17 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 5b318d17a..ccda6c75f 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -22,6 +22,9 @@ the writeout of dirty data to disk.
 Currently, these files are in /proc/sys/vm:
 
 - admin_reserve_kbytes
+- async_mm_teardown
+- async_mm_teardown_max_pending_pages
+- async_mm_teardown_thresh_pages
 - compact_memory
 - compaction_proactiveness
 - compact_unevictable_allowed
@@ -108,6 +111,41 @@ On x86_64 this is about 128MB.
 Changing this takes effect whenever an application requests memory.
 
 
+async_mm_teardown
+=================
+
+Available only when CONFIG_ASYNC_MM_TEARDOWN is set. Controls whether the
+address-space teardown (exit_mmap()) of large exiting processes is deferred
+to the mm_reaper kernel thread instead of running on the exiting CPU.
+
+Writing 1 enables deferral, 0 disables it. Disabling makes mmput_exit() tear
+down inline again; it does not drain mms already queued. Defaults to 0.
+
+Deferred teardown consumes CPU in the mm_reaper kernel thread, which runs in
+the root cgroup: the teardown work of a task in a CPU-limited cgroup is not
+charged to that cgroup, similar to kswapd and the oom_reaper. Consider this
+before enabling the feature on systems that rely on strict per-cgroup CPU
+accounting.
+
+
+async_mm_teardown_max_pending_pages
+===================================
+
+Available only when CONFIG_ASYNC_MM_TEARDOWN is set. Backpressure cap, in
+pages, on the total RSS of mms queued for the mm_reaper but not yet torn
+down. An exit that would push the total over this cap tears down
+synchronously instead of queuing. Defaults to totalram_pages() / 4.
+
+
+async_mm_teardown_thresh_pages
+==============================
+
+Available only when CONFIG_ASYNC_MM_TEARDOWN is set. Minimum RSS, in pages,
+for an exiting mm to be eligible for deferral to the mm_reaper. Exiting mms
+below this threshold are always torn down synchronously. Defaults to 64MB
+worth of pages.
+
+
 compact_memory
 ==============
 
diff --git a/kernel/fork.c b/kernel/fork.c
index d45418e66..0976770db 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3414,8 +3414,13 @@ subsys_initcall(init_fork_sysctl);
 static LLIST_HEAD(mm_reaper_list);
 static DECLARE_WAIT_QUEUE_HEAD(mm_reaper_wait);
 static atomic_long_t mm_reaper_pending_pages;
+static DEFINE_STATIC_KEY_FALSE(async_mm_teardown_key);
 static unsigned long sysctl_async_mm_teardown_thresh_pages;
 static unsigned long sysctl_async_mm_teardown_max_pending_pages;
+#ifdef CONFIG_SYSCTL
+static u8 sysctl_async_mm_teardown_enabled;
+static DEFINE_MUTEX(async_mm_teardown_lock);
+#endif
 
 static bool async_mm_teardown_eligible(struct mm_struct *mm, unsigned long rss)
 {
@@ -3485,8 +3490,6 @@ static int mm_reaper(void *unused)
 
 void mmput_exit(struct mm_struct *mm)
 {
-	unsigned long rss;
-
 	might_sleep();
 	/*
 	 * Fully ordered RMW: combined with exit_mm() (or exec_mmap(), the
@@ -3498,27 +3501,80 @@ void mmput_exit(struct mm_struct *mm)
 	if (!atomic_dec_and_test(&mm->mm_users))
 		return;
 
-	rss = get_mm_rss(mm);
+	if (static_branch_unlikely(&async_mm_teardown_key)) {
+		unsigned long rss = get_mm_rss(mm);
 
-	if (async_mm_teardown_eligible(mm, rss)) {
-		/*
-		 * exit_aio() can block indefinitely. Run it here so a stuck
-		 * AIO only hangs this task (same as how it would happen in
-		 * case of synchronous mmput()) instead of stranding every
-		 * teardown queued behind this mm
-		 */
-		exit_aio(mm);
+		if (async_mm_teardown_eligible(mm, rss)) {
+			/*
+			 * exit_aio() can block indefinitely. Run it here so a stuck
+			 * AIO only hangs this task (same as how it would happen in
+			 * case of synchronous mmput()) instead of stranding every
+			 * teardown queued behind this mm
+			 */
+			exit_aio(mm);
 
-		if (async_mm_teardown_reserve(rss)) {
-			mm->async_reap_rss = rss;
-			async_mm_teardown_queue(mm);
-			return;
+			if (async_mm_teardown_reserve(rss)) {
+				mm->async_reap_rss = rss;
+				async_mm_teardown_queue(mm);
+				return;
+			}
 		}
 	}
 
 	__mmput(mm);
 }
 
+#ifdef CONFIG_SYSCTL
+static int async_mm_teardown_enabled_handler(const struct ctl_table *table,
+					     int write, void *buffer,
+					     size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	/*
+	 * Serialize concurrent writers so the static key state always matches
+	 * the last value written to the variable.
+	 */
+	guard(mutex)(&async_mm_teardown_lock);
+
+	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
+	if (ret || !write)
+		return ret;
+
+	if (sysctl_async_mm_teardown_enabled)
+		static_branch_enable(&async_mm_teardown_key);
+	else
+		static_branch_disable(&async_mm_teardown_key);
+	return 0;
+}
+
+static const struct ctl_table async_mm_teardown_table[] = {
+	{
+		.procname	= "async_mm_teardown",
+		.data		= &sysctl_async_mm_teardown_enabled,
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= async_mm_teardown_enabled_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "async_mm_teardown_thresh_pages",
+		.data		= &sysctl_async_mm_teardown_thresh_pages,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "async_mm_teardown_max_pending_pages",
+		.data		= &sysctl_async_mm_teardown_max_pending_pages,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+};
+#endif /* CONFIG_SYSCTL */
+
 static int __init mm_reaper_init(void)
 {
 	struct task_struct *th;
@@ -3533,7 +3589,9 @@ static int __init mm_reaper_init(void)
 	sysctl_async_mm_teardown_thresh_pages      = SZ_64M >> PAGE_SHIFT;
 	sysctl_async_mm_teardown_max_pending_pages = totalram_pages() / 4;  /* TODO: placeholder */
 	wake_up_process(th);
-
+#ifdef CONFIG_SYSCTL
+	register_sysctl_init("vm", async_mm_teardown_table);
+#endif
 	return 0;
 }
 subsys_initcall(mm_reaper_init);
diff --git a/mm/Kconfig b/mm/Kconfig
index 296b16ad4..a9d925406 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1507,7 +1507,8 @@ config ASYNC_MM_TEARDOWN
 	help
 	  Defer the address space teardown (exit_mmap()) of large exiting processes
 	  to a kernel thread instead of running it on the exiting CPU. The feature
-	  is off by default.
+	  is off by default and is enabled at runtime via the vm.async_mm_teardown
+	  sysctl.
 
 	  If unsure, say N.
 
-- 
2.34.1


