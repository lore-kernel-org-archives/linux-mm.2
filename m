Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0048CFF5104
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 15:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4586B00B3; Tue,  7 Apr 2026 11:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C186B00B5; Tue,  7 Apr 2026 11:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1756B00B6; Tue,  7 Apr 2026 11:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF63E6B00B3
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:39:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A756B1408B2
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:39:17 +0000 (UTC)
X-FDA: 84632168754.13.B3870C9
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id AD6CD1A0009
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:39:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eLVGqBBi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775576356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xUraNMpir2RYmF7SdU6Sk5XYdPYUrZgrKlbGzzDcLkM=;
	b=X5IBkAxqQbOlCJRVGmuX29b57/zEUOMBiCjzeydzgLI0Wbo5X/scC4AZIhS7WC8Qs2iiiw
	b/HGrVnqnKFzDb1+qlWZzb0fT5LD42MQMuqudzizzbuWegADrecQc7L7ne8urkbdKQduxk
	b4E9Ap9nRULLWGIE+rlO96ks6lMX2kg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775576356; a=rsa-sha256;
	cv=none;
	b=Np5gN/UYVLLv5m5CK7wdbfcbg+rojU3FA70nyyJjEvirV8aPl+I7KxwYlYDrD921YvD94t
	zUKyQfMemm6xfR7F1O/QU6qyhQRlTIvWghlxqDA8pOTmue7GqXnpiGt/eE51byGqPJlmRZ
	6ClVlHhgr1IkRV9uJywML4dvOawnw1w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eLVGqBBi;
	spf=none (imf19.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=xUraNMpir2RYmF7SdU6Sk5XYdPYUrZgrKlbGzzDcLkM=; b=eLVGqBBiZiy8YRBAvIZxY8wsoP
	d4qMwlS2/8M+zQOm0mQ51yeOSiB9mhw6sOWAiGsAtt7EuGHsyZQgHoR0VRrF9aeeVskP6H7PiSgkI
	PtATK+fi5tJn8Bqt9awUgXGPSavRe1G2jl5khZYe+zwImmTnQX6nfnIN/nijq8FJgPwwCHkOESBGd
	L96VSBnw0JGDRZkPT+8xSoyXLIyLfp+PvsvYCi5e7ZlGh27FZQ3x/Fw+6i47fI97EW6cgPHmHiPjg
	zYhLALrdEQ07e/V5YWA8bkvrqkwqhbGONJ50OxYaPNHcmXNLVv2XpErvJd4t5pPLDtHpqdBQPVo6F
	1KPefvAg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wA8WB-007k9Y-2Y;
	Tue, 07 Apr 2026 15:39:06 +0000
Date: Tue, 7 Apr 2026 08:39:00 -0700
From: Breno Leitao <leitao@debian.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kas@kernel.org, shakeel.butt@linux.dev, usama.arif@linux.dev, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <adUhtrhU7c1TJQww@gmail.com>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <fa089716-1bed-478b-96e3-a2ef5465b52f@kernel.org>
 <a55afddd-8c6b-4a7a-bfd9-5140013c764c@kernel.org>
 <ac5urCFeEB9oyUiD@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac5urCFeEB9oyUiD@gmail.com>
X-Debian-User: leitao
X-Rspamd-Queue-Id: AD6CD1A0009
X-Stat-Signature: kqc3awodzu6bhkt4endyuyw3q6dncern
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775576355-695831
X-HE-Meta: U2FsdGVkX182p+6e24Yu6dYo2XEHdf7QhLwzs22Yw26gpMRUTv66arWWtqp2uDAQKf7q341QLHnfYVVcqRdXyGoOerJPPBIPYisV37g8dyXWjBRkpXjWyYrdP+INCFGUXAHYK1cfeUYeXhTFmJ/932FwsCrnlDYA6iaTagXAwrTMpdJO5Q+Mza+HNLj2NnO8CFQgmP/blVtjZXkiglXPNzdHr1VQvvkPbf+LOcLp/NfMTQkcsRQmftqTFa0Xu76AKKz4PfIodm6F2K8g348vnB3bpSHLkMvizD8Q0s7tjwepLON73qLXjiDytqm2TAPo2DNG1OHsxpBdNWOHUi55Zm+jRkK+VS6m7h9vkqpgPDXxlznuRaHpaOEZ+x4eqbPYNM1ZaI2mcCi9Go33RfTMJMUnQBU/dlmI1G4C/Ex4syT/JMZUK5yuh4MwHKV4VgjyTzse4gg3JguQ/YfIB+wX3i/muxWfF/a+3Pd4fyX3r3ce7GQ7k9iWADJTv9Kkq4svcKagEDcReSLJrha3p/ubpkJGu9uRVFOP1/GnImbhO+JWh/B9WxPNSqvXKSQx+cOMEDzySzsiL688siqnFrwbtgXr15zWSpbP0qYcllDSFO+htI6wgWiX8SmXDqxEGKoSMa9MDrGJYaaML9h5xTg4o51Y7IY7gwVWhGvVSjdqIbRL+b4XixwLIfdi7OPyBz0ZPrgIATyHqs28UUhhTJruJMzcUZaTde0EvhZGoiSW9ElmgLoI7Sip53nuFNWKaEBnPF5P3UlXKhm3FC9oe+p4VkDy+jDpgrBTLBIFzRfrIFO1SUpFtK220Ok0dIbzbNXPT3SLYOuyMnmUtFd9obLC66Xn+3DC1aO4varIRTRh5HnhHOqeehJA1j5FIYFUr9xB9Nr1yMW/uv/ILnrU4WtXU9JOiucxRosXjfx8SVlXtCH3b0ozO2jxVLLV871TxSjtLdBQAXcAcK7q/M9Q+cG
 ccgP2R8X
 N/xkxWiNzR0XUDUmaY0qYNILsAIoqGUR8ewHzUIMI1r3BO04rEUSTaSm9LhF8FHxHqhSqvB9bPmx323FUemB6z8usXJWq++qGOqN/QuBp0TcskUgmitkRhMZPhC3g4GR5A5JQURhxFayqHkI9z7Qdr98dlPiQnqQcfQ25R1Zm4bw7F4bOAUbJ7Bhh4mBoOK//ClBv2aLP8CvU5o+jd/ix9WCJ8O648OaEi9VrQ2zRlJ4XurtLjJU4C+TbxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 06:33:17AM -0700, Breno Leitao wrote:
> > >
> > > Cool!
> > >
> > > I noticed __round_jiffies_relative() exists and the description looks like
> > > it's meant for exactly this use case?
> >
> > On closer look, using round_jiffies_relative() as before your patch
> > means it's calling __round_jiffies_relative(j, raw_smp_processor_id())
> > so that's already doing this spread internally. You're also relying
> > smp_processor_id() so it's not about using a different cpu id.
> >
> > But your patch has better results, why? I still think it's not doing
> > what it intends - I think it makes every cpu have different interval
> > length (up to twice the original length), not skew. Is it that, or that
> > the 3 jiffies skew per cpu used in round_jiffies_common() is
> > insufficient? Or it a bug in its skew implementation?
> >
> > Ideally once that's clear, the findings could be used to improve
> > round_jiffies_common() and hopefully there's nothing here that's vmstat
> > specific.
>
> Excellent observation. I believe there are two key differences:
>
> 1) The interval duration now varies per CPU. Specifically, vmstat_update()
>    is scheduled at sysctl_stat_interval*2 for the highest CPU with my
>    proposed change, rather than a uniform sysctl_stat_interval across
>    all CPUs. (as you raised in the first email)
>
> 2) round_jiffies_relative() applies a 3-jiffies shift per CPU, whereas
>    vmstat_spread_delay distributes all CPUs across the full second
>    interval. (My tests were on HZ=1000)
>
> I'll investigate this further to provide more concrete data.

After further investigation, I can confirm that both factors mentioned
above contribute to the performance improvement.

However, we certainly don't want scenario (1) where the delay varies per
CPU, resulting in the last CPU having vmstat_update() scheduled every
2 seconds instead of 1 second.

I've implemented a patch following Dmitry's suggestion, and the
performance gains are measurable.

Here's my testing methodology:

1) Use ftrace to measure the execution time of refresh_cpu_vm_stats()
   * Applied a custom instrumentation patch [1]

2) Execute stress-ng:
   * stress-ng --vm 72 --vm-bytes 11256M --vm-method all --timeout 60s ; cat /sys/kernel/debug/tracing/trace

3) Parse the output using a Python script [2]

While the results are not as dramatic as initially reported (since
approach (1) was good but incorrect), the improvement is still
substantial:


  ┌─────────┬────────────┬────────────┬───────┐
  │ Metric  │ upstream*  │    fix**   │ Delta │
  ├─────────┼────────────┼────────────┼───────┤
  │ samples │ 36,981     │ 37,267     │ ~same │
  ├─────────┼────────────┼────────────┼───────┤
  │ avg     │ 31,511 ns  │ 21,337 ns  │ -32%  │
  ├─────────┼────────────┼────────────┼───────┤
  │ p50     │ 2,644 ns   │ 2,925 ns   │ ~same │
  ├─────────┼────────────┼────────────┼───────┤
  │ p99     │ 382,083 ns │ 304,357 ns │ -20%  │
  ├─────────┼────────────┼────────────┼───────┤
  │ max     │ 72.6 ms    │ 16.0 ms    │ -78%  │
  └─────────┴────────────┴────────────┴───────┘


* Upstream is based on linux-next commit f3e6330d7fe42  ("Add linux-next specific files for 20260407")
** "fix" contains the patch below:

Link: https://github.com/leitao/linux/commit/ac200164df1bda45ee8504cc3db5bff5b696245e [1]
Link: https://github.com/leitao/linux/commit/baa2ea6ea4c4c2b1df689de6db0a2a6f119e51be [2]


commit 41b7aaa1a51f07fc1f0db0614d140fbca78463d3
Author: Breno Leitao <leitao@debian.org>
Date:   Tue Apr 7 07:56:35 2026 -0700

    mm/vmstat: spread per-cpu vmstat work to reduce zone->lock contention

    vmstat_shepherd() queues all per-cpu vmstat_update work with zero delay,
    and vmstat_update() re-queues itself with round_jiffies_relative(), which
    clusters timers near the same second boundary due to the small per-CPU
    spread in round_jiffies_common(). On many-CPU systems this causes
    thundering-herd contention on zone->lock when multiple CPUs
    simultaneously call refresh_cpu_vm_stats() -> decay_pcp_high() ->
    free_pcppages_bulk().

    Introduce vmstat_spread_delay() to assign each CPU a unique offset
    distributed evenly across sysctl_stat_interval. The shepherd uses this
    when initially queuing per-cpu work, and vmstat_update re-queues with a
    plain sysctl_stat_interval to preserve the spread (round_jiffies_relative
    would snap CPUs back to the same boundary).

    Signed-off-by: Breno Leitao <leitao@debian.org>

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 3704f6ca7a268..8d93eee3b1f75 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2040,6 +2040,22 @@ static int vmstat_refresh(const struct ctl_table *table, int write,
 }
 #endif /* CONFIG_PROC_FS */

+/*
+ * Return a per-cpu initial delay that spreads vmstat_update work evenly
+ * across the stat interval, so that CPUs do not all fire at the same
+ * second boundary.
+ */
+static unsigned long vmstat_spread_delay(int cpu)
+{
+	unsigned long interval = sysctl_stat_interval;
+	unsigned int nr_cpus = num_online_cpus();
+
+	if (nr_cpus <= 1)
+		return 0;
+
+	return (interval * (cpu % nr_cpus)) / nr_cpus;
+}
+
 static void vmstat_update(struct work_struct *w)
 {
 	if (refresh_cpu_vm_stats(true)) {
@@ -2047,10 +2063,13 @@ static void vmstat_update(struct work_struct *w)
 		 * Counters were updated so we expect more updates
 		 * to occur in the future. Keep on running the
 		 * update worker thread.
+		 * Avoid round_jiffies_relative() here -- it would snap
+		 * every CPU back to the same second boundary, undoing
+		 * the initial spread from vmstat_shepherd.
 		 */
 		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
 				this_cpu_ptr(&vmstat_work),
-				round_jiffies_relative(sysctl_stat_interval));
+				sysctl_stat_interval);
 	}
 }

@@ -2148,7 +2167,8 @@ static void vmstat_shepherd(struct work_struct *w)
 				continue;

 			if (!delayed_work_pending(dw) && need_update(cpu))
-				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+				queue_delayed_work_on(cpu, mm_percpu_wq, dw,
+						      vmstat_spread_delay(cpu));
 		}

 		cond_resched();

